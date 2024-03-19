DEF __trainer_class__ = 0

MACRO trainerclass
	DEF \1 EQU __trainer_class__
	DEF __trainer_class__ += 1
	const_def 1
ENDM

; trainer class ids
; `trainerclass` indexes are for:
; - TrainerClassNames (see data/trainers/class_names.asm)
; - TrainerClassAttributes (see data/trainers/attributes.asm)
; - TrainerClassDVs (see data/trainers/dvs.asm)
; - TrainerGroups (see data/trainers/party_pointers.asm)
; - TrainerEncounterMusic (see data/trainers/encounter_music.asm)
; - TrainerPicPointers (see data/trainers/pic_pointers.asm)
; - TrainerPalettes (see data/trainers/palettes.asm)
; - BTTrainerClassSprites (see data/trainers/sprites.asm)
; - BTTrainerClassGenders (see data/trainers/genders.asm)
; trainer constants are Trainers indexes, for the sub-tables of TrainerGroups (see data/trainers/parties.asm)
DEF CHRIS EQU __trainer_class__
	trainerclass TRAINER_NONE ; 0
	const PHONECONTACT_MOM
	const PHONECONTACT_BIKESHOP
	const PHONECONTACT_BILL
	const PHONECONTACT_ELM
	const PHONECONTACT_BUENA
DEF NUM_NONTRAINER_PHONECONTACTS EQU const_value - 1

