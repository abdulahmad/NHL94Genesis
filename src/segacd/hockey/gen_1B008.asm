skateto
	sub.b	d7,$42(a3)
	bpl.w	L1B0CE
	addi.b	#$C,$42(a3)
	bsr.w	L1B0D8
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
	bgt.w	L1B060
	cmpi.w	#$FFF4,d0
	blt.w	L1B060
	cmpi.w	#$C,d1
	bgt.w	L1B060
	cmpi.w	#$FFF4,d1
	blt.w	L1B060
	moveq	#$9,d0
	bra.w	L1B064
L1B060	bsr.w	vtoa
L1B064	jsr	(a0)
	move.b	d0,$43(a3)
	cmpi.w	#$7,d0
	ble.w	L1B0CE
	move.w	$28(a3),d0
	or.w	$2A(a3),d0
	bne.w	L1B0CE
	dc.w	$3039,$0001,$7B80
	dc.w	$3239,$0001,$7B94
	btst	#$0,$17BE3.l
	beq.w	L1B0A2
	move.w	$17EDC.l,d0
	move.w	$17EDE.l,d1
L1B0A2	sub.w	$0(a3),d0
	sub.w	$14(a3),d1
	bsr.w	vtoa
	sub.w	$54(a3),d0
	beq.w	L1B0CE
	neg.w	d0
	andi.w	#$4,d0
	lsr.w	#$1,d0
	subi.w	#$1,d0
	add.w	$54(a3),d0
	andi.w	#$7,d0
	move.w	d0,$54(a3)
L1B0CE	clr.w	d0
	move.b	$43(a3),d0
	bra.w	Sub_363D6
L1B0D8	clr.w	$17EEA.l
	clr.w	$17EEC.l
	tst.w	$34(a3)
	beq.w	rtss2
	move.w	$0(a3),d2
	eor.w	d0,d2
	bpl.w	L1B17A
	move.w	d1,d2
	sub.w	$14(a3),d2
	move.w	$0(a3),d3
	muls.w	d3,d2
	sub.w	d0,d3
	divs.w	d3,d2
	add.w	$14(a3),d2
	cmpi.w	#$121,d2
	bgt.w	L1B17A
	cmpi.w	#$DB,d2
	blt.w	L1B144
	move.w	#$144,d3
	cmpi.w	#$FE,d2
	bgt.w	L1B138
	blt.w	L1B134
	cmpi.w	#$FE,$14(a3)
	bgt.w	L1B138
L1B134	move.w	#$B8,d3
L1B138	sub.w	d2,d3
	move.w	d3,$17EEC.l
	bra.w	L1B17A
L1B144	cmpi.w	#$FF25,d2
	bgt.w	L1B17A
	cmpi.w	#$FEDF,d2
	blt.w	L1B17A
	move.w	#$FF48,d3
	cmpi.w	#$FF02,d2
	bgt.w	L1B172
	blt.w	L1B16E
	cmpi.w	#$FF02,$14(a3)
	bgt.w	L1B172
L1B16E	move.w	#$FEBC,d3
L1B172	sub.w	d2,d3
	move.w	d3,$17EEC.l
L1B17A	move.w	d1,d3
	subi.w	#$FE,d3
	move.w	$14(a3),d2
	subi.w	#$FE,d2
	bsr.w	L1B1AC
	move.w	d1,d3
	addi.w	#$FE,d3
	move.w	$14(a3),d2
	addi.w	#$FE,d2
	bsr.w	L1B1AC
	add.w	$17EEA.l,d0
	add.w	$17EEC.l,d1
	rts
L1B1AC	move.w	d3,d4
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
	bne.w	L1B1E0
	tst.w	$0(a3)
L1B1E0	bpl.w	L1B1E6
	neg.w	d3
L1B1E6	sub.w	d4,d3
	move.w	d3,$17EEA.l
	rts
skatetopuckinit
	dc.w	$1039,$0001,$7BA8
	asr.b	#$1,d0
	ext.w	d0
	dc.w	$D079,$0001,$7B80
	dc.w	$1239,$0001,$7BAA
	asr.b	#$1,d1
	ext.w	d1
	dc.w	$D279,$0001,$7B94
	rts
