nn(face_model, [Face], Emotion,
   [angry, disgust, fear, happy, neutral, sad, surprise]) ::
   face_emotion(Face, Emotion).

nn(scene_model, [Scene], Cluster, [0, 1, 2, 3, 4, 5, 6, 7, 8]) ::
   scene_cluster(Scene, Cluster).

nn(combination_model, [FaceVal, ClusterVal], FinalEmotion,
   [sad, neutral, happy]) ::
   combine_valences(FaceVal, ClusterVal, FinalEmotion).

t(_) :: cluster_valence(0, 1);
t(_) :: cluster_valence(0, 0);
t(_) :: cluster_valence(0, -1).

t(_) :: cluster_valence(1, 1);
t(_) :: cluster_valence(1, 0);
t(_) :: cluster_valence(1, -1).

t(_) :: cluster_valence(2, 1);
t(_) :: cluster_valence(2, 0);
t(_) :: cluster_valence(2, -1).

t(_) :: cluster_valence(3, 1);
t(_) :: cluster_valence(3, 0);
t(_) :: cluster_valence(3, -1).

t(_) :: cluster_valence(4, 1);
t(_) :: cluster_valence(4, 0);
t(_) :: cluster_valence(4, -1).

t(_) :: cluster_valence(5, 1);
t(_) :: cluster_valence(5, 0);
t(_) :: cluster_valence(5, -1).

t(_) :: cluster_valence(6, 1);
t(_) :: cluster_valence(6, 0);
t(_) :: cluster_valence(6, -1).

t(_) :: cluster_valence(7, 1);
t(_) :: cluster_valence(7, 0);
t(_) :: cluster_valence(7, -1).

t(_) :: cluster_valence(8, 1);
t(_) :: cluster_valence(8, 0);
t(_) :: cluster_valence(8, -1).

emotion_classes([angry, disgust, fear, happy, neutral, sad, surprise]).

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

% Entry point: Start checking from the second element (Index 1)
% Initialize Max with the first element (H) and Best Index with 0
get_max_index([H|T], Index) :-
   get_max_index(T, 1, H, 0, Index).

% Base Case: List is empty, return the current Best Index
get_max_index([], _, _, Best, Best).

% Recursive Step 1: Found a new max (Strictly greater)
get_max_index([H|T], I, Max, _, Out) :-
   H > Max,
   NewBest = I,
   Next is I + 1,
   get_max_index(T, Next, H, NewBest, Out).

% Recursive Step 2: Not a new max (Less than or equal)
get_max_index([H|T], I, Max, Best, Out) :-
   H =< Max,
   Next is I + 1,
   get_max_index(T, Next, Max, Best, Out).

% If there are no faces, then we pick neutral as the dominant face emotion
dominant_face_emotion([], neutral).
dominant_face_emotion(FaceList, DominantEmotion) :-
   collect_vectors(FaceList, Vectors),
   % Sum vectors element wise
   sum_vectors(Vectors, Sum),
   % Extract the max value --> dominant emotion
   get_max_index(Sum, MaxIndex),
   emotion_classes(Classes),
   nth0(MaxIndex, Classes, DominantEmotion).

collect_vectors([], []).
collect_vectors([T|Ts], [V|Vs]) :-
   % For each face vector, one hot encode the face prediction
   % Append the vector to the list of vectors
   face_prob_vector(T, V),
   % Recursion
   collect_vectors(Ts, Vs).

face_valence(angry, -1).
face_valence(disgust, -1).
face_valence(fear, -1).
face_valence(happy, 1).
face_valence(neutral, 0).
face_valence(sad, -1).

t(_) :: face_valence(surprise, -1);
t(_) :: face_valence(surprise, 0);
t(_) :: face_valence(surprise, 1).

final_emotion(FaceTensorList, SceneTensor, FinalEmo):-
   dominant_face_emotion(FaceTensorList, DominantFace),
   face_valence(DominantFace, FaceVal),
   scene_cluster(SceneTensor, Cluster),
   cluster_valence(Cluster, ClusterVal),
   combine_valences(FaceVal, ClusterVal, FinalEmo).

test_sum_vectors(FaceList, Sum):-
   collect_vectors(FaceList, Vectors),
   sum_vectors(Vectors, Sum).

test_max_index(FaceList, MaxIndex):-
   collect_vectors(FaceList, Vectors),
   % Sum vectors element wise
   sum_vectors(Vectors, Sum),
   % Extract the max value --> dominant emotion
   get_max_index(Sum, MaxIndex).

test_dominant_face_emotion(FaceList, DominantEmo) :-
   dominant_face_emotion(FaceList, DominantEmo).






