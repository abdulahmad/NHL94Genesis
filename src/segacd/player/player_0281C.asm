; Blits a rectangle into the buffer at $BC000.
PlBlitToBuffer	movem.l	d0-d7/a0-a3,-(sp)
	movea.l	#$BC000,a0
	move.w	d0,d4
	movea.w	d1,a1
	movea.w	d2,a2
	swap	d1
	swap	d2
	move.w	d1,d5
	move.w	d2,d6
	move.w	d3,d7
	move.w	d3,(a0)+
	move.w	#$8F01,(a0)+
.loop	move.w	d4,d0
	move.w	d5,d1
	move.w	d6,d2
	move.w	#$8154,(a0)+
	move.w	#$9300,d3
	move.b	d0,d3
	move.w	d3,(a0)+
	move.w	#$9400,d3
	lsr.w	#$8,d0
	move.b	d0,d3
	move.w	d3,(a0)+
	move.w	#$9500,d3
	move.b	d2,d3
	move.w	d3,(a0)+
	move.w	#$9600,d3
	lsr.w	#$8,d2
	move.b	d2,d3
	move.w	d3,(a0)+
	move.w	#$97C0,(a0)+
	clr.l	d0
	move.w	d1,d0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	swap	d0
	ori.w	#$C0,d0
	move.l	d0,(a0)+
	add.w	a1,d5
	add.w	a2,d6
	dbra	d7,.loop
	move.w	#$8,$DE(a6)
.loop2	tst.w	$DE(a6)
	bne.w	.loop2
	movem.l	(sp)+,d0-d7/a0-a3
	rts
LF64Sub4	movem.l	d0-d4,-(sp)
	move.w	#$50,$E0(a6)
	move.w	d0,d3
	swap	d0
	move.w	d1,d4
	swap	d1
.loop	move.w	d0,$E4(a6)
	move.w	d1,$E2(a6)
	move.w	#$6,$DE(a6)
.loop2	tst.w	$DE(a6)
	bne.w	.loop2
	add.w	d3,d0
	add.w	d4,d1
	dbra	d2,.loop
	movem.l	(sp)+,d0-d4
	rts
; Length-prefixed situation names (power play, penalty kill, home/road advantage, skater counts).
StrSituationTable	dc.b	$16,'Power play adva'	; .Power play adva
	dc.b	'ntage',$00,$1E,'Penalty k'	; ntage..Penalty k
	dc.b	'illing disadvant'	; illing disadvant
	dc.b	$61,$67,$65,$00,$15,'Home team a'	; age..Home team a
	dc.b	'dvantage',$00,$18,'Road t'	; dvantage..Road t
	dc.b	'eam disadvantage'	; eam disadvantage
	dc.b	$00,$14,'Number of forw'	; ..Number of forw
	dc.b	'ards',$00,$16,'Number of '	; ards..Number of 
	dc.b	'defensemen',$00	; defensemen.
; 'Goalie # ' label.
StrGoalieNum	dc.b	$0B,'Goalie # ',$00	; .Goalie # .
; 'Player # ' label.
StrPlayerNum	dc.b	$0B,'Player # ',$00,$00	; .Player # ..
; Converts d7 to packed BCD in d1 (abcd loop).
BinToBcd	movem.l	d0-d2,-(sp)
	moveq	#$1,d0
	moveq	#$0,d2
	abcd.b	d0,d1
	moveq	#$0,d1
	bra.w	.next
.loop	abcd.b	d0,d1
.next	dbra	d7,.loop
	move.l	d1,d7
	cmpi.w	#$9,d1
	bgt.w	.next2
	addi.b	#$30,d7
	ori.l	#$2000,d7
	bra.w	.next3
.next2	ror.b	#$4,d7
	lsl.w	#$4,d7
	lsr.b	#$4,d7
	addi.w	#$3030,d7
	ori.l	#$200000,d7
.next3	movem.l	(sp)+,d0-d2
	rts
; Packed BCD conversion that counts the overflow in d2.
BinToBcdCarry	movem.l	d0-d2,-(sp)
	moveq	#$1,d0
	moveq	#$0,d1
	moveq	#$0,d2
	bra.w	.next
.loop	abcd.b	d0,d1
	bcc.w	.next
	addq.w	#$1,d2
.next	dbra	d7,.loop
	move.l	d1,d7
	tst.w	d2
	bne.w	.next3
	cmpi.w	#$9,d1
	bgt.w	.next2
	addi.b	#$30,d7
	ori.l	#$20202500,d7
	bra.w	.next4
.next2	ror.b	#$4,d7
	lsl.w	#$4,d7
	lsr.b	#$4,d7
	addi.w	#$3030,d7
	ori.l	#$20250000,d7
	bra.w	.next4
.next3	ror.b	#$4,d7
	lsl.w	#$4,d7
	lsr.b	#$4,d7
	lsl.l	#$8,d7
	move.b	d2,d7
	addi.l	#$303030,d7
	ori.l	#$25000000,d7
.next4	movem.l	(sp)+,d0-d2
	rts
