nn(face_model, [Face], Emotion,
   [angry, disgust, fear, happy, neutral, sad, surprise]) ::
   face_emotion(Face, Emotion).

nn(scene_model, [Scene], Cluster, [0, 1, 2, 3, 4, 5, 6, 7, 8]) ::
   scene_cluster(Scene, Cluster).

final_emotion_0([], SceneTensor, FinalEmo) :-
   dont_move_to_neighbour,
   scene_cluster(SceneTensor, Cluster),
   va_cluster(Cluster, Valence, Arousal),
   va_emotion(Valence, Arousal, FinalEmo).

final_emotion_0([], SceneTensor, FinalEmo):-
   scene_cluster(SceneTensor, Cluster),
   va_cluster(Cluster, Valence, Arousal),
   % In case move_to_neighbour is true
   move_to_neighbour,
   % With 50% chance choose neighbour of Valence, 50% choose neighbour of Arousal (make probs trainable)
   va_neighbour(Valence, Arousal, FinalEmo).

final_emotion_0([], SceneTensor, FinalEmo):-
   dont_move_to_neighbour,
   scene_cluster(SceneTensor, Cluster),
   va_cluster(Cluster, Valence, Arousal),
   % In case no emotion was found for the valence/arousal combo, find the nearest neighbour
   \+ va_emotion(Valence, Arousal, _),
   % With 50% chance choose neighbour of Valence, 50% choose neighbour of Arousal (make probs trainable)
   va_neighbour(Valence, Arousal, FinalEmo).

higher_value(very_low, low).
higher_value(very_low, mid).
higher_value(very_low, high).
higher_value(very_low, very_high).

higher_value(low, mid).
higher_value(low, high).
higher_value(low, very_high).

higher_value(mid, high).
higher_value(mid, very_high).

higher_value(high, very_high).

lower_value(very_high, high).
lower_value(very_high, mid).
lower_value(very_high, low).
lower_value(very_high, very_low).

lower_value(high, mid).
lower_value(high, low).
lower_value(high, very_low).

lower_value(mid, low).
lower_value(mid, very_low).

lower_value(low, very_low).

t(0.5) :: valence_or_arousal(arousal);
t(0.5) :: valence_or_arousal(valence).

t(0.5) :: higher_or_lower(higher);
t(0.5) :: higher_or_lower(lower).

t(0.15) :: move_to_neighbour;
t(0.85) :: dont_move_to_neighbour.

% Valence
va_neighbour(very_high, Arousal, FinalEmo):-
   valence_or_arousal(valence),
   % If feature is valence, we change the valence
   % If valence is already the lowest or highest value, we can already change that
   lower_value(very_high, NewValence),
   va_emotion(NewValence, Arousal, FinalEmo).

va_neighbour(very_low, Arousal, FinalEmo):-
   valence_or_arousal(valence),
   % If feature is valence, we change the valence
   % If valence is already the lowest or highest value, we can already change that
   higher_value(very_low, NewValence),
   va_emotion(NewValence, Arousal, FinalEmo).

va_neighbour(Valence, Arousal, FinalEmo):-
   valence_or_arousal(valence),
   % If feature is valence, we change the valence
   % We change it to a higher value
   higher_or_lower(higher),
   higher_value(Valence, NewValence),
   va_emotion(NewValence, Arousal, FinalEmo).

va_neighbour(Valence, Arousal, FinalEmo):-
   valence_or_arousal(valence),
   % If feature is valence, we change the valence
   % We change it to a lower value
   higher_or_lower(lower),
   lower_value(Valence, NewValence),
   va_emotion(NewValence, Arousal, FinalEmo).

% Arousal
va_neighbour(Valence, very_high, FinalEmo):-
   valence_or_arousal(arousal),
   % If feature is valence, we change the valence
   % If valence is already the lowest or highest value, we can already change that
   lower_value(very_high, NewArousal),
   va_emotion(Valence, NewArousal, FinalEmo).

va_neighbour(Valence, very_low, FinalEmo):-
   valence_or_arousal(arousal),
   % If feature is valence, we change the valence
   % If valence is already the lowest or highest value, we can already change that
   higher_value(very_low, NewArousal),
   va_emotion(Valence, NewArousal, FinalEmo).

va_neighbour(Valence, Arousal, FinalEmo):-
   valence_or_arousal(arousal),
   % If feature is valence, we change the valence
   % We change it to a higher value
   higher_or_lower(higher),
   higher_value(Arousal, NewArousal),
   va_emotion(Valence, NewArousal, FinalEmo).

va_neighbour(Valence, Arousal, FinalEmo):-
   valence_or_arousal(arousal),
   % If feature is valence, we change the valence
   % We change it to a lower value
   higher_or_lower(lower),
   lower_value(Arousal, NewArousal),
   va_emotion(Valence, NewArousal, FinalEmo).

% Zorg ervoor dat elke cluster wel naar een emotie mapt en dat alle emoties ook effectief bereikbaar zijn!
va_cluster(0, very_low, very_high).
va_cluster(1, mid, mid).
va_cluster(2, low, mid).
va_cluster(3, very_high, high).
va_cluster(4, very_high, low).
va_cluster(5, high, very_low).
va_cluster(6, mid, very_low).
va_cluster(7, low, high).
va_cluster(8, very_high, very_low).

t(_)::va_emotion(high, very_low, acceptance);
t(_)::va_emotion(high, very_low, interest).

t(_)::va_emotion(very_high, mid, admiration);
t(_)::va_emotion(very_high, mid, amazement);
t(_)::va_emotion(very_high, mid, joy).

t(_)::va_emotion(very_low, high, anger);
t(_)::va_emotion(very_low, high, fear);
t(_)::va_emotion(very_low, high, loathing);
t(_)::va_emotion(very_low, high, sadness).

va_emotion(very_low, low, annoyance).
t(_)::va_emotion(mid, low, anticipation);
t(_)::va_emotion(mid, low, surprise).

t(_)::va_emotion(low, low, apprehension);
t(_)::va_emotion(low, low, pensiveness).

va_emotion(low, very_low, boredom).
va_emotion(very_low, mid, disgust).
va_emotion(mid, very_low, distraction).
va_emotion(very_high, high, ecstasy).

% Cluster 0
t(_)::va_emotion(very_low, very_high, grief);
t(_)::va_emotion(very_low, very_high, rage);
t(_)::va_emotion(very_low, very_high, terror).

va_emotion(very_high, very_low, serenity).
va_emotion(very_high, low, trust).

% Cluster 1
va_emotion(mid, mid, vigilance).
