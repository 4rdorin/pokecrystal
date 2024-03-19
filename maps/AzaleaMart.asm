	object_const_def
	const AZALEAMART_CLERK1
	const AZALEAMART_CLERK2
	const AZALEAMART_COOLTRAINER_M
	const AZALEAMART_BUG_CATCHER

AzaleaMart_MapScripts:
	def_scene_scripts

	def_callbacks

AzaleaMartClerk1Script:
	opentext
	pokemart MARTTYPE_STANDARD, MART_AZALEA
	closetext
	end

AzaleaMartClerk2Script:
	faceplayer
	opentext
	farwritetext AskTeachAMoveText
	yesorno
	iffalse .Refused
	farwritetext TutorWhichMoveShouldITeachText
	loadmenu .MoveMenuHeader
	verticalmenu
	closewindow
	ifequal 1, .Bubblebeam
	ifequal 2, .MegaDrain
	sjump .Refused

.Bubblebeam:
	setval BUBBLEBEAM
	farwritetext TutorMoveText
	special MoveTutor
	ifequal FALSE, .TeachMove
	sjump .Incompatible

.MegaDrain:
	setval MEGA_DRAIN
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
	db "BUBBLE BEAM@"
	db "MEGA DRAIN@"
	db "CANCEL@"

AzaleaMartCooltrainerMScript:
	jumptextfaceplayer AzaleaMartCooltrainerMText

AzaleaMartBugCatcherScript:
	jumptextfaceplayer AzaleaMartBugCatcherText

AzaleaMartCooltrainerMText:
	text "There's no GREAT"
	line "BALL here. #"

	para "BALLS will have"
	line "to do."

	para "I wish KURT would"
	line "make me some of"
	cont "his custom BALLS."
	done

AzaleaMartBugCatcherText:
	text "A GREAT BALL is"
	line "better for catch-"
	cont "ing #MON than a"
	cont "# BALL."

	para "But KURT's might"
	line "be better some-"
	cont "times."
	done

AzaleaMart_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, AZALEA_TOWN, 3
	warp_event  3,  7, AZALEA_TOWN, 3

	def_coord_events

	def_bg_events

	def_object_events
	object_event  1,  3, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, AzaleaMartClerk1Script, -1
	object_event  1,  2, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, AzaleaMartClerk2Script, -1
	object_event  2,  5, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, AzaleaMartCooltrainerMScript, -1
	object_event  7,  2, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 2, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, AzaleaMartBugCatcherScript, -1
