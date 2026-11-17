	include	segacd\hockey.inc
	include	macros\genesis.mac

CC_Font1Pri	equ	$BF
ClearGameStats	equ	$29302
FigureJoy	equ	$40318
FourWayPlay	equ	$18BF8
Framer	equ	$38CA0
HomeTeam	equ	$17FAE
LOAD	equ	$1B000
NATxt	equ	$23EB6
Opt1team	equ	$18BFE
Opt2team	equ	$18C00
OptLine	equ	$18C0A
OptNOP	equ	$18BFC
OptPen	equ	$18C08
OptPlayMode	equ	$18BFA
OptUserRec	equ	$18C06
OptionValueOffsets	equ	$23ECC
PrintOptTeamName	equ	$23E20
PrintOptionNames	equ	$24238
ReadNameLog	equ	$2262E
ReadPassBits	equ	$4057C
ReadSetupPads	equ	$24524
ScrollClearTxt	equ	$23E1C
ScrollDownTxt	equ	$23E18
ScrollUpTxt	equ	$23E14
SetupMenuMap	equ	$47D74
Sroot	equ	$3708E
TempBuffer	equ	$17E70
TempWord1	equ	$17E62
TempWord2	equ	$17E64
ValidSRAM	equ	$193BA
VisTeam	equ	$17FB0
awaycoldplayer	equ	$17EB0
awayhotidx	equ	$17EA4
awayhotplayer	equ	$17EAC
awayhotter	equ	$17EA0
awtmstruct	equ	$186B2
demoflag	equ	$18C16
disflags	equ	$18D64
dobitmap	equ	$387E2
goaliemode1	equ	$18C0C
goaliemode2	equ	$18C0E
homecoldplayer	equ	$17EB2
homehotidx	equ	$17EA6
homehotplayer	equ	$17EAE
logoteam	equ	$1938A
move	equ	$2C9C8
palcount	equ	$18D62
passbits	equ	$18C38
print	equ	$38F80
printa	equ	$18D5C
printx	equ	$18D58
printy	equ	$18D5A
printz	equ	$38F6E
randomd0	equ	$37050
randomd0s	equ	$37044
setupfirstline	equ	$19384
setuphome	equ	$1938C
setupmenuchars	equ	$19388
setupprevline	equ	$19386
setupvis	equ	$1938E
sflags6	equ	$17F76
tmstruct	equ	$1834C
wcradiusx	equ	$17CF4
wcradiusy	equ	$17CF6
X_8088	equ	$8088
X_8798	equ	$8798
X_879E	equ	$879E
X_891E	equ	$891E
X_8984	equ	$8984
X_89CA	equ	$89CA
X_8A8C	equ	$8A8C
X_8CB6	equ	$8CB6
X_9348	equ	$9348
X_9660	equ	$9660
X_9720	equ	$9720
X_9962	equ	$9962
X_99C6	equ	$99C6

	org	$7FBE

checkcornercoll						;210 = blue line to the end of the rink, corner radius 64. Corner circles
									;and side walls for object a3 at d2 / d3 (wcradiusx / wcradiusy); a hit
									;goes to wallcollb. Called from wallcollduringcheck.
	bclr	#$4,$64(a3)		;clear the wall collision bit
	move.w	#$88,d4
	sub.w	(wcradiusx).l,d4
	move.w	#$12A,d5		;ywall
	sub.w	(wcradiusy).l,d5
	movem.w	d2-d5,-(sp)
	neg.w	d4		;d4/d5 = the negative edges, moved in by the corner radius
	neg.w	d5
	addi.w	#$40,d4		;radius
	addi.w	#$40,d5		;plus the radius
	cmp.w	d5,d3		;past the top corner start: maybe the top corners
	bgt.w	.ctc
	cmp.w	d4,d2		;left of the corner circle centre: a corner
	blt.w	.circle
	neg.w	d4
	cmp.w	d4,d2		;right of it?
	bgt.w	.circle		;right of the right corner circle: a corner
	bra.w	.exit		;between the corners: no corner hit
.ctc	neg.w	d5
	cmp.w	d5,d3		;below it?
	blt.w	.exit		;not in a corner zone
	cmp.w	d4,d2		;left of the corner?
	blt.w	.circle
	neg.w	d4
	cmp.w	d4,d2		;right of it?
	bgt.w	.circle
	bra.w	.exit		;no corner hit
