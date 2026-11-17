checkpuckcoll_sfx
	bclr	#$2,$17F72.l
	beq.w	rtss2
	move.w	#$5,-(sp)
	bra.w	sfx
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_20882.bin
puckstick
	tst.w	$34(a2)
	bne.w	L20C44
	btst	#$4,$17F68.l
	bne.w	rtss2
L20C44	bclr	#$0,$62(a2)
	move.w	$17BE0.l,d1
	bmi.w	L20D3A
	asl.w	#$7,d1
	dc.w	$207C,$0001,$7480
	adda.w	d1,a0
	move.b	$62(a0),d1
	move.b	$62(a2),d2
	eor.w	d1,d2
	btst	#$6,d2
	beq.w	rtss2
	btst	#$5,(sflags6).l
	beq.w	L20C8A
	cmpi.l	#$40,d0
	bhi.w	rtss2
	bra.w	L20C94
L20C8A	cmpi.l	#$24,d0
	bhi.w	rtss2
L20C94	tst.w	$34(a2)
	beq.w	L20CEA
	tst.w	$34(a0)
	beq.w	rtss2
	move.b	$71(a0),d0
	lsr.b	#$1,d0
	bsr.w	makepde
	move.w	d0,-(sp)
	exg.l	a0,a2
	move.b	$71(a0),d0
	lsr.b	#$1,d0
	bsr.w	makepde
	exg.l	a0,a2
	neg.w	d0
	add.w	(sp)+,d0
	addi.w	#$24,d0
	bsr.w	randomd0
	btst	#$5,(sflags6).l
	beq.w	L20CE2
	cmpi.w	#$4,d0
	bhi.w	rtss2
	bra.w	L20CEA
L20CE2	cmpi.w	#$2,d0
	bhi.w	rtss2
L20CEA	move.b	$71(a0),d0
	lsr.b	#$1,d0
	bsr.w	makepde
	addi.w	#$14,d0
	move.b	d0,$5E(a0)
	exg.l	a0,a2
	move.b	$71(a0),d0
	lsr.b	#$1,d0
	bsr.w	makepde
	addi.w	#$14,d0
	move.b	d0,$5E(a0)
	exg.l	a0,a2
	dc.w	$33E8,$0052,$0001,$7E2A
	bclr	#$2,$17F6A.l
	bclr	#$3,$17F6A.l
L20D2A	move.w	#$6,-(sp)
	bsr.w	sfx
	bsr.w	Sub_35D28
	bra.w	Sub_3C246
L20D3A	tst.w	$34(a2)
	bne.w	L20D4C
	cmpi.l	#$40,d0
	bhi.w	rtss2
L20D4C	btst	#$3,$64(a2)
	beq.w	L20D78
	cmpi.l	#$64,d0
	bhi.w	L20DCC
	cmpi.w	#$18,$5A(a2)
	bge.w	L20D78
	move.w	#$18,$5A(a2)
	bset	#$7,$17F7C.l
L20D78	dc.w	$3039,$0001,$7BA8
	dc.w	$3239,$0001,$7BAA
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	clr.w	d1
	btst	#$4,$17F6C.l
	bne.w	L20DAA
	btst	#$3,$64(a2)
	bne.w	L20DC0
	move.b	$71(a2),d1
	mulu.w	#$15E,d1
L20DAA	addi.w	#$32C8,d1
	mulu.w	d1,d1
	cmp.l	d1,d0
	bls.w	puckglue
	move.b	#$8,$5E(a2)
	bra.w	L20D2A
L20DC0	exg.l	a2,a3
	jsr	(onetimershot).l
	exg.l	a2,a3
	rts
L20DCC	cmpi.l	#$144,d0
	bhi.w	L20DE6
	cmpi.w	#$18,$5A(a2)
	bge.w	L20DE6
	move.w	#$18,$5A(a2)
L20DE6	rts
puckglue
	move.w	#$7,-(sp)
	move.w	$52(a2),d0
	move.w	d0,$17BE0.l
	movea.l	#tmstruct,a0
	lea.l	$366(a0),a1
	btst	#$6,$62(a2)
	bne.w	L20E0C
	exg.l	a0,a1
