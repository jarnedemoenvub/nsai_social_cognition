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

% angry  → mostly Anger, some Disgust, tiny bit Fear
t(0.80) :: face_emotion_group(angry, anger) ; 
t(0.15) :: face_emotion_group(angry, disgust) ;
t(0.05) :: face_emotion_group(angry, fear).

% disgust → mostly Disgust, some Anger and Sadness
0.80 :: face_emotion_group(disgust, disgust) ;
0.10 :: face_emotion_group(disgust, anger) ;
0.10 :: face_emotion_group(disgust, sadness).

% fear → mostly Fear, some Anticipation, some Surprise
t(0.75) :: face_emotion_group(fear, fear) ;
t(0.15) :: face_emotion_group(fear, anticipation) ;
t(0.10) :: face_emotion_group(fear, surprise).

% happy → mostly Joy, some Trust, tiny bit Anticipation
t(0.80) :: face_emotion_group(happy, joy) ;
t(0.15) :: face_emotion_group(happy, trust) ;
t(0.05) :: face_emotion_group(happy, anticipation).

% sad → mostly Sadness, some Fear and Disgust
0.80 :: face_emotion_group(sad, sadness) ;
0.10 :: face_emotion_group(sad, fear) ;
0.10 :: face_emotion_group(sad, disgust).

% surprise → mostly Surprise, some Anticipation, some Fear
0.70 :: face_emotion_group(surprise, surprise) ;
0.20 :: face_emotion_group(surprise, anticipation) ;
0.10 :: face_emotion_group(surprise, fear).

% neutral → calm / baseline: Trust, some Joy, some Sadness
0.50 :: face_emotion_group(neutral, trust) ;
0.25 :: face_emotion_group(neutral, joy) ;
0.25 :: face_emotion_group(neutral, sadness).

% agriculture → calm / positive outdoors
0.70 :: scene_emotion_group(agriculture, joy) ;
0.20 :: scene_emotion_group(agriculture, trust) ;
0.10 :: scene_emotion_group(agriculture, anticipation).

% cold → lonely / threatening / unpleasant
0.60 :: scene_emotion_group(cold, sadness) ;
0.25 :: scene_emotion_group(cold, fear) ;
0.15 :: scene_emotion_group(cold, disgust).

% commercial → shopping, buzz, forward-looking
0.50 :: scene_emotion_group(commercial, anticipation) ;
0.30 :: scene_emotion_group(commercial, trust) ;
0.20 :: scene_emotion_group(commercial, joy).

% cultural → museums, events, positive engagement
0.60 :: scene_emotion_group(cultural, joy) ;
0.25 :: scene_emotion_group(cultural, trust) ;
0.15 :: scene_emotion_group(cultural, anticipation).

% depressing → clearly negative, heavy
t(0.75) :: scene_emotion_group(depressing, sadness) ;
t(0.15) :: scene_emotion_group(depressing, fear) ;
t(0.10) :: scene_emotion_group(depressing, disgust).

% food → tasty, appetitive, social
0.70 :: scene_emotion_group(food, joy) ;
0.20 :: scene_emotion_group(food, anticipation) ;
0.10 :: scene_emotion_group(food, trust).

% horeca (hotel/restaurant/café) → social & pleasant
0.65 :: scene_emotion_group(horeca, joy) ;
0.20 :: scene_emotion_group(horeca, trust) ;
0.15 :: scene_emotion_group(horeca, anticipation).

% house interior → home, safety, sometimes melancholy
0.55 :: scene_emotion_group(house_interior, trust) ;
0.30 :: scene_emotion_group(house_interior, joy) ;
0.15 :: scene_emotion_group(house_interior, sadness).

% industrial → harsh, polluted, unfriendly
0.45 :: scene_emotion_group(industrial, disgust) ;
0.30 :: scene_emotion_group(industrial, sadness) ;
0.25 :: scene_emotion_group(industrial, fear).

% nature → positive, calm, open
0.70 :: scene_emotion_group(nature, joy) ;
0.20 :: scene_emotion_group(nature, trust) ;
0.10 :: scene_emotion_group(nature, anticipation).

% playful → games, fun, excitement
0.70 :: scene_emotion_group(playful, joy) ;
0.20 :: scene_emotion_group(playful, surprise) ;
0.10 :: scene_emotion_group(playful, anticipation).

% relaxing → calm, safe, pleasant
0.70 :: scene_emotion_group(relaxing, joy) ;
0.25 :: scene_emotion_group(relaxing, trust) ;
0.05 :: scene_emotion_group(relaxing, anticipation).

% royal → grandeur, awe, respect
0.50 :: scene_emotion_group(royal, joy) ;
0.25 :: scene_emotion_group(royal, trust) ;
0.25 :: scene_emotion_group(royal, surprise).

% scary → obvious
0.70 :: scene_emotion_group(scary, fear) ;
0.20 :: scene_emotion_group(scary, surprise) ;
0.10 :: scene_emotion_group(scary, disgust).

% sport → competition, excitement, uncertainty
t(0.50) :: scene_emotion_group(sport, anticipation) ;
t(0.30) :: scene_emotion_group(sport, joy) ;
t(0.20) :: scene_emotion_group(sport, surprise).

