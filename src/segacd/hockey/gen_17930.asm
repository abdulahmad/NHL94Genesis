; checkanim: stores the frame counter and tests the flags
checkanimFlags
	move.w	$17B80.l,$1AD58.l
	btst	#$0,$17F72.l
	beq.w	.next3
	btst	#$1,$63(a3)
	bne.w	.next3
	btst	#$1,$17F72.l
	beq.w	.next
	btst	#$3,$17F72.l
	bne.w	.next3
	cmpi.w	#$2C4,$6(a3)
	bne.w	.next3
	cmpi.w	#$2C8,$6(a3)
	bne.w	.next3
	bset	#$3,$17F72.l
	move.w	#$1C,-(sp)
	bsr.w	sfx
	bra.w	.next3
.next	movem.w	d0-d1,-(sp)
	move.w	$17B94.l,d0
	move.w	$14(a3),d1
	eor.w	d1,d0
	movem.w	(sp)+,d0-d1
	bmi.w	.next3
	cmpi.w	#$14,$0(a3)
	bgt.w	.next3
	cmpi.w	#$FFEC,$0(a3)
	ble.w	.next3
	bset	#$1,$17F72.l
	bclr	#$3,$17F72.l
	move.w	#$1596,d1
	btst	#$7,$62(a3)
	beq.w	.next2
	move.w	#$1684,d1
.next2	bsr.w	SetSPA
	bset	#$1,$63(a3)
.next3	btst	#$5,$62(a3)
	bne.w	ClampYPositionExit
	bsr.w	check4bench
	bclr	#$1,$62(a3)
	beq.w	.next4
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
	st.b	$46(a3)
.next4	cmpi.w	#$34,$0(a3)
	bgt.w	.next5
	cmpi.w	#$FFCC,$0(a3)
	blt.w	.next5
	cmpi.w	#$10E,$14(a3)
	bgt.w	.next5
	cmpi.w	#$FEF2,$14(a3)
	blt.w	.next5
	cmpi.w	#$D2,$14(a3)
	bgt.w	.next7
	cmpi.w	#$FF2E,$14(a3)
	blt.w	.next7
.next5	lea.l	ClampYPositionExit(pc),a0
	moveq	#$4,d0
	tst.w	$0(a3)
	bpl.w	.next6
	neg.w	d0
.next6	move.w	#$E4,d1
	btst	#$7,$62(a3)
	beq.w	skateto
	neg.w	d1
	bra.w	skateto
.next7	btst	#$1,$63(a3)
	bne.w	ClampYPositionExit
	btst	#$0,$17F72.l
	beq.w	.next9
	cmpi.w	#$2C5,$6(a3)
	beq.w	.next8
	cmpi.w	#$2C9,$6(a3)
	bne.w	.next9
	move.w	#$4,$54(a3)
	bra.w	.next9
.next8	move.w	#$0,$54(a3)
.next9	move.w	#$2,d1
	bsr.w	SetSPA
	btst	#$2,$17F70.l
	bne.w	.next10
	btst	#$0,$17F68.l
	bne.w	ClampYPositionExit
.next10	tst.w	$48(a3)
	bmi.w	.next13
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	beq.w	.next11
	st.b	$48(a3)
	bra.w	.next13
.next11	sub.w	d7,$48(a3)
	bpl.w	.next13
	btst	#$2,$17F70.l
	beq.w	.next12
	bset	#$4,$17F70.l
	bra.w	.next13
.next12	moveq	#$8,d0
	bsr.w	AddPenalty2
.next13	sub.b	d7,$40(a3)
	bpl.w	.next39
	move.b	$6B(a3),d0
	beq.w	.next14
	btst	#$6,$17F7A.l
	beq.w	.next14
	subi.b	#$1,d0
.next14	lsr.b	#$2,d0
	move.b	d0,$40(a3)
	btst	#$3,$62(a3)
	beq.w	.next15
	btst	#$2,$64(a3)
	bne.w	.next15
	moveq	#$1D,d0
	bra.w	AssistListPush