L20E0C	st.b	$1A(a0)
	st.b	$1C(a0)
	bset	#$3,$32(a0)
	bclr	#$4,$17F6E.l
	beq.w	L20E4E
	addi.w	#$1,$E(a1)
	addi.w	#$C8,(Crowdlevel).l
	move.w	#$C,(sp)
	cmpa.l	#$1834C,a1
	bne.w	L20E4E
	dc.w	$0679,$000A,$0001,$7CD8
	move.w	#$B,(sp)
L20E4E	bsr.w	sfx
	move.w	$52(a2),d0
	dc.w	$B079,$0001,$7E30
	bne.w	L20E66
	addi.w	#$1,$14(a1)
L20E66	dc.w	$50F9,$0001,$7E30
	bclr	#$2,$17F6A.l
	bclr	#$3,$17F6A.l
	tst.w	$34(a2)
	bne.w	L20E9E
	bsr.w	ChkShotStat
	move.w	#$8C,$48(a2)
	cmpi.w	#$2F4,$58(a2)
	bne.w	L20E9E
	move.w	#$5,$48(a2)
L20E9E	dc.w	$B079,$0001,$7F9E
	beq.w	rtss2
	dc.w	$B079,$0001,$7FA0
	beq.w	rtss2
	dc.w	$4A79,$0001,$7FAA
	beq.w	L20EC6
	dc.w	$B079,$0001,$7FA2
	beq.w	rtss2
L20EC6	dc.w	$4A79,$0001,$7FAC
	beq.w	L20EDA
	dc.w	$B079,$0001,$7FA4
	beq.w	rtss2
L20EDA	dc.w	$4A79,$0001,$7FAA
	bne.w	L20EEE
	dc.w	$4A79,$0001,$7FAC
	beq.w	L20F16
L20EEE	movem.l	d0/a3,-(sp)
	asl.w	#$7,d0
	dc.w	$267C,$0001,$7480
	tst.w	$34(a3,d0.w)
	bne.w	L20F12
	btst	#$3,$62(a3,d0.w)
	beq.w	L20F12
	movem.l	(sp)+,d0/a3
	rts
L20F12	movem.l	(sp)+,d0/a3
L20F16	cmpi.w	#$6,d0
	slt.b	d1
	ext.w	d1
	addi.w	#$2,d1
	dc.w	$3439,$0001,$7E2A
	dc.w	$B479,$0001,$7FA0
	beq.w	L20F42
	dc.w	$B279,$0001,$7FA6
	bne.w	L20F42
	jmp	(Sub_312B8).l
L20F42	dc.w	$B279,$0001,$7FA8
	bne.w	L20F52
	jmp	(Sub_312DC).l
L20F52	dc.w	$B279,$0001,$7FA6
	bne.w	rtss2
	jmp	(Sub_312B8).l
puckbody
	btst	#$3,$64(a2)
	bne.w	rtss2
	cmpi.w	#$8,$18(a3)
	bgt.w	L20F80
	move.w	d0,d1
	andi.w	#$F,d1
	bne.w	rtss2
L20F80	bsr.w	Sub_35D28
	move.w	#$24,-(sp)
	bsr.w	sfx
	clr.w	$2C(a3)
	move.b	#$8,$5E(a2)
	move.w	$0(a3),d0
	sub.w	$0(a2),d0
	move.w	$14(a3),d1
	sub.w	$14(a2),d1
	bne.w	L20FB0
	move.l	a2,-(sp)
	bsr.w	Sub_36362
L20FB0	move.w	$28(a3),d2
	move.w	$2A(a3),d3
	move.b	d0,$28(a3)
	move.b	d1,$2A(a3)
	bsr.w	puckflip
	cmpi.w	#$8,$18(a3)
	ble.w	rtss2
	muls.w	d2,d2
	muls.w	d3,d3
	add.l	d3,d2
	cmpi.l	#$9000000,d2
	bls.w	L20FEA
	cmpi.w	#$C,$18(a3)
	bgt.w	Sub_3A9BE
	rts
