% =========================
%  Neural predicate (MoE)
% =========================
%   Faces      : tensor (3,7)  — logits per face (pad with zeros when absent)
%   Scene      : tensor (7)    — logits from your adapter (365→7), or zeros if missing
%   FacePres   : tensor (3)    — 0/1 flags for face slots (e.g., [1,1,0])
%   NumFaces   : tensor (1)    — integer 0..3 stored as a 1-d tensor
%
%   E ∈ {0..6} (emotion index)

nn(moe_net, [Faces, Scene, FacePres, NumFacesT], E, [0,1,2,3,4,5,6])
    :: neural_emo(Faces, Scene, FacePres, NumFacesT, E).

% =========================
%  Soft priors (symbolic)
%  prior_emo(SceneTag, NumFacesScalar, Emotion)
% =========================

% baseline uniform priors (soft; never 0)
0.20::prior_emo(_, _, 0).
0.20::prior_emo(_, _, 1).
0.20::prior_emo(_, _, 2).
0.20::prior_emo(_, _, 3).
0.20::prior_emo(_, _, 4).
0.20::prior_emo(_, _, 5).
0.20::prior_emo(_, _, 6).

% --------- NUM_FACES BASED PRIORS (use =:= and >= with a ground NF) ---------

% No faces → isolation → neutral, sadness
0.55::prior_emo(_, NF, 6) :- NF =:= 0.
0.35::prior_emo(_, NF, 4) :- NF =:= 0.
0.10::prior_emo(_, NF, 2) :- NF =:= 0.

% One face → interpersonal → more emotional variance
0.45::prior_emo(_, NF, 3) :- NF =:= 1.
0.25::prior_emo(_, NF, 4) :- NF =:= 1.
0.15::prior_emo(_, NF, 2) :- NF =:= 1.
0.15::prior_emo(_, NF, 6) :- NF =:= 1.

% Two faces → social or interactional → happy / surprise
0.55::prior_emo(_, NF, 3) :- NF =:= 2.
0.25::prior_emo(_, NF, 5) :- NF =:= 2.
0.20::prior_emo(_, NF, 6) :- NF =:= 2.

% Three or more faces → group excitement / crowd → happy / surprise / anger
0.50::prior_emo(_, NF, 3) :- NF >= 3.
0.30::prior_emo(_, NF, 5) :- NF >= 3.
0.20::prior_emo(_, NF, 0) :- NF >= 3.

% --------- SCENE TAG × NUM_FACES COMBINATIONS ---------

% Party-like scenes with many faces → happiness/surprise
0.70::prior_emo(sports_and_entertainment, NF, 3) :- NF >= 2.
0.60::prior_emo(indoor_commercial,       NF, 3) :- NF >= 2.
0.50::prior_emo(urban_outdoor,           NF, 3) :- NF >= 2.
0.40::prior_emo(urban_outdoor,           NF, 5) :- NF >= 2.

% Religious or historical site + no people → sadness/neutral
0.60::prior_emo(religious_or_historical_site, NF, 4) :- NF =:= 0.
0.30::prior_emo(religious_or_historical_site, NF, 6) :- NF =:= 0.

% Natural landscape with no people → calm/neutral (+some happy)
0.70::prior_emo(natural_landscape, NF, 6) :- NF =:= 0.
0.30::prior_emo(natural_landscape, NF, 3) :- NF =:= 0.

% Industrial facility with many people → stress/anger/disgust
0.50::prior_emo(industrial_facility, NF, 0) :- NF >= 2.
0.40::prior_emo(industrial_facility, NF, 1) :- NF >= 2.

% Cold or aquatic environment + no faces → neutral/reflective
0.60::prior_emo(cold_environment,    NF, 6) :- NF =:= 0.
0.40::prior_emo(aquatic_environment, NF, 6) :- NF =:= 0.

% --------- SCENE-TAG ONLY PRIORS (always apply; soft) ---------

0.50::prior_emo(aquatic_environment,             _, 3).
0.30::prior_emo(aquatic_environment,             _, 6).
0.10::prior_emo(aquatic_environment,             _, 4).

0.45::prior_emo(cold_environment,                _, 6).
0.35::prior_emo(cold_environment,                _, 5).
0.20::prior_emo(cold_environment,                _, 2).
0.10::prior_emo(cold_environment,                _, 4).

0.50::prior_emo(cultural_space,                  _, 6).
0.30::prior_emo(cultural_space,                  _, 3).
0.20::prior_emo(cultural_space,                  _, 5).

0.55::prior_emo(indoor_commercial,               _, 3).
0.25::prior_emo(indoor_commercial,               _, 6).
0.10::prior_emo(indoor_commercial,               _, 5).

0.40::prior_emo(indoor_institutional,            _, 6).
0.25::prior_emo(indoor_institutional,            _, 3).
0.25::prior_emo(indoor_institutional,            _, 4).
0.10::prior_emo(indoor_institutional,            _, 0).

0.50::prior_emo(indoor_residential,              _, 3).
0.25::prior_emo(indoor_residential,              _, 6).
0.15::prior_emo(indoor_residential,              _, 4).
0.10::prior_emo(indoor_residential,              _, 2).

0.45::prior_emo(industrial_facility,             _, 1).
0.30::prior_emo(industrial_facility,             _, 0).
0.15::prior_emo(industrial_facility,             _, 6).
0.10::prior_emo(industrial_facility,             _, 2).

0.55::prior_emo(natural_landscape,               _, 6).
0.35::prior_emo(natural_landscape,               _, 3).
0.20::prior_emo(natural_landscape,               _, 5).

0.45::prior_emo(religious_or_historical_site,    _, 4).
0.35::prior_emo(religious_or_historical_site,    _, 6).
0.20::prior_emo(religious_or_historical_site,    _, 3).

0.50::prior_emo(rural_or_recreational_area,      _, 3).
0.30::prior_emo(rural_or_recreational_area,      _, 6).
0.20::prior_emo(rural_or_recreational_area,      _, 5).

0.60::prior_emo(sports_and_entertainment,        _, 3).
0.25::prior_emo(sports_and_entertainment,        _, 5).
0.15::prior_emo(sports_and_entertainment,        _, 6).

0.45::prior_emo(transport_infrastructure,        _, 6).
0.30::prior_emo(transport_infrastructure,        _, 2).
0.25::prior_emo(transport_infrastructure,        _, 4).

0.45::prior_emo(urban_outdoor,                   _, 6).
0.30::prior_emo(urban_outdoor,                   _, 3).
0.15::prior_emo(urban_outdoor,                   _, 0).
0.10::prior_emo(urban_outdoor,                   _, 1).

% ============================================
%  Combine neural MoE with the symbolic priors
% ============================================
final_emo(F, S, FP, NFT, ST, NF, E) :-
    neural_emo(F, S, FP, NFT, E),
    prior_emo(ST, NF, E).

