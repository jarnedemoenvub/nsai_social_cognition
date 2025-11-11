%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DeepProbLog: Neuro-Symbolic Valence–Arousal Reasoning with Expert Knowledge
% - Neural predicates: face_emotion/2, scene/2
% - Learned gate over up to 5 faces
% - Expert priors: emotion -> (valence, arousal), scene -> (valence, arousal)
% - Fusion: final_valence/3, final_arousal/3
%
% IMPORTANT:
% - All valence/arousal numbers are normalized to [0,1].
% - Your Python training should also normalize ground-truth labels to [0,1]
%   and use loss_function_name="mse".
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nn(face_model, [Face], Emotion, 
    [acceptance, admiration, amazement, anger, annoyance, anticipation, 
    apprehension, boredom, disgust, distraction, ecstasy, fear, grief, 
    interest, joy, loathing, pensiveness, rage, sadness, serenity, surprise, terror, 
    trust, vigilance]):: face_emotion(Face, Emotion).

nn(scene_model, [Image], Context, 
    [agriculture, cold, commercial, cultural, depressing, food, horeca, 
    house_interior, industrial, nature, playful, relaxing, royal, scary, sport, 
    summer, transport, urban, woods, work]):: scene(Image, Context).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Learned gate (mixture over sources)
%% One of 5 faces selected per sample.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% t(_) are learnable parameters. The AD below chooses exactly one head
% per proof (annotated disjunction semantics).
t(_) :: use_source(face_0);
t(_) :: use_source(face_1);
t(_) :: use_source(face_2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Helpers: pick per-face emotion via the neural predicate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

face_emotion_0([Face_0, _, _, _, _], Emotion) :- face_emotion(Face_0, Emotion).
face_emotion_1([_, Face_1, _, _, _], Emotion) :- face_emotion(Face_1, Emotion).
face_emotion_2([_, _, Face_2, _, _], Emotion) :- face_emotion(Face_2, Emotion).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Final categorical emotion = mixture-of-experts over faces
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

final_emo(Faces, _Image, Emotion) :-
    use_source(face_0),
    face_emotion_0(Faces, Emotion).

final_emo(Faces, _Image, Emotion) :-
    use_source(face_1),
    face_emotion_1(Faces, Emotion).

final_emo(Faces, _Image, Emotion) :-
    use_source(face_2),
    face_emotion_2(Faces, Emotion).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Expert knowledge
%% All values in [0,1]. Adjust if you have better priors.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ----------------------------
% Emotion -> Valence prior
% ----------------------------
emo_valence(acceptance,   0.75).
emo_valence(admiration,   0.80).
emo_valence(amazement,    0.80).
emo_valence(anger,        0.25).
emo_valence(annoyance,    0.40).
emo_valence(anticipation, 0.65).
emo_valence(apprehension, 0.35).
emo_valence(boredom,      0.30).
emo_valence(disgust,      0.20).
emo_valence(distraction,  0.50).
emo_valence(ecstasy,      0.95).
emo_valence(fear,         0.10).
emo_valence(grief,        0.15).
emo_valence(interest,     0.70).
emo_valence(joy,          0.90).
emo_valence(loathing,     0.20).
emo_valence(pensiveness,  0.45).
emo_valence(rage,         0.20).
emo_valence(sadness,      0.15).
emo_valence(serenity,     0.85).
emo_valence(surprise,     0.70).
emo_valence(terror,       0.05).
emo_valence(trust,        0.80).
emo_valence(vigilance,    0.55). % often task-focused/neutral+

% ----------------------------
% Emotion -> Arousal prior
% ----------------------------
emo_arousal(acceptance,   0.50).
emo_arousal(admiration,   0.55).
emo_arousal(amazement,    0.90).
emo_arousal(anger,        0.85).
emo_arousal(annoyance,    0.60).
emo_arousal(anticipation, 0.70).
emo_arousal(apprehension, 0.65).
emo_arousal(boredom,      0.20).
emo_arousal(disgust,      0.45).
emo_arousal(distraction,  0.50).
emo_arousal(ecstasy,      0.95).
emo_arousal(fear,         0.90).
emo_arousal(grief,        0.35).
emo_arousal(interest,     0.60).
emo_arousal(joy,          0.70).
emo_arousal(loathing,     0.55).
emo_arousal(pensiveness,  0.30).
emo_arousal(rage,         0.95).
emo_arousal(sadness,      0.30).
emo_arousal(serenity,     0.30).
emo_arousal(surprise,     0.80).
emo_arousal(terror,       0.98).
emo_arousal(trust,        0.50).
emo_arousal(vigilance,    0.80).

% ----------------------------
% Scene -> Valence prior
% ----------------------------
scene_valence(agriculture,     0.70).
scene_valence(cold,            0.30).
scene_valence(commercial,      0.55).
scene_valence(cultural,        0.70).
scene_valence(depressing,      0.10).
scene_valence(food,            0.75).
scene_valence(horeca,          0.70).  % hospitality
scene_valence(house_interior,  0.65).
scene_valence(industrial,      0.35).
scene_valence(nature,          0.80).
scene_valence(playful,         0.90).
scene_valence(relaxing,        0.85).
scene_valence(royal,           0.70).
scene_valence(scary,           0.15).
scene_valence(sport,           0.70).
scene_valence(summer,          0.80).
scene_valence(transport,       0.50).
scene_valence(urban,           0.55).
scene_valence(woods,           0.75).
scene_valence(work,            0.50).

% ----------------------------
% Scene -> Arousal prior
% ----------------------------
scene_arousal(agriculture,     0.45).
scene_arousal(cold,            0.25).
scene_arousal(commercial,      0.55).
scene_arousal(cultural,        0.50).
scene_arousal(depressing,      0.20).
scene_arousal(food,            0.60).
scene_arousal(horeca,          0.60).
scene_arousal(house_interior,  0.40).
scene_arousal(industrial,      0.55).
scene_arousal(nature,          0.40).
scene_arousal(playful,         0.80).
scene_arousal(relaxing,        0.30).
scene_arousal(royal,           0.55).
scene_arousal(scary,           0.90).
scene_arousal(sport,           0.85).
scene_arousal(summer,          0.55).
scene_arousal(transport,       0.60).
scene_arousal(urban,           0.65).
scene_arousal(woods,           0.45).
scene_arousal(work,            0.60).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fusion rules
%% Combine face-derived emotion with scene context to produce final V/A.
%% We use fixed weights (0.7 emotion / 0.3 scene). You can tune these.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

emo_weight(0.5).
scene_weight(0.5).

final_valence(Faces, Image, V) :-
    final_emo(Faces, Image, Emotion),
    scene(Image, Scene),
    emo_valence(Emotion, EV),
    scene_valence(Scene, SV),
    emo_weight(W1), scene_weight(W2),
    V is EV * W1 + SV * W2.

final_arousal(Faces, Image, A) :-
    final_emo(Faces, Image, Emotion),
    scene(Image, Scene),
    emo_arousal(Emotion, EA),
    scene_arousal(Scene, SA),
    emo_weight(W1), scene_weight(W2),
    A is EA * W1 + SA * W2.
