GetPartyParamLocation::
; Get the location of parameter a from wCurPartyMon in hl
	push bc
	ld hl, wPartyMons
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wCurPartyMon]
	call GetPartyLocation
	pop bc
	ret

GetPartyLocation::
; Add the length of a PartyMon struct to hl a times.
	ld bc, PARTYMON_STRUCT_LENGTH
	jmp AddNTimes

UserPartyAttr::
	push af
	ldh a, [hBattleTurn]
	and a
	jr nz, .ot
	pop af
	jr BattlePartyAttr
.ot
	pop af
	jr OTPartyAttr

OpponentPartyAttr::
	push af
	ldh a, [hBattleTurn]
	and a
	jr z, .ot
	pop af
	jr BattlePartyAttr
.ot
	pop af
	jr OTPartyAttr

BattlePartyAttr::
; Get attribute a from the party struct of the active battle mon.
	push bc
	ld c, a
	ld b, 0
	ld hl, wPartyMons
	add hl, bc
	ld a, [wCurBattleMon]
	call GetPartyLocation
	pop bc
	ret

OTPartyAttr::
; Get attribute a from the party struct of the active enemy mon.
	push bc
	ld c, a
	ld b, 0
	ld hl, wOTPartyMon1Species
	add hl, bc
	ld a, [wCurOTMon]
	call GetPartyLocation
	pop bc
	ret

ResetDamage::
	xor a
	ld [wCurDamage], a
	ld [wCurDamage + 1], a
	ret

SetPlayerTurn::
	xor a
	ldh [hBattleTurn], a
	ret

SetEnemyTurn::
	ld a, 1
	ldh [hBattleTurn], a
	ret

UpdateOpponentInParty::
	ldh a, [hBattleTurn]
	and a
	jr z, UpdateEnemyMonInParty
	jr UpdateBattleMonInParty

UpdateUserInParty::
	ldh a, [hBattleTurn]
	and a
	jr z, UpdateBattleMonInParty

;fallthrough
UpdateEnemyMonInParty::
; Update level, status, current HP

; No wildmons.
	ld a, [wBattleMode]
	dec a
	ret z

	ld a, [wCurOTMon]
	ld hl, wOTPartyMon1Level
	call GetPartyLocation

	ld d, h
	ld e, l
	ld hl, wEnemyMonLevel
	ld bc, wEnemyMonMaxHP - wEnemyMonLevel
	jmp CopyBytes

UpdateBattleMonInParty::
; Update level, status, current HP

	ld a, [wCurBattleMon]

UpdateBattleMon::
	ld hl, wPartyMon1Level
	call GetPartyLocation

	ld d, h
	ld e, l
	ld hl, wBattleMonLevel
	ld bc, wBattleMonMaxHP - wBattleMonLevel
	jmp CopyBytes

RefreshBattleHuds::
	call UpdateBattleHuds
	ld c, 3
	call DelayFrames
	jmp WaitBGMap

UpdateBattleHuds::
	farcall UpdatePlayerHUD
	farjp UpdateEnemyHUD

INCLUDE "home/battle_vars.asm"

FarCopyRadioText::
	inc hl
	ldh a, [hROMBank]
	push af
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ldh [hROMBank], a
	ld [MBC3RomBank], a
	ld a, e
	ld l, a
	ld a, d
	ld h, a
	ld de, wRadioText
	ld bc, 2 * SCREEN_WIDTH
	rst CopyBytes
	pop af
	ldh [hROMBank], a
	ld [MBC3RomBank], a
	ret

BattleTextbox::
; Open a textbox and print text at hl.
	push hl
	call SpeechTextbox
	call UpdateSprites
	call ApplyTilemap
	pop hl
	jmp PrintTextboxText

StdBattleTextbox::
; Open a textbox and print battle text at 20:hl.

	ldh a, [hROMBank]
	push af

	ld a, BANK(BattleText)
	rst Bankswitch

	call BattleTextbox

	pop af
	rst Bankswitch
	ret

