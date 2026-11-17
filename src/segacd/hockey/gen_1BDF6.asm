Sub_36DF6
	tst.w	(palcount).l
	bmi.w	rtss2
	cmpi.w	#$64,(palcount).l
	beq.w	L1BEA0
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
L1BE52	btst	#$4,$FF800E.l
	bne.b	L1BE52
	move.w	#$1D,$FF8026.l
	bset	#$3,$FF800F.l
L1BE6C	btst	#$3,$FF800E.l
	beq.b	L1BE6C
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
L1BE86	btst	#$3,$FF800E.l
	bne.b	L1BE86
	bclr	#$4,$FF800F.l
	jsr	$22268.l
	rts
L1BEA0	movem.l	d0/a0-a1,-(sp)
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$BBCB0,a1
	movea.l	#$C00000,a0
L1BEBE	btst	#$4,$FF800E.l
	bne.b	L1BEBE
	move.w	#$30,$FF8026.l
	move.l	#$C0000000,$FF8028.l
	bset	#$3,$FF800F.l
L1BEE2	btst	#$3,$FF800E.l
	beq.b	L1BEE2
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
L1BEFC	btst	#$3,$FF800E.l
	bne.b	L1BEFC
	bclr	#$4,$FF800F.l
	moveq	#$1F,d0
L1BF10	btst	#$4,$FF800E.l
	bne.b	L1BF10
	move.w	#$33,$FF8026.l
	move.l	(a1)+,$FF8028.l
	bset	#$3,$FF800F.l
L1BF30	btst	#$3,$FF800E.l
	beq.b	L1BF30
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
L1BF4A	btst	#$3,$FF800E.l
	bne.b	L1BF4A
	bclr	#$4,$FF800F.l
	dbra	d0,L1BF10
	st.b	(palcount).l
	move.w	(sp)+,(disflags).l
	movem.l	(sp)+,d0/a0-a1
	rts
	movem.l	d0/a0-a1,-(sp)
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$BBCB0,a1
	movea.l	#$C00000,a0
L1BF90	btst	#$7,$FF800E.l
	bne.b	L1BF90
	move.l	#$C0000000,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
L1BFB4	btst	#$6,$FF800E.l
	beq.b	L1BFB4
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1BFCE	btst	#$6,$FF800E.l
	bne.b	L1BFCE
	bclr	#$7,$FF800F.l
	moveq	#$1F,d0
L1BFE2	btst	#$7,$FF800E.l
	bne.b	L1BFE2
	move.l	(a1)+,$FF8022.l
	move.w	#$E,$FF8020.l
	bset	#$6,$FF800F.l
L1C002	btst	#$6,$FF800E.l
	beq.b	L1C002
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1C01C	btst	#$6,$FF800E.l
	bne.b	L1C01C
	bclr	#$7,$FF800F.l
	dbra	d0,L1BFE2
	st.b	(palcount).l
	move.w	(sp)+,(disflags).l
	movem.l	(sp)+,d0/a0-a1
	rts
Sub_37044
	move.w	d0,-(sp)
	asl.w	#$1,d0
	bsr.w	randomd0
	sub.w	(sp)+,d0
	rts
randomd0
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
Sroot
	tst.l	d0
	beq.w	rtss2
	cmpi.l	#$640,d0
	bhi.w	L1C0B2
	move.l	d1,-(sp)
	moveq	#-1,d1
L1C0A2	addq.w	#$2,d1
	sub.w	d1,d0
	bcc.w	L1C0A2
	lsr.w	#$1,d1
	move.w	d1,d0
	move.l	(sp)+,d1
	rts
L1C0B2	movem.l	d1-d4,-(sp)
	moveq	#$9,d3
	move.w	#$8000,d1
	cmpi.l	#$F00000,d0
	bhi.w	L1C0E6
	move.l	d0,d1
	lsr.l	#$8,d1
	addi.w	#$2,d1
L1C0CE	move.w	d1,d2
	move.l	d0,d1
	divu.w	d2,d1
	add.w	d2,d1
	lsr.w	#$1,d1
	cmp.w	d1,d2
	dbeq	d3,L1C0CE
L1C0DE	move.w	d1,d0
	movem.l	(sp)+,d1-d4
	rts
L1C0E6	moveq	#$0,d1
	moveq	#-1,d2