skatetopuck
	bsr.w	skatetopuckinit
	sub.b	d7,$42(a3)
	bpl.w	L1B2BC
	addi.b	#$A,$42(a3)
	bsr.w	L1B0D8
	movem.w	d0-d1,-(sp)
	move.l	a3,-(sp)
	bsr.w	Sub_36362
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
	beq.w	L1B2BC
	dc.w	$3039,$0001,$7BA8
	dc.w	$3239,$0001,$7BAA
	bsr.w	vtoa
	eori.w	#$4,d0
	cmp.w	$54(a3),d0
	beq.w	L1B2BC
	dc.w	$3039,$0001,$7B80
	sub.w	$0(a3),d0
	dc.w	$3239,$0001,$7B94
	sub.w	$14(a3),d1
	movem.w	d0-d1,-(sp)
	bsr.w	vtoa
	cmp.w	$54(a3),d0
	movem.w	(sp)+,d0-d1
	bne.w	L1B2BC
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmpi.l	#$384,d0
	bls.w	L1B2BC
	cmpi.l	#$5A4,d0
	bls.w	Sweepcheck
L1B2BC	move.b	$43(a3),d0
	bra.w	Sub_363D6
Sub_362C4
	addi.w	#$1,$36(a3)
	andi.w	#$7,$36(a3)
	bset	#$1,$62(a3)
	rts
Sub_362D8
	subi.w	#$1,$36(a3)
	andi.w	#$7,$36(a3)
Sub_362E4
	move.l	d1,-(sp)
	move.w	$36(a3),d1
	move.b	d0,$38(a3,d1.w)
	bset	#$1,$62(a3)
	move.l	(sp)+,d1
	rts
vtoa
	movem.l	d2/a0,-(sp)
	move.w	d0,d2
	or.w	d1,d2
	beq.w	L1B34A
	clr.w	d2
	tst.w	d0
	bpl.w	L1B312
	neg.w	d0
	bset	#$0,d2
L1B312	tst.w	d1
	bpl.w	L1B31E
	neg.w	d1
	bset	#$1,d2
L1B31E	asl.w	#$1,d1
	cmp.w	d1,d0
	bhi.w	L1B32A
	bset	#$2,d2
L1B32A	lsr.w	#$1,d1
	asl.w	#$1,d0
	cmp.w	d0,d1
	bhi.w	L1B338
	bset	#$3,d2
L1B338	movea.l	#GetHot,a0
	clr.w	d0
	move.b	(a0,d2.w),d0
	movem.l	(sp)+,d2/a0
	rts
L1B34A	moveq	#$8,d0
	movem.l	(sp)+,d2/a0
	rts
GetHot
	btst	d0,d7
	dc.w	$0305
	dc.l	$404
	dc.w	$0206,$0206
	btst	d0,d7
	btst	d1,d5
Sub_36362
	movem.l	a0-a1,-(sp)
	movea.l	$C(sp),a0
	clr.w	d0
	clr.w	d1
	tst.w	$6(a0)
	ble.w	L1B3B8
	movea.l	$47D28.l,a1
	subq.l	#$2,a1
	move.w	$6(a0),d0
	add.w	d0,d0
	move.b	$1(a1,d0.w),d1
	ext.w	d1
	move.b	(a1,d0.w),d0
	ext.w	d0
	btst	#$3,$4(a0)
	beq.w	L1B39C
	neg.w	d0
L1B39C	btst	#$4,$4(a0)
	bne.w	L1B3A8
	neg.w	d1
L1B3A8	btst	#$7,$17F6A.l
	beq.w	L1B3B8
	exg.l	d0,d1
	neg.w	d1
L1B3B8	movem.l	(sp)+,a0-a1
	move.l	(sp)+,(sp)
	rts
Sub_363C0
	cmp.w	$58(a3),d1
	beq.w	rtss2
	clr.w	$5A(a3)
	move.w	d1,$58(a3)
	st.b	$5C(a3)
	rts
Sub_363D6
	tst.w	$34(a3)
	beq.w	L1B5A4
	move.w	#$50C,d1
	btst	#$4,$62(a3)
	beq.w	L1B3F0
	move.w	#$A60,d1
