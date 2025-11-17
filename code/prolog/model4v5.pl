% ============================================================
% Neural predicates
% ============================================================

nn(face_model, [Face], Emotion,
   [angry, disgust, fear, happy, neutral, sad, surprise]) ::
   face_emotion(Face, Emotion).

nn(scene_model, [Scene], Context, [0,1,2,3,4,5,6,7,8,9]) ::
   scene_context(Scene, Context).

face_va(angry,    neg, high).
face_va(disgust,  neg, mid).
face_va(fear,     neg, high).
face_va(happy,    pos, high).
face_va(neutral,  mid, mid).
face_va(sad,      neg, low).
face_va(surprise, mid, high).

cluster_va(0, pos, low).
cluster_va(1, mid, mid).
cluster_va(2, pos, mid).
cluster_va(3, mid, low).
cluster_va(4, mid, high).
cluster_va(5, pos, low).
cluster_va(6, pos, high).
cluster_va(7, neg, high).
cluster_va(8, pos, high).
cluster_va(9, pos, low).


va_bucket(neg,  low,  bucket_neg).
va_bucket(neg,  mid,  bucket_neg).
va_bucket(neg,  high, bucket_neg).

va_bucket(mid,  _,    bucket_mid).

va_bucket(pos,  low,  bucket_pos).
va_bucket(pos,  mid,  bucket_pos).
va_bucket(pos,  high, bucket_pos).


0.45 :: bucket_emotion(bucket_neg, anger).
0.45 :: bucket_emotion(bucket_neg, sadness).

t(_) :: bucket_emotion(bucket_neg, disgust).
t(_) :: bucket_emotion(bucket_neg, fear).
t(_) :: bucket_emotion(bucket_neg, surprise).
t(_) :: bucket_emotion(bucket_neg, joy).
t(_) :: bucket_emotion(bucket_neg, trust).
t(_) :: bucket_emotion(bucket_neg, anticipation).


t(_) :: bucket_emotion(bucket_mid, anger).
t(_) :: bucket_emotion(bucket_mid, sadness).
t(_) :: bucket_emotion(bucket_mid, disgust).
t(_) :: bucket_emotion(bucket_mid, fear).
t(_) :: bucket_emotion(bucket_mid, surprise).
t(_) :: bucket_emotion(bucket_mid, joy).
t(_) :: bucket_emotion(bucket_mid, trust).
t(_) :: bucket_emotion(bucket_mid, anticipation).

0.45 :: bucket_emotion(bucket_pos, joy).
0.45 :: bucket_emotion(bucket_pos, trust).

t(_) :: bucket_emotion(bucket_pos, anticipation).
t(_) :: bucket_emotion(bucket_pos, surprise).
t(_) :: bucket_emotion(bucket_pos, anger).
t(_) :: bucket_emotion(bucket_pos, sadness).
t(_) :: bucket_emotion(bucket_pos, disgust).
t(_) :: bucket_emotion(bucket_pos, fear).

va_to_emotion(Val, Arou, Emotion) :-
    va_bucket(Val, Arou, B),
    bucket_emotion(B, Emotion).

final_emotion_0([], SceneTensor, FinalEmo) :-
    scene_context(SceneTensor, Cluster),
    cluster_va(Cluster, Val, Arou),
    va_to_emotion(Val, Arou, FinalEmo).
