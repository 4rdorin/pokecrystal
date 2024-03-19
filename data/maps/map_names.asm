MapGroupNum_Names::
	table_width 2, MapGroupNum_Names
	dw Olivine_Map_Names
	dw Mahogany_Map_Names
	dw Dungeons_Map_Names
	dw Ecruteak_Map_Names
	dw Blackthorn_Map_Names
	dw Cinnabar_Map_Names
	dw Cerulean_Map_Names
	dw Azalea_Map_Names
	dw Lake_of_Rage_Map_Names
	dw Violet_Map_Names
	dw Goldenrod_Map_Names
	dw Vermilion_Map_Names
	dw Pallet_Map_Names
	dw Pewter_Map_Names
	dw Fast_Ship_Map_Names
	dw Indigo_Map_Names
	dw Fuchsia_Map_Names
	dw Lavender_Map_Names
	dw Silver_Map_Names
	dw Cable_Club_Map_Names
	dw Celadon_Map_Names
	dw Cianwood_Map_Names
	dw Viridian_Map_Names
	dw New_Bark_Map_Names
	dw Saffron_Map_Names
	dw Cherrygrove_Map_Names
	dw SafariZone_Map_Names
	dw SafariZone3_Map_Names
	assert_table_length NUM_MAP_GROUPS

GetMapGroupNum_Name::
	dec d ; map num
	dec e ; map group
	push de
	ld d, 0
	; ld hl, Dungeons_Map_Names
	ld hl, MapGroupNum_Names
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld h, d
	ld l, e
	pop de
	ld e, d
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	; return string ptr in de
	ret


Olivine_Map_Names: ;newgroup OLIVINE
	table_width 2, Olivine_Map_Names
	dw Olivine_Map_Name1 ; OLIVINE_POKECENTER_1F
	dw Olivine_Map_Name2 ; OLIVINE_GYM
	dw Olivine_Map_Name3 ; OLIVINE_TIMS_HOUSE
	dw Olivine_Map_Name5 ; OLIVINE_PUNISHMENT_SPEECH_HOUSE
	dw Olivine_Map_Name6 ; OLIVINE_GOOD_ROD_HOUSE
	dw Olivine_Map_Name7 ; OLIVINE_CAFE
	dw Olivine_Map_Name8 ; OLIVINE_MART
	dw Olivine_Map_Name9 ; ROUTE_38_ECRUTEAK_GATE
	dw Olivine_Map_Name10 ; ROUTE_39_BARN
	dw Olivine_Map_Name11 ; ROUTE_39_FARMHOUSE
	dw Olivine_Map_Name12 ; ROUTE_38,
	dw Olivine_Map_Name13 ; ROUTE_39,
	dw Olivine_Map_Name14 ; OLIVINE_CITY
	dw Olivine_Map_Name15 ; ROUTE_35_COAST
	dw Olivine_Map_Name16 ; GOLDENROD_HARBOR
	dw Olivine_Map_Name17 ; GOLDENROD_HARBOR_GATE
	assert_table_length NUM_OLIVINE_MAPS

Mahogany_Map_Names: ;newgroup MAHOGANY
	table_width 2, Mahogany_Map_Names
	dw Mahogany_Map_Name1 ; MAHOGANY_RED_GYARADOS_SPEECH_HOUSE
	dw Mahogany_Map_Name2 ; MAHOGANY_GYM
	dw Mahogany_Map_Name3 ; MAHOGANY_POKECENTER_1F
	dw Mahogany_Map_Name4 ; ROUTE_42_ECRUTEAK_GATE
	dw Mahogany_Map_Name5 ; ROUTE_42,
	dw Mahogany_Map_Name6 ; ROUTE_44,
	dw Mahogany_Map_Name7 ; MAHOGANY_TOWN,
	assert_table_length NUM_MAHOGANY_MAPS


Dungeons_Map_Names: ;newgroup DUNGEONS
	table_width 2, Dungeons_Map_Names
	dw Dungeons_Map_Name1 ; SPROUT_TOWER_1F
	dw Dungeons_Map_Name2 ; SPROUT_TOWER_2F
	dw Dungeons_Map_Name3 ; SPROUT_TOWER_3F
	dw Dungeons_Map_Name4 ; TIN_TOWER_1F
	dw Dungeons_Map_Name5 ; TIN_TOWER_2F
	dw Dungeons_Map_Name6 ; TIN_TOWER_3F
	dw Dungeons_Map_Name7 ; TIN_TOWER_4F
	dw Dungeons_Map_Name8 ; TIN_TOWER_5F
	dw Dungeons_Map_Name9 ; TIN_TOWER_6F
	dw Dungeons_Map_Name10 ; TIN_TOWER_7F
	dw Dungeons_Map_Name11 ; TIN_TOWER_8F
	dw Dungeons_Map_Name12 ; TIN_TOWER_9F
	dw Dungeons_Map_Name13 ; BURNED_TOWER_1F
	dw Dungeons_Map_Name14 ; BURNED_TOWER_B1F
	dw Dungeons_Map_Name15 ; NATIONAL_PARK
	dw Dungeons_Map_Name16 ; NATIONAL_PARK_BUG_CONTEST
	dw Dungeons_Map_Name17 ; RADIO_TOWER_1F
	dw Dungeons_Map_Name18 ; RADIO_TOWER_2F
	dw Dungeons_Map_Name19 ; RADIO_TOWER_3F
	dw Dungeons_Map_Name20 ; RADIO_TOWER_4F
	dw Dungeons_Map_Name21 ; RADIO_TOWER_5F
	dw Dungeons_Map_Name22 ; RUINS_OF_ALPH_OUTSIDE
	dw Dungeons_Map_Name23 ; RUINS_OF_ALPH_HO_OH_CHAMBER
	dw Dungeons_Map_Name24; RUINS_OF_ALPH_KABUTO_CHAMBER
	dw Dungeons_Map_Name25; RUINS_OF_ALPH_OMANYTE_CHAMBER
	dw Dungeons_Map_Name26 ; RUINS_OF_ALPH_AERODACTYL_CHAMBER
	dw Dungeons_Map_Name27 ; RUINS_OF_ALPH_INNER_CHAMBER
	dw Dungeons_Map_Name28 ; RUINS_OF_ALPH_RESEARCH_CENTER
	dw Dungeons_Map_Name29 ; RUINS_OF_ALPH_HO_OH_ITEM_ROOM
	dw Dungeons_Map_Name30 ; RUINS_OF_ALPH_KABUTO_ITEM_ROOM
	dw Dungeons_Map_Name31 ; RUINS_OF_ALPH_OMANYTE_ITEM_ROOM
	dw Dungeons_Map_Name32 ; RUINS_OF_ALPH_AERODACTYL_ITEM_ROOM
	dw Dungeons_Map_Name33 ; RUINS_OF_ALPH_HO_OH_WORD_ROOM
	dw Dungeons_Map_Name34 ; RUINS_OF_ALPH_KABUTO_WORD_ROOM
	dw Dungeons_Map_Name35 ; RUINS_OF_ALPH_OMANYTE_WORD_ROOM
	dw Dungeons_Map_Name36 ; RUINS_OF_ALPH_AERODACTYL_WORD_ROOM
	dw Dungeons_Map_Name37 ; UNION_CAVE_1F
	dw Dungeons_Map_Name38 ; UNION_CAVE_B1F
	dw Dungeons_Map_Name39 ; UNION_CAVE_B2F
	dw Dungeons_Map_Name40 ; SLOWPOKE_WELL_B1F
	dw Dungeons_Map_Name41 ; SLOWPOKE_WELL_B2F
	dw Dungeons_Map_Name42 ; OLIVINE_LIGHTHOUSE_1F
	dw Dungeons_Map_Name43 ; OLIVINE_LIGHTHOUSE_2F
	dw Dungeons_Map_Name44 ; OLIVINE_LIGHTHOUSE_3F
	dw Dungeons_Map_Name45 ; OLIVINE_LIGHTHOUSE_4F
	dw Dungeons_Map_Name46 ; OLIVINE_LIGHTHOUSE_5F
	dw Dungeons_Map_Name47 ; OLIVINE_LIGHTHOUSE_6F
	dw Dungeons_Map_Name48 ; MAHOGANY_MART_1F
	dw Dungeons_Map_Name49 ; TEAM_ROCKET_BASE_B1F
	dw Dungeons_Map_Name50 ; TEAM_ROCKET_BASE_B2F
	dw Dungeons_Map_Name51 ; TEAM_ROCKET_BASE_B3F
	dw Dungeons_Map_Name52 ; ILEX_FOREST
	dw Dungeons_Map_Name53 ; GOLDENROD_UNDERGROUND
	dw Dungeons_Map_Name54 ; GOLDENROD_UNDERGROUND_SWITCH_ROOM_ENTRANCES
	dw Dungeons_Map_Name55 ; GOLDENROD_DEPT_STORE_B1F
	dw Dungeons_Map_Name56 ; GOLDENROD_UNDERGROUND_WAREHOUSE
	dw Dungeons_Map_Name57 ; MOUNT_MORTAR_1F_OUTSIDE
	dw Dungeons_Map_Name58 ; MOUNT_MORTAR_1F_INSIDE
	dw Dungeons_Map_Name59 ; MOUNT_MORTAR_2F_INSIDE
	dw Dungeons_Map_Name60 ; MOUNT_MORTAR_B1F
	dw Dungeons_Map_Name61 ; ICE_PATH_1F
	dw Dungeons_Map_Name62 ; ICE_PATH_B1F
	dw Dungeons_Map_Name63 ; ICE_PATH_B2F_MAHOGANY_SIDE
	dw Dungeons_Map_Name64 ; ICE_PATH_B2F_BLACKTHORN_SIDE
	dw Dungeons_Map_Name65 ; ICE_PATH_B3F
	dw Dungeons_Map_Name66 ; WHIRL_ISLAND_NW
	dw Dungeons_Map_Name67 ; WHIRL_ISLAND_NE
	dw Dungeons_Map_Name68 ; WHIRL_ISLAND_SW
	dw Dungeons_Map_Name69 ; WHIRL_ISLAND_CAVE
	dw Dungeons_Map_Name70 ; WHIRL_ISLAND_SE
	dw Dungeons_Map_Name71 ; WHIRL_ISLAND_B1F
	dw Dungeons_Map_Name72 ; WHIRL_ISLAND_B2F
	dw Dungeons_Map_Name73 ; WHIRL_ISLAND_LUGIA_CHAMBER
	dw Dungeons_Map_Name74 ; SILVER_CAVE_ROOM_1
	dw Dungeons_Map_Name75 ; SILVER_CAVE_ROOM_2
	dw Dungeons_Map_Name76 ; SILVER_CAVE_ROOM_3
	dw Dungeons_Map_Name77 ; SILVER_CAVE_ITEM_ROOMS
	dw Dungeons_Map_Name78 ; DARK_CAVE_VIOLET_ENTRANCE
	dw Dungeons_Map_Name79 ; DARK_CAVE_BLACKTHORN_ENTRANCE
	dw Dungeons_Map_Name80 ; DRAGONS_DEN_1F
	dw Dungeons_Map_Name81 ; DRAGONS_DEN_B1F
	dw Dungeons_Map_Name82 ; DRAGON_SHRINE
	dw Dungeons_Map_Name83 ; TOHJO_FALLS
	dw Dungeons_Map_Name84 ; DIGLETTS_CAVE
	dw Dungeons_Map_Name85 ; MOUNT_MOON
	dw Dungeons_Map_Name86 ; UNDERGROUND_PATH
	dw Dungeons_Map_Name87 ; ROCK_TUNNEL_1F
	dw Dungeons_Map_Name88 ; ROCK_TUNNEL_B1F
	dw Dungeons_Map_Name89 ; VICTORY_ROAD
	dw Dungeons_Map_Name90 ; CLIFF_EDGE_GATE
	dw Dungeons_Map_Name91 ; CLIFF_CAVE
	dw Dungeons_Map_Name92 ; SEAFOAM_ISLANDS
	dw Dungeons_Map_Name93 ; SEAFOAM_ISLANDS_1F
	dw Dungeons_Map_Name94 ; SEAFOAM_ISLANDS_B1F
	dw Dungeons_Map_Name95 ; SEAFOAM_ISLANDS_B2F
	dw Dungeons_Map_Name96 ; SEAFOAM_ISLANDS_B3F
	dw Dungeons_Map_Name97 ; SEAFOAM_ISLANDS_B4F
	dw Dungeons_Map_Name98 ; CERULEAN_CAVE_1F
	dw Dungeons_Map_Name99 ; CERULEAN_CAVE_2F
	dw Dungeons_Map_Name100 ; CERULEAN_CAVE_B1F
	assert_table_length NUM_DUNGEONS_MAPS


