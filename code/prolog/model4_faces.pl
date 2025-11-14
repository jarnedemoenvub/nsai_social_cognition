nn(face_model, [Face], Emotion, [angry, disgust, fear, happy, sad, surprise, neutral]) :: face_emotion(Face, Emotion).

% Learnable combination of three faces
t(0.33)::weight(face_0); t(0.33)::weight(face_1); t(0.34)::weight(face_2).

final_emotion([F1, F2, F3], Final) :-
    face_emotion(F1, E1),
    face_emotion(F2, E2),
    face_emotion(F3, E3),
    emotion_group(E1, G1),
    emotion_group(E2, G2),
    emotion_group(E3, G3),
    weight(I),
    select_face(I, [G1,G2,G3], Final).

select_face(face_0, [E|_], E).
select_face(face_1, [_,E|_], E).
select_face(face_2, [_,_,E], E).

% Emotion grouping rules
emotion_group(angry, sad).
emotion_group(disgust, sad).
emotion_group(fear, sad).
emotion_group(sad, sad).
emotion_group(happy, happy).
emotion_group(surprise, neutral).
emotion_group(neutral, neutral).