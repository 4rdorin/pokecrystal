ToddPhoneCalleeScript:
	gettrainername STRING_BUFFER_3, CAMPER, TODD
	farscall PhoneScript_AnswerPhone_Male
	checkflag ENGINE_TODD_SATURDAY_MORNING
	iftrue .NotSaturday
	readvar VAR_WEEKDAY
	ifnotequal SATURDAY, .NotSaturday
	checktime MORN
	iftrue ToddSaturdayMorning

.NotSaturday:
	checkflag ENGINE_GOLDENROD_DEPT_STORE_SALE_IS_ON
	iftrue .SaleOn
	farsjump ToddNoItemScript

.SaleOn:
	farsjump ToddHurryScript

ToddPhoneCallerScript:
	gettrainername STRING_BUFFER_3, CAMPER, TODD
	farscall PhoneScript_GreetPhone_Male
	checkflag ENGINE_TODD_SATURDAY_MORNING
	iftrue .TryForSale
	checkflag ENGINE_FLYPOINT_GOLDENROD
	iffalse .NoGoldenrod

.TryForSale:
	farscall PhoneScript_Random2
	ifequal 0, ToddDeptStoreSale

.NoGoldenrod:
	farscall PhoneScript_Random3
	ifequal 0, ToddFoundRare
	farsjump Phone_GenericCall_Male

ToddSaturdayMorning:
	setflag ENGINE_TODD_SATURDAY_MORNING

ToddFoundRare:
	farsjump Phone_CheckIfUnseenRare_Male

ToddDeptStoreSale:
	setflag ENGINE_GOLDENROD_DEPT_STORE_SALE_IS_ON
	farsjump ToddItemScript
