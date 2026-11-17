updateplayers
	btst	#$7,$17F6A.l
	bne.w	.next3
	dc.w	$0079,$000F,$0001,$7DC8		; ori.w #$F,$17DC8.l
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
.next4	jsr	(PlayedByAwayClearFlag).l
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
	jsr	(ReadJoy3).l
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
	jsr	(ReadJoy4).l
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

doinput
	btst	#$4,d1
	beq.w	.next
	btst	#$5,d1
	beq.w	.next
	bclr	#$4,d1
	bset	#$6,$64(a3)
	bra.w	.next5
.next	btst	#$4,d1
	beq.w	.next2
	bclr	#$6,$64(a3)
.next2	btst	#$4,d2
	beq.w	.next5
	bclr	#$6,$64(a3)
	beq.w	.next5
	tst.w	d4
	bne.w	.next3
	move.b	#$11,$17E56.l
	bra.w	.next4
.next3	move.b	#$11,$17E57.l
.next4	bclr	#$4,d2
.next5	btst	#$7,$17F78.l
	beq.w	.next6
	bclr	#$6,d0
	bclr	#$6,d1
	bclr	#$6,d2
	bclr	#$6,d3
	cmpi.b	#$8,d0
	beq.w	.next6
	jsr	(ShortenMsgTimer).l
	move.l	#$8,d0
	clr.l	d1
	clr.l	d2
	clr.l	d3
.next6	move.w	d0,$17E62.l
	andi.w	#$F,$17E62.l
	bsr.w	setpads
	btst	#$7,d1
	beq.w	.next8
	tst.w	$17F96.l
	bpl.w	.next7
	tst.w	d4
	beq.w	EndDemoExitMode0Off
	bra.w	EndDemoExitMode0On
.next7	btst	#$7,d1
	beq.w	.next8
	tst.w	$17F96.l
	beq.w	EndDemoExitMode3Off
	bra.w	EndDemoExitMode4On
.next8	btst	#$7,$17F6A.l
	beq.w	.next9
	btst	#$3,d0
	bne.w	.next9
	addi.w	#$2,d0
	andi.w	#$7,d0
.next9	btst	#$0,$17F6C.l
	bne.w	faceoffinput
	btst	#$3,$63(a3)
	bne.w	lineinput
	btst	#$3,$62(a3)
	beq.w	doinputExit
	movem.l	d0-d2/a0/a3,-(sp)
	move.w	$17E2A.l,d0
	cmp.w	$52(a3),d0
	bne.w	.next10
	tst.w	$17E30.l
	bmi.w	.next10
	tst.w	$17EBC.l
	bpl.w	.next10
	btst	#$5,d1
	beq.w	.next10
	move.w	$17E30.l,d0
	asl.w	#$7,d0
	movea.l	#$17480,a3
	adda.w	d0,a3
	tst.w	$34(a3)
	beq.w	.next10
	jsr	(PuckOnAttackHalf).l
	beq.w	.next10
	btst	#$3,$62(a3)
	bne.w	.next10
	btst	#$3,$64(a3)
	bne.w	.next10
	move.w	d4,$1AD7A.l
	move.w	$17F96.l,$1AD7C.l
	move.w	#$23,d0
	jsr	(assreplace).l
	movem.l	(sp)+,d0-d2/a0/a3
	rts
.next10	movem.l	(sp)+,d0-d2/a0/a3
	btst	#$3,$64(a3)
	bne.w	.next11
	btst	#$5,$62(a3)
	bne.w	doinput_islocked
.next11	btst	#$0,$63(a3)
	bne.w	faceoffinputExit
	move.w	$17BE0.l,d5
	cmp.w	$52(a3),d5
	beq.w	doinput_ispc
	tst.w	$34(a3)
	beq.w	.next13
	btst	#$3,$64(a3)
	beq.w	.next12
	bra.w	.next13
.next12	btst	#$6,d1
	bne.w	Holdplayer
.next13	tst.w	$34(a3)
	beq.w	.next14
	btst	#$2,$17F70.l
	bne.w	.next35
	bra.w	.next17
.next14	btst	#$6,$17F74.l
	bne.w	.next17
	tst.w	d4
	beq.w	.next15
	tst.w	$18C0E.l
	bra.w	.next16
.next15	tst.w	$18C0C.l
.next16	beq.w	.next17
	movem.w	d0,-(sp)
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	movem.w	(sp)+,d0
	beq.w	.next17
	bra.w	PassToJump
.next17	btst	#$4,d3
	beq.w	.next25
	tst.w	$19374.l
	bne.w	.next25
	tst.w	d4
	beq.w	.next21
	tst.b	$17E57.l
	beq.w	.next35
	subi.b	#$1,$17E57.l
	bpl.w	.next18
	move.b	#$0,$17E57.l
.next18	tst.b	$17E57.l
	bne.w	.next25
	tst.w	d4
	beq.w	.next19
	tst.w	$18C0E.l
	bra.w	.next20
.next19	tst.w	$18C0C.l
.next20	bne.w	.next25
	bra.w	.next33
.next21	tst.b	$17E56.l
	beq.w	.next35
	subi.b	#$1,$17E56.l
	bpl.w	.next22
	move.b	#$0,$17E56.l
.next22	tst.w	d4
	beq.w	.next23
	tst.w	$18C0E.l
	bra.w	.next24
.next23	tst.w	$18C0C.l
.next24	bne.w	.next25
	tst.b	$17E56.l
	beq.w	.next33
.next25	btst	#$4,d1
	beq.w	.next27
	tst.w	d4
	bne.w	.next26
	move.b	#$11,$17E56.l
	bra.w	.next35
.next26	move.b	#$11,$17E57.l
	bra.w	.next35
.next27	btst	#$4,d2
	beq.w	.next35
	btst	#$4,d3
	bne.w	.next35
	move.w	$17E56.l,d0
	tst.w	d4
	beq.w	.next30
	move.b	#$11,$17E57.l
	andi.w	#$FF,d0
	bne.w	PassToJump
	tst.w	d4
	beq.w	.next28
	tst.w	$18C0E.l
	bra.w	.next29
.next28	tst.w	$18C0C.l
.next29	bne.w	PassToJump
	bra.w	.next33
.next30	move.b	#$11,$17E56.l
	andi.w	#$FF00,d0
	bne.w	PassToJump
	tst.w	d4
	beq.w	.next31
	tst.w	$18C0E.l
	bra.w	.next32
.next31	tst.w	$18C0C.l
.next32	bne.w	PassToJump
.next33	tst.w	$19374.l
	bne.w	PassToJump
	move.w	#$5,d0
	cmpi.w	#$5,d6
	ble.w	.next34
	move.w	#$B,d0
.next34	jsr	(getGoalieSCnum).l
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
.next35	tst.w	$34(a3)
	bne.w	doinput_onetimer
	btst	#$6,d1
	beq.w	doinputExitButtons
	move.w	$17E62.l,d0
	cmpi.b	#$8,d0
	beq.w	doinputExitButtons
	move.w	d0,$54(a3)
	move.b	#$8,$5E(a3)
	move.w	#$2F4,d1
	bsr.w	SetSPA
	bset	#$1,$63(a3)
	bset	#$5,$62(a3)
	addi.w	#$96,(Crowdlevel).l
doinputExit
	rts
; doinput: button checks at the exit
doinputExitButtons	btst	#$5,d1
	bne.w	.next3
	btst	#$5,d3
	bne.w	.next
	bclr	#$7,$63(a3)
	bra.w	doinputCheckAnimFlag
.next	btst	#$7,$63(a3)
	beq.w	doinputCheckAnimFlag
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	#SPAlist,a0
	adda.w	$58(a3),a0
	move.w	$54(a3),d0
	btst	#$3,$4(a3)
	beq.w	.next2
	neg.w	d0
	addi.w	#$8,d0
	andi.w	#$7,d0
.next2	asl.w	#$1,d0
	adda.w	(a0,d0.w),a0
	tst.b	$5B(a3)
	movem.l	(sp)+,d0-d3/a0-a3
	bpl.w	doinputExit
	move.w	#$A,$5C(a3)
	rts
.next3	btst	#$5,$62(a3)
	bne.w	doinputCheckAnimFlag
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
	bgt.w	.next4
	cmpi.w	#$FF25,$17B94.l
	bgt.w	.next5
.next4	subi.w	#$40,d0
.next5	move.w	d0,d1
	muls.w	$17BA8.l,d0
	swap	d0
	add.w	$17B80.l,d0
	muls.w	$17BAA.l,d1
	swap	d1
	add.w	$17B94.l,d1
	bsr.w	.next10
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmpi.l	#$384,d0
	bhi.w	.next6
	movem.w	(sp)+,d0-d1
	bra.w	.next8
.next6	bsr.w	Sroot
	moveq	#$1,d2
	add.w	d0,d2
	moveq	#$12,d4
	btst	#$3,$17F6A.l
	beq.w	.next7
	addi.w	#$8,d4
.next7	movem.w	(sp)+,d0-d1
	muls.w	d4,d1
	addi.w	#$8,d4
	muls.w	d4,d0
	divs.w	d2,d0
	divs.w	d2,d1
.next8	add.w	d3,d1
	move.w	d1,d2
	cmpi.w	#$22,$2(a0)
	cmpi.w	#$18,(a0)
	cmpi.w	#$FFE8,(a0)
	cmpi.w	#$C,$2(a0)
	cmpi.w	#$108,$17B94.l
	cmpi.w	#$FEF8,$17B94.l
	bset	#$1,$63(a3)
	bne.w	doinputCheckAnimFlag
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#$17E36,a0
	move.w	#$108,d3
	btst	#$7,$62(a3)
	beq.w	.next9
	neg.w	d3
	adda.w	#$4,a0
.next9	jsr	(AdjustFacingDirectionStep).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.next10	move.w	$17BE0.l,d2
	cmp.w	$52(a3),d2
	bne.w	.next11
	clr.w	d0
.next11	cmpi.w	#$103,d1
	blt.w	.next12
	move.w	#$103,d1
.next12	cmpi.w	#$FEFD,d1
	bgt.w	.next13
	move.w	#$FEFD,d1
.next13	sub.w	d3,d1
	rts
doinput_chkanim						;Nothing while a3's animation runs (pflags2 bit 1); else skate a3
									;(doplayeracc)
	bchg	d0,d6
	bchg	d0,$250.w
	andi.l	#$1EC021E,-(a2)
; Instruction bytes inside doinput_chkanim that the assembler would encode differently, kept as words (1 row).
	dc.w	$148E,$14C0,$14F2,$1544
; doinput: skips when flag 1 of $63 is clear
doinputCheckAnimFlag
	btst	#$1,$63(a3)
	beq.w	.next
	rts
.next	tst.w	$34(a3)
	bne.w	doplayeracc
	bclr	#$1,$17F70.l
	cmpi.w	#$24,$0(a3)
	ble.w	.next2
	tst.w	$28(a3)
	bmi.w	.next2
	beq.w	.next2
	bset	#$1,$17F70.l
	clr.w	$28(a3)
.next2	cmpi.w	#$FFDC,$0(a3)
	bge.w	.next3
	tst.w	$28(a3)
	bpl.w	.next3
	bset	#$1,$17F70.l
	clr.w	$28(a3)
.next3	cmpi.w	#$E7,$14(a3)
	bgt.w	.next5
	cmpi.w	#$FF19,$14(a3)
	ble.w	.next5
	bra.w	.next4
.next4	movem.w	d0-d1,-(sp)
	move.w	$14(a3),d0
	move.w	$2A(a3),d1
	eor.w	d1,d0
	movem.w	(sp)+,d0-d1
	bpl.w	.next5
	tst.w	$2A(a3)
	beq.w	.next5
	bset	#$1,$17F70.l
	clr.w	$2A(a3)
.next5	btst	#$1,$17F70.l
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
	jsr	(GetTeamStructCount).l
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
	bra.w	FaceoffInputCheckLocked
.c1	subi.b	#$1,$19380.l
	bpl.w	.6
	move.b	#$0,$19380.l
.6	tst.b	$19380.l
	bne.w	.arel
	bset	#$3,$17F74.l
	jsr	(setpassmode).l
	bra.w	FaceoffInputCheckLocked
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
	jsr	(GetTeamStructCount).l
	bra.w	SetShotMode
doinput_islocked						;a3 is locked in an animation: B (bit 4) changes the controlled player
	move.w	$17BE0.l,d5
	cmp.w	$52(a3),d5
	beq.w	doinputExit
	btst	#$4,d1
	beq.w	doinput_islockedExit
	btst	#$6,$17F74.l
	bne.w	doinput_islockedExit
	bsr.w	PassToJump
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
	beq.w	.next
	jmp	$30AB0.l
.next	btst	#$4,d1		;test for b button press
	beq.w	.1		;branch if pressed
	move.w	#$FEA,d1
	bset	#$1,$63(a3)		;set anim in progress
	bra.w	SetSPA
.1	move.w	#$1014,d1		;#SPAfaceoffr anim
	bra.w	SetSPA
faceoffinputExit
	rts
; Leaves faceoff input when the player is locked.
FaceoffInputCheckLocked
	tst.w	$18C0A.l
	bne.w	doinput_islockedExit
	btst	#$4,$17F7A.l
	bne.w	doinput_islockedExit
	jsr	$3C958.l
	bset	#$1,$32(a2)
	bne.w	doinput_islockedExit
	btst	#$3,$17F74.l
	bne.w	.next
	bclr	#$2,$17F6A.l
.next	bclr	#$3,$17F6A.l
	bset	#$3,$63(a3)
SetLCmode2
	bsr.w	setlccords
	cmpi.w	#$F,(printy).l
	blt.w	.next
	bset	#$0,$17F6E.l
	bra.w	.next2
.next	jsr	(PrintBannerFont1).l
	bsr.w	setlccords
.next2	jsr	(Framer).l
	subi.w	#$2,(printy).l
	addi.w	#$1,(printx).l
	moveq	#$2,d4
.loop	move.w	d4,d0
	bsr.w	SetLcCoordsForSide
	tst.w	d0
	bmi.w	.next5
	btst	#$1,$32(a2)
	bne.w	.next3
	cmp.w	$30(a2),d4
	bne.w	.next4
	move.w	$16(a2),d0
.next3	movea.l	#mesarea,a1
	move.l	#$44120,(a1)
	add.b	d4,$2(a1)
	jsr	(print).l
	move.w	d0,-(sp)
	movea.l	#linelist,a1
	jsr	(PrintTickerEntry).l
	move.w	(sp)+,d0
	jsr	(linebar).l
	subi.w	#$5,(printx).l
.next4	subi.w	#$1,(printy).l
.next5	dbra	d4,.loop
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
	beq.w	.next
	eori.w	#$16,d0
.next	jsr	(printz).l
	String	CC_Font1Pri,$16,$0
	add.w	d0,(printy).l
	moveq	#$2,d0
	bsr.w	SetLcCoordsForSide
	moveq	#$6,d1		;3 rows
	tst.w	d0
	bpl.w	.next2
	subi.w	#$1,d1		;no third choice: 2 rows
	addi.w	#$1,(printy).l
.next2	moveq	#$9,d0
	rts
; Picks the line-change coordinates for the current side.
SetLcCoordsForSide
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
	lea.l	.next(pc),a0
	move.b	(a0,d0.w),d0
	ext.w	d0
	movem.l	(sp)+,d1-d2
	rts
; Table of 32 words after getlchoice2, 64 bytes: $0001,$0201,$0200,$0200,$0100,$0102 ...
.next	dc.w	$0001,$0201,$0200,$0200,$0100,$0102,$0001,$0200
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
	bne.w	LineInputSetCoords
	addi.w	#$1,d2
	btst	#$4,d1
	bne.w	LineInputSetCoords
	addi.w	#$1,d2
	btst	#$5,d1
	bne.w	LineInputSetCoords
	btst	#$3,$62(a3)
	beq.w	.x
	btst	#$5,$62(a3)
	bne.w	.x
	btst	#$0,$63(a3)
	beq.w	doplayeracc		;skate with dpad if not fighting
.x	rts
; Stores the choice and sets its coordinates.
LineInputSetCoords
	move.w	d2,d0
	move.w	d2,$30(a2)
	bsr.w	SetLcCoordsForSide
	tst.w	d0
	bpl.w	.next
	jmp	$30AB0.l
.next	bclr	#$3,$63(a3)
	bset	#$3,$62(a3)
	jsr	$3C958.l
	bclr	#$1,$32(a2)
	move.w	d0,$16(a2)
	jsr	(setpersonel).l
lcfound_close						;close lc box
	btst	#$7,$17F6A.l
	bne.w	setpassmodeExit
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
	beq.w	.next		;branch if 0
	move.w	$14(a3),d0		;move Ypos checker into d0
	sub.w	$14(a0),d0		;sub Ypos of player
	btst	#$7,$62(a3)		;check goal checker is shooting at
	beq.w	.air		;jump if bottom
	neg.w	d0		;make d0 negative
.air	bmi.w	.next
	move.w	#$C90,d1		;set anim - hold check stick in air
.next	bra.w	SetSPA
setpassmode						;initialize pass mode
	move.w	$54(a3),$17E2C.l
	andi.w	#$7,$17E2C.l
	btst	#$2,$17F70.l
	beq.w	.next
	bclr	#$2,$17F78.l
	bset	#$5,$17F70.l
	bne.w	doinput_islockedExit
	bclr	#$5,$17F78.l
	move.w	#$64,$17F9A.l
.next	bset	#$2,$17F6A.l
; Return of setpassmode
setpassmodeExit	rts
passmode						;dpad sets passdir until bbut changes
	btst	#$4,d2		;has b button changed?
	bne.w	dopass		;yes
	btst	#$3,$17F74.l		;Not in NHL Hockey Source
	bne.w	dopass
	btst	#$3,d0		;look for dpad
	bne.w	setpassmodeExit
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
	bra.w	.next4
.noot	moveq	#$8,d0		;moves 8 into d0
	tst.w	$34(a3)		;checks if goalie
	beq.w	.calc		;jump if goalie
	move.b	$6E(a3),d0		;Passacc
.calc	asl.w	#$2,d0		;d0 = passacc for player, 8 for goalie
	asr.w	#$1,d0		;change from NHL Hockey Source,
	addi.w	#$A0,d0
	move.w	d0,$17E2E.l
	btst	#$0,$6E(a3)		;Checks to see if bit 0 in Passacc is 0
	beq.w	.next		;Jumps if 0 (even number)
	asr.w	#$4,d0		;divide d0 by 16
	add.w	d0,$17E2E.l
.next	moveq	#-1,d4
	moveq	#$5,d3
	movea.l	#$17480,a1
	cmpi.w	#$6,$52(a3)		;compares 6 to SCnum(a3) (current player with puck) to check if
	blt.w	.0		;Jump if player is Home, continue if Away
	adda.w	#$300,a1		;Switch to Away Team Players
	btst	#$2,$17F70.l
	bne.w	.next3
