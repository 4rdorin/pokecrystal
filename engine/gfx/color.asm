DEF SHINY_DEF_DV EQU 13
DEF SHINY_SPD_DV EQU 11
DEF SHINY_SPC_DV EQU 13

CheckShininess:
; Check if a mon is shiny by DVs at bc.
; Return carry if shiny.

	ld l, c
	ld h, b

; Defense = 13
	ld a, [hli]
	and %1111
	cp SHINY_DEF_DV
	jr nz, .not_shiny

; Speed = 11, 12, 13 o 14
	ld a, [hl]
	and %1111 << 4
	cp SHINY_SPD_DV << 4
	jr c, .not_shiny
	cp 15 << 4
	jr z, .not_shiny

; Special = 13
	ld a, [hl]
	and %1111
	cp SHINY_SPC_DV
	jr nz, .not_shiny

; shiny
	scf
	ret

.not_shiny
	and a
	ret

Unused_CheckShininess:
; Return carry if the DVs at hl are all 10 or higher.

; Attack
	ld a, [hl]
	cp 10 << 4
	jr c, .not_shiny

; Defense
	ld a, [hli]
	and %1111
	cp 10
	jr c, .not_shiny

; Speed
	ld a, [hl]
	cp 10 << 4
	jr c, .not_shiny

; Special
	ld a, [hl]
	and %1111
	cp 10
	jr c, .not_shiny

; shiny
	scf
	ret

.not_shiny
	and a
	ret

InitPartyMenuPalettes:
	ld hl, PalPacket_PartyMenu + 1
	call CopyFourPalettes
	call InitPartyMenuOBPals
	jmp WipeAttrmap

ApplyMonOrTrainerPals:
	ld a, e
	and a
	jr z, .get_trainer
	ld a, [wCurPartySpecies]
	call GetMonPalettePointer
	jr .load_palettes

.get_trainer
	ld a, [wTrainerClass]
	call GetTrainerPalettePointer

.load_palettes
	ld de, wBGPals1
	call LoadPalette_White_Col1_Col2_Black
	call WipeAttrmap
	call ApplyAttrmap
	jmp ApplyPals

ApplyHPBarPals:
	ld a, [wWhichHPBar]
	and a
	jr z, .Enemy
	cp $1
	jr z, .Player
	cp $2
	jr z, .PartyMenu
	ret

.Enemy:
	ld de, wBGPals2 palette PAL_BATTLE_BG_ENEMY_HP color 1
	jr .okay

.Player:
	ld de, wBGPals2 palette PAL_BATTLE_BG_PLAYER_HP color 1

.okay
	ld l, c
	ld h, $0
	add hl, hl
	add hl, hl
	ld bc, HPBarPals
	add hl, bc
	ld bc, 4
	ld a, BANK(wBGPals2)
	call FarCopyWRAM
	ld a, TRUE
	ldh [hCGBPalUpdate], a
	ret

.PartyMenu:
	ld e, c
	inc e
	hlcoord 11, 1, wAttrmap
	ld bc, 2 * SCREEN_WIDTH
	ld a, [wCurPartyMon]
.loop
	and a
	jr z, .done
	add hl, bc
	dec a
	jr .loop

.done
	lb bc, 2, 8
	ld a, e
	jmp FillBoxCGB

