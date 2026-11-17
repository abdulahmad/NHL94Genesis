EncodePW						;After a playoff game compute winners and save the bits if needed. Returns
	
	
	
	tst.w	(OptNOP).l
	beq.w	rtss2
	tst.w	$18BFA.l
	beq.w	rtss2
	cmpi.w	#$4,$18BFA.l
	beq.w	rtss2
	move.w	#$1,$18BFA.l
	move.w	#$1,$18C24.l
	bsr.w	ResolveGames
	bsr.w	MakeTree
	cmpi.w	#$4,$18A9E.l
	beq.w	.next
	tst.w	$18A98.l
	bmi.w	.next
	movea.l	#$18C38,a3
	bsr.w	WritePassBits
	jsr	$2A5C8.l
	btst	#$2,$17F6E.l
	beq.w	rtss2
	movea.l	#$18D26,a3
	bsr.w	InitPlayerSlots
	bra.w	MakeTree
.next	movea.l	#$18C38,a3
	bsr.w	ClrPassBits
	jsr	$2A5C8.l
	move.w	#$2,$18BFA.l
	move.w	#$2,$18C24.l
	cmpi.w	#$7,$18A9C.l
	beq.w	rtss2
	move.w	#$3,$18BFA.l
	move.w	#$3,$18C24.l
	rts
WritePassBits						;Transfer the game variables to the bits at a3 (pojoy range 8). Called
	
	bsr.w	ClrPassBits
	move.w	$18A9A.l,d0
	moveq	#$20,d1
	bsr.w	PushBits
	move.w	$18A9C.l,d0
	moveq	#$8,d1
	bsr.w	PushBits
	move.w	$18A9E.l,d0
	moveq	#$4,d1
	bsr.w	PushBits
	move.w	$18AA0.l,d0
	moveq	#$10,d1
	bsr.w	PushBits
	move.w	$18AA2.l,d0
	moveq	#$8,d1
	bsr.w	PushBits
	move.w	$18AA4.l,d0
	move.w	#$4000,d1
	bsr.w	PushBits
	moveq	#$5,d1
	moveq	#$7,d2
	movea.l	#$18A18,a1
.loop	move.w	$4(a1),d0
	bsr.w	PushBits
	move.w	$6(a1),d0
	bsr.w	PushBits
	adda.w	#$10,a1
	dbra	d2,.loop
	rts
PushBits						;bits = bits * d1 + d0. d1 = range 2^1-2^15, d0 = data
	movem.l	d0-d1,-(sp)
	exg.l	d0,d1
	bsr.w	SuperMult
	clr.l	d0
	move.w	d1,d0
	bsr.w	SuperAdd
	movem.l	(sp)+,d0-d1
	rts
ClrPassBits						;Clear the 5 words of bits at a3
	movea.l	a3,a0
	moveq	#$4,d0
.0	clr.w	(a0)+
	dbra	d0,.0
	rts
SuperAdd						;1 long (d0.L) added to the 5 words at a3
	movem.l	d1/a0,-(sp)
	lea.l	$A(a3),a0
	moveq	#$3,d1
	add.l	d0,-(a0)
	bra.w	.2
.1	addi.w	#$1,-(a0)
.2	dbcc	d1,.1
	movem.l	(sp)+,d1/a0
	rts
SuperMult						;1 word (d0) multiplied by the 5 words at a3
	movem.l	d1-d4/a0,-(sp)
	movea.l	a3,a0
	moveq	#$4,d4
.0	move.w	(a0),-(sp)
	clr.w	(a0)+
	dbra	d4,.0
	moveq	#$4,d4
.1	move.w	d0,d1
	mulu.w	(sp)+,d1
	lea.l	$2(a3),a0
	adda.w	d4,a0
	adda.w	d4,a0
	move.w	d4,d2
	add.l	d1,-(a0)
	bra.w	.3
.2	addi.w	#$1,-(a0)
.3	dbcc	d2,.2
	dbra	d4,.1
	movem.l	(sp)+,d1-d4/a0
	rts
SuperDiv						;5 words at a3 divided by 1 word (d0); d0 = remainder on exit
	movem.l	d1-d2/a0,-(sp)
	movea.l	a3,a0
	moveq	#$4,d1
	clr.l	d2