.0	cmpa.l	a1,a3		;Check to see if passing to self
	beq.w	.next2		;skip if this is passing player
	tst.w	$34(a1)		;position(a1)
	beq.w	.next2		;skip if goalie
	btst	#$2,$63(a1)		;check if player is unavailable
	bne.w	.next2		;player unavailable
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
	bhi.w	.next2		;if higher branch to next
	muls.w	d1,d1		;square d1 (dX)
	muls.w	d2,d2		;square d2 (dY)
	add.l	d1,d2		;add together
	add.l	d0,d2		;add modified passdir to d2
	cmp.l	d4,d2		;compare d4 to d2
	bhi.w	.next2		;branch if higher (player is farther away than the closest player)
	move.l	d2,d4		;move d2 into d4
	movea.l	a1,a0		;move a1 address into a0 (receiving player)
.next2	adda.w	#$80,a1		;Skip to next player (80 hex is length of player struct)
	dbra	d3,.0
	tst.l	d4		;check if there's a player to pass to
	bmi.w	.next3		;skip if no player to pass to
	bsr.w	passto
	bra.w	.next4
.next3	move.w	$17E2C.l,d0
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
.next4	tst.w	$34(a3)
	bne.w	.next6
	tst.w	$17BAA.l
	btst	#$7,$62(a3)		;$62 = pflags Checks for what goal team is shooting at (0=bottom, 1=top)
	beq.w	.g0
	bmi.w	.next5
	bra.w	.next6
.g0	bmi.w	.next6
.next5	neg.w	$17BAA.l
.next6	move.w	$17BA8.l,d0
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

passto						;pass the puck to player a0: a3 = passer
	btst	#$3,$62(a3)
	beq.w	.next
	tst.w	$34(a3)
	bne.w	.next
	movem.l	d0-d1,-(sp)
	btst	#$3,$62(a0)
	bne.w	.stack
	bset	#$6,$64(a0)		;pflags3 bit 6
	move.w	$17FA6.l,d1
	cmp.w	$17FA8.l,d1
	bne.w	.h2hor1p
	move.w	$52(a0),d0		;SCnum of receiver into d0
	move.w	$52(a3),d1		;SCnum of passer into d1
	cmp.w	$17F9E.l,d1
	bne.w	.p2passing
	jsr	(setc1player).l
	bra.w	.stack
.p2passing	jsr	(setc2player).l
	bra.w	.stack
.h2hor1p	move.w	#$1,d1
	btst	#$6,$62(a3)		;check if home or away team
	beq.w	.0		;branch if home
	move.w	#$2,d1		;away team
.0	move.w	$52(a0),d0		;move SCnum of receiver into d0
	cmp.w	$17FA6.l,d1
	bne.w	.diffteam
	jsr	(setc1player).l
	bra.w	.stack
.diffteam	jsr	(setc2player).l
.stack	movem.l	(sp)+,d0-d1
.next	jsr	$3C958.l
	addi.w	#$1,$12(a2)
	move.w	$52(a0),$17E30.l
	move.w	$17E2E.l,d5
	asr.w	#$2,d5
	exg.l	a0,a3
	moveq	#$13,d0
	bsr.w	AssistListPush
	exg.l	a0,a3
	move.l	a0,-(sp)
	bsr.w	GetHotCount
	add.w	$0(a0),d0
	sub.w	$17B80.l,d0
	add.w	$14(a0),d1
	sub.w	$17B94.l,d1
	movem.w	d0-d1,-(sp)
	movem.w	(sp),d2-d3
	asr.w	#$2,d2
	asr.w	#$2,d3
	move.w	$28(a0),d0
	muls.w	#$F0,d0
	swap	d0
	move.w	$2A(a0),d1
	muls.w	#$F0,d1
	swap	d1
	movem.w	d0-d1,-(sp)
	muls.w	d2,d0
	muls.w	d3,d1
	add.w	d1,d0
	asl.w	#$1,d0
	move.w	d0,d4
	movem.w	(sp),d0-d1
	muls.w	d0,d0
	muls.w	d1,d1
	muls.w	d5,d5
	neg.l	d5
	add.l	d0,d5
	add.l	d1,d5
	muls.w	d2,d2
	muls.w	d3,d3
	add.l	d2,d3
	muls.w	d5,d3
	asl.l	#$2,d3
	move.w	d4,d0
	muls.w	d0,d0
	sub.l	d3,d0
	bsr.w	Sroot
	moveq	#$1,d3
	asr.w	#$2,d5
	bne.w	.loop
	moveq	#$1,d5
.loop	move.w	d0,d2
	neg.w	d0
	sub.w	d4,d2
	ext.l	d2
	divs.w	d5,d2
	dbpl	d3,.loop
	bne.w	.next2
	addi.w	#$1,d2
.next2	cmpi.w	#$18,d2
	bls.w	.next3
	moveq	#$18,d2
.next3	move.b	d2,$17BAC.l
	cmpi.w	#$C,d2
	blt.w	.next4
	move.b	#$C,$17BAC.l
.next4	move.w	d2,d0
	asl.w	#$3,d0
	subi.w	#$A,d0
	move.b	d0,$40(a0)
	subi.w	#$6,d0
	move.b	d0,$17BDE.l
	movem.w	(sp)+,d0-d1
	muls.w	d2,d0
	asr.l	#$1,d0
	add.w	(sp)+,d0
	move.w	$17B80.l,$44(a0)
	add.w	d0,$44(a0)
	muls.w	d2,d1
	asr.l	#$1,d1
	add.w	(sp)+,d1
	move.w	$17B94.l,$46(a0)
	add.w	d1,$46(a0)
	mulu.w	#$78,d2
	swap	d0
	divs.w	d2,d0
	move.w	d0,$17BA8.l
	swap	d1
	divs.w	d2,d1
	move.w	d1,$17BAA.l
	rts
; Jumps to the pass routine at $2B4E2.
PassToJump
	jmp	(HotColdIconDraw).l
Sweepcheck						;start sweep check on player a3
	bset	#$5,$62(a3)
	move.w	#$B24,d1
	bra.w	SetSPA
setc1player
	cmp.w	$17F9E.l,d0
	beq.w	.ex
	movem.l	d1/a0-a1,-(sp)
	move.w	$17F9E.l,d1
	bsr.w	restorepl
	move.w	d0,$17F9E.l
	movem.l	(sp)+,d1/a0-a1
.ex	rts
setc2player
	cmp.w	$17FA0.l,d0
	beq.w	.ex
	movem.l	d1/a0-a1,-(sp)
	move.w	$17FA0.l,d1
	bsr.w	restorepl
	move.w	d0,$17FA0.l
	movem.l	(sp)+,d1/a0-a1
.ex	rts
restorepl						;restore old joy controlled player d1, give d0 the joystick; a d1 in line
									;change mode keeps control
	movea.l	#$17480,a0
	tst.w	d1
	blt.w	.spd
	cmpi.w	#$B,d1
	bgt.w	.spd
	asl.w	#$7,d1		;multiply d0 by 80 hex (SCsize)
	btst	#$3,$63(a0,d1.w)		;#pfnp - no joystick pad
	beq.w	.cont
	lsr.w	#$7,d1		;divide by 80 hex
	move.w	d1,d0
	rts
.cont	bclr	#$3,$62(a0,d1.w)		;#pfjoycon
	btst	#$3,$64(a0,d1.w)		;bit 3, pflags3
	bne.w	.spd
	bset	#$1,$62(a0,d1.w)		;#pfna - new assignment
.spd	tst.w	d0		;checks if d0 0 or higher
	blt.w	.ex
	cmpi.w	#$B,d0		;checks if d0 11 or less
	bgt.w	.ex
	move.w	d0,d1		;copies d0 into d1
	asl.w	#$7,d1
	btst	#$2,$17F70.l
	bne.w	.chkgoalie
	btst	#$0,$17F78.l
	beq.w	.3
.chkgoalie	tst.w	$34(a0,d1.w)
	bne.w	.3
	btst	#$6,$62(a0,d1.w)		;check if home or away
	beq.w	.next
	tst.w	$18C0E.l
	bra.w	.1
.next	tst.w	$18C0C.l
.1	beq.w	.3
	move.w	#$0,d0		;first position of home SCNum
	btst	#$6,$62(a0,d1.w)		;check if home or away
	beq.w	.2
	move.w	#$6,d0		;first position of away SCNum
.2	bra.w	.ex
.3	bset	#$3,$62(a0,d1.w)		;set pfjoycon for SCNum
.ex	rts
Findhittype						;look for type of swing (forhand or backhand)
									;input d0 = launch dir
									;ouput beq forhand
	neg.w	d0
	add.w	$54(a3),d0		;facedir
	andi.w	#$7,d0
	btst	#$3,$4(a3)		;attribute bit 3
	beq.w	.next
; Instruction bytes inside Findhittype that the assembler would encode differently, kept as words (1 row).
	dc.w	$013C,$00F0,$4E75
; Table of 3 words after Findhittype, 6 bytes: $013C,$001E,$4E75 ...
.next	dc.w	$013C,$001E,$4E75
SetShotMode
	btst	#$2,$17F70.l
	beq.w	.next
	bclr	#$2,$17F78.l
	bset	#$5,$17F70.l
	bne.w	doinput_islockedExit
	bclr	#$5,$17F78.l
	move.w	#$64,$17F9A.l
.next	move.w	#$8,$17E2C.l
	bset	#$3,$17F6A.l
	clr.w	d0
	move.w	#$128,d1
	btst	#$7,$62(a3)
	bne.w	.next2
	neg.w	d1
.next2	sub.w	$0(a3),d0
	sub.w	$14(a3),d1
	bsr.w	vtoa
	move.w	#$F,$17E2E.l
	move.w	#$7FC,d1
	bsr.w	Findhittype
	beq.w	.next3
	move.w	#$92E,d1
	move.w	#$F,$17E2E.l
.next3	bra.w	SetSPA
ShotMode						;shot input
									;swing frame reached (anim frame 7*4): shoot, else dpad sets shot
									;direction
	cmpi.w	#$1C,$5A(a3)
	bge.w	prepshot		;end of animation so shoot
	btst	#$3,d0		;checks dpad for direction
	bne.w	.next
	andi.w	#$7,d0		;pass the first 3 bits of d0
	move.w	d0,$17E2C.l
.next	cmpi.w	#$10,$5A(a3)
	bge.w	doshotExit
	add.w	d7,$17E2E.l
	cmpi.b	#$14,$6C(a3)		;6C = shot speed
	bge.w	.checkcbut
	cmpi.w	#$8,$5A(a3)		;SPANum
	bgt.w	.chganim
.checkcbut	btst	#$5,d2		;5 = #cbut
	beq.w	doshotExit		;button hasnt changed so continue windup
.chganim	neg.w	$5A(a3)		;end windup and swing through
	addi.w	#$1C,$5A(a3)		;Add to SPANum
	rts
prepshot						;check the conditions before a shot: d0 = SCnum of the opposing goalie
									;(getGoalieSCnum)
	bclr	#$4,$17F74.l
	move.w	#$B,d0
	btst	#$6,$62(a3)		;check if home or away
	beq.w	.getGoalie		;gets opponents Goalie SCnum
	move.w	#$5,d0		;opponent is home
.getGoalie	jsr	(getGoalieSCnum).l
	tst.w	d0
	bmi.w	.next
	movem.l	a0,-(sp)
	asl.w	#$7,d0
	movea.l	#$17480,a0
	cmpi.w	#$250,$58(a0,d0.w)		;Checking goalie animations - pad stack right
	beq.w	.svgoalie
	cmpi.w	#$2A2,$58(a0,d0.w)		;Checking another goalie animation - pad stack left
.svgoalie	movem.l	(sp)+,a0		;pop stack value into a0
	bne.w	.cont
.next	cmpi.w	#$1,$17E2C.l
	ble.w	.next2
	cmpi.w	#$7,$17E2C.l
	bne.w	.cont
.next2	move.w	$17B94.l,d0
	btst	#$7,$62(a3)		;#pfgoal - goal to shoot at (0=bottom, 1=top)
	bne.w	.cmppuck		;branch if top
	neg.w	d0		;flips d0 for compare calc
.cmppuck	cmpi.w	#$D8,d0		;compares location of puck
	blt.w	.cont
	bset	#$4,$17F74.l		;set flag for in-close top shelf shooting
.cont	bra.w	doshot
doshot						;stick is at puck so launch puck toward goal
	movem.l	d0-d7/a0-a3,-(sp)
	bclr	#$4,$17F78.l
	btst	#$1,$64(a3)		;check if player on breakaway
	beq.w	.cont
	bset	#$4,$17F78.l		;set if breakaway
.cont	bsr.w	ShotDirAdjustCheck
	move.w	#$5,-(sp)		;#SFXshotwiff - sound effect
	move.w	$52(a3),$17E28.l
	bclr	#$3,$17F6A.l		;#sfssdir - shot direction mode
	bset	#$5,$62(a3)		;#pfalock
	btst	#$3,$64(a3)		;check if shooting one timer
	bne.w	.shottype		;jump if yes
	move.w	$17BE0.l,d0		;puck carrier SCnum into d0
	cmp.w	$52(a3),d0		;is player puck carrier?
	bne.w	.next5		;wiffed shot
.shottype	move.w	#$18,(sp)		;#SFXshotfh
	bset	#$4,$17F6C.l		;#sf2shot - shot was taken
	cmpi.w	#$92E,$58(a3)
	bne.w	.nbh		;no backhand
	move.w	#$14,(sp)		;#SFXshotbh
	move.w	$17E2E.l,d0
	lsr.w	#$2,d0
	sub.w	d0,$17E2E.l
.nbh	btst	#$3,$64(a3)		;check if shooting one timer
	beq.w	.cont2		;jump if not
	movem.l	d0-d1,-(sp)		;push d0-d1 on stack
	move.w	#$1F,d0		;1F into d0 - one timer min speed
	move.w	d0,$17E2E.l
	movem.l	(sp)+,d0-d1		;Pop off stack d0-d1
.cont2	clr.w	d0
	move.b	$6C(a3),d0		;6C = shotspd (ShP)
	lsr.b	#$1,d0		;divide by 2
	movea.l	a3,a0		;move a3 address into a0
	jsr	(makepde).l
	addi.w	#$14,d0
	mulu.w	$17E2E.l,d0
	mulu.w	#$5249,d0
	swap	d0
	move.w	d0,$17E2E.l
	btst	#$0,$6C(a3)		;checks if ShP value is even or odd
	beq.w	.even
	asr.w	#$4,d0		;divide by 16
	add.w	$17E2E.l,d0
.even	lsr.w	#$4,d0		;divide by 16 (d0 is passspeed)
	neg.w	d0		;negative
	addi.w	#$3,d0		;add 3 to d0
	bpl.w	.nbh2
	clr.w	d0		;clear if negative
.nbh2	add.w	d0,(sp)		;add to stack current value (Shot SFX)
	st.b	$17BE0.l		;clear puck carrier
	move.b	#$10,$5E(a3)		;5E = nopuck - no puck collision till 0
	move.w	$52(a3),$17E2A.l
	move.w	#$108,d1		;$108 = top goal line Y position
	btst	#$7,$62(a3)		;pfgoal, pflags
	bne.w	.next		;branch if shooting up
	neg.w	d1		;flip d1 if shooting down
.next	move.w	$17E2C.l,d2
	asl.w	#$2,d2
	lea.l	shotdiradj(pc),a0
	move.w	(a0,d2.w),d0
	move.w	$2(a0,d2.w),d2
	sub.w	$17B80.l,d0
	sub.w	$17B94.l,d1
	movem.w	d0-d2,-(sp)		;push d0-d2(dx,dy,z offset) on stack
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	bsr.w	Sroot
	tst.w	d0		;distance in pix to goal
	bne.w	.1
	addi.w	#$1,d0
.1	move.w	d0,d3		;straight line distance from puck to spot aiming for with passdir
	btst	#$4,$17F68.l		;check if highlight (always perfect)
	bne.w	.next2
	cmpi.w	#$C8,d3		;C8 = 200 decimal
	bhi.w	.notperf		;too far away from perfect shot
	jsr	(ReadGoaliePulled).l		;checks if shooting team's G pulled
	bmi.w	.next2		;perfect shot with pulled goalie
	btst	#$0,$17F78.l		;check if shootout
	bne.w	.next2		;perfect shot in shootout
	moveq	#$10,d0		;start value for ShA calc
	add.b	$6D(a3),d0		;shotacc(a3)
	bsr.w	randomd0
	cmpi.w	#$E,d0		;chance of perfect shot
	bgt.w	.next2		;branch if higher - perfect shot
.notperf	clr.w	d0
	move.b	$6D(a3),d0		;shotacc(a3)
	lsr.w	#$1,d0		;divide by 2
	move.b	d0,-(sp)		;push on stack
	move.w	$17E2E.l,d0
	lsr.w	#$4,d0		;divide by 16
	sub.b	(sp)+,d0		;shotacc(a3) / 2
	addi.b	#$10,d0		;add $10 to d0
	mulu.w	d3,d0		;mult straight line distance with d0
	lsr.w	#$6,d0		;shot accuracy adjust - divide by 64
	cmpi.w	#$FA,d3		;250 pixels straight line distance
	bhi.w	.chkvalue		;branch if higher
	lsr.w	#$1,d0		;extra shot accuracy adjust
.chkvalue	cmpi.w	#$88,d0		;compare to $88 (max adj value in X)
	blt.w	.cont3
	move.w	#$88,d0
.cont3	move.w	d0,-(sp)		;push adjusting value: 2(sp) / 4(sp) = x / y diff pushed before
	bsr.w	randomd0s		;RNG adj value
	add.w	d0,$2(sp)		;add result to x diff
	move.w	(sp),d0		;move adjusting value into d0
	cmpi.w	#$3C,d0		;compare to $3C (max adjustment in Y)
	bls.w	.lessx		;branch if less
	moveq	#$3C,d0
	move.w	d0,(sp)
.lessx	tst.w	$4(sp)
	bpl.w	.ycalc
	lsr.w	#$1,d0
.ycalc	bsr.w	randomd0s		;RNG adjustment
	add.w	d0,$4(sp)		;add to y diff
	move.w	(sp)+,d0		;pop adj value
	lsr.w	#$1,d0		;divide by 2
	bsr.w	randomd0		;RNG result
	add.w	d0,$4(sp)		;add to Z diff
.next2	move.w	$17E2E.l,d2
	muls.w	#$44,d2		;1024/15
	muls.w	(sp)+,d2		;mult by x dist
	divs.w	d3,d2		;divide d2 by straight line distance
	move.w	d2,$17BA8.l
	move.w	$17E2E.l,d2
	muls.w	#$44,d2		;1024/15
	muls.w	(sp)+,d2		;mult by y dist
	divs.w	d3,d2		;divide d2 by straight line distance
	move.w	d2,$17BAA.l
	move.w	#$8000,d1		;this is the highest negative puckvy possible
	btst	#$7,$62(a3)		;check direction of shooting net
	beq.w	.2		;branch if bottom goal
	clr.w	d1
.2	eor.w	d2,d1		;EOR - checking to see if exceeding maximum puckvy
	bpl.w	.next3		;branch if positive
	move.w	#$3810,$17BAA.l
	btst	#$7,$62(a3)
	bne.w	.next3
	move.w	#$C7F0,$17BAA.l