.next15	move.w	$17B94.l,d0
	move.w	$14(a3),d1
	eor.w	d0,d1
	bpl.w	.next16
	clr.w	d0
	move.w	#$F4,d2
	btst	#$7,$62(a3)
	beq.w	.loop5
	neg.w	d2
	bra.w	.loop5
.next16	subi.w	#$1,$46(a3)
	bpl.w	.next17
	move.w	#$FFFF,$46(a3)
.next17	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	bne.w	.next20
	tst.w	$48(a3)
	bpl.w	.next18
	move.w	#$5A,$48(a3)
.next18	st.b	$46(a3)
	cmpi.w	#$5A,$48(a3)
	bgt.w	.next23
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	andi.w	#$3,d0
	bne.w	.next23
	moveq	#$5,d0
	movea.l	#$17480,a0
	btst	#$6,$62(a3)
	bne.w	.loop4
	adda.w	#$300,a0
.loop4	btst	#$2,$63(a0)
	bne.w	.next19
	move.w	$17B94.l,d1
	sub.w	$14(a0),d1
	cmpi.w	#$1C,d1
	bgt.w	.next19
	cmpi.w	#$FFE4,d1
	blt.w	.next19
	move.w	$17B80.l,d1
	sub.w	$0(a0),d1
	cmpi.w	#$19,d1
	bgt.w	.next19
	cmpi.w	#$FFE7,d1
	bgt.w	.next23
.next19	adda.w	#$80,a0
	dbra	d0,.loop4
	move.w	#$1,$17E34.l
	bsr.w	chk4pass
	bra.w	.next23
.next20	tst.w	$46(a3)
	bne.w	.next23
	tst.w	$17BE0.l
	bpl.w	.next23
	move.w	$17B80.l,d0
	sub.w	$0(a3),d0
	cmpi.w	#$14,d0
	bgt.w	.next23
	cmpi.w	#$FFEC,d0
	blt.w	.next23
	move.w	$17B94.l,d1
	cmpi.w	#$108,d1
	bgt.w	.next23
	cmpi.w	#$FEF8,d1
	blt.w	.next23
	sub.w	$14(a3),d1
	cmpi.w	#$1E,d1
	bgt.w	.next23
	cmpi.w	#$FFE2,d1
	blt.w	.next23
	movem.w	d0-d1,-(sp)
	move.w	$17BA8.l,d0
	bpl.w	.next21
	neg.w	d0
.next21	move.w	$17BAA.l,d1
	bpl.w	.next22
	neg.w	d1
.next22	add.w	d1,d0
	cmpi.w	#$1000,d0
	movem.w	(sp)+,d0-d1
	bgt.w	.next23
	bsr.w	vtoa
	move.w	d0,$54(a3)
	move.b	#$8,$5E(a3)
	move.w	#$2F4,d1
	bsr.w	SetSPA
	bset	#$1,$63(a3)
	addi.w	#$96,(Crowdlevel).l
	rts
.next23	movea.l	#$17E36,a0
	move.w	#$104,d3
	btst	#$7,$62(a3)
	beq.w	.next24
	adda.w	#$4,a0
	neg.w	d3
.next24	cmpi.w	#$104,$14(a3)
	bgt.w	.next25
	cmpi.w	#$FEFC,$14(a3)
	bgt.w	.next26
.next25	clr.w	d2
	clr.w	d0
	cmpi.w	#$2C,$0(a3)
	bgt.w	.loop5
	cmpi.w	#$FFD4,$0(a3)
	blt.w	.loop5
	move.w	#$88,d0
	tst.w	$0(a3)
	bpl.w	.loop5
	neg.w	d0
	bra.w	.loop5
.next26	tst.w	$17BE0.l
	bmi.w	.next27
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	beq.w	.next27
	move.l	a0,-(sp)
	movea.l	#$17480,a0
	move.w	$17BE0.l,d0
	asl.w	#$7,d0
	adda.w	d0,a0
	move.w	$17B80.l,d0
	sub.w	$0(a0),d0
	asr.w	#$1,d0
	add.w	$0(a0),d0
	move.w	d0,$1AD58.l
	movea.l	(sp)+,a0
