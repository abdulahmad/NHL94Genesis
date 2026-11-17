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
	movea.l	#$180EC,a4
	adda.w	$180F0.l,a4
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
	bra.w	.next2
.foundplayer	move.w	$52(a2),d0
	bra.w	.next
.Cwdupdate	movem.l	d0-d1/a1-a3,-(sp)
	addi.w	#$64,(Crowdlevel).l
	addi.w	#$A,$17CD8.l
	move.w	$17E28.l,d0
.next	asl.w	#$7,d0
	movea.l	#$17480,a3
	adda.w	d0,a3
	bsr.w	.next3
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
	bmi.w	.next2
	addi.w	#$EA,d0
	addi.b	#$1,(a1,d0.w)
.next2	movem.l	(sp)+,d0-d1/a1-a3
	rts
.next3	movea.l	#tmstruct,a2
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
	tst.w	$18C0A.l
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
	move.w	#$0,$180E6.l
	jsr	$25A4E.l
.1	bsr.w	SetupTeamForIntermission
	moveq	#$F,d0
	movea.l	#$17480,a0
.loop	clr.w	$0(a0)
	adda.w	#$80,a0
	dbra	d0,.loop
	move.w	$18D56.l,d4
	movea.l	$47D34.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	move.w	#$140,$17CE2.l
	move.w	$180E4.l,d0
	tst.w	$18BFA.l
	beq.w	.ss
	addi.w	#$5,d0
.ss	asl.w	#$2,d0
	lea.l	.next(pc),a0
	movea.l	(a0,d0.w),a0
	btst	#$0,$17F78.l
	beq.w	.2
	movea.l	#$42250,a0
.2	bset	#$0,$17F6A.l
	movea.l	#$2C1F8,a1
	jsr	(SetMenuScreenHandler).l
	bsr.w	GetShifter
	move.w	d1,$18ADE.l
	bset	#$5,$FF800F.l
.loop2	tst.w	$18ADE.l
	bmi.w	.doh
	bsr.w	NewTickerNext
	bsr.w	NewTicker3
	move.w	#$96,d0
	bsr.w	waitxsr
	btst	#$7,d1
	bne.w	.clrh
	bsr.w	NewTickerErase
	move.w	#$3C,d0
	bsr.w	waitxsr
	btst	#$7,d1
	beq.w	.loop2
.clrh	bset	#$3,$17F6E.l
.doh	bsr.w	DoHiLights
	bclr	#$3,$17F6E.l
	bne.w	.clrz
.wait	move.w	#$1E0,d0
	bsr.w	waitxsr
	btst	#$7,d1
	bne.w	.clrz
	tst.w	$17FA6.l
	bne.w	.wait
	tst.w	$17FA8.l
	bne.w	.wait
.clrz	st.b	$17CE2.l		;zamboni off
	rts
.next	dc.w	$0004,$22D4,$0004,$2454,$0004,$2454,$0004,$2454
	dc.w	$0004,$25B0,$0004,$2388,$0004,$2454,$0004,$2454
	dc.w	$0004,$2454,$0004,$26C4
InitScores						;initialize other games scores/period in playoffs. Called from StartGame
	cmpi.w	#$1,$18A9E.l
	bgt.w	rtss2
	bsr.w	GetShifter
	movea.l	#$18A18,a0
	moveq	#$10,d0
	mulu.w	d1,d0
	adda.w	d0,a0
.loop	cmp.w	$18A98.l,d1
	beq.w	.next2
	btst	#$2,$E(a0)
	bne.w	.next2
	clr.w	$8(a0)
	moveq	#$3,d0
	bsr.w	randomd0
	bra.w	.next
.0	bsr.w	SetScore
.next	dbra	d0,.0
.next2	suba.w	#$10,a0
	dbra	d1,.loop
	rts
UpdateScores						;update ticker score values. Called from PeriodOver
	bsr.w	GetShifter
	move.w	d1,$18ADE.l
	movea.l	#$18A18,a0
	moveq	#$10,d0
	mulu.w	d1,d0
	adda.w	d0,a0
.loop	cmp.w	$18A98.l,d1
	beq.w	.next
	bclr	#$1,$E(a0)
	btst	#$2,$E(a0)
	bne.w	.next
	bsr.w	SetScore
