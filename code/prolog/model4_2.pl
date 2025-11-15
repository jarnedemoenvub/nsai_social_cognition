% -------------------------------
% Neural predicates
% -------------------------------
nn(face_model, [Face], Emotion,
   [angry, disgust, fear, happy, neutral, sad, surprise]) ::
   face_emotion(Face, Emotion).

nn(scene_model, [Scene], Context,
   [agriculture, cold, commercial, cultural, depressing, food, horeca, 
    house_interior, industrial, nature, playful, relaxing, royal, scary, sport, 
    summer, transport, urban, woods, work]) :: scene_context(Scene, Context).

% -------------------------------
% Emotion grouping
% -------------------------------
face_emotion_group(happy, happy).

face_emotion_group(surprise, neutral).
face_emotion_group(neutral, neutral).

face_emotion_group(angry, sad).
face_emotion_group(disgust, sad).
face_emotion_group(fear, sad).
face_emotion_group(sad, sad).


scene_emotion_group(agriculture, happy).
scene_emotion_group(food, happy).
scene_emotion_group(horeca, happy).
scene_emotion_group(nature, happy).
scene_emotion_group(playful, happy).
scene_emotion_group(relaxing, happy).
scene_emotion_group(sport, happy).
scene_emotion_group(summer, happy).
scene_emotion_group(royal, happy).
scene_emotion_group(woods, happy).

scene_emotion_group(commercial, neutral).
scene_emotion_group(cultural, neutral).
scene_emotion_group(house_interior, neutral).
scene_emotion_group(transport, neutral).
scene_emotion_group(work, neutral).
scene_emotion_group(urban, neutral).

scene_emotion_group(cold, sad).
scene_emotion_group(scary, sad).
scene_emotion_group(industrial, sad).
scene_emotion_group(depressing, sad).

dominant_emotion(OtherEmo, DomEmo, DomEmo, DomEmo, OtherEmo).
dominant_emotion(DomEmo, OtherEmo, DomEmo, DomEmo, OtherEmo).
dominant_emotion(DomEmo, DomEmo, OtherEmo, DomEmo, OtherEmo).
dominant_emotion(E1, E2, E3, all_diff, all_diff):-
    \+(E1 = E2),
    \+(E2 = E3),
    \+(E1 = E3).

% If all faces (and the scene) match emotion, return that emotion
% aggregate_cues_2(E1, E2, SE, Final)
aggregate_cues_2(E, E, _, E).

% Otherwise, it will be decided by the scene
aggregate_cues_2(_, _, E, E).

% All 3 faces the same --> output that emotion
% aggregate_cues_3(E1, E2, E3, SE, Dom, Other, Final)
aggregate_cues_3(E, E, E, _, _, _, E).

% If the dominant emotion matches the scene emotion, output that emotion
aggregate_cues_3(_, _, _, E, E, _, E).

% If the scene matches the other emotion, output that other emotion
aggregate_cues_3(_, _, _, E, _, E, E).

% No dominant emotion (all_diff), output emotion of the scene
aggregate_cues_3(_, _, _, E, all_diff, all_diff, E).
    
% If there are no faces detected, only base the emotion on the scene context
final_emotion_0([], SceneTensor, FinalEmo):-
    scene_context(SceneTensor, ContextPred),
    scene_emotion_group(ContextPred, FinalEmo).

% Only one face detected, pick the emotion of that person
final_emotion_1([FaceTensor1], _, FinalEmo):-
    face_emotion(FaceTensor1, FaceEmo1Pred),
    face_emotion_group(FaceEmo1Pred, FinalEmo).

% Two faces detected
final_emotion_2([FaceTensor1, FaceTensor2], SceneTensor , FinalEmo):-
    face_emotion(FaceTensor1, FaceEmo1Pred),
    face_emotion(FaceTensor2, FaceEmo2Pred),
    face_emotion_group(FaceEmo1Pred, FaceEmo1),
    face_emotion_group(FaceEmo2Pred, FaceEmo2),

    scene_context(SceneTensor, ContextPred),
    scene_emotion_group(ContextPred, SceneEmo),

    aggregate_cues_2(FaceEmo1, FaceEmo2, SceneEmo, FinalEmo).

% Three faces detected
final_emotion_3([FaceTensor1, FaceTensor2, FaceTensor3], SceneTensor, FinalEmo):-
    face_emotion(FaceTensor1, FaceEmo1Pred),
    face_emotion(FaceTensor2, FaceEmo2Pred),
    face_emotion(FaceTensor3, FaceEmo3Pred),

    face_emotion_group(FaceEmo1Pred, FaceEmo1),
    face_emotion_group(FaceEmo2Pred, FaceEmo2),
    face_emotion_group(FaceEmo3Pred, FaceEmo3),

    dominant_emotion(FaceEmo1, FaceEmo2, FaceEmo3, DomEmo, OtherEmo),
    scene_context(SceneTensor, ContextPred),
    scene_emotion_group(ContextPred, SceneEmo),
    aggregate_cues_3(FaceEmo1, FaceEmo2, FaceEmo3, SceneEmo, DomEmo, OtherEmo, FinalEmo).




