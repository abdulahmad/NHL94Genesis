skateto						;a0 = extra routine for collision avoidance, d0/d1 = x/y cord to skate to,
	
	sub.b	d7,$42(a3)
	bpl.w	.ex
	addi.b	#$C,$42(a3)
	bsr.w	avdgoal
	movem.w	d0-d1,-(sp)
	move.w	$28(a3),d0
	asr.w	#$8,d0
	neg.w	d0
	add.w	(sp)+,d0
	sub.w	$0(a3),d0
	move.w	$2A(a3),d1
	asr.w	#$8,d1
	neg.w	d1
	add.w	(sp)+,d1
	sub.w	$14(a3),d1
	cmpi.w	#$C,d0
	bgt.w	.vt
	cmpi.w	#$FFF4,d0
	blt.w	.vt
	cmpi.w	#$C,d1
	bgt.w	.vt
	cmpi.w	#$FFF4,d1
	blt.w	.vt
	moveq	#$9,d0
	bra.w	.nvt
.vt	bsr.w	vtoa
.nvt	jsr	(a0)
	move.b	d0,$43(a3)
	cmpi.w	#$7,d0
	ble.w	.ex
	move.w	$28(a3),d0
	or.w	$2A(a3),d0
	bne.w	.ex
	move.w	$17B80.l,d0
	move.w	$17B94.l,d1
	btst	#$0,$17BE3.l
	beq.w	.nf
	move.w	$17EDC.l,d0
	move.w	$17EDE.l,d1
.nf	sub.w	$0(a3),d0
	sub.w	$14(a3),d1
	bsr.w	vtoa
	sub.w	$54(a3),d0
	beq.w	.ex
	neg.w	d0
	andi.w	#$4,d0
	lsr.w	#$1,d0
	subi.w	#$1,d0
	add.w	$54(a3),d0
	andi.w	#$7,d0
	move.w	d0,$54(a3)
.ex	clr.w	d0
	move.b	$43(a3),d0
	bra.w	doplayeracc
avdgoal	clr.w	$17EEA.l
	clr.w	$17EEC.l
	tst.w	$34(a3)
	beq.w	rtss2
	move.w	$0(a3),d2
	eor.w	d0,d2
	bpl.w	.l1B17A
	move.w	d1,d2
	sub.w	$14(a3),d2
	move.w	$0(a3),d3
	muls.w	d3,d2
	sub.w	d0,d3
	divs.w	d3,d2
	add.w	$14(a3),d2
	cmpi.w	#$121,d2
	bgt.w	.l1B17A
	cmpi.w	#$DB,d2
	blt.w	.l1B144
	move.w	#$144,d3
	cmpi.w	#$FE,d2
	bgt.w	.l1B138
	blt.w	.l1B134
	cmpi.w	#$FE,$14(a3)
	bgt.w	.l1B138
.l1B134	move.w	#$B8,d3
.l1B138	sub.w	d2,d3
	move.w	d3,$17EEC.l
	bra.w	.l1B17A
.l1B144	cmpi.w	#$FF25,d2
	bgt.w	.l1B17A
	cmpi.w	#$FEDF,d2
	blt.w	.l1B17A
	move.w	#$FF48,d3
	cmpi.w	#$FF02,d2
	bgt.w	.l1B172
	blt.w	.l1B16E
	cmpi.w	#$FF02,$14(a3)
	bgt.w	.l1B172
.l1B16E	move.w	#$FEBC,d3
.l1B172	sub.w	d2,d3
	move.w	d3,$17EEC.l
.l1B17A	move.w	d1,d3
	subi.w	#$FE,d3
	move.w	$14(a3),d2
	subi.w	#$FE,d2
	bsr.w	.l1B1AC
	move.w	d1,d3
	addi.w	#$FE,d3
	move.w	$14(a3),d2
	addi.w	#$FE,d2
	bsr.w	.l1B1AC
	add.w	$17EEA.l,d0
	add.w	$17EEC.l,d1
	rts
