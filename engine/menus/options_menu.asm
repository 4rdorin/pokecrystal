_Option:
	call ClearJoypad
	ld hl, hInMenu
	ld a, [hl]
	push af
	ld [hl], TRUE
	call ClearBGPalettes
	hlcoord 0, 0
	ld b, SCREEN_HEIGHT - 2
	ld c, SCREEN_WIDTH - 2
	call Textbox
	hlcoord 2, 2
	ld de, StringOptions1
	rst PlaceString
	xor a
	ld [wCurOptionsPage], a

	call OptionsMenu_LoadOptions

	xor a
	ld [wJumptableIndex], a
	call WaitBGMap
	ld b, SCGB_DIPLOMA
	call GetSGBLayout
	call SetDefaultBGPAndOBP

.joypad_loop
	call JoyTextDelay
	ldh a, [hJoyPressed]
	and START | B_BUTTON
	jr nz, .ExitOptions
	call OptionsControl
	jr c, .dpad
	call GetOptionPointer
	jr c, .ExitOptions

.dpad
	call Options_UpdateCursorPosition
	ld c, 3
	call DelayFrames
	jr .joypad_loop

.ExitOptions:
	ld de, SFX_TRANSACTION
	call PlaySFX
	call WaitSFX
	pop af
	ldh [hInMenu], a
	ret

OptionsMenu_LoadOptions:
	xor a
	ld [wJumptableIndex], a
	ldh [hJoyPressed], a
	ld c, $6 ; number of items on the menu minus 1 (for done)
.print_text_loop ; this next will display the settings of each option when the menu is opened
	push bc
	xor a
	ldh [hJoyLast], a
	call GetOptionPointer
	pop bc
	ld hl, wJumptableIndex
	inc [hl]
	dec c
	jr nz, .print_text_loop
	ld a, [wCurOptionsPage]
	and a
	call z, UpdateFrame
	ld a, 1
	ldh [hBGMapMode], a
	ret

StringOptions1:
	db "TEXT SPEED<LF>"
	db "        :<LF>"
	db "BATTLE SCENE<LF>"
	db "        :<LF>"
	db "FOLLOWERS<LF>"
	db "        :<LF>"
	db "SOUND<LF>"
	db "        :<LF>"
	db "PRINT<LF>"
	db "        :<LF>"
	db "FRAME<LF>"
	db "        :TYPE<LF>"
	db "NEXT<LF>"
	db "         <LF>"
	db "CANCEL@"

StringOptions2:
	db "TEXT SPEED<LF>"
	db "        :<LF>"
	db "BATTLE SCENE<LF>"
	db "        :<LF>"
	db "FOLLOWERS<LF>"
	db "        :<LF>"
	db "SOUND<LF>"
	db "        :<LF>"
	db "PRINT<LF>"
	db "        :<LF>"
	db "FRAME<LF>"
	db "        :TYPE<LF>"
	db "BACK<LF>"
	db "         <LF>"
	db "CANCEL@"

GetOptionPointer:
	ld a, [wCurOptionsPage]
	and a
	ld a, [wJumptableIndex]
	jr z, .page1
	add 8
.page1
	jumptable .Pointers, wJumptableIndex

.Pointers:
	dw Options_TextSpeed
	dw Options_BattleScene
	dw Options_Followers
	dw Options_Sound
	dw Options_Print
	dw Options_Frame
	dw Options_NextPrevious
	dw Options_Cancel

	dw Options_TextSpeed
	dw Options_BattleScene
	dw Options_Followers
	dw Options_Sound
	dw Options_Print
	dw Options_Frame
	dw Options_NextPrevious
	dw Options_Cancel

	const_def
	const OPT_TEXT_SPEED_FAST ; 0
	const OPT_TEXT_SPEED_MED  ; 1
	const OPT_TEXT_SPEED_SLOW ; 2

Options_TextSpeed:
	call GetTextSpeed
	ldh a, [hJoyPressed]
	bit D_LEFT_F, a
	jr nz, .LeftPressed
	bit D_RIGHT_F, a
	jr z, .NonePressed
	ld a, c ; right pressed
	cp OPT_TEXT_SPEED_SLOW
	jr c, .Increase
	ld c, OPT_TEXT_SPEED_FAST - 1

