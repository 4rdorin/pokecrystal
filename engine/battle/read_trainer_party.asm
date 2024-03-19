GetNextTrainerDataByte:
	ld a, [wTrainerGroupBank]
	call GetFarByte
	inc hl
	ret

ReadTrainerParty:
	ld a, [wInBattleTowerBattle]
	bit 0, a
	ret nz

	ld a, [wLinkMode]
	and a
	ret nz

	call SetBadgeBaseLevel
	call SetTeamMaxLevel

	ld hl, wOTPartyCount
	xor a
	ld [hli], a
	dec a
	ld [hl], a

	ld hl, wOTPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH * PARTY_LENGTH
	xor a
	rst ByteFill

	ld a, [wOtherTrainerClass]
	cp CAL
	jr nz, .not_cal2
	ld a, [wOtherTrainerID]
	cp CAL2
	jr z, .cal2
	ld a, [wOtherTrainerClass]
.not_cal2

	dec a
	ld c, a
	ld b, 0
	ld hl, TrainerGroups
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld [wTrainerGroupBank], a
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [wOtherTrainerID]
	ld b, a
.skip_trainer
	dec b
	jr z, .got_trainer
.loop
	call GetNextTrainerDataByte
	cp -1
	jr nz, .loop
	jr .skip_trainer
.got_trainer

.skip_name
	call GetNextTrainerDataByte
	cp "@"
	jr nz, .skip_name

	call GetNextTrainerDataByte
	ld [wOtherTrainerType], a
	ld d, h
	ld e, l
	call ReadTrainerPartyPieces

.done
	jmp ComputeTrainerReward

.cal2
	ld a, BANK(sMysteryGiftTrainer)
	call OpenSRAM
	ld a, TRAINERTYPE_MOVES
	ld [wOtherTrainerType], a
	ld de, sMysteryGiftTrainer
	call ReadTrainerPartyPieces
	call CloseSRAM
	jr .done

ReadTrainerPartyPieces:
	ld h, d
	ld l, e

; Random?
	bit TRAINERTYPE_RANDOM_F, a
	jr z, .not_random
	call GetNextTrainerDataByte
	ld [wRandomTrainerNumPokemon], a
	call GetNextTrainerDataByte
	ld b, a 					; list number, skip this many $ff after bank switch
	ld a, BANK(RandomPartyLists)
	ld [wTrainerGroupBank], a
	ld hl, RandomPartyLists
.random_skiploop
	ld a, b
	and a
	jr z, .skipdone
.random_innerskiploop
	call GetNextTrainerDataByte
	cp -1
	jr nz, .random_innerskiploop
	dec b
	jr .random_skiploop
.skipdone
	call GetNextTrainerDataByte
	ld [wRandomTrainerTotalPokemon], a
	push hl
.start_random
	ld hl, wRandomTrainerRandomNumbers
	ld a, [wRandomTrainerTotalPokemon]
	call RandomRange
	ld b, a
	ld a, [wOTPartyCount]
	ld c, a
	inc c
.repeats_loop
	dec c
	jr z, .no_repeats
	ld a, [hli]
	cp b
	jr z, .start_random
	jr .repeats_loop
.no_repeats
	ld [hl], b
	pop hl
	push hl
	; skip b $fe delimiters
.random_skiploop2
	ld a, b
	and a
	jr z, .skipdone2
.random_innerskiploop2
	call GetNextTrainerDataByte
	cp $fe
	jr nz, .random_innerskiploop2
	dec b
	jr .random_skiploop2
.skipdone2
.not_random
.loop

; end?
	call GetNextTrainerDataByte
	cp -1
	ret z
	cp $fe
	ret z

; level
	call SetDynamicLevel
	ld [wCurPartyLevel], a

; species
	call GetNextTrainerDataByte
	ld [wCurPartySpecies], a

; add to party
	ld a, OTPARTYMON
	ld [wMonType], a
	push hl
	predef TryAddMonToParty
	pop hl

; nickname?
	ld a, [wOtherTrainerType]
	bit TRAINERTYPE_NICKNAME_F, a
	jr z, .no_nickname

	push de
	ld de, wStringBuffer2
.copy_nickname
	call GetNextTrainerDataByte
	ld [de], a
	inc de
	cp "@"
	jr nz, .copy_nickname

	push hl
	ld a, [wOTPartyCount]
	ld hl, wOTPartyMonNicknames - MON_NAME_LENGTH
	ld bc, MON_NAME_LENGTH
	rst AddNTimes
	ld d, h
	ld e, l
	ld hl, wStringBuffer2
	ld bc, MON_NAME_LENGTH
	rst CopyBytes
	pop hl
	pop de