LoadStatsScreenPals:
	ld hl, StatsScreenPals
	ld b, 0
	dec c
	add hl, bc
	add hl, bc
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rSVBK], a

	ld a, [hli] ; byte 1 of the stats screen page color
	ld [wBGPals1 palette 0], a ; into slot 1 byte 1 of pal 0
	ld [wBGPals1 palette 2], a ; into slot 1 byte 1 of pal 2
	ld [wBGPals1 palette 6], a ; into slot 1 byte 1 of pal 6
	ld [wBGPals1 palette 7], a ; into slot 1 byte 1 of pal 7
	ld a, [hl]
	ld [wBGPals1 palette 0 + 1], a ; into slot 1 byte 2 of pal 0
	ld [wBGPals1 palette 2 + 1], a ; into slot 1 byte 2 of pal 2
	ld [wBGPals1 palette 6 + 1], a ; into slot 1 byte 2 of pal 6
	ld [wBGPals1 palette 7 + 1], a ; into slot 1 byte 2 of pal 7
	dec hl
	ld a, [hli]
	cp $7f ; half of pink page color, which is $7E7F but bytes are reversed when stored in data (endianness),
	; so check $7F first since it will be the first one read
	jr nz, .notpinkpage
	ld a, [hl]

	cp $7e ; first half of pink page color
	jr nz, .notpinkpage

	; if we're here, we're on the pink page
	; set slot 4 (the "text" slot) of Pal 7 to WHITE (FFFF or 7FFF)
	; pal 6 too, status condition, if slot 2 of pal 6 isnt white
	; if it is white, means we are "OK", and dont change slot 4 of pal 6
	ld a, $FF ; loading white into slot 4 of pal 6 and 7, checking pal 6 after
	ld [wBGPals1 palette 7 + 6], a ; slot 4 of Palette 7, byte 1
	ld [wBGPals1 palette 7 + 7], a ; slot 4 of palette 7, byte 2
	ld [wBGPals1 palette 6 + 6], a ; slot 4 of palette 6, byte 1
	ld [wBGPals1 palette 6 + 7], a ; slot 4 of palette 6, byte 2

	; check if the Pokemon is "OK" and therefore needs black text in Palette 6
	pop af
	ldh [rSVBK], a ; restore the Bank that was there before
	; this code is straight from the Vanilla code in engine\pokemon\stats_screen.asm
	ld de, wTempMonStatus
	predef GetStatusConditionIndex

	ldh a, [rSVBK] ; our current real WRAM bank
	push af
	ld a, BANK(wBGPals1) ; go back to editing the palettes directly in their WRAM bank
	ldh [rSVBK], a

	ld a, d ; Status Condition Index
	and a
	jr nz, .done ; we are NOT "OK", keep the white color in slot 4 of pal 6
	xor a ; loading black into slot 4 of pal 6
	ld [wBGPals1 palette 6 + 6], a
	ld [wBGPals1 palette 6 + 7], a
	jr .done
.notpinkpage
	xor a ; loading black into slot 4 of pal 6 and 7
	ld [wBGPals1 palette 6 + 6], a
	ld [wBGPals1 palette 6 + 7], a
	ld [wBGPals1 palette 7 + 6], a
	ld [wBGPals1 palette 7 + 7], a
.done
	pop af
	ldh [rSVBK], a
	call ApplyPals
	ld a, $1
	ret

LoadMailPalettes:
	ld l, e
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, .MailPals
	add hl, de
	ld de, wBGPals1
	ld bc, 1 palettes
	ld a, BANK(wBGPals1)
	call FarCopyWRAM
	call ApplyPals
	call WipeAttrmap
	jmp ApplyAttrmap

.MailPals:
INCLUDE "gfx/mail/mail.pal"

INCLUDE "engine/gfx/cgb_layouts.asm"

CopyFourPalettes:
	ld de, wBGPals1
	ld c, 4

CopyPalettes:
.loop
	push bc
	ld a, [hli]
	push hl
	call GetPredefPal
	call LoadHLPaletteIntoDE
	pop hl
	inc hl
	pop bc
	dec c
	jr nz, .loop
	ret

GetPredefPal:
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, PredefPals
	add hl, bc
	ret

LoadHLPaletteIntoDE:
	ld c, 1 palettes
LoadHLBytesIntoDE:
	ldh a, [rSVBK]
	push af
	ld a, BANK(wOBPals1)
	ldh [rSVBK], a
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	pop af
	ldh [rSVBK], a
	ret

LoadPalette_White_Col1_Col2_Black:
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rSVBK], a

	ld a, LOW(PALRGB_WHITE)
	ld [de], a
	inc de
	ld a, HIGH(PALRGB_WHITE)
	ld [de], a
	inc de

	ld c, 2 * PAL_COLOR_SIZE
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop

	xor a
	ld [de], a
	inc de
	ld [de], a
	inc de

	pop af
	ldh [rSVBK], a
	ret

FillBoxCGB:
.row
	push bc
	push hl
.col
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ret

ResetBGPals:
	push af
	push bc
	push de
	push hl

	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rSVBK], a

	ld hl, wBGPals1
	ld c, 1 palettes
