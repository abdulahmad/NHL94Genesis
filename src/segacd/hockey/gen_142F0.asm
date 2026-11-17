Sub_2F2F0
	tst.w	$18BF8.l
	bne.w	.l14310
.l142FA	btst	#$1,$17F6A.l
	beq.s	*+8
	jmp	(ReadJoy2).l
.l1430A	jmp	(ReadJoy1).l
.l14310	tst.w	$17F94.l
	beq.w	.l142FA
	cmpi.w	#$3,$17F94.l
	bne.s	*+8
	jmp	$3752C.l
.l1432A	jmp	$3754A.l
	move.w	#$F0,$1AD56.l
	jsr	(printz).l
	String	CC_Font3Pri,$2,$2
	moveq	#$20,d0
	moveq	#$55,d1
	moveq	#$8,d2
	moveq	#$4,d3
	move.w	$18D48.l,d4
	move.w	#$0,d5
	movea.l	$47D18.l,a1
	btst	#$4,$17F72.l
	beq.w	.l1436E
	movea.l	$47D64.l,a1
.l1436E	adda.l	$4(a1),a1
	movea.l	#$1B008,a2
	jmp	(dobitmap).l
	dc.w	$4EB9,$0003,$8F6E,$0006,$BD02,$0200,$303C,$0008
	dc.w	$323C,$0004,$343C,$07FF,$4EF9,$0003,$8C06,$50F9
	dc.w	$0001,$AD56,$4EB9,$0003,$8F6E,$0006,$BD02,$0000
	dc.w	$7000,$7200,$7410,$760B,$3839,$0001,$8D56,$3A3C
	dc.w	$0000,$2279,$0004,$7D68,$D3E9,$0004,$247C,$0001
	dc.w	$B008,$4EF9,$0003,$87E2,$4EB9,$0003,$8F6E,$0006
	dc.w	$BD02,$0200,$303C,$0010,$323C,$000B,$343C,$07FF
	jmp	(eraser).l
suba4						;a4 = current replay frame. Back up 1 frame and set video parameters for
	
	
	cmpa.l	#$C45C,a4
	bne.w	.l14410
	btst	#$4,$17F6A.l
	beq.w	.end
	movea.l	#$173B0,a4
.l14410	suba.w	#$62,a4
	cmpa.l	$17470.l,a4
	bne.w	L145BC
	adda.w	#$62,a4
.end	bsr.w	L145BC
	clr.w	d7
	rts
adda4						;Step forward 1 frame. First handles a reverse
	
	bclr	#$6,$17F72.l
	beq.w	.1
	movem.l	d0-d7/a0-a6,-(sp)
	bchg	#$4,$17F72.l
	move.w	$17CEE.l,-(sp)
	move.w	$17CEA.l,-(sp)
	bsr.w	forceblack2
	jsr	(MenuWaitVblank).l
	jsr	(MenuWaitVblank).l
	jsr	$2E986.l
	clr.w	$17CEE.l
	clr.w	$17CEA.l
	move.w	#$7D0,$17CEC.l
	move.w	#$1,d0
.loop	jsr	(setvideo).l
	jsr	(MenuWaitVblank).l
	dbra	d0,.loop
	move.w	(sp)+,$17CEA.l
	move.w	(sp)+,$17CEE.l
	move.w	#$1,d0
	jsr	(setvideo).l
.l144A2	jsr	(MenuWaitVblank).l
	dbra	d0,.l144A2
	movem.l	a0,-(sp)
	movea.l	#$17A80,a0
	move.w	#$1,$8(a0)
	adda.l	#$80,a0
	move.w	#$1,$8(a0)
	movem.l	(sp)+,a0
	bsr.w	L145A8
	btst	#$5,$17F6A.l
	beq.w	.0
.0	jsr	$2F330.l
	move.w	#$64,(palcount).l
	movem.l	(sp)+,d0-d7/a0-a6
.1	clr.w	d7
	btst	#$2,$17F6C.l
	beq.w	adda42
	movem.l	a4,-(sp)
	bsr.w	L14520
	cmpa.l	$17470.l,a4
	movem.l	(sp)+,a4
	beq.w	updatereplayExit
