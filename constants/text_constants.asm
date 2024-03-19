; name lengths
DEF NAME_LENGTH               EQU 11
DEF PLAYER_NAME_LENGTH        EQU 8
DEF BOX_NAME_LENGTH           EQU 9
DEF MON_NAME_LENGTH           EQU 11
DEF MOVE_NAME_LENGTH          EQU 13
DEF ITEM_NAME_LENGTH          EQU 13
DEF TRAINER_CLASS_NAME_LENGTH EQU 13
DEF NAME_LENGTH_JAPANESE      EQU 6

; GetName types (see home/names.asm)
	const_def 1
	const MON_NAME              ; 1
	const MOVE_NAME             ; 2
	const ITEM_NAME             ; 3
	const PARTY_OT_NAME         ; 4
	const ENEMY_OT_NAME         ; 5
	const TRAINER_NAME          ; 6

; see home/text.asm
DEF BORDER_WIDTH   EQU 2
DEF TEXTBOX_WIDTH  EQU SCREEN_WIDTH
DEF TEXTBOX_INNERW EQU TEXTBOX_WIDTH - BORDER_WIDTH
DEF TEXTBOX_HEIGHT EQU 6
DEF TEXTBOX_INNERH EQU TEXTBOX_HEIGHT - BORDER_WIDTH
DEF TEXTBOX_X      EQU 0
DEF TEXTBOX_INNERX EQU TEXTBOX_X + 1
DEF TEXTBOX_Y      EQU SCREEN_HEIGHT - TEXTBOX_HEIGHT
DEF TEXTBOX_INNERY EQU TEXTBOX_Y + 2

; see gfx/frames/*.png
DEF TEXTBOX_FRAME_TILES EQU 6

; PrintNum bit flags
	const_def 5
	const PRINTNUM_MONEY_F        ; 5
	const PRINTNUM_LEFTALIGN_F    ; 6
	const PRINTNUM_LEADINGZEROS_F ; 7

; PrintNum arguments (see engine/math/print_num.asm)
DEF PRINTNUM_MONEY        EQU 1 << PRINTNUM_MONEY_F
DEF PRINTNUM_LEFTALIGN    EQU 1 << PRINTNUM_LEFTALIGN_F
DEF PRINTNUM_LEADINGZEROS EQU 1 << PRINTNUM_LEADINGZEROS_F

; character sets (see charmap.asm)
DEF FIRST_REGULAR_TEXT_CHAR     EQU $7f
DEF FIRST_HIRAGANA_DAKUTEN_CHAR EQU $20

; gfx/font/unown_font.png
DEF FIRST_UNOWN_CHAR EQU $40

; gfx/font/vwf.png
DEF FIRST_VWF_CHAR    EQU " " ; first printable character
DEF LAST_VWF_CHAR     EQU "9" ; last printable character
DEF FAILSAFE_VWF_CHAR EQU "."