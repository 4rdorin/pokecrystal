VancePhoneCalleeScript:
	gettrainername STRING_BUFFER_3, BIRD_KEEPER, VANCE
	farscall PhoneScript_AnswerPhone_Male
	checkflag ENGINE_VANCE_WEDNESDAY_NIGHT
	iftrue .NotWednesday
	readvar VAR_WEEKDAY
	ifnotequal WEDNESDAY, .NotWednesday
	checktime NITE
	iftrue VanceWednesdayNight

.NotWednesday:
	farsjump VanceLookingForwardScript

VancePhoneCallerScript:
	gettrainername STRING_BUFFER_3, BIRD_KEEPER, VANCE
	farscall PhoneScript_GreetPhone_Male
	checkflag ENGINE_VANCE_WEDNESDAY_NIGHT
	iftrue .WantsBattle

.WantsBattle:
	farsjump Phone_GenericCall_Male

VanceWednesdayNight:
	setflag ENGINE_VANCE_WEDNESDAY_NIGHT