.circle	sub.w	d4,d2
	sub.w	d5,d3
	move.w	d3,d0
	move.w	d2,d1
	neg.w	d1
	muls.w	d3,d3
	muls.w	d2,d2
	add.l	d2,d3		;dist from dot
	cmpi.l	#$42,d3		;.radius^2 = $1000
	bls.w	.exit		;inside the radius: no corner hit
	exg.l	d0,d3		;r = sqrt(dx^2 + dy^2)
	jsr	(Sroot).l
	exg.l	d0,d3
	ext.l	d0		;cos and sin as 8.8 fractions
	asl.l	#$8,d0		;cos * 256
	divs.w	d3,d0
	ext.l	d1
	asl.l	#$8,d1		;sin * 256
	divs.w	d3,d1
	bsr.w	X_8088		;bounce off the corner
.exit	movem.w	(sp)+,d2-d5
	move.w	$4E(a3),d0
	or.w	$50(a3),d0
	bne.w	.rtss3		;a corner was hit already: done
	move.w	#$100,d0		;now check side walls
	clr.w	d1
	cmp.w	d5,d3		;past the end wall (top)
	bge.w	X_8088
	neg.w	d5		;past the bottom end wall
	neg.w	d0
	cmp.w	d5,d3		;past the bottom?
	ble.w	X_8088
	exg.l	d0,d1		;side walls: normal along X
	cmp.w	d4,d2		;past the right?
	bge.w	X_8088		;past the right side wall
	neg.w	d4
	neg.w	d1
	cmp.w	d4,d2		;past the left side wall
	ble.w	X_8088
.rtss3	rts
	dc.w	$4EF9,$0003,$B6A2,$48E7,$FF00,$323C,$019F
HotColdLoop						;The Create_HotCold_Table loop
	move.w	#$9,d0		;sets RNG limit (-9 - +8)
	jsr	(randomd0s).l
	move.l	a0,-(sp)
	adda.l	#$1A4,a0		;offset to Hot/Cold table
	move.b	d0,(a0,d1.w)		;random value into this slot
	movea.l	(sp)+,a0
	dbra	d1,HotColdLoop
	movem.l	(sp)+,d0-d7
	rts
Clamp0to100						;unused: clamp d3 to 0 ... 100
	tst.w	d3		;below 0?
	bpl.w	.chkmax		;not negative: check the top
	clr.w	d3
	rts
.chkmax	cmpi.w	#$64,d3		;over 100?
	ble.w	.x
	move.w	#$64,d3
.x	rts
AttributeCalc						;Attribute d3 of player a3 * 5 plus his hot / cold value / 3, limited to 0
									;... $1E. Called from setplayer
	movem.l	d0-d2/a1,-(sp)
	move.w	(TempWord2).l,d1		;TempWord2 goes to d1
	movea.l	#tmstruct,a1		;Start of Home Team struct
	btst	#$6,$62(a3)		;Check if home or away
	beq.w	.attribmath		;home team: struct at tmstruct
	adda.l	#$366,a1		;shift to start of Away Team struct
.attribmath	clr.w	d1
	move.b	$66(a3),d1		;move roster offset into d1
	asl.w	#$4,d1		;shifts d1 4 bits left, moving the values over 1 nibble
	adda.l	#$1A4,a1		;a1 points to Hot/Cold Table Start
	move.b	(a1,d1.w),d1		;move data at add. (a1 + d1) into d1
	ext.w	d1		;sign-extend word. Ex: F5 (-5) -> FFF5
	ext.l	d1		;sign-extend long word. Ex: FFF5 -> FFFFFFF5
	divs.w	#$3,d1		;Signed-Div D1 by 3 (FFFFFFF5 / 3, or -5 / 3 = -1r2, or FFFEFFFF Remainder
	move.w	d3,-(sp)		;push d3 onto stack
	asl.w	#$2,d3		;shift left 2 bits (mult. by 4)
	add.w	(sp)+,d3		;Pop off d3 value and add to d3 (attrib X 5)
	add.w	d1,d3		;add d1 (H/C value) to d3
	bmi.w	.LowerLimit		;below 0: clamp to 0
	cmpi.w	#$1E,d3		;check if above upper limit (1E or 30 decimal)
	blt.w	.MaskAttribMathResult
	move.w	#$1E,d3		;if above, set to 1E
	bra.w	.MaskAttribMathResult
.LowerLimit	clr.w	d3		;if below lower limit (0), set to 0
.MaskAttribMathResult	andi.w	#$FF,d3		;pass only lower byte
	movem.l	(sp)+,d0-d2/a1
	rts