LF64Sub5	movem.l	d0-d2/a0-a1,-(sp)
	lea.l	.next(pc),a1
	moveq	#$0,d2
	clr.b	(a1)+
.loop	move.l	d0,d1
	divu.w	#$A,d1
	swap	d1
	move.w	d1,d2
	addi.b	#$30,d1
	move.b	d1,(a1)+
	sub.l	d2,d0
	divu.w	#$A,d0
	bne.w	.loop
.loop2	move.b	-(a1),(a0)+
	bne.w	.loop2
	movem.l	(sp)+,d0-d2/a0-a1
	rts
.next	dcb.b	$50,0
; Chooses the source pointers for the current page.
PlPrepareSource	movem.l	d0-d7/a1-a5,-(sp)
	moveq	#$0,d0
	movea.l	$1C(a6),a1
	movea.l	$48(a6),a2
	move.w	$7C(a6),d0
	cmpi.w	#$0,$18(a6)
	beq.w	.next
	movea.l	$20(a6),a1
	movea.l	$4C(a6),a2
	move.w	$7E(a6),d0
.next	move.w	$80(a6),d2
	add.w	d2,d2
	move.w	(a2,d2.w),d1
	bpl.w	.next2
	neg.w	d1
	cmpi.w	#$40,d1
	bne.w	.next2
	moveq	#$0,d1
	clr.w	$80(a6)
.next2	movea.l	$86(a6),a2
	add.l	d0,d0
	add.l	d0,d0
	movea.l	(a2,d0.l),a1
	move.w	(a1),d0
	movea.l	a1,a2
	adda.l	d0,a2
	bra.w	.next3
.loop	move.w	(a2),d0
	lea.l	$8(a2,d0.l),a2
.next3	dbra	d1,.loop
	move.w	(a2),d0
	lea.l	(a2,d0.l),a0
	move.l	a0,$50(a6)
	subq.w	#$3,d0
	movea.l	a2,a0
	addq.l	#$2,a0
	movea.l	$8E(a6),a1
.loop2	move.b	(a0)+,d1
	beq.w	.next4
	move.b	d1,(a1)+
	dbra	d0,.loop2
.next4	move.b	#$0,(a1)
	movea.l	$8E(a6),a0
.loop3	move.b	(a0)+,d0
	cmpi.b	#$20,d0
	bne.w	.loop3
	lea.l	StrSkaterCareerHeaders(pc),a5
	move.l	a5,$9A(a6)
	move.w	#$2,$A6(a6)
	lea.l	StatColumnWidthsA(pc),a5
	move.l	a5,$9E(a6)
	lea.l	StatColumnIdsSkaterA(pc),a5
	movea.l	a0,a3
	movea.l	$2C(a6),a1
	movea.l	$30(a6),a2
	cmpi.w	#$0,$18(a6)
	beq.w	.next5
	movea.l	$3C(a6),a1
	movea.l	$40(a6),a2
.next5	move.l	a1,d0
	beq.w	.next8
	moveq	#$0,d0
	moveq	#-2,d2
.loop4	movea.l	a1,a4
	adda.l	#$5,a4
	movea.l	a3,a0
.loop5	move.b	(a0)+,d0
	move.b	(a4)+,d1
	ori.b	#$20,d0
	ori.b	#$20,d1
	cmp.b	d0,d1
	beq.w	.loop5
	cmpi.b	#$2C,-$1(a4)
	beq.w	.next6
	moveq	#$0,d1
.loop6	move.w	(a1),d1
	lea.l	(a1,d1.l),a1
	cmpi.w	#$656C,$4(a1)
	beq.w	.next7
	cmpi.w	#$656E,$4(a1)
	bne.w	.loop6
	move.w	(a1),d1
	lea.l	(a1,d1.l),a1
	bra.w	.loop4
.next6	move.l	a1,$44(a6)
.loop7	move.w	$5A(a6),d0
	add.w	d0,d0
	move.w	(a5,d0.w),$58(a6)
	bpl.w	.next9
	move.w	#$0,$B0(a6)
	subi.w	#$1,$5A(a6)
	bra.w	.loop7
.next7	addq.w	#$1,d2
	beq.w	.next8
	movea.l	a2,a1
	lea.l	StrGoalieCareerHeaders(pc),a5
	move.l	a5,$9A(a6)
	move.w	#$5,$A6(a6)
	lea.l	StatColumnWidthsB(pc),a5
	move.l	a5,$9E(a6)
	lea.l	StatColumnIdsSkaterB(pc),a5
	move.l	a1,d0
	beq.w	.next8
	moveq	#$0,d0
	bra.w	.loop4
.next8	move.l	#$0,$44(a6)
.next9	movea.l	$8E(a6),a0
	movem.l	(sp)+,d0-d7/a1-a5
	rts
; Queues a DMA request in the $DE-$E4 block and waits for it.
PlDmaRequest	move.w	d0,$E0(a6)
	swap	d0
	move.w	d0,$E2(a6)
	move.l	$62(a6),$E4(a6)
	move.w	#$2,$DE(a6)
.loop	tst.w	$DE(a6)
	bne.w	.loop
	rts
	move.w	d0,$E0(a6)
	swap	d0
	move.w	d0,$E2(a6)
	move.l	#$7A1,$E4(a6)
	move.w	#$2,$DE(a6)