.l1B1AC	move.w	d3,d4
	eor.w	d2,d4
	bpl.w	rtss2
	move.w	d0,d4
	sub.w	$0(a3),d4
	muls.w	d2,d4
	sub.w	d3,d2
	divs.w	d2,d4
	add.w	$0(a3),d4
	cmpi.w	#$50,d4
	bgt.w	rtss2
	cmpi.w	#$FFB0,d4
	blt.w	rtss2
	moveq	#$50,d3
	tst.w	d4
	bne.w	.l1B1E0
	tst.w	$0(a3)
.l1B1E0	bpl.w	.l1B1E6
	neg.w	d3
.l1B1E6	sub.w	d4,d3
	move.w	d3,$17EEA.l
	rts
skatetopuckinit						;d0/d1 = puck x/y plus half the high byte of its
	
	move.b	$17BA8.l,d0
	asr.b	#$1,d0
	ext.w	d0
	add.w	$17B80.l,d0
	move.b	$17BAA.l,d1
	asr.b	#$1,d1
	ext.w	d1
	add.w	$17B94.l,d1
	rts
skatetopuck						;player a3 should skate to puck. d7 = elapse frames
	bsr.w	skatetopuckinit
	sub.b	d7,$42(a3)
	bpl.w	.ex
	addi.b	#$A,$42(a3)
	bsr.w	avdgoal
	movem.w	d0-d1,-(sp)
	move.l	a3,-(sp)
	bsr.w	GetHotSub1
	neg.b	d0
	neg.b	d1
	sub.b	$28(a3),d0
	ext.w	d0
	add.w	(sp)+,d0
	sub.w	$0(a3),d0
	sub.b	$2A(a3),d1
	ext.w	d1
	add.w	(sp)+,d1
	sub.w	$14(a3),d1
	bsr.w	vtoa
	move.b	d0,$43(a3)
	tst.w	$34(a3)
	beq.w	.ex
	move.w	$17BA8.l,d0
	move.w	$17BAA.l,d1
	bsr.w	vtoa
	eori.w	#$4,d0
	cmp.w	$54(a3),d0
	beq.w	.ex
	move.w	$17B80.l,d0
	sub.w	$0(a3),d0
	move.w	$17B94.l,d1
	sub.w	$14(a3),d1
	movem.w	d0-d1,-(sp)
	bsr.w	vtoa
	cmp.w	$54(a3),d0
	movem.w	(sp)+,d0-d1
	bne.w	.ex
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmpi.l	#$384,d0
	bls.w	.ex
	cmpi.l	#$5A4,d0
	bls.w	Sweepcheck
.ex	move.b	$43(a3),d0
	bra.w	doplayeracc
assexit
	addi.w	#$1,$36(a3)
	andi.w	#$7,$36(a3)
	bset	#$1,$62(a3)
	rts
assexitSub1
	subi.w	#$1,$36(a3)
	andi.w	#$7,$36(a3)
assreplace
	move.l	d1,-(sp)
	move.w	$36(a3),d1
	move.b	d0,$38(a3,d1.w)
	bset	#$1,$62(a3)
	move.l	(sp)+,d1
	rts
vtoa						;d0/d1 are x/y distances which are converted into direction 0-7 and
	
	movem.l	d2/a0,-(sp)
	move.w	d0,d2
	or.w	d1,d2
	beq.w	.nodir
	clr.w	d2
	tst.w	d0
	bpl.w	.0
	neg.w	d0
	bset	#$0,d2
.0	tst.w	d1
	bpl.w	.1
	neg.w	d1
	bset	#$1,d2
.1	asl.w	#$1,d1
	cmp.w	d1,d0
	bhi.w	.2
	bset	#$2,d2
.2	lsr.w	#$1,d1
	asl.w	#$1,d0
	cmp.w	d0,d1
	bhi.w	.3
	bset	#$3,d2
.3	movea.l	#GetHot,a0
	clr.w	d0
	move.b	(a0,d2.w),d0
	movem.l	(sp)+,d2/a0
	rts
.nodir	moveq	#$8,d0
	movem.l	(sp)+,d2/a0
	rts