L20FEA	bset	#$5,$62(a2)
	bne.w	rtss2
	move.w	#$10D0,d1
	exg.l	a2,a3
	bsr.w	Sub_363C0
	exg.l	a2,a3
rtss2
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_21002.bin
Sub_3C246
	st.b	$17BE0.l
	move.w	#$1000,d0
	bsr.w	Sub_37044
	move.w	d0,$2A(a3)
	move.w	#$1000,d0
	bsr.w	Sub_37044
	move.w	d0,$28(a3)
	move.w	#$1000,d0
	bsr.w	randomd0
	move.w	d0,$2C(a3)
	bra.w	puckflip
makepde
	ext.w	d0
	move.w	d0,-(sp)
	movem.l	d1/a2-a3,-(sp)
	movea.l	a0,a3
	bsr.w	getpde
	btst	#$4,$17F7A.l
	beq.w	L21292
	move.w	#$1000,d0
L21292	movem.l	(sp)+,d1/a2-a3
	muls.w	(sp)+,d0
	asl.l	#$4,d0
	swap	d0
	ext.l	d0
	rts
getpde
	movea.l	#tmstruct,a2
	btst	#$6,$62(a3)
	beq.w	L212B4
	adda.w	#$366,a2
L212B4	move.b	$66(a3),d1
	ext.w	d1
	add.w	d1,d1
	move.w	$34(a2,d1.w),d0
	rts
Sub_3C2C2
	tst.w	d0
	bpl.w	L212CA
	clr.w	d0
L212CA	move.w	d0,$34(a2,d1.w)
	rts
updatepwrplay
	btst	#$1,$17F78.l
	bne.w	rtss2
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a3
	move.w	$26(a2),d0
	sub.w	$26(a3),d0
	beq.w	L2139C
	bpl.w	L21312
	btst	#$6,$17F6C.l
	bne.w	L2132C
	bsr.w	L2139C
	bset	#$6,$17F6C.l
	bra.w	L2132C
L21312	exg.l	a2,a3
	btst	#$6,$17F6C.l
	beq.w	L2132C
	bsr.w	L2139C
	bclr	#$6,$17F6C.l
L2132C	bset	#$5,$17F6C.l
	bne.w	L21350
	addi.w	#$1,$4(a3)
	cmpa.l	#$1834C,a3
	bne.w	L2134C
L21348	bra.w	L21350
L2134C	bra.w	L21348
L21350	bsr.w	printz
	dc.w	$0012
	dc.b	$BF,$01,$19,$20,$20,$20,$16,$17,$18,$19,$BF,$01,$1A,$20,$20,$00
	bsr.w	GetLowestPen
	bsr.w	PushTime
	bsr.w	print
	movea.l	$1E(a3),a0
	movea.l	#mesarea,a3
	move.w	#$2,(a3)
	bsr.w	Sub_39200
	String	CC_Font1Pri,$1,$19
	adda.w	$4(a0),a0
	adda.w	(a0),a0
	movea.l	a0,a1
	bsr.w	appstring
	movea.l	a3,a1
	bra.w	print
L2139C	bclr	#$5,$17F6C.l
	beq.w	rtss2
	bra.w	EASNLogo
ClrHor
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#$7,$17F6A.l
	dc.w	$33FC,$03E8,$0001,$7CEC
	dc.w	$3839,$0001,$8D48
	movea.l	$47D18.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	jsr	$2A9D0.l
	bsr.w	Sub_3F03E
	btst	#$0,$17F6A.l
	bne.w	L21404
	bsr.w	printz
	String	CC_Font1,$0,$0
	moveq	#$20,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	bsr.w	eraser
	bsr.w	printscores1
L21404	movem.l	(sp)+,d0-d7/a0-a6
	rts
SetHor
	movem.l	d0-d7/a0-a6,-(sp)
	bset	#$7,$17F6A.l
