GavenPhoneCalleeScript:
	gettrainername STRING_BUFFER_3, COOLTRAINERM, GAVEN
	farscall PhoneScript_AnswerPhone_Male
	checkflag ENGINE_GAVEN_THURSDAY_MORNING
	iftrue .NotThursday
	readvar VAR_WEEKDAY
	ifnotequal THURSDAY, .NotThursday
	checktime MORN
	iftrue GavenThursdayMorningScript

.NotThursday:
	farsjump GavenHangUpNotThursdayScript

GavenPhoneCallerScript:
	gettrainername STRING_BUFFER_3, COOLTRAINERM, GAVEN
	farscall PhoneScript_GreetPhone_Male
	checkflag ENGINE_GAVEN_THURSDAY_MORNING
	iftrue .WaitingForBattle

.WaitingForBattle:
	farscall PhoneScript_Random3
	ifequal 0, GavenFoundRare
	farsjump Phone_GenericCall_Male

GavenThursdayMorningScript:
	setflag ENGINE_GAVEN_THURSDAY_MORNING

GavenFoundRare:
	farsjump Phone_CheckIfUnseenRare_Male
