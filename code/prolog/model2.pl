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

% SCENE TAG × NUM_FACES COMBINATIONS
0.70::prior_emo(sports_and_entertainment, NF, 3) :- NF >= 2.

% SCENE-TAG ONLY PRIORS

0.50::prior_emo(aquatic_environment ,_, 3).
0.30::prior_emo(aquatic_environment, _, 6).

0.55::prior_emo(natural_landscape, _, 6).
0.35::prior_emo(natural_landscape, _, 3).

0.60::prior_emo(sports_and_entertainment, _, 3).

% ============================================
%  Combine neural MoE with the symbolic priors
% ============================================
final_emo(F, S, FP, NFT, ST, NF, E) :-
    neural_emo(F, S, FP, NFT, E).
    % prior_emo(ST, NF, E).