GetHot						;push long address of structure to get hot spot from. Hot spot x/y
	
	btst	d0,d7
	dc.w	$0305
	dc.l	$404
	dc.w	$0206,$0206
	btst	d0,d7
	btst	d1,d5
GetHotSub1
	movem.l	a0-a1,-(sp)
	movea.l	$C(sp),a0
	clr.w	d0
	clr.w	d1
	tst.w	$6(a0)
	ble.w	.l1B3B8
	movea.l	$47D28.l,a1
	subq.l	#$2,a1
	move.w	$6(a0),d0
	add.w	d0,d0
	move.b	$1(a1,d0.w),d1
	ext.w	d1
	move.b	(a1,d0.w),d0
	ext.w	d0
	btst	#$3,$4(a0)
	beq.w	.l1B39C
	neg.w	d0
.l1B39C	btst	#$4,$4(a0)
	bne.w	.l1B3A8
	neg.w	d1
.l1B3A8	btst	#$7,$17F6A.l
	beq.w	.l1B3B8
	exg.l	d0,d1
	neg.w	d1
.l1B3B8	movem.l	(sp)+,a0-a1
	move.l	(sp)+,(sp)
	rts
SetSPA
	cmp.w	$58(a3),d1
	beq.w	rtss2
	clr.w	$5A(a3)
	move.w	d1,$58(a3)
	st.b	$5C(a3)
	rts
doplayeracc
	tst.w	$34(a3)
	beq.w	goalieacc_1
	move.w	#$50C,d1
	btst	#$4,$62(a3)
	beq.w	.l1B3F0
	move.w	#$A60,d1
.l1B3F0	andi.w	#$F,d0
	cmpi.w	#$7,d0
	ble.w	.l1B41C
	cmpi.w	#$9,d0
	bne.w	.l1B410
	move.w	$28(a3),d0
	or.w	$2A(a3),d0
	bne.w	dostop
.l1B410	btst	#$1,$63(a3)
	beq.w	SetSPA
	rts
.l1B41C	movem.w	d0-d1,-(sp)
	move.w	d0,d2
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	beq.w	.l1B4F4
	move.w	$17B80.l,d0
	sub.w	$0(a3),d0
	move.w	$14(a3),d3
	move.b	$17BAA.l,d1
	ext.w	d1
	add.w	$17B94.l,d1
	sub.w	d3,d1
	btst	#$7,$62(a3)
	bne.w	.l1B462
	neg.w	d0
	neg.w	d1
	neg.w	d3
	eori.w	#$4,d2
.l1B462	btst	#$4,$62(a3)
	bne.w	.l1B492
	tst.w	d3
	bpl.w	.l1B4F4
	cmpi.w	#$4,d2
	bne.w	.l1B4F4
	bsr.w	vtoa
	addi.w	#$1,d0
	andi.w	#$7,d0
	cmpi.w	#$2,d0
	bhi.w	.l1B4F4
	bra.w	.l1B4B6
.l1B492	subi.w	#$3,d2
	andi.w	#$7,d2
	cmpi.w	#$2,d2
	bhi.w	.l1B4F4
	bsr.w	vtoa
	addi.w	#$2,d0
	andi.w	#$7,d0
	cmpi.w	#$4,d0
	bhi.w	.l1B4F4
.l1B4B6	btst	#$4,$62(a3)
	bne.w	.l1B4FA
	move.w	$28(a3),d0
	or.w	$2A(a3),d0
	beq.w	.l1B4EA
	move.w	$28(a3),d0
	move.w	$2A(a3),d1
	bsr.w	vtoa
	sub.w	(sp),d0
	addi.w	#$1,d0
	andi.w	#$7,d0
	cmpi.w	#$2,d0
	bhi.w	.l1B4FA
.l1B4EA	bset	#$4,$62(a3)
	bra.w	.l1B4FA
