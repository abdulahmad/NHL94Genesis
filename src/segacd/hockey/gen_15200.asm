doinput
	btst	#$4,d1
	beq.w	.l1521E
	btst	#$5,d1
	beq.w	.l1521E
	bclr	#$4,d1
	bset	#$6,$64(a3)
	bra.w	.l1525C
.l1521E	btst	#$4,d1
	beq.w	.l1522C
	bclr	#$6,$64(a3)
.l1522C	btst	#$4,d2
	beq.w	.l1525C
	bclr	#$6,$64(a3)
	beq.w	.l1525C
	tst.w	d4
	bne.w	.l15250
	move.b	#$11,$17E56.l
	bra.w	.l15258
.l15250	move.b	#$11,$17E57.l
.l15258	bclr	#$4,d2
.l1525C	btst	#$7,$17F78.l
	beq.w	.l15292
	bclr	#$6,d0
	bclr	#$6,d1
	bclr	#$6,d2
	bclr	#$6,d3
	cmpi.b	#$8,d0
	beq.w	.l15292
	jsr	(ShortenMsgTimer).l
	move.l	#$8,d0
	clr.l	d1
	clr.l	d2
	clr.l	d3
.l15292	move.w	d0,$17E62.l
	andi.w	#$F,$17E62.l
	bsr.w	setpads
	btst	#$7,d1
	beq.w	.l152D6
	tst.w	$17F96.l
	bpl.w	.l152C0
	tst.w	d4
	beq.w	EndDemoOnPressSub1
	bra.w	EndDemoOnPressSub2
.l152C0	btst	#$7,d1
	beq.w	.l152D6
	tst.w	$17F96.l
	beq.w	EndDemoOnPressSub3
	bra.w	EndDemoOnPressSub4
.l152D6	btst	#$7,$17F6A.l
	beq.w	.l152F2
	btst	#$3,d0
	bne.w	.l152F2
	addi.w	#$2,d0
	andi.w	#$7,d0
.l152F2	btst	#$0,$17F6C.l
	bne.w	faceoffinput
	btst	#$3,$63(a3)
	bne.w	lineinput
	btst	#$3,$62(a3)
	beq.w	doinputExit
	movem.l	d0-d2/a0/a3,-(sp)
	move.w	$17E2A.l,d0
	cmp.w	$52(a3),d0
	bne.w	.l15396
	tst.w	$17E30.l
	bmi.w	.l15396
	tst.w	$17EBC.l
	bpl.w	.l15396
	btst	#$5,d1
	beq.w	.l15396
	move.w	$17E30.l,d0
	asl.w	#$7,d0
	movea.l	#$17480,a3
	adda.w	d0,a3
	tst.w	$34(a3)
	beq.w	.l15396
	jsr	(PuckOnAttackHalf).l
	beq.w	.l15396
	btst	#$3,$62(a3)
	bne.w	.l15396
	btst	#$3,$64(a3)
	bne.w	.l15396
	move.w	d4,$1AD7A.l
	move.w	$17F96.l,$1AD7C.l
	move.w	#$23,d0
	jsr	(assreplace).l
	movem.l	(sp)+,d0-d2/a0/a3
	rts
.l15396	movem.l	(sp)+,d0-d2/a0/a3
	btst	#$3,$64(a3)
	bne.w	.l153AE
	btst	#$5,$62(a3)
	bne.w	doinput_islocked
.l153AE	btst	#$0,$63(a3)
	bne.w	faceoffinputExit
	move.w	$17BE0.l,d5
	cmp.w	$52(a3),d5
	beq.w	doinput_ispc
	tst.w	$34(a3)
	beq.w	.l153E4
	btst	#$3,$64(a3)
	beq.w	.l153DC
	bra.w	.l153E4
.l153DC	btst	#$6,d1
	bne.w	Holdplayer
.l153E4	tst.w	$34(a3)
	beq.w	.l153FC
	btst	#$2,$17F70.l
	bne.w	.l155C2
	bra.w	.l1543C
.l153FC	btst	#$6,$17F74.l
	bne.w	.l1543C
	tst.w	d4
	beq.w	.l15418
	tst.w	$18C0E.l
	bra.w	.l1541E
