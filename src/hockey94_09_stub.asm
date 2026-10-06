	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	hockey94_09 segment stub. Retail $017C72-$01837F.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$17C72

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $017C72-$01837F, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
playoffseats = $5576		;#x at $17D24
randomd0 = $11086		;bsr.w / Bcc.w at $17D18
rtss2 = $15464			;bsr.w / Bcc.w at $18100
sub_18380 = $18380		;bsr.w / Bcc.w at $18122
sub_FE696 = $FE696		;jsr / jmp (x).l at $18144

; Main segment code
	include	hockey94_09.asm
