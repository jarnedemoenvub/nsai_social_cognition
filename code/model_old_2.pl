% Neural networks = flattened tensor 
nn(multi_face_net, [X], Y, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34]) :: all_face_emotions(X, Y).

% Scene prediction: 365 scene categories
nn(scene_net, [X], Y, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364]) :: scene_prediction(X, Y).

% Extract individual face-emotion probability from flattened tensor
face_emotion_prob(Image, FaceIdx, EmotionIdx) :-
    between(0, 4, FaceIdx),  
    between(0, 6, EmotionIdx),
    FlatIdx is FaceIdx * 7 + EmotionIdx,
    all_face_emotions(Image, FlatIdx).

% Simple query: just get the raw tensor output from neural network
faces(FaceImg, AllEmotions) :-
    all_face_emotions(FaceImg, AllEmotions).

% Scene prediction wrapper
scene(SceneImg, SceneIdx) :-
    scene_prediction(SceneImg, SceneIdx).

% NEW MAIN PREDICATE - True multi-modal integration
final_emotion(FaceImg, SceneImg, FindingEmoIdx) :-
    % Get weighted face emotion for this specific emotion
    weighted_face_emotion(FaceImg, FaceEmotion, FaceContribution),
    % Get scene contribution for this emotion
    scene_emotion_contribution(SceneImg, FaceEmotion, SceneContribution),
    % Combine face and scene contributions
    TotalContribution is FaceContribution + SceneContribution,
    % Map to FindingEmo emotion space
    mapped_emotion(FaceEmotion, FindingEmoIdx),
    % Use the total contribution as the final probability
    final_probability(TotalContribution).

% Weighted face emotion combination - combines all faces with their weights
weighted_face_emotion(Image, EmotionIdx, WeightedProb) :-
    findall(FaceProb*FaceWeight, (
        between(0, 4, FaceIdx),
        face_emotion_prob(Image, FaceIdx, EmotionIdx),
        face_weight(FaceIdx),
        FaceProb = face_emotion_prob(Image, FaceIdx, EmotionIdx),
        FaceWeight = face_weight(FaceIdx)
    ), WeightedProbs),
    sumlist(WeightedProbs, WeightedProb).

% Scene emotion contribution
scene_emotion_contribution(SceneImg, EmotionIdx, SceneProb) :-
    scene_valence(SceneImg, positive),
    (EmotionIdx = 3 -> SceneProb = scene_weight ; SceneProb = 0.0).

scene_emotion_contribution(SceneImg, EmotionIdx, SceneProb) :-
    scene_valence(SceneImg, negative), 
    (EmotionIdx = 4 -> SceneProb = scene_weight ; SceneProb = 0.0).

scene_emotion_contribution(SceneImg, EmotionIdx, SceneProb) :-
    scene_valence(SceneImg, neutral),
    SceneProb = 0.0.

% Helper predicate for probability calculation
final_probability(P) :- P > 0.0.

% Trainable face weights (should learn: bigger face = higher weight)
t(_)::face_weight(0).  % Weight for biggest face
t(_)::face_weight(1).  % Weight for second biggest face  
t(_)::face_weight(2).  % Weight for third face
t(_)::face_weight(3).  % Weight for fourth face
t(_)::face_weight(4).  % Weight for smallest face
t(_)::scene_weight.


% Scene valence detection
scene_valence(Image, positive) :-
    scene(Image, SceneIdx),
    joy_place(SceneIdx).

scene_valence(Image, negative) :-
    scene(Image, SceneIdx),
    sad_place(SceneIdx).

scene_valence(Image, neutral) :-
    scene(Image, SceneIdx),
    neutral_place(SceneIdx).

% Mapping from model emotions (0-6) to dataset emotions
% Angry -> anger, rage, annoyance
0.8::mapped_emotion(0, 4).
0.1::mapped_emotion(0, 13).
0.1::mapped_emotion(0, 14).

% Disgust -> disgust, loathing
0.7::mapped_emotion(1, 23).
0.3::mapped_emotion(1, 21).

% Fear -> fear, apprehension, terror, vigilance
0.4::mapped_emotion(2, 10).
0.2::mapped_emotion(2, 2).
0.2::mapped_emotion(2, 16).
0.2::mapped_emotion(2, 11).

% Happy -> joy, ecstasy, serenity, admiration, acceptance
0.4::mapped_emotion(3, 5).
0.2::mapped_emotion(3, 9).
0.2::mapped_emotion(3, 7).
0.1::mapped_emotion(3, 20).
0.1::mapped_emotion(3, 15).

% Sad -> sadness, grief, pensiveness
0.5::mapped_emotion(4, 12).
0.3::mapped_emotion(4, 6).
0.2::mapped_emotion(4, 19).

% Surprise -> surprise, amazement, distraction
0.5::mapped_emotion(5, 18).
0.3::mapped_emotion(5, 17).
0.2::mapped_emotion(5, 22).

% Neutral -> boredom, serenity, acceptance
0.4::mapped_emotion(6, 8).
0.3::mapped_emotion(6, 7).
0.3::mapped_emotion(6, 15).

