	object_const_def
	const SEAFOAMISLANDS1F_BOULDER1
	const SEAFOAMISLANDS1F_BOULDER2

SeafoamIslands1F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_STONETABLE, .SetUpStoneTable

.SetUpStoneTable:
	usestonetable .StoneTable ; check if any stones are sitting on a warp
	endcallback

.StoneTable:
	stonetable 6, SEAFOAMISLANDS1F_BOULDER1+1, .Boulder1
	stonetable 7, SEAFOAMISLANDS1F_BOULDER2+1, .Boulder2
	db -1 ; end

.Boulder1:
	disappear SEAFOAMISLANDS1F_BOULDER1
	clearevent EVENT_BOULDER_IN_SEAFOAM_B1F_1
	sjump .Fall

.Boulder2:
	disappear SEAFOAMISLANDS1F_BOULDER2
	clearevent EVENT_BOULDER_IN_SEAFOAM_B1F_2
	sjump .Fall

.Fall:
	pause 30
	scall .FX
	opentext
	writetext SeafoamIslands1FBoulderFellText
	waitbutton
	closetext
	end

.FX:
	playsound SFX_STRENGTH
	earthquake 80
	end

SeafoamIslands1FBoulder:
	jumpstd StrengthBoulderScript

SeafoamIslands1FBoulderFellText:
	text "The boulder fell"
	line "through!"
	done

SeafoamIslands1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  5,  9, SEAFOAM_ISLANDS, 4
	warp_event 25, 15, SEAFOAM_ISLANDS, 5
	warp_event 23, 15, SEAFOAM_ISLANDS_B1F, 1
	warp_event  7,  5, SEAFOAM_ISLANDS_B1F, 2
	warp_event 25,  3, SEAFOAM_ISLANDS_B1F, 3
	warp_event 17,  6, SEAFOAM_ISLANDS_B1F, 8 ; hole
	warp_event 24,  6, SEAFOAM_ISLANDS_B1F, 9 ; hole

	def_coord_events

	def_bg_events

	def_object_events
	object_event 18, 10, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslands1FBoulder, EVENT_BOULDER_IN_SEAFOAM_1F_1
	object_event 26,  7, SPRITE_BOULDER, SPRITEMOVEDATA_STRENGTH_BOULDER, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, SeafoamIslands1FBoulder, EVENT_BOULDER_IN_SEAFOAM_1F_2