.l15418	tst.w	$18C0C.l
.l1541E	beq.w	.l1543C
	movem.w	d0,-(sp)
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	movem.w	(sp)+,d0
	beq.w	.l1543C
	bra.w	passtoSub1
.l1543C	btst	#$4,d3
	beq.w	.l154DC
	tst.w	$19374.l
	bne.w	.l154DC
	tst.w	d4
	beq.w	.l1549A
	tst.b	$17E57.l
	beq.w	.l155C2
	subi.b	#$1,$17E57.l
	bpl.w	.l15472
	move.b	#$0,$17E57.l
.l15472	tst.b	$17E57.l
	bne.w	.l154DC
	tst.w	d4
	beq.w	.l1548C
	tst.w	$18C0E.l
	bra.w	.l15492
.l1548C	tst.w	$18C0C.l
.l15492	bne.w	.l154DC
	bra.w	.l15576
.l1549A	tst.b	$17E56.l
	beq.w	.l155C2
	subi.b	#$1,$17E56.l
	bpl.w	.l154B8
	move.b	#$0,$17E56.l
.l154B8	tst.w	d4
	beq.w	.l154C8
	tst.w	$18C0E.l
	bra.w	.l154CE
.l154C8	tst.w	$18C0C.l
.l154CE	bne.w	.l154DC
	tst.b	$17E56.l
	beq.w	.l15576
.l154DC	btst	#$4,d1
	beq.w	.l15502
	tst.w	d4
	bne.w	.l154F6
	move.b	#$11,$17E56.l
	bra.w	.l155C2
.l154F6	move.b	#$11,$17E57.l
	bra.w	.l155C2
.l15502	btst	#$4,d2
	beq.w	.l155C2
	btst	#$4,d3
	bne.w	.l155C2
	move.w	$17E56.l,d0
	tst.w	d4
	beq.w	.l1554C
	move.b	#$11,$17E57.l
	andi.w	#$FF,d0
	bne.w	passtoSub1
	tst.w	d4
	beq.w	.l1553E
	tst.w	$18C0E.l
	bra.w	.l15544
.l1553E	tst.w	$18C0C.l
.l15544	bne.w	passtoSub1
	bra.w	.l15576
.l1554C	move.b	#$11,$17E56.l
	andi.w	#$FF00,d0
	bne.w	passtoSub1
	tst.w	d4
	beq.w	.l1556C
	tst.w	$18C0E.l
	bra.w	.l15572
.l1556C	tst.w	$18C0C.l
.l15572	bne.w	passtoSub1
.l15576	tst.w	$19374.l
	bne.w	passtoSub1
	move.w	#$5,d0
	cmpi.w	#$5,d6
	ble.w	.l15590
	move.w	#$B,d0
.l15590	jsr	(getGoalieSCnum).l
	tst.w	d0
	bmi.w	doinputExit
	movem.l	d0/a3,-(sp)
	movea.l	#$17480,a3
	asl.w	#$7,d0
	adda.w	d0,a3
	btst	#$3,$62(a3)
	movem.l	(sp)+,d0/a3
	bne.w	doinputExit
	tst.w	d4
	beq.w	setc1player
	bra.w	setc2player
.l155C2	tst.w	$34(a3)
	bne.w	doinput_onetimer
	btst	#$6,d1
	beq.w	doinputExit_1
	move.w	$17E62.l,d0
	cmpi.b	#$8,d0
	beq.w	doinputExit_1
	move.w	d0,$54(a3)
	move.b	#$8,$5E(a3)
	move.w	#$2F4,d1
	bsr.w	SetSPA
	bset	#$1,$63(a3)
	bset	#$5,$62(a3)
	addi.w	#$96,(Crowdlevel).l
doinputExit
	rts
doinputExit_1	btst	#$5,d1
	bne.w	.l1566C
	btst	#$5,d3
	bne.w	.l15622
	bclr	#$7,$63(a3)
	bra.w	doinput_chkanimSub1
.l15622	btst	#$7,$63(a3)
	beq.w	doinput_chkanimSub1
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	#SPAlist,a0
	adda.w	$58(a3),a0
	move.w	$54(a3),d0
	btst	#$3,$4(a3)
	beq.w	.l15652
	neg.w	d0
	addi.w	#$8,d0
	andi.w	#$7,d0
