HotColdIcon						;The icon by the name of player iconplayer of team a2 at x iconx, y $19:
									;HotMap when he is awayhotplayer /
									;homehotplayer, ColdMap when awaycoldplayer / homecoldplayer, else
									;clear it (eraser)
	movem.l	d0/a0-a1,-(sp)
	dc.w	$207C,$0001,$7EAC
	move.w	#$2,$1AD8C.l
	cmpa.l	#$1834C,a2		;home team?
	bne.w	.l10428
	dc.w	$207C,$0001,$7EAE
	move.w	#$20,$1AD8C.l		;home: the home lists and column $20
.l10428	move.w	#$0,d0
.l1042C	move.w	(a0)+,d1		;1 hot player per team
	dc.w	$B279,$0001,$AD8A
	beq.w	.l1048E
	dbra	d0,.l1042C
	dc.w	$207C,$0001,$7EB0
	cmpa.l	#$1834C,a2
	bne.w	.l10452
	dc.w	$207C,$0001,$7EB2
.l10452	move.w	#$0,d0
.l10456	move.w	(a0)+,d1
	dc.w	$B279,$0001,$AD8A
	beq.w	.l1049E
	dbra	d0,.l10456
	move.w	$1AD8C.l,(printx).l
	move.w	#$19,(printy).l
	move.w	#$8,d0
	move.w	#$3,d1
	move.w	#$7FF,d2		;blank char
	dc.w	$4EB9,$0003,$8C06
	bra.w	.l104DC
.l1048E	move.w	(hoticonchars).l,d4
	movea.l	(HotMap).l,a0
	bra.w	.l104AA
.l1049E	move.w	(coldiconchars).l,d4
	movea.l	(ColdMap).l,a0
.l104AA	move.w	$1AD8C.l,(printx).l
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
	dc.w	$4EB9,$0003,$87E2
.l104DC	movem.l	(sp)+,d0/a0-a1
	rts
	btst	#$6,$17F74.l
	bne.w	Sub_2B600
	movem.l	d0-d6/a0-a1,-(sp)
	dc.w	$3039,$0001,$7BA8
	asr.w	#$8,d0
	dc.w	$D079,$0001,$7B80
	dc.w	$3239,$0001,$7BAA
	asr.w	#$8,d1
	dc.w	$D279,$0001,$7B94
	movem.w	d0-d1,-(sp)
	moveq	#$5,d2
	move.w	d4,d3
	eori.w	#$2,d3
	moveq	#-1,d5
	dc.w	$207C,$0001,$7480
	dc.w	$227C,$0001,$7FA6
	cmpi.w	#$1,(a1,d4.w)
	beq.w	.l10536
	adda.w	#$300,a0
.l10536	dc.w	$227C,$0001,$7F9E
.l1053C	tst.w	$34(a0)
	ble.w	.l105D6
	btst	#$2,$63(a0)
	bne.w	.l105D6
	movem.w	d1,-(sp)
	move.w	$52(a0),d1
	cmp.w	(a1,d4.w),d1
	movem.w	(sp)+,d1
	beq.w	.l1056C
	btst	#$3,$62(a0)
	bne.w	.l105D6
.l1056C	btst	#$2,$17F70.l
	beq.w	.l105A4
	movem.l	d0,-(sp)
	dc.w	$3039,$0001,$9368
	cmp.w	$52(a0),d0
	movem.l	(sp)+,d0
	beq.w	.l105A4
	movem.l	d0,-(sp)
	dc.w	$3039,$0001,$936A
	cmp.w	$52(a0),d0
	movem.l	(sp)+,d0
	bne.w	.l105D6
.l105A4	btst	#$5,$62(a0)
	bne.w	.l105D6
	movem.w	(sp),d0-d1
	sub.w	$0(a0),d0
	muls.w	d0,d0
	sub.w	$14(a0),d1
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	d5,d0
	bhi.w	.l105D6
	move.w	$52(a0),d1
	cmp.w	(a1,d3.w),d1
	beq.w	.l105D6
	move.l	d0,d5
	move.w	d1,d6
