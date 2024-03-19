	object_const_def
	const SAFARIZONEENTRANCE_OFFICER
	const SAFARIZONEENTRANCE_OFFICER2
	const SAFARIZONEENTRANCE_GENTLEMAN

SafariZoneEntrance_MapScripts:
	def_scene_scripts

	def_callbacks

SafariZoneEntranceMainOfficerScript:
	faceplayer
	opentext
	writetext SafariZoneEntranceMainOfficer_Text
	waitbutton
	closetext
	end

SafariZoneEntranceOfficerScript:
	faceplayer
	opentext
	writetext SafariZoneEntranceOfficer_Text
	yesorno
	iffalse SafariZoneEntranceOfficer_NotFirstTime
	writetext SafariZoneEntranceOfficer_Text3
	waitbutton
	closetext
	turnobject SAFARIZONEENTRANCE_OFFICER, RIGHT
	end

SafariZoneEntranceOfficer_NotFirstTime:
	writetext SafariZoneEntranceOfficer_Text2
	waitbutton
	closetext
	end

SafariZoneEntranceBaoboScript:
	faceplayer
	opentext
	writetext SafariZoneEntranceBaobo_Text
	waitbutton
	closetext
	end

SafariZoneEntranceMainOfficer_Text:
	text "Welcome to the"
	line "SAFARI ZONE!"

	para "The entrance is"
	line "free."

	para "You can catch all"
	line "the #MON you"
	cont "want in the park."

	para "Have fun!"
	done

SafariZoneEntranceOfficer_Text:
	text "Hi! Is it your"
	line "first time here at"
	cont "the SAFARI ZONE?"
	done

SafariZoneEntranceOfficer_Text2:
	text "Have fun at the"
	line "SAFARI ZONE!"
	done

SafariZoneEntranceOfficer_Text3:
	text "SAFARI ZONE has 4"
	line "areas for you to"
	cont "explore."

	para "Each area has"
	line "different kinds"
	cont "of #MON."

	para "Use your POKE"
	line "BALLS to catch"
	cont "whatever #MON"
	cont "you want!"
	done

SafariZoneEntranceBaobo_Text:
	text "Hello! Welcome!"

	para "We have started"
	line "the project of a"
	cont "new free Safari"
	cont "Zone in Johto"
	cont "with volunteers."

	para "I hope you catch"
	line "many rare #MON"
	done

SafariZoneEntrance_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3,  0, SAFARI_ZONE_AREA_1, 1
	warp_event  2,  9, SAFARI_ZONE_GATE, 1
	warp_event  3,  9, SAFARI_ZONE_GATE, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  0,  6, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SafariZoneEntranceOfficerScript, -1
	object_event  2,  1, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, SafariZoneEntranceMainOfficerScript, -1
	object_event  8,  6, SPRITE_GENTLEMAN, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, SafariZoneEntranceBaoboScript, 0
