; MAIN.BIN $CB8-$12BF ($FF0CB8-$FF12BF). Emitted by tools/emit_m68k.py.
; Byte-stream decoder and gate-array flag handshakes. 16-long table at $FF1280.



	bsr.w	.next12
	bsr.w	.next11
	bsr.w	.next15
	bsr.w	.next13
	bra.w	.next14
.next11	move.b	(a1)+,d0
	subq.w	#$1,d3
	andi.w	#$3,d0
	asl.w	#$2,d0
	subq.w	#$4,d0
	move.w	d0,$FF2DB8.l
	bra.w	TilemapCellAddr
.next12	move.b	(a1)+,d2
	andi.w	#$7,d2
	subq.w	#$1,d3
	ror.w	#$3,d2
	move.w	d2,$FF2DB6.l
	rts
.next13	clr.w	d0
	move.b	(a1)+,d0
	subq.w	#$1,d3
	move.w	d0,$FF2DB2.l
	bra.w	TilemapCellAddr
.next14	clr.w	d0
	move.b	(a1)+,d0
	subq.w	#$1,d3
	move.w	d0,$FF2DB4.l
	bra.w	TilemapCellAddr
	move.b	(a1)+,d0
	ext.w	d0
	subq.w	#$1,d3
	add.w	d0,$FF2DB2.l
	bra.w	TilemapCellAddr
	move.b	(a1)+,d0
	ext.w	d0
	subq.w	#$1,d3
	add.w	d0,$FF2DB4.l
	bra.w	TilemapCellAddr
.next15	clr.w	d0
	move.b	(a1)+,d0
	subq.w	#$1,d3
	add.w	d0,d0
	move.w	d0,$FF2DBA.l
	rts
	lea.l	$23A450.l,a2
	move.w	(a2)+,$FF2DB6.l
	move.w	(a2)+,$FF2DB2.l
	move.w	(a2)+,$FF2DB4.l
	move.w	(a2)+,$FF2DBA.l
	move.w	(a2)+,$FF2DB8.l
	move.w	(a2)+,$FF287A.l
	move.w	(a2)+,$FF287C.l
	move.w	(a2)+,$FF287E.l
	movea.l	a2,a1
	bsr.w	PrintStringBox
	lea.l	$23A450.l,a2
	move.w	$FF2DB6.l,(a2)+
	move.w	$FF2DB2.l,(a2)+
	move.w	$FF2DB4.l,(a2)+
	move.w	$FF2DBA.l,(a2)+
	move.w	$FF2DB8.l,(a2)
	rts
	move.l	a1,-(sp)
	movea.l	$4(sp),a1
	bsr.w	PrintStringBox
	move.l	a1,$4(sp)
	movea.l	(sp)+,a1
	rts
	lea.l	$23A450.l,a1
	move.w	(a1)+,$FF2DB6.l
	move.w	(a1)+,$FF2DB2.l
	move.w	(a1)+,$FF2DB4.l
	move.w	(a1)+,$FF2DBA.l
	move.w	(a1)+,$FF2DB8.l
	move.w	(a1)+,$FF287A.l
	move.w	(a1)+,$FF287C.l
	move.w	(a1)+,$FF287E.l
	bsr.w	PrintStringBox
	lea.l	$23A450.l,a1
	move.w	$FF2DB6.l,(a1)+
	move.w	$FF2DB2.l,(a1)+
	move.w	$FF2DB4.l,(a1)+
	move.w	$FF2DBA.l,(a1)+
	move.w	$FF2DB8.l,(a1)
	rts
	lea.l	$23A450.l,a0
	lea.l	$FF2860.l,a1
.loop3	move.w	(a0)+,(a1)+
	cmpa.l	#$FF2884,a1
	blt.b	.loop3
	rts
	lea.l	$23A450.l,a0
	move.w	(a0)+,d1
	movea.l	(a0)+,a1
	move.w	(a0)+,$FF2DB2.l
	move.w	(a0)+,$FF2DB4.l
	move.w	(a0)+,$FF2DB8.l
	adda.l	#$180000,a1
	bset.b	#$4,$23C6E8.l
	bsr.w	TilemapCellAddr
	neg.w	d1
	addq.w	#$3,d1
	moveq	#$2,d2
.loop4	move.w	(a1),d0
	cmp.b	d2,d1
	ble.w	.next16
	move.w	$2(a1),d0
