restoreteams						;Put both teams' rosters on the bench
	movea.l	#tmstruct,a2
	bsr.w	.r
	adda.w	#tmsize,a2
.r	move.w	#$6,tmap(a2)
	moveq	#$32,d0
.0	move.w	#$FFFE,tmpdst(a2,d0.w)
	subi.w	#$2,d0
	bpl.w	.0
	rts
ResetClock						;set period length and stop clock
	bsr.w	GetPeriodTime
	cmpi.w	#$3,(gsp).l
	blt.w	.0
	tst.w	(OptPlayMode).l
	bne.w	.0
	move.w	#$258,d0
.0	move.w	d0,(gameclock).l
	move.w	d0,(PerTimeTotal).l
	move.w	d0,(periodendtime).l
	asr.w	#$1,d0
	jsr	(randomd0).l
	sub.w	d0,(periodendtime).l
	bset	#gmclock,(gmode).l
	rts
GetPeriodTime						;Return d0 = period length in seconds for the period length option
	move.w	(Optperlen).l,d0
	asl.w	#$1,d0
	lea.l	.timetab(pc),a0
	move.w	(a0,d0.w),d0
	rts
; Table of 4 words after GetPeriodTime, 8 bytes: $012C,$0258,$04B0,$001E ...
.timetab	dc.w	$012C,$0258,$04B0,$001E
; Period time screen set-up: sets the palette count and the gate command.
GetPeriodTimeSetup
	bclr	#$5,(GA_COMFLAGS+1).l
	move.w	#$FFFF,(palcount).l
	move.w	#$8400,d1
	move.w	#$85,d0
	jsr	$5F22.w
StartPer
	cmpi.w	#$3,(gsp).l
	bne.w	.next2
	bset	#$1,(sflags7).l
.next2	st.b	(faceoffanim).l
	jsr	(p_turnoff).l
	jsr	(setupice).l
	bsr.w	ResetClock
	ori.w	#$F000,(PadControlBits).l
	st.b	(c1playernum).l
	st.b	(c2playernum).l
	movea.l	#puckx,a3
	clr.w	(fox).l
	clr.w	(foy).l
	btst	#$0,(gmode2).l
	beq.w	StartPer_fo
	move.w	#$1E,d0
	move.w	#$8,(BA_Skater_Offset).l
	move.w	#$B,(BA_Goalie_SCnum).l
	bra.w	GameloopStart
StartPer_fo						;Main loop for game
	moveq	#$1B,d0
; Start of the game loop: replaces the assist, sets the flags and the frame vector
GameloopStart	jsr	(assreplace).l
	bset	#$2,(sflags2).l
	bclr	#$4,(sflags).l
	move.w	#$FFFF,(lastsfx).l
	move.l	#$C45C,(recbpr).l
	move.w	(Vcount).l,(OldVcount).l
	bsr.w	DoGameFrame
	move.w	#$FFFF,(palcount).l
	bsr.w	DoGameFrame
	move.w	(gamelevel).l,d0
	asl.w	#$4,d0
	move.w	d0,(CwdExciteLvl).l
	clr.w	(CurCrowdMeter).l
	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#$0,(SongIndex).l
	jsr	(ChooseSong).l
	move.w	(SongNum).l,-(sp)
	jsr	(song).l
	move.w	(CdSongTrack).l,(CdCommandArg).l
	movea.l	(GA_RESET).l,a5
	move.w	#$12,d0
	lea.l	(CdCommandArg).l,a0
	jsr	$5F22.w
	move.w	#$FFFF,(CdSongPending).l
	move.w	#$0,(SubVblankCount).l
	cmpi.w	#$2,(gsp).l
	bge.w	Gameloop
	bset	#sf3fosong,(sflags3).l		;set for periods 1 and 2 only
Gameloop							;Main loop for game. The disc adds the SongCdCheck call at the top of the loop
	jsr	(SongCdCheck).l
	bsr.w	DoGameFrame
	bsr.w	demoread		;check if demo mode
	btst	#sfpz,(sflags).l
	beq.w	Gameloop		;the cartridge uses beq.s
	bsr.w	Pausemode
	bra.w	Gameloop		;the cartridge uses bra.s
