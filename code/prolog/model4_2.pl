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

% all_same_emotion(FaceEmo1, FaceEmo2, FaceEmo3, FinalEmo) --> results in the same emotion as final emotion output
all_same_emotion(E, E, E, FinalEmo):-
    face_emotion_group(E, FinalEmo).

all_same_emotion(E, E, FinalEmo):-
    face_emotion_group(E, FinalEmo).

% majority_emotion(FaceEmo1, FaceEmo2, FaceEmo3, DomEmo, OtherEmo)
dominant_emotion(E1, E2, E1, DomEmo, OtherEmo):-
    face_emotion_group(E1, DomEmo),
    face_emotion_group(E2, OtherEmo).

dominant_emotion(E1, E1, E2, DomEmo, OtherEmo):-
    face_emotion_group(E1, DomEmo),
    face_emotion_group(E2, OtherEmo).

dominant_emotion(E2, E1, E1, DomEmo, OtherEmo):-
    face_emotion_group(E1, DomEmo),
    face_emotion_group(E2, OtherEmo).

aggregate_cues_1(FaceEmo1, Context, FinalEmo):-
    scene_emotion_group(Context, SceneEmo),
    all_same_emotion(FaceEmo1, SceneEmo, FinalEmo).

% The following context categories have wedding scenes and can never be sad
aggregate_cues_1(_, agriculture, happy).
aggregate_cues_1(_, nature, happy).
aggregate_cues_1(_, royal, happy).

% For other scene categories, it does not matter because when people seem happy, even in less happy places, the overall emotion will be happy
aggregate_cues_1(FaceEmotion1, _, FaceEmotion1).

% If the dominant emotion matches the scene emotion, output that emotion
aggregate_cues_3(DomEmo, _, Context, FinalEmo):-
    scene_emotion_group(Context, SceneEmotion),
    all_same_emotion(DomEmo, SceneEmotion, FinalEmo).

% If the scene matches the other emotion, output that other emotion
aggregate_cues_3(_, OtherEmo, Context, FinalEmo):-
    scene_emotion_group(Context, SceneEmotion),
    all_same_emotion(OtherEmo, SceneEmotion, FinalEmo).
    
% If there are no faces detected, only base the emotion on the scene context
final_emotion([noface, noface, noface], Scene, FinalEmo):-
    scene_context(Scene, Context),
    scene_emotion_group(Context, FinalEmo).

test([Face1, noface, noface], _, great).

% Only one face detected
final_emotion([Face1, noface, noface], Scene, FinalEmo):-
    Face1 \= noface,
    face_emotion(Face1, FaceEmo1),
    scene_context(Scene, Context),
    aggregate_cues_1(FaceEmo1, Context, FinalEmo).

% Two faces detected
final_emotion([Face1, Face2, noface], _ , FinalEmo):-
    Face1 \= noface,
    Face2 \= noface,
    % If all faces agree on the emotion, the overall emotion will be the emotion of the faces
    face_emotion(Face1, FaceEmotion1),
    face_emotion(Face2, FaceEmotion2),
    all_same_emotion(FaceEmotion1, FaceEmotion2, FinalEmo).

final_emotion([_, _, noface], Scene, FinalEmo):-
    % When they do not agree on emotion, the scene context will decide the overall image emotion
    scene_context(Scene, Context),
    scene_emotion_group(Context, FinalEmo).

% Three faces detected 
% If all three faces have the same emotion, the final emotion will be that emotion regardless of the scene context
final_emotion([Face1, Face2, Face3], _, FinalEmo):-
    Face1 \= noface,
    Face2 \= noface,
    Face3 \= noface,
    face_emotion(Face1, FaceEmo1),
    face_emotion(Face2, FaceEmo2),
    face_emotion(Face3, FaceEmo3),
    all_same_emotion(FaceEmo1, FaceEmo2, FaceEmo3, FinalEmo).

% If there are two emotions of the same class
final_emotion([Face1, Face2, Face3], Scene, FinalEmo):-
    Face1 \= noface,
    Face2 \= noface,
    Face3 \= noface,
    % If they do not agree on the emotion, we will get the dominant emotion
    face_emotion(Face1, FaceEmo1),
    face_emotion(Face2, FaceEmo2),
    face_emotion(Face3, FaceEmo3),
    dominant_emotion(FaceEmo1, FaceEmo2, FaceEmo3, DomEmo, OtherEmo),
    scene_context(Scene, Context),
    aggregate_cues_3(DomEmo, OtherEmo, Context, FinalEmo).

% If all the emotions are different, final emotion will be decided by the context
final_emotion([_, _, _], Scene, FinalEmo):-
    % If they do not agree on the emotion, we will get the dominant emotion
    scene_context(Scene, Context),
    scene_emotion_group(Context, FinalEmo).