.next	suba.w	#$10,a0
	dbra	d1,.loop
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
	bgt.w	.next
	cmpi.w	#$FFFF,d0
	blt.w	.next
	move.w	#$3,$8(a0)
	bset	#$1,$E(a0)
	bra.w	.next
.o	addi.w	#$1,$8(a0)
	move.w	$0(a0),d0
	move.w	$2(a0),d1
	bsr.w	.getscore
	add.w	d0,$A(a0)
	move.w	$2(a0),d0
	move.w	$0(a0),d1
	bsr.w	.getscore
	add.w	d0,$C(a0)
.next	movem.l	(sp)+,d0-d1/a0-a1
	rts
.getscore	asl.w	#$2,d0
	movea.l	#TeamList,a1
	movea.l	(a1,d0.w),a1
	adda.w	$8(a1),a1
	move.b	(a1),d0
	andi.w	#$70,d0
	lsr.w	#$1,d0
	lea.l	NewTicker(pc),a1
	move.l	(a1,d0.w),$18BE8.l
	move.l	$4(a1,d0.w),$18BEC.l
	asl.w	#$2,d1
	movea.l	#TeamList,a1
	movea.l	(a1,d1.w),a1
	adda.w	$8(a1),a1
	move.b	(a1),d0
	andi.w	#$7,d0
	asl.w	#$3,d0
	lea.l	NewTicker(pc),a1
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
; Skips when the ticker timer is above $1E0.
NewTickerCheckBusy
	moveq	#-1,d3
	cmpi.w	#$1E0,$180E6.l
	bgt.w	rtss2
; Takes the next queued ticker message.
NewTickerNext
	move.w	$18ADE.l,d3
	bmi.w	rtss2
	subi.w	#$1,$18ADE.l
	cmp.w	$18A98.l,d3
	beq.w	NewTickerNext
CheckGameTickerStatus						;d3 = game. Return a0 = its gstruct; skip to the next ticker game if a
	
	moveq	#$10,d0
	mulu.w	d3,d0
	movea.l	#$18A18,a0
	adda.w	d0,a0
	btst	#$1,$E(a0)
	bne.w	NewTickerNext
	btst	#$2,$E(a0)
	bne.w	NewTickerNext
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
	add.w	$18A9E.l,d0
	tst.w	$18BFA.l
	bne.w	.next
	clr.w	d0
.next	lea.l	.next2(pc),a1
	bsr.w	PrintTickerEntry
	move.w	$8(a0),d0
	subi.w	#$1,d0
	movea.l	#$41A34,a1
	bsr.w	SkipListEntries
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
.next2	dc.b	$00,$12,'EA Hockey Nigh'
	dc.b	't',$00,$00,$18,'Stanley Cup '
	dc.b	'Qualifier',$00,$00,$0E,'Quar'
	dc.b	'terfinal',$00,$18,'Stanle'
	dc.b	'y Cup Semifinal',$00
; Sets the ticker position and erases it.
NewTickerErase
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
; Skips to the entry and prints it small.
PrintTickerEntry
	bsr.w	SkipListEntries
	bra.w	printsmall
; Skips d0 offset-linked entries starting at a1.
SkipListEntries
	bra.w	.next
.loop	adda.w	(a1),a1
.next	dbra	d0,.loop
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
	bsr.w	.next2
.next	suba.w	#$10,a0
	dbra	d1,.top
	rts
.next2	movem.l	d0-d7/a0-a6,-(sp)
.loop	btst	#$3,$17F6E.l
	bne.w	.next9
	bsr.w	.next13
	move.w	d1,d3
	bsr.w	CheckGameTickerStatus
	bsr.w	NewTicker3
	btst	#$3,$17F6E.l
	bne.w	.next8
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
	bne.w	.next8
	st.b	$17CE2.l
	clr.w	$17CD8.l
	move.w	$0(a0),(HomeTeam).l
	move.w	$2(a0),(VisTeam).l
	move.l	a0,-(sp)
	clr.w	$18374.l
	clr.w	$186DA.l
	jsr	(clearTeamStats).l
	jsr	(restoreteams).l
	st.b	$17F9E.l
	st.b	$17FA0.l
	clr.w	$17FA6.l
	clr.w	$17FA8.l
	moveq	#$78,d0
	bsr.w	randomd0
	addi.w	#$3C,d0
	move.w	d0,$180E6.l
	movea.l	(sp),a0
	move.w	$8(a0),$180E4.l
	subi.w	#$1,$180E4.l
	move.w	$A(a0),$18358.l
	move.w	$C(a0),$186BE.l
	move.b	#$10,$17F68.l
	btst	#$0,$180E5.l
	beq.w	.next3
	bset	#$1,$17F68.l