DoGameFrame						;wait for at least one vblank, then run one frame of game logic
	move.w	(Vcount).l,d7
	sub.w	(OldVcount).l,d7
	beq.w	DoGameFrame
	move.w	(Vcount).l,(OldVcount).l
	bsr.w	periodicevents
	bsr.w	updateplayers
	tst.w	(songdelay).l
	beq.w	.nosong
	bmi.w	.nosong
	subi.w	#$1,(songdelay).l
	bne.w	.nosong
	jsr	(stop_current_song).l
	move.w	(delayedsong).l,-(sp)
	jsr	(song).l
.nosong	jsr	(setSlotBit).l
	bsr.w	checkwindow
	bsr.w	updatereplay
	jmp	(setvideo).l
periodicevents						;Called every time thru game loop with d7 = elapsed frames
	jsr	(PenaltyManager).l
	bsr.w	updatecrowdf
	jsr	(RunArenaAnim).l
	jsr	(updatesound).l
	bsr.w	clockcont
	btst	#sfhor,(sflags).l
	bne.w	rtss8
	sub.w	d7,(lldisp).l
	bpl.w	rtss8
	addi.w	#jps,(lldisp).l
	jsr	(ChkGoalies).l
	bsr.w	UpdateCwdExcite
	bsr.w	CheckLateGameSong
	bsr.w	RestoreBenchEnergy
	bsr.w	CheckInjury
	jmp	(updatepwrplay).l
CheckInjury	subi.w	#$1,(InjCntDown).l
	bne.w	rtss8
	jmp	(ShowInjuryBox).l
RestoreBenchEnergy						;Called once per second. Restore energy for players on the bench
	tst.w	(OptLine).l
	bne.w	.ex
	movea.l	#tmstruct,a2
	bsr.w	.notinprog
	lea.l	$366(a2),a2
.notinprog	moveq	#$32,d0
.b0	cmpi.w	#$FFFE,tmpdst(a2,d0.w)
	bne.w	.next
	addi.w	#$9,tmpde(a2,d0.w)
	cmpi.w	#$1000,tmpde(a2,d0.w)
	blt.w	.next
	move.w	#$1000,tmpde(a2,d0.w)
.next	subi.w	#$2,d0
	bpl.w	.b0
.ex	rts
CheckLateGameSong						;Called once per second. 3rd period: choose and play a song once at the
	
	cmpi.w	#$2,(gsp).l
	bne.w	.x
	btst	#gmhl,(gmode).l
	bne.w	.x
	move.w	(gameclock).l,d0
	cmp.w	(periodendtime).l,d0
	bgt.w	.x
	st.b	(periodendtime).l
	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#$5,(SongIndex).l
	jsr	(ChooseSong).l
	move.w	(SongNum).l,-(sp)
	jsr	(song).l
.x	rts
UpdateCwdExcite						;called once per second. Track peak and running total of crowd excitement,
	
	
	move.w	(CwdExciteLvl).l,d0
	cmp.w	(MaxCwdExciteLvl).l,d0
	bls.w	.less
	move.w	d0,(MaxCwdExciteLvl).l
.less	ext.l	d0
	add.l	d0,(SumCwdExciteLvl).l
	addi.w	#$1,(NumCwdExciteLvl).l
	subi.w	#$1,(CwdExciteLvl).l
	bpl.w	.ex
	clr.w	(CwdExciteLvl).l
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
	movea.l	#updatecrowdf_cd0,a0
	move.b	(a0,d0.w),(Crowdframe+1).l
	clr.w	d1
	move.b	$1(a0,d0.w),d1
.loop	btst	#$7,(GA_COMFLAGS).l
	bne.b	.loop
	move.w	#$1B,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.loop2	btst	#$6,(GA_COMFLAGS).l
	beq.b	.loop2
	move.w	(GA_COMCMD0).l,d2
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.loop3	btst	#$6,(GA_COMFLAGS).l
	bne.b	.loop3
	bclr	#$7,(GA_COMFLAGS+1).l
	and.w	d1,d2
	add.w	d2,d1
	move.w	d1,(Crowdcnt).l
.cf	clr.b	(Crowdframe).l
	cmpi.w	#$118,(Crowdlevel).l
	bls.w	rtss8
