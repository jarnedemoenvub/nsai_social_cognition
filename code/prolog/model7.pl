nn(face_model, [Face], Emotion,
   [angry, disgust, fear, happy, neutral, sad, surprise]) ::
   face_emotion(Face, Emotion).

nn(scene_model, [ScenePredictions], Scene, [airfield, airplane_cabin, airport_terminal, alcove, alley, amphitheater, amusement_arcade, amusement_park, apartment_building_outdoor, aquarium, aqueduct, arcade, arch, archaelogical_excavation, archive, arena_hockey, arena_performance, arena_rodeo, army_base, art_gallery, art_school, art_studio, artists_loft, assembly_line, athletic_field_outdoor, atrium_public, attic, auditorium, auto_factory, auto_showroom, badlands, bakery_shop, balcony_exterior, balcony_interior, ball_pit, ballroom, bamboo_forest, bank_vault, banquet_hall, bar, barn, barndoor, baseball_field, basement, basketball_court_indoor, bathroom, bazaar_indoor, bazaar_outdoor, beach, beach_house, beauty_salon, bedchamber, bedroom, beer_garden, beer_hall, berth, biology_laboratory, boardwalk, boat_deck, boathouse, bookstore, booth_indoor, botanical_garden, bow_window_indoor, bowling_alley, boxing_ring, bridge, building_facade, bullring, burial_chamber, bus_interior, bus_station_indoor, butchers_shop, butte, cabin_outdoor, cafeteria, campsite, campus, canal_natural, canal_urban, candy_store, canyon, car_interior, carrousel, castle, catacomb, cemetery, chalet, chemistry_lab, childs_room, church_indoor, church_outdoor, classroom, clean_room, cliff, closet, clothing_store, coast, cockpit, coffee_shop, computer_room, conference_center, conference_room, construction_site, corn_field, corral, corridor, cottage, courthouse, courtyard, creek, crevasse, crosswalk, dam, delicatessen, department_store, desert_sand, desert_vegetation, desert_road, diner_outdoor, dining_hall, dining_room, discotheque, doorway_outdoor, dorm_room, downtown, dressing_room, driveway, drugstore, elevator_door, elevator_lobby, elevator_shaft, embassy, engine_room, entrance_hall, escalator_indoor, excavation, fabric_store, farm, fastfood_restaurant, field_cultivated, field_wild, field_road, fire_escape, fire_station, fishpond, flea_market_indoor, florist_shop_indoor, food_court, football_field, forest_broadleaf, forest_path, forest_road, formal_garden, fountain, galley, garage_indoor, garage_outdoor, gas_station, gazebo_exterior, general_store_indoor, general_store_outdoor, gift_shop, glacier, golf_course, greenhouse_indoor, greenhouse_outdoor, grotto, gymnasium_indoor, hangar_indoor, hangar_outdoor, harbor, hardware_store, hayfield, heliport, highway, home_office, home_theater, hospital, hospital_room, hot_spring, hotel_outdoor, hotel_room, house, hunting_lodge_outdoor, ice_cream_parlor, ice_floe, ice_shelf, ice_skating_rink_indoor, ice_skating_rink_outdoor, iceberg, igloo, industrial_area, inn_outdoor, islet, jacuzzi_indoor, jail_cell, japanese_garden, jewelry_shop, junkyard, kasbah, kennel_outdoor, kindergarden_classroom, kitchen, lagoon, lake_natural, landfill, landing_deck, laundromat, lawn, lecture_room, legislative_chamber, library_indoor, library_outdoor, lighthouse, living_room, loading_dock, lobby, lock_chamber, locker_room, mansion, manufactured_home, market_indoor, market_outdoor, marsh, martial_arts_gym, mausoleum, medina, mezzanine, moat_water, mosque_outdoor, motel, mountain, mountain_path, mountain_snowy, movie_theater_indoor, museum_indoor, museum_outdoor, music_studio, natural_history_museum, nursery, nursing_home, oast_house, ocean, office, office_building, office_cubicles, oilrig, operating_room, orchard, orchestra_pit, pagoda, palace, pantry, park, parking_garage_indoor, parking_garage_outdoor, parking_lot, pasture, patio, pavilion, pet_shop, pharmacy, phone_booth, physics_laboratory, picnic_area, pier, pizzeria, playground, playroom, plaza, pond, porch, promenade, pub_indoor, racecourse, raceway, raft, railroad_track, rainforest, reception, recreation_room, repair_shop, residential_neighborhood, restaurant, restaurant_kitchen, restaurant_patio, rice_paddy, river, rock_arch, roof_garden, rope_bridge, ruin, runway, sandbox, sauna, schoolhouse, science_museum, server_room, shed, shoe_shop, shopfront, shopping_mall_indoor, shower, ski_resort, ski_slope, sky, skyscraper, slum, snowfield, soccer_field, stable, stadium_baseball, stadium_football, stadium_soccer, stage_indoor, stage_outdoor, staircase, storage_room, street, subway_station_platform, supermarket, sushi_bar, swamp, swimming_hole, swimming_pool_indoor, swimming_pool_outdoor, synagogue_outdoor, television_room, television_studio, temple_asia, throne_room, ticket_booth, topiary_garden, tower, toyshop, train_interior, train_station_platform, tree_farm, tree_house, trench, tundra, underwater_ocean_deep, utility_room, valley, vegetable_garden, veterinarians_office, viaduct, village, vineyard, volcano, volleyball_court_outdoor, waiting_room, water_park, water_tower, waterfall, watering_hole, wave, wet_bar, wheat_field, wind_farm, windmill, yard, youth_hostel, zen_garden]) ::
   scene(ScenePredictions, Scene).

