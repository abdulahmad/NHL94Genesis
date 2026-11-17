LoadCrowdRec						;CrowdRecord = the arena record of HomeTeam from save RAM (ReadCrowdRecord
	
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(HomeTeam).l,d1
	ext.l	d1
	movea.l	#ThreeStars,a0
	jsr	(ReadCrowdRecord).l
	move.b	crpeak(a0),d0
	beq.w	.none
	andi.w	#$FF,d0
	bra.w	.ex
.none	move.w	#$50,d0
.ex	move.w	d0,(CrowdRecord).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
Crowd_Noise						;The crowd meter each frame: crowd noise on / off (sflags5 bit 7) from
	
	
	
	btst	#sfhor,(sflags).l
	bne.w	.ex1
	btst	#0,(gmode2).l
	bne.w	.ex1
	btst	#sf3llcs,(sflags3).l
	bne.w	.ex2
	btst	#7,(sflags5).l
	bne.w	.chkoff
	tst.w	(crowdnoisedelay).l
	beq.w	.chkon
	subi.w	#$1,(crowdnoisedelay).l
	bpl.w	.ex1
	clr.w	(crowdnoisedelay).l
.ex2	rts
.chkon	move.w	(CrowdRecord).l,d0
	move.w	d0,(CrowdAvg).l
	subi.w	#$B,(CrowdAvg).l
	subi.w	#$49,d0
	muls.w	d0,d0
	asr.l	#2,d0
	addi.w	#$6,d0
	cmp.w	(CwdExciteLvl).l,d0
	bgt.w	.ex1
	bset	#7,(sflags5).l
	rts
.chkoff	move.w	(CrowdAvg).l,d0
	subi.w	#$41,d0
	muls.w	d0,d0
	asr.l	#2,d0
	cmp.w	(CwdExciteLvl).l,d0
	blt.w	.meter
	bclr	#7,(sflags5).l
.meter	sub.w	d7,(CwdChkCntr).l
	bpl.w	.ex1
	move.w	#$14,(CwdChkCntr).l
	addi.w	#$1,(CwdChkCnt).l
	move.w	(CwdExciteLvl).l,d0
	ext.l	d0
	asl.w	#2,d0
	jsr	(Sroot).l
	addi.w	#$41,d0
	move.w	d0,(CurCrowdMeter).l
	cmp.w	(CrowdPeak).l,d0
	ble.w	.chkrec
	move.w	d0,(CrowdPeak).l
.chkrec	move.w	(CurCrowdMeter).l,d0
	cmp.w	(CrowdRecord).l,d0
	blt.w	.stack
	bra.w	.stack
.stack	movem.l	d0-d7/a0-a6,-(sp)
	movem.l	(sp)+,d0-d7/a0-a6
.ex1	rts
stopna2						;Slow Xvel and Yvel of a3 toward 0 by $7D0. Called from goalieacc
	tst.w	Xvel(a3)
	bpl.w	.xp
	addi.w	#$7D0,Xvel(a3)
	bmi.w	.y
	clr.w	Xvel(a3)
.xp	subi.w	#$7D0,Xvel(a3)
	bpl.w	.y
	clr.w	Xvel(a3)
.y	tst.w	Yvel(a3)
	bpl.w	.yp
	addi.w	#$7D0,Yvel(a3)
	bmi.w	.ex
	clr.w	Yvel(a3)
.yp	subi.w	#$7D0,Yvel(a3)
	bpl.w	.ex
	clr.w	Yvel(a3)
.ex	rts
checkcornercoll						;210 = blue line to the end of the rink, corner radius 64. Corner circles
	
	
	bclr	#pf3wall,pflags3(a3)
	move.w	#Sideline,d4
	sub.w	(wcradiusx).l,d4
	move.w	#$12A,d5
	sub.w	(wcradiusy).l,d5
	movem.w	d2-d5,-(sp)
	neg.w	d4
	neg.w	d5
	addi.w	#$40,d4
	addi.w	#$40,d5
	cmp.w	d5,d3
	bgt.w	.ctc
	cmp.w	d4,d2
	blt.w	.circle
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.circle
	bra.w	.exit
.ctc	neg.w	d5
	cmp.w	d5,d3
	blt.w	.exit
	cmp.w	d4,d2
	blt.w	.circle
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.circle
	bra.w	.exit
.circle	sub.w	d4,d2
	sub.w	d5,d3
	move.w	d3,d0
	move.w	d2,d1
	neg.w	d1
	muls.w	d3,d3
	muls.w	d2,d2
	add.l	d2,d3
	cmpi.l	#$42,d3
	bls.w	.exit
	exg.l	d0,d3
	jsr	(Sroot).l
	exg.l	d0,d3
	ext.l	d0
	asl.l	#8,d0
	divs.w	d3,d0
	ext.l	d1
	asl.l	#8,d1
	divs.w	d3,d1
	bsr.w	.next
.exit	movem.w	(sp)+,d2-d5
	move.w	Wallcos(a3),d0
	or.w	Wallsin(a3),d0
	bne.w	.rtss3
	move.w	#$100,d0
	clr.w	d1
	cmp.w	d5,d3
	bge.w	.next
	neg.w	d5
	neg.w	d0
	cmp.w	d5,d3
	ble.w	.next
	exg.l	d0,d1
	cmp.w	d4,d2
	bge.w	.next
	neg.w	d4
	neg.w	d1
	cmp.w	d4,d2
	ble.w	.next
.rtss3	rts
.next	jmp	(wallcollb).l
Create_HotCold_Table						;Fill the hot / cold table (tmHotCold) of team struct a0: 16 bytes for
	
	
	movem.l	d0-d7,-(sp)
	move.w	#tmPerGoals-tmHotCold-1,d1
HotColdLoop						;The Create_HotCold_Table loop
	move.w	#9,d0
	jsr	(randomd0s).l
	move.l	a0,-(sp)
	adda.l	#$1A4,a0
	move.b	d0,(a0,d1.w)
	movea.l	(sp)+,a0
	dbra	d1,HotColdLoop
	movem.l	(sp)+,d0-d7
	rts
Clamp0to100						;unused: clamp d3 to 0 ... 100
	tst.w	d3
	bpl.w	.chkmax
	clr.w	d3
	rts
.chkmax	cmpi.w	#$64,d3
	ble.w	.x
	move.w	#$64,d3
.x	rts
AttributeCalc						;Attribute d3 of player a3 * 5 plus his hot / cold value / 3, limited to 0
	
	movem.l	d0-d2/a1,-(sp)
	move.w	(TempWord2).l,d1
	movea.l	#tmstruct,a1
	btst	#pfteam,pflags(a3)
	beq.w	.attribmath
	adda.l	#$366,a1
.attribmath	clr.w	d1
	move.b	pnum(a3),d1
	asl.w	#4,d1
	adda.l	#$1A4,a1
	move.b	(a1,d1.w),d1
	ext.w	d1
	ext.l	d1
	divs.w	#3,d1
	move.w	d3,-(sp)
	asl.w	#2,d3
	add.w	(sp)+,d3
	add.w	d1,d3
	bmi.w	.LowerLimit
	cmpi.w	#$1E,d3
	blt.w	.MaskAttribMathResult
	move.w	#$1E,d3
	bra.w	.MaskAttribMathResult
.LowerLimit	clr.w	d3
.MaskAttribMathResult	andi.w	#$FF,d3
	movem.l	(sp)+,d0-d2/a1
	rts
NextHomeHotPlayer						;d1 = the next home hot player (homehotidx index into the list at
	
	
	movem.l	d0/a0,-(sp)
	movea.l	#homehotplayer,a0
	move.w	(homehotidx).l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#0,(homehotidx).l
	bge.w	.x
	addi.w	#$1,(homehotidx).l
.x	movem.l	(sp)+,d0/a0
	movea.l	#tmstruct,a1
	rts
NextAwayHotPlayer						;The same for the away team (awayhotplayer, awayhotidx), a1 = awtmstruct.
	
	movem.l	d0/a0,-(sp)
	movea.l	#awayhotplayer,a0
	move.w	(awayhotidx).l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#0,(awayhotidx).l
	bge.w	.x
	addi.w	#$1,(awayhotidx).l
.x	movem.l	(sp)+,d0/a0
	movea.l	#awtmstruct,a1
	rts
	rts
BuildHotColdLists						;Build the hot / cold player lists of both teams (SortHotColdStarters,
	
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
	
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	a0,a2
	adda.l	#$1A4,a2
	movea.l	tmdata(a0),a0
	adda.w	$6(a0),a0
	movea.l	#TempBuffer,a1
	move.w	#5,d0
.player	move.b	(a0)+,d1
	subi.b	#$1,d1
	move.b	d1,(a1)+
	ext.w	d1
	asl.w	#4,d1
	clr.b	(a1)
	addi.w	#$3,d1
	move.w	#3,d7
.attrib	clr.w	d2
	move.b	(a2,d1.w),d2
	cmpi.b	#$9,d7
	beq.w	.nextattr
	cmpi.b	#$D,d7
	beq.w	.nextattr
	add.b	d2,(a1)
.nextattr	addi.w	#$1,d1
	addi.w	#$1,d7
	cmpi.b	#$10,d7
	bne.w	.attrib
	tst.b	(a1)+
	dbra	d0,.player
.sort	movea.l	#TempBuffer,a1
	clr.w	d1
	move.w	#4,d0
.cmp	move.b	3(a1),d6
	cmp.b	1(a1),d6
	ble.w	.next
	st.b	d1
	move.w	2(a1),d2
	move.w	$0(a1),$2(a1)
	move.w	d2,$0(a1)
.next	tst.w	(a1)+
	dbra	d0,.cmp
	tst.w	d1
	bne.w	.sort
	movem.l	(sp)+,d0-d7/a0-a6
	rts
NextHomeColdPlayer						;d1 = the next home cold player (homecoldidx, homecoldplayer), a1 =
	
	movem.l	d0/a0,-(sp)
	movea.l	#homecoldplayer,a0
	move.w	(homecoldidx).l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#0,(homecoldidx).l
	bge.w	.x
	addi.w	#$1,(homecoldidx).l
.x	movem.l	(sp)+,d0/a0
	movea.l	#tmstruct,a1
	rts
NextAwayColdPlayer						;The same for the away team (awaycoldidx, awaycoldplayer), a1 =
	
	
	movem.l	d0/a0,-(sp)
	movea.l	#awaycoldplayer,a0
	move.w	(awaycoldidx).l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#0,(awaycoldidx).l
	bge.w	.x
	addi.w	#$1,(awaycoldidx).l
.x	movem.l	(sp)+,d0/a0
	movea.l	#awtmstruct,a1
	rts
	rts
CopyHottestPlayer						;Copy the hottest player of TempBuffer to the list at a0
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	#TempBuffer,a1
	move.w	#0,d0
.copy	clr.b	(a0)+
	move.b	(a1),d1
	move.b	d1,(a0)+
	tst.w	(a1)+
	dbra	d0,.copy
	movem.l	(sp)+,d0-d1/a0-a1
	rts
CopyColdestPlayer						;Copy the coldest player (TempBuffer+10) to the list at a0
	movem.l	d0/a0-a1,-(sp)
	movea.l	#$17E7A,a1
	move.w	#0,d0
.copy	clr.b	(a0)+
	move.b	(a1),(a0)+
	tst.w	-(a1)
	dbra	d0,.copy
	movem.l	(sp)+,d0/a0-a1
	rts
	movem.l	d1-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a0
	bsr.w	GetHotColdTotal
	move.w	d1,(TempWord1).l
	movea.l	#awtmstruct,a0
	bsr.w	GetHotColdTotal
	move.w	d1,(TempWord2).l
	move.w	(TempWord1).l,d1
	move.w	(TempWord2).l,d2
	sub.w	d1,d2
	move.w	#$0,(awayhotter).l
	tst.w	d2
	bmi.w	.next
	move.w	#$1,(awayhotter).l
.next	tst.w	d2
	bpl.w	.next2
	neg.w	d2
.next2	move.w	#$FFFF,d0
	cmpi.w	#$5E,d2
	blt.w	.next3
	move.w	#$22,d0
	cmpi.w	#$BD,d2
	blt.w	.next3
	move.w	#$23,d0
.next3	movem.l	(sp)+,d1-d7/a0-a6
	rts
GetHotColdTotal						;d1 = the hot / cold total of the starters of
	
	bsr.w	SortHotColdStarters
	move.w	#6,d0
	movea.l	#TempBuffer,a0
	clr.w	d1
.sum	move.b	1(a0),d2
	ext.w	d2
	add.w	d2,d1
	tst.w	(a0)+
	dbra	d0,.sum
	rts
