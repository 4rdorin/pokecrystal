MACRO phone
; trainer class, trainer id, map, callee time, callee script, caller time, caller script
	db \1, \2
	map_id \3
	db \4
	dba \5
	db \6
	dba \7
ENDM

PhoneContacts:
; entries correspond to PHONE_* constants
	table_width PHONE_CONTACT_SIZE, PhoneContacts
	phone TRAINER_NONE, PHONE_00,              N_A,                       0,       UnusedPhoneScript,        0,       UnusedPhoneScript
	phone TRAINER_NONE, PHONECONTACT_MOM,      PLAYERS_HOUSE_1F,          ANYTIME, MomPhoneCalleeScript,     0,       UnusedPhoneScript
	phone TRAINER_NONE, PHONECONTACT_BIKESHOP, OAKS_LAB,                  0,       UnusedPhoneScript,        0,       UnusedPhoneScript
	phone TRAINER_NONE, PHONECONTACT_BILL,     N_A,                       ANYTIME, BillPhoneCalleeScript,    0,       BillPhoneCallerScript
	phone TRAINER_NONE, PHONECONTACT_ELM,      ELMS_LAB,                  ANYTIME, ElmPhoneCalleeScript,     0,       ElmPhoneCallerScript
	phone SCHOOLBOY,    JACK,                 NATIONAL_PARK,             ANYTIME, JackPhoneCalleeScript,    ANYTIME, JackPhoneCallerScript
	phone POKEFANF,     BEVERLY1,              NATIONAL_PARK,             ANYTIME, BeverlyPhoneCalleeScript, ANYTIME, BeverlyPhoneCallerScript
	phone SAILOR,       HUEY,                 OLIVINE_LIGHTHOUSE_2F,     ANYTIME, HueyPhoneCalleeScript,    ANYTIME, HueyPhoneCallerScript
	phone TRAINER_NONE, PHONE_00,              N_A,                       0,       UnusedPhoneScript,        0,       UnusedPhoneScript
	phone TRAINER_NONE, PHONE_00,              N_A,                       0,       UnusedPhoneScript,        0,       UnusedPhoneScript
	phone TRAINER_NONE, PHONE_00,              N_A,                       0,       UnusedPhoneScript,        0,       UnusedPhoneScript
	phone COOLTRAINERM, GAVEN,                ROUTE_26,                  ANYTIME, GavenPhoneCalleeScript,   ANYTIME, GavenPhoneCallerScript
	phone COOLTRAINERF, BETH,                 ROUTE_26,                  ANYTIME, BethPhoneCalleeScript,    ANYTIME, BethPhoneCallerScript
	phone BIRD_KEEPER,  JOSE,                 ROUTE_27,                  ANYTIME, JosePhoneCalleeScript,    ANYTIME, JosePhoneCallerScript
	phone COOLTRAINERF, REENA,                ROUTE_27,                  ANYTIME, ReenaPhoneCalleeScript,   ANYTIME, ReenaPhoneCallerScript
	phone YOUNGSTER,    JOEY,                 ROUTE_30,                  ANYTIME, JoeyPhoneCalleeScript,    ANYTIME, JoeyPhoneCallerScript
	phone BUG_CATCHER,  WADE,                 ROUTE_31,                  ANYTIME, WadePhoneCalleeScript,    ANYTIME, WadePhoneCallerScript
	phone FISHER,       RALPH,                ROUTE_32,                  ANYTIME, RalphPhoneCalleeScript,   ANYTIME, RalphPhoneCallerScript
	phone PICNICKER,    LIZ,                  ROUTE_32,                  ANYTIME, LizPhoneCalleeScript,     ANYTIME, LizPhoneCallerScript
	phone HIKER,        ANTHONY,              ROUTE_33,                  ANYTIME, AnthonyPhoneCalleeScript, ANYTIME, AnthonyPhoneCallerScript
	phone CAMPER,       TODD,                 ROUTE_34,                  ANYTIME, ToddPhoneCalleeScript,    ANYTIME, ToddPhoneCallerScript
	phone PICNICKER,    GINA,                 ROUTE_34,                  ANYTIME, GinaPhoneCalleeScript,    ANYTIME, GinaPhoneCallerScript
	phone JUGGLER,      IRWIN1,                ROUTE_35,                  ANYTIME, IrwinPhoneCalleeScript,   ANYTIME, IrwinPhoneCallerScript
	phone BUG_CATCHER,  ARNIE,                ROUTE_35,                  ANYTIME, ArniePhoneCalleeScript,   ANYTIME, ArniePhoneCallerScript
	phone SCHOOLBOY,    ALAN,                 ROUTE_36,                  ANYTIME, AlanPhoneCalleeScript,    ANYTIME, AlanPhoneCallerScript
	phone TRAINER_NONE, PHONE_00,              N_A,                       0,       UnusedPhoneScript,        0,       UnusedPhoneScript
	phone LASS,         DANA,                 ROUTE_38,                  ANYTIME, DanaPhoneCalleeScript,    ANYTIME, DanaPhoneCallerScript
	phone SCHOOLBOY,    CHAD,                 ROUTE_38,                  ANYTIME, ChadPhoneCalleeScript,    ANYTIME, ChadPhoneCallerScript
	phone POKEFANM,     DEREK1,                ROUTE_39,                  ANYTIME, DerekPhoneCalleeScript,   ANYTIME, DerekPhoneCallerScript
	phone FISHER,       TULLY,                ROUTE_42,                  ANYTIME, TullyPhoneCalleeScript,   ANYTIME, TullyPhoneCallerScript
	phone POKEMANIAC,   BRENT,                ROUTE_43,                  ANYTIME, BrentPhoneCalleeScript,   ANYTIME, BrentPhoneCallerScript
	phone PICNICKER,    TIFFANY,              ROUTE_43,                  ANYTIME, TiffanyPhoneCalleeScript, ANYTIME, TiffanyPhoneCallerScript
	phone BIRD_KEEPER,  VANCE,                ROUTE_44,                  ANYTIME, VancePhoneCalleeScript,   ANYTIME, VancePhoneCallerScript
	phone FISHER,       WILTON,               ROUTE_44,                  ANYTIME, WiltonPhoneCalleeScript,  ANYTIME, WiltonPhoneCallerScript
	phone BLACKBELT_T,  KENJI3,                ROUTE_45,                  ANYTIME, KenjiPhoneCalleeScript,   ANYTIME, KenjiPhoneCallerScript
	phone HIKER,        PARRY,                ROUTE_45,                  ANYTIME, ParryPhoneCalleeScript,   ANYTIME, ParryPhoneCallerScript
	phone PICNICKER,    ERIN,                 ROUTE_46,                  ANYTIME, ErinPhoneCalleeScript,    ANYTIME, ErinPhoneCallerScript
	phone TRAINER_NONE, PHONECONTACT_BUENA,    GOLDENROD_DEPT_STORE_ROOF, ANYTIME, BuenaPhoneCalleeScript,   ANYTIME, BuenaPhoneCallerScript
	assert_table_length NUM_PHONE_CONTACTS + 1