.loop
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	dec c
	jr nz, .loop

	pop af
	ldh [rSVBK], a

	pop hl
	pop de
	pop bc
	pop af
	ret

WipeAttrmap:
	hlcoord 0, 0, wAttrmap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	xor a
	rst ByteFill
	ret

ApplyPals:
	ld hl, wBGPals1
	ld de, wBGPals2
	ld bc, 16 palettes
	ld a, BANK(wGBCPalettes)
	jmp FarCopyWRAM

ApplyAttrmap:
	ldh a, [rLCDC]
	bit rLCDC_ENABLE, a
	jr z, .UpdateVBank1
	ldh a, [hBGMapMode]
	push af
	ld a, $2
	ldh [hBGMapMode], a
	call DelayFrame
	call DelayFrame
	call DelayFrame
	call DelayFrame
	pop af
	ldh [hBGMapMode], a
	ret

.UpdateVBank1:
	hlcoord 0, 0, wAttrmap
	debgcoord 0, 0
	ld b, SCREEN_HEIGHT
	ld a, $1
	ldh [rVBK], a
.row
	ld c, SCREEN_WIDTH
.col
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .col
	ld a, BG_MAP_WIDTH - SCREEN_WIDTH
	add e
	jr nc, .okay
	inc d
.okay
	ld e, a
	dec b
	jr nz, .row
	ld a, $0
	ldh [rVBK], a
	ret

; CGB layout for SCGB_PARTY_MENU_HP_BARS
CGB_ApplyPartyMenuHPPals:
	ld hl, wHPPals
	ld a, [wSGBPals]
	ld e, a
	ld d, 0
	add hl, de
	ld e, l
	ld d, h
	ld a, [de]
	inc a
	ld e, a
	hlcoord 11, 2, wAttrmap
	ld bc, 2 * SCREEN_WIDTH
	ld a, [wSGBPals]
.loop
	and a
	jr z, .done
	add hl, bc
	dec a
	jr .loop
.done
	lb bc, 2, 8
	ld a, e
	jmp FillBoxCGB

InitPartyMenuOBPals:
	ld hl, PartyMenuOBPals
	ld de, wOBPals1
	ld bc, 8 palettes
	ld a, BANK(wOBPals1)
	jmp FarCopyWRAM

SetFirstOBJpalette::
; input: e must contain the offset of the selected palette from PartyMenuOBPals
	ld hl, PartyMenuOBPals
	ld d, 0
	add hl, de
	ld de, wOBPals1
	ld bc, 1 palettes
	ld a, BANK(wOBPals1)
	call FarCopyWRAM
	ld a, TRUE
	ldh [hCGBPalUpdate], a
	jmp ApplyPals

InitPokegearSwarmOBPal:
	ld a, d
	ld hl, PartyMenuOBPals
	ld bc, 1 palettes
	rst AddNTimes
	ld de, wOBPals1 palette 4
	ld bc, 1 palettes
	ld a, BANK(wOBPals1)
	call FarCopyWRAM
	ld hl, wOBPals1 palette 4
	ld de, wOBPals2 palette 4
	ld bc, 1 palettes
	ld a, BANK(wOBPals1)
	call FarCopyWRAM
	ld a, TRUE
	ldh [hCGBPalUpdate], a
	ret

GetBattlemonBackpicPalettePointer:
	push de
	farcall GetPartyMonDVs
	ld c, l
	ld b, h
	ld a, [wTempBattleMonSpecies]
	call GetPlayerOrMonPalettePointer
	pop de
	ret

GetEnemyFrontpicPalettePointer:
	push de
	farcall GetEnemyMonDVs
	ld c, l
	ld b, h
	ld a, [wTempEnemyMonSpecies]
	call GetFrontpicPalettePointer
	pop de
	ret

GetPlayerOrMonPalettePointer:
	and a
	jr nz, GetMonNormalOrShinyPalettePointer
	ld a, [wPlayerSpriteSetupFlags]
	bit PLAYERSPRITESETUP_FEMALE_TO_MALE_F, a
	jr nz, .male
	ld a, [wPlayerGender]
	and a
	jr z, .male
	ld hl, KrisPalette
	ret

.male
	ld hl, PlayerPalette
	ret

GetFrontpicPalettePointer:
	and a
	jr nz, GetMonNormalOrShinyPalettePointer
	ld a, [wTrainerClass]

