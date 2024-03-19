ErinPhoneCalleeScript:
	gettrainername STRING_BUFFER_3, PICNICKER, ERIN
	farscall PhoneScript_AnswerPhone_Female
	checkflag ENGINE_ERIN_SATURDAY_NIGHT
	iftrue .NotSaturday
	readvar VAR_WEEKDAY
	ifnotequal SATURDAY, .NotSaturday
	checktime NITE
	iftrue ErinSaturdayNight

.NotSaturday:
	farsjump ErinWorkingHardScript

ErinPhoneCallerScript:
	gettrainername STRING_BUFFER_3, PICNICKER, ERIN
	farscall PhoneScript_GreetPhone_Female
	checkflag ENGINE_ERIN_SATURDAY_NIGHT
	iftrue .GenericCall

.GenericCall:
	farsjump Phone_GenericCall_Female

ErinSaturdayNight:
	setflag ENGINE_ERIN_SATURDAY_NIGHT
