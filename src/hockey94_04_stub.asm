	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	hockey94_04 segment stub. Retail $01454A-$0150E3.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$1454A

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $01454A-$0150E3, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
AddPenalty2 = $11F62		;bsr.w / Bcc.w at $14A4C. penalty94_1
ChkShotStat = $12F30		;bsr.w / Bcc.w at $14724. penalty94_2
ChooseSong = $FE556		;jsr / jmp (x).l at $1490A
GetHot = $106E0			;bsr.w / Bcc.w at $14E7C. logic94_5
PenGoalStuff = $1284A		;bsr.w / Bcc.w at $149BE. penalty94_1 (IDA sub_1284A)
PrintScores1 = $12C04		;bsr.w / Bcc.w at $149C8. penalty94_2
SetSPA = $1073A			;bsr.w / Bcc.w at $14A3E. logic94_5
assinsert = $10658		;bsr.w / Bcc.w at $14A84. logic94_5
assreplace = $10662		;bsr.w / Bcc.w at $14A30. logic94_5
freezewindow = $AFB6		;jsr / jmp (x).l at $14852. hockey94_02
puckbody = $153CA		;bsr.w / Bcc.w at $14F1E. hockey94_05
puckflip = $102D2		;bsr.w / Bcc.w at $14778. logic94_5
puckgoalie = $15466		;bsr.w / Bcc.w at $150BA. hockey94_05
puckstick = $150E4		;bsr.w / Bcc.w at $14EC8. hockey94_05
randomd0 = $11086		;bsr.w / Bcc.w at $1474E. middle94_1
randomd0s = $1107A		;bsr.w / Bcc.w at $14764. middle94_1
rtss2 = $15464			;bsr.w / Bcc.w at $145F2. an rts
sfx = $11132			;bsr.w / Bcc.w at $14746. middle94_1
sroot = $110BE			;bsr.w / Bcc.w at $145D0. middle94_1
sub_1A304 = $1A304		;bsr.w / Bcc.w at $14838
sub_F37C = $F37C			;jsr / jmp (x).l at $14814. logic94_4
sub_FEFF0 = $FEFF0		;jsr / jmp (x).l at $14A7E

; Main segment code
	include	hockey94_04.asm
