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
; Table of 4 words after GetPeriodTime, 8 bytes: $012C,$0258,$04B0,$001E ...
.next	dc.w	$012C,$0258,$04B0,$001E
; Period time screen set-up: sets the palette count and the gate command.
GetPeriodTimeSetup
	bclr	#$5,$FF800F.l
	move.w	#$FFFF,(palcount).l
	move.w	#$8400,d1
	move.w	#$85,d0
	jsr	$5F22.w
	cmpi.w	#$3,$180E4.l
	bne.w	.next2
	bset	#$1,$17F7A.l
.next2	st.b	$1A560.l
	jsr	(HockeyRtsStubA).l
	jsr	(UpdateSoundVdpSetup).l
	bsr.w	ResetClock
; Inline data read by ResetClock from the return address (1 row).
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
.loop	jsr	(SongCdCheck).l
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
	jsr	(HockeyRtsStubB).l
	move.w	$1AD70.l,-(sp)
	jsr	(song).l
.nosong	jsr	(PlayerCardDrawStats).l
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
	jmp	(CalcTeamStarScoresPrint).l
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
	jsr	(HockeyRtsStubB).l
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
	jsr	(ReadJoy3).l
	btst	#$7,d1
	bne.w	EndDemoExitMode3Off
	bsr.w	EndDemoOnPress
	jsr	(ReadJoy4).l
	btst	#$7,d1
	bne.w	EndDemoExitMode4On
EndDemoOnPress						;Any button on the pad just read (d1) ends the demo
	tst.w	d1
	beq.w	updatereplayExit
	jmp	(GameOverCheckScroll).l
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
	jsr	(HockeyRtsStubA).l
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
	jsr	(IceRinkRemapGfxA).l
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
	jsr	(HockeyRtsStubC).l
	jsr	(printsmallz).l
; Inline data read by printsmallz from the return address (2 rows).
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