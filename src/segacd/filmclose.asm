; STARTER.BIN FilmClose, file $473A, runtime $F73A.
; Frees the film block and sets the frame index back to -1.
; See docs/segacd_film.md.

X_FD9E	equ	$FD9E
ffree	equ	$F9FA
DisposeEngine	equ	$FECE
StopFilmRead	equ	$F236
X_10256	equ	$10256
StarterFilmEntry	equ	$ECB4

	org	$F73A

	link	a6,#$0
	move.l	a4,-(sp)
	lea.l	StarterFilmEntry(pc),a0
	lea.l	$40(a0),a4
	pea.l	$30(a4)
	jsr	X_10256(pc)
	jsr	StopFilmRead(pc)
	pea.l	$18(a4)
	jsr	DisposeEngine(pc)
	moveq	#-1,d0
	move.l	d0,$40(a4)
	move.l	$14(a4),-(sp)
	jsr	ffree(pc)
	moveq	#$3,d0
	move.l	d0,-(sp)
	jsr	X_FD9E(pc)
	moveq	#$0,d0
	movea.l	-$4(a6),a4
	unlk	a6
	rts