.next27	move.w	$1AD58.l,d0
	move.w	$17B94.l,d1
	bsr.w	ClampYPosition
	bsr.w	vtoa
	bsr.w	AdjustFacingDirection
	move.w	$180E6.l,d0
	andi.w	#$7,d0
	asl.w	#$4,d0
	addi.w	#$A0,d0
	cmpi.w	#$DB,$17B94.l
	bgt.w	.next28
	cmpi.w	#$FF25,$17B94.l
	bgt.w	.next29
.next28	subi.w	#$40,d0
.next29	move.w	d0,d1
	muls.w	$17BA8.l,d0
	swap	d0
	add.w	$1AD58.l,d0
	muls.w	$17BAA.l,d1
	swap	d1
	add.w	$17B94.l,d1
	bsr.w	ClampYPosition
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmpi.l	#$384,d0
	bhi.w	.next30
	movem.w	(sp)+,d0-d1
	bra.w	.next32
.next30	bsr.w	Sroot
	moveq	#$1,d2
	add.w	d0,d2
	moveq	#$12,d4
	btst	#$3,$17F6A.l
	beq.w	.next31
	addi.w	#$8,d4
.next31	movem.w	(sp)+,d0-d1
	muls.w	d4,d1
	addi.w	#$8,d4
	muls.w	d4,d0
	divs.w	d2,d0
	divs.w	d2,d1
.next32	add.w	d3,d1
	move.w	d1,d2
	btst	#$0,$17F78.l
	bne.w	.next34
	btst	#$2,$17F70.l
	bne.w	.next34
	btst	#$3,$17F6A.l
	beq.w	.next34
	cmpi.w	#$D0,$17B94.l
	bgt.w	.next33
	cmpi.w	#$FF30,$17B94.l
	blt.w	.next33
	bra.w	.next34
.next33	cmpi.w	#$14,$0(a3)
	bgt.w	.next34
	cmpi.w	#$FFEC,$0(a3)
	blt.w	.next34
	btst	#$1,$180E7.l
	bne.w	.next34
	bra.w	.next35
.next34	cmpi.w	#$22,$2(a0)
	bhi.w	.loop5
	cmpi.w	#$18,(a0)
	bgt.w	.next40
	cmpi.w	#$FFE8,(a0)
	blt.w	.next40
	cmpi.w	#$C,$2(a0)
	bhi.w	.next36
.next35	cmpi.w	#$108,$17B94.l
	bgt.w	.next36
	cmpi.w	#$FEF8,$17B94.l
	blt.w	.next36
	bset	#$1,$63(a3)
	bne.w	.next36
	jsr	$330AC.l
.next36	move.w	(a0),d0
	cmpi.w	#$FC,$17B94.l
	bgt.w	.next37
	cmpi.w	#$FF04,$17B94.l
	bgt.w	.loop5
.next37	moveq	#$18,d0
	tst.w	$1AD58.l
	bpl.w	.loop5
	neg.w	d0
.loop5	move.w	d2,d1
	movem.w	d0-d1,-(sp)
	move.b	$28(a3),d0
	ext.w	d0
	neg.w	d0
	add.w	(sp)+,d0
	sub.w	$0(a3),d0
	move.b	$2A(a3),d1
	ext.w	d1
	neg.w	d1
	add.w	(sp)+,d1
	sub.w	$14(a3),d1
	cmpi.w	#$4,d0
	bgt.w	.next38
	cmpi.w	#$FFFC,d0
	blt.w	.next38
	cmpi.w	#$4,d1
	bgt.w	.next38
	cmpi.w	#$FFFC,d1
	blt.w	.next38
	clr.w	d0
	clr.w	d1
.next38	bsr.w	vtoa
	move.b	d0,$43(a3)
.next39	move.b	$43(a3),d2
	ext.w	d2
	cmpi.w	#$7,d2
	ble.w	playeracc
	bra.w	stopna
