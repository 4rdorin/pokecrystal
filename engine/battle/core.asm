; Core components of the battle engine.

DoBattle:
	call BackupBattleItems
	xor a
	ld [wBattleParticipantsNotFainted], a
	ld [wBattleParticipantsIncludingFainted], a
	ld [wBattlePlayerAction], a
	ld [wBattleEnded], a
	inc a
	ld [wBattleHasJustStarted], a
	ld hl, wOTPartyMon1HP
	ld bc, PARTYMON_STRUCT_LENGTH - 1
	ld d, BATTLEACTION_SWITCH1 - 1
.loop
	inc d
	ld a, [hli]
	or [hl]
	jr nz, .alive
	add hl, bc
	jr .loop

.alive
	ld a, d
	ld [wBattleAction], a
	ld a, [wLinkMode]
	and a
	jr z, .not_linked

	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr z, .player_2

.not_linked
	ld a, [wBattleMode]
	dec a
	jr z, .wild
	ld a, [wOTPartyCount]
	ld [wEnemyMonsLeft], a	;IA
	xor a
	ld [wEnemySwitchMonIndex], a
	call NewEnemyMonStatus
	call ResetEnemyStatLevels
	call BreakAttraction
	call EnemySwitch

.wild
	ld c, 30
	call DelayFrames

.player_2
	call LoadTilemapToTempTilemap
	call CheckPlayerPartyForFitMon
	ld a, d
	and a
	jmp z, LostBattle
	call SafeLoadTempTilemapToTilemap
	ld a, [wBattleType]
	cp BATTLETYPE_DEBUG
	jr z, .tutorial_debug
	cp BATTLETYPE_TUTORIAL
	jr z, .tutorial_debug
	xor a
	ld [wCurPartyMon], a
.loop2
	call CheckIfCurPartyMonIsFitToFight
	jr nz, .alive2
	ld hl, wCurPartyMon
	inc [hl]
	jr .loop2

.alive2
	ld a, [wCurBattleMon]
	ld [wLastPlayerMon], a
	ld a, [wCurPartyMon]
	ld [wCurBattleMon], a
	inc a
	ld hl, wPartySpecies - 1
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wCurPartySpecies], a
	ld [wTempBattleMonSpecies], a
	hlcoord 1, 5
	ld a, 9
	call SlideBattlePicOut
	call LoadTilemapToTempTilemap
	call ResetBattleParticipants
	call InitBattleMon
	call ResetPlayerStatLevels
	call SendOutMonText
	call NewBattleMonStatus
	call BreakAttraction
	call SendOutPlayerMon
	call EmptyBattleTextbox
	call LoadTilemapToTempTilemap
	call SetPlayerTurn
	call SpikesDamage
	ld a, [wLinkMode]
	and a
	jr z, BattleTurn
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr nz, BattleTurn
	xor a
	ld [wEnemySwitchMonIndex], a
	call NewEnemyMonStatus
	call ResetEnemyStatLevels
	call BreakAttraction
	call EnemySwitch
	call SetEnemyTurn
	call SpikesDamage
	jr BattleTurn

.tutorial_debug
	jmp BattleMenu

WildFled_EnemyFled_LinkBattleCanceled:
	call SafeLoadTempTilemapToTilemap
	ld a, [wBattleResult]
	and BATTLERESULT_BITMASK
	add DRAW
	ld [wBattleResult], a
	ld a, [wLinkMode]
	and a
	ld hl, BattleText_WildFled
	jr z, .print_text

	ld a, [wBattleResult]
	and BATTLERESULT_BITMASK
	ld [wBattleResult], a ; WIN
	ld hl, BattleText_EnemyFled
.print_text
	call StdBattleTextbox

.skip_text
	call StopDangerSound
	ld de, SFX_RUN
	call WaitPlaySFX
	call SetPlayerTurn
	ld a, 1
	ld [wBattleEnded], a
	ret

BattleTurn:
.loop
	call CheckContestBattleOver
	ret c

	xor a
	ld [wPlayerIsSwitching], a
	ld [wEnemyIsSwitching], a
	ld [wBattleHasJustStarted], a
	ld [wPlayerJustGotFrozen], a
	ld [wEnemyJustGotFrozen], a
	ld [wCurDamage], a
	ld [wCurDamage + 1], a

	call HandleBerserkGene
	call UpdateBattleMonInParty
	farcall AIChooseMove

	call CheckPlayerLockedIn
	jr c, .skip_iteration
.loop1
	call BattleMenu
	ret c
	ld a, [wBattleEnded]
	and a
	ret nz
	ld a, [wForcedSwitch] ; roared/whirlwinded/teleported
	and a
	ret nz
.skip_iteration
	call ParsePlayerAction
	push af
	call ClearSprites
	pop af
	jr nz, .loop1

	call EnemyTriesToFlee
	ret c

	call DetermineMoveOrder
	jr c, .false
	call Battle_EnemyFirst
	jr .proceed
.false
	call Battle_PlayerFirst
.proceed
	ld a, [wForcedSwitch]
	and a
	ret nz

	ld a, [wBattleEnded]
	and a
	ret nz

	call HandleBetweenTurnEffects
	ld a, [wBattleEnded]
	and a
	ret nz
	jr .loop

HandleBetweenTurnEffects:
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .CheckEnemyFirst
	call CheckFaint_PlayerThenEnemy
	ret c
	call HandleFutureSight
	call CheckFaint_PlayerThenEnemy
	ret c
	call HandleWeather
	call CheckFaint_PlayerThenEnemy
	ret c
	call HandleWrap
	call CheckFaint_PlayerThenEnemy
	ret c
	call HandlePerishSong
	call CheckFaint_PlayerThenEnemy
	ret c
	jr .NoMoreFaintingConditions

.CheckEnemyFirst:
	call CheckFaint_EnemyThenPlayer
	ret c
	call HandleFutureSight
	call CheckFaint_EnemyThenPlayer
	ret c
	call HandleWeather
	call CheckFaint_EnemyThenPlayer
	ret c
	call HandleWrap
	call CheckFaint_EnemyThenPlayer
	ret c
	call HandlePerishSong
	call CheckFaint_EnemyThenPlayer
	ret c

.NoMoreFaintingConditions:
	call CheckEnemyTrapped
	call HandleLeftovers
	call HandleSpeedBoost
	call HandleMysteryberry
	call HandleDefrost
	call HandleSafeguard
	call HandleScreens
	call HandleStatBoostingHeldItems
	call HandleHealingItems
	call UpdateBattleMonInParty
	call LoadTilemapToTempTilemap
	jmp HandleEncore

HasAnyoneFainted:
	call HasPlayerFainted
	jmp nz, HasEnemyFainted
	ret

CheckFaint_PlayerThenEnemy:
.faint_loop
	call .Function
	ret c
	call HasAnyoneFainted
	ret nz
	jr .faint_loop

.Function:
	call HasPlayerFainted
	jr nz, .PlayerNotFainted
	call HandlePlayerMonFaint
	ld a, [wBattleEnded]
	and a
	jr nz, .BattleIsOver

.PlayerNotFainted:
	call HasEnemyFainted
	jr nz, .BattleContinues
	call HandleEnemyMonFaint
	ld a, [wBattleEnded]
	and a
	jr nz, .BattleIsOver

.BattleContinues:
	and a
	ret

.BattleIsOver:
	scf
	ret

CheckFaint_EnemyThenPlayer:
.faint_loop
	call .Function
	ret c
	call HasAnyoneFainted
	ret nz
	jr .faint_loop

.Function
	call HasEnemyFainted
	jr nz, .EnemyNotFainted
	call HandleEnemyMonFaint
	ld a, [wBattleEnded]
	and a
	jr nz, .BattleIsOver

.EnemyNotFainted:
	call HasPlayerFainted
	jr nz, .BattleContinues
	call HandlePlayerMonFaint
	ld a, [wBattleEnded]
	and a
	jr nz, .BattleIsOver

.BattleContinues:
	and a
	ret

.BattleIsOver:
	scf
	ret

HandleBerserkGene:
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .reverse

	call .player
	jr .enemy

.reverse
	call .enemy
	; fallthrough

.player
	call SetPlayerTurn
	ld de, wPartyMon1Item
	ld a, [wCurBattleMon]
	ld b, a
	jr .go

.enemy
	call SetEnemyTurn
	ld de, wOTPartyMon1Item
	ld a, [wCurOTMon]
	ld b, a
	; fallthrough

.go
	push de
	push bc
	farcall GetUserItem
	ld a, [hl]
	ld [wNamedObjectIndex], a
	sub BERSERK_GENE
	pop bc
	pop de
	ret nz

	ld [hl], a

	ld h, d
	ld l, e
	ld a, b
	call GetPartyLocation
	xor a
	ld [hl], a
; BUG: Berserk Gene's confusion lasts for 256 turns or the previous Pokémon's confusion count (see docs/bugs_and_glitches.md)
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	push af
	set SUBSTATUS_CONFUSED, [hl]
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVarAddr
	push hl
	push af
	xor a
	ld [hl], a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	farcall BattleCommand_AttackUp2
	pop af
	pop hl
	ld [hl], a
	call GetItemName
	ld hl, BattleText_UsersStringBuffer1Activated
	call StdBattleTextbox
	farcall BattleCommand_StatUpMessage
	pop af
	bit SUBSTATUS_CONFUSED, a
	ret nz
	xor a
	ld [wNumHits], a
	ld de, ANIM_CONFUSED
	call Call_PlayBattleAnim_OnlyIfVisible
	call SwitchTurn
	ld hl, BecameConfusedText
	jmp StdBattleTextbox

EnemyTriesToFlee:
	ld a, [wLinkMode]
	and a
	jr z, .not_linked
	ld a, [wBattleAction]
	cp BATTLEACTION_FORFEIT
	jr z, .forfeit

.not_linked
	and a
	ret

.forfeit
	call WildFled_EnemyFled_LinkBattleCanceled
	scf
	ret

DetermineMoveOrder:
	ld a, [wLinkMode]
	and a
	jr z, .use_move
	ld a, [wBattleAction]
	cp BATTLEACTION_STRUGGLE
	jr z, .use_move
	cp BATTLEACTION_SKIPTURN
	jr z, .use_move
	sub BATTLEACTION_SWITCH1
	jr c, .use_move
	ld a, [wBattlePlayerAction]
	cp BATTLEPLAYERACTION_SWITCH
	jr nz, .switch
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr z, .player_2

	call BattleRandom
	cp 50 percent + 1
	jmp c, .player_first
	jmp .enemy_first

.player_2
	call BattleRandom
	cp 50 percent + 1
	jmp c, .enemy_first
	jmp .player_first

.switch
	farcall AI_Switch
	call SetEnemyTurn
	call SpikesDamage
	jmp .enemy_first

.use_move
	ld a, [wBattlePlayerAction]
	and a ; BATTLEPLAYERACTION_USEMOVE?
	jr nz, .player_first
	call CompareMovePriority
	jr z, .equal_priority
	jr c, .player_first ; player goes first
	jr .enemy_first

.equal_priority
	call SetPlayerTurn
	farcall GetUserItem
	push bc
	farcall GetOpponentItem
	pop de
	ld a, d
	cp HELD_QUICK_CLAW
	jr nz, .player_no_quick_claw
	ld a, b
	cp HELD_QUICK_CLAW
	jr z, .both_have_quick_claw
	call BattleRandom
	cp e
	jr nc, .speed_check
	jr .player_first

.player_no_quick_claw
	ld a, b
	cp HELD_QUICK_CLAW
	jr nz, .speed_check
	call BattleRandom
	cp c
	jr nc, .speed_check
	jr .enemy_first

.both_have_quick_claw
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr z, .player_2b
	call BattleRandom
	cp c
	jr c, .enemy_first
	call BattleRandom
	cp e
	jr c, .player_first
	jr .speed_check

.player_2b
	call BattleRandom
	cp e
	jr c, .player_first
	call BattleRandom
	cp c
	jr c, .enemy_first
.speed_check
	ld de, wBattleMonSpeed
	ld hl, wEnemyMonSpeed
	ld c, 2
	call CompareBytes
	jr z, .speed_tie
	jr nc, .player_first
	jr .enemy_first

.speed_tie
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr z, .player_2c
	call BattleRandom
	cp 50 percent + 1
	jr c, .player_first
	jr .enemy_first

.player_2c
	call BattleRandom
	cp 50 percent + 1
	jr c, .enemy_first
.player_first
	scf
	ret

.enemy_first
	and a
	ret

CheckContestBattleOver:
	ld a, [wBattleType]
	cp BATTLETYPE_CONTEST
	jr nz, .contest_not_over
	ld a, [wParkBallsRemaining]
	and a
	jr nz, .contest_not_over
	ld a, [wBattleResult]
	and BATTLERESULT_BITMASK
	add DRAW
	ld [wBattleResult], a
	scf
	ret

.contest_not_over
	and a
	ret

CheckPlayerLockedIn:
	ld a, [wPlayerSubStatus4]
	and 1 << SUBSTATUS_RECHARGE
	jr nz, .quit

	ld hl, wEnemySubStatus3
	res SUBSTATUS_FLINCHED, [hl]
	ld hl, wPlayerSubStatus3
	res SUBSTATUS_FLINCHED, [hl]

	ld a, [hl]
	and 1 << SUBSTATUS_CHARGED | 1 << SUBSTATUS_RAMPAGE
	jr nz, .quit

	ld hl, wPlayerSubStatus1
	bit SUBSTATUS_ROLLOUT, [hl]
	jr nz, .quit

	and a
	ret

.quit
	scf
	ret

ParsePlayerAction:
	call CheckPlayerLockedIn
	jr c, .locked_in
	ld hl, wPlayerSubStatus5
	bit SUBSTATUS_ENCORED, [hl]
	jr z, .not_encored
	ld a, [wLastPlayerMove]
	ld [wCurPlayerMove], a
	jr .encored

.not_encored
	ld a, [wBattlePlayerAction]
	cp BATTLEPLAYERACTION_SWITCH
	jr z, .reset_rage
	and a
	jr nz, .reset_bide
	ld a, [wPlayerSubStatus3]
	and 1 << SUBSTATUS_BIDE
	jr nz, .locked_in
	xor a
	ld [wMoveSelectionMenuType], a
	inc a ; POUND
	ld [wFXAnimID], a
	call MoveSelectionScreen
	push af
	call SafeLoadTempTilemapToTilemap
	ld b, SCGB_BATTLE_COLORS
	call GetSGBLayout
	ld a, [wCurPlayerMove]
	cp STRUGGLE
	call nz, PlayClickSFX

	ld a, $1
	ldh [hBGMapMode], a
	pop af
	ret nz

.encored
	call SetPlayerTurn
	farcall UpdateMoveData
	xor a
	ld [wPlayerCharging], a
	ld a, [wPlayerMoveStruct + MOVE_EFFECT]
	cp EFFECT_FURY_CUTTER
	jr z, .continue_fury_cutter
	xor a
	ld [wPlayerFuryCutterCount], a

.continue_fury_cutter
	ld a, [wPlayerMoveStruct + MOVE_EFFECT]
	cp EFFECT_RAGE
	jr z, .continue_rage
	ld hl, wPlayerSubStatus4
	res SUBSTATUS_RAGE, [hl]
	xor a
	ld [wPlayerRageCounter], a

.continue_rage
	ld a, [wPlayerMoveStruct + MOVE_EFFECT]
	cp EFFECT_PROTECT
	jr z, .continue_protect
	cp EFFECT_ENDURE
	jr z, .continue_protect
	xor a
	ld [wPlayerProtectCount], a
	jr .continue_protect

.reset_bide
	ld hl, wPlayerSubStatus3
	res SUBSTATUS_BIDE, [hl]

.locked_in
	xor a
	ld [wPlayerFuryCutterCount], a
	ld [wPlayerProtectCount], a
	ld [wPlayerRageCounter], a
	ld hl, wPlayerSubStatus4
	res SUBSTATUS_RAGE, [hl]

.continue_protect
	call ParseEnemyAction
	xor a
	ret

.reset_rage
	xor a
	ld [wPlayerFuryCutterCount], a
	ld [wPlayerProtectCount], a
	ld [wPlayerRageCounter], a
	ld hl, wPlayerSubStatus4
	res SUBSTATUS_RAGE, [hl]
	xor a
	ret

HandleEncore:
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .player_1
	call .do_player
	jr .do_enemy

.player_1
	call .do_enemy
.do_player
	ld hl, wPlayerSubStatus5
	bit SUBSTATUS_ENCORED, [hl]
	ret z
	ld hl, wPlayerEncoreCount
	dec [hl]
	jr z, .end_player_encore
	ld hl, wBattleMonPP
	ld a, [wCurMoveNum]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	and PP_MASK
	ret nz

.end_player_encore
	ld hl, wPlayerSubStatus5
	res SUBSTATUS_ENCORED, [hl]
	call SetEnemyTurn
	ld hl, BattleText_TargetsEncoreEnded
	jmp StdBattleTextbox

.do_enemy
	ld hl, wEnemySubStatus5
	bit SUBSTATUS_ENCORED, [hl]
	ret z
	ld hl, wEnemyEncoreCount
	dec [hl]
	jr z, .end_enemy_encore
	ld hl, wEnemyMonPP
	ld a, [wCurEnemyMoveNum]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	and PP_MASK
	ret nz

.end_enemy_encore
	ld hl, wEnemySubStatus5
	res SUBSTATUS_ENCORED, [hl]
	call SetPlayerTurn
	ld hl, BattleText_TargetsEncoreEnded
	jmp StdBattleTextbox

TryEnemyFlee:
	ld a, [wBattleMode]
	dec a
	jr nz, .Stay

	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_CANT_RUN, a
	jr nz, .Stay

	ld a, [wEnemyWrapCount]
	and a
	jr nz, .Stay

	ld a, [wEnemyMonStatus]
	and 1 << FRZ | SLP_MASK
	jr nz, .Stay

	ld a, [wTempEnemyMonSpecies]
	ld hl, AlwaysFleeMons
	call IsInByteArray
	jr c, .Flee

	call BattleRandom
	ld b, a
	cp 50 percent + 1
	jr nc, .Stay

	push bc
	ld a, [wTempEnemyMonSpecies]
	ld hl, OftenFleeMons
	call IsInByteArray
	pop bc
	jr c, .Flee

	ld a, b
	cp 10 percent + 1
	jr nc, .Stay

	ld a, [wTempEnemyMonSpecies]
	ld hl, SometimesFleeMons
	call IsInByteArray
	jr c, .Flee

.Stay:
	and a
	ret

.Flee:
	scf
	ret

INCLUDE "data/wild/flee_mons.asm"

CompareMovePriority:
; Compare the priority of the player and enemy's moves.
; Return carry if the player goes first, or z if they match.

	ld a, [wCurPlayerMove]
	call GetMovePriority
	ld b, a
	push bc
	ld a, [wCurEnemyMove]
	call GetMovePriority
	pop bc
	cp b
	ret

GetMovePriority:
; Return the priority (0-3) of move a.

	ld b, a

	; Vital Throw goes last.
	cp VITAL_THROW
	ld a, 0	; no-optimize a = 0
	ret z

	call GetMoveEffect
	ld hl, MoveEffectPriorities
.loop
	ld a, [hli]
	cp b
	jr z, .done
	inc hl
	cp -1
	jr nz, .loop

	ld a, BASE_PRIORITY
	ret

.done
	ld a, [hl]
	ret

INCLUDE "data/moves/effects_priorities.asm"

GetMoveEffect:
	ld a, b
	ld hl, Moves + MOVE_EFFECT
	call GetMoveProperty
	ld b, a
	ret

Battle_EnemyFirst:
	call LoadTilemapToTempTilemap
	call TryEnemyFlee
	jmp c, WildFled_EnemyFled_LinkBattleCanceled
	call SetEnemyTurn
	ld a, $1
	ld [wEnemyGoesFirst], a
	farcall AI_SwitchOrTryItem
	jr c, .switch_item
	call EnemyTurn_EndOpponentProtectEndureDestinyBond
	ld a, [wForcedSwitch]
	and a
	ret nz
	call HasPlayerFainted
	jmp z, HandlePlayerMonFaint
	call HasEnemyFainted
	jmp z, HandleEnemyMonFaint

.switch_item
	call SetEnemyTurn
	call ResidualDamage
	jmp z, HandleEnemyMonFaint
	call RefreshBattleHuds
	call PlayerTurn_EndOpponentProtectEndureDestinyBond
	ld a, [wForcedSwitch]
	and a
	ret nz
	call HasEnemyFainted
	jmp z, HandleEnemyMonFaint
	call HasPlayerFainted
	jmp z, HandlePlayerMonFaint
	call SetPlayerTurn
	call ResidualDamage
	jmp z, HandlePlayerMonFaint
	call RefreshBattleHuds
	xor a ; BATTLEPLAYERACTION_USEMOVE
	ld [wBattlePlayerAction], a
	ret

Battle_PlayerFirst:
	xor a
	ld [wEnemyGoesFirst], a
	call SetEnemyTurn
	farcall AI_SwitchOrTryItem
	push af
	call PlayerTurn_EndOpponentProtectEndureDestinyBond
	pop bc
	ld a, [wForcedSwitch]
	and a
	ret nz
	call HasEnemyFainted
	jmp z, HandleEnemyMonFaint
	call HasPlayerFainted
	jmp z, HandlePlayerMonFaint
	push bc
	call SetPlayerTurn
	call ResidualDamage
	pop bc
	jmp z, HandlePlayerMonFaint
	push bc
	call RefreshBattleHuds
	pop af
	jr c, .switched_or_used_item
	call LoadTilemapToTempTilemap
	call TryEnemyFlee
	jmp c, WildFled_EnemyFled_LinkBattleCanceled
	call EnemyTurn_EndOpponentProtectEndureDestinyBond
	ld a, [wForcedSwitch]
	and a
	ret nz
	call HasPlayerFainted
	jmp z, HandlePlayerMonFaint
	call HasEnemyFainted
	jmp z, HandleEnemyMonFaint

.switched_or_used_item
	call SetEnemyTurn
	call ResidualDamage
	jmp z, HandleEnemyMonFaint
	call RefreshBattleHuds
	xor a ; BATTLEPLAYERACTION_USEMOVE
	ld [wBattlePlayerAction], a
	ret

PlayerTurn_EndOpponentProtectEndureDestinyBond:
	call SetPlayerTurn
	call EndUserDestinyBond
	farcall DoPlayerTurn
	jr EndOpponentProtectEndureDestinyBond

EnemyTurn_EndOpponentProtectEndureDestinyBond:
	call SetEnemyTurn
	call EndUserDestinyBond
	farcall DoEnemyTurn

EndOpponentProtectEndureDestinyBond:
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVarAddr
	res SUBSTATUS_PROTECT, [hl]
	res SUBSTATUS_ENDURE, [hl]
	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVarAddr
	res SUBSTATUS_DESTINY_BOND, [hl]
	ret

EndUserDestinyBond:
	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVarAddr
	res SUBSTATUS_DESTINY_BOND, [hl]
	ret

CheckEnemyTrapped:
	call SetEnemyTurn
	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_CANT_RUN, a
	jr nz, .SetTrapped
	ld a, [wEnemyWrapCount]
.SetTrapped
	ld [wEnemyIsTrapped], a
	jmp SetPlayerTurn

HasUserFainted:
	ldh a, [hBattleTurn]
	and a
	jr z, HasPlayerFainted
HasEnemyFainted:
	ld hl, wEnemyMonHP
	jr CheckIfHPIsZero

HasPlayerFainted:
	ld hl, wBattleMonHP

CheckIfHPIsZero:
	ld a, [hli]
	or [hl]
	ret

ResidualDamage:
; Return z if the user fainted before
; or as a result of residual damage.
; For Sandstorm damage, see HandleWeather.

	call HasUserFainted
	ret z

	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and 1 << PSN | 1 << BRN
	jr z, .did_psn_brn

	ld hl, HurtByPoisonText
	ld de, ANIM_PSN
	and 1 << BRN
	jr z, .got_anim
	ld hl, HurtByBurnText
	ld de, ANIM_BRN
.got_anim

	push de
	call StdBattleTextbox
	pop de

	xor a
	ld [wNumHits], a
	call Call_PlayBattleAnim_OnlyIfVisible
	call GetEighthMaxHP
	ld de, wPlayerToxicCount
	ldh a, [hBattleTurn]
	and a
	jr z, .check_toxic
	ld de, wEnemyToxicCount
.check_toxic

	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVar
	bit SUBSTATUS_TOXIC, a
	jr z, .did_toxic
	call GetSixteenthMaxHP
	ld a, [de]
	inc a
	ld [de], a
	ld hl, 0
.add
	add hl, bc
	dec a
	jr nz, .add
	ld b, h
	ld c, l
.did_toxic

	call SubtractHPFromUser
.did_psn_brn

	call HasUserFainted
	jmp z, .fainted

	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	bit SUBSTATUS_LEECH_SEED, [hl]
	jr z, .not_seeded

	call SwitchTurn
	xor a
	ld [wNumHits], a
	ld de, ANIM_SAP
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	call z, Call_PlayBattleAnim_OnlyIfVisible
	call SwitchTurn

	call GetEighthMaxHP
	call SubtractHPFromUser
	ld a, $1
	ldh [hBGMapMode], a
	call RestoreHP
	ld hl, LeechSeedSapsText
	call StdBattleTextbox
.not_seeded

	call HasUserFainted
	jr z, .fainted

	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	bit SUBSTATUS_NIGHTMARE, [hl]
	jr z, .not_nightmare
	xor a
	ld [wNumHits], a
	ld de, ANIM_IN_NIGHTMARE
	call Call_PlayBattleAnim_OnlyIfVisible
	call GetQuarterMaxHP
	call SubtractHPFromUser
	ld hl, HasANightmareText
	call StdBattleTextbox
