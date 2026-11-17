SelectPenaltyShotSkater						;pick the skater for the penalty shot from team BA_Team
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a0
	tst.w	$19366.l
	beq.w	.hometeam
	movea.l	#awtmstruct,a0
.hometeam	move.w	#$0,d1
	move.w	#$FFFF,d6
	move.w	#$FFFF,d5
	movea.l	$1E(a0),a2
	adda.w	$0(a2),a2
.playerloop	cmpi.w	#$2,(a2)
	beq.w	.doneplayers
	adda.w	(a2),a2
	move.w	d1,d7
	asl.w	#$1,d7
	move.b	$5(a2),d0
	andi.w	#$F,d0
	cmpi.b	#$1,d0
	ble.w	.nextplayer
	btst	#$0,$17F78.l
	bne.w	.next
	cmpi.w	#$FFFE,$68(a0,d7.w)
	beq.w	.scorecandidate
	cmpi.w	#$FFFF,$68(a0,d7.w)
	bne.w	.nextplayer
.scorecandidate	clr.w	d3
	clr.w	d0
	move.b	$1(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$2(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$2(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$3(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$3(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$5(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$5(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$6(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$7(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	cmp.w	$1936C.l,d1
	bne.w	.comparebest
	move.w	#$7FFF,d3
.comparebest	cmp.w	d6,d3
	blt.w	.nextplayer
	move.w	d3,d6
	move.w	d1,d5
	bra.w	.nextplayer
.nextplayer	adda.l	#$8,a2
	addi.w	#$1,d1
	cmpi.w	#$1A,d1
	blt.w	.playerloop
.doneplayers	tst.w	d5
	bmi.w	.noeligible
	move.w	d5,$1936C.l
.next	move.w	#$0,$19368.l
	tst.w	$19366.l
	beq.w	.next2
	move.w	#$6,$19368.l
.next2	move.w	$19368.l,d0
	asl.w	#$7,d0
	movea.l	#$17480,a3
	adda.w	d0,a3
	move.w	$1936C.l,d3
	bra.w	.eligible
.noeligible	move.w	#$FFFF,d0
	bra.w	.exit
.eligible	move.w	#$1,d0
.exit	movem.l	(sp)+,d0-d7/a0-a6
	rts
L347BA	bclr.b	#$1,$62(a3)
	beq.w	.next19
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	forceblack
.loop	btst.b	#$0,$18D64.l
	bne.w	.loop
	cmpi.w	#$258,$17CD2.l
	bls.w	.next
	move.w	#$258,$17CD2.l
	addi.w	#$14,$17CD8.l
.next	move.w	$18D56.l,d4
	movea.l	$47D1C.l,a2
	addq.l	#$8,a2
	jsr	$38958.l
	bset.b	#$3,$18D64.l
	bclr.b	#$0,$17F6A.l
	bclr.b	#$0,$17F6E.l
	clr.w	$17E32.l
	clr.b	$17ECE.l
	st.b	$1806E.l
	bclr.b	#$1,$17F6C.l
	st.b	$17E30.l
	bsr.w	ClrHor
	clr.w	$17CEA.l
	clr.w	$17CEE.l
	move.w	#$0,$17B80.l
	move.w	#$0,$17B94.l
	clr.w	$17B98.l
	clr.w	$17BA8.l
	clr.w	$17BAA.l
	clr.w	$17BAC.l
	st.b	$17BE0.l
	movea.l	#$17A80,a0
	clr.w	$28(a0)
	clr.w	$2A(a0)
	clr.w	$0(a0)
	move.w	#$10C,$14(a0)
	adda.w	#$80,a0
	clr.w	$28(a0)
	clr.w	$2A(a0)
	clr.w	$0(a0)
	move.w	#$FEF4,$14(a0)
	movea.l	#$17C00,a0
	move.w	#$18A,$6(a0)
	clr.w	$58(a0)
	clr.w	$4(a0)
	clr.w	$17B84.l
	bclr.b	#$6,$17F6A.l
	moveq	#$64,d4
.loop2	bsr.w	checkwindow
	dbra	d4,.loop2
	move.w	#$3C,$17EE0.l
	jsr	$3D6E2.l
	movea.l	#$1834C,a2
	jsr	$3D426.l
	jsr	$3D5E4.l
	adda.l	#$366,a2
	jsr	$3D426.l
	jsr	$3D5E4.l
	jsr	$3F0C6.l
	move.l	a3,-(sp)
	movea.l	#$17A00,a3
	move.w	#$B,d2
.loop3	cmp.w	$19368.l,d2
	beq.w	.next2
	cmp.w	$1936A.l,d2
	beq.w	.next7
	move.w	#$FF10,$0(a3)
	clr.w	$14(a3)
	clr.w	$6(a3)
	move.w	#$20,d0
	bsr.w	AssistListPush
	bra.w	.next13
.next2	tst.w	$34(a3)
	bpl.w	.next4
	bclr.b	#$2,$63(a3)
	beq.w	.next4
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d3
	move.b	$66(a3),d3
	jsr	$3D770.l
	movem.l	(sp)+,d0-d7/a0-a6
	tst.w	$34(a3)
	beq.w	.next3
	bpl.w	.next4
.next3	nop
.next4	move.w	$17B80.l,d0
	subi.w	#$0,d0
	move.w	d0,$0(a3)
	move.w	$17B94.l,d0
	btst.b	#$7,$62(a3)
	bne.w	.next5
	addi.w	#$10,d0
	move.w	#$4,$54(a3)
	bra.w	.next6
.next5	addi.w	#$FFF0,d0
	move.w	#$0,$54(a3)
.next6	move.w	d0,$14(a3)
	clr.w	$28(a3)
	clr.w	$2A(a3)
	clr.w	$2C(a3)
	move.w	#$11,d0
	bsr.w	AssistListPush
	bra.w	.next13
.next7	btst.b	#$0,$17F78.l
	beq.w	.next8
	move.b	$1A435.l,$66(a3)
	tst.w	$1A436.l
	beq.w	.next9
	move.b	$1A427.l,$66(a3)
	bra.w	.next9
.next8	tst.w	$34(a3)
	bpl.w	.next11
	bclr.b	#$2,$63(a3)
	beq.w	.next11
.next9	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d3
	move.b	$66(a3),d3
	jsr	$3D770.l
	movem.l	(sp)+,d0-d7/a0-a6
	tst.w	$34(a3)
	bne.w	.next10
	bpl.w	.next11
.next10	nop
.next11	bclr.b	#$2,$63(a3)
	move.w	#$0,d0
	move.w	#$E5,d1
	btst.b	#$7,$62(a3)
	bne.w	.next12
	move.w	#$FF1B,d1
.next12	move.w	d0,$0(a3)
	move.w	d1,$14(a3)
	clr.w	$28(a3)
	clr.w	$2A(a3)
	clr.w	$18(a3)
	sub.w	$17B80.l,d0
	sub.w	$17B94.l,d1
	neg.w	d0
	neg.w	d1
	bsr.w	vtoa
	move.w	d0,$54(a3)
	bclr.b	#$2,$63(a3)
	bclr.b	#$5,$62(a3)
	move.w	#$50C,d1
	bsr.w	SetSPA
.next13	suba.l	#$80,a3
	dbra	d2,.loop3
	jsr	$3F03E.l
	movea.l	(sp)+,a3
	bsr.w	ResetAndSelectPlayers
	move.w	$1936A.l,d0
	asl.w	#$7,d0
	movea.l	#$17480,a3
	adda.w	d0,a3
	move.w	#$0,$0(a3)
	move.w	#$FF06,$14(a3)
	btst.b	#$7,$62(a3)
	bne.w	.next14
	move.w	#$FA,$14(a3)
.next14	move.w	$1936A.l,d0
	move.w	#$1,d1
	btst.b	#$6,$62(a3)
	beq.w	.next15
	move.w	#$2,d1
.next15	cmp.w	$17FA6.l,d1
	bne.w	.next16
	jsr	$312B8.l
	bra.w	.next17
.next16	cmp.w	$17FA8.l,d1
	bne.w	.next17
	jsr	$312DC.l
.next17	move.w	#$E,d0
	bsr.w	assreplace
	bset.b	#$7,$17F70.l
	bset.b	#$2,$17F6C.l
	move.w	#$190,$17F98.l
	tst.w	$17FA6.l
	bne.w	.next18
	tst.w	$17FA8.l
	bne.w	.next18
	move.w	#$64,$17F98.l
.next18	move.w	#$18,$18D62.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.next19	bset.b	#$2,$17F78.l
	move.w	#$18,d0
	bsr.w	assreplace
	clr.w	$28(a3)
	clr.w	$2A(a3)
	rts
	dc.b	$00,$01,$02,$03,$04,$05,$06,$00,$00,$01,$05,$03,$04,$02,$00,$00	; ................
	dc.b	$00,$03,$05,$01,$04,$00,$00,$00,$00,$00,$FF,$06,$FF,$DD,$FF,$CE	; ................
	dc.b	$00,$23,$FF,$CE,$FF,$CE,$FF,$F6,$00,$00,$FF,$F1,$00,$32,$FF,$F6	; .#...........2..
	dc.b	$00,$00,$FF,$C4	; ....
UpdatePenaltyShotEnd						;end the penalty shot when the goalie has the puck, the puck is loose or
									;the timer runs out
	movem.w	d0,-(sp)
	move.w	$17BE0.l,d0
	cmp.w	$1936A.l,d0
	movem.w	(sp)+,d0
	beq.w	.next2
	btst	#$5,$17F70.l
	beq.w	.next3
	btst	#$5,$17F78.l
	bne.w	.puckloose
	tst.w	$17BE0.l
	bpl.w	.next
	bset	#$5,$17F78.l
.puckloose	tst.w	$17BE0.l
	bpl.w	.next2
.next	tst.w	$17F9A.l
	bmi.w	.next2
	subq.w	#$1,$17F9A.l
	bra.w	.next3
.next2	bset	#$4,$17F70.l
.next3	tst.w	$193B6.l
	bne.w	.checkended
	bset	#$4,$17F70.l
.checkended	btst	#$4,$17F70.l
	bne.w	.finishshot
	rts
.finishshot	btst	#$6,$17F70.l
	bne.w	EndPenaltyShotPlay_1
	bset	#$6,$17F70.l
	move.w	#$A,d0
	jsr	(AddPenalty2).l
EndPenaltyShotPlay						;stop play after a penalty shot or shootout attempt: freeze the window,
									;stop the clock, clear the penalty shot flags
	jsr	(freezewindow).l
	btst	#$0,$17F78.l
	bne.w	.stopplay
	move.w	#$A,$1AD92.l
	bset	#$2,$17F6C.l
.stopplay	bset	#$0,$17F68.l
	bclr	#$2,$17F78.l
	bclr	#$2,$17F70.l
	bclr	#$3,$17F70.l
	bclr	#$5,$17F70.l
	bclr	#$4,$17F70.l
	bclr	#$6,$17F70.l
	movem.l	d0/a0,-(sp)
	movea.l	#$17480,a0
	move.w	$19368.l,d0
	asl.w	#$7,d0
	move.b	$17F9C.l,$61(a0,d0.w)
	movem.l	(sp)+,d0/a0
	jsr	(CountShootoutGoals).l
EndPenaltyShotPlay_1	rts
L34CC6	bclr.b	#$4,$17F7C.l
	btst.b	#$0,$17F78.l
	beq.w	.next
	clr.w	$17BA8.l
	clr.w	$17BAA.l
	move.w	#$1E,d0
	bra.w	assreplace
.next	bclr.b	#$1,$62(a3)
	beq.w	WaitForFaceoffLineChanges
	bclr.b	#$0,$17F7C.l
	beq.w	.next2
	clr.w	$17EE2.l
	clr.w	$17EE4.l
.next2	bclr.b	#$7,$17F7A.l
	clr.l	$17DCA.l
	clr.l	$17DCE.l
	clr.l	$17DD2.l
	bclr.b	#$6,$17F7A.l
	bclr.b	#$2,$17F7A.l
	jsr	$2ACA0.l
	tst.w	$1A560.l
	bmi.w	.next3
	move.w	$1A560.l,d0
	bra.w	.next4
.next3	jsr	$2AC4E.l
	tst.w	d0
	bmi.w	.next5
.next4	jsr	$2A456.l
.next5	bclr.b	#$1,$17F76.l
	bclr.b	#$1,$17F78.l
	tst.w	$180E6.l
	beq.w	PeriodOver
	btst.b	#$6,$17F68.l
	bne.w	PeriodOver
	cmpi.w	#$3,$180E4.l
	bne.w	.next6
	move.w	$18358.l,d0
	cmp.w	$186BE.l,d0
	bne.w	L3500C
.next6	btst.b	#$3,$17F68.l
	bne.w	Stop4Pen
	move.w	$180EA.l,d0
	asr.w	#$1,d0
	cmp.w	$180E6.l,d0
	bls.w	.next7
	cmpi.w	#$3C,$180E6.l
	blt.w	.next7
	btst.b	#$7,$17F6E.l
	beq.w	.next7
	btst.b	#$0,$17F68.l
	beq.w	.next7
	btst.b	#$6,$17F7C.l
	bne.w	.next7
	bclr.b	#$7,$17F6E.l
	move.w	$17FAE.l,$1A56C.l
	move.w	#$2,$1A56E.l
	jsr	$2A478.l
	move.w	$1A56A.l,-(sp)
	bsr.w	song
.next7	bsr.w	ReturnGoalies
	st.b	$40(a3)
	st.b	$42(a3)
	tst.w	$18C0A.l
	bne.w	WaitForFaceoffLineChanges
	bclr.b	#$1,$1837E.l
	bclr.b	#$1,$186E4.l
	movea.l	#$17480,a0
	moveq	#$B,d0
.loop	bclr.b	#$3,$63(a0)
	adda.w	#$80,a0
	dbra	d0,.loop
	move.w	$17FA6.l,d0
	or.w	$17FA8.l,d0
	beq.w	.next8
	btst.b	#$7,$17F6A.l
	beq.w	.next8
	bsr.w	forceblack
	bset.b	#$6,$17F6A.l
	bsr.w	ClrHor
	move.w	#$18,$18D62.l
	tst.w	$18C0A.l
	bne.w	.next8
	btst.b	#$4,$17F7A.l
	beq.w	.next8
	clr.w	$18D62.l
.next8	move.w	$17F9E.l,d0
	bmi.w	.next9
	bsr.w	StartFaceoffLineChange
.next9	move.w	$17FA0.l,d0
	bmi.w	.next10
	bsr.w	StartFaceoffLineChange
.next10	movea.l	#$1834C,a1
	lea.l	$366(a1),a2
	moveq	#$2,d0
	bsr.w	SetFaceoffComputerLine
	bra.w	WaitForFaceoffLineChanges
SetFaceoffComputerLine	tst.w	$18C0A.l
	bne.w	rtss2
	btst	#$4,$17F7A.l
	bne.w	.next
	cmp.w	$17FA6.l,d0
	beq.w	rtss2
	cmp.w	$17FA8.l,d0
	beq.w	rtss2
.next	bsr.w	CompLine
	jsr	(setpersonel).l
	bsr.w	printscores1
	move.w	#$2710,$17F82.l
	rts
StartFaceoffLineChange						;start the line change box for team d0's sort object before a faceoff
	exg.l	a2,a3
	asl.w	#$7,d0
	movea.l	#$17480,a3
	adda.w	d0,a3
	bclr	#$3,$63(a3)
	move.l	a2,-(sp)
	bsr.w	FaceoffInputCheckLocked
	movea.l	(sp)+,a2
	btst	#$3,$63(a3)
	beq.w	.exit
	btst	#$6,$62(a3)
	beq.w	.homeplayer
	move.w	#$168,$42(a2)
	move.w	$52(a3),$46(a2)
	bra.w	.exit
.homeplayer	move.w	#$258,$40(a2)
	move.w	$52(a3),$44(a2)
.exit	exg.l	a2,a3
	rts
WaitForFaceoffLineChanges						;run both teams' faceoff line change timers (temp1 / temp2); continue when
									;both have run out
	move.w	#$40,d0
	bsr.w	UpdateFaceoffLineChangeTimer
	move.w	#$42,d0
	bsr.w	UpdateFaceoffLineChangeTimer
	tst.w	$40(a3)
	bpl.w	rtss2
	tst.w	$42(a3)
	bpl.w	rtss2
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a1
	moveq	#$1,d0
	bsr.w	SetFaceoffComputerLine
	move.w	#$FFFF,$1A568.l
	move.w	#$1C,d0		;puckfaceoff2
	bra.w	assreplace
UpdateFaceoffLineChangeTimer						;count down one team's faceoff line change timer at offset d0 of a3
	tst.w	(a3,d0.w)
	bmi.w	rtss2
	move.w	$4(a3,d0.w),d1
	asl.w	#$7,d1
	movea.l	#$17480,a0
	movea.l	#tmstruct,a2
	btst	#$6,$62(a0,d1.w)
	beq.w	.checkactive
	adda.w	#$366,a2
.checkactive	btst	#$3,$63(a0,d1.w)
	bne.w	.countdown
	st.b	(a3,d0.w)
	bra.w	SetLCmode2
.countdown	sub.w	d7,(a3,d0.w)
	bpl.w	rtss2
	move.l	a3,-(sp)
	lea.l	(a0,d1.w),a3
	btst	#$3,$63(a3)
	beq.w	.exit
	clr.w	d2
	bsr.w	LineInputSetCoords
	bsr.w	SetLCmode2
.exit	movea.l	(sp)+,a3
	rts
L3500C	jmp	(clockcont_0).l
ChkGoalies						;computer pulls goalie on delayed penalty. Called from periodicevents
	btst	#$0,$17F68.l		;check if clock running
	bne.w	rtss2
	movea.l	#tmstruct,a2		;a2 = team being tested, a1 = the other team
	lea.l	$366(a2),a1
	moveq	#$1,d0		;d0 = team number (1 home, 2 visitors)
	bsr.w	.chkgoalie
	moveq	#$2,d0
	exg.l	a1,a2
.chkgoalie	tst.w	$28(a2)		;check for goalie
	bmi.w	rtss2		;no goalie, exit
	move.w	$17BE0.l,d1		;move puck carrier SCnum into d1
	bmi.w	rtss2
	subi.w	#$6,d1
	cmpa.l	#$1834C,a2
	beq.w	.chkpen
	not.w	d1		;makes d1 negative if away team
.chkpen	tst.w	d1
	bpl.w	rtss2
	btst	#$3,$17F68.l		;#gmpendel - delayed penalty called
	beq.w	.next
	st.b	$28(a2)		;sets to FFFF (no goalie)
	jmp	(setpersonel).l
.next	cmp.w	$17FA6.l,d0
	beq.w	rtss2
	cmp.w	$17FA8.l,d0
	beq.w	rtss2
	move.w	$17B94.l,d1
	bra.w	CPgoalie
ReturnGoalies						;if computer pulled goalie, look to see if computer should return him.
									;Called from puckfaceoff
	movea.l	#tmstruct,a2		;a2 = team being tested, a1 = the other team
	lea.l	$366(a2),a1
	moveq	#$1,d0		;d0 = team number
	bsr.w	.r		;home team first ...
	moveq	#$2,d0
	exg.l	a1,a2		;... then fall into .r for the visitors
.r	cmpi.w	#$FFFF,$28(a2)
	beq.w	rtss2		;still no goalie
	clr.b	$28(a2)		;clear for goalie return
	cmp.w	$17FA6.l,d0
	beq.w	rtss2
	cmp.w	$17FA8.l,d0
	beq.w	rtss2
	move.w	$17EE4.l,d1
CPgoalie						;see if computer should pull his goalie. d1 = puck/faceoff y. Falls in
									;from ReturnGoalies; also entered from ChkGoalies
	cmpi.w	#$2,$180E4.l		;check if 3rd period
	bne.w	rtss2		;exit if not
	move.w	$C(a1),d0		;tmscore
	sub.w	$C(a2),d0
	bmi.w	rtss2		;exit if leading in the game
	cmpi.w	#$2,d0
	bne.w	rtss2		;exit if behind by more than 2
	cmpi.w	#$3C,$180E6.l
	bgt.w	rtss2		;exit if more than 1 min left
	move.l	a0,-(sp)
	movea.l	$22(a2),a0		;moves a player struct address into a0
	btst	#$7,$62(a0)		;#pfgoal
	movea.l	(sp)+,a0
	bne.w	.0
	neg.w	d1		;make y positive toward the goal I shoot at
.0	tst.w	d1
	bmi.w	rtss2		;exit if d1 negative (faceoff in own zone)
	st.b	$28(a2)		;set to FFFF (no goalie)
	jmp	(setpersonel).l
CompLine						;find good line for comp to switch to. a2 = team, a1 = other team. Called
									;from chk4lc and puckfaceoff
	movem.l	d0-d2/a0,-(sp)
	moveq	#$3,d0		;d0 = first of the 2 special lines (3-4) used with a man advantage
	move.w	$26(a2),d1		;tmap
	sub.w	$26(a1),d1		;compare the numbers of active players
	beq.w	.next		;equal: normal line
	bpl.w	.0
	addi.w	#$2,d0		;fewer players: lines 5-6 instead
.0	move.w	d0,-(sp)		;find pk/pp line
	bsr.w	getlinee		;d0 = energy of the first candidate
	move.w	d0,d1
	move.w	(sp),d0
	addi.w	#$1,d0
	bsr.w	getlinee		;d0 = energy of the second candidate
	cmp.w	d0,d1
	bge.w	.1
	addi.w	#$1,(sp)		;second one has more energy: take it
.1	move.w	(sp)+,$16(a2)		;tmline
.loop
	movem.l	(sp)+,d0-d2/a0
	rts
.next	cmpa.l	#$1834C,a2
	bne.w	.next4
	moveq	#$2,d1
	lea.l	.next3(pc),a0
	cmpi.w	#$2,$180E4.l
	bne.w	.next2
	move.w	$C(a2),d2
	cmp.w	$C(a1),d2
	beq.w	.next2
	adda.w	#$E,a0
	bgt.w	.next2
	adda.w	#$E,a0
.next2	move.w	$16(a1),d1
	asl.w	#$1,d1
	move.w	(a0,d1.w),d0
	bsr.w	getlinee
	cmpi.w	#$C00,d0
	bls.w	.next4
	move.w	(a0,d1.w),$16(a2)
	bra.w	.loop
.next3	dc.w	$0000,$0001,$0002,$0000,$0001,$0000,$0001,$0002
	dc.w	$0000,$0001,$0002,$0000,$0002,$0000,$0000,$0001
	dc.w	$0000,$0000,$0001,$0000,$0001
