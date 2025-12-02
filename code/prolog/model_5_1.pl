% ======================================================
%  Neural Predictors: VA Bins (0..20)
% ======================================================

nn(face_val_model, [FaceFeat], VBin,
   [0,1,2,3,4,5,6,7,8,9,
    10,11,12,13,14,15,16,17,18,19,20]) ::
    face_val_bin(FaceFeat, VBin).

nn(face_aro_model, [FaceFeat], ABin,
   [0,1,2,3,4,5,6,7,8,9,
    10,11,12,13,14,15,16,17,18,19,20]) ::
    face_aro_bin(FaceFeat, ABin).

nn(scene_val_model, [SceneFeat], VBin,
   [0,1,2,3,4,5,6,7,8,9,
    10,11,12,13,14,15,16,17,18,19,20]) ::
    scene_val_bin(SceneFeat, VBin).

nn(scene_aro_model, [SceneFeat], ABin,
   [0,1,2,3,4,5,6,7,8,9,
    10,11,12,13,14,15,16,17,18,19,20]) ::
    scene_aro_bin(SceneFeat, ABin).

% ======================================================
%   Symbolic Difference Rules for VA Combination
% ======================================================

small_diff(F, S)  :- abs(F - S) =< 2.
medium_diff(F, S) :- D is abs(F - S), D >= 3, D =< 6.
large_diff(F, S)  :- abs(F - S) >= 7.

% Valence combination
combine_val_bin(F, S, M) :-
    small_diff(F, S),
    M is (F + S) // 2.

combine_val_bin(F, S, M) :-
    medium_diff(F, S),
    M is (2*F + S) // 3.

combine_val_bin(F, S, F) :-
    large_diff(F, S).

% Arousal combination
combine_aro_bin(F, S, M) :-
    small_diff(F, S),
    M is (F + S) // 2.

combine_aro_bin(F, S, M) :-
    medium_diff(F, S),
    M is (2*F + S) // 3.

combine_aro_bin(F, S, F) :-
    large_diff(F, S).

eucl_distance(CV, CA, EV, EA, D) :-
    DX is CV - EV,
    DY is CA - EA,
    D is sqrt(DX*DX + DY*DY).

% ======================================================
%   Emotion Prototypes (from VA centroids)
% ======================================================

emotion_bin(0, 5, 12). % anger
emotion_bin(1, 12, 8). % anticipation
emotion_bin(2, 7, 8). % disgust
emotion_bin(3, 6, 11). % fear
emotion_bin(4, 16, 10). % joy
emotion_bin(5, 5, 11). % sadness
emotion_bin(6, 12, 9). % surprise
emotion_bin(7, 15, 9). % trust

% ======================================================
%   Final Emotion Derivation
% ======================================================

final_emotion(FaceFeat, SceneFeat, Emotion) :-

    % 1. Neural predictions
    face_val_bin(FaceFeat, FV),
    face_aro_bin(FaceFeat, FA),
    scene_val_bin(SceneFeat, SV),
    scene_aro_bin(SceneFeat, SA),

    % 2. Symbolic combination
    combine_val_bin(FV, SV, CV),
    combine_aro_bin(FA, SA, CA),

    closest_emotion(CV, CA, Emotion).

test_face_val_bin(FaceFeat, VBin) :-
    face_val_bin(FaceFeat, VBin).

test_face_aro_bin(FaceFeat, ABin) :-
    face_aro_bin(FaceFeat, ABin).

test_scene_val_bin(SceneFeat, VBin) :-
    scene_val_bin(SceneFeat, VBin).

test_scene_aro_bin(SceneFeat, ABin) :-
    scene_aro_bin(SceneFeat, ABin).

test_combine_val_bin(FaceFeat, SceneFeat, CV) :-

    % 1. Neural predictions
    face_val_bin(FaceFeat, FV),
    scene_val_bin(SceneFeat, SV),

    % 2. Symbolic combination
    combine_val_bin(FV, SV, CV).

test_combine_aro_bin(FaceFeat, SceneFeat, CA) :-

    % 1. Neural predictions
    face_aro_bin(FaceFeat, FA),
    scene_aro_bin(SceneFeat, SA),

    % 2. Symbolic combination
    combine_aro_bin(FA, SA, CA).