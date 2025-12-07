nn(face_val_model, [FaceFeat], VBin,
   [0,1,2,3,4,5,6]) ::
    face_val_bin(FaceFeat, VBin).

nn(face_aro_model, [FaceFeat], ABin,
   [0,1,2,3,4,5,6]) ::
    face_aro_bin(FaceFeat, ABin).

nn(scene_val_model, [SceneFeat], VBin,
   [0,1,2,3,4,5,6]) ::
    scene_val_bin(SceneFeat, VBin).

nn(scene_aro_model, [SceneFeat], ABin,
   [0,1,2,3,4,5,6]) ::
    scene_aro_bin(SceneFeat, ABin).

nn(va2emotion_model, [ValBin, AroBin], Emotion,
    [anger, anticipation, disgust, fear, joy, sadness, surprise, trust]) ::
    closest_emotion(ValBin, AroBin, Emotion).

small_diff(F, S)  :- abs(F - S) =< 1.
medium_diff(F, S) :- D is abs(F - S), D >= 2, D =< 3.
large_diff(F, S)  :- abs(F - S) >= 4.

% Valence combination
t(_) :: use_face_small_val(FV, SV) ;
t(_) :: use_scene_small_val(FV, SV) :-
    small_diff(FV, SV).

t(_) :: use_face_big_val(FV, SV) ;
t(_) :: use_scene_big_val(FV, SV) :-
    large_diff(FV, SV).

combine_val_bin(FV, SV, FV) :-
    use_face_small_val(FV, SV).

combine_val_bin(FV, SV, SV) :-
    use_scene_small_val(FV, SV).

combine_val_bin(F, S, M) :-
    medium_diff(F, S),
    M is (2*F + S) // 3.

combine_val_bin(FV, SV, FV) :-
    use_face_big_val(FV, SV).

combine_val_bin(FV, SV, SV) :-
    use_scene_big_val(FV, SV).

% Arousal combination
t(_) :: use_face_small_aro(FA, SA) ;
t(_) :: use_scene_small_aro(FA, SA) :-
    small_diff(FA, SA).

t(_) :: use_face_big_aro(FA, SA) ;
t(_) :: use_scene_big_aro(FA, SA) :-
    large_diff(FA, SA).

combine_aro_bin(FA, SA, FA) :-
    use_face_small_aro(FA, SA).

combine_aro_bin(FA, SA, SA) :-
    use_scene_small_aro(FA, SA).

combine_aro_bin(F, S, M) :-
    medium_diff(F, S),
    M is (2*F + S) // 3.

combine_aro_bin(FV, SV, FV) :-
    use_face_big_aro(FV, SV).

combine_aro_bin(FV, SV, SV) :-
    use_scene_big_aro(FV, SV).

final_emotion(FaceFeat, SceneFeat, Emotion) :-

    % Neural predictions
    face_val_bin(FaceFeat, FV),
    face_aro_bin(FaceFeat, FA),
    scene_val_bin(SceneFeat, SV),
    scene_aro_bin(SceneFeat, SA),

    % Symbolic combination
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

    % Neural predictions
    face_val_bin(FaceFeat, FV),
    scene_val_bin(SceneFeat, SV),

    % Symbolic combination
    combine_val_bin(FV, SV, CV).

test_combine_aro_bin(FaceFeat, SceneFeat, CA) :-

    % Neural predictions
    face_aro_bin(FaceFeat, FA),
    scene_aro_bin(SceneFeat, SA),

    % Symbolic combination
    combine_aro_bin(FA, SA, CA).

test_closest_emotion(ValBin, AroBin, Emotion) :-
    closest_emotion(ValBin, AroBin, Emotion).