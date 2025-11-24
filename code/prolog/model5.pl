nn(face_model, [Face], Emotion,
   [angry, disgust, fear, happy, neutral, sad, surprise]) ::
   face_emotion(Face, Emotion).

nn(scene_model, [Scene], Cluster, [0, 1, 2, 3, 4, 5, 6, 7, 8]) ::
   scene_cluster(Scene, Cluster).

va_cluster(very_low, very_high, 0).
va_cluster(mid, mid, 1).
va_cluster(low, mid, 2).
va_cluster(very_high, high, 3).
va_cluster(very_high, low, 4).
va_cluster(high, very_low, 5).
va_cluster(mid, very_low, 6).
va_cluster(low, high, 7).
va_cluster(very_high, very_low, 8).

va_emotion(high, very_low, acceptance).
va_emotion(very_high, mid, admiration).
va_emotion(very_high, mid, amazement).
va_emotion(very_low, very_high, anger).
va_emotion(very_low, low, annoyance).
va_emotion(mid, low, anticipation).
va_emotion(low, low, apprehension).
va_emotion(low, very_low, boredom).
va_emotion(very_low, mid, disgust).
va_emotion(mid, very_low, distraction).
va_emotion(very_high, very_high, ecstasy).
va_emotion(very_low, high, fear).
va_emotion(very_low, very_high, grief).
va_emotion(high, very_low, interest).
va_emotion(very_high, mid, joy).
va_emotion(very_low, high, loathing).
va_emotion(low, low, pensiveness).
va_emotion(very_low, very_high, rage).
va_emotion(very_low, high, sadness).
va_emotion(very_high, low, serenity).
va_emotion(mid, low, surprise).
va_emotion(very_low, very_high, terror).
va_emotion(very_high, low, trust).
va_emotion(mid, mid, vigilance).

va_face_emotion(low, mid, angry).
va_face_emotion(low, high, disgust).
va_face_emotion(low, mid, fear).
va_face_emotion(high, mid, happy).
va_face_emotion(low, low, neutral).
va_face_emotion(low, mid, sad).
va_face_emotion(low, high, surprise).