L1B3F0	andi.w	#$F,d0
	cmpi.w	#$7,d0
	ble.w	L1B41C
	cmpi.w	#$9,d0
	bne.w	L1B410
	move.w	$28(a3),d0
	or.w	$2A(a3),d0
	bne.w	Sub_36AE0
L1B410	btst	#$1,$63(a3)
	beq.w	Sub_363C0
	rts
L1B41C	movem.w	d0-d1,-(sp)
	move.w	d0,d2
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	beq.w	L1B4F4
	dc.w	$3039,$0001,$7B80
	sub.w	$0(a3),d0
	move.w	$14(a3),d3
	dc.w	$1239,$0001,$7BAA
	ext.w	d1
	dc.w	$D279,$0001,$7B94
	sub.w	d3,d1
	btst	#$7,$62(a3)
	bne.w	L1B462
	neg.w	d0
	neg.w	d1
	neg.w	d3
	eori.w	#$4,d2
L1B462	btst	#$4,$62(a3)
	bne.w	L1B492
	tst.w	d3
	bpl.w	L1B4F4
	cmpi.w	#$4,d2
	bne.w	L1B4F4
	bsr.w	vtoa
	addi.w	#$1,d0
	andi.w	#$7,d0
	cmpi.w	#$2,d0
	bhi.w	L1B4F4
	bra.w	L1B4B6
L1B492	subi.w	#$3,d2
	andi.w	#$7,d2
	cmpi.w	#$2,d2
	bhi.w	L1B4F4
	bsr.w	vtoa
	addi.w	#$2,d0
	andi.w	#$7,d0
	cmpi.w	#$4,d0
	bhi.w	L1B4F4
L1B4B6	btst	#$4,$62(a3)
	bne.w	L1B4FA
	move.w	$28(a3),d0
	or.w	$2A(a3),d0
	beq.w	L1B4EA
	move.w	$28(a3),d0
	move.w	$2A(a3),d1
	bsr.w	vtoa
	sub.w	(sp),d0
	addi.w	#$1,d0
	andi.w	#$7,d0
	cmpi.w	#$2,d0
	bhi.w	L1B4FA
L1B4EA	bset	#$4,$62(a3)
	bra.w	L1B4FA
L1B4F4	bclr	#$4,$62(a3)
L1B4FA	movem.w	(sp)+,d0-d1
	move.w	$54(a3),d2
	sub.w	d2,d0
	andi.w	#$7,d0
	dc.w	$207C,$0003,$6594
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
	bge.w	L1B53A
	move.w	#$180,d4
L1B53A	muls.w	(a0,d0.w),d4
	btst	#$4,$62(a3)
	beq.w	L1B54A
	neg.l	d4
L1B54A	add.l	d4,$54(a3)
	andi.w	#$7,$54(a3)
	move.w	$54(a3),d2
	cmpi.w	#$14,d3
	bls.w	L1B586
	clr.w	d1
	tst.w	(a0,d0.w)
	bpl.w	L1B56E
	eori.w	#$FFCE,d1
L1B56E	btst	#$3,$4(a3)
	beq.w	L1B57C
	eori.w	#$FFCE,d1
L1B57C	addi.w	#$694,d1
	bset	#$1,$63(a3)
L1B586	bsr.w	Sub_363C0
	cmpi.w	#$2,d3
	bhi.w	L1B86A
	rts
goalieacc
	ori.b	#$10,d0
	dc.w	$0010,$0010
	dc.l	$FFF0
	dc.w	$FFF0
	dc.w	$FFF0
L1B5A4	btst	#$3,$62(a3)
	beq.w	L1B6EC
	movem.w	d0,-(sp)
	move.w	$17BE0.l,d0
	cmp.w	$52(a3),d0
	movem.w	(sp)+,d0
	beq.w	L1B6EC
	cmpi.w	#$30,$0(a3)
	bgt.w	L1B6EC
	cmpi.w	#$FFD0,$0(a3)
	blt.w	L1B6EC
	cmpi.w	#$FF40,$14(a3)
	bgt.w	L1B5F0
	cmpi.w	#$FEFA,$14(a3)
	blt.w	L1B6EC
	bra.w	L1B604
L1B5F0	cmpi.w	#$C0,$14(a3)
	blt.w	L1B6EC
	cmpi.w	#$106,$14(a3)
	bgt.w	L1B6EC