nn(positive_emotion_model, [FacePredictions, ScenePredictions], Emotion,
   [joy, trust, anticipation]) ::
   get_positive_emotion(FacePredictions, ScenePredictions, Emotion).

nn(negative_emotion_model, [FacePredictions, ScenePredictions], Emotion,
   [angry, fear, disgust]) ::
   get_negative_emotion(FacePredictions, ScenePredictions, Emotion).

scene_prior(airfield, 4.0, 3.0).
scene_prior(airplane_cabin, 3.06, 3.03).
scene_prior(airport_terminal, 2.95, 2.19).
scene_prior(alcove, 4.0, 1.0).
scene_prior(alley, 3.13, 2.61).
scene_prior(amphitheater, 2.91, 3.13).
scene_prior(amusement_arcade, 3.64, 3.0).
scene_prior(amusement_park, 3.32, 3.33).
scene_prior(apartment_building_outdoor, 4.0, 2.5).
scene_prior(aquarium, 3.21, 2.5).
scene_prior(aqueduct, 2.0, 2.67).
scene_prior(arcade, 4.2, 2.2).
scene_prior(arch, 6.0, 4.0).
scene_prior(archaelogical_excavation, 3.09, 2.71).
scene_prior(archive, 3.84, 2.65).
scene_prior(arena_hockey, 3.51, 2.97).
scene_prior(arena_performance, 3.98, 3.17).
scene_prior(arena_rodeo, 3.41, 2.65).
scene_prior(army_base, 2.75, 2.99).
scene_prior(art_gallery, 3.56, 2.48).
scene_prior(art_school, 4.13, 2.62).
scene_prior(art_studio, 3.87, 2.56).
scene_prior(artists_loft, 3.77, 2.15).
scene_prior(assembly_line, 2.59, 2.81).
scene_prior(athletic_field_outdoor, 4.16, 3.16).
scene_prior(atrium_public, 4.11, 0.06).
scene_prior(attic, 1.67, 3.0).
scene_prior(auditorium, 3.41, 2.83).
scene_prior(auto_factory, 1.5, 2.93).
scene_prior(auto_showroom, 3.4, 2.9).
scene_prior(badlands, 3.8, 3.6).
scene_prior(bakery_shop, 6.0, 5.0).
scene_prior(balcony_exterior, 5.0, 2.5).
scene_prior(balcony_interior, 4.31, 2.62).
scene_prior(ball_pit, 3.77, 2.86).
scene_prior(ballroom, 3.96, 3.17).
scene_prior(bamboo_forest, 3.84, 2.8).
scene_prior(bank_vault, 2.91, 5.47).
scene_prior(banquet_hall, 3.86, 2.6).
scene_prior(bar, 3.34, 3.18).
scene_prior(barn, 1.36, 2.65).
scene_prior(barndoor, 3.38, 2.25).
scene_prior(baseball_field, 3.89, 2.87).
scene_prior(basement, 2.8, 3.4).
scene_prior(basketball_court_indoor, 4.21, 3.23).
scene_prior(bathroom, 5.68, 5.16).
scene_prior(bazaar_indoor, 3.11, 3.02).
scene_prior(bazaar_outdoor, 2.56, 3.09).
scene_prior(beach, 4.73, 3.23).
scene_prior(beach_house, 5.0, 2.0).
scene_prior(beauty_salon, 3.65, 2.99).
scene_prior(bedchamber, 4.0, 4.0).
scene_prior(bedroom, 4.29, 3.48).
scene_prior(beer_garden, 3.28, 2.93).
scene_prior(beer_hall, 3.51, 2.92).
scene_prior(berth, 5.0, 3.33).
scene_prior(biology_laboratory, 3.84, 2.58).
scene_prior(boardwalk, 3.8, 2.67).
scene_prior(boat_deck, 3.05, 3.05).
scene_prior(boathouse, 5.64, 2.51).
scene_prior(bookstore, 3.77, 2.46).
scene_prior(booth_indoor, 3.65, 2.38).
scene_prior(botanical_garden, 4.25, 3.75).
scene_prior(bow_window_indoor, 3.52, 2.9).
scene_prior(bowling_alley, 4.8, 2.4).
scene_prior(boxing_ring, 3.27, 3.44).
scene_prior(bridge, 3.0, 2.0).
scene_prior(building_facade, 2.12, 5.26).
scene_prior(bullring, 2.8, 3.35).
scene_prior(burial_chamber, 4.01, 4.94).
scene_prior(bus_interior, 3.37, 2.68).
scene_prior(bus_station_indoor, 3.12, 2.62).
scene_prior(butchers_shop, 3.0, 2.39).
scene_prior(butte, 4.75, 3.12).
scene_prior(cabin_outdoor, 4.0, 1.33).
scene_prior(cafeteria, 4.13, 2.27).
scene_prior(campsite, 2.91, 2.73).
scene_prior(campus, 3.26, 2.76).
scene_prior(canal_natural, 2.0, 3.67).
scene_prior(canal_urban, 3.6, 1.8).
scene_prior(candy_store, 3.17, 1.83).
scene_prior(canyon, 4.47, 2.67).
scene_prior(car_interior, 4.4, 3.0).
scene_prior(carrousel, 3.48, 2.86).
scene_prior(castle, 3.62, 3.25).
scene_prior(catacomb, 2.0, 4.5).
scene_prior(cemetery, 2.34, 2.97).
scene_prior(chalet, 0.94, 2.95).
scene_prior(chemistry_lab, 3.59, 2.6).
scene_prior(childs_room, 3.6, 2.2).
scene_prior(church_indoor, 4.08, 3.02).
scene_prior(church_outdoor, 3.57, 2.71).
scene_prior(classroom, 3.79, 2.52).
scene_prior(clean_room, 2.83, 2.59).
scene_prior(cliff, 4.0, 1.8).
scene_prior(closet, 4.33, 3.0).
scene_prior(clothing_store, 3.37, 3.24).
scene_prior(coast, 4.21, 3.33).
scene_prior(cockpit, 3.0, 4.09).
scene_prior(coffee_shop, 4.06, 2.83).
scene_prior(computer_room, 3.88, 2.45).
scene_prior(conference_center, 3.4, 2.68).
scene_prior(conference_room, 3.5, 2.23).
scene_prior(construction_site, 3.15, 2.59).
scene_prior(corn_field, 3.5, 3.25).
scene_prior(corral, 3.31, 2.81).
scene_prior(corridor, 4.54, 2.07).
scene_prior(cottage, 1.22, 2.28).
scene_prior(courthouse, 2.0, 4.0).
scene_prior(courtyard, 3.67, 1.83).
scene_prior(creek, 4.62, 2.5).
scene_prior(crevasse, 2.0, 2.89).
scene_prior(crosswalk, 2.6, 2.85).
scene_prior(dam, 3.0, 1.0).
scene_prior(delicatessen, 4.6, 2.4).
scene_prior(department_store, 3.0, 2.62).
scene_prior(desert_sand, 2.14, 4.86).
scene_prior(desert_vegetation, 3.11, 2.92).
scene_prior(desert_road, 4.0, 3.29).
scene_prior(diner_outdoor, 0.59, 4.35).
scene_prior(dining_hall, 4.3, 2.3).
scene_prior(dining_room, 5.5, 0.5).
scene_prior(discotheque, 3.76, 3.26).
scene_prior(doorway_outdoor, 3.0, 2.0).
scene_prior(dorm_room, 3.57, 2.52).
scene_prior(downtown, 3.47, 2.63).
scene_prior(dressing_room, 3.55, 2.92).
scene_prior(driveway, 3.14, 3.0).
scene_prior(drugstore, 3.6, 2.2).
scene_prior(elevator_door, 3.16, 2.93).
scene_prior(elevator_lobby, 3.34, 2.81).
scene_prior(elevator_shaft, 2.64, 5.42).
scene_prior(embassy, 2.76, 2.79).
scene_prior(engine_room, 3.23, 3.62).
scene_prior(entrance_hall, 3.06, 3.06).
scene_prior(escalator_indoor, 3.56, 3.33).
scene_prior(excavation, 3.26, 2.95).
scene_prior(fabric_store, 2.82, 3.12).
scene_prior(farm, 3.5, 1.95).
scene_prior(fastfood_restaurant, 1.57, 5.27).
scene_prior(field_cultivated, 3.57, 1.57).
scene_prior(field_wild, 1.34, 0.92).
scene_prior(field_road, 5.67, 3.67).
scene_prior(fire_escape, 4.0, 2.75).
scene_prior(fire_station, 2.61, 2.9).
scene_prior(fishpond, 3.0, 2.33).
scene_prior(flea_market_indoor, 3.03, 2.61).
scene_prior(florist_shop_indoor, 2.92, 2.92).
scene_prior(food_court, 4.52, 2.34).
scene_prior(football_field, 3.81, 3.32).
scene_prior(forest_broadleaf, 3.57, 3.86).
scene_prior(forest_path, 4.46, 2.69).
scene_prior(forest_road, 3.29, 3.57).
scene_prior(formal_garden, 1.79, 5.4).
scene_prior(fountain, 3.89, 2.82).
scene_prior(galley, 5.0, 2.0).
scene_prior(garage_indoor, 6.0, 4.0).
scene_prior(garage_outdoor, 3.39, 4.3).
scene_prior(gas_station, 2.85, 2.59).
scene_prior(gazebo_exterior, 6.0, 0.0).
scene_prior(general_store_indoor, 5.0, 1.0).
scene_prior(general_store_outdoor, 1.15, 2.15).
scene_prior(gift_shop, 3.5, 2.0).
scene_prior(glacier, 3.06, 3.06).
scene_prior(golf_course, 3.48, 2.59).
scene_prior(greenhouse_indoor, 3.62, 2.12).
scene_prior(greenhouse_outdoor, 3.04, 0.09).
scene_prior(grotto, 1.0, 6.0).
scene_prior(gymnasium_indoor, 4.19, 2.82).
scene_prior(hangar_indoor, 3.58, 1.92).
scene_prior(hangar_outdoor, 2.4, 2.6).
scene_prior(harbor, 3.19, 2.88).
scene_prior(hardware_store, 3.59, 1.82).
scene_prior(hayfield, 4.0, 3.0).
scene_prior(heliport, 2.2, 2.6).
scene_prior(highway, 3.86, 2.14).
scene_prior(home_office, 4.33, 3.67).
scene_prior(home_theater, 3.37, 5.8).
scene_prior(hospital, 3.41, 2.18).
scene_prior(hospital_room, 3.59, 2.89).
scene_prior(hot_spring, 1.95, 3.74).
scene_prior(hotel_outdoor, 5.44, 2.35).
scene_prior(hotel_room, 4.0, 2.63).
scene_prior(house, 3.73, 4.71).
scene_prior(hunting_lodge_outdoor, 4.0, 2.0).
scene_prior(ice_cream_parlor, 4.77, 2.51).
scene_prior(ice_floe, 3.2, 4.4).
scene_prior(ice_shelf, 3.4, 3.6).
scene_prior(ice_skating_rink_indoor, 3.19, 2.9).
scene_prior(ice_skating_rink_outdoor, 3.05, 2.77).
scene_prior(iceberg, 2.83, 0.71).
scene_prior(igloo, 4.09, 3.64).
scene_prior(industrial_area, 0.44, 3.39).
scene_prior(inn_outdoor, 6.0, 6.0).
scene_prior(islet, 5.06, 0.77).
scene_prior(jacuzzi_indoor, 4.67, 2.67).
scene_prior(jail_cell, 2.64, 3.07).
scene_prior(japanese_garden, 5.0, 1.0).
scene_prior(jewelry_shop, 3.27, 2.64).
scene_prior(junkyard, 1.79, 3.21).
scene_prior(kasbah, 3.11, 2.5).
scene_prior(kennel_outdoor, 3.23, 2.54).
scene_prior(kindergarden_classroom, 4.32, 2.56).
scene_prior(kitchen, 4.91, 2.55).
scene_prior(lagoon, 6.0, 4.5).
scene_prior(lake_natural, 3.89, 3.44).
scene_prior(landfill, 2.21, 3.47).
scene_prior(landing_deck, 2.4, 3.02).
scene_prior(laundromat, 2.6, 3.0).
scene_prior(lawn, 3.97, 2.28).
scene_prior(lecture_room, 3.49, 2.45).
scene_prior(legislative_chamber, 3.22, 2.58).
scene_prior(library_indoor, 3.92, 2.37).
scene_prior(library_outdoor, 1.0, 1.0).
scene_prior(lighthouse, 2.0, 2.0).
scene_prior(living_room, 3.43, 2.7).
scene_prior(loading_dock, 2.68, 2.47).
scene_prior(lobby, 3.25, 2.65).
scene_prior(lock_chamber, 2.75, 3.38).
scene_prior(locker_room, 3.27, 3.09).
scene_prior(mansion, 4.0, 4.0).
scene_prior(manufactured_home, 5.99, 4.27).
scene_prior(market_indoor, 3.83, 2.0).
scene_prior(market_outdoor, 2.99, 2.82).
scene_prior(marsh, 4.67, 3.67).
scene_prior(martial_arts_gym, 3.65, 2.9).
scene_prior(mausoleum, 3.5, 3.5).
scene_prior(medina, 3.12, 2.9).
scene_prior(mezzanine, 1.93, 4.04).
scene_prior(moat_water, 2.0, 3.67).
scene_prior(mosque_outdoor, 2.64, 3.82).
scene_prior(motel, 4.53, 5.35).
scene_prior(mountain, 4.43, 2.79).
scene_prior(mountain_path, 4.0, 2.94).
scene_prior(mountain_snowy, 3.82, 2.64).
scene_prior(movie_theater_indoor, 3.17, 2.43).
scene_prior(museum_indoor, 3.3, 2.9).
scene_prior(museum_outdoor, 3.0, 3.42).
scene_prior(music_studio, 3.51, 2.8).
scene_prior(natural_history_museum, 4.4, 3.4).
scene_prior(nursery, 3.9, 2.75).
scene_prior(nursing_home, 3.89, 2.73).
scene_prior(oast_house, 5.5, 2.75).
scene_prior(ocean, 3.58, 3.72).
scene_prior(office, 3.53, 2.58).
scene_prior(office_building, 4.29, 2.53).
scene_prior(office_cubicles, 3.71, 2.45).
scene_prior(oilrig, 1.0, 4.0).
scene_prior(operating_room, 3.09, 3.08).
scene_prior(orchard, 4.08, 3.02).
scene_prior(orchestra_pit, 3.69, 3.03).
scene_prior(pagoda, 5.0, 5.0).
scene_prior(palace, 3.15, 2.92).
scene_prior(pantry, 0.29, 3.67).
scene_prior(park, 3.82, 2.89).
scene_prior(parking_garage_indoor, 4.0, 2.0).
scene_prior(parking_garage_outdoor, 3.44, 5.6).
scene_prior(parking_lot, 2.91, 2.9).
scene_prior(pasture, 4.4, 2.0).
scene_prior(patio, 3.91, 2.34).
scene_prior(pavilion, 4.38, 1.62).
scene_prior(pet_shop, 4.0, 1.67).
scene_prior(pharmacy, 3.73, 2.0).
scene_prior(phone_booth, 3.67, 2.67).
scene_prior(physics_laboratory, 3.54, 2.52).
scene_prior(picnic_area, 4.1, 2.58).
scene_prior(pier, 3.17, 3.04).
scene_prior(pizzeria, 3.36, 2.27).
scene_prior(playground, 3.66, 3.1).
scene_prior(playroom, 3.91, 2.74).
scene_prior(plaza, 2.48, 3.19).
scene_prior(pond, 5.0, 3.67).
scene_prior(porch, 4.04, 2.51).
scene_prior(promenade, 2.89, 2.79).
scene_prior(pub_indoor, 3.45, 3.04).
scene_prior(racecourse, 2.67, 3.24).
scene_prior(raceway, 2.47, 2.73).
scene_prior(raft, 3.16, 3.09).
scene_prior(railroad_track, 3.5, 2.5).
scene_prior(rainforest, 4.1, 2.87).
scene_prior(reception, 3.55, 2.3).
scene_prior(recreation_room, 4.16, 2.41).
scene_prior(repair_shop, 2.75, 2.8).
scene_prior(residential_neighborhood, 4.0, 2.5).
scene_prior(restaurant, 3.92, 2.58).
scene_prior(restaurant_kitchen, 3.64, 2.42).
scene_prior(restaurant_patio, 3.79, 1.96).
scene_prior(rice_paddy, 3.92, 2.92).
scene_prior(river, 3.27, 3.2).
scene_prior(rock_arch, 4.0, 2.75).
scene_prior(roof_garden, 3.0, 2.25).
scene_prior(rope_bridge, 3.79, 2.69).
scene_prior(ruin, 3.33, 5.0).
scene_prior(runway, 3.44, 2.6).
scene_prior(sandbox, 3.85, 2.73).
scene_prior(sauna, 4.43, 3.43).
scene_prior(schoolhouse, 3.0, 2.67).
scene_prior(science_museum, 3.48, 3.18).
scene_prior(server_room, 2.4, 3.0).
scene_prior(shed, 5.0, 2.0).
scene_prior(shoe_shop, 2.38, 3.48).
scene_prior(shopfront, 3.55, 0.64).
scene_prior(shopping_mall_indoor, 1.0, 3.0).
scene_prior(shower, 3.4, 2.6).
scene_prior(ski_resort, 3.11, 2.56).
scene_prior(ski_slope, 3.76, 3.07).
scene_prior(sky, 3.33, 2.33).
scene_prior(skyscraper, 4.51, 3.04).
scene_prior(slum, 2.78, 3.18).
scene_prior(snowfield, 4.0, 3.5).
scene_prior(soccer_field, 3.95, 3.05).
scene_prior(stable, 3.68, 3.23).
scene_prior(stadium_baseball, 3.72, 2.93).
scene_prior(stadium_football, 3.72, 3.19).
scene_prior(stadium_soccer, 3.84, 3.17).
scene_prior(stage_indoor, 4.01, 2.92).
scene_prior(stage_outdoor, 3.17, 3.09).
scene_prior(staircase, 3.69, 3.5).
scene_prior(storage_room, 2.8, 2.0).
scene_prior(street, 2.55, 3.05).
scene_prior(subway_station_platform, 3.42, 3.0).
scene_prior(supermarket, 3.88, 2.16).
scene_prior(sushi_bar, 3.22, 2.72).
scene_prior(swamp, 3.25, 3.0).
scene_prior(swimming_hole, 3.91, 2.82).
scene_prior(swimming_pool_indoor, 4.5, 2.67).
scene_prior(swimming_pool_outdoor, 5.12, 2.75).
scene_prior(synagogue_outdoor, 2.57, 2.86).
scene_prior(television_room, 4.33, 1.67).
scene_prior(television_studio, 3.44, 2.87).
scene_prior(temple_asia, 4.0, 2.5).
scene_prior(throne_room, 3.0, 2.86).
scene_prior(ticket_booth, 4.17, 1.83).
scene_prior(topiary_garden, 3.09, 2.64).
scene_prior(tower, 5.44, 1.23).
scene_prior(toyshop, 3.82, 2.88).
scene_prior(train_interior, 3.29, 2.86).
scene_prior(train_station_platform, 4.11, 2.78).
scene_prior(tree_farm, 3.21, 2.72).
scene_prior(tree_house, 3.29, 2.57).
scene_prior(trench, 2.68, 2.86).
scene_prior(tundra, 4.17, 2.75).
scene_prior(underwater_ocean_deep, 4.0, 2.5).
scene_prior(utility_room, 2.08, 1.56).
scene_prior(valley, 4.2, 2.4).
scene_prior(vegetable_garden, 4.1, 2.1).
scene_prior(veterinarians_office, 3.83, 2.95).
scene_prior(viaduct, 3.0, 2.0).
scene_prior(village, 3.51, 3.23).
scene_prior(vineyard, 3.64, 3.32).
scene_prior(volcano, 1.0, 4.2).
scene_prior(volleyball_court_outdoor, 4.18, 2.87).
scene_prior(waiting_room, 3.91, 2.7).
scene_prior(water_park, 4.09, 3.4).
scene_prior(water_tower, 3.0, 0.0).
scene_prior(waterfall, 2.5, 2.0).
scene_prior(watering_hole, 3.63, 3.41).
scene_prior(wave, 2.0, 3.71).
scene_prior(wet_bar, 2.59, 4.2).
scene_prior(wheat_field, 4.37, 3.0).
scene_prior(wind_farm, 2.0, 3.0).
scene_prior(windmill, 0.0, 5.0).
scene_prior(yard, 4.4, 2.47).
scene_prior(youth_hostel, 3.62, 2.88).
scene_prior(zen_garden, 5.0, 1.0).