adda42						;adda4 without the sf2drec look-ahead: stop at the record point, else show
	
	cmpa.l	$17470.l,a4
	beq.w	updatereplayExit
	bsr.w	L145BC
L14520	adda.w	#$62,a4
	cmpa.l	#$173B0,a4
	bne.w	updatereplayExit
	movea.l	#$C45C,a4
	rts
L14536	movem.l	d0-d2,-(sp)
	move.w	$0(a3),d0
	btst	#$7,$17F72.l
	beq.w	.l1454C
	neg.w	d0
.l1454C	move.w	d0,$0(a5)
	move.w	$14(a3),d1
	btst	#$7,$17F72.l
	beq.w	.l14562
	neg.w	d1
.l14562	move.w	d1,$14(a5)
	cmpi.w	#$3C,d0
	blt.w	.l14572
	move.w	#$3C,d0
.l14572	cmpi.w	#$FFC4,d0
	bgt.w	.l1457E
	move.w	#$FFC4,d0
.l1457E	move.w	d0,$17CEE.l
	cmpi.w	#$100,d1
	blt.w	.l14590
	move.w	#$100,d1
.l14590	cmpi.w	#$FF38,d1
	bgt.w	.l1459C
	move.w	#$FF38,d1
.l1459C	move.w	d1,$17CEA.l
	movem.l	(sp)+,d0-d2
	rts
L145A8	btst	#$4,$17F72.l
	beq.w	L145BC
	bset	#$7,$17F72.l
L145BC	movem.l	d0-d2/a0/a6,-(sp)
	movea.l	#$4761C,a6
	movea.l	a4,a0
	moveq	#$F,d1
	movea.l	#$17480,a3
.l145D0	move.w	$2(a0),d2
	andi.w	#$3FF,d2
	btst	#$9,d2
	beq.w	.l145E4
	ori.w	#$FC00,d2
.l145E4	btst	#$4,$17F72.l
	beq.w	.l145F2
	neg.w	d2
.l145F2	move.w	d2,$0(a3)
	move.l	(a0),d2
	asr.l	#$4,d2
	asr.w	#$6,d2
	btst	#$9,d2
	beq.w	.l14608
	ori.w	#$FC00,d2
.l14608	btst	#$4,$17F72.l
	beq.w	.l14622
	neg.w	d2
	cmpi.w	#$0,d1
	bne.w	.l14622
	addi.w	#$2,d2
.l14622	move.w	d2,$14(a3)
	move.w	(a0),d2
	asr.w	#$4,d2
	andi.w	#$3FF,d2
	btst	#$4,$17F72.l
	beq.w	.l14674
	asl.w	#$1,d2
	move.w	(a6,d2.w),d2
	cmpi.w	#$F,$52(a3)
	bne.w	.l14658
	cmpi.w	#$18A,d2
	beq.w	.l14658
	move.w	#$FC00,$14(a3)
.l14658	cmpi.w	#$1,d2
	blt.w	.l1466C
	cmpi.w	#$34E,d2
	bge.w	.l1466C
	bra.w	.l14674
.l1466C	move.w	(a0),d2
	asr.w	#$4,d2
	andi.w	#$3FF,d2
.l14674	move.w	d2,$6(a3)
	cmpi.w	#$28D,d2
	blt.w	.l1469A
	cmpi.w	#$292,d2
	bge.w	.l1469A
	btst	#$4,$17F72.l
	beq.w	.l1469A
	move.w	#$190,$14(a3)
.l1469A	move.w	(a0),d2
	asr.w	#$3,d2
	andi.w	#$1800,d2
	andi.w	#$E7FF,$4(a3)
	or.w	d2,$4(a3)
	btst	#$4,$17F72.l
	beq.w	.l146D2
	move.w	$6(a3),d2
	cmpi.w	#$162,d2
	blt.w	.l146D2
	cmpi.w	#$179,d2
	bge.w	.l146D2
	bchg	#$3,$4(a3)
