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
; Routine of the player screen, saves d0-d4
; Moves an object in d2 steps, waiting for each step
PlMoveObjectSteps	movem.l	d0-d4,-(sp)
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
; Routine of the player screen, saves d0-d2/a0-a1
; Converts d0 to a decimal string at a0
PlBinToDecString	movem.l	d0-d2/a0-a1,-(sp)
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
; Data of PlBinToDecString (1 row): table or constants used by it.
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