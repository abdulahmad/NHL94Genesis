	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	logic94_3 segment stub. Retail $00D09C-$00E62D.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$D09C

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $00D09C-$00E62D, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
AddPenalty2 = $11F62		;jsr / jmp (x).l at $D408
CompLine = $F790			;bsr.w / Bcc.w at $E254
PrintScores1 = $12C04		;bsr.w / Bcc.w at $E25C
ReadGoaliePulled = $FEFCC	;jsr / jmp (x).l at $E016
SetPersonel = $15788		;bsr.w / Bcc.w at $E258
SetSPA = $1073A			;bsr.w / Bcc.w at $D5BE
assexit = $10646			;bsr.w / Bcc.w at $D3D0
assinsert = $10658		;bsr.w / Bcc.w at $D71A
assnothing = $CBE4		;bsr.w / Bcc.w at $D0AC. logic94_2
assreplace = $10662		;bsr.w / Bcc.w at $D112
check4bench = $C67A		;bsr.w / Bcc.w at $D0B0. logic94_1
checkob = $E62E			;bsr.w / Bcc.w at $E04A. logic94_4, the next byte
dopass = $BC64			;jsr / jmp (x).l at $E2DA. logic94_1
playeracc = $10BC2		;bsr.w / Bcc.w at $DAAE
randomd0 = $11086		;jsr / jmp (x).l at $E2F2
randomd0s = $1107A		;bsr.w / Bcc.w at $D17C
rtss2 = $15464			;bsr.w / Bcc.w at $D476
rtss21 = $CF98			;bsr.w / Bcc.w at $D0A2. logic94_2
sfx = $11132			;bsr.w / Bcc.w at $D572
skateto = $103C8			;bsr.w / Bcc.w at $D1E2
skatetopuck = $105A2		;bsr.w / Bcc.w at $DDC0
sroot = $110BE			;bsr.w / Bcc.w at $D972
stopna = $10E1A			;bsr.w / Bcc.w at $DAB2
sub_12EF6 = $12EF6		;bsr.w / Bcc.w at $E248
sub_FE864 = $FE864		;jsr / jmp (x).l at $E0EE
sub_FE8EC = $FE8EC		;jsr / jmp (x).l at $E0A4
vtoa = $10676			;bsr.w / Bcc.w at $D85C

; Main segment code
	include	logic94_3.asm
