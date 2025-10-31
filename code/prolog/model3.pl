nn(face_model, [Face], Emotion, [angry, disgust, fear, happy, sad, surprise]):: face_emotion(Face, Emotion).

nn(scene_model, [Image], Scene, [aquatic_environment,cold_environment,cultural_space,
                                indoor_commercial, indoor_institutional, indoor_residential,
                                industrial_facility, natural_landscape, religious_or_historical_site,
                                rural_or_recreational_area, sports_and_entertainment, transport_infrastructure,
                                urban_outdoor]):: scene(Image, Scene).

face_emotion_1([Face_1, _, _], Emotion):-
    face_emotion(Face_1, Emotion).

face_emotion_2([_, Face_2, _], Emotion):-
    face_emotion(Face_2, Emotion).

face_emotion_3([_, _, Face_3], Emotion):-
    face_emotion(Face_3, Emotion).

final_emo(Faces, Scene, E):-
    face_emotion_1(Faces, E).
    % face_emotion_2(Faces, Emo_2),
    % face_emotion_3(Faces, Emo_3),
    % scene(Scene, Context),
    % context_to_emotion(Context, Context_Emo),
    % aggregate_emotion(Emo_1, Emo_2, Emo_3, Context_Emo, E).