.next3	clr.b	$17F6A.l
	move.b	#$4,$17F6C.l
	clr.b	$17F6E.l
	bclr	#$4,(disflags).l
	bset	#$3,(disflags).l
	clr.w	$17E32.l
	clr.b	$17ECE.l
	st.b	$1806E.l
	st.b	$17E38.l
	st.b	$17E3C.l
	jsr	$47DAC.l
	bsr.w	setupice_highlight
	move.w	#$1,$17468.l
	bsr.w	ClrHor
	move.w	#$0,$17468.l
	movea.l	#$C00000,a0
.loop2	btst	#$7,$FF800E.l
	bne.b	.loop2
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	beq.b	.loop3
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop4	btst	#$6,$FF800E.l
	bne.b	.loop4
	bclr	#$7,$FF800F.l
.loop5	btst	#$7,$FF800E.l
	bne.b	.loop5
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	beq.b	.loop6
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop7	btst	#$6,$FF800E.l
	bne.b	.loop7
	bclr	#$7,$FF800F.l
	move.w	$18D56.l,d4
	movea.l	$47D1C.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	clr.w	$17CEA.l
	clr.w	$17CEE.l
	bsr.w	ResetBench
	movea.l	#tmstruct,a2
	bsr.w	.next10
	adda.w	#$366,a2
	bsr.w	.next10
	bsr.w	resetplstuff
	moveq	#$B,d0
	movea.l	#$3D3F6,a0
	movea.l	#$17480,a1
.loop8	move.w	$34(a1),d1
	btst	#$7,$62(a1)
	bne.w	.next4
	addi.w	#$6,d1
.next4	asl.w	#$2,d1
	move.w	(a0,d1.w),$0(a1)
	move.w	$2(a0,d1.w),$14(a1)
	clr.w	$28(a1)
	clr.w	$2A(a1)
	adda.w	#$80,a1
	dbra	d0,.loop8
	bsr.w	SprSortSetup
	move.w	#$18,(palcount).l
	move.w	(ScoutSubStatus).l,$17476.l
	move.w	#$B4,-(sp)
.loop9	jsr	(DoGameFrame).l
	btst	#$0,$17F68.l
	beq.w	.next5
	subi.w	#$1,(sp)
	bmi.w	.next7
.next5	bsr.w	orjoy
	btst	#$5,d1
	bne.w	.next6
	btst	#$7,d1
	beq.w	.loop9
.next6	move.w	$18358.l,d0
	cmp.w	$186BE.l,d0
	bne.w	.next7
.loop10	btst	#$7,$FF800E.l
	bne.b	.loop10
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop11	btst	#$6,$FF800E.l
	beq.b	.loop11
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop12	btst	#$6,$FF800E.l
	bne.b	.loop12
	bclr	#$7,$FF800F.l
	andi.w	#$1,d0
	add.w	d0,$18358.l
	eori.w	#$1,d0
	add.w	d0,$186BE.l
.next7	adda.w	#$2,sp
	movea.l	(sp)+,a0
	movem.l	d1/a0,-(sp)
	jsr	$48208.l
	jsr	$47DAC.l
	movem.l	(sp)+,d1/a0
	move.w	$18358.l,$A(a0)
	move.w	$186BE.l,$C(a0)
	bsr.w	forceblack
	moveq	#$F,d0
	movea.l	#$17480,a0
