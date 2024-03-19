BrentPhoneCalleeScript:
	gettrainername STRING_BUFFER_3, POKEMANIAC, BRENT
	farscall PhoneScript_AnswerPhone_Male
	checkflag ENGINE_BRENT_MONDAY_MORNING
	iftrue .NotMonday
	readvar VAR_WEEKDAY
	ifnotequal MONDAY, .NotMonday
	checktime MORN
	iftrue BrentMondayMorning

.NotMonday:
	farsjump BrentHangUpScript

BrentPhoneCallerScript:
	gettrainername STRING_BUFFER_3, POKEMANIAC, BRENT
	farscall PhoneScript_GreetPhone_Male
	farscall PhoneScript_Random2
	ifequal 0, BrentBillTrivia
	checkflag ENGINE_BRENT_MONDAY_MORNING
	iftrue .Generic

.Generic:
	farsjump Phone_GenericCall_Male

BrentMondayMorning:
	setflag ENGINE_BRENT_MONDAY_MORNING

BrentBillTrivia:
	farsjump BrentBillTriviaScript
