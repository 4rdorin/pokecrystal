	object_const_def
	const VIOLETMART_CLERK1
	const VIOLETMART_CLERK2
	const VIOLETMART_GRANNY
	const VIOLETMART_COOLTRAINER_M

VioletMart_MapScripts:
	def_scene_scripts

	def_callbacks

VioletMartClerk1Script:
	opentext
	pokemart MARTTYPE_STANDARD, MART_VIOLET
	closetext
	end

VioletMartClerk2Script:
	faceplayer
	opentext
	farwritetext AskTeachAMoveText
	yesorno
	iffalse .Refused
	farwritetext TutorWhichMoveShouldITeachText
	loadmenu .MoveMenuHeader
	verticalmenu
	closewindow
	ifequal 1, .Psywave
	ifequal 2, .Teleport
	sjump .Refused

.Psywave:
	setval PSYWAVE
	farwritetext TutorMoveText
	special MoveTutor
	ifequal FALSE, .TeachMove
	sjump .Incompatible

.Teleport:
	setval TELEPORT
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
	db "PSYWAVE@"
	db "TELEPORT@"
	db "CANCEL@"

VioletMartGrannyScript:
	jumptextfaceplayer VioletMartGrannyText

VioletMartCooltrainerMScript:
	jumptextfaceplayer VioletMartCooltrainerMText

VioletMartGrannyText:
	text "When you first"
	line "catch a #MON,"
	cont "it may be weak."

	para "But it will even-"
	line "tually grow to be"
	cont "strong."

	para "It's important to"
	line "treat #MON with"
	cont "love."
	done

VioletMartCooltrainerMText:
	text "#MON can hold"
	line "items like POTION"
	cont "and ANTIDOTE."

	para "But they don't"
	line "appear to know how"

	para "to use manmade"
	line "items."
	done

VioletMart_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  2,  7, VIOLET_CITY, 1
	warp_event  3,  7, VIOLET_CITY, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  1,  3, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VioletMartClerk1Script, -1
	object_event  1,  2, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, VioletMartClerk2Script, -1
	object_event  7,  6, SPRITE_GRANNY, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, VioletMartGrannyScript, -1
	object_event  5,  2, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, VioletMartCooltrainerMScript, -1
