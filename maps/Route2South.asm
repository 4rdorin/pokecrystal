	object_const_def
	const ROUTE2S_POKE_BALL1
	const ROUTE2S_POKE_BALL2

Route2South_MapScripts:
	def_scene_scripts

	def_callbacks

Route2Sign:
	giveitem TM_HEADBUTT
	jumptext Route2SignText

Route2DireHit:
	itemball DIRE_HIT

Route2Elixer:
	itemball ELIXER

BugCatcherRobSeenText:
	text "My bug #MON are"
	line "tough. Prepare to"
	cont "lose!"
	done

BugCatcherRobBeatenText:
	text "I was whipped…"
	done

BugCatcherRobAfterBattleText:
	text "I'm going to look"
	line "for stronger bug"
	cont "#MON."
	done

BugCatcherDougSeenText:
	text "Why don't girls"
	line "like bug #MON?"
	done

BugCatcherDougBeatenText:
	text "No good!"
	done

BugCatcherDougAfterBattleText:
	text "Bug #MON squish"
	line "like plush toys"

	para "when you squeeze"
	line "their bellies."

	para "I love how they"
	line "feel!"
	done

Route2SignText:
	text "ROUTE 2"

	para "VIRIDIAN CITY -"
	line "PEWTER CITY"
	done

Route2South_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 17,  1, ROUTE_2_GATE, 3
	warp_event  5,  5, VIRIDIAN_FOREST_GATE_S, 3

	def_coord_events

	def_bg_events
	bg_event  7, 27, BGEVENT_READ, Route2Sign

	def_object_events
	object_event 15,  7, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route2DireHit, EVENT_ROUTE_2_DIRE_HIT
	object_event 15, 16, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route2Elixer, EVENT_ROUTE_2_ELIXER
