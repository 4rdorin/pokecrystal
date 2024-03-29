PrintStatLabels:
    ld de, .label_HP ; hp
    rst PlaceString

    ld bc, SCREEN_WIDTH
	add hl, bc
    ld de, .label_ATK ; atk
    rst PlaceString

    ld bc, SCREEN_WIDTH
	add hl, bc
    ld de, .label_DEF ; def
    rst PlaceString

    ld bc, SCREEN_WIDTH
	add hl, bc
    ld de, .label_SPE ; spe
    rst PlaceString

    ld bc, SCREEN_WIDTH
	add hl, bc
    ld de, .label_SPC ; spc
    rst PlaceString
	ret

.label_HP
    db "HP    /15@"
.label_ATK
    db "ATK   /15@"
.label_DEF
    db "DEF   /15@"
.label_SPE
    db "SPE   /15@"
.label_SPC
    db "SPC   /15@"
; by Aurelio Mannara - BitBuilt 2017
; ShockSlayer helped ( °v°)
TN_PrintDVs:
	;store DV source
	ld a, d
	ld [wDVSourceAtkDef], a
	ld a, e
	ld [wDVSourceSpdSpc], a
	;store base display coordinates
	ld a, h
	ld [wDVCoordX], a
	ld a, l
	ld [wDVCoodY], a
    ; print labels
	ld a, b
	and a
	jr z, .printingLabelsDone
	inc hl
    ld de, .label_DV ; DV
    rst PlaceString
	call .getBaseCoordinates
	ld bc, SCREEN_WIDTH
	add hl, bc
	call PrintStatLabels

.printingLabelsDone
    ; print 16 bit value of DVs
    call .getDVSource
    ld a, [de]
    ld b, a
    inc de
    ld a, [de]
    ld c, a
    push bc

    call .getDVSource
    xor a
    ld [de], a
    inc de
    pop bc
    ld a, b
    push bc
    and $f0
    swap a
    ld [de], a
	; print atk
	lb bc, 4, 2
	call .getOffsetCoordinates
    lb bc, PRINTNUM_LEADINGZEROS | 2, 2
    call .getDVSource
    call PrintNum

    call .getDVSource
    xor a
    ld [de], a
    inc de
    pop bc
    ld a, b
    push bc
    and $f
    ld [de],a
	; print def
    lb bc, 4, 3
	call .getOffsetCoordinates
    lb bc, PRINTNUM_LEADINGZEROS | 2, 2
    call .getDVSource
    call PrintNum

    call .getDVSource
    xor a
    ld [de], a
    inc de
    pop bc
    ld a, c
    push bc
    and $f0
    swap a
    ld [de], a
	; print speed
    lb bc, 4, 4
	call .getOffsetCoordinates
    lb bc, PRINTNUM_LEADINGZEROS | 2, 2
    call .getDVSource
    call PrintNum

    call .getDVSource
    xor a
    ld [de], a
    inc de
    pop bc
    ld a, c
    push bc
    and $f
    ld [de], a
	; print special
    lb bc, 4, 5
	call .getOffsetCoordinates
    lb bc, PRINTNUM_LEADINGZEROS | 2, 2
    call .getDVSource
    call PrintNum

    call .getDVSource
    xor a
    ld [de], a
    inc de
    pop bc
    bit 4, b
    jr z, .noAttackHP
    set 3, a
.noAttackHP
    bit 0, b
    jr z, .noDefenseHP
    set 2, a
.noDefenseHP
    bit 4, c
    jr z, .noSpeedHP
    set 1, a
.noSpeedHP
    bit 0, c
    jr z, .noSpecialHP
    set 0, a
.noSpecialHP
    push bc
    ld [de], a
	; print hp
    lb bc, 4, 1
	call .getOffsetCoordinates
    lb bc, PRINTNUM_LEADINGZEROS | 2, 2
    call .getDVSource
    call PrintNum

    call .getDVSource
    pop bc
    ld a, b
    ld [de], a
    inc de
    ld a, c
    ld [de], a
	ret

.label_DV
    db "DVs:@"

.getDVSource
	push af
	ld a, [wDVSourceAtkDef]
	ld d, a
	ld a, [wDVSourceSpdSpc]
	ld e, a
	pop af
	ret

.getBaseCoordinates
	push af
	ld a, [wDVCoordX]
	ld h, a
	ld a, [wDVCoodY]
	ld l, a
	pop af
	ret

.getOffsetCoordinates
	call .getBaseCoordinates
	ld a, b
.xLoop
	inc hl
	dec a
	jr nz, .xLoop
	ld a, c
	ld bc, SCREEN_WIDTH
.yLoop
	add hl, bc
	dec a
	jr nz, .yLoop
	ret

