HotColdIcon						;The icon by the name of player iconplayer of team a2 at x iconx, y $19:
									;HotMap when he is awayhotplayer /
									;homehotplayer, ColdMap when awaycoldplayer / homecoldplayer, else
									;clear it (eraser)
	movem.l	d0/a0-a1,-(sp)
	movea.l	#$17EAC,a0
	move.w	#$2,$1AD8C.l
	cmpa.l	#$1834C,a2		;home team?
	bne.w	.next
	movea.l	#$17EAE,a0
	move.w	#$20,$1AD8C.l		;home: the home lists and column $20
.next	move.w	#$0,d0
.loop	move.w	(a0)+,d1		;1 hot player per team
	cmp.w	$1AD8A.l,d1
	beq.w	.next3
	dbra	d0,.loop
	movea.l	#$17EB0,a0
	cmpa.l	#$1834C,a2
	bne.w	.next2
	movea.l	#$17EB2,a0
.next2	move.w	#$0,d0
.loop2	move.w	(a0)+,d1
	cmp.w	$1AD8A.l,d1
	beq.w	.next4
	dbra	d0,.loop2
	move.w	$1AD8C.l,(printx).l
	move.w	#$19,(printy).l
	move.w	#$8,d0
	move.w	#$3,d1
	move.w	#$7FF,d2		;blank char
	jsr	(eraser).l
	bra.w	.next6
.next3	move.w	(hoticonchars).l,d4
	movea.l	(HotMap).l,a0
	bra.w	.next5
.next4	move.w	(coldiconchars).l,d4
	movea.l	(ColdMap).l,a0
.next5	move.w	$1AD8C.l,(printx).l
	move.w	#$19,(printy).l
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1		;a1 = map data
	movea.l	#$1B008,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	moveq	#$0,d5		;no palette lines
	jsr	(dobitmap).l
.next6	movem.l	(sp)+,d0/a0-a1
	rts
	btst	#$6,$17F74.l
	bne.w	HotColdIconExit
	movem.l	d0-d6/a0-a1,-(sp)
	move.w	$17BA8.l,d0
	asr.w	#$8,d0
	add.w	$17B80.l,d0
	move.w	$17BAA.l,d1
	asr.w	#$8,d1
	add.w	$17B94.l,d1
	movem.w	d0-d1,-(sp)
	moveq	#$5,d2
	move.w	d4,d3
	eori.w	#$2,d3
	moveq	#-1,d5
	movea.l	#$17480,a0
	movea.l	#$17FA6,a1
	cmpi.w	#$1,(a1,d4.w)
	beq.w	.next7
	adda.w	#$300,a0
.next7	movea.l	#$17F9E,a1
.loop3	tst.w	$34(a0)
	ble.w	.next10
	btst	#$2,$63(a0)
	bne.w	.next10
	movem.w	d1,-(sp)
	move.w	$52(a0),d1
	cmp.w	(a1,d4.w),d1
	movem.w	(sp)+,d1
	beq.w	.next8
	btst	#$3,$62(a0)
	bne.w	.next10
.next8	btst	#$2,$17F70.l
	beq.w	.next9
	movem.l	d0,-(sp)
	move.w	$19368.l,d0
	cmp.w	$52(a0),d0
	movem.l	(sp)+,d0
	beq.w	.next9
	movem.l	d0,-(sp)
	move.w	$1936A.l,d0
	cmp.w	$52(a0),d0
	movem.l	(sp)+,d0
	bne.w	.next10
.next9	btst	#$5,$62(a0)
	bne.w	.next10
	movem.w	(sp),d0-d1
	sub.w	$0(a0),d0
	muls.w	d0,d0
	sub.w	$14(a0),d1
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	d5,d0
	bhi.w	.next10
	move.w	$52(a0),d1
	cmp.w	(a1,d3.w),d1
	beq.w	.next10
	move.l	d0,d5
	move.w	d1,d6
.next10	adda.w	#$80,a0
	dbra	d2,.loop3
	adda.w	#$4,sp
	pea.l	$2B5FC.l
	cmp.w	(a1,d4.w),d6
	beq.w	HotColdIconExitSweepcheck
	move.w	d6,d0
	tst.w	d4
	beq.w	HotColdIconExitSetC1
	bra.w	HotColdIconExitSetC2
	movem.l	(sp)+,d0-d6/a0-a1
