	incbin	..\Extracted\SegaCD\HOCKEY\hockey_2C65C.bin
	rts
	dc.w	$4E75
	rts
ReadJoyData
	movem.l	d1/a0,-(sp)
	dc.w	$4A79,$0001,$8BF8
	beq.w	L2CDEA
	dc.w	$6142
	dc.w	$13C0,$0001,$7E46
	bsr.w	L2CE56
	dc.w	$13C0,$0001,$7E47
	bsr.w	L2CEA8
	dc.w	$13C0,$0001,$7E48
	bsr.w	L2CEFA
	dc.w	$13C0,$0001,$7E49
	bra.w	L2CDFE
L2CDEA	bsr.w	L2CF58
	dc.w	$13C0,$0001,$7E46
	bsr.w	L2CF50
	dc.w	$13C0,$0001,$7E47
L2CDFE	movem.l	(sp)+,d1/a0
	rts
L2CE04	btst	#$4,$FF800E.l
	bne.b	L2CE04
	move.b	#$C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset	#$3,$FF800F.l
L2CE26	btst	#$4,$FF800E.l
	beq.b	L2CE26
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
L2CE40	btst	#$3,$FF800E.l
	bne.b	L2CE40
	bclr	#$4,$FF800F.l
	bra.w	L2CF48
L2CE56	btst	#$4,$FF800E.l
	bne.b	L2CE56
	move.b	#$1C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset	#$3,$FF800F.l
L2CE78	btst	#$4,$FF800E.l
	beq.b	L2CE78
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
L2CE92	btst	#$3,$FF800E.l
	bne.b	L2CE92
	bclr	#$4,$FF800F.l
	bra.w	L2CF48
L2CEA8	btst	#$4,$FF800E.l
	bne.b	L2CEA8
	move.b	#$2C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset	#$3,$FF800F.l
L2CECA	btst	#$4,$FF800E.l
	beq.b	L2CECA
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
L2CEE4	btst	#$3,$FF800E.l
	bne.b	L2CEE4
	bclr	#$4,$FF800F.l
	bra.w	L2CF48
L2CEFA	btst	#$4,$FF800E.l
	bne.b	L2CEFA
	move.b	#$3C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset	#$3,$FF800F.l
L2CF1C	btst	#$4,$FF800E.l
	beq.b	L2CF1C
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
L2CF36	btst	#$3,$FF800E.l
	bne.b	L2CF36
	bclr	#$4,$FF800F.l
L2CF48	movem.l	d1/a0,-(sp)
	bra.w	L2CF5C
L2CF50	movem.l	d1/a0,-(sp)
	bra.w	L2D096
L2CF58	movem.l	d1/a0,-(sp)
L2CF5C	moveq	#$0,d0
L2CF5E	btst	#$4,$FF800E.l
	bne.b	L2CF5E
	move.b	#$0,$FF8028.l
	move.w	#$36,$FF8026.l
	bset	#$3,$FF800F.l
L2CF80	btst	#$3,$FF800E.l
	beq.b	L2CF80
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
L2CF9A	btst	#$3,$FF800E.l
	bne.b	L2CF9A
	bclr	#$4,$FF800F.l
L2CFAC	btst	#$4,$FF800E.l
	bne.b	L2CFAC
	move.w	#$37,$FF8026.l
	bset	#$3,$FF800F.l
L2CFC6	btst	#$3,$FF800E.l
	beq.b	L2CFC6
	move.b	$FF8018.l,d0
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
L2CFE6	btst	#$3,$FF800E.l
	bne.b	L2CFE6
	bclr	#$4,$FF800F.l
L2CFF8	btst	#$4,$FF800E.l
	bne.b	L2CFF8
	move.b	#$40,$FF8028.l
	move.w	#$36,$FF8026.l
	bset	#$3,$FF800F.l
L2D01A	btst	#$3,$FF800E.l
	beq.b	L2D01A
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
L2D034	btst	#$3,$FF800E.l
	bne.b	L2D034
	bclr	#$4,$FF800F.l
L2D046	btst	#$4,$FF800E.l
	bne.b	L2D046
	move.w	#$37,$FF8026.l
	bset	#$3,$FF800F.l
L2D060	btst	#$3,$FF800E.l
	beq.b	L2D060
	move.b	$FF8018.l,d1
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
L2D080	btst	#$3,$FF800E.l
	bne.b	L2D080
	bclr	#$4,$FF800F.l
	bra.w	L2D1D0
L2D096	moveq	#$0,d0
L2D098	btst	#$4,$FF800E.l
	bne.b	L2D098
	move.b	#$0,$FF8028.l
	move.w	#$35,$FF8026.l
	bset	#$3,$FF800F.l
L2D0BA	btst	#$4,$FF800E.l
	beq.b	L2D0BA
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
L2D0D4	btst	#$3,$FF800E.l
	bne.b	L2D0D4
	bclr	#$4,$FF800F.l
L2D0E6	btst	#$4,$FF800E.l
	bne.b	L2D0E6
	move.w	#$38,$FF8026.l
	bset	#$3,$FF800F.l
L2D100	btst	#$3,$FF800E.l
	beq.b	L2D100
	move.b	$FF8018.l,d0
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
L2D120	btst	#$3,$FF800E.l
	bne.b	L2D120
	bclr	#$4,$FF800F.l
L2D132	btst	#$4,$FF800E.l
	bne.b	L2D132
	move.b	#$40,$FF8028.l
	move.w	#$35,$FF8026.l
	bset	#$3,$FF800F.l
L2D154	btst	#$4,$FF800E.l
	beq.b	L2D154
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
L2D16E	btst	#$3,$FF800E.l
	bne.b	L2D16E
	bclr	#$4,$FF800F.l
L2D180	btst	#$4,$FF800E.l
	bne.b	L2D180
	move.w	#$38,$FF8026.l
	bset	#$3,$FF800F.l
L2D19A	btst	#$3,$FF800E.l
	beq.b	L2D19A
	move.b	$FF8018.l,d1
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
L2D1BA	btst	#$3,$FF800E.l
	bne.b	L2D1BA
	bclr	#$4,$FF800F.l
	bra.w	L2D1D0
L2D1D0	asl.b	#$2,d0
	andi.b	#$C0,d0
	andi.b	#$3F,d1
	or.b	d1,d0
	not.b	d0
	not.b	d1
	andi.w	#$F,d1
	dc.w	$41FA,$0012
	andi.b	#$F0,d0
	or.b	(a0,d1.w),d0
	not.b	d0
	movem.l	(sp)+,d1/a0
	rts
	dc.w	$0001,$0201,$0405,$0606,$0809,$0A0A,$0809,$0A00
	dc.w	$4E75