.l105D6	adda.w	#$80,a0
	dbra	d2,.l1053C
	adda.w	#$4,sp
	pea.l	$2B5FC.l
	cmp.w	(a1,d4.w),d6
	beq.w	Sub_2B602
	move.w	d6,d0
	tst.w	d4
	beq.w	Sub_2B608
	bra.w	Sub_2B60E
	dc.w	$4CDF,$037F
Sub_2B600
	rts
Sub_2B602
	dc.w	$4EF9,$0003,$12AA
Sub_2B608
	dc.w	$4EF9,$0003,$12B8
Sub_2B60E
	dc.w	$4EF9,$0003,$12DC
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
	lea.l	$223D6.l,a2
	lea.l	$222EA.l,a3
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
	dc.w	$50F9,$0001,$A556
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
	dc.w	$6706
	move.w	#$1,-(a6)
	dc.w	$6004
.l10850	move.w	#$0,-(a6)
.l10854	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	jsr	$2B614.l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	dc.w	$670A
	bset	#$5,$FF800F.l
	dc.w	$6008
.l10880	bclr	#$5,$FF800F.l
.l10888	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	jsr	$37752.l
	lea.l	$1746A.l,a0
	move.w	#$10,d0
	jsr	$5F22.w
	move.w	#$2,d0
	jsr	$5F22.w
.l108AC	move.w	#$80,d0
	jsr	$5F22.w
	bcs.w	.l108AC
.l108B8	move.w	#$81,d0
	jsr	$5F22.w
	move.w	(a0),d2
	andi.w	#$FF00,d2
	cmpi.w	#$0,d2
	bne.b	.l108B8
	move.w	#$5,$19364.l
	move.w	#$13,d0
	lea.l	$19364.l,a0
	jsr	$5F22.w
	dc.w	$4EB9,$0003,$74F0
	cmpi.b	#$E0,d3
	bne.w	.l108F8
	dc.w	$33FC,$0003,$0001,$8C02
.l108F8	clr.b	$17F68.l
	dc.w	$0C79,$0001,$0001,$8C08
	bne.w	.l10912
	bset	#$5,$17F68.l
.l10912	dc.w	$0C79,$0001,$0001,$8BFA
	ble.w	.l10922
	bsr.w	.l10984
.l10922	jsr	(clearTeamStats).l
	btst	#$0,$17F78.l
	beq.w	.l10950
	move.l	a0,-(sp)
	movea.l	#tmstruct,a0
	jsr	(Create_HotCold_Table).l
	movea.l	#awtmstruct,a0
	jsr	(Create_HotCold_Table).l
	movea.l	(sp)+,a0
.l10950	dc.w	$4279,$0001,$80F0
	dc.w	$4279,$0001,$825A
	clr.w	$180E4.l
	dc.w	$4279,$0001,$80EC
	bsr.w	restoreteams
	dc.w	$4EB9,$0003,$CB50
	jsr	$3E91C.l
	jsr	(LoadCrowdRec).l
	jmp	$35A94.l
.l10984	move.w	#$71,d0
	movea.l	#$18C42,a0
.l1098E	clr.w	(a0)+
	dbra	d0,.l1098E
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
	blt.w	.l109DA
	dc.w	$4A79,$0001,$8BFA
	bne.w	.l109DA
	move.w	#$258,d0
.l109DA	dc.w	$33C0,$0001,$80E6
	dc.w	$33C0,$0001,$80EA
	dc.w	$33C0,$0001,$747E
	asr.w	#$1,d0
	dc.w	$4EB9,$0003,$7050
	dc.w	$9179,$0001,$747E
	bset	#$0,$17F68.l
	rts
GetPeriodTime						;Return d0 = period length in seconds for the period length option
	dc.w	$3039,$0001,$8C02
	asl.w	#$1,d0
	dc.w	$41FA,$0008
	move.w	(a0,d0.w),d0
	rts
	dc.w	$012C,$0258,$04B0,$001E
	bclr	#$5,$FF800F.l
	move.w	#$FFFF,(palcount).l
	move.w	#$8400,d1
	move.w	#$85,d0
	jsr	$5F22.w
	cmpi.w	#$3,$180E4.l
	bne.w	.l10A4E
	bset	#$1,$17F7A.l
