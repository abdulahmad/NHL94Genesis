setVram						;initialize all necesary video parameters based on my variables. d0 =
									;color to fade to. Falls into setVram_0
	movea.l	#$BBCB0,a0
	moveq	#$3F,d1
.loop	move.w	d0,(a0)+		;fill the 64 target colors with d0
	dbra	d1,.loop
	move.w	#$18,(palcount).l
	bsr.w	ForceBlackBegin
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	beq.s	.next
	move.w	#$1,-(a6)
	bra.s	.next2
.next	move.w	#$0,-(a6)
.next2	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
.loop2	btst	#$7,$FF800E.l
	bne.b	.loop2
	move.w	#$8F02,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	beq.b	.loop3
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop4	btst	#$6,$FF800E.l
	bne.b	.loop4
	bclr	#$7,$FF800F.l
	clr.w	d0
	bsr.w	SetVramWriteAddr1
	clr.l	d1
.loop5	btst	#$7,$FF800E.l
	bne.b	.loop5
	move.w	#$20,$FF8020.l
	bset	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	beq.b	.loop6
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop7	btst	#$6,$FF800E.l
	bne.b	.loop7
	bclr	#$7,$FF800F.l
	move.w	#$8C00,d0
	btst	#$1,(disflags).l
	bne.w	.loop8
	ori.w	#$81,d0
.loop8	btst	#$7,$FF800E.l
	bne.b	.loop8
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop9	btst	#$6,$FF800E.l
	beq.b	.loop9
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop10	btst	#$6,$FF800E.l
	bne.b	.loop10
	bclr	#$7,$FF800F.l
.loop11	btst	#$7,$FF800E.l
	bne.b	.loop11
	move.w	#$8014,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop12	btst	#$6,$FF800E.l
	beq.b	.loop12
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop13	btst	#$6,$FF800E.l
	bne.b	.loop13
	bclr	#$7,$FF800F.l
.loop14	btst	#$7,$FF800E.l
	bne.b	.loop14
	move.w	#$8164,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop15	btst	#$6,$FF800E.l
	beq.b	.loop15
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop16	btst	#$6,$FF800E.l
	bne.b	.loop16
	bclr	#$7,$FF800F.l
	move.w	#$9001,d0
	cmpi.w	#$6,(Map1col).l
	beq.w	.loop17
	move.w	#$9003,d0
.loop17	btst	#$7,$FF800E.l
	bne.b	.loop17
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop18	btst	#$6,$FF800E.l
	beq.b	.loop18
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop19	btst	#$6,$FF800E.l
	bne.b	.loop19
	bclr	#$7,$FF800F.l
	move.w	#$8200,d0
	move.b	(VmMAP1).l,d0
	lsr.b	#$2,d0
	andi.b	#$38,d0
.loop20	btst	#$7,$FF800E.l
	bne.b	.loop20
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop21	btst	#$6,$FF800E.l
	beq.b	.loop21
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop22	btst	#$6,$FF800E.l
	bne.b	.loop22
	bclr	#$7,$FF800F.l
	move.w	#$8400,d0
	move.b	$18D38.l,d0
	lsr.b	#$5,d0
.loop23	btst	#$7,$FF800E.l
	bne.b	.loop23
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop24	btst	#$6,$FF800E.l
	beq.b	.loop24
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop25	btst	#$6,$FF800E.l
	bne.b	.loop25
	bclr	#$7,$FF800F.l
	move.w	#$8300,d0
	move.b	$18D3C.l,d0
	lsr.b	#$2,d0
	andi.b	#$3E,d0
.loop26	btst	#$7,$FF800E.l
	bne.b	.loop26
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop27	btst	#$6,$FF800E.l
	beq.b	.loop27
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop28	btst	#$6,$FF800E.l
	bne.b	.loop28
	bclr	#$7,$FF800F.l
	move.w	#$8500,d0
	move.b	$18D32.l,d0
	lsr.b	#$1,d0
.loop29	btst	#$7,$FF800E.l
	bne.b	.loop29
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop30	btst	#$6,$FF800E.l
	beq.b	.loop30
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop31	btst	#$6,$FF800E.l
	bne.b	.loop31
	bclr	#$7,$FF800F.l
	move.w	#$8D00,d0
	move.b	$18D30.l,d0
	lsr.b	#$2,d0
