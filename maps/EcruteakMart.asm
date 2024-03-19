	object_const_def
	const ECRUTEAKMART_CLERK1
	const ECRUTEAKMART_CLERK2
	const ECRUTEAKMART_SUPER_NERD
	const ECRUTEAKMART_GRANNY

EcruteakMart_MapScripts:
	def_scene_scripts

	def_callbacks

EcruteakMartClerk1Script:
	opentext
	pokemart MARTTYPE_STANDARD, MART_ECRUTEAK
	closetext
	end

EcruteakMartClerk2Script:
	faceplayer
	opentext
	farwritetext AskTeachAMoveText
	yesorno
	iffalse .Refused
	farwritetext TutorWhichMoveShouldITeachText
	loadmenu .MoveMenuHeader
	verticalmenu
	closewindow
	ifequal 1, .Substitute
	ifequal 2, .SeismicToss
	sjump .Refused

.Substitute:
	setval SUBSTITUTE
	farwritetext TutorMoveText
	special MoveTutor
	ifequal FALSE, .TeachMove
	sjump .Incompatible

.SeismicToss:
	setval SEISMIC_TOSS
	farwritetext TutorMoveText
	special MoveTutor
	ifequal FALSE, .TeachMove
	sjump .Incompatible

.Refused:
	farwritetext TutorAwwButTheyreAmazingText
	waitbutton
	closetext
	end

.Incompatible:
	farwritetext TutorAwwButTheyreAmazingText
	waitbutton
	closetext
	end

.TeachMove:
	farwritetext TutorIfYouUnderstandYouveMadeItText
	promptbutton
	farwritetext TutorFarewellKidText
	waitbutton
	closetext
	end

.MoveMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 1, 15, TEXTBOX_Y
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR ; flags
	db 3 ; items
	db "SUBSTITUTE@"
	db "SEISMIC TOSS@"
	db "CANCEL@"

EcruteakMartSuperNerdScript:
	jumptextfaceplayer EcruteakMartSuperNerdText

EcruteakMartGrannyScript:
	jumptextfaceplayer EcruteakMartGrannyText

EcruteakMartSuperNerdText:
	text "My EEVEE evolved"
	line "into an ESPEON."

	para "But my friend's"
	line "EEVEE turned into"
	cont "an UMBREON."

	para "I wonder why? We"
	line "both were raising"

	para "our EEVEE in the"
	line "same way…"
	done

EcruteakMartGrannyText:
	text "If you use REVIVE,"
	line "a #MON that's"

	para "fainted will wake"
	line "right up."
	done

EcruteakMart_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, ECRUTEAK_CITY, 9
	warp_event  3,  7, ECRUTEAK_CITY, 9

	def_coord_events

	def_bg_events

	def_object_events
	object_event  1,  3, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, EcruteakMartClerk1Script, -1
	object_event  1,  2, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, EcruteakMartClerk2Script, -1
	object_event  5,  2, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, EcruteakMartSuperNerdScript, -1
	object_event  6,  6, SPRITE_GRANNY, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, EcruteakMartGrannyScript, -1
