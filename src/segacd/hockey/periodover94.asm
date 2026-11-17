PeriodOver						;what to do if period over. Branched to from puckfaceoff when the clock
									;runs out. After period 3 a tied game goes to
									;overtime (gsp 3), else the game is over (gsp 4); after overtime only a
									;tied playoff game plays on. Falls into PeriodOver_sp
	addi.w	#$1,$180E4.l		;period number
	bchg	#$1,$17F68.l		;flip the attack direction
	cmpi.w	#$3,$180E4.l		;period 3 or later?
	blt.w	.0
	beq.w	.1		;period 3 just ended
	move.w	#$3,$180E4.l		;overtime done: stay at 3
	tst.w	$18BFA.l
	bne.w	.1
	move.w	#$4,$180E4.l
.1	move.w	$18358.l,d0
	sub.w	$186BE.l,d0
	beq.w	.0		;tied: play overtime
	move.w	#$4,$180E4.l		;game over
.0	bsr.w	forceblack
; End of period: resets the clock, scores, then runs the intermission.
PeriodOverIntermission
	jsr	(ResetClock).l
	move.w	#$79,-(sp)
	bsr.w	song
	bsr.w	UpdateScores
	cmpi.w	#$4,$180E4.l
	bne.w	.next3
	jsr	(AddPlayoffTeamStats).l
.next3	bsr.w	Intermission
	cmpi.w	#$4,$180E4.l
	beq.w	.next4
	jmp	(GetPeriodTimeSetup).l
.next4	jmp	(GameOver).l
; Period over: ends a penalty shot first
PeriodOverPenaltyShot	btst.b	#$2,$17F70.l
	beq.w	.next
	bsr.w	UpdatePenaltyShotEnd
.next	bclr.b	#$1,$62(a3)
	beq.w	.next2
	clr.w	$40(a3)
	move.w	#$78,$42(a3)
.next2	movea.l	#$17E36,a1
	sub.w	d7,$2(a1)
	sub.w	d7,$6(a1)
	sub.w	d7,$40(a3)
	bpl.w	.next3
	addi.w	#$5,$40(a3)
	bsr.w	findpc
.next3	move.w	$17BE0.l,d0
	bmi.w	.next4
	asl.w	#$7,d0
	movea.l	#$17480,a2
	adda.w	d0,a2
	bsr.w	a2touchpuck
	move.l	a2,-(sp)
	bsr.w	GetHotCount
	add.w	$0(a2),d0
	sub.w	$0(a3),d0
	asr.w	#$2,d0
	add.w	d0,$0(a3)
	add.w	$14(a2),d1
	sub.w	$14(a3),d1
	asr.w	#$2,d1
	add.w	d1,$14(a3)
	move.w	$28(a2),$28(a3)
	move.w	$2A(a2),$2A(a3)
.next4	bsr.w	PuckIChk
	bsr.w	PeriodOverSwitch
	btst.b	#$0,$17F68.l
	bne.w	.next7
	tst.w	$17BE0.l
	bpl.w	.next6
	move.w	$0(a3),d0
	cmp.w	$1C(a3),d0
	bne.w	.next6
	move.w	$14(a3),d0
	cmp.w	$20(a3),d0
	bne.w	.next6
	moveq	#$6,d0
	subi.w	#$1,$42(a3)
	bpl.w	.next5
	bsr.w	AddPenalty2
.next5	bra.w	.next7
.next6	move.w	#$78,$42(a3)
.next7	tst.b	$2C(a3)
	bne.w	PuckCollisionLimits
	tst.w	$18(a3)
	bne.w	PuckCollisionLimits
	bsr.w	puckunflip
	bra.w	PuckCollisionLimits
; Period over: switches the teams
PeriodOverSwitch	btst.b	#$5,$17F68.l
	beq.w	rtss2
	btst.b	#$2,$17F70.l
	bne.w	rtss2
	movea.l	#$1834C,a1
	lea.l	$366(a1),a2
	bsr.w	ClearOffsidesIfAllPlayers
	exg.l	a1,a2
	bsr.w	ClearOffsidesIfAllPlayers
	move.w	#$54,d0
	cmp.w	$14(a3),d0
	bgt.w	.next3
	cmp.w	$20(a3),d0
	ble.w	rtss2
	addi.w	#$A,d0
	btst.b	#$1,$17F68.l
	beq.w	.next
	exg.l	a1,a2
.next	moveq	#$5,d2
	movea.l	$22(a2),a0
.loop	tst.w	$34(a0)
	bmi.w	.next2
	cmp.w	$14(a0),d0
	bge.w	.next2
	bset.b	#$4,$32(a2)
	rts
.next2	adda.w	#$80,a0
	dbra	d2,.loop
	rts
.next3	neg.w	d0
	cmp.w	$14(a3),d0
	blt.w	rtss2
	cmp.w	$20(a3),d0
	bge.w	rtss2
	subi.w	#$A,d0
	btst.b	#$1,$17F68.l
	bne.w	.next4
	exg.l	a1,a2
.next4	moveq	#$5,d2
	movea.l	$22(a2),a0
.loop2	tst.w	$34(a0)
	bmi.w	.next5
	cmp.w	$14(a0),d0
	ble.w	.next5
	bset.b	#$4,$32(a2)
	rts
.next5	adda.w	#$80,a0
	dbra	d2,.loop2
	rts