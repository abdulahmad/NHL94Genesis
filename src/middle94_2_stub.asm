	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	middle94_2 segment stub. Retail $01169A-$011F2B.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$1169A

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $01169A-$011F2B, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
DoDMApro = $113D0		;bsr.w / Bcc.w at $1175E
Vmaddr = $11680			;bsr.w / Bcc.w at $11974
framermap = $55B7E		;#x at $119D2
remap = $10EE0			;bsr.w / Bcc.w at $11766
rtss2 = $15464			;dc.l at $11AF4 (ControlCodeJumpTable entry 0; the rts at $15464)
sub_13508 = $13508		;bsr.w / Bcc.w at $11C7E
unk_1916A = $1916A		;#x at $11E92
unk_55B86 = $55B86		;#x at $11F12
unk_A9A10 = $A9A10		;#x at $11EAA
unk_AAC52 = $AAC52		;#x at $11AAE
unk_AAC5A = $AAC5A		;#x at $11F08
unk_ABA1C = $ABA1C		;#x at $11F22
unk_BE26A = $BE26A		;#x at $11ABE

; Main segment code
	include	middle94_2.asm
