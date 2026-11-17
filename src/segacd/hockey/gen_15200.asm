Sub_30200
	btst	#$4,d1
	beq.w	L1521E
	btst	#$5,d1
	beq.w	L1521E
	bclr	#$4,d1
	bset	#$6,$64(a3)
	bra.w	L1525C
L1521E	btst	#$4,d1
	beq.w	L1522C
	bclr	#$6,$64(a3)
L1522C	btst	#$4,d2
	beq.w	L1525C
	bclr	#$6,$64(a3)
	beq.w	L1525C
	tst.w	d4
	bne.w	L15250
	move.b	#$11,$17E56.l
	bra.w	L15258
L15250	move.b	#$11,$17E57.l
L15258	bclr	#$4,d2
L1525C	btst	#$7,$17F78.l
	beq.w	L15292
	bclr	#$6,d0
	bclr	#$6,d1
	bclr	#$6,d2
	bclr	#$6,d3
	cmpi.b	#$8,d0
	beq.w	L15292
	jsr	(ShortenMsgTimer).l
	dc.w	$203C,$0000,$0008
	clr.l	d1
	clr.l	d2
	clr.l	d3
L15292	dc.w	$33C0,$0001,$7E62
	dc.w	$0279,$000F,$0001,$7E62
	bsr.w	setpads
	btst	#$7,d1
	beq.w	L152D6
	tst.w	$17F96.l
	bpl.w	L152C0
	tst.w	d4
	beq.w	Sub_2C022
	bra.w	Sub_2C034
L152C0	btst	#$7,d1
	beq.w	L152D6
	tst.w	$17F96.l
	beq.w	Sub_2C04C
	bra.w	Sub_2C060
L152D6	btst	#$7,$17F6A.l
	beq.w	L152F2
	btst	#$3,d0
	bne.w	L152F2
	addi.w	#$2,d0
	andi.w	#$7,d0
L152F2	btst	#$0,$17F6C.l
	bne.w	faceoffinput
	btst	#$3,$63(a3)
	bne.w	lineinput
	btst	#$3,$62(a3)
	beq.w	Sub_30606
	movem.l	d0-d2/a0/a3,-(sp)
	dc.w	$3039,$0001,$7E2A
	cmp.w	$52(a3),d0
	bne.w	L15396
	dc.w	$4A79,$0001,$7E30
	bmi.w	L15396
	dc.w	$4A79,$0001,$7EBC
	bpl.w	L15396
	btst	#$5,d1
	beq.w	L15396
	dc.w	$3039,$0001,$7E30
	asl.w	#$7,d0
	dc.w	$267C,$0001,$7480
	adda.w	d0,a3
	tst.w	$34(a3)
	beq.w	L15396
	jsr	(PuckOnAttackHalf).l
	beq.w	L15396
	btst	#$3,$62(a3)
	bne.w	L15396
	btst	#$3,$64(a3)
	bne.w	L15396
	dc.w	$33C4,$0001,$AD7A
	move.w	$17F96.l,$1AD7C.l
	move.w	#$23,d0
	dc.w	$4EB9,$0003,$62E4
	movem.l	(sp)+,d0-d2/a0/a3
	rts
L15396	movem.l	(sp)+,d0-d2/a0/a3
	btst	#$3,$64(a3)
	bne.w	L153AE
	btst	#$5,$62(a3)
	bne.w	doinput_islocked
L153AE	btst	#$0,$63(a3)
	bne.w	Sub_30B06
	move.w	$17BE0.l,d5
	cmp.w	$52(a3),d5
	beq.w	doinput_ispc
	tst.w	$34(a3)
	beq.w	L153E4
	btst	#$3,$64(a3)
	beq.w	L153DC
	bra.w	L153E4
L153DC	btst	#$6,d1
	bne.w	Holdplayer
L153E4	tst.w	$34(a3)
	beq.w	L153FC
	btst	#$2,$17F70.l
	bne.w	L155C2
	bra.w	L1543C
L153FC	btst	#$6,$17F74.l
	bne.w	L1543C
	tst.w	d4
	beq.w	L15418
	dc.w	$4A79,$0001,$8C0E
	bra.w	L1541E
L15418	dc.w	$4A79,$0001,$8C0C
L1541E	beq.w	L1543C
	movem.w	d0,-(sp)
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	movem.w	(sp)+,d0
	beq.w	L1543C
	bra.w	Sub_312A4
