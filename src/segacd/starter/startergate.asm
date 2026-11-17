; Gate array interrupt service A
GateArrayIrqA	movem.l	d0-d7/a0-a2,-(sp)
	move.w	#$1,$C450.l
	tst.w	$C44E.l
	bne.w	.next2
	bset.b	#$5,$FF800F.l
	movea.l	#$BBCB0,a1
	moveq	#$1F,d0
.loop	clr.l	(a1)+
	dbra	d0,.loop
	move.w	#$64,$C43E.l
.loop2	tst.w	$C43E.l
	bpl.w	.loop2
	move.l	#$2,d7
	movea.l	#$80000,a0
	jsr	$6044.w
	move.w	#$20,$C448.l
	lea.l	$282B4.l,a1
	move.w	$2(a1),d0
	lsl.w	#$4,d0
	move.w	d0,d2
	move.w	$C448.l,d1
	lea.l	$4(a1),a0
	jsr	(TilemapPut).l
	add.w	d2,d2
	add.w	d2,$C448.l
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$61,d0
	jsr	$6044.w
	move.l	a0,$C436.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$C436.l,a1
	move.w	$2(a1),d0
	lsl.w	#$4,d0
	move.w	d0,d2
	move.w	$C448.l,d1
	move.w	d1,d5
	lsr.w	#$5,d5
	lea.l	$4(a1),a0
	jsr	(TilemapPut).l
	add.w	d2,d2
	add.w	d2,$C448.l
	lea.l	$4(a1,d2.w),a0
	movea.l	#$BBCB0,a1
	moveq	#$1F,d0
.loop3	move.l	(a0)+,(a1)+
	dbra	d0,.loop3
	move.l	#$EEE,$BBCD2.l
	move.l	#$4440666,$BBCF2.l
	move.w	#$E000,d0
	bsr.w	GateArrayVdpAddrCmd
	move.w	(a0)+,d1
	move.w	(a0)+,d2
	movea.l	a0,a2
	subq.w	#$1,d1
	subq.w	#$1,d2
	move.w	d1,d3
	move.w	#$80,d7
	moveq	#$0,d4
	move.w	#$E000,d4
.loop4	move.l	d4,d0
	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
.loop5	btst.b	#$7,$FF800E.l
	bne.b	.loop5
	move.l	d0,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	beq.b	.loop6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop7	btst.b	#$6,$FF800E.l
	bne.b	.loop7
	bclr.b	#$7,$FF800F.l
.loop8	move.w	(a2)+,d6
	add.w	d5,d6
.loop9	btst.b	#$7,$FF800E.l
	bne.b	.loop9
	move.w	d6,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop10	btst.b	#$6,$FF800E.l
	beq.b	.loop10
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop11	btst.b	#$6,$FF800E.l
	bne.b	.loop11
	bclr.b	#$7,$FF800F.l
	dbra	d1,.loop8
	move.w	d3,d1
	add.w	d7,d4
	dbra	d2,.loop4
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$40,d0
	jsr	$6044.w
	move.l	a0,$C43A.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$C43A.l,a1
	move.w	$2(a1),d0
	lsl.w	#$3,d0
	move.l	#$11111111,d1
	lea.l	$4(a1),a1
.loop12	add.l	d1,(a1)+
	dbra	d0,.loop12
	movea.l	$C43A.l,a1
	move.w	$2(a1),d0
	lsl.w	#$4,d0
	move.w	d0,d2
	move.w	$C448.l,d1
	move.w	d1,$C44A.l
	lea.l	$4(a1),a0
	jsr	(TilemapPut).l
	move.w	#$C000,d0
	bsr.w	GateArrayVdpAddrCmd
	tst.w	$C44C.l
	bne.w	.next
	moveq	#$0,d4
	move.w	#$C31A,d4
	move.w	#$20,d5
	lsr.w	#$5,d5
	bset	#$E,d5
	moveq	#$4,d1
	move.w	d1,d3
	moveq	#$2,d2
	move.w	#$80,d7
.loop13	move.l	d4,d0
	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