.l146D2	adda.w	#$4,a0
	adda.l	#$80,a3
	dbra	d1,.l145D0
	moveq	#$5,d2
	movea.l	#$17480,a3
.l146E8	move.b	(a0)+,$6F(a3)
	move.b	(a0),d0
	andi.w	#$F,d0
	cmpi.w	#$F,d0
	bne.w	.l146FC
	moveq	#-1,d0
.l146FC	move.w	d0,$34(a3)
	adda.l	#$80,a3
	move.b	(a0)+,d0
	lsr.b	#$4,d0
	move.b	d0,$6F(a3)
	move.b	(a0),d0
	asl.b	#$4,d0
	or.b	d0,$6F(a3)
	move.b	(a0)+,d0
	lsr.b	#$4,d0
	andi.w	#$F,d0
	cmpi.w	#$F,d0
	bne.w	.l14728
	moveq	#-1,d0
.l14728	move.w	d0,$34(a3)
	adda.l	#$80,a3
	dbra	d2,.l146E8
	move.b	(a0)+,d0
	ext.w	d0
	move.w	d0,$17B98.l
	move.b	(a0)+,d0
	ext.w	d0
	move.w	d0,$17C18.l
	move.b	(a0)+,d0
	ext.w	d0
	move.w	d0,(lastsfx).l
	clr.w	d7
	move.b	(a0)+,d7
	move.w	(a0)+,d0
	andi.w	#$FFF,d0
	andi.w	#$F000,$17DC8.l
	or.w	d0,$17DC8.l
	move.w	(a0)+,(Crowdframe).l
	move.w	(a0)+,$17E32.l
	move.b	(a0)+,$18068.l
	clr.w	d0
	move.b	(a0)+,d0
	lsl.w	#$4,d0
	ori.w	#$F00F,d0
	move.w	d0,$17DD6.l
	btst	#$5,$17F6A.l
	beq.w	.l147C2
	movea.l	a5,a3
	btst	#$5,$17F6E.l
	beq.w	.l147BA
	clr.w	$18(a5)
	move.w	$16(a5),d0
	asl.w	#$7,d0
	movea.l	#$17480,a3
	adda.w	d0,a3
.l147BA	bsr.w	L14536
	bra.w	.l147EC
.l147C2	move.w	(a0)+,$17CEE.l
	move.w	(a0)+,$17CEA.l
	btst	#$4,$17F72.l
	beq.w	.l147EC
	neg.w	$17CEE.l
	neg.w	$17CEA.l
	jsr	(ClampReplayView).l
.l147EC	bclr	#$7,$17F72.l
	movem.l	(sp)+,d0-d2/a0/a6
	rts
ClampReplayView						;Clamp Hpos to -$3C..$3C and Vpos to -$C8..$100
	move.w	d0,-(sp)
	move.w	#$3C,d0
	cmp.w	$17CEE.l,d0
	blt.w	.l14818
	move.w	#$FFC4,d0
	cmp.w	$17CEE.l,d0
	ble.w	.l1481E
.l14818	move.w	d0,$17CEE.l
.l1481E	move.w	#$100,d0
	cmp.w	$17CEA.l,d0
	blt.w	.l1483A
	move.w	#$FF38,d0
	cmp.w	$17CEA.l,d0
	ble.w	.l14840
.l1483A	move.w	d0,$17CEA.l
.l14840	move.w	(sp)+,d0
	rts
updatereplay						;called every frame to save replay events, d7 = elapsed frames
	btst	#$4,$17F68.l
	bne.w	updatereplayExit
	btst	#$2,$17F6C.l
	beq.w	.l1487C
	tst.w	$1AD92.l
	beq.w	.l148A6
	subi.w	#$1,$1AD92.l
	bpl.w	.l1487C
	clr.w	$1AD92.l
	bra.w	.l148A6
.l1487C	addi.l	#$62,$17470.l
	cmpi.l	#$173B0,$17470.l
	bne.w	.l148A6
	bset	#$4,$17F6A.l
	move.l	#$C45C,$17470.l
.l148A6	movea.l	$17470.l,a0
	moveq	#$F,d2
	movea.l	#$17480,a3