NextHomeHotPlayer						;d1 = the next home hot player (homehotidx index into the list at
									;homehotplayer), a1 = tmstruct. Called from UpdateScoutingDisplay (the
									;MATCHUPS text)
	movem.l	d0/a0,-(sp)
	movea.l	#homehotplayer,a0
	move.w	(homehotidx).l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1		;the next entry of the list
	cmpi.w	#$0,(homehotidx).l		;index stays 0 when already 0 or more
	bge.w	.x
	addi.w	#$1,(homehotidx).l
.x	movem.l	(sp)+,d0/a0
	movea.l	#tmstruct,a1
	rts
	movem.l	d0/a0,-(sp)
	movea.l	#awayhotplayer,a0
	move.w	(awayhotidx).l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#$0,(awayhotidx).l
	bge.w	.l8192
	addi.w	#$1,(awayhotidx).l
.l8192	movem.l	(sp)+,d0/a0
	movea.l	#awtmstruct,a1
	rts
	rts
BuildHotColdLists						;Build the hot / cold player lists of both teams (SortHotColdStarters,
									;CopyHottestPlayer, CopyColdestPlayer). Called from ScoutingReport
	clr.w	(awayhotidx).l
	clr.w	(homehotidx).l
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a0
	bsr.w	SortHotColdStarters
	movea.l	#homehotplayer,a0
	bsr.w	CopyHottestPlayer
	movea.l	#homecoldplayer,a0
	bsr.w	CopyColdestPlayer
	movea.l	#awtmstruct,a0
	bsr.w	SortHotColdStarters
	movea.l	#awayhotplayer,a0
	bsr.w	CopyHottestPlayer
	movea.l	#awaycoldplayer,a0
	bsr.w	CopyColdestPlayer
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SortHotColdStarters						;Sum the hot / cold values of the 6 starters of team a0 into TempBuffer
									;(byte pairs: player, sum), then sort them by sum
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	a0,a2
	adda.l	#$1A4,a2		;its hot / cold table
	movea.l	$1E(a0),a0
	adda.w	$6(a0),a0
	movea.l	#TempBuffer,a1
	move.w	#$5,d0		;6 starters
.player	move.b	(a0)+,d1
	subi.b	#$1,d1		;roster slots are 1-based
	move.b	d1,(a1)+
	ext.w	d1
	asl.w	#$4,d1		;16 hot / cold bytes per player
	clr.b	(a1)
	addi.w	#$3,d1		;start at byte 3
	move.w	#$3,d7
.attrib	clr.w	d2
	move.b	(a2,d1.w),d2		;hot / cold byte
	cmpi.b	#$9,d7		;byte 9?
	beq.w	.nextattr		;skip bytes 9 and $D
	cmpi.b	#$D,d7		;byte $D?
	beq.w	.nextattr
	add.b	d2,(a1)
.nextattr	addi.w	#$1,d1
	addi.w	#$1,d7
	cmpi.b	#$10,d7		;past byte $F?
	bne.w	.attrib		;up to byte $F
	tst.b	(a1)+
	dbra	d0,.player
.sort	movea.l	#TempBuffer,a1
	clr.w	d1
	move.w	#$4,d0		;5 compares
.cmp	move.b	$3(a1),d6		;next sum
	cmp.b	$1(a1),d6		;above this one?
	ble.w	.next		;in order: no swap
	st.b	d1		;swapped: d1 set, sort again
	move.w	$2(a1),d2		;swap the pairs
	move.w	$0(a1),$2(a1)
	move.w	d2,$0(a1)
.next	tst.w	(a1)+
	dbra	d0,.cmp
	tst.w	d1
	bne.w	.sort		;repeat until no swap
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	movem.l	d0/a0,-(sp)
	movea.l	#homecoldplayer,a0
	move.w	$17EAA.l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#$0,$17EAA.l
	bge.w	.l82B8
	addi.w	#$1,$17EAA.l
.l82B8	movem.l	(sp)+,d0/a0
	movea.l	#tmstruct,a1
	rts
	movem.l	d0/a0,-(sp)
	movea.l	#awaycoldplayer,a0
	move.w	$17EA8.l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#$0,$17EA8.l
	bge.w	.l82EE
	addi.w	#$1,$17EA8.l
.l82EE	movem.l	(sp)+,d0/a0
	movea.l	#awtmstruct,a1
	rts
	rts
