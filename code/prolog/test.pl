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


% % If there are no faces detected, only base the emotion on the scene context
% test_0([], ContextPred, FinalEmo):-
%     scene_emotion_group(ContextPred, FinalEmo).

% % Only one face detected, pick the emotion of that person
% test_1([FaceEmo1Pred], _, FinalEmo):-
%     face_emotion_group(FaceEmo1Pred, FinalEmo).

% % Two faces detected, faces agree --> use face emotion
% test_2([FaceEmo1Pred, FaceEmo2Pred], _ , FinalEmo):-
%     face_emotion_group(FaceEmo1Pred, FinalEmo),
%     face_emotion_group(FaceEmo2Pred, FinalEmo).

% % Two faces detected, faces disagree --> use scene emotion
% test_2([FaceEmo1Pred, FaceEmo2Pred], ContextPred , FinalEmo):-
%     face_emotion_group(FaceEmo1Pred, FaceEmo1),
%     face_emotion_group(FaceEmo2Pred, FaceEmo2),
%     \+ (FaceEmo1 = FaceEmo2),
%     scene_emotion_group(ContextPred, FinalEmo).

% % Three faces detected --> all same emotion --> output that emotion
% test_3([FaceEmo1Pred, FaceEmo2Pred, FaceEmo3Pred], _, FinalEmo):-

%     face_emotion_group(FaceEmo1Pred, FinalEmo),
%     face_emotion_group(FaceEmo2Pred, FinalEmo),
%     face_emotion_group(FaceEmo3Pred, FinalEmo).

% % Three faces detected --> all different emotions --> output scene
% test_3([FaceEmo1Pred, FaceEmo2Pred, FaceEmo3Pred], ContextPred, FinalEmo):-

%     face_emotion_group(FaceEmo1Pred, FaceEmo1),
%     face_emotion_group(FaceEmo2Pred, FaceEmo2),
%     face_emotion_group(FaceEmo3Pred, FaceEmo3),

%     all_different(FaceEmo1, FaceEmo2, FaceEmo3),
%     scene_emotion_group(ContextPred, FinalEmo).

% % Three faces detected --> with a dominant and not dominant emotion. 
% test_3([FaceEmo1Pred, FaceEmo2Pred, FaceEmo3Pred], ContextPred, FinalEmo):-

%     face_emotion_group(FaceEmo1Pred, FaceEmo1),
%     face_emotion_group(FaceEmo2Pred, FaceEmo2),
%     face_emotion_group(FaceEmo3Pred, FaceEmo3),

%     dominant_emotion(FaceEmo1, FaceEmo2, FaceEmo3, DomEmo, OtherEmo),
%     scene_emotion_group(ContextPred, SceneEmo),
%     match_with_scene(DomEmo, OtherEmo, SceneEmo, FinalEmo).

% test:-
%     test_0([], summer, happy),
%     test_0([], depressing, sad),

%     test_1([disgust], depressing, sad),
%     test_1([happy], depressing, happy),

%     test_2([neutral, neutral], depressing, neutral),
%     test_2([neutral, neutral], neutral, neutral),
%     test_2([happy, sad], summer, happy),
%     test_2([happy, sad], work, neutral),

%     test_3([happy, happy, happy], summer, happy),
%     test_3([happy, happy, happy], depressing, happy),
%     test_3([happy, sad, happy], depressing, sad),
%     test_3([happy, sad, happy], summer, happy),
%     test_3([happy, sad, surprise], summer, happy),
%     test_3([happy, sad, neutral], summer, happy).




