; Reads joypad 2 or 1 depending on the port flag.
ReadActiveJoypad
	tst.w	$18BF8.l
	bne.w	.next2
.loop	btst	#$1,$17F6A.l
	beq.s	.next
	jmp	(ReadJoy2).l
.next	jmp	(ReadJoy1).l
.next2	tst.w	$17F94.l
	beq.w	.loop
	cmpi.w	#$3,$17F94.l
	bne.s	.next3
	jmp	$3752C.l
.next3	jmp	$3754A.l
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
	beq.w	.next4
	movea.l	$47D64.l,a1
.next4	adda.l	$4(a1),a1
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
	bne.w	.next
	btst	#$4,$17F6A.l
	beq.w	.end
	movea.l	#$173B0,a4
.next	suba.w	#$62,a4
	cmpa.l	$17470.l,a4
	bne.w	RestoreReplayFrameCopy
	adda.w	#$62,a4
.end	bsr.w	RestoreReplayFrameCopy
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
.loop2	jsr	(MenuWaitVblank).l
	dbra	d0,.loop2
	movem.l	a0,-(sp)
	movea.l	#$17A80,a0
	move.w	#$1,$8(a0)
	adda.l	#$80,a0
	move.w	#$1,$8(a0)
	movem.l	(sp)+,a0
	bsr.w	RestoreReplayFrame
	btst	#$5,$17F6A.l
	beq.w	.0
.0	jsr	$2F330.l
	move.w	#$64,(palcount).l
	movem.l	(sp)+,d0-d7/a0-a6
.1	clr.w	d7
	btst	#$2,$17F6C.l
	beq.w	adda42
	movem.l	a4,-(sp)
	bsr.w	NextReplayEntry
	cmpa.l	$17470.l,a4
	movem.l	(sp)+,a4
	beq.w	updatereplayExit
adda42						;adda4 without the sf2drec look-ahead: stop at the record point, else show
	
	cmpa.l	$17470.l,a4
	beq.w	updatereplayExit
	bsr.w	RestoreReplayFrameCopy
; Advances the replay pointer by $62 and wraps at the end of the buffer.
NextReplayEntry	adda.w	#$62,a4
	cmpa.l	#$173B0,a4
	bne.w	updatereplayExit
	movea.l	#$C45C,a4
	rts
UpdateCameraPos	movem.l	d0-d2,-(sp)
	move.w	$0(a3),d0
	btst	#$7,$17F72.l
	beq.w	.next
	neg.w	d0
.next	move.w	d0,$0(a5)
	move.w	$14(a3),d1
	btst	#$7,$17F72.l
	beq.w	.next2
	neg.w	d1
.next2	move.w	d1,$14(a5)
	cmpi.w	#$3C,d0
	blt.w	.next3
	move.w	#$3C,d0
.next3	cmpi.w	#$FFC4,d0
	bgt.w	.next4
	move.w	#$FFC4,d0
.next4	move.w	d0,$17CEE.l
	cmpi.w	#$100,d1
	blt.w	.next5
	move.w	#$100,d1
.next5	cmpi.w	#$FF38,d1
	bgt.w	.next6
	move.w	#$FF38,d1
.next6	move.w	d1,$17CEA.l
	movem.l	(sp)+,d0-d2
	rts
RestoreReplayFrame	btst	#$4,$17F72.l
	beq.w	RestoreReplayFrameCopy
	bset	#$7,$17F72.l
; Copies the saved replay sprite state back.
RestoreReplayFrameCopy	movem.l	d0-d2/a0/a6,-(sp)
	movea.l	#$4761C,a6
	movea.l	a4,a0
	moveq	#$F,d1
	movea.l	#$17480,a3
.loop	move.w	$2(a0),d2
	andi.w	#$3FF,d2
	btst	#$9,d2
	beq.w	.next
	ori.w	#$FC00,d2
.next	btst	#$4,$17F72.l
	beq.w	.next2
	neg.w	d2
.next2	move.w	d2,$0(a3)
	move.l	(a0),d2
	asr.l	#$4,d2
	asr.w	#$6,d2
	btst	#$9,d2
	beq.w	.next3
	ori.w	#$FC00,d2
.next3	btst	#$4,$17F72.l
	beq.w	.next4
	neg.w	d2
	cmpi.w	#$0,d1
	bne.w	.next4
	addi.w	#$2,d2
