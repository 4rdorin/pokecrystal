Trader::
	ld hl, TraderText
	call PrintText
	call YesNoBox
	ld hl, TraderCanceledText
	jr c, .done

	; Select givemon from party
	ld b, PARTYMENUACTION_GIVE_MON
	farcall SelectTradeOrDayCareMon
	ld a, [wCurPartyMon]
	ld hl, TraderCanceledText
	jr c, .done

	ld hl, NPCTradeCableText
	call PrintText

	call TradeWithTrader
	call RestartMapMusic

	ld hl, TraderCompleteText
	jmp PrintText
.done
	jmp PrintText
;Loads the appropriate data to prefor the trade animation,

TradeWithTrader:
;Sets the link state to trading so that evolution is possible.
	ld a, LINK_TRADECENTER
	ld [wLinkMode], a

;Makes it so that pressing B will not cancel the evolution, standard for trade based evolution
	ld a, 1
	ld [wForceEvolution], a

;Evolves the mon if applicable
	call DisableSpriteUpdates
	farcall EvolvePokemon
	call ReturnToMapWithSpeechTextbox

;Put's the link mode back to not linked, battles don't work right otherwise.
	ld a, LINK_NULL
	ld [wLinkMode], a
	ret

TraderText::
	text "Hello there! I'm"
	line "trying to complete"
	cont "my Pokedex."

	para "Would you help me"
	line "by showing me one"
	line "one of your #MON?"

	para "I can trade a"
	line "#MON of your"
	cont "choosing back to"
	cont "you."
	done

TraderCanceledText::
	text "Oh, ok then."

	para "Come back if you"
	line "change your mind."
	done

TraderCompleteText::
	text "Thank you!"
	done