.loop32	btst	#$7,$FF800E.l
	bne.b	.loop32
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop33	btst	#$6,$FF800E.l
	beq.b	.loop33
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop34	btst	#$6,$FF800E.l
	bne.b	.loop34
	bclr	#$7,$FF800F.l
.loop35	btst	#$7,$FF800E.l
	bne.b	.loop35
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop36	btst	#$6,$FF800E.l
	beq.b	.loop36
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop37	btst	#$6,$FF800E.l
	bne.b	.loop37
	bclr	#$7,$FF800F.l
.loop38	btst	#$7,$FF800E.l
	bne.b	.loop38
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop39	btst	#$6,$FF800E.l
	beq.b	.loop39
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop40	btst	#$6,$FF800E.l
	bne.b	.loop40
	bclr	#$7,$FF800F.l
.loop41	btst	#$7,$FF800E.l
	bne.b	.loop41
	move.w	#$8700,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop42	btst	#$6,$FF800E.l
	beq.b	.loop42
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop43	btst	#$6,$FF800E.l
	bne.b	.loop43
	bclr	#$7,$FF800F.l
.loop44	btst	#$7,$FF800E.l
	bne.b	.loop44
	move.w	#$8B00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop45	btst	#$6,$FF800E.l
	beq.b	.loop45
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop46	btst	#$6,$FF800E.l
	bne.b	.loop46
	bclr	#$7,$FF800F.l
.loop47	btst	#$7,$FF800E.l
	bne.b	.loop47
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
.loop48	btst	#$6,$FF800E.l
	beq.b	.loop48
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop49	btst	#$6,$FF800E.l
	bne.b	.loop49
	bclr	#$7,$FF800F.l
.loop50	btst	#$7,$FF800E.l
	bne.b	.loop50
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset	#$6,$FF800F.l
.loop51	btst	#$6,$FF800E.l
	beq.b	.loop51
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop52	btst	#$6,$FF800E.l
	bne.b	.loop52
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.next3
	bset	#$5,$FF800F.l
	bra.s	.next4
.next3	bclr	#$5,$FF800F.l
.next4	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
; Pushes the flag on the queue for setVram
SetVramQueueFlag	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.b	.next
	move.w	#$1,-(a6)
	bra.b	.next2
.next	move.w	#$0,-(a6)
.next2	bclr.b	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	$18D64.l,-(sp)
	bset.b	#$2,$18D64.l
.loop	btst.b	#$7,$FF800E.l
	bne.s	.loop
	move.w	#$8F02,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop2	btst.b	#$6,$FF800E.l
	beq.s	.loop2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	bne.s	.loop3
	bclr.b	#$7,$FF800F.l
	clr.w	d0
	bsr.w	SetVramWriteAddr1
	clr.l	d1
	move.w	#$8C00,d0
	btst.b	#$1,$18D64.l
	bne.w	.loop4
	ori.w	#$81,d0
.loop4	btst.b	#$7,$FF800E.l
	bne.b	.loop4
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop5	btst.b	#$6,$FF800E.l
	beq.s	.loop5
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	bne.s	.loop6
	bclr.b	#$7,$FF800F.l
.loop7	btst.b	#$7,$FF800E.l
	bne.s	.loop7
	move.w	#$8014,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop8	btst.b	#$6,$FF800E.l
	beq.s	.loop8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop9	btst.b	#$6,$FF800E.l
	bne.s	.loop9
	bclr.b	#$7,$FF800F.l
.loop10	btst.b	#$7,$FF800E.l
	bne.s	.loop10
	move.w	#$8164,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop11	btst.b	#$6,$FF800E.l
	beq.s	.loop11
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop12	btst.b	#$6,$FF800E.l
	bne.s	.loop12
	bclr.b	#$7,$FF800F.l
	move.w	#$9001,d0
	cmpi.w	#$6,$18D36.l
	beq.w	.loop13
	move.w	#$9003,d0
.loop13	btst.b	#$7,$FF800E.l
	bne.b	.loop13
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop14	btst.b	#$6,$FF800E.l
	beq.s	.loop14
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop15	btst.b	#$6,$FF800E.l
	bne.s	.loop15
	bclr.b	#$7,$FF800F.l
	move.w	#$8200,d0
	move.b	$18D34.l,d0
	lsr.b	#$2,d0
	andi.b	#$38,d0