L1C0EA	move.w	d1,d3
	add.w	d2,d3
	roxr.w	#$1,d3
	cmp.w	d3,d1
	beq.w	L1C0DE
	move.w	d3,d4
	mulu.w	d3,d3
	cmp.l	d3,d0
	bcc.w	L1C106
	move.w	d4,d2
	bra.w	L1C0EA
L1C106	move.w	d4,d1
	bra.w	L1C0EA
sfx
	move.l	d0,-(sp)
	move.w	$8(sp),d0
	bmi.w	L1C168
	move.w	d0,(lastsfx).l
	move.w	d0,$FF8022.l
L1C122	btst	#$7,$FF800E.l
	bne.b	L1C122
	move.w	#$26,$FF8020.l
	bset	#$6,$FF800F.l
L1C13C	btst	#$6,$FF800E.l
	beq.b	L1C13C
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1C156	btst	#$6,$FF800E.l
	bne.b	L1C156
	bclr	#$7,$FF800F.l
L1C168	movem.l	(sp)+,d0
	move.l	(sp),$2(sp)
	addq.w	#$2,sp
	rts
	dc.w	$2F00,$302F,$0008,$33C0,$00FF,$8028,$0839,$0004
	dc.w	$00FF,$800E,$66F6,$33FC,$0034,$00FF,$8026,$08F9
	dc.w	$0003,$00FF,$800F,$0839,$0003,$00FF,$800E,$67F6
	dc.w	$08F9,$0004,$00FF,$800F,$08B9,$0003,$00FF,$800F
	dc.w	$0839,$0003,$00FF,$800E,$66F6,$08B9,$0004,$00FF
	dc.w	$800F,$4CDF,$0001,$2F57,$0002,$544F,$4E75
song
	move.l	d0,-(sp)
	move.w	$8(sp),d0
	cmpi.w	#$30,d0
	blt.w	L1C1FA
	cmpi.w	#$78,d0
	bge.w	L1C1FA
	move.w	#$1,$1745C.l
	subi.w	#$29,d0
	move.w	d0,$1745E.l
L1C1FA	movem.l	(sp)+,d0
	move.l	(sp),$2(sp)
	addq.w	#$2,sp
	rts
	movem.l	d0-d2/a0-a1,-(sp)
	move.w	#$80,d0
	jsr	$5F22.w
	bcs.w	L1C2CA
	move.w	#$81,d0
	jsr	$5F22.w
	move.w	(a0),d2
	andi.w	#$FF00,d2
	cmpi.w	#$500,d2
	dc.w	$660A
	move.w	#$2,$1745E.l
	dc.w	$603A
L1C234	cmpi.w	#$100,d2
	dc.w	$6622
	move.b	$7(a0),d0
	cmpi.b	#$FF,d0
	dc.w	$6718
	cmpi.b	#$2,d0
	dc.w	$6712
	cmpi.b	#$7,$7(a0)
	dc.w	$6C0A
	move.w	#$2,$1745E.l
	dc.w	$6012
L1C25C	cmpi.w	#$0,d2
	dc.w	$6604
	bra.w	L1C26E
L1C266	tst.w	$1745C.l
	dc.w	$6F5C
L1C26E	move.w	#$0,$1745C.l
	move.w	$1745E.l,$19364.l
	cmpi.w	#$2,$1745E.l
	dc.w	$6618
	move.w	#$300,d1
	move.w	#$85,d0
	jsr	$5F22.w
	move.w	$1745E.l,$19364.l
	dc.w	$600C
L1C2A2	move.w	#$400,d1
	move.w	#$85,d0
	jsr	$5F22.w
L1C2AE	lea.l	$19364.l,a0
	move.w	#$12,d0
	jsr	$5F22.w
	move.w	#$12,d0
	lea.l	$19364.l,a0
	jsr	$5F22.w
L1C2CA	movem.l	(sp)+,d0-d2/a0-a1
	rts
waitx
	clr.w	(waitxpad).l
	neg.w	d0
	move.w	d0,(ScoutSubStatus).l
L1C2DE	bsr.w	ReadJoy1
	or.w	d3,(waitxpad).l
	tst.w	d1
	bne.w	rtss2
	bsr.w	ReadJoy2
	or.w	d3,(waitxpad).l
	tst.w	d1
	bne.w	rtss2
	dc.w	$4A79,$0001,$8BF8
	beq.w	L1C328
	bsr.w	L1C52C
	or.w	d3,(waitxpad).l
	tst.w	d1
	bne.w	rtss2
	bsr.w	L1C54A
	or.w	d3,(waitxpad).l
	tst.w	d1
	bne.w	rtss2
