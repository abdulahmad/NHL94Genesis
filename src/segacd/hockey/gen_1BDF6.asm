; One fade countdown step.
ForceBlackStep
	tst.w	(palcount).l
	bmi.w	rtss2
	cmpi.w	#$64,(palcount).l
	beq.w	.next
	subq.w	#$1,(palcount).l
	bmi.w	rtss2
	clr.l	d0
	move.w	(palcount).l,d0
	cmpi.w	#$18,d0
	bgt.w	rtss2
	divu.w	#$3,d0
	swap	d0
	asl.w	#$2,d0
	moveq	#$2,d3
	asl.w	d0,d3
	moveq	#$E,d5
	asl.w	d0,d5
	move.w	d5,d4
	not.w	d4
	move.l	d3,$BBC88.l
	move.l	d4,$BBC8C.l
	move.l	d5,$BBC90.l
	jsr	$222C2.l
.loop	btst	#$4,$FF800E.l
	bne.b	.loop
	move.w	#$1D,$FF8026.l
	bset	#$3,$FF800F.l
.loop2	btst	#$3,$FF800E.l
	beq.b	.loop2
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop3	btst	#$3,$FF800E.l
	bne.b	.loop3
	bclr	#$4,$FF800F.l
	jsr	$22268.l
	rts
.next	movem.l	d0/a0-a1,-(sp)
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$BBCB0,a1
	movea.l	#$C00000,a0
.loop4	btst	#$4,$FF800E.l
	bne.b	.loop4
	move.w	#$30,$FF8026.l
	move.l	#$C0000000,$FF8028.l
	bset	#$3,$FF800F.l
.loop5	btst	#$3,$FF800E.l
	beq.b	.loop5
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop6	btst	#$3,$FF800E.l
	bne.b	.loop6
	bclr	#$4,$FF800F.l
	moveq	#$1F,d0
.loop7	btst	#$4,$FF800E.l
	bne.b	.loop7
	move.w	#$33,$FF8026.l
	move.l	(a1)+,$FF8028.l
	bset	#$3,$FF800F.l
.loop8	btst	#$3,$FF800E.l
	beq.b	.loop8
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop9	btst	#$3,$FF800E.l
	bne.b	.loop9
	bclr	#$4,$FF800F.l
	dbra	d0,.loop7
	st.b	(palcount).l
	move.w	(sp)+,(disflags).l
	movem.l	(sp)+,d0/a0-a1
	rts
	movem.l	d0/a0-a1,-(sp)
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$BBCB0,a1
	movea.l	#$C00000,a0
.loop10	btst	#$7,$FF800E.l
	bne.b	.loop10
	move.l	#$C0000000,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
.loop11	btst	#$6,$FF800E.l
	beq.b	.loop11
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop12	btst	#$6,$FF800E.l
	bne.b	.loop12
	bclr	#$7,$FF800F.l
	moveq	#$1F,d0
.loop13	btst	#$7,$FF800E.l
	bne.b	.loop13
	move.l	(a1)+,$FF8022.l
	move.w	#$E,$FF8020.l
	bset	#$6,$FF800F.l
.loop14	btst	#$6,$FF800E.l
	beq.b	.loop14
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop15	btst	#$6,$FF800E.l
	bne.b	.loop15
	bclr	#$7,$FF800F.l
	dbra	d0,.loop13
	st.b	(palcount).l
	move.w	(sp)+,(disflags).l
	movem.l	(sp)+,d0/a0-a1
	rts
randomd0s
	move.w	d0,-(sp)
	asl.w	#$1,d0
	bsr.w	randomd0
	sub.w	(sp)+,d0
	rts
randomd0						;d0 = range. Return random number in d0 (0 <= d0 < range)
	movem.l	d0-d2,-(sp)
	move.w	$18C1A.l,d0
	move.w	d0,d1
	move.w	$18C18.l,d2
	mulu.w	#$E62D,d0
	mulu.w	#$BB40,d1
	mulu.w	#$E62D,d2
	add.w	d2,d1
	swap	d0
	add.w	d1,d0
	swap	d0
	addq.l	#$1,d0
	move.l	d0,$18C18.l
	asr.l	#$8,d0
	mulu.w	$2(sp),d0
	swap	d0
	addq.w	#$4,sp
	movem.l	(sp)+,d1-d2
	rts