.l1B4F4	bclr	#$4,$62(a3)
.l1B4FA	movem.w	(sp)+,d0-d1
	move.w	$54(a3),d2
	sub.w	d2,d0
	andi.w	#$7,d0
	movea.l	#$36594,a0
	asl.w	#$1,d0
	tst.w	(a0,d0.w)
	beq.w	noturn0
	move.w	$28(a3),d4
	muls.w	d4,d4
	move.w	$2A(a3),d3
	muls.w	d3,d3
	add.l	d4,d3
	swap	d3
	move.w	#$300,d4
	sub.w	d3,d4
	cmpi.w	#$180,d4
	bge.w	.l1B53A
	move.w	#$180,d4
.l1B53A	muls.w	(a0,d0.w),d4
	btst	#$4,$62(a3)
	beq.w	.l1B54A
	neg.l	d4
.l1B54A	add.l	d4,$54(a3)
	andi.w	#$7,$54(a3)
	move.w	$54(a3),d2
	cmpi.w	#$14,d3
	bls.w	.l1B586
	clr.w	d1
	tst.w	(a0,d0.w)
	bpl.w	.l1B56E
	eori.w	#$FFCE,d1
.l1B56E	btst	#$3,$4(a3)
	beq.w	.l1B57C
	eori.w	#$FFCE,d1
.l1B57C	addi.w	#$694,d1
	bset	#$1,$63(a3)
.l1B586	bsr.w	SetSPA
	cmpi.w	#$2,d3
	bhi.w	noturn_1
	rts
goalieacc						;goalie gets acc. in direction d0. Turns facedir one step toward d0
	ori.b	#$10,d0
	dc.w	$0010,$0010
	dc.l	$FFF0
	dc.w	$FFF0
	dc.w	$FFF0
goalieacc_1	btst	#$3,$62(a3)
	beq.w	.normalgoalie
	movem.w	d0,-(sp)
	move.w	$17BE0.l,d0
	cmp.w	$52(a3),d0
	movem.w	(sp)+,d0
	beq.w	.normalgoalie
	cmpi.w	#$30,$0(a3)
	bgt.w	.normalgoalie
	cmpi.w	#$FFD0,$0(a3)
	blt.w	.normalgoalie
	cmpi.w	#$FF40,$14(a3)
	bgt.w	.checkbottom
	cmpi.w	#$FEFA,$14(a3)
	blt.w	.normalgoalie
	bra.w	.facepuck
.checkbottom	cmpi.w	#$C0,$14(a3)
	blt.w	.normalgoalie
	cmpi.w	#$106,$14(a3)
	bgt.w	.normalgoalie
.facepuck	movem.w	d0-d1,-(sp)
	move.w	$17B80.l,d0
	sub.w	$0(a3),d0
	move.w	$17B94.l,d1
	sub.w	$14(a3),d1
	cmpi.w	#$10,d0
	bgt.w	.usevtoa
	cmpi.w	#$FFF0,d0
	blt.w	.usevtoa
	cmpi.w	#$10,d1
	bgt.w	.usevtoa
	cmpi.w	#$FFF0,d1
	blt.w	.usevtoa
	move.w	$54(a3),d0
	bra.w	.checkadjust
.usevtoa	bsr.w	vtoa
.checkadjust	btst	#$0,$17F72.l
	bne.w	.adjustkeepdir
	bsr.w	AdjustFacingDirection
	movem.w	(sp)+,d0-d1
	bra.w	.setready
.adjustkeepdir	movem.w	(sp)+,d0-d1
	cmpi.w	#$8,d0
	beq.w	.setready
	movem.w	d0-d1,-(sp)
	bsr.w	AdjustFacingDirection
	movem.w	(sp)+,d0-d1
.setready	move.w	#$2,d1
	btst	#$1,$63(a3)
	bne.w	.exit
	bsr.w	SetSPA
	cmpi.w	#$8,d0
	bne.w	.playermove
	tst.w	$34(a3)
	bne.w	.playermove
	btst	#$3,$62(a3)
	beq.w	.playermove
	move.w	d0,-(sp)
	move.w	$14(a3),d0
	btst	#$7,$62(a3)
	beq.w	.topstay
	neg.w	d0
