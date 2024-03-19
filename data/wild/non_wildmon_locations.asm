MACRO casinomon 
; species, coins needed
	db \1
	dw \2
ENDM

MACRO specialencounter
; requested mon, offered mon, item, OT ID, OT name, gender requested
	db \1
	dw \2
	map_id \3
	dw \4
ENDM

CasinoMons::
; usually 3 per region, but not a hard coded limit
	; region map ; 2 bytes (group/ID)
	; species, coins (2 bytes)

	; johto, from maps\goldenrodgamecorner.asm
	map_id GOLDENROD_GAME_CORNER
	casinomon ABRA, GOLDENRODGAMECORNER_ABRA_COINS
	casinomon CUBONE, GOLDENRODGAMECORNER_CUBONE_COINS
	casinomon WOBBUFFET, GOLDENRODGAMECORNER_WOBBUFFET_COINS 
	db -1
	; kanto, from maps\celadongamecornerprizeroom.asm
	map_id CELADON_GAME_CORNER_PRIZE_ROOM
	casinomon PIKACHU, CELADONGAMECORNERPRIZEROOM_PIKACHU_COINS 
	casinomon PORYGON, CELADONGAMECORNERPRIZEROOM_PORYGON_COINS 
	casinomon LARVITAR, CELADONGAMECORNERPRIZEROOM_LARVITAR_COINS 
	db -1

NPCTradeMons_Locations::
; corresponds to NPCTrades:: in data\events\npc_trades.asm
	table_width 2 ; map is 2 bytes
	map_id GOLDENROD_DEPT_STORE_5F 	; MAPGROUP_GOLDENROD, 	MAP_GOLDENROD_DEPT_STORE_5F
	map_id VIOLET_KYLES_HOUSE		; MAPGROUP_VIOLET, 		MAP_VIOLET_KYLES_HOUSE
	map_id OLIVINE_TIMS_HOUSE 		; MAPGROUP_OLIVINE, 	MAP_OLIVINE_TIMS_HOUSE 
	map_id BLACKTHORN_EMYS_HOUSE 	; MAPGROUP_BLACKTHORN, 	MAP_BLACKTHORN_EMYS_HOUSE
	map_id PEWTER_POKECENTER_1F 	; MAPGROUP_PEWTER, 		MAP_PEWTER_POKECENTER_1F
	map_id ROUTE_14 				; MAPGROUP_FUCHSIA, 	MAP_ROUTE_14
	map_id POWER_PLANT 				; MAPGROUP_CERULEAN, 	MAP_POWER_PLANT
	assert_table_length NUM_NPC_TRADES

EventWildMons::
; replace map_id with -1 to hide location but keep hint				ToDo: Reemplazar mapas por landmarks para poder usar el -1 y elegir si mostrar la ubicación o no
; specialencounter 	 SPECIES,   EVENT_FLAG,                         map_id, blurb string ptr
	specialencounter LAPRAS, 	-1, 								UNION_CAVE_B2F, ToDo_Str ; reoccurs every Friday
	specialencounter SUDOWOODO, EVENT_FOUGHT_SUDOWOODO, 			ROUTE_36, ToDo_Str
	specialencounter GYARADOS, 	EVENT_LAKE_OF_RAGE_RED_GYARADOS, 	LAKE_OF_RAGE, ToDo_Str
	specialencounter SNORLAX, 	EVENT_FOUGHT_SNORLAX, 				VERMILION_CITY, ToDo_Str
	specialencounter SUICUNE,	EVENT_FOUGHT_SUICUNE, 				TIN_TOWER_1F, ToDo_Str
	specialencounter CELEBI, 	EVENT_CELEBI_ENCOUNTER, 			ILEX_FOREST, ToDo_Str
	specialencounter LUGIA, 	EVENT_FOUGHT_LUGIA, 				WHIRL_ISLAND_LUGIA_CHAMBER, ToDo_Str
	specialencounter HO_OH, 	EVENT_FOUGHT_HO_OH,  				TIN_TOWER_ROOF, ToDo_Str
	specialencounter ARTICUNO, 	EVENT_FOUGHT_SNORLAX, 				UNION_CAVE_B2F, ToDo_Str
	specialencounter ZAPDOS, 	EVENT_FOUGHT_SNORLAX, 				UNION_CAVE_B2F, ToDo_Str
	specialencounter MOLTRES, 	EVENT_FOUGHT_SNORLAX, 				UNION_CAVE_B2F, ToDo_Str
	specialencounter MEWTWO, 	EVENT_FOUGHT_SNORLAX, 				UNION_CAVE_B2F, ToDo_Str
	specialencounter MEW, 		EVENT_FOUGHT_SNORLAX, 				UNION_CAVE_B2F, ToDo_Str
	db -1

; LoadWildMon Dex Hints, max 18 chars per line
ToDo_Str:
	db 	 "@"

GiftMons::
; replace map_id with -1 to hide location but keep hint
; species, EVENT_FLAG, map_id, blurb string ptr
	specialencounter SPEAROW, 	EVENT_GOT_KENYA, 					ROUTE_35_GOLDENROD_GATE, ToDo_Str
	specialencounter DRATINI, 	EVENT_GOT_DRATINI, 					DRAGON_SHRINE, ToDo_Str
	specialencounter EEVEE,	 	EVENT_GOT_EEVEE, 					BILLS_FAMILYS_HOUSE, ToDo_Str
	specialencounter TYROGUE, 	EVENT_GOT_TYROGUE_FROM_KIYO, 		MOUNT_MORTAR_1F_OUTSIDE, ToDo_Str
	specialencounter AERODACTYL,EVENT_GOT_TYROGUE_FROM_KIYO, 	RUINS_OF_ALPH_RESEARCH_CENTER, ToDo_Str
	specialencounter KABUTO, 	EVENT_GOT_TYROGUE_FROM_KIYO, 	RUINS_OF_ALPH_RESEARCH_CENTER, ToDo_Str
	specialencounter OMANYTE, 	EVENT_GOT_TYROGUE_FROM_KIYO, 	RUINS_OF_ALPH_RESEARCH_CENTER, ToDo_Str
	db -1

; GivePoke Dex Hints, max 18 chars per line