printStatExp:
	hlcoord 0, 12
    ld de, .label_statExp
    rst PlaceString
	hlcoord 0, 13
	call PrintStatLabels

	lb bc, PRINTNUM_LEADINGZEROS | 2, 5
	hlcoord 4, 13 ; hp disp coords
    ld de, wTempMonHPExp
	call .printStatExpVal

	hlcoord 4, 14 ; atk disp coords
    ld de, wTempMonAtkExp
    call .printStatExpVal

	hlcoord 4, 15 ; def disp coords
    ld de, wTempMonDefExp
    call .printStatExpVal

	hlcoord 4, 16 ; spc disp coords
    ld de, wTempMonSpcExp
    call .printStatExpVal

	hlcoord 4, 17 ; spd disp coords
    ld de, wTempMonSpdExp
    jr .printStatExpVal

.printStatExpVal:
	ld a, [de]
	cp $FF
	jr nz, .printAsNum
	inc de
	ld a, [de]
	dec de
	cp $FF
	jr nz, .printAsNum
.printAsMax
	ld de, .label_MAX
	push bc ; keep the print num settings in bc
    rst PlaceString
	pop bc
	jr .done
.printAsNum
    call PrintNum
.done
	ret

.label_statExp
	db "StatExp:@"

.label_MAX
	db "-MAX-@"

EditMonDVs:
	call ClearSprites
	call WriteDvEditMenuTilemap
	call WaitBGMap
	call SetDefaultBGPAndOBP
	hlcoord 4, 2
	lb bc, 7, 10
	call Textbox
	hlcoord 0, 0
	lb bc, SCREEN_HEIGHT, SCREEN_WIDTH
	call TextboxPalette
	call DelayFrame
	call DVEditMenu
	ld [wDVsChanged], a
	and a
	jr z, .playerCancel
	ld a, MON_DVS
	call GetPartyParamLocation
	ld a, [wAtkDefDVs]
	ld [hli], a
	ld a, [wSpdSpcDVs]
	ld [hl], a
.playerCancel
	jmp ReturnToMapWithSpeechTextbox

WriteDvEditMenuTilemap:
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, " "
	rst ByteFill ; blank the tilemap
	ret

DVEditMenu:
	xor a
	ld [wDVEditMenu], a
	ld hl, ChooseYourTraining
	call PrintText
	hlcoord 6, 9
    ld de, .label_OK ; def
    rst PlaceString
	ld a, MON_DVS
	call GetPartyParamLocation
	ld a, [hli]
	ld [wAtkDefDVs], a
	ld a, [hl]
	ld [wSpdSpcDVs], a

	ld de, wAtkDefDVs
	hlcoord 6, 3
	ld b, 1
	call TN_PrintDVs
	jr .loopRedraw

.loopRedrawAll:
	ld de, wAtkDefDVs
	hlcoord 6, 3
	ld b, 0
	call TN_PrintDVs
.loopRedraw:
	call DelayFrame
	ld de, .cursorPositions
	ld a, [wDVEditMenu]
	ld b, a
	ld c, 0
.cursorLoop:
	hlcoord 0, 0
	push bc
	inc de
	ld a, [de]
	ld h, a
	dec de
	ld a, [de]
	ld l, a
	inc de
	inc de
	ld bc, wTilemap
	add hl, bc
	pop bc
	ld a, c
	cp b
	jr z, .drawCursor
	ld [hl], " "
	jr .endLoop
.drawCursor
	ld [hl], $ed
.endLoop
	inc c
	cp 4
	jr nz, .cursorLoop

.loop:
	call GetJoypad
	ld a, [hJoyPressed]
	bit D_DOWN_F, a
	jr nz, .d_down
	bit D_UP_F, a
	jr nz, .d_up
	bit D_LEFT_F, a
	jr nz, .d_left
	bit D_RIGHT_F, a
	jr nz, .d_right
	bit A_BUTTON_F, a
	jr nz, .a_btn
	bit B_BUTTON_F, a
	jr nz, .b_btn
	jr .done
.d_down
	ld a, [wDVEditMenu]
	cp 4
	jr z, .to_top
	inc a
	jr .d_down_done
.to_top
	xor a
.d_down_done
	ld [wDVEditMenu], a
	jr .loopRedraw
.d_up
	ld a, [wDVEditMenu]
	and a
	jr z, .to_bottom
	dec a
	jr .d_up_done
.to_bottom
	ld a, 4
.d_up_done
	ld [wDVEditMenu], a
	jr .loopRedraw
.a_btn
	ld a, [wDVEditMenu]
	ld hl, .aPressFunctions
	call JumpTable
	and a
	jr z, .done
	jr .finishedEditing
.b_btn
	ld hl, WantToCancel
	call PrintText
	call YesNoBox
	ld a, 0 ; need to keep carry here
	jr nc, .finishedEditing
	jr .done
