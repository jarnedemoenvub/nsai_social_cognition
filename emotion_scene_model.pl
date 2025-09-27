% DeepProbLog program for emotion recognition combining face emotions and scene context
% Author: Generated for social cognition research
% Models: Face emotion detection + Scene recognition -> Overall emotion, valence, arousal

% Neural network predicates (following DeepProbLog syntax)
nn(emotion_net, [FaceImg], EmotionProbs, [angry, disgust, fear, happy, sad, surprise, neutral]) :: face_emotion(FaceImg, EmotionProbs).
nn(scene_net, [SceneImg], SceneProbs, [beach, cemetery, party, playground, hospital, office, park, restaurant, home, street]) :: scene_context(SceneImg, SceneProbs).

% Emotion mapping rules based on psychological research
% High valence emotions: happy, surprise (positive emotions)
% Low valence emotions: angry, disgust, fear, sad (negative emotions) 
% Neutral valence: neutral

% High arousal emotions: angry, fear, surprise (high intensity)
% Medium arousal emotions: happy, disgust (medium intensity)
% Low arousal emotions: sad, neutral (low intensity)

% Valence prediction based on face emotion and scene context
0.8::valence(positive) :- face_emotion(happy), scene_supports_positive.
0.7::valence(positive) :- face_emotion(surprise), scene_supports_positive.
0.3::valence(positive) :- face_emotion(neutral), scene_supports_positive.
0.1::valence(positive) :- face_emotion(angry), scene_supports_positive.
0.1::valence(positive) :- face_emotion(disgust), scene_supports_positive.
0.1::valence(positive) :- face_emotion(fear), scene_supports_positive.
0.1::valence(positive) :- face_emotion(sad), scene_supports_positive.

0.2::valence(positive) :- face_emotion(happy), \+scene_supports_positive.
0.4::valence(positive) :- face_emotion(surprise), \+scene_supports_positive.
0.2::valence(positive) :- face_emotion(neutral), \+scene_supports_positive.
0.05::valence(positive) :- face_emotion(angry), \+scene_supports_positive.
0.05::valence(positive) :- face_emotion(disgust), \+scene_supports_positive.
0.05::valence(positive) :- face_emotion(fear), \+scene_supports_positive.
0.05::valence(positive) :- face_emotion(sad), \+scene_supports_positive.

valence(negative) :- \+valence(positive).

% Arousal prediction based on face emotion and scene intensity
0.9::arousal(high) :- face_emotion(angry), scene_high_intensity.
0.8::arousal(high) :- face_emotion(fear), scene_high_intensity.
0.7::arousal(high) :- face_emotion(surprise), scene_high_intensity.
0.6::arousal(high) :- face_emotion(happy), scene_high_intensity.
0.5::arousal(high) :- face_emotion(disgust), scene_high_intensity.
0.2::arousal(high) :- face_emotion(sad), scene_high_intensity.
0.1::arousal(high) :- face_emotion(neutral), scene_high_intensity.

0.7::arousal(high) :- face_emotion(angry), \+scene_high_intensity.
0.6::arousal(high) :- face_emotion(fear), \+scene_high_intensity.
0.5::arousal(high) :- face_emotion(surprise), \+scene_high_intensity.
0.4::arousal(high) :- face_emotion(happy), \+scene_high_intensity.
0.3::arousal(high) :- face_emotion(disgust), \+scene_high_intensity.
0.1::arousal(high) :- face_emotion(sad), \+scene_high_intensity.
0.05::arousal(high) :- face_emotion(neutral), \+scene_high_intensity.

arousal(low) :- \+arousal(high).

% Overall emotion prediction combining face and scene
0.9::overall_emotion(happy) :- face_emotion(happy), scene_supports_positive, \+scene_high_intensity.
0.8::overall_emotion(happy) :- face_emotion(happy), scene_supports_positive, scene_high_intensity.
0.3::overall_emotion(happy) :- face_emotion(happy), \+scene_supports_positive.

0.8::overall_emotion(angry) :- face_emotion(angry), scene_high_intensity.
0.6::overall_emotion(angry) :- face_emotion(angry), \+scene_high_intensity.
0.4::overall_emotion(angry) :- face_emotion(disgust), scene_high_intensity.

0.8::overall_emotion(fear) :- face_emotion(fear), scene_high_intensity.
0.6::overall_emotion(fear) :- face_emotion(fear), \+scene_high_intensity.
0.3::overall_emotion(fear) :- face_emotion(surprise), scene_negative_context.

0.7::overall_emotion(sad) :- face_emotion(sad), scene_negative_context.
0.5::overall_emotion(sad) :- face_emotion(sad), \+scene_negative_context.

0.7::overall_emotion(surprise) :- face_emotion(surprise), scene_supports_positive.
0.5::overall_emotion(surprise) :- face_emotion(surprise), \+scene_supports_positive.

0.6::overall_emotion(disgust) :- face_emotion(disgust), scene_negative_context.
0.4::overall_emotion(disgust) :- face_emotion(disgust), \+scene_negative_context.

0.8::overall_emotion(neutral) :- face_emotion(neutral), \+scene_high_intensity, \+scene_supports_positive, \+scene_negative_context.
0.4::overall_emotion(neutral) :- face_emotion(neutral).

% Default case for any unmatched emotion
0.1::overall_emotion(X) :- face_emotion(X), \+overall_emotion(_).

% Scene context classification based on Places365 categories
scene_supports_positive :- scene_context(party).
scene_supports_positive :- scene_context(wedding).
scene_supports_positive :- scene_context(playground).
scene_supports_positive :- scene_context(festival).
scene_supports_positive :- scene_context(beach).
scene_supports_positive :- scene_context(garden).
scene_supports_positive :- scene_context(park).

scene_negative_context :- scene_context(cemetery).
scene_negative_context :- scene_context(hospital).
scene_negative_context :- scene_context(prison).
scene_negative_context :- scene_context(war_zone).
scene_negative_context :- scene_context(disaster).

scene_high_intensity :- scene_context(sports).
scene_high_intensity :- scene_context(concert).
scene_high_intensity :- scene_context(stadium).
scene_high_intensity :- scene_context(rally).
scene_high_intensity :- scene_context(protest).
scene_high_intensity :- scene_context(competition).

% Main query predicates
emotion_prediction(Emotion, Valence, Arousal) :- 
    overall_emotion(Emotion),
    valence(Valence), 
    arousal(Arousal).