L1C328	move.w	(ScoutSubStatus).l,d0
L1C32E	cmp.w	(ScoutSubStatus).l,d0
	beq.w	L1C32E
	tst.w	d0
	bmi.w	L1C2DE
	rts
waitxsr
	movem.l	d4-d7/a0-a3,-(sp)
	neg.w	d0
	move.w	d0,(ScoutSubStatus).l
L1C34C	cmpi.w	#$708,$17CE2.l
	bhi.w	L1C360
	addi.w	#$1,$17CE2.l
L1C360	moveq	#$1,d7
	jsr	(updatecrowdf).l
	jsr	(RunArenaAnim).l
	dc.w	$4279,$0001,$7F94
	bclr	#$1,$17F6A.l
	bsr.w	ReadJoy1
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	bne.w	L1C3F6
	dc.w	$4279,$0001,$7F94
	bset	#$1,$17F6A.l
	bsr.w	ReadJoy2
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	bne.w	L1C3F6
	dc.w	$4A79,$0001,$8BF8
	beq.w	L1C426
	bclr	#$1,$17F6A.l
	dc.w	$33FC,$0003,$0001,$7F94
	bsr.w	L1C52C
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	bne.w	L1C3F6
	dc.w	$4A79,$0001,$8BF8
	beq.w	L1C426
	bset	#$1,$17F6A.l
	dc.w	$33FC,$0004,$0001,$7F94
	bsr.w	L1C54A
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	beq.w	L1C426
L1C3F6	move.w	(ScoutSubStatus).l,d0
	cmpi.w	#$FF88,d0
	blt.w	L1C406
	moveq	#-120,d0
L1C406	movem.w	d0,-(sp)
	jsr	(HandleMenuInput).l
	bne.w	L1C420
	adda.w	#$2,sp
	bset	#$7,d1
	bra.w	L1C440
L1C420	move.w	(sp)+,(ScoutSubStatus).l
L1C426	bsr.w	Sub_3DD16
	move.w	(ScoutSubStatus).l,d0
L1C430	cmp.w	(ScoutSubStatus).l,d0
	beq.w	L1C430
	tst.w	d0
	bmi.w	L1C34C
L1C440	movem.l	(sp)+,d4-d7/a0-a3
	rts
waitjoy
	move.w	(ScoutSubStatus).l,d0
L1C44C	cmp.w	(ScoutSubStatus).l,d0
	beq.w	L1C44C
	bsr.w	orjoy
	beq.w	waitjoy
	rts
orjoy
	dc.w	$4A79,$0001,$8BF8
	bne.w	L1C478
	bsr.w	ReadJoy1
	move.w	d1,-(sp)
	bsr.w	ReadJoy2
	or.w	(sp)+,d1
	rts
L1C478	bsr.w	ReadJoy1
	move.w	d1,-(sp)
	bsr.w	ReadJoy2
	move.w	d1,-(sp)
	bsr.w	L1C52C
	move.w	d1,-(sp)
	bsr.w	L1C54A
	or.w	(sp)+,d1
	or.w	(sp)+,d1
	or.w	(sp)+,d1
	rts
nodiag
	movem.l	d0/d4-d5,-(sp)
	moveq	#$3,d4
	move.w	d3,d0
	andi.w	#$F,d0
	beq.w	L1C4B8
L1C4A6	clr.w	d5
	bset	d4,d5
	cmp.w	d5,d0
	dbeq	d4,L1C4A6
	beq.w	L1C4B8
	andi.w	#$FFF0,d1
L1C4B8	movem.l	(sp)+,d0/d4-d5
	rts
ProcessInputWithRepeat
	bsr.w	nodiag
	tst.w	d3
	beq.w	rtss2
	tst.w	d2
	bne.w	L1C4E6
	subi.w	#$1,$17478.l
	bpl.w	rtss2
	move.w	#$4,$17478.l
	move.w	d3,d1
	rts
L1C4E6	move.w	#$F,$17478.l
	rts
ReadJoy1
	dc.w	$1039,$0001,$7E46
	bsr.w	L1C568
	move.w	$17E3E.l,d2
	move.w	d1,$17E3E.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoy2
	dc.w	$1039,$0001,$7E47
	bsr.w	L1C568
	move.w	$17E40.l,d2
	move.w	d1,$17E40.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