Ecruteak_Map_Names: ;newgroup ECRUTEAK
	table_width 2, Ecruteak_Map_Names
	dw Ecruteak_Map_Name1 ; ECRUTEAK_TIN_TOWER_ENTRANCE
	dw Ecruteak_Map_Name2 ; WISE_TRIOS_ROOM
	dw Ecruteak_Map_Name3 ; ECRUTEAK_POKECENTER_1F
	dw Ecruteak_Map_Name4 ; ECRUTEAK_LUGIA_SPEECH_HOUSE
	dw Ecruteak_Map_Name5 ; DANCE_THEATRE
	dw Ecruteak_Map_Name6 ; ECRUTEAK_MART
	dw Ecruteak_Map_Name7 ; ECRUTEAK_GYM
	dw Ecruteak_Map_Name8 ; ECRUTEAK_ITEMFINDER_HOUSE
	dw Ecruteak_Map_Name9 ; ECRUTEAK_CITY
	assert_table_length NUM_ECRUTEAK_MAPS

Blackthorn_Map_Names: ;newgroup BLACKTHORN
	table_width 2, Blackthorn_Map_Names
	dw Blackthorn_Map_Name1 ; BLACKTHORN_GYM_1F
	dw Blackthorn_Map_Name2 ; BLACKTHORN_GYM_2F
	dw Blackthorn_Map_Name3 ; BLACKTHORN_DRAGON_SPEECH_HOUSE
	dw Blackthorn_Map_Name4 ; BLACKTHORN_EMYS_HOUSE
	dw Blackthorn_Map_Name5 ; BLACKTHORN_MART
	dw Blackthorn_Map_Name6 ; BLACKTHORN_POKECENTER_1F
	dw Blackthorn_Map_Name7 ; MOVE_DELETERS_HOUSE
	dw Blackthorn_Map_Name8 ; ROUTE_45
	dw Blackthorn_Map_Name9 ; ROUTE_46
	dw Blackthorn_Map_Name10 ; BLACKTHORN_CITY
	assert_table_length NUM_BLACKTHORN_MAPS

Cinnabar_Map_Names: ;newgroup CINNABAR
	table_width 2, Cinnabar_Map_Names
	dw Cinnabar_Map_Name1 ; CINNABAR_POKECENTER_1F
	dw Cinnabar_Map_Name3 ; ROUTE_19_FUCHSIA_GATE
	dw Cinnabar_Map_Name4 ; SEAFOAM_GYM
	dw Cinnabar_Map_Name5 ; ROUTE_19
	dw Cinnabar_Map_Name6 ; ROUTE_20
	dw Cinnabar_Map_Name7 ; ROUTE_21
	dw Cinnabar_Map_Name8 ; CINNABAR_ISLAND
	dw Cinnabar_Map_Name9 ; POKEMON_MANSION_1F
	dw Cinnabar_Map_Name10 ; POKEMON_MANSION_B1F
	assert_table_length NUM_CINNABAR_MAPS

Cerulean_Map_Names: ;newgroup CERULEAN
	table_width 2, Cerulean_Map_Names
	dw Cerulean_Map_Name1 ; CERULEAN_GYM_BADGE_SPEECH_HOUSE
	dw Cerulean_Map_Name2 ; CERULEAN_POLICE_STATION
	dw Cerulean_Map_Name3 ; CERULEAN_TRADE_SPEECH_HOUSE
	dw Cerulean_Map_Name4 ; CERULEAN_POKECENTER_1F
	dw Cerulean_Map_Name6 ; CERULEAN_GYM
	dw Cerulean_Map_Name7 ; CERULEAN_MART
	dw Cerulean_Map_Name8 ; ROUTE_10_POKECENTER_1F
	dw Cerulean_Map_Name10 ; POWER_PLANT
	dw Cerulean_Map_Name11 ; POWER_PLANT B1F
	dw Cerulean_Map_Name12 ; BILLS_HOUSE
	dw Cerulean_Map_Name13 ; ROUTE_4
	dw Cerulean_Map_Name14 ; ROUTE_9
	dw Cerulean_Map_Name15 ; ROUTE_10_NORTH
	dw Cerulean_Map_Name16 ; ROUTE_24
	dw Cerulean_Map_Name17 ; ROUTE_25
	dw Cerulean_Map_Name18 ; CERULEAN_CITY
	assert_table_length NUM_CERULEAN_MAPS

Azalea_Map_Names: ;newgroup AZALEA
	table_width 2, Azalea_Map_Names
	dw Azalea_Map_Name1 ; AZALEA_POKECENTER_1F
	dw Azalea_Map_Name2 ; CHARCOAL_KILN
	dw Azalea_Map_Name3 ; AZALEA_MART
	dw Azalea_Map_Name4 ; KURTS_HOUSE
	dw Azalea_Map_Name5 ; AZALEA_GYM
	dw Azalea_Map_Name6 ; ROUTE_33,
	dw Azalea_Map_Name7 ; AZALEA_TOWN,
	assert_table_length NUM_AZALEA_MAPS