.loop2	tst.w	$DE(a6)
	bne.w	.loop2
	rts
; Copies a rectangle of tilemap data to the VDP.
PlCopyRectToVdp	move.w	(a1)+,d1
	subq.w	#$1,d1
	move.w	d1,d2
	move.w	(a1)+,d7
	subq.w	#$1,d7
.loop	moveq	#$0,d4
	move.w	d3,d4
	bsr.w	VdpWriteCmdD4
.loop2	btst.b	#$7,$FF800E.l
	bne.b	.loop2
	move.l	d4,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	beq.b	.loop3
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop4	btst.b	#$6,$FF800E.l
	bne.b	.loop4
	bclr.b	#$7,$FF800F.l
.loop5	move.w	(a1)+,d4
	btst	#$D,d4
	bne.w	.next
	tst.w	$B2(a6)
	beq.w	.next
	ori.w	#$6000,d4
.next	add.w	d5,d4
.loop6	btst.b	#$7,$FF800E.l
	bne.b	.loop6
	move.w	d4,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop7	btst.b	#$6,$FF800E.l
	beq.b	.loop7
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop8	btst.b	#$6,$FF800E.l
	bne.b	.loop8
	bclr.b	#$7,$FF800F.l
	dbra	d2,.loop5
	add.w	d6,d3
	move.w	d1,d2
	dbra	d7,.loop
	rts
; Turns the VRAM address in d4 into a VDP write command.
VdpWriteCmdD4	andi.l	#$FFFF,d4
	lsl.l	#$2,d4
	lsr.w	#$2,d4
	swap	d4
	addi.l	#$40000000,d4
	rts
LF64_27	addq.w	#$1,$EC(a6)
	rts
LF64_28	move.w	#$1,$102(a6)
	addi.l	#$1,$96(a6)
	cmpi.w	#$2,$DE(a6)
	beq.w	.next9
	cmpi.w	#$1,$DE(a6)
	beq.w	.next10
	cmpi.w	#$3,$DE(a6)
	beq.w	.next5
	cmpi.w	#$4,$DE(a6)
	beq.w	.next6
	cmpi.w	#$5,$DE(a6)
	beq.w	.next7
	cmpi.w	#$6,$DE(a6)
	beq.w	.next8
	cmpi.w	#$7,$DE(a6)
	beq.w	.next4
	cmpi.w	#$8,$DE(a6)
	beq.w	.next3
	cmpi.w	#$9,$DE(a6)
	beq.w	.next2
	cmpi.w	#$A,$DE(a6)
	beq.w	.next
	bra.w	.next14
.next	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	move.w	$E2(a6),d0
	move.w	$E0(a6),d1
	addi.w	#$9200,d0
.loop	btst.b	#$4,$FF800E.l
	bne.b	.loop
	move.w	#$39,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop2	btst.b	#$3,$FF800E.l
	beq.b	.loop2
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop3	btst.b	#$3,$FF800E.l
	bne.b	.loop3
	bclr.b	#$4,$FF800F.l
	addi.w	#$9100,d1
.loop4	btst.b	#$4,$FF800E.l
	bne.b	.loop4
	move.w	#$39,$FF8026.l
	move.w	d1,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop5	btst.b	#$3,$FF800E.l
	beq.b	.loop5
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop6	btst.b	#$3,$FF800E.l
	bne.b	.loop6
	bclr.b	#$4,$FF800F.l
	bra.w	.next13
.next2	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	move.w	$E2(a6),d0
	andi.w	#$3FF,d0
.loop7	btst.b	#$4,$FF800E.l
	bne.b	.loop7
	move.w	#$30,$FF8026.l
	move.l	#$70000003,$FF8028.l
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
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop11	btst.b	#$3,$FF800E.l
	beq.b	.loop11
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop12	btst.b	#$3,$FF800E.l
	bne.b	.loop12
	bclr.b	#$4,$FF800F.l
	add.w	$E0(a6),d0
	move.w	d0,$E2(a6)
	bra.w	.next13
.next3	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	bsr.w	GiveWordRam
.loop13	btst.b	#$4,$FF800E.l
	bne.b	.loop13
	move.w	#$2C,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop14	btst.b	#$3,$FF800E.l
	beq.b	.loop14
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop15	btst.b	#$3,$FF800E.l
	bne.b	.loop15
	bclr.b	#$4,$FF800F.l
	bsr.w	WaitDmnaSet
	bra.w	.next13
.next4	movem.l	d0-d3/a0-a2,-(sp)
.loop16	btst.b	#$4,$FF800E.l
	bne.b	.loop16
	move.w	#$30,$FF8026.l
	move.l	#$40000010,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop17	btst.b	#$3,$FF800E.l
	beq.b	.loop17
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop18	btst.b	#$3,$FF800E.l
	bne.b	.loop18
	bclr.b	#$4,$FF800F.l
	clr.w	$DE(a6)
	move.w	$E2(a6),d0
	move.w	$E0(a6),d1
	add.w	d1,d0