Sroot						;Square Root, this returns (d0.L)^.5 in d0. Large values use a binary
	
	tst.l	d0
	beq.w	rtss2
	cmpi.l	#$640,d0
	bhi.w	.m2
	move.l	d1,-(sp)
	moveq	#-1,d1
.0	addq.w	#$2,d1
	sub.w	d1,d0
	bcc.w	.0
	lsr.w	#$1,d1
	move.w	d1,d0
	move.l	(sp)+,d1
	rts
.m2	movem.l	d1-d4,-(sp)
	moveq	#$9,d3
	move.w	#$8000,d1
	cmpi.l	#$F00000,d0
	bhi.w	.big
	move.l	d0,d1
	lsr.l	#$8,d1
	addi.w	#$2,d1
.top	move.w	d1,d2
	move.l	d0,d1
	divu.w	d2,d1
	add.w	d2,d1
	lsr.w	#$1,d1
	cmp.w	d1,d2
	dbeq	d3,.top
.done	move.w	d1,d0
	movem.l	(sp)+,d1-d4
	rts
.big	moveq	#$0,d1
	moveq	#-1,d2
.bs	move.w	d1,d3
	add.w	d2,d3
	roxr.w	#$1,d3
	cmp.w	d3,d1
	beq.w	.done
	move.w	d3,d4
	mulu.w	d3,d3
	cmp.l	d3,d0
	bcc.w	.lo
	move.w	d4,d2
	bra.w	.bs
.lo	move.w	d4,d1
	bra.w	.bs
sfx						;play sound effect number. One word passed on stack
	move.l	d0,-(sp)
	move.w	$8(sp),d0
	bmi.w	.none
	move.w	d0,(lastsfx).l
	move.w	d0,$FF8022.l
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$26,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
.none	movem.l	(sp)+,d0
	move.l	(sp),$2(sp)
	addq.w	#$2,sp
	rts
	dc.w	$2F00,$302F,$0008,$33C0,$00FF,$8028,$0839,$0004
	dc.w	$00FF,$800E,$66F6,$33FC,$0034,$00FF,$8026,$08F9
	dc.w	$0003,$00FF,$800F,$0839,$0003,$00FF,$800E,$67F6
	dc.w	$08F9,$0004,$00FF,$800F,$08B9,$0003,$00FF,$800F
	dc.w	$0839,$0003,$00FF,$800E,$66F6,$08B9,$0004,$00FF
	dc.w	$800F,$4CDF,$0001,$2F57,$0002,$544F,$4E75
song						;play song number. One word passed on stack
	move.l	d0,-(sp)
	move.w	$8(sp),d0
	cmpi.w	#$30,d0
	blt.w	.none
	cmpi.w	#$78,d0
	bge.w	.none
	move.w	#$1,$1745C.l
	subi.w	#$29,d0
	move.w	d0,$1745E.l
.none	movem.l	(sp)+,d0
	move.l	(sp),$2(sp)
	addq.w	#$2,sp
	rts
	movem.l	d0-d2/a0-a1,-(sp)
	move.w	#$80,d0
	jsr	$5F22.w
	bcs.w	.next7
	move.w	#$81,d0
	jsr	$5F22.w
	move.w	(a0),d2
	andi.w	#$FF00,d2
	cmpi.w	#$500,d2
	bne.s	.next
	move.w	#$2,$1745E.l
	bra.s	.next4
.next	cmpi.w	#$100,d2
	bne.s	.next2
	move.b	$7(a0),d0
	cmpi.b	#$FF,d0
	beq.s	.next2
	cmpi.b	#$2,d0
	beq.s	.next2
	cmpi.b	#$7,$7(a0)
	bge.s	.next2
	move.w	#$2,$1745E.l
	bra.s	.next4
.next2	cmpi.w	#$0,d2
	bne.s	.next3
	bra.w	.next4
.next3	tst.w	$1745C.l
	ble.s	.next7
