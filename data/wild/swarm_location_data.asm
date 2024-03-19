DEF NUM_JOHTO_SWARMS EQU 3 ;
DEF NUM_JOHTO_ALT_SWARMS EQU 3
DEF NUM_KANTO_SWARMS EQU 1
DEF NUM_KANTO_ALT_SWARMS EQU 1

SwarmLocationDataJohto:
MACRO swarm_johto
	db \1					; pokemon
	map_id \2 				; map id
ENDM

;				pokemon,	map
	swarm_johto YANMA,		ROUTE_35
	swarm_johto DUNSPARCE,	DARK_CAVE_VIOLET_ENTRANCE
	swarm_johto QWILFISH,	RUINS_OF_ALPH_OUTSIDE
	db 0 ; end



SwarmLocationDataJohtoAlt:
MACRO swarm_johto2
	db \1					; pokemon
	map_id \2 				; map id
ENDM

;				 pokemon,	map
	swarm_johto2 DITTO,		ROUTE_35
	swarm_johto2 LARVITAR,	DARK_CAVE_VIOLET_ENTRANCE
	swarm_johto2 CORSOLA,	RUINS_OF_ALPH_OUTSIDE
	db 0 ; end



SwarmLocationDataKanto:
MACRO swarm_kanto
	db \1					; pokemon
	map_id \2 				; map id
ENDM

;				pokemon,	map
;	swarm_kanto YANMA,		ROUTE_35
	db 0 ; end



SwarmLocationDataKantoAlt:
MACRO swarm_kanto2
	db \1					; pokemon
	map_id \2 				; map id
ENDM

;				 pokemon,	map
;	swarm_kanto2 DITTO,		ROUTE_35
	db 0 ; end