L21416	btst	#$0,(disflags).l
	bne.w	L21416
	dc.w	$4279,$0001,$7CF0
	dc.w	$4279,$0001,$7CF2
	bsr.w	Sub_3F03E
	bsr.w	printz
	String	CC_Font2,$0,$0
	movea.l	$47D6C.l,a1
	adda.l	$4(a1),a1
	movea.l	$47D6C.l,a2
	addq.l	#$8,a2
	clr.w	d0
	move.w	#$0,d1
	moveq	#$20,d2
	moveq	#$1C,d3
	dc.w	$3839,$0001,$8D48
	moveq	#$0,d5
	bsr.w	dobitmap
	bsr.w	USBoard
	btst	#$0,$17F6A.l
	bne.w	L21486
	move.w	#$800,d0
	move.w	(VmMAP1).l,d1
	move.w	#$7FF,d2
	bsr.w	Sub_37AA2
L21486	movem.l	(sp)+,d0-d7/a0-a6
	rts
printscores1
	movem.l	d0-d2/a0-a3,-(sp)
	btst	#$7,$17F6A.l
	bne.w	L21548
	bclr	#$7,$17F74.l
	beq.w	L214B0
	dc.w	$33FC,$0078,$0001,$7F82
L214B0	bsr.w	printz
	String	CC_Font1Pri,$0,$17
	moveq	#$9,d0
	moveq	#$5,d1
	bsr.w	Framer
	bset	#$3,(disflags).l
	bsr.w	printz
	String	CC_Font1Pri,$1,$18
	move.w	$180E4.l,d0
	movea.l	#$41A34,a1
	btst	#$1,$17F78.l
	beq.w	L214F6
	move.w	#$4,d0
	movea.l	#$41A48,a1
L214F6	bsr.w	Sub_3CEBE
	bsr.w	EASNLogo
	btst	#$0,$17F6E.l
	bne.w	L21542
	bsr.w	printz
	String	CC_Font1Pri,$17,$17
	moveq	#$8,d0
	moveq	#$5,d1
	bsr.w	Framer
	bsr.w	printz
	String	CC_Font1Pri,$18,$1A
	movea.l	#tmstruct,a2
	bsr.w	printscores1_ps
	bsr.w	printz
	String	CC_Font1Pri,$18,$18
	adda.w	#$366,a2
	bsr.w	printscores1_ps
L21542	movem.l	(sp)+,d0-d2/a0-a3
	rts
L21548	bsr.w	printz
	String	CC_Font2Pri,$11,$2
	move.w	$180E4.l,d0
	btst	#$0,$17F78.l
	beq.w	L21568
	move.w	#$4,d0
L21568	movea.l	#$41A48,a1
	bsr.w	Sub_3CEC6
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	bsr.w	print
	bsr.w	printz
	String	CC_Font2Pri,$17,$2
	movea.l	#tmstruct,a2
	clr.w	d0
	bsr.w	PrintTeamLogoAndScore
	bsr.w	printz
	String	CC_Font2Pri,$8,$2
	adda.w	#$366,a2
	moveq	#$2C,d0
	bsr.w	PrintTeamLogoAndScore
	bra.w	L21542
printscores1_ps
	movea.l	$1E(a2),a1
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	bsr.w	print
	move.w	#$1C,(printx).l
	move.w	$C(a2),d0
	moveq	#$2,d1
	bsr.w	PushNumberWidth
	bra.w	print
PrintTeamLogoAndScore
	move.w	(printx).l,-(sp)
	subi.w	#$5,(printx).l
	jsr	(Sub_2C59E).l
	move.w	(sp)+,(printx).l
	addi.w	#$2,(printy).l
	move.w	$C(a2),d0
	cmpi.w	#$A,d0
	bge.w	L21604
	bra.w	L2160C
L21604	subi.w	#$1,(printx).l
L2160C	bsr.w	PushNumber
	move.w	(a1),d0
	subi.w	#$2,d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	addi.w	#$1,(printx).l
	bra.w	printbig
EASNLogo
	btst	#$5,$17F6C.l
	bne.w	rtss2
	bsr.w	printz
	String	CC_Font1Pri,$1,$19
	movea.l	$47D4C.l,a1
	adda.l	$4(a1),a1
	movea.l	#$1B008,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	dc.w	$3839,$0001,$8D50
	clr.w	d5
	bra.w	dobitmap