.loop13	clr.w	$0(a0)
	adda.w	#$80,a0
	dbra	d0,.loop13
	bsr.w	.next14
	bsr.w	CopyTeamLinesCheckTeam
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
	beq.w	.loop
	move.w	#$5,$8(a0)
	move.w	d1,d3
	bsr.w	CheckGameTickerStatus
	bsr.w	NewTicker3
	move.w	#$B4,d0
	bsr.w	waitxsr
	btst	#$7,d1
	bne.w	.loop14
	bsr.w	NewTickerErase
	move.w	#$3C,d0
	bsr.w	waitxsr
	btst	#$7,d1
	beq.w	.loop15
.loop14	bset	#$3,$17F6E.l
.loop15	movem.l	(sp)+,d0-d7/a0-a6
	rts
.next8	bsr.w	.next14
	bsr.w	.next11
	bra.w	.loop14
.next9	bsr.w	.next11
	bra.w	.loop15
.next10	jsr	(reenergizeteam).l
	bsr.w	setpersonel
	bsr.w	forcepldata
	st.b	$18(a2)
	bclr	#$7,$17F7C.l
	st.b	$1A(a2)
	st.b	$1C(a2)
	rts
.next11	move.w	$A(a0),d0
	cmp.w	$C(a0),d0
	bne.w	.next12
.loop16	btst	#$7,$FF800E.l
	bne.b	.loop16
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop17	btst	#$6,$FF800E.l
	beq.b	.loop17
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop18	btst	#$6,$FF800E.l
	bne.b	.loop18
	bclr	#$7,$FF800F.l
	andi.w	#$1,d0
	add.w	d0,$A(a0)
	eori.w	#$1,d0
	add.w	d0,$C(a0)
.next12	move.w	#$5,$8(a0)
	rts
.next13	move.w	#$557,d0
	movea.l	#$17F68,a1
	movea.l	#$C45C,a2
.loop19	move.w	(a1)+,(a2)+
	dbra	d0,.loop19
	move.w	$180F0.l,(a2)+
	rts
.next14	move.w	#$557,d0
	movea.l	#$17F68,a2
	movea.l	#$C45C,a1
.loop20	move.w	(a1)+,(a2)+
	dbra	d0,.loop20
	move.w	(a1)+,$180F0.l
	rts
DoHiLightsTbl1	dc.w	$0000,$FF10,$FFBA,$FF74,$0014,$FF92,$FF9C,$FFC4
	dc.w	$0019,$FFD8,$0046,$FFB0,$0000,$00F0,$0022,$005A
	dc.w	$FFC9,$0050,$0064,$0028,$FFF6,$000A,$FFCE,$0000
setpersonel
	movem.l	d0-d5/a0-a4,-(sp)
	movea.l	$22(a2),a3
	moveq	#$5,d4
.loop	st.b	$60(a3)
	st.b	$61(a3)
	adda.w	#$80,a3
	dbra	d4,.loop
	bsr.w	SetPlList
	moveq	#$5,d4
	movea.l	#$18AC6,a4
.loop2	clr.w	d5
	move.b	(a4,d4.w),d5
	beq.w	.next
	subi.w	#$1,d5
	moveq	#$5,d3
	movea.l	$22(a2),a3
	suba.w	#$80,a3
.loop3	adda.w	#$80,a3
	cmp.b	$66(a3),d5
	dbeq	d3,.loop3
	bne.w	.next
	move.b	$6(a4,d4.w),$60(a3)
	move.b	d5,$61(a3)
	clr.b	(a4,d4.w)
.next	dbra	d4,.loop2
	moveq	#$5,d4
	movea.l	#$18AC6,a4
.loop4	clr.w	d5
	move.b	(a4,d4.w),d5
	beq.w	.next3
	subi.w	#$1,d5
	moveq	#$5,d3
	movea.l	$22(a2),a3
	suba.w	#$80,a3
.loop5	adda.w	#$80,a3
	tst.b	$61(a3)
	dbmi	d3,.loop5
	bpl.w	.next2
	movea.l	a3,a0
.next2	tst.w	$34(a3)
	dbpl	d3,.loop5
	move.b	$6(a4,d4.w),$60(a0)
	move.b	d5,$61(a0)
	clr.b	(a4,d4.w)
.next3	dbra	d4,.loop4
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
	bpl.w	.next		;branch if theres a goalie
	adda.w	#$1,a0		;add 1 to a0
