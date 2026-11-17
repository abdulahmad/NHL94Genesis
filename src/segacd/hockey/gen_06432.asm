	incbin	..\Extracted\SegaCD\HOCKEY\hockey_06432.bin
	move.l	#$22018,$6038.w
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$2D,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_07018.bin
.loop4	btst	#$1,$FF8003.l
	beq.b	.loop4
	rts
	dc.w	$0839,$0007,$00FF,$800E,$66F6,$33FC,$0007,$00FF
	dc.w	$8020,$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$4EB9,$0002,$2268,$4E75
	bset	#$0,$FF8003.l
.loop5	btst	#$1,$FF8003.l
	bne.b	.loop5
	rts
	movem.l	d0-d1/a0-a1,-(sp)
.loop6	move.w	#$80,d0
	jsr	$5F22.w
	bcs.b	.loop6
	movem.l	(sp)+,d0-d1/a0-a1
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_072EA.bin
	lea.l	$193BC.l,a0
	moveq	#$0,d0
