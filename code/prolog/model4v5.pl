nn(face_model, [Face], Emotion,
   [angry, disgust, fear, happy, neutral, sad, surprise]) ::
   face_emotion(Face, Emotion).

nn(scene_model, [Scene], Context, [0,1,2,3,4,5,6,7,8,9]) ::
   scene_context(Scene, Context).

% valence_scale(very_low).
% valence_scale(low).
% valence_scale(mid).
% valence_scale(high).
% valence_scale(very_high).

% arousal_scale(very_low).
% arousal_scale(low).
% arousal_scale(mid).
% arousal_scale(high).
% arousal_scale(very_high).

% face_val_ar(angry, low, high).
% face_val_ar(disgust,low, mid).
% face_val_ar(fear, low, high).
% face_val_ar(happy, high, high).
% face_val_ar(neutral, mid, low).
% face_val_ar(sad, low,  low).
% face_val_ar(surprise, mid, high).


cluster_val_ar(0, high, low).  % calm_everyday_interiors
cluster_val_ar(1, mid, mid). % urban_strain_discomfort
cluster_val_ar(2, high, mid). % comforting_social_outdoors
cluster_val_ar(3, mid, low). % neutral_transit_mobility
cluster_val_ar(4, mid, high). % lively_social_gatherings
cluster_val_ar(5, very_high, very_low). % peaceful_natural_retreats
cluster_val_ar(6, very_high, very_high). % exotic_high_valence_wonderlands
cluster_val_ar(7, low, high). % threatening_environments
cluster_val_ar(8, high, high). % high_energy_nature_leisure
cluster_val_ar(9, very_high, low). % comforting_family_leisure


% emotion(joy).
% emotion(trust).
% emotion(fear).
% emotion(surprise).
% emotion(sadness).
% emotion(disgust).
% emotion(anger).
% emotion(anticipation).


va_bucket(low, low, bucket_ll). 
va_bucket(low, mid, bucket_lm).
va_bucket(low, high, bucket_lh).    

va_bucket(mid, low, bucket_ml).
va_bucket(mid, mid, bucket_mm).    
va_bucket(mid, high, bucket_mh).

va_bucket(high, low, bucket_hl).
va_bucket(high, mid, bucket_hm).
va_bucket(high, high, bucket_hh).   

t(_) :: bucket_emotion(bucket_ll, joy).
t(_) :: bucket_emotion(bucket_lm, joy).
t(_) :: bucket_emotion(bucket_lh, joy).
t(_) :: bucket_emotion(bucket_ml, joy).
t(_) :: bucket_emotion(bucket_mm, joy).
t(_) :: bucket_emotion(bucket_mh, joy).
t(_) :: bucket_emotion(bucket_hl, joy).
t(_) :: bucket_emotion(bucket_hm, joy).
t(_) :: bucket_emotion(bucket_hh, joy).

t(_) :: bucket_emotion(bucket_ll, trust).
t(_) :: bucket_emotion(bucket_lm, trust).
t(_) :: bucket_emotion(bucket_lh, trust).
t(_) :: bucket_emotion(bucket_ml, trust).
t(_) :: bucket_emotion(bucket_mm, trust).
t(_) :: bucket_emotion(bucket_mh, trust).
t(_) :: bucket_emotion(bucket_hl, trust).
t(_) :: bucket_emotion(bucket_hm, trust).
t(_) :: bucket_emotion(bucket_hh, trust).

t(_) :: bucket_emotion(bucket_ll, fear).
t(_) :: bucket_emotion(bucket_lm, fear).
t(_) :: bucket_emotion(bucket_lh, fear).
t(_) :: bucket_emotion(bucket_ml, fear).
t(_) :: bucket_emotion(bucket_mm, fear).
t(_) :: bucket_emotion(bucket_mh, fear).
t(_) :: bucket_emotion(bucket_hl, fear).
t(_) :: bucket_emotion(bucket_hm, fear).
t(_) :: bucket_emotion(bucket_hh, fear).

t(_) :: bucket_emotion(bucket_ll, surprise).
t(_) :: bucket_emotion(bucket_lm, surprise).
t(_) :: bucket_emotion(bucket_lh, surprise).
t(_) :: bucket_emotion(bucket_ml, surprise).
t(_) :: bucket_emotion(bucket_mm, surprise).
t(_) :: bucket_emotion(bucket_mh, surprise).
t(_) :: bucket_emotion(bucket_hl, surprise).
t(_) :: bucket_emotion(bucket_hm, surprise).
t(_) :: bucket_emotion(bucket_hh, surprise).

t(_) :: bucket_emotion(bucket_ll, sadness).
t(_) :: bucket_emotion(bucket_lm, sadness).
t(_) :: bucket_emotion(bucket_lh, sadness).
t(_) :: bucket_emotion(bucket_ml, sadness).
t(_) :: bucket_emotion(bucket_mm, sadness).
t(_) :: bucket_emotion(bucket_mh, sadness).
t(_) :: bucket_emotion(bucket_hl, sadness).
t(_) :: bucket_emotion(bucket_hm, sadness).
t(_) :: bucket_emotion(bucket_hh, sadness).

t(_) :: bucket_emotion(bucket_ll, disgust).
t(_) :: bucket_emotion(bucket_lm, disgust).
t(_) :: bucket_emotion(bucket_lh, disgust).
t(_) :: bucket_emotion(bucket_ml, disgust).
t(_) :: bucket_emotion(bucket_mm, disgust).
t(_) :: bucket_emotion(bucket_mh, disgust).
t(_) :: bucket_emotion(bucket_hl, disgust).
t(_) :: bucket_emotion(bucket_hm, disgust).
t(_) :: bucket_emotion(bucket_hh, disgust).

t(_) :: bucket_emotion(bucket_ll, anger).
t(_) :: bucket_emotion(bucket_lm, anger).
t(_) :: bucket_emotion(bucket_lh, anger).
t(_) :: bucket_emotion(bucket_ml, anger).
t(_) :: bucket_emotion(bucket_mm, anger).
t(_) :: bucket_emotion(bucket_mh, anger).
t(_) :: bucket_emotion(bucket_hl, anger).
t(_) :: bucket_emotion(bucket_hm, anger).
t(_) :: bucket_emotion(bucket_hh, anger).

t(_) :: bucket_emotion(bucket_ll, anticipation).
t(_) :: bucket_emotion(bucket_lm, anticipation).
t(_) :: bucket_emotion(bucket_lh, anticipation).
t(_) :: bucket_emotion(bucket_ml, anticipation).
t(_) :: bucket_emotion(bucket_mm, anticipation).
t(_) :: bucket_emotion(bucket_mh, anticipation).
t(_) :: bucket_emotion(bucket_hl, anticipation).
t(_) :: bucket_emotion(bucket_hm, anticipation).
t(_) :: bucket_emotion(bucket_hh, anticipation).


scene_va_to_emotion(Val, Arou, Emotion) :-
    va_bucket(Val, Arou, Bucket),
    bucket_emotion(Bucket, Emotion).

final_emotion_0([], SceneTensor, FinalEmo) :-
    scene_context(SceneTensor, Cluster),
    cluster_val_ar(Cluster, Val, Arou),
    scene_va_to_emotion(Val, Arou, FinalEmo).
