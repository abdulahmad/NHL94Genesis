	include	segacd\hockey.inc
	include	macros\genesis.mac

BA_Goalie_SCnum	equ	$1936A
BA_Team	equ	$19366
CC_Font1Pri	equ	$BF
EnterNameTxt	equ	$26C30
FormatPlayerNumInitial	equ	$41192
Framer	equ	$38CA0
GoalRecTitles	equ	$272F4
LetterGrid	equ	$26DD0
LogArrowsClrTxt	equ	$26D4A
LogArrowsTxt	equ	$26D42
NameEntryScreen	equ	$26348
NameLogBytes	equ	$80
OptUserRec	equ	$18C06
ReadSRAM	equ	$22452
SaveRecTitles	equ	$27346
SelectNameTxt	equ	$26C48
SortCords	equ	$17480
TeamRecBase	equ	$D20
TempBuffer	equ	$17E70
TempWord1	equ	$17E62
ThreeStars	equ	$BC000
WinRecTitles	equ	$272A2
awayuser	equ	$18BF6
awtmstruct	equ	$186B2
cont1team	equ	$17FA6
cont2team	equ	$17FA8
cursoron	equ	$1A566
eraser	equ	$38C06
homeuser	equ	$18BF4
move	equ	$2C9C8
nameentryvis	equ	$1A390
namelength	equ	$1A38A
namelog	equ	$1A2FC
namelogarrows	equ	$1A38E
namelogsel	equ	$1A38C
print	equ	$38F80
printbigz	equ	$39258
printm	equ	$18D5E
printsmall	equ	$38D9E
printx	equ	$18D58
printy	equ	$18D5A
printz	equ	$38F6E
recsort1	equ	$1A3D4
recsort2	equ	$1A3DC
sflags6	equ	$17F76
swap	equ	$2779A
tmstruct	equ	$1834C
wingames	equ	$1A404
winpcts	equ	$1A3EC
winsort	equ	$1A3E4
winties	equ	$1A3F4
X_BBD4	equ	$BBD4
X_BCF6	equ	$BCF6

	org	$B98E

	move.w	(sp),(printx).l
	addi.w	#$1,(printy).l
	jsr	(printz).l
	String	'A to go back.'
	dc.w	$33D7,$0001,$8D58,$0679,$0001,$0001,$8D5A,$4EB9
	dc.w	$0003,$8F6E,$000E,$4220,$746F,$2063,$616E,$6365
	dc.w	$6C2E,$33DF,$0001,$8D58,$0679,$0001,$0001,$8D5A
	dc.w	$4EB9,$0003,$8F6E,$0012,$5354,$4152,$5420,$7768
	dc.w	$656E,$2064,$6F6E,$652E,$4CDF,$7FFF,$4E75,$227C
	dc.w	$0001,$A37C,$6100,$0406,$33FC,$0000,$0001,$8D58
	dc.w	$33FC,$000F,$0001,$8D5A,$303C,$0028,$323C,$000D
	dc.w	$343C,$07FF,$4EB9,$0003,$8C06,$4EB9,$0003,$8F6E
	dc.w	$0006,$FE01,$1400,$7016,$7207,$4EB9,$0003,$8CA0
	dc.w	$6100,$0006,$6000,$FFB2,$48E7,$FFFE,$4EB9,$0003
	dc.w	$8F6E,$001A,$BF02,$1544,$2D50,$6164,$2075,$702F
	dc.w	$646F,$776E,$2074,$6F20,$2020,$2000,$4EB9,$0003
	dc.w	$8F6E,$001A,$BF02,$166D,$6F76,$6520,$6172,$726F
	dc.w	$7773,$2E20,$2020,$2020,$2020,$2000,$33FC,$0002
	dc.w	$0001,$8D58,$3F39,$0001,$8D58,$0679,$0001,$0001
	dc.w	$8D5A,$4EB9,$0003,$8F6E,$0016,$5072,$6573,$7320
	dc.w	$5354,$4152,$5420,$746F,$2020,$2020,$2020
	addi.w	#$1,(printy).l
	move.w	(sp),(printx).l
	jsr	(printz).l
	String	'select name.        '
	dc.w	$0679,$0001,$0001,$8D5A,$33DF,$0001,$8D58,$4EB9
	dc.w	$0003,$8F6E,$0016,$5072,$6573,$7320,$4220,$746F
	dc.w	$2065,$6469,$742E,$2020,$2020,$4CDF,$7FFF,$4E75