.not_nightmare

	call HasUserFainted
	jr z, .fainted

	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	bit SUBSTATUS_CURSE, [hl]
	jr z, .not_cursed

	xor a
	ld [wNumHits], a
	ld de, ANIM_IN_NIGHTMARE
	call Call_PlayBattleAnim_OnlyIfVisible
	call GetQuarterMaxHP
	call SubtractHPFromUser
	ld hl, HurtByCurseText
	call StdBattleTextbox

.not_cursed
	ld hl, wBattleMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, .check_fainted
	ld hl, wEnemyMonHP

.check_fainted
	ld a, [hli]
	or [hl]
	ret nz

.fainted
	call RefreshBattleHuds
	ld c, 15
	call DelayFrames
	xor a
	ret

HandlePerishSong:
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .EnemyFirst
	call SetPlayerTurn
	call .do_it
	call SetEnemyTurn
	jr .do_it

.EnemyFirst:
	call SetEnemyTurn
	call .do_it
	call SetPlayerTurn

.do_it
	ld hl, wPlayerPerishCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got_count
	ld hl, wEnemyPerishCount

.got_count
	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVar
	bit SUBSTATUS_PERISH, a
	ret z
	dec [hl]
	ld a, [hl]
	ld [wTextDecimalByte], a
	push af
	ld hl, PerishCountText
	call StdBattleTextbox
	pop af
	ret nz
	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	res SUBSTATUS_PERISH, [hl]
	ldh a, [hBattleTurn]
	and a
	jr nz, .kill_enemy
	ld hl, wBattleMonHP
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, wPartyMon1HP
	ld a, [wCurBattleMon]
	call GetPartyLocation
	xor a
	ld [hli], a
	ld [hl], a
	ret

.kill_enemy
	ld hl, wEnemyMonHP
	xor a
	ld [hli], a
	ld [hl], a
	ld a, [wBattleMode]
	dec a
	ret z
	ld hl, wOTPartyMon1HP
	ld a, [wCurOTMon]
	call GetPartyLocation
	xor a
	ld [hli], a
	ld [hl], a
	ret

HandleWrap:
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .EnemyFirst
	call SetPlayerTurn
	call .do_it
	call SetEnemyTurn
	jr .do_it

.EnemyFirst:
	call SetEnemyTurn
	call .do_it
	call SetPlayerTurn

.do_it
	ld hl, wPlayerWrapCount
	ld de, wPlayerTrappingMove
	ldh a, [hBattleTurn]
	and a
	jr z, .got_addrs
	ld hl, wEnemyWrapCount
	ld de, wEnemyTrappingMove

.got_addrs
	ld a, [hl]
	and a
	ret z

	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	ret nz

	ld a, [de]
	ld [wNamedObjectIndex], a
	ld [wFXAnimID], a
	call GetMoveName
	dec [hl]
	jr z, .release_from_bounds

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	jr nz, .skip_anim

	call SwitchTurn
	xor a
	ld [wNumHits], a
	ld [wFXAnimID + 1], a
	predef PlayBattleAnim
	call SwitchTurn

.skip_anim
	call GetSixteenthMaxHP
	call SubtractHPFromUser
	ld hl, BattleText_UsersHurtByStringBuffer1
	jr .print_text

.release_from_bounds
	ld hl, BattleText_UserWasReleasedFromStringBuffer1

.print_text
	jmp StdBattleTextbox

HandleLeftovers:
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .DoEnemyFirst
	call SetPlayerTurn
	call .do_it
	call SetEnemyTurn
	jr .do_it

.DoEnemyFirst:
	call SetEnemyTurn
	call .do_it
	call SetPlayerTurn
.do_it

	farcall GetUserItem
	ld a, [hl]
	ld [wNamedObjectIndex], a
	call GetItemName
	ld a, b
	cp HELD_LEFTOVERS
	ret nz

	ld hl, wBattleMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, wEnemyMonHP

.got_hp
; Don't restore if we're already at max HP
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	cp b
	jr nz, .restore
	ld a, [hl]
	cp c
	ret z

.restore
	call GetSixteenthMaxHP
	call SwitchTurn
	call RestoreHP
	ld hl, BattleText_TargetRecoveredWithItem
	jmp StdBattleTextbox

HandleSpeedBoost:
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .DoEnemyFirst
	call SetPlayerTurn
	call .do_it
	call SetEnemyTurn
	jr .do_it

.DoEnemyFirst:
	call SetEnemyTurn
	call .do_it
	call SetPlayerTurn
.do_it

	farcall GetUserItem
	ld a, [hl]
	ld [wNamedObjectIndex], a
	call GetItemName
	ld a, b
	cp HELD_SPEED_BOOST
	ret nz
	ld a, [wBattleMonSpecies]
	cp YANMA
	ret nz

	ld a, 1
	ld [wStatItem], a
	ld b, SPEED
	farcall RaiseStat
	ld a, [wFailedMessage]
	and a
	ret nz
	call SwitchTurn
	ld hl, BattleText_TargetRaisedSpeed
	jmp StdBattleTextbox

HandleMysteryberry:
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .DoEnemyFirst
	call SetPlayerTurn
	call .do_it
	call SetEnemyTurn
	jr .do_it

.DoEnemyFirst:
	call SetEnemyTurn
	call .do_it
	call SetPlayerTurn

.do_it
	farcall GetUserItem
	ld a, b
	cp HELD_RESTORE_PP
	ret nz
	ld hl, wPartyMon1PP
	ld a, [wCurBattleMon]
	call GetPartyLocation
	ld d, h
	ld e, l
	ld hl, wPartyMon1Moves
	ld a, [wCurBattleMon]
	call GetPartyLocation
	ldh a, [hBattleTurn]
	and a
	jr z, .wild
	ld de, wWildMonPP
	ld hl, wWildMonMoves
	ld a, [wBattleMode]
	dec a
	jr z, .wild
	ld hl, wOTPartyMon1PP
	ld a, [wCurOTMon]
	call GetPartyLocation
	ld d, h
	ld e, l
	ld hl, wOTPartyMon1Moves
	ld a, [wCurOTMon]
	call GetPartyLocation

.wild
	ld c, $0
.loop
	ld a, [hl]
	and a
	ret z
	ld a, [de]
	and PP_MASK
	jr z, .restore
	inc hl
	inc de
	inc c
	ld a, c
	cp NUM_MOVES
	jr nz, .loop
	ret

.restore
	; lousy hack
	ld a, [hl]
	cp SKETCH
	ld b, 1
	jr z, .sketch
	ld b, 5
.sketch
	ld a, [de]
	add b
	ld [de], a
	push bc
	push bc
	ld a, [hl]
	ld [wTempByteValue], a
	ld de, wBattleMonMoves - 1
	ld hl, wBattleMonPP
	ldh a, [hBattleTurn]
	and a
	jr z, .player_pp
	ld de, wEnemyMonMoves - 1
	ld hl, wEnemyMonPP
.player_pp
	inc de
	pop bc
	ld b, 0
	add hl, bc
	push hl
	ld h, d
	ld l, e
	add hl, bc
	pop de
	pop bc

	ld a, [wTempByteValue]
	cp [hl]
	jr nz, .skip_checks
	ldh a, [hBattleTurn]
	and a
	ld a, [wPlayerSubStatus5]
	jr z, .check_transform
	ld a, [wEnemySubStatus5]
.check_transform
	bit SUBSTATUS_TRANSFORMED, a
	jr nz, .skip_checks
	ld a, [de]
	add b
	ld [de], a
.skip_checks
	farcall GetUserItem
	ld a, [hl]
	ld [wNamedObjectIndex], a
	xor a
	ld [hl], a
	call GetPartymonItem
	ldh a, [hBattleTurn]
	and a
	jr z, .consume_item
	ld a, [wBattleMode]
	dec a
	jr z, .skip_consumption
	call GetOTPartymonItem

.consume_item
	xor a
	ld [hl], a

.skip_consumption
	call GetItemName
	call SwitchTurn
	call ItemRecoveryAnim
	call SwitchTurn
	ld hl, BattleText_UserRecoveredPPUsing
	jmp StdBattleTextbox

HandleFutureSight:
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .enemy_first
	call SetPlayerTurn
	call .do_it
	call SetEnemyTurn
	jr .do_it

.enemy_first
	call SetEnemyTurn
	call .do_it
	call SetPlayerTurn

.do_it
	ld hl, wPlayerFutureSightCount
	ldh a, [hBattleTurn]
	and a
	jr z, .okay
	ld hl, wEnemyFutureSightCount

.okay
	ld a, [hl]
	and a
	ret z
	dec a
	ld [hl], a
	cp $1
	ret nz

	ld hl, BattleText_TargetWasHitByFutureSight
	call StdBattleTextbox

	ld a, BATTLE_VARS_MOVE
	call GetBattleVarAddr
	push af
	ld [hl], FUTURE_SIGHT

	farcall UpdateMoveData
	xor a
	ld [wAttackMissed], a
	ld a, EFFECTIVE
	ld [wTypeModifier], a
	farcall DoMove
	xor a
	ld [wCurDamage], a
	ld [wCurDamage + 1], a

	ld a, BATTLE_VARS_MOVE
	call GetBattleVarAddr
	pop af
	ld [hl], a

	call UpdateBattleMonInParty
	jmp UpdateEnemyMonInParty

HandleDefrost:
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .enemy_first
	call .do_player_turn
	jr .do_enemy_turn

.enemy_first
	call .do_enemy_turn
.do_player_turn
	ld a, [wBattleMonStatus]
	bit FRZ, a
	ret z

	ld a, [wPlayerJustGotFrozen]
	and a
	ret nz

	call BattleRandom
	cp 10 percent
	ret nc
	xor a
	ld [wBattleMonStatus], a
	ld a, [wCurBattleMon]
	ld hl, wPartyMon1Status
	call GetPartyLocation
	ld [hl], 0
	call UpdateBattleHuds
	call SetEnemyTurn
	ld hl, DefrostedOpponentText
	jmp StdBattleTextbox

.do_enemy_turn
	ld a, [wEnemyMonStatus]
	bit FRZ, a
	ret z
	ld a, [wEnemyJustGotFrozen]
	and a
	ret nz
	call BattleRandom
	cp 10 percent
	ret nc
	xor a
	ld [wEnemyMonStatus], a

	ld a, [wBattleMode]
	dec a
	jr z, .wild
	ld a, [wCurOTMon]
	ld hl, wOTPartyMon1Status
	call GetPartyLocation
	ld [hl], 0
.wild

	call UpdateBattleHuds
	call SetPlayerTurn
	ld hl, DefrostedOpponentText
	jmp StdBattleTextbox

HandleSafeguard:
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .player1
	call .CheckPlayer
	jr .CheckEnemy

.player1
	call .CheckEnemy
.CheckPlayer:
	ld a, [wPlayerScreens]
	bit SCREENS_SAFEGUARD, a
	ret z
	ld hl, wPlayerSafeguardCount
	dec [hl]
	ret nz
	res SCREENS_SAFEGUARD, a
	ld [wPlayerScreens], a
	xor a
	jr .print

.CheckEnemy:
	ld a, [wEnemyScreens]
	bit SCREENS_SAFEGUARD, a
	ret z
	ld hl, wEnemySafeguardCount
	dec [hl]
	ret nz
	res SCREENS_SAFEGUARD, a
	ld [wEnemyScreens], a
	ld a, $1

.print
	ldh [hBattleTurn], a
	ld hl, BattleText_SafeguardFaded
	jmp StdBattleTextbox

HandleScreens:
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .Both
	call .CheckPlayer
	jr .CheckEnemy

.Both:
	call .CheckEnemy

.CheckPlayer:
	call SetPlayerTurn
	ld de, .Your
	call .Copy
	ld hl, wPlayerScreens
	ld de, wPlayerLightScreenCount
	jr .TickScreens

.CheckEnemy:
	call SetEnemyTurn
	ld de, .Enemy
	call .Copy
	ld hl, wEnemyScreens
	ld de, wEnemyLightScreenCount

.TickScreens:
	bit SCREENS_LIGHT_SCREEN, [hl]
	call nz, .LightScreenTick
	bit SCREENS_REFLECT, [hl]
	jr nz, .ReflectTick
	ret

.Copy:
	ld hl, wStringBuffer1
	jmp CopyName2

.Your:
	db "Your@"
.Enemy:
	db "Enemy@"

.LightScreenTick:
	ld a, [de]
	dec a
	ld [de], a
	ret nz
	res SCREENS_LIGHT_SCREEN, [hl]
	push hl
	push de
	ld hl, BattleText_MonsLightScreenFell
	call StdBattleTextbox
	pop de
	pop hl
	ret

.ReflectTick:
	inc de
	ld a, [de]
	dec a
	ld [de], a
	ret nz
	res SCREENS_REFLECT, [hl]
	ld hl, BattleText_MonsReflectFaded
	jmp StdBattleTextbox

HandleWeather:
	ld a, [wBattleWeather]
	cp WEATHER_NONE
	ret z

	ld hl, wWeatherCount
	dec [hl]
	jr z, .ended

	ld hl, .WeatherMessages
	call .PrintWeatherMessage

	ld a, [wBattleWeather]
	cp WEATHER_SANDSTORM
	ret nz

	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .enemy_first

; player first
	call SetPlayerTurn
	call .SandstormDamage
	call SetEnemyTurn
	jr .SandstormDamage

.enemy_first
	call SetEnemyTurn
	call .SandstormDamage
	call SetPlayerTurn

.SandstormDamage:
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	bit SUBSTATUS_UNDERGROUND, a
	ret nz

	call CheckIfUserIsGroundType
	ret z
	call CheckIfUserIsRockType
	ret z
	call CheckIfUserIsSteelType
	ret z

	call SwitchTurn
	xor a
	ld [wNumHits], a
	ld de, ANIM_IN_SANDSTORM
	call Call_PlayBattleAnim
	call SwitchTurn
	call GetEighthMaxHP
	call SubtractHPFromUser

	ld hl, SandstormHitsText
	jmp StdBattleTextbox

.ended
	ld hl, .WeatherEndedMessages
	call .PrintWeatherMessage
	xor a
	ld [wBattleWeather], a
	ret

.PrintWeatherMessage:
	ld a, [wBattleWeather]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jmp StdBattleTextbox

.WeatherMessages:
; entries correspond to WEATHER_* constants
	dw BattleText_RainContinuesToFall
	dw BattleText_TheSunlightIsStrong
	dw BattleText_TheSandstormRages

.WeatherEndedMessages:
; entries correspond to WEATHER_* constants
	dw BattleText_TheRainStopped
	dw BattleText_TheSunlightFaded
	dw BattleText_TheSandstormSubsided

SubtractHPFromTarget:
	call SubtractHP
	jmp UpdateHPBar

SubtractHPFromUser:
; Subtract HP from mon
	call SubtractHP
	jmp UpdateHPBarBattleHuds

SubtractHP:
	ld hl, wBattleMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wEnemyMonHP
.ok
	inc hl
	ld a, [hl]
	ld [wHPBuffer2], a
	sub c
	ld [hld], a
	ld [wHPBuffer3], a
	ld a, [hl]
	ld [wHPBuffer2 + 1], a
	sbc b
	ld [hl], a
	ld [wHPBuffer3 + 1], a
	ret nc

	ld a, [wHPBuffer2]
	ld c, a
	ld a, [wHPBuffer2 + 1]
	ld b, a
	xor a
	ld [hli], a
	ld [hl], a
	ld [wHPBuffer3], a
	ld [wHPBuffer3 + 1], a
	ret

GetSixteenthMaxHP:
	call GetQuarterMaxHP
; quarter result
	srl c
	srl c
; at least 1
	ld a, c
	and a
	ret nz
	inc c
	ret

GetEighthMaxHP:
; output: bc
	call GetQuarterMaxHP
; assumes nothing can have 1024 or more hp
; halve result
	srl c
; at least 1
	ld a, c
	and a
	ret nz
	inc c
	ret

GetQuarterMaxHP:
; output: bc
	call GetMaxHP

; quarter result
	srl b
	rr c
	srl b
	rr c

; assumes nothing can have 1024 or more hp
; at least 1
	ld a, c
	and a
	ret nz
	inc c
	ret

GetHalfMaxHP:
; output: bc
	call GetMaxHP

; halve result
	srl b
	rr c

; at least 1
	ld a, c
	or b
	ret nz
	inc c
	ret

GetMaxHP:
; output: bc, wHPBuffer1

	ld hl, wBattleMonMaxHP
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wEnemyMonMaxHP
.ok
	ld a, [hli]
	ld [wHPBuffer1 + 1], a
	ld b, a

	ld a, [hl]
	ld [wHPBuffer1], a
	ld c, a
	ret

CheckUserHasEnoughHP:
	ld hl, wBattleMonHP + 1
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wEnemyMonHP + 1
.ok
	ld a, c
	sub [hl]
	dec hl
	ld a, b
	sbc [hl]
	ret

RestoreHP:
	ld hl, wEnemyMonMaxHP
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wBattleMonMaxHP
.ok
	ld a, [hli]
	ld [wHPBuffer1 + 1], a
	ld a, [hld]
	ld [wHPBuffer1], a
	dec hl
	ld a, [hl]
	ld [wHPBuffer2], a
	add c
	ld [hld], a
	ld [wHPBuffer3], a
	ld a, [hl]
	ld [wHPBuffer2 + 1], a
	adc b
	ld [hli], a
	ld [wHPBuffer3 + 1], a

	ld a, [wHPBuffer1]
	ld c, a
	ld a, [hld]
	sub c
	ld a, [wHPBuffer1 + 1]
	ld b, a
	ld a, [hl]
	sbc b
	jr c, .overflow
	ld a, b
	ld [hli], a
	ld [wHPBuffer3 + 1], a
	ld a, c
	ld [hl], a
	ld [wHPBuffer3], a
.overflow

	call SwitchTurn
	call UpdateHPBarBattleHuds
	jmp SwitchTurn

UpdateHPBarBattleHuds:
	call UpdateHPBar
	jmp UpdateBattleHuds

UpdateHPBar:
	hlcoord 10, 9
	ldh a, [hBattleTurn]
	and a
	ld a, 1
	jr z, .ok
	hlcoord 2, 2
	xor a
.ok
	push bc
	ld [wWhichHPBar], a
	predef AnimateHPBar
	pop bc
	ret

HandleEnemyMonFaint:
	call FaintEnemyPokemon
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	call z, FaintYourPokemon
	xor a
	ld [wWhichMonFaintedFirst], a
	call UpdateBattleStateAndExperienceAfterEnemyFaint
	call CheckPlayerPartyForFitMon
	ld a, d
	and a
	jmp z, LostBattle

	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	call nz, UpdatePlayerHUD

	ld a, $1
	ldh [hBGMapMode], a
	ld c, 60
	call DelayFrames

	ld a, [wBattleMode]
	dec a
	jr z, .battle_ended

	call CheckEnemyTrainerDefeated
	jmp z, WinTrainerBattle

	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	jr nz, .player_mon_not_fainted

	call AskUseNextPokemon
	jr nc, .dont_flee

.battle_ended
	ld a, 1
	ld [wBattleEnded], a
	ret

.dont_flee
	call ForcePlayerMonChoice

	ld a, BATTLEPLAYERACTION_USEITEM
	ld [wBattlePlayerAction], a
	call HandleEnemySwitch
	jmp z, WildFled_EnemyFled_LinkBattleCanceled
	jr DoubleSwitch

.player_mon_not_fainted
	ld a, BATTLEPLAYERACTION_USEITEM
	ld [wBattlePlayerAction], a
	call HandleEnemySwitch
	jmp z, WildFled_EnemyFled_LinkBattleCanceled
	xor a ; BATTLEPLAYERACTION_USEMOVE
	ld [wBattlePlayerAction], a
	ret

DoubleSwitch:
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .player_1
	call ClearSprites
	hlcoord 1, 0
	lb bc, 4, 10
	call ClearBox
	call PlayerPartyMonEntrance
	ld a, $1
	call EnemyPartyMonEntrance
	jr .done

.player_1
	ld a, [wCurPartyMon]
	push af
	ld a, $1
	call EnemyPartyMonEntrance
	call ClearSprites
	call LoadTilemapToTempTilemap
	pop af
	ld [wCurPartyMon], a
	call PlayerPartyMonEntrance

.done
	xor a ; BATTLEPLAYERACTION_USEMOVE
	ld [wBattlePlayerAction], a
	ret

UpdateBattleStateAndExperienceAfterEnemyFaint:
	call UpdateBattleMonInParty
	ld a, [wBattleMode]
	dec a
	jr z, .wild
	ld a, [wCurOTMon]
	ld hl, wOTPartyMon1HP
	call GetPartyLocation
	xor a
	ld [hli], a
	ld [hl], a

.wild
	ld hl, wPlayerSubStatus3
	res SUBSTATUS_IN_LOOP, [hl]
	xor a
	ld hl, wEnemyDamageTaken
	ld [hli], a
	ld [hl], a
	call NewEnemyMonStatus
	call BreakAttraction
	ld a, [wBattleMode]
	dec a
	jr nz, .trainer
	call StopDangerSound
	ld a, $1
	ld [wBattleLowHealthAlarm], a

.trainer
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	jr nz, .player_mon_did_not_faint
	ld a, [wWhichMonFaintedFirst]
	and a
	call z, UpdateFaintedPlayerMon

.player_mon_did_not_faint
	call CheckPlayerPartyForFitMon
	ld a, d
	and a
	ret z
	ld a, [wBattleMode]
	dec a
	call z, PlayVictoryMusic
	call EmptyBattleTextbox
	call LoadTilemapToTempTilemap
	ld a, [wBattleResult]
	and BATTLERESULT_BITMASK
	ld [wBattleResult], a ; WIN
ApplyExperienceAfterEnemyCaught:
	; Preserve bits of non-fainted participants
	xor a
	ld[wExpShare], a
	ld[wExpShareText], a
	ld a, [wBattleParticipantsNotFainted]
	ld d, a
	push de
	call GiveExperiencePoints
	pop de
	; If Exp. Share is ON, give 50% EXP to non-participants
	ld a, 1
	ld[wExpShare], a
	ld a, [wExpShareToggle]
	and a
	ret z
	ld hl, wEnemyMonBaseExp
	srl [hl]
	ld a, [wBattleParticipantsNotFainted]
	push af
	ld a, d
	xor %00111111
	ld [wBattleParticipantsNotFainted], a
	call GiveExperiencePoints
	pop af
	ld [wBattleParticipantsNotFainted], a
	ret

StopDangerSound:
	xor a
	ld [wLowHealthAlarm], a
	ret

FaintYourPokemon:
	call StopDangerSound
	call WaitSFX
	ld a, $f0
	ld [wCryTracks], a
	ld a, [wBattleMonSpecies]
	call PlayStereoCry
	call PlayerMonFaintedAnimation
	hlcoord 9, 7
	lb bc, 5, 11
	call ClearBox
	ld hl, BattleText_MonFainted
	jmp StdBattleTextbox

FaintEnemyPokemon:
	ld de, SFX_KINESIS
	call WaitPlaySFX
	call EnemyMonFaintedAnimation
	ld de, SFX_FAINT
	call PlaySFX
	hlcoord 1, 0
	lb bc, 4, 10
	call ClearBox
	ld hl, BattleText_EnemyMonFainted
	jmp StdBattleTextbox

CheckEnemyTrainerDefeated:
	ld a, [wOTPartyCount]
	ld b, a
	xor a
	ld hl, wOTPartyMon1HP
	ld de, PARTYMON_STRUCT_LENGTH

.loop
	or [hl]
	inc hl
	or [hl]
	dec hl
	add hl, de
	dec b
	jr nz, .loop

	and a
	ret

HandleEnemySwitch:
	ld hl, wEnemyHPPal
	ld e, HP_BAR_LENGTH_PX
	call UpdateHPPal
	call WaitBGMap
	farcall EnemySwitch_TrainerHud
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	ld a, $0 ; no-optimize a = 0
	jr nz, EnemyPartyMonEntrance
	inc a
	ret

EnemyPartyMonEntrance:
	push af
	xor a
	ld [wEnemySwitchMonIndex], a
	call NewEnemyMonStatus
	call ResetEnemyStatLevels
	call BreakAttraction
	pop af
	and a
	jr nz, .set
	call EnemySwitch
	jr .done_switch

.set
	call EnemySwitch_SetMode
.done_switch
	call ResetBattleParticipants
	call SetEnemyTurn
	call SpikesDamage
	xor a
	ld [wEnemyMoveStruct + MOVE_ANIM], a
	ld [wBattlePlayerAction], a
	inc a
	ret

WinTrainerBattle:
; Player won the battle
	call StopDangerSound
	ld a, $1
	ld [wBattleLowHealthAlarm], a
	ld [wBattleEnded], a
	ld a, [wLinkMode]
	and a
	ld a, b
	call z, PlayVictoryMusic
	farcall Battle_GetTrainerName
	ld hl, BattleText_EnemyWasDefeated
	call StdBattleTextbox

	ld a, [wLinkMode]
	and a
	ret nz

	ld a, [wInBattleTowerBattle]
	bit 0, a
	jr nz, .battle_tower

	call BattleWinSlideInEnemyTrainerFrontpic
	ld c, 40
	call DelayFrames

	ld a, [wBattleType]
	cp BATTLETYPE_CANLOSE
	jr nz, .skip_heal
	farcall HealParty

.skip_heal
	call PrintWinLossText
	jr .give_money

.battle_tower
	call BattleWinSlideInEnemyTrainerFrontpic
	ld c, 40
	call DelayFrames
	call EmptyBattleTextbox
	ld c, BATTLETOWERTEXT_LOSS_TEXT
	farcall BattleTowerText
	call WaitPressAorB_BlinkCursor
	ld hl, wPayDayMoney
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	ret nz
	call ClearTilemap
	jmp ClearBGPalettes

