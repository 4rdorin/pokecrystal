	const_def
	const DEXENTRY_LORE      ; 0 ; bit 0, $1
	const DEXENTRY_BASESTATS ; 1 ; bit 1, $2
	const DEXENTRY_LVLUP     ; 2 ; bit 2, $4
	const DEXENTRY_FIELD     ; 3 ; bit 3, $8
	const DEXENTRY_EGG		 ; 4 ; bit 4, $10, 16
	const DEXENTRY_TMS       ; 5 ; bit 5, $20, 32
	; const DEXENTRY_HMS       ; bit 6, $40, 64
	const DEXENTRY_MTS       ; 6 ;bit 7, $80, 128
	const DEXENTRY_EVO		 ; 7
	const DEXENTRY_PICS      ; 8
	const DEXENTRY_AREA_NONE	;  9
	const DEXENTRY_AREA_GRASS_JOHTO   ; 0A
	const DEXENTRY_AREA_GRASS_KANTO   ; 0B
	const DEXENTRY_AREA_GRASS_SWARM   ; 0C
	const DEXENTRY_AREA_GRASS_SWARM_ALT   ; 0D
	const DEXENTRY_AREA_SURF_JOHTO    ; 0E
	const DEXENTRY_AREA_SURF_KANTO    ; 0F
	const DEXENTRY_AREA_SURF_SWARM   ; 10
	const DEXENTRY_AREA_SURF_SWARM_ALT   ; 11
	const DEXENTRY_AREA_RODS    ; 12
	const DEXENTRY_AREA_TREES_COMMON   ; 13
	const DEXENTRY_AREA_TREES_RARE   ; 14
	const DEXENTRY_AREA_ROCKSMASH   ; 15
	const DEXENTRY_AREA_CONTEST ; 16
	const DEXENTRY_AREA_ROAMING ; 17
	const DEXENTRY_AREA_CASINO ; 18
	const DEXENTRY_AREA_NPCTRADES ; 19
	const DEXENTRY_AREA_EVENTWILDMONS ; 1A
	const DEXENTRY_AREA_GIFTMONS ; 1B

EXPORT DEXENTRY_LORE
EXPORT DEXENTRY_BASESTATS
EXPORT DEXENTRY_LVLUP
EXPORT DEXENTRY_FIELD
EXPORT DEXENTRY_EGG
EXPORT DEXENTRY_TMS
; EXPORT DEXENTRY_HMS
EXPORT DEXENTRY_MTS
EXPORT DEXENTRY_EVO		 ; 7
EXPORT DEXENTRY_PICS      ; 8

EXPORT DEXENTRY_AREA_GRASS_JOHTO
EXPORT DEXENTRY_AREA_GRASS_KANTO
EXPORT DEXENTRY_AREA_GRASS_SWARM
EXPORT DEXENTRY_AREA_GRASS_SWARM_ALT

EXPORT DEXENTRY_AREA_SURF_JOHTO
EXPORT DEXENTRY_AREA_SURF_KANTO
EXPORT DEXENTRY_AREA_SURF_SWARM
EXPORT DEXENTRY_AREA_SURF_SWARM_ALT

EXPORT DEXENTRY_AREA_RODS
EXPORT DEXENTRY_AREA_TREES_COMMON
EXPORT DEXENTRY_AREA_TREES_RARE
EXPORT DEXENTRY_AREA_ROCKSMASH
EXPORT DEXENTRY_AREA_CONTEST
EXPORT DEXENTRY_AREA_ROAMING

EXPORT DEXENTRY_AREA_CASINO
EXPORT DEXENTRY_AREA_NPCTRADES
EXPORT DEXENTRY_AREA_EVENTWILDMONS
EXPORT DEXENTRY_AREA_GIFTMONS

EXPORT DEXENTRY_AREA_NONE

DEF NUM_FIELD_MOVES EQU 14
DEF MOVESPAGES_CONT_MASK EQU %00000011

AnimateDexSearchSlowpoke:
	ld hl, .FrameIDs
	ld b, 25
.loop
	ld a, [hli]

	; Wrap around
	cp $fe
	jr nz, .ok
	ld hl, .FrameIDs
	ld a, [hli]
.ok

	ld [wDexSearchSlowpokeFrame], a
	ld a, [hli]
	ld c, a
	push bc
	push hl
	call DoDexSearchSlowpokeFrame
	pop hl
	pop bc
	call DelayFrames
	dec b
	jr nz, .loop
	xor a
	ld [wDexSearchSlowpokeFrame], a
	call DoDexSearchSlowpokeFrame
	ld c, 32
	jmp DelayFrames

.FrameIDs:
	; frame ID, duration
	db 0, 7
	db 1, 7
	db 2, 7
	db 3, 7
	db 4, 7
	db -2

DoDexSearchSlowpokeFrame:
	ld a, [wDexSearchSlowpokeFrame]
	ld hl, .SlowpokeSpriteData
	ld de, wShadowOAMSprite00
