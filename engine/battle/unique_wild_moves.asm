CheckUniqueWildMove:
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	call GetWorldMapLocation
	ld c, a
	ld hl, UniqueWildMoves
.loop
	ld a, [hli] ; landmark
	cp -1
	ret z
	cp c
	jr nz, .inc2andloop
	ld a, [hli] ; species
	ld b, a
	ld a, [wCurPartySpecies]
	cp b
	jr nz, .inc1andloop
	ld a, [hli] ; move
	ld b, a
	;Teach the move
	ld hl, wEnemyMonMoves + 1 ; second move
	ld a, [hl]
	and a
	jr z, .ok
	inc hl ; third move
	ld a, [hl]
	and a
	jr z, .ok
	inc hl ; fourth move
	ld a, [hl]
	and a
	jr z, .ok
	ld hl, wEnemyMonMoves ; first move
.ok
	ld a, b
	ld [hl], a
	ret

.inc2andloop
	inc hl
.inc1andloop
	inc hl
	jr .loop

INCLUDE "data/pokemon/unique_wild_moves.asm"