PrintNamePrompt						;Name entry: "Enter new name:" for an empty name log slot namelogsel, else
									;"Select or replace:"
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(namelogsel).l,d0
	mulu.w	#$C,d0		;12 bytes per name
	movea.l	#namelog,a0
	movea.l	#EnterNameTxt,a1
	tst.b	(a0,d0.w)		;empty slot: "Enter new name:"
	beq.w	.0
	movea.l	#SelectNameTxt,a1
.0	jsr	(print).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SyncLetterCursor						;Name entry: the letter grid cursor d5 = the grid index of the current
									;letter (FindLetter), 0 when it is not in the grid
	movem.l	d0-d4/a0-a6,-(sp)
	move.b	$1A37C.l,d0		;first letter of the name
	bsr.w	FindLetter		;d0 = its grid index
	cmpi.w	#$1E,d0		;not in the grid: cursor on the first letter
	blt.w	.0
	clr.w	d5
	bra.w	.x
.0	move.w	d0,d5
	movea.l	#LetterGrid,a0
	move.b	(a0,d5.w),$1A37C.l		;unknown letters are turned into the first grid letter
.x	movem.l	(sp)+,d0-d4/a0-a6
	rts
FindLetter						;d0 = index of letter d0 in LetterGrid, $1E when not found
	movem.l	d1-d3/a0-a6,-(sp)
	movea.l	#LetterGrid,a0
	move.b	d0,d1
	clr.w	d0
	move.w	#$1E,d3		;31 tries
.loop	cmp.b	(a0,d0.w),d1
	beq.w	.x
	addi.w	#$1,d0
	dbra	d3,.loop
	move.w	#$1E,d0		;not found
.x	movem.l	(sp)+,d1-d3/a0-a6
	rts
	dc.w	$4EB9,$0003,$8F6E,$0006,$BF04,$1300,$D979,$0001
	dc.w	$8D58,$4A79,$0001,$A566,$6700,$000E,$4EB9,$0003
	dc.w	$8F6E,$0006,$203C,$2000,$4E75
PrintCurLetter						;Name entry: print grid letter d5 (with the cursor on, cursoron)
	tst.w	(cursoron).l		;cursor on?
	beq.w	X_BBD4
	movea.l	#ThreeStars,a1
	move.w	#$4,(a1)		;String of 1 letter (length 4)
	move.b	#$0,$3(a1)
	movea.l	#LetterGrid,a0
	move.b	(a0,d5.w),d0		;the letter
	move.b	d0,$2(a1)
	jmp	(print).l
	dc.w	$4EB9,$0003,$8F6E,$0006,$BF18,$1000
	move.w	d5,d0
	ext.l	d0
	divu.w	#$6,d0
	asl.w	#$1,d0
	add.w	d0,(printy).l
	swap	d0
	asl.w	#$1,d0
	add.w	d0,(printx).l
	moveq	#$3,d0
	moveq	#$3,d1
	rts
	dc.w	$0018,$BF02,$1020,$2045,$6E74,$6572,$206E,$6577
	dc.w	$206E,$616D,$653A,$2000,$0018,$BF02,$1053,$656C
	dc.w	$6563,$7420,$6F72,$2072,$6570,$6C61,$6365,$3A00
	dc.w	$48E7,$FFFE,$3F39,$0001,$A38A,$3F39,$0001,$A38C
	dc.w	$4EB9,$0003,$8F6E,$0006,$BF05,$0800
	move.w	#$6,d7
	move.w	#$1,(namelogsel).l
	movea.l	#TempBuffer,a1
.lBC8E	bsr.w	GetLogName
	move.w	(printx).l,-(sp)
	bsr.w	PrintNameField
	move.w	(sp)+,(printx).l
	addi.w	#$1,(printy).l
	addi.w	#$1,(namelogsel).l
	dbra	d7,.lBC8E
	move.w	(sp)+,(namelogsel).l
	move.w	(sp)+,(namelength).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