CopyHottestPlayer						;Copy the hottest player of TempBuffer to the list at a0
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	#TempBuffer,a1
	move.w	#$0,d0
.copy	clr.b	(a0)+
	move.b	(a1),d1
	move.b	d1,(a0)+
	tst.w	(a1)+
	dbra	d0,.copy
	movem.l	(sp)+,d0-d1/a0-a1
	rts
CopyColdestPlayer						;Copy the coldest player (TempBuffer+10) to the list at a0
	movem.l	d0/a0-a1,-(sp)
	movea.l	#$17E7A,a1		;the last pair is the coldest
	move.w	#$0,d0
.copy	clr.b	(a0)+
	move.b	(a1),(a0)+
	tst.w	-(a1)
	dbra	d0,.copy
	movem.l	(sp)+,d0/a0-a1
	rts
CompareHotColdTotals						;Compare the teams' hot / cold totals (GetHotColdTotal into TempWord1 /
									;TempWord2): awayhotter = 1 when the away total is
									;higher; d0 = -1, $22 or $23 by the difference (ScoutingReport text
									;"Lately ... has been playing (extremely) well")
	movem.l	d1-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a0
	bsr.w	GetHotColdTotal
	move.w	d1,(TempWord1).l
	movea.l	#awtmstruct,a0
	bsr.w	GetHotColdTotal
	move.w	d1,(TempWord2).l
	move.w	(TempWord1).l,d1
	move.w	(TempWord2).l,d2
	sub.w	d1,d2		;d2 = away total - home total
	move.w	#$0,(awayhotter).l
	tst.w	d2
	bmi.w	.abs		;home hotter: awayhotter stays 0
	move.w	#$1,(awayhotter).l
.abs	tst.w	d2		;negative?
	bpl.w	.level
	neg.w	d2
.level	move.w	#$FFFF,d0
	cmpi.w	#$5E,d2		;small gap?
	blt.w	.x		;small gap: no text
	move.w	#$22,d0		;"Lately" text
	cmpi.w	#$BD,d2		;big gap?
	blt.w	.x		;big gap: "extremely" well
	move.w	#$23,d0		;"extremely" text
.x	movem.l	(sp)+,d1-d7/a0-a6
	rts
GetHotColdTotal						;d1 = the hot / cold total of the starters of
									;team a0 (SortHotColdStarters)
	bsr.w	SortHotColdStarters
	move.w	#$6,d0		;7 sums (starters + the extra slot)
	movea.l	#TempBuffer,a0
	clr.w	d1
.sum	move.b	$1(a0),d2		;sum byte
	ext.w	d2
	add.w	d2,d1
	tst.w	(a0)+
	dbra	d0,.sum
	rts
GameSetUp
	jsr	$2A58C.l
	movea.l	#passbits,a3
	jsr	(ReadPassBits).l
	move.w	$18C22.l,(OptLine).l
	move.w	$18C24.l,(OptPlayMode).l
	bclr	#$1,$17F7A.l
	jsr	(ClearGameStats).l
	jsr	(ReadNameLog).l
	bsr.w	X_9348
	clr.w	(setupfirstline).l
	clr.w	(setupprevline).l
	bsr.w	PrintOptionNames-LOAD
	tst.w	(demoflag).l
	bne.w	.l8440
	moveq	#$1C,d0
	jsr	(randomd0).l
	move.w	d0,(Opt1team).l
	moveq	#$1C,d0
	jsr	(randomd0).l
	move.w	d0,(Opt2team).l
.l8440	st.b	(demoflag).l
	cmpi.w	#$4,(OptPlayMode).l
	bne.w	.l8456
	bra.w	.l8476
.l8456	cmpi.w	#$2,(OptPlayMode).l
	blt.w	.l8466
	bsr.w	X_8798
.l8466	cmpi.w	#$1,(OptPlayMode).l
	bne.w	.l8476
	bsr.w	X_879E
.l8476	clr.w	d7
	clr.w	d0
	bsr.w	MoveMenuFrame
	bsr.w	FixModeOptions
	move.w	(HomeTeam).l,(setuphome).l
	move.w	(HomeTeam).l,(logoteam).l
	bsr.w	X_9962
	move.w	(VisTeam).l,(setupvis).l
	move.w	(VisTeam).l,(logoteam).l
	bsr.w	X_99C6
	move.w	#$18,(palcount).l
	bclr	#$2,(disflags).l