HotColdIconExit
	rts
; Stub: jumps to Sweepcheck
HotColdIconExitSweepcheck
	jmp	(Sweepcheck).l
; Stub: jumps to setc1player
HotColdIconExitSetC1
	jmp	(setc1player).l
; Stub: jumps to setc2player
HotColdIconExitSetC2
	jmp	(setc2player).l
	jsr	$37598.l
	move.w	#$D,d7
	jsr	$6044.w
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$60,d0
	jsr	$6044.w
	move.l	a0,$47DA0.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$47DA0.l,a1
	lea.l	FileLoadOrder.l,a2
	lea.l	FileLoadTable.l,a3
	move.w	#$8,d7
	jsr	$6044.w
	jsr	$37598.l
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$1,d0
	jsr	$6044.w
	move.l	a0,(ScoutCDArg).l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	(ScoutCDArg).l,a0
	move.l	a0,d0
	move.l	(a0)+,(SmallFontMap).l
	add.l	d0,(SmallFontMap).l
	move.l	(a0)+,$47D18.l
	add.l	d0,$47D18.l
	move.l	(a0)+,$47D40.l
	add.l	d0,$47D40.l
	move.l	(a0)+,$47D2C.l
	add.l	d0,$47D2C.l
	move.l	(a0)+,(BigFontMap).l
	add.l	d0,(BigFontMap).l
	move.l	(a0)+,$47D4C.l
	add.l	d0,$47D4C.l
	move.l	(a0)+,$47D34.l
	add.l	d0,$47D34.l
	move.l	(a0)+,$47D30.l
	add.l	d0,$47D30.l
	move.l	(a0)+,$47D1C.l
	add.l	d0,$47D1C.l
	move.l	(a0)+,$47D20.l
	add.l	d0,$47D20.l
	move.l	(a0)+,$47D44.l
	add.l	d0,$47D44.l
	move.l	(a0)+,(FramerMap).l
	add.l	d0,(FramerMap).l
	move.l	(a0)+,$47D58.l
	add.l	d0,$47D58.l
	move.l	(a0)+,$47D14.l
	add.l	d0,$47D14.l
	move.l	(a0)+,$47D28.l
	add.l	d0,$47D28.l
	move.l	(a0)+,(EASportsBGMap).l
	add.l	d0,(EASportsBGMap).l
	move.l	(a0)+,$47D64.l
	add.l	d0,$47D64.l
	move.l	(a0)+,$47D68.l
	add.l	d0,$47D68.l
	move.l	(a0)+,$47D6C.l
	add.l	d0,$47D6C.l
	move.l	(a0)+,$47D70.l
	add.l	d0,$47D70.l
	move.l	(a0)+,$47D80.l
	add.l	d0,$47D80.l
	move.l	(a0)+,$47D84.l
	add.l	d0,$47D84.l
	move.l	(a0)+,(HotMap).l
	add.l	d0,(HotMap).l
	move.l	(a0)+,(ColdMap).l
	add.l	d0,(ColdMap).l
	move.l	(a0)+,$47DA8.l
	add.l	d0,$47DA8.l
	lea.l	(TeamGfxListEnd).l,a2
	move.w	(HomeTeam).l,d0
	asl.w	#$2,d0
	movea.l	(a2,d0.w),a2
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	a2,d0
	jsr	$6044.w
	move.l	a0,$47D90.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$2,d0
	jsr	$6044.w
	move.l	a0,$47D24.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	move.w	#$2,d0
	jsr	$5F22.w
	rts
	move.w	#$2,d0
	jsr	$5F22.w
	bclr	#$5,$FF800F.l
	st.b	$1A556.l
	clr.l	$1AD46.l
	clr.l	$1AD4E.l
	clr.l	$1AD4A.l
	clr.l	$1AD52.l
	clr.w	$191CE.l
	jsr	$37598.l
	jsr	$376F2.l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	beq.s	.next
	move.w	#$1,-(a6)
	bra.s	.next2
