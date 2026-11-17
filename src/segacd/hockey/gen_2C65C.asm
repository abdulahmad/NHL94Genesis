	incbin	..\Extracted\SegaCD\HOCKEY\hockey_2C65C.bin
	rts
	rts
	rts
ReadJoyData
	movem.l	d1/a0,-(sp)
	tst.w	$18BF8.l
	beq.w	.next
	dc.w	$6142
	move.b	d0,$17E46.l
	bsr.w	.loop4
	move.b	d0,$17E47.l
	bsr.w	.loop7
	move.b	d0,$17E48.l
	bsr.w	.loop10
	move.b	d0,$17E49.l
	bra.w	.next2
.next	bsr.w	.next5
	move.b	d0,$17E46.l
	bsr.w	.next4
	move.b	d0,$17E47.l
.next2	movem.l	(sp)+,d1/a0
	rts
.loop	btst	#$4,$FF800E.l
	bne.b	.loop
	move.b	#$C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset	#$3,$FF800F.l
.loop2	btst	#$4,$FF800E.l
	beq.b	.loop2
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop3	btst	#$3,$FF800E.l
	bne.b	.loop3
	bclr	#$4,$FF800F.l
	bra.w	.next3
.loop4	btst	#$4,$FF800E.l
	bne.b	.loop4
	move.b	#$1C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset	#$3,$FF800F.l
.loop5	btst	#$4,$FF800E.l
	beq.b	.loop5
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop6	btst	#$3,$FF800E.l
	bne.b	.loop6
	bclr	#$4,$FF800F.l
	bra.w	.next3
.loop7	btst	#$4,$FF800E.l
	bne.b	.loop7
	move.b	#$2C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset	#$3,$FF800F.l
.loop8	btst	#$4,$FF800E.l
	beq.b	.loop8
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop9	btst	#$3,$FF800E.l
	bne.b	.loop9
	bclr	#$4,$FF800F.l
	bra.w	.next3
.loop10	btst	#$4,$FF800E.l
	bne.b	.loop10
	move.b	#$3C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset	#$3,$FF800F.l
.loop11	btst	#$4,$FF800E.l
	beq.b	.loop11
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop12	btst	#$3,$FF800E.l
	bne.b	.loop12
	bclr	#$4,$FF800F.l
.next3	movem.l	d1/a0,-(sp)
	bra.w	.next6
.next4	movem.l	d1/a0,-(sp)
	bra.w	.next7
.next5	movem.l	d1/a0,-(sp)
.next6	moveq	#$0,d0
.loop13	btst	#$4,$FF800E.l
	bne.b	.loop13
	move.b	#$0,$FF8028.l
	move.w	#$36,$FF8026.l
	bset	#$3,$FF800F.l
.loop14	btst	#$3,$FF800E.l
	beq.b	.loop14
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop15	btst	#$3,$FF800E.l
	bne.b	.loop15
	bclr	#$4,$FF800F.l
.loop16	btst	#$4,$FF800E.l
	bne.b	.loop16
	move.w	#$37,$FF8026.l
	bset	#$3,$FF800F.l
.loop17	btst	#$3,$FF800E.l
	beq.b	.loop17
	move.b	$FF8018.l,d0
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop18	btst	#$3,$FF800E.l
	bne.b	.loop18
	bclr	#$4,$FF800F.l
.loop19	btst	#$4,$FF800E.l
	bne.b	.loop19
	move.b	#$40,$FF8028.l
	move.w	#$36,$FF8026.l
	bset	#$3,$FF800F.l
.loop20	btst	#$3,$FF800E.l
	beq.b	.loop20
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop21	btst	#$3,$FF800E.l
	bne.b	.loop21
	bclr	#$4,$FF800F.l
.loop22	btst	#$4,$FF800E.l
	bne.b	.loop22
	move.w	#$37,$FF8026.l
	bset	#$3,$FF800F.l
.loop23	btst	#$3,$FF800E.l
	beq.b	.loop23
	move.b	$FF8018.l,d1
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop24	btst	#$3,$FF800E.l
	bne.b	.loop24
	bclr	#$4,$FF800F.l
	bra.w	.next8
.next7	moveq	#$0,d0
.loop25	btst	#$4,$FF800E.l
	bne.b	.loop25
	move.b	#$0,$FF8028.l
	move.w	#$35,$FF8026.l
	bset	#$3,$FF800F.l
.loop26	btst	#$4,$FF800E.l
	beq.b	.loop26
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop27	btst	#$3,$FF800E.l
	bne.b	.loop27
	bclr	#$4,$FF800F.l
.loop28	btst	#$4,$FF800E.l
	bne.b	.loop28
	move.w	#$38,$FF8026.l
	bset	#$3,$FF800F.l
.loop29	btst	#$3,$FF800E.l
	beq.b	.loop29
	move.b	$FF8018.l,d0
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop30	btst	#$3,$FF800E.l
	bne.b	.loop30
	bclr	#$4,$FF800F.l
.loop31	btst	#$4,$FF800E.l
	bne.b	.loop31
	move.b	#$40,$FF8028.l
	move.w	#$35,$FF8026.l
	bset	#$3,$FF800F.l
.loop32	btst	#$4,$FF800E.l
	beq.b	.loop32
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop33	btst	#$3,$FF800E.l
	bne.b	.loop33
	bclr	#$4,$FF800F.l
.loop34	btst	#$4,$FF800E.l
	bne.b	.loop34
	move.w	#$38,$FF8026.l
	bset	#$3,$FF800F.l
.loop35	btst	#$3,$FF800E.l
	beq.b	.loop35
	move.b	$FF8018.l,d1
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop36	btst	#$3,$FF800E.l
	bne.b	.loop36
	bclr	#$4,$FF800F.l
	bra.w	.next8
.next8	asl.b	#$2,d0
	andi.b	#$C0,d0
	andi.b	#$3F,d1
	or.b	d1,d0
	not.b	d0
	not.b	d1
	andi.w	#$F,d1
	lea.l	.next9(pc),a0
	andi.b	#$F0,d0
	or.b	(a0,d1.w),d0
	not.b	d0
	movem.l	(sp)+,d1/a0
	rts
.next9	dc.w	$0001,$0201,$0405,$0606,$0809,$0A0A,$0809,$0A00
	rts