Lake_of_Rage_Map_Names: ;newgroup LAKE_OF_RAGE
	table_width 2, Lake_of_Rage_Map_Names
	dw Lake_of_Rage_Map_Name1 ; LAKE_OF_RAGE_HIDDEN_POWER_HOUSE
	dw Lake_of_Rage_Map_Name2 ; LAKE_OF_RAGE_MAGIKARP_HOUSE
	dw Lake_of_Rage_Map_Name3 ; ROUTE_43_MAHOGANY_GATE
	dw Lake_of_Rage_Map_Name4 ; ROUTE_43_GATE
	dw Lake_of_Rage_Map_Name5 ; ROUTE_43
	dw Lake_of_Rage_Map_Name6 ; LAKE_OF_RAGE
	assert_table_length NUM_LAKE_OF_RAGE_MAPS

Violet_Map_Names: ;newgroup VIOLET
	table_width 2, Violet_Map_Names
	dw Violet_Map_Name1 ; ROUTE_32
	dw Violet_Map_Name2 ; ROUTE_32_COAST
	dw Violet_Map_Name3 ; ROUTE_35
	dw Violet_Map_Name4 ; ROUTE_36
	dw Violet_Map_Name5 ; ROUTE_37
	dw Violet_Map_Name6 ; VIOLET_CITY
	dw Violet_Map_Name7 ; VIOLET_MART
	dw Violet_Map_Name8 ; VIOLET_GYM
	dw Violet_Map_Name9 ; EARLS_POKEMON_ACADEMY
	dw Violet_Map_Name10 ; VIOLET_NICKNAME_SPEECH_HOUSE
	dw Violet_Map_Name11 ; VIOLET_POKECENTER_1F
	dw Violet_Map_Name12 ; VIOLET_KYLES_HOUSE
	dw Violet_Map_Name13 ; ROUTE_32_RUINS_OF_ALPH_GATE
	dw Violet_Map_Name14 ; ROUTE_32_POKECENTER_1F
	dw Violet_Map_Name15 ; ROUTE_35_GOLDENROD_GATE
	dw Violet_Map_Name16 ; ROUTE_35_NATIONAL_PARK_GATE
	dw Violet_Map_Name17 ; ROUTE_36_RUINS_OF_ALPH_GATE
	dw Violet_Map_Name18 ; ROUTE_36_NATIONAL_PARK_GATE
	assert_table_length NUM_VIOLET_MAPS

Goldenrod_Map_Names: ;newgroup GOLDENROD
	table_width 2, Goldenrod_Map_Names
	dw Goldenrod_Map_Name1 ; ROUTE_34,
	dw Goldenrod_Map_Name2 ; GOLDENROD_CITY,
	dw Goldenrod_Map_Name3 ; GOLDENROD_GYM,
	dw Goldenrod_Map_Name4 ; GOLDENROD_BIKE_SHOP
	dw Goldenrod_Map_Name5 ; GOLDENROD_HAPPINESS_RATER
	dw Goldenrod_Map_Name6 ; BILLS_FAMILYS_HOUSE
	dw Goldenrod_Map_Name7 ; GOLDENROD_MAGNET_TRAIN_STATION
	dw Goldenrod_Map_Name8 ; GOLDENROD_FLOWER_SHOP
	dw Goldenrod_Map_Name9 ; GOLDENROD_PP_SPEECH_HOUSE
	dw Goldenrod_Map_Name10 ; GOLDENROD_NAME_RATER
	dw Goldenrod_Map_Name11 ; GOLDENROD_DEPT_STORE_1F
	dw Goldenrod_Map_Name12 ; GOLDENROD_DEPT_STORE_2F
	dw Goldenrod_Map_Name13 ; GOLDENROD_DEPT_STORE_3F
	dw Goldenrod_Map_Name14 ; GOLDENROD_DEPT_STORE_4F
	dw Goldenrod_Map_Name15 ; GOLDENROD_DEPT_STORE_5F
	dw Goldenrod_Map_Name16 ; GOLDENROD_DEPT_STORE_6F
	dw Goldenrod_Map_Name17 ; GOLDENROD_DEPT_STORE_ELEVATOR
	dw Goldenrod_Map_Name18 ; GOLDENROD_DEPT_STORE_ROOF
	dw Goldenrod_Map_Name19 ; GOLDENROD_GAME_CORNER
	dw Goldenrod_Map_Name20 ; GOLDENROD_POKECENTER_1F
	dw Goldenrod_Map_Name21 ; ILEX_FOREST_AZALEA_GATE
	dw Goldenrod_Map_Name22 ; ROUTE_34_ILEX_FOREST_GATE
	dw Goldenrod_Map_Name23 ; DAY_CARE
	dw Goldenrod_Map_Name24 ; ROUTE_34_COAST
	dw Goldenrod_Map_Name25 ; ILEX_BEACH
	assert_table_length NUM_GOLDENROD_MAPS

Vermilion_Map_Names: ;newgroup VERMILION
	table_width 2, Vermilion_Map_Names
	dw Vermilion_Map_Name1 ; ROUTE_6,
	dw Vermilion_Map_Name2 ; ROUTE_11,
	dw Vermilion_Map_Name3 ; VERMILION_CITY
	dw Vermilion_Map_Name4 ; VERMILION_FISHING_SPEECH_HOUSE
	dw Vermilion_Map_Name5 ; VERMILION_POKECENTER_1F
	dw Vermilion_Map_Name7 ; POKEMON_FAN_CLUB
	dw Vermilion_Map_Name8 ; VERMILION_MAGNET_TRAIN_SPEECH_HOUSE
	dw Vermilion_Map_Name9 ; VERMILION_MART
	dw Vermilion_Map_Name10 ; VERMILION_DIGLETTS_CAVE_SPEECH_HOUS
	dw Vermilion_Map_Name11 ; VERMILION_GYM
	dw Vermilion_Map_Name12 ; ROUTE_6_SAFFRON_GATE
	dw Vermilion_Map_Name13 ; ROUTE_6_UNDERGROUND_PATH_ENTRANCE
	dw Vermilion_Map_Name14
	assert_table_length NUM_VERMILION_MAPS

Pallet_Map_Names: ;newgroup PALLET
	table_width 2, Pallet_Map_Names
	dw Pallet_Map_Name1 ; ROUTE_1
	dw Pallet_Map_Name2 ; PALLET_TOWN
	dw Pallet_Map_Name3 ; REDS_HOUSE_1F
	dw Pallet_Map_Name4 ; REDS_HOUSE_2F
	dw Pallet_Map_Name5 ; BLUES_HOUSE
	dw Pallet_Map_Name6 ; OAKS_LAB
	assert_table_length NUM_PALLET_MAPS

Pewter_Map_Names: ;newgroup PEWTER
	table_width 2, Pewter_Map_Names
	dw Pewter_Map_Name1 ; ROUTE_3
	dw Pewter_Map_Name2 ; PEWTER_CITY
	dw Pewter_Map_Name3 ; PEWTER_NIDORAN_SPEECH_HOUSE
	dw Pewter_Map_Name4 ; PEWTER_GYM
	dw Pewter_Map_Name5 ; PEWTER_MART
	dw Pewter_Map_Name6 ; PEWTER_POKECENTER_1F
	dw Pewter_Map_Name8 ; PEWTER_SNOOZE_SPEECH_HOUSE
	dw Pewter_Map_Name9
	dw Pewter_Map_Name10
	dw Pewter_Map_Name11 ; MOUNT_MOON_POKECENTER_1F
	dw Pewter_Map_Name12 ; ROUTE_2_NORTH
	assert_table_length NUM_PEWTER_MAPS

Fast_Ship_Map_Names: ;newgroup FAST_SHIP
	table_width 2, Fast_Ship_Map_Names
	dw Fast_Ship_Map_Name1 ; OLIVINE_PORT
	dw Fast_Ship_Map_Name2 ; VERMILION_PORT
	dw Fast_Ship_Map_Name3 ; FAST_SHIP_1F
	dw Fast_Ship_Map_Name4 ; FAST_SHIP_CABINS_NNW_NNE_NE
	dw Fast_Ship_Map_Name5 ; FAST_SHIP_CABINS_SW_SSW_NW
	dw Fast_Ship_Map_Name6 ; FAST_SHIP_CABINS_SE_SSE_CAPTAINS_CABIN
	dw Fast_Ship_Map_Name7 ; FAST_SHIP_B1F
	dw Fast_Ship_Map_Name8 ; OLIVINE_PORT_PASSAGE
	dw Fast_Ship_Map_Name9 ; VERMILION_PORT_PASSAGE,
	dw Fast_Ship_Map_Name10 ; MOUNT_MOON_SQUARE,
	dw Fast_Ship_Map_Name11 ; MOUNT_MOON_GIFT_SHOP
	dw Fast_Ship_Map_Name12 ; TIN_TOWER_ROOF
	assert_table_length NUM_FAST_SHIP_MAPS

Indigo_Map_Names: ;newgroup INDIGO
	table_width 2, Indigo_Map_Names
	dw Indigo_Map_Name1 ; ROUTE_23,
	dw Indigo_Map_Name2 ; INDIGO_PLATEAU_POKECENTER_1F
	dw Indigo_Map_Name3 ; WILLS_ROOM
	dw Indigo_Map_Name4 ; KOGAS_ROOM
	dw Indigo_Map_Name5 ; BRUNOS_ROOM
	dw Indigo_Map_Name6 ; KARENS_ROOM
	dw Indigo_Map_Name7 ; LANCES_ROOM
	dw Indigo_Map_Name8 ; HALL_OF_FAME
	assert_table_length NUM_INDIGO_MAPS