% Places that trigger happiness (your existing rules)
0.95::joy_place(7).      % amusement_park
0.85::joy_place(11).     % arcade  
0.80::joy_place(34).     % ball_pit
0.90::joy_place(35).     % ballroom
0.75::joy_place(42).     % baseball_field
0.85::joy_place(48).     % beach
0.80::joy_place(49).     % beach_house
0.90::joy_place(62).     % botanical_garden
0.70::joy_place(77).     % campus
0.85::joy_place(80).     % candy_store
0.90::joy_place(83).     % carrousel
0.75::joy_place(97).     % coast
0.70::joy_place(119).    % diner/outdoor
0.75::joy_place(120).    % dining_hall
0.80::joy_place(121).    % dining_room
0.65::joy_place(125).    % downtown
0.70::joy_place(139).    % fastfood_restaurant
0.85::joy_place(153).    % formal_garden
0.75::joy_place(164).    % golf_course
0.80::joy_place(180).    % hot_spring
0.90::joy_place(185).    % ice_cream_parlor
0.85::joy_place(197).    % japanese_garden
0.75::joy_place(203).    % kitchen
0.70::joy_place(209).    % lawn
0.80::joy_place(215).    % living_room
0.70::joy_place(225).    % martial_arts_gym
0.75::joy_place(233).    % mountain_path
0.85::joy_place(235).    % movie_theater/indoor
0.80::joy_place(243).    % ocean
0.85::joy_place(254).    % park
0.75::joy_place(259).    % patio
0.80::joy_place(265).    % picnic_area
0.75::joy_place(267).    % pizzeria
0.95::joy_place(268).    % playground
0.85::joy_place(269).    % playroom
0.70::joy_place(270).    % plaza
0.75::joy_place(275).    % racecourse
0.75::joy_place(276).    % raceway
0.80::joy_place(281).    % recreation_room
0.85::joy_place(324).    % swimming_hole
0.80::joy_place(325).    % swimming_pool/indoor
0.85::joy_place(326).    % swimming_pool/outdoor
0.90::joy_place(335).    % toyshop
0.85::joy_place(339).    % tree_house
0.75::joy_place(351).    % volleyball_court/outdoor
0.95::joy_place(353).    % water_park
0.85::joy_place(355).    % waterfall
0.80::joy_place(364).    % zen_garden

% Places that trigger sadness (your existing rules)
0.85::sad_place(18).     % army_base
0.75::sad_place(43).     % basement
0.90::sad_place(69).     % burial_chamber
0.95::sad_place(85).     % catacomb
0.95::sad_place(86).     % cemetery
0.80::sad_place(111).    % crevasse
0.70::sad_place(116).    % desert/sand
0.75::sad_place(163).    % glacier
0.90::sad_place(178).    % hospital
0.85::sad_place(179).    % hospital_room
0.70::sad_place(186).    % ice_floe
0.70::sad_place(187).    % ice_shelf
0.75::sad_place(190).    % iceberg
0.65::sad_place(191).    % igloo
0.80::sad_place(192).    % industrial_area
0.90::sad_place(196).    % jail_cell
0.85::sad_place(206).    % landfill
0.65::sad_place(223).    % market/outdoor
0.95::sad_place(226).    % mausoleum
0.85::sad_place(241).    % nursing_home
0.80::sad_place(248).    % operating_room
0.85::sad_place(292).    % ruin
0.85::sad_place(308).    % slum
0.80::sad_place(340).    % trench
0.75::sad_place(341).    % tundra

% Places that trigger neutrality (your existing rules)
0.80::neutral_place(1).     % airplane_cabin
0.85::neutral_place(2).     % airport_terminal
0.75::neutral_place(19).    % art_gallery
0.80::neutral_place(25).    % atrium/public
0.75::neutral_place(27).    % auditorium
0.85::neutral_place(45).    % bathroom
0.75::neutral_place(60).    % bookstore
0.80::neutral_place(71).    % bus_station/indoor
0.80::neutral_place(75).    % cafeteria
0.85::neutral_place(92).    % classroom
0.90::neutral_place(100).   % computer_room
0.85::neutral_place(101).   % conference_center
0.90::neutral_place(102).   % conference_room
0.85::neutral_place(106).   % corridor
0.70::neutral_place(109).   % courtyard
0.80::neutral_place(112).   % crosswalk
0.75::neutral_place(114).   % delicatessen
0.80::neutral_place(115).   % department_store
0.80::neutral_place(128).   % drugstore
0.85::neutral_place(130).   % elevator_lobby
0.85::neutral_place(134).   % entrance_hall
0.80::neutral_place(135).   % escalator/indoor
0.75::neutral_place(144).   % fire_station
0.80::neutral_place(156).   % garage/indoor
0.75::neutral_place(158).   % gas_station
0.75::neutral_place(160).   % general_store/indoor
0.75::neutral_place(172).   % hardware_store
0.80::neutral_place(176).   % home_office
0.80::neutral_place(182).   % hotel_room
0.85::neutral_place(212).   % library/indoor
0.80::neutral_place(217).   % lobby
0.90::neutral_place(244).   % office
0.85::neutral_place(245).   % office_building
0.90::neutral_place(246).   % office_cubicles
0.85::neutral_place(255).   % parking_garage/indoor
0.80::neutral_place(257).   % parking_lot
0.75::neutral_place(273).   % promenade
0.75::neutral_place(284).   % restaurant
0.80::neutral_place(296).   % schoolhouse
0.80::neutral_place(302).   % shopping_mall/indoor
0.80::neutral_place(317).   % staircase
0.75::neutral_place(319).   % street
0.85::neutral_place(320).   % subway_station/platform
0.80::neutral_place(321).   % supermarket
0.80::neutral_place(337).   % train_station/platform
0.85::neutral_place(352).   % waiting_room
0.70::neutral_place(362).   % yard