L1543C	btst	#$4,d3
	beq.w	L154DC
	tst.w	$19374.l
	bne.w	L154DC
	tst.w	d4
	beq.w	L1549A
	tst.b	$17E57.l
	beq.w	L155C2
	subi.b	#$1,$17E57.l
	bpl.w	L15472
	move.b	#$0,$17E57.l
L15472	tst.b	$17E57.l
	bne.w	L154DC
	tst.w	d4
	beq.w	L1548C
	dc.w	$4A79,$0001,$8C0E
	bra.w	L15492
L1548C	dc.w	$4A79,$0001,$8C0C
L15492	bne.w	L154DC
	bra.w	L15576
L1549A	tst.b	$17E56.l
	beq.w	L155C2
	subi.b	#$1,$17E56.l
	bpl.w	L154B8
	move.b	#$0,$17E56.l
L154B8	tst.w	d4
	beq.w	L154C8
	dc.w	$4A79,$0001,$8C0E
	bra.w	L154CE
L154C8	dc.w	$4A79,$0001,$8C0C
L154CE	bne.w	L154DC
	tst.b	$17E56.l
	beq.w	L15576
L154DC	btst	#$4,d1
	beq.w	L15502
	tst.w	d4
	bne.w	L154F6
	move.b	#$11,$17E56.l
	bra.w	L155C2
L154F6	move.b	#$11,$17E57.l
	bra.w	L155C2
L15502	btst	#$4,d2
	beq.w	L155C2
	btst	#$4,d3
	bne.w	L155C2
	move.w	$17E56.l,d0
	tst.w	d4
	beq.w	L1554C
	move.b	#$11,$17E57.l
	andi.w	#$FF,d0
	bne.w	Sub_312A4
	tst.w	d4
	beq.w	L1553E
	dc.w	$4A79,$0001,$8C0E
	bra.w	L15544
L1553E	dc.w	$4A79,$0001,$8C0C
L15544	bne.w	Sub_312A4
	bra.w	L15576
L1554C	move.b	#$11,$17E56.l
	andi.w	#$FF00,d0
	bne.w	Sub_312A4
	tst.w	d4
	beq.w	L1556C
	dc.w	$4A79,$0001,$8C0E
	bra.w	L15572
L1556C	dc.w	$4A79,$0001,$8C0C
L15572	bne.w	Sub_312A4
L15576	tst.w	$19374.l
	bne.w	Sub_312A4
	move.w	#$5,d0
	cmpi.w	#$5,d6
	ble.w	L15590
	move.w	#$B,d0
L15590	jsr	(getGoalieSCnum).l
	tst.w	d0
	bmi.w	Sub_30606
	movem.l	d0/a3,-(sp)
	dc.w	$267C,$0001,$7480
	asl.w	#$7,d0
	adda.w	d0,a3
	btst	#$3,$62(a3)
	movem.l	(sp)+,d0/a3
	bne.w	Sub_30606
	tst.w	d4
	beq.w	Sub_312B8
	bra.w	Sub_312DC
L155C2	tst.w	$34(a3)
	bne.w	doinput_onetimer
	btst	#$6,d1
	beq.w	L15608
	dc.w	$3039,$0001,$7E62
	cmpi.b	#$8,d0
	beq.w	L15608
	move.w	d0,$54(a3)
	move.b	#$8,$5E(a3)
	move.w	#$2F4,d1
	bsr.w	Sub_363C0
	bset	#$1,$63(a3)
	bset	#$5,$62(a3)
	addi.w	#$96,(Crowdlevel).l
Sub_30606
	rts
L15608	btst	#$5,d1
	bne.w	L1566C
	btst	#$5,d3
	bne.w	L15622
	bclr	#$7,$63(a3)
	bra.w	Sub_307D8
L15622	btst	#$7,$63(a3)
	beq.w	Sub_307D8
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	#SPAlist,a0
	adda.w	$58(a3),a0
	move.w	$54(a3),d0
	btst	#$3,$4(a3)
	beq.w	L15652
	neg.w	d0
	addi.w	#$8,d0
	andi.w	#$7,d0
L15652	asl.w	#$1,d0
	adda.w	(a0,d0.w),a0
	tst.b	$5B(a3)
	movem.l	(sp)+,d0-d3/a0-a3
	bpl.w	Sub_30606
	move.w	#$A,$5C(a3)
	rts