.loop19	btst.b	#$4,$FF800E.l
	bne.b	.loop19
	move.w	#$31,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop20	btst.b	#$3,$FF800E.l
	beq.b	.loop20
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop21	btst.b	#$3,$FF800E.l
	bne.b	.loop21
	bclr.b	#$4,$FF800F.l
	move.w	d0,$E2(a6)
	bra.w	.next13
.next5	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	moveq	#$0,d0
	bsr.w	GateArrayLoadFont
.loop22	btst.b	#$4,$FF800E.l
	bne.b	.loop22
	move.w	#$39,$FF8026.l
	move.w	#$9001,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop23	btst.b	#$3,$FF800E.l
	beq.b	.loop23
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop24	btst.b	#$3,$FF800E.l
	bne.b	.loop24
	bclr.b	#$4,$FF800F.l
	bra.w	.next13
.next6	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
.loop25	btst.b	#$4,$FF800E.l
	bne.b	.loop25
	move.w	#$39,$FF8026.l
	move.w	#$9003,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop26	btst.b	#$3,$FF800E.l
	beq.b	.loop26
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop27	btst.b	#$3,$FF800E.l
	bne.b	.loop27
	bclr.b	#$4,$FF800F.l
	bra.w	.next13
.next7	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
.loop28	btst.b	#$4,$FF800E.l
	bne.b	.loop28
	move.w	#$39,$FF8026.l
	move.w	$E2(a6),$FF8028.l
	bset.b	#$3,$FF800F.l
.loop29	btst.b	#$3,$FF800E.l
	beq.b	.loop29
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop30	btst.b	#$3,$FF800E.l
	bne.b	.loop30
	bclr.b	#$4,$FF800F.l
.loop31	btst.b	#$4,$FF800E.l
	bne.b	.loop31
	move.w	#$30,$FF8026.l
	move.l	#$40000010,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop32	btst.b	#$3,$FF800E.l
	beq.b	.loop32
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop33	btst.b	#$3,$FF800E.l
	bne.b	.loop33
	bclr.b	#$4,$FF800F.l
.loop34	btst.b	#$4,$FF800E.l
	bne.b	.loop34
	move.w	#$31,$FF8026.l
	move.w	#$0,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop35	btst.b	#$3,$FF800E.l
	beq.b	.loop35
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop36	btst.b	#$3,$FF800E.l
	bne.b	.loop36
	bclr.b	#$4,$FF800F.l
	bra.w	.next13
.next8	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	moveq	#$0,d0
	move.w	$E0(a6),d0
	move.l	d0,$BBC88.l
	move.w	$E2(a6),d0
	move.l	d0,$BBC8C.l
	move.w	$E4(a6),d0
	move.l	d0,$BBC90.l
	bsr.w	GiveWordRam
.loop37	btst.b	#$4,$FF800E.l
	bne.b	.loop37
	move.w	#$3A,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop38	btst.b	#$3,$FF800E.l
	beq.b	.loop38
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop39	btst.b	#$3,$FF800E.l
	bne.b	.loop39
	bclr.b	#$4,$FF800F.l
	bsr.w	WaitDmnaSet
	bra.w	.next13
.next9	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	moveq	#$0,d0
	move.w	$E0(a6),d0
	move.l	d0,$BBC88.l
	move.w	$E2(a6),d0
	move.l	d0,$BBC8C.l
	move.l	$E4(a6),$BBC90.l
	bsr.w	GiveWordRam
.loop40	btst.b	#$4,$FF800E.l
	bne.b	.loop40
	move.w	#$3B,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop41	btst.b	#$3,$FF800E.l
	beq.b	.loop41
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop42	btst.b	#$3,$FF800E.l
	bne.b	.loop42
	bclr.b	#$4,$FF800F.l
	bsr.w	WaitDmnaSet
	bra.w	.next13
.next10	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	move.w	$E0(a6),d0
	move.w	$E2(a6),d1
	movea.l	$E4(a6),a0
	cmpa.l	#$80000,a0
	bge.w	.next12
	move.l	d0,d3
	movea.l	#$BC000,a2
	lsr.w	#$1,d3
	bcc.w	.next11
	move.w	(a0)+,(a2)+
.next11	subq.w	#$1,d3
.loop43	move.l	(a0)+,(a2)+
	dbra	d3,.loop43
	movea.l	#$BC000,a0
.next12	lea.l	$C00004.l,a1
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
	bsr.w	GiveWordRam
.loop44	btst.b	#$4,$FF800E.l
	bne.b	.loop44
	move.w	#$32,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop45	btst.b	#$3,$FF800E.l
	beq.b	.loop45
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop46	btst.b	#$3,$FF800E.l
	bne.b	.loop46
	bclr.b	#$4,$FF800F.l
	bsr.w	WaitDmnaSet
.next13	movem.l	(sp)+,d0-d3/a0-a2
.next14	tst.w	$FA(a6)
	beq.w	LF64_29
	movem.l	d0-d3/a0-a2,-(sp)
	move.w	$F6(a6),d0
	cmp.w	$F4(a6),d0
	bgt.w	.next16
	cmpi.w	#$1,$F8(a6)
	beq.w	.next15
	neg.w	d0