USBoard
	movem.l	d0-d7/a0-a3,-(sp)
	bset	#$3,(disflags).l
	bsr.w	printscores1
	bsr.w	printz
	String	CC_Font2Pri,$14,$8
	dc.w	$247C,$0001,$834C,$6100,$001C,$6100,$C8E2,$0006
	dc.w	$BE05,$0800,$247C,$0001,$86B2,$6100,$0008,$4CDF
	dc.w	$0FFF,$4E75,$41EA,$009C,$4240,$1018,$6B00,$0014
	dc.w	$0832,$0006,$0068,$6600,$FFF0,$6100,$0024,$6000
	dc.w	$FFE8,$41EA,$009C,$4240,$1018,$6B00,$F934,$0832
	dc.w	$0006,$0068,$6700,$FFF0,$6100,$0006,$6000,$FFE8
pplpen
	cmpi.w	#$A,(printy).l
	bhi.w	rtss2
	move.w	$68(a2,d0.w),d2
	andi.w	#$7FF,d2
	movea.l	$1E(a2),a1
	adda.w	$0(a1),a1
	lsr.w	#$1,d0
L216FE	adda.w	(a1),a1
	adda.w	#$8,a1
	dbra	d0,L216FE
	clr.w	d0
	move.b	-$8(a1),d0
	move.w	(printx).l,-(sp)
	movea.l	#TextBuffer,a1
	bsr.w	ConvertByteToDigits
	movea.l	#mesarea,a1
	move.w	#$4,(a1)
	bsr.w	print
	move.w	d2,d0
	bsr.w	PushTime
	bsr.w	print
	move.w	(sp)+,(printx).l
	addi.w	#$1,(printy).l
	rts
linebar
	movem.l	d0-d5/a0-a2,-(sp)
	bsr.w	getlinee
	move.w	(printa).l,-(sp)
	move.w	#$8000,(printa).l
	ext.l	d0
	divu.w	#$100,d0
	cmpi.w	#$F,d0
	bls.w	L2176C
	moveq	#$F,d0
L2176C	moveq	#$F,d1
	sub.w	d0,d1
	clr.w	d0
	movea.l	$47D40.l,a1
	adda.l	$4(a1),a1
	movea.l	#$1B008,a2
	move.w	(a1),d2
	moveq	#$1,d3
	dc.w	$3839,$0001,$8D46
	moveq	#$0,d5
	bsr.w	dobitmap
	move.w	(sp)+,(printa).l
	movem.l	(sp)+,d0-d5/a0-a2
	rts
getlinee
	movem.l	d1-d5/a0-a3,-(sp)
	lea.l	$16C(a2),a1
	asl.w	#$3,d0
	adda.w	d0,a1
	clr.l	d0
	clr.w	d1
	movea.l	#$41AD6,a0
	move.w	$26(a2),d4
	bra.w	L217D6
L217BC	clr.w	d5
	move.b	(a0,d4.w),d5
	beq.w	L217D6
	clr.w	d3
	move.b	(a1,d5.w),d3
	asl.w	#$1,d3
	addi.w	#$1,d1
	add.w	$32(a2,d3.w),d0
L217D6	dbra	d4,L217BC
	divu.w	d1,d0
	movem.l	(sp)+,d1-d5/a0-a3
	rts
AvgCline
	movem.l	d1-d3/a0,-(sp)
	clr.l	d0
	clr.w	d1
	moveq	#$5,d2
	movea.l	$22(a2),a0
L217F0	tst.w	$34(a0)
	ble.w	L21808
	clr.w	d3
	move.b	$66(a0),d3
	add.w	d3,d3
	add.w	$34(a2,d3.w),d0
	addi.w	#$1,d1
L21808	adda.w	#$80,a0
	dbra	d2,L217F0
	tst.w	d1
	beq.w	L21818
	divu.w	d1,d0
L21818	movem.l	(sp)+,d1-d3/a0
	rts
