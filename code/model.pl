
% Neural networks - flattened tensor approach
nn(multi_face_net, [X], Y, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34]) :: all_face_emotions(X, Y).

% Scene prediction: 365 scene categories
nn(scene_net, [X], Y, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364]) :: scene_prediction(X, Y).

% Extract individual face-emotion probability from flattened tensor
% FlatIndex = FaceIndex * 7 + EmotionIndex
face_emotion_prob(Image, FaceIdx, EmotionIdx) :-
    between(0, 4, FaceIdx),  
    between(0, 6, EmotionIdx),
    FlatIdx is FaceIdx * 7 + EmotionIdx,
    all_face_emotions(Image, FlatIdx).

% Simple query: just get the raw tensor output from neural network
faces(FaceImg, AllEmotions) :-
    all_face_emotions(FaceImg, AllEmotions).

% Multi-face emotion aggregation (considers ALL faces)
multi_face_emotion(Image, AggregatedEmotion) :-
    face_emotion_prob(Image, _, AggregatedEmotion).

% MAIN PREDICATE 
enhanced_final_emotion(FaceImg, SceneImg, FindingEmoIdx) :-
    multi_face_emotion(FaceImg, ModelEmotion),  % Uses all the faces
    scene_valence(SceneImg, SceneValence),
    scene_emotion_boost(ModelEmotion, SceneValence),
    mapped_emotion(ModelEmotion, FindingEmoIdx).

% Scene prediction 
scene(SceneImg, SceneIdx) :-
    scene_prediction(SceneImg, SceneIdx).

scene_valence(Image, joy) :-
    scene(Image, SceneIdx),
    joy_place(SceneIdx).

scene_valence(Image, sad) :-
    scene(Image, SceneIdx),
    sad_place(SceneIdx).

scene_valence(Image, neutral) :-
    scene(Image, SceneIdx),
    neutral_place(SceneIdx).

primary_face_emotion(Image, EmotionIdx) :-
    face_emotion_prob(Image, _, EmotionIdx).
    
% Scene-emotion compatibility rules with probabilistic weights
0.9::scene_emotion_boost(3, joy).     % Happy emotion + joy place = strong boost
0.8::scene_emotion_boost(4, sad).     % Sad emotion + sad place = strong boost  
0.7::scene_emotion_boost(6, neutral). % Neutral emotion + neutral place = medium boost
0.3::scene_emotion_boost(3, sad).     % Happy emotion + sad place = weak (contradiction)
0.3::scene_emotion_boost(4, joy).     % Sad emotion + joy place = weak (contradiction)
0.5::scene_emotion_boost(_, neutral). % Any emotion + neutral place = medium
0.4::scene_emotion_boost(_, _).       % Default compatibility


% Enhanced final prediction using multi-face
enhanced_final_emotion(FaceImg, SceneImg, FindingEmoIdx) :-
    multi_face_emotion(FaceImg, ModelEmotion),
    scene_valence(SceneImg, SceneValence),
    scene_emotion_boost(ModelEmotion, SceneValence),
    mapped_emotion(ModelEmotion, FindingEmoIdx).


% Learn mapping of model emotions to dataset emotions
% Angry -> rage, annoyance
t(_)::mapped_emotion(0, 4).
t(_)::mapped_emotion(0, 13).
t(_)::mapped_emotion(0, 14).

% Disgust -> disgust, loathing
t(_)::mapped_emotion(1, 23).
t(_)::mapped_emotion(1, 21).

% Fear -> fear, apprehension, terror, vigilance
t(_)::mapped_emotion(2, 10).
t(_)::mapped_emotion(2, 2).
t(_)::mapped_emotion(2, 16).
t(_)::mapped_emotion(2, 11).

% Happy -> joy, ecstasy, serenity, admiration, acceptance
t(_)::mapped_emotion(3, 5).
t(_)::mapped_emotion(3, 9).
t(_)::mapped_emotion(3, 7).
t(_)::mapped_emotion(3, 20).
t(_)::mapped_emotion(3, 15).

% Sad -> sadness, grief, pensiveness
t(_)::mapped_emotion(4, 12).
t(_)::mapped_emotion(4, 6).
t(_)::mapped_emotion(4, 19).

% Surprise -> surprise, amazement, distraction
t(_)::mapped_emotion(5, 18).
t(_)::mapped_emotion(5, 17).
t(_)::mapped_emotion(5, 22).

