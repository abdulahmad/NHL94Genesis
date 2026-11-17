; STARTER.BIN movie switch, file $3D94, runtime $25094.
; Word at 4(sp) is 0: save the caller's pointers, install two BIOS
; vectors, and call FilmOpen ($25636).
; Word is 1: FilmTask. Any other value: FilmClose, then restore the vectors.
; See docs/segacd_film.md.



.l25094	tst.w	$4(sp)
	bne.b	.l250F6
	link	a6,#$0
	movem.l	d1-d7/a0-a5,-(sp)
	lea.l	RestoreBios_78(pc),a0
	move.l	$12(a6),(a0)
	lea.l	RestoreBios_77(pc),a0
	move.l	$E(a6),(a0)
	lea.l	RestoreBios_82(pc),a0
	move.l	$22(a6),(a0)+
	move.l	$1E(a6),(a0)+
	move.l	$1A(a6),(a0)+
	move.l	$16(a6),(a0)+
	move.l	$26(a6),(a0)+
	move.l	$2A(a6),(a0)+
	movea.l	#$FF8000,a5
	ori.w	#$4,$2(a5)
	jsr	RestoreBios_86(pc)
	jsr	RestoreBios_96(pc)
	move.l	$A(a6),-(sp)
	jsr	Wait_1(pc)
	addq.w	#$4,sp
	movem.l	(sp)+,d1-d7/a0-a5
	unlk	a6
	tst.l	d0
	rts
.l250F6	link	a6,#$0
	movem.l	d1-d7/a0-a5,-(sp)
	move.w	$8(a6),d0
	subq.w	#$1,d0
	bne.b	.l2510C
	jsr	Wait_10(pc)
	bra.b	.l2511A
.l2510C	jsr	Wait_23(pc)
	jsr	RestoreBios_87(pc)
	jsr	RestoreBios_97(pc)
	moveq	#$0,d0
.l2511A	movem.l	(sp)+,d1-d7/a0-a5
	unlk	a6
	tst.l	d0
	rts
	move.w	$0.w,d0
.l25128	addq.w	#$1,$0.w
	cmp.w	$0.w,d0
	beq.b	.l25128
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
RestoreBios_85	ori.b	#$0,d0
RestoreBios_86	lea.l	RestoreBios_85(pc),a0
	move.l	$5F36.w,(a0)
	lea.l	RestoreBios_88(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F36.w
	move.w	(sp)+,sr
	rts
RestoreBios_87	movea.l	RestoreBios_85(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F36.w
	move.w	(sp)+,sr
	rts
RestoreBios_88	movem.l	d0/a0,-(sp)
	lea.l	RestoreBios_76(pc),a0
	addq.l	#$1,(a0)
	move.l	RestoreBios_83(pc),d0
	beq.b	.l251A4
	movea.l	d0,a0
	jsr	(a0)
.l251A4	movem.l	(sp)+,d0/a0
	rts

