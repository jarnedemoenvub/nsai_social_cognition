nn(face_model, [Face], Emotion, [angry, disgust, fear, happy, sad, surprise]):: face_emotion(Face, Emotion).

nn(scene_model, [Image], Scene, ['natural_landscape',
 'industrial_facility',
 'urban_outdoor',
 'indoor_residential',
 'religious_or_historical_site',
 'sports_and_entertainment',
 'cultural_space',
 'transport_infrastructure',
 'aquatic_environment',
 'cold_environment',
 'indoor_institutional',
 'rural_or_recreational_area',
 'indoor_commercial']):: scene(Image, Scene).

face_emotion_1([Face_1, _, _], Emotion):-
    face_emotion(Face_1, Emotion).

face_emotion_2([_, Face_2, _], Emotion):-
    face_emotion(Face_2, Emotion).

face_emotion_3([_, _, Face_3], Emotion):-
    face_emotion(Face_3, Emotion).

scene_context(Scene, Context):-
    scene(Scene, Context).

final_emo(Faces, Scene, E):-
    face_emotion_1(Faces, E).
    % face_emotion_2(Faces, Emo_2),
    % face_emotion_3(Faces, Emo_3),
    % scene(Scene, Context),
    % context_to_emotion(Context, Context_Emo),
    % aggregate_emotion(Emo_1, Emo_2, Emo_3, Context_Emo, E).
