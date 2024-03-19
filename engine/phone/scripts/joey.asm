JoeyPhoneCalleeScript:
	gettrainername STRING_BUFFER_3, YOUNGSTER, JOEY
	farscall PhoneScript_AnswerPhone_Male
	checkflag ENGINE_JOEY_MONDAY_AFTERNOON
	iftrue .NotMonday
	readvar VAR_WEEKDAY
	ifnotequal MONDAY, .NotMonday
	checktime DAY
	iftrue JoeyMondayAfternoon

.NotMonday:
	special RandomPhoneMon
	farsjump JoeyHangUpScript

JoeyPhoneCallerScript:
	gettrainername STRING_BUFFER_3, YOUNGSTER, JOEY
	farscall PhoneScript_GreetPhone_Male
	checkflag ENGINE_JOEY_MONDAY_AFTERNOON
	iftrue .Generic

.Generic:
	farsjump Phone_GenericCall_Male

JoeyMondayAfternoon:
	setflag ENGINE_JOEY_MONDAY_AFTERNOON
