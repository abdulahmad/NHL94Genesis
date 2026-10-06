	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	logic94_4 segment stub. Retail $00E62E-$00FFE9.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$E62E

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $00E62E-$00FFE9, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
Acheck = $BBD4			;bsr.w / Bcc.w at $EB64
AddPenalty2 = $11F62		;jsr / jmp (x).l at $F376
BreakawayOffsidesFlagSet = $DE2A	;jsr / jmp (x).l at $E724
ChkOffsides = $FFEA		;bsr.w / Bcc.w at $FF8A
ChooseSong = $FE556		;jsr / jmp (x).l at $ED62
ClrHor = $12B40			;bsr.w / Bcc.w at $EFFA
FaceOffMap = $55BF6		;#x at $FB8E
FaceOffsprites = $191A6		;#x at $FBEE
Framer = $119B8			;bsr.w / Bcc.w at $FBCC
GetHot = $106E0			;bsr.w / Bcc.w at $E88C
PeriodOver = $17236		;bsr.w / Bcc.w at $F476
PrintScores1 = $12C04		;bsr.w / Bcc.w at $F5BA
PushRef = $126F8			;bsr.w / Bcc.w at $E6AA
ReadGoaliePulled = $FEFCC	;jsr / jmp (x).l at $E7D2
ResetBench = $15A24		;bsr.w / Bcc.w at $F07A
SetLCmode = $B8F2		;bsr.w / Bcc.w at $F5D8
SetPersonel = $15788		;bsr.w / Bcc.w at $F082
SetSPA = $1073A			;bsr.w / Bcc.w at $F1F8
SetShotMode = $C1B8		;bsr.w / Bcc.w at $EC96
ShotMode = $C224			;bsr.w / Bcc.w at $ECAA
SprSort = $1702E			;bsr.w / Bcc.w at $F206
Stop4Pen = $124A6		;bsr.w / Bcc.w at $ED32
a2touchpuck = $1013E		;bsr.w / Bcc.w at $FF5A
assexit = $10646			;bsr.w / Bcc.w at $E908
assgoaliecpu = $D51C		;bsr.w / Bcc.w at $E7AE
assinsert = $10658		;bsr.w / Bcc.w at $E7BE
assnothing = $CBE4		;bsr.w / Bcc.w at $E982
assreplace = $10662		;bsr.w / Bcc.w at $E6E4
breakaway = $DDC4		;jsr / jmp (x).l at $E6EC
burst = $BB62			;bsr.w / Bcc.w at $EB72
changeplayer = $BFBC		;bsr.w / Bcc.w at $FD38
checkpuckcoll = $14D8C		;bsr.w / Bcc.w at $FFD6
checkwindow = $AFCA		;bsr.w / Bcc.w at $F06C
chkpk2 = $E274			;bsr.w / Bcc.w at $E938
clockcont_0 = $7B5C		;bsr.w / Bcc.w at $F496. hockey94_01 (IDA loc_7B5C)
dirtab = $10E64			;#x at $FECA
dobitmap = $1169A		;bsr.w / Bcc.w at $FBAC
eraser = $1197E			;bsr.w / Bcc.w at $FE14
findpc = $10346			;bsr.w / Bcc.w at $FF46
forceblack = $10F32		;bsr.w / Bcc.w at $EFA0
forcepldata = $159A8		;bsr.w / Bcc.w at $F9E0
freezewindow = $AFB6		;jsr / jmp (x).l at $F37C
getlinee = $12EB4		;bsr.w / Bcc.w at $F7AA
lcfound = $BB06			;bsr.w / Bcc.w at $F69E
printz = $11B92			;bsr.w / Bcc.w at $FB54
printz2 = $11A36			;bsr.w / Bcc.w at $FBBE
puckIChk = $10246		;bsr.w / Bcc.w at $FF86
puckunflip = $102A8		;bsr.w / Bcc.w at $FFE2
randomd0 = $11086		;bsr.w / Bcc.w at $E94C
resetplstuff = $170B0		;jsr / jmp (x).l at $F096
rtss2 = $15464			;bsr.w / Bcc.w at $E634
setc1player = $C0BC		;jsr / jmp (x).l at $F254
setc2player = $C0DA		;jsr / jmp (x).l at $F266
setplayer = $15AA4		;jsr / jmp (x).l at $F0EC
sfx = $11132			;jsr / jmp (x).l at $E752
skateto = $103C8			;bsr.w / Bcc.w at $EA44
skatetopuck = $105A2		;bsr.w / Bcc.w at $EACA
skatetopuckinit = $10588		;bsr.w / Bcc.w at $E9AE
song = $11156			;bsr.w / Bcc.w at $ED86
sub_11738 = $11738		;jsr / jmp (x).l at $EFCC
sub_13508 = $13508		;bsr.w / Bcc.w at $FBF4
sub_1592C = $1592C		;bsr.w / Bcc.w at $F086
sub_B92E = $B92E			;bsr.w / Bcc.w at $F680
sub_F6C44 = $F6C44		;jsr / jmp (x).l at $EC0E
sub_FC4C0 = $FC4C0		;jsr / jmp (x).l at $ECE2
sub_FC516 = $FC516		;jsr / jmp (x).l at $F3DC
sub_FE510 = $FE510		;jsr / jmp (x).l at $FB4E
sub_FE53C = $FE53C		;jsr / jmp (x).l at $F460
sub_FE548 = $FE548		;jsr / jmp (x).l at $FCE4
sub_FE756 = $FE756		;jsr / jmp (x).l at $ECEC
sub_FECAA = $FECAA		;jsr / jmp (x).l at $F454
sub_FECF8 = $FECF8		;jsr / jmp (x).l at $F43E
sub_FF7E2 = $FF7E2		;jsr / jmp (x).l at $FCA6
unk_55BFE = $55BFE		;#x at $FB1C
unk_5C410 = $5C410		;#x at $EFC6
unk_A78B6 = $A78B6		;#x at $FB2C
vtoa = $10676			;bsr.w / Bcc.w at $EB52

; Main segment code
	include	logic94_4.asm