L1C52C	dc.w	$1039,$0001,$7E48
	bsr.w	L1C568
	move.w	$17E42.l,d2
	move.w	d1,$17E42.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
L1C54A	dc.w	$1039,$0001,$7E49
	bsr.w	L1C568
	move.w	$17E44.l,d2
	move.w	d1,$17E44.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
L1C568	not.b	d0
	clr.w	d1
	move.b	d0,d1
	move.w	d1,-(sp)
	andi.w	#$F0,d0
	andi.w	#$F,d1
	lea.l	$37588.l,a0
	move.b	(a0,d1.w),d1
	or.w	d1,d0
	move.w	(sp)+,d1
	rts
	dc.w	$0800,$0408,$0607,$0508,$0201,$0308,$0808,$0808
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
L1C5C6	clr.l	(a0)+
	dbra	d0,L1C5C6
	movem.l	(sp)+,d0/a0
	rts
	dc.w	$563A,$7E00,$3E39,$0003,$75D2,$E24F,$6400,$0006
	dc.w	$0A47,$B400,$33C7,$0003,$75D2,$8FFC,$FFFF,$4847
	dc.w	$4E75
	movem.l	d0-d1/a0,-(sp)
	movea.l	$47D88.l,a0
	move.l	a0,d1
	moveq	#$1B,d0
L1C602	add.l	d1,(a0)+
	dbra	d0,L1C602
L1C608	add.l	d1,(a0)+
	addq.l	#$2,a0
	tst.l	(a0)
	bne.w	L1C608
	addq.l	#$4,a0
	tst.l	(a0)
	bne.w	L1C608
	movem.l	(sp)+,d0-d1/a0
	rts
	movem.l	d0-d1/a0,-(sp)
	movea.l	#$80000,a0
	move.l	a0,d1
	sub.l	$47D88.l,d1
	moveq	#$1B,d0
L1C634	add.l	d1,(a0)+
	dbra	d0,L1C634
L1C63A	add.l	d1,(a0)+
	addq.l	#$2,a0
	tst.l	(a0)
	bne.w	L1C63A
	addq.l	#$4,a0
	tst.l	(a0)
	bne.w	L1C63A
	movem.l	(sp)+,d0-d1/a0
	rts
CompareHotColdTotals
	movem.l	d0-d3/a0-a4,-(sp)
	movea.l	$47D88.l,a0
	movea.l	#$80000,a1
	move.w	#$88B8,d0
L1C666	move.l	(a0)+,(a1)+
	dbra	d0,L1C666
	movea.l	$47D88.l,a0
	jsr	$37620.l
	movea.l	a0,a1
	adda.l	#$7D0,a1
	movea.l	#$80000,a2
	move.w	(VisTeam).l,d0
	dc.w	$611C
	move.w	(HomeTeam).l,d0
	dc.w	$6114
	adda.l	#$EA60,a0
	move.w	#$2,d7
	jsr	$6044.w
	movem.l	(sp)+,d0-d3/a0-a4
	rts
L1C6AA	move.w	d0,d2
	asl.w	#$2,d2
	move.l	(a0,d2.w),d1
	sub.l	a0,d1
L1C6B4	move.w	#$12C,d3
	movea.l	(a2,d1.w),a3
	movea.l	a1,a4
L1C6BE	move.l	(a3)+,(a1)+
	dbra	d3,L1C6BE
	move.l	a4,(a0,d1.w)
	addq.w	#$6,d1
	tst.l	(a0,d1.w)
	bne.w	L1C6B4
	rts
	movem.l	d0-d1/a0,-(sp)
	movea.l	(TeamLogoBitmaps).l,a0
	move.l	a0,d1
	move.l	#$1B,d0
L1C6E6	add.l	d1,(a0)+
	dbra	d0,L1C6E6
	movem.l	(sp)+,d0-d1/a0
	rts
	movem.l	d0-d7/a0-a2,-(sp)
	bclr	#$5,$FF800F.l
L1C6FE	btst	#$7,$FF800E.l
	bne.b	L1C6FE
	move.w	#$3D,$FF8020.l
	bset	#$6,$FF800F.l