.Increase:
	inc c
	ld a, e
	jr .Save

.LeftPressed:
	ld a, c
	and a
	jr nz, .Decrease
	ld c, OPT_TEXT_SPEED_SLOW + 1

.Decrease:
	dec c
	ld a, d

.Save:
	ld b, a
	ld a, [wOptions]
	and $f0
	or b
	ld [wOptions], a

.NonePressed:
	ld b, 0
	ld hl, .Strings
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 11, 3
	rst PlaceString
	and a
	ret

.Strings:
; entries correspond to OPT_TEXT_SPEED_* constants
	dw .Fast
	dw .Mid
	dw .Slow

.Fast: db "FAST@"
.Mid:  db "MID @"
.Slow: db "SLOW@"

GetTextSpeed:
; converts TEXT_DELAY_* value in a to OPT_TEXT_SPEED_* value in c,
; with previous/next TEXT_DELAY_* values in d/e
	ld a, [wOptions]
	and TEXT_DELAY_MASK
	cp TEXT_DELAY_SLOW
	jr z, .slow
	cp TEXT_DELAY_FAST
	jr z, .fast
	; none of the above
	ld c, OPT_TEXT_SPEED_MED
	lb de, TEXT_DELAY_FAST, TEXT_DELAY_SLOW
	ret

.slow
	ld c, OPT_TEXT_SPEED_SLOW
	lb de, TEXT_DELAY_MED, TEXT_DELAY_FAST
	ret

.fast
	ld c, OPT_TEXT_SPEED_FAST
	lb de, TEXT_DELAY_SLOW, TEXT_DELAY_MED
	ret

Options_BattleScene:
	ld hl, wOptions
	ldh a, [hJoyPressed]
	bit D_LEFT_F, a
	jr nz, .LeftPressed
	bit D_RIGHT_F, a
	jr z, .NonePressed
	bit BATTLE_SCENE, [hl]
	jr nz, .ToggleOn
	jr .ToggleOff

.LeftPressed:
	bit BATTLE_SCENE, [hl]
	jr z, .ToggleOff
	jr .ToggleOn

.NonePressed:
	bit BATTLE_SCENE, [hl]
	jr nz, .ToggleOff

.ToggleOn:
	res BATTLE_SCENE, [hl]
	ld de, .On
	jr .Display

.ToggleOff:
	set BATTLE_SCENE, [hl]
	ld de, .Off

.Display:
	hlcoord 11, 5
	rst PlaceString
	and a
	ret

.On:  db "ON @"
.Off: db "OFF@"

Options_Followers:
	ld hl, wFollowers
	ldh a, [hJoyPressed]
	bit D_LEFT_F, a
	jr nz, .LeftPressed
	bit D_RIGHT_F, a
	jr z, .NonePressed
	bit FOLLOWERS_ENABLED, [hl]
	jr nz, .ToggleOff
	jr .ToggleOn

.LeftPressed:
	bit FOLLOWERS_ENABLED, [hl]
	jr z, .ToggleOn
	jr .ToggleOff

.NonePressed:
	bit FOLLOWERS_ENABLED, [hl]
	jr nz, .ToggleOn

.ToggleOff:
	res FOLLOWERS_ENABLED, [hl]
	ld de, .Off
	ld bc, wObject1Struct
	call DoesObjectHaveASprite
	jr z, .Display
	ld hl, OBJECT_FLAGS1
	add hl, bc
	set INVISIBLE_F, [hl]
	ld hl, wFollowerFlags
	set FOLLOWER_INVISIBLE_F, [hl]
	jr .Display

.ToggleOn:
	set FOLLOWERS_ENABLED, [hl]
	ld hl, wFollowerFlags
	set FOLLOWER_INVISIBLE_ONE_STEP_F, [hl]
	farcall RefreshFollowingCoords
	ld de, .On

.Display:
	hlcoord 11, 7
	rst PlaceString
	and a
	ret

.On:  db "ON @"
.Off: db "OFF@"

Options_Sound:
	ld hl, wOptions
	ldh a, [hJoyPressed]
	bit D_LEFT_F, a
	jr nz, .LeftPressed
	bit D_RIGHT_F, a
	jr z, .NonePressed
	bit STEREO, [hl]
	jr nz, .SetMono
	jr .SetStereo

