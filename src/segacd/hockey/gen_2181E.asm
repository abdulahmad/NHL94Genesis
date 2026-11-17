ChkShotStat						;determine if shot taken, add to appropriate stats: crowd, team, shooter
	
	
	
	
	btst	#$0,$17F68.l
	bne.w	rtss2
	btst	#$4,$17F68.l
	bne.w	rtss2
	bclr	#$4,$17F6C.l
	bne.w	.Cwdupdate
	btst	#$0,$17F72.l
	beq.w	rtss2
	bclr	#$3,$17F7C.l
	bne.w	.0
	bset	#$3,$17F7C.l
	bra.w	rtss2
.0	movem.l	d0-d1/a1-a3,-(sp)
	move.l	a4,-(sp)
	dc.w	$287C,$0001,$80EC
	dc.w	$D8F9,$0001,$80F0
	movea.l	#tmstruct,a2
	btst	#$7,$2(a4)
	beq.w	.pllookup
	adda.w	#$366,a2
.pllookup	clr.w	d0
	move.b	$3(a4),d0
	movea.l	(sp)+,a4
	movea.l	$22(a2),a2
	move.w	#$5,d1
.findplayer	cmp.b	$66(a2),d0
	beq.w	.foundplayer
	adda.w	#$80,a2
	dbra	d1,.findplayer
	bra.w	.ex
.foundplayer	move.w	$52(a2),d0
	bra.w	.l218D2
.Cwdupdate	movem.l	d0-d1/a1-a3,-(sp)
	addi.w	#$64,(Crowdlevel).l
	dc.w	$0679,$000A,$0001,$7CD8
	dc.w	$3039,$0001,$7E28
.l218D2	asl.w	#$7,d0
	dc.w	$267C,$0001,$7480
	adda.w	d0,a3
	bsr.w	.l21958
	addi.w	#$1,$0(a2)
	btst	#$5,$17F6C.l
	beq.w	.2
	btst	#$6,$17F6C.l
	bne.w	.1
	btst	#$6,$62(a3)
	bne.w	.2
.PPshot	addi.w	#$1,$356(a2)
	bra.w	.2
.1	btst	#$6,$62(a3)
	bne.w	.PPshot
.2	move.l	a2,-(sp)
	move.w	$180E4.l,d0
	add.w	d0,d0
	adda.w	d0,a2
	addi.w	#$1,$34C(a2)
	movea.l	(sp)+,a2
	clr.w	d0
	move.b	$66(a3),d0
	addi.w	#$EA,d0
	addi.b	#$1,(a2,d0.w)
	move.w	$28(a1),d0
	bmi.w	.ex
	addi.w	#$EA,d0
	addi.b	#$1,(a1,d0.w)
.ex	movem.l	(sp)+,d0-d1/a1-a3
	rts
.l21958	movea.l	#tmstruct,a2
	lea.l	$366(a2),a1
	btst	#$6,$62(a3)
	beq.w	rtss2
	exg.l	a1,a2
	rts
SetupTeamForIntermission						;Reset the bench, then for each team refill energy and pick the starting
	
	
	bsr.w	ResetBench
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a3
	bsr.w	.r
	exg.l	a2,a3
.r	bsr.w	reenergizeteam
	clr.w	$16(a3)
	dc.w	$4A79,$0001,$8C0A
	bne.w	rtss2
	move.w	$26(a3),d0
	sub.w	$26(a2),d0
	beq.w	rtss2
	move.w	#$3,$16(a3)
	tst.w	d0
	bpl.w	rtss2
	move.w	#$5,$16(a3)		;PK1
	rts
RestoreTeamEnergy						;a2 = team: max energy (tmpde $1000) for every player. The skip needs
	
	
	moveq	#$32,d0
.loop	cmpi.w	#$FFFD,$68(a2,d0.w)
	bne.w	.0
	cmpi.w	#$FFFC,$68(a2,d0.w)
	bne.w	.0
	bra.w	.1
.0	move.w	#$1000,$34(a2,d0.w)
.1	subi.w	#$2,d0
	bpl.w	.loop
	rts
reenergizeteam						;Set all players to max energy on team a2 except those at tmpdst -4;
	
	
	
	moveq	#$32,d0
.loop	cmpi.w	#$FFFC,$68(a2,d0.w)
	beq.w	.nb
	move.w	#$1000,$34(a2,d0.w)
	cmpi.w	#$FFFD,$68(a2,d0.w)
	bne.w	.nb
	move.w	#$FFFE,$68(a2,d0.w)