L1566C	btst	#$5,$62(a3)
	bne.w	Sub_307D8
	movem.w	d0-d1,-(sp)
	dc.w	$3039,$0001,$7B80
	sub.w	$0(a3),d0
	dc.w	$3239,$0001,$7B94
	sub.w	$14(a3),d1
	bsr.w	vtoa
	move.w	d0,$54(a3)
	movem.w	(sp)+,d0-d1
	dc.w	$3039,$0001,$7E62
	bclr	#$0,$17F70.l
	dc.w	$3039,$0001,$80E6
	andi.w	#$7,d0
	asl.w	#$4,d0
	addi.w	#$A0,d0
	dc.w	$0C79,$00DB,$0001,$7B94
	bgt.w	L156D0
	dc.w	$0C79,$FF25,$0001,$7B94
	bgt.w	L156D4
L156D0	subi.w	#$40,d0
L156D4	move.w	d0,d1
	dc.w	$C1F9,$0001,$7BA8
	swap	d0
	dc.w	$D079,$0001,$7B80
	dc.w	$C3F9,$0001,$7BAA
	swap	d1
	dc.w	$D279,$0001,$7B94
	bsr.w	L15798
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmpi.l	#$384,d0
	bhi.w	L15712
	movem.w	(sp)+,d0-d1
	bra.w	L1573C
L15712	bsr.w	Sroot
	moveq	#$1,d2
	add.w	d0,d2
	moveq	#$12,d4
	btst	#$3,$17F6A.l
	beq.w	L1572C
	addi.w	#$8,d4
L1572C	movem.w	(sp)+,d0-d1
	muls.w	d4,d1
	addi.w	#$8,d4
	muls.w	d4,d0
	divs.w	d2,d0
	divs.w	d2,d1
L1573C	add.w	d3,d1
	move.w	d1,d2
	cmpi.w	#$22,$2(a0)
	cmpi.w	#$18,(a0)
	cmpi.w	#$FFE8,(a0)
	cmpi.w	#$C,$2(a0)
	dc.w	$0C79,$0108,$0001,$7B94
	dc.w	$0C79,$FEF8,$0001,$7B94
	bset	#$1,$63(a3)
	bne.w	Sub_307D8
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#$17E36,a0
	move.w	#$108,d3
	btst	#$7,$62(a3)
	beq.w	L1578C
	neg.w	d3
	adda.w	#$4,a0
L1578C	jsr	$330AC.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
L15798	move.w	$17BE0.l,d2
	cmp.w	$52(a3),d2
	bne.w	L157A8
	clr.w	d0
L157A8	cmpi.w	#$103,d1
	blt.w	L157B4
	move.w	#$103,d1
L157B4	cmpi.w	#$FEFD,d1
	bgt.w	L157C0
	move.w	#$FEFD,d1
L157C0	sub.w	d3,d1
	rts
doinput_chkanim
	bchg	d0,d6
	bchg	d0,$250.w
	andi.l	#$1EC021E,-(a2)
	dc.w	$148E,$14C0,$14F2,$1544
Sub_307D8
	btst	#$1,$63(a3)
	beq.w	L157E4
	rts
L157E4	tst.w	$34(a3)
	bne.w	Sub_363D6
	bclr	#$1,$17F70.l
	cmpi.w	#$24,$0(a3)
	ble.w	L15816
	tst.w	$28(a3)
	bmi.w	L15816
	beq.w	L15816
	bset	#$1,$17F70.l
	clr.w	$28(a3)
L15816	cmpi.w	#$FFDC,$0(a3)
	bge.w	L15834
	tst.w	$28(a3)
	bpl.w	L15834
	bset	#$1,$17F70.l
	clr.w	$28(a3)
L15834	cmpi.w	#$E7,$14(a3)
	bgt.w	L15876
	cmpi.w	#$FF19,$14(a3)
	ble.w	L15876
	bra.w	L1584C
L1584C	movem.w	d0-d1,-(sp)
	move.w	$14(a3),d0
	move.w	$2A(a3),d1
	eor.w	d1,d0
	movem.w	(sp)+,d0-d1
	bpl.w	L15876
	tst.w	$2A(a3)
	beq.w	L15876
	bset	#$1,$17F70.l
	clr.w	$2A(a3)
L15876	btst	#$1,$17F70.l
	bne.w	Sub_30606
	dc.w	$3039,$0001,$7E62
	bra.w	Sub_363D6