.next15	add.w	$F2(a6),d0
	bsr.w	GateArrayLoadFont
	addi.w	#$6,$F6(a6)
	bra.w	.next18
.next16	move.w	$F6(a6),d0
	subi.w	#$6,d0
	move.w	d0,$F6(a6)
	sub.w	$F4(a6),d0
	neg.w	d0
	add.w	$F6(a6),d0
	tst.w	$F8(a6)
	bne.w	.next17
	neg.w	d0
.next17	add.w	$F2(a6),d0
	bsr.w	GateArrayLoadFont
	clr.w	$FA(a6)
	clr.w	$F6(a6)
	andi.w	#$3FF,d0
	move.w	d0,$F2(a6)
.next18	movem.l	(sp)+,d0-d3/a0-a2
LF64_29	movem.l	d0-d5/a0-a1,-(sp)
	bsr.w	TickTimers
	movem.l	(sp)+,d0-d5/a0-a1
	rts
; Sends the font load command through the gate-array registers.
GateArrayLoadFont	btst.b	#$4,$FF800E.l
	bne.b	GateArrayLoadFont
	move.w	#$30,$FF8026.l
	move.l	#$70000003,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop	btst.b	#$3,$FF800E.l
	beq.b	.loop
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop2	btst.b	#$3,$FF800E.l
	bne.b	.loop2
	bclr.b	#$4,$FF800F.l
.loop3	btst.b	#$4,$FF800E.l
	bne.b	.loop3
	move.w	#$31,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop4	btst.b	#$3,$FF800E.l
	beq.b	.loop4
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop5	btst.b	#$3,$FF800E.l
	bne.b	.loop5
	bclr.b	#$4,$FF800F.l
.loop6	btst.b	#$4,$FF800E.l
	bne.b	.loop6
	move.w	#$31,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop7	btst.b	#$3,$FF800E.l
	beq.b	.loop7
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop8	btst.b	#$3,$FF800E.l
	bne.b	.loop8
	bclr.b	#$4,$FF800F.l
	rts
; Countdown timer tick at $EC(a6).
TickTimers	tst.w	$EC(a6)
	bmi.w	.ex
	cmpi.w	#$64,$EC(a6)
	beq.w	.next
	subq.w	#$1,$EC(a6)
	bmi.w	.ex
	clr.l	d0
	move.w	$EC(a6),d0
	cmpi.w	#$18,d0
	bgt.w	.ex
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
.loop	btst.b	#$4,$FF800E.l
	bne.b	.loop
	move.w	#$1D,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop2	btst.b	#$3,$FF800E.l
	beq.b	.loop2
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop3	btst.b	#$3,$FF800E.l
	bne.b	.loop3
	bclr.b	#$4,$FF800F.l
	bsr.w	WaitDmnaSet
.ex	rts
.next	movea.l	#$BBCB0,a1
.loop4	btst.b	#$4,$FF800E.l
	bne.b	.loop4
	move.w	#$30,$FF8026.l
	move.l	#$C0000000,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop5	btst.b	#$3,$FF800E.l
	beq.b	.loop5
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop6	btst.b	#$3,$FF800E.l
	bne.b	.loop6
	bclr.b	#$4,$FF800F.l
	moveq	#$1F,d0
.loop7	btst.b	#$4,$FF800E.l
	bne.b	.loop7
	move.w	#$33,$FF8026.l
	move.l	(a1)+,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop8	btst.b	#$3,$FF800E.l
	beq.b	.loop8
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop9	btst.b	#$3,$FF800E.l
	bne.b	.loop9
	bclr.b	#$4,$FF800F.l
	dbra	d0,.loop7
	st.b	$EC(a6)
	rts
; Decodes pad 1 and computes newly pressed buttons.
UpdatePad1	move.b	$C2(a6),d0
	bsr.w	DecodePadBits
	move.w	$C6(a6),d2
	move.w	d1,$C6(a6)
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
; Decodes pad 2 and computes newly pressed buttons.
UpdatePad2	move.b	$C3(a6),d0
	bsr.w	DecodePadBits
	move.w	$C8(a6),d2
	move.w	d1,$C8(a6)
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
	move.b	$C4(a6),d0
	bsr.w	DecodePadBits
	move.w	$CA(a6),d2
	move.w	d1,$CA(a6)
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
	move.b	$C5(a6),d0
	bsr.w	DecodePadBits
	move.w	$CC(a6),d2
	move.w	d1,$CC(a6)
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
; Inverts the raw pad byte and splits direction and button bits.
DecodePadBits	not.b	d0
	clr.w	d1
	move.b	d0,d1
	move.w	d1,-(sp)
	andi.w	#$F0,d0
	andi.w	#$F,d1
	lea.l	.next(pc),a0
	move.b	(a0,d1.w),d1
	or.w	d1,d0
	move.w	(sp)+,d1
	rts