.give_money
	ld a, [wAmuletCoin]
	and a
	call nz, .DoubleReward
	call .CheckMaxedOutMomMoney
	push af
	ld a, FALSE
	jr nc, .okay
	ld a, [wMomSavingMoney]
	and MOM_SAVING_MONEY_MASK
	cp (1 << MOM_SAVING_SOME_MONEY_F) | (1 << MOM_SAVING_HALF_MONEY_F)
	jr nz, .okay
	inc a ; TRUE

.okay
	ld b, a
	ld c, 4
.loop
	ld a, b
	and a
	jr z, .loop2
	call .AddMoneyToMom
	dec c
	dec b
	jr .loop

.loop2
	ld a, c
	and a
	jr z, .done
	call .AddMoneyToWallet
	dec c
	jr .loop2

.done
	call .DoubleReward
	call .DoubleReward
	pop af
	jr nc, .KeepItAll
	ld a, [wMomSavingMoney]
	and MOM_SAVING_MONEY_MASK
	jr z, .KeepItAll
	ld hl, .SentToMomTexts
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jmp StdBattleTextbox

.KeepItAll:
	ld hl, GotMoneyForWinningText
	jmp StdBattleTextbox

.AddMoneyToMom:
	push bc
	ld hl, wBattleReward + 2
	ld de, wMomsMoney + 2
	call AddBattleMoneyToAccount
	pop bc
	ret

.AddMoneyToWallet:
	push bc
	ld hl, wBattleReward + 2
	ld de, wMoney + 2
	call AddBattleMoneyToAccount
	pop bc
	ret

.DoubleReward:
	ld hl, wBattleReward + 2
	sla [hl]
	dec hl
	rl [hl]
	dec hl
	rl [hl]
	ret nc
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

.SentToMomTexts:
; entries correspond to MOM_SAVING_* constants
	dw SentSomeToMomText
	dw SentHalfToMomText
	dw SentAllToMomText

.CheckMaxedOutMomMoney:
	ld hl, wMomsMoney + 2
	ld a, [hld]
	cp LOW(MAX_MONEY)
	ld a, [hld]
	sbc HIGH(MAX_MONEY) ; mid
	ld a, [hl]
	sbc HIGH(MAX_MONEY >> 8)
	ret

AddBattleMoneyToAccount:
	ld c, 3
	and a
	push de
	push hl
	push bc
	ld b, h
	ld c, l
	pop bc
	pop hl
.loop
	ld a, [de]
	adc [hl]
	ld [de], a
	dec de
	dec hl
	dec c
	jr nz, .loop
	pop hl
	ld a, [hld]
	cp LOW(MAX_MONEY)
	ld a, [hld]
	sbc HIGH(MAX_MONEY) ; mid
	ld a, [hl]
	sbc HIGH(MAX_MONEY >> 8)
	ret c
	ld a, HIGH(MAX_MONEY >> 8)
	ld [hli], a
	ld a, HIGH(MAX_MONEY) ; mid
	ld [hli], a
	ld [hl], LOW(MAX_MONEY)
	ret

PlayVictoryMusic:
	push de
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	ld de, MUSIC_WILD_VICTORY
	ld a, [wBattleMode]
	dec a
	jr nz, .trainer_victory
	ld hl, wPayDayMoney
	ld a, [hli]
	or [hl]
	jr nz, .play_music
	ld a, [wBattleParticipantsNotFainted]
	and a
	jr z, .lost
	jr .play_music

.trainer_victory
	ld de, MUSIC_GYM_VICTORY
	call IsGymLeader
	jr c, .play_music
	ld de, MUSIC_TRAINER_VICTORY

.play_music
	call PlayMusic

.lost
	pop de
	ret

IsKantoGymLeader:
	ld hl, KantoGymLeaders
	jr IsGymLeaderCommon

IsGymLeader:
	ld hl, GymLeaders
IsGymLeaderCommon:
	push de
	ld a, [wOtherTrainerClass]
	call IsInByteArray
	pop de
	ret

INCLUDE "data/trainers/leaders.asm"

HandlePlayerMonFaint:
	call FaintYourPokemon
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl]
	call z, FaintEnemyPokemon
	ld a, $1
	ld [wWhichMonFaintedFirst], a
	call UpdateFaintedPlayerMon
	call CheckPlayerPartyForFitMon
	ld a, d
	and a
	jmp z, LostBattle
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl]
	jr nz, .notfainted
	call UpdateBattleStateAndExperienceAfterEnemyFaint
	ld a, [wBattleMode]
	dec a
	jr z, .battle_ended
	call CheckEnemyTrainerDefeated
	jmp z, WinTrainerBattle

.notfainted
	call AskUseNextPokemon
	jr nc, .switch

.battle_ended
	ld a, $1
	ld [wBattleEnded], a
	ret

.switch
	call ForcePlayerMonChoice
	ld a, c
	and a
	ret nz
	ld a, BATTLEPLAYERACTION_USEITEM
	ld [wBattlePlayerAction], a
	call HandleEnemySwitch
	jmp z, WildFled_EnemyFled_LinkBattleCanceled
	jmp DoubleSwitch

UpdateFaintedPlayerMon:
	ld a, [wCurBattleMon]
	ld c, a
	ld hl, wBattleParticipantsNotFainted
	ld b, RESET_FLAG
	predef SmallFarFlagAction
	ld hl, wEnemySubStatus3
	res SUBSTATUS_IN_LOOP, [hl]
	xor a
	ld [wLowHealthAlarm], a
	ld hl, wPlayerDamageTaken
	ld [hli], a
	ld [hl], a
	ld [wBattleMonStatus], a
	call UpdateBattleMonInParty
	ld c, HAPPINESS_FAINTED
	; If TheirLevel > (YourLevel + 30), use a different parameter
	ld a, [wBattleMonLevel]
	add 30
	ld b, a
	ld a, [wEnemyMonLevel]
	cp b
	jr c, .got_param
	ld c, HAPPINESS_BEATENBYSTRONGFOE

.got_param
	ld a, [wCurBattleMon]
	ld [wCurPartyMon], a
	farcall ChangeHappiness
	ld a, [wBattleResult]
	and BATTLERESULT_BITMASK
	add LOSE
	ld [wBattleResult], a
	ld a, [wWhichMonFaintedFirst]
	and a
	ret

AskUseNextPokemon:
	call EmptyBattleTextbox
	call LoadTilemapToTempTilemap
; We don't need to be here if we're in a Trainer battle,
; as that decision is made for us.
	ld a, [wBattleMode]
	and a
	dec a
	ret nz

	ld hl, BattleText_UseNextMon
	call StdBattleTextbox
.loop
	lb bc, 1, 7
	call PlaceYesNoBox
	ld a, [wMenuCursorY]
	jr c, .pressed_b
	and a
	ret

.pressed_b
	ld a, [wMenuCursorY]
	cp $1 ; YES
	jr z, .loop
	ld hl, wPartyMon1Speed
	ld de, wEnemyMonSpeed
	jmp TryToRunAwayFromBattle

ForcePlayerMonChoice:
	call EmptyBattleTextbox
	call LoadStandardMenuHeader
	call SetUpBattlePartyMenu
	call ForcePickPartyMonInBattle
	xor a ; BATTLEPLAYERACTION_USEMOVE
	ld [wBattlePlayerAction], a
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl]
	jr nz, .send_out_pokemon

.send_out_pokemon
	call ClearSprites
	ld a, [wCurBattleMon]
	ld [wLastPlayerMon], a
	ld a, [wCurPartyMon]
	ld [wCurBattleMon], a
	call AddBattleParticipant
	call InitBattleMon
	call ResetPlayerStatLevels
	call ClearPalettes
	call DelayFrame
	call _LoadHPBar
	call CloseWindow
	call GetMemSGBLayout
	call SetDefaultBGPAndOBP
	call SendOutMonText
	call NewBattleMonStatus
	call BreakAttraction
	call SendOutPlayerMon
	call EmptyBattleTextbox
	call LoadTilemapToTempTilemap
	call SetPlayerTurn
	call SpikesDamage
	ld a, $1
	and a
	ld c, a
	ret

PlayerPartyMonEntrance:
	ld a, [wCurBattleMon]
	ld [wLastPlayerMon], a
	ld a, [wCurPartyMon]
	ld [wCurBattleMon], a
	call AddBattleParticipant
	call InitBattleMon
	call ResetPlayerStatLevels
	call SendOutMonText
	call NewBattleMonStatus
	call BreakAttraction
	call SendOutPlayerMon
	call EmptyBattleTextbox
	call LoadTilemapToTempTilemap
	call SetPlayerTurn
	jmp SpikesDamage

SetUpBattlePartyMenu:
	call ClearBGPalettes
SetUpBattlePartyMenu_Loop: ; switch to fullscreen menu?
	farcall LoadPartyMenuGFX
	farcall InitPartyMenuWithCancel
	farcall InitPartyMenuBGPal7
	farjp InitPartyMenuGFX

JumpToPartyMenuAndPrintText:
	farcall WritePartyMenuTilemap
	farcall PlacePartyMenuText
	call WaitBGMap
	call SetDefaultBGPAndOBP
	jmp DelayFrame

SelectBattleMon:
	farjp PartyMenuSelect

PickPartyMonInBattle:
.loop
	ld a, PARTYMENUACTION_SWITCH ; Which PKMN?
	ld [wPartyMenuActionText], a
	call JumpToPartyMenuAndPrintText
	call SelectBattleMon
	ret c
	call CheckIfCurPartyMonIsFitToFight
	jr z, .loop
	xor a
	ret

SwitchMonAlreadyOut:
	ld hl, wCurBattleMon
	ld a, [wCurPartyMon]
	cp [hl]
	jr nz, .notout

	ld hl, BattleText_MonIsAlreadyOut
	call StdBattleTextbox
	scf
	ret

.notout
	xor a
	ret

ForcePickPartyMonInBattle:
; Can't back out.

.pick
	call PickPartyMonInBattle
	ret nc

	ld de, SFX_WRONG
	call PlaySFX
	call WaitSFX
	jr .pick

PickSwitchMonInBattle:
.pick
	call PickPartyMonInBattle
	ret c
	call SwitchMonAlreadyOut
	jr c, .pick
	xor a
	ret

ForcePickSwitchMonInBattle:
; Can't back out.

.pick
	call ForcePickPartyMonInBattle
	call SwitchMonAlreadyOut
	jr c, .pick

	xor a
	ret

LostBattle:
	ld a, 1
	ld [wBattleEnded], a

	ld a, [wInBattleTowerBattle]
	bit 0, a
	jr nz, .battle_tower

	ld a, [wBattleType]
	cp BATTLETYPE_CANLOSE
	jr nz, .not_canlose

; Remove the enemy from the screen.
	hlcoord 0, 0
	lb bc, 8, 21
	call ClearBox
	call BattleWinSlideInEnemyTrainerFrontpic

	ld c, 40
	call DelayFrames

	jmp PrintWinLossText

.battle_tower
; Remove the enemy from the screen.
	hlcoord 0, 0
	lb bc, 8, 21
	call ClearBox
	call BattleWinSlideInEnemyTrainerFrontpic

	ld c, 40
	call DelayFrames

	call EmptyBattleTextbox
	ld c, BATTLETOWERTEXT_WIN_TEXT
	farcall BattleTowerText
	call WaitPressAorB_BlinkCursor
	call ClearTilemap
	jmp ClearBGPalettes

.not_canlose
	ld a, [wLinkMode]
	and a
	jr nz, .LostLinkBattle

; Grayscale
	ld b, SCGB_BATTLE_GRAYSCALE
	call GetSGBLayout
	call SetDefaultBGPAndOBP
	jr .end

.LostLinkBattle:
	call UpdateEnemyMonInParty
	call CheckEnemyTrainerDefeated
	jr nz, .not_tied
	ld hl, TiedAgainstText
	ld a, [wBattleResult]
	and BATTLERESULT_BITMASK
	add DRAW
	ld [wBattleResult], a
	jr .text

.not_tied
	ld hl, LostAgainstText

.text
	call StdBattleTextbox

.end
	scf
	ret

EnemyMonFaintedAnimation:
	hlcoord 12, 5
	decoord 12, 6
	jr MonFaintedAnimation

PlayerMonFaintedAnimation:
	hlcoord 1, 10
	decoord 1, 11

MonFaintedAnimation:
	ld a, [wJoypadDisable]
	push af
	set JOYPAD_DISABLE_MON_FAINT_F, a
	ld [wJoypadDisable], a

	ld b, 7

.OuterLoop:
	push bc
	push de
	push hl
	ld b, 6

.InnerLoop:
	push bc
	push hl
	push de
	ld bc, 7
	rst CopyBytes
	pop de
	pop hl
	ld bc, -SCREEN_WIDTH
	add hl, bc
	push hl
	ld h, d
	ld l, e
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	pop bc
	dec b
	jr nz, .InnerLoop

	ld bc, 20
	add hl, bc
	ld de, .Spaces
	rst PlaceString
	ld c, 2
	call DelayFrames
	pop hl
	pop de
	pop bc
	dec b
	jr nz, .OuterLoop

	pop af
	ld [wJoypadDisable], a
	ret

.Spaces:
	db "       @"

SlideBattlePicOut:
	ldh [hMapObjectIndex], a
	ld c, a
.loop
	push bc
	push hl
	ld b, $7
.loop2
	push hl
	call .DoFrame
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, .loop2
	ld c, 2
	call DelayFrames
	pop hl
	pop bc
	dec c
	jr nz, .loop
	ret

.DoFrame:
	ldh a, [hMapObjectIndex]
	ld c, a
	cp $8
	jr nz, .back
.forward
	ld a, [hli]
	ld [hld], a
	dec hl
	dec c
	jr nz, .forward
	ret

.back
	ld a, [hld]
	ld [hli], a
	inc hl
	dec c
	jr nz, .back
	ret

ForceEnemySwitch:
	call ResetEnemyBattleVars
	ld a, [wEnemySwitchMonIndex]
	dec a
	ld b, a
	call LoadEnemyMonToSwitchTo
	call ClearEnemyMonBox
	call NewEnemyMonStatus
	call ResetEnemyStatLevels
	call ShowSetEnemyMonAndSendOutAnimation
	call BreakAttraction
	jr ResetBattleParticipants

EnemySwitch:
EnemySwitch_SetMode:
	call ResetEnemyBattleVars
	call CheckWhetherSwitchmonIsPredetermined
	call nc, FindMonInOTPartyToSwitchIntoBattle
	; 'b' contains the PartyNr of the mon the AI will switch to
	call LoadEnemyMonToSwitchTo
	ld a, 1
	ld [wEnemyIsSwitching], a
	call ClearEnemyMonBox
	call ShowBattleTextEnemySentOut
	jmp ShowSetEnemyMonAndSendOutAnimation

CheckWhetherSwitchmonIsPredetermined:
; returns the enemy switchmon index in b, or
; returns carry if the index is not yet determined.
	ld a, [wLinkMode]
	and a
	jr z, .not_linked

	ld a, [wBattleAction]
	sub BATTLEACTION_SWITCH1
	ld b, a
	jr .return_carry

.not_linked
	ld a, [wEnemySwitchMonIndex]
	and a
	jr z, .check_wBattleHasJustStarted

	dec a
	ld b, a
	jr .return_carry

.check_wBattleHasJustStarted
	ld a, [wBattleHasJustStarted]
	and a
	ld b, 0
	jr nz, .return_carry

	and a
	ret

.return_carry
	scf
	ret

ResetEnemyBattleVars:
; and draw empty Textbox
	xor a
	ld [wLastPlayerCounterMove], a
	ld [wLastEnemyCounterMove], a
	ld [wLastEnemyMove], a
	ld [wCurEnemyMove], a
	dec a
	ld [wEnemyItemState], a
	xor a
	ld [wPlayerWrapCount], a
	hlcoord 18, 0
	ld a, 8
	call SlideBattlePicOut
	call EmptyBattleTextbox
	jmp LoadStandardMenuHeader

ResetBattleParticipants:
	xor a
	ld [wBattleParticipantsNotFainted], a
	ld [wBattleParticipantsIncludingFainted], a
AddBattleParticipant:
	ld a, [wCurBattleMon]
	ld c, a
	ld hl, wBattleParticipantsNotFainted
	ld b, SET_FLAG
	push bc
	predef SmallFarFlagAction
	pop bc
	ld hl, wBattleParticipantsIncludingFainted
	predef_jump SmallFarFlagAction

FindMonInOTPartyToSwitchIntoBattle:
	ld b, -1
	ld a, 1
	ld [wEnemyEffectivenessVsPlayerMons], a
	ld [wPlayerEffectivenessVsEnemyMons], a
.loop
	ld hl, wEnemyEffectivenessVsPlayerMons
	sla [hl]
	inc hl ; wPlayerEffectivenessVsEnemyMons
	sla [hl]
	inc b
	ld a, [wOTPartyCount]
	cp b
	jmp z, ScoreMonTypeMatchups
	ld a, [wCurOTMon]
	cp b
	jr z, .discourage
	ld hl, wOTPartyMon1HP
	push bc
	ld a, b
	call GetPartyLocation
	ld a, [hli]
	ld c, a
	ld a, [hl]
	or c
	pop bc
	jr z, .discourage
	call LookUpTheEffectivenessOfEveryMove
	call IsThePlayerMonTypesEffectiveAgainstOTMon
	jr .loop

.discourage
	ld hl, wPlayerEffectivenessVsEnemyMons
	set 0, [hl]
	jr .loop

LookUpTheEffectivenessOfEveryMove:
	push bc
	ld hl, wOTPartyMon1Moves
	ld a, b
	call GetPartyLocation
	pop bc
	ld e, NUM_MOVES + 1
.loop
	dec e
	ret z
	ld a, [hli]
	and a
	ret z
	push hl
	push de
	push bc
	ld hl, (Moves + MOVE_POWER) - MOVE_LENGTH
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	and a
	jr z, .pop_loop
	dec hl
	dec hl
	ld de, wEnemyMoveStruct
	ld a, BANK(Moves)
	call FarCopyBytes
	call SetEnemyTurn

	ld hl, wEnemyMoveStruct
	ld a, [hl]
	cp HIDDEN_POWER
	jr nz, .continue
	pop bc
	ld hl, wOTPartyMon1DVs
	ld a, b
	push bc
	call GetPartyLocation
	ld b, h
	ld c, l
	farcall HiddenPowerDamage
.continue
	farcall BattleCheckTypeMatchup
	pop bc
	pop de
	pop hl
	ld a, [wEnemyMoveStruct + MOVE_POWER]
	and a
	jr z, .loop
	ld a, [wTypeMatchup]
	cp EFFECTIVE + 1
	jr c, .loop
	ld hl, wEnemyEffectivenessVsPlayerMons
	set 0, [hl]
	ret

.pop_loop
	pop bc
	pop de
	pop hl
	jr .loop

IsThePlayerMonTypesEffectiveAgainstOTMon:
; Calculates the effectiveness of the types of the PlayerMon
; against the OTMon
	push bc
	ld hl, wOTPartyCount
	ld a, b
	inc a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld hl, (BaseData + BASE_TYPES) - BASE_DATA_SIZE
	ld bc, BASE_DATA_SIZE
	rst AddNTimes
	ld de, wEnemyMonType
	ld bc, BASE_CATCH_RATE - BASE_TYPES
	ld a, BANK(BaseData)
	call FarCopyBytes
	ld a, [wBattleMonType1]
	ld [wPlayerMoveStruct + MOVE_TYPE], a
	call SetPlayerTurn
	farcall BattleCheckTypeMatchup
	ld a, [wTypeMatchup]
	cp EFFECTIVE + 1
	jr nc, .super_effective
	ld a, [wBattleMonType2]
	ld [wPlayerMoveStruct + MOVE_TYPE], a
	farcall BattleCheckTypeMatchup
	ld a, [wTypeMatchup]
	cp EFFECTIVE + 1
	jr nc, .super_effective
	pop bc
	ret

.super_effective
	pop bc
	ld hl, wEnemyEffectivenessVsPlayerMons
	bit 0, [hl]
	jr nz, .reset
	inc hl ; wPlayerEffectivenessVsEnemyMons
	set 0, [hl]
	ret

.reset
	res 0, [hl]
	ret

ScoreMonTypeMatchups:
.loop1
	ld hl, wEnemyEffectivenessVsPlayerMons
	sla [hl]
	inc hl ; wPlayerEffectivenessVsEnemyMons
	sla [hl]
	jr nc, .loop1
	ld a, [wOTPartyCount]
	ld b, a
	ld c, [hl]
.loop2
	sla c
	jr nc, .okay
	dec b
	jr z, .loop5
	jr .loop2

.okay
	ld a, [wEnemyEffectivenessVsPlayerMons]
	and a
	jr z, .okay2
	ld b, -1
	ld c, a
.loop3
	inc b
	sla c
	jr nc, .loop3
	ret

.okay2
	ld b, -1
	ld a, [wPlayerEffectivenessVsEnemyMons]
	ld c, a
.loop4
	inc b
	sla c
	jr c, .loop4
	ret

.loop5
	ld a, [wOTPartyCount]
	ld b, a
	call BattleRandom
	and $7
	cp b
	jr nc, .loop5
	ld b, a
	ld a, [wCurOTMon]
	cp b
	jr z, .loop5
	ld hl, wOTPartyMon1HP
	push bc
	ld a, b
	call GetPartyLocation
	pop bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	or c
	jr z, .loop5
	ret

LoadEnemyMonToSwitchTo:
	; 'b' contains the PartyNr of the mon the AI will switch to
	ld a, b
	ld [wCurPartyMon], a
	ld hl, wOTPartyMon1Level
	call GetPartyLocation
	ld a, [hl]
	ld [wCurPartyLevel], a
	ld a, [wCurPartyMon]
	inc a
	ld hl, wOTPartyCount
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wTempEnemyMonSpecies], a
	ld [wCurPartySpecies], a
	call LoadEnemyMon

	ld a, [wCurPartySpecies]
	cp UNOWN
	jr nz, .skip_unown
	ld a, [wFirstUnownSeen]
	and a
	jr nz, .skip_unown
	ld hl, wEnemyMonDVs
	predef GetUnownLetter
	ld a, [wUnownLetter]
	ld [wFirstUnownSeen], a
.skip_unown

	ld hl, wEnemyMonHP
	ld a, [hli]
	ld [wEnemyHPAtTimeOfPlayerSwitch], a
	ld a, [hl]
	ld [wEnemyHPAtTimeOfPlayerSwitch + 1], a
	ret

ClearEnemyMonBox:
	xor a
	ldh [hBGMapMode], a
	call ExitMenu
	call ClearSprites
	hlcoord 1, 0
	lb bc, 4, 10
	call ClearBox
	call WaitBGMap
	jmp FinishBattleAnim

ShowBattleTextEnemySentOut:
	farcall Battle_GetTrainerName
	ld hl, BattleText_EnemySentOut
	call StdBattleTextbox
	jmp WaitBGMap

ShowSetEnemyMonAndSendOutAnimation:
	ld a, [wTempEnemyMonSpecies]
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetBaseData
	ld a, OTPARTYMON
	ld [wMonType], a
	predef CopyMonToTempMon
	call GetEnemyMonFrontpic

	xor a
	ld [wNumHits], a
	ld [wBattleAnimParam], a
	call SetEnemyTurn
	ld de, ANIM_SEND_OUT_MON
	call Call_PlayBattleAnim

	call BattleCheckEnemyShininess
	jr nc, .not_shiny

	ld a, 1 ; shiny anim
	ld [wBattleAnimParam], a
	ld de, ANIM_SEND_OUT_MON
	call Call_PlayBattleAnim

.not_shiny
	ld bc, wTempMonSpecies
	farcall CheckFaintedFrzSlp
	jr c, .skip_cry

	farcall CheckBattleScene
	jr c, .cry_no_anim

	hlcoord 12, 0
	ld de, ANIM_MON_SLOW
	predef AnimateFrontpic
	jr .skip_cry

.cry_no_anim
	ld a, $f
	ld [wCryTracks], a
	ld a, [wTempEnemyMonSpecies]
	call PlayStereoCry

.skip_cry
	call UpdateEnemyHUD
	ld a, $1
	ldh [hBGMapMode], a
	ret

NewEnemyMonStatus:
	xor a
	ld [wLastPlayerCounterMove], a
	ld [wLastEnemyCounterMove], a
	ld [wLastEnemyMove], a
	ld hl, wEnemySubStatus1
rept 4
	ld [hli], a
endr
	ld [hl], a
	ld [wEnemyDisableCount], a
	ld [wEnemyFuryCutterCount], a
	ld [wEnemyProtectCount], a
	ld [wEnemyRageCounter], a
	ld [wEnemyDisabledMove], a
	ld [wEnemyMinimized], a
	ld [wPlayerWrapCount], a
	ld [wEnemyWrapCount], a
	ld [wEnemyTurnsTaken], a
	ld hl, wPlayerSubStatus5
	res SUBSTATUS_CANT_RUN, [hl]
	ret

ResetEnemyStatLevels:
	ld a, BASE_STAT_LEVEL
	ld b, NUM_LEVEL_STATS
	ld hl, wEnemyStatLevels
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret

CheckPlayerPartyForFitMon:
; Has the player any mon in his Party that can fight?
	ld a, [wPartyCount]
	ld e, a
	xor a
	ld hl, wPartyMon1HP
	ld bc, PARTYMON_STRUCT_LENGTH - 1
.loop
	or [hl]
	inc hl ; + 1
	or [hl]
	add hl, bc
	dec e
	jr nz, .loop
	ld d, a
	ret

