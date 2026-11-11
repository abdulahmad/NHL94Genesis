; STARTER.BIN FilmOpen, file $4336, runtime $F336.
; Requires the long FILM ($46494C4D). Returns -1 on a bad file.
; See docs/segacd_film.md.

X_100D8	equ	$100D8
Wait	equ	$F306
X_FD9E	equ	$FD9E
SwapMeg	equ	$F788
X_F544	equ	$F544
X_FFA8	equ	$FFA8
X_FE26	equ	$FE26
X_F54E	equ	$F54E
X_F55A	equ	$F55A
ffree	equ	$F9FA
X_10332	equ	$10332
X_F56A	equ	$F56A
WaitIODone	equ	$FD7E
StartFilmRead	equ	$F246
mmalloc	equ	$FB7E
aprint	equ	$F8C4
X_F57C	equ	$F57C
InitWorld	equ	$FC84
StarterFilmEntry	equ	$ECB4

	org	$F336

	link	a6,#$FFFC
	movem.l	d3/d5-d7/a3-a4,-(sp)
	move.l	$8(a6),d5
	move.l	#$C0000,-$4(a6)
	lea.l	StarterFilmEntry(pc),a0
	lea.l	$40(a0),a4
	jsr	InitWorld(pc)
	move.l	d5,-(sp)
	pea.l	X_F57C(pc)
	jsr	aprint(pc)
	moveq	#-1,d0
	move.l	d0,$40(a4)
	pea.l	$800.w
	jsr	mmalloc(pc)
	movea.l	d0,a3
	move.l	a3,d0
	lea.l	$C(sp),sp
	bne.b	LF37E
	moveq	#-1,d0
	bra.w	LF52E
LF37E	move.l	a3,-(sp)
	moveq	#$1,d0
	move.l	d0,-(sp)
	move.l	d5,-(sp)
	jsr	StartFilmRead(pc)
	jsr	WaitIODone(pc)
	cmpi.l	#$46494C4D,(a3)
	lea.l	$C(sp),sp
	beq.b	LF3AC
	move.l	d5,-(sp)
	pea.l	X_F56A(pc)
	jsr	aprint(pc)
	moveq	#-1,d0
	addq.w	#$8,sp
	bra.w	LF52E
LF3AC	move.l	$4(a3),d7
	move.l	d7,d0
	; SNASM rewrites add.l #imm,dn into addi.l. The disc is D0BC.
	dc.w	$D0BC
	dc.l	$000007FF
	move.l	#$800,d1
	jsr	X_10332(pc)
	move.l	d0,d6
	moveq	#$1,d0
	cmp.l	d6,d0
	bge.b	LF414
	move.l	a3,-(sp)
	jsr	ffree(pc)
	move.l	d6,d1
	move.l	d1,d0
	mulu.w	#$800,d1
	swap	d0
	mulu.w	#$800,d0
	swap	d0
	clr.w	d0
	add.l	d0,d1
	move.l	d1,-(sp)
	jsr	mmalloc(pc)
	movea.l	d0,a3
	move.l	a3,d0
	addq.w	#$8,sp
	bne.b	LF3F8
	moveq	#-1,d0
	bra.w	LF52E
LF3F8	move.l	d6,-(sp)
	pea.l	X_F55A(pc)
	jsr	aprint(pc)
	move.l	a3,-(sp)
	move.l	d6,-(sp)
	move.l	d5,-(sp)
	jsr	StartFilmRead(pc)
	jsr	WaitIODone(pc)
	lea.l	$14(sp),sp
LF414	move.l	$4(a3),$8(a4)
	move.l	a3,d0
	moveq	#$10,d1
	add.l	d1,d0
	move.l	d0,$C(a4)
	movea.l	d0,a0
	move.l	$4(a0),d0
	add.l	$C(a4),d0
	move.l	d0,$10(a4)
	move.l	a3,$14(a4)
	pea.l	X_F54E(pc)
	jsr	aprint(pc)
	move.l	d5,-(sp)
	pea.l	$18(a4)
	jsr	X_FE26(pc)
	tst.w	d0
	lea.l	$C(sp),sp
	beq.b	LF456
	moveq	#-1,d0
	bra.w	LF52E
LF456	pea.l	$18(a4)
	jsr	X_FFA8(pc)
	pea.l	X_F544(pc)
	jsr	aprint(pc)
	moveq	#$0,d5
	move.l	d5,d6
	move.l	d6,d7
	addq.w	#$8,sp
	bra.b	LF496
LF470	movea.l	$10(a4),a0
	move.l	d7,d0
	asl.l	#$4,d0
	lea.l	$10(a0,d0.l),a3
	moveq	#-1,d0
	cmp.l	$8(a3),d0
	seq.b	d3
	neg.b	d3
	beq.b	LF48E
	move.l	d5,d0
	addq.l	#$1,d5
	bra.b	LF492
LF48E	move.l	d6,d0
	addq.l	#$1,d6
LF492	move.l	d7,d0
	addq.l	#$1,d7
LF496	movea.l	$10(a4),a0
	cmp.l	$C(a0),d7
	blt.b	LF470
	lea.l	StarterFilmEntry(pc),a0
	moveq	#$0,d0
	move.l	d0,$3C(a0)
	tst.l	d6
	bne.b	LF4B8
	lea.l	StarterFilmEntry(pc),a0
	moveq	#-1,d0
	move.l	d0,$3C(a0)
LF4B8	tst.l	d5
	bne.b	LF4C6
	lea.l	StarterFilmEntry(pc),a0
	moveq	#$1,d0
	move.l	d0,$3C(a0)
LF4C6	lea.l	StarterFilmEntry(pc),a0
	movea.l	-$4(a6),a1
	move.l	$20(a0),(a1)
	lea.l	StarterFilmEntry(pc),a0
	lea.l	StarterFilmEntry(pc),a1
	move.l	$28(a1),d0
	add.l	d0,d0
	add.l	$24(a0),d0
	lea.l	StarterFilmEntry(pc),a0
	move.l	$2C(a0),d1
	asl.l	#$7,d1
	add.l	d0,d1
	movea.l	-$4(a6),a0
	move.l	d1,$4(a0)
	lea.l	StarterFilmEntry(pc),a0
	movea.l	-$4(a6),a1
	move.l	$30(a0),$8(a1)
	jsr	SwapMeg(pc)
	moveq	#$3,d0
	move.l	d0,-(sp)
	jsr	X_FD9E(pc)
	moveq	#$0,d0
	move.l	d0,$40(a4)
	moveq	#$3C,d0
	move.l	d0,-(sp)
	jsr	Wait(pc)
	pea.l	$30(a4)
	jsr	X_100D8(pc)
	moveq	#$0,d0
	lea.l	$C(sp),sp
LF52E	movem.l	-$1C(a6),d3/d5-d7/a3-a4
	unlk	a6
	rts