GetTrainerPalettePointer:
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld bc, TrainerPalettes
	add hl, bc
	ret

GetMonPalettePointer:
	jr _GetMonPalettePointer

BattleObjectPals:
INCLUDE "gfx/battle_anims/battle_anims.pal"

_GetMonPalettePointer:
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, PokemonPalettes
	add hl, bc
	ret

GetMonNormalOrShinyPalettePointer:
	push bc
	call _GetMonPalettePointer
	pop bc
	push hl
	call CheckShininess
	pop hl
	ret nc
rept 4
	inc hl
endr
	ret

InitCGBPals::
; CGB only
	ld a, BANK(vTiles3)
	ldh [rVBK], a
	ld hl, vTiles3
	ld bc, $200 tiles
	xor a
	rst ByteFill
	ld a, BANK(vTiles0)
	ldh [rVBK], a
	ld a, 1 << rBGPI_AUTO_INCREMENT
	ldh [rBGPI], a
	ld c, 4 * TILE_WIDTH
.bgpals_loop
	ld a, LOW(PALRGB_WHITE)
	ldh [rBGPD], a
	ld a, HIGH(PALRGB_WHITE)
	ldh [rBGPD], a
	dec c
	jr nz, .bgpals_loop
	ld a, 1 << rOBPI_AUTO_INCREMENT
	ldh [rOBPI], a
	ld c, 4 * TILE_WIDTH
.obpals_loop
	ld a, LOW(PALRGB_WHITE)
	ldh [rOBPD], a
	ld a, HIGH(PALRGB_WHITE)
	ldh [rOBPD], a
	dec c
	jr nz, .obpals_loop
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rSVBK], a
	ld hl, wBGPals1
	call .LoadWhitePals
	ld hl, wBGPals2
	call .LoadWhitePals
	pop af
	ldh [rSVBK], a
	ret

.LoadWhitePals:
	ld c, 4 * 16
.loop
	ld a, LOW(PALRGB_WHITE)
	ld [hli], a
	ld a, HIGH(PALRGB_WHITE)
	ld [hli], a
	dec c
	jr nz, .loop
	ret

CopyData:
; copy bc bytes of data from hl to de
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, .loop
	ret

ClearBytes:
; clear bc bytes of data starting from de
.loop
	xor a
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, .loop
	ret

DrawDefaultTiles:
; Draw 240 tiles (2/3 of the screen) from tiles in VRAM
	hlbgcoord 0, 0 ; BG Map 0
	ld de, BG_MAP_WIDTH - SCREEN_WIDTH
	ld a, $80 ; starting tile
	ld c, 12 + 1
.line
	ld b, 20
.tile
	ld [hli], a
	inc a
	dec b
	jr nz, .tile
; next line
	add hl, de
	dec c
	jr nz, .line
	ret

INCLUDE "gfx/sgb/pal_packets.asm"

PredefPals:
	table_width PALETTE_SIZE, PredefPals
INCLUDE "gfx/sgb/predef.pal"
	assert_table_length NUM_PREDEF_PALS

HPBarPals:
INCLUDE "gfx/battle/hp_bar.pal"

ExpBarPalette:
INCLUDE "gfx/battle/exp_bar.pal"

INCLUDE "data/pokemon/palettes.asm"

INCLUDE "data/trainers/palettes.asm"

LoadMapPals:
	farcall LoadSpecialMapPalette
	jr c, .got_pals

	; Which palette group is based on whether we're outside or inside
	ld a, [wEnvironment]
	maskbits NUM_ENVIRONMENTS + 1
	ld e, a
	ld d, 0
	ld hl, EnvironmentColorsPointers
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	; Futher refine by time of day
	ld a, [wTimeOfDayPal]
	maskbits NUM_DAYTIMES
	add a
	add a
	add a
	ld e, a
	ld d, 0
	add hl, de
	ld e, l
	ld d, h
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rSVBK], a
	ld hl, wBGPals1
	ld b, 8
.outer_loop
	ld a, [de] ; lookup index for TilesetBGPalette
	push de
	push hl
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, TilesetBGPalette
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ld c, 1 palettes
.inner_loop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .inner_loop
	pop de
	inc de
	dec b
	jr nz, .outer_loop
	pop af
	ldh [rSVBK], a