Fuchsia_Map_Names: ;newgroup FUCHSIA
	table_width 2, Fuchsia_Map_Names
	dw Fuchsia_Map_Name1 ; ROUTE_13
	dw Fuchsia_Map_Name2 ; ROUTE_14
	dw Fuchsia_Map_Name3 ; ROUTE_15
	dw Fuchsia_Map_Name5 ; FUCHSIA_CITY
	dw Fuchsia_Map_Name6 ; FUCHSIA_MART
	dw Fuchsia_Map_Name7 ; SAFARI_ZONE_MAIN_OFFICE
	dw Fuchsia_Map_Name8 ; FUCHSIA_GYM
	dw Fuchsia_Map_Name9 ; BILLS_BROTHERS_HOUSE
	dw Fuchsia_Map_Name10 ; FUCHSIA_POKECENTER_1F
	dw Fuchsia_Map_Name12 ; SAFARI_ZONE_WARDENS_HOME
	dw Fuchsia_Map_Name13 ; ROUTE_15_FUCHSIA_GATE
	assert_table_length NUM_FUCHSIA_MAPS

Lavender_Map_Names: ;newgroup LAVENDER
	table_width 2, Lavender_Map_Names
	dw Lavender_Map_Name1 ; ROUTE_8
	dw Lavender_Map_Name2 ; ROUTE_12
	dw Lavender_Map_Name3 ; ROUTE_10_SOUTH,
	dw Lavender_Map_Name4 ; LAVENDER_TOWN,
	dw Lavender_Map_Name5 ; LAVENDER_POKECENTER_1F
	dw Lavender_Map_Name7 ; MR_FUJIS_HOUSE
	dw Lavender_Map_Name8 ; LAVENDER_SPEECH_HOUSE
	dw Lavender_Map_Name9 ; LAVENDER_NAME_RATER
	dw Lavender_Map_Name10 ; LAVENDER_MART
	dw Lavender_Map_Name11 ; SOUL_HOUSE
	dw Lavender_Map_Name12 ; LAV_RADIO_TOWER_1F
	dw Lavender_Map_Name13 ; ROUTE_8_SAFFRON_GATE
	dw Lavender_Map_Name14 ; ROUTE_12_SUPER_ROD_HOUSE
	assert_table_length NUM_LAVENDER_MAPS

Silver_Map_Names: ;newgroup SILVER
	table_width 2, Silver_Map_Names
	dw Silver_Map_Name1 ; ROUTE_28
	dw Silver_Map_Name2 ; SILVER_CAVE_OUTSIDE
	dw Silver_Map_Name3 ; SILVER_CAVE_POKECENTER_1F
	dw Silver_Map_Name4 ; ROUTE_28_STEEL_WING_HOUSE
	assert_table_length NUM_SILVER_MAPS

Cable_Club_Map_Names: ;newgroup CABLE_CLUB
	table_width 2, Cable_Club_Map_Names
	dw Cable_Club_Map_Name1 ; POKECENTER_2F
	dw Cable_Club_Map_Name2 ; TRADE_CENTER
	dw Cable_Club_Map_Name3 ; COLOSSEUM
	dw Cable_Club_Map_Name4 ; TIME_CAPSULE
	assert_table_length NUM_CABLE_CLUB_MAPS

Celadon_Map_Names: ;newgroup CELADON
	table_width 2, Celadon_Map_Names
	dw Celadon_Map_Name1 ; ROUTE_7,
	dw Celadon_Map_Name2 ; ROUTE_16
	dw Celadon_Map_Name3 ; ROUTE_17
	dw Celadon_Map_Name27 ; ROUTE_18
	dw Celadon_Map_Name4 ; CELADON_CITY,20, 18
	dw Celadon_Map_Name5 ; CELADON_DEPT_STORE_1F
	dw Celadon_Map_Name6 ; CELADON_DEPT_STORE_2F
	dw Celadon_Map_Name7 ; CELADON_DEPT_STORE_3F
	dw Celadon_Map_Name8 ; CELADON_DEPT_STORE_4F
	dw Celadon_Map_Name9 ; CELADON_DEPT_STORE_5F
	dw Celadon_Map_Name10 ; CELADON_DEPT_STORE_6F
	dw Celadon_Map_Name11 ; CELADON_DEPT_STORE_ELEVATOR
	dw Celadon_Map_Name12 ; CELADON_MANSION_1F
	dw Celadon_Map_Name13 ; CELADON_MANSION_2F
	dw Celadon_Map_Name14 ; CELADON_MANSION_3F
	dw Celadon_Map_Name15 ; CELADON_MANSION_ROOF
	dw Celadon_Map_Name16 ; CELADON_MANSION_ROOF_HOUSE
	dw Celadon_Map_Name17 ; CELADON_POKECENTER_1F
	dw Celadon_Map_Name19 ; CELADON_GAME_CORNER
	dw Celadon_Map_Name20 ; CELADON_GAME_CORNER_PRIZE_ROOM
	dw Celadon_Map_Name21 ; CELADON_GYM
	dw Celadon_Map_Name22 ; CELADON_CAFE
	dw Celadon_Map_Name23 ; ROUTE_16_FUCHSIA_SPEECH_HOUSE
	dw Celadon_Map_Name24 ; ROUTE_16_GATE
	dw Celadon_Map_Name25 ; ROUTE_7_SAFFRON_GATE
	dw Celadon_Map_Name26 ; ROUTE_17_ROUTE_18_GATE
	assert_table_length NUM_CELADON_MAPS

Cianwood_Map_Names: ;newgroup CIANWOOD
	table_width 2, Cianwood_Map_Names
	dw Cianwood_Map_Name1 ; ROUTE_40
	dw Cianwood_Map_Name2 ; ROUTE_41
	dw Cianwood_Map_Name3 ; CIANWOOD_CITY
	dw Cianwood_Map_Name4 ; MANIAS_HOUSE
	dw Cianwood_Map_Name5 ; CIANWOOD_GYM
	dw Cianwood_Map_Name6 ; CIANWOOD_POKECENTER_1F
	dw Cianwood_Map_Name7 ; CIANWOOD_PHARMACY
	dw Cianwood_Map_Name8 ; CIANWOOD_PHOTO_STUDIO
	dw Cianwood_Map_Name9 ; CIANWOOD_LUGIA_SPEECH_HOUSE
	dw Cianwood_Map_Name10 ; POKE_SEERS_HOUSE
	dw Cianwood_Map_Name11 ; BATTLE_TOWER_1F
	dw Cianwood_Map_Name12 ; BATTLE_TOWER_BATTLE_ROOM
	dw Cianwood_Map_Name13 ; BATTLE_TOWER_ELEVATOR
	dw Cianwood_Map_Name14 ; BATTLE_TOWER_HALLWAY
	dw Cianwood_Map_Name15 ; ROUTE_40_BATTLE_TOWER_GATE
	dw Cianwood_Map_Name16 ; BATTLE_TOWER_OUTSIDE
	assert_table_length NUM_CIANWOOD_MAPS

Viridian_Map_Names: ;newgroup VIRIDIAN
	table_width 2, Viridian_Map_Names
	dw Viridian_Map_Name1 ; ROUTE_2
	dw Viridian_Map_Name2 ; ROUTE_22
	dw Viridian_Map_Name3 ; VIRIDIAN_CITY
	dw Viridian_Map_Name4 ; VIRIDIAN_GYM
	dw Viridian_Map_Name5 ; VIRIDIAN_NICKNAME_SPEECH_HOUSE
	dw Viridian_Map_Name6 ; TRAINER_HOUSE_1F
	dw Viridian_Map_Name7 ; TRAINER_HOUSE_B1F
	dw Viridian_Map_Name8 ; VIRIDIAN_MART
	dw Viridian_Map_Name9 ; VIRIDIAN_POKECENTER_1F
	dw Viridian_Map_Name11 ; ROUTE_2_NUGGET_HOUSE
	dw Viridian_Map_Name12 ; ROUTE_2_GATE
	dw Viridian_Map_Name13 ; VICTORY_ROAD_GATE
	dw Viridian_Map_Name14 ; VIRIDIAN_FOREST
	dw Viridian_Map_Name15 ; VIRIDIAN_FOREST_GATE_N
	dw Viridian_Map_Name16 ; VIRIDIAN_FOREST_GATE_S
	assert_table_length NUM_VIRIDIAN_MAPS