.loop14	btst.b	#$7,$FF800E.l
	bne.b	.loop14
	move.l	d0,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop15	btst.b	#$6,$FF800E.l
	beq.b	.loop15
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop16	btst.b	#$6,$FF800E.l
	bne.b	.loop16
	bclr.b	#$7,$FF800F.l
.loop17	btst.b	#$7,$FF800E.l
	bne.b	.loop17
	move.w	d5,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop18	btst.b	#$6,$FF800E.l
	beq.b	.loop18
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop19	btst.b	#$6,$FF800E.l
	bne.b	.loop19
	bclr.b	#$7,$FF800F.l
	addi.w	#$1,d5
	dbra	d1,.loop17
	move.w	d3,d1
	add.w	d7,d4
	dbra	d2,.loop13
.loop20	btst.b	#$7,$FF800E.l
	bne.b	.loop20
	move.l	#$74000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop21	btst.b	#$6,$FF800E.l
	beq.b	.loop21
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop22	btst.b	#$6,$FF800E.l
	bne.b	.loop22
	bclr.b	#$7,$FF800F.l
.loop23	btst.b	#$7,$FF800E.l
	bne.b	.loop23
	move.w	#$3B,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop24	btst.b	#$6,$FF800E.l
	beq.b	.loop24
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop25	btst.b	#$6,$FF800E.l
	bne.b	.loop25
	bclr.b	#$7,$FF800F.l
	move.w	#$3B,$C444.l
	lea.l	StrWarningA(pc),a0
	move.w	#$5B,d0
	moveq	#$9,d1
.loop26	bsr.w	TilemapCellCmd
	addi.w	#$28,d0
	dbra	d1,.loop26
.next	bset.b	#$5,$FF800F.l
	move.w	#$18,$C43E.l
.loop27	tst.w	$C43E.l
	bpl.w	.loop27
	move.w	#$1,$C44E.l
.next2	tst.w	$C44C.l
	bne.w	.next7
.loop28	clr.w	$C446.l
.loop29	tst.w	$C446.l
	beq.w	.loop29
	bsr.w	UpdatePadStateSub
	cmpi.b	#$4,d1
	beq.w	.next3
	cmpi.b	#$8,d1
	beq.w	.next4
	cmpi.b	#$20,d1
	beq.w	.next5
	bra.w	.loop28
.next3	tst.w	$C442.l
	bpl.w	.loop28
	clr.w	$C442.l
	move.w	#$FFFE,$C440.l
	bra.w	.loop30
.next4	tst.w	$C442.l
	bmi.w	.loop28
	move.w	#$FFFF,$C442.l
	move.w	#$2,$C440.l
.loop30	tst.w	$C440.l
	bne.w	.loop30
	bra.w	.loop28
.next5	cmpi.w	#$FFFF,$C442.l
	beq.w	.next6
	lea.l	StrFormatting(pc),a0
	move.w	#$213,d0
	bsr.w	TilemapCellCmd
	moveq	#$3,d1
	moveq	#$F,d2
	move.w	d2,d3
	addi.w	#$A,d0
.loop31	clr.w	$C446.l
.loop32	tst.w	$C446.l
	beq.w	.loop32
	dbra	d2,.loop31
	move.w	d3,d2
	bsr.w	TilemapCellCmd
	addi.w	#$1,d0
	dbra	d1,.loop31
.next6	bra.w	.next8
.next7	move.w	#$C000,d0
	bsr.w	GateArrayVdpAddrCmd
	move.w	#$B,d1
	move.w	#$5B,d0
	lea.l	StrWarningB(pc),a0
.loop33	bsr.w	TilemapCellCmd
	addi.w	#$28,d0
	dbra	d1,.loop33
.loop34	clr.w	$C446.l
.loop35	tst.w	$C446.l
	beq.w	.loop35
	bsr.w	UpdatePadStateSub
	cmpi.b	#$20,d1
	bne.w	.loop34
.next8	movem.l	(sp)+,d0-d7/a0-a2
	rts
