; Sub-CPU command: palette copy
SubCmdCramCopy	bsr.w	WaitDmnaClear
	move.l	$23BC88.l,d3
	move.l	$23BC8C.l,d4
	move.l	$23BC90.l,d5
	movea.l	#$23BCB0,a1
	movea.l	#$C00000,a0
	clr.w	d6
.loop	move.w	d3,d2
	move.w	d6,d0
	swap	d0
	move.w	#$20,d0
	move.l	d0,$4(a0)
	move.w	(a0),d7
	move.w	d7,d0
	and.w	d5,d0
	move.w	(a1)+,d1
	and.w	d5,d1
	cmp.w	d1,d0
	beq.w	.next2
	blt.w	.next
	neg.w	d2
.next	add.w	d2,d0
	and.w	d4,d7
	or.w	d0,d7
	move.l	#$C000,d0
	move.b	d6,d0
	swap	d0
	move.l	d0,$4(a0)
	move.w	d7,(a0)
.next2	addq.w	#$2,d6
	cmpi.w	#$80,d6
	bne.w	.loop
	bsr.w	GiveWordRamToSub
	rts
	bsr.w	WaitDmnaClear
	move.l	$23BC88.l,d0
	move.l	$23BC8C.l,d1
	move.l	$23BC90.l,d2
	lea.l	$C00004.l,a1
	move.w	#$8154,(a1)
	move.w	#$8F01,(a1)
	move.w	#$9300,d3
	move.b	d0,d3
	move.w	d3,(a1)
	move.w	#$9400,d3
	lsr.w	#$8,d0
	move.b	d0,d3
	move.w	d3,(a1)
	move.w	#$9500,d3
	move.b	d2,d3
	move.w	d3,(a1)
	move.w	#$9600,d3
	lsr.w	#$8,d2
	move.b	d2,d3
	move.w	d3,(a1)
	move.w	#$97C0,(a1)
	clr.l	d0
	move.w	d1,d0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	swap	d0
	ori.w	#$C0,d0
	move.l	d0,$FF6CE8.l
	move.w	$FF6CE8.l,(a1)
	move.w	$FF6CEA.l,(a1)
.loop2	move.w	$C00004.l,-(sp)
	btst.b	#$1,$1(sp)
	addq.w	#$2,sp
	bne.w	.loop2
	move.w	#$8164,(a1)
	move.w	#$8F02,(a1)
	bsr.w	GiveWordRamToSub
	rts
	bsr.w	WaitDmnaClear
	lea.l	$C00004.l,a1
	movea.l	#$23C000,a0
	move.w	(a0)+,d0
	move.w	(a0)+,(a1)
.loop3	move.w	(a0)+,(a1)
	move.w	(a0)+,(a1)
	move.w	(a0)+,(a1)
	move.w	(a0)+,(a1)
	move.w	(a0)+,(a1)
	move.w	(a0)+,(a1)
	move.l	(a0)+,$FF6CE8.l
	move.w	$FF6CE8.l,(a1)
	move.w	$FF6CEA.l,(a1)
.loop4	move.w	$C00004.l,-(sp)
	btst.b	#$1,$1(sp)
	addq.w	#$2,sp
	bne.w	.loop4
	move.w	#$8164,(a1)
	dbra	d0,.loop3
	move.w	#$8F02,(a1)
	bsr.w	GiveWordRamToSub
	rts
	bsr.w	WaitDmnaClear
	move.l	$23BC88.l,d0
	move.l	$23BC8C.l,d1
	move.l	$23BC90.l,d2
	movea.l	#$C00000,a1
	andi.l	#$FFFF,d1
	asl.l	#$2,d1
	lsr.w	#$2,d1
	ori.w	#$4000,d1
	swap	d1
	move.l	d1,$4(a1)
	move.w	d2,d3
	swap	d3
	move.w	d2,d3
	lsr.w	#$1,d0
	subq.w	#$1,d0
.loop5	move.l	d3,$FF6CE8.l
	move.w	$FF6CE8.l,(a1)
	move.w	$FF6CEA.l,(a1)
	dbra	d0,.loop5
	bsr.w	GiveWordRamToSub
	rts