.top	clr.l	(a0)
	move.w	$0(a3),d1
	andi.w	#$3FF,d1
	move.w	d1,$2(a0)
	clr.l	d1
	move.w	$14(a3),d1
	asl.w	#$6,d1
	asl.l	#$4,d1
	or.l	d1,(a0)
	move.w	$6(a3),d1
	asl.w	#$4,d1
	or.w	d1,(a0)
	move.w	$4(a3),d1
	andi.w	#$1800,d1
	asl.w	#$3,d1
	or.w	d1,(a0)
	adda.w	#$4,a0
	adda.l	#$80,a3
	dbra	d2,.top
	moveq	#$5,d2
	movea.l	#$17480,a3
.loop	move.b	$6F(a3),(a0)+
	move.w	$34(a3),d0
	bpl.w	.n0
	moveq	#$F,d0
.n0	andi.w	#$F,d0
	move.b	d0,(a0)
	adda.l	#$80,a3
	move.b	$6F(a3),d0
	asl.w	#$4,d0
	or.b	d0,(a0)+
	move.b	$6F(a3),d0
	lsr.b	#$4,d0
	move.b	d0,(a0)
	move.w	$34(a3),d0
	bpl.w	.n1
	moveq	#$F,d0
.n1	asl.w	#$4,d0
	or.b	d0,(a0)+
	adda.l	#$80,a3
	dbra	d2,.loop
	move.b	$17B99.l,(a0)+
	move.b	$17C19.l,(a0)+
	move.b	$17F65.l,(a0)+
	bset	#$7,$17F65.l
	move.b	d7,(a0)+
	move.w	$17DC8.l,(a0)+
	move.w	(Crowdframe).l,(a0)+
	move.w	$17E32.l,(a0)+
	move.b	$18068.l,(a0)+
	move.w	d0,-(sp)
	move.w	$17DD6.l,d0
	lsr.w	#$4,d0
	move.b	d0,(a0)+
	move.w	(sp)+,d0
	move.w	$17CEE.l,(a0)+
	move.w	$17CEA.l,(a0)+
updatereplayExit
	rts
updateplayers
	btst	#$7,$17F6A.l
	bne.w	.l149F4
	dc.w	$0079,$000F,$0001,$7DC8
	cmpi.w	#$5,$17B98.l
	bgt.w	.l149B4
.l149AA	clr.w	$1AD74.l
	bra.w	.l149F4
.l149B4	move.w	$1AD78.l,d0
	cmp.w	$17B98.l,d0
	beq.w	.l149D2
	move.w	$17B98.l,$1AD78.l
	bra.w	.l149AA
.l149D2	addi.w	#$1,$1AD74.l
	cmpi.w	#$10,$1AD74.l
	blt.w	.l149F4
	clr.w	$1AD74.l
	subi.w	#$1,$17B98.l
.l149F4	bclr	#$6,$17F7A.l
	move.w	$17F8C.l,d0
	cmp.w	$17F8E.l,d0
	blt.w	.l14A14
	bset	#$6,$17F7A.l
.l14A14	jsr	$2AE68.l
	tst.w	$17BE0.l
	bmi.w	.l14A56
	bclr	#$7,$17F7C.l
	bclr	#$1,(sflags6).l
	move.w	$17BE0.l,d0
	asl.w	#$7,d0
	movea.l	#$17480,a3
	adda.w	d0,a3
	btst	#$1,$64(a3)
	beq.w	.l14A56
	bclr	#$4,$17F78.l
.l14A56	movea.l	#$17480,a3
.l14A5C	move.l	$0(a3),$1C(a3)
	move.l	$14(a3),$20(a3)
	move.l	$18(a3),$24(a3)
	btst	#$5,$64(a3)
	beq.w	.l14B86
	clr.w	$28(a3)
	clr.w	$2A(a3)
	tst.w	$5A(a3)
	bne.w	.l14A92
	jsr	(PlaceBoardFall).l
	bra.w	.l14B86
