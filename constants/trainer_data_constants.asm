; TrainerClassAttributes struct members (see data/trainers/attributes.asm)
rsreset
DEF TRNATTR_ITEM1           rb ; 0
DEF TRNATTR_ITEM2           rb ; 1
DEF TRNATTR_BASEMONEY       rb ; 2
DEF TRNATTR_AI_MOVE_WEIGHTS rw ; 3
DEF TRNATTR_AI_ITEM_SWITCH  rw ; 5
DEF NUM_TRAINER_ATTRIBUTES EQU _RS

; TRNATTR_AI_MOVE_WEIGHTS bit flags (wEnemyTrainerAIFlags)
; AIScoringPointers indexes (see engine/battle/ai/move.asm)
	const_def
	shift_const AI_BASIC
	shift_const AI_SETUP
	shift_const AI_TYPES
	shift_const AI_OFFENSIVE
	shift_const AI_SMART
	shift_const AI_OPPORTUNIST
	shift_const AI_AGGRESSIVE
	shift_const AI_CAUTIOUS
	shift_const AI_STATUS
	shift_const AI_RISKY
DEF NO_AI EQU 0

; TRNATTR_AI_ITEM_SWITCH bit flags
	const_def
	const SWITCH_OFTEN_F     ; 0
	const SWITCH_RARELY_F    ; 1
	const SWITCH_SOMETIMES_F ; 2
	const SWITCH_COMPETITIVE_F ; 3
	const KEEP_ORDER_F       ; 5
	const ALWAYS_USE_F       ; 5
	const CONTEXT_USE_F      ; 6

DEF SWITCH_OFTEN       EQU 1 << SWITCH_OFTEN_F
DEF SWITCH_RARELY      EQU 1 << SWITCH_RARELY_F
DEF SWITCH_SOMETIMES   EQU 1 << SWITCH_SOMETIMES_F
DEF SWITCH_COMPETITIVE  EQU 1 << SWITCH_COMPETITIVE_F
DEF KEEP_ORDER         EQU 1 << KEEP_ORDER_F
DEF ALWAYS_USE         EQU 1 << ALWAYS_USE_F
DEF CONTEXT_USE        EQU 1 << CONTEXT_USE_F

; TrainerTypes bits (see engine/battle/read_trainer_party.asm)
	const_def
	const TRAINERTYPE_MOVES_F ; 0
	const TRAINERTYPE_ITEM_F  ; 1
	const TRAINERTYPE_NICKNAME_F ; 2
	const TRAINERTYPE_DVS_F ; 3
	const TRAINERTYPE_STAT_EXP_F ; 4
	const TRAINERTYPE_RANDOM_F ; 7

; Trainer party types (see data/trainers/parties.asm)
DEF TRAINERTYPE_NORMAL     EQU 0
DEF TRAINERTYPE_MOVES      EQU 1 << TRAINERTYPE_MOVES_F
DEF TRAINERTYPE_ITEM       EQU 1 << TRAINERTYPE_ITEM_F
DEF TRAINERTYPE_ITEM_MOVES EQU TRAINERTYPE_MOVES | TRAINERTYPE_ITEM
DEF TRAINERTYPE_NICKNAME   EQU 1 << TRAINERTYPE_NICKNAME_F
DEF TRAINERTYPE_DVS        EQU 1 << TRAINERTYPE_DVS_F
DEF TRAINERTYPE_STAT_EXP   EQU 1 << TRAINERTYPE_STAT_EXP_F
DEF TRAINERTYPE_RANDOM     EQU 1 << TRAINERTYPE_RANDOM_F

DEF PERFECT_DV EQU $00 ; treated as $FF in enemy party data
DEF PERFECT_STAT_EXP EQU $0000 ; treated as $FFFF in enemy party data

	const_def
 	const RANDOMLIST_0