New_Bark_Map_Names: ; newgroup NEW_BARK
	table_width 2, New_Bark_Map_Names
	dw New_Bark_Map_Name1 ; ROUTE_26
	dw New_Bark_Map_Name2 ; ROUTE_27
	dw New_Bark_Map_Name3 ; ROUTE_29
	dw New_Bark_Map_Name4 ; NEW_BARK_TOWN,
	dw New_Bark_Map_Name5 ; ELMS_LAB
	dw New_Bark_Map_Name6 ; PLAYERS_HOUSE_1F
	dw New_Bark_Map_Name7 ; PLAYERS_HOUSE_2F
	dw New_Bark_Map_Name8 ; PLAYERS_NEIGHBORS_HOUSE
	dw New_Bark_Map_Name9 ; ELMS_HOUSE
	dw New_Bark_Map_Name10 ; ROUTE_26_HEAL_HOUSE
	dw New_Bark_Map_Name11 ; DAY_OF_WEEK_SIBLINGS_HOUSE
	dw New_Bark_Map_Name12 ; ROUTE_27_SANDSTORM_HOUSE
	dw New_Bark_Map_Name13 ; ROUTE_29_ROUTE_46_GATE
	assert_table_length NUM_NEW_BARK_MAPS


	; newgroup SAFFRON
Saffron_Map_Names:
	table_width 2, Saffron_Map_Names
	dw Saffron_Map_Name1 ; ROUTE_5,
	dw Saffron_Map_Name2 ; SAFFRON_CITY,20, 18
	dw Saffron_Map_Name3 ; FIGHTING_DOJO
	dw Saffron_Map_Name4 ; SAFFRON_GYM,
	dw Saffron_Map_Name5 ; SAFFRON_MART
	dw Saffron_Map_Name6 ; SAFFRON_POKECENTER_1F
	dw Saffron_Map_Name8 ; MR_PSYCHICS_HOUSE
	dw Saffron_Map_Name9 ; SAFFRON_MAGNET_TRAIN_STATION,10,  9
	dw Saffron_Map_Name10 ; SILPH_CO_1F
	dw Saffron_Map_Name11 ; COPYCATS_HOUSE_1F
	dw Saffron_Map_Name12 ; COPYCATS_HOUSE_2F
	dw Saffron_Map_Name13 ; ROUTE_5_UNDERGROUND_PATH_ENTRANCE
	dw Saffron_Map_Name14 ; ROUTE_5_SAFFRON_GATE
	dw Saffron_Map_Name15 ; ROUTE_5_CLEANSE_TAG_HOUSE
	assert_table_length NUM_SAFFRON_MAPS

	; CHERRYGROVE, 26
Cherrygrove_Map_Names:
	table_width 2, Cherrygrove_Map_Names
	dw Cherrygrove_Map_Name1 ; ROUTE_30
	dw Cherrygrove_Map_Name2 ; ROUTE_31
	dw Cherrygrove_Map_Name3 ; CHERRYGROVE_CITY
	dw Cherrygrove_Map_Name4 ; CHERRYGROVE_CITY
	dw Cherrygrove_Map_Name5 ; CHERRYGROVE_POKECENTER_1F
	dw Cherrygrove_Map_Name6 ; CHERRYGROVE_GYM_SPEECH_HOUSE
	dw Cherrygrove_Map_Name7 ; GUIDE_GENTS_HOUSE
	dw Cherrygrove_Map_Name8 ; CHERRYGROVE_EVOLUTION_SPEECH_HOUSE
	dw Cherrygrove_Map_Name9 ; ROUTE_30_BERRY_HOUSE 0
	dw Cherrygrove_Map_Name10 ; MR_POKEMONS_HOUSE
	dw Cherrygrove_Map_Name11 ; ROUTE_31_VIOLET_GATE
	dw Cherrygrove_Map_Name12 ; GATE
	assert_table_length NUM_CHERRYGROVE_MAPS

	;SAFARI ZONE
SafariZone_Map_Names:
	table_width 2, SafariZone_Map_Names
	dw SafariZone_Map_Name1 ; ROUTE_47
	dw SafariZone_Map_Name2 ; ROUTE_48
	dw SafariZone_Map_Name3 ; SAFARI_ZONE_ENTRANCE
	dw SafariZone_Map_Name4 ; SAFARI_ZONE_GATE
	dw SafariZone_Map_Name5 ; SAFARI_ZONE_GATE_POKECENTER_1F
	dw SafariZone_Map_Name6 ; SAFARI_ZONE_AREA_1
	dw SafariZone_Map_Name7 ; SAFARI_ZONE_AREA_2
	dw SafariZone_Map_Name8 ; SAFARI_ZONE_AREA_4
	dw SafariZone_Map_Name9 ; SAFARI_REST_HOUSE_AREA_1
	dw SafariZone_Map_Name10 ; SAFARI_REST_HOUSE_AREA_2
	dw SafariZone_Map_Name11 ; SAFARI_REST_HOUSE_AREA_3
	dw SafariZone_Map_Name12 ; SAFARI_REST_HOUSE_AREA_4
	assert_table_length NUM_SAFARI_ZONE_MAPS

	;SAFARI ZONE AREA 3
SafariZone3_Map_Names:
	table_width 2, SafariZone3_Map_Names
	dw SafariZone3_Map_Name1 ; SAFARI_ZONE_AREA_3
	assert_table_length NUM_SAFARI_ZONE_3_MAPS

; MAX LENGTH: 17
Olivine_Map_Name1: db "OLIVINE<BSP>", $E1, $E2, " CENTER@"
Olivine_Map_Name2: db "OLIVINE<BSP>GYM@"
Olivine_Map_Name3: db "TIM'S HOUSE@"
Olivine_Map_Name5: db "OLIVINE<BSP>HOUSE 1@"
Olivine_Map_Name6: db "OLIVINE<BSP>HOUSE 2@"
Olivine_Map_Name7: db "OLIVINE<BSP>CAFE@"
Olivine_Map_Name8: db "OLIVINE ", $70, $71, "MART@"
Olivine_Map_Name9: db "ROUTE 38 GATE@"
Olivine_Map_Name10: db "ROUTE 39 BARN@"
Olivine_Map_Name11: db "ROUTE 39 HOUSE@"
Olivine_Map_Name12: db "ROUTE 38@"
Olivine_Map_Name13: db "ROUTE 39@"
Olivine_Map_Name14: db "OLIVINE<BSP>CITY@"
Olivine_Map_Name15: db "ROUTE 35 COAST@"
Olivine_Map_Name16: db "GOLDENROD HARBOR@"
Olivine_Map_Name17: db "GOLD. HARBOR GATE@"

Mahogany_Map_Name1: db "MAHOGANY<BSP>HOUSE@"
Mahogany_Map_Name2: db "MAHOGANY<BSP>GYM@"
Mahogany_Map_Name3: db "MAHOGANY<BSP>PC@"
Mahogany_Map_Name4: db "ROUTE 42 GATE@"
Mahogany_Map_Name5: db "ROUTE 42@"
Mahogany_Map_Name6: db "ROUTE 44@"
Mahogany_Map_Name7: db "MAHOGANY<BSP>TOWN@"

