BattleCommand_BatonPass:
	ldh a, [hBattleTurn]
	and a
	jr nz, .Enemy

; Need something to switch to
	call CheckAnyOtherAlivePartyMons
	jr z, FailedBatonPass

	call UpdateBattleMonInParty
	call AnimateCurrentMove

	ld c, 50
	call DelayFrames

; Transition into switchmon menu
	call LoadStandardMenuHeader
	farcall SetUpBattlePartyMenu

	farcall ForcePickSwitchMonInBattle

; Return to battle scene
	call ClearPalettes
	farcall _LoadBattleFontsHPBar
	call CloseWindow
	call ClearSprites
	hlcoord 1, 0
	lb bc, 4, 10
	call ClearBox
	ld b, SCGB_BATTLE_COLORS
	call GetSGBLayout
	call SetDefaultBGPAndOBP

	farcall PassedBattleMonEntrance

	jr ResetBatonPassStatus

.Enemy:
; Wildmons don't have anything to switch to
	ld a, [wBattleMode]
	dec a ; WILDMON
	jr z, FailedBatonPass

	call CheckAnyOtherAliveEnemyMons
	jr z, FailedBatonPass

	call UpdateEnemyMonInParty
	call AnimateCurrentMove

; Passed enemy PartyMon entrance
	xor a
	ld [wEnemySwitchMonIndex], a
	farcall EnemySwitch_SetMode
	farcall ResetBattleParticipants
	ld a, TRUE
	ld [wApplyStatLevelMultipliersToEnemy], a
	farcall ApplyStatLevelMultiplierOnAllStats

	farcall SpikesDamage

	jr ResetBatonPassStatus

FailedBatonPass:
	call AnimateFailedMove
	jmp PrintButItFailed

ResetBatonPassStatus:
; Reset status changes that aren't passed by Baton Pass.

	; Nightmare isn't passed.
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and SLP_MASK
	jr nz, .ok

	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	res SUBSTATUS_NIGHTMARE, [hl]
.ok

	; Disable isn't passed.
	call ResetActorDisable

	; Attraction isn't passed.
	ld hl, wPlayerSubStatus1
	res SUBSTATUS_IN_LOVE, [hl]
	ld hl, wEnemySubStatus1
	res SUBSTATUS_IN_LOVE, [hl]
	ld hl, wPlayerSubStatus5

	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVarAddr
	res SUBSTATUS_TRANSFORMED, [hl]
	res SUBSTATUS_ENCORED, [hl]

	; New mon hasn't used a move yet.
	ld a, BATTLE_VARS_LAST_MOVE
	call GetBattleVarAddr
	ld [hl], 0

	xor a
	ld [wPlayerWrapCount], a
	ld [wEnemyWrapCount], a
	ret
