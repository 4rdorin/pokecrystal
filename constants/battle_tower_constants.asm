DEF BATTLETOWER_PARTY_LENGTH EQU 3
DEF BATTLETOWER_STREAK_LENGTH EQU 7

DEF BATTLETOWER_NUM_UNIQUE_MON EQU 21
DEF BATTLETOWER_NUM_UNIQUE_TRAINERS EQU 70

DEF BATTLETOWER_TRAINERDATALENGTH EQU $24
DEF BATTLE_TOWER_STRUCT_LENGTH EQUS "(NAME_LENGTH + BATTLETOWER_PARTY_LENGTH * NICKNAMED_MON_STRUCT_LENGTH + BATTLETOWER_TRAINERDATALENGTH)"

; BattleTowerAction setval arguments (see engine/events/battle_tower/battle_tower.asm)
	const_def
	const BATTLETOWERACTION_CHECK_EXPLANATION_READ
	const BATTLETOWERACTION_SET_EXPLANATION_READ
	const BATTLETOWERACTION_GET_CHALLENGE_STATE
	const BATTLETOWERACTION_SAVE_AND_QUIT
	const BATTLETOWERACTION_CHALLENGECANCELED
	const BATTLETOWERACTION_SAVELEVELGROUP
	const BATTLETOWERACTION_LOADLEVELGROUP
	const BATTLETOWERACTION_CHECKSAVEFILEISYOURS
	const BATTLETOWERACTION_0A
	const BATTLETOWERACTION_RESETDATA ; clear data
	const BATTLETOWERACTION_GIVEREWARD ; give reward
	const BATTLETOWERACTION_1C ; set won challenge
	const BATTLETOWERACTION_1D ; set received reward
	const BATTLETOWERACTION_CHOOSEREWARD ; save options
	const BATTLETOWERACTION_SAVEOPTIONS

; BattleTowerText arguments (see engine/events/battle_tower/trainer_text.asm)
	const_def 1
	const BATTLETOWERTEXT_INTRO
	const BATTLETOWERTEXT_WIN_TEXT
	const BATTLETOWERTEXT_LOSS_TEXT

; sBattleTowerChallengeState values
	const_def
	const BATTLETOWER_NO_CHALLENGE
	const BATTLETOWER_SAVED_AND_LEFT
	const BATTLETOWER_CHALLENGE_IN_PROGRESS
	const BATTLETOWER_WON_CHALLENGE
	const BATTLETOWER_RECEIVED_REWARD