.l15652	asl.w	#$1,d0
	adda.w	(a0,d0.w),a0
	tst.b	$5B(a3)
	movem.l	(sp)+,d0-d3/a0-a3
	bpl.w	doinputExit
	move.w	#$A,$5C(a3)
	rts
.l1566C	btst	#$5,$62(a3)
	bne.w	doinput_chkanimSub1
	movem.w	d0-d1,-(sp)
	move.w	$17B80.l,d0
	sub.w	$0(a3),d0
	move.w	$17B94.l,d1
	sub.w	$14(a3),d1
	bsr.w	vtoa
	move.w	d0,$54(a3)
	movem.w	(sp)+,d0-d1
	move.w	$17E62.l,d0
	bclr	#$0,$17F70.l
	move.w	$180E6.l,d0
	andi.w	#$7,d0
	asl.w	#$4,d0
	addi.w	#$A0,d0
	cmpi.w	#$DB,$17B94.l
	bgt.w	.l156D0
	cmpi.w	#$FF25,$17B94.l
	bgt.w	.l156D4
.l156D0	subi.w	#$40,d0
.l156D4	move.w	d0,d1
	muls.w	$17BA8.l,d0
	swap	d0
	add.w	$17B80.l,d0
	muls.w	$17BAA.l,d1
	swap	d1
	add.w	$17B94.l,d1
	bsr.w	.l15798
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmpi.l	#$384,d0
	bhi.w	.l15712
	movem.w	(sp)+,d0-d1
	bra.w	.l1573C
.l15712	bsr.w	Sroot
	moveq	#$1,d2
	add.w	d0,d2
	moveq	#$12,d4
	btst	#$3,$17F6A.l
	beq.w	.l1572C
	addi.w	#$8,d4
.l1572C	movem.w	(sp)+,d0-d1
	muls.w	d4,d1
	addi.w	#$8,d4
	muls.w	d4,d0
	divs.w	d2,d0
	divs.w	d2,d1
.l1573C	add.w	d3,d1
	move.w	d1,d2
	cmpi.w	#$22,$2(a0)
	cmpi.w	#$18,(a0)
	cmpi.w	#$FFE8,(a0)
	cmpi.w	#$C,$2(a0)
	cmpi.w	#$108,$17B94.l
	cmpi.w	#$FEF8,$17B94.l
	bset	#$1,$63(a3)
	bne.w	doinput_chkanimSub1
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#$17E36,a0
	move.w	#$108,d3
	btst	#$7,$62(a3)
	beq.w	.l1578C
	neg.w	d3
	adda.w	#$4,a0
.l1578C	jsr	$330AC.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.l15798	move.w	$17BE0.l,d2
	cmp.w	$52(a3),d2
	bne.w	.l157A8
	clr.w	d0
.l157A8	cmpi.w	#$103,d1
	blt.w	.l157B4
	move.w	#$103,d1
.l157B4	cmpi.w	#$FEFD,d1
	bgt.w	.l157C0
	move.w	#$FEFD,d1
.l157C0	sub.w	d3,d1
	rts
doinput_chkanim						;Nothing while a3's animation runs (pflags2 bit 1); else skate a3
									;(doplayeracc)
	bchg	d0,d6
	bchg	d0,$250.w
	andi.l	#$1EC021E,-(a2)
	dc.w	$148E,$14C0,$14F2,$1544
doinput_chkanimSub1
	btst	#$1,$63(a3)
	beq.w	.l157E4
	rts
.l157E4	tst.w	$34(a3)
	bne.w	doplayeracc
	bclr	#$1,$17F70.l
	cmpi.w	#$24,$0(a3)
	ble.w	.l15816
	tst.w	$28(a3)
	bmi.w	.l15816
	beq.w	.l15816
	bset	#$1,$17F70.l
	clr.w	$28(a3)
.l15816	cmpi.w	#$FFDC,$0(a3)
	bge.w	.l15834
	tst.w	$28(a3)
	bpl.w	.l15834
	bset	#$1,$17F70.l
	clr.w	$28(a3)
.l15834	cmpi.w	#$E7,$14(a3)
	bgt.w	.l15876
	cmpi.w	#$FF19,$14(a3)
	ble.w	.l15876
	bra.w	.l1584C
