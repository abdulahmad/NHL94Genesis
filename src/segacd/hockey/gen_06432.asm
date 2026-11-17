	incbin	..\Extracted\SegaCD\HOCKEY\hockey_06432.bin
	move.l	#$22018,$6038.w
.l6FD0	btst	#$7,$FF800E.l
	bne.b	.l6FD0
	move.w	#$2D,$FF8020.l
	bset	#$6,$FF800F.l
.l6FEA	btst	#$6,$FF800E.l
	beq.b	.l6FEA
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l7004	btst	#$6,$FF800E.l
	bne.b	.l7004
	bclr	#$7,$FF800F.l
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_07018.bin
.l7268	btst	#$1,$FF8003.l
	beq.b	.l7268
	rts
	dc.w	$0839,$0007,$00FF,$800E,$66F6,$33FC,$0007,$00FF
	dc.w	$8020,$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$4EB9,$0002,$2268,$4E75
	bset	#$0,$FF8003.l
.l72CA	btst	#$1,$FF8003.l
	bne.b	.l72CA
	rts
	movem.l	d0-d1/a0-a1,-(sp)
.l72DA	move.w	#$80,d0
	jsr	$5F22.w
	bcs.b	.l72DA
	movem.l	(sp)+,d0-d1/a0-a1
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_072EA.bin
	lea.l	$193BC.l,a0
	moveq	#$0,d0