L1B604	movem.w	d0-d1,-(sp)
	dc.w	$3039,$0001,$7B80
	sub.w	$0(a3),d0
	dc.w	$3239,$0001,$7B94
	sub.w	$14(a3),d1
	cmpi.w	#$10,d0
	bgt.w	L1B644
	cmpi.w	#$FFF0,d0
	blt.w	L1B644
	cmpi.w	#$10,d1
	bgt.w	L1B644
	cmpi.w	#$FFF0,d1
	blt.w	L1B644
	move.w	$54(a3),d0
	bra.w	L1B648
L1B644	bsr.w	vtoa
L1B648	btst	#$0,$17F72.l
	bne.w	L1B660
	bsr.w	AdjustFacingDirection
	movem.w	(sp)+,d0-d1
	bra.w	L1B678
L1B660	movem.w	(sp)+,d0-d1
	cmpi.w	#$8,d0
	beq.w	L1B678
	movem.w	d0-d1,-(sp)
	bsr.w	AdjustFacingDirection
	movem.w	(sp)+,d0-d1
L1B678	move.w	#$2,d1
	btst	#$1,$63(a3)
	bne.w	L1B786
	bsr.w	Sub_363C0
	cmpi.w	#$8,d0
	bne.w	L1B6E6
	tst.w	$34(a3)
	bne.w	L1B6E6
	btst	#$3,$62(a3)
	beq.w	L1B6E6
	move.w	d0,-(sp)
	move.w	$14(a3),d0
	btst	#$7,$62(a3)
	beq.w	L1B6B6
	neg.w	d0
L1B6B6	cmpi.w	#$D8,d0
	blt.w	L1B6DE
	move.w	$0(a3),d0
	cmpi.w	#$20,d0
	bgt.w	L1B6DE
	cmpi.w	#$FFE0,d0
	blt.w	L1B6DE
	move.w	(sp)+,d0
	jsr	(stopna2).l
	bra.w	L1B6E6
L1B6DE	jsr	(stopna2).l
	move.w	(sp)+,d0
L1B6E6	move.w	d0,d2
	bra.w	Sub_36878
L1B6EC	move.w	#$2,d1
	btst	#$3,$62(a3)
	beq.w	L1B756
	btst	#$2,$62(a3)
	bne.w	L1B77C
	cmpi.w	#$8,d0
	bne.w	L1B752
	tst.w	$34(a3)
	bne.w	L1B77C
	move.w	d0,-(sp)
	move.w	$14(a3),d0
	btst	#$7,$62(a3)
	beq.w	L1B726
	neg.w	d0
L1B726	cmpi.w	#$D8,d0
	blt.w	L1B74C
	move.w	$0(a3),d0
	cmpi.w	#$20,d0
	bgt.w	L1B74C
	cmpi.w	#$FFE0,d0
	blt.w	L1B74C
	move.w	(sp)+,d0
	bsr.w	stopna
	bra.w	L1B77C
L1B74C	move.w	(sp)+,d0
	bra.w	L1B77C
L1B752	bra.w	L1B788
L1B756	andi.w	#$F,d0
	cmpi.w	#$7,d0
	ble.w	L1B788
	cmpi.w	#$9,d0
	bne.w	L1B77C
	move.w	$28(a3),d0
	or.w	$2A(a3),d0
	beq.w	L1B77C
	jmp	(stopna2).l
L1B77C	btst	#$1,$63(a3)
	beq.w	Sub_363C0
L1B786	rts
L1B788	sub.w	$54(a3),d0
	beq.w	L1B7A8
	neg.w	d0
	andi.w	#$4,d0
	lsr.w	#$1,d0
	subi.w	#$1,d0
	add.w	$54(a3),d0
	andi.w	#$7,d0
	move.w	d0,$54(a3)
L1B7A8	move.w	#$3D8,d1
	bsr.w	Sub_363C0
	move.w	$54(a3),d2
	bra.w	Sub_36878
noturn0
	moveq	#$2,d4
	btst	#$4,$62(a3)
	beq.w	L1B7CC
	addi.w	#$4,d4
	eori.w	#$8,d0
