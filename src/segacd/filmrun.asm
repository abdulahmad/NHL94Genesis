; STARTER.BIN movie switch, file $3D94, runtime $ED94.
; Word at 4(sp) is 0: save the caller's pointers, install two BIOS
; vectors, and call FilmOpen ($F336).
; Word is 1: FilmTask. Any other value: FilmClose, then restore the vectors.
; See docs/segacd_film.md.

FilmCallback	equ	$ECE8
FilmFrameTicks	equ	$ECB8
RemoveFilmReadHook	equ	$F118
FilmClose	equ	$F73A
FilmTask	equ	$F58C
FilmOpen	equ	$F336
InstallFilmReadHook	equ	$F0FE
FilmDisplayArgs	equ	$ECD4
FilmBuffer	equ	$ECBC
FilmBufferSize	equ	$ECC0

	org	$ED94

FilmSwitchBody						;FilmSwitch's body (StarterFilmEntry branches here)
	tst.w	$4(sp)
	bne.b	LEDF6
	link	a6,#$0
	movem.l	d1-d7/a0-a5,-(sp)
	lea.l	FilmBufferSize(pc),a0
	move.l	$12(a6),(a0)
	lea.l	FilmBuffer(pc),a0
	move.l	$E(a6),(a0)
	lea.l	FilmDisplayArgs(pc),a0
	move.l	$22(a6),(a0)+
	move.l	$1E(a6),(a0)+
	move.l	$1A(a6),(a0)+
	move.l	$16(a6),(a0)+
	move.l	$26(a6),(a0)+
	move.l	$2A(a6),(a0)+
	movea.l	#$FF8000,a5
	ori.w	#$4,$2(a5)
	jsr	InstallFilmHook(pc)
	jsr	InstallFilmReadHook(pc)
	move.l	$A(a6),-(sp)
	jsr	FilmOpen(pc)
	addq.w	#$4,sp
	movem.l	(sp)+,d1-d7/a0-a5
	unlk	a6
	tst.l	d0
	rts
LEDF6	link	a6,#$0
	movem.l	d1-d7/a0-a5,-(sp)
	move.w	$8(a6),d0
	subq.w	#$1,d0
	bne.b	LEE0C
	jsr	FilmTask(pc)
	bra.b	LEE1A
LEE0C	jsr	FilmClose(pc)
	jsr	RemoveFilmHook(pc)
	jsr	RemoveFilmReadHook(pc)
	moveq	#$0,d0
LEE1A	movem.l	(sp)+,d1-d7/a0-a5
	unlk	a6
	tst.l	d0
	rts
	move.w	$0.w,d0
LEE28	addq.w	#$1,$0.w
	cmp.w	$0.w,d0
	beq.b	LEE28
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
SavedFilmHookJump					;the old target of the BIOS jump at $5F34
	ori.b	#$0,d0
InstallFilmHook						;FilmHook into the BIOS jump at $5F34
	lea.l	SavedFilmHookJump(pc),a0
	move.l	$5F36.w,(a0)
	lea.l	FilmHook(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F36.w
	move.w	(sp)+,sr
	rts
RemoveFilmHook
	movea.l	SavedFilmHookJump(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F36.w
	move.w	(sp)+,sr
	rts
FilmHook							;FilmFrameTicks + 1, then FilmCallback
	movem.l	d0/a0,-(sp)
	lea.l	FilmFrameTicks(pc),a0
	addq.l	#$1,(a0)
	move.l	FilmCallback(pc),d0
	beq.b	LEEA4
	movea.l	d0,a0
	jsr	(a0)
LEEA4	movem.l	(sp)+,d0/a0
	rts
