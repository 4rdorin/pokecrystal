; overworld_sprite struct members (see data/sprites/sprites.asm)
rsreset
DEF SPRITEDATA_ADDR    rw ; 0
DEF SPRITEDATA_SIZE    rb ; 2
DEF SPRITEDATA_BANK    rb ; 3
DEF SPRITEDATA_TYPE    rb ; 4
DEF SPRITEDATA_PALETTE rb ; 5
DEF NUM_SPRITEDATA_FIELDS EQU _RS

; sprite types
	const_def 1
	const WALKING_SPRITE  ; 1
	const STANDING_SPRITE ; 2
	const STILL_SPRITE    ; 3

; sprite palettes
	const_def
	const PAL_OW_RED    	; 0
	const PAL_OW_BLUE   	; 1
	const PAL_OW_GREEN  	; 2
	const PAL_OW_BROWN  	; 3
	const PAL_OW_FOLLOWER   ; 4
	const PAL_OW_EMOTE  	; 5
	const PAL_OW_TREE 		; 6
	const PAL_OW_ROCK		; 7

; object_events set bit 3 so as not to use the sprite's default palette
; MapObjectPals indexes (see gfx/overworld/npc_sprites.pal)
	const_def 1 << 3
	const PAL_NPC_RED    	; 8
	const PAL_NPC_BLUE   	; 9
	const PAL_NPC_GREEN  	; a
	const PAL_NPC_BROWN  	; b
	const PAL_NPC_FOLLOWER  ; c
	const PAL_NPC_EMOTE  	; d
	const PAL_NPC_TREE 	 	; e
	const PAL_NPC_ROCK	 	; f

; follower palletes
	const_def
	const PAL_FOL_RED     ; 0
	const PAL_FOL_BLUE    ; 1
	const PAL_FOL_GREEN   ; 2
	const PAL_FOL_BROWN   ; 3
	const PAL_FOL_PURPLE  ; 4
	const PAL_FOL_GRAY    ; 5
	const PAL_FOL_YELLOW  ; 6
	const PAL_FOL_PINK    ; 7
	const PAL_FOL_SUICUNE ; 8
	const PAL_FOL_DRAGONITE ; 9
	const PAL_FOL_TYRANITAR ; A
	const PAL_FOL_STEELIX ; B
	const PAL_FOL_CELEBI ; C
	const PAL_FOL_BULBASAUR ; D
	const PAL_FOL_VENUSAUR ; E
	const PAL_FOL_ODDISH ; F
	const PAL_FOL_GLOOM ; 10
	const PAL_FOL_VILEPLUME ; 11
	const PAL_FOL_POLIWAG ; 12
	const PAL_FOL_BELLOSSOM ; 13
	const PAL_FOL_TENTACOOL ; 14
	const PAL_FOL_ESPEON ; 15
	const PAL_FOL_GENGAR ; 16
	const PAL_FOL_PORYGON ; 17
	const PAL_FOL_TYROGUE ; 18
	const PAL_FOL_HITMONCHAN ; B
	const PAL_FOL_HITMONTOP ; B
	const PAL_FOL_BLISSEY ; B
	const PAL_FOL_STARMIE ; B
	const PAL_FOL_AERODACTYL ; B
	const PAL_FOL_SNORLAX ; B
	const PAL_FOL_ARTICUNO ; B
	const PAL_FOL_TOGEPI ; B
	const PAL_FOL_HOPPIP ; B
	const PAL_FOL_FORRETRESS ; B
	const PAL_FOL_MISDREAVUS ; B
	const PAL_FOL_GLIGAR ; B
	const PAL_FOL_DUNSPARCE ; B
	const PAL_FOL_PHANPY ; B
	const PAL_FOL_SKARMORY ; B
	const PAL_FOL_RAIKOU ; B
	const PAL_FOL_ENTEI ; B
	const PAL_FOL_MEWTWO ; B
	const PAL_FOL_MEW ; B
	const PAL_FOL_HOOH ; B
	const PAL_FOL_LUGIA ; B