.next40	tst.w	$17BE0.l
	bpl.w	.loop5
	btst	#$2,$17ECE.l
	bne.w	.loop5
	movea.l	#tmstruct,a1
	lea.l	$366(a1),a2
	btst	#$6,$62(a3)
	beq.w	.next41
	exg.l	a1,a2
.next41	cmpi.l	#$1324,$2C(a1)
	blt.w	.loop5
	cmpi.l	#$9C4,$2C(a2)
	blt.w	.loop5
	cmpi.w	#$E0,$17B94.l
	bgt.w	.next42
	cmpi.w	#$FF20,$17B94.l
	bgt.w	.loop5
.next42	tst.w	$17BAA.l
	btst	#$7,$62(a3)
	beq.w	.next43
	eori.b	#$8,ccr
.next43	bmi.w	.loop5
	move.w	$17BA8.l,d0
	bpl.w	.next44
	neg.w	d0
.next44	move.w	$17BAA.l,d1
	bpl.w	.next45
	neg.w	d1
.next45	cmp.w	d0,d1
	blt.w	.loop5
	moveq	#$F,d0
	bra.w	AssistListPush
ClampYPosition						;d1 = y clamped to +-$103, minus goal line d3. d0 = 0 if a3 has the puck
	move.w	$17BE0.l,d2
	cmp.w	$52(a3),d2		;is this player the puck carrier?
	bne.w	.0
	clr.w	d0		;carrier: d0 = 0
.0	cmpi.w	#$103,d1		;clamp d1 to the range -$103..$103
	blt.w	.1
	move.w	#$103,d1		;upper limit
.1	cmpi.w	#$FEFD,d1
	bgt.w	.2
	move.w	#$FEFD,d1
.2	sub.w	d3,d1
; Return of ClampYPosition
ClampYPositionExit	rts
AdjustFacingDirection						;Turn facedir one step toward direction d0
	move.w	$54(a3),d1		;facedir
	sub.w	d1,d0		;d0 = wanted - current
	beq.w	check4benchExit
	neg.w	d0
	andi.w	#$4,d0		;bit 2 of (current - wanted) picks the turn sense
	lsr.w	#$1,d0
	subi.w	#$1,d0		;d0 = +1/-1
	btst	#$3,$62(a3)		;pfjoycon
	bne.w	.add
	dc.w	$033C,$0042,$6700
	dc.w	$0022,$D240
	btst	#$7,$62(a3)
	dc.w	$6600,$000A
	dc.w	$033C,$0083,$6000
	dc.w	$0006,$033C
	dc.w	$0038,$6700,$0008
	neg.w	d0		;in the mask: undo it and turn the other way instead
	add.w	d0,d1
.add	add.w	d0,d1		;apply the step
	andi.w	#$7,d1		;wrap to 0-7
	move.w	d1,$54(a3)		;facedir
	rts
	move.w	(a0),d0
	sub.w	$0(a3),d0
	move.w	d3,d1
	sub.w	$14(a3),d1
	bsr.w	vtoa
	sub.w	$54(a3),d0
	andi.w	#$7,d0
	move.w	d0,d3
	lsr.w	#$2,d0
	btst	#$3,$4(a3)
	beq.w	.next
	eori.w	#$1,d0
.next	cmpi.w	#$8,$17B98.l
	bgt.w	.next2
	cmpi.w	#$800,$17BAC.l
	bgt.w	.next2
	bra.w	.next4
.next2	movem.l	d0,-(sp)
	move.w	$0(a3),d0
	sub.w	(a0),d0
	cmpi.w	#$10,d0
	bgt.w	.next3
	cmpi.w	#$FFF0,d0
	blt.w	.next3
	movem.l	(sp)+,d0
	addi.w	#$6,d0
	bra.w	.next13
.next3	movem.l	(sp)+,d0
	bra.w	.next13
.next4	addi.w	#$4,d0
	cmpi.w	#$8,$2(a0)
	bls.w	.next10
	cmpi.w	#$2,$54(a3)
	beq.w	.next13
	cmpi.w	#$6,$54(a3)
	beq.w	.next13
	tst.w	$17BE0.l
	bmi.w	.next13
	subi.w	#$2,d0
	move.w	d1,-(sp)
	move.w	#$1000,d1
	move.w	d1,$28(a3)
	ori.w	#$1,d0
	btst	#$7,$62(a3)
	bne.w	.next5
	eori.w	#$1,d0