.no_nickname

	; dvs?
	ld a, [wOtherTrainerType]
	bit TRAINERTYPE_DVS_F, a
	jr z, .no_dvs

	push hl
	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1DVs
	call GetPartyLocation
	ld d, h
	ld e, l
	pop hl

	; When reading DVs, treat PERFECT_DV as $ff
	call GetNextTrainerDataByte
	and a
	jr nz, .atk_def_dv_ok
	ld a, $ff
.atk_def_dv_ok
	ld [de], a
	inc de
	call GetNextTrainerDataByte
	and a
	jr nz, .spd_spc_dv_ok
	ld a, $ff
.spd_spc_dv_ok
	ld [de], a
.no_dvs

	; stat exp?
	ld a, [wOtherTrainerType]
	bit TRAINERTYPE_STAT_EXP_F, a
	jr z, .no_stat_exp

	push hl
	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1StatExp
	call GetPartyLocation
	ld d, h
	ld e, l
	pop hl

	ld c, NUM_EXP_STATS
.stat_exp_loop
	; When reading stat experience, treat PERFECT_STAT_EXP as $FFFF
	call GetNextTrainerDataByte
	dec hl
	and a
	jr nz, .not_perfect_stat_exp
	inc hl
	call GetNextTrainerDataByte
	dec hl
	dec hl
	and a
	jr nz, .not_perfect_stat_exp
	ld a, $ff
rept 2
	ld [de], a
	inc de
	inc hl
endr
	jr .continue_stat_exp

.not_perfect_stat_exp
	call GetNextTrainerDataByte
	inc de
	ld [de], a
	dec de
	call GetNextTrainerDataByte
	ld [de], a
	inc de
	inc de
.continue_stat_exp
	dec c
	jr nz, .stat_exp_loop
.no_stat_exp


; item?
	ld a, [wOtherTrainerType]
	bit TRAINERTYPE_ITEM_F, a
	jr z, .no_item

	push hl
	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1Item
	call GetPartyLocation
	ld d, h
	ld e, l
	pop hl

	call GetNextTrainerDataByte
	ld [de], a
.no_item

; moves?
	ld a, [wOtherTrainerType]
	bit TRAINERTYPE_MOVES_F, a
	jr z, .no_moves

	push hl
	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1Moves
	call GetPartyLocation
	ld d, h
	ld e, l
	pop hl

	ld b, NUM_MOVES
.copy_moves
	call GetNextTrainerDataByte
	ld [de], a
	inc de
	dec b
	jr nz, .copy_moves

	push hl

	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1
	call GetPartyLocation
	ld d, h
	ld e, l
	ld hl, MON_PP
	add hl, de

	push hl
	ld hl, MON_MOVES
	add hl, de
	pop de

	ld b, NUM_MOVES
.copy_pp
	ld a, [hli]
	and a
	jr z, .copied_pp

	push hl
	ld hl, Moves + MOVE_PP
	call GetMoveProperty
	pop hl

	ld [de], a
	inc de
	dec b
	jr nz, .copy_pp
.copied_pp

	pop hl
.no_moves

	; Custom DVs affect stats, so recalculate them after TryAddMonToParty
	ld a, [wOtherTrainerType]
	and TRAINERTYPE_DVS | TRAINERTYPE_STAT_EXP
	jr z, .no_stat_recalc

	push hl

	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1MaxHP
	call GetPartyLocation
	ld d, h
	ld e, l

	ld a, [wOTPartyCount]
	dec a
	ld hl, wOTPartyMon1StatExp - 1
	call GetPartyLocation

	; recalculate stats
	ld b, TRUE
	push de
	predef CalcMonStats
	pop hl

	; copy max HP to current HP
	inc hl
	ld a, [hld]
	ld c, a
	ld a, [hld]
	ld b, a
	ld a, c
	ld [hld], a
	ld [hl], b

	pop hl
.no_stat_recalc
	ld a, [wOtherTrainerType]
	bit TRAINERTYPE_RANDOM_F, a
	jmp z, .loop

.random_loop
	ld hl, wRandomTrainerNumPokemon
	dec [hl]
	jp nz, .start_random
	pop hl
	ret