.got_pals
	ld a, [wTimeOfDayPal]
	maskbits NUM_DAYTIMES
	ld bc, 8 palettes
	ld hl, MapObjectPals
	rst AddNTimes
	ld de, wOBPals1
	ld bc, 8 palettes
	ld a, BANK(wOBPals1)
	call FarCopyWRAM

	farcall LoadSpecialMapOBPalette
	farcall LoadSpecialFollowerPalette

	ld a, [wEnvironment]
	cp TOWN
	jr z, .outside
	cp ROUTE
	ret nz
.outside
	ld a, [wMapGroup]
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, RoofPals
	add hl, de
	ld a, [wTimeOfDayPal]
	maskbits NUM_DAYTIMES
	cp NITE_F
	jr c, .morn_day
rept 4
	inc hl
endr
.morn_day
	ld de, wBGPals1 palette PAL_BG_ROOF color 1
	ld bc, 4
	ld a, BANK(wBGPals1)
	jmp FarCopyWRAM

LoadCPaletteBytesFromHLIntoDE:
	; Loads the number of Palettes passed in 'c' when called
	; Source address is 'hl'
	; Destination address is 'de'
	ldh a, [rSVBK]
	push af
	ld a, BANK("GBC Video")
	ldh [rSVBK], a
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	pop af
	ldh [rSVBK], a
	ret

LoadMonBaseTypePal:
	; destination address of Palette and Slot is passed in 'de'
	; Type Index (already fixed/adjusted if a Special Type) is passed in 'c'
	ld hl, TypeIconPals ; pointer to the Type Colors designated in gfx\types_cats_status_pals.asm
	ld a, c ; c is the Type Index
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld bc, 2
	jmp FarCopyColorWRAM

LoadDexTypePals:
	; ldh a, [rSVBK]
	; push af
	; ld a, BANK(wBGPals1)
	; ldh [rSVBK], a
	; ld a, LOW(PALRGB_WHITE)
	; ld [de], a
	; inc de
	; ld a, HIGH(PALRGB_WHITE)
	; ld [de], a
	; inc de
	; pop af
	; ldh [rSVBK], a
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rSVBK], a
	xor a
	ld [de], a
	inc de
	ld [de], a
	inc de
	pop af
	ldh [rSVBK], a

	ld hl, TypeIconPals
	ld a, b
	add a
	push bc
	ld c, a
	ld b, 0
	add hl, bc
	ld bc, 2
	push de
	call FarCopyColorWRAM
	pop de

	ld hl, TypeIconPals
	pop bc
	ld a, c
	add a
	ld c, a
	ld b, 0
	add hl, bc
	inc de
	inc de
	ld bc, 2
	push de
	call FarCopyColorWRAM
	pop de
	inc de
	inc de

	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rSVBK], a
	xor a
	ld [de], a
	inc de
	ld [de], a
	inc de
	pop af
	ldh [rSVBK], a
	ret

LoadSingleBlackPal:
	; Destination address of the Palette and Slot is passed in 'de'
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rSVBK], a
	xor a ; the color black is $0000
	ld [de], a
	inc de
	ld [de], a
	inc de

	pop af
	ldh [rSVBK], a
	ret