.0	move.w	(a0),d2
	divu.w	d0,d2
	move.w	d2,(a0)+
	dbra	d1,.0
	swap	d2
	move.w	d2,d0
	movem.l	(sp)+,d1-d2/a0
	rts
GetShifter						;Returns d1 = number of games - 1, d2 = first bit of WinBits
	move.l	d0,-(sp)
	moveq	#-16,d2
	moveq	#$10,d1
	move.w	$18A9E.l,d0
.loop	add.w	d1,d2
	lsr.w	#$1,d1
	dbra	d0,.loop
	subi.w	#$1,d1
	move.l	(sp)+,d0
	rts
AddPlayoffTeamStats						;Add the po team's game stats to its packed playoff totals: unpack them
	
	
	
	cmpi.w	#$1,$18BFA.l
	blt.w	rtss2
	bsr.w	ReadTeamStats
	movea.l	#$18AA6,a0
	move.w	$18AA0.l,d2
	move.b	(a0,d2.w),d2
	movea.l	#tmstruct,a2
	cmp.w	$2A(a2),d2
	beq.w	.0
	adda.w	#$366,a2
.0	adda.w	#$B6,a2
	moveq	#$67,d0
	movea.l	#$B000,a1
.loop	clr.w	d1
	move.b	(a2)+,d1
	add.w	d1,(a1)+
	dbra	d0,.loop
	movea.l	#$B000,a0
	movea.l	#$408DC,a1
	movea.l	#$18C42,a2
	moveq	#$67,d0
	clr.w	d4
.loop2	clr.l	d1
	move.w	(a0)+,d1
	move.w	d0,d2
	andi.w	#$3,d2
	move.b	(a1,d2.w),d2
	clr.l	d3
	bset	d2,d3
	subi.w	#$1,d3
	cmp.w	d3,d1
	ble.w	.1
	move.w	d3,d1
.1	not.l	d3
	move.w	d4,d5
	andi.w	#$F,d5
	rol.l	d5,d3
	rol.l	d5,d1
	move.w	d4,d5
	lsr.w	#$4,d5
	add.w	d5,d5
	neg.w	d5
	addi.w	#$100,d5
	and.l	d3,-$22(a2,d5.w)
	or.l	d1,-$22(a2,d5.w)
	add.w	d2,d4
	dbra	d0,.loop2
	rts
AddPlayoffTeamStatsTbl1	dc.w	$0C0E,$0A0A
ReadTeamStats						;Unpack the $68 playoff stat totals from the bit stream into statsbuffer
	
	movea.l	#$B000,a0
	movea.l	#$408DC,a1
	movea.l	#$18C42,a2
	moveq	#$67,d0
	clr.w	d4
.loop	move.w	d4,d5
	lsr.w	#$4,d5
	add.w	d5,d5
	neg.w	d5
	addi.w	#$100,d5
	move.l	-$22(a2,d5.w),d1
	move.w	d4,d5
	andi.w	#$F,d5
	lsr.l	d5,d1
	move.w	d0,d2
	andi.w	#$3,d2
	move.b	(a1,d2.w),d2
	add.w	d2,d4
	clr.w	d3
	bset	d2,d3
	subi.w	#$1,d3
	and.w	d3,d1
	move.w	d1,(a0)+
	dbra	d0,.loop
	rts
ResolveGames						;Compute winners and losers for playoff matchups. Called from EncodePW
	move.w	$18A98.l,d0
	mulu.w	#$10,d0
	movea.l	#$18A18,a0
	move.w	$18358.l,$A(a0,d0.w)
	move.w	$186BE.l,$C(a0,d0.w)
	bsr.w	GetShifter
	movea.l	#$18A18,a0
	moveq	#$10,d3
	mulu.w	d1,d3
	adda.w	d3,a0
	cmpi.w	#$7,$18A9C.l
	beq.w	.notbos
.loop	cmpi.w	#$4,$4(a0)
	beq.w	.b1
	cmpi.w	#$4,$6(a0)
	beq.w	.b1
	clr.w	d3
	btst	#$0,$E(a0)
	beq.w	.0
	eori.w	#$2,d3
.0	move.w	$A(a0),d0
	sub.w	$C(a0),d0
	bpl.w	.win
	eori.w	#$2,d3
