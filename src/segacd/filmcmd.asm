; STARTER.BIN movie command, file $4D9E, runtime $FD9E.
; Waits until $FF8010 is clear, posts the caller's word at $FF8020,
; waits until $FF8010 is set, then clears $FF8020.
; Main CPU GetCommandFromSub is the other side. FilmTask posts 2.
; See docs/segacd_film.md.

	org	$FD9E

	link	a6,#$0
	movem.l	a3-a4,-(sp)
	movea.l	#$FF8010,a4
	movea.l	#$FF8020,a3
LFDB2	tst.w	(a4)
	bne.b	LFDB2
	move.w	$A(a6),(a3)
LFDBA	tst.w	(a4)
	beq.b	LFDBA
	clr.w	(a3)
	movem.l	-$8(a6),a3-a4
	unlk	a6
	rts