.next	dc.b	$08,$00,$04,$08,$06,$07,$05,$08,$02,$01,$03,$08,$08,$08,$08,$08	; ................
LF64Sub7	movem.l	d1/a0,-(sp)
	tst.w	$BC(a6)
	beq.w	.next
	bsr.b	.loop
	move.b	d0,$C2(a6)
	bsr.w	.loop4
	move.b	d0,$C3(a6)
	bsr.w	.loop7
	move.b	d0,$C4(a6)
	bsr.w	.loop10
	move.b	d0,$C5(a6)
	bra.w	.next2
.next	bsr.w	.next5
	move.b	d0,$C2(a6)
	bsr.w	.next4
	move.b	d0,$C3(a6)
.next2	movem.l	(sp)+,d1/a0
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
	bra.w	.next3
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
	bra.w	.next3
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
	bra.w	.next3
.loop10	btst.b	#$4,$FF800E.l
	bne.b	.loop10
	move.b	#$3C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop11	btst.b	#$4,$FF800E.l
	beq.b	.loop11
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop12	btst.b	#$3,$FF800E.l
	bne.b	.loop12
	bclr.b	#$4,$FF800F.l
.next3	movem.l	d1/a0,-(sp)
	bra.w	.next6
.next4	movem.l	d1/a0,-(sp)
	bra.w	.next7
.next5	movem.l	d1/a0,-(sp)
.next6	moveq	#$0,d0
.loop13	btst.b	#$4,$FF800E.l
	bne.b	.loop13
	move.b	#$0,$FF8028.l
	move.w	#$36,$FF8026.l
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
	move.w	#$37,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop17	btst.b	#$3,$FF800E.l
	beq.b	.loop17
	move.b	$FF8018.l,d0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop18	btst.b	#$3,$FF800E.l
	bne.b	.loop18
	bclr.b	#$4,$FF800F.l
.loop19	btst.b	#$4,$FF800E.l
	bne.b	.loop19
	move.b	#$40,$FF8028.l
	move.w	#$36,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop20	btst.b	#$3,$FF800E.l
	beq.b	.loop20
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop21	btst.b	#$3,$FF800E.l
	bne.b	.loop21
	bclr.b	#$4,$FF800F.l
.loop22	btst.b	#$4,$FF800E.l
	bne.b	.loop22
	move.w	#$37,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop23	btst.b	#$3,$FF800E.l
	beq.b	.loop23
	move.b	$FF8018.l,d1
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop24	btst.b	#$3,$FF800E.l
	bne.b	.loop24
	bclr.b	#$4,$FF800F.l
	dc.w	$6000,$013C
.next7	moveq	#$0,d0
.loop25	btst.b	#$4,$FF800E.l
	bne.b	.loop25
	move.b	#$0,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop26	btst.b	#$4,$FF800E.l
	beq.b	.loop26
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop27	btst.b	#$3,$FF800E.l
	bne.b	.loop27
	bclr.b	#$4,$FF800F.l
.loop28	btst.b	#$4,$FF800E.l
	bne.b	.loop28
	move.w	#$38,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop29	btst.b	#$3,$FF800E.l
	beq.b	.loop29
	move.b	$FF8018.l,d0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop30	btst.b	#$3,$FF800E.l
	bne.b	.loop30
	bclr.b	#$4,$FF800F.l
.loop31	btst.b	#$4,$FF800E.l
	bne.b	.loop31
	move.b	#$40,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop32	btst.b	#$4,$FF800E.l
	beq.b	.loop32
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop33	btst.b	#$3,$FF800E.l
	bne.b	.loop33
	bclr.b	#$4,$FF800F.l
.loop34	btst.b	#$4,$FF800E.l
	bne.b	.loop34
	move.w	#$38,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop35	btst.b	#$3,$FF800E.l
	beq.b	.loop35
	move.b	$FF8018.l,d1
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop36	btst.b	#$3,$FF800E.l
	bne.b	.loop36
	bclr.b	#$4,$FF800F.l
	bra.w	.next8
.next8	asl.b	#$2,d0
	andi.b	#$C0,d0
	andi.b	#$3F,d1
	or.b	d1,d0
	not.b	d0
	not.b	d1
	andi.w	#$F,d1
	lea.l	.next9(pc),a0
	andi.b	#$F0,d0
	or.b	(a0,d1.w),d0
	not.b	d0
	movem.l	(sp)+,d1/a0
	rts
.next9	dc.b	$00,$01,$02,$01,$04,$05,$06,$06,$08,$09,$0A,$0A,$08,$09,$0A,$00	; ................
; Saves the vblank vector and points it at the page handler.
InstallVblankHook	move.l	$6038.w,$D6(a6)
	lea.l	LF64_37(pc),a0
	move.l	a0,$6038.w
	rts
; Restores the saved vblank vector.
RemoveVblankHook	move.l	$D6(a6),$6038.w
	rts
LF64_37	btst.b	#$5,$FF800E.l
	beq.w	.ex
	bset.b	#$2,$FF800F.l
	pea.l	.next(pc)
	move.l	$D2(a6),-(sp)
	rts
.next	bsr.w	LF64Sub7
.loop	btst.b	#$4,$FF800E.l
	bne.b	.loop
	move.w	#$2F,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop2	btst.b	#$3,$FF800E.l
	beq.b	.loop2
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop3	btst.b	#$3,$FF800E.l
	bne.b	.loop3
	bclr.b	#$4,$FF800F.l
	bclr.b	#$2,$FF800F.l