CheckIfCurPartyMonIsFitToFight:
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1HP
	call GetPartyLocation
	ld a, [hli]
	or [hl]
	ret nz

	ld a, [wBattleHasJustStarted]
	and a
	jr nz, .finish_fail
	ld hl, wPartySpecies
	ld a, [wCurPartyMon]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	cp EGG
	ld hl, BattleText_AnEGGCantBattle
	jr z, .print_textbox

	ld hl, BattleText_TheresNoWillToBattle

.print_textbox
	call StdBattleTextbox

.finish_fail
	xor a
	ret

TryToRunAwayFromBattle:
; Run away from battle, with or without item
	ld a, [wBattleType]
	cp BATTLETYPE_DEBUG
	jmp z, .can_escape
	cp BATTLETYPE_CONTEST
	jmp z, .can_escape
	cp BATTLETYPE_TRAP
	jmp z, .cant_escape
	cp BATTLETYPE_CELEBI
	jmp z, .cant_escape
	cp BATTLETYPE_FORCESHINY
	jmp z, .cant_escape
	cp BATTLETYPE_SUICUNE
	jmp z, .cant_escape

	ld a, [wLinkMode]
	and a
	jmp nz, .can_escape

	ld a, [wBattleMode]
	dec a
	jmp nz, .cant_run_from_trainer

	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_CANT_RUN, a
	jmp nz, .cant_escape

	ld a, [wPlayerWrapCount]
	and a
	jmp nz, .cant_escape

	push hl
	push de
	ld a, [wBattleMonItem]
	ld [wNamedObjectIndex], a
	ld b, a
	farcall GetItemHeldEffect
	ld a, b
	cp HELD_ESCAPE
	pop de
	pop hl
	jr nz, .no_flee_item

	call SetPlayerTurn
	call GetItemName
	ld hl, BattleText_UserFledUsingAStringBuffer1
	call StdBattleTextbox
	jmp .can_escape

.no_flee_item
	ld a, [wNumFleeAttempts] ; no-optimize Inefficient WRAM increment/decrement
	inc a
	ld [wNumFleeAttempts], a
	ld a, [hli]
	ldh [hMultiplicand + 1], a
	ld a, [hl]
	ldh [hMultiplicand + 2], a
	ld a, [de]
	inc de
	ldh [hEnemyMonSpeed + 0], a
	ld a, [de]
	ldh [hEnemyMonSpeed + 1], a
	call SafeLoadTempTilemapToTilemap
	ld de, hMultiplicand + 1
	ld hl, hEnemyMonSpeed
	ld c, 2
	call CompareBytes
	jr nc, .can_escape

	xor a
	ldh [hMultiplicand + 0], a
	ld a, 32
	ldh [hMultiplier], a
	call Multiply
	ldh a, [hProduct + 2]
	ldh [hDividend + 0], a
	ldh a, [hProduct + 3]
	ldh [hDividend + 1], a
	ldh a, [hEnemyMonSpeed + 0]
	ld b, a
	ldh a, [hEnemyMonSpeed + 1]
	srl b
	rra
	srl b
	rra
	and a
	jr z, .can_escape
	ldh [hDivisor], a
	ld b, 2
	call Divide
	ldh a, [hQuotient + 2]
	and a
	jr nz, .can_escape
	ld a, [wNumFleeAttempts]
	ld c, a
.loop
	dec c
	jr z, .cant_escape_2
	ld b, 30
	ldh a, [hQuotient + 3]
	add b
	ldh [hQuotient + 3], a
	jr c, .can_escape
	jr .loop

.cant_escape_2
	call BattleRandom
	ld b, a
	ldh a, [hQuotient + 3]
	cp b
	jr nc, .can_escape
	ld a, BATTLEPLAYERACTION_USEITEM
	ld [wBattlePlayerAction], a

.cant_escape
	ld hl, BattleText_CantEscape
	jr .print_inescapable_text

.cant_run_from_trainer
	ld hl, BattleText_TheresNoEscapeFromTrainerBattle

.print_inescapable_text
	call StdBattleTextbox
	ld a, TRUE
	ld [wFailedToFlee], a
	call LoadTilemapToTempTilemap
	and a
	ret

.can_escape
	ld a, DRAW
	ld b, a
	ld a, [wBattleResult]
	and BATTLERESULT_BITMASK
	add b
	ld [wBattleResult], a
	call StopDangerSound
	push de
	ld de, SFX_RUN
	call WaitPlaySFX
	pop de
	ld hl, BattleText_GotAwaySafely
	call StdBattleTextbox
	call WaitSFX
	call LoadTilemapToTempTilemap
	scf
	ret

InitBattleMon:
	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld de, wBattleMonSpecies
	ld bc, MON_ID
	rst CopyBytes
	ld bc, MON_DVS - MON_ID
	add hl, bc
	ld de, wBattleMonDVs
	ld bc, MON_POKERUS - MON_DVS
	rst CopyBytes
	inc hl
	inc hl
	inc hl
	ld de, wBattleMonLevel
	ld bc, PARTYMON_STRUCT_LENGTH - MON_LEVEL
	rst CopyBytes
	ld a, [wBattleMonSpecies]
	ld [wTempBattleMonSpecies], a
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [wBaseType1]
	ld [wBattleMonType1], a
	ld a, [wBaseType2]
	ld [wBattleMonType2], a
	ld hl, wPartyMonNicknames
	ld a, [wCurBattleMon]
	call SkipNames
	ld de, wBattleMonNickname
	ld bc, MON_NAME_LENGTH
	rst CopyBytes
	ld hl, wBattleMonAttack
	ld de, wPlayerStats
	ld bc, PARTYMON_STRUCT_LENGTH - MON_ATK
	rst CopyBytes
	jmp ApplyStatusEffectOnPlayerStats

BattleCheckPlayerShininess:
	call GetPartyMonDVs
	jr BattleCheckShininess

BattleCheckEnemyShininess:
	call GetEnemyMonDVs

BattleCheckShininess:
	ld b, h
	ld c, l
	farjp CheckShininess

GetPartyMonDVs:
	ld hl, wBattleMonDVs
	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	ret z
	ld hl, wPartyMon1DVs
	ld a, [wCurBattleMon]
	jmp GetPartyLocation

GetEnemyMonDVs:
	ld hl, wEnemyMonDVs
	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	ret z
	ld hl, wEnemyBackupDVs
	ld a, [wBattleMode]
	dec a
	ret z
	ld hl, wOTPartyMon1DVs
	ld a, [wCurOTMon]
	jmp GetPartyLocation

ResetPlayerStatLevels:
	ld a, BASE_STAT_LEVEL
	ld b, NUM_LEVEL_STATS
	ld hl, wPlayerStatLevels
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret

InitEnemyMon:
	ld a, [wCurPartyMon]
	ld hl, wOTPartyMon1Species
	call GetPartyLocation
	ld de, wEnemyMonSpecies
	ld bc, MON_ID
	rst CopyBytes
	ld bc, MON_DVS - MON_ID
	add hl, bc
	ld de, wEnemyMonDVs
	ld bc, MON_POKERUS - MON_DVS
	rst CopyBytes
	inc hl
	inc hl
	inc hl
	ld de, wEnemyMonLevel
	ld bc, PARTYMON_STRUCT_LENGTH - MON_LEVEL
	rst CopyBytes
	ld a, [wEnemyMonSpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld hl, wOTPartyMonNicknames
	ld a, [wCurPartyMon]
	call SkipNames
	ld de, wEnemyMonNickname
	ld bc, MON_NAME_LENGTH
	rst CopyBytes
	ld hl, wEnemyMonAttack
	ld de, wEnemyStats
	ld bc, PARTYMON_STRUCT_LENGTH - MON_ATK
	rst CopyBytes
	call ApplyStatusEffectOnEnemyStats
	ld hl, wBaseType1
	ld de, wEnemyMonType1
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	; The enemy mon's base Sp. Def isn't needed since its base
	; Sp. Atk is also used to calculate Sp. Def stat experience.
	ld hl, wBaseStats
	ld de, wEnemyMonBaseStats
	ld b, NUM_STATS - 1
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	ld a, [wCurPartyMon]
	ld [wCurOTMon], a
	ret

SwitchPlayerMon:
	call ClearSprites
	ld a, [wCurBattleMon]
	ld [wLastPlayerMon], a
	ld a, [wCurPartyMon]
	ld [wCurBattleMon], a
	call AddBattleParticipant
	call InitBattleMon
	call ResetPlayerStatLevels
	call NewBattleMonStatus
	call BreakAttraction
	call SendOutPlayerMon
	call EmptyBattleTextbox
	call LoadTilemapToTempTilemap
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl]
	ret

SendOutPlayerMon:
	ld hl, wBattleMonDVs
	predef GetUnownLetter
	hlcoord 1, 5
	lb bc, 7, 8
	call ClearBox
	call WaitBGMap
	xor a
	ldh [hBGMapMode], a
	call GetBattleMonBackpic
	xor a
	ldh [hGraphicStartTile], a
	ld [wBattleMenuCursorPosition], a
	ld [wCurMoveNum], a
	ld [wTypeModifier], a
	ld [wPlayerMoveStruct + MOVE_ANIM], a
	ld [wLastPlayerCounterMove], a
	ld [wLastEnemyCounterMove], a
	ld [wLastPlayerMove], a
	call CheckAmuletCoin
	call FinishBattleAnim
	xor a
	ld [wEnemyWrapCount], a
	call SetPlayerTurn
	xor a
	ld [wNumHits], a
	ld [wBattleAnimParam], a
	ld de, ANIM_SEND_OUT_MON
	call Call_PlayBattleAnim
	call BattleCheckPlayerShininess
	jr nc, .not_shiny
	ld a, 1
	ld [wBattleAnimParam], a
	ld de, ANIM_SEND_OUT_MON
	call Call_PlayBattleAnim

.not_shiny
	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld b, h
	ld c, l
	farcall CheckFaintedFrzSlp
	jr c, .statused
	ld a, $f0
	ld [wCryTracks], a
	ld a, [wCurPartySpecies]
	call PlayStereoCry

.statused
	call UpdatePlayerHUD
	ld a, $1
	ldh [hBGMapMode], a
	ret

NewBattleMonStatus:
	xor a
	ld [wLastPlayerCounterMove], a
	ld [wLastEnemyCounterMove], a
	ld [wLastPlayerMove], a
	ld hl, wPlayerSubStatus1
rept 4
	ld [hli], a
endr
	ld [hl], a
	ld [wPlayerDisableCount], a
	ld [wPlayerFuryCutterCount], a
	ld [wPlayerProtectCount], a
	ld [wPlayerRageCounter], a
	ld [wDisabledMove], a
	ld [wPlayerMinimized], a
	ld [wEnemyWrapCount], a
	ld [wPlayerWrapCount], a
	ld [wPlayerTurnsTaken], a
	ld hl, wEnemySubStatus5
	res SUBSTATUS_CANT_RUN, [hl]
	ret

BreakAttraction:
	ld hl, wPlayerSubStatus1
	res SUBSTATUS_IN_LOVE, [hl]
	ld hl, wEnemySubStatus1
	res SUBSTATUS_IN_LOVE, [hl]
	ret

SpikesDamage:
	ld hl, wPlayerScreens
	ld de, wBattleMonType
	ld bc, UpdatePlayerHUD
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wEnemyScreens
	ld de, wEnemyMonType
	ld bc, UpdateEnemyHUD
.ok

	bit SCREENS_SPIKES, [hl]
	ret z

	; Flying-types aren't affected by Spikes.
	ld a, [de]
	cp FLYING
	ret z
	inc de
	ld a, [de]
	cp FLYING
	ret z

	push bc

	ld hl, BattleText_UserHurtBySpikes ; "hurt by SPIKES!"
	call StdBattleTextbox

	call GetEighthMaxHP
	call SubtractHPFromTarget

	pop hl
	call .hl

	jmp WaitBGMap

.hl
	jp hl

PursuitSwitch:
	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	ld b, a
	call GetMoveEffect
	ld a, b
	cp EFFECT_PURSUIT
	jr nz, .done

	ld a, [wCurBattleMon]
	push af

	ld hl, DoPlayerTurn
	ldh a, [hBattleTurn]
	and a
	jr z, .do_turn
	ld hl, DoEnemyTurn
	ld a, [wLastPlayerMon]
	ld [wCurBattleMon], a
.do_turn
	ld a, BANK(DoPlayerTurn) ; aka BANK(DoEnemyTurn)
	call FarCall_hl

	ld a, BATTLE_VARS_MOVE
	call GetBattleVarAddr
	ld [hl], $ff

	pop af
	ld [wCurBattleMon], a

	ldh a, [hBattleTurn]
	and a
	jr z, .check_enemy_fainted

	ld a, [wLastPlayerMon]
	call UpdateBattleMon
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	jr nz, .done

	ld a, $f0
	ld [wCryTracks], a
	ld a, [wBattleMonSpecies]
	call PlayStereoCry
	ld a, [wCurBattleMon]
	push af
	ld a, [wLastPlayerMon]
	ld [wCurBattleMon], a
	call UpdateFaintedPlayerMon
	pop af
	ld [wCurBattleMon], a
	call PlayerMonFaintedAnimation
	ld hl, BattleText_MonFainted
	jr .done_fainted

.check_enemy_fainted
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl]
	jr nz, .done

	ld de, SFX_KINESIS
	call PlaySFX
	ld de, SFX_FAINT
	call WaitPlaySFX
	call WaitSFX
	call EnemyMonFaintedAnimation
	ld hl, BattleText_EnemyMonFainted

.done_fainted
	call StdBattleTextbox
	scf
	ret

.done
	and a
	ret

RecallPlayerMon:
	ldh a, [hBattleTurn]
	push af
	xor a
	ldh [hBattleTurn], a
	ld [wNumHits], a
	ld de, ANIM_RETURN_MON
	call Call_PlayBattleAnim
	pop af
	ldh [hBattleTurn], a
	ret

HandleHealingItems:
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .player_1
	call SetPlayerTurn
	call HandleHPHealingItem
	call UseHeldStatusHealingItem
	call UseConfusionHealingItem
	call SetEnemyTurn
	call HandleHPHealingItem
	call UseHeldStatusHealingItem
	jmp UseConfusionHealingItem

.player_1
	call SetEnemyTurn
	call HandleHPHealingItem
	call UseHeldStatusHealingItem
	call UseConfusionHealingItem
	call SetPlayerTurn
	call HandleHPHealingItem
	call UseHeldStatusHealingItem
	jmp UseConfusionHealingItem

HandleHPHealingItem:
	farcall GetOpponentItem
	ld a, b
	cp HELD_BERRY
	ret nz
	ld de, wEnemyMonHP + 1
	ld hl, wEnemyMonMaxHP
	ldh a, [hBattleTurn]
	and a
	jr z, .go
	ld de, wBattleMonHP + 1
	ld hl, wBattleMonMaxHP

.go
; If, and only if, Pokemon's HP is less than half max, use the item.
; Store current HP in Buffer 3/4
	push bc
	ld a, [de]
	ld [wHPBuffer2], a
	add a
	ld c, a
	dec de
	ld a, [de]
	inc de
	ld [wHPBuffer2 + 1], a
	adc a
	ld b, a
	cp [hl]
	ld a, c
	pop bc
	jr z, .equal
	jr c, .less
	ret

.equal
	inc hl
	cp [hl]
	dec hl
	ret nc

.less
	call ItemRecoveryAnim
	; store max HP in wHPBuffer1
	ld a, [hli]
	ld [wHPBuffer1 + 1], a
	ld a, [hl]
	ld [wHPBuffer1], a
	ld a, [de]
	add c
	ld [wHPBuffer3], a
	ld c, a
	dec de
	ld a, [de]
	adc 0
	ld [wHPBuffer3 + 1], a
	ld b, a
	ld a, [hld]
	cp c
	ld a, [hl]
	sbc b
	jr nc, .okay
	ld a, [hli]
	ld [wHPBuffer3 + 1], a
	ld a, [hl]
	ld [wHPBuffer3], a

.okay
	ld a, [wHPBuffer3 + 1]
	ld [de], a
	inc de
	ld a, [wHPBuffer3]
	ld [de], a
	ldh a, [hBattleTurn]
	ld [wWhichHPBar], a
	and a
	hlcoord 2, 2
	jr z, .got_hp_bar_coords
	hlcoord 10, 9

.got_hp_bar_coords
	ld [wWhichHPBar], a
	predef AnimateHPBar
UseOpponentItem:
	call RefreshBattleHuds
	farcall GetOpponentItem
	ld a, [hl]
	ld [wNamedObjectIndex], a
	call GetItemName
	farcall ConsumeHeldItem
	ld hl, RecoveredUsingText
	jmp StdBattleTextbox

ItemRecoveryAnim:
	push hl
	push de
	push bc
	call EmptyBattleTextbox
	ld a, RECOVER
	ld [wFXAnimID], a
	call SwitchTurn
	xor a
	ld [wNumHits], a
	ld [wFXAnimID + 1], a
	predef PlayBattleAnim
	call SwitchTurn
	pop bc
	pop de
	pop hl
	ret

UseHeldStatusHealingItem:
	farcall GetOpponentItem
	ld hl, HeldStatusHealingEffects
.loop
	ld a, [hli]
	cp $ff
	ret z
	inc hl
	cp b
	jr nz, .loop
	dec hl
	ld b, [hl]
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and b
	ret z
	xor a
	ld [hl], a
	push bc
	call UpdateOpponentInParty
	pop bc
	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVarAddr
	and [hl]
	res SUBSTATUS_TOXIC, [hl]
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVarAddr
	and [hl]
	res SUBSTATUS_NIGHTMARE, [hl]
	ld a, b
	cp ALL_STATUS
	jr nz, .skip_confuse
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVarAddr
	res SUBSTATUS_CONFUSED, [hl]

.skip_confuse
	ld hl, CalcEnemyStats
	ldh a, [hBattleTurn]
	and a
	jr z, .got_pointer
	ld hl, CalcPlayerStats

.got_pointer
	call SwitchTurn
	ld a, BANK(CalcPlayerStats) ; aka BANK(CalcEnemyStats)
	call FarCall_hl
	call SwitchTurn
	call ItemRecoveryAnim
	call UseOpponentItem
	ld a, $1
	and a
	ret

INCLUDE "data/battle/held_heal_status.asm"

UseConfusionHealingItem:
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	bit SUBSTATUS_CONFUSED, a
	ret z
	farcall GetOpponentItem
	ld a, b
	cp HELD_HEAL_CONFUSION
	jr z, .heal_status
	cp HELD_HEAL_STATUS
	ret nz

.heal_status
	ld a, [hl]
	ld [wNamedObjectIndex], a
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVarAddr
	res SUBSTATUS_CONFUSED, [hl]
	call GetItemName
	call ItemRecoveryAnim
	ld hl, BattleText_ItemHealedConfusion
	call StdBattleTextbox
	ldh a, [hBattleTurn]
	and a
	jr nz, .do_partymon
	call GetOTPartymonItem
	xor a
	ld [bc], a
	ld a, [wBattleMode]
	dec a
	ret z
	ld [hl], $0
	ret

.do_partymon
	call GetPartymonItem
	xor a
	ld [bc], a
	ld [hl], a
	ret

HandleStatBoostingHeldItems:
; The effects handled here are not used in-game.
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .player_1
	call .DoPlayer
	jr .DoEnemy

.player_1
	call .DoEnemy

.DoPlayer:
	call GetPartymonItem
	xor a
	jr .HandleItem

.DoEnemy:
	call GetOTPartymonItem
	ld a, $1
.HandleItem:
	ldh [hBattleTurn], a
	ld d, h
	ld e, l
	push de
	push bc
	ld a, [bc]
	ld b, a
	farcall GetItemHeldEffect
	ld hl, HeldStatUpItems
.loop
	ld a, [hli]
	cp -1
	jr z, .finish
	inc hl
	inc hl
	cp b
	jr nz, .loop
	pop bc
	ld a, [bc]
	ld [wNamedObjectIndex], a
	push bc
	dec hl
	dec hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, BANK(BattleCommand_AttackUp)
	call FarCall_hl
	pop bc
	pop de
	ld a, [wFailedMessage]
	and a
	ret nz
	xor a
	ld [bc], a
	ld [de], a
	call GetItemName
	ld hl, BattleText_UsersStringBuffer1Activated
	call StdBattleTextbox
	farjp BattleCommand_StatUpMessage

.finish
	pop bc
	pop de
	ret

INCLUDE "data/battle/held_stat_up.asm"

GetPartymonItem:
	ld hl, wPartyMon1Item
	ld a, [wCurBattleMon]
	call GetPartyLocation
	ld bc, wBattleMonItem
	ret

GetOTPartymonItem:
	ld hl, wOTPartyMon1Item
	ld a, [wCurOTMon]
	call GetPartyLocation
	ld bc, wEnemyMonItem
	ret

UpdateBattleHUDs:
	push hl
	push de
	push bc
	call DrawPlayerHUD
	ld hl, wPlayerHPPal
	call SetHPPal
	call CheckDanger
	call DrawEnemyHUD
	ld hl, wEnemyHPPal
	call SetHPPal
	pop bc
	pop de
	pop hl
	ret

UpdatePlayerHUD::
	push hl
	push de
	push bc
	call DrawPlayerHUD
	call UpdatePlayerHPPal
	call CheckDanger
	pop bc
	pop de
	pop hl
	ret

DrawPlayerHUD:
	xor a
	ldh [hBGMapMode], a

	; Clear the area
	hlcoord 9, 7
	lb bc, 5, 11
	call ClearBox

	farcall DrawPlayerHUDBorder

	hlcoord 18, 9
	ld [hl], $73 ; vertical bar
	call PrintPlayerHUD

	; HP bar
	hlcoord 10, 9
	ld b, 1
	xor a ; PARTYMON
	ld [wMonType], a
	predef DrawPlayerHP

	; Exp bar
	push de
	ld a, [wCurBattleMon]
	ld hl, wPartyMon1Exp + 2
	call GetPartyLocation
	ld d, h
	ld e, l

	hlcoord 10, 11
	ld a, [wTempMonLevel]
	ld b, a
	call FillInExpBar
	pop de
	ret

UpdatePlayerHPPal:
	ld hl, wPlayerHPPal
	jmp UpdateHPPal

CheckDanger:
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	jr z, .no_danger
	ld a, [wBattleLowHealthAlarm]
	and a
	ret nz
	ld a, [wPlayerHPPal]
	cp HP_RED
	jr z, .danger

.no_danger
	ld hl, wLowHealthAlarm
	res DANGER_ON_F, [hl]
	ret

.danger
	ld hl, wLowHealthAlarm
	set DANGER_ON_F, [hl]
	ret

PrintPlayerHUD:
	ld de, wBattleMonNickname
	hlcoord 10, 7
	rst PlaceString

	push bc

	ld a, [wCurBattleMon]
	ld hl, wPartyMon1DVs
	call GetPartyLocation
	ld de, wTempMonDVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld hl, wBattleMonLevel
	ld de, wTempMonLevel
	ld bc, wTempMonStructEnd - wTempMonLevel
	rst CopyBytes ; battle_struct and party_struct end with the same data
	ld a, [wCurBattleMon]
	ld hl, wPartyMon1Species
	call GetPartyLocation
	ld a, [hl]
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	call GetBaseData

	pop hl
	dec hl

	ld a, TEMPMON
	ld [wMonType], a
	farcall GetGender
	ld a, " "
	jr c, .got_gender_char
	ld a, "♂"
	jr nz, .got_gender_char
	ld a, "♀"

.got_gender_char
	hlcoord 17, 8
	ld [hl], a
	; Player Mon Status Condition GFX
	farcall Player_LoadNonFaintStatus ; loads needed Status Conditon GFX into VRAM
 	ld a, c
	and a
	jr z, .status_done ; if Mon is fainted, or it doesnt have a Status Cond, dont print Tiles
	; place status tiles:
	hlcoord 10, 8 ; status icon tile 1
	ld a, $70
	ld [hli], a
	ld [hl], $71
	.status_done
	hlcoord 14, 8 ; where the player mon's lvl is printed

	ld a, [wBattleMonLevel]
	ld [wTempMonLevel], a
	jmp PrintLevel

UpdateEnemyHUD::
	push hl
	push de
	push bc
	call DrawEnemyHUD
	call UpdateEnemyHPPal
	pop bc
	pop de
	pop hl
	ret

DrawEnemyHUD:
	xor a
	ldh [hBGMapMode], a

	hlcoord 1, 0
	lb bc, 4, 11
	call ClearBox

	farcall DrawEnemyHUDBorder

	ld a, [wTempEnemyMonSpecies]
	ld [wCurSpecies], a
	ld [wCurPartySpecies], a
	call GetBaseData
	ld de, wEnemyMonNickname
	hlcoord 1, 0
	rst PlaceString
	ld h, b
	ld l, c
	dec hl

	ld hl, wEnemyMonDVs
	ld de, wTempMonDVs
	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jr z, .ok
	ld hl, wEnemyBackupDVs
.ok
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

	ld a, TEMPMON
	ld [wMonType], a
	farcall GetGender
	ld a, " "
	jr c, .got_gender
	ld a, "♂"
	jr nz, .got_gender
	ld a, "♀"

.got_gender
	hlcoord 9, 1
	ld [hl], a
	; Enemy Status Condition GFX
	farcall Enemy_LoadNonFaintStatus ; load Status Condition GFX Tiles
	ld a, c
	and a
	jr z, .status_done ; if Mon is fainted, or it doesnt have a Status Cond, dont print Tiles
	hlcoord 2, 1
	ld a, $72 ; enemy status left half
	ld [hli], a
	ld [hl], $73 ; enemy status left half
.status_done
	hlcoord 6, 1 ; enemy's level
	ld a, [wEnemyMonLevel]
	ld [wTempMonLevel], a
	call PrintLevel
