LizPhoneCalleeScript:
	gettrainername STRING_BUFFER_3, PICNICKER, LIZ
	farscall PhoneScript_AnswerPhone_Female
	checkflag ENGINE_LIZ_THURSDAY_AFTERNOON
	iftrue .NotThursday
	readvar VAR_WEEKDAY
	ifnotequal THURSDAY, .NotThursday
	checktime DAY
	iftrue LizThursdayAfternoon

.NotThursday:
	special RandomPhoneMon
	farsjump LizHangUpScript

LizPhoneCallerScript:
	gettrainername STRING_BUFFER_3, PICNICKER, LIZ
	farscall PhoneScript_Random4
	ifequal 0, LizWrongNumber
	farscall PhoneScript_GreetPhone_Female
	checkflag ENGINE_LIZ_THURSDAY_AFTERNOON
	iftrue .next

.next:
	farscall PhoneScript_Random2
	ifequal 0, LizGossip
	checkflag ENGINE_FLYPOINT_GOLDENROD
	iffalse .Generic

.Generic:
	farsjump Phone_GenericCall_Female

LizThursdayAfternoon:
	setflag ENGINE_LIZ_THURSDAY_AFTERNOON

LizWrongNumber:
	farsjump LizWrongNumberScript

LizGossip:
	random 9
	ifequal 0, .CoolTrainerM
	ifequal 1, .Beauty
	ifequal 2, .Grunt
	ifequal 3, .Teacher
	ifequal 4, .SwimmerF
	ifequal 5, .KimonoGirl
	ifequal 6, .Skier
	ifequal 7, .Medium
	ifequal 8, .PokefanM

.CoolTrainerM:
	gettrainerclassname STRING_BUFFER_4, COOLTRAINERM
	sjump LizGossipScript

.Beauty:
	gettrainerclassname STRING_BUFFER_4, BEAUTY
	sjump LizGossipScript

.Grunt:
	gettrainerclassname STRING_BUFFER_4, GRUNTM
	sjump LizGossipScript

.Teacher:
	gettrainerclassname STRING_BUFFER_4, TEACHER
	sjump LizGossipScript

.SwimmerF:
	gettrainerclassname STRING_BUFFER_4, SWIMMERF
	sjump LizGossipScript

.KimonoGirl:
	gettrainerclassname STRING_BUFFER_4, KIMONO_GIRL
	sjump LizGossipScript

.Skier:
	gettrainerclassname STRING_BUFFER_4, SKIER
	sjump LizGossipScript

.Medium:
	gettrainerclassname STRING_BUFFER_4, MEDIUM
	sjump LizGossipScript

.PokefanM:
	gettrainerclassname STRING_BUFFER_4, POKEFANM
	sjump LizGossipScript

LizGossipScript:
	farsjump LizGossipRandomScript