doinput_onetimer
	dc.w	$3039,$0001,$7E62
	btst	#$3,$64(a3)
	bne.w	Sub_30A6E
	btst	#$5,d1
	beq.w	Sub_363D6
	movem.l	d7/a0,-(sp)
	dc.w	$3E39,$0001,$7E2A
	asl.w	#$7,d7
	dc.w	$207C,$0001,$7480
	adda.w	d7,a0
	tst.w	$34(a0)
	movem.l	(sp)+,d7/a0
	beq.w	burst
	movem.w	d7,-(sp)
	move.w	$52(a3),d7
	dc.w	$BE79,$0001,$7E30
	movem.w	(sp)+,d7
	bne.w	burst
	tst.w	$17BE0.l
	bpl.w	burst
	jsr	(PuckOnAttackHalf).l
	beq.w	burst
	move.w	d0,-(sp)
	dc.w	$33C4,$0001,$AD7A
	move.w	$17F96.l,$1AD7C.l
	move.w	#$23,d0
	dc.w	$4EB9,$0003,$62E4
	move.w	(sp)+,d0
	rts
doinput_ispc
	bsr.w	checkob
	tst.w	$34(a3)
	bne.w	L15924
	btst	#$1,$63(a3)
	bne.w	Sub_30606
L15924	btst	#$2,$17F6A.l
	bne.w	passmode
	btst	#$3,$17F6A.l
	bne.w	ShotMode
	btst	#$4,d1
	beq.w	L1594E
	jsr	$2AD3A.l
	bra.w	setpassmode
L1594E	btst	#$6,d1
	beq.w	L15970
	tst.w	d4
	beq.w	L15968
	move.b	#$F,$19381.l
	bra.w	L15970
L15968	move.b	#$F,$19380.l
L15970	btst	#$6,d3
	beq.w	L159DE
	tst.w	d4
	beq.w	L159AE
	subi.b	#$1,$19381.l
	bpl.w	L15992
	move.b	#$0,$19381.l
L15992	tst.b	$19381.l
	bne.w	L159DE
	bset	#$3,$17F74.l
	dc.w	$4EB9,$0003,$0E7C
	bra.w	Sub_30B08
L159AE	subi.b	#$1,$19380.l
	bpl.w	L159C2
	move.b	#$0,$19380.l
L159C2	tst.b	$19380.l
	bne.w	L159DE
	bset	#$3,$17F74.l
	dc.w	$4EB9,$0003,$0E7C
	bra.w	Sub_30B08
L159DE	btst	#$6,d3
	bne.w	L159FA
	btst	#$6,d2
	beq.w	L159FA
	bset	#$3,$17F74.l
	bra.w	setpassmode
L159FA	tst.w	$34(a3)
	bne.w	L15A06
	bra.w	Sub_363D6
L15A06	btst	#$5,d1
	beq.w	Sub_363D6
	jsr	$2AD3A.l
	bra.w	Sub_313CA
doinput_islocked
	move.w	$17BE0.l,d5
	cmp.w	$52(a3),d5
	beq.w	Sub_30606
	btst	#$4,d1
	beq.w	Sub_30A6E
	btst	#$6,$17F74.l
	bne.w	Sub_30A6E
	bsr.w	Sub_312A4
	movem.l	d0/a0,-(sp)
	dc.w	$3039,$0001,$7F9E
	tst.w	d4
	beq.w	L15A54
	dc.w	$3039,$0001,$7FA0
L15A54	tst.w	d0
	bmi.w	L15A6A
	asl.w	#$7,d0
	dc.w	$207C,$0001,$7480
	adda.w	d0,a0
	bset	#$6,$64(a0)
L15A6A	movem.l	(sp)+,d0/a0
Sub_30A6E
	rts
getGoalieSCnum
	movem.l	d1/a0,-(sp)
	dc.w	$207C,$0001,$7480
	asl.w	#$7,d0
	adda.w	d0,a0
	move.w	#$5,d1
L15A82	tst.w	$34(a0)
	beq.w	L15A9A
	suba.w	#$80,a0
	dbra	d1,L15A82
	move.w	#$FFFF,d0
	bra.w	L15A9E
L15A9A	move.w	$52(a0),d0
L15A9E	movem.l	(sp)+,d1/a0
	rts