GetBattleAnimPointer::
	ld a, BANK(BattleAnimations)
	rst Bankswitch

	ld a, [hli]
	ld [wBattleAnimAddress], a
	ld a, [hl]
	ld [wBattleAnimAddress + 1], a

	; ClearBattleAnims is the only function that calls this...
	ld a, BANK(ClearBattleAnims)
	rst Bankswitch

	ret

GetBattleAnimByte::
	push hl
	push de

	ld hl, wBattleAnimAddress
	ld e, [hl]
	inc hl
	ld d, [hl]

	ld a, BANK(BattleAnimations)
	rst Bankswitch

	ld a, [de]
	ld [wBattleAnimByte], a
	inc de

	ld a, BANK(BattleAnimCommands)
	rst Bankswitch

	ld a, d
	ld [hld], a
	ld [hl], e

	pop de
	pop hl

	ld a, [wBattleAnimByte]
	ret

PushLYOverrides::
	ldh a, [hLCDCPointer]
	and a
	ret z

	ld a, LOW(wLYOverridesBackup)
	ld [wRequested2bppSource], a
	ld a, HIGH(wLYOverridesBackup)
	ld [wRequested2bppSource + 1], a

	ld a, LOW(wLYOverrides)
	ld [wRequested2bppDest], a
	ld a, HIGH(wLYOverrides)
	ld [wRequested2bppDest + 1], a

	ld a, (wLYOverridesEnd - wLYOverrides) / LEN_2BPP_TILE
	ld [wRequested2bppSize], a
	ret

GetCurMoveProperty::
	ld a, [wCurSpecies]
GetMoveProperty::
	dec a
GetMoveAttr::
; Assuming hl = Moves + x, return attribute x of move a.
	push bc
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	pop bc
	ret

GetCurMoveCategory::
	ld a, [wCurSpecies]
GetMoveCategory::
	dec a
GetMoveCategoryAttr::
	push bc
	ld hl, Moves + MOVE_TYPE
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte

;check dark and ghost
	ld b, a
	ld a, [wPhysicalDark]
	and a
	ld a, b
	jr z, .check_waterfall
	cp SPECIAL | DARK
	jr z, .is_physical
	cp PHYSICAL | GHOST
	jr z, .is_special
.check_waterfall
	ld a, [wPhysicalWaterfall]
	and a
	ld a, b
	jr nz, .remove_type
	cp PHYSICAL | WATER
	jr z, .is_special

.remove_type
	and ~TYPE_MASK
	swap a
	srl a
	srl a
	dec a
	pop bc
	ret

.is_physical
	ld b, PHYSICAL
	jr .remove_type

.is_special
	ld b, SPECIAL
	jr .remove_type


GetPlayerMoveStructCategory::
	push bc
	ld a, [wPlayerMoveStruct + MOVE_TYPE]
	;check dark and ghost
	ld b, a
	ld a, [wPhysicalDark]
	and a
	ld a, b
	jr z, .check_waterfall
	cp SPECIAL | DARK
	jr z, .is_physical
	cp PHYSICAL | GHOST
	jr z, .is_special
.check_waterfall
	ld a, [wPhysicalWaterfall]
	and a
	ld a, b
	jr nz, .remove_type
	cp PHYSICAL | WATER
	jr z, .is_special

.remove_type
	and ~TYPE_MASK
	swap a
	srl a
	srl a
	dec a
	pop bc
	ret

.is_physical
	ld b, PHYSICAL
	jr .remove_type

.is_special
	ld b, SPECIAL
	jr .remove_type

GetCurMoveType::
	ld a, [wCurSpecies]
GetMoveType::
	dec a
GetMoveTypeAttr::
	push bc
	ld hl, Moves + MOVE_TYPE
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	and TYPE_MASK
	pop bc
	ret

