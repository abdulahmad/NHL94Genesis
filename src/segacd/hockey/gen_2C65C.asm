	incbin	..\Extracted\SegaCD\HOCKEY\hockey_2C65C.bin
	rts
	rts
	rts
ReadJoyData
	movem.l	d1/a0,-(sp)
	tst.w	$18BF8.l
	beq.w	.l2CDEA
	dc.w	$6142
	move.b	d0,$17E46.l
	bsr.w	.l2CE56
	move.b	d0,$17E47.l
	bsr.w	.l2CEA8
	move.b	d0,$17E48.l
	bsr.w	.l2CEFA
	move.b	d0,$17E49.l
	bra.w	.l2CDFE
.l2CDEA	bsr.w	.l2CF58
	move.b	d0,$17E46.l
	bsr.w	.l2CF50
	move.b	d0,$17E47.l
.l2CDFE	movem.l	(sp)+,d1/a0
	rts
.l2CE04	btst	#$4,$FF800E.l
	bne.b	.l2CE04
	move.b	#$C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset	#$3,$FF800F.l
.l2CE26	btst	#$4,$FF800E.l
	beq.b	.l2CE26
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.l2CE40	btst	#$3,$FF800E.l
	bne.b	.l2CE40
	bclr	#$4,$FF800F.l
	bra.w	.l2CF48
.l2CE56	btst	#$4,$FF800E.l
	bne.b	.l2CE56
	move.b	#$1C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset	#$3,$FF800F.l
.l2CE78	btst	#$4,$FF800E.l
	beq.b	.l2CE78
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.l2CE92	btst	#$3,$FF800E.l
	bne.b	.l2CE92
	bclr	#$4,$FF800F.l
	bra.w	.l2CF48
.l2CEA8	btst	#$4,$FF800E.l
	bne.b	.l2CEA8
	move.b	#$2C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset	#$3,$FF800F.l
.l2CECA	btst	#$4,$FF800E.l
	beq.b	.l2CECA
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.l2CEE4	btst	#$3,$FF800E.l
	bne.b	.l2CEE4
	bclr	#$4,$FF800F.l
	bra.w	.l2CF48
.l2CEFA	btst	#$4,$FF800E.l
	bne.b	.l2CEFA
	move.b	#$3C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset	#$3,$FF800F.l
.l2CF1C	btst	#$4,$FF800E.l
	beq.b	.l2CF1C
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.l2CF36	btst	#$3,$FF800E.l
	bne.b	.l2CF36
	bclr	#$4,$FF800F.l
.l2CF48	movem.l	d1/a0,-(sp)
	bra.w	.l2CF5C
.l2CF50	movem.l	d1/a0,-(sp)
	bra.w	.l2D096
.l2CF58	movem.l	d1/a0,-(sp)
.l2CF5C	moveq	#$0,d0
.l2CF5E	btst	#$4,$FF800E.l
	bne.b	.l2CF5E
	move.b	#$0,$FF8028.l
	move.w	#$36,$FF8026.l
	bset	#$3,$FF800F.l
.l2CF80	btst	#$3,$FF800E.l
	beq.b	.l2CF80
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.l2CF9A	btst	#$3,$FF800E.l
	bne.b	.l2CF9A
	bclr	#$4,$FF800F.l
.l2CFAC	btst	#$4,$FF800E.l
	bne.b	.l2CFAC
	move.w	#$37,$FF8026.l
	bset	#$3,$FF800F.l
.l2CFC6	btst	#$3,$FF800E.l
	beq.b	.l2CFC6
	move.b	$FF8018.l,d0
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.l2CFE6	btst	#$3,$FF800E.l
	bne.b	.l2CFE6
	bclr	#$4,$FF800F.l
.l2CFF8	btst	#$4,$FF800E.l
	bne.b	.l2CFF8
	move.b	#$40,$FF8028.l
	move.w	#$36,$FF8026.l
	bset	#$3,$FF800F.l
.l2D01A	btst	#$3,$FF800E.l
	beq.b	.l2D01A
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.l2D034	btst	#$3,$FF800E.l
	bne.b	.l2D034
	bclr	#$4,$FF800F.l
.l2D046	btst	#$4,$FF800E.l
	bne.b	.l2D046
	move.w	#$37,$FF8026.l
	bset	#$3,$FF800F.l
.l2D060	btst	#$3,$FF800E.l
	beq.b	.l2D060
	move.b	$FF8018.l,d1
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.l2D080	btst	#$3,$FF800E.l
	bne.b	.l2D080
	bclr	#$4,$FF800F.l
	bra.w	.l2D1D0
.l2D096	moveq	#$0,d0
.l2D098	btst	#$4,$FF800E.l
	bne.b	.l2D098
	move.b	#$0,$FF8028.l
	move.w	#$35,$FF8026.l
	bset	#$3,$FF800F.l
.l2D0BA	btst	#$4,$FF800E.l
	beq.b	.l2D0BA
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.l2D0D4	btst	#$3,$FF800E.l
	bne.b	.l2D0D4
	bclr	#$4,$FF800F.l
.l2D0E6	btst	#$4,$FF800E.l
	bne.b	.l2D0E6
	move.w	#$38,$FF8026.l
	bset	#$3,$FF800F.l
.l2D100	btst	#$3,$FF800E.l
	beq.b	.l2D100
	move.b	$FF8018.l,d0
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.l2D120	btst	#$3,$FF800E.l
	bne.b	.l2D120
	bclr	#$4,$FF800F.l
.l2D132	btst	#$4,$FF800E.l
	bne.b	.l2D132
	move.b	#$40,$FF8028.l
	move.w	#$35,$FF8026.l
	bset	#$3,$FF800F.l
.l2D154	btst	#$4,$FF800E.l
	beq.b	.l2D154
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.l2D16E	btst	#$3,$FF800E.l
	bne.b	.l2D16E
	bclr	#$4,$FF800F.l
.l2D180	btst	#$4,$FF800E.l
	bne.b	.l2D180
	move.w	#$38,$FF8026.l
	bset	#$3,$FF800F.l
.l2D19A	btst	#$3,$FF800E.l
	beq.b	.l2D19A
	move.b	$FF8018.l,d1
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.l2D1BA	btst	#$3,$FF800E.l
	bne.b	.l2D1BA
	bclr	#$4,$FF800F.l
	bra.w	.l2D1D0
.l2D1D0	asl.b	#$2,d0
	andi.b	#$C0,d0
	andi.b	#$3F,d1
	or.b	d1,d0
	not.b	d0
	not.b	d1
	andi.w	#$F,d1
	lea.l	.l481F8(pc),a0
	andi.b	#$F0,d0
	or.b	(a0,d1.w),d0
	not.b	d0
	movem.l	(sp)+,d1/a0
	rts
.l481F8	dc.w	$0001,$0201,$0405,$0606,$0809,$0A0A,$0809,$0A00
	rts
