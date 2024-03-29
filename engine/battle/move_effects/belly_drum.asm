BattleCommand_BellyDrum:
	call BattleCommand_AttackUp2
	ld a, [wAttackMissed]
	and a
	jr nz, .failed

	farcall GetHalfMaxHP
	farcall CheckUserHasEnoughHP
	jr nc, .failed

	push bc
	call AnimateCurrentMove
	pop bc
	farcall SubtractHPFromUser
	call UpdateUserInParty
	ld a, MAX_STAT_LEVEL - BASE_STAT_LEVEL - 1

.max_attack_loop
	push af
	call BattleCommand_AttackUp2
	pop af
	dec a
	jr nz, .max_attack_loop

	ld hl, BellyDrumText
	jmp StdBattleTextbox

.failed
	call AnimateFailedMove
	jmp PrintButItFailed
