JackPhoneCalleeScript:
	gettrainername STRING_BUFFER_3, SCHOOLBOY, JACK
	farscall PhoneScript_AnswerPhone_Male
	checkflag ENGINE_JACK_MONDAY_MORNING
	iftrue .NotMonday
	readvar VAR_WEEKDAY
	ifnotequal MONDAY, .NotMonday
	checktime MORN
	iftrue JackMondayMorning

.NotMonday:
	farsjump JackPhoneTipsScript

JackPhoneCallerScript:
	gettrainername STRING_BUFFER_3, SCHOOLBOY, JACK
	farscall PhoneScript_GreetPhone_Male
	farscall PhoneScript_Random2
	ifequal 0, JackBattleTrivia
	checkflag ENGINE_JACK_MONDAY_MORNING
	iftrue .WaitingForBattle

.WaitingForBattle:
	farscall PhoneScript_Random3
	ifequal 0, JackFindsRare
	farsjump Phone_GenericCall_Male

JackMondayMorning:
	setflag ENGINE_JACK_MONDAY_MORNING

JackFindsRare:
	farsjump Phone_CheckIfUnseenRare_Male

JackBattleTrivia:
	farsjump JackTriviaScript