faceoffinput
	btst	#$6,$17F74.l
	beq.w	L15AB2
	rts
L15AB2	move.w	$36(a3),d4
	cmpi.b	#$17,$38(a3,d4.w)
	bne.w	Sub_30A6E
	movea.l	#$17EE6,a0
	btst	#$7,$62(a3)
	beq.w	L15AD6
	movea.l	#$17EE8,a0
L15AD6	move.w	d0,(a0)
	btst	#$1,$63(a3)
	beq.w	L15AE8
	jmp	$30AB0.l
L15AE8	btst	#$4,d1
	beq.w	L15AFE
	move.w	#$FEA,d1
	bset	#$1,$63(a3)
	bra.w	Sub_363C0
L15AFE	move.w	#$1014,d1
	bra.w	Sub_363C0
Sub_30B06
	rts
Sub_30B08
	dc.w	$4A79,$0001,$8C0A
	bne.w	Sub_30A6E
	btst	#$4,$17F7A.l
	bne.w	Sub_30A6E
	jsr	$3C958.l
	bset	#$1,$32(a2)
	bne.w	Sub_30A6E
	btst	#$3,$17F74.l
	bne.w	L15B42
	bclr	#$2,$17F6A.l
L15B42	bclr	#$3,$17F6A.l
	bset	#$3,$63(a3)
Sub_30B50
	bsr.w	setlccords
	cmpi.w	#$F,(printy).l
	blt.w	L15B6C
	bset	#$0,$17F6E.l
	bra.w	L15B76
L15B6C	jsr	$410EC.l
	bsr.w	setlccords
L15B76	jsr	(Framer).l
	subi.w	#$2,(printy).l
	addi.w	#$1,(printx).l
	moveq	#$2,d4
L15B8E	move.w	d4,d0
	bsr.w	Sub_30C58
	tst.w	d0
	bmi.w	L15BEC
	btst	#$1,$32(a2)
	bne.w	L15BB0
	cmp.w	$30(a2),d4
	bne.w	L15BE4
	move.w	$16(a2),d0
L15BB0	movea.l	#mesarea,a1
	move.l	#$44120,(a1)
	add.b	d4,$2(a1)
	dc.w	$4EB9,$0003,$8F80
	move.w	d0,-(sp)
	movea.l	#$419F6,a1
	dc.w	$4EB9,$0003,$CEBE
	move.w	(sp)+,d0
	dc.w	$4EB9,$0003,$C746
	subi.w	#$5,(printx).l
L15BE4	subi.w	#$1,(printy).l
L15BEC	dbra	d4,L15B8E
	movea.l	$1E(a2),a1
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	addi.w	#$2,(printx).l
	dc.w	$4EF9,$0003,$8F80
setlccords
	clr.w	d0
	cmpa.l	#$1834C,a2
	bne.w	L15C18
	eori.w	#$16,d0
L15C18	btst	#$1,$17F68.l
	beq.w	L15C28
	eori.w	#$16,d0
L15C28	jsr	(printz).l
	String	CC_Font1Pri,$16,$0
	add.w	d0,(printy).l
	moveq	#$2,d0
	bsr.w	Sub_30C58
	moveq	#$6,d1
	tst.w	d0
	bpl.w	L15C54
	subi.w	#$1,d1
	addi.w	#$1,(printy).l
L15C54	moveq	#$9,d0
	rts
Sub_30C58
	movem.l	d1-d2,-(sp)
	move.w	$38C(a2),d2
	cmpa.l	#$1834C,a2
	beq.w	getlchoice2
	move.w	-$340(a2),d2
getlchoice2
	sub.w	$26(a2),d2
	beq.w	L15C84
	addi.w	#$15,d0
	tst.w	d2
	bmi.w	L15C84
	addi.w	#$15,d0
L15C84	move.w	$16(a2),d1
	add.w	d1,d0
	add.w	d1,d0
	add.w	d1,d0
	dc.w	$41FA,$000E
	move.b	(a0,d0.w),d0
	ext.w	d0
	movem.l	(sp)+,d1-d2
	rts
	dc.w	$0001,$0201,$0200,$0200,$0100,$0102,$0001,$0200
	dc.w	$0102,$0001,$0203,$04FF,$0304,$FF03,$04FF,$0304
	dc.w	$FF04,$03FF,$0304,$FF03,$04FF,$0506,$FF05,$06FF
	dc.w	$0506,$FF05,$06FF,$0506,$FF05,$06FF,$0605,$FF00