.l84C2	cmpi.w	#$4,(OptPlayMode).l
	bne.w	.l84E6
	move.w	#$1,(OptLine).l
	move.w	#$0,(OptPen).l
	move.w	#$1,(OptUserRec).l
.l84E6	bsr.w	ReadSetupPads-LOAD
	tst.w	d1
	bne.w	.l84F4
	bra.w	X_9660
.l84F4	btst	#$7,d1
	bne.w	X_9720
	btst	#$1,d1
	beq.w	.l85A0
	tst.w	(OptNOP).l
	bne.w	.l851E
	cmpi.w	#$8,d7
	bne.w	.l851E
	move.w	#$4,d0
	bra.w	.l8522
.l851E	move.w	#$2,d0
.l8522	cmpi.w	#$4,(OptPlayMode).l
	beq.w	.l8548
	tst.w	(OptNOP).l
	bne.w	.l8548
	cmpi.w	#$8,d7
	bne.w	.l8548
	move.w	#$6,d0
	bra.w	.l8594
.l8548	cmpi.w	#$6,d7
	bne.w	.l856C
	cmpi.w	#$4,(OptPlayMode).l
	bne.w	.l856C
	tst.w	(OptNOP).l
	bne.w	.l8590
	clr.w	d0
	bra.w	.l8594
.l856C	cmpi.w	#$A,d7
	bne.w	.l8594
	cmpi.w	#$4,(OptPlayMode).l
	bne.w	.l8586
	clr.w	d0
	bra.w	.l8594
.l8586	tst.w	(ValidSRAM).l
	bpl.w	.l8594
.l8590	move.w	#$4,d0
.l8594	bsr.w	MoveMenuFrame
	bsr.w	FixModeOptions
	bra.w	.l84C2
.l85A0	btst	#$0,d1
	beq.w	.l862E
	tst.w	(OptNOP).l
	bne.w	.l85C2
	cmpi.w	#$C,d7
	bne.w	.l85C2
	move.w	#$FFFC,d0
	bra.w	.l85EC
.l85C2	move.w	#$FFFE,d0
	cmpi.w	#$4,(OptPlayMode).l
	beq.w	.l85EC
	tst.w	(OptNOP).l
	bne.w	.l85EC
	cmpi.w	#$E,d7
	bne.w	.l85EC
	move.w	#$FFFA,d0
	bra.w	.l8622
.l85EC	cmpi.w	#$A,d7
	bne.w	.l8600
	cmpi.w	#$4,(OptPlayMode).l
	beq.w	.l861E
.l8600	cmpi.w	#$E,d7
	bne.w	.l8622
	cmpi.w	#$4,(OptPlayMode).l
	beq.w	.l861E
	tst.w	(ValidSRAM).l
	bpl.w	.l8622
.l861E	move.w	#$FFFC,d0
.l8622	bsr.w	MoveMenuFrame
	bsr.w	FixModeOptions
	bra.w	.l84C2
.l862E	moveq	#$1,d2
	btst	#$3,d1
	bne.w	.l8642
	btst	#$2,d1
	beq.w	.l84C2
	moveq	#-1,d2
.l8642	cmpi.w	#$4,(OptPlayMode).l
	beq.w	.l8654
	jsr	(FigureJoy).l
.l8654	move.w	(Opt2team).l,-(sp)
	move.w	(Opt1team).l,-(sp)
	bsr.w	X_8A8C
	move.w	(sp)+,d0
	cmpi.w	#$4,(OptPlayMode).l
	beq.w	.l867C
	tst.w	(OptPlayMode).l
	bne.w	.l8690
.l867C	move.w	(Opt1team).l,(HomeTeam).l
	move.w	(Opt2team).l,(VisTeam).l
.l8690	move.w	(HomeTeam).l,(logoteam).l
	btst	#$6,$19390.l
	beq.w	.l86BE
	movem.w	d0,-(sp)
	move.w	(setuphome).l,d0
	cmp.w	(HomeTeam).l,d0
	movem.w	(sp)+,d0
	beq.w	.l86CC
.l86BE	move.w	(HomeTeam).l,(setuphome).l
	bsr.w	X_9962
.l86CC	btst	#$7,$19390.l
	beq.w	.l86F0
	movem.w	d0,-(sp)
	move.w	(setupvis).l,d0
	cmp.w	(VisTeam).l,d0
	movem.w	(sp)+,d0
	beq.w	.l8712