InitPartyMenuStatusPals:
	ld hl, StatusIconPals
	ld c, $1 ; PSN Index
	ld b, 0
	add hl, bc
	add hl, bc
	ld de, wBGPals1 palette 4 + 2 ; Color 2 of Palette 4 (Light Gray Pixels)
	ld bc, 2 ; 1 Color (2 bytes)
	call FarCopyColorWRAM

	ld hl, StatusIconPals
	ld c, $2 ; PAR Index
	ld b, 0
	add hl, bc
	add hl, bc
	ld de, wBGPals1 palette 5 + 2 ; Color 2 of Palette 5 (Light Gray Pixels)
	ld bc, 2 ; 1 Color (2 bytes)
	call FarCopyColorWRAM

	ld hl, StatusIconPals
	ld c, $3 ; SLP Index
	ld b, 0
	add hl, bc
	add hl, bc
 	ld de, wBGPals1 palette 6 + 2 ; Color 2 of Palette 6 (Light Gray Pixels)
	ld bc, 2 ; 1 Color (2 bytes)
	call FarCopyColorWRAM

	ld hl, StatusIconPals
	ld c, $4 ; BRN Index
	ld b, 0
	add hl, bc
	add hl, bc
	ld de, wBGPals1 palette 4 + 4 ; Color 3 of Palette 4 (Dark Gray Pixels)
	ld bc, 2 ; 1 Color (2 bytes)
	call FarCopyColorWRAM

	ld hl, StatusIconPals
	ld c, $5 ; FRZ Index
	ld b, 0
	add hl, bc
	add hl, bc
	ld de, wBGPals1 palette 5 + 4 ; Color 3 of Palette 5 (Dark Gray Pixels)
	ld bc, 2 ; 1 Color (2 bytes)
	call FarCopyColorWRAM

	; put white (7fff) into the slot 4 of pals 4, 5, 6
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rSVBK], a
	ld a, $FF
	ld [wBGPals1 palette 4 + 6], a ; pal 4, slot 4, byte 1
	ld [wBGPals1 palette 5 + 6], a ; pal 5, slot 4, byte 1
	ld [wBGPals1 palette 6 + 6], a ; pal 6, slot 4, byte 1
	ld [wBGPals1 palette 4 + 7], a ; pal 4, slot 4, byte 2
	ld [wBGPals1 palette 5 + 7], a ; pal 5, slot 4, byte 2
	ld [wBGPals1 palette 6 + 7], a ; pal 6, slot 4, byte 2
	pop af
	ldh [rSVBK], a
	ret

LoadBattleCategoryAndTypePals:
	call GetPlayerMoveStructCategory
	ld b, a ; Move Category Index
	call GetPlayerMoveStructType
	ld c, a ; farcall will clobber a for the bank
	; type index is already in c
	ld de, wBGPals1 palette 5
	; fallthrough
LoadCategoryAndTypePals:
	; given: de holds the address of destination Palette and Slot
	; adding a single white pal the way vanilla game does it
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rSVBK], a
	ld a, LOW(PALRGB_WHITE)
	ld [de], a
	inc de ; slot 1 + 1 byte, now pointing at 2nd byte of slot 1
	ld a, HIGH(PALRGB_WHITE)
	ld [de], a
	inc de ; now pointing at slot 2
	pop af
	ldh [rSVBK], a
	; done adding the single white pal

	ld hl, CategoryIconPals ; from gfx\types_cats_status_pals.asm
	ld a, b
	add a ; doubles the Category Index
	add a ; Quadruples the Category Index
	; each Category has two colors, so each entry is 4 bytes long, 2 bytes per Color
	push bc
	ld c, a
	ld b, 0
	add hl, bc
	ld bc, 4 ; 4 bytes worth of colors means 2 slots are being filled at the same time, the two category colors
	push de
	call FarCopyColorWRAM
	pop de ; still pointing to Slot 2 of the Palette

	ld hl, TypeIconPals ; from gfx\types_cats_status_pals.asm
	pop bc
	ld a, c
	add a ; doubles the Index, since each color is 2 bytes
	ld c, a
	ld b, 0
	add hl, bc
	inc de
	inc de
	inc de
	inc de ; incs 4 bytes, skips 2 slots of a Palette, now at Slot 4
	ld bc, 2 ; 2 bytes, 1 color, the type color in slot 4
	jmp FarCopyColorWRAM

LoadPlayerBattleCGBLayoutStatusIconPalette:
	ld bc, 0
	farcall Player_CheckToxicStatus
	jr nc, .check_status_nottoxic
	ld c, 7
.check_status_nottoxic
	ld a, 7
	cp c ; checking if we are Toxic'd
	jr z, .player_gotstatus ; yes, we are toxic
	ld de, wBattleMonStatus
	farcall GetStatusConditionIndex
	ld a, d
	and a
	ret z ; .no_status
	cp $6 ; faint
	ret z
.player_gotstatus
	ld d, a
	jr LoadPlayerStatusIconPalette

LoadStatsScreenStatusIconPalette:
	ld de, wTempMonStatus
	predef GetStatusConditionIndex
	; index is in 'd'
	jr LoadPlayerStatusIconPalette.phase2 ; do not load the white pal in slot 4 of pal 6