% summer → warm, bright, holiday vibes
0.70 :: scene_emotion_group(summer, joy) ;
0.20 :: scene_emotion_group(summer, anticipation) ;
0.10 :: scene_emotion_group(summer, trust).

% transport → travel, waiting, risk
0.50 :: scene_emotion_group(transport, anticipation) ;
0.25 :: scene_emotion_group(transport, fear) ;
0.25 :: scene_emotion_group(transport, trust).

% urban → busy city: opportunities + stress
0.40 :: scene_emotion_group(urban, anticipation) ;
0.35 :: scene_emotion_group(urban, joy) ;
0.25 :: scene_emotion_group(urban, anger).

% woods → nature, but can be eerie
0.60 :: scene_emotion_group(woods, joy) ;
0.25 :: scene_emotion_group(woods, trust) ;
0.15 :: scene_emotion_group(woods, fear).

% work → structured, sometimes stressful / dull
0.45 :: scene_emotion_group(work, trust) ;
0.30 :: scene_emotion_group(work, anticipation) ;
0.25 :: scene_emotion_group(work, sadness).


all_different(E1, E2, E3):-
    \+ (E1 = E2),
    \+ (E1 = E3),
    \+ (E2 = E3).

% Two the same: positions 2 and 3
dominant_emotion(E1, E2, _, E1) :-
    E1 = E2.

dominant_emotion(E1, _, E3, E1) :-
    E1 = E3.

dominant_emotion(_, E2, E3, E2) :-
    E2 = E3.

% If there are no faces detected, only base the emotion on the scene context
final_emotion_0([], SceneTensor, FinalEmo):-
    scene_context(SceneTensor, ContextPred),
    scene_emotion_group(ContextPred, FinalEmo).

% Only one face detected, pick the emotion of that person
final_emotion_1([FaceTensor1], _, FinalEmo):-
    face_emotion(FaceTensor1, FaceEmo1Pred),
    face_emotion_group(FaceEmo1Pred, FinalEmo).

% Two faces detected, faces agree --> use face emotion
final_emotion_2([FaceTensor1, FaceTensor2], _ , FinalEmo):-
    face_emotion(FaceTensor1, FaceEmo1Pred),
    face_emotion(FaceTensor2, FaceEmo2Pred),
    face_emotion_group(FaceEmo1Pred, FinalEmo),
    face_emotion_group(FaceEmo2Pred, FinalEmo).

% Two faces detected, faces disagree --> use scene emotion
final_emotion_2([FaceTensor1, FaceTensor2], SceneTensor , FinalEmo):-
    face_emotion(FaceTensor1, FaceEmo1Pred),
    face_emotion(FaceTensor2, FaceEmo2Pred),
    face_emotion_group(FaceEmo1Pred, FaceEmo1),
    face_emotion_group(FaceEmo2Pred, FaceEmo2),
    \+ (FaceEmo1 = FaceEmo2),
    scene_context(SceneTensor, ContextPred),
    scene_emotion_group(ContextPred, FinalEmo).

% Three faces detected --> all same emotion --> output that emotion
final_emotion_3([FaceTensor1, FaceTensor2, FaceTensor3], _, FinalEmo):-
    face_emotion(FaceTensor1, FaceEmo1Pred),
    face_emotion(FaceTensor2, FaceEmo2Pred),
    face_emotion(FaceTensor3, FaceEmo3Pred),

    face_emotion_group(FaceEmo1Pred, FinalEmo),
    face_emotion_group(FaceEmo2Pred, FinalEmo),
    face_emotion_group(FaceEmo3Pred, FinalEmo).

% Three faces detected --> all different emotions --> output scene
final_emotion_3([FaceTensor1, FaceTensor2, FaceTensor3], SceneTensor, FinalEmo):-
    face_emotion(FaceTensor1, FaceEmo1Pred),
    face_emotion(FaceTensor2, FaceEmo2Pred),
    face_emotion(FaceTensor3, FaceEmo3Pred),

    face_emotion_group(FaceEmo1Pred, FaceEmo1),
    face_emotion_group(FaceEmo2Pred, FaceEmo2),
    face_emotion_group(FaceEmo3Pred, FaceEmo3),

    all_different(FaceEmo1, FaceEmo2, FaceEmo3),
    scene_context(SceneTensor, ContextPred),
    scene_emotion_group(ContextPred, FinalEmo).

% Three faces detected --> majority vote 
final_emotion_3([FaceTensor1, FaceTensor2, FaceTensor3], SceneTensor, FinalEmo):-
    face_emotion(FaceTensor1, FaceEmo1Pred),
    face_emotion(FaceTensor2, FaceEmo2Pred),
    face_emotion(FaceTensor3, FaceEmo3Pred),

    face_emotion_group(FaceEmo1Pred, FaceEmo1),
    face_emotion_group(FaceEmo2Pred, FaceEmo2),
    face_emotion_group(FaceEmo3Pred, FaceEmo3),

    dominant_emotion(FaceEmo1, FaceEmo2, FaceEmo3, FinalEmo).


