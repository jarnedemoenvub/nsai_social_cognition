% Neural declarations
nn(face_model, [Tensor], FaceLogits).        % returns 18 logits (3 faces x 6 emotions)
nn(scene_model, [Tensor], Places365Logits).  % returns 365 logits
nn(scene_reduction, [Places365Logits], Places13Logits). % returns 13 logits

face_logits(Tensor, Logits) :- nn(face_model, [Tensor], Logits).
scene365_logits(Tensor, Logits) :- nn(scene_model, [Tensor], Logits).
scene13_logits(Tensor, Logits) :- nn(scene_model, [Tensor], L365), nn(scene_reduction, [L365], Logits).

% --- Enumerations / mappings -------------------------------------------------

% The six basic emotions (indexing 0..5). Ensure same order as your face network.
emotion(0, anger).
emotion(1, disgust).
emotion(2, fear).
emotion(3, joy).
emotion(4, sadness).
emotion(5, surprise).

% If you need reverse lookup: emotion_idx(Name,Idx).
emotion_idx(Name, Idx) :- emotion(Idx, Name).

% Define how the 18 face logits map to the 3 faces x 6 emotions.
% We use face_slice(FaceLogits, FaceIndex, EmIndex, LogitValue) semantics
% but in practice we will use softmax/2 to get probabilities for the 18-dim vector,
% then aggregate per-emotion across faces.

% --- Helpers assumed to be available in deepproblog --------------------------
% softmax(Tensor, ProbsList)   : converts a neural tensor into a list of probabilities (sum==1).
% nth0(Index, List, Value)     : standard SWI-Prolog list indexing (0-based).
% sum_list(List, Sum)          : builtin.
% maplist/3 etc. are available.
% If softmax/2 is not present, provide a small python wrapper that takes the raw logits
% and returns the normalized probabilities (registerable in deepproblog).

% --- Face probability for basic emotion (aggregate over faces) -------------
% face_emotion_prob(TensorFace, EmotionIdx, Prob).
face_emotion_prob(TensorFace, EmIdx, Prob) :-
    nn(face_model, [TensorFace], FaceLogits),     % FaceLogits: 18-dim logits
    softmax(FaceLogits, FaceProbs),               % FaceProbs: list length 18 summing to 1
    % gather per-face probabilities for this emotion (faces 0,1,2)
    EmPos0 is EmIdx,                              % position in 1st face block
    EmPos1 is 6 + EmIdx,
    EmPos2 is 12 + EmIdx,
    nth0(EmPos0, FaceProbs, P0),
    nth0(EmPos1, FaceProbs, P1),
    nth0(EmPos2, FaceProbs, P2),
    % combine faces: average (other strategies possible: max, weighted, etc.)
    Prob is (P0 + P1 + P2) / 3.

% A convenience wrapper returning a prob vector for all 6 emotions:
face_emotion_vector(TensorFace, [P0,P1,P2,P3,P4,P5]) :-
    findall(P, (between(0,5,Idx), face_emotion_prob(TensorFace,Idx,P)), [P0,P1,P2,P3,P4,P5]).

% --- Scene-based priors: map scene tensor -> 13 places -> per-emotion prior ----
% scene_place_prob(TensorScene, PlaceIdx, ProbPlace)  : probability for place idx (0..12)
scene_place_prob(TensorScene, PlaceIdx, ProbPlace) :-
    nn(scene_model, [TensorScene], Places365Logits),
    nn(scene_reduction, [Places365Logits], Places13Logits),  % 13-dim logits
    softmax(Places13Logits, PlaceProbs),
    nth0(PlaceIdx, PlaceProbs, ProbPlace).

% Define a manual prior mapping from place-category (0..12) to how it biases emotions.
% Each place j has a weight vector W_j over the 6 emotions (length 6). We encode as facts.
% Example small set (you should fill/learn better weights). Values are non-negative and will be normalized.
place_emotion_weights(0, [1,0.5,0.2,1.5,0.3,0.4]).  % place 0 biases joy etc.
place_emotion_weights(1, [0.8,1.2,0.9,0.6,1.0,0.3]). % place 1 biases disgust/anger...
% ... add facts for all 13 places (indexes 0..12)
% To keep the file short put placeholders: if missing default to uniform
place_emotion_weights(Idx, [1,1,1,1,1,1]) :- Idx < 13, \+ place_emotion_weights(Idx, _).