.next16	add.w	$FF286C.l,d0
	move.w	d0,(a0)
	dbra	d2,.loop4
	bclr.b	#$4,$23C6E8.l
	rts
	rts
	move.w	$C00008.l,$23A450.l
	rts
	lea.l	$23A450.l,a0
	move.l	(a0)+,d4
	movea.l	(a0)+,a2
	move.l	a0,$FF2912.l
	adda.l	#$180000,a2
	bsr.w	ProcessTileCmdList
	lea.l	$23A450.l,a0
	move.l	d4,(a0)
	rts
	lea.l	$23A450.l,a5
	addq.l	#$4,a5
	move.w	(a5)+,d4
	move.w	(a5)+,d2
	movea.l	(a5)+,a1
	adda.l	#$180000,a1
	move.w	(a5)+,$FF2DB2.l
	move.w	(a5)+,$FF2DB4.l
	move.w	(a5)+,$FF2DB6.l
	move.w	(a5)+,$FF2DB8.l
	lea.l	$23A450.l,a5
	bsr.w	.next17
	addq.l	#$4,a5
	move.w	d4,(a5)+
	move.w	$FF2DB4.l,(a5)
	rts
.next17	bsr.w	TilemapCellAddr
	addq.w	#$1,$FF2DB4.l
	bsr.w	.next18
	addq.w	#$2,d4
	move.w	$0(a5),d0
	subq.w	#$3,d0
.loop5	bsr.w	.next18
	dbra	d0,.loop5
	addq.w	#$2,d4
	bsr.w	.next18
	addq.w	#$2,d4
	rts
.next18	move.w	(a1,d4.w),d3
	add.w	d2,d3
	move.w	d3,(a0)
	rts
DispatchPrep	bset.b	#$0,$A12018.l
.loop	btst.b	#$0,$A12028.l
	beq.b	.loop
	bclr.b	#$0,$A12018.l
.loop2	btst.b	#$0,$A12028.l
	bne.b	.loop2
	rts
DispatchBody	bset.b	#$1,$A12018.l
.loop	btst.b	#$1,$A12028.l
	beq.b	.loop
	bclr.b	#$1,$A12018.l
.loop2	btst.b	#$1,$A12028.l
	bne.b	.loop2
	rts
DispatchAfter	bset.b	#$2,$A12018.l
.loop	btst.b	#$2,$A12028.l
	beq.b	.loop
	bclr.b	#$2,$A12018.l
.loop2	btst.b	#$2,$A12028.l
	bne.b	.loop2
	rts
DispatchTail	bset.b	#$3,$A12018.l
.loop	btst.b	#$3,$A12028.l
	beq.b	.loop
	bclr.b	#$3,$A12018.l
.loop2	btst.b	#$3,$A12028.l
	bne.b	.loop2
	rts
	move.l	a1,-(sp)
	movea.l	$4(sp),a1
	bsr.w	DrawLines
	move.l	a1,$4(sp)
	movea.l	(sp)+,a1
	rts
; Draws a list of line segments held at a1.
DrawLines	movem.l	d0-d3,-(sp)
	move.w	$E(a1),d3
	bra.w	.next
.loop	lea.l	(a1),a0
	bsr.w	.next2
	move.w	d0,d2
	lea.l	$6(a1),a0
	bsr.w	.next2
	move.w	d0,d1
	move.w	$C(a1),d0
	add.w	d0,d0
	bsr.w	.next3
.next	dbra	d3,.loop
	adda.l	#$10,a1
	movem.l	(sp)+,d0-d3
	rts
.next2	movem.l	d1/a0-a2,-(sp)
	lea.l	$FF284E.l,a2
	move.w	$4(a0),d1
	asl.w	#$2,d1
	adda.w	d1,a2
	move.w	$E(a1),d0
	sub.w	d3,d0
	subq.w	#$1,d0
	add.w	$2(a0),d0
	move.w	$2(a2),d1
	asl.w	d1,d0
	add.w	(a0),d0
	add.w	d0,d0
	add.w	(a2),d0
	movem.l	(sp)+,d1/a0-a2
	rts
.next3	movem.l	d0-d3/a1,-(sp)
	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	lea.l	$C00004.l,a1
	move.w	#$8154,(a1)
	move.w	#$8F01,(a1)
	move.w	#$9300,d3
	move.b	d0,d3
	move.w	d3,(a1)
	move.w	#$9400,d3
	lsr.w	#$8,d0
	move.b	d0,d3
	move.w	d3,(a1)
	move.w	#$9500,d3
	move.b	d2,d3
	move.w	d3,(a1)
	move.w	#$9600,d3
	lsr.w	#$8,d2
	move.b	d2,d3
	move.w	d3,(a1)
	move.w	#$97C0,(a1)
	clr.l	d0
	move.w	d1,d0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	swap	d0
	ori.w	#$C0,d0
	move.l	d0,$FF290E.l
	move.w	$FF290E.l,(a1)
	move.w	$FF2910.l,(a1)
	bsr.w	WaitVdpDmaDone
	move.w	#$8164,(a1)
	move.w	#$8F02,(a1)
	move.w	(sp)+,$23C6E8.l
	movem.l	(sp)+,d0-d3/a1
	rts
