nn(face_model, [Face], Emotion, 
    [acceptance, admiration, amazement, anger, annoyance, anticipation, 
    apprehension, boredom, disgust, distraction, ecstasy, fear, grief, 
    interest, joy, loathing, pensiveness, rage, sadness, serenity, surprise, terror, 
    trust, vigilance]):: face_emotion(Face, Emotion).

nn(scene_model, [Image], Context, 
    [aquatic_environment, cold_environment, cultural_space, indoor_commercial, 
    indoor_institutional, indoor_residential, industrial_facility, natural_landscape, 
    religious_or_historical_site, rural_or_recreational_area, sports_and_entertainment, 
    transport_infrastructure, urban_outdoor]):: scene(Image, Context).

% Learnable gate (mixture over sources). Parameters t(_) are learned end-to-end.
t(_)::use_source(face_0); t(_)::use_source(face_1); t(_)::use_source(face_2); t(_)::use_source(scene).

% Face helpers: pick one of the three faces and call the neural predicate
face_emotion0([Face_0, _, _], Emotion) :- face_emotion(Face_0, Emotion).
face_emotion1([_, Face_1, _], Emotion) :- face_emotion(Face_1, Emotion).
face_emotion2([_, _, Face_2], Emotion) :- face_emotion(Face_2, Emotion).

% Final emotion = mixture-of-experts using the learned gate
final_emo(Faces, _Image, Emotion) :-
    use_source(face_0),
    face_emotion0(Faces, Emotion).
final_emo(Faces, _Image, Emotion) :-
    use_source(face_1),
    face_emotion1(Faces, Emotion).
final_emo(Faces, _Image, Emotion) :-
    use_source(face_2),
    face_emotion2(Faces, Emotion).
final_emo(_Faces, Image, Emotion) :-
    use_source(scene),
    scene_context(Image, Context),
    context_to_emotion(Context, Emotion).