; STARTER.BIN movie switch, file $3D94, runtime $25094.
; Word at 4(sp) is 0: save the caller's pointers, install two BIOS
; vectors, and call FilmOpen ($25636).
; Word is 1: FilmTask. Any other value: FilmClose, then restore the vectors.
; See docs/segacd_film.md.



L25094	tst.w	$4(sp)
	bne.b	L250F6
	link	a6,#$0
	movem.l	d1-d7/a0-a5,-(sp)
	lea.l	L24FC0(pc),a0
	move.l	$12(a6),(a0)
	lea.l	L24FBC(pc),a0
	move.l	$E(a6),(a0)
	lea.l	L24FD4(pc),a0
	move.l	$22(a6),(a0)+
	move.l	$1E(a6),(a0)+
	move.l	$1A(a6),(a0)+
	move.l	$16(a6),(a0)+
	move.l	$26(a6),(a0)+
	move.l	$2A(a6),(a0)+
	movea.l	#$FF8000,a5
	ori.w	#$4,$2(a5)
	jsr	L25164(pc)
	jsr	L253FE(pc)
	move.l	$A(a6),-(sp)
	jsr	L25636(pc)
	addq.w	#$4,sp
	movem.l	(sp)+,d1-d7/a0-a5
	unlk	a6
	tst.l	d0
	rts
L250F6	link	a6,#$0
	movem.l	d1-d7/a0-a5,-(sp)
	move.w	$8(a6),d0
	subq.w	#$1,d0
	bne.b	L2510C
	jsr	L2588C(pc)
	bra.b	L2511A
L2510C	jsr	L25A3A(pc)
	jsr	L2517E(pc)
	jsr	L25418(pc)
	moveq	#$0,d0
L2511A	movem.l	(sp)+,d1-d7/a0-a5
	unlk	a6
	tst.l	d0
	rts
	move.w	$0.w,d0
L25128	addq.w	#$1,$0.w
	cmp.w	$0.w,d0
	beq.b	L25128
	move.w	d0,$0.w
	clr.l	$8.w
	clr.l	$C.w
	clr.l	$10.w
	clr.l	$14.w
	clr.l	$18.w
	clr.l	$1C.w
	clr.l	$20.w
	clr.l	$24.w
	move.l	#$208008,$80.w
	rts
L25160	ori.b	#$0,d0
L25164	lea.l	L25160(pc),a0
	move.l	$5F36.w,(a0)
	lea.l	L25190(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F36.w
	move.w	(sp)+,sr
	rts
L2517E	movea.l	L25160(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F36.w
	move.w	(sp)+,sr
	rts
L25190	movem.l	d0/a0,-(sp)
	lea.l	L24FB8(pc),a0
	addq.l	#$1,(a0)
	move.l	L24FE8(pc),d0
	beq.b	L251A4
	movea.l	d0,a0
	jsr	(a0)
L251A4	movem.l	(sp)+,d0/a0
	rts

