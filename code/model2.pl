% neural predicate
nn(moe_net, [FaceLogits, SceneLogits, FacePresent, NumFaces], E, [0,1,2,3,4,5,6])
    :: neural_emo(FaceLogits, SceneLogits, FacePresent, NumFaces, E).

% symbolic priors
0.10::prior_emo(M, 0) :- num_faces(M, 0).
0.60::prior_emo(M, 3) :- scene_tag(M, party).
0.15::prior_emo(M, 4) :- scene_tag(M, funeral).

% combine both
final_emo(FaceLogits, SceneLogits, FacePresent, NumFaces, Meta, E) :-
    neural_emo(FaceLogits, SceneLogits, FacePresent, NumFaces, E),
    prior_emo(Meta, E).

