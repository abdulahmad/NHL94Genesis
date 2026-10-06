	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	hockey94_05 segment stub. Retail $0150E4-$015D99.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$150E4

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $0150E4-$015D99, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
AttributeCalc = $F70E4		;jsr / jmp (x).l at $15BC6
ChkShotStat = $12F30		;bsr.w / Bcc.w at $15308. penalty94_2
FallDown = $14062		;bsr.w / Bcc.w at $15448. hockey94_03
GetHot = $106E0			;bsr.w / Bcc.w at $15410. logic94_5
GetPeriodTime = $784E		;jsr (x).w at $15B66. hockey94_01 (IDA ClockLength)
SetSPA = $1073A			;bsr.w / Bcc.w at $1545E. logic94_5
a2touchpuck = $1013E		;bsr.w / Bcc.w at $151D6. logic94_5
assinsert = $10658		;bsr.w / Bcc.w at $159F6. logic94_5
assreplace = $10662		;bsr.w / Bcc.w at $15954. logic94_5
chkpk2 = $E274			;bsr.w / Bcc.w at $15B16. logic94_3
nullsub_2 = $F6E38		;jsr / jmp (x).l at $159D0
onetimershot = $F6CBA		;jsr / jmp (x).l at $1525E
priolist = $19286		;#x at $1583C
puckflip = $102D2		;bsr.w / Bcc.w at $15424. logic94_5
randomd0 = $11086		;bsr.w / Bcc.w at $15172. middle94_1
randomd0s = $1107A		;bsr.w / Bcc.w at $1570C. middle94_1
setc1player = $C0BC		;jsr / jmp (x).l at $153A8. logic94_1
setc2player = $C0DA		;jsr / jmp (x).l at $153B6. logic94_1
sfx = $11132			;bsr.w / Bcc.w at $151D2. middle94_1
song = $11156			;bsr.w / Bcc.w at $152DC. middle94_1
sub_9F9A = $9F9A			;jsr / jmp (x).l at $158DC
sublist = $1921C			;#x at $158BA
vtoa = $10676			;bsr.w / Bcc.w at $15480. logic94_5

; Main segment code
	include	hockey94_05.asm
