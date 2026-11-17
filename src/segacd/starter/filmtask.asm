; STARTER.BIN FilmTask, file $458C, runtime $2588C.
; Steps one 16-byte record. An SM chunk ($534D) goes to filmsm.
; See docs/segacd_film.md.



; C function FilmTask (Sierra C name tag follows it).
FilmTask	link	a6,#$FFFC
	movem.l	d7/a3-a4,-(sp)
	move.l	#$C0000,-$4(a6)
	lea.l	RestoreBios_97(pc),a0
	lea.l	$40(a0),a4
	lea.l	RestoreBios_97(pc),a0
	tst.l	$38(a0)
	beq.b	.next
	moveq	#-2,d0
	bra.w	.next12
.next	tst.l	$40(a4)
	bge.b	.next2
	moveq	#-1,d0
	bra.w	.next12
.next2	lea.l	RestoreBios_97(pc),a0
	moveq	#$1,d0
	cmp.l	$3C(a0),d0
	bne.b	.next3
	pea.l	$30(a4)
	jsr	AudioSilence(pc)
	addq.w	#$4,sp
.next3	movea.l	$10(a4),a0
	move.l	$40(a4),d0
	addq.l	#$1,$40(a4)
	asl.l	#$4,d0
	lea.l	$10(a0,d0.l),a3
	moveq	#-1,d0
	cmp.l	$8(a3),d0
	bne.w	.next7
	bra.b	.next4
.loop	pea.l	$18(a4)
	jsr	EngineIdle(pc)
	pea.l	$30(a4)
	jsr	AudioIdle(pc)
	addq.w	#$8,sp
.next4	move.l	$4(a3),-(sp)
	move.l	(a3),d0
	add.l	$8(a4),d0
	move.l	d0,-(sp)
	pea.l	$18(a4)
	jsr	GetData(pc)
	move.l	d0,d7
	lea.l	$C(sp),sp
	beq.b	.loop
	move.l	$4(a3),-(sp)
	move.l	d7,-(sp)
	pea.l	$30(a4)
	jsr	AudioFeed(pc)
	lea.l	RestoreBios_97(pc),a0
	moveq	#-1,d0
	cmp.l	$3C(a0),d0
	lea.l	$C(sp),sp
	bne.b	.next6
	bra.b	.next5
.loop2	pea.l	$30(a4)
	jsr	AudioIdle(pc)
	addq.w	#$4,sp
.next5	pea.l	$30(a4)
	jsr	AudioBusy(pc)
	tst.w	d0
	addq.w	#$4,sp
	bne.b	.loop2
.next6	move.l	$4(a3),-(sp)
	move.l	(a3),d0
	add.l	$8(a4),d0
	move.l	d0,-(sp)
	pea.l	$18(a4)
	jsr	SetBlockEnd(pc)
	lea.l	$C(sp),sp
	bra.w	.next10
.loop3	pea.l	$30(a4)
	jsr	AudioIdle(pc)
	pea.l	$18(a4)
	jsr	EngineIdle(pc)
	addq.w	#$8,sp
.next7	move.l	$4(a3),-(sp)
	move.l	(a3),d0
	add.l	$8(a4),d0
	move.l	d0,-(sp)
	pea.l	$18(a4)
	jsr	GetData(pc)
	move.l	d0,d7
	lea.l	$C(sp),sp
	beq.b	.loop3
	movea.l	d7,a0
	cmpi.w	#$534D,(a0)
	bne.b	.next9
	move.l	d7,-(sp)
	move.l	-$4(a6),-(sp)
	jsr	LoadSmImage(pc)
	move.l	#$7FFFFFFF,d7
	and.l	$8(a3),d7
	bra.b	.next8
.loop4	pea.l	$30(a4)
	jsr	AudioIdle(pc)
	pea.l	$18(a4)
	jsr	EngineIdle(pc)
	addq.w	#$8,sp
.next8	pea.l	$258.w
	pea.l	$30(a4)
	jsr	AudioTime(pc)
	cmp.l	d0,d7
	addq.w	#$8,sp
	bgt.b	.loop4
	jsr	SwapMeg(pc)
	moveq	#$2,d0
	move.l	d0,-(sp)
	jsr	SendCommandToMain(pc)
	addq.w	#$4,sp
.next9	move.l	$4(a3),-(sp)
	move.l	(a3),d0
	add.l	$8(a4),d0
	move.l	d0,-(sp)
	pea.l	$18(a4)
	jsr	SetBlockEnd(pc)
	lea.l	$C(sp),sp
.next10	movea.l	$10(a4),a0
	move.l	$40(a4),d0
	cmp.l	$C(a0),d0
	bne.b	.next11
	moveq	#-1,d0
	move.l	d0,$40(a4)
.next11	move.l	$40(a4),d0
.next12	movem.l	-$10(a6),d7/a3-a4
	unlk	a6
	rts