.next4	move.w	#$0,$1745C.l
	move.w	$1745E.l,$19364.l
	cmpi.w	#$2,$1745E.l
	bne.s	.next5
	move.w	#$300,d1
	move.w	#$85,d0
	jsr	$5F22.w
	move.w	$1745E.l,$19364.l
	bra.s	.next6
.next5	move.w	#$400,d1
	move.w	#$85,d0
	jsr	$5F22.w
.next6	lea.l	$19364.l,a0
	move.w	#$12,d0
	jsr	$5F22.w
	move.w	#$12,d0
	lea.l	$19364.l,a0
	jsr	$5F22.w
.next7	movem.l	(sp)+,d0-d2/a0-a1
	rts
waitx						;wait d0 vblanks or until input from either joystick. Return joystick
	
	
	clr.w	(waitxpad).l
	neg.w	d0
	move.w	d0,(ScoutSubStatus).l
.wait	bsr.w	ReadJoy1
	or.w	d3,(waitxpad).l
	tst.w	d1
	bne.w	rtss2
	bsr.w	ReadJoy2
	or.w	d3,(waitxpad).l
	tst.w	d1
	bne.w	rtss2
	tst.w	$18BF8.l
	beq.w	.1
	bsr.w	ReadJoy3
	or.w	d3,(waitxpad).l
	tst.w	d1
	bne.w	rtss2
	bsr.w	ReadJoy4
	or.w	d3,(waitxpad).l
	tst.w	d1
	bne.w	rtss2
.1	move.w	(ScoutSubStatus).l,d0
.0	cmp.w	(ScoutSubStatus).l,d0
	beq.w	.0
	tst.w	d0
	bmi.w	.wait		;still counting up to zero
	rts
waitxsr						;Wait d0 vblanks while the zamboni crosses
	movem.l	d4-d7/a0-a3,-(sp)
	neg.w	d0
	move.w	d0,(ScoutSubStatus).l
.wait	cmpi.w	#$708,$17CE2.l
	bhi.w	.nz
	addi.w	#$1,$17CE2.l
.nz	moveq	#$1,d7
	jsr	(updatecrowdf).l
	jsr	(RunArenaAnim).l
	clr.w	$17F94.l
	bclr	#$1,$17F6A.l
	bsr.w	ReadJoy1
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	bne.w	.key
	clr.w	$17F94.l
	bset	#$1,$17F6A.l
	bsr.w	ReadJoy2
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	bne.w	.key
	tst.w	$18BF8.l
	beq.w	.vid
	bclr	#$1,$17F6A.l
	move.w	#$3,$17F94.l
	bsr.w	ReadJoy3
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	bne.w	.key
	tst.w	$18BF8.l
	beq.w	.vid
	bset	#$1,$17F6A.l
	move.w	#$4,$17F94.l
	bsr.w	ReadJoy4
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	beq.w	.vid
.key	move.w	(ScoutSubStatus).l,d0
	cmpi.w	#$FF88,d0
	blt.w	.menu
	moveq	#-120,d0
.menu	movem.w	d0,-(sp)
	jsr	(HandleMenuInput).l
	bne.w	.resume
	adda.w	#$2,sp
	bset	#$7,d1
	bra.w	.next
.resume	move.w	(sp)+,(ScoutSubStatus).l
.vid	bsr.w	setvideo
	move.w	(ScoutSubStatus).l,d0
.0	cmp.w	(ScoutSubStatus).l,d0
	beq.w	.0
	tst.w	d0
	bmi.w	.wait
.next	movem.l	(sp)+,d4-d7/a0-a3
	rts
waitjoy						;wait for either joystick input. Return d1 = new button presses. it as
	
	move.w	(ScoutSubStatus).l,d0
.0	cmp.w	(ScoutSubStatus).l,d0
	beq.w	.0
	bsr.w	orjoy
	beq.w	waitjoy
	rts
orjoy						;return d1 = new button presses from either joystick
	tst.w	$18BF8.l
	bne.w	.4way
	bsr.w	ReadJoy1
	move.w	d1,-(sp)
	bsr.w	ReadJoy2
	or.w	(sp)+,d1
	rts
