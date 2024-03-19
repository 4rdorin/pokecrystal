; item ids
; indexes for:
; - ItemNames (see data/items/names.asm)
; - ItemDescriptions (see data/items/descriptions.asm)
; - ItemAttributes (see data/items/attributes.asm)
; - ItemEffects (see engine/items/item_effects.asm)
	const_def
	const NO_ITEM
	; balls, 15 balls
	const POKE_BALL
	const GREAT_BALL
	const ULTRA_BALL
	const MASTER_BALL
	const HEAVY_BALL
	const LEVEL_BALL
	const LURE_BALL
	const FAST_BALL
	const FRIEND_BALL
	const MOON_BALL
	const LOVE_BALL
	const PARK_BALL
	const REPEAT_BALL
	const TIMER_BALL
	const QUICK_BALL
DEF NUM_BALL_ITEMS EQU const_value
; meds, 35 items
	const POTION
	const SUPER_POTION
	const HYPER_POTION
	const MAX_POTION
	const ANTIDOTE
	const BURN_HEAL
	const PARLYZ_HEAL
	const AWAKENING
	const ICE_HEAL
	const FULL_HEAL
	const FULL_RESTORE
	const REVIVE
	const MAX_REVIVE
	const ETHER
	const MAX_ETHER
	const ELIXER
	const MAX_ELIXER
	const HP_UP
	const PROTEIN
	const IRON
	const CARBOS
	const CALCIUM
	const RARE_CANDY
	const PP_UP
	const FRESH_WATER
	const SODA_POP
	const LEMONADE
	const MOOMOO_MILK
	const RAGECANDYBAR
	const SACRED_ASH
	const ENERGYPOWDER
	const ENERGY_ROOT
	const HEAL_POWDER
	const REVIVAL_HERB
	const BERRY_JUICE
; berries/apricorns, 10 berries
	const BERRY
	const GOLD_BERRY
	const PSNCUREBERRY
	const PRZCUREBERRY
	const MINT_BERRY
	const BURNT_BERRY
	const ICE_BERRY
	const BITTER_BERRY
	const MYSTERYBERRY
	const MIRACLEBERRY
	; 7 apricorns
	const RED_APRICORN
	const BLU_APRICORN
	const YLW_APRICORN
	const GRN_APRICORN
	const WHT_APRICORN
	const BLK_APRICORN
	const PNK_APRICORN
; hold items, 35 items
	const PINK_BOW
	const BLACKBELT_I
	const SHARP_BEAK
	const POISON_BARB
	const SOFT_SAND
	const HARD_STONE
	const SILVERPOWDER
	const SPELL_TAG
	const METAL_COAT
	const CHARCOAL
	const MYSTIC_WATER
	const MIRACLE_SEED
	const MAGNET
	const TWISTEDSPOON
	const NEVERMELTICE
	const DRAGON_FANG
	const DRAGON_SCALE
	const BLACKGLASSES
	const BRIGHTPOWDER
	const SCOPE_LENS
	const QUICK_CLAW
	const KINGS_ROCK
	const FOCUS_BAND
	const LEFTOVERS
	const LUCKY_EGG
	const AMULET_COIN
	const CLEANSE_TAG
	const SMOKE_BALL
	const BERSERK_GENE
	const LIGHT_BALL
	const STICK
	const THICK_CLUB
	const LUCKY_PUNCH
	const METAL_POWDER
	const EVERSTONE
; evolution items, 7 items
	const LEAF_STONE
	const FIRE_STONE
	const WATER_STONE
	const THUNDERSTONE
	const MOON_STONE
	const SUN_STONE
	const UPGRADE
; etc, 5 items
	const REPEL
	const SUPER_REPEL
	const MAX_REPEL
	const ESCAPE_ROPE
	const POKE_DOLL
; misc, sellable, 7 items
	const NUGGET
	const TINYMUSHROOM
	const BIG_MUSHROOM
	const PEARL
	const BIG_PEARL
	const STARDUST
	const STAR_PIECE
; mails, 10 items
	const FLOWER_MAIL
	const SURF_MAIL
	const LITEBLUEMAIL
	const PORTRAITMAIL
	const LOVELY_MAIL
	const EON_MAIL
	const MORPH_MAIL
	const BLUESKY_MAIL
	const MUSIC_MAIL
	const MIRAGE_MAIL
; special items, 5 items
	const BRICK_PIECE
	const SILVER_LEAF
	const GOLD_LEAF
	const NORMAL_BOX
	const GORGEOUS_BOX
; key items, 25 items
	const BICYCLE
	const OLD_ROD
	const GOOD_ROD
	const SUPER_ROD
	const EXP_SHARE
	const COIN_CASE
	const ITEMFINDER
	const MYSTERY_EGG
	const SQUIRTBOTTLE
	const SECRETPOTION
	const RED_SCALE
	const CARD_KEY
	const BASEMENT_KEY
	const S_S_TICKET
	const PASS
	const MACHINE_PART
	const LOST_ITEM
	const RAINBOW_WING
	const SILVER_WING
	const CLEAR_BELL
	const GS_BALL
	const BLUE_CARD
	const POCKET_PC
	const LEVEL_CAP
	const MUSIC_PLAYER
DEF NUM_CLASSIC_ITEMS EQU const_value
; reworked hold items, 7 items
	const X_ATTACK
	const X_DEFEND
	const X_SPEED
	const X_SPECIAL
	const X_ACCURACY
	const DIRE_HIT
	const GUARD_SPEC
; new hold items
	const SOOTHE_BELL

