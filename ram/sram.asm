SECTION "Scratch", SRAM

UNION
 sScratch:: ds $60 tiles

NEXTU
sEnemyFrontpicTileCount:: db
sPaddedEnemyFrontpic:: ds 7 * 7 tiles
ENDU


SECTION "SRAM Bank 0", SRAM

sPartyMail::
; sPartyMon1Mail - sPartyMon6Mail
for n, 1, PARTY_LENGTH + 1
sPartyMon{d:n}Mail:: mailmsg sPartyMon{d:n}Mail
endr

sPartyMailBackup::
; sPartyMon1MailBackup - sPartyMon6MailBackup
for n, 1, PARTY_LENGTH + 1
sPartyMon{d:n}MailBackup:: mailmsg sPartyMon{d:n}MailBackup
endr

sMailboxCount:: db
sMailboxes::
; sMailbox1 - sMailbox10
for n, 1, MAILBOX_CAPACITY + 1
sMailbox{d:n}:: mailmsg sMailbox{d:n}
endr

sMailboxCountBackup:: db
sMailboxesBackup::
; sMailbox1Backup - sMailbox10Backup
for n, 1, MAILBOX_CAPACITY + 1
sMailbox{d:n}Backup:: mailmsg sMailbox{d:n}Backup
endr

sMysteryGiftData::
sMysteryGiftItem:: db
sMysteryGiftUnlocked:: db
sBackupMysteryGiftItem:: db
sNumDailyMysteryGiftPartnerIDs:: db
sDailyMysteryGiftPartnerIDs:: ds MAX_MYSTERY_GIFT_PARTNERS * 2
sMysteryGiftDecorationsReceived:: flag_array NUM_NON_TROPHY_DECOS
	ds 4
sMysteryGiftTimer:: dw
	ds 1
sMysteryGiftTrainerHouseFlag:: db
sMysteryGiftPartnerName:: ds NAME_LENGTH
sMysteryGiftTrainer:: ds wMysteryGiftTrainerEnd - wMysteryGiftTrainer
sBackupMysteryGiftItemEnd::

	ds 49

sRTCStatusFlags:: db
	ds 7
sLuckyNumberDay:: db
sLuckyIDNumber::  dw


SECTION "Backup Save", SRAM

sBackupOptions:: ds wOptionsEnd - wOptions

sBackupCheckValue1:: db ; loaded with SAVE_CHECK_VALUE_1, used to check save corruption

sBackupGameData::
sBackupPlayerData::  ds wPlayerDataEnd - wPlayerData
sBackupCurMapData::  ds wCurMapDataEnd - wCurMapData
sBackupPokemonData:: ds wPokemonDataEnd - wPokemonData
sBackupGameDataEnd::

	ds $18a

sBackupChecksum:: dw

sBackupCheckValue2:: db ; loaded with SAVE_CHECK_VALUE_2, used to check save corruption

sStackTop:: dw

if DEF(_DEBUG)
sRTCHaltCheckValue:: dw
sSkipBattle:: db
sDebugTimeCyclesSinceLastCall:: db
sOpenedInvalidSRAM:: db
sIsBugMon:: db
endc


SECTION "Save", SRAM

sOptions:: ds wOptionsEnd - wOptions

sCheckValue1:: db ; loaded with SAVE_CHECK_VALUE_1, used to check save corruption

sGameData::
sPlayerData::  ds wPlayerDataEnd - wPlayerData
sCurMapData::  ds wCurMapDataEnd - wCurMapData
sPokemonData:: ds wPokemonDataEnd - wPokemonData
sGameDataEnd::

	ds $18a

sChecksum:: dw

sCheckValue2:: db ; loaded with SAVE_CHECK_VALUE_2, used to check save corruption


SECTION "Box Metadata", SRAM

for n, 1, NUM_BOXES + 1
sNewBox{d:n}:: newbox sNewBox{d:n}
endr
sNewBoxEnd::

for n, 1, NUM_BOXES + 1
sBackupNewBox{d:n}:: newbox sBackupNewBox{d:n}
endr
sBackupNewBoxEnd::

sWritingBackup:: db ; 1 if we're saving, anything else if not.

	ds $ff


SECTION "Link Battle Data", SRAM

sLinkBattleStats::
sLinkBattleWins::   dw
sLinkBattleLosses:: dw
sLinkBattleDraws::  dw

sLinkBattleRecord::
; sLinkBattleRecord1 - sLinkBattleRecord5
for n, 1, NUM_LINK_BATTLE_RECORDS + 1
sLinkBattleRecord{d:n}:: link_battle_record sLinkBattleRecord{d:n}
endr
sLinkBattleStatsEnd::


SECTION "SRAM Hall of Fame", SRAM

sHallOfFame::
; sHallOfFame1 - sHallOfFame30
for n, 1, NUM_HOF_TEAMS + 1
sHallOfFame{d:n}:: hall_of_fame sHallOfFame{d:n}
endr
sHallOfFameEnd::


SECTION "SRAM Battle Tower", SRAM

; Battle Tower data must be in SRAM because you can save and leave between battles
sBattleTowerChallengeState::
; 0: normal
; 2: battle tower
	db

sBattleTower:: ; be46
sNrOfBeatenBattleTowerTrainers:: db
sBTChoiceOfLevelGroup:: db
; Battle Tower trainers are saved here, so nobody appears more than once
sBTTrainers:: ds BATTLETOWER_STREAK_LENGTH ; sbe48
sBattleTowerSaveFileFlags:: db
sBattleTowerReward:: db

; team of previous trainer
sBTMonOfTrainers:: ; be51
sBTMonPrevTrainer1:: db
sBTMonPrevTrainer2:: db
sBTMonPrevTrainer3:: db
; team of preprevious trainer
sBTMonPrevPrevTrainer1:: db
sBTMonPrevPrevTrainer2:: db
sBTMonPrevPrevTrainer3:: db


SECTION "PokeDB Bank 1", SRAM

sNewBoxMons1:: pokedb sNewBoxMons1, MONDB_ENTRIES


SECTION "PokeDB Bank 2", SRAM

sNewBoxMons2:: pokedb sNewBoxMons2, MONDB_ENTRIES


SECTION "SRAM Bank 4", SRAM


SECTION "SRAM Bank 5", SRAM


SECTION "SRAM Bank 6", SRAM


SECTION "SRAM Bank 7", SRAM
ENDSECTION