.topstay	cmpi.w	#$D8,d0
	blt.w	.stopandrestore
	move.w	$0(a3),d0
	cmpi.w	#$20,d0
	bgt.w	.stopandrestore
	cmpi.w	#$FFE0,d0
	blt.w	.stopandrestore
	move.w	(sp)+,d0
	jsr	(stopna2).l
	bra.w	.playermove
.stopandrestore	jsr	(stopna2).l
	move.w	(sp)+,d0
.playermove	move.w	d0,d2
	bra.w	playeracc
.normalgoalie	move.w	#$2,d1
	btst	#$3,$62(a3)
	beq.w	.goalieacc2
	btst	#$2,$62(a3)
	bne.w	.cgl
	cmpi.w	#$8,d0
	bne.w	.turnskater
	tst.w	$34(a3)
	bne.w	.cgl
	move.w	d0,-(sp)
	move.w	$14(a3),d0
	btst	#$7,$62(a3)
	beq.w	.topstop
	neg.w	d0
.topstop	cmpi.w	#$D8,d0
	blt.w	.restoreidle
	move.w	$0(a3),d0
	cmpi.w	#$20,d0
	bgt.w	.restoreidle
	cmpi.w	#$FFE0,d0
	blt.w	.restoreidle
	move.w	(sp)+,d0
	bsr.w	stopna
	bra.w	.cgl
.restoreidle	move.w	(sp)+,d0
	bra.w	.cgl
.turnskater	bra.w	.d1
.goalieacc2	andi.w	#$F,d0
	cmpi.w	#$7,d0
	ble.w	.d1
	cmpi.w	#$9,d0
	bne.w	.cgl
	move.w	$28(a3),d0
	or.w	$2A(a3),d0
	beq.w	.cgl
	jmp	(stopna2).l
.cgl	btst	#$1,$63(a3)
	beq.w	SetSPA
.exit	rts
.d1	sub.w	$54(a3),d0
	beq.w	.d11
	neg.w	d0
	andi.w	#$4,d0
	lsr.w	#$1,d0
	subi.w	#$1,d0
	add.w	$54(a3),d0
	andi.w	#$7,d0
	move.w	d0,$54(a3)
.d11	move.w	#$3D8,d1
	bsr.w	SetSPA
	move.w	$54(a3),d2
	bra.w	playeracc
noturn0						;doplayeracc when the wanted direction needs no turn (.ftab entry 0). d0 =
	
	moveq	#$2,d4
	btst	#$4,$62(a3)
	beq.w	.0
	addi.w	#$4,d4
	eori.w	#$8,d0
.0	tst.w	d0
	beq.w	noturn
	move.w	$28(a3),d0
	move.w	$2A(a3),d1
	bsr.w	vtoa
	btst	#$3,d0
	bne.w	.nostop
	sub.w	$54(a3),d0
	add.w	d4,d0
	andi.w	#$7,d0
	cmpi.w	#$4,d0
	blt.w	dostop
.nostop	addi.w	#$1,$54(a3)
	btst	#$3,$4(a3)
	beq.w	.nos0
	subi.w	#$2,$54(a3)
.nos0	andi.w	#$7,$54(a3)
	move.w	#$50C,d1
	btst	#$4,$62(a3)
	beq.w	SetSPA
	move.w	#$A60,d1
	bra.w	SetSPA
noturn						;reverse the acc. direction when skating backwards, then falls into
	
	move.w	#$A92,d1
	btst	#$4,$62(a3)
	bne.w	.l1B85C
	move.w	#$5D0,d1
	btst	#$6,$63(a3)
	beq.w	.l1B84A
	move.w	#$11E6,d1
.l1B84A	move.w	$17BE0.l,d4
	cmp.w	$52(a3),d4
	bne.w	.l1B85C
	move.w	#$53E,d1
.l1B85C	btst	#$1,$63(a3)
	bne.w	noturn_1
	bsr.w	SetSPA
noturn_1	btst	#$4,$62(a3)
	beq.w	playeracc
	eori.w	#$4,d2		;opposite direction