GetPlayerMoveStructType::
	ld a, [wPlayerMoveStruct + MOVE_TYPE]
	and TYPE_MASK
	ret

; These routines return z if the user is of the given type
CheckIfTargetIsGrassType::
	ld a, GRASS
	jr CheckIfTargetIsSomeType
CheckIfTargetIsSteelType::
	ld a, STEEL
	jr CheckIfTargetIsSomeType
CheckIfTargetIsFireType::
	ld a, FIRE
	jr CheckIfTargetIsSomeType
CheckIfTargetIsPoisonType::
	ld a, POISON
	jr CheckIfTargetIsSomeType
CheckIfTargetIsIceType::
	ld a, ICE
CheckIfTargetIsSomeType::
	ld b, a
	ldh a, [hBattleTurn]
	jr CheckIfSomeoneIsSomeType
CheckIfUserIsFlyingType::
	ld a, FLYING
	jr CheckIfUserIsSomeType
CheckIfUserIsGhostType::
	ld a, GHOST
	jr CheckIfUserIsSomeType
CheckIfUserIsGroundType::
	ld a, GROUND
	jr CheckIfUserIsSomeType
CheckIfUserIsRockType::
	ld a, ROCK
	jr CheckIfUserIsSomeType
CheckIfUserIsSteelType::
	ld a, STEEL
CheckIfUserIsSomeType::
	ld b, a
	ldh a, [hBattleTurn]
	xor 1
CheckIfSomeoneIsSomeType:
	ld c, a
	ld de, wEnemyMonType1
	ld a, c
	and a
	jr z, .ok
	ld de, wBattleMonType1
.ok
	ld a, [de]
	inc de
	cp b
	ret z
	ld a, [de]
	cp b
	ret

Adjust_percent::
	call Scale256To100
	cp 90
	ret nc
	cp 84
	ret c
	inc a
	ret

Scale256To100::
	; in: a: value (x/256)
	; out: a: value (x/100)
	ld l, a
	ld h, 0
	push af
	; multiply by 3...
	add hl, hl
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	; ...now by 8, giving 24...
	add hl, hl
	add hl, hl
	add hl, hl
	; ...and add the original value back, giving 25
	pop af
	add l
	ld l, a
	adc h
	sbc l
	ld h, a
	; then multiply by 4, since 25 x 4 = 100
	add hl, hl
	add hl, hl
	; round the high byte to nearest, drop the low byte and done!
	sla l
	sbc a
	and 1
	add h
	ret

BattleCommand_SwitchTurn::
SwitchTurn::
; Preserves all registers.
	push af
	ldh a, [hBattleTurn]
	xor 1
	ldh [hBattleTurn], a
	pop af
	ret

GetBackupItemAddr::
; Return address of backup item for current mon in hl
	push bc
	ld a, [wCurBattleMon]
	ld c, a
	ld b, 0
	ld hl, wPartyBackupItems
	add hl, bc
	pop bc
	ret
	
SetBackupItem::
; If backup is empty, replace it with b if it's our turn
	ldh a, [hBattleTurn]
	and a
	ret nz
	
	call GetBackupItemAddr
	ld a, [hl]
	and a
	ret nz
	ld [hl], b
	ret
	
BackupBattleItems::
; Copies items from party to backup wram
	ld c, 0
	jr ToggleBattleItems
RestoreBattleItems::
; Restores items from wPartyBackupItems
	ld c, 1
; fallthrough
ToggleBattleItems:
	ld b, 7
	ld hl, wPartyMon1Item
	ld de, wPartyBackupItems
.loop
	dec b
	ret z
	ld a, c
	and a
	jr nz, .restore
	
; Backup
	ld a, [hl]
	ld [de], a
	jr .next
	
.restore
	ld a, [de]
	ld [hl], a
; fallthrough
.next
	inc de
	push bc
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc
	pop bc
	jr .loop