.l10A4E	dc.w	$50F9,$0001,$A560
	jsr	$47DAC.l
	jsr	$3E91C.l
	bsr.w	ResetClock
	dc.w	$0079,$F000,$0001,$7DC8
	dc.w	$50F9,$0001,$7F9E
	dc.w	$50F9,$0001,$7FA0
	dc.w	$267C,$0001,$7B80
	clr.w	$17EE2.l
	clr.w	$17EE4.l
	btst	#$0,$17F78.l
	beq.w	Gameloop
	move.w	#$1E,d0
	dc.w	$33FC,$0008,$0001,$936C
	dc.w	$33FC,$000B,$0001,$936A
	bra.w	L10AB0
Gameloop						;Main loop for game
	moveq	#$1B,d0
L10AB0	jsr	(Sub_362E4).l
	bset	#$2,$17F6C.l
	bclr	#$4,$17F6A.l
	move.w	#$FFFF,(lastsfx).l
	dc.w	$23FC,$0000,$C45C,$0001,$7470
	dc.w	$33F9,$0001,$7474,$0001,$7476
	bsr.w	DoGameFrame
	move.w	#$FFFF,(palcount).l
	bsr.w	DoGameFrame
	dc.w	$3039,$0001,$8A9E
	asl.w	#$4,d0
	dc.w	$33C0,$0001,$7CD8
	dc.w	$4279,$0001,$7F8C
	dc.w	$33F9,$0001,$7FAE,$0001,$A56C
	dc.w	$33FC,$0000,$0001,$A56E
	jsr	(ChooseSong).l
	dc.w	$3F39,$0001,$A56A
	dc.w	$4EB9,$0003,$71D2
	move.w	$1745E.l,$19364.l
	movea.l	$FF8000.l,a5
	move.w	#$12,d0
	lea.l	$19364.l,a0
	jsr	$5F22.w
	move.w	#$FFFF,$1745C.l
	move.w	#$0,$17460.l
	cmpi.w	#$2,$180E4.l
	bge.w	.l10B6C
	bset	#$7,$17F6E.l
.l10B6C	jsr	$37206.l
	bsr.w	DoGameFrame
	bsr.w	demoread
	btst	#$0,$17F6A.l
	beq.w	.l10B6C
	bsr.w	L11074
	bra.w	.l10B6C
DoGameFrame						;wait for at least one vblank, then run one frame of game logic
	move.w	(ScoutSubStatus).l,d7
	dc.w	$9E79,$0001,$7476
	beq.w	DoGameFrame
	dc.w	$33F9,$0001,$7474,$0001,$7476
	bsr.w	periodicevents
	bsr.w	Sub_2F98A
	dc.w	$4A79,$0001,$AD6E
	beq.w	.nosong
	bmi.w	.nosong
	dc.w	$0479,$0001,$0001,$AD6E
	bne.w	.nosong
	jsr	$47DB0.l
	dc.w	$3F39,$0001,$AD70
	dc.w	$4EB9,$0003,$71D2
.nosong	jsr	$25000.l
	bsr.w	Sub_300B2
	bsr.w	updatereplay
	dc.w	$4EF9,$0003,$DD16
periodicevents						;Called every time thru game loop with d7 = elapsed frames
	dc.w	$4EB9,$0003,$94F2
	bsr.w	updatecrowdf
	jsr	(RunArenaAnim).l
	dc.w	$4EB9,$0003,$E8CE
	bsr.w	clockcont
	btst	#$7,$17F6A.l
	bne.w	Sub_2F988
	dc.w	$9F79,$0001,$747C
	bpl.w	Sub_2F988
	dc.w	$0679,$0018,$0001,$747C
	dc.w	$4EB9,$0003,$5012
	bsr.w	UpdateCwdExcite
	bsr.w	CheckLateGameSong
	bsr.w	RestoreBenchEnergy
	bsr.w	.l10C44
	dc.w	$4EF9,$0003,$C2D0
.l10C44	subi.w	#$1,$1806A.l
	bne.w	Sub_2F988
	jmp	$40D50.l
RestoreBenchEnergy						;Called once per second. Restore energy for players on the bench
	dc.w	$4A79,$0001,$8C0A
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
	bne.w	.l10CEC
	btst	#$4,$17F68.l
	bne.w	.l10CEC
	dc.w	$3039,$0001,$80E6
	dc.w	$B079,$0001,$747E
	bgt.w	.l10CEC
	dc.w	$50F9,$0001,$747E
	dc.w	$33F9,$0001,$7FAE,$0001,$A56C
	dc.w	$33FC,$0005,$0001,$A56E
	jsr	(ChooseSong).l
	dc.w	$3F39,$0001,$A56A
	dc.w	$4EB9,$0003,$71D2
