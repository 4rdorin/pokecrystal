	object_const_def
	const SAFARIZONERESTHOUSEAREA2_SCIENTIST
	const SAFARIZONERESTHOUSEAREA2_POKEFAN_M
	const SAFARIZONERESTHOUSEAREA2_TWIN

SafariRestHouseArea2_MapScripts:
	def_scene_scripts

	def_callbacks

SafariRestHouseArea2ScientistScript:
	faceplayer
	opentext
	writetext SafariRestHouseArea2ScientistScript_Text
	waitbutton
	closetext
	end

SafariRestHouseArea2PokefanMScript:
	faceplayer
	opentext
	writetext SafariRestHouseArea2PokefanMScript_Text
	waitbutton
	closetext
	end

SafariRestHouseArea2TwinScript:
	faceplayer
	opentext
	writetext SafariRestHouseArea2TwinScript_Text
	waitbutton
	closetext
	end

SafariRestHouseArea2ScientistScript_Text:
	text "I came here to"
	line "study how the wild"
	cont "#MON adapt to"
	cont "their environment."
	done

SafariRestHouseArea2PokefanMScript_Text:
	text "It sure got hotter"
	line "all of a sudden."

	para "Maybe that's why"
	line "the #MON are"
	cont "different in this"
	cont "area…"
	done

SafariRestHouseArea2TwinScript_Text:
	text "I heard that some"
	line "#MON can learn"
	cont "special attacks"
	cont "here!"
	done

SafariRestHouseArea2_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, SAFARI_ZONE_AREA_2, 5
	warp_event  3,  7, SAFARI_ZONE_AREA_2, 5

	def_coord_events

	def_bg_events

	def_object_events
	object_event  1,  3, SPRITE_SCIENTIST, SPRITEMOVEDATA_WALK_UP_DOWN, 2, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, SafariRestHouseArea2ScientistScript, 0
	object_event  5,  5, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SafariRestHouseArea2PokefanMScript, 0
	object_event  6,  5, SPRITE_TWIN, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, SafariRestHouseArea2TwinScript, 0