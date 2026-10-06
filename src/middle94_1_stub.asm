	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	middle94_1 segment stub. Retail $010EE0-$011699.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$10EE0

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $010EE0-$011699, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
dmaram = $FFFFD06A		;ram_addrs.inc spells it dmaram? (IDA name; the ? is stripped here)
loc_15E4C = $15E4C		;#x at $10F96. vblank handler
p_initfx = $1A294		;jsr / jmp (x).l at $11144
rtss2 = $15464			;bsr.w / Bcc.w at $10FBA
setvideo = $15EC0		;bsr.w / Bcc.w at $11290
sub_7E88 = $7E88			;jsr (x).w at $1127A (93 HandleMenuInput)
sub_FE2C8 = $FE2C8		;jsr / jmp (x).l at $111EE
updatecrowdf = $7A9E		;jsr (x).w at $111EA (hockey94_01)

; Main segment code
	include	middle94_1.asm
