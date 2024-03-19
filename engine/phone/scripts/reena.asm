ReenaPhoneCalleeScript:
	gettrainername STRING_BUFFER_3, COOLTRAINERF, REENA
	farscall PhoneScript_AnswerPhone_Female
	checkflag ENGINE_REENA_SUNDAY_MORNING
	iftrue .NotSunday
	readvar VAR_WEEKDAY
	ifnotequal SUNDAY, .NotSunday
	checktime MORN
	iftrue ReenaSundayMorning

.NotSunday:
	farsjump ReenaForwardScript

ReenaPhoneCallerScript:
	gettrainername STRING_BUFFER_3, COOLTRAINERF, REENA
	farscall PhoneScript_GreetPhone_Female
	checkflag ENGINE_REENA_SUNDAY_MORNING
	iftrue .Generic

.Generic:
	farsjump Phone_GenericCall_Female

ReenaSundayMorning:
	setflag ENGINE_REENA_SUNDAY_MORNING
