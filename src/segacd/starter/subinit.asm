;	STARTER.BIN $4C84-$4D9D (runtime $FC84-$FD9D).
;
;	InitWorld (prints SUBCPU is alive), GetTicks, WaitIODone.


StarterFilmEntry	equ	$ECB4
aprint	equ	$F8C4
InitHeap	equ	$FC10

	org	$FC84

InitWorld
	link	a6,#$0
	move.l	d7,-(sp)
	clr.w	$FF8020.l
	pea	.LFD52(pc)
	jsr	aprint(pc)
	lea	StarterFilmEntry(pc),a0
	moveq	#$F,d7
	and.l	$8(a0),d7
	tst.l	d7
	addq.w	#$4,sp
	beq.s	.LFCB2
	pea	.LFD46(pc)
	jsr	aprint(pc)
	addq.w	#$4,sp
.LFCB2
	lea	StarterFilmEntry(pc),a0
	move.l	$8(a0),d0
	moveq	#$F,d1
	add.l	d1,d0
	moveq	#-16,d2
	and.l	d0,d2
	lea	StarterFilmEntry(pc),a0
	move.l	d2,$8(a0)
	lea	StarterFilmEntry(pc),a0
	move.l	$C(a0),d0
	sub.l	d7,d0
	moveq	#-16,d2
	and.l	d0,d2
	lea	StarterFilmEntry(pc),a0
	move.l	d2,$C(a0)
	lea	StarterFilmEntry(pc),a0
	move.l	$8(a0),-(sp)
	pea	.LFD36(pc)
	jsr	aprint(pc)
	lea	StarterFilmEntry(pc),a0
	move.l	$C(a0),-(sp)
	pea	.LFD26(pc)
	jsr	aprint(pc)
	lea	StarterFilmEntry(pc),a0
	tst.l	$C(a0)
	lea	$10(sp),sp
	beq.s	.LFD12
	jsr	InitHeap(pc)
.LFD12
	move.l	-$4(a6),d7
	unlk	a6
	rts
	dc.b	$89,'InitWorld'
	dc.w	$003C
.LFD26
	dc.b	'Heap Size : %x'
	dc.w	$0000
.LFD36
	dc.b	'Heap Start: %x'
	dc.w	$0000
.LFD46
	dc.b	'Fixing Heap'
	dc.b	$00
.LFD52
	dc.b	'SUBCPU is alive'
	dc.b	$00
GetTicks
	link	a6,#$0
	lea	StarterFilmEntry(pc),a0
	move.l	$4(a0),d0
	unlk	a6
	rts
	dc.b	$88,'GetTicks',0,0,0
WaitIODone
	link	a6,#$0
.LFD82
	lea	StarterFilmEntry(pc),a0
	tst.l	$10(a0)
	bne.s	.LFD82
	unlk	a6
	rts
	dc.b	$8A,'WaitIODone',0,0,0