.skip_level
	hlcoord 6, 1 ; enemy's level
	ld hl, wEnemyMonHP
	ld a, [hli]
	ldh [hMultiplicand + 1], a
	ld a, [hld]
	ldh [hMultiplicand + 2], a
	or [hl]
	jr nz, .not_fainted

	ld c, a
	ld e, a
	ld d, HP_BAR_LENGTH
	jr .draw_bar

.not_fainted
	xor a
	ldh [hMultiplicand + 0], a
	ld a, HP_BAR_LENGTH_PX
	ldh [hMultiplier], a
	call Multiply
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ldh [hMultiplier], a
	ld a, b
	and a
	jr z, .less_than_256_max
	ldh a, [hMultiplier]
	srl b
	rra
	srl b
	rra
	ldh [hDivisor], a
	ldh a, [hProduct + 2]
	ld b, a
	srl b
	ldh a, [hProduct + 3]
	rra
	srl b
	rra
	ldh [hProduct + 3], a
	ld a, b
	ldh [hProduct + 2], a

.less_than_256_max
	ldh a, [hProduct + 2]
	ldh [hDividend + 0], a
	ldh a, [hProduct + 3]
	ldh [hDividend + 1], a
	ld a, 2
	ld b, a
	call Divide
	ldh a, [hQuotient + 3]
	ld e, a
	ld a, HP_BAR_LENGTH
	ld d, a
	ld c, a

.draw_bar
	xor a
	ld [wWhichHPBar], a
	hlcoord 2, 2
	ld b, 0
	jmp DrawBattleHPBar

UpdateEnemyHPPal:
	ld hl, wEnemyHPPal

UpdateHPPal:
	ld b, [hl]
	call SetHPPal
	ld a, [hl]
	cp b
	ret z
	jmp FinishBattleAnim

BattleMenu:
	xor a
	ldh [hBGMapMode], a
	call LoadTempTilemapToTilemap

	ld a, [wBattleType]
	cp BATTLETYPE_DEBUG
	jr z, .ok
	cp BATTLETYPE_TUTORIAL
	jr z, .ok
	call EmptyBattleTextbox
	call UpdateBattleHuds
	call EmptyBattleTextbox
	call LoadTilemapToTempTilemap
.ok

.loop
	ld a, [wBattleType]
	cp BATTLETYPE_CONTEST
	jr nz, .not_contest
	farcall ContestBattleMenu
	jr .next
.not_contest

	; Auto input: choose "ITEM"
	ld a, [wInputType]
	or a
	jr z, .skip_dude_pack_select
	farcall _DudeAutoInput_DownA
.skip_dude_pack_select
	call LoadBattleMenu2
	ret c

.next
	ld a, $1
	ldh [hBGMapMode], a
	ld a, [wBattleMenuCursorPosition]
	cp $1
	jr z, BattleMenu_Fight
	cp $3
	jr z, BattleMenu_Pack
	cp $2
	jmp z, BattleMenu_PKMN
	cp $4
	jmp z, BattleMenu_Run
	jr .loop

BattleMenu_Fight:
	xor a
	ld [wNumFleeAttempts], a
	call SafeLoadTempTilemapToTilemap
	and a
	ret

LoadBattleMenu2:
	farcall LoadBattleMenu
	and a
	ret

BattleMenu_Pack:
	ld a, [wLinkMode]
	and a
	jr nz, .ItemsCantBeUsed

	ld a, [wInBattleTowerBattle]
	and a
	jr nz, .ItemsCantBeUsed

	call LoadStandardMenuHeader

	ld a, [wBattleType]
	cp BATTLETYPE_TUTORIAL
	jr z, .tutorial
	cp BATTLETYPE_CONTEST
	jr z, .contest

	farcall BattlePack
	ld a, [wBattlePlayerAction]
	and a ; BATTLEPLAYERACTION_USEMOVE?
	jr z, .didnt_use_item
	jr .UseItem

.tutorial
	farcall TutorialPack
	ld a, POKE_BALL
	ld [wCurItem], a
	call DoItemEffect
	jr .UseItem

.contest
	ld a, PARK_BALL
	ld [wCurItem], a
	call DoItemEffect
	jr .UseItem

.didnt_use_item
	call ClearPalettes
	call DelayFrame
	call _LoadBattleFontsHPBar
	call GetBattleMonBackpic
	call GetEnemyMonFrontpic
	call ExitMenu
	call WaitBGMap
	call FinishBattleAnim
	call LoadTilemapToTempTilemap
	jmp BattleMenu

.ItemsCantBeUsed:
	ld hl, BattleText_ItemsCantBeUsedHere
	call StdBattleTextbox
	jmp BattleMenu

.UseItem:
	ld a, [wWildMon]
	and a
	jr nz, .run
	farcall CheckItemPocket
	ld a, [wItemAttributeValue]
	cp BALL
	call nz, ClearBGPalettes

.ball
	xor a
	ldh [hBGMapMode], a
	call _LoadBattleFontsHPBar
	call ClearSprites
	ld a, [wBattleType]
	cp BATTLETYPE_TUTORIAL
	call nz, GetBattleMonBackpic
	call GetEnemyMonFrontpic
	ld a, $1
	ld [wMenuCursorY], a
	call ExitMenu
	call UpdateBattleHUDs
	call WaitBGMap
	call LoadTilemapToTempTilemap
	call ClearWindowData
	call FinishBattleAnim
	and a
	ret

.run
	xor a
	ld [wWildMon], a
	ld a, [wBattleResult]
	and BATTLERESULT_BITMASK
	ld [wBattleResult], a ; WIN
	call ClearWindowData
	call SetDefaultBGPAndOBP
	scf
	ret

BattleMenu_PKMN:
	call LoadStandardMenuHeader
BattleMenuPKMN_ReturnFromStats:
	call ExitMenu
	call LoadStandardMenuHeader
	call ClearBGPalettes
BattleMenuPKMN_Loop:
	call SetUpBattlePartyMenu_Loop
	xor a
	ld [wPartyMenuActionText], a
	call JumpToPartyMenuAndPrintText
	call SelectBattleMon
	jr c, .Cancel
.loop
	farcall FreezeMonIcons
	call .GetMenu
	jr c, BattleMenuPKMN_Loop ; .PressedB
	call PlaceHollowCursor
	ld a, [wMenuCursorY]
	cp $1 ; SWITCH
	jr z, TryPlayerSwitch
	cp $2 ; STATS
	jr z, .Stats
	cp $3 ; CANCEL
	jr z, .Cancel
	jr .loop

.Stats:
	call Battle_StatsScreen
	jr BattleMenuPKMN_ReturnFromStats

.Cancel:
	call ClearSprites
	call ClearPalettes
	call DelayFrame
	call _LoadHPBar
	call CloseWindow
	call GetBattleMonBackpic
	call WaitBGMap
	call LoadTilemapToTempTilemap
	call GetMemSGBLayout
	call SetDefaultBGPAndOBP
	jmp BattleMenu

.GetMenu:
	farjp BattleMonMenu

Battle_StatsScreen:
	call DisableLCD

	ld hl, vTiles2 tile $31
	ld de, vTiles0
	ld bc, $11 tiles
	rst CopyBytes

	ld hl, vTiles2
	ld de, vTiles0 tile $11
	ld bc, $31 tiles
	rst CopyBytes

	call EnableLCD

	call ClearSprites
	call LowVolume
	xor a ; PARTYMON
	ld [wMonType], a
	farcall StatsScreenInit
	call MaxVolume

	call DisableLCD

	ld hl, vTiles0
	ld de, vTiles2 tile $31
	ld bc, $11 tiles
	rst CopyBytes

	ld hl, vTiles0 tile $11
	ld de, vTiles2
	ld bc, $31 tiles
	rst CopyBytes

	jmp EnableLCD

TryPlayerSwitch:
	ld a, [wCurBattleMon]
	ld d, a
	ld a, [wCurPartyMon]
	cp d
	jr nz, .check_trapped
	ld hl, BattleText_MonIsAlreadyOut
	call StdBattleTextbox
	jmp BattleMenuPKMN_Loop

.check_trapped
	ld a, [wPlayerWrapCount]
	and a
	jr nz, .trapped
	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_CANT_RUN, a
	jr z, .try_switch

.trapped
	ld hl, BattleText_MonCantBeRecalled
	call StdBattleTextbox
	jmp BattleMenuPKMN_Loop

.try_switch
	call CheckIfCurPartyMonIsFitToFight
	jmp z, BattleMenuPKMN_Loop
	ld a, [wCurBattleMon]
	ld [wLastPlayerMon], a
	ld a, BATTLEPLAYERACTION_SWITCH
	ld [wBattlePlayerAction], a
	call ClearPalettes
	call DelayFrame
	call ClearSprites
	call _LoadHPBar
	call GetBattleMonBackpic
	call WaitBGMap
	call CloseWindow
	call GetMemSGBLayout
	call SetDefaultBGPAndOBP
	ld a, [wCurPartyMon]
	ld [wCurBattleMon], a
	ld a, 1
	ld [wPlayerIsSwitching], a
	call ParseEnemyAction
	ld a, [wLinkMode]
	and a
	jr nz, .linked

.switch
	call BattleMonEntrance
	and a
	ret

.linked
	ld a, [wBattleAction]
	cp BATTLEACTION_STRUGGLE
	jr z, .switch
	cp BATTLEACTION_SKIPTURN
	jr z, .switch
	cp BATTLEACTION_SWITCH1
	jr c, .switch
	cp BATTLEACTION_FORFEIT
	jmp z, WildFled_EnemyFled_LinkBattleCanceled

.dont_run
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .player_1
	call BattleMonEntrance
	call EnemyMonEntrance
	and a
	ret

.player_1
	call EnemyMonEntrance
	call BattleMonEntrance
	and a
	ret

EnemyMonEntrance:
	farcall AI_Switch
	call SetEnemyTurn
	jmp SpikesDamage

BattleMonEntrance:
	call WithdrawMonText

	ld c, 50
	call DelayFrames

	ld hl, wPlayerSubStatus4
	res SUBSTATUS_RAGE, [hl]

	call SetEnemyTurn
	call PursuitSwitch
	call nc, RecallPlayerMon

	hlcoord 9, 7
	lb bc, 5, 11
	call ClearBox

	ld a, [wCurBattleMon]
	ld [wCurPartyMon], a
	call AddBattleParticipant
	call InitBattleMon
	call ResetPlayerStatLevels
	call SendOutMonText
	call NewBattleMonStatus
	call BreakAttraction
	call SendOutPlayerMon
	call EmptyBattleTextbox
	call LoadTilemapToTempTilemap
	call SetPlayerTurn
	call SpikesDamage
	ld a, $2
	ld [wMenuCursorY], a
	ret

PassedBattleMonEntrance:
	ld c, 50
	call DelayFrames

	hlcoord 9, 7
	lb bc, 5, 11
	call ClearBox

	ld a, [wCurPartyMon]
	ld [wCurBattleMon], a
	call AddBattleParticipant
	call InitBattleMon
	xor a ; FALSE
	ld [wApplyStatLevelMultipliersToEnemy], a
	call ApplyStatLevelMultiplierOnAllStats
	call SendOutPlayerMon
	call EmptyBattleTextbox
	call LoadTilemapToTempTilemap
	call SetPlayerTurn
	jmp SpikesDamage

BattleMenu_Run:
	call SafeLoadTempTilemapToTilemap
	ld a, $3
	ld [wMenuCursorY], a
	ld hl, wBattleMonSpeed
	ld de, wEnemyMonSpeed
	call TryToRunAwayFromBattle
	ld a, FALSE
	ld [wFailedToFlee], a
	ret c
	ld a, [wBattlePlayerAction]
	and a ; BATTLEPLAYERACTION_USEMOVE?
	ret nz
	jmp BattleMenu

CheckAmuletCoin:
	ld a, [wBattleMonItem]
	ld b, a
	farcall GetItemHeldEffect
	ld a, b
	cp HELD_AMULET_COIN
	ret nz
	ld a, 1
	ld [wAmuletCoin], a
	ret

MoveSelectionScreen:
	ld hl, wEnemyMonMoves
	ld a, [wMoveSelectionMenuType]
	dec a
	jr z, .got_menu_type
	dec a
	jr z, .ether_elixer_menu
	call CheckPlayerHasUsableMoves
	ret z ; use Struggle
	ld hl, wBattleMonMoves
	jr .got_menu_type

.ether_elixer_menu
	ld a, MON_MOVES
	call GetPartyParamLocation

.got_menu_type
	ld de, wListMoves_MoveIndicesBuffer
	ld bc, NUM_MOVES
	rst CopyBytes
	xor a
	ldh [hBGMapMode], a

	hlcoord 4, 17 - NUM_MOVES - 1
	lb bc, 4, 14
	ld a, [wMoveSelectionMenuType]
	cp $2
	jr nz, .got_dims
	hlcoord 4, 17 - NUM_MOVES - 1 - 4
	lb bc, 4, 14
.got_dims
	call Textbox

	hlcoord 6, 17 - NUM_MOVES
	ld a, [wMoveSelectionMenuType]
	cp $2
	jr nz, .got_start_coord
	hlcoord 6, 17 - NUM_MOVES - 4
.got_start_coord
	ld a, SCREEN_WIDTH
	ld [wListMovesLineSpacing], a
	predef ListMoves

	ld b, 5
	ld a, [wMoveSelectionMenuType]
	cp $2
	ld a, 17 - NUM_MOVES
	jr nz, .got_default_coord
	ld b, 5
	ld a, 17 - NUM_MOVES - 4

.got_default_coord
	ld [w2DMenuCursorInitY], a
	ld a, b
	ld [w2DMenuCursorInitX], a
	ld a, [wMoveSelectionMenuType]
	cp $1
	jr z, .skip_inc
	ld a, [wCurMoveNum]
	inc a

.skip_inc
	ld [wMenuCursorY], a
	ld a, 1
	ld [wMenuCursorX], a
	ld a, [wNumMoves]
	inc a
	ld [w2DMenuNumRows], a
	ld a, 1
	ld [w2DMenuNumCols], a
	ld c, STATICMENU_ENABLE_LEFT_RIGHT | STATICMENU_ENABLE_START | STATICMENU_WRAP
	ld a, [wMoveSelectionMenuType]
	dec a
	ld b, D_DOWN | D_UP | A_BUTTON
	jr z, .okay
	dec a
	ld b, D_DOWN | D_UP | A_BUTTON | B_BUTTON
	jr z, .okay
	ld a, [wLinkMode]
	and a
	jr nz, .okay
	ld b, D_DOWN | D_UP | A_BUTTON | B_BUTTON | SELECT

.okay
	ld a, b
	ld [wMenuJoypadFilter], a
	ld a, c
	ld [w2DMenuFlags1], a
	xor a
	ld [w2DMenuFlags2], a
	ld a, $10
	ld [w2DMenuCursorOffsets], a
.menu_loop
	ld a, [wMoveSelectionMenuType]
	and a
	jr z, .battle_player_moves
	dec a
	jr nz, .interpret_joypad
	hlcoord 11, 14
	ld de, .empty_string
	rst PlaceString
	jr .interpret_joypad

.battle_player_moves
	call MoveInfoBox
	call GetWeatherImage
	ld a, [wSwappingMove]
	and a
	jr z, .interpret_joypad
	hlcoord 5, 13
	ld bc, SCREEN_WIDTH
	dec a
	rst AddNTimes
	ld [hl], "▷"

.interpret_joypad
	ld a, $1
	ldh [hBGMapMode], a
	farcall _ScrollingMenuJoypadAtk
	call GetMenuJoypad


	bit D_UP_F, a
	jmp nz, .pressed_up
	bit D_DOWN_F, a
	jmp nz, .pressed_down
	bit SELECT_F, a
	jmp nz, .pressed_select
	bit B_BUTTON_F, a
	; A button
	push af

	ld hl, WhiteCategoryIconGFX
	ld bc, 2 tiles ; Move Category is 2 Tiles wide
	rst AddNTimes
	ld d, h
	ld e, l
	ld hl, vTiles2 tile $59
	lb bc, BANK(WhiteCategoryIconGFX), 2 ; bank in 'b', Num of Tiles in 'c'
	call Request2bpp ; Load 2bpp at b:de to occupy c tiles of hl.
	hlcoord 1, 11 ; placing the Category Tiles
	ld a, $59
	ld [hli], a
	ld [hl], $5a
	ld hl, WhiteTypesIconGFX ; from gfx\battle\types.png, uses Color 4
	ld bc, 4 * LEN_1BPP_TILE ; Type GFX is 4 Tiles Wide
	rst AddNTimes
	ld d, h
	ld e, l
	ld hl, vTiles2 tile $55
	lb bc, BANK(WhiteTypesIconGFX), 4 ; bank in 'b', Num of Tiles in 'c'
	call Request1bpp
	hlcoord 4, 11
	ld a, $55
	ld [hli], a
	ld a, $56
	ld [hli], a
	ld a, $57
	ld [hli], a
	ld [hl], $58

	xor a
	ld [wSwappingMove], a
	ld hl, wMenuCursorY
	dec [hl]
	ld a, [hl]
	ld b, a
	ld a, [wMoveSelectionMenuType]
	dec a
	jr nz, .not_enemy_moves_process_b

	pop af
	ret

.not_enemy_moves_process_b
	dec a
	ld a, b
	ld [wCurMoveNum], a
	jr nz, .use_move

	pop af
	ret

.use_move
	pop af
	ret nz

	ld hl, wBattleMonPP
	ld a, [wMenuCursorY]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	and PP_MASK
	jr z, .no_pp_left
	ld a, [wPlayerDisableCount]
	swap a
	and $f
	dec a
	cp c
	jr z, .move_disabled
	ld a, [wMenuCursorY]
	ld hl, wBattleMonMoves
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wCurPlayerMove], a
	xor a
	ret

.move_disabled
	ld hl, BattleText_TheMoveIsDisabled
	jr .place_textbox_start_over

.no_pp_left
	ld hl, BattleText_TheresNoPPLeftForThisMove

.place_textbox_start_over
	push hl
	call ClearSprites
	ld b, SCGB_BATTLE_COLORS
	call GetSGBLayout
	pop hl
	call StdBattleTextbox
	call SafeLoadTempTilemapToTilemap
	jmp MoveSelectionScreen

.empty_string
	db "@"

.pressed_up
	ld a, [wMenuCursorY]
	and a
	jmp nz, .menu_loop
	ld a, [wNumMoves]
	inc a
	ld [wMenuCursorY], a
	jmp .menu_loop

.pressed_down
	ld a, [wMenuCursorY]
	ld b, a
	ld a, [wNumMoves]
	inc a
	inc a
	cp b
	jmp nz, .menu_loop
	ld a, $1
	ld [wMenuCursorY], a
	jmp .menu_loop

.pressed_select
	ld a, [wSwappingMove]
	and a
	jr z, .start_swap
	ld hl, wBattleMonMoves
	call .swap_bytes
	ld hl, wBattleMonPP
	call .swap_bytes
	ld hl, wPlayerDisableCount
	ld a, [hl]
	swap a
	and $f
	ld b, a
	ld a, [wMenuCursorY]
	cp b
	jr nz, .not_swapping_disabled_move
	ld a, [hl]
	and $f
	ld b, a
	ld a, [wSwappingMove]
	swap a
	add b
	ld [hl], a
	jr .swap_moves_in_party_struct

.not_swapping_disabled_move
	ld a, [wSwappingMove]
	cp b
	jr nz, .swap_moves_in_party_struct
	ld a, [hl]
	and $f
	ld b, a
	ld a, [wMenuCursorY]
	swap a
	add b
	ld [hl], a

.swap_moves_in_party_struct
; Fixes the COOLTRAINER glitch
	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jr nz, .transformed
	ld hl, wPartyMon1Moves
	ld a, [wCurBattleMon]
	call GetPartyLocation
	push hl
	call .swap_bytes
	pop hl
	ld bc, MON_PP - MON_MOVES
	add hl, bc
	call .swap_bytes

.transformed
	xor a
	ld [wSwappingMove], a
	jmp MoveSelectionScreen

.swap_bytes
	push hl
	ld a, [wSwappingMove]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, [wMenuCursorY]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [de]
	ld b, [hl]
	ld [hl], a
	ld a, b
	ld [de], a
	ret

.start_swap
	ld a, [wMenuCursorY]
	ld [wSwappingMove], a
	jmp MoveSelectionScreen

MoveInfoBox:
	lda_coord 4, 11
	ld[wMoveInfoBox], a
	xor a
	ldh [hBGMapMode], a

	hlcoord 0, 7 ; upper right corner of the textbox
	lb bc, 4, 7 ; (height, length)
	call Textbox

	ld a, [wPlayerDisableCount]
	and a
	jr z, .not_disabled

	swap a
	and $f
	ld b, a
	ld a, [wMenuCursorY]
	cp b
	jr nz, .not_disabled

	hlcoord 1, 11
	ld de, .Disabled
	rst PlaceString
	ret

.not_disabled
	ld hl, wMenuCursorY
	dec [hl]
	call SetPlayerTurn
	ld hl, wBattleMonMoves
	ld a, [wMenuCursorY]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wCurPlayerMove], a

	ld a, [wCurBattleMon]
	ld [wCurPartyMon], a
	ld a, WILDMON
	ld [wMonType], a
	farcall GetMaxPPOfMove

	ld hl, wMenuCursorY
	ld c, [hl]
	inc [hl]
	ld b, 0
	ld hl, wBattleMonPP
	add hl, bc
	ld a, [hl]
	and PP_MASK
	ld [wStringBuffer1], a
	call .PrintPP

	ld a, [wMoveInfoBox]
	cp $55
	jr nz, .notilesyet
	farcall LoadBattleCategoryAndTypePals
	farcall UpdateMoveData

	call GetPlayerMoveStructType
	ld hl, TypeIconGFX ; from gfx\battle\types.png, uses Color 4
	ld bc, 4 * LEN_1BPP_TILE ; Type GFX is 4 Tiles Wide
	rst AddNTimes
	ld d, h
	ld e, l
	ld hl, vTiles2 tile $55
	lb bc, BANK(TypeIconGFX), 4 ; bank in 'b', Num of Tiles in 'c'
	call Request1bpp
	hlcoord 4, 11 ; placing the Type Tiles in  the MoveInfoBox
	ld a, $55
	ld [hli], a
	ld a, $56
	ld [hli], a
	ld a, $57
	ld [hli], a
	ld [hl], $58

	call GetPlayerMoveStructCategory
	ld hl, CategoryIconGFX
	ld bc, 2 tiles ; Move Category is 2 Tiles wide
	rst AddNTimes
	ld d, h
	ld e, l
	ld hl, vTiles2 tile $59
	lb bc, BANK(CategoryIconGFX), 2 ; bank in 'b', Num of Tiles in 'c'
	call Request2bpp ; Load 2bpp at b:de to occupy c tiles of hl.
	hlcoord 1, 11 ; placing the Category Tiles in the MoveInfoBox
	ld a, $59
	ld [hli], a
	ld [hl], $5a

	ld b, SCGB_BATTLE_COLORS
	call GetSGBLayout

.notilesyet
	farcall UpdateMoveData

; print move BP (Base Power)
	ld de, .power_string ; "BP"
	hlcoord 1, 8
	rst PlaceString

	hlcoord 4, 8
	ld a, [wPlayerMoveStruct + MOVE_POWER]
	and a
	jr nz, .haspower
	ld de, .nopower_string ; "---"
	rst PlaceString
	jr .print_acc
.haspower
	ld [wTextDecimalByte], a
	ld de, wTextDecimalByte
	lb bc, 1, 3 ; number of bytes this number is in, in 'b', number of possible digits in 'c'
	call PrintNum

; print move ACC
.print_acc
	hlcoord 1, 9
	ld de, .accuracy_string ; "ACC"
	rst PlaceString
	hlcoord 7, 9
	ld [hl], "<%>"
	ld a, [wPlayerMoveStruct + MOVE_ACC]
; convert from hex to decimal
	call Adjust_percent
	hlcoord 4, 9
.print_num
	ld [wTextDecimalByte], a
	ld de, wTextDecimalByte
	lb bc, 1, 3 ; number of bytes this number is in, in 'b', number of possible digits in 'c'
	jmp PrintNum

.Disabled:
	db "Disabled!@"
.Type:
	db "TYPE/@"

.PrintPP:
	hlcoord 3, 10
	push hl
	ld de, wStringBuffer1
	lb bc, 1, 2
	call PrintNum
	pop hl
	inc hl
	inc hl
	ld a, "/"
	ld [hli], a
	ld de, wNamedObjectIndex
	lb bc, 1, 2
	call PrintNum
	hlcoord 1, 10
	ld a, "P"
	ld [hli], a
	ld [hl], a
	ret

.power_string:
	db "BP@"
.nopower_string:
	db "---@"
.accuracy_string:
	db "AC@"

CheckPlayerHasUsableMoves:
	ld a, STRUGGLE
	ld [wCurPlayerMove], a
	ld a, [wPlayerDisableCount]
	and a
	ld hl, wBattleMonPP
	jr nz, .disabled

	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	inc hl
	or [hl]
	and PP_MASK
	ret nz
	jr .force_struggle

.disabled
	swap a
	and $f
	ld b, a
	ld d, NUM_MOVES + 1
	xor a
.loop
	dec d
	jr z, .done
	ld c, [hl] ; no-optimize b|c|d|e = *hl++|*hl-- (a is used.)
	inc hl
	dec b
	jr z, .loop
	or c
	jr .loop

.done
	and PP_MASK
	ret nz

.force_struggle
	ld hl, BattleText_MonHasNoMovesLeft
	call StdBattleTextbox
	ld c, 60
	call DelayFrames
	xor a
	ret

