BethPhoneCalleeScript:
	gettrainername STRING_BUFFER_3, COOLTRAINERF, BETH
	farscall PhoneScript_AnswerPhone_Female
	checkflag ENGINE_BETH_FRIDAY_AFTERNOON
	iftrue .NotFriday
	readvar VAR_WEEKDAY
	ifnotequal FRIDAY, .NotFriday
	checktime DAY
	iftrue BethFridayAfternoon

.NotFriday:
	farsjump BethHangUpScript

BethPhoneCallerScript:
	gettrainername STRING_BUFFER_3, COOLTRAINERF, BETH
	farscall PhoneScript_GreetPhone_Female
	checkflag ENGINE_BETH_FRIDAY_AFTERNOON
	iftrue .Generic

.Generic:
	farsjump Phone_GenericCall_Female

BethFridayAfternoon:
	setflag ENGINE_BETH_FRIDAY_AFTERNOON
