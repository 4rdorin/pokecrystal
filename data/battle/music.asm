BattleMusic_Trainers:
;	db WILL,             MUSIC_KANTO_ELITE_FOUR_FRLG
;	db KOGA,             MUSIC_KANTO_ELITE_FOUR_FRLG
;	db BRUNO,            MUSIC_KANTO_ELITE_FOUR_FRLG
;	db KAREN,            MUSIC_KANTO_ELITE_FOUR_FRLG
	db CHAMPION,         MUSIC_CHAMPION_BATTLE
	db RED,              MUSIC_CHAMPION_BATTLE
	db RIVAL1,           MUSIC_RIVAL_BATTLE
	db RIVAL2,           MUSIC_RIVAL_BATTLE
	db GRUNTM,           MUSIC_ROCKET_BATTLE
	db GRUNTF,           MUSIC_ROCKET_BATTLE
	db SCIENTIST, 		 MUSIC_ROCKET_BATTLE
	db EXECUTIVEM,		 MUSIC_ROCKET_BATTLE
	db EXECUTIVEF,		 MUSIC_ROCKET_BATTLE
;	db PROTON,           MUSIC_ROCKET_BATTLE
;	db PETREL,           MUSIC_ROCKET_BATTLE
;	db ARCHER,           MUSIC_ROCKET_BATTLE
;	db ARIANA,           MUSIC_ROCKET_BATTLE
;	db GIOVANNI,         MUSIC_ROCKET_BATTLE
	db -1

BattleMusic_Legendaries:
;	db ARTICUNO, MUSIC_KANTO_LEGEND_BATTLE_XY
;	db ZAPDOS,   MUSIC_KANTO_LEGEND_BATTLE_XY
;	db MOLTRES,  MUSIC_KANTO_LEGEND_BATTLE_XY
;	db MEWTWO,   MUSIC_KANTO_LEGEND_BATTLE_XY
;	db MEW,      MUSIC_KANTO_LEGEND_BATTLE_XY
	db RAIKOU,   MUSIC_SUICUNE_BATTLE
	db ENTEI,    MUSIC_SUICUNE_BATTLE
	db SUICUNE,  MUSIC_SUICUNE_BATTLE
;	db HO_OH,    MUSIC_HO_OH_BATTLE_HGSS
;	db LUGIA,    MUSIC_LUGIA_BATTLE_HGSS
	db CELEBI,   MUSIC_SUICUNE_BATTLE
	db -1

BattleMusic_RegionalTrainers:
; morn/day
	dw MUSIC_JOHTO_TRAINER_BATTLE
	dw MUSIC_KANTO_TRAINER_BATTLE
; nite
	dw MUSIC_JOHTO_TRAINER_BATTLE
	dw MUSIC_KANTO_TRAINER_BATTLE

BattleMusic_RegionalWilds:
; morn/day
	dw MUSIC_JOHTO_WILD_BATTLE
	dw MUSIC_KANTO_WILD_BATTLE
; nite
	dw MUSIC_JOHTO_WILD_BATTLE_NIGHT
	dw MUSIC_KANTO_WILD_BATTLE