% Neutral -> boredom, serenity, acceptance
t(_)::mapped_emotion(6, 8).
t(_)::mapped_emotion(6, 7).
t(_)::mapped_emotion(6, 15).
% Places that trigger happiness
t(_)::joy_place(7).      % amusement_park
t(_)::joy_place(11).     % arcade
t(_)::joy_place(34).     % ball_pit
t(_)::joy_place(35).     % ballroom
t(_)::joy_place(42).     % baseball_field
t(_)::joy_place(48).     % beach
t(_)::joy_place(49).     % beach_house
t(_)::joy_place(62).     % botanical_garden
t(_)::joy_place(77).     % campus
t(_)::joy_place(80).     % candy_store
t(_)::joy_place(83).     % carrousel
t(_)::joy_place(97).     % coast
t(_)::joy_place(119).    % diner/outdoor
t(_)::joy_place(120).    % dining_hall
t(_)::joy_place(121).    % dining_room
t(_)::joy_place(125).    % downtown
t(_)::joy_place(139).    % fastfood_restaurant
t(_)::joy_place(153).    % formal_garden
t(_)::joy_place(164).    % golf_course
t(_)::joy_place(180).    % hot_spring
t(_)::joy_place(185).    % ice_cream_parlor
t(_)::joy_place(197).    % japanese_garden
t(_)::joy_place(203).    % kitchen
t(_)::joy_place(209).    % lawn
t(_)::joy_place(215).    % living_room
t(_)::joy_place(225).    % martial_arts_gym
t(_)::joy_place(233).    % mountain_path
t(_)::joy_place(235).    % movie_theater/indoor
t(_)::joy_place(243).    % ocean
t(_)::joy_place(254).    % park
t(_)::joy_place(259).    % patio
t(_)::joy_place(265).    % picnic_area
t(_)::joy_place(267).    % pizzeria
t(_)::joy_place(268).    % playground
t(_)::joy_place(269).    % playroom
t(_)::joy_place(270).    % plaza
t(_)::joy_place(275).    % racecourse
t(_)::joy_place(276).    % raceway
t(_)::joy_place(281).    % recreation_room
t(_)::joy_place(324).    % swimming_hole
t(_)::joy_place(325).    % swimming_pool/indoor
t(_)::joy_place(326).    % swimming_pool/outdoor
t(_)::joy_place(335).    % toyshop
t(_)::joy_place(339).    % tree_house
t(_)::joy_place(351).    % volleyball_court/outdoor
t(_)::joy_place(353).    % water_park
t(_)::joy_place(355).    % waterfall
t(_)::joy_place(364).    % zen_garden

% Places that trigger sadness
t(_)::sad_place(18).     % army_base
t(_)::sad_place(43).     % basement
t(_)::sad_place(69).     % burial_chamber
t(_)::sad_place(85).     % catacomb
t(_)::sad_place(86).     % cemetery
t(_)::sad_place(111).    % crevasse
t(_)::sad_place(116).    % desert/sand
t(_)::sad_place(163).    % glacier
t(_)::sad_place(178).    % hospital
t(_)::sad_place(179).    % hospital_room
t(_)::sad_place(186).    % ice_floe
t(_)::sad_place(187).    % ice_shelf
t(_)::sad_place(190).    % iceberg
t(_)::sad_place(191).    % igloo
t(_)::sad_place(192).    % industrial_area
t(_)::sad_place(196).    % jail_cell
t(_)::sad_place(206).    % landfill
t(_)::sad_place(223).    % market/outdoor (lonely setting)
t(_)::sad_place(226).    % mausoleum
t(_)::sad_place(241).    % nursing_home
t(_)::sad_place(248).    % operating_room
t(_)::sad_place(292).    % ruin
t(_)::sad_place(308).    % slum
t(_)::sad_place(340).    % trench
t(_)::sad_place(341).    % tundra

% Places that trigger neutrality
t(_)::neutral_place(1).     % airplane_cabin
t(_)::neutral_place(2).     % airport_terminal
t(_)::neutral_place(19).    % art_gallery
t(_)::neutral_place(25).    % atrium/public
t(_)::neutral_place(27).    % auditorium
t(_)::neutral_place(45).    % bathroom
t(_)::neutral_place(60).    % bookstore
t(_)::neutral_place(71).    % bus_station/indoor
t(_)::neutral_place(75).    % cafeteria
t(_)::neutral_place(92).    % classroom
t(_)::neutral_place(100).   % computer_room
t(_)::neutral_place(101).   % conference_center
t(_)::neutral_place(102).   % conference_room
t(_)::neutral_place(106).   % corridor
t(_)::neutral_place(109).   % courtyard
t(_)::neutral_place(112).   % crosswalk
t(_)::neutral_place(114).   % delicatessen
t(_)::neutral_place(115).   % department_store
t(_)::neutral_place(128).   % drugstore
t(_)::neutral_place(130).   % elevator_lobby
t(_)::neutral_place(134).   % entrance_hall
t(_)::neutral_place(135).   % escalator/indoor
t(_)::neutral_place(144).   % fire_station
t(_)::neutral_place(156).   % garage/indoor
t(_)::neutral_place(158).   % gas_station
t(_)::neutral_place(160).   % general_store/indoor
t(_)::neutral_place(172).   % hardware_store
t(_)::neutral_place(176).   % home_office
t(_)::neutral_place(182).   % hotel_room
t(_)::neutral_place(212).   % library/indoor
t(_)::neutral_place(217).   % lobby
t(_)::neutral_place(244).   % office
t(_)::neutral_place(245).   % office_building
t(_)::neutral_place(246).   % office_cubicles
t(_)::neutral_place(255).   % parking_garage/indoor
t(_)::neutral_place(257).   % parking_lot
t(_)::neutral_place(273).   % promenade
t(_)::neutral_place(284).   % restaurant
t(_)::neutral_place(296).   % schoolhouse
t(_)::neutral_place(302).   % shopping_mall/indoor
t(_)::neutral_place(317).   % staircase
t(_)::neutral_place(319).   % street
t(_)::neutral_place(320).   % subway_station/platform
t(_)::neutral_place(321).   % supermarket
t(_)::neutral_place(337).   % train_station/platform
t(_)::neutral_place(352).   % waiting_room
t(_)::neutral_place(362).   % yard


