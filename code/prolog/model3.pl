nn(face_model, [Face], Emotion, [anger, disgust, fear, joy, sadness, surprise]):: face_emotion(Face, Emotion).

nn(scene_model, [Image], Scene, 
    ['aquatic_environment', 'cold_environment', 'cultural_space', 'indoor_commercial', 
    'indoor_institutional', 'indoor_residential', 'industrial_facility', 'natural_landscape', 
    'religious_or_historical_site', 'rural_or_recreational_area', 'sports_and_entertainment', 
    'transport_infrastructure', 'urban_outdoor']):: scene(Image, Scene).

t(0.2):: context_to_emotion(natural_landscape, joy).


face_emotion_0([Face_0, _, _], Emotion):-
    face_emotion(Face_0, Emotion).

face_emotion_1([_, Face_1, _], Emotion):-
    face_emotion(Face_1, Emotion).

face_emotion_2([_, _, Face_2], Emotion):-
    face_emotion(Face_2, Emotion).

scene_context(Scene, Context):-
    scene(Scene, Context).