.l1584C	movem.w	d0-d1,-(sp)
	move.w	$14(a3),d0
	move.w	$2A(a3),d1
	eor.w	d1,d0
	movem.w	(sp)+,d0-d1
	bpl.w	.l15876
	tst.w	$2A(a3)
	beq.w	.l15876
	bset	#$1,$17F70.l
	clr.w	$2A(a3)
.l15876	btst	#$1,$17F70.l
	bne.w	doinputExit
	move.w	$17E62.l,d0
	bra.w	doplayeracc
doinput_onetimer						;a3 is set for a one-timer: C (bit 5) starts the one-timer shot, else
									;skate
	move.w	$17E62.l,d0
	btst	#$3,$64(a3)
	bne.w	doinput_islockedExit
	btst	#$5,d1
	beq.w	doplayeracc
	movem.l	d7/a0,-(sp)
	move.w	$17E2A.l,d7
	asl.w	#$7,d7
	movea.l	#$17480,a0
	adda.w	d7,a0
	tst.w	$34(a0)
	movem.l	(sp)+,d7/a0
	beq.w	burst
	movem.w	d7,-(sp)
	move.w	$52(a3),d7
	cmp.w	$17E30.l,d7
	movem.w	(sp)+,d7
	bne.w	burst
	tst.w	$17BE0.l
	bpl.w	burst
	jsr	(PuckOnAttackHalf).l
	beq.w	burst
	move.w	d0,-(sp)
	move.w	d4,$1AD7A.l
	move.w	$17F96.l,$1AD7C.l
	move.w	#$23,d0
	jsr	(assreplace).l
	move.w	(sp)+,d0
	rts
doinput_ispc						;a3 has the puck: pass mode, shot mode, or start a pass / shot by the
									;buttons
	bsr.w	checkob
	tst.w	$34(a3)
	bne.w	.0
	btst	#$1,$63(a3)
	bne.w	doinputExit
.0	btst	#$2,$17F6A.l
	bne.w	passmode
	btst	#$3,$17F6A.l
	bne.w	ShotMode
	btst	#$4,d1
	beq.w	.1
	jsr	$2AD3A.l
	bra.w	setpassmode
.1	btst	#$6,d1
	beq.w	.ahold
	tst.w	d4
	beq.w	.2
	move.b	#$F,$19381.l
	bra.w	.ahold
.2	move.b	#$F,$19380.l
.ahold	btst	#$6,d3
	beq.w	.arel
	tst.w	d4
	beq.w	.c1
	subi.b	#$1,$19381.l
	bpl.w	.4
	move.b	#$0,$19381.l
.4	tst.b	$19381.l
	bne.w	.arel
	bset	#$3,$17F74.l
	jsr	(setpassmode).l
	bra.w	faceoffinputExitSub1
.c1	subi.b	#$1,$19380.l
	bpl.w	.6
	move.b	#$0,$19380.l
.6	tst.b	$19380.l
	bne.w	.arel
	bset	#$3,$17F74.l
	jsr	(setpassmode).l
	bra.w	faceoffinputExitSub1
.arel	btst	#$6,d3
	bne.w	.8
	btst	#$6,d2
	beq.w	.8
	bset	#$3,$17F74.l
	bra.w	setpassmode
.8	tst.w	$34(a3)
	bne.w	.shot
	bra.w	doplayeracc
.shot	btst	#$5,d1
	beq.w	doplayeracc
	jsr	$2AD3A.l
	bra.w	SetShotMode
doinput_islocked						;a3 is locked in an animation: B (bit 4) changes the controlled player
	move.w	$17BE0.l,d5
	cmp.w	$52(a3),d5
	beq.w	doinputExit
	btst	#$4,d1
	beq.w	doinput_islockedExit
	btst	#$6,$17F74.l
	bne.w	doinput_islockedExit
	bsr.w	passtoSub1
	movem.l	d0/a0,-(sp)
	move.w	$17F9E.l,d0
	tst.w	d4
	beq.w	.0
	move.w	$17FA0.l,d0
.0	tst.w	d0
	bmi.w	.x
	asl.w	#$7,d0
	movea.l	#$17480,a0
	adda.w	d0,a0
	bset	#$6,$64(a0)