.win	addi.w	#$1,$4(a0,d3.w)
.b1	suba.w	#$10,a0
	dbra	d1,.loop
	addi.w	#$1,$18A9C.l
	cmpi.w	#$7,$18A9C.l
	beq.w	.next2
	move.w	$18A98.l,d0
	mulu.w	#$10,d0
	movea.l	#$18A18,a0
	adda.w	d0,a0
	cmpi.w	#$4,$4(a0)
	beq.w	.next
	cmpi.w	#$4,$6(a0)
	bne.w	rtss2
.next	cmpi.w	#$3,$18A9E.l
	bge.w	.next2
	bsr.w	GetShifter
	movea.l	#$18A18,a0
	moveq	#$10,d3
	mulu.w	d1,d3
	adda.w	d3,a0
.loop2	cmp.w	$18A98.l,d1
	beq.w	.crn
	cmpi.w	#$4,$4(a0)
	beq.w	.crn
	cmpi.w	#$4,$6(a0)
	beq.w	.crn
	addi.w	#$1,$4(a0)
	move.l	#$C8,d0
	jsr	(randomd0).l
	andi.w	#$1,d0
	beq.w	.loop2
	subi.w	#$1,$4(a0)
	addi.w	#$1,$6(a0)
	bra.w	.loop2
.crn	suba.w	#$10,a0
	dbra	d1,.loop2
	movea.l	#$18D26,a3
	bsr.w	WritePassBits
	bset	#$2,$17F6E.l
.next2	clr.w	$18A9C.l
	bsr.w	GetShifter
	movea.l	#$18A18,a0
	moveq	#$10,d3
	mulu.w	d1,d3
	adda.w	d3,a0
	clr.w	d3
.loop3	cmpi.w	#$4,$4(a0)
	beq.w	.2
	bset	d1,d3
.2	clr.w	$4(a0)
	clr.w	$6(a0)
	suba.w	#$10,a0
	dbra	d1,.loop3
	moveq	#$1,d1
	asl.w	d2,d1
	subi.w	#$1,d1
	and.w	d1,$18AA4.l
	asl.w	d2,d3
	or.w	d3,$18AA4.l
	addi.w	#$1,$18A9E.l
	rts
.notbos	clr.w	d3
.loop4	move.w	$A(a0),d0
	cmp.w	$C(a0),d0
	bhi.w	.3
	bset	d1,d3
.3	btst	#$0,$E(a0)
	beq.w	.nb2
	bchg	d1,d3
.nb2	suba.w	#$10,a0
	dbra	d1,.loop4
	moveq	#$1,d1
	asl.w	d2,d1
	subi.w	#$1,d1
	and.w	d1,$18AA4.l
	asl.w	d2,d3
	or.w	d3,$18AA4.l
	addi.w	#$1,$18A9E.l
	rts
ShowThreeStars						;End of game Stars of the Game box. Called from UpdatePA while RefPen is
	
	
	
	
	
	cmpi.w	#$40,$1806E.l
	bgt.w	rtss2
	bset	#$7,$17F68.l
	bne.w	rtss2
	movem.l	d0/a1,-(sp)
	bset	#$3,(disflags).l
	move.w	(ScoutSubStatus).l,d0
.loop	cmp.w	(ScoutSubStatus).l,d0
	beq.w	.loop
	movem.l	(sp)+,d0/a1
	movem.l	d0-d5/a0-a4,-(sp)
	jsr	(printz).l
	String	CC_Font1Pri,$2,$E
	moveq	#$1C,d0
	moveq	#$9,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	CC_Font1Pri,$9,$10,'Stars of the Game',CC_Font1Pri,$3,$F
	movea.l	$47D18.l,a1
	movea.l	#$1B008,a2
	adda.l	$4(a1),a1
	moveq	#$D,d0
	moveq	#$5B,d1
	moveq	#$6,d2
	moveq	#$4,d3
	move.w	$18D48.l,d4
	clr.w	d5
	jsr	(dobitmap).l
	bsr.w	CalcStarScores
	move.w	#$12,(printy).l
	moveq	#$2,d2
.loop2	bsr.w	TakeTopStarScore
	move.w	#$1A,(printx).l
	addi.w	#$1,(printy).l
	movea.l	$1E(a2),a1
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	jsr	(print).l
	bsr.w	GetPlayerNameBuild
	move.w	#$3,(printx).l
	jsr	(print).l
	dbra	d2,.loop2
	move.w	$18358.l,d0
	sub.w	$186BE.l,d0
	ble.w	.nosong		;home didn't win
	move.w	#$F,-(sp)		;home team won (sound effect)
	jsr	(sfx).l
