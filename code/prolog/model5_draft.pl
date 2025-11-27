nn(face_model, [Face], Emotion,
   [angry, disgust, fear, happy, neutral, sad, surprise]) ::
   face_emotion(Face, Emotion).

nn(scene_model, [Scene], Cluster, [0, 1, 2, 3, 4, 5, 6, 7, 8]) ::
   scene_cluster(Scene, Cluster).

nn(combination_model, [FaceDistribution, ClusterId], FinalEmotion,
   [anger, anticipation, disgust, fear, joy, sadness, surprise, trust]) ::
   combine_features(FaceDistribution, ClusterId, FinalEmotion).

% Step 1: Find the predicted emotion and then call the one-hot generator
face_prob_vector(FaceTensor, Vector) :-
   face_emotion(FaceTensor, Emotion), % Find the *single* predicted emotion
   one_hot_vector(Emotion, Vector).

% Step 2: Define a clause for each emotion to generate the correct one-hot vector
% Vector order: [angry, disgust, fear, happy, neutral, sad, surprise]
one_hot_vector(angry, [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]).
one_hot_vector(disgust, [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]).
one_hot_vector(fear, [0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0]).
one_hot_vector(happy, [0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0]).
one_hot_vector(neutral, [0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0]).
one_hot_vector(sad, [0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0]).
one_hot_vector(surprise, [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0]).

sum_vectors([], [0,0,0,0,0,0,0]).
sum_vectors([Vec|Rest], Total) :-
   sum_vectors(Rest, Tail),
   sum_two_vectors(Vec, Tail, Total).

sum_two_vectors([], [], []).
sum_two_vectors([A|As], [B|Bs], [C|Cs]) :-
   C is A + B,
   sum_two_vectors(As, Bs, Cs).

% If there are no faces, then we pick neutral as the dominant face emotion
face_summary(FaceList, Summary) :-
   collect_vectors(FaceList, Vectors),
   % Sum vectors element wise
   sum_vectors(Vectors, Summary).

collect_vectors([], []).
collect_vectors([T|Ts], [V|Vs]) :-
   % For each face vector, one hot encode the face prediction
   % Append the vector to the list of vectors
   face_prob_vector(T, V),
   % Recursion
   collect_vectors(Ts, Vs).

final_emotion(FaceTensorList, SceneTensor, FinalEmo):-
   face_summary(FaceTensorList, FaceDistribution),
   scene_cluster(SceneTensor, ClusterId),
   combine_features(FaceDistribution, ClusterId, FinalEmo).

test_face_summary(FaceList, DominantEmo) :-
   face_summary(FaceList, DominantEmo).

test_sum_vectors(FaceList, SumVector) :-
   collect_vectors(FaceList, Vectors),
   sum_vectors(Vectors, SumVector).