.x	movem.l	(sp)+,d0/a0
doinput_islockedExit
	rts
getGoalieSCnum						;d0 = SCnum of the goalie in the 6 sort objects
									;up to object d0, -1 if none
	movem.l	d1/a0,-(sp)
	movea.l	#$17480,a0
	asl.w	#$7,d0
	adda.w	d0,a0
	move.w	#$5,d1
.loop	tst.w	$34(a0)
	beq.w	.goalie
	suba.w	#$80,a0
	dbra	d1,.loop
	move.w	#$FFFF,d0
	bra.w	.end
.goalie	move.w	$52(a0),d0
.end	movem.l	(sp)+,d1/a0
	rts
faceoffinput						;controller processing for faceoff
	btst	#$6,$17F74.l
	beq.w	.0
	rts
.0	move.w	$36(a3),d4		;move assnum into d4
	cmpi.b	#$17,$38(a3,d4.w)		;check if afaceoffpl is in asslist at assnum position
	bne.w	doinput_islockedExit		;exit if this is not a faceoff player
	movea.l	#$17EE6,a0		;faceoff direction of puck control variable
	btst	#$7,$62(a3)		;check which goal shooting on
	beq.w	.2		;branch if bottom goal
	movea.l	#$17EE8,a0
.2	move.w	d0,(a0)		;store dpad for faceoff pull
	btst	#$1,$63(a3)		;check if anim in progress
	beq.w	.l15AE8
	jmp	$30AB0.l
.l15AE8	btst	#$4,d1		;test for b button press
	beq.w	.1		;branch if pressed
	move.w	#$FEA,d1
	bset	#$1,$63(a3)		;set anim in progress
	bra.w	SetSPA
.1	move.w	#$1014,d1		;#SPAfaceoffr anim
	bra.w	SetSPA
faceoffinputExit
	rts
faceoffinputExitSub1
	tst.w	$18C0A.l
	bne.w	doinput_islockedExit
	btst	#$4,$17F7A.l
	bne.w	doinput_islockedExit
	jsr	$3C958.l
	bset	#$1,$32(a2)
	bne.w	doinput_islockedExit
	btst	#$3,$17F74.l
	bne.w	.l15B42
	bclr	#$2,$17F6A.l
.l15B42	bclr	#$3,$17F6A.l
	bset	#$3,$63(a3)
SetLCmode2
	bsr.w	setlccords
	cmpi.w	#$F,(printy).l
	blt.w	.l15B6C
	bset	#$0,$17F6E.l
	bra.w	.l15B76
.l15B6C	jsr	$410EC.l
	bsr.w	setlccords
.l15B76	jsr	(Framer).l
	subi.w	#$2,(printy).l
	addi.w	#$1,(printx).l
	moveq	#$2,d4
.l15B8E	move.w	d4,d0
	bsr.w	setlccordsSub1
	tst.w	d0
	bmi.w	.l15BEC
	btst	#$1,$32(a2)
	bne.w	.l15BB0
	cmp.w	$30(a2),d4
	bne.w	.l15BE4
	move.w	$16(a2),d0
.l15BB0	movea.l	#mesarea,a1
	move.l	#$44120,(a1)
	add.b	d4,$2(a1)
	jsr	(print).l
	move.w	d0,-(sp)
	movea.l	#$419F6,a1
	jsr	(SetTickerAreaPositionSub1).l
	move.w	(sp)+,d0
	jsr	(linebar).l
	subi.w	#$5,(printx).l
.l15BE4	subi.w	#$1,(printy).l
.l15BEC	dbra	d4,.l15B8E
	movea.l	$1E(a2),a1
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	addi.w	#$2,(printx).l
	jmp	(print).l
setlccords						;set printx/y to cords for lc box on team a2
	clr.w	d0
	cmpa.l	#$1834C,a2
	bne.w	.0
	eori.w	#$16,d0
.0	btst	#$1,$17F68.l		;reverse direction: flip to the other end
	beq.w	.l15C28
	eori.w	#$16,d0
