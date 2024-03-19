ArniePhoneCalleeScript:
	gettrainername STRING_BUFFER_3, BUG_CATCHER, ARNIE
	farscall PhoneScript_AnswerPhone_Male
	checktime MORN
	iftrue ArnieTuesdayMorning
	farsjump ArnieHangUpScript

ArniePhoneCallerScript:
	gettrainername STRING_BUFFER_3, BUG_CATCHER, ARNIE
	farscall PhoneScript_GreetPhone_Male

ArnieTuesdayMorning:
	setflag ENGINE_ARNIE_TUESDAY_MORNING
