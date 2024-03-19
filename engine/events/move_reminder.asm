MoveRemind:
	ld hl, MoveReminderIntroText
	call PrintText
	call YesNoBox
	jr c, .cancel

	ld hl, MoveReminderWhichMonText
	call PrintText

; This code falls through into the ".loop_party_menu" local jump.

; This is where the party menu loop begins.
; Loads the party menu to select a Pokémon. Relative jump
; to the ".cancel" local jump if the player leaves
; the party menu without selecting anything.

.loop_party_menu	
	farcall SelectMonFromParty
	jr c, .cancel

	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .is_an_egg

	call IsAPokemon
	jr c, .not_a_pokemon

	call GetRemindableMoves
	jr z, .no_moves_to_learn

	ld hl, MoveReminderWhichMoveText
	call PrintText

; This code falls through into the ".recheck_for_moves" local jump.

; Rechecks for any moves that can be learned. Relative
; jump to the ".no_moves_to_learn" local jump if
; there are none and relative jump to the
; ".loop_move_menu" local jump if there are.

.loop_move_menu
	; Generates the Move Reminder's menu. Relative jump to the
	; ".exit_menu" local jump if the player leaves
	; the menu and continue if they do not.

	call ChooseMoveToLearn
	jr c, .loop_party_menu

	; If the player selects a move, load the move's name and copy
	; it for later. This is used for displaying the move's
	; name in some of the text boxes while learning a move.

	ld a, [wMenuSelection]
	ld [wNamedObjectIndex], a
	call GetMoveName
	call CopyName1

	; The "LearnMove" label sets the value of the "b" register to "1"
	; when a move is successfully learned and sets it to "0" if
	; cancelled at any point in the move learning process.

	predef LearnMove

	ld a, b
	dec a
	jr z, .move_learned

; This code falls through into the ".recheck_for_moves" local jump.

; Rechecks for any moves that can be learned. Relative
; jump to the ".no_moves_to_learn" local jump if
; there are none and relative jump to the
; ".loop_move_menu" local jump if there are.

.recheck_for_moves
	call GetRemindableMoves
	jr z, .no_moves_to_learn
	jr .loop_move_menu

.cancel
	ld hl, MoveReminderCancelText
	jmp PrintText

.is_an_egg
	ld hl, MoveReminderEggText
	call PrintText
	jr .loop_party_menu

.not_a_pokemon
	ld hl, MoveReminderNotaMonText
	call PrintText
	jr .loop_party_menu

.no_moves_to_learn
	ld hl, MoveReminderNoMovesText
	call PrintText
	jr .loop_party_menu

.move_learned
	call ReturnToMapWithSpeechTextbox
	ld hl, MoveReminderMoveLearnedText
	call PrintText
	jr .recheck_for_moves	;Remove this line (and change last line with a jmp) to exit after relearning

; Checks for moves that can be learned and returns
; a zero flag if there are none.
GetRemindableMoves:
; Get moves remindable by CurPartyMon
; Returns z if no moves can be reminded.
	; The "wMoveReminder" wram label is being used to store
	; the moves for placement in the move list.
	ld hl, wMoveReminder
	xor a
	ld [hli], a
	ld [hl], $ff

	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld a, [hl]
	ld [wCurPartySpecies], a

	push af
	ld a, MON_LEVEL
	call GetPartyParamLocation
	ld a, [hl]
	ld [wCurPartyLevel], a

	; The "b" register will contain the number of
	; moves in the move list and "wMoveReminder + 1"
	; is where the move list begins.
	ld b, 0
	ld de, wMoveReminder + 1

	; Retrieves the currently selected Pokémon's evolution
	; and attack address from the "EvosAttacksPointers"
	; table that is located in another bank. This is the
	; list of evolutions and learnset of every Pokémon.
	ld a, [wCurPartySpecies]
	dec a
	push bc
	ld c, a
	ld hl, EvosAttacksPointers
	add hl, bc
	add hl, bc
	ld a, BANK(EvosAttacksPointers)
	call GetFarWord

; Skips the evolution data to start at the learnset for the
; currently selected Pokémon in the "EvosAttacksPointers"
; table. This is "db 0 ; no more evolutions".
.skip_evos
	ld a, BANK("Evolutions and Attacks")
	call GetFarByte
	inc hl
	and a
	jr nz, .skip_evos

; Loops through the move list until it reaches
; the end of the "EvosAttacksPointers" table
; for the currently selected Pokémon. This is
; "db 0 ; no more level-up moves".

