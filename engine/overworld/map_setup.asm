RunMapSetupScript::
	ldh a, [hMapEntryMethod]
	and $f
	dec a
	ld c, a
	ld b, 0
	ld hl, MapSetupScripts
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jmp ReadMapSetupScript

INCLUDE "data/maps/setup_scripts.asm"

ReadMapSetupScript:
.loop
	ld a, [hli]
	cp -1 ; end?
	ret z

	push hl

	ld c, a
	ld b, 0
	ld hl, MapSetupCommands
	add hl, bc
	add hl, bc
	add hl, bc

	; bank
	ld b, [hl]
	inc hl

	; address
	ld a, [hli]
	ld h, [hl]
	ld l, a

	; Bit 7 of the bank indicates a parameter.
	; This is left unused.
	bit 7, b
	jr z, .go

	pop de
	ld a, [de]
	ld c, a
	inc de
	push de

.go
	ld a, b
	and $7f
	call FarCall_hl

	pop hl
	jr .loop

INCLUDE "data/maps/setup_script_pointers.asm"

EnableTextAcceleration:
	xor a
	ld [wDisableTextAcceleration], a
	ret

ActivateMapAnims:
	ld a, TRUE
	ldh [hMapAnims], a
	ret

SuspendMapAnims:
	xor a ; FALSE
	ldh [hMapAnims], a
	ret

LoadMapObjects:
	ld a, MAPCALLBACK_OBJECTS
	call RunMapCallback
	farcall LoadObjectMasks
	farjp InitializeVisibleSprites

ResetPlayerObjectAction:
	ld hl, wPlayerSpriteSetupFlags
	set PLAYERSPRITESETUP_RESET_ACTION_F, [hl]
	ret

SkipUpdateMapSprites:
	ld hl, wPlayerSpriteSetupFlags
	set PLAYERSPRITESETUP_SKIP_RELOAD_GFX_F, [hl]
	ret

CheckUpdatePlayerSprite:
	nop
	call .CheckForcedBiking
	jr c, .ok
	call .CheckSurfing
	jr c, .ok
	call .ResetSurfingOrBikingState
	jr c, .ok
	ret

.ok
	jmp UpdatePlayerSprite

.CheckForcedBiking:
	and a
	ld hl, wBikeFlags
	bit BIKEFLAGS_ALWAYS_ON_BIKE_F, [hl]
	ret z
	ld a, PLAYER_BIKE
	ld [wPlayerState], a
	scf
	ret

.ResetSurfingOrBikingState:
	ld a, [wPlayerState]
	cp PLAYER_NORMAL
	jr z, .nope
	cp PLAYER_SKATE
	jr z, .nope
	cp PLAYER_SURF
	jr z, .surfing
	cp PLAYER_SURF_PIKA
	jr z, .surfing
	call GetMapEnvironment
	cp INDOOR
	jr z, .no_biking
	cp GYM
	jr z, .no_biking
	cp DUNGEON
	jr nz, .nope
.no_biking
	ld a, [wPlayerState]
	cp PLAYER_BIKE
	jr nz, .nope
.surfing
	ld a, PLAYER_NORMAL
	ld [wPlayerState], a
	ld [wFollowerState], a
	scf
	ret

.nope
	and a
	ret

.CheckSurfing:
	call CheckOnWater
	jr nz, .nope2
	ld a, [wPlayerState]
	cp PLAYER_SURF
	jr z, .is_surfing
	cp PLAYER_SURF_PIKA
	jr z, .is_surfing
	ld a, PLAYER_SURF
	ld [wPlayerState], a
.is_surfing
	scf
	ret

.nope2
	and a
	ret

FadeOutMapMusic:
	ld a, 6
	jmp SkipMusic

ApplyMapPalettes:
	farjp _UpdateTimePals

FadeMapMusicAndPalettes:
	ld de, MUSIC_NONE
	ld a, $4
	ld [wMusicFade], a
	jmp RotateThreePalettesRight

ForceMapMusic:
	ld a, [wPlayerState]
	cp PLAYER_BIKE
	jr nz, .notbiking
	call MinVolume
	ld a, $88
	ld [wMusicFade], a
.notbiking
	jmp TryRestartMapMusic