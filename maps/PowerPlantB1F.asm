	object_const_def
	const POWERPLANTB1F_ZAPDOS

PowerPlantB1F_MapScripts:
	def_scene_scripts

	def_callbacks
	callback MAPCALLBACK_OBJECTS, ZapdosEncounter

ZapdosEncounter:
	checkevent EVENT_FOUGHT_ZAPDOS
	iftrue .NoAppear

.Appear:
	appear POWERPLANTB1F_ZAPDOS
	endcallback

.NoAppear:
	disappear POWERPLANTB1F_ZAPDOS
	endcallback

PowerPlantB1FZapdos:
	opentext
	writetext ZapdosText
	cry ZAPDOS
	pause 15
	closetext
	;writecode VAR_BATTLETYPE, BATTLETYPE_KANTO_LEGEND
	loadwildmon ZAPDOS, 50
	startbattle
	disappear POWERPLANTB1F_ZAPDOS
	setevent EVENT_FOUGHT_ZAPDOS
	reloadmapafterbattle
	special CheckBattleCaughtResult
	iffalse .nocatch
	setflag ENGINE_PLAYER_CAUGHT_ZAPDOS
.nocatch
	end

ZapdosText:
	text "Gyaoo!"
	done

PowerPlantB1F_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  3, 10, POWER_PLANT, 3
	warp_event  4, 35, ROUTE_10_SOUTH, 1
	warp_event  5, 35, ROUTE_10_SOUTH, 1

	def_coord_events

	def_bg_events

	def_object_events
	object_event  5, 30, SPRITE_ZAPDOS, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_ROCK, OBJECTTYPE_SCRIPT, 0, PowerPlantB1FZapdos, EVENT_ZAPDOS_APPEAR