; It then compares the currently selected Pokémon's
; level with the level the move is learned at and
; if the Pokémon's level is higher, it will
; attempt to add the move to the move list.
.loop_moves
	ld a, BANK("Evolutions and Attacks")
	call GetFarByte
	inc hl
	and a
	jr z, .done
	ld c, a
	ld a, [wCurPartyLevel]
	cp c
	ld a, BANK("Evolutions and Attacks")
	call GetFarByte
	inc hl
	jr c, .loop_moves

	; Checks if the move is already in the
	; move list or already learned by the
	; Pokémon. If both are false, then the
	; move will be added to the move list.
	ld c, a
	call CheckAlreadyInList
	jr c, .loop_moves
	call CheckPokemonAlreadyKnowsMove
	jr c, .loop_moves
	ld a, c
	ld [de], a
	inc de
	ld a, $ff
	ld [de], a
	pop bc
	inc b
	push bc
	jr .loop_moves

.done
	pop bc
	pop af
	ld [wCurPartySpecies], a
	ld a, b
	ld [wMoveReminder], a
	and a
	ret

; Checks if there is a move already placed
; in the move list. This prevents
; duplicate entries in the move list.
CheckAlreadyInList:
	push hl
	ld hl, wMoveReminder + 1
.loop
	ld a, [hli]
	inc a
	jr z, .nope
	dec a
	cp c
	jr nz, .loop
	pop hl
	scf
	ret
.nope
	pop hl
	and a
	ret

; Checks if a Pokémon already knows a move. This
; prevents the player teaching the currently
; selected Pokémon a move it already knows.
CheckPokemonAlreadyKnowsMove:
	push hl
	push bc
	ld a, MON_MOVES
	call GetPartyParamLocation
	ld b, 4
.loop
	ld a, [hli]
	cp c
	jr z, .yes
	dec b
	jr nz, .loop
	pop bc
	pop hl
	and a
	ret
.yes
	pop bc
	pop hl
	scf
	ret

; Creates a scrolling menu and sets up the menu gui.
; The number of items is stored in "wMoveReminder"
; The list of items is stored in "wMoveReminder + 1"
ChooseMoveToLearn:
	farcall FadeOutToWhite
	farcall BlankScreen
	ld hl, .MenuHeader
	call CopyMenuHeader
	xor a
	ld [wMenuCursorPosition], a
	ld [wMenuScrollPosition], a

	; This creates a border around the move list.
	; "hlcoord" configures the position.
	; "lb bc" configures the size.
	hlcoord 0,  1
	lb bc, 9, 18
	call TextboxBorder

	; This replaces the tile using the identifier
	; of "$6e" with the fourteenth tile of the
	; "FontBattleExtra gfx" font. Also, only 1
	; tile will be loaded as loading the entire
	; "FontBattleExtra gfx" font will overwrite
	; the "UP" arrow in the menu.
	ld de, FontBattleExtra + 14 tiles
	ld hl, vTiles2 tile $6e
	lb bc, BANK(FontBattleExtra), 1
	call Get2bppViaHDMA

	; This is used for displaying the symbol that
	; appears before the Pokémon's level. Without
	; it, an incorrect symbol will appear.
	farcall LoadStatsScreenPageTilesGFX

	; This displays the Pokémon's species
	; name (not nickname) at the
	; coordinates defined at "hlcoord".
	; In this case that is the
	; top left of the screen.
	xor a
	ld [wMonType], a
	ld a, [wCurPartySpecies]
	ld [wNamedObjectIndex], a
	call GetPokemonName
	hlcoord  5, 1
	rst PlaceString

	; This displays the Pokémon's level
	; right after the Pokémon's name.
	push bc
	farcall CopyMonToTempMon
	pop hl
	call PrintLevel

	; This displays the pokemon icon
	farcall ClearSpriteAnims2
	ld a, [wCurPartySpecies]
	ld [wTempIconSpecies], a
	ld e, MONICON_MOVES
	farcall LoadMenuMonIcon
	hlcoord 2, 0
	lb bc, 2, 3
	call ClearBox

	ld b, SCGB_MOVE_REMINDER
	call GetSGBLayout ; reload proper palettes for new Move Type and Category, and apply

	; Creates the menu, sets the "B_BUTTON"
	; to cancel and sets up each entry
	; to behave like a tm/hm.
	call ScrollingMenu_Icon
	ld a, [wMenuJoypad]
	cp B_BUTTON
	jr z, .carry
	ld a, [wMenuSelection]
	ld [wPutativeTMHMMove], a
	and a
	ret

; Sets the carry flag and returns from
; this subroutine. Setting the carry
; flag being set will cause the
; menu to exit after returning.
.carry
	scf
	ret

; The menu header defines the menu's position and
; what will be included. The last two values
; of "menu_coords" will determine where the
; vertical scroll arrows will be located.
.MenuHeader:
	db MENU_BACKUP_TILES
	menu_coords 1, 2, SCREEN_WIDTH - 2, 10
	dw .MenuData
	db 1

; This sets up the menu's contents, including the amount
; of entries displayed before scrolling is required.

