ParryPhoneCalleeScript:
	gettrainername STRING_BUFFER_3, HIKER, PARRY
	farscall PhoneScript_AnswerPhone_Male
	checktime DAY
	iftrue ParryFridayDay

ParryPhoneCallerScript:
	gettrainername STRING_BUFFER_3, HIKER, PARRY
	farscall PhoneScript_GreetPhone_Male
	checkflag ENGINE_PARRY_FRIDAY_AFTERNOON
	iftrue .GenericCall

.GenericCall:
	farsjump Phone_GenericCall_Male

ParryFridayDay:
	setflag ENGINE_PARRY_FRIDAY_AFTERNOON