.loop16	btst.b	#$7,$FF800E.l
	bne.s	.loop16
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop17	btst.b	#$6,$FF800E.l
	beq.s	.loop17
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop18	btst.b	#$6,$FF800E.l
	bne.s	.loop18
	bclr.b	#$7,$FF800F.l
	move.w	#$8400,d0
	move.b	$18D38.l,d0
	lsr.b	#$5,d0
.loop19	btst.b	#$7,$FF800E.l
	bne.s	.loop19
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop20	btst.b	#$6,$FF800E.l
	beq.s	.loop20
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop21	btst.b	#$6,$FF800E.l
	bne.s	.loop21
	bclr.b	#$7,$FF800F.l
	move.w	#$8300,d0
	move.b	$18D3C.l,d0
	lsr.b	#$2,d0
	andi.b	#$3E,d0
.loop22	btst.b	#$7,$FF800E.l
	bne.s	.loop22
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop23	btst.b	#$6,$FF800E.l
	beq.s	.loop23
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop24	btst.b	#$6,$FF800E.l
	bne.s	.loop24
	bclr.b	#$7,$FF800F.l
	move.w	#$8500,d0
	move.b	$18D32.l,d0
	lsr.b	#$1,d0
.loop25	btst.b	#$7,$FF800E.l
	bne.s	.loop25
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop26	btst.b	#$6,$FF800E.l
	beq.s	.loop26
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop27	btst.b	#$6,$FF800E.l
	bne.s	.loop27
	bclr.b	#$7,$FF800F.l
	move.w	#$8D00,d0
	move.b	$18D30.l,d0
	lsr.b	#$2,d0
.loop28	btst.b	#$7,$FF800E.l
	bne.s	.loop28
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop29	btst.b	#$6,$FF800E.l
	beq.s	.loop29
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop30	btst.b	#$6,$FF800E.l
	bne.s	.loop30
	bclr.b	#$7,$FF800F.l
.loop31	btst.b	#$7,$FF800E.l
	bne.s	.loop31
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop32	btst.b	#$6,$FF800E.l
	beq.s	.loop32
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop33	btst.b	#$6,$FF800E.l
	bne.s	.loop33
	bclr.b	#$7,$FF800F.l
.loop34	btst.b	#$7,$FF800E.l
	bne.s	.loop34
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop35	btst.b	#$6,$FF800E.l
	beq.s	.loop35
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop36	btst.b	#$6,$FF800E.l
	bne.s	.loop36
	bclr.b	#$7,$FF800F.l
.loop37	btst.b	#$7,$FF800E.l
	bne.s	.loop37
	move.w	#$8700,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop38	btst.b	#$6,$FF800E.l
	beq.s	.loop38
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop39	btst.b	#$6,$FF800E.l
	bne.s	.loop39
	bclr.b	#$7,$FF800F.l
.loop40	btst.b	#$7,$FF800E.l
	bne.s	.loop40
	move.w	#$8B00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop41	btst.b	#$6,$FF800E.l
	beq.s	.loop41
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop42	btst.b	#$6,$FF800E.l
	bne.s	.loop42
	bclr.b	#$7,$FF800F.l
.loop43	btst.b	#$7,$FF800E.l
	bne.s	.loop43
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop44	btst.b	#$6,$FF800E.l
	beq.s	.loop44
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop45	btst.b	#$6,$FF800E.l
	bne.s	.loop45
	bclr.b	#$7,$FF800F.l
.loop46	btst.b	#$7,$FF800E.l
	bne.s	.loop46
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop47	btst.b	#$6,$FF800E.l
	beq.s	.loop47
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop48	btst.b	#$6,$FF800E.l
	bne.s	.loop48
	bclr.b	#$7,$FF800F.l
	move.w	(sp)+,$18D64.l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.b	.next3
	bset.b	#$5,$FF800F.l
	bra.b	.next4
.next3	bclr.b	#$5,$FF800F.l
.next4	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
; Sets the VDP VRAM write command from d0.
SetVramWriteAddr1
	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.l	d0,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	rts
; Second copy of SetVramWriteAddr1.
SetVramWriteAddr2
	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
.loop	btst	#$4,$FF800E.l
	bne.b	.loop
	move.w	#$30,$FF8026.l
	move.l	d0,$FF8028.l
	bset	#$3,$FF800F.l
