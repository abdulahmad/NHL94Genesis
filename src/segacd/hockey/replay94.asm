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