.next5	move.w	#$FFFA,d1
	tst.w	$28(a3)
	bmi.w	.next6
	neg.w	$28(a3)
.next6	tst.w	$0(a3)
	bpl.w	.next8
	tst.w	$28(a3)
	bpl.w	.next7
	neg.w	$28(a3)
.next7	move.w	#$6,d1
	eori.w	#$1,d0
.next8	add.w	d1,$0(a3)
	btst	#$0,$76(a3)
	beq.w	.next9
	eori.w	#$1,d0
.next9	move.w	(sp)+,d1
	bra.w	.next13
.next10	movem.l	d0,-(sp)
	move.w	$0(a3),d0
	sub.w	(a0),d0
	cmpi.w	#$10,d0
	ble.w	.next11
	movem.l	(sp)+,d0
	bra.w	.next12
.next11	cmpi.w	#$FFF0,d0
	movem.l	(sp)+,d0
	bgt.w	.next13
.next12	addi.w	#$4,d0
.next13	add.w	d0,d0
	lea.l	.next15(pc),a1
	move.w	(a1,d0.w),d1
	cmpi.w	#$178,d1
	bne.w	.next14
	andi.w	#$3,d3
	beq.w	.next14
	cmpi.b	#$B,$73(a3)
	blt.w	.next14
	move.w	#$1AA,d1
.next14	bsr.w	SetSPA
	addi.w	#$96,(Crowdlevel).l
	addi.w	#$A,$17CD8.l
	asr.w	$28(a3)
	asr.w	$28(a3)
	asr.w	$2A(a3)
	asr.w	$2A(a3)
	rts
.next15	dc.w	$0146,$0178,$0250,$02A2,$01EC,$021E,$148E,$14C0
	dc.w	$14F2,$1544
assgoalietopuck						;goalie skates out to a loose puck (inserted by
									;assgoalie)
	btst	#$3,$62(a3)		;human controlled goalie: nothing to do
	bne.w	assexit
	btst	#$0,$17F68.l		;clock stopped: nothing to do
	bne.w	assexit
	bsr.w	check4bench
	bclr	#$1,$62(a3)		;new assignment? (clears the flag)
	beq.w	.0
	clr.w	$40(a3)
.0	sub.b	d7,$40(a3)		;count the timer down by d7 (elapsed frames)
	bpl.w	.go		;still running: keep skating to the puck
	move.b	$6B(a3),d0		;aidef
	beq.w	.1
	btst	#$6,$17F7A.l
	beq.w	.1
	subi.b	#$1,d0
.1	lsr.b	#$2,d0
	move.b	d0,$40(a3)		;reload timer = defensive rating / 4
	tst.w	$17BE0.l
	bpl.w	assexit		;someone has the puck: stay
	tst.w	$17BAA.l
	btst	#$7,$62(a3)
	beq.w	.dir
	eori.b	#$8,ccr		;flip N for the other goal end
.dir	bmi.w	assexit		;puck moving away from this goalie
	movea.l	#tmstruct,a1		;load home team struct into a1
	lea.l	$366(a1),a2		;load away team struct into a2
	btst	#$6,$62(a3)		;check if player is home or away
	beq.w	.t0		;branch if home
	exg.l	a1,a2		;swap if away
.t0	cmpi.l	#$E10,$2C(a1)		;each team's nearest distance^2 (tmnear) vs limits
	blt.w	assexit
	cmpi.l	#$640,$2C(a2)
	blt.w	assexit
.go	bra.w	skatetopuck
breakaway						;puck carrier a3 on a breakaway: beep on a new assignment and check the
									;skating direction toward the net
	bset	#$2,$17F74.l
	bclr	#$1,$62(a3)		;pfna - clear new assignment
	beq.w	.nna		;jump if no new assignment
	move.w	#$2,-(sp)		;ding SFX
	jsr	(sfx).l
	movem.l	a2,-(sp)		;push a2 on stack
	movea.l	#tmstruct,a2		;move Home Team Struct into a2
	btst	#$6,$62(a3)		;pfteam - check if home or away
	beq.w	.c0		;jump if home
	movea.l	#awtmstruct,a2		;move Away Team Struct into a2