.nb	subi.w	#$2,d0
	bpl.w	.loop
	rts
Intermission						;end of period junk (zamboni/stats). Opens the pause menu screen (item
	
	
	
	
	
	cmpi.w	#$4,$180E4.l
	bne.w	.1
	dc.w	$33FC,$0000,$0001,$80E6
	jsr	$25A4E.l
.1	bsr.w	SetupTeamForIntermission
	moveq	#$F,d0
	dc.w	$207C,$0001,$7480
.l21A32	clr.w	$0(a0)
	adda.w	#$80,a0
	dbra	d0,.l21A32
	dc.w	$3839,$0001,$8D56
	movea.l	$47D34.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	move.w	#$140,$17CE2.l
	move.w	$180E4.l,d0
	dc.w	$4A79,$0001,$8BFA
	beq.w	.ss
	addi.w	#$5,d0
.ss	asl.w	#$2,d0
	dc.w	$41FA,$00B8
	movea.l	(a0,d0.w),a0
	btst	#$0,$17F78.l
	beq.w	.2
	movea.l	#$42250,a0
.2	bset	#$0,$17F6A.l
	movea.l	#$2C1F8,a1
	jsr	(Sub_2C2F8).l
	bsr.w	GetShifter
	dc.w	$33C1,$0001,$8ADE
	bset	#$5,$FF800F.l
.l21AAE	dc.w	$4A79,$0001,$8ADE
	bmi.w	.doh
	bsr.w	Sub_3CD00
	bsr.w	NewTicker3
	move.w	#$96,d0
	bsr.w	waitxsr
	btst	#$7,d1
	bne.w	.clrh
	bsr.w	Sub_3CE8C
	move.w	#$3C,d0
	bsr.w	waitxsr
	btst	#$7,d1
	beq.w	.l21AAE
.clrh	bset	#$3,$17F6E.l
.doh	bsr.w	DoHiLights
	bclr	#$3,$17F6E.l
	bne.w	.clrz
.wait	move.w	#$1E0,d0
	bsr.w	waitxsr
	btst	#$7,d1
	bne.w	.clrz
	dc.w	$4A79,$0001,$7FA6
	bne.w	.wait
	dc.w	$4A79,$0001,$7FA8
	bne.w	.wait
.clrz	st.b	$17CE2.l		;zamboni off
	rts
	dc.w	$0004,$22D4,$0004,$2454,$0004,$2454,$0004,$2454
	dc.w	$0004,$25B0,$0004,$2388,$0004,$2454,$0004,$2454
	dc.w	$0004,$2454,$0004,$26C4
InitScores						;initialize other games scores/period in playoffs. Called from StartGame
	dc.w	$0C79,$0001,$0001,$8A9E
	bgt.w	rtss2
	bsr.w	GetShifter
	movea.l	#$18A18,a0
	moveq	#$10,d0
	mulu.w	d1,d0
	adda.w	d0,a0
.l21B6C	dc.w	$B279,$0001,$8A98
	beq.w	.l21B96
	btst	#$2,$E(a0)
	bne.w	.l21B96
	clr.w	$8(a0)
	moveq	#$3,d0
	bsr.w	randomd0
	bra.w	.l21B92
.0	bsr.w	SetScore
.l21B92	dbra	d0,.0
.l21B96	suba.w	#$10,a0
	dbra	d1,.l21B6C
	rts
UpdateScores						;update ticker score values. Called from PeriodOver
	bsr.w	GetShifter
	dc.w	$33C1,$0001,$8ADE
	movea.l	#$18A18,a0
	moveq	#$10,d0
	mulu.w	d1,d0
	adda.w	d0,a0
.l21BB6	dc.w	$B279,$0001,$8A98
	beq.w	.next
	bclr	#$1,$E(a0)
	btst	#$2,$E(a0)
	bne.w	.next
	bsr.w	SetScore
.next	suba.w	#$10,a0
	dbra	d1,.l21BB6
	rts
SetScore						;add to score for game in a0. After period 3 a game within one goal goes
	
	cmpi.w	#$4,$8(a0)
	bge.w	rtss2
	movem.l	d0-d1/a0-a1,-(sp)
	cmpi.w	#$3,$8(a0)
	bne.w	.o
	move.w	#$5,$8(a0)
	move.w	$A(a0),d0
	sub.w	$C(a0),d0
	cmpi.w	#$1,d0
	bgt.w	.ex
	cmpi.w	#$FFFF,d0
	blt.w	.ex
	move.w	#$3,$8(a0)
	bset	#$1,$E(a0)
	bra.w	.ex
.o	addi.w	#$1,$8(a0)
	move.w	$0(a0),d0
	move.w	$2(a0),d1
	bsr.w	.getscore
	add.w	d0,$A(a0)
	move.w	$2(a0),d0
	move.w	$0(a0),d1
	bsr.w	.getscore
	add.w	d0,$C(a0)
.ex	movem.l	(sp)+,d0-d1/a0-a1
	rts
.getscore	asl.w	#$2,d0
	movea.l	#TeamList,a1
	movea.l	(a1,d0.w),a1
	adda.w	$8(a1),a1
	move.b	(a1),d0
	andi.w	#$70,d0
	lsr.w	#$1,d0
	dc.w	$43FA,$0048
	move.l	(a1,d0.w),$18BE8.l
	move.l	$4(a1,d0.w),$18BEC.l
	asl.w	#$2,d1
	movea.l	#TeamList,a1
	movea.l	(a1,d1.w),a1
	adda.w	$8(a1),a1
	move.b	(a1),d0
	andi.w	#$7,d0
	asl.w	#$3,d0
	dc.w	$43FA,$001C
	move.l	(a1,d0.w),d1
	add.l	d1,$18BE8.l
	move.l	$4(a1,d0.w),d1
	add.l	d1,$18BEC.l
	moveq	#$4,d0
	bra.w	WeightedRandomSelect
NewTicker						;show the next ticker score once the clock is at 8:00 or less. d3 = -1 if
	
	ori.b	#$1E,$17(a3)
	ori.b	#$27,d4
	ori.b	#$18,-(a0)
	ori.b	#$23,d5
	ori.b	#$1A,-(a1)
	ori.b	#$1E,d6
	ori.b	#$1E,-(a2)
	ori.b	#$1A,d6
	ori.b	#$1E,-(a4)
	dc.w	$0008,$0016,$0025,$001F,$000A,$0013,$0026,$001F
	dc.w	$000C,$000F,$0026,$0020,$000F
Sub_3CCF2
	moveq	#-1,d3
	dc.w	$0C79,$01E0,$0001,$80E6
	bgt.w	rtss2
Sub_3CD00
	dc.w	$3639,$0001,$8ADE
	bmi.w	rtss2
	dc.w	$0479,$0001,$0001,$8ADE
	dc.w	$B679,$0001,$8A98
	beq.w	Sub_3CD00
CheckGameTickerStatus						;d3 = game. Return a0 = its gstruct; skip to the next ticker game if a
	
	moveq	#$10,d0
	mulu.w	d3,d0
	movea.l	#$18A18,a0
	adda.w	d0,a0
	btst	#$1,$E(a0)
	bne.w	Sub_3CD00
	btst	#$2,$E(a0)
	bne.w	Sub_3CD00
	rts
NewTicker3						;Display ticker score for game d3 (a0 = gstruct entry), skip if d3 is
	
	tst.w	d3
	bmi.w	rtss2
	bsr.w	SetTickerAreaPosition
	bsr.w	Framer
	addi.w	#$1,(printx).l
	subi.w	#$4,(printy).l
	move.w	(printx).l,-(sp)
	bsr.w	GetShifter
	move.w	#$A000,(printa).l
	bsr.w	printz
	String	'                        '
	move.w	(sp),(printx).l
	moveq	#$1,d0
	dc.w	$D079,$0001,$8A9E
	dc.w	$4A79,$0001,$8BFA
	bne.w	.l21DA6
	clr.w	d0
.l21DA6	dc.w	$43FA,$0094
	bsr.w	Sub_3CEBE
	move.w	$8(a0),d0
	subi.w	#$1,d0
	movea.l	#$41A34,a1
	bsr.w	Sub_3CEC6
	move.w	(a1),d0
	lsr.w	#$1,d0
	neg.w	d0
	add.w	(sp),d0
	addi.w	#$17,d0
	move.w	d0,(printx).l
	bsr.w	print
	move.w	#$8000,(printa).l
	move.w	$2(a0),d0
	move.w	$C(a0),d1
	bsr.w	.tn
	move.w	$0(a0),d0
	move.w	$A(a0),d1
	bsr.w	.tn
	adda.w	#$2,sp
	rts
.tn	move.w	$4(sp),(printx).l
	addi.w	#$1,(printy).l
	movea.l	#TeamList,a1
	asl.w	#$2,d0
	movea.l	(a1,d0.w),a1
	adda.w	$4(a1),a1
	bsr.w	print
	move.w	$4(sp),(printx).l
	addi.w	#$15,(printx).l
	move.w	d1,d0
	moveq	#$2,d1
	bsr.w	PushNumberWidth
	bra.w	print
	dc.w	$0012,$4541,$2048,$6F63,$6B65,$7920,$4E69,$6768
	dc.w	$7400,$0018,$5374,$616E,$6C65,$7920,$4375,$7020
	dc.w	$5175,$616C,$6966,$6965,$7200,$000E,$5175,$6172
	dc.w	$7465,$7266,$696E,$616C,$0018,$5374,$616E,$6C65
	dc.w	$7920,$4375,$7020,$5365,$6D69,$6669,$6E61,$6C00
Sub_3CE8C
	bsr.w	SetTickerAreaPosition
	move.w	#$7FF,d2
	bra.w	eraser
SetTickerAreaPosition						;Set printx/printy/printm for the ticker box (x 3, y $17; the $BD map in
	
	
	bsr.w	printz
	String	CC_Font3Pri,$3,$17
	btst	#$0,$17F6A.l
	bne.w	.1
	bsr.w	printz
	String	CC_Font1Pri,$3,$17
.1	moveq	#$1A,d0
	moveq	#$5,d1
	rts
Sub_3CEBE
	bsr.w	Sub_3CEC6
	bra.w	printsmall
Sub_3CEC6
	bra.w	.l21ECC
.l21ECA	adda.w	(a1),a1
.l21ECC	dbra	d0,.l21ECA
	rts
DoHiLights						;Hilites logic: search for hilite game and show
	
	bsr.w	GetShifter
	moveq	#$10,d3
	mulu.w	d1,d3
	movea.l	#$18A18,a0
	adda.w	d3,a0
.top	btst	#$2,$E(a0)
	bne.w	.next
	bclr	#$1,$E(a0)
	beq.w	.next
	bsr.w	.l21F04
.next	suba.w	#$10,a0
	dbra	d1,.top
	rts
.l21F04	movem.l	d0-d7/a0-a6,-(sp)
.l21F08	btst	#$3,$17F6E.l
	bne.w	.l2231E
	bsr.w	.l223BA
	move.w	d1,d3
	bsr.w	CheckGameTickerStatus
	bsr.w	NewTicker3
	btst	#$3,$17F6E.l
	bne.w	.l22312
	move.w	#$4,(printx).l
	subi.w	#$6,(printy).l
	moveq	#$18,d0
	moveq	#$3,d1
	bsr.w	Framer
	addi.w	#$1,(printx).l
	subi.w	#$2,(printy).l
	bsr.w	printz
	String	'Highlight from game:'
	move.w	#$B4,d0
	bsr.w	waitxsr
	btst	#$7,d1
	bne.w	.l22312
	st.b	$17CE2.l
	dc.w	$4279,$0001,$7CD8
	move.w	$0(a0),(HomeTeam).l
	move.w	$2(a0),(VisTeam).l
	move.l	a0,-(sp)
	clr.w	$18374.l
	clr.w	$186DA.l
	jsr	(clearTeamStats).l
	jsr	(restoreteams).l
	dc.w	$50F9,$0001,$7F9E
	dc.w	$50F9,$0001,$7FA0
	dc.w	$4279,$0001,$7FA6
	dc.w	$4279,$0001,$7FA8
	moveq	#$78,d0
	bsr.w	randomd0
	addi.w	#$3C,d0
	dc.w	$33C0,$0001,$80E6
	movea.l	(sp),a0
	move.w	$8(a0),$180E4.l
	subi.w	#$1,$180E4.l
	dc.w	$33E8,$000A,$0001,$8358
	dc.w	$33E8,$000C,$0001,$86BE
	move.b	#$10,$17F68.l
	btst	#$0,$180E5.l
	beq.w	.l2201C
	bset	#$1,$17F68.l
.l2201C	clr.b	$17F6A.l
	move.b	#$4,$17F6C.l
	clr.b	$17F6E.l
	bclr	#$4,(disflags).l
	bset	#$3,(disflags).l
	clr.w	$17E32.l
	clr.b	$17ECE.l
	dc.w	$50F9,$0001,$806E
	st.b	$17E38.l
	st.b	$17E3C.l
	jsr	$47DAC.l
	bsr.w	setupice_highlight
	move.w	#$1,$17468.l
	bsr.w	ClrHor
	move.w	#$0,$17468.l
	movea.l	#$C00000,a0
.l22082	btst	#$7,$FF800E.l
	bne.b	.l22082
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l220A4	btst	#$6,$FF800E.l
	beq.b	.l220A4
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l220BE	btst	#$6,$FF800E.l
	bne.b	.l220BE
	bclr	#$7,$FF800F.l
.l220D0	btst	#$7,$FF800E.l
	bne.b	.l220D0
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l220F2	btst	#$6,$FF800E.l
	beq.b	.l220F2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l2210C	btst	#$6,$FF800E.l
	bne.b	.l2210C
	bclr	#$7,$FF800F.l
	dc.w	$3839,$0001,$8D56
	movea.l	$47D1C.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	dc.w	$4279,$0001,$7CEA
	dc.w	$4279,$0001,$7CEE
	bsr.w	ResetBench
	movea.l	#tmstruct,a2
	bsr.w	.l22326
	adda.w	#$366,a2
	bsr.w	.l22326
	bsr.w	resetplstuff
	moveq	#$B,d0
	movea.l	#$3D3F6,a0
	dc.w	$227C,$0001,$7480
.l22164	move.w	$34(a1),d1
	btst	#$7,$62(a1)
	bne.w	.l22176
	addi.w	#$6,d1
.l22176	asl.w	#$2,d1
	move.w	(a0,d1.w),$0(a1)
	move.w	$2(a0,d1.w),$14(a1)
	clr.w	$28(a1)
	clr.w	$2A(a1)
	adda.w	#$80,a1
	dbra	d0,.l22164
	bsr.w	Sub_3F03E
	move.w	#$18,(palcount).l
	dc.w	$33F9,$0001,$7474,$0001,$7476
	move.w	#$B4,-(sp)
.l221AE	jsr	(DoGameFrame).l
	btst	#$0,$17F68.l
	beq.w	.l221C8
	subi.w	#$1,(sp)
	bmi.w	.l2224C
.l221C8	bsr.w	orjoy
	btst	#$5,d1
	bne.w	.l221DC
	btst	#$7,d1
	beq.w	.l221AE
.l221DC	dc.w	$3039,$0001,$8358
	dc.w	$B079,$0001,$86BE
	bne.w	.l2224C
.l221EC	btst	#$7,$FF800E.l
	bne.b	.l221EC
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.l22206	btst	#$6,$FF800E.l
	beq.b	.l22206
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l22226	btst	#$6,$FF800E.l
	bne.b	.l22226
	bclr	#$7,$FF800F.l
	andi.w	#$1,d0
	dc.w	$D179,$0001,$8358
	eori.w	#$1,d0
	dc.w	$D179,$0001,$86BE
.l2224C	adda.w	#$2,sp
	movea.l	(sp)+,a0
	movem.l	d1/a0,-(sp)
	jsr	$48208.l
	jsr	$47DAC.l
	movem.l	(sp)+,d1/a0
	dc.w	$3179,$0001,$8358,$000A
	dc.w	$3179,$0001,$86BE,$000C
	bsr.w	forceblack
	moveq	#$F,d0
	dc.w	$207C,$0001,$7480
.l22282	clr.w	$0(a0)
	adda.w	#$80,a0
	dbra	d0,.l22282
	bsr.w	.l223D8
	bsr.w	Sub_3F24C
	bsr.w	SetHor
	bsr.w	setvideo
	jsr	$2C1F8.l
	jsr	(DrawMenuScreen).l
	move.w	#$18,(palcount).l
	move.w	#$79,-(sp)
	bsr.w	song
	movem.l	(sp),d0-d7/a0-a6
	move.w	#$4,$8(a0)
	move.w	$A(a0),d0
	cmp.w	$C(a0),d0
	beq.w	.l21F08
	move.w	#$5,$8(a0)
	move.w	d1,d3
	bsr.w	CheckGameTickerStatus
	bsr.w	NewTicker3
	move.w	#$B4,d0
	bsr.w	waitxsr
	btst	#$7,d1
	bne.w	.l22304
	bsr.w	Sub_3CE8C
	move.w	#$3C,d0
	bsr.w	waitxsr
	btst	#$7,d1
	beq.w	.l2230C
.l22304	bset	#$3,$17F6E.l
.l2230C	movem.l	(sp)+,d0-d7/a0-a6
	rts
.l22312	bsr.w	.l223D8
	bsr.w	.l2234A
	bra.w	.l22304
.l2231E	bsr.w	.l2234A
	bra.w	.l2230C
.l22326	jsr	(reenergizeteam).l
	bsr.w	setpersonel
	bsr.w	forcepldata
	st.b	$18(a2)
	bclr	#$7,$17F7C.l
	st.b	$1A(a2)
	st.b	$1C(a2)
	rts
.l2234A	move.w	$A(a0),d0
	cmp.w	$C(a0),d0
	bne.w	.l223B2
.l22356	btst	#$7,$FF800E.l
	bne.b	.l22356
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.l22370	btst	#$6,$FF800E.l
	beq.b	.l22370
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l22390	btst	#$6,$FF800E.l
	bne.b	.l22390
	bclr	#$7,$FF800F.l
	andi.w	#$1,d0
	add.w	d0,$A(a0)
	eori.w	#$1,d0
	add.w	d0,$C(a0)
.l223B2	move.w	#$5,$8(a0)
	rts
.l223BA	move.w	#$557,d0
	movea.l	#$17F68,a1
	dc.w	$247C,$0000,$C45C
.l223CA	move.w	(a1)+,(a2)+
	dbra	d0,.l223CA
	dc.w	$34F9,$0001,$80F0
	rts
.l223D8	move.w	#$557,d0
	movea.l	#$17F68,a2
	dc.w	$227C,$0000,$C45C
.l223E8	move.w	(a1)+,(a2)+
	dbra	d0,.l223E8
	dc.w	$33D9,$0001,$80F0
	rts
	dc.w	$0000,$FF10,$FFBA,$FF74,$0014,$FF92,$FF9C,$FFC4
	dc.w	$0019,$FFD8,$0046,$FFB0,$0000,$00F0,$0022,$005A
	dc.w	$FFC9,$0050,$0064,$0028,$FFF6,$000A,$FFCE,$0000
setpersonel
	movem.l	d0-d5/a0-a4,-(sp)
	movea.l	$22(a2),a3
	moveq	#$5,d4
.l22430	st.b	$60(a3)
	st.b	$61(a3)
	adda.w	#$80,a3
	dbra	d4,.l22430
	bsr.w	SetPlList
	moveq	#$5,d4
	movea.l	#$18AC6,a4
.l2244C	clr.w	d5
	move.b	(a4,d4.w),d5
	beq.w	.l22482
	subi.w	#$1,d5
	moveq	#$5,d3
	movea.l	$22(a2),a3
	suba.w	#$80,a3
.l22464	adda.w	#$80,a3
	cmp.b	$66(a3),d5
	dbeq	d3,.l22464
	bne.w	.l22482
	move.b	$6(a4,d4.w),$60(a3)
	move.b	d5,$61(a3)
	clr.b	(a4,d4.w)
.l22482	dbra	d4,.l2244C
	moveq	#$5,d4
	movea.l	#$18AC6,a4
.l2248E	clr.w	d5
	move.b	(a4,d4.w),d5
	beq.w	.l224CE
	subi.w	#$1,d5
	moveq	#$5,d3
	movea.l	$22(a2),a3
	suba.w	#$80,a3
.l224A6	adda.w	#$80,a3
	tst.b	$61(a3)
	dbmi	d3,.l224A6
	bpl.w	.l224B8
	movea.l	a3,a0
.l224B8	tst.w	$34(a3)
	dbpl	d3,.l224A6
	move.b	$6(a4,d4.w),$60(a0)
	move.b	d5,$61(a0)
	clr.b	(a4,d4.w)
.l224CE	dbra	d4,.l2248E
	movem.l	(sp)+,d0-d5/a0-a4
	rts
SetPlList						;create PlList of players who we want on the ice now. a2 = team struct.
									;Takes the current line (tmline) by priolist; an unavailable
									;player (in the box or injured, -3 / -4) is replaced from sublist, or from
									;the whole roster
	movea.l	#$18AC6,a4
	clr.l	(a4)		;goalie present: use the position priority list from the start
	clr.w	$4(a4)
	movea.l	#$41AD6,a0
	tst.w	$28(a2)
	bpl.w	.l224F6		;branch if theres a goalie
	adda.w	#$1,a0		;add 1 to a0
.l224F6	lea.l	$16C(a2),a1		;loop: d5 = position, PlList slot = the line's player there (no player:
	move.w	$16(a2),d0		;current line selected
	asl.w	#$3,d0
	adda.w	d0,a1		;add to a1 to set a1 to currently selected line
	move.w	$26(a2),d4		;tmap - active players (4-6 in normal ROM)
	bra.w	.l22528
.l2250A	clr.w	d5
	move.b	(a0,d4.w),d5		;move position into d5
	move.b	(a1,d5.w),(a4,d4.w)
	move.b	d5,$6(a4,d4.w)
	bne.w	.l22528
	moveq	#$1,d3		;loop: replace injured or penalized players
	add.w	$28(a2),d3
	move.b	d3,(a4,d4.w)
.l22528	dbra	d4,.l2250A
	moveq	#$5,d4		;now check to see if player is available
.l2252E	move.b	(a4,d4.w),d3
	beq.w	.l22584
	ext.w	d3
	subi.w	#$1,d3
	add.w	d3,d3
	cmpi.w	#$FFFD,$68(a2,d3.w)		;injured or not on the bench: find a substitute from sublist
	beq.w	.l2255A
	cmpi.w	#$FFFC,$68(a2,d3.w)		;check if player injured for game
	beq.w	.l2255A
	tst.w	$68(a2,d3.w)
	ble.w	.l22584
.l2255A	lea.l	$16C(a2),a1		;now find a player of similar position who is available move Line Lists
	move.b	$6(a4,d4.w),d0		;move 6+a4+d4 into d0 (previous d5)
	ext.w	d0
	asl.w	#$1,d0
	movea.l	#$41A6C,a0		;move sublist into a0
	adda.w	(a0,d0.w),a0		;move a0+d0 into a0
.l22570	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	.l2258A
	move.b	(a1,d0.w),d0
	bsr.w	TryAddPlayerToList
	beq.w	.l22570
.l22584	dbra	d4,.l2252E
	rts
.l2258A	jsr	(GetPlayerCount).l		;then try the players from d0 down
	move.w	d0,d3
.l22592	move.w	d3,d0		;d0 = candidate player number, d3 counts down
	subi.w	#$1,d3
	bmi.w	.l22584		;none available
	bsr.w	TryAddPlayerToList
	beq.w	.l22592
	bra.w	.l22584
TryAddPlayerToList						;d0 = player number (1 based), d4 = PlList slot. Put d0 in the slot if he
									;is on the bench or ice (not in the box, not injured) and not in PlList
									;yet; return d1 = 0 (Z set) if not
	move.w	d0,d1
	subi.w	#$1,d0
	add.w	d0,d0
	tst.w	$68(a2,d0.w)
	bgt.w	.l225E0		;loop: is d1 already in PlList?
	cmpi.w	#$FFFD,$68(a2,d0.w)
	beq.w	.l225E0
	cmpi.w	#$FFFC,$68(a2,d0.w)
	beq.w	.l225E0
	moveq	#$5,d0
.l225CE	cmp.b	(a4,d0.w),d1
	dbeq	d0,.l225CE
	beq.w	.l225E0
	move.b	d1,(a4,d4.w)
	rts
.l225E0	clr.w	d1
	rts
SetupPenaltyShot						;Penalty shot set up for team a2 (called from puckpenshot): the shooter
									;loop over the team: shooter plays center, goalie stays, others leave
	movem.l	d0-d5/a0-a3,-(sp)
	movea.l	$22(a2),a3
	moveq	#$5,d4
.l225EE	move.w	$52(a3),d0
	dc.w	$B079,$0001,$9368
	beq.w	.l22618
	dc.w	$B079,$0001,$936A
	beq.w	.l22636
	bset	#$2,$63(a3)		;set player unavailable
	move.w	#$20,d0		;assgoaliebreakwait
	bsr.w	assreplace
	bra.w	.l22652
.l22618	bsr.w	Setplass
	move.b	$61(a3),$17F9C.l
	move.b	$1936D.l,$61(a3)		;put the player on the ice
	move.w	#$4,$34(a3)
	bra.w	.l2263E
.l22636	bsr.w	Setplass
	clr.w	$34(a3)
.l2263E	clr.w	d3		;next sort object
	move.b	$61(a3),d3
	add.w	d3,d3
	move.w	#$FFFF,$68(a2,d3.w)
	lsr.w	#$1,d3
	bsr.w	Sub_3D770
.l22652	st.b	$61(a3)
	st.b	$60(a3)
	adda.w	#$80,a3
	dbra	d4,.l225EE
	movem.l	(sp)+,d0-d5/a0-a3
	rts
forcepldata						;no skating on/off: force players to correct data (for faceoffs only). a2
									;= team struct
	movem.l	d0-d4/a0-a3,-(sp)
	movea.l	$22(a2),a3		;22 offset of team struct is tmsort (address of first sort obj)
	moveq	#$5,d4		;will run the loop 6 times
.l22672	move.b	$60(a3),d0		;newpos = requested next pos of player
	ext.w	d0
	tst.w	$34(a3)
	bne.w	.l2269A
	tst.w	d0		;set the position and its assignment; centers also get assnearest
	beq.w	.l2269A
	move.w	$52(a3),-(sp)		;push SCNum to stack
	move.w	#$F,$52(a3)		;put F into SCNum
	jsr	$22DDE.l
	move.w	(sp)+,$52(a3)		;pop original SCNum back into SCNum
.l2269A	move.w	d0,$34(a3)		;move newpos(d0) into position
	bmi.w	.l226CA		;put the requested player on the ice
	bsr.w	Setplass
	cmpi.w	#$4,$34(a3)
	bne.w	.l226B6
	moveq	#$11,d0
	bsr.w	Sub_362D8
.l226B6	clr.w	d3		;d3 = requested player number
	move.b	$61(a3),d3		;next sort object
	add.w	d3,d3		;add d3 to itself
	move.w	#$FFFF,$68(a2,d3.w)		;move -1 into tmpdst
	lsr.w	#$1,d3		;divide d3 by 2
	bsr.w	Sub_3D770
.l226CA	st.b	$61(a3)		;set newpnum to FF
	st.b	$60(a3)		;set newpos to FF
	adda.l	#$80,a3		;move to next sortobj (player struct)
	dbra	d4,.l22672
	movem.l	(sp)+,d0-d4/a0-a3
	rts
ResetBench						;remove all players from penalty box / put all players on their own bench
									;(not the injured, -3 / -4). Counts the players left in the box in PBnum
									;(home in the high nibble). .rb runs for the home team, then falls in for
									;the visitors
	dc.w	$4239,$0001,$8068
	moveq	#$10,d1
	movea.l	#tmstruct,a0
	bsr.w	.l226FA
	moveq	#$1,d1
	adda.w	#$366,a0		;change to Away Team
.l226FA	moveq	#$32,d0		;$32 = (MaxRos-1)*2 = 50 decimal
.l226FC	dc.w	$D339,$0001,$8068
	tst.w	$68(a0,d0.w)
	ble.w	.l2272A
	btst	#$4,$68(a0,d0.w)		;test 3rd bit in tmpdst (4 decimal)
	beq.w	.l2274A		;not in the box: mark on the bench unless injured
	move.w	$68(a0,d0.w),d2		;move tmpdst into d2
	andi.w	#$7FF,d2		;mask 7FF with d2. Passes lowest 11 bits
	bne.w	.l2274A
	dc.w	$9339,$0001,$8068
	bra.w	.l2274A
.l2272A	dc.w	$9339,$0001,$8068
	cmpi.w	#$FFFD,$68(a0,d0.w)		;compare -3 with tmpdst
	beq.w	.l2274A
	cmpi.w	#$FFFC,$68(a0,d0.w)		;compare -4 with tmpdst
	beq.w	.l2274A
	move.w	#$FFFE,$68(a0,d0.w)		;move -2 into tmpdst
.l2274A	subi.w	#$2,d0		;previous roster entry
	bpl.w	.l226FC
	rts
Setplass						;set players (a3) initial assignment from .alist by position
	move.w	$34(a3),d0
	bmi.w	rtss2
	dc.w	$41FA,$000A
	move.b	(a0,d0.w),d0
	bra.w	assreplace
	dc.w	$0E02		;assgoalie
setplayer						;bring player onto the ice and set his attributes. d3 = offset of player
									;on roster, a3 = sortcord of player. Reads the roster bytes through
									;AttributeCalc (attribute number in TempWord2). Adds the PP / PK, home /
									;away and third period bonuses (team ScoutReport bytes) to some attributes
									;and clamps them with ClampNibble
	dc.w	$0203,$0503
	btst	d2,d0
