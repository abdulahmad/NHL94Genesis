; MAIN.BIN $500-$CB7 ($FF0500-$FF0CB7). Emitted by tools/emit_m68k.py.
; Rest of the DMA routine, the $23A450 copy, and a 9-long table at $FF0C94.



	bge.w	.next5
	ori.w	#$4000,d3
	swap	d3
	andi.w	#$3,d3
	move.l	d3,(a1)
	move.l	(a0),-$4(a1)
.next5	move.w	(sp)+,sr
	movem.l	(sp)+,d2-d3/a1
	rts
; Spins until the VDP status DMA-busy bit clears.
WaitVdpDmaDone	move.w	$C00004.l,d2
	btst	#$1,d2
	bne.b	WaitVdpDmaDone
	rts
	lea.l	$23A450.l,a0
	move.w	(a0)+,$FF284E.l
	move.w	(a0)+,$FF2850.l
	move.w	(a0)+,$FF2852.l
	move.w	(a0)+,$FF2856.l
	move.w	(a0)+,$FF285A.l
	move.w	(a0)+,$FF2854.l
	move.w	(a0)+,$FF285E.l
	bclr.b	#$3,$23C6E8.l
	move.w	(a0)+,d0
	or.b	d0,$23C6E8.l
	move.w	(a0)+,d0
	movea.l	#$23A850,a0
	moveq	#$3F,d1
.loop	move.w	d0,(a0)+
	dbra	d1,.loop
	move.w	#$18,$23A8D0.l
	bsr.w	WaitVblank
	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	move.w	#$8F02,$C00004.l
	movea.l	#$C00000,a0
	move.w	#$8C00,d0
	move.w	#$5,$FF285C.l
	btst.b	#$3,$23C6E8.l
	bne.w	.next
	move.w	#$6,$FF285C.l
	ori.w	#$81,d0
.next	move.w	d0,$4(a0)
	move.w	#$8004,$4(a0)
	move.w	#$8164,$4(a0)
	move.w	$FF2854.l,d0
	move.w	d0,$FF2858.l
	subq.w	#$5,d0
	cmpi.w	#$1,d0
	bls.w	.next2
	moveq	#$3,d0
.next2	cmpi.w	#$40,$FF285E.l
	bne.w	.next3
	ori.w	#$10,d0
.next3	cmpi.w	#$80,$FF285E.l
	bne.w	.next4
	ori.w	#$30,d0
.next4	ori.w	#$9000,d0
	move.w	d0,$4(a0)
	move.w	#$8200,d0
	move.b	$FF2852.l,d0
	lsr.b	#$2,d0
	andi.b	#$38,d0
	move.w	d0,$4(a0)
	move.w	#$8400,d0
	move.b	$FF2856.l,d0
	lsr.b	#$5,d0
	move.w	d0,$4(a0)
	move.w	#$8300,d0
	move.b	$FF285A.l,d0
	lsr.b	#$2,d0
	andi.b	#$3E,d0
	move.w	d0,$4(a0)
	move.w	#$8500,d0
	move.b	$FF2850.l,d0
	lsr.b	#$1,d0
	move.w	d0,$4(a0)
	move.w	#$8D00,d0
	move.b	$FF284E.l,d0
	lsr.b	#$2,d0
	move.w	d0,$4(a0)
	move.w	#$9100,$4(a0)
	move.w	#$9200,$4(a0)
	move.w	#$8700,$4(a0)
	move.w	#$8B00,$4(a0)
	move.l	#$40000010,$4(a0)
	move.l	#$0,(a0)
	move.w	(sp)+,$23C6E8.l
	rts
; Sets the VDP VRAM write address from d0 (returns the data port in a0).
VdpSetWriteAddr	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
	move.l	d0,$4(a0)
	rts
; Turns the current plane cursor into a nametable address.
TilemapCellAddr	movem.l	d0-d2,-(sp)
	move.w	$FF2DB2.l,d0
	move.w	$FF2DB4.l,d1
	lea.l	$FF2852.l,a0
	adda.w	$FF2DB8.l,a0
	move.w	$2(a0),d2
	asl.w	d2,d1
	add.w	d1,d0
	add.w	d0,d0
	add.w	(a0),d0
	bsr.w	VdpSetWriteAddr
	movem.l	(sp)+,d0-d2
	rts
; Fills a tilemap rectangle with the tile in d2.
FillTilemapRect	movem.l	d0-d3/a0,-(sp)
	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	moveq	#-1,d3
	add.w	$FF285E.l,d3
	movem.w	d0-d1,-(sp)
.loop	bsr.w	TilemapCellAddr
	move.w	(sp),d0
	subq.w	#$1,d0
