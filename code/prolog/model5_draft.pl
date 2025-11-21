nn(face_model, [Face], Emotion,
   [angry, disgust, fear, happy, neutral, sad, surprise]) ::
   face_emotion(Face, Emotion).

nn(scene_model, [Scene], Cluster, [0, 1, 2, 3, 4, 5, 6, 7, 8]) ::
   scene_cluster(Scene, Cluster).

final_emotion_0([], SceneTensor, FinalEmo) :-
    scene_cluster(SceneTensor, Cluster),
    va_cluster(Cluster, Valence, Arousal),
    va_emotion(Valence, Arousal, FinalEmo).

final_emotion_

% Zorg ervoor dat elke cluster wel naar een emotie mapt en dat alle emoties ook effectief bereikbaar zijn!

va_cluster(0, very_low, very_high).
va_cluster(1, mid, mid).
va_cluster(2, low, mid).
va_cluster(3, very_high, high).
va_cluster(4, very_high, low).
va_cluster(5, high, very_low).
va_cluster(6, mid, very_low).
va_cluster(7, low, high).
va_cluster(8, very_high, very_low).

t(_)::va_emotion(high, very_low, acceptance);
t(_)::va_emotion(high, very_low, interest).

t(_)::va_emotion(very_high, mid, admiration);
t(_)::va_emotion(very_high, mid, amazement);
t(_)::va_emotion(very_high, mid, joy).

t(_)::va_emotion(very_low, high, anger);
t(_)::va_emotion(very_low, high, fear);
t(_)::va_emotion(very_low, high, loathing);
t(_)::va_emotion(very_low, high, sadness).

va_emotion(very_low, low, annoyance).
t(_)::va_emotion(mid, low, anticipation);
t(_)::va_emotion(mid, low, surprise).

t(_)::va_emotion(low, low, apprehension);
t(_)::va_emotion(low, low, pensiveness).

va_emotion(low, very_low, boredom).
va_emotion(very_low, mid, disgust).
va_emotion(mid, very_low, distraction).
va_emotion(very_high, high, ecstasy).
t(_)::va_emotion(very_low, very_high, grief);
t(_)::va_emotion(very_low, very_high, rage);
t(_)::va_emotion(very_low, very_high, terror).

va_emotion(very_high, very_low, serenity).
va_emotion(very_high, low, trust).
va_emotion(mid, mid, vigilance).
