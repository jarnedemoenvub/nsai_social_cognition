nn(multi_face_net, [X], Y,
    [0,1,2,3,4,5,6,
     7,8,9,10,11,12,13,
     14,15,16,17,18,19,20]) :: face_flat(X,Y).

nn(scene2emo_net, [X], E, [0,1,2,3,4,5,6]) :: scene_emotion(X, E).


flat_index(FaceIdx, EmoIdx, Flat) :- Flat is FaceIdx * 7 + EmoIdx.

face_emotion_prob(X, FaceIdx, EmoIdx) :-
    var(EmoIdx),
    between(0, 6, EmoIdx),
    flat_index(FaceIdx, EmoIdx, Flat),
    face_flat(X, Flat).

face_emotion_prob(X, FaceIdx, EmoIdx) :-
    nonvar(EmoIdx),
    flat_index(FaceIdx, EmoIdx, Flat),
    face_flat(X, Flat).

t(_)::use(face,0); t(_)::use(face,1); t(_)::use(face,2); t(_)::use(scene).

base_emotion(Faces, Scene, EmoIdx) :-
    use(face,0), face_emotion_prob(Faces, 0, EmoIdx).
base_emotion(Faces, Scene, EmoIdx) :-
    use(face,1), face_emotion_prob(Faces, 1, EmoIdx).
base_emotion(Faces, Scene, EmoIdx) :-
    use(face,2), face_emotion_prob(Faces, 2, EmoIdx).
base_emotion(FaceImg, SceneImg, EmoIdx) :-
    use(scene),
    scene_emotion(SceneImg, EmoIdx).

final_findingemo(Faces, Scene, FEIdx) :-
    base_emotion(Faces, Scene, FEIdx).