.l10CEC	rts
UpdateCwdExcite						;called once per second. Track peak and running total of crowd excitement,
	
	
	dc.w	$3039,$0001,$7CD8
	dc.w	$B079,$0001,$7CDA
	bls.w	.l10D04
	dc.w	$33C0,$0001,$7CDA
.l10D04	ext.l	d0
	dc.w	$D1B9,$0001,$7CDE
	addi.w	#$1,$17CDC.l
	dc.w	$0479,$0001,$0001,$7CD8
	bpl.w	.l10D26
	dc.w	$4279,$0001,$7CD8
.l10D26	rts
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
	dc.w	$207C,$0004,$154C
	move.b	(a0,d0.w),$17CD1.l
	clr.w	d1
	move.b	$1(a0,d0.w),d1
.l10D96	btst	#$7,$FF800E.l
	bne.b	.l10D96
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.l10DB0	btst	#$6,$FF800E.l
	beq.b	.l10DB0
	move.w	$FF8010.l,d2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l10DD0	btst	#$6,$FF800E.l
	bne.b	.l10DD0
	bclr	#$7,$FF800F.l
	and.w	d1,d2
	add.w	d2,d1
	move.w	d1,(Crowdcnt).l
.cf	clr.b	(Crowdframe).l
	cmpi.w	#$118,(Crowdlevel).l
	bls.w	Sub_2F988
.l10DFE	btst	#$7,$FF800E.l
	bne.b	.l10DFE
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.l10E18	btst	#$6,$FF800E.l
	beq.b	.l10E18
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l10E38	btst	#$6,$FF800E.l
	bne.b	.l10E38
	bclr	#$7,$FF800F.l
	andi.w	#$7F,d0
	cmpi.w	#$13,d0
	blt.w	Sub_2F988
	cmpi.w	#$19,d0
	bgt.w	Sub_2F988
	move.b	d0,(Crowdframe).l
	rts
clockcont						;monitor period clock and initiate various clock activated events
	btst	#$0,$17F68.l
	bne.w	Sub_2F988
	dc.w	$4A79,$0001,$80E6
	bne.w	Sub_2F988
	bset	#$3,(disflags).l
	jsr	$47DB0.l
	move.w	#$4,-(sp)
	dc.w	$4EB9,$0003,$710C
	bsr.w	freezewindow
clockcont_0						;End of period. Also entered from puckfaceoff
	dc.w	$267C,$0001,$7B80
	dc.w	$203C,$0000,$0018
	dc.w	$4EB9,$0003,$62D8
	cmpi.w	#$2,$180E4.l
	blt.w	.l10F98
	dc.w	$203C,$0000,$0007
	dc.w	$267C,$0001,$7480
	dc.w	$0C79,$0003,$0001,$8A9E
	bne.w	.l10F34
	dc.w	$0C79,$0007,$0001,$8A9C
	beq.w	.l10F18
	moveq	#$10,d3
	dc.w	$C6F9,$0001,$8A98
	movea.l	#$18A18,a0
	adda.w	d3,a0
	clr.w	d3
	btst	#$0,$E(a0)
	beq.w	.l10EFA
	eori.w	#$2,d3
.l10EFA	dc.w	$3239,$0001,$8358
	dc.w	$9279,$0001,$86BE
	bpl.w	.ns1
	eori.w	#$2,d3
.ns1	cmpi.w	#$3,$4(a0,d3.w)
	bne.w	.l10F34
.l10F18	dc.w	$203C,$0000,$0008
	moveq	#$B,d2
.t0	bclr	#$3,$62(a3)
	adda.w	#$80,a3
	dbra	d2,.t0
	dc.w	$267C,$0001,$7480
.l10F34	moveq	#$5,d2
	dc.w	$3239,$0001,$8358
	dc.w	$9279,$0001,$86BE
	beq.w	.l10F98
	bpl.w	.t2
	adda.w	#$300,a3
