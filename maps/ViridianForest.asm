	object_const_def
	const VIRIDIAN_FOREST_POKE_BALL1
	const VIRIDIAN_FOREST_POKE_BALL2
	const VIRIDIAN_FOREST_POKE_BALL3

ViridianForest_MapScripts:
	def_scene_scripts

	def_callbacks

ViridianForestHiddenMaxEther:
	hiddenitem MAX_ETHER, EVENT_ROUTE_2_HIDDEN_MAX_ETHER

ViridianForestHiddenFullHeal:
	hiddenitem FULL_HEAL, EVENT_ROUTE_2_HIDDEN_FULL_HEAL

ViridianForestHiddenFullRestore:
	hiddenitem FULL_RESTORE, EVENT_ROUTE_2_HIDDEN_FULL_RESTORE

ViridianForestMaxPotion:
	itemball MAX_POTION

ViridianForestLeafStone:
	itemball LEAF_STONE

ViridianForestMaxEther:
	itemball MAX_ETHER

ViridianForestHiddenRevive:
	hiddenitem REVIVE, EVENT_ROUTE_2_HIDDEN_REVIVE

ViridianForest_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  1,  3, VIRIDIAN_FOREST_GATE_N, 3
	warp_event 16, 51, VIRIDIAN_FOREST_GATE_S, 1
	warp_event 17, 51, VIRIDIAN_FOREST_GATE_S, 2

	def_coord_events

	def_bg_events
	bg_event 17, 22, BGEVENT_ITEM, ViridianForestHiddenMaxEther
	bg_event 13,  6, BGEVENT_ITEM, ViridianForestHiddenFullHeal
	bg_event 10, 38, BGEVENT_ITEM, ViridianForestHiddenFullRestore
	bg_event 31, 46, BGEVENT_ITEM, ViridianForestHiddenRevive

	def_object_events
	object_event 11, 32, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, ViridianForestMaxPotion, EVENT_VIRIDIAN_FOREST_MAX_POTION
	object_event 25, 17, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, ViridianForestMaxEther, EVENT_VIRIDIAN_FOREST_MAX_ETHER
	object_event  2, 34, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, ViridianForestLeafStone, EVENT_VIRIDIAN_FOREST_LEAF_STONE
