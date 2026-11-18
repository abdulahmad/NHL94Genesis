; Points the sprite list registers at $BA8D2/$BAF16 and restarts the count.
SpriteListReset	movea.l	#$BA8D2,a5
	movea.l	#$BAF16,a6
	moveq	#$1,d6
	rts
; Adds the sprites of one object to the list (max $50).
SpriteListAddObject	cmpi.w	#$50,d6
	bgt.w	RtsStub
	movem.l	d0-d5/a0,-(sp)
	adda.l	$4(a0),a0
	move.w	d2,d5
	andi.w	#$7FF,d2
	add.w	d2,d2
	move.w	(a0,d2.w),d3
	sub.w	-$2(a0,d2.w),d3
	lsr.w	#$3,d3
	subq.w	#$1,d3
	adda.w	-$2(a0,d2.w),a0
.loop	move.w	$2(a0),(a6)
	add.w	d1,(a6)+
	move.b	$7(a0),(a6)+
	move.b	d6,(a6)+
	move.w	$6(a0),d2
	eor.w	d5,d2
	andi.w	#$F800,d2
	add.w	$4(a0),d2
	add.w	d4,d2
	move.w	d2,(a6)+
	move.w	(a0),(a6)
	add.w	d0,(a6)+
	addq.w	#$1,d6
	cmpi.w	#$51,d6
	beq.w	.next
	addq.l	#$8,a0
	dbra	d3,.loop
.next	movem.l	(sp)+,d0-d5/a0
	rts
; Terminates the sprite list.
SpriteListFinish	moveq	#-1,d0
	add.w	d6,d0
	bne.w	.next
	moveq	#$1,d0
	clr.l	(a6)+
	clr.l	(a6)+
.next	cmpi.w	#$50,d0
	ble.w	.next2
	moveq	#$50,d0
.next2	asl.w	#$3,d0
	lea.l	$BAF16.l,a6
	clr.b	-$5(a6,d0.w)
	lsr.w	#$1,d0
	move.w	d0,$BB1E6.l
	move.l	a5,$BAF12.l
	rts
; Copies the sprite data to the buffer at $BC6F0.
SpriteListToVram	movea.l	#$BC6F0,a0
	lea.l	$BA8D2.l,a1
	move.l	#$80000,d1
.loop	cmpa.l	$BAF12.l,a1
	beq.w	.next2
	move.l	(a1),d0
	cmp.l	d1,d0
	bgt.w	.next
	movea.l	d0,a2
	move.w	$4(a1),d0
	subq.w	#$1,d0
	move.l	a0,(a1)
.loop2	move.w	(a2)+,(a0)+
	cmpa.l	#$C0000,a0
	bge.w	.next3
	dbra	d0,.loop2
.next	addq.l	#$8,a1
	bra.b	.loop
.next2	move.l	a0,$10AC8.l
	rts
.next3	bra.b	.next3