.next4	move.w	d2,$14(a3)
	move.w	(a0),d2
	asr.w	#$4,d2
	andi.w	#$3FF,d2
	btst	#$4,$17F72.l
	beq.w	.next7
	asl.w	#$1,d2
	move.w	(a6,d2.w),d2
	cmpi.w	#$F,$52(a3)
	bne.w	.next5
	cmpi.w	#$18A,d2
	beq.w	.next5
	move.w	#$FC00,$14(a3)
.next5	cmpi.w	#$1,d2
	blt.w	.next6
	cmpi.w	#$34E,d2
	bge.w	.next6
	bra.w	.next7
.next6	move.w	(a0),d2
	asr.w	#$4,d2
	andi.w	#$3FF,d2
.next7	move.w	d2,$6(a3)
	cmpi.w	#$28D,d2
	blt.w	.next8
	cmpi.w	#$292,d2
	bge.w	.next8
	btst	#$4,$17F72.l
	beq.w	.next8
	move.w	#$190,$14(a3)
.next8	move.w	(a0),d2
	asr.w	#$3,d2
	andi.w	#$1800,d2
	andi.w	#$E7FF,$4(a3)
	or.w	d2,$4(a3)
	btst	#$4,$17F72.l
	beq.w	.next9
	move.w	$6(a3),d2
	cmpi.w	#$162,d2
	blt.w	.next9
	cmpi.w	#$179,d2
	bge.w	.next9
	bchg	#$3,$4(a3)
.next9	adda.w	#$4,a0
	adda.l	#$80,a3
	dbra	d1,.loop
	moveq	#$5,d2
	movea.l	#$17480,a3
.loop2	move.b	(a0)+,$6F(a3)
	move.b	(a0),d0
	andi.w	#$F,d0
	cmpi.w	#$F,d0
	bne.w	.next10
	moveq	#-1,d0
.next10	move.w	d0,$34(a3)
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
	bne.w	.next11
	moveq	#-1,d0
.next11	move.w	d0,$34(a3)
	adda.l	#$80,a3
	dbra	d2,.loop2
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
	beq.w	.next13
	movea.l	a5,a3
	btst	#$5,$17F6E.l
	beq.w	.next12
	clr.w	$18(a5)
	move.w	$16(a5),d0
	asl.w	#$7,d0
	movea.l	#$17480,a3
	adda.w	d0,a3
.next12	bsr.w	UpdateCameraPos
	bra.w	.next14
.next13	move.w	(a0)+,$17CEE.l
	move.w	(a0)+,$17CEA.l
	btst	#$4,$17F72.l
	beq.w	.next14
	neg.w	$17CEE.l
	neg.w	$17CEA.l
	jsr	(ClampReplayView).l
.next14	bclr	#$7,$17F72.l
	movem.l	(sp)+,d0-d2/a0/a6
	rts
ClampReplayView						;Clamp Hpos to -$3C..$3C and Vpos to -$C8..$100
	move.w	d0,-(sp)
	move.w	#$3C,d0
	cmp.w	$17CEE.l,d0
	blt.w	.next
	move.w	#$FFC4,d0
	cmp.w	$17CEE.l,d0
	ble.w	.next2
.next	move.w	d0,$17CEE.l
.next2	move.w	#$100,d0
	cmp.w	$17CEA.l,d0
	blt.w	.next3
	move.w	#$FF38,d0
	cmp.w	$17CEA.l,d0
	ble.w	.next4
.next3	move.w	d0,$17CEA.l
.next4	move.w	(sp)+,d0
	rts
updatereplay						;called every frame to save replay events, d7 = elapsed frames
	btst	#$4,$17F68.l
	bne.w	updatereplayExit
	btst	#$2,$17F6C.l
	beq.w	.next
	tst.w	$1AD92.l
	beq.w	.next2
	subi.w	#$1,$1AD92.l
	bpl.w	.next
	clr.w	$1AD92.l
	bra.w	.next2
.next	addi.l	#$62,$17470.l
	cmpi.l	#$173B0,$17470.l
	bne.w	.next2
	bset	#$4,$17F6A.l
	move.l	#$C45C,$17470.l
.next2	movea.l	$17470.l,a0
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
	bne.w	.next3
	dc.w	$0079,$000F,$0001,$7DC8
	cmpi.w	#$5,$17B98.l
	bgt.w	.next
.loop	clr.w	$1AD74.l
	bra.w	.next3
.next	move.w	$1AD78.l,d0
	cmp.w	$17B98.l,d0
	beq.w	.next2
	move.w	$17B98.l,$1AD78.l
	bra.w	.loop
.next2	addi.w	#$1,$1AD74.l
	cmpi.w	#$10,$1AD74.l
	blt.w	.next3
	clr.w	$1AD74.l
	subi.w	#$1,$17B98.l