.loop2	btst	#$3,$FF800E.l
	beq.b	.loop2
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop3	btst	#$3,$FF800E.l
	bne.b	.loop3
	bclr	#$4,$FF800F.l
	rts
dobitmap						;transfer palette data/map data/tiles data to vram. a0 = palette, a1 =
									;map, a2 = tiles (DecompressGraphics data), d0 = start x, d1 = start y, d2
									;= width x, d3 = width y, d4 = start char, d5 = pal used bits (0-3) for
									;color fam 1-4. printy is restored and the tiles go last through
									;DecompressGraphics (returns d4 = end char)
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	beq.s	.next
	move.w	#$1,-(a6)
	bra.s	.next2
.next	move.w	#$0,-(a6)
.next2	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	(printy).l,-(sp)
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movem.l	d0-d3/d5-d6/a0-a3,-(sp)		;2(sp) start x, $A(sp) width x, $E(sp) width y (low words of d0, d2, d3)
	move.w	d1,d6
	movea.l	#$BBCB0,a3		;a3 = target palette, a0 = palette data
	bra.w	.next3
.loop	move.b	(a0,d0.w),(a3,d0.w)		;copy the color
	dbra	d0,.loop
.loop2	adda.l	#$20,a0		;next line
	adda.l	#$20,a3		;next line
.next3	moveq	#$1F,d0
	lsr.w	#$1,d5		;d5 bit n = copy palette line n; stop when no bits left
	bcs.w	.loop
	bne.w	.loop2
	move.w	(printa).l,d5		;d5 = tile attribute bits (priority/palette/flip) from printa
	andi.w	#$F800,d5		;attribute bits
	move.w	$E(sp),d2
	subi.w	#$1,d2
.loop3	bsr.w	xyVmMap		;set vram address from printx/printy/printm, a0 = Vdata
	move.w	d6,d0
	mulu.w	(a1),d0
	add.w	$2(sp),d0
	asl.w	#$1,d0		;d0 = byte offset of the first map word wanted
	move.w	$A(sp),d1
	subi.w	#$1,d1
	move.w	d1,(ThreeStars).l		;map word (map data starts 4 bytes in)
	lea.l	$BC002.l,a0
.loop4	move.w	$4(a1,d0.w),d3
	add.w	d4,d3		;add the start char
	eor.w	d5,d3		;xor the attribute bits
	move.w	d3,(a0)+		;write the name table entry
	addi.w	#$2,d0
	dbra	d1,.loop4
.loop5	btst	#$7,$FF800E.l
	bne.b	.loop5
	move.w	#$21,$FF8020.l
	jsr	$222C2.l
	bset	#$6,$FF800F.l
	jsr	$22268.l
.loop6	btst	#$6,$FF800E.l
	beq.b	.loop6
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop7	btst	#$6,$FF800E.l
	bne.b	.loop7
	bclr	#$7,$FF800F.l
	addi.w	#$1,(printy).l
	addi.w	#$1,d6
	dbra	d2,.loop3
	btst	#$0,(sflags6).l
	bne.w	.next4
	jsr	(DecompressGraphicsPlain).l
.next4	movem.l	(sp)+,d0-d3/d5-d6/a0-a3
	move.w	(sp)+,(disflags).l
	move.w	(sp)+,(printy).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.next5
	bset	#$5,$FF800F.l
	bra.s	.next6
.next5	bclr	#$5,$FF800F.l
.next6	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
DecompressGraphicsWithRemap						;DecompressGraphics, then return 8 bytes past the call (remap table)
	move.l	(sp),$18AE4.l
	bsr.w	DecompressGraphicsQueue
	addi.l	#$8,(sp)
	rts
DecompressGraphicsPlain						;Clear remapTablePtr, fall into DecompressGraphics
	clr.l	$18AE4.l
; Queues the decompress command in the list at $19360.
DecompressGraphicsQueue	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	beq.s	.next
	move.w	#$1,-(a6)
	bra.s	.next2