playeracc
	asl.w	#$2,d2
	lea.l	stopnaTbl1(pc),a0
	move.w	$2(a0,d2.w),d1
	move.w	(a0,d2.w),d0
	move.w	$50(a3),d2
	beq.w	.l1B896
	eor.w	d0,d2
	bpl.w	.l1B896
	clr.w	d0
.l1B896	move.w	$4E(a3),d2
	beq.w	.l1B8A6
	eor.w	d1,d2
	bmi.w	.l1B8A6
	clr.w	d1
.l1B8A6	clr.w	d2
	move.b	$67(a3),d2
	lsr.w	#$2,d2
	neg.w	d2
	addi.w	#$40,d2
	add.b	$68(a3),d2
	btst	#$1,$17F7C.l
	bne.w	.l1B8D0
	btst	#$6,$17F7A.l
	beq.w	.l1B8D8
.l1B8D0	addi.b	#$2,d2
	addi.b	#$2,d2
.l1B8D8	tst.w	$34(a3)
	bne.w	.l1B8E8
	add.b	$68(a3),d2
	addi.w	#$10,d2
.l1B8E8	asr.w	#$1,d2
	muls.w	d2,d0
	muls.w	d2,d1
	asr.l	#$5,d0
	asr.l	#$5,d1
	muls.w	d7,d0
	muls.w	d7,d1
	tst.w	$34(a3)
	bne.w	.l1B91A
	btst	#$3,$62(a3)
	beq.w	.l1B91A
	move.w	$17BE0.l,d2
	cmp.w	$52(a3),d2
	bne.w	.l1B91A
	asr.w	#$1,d0
	asr.w	#$1,d1
.l1B91A	add.w	$28(a3),d0
	add.w	$2A(a3),d1
	move.w	d0,d2
	move.w	d1,d3
	muls.w	d2,d2
	muls.w	d3,d3
	add.l	d2,d3
	movem.w	d0-d1,-(sp)
	bsr.w	getpde
	btst	#$4,$17F7A.l
	beq.w	.l1B944
	move.w	#$1000,d0
.l1B944	clr.w	d2
	move.b	$69(a3),d2
	btst	#$1,$17F7C.l
	bne.w	.l1B962
	btst	#$6,$17F7A.l
	beq.w	.l1B972
.l1B962	addi.b	#$2,d2
	cmpi.b	#$1E,d2
	ble.w	.l1B972
	move.b	#$1E,d2
.l1B972	move.w	d2,$17E66.l
	lsr.w	#$1,d2
	mulu.w	d0,d2
	asl.l	#$4,d2
	swap	d2
	asl.w	#$2,d2
	andi.w	#$3F,d2
	lea.l	MaxSpeed(pc),a2
	move.w	d2,$17E6C.l
	move.l	(a2,d2.w),d2
	move.l	d2,$17E68.l
	cmpi.w	#$3C,$17E6C.l
	bge.w	.l1B9CE
	btst	#$0,$17E67.l
	beq.w	.l1B9CE
	move.w	$17E6C.l,d2
	addi.w	#$4,d2
	move.l	(a2,d2.w),d2
	sub.l	$17E68.l,d2
	asr.l	#$1,d2
	add.l	$17E68.l,d2
.l1B9CE	btst	#$6,$63(a3)
	beq.w	.l1B9DA
	lsr.l	#$3,d2
.l1B9DA	tst.w	$34(a3)
	bne.w	.l1B9F2
	move.w	$17BE0.l,d0
	cmp.w	$52(a3),d0
	bne.w	.l1B9F2
	asr.l	#$1,d2
.l1B9F2	movem.w	(sp)+,d0-d1
	cmp.l	d2,d3
	bhi.w	.l1BA04
	move.w	d0,$28(a3)
	move.w	d1,$2A(a3)
.l1BA04	tst.w	$18C0A.l
	bne.w	rtss2
