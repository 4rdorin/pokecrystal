; rst vectors (called through the rst instruction)

SECTION "rst0", ROM0[$0000]
	di
	jp Start

SECTION "rst8", ROM0[$0008]
FarCall::
	jmp RstFarCall

PopAFBCDEHL::
	pop af
PopBCDEHL::
	pop bc
	pop de
	pop hl
DoNothing::
	ret

SECTION "rst10", ROM0[$0010]
Bankswitch::
	ldh [hROMBank], a
	ld [MBC3RomBank], a
	ret

SECTION "rst18", ROM0[$0018]

AddNTimes::
	jmp _AddNTimes

SECTION "rst20", ROM0[$0020]
CopyBytes::
	jmp _CopyBytes

SECTION "rst28", ROM0[$0028]

ByteFill::
	jmp _ByteFill

SECTION "rst30", ROM0[$0030]

PlaceString::
	jmp _PlaceString

SwapHLDE::
	push de
	ld d, h
	ld e, l
	pop hl
	ret

SECTION "rst38", ROM0[$0038]
GetScriptByte::
	jmp _GetScriptByte

; Game Boy hardware interrupts

SECTION "vblank", ROM0[$0040]
	jp VBlank

SECTION "lcd", ROM0[$0048]
	jr hLCDInterruptFunction

SECTION "timer", ROM0[$0050]
	reti

SECTION "serial", ROM0[$0058]
	jp Serial

SECTION "joypad", ROM0[$0060]
	jp Joypad


SECTION "Header", ROM0[$0100]

Start::
; Nintendo requires all Game Boy ROMs to begin with a nop ($00) and a jp ($C3)
; to the starting address.
	nop
	jp _Start

; The Game Boy cartridge header data is patched over by rgbfix.
; This makes sure it doesn't get used for anything else.

	ds $0150 - @, $00

ENDSECTION