ParseEnemyAction:
	ld a, [wEnemyIsSwitching]
	and a
	ret nz
	ld hl, wEnemySubStatus5
	bit SUBSTATUS_ENCORED, [hl]
	jr z, .skip_encore
	ld a, [wLastEnemyMove]
	jr .finish

.skip_encore
	call CheckEnemyLockedIn
	jmp nz, ResetVarsForSubstatusRage
	jr .continue

.skip_turn
	ld a, $ff
	jr .finish

.continue
	ld hl, wEnemyMonMoves
	ld de, wEnemyMonPP
	ld b, NUM_MOVES
.loop
	ld a, [hl]
	and a
	jr z, .struggle
	ld a, [wEnemyDisabledMove]
	cp [hl]
	jr z, .disabled
	ld a, [de]
	and PP_MASK
	jr nz, .enough_pp

.disabled
	inc hl
	inc de
	dec b
	jr nz, .loop
	jr .struggle

.enough_pp
	ld a, [wBattleMode]
	dec a
	jr nz, .skip_load
; wild
.loop2
	ld hl, wEnemyMonMoves
	call BattleRandom
	maskbits NUM_MOVES
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wEnemyDisableCount]
	swap a
	and $f
	dec a
	cp c
	jr z, .loop2
	ld a, [hl]
	and a
	jr z, .loop2
	ld hl, wEnemyMonPP
	add hl, bc
	ld b, a
	ld a, [hl]
	and PP_MASK
	jr z, .loop2
	ld a, c
	ld [wCurEnemyMoveNum], a
	ld a, b

.finish
	ld [wCurEnemyMove], a

.skip_load
	call SetEnemyTurn
	farcall UpdateMoveData
	call CheckEnemyLockedIn
	jr nz, .raging
	xor a
	ld [wEnemyCharging], a

.raging
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp EFFECT_FURY_CUTTER
	jr z, .fury_cutter
	xor a
	ld [wEnemyFuryCutterCount], a

.fury_cutter
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp EFFECT_RAGE
	jr z, .no_rage
	ld hl, wEnemySubStatus4
	res SUBSTATUS_RAGE, [hl]
	xor a
	ld [wEnemyRageCounter], a

.no_rage
	ld a, [wEnemyMoveStruct + MOVE_EFFECT]
	cp EFFECT_PROTECT
	ret z
	cp EFFECT_ENDURE
	ret z
	xor a
	ld [wEnemyProtectCount], a
	ret

.struggle
	ld a, STRUGGLE
	jr .finish

ResetVarsForSubstatusRage:
	xor a
	ld [wEnemyFuryCutterCount], a
	ld [wEnemyProtectCount], a
	ld [wEnemyRageCounter], a
	ld hl, wEnemySubStatus4
	res SUBSTATUS_RAGE, [hl]
	ret

CheckEnemyLockedIn:
	ld a, [wEnemySubStatus4]
	and 1 << SUBSTATUS_RECHARGE
	ret nz

	ld a, [wEnemySubStatus3]
	and 1 << SUBSTATUS_CHARGED | 1 << SUBSTATUS_RAMPAGE | 1 << SUBSTATUS_BIDE
	ret nz

	ld hl, wEnemySubStatus1
	bit SUBSTATUS_ROLLOUT, [hl]
	ret

LoadEnemyMon:
; Initialize enemy monster parameters
; To do this we pull the species from wTempEnemyMonSpecies

; Notes:
;   BattleRandom is used to ensure sync between Game Boys

; Clear the whole enemy mon struct (wEnemyMon)
	xor a
	ld hl, wEnemyMonSpecies
	ld bc, wEnemyMonEnd - wEnemyMon
	rst ByteFill

; We don't need to be here if we're in a link battle
	ld a, [wLinkMode]
	and a
	jmp nz, InitEnemyMon

; and also not in a BattleTower-Battle
	ld a, [wInBattleTowerBattle]
	bit 0, a
	jmp nz, InitEnemyMon

; Make sure everything knows what species we're working with
	ld a, [wTempEnemyMonSpecies]
	ld [wEnemyMonSpecies], a
	ld [wCurSpecies], a
	ld [wCurPartySpecies], a

; Grab the BaseData for this species
	call GetBaseData

; Let's get the item:

; Is the item predetermined?
	ld a, [wBattleMode]
	dec a
	jr z, .WildItem

; If we're in a trainer battle, the item is in the party struct
	ld a, [wCurPartyMon]
	ld hl, wOTPartyMon1Item
	call GetPartyLocation ; bc = PartyMon[wCurPartyMon] - wPartyMons
	ld a, [hl]
	jr .UpdateItem

.WildItem:
; In a wild battle, we pull from the item slots in BaseData

; Force Item1
; Used for Ho-Oh, Lugia and Snorlax encounters
	ld a, [wBattleType]
	cp BATTLETYPE_FORCEITEM
	ld a, [wBaseItem1]
	jr z, .UpdateItem

; Failing that, it's all up to chance
;  Effective chances:
;    45% None
;    50% Item1
;     5% Item2

; 50% chance of getting an item
	call BattleRandom
	cp 50 percent + 1
	ld a, [wBaseItem1]
	jr c, .UpdateItem

; 5% chance of getting Item2 (10% of 50% = 5%)
	call BattleRandom
	cp 10 percent + 1
	ld a, [wBaseItem2]
	jr c, .UpdateItem

; 45% chance of not getting an item (100% - 50% - 5% = 45%)
	xor a ; NO_ITEM

.UpdateItem:
	ld [wEnemyMonItem], a

; Initialize DVs

; If we're in a trainer battle, DVs are predetermined
	ld a, [wBattleMode]
	and a
	jr z, .InitDVs

	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jr z, .InitDVs

; Unknown
	ld hl, wEnemyBackupDVs
	ld de, wEnemyMonDVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	jmp .Happiness

.InitDVs:
	ld a, [wBattleMode]
	dec a
	jr z, .WildDVs

	; Trainer DVs
	ld a, [wCurPartyMon]
	ld hl, wOTPartyMon1DVs
	call GetPartyLocation
	ld a, [hli]
	ld b, a
	ld c, [hl]
	jr .UpdateDVs

.WildDVs:
; Wild DVs
; Here's where the fun starts

; Roaming monsters (Entei, Raikou) work differently
; They have their own structs, which are shorter than normal
	ld a, [wBattleType]
	cp BATTLETYPE_ROAMING
	jr nz, .NotRoaming

; Grab HP
	call GetRoamMonHP
	ld a, [hl]
; Check if the HP has been initialized
	and a
; We'll do something with the result in a minute
	push af

; Grab DVs
	call GetRoamMonDVs
	inc hl
	ld a, [hld]
	ld c, a
	ld b, [hl]

; Get back the result of our check
	pop af
; If the RoamMon struct has already been initialized, we're done
	jr nz, .UpdateDVs

; If it hasn't, we need to initialize the DVs
; (HP is initialized at the end of the battle)
	call GetRoamMonDVs
	inc hl
	call BattleRandom
	ld [hld], a
	ld c, a
	call BattleRandom
	ld [hl], a
	ld b, a
; We're done with DVs
	jr .UpdateDVs

.NotRoaming:
; Register a contains wBattleType

; Forced shiny battle type
; Used by Red Gyarados at Lake of Rage
	cp BATTLETYPE_FORCESHINY
	jr nz, .GenerateDVs

	lb bc, ATKDEFDV_SHINY, DV_SHINY2
	jr .UpdateDVs

.GenerateDVs:
;checkswarm
	ld hl, wDailyFlags1
	bit DAILYFLAGS1_SWARM_F, [hl]
	jr z, .skipspecial

	farcall GenerateSwarmSpecial
	jr .next

.skipspecial:
; Generate new random DVs
	call BattleRandom
	ld b, a
	call BattleRandom
	ld c, a

.UpdateDVs:
; Input DVs in register bc
	ld hl, wEnemyMonDVs
	ld a, b
	ld [hli], a
	ld [hl], c

.next
; We've still got more to do if we're dealing with a wild monster
	ld a, [wBattleMode]
	dec a
	jr nz, .Happiness

; Species-specfic:

; Unown
	ld a, [wTempEnemyMonSpecies]
	cp UNOWN
	jr nz, .Magikarp

; Get letter based on DVs
	ld hl, wEnemyMonDVs
	predef GetUnownLetter
; Can't use any letters that haven't been unlocked
; If combined with forced shiny battletype, causes an infinite loop
	call CheckUnownLetter
	jr c, .GenerateDVs ; try again

.Magikarp:
; These filters are untranslated.
; They expect at wMagikarpLength a 2-byte value in mm,
; but the value is in feet and inches (one byte each).

; The first filter is supposed to make very large Magikarp even rarer,
; by targeting those 1600 mm (= 5'3") or larger.
; After the conversion to feet, it is unable to target any,
; since the largest possible Magikarp is 5'3", and $0503 = 1283 mm.
	ld a, [wTempEnemyMonSpecies]
	cp MAGIKARP
	jr nz, .Happiness

; Get Magikarp's length
	ld de, wEnemyMonDVs
	ld bc, wPlayerID
	farcall CalcMagikarpLength

; No reason to keep going if length > 1536 mm (i.e. if HIGH(length) > 6 feet)
	ld a, [wMagikarpLength]
	cp 5
	jr nz, .CheckMagikarpArea

; 5% chance of skipping both size checks
	call Random
	cp 5 percent
	jr c, .CheckMagikarpArea
; Try again if length >= 1616 mm (i.e. if LOW(length) >= 4 inches)
	ld a, [wMagikarpLength + 1]
	cp 4
	jr nc, .GenerateDVs

; 20% chance of skipping this check
	call Random
	cp 20 percent - 1
	jr c, .CheckMagikarpArea
; Try again if length >= 1600 mm (i.e. if LOW(length) >= 3 inches)
	ld a, [wMagikarpLength + 1]
	cp 3
	jr nc, .GenerateDVs

.CheckMagikarpArea:
	ld a, [wMapGroup]
	cp GROUP_LAKE_OF_RAGE
	jr nz, .Happiness
	ld a, [wMapNumber]
	cp MAP_LAKE_OF_RAGE
	jr nz, .Happiness
; 40% chance of not flooring
	call Random
	cp 39 percent + 1
	jr c, .Happiness
; Try again if length < 1024 mm (i.e. if HIGH(length) < 3 feet)
	ld a, [wMagikarpLength]
	cp 3
	jmp c, .GenerateDVs ; try again

; Finally done with DVs

.Happiness:
; Set happiness
	ld a, BASE_HAPPINESS
	ld [wEnemyMonHappiness], a
; Set level. If level > 100, then the level will depend on the level of the party
	ld a, [wCurPartyLevel]
	ld [wEnemyMonLevel], a
; Fill stats
	ld de, wEnemyMonMaxHP
	ld b, FALSE
	ld hl, wEnemyMonDVs - (MON_DVS - MON_STAT_EXP + 1)
	ld a, [wBattleMode]
	cp TRAINER_BATTLE
	jr nz, .no_stat_exp
	ld a, [wCurPartyMon]
	ld hl, wOTPartyMon1StatExp - 1
	call GetPartyLocation
	ld b, TRUE
.no_stat_exp
	predef CalcMonStats

; If we're in a trainer battle,
; get the rest of the parameters from the party struct
	ld a, [wBattleMode]
	cp TRAINER_BATTLE
	jr z, .OpponentParty

; If we're in a wild battle, check wild-specific stuff
	and a
	jr z, .TreeMon

	ld a, [wEnemySubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jr nz, .Moves

.TreeMon:
; If we're headbutting trees, some monsters enter battle asleep.
; Otherwise, no status
	call CheckSleepingTreeMon
	ld a, TREEMON_SLEEP_TURNS
	sbc a
	and TREEMON_SLEEP_TURNS

	ld hl, wEnemyMonStatus
	ld [hli], a

; Unused byte
	xor a
	ld [hli], a

; Full HP..
	ld a, [wEnemyMonMaxHP]
	ld [hli], a
	ld a, [wEnemyMonMaxHP + 1]
	ld [hl], a

; ..unless it's a RoamMon
	ld a, [wBattleType]
	cp BATTLETYPE_ROAMING
	jr nz, .Moves

; Grab HP
	call GetRoamMonHP
	ld a, [hl]
; Check if it's been initialized again
	and a
	jr z, .InitRoamHP
; Update from the struct if it has
	ld a, [hl]
	ld [wEnemyMonHP + 1], a
	jr .Moves

.InitRoamHP:
; HP only uses the lo byte in the RoamMon struct since
; Raikou and Entei will have < 256 hp at level 40
	ld a, [wEnemyMonHP + 1]
	ld [hl], a
	jr .Moves

.OpponentParty:
; Get HP from the party struct
	ld hl, (wOTPartyMon1HP + 1)
	ld a, [wCurPartyMon]
	call GetPartyLocation
	ld a, [hld]
	ld [wEnemyMonHP + 1], a
	ld a, [hld]
	ld [wEnemyMonHP], a

; Make sure everything knows which monster the opponent is using
	ld a, [wCurPartyMon]
	ld [wCurOTMon], a

; Get status from the party struct
	dec hl
	ld a, [hl] ; OTPartyMonStatus
	ld [wEnemyMonStatus], a

.Moves:
	ld hl, wBaseType1
	ld de, wEnemyMonType1
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

; Get moves
	ld de, wEnemyMonMoves
; Are we in a trainer battle?
	ld a, [wBattleMode]
	cp TRAINER_BATTLE
	jr nz, .WildMoves
; Then copy moves from the party struct
	ld hl, wOTPartyMon1Moves
	ld a, [wCurPartyMon]
	call GetPartyLocation
	ld bc, NUM_MOVES
	rst CopyBytes
	jr .PP

.WildMoves:
; Clear wEnemyMonMoves
	xor a
	ld h, d
	ld l, e
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [wSkipMovesBeforeLevelUp], a
; Fill moves based on level
	predef FillMoves
	farcall CheckUniqueWildMove

.PP:
; Trainer battle?
	ld a, [wBattleMode]
	cp TRAINER_BATTLE
	jr z, .TrainerPP

; Fill wild PP
	ld hl, wEnemyMonMoves
	ld de, wEnemyMonPP
	predef FillPP
	jr .Finish

.TrainerPP:
; Copy PP from the party struct
	ld hl, wOTPartyMon1PP
	ld a, [wCurPartyMon]
	call GetPartyLocation
	ld de, wEnemyMonPP
	ld bc, NUM_MOVES
	rst CopyBytes

.Finish:
; Copy the first five base stats (the enemy mon's base Sp. Atk
; is also used to calculate Sp. Def stat experience)
	ld hl, wBaseStats
	ld de, wEnemyMonBaseStats
	ld b, NUM_STATS - 1
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop

	ld a, [wBaseCatchRate]
	ld [de], a
	inc de

	ld a, [wBaseExp]
	ld [de], a

	ld a, [wTempEnemyMonSpecies]
	ld [wNamedObjectIndex], a

; Did we catch it?
	ld a, [wBattleMode]
	and a
	ret z

; Update enemy nickname
	ld a, [wBattleMode]
	dec a ; WILD_BATTLE?
	jr z, .no_nickname
	ld a, [wOtherTrainerType]
	bit TRAINERTYPE_NICKNAME_F, a
	jr z, .no_nickname
	ld a, [wCurPartyMon]
	ld hl, wOTPartyMonNicknames
	ld bc, MON_NAME_LENGTH
	rst AddNTimes
	ld a, [hl]
	cp "@"
	jr nz, .got_nickname
.no_nickname
	call GetPokemonName
	ld hl, wStringBuffer1
.got_nickname
	ld de, wEnemyMonNickname
	ld bc, MON_NAME_LENGTH
	rst CopyBytes

; Saw this mon
	ld a, [wTempEnemyMonSpecies]
	dec a
	ld c, a
	ld b, SET_FLAG
	ld hl, wPokedexSeen
	predef SmallFarFlagAction

	ld hl, wEnemyMonStats
	ld de, wEnemyStats
	ld bc, NUM_BATTLE_STATS * 2
	rst CopyBytes

	jmp ApplyStatusEffectOnEnemyStats

CheckSleepingTreeMon:
; Return carry if species is in the list
; for the current time of day

; Don't do anything if this isn't a tree encounter
	ld a, [wBattleType]
	cp BATTLETYPE_TREE
	jr nz, .NotSleeping

; Get list for the time of day
	ld hl, AsleepTreeMonsMorn
	ld a, [wTimeOfDay]
	cp DAY_F
	jr c, .Check
	ld hl, AsleepTreeMonsDay
	jr z, .Check
	ld hl, AsleepTreeMonsNite

.Check:
	ld a, [wTempEnemyMonSpecies]
	ld de, 1 ; length of species id
	call IsInArray
; If it's a match, the opponent is asleep
	ret c

.NotSleeping:
	and a
	ret

INCLUDE "data/wild/treemons_asleep.asm"

CheckUnownLetter:
; Return carry if the Unown letter hasn't been unlocked yet

	ld a, [wUnlockedUnowns]
	ld c, a
	ld de, 0

.loop

; Don't check this set unless it's been unlocked
	srl c
	jr nc, .next

; Is our letter in the set?
	ld hl, UnlockedUnownLetterSets
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a

	push de
	ld a, [wUnownLetter]
	push bc
	call IsInByteArray
	pop bc
	pop de

	jr c, .match

.next
; Make sure we haven't gone past the end of the table
	inc e
	inc e
	ld a, e
	cp NUM_UNLOCKED_UNOWN_SETS * 2
	jr c, .loop

; Hasn't been unlocked, or the letter is invalid
	scf
	ret

.match
; Valid letter
	and a
	ret

INCLUDE "data/wild/unlocked_unowns.asm"

BattleWinSlideInEnemyTrainerFrontpic:
	xor a
	ld [wTempEnemyMonSpecies], a
	call FinishBattleAnim
	ld a, [wOtherTrainerClass]
	ld [wTrainerClass], a
	ld de, vTiles2
	farcall GetTrainerPic
	hlcoord 19, 0
	ld c, 0

.outer_loop
	inc c
	ld a, c
	cp 7
	ret z
	xor a
	ldh [hBGMapMode], a
	ldh [hBGMapThird], a
	ld d, $0
	push bc
	push hl

.inner_loop
	call .CopyColumn
	inc hl
	ld a, 7
	add d
	ld d, a
	dec c
	jr nz, .inner_loop

	ld a, $1
	ldh [hBGMapMode], a
	ld c, 4
	call DelayFrames
	pop hl
	pop bc
	dec hl
	jr .outer_loop

.CopyColumn:
	push hl
	push de
	push bc
	ld e, 7

.loop
	ld [hl], d
	ld bc, SCREEN_WIDTH
	add hl, bc
	inc d
	dec e
	jr nz, .loop

	pop bc
	pop de
	pop hl
	ret

ApplyStatusEffectOnPlayerStats:
	ld a, 1
	jr ApplyStatusEffectOnStats

ApplyStatusEffectOnEnemyStats:
	xor a

ApplyStatusEffectOnStats:
	ldh [hBattleTurn], a
	call ApplyPrzEffectOnSpeed

ApplyBrnEffectOnAttack:
	ldh a, [hBattleTurn]
	and a
	jr z, .enemy
	ld a, [wBattleMonStatus]
	and 1 << BRN
	ret z
	ld hl, wBattleMonAttack + 1
	ld a, [hld]
	ld b, a
	ld a, [hl]
	srl a
	rr b
	ld [hli], a
	or b
	jr nz, .player_ok
	ld b, $1 ; min attack

.player_ok
	ld [hl], b
	ret

.enemy
	ld a, [wEnemyMonStatus]
	and 1 << BRN
	ret z
	ld hl, wEnemyMonAttack + 1
	ld a, [hld]
	ld b, a
	ld a, [hl]
	srl a
	rr b
	ld [hli], a
	or b
	jr nz, .enemy_ok
	ld b, $1 ; min attack

.enemy_ok
	ld [hl], b
	ret

ApplyPrzEffectOnSpeed:
	ldh a, [hBattleTurn]
	and a
	jr z, .enemy
	ld a, [wBattleMonStatus]
	and 1 << PAR
	ret z
	ld hl, wBattleMonSpeed + 1
	ld a, [hld]
	ld b, a
	ld a, [hl]
	srl a
	rr b
	srl a
	rr b
	ld [hli], a
	or b
	jr nz, .player_ok
	ld b, $1 ; min speed

.player_ok
	ld [hl], b
	ret

.enemy
	ld a, [wEnemyMonStatus]
	and 1 << PAR
	ret z
	ld hl, wEnemyMonSpeed + 1
	ld a, [hld]
	ld b, a
	ld a, [hl]
	srl a
	rr b
	srl a
	rr b
	ld [hli], a
	or b
	jr nz, .enemy_ok
	ld b, $1 ; min speed

.enemy_ok
	ld [hl], b
	ret

ApplyStatLevelMultiplierOnAllStats:
; Apply StatLevelMultipliers on all 5 Stats
	ld c, 0
.stat_loop
	call ApplyStatLevelMultiplier
	inc c
	ld a, c
	cp NUM_BATTLE_STATS
	jr nz, .stat_loop
	ret

ApplyStatLevelMultiplier:
	push bc
	push bc
	ld a, [wApplyStatLevelMultipliersToEnemy]
	and a
	ld a, c
	ld hl, wBattleMonAttack
	ld de, wPlayerStats
	ld bc, wPlayerAtkLevel
	jr z, .got_pointers
	ld hl, wEnemyMonAttack
	ld de, wEnemyStats
	ld bc, wEnemyAtkLevel

.got_pointers
	add c
	ld c, a
	adc b
	sub c
	ld b, a
	ld a, [bc]
	pop bc
	ld b, a
	push bc
	sla c
	ld b, 0
	add hl, bc
	ld a, c
	add e
	ld e, a
	adc d
	sub e
	ld d, a
	pop bc
	push hl
	ld hl, StatLevelMultipliers_Applied
	dec b
	sla b
	ld c, b
	ld b, 0
	add hl, bc
	xor a
	ldh [hMultiplicand + 0], a
	ld a, [de]
	ldh [hMultiplicand + 1], a
	inc de
	ld a, [de]
	ldh [hMultiplicand + 2], a
	ld a, [hli]
	ldh [hMultiplier], a
	call Multiply
	ld a, [hl]
	ldh [hDivisor], a
	ld b, 4
	call Divide
	pop hl

; Cap at 999.
	ldh a, [hQuotient + 3]
	sub LOW(MAX_STAT_VALUE)
	ldh a, [hQuotient + 2]
	sbc HIGH(MAX_STAT_VALUE)
	jr c, .okay3

	ld a, HIGH(MAX_STAT_VALUE)
	ldh [hQuotient + 2], a
	ld a, LOW(MAX_STAT_VALUE)
	ldh [hQuotient + 3], a

.okay3
	ldh a, [hQuotient + 2]
	ld [hli], a
	ld b, a
	ldh a, [hQuotient + 3]
	ld [hl], a
	or b
	jr nz, .okay4
	inc [hl]

.okay4
	pop bc
	ret

INCLUDE "data/battle/stat_multipliers_2.asm"

_LoadBattleFontsHPBar:
	farjp LoadBattleFontsHPBar

_LoadHPBar:
	farjp LoadHPBar

EmptyBattleTextbox:
	ld hl, .empty
	jmp BattleTextbox

.empty:
	text_end

_BattleRandom::
; If the normal RNG is used in a link battle it'll desync.
; To circumvent this a shared PRNG is used instead.

; But if we're in a non-link battle we're safe to use it
	ld a, [wLinkMode]
	and a
	jmp z, Random

; The PRNG operates in streams of 10 values.

; Which value are we trying to pull?
	push hl
	push bc
	ld a, [wLinkBattleRNCount]
	ld c, a
	ld b, 0
	ld hl, wLinkBattleRNs
	add hl, bc
	inc a
	ld [wLinkBattleRNCount], a

; If we haven't hit the end yet, we're good
	cp 10 - 1 ; Exclude last value. See the closing comment
	ld a, [hl]
	pop bc
	pop hl
	ret c

; If we have, we have to generate new pseudorandom data
; Instead of having multiple PRNGs, ten seeds are used
	push hl
	push bc
	push af

; Reset count to 0
	xor a
	ld [wLinkBattleRNCount], a
	ld hl, wLinkBattleRNs
	ld b, 10 ; number of seeds

; Generate next number in the sequence for each seed
; a[n+1] = (a[n] * 5 + 1) % 256
.loop
	; get last #
	ld a, [hl]

	; a * 5 + 1
	ld c, a
	add a
	add a
	add c
	inc a

	; update #
	ld [hli], a
	dec b
	jr nz, .loop

; This has the side effect of pulling the last value first,
; then wrapping around. As a result, when we check to see if
; we've reached the end, we check the one before it.

	pop af
	pop bc
	pop hl
	ret

Call_PlayBattleAnim_OnlyIfVisible:
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	ret nz

Call_PlayBattleAnim:
	ld a, e
	ld [wFXAnimID], a
	ld a, d
	ld [wFXAnimID + 1], a
	call WaitBGMap
	predef_jump PlayBattleAnim

FinishBattleAnim:
	push af
	push bc
	push de
	push hl
	ld b, SCGB_BATTLE_COLORS
	call GetSGBLayout
	call SetDefaultBGPAndOBP
	call DelayFrame
	pop hl
	pop de
	pop bc
	pop af
	ret

GiveExperiencePoints:
; Give experience.
; Don't give experience if linked or in the Battle Tower.
	ld a, [wLinkMode]
	and a
	ret nz

	ld a, [wInBattleTowerBattle]
	bit 0, a
	ret nz

	call .EvenlyDivideExpAmongParticipants

	xor a
	ld [wCurPartyMon], a
	ld bc, wPartyMon1Species

.loop
	ld hl, MON_HP
	add hl, bc
	ld a, [hli]
	or [hl]
	jmp z, .next_mon ; fainted

	push bc
	ld hl, wBattleParticipantsNotFainted
	ld a, [wCurPartyMon]
	ld c, a
	ld b, CHECK_FLAG
	ld d, 0
	predef SmallFarFlagAction
	ld a, c
	and a
	pop bc
	jmp z, .next_mon

; give stat exp
	ld hl, MON_STAT_EXP + 1
	add hl, bc
	ld d, h
	ld e, l
	ld hl, wEnemyMonBaseStats - 1
	push bc
	ld c, NUM_EXP_STATS
.stat_exp_loop
	inc hl
	ld a, [de]
	add [hl]
	ld [de], a
	jr nc, .no_carry_stat_exp
	dec de
	ld a, [de]
	inc a
	jr z, .stat_exp_maxed_out
	ld [de], a
	inc de

.no_carry_stat_exp
	push hl
	push bc
	ld a, MON_POKERUS
	call GetPartyParamLocation
	ld a, [hl]
	and a
	pop bc
	pop hl
	jr z, .stat_exp_awarded
	ld a, [de]
	add [hl]
	ld [de], a
	jr nc, .stat_exp_awarded
	dec de
	ld a, [de]
	inc a
	jr z, .stat_exp_maxed_out
	ld [de], a
	inc de
	jr .stat_exp_awarded

.stat_exp_maxed_out
	ld a, $ff
	ld [de], a
	inc de
	ld [de], a

.stat_exp_awarded
	inc de
	inc de
	dec c
	jr nz, .stat_exp_loop
; No Experience al nivel 100
	pop bc
	ld hl, MON_LEVEL
	add hl, bc
	ld a, [hl]
	cp MAX_LEVEL
	jp nc, .next_mon
	push bc
; Experience
	ld a, [wEnemyMonLevel]
	ld d, a
; Calc the Exp Points
	xor a
	ldh [hMultiplicand + 0], a
	ldh [hMultiplicand + 1], a
	ld a, [wEnemyMonBaseExp]
	ldh [hMultiplicand + 2], a
	ld a, d
	ldh [hMultiplier], a
	call Multiply
	ld a, 7
	ldh [hDivisor], a
	ld b, 4
	call Divide
; Level Scaling para participantes
	pop bc
	ld hl, MON_LEVEL
	add hl, bc
	ld a, [hl]	;Nivel del pokemon
	push bc
	ld b, a
	ld a, [wEnemyMonLevel]
	sub b
	jr c, .noscaling	;Solo si nuestro pokemon tiene menor nivel
	ld a, [wEnemyMonLevel]	; Nivel del otro pokemon
	ldh [hMultiplier], a
	call Multiply
	ld a, b 	; Nivel de nuestro pokemon
	ldh [hDivisor], a
	ld b, 4
	call Divide
.noscaling
; Boost Experience for traded Pokemon
	pop bc
	ld hl, MON_ID
	add hl, bc
	ld a, [wPlayerID]
	cp [hl]
	jr nz, .boosted
	inc hl
	ld a, [wPlayerID + 1]
	cp [hl]
	ld a, 0	; no-optimize a = 0
	jr z, .no_boost

.boosted
	call BoostExp
	ld a, 1

.no_boost
; Boost experience for a Trainer Battle
	ld [wStringBuffer2 + 2], a
	ld a, [wBattleMode]
	dec a
	call nz, BoostExp
; Boost experience for Lucky Egg
	push bc
	ld a, MON_ITEM
	call GetPartyParamLocation
	ld a, [hl]
	cp LUCKY_EGG
	call z, BoostExp
; Show text
	ldh a, [hQuotient + 3]
	ld [wStringBuffer2 + 1], a
	ldh a, [hQuotient + 2]
	ld [wStringBuffer2], a
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames
	call GetNickname
	;Mostrar texto sola una vez para el resto
	ld a, [wExpShare]
	and a
	jr nz, .ExpShareON	;Comentar esta línea para mostrar la exp ganada por todos los pokes
	ld hl, Text_MonGainedExpPoint
	jr .Text
.ExpShareON
	ld a, [wExpShareText]
	and a
	jr nz, .AfterText
	inc a
	ld [wExpShareText], a
	ld hl, Text_TeamGainedExpPoint	;Texto "Resto del equipo"
.Text
	call BattleTextbox
.AfterText
	ld a, [wStringBuffer2 + 1]
	ldh [hQuotient + 3], a
	ld a, [wStringBuffer2]
	ldh [hQuotient + 2], a
; Give Exp
	pop bc
	call AnimateExpBar
	push bc
	call LoadTilemapToTempTilemap
	pop bc
	ld hl, MON_EXP + 2
	add hl, bc
	ld d, [hl]
	ldh a, [hQuotient + 3]
	add d
	ld [hld], a
	ld d, [hl]
	ldh a, [hQuotient + 2]
	adc d
	ld [hl], a
	jr nc, .no_exp_overflow
	dec hl
	inc [hl]
	jr nz, .no_exp_overflow
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hl], a

.no_exp_overflow
	ld a, [wCurPartyMon]
	ld e, a
	ld d, 0
	ld hl, wPartySpecies
	add hl, de
	ld a, [hl]
	ld [wCurSpecies], a
	call GetBaseData
	push bc
	ld d, MAX_LEVEL
	farcall CalcExpAtLevel
	pop bc
	ld hl, MON_EXP + 2
	add hl, bc
	push bc
	ldh a, [hQuotient + 1]
	ld b, a
	ldh a, [hQuotient + 2]
	ld c, a
	ldh a, [hQuotient + 3]
	ld d, a
	ld a, [hld]
	sub d
	ld a, [hld]
	sbc c
	ld a, [hl]
	sbc b
	jr c, .not_max_exp
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hld], a

