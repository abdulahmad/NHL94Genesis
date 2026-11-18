; STARTER.BIN movie switch, file $3D94, runtime $25094.
; Word at 4(sp) is 0: save the caller's pointers, install two BIOS
; vectors, and call FilmOpen ($25636).
; Word is 1: FilmTask. Any other value: FilmClose, then restore the vectors.
; See docs/segacd_film.md.



; Movie switch: word at 4(sp) = 0 opens the film, 1 runs a task step, anything else closes it and restores the vectors.
FilmSwitch	tst.w	$4(sp)
	bne.b	.next
	link	a6,#$0
	movem.l	d1-d7/a0-a5,-(sp)
	lea.l	FilmSavedArg1(pc),a0
	move.l	$12(a6),(a0)
	lea.l	FilmSavedArg2(pc),a0
	move.l	$E(a6),(a0)
	lea.l	FilmSavedVectors(pc),a0
	move.l	$22(a6),(a0)+
	move.l	$1E(a6),(a0)+
	move.l	$1A(a6),(a0)+
	move.l	$16(a6),(a0)+
	move.l	$26(a6),(a0)+
	move.l	$2A(a6),(a0)+
	movea.l	#$FF8000,a5
	ori.w	#$4,$2(a5)
	jsr	InstallIrqHook1(pc)
	jsr	InstallIrqHook2(pc)
	move.l	$A(a6),-(sp)
	jsr	FilmOpen(pc)
	addq.w	#$4,sp
	movem.l	(sp)+,d1-d7/a0-a5
	unlk	a6
	tst.l	d0
	rts
.next	link	a6,#$0
	movem.l	d1-d7/a0-a5,-(sp)
	move.w	$8(a6),d0
	subq.w	#$1,d0
	bne.b	.next2
	jsr	FilmTask(pc)
	bra.b	.next3
.next2	jsr	FilmClose(pc)
	jsr	RemoveIrqHook1(pc)
	jsr	RemoveIrqHook2(pc)
	moveq	#$0,d0
.next3	movem.l	(sp)+,d1-d7/a0-a5
	unlk	a6
	tst.l	d0
	rts
	move.w	$0.w,d0
.loop	addq.w	#$1,$0.w
	cmp.w	$0.w,d0
	beq.b	.loop
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
; The BIOS vector at $5F36, saved while the first interrupt hook is installed.
SavedBiosVector5F36	ori.b	#$0,d0
; Saves the level vector at $5F36 and installs the stream interrupt handler.
InstallIrqHook1	lea.l	SavedBiosVector5F36(pc),a0
	move.l	$5F36.w,(a0)
	lea.l	CdIrqHook1(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F36.w
	move.w	(sp)+,sr
	rts
; Restores the vector at $5F36.
RemoveIrqHook1	movea.l	SavedBiosVector5F36(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F36.w
	move.w	(sp)+,sr
	rts
; First CD interrupt hook: counts a tick and calls FilmTickCallback.
CdIrqHook1	movem.l	d0/a0,-(sp)
	lea.l	FilmIrqTicks(pc),a0
	addq.l	#$1,(a0)
	move.l	FilmTickCallback(pc),d0
	beq.b	.next
	movea.l	d0,a0
	jsr	(a0)
.next	movem.l	(sp)+,d0/a0
	rts

