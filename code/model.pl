% ============================================================
% NEUROSYMBOLIC EMOTION FUSION MODEL (WITH CORRECT FINDINGEMO MAPPINGS)
% ============================================================

% ============================
% 1. NEURAL COMPONENTS
% ============================

nn(multi_face_net, [X], Y,
    [0,1,2,3,4,5,6,
     7,8,9,10,11,12,13,
     14,15,16,17,18,19,20,
     21,22,23,24,25,26,27,
     28,29,30,31,32,33,34]) :: face_flat(X,Y).

% Scene image → deterministic 512-D feature vector
nn(scene_net, [X], Vec) :: scene_raw_vec(X, Vec).

% Scene feature vector → 7 base emotions
nn(scene2emo_net, [Vec], E, [0,1,2,3,4,5,6]) :: scene_emotion(Vec,E).

% Test predicates
multi_face_test(FaceImg, FaceFlat):-
    face_flat(FaceImg, FaceFlat).

scene_test(SceneImg, Emo):-
    scene_raw_vec(SceneImg, Vec),
    scene_emotion(Vec, Emo).

% ============================
% 2. FACE PROCESSING
% ============================

flat_index(FaceIdx, EmoIdx, Flat) :- Flat is FaceIdx * 7 + EmoIdx.

face_emotion_prob(X, FaceIdx, EmoIdx) :-
    between(0, 4, FaceIdx),
    between(0, 6, EmoIdx),
    flat_index(FaceIdx, EmoIdx, Flat),
    face_flat(X, Flat).

% ============================
% 3. WEIGHTED FUSION
% ============================

0.4::use_face_0.
0.2::use_face_1.
0.1::use_face_2.
0.05::use_face_3.
0.05::use_face_4.
0.2::use_scene.

% ============================
% 4. BASE EMOTION PREDICTION
% ============================

base_emotion(FaceImg, SceneImg, EmoIdx) :-
    use_face_0, face_emotion_prob(FaceImg, 0, EmoIdx).

base_emotion(FaceImg, SceneImg, EmoIdx) :-
    use_face_1, face_emotion_prob(FaceImg, 1, EmoIdx).

base_emotion(FaceImg, SceneImg, EmoIdx) :-
    use_face_2, face_emotion_prob(FaceImg, 2, EmoIdx).

base_emotion(FaceImg, SceneImg, EmoIdx) :-
    use_face_3, face_emotion_prob(FaceImg, 3, EmoIdx).

base_emotion(FaceImg, SceneImg, EmoIdx) :-
    use_face_4, face_emotion_prob(FaceImg, 4, EmoIdx).

base_emotion(FaceImg, SceneImg, EmoIdx) :-
    use_scene,
    scene_raw_vec(SceneImg, Vec),
    scene_emotion(Vec, EmoIdx).

% ============================
% 5. MAPPING TO FINDINGEMO EMOTIONS (CORRECTED INDICES)
% ============================

% Angry (0) → anger-related emotions
0.6::mapped_emotion(0, 4).   % Anger
0.2::mapped_emotion(0, 13).  % Rage
0.2::mapped_emotion(0, 14).  % Annoyance

% Disgust (1) → disgust-related emotions
0.7::mapped_emotion(1, 23).  % Disgust
0.3::mapped_emotion(1, 21).  % Loathing

% Fear (2) → fear-related emotions
0.4::mapped_emotion(2, 10).  % Fear
0.2::mapped_emotion(2, 2).   % Apprehension
0.2::mapped_emotion(2, 16).  % Terror
0.2::mapped_emotion(2, 11).  % Vigilance

% Happy (3) → joy/positive emotions
0.3::mapped_emotion(3, 5).   % Joy
0.2::mapped_emotion(3, 9).   % Ecstasy
0.15::mapped_emotion(3, 7).   % Serenity
0.1::mapped_emotion(3, 20). % Admiration
0.1::mapped_emotion(3, 15). % Acceptance
0.1::mapped_emotion(3, 0).   % Trust from Happy
0.05::mapped_emotion(3, 3).  % Anticipation from Happy


% Sad (4) → sadness-related emotions
0.4::mapped_emotion(4, 12).  % Sadness
0.3::mapped_emotion(4, 6).   % Grief
0.3::mapped_emotion(4, 19).  % Pensiveness

% Surprise (5) → surprise-related emotions
0.4::mapped_emotion(5, 18).  % Surprise
0.25::mapped_emotion(5, 17).  % Amazement
0.25::mapped_emotion(5, 22).  % Distraction
0.1::mapped_emotion(5, 3).   % Anticipation from Surprise


% Neutral (6) → neutral/contemplative emotions
0.3::mapped_emotion(6, 8).   % Boredom
0.25::mapped_emotion(6, 15). % Acceptance
0.2::mapped_emotion(6, 7).  % Serenity
0.2::mapped_emotion(6, 1).   % Interest
0.05::mapped_emotion(6, 0).  % Trust from Neutral


% ============================
% 7. FINAL PREDICTION
% ============================

final_findingemo(Faces, Scene, FEIdx) :-
    base_emotion(Faces, Scene, BaseIdx),
    mapped_emotion(BaseIdx, FEIdx).

% ============================
% 8. EXPLAINABILITY QUERIES
% ============================

%   ?- query(final_findingemo(Faces, Scene, E)).
%   ?- query(use_face_0).
%   ?- query(use_scene).
% ============================================================
% END OF MODEL
% ============================================================