; Vertical scroll arrows and the move's
; details will be displayed.

; This menu is populated with an item and three functions.
; The item is "wMoveReminder".
; Function 1 is the ".print_move_name" local jump.
; Function 2 is the ".print_pp" local jump.
; Function 3 is the ".print_move_details" local jump.
.MenuData:
	db SCROLLINGMENU_DISPLAY_ARROWS | SCROLLINGMENU_ENABLE_FUNCTION3
	db 4, SCREEN_WIDTH + 2
	db SCROLLINGMENU_ITEMS_NORMAL
	dba  wMoveReminder
	dba .print_move_name
	dba .print_pp
	dba .print_move_details

; This prints the move's name in the menu.
; This is purely visual as the actual
; entry is stored in "wMoveReminder".
.print_move_name
	push de
	ld a, [wMenuSelection]
	ld [wNamedObjectIndex], a
	call GetMoveName
	pop hl
	jp PlaceString

; This prints the move's pp offset by one
; line with some spacing from the left.
.print_pp
	ld hl, wStringBuffer1
	ld bc, wStringBuffer2 - wStringBuffer1
	ld a, " "
	call ByteFill
	ld a, [wMenuSelection]
	inc a
	ret z
	dec a
	push de

	ld a, [wMenuSelection]
	ld bc, MOVE_LENGTH
	ld hl, (Moves + MOVE_PP) - MOVE_LENGTH
	call AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	ld [wMRBuffer], a
	ld hl, wStringBuffer1 + 9
	ld de, wMRBuffer
	lb bc, 1, 2
	call PrintNum
	ld hl, wStringBuffer1 + 11
	ld [hl], "/"
	ld hl, wStringBuffer1 + 12
	call PrintNum
	
	ld hl, wStringBuffer1 + 14
	ld [hl], "@"

	pop hl
	ld de, wStringBuffer1
	rst PlaceString

	; This prints the pp gfx before the move's pp.
	ld bc, 6
	add hl, bc
	ld a, $3e
	ld [hli], a
	ld [hl], a
	ret

; This adds a text box border line to the description
; box that replaces a leftover piece of the notch
; that remains when the cancel option is highlighted.
.cancel_border_fix
	hlcoord 0, 10
	ld [hl], "│"
	inc hl
	ret

; This begins the printing of all of the move's details,
; including the border around the description.
.print_move_details

	; This creates a border around the description.
	hlcoord 0, 11
	lb bc, 5, 18
	call TextboxBorder

	; This code will relative jump to the
	; ".cancel_border_fix" local jump if
	; the cancel entry is highlighted.
	ld a, [wMenuSelection]
	cp -1
	jr z, .cancel_border_fix
; This code falls through into the ".print_move_desc" local jump.

; This prints the moves description.
.print_move_desc
	push de
	ld a, [wMenuSelection]
	inc a
	pop de
	ret z
	dec a
	ld [wCurSpecies], a
	hlcoord 1, 15
	call PrintMoveDescription
	ld b, SCGB_MOVE_REMINDER
	call GetSGBLayout ; reload proper palettes for new Move Type and Category, and apply
	ld a, $1 ; done editing the screen
	ldh [hBGMapMode], a

; Print UI elements
	hlcoord 0, 10
	ld de, MoveTypeTopString
	rst PlaceString

	hlcoord 0, 11
	ld de, MoveTypeString
	rst PlaceString

	hlcoord 2, 12
	ld de, MoveAttackString
	rst PlaceString

	hlcoord 11, 12
	ld de, MoveAccuracyString
	rst PlaceString

	hlcoord 11, 13
	ld de, MoveChanceString
	rst PlaceString

; Print move Category
	call GetCurMoveCategory
	ld hl, CategoryIconGFX ; ptr to Category GFX loaded from PNG(2bpp)
	ld bc, 2 tiles
	rst AddNTimes
	ld d, h
	ld e, l
	ld hl, vTiles2 tile $59 ; category icon tile slot in VRAM, destination
	lb bc, BANK(CategoryIconGFX), 2
	call Request2bpp ; Load 2bpp at b:de to occupy c tiles of hl.
	hlcoord 7, 13
	ld a, $59 ; category icon tile 1
	ld [hli], a
	ld [hl], $5a ; category icon tile 2

; Print move Type
	call GetCurMoveType
	; Load Type GFX Tiles, color will be in Slot 4 of Palette
	ld hl, TypeIconGFX ; ptr for PNG w/ black Tiles, since this screen is using Slot 4 in the Palette for Type color
	ld bc, 4 * LEN_1BPP_TILE ; purely Black and White tiles are 1bpp. Type Tiles are 4 Tiles wide
	rst AddNTimes ; increments pointer based on Type Index
	ld d, h
	ld e, l ; de is the source Pointer
	ld hl, vTiles2 tile $5b ; $5b is destination Tile for first Type Tile
	lb bc, BANK(TypeIconGFX), 4 ; Bank in 'b', num of Tiles to load in 'c'
	call Request1bpp
	hlcoord 2, 13
	ld a, $5b ; first Type Tile
	ld [hli], a
	inc a ; Tile $5c
	ld [hli], a
	inc a ; Tile $5d
	ld [hli], a
	ld [hl], $5e ; final Type Tile

