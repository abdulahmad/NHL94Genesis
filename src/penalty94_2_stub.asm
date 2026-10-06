	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	penalty94_2 segment stub. Retail $012C04-$0138AB.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$12C04

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $012C04-$0138AB, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
AllSndOff = $1A264		;jsr / jmp (x).l at $13656. 93 p_turnoff
ClrHor = $12B40			;bsr.w / Bcc.w at $13660. penalty94_1
DoDMA_clearCallbackPointer = $11738	;bsr.w / Bcc.w at $1311A. middle94_2 (IDA sub_11738)
DoGameFrame = $794E		;jsr (x).w at $136F0. hockey94_01
Framer = $119B8			;bsr.w / Bcc.w at $12C30
GetShifter = $1828A		;bsr.w / Bcc.w at $1315C
KillCrowd = $169D0		;jsr / jmp (x).l at $13740
PushNumber = $11D06		;bsr.w / Bcc.w at $12D5A
PushNumberWidth = $11D3A		;bsr.w / Bcc.w at $12D28. middle94_2 (IDA DeterStrLength?)
PushTime = $11CA2		;bsr.w / Bcc.w at $12E54
ResetBench = $15A24		;bsr.w / Bcc.w at $13056
SetHor = $12B94			;bsr.w / Bcc.w at $13778. penalty94_1
SetPersonel = $15788		;bsr.w / Bcc.w at $13802
SetTeamColors = $1720C		;bsr.w / Bcc.w at $13774. 93 setplayercolors
SetupPauseScreen = $7DCE		;jsr (x).w at $13780. hockey94_01 (IDA sub_7DCE; also movea.l #x at $1314E)
SprSort = $1702E			;bsr.w / Bcc.w at $136DC
WeightedRandomSelect = $10EB4	;bsr.w / Bcc.w at $13334. logic94_5 (IDA sub_10EB4)
clearTeamStats = $17102		;jsr / jmp (x).l at $135D2
d0toascii = $18BDC		;bsr.w / Bcc.w at $12E42. 93 ConverByteToDigits
dobitmap = $1169A		;bsr.w / Bcc.w at $12DA2
eraser = $1197E			;bsr.w / Bcc.w at $134E0
forceblack = $10F32		;bsr.w / Bcc.w at $1375C
forcepldata = $159A8		;bsr.w / Bcc.w at $13806
orjoy = $112BC			;bsr.w / Bcc.w at $13704
print = $11BA4			;bsr.w / Bcc.w at $12CDE
print2 = $11A48			;bsr.w / Bcc.w at $1350C
printbig = $11DF4		;bsr.w / Bcc.w at $12D6C
printz = $11B92			;bsr.w / Bcc.w at $12C22
priolist = $19286		;#x at $12EC4
randomd0 = $11086		;bsr.w / Bcc.w at $13224
resetplstuff = $170B0		;bsr.w / Bcc.w at $136A0
restoreteams = $77F4		;jsr (x).w at $135D8. hockey94_01
rtss2 = $15464			;bsr.w / Bcc.w at $12D76. an rts
setvideo = $15EC0		;bsr.w / Bcc.w at $1377C
song = $11156			;bsr.w / Bcc.w at $13792
sub_16BAC = $16BAC		;bsr.w / Bcc.w at $1365C. 93 setupice_highlight
sub_7E36 = $7E36			;jsr (x).w at $13158. 93 InitMenuState
sub_7E46 = $7E46			;jsr (x).w at $13784. 93 DrawMenuScreen
sub_8078 = $8078			;jsr / jmp (x).l at $12D38. 93 PrintTeamData
sub_F9CDE = $F9CDE		;jsr / jmp (x).l at $130F6
unk_191E4 = $191E4		;#x at $12C48. 93 PerLabels
unk_191F8 = $191F8		;#x at $12C5C. 94 period names
unk_19A00 = $19A00		;#x at $13146. 94 item list (word_FFC2FA bit 0)
unk_19A84 = $19A84		;dc.l in .sslist (93 StartGameText)
unk_19B38 = $19B38		;dc.l in .sslist (93 StartGameTextPO)
unk_19C04 = $19C04		;dc.l in .sslist (93 IntermissionText)
unk_19D60 = $19D60		;dc.l in .sslist (93 ExitGameText)
unk_19E74 = $19E74		;dc.l in .sslist (93 ExitGameTextPO)
unk_5C410 = $5C410		;#x at $1367A. 93 RefsMap+8 (logic94_4 uses this name)
unk_A892A = $A892A		;#x at $13114. 93 ZamSprites+8
unk_AB920 = $AB920		;#x at $12E8E. 93 EnergyBarMap
unk_B3530 = $B3530		;#x at $12D84. 93 EASNmap
waitxsr = $111D0			;bsr.w / Bcc.w at $13178. middle94_1 (93 IntermissionLoop)

; Main segment code
	include	penalty94_2.asm