.next3	bclr	#$6,$17F7A.l
	move.w	$17F8C.l,d0
	cmp.w	$17F8E.l,d0
	blt.w	.next4
	bset	#$6,$17F7A.l
.next4	jsr	$2AE68.l
	tst.w	$17BE0.l
	bmi.w	.next5
	bclr	#$7,$17F7C.l
	bclr	#$1,(sflags6).l
	move.w	$17BE0.l,d0
	asl.w	#$7,d0
	movea.l	#$17480,a3
	adda.w	d0,a3
	btst	#$1,$64(a3)
	beq.w	.next5
	bclr	#$4,$17F78.l
.next5	movea.l	#$17480,a3
.loop2	move.l	$0(a3),$1C(a3)
	move.l	$14(a3),$20(a3)
	move.l	$18(a3),$24(a3)
	btst	#$5,$64(a3)
	beq.w	.next17
	clr.w	$28(a3)
	clr.w	$2A(a3)
	tst.w	$5A(a3)
	bne.w	.next6
	jsr	(PlaceBoardFall).l
	bra.w	.next17
.next6	cmpi.w	#$193E,$58(a3)
	beq.w	.next16
	cmpi.w	#$1A00,$58(a3)
	beq.w	.next14
	cmpi.w	#$18CC,$58(a3)
	beq.w	.next15
	cmpi.w	#$17E8,$58(a3)
	beq.w	.next13
	cmpi.w	#$1776,$58(a3)
	beq.w	.next7
	cmpi.w	#$185A,$58(a3)
	beq.w	.next10
	bra.w	.next17
.next7	move.w	#$124,d0
	cmpi.w	#$56,$1937E.l
	bgt.w	.next8
	cmpi.w	#$FFAA,$1937E.l
	bgt.w	.next9
.next8	move.w	#$116,d0
.next9	move.w	d0,$14(a3)
	bra.w	.next17
.next10	move.w	#$FEDC,d0
	cmpi.w	#$56,$1937E.l
	bgt.w	.next11
	cmpi.w	#$FFAA,$1937E.l
	bgt.w	.next12
.next11	move.w	#$FEEA,d0
.next12	move.w	d0,$14(a3)
	bra.w	.next17
.next13	move.w	#$82,$0(a3)
	btst	#$3,$4(a3)
	beq.w	.next17
	move.w	#$FF7E,$0(a3)
	bra.w	.next17
.next14	move.w	#$88,$0(a3)
	btst	#$3,$4(a3)
	beq.w	.next17
	move.w	#$FF78,$0(a3)
	bra.w	.next17
.next15	move.w	#$FF7E,$0(a3)
	btst	#$3,$4(a3)
	beq.w	.next17
	move.w	#$82,$0(a3)
	bra.w	.next17
.next16	move.w	#$FF78,$0(a3)
	btst	#$3,$4(a3)
	beq.w	.next17
	move.w	#$88,$0(a3)
.next17	tst.w	$34(a3)
	bmi.w	.next42
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	beq.w	.next18
	bclr	#$1,$64(a3)
	bclr	#$0,$64(a3)
.next18	bsr.w	updateanim
	sub.b	d7,$5E(a3)
	bpl.w	.next19
	clr.b	$5E(a3)
.next19	sub.b	d7,$5F(a3)
	bpl.w	.next20
	clr.b	$5F(a3)
.next20	btst	#$6,$17F6E.l
	beq.w	.next21
	clr.w	d0
	move.b	$66(a3),d0
	bmi.w	.next21
	add.w	d0,d0
	addi.w	#$138,d0
	jsr	$3C958.l
	addi.w	#$1,(a2,d0.w)
.next21	cmpi.w	#$145C,$58(a3)
	beq.w	.next32
	cmpi.w	#$1AF4,$58(a3)
	beq.w	.next32
	moveq	#$11,d4
	tst.w	$18C20.l
	beq.w	.next22
	moveq	#$16,d4
.next22	mulu.w	d7,d4
	tst.w	$18(a3)
	bne.w	.next27
	moveq	#$6,d2
	btst	#$0,$62(a3)
	beq.w	.next23
	moveq	#$9,d2
.next23	move.w	$28(a3),d0
	beq.w	.next25
	asr.w	d2,d0
	bne.w	.next24
	move.l	#$1,d0
.next24	sub.w	d0,$28(a3)
.next25	move.w	$2A(a3),d0
	beq.w	.next27
	asr.w	d2,d0
	bne.w	.next26
	move.l	#$1,d0