.l1BA0E	btst	#$7,$FF800E.l
	bne.b	.l1BA0E
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.l1BA28	btst	#$6,$FF800E.l
	beq.b	.l1BA28
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1BA48	btst	#$6,$FF800E.l
	bne.b	.l1BA48
	bclr	#$7,$FF800F.l
	andi.w	#$7F,d0
	bne.w	rtss2
	bsr.w	getpde
	subi.w	#$21,d0
	cmpi.w	#$C00,d0
	blt.w	setpde
	move.b	$72(a3),d2
	ext.w	d2
	lsr.w	#$1,d2
	add.w	d2,d0
	bsr.w	setpde
	btst	#$0,$72(a3)
	beq.w	.l1BA9E
	btst	#$0,$17475.l
	beq.w	.l1BA9E
	addi.w	#$1,d0
	bra.w	setpde
.l1BA9E	rts
MaxSpeed						;max speed values for each rating level 0-$F: ((n+20)*275)^2 (92 used 250)
	dc.w	$01CD,$9410,$01FC,$E3E1,$022E,$8284,$0262,$6FF9
	dc.w	$0298,$AC40,$02D1,$3759,$030C,$1144,$0349,$3A01
	dc.w	$0388,$B190,$03CA,$77F1,$040E,$8D24,$0454,$F129
	dc.w	$049D,$A400,$04E8,$A5A9,$0535,$F624,$0585,$9571
dostop
	cmpi.w	#$1000,$28(a3)
	bgt.w	dostopSub1
	cmpi.w	#$F000,$28(a3)
	blt.w	dostopSub1
	cmpi.w	#$1000,$2A(a3)
	bgt.w	dostopSub1
	cmpi.w	#$F000,$2A(a3)
	blt.w	dostopSub1
	tst.w	$34(a3)
	bne.w	stopna
	jmp	(stopna2).l
	dc.w	$6000,$002C
dostopSub1
	move.w	#$50C,d1
	btst	#$4,$62(a3)
	bne.w	.l1BB32
	bset	#$1,$63(a3)
	move.w	#$6C6,d1
.l1BB32	bsr.w	SetSPA
	tst.w	$34(a3)
	bne.w	stopna
	jmp	(stopna2).l
stopna						;slow player a3 by 150 on each axis, no animation change. Falls in from
	
	tst.w	$28(a3)
	bpl.w	.xp
	addi.w	#$96,$28(a3)
	bmi.w	.y
	clr.w	$28(a3)
.xp	subi.w	#$96,$28(a3)
	bpl.w	.y
	clr.w	$28(a3)
.y	tst.w	$2A(a3)
	bpl.w	.yp
	addi.w	#$96,$2A(a3)
	bmi.w	rtss2
	clr.w	$2A(a3)
.yp	subi.w	#$96,$2A(a3)
	bpl.w	rtss2
	clr.w	$2A(a3)
	rts
stopnaTbl1	dc.w	$0000,$00C8,$008D,$008D,$00C8,$0000,$008D,$FF73
	dc.w	$0000,$FF38,$FF73,$FF73,$FF38,$0000,$FF73,$008D
	dc.w	$0000,$0000
UnpackNibbles						;a0 = packed data, d0 = count: unpack 4-bit values into words at
									;nibblebuffer
	movem.l	d0-d2/a0-a1,-(sp)
	movea.l	#$18BE8,a1		;a1 = output words
	clr.w	d2		;d2 bit 0 = which nibble is next
	bra.w	.l1BBD8
.l1BBC2	move.b	(a0)+,d1		;next nibble (one count per pass)
	bchg	#$0,d2		;toggle high/low nibble
	bne.w	.l1BBD2		;low nibble?
	suba.w	#$1,a0		;high nibble: read the same byte again next time
	lsr.w	#$4,d1		;high nibble down
.l1BBD2	andi.w	#$F,d1
	move.w	d1,(a1)+
.l1BBD8	dbra	d0,.l1BBC2
	movem.l	(sp)+,d0-d2/a0-a1
	rts
WeightedRandomSelect						;d0 = number of word weights at nibblebuffer:
									;return a weighted random index
	movem.l	d1/a1,-(sp)
	movea.l	#$18BE8,a1		;weights
	clr.w	d1		;d1 = running total of the weights
	bra.w	.l1BBF4
