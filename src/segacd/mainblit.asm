; MAIN.BIN $CB8-$12BF (runtime $FF1CB8-$FF22BF). Emitted by tools/emit_m68k.py.
; The text codes, the older interface's commands $0C-$12 (coded text, drawing parameters, tiles, frame rows,
; VRAM copies), the four flag handshakes, FillVram, then the byte-stream decoder (16-long table at $FF2280).

FlushOutputBuffer	equ	$FF1316
WaitForVdpDma	equ	$FF151C
FontMapPtr	equ	$FF2884
DecompressGraphics	equ	$FF1278
X_FF1B42	equ	$FF1B42
SetVramWriteToCursor	equ	$FF16B6

	org	$FF1CB8

TextCodeSetAll						;code 8: attribute, plane, font, x, y
	bsr.w	TextCodeSetAttribute
	bsr.w	TextCodeSetPlane
	bsr.w	TextCodeSetFont
	bsr.w	TextCodeSetX
	bra.w	TextCodeSetY
TextCodeSetPlane					;code 1: the plane
	move.b	(a1)+,d0
	subq.w	#$1,d3
	andi.w	#$3,d0
	asl.w	#$2,d0
	subq.w	#$4,d0
	move.w	d0,$FF2DB8.l
	bra.w	SetVramWriteToCursor
TextCodeSetAttribute				;code 2: attribute bits 13-15 (palette, priority)
	move.b	(a1)+,d2
	andi.w	#$7,d2
	subq.w	#$1,d3
	ror.w	#$3,d2
	move.w	d2,$FF2DB6.l
	rts
TextCodeSetX						;code 3: x
	clr.w	d0
	move.b	(a1)+,d0
	subq.w	#$1,d3
	move.w	d0,$FF2DB2.l
	bra.w	SetVramWriteToCursor
TextCodeSetY						;code 4: y
	clr.w	d0
	move.b	(a1)+,d0
	subq.w	#$1,d3
	move.w	d0,$FF2DB4.l
	bra.w	SetVramWriteToCursor
TextCodeMoveX						;code 5: x plus a signed byte
	move.b	(a1)+,d0
	ext.w	d0
	subq.w	#$1,d3
	add.w	d0,$FF2DB2.l
	bra.w	SetVramWriteToCursor
TextCodeMoveY						;code 6: y plus a signed byte
	move.b	(a1)+,d0
	ext.w	d0
	subq.w	#$1,d3
	add.w	d0,$FF2DB4.l
	bra.w	SetVramWriteToCursor
TextCodeSetFont						;code 7: the font (which base at $FF287A)
	clr.w	d0
	move.b	(a1)+,d0
	subq.w	#$1,d3
	add.w	d0,d0
	move.w	d0,$FF2DBA.l
	rts
DrawCodedTextCommand				;command $0C: attribute, x, y, font, plane, three font bases, a string
									;with codes: DrawCodedText; the state back
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
	bsr.w	X_FF1B42
	lea.l	$23A450.l,a2
	move.w	$FF2DB6.l,(a2)+
	move.w	$FF2DB2.l,(a2)+
	move.w	$FF2DB4.l,(a2)+
	move.w	$FF2DBA.l,(a2)+
	move.w	$FF2DB8.l,(a2)
	rts
DrawCodedTextInline					;DrawCodedText with the string after the call
	move.l	a1,-(sp)
	movea.l	$4(sp),a1
	bsr.w	X_FF1B42
	move.l	a1,$4(sp)
	movea.l	(sp)+,a1
	rts
DrawCodedTextCommand2				;command $0D: the same as $0C
	lea.l	$23A450.l,a1
	move.w	(a1)+,$FF2DB6.l
	move.w	(a1)+,$FF2DB2.l
	move.w	(a1)+,$FF2DB4.l
	move.w	(a1)+,$FF2DBA.l
	move.w	(a1)+,$FF2DB8.l
	move.w	(a1)+,$FF287A.l
	move.w	(a1)+,$FF287C.l
	move.w	(a1)+,$FF287E.l
	bsr.w	X_FF1B42
	lea.l	$23A450.l,a1
	move.w	$FF2DB6.l,(a1)+
	move.w	$FF2DB2.l,(a1)+
	move.w	$FF2DB4.l,(a1)+
	move.w	$FF2DBA.l,(a1)+
	move.w	$FF2DB8.l,(a1)
	rts