.loop
	ld a, [hli]
	cp -1
	ret z
	ld [de], a ; y
	inc de
	ld a, [hli]
	ld [de], a ; x
	inc de
	ld a, [wDexSearchSlowpokeFrame]
	ld b, a
	add a
	add b
	add [hl]
	inc hl
	ld [de], a ; tile id
	inc de
	ld a, [hli]
	ld [de], a ; attributes
	inc de
	jr .loop

.SlowpokeSpriteData:
	dbsprite  9, 11, 0, 0, $00, 0
	dbsprite 10, 11, 0, 0, $01, 0
	dbsprite 11, 11, 0, 0, $02, 0
	dbsprite  9, 12, 0, 0, $10, 0
	dbsprite 10, 12, 0, 0, $11, 0
	dbsprite 11, 12, 0, 0, $12, 0
	dbsprite  9, 13, 0, 0, $20, 0
	dbsprite 10, 13, 0, 0, $21, 0
	dbsprite 11, 13, 0, 0, $22, 0
	db -1

HandlePageNumReset:
	ld b, a
	ld a, [wPokedexEntryType]
	cp b
	ret z
	ld a, b
	ld [wPokedexEntryType], a
	xor a
	ld [wPokedexEntryPageNum], a
	ret

DisplayDexEntry:
	; call Dex_PrintMonTypeTiles
	ld a, [wPokedexEntryType]
	and a
	jr nz, .check_caught
	ld a, DEXENTRY_LORE
	call HandlePageNumReset
.check_caught
; Check to see if we caught it.  Get out of here if we haven't.
	ld a, [wTempSpecies]
	dec a
	call CheckCaughtMon
	ret z

	; xor a
	; ldh [hBGMapMode], a

	ld a, DEXENTRY_LORE
	call HandlePageNumReset

	lb bc, 8, SCREEN_WIDTH - 1
	hlcoord 1, 8
	call ClearBox

	hlcoord 1, 8
	ld bc, 19
	ld a, $55
	rst ByteFill

	ld a, [wTempSpecies]
	ld b, a
	call GetDexEntryPointer
	ld a, b
	push af
	hlcoord 2, 9
	call PlaceFarString ; dex species nickname
	ld h, b
	ld l, c
	push de
	hlcoord 12, 9
.check_tile
	; this prints the "PKMN" symbols after the species nickname
	ld a, [hld]
	cp $e2
	jr z, .cont
	cp $7f ; empty tile
	jr z, .check_tile
	inc hl
	inc hl
	ld [hl], " "
	inc hl
	ld [hl], $e1
	inc hl
	ld [hl], $e2
.cont
	pop hl
	pop bc
; Get the height of the Pokemon.
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	inc hl
	ld a, b
	push af
	inc hl
	inc hl
	inc hl
	push hl
	ld a, [wPokedexEntryPageNum]
	and a ; check for page 2
	jr nz, .page2
; Page 1
	call Pokedex_PrintPageNum
	pop de
	inc de
	pop af
	hlcoord 2, 11
	push af
	call PlaceFarString
	pop bc
	call DexEntry_IncPageNum
	; jmp WaitBGMap
	ret

; Page 2
.page2
	pop de
	inc de
	pop af
	hlcoord 2, 11
	push af
	call PlaceFarString
	pop bc
	push bc
	push de
	lb bc, 5, SCREEN_WIDTH - 1
	hlcoord 1, 11
	call ClearBox
	hlcoord 1, 8
	ld bc, 19
	ld a, $55
	rst ByteFill
	call Pokedex_PrintPageNum
	pop de
	inc de
	pop af
	hlcoord 2, 11
	call PlaceFarString
	xor a
	ld [wPokedexEntryPageNum], a
	; jmp WaitBGMap
	ret

GetDexEntryPointer:
; return dex entry pointer b:de
	push hl
	ld hl, PokedexDataPointerTable
	ld a, b
	dec a
	ld d, 0
	ld e, a
	add hl, de
	add hl, de
	add hl, de
	; b = bank
	ld a, [hli]
	ld b, a
	; de = address
	ld a, [hli]
	ld e, a
	ld d, [hl]
	pop hl
	ret

GetDexEntryPagePointer:
	call GetDexEntryPointer
	push hl
	ld h, d
	ld l, e
; skip species name
.loop1
	ld a, b
	call GetFarByte
	inc hl
	cp "@"
	jr nz, .loop1
; skip height and weight
rept 4
	inc hl
endr
; if c != 1: skip entry
	dec c
	and c
	jr z, .done
; skip entry
.loop2
	ld a, b
	call GetFarByte
	inc hl
	cp "@"
	jr nz, .loop2
.done
	ld d, h
	ld e, l
	pop hl
	ret

DisplayDexMonType:
	call GetBaseData
	ld a, [wBaseType1]