.loop4	btst	#$7,(GA_COMFLAGS).l
	bne.b	.loop4
	move.w	#$1B,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.loop5	btst	#$6,(GA_COMFLAGS).l
	beq.b	.loop5
	move.w	(GA_COMCMD0).l,d0
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.loop6	btst	#$6,(GA_COMFLAGS).l
	bne.b	.loop6
	bclr	#$7,(GA_COMFLAGS+1).l
	andi.w	#$7F,d0
	cmpi.w	#$13,d0
	blt.w	rtss8
	cmpi.w	#$19,d0
	bgt.w	rtss8
	move.b	d0,(Crowdframe).l
	rts
clockcont						;monitor period clock and initiate various clock activated events
	btst	#gmclock,(gmode).l
	bne.w	rtss8
	tst.w	(gameclock).l
	bne.w	rtss8
	bset	#dfclock,(disflags).l
	jsr	(stop_current_song).l
	move.w	#$4,-(sp)
	jsr	(sfx).l
	bsr.w	freezewindow
; clockcont: pushes the assist list and carries on
clockcont_0						;End of period. Also entered from puckfaceoff
	movea.l	#puckx,a3
	move.l	#$18,d0
	jsr	(assinsert).l
	cmpi.w	#$2,(gsp).l
	blt.w	.next5
	move.l	#$7,d0
	movea.l	#SortCords,a3
	cmpi.w	#$3,(gamelevel).l
	bne.w	.next3
	cmpi.w	#$7,(bosgames).l
	beq.w	.next2
	moveq	#$10,d3
	mulu.w	(gamenum).l,d3
	movea.l	#gstruct,a0
	adda.w	d3,a0
	clr.w	d3
	btst	#$0,$E(a0)
	beq.w	.next
	eori.w	#$2,d3
.next	move.w	(HmGoals).l,d1
	sub.w	(AwGoals).l,d1
	bpl.w	.ns1
	eori.w	#$2,d3
.ns1	cmpi.w	#$3,$4(a0,d3.w)
	bne.w	.next3
.next2	move.l	#$8,d0
	moveq	#$B,d2
.t0	bclr	#$3,$62(a3)
	adda.w	#$80,a3
	dbra	d2,.t0
	movea.l	#SortCords,a3
.next3	moveq	#$5,d2
	move.w	(HmGoals).l,d1
	sub.w	(AwGoals).l,d1
	beq.w	.next5
	bpl.w	.t2
	adda.w	#$300,a3
.t2	tst.w	$34(a3)
	ble.w	.next4
	jsr	(assinsert).l
	move.l	#$7,d0
.next4	adda.w	#$80,a3
	dbra	d2,.t2
.eog	jsr	(ClearPenaltyBuffer).l
	addi.w	#$3E8,(Crowdlevel).l
	bset	#$0,(gmode).l
	bset	#$6,(gmode).l
	jsr	(ClearPenalties).l
	move.w	#$4,d0
	jmp	(AddPenalty2).l
.next5	cmpi.w	#$3,(gsp).l
	bne.w	.next6
	tst.w	(OptPlayMode).l
	beq.w	.eog
.next6	move.w	#$2,d0
	jmp	(AddPenalty2).l
demoread						;monitor joystick if in demo mode (called every game loop)
	tst.w	(cont1team).l
	bne.w	rtss8
	tst.w	(cont2team).l
	bne.w	rtss8
	jsr	(ReadJoy1).l
	btst	#sbut,d1
	bne.w	startpause1
	bsr.w	EndDemoOnPress
	jsr	(ReadJoy2).l
	btst	#$7,d1
	bne.w	startpause2
	tst.w	(FourWayPlay).l
	beq.w	EndDemoOnPress
	jsr	(ReadJoy3).l
	btst	#$7,d1
	bne.w	startpause3
	bsr.w	EndDemoOnPress
	jsr	(ReadJoy4).l
	btst	#$7,d1
	bne.w	startpause4
EndDemoOnPress						;Any button on the pad just read (d1) ends the demo
	tst.w	d1
	beq.w	rtss8
	jmp	(GameOverCheckScroll).l
; Demo end code 0, flag 1 cleared
startpause1
	clr.w	(pausepad).l
	bclr	#$1,(sflags).l
	bra.w	startpause
; Demo end code 0, flag 1 set
startpause2
	clr.w	(pausepad).l
	bset	#$1,(sflags).l
; Sets the demo end flag and returns
startpause	bset	#$0,(sflags).l
	rts
; Demo end code 3, flag 1 cleared
startpause3
	move.w	#$3,(pausepad).l
	bclr	#$1,(sflags).l
	bra.w	startpause
