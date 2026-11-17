	dc.b	$8A,$49,$6E,$69,$74,$45,$6E,$67,$69,$6E,$65,$00,$00,$00	; .InitEngine...
L261CE	dc.w	$4E56,$0000
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	tst.l	(a4)
	dc.w	$6708
	move.l	(a4),-(sp)
	jsr	L25CFA(pc)
	addq.w	#$4,sp
.l4EE4	movea.l	-$4(a6),a4
	unlk	a6
	dc.w	$4E75
	dc.b	$8D,$44,$69,$73,$70,$6F,$73,$65,$45,$6E,$67,$69,$6E,$65,$00,$00	; .DisposeEngine..
GetSectDst	dc.w	$4E56,$0000
Sub_26200	movem.l	d7/a4,-(sp)
	lea.l	L24FB4(pc),a0
	movea.l	$1C(a0),a4
	moveq	#$0,d7
	move.l	$8(a4),d0
	sub.l	$C(a4),d0
	dc.w	$D0BC,$0000,$0800
	cmp.l	$4(a4),d0
	dc.w	$6C1C
	move.l	$8(a4),d0
	move.l	$4(a4),d1
	dc.w	$4EBA,$042A
	move.l	d0,d7
	add.l	(a4),d7
	addq.l	#$1,$10(a4)
	addi.l	#$800,$8(a4)
.l4F3E	move.l	d7,d0
	movem.l	-$8(a6),d7/a4
	unlk	a6
	dc.w	$4E75
	dc.b	$8A,$47,$65,$74,$53,$65,$63,$74,$44,$73,$74,$00,$00,$00	; .GetSectDst...
PeekSectDst	dc.w	$4E56,$0000
Sub_2625C	movem.l	d7/a4,-(sp)
	lea.l	L24FB4(pc),a0
	movea.l	$1C(a0),a4
	moveq	#$0,d7
	move.l	$8(a4),d0
	sub.l	$C(a4),d0
	dc.w	$D0BC,$0000,$0800
	cmp.l	$4(a4),d0
	dc.w	$6C10
	move.l	$8(a4),d0
	move.l	$4(a4),d1
	dc.w	$4EBA,$03CE
	move.l	d0,d7
	add.l	(a4),d7
.l4F8E	move.l	d7,d0
	movem.l	-$8(a6),d7/a4
	unlk	a6
	dc.w	$4E75
	dc.b	$8B,$50,$65,$65,$6B,$53,$65,$63,$74,$44,$73,$74,$00,$00	; .PeekSectDst..
