; Prints a zero-terminated string with the special characters at a0.
PrintTextLine	move.w	#$7A0,d0
	bset	#$E,d0
.loop	moveq	#$0,d2
	move.b	(a0)+,d2
	beq.w	.next4
	cmpi.b	#$22,d2
	beq.w	.next
	cmpi.b	#$5F,d2
	beq.w	.next
	cmpi.b	#$24,d2
	beq.w	.next2
	bra.w	.next3
.next	move.b	#$20,d2
	bra.w	.next3
.next2	move.b	#$22,d2
.next3	move.b	d2,(a5)+
	subi.b	#$20,d2
	add.w	d0,d2
.loop2	btst.b	#$7,$FF800E.l
	bne.b	.loop2
	move.w	d2,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	beq.b	.loop3
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop4	btst.b	#$6,$FF800E.l
	bne.b	.loop4
	bclr.b	#$7,$FF800F.l
	subq.w	#$1,d1
	bra.w	.loop
.next4	tst.w	d1
	blt.w	.next5
.loop5	btst.b	#$7,$FF800E.l
	bne.b	.loop5
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	beq.b	.loop6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop7	btst.b	#$6,$FF800E.l
	bne.b	.loop7
	bclr.b	#$7,$FF800F.l
	move.b	#$20,(a5)+
	dbra	d1,.loop5
	subq.l	#$1,a5
.next5	clr.b	(a5)+
	rts
; Prints a string at a4 (stops at 0 or $FF).
PrintTextPlain	movem.l	d0-d2/a4,-(sp)
	move.w	#$7A0,d0
	bset	#$E,d0
.loop	moveq	#$0,d2
	move.b	(a4)+,d2
	beq.w	.next
	cmpi.b	#$FF,d2
	beq.w	.next
	subi.b	#$20,d2
	add.w	d0,d2
.loop2	btst.b	#$7,$FF800E.l
	bne.b	.loop2
	move.w	d2,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	beq.b	.loop3
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop4	btst.b	#$6,$FF800E.l
	bne.b	.loop4
	bclr.b	#$7,$FF800F.l
	subq.b	#$1,d1
	bra.w	.loop
.next	subq.b	#$1,d1
	tst.b	d1
	bmi.w	.next2
.loop5	btst.b	#$7,$FF800E.l
	bne.b	.loop5
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	beq.b	.loop6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop7	btst.b	#$6,$FF800E.l
	bne.b	.loop7
	bclr.b	#$7,$FF800F.l
	dbra	d1,.loop5
.next2	movem.l	(sp)+,d0-d2/a4
	rts
; Copies at most d0 characters of a0 to the string buffer $8E(a6).
CopyStringToBuffer	movem.l	d0/a0-a1,-(sp)
	movea.l	$8E(a6),a1
.loop	move.b	(a0)+,(a1)+
	beq.w	.next
	dbra	d0,.loop
	clr.b	(a1)
.next	movem.l	(sp)+,d0/a0-a1
	rts
; Spins until the word-RAM DMNA bit is set.
WaitDmnaSet	btst.b	#$1,$FF8003.l
	beq.b	WaitDmnaSet
	rts
; Sets the word-RAM request bit and waits until it is granted.
GiveWordRam	bset.b	#$0,$FF8003.l
.loop	btst.b	#$1,$FF8003.l
	bne.b	.loop
	rts
; Loads a command through the gate-array comm registers.
GateArrayLoadCmd	movem.l	d0-d7/a0-a2,-(sp)
	bclr.b	#$5,$FF800F.l
.loop	btst.b	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$3D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop2	btst.b	#$6,$FF800E.l
	beq.b	.loop2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	bne.b	.loop3
	bclr.b	#$7,$FF800F.l
	bset.b	#$5,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a2
	rts