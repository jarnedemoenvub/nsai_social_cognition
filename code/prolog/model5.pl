nn(face_model, [Face], Emotion,
   [angry, disgust, fear, happy, neutral, sad, surprise]) ::
   face_emotion(Face, Emotion).

nn(scene_model, [Scene], Cluster, [0,1,2,3,4,5,6,7,8]) ::
   scene_cluster(Scene, Cluster).

final_emotion_0([], SceneTensor, FinalEmo) :-
    scene_cluster(SceneTensor, Cluster),
    cluster_to_emotion(Cluster, FinalEmo).

0.05::cluster_to_emotion(0, joy);
0.05::cluster_to_emotion(0, trust);
0.24::cluster_to_emotion(0, fear);
0.08::cluster_to_emotion(0, surprise);
0.19::cluster_to_emotion(0, sadness);
0.13::cluster_to_emotion(0, disgust);
0.18::cluster_to_emotion(0, anger);
0.08::cluster_to_emotion(0, anticipation).

0.08::cluster_to_emotion(1, joy);
0.11::cluster_to_emotion(1, trust);
0.07::cluster_to_emotion(1, fear);
0.30::cluster_to_emotion(1, surprise);
0.06::cluster_to_emotion(1, sadness);
0.09::cluster_to_emotion(1, disgust);
0.06::cluster_to_emotion(1, anger);
0.23::cluster_to_emotion(1, anticipation).

0.07::cluster_to_emotion(2, joy);
0.09::cluster_to_emotion(2, trust);
0.12::cluster_to_emotion(2, fear);
0.19::cluster_to_emotion(2, surprise);
0.10::cluster_to_emotion(2, sadness);
0.18::cluster_to_emotion(2, disgust);
0.09::cluster_to_emotion(2, anger);
0.16::cluster_to_emotion(2, anticipation).

0.15::cluster_to_emotion(3, joy);
0.18::cluster_to_emotion(3, trust);
0.07::cluster_to_emotion(3, fear);
0.21::cluster_to_emotion(3, surprise);
0.06::cluster_to_emotion(3, sadness);
0.08::cluster_to_emotion(3, disgust);
0.06::cluster_to_emotion(3, anger);
0.19::cluster_to_emotion(3, anticipation).

0.11::cluster_to_emotion(4, joy);
0.19::cluster_to_emotion(4, trust);
0.05::cluster_to_emotion(4, fear);
0.25::cluster_to_emotion(4, surprise);
0.05::cluster_to_emotion(4, sadness);
0.06::cluster_to_emotion(4, disgust);
0.04::cluster_to_emotion(4, anger);
0.25::cluster_to_emotion(4, anticipation).

0.04::cluster_to_emotion(5, joy);
0.09::cluster_to_emotion(5, trust);
0.03::cluster_to_emotion(5, fear);
0.26::cluster_to_emotion(5, surprise);
0.02::cluster_to_emotion(5, sadness);
0.04::cluster_to_emotion(5, disgust);
0.02::cluster_to_emotion(5, anger);
0.50::cluster_to_emotion(5, anticipation).

0.05::cluster_to_emotion(6, joy);
0.08::cluster_to_emotion(6, trust);
0.05::cluster_to_emotion(6, fear);
0.40::cluster_to_emotion(6, surprise);
0.04::cluster_to_emotion(6, sadness);
0.08::cluster_to_emotion(6, disgust);
0.04::cluster_to_emotion(6, anger);
0.26::cluster_to_emotion(6, anticipation).

0.07::cluster_to_emotion(7, joy);
0.07::cluster_to_emotion(7, trust);
0.16::cluster_to_emotion(7, fear);
0.14::cluster_to_emotion(7, surprise);
0.13::cluster_to_emotion(7, sadness);
0.18::cluster_to_emotion(7, disgust);
0.12::cluster_to_emotion(7, anger);
0.13::cluster_to_emotion(7, anticipation).

0.12::cluster_to_emotion(8, joy);
0.46::cluster_to_emotion(8, trust);
0.04::cluster_to_emotion(8, fear);
0.13::cluster_to_emotion(8, surprise);
0.03::cluster_to_emotion(8, sadness);
0.05::cluster_to_emotion(8, disgust);
0.03::cluster_to_emotion(8, anger);
0.14::cluster_to_emotion(8, anticipation).