.next	move.w	#$0,-(a6)
.next2	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	jsr	$2B614.l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.next3
	bset	#$5,$FF800F.l
	bra.s	.next4
.next3	bclr	#$5,$FF800F.l
.next4	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	jsr	$37752.l
	lea.l	$1746A.l,a0
	move.w	#$10,d0
	jsr	$5F22.w
	move.w	#$2,d0
	jsr	$5F22.w
.loop	move.w	#$80,d0
	jsr	$5F22.w
	bcs.w	.loop
.loop2	move.w	#$81,d0
	jsr	$5F22.w
	move.w	(a0),d2
	andi.w	#$FF00,d2
	cmpi.w	#$0,d2
	bne.b	.loop2
	move.w	#$5,$19364.l
	move.w	#$13,d0
	lea.l	$19364.l,a0
	jsr	$5F22.w
	jsr	(ReadJoy1).l
	cmpi.b	#$E0,d3
	bne.w	.next5
	move.w	#$3,$18C02.l
.next5	clr.b	$17F68.l
	cmpi.w	#$1,$18C08.l
	bne.w	.next6
	bset	#$5,$17F68.l
.next6	cmpi.w	#$1,$18BFA.l
	ble.w	.next7
	bsr.w	.next9
.next7	jsr	(clearTeamStats).l
	btst	#$0,$17F78.l
	beq.w	.next8
	move.l	a0,-(sp)
	movea.l	#tmstruct,a0
	jsr	(Create_HotCold_Table).l
	movea.l	#awtmstruct,a0
	jsr	(Create_HotCold_Table).l
	movea.l	(sp)+,a0
.next8	clr.w	$180F0.l
	clr.w	$1825A.l
	clr.w	$180E4.l
	clr.w	$180EC.l
	bsr.w	restoreteams
	jsr	(InitScores).l
	jsr	$3E91C.l
	jsr	(LoadCrowdRec).l
	jmp	$35A94.l
.next9	move.w	#$71,d0
	movea.l	#$18C42,a0
.loop3	clr.w	(a0)+
	dbra	d0,.loop3
	rts
restoreteams						;Put both teams' rosters on the bench
	movea.l	#tmstruct,a2
	bsr.w	.r
	adda.w	#$366,a2
.r	move.w	#$6,$26(a2)
	moveq	#$32,d0
.0	move.w	#$FFFE,$68(a2,d0.w)
	subi.w	#$2,d0
	bpl.w	.0
	rts
ResetClock						;set period length and stop clock
	bsr.w	GetPeriodTime
	cmpi.w	#$3,$180E4.l
	blt.w	.next
	tst.w	$18BFA.l
	bne.w	.next
	move.w	#$258,d0
.next	move.w	d0,$180E6.l
	move.w	d0,$180EA.l
	move.w	d0,$1747E.l
	asr.w	#$1,d0
	jsr	(randomd0).l
	sub.w	d0,$1747E.l
	bset	#$0,$17F68.l
	rts
GetPeriodTime						;Return d0 = period length in seconds for the period length option
	move.w	$18C02.l,d0
	asl.w	#$1,d0
	lea.l	.next(pc),a0
	move.w	(a0,d0.w),d0
	rts
.next	dc.w	$012C,$0258,$04B0,$001E
	bclr	#$5,$FF800F.l
	move.w	#$FFFF,(palcount).l
	move.w	#$8400,d1
	move.w	#$85,d0
	jsr	$5F22.w
	cmpi.w	#$3,$180E4.l
	bne.w	.next2
	bset	#$1,$17F7A.l
.next2	st.b	$1A560.l
	jsr	$47DAC.l
	jsr	$3E91C.l
	bsr.w	ResetClock
	dc.w	$0079,$F000,$0001,$7DC8
	st.b	$17F9E.l
	st.b	$17FA0.l
	movea.l	#$17B80,a3
	clr.w	$17EE2.l
	clr.w	$17EE4.l
	btst	#$0,$17F78.l
	beq.w	Gameloop
	move.w	#$1E,d0
	move.w	#$8,$1936C.l
	move.w	#$B,$1936A.l
	bra.w	GameloopStart