.loop2	move.w	d2,(a0)
	dbra	d0,.loop2
	addq.w	#$1,$FF2DB4.l
	and.w	d3,$FF2DB4.l
	subq.w	#$1,$2(sp)
	bne.b	.loop
	addq.l	#$4,sp
	move.w	(sp)+,$23C6E8.l
	movem.l	(sp)+,d0-d3/a0
	rts
; Enables interrupts and waits for the vertical blank counter.
WaitVblank	move.w	sr,-(sp)
	move.w	$23C6E8.l,-(sp)
	bclr.b	#$4,$23C6E8.l
	move.w	#$2500,sr
.loop	tst.w	$23A8D0.l
	bpl.b	.loop
	move.w	(sp)+,$23C6E8.l
	move.w	(sp)+,sr
	rts
	movem.l	d0/a0,-(sp)
	lea.l	$FF2A1A.l,a0
	move.w	#$1CB,d0
.loop2	clr.w	(a0)+
	dbra	d0,.loop2
	move.b	#$1,$FF2A18.l
	movem.l	(sp)+,d0/a0
	rts
; Clears both plane nametables in VRAM.
ClearVdpPlanes	bset.b	#$4,$23C6E8.l
	andi.b	#$9C,$23C6E8.l
	move.w	$FF284E.l,d0
	bsr.w	VdpSetWriteAddr
	moveq	#$0,d1
	move.w	#$DF,d0
.loop	move.l	d1,(a0)
	dbra	d0,.loop
	move.w	$FF2850.l,d0
	bsr.w	VdpSetWriteAddr
	moveq	#$0,d0
	move.l	d0,(a0)
	move.l	d0,(a0)
	bclr.b	#$4,$23C6E8.l
	rts
	lea.l	$23A450.l,a0
	move.w	(a0)+,d0
	move.w	(a0)+,d1
	move.w	(a0)+,d2
	move.w	(a0)+,$FF2DB2.l
	move.w	(a0)+,$FF2DB4.l
	move.w	(a0)+,$FF2DB8.l
	bsr.w	FillTilemapRect
	lea.l	$23A450.l,a0
	move.w	$FF2DB2.l,(a0)+
	move.w	$FF2DB4.l,(a0)+
	move.w	$FF2DB8.l,(a0)+
	rts
	lea.l	$23A450.l,a0
	move.w	(a0)+,d0
	move.w	(a0)+,d1
	move.w	(a0)+,d2
	bsr.w	VdpSetWriteAddrD1
	rts
; Prints a glyph string into the tilemap at the cursor.
PrintGlyphs	move.w	$FF2DB4.l,-(sp)
	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	movem.l	d0-d3/d5-d6/a0-a3,-(sp)
	move.w	d1,d6
	lea.l	$FF2A1A.l,a3
	move.w	$FF2DB6.l,d5
	andi.w	#$F800,d5
	move.w	$E(sp),d2
	subq.w	#$1,d2
.loop	bsr.w	TilemapCellAddr
	move.w	d6,d0
	mulu.w	(a1),d0
	add.w	$2(sp),d0
	asl.w	#$1,d0
	move.w	$A(sp),d1
	subq.w	#$1,d1
.loop2	move.w	$4(a1,d0.w),d3
	move.w	d3,-(sp)
	andi.w	#$7FF,d3
	tst.b	(a3,d3.w)
	bne.w	.next
	move.b	$FF2A18.l,(a3,d3.w)
	addq.b	#$1,$FF2A18.l
.next	move.b	(a3,d3.w),d3
	andi.w	#$FF,d3
	subq.w	#$1,d3
	add.w	d4,d3
	andi.w	#$F800,(sp)
	or.w	(sp)+,d3
	eor.w	d5,d3
	move.w	d3,(a0)
	addq.w	#$2,d0
	dbra	d1,.loop2
	addq.w	#$1,$FF2DB4.l
	addq.w	#$1,d6
	dbra	d2,.loop
	movem.l	(sp)+,d0-d3/d5-d6/a0-a3
	move.w	(sp)+,$23C6E8.l
	move.w	(sp)+,$FF2DB4.l
	rts
; Prints one glyph and advances the cursor.
PrintCharAdvance	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	moveq	#$1,d1
	lea.l	$FF2A1A.l,a3
	bsr.w	PackGlyphBits
	clr.w	d1
	move.b	$FF2A18.l,d1
	add.w	d1,d4
	move.w	(sp)+,$23C6E8.l
	rts
; PrintGlyphs variant using the $23A850 buffer.
PrintGlyphsAlt	move.w	$FF2DB4.l,-(sp)
	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	movem.l	d0-d3/d5-d6/a0-a3,-(sp)
	move.w	d1,d6
	lea.l	$23A850.l,a3
	bra.w	.next
