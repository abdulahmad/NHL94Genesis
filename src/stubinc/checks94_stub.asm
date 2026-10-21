;	Segment build for checks94.asm: sets its origin and the outside routines and data it uses,
;	then includes checks94.asm on its own for checking against the ROM.

	include	macros\genesis.mac		;String

; .region code
	org	$D09C

; includes for stubs to replace removed code
	include	stubinc\ports.inc		;IO_* / VDP_* ports
	include	stubinc\equals.inc		;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement.
AddPenalty2 = $11F62				;jsr / jmp (x).l
printscores1 = $12C04				;bsr.w / Bcc.w
ReadGoaliePulled = $FEFCC			;jsr / jmp (x).l
setpersonel = $15788				;bsr.w / Bcc.w
donothing = $CBE4					;bsr.w / Bcc.w.
check4bench = $C67A					;bsr.w / Bcc.w.
dopass = $BC64						;jsr / jmp (x).l.
randomd0 = $11086					;jsr / jmp (x).l
randomd0s = $1107A					;bsr.w / Bcc.w
rtss2 = $15464						;bsr.w / Bcc.w
rtss21 = $CF98						;bsr.w / Bcc.w.
sfx = $11132						;bsr.w / Bcc.w
Sroot = $110BE						;bsr.w / Bcc.w
AvgCline = $12EF6					;bsr.w / Bcc.w
SkatePath = $FE864					;jsr / jmp (x).l
ShootoutShootCheck = $FE8EC			;jsr / jmp (x).l

Acheck = $BBD4						;bsr.w / Bcc.w
ChooseSong = $FE556					;jsr / jmp (x).l
ClrHor = $12B40						;bsr.w / Bcc.w
FaceOffMap = $55BF6					;#x
linelist = $191A6					;#x
Framer = $119B8						;bsr.w / Bcc.w
PeriodOver = $17236					;bsr.w / Bcc.w
PushRef = $126F8					;bsr.w / Bcc.w
ResetBench = $15A24					;bsr.w / Bcc.w
SetLCmode = $B8F2					;bsr.w / Bcc.w
SetShotMode = $C1B8					;bsr.w / Bcc.w
ShotMode = $C224					;bsr.w / Bcc.w
SprSort = $1702E					;bsr.w / Bcc.w
Stop4Pen = $124A6					;bsr.w / Bcc.w
burst = $BB62						;bsr.w / Bcc.w
changeplayer = $BFBC				;bsr.w / Bcc.w
checkpuckcoll = $14D8C				;bsr.w / Bcc.w
checkwindow = $AFCA					;bsr.w / Bcc.w
clockcont_0 = $7B5C					;bsr.w / Bcc.w.
dobitmap = $1169A					;bsr.w / Bcc.w
eraser = $1197E						;bsr.w / Bcc.w
forceblack = $10F32					;bsr.w / Bcc.w
forcepldata = $159A8				;bsr.w / Bcc.w
freezewindow = $AFB6				;jsr / jmp (x).l
getlinee = $12EB4					;bsr.w / Bcc.w
lcfound = $BB06						;bsr.w / Bcc.w
printz = $11B92						;bsr.w / Bcc.w
printsmallz = $11A36				;bsr.w / Bcc.w
resetplstuff = $170B0				;jsr / jmp (x).l
setc1player = $C0BC					;jsr / jmp (x).l
setc2player = $C0DA					;jsr / jmp (x).l
setplayer = $15AA4					;jsr / jmp (x).l
song = $11156						;bsr.w / Bcc.w
DecompressGraphicsPlain = $11738	;jsr / jmp (x).l
Fprintsmall = $13508				;bsr.w / Bcc.w
SetupPenaltyShot = $1592C			;bsr.w / Bcc.w
SetLCmode2 = $B92E					;bsr.w / Bcc.w
PuckOnAttackHalf = $F6C44			;jsr / jmp (x).l
NextShooter = $FC4C0				;jsr / jmp (x).l
CountShootoutGoals = $FC516			;jsr / jmp (x).l
StartArenaAnim = $FE510				;jsr / jmp (x).l
SetFaceoffAnim = $FE53C				;jsr / jmp (x).l
EndArenaAnim = $FE548				;jsr / jmp (x).l
StartShootoutPath = $FE756			;jsr / jmp (x).l
RandomFaceoffAnim = $FECAA			;jsr / jmp (x).l
CheckScoreLeader = $FECF8			;jsr / jmp (x).l
LeadSong = $FF7E2					;jsr / jmp (x).l
RefsMap = $5C408					;#x
FaceOffSprites = $A78AE				;#x

AddPenalty = $11F2C					;bsr.w / Bcc.w
HotList = $A44C8					;#x
Sweepcheck = $C0AE					;bsr.w / Bcc.w
getpde = $1575A						;bsr.w / Bcc.w
setpde = $1577A						;bsr.w / Bcc.w
stopna2 = $F6F8C					;jsr / jmp (x).l

; frames94 equates (the segment does not include frames94.asm; it emits bytes)
SPFslamtop	=	708
SPFslambot	=	712
SPFpuck	=	394
SPAgready	=	$2
SPAgdive	=	$2F4
SPAgglovel	=	$178
SPAgglovel2	=	$1AA
SPAgglover	=	$146
SPAgstackr	=	$250
SPAgstackl	=	$2A2
SPAgstickr	=	$1EC
SPAgstickl	=	$21E
SPAghighr	=	$148E
SPAghighl	=	$14C0
SPAgstick2r	=	$14F2
SPAgstick2l	=	$1544
SPAgslamtop	=	$1596
SPAgslambot	=	$1684
SPAglide	=	$50C
SPApflip	=	$46A
SPAglideback	=	$A60
SPAturnl	=	$662
SPAturnr	=	$694
SPAgskate	=	$3D8
SPAskateback	=	$A92
SPAskate	=	$5D0
SPAstumble	=	$11E6
SPAskatewp	=	$53E
SPAstop	=	$6C6

; Main segment code
	include	checks94.asm
