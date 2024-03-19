DefaultOptions:
; wOptions: fast text speed and  Battle Set toggled
	db TEXT_DELAY_FAST
; wSaveFileExists: no
	db FALSE
; wTextboxFrame: frame 1
	db FRAME_1
; wTextboxFlags: use text speed
	db 1 << FAST_TEXT_DELAY_F
; wOptions2: menu account on
	db 1 << MENU_ACCOUNT
; FollowersEnabled
	db 1	

	db $00
	db $00
.End
	assert DefaultOptions.End - DefaultOptions == wOptionsEnd - wOptions