Gameloop						;Main loop for game
	moveq	#$1B,d0
; Start of the game loop: replaces the assist, sets the flags and the frame vector
GameloopStart	jsr	(assreplace).l
	bset	#$2,$17F6C.l
	bclr	#$4,$17F6A.l
	move.w	#$FFFF,(lastsfx).l
	move.l	#$C45C,$17470.l
	move.w	(ScoutSubStatus).l,$17476.l
	bsr.w	DoGameFrame
	move.w	#$FFFF,(palcount).l
	bsr.w	DoGameFrame
	move.w	$18A9E.l,d0
	asl.w	#$4,d0
	move.w	d0,$17CD8.l
	clr.w	$17F8C.l
	move.w	(HomeTeam).l,$1A56C.l
	move.w	#$0,$1A56E.l
	jsr	(ChooseSong).l
	move.w	$1A56A.l,-(sp)
	jsr	(song).l
	move.w	$1745E.l,$19364.l
	movea.l	$FF8000.l,a5
	move.w	#$12,d0
	lea.l	$19364.l,a0
	jsr	$5F22.w
	move.w	#$FFFF,$1745C.l
	move.w	#$0,$17460.l
	cmpi.w	#$2,$180E4.l
	bge.w	.loop
	bset	#$7,$17F6E.l
.loop	jsr	$37206.l
	bsr.w	DoGameFrame
	bsr.w	demoread
	btst	#$0,$17F6A.l
	beq.w	.loop
	bsr.w	Pausemode
	bra.w	.loop
DoGameFrame						;wait for at least one vblank, then run one frame of game logic
	move.w	(ScoutSubStatus).l,d7
	sub.w	$17476.l,d7
	beq.w	DoGameFrame
	move.w	(ScoutSubStatus).l,$17476.l
	bsr.w	periodicevents
	bsr.w	updateplayers
	tst.w	$1AD6E.l
	beq.w	.nosong
	bmi.w	.nosong
	subi.w	#$1,$1AD6E.l
	bne.w	.nosong
	jsr	$47DB0.l
	move.w	$1AD70.l,-(sp)
	jsr	(song).l
.nosong	jsr	$25000.l
	bsr.w	checkwindow
	bsr.w	updatereplay
	jmp	(setvideo).l
periodicevents						;Called every time thru game loop with d7 = elapsed frames
	jsr	(PenaltyManager).l
	bsr.w	updatecrowdf
	jsr	(RunArenaAnim).l
	jsr	(updatesound).l
	bsr.w	clockcont
	btst	#$7,$17F6A.l
	bne.w	updatereplayExit
	sub.w	d7,$1747C.l
	bpl.w	updatereplayExit
	addi.w	#$18,$1747C.l
	jsr	(ChkGoalies).l
	bsr.w	UpdateCwdExcite
	bsr.w	CheckLateGameSong
	bsr.w	RestoreBenchEnergy
	bsr.w	.next
	jmp	(updatepwrplay).l
.next	subi.w	#$1,$1806A.l
	bne.w	updatereplayExit
	jmp	$40D50.l
RestoreBenchEnergy						;Called once per second. Restore energy for players on the bench
	tst.w	$18C0A.l
	bne.w	.ex
	movea.l	#tmstruct,a2
	bsr.w	.notinprog
	lea.l	$366(a2),a2
.notinprog	moveq	#$32,d0
.b0	cmpi.w	#$FFFE,$68(a2,d0.w)
	bne.w	.next
	addi.w	#$9,$34(a2,d0.w)
	cmpi.w	#$1000,$34(a2,d0.w)
	blt.w	.next
	move.w	#$1000,$34(a2,d0.w)
.next	subi.w	#$2,d0
	bpl.w	.b0
.ex	rts
CheckLateGameSong						;Called once per second. 3rd period: choose and play a song once at the
	
	cmpi.w	#$2,$180E4.l
	bne.w	.ex
	btst	#$4,$17F68.l
	bne.w	.ex
	move.w	$180E6.l,d0
	cmp.w	$1747E.l,d0
	bgt.w	.ex
	st.b	$1747E.l
	move.w	(HomeTeam).l,$1A56C.l
	move.w	#$5,$1A56E.l
	jsr	(ChooseSong).l
	move.w	$1A56A.l,-(sp)
	jsr	(song).l