L1B7CC	tst.w	d0
	beq.w	noturn
	move.w	$28(a3),d0
	move.w	$2A(a3),d1
	bsr.w	vtoa
	btst	#$3,d0
	bne.w	L1B7F8
	sub.w	$54(a3),d0
	add.w	d4,d0
	andi.w	#$7,d0
	cmpi.w	#$4,d0
	blt.w	Sub_36AE0
L1B7F8	addi.w	#$1,$54(a3)
	btst	#$3,$4(a3)
	beq.w	L1B80E
	subi.w	#$2,$54(a3)
L1B80E	andi.w	#$7,$54(a3)
	move.w	#$50C,d1
	btst	#$4,$62(a3)
	beq.w	Sub_363C0
	move.w	#$A60,d1
	bra.w	Sub_363C0
noturn
	move.w	#$A92,d1
	btst	#$4,$62(a3)
	bne.w	L1B85C
	move.w	#$5D0,d1
	btst	#$6,$63(a3)
	beq.w	L1B84A
	move.w	#$11E6,d1
L1B84A	move.w	$17BE0.l,d4
	cmp.w	$52(a3),d4
	bne.w	L1B85C
	move.w	#$53E,d1
L1B85C	btst	#$1,$63(a3)
	bne.w	L1B86A
	bsr.w	Sub_363C0
L1B86A	btst	#$4,$62(a3)
	beq.w	Sub_36878
	eori.w	#$4,d2
Sub_36878
	asl.w	#$2,d2
	dc.w	$41FA,$0312
	move.w	$2(a0,d2.w),d1
	move.w	(a0,d2.w),d0
	move.w	$50(a3),d2
	beq.w	L1B896
	eor.w	d0,d2
	bpl.w	L1B896
	clr.w	d0
L1B896	move.w	$4E(a3),d2
	beq.w	L1B8A6
	eor.w	d1,d2
	bmi.w	L1B8A6
	clr.w	d1
L1B8A6	clr.w	d2
	move.b	$67(a3),d2
	lsr.w	#$2,d2
	neg.w	d2
	addi.w	#$40,d2
	add.b	$68(a3),d2
	btst	#$1,$17F7C.l
	bne.w	L1B8D0
	btst	#$6,$17F7A.l
	beq.w	L1B8D8
L1B8D0	addi.b	#$2,d2
	addi.b	#$2,d2
L1B8D8	tst.w	$34(a3)
	bne.w	L1B8E8
	add.b	$68(a3),d2
	addi.w	#$10,d2
L1B8E8	asr.w	#$1,d2
	muls.w	d2,d0
	muls.w	d2,d1
	asr.l	#$5,d0
	asr.l	#$5,d1
	muls.w	d7,d0
	muls.w	d7,d1
	tst.w	$34(a3)
	bne.w	L1B91A
	btst	#$3,$62(a3)
	beq.w	L1B91A
	move.w	$17BE0.l,d2
	cmp.w	$52(a3),d2
	bne.w	L1B91A
	asr.w	#$1,d0
	asr.w	#$1,d1
L1B91A	add.w	$28(a3),d0
	add.w	$2A(a3),d1
	move.w	d0,d2
	move.w	d1,d3
	muls.w	d2,d2
	muls.w	d3,d3
	add.l	d2,d3
	movem.w	d0-d1,-(sp)
	bsr.w	getpde
	btst	#$4,$17F7A.l
	beq.w	L1B944
	move.w	#$1000,d0
L1B944	clr.w	d2
	move.b	$69(a3),d2
	btst	#$1,$17F7C.l
	bne.w	L1B962
	btst	#$6,$17F7A.l
	beq.w	L1B972
L1B962	addi.b	#$2,d2
	cmpi.b	#$1E,d2
	ble.w	L1B972
	move.b	#$1E,d2
L1B972	move.w	d2,$17E66.l
	lsr.w	#$1,d2
	mulu.w	d0,d2
	asl.l	#$4,d2
	swap	d2
	asl.w	#$2,d2
	andi.w	#$3F,d2
	dc.w	$45FA,$0118
	move.w	d2,$17E6C.l
	move.l	(a2,d2.w),d2
	move.l	d2,$17E68.l
	cmpi.w	#$3C,$17E6C.l
	bge.w	L1B9CE
	btst	#$0,$17E67.l
	beq.w	L1B9CE
	move.w	$17E6C.l,d2
	addi.w	#$4,d2
	move.l	(a2,d2.w),d2
	sub.l	$17E68.l,d2
	asr.l	#$1,d2
	add.l	$17E68.l,d2
