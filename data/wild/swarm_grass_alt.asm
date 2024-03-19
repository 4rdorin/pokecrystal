; Pokémon swarms in grass

SwarmGrassWildMonsAlt:
; Larvitar swarm
	map_id DARK_CAVE_VIOLET_ENTRANCE
	db 4 percent, 4 percent, 4 percent ; encounter rates: morn/day/nite
	; morn
	;  %, species,    min, max
	db 30, GEODUDE,		 3,  3
	db 30, LARVITAR,	 2,  4
	db 10, ZUBAT,		 2,  2
	db 10, GEODUDE,		 2,  3
	db 10, LARVITAR,	 2,  4
	db  9, LARVITAR,	 2,  4
	db  1, LARVITAR,	 2,  4

	; day
	;  %, species,    min, max
	db 30, GEODUDE,		 3,  3
	db 30, LARVITAR,	 2,  4
	db 10, ZUBAT,		 2,  2
	db 10, GEODUDE,		 2,  3
	db 10, LARVITAR,	 2,  4
	db  9, LARVITAR,	 2,  4
	db  1, LARVITAR,	 2,  4

	; nite
	;  %, species,    min, max
	db 30, GEODUDE,		 3,  3
	db 30, LARVITAR,	 2,  4
	db 10, ZUBAT,		 2,  2
	db 10, GEODUDE,		 2,  3
	db 10, LARVITAR,	 2,  4
	db  9, LARVITAR,	 2,  4
	db  1, LARVITAR,	 2,  4

; Ditto swarm
	map_id ROUTE_35
	db 10 percent, 10 percent, 10 percent ; encounter rates: morn/day/nite
	; morn
	;  %, species,    min, max
	db 50, DITTO,		12, 14
	db 10, NIDORAN_M,	12, 12
	db 10, NIDORAN_F,	12, 12
	db 10, DITTO,		12, 14
	db 10, DITTO,		12, 14
	db  5, PIDGEY,		14, 14
	db  5, DITTO,		10, 10

	; day
	;  %, species,    min, max
	db 50, DITTO,		12, 14
	db 10, NIDORAN_M,	12, 12
	db 10, NIDORAN_F,	12, 12
	db 10, DITTO,		12, 14
	db 10, DITTO,		12, 14
	db  5, PIDGEY,		14, 14
	db  5, DITTO,		10, 10

	; nite
	;  %, species,    min, max
	db 50, DITTO,		12, 14
	db 10, NIDORAN_M,	12, 12
	db 10, NIDORAN_F,	12, 12
	db 10, DITTO,		12, 14
	db 10, DITTO,		12, 14
	db  5, PIDGEY,		14, 14
	db  5, DITTO,		10, 10

	db -1 ; end
	