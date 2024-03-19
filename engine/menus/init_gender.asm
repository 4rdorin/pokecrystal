InitCrystalData:
	xor a
	ld [wPlayerGender], a
	ret

InitGender:
	call InitGenderScreen
	call LoadGenderScreenPal
	call LoadGenderScreenLightBlueTile
	call WaitBGMap2
	call SetDefaultBGPAndOBP
	ld hl, AreYouABoyOrAreYouAGirlText
	call PrintText
	ld hl, .MenuHeader
	call LoadMenuHeader
	call WaitBGMap2
	call VerticalMenu
	call CloseWindow
	ld a, [wMenuCursorY]
	dec a
	ld [wPlayerGender], a
	ld c, 10
	jmp DelayFrames

.MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 6, 4, 12, 9
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR | STATICMENU_WRAP | STATICMENU_DISABLE_B ; flags
	db 2 ; items
	db "Boy@"
	db "Girl@"

AreYouABoyOrAreYouAGirlText:
	text_far _AreYouABoyOrAreYouAGirlText
	text_end

InitGenderScreen:
	ld a, $10
	ld [wMusicFade], a
	ld a, LOW(MUSIC_NONE)
	ld [wMusicFadeID], a
	ld a, HIGH(MUSIC_NONE)
	ld [wMusicFadeID + 1], a
	ld c, 8
	call DelayFrames
	call ClearBGPalettes
	call InitCrystalData
	call LoadFontsExtra
	hlcoord 0, 0
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	ld a, $0
	rst ByteFill
	hlcoord 0, 0, wAttrmap
	ld bc, SCREEN_HEIGHT * SCREEN_WIDTH
	xor a
	rst ByteFill
	ret

LoadGenderScreenPal:
	ld hl, .Palette
	ld de, wBGPals1
	ld bc, 1 palettes
	ld a, BANK(wBGPals1)
	call FarCopyWRAM
	farjp ApplyPals

.Palette:
INCLUDE "gfx/new_game/gender_screen.pal"

LoadGenderScreenLightBlueTile:
	ld de, .LightBlueTile
	ld hl, vTiles2 tile $00
	lb bc, BANK(.LightBlueTile), 1
	jmp Get2bpp

.LightBlueTile:
INCBIN "gfx/new_game/gender_screen.2bpp"