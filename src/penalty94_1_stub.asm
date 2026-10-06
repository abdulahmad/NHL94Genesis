	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	penalty94_1 segment stub. Retail $011F2C-$012C03.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$11F2C

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $011F2C-$012C03, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
DoDMA_clearCallbackPointer = $11738	;bsr.w / Bcc.w at $120D6. middle94_2 (IDA sub_11738)
DoFill = $11544			;bsr.w / Bcc.w at $12BFA. middle94_1
Framer = $119B8			;bsr.w / Bcc.w at $127E2. middle94_2
NewTicker = $13378		;bsr.w / Bcc.w at $120DA
NewTicker3pt2 = $133B2		;bsr.w / Bcc.w at $120DE. 93 NewTicker3
PenaltyList = $18E0C		;#x at $11FB0
PrintScores1 = $12C04		;bsr.w / Bcc.w at $12B8A. penalty94_2 (93 printscores1)
PushTime = $11CA2		;bsr.w / Bcc.w at $12B02. middle94_2
RefsMap = $5C408			;#x at $12708
Rinktiles = $56062		;#x at $12B54
Setplass = $15A88		;bsr.w / Bcc.w at $12A1A
SprSort = $1702E			;bsr.w / Bcc.w at $12B66
appendz = $11D96			;bsr.w / Bcc.w at $12B16. middle94_2
appstring = $11D9E		;bsr.w / Bcc.w at $12B28. middle94_2
assinsert = $10658		;bsr.w / Bcc.w at $120F0. logic94_5
assreplace = $10662		;bsr.w / Bcc.w at $1237A. logic94_5
dobitmap = $1169A		;bsr.w / Bcc.w at $12BDC. middle94_2
eraser = $1197E			;jsr / jmp (x).l at $12058. middle94_2
forceblack = $10F32		;bsr.w / Bcc.w at $120C0. middle94_1
getGoalieSCnum = $B86A		;jsr / jmp (x).l at $121A4. logic94_1
icerinkmap = $BC064		;#x at $12BC6
loc_1889A = $1889A		;bsr.w / Bcc.w at $12656. 93 DisplayPlayerAttributeMenu
print = $11BA4			;bsr.w / Bcc.w at $12634. middle94_2
printz = $11B92			;bsr.w / Bcc.w at $12036. middle94_2
priolist = $19286		;#x at $12A00
rtss2 = $15464			;bsr.w / Bcc.w at $11F32. an rts
setplayer = $15AA4		;bsr.w / Bcc.w at $12A1E
sfx = $11132			;bsr.w / Bcc.w at $12572. middle94_1
song = $11156			;middle94_1 (bsr.w at $11F96; a fixed value because the .song local also matches the name)
sub_12D70 = $12D70		;bsr.w / Bcc.w at $12B3C. 93 EASNLogo
sub_12DA6 = $12DA6		;bsr.w / Bcc.w at $12386. 93 USBoard
sub_14A94 = $14A94		;bsr.w / Bcc.w at $1229E. 93 GetPeriodTimeRemaining
sub_1850A = $1850A		;bsr.w / Bcc.w at $12608. 93 DisplayPeriodOver
sub_187B8 = $187B8		;jsr / jmp (x).l at $12066
sub_18A6E = $18A6E		;bsr.w / Bcc.w at $12628. 93 GetPlayerName
sub_1A304 = $1A304		;jsr / jmp (x).l at $12568
sub_FC5AE = $FC5AE		;jsr / jmp (x).l at $1266E
sub_FEA52 = $FEA52		;jsr / jmp (x).l at $12B60
unk_1913A = $1913A		;#x at $1213A. penalty shot penalty per penalty number
unk_5CF64 = $5CF64		;#x at $12718. 93 RefMap2
unk_5CF6C = $5CF6C		;#x at $120D0. 93 RefMap2+8
unk_BC05C = $BC05C		;#x at $12BBC. no IDA label (hidden in the SetHor string). 93 IceRinkMap; icerinkmap is +8
updatePPTeamTime = $FE14C	;jsr / jmp (x).l at $128DA

; Main segment code
	include	penalty94_1.asm