.not_max_exp
; Check if the mon leveled up
	xor a ; PARTYMON
	ld [wMonType], a
	predef CopyMonToTempMon
	call CalcLevelExp
	pop bc
	ld hl, MON_LEVEL
	add hl, bc
	ld a, [hl]
	cp MAX_LEVEL
	jmp nc, .next_mon
	cp d
	jmp z, .next_mon
; <NICKNAME> grew to level ##!
	ld [wTempLevel], a
	ld a, [wCurPartyLevel]
	push af
	ld a, d
	ld [wCurPartyLevel], a
	ld [hl], a
	ld hl, MON_SPECIES
	add hl, bc
	ld a, [hl]
	ld [wCurSpecies], a
	ld [wTempSpecies], a ; unused?
	call GetBaseData
	ld hl, MON_MAXHP + 1
	add hl, bc
	ld a, [hld]
	ld e, a
	ld d, [hl]
	push de
	ld hl, MON_MAXHP
	add hl, bc
	ld d, h
	ld e, l
	ld hl, MON_STAT_EXP - 1
	add hl, bc
	push bc
	ld b, TRUE
	predef CalcMonStats
	pop bc
	pop de
	ld hl, MON_MAXHP + 1
	add hl, bc
	ld a, [hld]
	sub e
	ld e, a
	ld a, [hl]
	sbc d
	ld d, a
	dec hl
	ld a, [hl]
	add e
	ld [hld], a
	ld a, [hl]
	adc d
	ld [hl], a
	ld a, [wCurBattleMon]
	ld d, a
	ld a, [wCurPartyMon]
	cp d
	jr nz, .skip_active_mon_update
	ld de, wBattleMonHP
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld de, wBattleMonMaxHP
	push bc
	ld bc, PARTYMON_STRUCT_LENGTH - MON_MAXHP
	rst CopyBytes
	pop bc
	ld hl, MON_LEVEL
	add hl, bc
	ld a, [hl]
	ld [wBattleMonLevel], a
	ld a, [wPlayerSubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jr nz, .transformed
	ld hl, MON_ATK
	add hl, bc
	ld de, wPlayerStats
	ld bc, PARTYMON_STRUCT_LENGTH - MON_ATK
	rst CopyBytes

.transformed
	xor a ; FALSE
	ld [wApplyStatLevelMultipliersToEnemy], a
	call ApplyStatLevelMultiplierOnAllStats
	call ApplyStatusEffectOnPlayerStats
	call UpdatePlayerHUD
	call EmptyBattleTextbox
	call LoadTilemapToTempTilemap
	ld a, $1
	ldh [hBGMapMode], a

.skip_active_mon_update
	farcall LevelUpHappinessMod
	ld a, [wCurBattleMon]
	ld b, a
	ld a, [wCurPartyMon]
	cp b
	jr z, .skip_exp_bar_animation
	ld de, SFX_HIT_END_OF_EXP_BAR
	call PlaySFX
	call WaitSFX
	ld hl, BattleText_StringBuffer1GrewToLevel
	call StdBattleTextbox
	call LoadTilemapToTempTilemap

.skip_exp_bar_animation
	xor a ; PARTYMON
	ld [wMonType], a
	predef CopyMonToTempMon
	hlcoord 9, 0
	lb bc, 10, 9
	call Textbox
	hlcoord 11, 1
	ld bc, 4
	predef PrintTempMonStats
	ld c, 30
	call DelayFrames
	call WaitPressAorB_BlinkCursor
	call SafeLoadTempTilemapToTilemap
	xor a ; PARTYMON
	ld [wMonType], a
	ld a, [wCurSpecies]
	ld [wTempSpecies], a ; unused?
	ld a, [wCurPartyLevel]
	push af
	ld c, a
	ld a, [wTempLevel]
	ld b, a

.level_loop
	inc b
	ld a, b
	ld [wCurPartyLevel], a
	push bc
	predef LearnLevelMoves
	pop bc
	ld a, b
	cp c
	jr nz, .level_loop
	pop af
	ld [wCurPartyLevel], a
	ld hl, wEvolvableFlags
	ld a, [wCurPartyMon]
	ld c, a
	ld b, SET_FLAG
	predef SmallFarFlagAction
	pop af
	ld [wCurPartyLevel], a

.next_mon
	ld a, [wPartyCount]
	ld b, a
	ld a, [wCurPartyMon]
	inc a
	cp b
	jr z, .done
	ld [wCurPartyMon], a
	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld b, h
	ld c, l
	jmp .loop

.done
	jmp ResetBattleParticipants

.EvenlyDivideExpAmongParticipants:
; Only if there is Exp Share is not active
	ld a, [wExpShareToggle]
	and a
	ret nz
; Count number of battle participants
	ld a, [wBattleParticipantsNotFainted]
	ld b, a
	ld c, PARTY_LENGTH
	ld de, 0
.count_loop
push bc
	push de
	ld a, e
	ld hl, wPartyMon1Level
	call GetPartyLocation
	ld a, [hl]
	cp MAX_LEVEL
	pop de
	pop bc
	jr c, .gains_exp
	srl b
	ld a, d
	jr .no_exp
.gains_exp
	xor a
	srl b
	adc d
	ld d, a
.no_exp
	inc e
	dec c
	jr nz, .count_loop
	cp 2
	ret c

	ld [wTempByteValue], a
	ld hl, wEnemyMonBaseStats
	ld c, wEnemyMonEnd - wEnemyMonBaseStats
.base_stat_division_loop
	xor a
	ldh [hDividend + 0], a
	ld a, [hl]
	ldh [hDividend + 1], a
	ld a, [wTempByteValue]
	ldh [hDivisor], a
	ld b, 2
	call Divide
	ldh a, [hQuotient + 3]
	ld [hli], a
	dec c
	jr nz, .base_stat_division_loop
	ret

BoostExp:
; Multiply experience by 1.5x
	ln a, 3, 2 ; x1.5
	jmp MultiplyAndDivide
	ret

Text_MonGainedExpPoint:
	text_far Text_Gained
	text_asm
	ld hl, ExpPointsText
	ld a, [wStringBuffer2 + 2] ; IsTradedMon
	and a
	ret z

	ld hl, BoostedExpPointsText
	ret

Text_TeamGainedExpPoint:
	text_asm
	ld hl, TeamGainedExpPointText
	ret

TeamGainedExpPointText:
	text_far _TeamGainedExpText
	text_end

BoostedExpPointsText:
	text_far _BoostedExpPointsText
	text_end

ExpPointsText:
	text_far _ExpPointsText
	text_end

AnimateExpBar:
	push bc

	ld hl, wCurPartyMon
	ld a, [wCurBattleMon]
	cp [hl]
	jmp nz, .finish

	ld a, [wBattleMonLevel]
	cp MAX_LEVEL
	jmp nc, .finish

	ldh a, [hProduct + 3]
	ld [wExperienceGained + 2], a
	push af
	ldh a, [hProduct + 2]
	ld [wExperienceGained + 1], a
	push af
	xor a
	ld [wExperienceGained], a
	xor a ; PARTYMON
	ld [wMonType], a
	predef CopyMonToTempMon
	ld a, [wTempMonLevel]
	ld b, a
	ld e, a
	push de
	ld de, wTempMonExp + 2
	call CalcExpBar
	push bc
	ld hl, wTempMonExp + 2
	ld a, [wExperienceGained + 2]
	add [hl]
	ld [hld], a
	ld a, [wExperienceGained + 1]
	adc [hl]
	ld [hld], a
	jr nc, .NoOverflow
	inc [hl]
	jr nz, .NoOverflow
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hl], a

.NoOverflow:
	ld d, MAX_LEVEL
	farcall CalcExpAtLevel
	ldh a, [hProduct + 1]
	ld b, a
	ldh a, [hProduct + 2]
	ld c, a
	ldh a, [hProduct + 3]
	ld d, a
	ld hl, wTempMonExp + 2
	ld a, [hld]
	sub d
	ld a, [hld]
	sbc c
	ld a, [hl]
	sbc b
	jr c, .AlreadyAtMaxExp
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hld], a

.AlreadyAtMaxExp:
	call CalcLevelExp
	ld a, d
	pop bc
	pop de
	ld d, a
	cp e
	jr nc, .LoopLevels
	ld a, e
	ld d, a

.LoopLevels:
	ld a, e
	cp MAX_LEVEL
	jr nc, .FinishExpBar
	cp d
	jr z, .FinishExpBar
	inc a
	ld [wTempMonLevel], a
	ld [wCurPartyLevel], a
	ld [wBattleMonLevel], a
	push de
	call .PlayExpBarSound
	ld c, $40
	call .LoopBarAnimation
	call PrintPlayerHUD
	ld hl, wBattleMonNickname
	ld de, wStringBuffer1
	ld bc, MON_NAME_LENGTH
	rst CopyBytes
	call TerminateExpBarSound
	ld de, SFX_HIT_END_OF_EXP_BAR
	call PlaySFX
	farcall AnimateEndOfExpBar
	call WaitSFX
	ld hl, BattleText_StringBuffer1GrewToLevel
	call StdBattleTextbox
	pop de
	inc e
	ld b, $0
	jr .LoopLevels

.FinishExpBar:
	push bc
	ld b, d
	ld de, wTempMonExp + 2
	call CalcExpBar
	ld a, b
	pop bc
	ld c, a
	call .PlayExpBarSound
	call .LoopBarAnimation
	call TerminateExpBarSound
	pop af
	ldh [hProduct + 2], a
	pop af
	ldh [hProduct + 3], a

.finish
	pop bc
	ret

.PlayExpBarSound:
	push bc
	ld de, SFX_EXP_BAR
	call WaitPlaySFX
	ld c, 10
	call DelayFrames
	pop bc
	ret

.LoopBarAnimation:
	ld d, 3
	dec b
.anim_loop
	inc b
	push bc
	push de
	hlcoord 17, 11
	call PlaceExpBar
	pop de
	ld a, $1
	ldh [hBGMapMode], a
	ld c, d
	call DelayFrames
	xor a
	ldh [hBGMapMode], a
	pop bc
	ld a, c
	cp b
	jr z, .end_animation
	inc b
	push bc
	push de
	hlcoord 17, 11
	call PlaceExpBar
	pop de
	ld a, $1
	ldh [hBGMapMode], a
	ld c, d
	call DelayFrames
	xor a
	ldh [hBGMapMode], a
	dec d
	jr nz, .min_number_of_frames
	ld d, 1
.min_number_of_frames
	pop bc
	ld a, c
	cp b
	jr nz, .anim_loop
.end_animation
	ld a, $1
	ldh [hBGMapMode], a
	ret

SendOutMonText:
	ld a, [wLinkMode]
	and a
	jr z, .not_linked

; If we're in a LinkBattle print just "Go <PlayerMon>"
; unless DoBattle already set [wBattleHasJustStarted]
	ld hl, GoMonText
	ld a, [wBattleHasJustStarted]
	and a
	jr nz, .skip_to_textbox

.not_linked
; Depending on the HP of the enemy mon, the game prints a different text
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl]
	ld hl, GoMonText
	jr z, .skip_to_textbox

	; compute enemy health remaining as a percentage
	xor a
	ldh [hMultiplicand + 0], a
	ld hl, wEnemyMonHP
	ld a, [hli]
	ld [wEnemyHPAtTimeOfPlayerSwitch], a
	ldh [hMultiplicand + 1], a
	ld a, [hl]
	ld [wEnemyHPAtTimeOfPlayerSwitch + 1], a
	ldh [hMultiplicand + 2], a
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld b, [hl]
	ld c, 100
	and a
	jr z, .shift_done
.shift
	rra
 	rr b
	srl c
	and a
	jr nz, .shift
.shift_done
	ld a, c
	ldh [hMultiplier], a
	call Multiply
	ld a, b
	ld b, 4
	ldh [hDivisor], a
	call Divide

	ldh a, [hQuotient + 3]
	ld hl, GoMonText
	cp 70
	jr nc, .skip_to_textbox

	ld hl, DoItMonText
	cp 40
	jr nc, .skip_to_textbox

	ld hl, GoForItMonText
	cp 10
	jr nc, .skip_to_textbox

	ld hl, YourFoesWeakGetmMonText
.skip_to_textbox
	jmp BattleTextbox

CalcLevelExp:
	ld a, [wTempMonSpecies]
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [wTempMonLevel]
	ld d, a
.next_level
	inc d
	ld a, d
	cp LOW(MAX_LEVEL + 1)
	jr z, .got_level
	farcall CalcExpAtLevel
	push hl
	ld hl, wTempMonExp + 2
	ldh a, [hProduct + 3]
	ld c, a
	ld a, [hld]
	sub c
	ldh a, [hProduct + 2]
	ld c, a
	ld a, [hld]
	sbc c
	ldh a, [hProduct + 1]
	ld c, a
	ld a, [hl]
	sbc c
	pop hl
	jr nc, .next_level

.got_level
	dec d
	ret

GoMonText:
	text_far _GoMonText
	text_asm
	jr PrepareBattleMonNicknameText

DoItMonText:
	text_far _DoItMonText
	text_asm
	jr PrepareBattleMonNicknameText

GoForItMonText:
	text_far _GoForItMonText
	text_asm
	jr PrepareBattleMonNicknameText

YourFoesWeakGetmMonText:
	text_far _YourFoesWeakGetmMonText
	text_asm
PrepareBattleMonNicknameText:
	ld hl, BattleMonNicknameText
	ret

BattleMonNicknameText:
	text_far _BattleMonNicknameText
	text_end

WithdrawMonText:
	ld hl, .WithdrawMonText
	jmp BattleTextbox

.WithdrawMonText:
	text_far _BattleMonNickCommaText
	text_asm
; Depending on the HP lost since the enemy mon was sent out, the game prints a different text
	push de
	push bc
	; compute enemy health lost as a percentage
	ld hl, wEnemyMonHP + 1
	ld de, wEnemyHPAtTimeOfPlayerSwitch + 1
	ld a, [hld]
	ld b, a
	ld a, [de]
	sub b
	ldh [hMultiplicand + 2], a
	dec de
	ld b, [hl]
	ld a, [de]
	sbc b
	ldh [hMultiplicand + 1], a
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld b, [hl]

	ld c, 100
	and a
	jr z, .shift_done
.shift
	rra
 	rr b
	srl c
	and a
	jr nz, .shift
.shift_done
	ld a, c
	ldh [hMultiplier], a
	call Multiply
	ld a, b
	ld b, 4
	ldh [hDivisor], a
	call Divide
	pop bc
	pop de
	ldh a, [hQuotient + 3]
	ld hl, ThatsEnoughComeBackText
	and a
	ret z

	ld hl, ComeBackText
	cp 30
	ret c

	ld hl, OKComeBackText
	cp 70
	ret c

	ld hl, GoodComeBackText
	ret

ThatsEnoughComeBackText:
	text_far _ThatsEnoughComeBackText
	text_end

OKComeBackText:
	text_far _OKComeBackText
	text_end

GoodComeBackText:
	text_far _GoodComeBackText
	text_end

ComeBackText:
	text_far _ComeBackText
	text_end

FillInExpBar:
	push hl
	call CalcExpBar
	pop hl
	ld de, 7
	add hl, de
	jr PlaceExpBar

CalcExpBar:
; Calculate the percent exp between this level and the next
; Level in b
	push de
	ld d, b
	push de
	farcall CalcExpAtLevel
	pop de
; exp at current level gets pushed to the stack
	ld hl, hMultiplicand
	ld a, [hli]
	push af
	ld a, [hli]
	push af
	ld a, [hl]
	push af
; next level
	inc d
	farcall CalcExpAtLevel
; back up the next level exp, and subtract the two levels
	ld hl, hMultiplicand + 2
	ld a, [hl]
	ldh [hMathBuffer + 2], a
	pop bc
	sub b
	ld [hld], a
	ld a, [hl]
	ldh [hMathBuffer + 1], a
	pop bc
	sbc b
	ld [hld], a
	ld a, [hl]
	ldh [hMathBuffer], a
	pop bc
	sbc b
	ld [hl], a
	pop de

	ld hl, hMultiplicand + 1
	ld a, [hli]
	push af
	ld a, [hl]
	push af

; get the amount of exp remaining to the next level
	ld a, [de]
	dec de
	ld c, a
	ldh a, [hMathBuffer + 2]
	sub c
	ld [hld], a
	ld a, [de]
	dec de
	ld b, a
	ldh a, [hMathBuffer + 1]
	sbc b
	ld [hld], a
	ld a, [de]
	ld c, a
	ldh a, [hMathBuffer]
	sbc c
	ld [hld], a
	xor a
	ld [hl], a
	ld a, 64
	ldh [hMultiplier], a
	call Multiply
	pop af
	ld c, a
	pop af
	ld b, a
.loop
	ld a, b
	and a
	jr z, .done
	srl b
	rr c
	ld hl, hProduct
	srl [hl]
	inc hl
	rr [hl]
	inc hl
	rr [hl]
	inc hl
	rr [hl]
	jr .loop

.done
	ld a, c
	ldh [hDivisor], a
	ld b, 4
	call Divide
	ldh a, [hQuotient + 3]
	cpl
	add $40 + 1
	ld b, a
	ret

PlaceExpBar:
	ld c, $8 ; number of tiles
.loop1
	ld a, b
	sub $8
	jr c, .next
	ld b, a
	ld a, $6a ; full bar
	ld [hld], a
	dec c
	ret z
	jr .loop1

.next
	add $8
	jr z, .loop2
	push hl
	push af
	hlcoord 9, 0 ; coord of HP bar label, usually 0,9
	ld a, [hl]
	ld b, $62
	cp $e8 ; if we are in stats screen
	jr nz, .inbattle
	ld b, $54
.inbattle
	pop af
	pop hl
	add b
	jr .skip

.loop2
	ld a, $62 ; empty bar

.skip
	ld [hld], a
	ld a, $62 ; empty bar
	dec c
	jr nz, .loop2
	ret

GetBattleMonBackpic:
	ld a, [wPlayerSubStatus4]
	bit SUBSTATUS_SUBSTITUTE, a
	ld hl, BattleAnimCmd_RaiseSub
	jr nz, GetBattleMonBackpic_DoAnim ; substitute

DropPlayerSub:
	ld a, [wPlayerMinimized]
	and a
	ld hl, BattleAnimCmd_MinimizeOpp
	jr nz, GetBattleMonBackpic_DoAnim
	ld a, [wCurPartySpecies]
	push af
	ld a, [wBattleMonSpecies]
	ld [wCurPartySpecies], a
	ld hl, wBattleMonDVs
	predef GetUnownLetter
	ld de, vTiles2 tile $31
	predef GetMonBackpic
	pop af
	ld [wCurPartySpecies], a
	ret

GetBattleMonBackpic_DoAnim:
	ldh a, [hBattleTurn]
	push af
	xor a
	ldh [hBattleTurn], a
	ld a, BANK(BattleAnimCommands)
	call FarCall_hl
	pop af
	ldh [hBattleTurn], a
	ret

GetEnemyMonFrontpic:
	ld a, [wEnemySubStatus4]
	bit SUBSTATUS_SUBSTITUTE, a
	ld hl, BattleAnimCmd_RaiseSub
	jr nz, GetEnemyMonFrontpic_DoAnim

DropEnemySub:
	ld a, [wEnemyMinimized]
	and a
	ld hl, BattleAnimCmd_MinimizeOpp
	jr nz, GetEnemyMonFrontpic_DoAnim

	ld a, [wCurPartySpecies]
	push af
	ld a, [wEnemyMonSpecies]
	ld [wCurSpecies], a
	ld [wCurPartySpecies], a
	call GetBaseData
	ld hl, wEnemyMonDVs
	predef GetUnownLetter
	ld de, vTiles2
	predef GetAnimatedFrontpic
	pop af
	ld [wCurPartySpecies], a
	ret

GetEnemyMonFrontpic_DoAnim:
	ldh a, [hBattleTurn]
	push af
	call SetEnemyTurn
	ld a, BANK(BattleAnimCommands)
	call FarCall_hl
	pop af
	ldh [hBattleTurn], a
	ret

