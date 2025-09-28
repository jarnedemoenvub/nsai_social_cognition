
nn(face_net,[X],Y,[0,1,2,3,4,5,6]) :: emotion(X,Y).

face_emotion_predict(X, EmotionIdx) :-
    emotion(X, EmotionIdx).