.ex	rts
UpdateCwdExcite						;called once per second. Track peak and running total of crowd excitement,
	
	
	move.w	$17CD8.l,d0
	cmp.w	$17CDA.l,d0
	bls.w	.next
	move.w	d0,$17CDA.l
.next	ext.l	d0
	add.l	d0,$17CDE.l
	addi.w	#$1,$17CDC.l
	subi.w	#$1,$17CD8.l
	bpl.w	.ex
	clr.w	$17CD8.l
.ex	rts
updatecrowdf						;this is called every game loop with d7 = elapsed frames this will update
	
	cmpi.w	#$15E,(Crowdlevel).l
	blt.w	.dec
	subi.w	#$3,(Crowdlevel).l
.dec	sub.w	d7,(Crowdlevel).l
	bpl.w	.0
	clr.w	(Crowdlevel).l
.0	sub.w	d7,(Crowdcnt).l
	bpl.w	.cf
	move.w	(Crowdlevel).l,d0
	lsr.w	#$1,d0
	cmpi.w	#$7F,d0
	bls.w	.1
	moveq	#$7F,d0
.1	andi.w	#$60,d0
	addi.w	#$2,(Crowdstep).l
	andi.w	#$1E,(Crowdstep).l
	add.w	(Crowdstep).l,d0
	movea.l	#$4154C,a0
	move.b	(a0,d0.w),$17CD1.l
	clr.w	d1
	move.b	$1(a0,d0.w),d1
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	move.w	$FF8010.l,d2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	and.w	d1,d2
	add.w	d2,d1
	move.w	d1,(Crowdcnt).l
.cf	clr.b	(Crowdframe).l
	cmpi.w	#$118,(Crowdlevel).l
	bls.w	updatereplayExit
.loop4	btst	#$7,$FF800E.l
	bne.b	.loop4
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop5	btst	#$6,$FF800E.l
	beq.b	.loop5
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	bne.b	.loop6
	bclr	#$7,$FF800F.l
	andi.w	#$7F,d0
	cmpi.w	#$13,d0
	blt.w	updatereplayExit
	cmpi.w	#$19,d0
	bgt.w	updatereplayExit
	move.b	d0,(Crowdframe).l
	rts
clockcont						;monitor period clock and initiate various clock activated events
	btst	#$0,$17F68.l
	bne.w	updatereplayExit
	tst.w	$180E6.l
	bne.w	updatereplayExit
	bset	#$3,(disflags).l
	jsr	$47DB0.l
	move.w	#$4,-(sp)
	jsr	(sfx).l
	bsr.w	freezewindow
; clockcont: pushes the assist list and carries on
clockcontAssists						;End of period. Also entered from puckfaceoff
	movea.l	#$17B80,a3
	move.l	#$18,d0
	jsr	(AssistListPush).l
	cmpi.w	#$2,$180E4.l
	blt.w	.next5
	move.l	#$7,d0
	movea.l	#$17480,a3
	cmpi.w	#$3,$18A9E.l
	bne.w	.next3
	cmpi.w	#$7,$18A9C.l
	beq.w	.next2
	moveq	#$10,d3
	mulu.w	$18A98.l,d3
	movea.l	#$18A18,a0
	adda.w	d3,a0
	clr.w	d3
	btst	#$0,$E(a0)
	beq.w	.next
	eori.w	#$2,d3
.next	move.w	$18358.l,d1
	sub.w	$186BE.l,d1
	bpl.w	.ns1
	eori.w	#$2,d3
.ns1	cmpi.w	#$3,$4(a0,d3.w)
	bne.w	.next3
.next2	move.l	#$8,d0
	moveq	#$B,d2
.t0	bclr	#$3,$62(a3)
	adda.w	#$80,a3
	dbra	d2,.t0
	movea.l	#$17480,a3
.next3	moveq	#$5,d2
	move.w	$18358.l,d1
	sub.w	$186BE.l,d1
	beq.w	.next5
	bpl.w	.t2
	adda.w	#$300,a3
