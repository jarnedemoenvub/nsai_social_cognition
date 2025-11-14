% -------------------------------
% Neural predicates
% -------------------------------
nn(face_model, [Face], Emotion,
   [angry, disgust, fear, happy, neutral, sad, surprise]) ::
   face_emotion_raw(Face, Emotion).

nn(scene_model, [Scene], Context,
   [agriculture, cold, commercial, cultural, depressing, food, horeca, 
    house_interior, industrial, nature, playful, relaxing, royal, scary, sport, 
    summer, transport, urban, woods, work]) :: scene_context(Scene, Context).

% -------------------------------
% Emotion grouping
% -------------------------------
emotion_group(angry, sad).
emotion_group(disgust, sad).
emotion_group(fear, sad).
emotion_group(sad, sad).
emotion_group(happy, happy).
emotion_group(surprise, neutral).
emotion_group(neutral, neutral).

% Map raw face emotion to grouped emotion
face_emotion(Face, Grouped) :-
    face_emotion_raw(Face, Raw),
    emotion_group(Raw, Grouped).

% -------------------------------
% Face aggregation with learnable weights
% -------------------------------
t(_)::use_face(0).
t(_)::use_face(1).
t(_)::use_face(2).

% Get the dominant face's grouped emotion
aggregate_faces([F1, F2, F3], Agg) :-
    face_emotion(F1, E1),
    face_emotion(F2, E2),
    face_emotion(F3, E3),
    ( (use_face(0), Agg = E1) ;
      (use_face(1), Agg = E2) ;
      (use_face(2), Agg = E3) ).

% -------------------------------
% Scene-based emotion suggestion
% -------------------------------
context_emotion(playful, happy).
context_emotion(sport, happy).
context_emotion(food, happy).
context_emotion(royal, happy).
context_emotion(relaxing, happy).
context_emotion(cultural, happy).
context_emotion(horeca, happy).
context_emotion(summer, happy).
context_emotion(depressing, sad).
context_emotion(scary, sad).
context_emotion(cold, sad).
context_emotion(house_interior, neutral).
context_emotion(industrial, neutral).
context_emotion(urban, neutral).
context_emotion(transport, neutral).
context_emotion(nature, neutral).
context_emotion(agriculture, neutral).
context_emotion(woods, neutral).
context_emotion(work, neutral).
context_emotion(commercial, neutral).

% Default: use neutral for unmatched contexts
scene_emotion(Scene, Emo) :-
    scene_context(Scene, Ctx),
    (context_emotion(Ctx, Emo) ; Emo = neutral).

% -------------------------------
% Final decision: trust scene or faces
% -------------------------------
0.5::trust_scene.

final_emotion([F1, F2, F3], Scene, Final) :-
    aggregate_faces([F1, F2, F3], FaceEmo),
    scene_emotion(Scene, SceneEmo),
    ( (trust_scene, Final = SceneEmo) ;
      (\+ trust_scene, Final = FaceEmo) ).