.ex	rts
; Turns a linear cell index in d0 into a nametable address (40 columns).
TilemapAddr	movem.l	d0-d2/a0-a1/a5,-(sp)
	andi.l	#$FFFF,d0
	divu.w	#$28,d0
	move.w	d0,d2
	lsl.w	#$6,d2
	swap	d0
	add.w	d2,d0
	add.w	d0,d0
	moveq	#$0,d2
	move.w	#$B000,d2
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
	movea.l	$8E(a6),a5
	bsr.w	PrintTextLine
	movem.l	(sp)+,d0-d2/a0-a1/a5
	rts
LF64Sub8	movem.l	d0-d2/a0-a1/a5,-(sp)
	andi.l	#$FFFF,d0
	divu.w	#$28,d0
	move.w	d0,d2
	lsl.w	#$7,d2
	swap	d0
	add.w	d2,d0
	add.w	d0,d0
	moveq	#$0,d2
	move.w	$EE(a6),d2
	subi.w	#$2000,d2
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
	movea.l	$8E(a6),a5
	bsr.w	PrintTextLine
	movem.l	(sp)+,d0-d2/a0-a1/a5
	rts
; Prints a zero-terminated string with the special characters at a0.
PrintTextLine	move.w	#$7A0,d0
	bset	#$E,d0
.loop	moveq	#$0,d2
	move.b	(a0)+,d2
	beq.w	.next4
	cmpi.b	#$22,d2
	beq.w	.next
	cmpi.b	#$5F,d2
	beq.w	.next
	cmpi.b	#$24,d2
	beq.w	.next2
	bra.w	.next3
.next	move.b	#$20,d2
	bra.w	.next3
.next2	move.b	#$22,d2
.next3	move.b	d2,(a5)+
	subi.b	#$20,d2
	add.w	d0,d2
.loop2	btst.b	#$7,$FF800E.l
	bne.b	.loop2
	move.w	d2,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	beq.b	.loop3
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop4	btst.b	#$6,$FF800E.l
	bne.b	.loop4
	bclr.b	#$7,$FF800F.l
	subq.w	#$1,d1
	bra.w	.loop
.next4	tst.w	d1
	blt.w	.next5
.loop5	btst.b	#$7,$FF800E.l
	bne.b	.loop5
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	beq.b	.loop6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop7	btst.b	#$6,$FF800E.l
	bne.b	.loop7
	bclr.b	#$7,$FF800F.l
	move.b	#$20,(a5)+
	dbra	d1,.loop5
	subq.l	#$1,a5
.next5	clr.b	(a5)+
	rts
; Prints a string at a4 (stops at 0 or $FF).
PrintTextPlain	movem.l	d0-d2/a4,-(sp)
	move.w	#$7A0,d0
	bset	#$E,d0
.loop	moveq	#$0,d2
	move.b	(a4)+,d2
	beq.w	.next
	cmpi.b	#$FF,d2
	beq.w	.next
	subi.b	#$20,d2
	add.w	d0,d2
.loop2	btst.b	#$7,$FF800E.l
	bne.b	.loop2
	move.w	d2,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	beq.b	.loop3
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop4	btst.b	#$6,$FF800E.l
	bne.b	.loop4
	bclr.b	#$7,$FF800F.l
	subq.b	#$1,d1
	bra.w	.loop
.next	subq.b	#$1,d1
	tst.b	d1
	bmi.w	.next2
.loop5	btst.b	#$7,$FF800E.l
	bne.b	.loop5
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	beq.b	.loop6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop7	btst.b	#$6,$FF800E.l
	bne.b	.loop7
	bclr.b	#$7,$FF800F.l
	dbra	d1,.loop5
.next2	movem.l	(sp)+,d0-d2/a4
	rts
; Copies at most d0 characters of a0 to the string buffer $8E(a6).
CopyStringToBuffer	movem.l	d0/a0-a1,-(sp)
	movea.l	$8E(a6),a1
.loop	move.b	(a0)+,(a1)+
	beq.w	.next
	dbra	d0,.loop
	clr.b	(a1)
.next	movem.l	(sp)+,d0/a0-a1
	rts
; Spins until the word-RAM DMNA bit is set.
WaitDmnaSet	btst.b	#$1,$FF8003.l
	beq.b	WaitDmnaSet
	rts
; Sets the word-RAM request bit and waits until it is granted.
GiveWordRam	bset.b	#$0,$FF8003.l
.loop	btst.b	#$1,$FF8003.l
	bne.b	.loop
	rts
; Loads a command through the gate-array comm registers.
GateArrayLoadCmd	movem.l	d0-d7/a0-a2,-(sp)
	bclr.b	#$5,$FF800F.l
.loop	btst.b	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$3D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop2	btst.b	#$6,$FF800E.l
	beq.b	.loop2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	bne.b	.loop3
	bclr.b	#$7,$FF800F.l
	bset.b	#$5,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a2
	rts