.l15C28	jsr	(printz).l
	String	CC_Font1Pri,$16,$0
	add.w	d0,(printy).l
	moveq	#$2,d0
	bsr.w	setlccordsSub1
	moveq	#$6,d1		;3 rows
	tst.w	d0
	bpl.w	.ex
	subi.w	#$1,d1		;no third choice: 2 rows
	addi.w	#$1,(printy).l
.ex	moveq	#$9,d0
	rts
setlccordsSub1
	movem.l	d1-d2,-(sp)
	move.w	$38C(a2),d2
	cmpa.l	#$1834C,a2
	beq.w	getlchoice2
	move.w	-$340(a2),d2
getlchoice2						;add $15 to d0 for each player more or fewer than the other team has on
									;the ice
	sub.w	$26(a2),d2
	beq.w	.0
	addi.w	#$15,d0
	tst.w	d2
	bmi.w	.0
	addi.w	#$15,d0
.0	move.w	$16(a2),d1
	add.w	d1,d0
	add.w	d1,d0
	add.w	d1,d0
	lea.l	.l30C9E(pc),a0
	move.b	(a0,d0.w),d0
	ext.w	d0
	movem.l	(sp)+,d1-d2
	rts
.l30C9E	dc.w	$0001,$0201,$0200,$0200,$0100,$0102,$0001,$0200
	dc.w	$0102,$0001,$0203,$04FF,$0304,$FF03,$04FF,$0304
	dc.w	$FF04,$03FF,$0304,$FF03,$04FF,$0506,$FF05,$06FF
	dc.w	$0506,$FF05,$06FF,$0506,$FF05,$06FF,$0605,$FF00
lineinput						;process input for line changes
									;d1 = new button presses
	btst	#$3,$17F74.l
	beq.w	.0
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(passmode).l
	movem.l	(sp)+,d0-d7/a0-a6
.0	move.w	d1,-(sp)
	movea.l	#tmstruct,a2
	btst	#$6,$62(a3)
	beq.w	.2
	adda.w	#$366,a2
.2	bclr	#$0,$32(a2)		;Flag to start lc mode
	beq.w	.1
	bsr.w	lcfound_close		;close the old box
	bsr.w	SetLCmode2		;start lc mode
.1	move.w	(sp)+,d1
	clr.w	d2
	btst	#$6,d1
	bne.w	lineinputSub1
	addi.w	#$1,d2
	btst	#$4,d1
	bne.w	lineinputSub1
	addi.w	#$1,d2
	btst	#$5,d1
	bne.w	lineinputSub1
	btst	#$3,$62(a3)
	beq.w	.x
	btst	#$5,$62(a3)
	bne.w	.x
	btst	#$0,$63(a3)
	beq.w	doplayeracc		;skate with dpad if not fighting
.x	rts
lineinputSub1
	move.w	d2,d0
	move.w	d2,$30(a2)
	bsr.w	setlccordsSub1
	tst.w	d0
	bpl.w	.l15D7A
	jmp	$30AB0.l
.l15D7A	bclr	#$3,$63(a3)
	bset	#$3,$62(a3)
	jsr	$3C958.l
	bclr	#$1,$32(a2)
	move.w	d0,$16(a2)
	jsr	(setpersonel).l
lcfound_close						;close lc box
	btst	#$7,$17F6A.l
	bne.w	setpassmode_1
	bsr.w	setlccords
	cmpi.w	#$F,(printy).l
	blt.w	.nollcm
	bclr	#$0,$17F6E.l
.nollcm	addi.w	#$1,d1		;d1 = 1 and d2 = $7FF tile: erase the box area
	move.w	#$7FF,d2
	bsr.w	eraser
	jmp	(printscores1).l
burst						;cbut press check/speed. Also entered from check4check burst costs energy
									;$CC (only when line changes are on, OptLine = 0)
	jsr	(getpde).l
	tst.w	$18C0A.l
	bne.w	.0
	subi.w	#$CC,d0
	jsr	(setpde).l
	btst	#$4,$17F7A.l
	beq.w	.0
	move.w	#$1000,d0