; Demo end code 4, flag 1 set
startpause4
	move.w	#$4,(pausepad).l
	bset	#$1,(sflags).l
	bra.w	startpause
Pausemode	jsr	(forceblack).l
	move.w	d0,-(sp)
	move.w	(Vcount).l,d0
.vb	cmp.w	(Vcount).l,d0
	beq.w	.vb
	move.w	(sp)+,d0
	jsr	(p_turnoff).l
	move.w	(sflags).l,-(sp)
	bsr.w	seta2
	movea.l	#Pausemode_mlist,a0
	lea.l	PausemodeVdpFill(pc),a1
	btst	#$0,(gmode2).l
	beq.w	.chk2
	movea.l	#PauseMenuItems,a0
	bra.w	.0
.chk2	btst	#$2,tmflags(a2)
	beq.w	.0
	movea.l	#PauseText2,a0
.0	bsr.w	Pausemode_top
.loop	bsr.w	MenuWaitVblank
	bsr.w	ReadActiveJoypad
	jsr	(showclock).l
	jsr	(ProcessInputWithRepeat).l
	bsr.w	HandleMenuInput
	bne.w	.loop
	jsr	(forceblack).l
	move.w	(sp)+,(sflags).l
	btst	#sfhor,(sflags).l
	beq.w	.clr
	jsr	(ReloadRefHorTiles).l
	jsr	(SetHor).l
	bra.w	.hor
.clr	jsr	(ClrHor).l
.hor	movea.l	#$C00000,a0
.loop3	btst	#$7,(GA_COMFLAGS).l
	bne.b	.loop3
	move.w	#$9100,(GA_COMSTAT1).l
	move.w	#$A,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.loop4	btst	#$6,(GA_COMFLAGS).l
	beq.b	.loop4
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.loop5	btst	#$6,(GA_COMFLAGS).l
	bne.b	.loop5
	bclr	#$7,(GA_COMFLAGS+1).l
.loop6	btst	#$7,(GA_COMFLAGS).l
	bne.b	.loop6
	move.w	#$9200,(GA_COMSTAT1).l
	move.w	#$A,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.loop7	btst	#$6,(GA_COMFLAGS).l
	beq.b	.loop7
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.loop8	btst	#$6,(GA_COMFLAGS).l
	bne.b	.loop8
	bclr	#$7,(GA_COMFLAGS+1).l
	bset	#dfclock,(disflags).l
	bclr	#sfpz,(sflags).l
	jsr	(printscores1).l
	jsr	(setvideo).l
	move.w	#$18,(palcount).l
.wait	tst.w	(palcount).l
	bpl.w	.wait
	move.w	(Vcount).l,(OldVcount).l
	rts
; Pause mode: fills VDP memory through the gate array
PausemodeVdpFill
.next5	movea.l	#$C00000,a0
.loop10	btst	#$7,(GA_COMFLAGS).l
	bne.b	.loop10
	move.w	#$9100,(GA_COMSTAT1).l
	move.w	#$A,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.loop11	btst	#$6,(GA_COMFLAGS).l
	beq.b	.loop11
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.loop12	btst	#$6,(GA_COMFLAGS).l
	bne.b	.loop12
	bclr	#$7,(GA_COMFLAGS+1).l
.loop13	btst	#$7,(GA_COMFLAGS).l
	bne.b	.loop13
	move.w	#$921C,(GA_COMSTAT1).l
	move.w	#$A,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.loop14	btst	#$6,(GA_COMFLAGS).l
	beq.b	.loop14
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.loop15	btst	#$6,(GA_COMFLAGS).l
	bne.b	.loop15
	bclr	#$7,(GA_COMFLAGS+1).l
	jsr	(SetHor).l
	jsr	(setvideo).l
	jsr	(KillCrowd).l
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
	btst	#sfpj,(sflags).l
	beq.w	.seta20
	cmpi.w	#$1,(cont2team).l
	bra.w	.seta21
.seta20	cmpi.w	#$1,(cont1team).l
.seta21	beq.w	.x
	adda.w	#tmsize,a2
.x	rts
; Stores the menu handler pointers and clears the cursor.
Pausemode_top
	move.l	a0,(menulist).l
	move.l	a1,(menudraw).l
	clr.w	(menuitem).l
	clr.w	(MenuScrollTop).l