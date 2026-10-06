	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	video94_2 segment stub. Retail $0162FE-$0169F9.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$162FE

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $0162FE-$0169F9, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
Spritetiles = $5DE84		;addi.l #x at $1686A (0682 + long)
jdtab = $113C0			;#x at $16574. middle94_1
off_5DE7A = $5DE7A		;#x at $167CE. sprite frame list
print = $11BA4			;jsr / jmp (x).l at $1638E. middle94_2
printz = $11B92			;jsr / jmp (x).l at $16314. middle94_2
rtss2 = $15464			;bsr.w / Bcc.w at $163C4. hockey94_05 (an rts)
sizetab = $1920C			;#x at $16820
unk_AAC52 = $AAC52		;#x at $163E0. 93 smallfontmap

; Main segment code
	include	video94_2.asm