.next26	sub.w	d0,$2A(a3)
.next27	move.w	$28(a3),d0
	beq.w	.next28
	muls.w	d4,d0
	add.l	d0,$0(a3)
.next28	move.w	$2A(a3),d0
	beq.w	.next29
	muls.w	d4,d0
	add.l	d0,$14(a3)
.next29	tst.w	$18(a3)
	bmi.w	.next32
	bne.w	.next30
	tst.w	$2C(a3)
	beq.w	.next32
.next30	asl.w	#$1,d4
	sub.w	d4,$2C(a3)
	asl.w	#$1,d4
	sub.w	d4,$2C(a3)
	lsr.w	#$2,d4
	move.w	$2C(a3),d0
	muls.w	d4,d0
	add.l	d0,$18(a3)
	bpl.w	.next32
	clr.l	$18(a3)
	neg.w	$2C(a3)
	asr.w	$2C(a3)
	moveq	#$5,d0
	sub.b	$2C(a3),d0
	bpl.w	.next31
	clr.w	d0
.next31	cmpi.w	#$3,d0
	bhi.w	.next32
	addi.w	#$2C,d0
	move.w	d0,-(sp)
	bsr.w	sfx
.next32	move.w	$52(a3),d6
	cmp.w	$17BE0.l,d6
	bne.w	.next33
	btst	#$0,$63(a3)
	bne.w	.next33
	btst	#$7,$17F6A.l
	bne.w	.next33
	moveq	#-2,d4
	bsr.w	setpads
.next33	btst	#$0,$17F6C.l
	bne.w	.next35
	tst.w	$19374.l
	beq.w	.next35
	subi.w	#$1,$19374.l
	beq.w	.next34
	bpl.w	.next35
.next34	clr.w	$19374.l
	move.w	#$1111,$17E56.l
	move.w	#$1111,$17E58.l
.next35	cmp.w	$17F9E.l,d6
	bne.w	.next36
	bsr.w	ReadJoy1
	clr.w	d4
	move.w	#$FFFF,$17F96.l
	bsr.w	doinput
	bra.w	.next37
.next36	cmp.w	$17FA0.l,d6
	bne.w	.next37
	bsr.w	ReadJoy2
	move.l	#$2,d4
	move.w	#$FFFF,$17F96.l
	bsr.w	doinput
.next37	cmpi.w	#$B,d6
	bgt.w	.next39
	tst.w	$17FAA.l
	beq.w	.next38
	cmp.w	$17FA2.l,d6
	bne.w	.next38
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
.next38	tst.w	$17FAC.l
	beq.w	.next39
	cmp.w	$17FA4.l,d6
	bne.w	.next39
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
.next39	move.w	$36(a3),d0
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
	bne.w	.next40
	cmp.w	$20(a3),d3
	beq.w	.next41
.next40	jsr	(checkcoll).l
.next41	move.w	d7,d0
	asl.w	#$1,d0
	sub.w	d0,$32(a3)
	bpl.w	.next42
	clr.w	$32(a3)
.next42	move.w	$32(a3),$30(a3)
	adda.l	#$80,a3
	cmpi.w	#$F,-$2E(a3)
	blt.w	.loop2
	rts
updateanim						;frame switch control on struct a3
	tst.w	$58(a3)
	bne.w	.next		;branch if not 0
	bclr	#$5,$62(a3)
	bclr	#$1,$63(a3)		;clear anim in progress
	rts
.next	movea.l	#SPAlist,a0		;animation data tables
	adda.w	$58(a3),a0		;add SPA to a0 address
	move.w	$10(a0),d1		;16 dec - attributes for anim
	move.w	$54(a3),d0
	btst	#$7,$17F6A.l		;check if horizontal mode
	beq.w	.next2
	cmpi.w	#$C,$52(a3)		;compare to 12 (check if a player, not the puck or nets)
	bge.w	.next2		;branch if greater than (puck or nets)
	subi.w	#$2,d0		;direction adjust for horizontal rink
	andi.w	#$7,d0
.next2	btst	#$3,$4(a3)		;x flip flag
	beq.w	.next3		;branch if no flip
	neg.w	d0
	addi.w	#$8,d0		;add 8 to d0 for flipping
	andi.w	#$7,d0		;pass first 3 bits