L1C718	btst	#$6,$FF800E.l
	beq.b	L1C718
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1C732	btst	#$6,$FF800E.l
	bne.b	L1C732
	bclr	#$7,$FF800F.l
	bset	#$5,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a2
	rts
	movem.l	d0-d7/a0-a2,-(sp)
	moveq	#$0,d0
	bsr.w	setVram
	movem.l	(sp)+,d0-d7/a0-a2
	rts
Sub_37762
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	bsr.w	Sub_3777C
	move.w	(sp)+,(disflags).l
	rts
Sub_3777C
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	dc.w	$6706
	move.w	#$1,-(a6)
	dc.w	$6004
L1C794	move.w	#$0,-(a6)
L1C798	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movem.l	d2-d3/a1-a2,-(sp)
	cmpa.l	#$80000,a0
	bge.w	L1C7CC
	move.l	d0,d3
	lsr.w	#$1,d3
	lea.l	(ThreeStars).l,a2
L1C7C0	move.l	(a0)+,(a2)+
	dbra	d3,L1C7C0
	lea.l	(ThreeStars).l,a0
L1C7CC	lea.l	$C00004.l,a1
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
L1C85A	btst	#$7,$FF800E.l
	bne.b	L1C85A
	move.w	#$8,$FF8020.l
	bset	#$6,$FF800F.l
L1C874	btst	#$6,$FF800E.l
	beq.b	L1C874
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1C88E	btst	#$6,$FF800E.l
	bne.b	L1C88E
	bclr	#$7,$FF800F.l
	jsr	$22268.l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	dc.w	$670A
	bset	#$5,$FF800F.l
	dc.w	$6008
L1C8BC	bclr	#$5,$FF800F.l
L1C8C4	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movem.l	(sp)+,d2-d3/a1-a2
	rts
	movem.l	d2-d3/a1-a2,-(sp)
	cmpa.l	#$80000,a0
	bge.w	L1C8F6
	move.l	d0,d3
	lsr.w	#$1,d3
	lea.l	(ThreeStars).l,a2
L1C8EA	move.l	(a0)+,(a2)+
	dbra	d3,L1C8EA
	lea.l	(ThreeStars).l,a0
L1C8F6	lea.l	$C00004.l,a1
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
L1C984	btst	#$4,$FF800E.l
	bne.b	L1C984
	move.w	#$32,$FF8026.l
	bset	#$3,$FF800F.l
L1C99E	btst	#$3,$FF800E.l
	beq.b	L1C99E
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
L1C9B8	btst	#$3,$FF800E.l
	bne.b	L1C9B8
	bclr	#$4,$FF800F.l
	jsr	$22268.l
	movem.l	(sp)+,d2-d3/a1-a2
	rts
DoDMA_nd2
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	dc.w	$6706
	move.w	#$1,-(a6)
	dc.w	$6004
L1C9EE	move.w	#$0,-(a6)
L1C9F2	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	move.l	d0,$BBC88.l
	move.l	d1,$BBC8C.l
	move.l	d2,$BBC90.l
	jsr	$222C2.l
L1CA28	btst	#$7,$FF800E.l
	bne.b	L1CA28
	move.w	#$1E,$FF8020.l
	bset	#$6,$FF800F.l
L1CA42	btst	#$6,$FF800E.l
	beq.b	L1CA42
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1CA5C	btst	#$6,$FF800E.l
	bne.b	L1CA5C
	bclr	#$7,$FF800F.l
	jsr	$22268.l
	move.w	(sp)+,(disflags).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	dc.w	$670A
	bset	#$5,$FF800F.l
	dc.w	$6008
L1CA90	bclr	#$5,$FF800F.l
L1CA98	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
Sub_37AA2
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	dc.w	$6706
	move.w	#$1,-(a6)
	dc.w	$6004
L1CABA	move.w	#$0,-(a6)
L1CABE	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.l	d0,$BBC88.l
	move.l	d1,$BBC8C.l
	move.l	d2,$BBC90.l
	jsr	$222C2.l
L1CAE6	btst	#$7,$FF800E.l
	bne.b	L1CAE6
	move.w	#$1F,$FF8020.l
	bset	#$6,$FF800F.l
L1CB00	btst	#$6,$FF800E.l
	beq.b	L1CB00
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1CB1A	btst	#$6,$FF800E.l
	bne.b	L1CB1A
	bclr	#$7,$FF800F.l
	jsr	$22268.l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	dc.w	$670A
	bset	#$5,$FF800F.l
	dc.w	$6008
L1CB48	bclr	#$5,$FF800F.l
L1CB50	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