.l86F0	move.w	(VisTeam).l,(setupvis).l
	move.w	(VisTeam).l,(logoteam).l
	bsr.w	X_99C6
	move.w	(HomeTeam).l,(logoteam).l
.l8712	tst.w	(sp)+
	bra.w	.l878E
	move.w	(sp)+,d0
	cmp.w	(VisTeam).l,d0
	beq.w	.l878E
	move.w	(VisTeam).l,(logoteam).l
	movem.w	d0,-(sp)
	move.w	(VisTeam).l,d0
	cmp.w	(VisTeam).l,d0
	movem.w	(sp)+,d0
	beq.w	.l8754
	move.w	(VisTeam).l,(setupvis).l
	bsr.w	X_99C6
.l8754	movem.w	d0,-(sp)
	move.w	(setuphome).l,d0
	cmp.w	(HomeTeam).l,d0
	movem.w	(sp)+,d0
	beq.w	.l878E
	move.w	(HomeTeam).l,(setuphome).l
	move.w	(HomeTeam).l,(logoteam).l
	bsr.w	X_9962
	move.w	(VisTeam).l,(logoteam).l
.l878E	bsr.w	FixModeOptions
	bra.w	.l84C2
	rts
	dc.w	$4EF9,$0004,$01C4,$4EF9,$0004,$0132
MoveMenuFrame
	move.w	d7,d3
.l87A6	bclr	#$2,$17F74.l
	tst.w	d0
	bpl.w	.l87EA
	move.w	d0,-(sp)
	move.w	d7,d0
	asr.w	#$1,d0
	cmp.w	(setupfirstline).l,d0
	bne.w	.l87E8
	move.w	(setupfirstline).l,(setupprevline).l
	bset	#$2,$17F74.l
	subi.w	#$1,(setupfirstline).l
	bpl.w	.l87E8
	clr.w	(setupfirstline).l
.l87E8	move.w	(sp)+,d0
.l87EA	move.w	d7,(TempWord1).l
	add.w	d0,d7
	bpl.w	.l87F8
	clr.w	d7
.l87F8	tst.w	d0
	bmi.w	.l8860
	move.w	d0,-(sp)
	move.w	d7,d0
	asr.w	#$1,d0
	sub.w	(setupfirstline).l,d0
	cmpi.w	#$5,d0
	bgt.w	.l8816
	bra.w	.l885E
.l8816	move.w	(setupfirstline).l,(setupprevline).l
	bset	#$2,$17F74.l
	addi.w	#$1,(setupfirstline).l
	move.w	d7,d0
	asr.w	#$1,d0
	sub.w	(setupfirstline).l,d0
	cmpi.w	#$5,d0
	ble.w	.l884A
	addi.w	#$1,(setupfirstline).l
.l884A	cmpi.w	#$3,(setupfirstline).l
	ble.w	.l885E
	move.w	#$3,(setupfirstline).l
.l885E	move.w	(sp)+,d0
.l8860	btst	#$2,$17F74.l
	bne.w	.l8876
	move.w	(setupfirstline).l,(setupprevline).l
.l8876	cmpi.w	#$12,d7
	blt.w	.l8880
	sub.w	d0,d7
.l8880	cmpi.w	#$1,(OptPlayMode).l
	bne.w	.l889A
	tst.w	d7
	beq.w	.l889A
	cmpi.w	#$6,d7
	bls.w	.l87A6
.l889A	cmpi.w	#$2,(OptPlayMode).l
	blt.w	.l88BA
	cmpi.w	#$4,(OptPlayMode).l
	beq.w	.l88BA
	cmpi.w	#$6,d7
	beq.w	.l87A6
.l88BA	bsr.w	X_891E
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(setupmenuchars).l,d4
	movea.l	(SetupMenuMap).l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	(printx).l,d0
	subi.w	#$1,d0
	move.w	d1,d3
	move.w	(printy).l,d1
	subi.w	#$E,d1
	moveq	#$17,d2
	moveq	#$0,d5
	bset	#$0,(sflags6).l
	jsr	(dobitmap).l
	bclr	#$0,(sflags6).l
	movem.l	(sp)+,d0-d7/a0-a6
	move.w	d7,d3
	bsr.w	X_8984
	move.w	#$6000,(printa).l
	jmp	(Framer).l
	dc.w	$4EB9,$0003,$8F6E,$0006,$FF10,$0E00,$303C,$0017
	dc.w	$323C,$000D,$4E75