.4way	bsr.w	ReadJoy1
	move.w	d1,-(sp)
	bsr.w	ReadJoy2
	move.w	d1,-(sp)
	bsr.w	ReadJoy3
	move.w	d1,-(sp)
	bsr.w	ReadJoy4
	or.w	(sp)+,d1
	or.w	(sp)+,d1
	or.w	(sp)+,d1
	rts
nodiag						;eliminate diagonal direction presses: if held directions (d3 bits 0-3)
	
	movem.l	d0/d4-d5,-(sp)
	moveq	#$3,d4
	move.w	d3,d0
	andi.w	#$F,d0
	beq.w	.ok
.0	clr.w	d5
	bset	d4,d5
	cmp.w	d5,d0
	dbeq	d4,.0
	beq.w	.ok
	andi.w	#$FFF0,d1
.ok	movem.l	(sp)+,d0/d4-d5
	rts
ProcessInputWithRepeat						;nodiag, then key repeat on d1-d3
	bsr.w	nodiag
	tst.w	d3
	beq.w	rtss2
	tst.w	d2
	bne.w	.chg
	subi.w	#$1,$17478.l
	bpl.w	rtss2
	move.w	#$4,$17478.l
	move.w	d3,d1
	rts
.chg	move.w	#$F,$17478.l
	rts
ReadJoy1						;read controller 1 from the byte ReadPads left in PadRaw1. Return d0 =
	
	
	move.b	$17E46.l,d0
	bsr.w	ReadJoy
	move.w	$17E3E.l,d2
	move.w	d1,$17E3E.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1		;d1 = changed and now down = new presses
	rts
ReadJoy2						;read controller 2 from PadRaw2 (same as ReadJoy1 with lj2)
	move.b	$17E47.l,d0
	bsr.w	ReadJoy
	move.w	$17E40.l,d2
	move.w	d1,$17E40.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoy3	move.b	$17E48.l,d0
	bsr.w	ReadJoy
	move.w	$17E42.l,d2
	move.w	d1,$17E42.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoy4	move.b	$17E49.l,d0
	bsr.w	ReadJoy
	move.w	$17E44.l,d2
	move.w	d1,$17E44.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoy	not.b	d0
	clr.w	d1
	move.b	d0,d1
	move.w	d1,-(sp)
	andi.w	#$F0,d0
	andi.w	#$F,d1
	lea.l	ReadJoyTbl1.l,a0
	move.b	(a0,d1.w),d1
	or.w	d1,d0
	move.w	(sp)+,d1
	rts
ReadJoyTbl1	dc.w	$0800,$0408,$0607,$0508,$0201,$0308,$0808,$0808
	movem.l	d7/a0,-(sp)
	move.w	#$2,d7
	movea.l	#$4820A,a0
	jsr	$6044.w
	movem.l	(sp)+,d7/a0
	jsr	$375B6.l
	rts
	movem.l	d0/a0,-(sp)
	lea.l	(ScoutingReportText).l,a0
	move.l	#$2B,d0
.loop	clr.l	(a0)+
	dbra	d0,.loop
	movem.l	(sp)+,d0/a0
	rts
	dc.w	$563A,$7E00,$3E39,$0003,$75D2,$E24F,$6400,$0006
	dc.w	$0A47,$B400,$33C7,$0003,$75D2,$8FFC,$FFFF,$4847
	rts
	movem.l	d0-d1/a0,-(sp)
	movea.l	$47D88.l,a0
	move.l	a0,d1
	moveq	#$1B,d0
.loop2	add.l	d1,(a0)+
	dbra	d0,.loop2
.loop3	add.l	d1,(a0)+
	addq.l	#$2,a0
	tst.l	(a0)
	bne.w	.loop3
	addq.l	#$4,a0
	tst.l	(a0)
	bne.w	.loop3
	movem.l	(sp)+,d0-d1/a0
	rts
	movem.l	d0-d1/a0,-(sp)
	movea.l	#$80000,a0
	move.l	a0,d1
	sub.l	$47D88.l,d1
	moveq	#$1B,d0
.loop4	add.l	d1,(a0)+
	dbra	d0,.loop4