SetDrawingParametersCommand			;command $0E: $24 bytes from $23A450 to $FF2860-$FF2883 (the font bases
									;at $FF287A on)
	lea.l	$23A450.l,a0
	lea.l	$FF2860.l,a1
LFF1E24	move.w	(a0)+,(a1)+
	cmpa.l	#FontMapPtr,a1
	blt.b	LFF1E24
	rts
DrawThreeCellGauge					;not in CmdJumpTable, no caller found: d1 of three cells from the first
									;word at a1, the rest from the second, + $FF286C
	lea.l	$23A450.l,a0
	move.w	(a0)+,d1
	movea.l	(a0)+,a1
	move.w	(a0)+,$FF2DB2.l
	move.w	(a0)+,$FF2DB4.l
	move.w	(a0)+,$FF2DB8.l
	adda.l	#$180000,a1
	bset.b	#$4,$23C6E8.l
	bsr.w	SetVramWriteToCursor
	neg.w	d1
	addq.w	#$3,d1
	moveq	#$2,d2
LFF1E64	move.w	(a1),d0
	cmp.b	d2,d1
	ble.w	LFF1E70
	move.w	$2(a1),d0
LFF1E70	add.w	$FF286C.l,d0
	move.w	d0,(a0)
	dbra	d2,LFF1E64
	bclr.b	#$4,$23C6E8.l
	rts
	rts
ReadHvCounterToWordRamCommand		;command $0F: the HV counter into $23A450
	move.w	$C00008.l,$23A450.l
	rts
LoadRecolouredTilesCommand			;command $10: d4, a2 tiles, then eight bytes of colour map: each pixel of
									;the tiles through the map (remapTablePtr) into VRAM at character d4; d4
									;back
	lea.l	$23A450.l,a0
	move.l	(a0)+,d4
	movea.l	(a0)+,a2
	move.l	a0,$FF2912.l
	adda.l	#$180000,a2
	bsr.w	DecompressGraphics
	lea.l	$23A450.l,a0
	move.l	d4,(a0)
	rts
DrawFrameRowCommand					;command $11: width, d4, d2, a1, x, y, attribute, plane: DrawFrameRow; d4,
									;y back
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
	bsr.w	DrawFrameRow
	addq.l	#$4,a5
	move.w	d4,(a5)+
	move.w	$FF2DB4.l,(a5)
	rts
DrawFrameRow						;a row of the width at 0(a5): the cell words at a1 + d4, + 2 (repeated), +
									;4, each + d2; d4 on to the next row, y down
	bsr.w	SetVramWriteToCursor
	addq.w	#$1,$FF2DB4.l
	bsr.w	WriteFrameCell
	addq.w	#$2,d4
	move.w	$0(a5),d0
	subq.w	#$3,d0
LFF1F10	bsr.w	WriteFrameCell
	dbra	d0,LFF1F10
	addq.w	#$2,d4
	bsr.w	WriteFrameCell
	addq.w	#$2,d4
	rts
WriteFrameCell
	move.w	(a1,d4.w),d3
	add.w	d2,d3
	move.w	d3,(a0)
	rts
DispatchPrep						;bit 0 of $A12018 until the sub CPU answers on $A12028 (the names of
									;maincd.asm)
	bset.b	#$0,$A12018.l
LFF1F34	btst.b	#$0,$A12028.l
	beq.b	LFF1F34
	bclr.b	#$0,$A12018.l
LFF1F46	btst.b	#$0,$A12028.l
	bne.b	LFF1F46
	rts
DispatchBody						;bit 1
	bset.b	#$1,$A12018.l
LFF1F5A	btst.b	#$1,$A12028.l
	beq.b	LFF1F5A
	bclr.b	#$1,$A12018.l
LFF1F6C	btst.b	#$1,$A12028.l
	bne.b	LFF1F6C
	rts
DispatchAfter						;bit 2
	bset.b	#$2,$A12018.l
LFF1F80	btst.b	#$2,$A12028.l
	beq.b	LFF1F80
	bclr.b	#$2,$A12018.l