.c0	addi.w	#$1,$35A(a2)		;add one to breakaway attempt
	addi.w	#$14,$17CD8.l
	addi.w	#$C8,(Crowdlevel).l		;add to Crowdlevel
	movem.l	(sp)+,a2
.nna	movem.w	d1,-(sp)		;push d1 on stack
	move.w	$14(a3),d0		;move Ypos into d0
	move.w	$2A(a3),d1		;move Yvel into d1
	beq.w	.yvel0		;jump if Yvel = 0
	eor.w	d1,d0		;EOR d1 with d0. d0 will be negative if skating opposite direction of net
.exit	movem.w	(sp)+,d1		;pop d1 off stack
	rts
.yvel0	move.w	#$FFFF,d1
	bra.w	.exit
BreakawayOffsidesFlagSet						;On a new assignment clear the offsides and breakaway bits of a3. Behind
									;the goal line or not yet in the attack zone set pf3oside, else end the
									;assignment
	btst	#$1,$62(a3)		;check for new assignment
	beq.w	.loadYpos		;branch if no new assignment
	bclr	#$0,$64(a3)		;clear player offsides flag
	bclr	#$1,$64(a3)		;clear player breakaway flag
.loadYpos	movem.w	d0-d1/a0,-(sp)
	move.w	#$108,d0		;108 = top goal line Y pos
	move.w	$14(a3),d1		;Ypos
	bpl.w	.cmpgoalline		;branch if Ypos is positive
	neg.w	d1		;negate d1
.cmpgoalline	cmp.w	d0,d1		;compare position to top goal line
	bge.w	.nogood		;Branch if above it
	move.w	#$58,d0		;58 = top blue line Y pos
	move.w	$14(a3),d1		;Ypos
	btst	#$7,$62(a3)		;check goal to shoot on (0=bottom, 1=top)
	bne.w	.top		;branch if top goal
	neg.w	d0		;bottom goal, so negate d0
	cmp.w	d1,d0		;compare Ypos to blue line Y
	blt.w	.setoffside		;branch if not in attack zone
	bra.w	.offzone		;branch if in attack zone
.top	cmp.w	d1,d0		;compare Ypos to blue line Y
	blt.w	.offzone		;branch if in offensive zone
.setoffside	bset	#$0,$64(a3)		;set offsides flag
	bra.w	.nogood
.offzone	bclr	#$0,$64(a3)		;clear offside bit
	beq.w	.nogood		;branch if on the blue line
	movea.l	#$17A00,a0		;loads last SCScruct player struct (Away pos #6)
	move.w	#$B,d0		;B = # of player structs to check (12)
	tst.w	d1		;checks if d1 is negative (determines what zone to check)
	bmi.w	.checkYpos
.checkYpos2	cmp.w	$14(a0),d1		;compare Ypos of a0 player to d1 (Ypos puckc)
	bge.w	.substruct2		;branch if d1 greater than or equal
	tst.w	$34(a0)		;check if goalie
	beq.w	.substruct2		;branch if goalie
	bra.w	.nogood
.substruct2	suba.w	#$80,a0
	dbra	d0,.checkYpos2
.setBAbit	bset	#$1,$64(a3)		;set breakaway bit
	move.w	#$1,d0		;moves 1 into d0 (used by returned subroutine)
.exit	movem.w	(sp)+,d0-d1/a0
	rts
.nogood	move.w	#$0,d0		;move 0 into d0 (used on return to subroutine)
	bra.w	.exit
.checkYpos	cmp.w	$14(a0),d1		;check Ypos with d1 (d1 = blue line Y)
	ble.w	.substruct
	tst.w	$34(a0)		;checks if goalie (who would be below blue line)
	beq.w	.substruct
	bra.w	.nogood
