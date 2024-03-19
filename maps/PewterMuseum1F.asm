	object_const_def
	const PEWTER_MUSEUM_1F_SCIENTIST_1
	const PEWTER_MUSEUM_1F_SCIENTIST_2
	const PEWTER_MUSEUM_1F_GRAMPS
	const PEWTER_MUSEUM_1F_SUPER_NERD

PewterMuseum1F_MapScripts:
	def_scene_scripts

	def_callbacks

ReceptionScene:
	turnobject PLAYER, RIGHT
	end

PewterMuseum1F_Reception_Scientist_Script:
	faceplayer
	opentext
	writetext PewterMuseum1F_Scientist_ReceptionText
	waitbutton
	closetext
	end

.NotEnoughMoney:
	writetext PewterMuseum1F_Scientist_NotEnoughMoneyText
	waitbutton
	closetext
	applymovement PLAYER, MovementData_Player_Walks_Museum_Entrance
	end

.Refused:
	writetext PewterMuseum1F_Scientist_ComeAgainText
	waitbutton
	closetext
	turnobject PEWTER_MUSEUM_1F_SCIENTIST_1, LEFT
	applymovement PLAYER, MovementData_Player_Walks_Museum_Entrance
	end

.DontSneakIn:
	writetext PewterMuseum1F_Scientist_ReceptionBackWayText
	waitbutton
	closetext
	turnobject PEWTER_MUSEUM_1F_SCIENTIST_1, LEFT
	end

PewterMuseum1F_Fossil_Scientist_Script:
	faceplayer
	opentext
	writetext PewterMuseum1F_Scientist_PrideAndJoyText
	waitbutton
	closetext
	end

PewterMuseum1F_Gramps_Script:
	faceplayer
	opentext
	writetext PewterMuseum1F_Gramps_Text
	waitbutton
	closetext
	turnobject PEWTER_MUSEUM_1F_GRAMPS, UP
	end

PewterMuseum1F_SuperNerd_Script:
	faceplayer
	opentext
	writetext PewterMuseum1F_SuperNerd_Text
	waitbutton
	closetext
	end

PewterMuseum1FKabutopsFossilDisplay:
	reanchormap
	;trainerpic KABUTOPS_FOSSIL
	waitbutton
	closepokepic
	opentext
	writetext KabutopsFossilDisplayText
	waitbutton
	closetext
	end

PewterMuseum1FAerodactylFossilDisplay:
	reanchormap
	;trainerpic AERODACTYL_FOSSIL
	waitbutton
	closepokepic
	opentext
	writetext AerodactylFossilDisplayText
	waitbutton
	closetext
	end

PewterMuseum1F_Scientist_ReceptionBackWayText:
	text "Hey!"

	para "You can't sneak in"
	line "through the back!"

	para "Well, not that it"
	line "matters…"

	para "You can't view the"
	line "exhibits from here"
	cont "anyway."
	done

PewterMuseum1F_Scientist_PrideAndJoyText:
	text "We managed to find"
	line "two fossils of"

	para "very rare, extinct"
	line "#MON!"

	para "They are the pride"
	line "and joy of the"
	cont "MUSEUM!"
	done

PewterMuseum1F_Scientist_TakeTheAmberCheckedText:
	text "Ssh! I have a"
	line "secret to share."

	para "I found this chunk"
	line "of AMBER, and I"

	para "believe it may"
	line "contain #MON"
	cont "DNA!"

	para "My colleagues say"
	line "it's all nonsense!"

	para "So, I would like"
	line "to ask a favor."

	para "Could you get this"
	line "AMBER examined?"

	para "I hear there is a"
	line "good team of re-"
	cont "searchers at the"
	cont "RUINS OF ALPH who"
	cont "can help!"
	done

PewterMuseum1F_Scientist_GetTheAmberCheckedText:
	text "Ssh!"
	line "Get the OLD AMBER"
	cont "checked!"
	done

PewterMuseum1F_AmberText:
	text "A beautiful piece"
	line "of AMBER…"

	para "It's clear and"
	line "gold!"
	done

PewterMuseum1F_Scientist_ReceptionText:
	text "Welcome!"
	done

PewterMuseum1F_Scientist_ComeAgainText:
	text "Come again!"
	done

PewterMuseum1F_Scientist_TicketThankYouText:
	text "That's ¥50 then,"
	line "thank you!"
	done

PewterMuseum1F_Scientist_NotEnoughMoneyText:
	text "You don't have"
	line "enough money!"
	done

PewterMuseum1F_Gramps_Text:
	text "My, my, what an"
	line "impressive fossil!"
	done

PewterMuseum1F_SuperNerd_Text:
	text "After being to the"
	line "RUINS OF ALPH,"

	para "this MUSEUM is the"
	line "best place to"
	cont "visit!"

	para "So much history…"
	done

KabutopsFossilDisplayText:
	text "KABUTOPS FOSSIL"

	para "A primitive and"
	line "rare #MON."
	done

AerodactylFossilDisplayText:
	text "AERODACTYL FOSSIL"

	para "A primitive and"
	line "rare #MON."
	done

MovementData_Player_Walks_Museum_Entrance:
	step DOWN
	step_end

PewterMuseum1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 10,  7, PEWTER_CITY, 6
	warp_event 11,  7, PEWTER_CITY, 6
	warp_event 16,  7, PEWTER_CITY, 7
	warp_event 17,  7, PEWTER_CITY, 7
	warp_event  7,  7, PEWTER_MUSEUM_2F, 1

	def_coord_events

	def_bg_events
	bg_event  3,  6, BGEVENT_READ, PewterMuseum1FKabutopsFossilDisplay
	bg_event  3,  3, BGEVENT_READ, PewterMuseum1FAerodactylFossilDisplay

	def_object_events
	object_event 12,  4, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_LEFT, 2, 2, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, PewterMuseum1F_Reception_Scientist_Script, -1
	object_event 17,  4, SPRITE_SCIENTIST, SPRITEMOVEDATA_SPINRANDOM_SLOW, 2, 2, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, PewterMuseum1F_Fossil_Scientist_Script, -1
	object_event  2,  4, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_UP, 2, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, PewterMuseum1F_Gramps_Script, -1
	object_event  8,  2, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 2, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, PewterMuseum1F_SuperNerd_Script, -1
