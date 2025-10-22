% =========================
%  Neural predicate (MoE)
% =========================
%   Faces      : tensor (3,7)  — logits per face (pad with zeros when absent)
%   Scene      : tensor (7)    — logits from your adapter (365→7), or zeros if missing
%   FacePres   : tensor (3)    — 0/1 flags for face slots (e.g., [1,1,0])
%   NumFaces   : tensor (1)    — integer 0..3 stored as a 1-d tensor
%
%   E ∈ {0..6} (emotion index)

nn(moe_net, [Faces, Scene, FacePres, NumFaces], E, [0,1,2,3,4,5,6])
    :: neural_emo(Faces, Scene, FacePres, NumFaces, E).

% =========================
%  Soft priors (symbolic)
% =========================

% baseline uniform priors
0.20::prior_emo(_, 0).
0.20::prior_emo(_, 1).
0.20::prior_emo(_, 2).
0.20::prior_emo(_, 3).
0.20::prior_emo(_, 4).
0.20::prior_emo(_, 5).
0.20::prior_emo(_, 6).

% fewer/no faces → damp emotions that rely on faces
0.10::prior_emo(ST, 0) :- NumFaces = 0.  % anger
0.10::prior_emo(ST, 1) :- NumFaces = 0.  % disgust
0.10::prior_emo(ST, 5) :- NumFaces = 0.  % surprise

% scene tags → boost/dampen certain emotions
0.60::prior_emo(party, 3).     % happy↑
0.15::prior_emo(funeral, 4).   % sad↑
0.15::prior_emo(funeral, 0).   % anger slightly↑

% ============================================
%  Combine neural MoE with the symbolic priors
% ============================================
final_emo(F, S, FP, N, ST, E) :-
    neural_emo(F, S, FP, N, E),
    prior_emo(ST, E).