lineinput
	btst	#$3,$17F74.l
	beq.w	L15CF8
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$4EB9,$0003,$0EC6
	movem.l	(sp)+,d0-d7/a0-a6
L15CF8	move.w	d1,-(sp)
	movea.l	#tmstruct,a2
	btst	#$6,$62(a3)
	beq.w	L15D0E
	adda.w	#$366,a2
L15D0E	bclr	#$0,$32(a2)
	beq.w	L15D20
	bsr.w	lcfound_close
	bsr.w	Sub_30B50
L15D20	move.w	(sp)+,d1
	clr.w	d2
	btst	#$6,d1
	bne.w	Sub_30D64
	addi.w	#$1,d2
	btst	#$4,d1
	bne.w	Sub_30D64
	addi.w	#$1,d2
	btst	#$5,d1
	bne.w	Sub_30D64
	btst	#$3,$62(a3)
	beq.w	L15D62
	btst	#$5,$62(a3)
	bne.w	L15D62
	btst	#$0,$63(a3)
	beq.w	Sub_363D6
L15D62	rts
Sub_30D64
	move.w	d2,d0
	move.w	d2,$30(a2)
	bsr.w	Sub_30C58
	tst.w	d0
	bpl.w	L15D7A
	jmp	$30AB0.l
L15D7A	bclr	#$3,$63(a3)
	bset	#$3,$62(a3)
	jsr	$3C958.l
	bclr	#$1,$32(a2)
	move.w	d0,$16(a2)
	dc.w	$4EB9,$0003,$D426
lcfound_close
	btst	#$7,$17F6A.l
	bne.w	L15EC4
	bsr.w	setlccords
	cmpi.w	#$F,(printy).l
	blt.w	L15DC0
	bclr	#$0,$17F6E.l
L15DC0	addi.w	#$1,d1
	move.w	#$7FF,d2
	bsr.w	eraser
	dc.w	$4EF9,$0003,$C48C
burst
	dc.w	$4EB9,$0003,$C2A0
	dc.w	$4A79,$0001,$8C0A
	bne.w	L15DFC
	subi.w	#$CC,d0
	dc.w	$4EB9,$0003,$C2C2
	btst	#$4,$17F7A.l
	beq.w	L15DFC
	move.w	#$1000,d0
L15DFC	lsr.w	#$7,d0
	move.w	d0,d1
	move.w	$54(a3),d2
	asl.w	#$2,d2
	movea.l	#$36B8E,a0
	muls.w	(a0,d2.w),d0
	muls.w	$2(a0,d2.w),d1
	add.w	d0,$28(a3)
	add.w	d1,$2A(a3)
	bset	#$5,$62(a3)
	move.w	#$C5E,d1
	bra.w	Sub_363C0
Holdplayer
	bset	#$5,$62(a3)
	move.w	#$1122,d1
	tst.w	$32(a3)
	beq.w	Sub_363C0
	dc.w	$207C,$0001,$7480
	move.w	$2E(a3),d0
	asl.w	#$7,d0
	adda.w	d0,a0
Acheck
	bset	#$5,$62(a3)
	move.w	#$1122,d1
	tst.w	$32(a3)
	beq.w	L15E78
	move.w	$14(a3),d0
	sub.w	$14(a0),d0
	btst	#$7,$62(a3)
	beq.w	L15E70
	neg.w	d0
L15E70	bmi.w	L15E78
	move.w	#$C90,d1
L15E78	bra.w	Sub_363C0
setpassmode
	dc.w	$33EB,$0054,$0001,$7E2C
	dc.w	$0279,$0007,$0001,$7E2C
	btst	#$2,$17F70.l
	beq.w	L15EBC
	bclr	#$2,$17F78.l
	bset	#$5,$17F70.l
	bne.w	Sub_30A6E
	bclr	#$5,$17F78.l
	dc.w	$33FC,$0064,$0001,$7F9A
L15EBC	bset	#$2,$17F6A.l
L15EC4	rts
passmode
	btst	#$4,d2
	bne.w	dopass
	btst	#$3,$17F74.l
	bne.w	dopass
	btst	#$3,d0
	bne.w	L15EC4
	andi.w	#$7,d0
	dc.w	$33C0,$0001,$7E2C
	bset	#$3,d0
