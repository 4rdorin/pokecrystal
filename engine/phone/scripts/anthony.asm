AnthonyPhoneCalleeScript:
	gettrainername STRING_BUFFER_3, HIKER, ANTHONY
	farscall PhoneScript_AnswerPhone_Male
	checktime NITE
	iftrue AnthonyFridayNight
	farsjump AnthonyHangUpScript

AnthonyPhoneCallerScript:
	gettrainername STRING_BUFFER_3, HIKER, ANTHONY
	farscall PhoneScript_GreetPhone_Male
	farsjump Phone_GenericCall_Male

AnthonyFridayNight:
	setflag ENGINE_ANTHONY_FRIDAY_NIGHT
	