face_prior(angry, 1.2, 5.1).
face_prior(disgust, 0.9, 3.1).
face_prior(fear, 0.6, 5.4).
face_prior(happy, 5.4, 4.8).
face_prior(neutral, 3.0, 2.4).
face_prior(sad, 0.9, 1.5).
face_prior(surprise, 3.3, 5.4).

small_diff(F, S)  :- abs(F - S) =< 1.
medium_diff(F, S) :- D is abs(F - S), D > 1, D =< 3.
large_diff(F, S)  :- abs(F - S) > 3.

t(_) :: use_face_small_val(F,S) ; t(_) :: use_scene_small_val(F,S).
t(_) :: use_face_small_aro(F,S) ; t(_) :: use_scene_small_aro(F,S).
t(_) :: use_face_big_val(F,S) ; t(_) :: use_scene_big_val(F,S).
t(_) :: use_face_big_aro(F,S) ; t(_) :: use_scene_big_aro(F,S).

combine_val(FV, SV, FV) :-
    small_diff(FV, SV), 
    use_face_small_val(FV, SV). 

combine_val(FV, SV, SV) :-
    small_diff(FV, SV), 
    use_scene_small_val(FV, SV). 

combine_val(F, S, M) :-
    medium_diff(F, S), 
    M is (2*F + S) / 3. 

