nn(face_model, [Face], Emotion, [anger, disgust, fear, joy, sadness, surprise]):: face_emotion(Face, Emotion).

nn(scene_model, [Image], Context, 
    ['aquatic_environment', 'cold_environment', 'cultural_space', 'indoor_commercial', 
    'indoor_institutional', 'indoor_residential', 'industrial_facility', 'natural_landscape', 
    'religious_or_historical_site', 'rural_or_recreational_area', 'sports_and_entertainment', 
    'transport_infrastructure', 'urban_outdoor']):: scene(Image, Context).

% Learnable gate (mixture over sources). Parameters t(_) are learned end-to-end.
t(_)::use_source(face_0); t(_)::use_source(face_1); t(_)::use_source(face_2); t(_)::use_source(scene).

% Face helpers: pick one of the three faces and call the neural predicate
face_emotion0([Face_0, _, _], Emotion) :- face_emotion(Face_0, Emotion).
face_emotion1([_, Face_1, _], Emotion) :- face_emotion(Face_1, Emotion).
face_emotion2([_, _, Face_2], Emotion) :- face_emotion(Face_2, Emotion).

scene_context(Image, Context):-
    scene(Image, Context).

face_vote(Faces, Emotion) :-
    face_emotion0(Faces, Emotion).
face_vote(Faces, Emotion) :-
    face_emotion1(Faces, Emotion).
face_vote(Faces, Emotion) :-
    face_emotion2(Faces, Emotion).

% Minimal fallback prior so scene path is never blocking (can be replaced by your learned priors)
0.01::base_prior(anger).
0.01::base_prior(disgust).
0.01::base_prior(fear).
0.01::base_prior(joy).
0.01::base_prior(sadness).
0.01::base_prior(surprise).

context_to_emotion(_Context, Emotion) :- base_prior(Emotion).

0.12::context_to_emotion(aquatic_environment, anger).
0.04::context_to_emotion(aquatic_environment, disgust).
0.20::context_to_emotion(aquatic_environment, fear).
0.49::context_to_emotion(aquatic_environment, joy).
0.11::context_to_emotion(aquatic_environment, sadness).
0.03::context_to_emotion(aquatic_environment, surprise).

0.15::context_to_emotion(cold_environment, anger).
0.00::context_to_emotion(cold_environment, disgust).
0.26::context_to_emotion(cold_environment, fear).
0.37::context_to_emotion(cold_environment, joy).
0.07::context_to_emotion(cold_environment, sadness).
0.15::context_to_emotion(cold_environment, surprise).

0.10::context_to_emotion(cultural_space, anger).
0.05::context_to_emotion(cultural_space, disgust).
0.09::context_to_emotion(cultural_space, fear).
0.55::context_to_emotion(cultural_space, joy).
0.13::context_to_emotion(cultural_space, sadness).
0.06::context_to_emotion(cultural_space, surprise).

0.11::context_to_emotion(indoor_commercial, anger).
0.07::context_to_emotion(indoor_commercial, disgust).
0.11::context_to_emotion(indoor_commercial, fear).
0.50::context_to_emotion(indoor_commercial, joy).
0.16::context_to_emotion(indoor_commercial, sadness).
0.05::context_to_emotion(indoor_commercial, surprise).

0.11::context_to_emotion(indoor_institutional, anger).
0.08::context_to_emotion(indoor_institutional, disgust).
0.13::context_to_emotion(indoor_institutional, fear).
0.45::context_to_emotion(indoor_institutional, joy).
0.17::context_to_emotion(indoor_institutional, sadness).
0.07::context_to_emotion(indoor_institutional, surprise).

0.07::context_to_emotion(indoor_residential, anger).
0.06::context_to_emotion(indoor_residential, disgust).
0.10::context_to_emotion(indoor_residential, fear).
0.57::context_to_emotion(indoor_residential, joy).
0.15::context_to_emotion(indoor_residential, sadness).
0.04::context_to_emotion(indoor_residential, surprise).

0.13::context_to_emotion(industrial_facility, anger).
0.06::context_to_emotion(industrial_facility, disgust).
0.32::context_to_emotion(industrial_facility, fear).
0.22::context_to_emotion(industrial_facility, joy).
0.23::context_to_emotion(industrial_facility, sadness).
0.04::context_to_emotion(industrial_facility, surprise).

0.03::context_to_emotion(natural_landscape, anger).
0.03::context_to_emotion(natural_landscape, disgust).
0.17::context_to_emotion(natural_landscape, fear).
0.64::context_to_emotion(natural_landscape, joy).
0.09::context_to_emotion(natural_landscape, sadness).
0.03::context_to_emotion(natural_landscape, surprise).

0.11::context_to_emotion(religious_or_historical_site, anger).
0.07::context_to_emotion(religious_or_historical_site, disgust).
0.16::context_to_emotion(religious_or_historical_site, fear).
0.40::context_to_emotion(religious_or_historical_site, joy).
0.21::context_to_emotion(religious_or_historical_site, sadness).
0.06::context_to_emotion(religious_or_historical_site, surprise).

0.14::context_to_emotion(rural_or_recreational_area, anger).
0.05::context_to_emotion(rural_or_recreational_area, disgust).
0.10::context_to_emotion(rural_or_recreational_area, fear).
0.50::context_to_emotion(rural_or_recreational_area, joy).
0.17::context_to_emotion(rural_or_recreational_area, sadness).
0.04::context_to_emotion(rural_or_recreational_area, surprise).

0.19::context_to_emotion(sports_and_entertainment, anger).
0.03::context_to_emotion(sports_and_entertainment, disgust).
0.11::context_to_emotion(sports_and_entertainment, fear).
0.50::context_to_emotion(sports_and_entertainment, joy).
0.10::context_to_emotion(sports_and_entertainment, sadness).
0.07::context_to_emotion(sports_and_entertainment, surprise).

0.16::context_to_emotion(transport_infrastructure, anger).
0.07::context_to_emotion(transport_infrastructure, disgust).
0.13::context_to_emotion(transport_infrastructure, fear).
0.38::context_to_emotion(transport_infrastructure, joy).
0.20::context_to_emotion(transport_infrastructure, sadness).
0.06::context_to_emotion(transport_infrastructure, surprise).

0.23::context_to_emotion(urban_outdoor, anger).
0.07::context_to_emotion(urban_outdoor, disgust).
0.19::context_to_emotion(urban_outdoor, fear).
0.27::context_to_emotion(urban_outdoor, joy).
0.20::context_to_emotion(urban_outdoor, sadness).
0.05::context_to_emotion(urban_outdoor, surprise).

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