.next	lea.l	$16C(a2),a1		;loop: d5 = position, PlList slot = the line's player there (no player:
	move.w	$16(a2),d0		;current line selected
	asl.w	#$3,d0
	adda.w	d0,a1		;add to a1 to set a1 to currently selected line
	move.w	$26(a2),d4		;tmap - active players (4-6 in normal ROM)
	bra.w	.next2
.loop	clr.w	d5
	move.b	(a0,d4.w),d5		;move position into d5
	move.b	(a1,d5.w),(a4,d4.w)
	move.b	d5,$6(a4,d4.w)
	bne.w	.next2
	moveq	#$1,d3		;loop: replace injured or penalized players
	add.w	$28(a2),d3
	move.b	d3,(a4,d4.w)
.next2	dbra	d4,.loop
	moveq	#$5,d4		;now check to see if player is available
.loop2	move.b	(a4,d4.w),d3
	beq.w	.loop4
	ext.w	d3
	subi.w	#$1,d3
	add.w	d3,d3
	cmpi.w	#$FFFD,$68(a2,d3.w)		;injured or not on the bench: find a substitute from sublist
	beq.w	.next3
	cmpi.w	#$FFFC,$68(a2,d3.w)		;check if player injured for game
	beq.w	.next3
	tst.w	$68(a2,d3.w)
	ble.w	.loop4
.next3	lea.l	$16C(a2),a1		;now find a player of similar position who is available move Line Lists
	move.b	$6(a4,d4.w),d0		;move 6+a4+d4 into d0 (previous d5)
	ext.w	d0
	asl.w	#$1,d0
	movea.l	#$41A6C,a0		;move sublist into a0
	adda.w	(a0,d0.w),a0		;move a0+d0 into a0
.loop3	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	.next4
	move.b	(a1,d0.w),d0
	bsr.w	TryAddPlayerToList
	beq.w	.loop3
.loop4	dbra	d4,.loop2
	rts
.next4	jsr	(GetPlayerCount).l		;then try the players from d0 down
	move.w	d0,d3
.loop5	move.w	d3,d0		;d0 = candidate player number, d3 counts down
	subi.w	#$1,d3
	bmi.w	.loop4		;none available
	bsr.w	TryAddPlayerToList
	beq.w	.loop5
	bra.w	.loop4
TryAddPlayerToList						;d0 = player number (1 based), d4 = PlList slot. Put d0 in the slot if he
									;is on the bench or ice (not in the box, not injured) and not in PlList
									;yet; return d1 = 0 (Z set) if not
	move.w	d0,d1
	subi.w	#$1,d0
	add.w	d0,d0
	tst.w	$68(a2,d0.w)
	bgt.w	.next		;loop: is d1 already in PlList?
	cmpi.w	#$FFFD,$68(a2,d0.w)
	beq.w	.next
	cmpi.w	#$FFFC,$68(a2,d0.w)
	beq.w	.next
	moveq	#$5,d0
.loop	cmp.b	(a4,d0.w),d1
	dbeq	d0,.loop
	beq.w	.next
	move.b	d1,(a4,d4.w)
	rts
.next	clr.w	d1
	rts
SetupPenaltyShot						;Penalty shot set up for team a2 (called from puckpenshot): the shooter
									;loop over the team: shooter plays center, goalie stays, others leave
	movem.l	d0-d5/a0-a3,-(sp)
	movea.l	$22(a2),a3
	moveq	#$5,d4
.loop	move.w	$52(a3),d0
	cmp.w	$19368.l,d0
	beq.w	.next
	cmp.w	$1936A.l,d0
	beq.w	.next2
	bset	#$2,$63(a3)		;set player unavailable
	move.w	#$20,d0		;assgoaliebreakwait
	bsr.w	assreplace
	bra.w	.next4
.next	bsr.w	Setplass
	move.b	$61(a3),$17F9C.l
	move.b	$1936D.l,$61(a3)		;put the player on the ice
	move.w	#$4,$34(a3)
	bra.w	.next3
.next2	bsr.w	Setplass
	clr.w	$34(a3)
.next3	clr.w	d3		;next sort object
	move.b	$61(a3),d3
	add.w	d3,d3
	move.w	#$FFFF,$68(a2,d3.w)
	lsr.w	#$1,d3
	bsr.w	SetPlayerSide