.l14A92	cmpi.w	#$193E,$58(a3)
	beq.w	.l14B70
	cmpi.w	#$1A00,$58(a3)
	beq.w	.l14B3C
	cmpi.w	#$18CC,$58(a3)
	beq.w	.l14B56
	cmpi.w	#$17E8,$58(a3)
	beq.w	.l14B22
	cmpi.w	#$1776,$58(a3)
	beq.w	.l14AD2
	cmpi.w	#$185A,$58(a3)
	beq.w	.l14AFA
	bra.w	.l14B86
.l14AD2	move.w	#$124,d0
	cmpi.w	#$56,$1937E.l
	bgt.w	.l14AEE
	cmpi.w	#$FFAA,$1937E.l
	bgt.w	.l14AF2
.l14AEE	move.w	#$116,d0
.l14AF2	move.w	d0,$14(a3)
	bra.w	.l14B86
.l14AFA	move.w	#$FEDC,d0
	cmpi.w	#$56,$1937E.l
	bgt.w	.l14B16
	cmpi.w	#$FFAA,$1937E.l
	bgt.w	.l14B1A
.l14B16	move.w	#$FEEA,d0
.l14B1A	move.w	d0,$14(a3)
	bra.w	.l14B86
.l14B22	move.w	#$82,$0(a3)
	btst	#$3,$4(a3)
	beq.w	.l14B86
	move.w	#$FF7E,$0(a3)
	bra.w	.l14B86
.l14B3C	move.w	#$88,$0(a3)
	btst	#$3,$4(a3)
	beq.w	.l14B86
	move.w	#$FF78,$0(a3)
	bra.w	.l14B86
.l14B56	move.w	#$FF7E,$0(a3)
	btst	#$3,$4(a3)
	beq.w	.l14B86
	move.w	#$82,$0(a3)
	bra.w	.l14B86
.l14B70	move.w	#$FF78,$0(a3)
	btst	#$3,$4(a3)
	beq.w	.l14B86
	move.w	#$88,$0(a3)
.l14B86	tst.w	$34(a3)
	bmi.w	.l14FA0
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	beq.w	.l14BA8
	bclr	#$1,$64(a3)
	bclr	#$0,$64(a3)
.l14BA8	bsr.w	updateanim
	sub.b	d7,$5E(a3)
	bpl.w	.l14BB8
	clr.b	$5E(a3)
.l14BB8	sub.b	d7,$5F(a3)
	bpl.w	.l14BC4
	clr.b	$5F(a3)
.l14BC4	btst	#$6,$17F6E.l
	beq.w	.l14BEC
	clr.w	d0
	move.b	$66(a3),d0
	bmi.w	.l14BEC
	add.w	d0,d0
	addi.w	#$138,d0
	jsr	$3C958.l
	addi.w	#$1,(a2,d0.w)
.l14BEC	cmpi.w	#$145C,$58(a3)
	beq.w	.l14CCC
	cmpi.w	#$1AF4,$58(a3)
	beq.w	.l14CCC
	moveq	#$11,d4
	tst.w	$18C20.l
	beq.w	.l14C0E
	moveq	#$16,d4
.l14C0E	mulu.w	d7,d4
	tst.w	$18(a3)
	bne.w	.l14C56
	moveq	#$6,d2
	btst	#$0,$62(a3)
	beq.w	.l14C26
	moveq	#$9,d2
.l14C26	move.w	$28(a3),d0
	beq.w	.l14C3E
	asr.w	d2,d0
	bne.w	.l14C3A
	move.l	#$1,d0
.l14C3A	sub.w	d0,$28(a3)
.l14C3E	move.w	$2A(a3),d0
	beq.w	.l14C56
	asr.w	d2,d0
	bne.w	.l14C52
	move.l	#$1,d0
.l14C52	sub.w	d0,$2A(a3)
.l14C56	move.w	$28(a3),d0
	beq.w	.l14C64
	muls.w	d4,d0
	add.l	d0,$0(a3)
.l14C64	move.w	$2A(a3),d0
	beq.w	.l14C72
	muls.w	d4,d0
	add.l	d0,$14(a3)
.l14C72	tst.w	$18(a3)
	bmi.w	.l14CCC
	bne.w	.l14C86
	tst.w	$2C(a3)
	beq.w	.l14CCC
