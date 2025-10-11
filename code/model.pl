% ============================================================
% NEUROSYMBOLIC EMOTION FUSION MODEL (WITH FINDINGEMO OUTPUT)
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


% ============================
% 2. SYMBOLIC KNOWLEDGE BASE
% ============================

% Base emotion polarity (used by mapping)
emotion_group(0, negative).  % angry
emotion_group(1, negative).  % disgust
emotion_group(2, negative).  % fear
emotion_group(3, positive).  % happy
emotion_group(4, negative).  % sad
emotion_group(5, positive).  % surprise
emotion_group(6, neutral).   % neutral


% ============================
% 3. TRAINABLE / FIXED WEIGHTS
% ============================

0.8::w_face(0).
0.2::w_face(1).
0.05::w_face(2).
0.05::w_face(3).
0.05::w_face(4).
0.5::w_scene.


% ============================
% 4. FACE FEATURES
% ============================

flat_index(FaceIdx, EmoIdx, Flat) :- Flat is FaceIdx * 7 + EmoIdx.

face_emotion_prob(X, FaceIdx, EmoIdx) :-
    between(0, 4, FaceIdx),
    between(0, 6, EmoIdx),
    flat_index(FaceIdx, EmoIdx, Flat),
    face_flat(X, Flat).


% ============================
% 5. FUSION: BASE EMOTION PROBABILITY
% ============================

% Contribution from each face
final_emotion(FaceImg, SceneImg, EmoIdx) :-
    w_face(FIdx),
    face_emotion_prob(FaceImg, FIdx, EmoIdx).

% Contribution from the scene via neural adapter
final_emotion(FaceImg, SceneImg, EmoIdx) :-
    w_scene,
    scene_raw_vec(SceneImg, Vec),
    scene_emotion(Vec, EmoIdx).


% ============================
% 6. MAPPING TO FINDINGEMO SPACE (0–23)
% ============================

% Angry → anger-related emotions
0.8::mapped_emotion(0, 4).   % Anger
0.1::mapped_emotion(0, 13).  % Rage
0.1::mapped_emotion(0, 14).  % Annoyance

% Disgust → loathing/disgust
0.7::mapped_emotion(1, 23).  % Disgust
0.3::mapped_emotion(1, 21).  % Loathing

% Fear → fear/apprehension/terror/vigilance
0.4::mapped_emotion(2, 10).  % Fear
0.2::mapped_emotion(2, 2).   % Apprehension
0.2::mapped_emotion(2, 16).  % Terror
0.2::mapped_emotion(2, 11).  % Vigilance

% Happy → joy/ecstasy/serenity/admiration/acceptance
0.4::mapped_emotion(3, 5).   % Joy
0.2::mapped_emotion(3, 9).   % Ecstasy
0.2::mapped_emotion(3, 7).   % Serenity
0.1::mapped_emotion(3, 20).  % Admiration
0.1::mapped_emotion(3, 15).  % Acceptance

% Sad → sadness/grief/pensiveness
0.5::mapped_emotion(4, 12).  % Sadness
0.3::mapped_emotion(4, 6).   % Grief
0.2::mapped_emotion(4, 19).  % Pensiveness

% Surprise → surprise/amaze/distraction
0.5::mapped_emotion(5, 18).  % Surprise
0.3::mapped_emotion(5, 17).  % Amazement
0.2::mapped_emotion(5, 22).  % Distraction

% Neutral → boredom/serenity/acceptance
0.4::mapped_emotion(6, 8).   % Boredom
0.3::mapped_emotion(6, 7).   % Serenity
0.3::mapped_emotion(6, 15).  % Acceptance

% Final output in FindingEmo space
final_findingemo(Faces, Scene, FEIdx) :-
    final_emotion(Faces, Scene, BaseIdx),
    mapped_emotion(BaseIdx, FEIdx).


% ============================
% 7. EXPLAINABILITY QUERIES
% ============================

%   ?- query(final_findingemo(Faces, Scene, E)).
%   ?- query(w_face(0)).
%   ?- query(w_scene).
%
%   face0: 0.42, face1: 0.20, scene: 0.10 ...
% ============================================================
% END OF MODEL
% ============================================================