.t2	tst.w	$34(a3)
	ble.w	.l10F62
	dc.w	$4EB9,$0003,$62D8
	dc.w	$203C,$0000,$0007
.l10F62	adda.w	#$80,a3
	dbra	d2,.t2
.eog	jsr	(ClearPenaltyBuffer).l
	addi.w	#$3E8,(Crowdlevel).l
	bset	#$0,$17F68.l
	bset	#$6,$17F68.l
	jsr	(ClearPenalties).l
	move.w	#$4,d0
	dc.w	$4EF9,$0003,$9456
.l10F98	cmpi.w	#$3,$180E4.l
	bne.w	.l10FAE
	dc.w	$4A79,$0001,$8BFA
	beq.w	.eog
.l10FAE	move.w	#$2,d0
	dc.w	$4EF9,$0003,$9456
demoread						;monitor joystick if in demo mode (called every game loop)
	dc.w	$4A79,$0001,$7FA6
	bne.w	Sub_2F988
	dc.w	$4A79,$0001,$7FA8
	bne.w	Sub_2F988
	dc.w	$4EB9,$0003,$74F0
	btst	#$7,d1
	bne.w	Sub_2C022
	bsr.w	EndDemoOnPress
	dc.w	$4EB9,$0003,$750E
	btst	#$7,d1
	bne.w	Sub_2C034
	dc.w	$4A79,$0001,$8BF8
	beq.w	EndDemoOnPress
	jsr	$3752C.l
	btst	#$7,d1
	bne.w	Sub_2C04C
	bsr.w	EndDemoOnPress
	jsr	$3754A.l
	btst	#$7,d1
	bne.w	Sub_2C060
EndDemoOnPress						;Any button on the pad just read (d1) ends the demo
	tst.w	d1
	beq.w	Sub_2F988
	jmp	$3F2BE.l
Sub_2C022
	dc.w	$4279,$0001,$7F94
	bclr	#$1,$17F6A.l
	bra.w	L11042
Sub_2C034
	dc.w	$4279,$0001,$7F94
	bset	#$1,$17F6A.l
L11042	bset	#$0,$17F6A.l
	rts
Sub_2C04C
	dc.w	$33FC,$0003,$0001,$7F94
	bclr	#$1,$17F6A.l
	bra.w	L11042
Sub_2C060
	dc.w	$33FC,$0004,$0001,$7F94
	bset	#$1,$17F6A.l
	bra.w	L11042
L11074	jsr	(Sub_36D0A).l
	move.w	d0,-(sp)
	move.w	(ScoutSubStatus).l,d0
.l11082	cmp.w	(ScoutSubStatus).l,d0
	beq.w	.l11082
	move.w	(sp)+,d0
	jsr	$47DAC.l
	move.w	$17F6A.l,-(sp)
	bsr.w	seta2
	movea.l	#$41F50,a0
	dc.w	$43FA,$0152
	btst	#$0,$17F78.l
	beq.w	.l110BE
	movea.l	#$41EB4,a0
	bra.w	.l110CE
.l110BE	btst	#$2,$32(a2)
	beq.w	.l110CE
	movea.l	#$420DC,a0
.l110CE	bsr.w	Sub_2C2F8
.l110D2	bsr.w	MenuWaitVblank
	bsr.w	Sub_2F2F0
	dc.w	$4EB9,$0003,$E1CE
	dc.w	$4EB9,$0003,$74BE
	bsr.w	HandleMenuInput
	bne.w	.l110D2
	dc.w	$4EB9,$0003,$6D0A
	move.w	(sp)+,$17F6A.l
	btst	#$7,$17F6A.l
	beq.w	.l11116
	jsr	$3ECB8.l
	dc.w	$4EB9,$0003,$C40A
	bra.w	.l1111C
.l11116	jsr	(ClrHor).l
.l1111C	movea.l	#$C00000,a0
.l11122	btst	#$7,$FF800E.l
	bne.b	.l11122
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l11144	btst	#$6,$FF800E.l
	beq.b	.l11144
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1115E	btst	#$6,$FF800E.l
	bne.b	.l1115E
	bclr	#$7,$FF800F.l
