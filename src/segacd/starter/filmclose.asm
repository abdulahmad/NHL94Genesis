; STARTER.BIN FilmClose, file $473A, runtime $25A3A.
; Frees the film block and sets the frame index back to -1.
; See docs/segacd_film.md.



L25A3A	link	a6,#$0
	move.l	a4,-(sp)
	lea.l	L24FB4(pc),a0
	lea.l	$40(a0),a4
	pea.l	$30(a4)
	jsr	L26556(pc)
	jsr	L25536(pc)
	pea.l	$18(a4)
	jsr	L261CE(pc)
	moveq	#-1,d0
	move.l	d0,$40(a4)
	move.l	$14(a4),-(sp)
	jsr	L25CFA(pc)
	moveq	#$3,d0
	move.l	d0,-(sp)
	jsr	L2609E(pc)
	moveq	#$0,d0
	movea.l	-$4(a6),a4
	unlk	a6
	rts