.substruct	suba.w	#$80,a0		;subtract SCstruct size (80 hex)
	dbra	d0,.checkYpos
	bra.w	.setBAbit
chkpuckc						;puck carrier a3: check for a breakaway (not in a shootout or penalty
									;shot), else assign asspuckc
	btst	#$0,$17F78.l
	bne.w	.0
	btst	#$2,$17F70.l
	bne.w	.0
	bsr.w	breakaway
	bpl.w	asspuckc		;currently skating towards net in Y
.0	bclr	#$1,$64(a3)		;clear breakaway bit
	move.w	#$10,d0		;asspuckc
	bsr.w	assreplace
asspuckc						;player a3 is puck handler
	bclr	#$2,$17F74.l
	bne.w	.0
	bclr	#$1,$64(a3)
.0	move.w	$17BE0.l,d0
	cmp.w	$52(a3),d0
	bne.w	assexit
	btst	#$2,$17F70.l
	beq.w	.1
	cmpi.w	#$1,$17F98.l
	bgt.w	asspuckcExit
.1	btst	#$1,$64(a3)
	bne.w	.2
	btst	#$2,$17F70.l
	bne.w	.2
	jsr	(BreakawayOffsidesFlagSet).l
	beq.w	.2		;branch if breakaway flag not set
	move.w	#$21,d0		;chkpuckc assignment
	bsr.w	assreplace
	bra.w	.2
.2	btst	#$5,$62(a3)
	bne.w	asspuckcExit
	btst	#$2,$17F70.l
	bne.w	.3
	btst	#$0,$17F68.l
	bne.w	donothing
.3	btst	#$3,$62(a3)
	bne.w	assexit
	bclr	#$1,$62(a3)
	beq.w	.7
	btst	#$1,$64(a3)
	beq.w	.4
	move.w	#$2,-(sp)
	jsr	(sfx).l
.4	btst	#$1,$64(a3)
	beq.w	.6
	movem.l	a2,-(sp)
	movea.l	#tmstruct,a2
	btst	#$6,$62(a3)
	beq.w	.5
	movea.l	#awtmstruct,a2
.5	addi.w	#$1,$35A(a2)
	addi.w	#$14,$17CD8.l
	addi.w	#$C8,(Crowdlevel).l
	movem.l	(sp)+,a2
.6	clr.w	$40(a3)
	move.w	#$8,$42(a3)
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	andi.w	#$3,d0
	move.w	d0,$44(a3)
.7	sub.b	d7,$40(a3)
	bpl.w	.nodec
	move.b	$6A(a3),$40(a3)
	jsr	(ReadGoaliePulled).l
	bmi.w	.8
	btst	#$6,$17F7A.l
	beq.w	.9
	tst.b	$40(a3)
	beq.w	.9
.8	subi.b	#$1,$40(a3)
.9	btst	#$2,$17F70.l
	bne.w	.soshot
	btst	#$0,$17F78.l
	bne.w	.soshot
	bsr.w	checkob
	bsr.w	CheckForLineChange
	btst	#$0,$17F78.l
	bne.w	.soshot
	btst	#$2,$17F70.l
	bne.w	.soshot
	btst	#$1,$64(a3)
	bne.w	.shot
	move.w	#$1,d0
	btst	#$6,$62(a3)
	beq.w	.next
	move.w	#$2,d0
.next	cmp.w	$17FA6.l,d0
	beq.w	.shot
	cmp.w	$17FA8.l,d0
	beq.w	.shot
	btst	#$1,$17475.l
	bne.w	.pass
.shot	bsr.w	CheckPuckHolder2
	bra.w	.pass
.soshot	jsr	$2A84A.l
	bne.w	.nodec
	jsr	(CompShoot).l
.pass	bsr.w	chk4pass
.nodec	moveq	#$6,d0
	add.w	$44(a3),d0		;add temp3 to d0
	lea.l	chk4lc(pc),a0
	btst	#$7,$17F6C.l		;#sf2offsig
	beq.w	.nd1
	move.w	$34(a3),d0		;position