.l11170	btst	#$7,$FF800E.l
	bne.b	.l11170
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l11192	btst	#$6,$FF800E.l
	beq.b	.l11192
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l111AC	btst	#$6,$FF800E.l
	bne.b	.l111AC
	bclr	#$7,$FF800F.l
	bset	#$3,(disflags).l
	bclr	#$0,$17F6A.l
	dc.w	$4EB9,$0003,$C48C
	dc.w	$4EB9,$0003,$DD16
	move.w	#$18,(palcount).l
.l111E2	tst.w	(palcount).l
	bpl.w	.l111E2
	dc.w	$33F9,$0001,$7474,$0001,$7476
	rts
	movea.l	#$C00000,a0
.l111FE	btst	#$7,$FF800E.l
	bne.b	.l111FE
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l11220	btst	#$6,$FF800E.l
	beq.b	.l11220
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1123A	btst	#$6,$FF800E.l
	bne.b	.l1123A
	bclr	#$7,$FF800F.l
.l1124C	btst	#$7,$FF800E.l
	bne.b	.l1124C
	move.w	#$921C,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l1126E	btst	#$6,$FF800E.l
	beq.b	.l1126E
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l11288	btst	#$6,$FF800E.l
	bne.b	.l11288
	bclr	#$7,$FF800F.l
	dc.w	$4EB9,$0003,$C40A
	dc.w	$4EB9,$0003,$DD16
	jsr	$48208.l
	dc.w	$4EB9,$0003,$8D8C
	dc.w	$0008
	dc.b	$FF,$03,$FD,$00,$FC,$00
	moveq	#$20,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	dc.w	$4EF9,$0003,$8C06
seta2						;Set a2 to the team struct of the pause joystick also called from
	
	movea.l	#tmstruct,a2
	btst	#$1,$17F6A.l
	beq.w	.l112E6
	dc.w	$0C79,$0001,$0001,$7FA8
	bra.w	.seta21
.l112E6	dc.w	$0C79,$0001,$0001,$7FA6
.seta21	beq.w	.x
	adda.w	#$366,a2
.x	rts
Sub_2C2F8
	dc.w	$23C8,$0001,$8AD6
	dc.w	$23C9,$0001,$8ADA
	clr.w	$18AD2.l
	clr.w	$18AD4.l
DrawMenuScreen						;Call the draw routine, frame the menu box, print the items and fade in.
	
	dc.w	$2079,$0001,$8ADA
	jsr	(a0)
	dc.w	$4EB9,$0003,$8D8C
	String	CC_Font2,$4,$FC,$C
	bsr.w	SetMenuPrintX
	moveq	#$16,d0
	moveq	#$6,d1
	dc.w	$4EB9,$0003,$8CA0
	bsr.w	Pausemode_Pmenu
	move.w	#$18,(palcount).l
.l1133E	tst.w	(palcount).l
	bpl.w	.l1133E
	rts
SetMenuPrintX						;printx = the left edge of the menu box: 5 in 32 column mode, else 9
	move.w	#$5,(printx).l
	btst	#$1,(disflags).l
	bne.w	Sub_2F988
	addi.w	#$4,(printx).l
	rts
HandleMenuInput						;Act on the pad bits d1 for the current menu: down / up move the
	
	
	
	
	btst	#$7,d1
	bne.w	.l113DE
	btst	#$1,d1
	beq.w	.l11384
	addi.w	#$1,$18AD2.l
	bra.w	Pausemode_Pmenu
.l11384	btst	#$0,d1
	beq.w	.l11398
	subi.w	#$1,$18AD2.l
	bra.w	Pausemode_Pmenu
.l11398	btst	#$5,d1
	beq.w	.l113DE
	bsr.w	seta2
	move.w	$18AD2.l,d0
	dc.w	$2079,$0001,$8AD6
	adda.w	(a0),a0
	adda.w	(a0),a0
	bra.w	.l113BC
.l113B8	adda.w	#$4,a0
.l113BC	adda.w	(a0),a0
	dbra	d0,.l113B8
	movea.l	(a0),a0
	jsr	(a0)
	bclr	#$1,$17F74.l
	bne.w	.l113D6
	bsr.w	DrawMenuScreen
.l113D6	tst.w	$18AD2.l		;item 0 (resume) leaves the menu
	rts
.l113DE	eori.b	#$4,ccr		;invert Z
	rts