DEF NUM_USED_ITEMS EQU const_value
; unused items, 28 items
	const ITEM_64
	const ITEM_78
	const ITEM_87
	const ITEM_88
	const ITEM_89
	const ITEM_8D
	const ITEM_8E
	const ITEM_91
	const ITEM_93
	const ITEM_94
	const ITEM_95
	const ITEM_2D
	const ITEM_32
	const ITEM_99
	const ITEM_A2
	const ITEM_9A
	const ITEM_9B
	const ITEM_AB
	const ITEM_B0
	const ITEM_B3
	const ITEM_BE
	const ITEM_BF
	const ITEM_C0
	const ITEM_C1
	const ITEM_C2
	const ITEM_C3
	const ITEM_C4
	const ITEM_C5
DEF NUM_ITEMS EQU const_value - 1

DEF __tmhm_value__ = 1

MACRO add_tmnum
	DEF \1_TMNUM EQU __tmhm_value__
	DEF __tmhm_value__ += 1
ENDM

MACRO add_tm
; Defines three constants:
; - TM_\1: the item id, starting at $bf
; - \1_TMNUM: the learnable TM/HM flag, starting at 1
; - TM##_MOVE: alias for the move id, equal to the value of \1
	const TM_\1
	DEF TM{02d:__tmhm_value__}_MOVE = \1
	add_tmnum \1
ENDM

; see data/moves/tmhm_moves.asm for moves
DEF TM01 EQU const_value
	add_tm DYNAMICPUNCH
	add_tm HEADBUTT
	add_tm CURSE
	add_tm ROLLOUT
	add_tm ROAR
	add_tm TOXIC
	add_tm ZAP_CANNON
	add_tm ROCK_SMASH
	add_tm PSYCH_UP
	add_tm HIDDEN_POWER
	add_tm SUNNY_DAY
	add_tm SWEET_SCENT
	add_tm SNORE
	add_tm BLIZZARD
	add_tm HYPER_BEAM
	add_tm ICY_WIND
	add_tm PROTECT
	add_tm RAIN_DANCE
	add_tm GIGA_DRAIN
	add_tm ENDURE
	add_tm FRUSTRATION
	add_tm SOLARBEAM
	add_tm IRON_TAIL
	add_tm DRAGONBREATH
	add_tm THUNDER
	add_tm EARTHQUAKE
	add_tm RETURN
	add_tm DIG
	add_tm PSYCHIC_M
	add_tm SHADOW_BALL
	add_tm MUD_SLAP
	add_tm DOUBLE_TEAM
	add_tm ICE_PUNCH
	add_tm SWAGGER
	add_tm SLEEP_TALK
	add_tm SLUDGE_BOMB
	add_tm SANDSTORM
	add_tm FIRE_BLAST
	add_tm SWIFT
	add_tm DEFENSE_CURL
	add_tm THUNDERPUNCH
	add_tm DREAM_EATER
	add_tm DETECT
	add_tm REST
	add_tm ATTRACT
	add_tm THIEF
	add_tm STEEL_WING
	add_tm FIRE_PUNCH
	add_tm FURY_CUTTER
	add_tm NIGHTMARE
DEF NUM_TMS EQU __tmhm_value__ - 1

MACRO add_hm
; Defines three constants:
; - HM_\1: the item id, starting at $f3
; - \1_TMNUM: the learnable TM/HM flag, starting at 51
; - HM##_MOVE: alias for the move id, equal to the value of \1
	const HM_\1
	DEF HM_VALUE = __tmhm_value__ - NUM_TMS
	DEF HM{02d:HM_VALUE}_MOVE = \1
	add_tmnum \1
ENDM

DEF HM01 EQU const_value
	add_hm CUT          ; f3
	add_hm FLY          ; f4
	add_hm SURF         ; f5
	add_hm STRENGTH     ; f6
	add_hm FLASH        ; f7
	add_hm WHIRLPOOL    ; f8
	add_hm WATERFALL    ; f9
DEF NUM_HMS EQU __tmhm_value__ - NUM_TMS - 1

MACRO add_mt
; Defines two constants:
; - \1_TMNUM: the learnable TM/HM flag, starting at 58
; - MT##_MOVE: alias for the move id, equal to the value of \1
	DEF MT_VALUE = __tmhm_value__ - NUM_TMS - NUM_HMS
	DEF MT{02d:MT_VALUE}_MOVE = \1
	add_tmnum \1
ENDM

DEF MT01 EQU const_value
	add_mt FLAMETHROWER
	add_mt THUNDERBOLT
	add_mt ICE_BEAM
	add_mt TELEPORT
	add_mt PSYWAVE
	add_mt WHIRLWIND
	add_mt BUBBLEBEAM
	add_mt METRONOME
	add_mt MEGA_DRAIN
	add_mt SUBSTITUTE
	add_mt COUNTER
	add_mt SEISMIC_TOSS
	add_mt TRI_ATTACK
	add_mt THUNDER_WAVE
	add_mt BODY_SLAM
	add_mt ROCK_SLIDE
	add_mt SELFDESTRUCT
	add_mt SWORDS_DANCE
	add_mt EXPLOSION

DEF NUM_TUTORS = __tmhm_value__ - NUM_TMS - NUM_HMS - 1

DEF NUM_TM_HM_TUTOR EQU NUM_TMS + NUM_HMS + NUM_TUTORS

	const ITEM_FA       ; fa

DEF USE_SCRIPT_VAR EQU $00
DEF ITEM_FROM_MEM  EQU $ff

; leftovers from red
DEF MOON_STONE_RED EQU $0a ; BURN_HEAL
DEF FULL_HEAL_RED  EQU $34 ; X_SPEED