StartBattle:
; This check prevents you from entering a battle without any Pokemon.
; Those using walk-through-walls to bypass getting a Pokemon experience
; the effects of this check.
	ld a, [wPartyCount]
	and a
	ret z

	ld a, [wTimeOfDayPal]
	push af
	call BattleIntro
	call DoBattle
	call ExitBattle
	pop af
	ld [wTimeOfDayPal], a
	scf
	ret

BattleIntro:
	call LoadTrainerOrWildMonPic
	xor a
	ld [wTempBattleMonSpecies], a
	ld [wBattleMenuCursorPosition], a
	xor a
	ldh [hMapAnims], a
	farcall PlayBattleMusic
	farcall ShowLinkBattleParticipants
	farcall FindFirstAliveMonAndStartBattle
	call DisableSpriteUpdates
	farcall ClearBattleRAM
	call InitEnemy
	call BackUpBGMap2
	ld b, SCGB_BATTLE_GRAYSCALE
	call GetSGBLayout
	ld hl, rLCDC
	res rLCDC_WINDOW_TILEMAP, [hl] ; select vBGMap0/vBGMap2
	call InitBattleDisplay
	call BattleStartMessage
	ld hl, rLCDC
	set rLCDC_WINDOW_TILEMAP, [hl] ; select vBGMap1/vBGMap3
	xor a
	ldh [hBGMapMode], a
	call EmptyBattleTextbox
	hlcoord 9, 7
	lb bc, 5, 11
	call ClearBox
	hlcoord 1, 0
	lb bc, 4, 10
	call ClearBox
	call ClearSprites
	ld a, [wBattleMode]
	cp WILD_BATTLE
	call z, UpdateEnemyHUD
	ld a, $1
	ldh [hBGMapMode], a
	ret

LoadTrainerOrWildMonPic:
	ld a, [wOtherTrainerClass]
	and a
	jr nz, .Trainer
	ld a, [wTempWildMonSpecies]
	ld [wCurPartySpecies], a

.Trainer:
	ld [wTempEnemyMonSpecies], a
	ret

InitEnemy:
	ld a, [wOtherTrainerClass]
	and a
	jr nz, InitEnemyTrainer ; trainer
	jmp InitEnemyWildmon ; wild

BackUpBGMap2:
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a
	ld hl, wDecompressScratch
	ld bc, $40 tiles ; vBGMap3 - vBGMap2
	ld a, $2
	rst ByteFill
	ldh a, [rVBK]
	push af
	ld a, $1
	ldh [rVBK], a
	ld de, wDecompressScratch
	hlbgcoord 0, 0 ; vBGMap2
	lb bc, BANK(BackUpBGMap2), $40
	call Request2bpp
	pop af
	ldh [rVBK], a
	pop af
	ldh [rSVBK], a
	ret

InitEnemyTrainer:
	ld [wTrainerClass], a
	xor a
	ld [wTempEnemyMonSpecies], a
	farcall GetTrainerAttributes
	farcall ReadTrainerParty

	; RIVAL1's first mon has no held item
	ld a, [wTrainerClass]
	cp RIVAL1
	jr nz, .ok
	xor a
	ld [wOTPartyMon1Item], a

.ok
	ld de, vTiles2
	farcall GetTrainerPic
	xor a
	ldh [hGraphicStartTile], a
	dec a
	ld [wEnemyItemState], a
	hlcoord 12, 0
	lb bc, 7, 7
	predef PlaceGraphic
	ld a, -1
	ld [wCurOTMon], a
	ld a, TRAINER_BATTLE
	ld [wBattleMode], a

	call IsGymLeader
	ret nc
	xor a
	ld [wCurPartyMon], a
	ld a, [wPartyCount]
	ld b, a
.partyloop
	push bc
	ld a, MON_HP
	call GetPartyParamLocation
	ld a, [hli]
	or [hl]
	jr z, .skipfaintedmon
	ld c, HAPPINESS_GYMBATTLE
	farcall ChangeHappiness
.skipfaintedmon
	pop bc
	dec b
	ret z
	ld hl, wCurPartyMon
	inc [hl]
	jr .partyloop
	ret

InitEnemyWildmon:
	ld a, WILD_BATTLE
	ld [wBattleMode], a
	call LoadEnemyMon
	ld hl, wEnemyMonMoves
	ld de, wWildMonMoves
	ld bc, NUM_MOVES
	rst CopyBytes
	ld hl, wEnemyMonPP
	ld de, wWildMonPP
	ld bc, NUM_MOVES
	rst CopyBytes
	ld hl, wEnemyMonDVs
	predef GetUnownLetter
	ld a, [wCurPartySpecies]
	cp UNOWN
	jr nz, .skip_unown
	ld a, [wFirstUnownSeen]
	and a
	jr nz, .skip_unown
	ld a, [wUnownLetter]
	ld [wFirstUnownSeen], a
.skip_unown
	ld de, vTiles2
	predef GetAnimatedFrontpic
	xor a
	ld [wTrainerClass], a
	ldh [hGraphicStartTile], a
	hlcoord 12, 0
	lb bc, 7, 7
	predef_jump PlaceGraphic

ExitBattle:
	call .HandleEndOfBattle
	jr CleanUpBattleRAM

.HandleEndOfBattle:
	ld a, [wLinkMode]
	and a
	jr z, .not_linked
	call ShowLinkBattleParticipantsAfterEnd
	ld c, 150
	call DelayFrames
	jmp DisplayLinkBattleResult

.not_linked
	ld a, [wBattleResult]
	and $f
	ret nz
	call CheckPayDay
	xor a
	ld [wForceEvolution], a
	farcall EvolveAfterBattle
	farjp GivePokerusAndConvertBerries

CleanUpBattleRAM:
	call BattleEnd_HandleRoamMons
	call RestoreBattleItems
	xor a
	ld [wLowHealthAlarm], a
	ld [wBattleMode], a
	ld [wBattleType], a
	ld [wAttackMissed], a
	ld [wTempWildMonSpecies], a
	ld [wOtherTrainerClass], a
	ld [wFailedToFlee], a
	ld [wNumFleeAttempts], a
	ld [wForcedSwitch], a
	ld [wPartyMenuCursor], a
	ld [wKeyItemsPocketCursor], a
	ld [wItemsPocketCursor], a
	ld [wBattleMenuCursorPosition], a
	ld [wCurMoveNum], a
	ld [wBallsPocketCursor], a
	ld [wLastPocket], a
	ld [wMenuScrollPosition], a
	ld [wKeyItemsPocketScrollPosition], a
	ld [wItemsPocketScrollPosition], a
	ld [wBallsPocketScrollPosition], a
	ld hl, wPlayerSubStatus1
	ld b, wEnemyFuryCutterCount - wPlayerSubStatus1
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	jmp WaitSFX

CheckPayDay:
	ld hl, wPayDayMoney
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	ret z
	ld a, [wAmuletCoin]
	and a
	jr z, .okay
	ld hl, wPayDayMoney + 2
	sla [hl]
	dec hl
	rl [hl]
	dec hl
	rl [hl]
	jr nc, .okay
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hl], a

.okay
	ld hl, wPayDayMoney + 2
	ld de, wMoney + 2
	call AddBattleMoneyToAccount
	ld hl, BattleText_PlayerPickedUpPayDayMoney
	call StdBattleTextbox
	ld a, [wInBattleTowerBattle]
	bit 0, a
	ret z
	call ClearTilemap
	jmp ClearBGPalettes

ShowLinkBattleParticipantsAfterEnd:
	ld a, [wCurOTMon]
	ld hl, wOTPartyMon1Status
	call GetPartyLocation
	ld a, [wEnemyMonStatus]
	ld [hl], a
	call ClearTilemap
	farjp _ShowLinkBattleParticipants

DisplayLinkBattleResult:
	ld a, [wBattleResult]
	and $f
	cp LOSE
	jr c, .win ; WIN
	jr z, .lose ; LOSE
	; DRAW
	ld de, .Draw
	jr .store_result

.win
	ld de, .YouWin
	jr .store_result

.lose
	ld de, .YouLose

.store_result
	hlcoord 6, 8
	rst PlaceString
	ld c, 200
	call DelayFrames

	ld a, BANK(sLinkBattleStats)
	call OpenSRAM

	call AddLastLinkBattleToLinkRecord
	call ReadAndPrintLinkBattleRecord

	call CloseSRAM

	call WaitPressAorB_BlinkCursor
	jmp ClearTilemap

.YouWin:
	db "YOU WIN@"
.YouLose:
	db "YOU LOSE@"
.Draw:
	db "  DRAW@"

.InvalidBattle:
	db "INVALID BATTLE@"

_DisplayLinkRecord:
	ld a, BANK(sLinkBattleStats)
	call OpenSRAM

	call ReadAndPrintLinkBattleRecord

	call CloseSRAM
	hlcoord 0, 0, wAttrmap
	xor a
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	rst ByteFill
	call WaitBGMap2
	ld b, SCGB_DIPLOMA
	call GetSGBLayout
	call SetDefaultBGPAndOBP
	ld c, 8
	call DelayFrames
	jmp WaitPressAorB_BlinkCursor

ReadAndPrintLinkBattleRecord:
	call ClearTilemap
	call ClearSprites
	call .PrintBattleRecord
	hlcoord 0, 8
	ld b, NUM_LINK_BATTLE_RECORDS
	ld de, sLinkBattleRecord1Name
.loop
	push bc
	push hl
	push de
	ld a, [de]
	and a
	jr z, .PrintFormatString
	ld a, [wSavedAtLeastOnce]
	and a
	jr z, .PrintFormatString
	push hl
	push hl
	ld h, d
	ld l, e
	ld de, wLinkBattleRecordName
	ld bc, NAME_LENGTH - 1
	rst CopyBytes
	ld a, "@"
	ld [de], a
	inc de ; wLinkBattleRecordWins
	ld bc, 6
	rst CopyBytes
	ld de, wLinkBattleRecordName
	pop hl
	rst PlaceString
	pop hl
	ld de, 26
	add hl, de
	push hl
	ld de, wLinkBattleRecordWins
	lb bc, 2, 4
	call PrintNum
	pop hl
	ld de, 5
	add hl, de
	push hl
	ld de, wLinkBattleRecordLosses
	lb bc, 2, 4
	call PrintNum
	pop hl
	ld de, 5
	add hl, de
	ld de, wLinkBattleRecordDraws
	lb bc, 2, 4
	call PrintNum
	jr .next

.PrintFormatString:
	ld de, .Format
	rst PlaceString
.next
	pop hl
	ld bc, LINK_BATTLE_RECORD_LENGTH
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld bc, 2 * SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .loop
	ret

.PrintBattleRecord:
	hlcoord 1, 0
	ld de, .Record
	rst PlaceString

	hlcoord 0, 6
	ld de, .Result
	rst PlaceString

	hlcoord 0, 2
	ld de, .Total
	rst PlaceString

	hlcoord 6, 4
	ld de, sLinkBattleWins
	call .PrintZerosIfNoSaveFileExists
	ret c

	lb bc, 2, 4
	call PrintNum

	hlcoord 11, 4
	ld de, sLinkBattleLosses
	call .PrintZerosIfNoSaveFileExists

	lb bc, 2, 4
	call PrintNum

	hlcoord 16, 4
	ld de, sLinkBattleDraws
	call .PrintZerosIfNoSaveFileExists

	lb bc, 2, 4
	jmp PrintNum

.PrintZerosIfNoSaveFileExists:
	ld a, [wSavedAtLeastOnce]
	and a
	ret nz
	ld de, .Scores
	rst PlaceString
	scf
	ret

.Scores:
	db "   0    0    0@"

.Format:
	db "  ---  <LF>"
	db "         -    -    -@"
.Record:
	db "<PLAYER>'s RECORD@"
.Result:
	db "RESULT WIN LOSE DRAW@"
.Total:
	db "TOTAL  WIN LOSE DRAW@"

BattleEnd_HandleRoamMons:
	ld a, [wBattleType]
	cp BATTLETYPE_ROAMING
	jr nz, .not_roaming
	ld a, [wBattleResult]
	and $f
	jr z, .caught_or_defeated_roam_mon ; WIN
	call GetRoamMonHP
	ld a, [wEnemyMonHP + 1]
	ld [hl], a
	jr .update_roam_mons

.caught_or_defeated_roam_mon
	call GetRoamMonHP
	ld [hl], 0
	call GetRoamMonMapGroup
	ld [hl], GROUP_N_A
	call GetRoamMonMapNumber
	ld [hl], MAP_N_A
	call GetRoamMonSpecies
	ld [hl], 0
	ret

.not_roaming
	call BattleRandom
	and $f
	ret nz

.update_roam_mons
	farjp UpdateRoamMons

GetRoamMonMapGroup:
	ld a, [wTempEnemyMonSpecies]
	ld b, a
	ld a, [wRoamMon1Species]
	cp b
	ld hl, wRoamMon1MapGroup
	ret z
	ld a, [wRoamMon2Species]
	cp b
	ld hl, wRoamMon2MapGroup
	ret z
	ld hl, wRoamMon3MapGroup
	ret

GetRoamMonMapNumber:
	ld a, [wTempEnemyMonSpecies]
	ld b, a
	ld a, [wRoamMon1Species]
	cp b
	ld hl, wRoamMon1MapNumber
	ret z
	ld a, [wRoamMon2Species]
	cp b
	ld hl, wRoamMon2MapNumber
	ret z
	ld hl, wRoamMon3MapNumber
	ret

GetRoamMonHP:
; output: hl = wRoamMonHP
	ld a, [wTempEnemyMonSpecies]
	ld b, a
	ld a, [wRoamMon1Species]
	cp b
	ld hl, wRoamMon1HP
	ret z
	ld a, [wRoamMon2Species]
	cp b
	ld hl, wRoamMon2HP
	ret z
	ld hl, wRoamMon3HP
	ret

GetRoamMonDVs:
; output: hl = wRoamMonDVs
	ld a, [wTempEnemyMonSpecies]
	ld b, a
	ld a, [wRoamMon1Species]
	cp b
	ld hl, wRoamMon1DVs
	ret z
	ld a, [wRoamMon2Species]
	cp b
	ld hl, wRoamMon2DVs
	ret z
	ld hl, wRoamMon3DVs
	ret

GetRoamMonSpecies:
	ld a, [wTempEnemyMonSpecies]
	ld hl, wRoamMon1Species
	cp [hl]
	ret z
	ld hl, wRoamMon2Species
	cp [hl]
	ret z
	ld hl, wRoamMon3Species
	ret

AddLastLinkBattleToLinkRecord:
	ld hl, wOTPlayerID
	ld de, wStringBuffer1
	ld bc, 2
	rst CopyBytes
	ld hl, wOTPlayerName
	ld bc, NAME_LENGTH - 1
	rst CopyBytes
	ld hl, sLinkBattleStats - (LINK_BATTLE_RECORD_LENGTH - 6)
	call .StoreResult
	ld hl, sLinkBattleRecord
	ld d, NUM_LINK_BATTLE_RECORDS
.loop
	push hl
	inc hl
	inc hl
	ld a, [hld]
	dec hl
	and a
	jr z, .copy
	push de
	ld bc, LINK_BATTLE_RECORD_LENGTH - 6
	ld de, wStringBuffer1
	call CompareBytesLong
	pop de
	pop hl
	jr c, .done
	ld bc, LINK_BATTLE_RECORD_LENGTH
	add hl, bc
	dec d
	jr nz, .loop
	ld bc, -LINK_BATTLE_RECORD_LENGTH
	add hl, bc
	push hl

.copy
	ld d, h
	ld e, l
	ld hl, wStringBuffer1
	ld bc, LINK_BATTLE_RECORD_LENGTH - 6
	rst CopyBytes
	ld b, 6
	xor a
.loop2
	ld [de], a
	inc de
	dec b
	jr nz, .loop2
	pop hl

.done
	call .StoreResult
	jr .FindOpponentAndAppendRecord

.StoreResult:
	ld a, [wBattleResult]
	and $f
	cp LOSE
	ld bc, (sLinkBattleRecord1Wins - sLinkBattleRecord1) + 1
	jr c, .okay ; WIN
	ld bc, (sLinkBattleRecord1Losses - sLinkBattleRecord1) + 1
	jr z, .okay ; LOSE
	; DRAW
	ld bc, (sLinkBattleRecord1Draws - sLinkBattleRecord1) + 1
.okay
	add hl, bc
	call .CheckOverflow
	ret nc
	inc [hl]
	ret nz
	dec hl
	inc [hl]
	ret

.CheckOverflow:
	dec hl
	ld a, [hli]
	cp HIGH(MAX_LINK_RECORD)
	ret c
	ld a, [hl]
	cp LOW(MAX_LINK_RECORD)
	ret

.FindOpponentAndAppendRecord:
	ld b, NUM_LINK_BATTLE_RECORDS
	ld hl, sLinkBattleRecord1End - 1
	ld de, wLinkBattleRecordBuffer
.loop3
	push bc
	push de
	push hl
	call .LoadPointer
	pop hl
	ld a, e
	pop de
	ld [de], a
	inc de
	ld a, b
	ld [de], a
	inc de
	ld a, c
	ld [de], a
	inc de
	ld bc, LINK_BATTLE_RECORD_LENGTH
	add hl, bc
	pop bc
	dec b
	jr nz, .loop3
	lb bc, 0, 1
.loop4
	ld a, b
	add b
	add b
	ld e, a
	ld d, 0
	ld hl, wLinkBattleRecordBuffer
	add hl, de
	push hl
	ld a, c
	add c
	add c
	ld e, a
	ld d, 0
	ld hl, wLinkBattleRecordBuffer
	add hl, de
	ld d, h
	ld e, l
	pop hl
	push bc
	ld c, 3
	call CompareBytes
	pop bc
	jr z, .equal
	jr nc, .done2

.equal
	inc c
	ld a, c
	cp $5
	jr nz, .loop4
	inc b
	ld c, b
	inc c
	ld a, b
	cp $4
	jr nz, .loop4
	ret

.done2
	push bc
	ld a, b
	ld bc, LINK_BATTLE_RECORD_LENGTH
	ld hl, sLinkBattleRecord
	rst AddNTimes
	push hl
	ld de, wLinkBattleRecordBuffer
	ld bc, LINK_BATTLE_RECORD_LENGTH
	rst CopyBytes
	pop hl
	pop bc
	push hl
	ld a, c
	ld bc, LINK_BATTLE_RECORD_LENGTH
	ld hl, sLinkBattleRecord
	rst AddNTimes
	pop de
	push hl
	ld bc, LINK_BATTLE_RECORD_LENGTH
	rst CopyBytes
	ld hl, wLinkBattleRecordBuffer
	ld bc, LINK_BATTLE_RECORD_LENGTH
	pop de
	rst CopyBytes
	ret

.LoadPointer:
	ld e, $0
	ld a, [hld]
	ld c, a
	ld a, [hld]
	ld b, a
	ld a, [hld]
	add c
	ld c, a
	ld a, [hld]
	adc b
	ld b, a
	jr nc, .okay2
	inc e

.okay2
	ld a, [hld]
	add c
	ld c, a
	ld a, [hl]
	adc b
	ld b, a
	ret nc
	inc e
	ret

InitBattleDisplay:
	call .InitBackPic
	hlcoord 0, 12
	lb bc, 4, 18
	call Textbox
	hlcoord 1, 5
	lb bc, 3, 7
	call ClearBox
	call LoadStandardFont
	call _LoadBattleFontsHPBar
	call .BlankBGMap
	xor a
	ldh [hMapAnims], a
	ldh [hSCY], a
	ld a, $90
	ldh [hWY], a
	ldh [rWY], a
	call WaitBGMap
	xor a
	ldh [hBGMapMode], a
	farcall BattleIntroSlidingPics
	ld a, $1
	ldh [hBGMapMode], a
	ld a, $31
	ldh [hGraphicStartTile], a
	hlcoord 2, 6
	lb bc, 6, 6
	predef PlaceGraphic
	xor a
	ldh [hWY], a
	vc_hook Unknown_InitBattleDisplay
	ldh [rWY], a
	call WaitBGMap
	call HideSprites
	ld b, SCGB_BATTLE_COLORS
	call GetSGBLayout
	call SetDefaultBGPAndOBP
	ld a, $90
	ldh [hWY], a
	xor a
	ldh [hSCX], a
	ret

.BlankBGMap:
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a

	ld hl, wDecompressScratch
	ld bc, BG_MAP_WIDTH * BG_MAP_HEIGHT
	ld a, " "
	rst ByteFill

	ld de, wDecompressScratch
	hlbgcoord 0, 0
	lb bc, BANK(@), (BG_MAP_WIDTH * BG_MAP_HEIGHT) / LEN_2BPP_TILE
	call Request2bpp

	pop af
	ldh [rSVBK], a
	ret

.InitBackPic:
	call GetTrainerBackpic
	jr CopyBackpic

GetTrainerBackpic:
; Load the player character's backpic (6x6) into VRAM starting from vTiles2 tile $31.

; Special exception for Dude.
	ld b, BANK(DudeBackpic)
	ld hl, DudeBackpic
	ld a, [wBattleType]
	cp BATTLETYPE_TUTORIAL
	jr z, .Decompress

; What gender are we?
	ld a, [wPlayerSpriteSetupFlags]
	bit PLAYERSPRITESETUP_FEMALE_TO_MALE_F, a
	jr nz, .Chris
	ld a, [wPlayerGender]
	bit PLAYERGENDER_FEMALE_F, a
	jr z, .Chris

; It's a girl.
	farjp GetKrisBackpic

.Chris:
; It's a boy.
	ld b, BANK(ChrisBackpic)
	ld hl, ChrisBackpic

.Decompress:
	ld de, vTiles2 tile $31
	ld c, 7 * 7
	predef_jump DecompressGet2bpp

CopyBackpic:
	ldh a, [rSVBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rSVBK], a
	ld hl, vTiles0
	ld de, vTiles2 tile $31
	ldh a, [hROMBank]
	ld b, a
	ld c, 7 * 7
	call Get2bpp
	pop af
	ldh [rSVBK], a
	call .LoadTrainerBackpicAsOAM
	ld a, $31
	ldh [hGraphicStartTile], a
	hlcoord 2, 6
	lb bc, 6, 6
	predef_jump PlaceGraphic

.LoadTrainerBackpicAsOAM:
	ld hl, wShadowOAMSprite00
	xor a
	ldh [hMapObjectIndex], a
	ld b, 6
	ld e, (SCREEN_WIDTH + 1) * TILE_WIDTH
.outer_loop
	ld c, 3
	ld d, 8 * TILE_WIDTH
.inner_loop
	ld a, d ; y
	ld [hli], a
	ld a, e ; x
	ld [hli], a
	ldh a, [hMapObjectIndex]
	ld [hli], a ; tile id
	inc a
	ldh [hMapObjectIndex], a
	ld a, PAL_BATTLE_OB_PLAYER
	ld [hli], a ; attributes
	ld a, d
	add 1 * TILE_WIDTH
	ld d, a
	dec c
	jr nz, .inner_loop
	ldh a, [hMapObjectIndex]
	add $3
	ldh [hMapObjectIndex], a
	ld a, e
	add 1 * TILE_WIDTH
	ld e, a
	dec b
	jr nz, .outer_loop
	ret

BattleStartMessage:
	ld a, [wBattleMode]
	dec a
	jr z, .wild

	ld de, SFX_SHINE
	call PlaySFX
	call WaitSFX

	ld c, 20
	call DelayFrames

	farcall Battle_GetTrainerName

	ld hl, WantsToBattleText
	jr .PrintBattleStartText

.wild
	call BattleCheckEnemyShininess
	jr nc, .not_shiny

	xor a
	ld [wNumHits], a
	ld a, 1
	ldh [hBattleTurn], a
	ld a, 1
	ld [wBattleAnimParam], a
	ld de, ANIM_SEND_OUT_MON
	call Call_PlayBattleAnim

.not_shiny
	call CheckSleepingTreeMon
	jr c, .skip_cry

	farcall CheckBattleScene
	jr c, .cry_no_anim

	hlcoord 12, 0
	ld de, ANIM_MON_NORMAL
	predef AnimateFrontpic
	jr .skip_cry ; cry is played during the animation

.cry_no_anim
	ld a, $f
	ld [wCryTracks], a
	ld a, [wTempEnemyMonSpecies]
	call PlayStereoCry

.skip_cry
	ld a, [wBattleType]
	cp BATTLETYPE_FISH
	jr nz, .NotFishing

	ld hl, HookedPokemonAttackedText
	jr .PrintBattleStartText

.NotFishing:
	ld hl, PokemonFellFromTreeText
	cp BATTLETYPE_TREE
	jr z, .PrintBattleStartText
	ld hl, WildCelebiAppearedText
	cp BATTLETYPE_CELEBI
	jr z, .PrintBattleStartText
	ld hl, WildPokemonAppearedText

.PrintBattleStartText:
	push hl
	farcall BattleStart_TrainerHuds
	pop hl
	jmp StdBattleTextbox

GetWeatherImage:
	ld a, [wBattleWeather]
	and a
	ret z
	ld de, RainWeatherImage
	lb bc, PAL_BATTLE_OB_BLUE, 4
	dec a
	jr z, .done
	ld de, SunWeatherImage
	ld b, PAL_BATTLE_OB_YELLOW
	dec a
	jr z, .done
	ld de, SandstormWeatherImage
	ld b, PAL_BATTLE_OB_BROWN
	dec a
	ret nz

.done
	push bc
	ld b, BANK(WeatherImages) ; c = 4
	ld hl, vTiles0
	call Request2bpp
	pop bc
	ld hl, wShadowOAMSprite00
	ld de, .WeatherImageOAMData
.loop
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	jr nz, .loop
	ret

.WeatherImageOAMData
; positions are backwards since
; we load them in reverse order
	db $88, $1c ; y/x - bottom right
	db $88, $14 ; y/x - bottom left
	db $80, $1c ; y/x - top right
	db $80, $14 ; y/x - top left