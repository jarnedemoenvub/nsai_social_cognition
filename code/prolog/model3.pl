nn(face_model, [Face], Emotion, [anger, disgust, fear, joy, sadness, surprise]):: face_emotion(Face, Emotion).

nn(scene_model, [Image], Scene, [natural_landscape,
 industrial_facility,
 urban_outdoor,
 indoor_residential,
 religious_or_historical_site,
 sports_and_entertainment,
 cultural_space,
 transport_infrastructure,
 aquatic_environment,
 cold_environment,
 indoor_institutional,
 rural_or_recreational_area,
 indoor_commercial]):: scene(Image, Scene).

t(0.2):: context_to_emotion(natural_landscape, joy).


face_emotion_0([Face_0, _, _], Emotion):-
    face_emotion(Face_0, Emotion).

face_emotion_1([_, Face_1, _], Emotion):-
    face_emotion(Face_1, Emotion).

face_emotion_2([_, _, Face_2], Emotion):-
    face_emotion(Face_2, Emotion).

scene_context(Scene, Context):-
    scene(Scene, Context).