.t2	tst.w	$34(a3)
	ble.w	.next4
	jsr	(AssistListPush).l
	move.l	#$7,d0
.next4	adda.w	#$80,a3
	dbra	d2,.t2
.eog	jsr	(ClearPenaltyBuffer).l
	addi.w	#$3E8,(Crowdlevel).l
	bset	#$0,$17F68.l
	bset	#$6,$17F68.l
	jsr	(ClearPenalties).l
	move.w	#$4,d0
	jmp	(AddPenalty2).l
.next5	cmpi.w	#$3,$180E4.l
	bne.w	.next6
	tst.w	$18BFA.l
	beq.w	.eog
.next6	move.w	#$2,d0
	jmp	(AddPenalty2).l
demoread						;monitor joystick if in demo mode (called every game loop)
	tst.w	$17FA6.l
	bne.w	updatereplayExit
	tst.w	$17FA8.l
	bne.w	updatereplayExit
	jsr	(ReadJoy1).l
	btst	#$7,d1
	bne.w	EndDemoExitMode0Off
	bsr.w	EndDemoOnPress
	jsr	(ReadJoy2).l
	btst	#$7,d1
	bne.w	EndDemoExitMode0On
	tst.w	$18BF8.l
	beq.w	EndDemoOnPress
	jsr	$3752C.l
	btst	#$7,d1
	bne.w	EndDemoExitMode3Off
	bsr.w	EndDemoOnPress
	jsr	$3754A.l
	btst	#$7,d1
	bne.w	EndDemoExitMode4On
EndDemoOnPress						;Any button on the pad just read (d1) ends the demo
	tst.w	d1
	beq.w	updatereplayExit
	jmp	$3F2BE.l
; Demo end code 0, flag 1 cleared
EndDemoExitMode0Off
	clr.w	$17F94.l
	bclr	#$1,$17F6A.l
	bra.w	EndDemoExitFinish
; Demo end code 0, flag 1 set
EndDemoExitMode0On
	clr.w	$17F94.l
	bset	#$1,$17F6A.l
; Sets the demo end flag and returns
EndDemoExitFinish	bset	#$0,$17F6A.l
	rts
; Demo end code 3, flag 1 cleared
EndDemoExitMode3Off
	move.w	#$3,$17F94.l
	bclr	#$1,$17F6A.l
	bra.w	EndDemoExitFinish
; Demo end code 4, flag 1 set
EndDemoExitMode4On
	move.w	#$4,$17F94.l
	bset	#$1,$17F6A.l
	bra.w	EndDemoExitFinish
Pausemode	jsr	(forceblack).l
	move.w	d0,-(sp)
	move.w	(ScoutSubStatus).l,d0
.loop	cmp.w	(ScoutSubStatus).l,d0
	beq.w	.loop
	move.w	(sp)+,d0
	jsr	$47DAC.l
	move.w	$17F6A.l,-(sp)
	bsr.w	seta2
	movea.l	#$41F50,a0
	lea.l	.next5(pc),a1
	btst	#$0,$17F78.l
	beq.w	.next
	movea.l	#$41EB4,a0
	bra.w	.next2
.next	btst	#$2,$32(a2)
	beq.w	.next2
	movea.l	#$420DC,a0
.next2	bsr.w	SetMenuScreenHandler
.loop2	bsr.w	MenuWaitVblank
	bsr.w	ReadActiveJoypad
	jsr	(showclock).l
	jsr	(ProcessInputWithRepeat).l
	bsr.w	HandleMenuInput
	bne.w	.loop2
	jsr	(forceblack).l
	move.w	(sp)+,$17F6A.l
	btst	#$7,$17F6A.l
	beq.w	.next3
	jsr	$3ECB8.l
	jsr	(SetHor).l
	bra.w	.next4
.next3	jsr	(ClrHor).l
.next4	movea.l	#$C00000,a0
.loop3	btst	#$7,$FF800E.l
	bne.b	.loop3
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop4	btst	#$6,$FF800E.l
	beq.b	.loop4
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop5	btst	#$6,$FF800E.l
	bne.b	.loop5
	bclr	#$7,$FF800F.l