.loop	move.b	(a0,d0.w),(a3,d0.w)
	dbra	d0,.loop
.loop2	adda.w	#$20,a0
	adda.w	#$20,a3
.next	moveq	#$1F,d0
	lsr.w	#$1,d5
	bcs.b	.loop
	bne.b	.loop2
	move.w	$FF2DB6.l,d5
	andi.w	#$F800,d5
	move.w	$E(sp),d2
	subq.w	#$1,d2
.loop3	bsr.w	TilemapCellAddr
	move.w	d6,d0
	mulu.w	(a1),d0
	add.w	$2(sp),d0
	asl.w	#$1,d0
	move.w	$A(sp),d1
	subq.w	#$1,d1
.loop4	move.w	$4(a1,d0.w),d3
	add.w	d4,d3
	eor.w	d5,d3
	move.w	d3,(a0)
	addq.w	#$2,d0
	dbra	d1,.loop4
	addq.w	#$1,$FF2DB4.l
	addq.w	#$1,d6
	dbra	d2,.loop3
	bsr.w	LinkedCall
	movem.l	(sp)+,d0-d3/d5-d6/a0-a3
	move.w	(sp)+,$23C6E8.l
	move.w	(sp)+,$FF2DB4.l
	rts
	lea.l	$23A450.l,a5
	movea.l	(a5)+,a0
	movea.l	(a5)+,a1
	movea.l	(a5)+,a2
	move.l	(a5)+,d0
	move.l	(a5)+,d1
	move.l	(a5)+,d2
	move.l	(a5)+,d3
	move.l	(a5)+,d4
	move.l	(a5)+,d5
	adda.l	#$180000,a0
	adda.l	#$180000,a1
	adda.l	#$180000,a2
	move.w	(a5)+,$FF2DB6.l
	move.w	(a5)+,$FF2DB2.l
	move.w	(a5)+,$FF2DB4.l
	move.w	(a5)+,$FF2DB8.l
	bsr.w	PrintGlyphsAlt
	lea.l	$23A450.l,a5
	move.w	d4,(a5)+
	move.w	$FF2DB6.l,(a5)+
	move.w	$FF2DB2.l,(a5)+
	move.w	$FF2DB4.l,(a5)+
	move.w	$FF2DB8.l,(a5)+
	rts
	lea.l	$23A450.l,a5
	movea.l	(a5)+,a0
	adda.l	#$180000,a0
	move.w	(a5),d4
	bsr.w	PrintCharAdvance
	move.w	d4,$23A450.l
	rts
	lea.l	$23A450.l,a5
	movea.l	(a5)+,a0
	movea.l	(a5)+,a1
	movea.l	(a5)+,a2
	adda.l	#$180000,a0
	adda.l	#$180000,a1
	adda.l	#$180000,a2
	move.l	(a5)+,d0
	move.l	(a5)+,d1
	move.l	(a5)+,d2
	move.l	(a5)+,d3
	move.l	(a5)+,d4
	move.l	(a5)+,d5
	move.w	(a5)+,$FF2DB6.l
	move.w	(a5)+,$FF2DB2.l
	move.w	(a5)+,$FF2DB4.l
	move.w	(a5),$FF2DB8.l
	bsr.w	PrintGlyphs
	move.w	d4,$23A450.l
	rts
.loop5	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	TilemapCellAddr
	move.w	$FF2DB6.l,d2
	move.w	(a1)+,d3
	subq.w	#$2,d3
	bra.w	.next5
.loop6	move.b	(a1)+,d0
	beq.w	.next5
	ext.w	d0
	bpl.w	.next2
	neg.w	d0
	move.w	d0,d2
	asl.w	#$8,d2
	asl.w	#$1,d2
	andi.w	#$F800,d2
	move.w	d2,$FF2DB6.l
	andi.w	#$3,d0
	asl.w	#$2,d0
	subq.w	#$4,d0
	move.w	d0,$FF2DB8.l
	move.b	(a1)+,d0
	ext.w	d0
	move.w	d0,$FF2DB2.l
	move.b	(a1)+,d1
	ext.w	d1
	move.w	d1,$FF2DB4.l
	bsr.w	TilemapCellAddr
	subq.w	#$2,d3
	bra.w	.next5
.next2	cmpi.b	#$40,d0
	bne.w	.next3
	move.w	#$7FF,d0
	bra.w	.next4
.next3	asl.w	#$1,d0
	movea.l	$FF2884.l,a2
	adda.l	$4(a2),a2
	move.w	$4(a2,d0.w),d0
	add.w	$FF287A.l,d0
.next4	add.w	d2,d0
	move.w	d0,(a0)
	addq.w	#$1,$FF2DB2.l
