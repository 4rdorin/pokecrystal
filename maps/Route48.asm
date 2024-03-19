	object_const_def

Route48_MapScripts:
	def_scene_scripts

	def_callbacks

Route48Nugget:	;ToDo: Revisar
	itemball NUGGET

Route48Sign:
	jumptext Route48SignText

Route48SignText:
	text "ROUTE 48"
	line "SAFARI ZONE AHEAD"
	done

Route48_MapEvents:
	db 0, 0 ; filler

	def_warp_events

	def_coord_events

	def_bg_events
	bg_event 27,  9, BGEVENT_READ, Route48Sign

	def_object_events
