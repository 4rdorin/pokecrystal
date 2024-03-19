GinaPhoneCalleeScript:
	gettrainername STRING_BUFFER_3, PICNICKER, GINA
	farscall PhoneScript_AnswerPhone_Female
	checkflag ENGINE_GINA_SUNDAY_AFTERNOON
	iftrue .NotSunday
	checkflag ENGINE_GINA_HAS_LEAF_STONE
	iftrue .HasLeafStone
	readvar VAR_WEEKDAY
	ifnotequal SUNDAY, .NotSunday
	checktime DAY
	iftrue GinaSundayDay

.NotSunday:
	checkflag ENGINE_ROCKETS_IN_RADIO_TOWER
	iftrue .Rockets
	farsjump GinaHangUpScript

.Rockets:
	farsjump GinaRocketRumorScript

.WantsBattle:
	getlandmarkname STRING_BUFFER_5, LANDMARK_ROUTE_34
	farsjump GinaReminderScript

.HasLeafStone:
	getlandmarkname STRING_BUFFER_5, LANDMARK_ROUTE_34
	farsjump GinaComePickUpScript

GinaPhoneCallerScript:
	gettrainername STRING_BUFFER_3, PICNICKER, GINA
	farscall PhoneScript_GreetPhone_Female
	checkflag ENGINE_ROCKETS_IN_RADIO_TOWER
	iftrue GinaRockets
	checkflag ENGINE_GINA_SUNDAY_AFTERNOON
	iftrue .Generic
	checkflag ENGINE_GINA_HAS_LEAF_STONE
	iftrue .Generic
	checkevent EVENT_GINA_GAVE_LEAF_STONE
	iftrue .GaveLeafStone
	farscall PhoneScript_Random2
	ifequal 0, GinaHasLeafStone

.GaveLeafStone:
	farscall PhoneScript_Random11
	ifequal 0, GinaHasLeafStone
	checkflag ENGINE_FLYPOINT_GOLDENROD
	iffalse .Generic

.Generic:
	farsjump Phone_GenericCall_Female

GinaSundayDay:
	setflag ENGINE_GINA_SUNDAY_AFTERNOON

GinaRockets:
	farsjump GinaRocketRumorScript

GinaHasLeafStone:
	setflag ENGINE_GINA_HAS_LEAF_STONE
	getlandmarkname STRING_BUFFER_5, LANDMARK_ROUTE_34
	farsjump PhoneScript_FoundItem_Female
