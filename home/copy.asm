_CopyBytes::
; copy bc bytes from hl to de
	inc b ; we bail the moment b hits 0, so include the last run

	srl c
	jr nc, .skip1
	ld a, [hli]
	ld [de], a
	inc de

.skip1
	srl c
	jr nc, .skip2
rept 2
	ld a, [hli]
	ld [de], a
	inc de
endr

.skip2
	jr z, .next
.loop
rept 4
	ld a, [hli]
	ld [de], a
	inc de
endr

	dec c
	jr nz, .loop

.next
	dec b
	ret z

	ld c, $40
	jr .loop

_ByteFill::
; fill bc bytes with the value of a, starting at hl
	inc b ; we bail the moment b hits 0, so include the last run
	inc c ; same thing; include last byte
	jr .HandleLoop
.PutByte:
	ld [hli], a
.HandleLoop:
	dec c
	jr nz, .PutByte
	dec b
	jr nz, .PutByte
	ret

GetFarByte::
; retrieve a single byte from a:hl, and return it in a.
	; bankswitch to new bank
	ldh [hTempBank], a
	ldh a, [hROMBank]
	push af
	ldh a, [hTempBank]
	rst Bankswitch

	; get byte from new bank
	ld a, [hl]
	ldh [hFarByte], a

	; bankswitch to previous bank
	pop af
	rst Bankswitch

	; return retrieved value in a
	ldh a, [hFarByte]
	ret

GetFarWord::
; retrieve a word from a:hl, and return it in hl.
	; bankswitch to new bank
	ldh [hTempBank], a
	ldh a, [hROMBank]
	push af
	ldh a, [hTempBank]
	rst Bankswitch

	; get word from new bank, put it in hl
	ld a, [hli]
	ld h, [hl]
	ld l, a

	; bankswitch to previous bank and return
	pop af
	rst Bankswitch
	ret

FarCopyColorWRAM::
	ld a, BANK("GBC Video")
FarCopyWRAM::
	ldh [hTempBank], a
	ldh a, [rSVBK]
	push af
	ldh a, [hTempBank]
	ldh [rSVBK], a

	rst CopyBytes

	pop af
	ldh [rSVBK], a
	ret

GetFarWRAMByte::
	ldh [hTempBank], a
	ldh a, [rSVBK]
	push af
	ldh a, [hTempBank]
	ldh [rSVBK], a
	ld a, [hl]
	ldh [hFarByte], a
	pop af
	ldh [rSVBK], a
	ldh a, [hFarByte]
	ret