SetFrameRectUnused
	add.w	d3,(printy).l
	move.w	(setupprevline).l,d0
	add.w	d0,d0
	sub.w	d0,(printy).l
	cmpi.w	#$18,(printy).l
	ble.w	.l895C
	move.w	#$18,(printy).l
.l895C	moveq	#$17,d0
	moveq	#$3,d1
	cmpi.w	#$2,(OptPlayMode).l
	blt.w	X_89CA
	cmpi.w	#$4,(OptPlayMode).l
	beq.w	X_89CA
	cmpi.w	#$4,d3
	bne.w	X_89CA
	moveq	#$5,d1
	rts
	dc.w	$4EB9,$0003,$8F6E,$0006,$FF10,$0E00,$D779,$0001
	dc.w	$8D5A,$3039,$0001,$9384,$D040,$9179,$0001,$8D5A
	dc.w	$7017,$7203,$0C79,$0002,$0001,$8BFA,$6D00,$0018
	dc.w	$0C79,$0004,$0001,$8BFA,$6700,$000C,$0C43,$0004
	dc.w	$6600,$0004,$7205,$4E75
FixModeOptions
	movem.l	d0-d7/a0-a6,-(sp)
	cmpi.w	#$4,(OptPlayMode).l
	bne.w	.l89E4
	move.w	#$1,(OptUserRec).l
.l89E4	tst.w	(OptNOP).l
	bne.w	.l89F6
	move.w	#$1,(OptUserRec).l
.l89F6	tst.w	(OptNOP).l
	bne.w	.l8A3A
	move.w	#$0,$18C04.l
	move.w	#$0,(goaliemode1).l
	move.w	#$0,(goaliemode2).l
	tst.w	(OptNOP).l
	bne.w	.l8A3A
	move.w	#$1,$18C04.l
	move.w	#$1,(goaliemode1).l
	move.w	#$1,(goaliemode2).l
.l8A3A	move.w	(setupfirstline).l,d0
	cmp.w	(setupprevline).l,d0
	beq.w	.l8A4E
	bsr.w	PrintOptionNames-LOAD
.l8A4E	bset	#$3,(sflags6).l
	bsr.w	X_8CB6
	bclr	#$3,(sflags6).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$0005,$0008,$001C,$001C,$0003,$0002,$0002,$0003
	dc.w	$0003,$0005,$000C,$001C,$001C,$0003,$0002,$0002
	dc.w	$0003,$0003,$4A47,$6600,$007C,$48A7,$A000,$4A42
	dc.w	$6700,$0038,$3039,$0001,$8BFA,$D042,$6A00,$0006
	dc.w	$303C,$0004,$0C40,$0004,$6600,$0020,$33F9,$0001
	dc.w	$8C06,$0001,$8C10,$33F9,$0001,$8C08,$0001,$8C12
	dc.w	$33F9,$0001,$8C0A,$0001,$8C14,$4C9F,$0005,$4A47
	dc.w	$6600,$0032,$4A42,$6700,$002C,$0C79,$0004,$0001
	dc.w	$8BFA,$6600,$0020,$33F9,$0001,$8C10,$0001,$8C06
	dc.w	$33F9,$0001,$8C12,$0001,$8C08,$33F9,$0001,$8C14
	dc.w	$0001,$8C0A,$247C,$0001,$8BFA,$267C,$0002,$3A68
	dc.w	$4A79,$0001,$8BF8,$6700,$0008,$267C,$0002,$3A7A
	dc.w	$4245,$3833,$7000,$3632,$7000,$0C79,$0002,$0001
	dc.w	$8BFA,$6D00,$0018,$0C79,$0004,$0001,$8BFA,$6700
	dc.w	$000C,$0C47,$0004,$6600,$0004,$781A,$0C47,$0002
	dc.w	$6600,$00A6,$0C79,$0004,$0001,$8BFA,$6600,$005E
	dc.w	$48A7,$2000,$D479,$0001,$8BFC,$6A00,$0006,$0642
	dc.w	$0007,$0C42,$0004,$4C9F,$0004,$6F00,$0018,$4A42
	dc.w	$6A00,$000A,$343C,$0004,$6000,$0032,$0642,$0002
	dc.w	$6000,$002A,$48A7,$2000,$D479,$0001,$8BFC,$0C42
	dc.w	$0003,$4C9F,$0004,$6600,$0014,$4A42,$6A00,$000A
	dc.w	$0442,$0001,$6000,$0006,$0642,$0001,$7A05,$4A79
	dc.w	$0001,$8BF8,$6700,$000A,$383C,$000A,$0645,$0002
	dc.w	$0C79,$0004,$0001,$8BFA,$6700,$000C,$4A79,$0001
	dc.w	$8BFA,$6600,$0006,$4245,$7805,$4A79,$0001,$8BF8
	dc.w	$6700,$0006,$0644,$0002,$6100,$009E,$4A79,$0001
	dc.w	$8BF8,$6700,$0038,$0C47,$0002,$6600,$0030,$4A42
	dc.w	$6B00,$0016,$0C43,$0009,$6700,$001E,$0C43,$000A
	dc.w	$6700,$0016,$6000,$0016,$0C43,$000A,$6600,$000E
	dc.w	$363C,$0008,$6000,$0006,$363C,$000B,$3583,$7000
	dc.w	$4A42,$6700,$FD7E,$0C79,$0001,$0001,$8BFA,$6600
	dc.w	$0020,$4A47,$6600,$001A,$4EB9,$0004,$0132,$3039
	dc.w	$0001,$8A9E,$8079,$0001,$8A9C,$6700,$FF7E,$4E75
	dc.w	$0C79,$0002,$0001,$8BFA,$6D00,$FD48,$0C79,$0004
	dc.w	$0001,$8BFA,$6700,$FD3C,$4A47,$6700,$FB04,$0C47
	dc.w	$0004,$6700,$FAFC,$4E75
