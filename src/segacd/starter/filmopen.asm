; STARTER.BIN FilmOpen, file $4336, runtime $25636.
; Requires the long FILM ($46494C4D). Returns -1 on a bad file.
; See docs/segacd_film.md.



; C function FilmOpen (Sierra C name tag follows it).
FilmOpen	link	a6,#$FFFC
	movem.l	d3/d5-d7/a3-a4,-(sp)
	move.l	$8(a6),d5
	move.l	#$C0000,-$4(a6)
	lea.l	FilmEntryVector(pc),a0
	lea.l	$40(a0),a4
	jsr	InitWorld(pc)
	move.l	d5,-(sp)
	pea.l	FilmOpenStrOpening(pc)
	jsr	aprint(pc)
	moveq	#-1,d0
	move.l	d0,$40(a4)
	pea.l	$800.w
	jsr	mmalloc(pc)
	movea.l	d0,a3
	move.l	a3,d0
	lea.l	$C(sp),sp
	bne.b	.next
	moveq	#-1,d0
	bra.w	.next11
.next	move.l	a3,-(sp)
	moveq	#$1,d0
	move.l	d0,-(sp)
	move.l	d5,-(sp)
	jsr	CdBiosReadSequence(pc)
	jsr	WaitIODone(pc)
	cmpi.l	#$46494C4D,(a3)
	lea.l	$C(sp),sp
	beq.b	.next2
	move.l	d5,-(sp)
	pea.l	FilmOpenStrBad(pc)
	jsr	aprint(pc)
	moveq	#-1,d0
	addq.w	#$8,sp
	bra.w	.next11
.next2	move.l	$4(a3),d7
	move.l	d7,d0
	; SNASM rewrites add.l #imm,dn into addi.l. The disc is D0BC.
; Data of FilmOpen (2 rows): table or constants used by it.
	dc.w	$D0BC
	dc.l	$000007FF
	move.l	#$800,d1
	jsr	DataThunkA(pc)
	move.l	d0,d6
	moveq	#$1,d0
	cmp.l	d6,d0
	bge.b	.next4
	move.l	a3,-(sp)
	jsr	ffree(pc)
	move.l	d6,d1
	move.l	d1,d0
	mulu.w	#$800,d1
	swap	d0
	mulu.w	#$800,d0
	swap	d0
	clr.w	d0
	add.l	d0,d1
	move.l	d1,-(sp)
	jsr	mmalloc(pc)
	movea.l	d0,a3
	move.l	a3,d0
	addq.w	#$8,sp
	bne.b	.next3
	moveq	#-1,d0
	bra.w	.next11
.next3	move.l	d6,-(sp)
	pea.l	FilmOpenStrSects(pc)
	jsr	aprint(pc)
	move.l	a3,-(sp)
	move.l	d6,-(sp)
	move.l	d5,-(sp)
	jsr	CdBiosReadSequence(pc)
	jsr	WaitIODone(pc)
	lea.l	$14(sp),sp
.next4	move.l	$4(a3),$8(a4)
	move.l	a3,d0
	moveq	#$10,d1
	add.l	d1,d0
	move.l	d0,$C(a4)
	movea.l	d0,a0
	move.l	$4(a0),d0
	add.l	$C(a4),d0
	move.l	d0,$10(a4)
	move.l	a3,$14(a4)
	pea.l	FilmOpenStrInit(pc)
	jsr	aprint(pc)
	move.l	d5,-(sp)
	pea.l	$18(a4)
	jsr	InitEngine(pc)
	tst.w	d0
	lea.l	$C(sp),sp
	beq.b	.next5
	moveq	#-1,d0
	bra.w	.next11
.next5	pea.l	$18(a4)
	jsr	EngineIdle(pc)
	pea.l	FilmOpenStrTitle(pc)
	jsr	aprint(pc)
	moveq	#$0,d5
	move.l	d5,d6
	move.l	d6,d7
	addq.w	#$8,sp
	bra.b	.next8
.loop	movea.l	$10(a4),a0
	move.l	d7,d0
	asl.l	#$4,d0
	lea.l	$10(a0,d0.l),a3
	moveq	#-1,d0
	cmp.l	$8(a3),d0
	seq.b	d3
	neg.b	d3
	beq.b	.next6
	move.l	d5,d0
	addq.l	#$1,d5
	bra.b	.next7
.next6	move.l	d6,d0
	addq.l	#$1,d6
.next7	move.l	d7,d0
	addq.l	#$1,d7
.next8	movea.l	$10(a4),a0
	cmp.l	$C(a0),d7
	blt.b	.loop
	lea.l	FilmEntryVector(pc),a0
	moveq	#$0,d0
	move.l	d0,$3C(a0)
	tst.l	d6
	bne.b	.next9
	lea.l	FilmEntryVector(pc),a0
	moveq	#-1,d0
	move.l	d0,$3C(a0)
.next9	tst.l	d5
	bne.b	.next10
	lea.l	FilmEntryVector(pc),a0
	moveq	#$1,d0
	move.l	d0,$3C(a0)
.next10	lea.l	FilmEntryVector(pc),a0
	movea.l	-$4(a6),a1
	move.l	$20(a0),(a1)
	lea.l	FilmEntryVector(pc),a0
	lea.l	FilmEntryVector(pc),a1
	move.l	$28(a1),d0
	add.l	d0,d0
	add.l	$24(a0),d0
	lea.l	FilmEntryVector(pc),a0
	move.l	$2C(a0),d1
	asl.l	#$7,d1
	add.l	d0,d1
	movea.l	-$4(a6),a0
	move.l	d1,$4(a0)
	lea.l	FilmEntryVector(pc),a0
	movea.l	-$4(a6),a1
	move.l	$30(a0),$8(a1)
	jsr	SwapMeg(pc)
	moveq	#$3,d0
	move.l	d0,-(sp)
	jsr	SendCommandToMain(pc)
	moveq	#$0,d0
	move.l	d0,$40(a4)
	moveq	#$3C,d0
	move.l	d0,-(sp)
	jsr	Wait(pc)
	pea.l	$30(a4)
	jsr	AudioInit(pc)
	moveq	#$0,d0
	lea.l	$C(sp),sp
.next11	movem.l	-$1C(a6),d3/d5-d7/a3-a4
	unlk	a6
	rts

