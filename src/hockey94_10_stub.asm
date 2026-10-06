	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	hockey94_10 segment stub. Retail $018380-$018CFB.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$18380

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $018380-$018CFB, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
Framer = $119B8			;bsr.w / Bcc.w at $18548
GetPeriodTime = $784E		;jsr (x).w at $18624. hockey94_01 (IDA ClockLength)
GetShifter = $1828A		;bsr.w / Bcc.w at $18398
PenaltyList = $18E0C		;#x at $18838
Rinktilelist = $5605A		;#x at $1856A
WritePassBits = $18192		;bsr.w / Bcc.w at $18480
appendz = $11D96			;bsr.w / Bcc.w at $18AAE
appstring = $11D9E		;bsr.w / Bcc.w at $18AB8
dobitmap = $1169A		;bsr.w / Bcc.w at $18586
eraser = $1197E			;bsr.w / Bcc.w at $18A6A
lcfound2 = $BB36			;jsr / jmp (x).l at $188B2
loc_FC320 = $FC320		;jsr / jmp (x).l at $187C8
prefmes = $1277A			;jsr / jmp (x).l at $187D6
print = $11BA4			;bsr.w / Bcc.w at $185AE
printbig = $11DF4		;bsr.w / Bcc.w at $187F2
printbigz = $11DE2		;bsr.w / Bcc.w at $18C00
printz = $11B92			;bsr.w / Bcc.w at $1853A
randomd0 = $11086		;jsr / jmp (x).l at $1845E
rtss2 = $15464			;bsr.w / Bcc.w at $1841C
song = $11156			;jsr / jmp (x).l at $185D4
sub_9F40 = $9F40			;jsr / jmp (x).l at $1868C
sub_F9FC0 = $F9FC0		;jsr / jmp (x).l at $188F2
sub_FE510 = $FE510		;jsr / jmp (x).l at $18966
sub_FEAE4 = $FEAE4		;jsr / jmp (x).l at $189DC
sub_FEAFA = $FEAFA		;jsr / jmp (x).l at $189A0

; Main segment code
	include	hockey94_10.asm
