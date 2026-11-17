RestoreBios_95	dc.b	$00,$00,$00,$00	; ....
RestoreBios_96	lea.l	RestoreBios_95(pc),a0
	move.l	$5F90.w,(a0)
	lea.l	RestoreBios_99(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F90.w
	move.w	(sp)+,sr
	rts
RestoreBios_97	movea.l	RestoreBios_95(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F90.w
	move.w	(sp)+,sr
	dc.w	$4E75
RestoreBios_98	dc.b	$00,$00,$00,$00	; ....
RestoreBios_99	movem.l	d0-d3/a0-a2/a5,-(sp)
	pea.l	.l413E(pc)
	move.w	sr,-(sp)
	movea.l	RestoreBios_95(pc),a2
	jmp	(a2)
.l413E	movea.l	#$FF8000,a5
	move.l	RestoreBios_79(pc),d3
	beq.w	.l421C
	dc.w	$6E78
	andi.w	#$F8FF,$4(a5)
	ori.w	#$300,$4(a5)
	move.w	#$8B,d0
	jsr	$5F22.w
	bcs.w	.l421C
	move.l	RestoreBios_80(pc),d0
	dc.w	$660A
	bsr.w	PeekSectDst
	tst.l	d0
	beq.w	.l4222
.l4176	movea.l	d0,a0
	lea.l	RestoreBios_98(pc),a1
	move.w	#$8C,d0
	jsr	$5F22.w
	bcs.w	.l421C
	move.w	#$8D,d0
	jsr	$5F22.w
	move.l	RestoreBios_98(pc),d0
	andi.l	#$FFFFFF00,d0
	bsr.w	RestoreBios_102
	move.l	RestoreBios_81(pc),d1
	cmp.l	d0,d1
	dc.w	$6676
	lea.l	RestoreBios_80(pc),a1
	tst.l	(a1)
	dc.w	$6708
	addi.l	#$800,(a1)
	dc.w	$6004
.l41B6	bsr.w	GetSectDst
.l41BA	neg.l	d3
	subq.w	#$1,d3
	lea.l	RestoreBios_79(pc),a1
	move.l	d3,(a1)
	dc.w	$6056
.l41C6	movea.l	#$FF8000,a5
	andi.w	#$F8FF,$4(a5)
	ori.w	#$500,$4(a5)
	move.l	RestoreBios_80(pc),d0
	dc.w	$6608
	bsr.w	GetSectDst
	tst.l	d0
	dc.w	$673C
.l41E6	lsr.l	#$3,d0
	move.w	d0,$A(a5)
	move.w	#$8B,d0
	jsr	$5F22.w
	dc.w	$6534
.l41F6	btst.b	#$7,$4(a5)
	beq.b	.l41F6
	dc.w	$652A
	move.w	#$8D,d0
	jsr	$5F22.w
	lea.l	RestoreBios_80(pc),a1
	tst.l	(a1)
	dc.w	$6706
	addi.l	#$800,(a1)
.l4216	lea.l	RestoreBios_79(pc),a1
	subq.l	#$1,(a1)
.l421C	movem.l	(sp)+,d0-d3/a0-a2/a5
	rte
.l4222	lea.l	RestoreBios_79(pc),a1
	clr.l	(a1)
	bra.b	.l421C
.l422A	lea.l	RestoreBios_84(pc),a1
	move.l	#$FFFFFFFF,(a1)
	bra.b	.l421C
RestoreBios_100	lea.l	RestoreBios_79(pc),a1
	clr.l	(a1)
	move.w	#$8,d0
	jsr	$5F22.w
	rts
RestoreBios_101	dc.w	$4E56,$FFFC
RestoreBiosSub50	movem.l	d1-d7/a0-a5,-(sp)
	movea.l	#$FF8000,a5
	lea.l	RestoreBios_84(pc),a1
	clr.l	(a1)
	moveq	#$5,d4
	moveq	#-1,d5
	subq.l	#$1,d4
	dc.w	$6736
	moveq	#$0,d0
	move.w	#$96,d0
	jsr	$5F22.w
	move.l	$8(a6),d3
	move.l	$C(a6),d2
	lea.l	$8(a6),a0
	move.w	#$17,d0
	jsr	$5F22.w
	lea.l	RestoreBios_80(pc),a1
	move.l	$10(a6),(a1)
	lea.l	RestoreBios_79(pc),a1
	neg.l	d2
	move.l	d2,(a1)
	lea.l	RestoreBios_81(pc),a1
	move.l	d3,(a1)
	moveq	#$0,d5
.l4298	move.l	d5,d0
	movem.l	(sp)+,d1-d7/a0-a5
	unlk	a6
	rts
RestoreBiosSub51	move.l	d1,-(sp)
	move.b	d0,d1
	andi.w	#$FF,d1
	lsr.w	#$4,d1
	mulu.w	#$A,d1
	andi.w	#$F,d0
	add.w	d1,d0
	move.l	(sp)+,d1
	rts
RestoreBios_102	movem.l	d1-d2,-(sp)
	lsr.l	#$8,d0
	move.l	d0,d1
	jsr	RestoreBiosSub51(pc)
	move.b	d0,d2
	andi.l	#$FF,d2
	move.l	d1,d0
	lsr.l	#$8,d0
	move.l	d0,d1
	jsr	RestoreBiosSub51(pc)
	andi.l	#$FF,d0
	mulu.w	#$4B,d0
	add.l	d0,d2
	move.l	d1,d0
	lsr.l	#$8,d0
	jsr	RestoreBiosSub51(pc)
	andi.l	#$FF,d0
	mulu.w	#$1194,d0
	add.l	d0,d2
	subi.l	#$96,d2
	move.l	d2,d0
	movem.l	(sp)+,d1-d2
	rts
RestoreBios_103	dc.w	$4E56,$0000
Wait	movem.l	d6-d7,-(sp)
	move.l	$8(a6),d6
	jsr	GetTicks(pc)
	move.l	d0,d7
.l4318	jsr	GetTicks(pc)
	move.l	d7,d1
	add.l	d6,d1
	cmp.l	d0,d1
	bgt.b	.l4318
	movem.l	-$8(a6),d6-d7
	unlk	a6
	dc.w	$4E75
	dc.b	$84,'Wait',$00,$00,$00	; .Wait...