Dungeons_Map_Name1: db "SPROUT<BSP>TOWER 1F@"
Dungeons_Map_Name2: db "SPROUT<BSP>TOWER 2F@"
Dungeons_Map_Name3: db "SPROUT<BSP>TOWER 3F@"
Dungeons_Map_Name4: db "TIN TOWER 1F@"
Dungeons_Map_Name5: db "TIN TOWER 2F@"
Dungeons_Map_Name6: db "TIN TOWER 3F@"
Dungeons_Map_Name7: db "TIN TOWER 4F@"
Dungeons_Map_Name8: db "TIN TOWER 5F@"
Dungeons_Map_Name9: db "TIN TOWER 6F@"
Dungeons_Map_Name10: db "TIN TOWER 7F@"
Dungeons_Map_Name11: db "TIN TOWER 8F@"
Dungeons_Map_Name12: db "TIN TOWER 9F@"
Dungeons_Map_Name13: db "BURNED<BSP>TOWER 1F@"
Dungeons_Map_Name14: db "BURNED<BSP>TOWER B1F@"
Dungeons_Map_Name15: db "NATIONAL<BSP>PARK@"
Dungeons_Map_Name16: db "BUG CONTEST@"
Dungeons_Map_Name17: db "RADIO TOWER 1F@"
Dungeons_Map_Name18: db "RADIO TOWER 2F@"
Dungeons_Map_Name19: db "RADIO TOWER 3F@"
Dungeons_Map_Name20: db "RADIO TOWER 4F@"
Dungeons_Map_Name21: db "RADIO TOWER 5F@"
Dungeons_Map_Name22: db "RUINS OF ALPH@"
Dungeons_Map_Name23: db "HO<BSP>OH CHAMBER@"
Dungeons_Map_Name24: db "KABUTO CHAMBER@"
Dungeons_Map_Name25: db "OMANYTE CHAMBER@"
Dungeons_Map_Name26: db "AERO CHAMBER@"
Dungeons_Map_Name27: db "RUINS CHAMBER@"
Dungeons_Map_Name28: db "RUINS LAB@"
Dungeons_Map_Name29: db "HO<BSP>OH PRIZE ROOM@"
Dungeons_Map_Name30: db "KABUTO PRIZE ROOM@"
Dungeons_Map_Name31: db "OMANYTE PRIZEROOM@"
Dungeons_Map_Name32: db "AERO PRIZE ROOM@"
Dungeons_Map_Name33: db "HO<BSP>OH WORD ROOM@"
Dungeons_Map_Name34: db "KABUTO WORD ROOM@"
Dungeons_Map_Name35: db "OMANYTE WORD ROOM@"
Dungeons_Map_Name36: db "AERO WORD ROOM@"
Dungeons_Map_Name37: db "UNION CAVE 1F@"
Dungeons_Map_Name38: db "UNION CAVE B1F@"
Dungeons_Map_Name39: db "UNION CAVE B2F@"
Dungeons_Map_Name40: db "SLOWPOKEWELL B1@"
Dungeons_Map_Name41: db "SLOWPOKEWELL B2@"
Dungeons_Map_Name42: db "LIGHTHOUSE 1F@"
Dungeons_Map_Name43: db "LIGHTHOUSE 2F@"
Dungeons_Map_Name44: db "LIGHTHOUSE 3F@"
Dungeons_Map_Name45: db "LIGHTHOUSE 4F@"
Dungeons_Map_Name46: db "LIGHTHOUSE 5F@"
Dungeons_Map_Name47: db "LIGHTHOUSE 6F@"
Dungeons_Map_Name48: db "MAHOGANY ", $70, $71, "MART@"
Dungeons_Map_Name49: db "ROCKET BASE B1F@"
Dungeons_Map_Name50: db "ROCKET BASE B2F@"
Dungeons_Map_Name51: db "ROCKET BASE B3F@"
Dungeons_Map_Name52: db "ILEX FOREST@"
Dungeons_Map_Name53: db "GOLD. UNDERGROUND@"
Dungeons_Map_Name54: db "GOLD. SWITCH ROOM@"
Dungeons_Map_Name55: db "GOLD. DEPT B1F@"
Dungeons_Map_Name56: db "GOLD. DEPT B1F@"
Dungeons_Map_Name57: db "MT. MORTAR@"
Dungeons_Map_Name58: db "MT. MORTAR 1F@"
Dungeons_Map_Name59: db "MT. MORTAR 2F@"
Dungeons_Map_Name60: db "MT. MORTAR B1F@"
Dungeons_Map_Name61: db "ICE PATH 1F@"
Dungeons_Map_Name62: db "ICE PATH B1F@"
Dungeons_Map_Name63: db "ICE PATH B2F W@"
Dungeons_Map_Name64: db "ICE PATH B2F E@"
Dungeons_Map_Name65: db "ICE PATH B3F@"
Dungeons_Map_Name66: db "WHIRL<BSP>ISL NW@"
Dungeons_Map_Name67: db "WHIRL<BSP>ISL NE@"
Dungeons_Map_Name68: db "WHIRL<BSP>ISL SW@"
Dungeons_Map_Name69: db "WHIRL<BSP>ISL CAVE@"
Dungeons_Map_Name70: db "WHIRL<BSP>ISL SE@"
Dungeons_Map_Name71: db "WHIRL<BSP>ISL B1F@"
Dungeons_Map_Name72: db "WHIRL<BSP>ISL B2F@"
Dungeons_Map_Name73: db "WHIRL<BSP>ISL DEEP@"
Dungeons_Map_Name74: db "SILVER CAVE R1@"
Dungeons_Map_Name75: db "SILVER CAVE R2@"
Dungeons_Map_Name76: db "SILVER CAVE R3@"
Dungeons_Map_Name77: db "SILVER CAVE ROOM@"
Dungeons_Map_Name78: db "DARK CAVE WEST@"
Dungeons_Map_Name79: db "DARK CAVE EAST@"
Dungeons_Map_Name80: db "DRAGONS<BSP>DEN 1F@"
Dungeons_Map_Name81: db "DRAGONS<BSP>DEN B1@"
Dungeons_Map_Name82: db "DRAGON SHRINE@"
Dungeons_Map_Name83: db "TOHJO FALLS@"
Dungeons_Map_Name84: db "DIGLETTS<BSP>CAVE@"
Dungeons_Map_Name85: db "MT. MOON@"
Dungeons_Map_Name86: db "UNDERGROUND PATH@"
Dungeons_Map_Name87: db "ROCK TUNNEL 1F@"
Dungeons_Map_Name88: db "ROCK TUNNEL B1F@"
Dungeons_Map_Name89: db "VICTORY<BSP>ROAD@"
Dungeons_Map_Name90: db "CLIFF EDGE GATE@"
Dungeons_Map_Name91: db "CLIFF CAVE@"
Dungeons_Map_Name92: db "SEAFOAM<BSP>ISL@"
Dungeons_Map_Name93: db "SEAFOAM<BSP>ISL<BSP>1F@"
Dungeons_Map_Name94: db "SEAFOAM<BSP>ISL<BSP>B1F@"
Dungeons_Map_Name95: db "SEAFOAM<BSP>ISL<BSP>B2F@"
Dungeons_Map_Name96: db "SEAFOAM<BSP>ISL<BSP>B3F@"
Dungeons_Map_Name97: db "SEAFOAM<BSP>ISL<BSP>B4F@"
Dungeons_Map_Name98: db "CERULEAN<BSP>CAVE<BSP>1F@"
Dungeons_Map_Name99: db "CERULEAN<BSP>CAVE<BSP>2F@"
Dungeons_Map_Name100: db "CERULEAN<BSP>CAVE<BSP>B1F@"

Ecruteak_Map_Name1: db "TIN TOWER PATH@"
Ecruteak_Map_Name2: db "WISE TRIO ROOM@"
Ecruteak_Map_Name3: db "ECRUTEAK ", $E1, $E2, "CENTER@"
Ecruteak_Map_Name4: db "ECRUTEAK<BSP>HOUSE 1@"
Ecruteak_Map_Name5: db "DANCE THEATER@"
Ecruteak_Map_Name6: db "ECRUTEAK ", $70, $71, "MART@"
Ecruteak_Map_Name7: db "ECRUTEAK<BSP>GYM@"
Ecruteak_Map_Name8: db "ITEMFINDER<BSP>HOUSE@"
Ecruteak_Map_Name9: db "ECRUTEAK<BSP>CITY@"


Blackthorn_Map_Name1: db "BLACKTHORN<BSP>GYM@"
Blackthorn_Map_Name2: db "BLACKTHORN<BSP>GYM B1@"
Blackthorn_Map_Name3: db "DRAGON HOUSE@"
Blackthorn_Map_Name4: db "EMY'S HOUSE@"
Blackthorn_Map_Name5: db "BLACKTHORN ", $70, $71, "MART@"
Blackthorn_Map_Name6: db "BLACKTHORN ", $E1, $E2, "CEN.@"
Blackthorn_Map_Name7: db "MOVE DELETER@"
Blackthorn_Map_Name8: db "ROUTE 45@"
Blackthorn_Map_Name9: db "ROUTE 46@"
Blackthorn_Map_Name10: db "BLACKTHORN<BSP>CITY@"


Cinnabar_Map_Name1: db "CINNABAR ", $E1, $E2, "CENTER@"
Cinnabar_Map_Name3: db "ROUTE 19 GATE@"
Cinnabar_Map_Name4: db "SEAFOAM<BSP>GYM@"
Cinnabar_Map_Name5: db "ROUTE 19@"
Cinnabar_Map_Name6: db "ROUTE 20@"
Cinnabar_Map_Name7: db "ROUTE 21@"
Cinnabar_Map_Name8: db "CINNABAR<BSP>ISLAND@"
Cinnabar_Map_Name9: db "CINNABAR<BSP>VOLCANO@"
Cinnabar_Map_Name10: db "CINNABAR<BSP>VOLCANO@"


Cerulean_Map_Name1: db "CERULEAN<BSP>HOUSE 1@"
Cerulean_Map_Name2: db "POLICE STATION@"
Cerulean_Map_Name3: db "CERULEAN<BSP>HOUSE 2@"
Cerulean_Map_Name4: db "CERULEAN ", $E1, $E2, "CENTER@"
Cerulean_Map_Name6: db "CERULEAN<BSP>GYM@"
Cerulean_Map_Name7: db "CERULEAN ", $70, $71, "MART@"
Cerulean_Map_Name8: db "ROUTE 10 ", $E1, $E2, "CENTER@"
Cerulean_Map_Name10: db "POWER PLANT@"
Cerulean_Map_Name11: db "POWER PLANT B1F@"
Cerulean_Map_Name12: db "BILL'S HOUSE@"
Cerulean_Map_Name13: db "ROUTE 4@"
Cerulean_Map_Name14: db "ROUTE 9@"
Cerulean_Map_Name15: db "ROUTE 10 NORTH@"
Cerulean_Map_Name16: db "ROUTE 24@"
Cerulean_Map_Name17: db "ROUTE 25@"
Cerulean_Map_Name18: db "CERULEAN<BSP>CITY@"

Azalea_Map_Name1: db "AZALEA ", $E1, $E2, "CENTER@"
Azalea_Map_Name2: db "CHARCOAL KILN@"
Azalea_Map_Name3: db "AZALEA ", $70, $71, "MART@"
Azalea_Map_Name4: db "KURT'S HOUSE@"
Azalea_Map_Name5: db "AZALEA GYM@"
Azalea_Map_Name6: db "ROUTE 33@"
Azalea_Map_Name7: db "AZALEA TOWN@"

