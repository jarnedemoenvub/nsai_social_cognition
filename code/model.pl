% ============================================================
% NEUROSYMBOLIC EMOTION FUSION MODEL (WITH FINDINGEMO OUTPUT)
% ============================================================

% ============================
% 1. NEURAL COMPONENTS
% ============================

nn(multi_face_net, [X], Y,
    [0,1,2,3,4,5,6,
     7,8,9,10,11,12,13,
     14,15,16,17,18,19,20,
     21,22,23,24,25,26,27,
     28,29,30,31,32,33,34]) :: face_flat(X,Y).

nn(scene_net, [X], Y, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364]) :: scene_raw(X,Y).
nn(scene2emo_net, [X], E, [0,1,2,3,4,5,6]) :: scene_emotion(X,E).

% ============================
% 2. SYMBOLIC KNOWLEDGE BASE
% ============================

% --- Prototype-based scene valence priors ---
0.9::joy_scene(48).    % beach
0.8::joy_scene(62).    % botanical_garden
0.85::joy_scene(235).  % movie_theater
0.9::joy_scene(268).   % playground
0.8::joy_scene(353).   % water_park
0.8::joy_scene(355).   % waterfall

0.85::sad_scene(86).   % cemetery
0.8::sad_scene(178).   % hospital
0.75::sad_scene(179).  % hospital_room
0.85::sad_scene(196).  % jail_cell
0.8::sad_scene(241).   % nursing_home
0.75::sad_scene(308).  % slum

0.85::neutral_scene(45).   % bathroom
0.8::neutral_scene(92).    % classroom
0.8::neutral_scene(101).   % conference_center
0.8::neutral_scene(176).   % home_office
0.85::neutral_scene(244).  % office
0.8::neutral_scene(319).   % street

% --- Scene valence (with fallback) ---
scene_valence(X, positive) :- scene_raw(X,S), joy_scene(S).
scene_valence(X, negative) :- scene_raw(X,S), sad_scene(S).
scene_valence(X, neutral)  :- scene_raw(X,S), neutral_scene(S).
scene_valence(X, unknown)  :- scene_raw(X,S),
                              \+ joy_scene(S),
                              \+ sad_scene(S),
                              \+ neutral_scene(S).

% --- Base emotion groups ---
emotion_group(0, negative).  % angry
emotion_group(1, negative).  % disgust
emotion_group(2, negative).  % fear
emotion_group(3, positive).  % happy
emotion_group(4, negative).  % sad
emotion_group(5, positive).  % surprise
emotion_group(6, neutral).   % neutral


% ============================
% 3. TRAINABLE WEIGHTS
% ============================

% t(_)::w_face(0).
% t(_)::w_face(1).
% t(_)::w_face(2).
% t(_)::w_face(3).
% t(_)::w_face(4).
% t(_)::w_scene.
% t(_)::w_scene_unknown.

0.8::w_face(0).
0.2::w_face(1).
0.0::w_face(2).
0.0::w_face(3).
0.0::w_face(4).
0.5::w_scene.
0.1::w_scene_unknown.


% ============================
% 4. FACE AND SCENE FEATURES
% ============================

flat_index(FaceIdx, EmoIdx, Flat) :- Flat is FaceIdx * 7 + EmoIdx.

face_emotion_prob(X, FaceIdx, EmoIdx) :-
    between(0, 4, FaceIdx),  
    between(0, 6, EmoIdx),
    flat_index(FaceIdx, EmoIdx, Flat),
    face_flat(X, Flat).


% ============================
% 5. SYMBOLIC SCENE SUPPORT
% ============================

symbolic_scene_support(SceneImg, EmoIdx) :-
    scene_valence(SceneImg, Val),
    Val \= unknown,
    emotion_group(EmoIdx, Val),
    w_scene.

symbolic_scene_support(SceneImg, 6) :-  % fallback to neutral
    scene_valence(SceneImg, unknown),
    w_scene_unknown.


% ============================
% 6. FUSION: BASE EMOTION PROBABILITY
% ============================

final_emotion(FaceImg, SceneImg, EmoIdx) :-
    w_face(FIdx),
    face_emotion_prob(FaceImg, FIdx, EmoIdx).

final_emotion(FaceImg, SceneImg, EmoIdx) :-
    symbolic_scene_support(SceneImg, EmoIdx).

final_emotion(FaceImg, SceneImg, EmoIdx) :-
    w_scene,
    scene_raw(SceneImg, SceneVec),
    scene_emotion(SceneVec, EmoIdx).


% ============================
% 7. MAPPING TO FINDINGEMO INDEX SPACE
% ============================
% Each base emotion (0–6) maps to one or several FindingEmo categories (0–23).

% Angry → anger-related emotions
0.8::mapped_emotion(0, 4).   % Anger
0.1::mapped_emotion(0, 13).  % Rage
0.1::mapped_emotion(0, 14).  % Annoyance

% Disgust → loathing/disgust
0.7::mapped_emotion(1, 23).  % Disgust
0.3::mapped_emotion(1, 21).  % Loathing

% Fear → fear/apprehension/terror/vigilance
0.4::mapped_emotion(2, 10).  % Fear
0.2::mapped_emotion(2, 2).   % Apprehension
0.2::mapped_emotion(2, 16).  % Terror
0.2::mapped_emotion(2, 11).  % Vigilance

% Happy → joy/ecstasy/serenity/admiration/acceptance
0.4::mapped_emotion(3, 5).   % Joy
0.2::mapped_emotion(3, 9).   % Ecstasy
0.2::mapped_emotion(3, 7).   % Serenity
0.1::mapped_emotion(3, 20).  % Admiration
0.1::mapped_emotion(3, 15).  % Acceptance

% Sad → sadness/grief/pensiveness
0.5::mapped_emotion(4, 12).  % Sadness
0.3::mapped_emotion(4, 6).   % Grief
0.2::mapped_emotion(4, 19).  % Pensiveness

% Surprise → surprise/amaze/distraction
0.5::mapped_emotion(5, 18).  % Surprise
0.3::mapped_emotion(5, 17).  % Amazement
0.2::mapped_emotion(5, 22).  % Distraction

% Neutral → boredom/serenity/acceptance
0.4::mapped_emotion(6, 8).   % Boredom
0.3::mapped_emotion(6, 7).   % Serenity
0.3::mapped_emotion(6, 15).  % Acceptance


% --- Final output: in FindingEmo space (0–23) ---
final_findingemo(Faces, Scene, FEIdx) :-
    final_emotion(Faces, Scene, BaseIdx),
    mapped_emotion(BaseIdx, FEIdx).


% ============================
% 8. EXPLAINABILITY QUERIES
% ============================

% Query examples:
%   ?- query(final_findingemo(Faces, Scene, E)).
%   ?- query(w_face(0)).
%   ?- query(w_scene).
%
% Interpretation:
%   face0: 0.42, face1: 0.20, face2: 0.15, face3: 0.08, face4: 0.05, scene: 0.10
%   → 42% of decision from face0, 10% from scene.
%
% Base-to-FindingEmo mapping allows rich emotional granularity (24 categories).
%
% ============================================================
% END OF MODEL
% ============================================================