; VdpSetWriteAddr taking the address in d1 and keeping a1.
VdpSetWriteAddrD1	movem.l	d3/a1,-(sp)
	movea.l	#$C00000,a1
	andi.l	#$FFFF,d1
	asl.l	#$2,d1
	lsr.w	#$2,d1
	ori.w	#$4000,d1
	swap	d1
	move.l	d1,$4(a1)
	move.w	d2,d3
	swap	d3
	move.w	d2,d3
	lsr.w	#$1,d0
	subq.w	#$1,d0
.loop	move.l	d3,$FF290E.l
	move.w	$FF290E.l,(a1)
	move.w	$FF2910.l,(a1)
	dbra	d0,.loop
	movem.l	(sp)+,d3/a1
	rts
	lea.l	$23A450.l,a1
	bsr.w	DrawLines
	rts
; Packs the glyph bitmap at a0 into 4-bit pixels at $FF2916.
PackGlyphBits	movem.l	d0-d3/a0-a2,-(sp)
	move.w	d1,d3
	clr.w	d1
	clr.w	d2
	lea.l	$FF2916.l,a1
.loop	move.b	(a0)+,d0
	andi.w	#$F0,d0
	lsr.w	#$2,d0
	movea.l	#$FF2280,a2
	movea.l	(a2,d0.w),a2
	jsr	(a2)
	bra.b	.loop
	move.b	-$1(a0),d0
	andi.w	#$1F,d0
.loop2	move.b	(a0)+,(a1,d1.w)
	addq.b	#$1,d1
	bne.w	.next
	bsr.w	ExpandTileData
.next	dbra	d0,.loop2
	rts
	move.b	-$1(a0),d0
	andi.w	#$F,d0
.loop3	clr.b	(a1,d1.w)
	addq.b	#$1,d1
	bne.w	.next2
	bsr.w	ExpandTileData
.next2	dbra	d0,.loop3
	rts
	move.b	-$1(a0),d0
	andi.w	#$F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
.loop4	move.b	d2,(a1,d1.w)
	addq.b	#$1,d1
	bne.w	.next3
	bsr.w	ExpandTileData
.next3	dbra	d0,.loop4
	rts
	move.b	-$1(a0),d0
	andi.w	#$7,d0
	addq.w	#$1,d0
	move.b	-$1(a0),d2
	lsr.w	#$3,d2
	andi.w	#$7,d2
	addq.w	#$1,d2
.loop5	neg.b	d2
	add.b	d1,d2
.loop6	move.b	(a1,d2.w),(a1,d1.w)
	addq.b	#$1,d2
	addq.b	#$1,d1
	bne.w	.next4
	bsr.w	ExpandTileData
.next4	dbra	d0,.loop6
	rts
	move.b	-$1(a0),d0
	andi.w	#$F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	bra.b	.loop5
	move.b	(a0),d0
	asl.b	#$1,d0
	move.b	-$1(a0),d0
	roxl.b	#$1,d0
	andi.w	#$1F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	andi.w	#$7F,d2
	addq.w	#$1,d2
	bra.b	.loop5
	move.b	-$1(a0),d0
	asl.w	#$8,d0
	move.b	(a0),d0
	lsr.w	#$6,d0
	andi.w	#$3F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	andi.w	#$3F,d2
	addq.w	#$1,d2
	bra.b	.loop5
	move.b	-$1(a0),d0
	asl.w	#$8,d0
	move.b	(a0),d0
	lsr.w	#$5,d0
	andi.w	#$7F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	andi.w	#$1F,d2
	addq.w	#$1,d2
	bra.b	.loop5
	move.b	-$1(a0),d0
	andi.w	#$3,d0
	addq.w	#$1,d0
	move.b	-$1(a0),d2
	lsr.w	#$2,d2
	andi.w	#$7,d2
	addq.w	#$1,d2
.loop7	neg.b	d2
	add.b	d1,d2
.loop8	move.b	(a1,d2.w),(a1,d1.w)
	subq.b	#$1,d2
	addq.b	#$1,d1
	bne.w	.next5
	bsr.w	ExpandTileData
.next5	dbra	d0,.loop8
	rts
	move.b	-$1(a0),d0
	andi.w	#$F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	bne.b	.loop7
	bsr.w	ExpandTileData
	addq.l	#$4,sp
	movem.l	(sp)+,d0-d3/a0-a2
	rts
	move.b	(a0),d0
	asl.b	#$1,d0
	move.b	-$1(a0),d0
	roxl.b	#$1,d0
	andi.w	#$1F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	andi.w	#$7F,d2
	addq.w	#$1,d2
	bra.b	.loop7
; Data of PackGlyphBits (16 rows): table or constants used by it.
	dc.l	$FF2134
	dc.l	$FF2134
	dc.l	$FF2150
	dc.l	$FF216C
	dc.l	$FF218C
	dc.l	$FF218C
	dc.l	$FF218C
	dc.l	$FF218C
	dc.l	$FF21BE
	dc.l	$FF21CC
	dc.l	$FF21E6
	dc.l	$FF2200
	dc.l	$FF221A
	dc.l	$FF221A
	dc.l	$FF224C
	dc.l	$FF2266