dopass
	movem.l	d0-d5/a0-a1,-(sp)
	bclr	#$2,$17F6A.l
	st.b	$17BE0.l
	move.b	#$10,$5E(a3)
	dc.w	$33EB,$0052,$0001,$7E2A
	bclr	#$3,$17F74.l
	beq.w	L15F48
	jsr	(OneTimerTarget).l
	dc.w	$33FC,$0012,$0001,$937A
	btst	#$2,(sflags6).l
	beq.w	L15F3E
	dc.w	$33FC,$003A,$0001,$937A
L15F3E	jsr	(OneTimerPass).l
	bra.w	L1606C
L15F48	moveq	#$8,d0
	tst.w	$34(a3)
	beq.w	L15F56
	move.b	$6E(a3),d0
L15F56	asl.w	#$2,d0
	asr.w	#$1,d0
	addi.w	#$A0,d0
	dc.w	$33C0,$0001,$7E2E
	btst	#$0,$6E(a3)
	beq.w	L15F76
	asr.w	#$4,d0
	dc.w	$D179,$0001,$7E2E
L15F76	moveq	#-1,d4
	moveq	#$5,d3
	dc.w	$227C,$0001,$7480
	cmpi.w	#$6,$52(a3)
	blt.w	L15F9A
	adda.w	#$300,a1
	btst	#$2,$17F70.l
	bne.w	L16016
L15F9A	cmpa.l	a1,a3
	beq.w	L16000
	tst.w	$34(a1)
	beq.w	L16000
	btst	#$2,$63(a1)
	bne.w	L16000
	move.w	$0(a1),d0
	dc.w	$9079,$0001,$7B80
	move.w	$14(a1),d1
	dc.w	$9279,$0001,$7B94
	movem.w	d0-d1,-(sp)
	bsr.w	vtoa
	movem.w	(sp)+,d1-d2
	dc.w	$9079,$0001,$7E2C
	andi.w	#$7,d0
	asl.b	#$5,d0
	ext.w	d0
	asl.w	#$3,d0
	muls.w	d0,d0
	cmpi.l	#$10000,d0
	bhi.w	L16000
	muls.w	d1,d1
	muls.w	d2,d2
	add.l	d1,d2
	add.l	d0,d2
	cmp.l	d4,d2
	bhi.w	L16000
	move.l	d2,d4
	movea.l	a1,a0
L16000	adda.w	#$80,a1
	dbra	d3,L15F9A
	tst.l	d4
	bmi.w	L16016
	bsr.w	passto
	bra.w	L1606C
L16016	dc.w	$3039,$0001,$7E2C
	asl.w	#$2,d0
	movea.l	#$36B8E,a0
	move.w	$2(a0,d0.w),d1
	dc.w	$C3F9,$0001,$7E2E
	dc.w	$243C,$0000,$000A
	asl.l	d2,d1
	divs.w	#$BB8,d1
	add.w	$2A(a3),d1
	dc.w	$33C1,$0001,$7BAA
	move.w	(a0,d0.w),d1
	dc.w	$C3F9,$0001,$7E2E
	asl.l	d2,d1
	divs.w	#$BB8,d1
	add.w	$28(a3),d1
	dc.w	$33C1,$0001,$7BA8
	move.w	#$1000,d0
	bsr.w	randomd0
	dc.w	$33C0,$0001,$7BAC
L1606C	tst.w	$34(a3)
	bne.w	L16096
	dc.w	$4A79,$0001,$7BAA
	btst	#$7,$62(a3)
	beq.w	L1608C
	bmi.w	L16090
	bra.w	L16096
L1608C	bmi.w	L16096
L16090	dc.w	$4479,$0001,$7BAA
L16096	dc.w	$3039,$0001,$7BA8
	dc.w	$3239,$0001,$7BAA
	bsr.w	vtoa
	move.w	#$366,d1
	tst.w	$34(a3)
	beq.w	L160C2
	move.w	#$718,d1
	bsr.w	Findhittype
	beq.w	L160C2
	move.w	#$78A,d1
L160C2	bsr.w	Sub_363C0
	bset	#$5,$62(a3)
	moveq	#$C,d0
	dc.w	$9039,$0001,$7BAC
	lsr.w	#$2,d0
	andi.w	#$3,d0
	move.w	#$10,d0
	move.w	d0,-(sp)
	bsr.w	sfx
	movem.l	(sp)+,d0-d5/a0-a1
	rts