.next	move.w	#$0,-(a6)
.next2	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movem.l	d0-d1/a0-a6,-(sp)
	moveq	#$0,d0
	moveq	#$0,d1
	movea.l	a2,a0
	move.w	d4,d1
	asl.w	#$5,d1
	move.w	(a0)+,d0
	beq.w	.next4
	bmi.w	.next3
	add.w	d0,d4
	asl.w	#$4,d0
	pea.l	$389CA.l
	tst.l	$18AE4.l
	beq.w	DoDMApro
	movea.l	$18AE4.l,a1
	bra.w	QueueVramWriteFlag
.next3	andi.w	#$7FFF,d0
	add.w	d0,d4
	bsr.w	DecompressBytecode
.next4	movem.l	(sp)+,d0-d1/a0-a6
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.next5
	bset	#$5,$FF800F.l
	bra.s	.next6
.next5	bclr	#$5,$FF800F.l
.next6	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
DecompressBytecode						;Unpack a0 into the 256 byte ring buffer at decompbuffer. d1 = vram
	
	movea.l	#ThreeStars,a1
	movea.l	#ThreeStars,a3
	movea.l	#$18AE4,a4
	movea.l	#QueueVramWriteFlag,a5
	movea.l	#DoDMApro,a6
	movem.l	d0-d3/a0-a2,-(sp)
	move.w	d1,d3
	clr.w	d1
	clr.w	d2
.loop	move.b	(a0)+,d0
	andi.w	#$F0,d0
	lsr.w	#$3,d0
	lea.l	DecompressOpcodeTable(pc),a2
	move.w	(a2,d0.w),d0
	jsr	(a2,d0.w)
	bra.b	.loop
DecompressOpcodeTable						;DecompressBytecode handler offsets, one per opcode high nibble
	dc.w	$0020,$0020,$003C,$0058,$0078,$0078,$0078,$0078
	dc.w	$00AA,$00B8,$00D2,$00EC,$0106,$0106,$0138,$0158
Opcode_CopyLiteral						;opcodes 0-1, copy (low 5 bits)+1 bytes from the data
	move.b	-$1(a0),d0
	andi.w	#$1F,d0
.loop	move.b	(a0)+,(a1,d1.w)
	addq.b	#$1,d1
	bne.w	.next
	bsr.w	FlushOutputBuffer
.next	dbra	d0,.loop
	rts
Opcode_ClearBytes						;opcode 2, write (low 4 bits)+1 zero bytes
	move.b	-$1(a0),d0
	andi.w	#$F,d0
.loop	clr.b	(a1,d1.w)
	addq.b	#$1,d1
	bne.w	.next
	bsr.w	FlushOutputBuffer
.next	dbra	d0,.loop
	rts
Opcode_FillBytes						;opcode 3, write the next data byte (low 4 bits)+3 times
	move.b	-$1(a0),d0
	andi.w	#$F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
.loop	move.b	d2,(a1,d1.w)
	addq.b	#$1,d1
	bne.w	.next
	bsr.w	FlushOutputBuffer
.next	dbra	d0,.loop
	rts
Opcode_CopyBackwardShort						;opcodes 4-7, copy from back in the output buffer
	move.b	-$1(a0),d0
	andi.w	#$7,d0
	addq.w	#$1,d0
	move.b	-$1(a0),d2
	lsr.w	#$3,d2
	andi.w	#$7,d2
	addq.w	#$1,d2
CopyBackwardRun						;shared copy loop, d0 = count-1, d2 = distance back
	neg.b	d2
	add.b	d1,d2
.loop	move.b	(a1,d2.w),(a1,d1.w)
	addq.b	#$1,d2
	addq.b	#$1,d1
	bne.w	.next
	bsr.w	FlushOutputBuffer
.next	dbra	d0,.loop
	rts
Opcode_CopyBackwardMedium						;opcode 8
	move.b	-$1(a0),d0
	andi.w	#$F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	bra.b	CopyBackwardRun
	dc.w	$1010,$E300,$1028,$FFFF,$E310,$0240,$001F,$5440
	dc.w	$1418,$0242,$007F,$5242,$60BC,$1028,$FFFF,$E140
	dc.w	$1010,$EC48,$0240,$003F,$5440,$1418,$0242,$003F
	dc.w	$5242,$60A2,$1028,$FFFF,$E140,$1010,$EA48,$0240
	dc.w	$007F,$5440,$1418,$0242,$001F,$5242,$6088,$1028
	dc.w	$FFFF,$0240,$0003,$5240,$1428,$FFFF,$E44A,$0242
	dc.w	$0007,$5242