combine_val(FV, SV, FV) :-
    large_diff(FV, SV), 
    use_face_big_val(FV, SV). 

combine_val(FV, SV, SV) :-
    large_diff(FV, SV), 
    use_scene_big_val(FV, SV). 

combine_aro(FA, SA, FA) :-
    small_diff(FA, SA), 
    use_face_small_aro(FA, SA). 

combine_aro(FA, SA, SA) :-
    small_diff(FA, SA), 
    use_scene_small_aro(FA, SA). 

combine_aro(F, S, M) :-
    medium_diff(F, S), 
    M is (2*F + S) / 3. 

combine_aro(FA, SA, FA) :-
    large_diff(FA, SA), 
    use_face_big_aro(FA, SA). 

combine_aro(FA, SA, SA) :-
    large_diff(FA, SA), 
    use_scene_big_aro(FA, SA). 

predict_emotion(CV, CA, FacePredictions, ScenePredictions, sadness) :-
    CV < 2.5, 
    CA < 3. 

predict_emotion(CV, CA, FacePredictions, ScenePredictions, Emotion) :-
    CV < 2.5, 
    CA >= 3, 
    get_negative_emotion(FacePredictions, ScenePredictions, Emotion). 

predict_emotion(CV, CA, FacePredictions, ScenePredictions, surprise) :-
    CV > 2.5, 
    CA >= 3.5. 

