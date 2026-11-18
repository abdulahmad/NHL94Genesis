; Steps an animation script to its next frame or loop point.
AnimNextFrame	movea.l	(a4),a1
	move.w	$2(a1),d2
	subq.w	#$1,(a2)
	bpl.w	.next4
	addq.l	#$4,a1
	move.w	(a1),d0
	bpl.w	.next3
	move.w	$2(a1),d0
	beq.w	.next
	bmi.w	.next2
.next	move.l	a3,(a4)
	addq.l	#$4,(a4)
	movea.l	(a4),a1
	move.w	(a1),d0
	bra.w	.next3
.next2	subq.l	#$4,a1
	move.w	(a1),d0
.next3	move.w	d0,(a2)
	move.w	$2(a1),d2
	move.l	a1,(a4)
.next4	tst.w	d2
	bmi.w	.ex
	move.w	(a3)+,d0
	move.w	(a3),d1
	bsr.w	SpriteListAddObject
.ex	rts
; Stores the animation state and sends command 4.
QueueAnimCmd	move.w	d4,(a3)
	move.l	a0,(a1)
	addq.l	#$4,(a1)
	move.w	$4(a0),(a2)
	movea.l	a4,a0
	lea.l	$8(a0),a2
	bsr.w	SendCmd4Args
	rts
; Stores -d0 in the frame counter and waits until it counts up past zero.
WaitCountdown	neg.w	d0
	move.w	d0,$10AE0.l
.loop	tst.w	$10AE0.l
	bmi.b	.loop
	rts