TullyPhoneCalleeScript:
	gettrainername STRING_BUFFER_3, FISHER, TULLY
	farscall PhoneScript_AnswerPhone_Male
	checkflag ENGINE_TULLY_SUNDAY_NIGHT
	iftrue .NotSunday
	checkflag ENGINE_TULLY_HAS_WATER_STONE
	iftrue .WaterStone
	readvar VAR_WEEKDAY
	ifnotequal SUNDAY, .NotSunday
	checktime NITE
	iftrue TullySundayNight

.NotSunday:
	farsjump TullyNoItemScript

.WaterStone:
	getlandmarkname STRING_BUFFER_5, LANDMARK_ROUTE_42
	farsjump TullyHurryScript

TullyPhoneCallerScript:
	gettrainername STRING_BUFFER_3, FISHER, TULLY
	farscall PhoneScript_GreetPhone_Male
	checkflag ENGINE_TULLY_SUNDAY_NIGHT
	iftrue .Generic
	checkflag ENGINE_TULLY_HAS_WATER_STONE
	iftrue .Generic
	checkevent EVENT_TULLY_GAVE_WATER_STONE
	iftrue .WaterStone
	farscall PhoneScript_Random2
	ifequal 0, TullyFoundWaterStone

.WaterStone:
	farscall PhoneScript_Random11
	ifequal 0, TullyFoundWaterStone

.Generic:
	farsjump Phone_GenericCall_Male

TullySundayNight:
	setflag ENGINE_TULLY_SUNDAY_NIGHT

TullyFoundWaterStone:
	setflag ENGINE_TULLY_HAS_WATER_STONE
	getlandmarkname STRING_BUFFER_5, LANDMARK_ROUTE_42
	farsjump PhoneScript_FoundItem_Male
