nn(face_model, [Face], Emotion,
   [angry, disgust, fear, happy, neutral, sad, surprise]) ::
   face_emotion(Face, Emotion).

nn(scene_model, [Scene], Cluster, [0, 1, 2, 3, 4, 5, 6, 7, 8]) ::
   scene_cluster(Scene, Cluster).

va_cluster(low, high, 0).
va_cluster(mid, mid, 1).
t(_)::va_cluster(low, mid, 2);
t(_)::va_cluster(low, mid, 7).

va_cluster(high, high, 3).
t(_)::va_cluster(high, low, 4);
t(_)::va_cluster(high, low, 5);
t(_)::va_cluster(high, low, 8).

va_cluster(mid, low, 6).

t(_)::va_emotion(low, high, anger);
t(_)::va_emotion(low, high, fear);
t(_)::va_emotion(low, high, sadness).

t(_)::va_emotion(mid, low, anticipation);
t(_)::va_emotion(mid, low, surprise).

va_emotion(low, low, disgust).
va_emotion(high, mid, joy).
va_emotion(high, low, trust).

t(_)::va_face_emotion(low, high, angry);
t(_)::va_face_emotion(low, high, fear).

t(_)::va_face_emotion(low, low, disgust);
t(_)::va_face_emotion(low, low, sad).

va_face_emotion(high, mid, happy).
va_face_emotion(mid, low, neutral).
va_face_emotion(mid, high, surprise).

final_emotion_0([], SceneTensor, FinalEmo) :-
    scene_cluster(SceneTensor, Cluster),
    va_cluster(Val, Ar, Cluster),
    va_emotion(Val, Arou, FinalEmo).

final_emotion_1([FaceTensor1], SceneTensor, FinalEmo) :-
   scene_cluster(SceneTensor, Cluster),
   face_emotion(FaceTensor1, FaceEmotion),
   % Based on the face prediction, get symboloc values for valence and arousal
   va_face_emotion(FaceVal, FaceAr, FaceEmotion),
   % Now get the estimated symbolic value for valence and arousal based on the scene
   scene_cluster(SceneTensor, CLuster),
   va_cluster(SceneVal, SceneAr, Cluster),
