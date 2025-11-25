nn(face_model, [Face], Emotion,
   [angry, disgust, fear, happy, neutral, sad, surprise]) ::
   face_emotion(Face, Emotion).

nn(scene_model, [Scene], Cluster, [0, 1, 2, 3, 4, 5, 6, 7, 8]) ::
   scene_cluster(Scene, Cluster).

t(1/3) :: cluster_emo(0, anger);
t(1/3) :: cluster_emo(0, fear);
t(1/3) :: cluster_emo(0, sadness).

t(_)



final_emotion_0([], SceneTensor, FinalEmo) :-
    scene_cluster(SceneTensor, Cluster),
    va_cluster(Val, Ar, Cluster),
    va_emotion(Val, Arou, FinalEmo).

final_emotion(FaceTensorList, SceneTensor, FinalEmo):-



