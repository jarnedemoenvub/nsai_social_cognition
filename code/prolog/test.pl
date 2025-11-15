final_emotion_0_test([], ContextPred, FinalEmo):-
    scene_emotion_group(ContextPred, FinalEmo).

% Only one face detected
final_emotion_1_test([FaceEmo1Pred], _, FinalEmo):-
    face_emotion_group(FaceEmo1Pred, FinalEmo).

% Two faces detected
final_emotion_2_test([FaceEmo1Pred, FaceEmo2Pred], ContextPred , FinalEmo):-
    face_emotion_group(FaceEmo1Pred, FaceEmo1),
    face_emotion_group(FaceEmo2Pred, FaceEmo2),

    scene_emotion_group(ContextPred, SceneEmo),

    aggregate_cues_2(FaceEmo1, FaceEmo2, SceneEmo, FinalEmo).

% Three faces detected
% If there are two emotions of the same class
final_emotion_3_test([FaceEmo1Pred, FaceEmo2Pred, FaceEmo3Pred], ContextPred, FinalEmo):-
    face_emotion_group(FaceEmo1Pred, FaceEmo1),
    face_emotion_group(FaceEmo2Pred, FaceEmo2),
    face_emotion_group(FaceEmo3Pred, FaceEmo3),

    dominant_emotion(FaceEmo1, FaceEmo2, FaceEmo3, DomEmo, OtherEmo),
    scene_emotion_group(ContextPred, SceneEmo),
    aggregate_cues_3(FaceEmo1, FaceEmo2, FaceEmo3, SceneEmo, DomEmo, OtherEmo, FinalEmo).

test:-
    final_emotion_0_test([], summer, happy),

    final_emotion_1_test([happy], summer, happy),

    final_emotion_2_test([happy, happy], depressing, happy),
    final_emotion_2_test([happy, sad], summer, happy),

    final_emotion_3_test([sad, sad, sad], summer, sad),
    final_emotion_3_test([happy, sad, sad], summer, happy),
    final_emotion_3_test([happy, sad, sad], depressing, sad),
    final_emotion_3_test([happy, sad, disgust], depressing, sad).





