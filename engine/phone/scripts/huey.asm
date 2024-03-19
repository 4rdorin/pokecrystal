HueyPhoneCalleeScript:
	gettrainername STRING_BUFFER_3, SAILOR, HUEY
	farscall PhoneScript_AnswerPhone_Male
	checkflag ENGINE_HUEY_WEDNESDAY_NIGHT
	iftrue .NotWednesday
	readvar VAR_WEEKDAY
	ifnotequal WEDNESDAY, .NotWednesday
	checktime NITE
	iftrue HueyWednesdayNight

.NotWednesday:
	special RandomPhoneMon
	farsjump HueyHangUpScript

.WantsBattle:
	getlandmarkname STRING_BUFFER_5, LANDMARK_LIGHTHOUSE
	farsjump HueyWantsBattleScript

HueyPhoneCallerScript:
	gettrainername STRING_BUFFER_3, SAILOR, HUEY
	farscall PhoneScript_GreetPhone_Male
	farsjump PhoneScript_MonFlavorText

HueyWednesdayNight:
	setflag ENGINE_HUEY_WEDNESDAY_NIGHT