.l14C86	asl.w	#$1,d4
	sub.w	d4,$2C(a3)
	asl.w	#$1,d4
	sub.w	d4,$2C(a3)
	lsr.w	#$2,d4
	move.w	$2C(a3),d0
	muls.w	d4,d0
	add.l	d0,$18(a3)
	bpl.w	.l14CCC
	clr.l	$18(a3)
	neg.w	$2C(a3)
	asr.w	$2C(a3)
	moveq	#$5,d0
	sub.b	$2C(a3),d0
	bpl.w	.l14CBA
	clr.w	d0
.l14CBA	cmpi.w	#$3,d0
	bhi.w	.l14CCC
	addi.w	#$2C,d0
	move.w	d0,-(sp)
	bsr.w	sfx
.l14CCC	move.w	$52(a3),d6
	cmp.w	$17BE0.l,d6
	bne.w	.l14CF6
	btst	#$0,$63(a3)
	bne.w	.l14CF6
	btst	#$7,$17F6A.l
	bne.w	.l14CF6
	moveq	#-2,d4
	bsr.w	setpads
.l14CF6	btst	#$0,$17F6C.l
	bne.w	.l14D32
	tst.w	$19374.l
	beq.w	.l14D32
	subi.w	#$1,$19374.l
	beq.w	.l14D1C
	bpl.w	.l14D32
.l14D1C	clr.w	$19374.l
	move.w	#$1111,$17E56.l
	move.w	#$1111,$17E58.l
.l14D32	cmp.w	$17F9E.l,d6
	bne.w	.l14D52
	bsr.w	ReadJoy1
	clr.w	d4
	move.w	#$FFFF,$17F96.l
	bsr.w	doinput
	bra.w	.l14D72
.l14D52	cmp.w	$17FA0.l,d6
	bne.w	.l14D72
	bsr.w	ReadJoy2
	move.l	#$2,d4
	move.w	#$FFFF,$17F96.l
	bsr.w	doinput
.l14D72	cmpi.w	#$B,d6
	bgt.w	.l14F4C
	tst.w	$17FAA.l
	beq.w	.l14E60
	cmp.w	$17FA2.l,d6
	bne.w	.l14E60
	jsr	$3752C.l
	clr.l	d4
	clr.w	$17F96.l
	move.w	$17FA6.l,-(sp)
	move.w	$17FAA.l,$17FA6.l
	move.w	$17F9E.l,-(sp)
	move.w	$17FA2.l,$17F9E.l
	move.w	$17E56.l,-(sp)
	move.w	$17E58.l,$17E56.l
	move.w	$17E5E.l,-(sp)
	move.w	$17E5A.l,$17E5E.l
	move.w	$19380.l,-(sp)
	move.w	$19382.l,$19380.l
	move.w	$17DC8.l,-(sp)
	move.w	$17DD6.l,$17DC8.l
	bsr.w	doinput
	move.w	$17DC8.l,$17DD6.l
	move.w	(sp)+,$17DC8.l
	move.w	$19380.l,$19382.l
	move.w	(sp)+,$19380.l
	move.w	$17E5E.l,$17E5A.l
	move.w	(sp)+,$17E5E.l
	move.w	$17E56.l,$17E58.l
	move.w	(sp)+,$17E56.l
	move.w	$17F9E.l,$17FA2.l
	move.w	(sp)+,$17F9E.l
	move.w	$17FA6.l,$17FAA.l
	move.w	(sp)+,$17FA6.l