.loop6	btst	#$7,$FF800E.l
	bne.b	.loop6
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop7	btst	#$6,$FF800E.l
	beq.b	.loop7
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop8	btst	#$6,$FF800E.l
	bne.b	.loop8
	bclr	#$7,$FF800F.l
	bset	#$3,(disflags).l
	bclr	#$0,$17F6A.l
	jsr	(printscores1).l
	jsr	(setvideo).l
	move.w	#$18,(palcount).l
.loop9	tst.w	(palcount).l
	bpl.w	.loop9
	move.w	(ScoutSubStatus).l,$17476.l
	rts
.next5	movea.l	#$C00000,a0
.loop10	btst	#$7,$FF800E.l
	bne.b	.loop10
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop11	btst	#$6,$FF800E.l
	beq.b	.loop11
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop12	btst	#$6,$FF800E.l
	bne.b	.loop12
	bclr	#$7,$FF800F.l
.loop13	btst	#$7,$FF800E.l
	bne.b	.loop13
	move.w	#$921C,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop14	btst	#$6,$FF800E.l
	beq.b	.loop14
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop15	btst	#$6,$FF800E.l
	bne.b	.loop15
	bclr	#$7,$FF800F.l
	jsr	(SetHor).l
	jsr	(setvideo).l
	jsr	$48208.l
	jsr	(printsmallz).l
	dc.w	$0008
	dc.b	$FF,$03,$FD,$00,$FC,$00
	moveq	#$20,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	jmp	(eraser).l
seta2						;Set a2 to the team struct of the pause joystick also called from
	
	movea.l	#tmstruct,a2
	btst	#$1,$17F6A.l
	beq.w	.next
	cmpi.w	#$1,$17FA8.l
	bra.w	.seta21
.next	cmpi.w	#$1,$17FA6.l
.seta21	beq.w	.x
	adda.w	#$366,a2
.x	rts
; Stores the menu handler pointers and clears the cursor.
SetMenuScreenHandler
	move.l	a0,$18AD6.l
	move.l	a1,$18ADA.l
	clr.w	$18AD2.l
	clr.w	$18AD4.l
DrawMenuScreen						;Call the draw routine, frame the menu box, print the items and fade in.
	
	movea.l	$18ADA.l,a0
	jsr	(a0)
	jsr	(printsmallz).l
	String	CC_Font2,$4,$FC,$C
	bsr.w	SetMenuPrintX
	moveq	#$16,d0
	moveq	#$6,d1
	jsr	(Framer).l
	bsr.w	Pausemode_Pmenu
	move.w	#$18,(palcount).l
.loop	tst.w	(palcount).l
	bpl.w	.loop
	rts
SetMenuPrintX						;printx = the left edge of the menu box: 5 in 32 column mode, else 9
	move.w	#$5,(printx).l
	btst	#$1,(disflags).l
	bne.w	updatereplayExit
	addi.w	#$4,(printx).l
	rts
HandleMenuInput						;Act on the pad bits d1 for the current menu: down / up move the
	
	
	
	
	btst	#$7,d1
	bne.w	.next5
	btst	#$1,d1
	beq.w	.next
	addi.w	#$1,$18AD2.l
	bra.w	Pausemode_Pmenu
.next	btst	#$0,d1
	beq.w	.next2
	subi.w	#$1,$18AD2.l
	bra.w	Pausemode_Pmenu
.next2	btst	#$5,d1
	beq.w	.next5
	bsr.w	seta2
	move.w	$18AD2.l,d0
	movea.l	$18AD6.l,a0
	adda.w	(a0),a0
	adda.w	(a0),a0
	bra.w	.next3
.loop	adda.w	#$4,a0
.next3	adda.w	(a0),a0
	dbra	d0,.loop
	movea.l	(a0),a0
	jsr	(a0)
	bclr	#$1,$17F74.l
	bne.w	.next4
	bsr.w	DrawMenuScreen
.next4	tst.w	$18AD2.l		;item 0 (resume) leaves the menu
	rts
.next5	eori.b	#$4,ccr		;invert Z
	rts