ComputeTrainerReward:
	ld hl, hProduct
	xor a
	ld [hli], a
	ld [hli], a ; hMultiplicand + 0
	ld [hli], a ; hMultiplicand + 1
	ld a, [wEnemyTrainerBaseReward]
	ld [hli], a ; hMultiplicand + 2
	ld a, [wCurPartyLevel]
	ld [hl], a ; hMultiplier
	call Multiply
	ld hl, wBattleReward
	xor a
	ld [hli], a
	ldh a, [hProduct + 2]
	ld [hli], a
	ldh a, [hProduct + 3]
	ld [hl], a
	ret

Battle_GetTrainerName::
	ld a, [wInBattleTowerBattle]
	bit 0, a
	ld hl, wOTPlayerName
	ld a, BANK(Battle_GetTrainerName)
	ld [wTrainerGroupBank], a
	jr nz, CopyTrainerName

	ld a, [wOtherTrainerID]
	ld b, a
	ld a, [wOtherTrainerClass]
	ld c, a

GetTrainerName::
	ld a, c
	cp CAL
	jr nz, .not_cal2

	ld a, BANK(sMysteryGiftTrainerHouseFlag)
	call OpenSRAM
	ld a, [sMysteryGiftTrainerHouseFlag]
	and a
	call CloseSRAM
	jr z, .not_cal2

	ld a, BANK(sMysteryGiftPartnerName)
	call OpenSRAM
	ld hl, sMysteryGiftPartnerName
	call CopyTrainerName
	jmp CloseSRAM

.not_cal2
	dec c
	push bc
	ld b, 0
	ld hl, TrainerGroups
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld [wTrainerGroupBank], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc

.loop
	dec b
	jr z, CopyTrainerName

.skip
	call GetNextTrainerDataByte
	cp $ff
	jr nz, .skip
	jr .loop

CopyTrainerName:
	ld de, wStringBuffer1
	push de
	ld bc, NAME_LENGTH
	ld a, [wTrainerGroupBank]
	call FarCopyBytes
	pop de
	ret

INCLUDE "data/trainers/party_pointers.asm"

SetTrainerBattleLevel:
	ld a, 255
	ld [wCurPartyLevel], a

	ld a, [wInBattleTowerBattle]
	bit 0, a
	ret nz

	ld a, [wLinkMode]
	and a
	ret nz

	ld a, [wOtherTrainerClass]
	dec a
	ld c, a
	ld b, 0
	ld hl, TrainerGroups
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [wOtherTrainerID]
	ld b, a
.skip_trainer
	dec b
	jr z, .got_trainer
.skip_party
	ld a, [hli]
	cp $ff
	jr nz, .skip_party
	jr .skip_trainer
.got_trainer

.skip_name
	ld a, [hli]
	cp "@"
	jr nz, .skip_name

	inc hl
	ld a, [hl]
	call SetDynamicLevel
	ld [wCurPartyLevel], a
	ret

SetBadgeBaseLevel:
	ld hl, wBadges
	ld b, wBadgesEnd - wBadges
	call CountSetBits
	ld hl, BadgeBaseLevels
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wBadgeBaseLevel], a
	ret

INCLUDE "data/wild/badge_base_levels.asm"

SetTeamMaxLevel:
	ld a, [wPartyCount]
	ld b, a
	ld hl, wPartyMon1Level
	ld a, [hl]
	dec b
	jr z, .SetLevel
	ld de, PARTYMON_STRUCT_LENGTH
	ld c, a

.LoopPartyLevel
	add hl, de
	ld a, [hl]
	cp c
	jr c, .Continue
	ld c, a
.Continue
	dec b
	jr nz, .LoopPartyLevel
	ld a, c
.SetLevel
	ld [wTeamMaxLevel], a

SetDynamicLevel:
	cp MAX_LEVEL + 1
	ret c
	cp 199
	jr nc, .MaxLevelMode
	sub LEVEL_FROM_BADGES
	ld b, a
	ld a, [wBadgeBaseLevel]
	add b
	cp MAX_LEVEL + 1
	ret c
; cap overflowflow at level 100
	cp LEVEL_FROM_BADGES
	ld a, MAX_LEVEL
	ret c
; cap overflow at level 2
	ld a, 2
	ret

.MaxLevelMode
	sub LEVEL_FROM_PARTY
	ld b, a
	ld a, [wTeamMaxLevel]
	add b
	cp MAX_LEVEL
	ret c
; cap overflowflow at level 100
	cp LEVEL_FROM_PARTY
	ld a, MAX_LEVEL
	ret c
; cap overflow at level 2
	ld a, 2
	ret