LFF1F92	btst.b	#$2,$A12028.l
	bne.b	LFF1F92
	rts
DispatchTail						;bit 3
	bset.b	#$3,$A12018.l
LFF1FA6	btst.b	#$3,$A12028.l
	beq.b	LFF1FA6
	bclr.b	#$3,$A12018.l
LFF1FB8	btst.b	#$3,$A12028.l
	bne.b	LFF1FB8
	rts
CopyCellRectanglesInline			;CopyCellRectangles with the block after the call
	move.l	a1,-(sp)
	movea.l	$4(sp),a1
	bsr.w	CopyCellRectangles
	move.l	a1,$4(sp)
	movea.l	(sp)+,a1
	rts
CopyCellRectangles					;a1 a block: from x, y, plane (1 A, 2 B, 3 window), to x, y, plane, width,
									;rows; each row by a VRAM copy DMA
	movem.l	d0-d3,-(sp)
	move.w	$E(a1),d3
	bra.w	LFF1FFE
LFF1FE2	lea.l	(a1),a0
	bsr.w	CellVramAddress
	move.w	d0,d2
	lea.l	$6(a1),a0
	bsr.w	CellVramAddress
	move.w	d0,d1
	move.w	$C(a1),d0
	add.w	d0,d0
	bsr.w	CopyVramByDma
LFF1FFE	dbra	d3,LFF1FE2
	adda.l	#$10,a1
	movem.l	(sp)+,d0-d3
	rts
CellVramAddress						;the VRAM address of row $E(a1) - d3 - 1 + y at the x, y, plane at a0
	movem.l	d1/a0-a2,-(sp)
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
CopyVramByDma						;d0 bytes from VRAM d2 to VRAM d1 (DMA on and the V interrupt off
									;meanwhile)
	movem.l	d0-d3/a1,-(sp)
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
	bsr.w	WaitForVdpDma
	move.w	#$8164,(a1)
	move.w	#$8F02,(a1)
	move.w	(sp)+,$23C6E8.l
	movem.l	(sp)+,d0-d3/a1
	rts
FillVram							;d0 bytes of the word d2 at VRAM d1
	movem.l	d3/a1,-(sp)
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
LFF20E6	move.l	d3,$FF290E.l
	move.w	$FF290E.l,(a1)
	move.w	$FF2910.l,(a1)
	dbra	d0,LFF20E6
	movem.l	(sp)+,d3/a1
	rts
CopyCellRectanglesCommand			;command $12: CopyCellRectangles with the block at $23A450
	lea.l	$23A450.l,a1
	bsr.w	CopyCellRectangles
	rts
DecompressBytecode					;unpack a0 into the 256-byte ring buffer at $FF2916
	movem.l	d0-d3/a0-a2,-(sp)
	move.w	d1,d3
	clr.w	d1
	clr.w	d2
	lea.l	$FF2916.l,a1
LFF211E	move.b	(a0)+,d0
	andi.w	#$F0,d0
	lsr.w	#$2,d0
	movea.l	#$FF2280,a2
	movea.l	(a2,d0.w),a2
	jsr	(a2)
	bra.b	LFF211E
Opcode_CopyLiteral					;opcodes 0-1
	move.b	-$1(a0),d0
	andi.w	#$1F,d0
LFF213C	move.b	(a0)+,(a1,d1.w)
	addq.b	#$1,d1
	bne.w	LFF214A
	bsr.w	FlushOutputBuffer
LFF214A	dbra	d0,LFF213C
	rts
Opcode_ClearBytes					;opcode 2
	move.b	-$1(a0),d0
	andi.w	#$F,d0
LFF2158	clr.b	(a1,d1.w)
	addq.b	#$1,d1
	bne.w	LFF2166
	bsr.w	FlushOutputBuffer
LFF2166	dbra	d0,LFF2158
	rts
Opcode_FillBytes					;opcode 3
	move.b	-$1(a0),d0
	andi.w	#$F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
LFF2178	move.b	d2,(a1,d1.w)
	addq.b	#$1,d1
	bne.w	LFF2186
	bsr.w	FlushOutputBuffer
