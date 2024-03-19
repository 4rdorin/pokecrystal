GoldenrodHarborGate_MapScripts:
	def_scene_scripts

	def_callbacks

GoldenrodHarborGate_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  0,  4, GOLDENROD_HARBOR, 1
	warp_event  0,  5, GOLDENROD_HARBOR, 2
	warp_event  9,  4, GOLDENROD_CITY, 16
	warp_event  9,  5, GOLDENROD_CITY, 17

	def_coord_events

	def_bg_events

	def_object_events