.next5	dbra	d3,.loop6
	movem.l	(sp)+,d0-d3/a0/a2
	move.w	(sp)+,$23C6E8.l
	rts
	move.l	a1,-(sp)
	movea.l	$4(sp),a1
	bsr.w	.loop5
	move.l	a1,$4(sp)
	movea.l	(sp)+,a1
	rts
	lea.l	$23A450.l,a1
	move.w	(a1)+,$FF2DB6.l
	move.w	(a1)+,$FF2DB8.l
	move.w	(a1)+,$FF2DB2.l
	move.w	(a1)+,$FF2DB4.l
	move.w	(a1)+,$FF287A.l
	bsr.w	.loop5
	lea.l	$23A450.l,a1
	move.w	$FF2DB6.l,(a1)+
	move.w	$FF2DB8.l,(a1)+
	move.w	$FF2DB2.l,(a1)+
	move.w	$FF2DB4.l,(a1)
	rts
; Prints a counted string with the plane parameters at $FF287A.
PrintStringBox	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	movem.l	d0-d3/a0/a2-a3,-(sp)
	lea.l	$FF287A.l,a3
	bsr.w	TilemapCellAddr
	move.w	$FF2DB6.l,d2
	move.w	(a1)+,d3
	subq.w	#$2,d3
	bra.w	.next2
.loop	move.b	(a1)+,d0
	ext.w	d0
	bgt.w	.next
	neg.w	d0
	asl.w	#$2,d0
	movea.l	#$FF1C94,a2
	movea.l	(a2,d0.w),a2
	jsr	(a2)
	bra.w	.next2
.next	bsr.w	.next3
.next2	dbra	d3,.loop
	movem.l	(sp)+,d0-d3/a0/a2-a3
	move.w	(sp)+,$23C6E8.l
	rts
.next3	move.w	$FF2DBA.l,d1
	cmpi.w	#$4,d1
	beq.w	.next7
	cmpi.b	#$40,d0
	bne.w	.next4
	move.w	#$7FF,d0
	bra.w	.next5
.next4	cmpi.b	#$5E,d0
	beq.w	.next6
	asl.w	#$1,d0
	movea.l	$FF2884.l,a2
	adda.l	$4(a2),a2
	move.w	$4(a2,d0.w),d0
	add.w	(a3,d1.w),d0
.next5	add.w	d2,d0
	move.w	d0,(a0)
	addq.w	#$1,$FF2DB2.l
	rts
.next6	addq.w	#$1,$FF2DB2.l
	bra.w	TilemapCellAddr
.next7	cmpi.b	#$61,d0
	blt.w	.next8
	cmpi.b	#$7A,d0
	bgt.w	.next8
	addi.w	#$FFE0,d0
.next8	movem.l	d4-d7/a0,-(sp)
	subi.w	#$20,d0
	lea.l	$FF2DBC.l,a0
	moveq	#$1,d4
	move.b	(a0,d0.w),d5
	ext.w	d5
	bpl.w	.next9
	neg.w	d5
	clr.w	d4
.next9	add.w	d5,d5
	movea.l	$FF2888.l,a0
	adda.l	$4(a0),a0
.loop2	bsr.w	.next10
	move.w	(a0),d7
	add.w	d7,d7
	add.w	d7,d5
	addq.w	#$1,$FF2DB4.l
	bsr.w	.next10
	sub.w	d7,d5
	subq.w	#$1,$FF2DB4.l
	addq.w	#$1,$FF2DB2.l
	addq.w	#$2,d5
	dbra	d4,.loop2
	movem.l	(sp)+,d4-d7/a0
	rts
.next10	movem.l	d1/a0,-(sp)
	move.w	(a3,d1.w),d6
	add.w	$4(a0,d5.w),d6
	add.w	d2,d6
	move.w	$FF2DB4.l,d0
	lea.l	$FF2852.l,a0
	adda.w	$FF2DB8.l,a0
	move.w	$2(a0),d1
	asl.w	d1,d0
	add.w	$FF2DB2.l,d0
	add.w	d0,d0
	add.w	(a0),d0
	bsr.w	VdpSetWriteAddr
	move.w	d6,(a0)
	movem.l	(sp)+,d1/a0
	rts
; Table of 9 longs after PrintStringBox, 36 bytes: $00FF2698,$00FF1CCC,$00FF1CE2,$00FF1CF4,$00FF1D04,$00FF1D14 ...
	dc.l	$FF2698
	dc.l	$FF1CCC
	dc.l	$FF1CE2
	dc.l	$FF1CF4
	dc.l	$FF1D04
	dc.l	$FF1D14
	dc.l	$FF1D24
	dc.l	$FF1D34
	dc.l	$FF1CB8