.nosong	movem.l	(sp)+,d0-d5/a0-a4
	rts
TakeTopStarScore						;Take the highest of the 52 star scores at ThreeStars and clear it.
	
	
	movem.l	d1-d2/a1/a4,-(sp)
	movea.l	#ThreeStars,a4
	clr.l	d0
	moveq	#$33,d2
.find	cmp.l	(a4)+,d0
	bge.w	.next
	lea.l	-$4(a4),a1
	move.l	(a1),d0
.next	dbra	d2,.find
	clr.l	(a1)
	move.l	a1,d0
	subi.l	#$BC000,d0
	lsr.w	#$2,d0
	movea.l	#tmstruct,a2
	cmpi.w	#$1A,d0
	blt.w	.home
	subi.w	#$1A,d0
	adda.w	#$366,a2
.home	movem.l	(sp)+,d1-d2/a1/a4
	rts
CalcStarScores						;Star score for every roster slot of both teams to ThreeStars (26 longs
	
	
	
	
	movea.l	#ThreeStars,a4
	jsr	(GetPeriodTime).l
	move.w	d0,d5
	add.w	d2,d5
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a3
	bsr.w	CalcTeamStarScores
	movea.l	a3,a2
	lea.l	-$366(a2),a3
	bsr.w	CalcTeamStarScores
	cmpi.w	#$3,$180E4.l
	bne.w	.x
	tst.w	d3
	beq.w	.x
	movea.l	#$180EC,a0
	adda.w	$180F0.l,a0
	clr.w	d0
	btst	#$7,$2(a0)
	beq.w	.slot
	addi.w	#$1A,d0
.slot	add.b	$3(a0),d0
	asl.w	#$2,d0
	movea.l	#ThreeStars,a0
	move.l	#$7FFFFFFF,(a0,d0.w)		;game winner is the first star
.x	rts
CalcTeamStarScores						;Star scores of team a2 (a3 = other team) to (a4)+, one long per roster
	
	
	
	
	
	movea.l	a2,a1
	move.w	$C(a2),d3
	sub.w	$C(a3),d3
	ext.l	d3
	moveq	#$19,d4
	jsr	(GetGoalieCount).l
	neg.w	d0
	add.w	d4,d0
.loop	move.l	d3,(a4)
	cmp.w	d0,d4
	bhi.w	.goalie
	clr.w	d1
	move.b	$B6(a2),d1
	mulu.w	#$2AF8,d1
	add.l	d1,(a4)
	clr.w	d1
	move.b	$D0(a2),d1
	mulu.w	#$2774,d1
	add.l	d1,(a4)
	clr.w	d1
	move.b	$EA(a2),d1
	mulu.w	#$A,d1
	tst.w	d3
	bne.w	.add
	mulu.w	#$64,d1
	add.l	d1,(a4)
	clr.l	d1
	add.w	$138(a1),d1
.add	add.l	d1,(a4)
	bra.w	.next
.goalie	cmp.w	$138(a1),d5
	bhi.w	.next
	clr.w	d1
	move.b	$B6(a2),d1
	mulu.w	#$64,d1
	clr.w	d2
	move.b	$EA(a2),d2
	beq.w	.next
	divu.w	d2,d1
	cmpi.w	#$4,d1
	bhi.w	.next
	addi.l	#$7D00,(a4)
	tst.w	d1
	bne.w	.next
	addi.l	#$124F8,(a4)
.next	adda.w	#$2,a1
	adda.w	#$1,a2
	adda.w	#$4,a4
	dbra	d4,.loop
	rts
	movem.l	d0-d2/a0-a4,-(sp)
	jsr	(printz).l
	String	CC_Font1Pri,$B,$3
	moveq	#$12,d0
	moveq	#$5,d1
	jsr	(Framer).l
	btst	#$5,$17F7A.l
	bne.w	.next2
	jsr	(printz).l
	dc.w	$0024
	dc.b	$BF,$0C,$04,'Injury to:',$BF,$0C,$06,'Out for period',$BF,$0C,$05,$00
	bra.w	.next3
.next2	jsr	(printz).l
	dc.w	$0022
	dc.b	$BF,$0C,$04,'Injury to:',$BF,$0C,$06,'Out for game',$BF,$0C,$05,$00
.next3	bsr.w	GetPlayerNumInitial
	jsr	(print).l
	btst	#$0,$17BE3.l
	beq.w	.next4
	jsr	(printz).l
	String	CC_Font1Pri,$14,$6,'the game'
.next4	movem.l	(sp)+,d0-d2/a0-a4
	rts
	bset	#$7,$17F78.l
	btst	#$0,$17F78.l
	beq.w	.next5
	jmp	(ShootoutModeBox).l
.next5	movem.l	d0-d2/a0-a4,-(sp)
	move.w	#$FFFF,d0
	jsr	(prefmes).l
	jsr	(printz).l
	String	CC_Font1Pri,$3,$2
	moveq	#$1B,d0
	moveq	#$8,d1
	jsr	(Framer).l
	lea.l	ShowGoalBox(pc),a1
	jsr	(printbig).l
	move.w	$19368.l,d0
	asl.w	#$7,d0
	movea.l	#$17480,a2
	adda.w	d0,a2
	clr.w	d0
	move.b	$66(a2),d0
	movea.l	#tmstruct,a2
	tst.w	$19366.l
	beq.w	.next6
	movea.l	#awtmstruct,a2
.next6	bsr.w	FormatPlayerNumInitial
	jsr	(print).l
	jsr	(printz).l
	String	CC_Font1Pri,$4,$7
	movem.l	a1/a3,-(sp)
	move.w	$19372.l,d0
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	lea.l	$2(a1),a1
	jsr	(print).l
	movem.l	(sp)+,a1/a3
	jsr	(printz).l
	String	' by',CC_Font1Pri,$4,$8
	move.w	$19370.l,d0
	movea.l	#awtmstruct,a2
	tst.w	$19366.l
	beq.w	.next7
	movea.l	#tmstruct,a2
.next7	jsr	(FormatPlayerNumInitial).l
	jsr	(print).l
	movem.l	(sp)+,d0-d2/a0-a4
	rts
ShowGoalBox						;Goal box. Closes both line change boxes, then printbig 'GOAL!' ('PP
	
	
	
									;assists of the last goal entry (FormatPlayerName). Calls CountGoalies,
									;StartArenaAnim (home hat trick),
									;PrintPlayerGoals and PrintPlayerAssists; BA_PS_flags bit 2 sets sflags2
									;bit 2. Called from SetPA
	dc.w	$0016,$BF04
	bchg	d1,(a0)
	dc.b	'ENALTY SHOT!',$BF,$04,$05,$00
; Draws the goal box after the flag checks.
ShowGoalBoxDraw
	movem.l	d0-d2/a0-a4,-(sp)
	btst	#$2,$17F70.l
	beq.w	.next
	bset	#$2,$17F6C.l
.next	movea.l	#tmstruct,a2
	jsr	(lcfound_close).l
	adda.w	#$366,a2
	jsr	(lcfound_close).l
	movea.l	#$180EC,a4
	adda.w	$180F0.l,a4
	jsr	(printz).l
	String	CC_Font1Pri,$B,$2
	moveq	#$13,d0
	move.w	#$5,d1
	tst.b	$4(a4)
	bmi.w	.next2
	addi.w	#$2,d1
	tst.b	$5(a4)
	bmi.w	.next2
	addi.w	#$1,d1
.next2	jsr	(Framer).l
	jsr	$25D8C.l
	movea.l	#tmstruct,a2
	move.w	$193AA.l,$17E98.l
	btst	#$7,$2(a4)
	beq.w	.next3
	adda.w	#$366,a2
	move.w	$193AC.l,$17E98.l
.next3	lea.l	.next9(pc),a1
	bclr	#$0,$17F7E.l
	beq.w	.next4
	lea.l	.next10(pc),a1
.next4	clr.w	d0
	move.b	$3(a4),d0
	addi.w	#$B6,d0
	cmpi.b	#$3,(a2,d0.w)
	bne.w	.next6
	movem.w	d1,-(sp)
	clr.w	d1
	move.b	$3(a4),d1
	cmp.w	$17E98.l,d1
	movem.w	(sp)+,d1
	blt.w	.next6
	adda.w	(a1),a1
	move.w	d0,-(sp)
	move.w	$2A(a2),d0
	cmp.w	(HomeTeam).l,d0
	bne.w	.next5
	move.w	#$0,d0
	jsr	(StartArenaAnim).l
.next5	move.w	(sp)+,d0
.next6	jsr	(printbig).l
	clr.w	d0
	move.b	$3(a4),d0
	move.w	d0,-(sp)
	move.w	#$C,(printx).l
	bsr.w	FormatPlayerName
	jsr	(print).l
	move.w	(sp)+,d0
	movem.w	d1,-(sp)
	clr.w	d1
	move.b	$3(a4),d1
	cmp.w	$17E98.l,d1
	movem.w	(sp)+,d1
	blt.w	.next7
	jsr	$2AA80.l
.next7	clr.w	d0
	move.b	$4(a4),d0
	bmi.w	.next8
	bclr	#$5,$17F72.l
	bne.w	.next8
	jsr	(printz).l
	String	CC_Font1Pri,$E,$6,'Assist by:',CC_Font1Pri,$C,$7
	move.w	d0,-(sp)
	bsr.w	FormatPlayerName
	jsr	(print).l
	move.w	(sp)+,d0
	jsr	$2AA6A.l
	clr.w	d0
	move.b	$5(a4),d0
	bmi.w	.next8
	jsr	(printz).l
	String	CC_Font1Pri,$C,$8
	move.w	d0,-(sp)
	bsr.w	FormatPlayerName
	jsr	(print).l
	move.w	(sp)+,d0
	jsr	$2AA6A.l
.next8	bclr	#$5,$17F72.l
	movem.l	(sp)+,d0-d2/a0-a4
	rts
.next9	dc.w	$000E,$BF0F,$0347,$4F41,$4C21,$BF0C,$0500,$0012
	dc.b	$BF,$0C,$03,'HAT TRICK!',$BF,$0C,$05
.next10	dc.w	$0010,$BF0D,$0350,$5020,$474F,$414C,$21BF,$0C05
	dc.b	$00,$12,$BF,$0C,$03,'HAT TRICK!',$BF
	dc.w	$0C05
	jsr	(printz).l
	String	CC_Font1,$B,$2
	moveq	#$13,d0
	moveq	#$8,d1
	move.l	#$7FF,d2
	jmp	(eraser).l
GetPlayerName						;but that is the same symbol as getplayername (SNASM symbols are
	
	
	
	movem.l	d0/a2,-(sp)
	movea.l	#tmstruct,a2
	move.w	$180EE.l,d0
	bpl.w	.0
	andi.w	#$FF,d0
	adda.w	#$366,a2
.0	bsr.w	GetPlayerNameBuild		;name for d0 of team a2
	movem.l	(sp)+,d0/a2
	rts
; Builds the name text in the message area.
GetPlayerNameBuild
	movem.l	d0-d3/a0/a2-a3,-(sp)
	bsr.w	SkipTextEntries
	move.l	a0,-(sp)
	movea.l	#mesarea,a3
	move.w	#$4,(a3)
	lea.l	$2(a3),a1
	adda.w	(a0),a0
	move.b	(a0),d0
	bsr.w	ConvertByteToDigits
	jsr	(PushNumberWidthString).l
	String	' '
	movea.l	(sp)+,a1
	jsr	(appstring).l
	movea.l	#mesarea,a1
	movem.l	(sp)+,d0-d3/a0/a2-a3
	rts
GetPlayerNumInitial
	movem.l	d0/a2,-(sp)
	movea.l	#tmstruct,a2
	move.w	$180EE.l,d0
	bpl.w	.next
	andi.w	#$FF,d0
	adda.w	#$366,a2
.next	bsr.w	FormatPlayerNumInitial
	movem.l	(sp)+,d0/a2
	rts
FormatPlayerNumInitial						;a1 = mesarea string "NN F. Last" for player d0 of team a2, built in
	
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	SkipTextEntries
	move.l	a0,-(sp)
	movea.l	#TextBuffer,a1
	adda.w	(a0),a0
	move.b	(a0),d0
	bsr.w	ConvertByteToDigits
	move.b	#$20,(a1)+
	movea.l	(sp)+,a0
	move.w	(a0)+,d0
	lea.l	-$2(a0,d0.w),a2
	move.b	(a0)+,(a1)+
	move.w	#$2E20,(a1)+
.skip	cmpi.b	#$20,(a0)+
	bne.w	.skip
.copy	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	bne.w	.copy
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
FormatPlayerName						;a1 = mesarea string "NN Last" for player d0 of team a2, built in
	
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	SkipTextEntries
	move.l	a0,-(sp)
	movea.l	#TextBuffer,a1
	adda.w	(a0),a0
	move.b	(a0),d0
	bsr.w	ConvertByteToDigits
	move.b	#$20,(a1)+
	movea.l	(sp)+,a0
	move.w	(a0)+,d0
	lea.l	-$2(a0,d0.w),a2
.skip	cmpi.b	#$20,(a0)+
	bne.w	.skip
.copy	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	bne.w	.copy
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
FormatPlayerNameLast						;FormatPlayerNameShort without the leading space ("Last", space padded).
	
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	SkipTextEntries
	movea.l	#TextBuffer,a1
	bra.w	FormatLastName
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	SkipTextEntries
	movea.l	#TextBuffer,a1
	move.b	#$20,(a1)+
FormatLastName						;Skip the first name, copy the last name, pad; branched to from
	
	move.w	(a0)+,d0
	lea.l	-$2(a0,d0.w),a2
.loop	cmpi.b	#$20,(a0)+
	bne.w	.loop
.loop2	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	beq.w	.pad
	tst.b	(a0)
	bne.w	.loop2
	bra.w	.pad
.loop3	move.b	#$20,(a1)+
.pad	cmpa.l	#$17F00,a1
	blt.w	.loop3
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
FinalizeTextBuffer						;mesarea length word = a1 - mesarea, with a 0 pad byte when odd. Returns
	
	move.l	a1,d0
	subi.l	#$17EF2,d0
	btst	#$0,d0
	beq.w	.even
	clr.b	(a1)+
	addi.w	#$1,d0
.even	movea.l	#mesarea,a1
	move.w	d0,(a1)
	rts
; Skips d0 entries of an offset-linked text list.
SkipTextEntries	movea.l	$1E(a2),a0
	adda.w	$0(a0),a0
	bra.w	.next
.loop	adda.w	(a0),a0
	adda.w	#$8,a0
.next	dbra	d0,.loop
	rts
ConvertByteToDigits						;converts decimal number in d0 to ascii: two ascii digits of bcd byte d0
	
	move.w	d0,-(sp)
	lsr.b	#$4,d0
	bne.w	.n0
	move.b	#$F0,d0
.n0	addi.b	#$30,d0
	move.b	d0,(a1)+
	move.w	(sp)+,d0
	andi.w	#$F,d0
	addi.b	#$30,d0
	move.b	d0,(a1)+
	rts
L412C8	bclr.b	#$5,$FF800F.l
	jsr	$39258.l
	dc.b	$00,$12,$BD,$00,$00,$41,$64,$64,$72,$65,$73,$73,$20,$45,$72,$72	; .....Address Err
	dc.b	$6F,$72	; or
	move.l	$A(sp),d0
	move.l	$2(sp),d1
	bra.w	L4134E
	dc.b	$08,$B9,$00,$05,$00,$FF,$80,$0F,$4E,$B9,$00,$03,$92,$58,$00,$18	; ........N....X..
	dc.b	$BD,$00,$00,$49,$6C,$6C,$65,$67,$61,$6C,$20,$49,$6E,$73,$74,$72	; ...Illegal Instr
	dc.b	$75,$63,$74,$69,$6F,$6E,$20,$2F,$00,$02,$22,$00,$60,$00,$00,$2C	; uction /..".`..,
	dc.b	$08,$B9,$00,$05,$00,$FF,$80,$0F,$4E,$B9,$00,$03,$92,$58,$00,$16	; ........N....X..
	dc.b	$BD,$00,$00,$44,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A	; ...Division by z
	dc.b	$65,$72,$6F,$00,$20,$2F,$00,$02,$22,$00	; ero. /..".
L4134E	movea.l	#$17EF2,a0
	move.w	#$18,(a0)+
	move.b	#$BD,(a0)+
	move.b	#$0,(a0)+
	move.b	#$2,(a0)+
	move.l	d1,-(sp)
	bsr.w	L4152A
	move.b	#$BD,(a0)+
	move.b	#$0,(a0)+
	move.b	#$4,(a0)+
	move.l	(sp)+,d0
	bsr.w	L4152A
	movea.l	#$17EF2,a1
	jsr	$3926A.l
	movea.l	#$C00000,a0
.loop	btst.b	#$7,$FF800E.l
	bne.s	.loop
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop2	btst.b	#$6,$FF800E.l
	beq.s	.loop2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	bne.s	.loop3
	bclr.b	#$7,$FF800F.l
.loop4	btst.b	#$7,$FF800E.l
	bne.s	.loop4
	move.w	#$9206,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop5	btst.b	#$6,$FF800E.l
	beq.s	.loop5
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	bne.s	.loop6
	bclr.b	#$7,$FF800F.l
.loop7	btst.b	#$7,$FF800E.l
	bne.s	.loop7
	move.w	#$8F02,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop8	btst.b	#$6,$FF800E.l
	beq.s	.loop8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop9	btst.b	#$6,$FF800E.l
	bne.s	.loop9
	bclr.b	#$7,$FF800F.l
.loop10	btst.b	#$7,$FF800E.l
	bne.s	.loop10
	move.l	#$C0200000,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop11	btst.b	#$6,$FF800E.l
	beq.s	.loop11
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop12	btst.b	#$6,$FF800E.l
	bne.s	.loop12
	bclr.b	#$7,$FF800F.l
	movea.l	$47D18.l,a1
	adda.l	(a1),a1
	adda.w	#$20,a1
	moveq	#$7,d0
.loop13	btst.b	#$7,$FF800E.l
	bne.s	.loop13
	move.l	(a1)+,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop14	btst.b	#$6,$FF800E.l
	beq.s	.loop14
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop15	btst.b	#$6,$FF800E.l
	bne.s	.loop15
	bclr.b	#$7,$FF800F.l
	dbra	d0,.loop13
	dc.w	$6000,$FFFE
L4152A	moveq	#$7,d2
.loop	rol.l	#$4,d0
	move.w	d0,d1
	andi.w	#$F,d1
	addi.w	#$30,d1
	cmpi.w	#$39,d1
	ble.w	.next
	addi.w	#$7,d1
.next	move.b	d1,(a0)+
	dbra	d2,.loop
	rts
updatecrowdf_cd0						;$fftt = frame/time for various levels of crowd
									;excitement. Used by updatecrowdf.
									;Used by updatecrowdf, indexed by crowd level and Crowdstep
	movep.w	$20C(a4),d0
	movep.w	$40C(a4),d1
	movep.w	$A0C(a4),d2
	movep.w	$80C(a4),d4
	dc.w	$060c,$070c,$080c,$090c,$0a0c,$050c,$040c,$030c

	dc.w	$0107,$0207,$0307,$0407,$0507,$0b07,$0c07,$0d07
	dc.w	$0607,$0707,$0807,$0907,$0a07,$0b07,$0c07,$0d07

	dc.w	$0e07,$0f07,$1007,$1107,$1207,$0b07,$0c07,$0d07
	dc.w	$1207,$1107,$1007,$0f07,$0e07,$0d07,$0c07,$0b07

	dc.w	$0e03,$0f03,$1003,$1103,$1203,$0b03,$0c03,$0d03
	dc.w	$1203,$1103,$1003,$0f03,$0e03,$0d03,$0c03,$0b03
	dc.b	$00,$03,$C0,$00,$00,$03,$1F,$F2,$00,$03,$20,$E6,$00,$03,$22,$B2
	dc.b	$00,$03,$23,$D2,$00,$03,$25,$76,$00,$03,$26,$36,$00,$03,$1F,$2A
	dc.b	$00,$03,$1E,$CC,$00,$03,$1B,$28,$00,$03,$1D,$0A,$00,$03,$19,$AC
	dc.b	$00,$03,$1B,$A0,$00,$03,$1C,$E2,$00,$03,$29,$26,$00,$03,$32,$3C
	dc.b	$00,$03,$34,$46,$00,$03,$3E,$06,$00,$03,$44,$3C,$00,$03,$43,$30
	dc.b	$00,$03,$1E,$AE,$00,$03,$1E,$B0,$00,$03,$1D,$FE,$00,$03,$1E,$16
	dc.b	$00,$03,$5A,$D4,$00,$03,$5F,$12,$00,$03,$5E,$CE,$00,$03,$4C,$C6
	dc.b	$00,$03,$52,$2A,$00,$03,$27,$BE,$00,$03,$44,$72,$00,$03,$47,$BA
	dc.b	$00,$03,$1D,$9E,$00,$03,$34,$18,$00,$03,$3D,$DC,$00,$02,$29,$26
