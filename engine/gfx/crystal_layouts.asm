Crystal_FillBoxCGB:
; This is a copy of FillBoxCGB.
.row
	push bc
	push hl
.col
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ret

LoadOW_BGPal7::
	ld hl, Palette_TextBG7
	ld de, wBGPals1 palette PAL_BG_TEXT
	ld bc, 1 palettes
	ld a, BANK(wBGPals1)
	jmp FarCopyWRAM

Palette_TextBG7:
INCLUDE "gfx/font/bg_text.pal"

INCLUDE "engine/tilesets/tileset_palettes.asm"

_LoadTradeRoomBGPals:
	ld hl, TradeRoomPalette
	ld de, wBGPals1 palette PAL_BG_GREEN
	ld bc, 6 palettes
	ld a, BANK(wBGPals1)
	call FarCopyWRAM
	farjp ApplyPals

TradeRoomPalette:
INCLUDE "gfx/trade/border.pal"