predict_emotion(CV, CA, FacePredictions, ScenePredictions, Emotion) :-
    CV > 2.5, 
    CA >= 4, 
    get_positive_emotion(FacePredictions, ScenePredictions, Emotion). 

predict_emotion(CV, CA, FacePredictions, ScenePredictions, trust) :-
    CV > 2.5, 
    CA < 4. 

final_emotion(FacePredictions, ScenePredictions, Emotion) :-
    face_emotion(FacePredictions, FaceEmotion),
    face_prior(FaceEmotion, FV, FA),
    scene(ScenePredictions, Scene),
    scene_prior(Scene, SV, SA),
    combine_val(FV, SV, CV),
    combine_aro(FA, SA, CA),
    predict_emotion(CV, CA, FacePredictions, ScenePredictions, Emotion). 

test_va(FacePredictions, ScenePredictions, FV, FA, SV, SA) :-
    face_emotion(FacePredictions, FaceEmotion),
    face_prior(FaceEmotion, FV, FA),
    scene(ScenePredictions, Scene),
    scene_prior(Scene, SV, SA).
test_combo(FacePredictions, ScenePredictions, CV, CA) :-
    face_emotion(FacePredictions, FaceEmotion),
    face_prior(FaceEmotion, FV, FA),
    scene(ScenePredictions, Scene),
    scene_prior(Scene, SV, SA),
    combine_val(FV, SV, CV),
    combine_aro(FA, SA, CA).