.loop5	add.l	d1,(a0)+
	addq.l	#$2,a0
	tst.l	(a0)
	bne.w	.loop5
	addq.l	#$4,a0
	tst.l	(a0)
	bne.w	.loop5
	movem.l	(sp)+,d0-d1/a0
	rts
CompareHotColdTotals						;Compare the teams' hot / cold totals (GetHotColdTotal into TempWord1 /
									;TempWord2): awayhotter = 1 when the away total is
									;higher; d0 = -1, $22 or $23 by the difference (ScoutingReport text
									;"Lately ... has been playing (extremely) well")
	movem.l	d0-d3/a0-a4,-(sp)
	movea.l	$47D88.l,a0
	movea.l	#$80000,a1
	move.w	#$88B8,d0
.loop	move.l	(a0)+,(a1)+
	dbra	d0,.loop
	movea.l	$47D88.l,a0
	jsr	$37620.l
	movea.l	a0,a1
	adda.l	#$7D0,a1
	movea.l	#$80000,a2
	move.w	(VisTeam).l,d0
	bsr.s	.next
	move.w	(HomeTeam).l,d0
	bsr.s	.next
	adda.l	#$EA60,a0
	move.w	#$2,d7
	jsr	$6044.w
	movem.l	(sp)+,d0-d3/a0-a4
	rts
.next	move.w	d0,d2
	asl.w	#$2,d2
	move.l	(a0,d2.w),d1
	sub.l	a0,d1
.loop2	move.w	#$12C,d3
	movea.l	(a2,d1.w),a3
	movea.l	a1,a4
.loop3	move.l	(a3)+,(a1)+
	dbra	d3,.loop3
	move.l	a4,(a0,d1.w)
	addq.w	#$6,d1
	tst.l	(a0,d1.w)
	bne.w	.loop2
	rts
	movem.l	d0-d1/a0,-(sp)
	movea.l	(TeamLogoBitmaps).l,a0
	move.l	a0,d1
	move.l	#$1B,d0
.loop4	add.l	d1,(a0)+
	dbra	d0,.loop4
	movem.l	(sp)+,d0-d1/a0
	rts
	movem.l	d0-d7/a0-a2,-(sp)
	bclr	#$5,$FF800F.l
.loop5	btst	#$7,$FF800E.l
	bne.b	.loop5
	move.w	#$3D,$FF8020.l
	bset	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	beq.b	.loop6
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop7	btst	#$6,$FF800E.l
	bne.b	.loop7
	bclr	#$7,$FF800F.l
	bset	#$5,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a2
	rts
	movem.l	d0-d7/a0-a2,-(sp)
	moveq	#$0,d0
	bsr.w	setVram
	movem.l	(sp)+,d0-d7/a0-a2
	rts
DoDMApro
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	bsr.w	DoDMAProQueue
	move.w	(sp)+,(disflags).l
	rts
; Queues a DMA command in the list at $19360.
DoDMAProQueue
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	beq.s	.next
	move.w	#$1,-(a6)
	bra.s	.next2
.next	move.w	#$0,-(a6)
.next2	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movem.l	d2-d3/a1-a2,-(sp)
	cmpa.l	#$80000,a0
	bge.w	.next3
	move.l	d0,d3
	lsr.w	#$1,d3
	lea.l	(ThreeStars).l,a2
.loop	move.l	(a0)+,(a2)+
	dbra	d3,.loop
	lea.l	(ThreeStars).l,a0
.next3	lea.l	$C00004.l,a1
	move.l	(a0),$BBC96.l
	move.l	d1,$BBC9A.l
	adda.l	#$180002,a0
	move.w	#$8154,$BBC88.l
	move.w	#$8F02,$BBC8A.l
	move.w	#$9300,d2
	move.b	d0,d2
	move.w	d2,$BBC8C.l
	move.w	#$9400,d2
	lsr.w	#$8,d0
	move.b	d0,d2
	move.w	d2,$BBC8E.l
	move.l	a0,d0
	lsr.l	#$1,d0
	move.w	#$9500,d2
	move.b	d0,d2
	move.w	d2,$BBC90.l
	lsr.l	#$8,d0
	move.w	#$9600,d2
	move.b	d0,d2
	move.w	d2,$BBC92.l
	lsr.l	#$8,d0
	andi.b	#$7F,d0
	move.w	#$9700,d2
	move.b	d0,d2
	move.w	d2,$BBC94.l
	clr.l	d0
	move.w	d1,d0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	move.l	d0,d3
	ori.l	#$804000,d0
	move.l	d0,$BBC9E.l
	jsr	$222C2.l
