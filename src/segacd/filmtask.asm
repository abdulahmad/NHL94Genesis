; STARTER.BIN FilmTask, file $458C, runtime $F58C.
; Steps one 16-byte record. An SM chunk ($534D) goes to filmsm.
; See docs/segacd_film.md.

X_FD9E	equ	$FD9E
SwapMeg	equ	$F788
X_102B2	equ	$102B2
CopySmChunk	equ	$EEAA
ReadData	equ	$10068
X_102E8	equ	$102E8
X_10180	equ	$10180
X_FFFC	equ	$FFFC
X_1010C	equ	$1010C
X_FFA8	equ	$FFA8
X_101DE	equ	$101DE
StarterFilmEntry	equ	$ECB4

	org	$F58C

	link	a6,#$FFFC
	movem.l	d7/a3-a4,-(sp)
	move.l	#$C0000,-$4(a6)
	lea.l	StarterFilmEntry(pc),a0
	lea.l	$40(a0),a4
	lea.l	StarterFilmEntry(pc),a0
	tst.l	$38(a0)
	beq.b	LF5B4
	moveq	#-2,d0
	bra.w	LF724
LF5B4	tst.l	$40(a4)
	bge.b	LF5C0
	moveq	#-1,d0
	bra.w	LF724
LF5C0	lea.l	StarterFilmEntry(pc),a0
	moveq	#$1,d0
	cmp.l	$3C(a0),d0
	bne.b	LF5D6
	pea.l	$30(a4)
	jsr	X_101DE(pc)
	addq.w	#$4,sp
LF5D6	movea.l	$10(a4),a0
	move.l	$40(a4),d0
	addq.l	#$1,$40(a4)
	asl.l	#$4,d0
	lea.l	$10(a0,d0.l),a3
	moveq	#-1,d0
	cmp.l	$8(a3),d0
	bne.w	LF688
	bra.b	LF606
LF5F4	pea.l	$18(a4)
	jsr	X_FFA8(pc)
	pea.l	$30(a4)
	jsr	X_1010C(pc)
	addq.w	#$8,sp
LF606	move.l	$4(a3),-(sp)
	move.l	(a3),d0
	add.l	$8(a4),d0
	move.l	d0,-(sp)
	pea.l	$18(a4)
	jsr	X_FFFC(pc)
	move.l	d0,d7
	lea.l	$C(sp),sp
	beq.b	LF5F4
	move.l	$4(a3),-(sp)
	move.l	d7,-(sp)
	pea.l	$30(a4)
	jsr	X_10180(pc)
	lea.l	StarterFilmEntry(pc),a0
	moveq	#-1,d0
	cmp.l	$3C(a0),d0
	lea.l	$C(sp),sp
	bne.b	LF65A
	bra.b	LF64C
LF642	pea.l	$30(a4)
	jsr	X_1010C(pc)
	addq.w	#$4,sp
LF64C	pea.l	$30(a4)
	jsr	X_102E8(pc)
	tst.w	d0
	addq.w	#$4,sp
	bne.b	LF642
LF65A	move.l	$4(a3),-(sp)
	move.l	(a3),d0
	add.l	$8(a4),d0
	move.l	d0,-(sp)
	pea.l	$18(a4)
	jsr	ReadData(pc)
	lea.l	$C(sp),sp
	bra.w	LF70C
LF676	pea.l	$30(a4)
	jsr	X_1010C(pc)
	pea.l	$18(a4)
	jsr	X_FFA8(pc)
	addq.w	#$8,sp
LF688	move.l	$4(a3),-(sp)
	move.l	(a3),d0
	add.l	$8(a4),d0
	move.l	d0,-(sp)
	pea.l	$18(a4)
	jsr	X_FFFC(pc)
	move.l	d0,d7
	lea.l	$C(sp),sp
	beq.b	LF676
	movea.l	d7,a0
	cmpi.w	#$534D,(a0)
	bne.b	LF6F4
	move.l	d7,-(sp)
	move.l	-$4(a6),-(sp)
	jsr	CopySmChunk(pc)
	move.l	#$7FFFFFFF,d7
	and.l	$8(a3),d7
	bra.b	LF6D4
LF6C2	pea.l	$30(a4)
	jsr	X_1010C(pc)
	pea.l	$18(a4)
	jsr	X_FFA8(pc)
	addq.w	#$8,sp
LF6D4	pea.l	$258.w
	pea.l	$30(a4)
	jsr	X_102B2(pc)
	cmp.l	d0,d7
	addq.w	#$8,sp
	bgt.b	LF6C2
	jsr	SwapMeg(pc)
	moveq	#$2,d0
	move.l	d0,-(sp)
	jsr	X_FD9E(pc)
	addq.w	#$4,sp
LF6F4	move.l	$4(a3),-(sp)
	move.l	(a3),d0
	add.l	$8(a4),d0
	move.l	d0,-(sp)
	pea.l	$18(a4)
	jsr	ReadData(pc)
	lea.l	$C(sp),sp
LF70C	movea.l	$10(a4),a0
	move.l	$40(a4),d0
	cmp.l	$C(a0),d0
	bne.b	LF720
	moveq	#-1,d0
	move.l	d0,$40(a4)
LF720	move.l	$40(a4),d0
LF724	movem.l	-$10(a6),d7/a3-a4
	unlk	a6
	rts
