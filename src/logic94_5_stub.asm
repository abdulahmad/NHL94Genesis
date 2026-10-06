	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	logic94_5 segment stub. Retail $00FFEA-$010EDF.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$FFEA

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $00FFEA-$010EDF, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
AddPenalty = $11F2C		;bsr.w / Bcc.w at $10136
Hotlist = $A44C8			;#x at $106F4
Sweepcheck = $C0AE		;bsr.w / Bcc.w at $1063A
getpde = $1575A			;bsr.w / Bcc.w at $10C6E
randomd0 = $11086		;bsr.w / Bcc.w at $10ECA
rtss2 = $15464			;bsr.w / Bcc.w at $FFF0
setpde = $1577A			;bsr.w / Bcc.w at $10D48
stopna2 = $F6F8C			;jsr / jmp (x).l at $10A2A
sub_DB68 = $DB68			;bsr.w / Bcc.w at $109AC

; Main segment code
	include	logic94_5.asm