.next3	asl.w	#$1,d0
	adda.w	(a0,d0.w),a0		;add a0 + d0 offset to a0 - This moves the SPF value into a0
	move.w	$5A(a3),d0		;SPANum into d0 (index into animation)
	move.w	(a0,d0.w),d2		;a0 + d0 offset into d2 - this is the new SPF frame of this animation
	tst.w	$5C(a3)		;check if SPAcnt is 0 (time for a new frame)
	bmi.w	.next4		;branch if so (SPAcnt is negative)
	sub.w	d7,$5C(a3)		;sub frames elasped from SPAcnt
	bpl.w	.next6		;branch if SPAcnt is positive
	addi.w	#$4,$5A(a3)		;add 4 to SPAnum (set for next index)
	addi.w	#$4,d0		;add 4 to d0 (currently holds current index)
	tst.w	-$2(a0,d0.w)		;test -2 offset from a0 + d0 (this is the frame
	bpl.w	.next4		;branch if positive (not the end of the animation)
	clr.w	d0
	clr.w	$5A(a3)
	bclr	#$5,$62(a3)
	bclr	#$1,$63(a3)		;clear animation in progress
	bclr	#$5,$64(a3)		;clear fall down flag
	btst	#$0,d1		;check if anim attribute loops
	bne.w	.next4
	clr.w	$58(a3)
.next4	move.w	$2(a0,d0.w),d0		;move frame time for animation frame into d0
	bpl.w	.next5
	neg.w	d0		;make d0 negative (this is the case if final frame)
.next5	move.w	d0,$5C(a3)		;move d0 into SPAcnt
.next6	sub.b	d7,$65(a3)		;sub frames elapsed from glitch - limit minimum
	bpl.w	.ex		;branch if glitch is positive still
	clr.b	$65(a3)
	cmp.w	$6(a3),d2		;compare frame to d2
	beq.w	.ex
	move.w	d2,$6(a3)		;move d2 into frame
	move.b	#$4,$65(a3)		;move 4 into glitch - /60 sec min frame switch time
.ex	rts
freezewindow						;lock scrolling to the current position
	move.w	$17CEA.l,$17EDE.l
	move.w	$17CEE.l,$17EDC.l
	bset	#$6,$17F6A.l
	rts
checkwindow
	move.w	$17EDE.l,d2
	move.w	$17EDC.l,d3
	btst	#$6,$17F6A.l
	bne.w	.next3
	movea.l	#$17B80,a3
	move.w	$17BE0.l,d0
	bmi.w	.next2
	asl.w	#$7,d0
	movea.l	#$17480,a3
	adda.w	d0,a3
	move.w	d7,d0
	add.w	d0,d0
	btst	#$7,$62(a3)
	beq.w	.next
	add.w	d0,$17EE0.l
	cmpi.w	#$32,$17EE0.l
	blt.w	.next2
	move.w	#$32,$17EE0.l
	bra.w	.next2
.next	sub.w	d0,$17EE0.l
	cmpi.w	#$FFCE,$17EE0.l
	bgt.w	.next2
	move.w	#$FFCE,$17EE0.l
.next2	move.w	$2A(a3),d2
	asr.w	#$7,d2
	add.w	$14(a3),d2
	add.w	$17EE0.l,d2
	move.w	$0(a3),d3
	move.w	d2,$17EDE.l
	move.w	d3,$17EDC.l
.next3	move.w	d2,d0
	sub.w	$17CEA.l,d0
	cmpi.w	#$FFF6,d0
	bge.w	.next4
	move.w	d2,d1
	subi.w	#$FFF6,d1
	cmpi.w	#$FF38,d1
	bgt.w	.next5
	move.w	#$FF38,d1
	bra.w	.next5
.next4	cmpi.w	#$A,d0
	ble.w	.next7
	move.w	d2,d1
	subi.w	#$A,d1
	cmpi.w	#$100,d1
	blt.w	.next5
	move.w	#$100,d1
.next5	sub.w	$17CEA.l,d1
	beq.w	.next7
	asr.w	#$4,d1
	bne.w	.next6
	addi.w	#$1,d1
.next6	add.w	d1,$17CEA.l
.next7	move.w	d3,d0
	sub.w	$17CEE.l,d0
	cmpi.w	#$FFD8,d0
	bge.w	.next8
	move.w	d3,d1
	subi.w	#$FFD8,d1
	cmpi.w	#$FFC4,d1
	bge.w	.next9
	move.w	#$FFC4,d1
	bra.w	.next9
.next8	cmpi.w	#$28,d0
	ble.w	.ex
	move.w	d3,d1
	subi.w	#$28,d1
	cmpi.w	#$3C,d1
	ble.w	.next9
	move.w	#$3C,d1
.next9	sub.w	$17CEE.l,d1
	beq.w	.ex
	asr.w	#$4,d1
	bne.w	.next10
	addi.w	#$1,d1
.next10	add.w	d1,$17CEE.l
.ex	rts