L1B9CE	btst	#$6,$63(a3)
	beq.w	L1B9DA
	lsr.l	#$3,d2
L1B9DA	tst.w	$34(a3)
	bne.w	L1B9F2
	move.w	$17BE0.l,d0
	cmp.w	$52(a3),d0
	bne.w	L1B9F2
	asr.l	#$1,d2
L1B9F2	movem.w	(sp)+,d0-d1
	cmp.l	d2,d3
	bhi.w	L1BA04
	move.w	d0,$28(a3)
	move.w	d1,$2A(a3)
L1BA04	dc.w	$4A79,$0001,$8C0A
	bne.w	rtss2
L1BA0E	btst	#$7,$FF800E.l
	bne.b	L1BA0E
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
L1BA28	btst	#$6,$FF800E.l
	beq.b	L1BA28
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1BA48	btst	#$6,$FF800E.l
	bne.b	L1BA48
	bclr	#$7,$FF800F.l
	andi.w	#$7F,d0
	bne.w	rtss2
	bsr.w	getpde
	subi.w	#$21,d0
	cmpi.w	#$C00,d0
	blt.w	Sub_3C2C2
	move.b	$72(a3),d2
	ext.w	d2
	lsr.w	#$1,d2
	add.w	d2,d0
	bsr.w	Sub_3C2C2
	btst	#$0,$72(a3)
	beq.w	L1BA9E
	btst	#$0,$17475.l
	beq.w	L1BA9E
	addi.w	#$1,d0
	bra.w	Sub_3C2C2
L1BA9E	rts
MaxSpeed
	dc.w	$01CD,$9410,$01FC,$E3E1,$022E,$8284,$0262,$6FF9
	dc.w	$0298,$AC40,$02D1,$3759,$030C,$1144,$0349,$3A01
	dc.w	$0388,$B190,$03CA,$77F1,$040E,$8D24,$0454,$F129
	dc.w	$049D,$A400,$04E8,$A5A9,$0535,$F624,$0585,$9571
Sub_36AE0
	cmpi.w	#$1000,$28(a3)
	bgt.w	Sub_36B1A
	cmpi.w	#$F000,$28(a3)
	blt.w	Sub_36B1A
	cmpi.w	#$1000,$2A(a3)
	bgt.w	Sub_36B1A
	cmpi.w	#$F000,$2A(a3)
	blt.w	Sub_36B1A
	tst.w	$34(a3)
	bne.w	stopna
	jmp	(stopna2).l
	dc.w	$6000,$002C
Sub_36B1A
	move.w	#$50C,d1
	btst	#$4,$62(a3)
	bne.w	L1BB32
	bset	#$1,$63(a3)
	move.w	#$6C6,d1
L1BB32	bsr.w	Sub_363C0
	tst.w	$34(a3)
	bne.w	stopna
	jmp	(stopna2).l
stopna
	tst.w	$28(a3)
	bpl.w	L1BB5A
	addi.w	#$96,$28(a3)
	bmi.w	L1BB68
	clr.w	$28(a3)
L1BB5A	subi.w	#$96,$28(a3)
	bpl.w	L1BB68
	clr.w	$28(a3)
L1BB68	tst.w	$2A(a3)
	bpl.w	L1BB7E
	addi.w	#$96,$2A(a3)
	bmi.w	rtss2
	clr.w	$2A(a3)
L1BB7E	subi.w	#$96,$2A(a3)
	bpl.w	rtss2
	clr.w	$2A(a3)
	rts
	dc.w	$0000,$00C8,$008D,$008D,$00C8,$0000,$008D,$FF73
	dc.w	$0000,$FF38,$FF73,$FF73,$FF38,$0000,$FF73,$008D
	dc.w	$0000,$0000
UnpackNibbles
	movem.l	d0-d2/a0-a1,-(sp)
	movea.l	#$18BE8,a1
	clr.w	d2
	bra.w	L1BBD8