WrapOption
	add.w	d2,d3
	cmp.w	d5,d3
	bge.w	.l8CAC
	move.w	d4,d3
	subq.w	#$1,d3
.l8CAC	cmp.w	d4,d3
	blt.w	X_89CA
	move.w	d5,d3
	rts
	dc.w	$3C07,$2E3C,$FFFF,$FFFE,$0647,$0002,$4242,$6100
	dc.w	$FDC6,$48E7,$0100,$E247,$BE79,$0001,$9384,$4CDF
	dc.w	$0080,$6D00,$0006,$6100,$002A,$0C47,$0010,$6600
	dc.w	$FFD8,$6100,$00C4,$3E06,$4EB9,$0003,$FF4C,$0839
	dc.w	$0000,$0001,$9390,$6600,$0008,$4EB9,$0002,$4B5E
	dc.w	$4E75
PrintOptionValue
	jsr	(printz).l
	String	CC_Font1Pri,$11,$10
	move.w	(setupfirstline).l,d0
	add.w	d0,d0
	sub.w	d0,(printy).l
	add.w	d7,(printy).l
	cmpi.w	#$1B,(printy).l
	bgt.w	X_89CA
	subi.w	#$1,(printy).l
	move.w	#$11,(printx).l
	cmpi.w	#$4,d7
	beq.w	PrintOptTeamName-LOAD
	cmpi.w	#$6,d7
	beq.w	PrintOptTeamName-LOAD
	movea.l	#OptPlayMode,a0
	move.w	(a0,d7.w),d3
	movea.l	#OptionValueOffsets,a0
	adda.w	(a0,d7.w),a0
	cmpa.l	#$24104,a0
	bne.w	.l8D8A
	cmpi.w	#$4,(OptPlayMode).l
	bne.w	.l8D8A
	movea.l	#NATxt,a1
	jmp	(print).l
.l8D8A	tst.w	(FourWayPlay).l
	beq.w	.l8DA0
	cmpi.w	#$2,d7
	bne.w	.l8DA0
	adda.w	#$B0,a0
.l8DA0	movea.l	a0,a1
	adda.w	(a0),a0
	dbra	d3,.l8DA0
	jmp	(print).l
PrintScrollMarks
	move.w	#$19,(printy).l
	movea.l	#ScrollClearTxt,a1
	cmpi.w	#$3,(setupfirstline).l
	beq.w	.l8DDA
	cmpi.w	#$4,(OptPlayMode).l
	beq.w	.l8DDA
	movea.l	#ScrollDownTxt,a1
.l8DDA	move.w	#$2,(printx).l
	jsr	(print).l
	movea.l	#ScrollClearTxt,a1
	move.w	#$F,(printy).l
	tst.w	(setupfirstline).l
	beq.w	.l8E06
	movea.l	#ScrollUpTxt,a1
.l8E06	move.w	#$2,(printx).l
	jmp	(print).l
	dc.w	$0004,$7B00,$0004,$7D00,$0004,$2000