; Sends a VDP write address through the gate-array command.
GateArrayVdpAddrCmd	movem.l	d0-d2,-(sp)
	move.w	#$0,d1
	lsr.w	#$5,d1
	moveq	#$0,d2
	move.w	d0,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.loop	btst.b	#$7,$FF800E.l
	bne.b	.loop
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop2	btst.b	#$6,$FF800E.l
	beq.b	.loop2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	bne.b	.loop3
	bclr.b	#$7,$FF800F.l
	move.w	#$7FF,d2
.loop4	btst.b	#$7,$FF800E.l
	bne.b	.loop4
	move.w	d1,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop5	btst.b	#$6,$FF800E.l
	beq.b	.loop5
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	bne.b	.loop6
	bclr.b	#$7,$FF800F.l
	dbra	d2,.loop4
	movem.l	(sp)+,d0-d2
	rts
; Sends the VDP data through the gate array
GateArrayVdpSend	movem.l	d0-d7/a0,-(sp)
	tst.w	$C440.l
	beq.w	.next3
.loop	btst.b	#$4,$FF800E.l
	bne.b	.loop
	move.w	#$30,$FF8026.l
	move.l	#$74000003,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop2	btst.b	#$3,$FF800E.l
	beq.b	.loop2
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop3	btst.b	#$3,$FF800E.l
	bne.b	.loop3
	bclr.b	#$4,$FF800F.l
.loop4	btst.b	#$4,$FF800E.l
	bne.b	.loop4
	move.w	#$31,$FF8026.l
	move.w	$C444.l,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop5	btst.b	#$3,$FF800E.l
	beq.b	.loop5
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop6	btst.b	#$3,$FF800E.l
	bne.b	.loop6
	bclr.b	#$4,$FF800F.l
	move.w	$C440.l,d0
	add.w	d0,$C444.l
	tst.w	$C440.l
	bpl.w	.next
	cmpi.w	#$0,$C444.l
	bgt.w	.next3
	clr.w	$C444.l
.loop7	btst.b	#$4,$FF800E.l
	bne.b	.loop7
	move.w	#$30,$FF8026.l
	move.l	#$74000003,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop8	btst.b	#$3,$FF800E.l
	beq.b	.loop8
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop9	btst.b	#$3,$FF800E.l
	bne.b	.loop9
	bclr.b	#$4,$FF800F.l
.loop10	btst.b	#$4,$FF800E.l
	bne.b	.loop10
	move.w	#$31,$FF8026.l
	move.w	#$0,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop11	btst.b	#$3,$FF800E.l
	beq.b	.loop11
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop12	btst.b	#$3,$FF800E.l
	bne.b	.loop12
	bclr.b	#$4,$FF800F.l
	bra.w	.next2
.next	cmpi.w	#$3B,$C444.l
	blt.w	.next3
.loop13	btst.b	#$4,$FF800E.l
	bne.b	.loop13
	move.w	#$30,$FF8026.l
	move.l	#$74000003,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop14	btst.b	#$3,$FF800E.l
	beq.b	.loop14
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop15	btst.b	#$3,$FF800E.l
	bne.b	.loop15
	bclr.b	#$4,$FF800F.l
.loop16	btst.b	#$4,$FF800E.l
	bne.b	.loop16
	move.w	#$31,$FF8026.l
	move.w	#$3B,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop17	btst.b	#$3,$FF800E.l
	beq.b	.loop17
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop18	btst.b	#$3,$FF800E.l
	bne.b	.loop18
	bclr.b	#$4,$FF800F.l
	move.w	#$3B,$C444.l
.next2	clr.w	$C440.l
.next3	tst.w	$C43E.l
	bmi.w	.next4
	cmpi.w	#$64,$C43E.l
	beq.w	.next5
	subq.w	#$1,$C43E.l
	bmi.w	.next4
	clr.l	d0
	move.w	$C43E.l,d0
	cmpi.w	#$18,d0
	bgt.w	.next4
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
	bsr.w	GiveWordRam