MoveLogArrows						;Name entry: when the name log selection namelogsel changed, erase the old
									;] [ arrows and print them at the new row (PrintLogArrows)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(namelogsel).l,d0
	cmp.w	(namelogarrows).l,d0		;arrows already there?
	beq.w	.x		;same row: nothing to do
	movea.l	#LogArrowsClrTxt,a1
	bsr.w	X_BCF6		;erase the old ones
	movea.l	#LogArrowsTxt,a1
	bsr.w	X_BCF6		;print the new ones
.x	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$4A79,$0001,$A38E,$6700,$0038,$4EB9,$0003,$8F6E
	dc.w	$0006,$BF03,$0800
	move.w	(namelogarrows).l,d0
	subi.w	#$1,d0
	add.w	d0,(printy).l
	move.l	a1,-(sp)
	jsr	(print).l
	movea.l	(sp)+,a1
	adda.w	(a1),a1
	move.w	#$12,(printx).l
	jsr	(print).l
	move.w	(namelogsel).l,(namelogarrows).l
	rts
	dc.w	$0004,$5D00,$0004,$5B00,$0004,$2000,$0004,$2000
GetNameLength						;namelength = length of the name being entered
									;(up to '-' or 0, at most 12)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$B,d3		;at most 12 characters
	movea.l	#$1A37C,a0
	clr.w	(namelength).l
.loop	cmpi.b	#$2D,(a0)		;a '-' ends the name
	beq.w	.lBD80
	tst.b	(a0)+		;so does a 0
	beq.w	.lBD80
	addi.w	#$1,(namelength).l
	dbra	d3,.loop
.lBD80	movem.l	(sp)+,d0-d7/a0-a6
	rts
PrintNameField						;Name entry: print the 12 character name field from a1, '-' past the
									;length namelength
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#ThreeStars,a0
	move.w	(namelength).l,d0		;(d0 unused)
	move.w	#$0,d3		;character index
	move.w	#$E,(a0)+		;String of 12 characters
.loop	move.b	(a1,d3.w),d1		;the character
	cmp.w	(namelength).l,d3		;past the name?
	blt.w	.0		;inside the name: print it
	move.b	#$2D,d1
.0	move.b	d1,(a0)+
	addi.w	#$1,d3		;next character
	cmpi.w	#$C,d3		;12 characters
	blt.w	.loop
	movea.l	#ThreeStars,a1
	jsr	(print).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$4142
	dc.w	$4344
	dc.w	$4546
	dc.w	$4748
	dc.w	$494A
	dc.w	$4B4C
	dc.w	$4D4E
	dc.w	$4F50
	dc.w	$5152,$5354,$5556,$5758,$595A,$2E31,$3220,$2D00
	dc.w	$3F39,$0001,$8D4E,$33F9,$0001,$A3D2,$0001,$8D4E
	dc.w	$4EB9,$0003,$8CA0,$33DF,$0001,$8D4E,$4E75
GetLogName						;Copy name log entry namelogsel to a1 ('-' for
									;empty), namelength = its length
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#namelog,a0
	move.w	(namelogsel).l,d2
	mulu.w	#$C,d2		;12 bytes per name
	move.w	#$0,(namelength).l
	move.w	#$B,d3		;12 characters
.loop	move.b	(a0,d2.w),d0
	beq.w	.0		;0 = unused character
	bra.w	.1		;a letter: copy it
.0	move.b	#$2D,d0
	subi.w	#$1,(namelength).l
.1	move.b	d0,(a1)+
	addi.w	#$1,(namelength).l
	addi.w	#$1,d2		;next character
	dbra	d3,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$48E7,$FFFE,$207C,$0001,$A2FC,$3039,$0001,$A38C
	dc.w	$C0FC,$000C,$D0C0,$227C,$0001,$A37C,$383C,$000B
	dc.w	$0C11,$002D,$6600,$0006,$12BC,$0000,$1219,$B218
	dc.w	$6600,$000A,$51CC,$FFEA,$6000,$003C,$207C,$0001
	dc.w	$A2FC,$3039,$0001,$A38C,$C0FC,$000C,$D0C0,$227C
	dc.w	$0001,$A37C,$383C,$000B,$1219,$0C01,$002D,$6600
	dc.w	$0006,$123C,$0000,$10C1,$51CC,$FFEE,$6100,$B756
	dc.w	$4EB9,$0002,$6F06,$2A7C,$0001,$8BF4,$4A79,$0001
	dc.w	$A390,$6700,$0008,$2A7C,$0001,$8BF6,$4A39,$0001
	dc.w	$A37C,$6600,$0008,$4279,$0001,$A38C,$3AB9,$0001
	dc.w	$A38C,$4CDF,$7FFF,$4E75,$48E7,$FFFE,$3E3C,$02D7
	dc.w	$203C,$0000,$0000,$223C,$0000,$0004,$207C,$000B
	dc.w	$C000,$3C39,$0001,$A38C,$4245,$4EB9,$0002,$2452
	dc.w	$BC28,$0001,$6600,$0008,$4228,$0001,$50C5,$BC28
	dc.w	$0003,$6600,$0008,$4228,$0003,$50C5,$4A45,$6700
	dc.w	$0008,$4EB9,$0002,$246C,$0680,$0000,$0004,$51CF
	dc.w	$FFC8,$3E3C,$001B,$203C,$0000,$0B60,$223C,$0000
	dc.w	$0010,$207C,$000B,$C000,$3C39,$0001,$A38C,$4245
	dc.w	$4EB9,$0002,$2452,$BC28,$0001,$6600,$0008,$4228
	dc.w	$0001,$50C5,$BC28,$0003,$6600,$0008,$4228,$0003
	dc.w	$50C5,$BC28,$0005,$6600,$0008,$4228,$0005,$50C5
	dc.w	$BC28,$0007,$6600,$0008,$4228,$0007,$50C5,$BC28
	dc.w	$0009,$6600,$0008,$4228,$0009,$50C5,$BC28,$000B
	dc.w	$6600,$0008,$4228,$000B,$50C5,$4A45,$6700,$0008
	dc.w	$4EB9,$0002,$246C,$0680,$0000,$0010,$51CF,$FF90
	dc.w	$203C,$0000,$0D20,$3639,$0001,$A38C,$E943,$48C3
	dc.w	$D083,$223C,$0000,$0010,$207C,$000B,$C000,$4EB9
	dc.w	$0002,$2452,$2F08,$363C,$000F,$4218,$51CB,$FFFC
	dc.w	$205F,$4EB9,$0002,$246C,$4CDF,$7FFF,$4E75
UserNameEntry						;With user records on (OptUserRec 0): the name entry (NameEntryScreen) for
									;the pads in use. Called from Opening2
	tst.w	(OptUserRec).l
	bne.w	.x		;user records off: no name entry
	clr.w	(homeuser).l		;no home user yet
	clr.w	(awayuser).l		;no away user yet
	tst.w	(cont1team).l		;controller 1 on a team: enter its name
	beq.w	.0
	move.w	(cont1team).l,(nameentryvis).l
	subi.w	#$1,(nameentryvis).l		;nameentryvis = 0 home, 1 visitors
	jsr	(NameEntryScreen).l
.0	tst.w	(cont2team).l
	beq.w	.x		;controller 2 not on a team
	movem.w	d0,-(sp)
	move.w	(cont1team).l,d0
	cmp.w	(cont2team).l,d0		;same as controller 2?
	movem.w	(sp)+,d0
	beq.w	.x		;both pads on the same team: one name only
	move.w	(cont2team).l,(nameentryvis).l
	subi.w	#$1,(nameentryvis).l
	jsr	(NameEntryScreen).l
.x	rts
SkipOtherUserName						;Name entry: step the selection namelogsel past the name the other pad
									;picked (homeuser / awayuser), in the direction on the stack
	movem.w	d0,-(sp)		;d0 = the step direction (passed on the stack)
	move.w	(awayuser).l,d0		;the other side's user
	tst.w	(nameentryvis).l		;which side?
	beq.w	.0
	move.w	(homeuser).l,d0		;visitors: the home user
.0	cmp.w	(namelogsel).l,d0
	bne.w	.x		;not his slot: keep it
	move.w	#$1,d0		;his slot: step past it (+1, or -1 when the stack word is negative)
	tst.w	(sp)
	bpl.w	.1
	move.w	#$FFFF,d0
.1	add.w	d0,(namelogsel).l
	clr.w	d0		;d0 = 0 tells the caller to check the slot again
.x	movem.w	(sp)+,d0
	rts
	dc.w	$303C,$0000,$323C,$001A,$4EB9,$0002,$E728,$4EB9
	dc.w	$0003,$8F6E,$0006,$BE01,$0100,$2079,$0004,$7D80
	dc.w	$2248,$2448,$D1DA,$D3DA,$4241,$4240,$7406,$363C
	dc.w	$0006,$7A08,$4EB9,$0003,$87E2,$4EB9,$0003,$8F6E
	dc.w	$0006,$BE21,$0100,$2079,$0004,$7D84,$2248,$2448
	dc.w	$D1DA,$D3DA,$4241,$4240,$7406,$363C,$0006,$7A00
	dc.w	$4EB9,$0003,$87E2,$4EB9,$0003,$8F6E,$0006,$BD0B
	dc.w	$0100
	move.w	#$12,d0
	move.w	#$7,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	dc.w	$0018
	dc.b	$BD,$0E,$02,$52,$65,$63,$6F,$72,$64,$BD,$0D,$05,$48,$6F,$6C,$64,$65,$72,$73,$BD,$01,$09
	dc.w	$4EB9,$0003,$8D8C,$0010,$F806,$0305,$08F9,$014E
	dc.w	$616D,$65F9,$0000,$6100,$B498,$4279,$0001,$7E62
	dc.w	$08B9,$0006,$0001,$7F76,$6100,$0612,$08F9,$0006
	dc.w	$0001,$7F76,$6100,$0606,$6100,$0500,$6100,$00B6
	dc.w	$6100,$01D8,$4EB9,$0002,$C63A,$4EB9,$0002,$F2F0
	dc.w	$4EB9,$0003,$74BE,$0803,$0007,$6700,$0008,$4EF9
	dc.w	$0002,$E980,$4A79,$0001,$7E62,$6600,$0022,$0803
	dc.w	$0006,$6700,$001A,$0803,$0005,$6700,$0012,$6100
	dc.w	$3406,$6100,$04B6,$6100,$0192,$6000,$FFB8,$0801
	dc.w	$0003,$6700,$0026,$0C79,$0002,$0001,$7E62,$6700
	dc.w	$FFA4,$6100,$028E,$0679,$0001,$0001,$7E62,$6100
	dc.w	$0044,$6100,$0032,$6000,$FF8C,$0801,$0002,$6700
	dc.w	$FF84,$4A79,$0001,$7E62,$6700,$FF7A,$6100,$0264
	dc.w	$0479,$0001,$0001,$7E62,$6100,$001A,$6100,$0008
	dc.w	$6000,$FF62,$4E75,$4A79,$0001,$7E62,$6700,$012C
	dc.w	$6000,$028A
PrintRecordTitles						;Record Holders: the record titles (WinRecTitles, GoalRecTitles,
									;SaveRecTitles)
	movea.l	#WinRecTitles,a1
	tst.w	(TempWord1).l		;page 0: the win titles
	beq.w	.0
	movea.l	#SaveRecTitles,a1
	cmpi.w	#$2,(TempWord1).l
	beq.w	.0		;page 2: the saves titles
	movea.l	#GoalRecTitles,a1
.0	jsr	(printsmall).l		;print them
	rts
	dc.w	$0052,$F806,$0310,$08F9,$0120,$2020,$5769,$6E20
	dc.w	$2520,$2020,$5769,$6E2D,$4C6F,$7373,$2D54,$6965
	dc.w	$FD04,$FC19,$5573,$6520,$412B,$4320,$746F,$2063
	dc.w	$6C65,$6172,$2041,$4C4C,$2077,$696E,$2072,$6563
	dc.w	$6F72,$6473,$FD10,$FC1A,$2020,$4D6F,$7265,$205D
	dc.w	$F900,$0052,$F806,$0312,$08F9,$0147,$6F61,$6C73
	dc.w	$2020,$2020,$2020,$2020,$2054,$6561,$6D73,$2020
	dc.w	$2020,$FD04,$FC19,$2020,$2020,$5445,$414D,$204D
	dc.w	$5553,$5420,$5749,$4E20,$544F,$2051,$5541,$4C49
	dc.w	$4659,$2020,$2020,$FD10,$FC1A,$5B20,$4D6F,$7265
	dc.w	$205D,$F900,$0052,$F806,$0312,$08F9,$0153,$6176
	dc.w	$6573,$2020,$2020,$2020,$2020,$2054,$6561,$6D73
	dc.w	$2020,$2020,$FD04,$FC19,$2020,$2020,$5445,$414D
	dc.w	$204D,$5553,$5420,$5749,$4E20,$544F,$2051,$5541
	dc.w	$4C49,$4659,$2020,$2020,$FD10,$FC1A,$5B20,$4D6F
	dc.w	$7265,$2020,$F900,$48E7,$FFFE,$4EB9,$0003,$8D8C
	dc.w	$000A,$F804,$0202,$0AF9,$0000,$3E3C,$0006,$207C
	dc.w	$0001,$A3E4,$247C,$0001,$A3EC,$2A7C,$000B,$C000
	dc.w	$33FC,$0002,$0001,$8D58,$1018,$4880,$1A32,$0000
	dc.w	$E940,$1835,$000A,$E14C,$1835,$000B,$3F04,$1835
	dc.w	$000C,$E14C,$1835,$000D,$33C4,$0001,$7E9A,$1835
	dc.w	$0008,$E14C,$1835,$0009,$33C4,$0001,$7E9E,$D879
	dc.w	$0001,$7E9A,$9857,$4444,$33C4,$0001,$7E9C,$381F
	dc.w	$4A44,$6700,$007C,$6100,$024C,$33FC,$0013,$0001
	dc.w	$8D58,$3F00,$3005,$323C,$0003,$4EB9,$0003,$919A
	dc.w	$4EB9,$0003,$8D9E,$33FC,$001A,$0001,$8D58,$3039
	dc.w	$0001,$7E9E,$323C,$0004,$4EB9,$0003,$919A,$4EB9
	dc.w	$0003,$8D9E,$33FC,$001F,$0001,$8D58,$3039,$0001
	dc.w	$7E9C,$323C,$0004,$4EB9,$0003,$919A,$4EB9,$0003
	dc.w	$8D9E,$33FC,$0024,$0001,$8D58,$3039,$0001,$7E9A
	dc.w	$323C,$0003,$4EB9,$0003,$919A,$301F,$6000,$0008
	dc.w	$227C,$0002,$7630,$4EB9,$0003,$8D9E,$0679,$0002
	dc.w	$0001,$8D5A,$51CF,$FF1A,$4CDF,$7FFF,$4E75,$48E7
	dc.w	$FFFE,$3F39,$0001,$8D58,$3F39,$0001,$8D5A,$3F39
	dc.w	$0001,$8D5E,$4EB9,$0003,$8D8C,$0008,$F804,$0200
	dc.w	$0A00
	move.w	#$28,d0
	move.w	#$12,d1
	jsr	(eraser).l
	move.w	(sp)+,(printm).l
	move.w	(sp)+,(printy).l
	move.w	(sp)+,(printx).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$48E7,$FFFE,$4EB9,$0003,$8D8C,$000A,$F804,$0202
	dc.w	$0AF9,$0000,$3E3C,$0006,$207C,$0001,$A3D4,$0C79
	dc.w	$0001,$0001,$7E62,$6700,$0008,$207C,$0001,$A3DC
	dc.w	$247C,$000B,$C000,$33FC,$0002,$0001,$8D58,$1018
	dc.w	$4880,$E940,$1A32,$0000,$0C79,$0001,$0001,$7E62
	dc.w	$6700,$0006,$1A32,$0004,$4A05,$6700,$00BC,$6100
	dc.w	$010C,$33FC,$0012,$0001,$8D58,$3F00,$0C79,$0001
	dc.w	$0001,$7E62,$6600,$000A,$1032,$0000,$6000,$0006
	dc.w	$1032,$0004,$0240,$00FF,$323C,$0003,$4EB9,$0003
	dc.w	$919A,$4EB9,$0003,$8D9E,$301F,$33FC,$0019,$0001
	dc.w	$8D58,$227C,$0002,$7658,$267C,$0001,$7EF2,$6100
	dc.w	$E26E,$3F00,$0C79,$0001,$0001,$7E62,$6600,$000A
	dc.w	$1032,$0001,$6000,$0006,$1032,$0005,$0240,$00FF
	dc.w	$227C,$0001,$7EF2,$6100,$EB0E,$227C,$0002,$765E
	dc.w	$267C,$0001,$7EF2,$4EB9,$0003,$9208,$227C,$0001
	dc.w	$7EF2,$301F,$0C79,$0001,$0001,$7E62,$6600,$000A
	dc.w	$1032,$0002,$6000,$0006,$1032,$0006,$0240,$00FF
	dc.w	$6100,$EAD4,$6000,$0008,$227C,$0002,$7630,$4EB9
	dc.w	$0003,$8D9E,$0679,$0002,$0001,$8D5A,$51CF,$FF08
	dc.w	$4CDF,$7FFF,$4E75,$0028,$2020,$2020,$2020,$2020
	dc.w	$2020,$2020,$2020,$2020,$2020,$2020,$2020,$2020
	dc.w	$2020,$2020,$2020,$2020,$2020,$2020,$2020,$0006
	dc.w	$6279,$2000,$0008,$2076,$732E,$2000,$3F07,$4447
	dc.w	$0647,$0007,$0647,$0030,$227C,$0001,$7EF2,$32BC
	dc.w	$0006,$1347,$0002,$137C,$002E,$0003,$137C,$0020
	dc.w	$0004,$137C,$0000,$0005,$4EB9,$0003,$8D9E,$3E1F
	dc.w	$1428,$FFFF,$4882,$227C,$0001,$7EF2,$08B9,$0007
	dc.w	$0001,$7F76,$6100,$E738,$4EF9,$0003,$8D9E
CalcWinPercents						;Record Holders: for the 8 user record blocks at recordbuf, the win %
									;(winpcts), games (wingames) and ties (winties), then sort the rows
									;(winsort)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#ThreeStars,a0
	movea.l	#winpcts,a1
	movea.l	#winties,a6
	movea.l	#wingames,a5
	move.w	#$7,d7		;8 user blocks
.loop	move.b	$8(a0),d0		;wins, big endian
	lsl.w	#$8,d0
	move.b	$9(a0),d0
	move.b	$A(a0),d1		;games, big endian
	lsl.w	#$8,d1
	move.b	$B(a0),d1
	move.w	d1,(a5)+
	tst.w	d1
	bne.w	.0
	clr.w	d0
	bra.w	.1
.0	mulu.w	#$64,d0
	divu.w	d1,d0
.1	move.b	d0,(a1)+
	move.b	$C(a0),(a6)+
	move.b	$D(a0),(a6)+
	adda.w	#$10,a0		;next 16 byte block
	dbra	d7,.loop
	movea.l	#winsort,a1
	move.l	a1,-(sp)
	move.w	#$1,d0		;the sort list starts as users 1-7
	move.w	#$6,d7		;7 users
.loop2	move.b	d0,(a1)+
	addi.w	#$1,d0		;next user
	dbra	d7,.loop2
	movea.l	(sp),a1
	movea.l	#winpcts,a0
	movea.l	#winties,a6
	movea.l	#wingames,a5
.loop3	movea.l	(sp),a1
	move.w	#$5,d7		;6 pairs
	clr.w	d6
.loop4	move.b	(a1)+,d1
	ext.w	d1
	move.b	(a1),d2
	ext.w	d2
	move.b	(a0,d1.w),d0		;this user's %
	move.b	(a0,d2.w),d3		;next user's %
	cmp.b	d3,d0
	bgt.w	.lC7A8
	blt.w	.swap
	movem.l	d1-d3,-(sp)
	add.w	d1,d1
	add.w	d2,d2
	move.w	(a6,d1.w),d0		;this user's ties
	move.w	(a6,d2.w),d3		;next user's ties
	cmp.w	d3,d0
	movem.l	(sp)+,d1-d3
	bgt.w	.lC7A8		;same %: more ties first
	blt.w	.swap
	movem.l	d1-d3,-(sp)
	add.w	d1,d1
	add.w	d2,d2
	move.w	(a5,d1.w),d0		;this user's games
	move.w	(a5,d2.w),d3		;next user's games
	cmp.w	d3,d0
	movem.l	(sp)+,d1-d3
	bge.w	.lC7A8		;same ties: more games first
.swap	move.b	(a1),d0
	move.b	-$1(a1),d1		;previous entry
	move.b	d0,-$1(a1)		;swap them
	move.b	d1,(a1)
	st.b	d6
.lC7A8	dbra	d7,.loop4
	tst.w	d6
	bne.w	.loop3		;repeat until no swap
	movea.l	(sp)+,a1
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ReadTeamRecords						;Record Holders: read the records (ReadSRAM)
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	#TeamRecBase,d0		;first user block
	move.l	#NameLogBytes,d1		;all 8 user blocks
	movea.l	#ThreeStars,a0
	jsr	(ReadSRAM).l
	movea.l	#recsort1,a1		;the goals sort list, or the saves one (bit 6)
	btst	#$6,(sflags6).l
	beq.w	.0
	movea.l	#recsort2,a1
.0	move.l	a1,-(sp)
	move.w	#$1,d0		;start with users 1-7
	move.w	#$6,d7		;7 users
.loop	move.b	d0,(a1)+
	addi.w	#$1,d0		;next user
	dbra	d7,.loop
	movea.l	(sp),a1
	movea.l	#ThreeStars,a0
.loop2	movea.l	(sp),a1
	move.w	#$5,d7		;6 pairs
	clr.w	d6
.loop3	move.b	(a1)+,d1
	ext.w	d1
	move.b	(a1),d2
	ext.w	d2
	asl.w	#$4,d1		;16 bytes per user record
	asl.w	#$4,d2
	move.b	(a0,d1.w),d0		;urgoals: goals record
	move.b	(a0,d2.w),d3		;next user's
	btst	#$6,(sflags6).l		;bit 6: sort by saves instead
	beq.w	.1
	move.b	$4(a0,d1.w),d0
	move.b	$4(a0,d2.w),d3
.1	cmp.b	d3,d0
	bge.w	.lC84E
	move.b	(a1),d0
	move.b	-$1(a1),d1		;previous entry
	move.b	d0,-$1(a1)		;swap them
	move.b	d1,(a1)
	st.b	d6
.lC84E	dbra	d7,.loop3
	tst.w	d6		;any swap?
	bne.w	.loop2		;repeat until no swap
	movea.l	(sp)+,a1
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$48E7,$FFFE,$303C,$FFFF,$4EB9,$0003,$9D96,$4EB9
	dc.w	$0003,$8F6E,$0006,$BF03,$0200,$701B,$720C,$4EB9
	dc.w	$0003,$8CA0,$43FA,$013E,$4EB9,$0003,$926A,$3039
	dc.w	$0001,$936C,$247C,$0001,$834C,$4A79,$0001,$9366
	dc.w	$6700,$0008,$247C,$0001,$86B2,$4EB9,$0004,$1192
	dc.w	$3F39,$0001,$8D58,$4EB9,$0003,$8F80,$33DF,$0001
	dc.w	$8D58,$0679,$0001,$0001,$8D5A,$0679,$0006,$0001
	dc.w	$8D58,$4EB9,$0003,$8F6E,$000A,$2076,$732E,$BF04
	dc.w	$0700
	move.w	(BA_Goalie_SCnum).l,d0
	asl.w	#$7,d0
	movea.l	#SortCords,a2
	adda.w	d0,a2
	clr.w	d0
	move.b	$66(a2),d0
	movea.l	#awtmstruct,a2
	tst.w	(BA_Team).l
	beq.w	.lC90E
	movea.l	#tmstruct,a2
.lC90E	jsr	(FormatPlayerNumInitial).l
	jsr	(print).l
	jsr	(printz).l
	String	CC_Font1Pri,$4,$9