LFF2186	dbra	d0,LFF2178
	rts
Opcode_CopyBackwardShort			;opcodes 4-7
	move.b	-$1(a0),d0
	andi.w	#$7,d0
	addq.w	#$1,d0
	move.b	-$1(a0),d2
	lsr.w	#$3,d2
	andi.w	#$7,d2
	addq.w	#$1,d2
CopyBackwardRun						;shared copy loop
	neg.b	d2
	add.b	d1,d2
LFF21A6	move.b	(a1,d2.w),(a1,d1.w)
	addq.b	#$1,d2
	addq.b	#$1,d1
	bne.w	LFF21B8
	bsr.w	FlushOutputBuffer
LFF21B8	dbra	d0,LFF21A6
	rts
Opcode_CopyBackwardMedium			;opcode 8
	move.b	-$1(a0),d0
	andi.w	#$F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	bra.b	CopyBackwardRun
Opcode_CopyBackwardLong				;opcode 9
	move.b	(a0),d0
	asl.b	#$1,d0
	move.b	-$1(a0),d0
	roxl.b	#$1,d0
	andi.w	#$1F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	andi.w	#$7F,d2
	addq.w	#$1,d2
	bra.b	CopyBackwardRun
Opcode_CopyBackwardExtended1		;opcode A
	move.b	-$1(a0),d0
	asl.w	#$8,d0
	move.b	(a0),d0
	lsr.w	#$6,d0
	andi.w	#$3F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	andi.w	#$3F,d2
	addq.w	#$1,d2
	bra.b	CopyBackwardRun
Opcode_CopyBackwardExtended2		;opcode B
	move.b	-$1(a0),d0
	asl.w	#$8,d0
	move.b	(a0),d0
	lsr.w	#$5,d0
	andi.w	#$7F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	andi.w	#$1F,d2
	addq.w	#$1,d2
	bra.b	CopyBackwardRun
Opcode_CopyBackwardReverseShort		;opcodes C-D
	move.b	-$1(a0),d0
	andi.w	#$3,d0
	addq.w	#$1,d0
	move.b	-$1(a0),d2
	lsr.w	#$2,d2
	andi.w	#$7,d2
	addq.w	#$1,d2
CopyBackwardReverseRun				;shared reverse copy loop
	neg.b	d2
	add.b	d1,d2
LFF2234	move.b	(a1,d2.w),(a1,d1.w)
	subq.b	#$1,d2
	addq.b	#$1,d1
	bne.w	LFF2246
	bsr.w	FlushOutputBuffer
LFF2246	dbra	d0,LFF2234
	rts
Opcode_CopyBackwardReverseMedium	;opcode E; distance 0 is the end code
	move.b	-$1(a0),d0
	andi.w	#$F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	bne.b	CopyBackwardReverseRun
	bsr.w	FlushOutputBuffer
	addq.l	#$4,sp
	movem.l	(sp)+,d0-d3/a0-a2
	rts
Opcode_CopyBackwardReverseLong		;opcode F
	move.b	(a0),d0
	asl.b	#$1,d0
	move.b	-$1(a0),d0
	roxl.b	#$1,d0
	andi.w	#$1F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	andi.w	#$7F,d2
	addq.w	#$1,d2
	bra.b	CopyBackwardReverseRun
DecompressOpcodeTable				;one handler per opcode high nibble
	dc.l	Opcode_CopyLiteral
	dc.l	Opcode_CopyLiteral
	dc.l	Opcode_ClearBytes
	dc.l	Opcode_FillBytes
	dc.l	Opcode_CopyBackwardShort
	dc.l	Opcode_CopyBackwardShort
	dc.l	Opcode_CopyBackwardShort
	dc.l	Opcode_CopyBackwardShort
	dc.l	Opcode_CopyBackwardMedium
	dc.l	Opcode_CopyBackwardLong
	dc.l	Opcode_CopyBackwardExtended1
	dc.l	Opcode_CopyBackwardExtended2
	dc.l	Opcode_CopyBackwardReverseShort
	dc.l	Opcode_CopyBackwardReverseShort
	dc.l	Opcode_CopyBackwardReverseMedium
	dc.l	Opcode_CopyBackwardReverseLong