.loop2	btst	#$7,$FF800E.l
	bne.b	.loop2
	move.w	#$8,$FF8020.l
	bset	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	beq.b	.loop3
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop4	btst	#$6,$FF800E.l
	bne.b	.loop4
	bclr	#$7,$FF800F.l
	jsr	$22268.l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.next4
	bset	#$5,$FF800F.l
	bra.s	.next5
.next4	bclr	#$5,$FF800F.l
.next5	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movem.l	(sp)+,d2-d3/a1-a2
	rts
	movem.l	d2-d3/a1-a2,-(sp)
	cmpa.l	#$80000,a0
	bge.w	.next6
	move.l	d0,d3
	lsr.w	#$1,d3
	lea.l	(ThreeStars).l,a2
.loop5	move.l	(a0)+,(a2)+
	dbra	d3,.loop5
	lea.l	(ThreeStars).l,a0
.next6	lea.l	$C00004.l,a1
	move.l	(a0),$BBC96.l
	move.l	d1,$BBC9A.l
	adda.l	#$180002,a0
	move.w	#$8154,$BBC88.l
	move.w	#$8F02,$BBC8A.l
	move.w	#$9300,d2
	move.b	d0,d2
	move.w	d2,$BBC8C.l
	move.w	#$9400,d2
	lsr.w	#$8,d0
	move.b	d0,d2
	move.w	d2,$BBC8E.l
	move.l	a0,d0
	lsr.l	#$1,d0
	move.w	#$9500,d2
	move.b	d0,d2
	move.w	d2,$BBC90.l
	lsr.l	#$8,d0
	move.w	#$9600,d2
	move.b	d0,d2
	move.w	d2,$BBC92.l
	lsr.l	#$8,d0
	andi.b	#$7F,d0
	move.w	#$9700,d2
	move.b	d0,d2
	move.w	d2,$BBC94.l
	clr.l	d0
	move.w	d1,d0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	move.l	d0,d3
	ori.l	#$804000,d0
	move.l	d0,$BBC9E.l
	jsr	$222C2.l
.loop6	btst	#$4,$FF800E.l
	bne.b	.loop6
	move.w	#$32,$FF8026.l
	bset	#$3,$FF800F.l
.loop7	btst	#$3,$FF800E.l
	beq.b	.loop7
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop8	btst	#$3,$FF800E.l
	bne.b	.loop8
	bclr	#$4,$FF800F.l
	jsr	$22268.l
	movem.l	(sp)+,d2-d3/a1-a2
	rts
DoDMA_nd2						;vram to vram copy by dma, protected from vblank
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	beq.s	.next
	move.w	#$1,-(a6)
	bra.s	.next2
.next	move.w	#$0,-(a6)
.next2	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	move.l	d0,$BBC88.l
	move.l	d1,$BBC8C.l
	move.l	d2,$BBC90.l
	jsr	$222C2.l
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1E,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	jsr	$22268.l
	move.w	(sp)+,(disflags).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.next3
	bset	#$5,$FF800F.l
	bra.s	.next4
.next3	bclr	#$5,$FF800F.l
.next4	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
; Queues a DMA command in the list at $19360.
DoDMANd2Queue
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	beq.s	.next
	move.w	#$1,-(a6)
	bra.s	.next2
.next	move.w	#$0,-(a6)
.next2	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.l	d0,$BBC88.l
	move.l	d1,$BBC8C.l
	move.l	d2,$BBC90.l
	jsr	$222C2.l
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1F,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	jsr	$22268.l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.next3
	bset	#$5,$FF800F.l
	bra.s	.next4
.next3	bclr	#$5,$FF800F.l
.next4	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
