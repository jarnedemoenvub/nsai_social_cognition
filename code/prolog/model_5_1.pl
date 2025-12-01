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

% ======================================================
%   Emotion Prototypes (from VA centroids)
% ======================================================

emotion_bin(anger,         5, 17).
emotion_bin(fear,          4, 18).
emotion_bin(disgust,       9, 10).
emotion_bin(sadness,       6, 12).
emotion_bin(joy,          17, 10).
emotion_bin(trust,        18,  9).
emotion_bin(anticipation, 16, 12).
emotion_bin(surprise,     10, 16).

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

    % 3. Deterministic VA → Emotion
    emotion_bin(Emotion, CV, CA).
