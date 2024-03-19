LoadSpecialMapPalette:
	ld a, [wMapTileset]
	cp TILESET_BATTLE_TOWER_INSIDE
	jr z, .battle_tower_inside
	cp TILESET_ICE_PATH
	jr z, .ice_path
	cp TILESET_HOUSE
	jr z, .house
	cp TILESET_RADIO_TOWER
	jr z, .radio_tower
	cp TILESET_MANSION
	jr z, .mansion

	ld a, [wMapGroup]
	cp GROUP_SAFARI_ZONE_AREA_2
	jr nz, .not_safari_zone_area_2
	ld a, [wMapNumber]
	cp MAP_SAFARI_ZONE_AREA_2
	jr z, .SandOverBrownBGPalette
.not_safari_zone_area_2
	ld a, [wMapGroup]
	cp GROUP_SAFARI_ZONE_AREA_3
	jr nz, .not_safari_zone_area_3
	ld a, [wMapNumber]
	cp MAP_SAFARI_ZONE_AREA_3
	jr z, .SwampBGPalettes
.not_safari_zone_area_3
	ld a, [wMapGroup]
	cp GROUP_SAFARI_ZONE_AREA_4
	jr nz, .not_safari_zone_area_4
	ld a, [wMapNumber]
	cp MAP_SAFARI_ZONE_AREA_4
	jr z, .SundriedBGPalettes
.not_safari_zone_area_4
	ld a, [wMapGroup]
	cp GROUP_POKEMON_MANSION_B1F
	jr nz, .not_Pokemon_Mansion_B1F
	ld a, [wMapNumber]
	cp MAP_POKEMON_MANSION_B1F
	jr z, .LavaOverRedCoalOverBrownBGPalette
.not_Pokemon_Mansion_B1F
	jr .do_nothing

.battle_tower_inside
	call LoadBattleTowerInsidePalette
	scf
	ret

.ice_path
	ld a, [wEnvironment]
	and $7
	cp INDOOR ; Hall of Fame
	jr z, .do_nothing
	call LoadIcePathPalette
	scf
	ret

.house
	call LoadHousePalette
	scf
	ret

.radio_tower
	call LoadRadioTowerPalette
	scf
	ret

.mansion
	call LoadMansionPalette
	scf
	ret

.LavaOverRedCoalOverBrownBGPalette
	ld hl, LavaOverRedCoalOverBrown
	jr .next

.SandOverBrownBGPalette:
	ld hl, SandOverRock
	ld a, [wTimeOfDayPal]
	maskbits NUM_DAYTIMES
	ld bc, 8 palettes
	rst AddNTimes
	jr .next_TimeOfDay

.SwampBGPalettes:
	ld hl, SwampPals
	ld a, [wTimeOfDayPal]
	maskbits NUM_DAYTIMES
	ld bc, 8 palettes
	rst AddNTimes
	jr .next_TimeOfDay

.SundriedBGPalettes:
	ld hl, SundriedPals
	ld a, [wTimeOfDayPal]
	maskbits NUM_DAYTIMES
	ld bc, 8 palettes
	rst AddNTimes
	ld de, wBGPals1
	ld a, BANK(wBGPals1)
	call FarCopyWRAM
	scf
	ret

.next
	ld bc, 8 palettes
.next_TimeOfDay
	ld de, wBGPals1
	ld a, BANK(wBGPals1)
	call FarCopyWRAM
	scf
	ret

.do_nothing
	and a
	ret

LoadBattleTowerInsidePalette:
	ld a, BANK(wBGPals1)
	ld de, wBGPals1
	ld hl, BattleTowerInsidePalette
	ld bc, 8 palettes
	jmp FarCopyWRAM

BattleTowerInsidePalette:
INCLUDE "gfx/tilesets/battle_tower_inside.pal"

LoadIcePathPalette:
	ld a, BANK(wBGPals1)
	ld de, wBGPals1
	ld hl, IcePathPalette
	ld bc, 8 palettes
	jmp FarCopyWRAM

IcePathPalette:
INCLUDE "gfx/tilesets/ice_path.pal"

LoadHousePalette:
	ld a, BANK(wBGPals1)
	ld de, wBGPals1
	ld hl, HousePalette
	ld bc, 8 palettes
	jmp FarCopyWRAM

HousePalette:
INCLUDE "gfx/tilesets/house.pal"

LoadRadioTowerPalette:
	ld a, BANK(wBGPals1)
	ld de, wBGPals1
	ld hl, RadioTowerPalette
	ld bc, 8 palettes
	jmp FarCopyWRAM

RadioTowerPalette:
INCLUDE "gfx/tilesets/radio_tower.pal"

MansionPalette1:
INCLUDE "gfx/tilesets/mansion_1.pal"

LoadMansionPalette:
	ld a, BANK(wBGPals1)
	ld de, wBGPals1
	ld hl, MansionPalette1
	ld bc, 8 palettes
	call FarCopyWRAM
	ld a, BANK(wBGPals1)
	ld de, wBGPals1 palette PAL_BG_YELLOW
	ld hl, MansionPalette2
	ld bc, 1 palettes
	call FarCopyWRAM
	ld a, BANK(wBGPals1)
	ld de, wBGPals1 palette PAL_BG_WATER
	ld hl, MansionPalette1 palette 6
	ld bc, 1 palettes
	call FarCopyWRAM
	ld a, BANK(wBGPals1)
	ld de, wBGPals1 palette PAL_BG_ROOF
	ld hl, MansionPalette1 palette 8
	ld bc, 1 palettes
	jmp FarCopyWRAM

MansionPalette2:
INCLUDE "gfx/tilesets/mansion_2.pal"

LoadSpecialMapOBPalette:
	ld hl, SpecialOBPalettes
.loop
	ld a, [hli]
	and a
	ret z
	ld b, a
	ld a, [wMapGroup]
	cp b
	ld a, [hli]
	jr nz, .next
	ld b, a
	ld a, [wMapNumber]
	cp b
	jr nz, .next
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a			; de = color original
	ld a, [hli]
	ld h, [hl]
	ld l, a			; hl = nuevo color
	ld bc, 1 palettes
	jmp FarCopyColorWRAM
.next
rept 4
	inc hl
endr
	jr .loop

LoadSpecialFollowerPalette:
	ld hl, SpecialFollowerPalettes
.loop
	ld a, [hli]
	and a
	ret z
	ld b, a
	ld a, [wFollowerPalNum]
	cp b
	jr nz, .next
	ld a, [hli]
	ld h, [hl]
	ld l, a			; hl = nuevo color
	ld bc, 1 palettes
	ld de, wOBPals1 palette PAL_OW_FOLLOWER
	jmp FarCopyColorWRAM
.next
	inc hl
	inc hl
	jr .loop

INCLUDE "data/maps/palettes.asm"
INCLUDE "gfx/tilesets/bg_tiles_special_pals.pal"