.nd1	asl.w	#$2,d0
	move.w	$2(a0,d0.w),d1
	move.w	(a0,d0.w),d0
	btst	#$2,$17F70.l
	bne.w	.path
	btst	#$0,$17F78.l
	beq.w	.15
.path	jsr	$2A7B6.l
	cmpi.b	#$80,$1A8B8.l
	beq.w	asspuckcExit
.15	btst	#$7,$62(a3)		;pfgoal - 0 for bottom 1 for top
	bne.w	.next2
	neg.w	d0
	neg.w	d1
.next2	lea.l	.next3(pc),a0
	btst	#$2,$17F70.l
	bne.w	.16
	btst	#$0,$17F78.l
	beq.w	.17
.16	lea.l	asspuckcExit(pc),a0
.17	bra.w	skateto
.next3	dc.w	$4880,$142B,$0028,$4882,$D479,$0001,$7B80,$162B
	dc.w	$002A,$4883,$D679,$0001,$7B94,$4279,$0001,$7E34
	dc.w	$7805,$207C,$0001,$7480,$0C6B,$0006,$0052,$6C00
	dc.w	$0006,$D0FC,$0300,$1228,$0028,$4881,$D268,$0000
	dc.w	$9242,$0C41,$0014,$6E00,$00A6,$0C41,$FFEC,$6D00
	dc.w	$009E,$1228,$002A,$4881,$D268,$0014,$9243,$0C41
	dc.w	$0014,$6E00,$008A,$0C41,$FFEC,$6D00,$0082,$0679
	dc.w	$0001,$0001,$7E34,$302B,$0000,$9068,$0000,$322B
	dc.w	$0014,$9268,$0014,$6100,$2B9E,$322B,$0054,$0A41
	dc.w	$0004,$B240,$6600,$0058,$0839,$0007,$00FF,$800E
	dc.w	$66F6,$33FC,$001B,$00FF,$8020,$08F9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$67F6,$3239,$00FF
	dc.w	$8010,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$0241,$0001,$D041,$0240,$0007,$D0FC
	dc.w	$0080,$51CC,$FF42
asspuckcExit
	rts
chk4lc						;see if computer should call line change
	dc.w	$FF9C
	dc.w	$FFEC
	ori.w	#$FFEC,-(a4)
	dc.w	$FF88
	ori.b	#$14,$28(a0)
	ori.w	#$28,$FFFFFFEC.w
	dc.w	$0028,$FFD8,$00F0
	ori.b	#$DC,d0
	ori.b	#$E6,(a4)
	ori.b	#$E6,(a6)+
; Checks the line-change input state.
CheckForLineChange
	btst	#$4,$17F7A.l
	bne.w	.ex
	move.w	$17B94.l,d0
	btst	#$7,$62(a3)
	bne.w	.next
	neg.w	d0
.next	tst.w	d0
	bmi.w	check4benchExit
	cmpi.w	#$58,d0
	bgt.w	check4benchExit
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	andi.w	#$3,d0
	bne.w	check4benchExit
	btst	#$3,$63(a3)
	bne.w	check4benchExit
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a1
	btst	#$6,$62(a3)
	beq.w	.next2
	exg.l	a1,a2
.next2	jsr	(AvgCline).l
	cmpi.w	#$C00,d0
	bhi.w	check4benchExit
	bsr.w	CompLine
	jsr	(setpersonel).l
	jsr	(printscores1).l
	bra.w	CompShoot
.ex	rts
chkpk
	btst	#$5,$17F6C.l
	bne.w	chkpk2
	eori.b	#$4,ccr
	rts
chkpk2						;return z flag set if a3's team is the one on the power play (sf2pwrtm
									;against pfteam)
	movem.l	d0-d1,-(sp)
	btst	#$6,$17F6C.l		;#sf2pwrtm - 0 for team 1, 1 for team 2
	move.w	sr,d0
	btst	#$6,$62(a3)		;pfteam - 0 home, 1 away
	move.w	sr,d1
	eor.w	d1,d0
	move.w	d0,ccr
	movem.l	(sp)+,d0-d1
	rts
