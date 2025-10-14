% ============================================================
% NEUROSYMBOLIC EMOTION FUSION MODEL (WITH CORRECT FINDINGEMO MAPPINGS)
% ============================================================

% ============================
% 1. NEURAL COMPONENTS
% ============================

nn(multi_face_net, [X], Y,
    [0,1,2,3,4,5,6,
     7,8,9,10,11,12,13,
     14,15,16,17,18,19,20]) :: face_flat(X,Y).

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
    (var(EmoIdx) -> between(0, 6, EmoIdx) ; true),
    flat_index(FaceIdx, EmoIdx, Flat),
    face_flat(X, Flat).

% ============================
% 3. WEIGHTED FUSION
% ============================

t(_)::use_face_0.
t(_)::use_face_1.
t(_)::use_face_2.
t(_)::use_scene.

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
    use_scene,
    scene_raw_vec(SceneImg, Vec),
    scene_emotion(Vec, EmoIdx).

% ============================
% 7. FINAL PREDICTION
% ============================

final_findingemo(Faces, Scene, FEIdx) :-
    base_emotion(Faces, Scene, FEIdx).