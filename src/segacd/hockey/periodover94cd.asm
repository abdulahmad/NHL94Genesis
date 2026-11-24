PeriodOver						;what to do if period over. Branched to from puckfaceoff when the clock
									;runs out. After period 3 a tied game goes to
									;overtime (gsp 3), else the game is over (gsp 4); after overtime only a
									;tied playoff game plays on. Falls into PeriodOver_sp
	addi.w	#$1,(gsp).l		;period number
	bchg	#gmdir,(gmode).l		;flip the attack direction
	cmpi.w	#$3,(gsp).l		;period 3 or later?
	blt.w	PeriodOver_sp
	beq.w	.1		;period 3 just ended
	move.w	#$3,(gsp).l		;overtime done: stay at 3
	tst.w	(OptPlayMode).l
	bne.w	.1
	move.w	#$4,(gsp).l
.1	move.w	(HmGoals).l,d0
	sub.w	(AwGoals).l,d0
	beq.w	PeriodOver_sp		;tied: play overtime
	move.w	#$4,(gsp).l		;game over
PeriodOver_sp	bsr.w	forceblack
; End of period: resets the clock, scores, then runs the intermission.
PeriodOverIntermission
	jsr	(ResetClock).l
	move.w	#$79,-(sp)
	bsr.w	song
	bsr.w	UpdateScores
	cmpi.w	#$4,(gsp).l
	bne.w	.next3
	jsr	(AddPlayoffTeamStats).l
.next3	bsr.w	Intermission
	cmpi.w	#$4,(gsp).l
	beq.w	.next4
	jmp	(GetPeriodTimeSetup).l
.next4	jmp	(GameOver).l
; Period over: ends a penalty shot first
pucknorm	btst.b	#$2,(BA_PS_flags).l
	beq.w	.next
	bsr.w	UpdatePenaltyShotEnd
.next	bclr.b	#$1,pflags(a3)
	beq.w	.next2
	clr.w	temp1(a3)
	move.w	#$78,temp2(a3)
.next2	movea.l	#puckcross,a1
	sub.w	d7,pcframes(a1)
	sub.w	d7,$6(a1)
	sub.w	d7,temp1(a3)
	bpl.w	.next3
	addi.w	#$5,$40(a3)
	bsr.w	findpc
.next3	move.w	(puckc).l,d0
	bmi.w	.next4
	asl.w	#$7,d0
	movea.l	#SortCords,a2
	adda.w	d0,a2
	bsr.w	a2touchpuck
	move.l	a2,-(sp)
	bsr.w	GetHot
	add.w	$0(a2),d0
	sub.w	$0(a3),d0
	asr.w	#$2,d0
	add.w	d0,$0(a3)
	add.w	Ypos(a2),d1
	sub.w	Ypos(a3),d1
	asr.w	#$2,d1
	add.w	d1,Ypos(a3)
	move.w	Xvel(a2),Xvel(a3)
	move.w	Yvel(a2),Yvel(a3)
.next4	bsr.w	PuckIChk
	bsr.w	ChkOffsides
	btst.b	#$0,(gmode).l
	bne.w	.next7
	tst.w	(puckc).l
	bpl.w	.next6
	move.w	$0(a3),d0
	cmp.w	OldXpos(a3),d0
	bne.w	.next6
	move.w	Ypos(a3),d0
	cmp.w	OldYpos(a3),d0
	bne.w	.next6
	moveq	#$6,d0
	subi.w	#$1,$42(a3)
	bpl.w	.next5
	bsr.w	AddPenalty2
.next5	bra.w	.next7
.next6	move.w	#$78,temp2(a3)
.next7	tst.b	Zvel(a3)
	bne.w	checkpuckcoll
	tst.w	Zpos(a3)
	bne.w	checkpuckcoll
	bsr.w	puckunflip
	bra.w	checkpuckcoll
; Period over: switches the teams
ChkOffsides	btst.b	#$5,(gmode).l
	beq.w	rtss2
	btst.b	#$2,(BA_PS_flags).l
	bne.w	rtss2
	movea.l	#tmstruct,a1
	lea.l	tmsize(a1),a2
	bsr.w	ClearOffsidesIfAllPlayers
	exg.l	a1,a2
	bsr.w	ClearOffsidesIfAllPlayers
	move.w	#$54,d0
	cmp.w	Ypos(a3),d0
	bgt.w	.next3
	cmp.w	OldYpos(a3),d0
	ble.w	rtss2
	addi.w	#$A,d0
	btst.b	#$1,(gmode).l
	beq.w	.next
	exg.l	a1,a2
.next	moveq	#$5,d2
	movea.l	tmsort(a2),a0
.loop	tst.w	position(a0)
	bmi.w	.next2
	cmp.w	Ypos(a0),d0
	bge.w	.next2
	bset.b	#$4,tmflags(a2)
	rts
.next2	adda.w	#$80,a0
	dbra	d2,.loop
	rts
.next3	neg.w	d0
	cmp.w	Ypos(a3),d0
	blt.w	rtss2
	cmp.w	OldYpos(a3),d0
	bge.w	rtss2
	subi.w	#$A,d0
	btst.b	#$1,(gmode).l
	bne.w	.next4
	exg.l	a1,a2
.next4	moveq	#$5,d2
	movea.l	tmsort(a2),a0
.loop2	tst.w	position(a0)
	bmi.w	.next5
	cmp.w	Ypos(a0),d0
	ble.w	.next5
	bset.b	#$4,tmflags(a2)
	rts
.next5	adda.w	#$80,a0
	dbra	d2,.loop2
	rts