.next4	st.b	$61(a3)
	st.b	$60(a3)
	adda.w	#$80,a3
	dbra	d4,.loop
	movem.l	(sp)+,d0-d5/a0-a3
	rts
forcepldata						;no skating on/off: force players to correct data (for faceoffs only). a2
									;= team struct
	movem.l	d0-d4/a0-a3,-(sp)
	movea.l	$22(a2),a3		;22 offset of team struct is tmsort (address of first sort obj)
	moveq	#$5,d4		;will run the loop 6 times
.loop	move.b	$60(a3),d0		;newpos = requested next pos of player
	ext.w	d0
	tst.w	$34(a3)
	bne.w	.next
	tst.w	d0		;set the position and its assignment; centers also get assnearest
	beq.w	.next
	move.w	$52(a3),-(sp)		;push SCNum to stack
	move.w	#$F,$52(a3)		;put F into SCNum
	jsr	$22DDE.l
	move.w	(sp)+,$52(a3)		;pop original SCNum back into SCNum
.next	move.w	d0,$34(a3)		;move newpos(d0) into position
	bmi.w	.next3		;put the requested player on the ice
	bsr.w	Setplass
	cmpi.w	#$4,$34(a3)
	bne.w	.next2
	moveq	#$11,d0
	bsr.w	AssistListPush
.next2	clr.w	d3		;d3 = requested player number
	move.b	$61(a3),d3		;next sort object
	add.w	d3,d3		;add d3 to itself
	move.w	#$FFFF,$68(a2,d3.w)		;move -1 into tmpdst
	lsr.w	#$1,d3		;divide d3 by 2
	bsr.w	SetPlayerSide
.next3	st.b	$61(a3)		;set newpnum to FF
	st.b	$60(a3)		;set newpos to FF
	adda.l	#$80,a3		;move to next sortobj (player struct)
	dbra	d4,.loop
	movem.l	(sp)+,d0-d4/a0-a3
	rts
ResetBench						;remove all players from penalty box / put all players on their own bench
									;(not the injured, -3 / -4). Counts the players left in the box in PBnum
									;(home in the high nibble). .rb runs for the home team, then falls in for
									;the visitors
	clr.b	$18068.l
	moveq	#$10,d1
	movea.l	#tmstruct,a0
	bsr.w	.next
	moveq	#$1,d1
	adda.w	#$366,a0		;change to Away Team
.next	moveq	#$32,d0		;$32 = (MaxRos-1)*2 = 50 decimal
.loop	add.b	d1,$18068.l
	tst.w	$68(a0,d0.w)
	ble.w	.next2
	btst	#$4,$68(a0,d0.w)		;test 3rd bit in tmpdst (4 decimal)
	beq.w	.next3		;not in the box: mark on the bench unless injured
	move.w	$68(a0,d0.w),d2		;move tmpdst into d2
	andi.w	#$7FF,d2		;mask 7FF with d2. Passes lowest 11 bits
	bne.w	.next3
	sub.b	d1,$18068.l
	bra.w	.next3
.next2	sub.b	d1,$18068.l
	cmpi.w	#$FFFD,$68(a0,d0.w)		;compare -3 with tmpdst
	beq.w	.next3
	cmpi.w	#$FFFC,$68(a0,d0.w)		;compare -4 with tmpdst
	beq.w	.next3
	move.w	#$FFFE,$68(a0,d0.w)		;move -2 into tmpdst
.next3	subi.w	#$2,d0		;previous roster entry
	bpl.w	.loop
	rts
Setplass						;set players (a3) initial assignment from .alist by position
	move.w	$34(a3),d0
	bmi.w	rtss2
	lea.l	.next(pc),a0
	move.b	(a0,d0.w),d0
	bra.w	assreplace
.next	dc.w	$0E02		;assgoalie
setplayer						;bring player onto the ice and set his attributes. d3 = offset of player
									;on roster, a3 = sortcord of player. Reads the roster bytes through
									;AttributeCalc (attribute number in TempWord2). Adds the PP / PK, home /
									;away and third period bonuses (team ScoutReport bytes) to some attributes
									;and clamps them with ClampNibble
	dc.w	$0203,$0503
	btst	d2,d0