.next3	move.w	(sp)+,d1
	beq.w	.next5
	mulu.w	$17E2E.l,d1
	mulu.w	#$44,d1		;1024/15
	divu.w	d3,d1		;by d3 = distance in pix to goal
	mulu.w	#$B33,d3		;(1024*42)/15
	divu.w	$17E2E.l,d3
	add.w	d1,d3
	cmpi.w	#$1800,d3
	bls.w	.next4		;branch if less than
	move.w	#$1800,d3		;set max puckvz
.next4	move.w	d3,$17BAC.l
	bclr	#$4,$17F74.l		;check in-close top shelf bit
	beq.w	.next5		;if bit was cleared, exit
	btst	#$3,$64(a3)		;check if one timer
	bne.w	.next5		;branch if so
	jsr	(puckvzadj).l		;adjust puckvz for top shelf shot
.next5	bsr.w	sfx		;play the shot sound
	movem.l	(sp)+,d0-d7/a0-a3
; Return of doshot
doshotExit	rts
shotdiradj						;If the opposing goalie
									;covers the middle of the net, set passdir 2 or 6 to shoot at the open
									;side, else 0. Skipped for computer players (pfjoycon clear)
	ori.b	#$C,d0
	ori.b	#$C,(a0)
	ori.b	#$6,(a0)
	ori.b	#$0,(a0)
	ori.b	#$0,d0
; Instruction bytes inside shotdiradj that the assembler would encode differently, kept as words (4 rows).
	dc.w	$FFF0
	dc.l	$FFF0
	dc.w	$0006,$FFF0
	dc.w	$000C,$0000,$0006
; Checks the direction bits before adjusting a shot.
ShotDirAdjustCheck
	btst	#$3,$64(a3)
	bne.w	.next
	btst	#$3,$62(a3)
	bne.w	.ex
.next	moveq	#$8,d0
	moveq	#$5,d1
	movea.l	#$17400,a0
	btst	#$6,$62(a3)
	bne.w	.loop
	adda.w	#$300,a0
.loop	adda.w	#$80,a0
	tst.w	$34(a0)
	dbeq	d1,.loop
	bne.w	.next4
	move.b	$28(a0),d0
	ext.w	d0
	asr.w	#$1,d0
	add.w	$0(a0),d0
	sub.w	$17B80.l,d0
	move.b	$2A(a0),d1
	ext.w	d1
	asr.w	#$1,d1
	add.w	$14(a0),d1
	sub.w	$17B94.l,d1
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	addq.l	#$1,d0
	bsr.w	Sroot
	move.w	d0,d2
	movem.w	(sp)+,d0-d1
	moveq	#$12,d3
	move.w	#$108,d4
	btst	#$7,$62(a3)
	bne.w	.next2
	neg.w	d4
.next2	movem.w	d3-d4,-(sp)
	bsr.w	.next6
	move.w	d4,d5
	movem.w	(sp)+,d3-d4
	neg.w	d3
	bsr.w	.next6
	add.w	d5,d4
	clr.w	d0
	cmpi.w	#$2C,d4
	bgt.w	.next4
	cmpi.w	#$FFD4,d4
	blt.w	.next4
	btst	#$7,$62(a3)
	beq.w	.next3
	neg.w	d4
.next3	moveq	#$2,d0
	tst.w	d4
	bpl.w	.next4
	moveq	#$6,d0
.next4	move.w	d0,$17E2C.l
	btst	#$2,$17F70.l
	bne.w	.next5
	btst	#$0,$17F78.l
	beq.w	.ex
.next5	jsr	(PSandSOpassdir).l
.ex	rts
.next6	sub.w	$17B80.l,d3
	sub.w	$17B94.l,d4
	muls.w	d0,d4
	muls.w	d1,d3
	sub.l	d3,d4
	divs.w	d2,d4
	rts
setpads						;Put SCnum of a3 in the d4 nibble of PadControlBits ; d4 = -2 puck
									;carrier, 0 / 2 pads, 4 replay target. Falls into rtss3
	movem.l	d0-d1,-(sp)
	moveq	#$2,d0
	add.w	d4,d0
	add.w	d0,d0
	move.w	#$FFF0,d1
	rol.w	d0,d1
	and.w	d1,$17DC8.l
	move.w	$52(a3),d1
	asl.w	d0,d1
	or.w	d1,$17DC8.l
	movem.l	(sp)+,d0-d1
; Return of setpads
setpadsExit	rts
check4bench
	btst	#$2,$17F70.l
	bne.w	setpadsExit
	btst	#$3,$62(a3)
	bne.w	setpadsExit
	btst	#$4,$63(a3)
	bne.w	setpadsExit
	tst.b	$60(a3)
	bpl.w	.next
	tst.b	$61(a3)
	bmi.w	setpadsExit
.next	move.b	$61(a3),d0
	cmp.b	$66(a3),d0
	beq.w	.next2
	move.w	$36(a3),d0
	cmpi.b	#$B,$38(a3,d0.w)
	beq.w	setpadsExit
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	beq.w	setpadsExit
	adda.w	#$4,sp
	bset	#$2,$63(a3)
	clr.w	$40(a3)
	moveq	#$B,d0
	bra.w	assreplace
.next2	adda.w	#$4,sp
	bclr	#$2,$63(a3)
	bclr	#$2,$62(a3)
	st.b	$61(a3)
	st.b	$60(a3)
	move.w	$34(a3),d0
	tst.b	$60(a3)
	bpl.w	.next3
	jmp	(Setplass).l
.next3	move.b	$60(a3),d0
	ext.w	d0
	move.w	d0,$34(a3)
	jmp	(Setplass).l
; Bench check: flag 5 means skip, a $64 counter means go to the bench
check4benchAlt	btst.b	#$5,$62(a3)
	bne.w	setpadsExit
	cmpi.w	#$64,$40(a3)
	beq.w	BenchGoToBench
	bsr.w	check4bench
	btst.b	#$4,$63(a3)
	bne.w	assexit
	bclr.b	#$1,$62(a3)
	beq.w	.next2
	move.w	#$8,$42(a3)
	moveq	#$50,d0
	btst.b	#$6,$62(a3)
	bne.w	.next
	neg.w	d0
.next	move.w	d0,$46(a3)
	move.w	#$88,$44(a3)
	neg.w	$44(a3)
	subi.w	#$8,$44(a3)
	clr.w	$40(a3)
.next2	move.b	$61(a3),d0
	cmp.b	$66(a3),d0
	beq.w	BenchFlagBits
	sub.w	d7,$40(a3)
	bpl.w	BenchWalkTarget
	addi.w	#$8,$40(a3)
	move.w	$14(a3),d0
	sub.w	$46(a3),d0
	cmpi.w	#$28,d0
	bgt.w	BenchWalkTarget
	cmpi.w	#$FFD8,d0
	blt.w	BenchWalkTarget
	move.w	$0(a3),d0
	sub.w	$44(a3),d0
	cmpi.w	#$20,d0
	bgt.w	BenchWalkTarget
	move.w	#$50C,d1
	tst.w	$34(a3)
	bne.w	.next3
	move.w	#$2,d1
.next3	bsr.w	SetSPA
	bset.b	#$2,$62(a3)
	cmpi.w	#$4,$54(a3)
	beq.w	.next4
	addi.w	#$1,$54(a3)
	andi.w	#$7,$54(a3)
.next4	clr.w	$2A(a3)
	move.w	#$F800,$28(a3)
	cmpi.w	#$10,d0
	bgt.w	check4benchExit
	clr.w	$28(a3)
	cmpi.w	#$4,$54(a3)
	bne.w	check4benchExit
	move.w	#$F800,$28(a3)
	move.w	#$2,$54(a3)
	move.w	#$FAC,d1
	bsr.w	SetSPA
	bset.b	#$5,$62(a3)
	move.w	#$64,$40(a3)
check4benchExit
	rts
; Sends the player to the bench: clears the speed and looks up the team struct
BenchGoToBench	clr.w	$6(a3)
	clr.w	d0
	move.b	$66(a3),d0
	add.w	d0,d0
	movea.l	#$1834C,a0
	btst.b	#$6,$62(a3)
	beq.w	.next
	adda.w	#$366,a0
.next	move.w	#$FFFE,$68(a0,d0.w)
	move.b	$61(a3),d3
	bsr.w	BenchSetAnimation
	jmp	(SetPlayerSide).l
; Walks the player towards the bench door
BenchWalkTarget	btst.b	#$2,$62(a3)
	bne.w	check4benchExit
	move.w	$44(a3),d0
	move.w	$46(a3),d1
	movea.l	#$33C6E,a0
	bra.w	skateto
; Inline bit and byte data used by the bench code
BenchFlagBits	dc.b	$08,$AB,$00,$02,$00,$63	; .....c
; Copies $60 to $34 and starts the animation
BenchSetAnimation	move.b	$60(a3),d0
	ext.w	d0
	move.w	d0,$34(a3)
	jsr	(Setplass).l
	st.b	$61(a3)
	st.b	$60(a3)
	rts
	btst.b	#$5,$62(a3)
	bne.w	check4benchExit
	bclr.b	#$1,$62(a3)
	beq.w	.next2
	clr.w	$28(a3)
	clr.w	$2A(a3)
	move.w	$52(a3),d0
	subi.w	#$6,d0
	bmi.w	.next
	addi.w	#$1,d0
.next	muls.w	#$E,d0
	move.w	d0,$14(a3)
	move.w	#$88,$0(a3)
	neg.w	$0(a3)
	move.w	#$2,$54(a3)
	bset.b	#$5,$62(a3)
	move.w	#$F6E,d1
	bra.w	SetSPA
.next2	move.w	#$4,$54(a3)
	bclr.b	#$2,$62(a3)
	bclr.b	#$5,$63(a3)
	bclr.b	#$2,$63(a3)
	clr.w	$58(a3)
	move.w	#$1000,$28(a3)
	bra.w	assexit
	btst.b	#$5,$62(a3)
	bne.w	check4benchExit
	bclr.b	#$1,$62(a3)
	beq.w	.next5
	bset.b	#$2,$63(a3)
	bsr.w	BenchControlledCheck
	moveq	#-2,d4
	bsr.w	setpads
	move.w	#$8,$42(a3)
	moveq	#$B,d0
	move.b	$18068.l,d1
	btst.b	#$6,$62(a3)
	bne.w	.next3
	lsr.w	#$4,d1
	neg.w	d0
.next3	andi.w	#$F,d1
	cmpi.w	#$2,d1
	bls.w	.next4
	moveq	#$2,d1
.next4	addq.w	#$3,d1
	muls.w	d0,d1
	move.w	d1,$46(a3)
	move.w	#$88,$44(a3)
	clr.w	$40(a3)
	bset.b	#$5,$63(a3)
	clr.w	$4E(a3)
	clr.w	$50(a3)
.next5	move.w	$14(a3),d0
	sub.w	$46(a3),d0
	cmpi.w	#$C,d0
	bgt.w	.next8
	cmpi.w	#$FFF4,d0
	blt.w	.next8
	move.w	$0(a3),d0
	sub.w	$44(a3),d0
	cmpi.w	#$FFE8,d0
	blt.w	.next8
	sub.w	d7,$40(a3)
	bpl.w	check4benchExit
	addi.w	#$8,$40(a3)
	bset.b	#$2,$62(a3)
	move.w	#$50C,d1
	bsr.w	SetSPA
	moveq	#$6,d2
	tst.b	$76(a3)
	beq.w	.next6
	moveq	#$2,d2
.next6	cmp.w	$54(a3),d2
	beq.w	.next7
	addi.w	#$1,$54(a3)
	andi.w	#$7,$54(a3)
.next7	clr.w	$2A(a3)
	move.w	#$1000,$28(a3)
	cmpi.w	#$FFF8,d0
	blt.w	check4benchExit
	clr.w	$28(a3)
	cmp.w	$54(a3),d2
	bne.w	check4benchExit
	bset.b	#$5,$62(a3)
	move.w	#$2,$54(a3)
	move.w	#$F6E,d1
	bsr.w	SetSPA
	bclr.b	#$4,$63(a3)
	moveq	#$D,d0
	bra.w	assreplace
.next8	move.w	$44(a3),d0
	move.w	$46(a3),d1
	movea.l	#$31AB6,a0
	bra.w	skateto
; Bench: checks the controlled player
BenchControlledCheck	btst.b	#$3,$62(a3)
	beq.w	check4benchExit
	clr.w	d4
	move.w	$52(a3),d0
	cmp.w	$17F9E.l,d0
	beq.w	PassToJump
	moveq	#$2,d4
	bra.w	PassToJump
assdopen						;add player a3 to penalty box
	btst	#$5,$62(a3)
	bne.w	check4benchExit
	moveq	#$10,d0
	btst	#$6,$62(a3)
	beq.w	.next
	moveq	#$1,d0
.next	add.b	d0,$18068.l
	st.b	$34(a3)
	clr.w	$6(a3)
	rts
assepen						;player a3 should exit penalty area
	btst	#$5,$62(a3)
	bne.w	check4benchExit
	bclr	#$1,$62(a3)
	beq.w	.nna
	bset	#$2,$62(a3)		;set player in no collision mode
	bset	#$2,$63(a3)		;set player unavailable
	moveq	#$10,d0
	moveq	#-60,d1
	btst	#$6,$62(a3)
	beq.w	.next
	moveq	#$1,d0
	neg.w	d1
.next	sub.b	d0,$18068.l
	move.w	d1,$14(a3)
	clr.w	$28(a3)
	clr.w	$2A(a3)
	move.w	#$86,$0(a3)
	move.w	#$2,$54(a3)
	bset	#$5,$62(a3)
	move.w	#$FAC,d1
	bsr.w	SetSPA
	jmp	(SprSort).l
.nna	move.w	#$4,$54(a3)
	st.b	$61(a3)
	st.b	$60(a3)
	bclr	#$3,$62(a3)
	bclr	#$2,$62(a3)
	bclr	#$5,$63(a3)		;pf2npc
	bclr	#$2,$63(a3)		;pf2unav
	move.w	#$F000,$28(a3)
	bra.w	assexit
assgoaliebreakwait						;asstab entry. In a shootout or penalty shot park the idle goalie off the
									;ice, else exit
	btst	#$5,$62(a3)		;check if animation locked
	bne.w	.exit		;exit if so
	btst	#$2,$17F70.l		;check if pen shot
	bne.w	.park		;branch if so
	btst	#$0,$17F78.l		;check for shootout
	bne.w	.park		;branch if so
	nop
	bra.w	assexit
.park	clr.w	$28(a3)		;clear Xvel
	clr.w	$2A(a3)		;clear Yvel
	movem.l	d0/a0,-(sp)		;push d0 and a0 on stack
	movea.l	#$17480,a0
	move.w	$1936A.l,d0
	asl.w	#$7,d0		;shift d0 7 bits left
	adda.w	d0,a0		;add d0 to address a0
	move.w	#$191,$14(a3)		;move 401 decimal into Ypos
	btst	#$7,$62(a0)		;check if shooting up or down (a0 is goalie being shot on)
	bne.w	.popstack		;branch if shooting up
	move.w	#$FE6F,$14(a3)		;move -191 decimal into Ypos (goalie not being shot on)
.popstack	movem.l	(sp)+,d0/a0
.exit	rts
assfaceoff						;players do nothing until faceoff is over
	btst	#$5,$62(a3)
	bne.w	assfaceoffExit
	btst	#$0,$17F6C.l
	beq.w	assexit
; Return of assfaceoff
assfaceoffExit	rts
assfaceoffpl						;Face off player
	btst	#$5,$62(a3)
	bne.w	assfaceoffExit
	btst	#$0,$17F6C.l
	beq.w	.exit
	bclr	#$1,$62(a3)
	beq.w	.next
	clr.w	$40(a3)
.next	movea.l	#$17CF8,a0
	btst	#$6,$62(a3)
	beq.w	.0
	adda.w	#$4,a0
.0	move.w	$5A(a3),d0		;d0 = SPAnum/4 + 1, +3 for right handed: frame code for the big sprite
	lsr.w	#$2,d0
	addi.w	#$1,d0
	tst.b	$76(a3)
	bne.w	.lefty
	addi.w	#$3,d0
.lefty	move.w	d0,(a0)
	btst	#$3,$62(a3)
	bne.w	check4benchExit
	bset	#$1,$63(a3)
	bne.w	check4benchExit
	move.w	#$FEA,d1
	cmpi.w	#$10,$17BC0.l
	bls.w	.d
	moveq	#$8,d0
	bsr.w	randomd0
	tst.w	d0
	beq.w	.d
	move.w	#$1014,d1
.d	bset	#$1,$63(a3)
	bra.w	SetSPA
.exit	move.b	#$14,$5E(a3)
	bra.w	assexit
	rts	
	rts	

donothing
	btst	#$5,$62(a3)
	bne.w	check4benchExit
	btst	#$3,$62(a3)
	bne.w	check4benchExit
	moveq	#$8,d0
	bra.w	doplayeracc
; AI target setup: flags 5 and 1 of $62
AssistTargetSetup	btst.b	#$5,$62(a3)
	bne.w	check4benchExit
	bclr.b	#$1,$62(a3)
	beq.w	.next2
	move.w	#$5A,$44(a3)
	tst.w	$17CEE.l
	bpl.w	.next
	neg.w	$44(a3)
.next	move.w	$17CEA.l,$46(a3)
	move.w	#$109E,d1
	bsr.w	SetSPA
.next2	move.w	$44(a3),d0
	sub.w	$0(a3),d0
	move.w	$46(a3),d1
	sub.w	$14(a3),d1
	bsr.w	vtoa
	cmpi.w	#$7,d0
	bgt.w	check4benchExit
	move.w	d0,d2
	move.w	d2,$54(a3)
	bra.w	playeracc
	btst.b	#$5,$62(a3)
	bne.w	check4benchExit
	bclr.b	#$1,$62(a3)
	beq.w	.next4
	bsr.w	AssistRandomTimer
	move.w	#$8,$42(a3)
	move.w	#$5A,$44(a3)
	tst.w	$17CEE.l
	bpl.w	.next3
	neg.w	$44(a3)
.next3	move.w	$17CEA.l,$46(a3)
.next4	movea.l	#$31AB6,a0
	move.w	$44(a3),d0
	move.w	$46(a3),d1
	btst.b	#$0,$17F78.l
	beq.w	.next7
	tst.w	$1AD72.l
	beq.w	.next5
	subi.w	#$1,$1AD72.l
	bne.w	.next5
	bset.b	#$2,$17F6C.l
.next5	cmpi.w	#$88,$0(a3)
	bgt.w	.next6
	cmpi.w	#$FF78,$0(a3)
	bgt.w	.next7
.next6	clr.w	d1
.next7	sub.w	d7,$40(a3)
	bpl.w	AssistSkateOrExit
	bset.b	#$5,$62(a3)
	move.w	#$E8A,d1
	move.w	$17E28.l,d0
	cmp.w	$52(a3),d0
	bne.w	.next8
	move.w	#$EFC,d1