.l14E60	tst.w	$17FAC.l
	beq.w	.l14F4C
	cmp.w	$17FA4.l,d6
	bne.w	.l14F4C
	jsr	$3754A.l
	move.l	#$2,d4
	move.w	#$1,$17F96.l
	move.w	$17FA8.l,-(sp)
	move.w	$17FAC.l,$17FA8.l
	move.w	$17FA0.l,-(sp)
	move.w	$17FA4.l,$17FA0.l
	move.w	$17E56.l,-(sp)
	move.w	$17E58.l,$17E56.l
	move.w	$17E60.l,-(sp)
	move.w	$17E5C.l,$17E60.l
	move.w	$19380.l,-(sp)
	move.w	$19382.l,$19380.l
	move.w	$17DC8.l,-(sp)
	move.w	$17DD6.l,$17DC8.l
	bsr.w	doinput
	move.w	$17DC8.l,$17DD6.l
	move.w	(sp)+,$17DC8.l
	move.w	$19380.l,$19382.l
	move.w	(sp)+,$19380.l
	move.w	$17E60.l,$17E5C.l
	move.w	(sp)+,$17E60.l
	move.w	$17E56.l,$17E58.l
	move.w	(sp)+,$17E56.l
	move.w	$17FA0.l,$17FA4.l
	move.w	(sp)+,$17FA0.l
	move.w	$17FA8.l,$17FAC.l
	move.w	(sp)+,$17FA8.l
.l14F4C	move.w	$36(a3),d0
	clr.w	d1
	move.b	$38(a3,d0.w),d1
	asl.w	#$2,d1
	movea.l	#$415CC,a0
	movea.l	(a0,d1.w),a0
	jsr	$3C958.l
	jsr	(a0)
	clr.w	$4E(a3)
	clr.w	$50(a3)
	move.w	$0(a3),d2
	move.w	$14(a3),d3
	cmp.w	$1C(a3),d2
	bne.w	.l14F8A
	cmp.w	$20(a3),d3
	beq.w	.l14F90
.l14F8A	jsr	(checkcoll).l
.l14F90	move.w	d7,d0
	asl.w	#$1,d0
	sub.w	d0,$32(a3)
	bpl.w	.l14FA0
	clr.w	$32(a3)
.l14FA0	move.w	$32(a3),$30(a3)
	adda.l	#$80,a3
	cmpi.w	#$F,-$2E(a3)
	blt.w	.l14A5C
	rts
updateanim						;frame switch control on struct a3
	tst.w	$58(a3)
	bne.w	.l14FCE		;branch if not 0
	bclr	#$5,$62(a3)
	bclr	#$1,$63(a3)		;clear anim in progress
	rts
.l14FCE	movea.l	#SPAlist,a0		;animation data tables
	adda.w	$58(a3),a0		;add SPA to a0 address
	move.w	$10(a0),d1		;16 dec - attributes for anim
	move.w	$54(a3),d0
	btst	#$7,$17F6A.l		;check if horizontal mode
	beq.w	.l14FFE
	cmpi.w	#$C,$52(a3)		;compare to 12 (check if a player, not the puck or nets)
	bge.w	.l14FFE		;branch if greater than (puck or nets)
	subi.w	#$2,d0		;direction adjust for horizontal rink
	andi.w	#$7,d0
.l14FFE	btst	#$3,$4(a3)		;x flip flag
	beq.w	.l15012		;branch if no flip
	neg.w	d0
	addi.w	#$8,d0		;add 8 to d0 for flipping
	andi.w	#$7,d0		;pass first 3 bits