Lake_of_Rage_Map_Name1: db "HIDDEN<BSP>POWER<BSP>HS@"
Lake_of_Rage_Map_Name2: db "MAGIKARP<BSP>HOUSE@"
Lake_of_Rage_Map_Name3: db "RT 43 GATE 1@"
Lake_of_Rage_Map_Name4: db "RT 43 GATE 2@"
Lake_of_Rage_Map_Name5: db "ROUTE 43@"
Lake_of_Rage_Map_Name6: db "LAKE OF<BSP>RAGE@"

Violet_Map_Name1: db "ROUTE 32@"
Violet_Map_Name2: db "ROUTE 32 COAST@"
Violet_Map_Name3: db "ROUTE 35@"
Violet_Map_Name4: db "ROUTE 36@"
Violet_Map_Name5: db "ROUTE 37@"
Violet_Map_Name6: db "VIOLET CITY@"
Violet_Map_Name7: db "VIOLET ", $70, $71, "MART@"
Violet_Map_Name8: db "VIOLET GYM@"
Violet_Map_Name9: db "EARL'S ACADEMY@"
Violet_Map_Name10: db "VIOLET HOUSE 1@"
Violet_Map_Name11: db "VIOLET ", $E1, $E2, "CENTER@"
Violet_Map_Name12: db "KYLE'S HOUSE@"
Violet_Map_Name13: db "ROUTE 32 GATE ROA@"
Violet_Map_Name14: db "ROUTE 32 ", $E1, $E2, "CENTER@"
Violet_Map_Name15: db "ROUTE 35 GATE@"
Violet_Map_Name16: db "ROUTE 35<BSP>PARK GATE@"
Violet_Map_Name17: db "ROUTE 36 GATE ROA@"
Violet_Map_Name18: db "ROUTE 36 GATE@"

Goldenrod_Map_Name1: db "ROUTE 34@"
Goldenrod_Map_Name2: db "GOLDENROD<BSP>CITY@"
Goldenrod_Map_Name3: db "GOLDENROD<BSP>GYM@"
Goldenrod_Map_Name4: db "GOLD. BIKE SHOP@"
Goldenrod_Map_Name5: db "HAPPINESS<BSP>RATER@"
Goldenrod_Map_Name6: db "BILL'S FAM. HOUSE@"
Goldenrod_Map_Name7: db "TRAIN STATION 1@"
Goldenrod_Map_Name8: db "FLOWER SHOP@"
Goldenrod_Map_Name9: db "GOLDENROD HOUSE 1"
Goldenrod_Map_Name10: db "GOLD. NAME RATER@"
Goldenrod_Map_Name11: db "GOLD.DEPTSTORE 1F@"
Goldenrod_Map_Name12: db "GOLD.DEPTSTORE 2F@"
Goldenrod_Map_Name13: db "GOLD.DEPTSTORE 3F@"
Goldenrod_Map_Name14: db "GOLD.DEPTSTORE 4F@"
Goldenrod_Map_Name15: db "GOLD.DEPTSTORE 5F@"
Goldenrod_Map_Name16: db "GOLD.DEPTSTORE 6F@"
Goldenrod_Map_Name17: db "GOLD. DEPT LIFT@"
Goldenrod_Map_Name18: db "GOLD. DEPT ROOF@"
Goldenrod_Map_Name19: db "GOLD. GAME CORNER@"
Goldenrod_Map_Name20: db "GOLDENROD", $E1, $E2, "CENTER@"
Goldenrod_Map_Name21: db "AZALEA GATE@"
Goldenrod_Map_Name22: db "ILEX GATE@"
Goldenrod_Map_Name23: db "JOHTO DAYCARE@"
Goldenrod_Map_Name24: db "ROUTE 34 COAST@"
Goldenrod_Map_Name25: db "ILEX BEACH@"

Vermilion_Map_Name1: db "ROUTE 6@"
Vermilion_Map_Name2: db "ROUTE 11@"
Vermilion_Map_Name3: db "VERMILION<BSP>CITY@"
Vermilion_Map_Name4: db "VERMILION<BSP>HOUSE 1@"
Vermilion_Map_Name5: db "VERMILION ", $E1, $E2, "CENT.@"
Vermilion_Map_Name7: db "VERMILION<BSP>FANCLUB@"
Vermilion_Map_Name8: db "VERMILION<BSP>HOUSE 2@"
Vermilion_Map_Name9: db "VERMILION ", $70, $71, "MART@"
Vermilion_Map_Name10: db "VERMILION<BSP>HOUSE 3@"
Vermilion_Map_Name11: db "VERMILION<BSP>GYM@"
Vermilion_Map_Name12: db "ROUTE 6 GATE@"
Vermilion_Map_Name13: db "ROUTE 6 UNDER.@"
Vermilion_Map_Name14: db "GATE@"

Pallet_Map_Name1: db "ROUTE 1@"
Pallet_Map_Name2: db "PALLET TOWN@"
Pallet_Map_Name3: db "RED'S HOUSE 1F@"
Pallet_Map_Name4: db "RED'S HOUSE 2F@"
Pallet_Map_Name5: db "BLUE'S HOUSE@"
Pallet_Map_Name6: db "OAK'S LAB@"

Pewter_Map_Name1: db "ROUTE 3@"
Pewter_Map_Name2: db "PEWTER CITY@"
Pewter_Map_Name3: db "PEWTER HOUSE 1@"
Pewter_Map_Name4: db "PEWTER GYM@"
Pewter_Map_Name5: db "PEWTER ", $70, $71, "MART@"
Pewter_Map_Name6: db "PEWTER ", $E1, $E2, "CENTER@"
Pewter_Map_Name8: db "PEWTER HOUSE 2@"
Pewter_Map_Name9: db "PEWTER MUSEUM@"
Pewter_Map_Name10: db "PEWTER MUSEUM@"
Pewter_Map_Name11: db "MT. MOON ", $E1, $E2, "CENTER@"
Pewter_Map_Name12: db "ROUTE 2 NORTH@"

Fast_Ship_Map_Name1: db "OLIVINE MARINA@"
Fast_Ship_Map_Name2: db "VERMILION MARINA@"
Fast_Ship_Map_Name3: db "S.S. AQUA@"
Fast_Ship_Map_Name4: db "S.S. AQUA CABIN 1@"
Fast_Ship_Map_Name5: db "S.S. AQUA CABIN 1@"
Fast_Ship_Map_Name6: db "S.S. AQUA CPTQTRS@"
Fast_Ship_Map_Name7: db "S.S. AQUA GALLEY@"
Fast_Ship_Map_Name8: db "JOHTO PORTPASSAGE@"
Fast_Ship_Map_Name9: db "KANTO PORTPASSAGE@"
Fast_Ship_Map_Name10: db "MT. MOON SQUARE@"
Fast_Ship_Map_Name11: db "MT. MOON SHOP@"
Fast_Ship_Map_Name12: db "TIN TOWER ROOF@"

Indigo_Map_Name1: db "ROUTE 23@"
Indigo_Map_Name2: db "INDIGO<BSP>PLATEAU@"
Indigo_Map_Name3: db "E4 WILL'S ROOM@"
Indigo_Map_Name4: db "E4 KOGA'S ROOM@"
Indigo_Map_Name5: db "E4 BRUNO'S ROOM@"
Indigo_Map_Name6: db "E4 KAREN'S ROOM@"
Indigo_Map_Name7: db "E4 LANCE'S ROOM@"
Indigo_Map_Name8: db "E4 HALL OF FAME@"

Fuchsia_Map_Name1: db "ROUTE 13@"
Fuchsia_Map_Name2: db "ROUTE 14@"
Fuchsia_Map_Name3: db "ROUTE 15@"
Fuchsia_Map_Name5: db "FUCHSIA<BSP>CITY@"
Fuchsia_Map_Name6: db "FUCHSIA ", $70, $71, "MART@"
Fuchsia_Map_Name7: db "SAFARI ZONE HQ@"
Fuchsia_Map_Name8: db "FUCHSIA<BSP>GYM@"
Fuchsia_Map_Name9: db "BILL'S BRO HOUSE@"
Fuchsia_Map_Name10: db "FUCHSIA ", $E1, $E2, "CENTER@"
Fuchsia_Map_Name12: db "WARDEN'S HOUSE@"
Fuchsia_Map_Name13: db "FUCHSIA<BSP>GATE@"

Lavender_Map_Name1: db "ROUTE 8@"
Lavender_Map_Name2: db "ROUTE 12@"
Lavender_Map_Name3: db "ROUTE 10 S.@"
Lavender_Map_Name4: db "LAVENDER<BSP>TOWN@"
Lavender_Map_Name5: db "LAVENDER ", $E1, $E2, "CENTER@"
Lavender_Map_Name7: db "MR.FUJI'S HOUSE@"
Lavender_Map_Name8: db "LAVENDER<BSP>HOUSE 1@"
Lavender_Map_Name9: db "KANTO NAME RATER@"
Lavender_Map_Name10: db "LAVENDER ", $70, $71, "MART@"
Lavender_Map_Name11: db "SOUL HOUSE@"
Lavender_Map_Name12: db "KANTO<BSP>RADIO TOWER@"
Lavender_Map_Name13: db "ROUTE 8 GATE@"
Lavender_Map_Name14: db "ROUTE 12 ANGLER@"