L1BBC2	move.b	(a0)+,d1
	bchg	#$0,d2
	bne.w	L1BBD2
	suba.w	#$1,a0
	lsr.w	#$4,d1
L1BBD2	andi.w	#$F,d1
	move.w	d1,(a1)+
L1BBD8	dbra	d0,L1BBC2
	movem.l	(sp)+,d0-d2/a0-a1
	rts
WeightedRandomSelect
	movem.l	d1/a1,-(sp)
	movea.l	#$18BE8,a1
	clr.w	d1
	bra.w	L1BBF4
L1BBF2	add.w	(a1)+,d1
L1BBF4	dbra	d0,L1BBF2
	move.w	d1,d0
	bsr.w	randomd0
L1BBFE	sub.w	-(a1),d0
	bpl.w	L1BBFE
	suba.l	#$18BE8,a1
	move.w	a1,d0
	lsr.w	#$1,d0
	movem.l	(sp)+,d1/a1
	rts
Sub_36C14
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	dc.w	$6706
	move.w	#$1,-(a6)
	dc.w	$6004
L1BC2C	move.w	#$0,-(a6)
L1BC30	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movem.l	d0-d4/a0-a2,-(sp)
	exg.l	d0,d1
	movea.l	a0,a2
	bsr.w	Sub_3871E
	subi.w	#$1,d1
L1BC5E	moveq	#$3,d0
	move.w	(a2)+,d2
	clr.w	d3
L1BC64	move.w	d2,d4
	andi.w	#$F,d4
	lsr.w	#$1,d4
	move.b	(a1,d4.w),d4
	btst	#$0,d2
	bne.w	L1BC7A
	lsr.w	#$4,d4
L1BC7A	andi.w	#$F,d4
	or.b	d4,d3
	ror.w	#$4,d3
	ror.w	#$4,d2
	dbra	d0,L1BC64
L1BC88	btst	#$7,$FF800E.l
	bne.b	L1BC88
	move.w	d3,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
L1BCA8	btst	#$6,$FF800E.l
	beq.b	L1BCA8
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1BCC2	btst	#$6,$FF800E.l
	bne.b	L1BCC2
	bclr	#$7,$FF800F.l
	dbra	d1,L1BC5E
	movem.l	(sp)+,d0-d4/a0-a2
	move.w	(sp)+,(disflags).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	dc.w	$670A
	bset	#$5,$FF800F.l
	dc.w	$6008
L1BCF8	bclr	#$5,$FF800F.l
L1BD00	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
Sub_36D0A
	movem.l	d0/a0,-(sp)
	movea.l	#$BBCB0,a0
	moveq	#$1F,d0
L1BD16	move.l	(a0),-(sp)
	clr.l	(a0)+
	dbra	d0,L1BD16
	move.w	#$18,(palcount).l
	bsr.w	Sub_36D66
	moveq	#$1F,d0
L1BD2C	move.l	(sp)+,-(a0)
	dbra	d0,L1BD2C
	movem.l	(sp)+,d0/a0
	rts
Sub_36D38
	movem.l	d0/a0,-(sp)
	movea.l	#$BBCB0,a0
	moveq	#$1F,d0
L1BD44	move.l	(a0),-(sp)
	clr.l	(a0)+
	dbra	d0,L1BD44
	move.w	#$64,(palcount).l
	bsr.w	Sub_36D66
	moveq	#$1F,d0
L1BD5A	move.l	(sp)+,-(a0)
	dbra	d0,L1BD5A
	movem.l	(sp)+,d0/a0
	rts
Sub_36D66
	move.l	(VBint).l,-(sp)
	move.w	(disflags).l,-(sp)
	bclr	#$2,(disflags).l
	move.l	#vb2,(VBint).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	dc.w	$6706
	move.w	#$1,-(a6)
	dc.w	$6004
L1BD9C	move.w	#$0,-(a6)
L1BDA0	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	bset	#$5,$FF800F.l
L1BDB8	tst.w	(palcount).l
	bpl.w	L1BDB8
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	dc.w	$670A
	bset	#$5,$FF800F.l
	dc.w	$6008
L1BDD8	bclr	#$5,$FF800F.l
L1BDE0	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	(sp)+,(disflags).l
	move.l	(sp)+,(VBint).l
	rts
