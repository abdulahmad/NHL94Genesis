; STARTER.BIN FilmClose, file $473A, runtime $25A3A.
; Frees the film block and sets the frame index back to -1.
; See docs/segacd_film.md.



; C function FilmClose (Sierra C name tag follows it).
FilmClose	link	a6,#$0
	move.l	a4,-(sp)
	lea.l	RestoreBios_85(pc),a0
	lea.l	$40(a0),a4
	pea.l	$30(a4)
	jsr	GetData_10(pc)
	jsr	RestoreBios_110(pc)
	pea.l	$18(a4)
	jsr	DisposeEngine(pc)
	moveq	#-1,d0
	move.l	d0,$40(a4)
	move.l	$14(a4),-(sp)
	jsr	ffree(pc)
	moveq	#$3,d0
	move.l	d0,-(sp)
	jsr	SendCommandToMain(pc)
	moveq	#$0,d0
	movea.l	-$4(a6),a4
	unlk	a6
	rts