Silver_Map_Name1: db "ROUTE 28@"
Silver_Map_Name2: db "MT. SILVER@"
Silver_Map_Name3: db "SILVER C.", $E1, $E2, "CENTER@"
Silver_Map_Name4: db "ROUTE 28 CABIN@"

Cable_Club_Map_Name1: db $E1, $E2, " CENTER 2F@"
Cable_Club_Map_Name2: db $E1, $E2, " TRADE CENTER@"
Cable_Club_Map_Name3: db $E1, $E2, " COLOSSEUM@"
Cable_Club_Map_Name4: db $E1, $E2, " TIME CAPSULE@"

Celadon_Map_Name1: db "ROUTE 7@"
Celadon_Map_Name2: db "ROUTE 16@"
Celadon_Map_Name3: db "ROUTE 17@"
Celadon_Map_Name27: db "ROUTE 18@"
Celadon_Map_Name4: db "CELADON<BSP>CITY@"
Celadon_Map_Name5: db "CEL. DEPTSTORE 1F@"
Celadon_Map_Name6: db "CEL. DEPTSTORE 2F@"
Celadon_Map_Name7: db "CEL. DEPTSTORE 3F@"
Celadon_Map_Name8: db "CEL. DEPTSTORE 4F@"
Celadon_Map_Name9: db "CEL. DEPTSTORE 5F@"
Celadon_Map_Name10: db "CEL. DEPTSTORE 6F@"
Celadon_Map_Name11: db "CELADON DEPT LIFT@"
Celadon_Map_Name12: db "CELADON MANSION1F@"
Celadon_Map_Name13: db "CELADON MANSION2F@"
Celadon_Map_Name14: db "CELADON MANSION3F@"
Celadon_Map_Name15: db "CEL. MANSION ROOF@"
Celadon_Map_Name16: db "CELADON MANSION4F@"
Celadon_Map_Name17: db "CELADON ", $E1, $E2, "CENTER@"
Celadon_Map_Name19: db "CEL. GAME CORNER@"
Celadon_Map_Name20: db "CELADON PRIZE ROOM@"
Celadon_Map_Name21: db "CELADON GYM@"
Celadon_Map_Name22: db "CELADON CAFE@"
Celadon_Map_Name23: db "ROUTE 16 HOUSE@"
Celadon_Map_Name24: db "ROUTE 16 GATE@"
Celadon_Map_Name25: db "ROUTE 7 GATE@"
Celadon_Map_Name26: db "ROUTE 17&18 GATE@"

Cianwood_Map_Name1: db "ROUTE 40@"
Cianwood_Map_Name2: db "ROUTE 41@"
Cianwood_Map_Name3: db "CIANWOOD<BSP>CITY@"
Cianwood_Map_Name4: db "MANIA'S HOUSE@"
Cianwood_Map_Name5: db "CIANWOOD<BSP>GYM@"
Cianwood_Map_Name6: db "CIANWOOD ", $E1, $E2, "CENTER@"
Cianwood_Map_Name7: db "CIANWOOD<BSP>PHARMACY@"
Cianwood_Map_Name8: db "CIANWOOD<BSP>STUDIO@"
Cianwood_Map_Name9: db "CIANWOOD HOUSE@"
Cianwood_Map_Name10: db "POKESEER HOUSE@"
Cianwood_Map_Name11: db "BATTLE TOWER 1F@"
Cianwood_Map_Name12: db "BATTLE TOWER ROOM@"
Cianwood_Map_Name13: db "BATTLE TOWER LIFT@"
Cianwood_Map_Name14: db "BATTLE TOWER HALL@"
Cianwood_Map_Name15: db "ROUTE 40 GATE@"
Cianwood_Map_Name16: db "BATTLE TOWER@"

Viridian_Map_Name1: db "ROUTE 2@"
Viridian_Map_Name2: db "ROUTE 22@"
Viridian_Map_Name3: db "VIRIDIAN<BSP>CITY@"
Viridian_Map_Name4: db "VIRIDIAN<BSP>GYM@"
Viridian_Map_Name5: db "VIRIDIAN<BSP>HOUSE 2@"
Viridian_Map_Name6: db "VIRIDIAN<BSP>HOUSE 1F@"
Viridian_Map_Name7: db "VIRIDIAN<BSP>HOUSEB1F@"
Viridian_Map_Name8: db "VIRIDIAN ", $70, $71, "MART@"
Viridian_Map_Name9: db "VIRIDIAN ", $E1, $E2, "CENTER@"
Viridian_Map_Name11: db "RT 2 NUGGET HOUSE@"
Viridian_Map_Name12: db "ROUTE 2 GATE@"
Viridian_Map_Name13: db "VICTORY<BSP>ROAD GATE@"
Viridian_Map_Name14: db "VIRIDIAN<BSP>FOREST@"
Viridian_Map_Name15: db "VIRIDIAN GATE N@"
Viridian_Map_Name16: db "VIRIDIAN GATE S@"

New_Bark_Map_Name1: db "ROUTE 26@"
New_Bark_Map_Name2: db "ROUTE 27@"
New_Bark_Map_Name3: db "ROUTE 29@"
New_Bark_Map_Name4: db "NEW BARK<BSP>TOWN@"
New_Bark_Map_Name5: db "ELM'S LAB@"
New_Bark_Map_Name6: db "PLAYER'S HOUSE 1F@"
New_Bark_Map_Name7: db "PLAYER'S HOUSE 2F@"
New_Bark_Map_Name8: db "NEW BARK HOUSE@"
New_Bark_Map_Name9: db "ELM'S HOUSE@"
New_Bark_Map_Name10: db "ROUTE 26 HOUSE@"
New_Bark_Map_Name11: db "DAY SIBLINGS HOUSE@"
New_Bark_Map_Name12: db "ROUTE 27 HOUSE@"
New_Bark_Map_Name13: db "ROUTE 29 GATE@"

Saffron_Map_Name1: db "ROUTE 5@"
Saffron_Map_Name2: db "SAFFRON<BSP>CITY@"
Saffron_Map_Name3: db "FIGHTING DOJO@"
Saffron_Map_Name4: db "SAFFRON GYM@"
Saffron_Map_Name5: db "SAFFRON ", $70, $71, "MART@"
Saffron_Map_Name6: db "SAFFRON ", $E1, $E2, "CENTER@"
Saffron_Map_Name8: db "MR.PSYCHICS HOUSE@"
Saffron_Map_Name9: db "SAFFRON STATION@"
Saffron_Map_Name10: db "SILPH CO.@"
Saffron_Map_Name11: db "COPYCAT HOUSE 1F@"
Saffron_Map_Name12: db "COPYCAT HOUSE 2F@"
Saffron_Map_Name13: db "ROUTE 5 UNDERGRND@"
Saffron_Map_Name14: db "ROUTE 5 GATE@"
Saffron_Map_Name15: db "ROUTE 5 HOUSE@"

Cherrygrove_Map_Name1: db "ROUTE 30@"
Cherrygrove_Map_Name2: db "ROUTE 31@"
Cherrygrove_Map_Name3: db "CHERRYGROVE<BSP>CITY@"
Cherrygrove_Map_Name4: db "CHERRYGROVE<BSP>BAY@"
Cherrygrove_Map_Name5: db "CHERRYGROVE.#MART@"
Cherrygrove_Map_Name6: db "CHERRYGROVE ", $E1, $E2, "CEN@"
Cherrygrove_Map_Name7: db "CHERRYG.<BSP>HOUSE 1@"
Cherrygrove_Map_Name8: db "GUIDE GENT HOUSE@"
Cherrygrove_Map_Name9: db "CHERRYG.<BSP>HOUSE 2@"
Cherrygrove_Map_Name10: db "ROUTE 30 HOUSE@"
Cherrygrove_Map_Name11: db "MR.#MON HOUSE@"
Cherrygrove_Map_Name12: db "ROUTE 31 GATE@"

SafariZone_Map_Name1: db "ROUTE 47@"
SafariZone_Map_Name2: db "ROUTE 48@"
SafariZone_Map_Name3: db "SAFARI<BSP>ENTR@"
SafariZone_Map_Name4: db "SAFARI<BSP>GATE@"
SafariZone_Map_Name5: db "SAFARI ", $E1, $E2, "CEN@"
SafariZone_Map_Name6: db "SAFARI<BSP>AREA 1@"
SafariZone_Map_Name7: db "SAFARI<BSP>AREA 2@"
SafariZone_Map_Name8: db "SAFARI<BSP>AREA 4@"
SafariZone_Map_Name9: db "SAFARI<BSP>HOUSE 1@"
SafariZone_Map_Name10: db "SAFARI HOUSE 2@"
SafariZone_Map_Name11: db "SAFARI HOUSE 3@"
SafariZone_Map_Name12: db "SAFARI HOUSE 4@"

SafariZone3_Map_Name1: db "SAFARI AREA 3@"
