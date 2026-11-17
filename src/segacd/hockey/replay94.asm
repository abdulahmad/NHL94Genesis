suba4						;a4 = current replay frame. Back up 1 frame and set video parameters for
	
	
	cmpa.l	#$C45C,a4
	bne.w	.1
	btst	#sfwrap,(sflags).l
	beq.w	.end
	movea.l	#replayend,a4
.1	suba.w	#$62,a4
	cmpa.l	(recbpr).l,a4
	bne.w	RestoreReplayFrameCopy
	adda.w	#$62,a4
.end	bsr.w	RestoreReplayFrameCopy
	clr.w	d7
	rts
adda4						;Step forward 1 frame. First handles a reverse
	
	bclr	#6,(sflags4).l
	beq.w	.1
	movem.l	d0-d7/a0-a6,-(sp)
	bchg	#4,(sflags4).l
	move.w	(Hpos).l,-(sp)
	move.w	(Vpos).l,-(sp)
	bsr.w	forceblack2
	jsr	(MenuWaitVblank).l
	jsr	(MenuWaitVblank).l
	jsr	(StatsScreenFadeInClear).l
	clr.w	(Hpos).l
	clr.w	(Vpos).l
	move.w	#$7D0,(Oldrow).l
	move.w	#1,d0
.loop	jsr	(setvideo).l
	jsr	(MenuWaitVblank).l
	dbra	d0,.loop
	move.w	(sp)+,(Vpos).l
	move.w	(sp)+,(Hpos).l
	move.w	#1,d0
	jsr	(setvideo).l
.loop2	jsr	(MenuWaitVblank).l
	dbra	d0,.loop2
	movem.l	a0,-(sp)
	movea.l	#$17A80,a0
	move.w	#1,oldframe(a0)
	adda.l	#$80,a0
	move.w	#1,oldframe(a0)
	movem.l	(sp)+,a0
	bsr.w	RestoreReplayFrame
	btst	#sfscrl,(sflags).l
	beq.w	.0
.0	jsr	(ReadActiveJoypadPrint).l
	move.w	#$64,(palcount).l
	movem.l	(sp)+,d0-d7/a0-a6
.1	clr.w	d7
	btst	#sf2drec,(sflags2).l
	beq.w	adda42
	movem.l	a4,-(sp)
	bsr.w	NextReplayEntry
	cmpa.l	(recbpr).l,a4
	movem.l	(sp)+,a4
	beq.w	updatereplayExit
adda42						;adda4 without the sf2drec look-ahead: stop at the record point, else show
	
	cmpa.l	(recbpr).l,a4
	beq.w	updatereplayExit
	bsr.w	RestoreReplayFrameCopy
; Advances the replay pointer by $62 and wraps at the end of the buffer.
NextReplayEntry	adda.w	#$62,a4
	cmpa.l	#replayend,a4
	bne.w	updatereplayExit
	movea.l	#$C45C,a4
	rts
UpdateCameraPos	movem.l	d0-d2,-(sp)
	move.w	$0(a3),d0
	btst	#7,(sflags4).l
	beq.w	.0
	neg.w	d0
.0	move.w	d0,$0(a5)
	move.w	Ypos(a3),d1
	btst	#7,(sflags4).l
	beq.w	.2
	neg.w	d1
.2	move.w	d1,Ypos(a5)
	cmpi.w	#$3C,d0
	blt.w	.next3
	move.w	#$3C,d0
.next3	cmpi.w	#$FFC4,d0
	bgt.w	.1
	move.w	#$FFC4,d0
.1	move.w	d0,(Hpos).l
	cmpi.w	#$100,d1
	blt.w	.next5
	move.w	#$100,d1
.next5	cmpi.w	#$FF38,d1
	bgt.w	.3
	move.w	#$FF38,d1
.3	move.w	d1,(Vpos).l
	movem.l	(sp)+,d0-d2
	rts
RestoreReplayFrame	btst	#$4,(sflags4).l
	beq.w	RestoreReplayFrameCopy
	bset	#$7,(sflags4).l
; Copies the saved replay sprite state back.
RestoreReplayFrameCopy	movem.l	d0-d2/a0/a6,-(sp)
	movea.l	#$4761C,a6
	movea.l	a4,a0
	moveq	#$F,d1
	movea.l	#SortCords,a3
.loop	move.w	$2(a0),d2
	andi.w	#$3FF,d2
	btst	#$9,d2
	beq.w	.next
	ori.w	#$FC00,d2
.next	btst	#$4,(sflags4).l
	beq.w	.next2
	neg.w	d2
.next2	move.w	d2,$0(a3)
	move.l	(a0),d2
	asr.l	#$4,d2
	asr.w	#$6,d2
	btst	#$9,d2
	beq.w	.next3
	ori.w	#$FC00,d2
.next3	btst	#$4,(sflags4).l
	beq.w	.next4
	neg.w	d2
	cmpi.w	#$0,d1
	bne.w	.next4
	addi.w	#$2,d2
.next4	move.w	d2,$14(a3)
	move.w	(a0),d2
	asr.w	#$4,d2
	andi.w	#$3FF,d2
	btst	#$4,(sflags4).l
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
	btst	#$4,(sflags4).l
	beq.w	.next8
	move.w	#$190,$14(a3)
