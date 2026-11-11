; STARTER.BIN SM-chunk copy, file $3EAA, runtime $EEAA.
; FilmTask calls this when a record starts with $534D.
; Destination is the first argument ($C0000 from FilmTask).
; See docs/segacd_film.md.

; STARTER.BIN SM-chunk copy, file $3EAA, runtime $EEAA.
; FilmTask calls this when a record starts with $534D.
; Destination is the first argument ($C0000 from FilmTask).
; The epilogue pops the return address and jumps through it.
; See docs/segacd_film.md.

	org	$EEAA

CopySmChunk
	link	a6,#$0
	movem.l	d0-d7/a0-a5,-(sp)
	movea.l	$8(a6),a0
	movea.l	$C(a6),a1
	cmpi.w	#$534D,(a1)
	bne.w	LEFC4
	move.w	$8(a1),d0
	ext.l	d0
	move.w	$A(a1),d7
	ext.l	d7
	mulu.w	d0,d7
	move.l	d7,d6
	add.l	d6,d6
	addi.w	#$1F,d6
	lsr.w	#$5,d6
	lsl.w	#$2,d6
	move.w	#$C,d0
	move.w	$2(a1),d1
	andi.w	#$3,d1
	beq.b	LEEEC
	add.w	d6,d0
LEEEC	addq.w	#$1,d1
	lsl.w	#$5,d1
	add.w	d1,d0
	lsr.w	#$2,d0
	subq.w	#$1,d0
LEEF6	move.l	(a1)+,(a0)+
	dbra	d0,LEEF6
	move.l	(a1)+,d0
	movea.l	a1,a2
	adda.l	d0,a1
	move.l	(a1)+,d0
	movea.l	a1,a3
	adda.l	d0,a1
	movea.l	a1,a4
	adda.l	d6,a1
	moveq	#$1,d3
	subq.w	#$1,d7
LEF10	subq.w	#$1,d3
	bne.b	LEF18
	move.l	(a4)+,d5
	moveq	#$10,d3
LEF18	add.l	d5,d5
	bcs.b	LEF44
	add.l	d5,d5
	bcs.b	LEF2C
	lea.l	$20(a0),a0
	dbra	d7,LEF10
	bra.w	LEFC4
LEF2C	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	dbra	d7,LEF10
	bra.w	LEFC4
LEF44	add.l	d5,d5
	bcs.b	LEF78
	moveq	#$3,d4
LEF4A	moveq	#$0,d0
	move.b	(a1)+,d0
	lsl.w	#$2,d0
	move.l	(a2,d0.w),d0
	moveq	#$0,d1
	move.b	(a1)+,d1
	lsl.w	#$2,d1
	move.l	(a2,d1.w),d1
	swap	d0
	swap	d1
	move.w	d0,(a0)+
	move.w	d1,(a0)+
	swap	d0
	swap	d1
	move.w	d0,(a0)+
	move.w	d1,(a0)+
	dbra	d4,LEF4A
	dbra	d7,LEF10
	bra.b	LEFC4
LEF78	moveq	#$3,d4
LEF7A	moveq	#$0,d0
	move.b	(a1)+,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d1
	move.b	d1,d2
	lsl.l	#$8,d1
	lsl.l	#$8,d2
	moveq	#$0,d0
	move.b	(a1)+,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d1
	move.b	d1,d2
	lsl.l	#$8,d1
	lsl.l	#$8,d2
	moveq	#$0,d0
	move.b	(a1)+,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d1
	move.b	d1,d2
	lsl.l	#$8,d2
	moveq	#$0,d0
	move.b	(a1)+,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	move.b	d0,d2
	lsr.w	#$8,d0
	move.b	d0,d1
	move.l	d1,(a0)+
	move.l	d2,(a0)+
	dbra	d4,LEF7A
	dbra	d7,LEF10
LEFC4	movem.l	(sp)+,d0-d7/a0-a5
	unlk	a6
	movea.l	(sp)+,a0
	addq.w	#$8,sp
	jmp	(a0)