% Convert place distribution to an emotion prior distribution
scene_emotion_prior(TensorScene, EmotionIdx, Prior) :-
    % Collect place probs and their weights
    findall(PlaceProb-Weights,
            ( between(0,12,PlaceIdx),
              scene_place_prob(TensorScene, PlaceIdx, PlaceProb),
              place_emotion_weights(PlaceIdx, Weights)
            ),
            PlacePairs),
    % For each place get the weight for emotion EmotionIdx and multiply by place prob
    findall(Contrib,
            ( member(PlaceProb-Weights, PlacePairs),
              nth0(EmotionIdx, Weights, W),
              Contrib is PlaceProb * W
            ),
            Contributions),
    sum_list(Contributions, S),
    % Normalize across emotions outside (caller) — here we return a raw score.
    Prior is S.

% Provide vector version
scene_emotion_vector(TensorScene, [S0,S1,S2,S3,S4,S5]) :-
    findall(S, (between(0,5,Idx), scene_emotion_prior(TensorScene,Idx,S)), [S0,S1,S2,S3,S4,S5]).

% --- Combine face evidence and scene prior to produce final emotion distribution ---
% We combine by multiplying (Bayesian style) and renormalizing.
combine_face_scene(FaceTensor, SceneTensor, [R0,R1,R2,R3,R4,R5]) :-
    face_emotion_vector(FaceTensor, FaceVec),
    scene_emotion_vector(SceneTensor, SceneVec),
    % elementwise multiply
    maplist(mult, FaceVec, SceneVec, Prod),
    sum_list(Prod, Z),
    ( Z =:= 0 -> % fallback to face-only if scene gives zero mass
        Prod = FaceVec,
        Z2 is sum_list(Prod),
        ( Z2 =:= 0 -> % fallback uniform
            R0=0.1666666667, R1=0.1666666667, R2=0.1666666667, R3=0.1666666667, R4=0.1666666667, R5=0.1666666667
        ;
            normalize_list(Prod, Z2, [R0,R1,R2,R3,R4,R5])
        )
    ;
        normalize_list(Prod, Z, [R0,R1,R2,R3,R4,R5])
    ).

% arithmetic helpers
mult(A,B,C) :- C is A*B.

normalize_list([], _, []).
normalize_list([H|T], Z, [HN|TN]) :-
    HN is H / Z,
    normalize_list(T, Z, TN).

% final_emo(FaceTensor, SceneTensor, EmotionIdx) succeeds probabilistically by grounding the combined distribution
% We turn the combined distribution into an annotated disjunction over the 6 emotions.
final_emo(FaceTensor, SceneTensor, E) :-
    combine_face_scene(FaceTensor, SceneTensor, Dist),
    Dist = [P0,P1,P2,P3,P4,P5],
    % create AD: P0::class(0); P1::class(1); ...
    % Use helper predicate that emits the AD and yields E as the chosen index
    choice_from_distribution([P0,P1,P2,P3,P4,P5], E).

% Helper that materializes an annotated disjunction given a list of probabilities.
% choice_from_distribution(ProbList, Index) - uses built-in deepproblog support for probabilistic choices.
choice_from_distribution([P0,P1,P2,P3,P4,P5], 0) :- P0::true.
choice_from_distribution([P0,P1,P2,P3,P4,P5], 1) :- P1::true.
choice_from_distribution([P0,P1,P2,P3,P4,P5], 2) :- P2::true.
choice_from_distribution([P0,P1,P2,P3,P4,P5], 3) :- P3::true.
choice_from_distribution([P0,P1,P2,P3,P4,P5], 4) :- P4::true.
choice_from_distribution([P0,P1,P2,P3,P4,P5], 5) :- P5::true.

% If you also want a predicate that returns the probability vector (for evaluation)
final_emo_probs(FaceTensor, SceneTensor, [P0,P1,P2,P3,P4,P5]) :-
    combine_face_scene(FaceTensor, SceneTensor, [P0,P1,P2,P3,P4,P5]).

% End of model3.pl