.0	lsr.w	#$7,d0		;d0 will be $1000 with lines off
	move.w	d0,d1		;energy = speed increase (check violence)
	move.w	$54(a3),d2		;facedir
	asl.w	#$2,d2
	movea.l	#$36B8E,a0
	muls.w	(a0,d2.w),d0
	muls.w	$2(a0,d2.w),d1
	add.w	d0,$28(a3)		;add to X Vel
	add.w	d1,$2A(a3)		;add to Y Vel
	bset	#$5,$62(a3)		;lock in this animation
	move.w	#$C5E,d1
	bra.w	SetSPA
Holdplayer						;abut press hold. a0 = the player this one is
									;assigned to, falls into Acheck
	bset	#$5,$62(a3)		;lock animation
	move.w	#$1122,d1		;move anim into d1 - normal hold check
	tst.w	$32(a3)		;check if impact = 0
	beq.w	SetSPA		;set anim if 0
	movea.l	#$17480,a0
	move.w	$2E(a3),d0		;move last impact player into d0
	asl.w	#$7,d0		;calc offset
	adda.w	d0,a0		;add offset to a0
Acheck						;start SPAhook, or SPAHold if a0 is ahead
	bset	#$5,$62(a3)		;lock animation
	move.w	#$1122,d1		;move anim into d1 - normal hold check
	tst.w	$32(a3)		;check if impact = 0
	beq.w	.ex		;branch if 0
	move.w	$14(a3),d0		;move Ypos checker into d0
	sub.w	$14(a0),d0		;sub Ypos of player
	btst	#$7,$62(a3)		;check goal checker is shooting at
	beq.w	.air		;jump if bottom
	neg.w	d0		;make d0 negative
.air	bmi.w	.ex
	move.w	#$C90,d1		;set anim - hold check stick in air
.ex	bra.w	SetSPA
setpassmode						;initialize pass mode
	move.w	$54(a3),$17E2C.l
	andi.w	#$7,$17E2C.l
	btst	#$2,$17F70.l
	beq.w	.l15EBC
	bclr	#$2,$17F78.l
	bset	#$5,$17F70.l
	bne.w	doinput_islockedExit
	bclr	#$5,$17F78.l
	move.w	#$64,$17F9A.l
.l15EBC	bset	#$2,$17F6A.l
setpassmode_1	rts
passmode						;dpad sets passdir until bbut changes
	btst	#$4,d2		;has b button changed?
	bne.w	dopass		;yes
	btst	#$3,$17F74.l		;Not in NHL Hockey Source
	bne.w	dopass
	btst	#$3,d0		;look for dpad
	bne.w	setpassmode_1
	andi.w	#$7,d0		;pass first 3 bits of d0
	move.w	d0,$17E2C.l
	bset	#$3,d0
dopass						;pass the puck in passdir, to the best teammate there if any
	movem.l	d0-d5/a0-a1,-(sp)
	bclr	#$2,$17F6A.l		;#sfspdir
	st.b	$17BE0.l		;player is not puck handler anymore
	move.b	#$10,$5E(a3)
	move.w	$52(a3),$17E2A.l
	bclr	#$3,$17F74.l		;Not in NHL Hockey Source
	beq.w	.noot
	jsr	(OneTimerTarget).l
	move.w	#$12,$1937A.l
	btst	#$2,(sflags6).l
	beq.w	.1
	move.w	#$3A,$1937A.l
.1	jsr	(OneTimerPass).l
	bra.w	.l1606C
.noot	moveq	#$8,d0		;moves 8 into d0
	tst.w	$34(a3)		;checks if goalie
	beq.w	.calc		;jump if goalie
	move.b	$6E(a3),d0		;Passacc
.calc	asl.w	#$2,d0		;d0 = passacc for player, 8 for goalie
	asr.w	#$1,d0		;change from NHL Hockey Source,
	addi.w	#$A0,d0
	move.w	d0,$17E2E.l
	btst	#$0,$6E(a3)		;Checks to see if bit 0 in Passacc is 0
	beq.w	.l15F76		;Jumps if 0 (even number)
	asr.w	#$4,d0		;divide d0 by 16
	add.w	d0,$17E2E.l
.l15F76	moveq	#-1,d4
	moveq	#$5,d3
	movea.l	#$17480,a1
	cmpi.w	#$6,$52(a3)		;compares 6 to SCnum(a3) (current player with puck) to check if
	blt.w	.0		;Jump if player is Home, continue if Away
	adda.w	#$300,a1		;Switch to Away Team Players
	btst	#$2,$17F70.l
	bne.w	.l16016