; Column ids for one skater stat page, $FFFF ends the list.
StatColumnIdsSkaterA	dc.b	$00,$00,$00,$01,$00,$02,$00,$05,$00,$06,$00,$07,$FF,$FF	; ..............
; Column ids for the second skater stat page.
StatColumnIdsSkaterB	dc.b	$00,$00,$00,$01,$00,$02,$00,$03,$00,$04,$00,$05,$00,$08,$00,$09	; ................
	dc.b	$00,$0A,$00,$0B,$00,$0C,$FF,$FF	; ........
; Column widths for the first page.
StatColumnWidthsA	dc.b	$07,$FF,$05,$03,$03,$03,$03,$04,$03,$03,$03,$03,$04,$00	; ..............
; Column widths for the second page.
StatColumnWidthsB	dc.b	$07,$FF,$05,$03,$03,$03,$03,$04,$03,$02,$04,$03,$03,$03,$05,$03	; ................
	dc.b	$03,$04	; ..
; 'Players'.
StrPlayers	dc.b	'Players',$00,$20,$00	; Players. .
; 'Goalies'.
StrGoalies	dc.b	'Goalies',$00,$20,$00	; Goalies. .
; Skater column headings: Gp G A Pts +/- Pim PP Sh Gw Gt S Pctg.
StrSkaterStatHeaders	dc.b	$47,$70,$00,$47,$00,$41,$00,$50,$74,$73,$00,$2B,$2F,$2D,$00,$50	; Gp.G.A.Pts.+/-.P
	dc.b	$69,$6D,$00,$50,$50,$00,$53,$68,$00,$47,$77,$00,$47,$74,$00,$53	; im.PP.Sh.Gw.Gt.S
	dc.b	$00,'Pctg',$FF	; .Pctg.
; Goalie column headings: Gp Mins Ga Avg. W L T SO En Shts and the per-game forms.
StrGoalieStatHeaders	dc.b	$47,$70,$00,'Mins',$00,$47,$61,$00,'Avg.',$00	; Gp.Mins.Ga.Avg..
	dc.b	$57,$00,$4C,$00,$54,$00,$53,$4F,$00,$45,$6E,$00,'Shts'	; W.L.T.SO.En.Shts
	dc.b	$00,$70,$47,$50,$00,'pMIN',$00,$70,$47,$41,$00,$70,$41	; .pGP.pMIN.pGA.pA
	dc.b	$56,$47,$00,$70,$57,$00,$70,$4C,$00,$70,$53,$4F,$00,$70,$45,$4E	; VG.pW.pL.pSO.pEN
	dc.b	$00,$70,$53,$41,$FF	; .pSA.
; 'Regular'.
StrRegular	dc.b	'Regular',$00	; Regular.
; 'Playoff'.
StrPlayoff	dc.b	'Playoff',$00	; Playoff.
; Skater career headings: Season Club Lea Gp G A Tp Pim.
StrSkaterCareerHeaders	dc.b	'Season',$00,'Club',$00,$4C,$65,$61,$00	; Season.Club.Lea.
	dc.b	$47,$70,$00,$47,$00,$41,$00,$54,$70,$00,$50,$69,$6D,$00,$47,$70	; Gp.G.A.Tp.Pim.Gp
	dc.b	$00,$47,$00,$41,$00,$54,$70,$00,$50,$69,$6D,$00	; .G.A.Tp.Pim.
; Goalie career headings: Season Club Lea Gp W L T Mins Ga So Avg.
StrGoalieCareerHeaders	dc.b	'Season',$00,'Club',$00,$4C,$65,$61,$00	; Season.Club.Lea.
	dc.b	$47,$70,$00,$57,$00,$4C,$00,$54,$00,'Mins',$00,$47,$61	; Gp.W.L.T.Mins.Ga
	dc.b	$00,$53,$6F,$00,$41,$76,$67,$00,$47,$70,$00,$57,$00,$4C,$00,$4D	; .So.Avg.Gp.W.L.M
	dc.b	$69,$6E,$73,$00,$47,$61,$00,$53,$6F,$00,$41,$76,$67,$00,$00	; ins.Ga.So.Avg..
; Picture tile data, single frame (page A).
PicTilesStillA	incbin	..\Extracted\SegaCD\PLAYER\player_040C4.bin
; Picture tile data, animation frames (page A).
PicTilesFramesA	incbin	..\Extracted\SegaCD\PLAYER\player_045C8.bin
.next	incbin	..\Extracted\SegaCD\PLAYER\player_06044.bin
; Picture tile data, single frame (page B).
PicTilesStillB	incbin	..\Extracted\SegaCD\PLAYER\player_068E4.bin
; Picture tile data, three animation frames (page B), $504 bytes each.
PicTilesFramesB	incbin	..\Extracted\SegaCD\PLAYER\player_06DE8.bin
; Table of $34-byte records indexed by the current page.
PlRecordTable	incbin	..\Extracted\SegaCD\PLAYER\player_07CF4.bin
; Background image: width, height, then tile data.
PlBackgroundImage	incbin	..\Extracted\SegaCD\PLAYER\player_082A4.bin
	dcb.b	$8DC,0