.loop19	btst.b	#$4,$FF800E.l
	bne.b	.loop19
	move.w	#$1D,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop20	btst.b	#$3,$FF800E.l
	beq.b	.loop20
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop21	btst.b	#$3,$FF800E.l
	bne.b	.loop21
	bclr.b	#$4,$FF800F.l
	bsr.w	WaitDmnaSet
.next4	movem.l	(sp)+,d0-d7/a0
	rts
.next5	movea.l	#$BBCB0,a1
.loop22	btst.b	#$4,$FF800E.l
	bne.b	.loop22
	move.w	#$30,$FF8026.l
	move.l	#$C0000000,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop23	btst.b	#$3,$FF800E.l
	beq.b	.loop23
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop24	btst.b	#$3,$FF800E.l
	bne.b	.loop24
	bclr.b	#$4,$FF800F.l
	moveq	#$1F,d0
.loop25	btst.b	#$4,$FF800E.l
	bne.b	.loop25
	move.w	#$33,$FF8026.l
	move.l	(a1)+,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop26	btst.b	#$3,$FF800E.l
	beq.b	.loop26
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop27	btst.b	#$3,$FF800E.l
	bne.b	.loop27
	bclr.b	#$4,$FF800F.l
	dbra	d0,.loop25
	st.b	$C43E.l
	movem.l	(sp)+,d0-d7/a0
	rts
; Turns a cell index into a nametable VDP command (40 columns).
TilemapCellCmd	movem.l	d0-d2/a1/a5,-(sp)
	andi.l	#$FFFF,d0
	divu.w	#$28,d0
	move.w	d0,d2
	lsl.w	#$6,d2
	swap	d0
	add.w	d2,d0
	add.w	d0,d0
	moveq	#$0,d2
	move.w	#$E000,d2
	add.w	d0,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.loop	btst.b	#$7,$FF800E.l
	bne.b	.loop
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop2	btst.b	#$6,$FF800E.l
	beq.b	.loop2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	bne.b	.loop3
	bclr.b	#$7,$FF800F.l
	bsr.w	.next
	movem.l	(sp)+,d0-d2/a1/a5
	rts
.next	move.w	$C44A.l,d0
	lsr.w	#$5,d0
	bset	#$D,d0
.loop4	moveq	#$0,d2
	move.b	(a0)+,d2
	beq.w	.ex
	cmpi.b	#$22,d2
	beq.w	.next2
	cmpi.b	#$5F,d2
	beq.w	.next2
	cmpi.b	#$24,d2
	beq.w	.next3
	bra.w	.next4
.next2	move.b	#$20,d2
	bra.w	.next4
.next3	move.b	#$22,d2
.next4	subi.b	#$20,d2
	add.w	d0,d2
.loop5	btst.b	#$7,$FF800E.l
	bne.b	.loop5
	move.w	d2,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	beq.b	.loop6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop7	btst.b	#$6,$FF800E.l
	bne.b	.loop7
	bclr.b	#$7,$FF800F.l
	bra.w	.loop4
.ex	rts
; Writes a tilemap cell
TilemapPut	movem.l	d2-d3/a1-a2,-(sp)
	cmpa.l	#$80000,a0
	bge.w	.next
	move.l	d0,d3
	lsr.w	#$1,d3
	lea.l	$BC000.l,a2
.loop	move.l	(a0)+,(a2)+
	dbra	d3,.loop
	lea.l	$BC000.l,a0
.next	lea.l	$C00004.l,a1
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
	jsr	(GiveWordRam).l
.loop2	btst.b	#$7,$FF800E.l
	bne.b	.loop2
	move.w	#$8,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	beq.b	.loop3
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop4	btst.b	#$6,$FF800E.l
	bne.b	.loop4
	bclr.b	#$7,$FF800F.l
	jsr	(WaitDmnaSet).l
	movem.l	(sp)+,d2-d3/a1-a2
	rts
	move.l	$6038.w,$C42E.l
	move.l	#$27A74,$6038.w