LoadPlayerStatusIconPalette:
	; given: Status condition index in 'd'

	; load single white color in slot 4 of palette 6
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rSVBK], a
	ld hl, wBGPals1 palette 6 + 6 ; slot 4 of pal 6
	ld a, $FF
	ld [hli], a
	ld [hl], a
	pop af
	ldh [rSVBK], a
	; done loading white color directly into slot 4 of pal 6
.phase2
	ld hl, StatusIconPals
	ld c, d
	ld b, 0
	add hl, bc ; pointers are 2 bytes long, so double the index to point at the right color
	add hl, bc
	ld de, wBGPals1 palette 6 + 2 ; slot 2 of pal 6
	ld bc, 2 ; number of bytes of the color, 2 bytes per slot
	jmp FarCopyColorWRAM

LoadEnemyBattleCGBLayoutStatusIconPalette:
	ld bc, 0
	farcall Enemy_CheckToxicStatus
	jr nc, .check_status_nottoxic
	ld c, 7
.check_status_nottoxic
	ld a, 7
	cp c ; checking if we are Toxic'd
	jr z, .enemy_gotstatus ; yes, we are toxic
	ld de, wEnemyMonStatus
	predef GetStatusConditionIndex
	ld a, d
	and a
	ret z ; .no_status
	cp $6 ; faint
	ret z
.enemy_gotstatus
	ld d, a
LoadEnemyStatusIconPalette:
	ld a, [wEnemySubStatus2]
	ld de, wEnemyMonStatus
	farcall GetStatusConditionIndex ; status cond. index returned in 'd'
	ld hl, StatusIconPals ; from gfx\types_cats_status_pals.asm
	ld c, d
	ld b, 0
	add hl, bc ; add the index twice because file is list of colors 2 bytes each
	add hl, bc
	ld de, wBGPals1 palette 6 + 4 ; slot 3 of Palette 6
	ld bc, 2 ; two bytes, 1 color
	jmp FarCopyColorWRAM

 LoadPokemonPalette:
	ld a, [wCurPartySpecies]
	; hl = palette
	call GetMonPalettePointer
	; load palette into de (set by caller)
	ld bc, PAL_COLOR_SIZE * 2
	ld a, BANK(wBGPals1)
	jp FarCopyWRAM

INCLUDE "data/maps/environment_colors.asm"
INCLUDE "gfx/types_cats_status_pals.asm"

PartyMenuBGPalette:
INCLUDE "gfx/stats/party_menu_bg.pal"

BillsPC_ThemePals:
	table_width PAL_COLOR_SIZE * 4, BillsPC_ThemePals
INCLUDE "gfx/pc/themes.pal"
	assert_table_length NUM_BILLS_PC_THEMES

BillsPC_CursorPalette:
	; middle colors are set dynamically
	RGB 31,31,31, 31,31,31, 00,00,00, 00,00,00
BillsPC_PackPalette:
	RGB 31,31,31, 31,31,31, 07,19,07, 00,00,00
BillsPC_WhitePalette:
	RGB 31,31,31, 31,31,31, 31,31,31, 31,31,31

TilesetBGPalette:
INCLUDE "gfx/tilesets/bg_tiles.pal"

MapObjectPals::
INCLUDE "gfx/overworld/npc_sprites.pal"

RoofPals:
	table_width PAL_COLOR_SIZE * 2 * 2, RoofPals
INCLUDE "gfx/tilesets/roofs.pal"
	assert_table_length NUM_MAP_GROUPS + 1

DiplomaPalettes:
INCLUDE "gfx/diploma/diploma.pal"

PartyMenuOBPals:
INCLUDE "gfx/stats/party_menu_ob.pal"

UnusedGSTitleBGPals:
INCLUDE "gfx/title/unused_gs_bg.pal"

UnusedGSTitleOBPals:
INCLUDE "gfx/title/unused_gs_fg.pal"

MalePokegearPals:
INCLUDE "gfx/pokegear/pokegear.pal"

FemalePokegearPals:
INCLUDE "gfx/pokegear/pokegear_f.pal"

BetaPokerPals:
INCLUDE "gfx/beta_poker/beta_poker.pal"

SlotMachinePals:
INCLUDE "gfx/slots/slots.pal"
