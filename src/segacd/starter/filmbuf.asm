; STARTER.BIN film buffer, file $4E26, runtime $26126.
; Asks $25E34 for a size, clamps it to $14000-$34000, and allocates
; that many bytes plus $4000. See docs/segacd_film.md.



; C function InitEngine (Sierra C name tag follows it).
InitEngine	link	a6,#$0
	movem.l	d7/a4,-(sp)
	movea.l	$8(a6),a4
	jsr	MaxFree_2(pc)
	move.l	d0,d7
	cmpi.l	#$14000,d7
	bge.b	.l26144
	moveq	#-1,d0
	bra.b	.l261B6
.l26144	cmpi.l	#$34000,d7
	ble.b	.l26152
	move.l	#$34000,d7
.l26152	move.l	d7,d0
	; SNASM rewrites sub.l #imm,dn into subi.l. The disc is 90BC.
	dc.w	$90BC
	dc.l	$00004000
	move.l	#$800,d1
	jsr	GetData_15(pc)
	move.l	d0,d1
	mulu.w	#$800,d0
	swap	d1
	mulu.w	#$800,d1
	swap	d1
	clr.w	d1
	add.l	d1,d0
	move.l	d0,$4(a4)
	; SNASM rewrites add.l #imm,dn into addi.l. The disc is D0BC.
	dc.w	$D0BC
	dc.l	$00004000
	move.l	d0,-(sp)
	jsr	mmalloc_2(pc)
	move.l	d0,(a4)
	addq.w	#$4,sp
	bne.b	.l26190
	moveq	#-1,d0
	bra.b	.l261B6
.l26190	moveq	#$0,d0
	move.l	d0,$8(a4)
	move.l	d0,$C(a4)
	move.l	$C(a6),$10(a4)
	move.l	d0,$14(a4)
	lea.l	RestoreBios_91(pc),a0
	move.l	a4,$1C(a0)
	move.l	a4,-(sp)
	jsr	EngineIdle(pc)
	moveq	#$0,d0
	addq.w	#$4,sp
.l261B6	movem.l	-$8(a6),d7/a4
	unlk	a6
	rts