.next8	bsr.w	SetSPA
; Sets a random timer (0 to $78) in $40
AssistRandomTimer	moveq	#$78,d0
	bsr.w	randomd0
	move.w	d0,$40(a3)
	rts
; Skates to the target or returns
AssistSkateOrExit	btst.b	#$3,$62(a3)
	beq.w	skateto
	rts
	btst.b	#$5,$62(a3)
	bne.w	check4benchExit
	btst.b	#$0,$17F68.l
	bne.w	donothing
	bsr.w	check4bench
	btst.b	#$3,$62(a3)
	bne.w	check4benchExit
	bclr.b	#$1,$62(a3)
	beq.w	.next
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
.next	sub.b	d7,$40(a3)
	bpl.w	.next5
	move.b	$6A(a3),$40(a3)
	jsr	(ReadGoaliePulled).l
	bmi.w	.next2
	btst.b	#$6,$17F7A.l
	beq.w	.next3
	tst.b	$40(a3)
	beq.w	.next3
.next2	subi.b	#$1,$40(a3)
.next3	moveq	#$2,d0
	btst.b	#$4,$32(a2)
	bne.w	assreplace
	move.w	$17B94.l,d1
	btst.b	#$7,$62(a3)
	bne.w	.next4
	neg.w	d1
.next4	cmpi.w	#$5D,d1
	blt.w	assreplace
	move.w	$17BE0.l,d1
	bmi.w	.next5
	subi.w	#$6,d1
	move.w	$52(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	bmi.w	assreplace
.next5	dc.w	$41FA,$1BCE		; lea.l X_33C6E(pc),a0
	moveq	#$50,d0
	cmpi.w	#$2,$34(a3)
	beq.w	.next6
	neg.w	d0
.next6	move.w	#$62,d1
	btst.b	#$7,$62(a3)
	bne.w	.next7
	neg.w	d0
	neg.w	d1
.next7	move.w	$17B80.l,d2
	eor.w	d0,d2
	bmi.w	.next8
	move.w	$17B80.l,d0
	bra.w	skateto
.next8	move.w	$17B80.l,d2
	asr.w	#$1,d2
	add.w	d2,d0
	bra.w	skateto
	btst.b	#$5,$62(a3)
	bne.w	check4benchExit
	btst.b	#$0,$17F68.l
	bne.w	donothing
	bsr.w	check4bench
	btst.b	#$3,$62(a3)
	bne.w	check4benchExit
	bclr.b	#$1,$62(a3)
	beq.w	.next9
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
.next9	sub.b	d7,$40(a3)
	bpl.w	.next22
	move.b	$6B(a3),$40(a3)
	btst.b	#$6,$17F7A.l
	beq.w	.next10
	tst.b	$40(a3)
	beq.w	.next10
	subi.b	#$1,$40(a3)
.next10	move.w	$17B94.l,d1
	move.w	$17BAA.l,d3
	asr.w	#$6,d3
	btst.b	#$7,$62(a3)
	bne.w	.next11
	neg.w	d1
	neg.w	d3
.next11	tst.w	d3
	bpl.w	.next12
	clr.w	d3
.next12	add.w	d1,d3
	cmpi.w	#$58,d3
	blt.w	.next13
	btst.b	#$4,$32(a2)
	bne.w	.next13
	move.w	$17BE0.l,d1
	bmi.w	.next13
	bsr.w	chkpk
	beq.w	.next13
	moveq	#$1,d0
	subi.w	#$6,d1
	move.w	$52(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	bpl.w	assreplace
.next13	move.w	#$41,$44(a3)
	cmpi.w	#$2,$34(a3)
	beq.w	.next14
	neg.w	$44(a3)
.next14	movea.l	#$17480,a0
	cmpi.w	#$6,$52(a3)
	bge.w	.next15
	adda.w	#$300,a0
.next15	moveq	#$5,d2
	move.w	#$FC18,d0
	btst.b	#$7,$62(a3)
	beq.w	.loop2
	neg.w	d0
.loop	btst.b	#$2,$63(a0)
	bne.w	.next17
	tst.w	$34(a0)
	bmi.w	.next17
	move.w	$2A(a0),d1
	bmi.w	.next16
	clr.w	d1
.next16	asr.w	#$4,d1
	add.w	$14(a0),d1
	cmp.w	d0,d1
	bgt.w	.next17
	move.w	d1,d0
.next17	adda.w	#$80,a0
	dbra	d2,.loop
	subi.w	#$32,d0
	cmpi.w	#$FF42,d0
	bgt.w	.next18
	move.w	#$FF24,d0
.next18	move.w	d0,$46(a3)
	move.w	$17B80.l,d0
	move.w	$44(a3),d1
	eor.w	d0,d1
	bpl.w	.next22
	clr.w	$44(a3)
	bra.w	.next22
.loop2	btst.b	#$2,$63(a0)
	bne.w	.next20
	tst.w	$34(a0)
	bmi.w	.next20
	move.w	$2A(a0),d1
	bpl.w	.next19
	clr.w	d1
.next19	asr.w	#$4,d1
	add.w	$14(a0),d1
	cmp.w	d0,d1
	blt.w	.next20
	move.w	d1,d0
.next20	adda.w	#$80,a0
	dbra	d2,.loop2
	addi.w	#$32,d0
	cmpi.w	#$BE,d0
	blt.w	.next21
	move.w	#$DC,d0
.next21	move.w	d0,$46(a3)
	neg.w	$44(a3)
	move.w	$17B80.l,d0
	move.w	$44(a3),d1
	eor.w	d0,d1
	bpl.w	.next22
	clr.w	$44(a3)
.next22	move.w	$44(a3),d0
	move.w	$46(a3),d1
	movea.l	#$33C6E,a0
	bsr.w	skateto
	bra.w	CheckCheckerSet
.loop3	rts
	btst.b	#$5,$62(a3)
	bne.w	.loop3
	btst.b	#$0,$17F68.l
	bne.w	donothing
	bsr.w	check4bench
	btst.b	#$3,$62(a3)
	bne.w	.loop3
	bclr.b	#$1,$62(a3)
	beq.w	.next23
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
.next23	sub.b	d7,$40(a3)
	bpl.w	.next25
	move.b	$6B(a3),$40(a3)
	btst.b	#$6,$17F7A.l
	beq.w	.next24
	tst.b	$40(a3)
	beq.w	.next24
	subi.b	#$1,$40(a3)
.next24	move.w	$17BE0.l,d1
	bmi.w	.next25
	moveq	#$4,d0
	subi.w	#$6,d1
	move.w	$52(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	bpl.w	assreplace
.next25	moveq	#$64,d0
	cmpi.w	#$5,$34(a3)
	bne.w	.next26
	neg.w	d0
.next26	move.l	#$9E,d1
	btst.b	#$7,$62(a3)
	beq.w	.next28
	neg.w	d0
	neg.w	d1
	moveq	#-78,d2
	btst.b	#$4,$32(a2)
	bne.w	.next30
	cmp.w	$17B94.l,d2
	bgt.w	.next27
	move.w	$17B94.l,d1
	bra.w	.next31
.next27	move.w	#$FEF8,d2
	cmp.w	$17B94.l,d2
	blt.w	.next31
	move.w	d2,d1
	bra.w	.next31
.next28	moveq	#$4E,d2
	btst.b	#$4,$32(a2)
	bne.w	.next30
	cmp.w	$17B94.l,d2
	blt.w	.next29
	move.w	$17B94.l,d1
	bra.w	.next31
.next29	move.w	#$108,d2
	cmp.w	$17B94.l,d2
	bgt.w	.next31
.next30	move.w	d2,d1
.next31	lea.l	$322B0.l,a0
	move.w	$17B80.l,d2
	eor.w	d0,d2
	bmi.w	skateto
	move.w	$17B80.l,d0
	bra.w	skateto
	btst.b	#$5,$62(a3)
	bne.w	.loop3
	btst.b	#$0,$17F68.l
	bne.w	donothing
	bsr.w	check4bench
	btst.b	#$3,$62(a3)
	bne.w	.loop3
	bclr.b	#$1,$62(a3)
	beq.w	.next32
	st.b	$48(a3)
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
.next32	sub.b	d7,$40(a3)
	bpl.w	AssistTargetFlip
	move.b	$6B(a3),$40(a3)
	btst.b	#$6,$17F7A.l
	beq.w	.next33
	tst.b	$40(a3)
	beq.w	.next33
	subi.b	#$1,$40(a3)
.next33	moveq	#$3,d0
	move.w	$17BE0.l,d1
	bmi.w	.next34
	subi.w	#$6,d1
	move.w	$52(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	bmi.w	assreplace
.next34	move.w	$17B94.l,d0
	move.w	$17BAA.l,d3
	asr.w	#$6,d3
	add.w	d0,d3
	btst.b	#$7,$62(a3)
	bne.w	.next35
	neg.w	d0
	neg.w	d3
.next35	clr.w	d2
	cmpi.w	#$FFA8,d3
	blt.w	.next36
	addi.w	#$8,d2
	cmpi.w	#$58,d0
	blt.w	.next36
	btst.b	#$4,$32(a2)
	bne.w	.next36
	addi.w	#$8,d2
	cmpi.w	#$108,d3
	blt.w	.next36
	addi.w	#$8,d2
.next36	cmp.w	$48(a3),d2
	bne.w	.next37
.loop4	btst.b	#$7,$FF800E.l
	bne.s	.loop4
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop5	btst.b	#$6,$FF800E.l
	beq.s	.loop5
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	bne.s	.loop6
	bclr.b	#$7,$FF800F.l
	andi.w	#$7F,d0
	bne.w	AssistTargetFlip
.next37	move.w	d2,$48(a3)
	lea.l	AssistLimitsTable(pc),a0
	move.w	$2(a0,d2.w),d0
	bsr.w	randomd0s
	add.w	(a0,d2.w),d0
	move.w	d0,$44(a3)
	move.w	$6(a0,d2.w),d0
	bsr.w	randomd0s
	add.w	$4(a0,d2.w),d0
	move.w	d0,$46(a3)
	bra.w	AssistTargetFlip
; Word table of position limits
AssistLimitsTable	dc.b	$00,$50,$00,$14,$FF,$BA,$00,$0A,$00,$64,$00,$14,$00,$3A,$00,$05	; .P.......d...:..
	dc.b	$00,$3C,$00,$32,$00,$E6,$00,$14,$00,$50,$00,$1E,$00,$FA,$00,$14	; .<.2.....P......
; Mirrors the target x for the side
AssistTargetFlip	move.w	$44(a3),d0
	cmpi.w	#$5,$34(a3)
	beq.w	.next
	neg.w	d0
.next	move.w	$46(a3),d1
	btst.b	#$7,$62(a3)
	bne.w	.next2
	neg.w	d0
	neg.w	d1
; Instruction bytes inside AssistTargetFlip that the assembler would encode differently, kept as words (1 row).
.next2	dc.w	$41FA,$1700
	bra.w	skateto
.loop	rts
	btst.b	#$5,$62(a3)
	bne.w	.loop
	btst.b	#$0,$17F68.l
	bne.w	donothing
	bsr.w	check4bench
	btst.b	#$3,$62(a3)
	bne.w	.loop
	bclr.b	#$1,$62(a3)
	beq.w	.next3
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
.next3	sub.b	d7,$40(a3)
	bpl.w	.next5
	move.b	$6B(a3),$40(a3)
	btst.b	#$6,$17F7A.l
	beq.w	.next4
	tst.b	$40(a3)
	beq.w	.next4
	subi.b	#$1,$40(a3)
.next4	move.w	$17BE0.l,d1
	bmi.w	.next5
	moveq	#$6,d0
	subi.w	#$6,d1
	move.w	$52(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	bpl.w	assreplace
.next5	move.w	$17B80.l,d0
	asr.w	#$1,d0
	move.w	$17B94.l,d2
	btst.b	#$7,$62(a3)
	bne.w	.next6
	neg.w	d2
.next6	moveq	#-128,d1
	cmpi.w	#$FFA8,d2
	blt.w	.next7
	add.w	$17B94.l,d1
	asr.w	#$1,d1
.next7	btst.b	#$7,$62(a3)
	bne.w	.next8
	neg.w	d1
.next8	lea.l	$32574.l,a0
	bra.w	skateto
	btst.b	#$5,$62(a3)
	bne.w	.loop
	btst.b	#$0,$17F68.l
	bne.w	donothing
	bsr.w	check4bench
	btst.b	#$3,$62(a3)
	bne.w	.loop
	bclr.b	#$1,$62(a3)
	beq.w	.next9
	st.b	$48(a3)
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
.next9	sub.b	d7,$40(a3)
	bpl.w	AssistTargetFlipGoalie
	move.b	$6B(a3),$40(a3)
	btst.b	#$6,$17F7A.l
	beq.w	.next10
	tst.b	$40(a3)
	beq.w	.next10
	subi.b	#$1,$40(a3)
.next10	move.w	$17BE0.l,d1
	bmi.w	.next11
	moveq	#$5,d0
	subi.w	#$6,d1
	move.w	$52(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	bmi.w	assreplace
.next11	move.w	$17B94.l,d0
	btst.b	#$7,$62(a3)
	bne.w	.next12
	neg.w	d0
.next12	clr.w	d2
	cmpi.w	#$FFA8,d0
	blt.w	.next13
	addi.w	#$8,d2
	cmpi.w	#$58,d0
	blt.w	.next13
	btst.b	#$4,$32(a2)
	bne.w	.next13
	addi.w	#$8,d2
	cmpi.w	#$108,d0
	blt.w	.next13
	addi.w	#$8,d2
.next13	cmp.w	$48(a3),d2
	bne.w	.next14
.loop2	btst.b	#$7,$FF800E.l
	bne.s	.loop2
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	beq.s	.loop3
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop4	btst.b	#$6,$FF800E.l
	bne.s	.loop4
	bclr.b	#$7,$FF800F.l
	andi.w	#$7F,d0
	bne.w	AssistTargetFlipGoalie
.next14	move.w	d2,$48(a3)
	lea.l	AssistLimitsTableGoalie(pc),a0
	move.w	$2(a0,d2.w),d0
	bsr.w	randomd0s
	add.w	(a0,d2.w),d0
	move.w	d0,$44(a3)
	move.w	$6(a0,d2.w),d0
	bsr.w	randomd0s
	add.w	$4(a0,d2.w),d0
	move.w	d0,$46(a3)
	bra.w	AssistTargetFlipGoalie
; Word table of position limits for the goalie
AssistLimitsTableGoalie	dc.b	$00,$00,$00,$3C,$FF,$BA,$00,$0A,$00,$00,$00,$3C,$00,$3C,$00,$0A	; ...<.......<.<..
	dc.b	$00,$00,$00,$28,$00,$AA,$00,$1E,$00,$00,$00,$50,$00,$AA,$00,$14	; ...(.......P....
; Mirrors the target for the goalie
AssistTargetFlipGoalie	move.w	$44(a3),d0
	move.w	$46(a3),d1
	btst.b	#$7,$62(a3)
	bne.w	.next
	neg.w	d1
; Instruction bytes inside AssistTargetFlipGoalie that the assembler would encode differently, kept as words (1 row).
.next	dc.w	$41FA,$14B6
	bra.w	skateto
assgoaliectrl						;joypad controlled goalie control: a3 = goalie; a goalie not on the
									;joystick leaves through assexit
	btst	#$3,$62(a3)		;is player joystick controlled?
	bne.w	.goaliectrl		;branch is so
	bra.w	assexit
.goaliectrl	btst	#$1,$62(a3)		;check if new assignment
	bne.w	.na		;branch if new assignment
	movem.w	d0-d1,-(sp)		;push to stack
	move.w	$0(a3),d0		;Xpos
	move.w	$14(a3),d1		;Ypos
	cmpi.w	#$AA,d1		;compare $AA to Ypos
	bgt.w	.next
	cmpi.w	#$FF56,d1		;check -$AA to Ypos
	blt.w	.next		;branch if less than
	btst	#$0,$17F68.l		;check if clock stopped
	bne.w	.next		;branch if so
	move.w	d0,-(sp)		;push to stack
	move.w	#$8,d0		;clock stoppage due to goalie out of range
	jsr	(AddPenalty2).l
	move.w	(sp)+,d0
.next	sub.w	$17CEE.l,d0
	sub.w	$17CEA.l,d1
	bclr	#$2,$64(a3)		;clear goalie control bit?
	cmpi.w	#$74,d0		;compare $74 to Xpos diff
	blt.w	.0		;branch if less than
	bset	#$2,$64(a3)		;set goalie control bit?
	bra.w	.cont2
.0	cmpi.w	#$FF8C,d0		;compare -$74 to Xpos diff
	bgt.w	.1		;branch if greater than
	bset	#$2,$64(a3)		;set goalie control bit?
	bra.w	.cont2
.1	cmpi.w	#$64,d1		;compare $64 to Ypos diff
	blt.w	.2		;branch if less than
	bset	#$2,$64(a3)		;set goalie control bit?
	bra.w	.cont2
.2	cmpi.w	#$FF9C,d1		;compare -$64 to Ypos diff
	bgt.w	.cont2		;branch if greater than
	bset	#$2,$64(a3)		;set goalie control bit?
.cont2	movem.w	(sp)+,d0-d1		;pop from stack
	btst	#$2,$64(a3)		;check goalie ctrl bit
	bne.w	checkanimFlags		;branch if set
.na	btst	#$5,$62(a3)		;check if anim lock
	bne.w	check4benchExit		;exit if so
	bsr.w	check4bench
	bclr	#$1,$62(a3)		;clear new assignment bit
	beq.w	.nna		;branch if already cleared
	clr.w	$40(a3)		;clear temp1
	move.w	#$8,$42(a3)		;move 8 into temp2
	st.b	$46(a3)		;FFFF to temp4
.nna	btst	#$1,$63(a3)		;check if anim in progress
	bne.w	.ex		;exit if so
	btst	#$0,$17F68.l		;check if clock stopped
	bne.w	check4benchExit		;exit if so
	tst.w	$48(a3)		;test temp5
	bmi.w	.nofo		;branch if less than 0
	move.w	$52(a3),d0		;move SCnum into d0
	cmp.w	$17BE0.l,d0		;check if puckc is goalie
	beq.w	.mbfo		;branch if equal
	st.b	$48(a3)		;set temp5 to -1
	bra.w	.nofo
.mbfo	sub.w	d7,$48(a3)		;subtract d7(frames elapsed) from temp5
	bpl.w	.nofo		;branch if more than 0
	btst	#$2,$17F70.l		;check bit 2
	beq.w	.next2		;branch if not set
	bset	#$4,$17F70.l
	bra.w	.nofo
.next2	moveq	#$8,d0
	bsr.w	AddPenalty2
.nofo	sub.b	d7,$40(a3)		;sub d7(frames elapsed) from temp1
	bpl.w	.ex		;branch if positive
	move.b	$6B(a3),d0		;DfA into d0
	beq.w	.3		;branch if value was 0
	btst	#$6,$17F7A.l		;check if crowd meter broken
	beq.w	.3		;jump if not
	subi.b	#$1,d0		;sub 1 from d0
.3	lsr.b	#$2,d0		;divide by 4
	move.b	d0,$40(a3)		;move d0 into temp1
	move.w	$52(a3),d0		;move SCnum into d0
	cmp.w	$17BE0.l,d0		;compare puckc to d0
	beq.w	.ex		;jump to assgoaliecpu if the same
.ex	rts
checkanim
	btst	#$3,$62(a3)
	bne.w	assgoaliectrl

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
	jsr	(AdjustFacingDirectionStep).l
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
	dc.w	$033C,$0042,$6700		; btst.l d1,#$426700
	dc.w	$0022,$D240		; ori.b #$40,-(a2)
	btst	#$7,$62(a3)
	dc.w	$6600,$000A		; bne.w .l18094
	dc.w	$033C,$0083,$6000		; btst.l d1,#$836000
	dc.w	$0006,$033C		; ori.b #$3C,d6
	dc.w	$0038,$6700,$0008		; ori.b #$0,$8.w
	neg.w	d0		;in the mask: undo it and turn the other way instead
	add.w	d0,d1
.add	add.w	d0,d1		;apply the step
	andi.w	#$7,d1		;wrap to 0-7
	move.w	d1,$54(a3)		;facedir
	rts
; Computes the facing step from the position difference.
AdjustFacingDirectionStep
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
; Table of 10 words after AdjustFacingDirection, 20 bytes: $0146,$0178,$0250,$02A2,$01EC,$021E ...
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
.soshot	jsr	(NextPathPointCheck).l
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
.path	jsr	(NextPathPointStep).l
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
; Table of 123 words after asspuckc, 246 bytes: $4880,$142B,$0028,$4882,$D479,$0001 ...
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
; Table of 2 words after chk4lc, 4 bytes: $FF9C,$FFEC ...
	dc.w	$FF9C
	dc.w	$FFEC
	ori.w	#$FFEC,-(a4)
; Instruction bytes inside chk4lc that the assembler would encode differently, kept as words (1 row).
	dc.w	$FF88
	ori.b	#$14,$28(a0)
	ori.w	#$28,$FFFFFFEC.w
	dc.w	$0028,$FFD8,$00F0		; ori.b #$D8,$F0(a0)
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

; Checks the puck holder and waits for DMA.
CheckPuckHolder2
	bsr.w	chkpk
	bne.w	CheckPuckHolder2Random
	tst.w	$17E34.l
	beq.w	CheckPuckHolder2Random
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
	bne.w	CheckPuckHolder2Random
	move.w	#$58,d0
	btst	#$7,$62(a3)
	beq.w	.next
	move.w	#$FFA8,d0
	cmp.w	$14(a3),d0
	blt.w	CompShoot
	bra.w	.next2
.next	cmp.w	$14(a3),d0
	bgt.w	CompShoot
.next2	bset	#$3,$17F74.l
	jmp	(dopass).l
	bra.w	CompShoot
; Random check ($1E) when flag 1 of $64 is set
CheckPuckHolder2Random
	btst	#$1,$64(a3)
	beq.w	.next2
	move.w	#$1E,d0
	jsr	(randomd0).l
	addi.w	#$82,d0
	cmp.w	$17B94.l,d0
	blt.w	.next
	neg.w	d0
	cmp.w	$17B94.l,d0
	bgt.w	.next
	bra.w	.next2
.next	move.w	#$2,d0
	jsr	(randomd0s).l
	add.w	$54(a3),d0
	andi.w	#$7,d0
	move.w	d0,$54(a3)
	bra.w	CompShoot
.next2	moveq	#$20,d4
	clr.w	d1
	move.b	$70(a3),d1
	lsr.w	#$1,d1
	sub.b	d1,d4
	asl.w	#$4,d4
	move.w	#$108,d1
	btst	#$7,$62(a3)
	bne.w	.next3
	neg.w	d1
.next3	sub.w	$17B94.l,d1
	move.w	$17B80.l,d0
	neg.w	d0
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d0,d1
	cmpi.l	#$2710,d1
	movem.w	(sp)+,d0-d1
	bhi.w	.next6
	lsr.w	#$4,d4
	bsr.w	vtoa
	move.w	d0,d5
	moveq	#$5,d3
	movea.l	#$17480,a1
	cmpi.w	#$6,$52(a3)
	bge.w	.loop
	adda.w	#$300,a1
.loop	tst.w	$34(a1)
	beq.w	.next4
	move.w	$0(a1),d0
	sub.w	$17B80.l,d0
	move.w	$14(a1),d1
	sub.w	$17B94.l,d1
	bsr.w	vtoa
	cmp.w	d5,d0
	bne.w	.next5
	asl.w	#$1,d4
	bra.w	.next5
.next4	btst	#$1,$63(a1)
	beq.w	.next5
	clr.w	d3
	moveq	#$1,d4
.next5	adda.w	#$80,a1
	dbra	d3,.loop
.next6	move.w	d4,d0
	bsr.w	randomd0
	btst	#$0,$70(a3)
	beq.w	.next7
	cmpi.w	#$7,d0
	bgt.w	check4benchExit
	bra.w	.next8
.next7	cmpi.w	#$8,d0
	bgt.w	check4benchExit
.next8	move.w	$17B94.l,d0
	btst	#$7,$62(a3)
	bne.w	.next9
	neg.w	d0
.next9	tst.w	d0
	bmi.w	check4benchExit
	move.w	#$108,d1
	sub.w	d0,d1
	bmi.w	check4benchExit
	btst	#$7,$17F6C.l
	bne.w	check4benchExit
CompShoot						;computer shot: drop the return address and aim from the puck's distance
									;to the goal line
	adda.w	#$4,sp
	move.w	$17B94.l,d0
	btst	#$7,$62(a3)
	bne.w	.ds0
	neg.w	d0
.ds0	move.w	#$108,d1		;d0 is now puck y toward the goal I shoot at
	sub.w	d0,d1		;d1 = distance to $108 along the shooting direction
	lsr.w	#$3,d1
	cmpi.w	#$14,d1
	blt.w	.0
	moveq	#$14,d1
.0	move.w	d1,$42(a3)
	moveq	#$12,d0
	bra.w	assreplace
chk4pass						;player a3 looks for good pass (computer controlled)
	tst.w	$17E34.l
	bne.w	.dp0		;an opponent is close: always consider a pass
	moveq	#$10,d0
	add.b	$70(a3),d0
	bsr.w	randomd0		;0 <= d0 < $10 + odds
	cmpi.w	#$C,d0
	bgt.w	check4benchExit
.dp0	moveq	#$6,d0		;Set up pass assignment
	bsr.w	randomd0		;d0 = random teammate index 0-5
	cmpi.w	#$6,$52(a3)
	blt.w	.0
	addi.w	#$6,d0
.0	tst.w	$34(a3)
	beq.w	.1
	cmpi.w	#$28,$17B80.l
	bgt.w	.1
	cmpi.w	#$FFD8,$17B80.l
	blt.w	.1
	cmpi.w	#$CC,$17B94.l
	bgt.w	check4benchExit
	cmpi.w	#$FF34,$17B94.l
	blt.w	check4benchExit
.1	cmp.w	$52(a3),d0
	beq.w	check4benchExit
	asl.w	#$7,d0		;d0 * SCstruct ($80)
	movea.l	#$17480,a0
	adda.w	d0,a0		;a0 = receiver sort object
	tst.w	$34(a0)
	ble.w	check4benchExit
	btst	#$2,$63(a0)
	bne.w	check4benchExit
	btst	#$5,$62(a0)
	bne.w	check4benchExit
	move.w	$14(a0),d0		;check for pass across blue line
	move.w	$14(a3),d1		;d0 = receiver y, d1 = my y (toward the goal I shoot at)
	btst	#$7,$62(a3)
	bne.w	.f0
	neg.w	d0
	neg.w	d1
.f0	btst	#$5,$17F68.l		;offsides on?
	beq.w	.oko
	movem.w	d0-d1,-(sp)
	subi.w	#$58,d0		;y relative to the blue line
	subi.w	#$58,d1
	eor.w	d0,d1		;sign differs if the pass crosses the blue line
	movem.w	(sp)+,d0-d1
	bmi.w	check4benchExit
.oko	cmpi.w	#$58,d0
	bgt.w	.ok
	sub.w	d1,d0
	cmpi.w	#$FFF1,d0
	blt.w	check4benchExit
.ok	move.w	$0(a0),d0		;receiver accepted: get the pass direction
	sub.w	$17B80.l,d0
	move.w	$14(a0),d1
	sub.w	$17B94.l,d1
	movem.w	d0-d1,-(sp)
	bsr.w	vtoa
	move.w	d0,$17E2C.l
	movem.w	(sp)+,d1-d2
	muls.w	d1,d1
	muls.w	d2,d2
	add.l	d1,d2		;d2 = squared distance to the receiver
	moveq	#$5,d3
	movea.l	#$17480,a1
	cmpi.w	#$6,$52(a3)
	bge.w	.co0
	adda.w	#$300,a1		;loop over the 6 opponents
.co0	move.w	$0(a1),d0		;next opponent: is he in the pass lane?
	sub.w	$17B80.l,d0
	move.w	$14(a1),d1
	sub.w	$17B94.l,d1
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d0,d1		;d1 = squared distance to this opponent
	cmp.l	d2,d1
	movem.w	(sp)+,d0-d1
	bhi.w	.next		;farther than the receiver: ignore
	bsr.w	vtoa
	cmp.w	$17E2C.l,d0
	beq.w	check4benchExit
.next	adda.w	#$80,a1
	dbra	d3,.co0
	bsr.w	dopass		;lane is clear: pass in passdir
	tst.w	$34(a3)
	beq.w	check4benchExit
	adda.w	#$4,sp
	bra.w	assexit
; Table of 88 words after chk4pass, 176 bytes: $4A79,$0001,$7BE0,$6B00,$DE40,$142B ...
	dc.w	$4A79,$0001,$7BE0,$6B00,$DE40,$142B,$0028,$9439
	dc.w	$0001,$7BA8,$4882,$D46B,$0000,$9479,$0001,$7B80
	dc.w	$0C42,$0028,$6E00,$DE22,$0C42,$FFD8,$6D00,$DE1A
	dc.w	$122B,$002A,$9239,$0001,$7BAA,$4881,$D26B,$0014
	dc.w	$9279,$0001,$7B94,$0C41,$0028,$6E00,$DDFC,$0C41
	dc.w	$FFD8,$6D00,$DDF4,$302B,$0000,$9079,$0001,$7B80
	dc.w	$322B,$0014,$9279,$0001,$7B94,$6100,$261E,$0839
	dc.w	$0005,$0001,$7F68,$6700,$0038,$322B,$0014,$082B
	dc.w	$0007,$0062,$6600,$0004,$4441,$0441,$0058,$0C41
	dc.w	$000A,$6E00,$001C,$0C41,$FFCE,$6D00,$0014,$7002
	dc.w	$322B,$0000,$B279,$0001,$7B80,$6E00,$0004,$7006
	rts
checkob						;bring up little warning ref if a player on your team is over blue line
	btst	#$5,$17F68.l
	beq.w	check4benchExit
	btst	#$2,$17F70.l
	bne.w	.ex
	movem.l	d0-d1/a0,-(sp)
	moveq	#$5,d0		;6 players of a3's team
	movea.l	#$17480,a0
	cmpi.w	#$6,$52(a3)
	blt.w	.0
	adda.w	#$300,a0		;a0 = first sort object of a3's team
.0	moveq	#$5C,d1
	btst	#$7,$62(a3)
	bne.w	.next2		;shooting at the top goal: mirrored tests below
	neg.w	d1		;d1 = -$5C
	cmp.w	$17B94.l,d1
	bgt.w	.nob		;puck already across the line: nobody can be offside
.bottom	tst.w	$34(a0)		;loop over the team, skipping negative positions
	bmi.w	.bn
	cmp.w	$14(a0),d1
	bgt.w	.ob		;this player is over the line
.bn	adda.w	#$80,a0
	dbra	d0,.bottom
.nob	moveq	#$40,d0		;no one offside: d0 = $40 = clear the ref window (PushRef)
	bclr	#$7,$17F6C.l		;clear the offsides ref flag
	bne.w	.next		;it was on: update the ref
.loop	movem.l	(sp)+,d0-d1/a0
.ex	rts
.ob	moveq	#$6,d0
	bset	#$7,$17F6C.l		;someone is offsides: show the little ref
	bne.w	.loop		;already shown
.next	tst.w	$1806E.l
	bpl.w	.loop
	bsr.w	PushRef
	bra.w	.loop
.next2	cmp.w	$17B94.l,d1
	blt.w	.nob
.top1	tst.w	$34(a0)		;loop over the team's players (top goal)
	bmi.w	.tn
	cmp.w	$14(a0),d1
	blt.w	.ob
.tn	adda.w	#$80,a0		;next player
	dbra	d0,.top1
	bra.w	.nob
assbreakaway						;assignment for a breakaway: the puck carrier skates in, anyone else goes
									;back to assnearest
	move.w	$52(a3),d0		;Move SCnum into d0
	cmp.w	$17BE0.l,d0		;compare puck carrier SCnum with d0
	beq.w	assnearest		;branch if puck carrier
; Clears the breakaway flag and replaces the assist
assbreakawayStart	bclr	#$1,$64(a3)		;clear breakaway bit
	move.w	#$11,d0		;11 - assnearest
	bsr.w	assreplace
	bra.w	assnearestCheck
assnearest						;this is a special assignment used for the player who is nearest the puck
									;but doesn't have it. Assignment anearest ($11)
									;a2 = a3's team struct, d7 = elapsed frames. temp1 = re-evaluation timer,
									;temp3 = hold timer
	jsr	(breakaway).l
	bmi.w	assbreakawayStart
; assnearest: tests the nearest flag and the puck holder
assnearestCheck	bclr	#$2,$17F74.l
	bne.w	.chkpuck
	bclr	#$1,$64(a3)		;clear breakaway bit
.chkpuck	move.w	$52(a3),d0		;move SCnum into d0
	cmp.w	$17BE0.l,d0		;compare with puck carrier SCnum
	bne.w	.chkbreak		;jump if not puck carrier
	btst	#$1,$64(a3)		;check breakaway bit
	bne.w	.chkbreak		;jump if set
	btst	#$2,$17F70.l		;check if bit 2 set (cleared on Faceoffs)
	bne.w	.chkbreak		;jump if set
	jsr	(BreakawayOffsidesFlagSet).l
	beq.w	.chkbreak
	move.w	#$22,d0		;22 - assbreakaway if flag set
	bsr.w	assreplace		;assreplace with assbreakaway
	bra.w	.chkbreak
.chkbreak	bclr	#$1,$62(a3)		;pfna - clear new assignment
	beq.w	.nna
	btst	#$1,$64(a3)		;check if breakaway
	beq.w	.chkbreak2		;jump if not
	move.w	#$2,-(sp)		;ding SFX
	jsr	(sfx).l
.chkbreak2	btst	#$1,$64(a3)		;check if breakaway
	beq.w	.nobreak		;jump if not
	movem.l	a2,-(sp)		;push a2 to stack
	movea.l	#tmstruct,a2		;put Home Team Struct into a2
	btst	#$6,$62(a3)		;pfteam - check home or away
	beq.w	.addcrowd		;jump if home
	movea.l	#awtmstruct,a2		;put Away Team Struct into a2
.addcrowd	addi.w	#$1,$35A(a2)		;add to breakaway attempt
	addi.w	#$14,$17CD8.l
	addi.w	#$C8,(Crowdlevel).l		;add to crowd level
	movem.l	(sp)+,a2		;pop off stack into a2
.nobreak	clr.w	$44(a3)		;clear temp3
	move.w	#$8,$42(a3)		;move 8 into temp2
	clr.w	$40(a3)		;clear temp1
.nna	move.w	$52(a3),d1		;checks if puck carrier
	cmp.w	$17BE0.l,d1
	bne.w	.nopc		;jumps if not
	tst.w	$34(a3)		;check if goalie
	beq.w	checkanim		;branch if goalie
	moveq	#$10,d0
	btst	#$3,$62(a3)		;pfjoycon - check if controlled
	beq.w	AssistListPush		;jump if not
	rts		;human controlled: leave as is
.nopc	sub.b	d7,$40(a3)		;subtract d7 (elapsed frames) from temp1
	bpl.w	.nodec		;jump if positive
	move.b	$6A(a3),$40(a3)		;move aioff into temp1
	jsr	(ReadGoaliePulled).l		;check if goalie is pulled
	bmi.w	.bonus
	btst	#$6,$17F7A.l		;check if crowd meter currently broken
	beq.w	.nopc2		;jump if not broken
	tst.b	$40(a3)		;check if temp1 is 0
	beq.w	.nopc2		;jump if so
.bonus	subi.b	#$1,$40(a3)		;subtract 1 from temp1
.nopc2	btst	#$5,(sflags6).l		;check if slot bit is set (puckc in slot)
	beq.w	.nopc3		;branch if not set
	move.w	$17BE0.l,d1		;move puck carrier SCnum
	cmpi.w	#$5,d1		;check if its home (5 or less) or away (6-11)
	bgt.w	.pcaway		;jump if away
	btst	#$6,$62(a3)		;pfteam
	beq.w	.nopc3		;jump if home
.tmnopc	move.b	$40(a3),d1		;temp1 into d1
	ext.w	d1		;extend d1
	asr.w	#$1,d1		;divide by 2
	move.b	d1,$40(a3)		;move d1 into temp1 - cutting the timer in half
	bne.w	.nopc3		;jump if not zero
	move.b	#$1,$40(a3)		;move 1 into temp1
	bra.w	.nopc3
.pcaway	btst	#$6,$62(a3)		;pfteam - 0 home, 1 away
	beq.w	.tmnopc		;jump if home
.nopc3	clr.l	$2C(a2)		;no nearest skater yet
	move.w	$17BE0.l,d1		;move puck carrier SCnum into d1
	bmi.w	.np		;branch if no puck carrier
	asl.w	#$7,d1		;scsize
	movea.l	#$17480,a1
	adda.w	d1,a1		;use d1 as offset
	move.b	$62(a1),d0		;pflags of puck carrier
	move.b	$62(a3),d1		;pflags of current player
	eor.b	d0,d1		;XOR pflags
	btst	#$6,d1		;check pfteam
	beq.w	.switch		;branch if on same team
.np	moveq	#-1,d2		;-1
	moveq	#$5,d4		;5 = # of players on team
	movea.l	$22(a2),a0		;SortCord start value for team
.de0	tst.w	$34(a0)		;check if goalie
	ble.w	.next		;branch if goalie
	tst.b	$5E(a0)		;check if nopuck (cant touch puck)
	bne.w	.next		;branch if nopuck timer not 0
	btst	#$2,$63(a0)		;pf2unav - unavailable
	bne.w	.next		;branch if unavailable
	move.w	$36(a0),d0		;assnum - current assignment
	cmpi.b	#$13,$38(a0,d0.w)		;check if current assignment is asspassrec
	beq.w	.next		;branch if a0 is going to receive puck
	move.l	a0,-(sp)		;push onto stack
	bsr.w	GetHotCount		;get hot spot
	add.w	$0(a0),d0		;Xpos to d0
	sub.w	$17B80.l,d0
	add.w	$14(a0),d1
	sub.w	$17B94.l,d1
	move.w	$17BA8.l,d3
	asr.w	#$6,d3
	sub.w	d3,d0
	move.w	$17BAA.l,d3
	asr.w	#$6,d3		;divide by 64
	sub.w	d3,d1		;sub d3 from d1 (Y distance between player and puck)
	muls.w	d0,d0		;square d0
	muls.w	d1,d1		;square d1
	add.l	d1,d0		;add d1 to d0
	cmp.l	d2,d0		;compare d2 to d0
	bhi.w	.next		;branch if d0 higher than d2 (0 or a positive # first run)
	move.l	d0,d2		;move d0 into d2
	movea.l	a0,a1		;move a0 address into a1
.next	adda.w	#$80,a0		;SCstruct size
	dbra	d4,.de0
	tst.l	d2		;check if 0
	bmi.w	.de1		;branch if less (no one near puck)
	move.l	d2,$2C(a2)		;nearest skater's distance^2 to the puck
.switch	cmpa.l	a1,a3		;a1 = closest to the puck, or puckc (if on same team)
	beq.w	.de1		;branch if same
	btst	#$0,$17F68.l		;gmclock - 1 if stopped
	bne.w	.de1		;jump if stopped
	btst	#$2,$63(a1)		;pf2unav
	bne.w	.de1		;jump if unavailable
	btst	#$3,$64(a1)		;shooting one timer
	bne.w	.de1		;jump if shooting
	exg.l	a1,a3		;swap addresses
	bclr	#$0,$62(a3)		;clear pfdoff
	moveq	#$11,d0
	bsr.w	AssistListPush		;... and give him the assnearest assignment
	exg.l	a1,a3
	bra.w	assexit		;I (old a3) drop this assignment
.de1	btst	#$5,$62(a3)		;pfalock - check if locked in animation
	bne.w	check4benchExit		;exit if locked
	moveq	#$2,d1		;move 2 into d1
	cmpi.w	#$190,d2		;compare $190 (20^2) to d2. d2 = distance to puck^2
	bhi.w	.nfar		;branch if d2 higher
	subi.w	#$2,d1		;close: d1 = 0
	cmpi.w	#$2,$34(a3)		;compare if position is F or D (1 and 2 are D)
	bls.w	.nodec		;jump if D
.nfar	btst	#$5,$17F6C.l		;sf2pwrplay - check if PP
	beq.w	.next2		;branch if no PP
	subi.w	#$2,d1		;sub 2 from d1
	bsr.w	chkpk2
	bne.w	.next2		;branch if on PK
	addi.w	#$4,d1		;add 4 to d1
.next2	moveq	#$28,d0
	sub.b	$75(a3),d0		;sub checking from d0
	asl.w	d1,d0		;shift d0 by value of d1
	bsr.w	randomd0		;RNG
	cmpi.w	#$2,d0		;compare 2 to d0
	bhi.w	.nodec		;branch if d0 more than 2
	move.w	#$F0,$44(a3)		;move 240 dec into temp3
.nodec	btst	#$5,$62(a3)		;pfalock - check if anim lock
	bne.w	check4benchExit		;exit if locked
	btst	#$2,$17F70.l		;check bit 2
	beq.w	.gmclock		;jump if not set
	btst	#$5,$17F70.l		;check bit 5
	beq.w	.nodec2		;jump if not set
.gmclock	btst	#$0,$17F68.l		;check if clock running
	bne.w	donothing		;branch if not
.nodec2	btst	#$3,$62(a3)		;pfjoycon - check if controlled
	bne.w	check4benchExit		;jump if controlled
	btst	#$2,$32(a2)		;tmfmid of tmflags(a2)
	bne.w	.nodec22
	tst.w	$17BE0.l		;check if theres a puck carrier
	bmi.w	check4check		;jump if no puck carrier
	sub.w	d7,$44(a3)		;subtract frames from temp3
	bpl.w	check4check		;jump if positive
	clr.w	$44(a3)		;clear temp3
.nodec22	bsr.w	skatetopuckinit		;d0/d1 = halfway between
	movem.w	d0-d1,-(sp)		;d0 = future puckx, d1 = future pucky push on stack
	neg.w	d0		;or (0,-$F4) if pfgoal
	neg.w	d1
	addi.w	#$F4,d1		;add goalline - 20 decimal
	btst	#$7,$62(a3)		;pfgoal - check what net shooting on
	beq.w	.nd0		;branch if bottom
	subi.w	#$1E8,d1		;sub bottom goalline - 20 decimal
.nd0	asr.w	#$1,d0		;divide by 2
	asr.w	#$1,d1		;divide by 2
	add.w	(sp)+,d0		;add original future puckx
	add.w	(sp)+,d1		;add original future pucky
	btst	#$2,$32(a2)		;?? - doesn't seem to be set anywhere
	beq.w	.spdboost
	btst	#$7,$62(a3)		;pfgoal
	beq.w	.botshoot		;branch if bottom
	cmpi.w	#$53,d1		;check if y pos of puck near blue line
	blt.w	.spdboost		;branch if in neutral zone or D zone
	move.w	#$44,d1		;move 44 hex into d1
	bra.w	.spdboost
.botshoot	cmpi.w	#$FFAD,d1		;check if pucky near bottom blue line
	bgt.w	.spdboost		;branch if in neutral zone or D zone
	move.w	#$FFBC,d1		;move FFBC into d1
.spdboost	btst	#$5,(sflags6).l		;check if puckc is in the slot
	beq.w	.noslot		;branch if not
	move.b	$69(a3),$17E6E.l		;legspd into TempLegSpd
	addi.b	#$6,$69(a3)		;add 6 to legspd
	btst	#$1,$17F7C.l		;check if crowd meter broken (always is)
	bne.w	.spdboostex		;jump if set
	btst	#$6,$17F7A.l		;check if crowd meter currently broken
	beq.w	.spdlimit		;jump if not set
.spdboostex	addi.b	#$2,$69(a3)
.spdlimit	cmpi.b	#$1E,$69(a3)		;check speed limit
	ble.w	.cont
	move.b	#$1E,$69(a3)		;limit legspd to $1E (30 decimal)
.cont	lea.l	$341EE.l,a0
	bsr.w	skateto
	move.b	$17E6E.l,$69(a3)		;move original legpsd back into player
	bra.w	.chkslot
.noslot	lea.l	$341EE.l,a0
	bsr.w	skateto
.chkslot	btst	#$5,(sflags6).l
	beq.w	.chkcont
	move.w	$17B94.l,d0
	move.w	$14(a3),d2		;Ypos into d2
	tst.w	d0		;check if d0 is 0
	bpl.w	.pospuck		;branch if positive
	neg.w	d0		;make d0 negative
	neg.w	d2		;make d2 negative
.pospuck	sub.w	d0,d2		;sub d0 from d2 (equals how far puck is from player Ypos)
	cmpi.w	#$A,d2		;check difference with A (10 decimal)
	blt.w	.exit
	move.w	$0(a3),d0		;Xpos of player (gets here if player is between net and puck carrier)
	sub.w	$17B80.l,d0
	bpl.w	.chkx		;branch if positive difference
	neg.w	d0		;make d0 negative
.chkx	cmpi.w	#$F,d0		;compare F (15 dec) with Xpos difference
	blt.w	.chkcont		;branch if less than (within 15 pix in X direction)
.exit	rts
.chkcont	btst	#$5,(sflags6).l		;check if puckc is in the slot
	beq.w	CheckCheckerSet		;branch if not in slot
	move.b	$75(a3),d0		;move Chk into d0
	ext.w	d0		;clear top byte of d0
	movem.l	d0/a3,-(sp)		;push to stack
	add.b	d0,d0		;add d0 to itself
	cmpi.b	#$1E,d0		;compare max Chk to d0
	blt.w	.chkcont2		;branch if less
	move.b	#$1E,d0		;move 1E into d0
.chkcont2	move.b	d0,$75(a3)		;move d0 into Chk
	bsr.w	CheckCheckerSet
	movem.l	(sp)+,d0/a3		;pop off stack
	move.b	d0,$75(a3)		;move original Chk into player
	rts
check4check						;look for good opportunity for checking opponent. Falls in from
									;assnearest; also entered from assfwatch and asswingd roll against
									;the checking rating first, then look for an opponent within 30 units
									;whom a3 is facing
	bsr.w	skatetopuck
; Returns unless the player has a checker set at $34.
CheckCheckerSet	tst.w	$34(a3)		;check if goalie
	bne.w	.player		;branch if not
	rts
.player	move.w	#$28,d0		;start with 28 hex (40 decimal)
	sub.b	$75(a3),d0		;subtract Chk from d0 (Chk max is 1E or 30 decimal)
	tst.w	$18C08.l
	beq.w	.nopen		;branch if not on
	asl.w	#$1,d0		;mult by 2
.nopen	bsr.w	randomd0		;RNG d0
	cmpi.w	#$6,d0		;compare 6 to d0
	bhi.w	check4benchExit		;exit if d0 higher than 6
	moveq	#$5,d2		;move 5 into d2
	movea.l	#$17480,a0
	cmpi.w	#$6,$52(a3)		;check if player on home team
	bge.w	.0		;branch if away
	adda.w	#$300,a0		;add if home (checks opposite team in loop)
.0	tst.w	$34(a0)		;check if goalie
	beq.w	.next		;branch if goalie
	btst	#$5,$62(a0)		;check if locked in anim
	bne.w	.next		;branch if locked
	btst	#$0,$63(a0)		;check if fighting
	bne.w	.next		;branch if fighting
	move.w	$0(a0),d0		;move Xpos into d0
	sub.w	$0(a3),d0		;sub a3 from a0
	cmpi.w	#$1E,d0		;compare to 30 decimal
	bgt.w	.next		;branch if more than 30 decimal
	cmpi.w	#$FFE2,d0		;compare to -30 decimal
	blt.w	.next		;branch if less than -30
	move.w	$14(a0),d1		;Ypos
	sub.w	$14(a3),d1		;subtract checker Ypos from d1
	cmpi.w	#$1E,d1		;compare to 30 decimal
	bgt.w	.next		;branch if more
	cmpi.w	#$FFE2,d1		;check with -30 decimal
	blt.w	.next		;branch if less
	bsr.w	vtoa		;determine direction
	cmp.w	$54(a3),d0		;compare facedir with vtoa result
	bne.w	.next		;branch if not facing in that direction
	btst	#$5,(sflags6).l		;check if puckc in slot
	bne.w	Acheck		;branch if in slot
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
	andi.w	#$3,d0		;pass first 2 bits
	bne.w	burst		;throw check
	bra.w	Acheck		;1 in 4: hold or hook on a0
.next	adda.w	#$80,a0		;move to next SCstruct
	dbra	d2,.0
	rts
asspassrec						;assignment for catching a pass (apassrec)
	btst	#$5,$62(a3)		;pfalock - animation lock
	bne.w	check4benchExit		;exit if locked
	btst	#$0,$17F68.l		;gmclock - check if clock running
	bne.w	donothing		;exit if clock stopped
	btst	#$3,$62(a3)		;pfjoycon - joystick controlled?
	bne.w	assexit		;exit if controlled
	bclr	#$1,$62(a3)		;#pfna - clear new assignment
	beq.w	.nna
	bset	#$0,$62(a3)		;#pfdoff - set decceleration off
	move.b	#$8,$43(a3)		;move into temp2+1
	clr.b	$42(a3)		;clear temp2 byte
	move.w	#$FFFE,$46(a3)		;move into temp4
.nna	tst.w	$17BE0.l		;check if there is a puck carrier
	bpl.w	.exit		;exit if puck still in possession
	addi.w	#$1,$46(a3)		;add to temp4
	beq.w	.next		;branch if temp4 is zero
	bpl.w	.next3		;branch if temp4 is positive
.next	tst.w	$17EBC.l
	bpl.w	.next3
	tst.w	$34(a3)		;test if goalie
	beq.w	.next3		;exit if goalie
	move.w	d0,-(sp)		;push d0 on stack
	clr.w	$46(a3)		;clear temp4
	move.w	#$1,d0
	btst	#$6,$62(a3)		;check if home or away
	beq.w	.next2
	move.w	#$2,d0		;away team
.next2	cmp.w	$17FA6.l,d0
	beq.w	.pop
	cmp.w	$17FA8.l,d0
	beq.w	.pop		;branch if so
	jsr	(PuckOnAttackHalf).l
	beq.w	.pop
	move.w	$14(a3),d0		;Ypos
	btst	#$7,$62(a3)		;pfgoal
	bne.w	.chkpos		;branch if shooting at top
	neg.w	d0
.chkpos	cmpi.w	#$58,d0		;blueline
	blt.w	.nozone
	cmpi.w	#$108,d0		;goalline
	bgt.w	.nozone
	bra.w	.atkzone
.nozone	move.w	#$8,d0		;outside of attack zone
	jsr	(randomd0).l
	tst.w	d0		;check if d0 is zero
	bne.w	.pop
.atkzone	move.w	(sp)+,d0
	move.w	#$FFFF,$1AD7A.l
	move.w	#$23,d0
	jmp	(assreplace).l
.pop	move.w	(sp)+,d0
.next3	sub.b	d7,$40(a3)
	bpl.w	check4benchExit
.exit	bclr	#$0,$62(a3)
	bra.w	assexit
	move.w	$44(a3),d0
	move.w	$46(a3),d1
; Instruction bytes inside asspassrec that the assembler would encode differently, kept as words (1 row).
	dc.w	$41FA,$7BCA
	bra.w	skateto
assshoot						;assignment for computer shooting. Assignment ashoot ($12)
	btst	#$5,$62(a3)		;pfalock - animation locked
	bne.w	check4benchExit
	bclr	#$1,$62(a3)		;clear pfna
	beq.w	.nna
	bra.w	SetShotMode		;first frame: start the shot (temp2 = swing time set by CompShoot)
.nna	btst	#$3,$17F6A.l		;#sfssdir
	beq.w	assexit		;no: the shot is done
	clr.w	d2
	sub.w	d7,$42(a3)		;count the swing time down
	bpl.w	ShotMode		;still swinging: feed ShotMode no buttons
	bset	#$5,d2		;#cbut
	bra.w	ShotMode		;swing time over: press the shot button (cbut)
puckshootout						;puck logic for the shootout: on a new assignment clear the pads and
									;select the skater, then run the attempt
	bclr	#$1,$62(a3)
	beq.w	.selectskater
	bset	#$7,$17F7A.l
	clr.l	$17DCA.l
	clr.l	$17DCE.l
	clr.l	$17DD2.l
	bclr	#$7,$17F78.l
	btst	#$0,$17F78.l
	beq.w	.startattempt
	jsr	(NextShooter).l
	bra.w	.initflags
.startattempt	jsr	(StartShootoutPath).l
	move.l	a2,-(sp)
	movea.l	#tmstruct,a2
	tst.w	$19366.l
	beq.w	.countattempt
	movea.l	#awtmstruct,a2
.countattempt	addi.w	#$1,$362(a2)
	movea.l	(sp)+,a2
.initflags	bclr	#$2,$17F70.l
	bclr	#$4,$17F70.l
	bclr	#$5,$17F70.l
	bclr	#$6,$17F70.l
	bset	#$1,(sflags6).l
	btst	#$3,$17F68.l
	bne.w	Stop4Pen
	bclr	#$1,$62(a3)
	btst	#$0,$17F78.l
	beq.w	.next
	tst.w	$1A436.l
	bne.w	.setstopped
	tst.w	$1A428.l
	bne.w	.setstopped
	move.w	(HomeTeam).l,$1A56C.l
	move.w	#$2,$1A56E.l
	jsr	(ChooseSong).l
	move.w	$1A56A.l,-(sp)
	bra.w	.playsong
.next	move.w	(HomeTeam).l,$1A56C.l
	move.w	#$2,$1A56E.l
	jsr	(ChooseSong).l
	move.w	$1A56A.l,-(sp)
.playsong	bsr.w	song
.setstopped	bset	#$0,$17F68.l
	bset	#$1,$17F78.l
	clr.w	$17BA8.l
	clr.w	$17BAA.l
	move.w	#$19,$193B6.l
	bsr.w	ReturnGoalies
	st.b	$40(a3)
	st.b	$42(a3)
.selectskater	bset	#$2,$17F70.l
	movem.w	d1-d2,-(sp)
	jsr	(SelectPenaltyShotSkater).l
	bmi.w	.noeligible
	movem.w	(sp)+,d1-d2
	bra.w	.checkgoalie
.noeligible	movem.w	(sp)+,d1-d2
	bclr	#$2,$17F70.l
	move.w	#$1B,d0		;puckfaceoff
	bsr.w	assreplace
	rts
.checkgoalie	movem.w	d1-d2,-(sp)
	move.w	$1936A.l,d0
	movea.l	#$17480,a2
	asl.w	#$7,d0
	adda.w	d0,a2
	tst.w	$34(a2)
	bne.w	.next2
	btst	#$2,$63(a2)
	beq.w	.startpenshot
.next2	move.w	$1936A.l,d0
	move.w	#$6,d2
.goalieloop	subi.w	#$1,d2
	bmi.w	.noeligible
	subi.w	#$1,d0
	bpl.w	.wraphome
	move.w	#$5,d0
	bra.w	.next3
.wraphome	cmpi.w	#$5,d0
	bne.w	.next3
	move.w	#$B,d0
.next3	movea.l	#$17480,a2
	move.w	d0,d1
	asl.w	#$7,d1
	adda.w	d1,a2
	tst.w	$34(a2)
	bne.w	.goalieloop
	btst	#$2,$63(a2)
	bne.w	.goalieloop
	move.w	d0,$1936A.l
.startpenshot	movem.w	(sp)+,d1-d2
	movea.l	#tmstruct,a2
	move.w	#$1F,d0		;puckpenshot
	bra.w	assreplace

SelectPenaltyShotSkater						;pick the skater for the penalty shot from team BA_Team
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a0
	tst.w	$19366.l
	beq.w	.hometeam
	movea.l	#awtmstruct,a0
.hometeam	move.w	#$0,d1
	move.w	#$FFFF,d6
	move.w	#$FFFF,d5
	movea.l	$1E(a0),a2
	adda.w	$0(a2),a2
.playerloop	cmpi.w	#$2,(a2)
	beq.w	.doneplayers
	adda.w	(a2),a2
	move.w	d1,d7
	asl.w	#$1,d7
	move.b	$5(a2),d0
	andi.w	#$F,d0
	cmpi.b	#$1,d0
	ble.w	.nextplayer
	btst	#$0,$17F78.l
	bne.w	.next
	cmpi.w	#$FFFE,$68(a0,d7.w)
	beq.w	.scorecandidate
	cmpi.w	#$FFFF,$68(a0,d7.w)
	bne.w	.nextplayer
.scorecandidate	clr.w	d3
	clr.w	d0
	move.b	$1(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$2(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$2(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$3(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$3(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$5(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$5(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$6(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$7(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	cmp.w	$1936C.l,d1
	bne.w	.comparebest
	move.w	#$7FFF,d3
.comparebest	cmp.w	d6,d3
	blt.w	.nextplayer
	move.w	d3,d6
	move.w	d1,d5
	bra.w	.nextplayer
.nextplayer	adda.l	#$8,a2
	addi.w	#$1,d1
	cmpi.w	#$1A,d1
	blt.w	.playerloop
.doneplayers	tst.w	d5
	bmi.w	.noeligible
	move.w	d5,$1936C.l
.next	move.w	#$0,$19368.l
	tst.w	$19366.l
	beq.w	.next2
	move.w	#$6,$19368.l
.next2	move.w	$19368.l,d0
	asl.w	#$7,d0
	movea.l	#$17480,a3
	adda.w	d0,a3
	move.w	$1936C.l,d3
	bra.w	.eligible
.noeligible	move.w	#$FFFF,d0
	bra.w	.exit
.eligible	move.w	#$1,d0
.exit	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Penalty shot: fade out and show the skater selection
SelectPenaltyShotSkaterScreen	bclr.b	#$1,$62(a3)
	beq.w	.next19
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	forceblack
.loop	btst.b	#$0,$18D64.l
	bne.w	.loop
	cmpi.w	#$258,$17CD2.l
	bls.w	.next
	move.w	#$258,$17CD2.l
	addi.w	#$14,$17CD8.l
.next	move.w	$18D56.l,d4
	movea.l	$47D1C.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	bset.b	#$3,$18D64.l
	bclr.b	#$0,$17F6A.l
	bclr.b	#$0,$17F6E.l
	clr.w	$17E32.l
	clr.b	$17ECE.l
	st.b	$1806E.l
	bclr.b	#$1,$17F6C.l
	st.b	$17E30.l
	bsr.w	ClrHor
	clr.w	$17CEA.l
	clr.w	$17CEE.l
	move.w	#$0,$17B80.l
	move.w	#$0,$17B94.l
	clr.w	$17B98.l
	clr.w	$17BA8.l
	clr.w	$17BAA.l
	clr.w	$17BAC.l
	st.b	$17BE0.l
	movea.l	#$17A80,a0
	clr.w	$28(a0)
	clr.w	$2A(a0)
	clr.w	$0(a0)
	move.w	#$10C,$14(a0)
	adda.w	#$80,a0
	clr.w	$28(a0)
	clr.w	$2A(a0)
	clr.w	$0(a0)
	move.w	#$FEF4,$14(a0)
	movea.l	#$17C00,a0
	move.w	#$18A,$6(a0)
	clr.w	$58(a0)
	clr.w	$4(a0)
	clr.w	$17B84.l
	bclr.b	#$6,$17F6A.l
	moveq	#$64,d4
.loop2	bsr.w	checkwindow
	dbra	d4,.loop2
	move.w	#$3C,$17EE0.l
	jsr	(ResetBench).l
	movea.l	#$1834C,a2
	jsr	(setpersonel).l
	jsr	(SetupPenaltyShot).l
	adda.l	#$366,a2
	jsr	(setpersonel).l
	jsr	(SetupPenaltyShot).l
	jsr	(resetplstuff).l
	move.l	a3,-(sp)
	movea.l	#$17A00,a3
	move.w	#$B,d2
.loop3	cmp.w	$19368.l,d2
	beq.w	.next2
	cmp.w	$1936A.l,d2
	beq.w	.next7
	move.w	#$FF10,$0(a3)
	clr.w	$14(a3)
	clr.w	$6(a3)
	move.w	#$20,d0
	bsr.w	AssistListPush
	bra.w	.next13
.next2	tst.w	$34(a3)
	bpl.w	.next4
	bclr.b	#$2,$63(a3)
	beq.w	.next4
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d3
	move.b	$66(a3),d3
	jsr	(SetPlayerSide).l
	movem.l	(sp)+,d0-d7/a0-a6
	tst.w	$34(a3)
	beq.w	.next3
	bpl.w	.next4
.next3	nop
.next4	move.w	$17B80.l,d0
	subi.w	#$0,d0
	move.w	d0,$0(a3)
	move.w	$17B94.l,d0
	btst.b	#$7,$62(a3)
	bne.w	.next5
	addi.w	#$10,d0
	move.w	#$4,$54(a3)
	bra.w	.next6
.next5	addi.w	#$FFF0,d0
	move.w	#$0,$54(a3)
.next6	move.w	d0,$14(a3)
	clr.w	$28(a3)
	clr.w	$2A(a3)
	clr.w	$2C(a3)
	move.w	#$11,d0
	bsr.w	AssistListPush
	bra.w	.next13
.next7	btst.b	#$0,$17F78.l
	beq.w	.next8
	move.b	$1A435.l,$66(a3)
	tst.w	$1A436.l
	beq.w	.next9
	move.b	$1A427.l,$66(a3)
	bra.w	.next9
.next8	tst.w	$34(a3)
	bpl.w	.next11
	bclr.b	#$2,$63(a3)
	beq.w	.next11
.next9	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d3
	move.b	$66(a3),d3
	jsr	(SetPlayerSide).l
	movem.l	(sp)+,d0-d7/a0-a6
	tst.w	$34(a3)
	bne.w	.next10
	bpl.w	.next11
.next10	nop
.next11	bclr.b	#$2,$63(a3)
	move.w	#$0,d0
	move.w	#$E5,d1
	btst.b	#$7,$62(a3)
	bne.w	.next12
	move.w	#$FF1B,d1
.next12	move.w	d0,$0(a3)
	move.w	d1,$14(a3)
	clr.w	$28(a3)
	clr.w	$2A(a3)
	clr.w	$18(a3)
	sub.w	$17B80.l,d0
	sub.w	$17B94.l,d1
	neg.w	d0
	neg.w	d1
	bsr.w	vtoa
	move.w	d0,$54(a3)
	bclr.b	#$2,$63(a3)
	bclr.b	#$5,$62(a3)
	move.w	#$50C,d1
	bsr.w	SetSPA
.next13	suba.l	#$80,a3
	dbra	d2,.loop3
	jsr	(SprSort).l
	movea.l	(sp)+,a3
	bsr.w	ResetAndSelectPlayers
	move.w	$1936A.l,d0
	asl.w	#$7,d0
	movea.l	#$17480,a3
	adda.w	d0,a3
	move.w	#$0,$0(a3)
	move.w	#$FF06,$14(a3)
	btst.b	#$7,$62(a3)
	bne.w	.next14
	move.w	#$FA,$14(a3)
.next14	move.w	$1936A.l,d0
	move.w	#$1,d1
	btst.b	#$6,$62(a3)
	beq.w	.next15
	move.w	#$2,d1
.next15	cmp.w	$17FA6.l,d1
	bne.w	.next16
	jsr	(setc1player).l
	bra.w	.next17
.next16	cmp.w	$17FA8.l,d1
	bne.w	.next17
	jsr	(setc2player).l
.next17	move.w	#$E,d0
	bsr.w	assreplace
	bset.b	#$7,$17F70.l
	bset.b	#$2,$17F6C.l
	move.w	#$190,$17F98.l
	tst.w	$17FA6.l
	bne.w	.next18
	tst.w	$17FA8.l
	bne.w	.next18
	move.w	#$64,$17F98.l
.next18	move.w	#$18,$18D62.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.next19	bset.b	#$2,$17F78.l
	move.w	#$18,d0
	bsr.w	assreplace
	clr.w	$28(a3)
	clr.w	$2A(a3)
	rts
; Table of 52 bytes after SelectPenaltyShotSkaterScreen, 52 bytes: $00,$01,$02,$03,$04,$05 ...
	dc.b	$00,$01,$02,$03,$04,$05,$06,$00,$00,$01,$05,$03,$04,$02,$00,$00	; ................
	dc.b	$00,$03,$05,$01,$04,$00,$00,$00,$00,$00,$FF,$06,$FF,$DD,$FF,$CE	; ................
	dc.b	$00,$23,$FF,$CE,$FF,$CE,$FF,$F6,$00,$00,$FF,$F1,$00,$32,$FF,$F6	; .#...........2..
	dc.b	$00,$00,$FF,$C4	; ....
UpdatePenaltyShotEnd						;end the penalty shot when the goalie has the puck, the puck is loose or
									;the timer runs out
	movem.w	d0,-(sp)
	move.w	$17BE0.l,d0
	cmp.w	$1936A.l,d0
	movem.w	(sp)+,d0
	beq.w	.next2
	btst	#$5,$17F70.l
	beq.w	.next3
	btst	#$5,$17F78.l
	bne.w	.puckloose
	tst.w	$17BE0.l
	bpl.w	.next
	bset	#$5,$17F78.l
.puckloose	tst.w	$17BE0.l
	bpl.w	.next2
.next	tst.w	$17F9A.l
	bmi.w	.next2
	subq.w	#$1,$17F9A.l
	bra.w	.next3
.next2	bset	#$4,$17F70.l
.next3	tst.w	$193B6.l
	bne.w	.checkended
	bset	#$4,$17F70.l
.checkended	btst	#$4,$17F70.l
	bne.w	.finishshot
	rts
.finishshot	btst	#$6,$17F70.l
	bne.w	EndPenaltyShotPlayExit
	bset	#$6,$17F70.l
	move.w	#$A,d0
	jsr	(AddPenalty2).l
EndPenaltyShotPlay						;stop play after a penalty shot or shootout attempt: freeze the window,
									;stop the clock, clear the penalty shot flags
	jsr	(freezewindow).l
	btst	#$0,$17F78.l
	bne.w	.stopplay
	move.w	#$A,$1AD92.l
	bset	#$2,$17F6C.l
.stopplay	bset	#$0,$17F68.l
	bclr	#$2,$17F78.l
	bclr	#$2,$17F70.l
	bclr	#$3,$17F70.l
	bclr	#$5,$17F70.l
	bclr	#$4,$17F70.l
	bclr	#$6,$17F70.l
	movem.l	d0/a0,-(sp)
	movea.l	#$17480,a0
	move.w	$19368.l,d0
	asl.w	#$7,d0
	move.b	$17F9C.l,$61(a0,d0.w)
	movem.l	(sp)+,d0/a0
	jsr	(CountShootoutGoals).l
; Return of EndPenaltyShotPlay
EndPenaltyShotPlayExit	rts
; Penalty shot: clears the flags and the timers
PenaltyShotCleanup	bclr.b	#$4,$17F7C.l
	btst.b	#$0,$17F78.l
	beq.w	.next
	clr.w	$17BA8.l
	clr.w	$17BAA.l
	move.w	#$1E,d0
	bra.w	assreplace
.next	bclr.b	#$1,$62(a3)
	beq.w	WaitForFaceoffLineChanges
	bclr.b	#$0,$17F7C.l
	beq.w	.next2
	clr.w	$17EE2.l
	clr.w	$17EE4.l
.next2	bclr.b	#$7,$17F7A.l
	clr.l	$17DCA.l
	clr.l	$17DCE.l
	clr.l	$17DD2.l
	bclr.b	#$6,$17F7A.l
	bclr.b	#$2,$17F7A.l
	jsr	(CheckScoreLeader).l
	tst.w	$1A560.l
	bmi.w	.next3
	move.w	$1A560.l,d0
	bra.w	.next4
.next3	jsr	(RandomFaceoffAnim).l
	tst.w	d0
	bmi.w	.next5
.next4	jsr	(SetFaceoffAnim).l
.next5	bclr.b	#$1,$17F76.l
	bclr.b	#$1,$17F78.l
	tst.w	$180E6.l
	beq.w	PeriodOver
	btst.b	#$6,$17F68.l
	bne.w	PeriodOver
	cmpi.w	#$3,$180E4.l
	bne.w	.next6
	move.w	$18358.l,d0
	cmp.w	$186BE.l,d0
	bne.w	FaceoffContinueClock
.next6	btst.b	#$3,$17F68.l
	bne.w	Stop4Pen
	move.w	$180EA.l,d0
	asr.w	#$1,d0
	cmp.w	$180E6.l,d0
	bls.w	.next7
	cmpi.w	#$3C,$180E6.l
	blt.w	.next7
	btst.b	#$7,$17F6E.l
	beq.w	.next7
	btst.b	#$0,$17F68.l
	beq.w	.next7
	btst.b	#$6,$17F7C.l
	bne.w	.next7
	bclr.b	#$7,$17F6E.l
	move.w	$17FAE.l,$1A56C.l
	move.w	#$2,$1A56E.l
	jsr	(ChooseSong).l
	move.w	$1A56A.l,-(sp)
	bsr.w	song
.next7	bsr.w	ReturnGoalies
	st.b	$40(a3)
	st.b	$42(a3)
	tst.w	$18C0A.l
	bne.w	WaitForFaceoffLineChanges
	bclr.b	#$1,$1837E.l
	bclr.b	#$1,$186E4.l
	movea.l	#$17480,a0
	moveq	#$B,d0
.loop	bclr.b	#$3,$63(a0)
	adda.w	#$80,a0
	dbra	d0,.loop
	move.w	$17FA6.l,d0
	or.w	$17FA8.l,d0
	beq.w	.next8
	btst.b	#$7,$17F6A.l
	beq.w	.next8
	bsr.w	forceblack
	bset.b	#$6,$17F6A.l
	bsr.w	ClrHor
	move.w	#$18,$18D62.l
	tst.w	$18C0A.l
	bne.w	.next8
	btst.b	#$4,$17F7A.l
	beq.w	.next8
	clr.w	$18D62.l
.next8	move.w	$17F9E.l,d0
	bmi.w	.next9
	bsr.w	StartFaceoffLineChange
.next9	move.w	$17FA0.l,d0
	bmi.w	.next10
	bsr.w	StartFaceoffLineChange
.next10	movea.l	#$1834C,a1
	lea.l	$366(a1),a2
	moveq	#$2,d0
	bsr.w	SetFaceoffComputerLine
	bra.w	WaitForFaceoffLineChanges
SetFaceoffComputerLine	tst.w	$18C0A.l
	bne.w	rtss2
	btst	#$4,$17F7A.l
	bne.w	.next
	cmp.w	$17FA6.l,d0
	beq.w	rtss2
	cmp.w	$17FA8.l,d0
	beq.w	rtss2
.next	bsr.w	CompLine
	jsr	(setpersonel).l
	bsr.w	printscores1
	move.w	#$2710,$17F82.l
	rts
StartFaceoffLineChange						;start the line change box for team d0's sort object before a faceoff
	exg.l	a2,a3
	asl.w	#$7,d0
	movea.l	#$17480,a3
	adda.w	d0,a3
	bclr	#$3,$63(a3)
	move.l	a2,-(sp)
	bsr.w	FaceoffInputCheckLocked
	movea.l	(sp)+,a2
	btst	#$3,$63(a3)
	beq.w	.exit
	btst	#$6,$62(a3)
	beq.w	.homeplayer
	move.w	#$168,$42(a2)
	move.w	$52(a3),$46(a2)
	bra.w	.exit
.homeplayer	move.w	#$258,$40(a2)
	move.w	$52(a3),$44(a2)
.exit	exg.l	a2,a3
	rts
WaitForFaceoffLineChanges						;run both teams' faceoff line change timers (temp1 / temp2); continue when
									;both have run out
	move.w	#$40,d0
	bsr.w	UpdateFaceoffLineChangeTimer
	move.w	#$42,d0
	bsr.w	UpdateFaceoffLineChangeTimer
	tst.w	$40(a3)
	bpl.w	rtss2
	tst.w	$42(a3)
	bpl.w	rtss2
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a1
	moveq	#$1,d0
	bsr.w	SetFaceoffComputerLine
	move.w	#$FFFF,$1A568.l
	move.w	#$1C,d0		;puckfaceoff2
	bra.w	assreplace
UpdateFaceoffLineChangeTimer						;count down one team's faceoff line change timer at offset d0 of a3
	tst.w	(a3,d0.w)
	bmi.w	rtss2
	move.w	$4(a3,d0.w),d1
	asl.w	#$7,d1
	movea.l	#$17480,a0
	movea.l	#tmstruct,a2
	btst	#$6,$62(a0,d1.w)
	beq.w	.checkactive
	adda.w	#$366,a2
.checkactive	btst	#$3,$63(a0,d1.w)
	bne.w	.countdown
	st.b	(a3,d0.w)
	bra.w	SetLCmode2
.countdown	sub.w	d7,(a3,d0.w)
	bpl.w	rtss2
	move.l	a3,-(sp)
	lea.l	(a0,d1.w),a3
	btst	#$3,$63(a3)
	beq.w	.exit
	clr.w	d2
	bsr.w	LineInputSetCoords
	bsr.w	SetLCmode2
.exit	movea.l	(sp)+,a3
	rts
; Jumps back into clockcont
FaceoffContinueClock	jmp	(clockcontAssists).l
ChkGoalies						;computer pulls goalie on delayed penalty. Called from periodicevents
	btst	#$0,$17F68.l		;check if clock running
	bne.w	rtss2
	movea.l	#tmstruct,a2		;a2 = team being tested, a1 = the other team
	lea.l	$366(a2),a1
	moveq	#$1,d0		;d0 = team number (1 home, 2 visitors)
	bsr.w	.chkgoalie
	moveq	#$2,d0
	exg.l	a1,a2
.chkgoalie	tst.w	$28(a2)		;check for goalie
	bmi.w	rtss2		;no goalie, exit
	move.w	$17BE0.l,d1		;move puck carrier SCnum into d1
	bmi.w	rtss2
	subi.w	#$6,d1
	cmpa.l	#$1834C,a2
	beq.w	.chkpen
	not.w	d1		;makes d1 negative if away team
.chkpen	tst.w	d1
	bpl.w	rtss2
	btst	#$3,$17F68.l		;#gmpendel - delayed penalty called
	beq.w	.next
	st.b	$28(a2)		;sets to FFFF (no goalie)
	jmp	(setpersonel).l
.next	cmp.w	$17FA6.l,d0
	beq.w	rtss2
	cmp.w	$17FA8.l,d0
	beq.w	rtss2
	move.w	$17B94.l,d1
	bra.w	CPgoalie
ReturnGoalies						;if computer pulled goalie, look to see if computer should return him.
									;Called from puckfaceoff
	movea.l	#tmstruct,a2		;a2 = team being tested, a1 = the other team
	lea.l	$366(a2),a1
	moveq	#$1,d0		;d0 = team number
	bsr.w	.r		;home team first ...
	moveq	#$2,d0
	exg.l	a1,a2		;... then fall into .r for the visitors
.r	cmpi.w	#$FFFF,$28(a2)
	beq.w	rtss2		;still no goalie
	clr.b	$28(a2)		;clear for goalie return
	cmp.w	$17FA6.l,d0
	beq.w	rtss2
	cmp.w	$17FA8.l,d0
	beq.w	rtss2
	move.w	$17EE4.l,d1
CPgoalie						;see if computer should pull his goalie. d1 = puck/faceoff y. Falls in
									;from ReturnGoalies; also entered from ChkGoalies
	cmpi.w	#$2,$180E4.l		;check if 3rd period
	bne.w	rtss2		;exit if not
	move.w	$C(a1),d0		;tmscore
	sub.w	$C(a2),d0
	bmi.w	rtss2		;exit if leading in the game
	cmpi.w	#$2,d0
	bne.w	rtss2		;exit if behind by more than 2
	cmpi.w	#$3C,$180E6.l
	bgt.w	rtss2		;exit if more than 1 min left
	move.l	a0,-(sp)
	movea.l	$22(a2),a0		;moves a player struct address into a0
	btst	#$7,$62(a0)		;#pfgoal
	movea.l	(sp)+,a0
	bne.w	.0
	neg.w	d1		;make y positive toward the goal I shoot at
.0	tst.w	d1
	bmi.w	rtss2		;exit if d1 negative (faceoff in own zone)
	st.b	$28(a2)		;set to FFFF (no goalie)
	jmp	(setpersonel).l
CompLine						;find good line for comp to switch to. a2 = team, a1 = other team. Called
									;from chk4lc and puckfaceoff
	movem.l	d0-d2/a0,-(sp)
	moveq	#$3,d0		;d0 = first of the 2 special lines (3-4) used with a man advantage
	move.w	$26(a2),d1		;tmap
	sub.w	$26(a1),d1		;compare the numbers of active players
	beq.w	.next		;equal: normal line
	bpl.w	.0
	addi.w	#$2,d0		;fewer players: lines 5-6 instead
.0	move.w	d0,-(sp)		;find pk/pp line
	bsr.w	getlinee		;d0 = energy of the first candidate
	move.w	d0,d1
	move.w	(sp),d0
	addi.w	#$1,d0
	bsr.w	getlinee		;d0 = energy of the second candidate
	cmp.w	d0,d1
	bge.w	.1
	addi.w	#$1,(sp)		;second one has more energy: take it
.1	move.w	(sp)+,$16(a2)		;tmline
.loop
	movem.l	(sp)+,d0-d2/a0
	rts
.next	cmpa.l	#$1834C,a2
	bne.w	.next4
	moveq	#$2,d1
	lea.l	.next3(pc),a0
	cmpi.w	#$2,$180E4.l
	bne.w	.next2
	move.w	$C(a2),d2
	cmp.w	$C(a1),d2
	beq.w	.next2
	adda.w	#$E,a0
	bgt.w	.next2
	adda.w	#$E,a0
.next2	move.w	$16(a1),d1
	asl.w	#$1,d1
	move.w	(a0,d1.w),d0
	bsr.w	getlinee
	cmpi.w	#$C00,d0
	bls.w	.next4
	move.w	(a0,d1.w),$16(a2)
	bra.w	.loop
; Table of 21 words after CompLine, 42 bytes: $0000,$0001,$0002,$0000,$0001,$0000 ...
.next3	dc.w	$0000,$0001,$0002,$0000,$0001,$0000,$0001,$0002
	dc.w	$0000,$0001,$0002,$0000,$0002,$0000,$0000,$0001
	dc.w	$0000,$0000,$0001,$0000,$0001

.next4
	moveq	#$2,d1
	lea.l	.next5(pc),a0
	cmpi.w	#$2,$180E4.l
	bne.w	.loop2
	move.w	$C(a2),d2
	cmp.w	$C(a1),d2
	beq.w	.loop2
	adda.w	#$6,a0
	bgt.w	.loop2
	adda.w	#$6,a0
.loop2	move.w	(a0)+,d0
	bsr.w	getlinee
	cmpi.w	#$C00,d0
	dbhi	d1,.loop2
	move.w	-(a0),$16(a2)
	bra.w	.loop
.next5
; Table of 84 bytes after CompLine, 84 bytes: $00,$00,$00,$01,$00,$02 ...
	dc.b	$00,$00,$00,$01,$00,$02,$00,$00,$00,$02,$00,$01,$00,$00,$00,$01	; ................
	dc.b	$00,$00,$08,$AB,$00,$01,$00,$62,$67,$00,$05,$1E,$08,$B9,$00,$02	; .......bg.......
	dc.b	$00,$01,$7F,$70,$08,$B9,$00,$05,$00,$01,$7F,$70,$08,$B9,$00,$00	; ...p.......p....
	dc.b	$00,$01,$7F,$72,$08,$B9,$00,$01,$00,$01,$7F,$72,$08,$B9,$00,$00	; ...r.......r....
	dc.b	$00,$01,$7F,$7E,$08,$B9,$00,$01,$00,$01,$7F,$7E,$08,$B9,$00,$02	; ...~.......~....
	dc.b	$00,$01,$7F,$7E	; ...~
; Line change screen: fades out and sets the timer
CompLineScreen	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	forceblack
.loop	btst.b	#$0,$18D64.l
	bne.w	.loop
	move.w	#$3C,$19374.l
	tst.w	$17EE2.l
	bne.w	CompLineScreenFlag
	tst.w	$17EE4.l
	bne.w	CompLineScreenFlag
	move.w	#$FFFF,$1A560.l
	bra.w	CompLineScreenLimit
; Clears flag 5 of the gate array flags
CompLineScreenFlag	bclr.b	#$5,$FF800F.l
; Limits the line change timer to $258
CompLineScreenLimit	cmpi.w	#$258,$17CD2.l
	bls.w	.next
	move.w	#$258,$17CD2.l
.next	bset.b	#$3,$18D64.l
	bclr.b	#$0,$17F6A.l
	bclr.b	#$0,$17F6E.l
	clr.w	$17E32.l
	clr.b	$17ECE.l
	st.b	$1806E.l
	st.b	$17E38.l
	st.b	$17E3C.l
	bclr.b	#$1,$17F6C.l
	bset.b	#$0,$17F6C.l
	bset.b	#$2,$17F6C.l
	st.b	$17E30.l
	st.b	$17EBC.l
	bset.b	#$4,$18D64.l
	bsr.w	ClrHor
	move.w	#$2710,$17F82.l
	clr.w	$17CEA.l
	clr.w	$17CEE.l
	move.w	$17EE2.l,$17B80.l
	move.w	$17EE4.l,$17B94.l
	st.b	$17B98.l
	clr.w	$17BA8.l
	clr.w	$17BAA.l
	clr.w	$17BAC.l
	st.b	$17BE0.l
	movea.l	#$17A80,a0
	clr.w	$28(a0)
	clr.w	$2A(a0)
	clr.w	$0(a0)
	move.w	#$10C,$14(a0)
	adda.l	#$80,a0
	clr.w	$28(a0)
	clr.w	$2A(a0)
	clr.w	$0(a0)
	move.w	#$FEF4,$14(a0)
	movea.l	#$17C00,a0
	move.w	#$18A,$6(a0)
	clr.w	$58(a0)
	clr.w	$4(a0)
	clr.w	$17B84.l
	bclr.b	#$6,$17F6A.l
	moveq	#$64,d4
.loop	bsr.w	checkwindow
	dbra	d4,.loop
	move.w	#$3C,$17EE0.l
	jsr	(ResetBench).l
	movea.l	#$1834C,a2
	jsr	(setpersonel).l
	jsr	(forcepldata).l
	adda.w	#$366,a2
	jsr	(setpersonel).l
	jsr	(forcepldata).l
	jsr	(resetplstuff).l
	move.l	a3,-(sp)
	movea.l	#$17480,a3
	moveq	#$B,d2
.loop2	move.w	#$FF10,$0(a3)
	clr.w	$14(a3)
	clr.w	$6(a3)
	move.w	$34(a3),d1
	bmi.w	.next10
	beq.w	.next4
	moveq	#$16,d0
	cmpi.w	#$4,d1
	bne.w	.next3
	movea.l	#$1834C,a2
	btst.b	#$6,$62(a3)
	beq.w	.next2
	adda.w	#$366,a2
.next2	clr.w	$18(a2)
	move.b	$66(a3),$19(a2)
	bclr.b	#$7,$17F7C.l
	st.b	$1A(a2)
	st.b	$1C(a2)
	bclr.b	#$3,$32(a2)
	moveq	#$17,d0
.next3	bsr.w	AssistListPush
.next4	move.w	$18372.l,d4
	btst.b	#$6,$62(a3)
	beq.w	.next5
	move.w	$186D8.l,d4
.next5	neg.w	d4
	addi.w	#$6,d4
	asl.w	#$3,d4
	movea.l	#$35764,a1
	adda.w	d4,a1
	move.b	(a1,d1.w),d4
	asl.w	#$2,d4
	movea.l	#$3577C,a1
	move.w	(a1,d4.w),d0
	move.w	$2(a1,d4.w),d1
	btst.b	#$7,$62(a3)
	bne.w	.next6
	neg.w	d0
	neg.w	d1
.next6	tst.w	$34(a3)
	beq.w	.next9
	cmpi.w	#$8,d4
	bgt.w	.next8
	move.w	$17EE2.l,d3
	eor.w	d0,d3
	bpl.w	.next7
	move.w	$17EE4.l,d3
	asr.w	#$3,d3
	sub.w	d3,d1
.next7	move.w	$17EE2.l,d3
	asr.w	#$2,d3
	sub.w	d3,d0
.next8	add.w	$17EE2.l,d0
	add.w	$17EE4.l,d1
.next9	move.w	d0,$0(a3)
	move.w	d1,$14(a3)
	clr.w	$28(a3)
	clr.w	$2A(a3)
	sub.w	$17B80.l,d0
	sub.w	$17B94.l,d1
	neg.w	d0
	neg.w	d1
	bsr.w	vtoa
	move.w	d0,$54(a3)
	bclr.b	#$2,$63(a3)
	bclr.b	#$5,$62(a3)
	move.w	#$50C,d1
	bsr.w	SetSPA
.next10	adda.l	#$80,a3
	dbra	d2,.loop2
	jsr	(SprSort).l
	movea.l	(sp)+,a3
	bsr.w	ResetAndSelectPlayers
	move.w	$18D56.l,d4
	movea.l	$47D14.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,$18D4C.l
	movea.l	$47D30.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	move.w	#$FFFF,$1A556.l
	btst.b	#$0,$17F7A.l
	beq.w	.next11
	move.w	$1A560.l,d0
	bmi.w	.next11
	jsr	(StartArenaAnim).l
.next11	bsr.w	printz
; Inline data read by printz from the return address (1 row).
	dc.b	$00,$06,$FF,$00,$00,$00	; ......
; Picks the song for the faceoff
FaceoffSongPick	moveq	#$36,d0
	tst.w	$17EE2.l
	bpl.w	.next
	move.w	#$BE,d0
.next	move.w	d0,$1746C.l
	subi.w	#$2E,d0
	asr.w	#$3,d0
	move.w	d0,$18D58.l
	moveq	#$5C,d0
	move.w	d0,$1746E.l
	subi.w	#$44,d0
	asr.w	#$3,d0
	move.w	d0,$18D5A.l
	move.w	$18D56.l,d4
	movea.l	$47D14.l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$C,d2
	moveq	#$A,d3
	moveq	#$0,d5
	bset.b	#$0,$17F76.l
	bsr.w	dobitmap
	bclr.b	#$0,$17F76.l
	tst.w	$18C0A.l
	bne.w	FaceoffRandomDelay
	bsr.w	printsmallz
; Inline data read by printsmallz from the return address (1 row).
	dc.b	$00,$06,$FA,$0A,$FE,$04	; ......
	moveq	#$C,d0
	moveq	#$3,d1
	bsr.w	Framer
	move.w	$18362.l,d0
	move.w	$186C8.l,d1
	btst.b	#$1,$17F68.l
	bne.w	.next2
	exg.l	d0,d1
.next2	bsr.w	printsmallz
; Inline data read by printsmallz from the return address (1 row).
	dc.b	$00,$06,$FB,$01,$FA,$FE	; ......
; Prints the line list
FaceoffLineList	movea.l	#linelist,a1
	dc.w	$6100,$787A		; bsr.w X_3CEBE
	addi.w	#$4,$18D58.l
	move.w	d1,d0
	movea.l	#linelist,a1
; Instruction bytes inside FaceoffLineList that the assembler would encode differently, kept as words (1 row).
	dc.w	$6100,$7866
; Random delay ($B4 to $12B) before the faceoff
FaceoffRandomDelay	move.w	#$78,d0
	bsr.w	randomd0
	addi.w	#$B4,d0
	cmpi.w	#$0,$1A556.l
	beq.w	.next
	cmpi.w	#$1,$1A556.l
	beq.w	.next
	cmpi.w	#$5,$1A556.l
	beq.w	.next
	cmpi.w	#$4,$1A556.l
	beq.w	.next
	cmpi.w	#$2,$1A556.l
	bne.w	.next2
.next	cmpi.w	#$10E,d0
	bgt.w	.next2
	move.w	#$10E,d0
.next2	move.w	d0,$40(a3)
	move.w	#$18,$18D62.l
	movea.l	#$17CF8,a0
	move.w	#$1,(a0)
	move.w	#$8000,$2(a0)
	move.w	#$4,$4(a0)
	move.w	#$A800,$6(a0)
	move.w	#$7,$8(a0)
	move.w	#$8000,$A(a0)
	btst.b	#$1,$17F68.l
	bne.w	.next3
	eori.w	#$800,$2(a0)
	eori.w	#$800,$6(a0)
.next3	move.w	#$FFFF,$17EE6.l
	move.w	#$FFFF,$17EE8.l
	jsr	(GoalieSwapCheck).l
	bclr.b	#$6,$17F7C.l
	bne.w	.next4
	bclr.b	#$4,$17F7C.l
	beq.w	.next5
.next4	bclr.b	#$4,$17F7C.l
	move.w	$1A56A.l,-(sp)
	bsr.w	song
.next5	move.w	#$18,$18D62.l
	bset.b	#$5,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Counts the faceoff timer down and ends the faceoff
FaceoffTimerStep	subi.w	#$1,$40(a3)
	bpl.w	updatefaceoff
	jsr	(EndArenaAnim).l
	bra.w	Endfaceoff
; Table of 52 bytes after FaceoffTimerStep, 52 bytes: $00,$01,$02,$03,$04,$05 ...
	dc.b	$00,$01,$02,$03,$04,$05,$06,$00,$00,$01,$05,$03,$04,$02,$00,$00	; ................
	dc.b	$00,$03,$05,$01,$04,$00,$00,$00,$00,$00,$FF,$06,$FF,$DD,$FF,$CE	; ................
	dc.b	$00,$23,$FF,$CE,$FF,$CE,$FF,$F6,$00,$00,$FF,$F1,$00,$32,$FF,$F6	; .#...........2..
	dc.b	$00,$00,$FF,$C4	; ....
ResetAndSelectPlayers						;c1playernum / c2playernum = -1, then changeplayer for each human team
	move.w	#$FFFF,$17F9E.l
	move.w	#$FFFF,$17FA0.l
	tst.w	$17FA6.l
	beq.w	.next
	clr.w	d4
	bsr.w	PassToJump
.next	tst.w	$17FA8.l
	beq.w	.next2
	moveq	#$2,d4
	bsr.w	PassToJump
.next2	tst.w	$17FAA.l
	beq.w	.next3
	move.w	$17FA6.l,-(sp)
	move.w	$17FAA.l,$17FA6.l
	move.w	$17F9E.l,-(sp)
	move.w	#$FFFF,$17F9E.l
	clr.w	d4
	jsr	(PassToJump).l
	move.w	$17F9E.l,$17FA2.l
	move.w	$17FA6.l,$17FAA.l
	move.w	(sp)+,$17F9E.l
	move.w	(sp)+,$17FA6.l
.next3	tst.w	$17FAC.l
	beq.w	.ex
	move.w	$17FA8.l,-(sp)
	move.w	$17FAC.l,$17FA8.l
	move.w	$17FA0.l,-(sp)
	move.w	#$FFFF,$17FA0.l
	move.w	#$2,d4
	jsr	(PassToJump).l
	move.w	$17FA0.l,$17FA4.l
	move.w	$17FA8.l,$17FAC.l
	move.w	(sp)+,$17FA0.l
	move.w	(sp)+,$17FA8.l
.ex	rts
updatefaceoff						;a3 = puck. Drop animation frame from temp1; at 0 erases the faceoff box
	move.w	$40(a3),d0
	beq.w	.erase
	addi.w	#$6,d0
	lsr.w	#$3,d0
	cmpi.w	#$2,d0
	bgt.w	rtss2
	neg.w	d0
	addi.w	#$A,d0
	move.w	d0,$17D00.l
	rts
.erase	bclr	#$4,(disflags).l
	bsr.w	printz
	String	CC_Font1Pri,$0,$0
	move.w	$1746C.l,d0
	subi.w	#$2E,d0
	asr.w	#$3,d0
	move.w	d0,(printx).l
	moveq	#$64,d0
	move.w	$1746E.l,d0
	subi.w	#$44,d0
	asr.w	#$3,d0
	move.w	d0,(printy).l
	moveq	#$C,d0
	moveq	#$D,d1
	move.w	#$7FF,d2
	bra.w	eraser
Endfaceoff						;drop the puck: pick the faceoff winner and send the puck off
	movea.l	#$BBD30,a0
	move.w	$17F66.l,d0
	move.w	$18D32.l,d1
	jsr	(DoDMAProQueue).l
	move.w	#$2F,-(sp)
	bsr.w	sfx
	bclr	#$0,$17F6C.l
	move.w	#$3C,$19374.l
	move.w	$18D56.l,d4
	movea.l	$47D1C.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	bclr	#$2,$17F6C.l
	bclr	#$0,$17F68.l
	bclr	#$0,$63(a3)
	clr.w	$17F82.l
	bset	#$4,$17F6E.l
	move.w	$17EE6.l,d3
	move.w	#$800,d4
	movea.l	#$35A38,a0
	movea.l	#$17CF8,a1
	moveq	#$10,d2
	move.w	(a1),d1
	sub.b	-$1(a0,d1.w),d2
	move.w	$4(a1),d1
	add.b	-$1(a0,d1.w),d2
	moveq	#$21,d0
	bsr.w	randomd0
	cmp.b	d0,d2
	bls.w	.p1won
	adda.w	#$4,a1
.p1won	btst	#$3,$2(a1)
	beq.w	.pos
	move.w	$17EE8.l,d3
	neg.w	d4
.pos	move.w	d3,d0
	btst	#$3,d0
	bne.w	.nojoy
	andi.w	#$7,d0
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	move.w	$FF8010.l,d1
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	andi.w	#$3,d1
	bne.w	.nj2
.nojoy	moveq	#$5,d0
	bsr.w	randomd0
	subi.w	#$2,d0
	andi.w	#$7,d0
	tst.w	d4
	bmi.w	.nj2
	eori.w	#$4,d0
.nj2	asl.w	#$2,d0
	movea.l	#$36B8E,a0
	move.w	(a0,d0.w),d1
	asl.w	#$5,d1
	move.w	d1,$28(a3)
	move.w	$2(a0,d0.w),d1
	asl.w	#$5,d1
	add.w	d4,d1
	move.w	d1,$2A(a3)
	move.w	#$800,d0
	bsr.w	randomd0
	move.w	d0,$2C(a3)
	clr.w	$17B98.l
	bclr	#$2,$62(a3)
	moveq	#$18,d0
	bra.w	assreplace
; Data that follows Endfaceoff (strings, small tables)
EndfaceoffData	dc.w	$0008,$1000,$0810