.LeftPressed:
	bit STEREO, [hl]
	jr z, .SetStereo
	jr .SetMono

.NonePressed:
	bit STEREO, [hl]
	jr nz, .ToggleStereo
	jr .ToggleMono

.SetMono:
	res STEREO, [hl]
	call RestartMapMusic

.ToggleMono:
	ld de, .Mono
	jr .Display

.SetStereo:
	set STEREO, [hl]
	call RestartMapMusic

.ToggleStereo:
	ld de, .Stereo

.Display:
	hlcoord 11, 9
	rst PlaceString
	and a
	ret

.Mono:   db "MONO  @"
.Stereo: db "STEREO@"


Options_Print:
	ld hl, wOptions
	ldh a, [hJoyPressed]
	bit D_LEFT_F, a
	jr nz, .LeftPressed
	bit D_RIGHT_F, a
	jr z, .NonePressed
	bit STEREO, [hl]
	jr nz, .SetMono
	jr .SetStereo

.LeftPressed:
	bit STEREO, [hl]
	jr z, .SetStereo
	jr .SetMono

.NonePressed:
	bit STEREO, [hl]
	jr nz, .ToggleStereo
	jr .ToggleMono

.SetMono:
.ToggleMono:
	ld de, .Mono
	jr .Display

.SetStereo:
.ToggleStereo:
	ld de, .Stereo

.Display:
	hlcoord 11, 11
	rst PlaceString
	and a
	ret

.Mono:   db "MONO  @"
.Stereo: db "STEREO@"

Options_Frame:
	ld hl, wTextboxFrame
	ldh a, [hJoyPressed]
	bit D_LEFT_F, a
	jr nz, .LeftPressed
	bit D_RIGHT_F, a
	jr nz, .RightPressed
	and a
	ret

.RightPressed:
	ld a, [hl]
	inc a
	jr .Save

.LeftPressed:
	ld a, [hl]
	dec a

.Save:
	maskbits NUM_FRAMES
	ld [hl], a
UpdateFrame:
	ld a, [wTextboxFrame]
	hlcoord 16, 13 ; where on the screen the number is drawn
	add "1"
	ld [hl], a
	call LoadFontsExtra
	and a
	ret

Options_NextPrevious:
	ld hl, wCurOptionsPage
	ldh a, [hJoyPressed]
	and A_BUTTON | D_LEFT | D_RIGHT
	jr z, .NonePressed
	bit 0, [hl]
	jr z, .Page2
;.Page1:
	res 0, [hl]
	ld de, StringOptions1
	jr .Display
.Page2:
	set 0, [hl]
	ld de, StringOptions2
.Display:
	push de
	hlcoord 0, 0
	lb bc, 16, 18
	call Textbox
	pop de
	hlcoord 2, 2
	rst PlaceString
	call OptionsMenu_LoadOptions
	ld a, $6
	ld [wJumptableIndex], a
.NonePressed:
	and a
	ret

Options_Cancel:
	ldh a, [hJoyPressed]
	and A_BUTTON
	jr nz, .Exit
	and a
	ret

.Exit:
	scf
	ret

OptionsControl:
	ld hl, wJumptableIndex
	ldh a, [hJoyLast]
	cp D_DOWN
	jr z, .DownPressed
	cp D_UP
	jr z, .UpPressed
	and a
	ret

.DownPressed:
	ld a, [hl] ; load the cursor position to a
	cp $7 ; maximum number of items in option menu
	jr nz, .Increase
	ld [hl], -1
.Increase:
	inc [hl]
	scf
	ret

.UpPressed:
	ld a, [hl]
	and a
	jr nz, .Decrease
	ld [hl], $8 ; number of option items + 1
.Decrease:
	dec [hl]
	scf
	ret

Options_UpdateCursorPosition:
	hlcoord 1, 1
	ld de, SCREEN_WIDTH
	ld c, SCREEN_HEIGHT - 2
.loop
	ld [hl], " "
	add hl, de
	dec c
	jr nz, .loop
	hlcoord 1, 2
	ld bc, 2 * SCREEN_WIDTH
	ld a, [wJumptableIndex]
	rst AddNTimes
	ld [hl], "▶"
	ret