DEF KRIS EQU __trainer_class__
	trainerclass FALKNER ; 1
	const FALKNER1

	trainerclass WHITNEY ; 2
	const WHITNEY1

	trainerclass BUGSY ; 3
	const BUGSY1

	trainerclass MORTY ; 4
	const MORTY1

	trainerclass PRYCE ; 5
	const PRYCE1

	trainerclass JASMINE ; 6
	const JASMINE1

	trainerclass CHUCK ; 7
	const CHUCK1

	trainerclass CLAIR ; 8
	const CLAIR1

	trainerclass RIVAL1 ; 9
	const RIVAL1_1_CHIKORITA
	const RIVAL1_1_CYNDAQUIL
	const RIVAL1_1_TOTODILE
	const RIVAL1_2_CHIKORITA
	const RIVAL1_2_CYNDAQUIL
	const RIVAL1_2_TOTODILE
	const RIVAL1_3_CHIKORITA
	const RIVAL1_3_CYNDAQUIL
	const RIVAL1_3_TOTODILE
	const RIVAL1_4_CHIKORITA
	const RIVAL1_4_CYNDAQUIL
	const RIVAL1_4_TOTODILE
	const RIVAL1_5_CHIKORITA
	const RIVAL1_5_CYNDAQUIL
	const RIVAL1_5_TOTODILE

	trainerclass POKEMON_PROF ; a

	trainerclass WILL ; b
	const WILL1

	trainerclass CAL ; c
	const CAL2
	const CAL3

	trainerclass BRUNO ; d
	const BRUNO1

	trainerclass KAREN ; e
	const KAREN1

	trainerclass KOGA ; f
	const KOGA1

	trainerclass CHAMPION ; 10
	const LANCE

	trainerclass BROCK ; 11
	const BROCK1

	trainerclass MISTY ; 12
	const MISTY1

	trainerclass LT_SURGE ; 13
	const LT_SURGE1

	trainerclass SCIENTIST ; 14
	const ROSS	; TEAM ROCKET BASE
	const MITCH	; TEAM ROCKET BASE
	const JED	; TEAM ROCKET BASE
	const MARC	; RADIO TOWER
	const RICH	; RADIO TOWER

	trainerclass ERIKA ; 15
	const ERIKA1

	trainerclass YOUNGSTER ; 16
	const JOEY	; R30
	const MIKEY	; R30
	const ALBERT ; R32
	const GORDON ; R32
	const SAMUEL ; R34
	const IAN	; R34
	const WARREN ; R3
	const JIMMY	; R3
	const OWEN	; R11
	const JASON ; R11

	trainerclass SCHOOLBOY ; 17
	const JACK	; NATIONAL PARK
	const KIPP  ; R15
	const ALAN	; R36
	const JOHNNY ; R15
	const DANNY	; R1
	const TOMMY ; R15
	const DUDLEY ; R25
	const JOE ; R25
	const BILLY ; R15
	const CHAD ; R38
	const NATE ; FASTSHIP
	const RICKY ; FASTSHIP

	trainerclass BIRD_KEEPER ; 18
	const ROD 	; VIOLET GYM
	const ABE 	; VIOLET GYM
	const BRYAN ; R35
	const THEO	; LIGHTHOUSE
	const TOBY	; R38
	const DENIS	; LIGHTHOUSE
	const VANCE ; R44
	const HANK	; R4
	const ROY	; R14
	const BORIS	; R18
	const BOB	; R18
	const JOSE  ; R27
	const PETER	; R32
	const PERRY	; R13
	const BRET	; R13
	const KARTER ; R31
	const EASTON ; R31

	trainerclass LASS ; 19
	const CARRIE ; GOLDENROD GYM
	const BRIDGET ; GOLDENROD GYM
	const ALICE ; FUCHSIA GYM
	const KRISE ; NATIONAL PARK
	const CONNIE1 ; LIGHTHOUSE
	const LINDA ; FUCHSIA GYM
	const LAURA	; R25
	const SHANNON ; R25
	const MICHELLE ; CELADON GYM
	const DANA	; R38
	const ELLEN ; R25

	trainerclass JANINE ; 1a
	const JANINE1

	trainerclass COOLTRAINERM ; 1b
	const NICK	; UNION CAVE
	const AARON	; LAKE OF RAGE
	const PAUL	; BLACKTHORN GYM
	const CODY	; BLACKTHORN GYM
	const MIKE	; BLACKTHORN GYM
	const GAVEN ; R26
	const RYAN	; R45
	const JAKE	; R26
	const BLAKE	; R27
	const BRIAN	; R27
	const SEAN	; FASTSHIP
	const KEVIN ; R25
	const ALLEN ; R44
	const DARIN ; DRAGONS DEN

	trainerclass COOLTRAINERF ; 1c
	const GWEN 	; UNION CAVE
	const LOIS 	; LAKE OF RAGE
	const FRAN	; BLACKTHORN GYM
	const LOLA	; BLACKTHORN GYM
	const KATE	; R34
	const IRENE	; R34
	const KELLY	; R45
	const JOYCE	; R26
	const BETH	; R26
	const REENA ; R27
	const MEGAN	; R27
	const CAROL	; FASTSHIP
	const QUINN ; R1
	const EMMA	; UNION CAVE
	const CYBIL	; R44
	const JENN	; R34
	const CARA	; DRAGONS DEN

	trainerclass BEAUTY ; 1d
	const VICTORIA 	; GOLDENROD GYM
	const SAMANTHA 	; GOLDENROD GYM
	const CASSIE	; FASTSHIP
	const JULIA		; CELADON GYM
	const VALERIE	; R38
	const OLIVIA	; R38

	trainerclass POKEMANIAC ; 1e
	const LARRY	; UNION CAVE
	const ANDREW ; UNION CAVE
	const CALVIN ; UNION CAVE
	const SHANE	; R42
	const BEN	; R43
	const BRENT ; R43
	const RON	; R43
	const ETHAN	; FASTSHIP
	const ISSAC	; GOLDENROD UNDERGROUND
	const DONALD ; GOLDENROD UNDERGROUND
	const ZACH	; R44
	const MILLER ; MOUNT MORTAR

	trainerclass GRUNTM ; 1f
	const GRUNTM_1	; SLOWPOKE WELL
	const GRUNTM_2	; SLOWPOKE WELL
	const GRUNTM_3	; RADIO TOWER
	const GRUNTM_4	; RADIO TOWER
	const GRUNTM_5	; RADIO TOWER
	const GRUNTM_6	; RADIO TOWER
	const GRUNTM_7	; RADIO TOWER
	const GRUNTM_8	; RADIO TOWER
	const GRUNTM_9	; RADIO TOWER
	const GRUNTM_10	; RADIO TOWER
	const GRUNTM_11 ; GOLDENROD UNDERGROUND
	const GRUNTM_13 ; GOLDENROD UNDERGROUND
	const GRUNTM_14 ; GOLDENROD UNDERGROUND
	const GRUNTM_15 ; GOLDENROD UNDERGROUND
	const GRUNTM_16 ; TEAM ROCKET BASE
	const GRUNTM_17 ; TEAM ROCKET BASE
	const GRUNTM_18 ; TEAM ROCKET BASE
	const GRUNTM_19 ; TEAM ROCKET BASE
	const GRUNTM_20 ; TEAM ROCKET BASE
	const GRUNTM_21 ; TEAM ROCKET BASE
	const GRUNTM_24 ; GOLDENROD UNDERGROUND
	const GRUNTM_25 ; GOLDENROD UNDERGROUND
	const GRUNTM_28 ; TEAM ROCKET BASE
	const GRUNTM_29 ; SLOWPOKE WELL
	const GRUNTM_31 ; R24

	trainerclass GENTLEMAN ; 20
	const PRESTON	; LIGHTHOUSE
	const EDWARD	; FASTSHIP
	const GREGORY	; VERMILION GYM
	const ALFRED	; LIGHTHOUSE

	trainerclass SKIER ; 21
	const ROXANNE	; MAHOGANY GYM
	const CLARISSA	; MAHOGANY GYM

	trainerclass TEACHER ; 22
	const COLETTE	; R15
	const HILLARY	; R15
	const SHIRLEY	; FASTSHIP

	trainerclass SABRINA ; 23
	const SABRINA1

	trainerclass BUG_CATCHER ; 24
	const DON	; R30
	const ROB	; ???
	const ED	; R2N
	const WADE	; R31
	const BENNY ; AZALEA GYM
	const AL	; AZALEA GYM
	const JOSH	; AZALEA GYM
	const ARNIE ; R35
	const KEN	; FASTSHIP
	const DOUG	; ???
	const WAYNE	; ILEX FOREST

	trainerclass FISHER ; 25
	const JUSTIN	; R32
	const RALPH		; R32
	const ARNOLD	; R21
	const KYLE		; R12
	const HENRY		; R32
	const MARVIN	; R43
	const TULLY		; R42
	const ANDRE		; LAKE OF RAGE
	const RAYMOND	; LAKE OF RAGE
	const WILTON	; R44
	const EDGAR		; R44
	const JONAH		; FASTSHIP
	const MARTIN	; R12
	const STEPHEN	; R12
	const BARNEY	; R12
	const SCOTT		; R26
	const MURPHY	; R31
	const LIAM		; R31
	const GIDEON	; R31

	trainerclass SWIMMERM ; 26
	const HAROLD	; R19
	const SIMON		; R40
	const RANDALL	; R40
	const CHARLIE	; R41
	const GEORGE	; R41
	const BERKE		; R41
	const KIRK		; R41
	const MATHEW	; R41
	const JEROME	; R19
	const TUCKER	; R19
	const CAMERON	; R20
	const SETH		; R21
	const PARKER	; CELADON GYM
	const ESTEBAN	; R31
	const DUANE		; R31

	trainerclass SWIMMERF ; 27
	const ELAINE	; R40
	const PAULA		; R40
	const KAYLEE	; R41
	const SUSIE		; R41
	const DENISE	; R41
	const KARA		; R41
	const WENDY		; R41
	const DAWN		; R19
	const NICOLE	; R20
	const LORI		; R20
	const NIKKI		; R21
	const DIANA		; CELADON GYM
	const BRIANA	; CELADON GYM
	const CHELAN	; R31
	const KAIDYN	; R31

	trainerclass SAILOR ; 28
	const EUGENE	; R39
	const HUEY		; LIGHTHOUSE
	const TERRELL	; LIGHTHOUSE
	const KENT		; LIGHTHOUSE
	const ERNEST	; LIGHTHOUSE
	const JEFF		; FASTSHIP
	const GARRETT	; FASTSHIP
	const KENNETH	; FASTSHIP
	const STANLY	; FASTSHIP
	const HARRY		; R38

	trainerclass SUPER_NERD ; 29
	const STAN	; ROA OUTSIDE
	const ERIC	; GOLDENROD UNDERGROUND
	const SAM	; R8
	const TOM	; R8
	const PAT	; R25
	const SHAWN	; FASTSHIP
	const TERU	; GOLDENROD UNDERGROUND
	const HUGH	; MOUNT MORTAR
	const MARKUS ; MOUNT MORTAR

	trainerclass RIVAL2 ; 2a
	const RIVAL2_1_CHIKORITA
	const RIVAL2_1_CYNDAQUIL
	const RIVAL2_1_TOTODILE
	const RIVAL2_2_CHIKORITA
	const RIVAL2_2_CYNDAQUIL
	const RIVAL2_2_TOTODILE

	trainerclass GUITARIST ; 2b
	const CLYDE		; FASTSHIP
	const VINCENT	; VERMILION GYM

	trainerclass HIKER ; 2c
	const ANTHONY 	; R33
	const RUSSELL	; UNION CAVE
	const PHILLIP	; UNION CAVE
	const LEONARD	; UNION CAVE
	const BENJAMIN	; R42
	const ERIK		; R45
	const MICHAEL	; R45
	const PARRY		; R45
	const TIMOTHY	; R45
	const BAILEY	; R46
	const TIM		; R9
	const NOLAND	; FASTSHIP
	const SIDNEY	; R9
	const KENNY		; R13
	const JIM		; R10S
	const DANIEL	; UNION CAVE

	trainerclass BIKER ; 2d
	const DWAYNE	; R8
	const HARRIS	; R8
	const ZEKE		; R8
	const CHARLES	; R17
	const RILEY		; R17
	const JOEL		; R17
	const GLENN		; R17

	trainerclass BLAINE ; 2e
	const BLAINE1

	trainerclass BURGLAR ; 2f
	const DUNCAN 	; GOLDENROD UNDERGROUND
	const EDDIE		; GOLDENROD UNDERGROUND
	const COREY		; FASTSHIP

	trainerclass FIREBREATHER ; 30
	const OTIS	; R3
	const BURT	; R3
	const BILL	; UNION CAVE
	const WALT	; R35
	const RAY	; UNION CAVE
	const LYLE	; FASTSHIP

	trainerclass JUGGLER ; 31
	const IRWIN1	; R35
	const FRITZ		; FASTSHIP
	const HORTON	; VERMILION GYM

	trainerclass BLACKBELT_T ; 32
	const YOSHI	; CIANWOOD GYM
	const LAO	; CIANWOOD GYM
	const NOB	; CIANWOOD GYM
	const KIYO	; MOUNT MORTAR
	const LUNG	; CIANWOOD GYM
	const KENJI3 ; R45
	const WAI	; FASTSHIP

	trainerclass EXECUTIVEM ; 33
	const EXECUTIVEM_1	; RADIO TOWER
	const EXECUTIVEM_2	; RADIO TOWER
	const EXECUTIVEM_3	; RADIO TOWER
	const EXECUTIVEM_4	; TEAM ROCKET BASE

	trainerclass PSYCHIC_T ; 34
	const NATHAN	; ROA OUTSIDE
	const FRANKLIN	; SAFFRON GYM
	const HERMAN	; R11
	const FIDEL		; R11
	const GREG		; R37
	const NORMAN	; R39
	const MARK		; R36
	const PHIL		; R44
	const RICHARD	; R26
	const GILBERT	; R27
	const JARED		; SAFFRON GYM
	const RODNEY	; FASTSHIP

	trainerclass PICNICKER ; 35
	const LIZ	; R32
	const GINA ; R34
	const BROOKE ; R35
	const KIM	; R35
	const CINDY ; FUCHSIA GYM
	const HOPE	; R4
	const SHARON ; R4
	const DEBRA ; FASTSHIP
	const ERIN	; R46
	const HEIDI	; R9
	const EDNA	; R9
	const TIFFANY ; R43
	const TANYA	; CELADON GYM

	trainerclass CAMPER ; 36
	const ROLAND ; R32
	const TODD	; R34
	const IVAN	; R35
	const ELLIOT ; R35
	const BARRY	; FUCHSIA GYM
	const LLOYD	; R25
	const DEAN	; R9
	const SID	; R9
	const TED	; R46
	const JERRY	; PEWTER GYM
	const SPENCER ; R43
	const QUENTIN ; R45

	trainerclass EXECUTIVEF ; 37
	const EXECUTIVEF_1	; RADIO TOWER
	const EXECUTIVEF_2	; ROCKET BASE

	trainerclass SAGE ; 38
	const CHOW	; SPROUT TOWER
	const NICO	; SPROUT TOWER
	const JIN	; SPROUT TOWER
	const TROY	; SPROUT TOWER
	const JEFFREY ; ECRUTEAK GYM
	const PING	; ECRUTEAK GYM
	const EDMOND ; SPROUT TOWER
	const NEAL	; SPROUT TOWER
	const LI	; SPROUT TOWER
	const GAKU	; SUICUNE EVENT
	const MASA	; SUICUNE EVENT
	const KOJI	; SUICUNE EVENT

	trainerclass MEDIUM ; 39
	const MARTHA	; ECRUTEAK GYM
	const GRACE		; ECRUTEAK GYM
	const REBECCA	; SAFFRON GYM
	const DORIS		; SAFFRON GYM

	trainerclass BOARDER ; 3a
	const RONALD	; MAHOGANY GYM
	const BRAD		; MAHOGANY GYM
	const DOUGLAS	; MAHOGANY GYM

	trainerclass POKEFANM ; 3b
	const WILLIAM	; NATIONAL PARK
	const DEREK1	; R39
	const ROBERT	; R10S
	const JOSHUA	; R13
	const CARTER	; R14
	const TREVOR	; R14
	const BRANDON	; R34
	const JEREMY	; FASTSHIP
	const COLIN		; FASTSHIP
	const ALEX		; R13
	const REX		; R6
	const ALLAN		; R6

	trainerclass KIMONO_GIRL ; 3c
	const NAOKO
	const SAYO
	const ZUKI
	const KUNI
	const MIKI

	trainerclass TWINS ; 3d
	const AMYANDMAY1	; AZALEA GYM
	const ANNANDANNE1	; R37
	const ANNANDANNE2	; R37
	const AMYANDMAY2	; AZALEA GYM
	const JOANDZOE1		; CELADON GYM
	const JOANDZOE2		; CELADON GYM
	const MEGANDPEG1	; FASTSHIP
	const MEGANDPEG2	; FASTSHIP
	const LEAANDPIA1	; DRAGONS DEN

	trainerclass POKEFANF ; 3e
	const BEVERLY1 ; NATIONAL PARK
	const RUTH	; R39
	const GEORGIA ; FASTSHIP
	const JAIME	; R39

	trainerclass RED ; 3f
	const RED1

	trainerclass BLUE ; 40
	const BLUE1

	trainerclass OFFICER ; 41
	const KEITH	; R34
	const DIRK	; R35

	trainerclass GRUNTF ; 42
	const GRUNTF_1	; SLOWPOKE WELL
	const GRUNTF_2	; RADIO TOWER
	const GRUNTF_3	; GOLDENROD UNDERGROUND
	const GRUNTF_4	; RADIO TOWER
	const GRUNTF_5	; TEAM ROCKET BASE

	trainerclass MYSTICALMAN ; 43
	const EUSINE

DEF NUM_TRAINER_CLASSES EQU __trainer_class__ - 1