.d_left
	ld a, [wDVEditMenu]
	ld hl, .leftPressFunctions
	call JumpTable
	jmp .loopRedrawAll
.d_right
	ld a, [wDVEditMenu]
	ld hl, .rightPressFunctions
	call JumpTable
	jmp .loopRedrawAll
.done
	jr .loop

.finishedEditing
	ret

.label_OK:
	db "OK@"

.stub
	xor a
	ret

.aPressFunctions:
	dw .selectionOK
	dw .selectionOK
	dw .selectionOK
	dw .selectionOK
	dw .selectionOK

.selectionOK:
	ld hl, TrainingSelected
	call PrintText
	call YesNoBox
	ld a, 1
	jr nc, .playerOK
	ld hl, ChooseYourTraining
	call PrintText
	xor a
.playerOK
	ret

.leftPressFunctions:
	dw .leftAtk
	dw .leftDef
	dw .leftSpd
	dw .leftSpc
	dw .stub

.leftAtk:
	ld a, [wAtkDefDVs]
	ld c, a
	and $f0
    swap a
	and a
	jr z, .leftAtkOverflow
	dec a
	jr .leftAtkDone
.leftAtkOverflow
	ld a, 15
.leftAtkDone
	swap a
	ld b, a
	ld a, c
	and $0f
	or b
	ld [wAtkDefDVs], a
	ret

.leftDef:
	ld a, [wAtkDefDVs]
	ld c, a
	and $0f
	and a
	jr z, .leftDefOverflow
	dec a
	jr .leftDefDone
.leftDefOverflow
	ld a, 15
.leftDefDone
	ld b, a
	ld a, c
	and $f0
	or b
	ld [wAtkDefDVs], a
	ret

.leftSpd:
	ld a, [wSpdSpcDVs]
	ld c, a
	and $f0
    swap a
	and a
	jr z, .leftSpdOverflow
	dec a
	jr .leftSpdDone
.leftSpdOverflow
	ld a, 15
.leftSpdDone
	swap a
	ld b, a
	ld a, c
	and $0f
	or b
	ld [wSpdSpcDVs], a
	ret

.leftSpc:
	ld a, [wSpdSpcDVs]
	ld c, a
	and $0f
	and a
	jr z, .leftSpcOverflow
	dec a
	jr .leftSpcDone
.leftSpcOverflow
	ld a, 15
.leftSpcDone
	ld b, a
	ld a, c
	and $f0
	or b
	ld [wSpdSpcDVs], a
	ret


.rightPressFunctions:
	dw .rightAtk
	dw .rightDef
	dw .rightSpd
	dw .rightSpc
	dw .stub

.rightAtk:
	ld a, [wAtkDefDVs]
	ld c, a
	and $f0
    swap a
	cp 15
	jr z, .rightAtkOverflow
	inc a
	jr .rightAtkDone
.rightAtkOverflow
	ld a, 0
.rightAtkDone
	swap a
	ld b, a
	ld a, c
	and $0f
	or b
	ld [wAtkDefDVs], a
	ret

.rightDef:
	ld a, [wAtkDefDVs]
	ld c, a
	and $0f
	cp 15
	jr z, .rightDefOverflow
	inc a
	jr .rightDefDone
.rightDefOverflow
	ld a, 0
.rightDefDone
	ld b, a
	ld a, c
	and $f0
	or b
	ld [wAtkDefDVs], a
	ret

.rightSpd:
	ld a, [wSpdSpcDVs]
	ld c, a
	and $f0
    swap a
	cp 15
	jr z, .rightSpdOverflow
	inc a
	jr .rightSpdDone
.rightSpdOverflow
	ld a, 0
.rightSpdDone
	swap a
	ld b, a
	ld a, c
	and $0f
	or b
	ld [wSpdSpcDVs], a
	ret

.rightSpc:
	ld a, [wSpdSpcDVs]
	ld c, a
	and $0f
	cp 15
	jr z, .rightSpcOverflow
	inc a
	jr .rightSpcDone
.rightSpcOverflow
	ld a, 0
.rightSpcDone
	ld b, a
	ld a, c
	and $f0
	or b
	ld [wSpdSpcDVs], a
	ret

.cursorPositions:
	dw 5 * SCREEN_WIDTH + 5
	dw 6 * SCREEN_WIDTH + 5
	dw 7 * SCREEN_WIDTH + 5
	dw 8 * SCREEN_WIDTH + 5
	dw 9 * SCREEN_WIDTH + 5

ChooseYourTraining:
	text "Decide how to"
	line "train, trainer!"
	done
	db "@"

TrainingSelected:
	text "Is this to your"
	line "liking, trainer?"
	done
	db "@"

WantToCancel:
	text "Have you changed"
	line "you mind, trainer?"
	done
	db "@"