.next8	move.w	(a0),d2
	asr.w	#$3,d2
	andi.w	#$1800,d2
	andi.w	#$E7FF,$4(a3)
	or.w	d2,$4(a3)
	btst	#$4,(sflags4).l
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
	movea.l	#SortCords,a3
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
	move.w	d0,(puckz).l
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
	andi.w	#$F000,(PadControlBits).l
	or.w	d0,(PadControlBits).l
	move.w	(a0)+,(Crowdframe).l
	move.w	(a0)+,(glovecords).l
	move.b	(a0)+,(PBnum).l
	clr.w	d0
	move.b	(a0)+,d0
	lsl.w	#$4,d0
	ori.w	#$F00F,d0
	move.w	d0,(PadControlBits34).l
	btst	#$5,(sflags).l
	beq.w	.next13
	movea.l	a5,a3
	btst	#$5,(sflags3).l
	beq.w	.next12
	clr.w	$18(a5)
	move.w	$16(a5),d0
	asl.w	#$7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
.next12	bsr.w	UpdateCameraPos
	bra.w	.next14
.next13	move.w	(a0)+,(Hpos).l
	move.w	(a0)+,(Vpos).l
	btst	#$4,(sflags4).l
	beq.w	.next14
	neg.w	(Hpos).l
	neg.w	(Vpos).l
	jsr	(ClampReplayView).l
.next14	bclr	#$7,(sflags4).l
	movem.l	(sp)+,d0-d2/a0/a6
	rts
ClampReplayView						;Clamp Hpos to -$3C..$3C and Vpos to -$C8..$100
	move.w	d0,-(sp)
	move.w	#$3C,d0
	cmp.w	(Hpos).l,d0
	blt.w	.0
	move.w	#$FFC4,d0
	cmp.w	(Hpos).l,d0
	ble.w	.1
.0	move.w	d0,(Hpos).l
.1	move.w	#$100,d0
	cmp.w	(Vpos).l,d0
	blt.w	.2
	move.w	#$FF38,d0
	cmp.w	(Vpos).l,d0
	ble.w	.3
.2	move.w	d0,(Vpos).l
.3	move.w	(sp)+,d0
	rts
updatereplay						;called every frame to save replay events, d7 = elapsed frames
	btst	#gmhl,(gmode).l
	bne.w	updatereplayExit
	btst	#sf2drec,(sflags2).l
	beq.w	.0
	tst.w	(replaydelay).l
	beq.w	.rec
	subi.w	#$1,(replaydelay).l
	bpl.w	.0
	clr.w	(replaydelay).l
	bra.w	.rec
.0	addi.l	#$62,(recbpr).l
	cmpi.l	#replayend,(recbpr).l
	bne.w	.rec
	bset	#sfwrap,(sflags).l
	move.l	#$C45C,(recbpr).l
.rec	movea.l	(recbpr).l,a0
	moveq	#$F,d2
	movea.l	#SortCords,a3
.top	clr.l	(a0)
	move.w	$0(a3),d1
	andi.w	#$3FF,d1
	move.w	d1,2(a0)
	clr.l	d1
	move.w	Ypos(a3),d1
	asl.w	#6,d1
	asl.l	#4,d1
	or.l	d1,(a0)
	move.w	frame(a3),d1
	asl.w	#4,d1
	or.w	d1,(a0)
	move.w	attribute(a3),d1
	andi.w	#$1800,d1
	asl.w	#3,d1
	or.w	d1,(a0)
	adda.w	#$4,a0
	adda.l	#$80,a3
	dbra	d2,.top
	moveq	#5,d2
	movea.l	#SortCords,a3
.loop	move.b	rostnum(a3),(a0)+
	move.w	position(a3),d0
	bpl.w	.n0
	moveq	#$F,d0
.n0	andi.w	#$F,d0
	move.b	d0,(a0)
	adda.l	#$80,a3
	move.b	rostnum(a3),d0
	asl.w	#4,d0
	or.b	d0,(a0)+
	move.b	rostnum(a3),d0
	lsr.b	#4,d0
	move.b	d0,(a0)
	move.w	position(a3),d0
	bpl.w	.n1
	moveq	#$F,d0
.n1	asl.w	#4,d0
	or.b	d0,(a0)+
	adda.l	#$80,a3
	dbra	d2,.loop
	move.b	$17B99.l,(a0)+
	move.b	$17C19.l,(a0)+
	move.b	$17F65.l,(a0)+
	bset	#$7,$17F65.l
	move.b	d7,(a0)+
	move.w	(PadControlBits).l,(a0)+
	move.w	(Crowdframe).l,(a0)+
	move.w	(glovecords).l,(a0)+
	move.b	(PBnum).l,(a0)+
	move.w	d0,-(sp)
	move.w	(PadControlBits34).l,d0
	lsr.w	#4,d0
	move.b	d0,(a0)+
	move.w	(sp)+,d0
	move.w	(Hpos).l,(a0)+
	move.w	(Vpos).l,(a0)+
updatereplayExit
	rts