	object_const_def

Route47_MapScripts:
	def_scene_scripts

	def_callbacks

Route47Revive:
	itemball REVIVE

Route47MysticWater:
	itemball MYSTIC_WATER

Route47SilverPowder:
	itemball SILVERPOWDER

Route47MaxRepel:
	itemball MAX_REPEL

Route47HiddenPearl:
	hiddenitem PEARL, EVENT_ROUTE_47_HIDDEN_PEARL

Route47HiddenStardust:
	hiddenitem STARDUST, EVENT_ROUTE_47_HIDDEN_STARDUST

Route47_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 67, 21, CLIFF_EDGE_GATE, 2
	warp_event 52, 17, CLIFF_CAVE, 1
	warp_event 53, 21, CLIFF_CAVE, 2
	warp_event 53, 29, CLIFF_CAVE, 3

	def_coord_events

	def_bg_events
	bg_event 33, 34, BGEVENT_ITEM, Route47HiddenPearl
	bg_event 28, 12, BGEVENT_ITEM, Route47HiddenStardust

	def_object_events
	;object_event 59, 26, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 4, GenericTrainerHikerDevin, -1
	;object_event 40, 22, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 3, GenericTrainerCamperGrant, -1
	;object_event 53, 19, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_LEFT,  0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 1,GenericTrainerCoolDuoThomandkae1, -1
	;object_event 53, 18, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_LEFT,  0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_TRAINER, 1,GenericTrainerCoolDuoThomandkae2, -1
	;object_event 27,  7, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 1, GenericTrainerCoupleDuffandeda1, -1
	;object_event 28,  7, SPRITE_LASS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 1, GenericTrainerCoupleDuffandeda2, -1
	;object_event 39, 28, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route47Revive, EVENT_ROUTE_47_REVIVE
	;object_event 11, 24, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route47MysticWater, EVENT_ROUTE_47_MYSTIC_WATER
	;object_event 31, 20, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route47SilverPowder, EVENT_ROUTE_47_SILVER_POWDER
	;object_event 7, 6, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route47MaxRepel, EVENT_ROUTE_47_MAX_REPEL