.l1BBF2	add.w	(a1)+,d1
.l1BBF4	dbra	d0,.l1BBF2
	move.w	d1,d0
	bsr.w	randomd0		;random 0 to total-1
.l1BBFE	sub.w	-(a1),d0		;minus the weight
	bpl.w	.l1BBFE
	suba.l	#$18BE8,a1
	move.w	a1,d0
	lsr.w	#$1,d0		;word offset -> index
	movem.l	(sp)+,d1/a1
	rts
WeightedRandomSelectSub1
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	beq.s	.l1BC2C
	move.w	#$1,-(a6)
	bra.s	.l1BC30
.l1BC2C	move.w	#$0,-(a6)
.l1BC30	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movem.l	d0-d4/a0-a2,-(sp)
	exg.l	d0,d1
	movea.l	a0,a2
	bsr.w	setVramSub1
	subi.w	#$1,d1
.l1BC5E	moveq	#$3,d0
	move.w	(a2)+,d2
	clr.w	d3
.l1BC64	move.w	d2,d4
	andi.w	#$F,d4
	lsr.w	#$1,d4
	move.b	(a1,d4.w),d4
	btst	#$0,d2
	bne.w	.l1BC7A
	lsr.w	#$4,d4
.l1BC7A	andi.w	#$F,d4
	or.b	d4,d3
	ror.w	#$4,d3
	ror.w	#$4,d2
	dbra	d0,.l1BC64
.l1BC88	btst	#$7,$FF800E.l
	bne.b	.l1BC88
	move.w	d3,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
.l1BCA8	btst	#$6,$FF800E.l
	beq.b	.l1BCA8
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1BCC2	btst	#$6,$FF800E.l
	bne.b	.l1BCC2
	bclr	#$7,$FF800F.l
	dbra	d1,.l1BC5E
	movem.l	(sp)+,d0-d4/a0-a2
	move.w	(sp)+,(disflags).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.l1BCF8
	bset	#$5,$FF800F.l
	bra.s	.l1BD00
.l1BCF8	bclr	#$5,$FF800F.l
.l1BD00	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
forceblack
	movem.l	d0/a0,-(sp)
	movea.l	#$BBCB0,a0
	moveq	#$1F,d0
.l1BD16	move.l	(a0),-(sp)
	clr.l	(a0)+
	dbra	d0,.l1BD16
	move.w	#$18,(palcount).l
	bsr.w	forceblack2Sub1
	moveq	#$1F,d0
.l1BD2C	move.l	(sp)+,-(a0)
	dbra	d0,.l1BD2C
	movem.l	(sp)+,d0/a0
	rts
forceblack2
	movem.l	d0/a0,-(sp)
	movea.l	#$BBCB0,a0
	moveq	#$1F,d0
.l1BD44	move.l	(a0),-(sp)
	clr.l	(a0)+
	dbra	d0,.l1BD44
	move.w	#$64,(palcount).l
	bsr.w	forceblack2Sub1
	moveq	#$1F,d0
.l1BD5A	move.l	(sp)+,-(a0)
	dbra	d0,.l1BD5A
	movem.l	(sp)+,d0/a0
	rts
forceblack2Sub1
	move.l	(VBint).l,-(sp)
	move.w	(disflags).l,-(sp)
	bclr	#$2,(disflags).l
	move.l	#vb2,(VBint).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	beq.s	.l1BD9C
	move.w	#$1,-(a6)
	bra.s	.l1BDA0
.l1BD9C	move.w	#$0,-(a6)
.l1BDA0	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	bset	#$5,$FF800F.l
.l1BDB8	tst.w	(palcount).l
	bpl.w	.l1BDB8
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.l1BDD8
	bset	#$5,$FF800F.l
	bra.s	.l1BDE0
.l1BDD8	bclr	#$5,$FF800F.l
.l1BDE0	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	(sp)+,(disflags).l
	move.l	(sp)+,(VBint).l
	rts