.loop5	btst.b	#$7,$FF800E.l
	bne.b	.loop5
	move.w	#$2D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	beq.b	.loop6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop7	btst.b	#$6,$FF800E.l
	bne.b	.loop7
	bclr.b	#$7,$FF800F.l
	rts
	move.l	$C42E.l,$6038.w
	rts
	btst.b	#$5,$FF800E.l
	beq.w	.ex
	move.w	#$1,$C446.l
	bset.b	#$2,$FF800F.l
	move.l	#$27A9E,-(sp)
	move.l	$C432.l,-(sp)
	rts
; Table of 84 bytes after TilemapPut, 84 bytes: $4E,$B9,$00,$02,$7B,$38 ...
	dc.b	$4E,$B9,$00,$02,$7B,$38,$08,$39,$00,$04,$00,$FF,$80,$0E,$66,$F6	; N...{8.9......f.
	dc.b	$33,$FC,$00,$2F,$00,$FF,$80,$26,$08,$F9,$00,$03,$00,$FF,$80,$0F	; 3../...&........
	dc.b	$08,$39,$00,$03,$00,$FF,$80,$0E,$67,$F6,$08,$F9,$00,$04,$00,$FF	; .9......g.......
	dc.b	$80,$0F,$08,$B9,$00,$03,$00,$FF,$80,$0F,$08,$39,$00,$03,$00,$FF	; ...........9....
	dc.b	$80,$0E,$66,$F6,$08,$B9,$00,$04,$00,$FF,$80,$0F,$08,$B9,$00,$02	; ..f.............
	dc.b	$00,$FF,$80,$0F	; ....
.ex	rts
; Table of 8 bytes after TilemapPut, 8 bytes: $2F,$0D,$40,$E7,$46,$FC ...
	dc.b	$2F,$0D,$40,$E7,$46,$FC,$27,$00	; /.@.F...
; Gate array interrupt service B
GateArrayIrqB	movem.l	d0-d7/a0-a4/a6,-(sp)
	btst.b	#$0,$FF800F.l
	beq.w	.next
	btst.b	#$1,$FF800E.l
	beq.b	.next
	move.w	#$A,d7
	jsr	$6044.w
.next	movem.l	(sp)+,d0-d7/a0-a4/a6
	movea.l	#$FF8000,a5
	move.w	(sp)+,sr
	nop
	nop
	nop
	nop
	nop
	movea.l	(sp)+,a5
	rts
; Writes the communication bytes
WriteSubCommBytes	movem.l	d1/a0,-(sp)
	bsr.w	.next3
	move.b	d0,$2800A.l
	bsr.w	.next2
	move.b	d0,$2800B.l
	movem.l	(sp)+,d1/a0
	rts
.loop	btst.b	#$4,$FF800E.l
	bne.b	.loop
	move.b	#$C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop2	btst.b	#$4,$FF800E.l
	beq.b	.loop2
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop3	btst.b	#$3,$FF800E.l
	bne.b	.loop3
	bclr.b	#$4,$FF800F.l
	bra.w	.next
.loop4	btst.b	#$4,$FF800E.l
	bne.b	.loop4
	move.b	#$1C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop5	btst.b	#$4,$FF800E.l
	beq.b	.loop5
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop6	btst.b	#$3,$FF800E.l
	bne.b	.loop6
	bclr.b	#$4,$FF800F.l
	bra.w	.next
.loop7	btst.b	#$4,$FF800E.l
	bne.b	.loop7
	move.b	#$2C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop8	btst.b	#$4,$FF800E.l
	beq.b	.loop8
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop9	btst.b	#$3,$FF800E.l
	bne.b	.loop9
	bclr.b	#$4,$FF800F.l
	bra.w	.next
; Table of 78 bytes after WriteSubCommBytes, 78 bytes: $08,$39,$00,$04,$00,$FF ...
	dc.b	$08,$39,$00,$04,$00,$FF,$80,$0E,$66,$F6,$13,$FC,$00,$3C,$00,$FF	; .9......f....<..
	dc.b	$80,$28,$33,$FC,$00,$35,$00,$FF,$80,$26,$08,$F9,$00,$03,$00,$FF	; .(3..5...&......
	dc.b	$80,$0F,$08,$39,$00,$04,$00,$FF,$80,$0E,$67,$F6,$08,$F9,$00,$04	; ...9......g.....
	dc.b	$00,$FF,$80,$0F,$08,$B9,$00,$03,$00,$FF,$80,$0F,$08,$39,$00,$03	; .............9..
	dc.b	$00,$FF,$80,$0E,$66,$F6,$08,$B9,$00,$04,$00,$FF,$80,$0F	; ....f.........
.next	movem.l	d1/a0,-(sp)
	bra.w	.next4
.next2	movem.l	d1/a0,-(sp)
	bra.w	.next5
.next3	movem.l	d1/a0,-(sp)
.next4	moveq	#$0,d0
.loop10	btst.b	#$4,$FF800E.l
	bne.b	.loop10
	move.b	#$0,$FF8028.l
	move.w	#$36,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop11	btst.b	#$3,$FF800E.l
	beq.b	.loop11
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop12	btst.b	#$3,$FF800E.l
	bne.b	.loop12
	bclr.b	#$4,$FF800F.l
.loop13	btst.b	#$4,$FF800E.l
	bne.b	.loop13
	move.w	#$37,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop14	btst.b	#$3,$FF800E.l
	beq.b	.loop14
	move.b	$FF8018.l,d0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop15	btst.b	#$3,$FF800E.l
	bne.b	.loop15
	bclr.b	#$4,$FF800F.l
.loop16	btst.b	#$4,$FF800E.l
	bne.b	.loop16
	move.b	#$40,$FF8028.l
	move.w	#$36,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop17	btst.b	#$3,$FF800E.l
	beq.b	.loop17
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop18	btst.b	#$3,$FF800E.l
	bne.b	.loop18
	bclr.b	#$4,$FF800F.l
.loop19	btst.b	#$4,$FF800E.l
	bne.b	.loop19
	move.w	#$37,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop20	btst.b	#$3,$FF800E.l
	beq.b	.loop20
	move.b	$FF8018.l,d1
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop21	btst.b	#$3,$FF800E.l
	bne.b	.loop21
	bclr.b	#$4,$FF800F.l
; Instruction bytes inside WriteSubCommBytes that the assembler would encode differently, kept as words (1 row).
	dc.w	$6000,$013C
.next5	moveq	#$0,d0
.loop22	btst.b	#$4,$FF800E.l
	bne.b	.loop22
	move.b	#$0,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop23	btst.b	#$4,$FF800E.l
	beq.b	.loop23
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop24	btst.b	#$3,$FF800E.l
	bne.b	.loop24
	bclr.b	#$4,$FF800F.l
.loop25	btst.b	#$4,$FF800E.l
	bne.b	.loop25
	move.w	#$38,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop26	btst.b	#$3,$FF800E.l
	beq.b	.loop26
	move.b	$FF8018.l,d0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop27	btst.b	#$3,$FF800E.l
	bne.b	.loop27
	bclr.b	#$4,$FF800F.l
.loop28	btst.b	#$4,$FF800E.l
	bne.b	.loop28
	move.b	#$40,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop29	btst.b	#$4,$FF800E.l
	beq.b	.loop29
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop30	btst.b	#$3,$FF800E.l
	bne.b	.loop30
	bclr.b	#$4,$FF800F.l
.loop31	btst.b	#$4,$FF800E.l
	bne.b	.loop31
	move.w	#$38,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop32	btst.b	#$3,$FF800E.l
	beq.b	.loop32
	move.b	$FF8018.l,d1
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop33	btst.b	#$3,$FF800E.l
	bne.b	.loop33
	bclr.b	#$4,$FF800F.l
	bra.w	.next6
.next6	asl.b	#$2,d0
	andi.b	#$C0,d0
	andi.b	#$3F,d1
	or.b	d1,d0
	not.b	d0
	not.b	d1
	andi.w	#$F,d1
	lea.l	.next7(pc),a0
	andi.b	#$F0,d0
	or.b	(a0,d1.w),d0
	not.b	d0
	movem.l	(sp)+,d1/a0
	rts
; Table of 16 bytes after WriteSubCommBytes, 16 bytes: $00,$01,$02,$01,$04,$05 ...
.next7	dc.b	$00,$01,$02,$01,$04,$05,$06,$06,$08,$09,$0A,$0A,$08,$09,$0A,$00	; ................
; Reads the pad byte at $2800A and computes newly pressed buttons.
UpdatePadStateSub	move.b	$2800A.l,d0
	bsr.w	.next
	move.w	$28002.l,d2
	move.w	d1,$28002.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
	move.b	$2800B.l,d0
	bsr.w	.next
	move.w	$28004.l,d2
	move.w	d1,$28004.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
	move.b	$2800C.l,d0
	bsr.w	.next
	move.w	$28006.l,d2
	move.w	d1,$28006.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
	move.b	$2800D.l,d0
	bsr.w	.next
	move.w	$28008.l,d2
	move.w	d1,$28008.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
.next	not.b	d0
	clr.w	d1
	move.b	d0,d1
	move.w	d1,-(sp)
	andi.w	#$F0,d0
	andi.w	#$F,d1
	lea.l	$27FF2.l,a0
	move.b	(a0,d1.w),d1
	or.w	d1,d0
	move.w	(sp)+,d1
	rts
; Table of 28 bytes after UpdatePadStateSub, 28 bytes: $08,$00,$04,$08,$06,$07 ...
	dc.b	$08,$00,$04,$08,$06,$07,$05,$08,$02,$01,$03,$08,$08,$08,$08,$08	; ................
	dcb.b	$C,0
; Spins until DMNA is set.
WaitDmnaSet	btst.b	#$1,$FF8003.l
	beq.b	WaitDmnaSet
	rts
; Sets the word-RAM request bit and waits for the grant.
GiveWordRam	bset.b	#$0,$FF8003.l
.loop	btst.b	#$1,$FF8003.l
	bne.b	.loop
	rts
.loop2	btst.b	#$7,$FF800E.l
	bne.b	.loop2
.loop3	btst.b	#$6,$FF800E.l
	beq.b	.loop3
	bset.b	#$6,$FF800F.l
	bset.b	#$7,$FF800F.l
.loop4	btst.b	#$6,$FF800E.l
	bne.b	.loop4
	bclr.b	#$6,$FF800F.l
	bclr.b	#$7,$FF800F.l
	rts
; Table of 64 bytes after GiveWordRam, 64 bytes: $34,$3C,$00,$07,$16,$02 ...
	dc.b	$34,$3C,$00,$07,$16,$02,$06,$43,$00,$40,$13,$C3,$00,$FF,$00,$0F	; 4<.....C.@......
	dc.b	$13,$FC,$00,$00,$00,$FF,$00,$0D,$13,$FC,$00,$00,$00,$FF,$00,$0B	; ................
	dc.b	$13,$FC,$00,$00,$00,$FF,$00,$09,$51,$CA,$FF,$DA,$13,$FC,$00,$40	; ........Q......@
	dc.b	$00,$FF,$00,$0F,$13,$FC,$00,$80,$00,$FF,$00,$0F,$34,$3C,$00,$0F	; ............4<..
.loop5	move.w	#$FFF,d0
	move.l	#$0,d1
	movea.l	#$FF2001,a0
	move.b	d2,$FF000D.l
.loop6	move.b	d1,$0(a0)
	adda.w	#$2,a0
	dbra	d0,.loop6
	dbra	d2,.loop5
	move.b	#$FF,$FF0011.l
	rts
; Waits until the sub-CPU takes the data
WaitSubBusy	movem.l	d0-d1/a0-a1,-(sp)
.loop	move.w	#$80,d0
	jsr	$5F22.w
	bcs.b	.loop
	movem.l	(sp)+,d0-d1/a0-a1
	rts
.loop2	bclr.b	#$2,$FF8003.l
	bne.b	.loop2
	rts