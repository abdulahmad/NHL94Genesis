	dc.b	$91,$53,$65,$6E,$64,$43,$6F,$6D,$6D,$61,$6E,$64,$54,$6F,$4D,$61	; .SendCommandToMa
	dc.b	$69,$6E,$00,$00	; in..
CopyData	dc.w	$4E56,$0000
Sub_260E2	movem.l	d4-d7,-(sp)
	move.l	$C(a6),d4
	move.l	$8(a6),d5
	move.l	$10(a6),d6
	move.l	d6,d0
	addq.l	#$3,d0
	asr.l	#$2,d0
	move.l	d0,d6
	moveq	#$0,d7
	dc.w	$600E
L260FE	movea.l	d5,a0
Sub_26100	addq.l	#$4,d5
	movea.l	d4,a1
	addq.l	#$4,d4
	move.l	(a0),(a1)
	move.l	d7,d0
	addq.l	#$1,d7
L2610C	cmp.l	d7,d6
	bgt.b	L260FE
	movem.l	-$10(a6),d4-d7
	unlk	a6
	dc.w	$4E75
	dc.b	$88,$43,$6F,$70,$79,$44,$61,$74,$61,$00,$00,$00	; .CopyData...