; Place Move Effect Chance
	ld a, [wMenuSelection]
	ld hl, Moves + MOVE_CHANCE
	call GetMoveProperty
	cp 1
	jr c, .print_move_null_chance
	call Adjust_percent
	ld [wMRBuffer], a
	ld de, wMRBuffer
	lb bc, 1, 3
	hlcoord 15, 13
	call PrintNum
	hlcoord 18, 13
	ld [hl], "<%>"
	jr .print_move_accuracy

.print_move_null_chance
	ld de, MoveNullValueString
	ld bc, 3
	hlcoord  15, 13
	rst PlaceString
; This code falls through into the ".print_move_accuracy" local jump.

; Print Move Accuracy
.print_move_accuracy
	ld a, [wMenuSelection]
	ld hl, Moves + MOVE_EFFECT
	call GetMoveProperty
	cp EFFECT_MIRROR_MOVE
	;jr nc, .perfect_accuracy	;Quitar comentario para no mostrar precisión de ataques que no fallan nunca

	ld a, [wMenuSelection]
	ld hl, Moves + MOVE_ACC
	call GetMoveProperty
	call Adjust_percent
	ld [wMRBuffer], a
	ld de, wMRBuffer
	lb bc, 1, 3
	hlcoord 15, 12
	call PrintNum
	hlcoord 18, 12
	ld [hl], "<%>"
	jr .print_move_attack

; This prints "---" if the move
; has perfect accuracy.
.perfect_accuracy
	ld de, MoveNullValueString
	ld bc, 3
	hlcoord 15, 12
	rst PlaceString

; Print Move Power
.print_move_attack
	ld a, [wMenuSelection]
	ld hl, Moves + MOVE_POWER
	call GetMoveProperty
	cp 2
	jr c, .print_move_null_attack
	ld [wMRBuffer], a
	ld de, wMRBuffer
	lb bc, 1, 3
	hlcoord 6, 12
	jp PrintNum

; This prints "---" if the move has an attack of "0".
; This means that the move does not initially cause
; damage or is a one hit knockout move.
.print_move_null_attack
	hlcoord 6, 12
	ld de, MoveNullValueString
	ld bc, 3
	jp PlaceString

; This is a notch that will be placed on
; the top left of the description box.
MoveTypeTopString:
	db "┌─────┐@"

; This is the string that displays
; above the move's type.
MoveTypeString:
	db "│INFO/└@"

; This is the string that precedes
; the move's attack number.
MoveAttackString:
	db "ATK/@"

; This displays when a move has
; a metric with a null value.
MoveNullValueString:
	db "---@"

; This is the string that precedes
; the move's accuracy number.
MoveAccuracyString:
	db "ACC/@"

; This is the string that precedes the
; move's status effect chance number.
MoveChanceString:
	db "EFF/@"

; This is the text that displays when the player
; first talks to the move reminder.
MoveReminderIntroText:
	text "Hi, I'm the Move"
	line "Reminder!"

	para "I can make #MON"
	line "remember moves."

	para "Are you"
	line "interested?"
	done

; This is the text that displays just
; before the party menu opens.
MoveReminderWhichMonText:
	text "Which #MON?"
	prompt

; This is the text that displays after
; a Pokémon has been selected.
MoveReminderWhichMoveText:
	text "Which move should"
	line "it remember, then?"
	prompt

; This is the text that displays just before
; the player ends the dialogue
; with the move reminder.
MoveReminderCancelText:
	text "Come visit me"
	line "again."
	done

; This is the text that displays if the player
; selects an egg in the party menu.
MoveReminderEggText:
	text "An EGG can't learn"
	line "any moves!"
	prompt

; This is the text that displays if the player
; selects an entry in the party menu that
; is neither a Pokémon or an egg.
MoveReminderNotaMonText:
	text "What is that!?"

	para "I'm sorry, but I"
	line "can only teach"
	cont "moves to #MON!"
	prompt

; This is the text that displays if the player
; selects a Pokémon in the party menu that
; has no moves that can be learned.
MoveReminderNoMovesText:
	text "There are no moves"
	line "for this #MON"
	cont "to learn."
	prompt

; This is the text that displays after a
; Pokémon successfully learns a move.
MoveReminderMoveLearnedText:
	text "Done! Your #MON"
	line "remembered the"
	cont "move."
	prompt
