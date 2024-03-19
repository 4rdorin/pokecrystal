_GigaSage:
; Introduce himself
	ld hl, GigaSageContinueText
	call PrintText
	call YesNoBox
	jr c, .cancel
; Select a Pokemon from your party
	ld hl, GigaSageWhichMonText
	call PrintText
	farcall SelectMonFromParty
	jr c, .cancel
; He can't train an egg...
	ld a, [wCurPartySpecies]
	cp EGG
	jr z, .egg
	ld hl, GigaSageIsGoodText
	call PrintText
	call YesNoBox
	jr c, .cancel
	ld hl, GigaSageLetsBeginText
	call PrintText
	jr .gigaTrain

.gigaTrainingSuccessful
	ld hl, GigaSageFinishedText
	jr .done
.cancel
	ld hl, GigaSageCancelText
	jr .done

.egg
	ld hl, GigaSageEggText

.done
	jmp PrintText

.gigaTrain:
	call EditMonDVs
	ld a, [wDVsChanged]
	and a
	jr z, .cancel
	jr .recalc_stats ;Borrar para max evs
.maxStatExp
	ld a, MON_STAT_EXP
	call GetPartyParamLocation
	ld a, $FF
	ld b, 10
.loop
	ld [hli], a
	dec b
	jr nz, .loop

.recalc_stats
	ld a, MON_SPECIES
	call GetPartyParamLocation
	ld a, [hl]
	ld [wCurSpecies], a
	call GetBaseData
	
	ld a, MON_LEVEL
	call GetPartyParamLocation
	ld a, [hl]
	ld [wCurPartyLevel], a
	
	ld a, MON_MAXHP
	call GetPartyParamLocation
	ld d, h 
	ld e, l	
	ld a, MON_STAT_EXP - 1
	call GetPartyParamLocation
	
	ld b, TRUE
	predef CalcMonStats
	
	ld a, MON_HP
	call GetPartyParamLocation
	ld d, h 
	ld e, l
	
	ld a, MON_MAXHP
	call GetPartyParamLocation
	ld a, [hli]
	ld [de], a 
	inc de 
	ld a, [hl]
	ld [de], a		

	jr .gigaTrainingSuccessful

GigaSageIntroText:
	text "Well met,"
	line "young trainer!"

	para "I have honed my"
	line "skills here on "

	para "Mt. Silver and"
	line "have perfected the"

	para "most sacred of"
	line "training methods."

	para "GIGA TRAINING!"

	para "For the low, low"
	line "price of ¥200,000"

	para "you too can make"
	line "one of your"

	para "#MON the "
	line "best they can be!"
	prompt
	db "@"

GigaSageContinueText:
	text "Trainer!"
	line "Are you ready to"

	cont "start training?"
	done
	db "@"

GigaSageWhichMonText:
	text "Which #MON"
	line "needs training?"
	prompt
	db "@"

GigaSageIsGoodText:
	text "Is this the"
	line "#MON?"
	done
	db "@"

GigaSageLetsBeginText:
	text "Then let us begin!"
	prompt
	db "@"

GigaSageFinishedText:
	text "There, the full"
	line "potential of your"

	para "#MON has been"
	line "unlocked!"

	para "..."
	line "And we thank you"

	para "for your generous"
	line "contribution."
	done
	db "@"

GigaSageCancelText:
	text "Trainer! I"
	line "shall be waiting!"
	done
	db "@"

GigaSageEggText:
	; Whoa… That's just an EGG.
	text "An EGG cannot"
	line "receive training!"
	done
	db "@"
