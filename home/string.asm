InitName::
; Intended for names, so this function is limited to ten characters.
	ld c, NAME_LENGTH - 1
InitString::
; Init a string of length c.
	push hl
_InitString::
	push bc
.loop
	ld a, [hli]
	cp "@"
	jr z, .blank
	cp " "
	jr nz, .notblank
	dec c
	jr nz, .loop
.blank
	pop bc
	ld l, e
	ld h, d
	pop de
	ld b, 0
	inc c
	rst CopyBytes
	ret

.notblank
	pop bc
	pop hl
	ret
