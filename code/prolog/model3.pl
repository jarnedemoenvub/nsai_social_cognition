nn(face_model, [Face], Emotion, [angry, disgust, fear, happy, sad, surprise]):- face_emotion(Face, Emotion).

nn(scene_model, [Image], Scene, [aquatic_environment,cold_environment,cultural_space,
                                indoor_commercial, indoor_institutional, indoor_residential,
                                industrial_facility, natural_landscape, religious_or_historical_site,
                                rural_or_recreational_area, sports_and_entertainment, transport_infrastructure,
                                urban_outdoor]):- scene(Image, Scene)

group_emotion(Face1, Face2, Face3, E):-
    face_emotion(Face1, E1),
    face_emotion(Face2, E2),
    face_emotion(Face3, E3).
