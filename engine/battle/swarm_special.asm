GenerateSwarmSpecial:
;Comprobamos que estamos en el mapa correcto
	ld a, [wSwarmMapGroup]
	ld b, a
	ld a, [wMapGroup]
	cp b
	jr nz, .normalencounter
	ld a, [wSwarmMapNumber]
	ld b, a
	ld a, [wMapNumber]
	cp b
	jr nz, .normalencounter

;Comprobamos que el pokemon que encontramos
	ld a, [wSwarmSpecies]
	ld b, a
	ld a, [wCurPartySpecies]
	cp b
	jr nz, .normalencounter

;Probabilidad de IVs perfectos y de shiny
	ld a, 100
    call RandomRange
	cp 30 ; adjust to desired percentage
	jr nc, .trynext
	ld b, $ff
	ld c, $ff
	jr .UpdateDVs
.trynext:
	ld a, 100
    call RandomRange
	cp 1 ; adjust to desired percentage
	jr nc, .tryfshiny
	ld b, DV_SHINY
	ld c, DV_SHINY2
	jr .UpdateDVs
.tryfshiny:
	ld a, 100
    call RandomRange
	cp 1 ; adjust to desired percentage
	jr nc, .normalencounter
	ld b, DV_SHINY3
	ld c, DV_SHINY2
	jr .UpdateDVs

.normalencounter:
; Generate new random DVs
	call BattleRandom
	ld b, a
	call BattleRandom
	ld c, a

.UpdateDVs:
; Input DVs in register bc
	ld hl, wEnemyMonDVs
	ld a, b
	ld [hli], a
	ld [hl], c
	ret