.0	cmpa.l	a1,a3		;Check to see if passing to self
	beq.w	.next		;skip if this is passing player
	tst.w	$34(a1)		;position(a1)
	beq.w	.next		;skip if goalie
	btst	#$2,$63(a1)		;check if player is unavailable
	bne.w	.next		;player unavailable
	move.w	$0(a1),d0		;X Position of receiving player
	sub.w	$17B80.l,d0
	move.w	$14(a1),d1
	sub.w	$17B94.l,d1
	movem.w	d0-d1,-(sp)		;push to stack
	bsr.w	vtoa		;get direction of pass in d0
	movem.w	(sp)+,d1-d2		;pop from stack d1 is dX, d2 is dY
	sub.w	$17E2C.l,d0
	andi.w	#$7,d0		;pass only lower 3 bits in d0
	asl.b	#$5,d0		;Multiply d0 by 32 (224 decimal is max)
	ext.w	d0		;sign extend d0 byte to d0 word
	asl.w	#$3,d0		;mult d0 by 8 (700 decimal max)
	muls.w	d0,d0		;square d0 = max is 490000 decimal
	cmpi.l	#$10000,d0		;compare to 65536 decimal (#256^2: power, SNASM ^ is xor)
	bhi.w	.next		;if higher branch to next
	muls.w	d1,d1		;square d1 (dX)
	muls.w	d2,d2		;square d2 (dY)
	add.l	d1,d2		;add together
	add.l	d0,d2		;add modified passdir to d2
	cmp.l	d4,d2		;compare d4 to d2
	bhi.w	.next		;branch if higher (player is farther away than the closest player)
	move.l	d2,d4		;move d2 into d4
	movea.l	a1,a0		;move a1 address into a0 (receiving player)
.next	adda.w	#$80,a1		;Skip to next player (80 hex is length of player struct)
	dbra	d3,.0
	tst.l	d4		;check if there's a player to pass to
	bmi.w	.l16016		;skip if no player to pass to
	bsr.w	passto
	bra.w	.l1606C
.l16016	move.w	$17E2C.l,d0
	asl.w	#$2,d0
	movea.l	#$36B8E,a0
	move.w	$2(a0,d0.w),d1		;y inc
	muls.w	$17E2E.l,d1
	move.l	#$A,d2
	asl.l	d2,d1
	divs.w	#$BB8,d1
	add.w	$2A(a3),d1		;Yvel
	move.w	d1,$17BAA.l
	move.w	(a0,d0.w),d1
	muls.w	$17E2E.l,d1
	asl.l	d2,d1
	divs.w	#$BB8,d1
	add.w	$28(a3),d1		;Xvel
	move.w	d1,$17BA8.l
	move.w	#$1000,d0
	bsr.w	randomd0
	move.w	d0,$17BAC.l
.l1606C	tst.w	$34(a3)
	bne.w	.l16096
	tst.w	$17BAA.l
	btst	#$7,$62(a3)		;$62 = pflags Checks for what goal team is shooting at (0=bottom, 1=top)
	beq.w	.g0
	bmi.w	.l16090
	bra.w	.l16096
.g0	bmi.w	.l16096
.l16090	neg.w	$17BAA.l
.l16096	move.w	$17BA8.l,d0
	move.w	$17BAA.l,d1
	bsr.w	vtoa
	move.w	#$366,d1		;SPA = Sprite Animation
	tst.w	$34(a3)		;$34 = position
	beq.w	.e1		;goalie anim.
	move.w	#$718,d1
	bsr.w	Findhittype
	beq.w	.e1
	move.w	#$78A,d1
.e1	bsr.w	SetSPA		;start the pass animation d1
	bset	#$5,$62(a3)		;#pfalock, $62 = pflags
	moveq	#$C,d0		;Rest to rts, not in NHL Hockey Source
	sub.b	$17BAC.l,d0
	lsr.w	#$2,d0
	andi.w	#$3,d0
	move.w	#$10,d0
	move.w	d0,-(sp)		;#SFXpass
	bsr.w	sfx
	movem.l	(sp)+,d0-d5/a0-a1
	rts
