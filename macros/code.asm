; Syntactic sugar macros

MACRO lb ; r, hi, lo
	ld \1, ((\2) & $ff) << 8 | ((\3) & $ff)
ENDM

MACRO ln ; r, hi, lo[, hi, lo]
	if _NARG == 3
		ld \1, ((\2) & $f) << 4 | ((\3) & $f)
	else
		lb \1, ((\2) & $f) << 4 | ((\3) & $f), ((\4) & $f) << 4 | ((\5) & $f)
	endc
ENDM

; Design patterns

MACRO jumptable
	ld a, [\2]
	ld e, a
	ld d, 0
	ld hl, \1
	add hl, de
	add hl, de
	jmp IndirectHL
ENDM

MACRO maskbits
; masks just enough bits to cover values 0 to \1 - 1
; \2 is an optional shift amount
; e.g. "maskbits 26" becomes "and %00011111" (since 26 - 1 = %00011001)
; and "maskbits 3, 2" becomes "and %00001100" (since "maskbits 3" becomes %00000011)
; example usage in rejection sampling:
; .loop
; 	call Random
; 	maskbits 26
; 	cp 26
; 	jr nc, .loop
	assert 0 < (\1) && (\1) <= $100, "bitmask must be 8-bit"
	DEF x = 1
	rept 8
		if x + 1 < (\1)
			DEF x = (x << 1) | 1
		endc
	endr
	if _NARG == 2
		and x << (\2)
	else
		and x
	endc
ENDM

MACRO calc_sine_wave
; input: a = a signed 6-bit value
; output: a = d * sin(a * pi/32)
	and %111111
	cp %100000
	jr nc, .negative\@
	call .apply\@
	ld a, h
	ret
.negative\@
	and %011111
	call .apply\@
	ld a, h
	cpl
	inc a
	ret
.apply\@
	ld e, a
	ld a, d
	ld d, 0
if _NARG == 1
	ld hl, \1
else
	ld hl, .sinetable\@
endc
	add hl, de
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, 0
.multiply\@ ; factor amplitude
	srl a
	jr nc, .even\@
	add hl, de
.even\@
	sla e
	rl d
	and a
	jr nz, .multiply\@
	ret
if _NARG == 0
.sinetable\@
	sine_table 32
endc
ENDM

DEF eventflagset   EQUS "flagset wEventFlags,"
DEF eventflagreset EQUS "flagreset wEventFlags,"
DEF eventflagcheck EQUS "flagcheck wEventFlags,"

MACRO flagset
	ld hl, \1 + (\2 >> 3)
	set (\2 & $7), [hl]
ENDM

MACRO flagreset
	ld hl, \1 + (\2 >> 3)
	res (\2 & $7), [hl]
ENDM

MACRO flagcheck
	ld hl, \1 + (\2 >> 3)
	bit (\2 & $7), [hl]
ENDM