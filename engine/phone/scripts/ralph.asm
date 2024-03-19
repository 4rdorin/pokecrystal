RalphPhoneCalleeScript:
	gettrainername STRING_BUFFER_3, FISHER, RALPH
	farscall PhoneScript_AnswerPhone_Male
	checktime MORN
	iftrue Ralph_WednesdayMorning
	farsjump RalphNoItemScript

RalphPhoneCallerScript:
	gettrainername STRING_BUFFER_3, FISHER, RALPH
	farscall PhoneScript_GreetPhone_Male
	farsjump Phone_GenericCall_Male

Ralph_WednesdayMorning:
	setflag ENGINE_RALPH_WEDNESDAY_MORNING