; load the tiles
	ld hl, TypeLightIconGFX
	ld bc, 4 * LEN_2BPP_TILE
	rst AddNTimes
	ld d, h
	ld e, l

	ld a, $1
	ldh [rVBK], a
	ld hl, vTiles2 tile $77
	lb bc, BANK(TypeLightIconGFX), 4
	call Request2bpp

	hlcoord 9, 6
	ld [hl], $77
	inc hl
	ld [hl], $78
	inc hl
	ld [hl], $79
	inc hl
	ld [hl], $7a

	ld a, $0
	ldh [rVBK], a
; 2nd Type
	ld a, [wBaseType1]
	ld b, a
	ld a, [wBaseType2]
	cp b
	ret z
; load type 2 tiles
	ld hl, TypeDarkIconGFX
	ld bc, 4 * LEN_2BPP_TILE
	rst AddNTimes
	ld d, h
	ld e, l

	ld a, $1
	ldh [rVBK], a

	ld hl, vTiles2 tile $7b
	lb bc, BANK(TypeDarkIconGFX), 4
	call Request2bpp
	hlcoord 13, 6
	ld [hl], $7b
	inc hl
	ld [hl], $7c
	inc hl
	ld [hl], $7d
	inc hl
	ld [hl], $7e
	ld a, $0
	ldh [rVBK], a
	ret

Dex_PrintMonTypeTiles:
	ld a, [wTempSpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [wBaseType1]
; load the tiles
	ld hl, TypeLightIconGFX ; gfx\stats\types_light.png
	ld bc, 4 * LEN_2BPP_TILE ; Type GFX are 4 Tiles wide
	rst AddNTimes ; increments the TypeLightIconGFX pointer to the right address of the needed Type Tiles
	ld d, h
	ld e, l
	ld hl, vTiles2 tile $70 ; destination address of the Tile, in this case Tiles $70-$73
	lb bc, BANK(TypeLightIconGFX), 4 ; Bank in 'b', Number of Tiles being loaded in 'c'
	call Request2bpp
; 2nd Type
	ld a, [wBaseType2]
; load type 2 tiles
	ld hl, TypeDarkIconGFX ; gfx\stats\types_dark.png
	ld bc, 4 * LEN_2BPP_TILE ; Type GFX are 4 Tiles wide
	rst AddNTimes ; increments the TypeDarkIconGFX pointer to the right address of the needed Type Tiles
	ld d, h
	ld e, l
	ld hl, vTiles2 tile $74 ; destination address of the Tile, in this case Tiles $74-$77
	lb bc, BANK(TypeDarkIconGFX), 4 ; Bank in 'b', Number of Tiles being loaded in 'c'
	call Request2bpp

	hlcoord 9, 1
	ld [hl], $70
	inc hl
	ld [hl], $71
	inc hl
	ld [hl], $72
	inc hl
	ld [hl], $73
	inc hl
	ld a, [wBaseType1]
	ld b, a
	ld a, [wBaseType2]
	cp b
	ret z ; pokemon doesnt have a 2nd type
	ld [hl], $74
	inc hl
	ld [hl], $75
	inc hl
	ld [hl], $76
	inc hl
	ld [hl], $77
	ret

INCLUDE "data/pokemon/dex_entry_pointers.asm"
INCLUDE "engine/pokedex/pokedex_stats_page.asm"
INCLUDE "engine/pokedex/pokedex_moves_page.asm"
INCLUDE "engine/pokedex/pokedex_area_page.asm"
INCLUDE "engine/pokedex/pokedex_evolution_page.asm"
INCLUDE "engine/pokedex/pokedex_pics_page.asm"

Pokedex_Clearbox:
	;clear Area BC @ HL
	; xor a
	; ldh [hBGMapMode], a
	lb bc, 7, SCREEN_WIDTH - 1
	hlcoord 1, 9
	call ClearBox
	; jmp WaitBGMap
	ret

DexEntry_adjusthlcoord:
	; given: current printed lines in c
	push af
	push de
	ld a, 20
	; the num of moves already printed should still be in bc
	call SimpleMultiply ; uses c as the other number
	; result in a
	ld d, 0
	ld e, a
	add hl, de ; allows us to print on the proper row lol
	pop de
	pop af
	ret

DexEntry_IncPageNum:
	ld a, [wPokedexEntryPageNum]
	inc a
	ld [wPokedexEntryPageNum], a
	ret

Pokedex_PrintPageNum:
	push hl
	ld a, [wPokedexEntryPageNum]
	; a = page num, starting with 0 as page 1
	hlcoord 18, 7
	ld [hl], $61 ; p. vram1
	inc hl

	cp 10 ; if we are past nine pages
	jr c, .checkdone
	ld a, 9
.checkdone
	add $62 ; this is how we get the page num tile
	ld [hl], a ; #
	pop hl
	ld a, [wPokedexEntryPageNum]
	ret

DexEntry_NextCategory:
	ld [wPokedexEntryType], a
	xor a
	ld [wPokedexEntryPageNum], a
	ld [wPokedexStatus], a
	ret