.l15012	asl.w	#$1,d0
	adda.w	(a0,d0.w),a0		;add a0 + d0 offset to a0 - This moves the SPF value into a0
	move.w	$5A(a3),d0		;SPANum into d0 (index into animation)
	move.w	(a0,d0.w),d2		;a0 + d0 offset into d2 - this is the new SPF frame of this animation
	tst.w	$5C(a3)		;check if SPAcnt is 0 (time for a new frame)
	bmi.w	.l15066		;branch if so (SPAcnt is negative)
	sub.w	d7,$5C(a3)		;sub frames elasped from SPAcnt
	bpl.w	.l15074		;branch if SPAcnt is positive
	addi.w	#$4,$5A(a3)		;add 4 to SPAnum (set for next index)
	addi.w	#$4,d0		;add 4 to d0 (currently holds current index)
	tst.w	-$2(a0,d0.w)		;test -2 offset from a0 + d0 (this is the frame
	bpl.w	.l15066		;branch if positive (not the end of the animation)
	clr.w	d0
	clr.w	$5A(a3)
	bclr	#$5,$62(a3)
	bclr	#$1,$63(a3)		;clear animation in progress
	bclr	#$5,$64(a3)		;clear fall down flag
	btst	#$0,d1		;check if anim attribute loops
	bne.w	.l15066
	clr.w	$58(a3)
.l15066	move.w	$2(a0,d0.w),d0		;move frame time for animation frame into d0
	bpl.w	.l15070
	neg.w	d0		;make d0 negative (this is the case if final frame)
.l15070	move.w	d0,$5C(a3)		;move d0 into SPAcnt
.l15074	sub.b	d7,$65(a3)		;sub frames elapsed from glitch - limit minimum
	bpl.w	.l15092		;branch if glitch is positive still
	clr.b	$65(a3)
	cmp.w	$6(a3),d2		;compare frame to d2
	beq.w	.l15092
	move.w	d2,$6(a3)		;move d2 into frame
	move.b	#$4,$65(a3)		;move 4 into glitch - /60 sec min frame switch time
.l15092	rts
freezewindow						;lock scrolling to the current position
	move.w	$17CEA.l,$17EDE.l
	move.w	$17CEE.l,$17EDC.l
	bset	#$6,$17F6A.l
	rts
checkwindow
	move.w	$17EDE.l,d2
	move.w	$17EDC.l,d3
	btst	#$6,$17F6A.l
	bne.w	.l1514A
	movea.l	#$17B80,a3
	move.w	$17BE0.l,d0
	bmi.w	.l1512A
	asl.w	#$7,d0
	movea.l	#$17480,a3
	adda.w	d0,a3
	move.w	d7,d0
	add.w	d0,d0
	btst	#$7,$62(a3)
	beq.w	.l15110
	add.w	d0,$17EE0.l
	cmpi.w	#$32,$17EE0.l
	blt.w	.l1512A
	move.w	#$32,$17EE0.l
	bra.w	.l1512A
.l15110	sub.w	d0,$17EE0.l
	cmpi.w	#$FFCE,$17EE0.l
	bgt.w	.l1512A
	move.w	#$FFCE,$17EE0.l
.l1512A	move.w	$2A(a3),d2
	asr.w	#$7,d2
	add.w	$14(a3),d2
	add.w	$17EE0.l,d2
	move.w	$0(a3),d3
	move.w	d2,$17EDE.l
	move.w	d3,$17EDC.l
.l1514A	move.w	d2,d0
	sub.w	$17CEA.l,d0
	cmpi.w	#$FFF6,d0
	bge.w	.l15170
	move.w	d2,d1
	subi.w	#$FFF6,d1
	cmpi.w	#$FF38,d1
	bgt.w	.l1518A
	move.w	#$FF38,d1
	bra.w	.l1518A
.l15170	cmpi.w	#$A,d0
	ble.w	.l151A4
	move.w	d2,d1
	subi.w	#$A,d1
	cmpi.w	#$100,d1
	blt.w	.l1518A
	move.w	#$100,d1
.l1518A	sub.w	$17CEA.l,d1
	beq.w	.l151A4
	asr.w	#$4,d1
	bne.w	.l1519E
	addi.w	#$1,d1
.l1519E	add.w	d1,$17CEA.l
.l151A4	move.w	d3,d0
	sub.w	$17CEE.l,d0
	cmpi.w	#$FFD8,d0
	bge.w	.l151CA
	move.w	d3,d1
	subi.w	#$FFD8,d1
	cmpi.w	#$FFC4,d1
	bge.w	.l151E4
	move.w	#$FFC4,d1
	bra.w	.l151E4
.l151CA	cmpi.w	#$28,d0
	ble.w	.l151FE
	move.w	d3,d1
	subi.w	#$28,d1
	cmpi.w	#$3C,d1
	ble.w	.l151E4
	move.w	#$3C,d1
.l151E4	sub.w	$17CEE.l,d1
	beq.w	.l151FE
	asr.w	#$4,d1
	bne.w	.l151F8
	addi.w	#$1,d1
.l151F8	add.w	d1,$17CEE.l
.l151FE	rts
