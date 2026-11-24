DecompressGraphicsWithRemap						;DecompressGraphics, then return 8 bytes past the call (remap table)
	move.l	(sp),(remapTablePtr).l
	bsr.w	DecompressGraphicsQueue
	addi.l	#$8,(sp)
	rts
DecompressGraphicsPlain						;Clear remapTablePtr, fall into DecompressGraphics
	clr.l	(remapTablePtr).l
; Queues the decompress command in the list at $19360.
DecompressGraphicsQueue	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	btst	#$5,(GA_COMFLAGS+1).l
	beq.s	.next
	move.w	#$1,-(a6)
	bra.s	.next2
.next	move.w	#$0,-(a6)
.next2	bclr	#$5,(GA_COMFLAGS+1).l
	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
DecompressGraphics
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
	tst.l	(remapTablePtr).l
	beq.w	DoDMApro
	movea.l	(remapTablePtr).l,a1
	bra.w	QueueVramWriteFlag
.next3	andi.w	#$7FFF,d0
	add.w	d0,d4
	bsr.w	DecompressBytecode
.next4	movem.l	(sp)+,d0-d1/a0-a6
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	tst.w	(a6)+
	beq.s	.next5
	bset	#$5,(GA_COMFLAGS+1).l
	bra.s	.next6
.next5	bclr	#$5,(GA_COMFLAGS+1).l
.next6	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	rts
DecompressBytecode						;Unpack a0 into the 256 byte ring buffer at decompbuffer. d1 = vram
	
	movea.l	#ThreeStars,a1
	movea.l	#ThreeStars,a3
	movea.l	#remapTablePtr,a4
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
	dc.w	Opcode_CopyLiteral-DecompressOpcodeTable		;0
	dc.w	Opcode_CopyLiteral-DecompressOpcodeTable		;1
	dc.w	Opcode_ClearBytes-DecompressOpcodeTable		;2
	dc.w	Opcode_FillBytes-DecompressOpcodeTable		;3
	dc.w	Opcode_CopyBackwardShort-DecompressOpcodeTable		;4
	dc.w	Opcode_CopyBackwardShort-DecompressOpcodeTable		;5
	dc.w	Opcode_CopyBackwardShort-DecompressOpcodeTable		;6
	dc.w	Opcode_CopyBackwardShort-DecompressOpcodeTable		;7
	dc.w	Opcode_CopyBackwardMedium-DecompressOpcodeTable		;8
	dc.w	Opcode_CopyBackwardLong-DecompressOpcodeTable		;9
	dc.w	Opcode_CopyBackwardExtended1-DecompressOpcodeTable		;A
	dc.w	Opcode_CopyBackwardExtended2-DecompressOpcodeTable		;B
	dc.w	Opcode_CopyBackwardReverseShort-DecompressOpcodeTable		;C
	dc.w	Opcode_CopyBackwardReverseShort-DecompressOpcodeTable		;D
	dc.w	Opcode_CopyBackwardReverseMedium-DecompressOpcodeTable		;E
	dc.w	Opcode_CopyBackwardReverseLong-DecompressOpcodeTable		;F
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
Opcode_CopyBackwardLong						;opcode 9
	move.b	(a0),d0
	asl.b	#$1,d0		;x = bit 7 of the next byte
	move.b	-$1(a0),d0		;step back to the opcode byte just read
	roxl.b	#$1,d0
	andi.w	#$1F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	andi.w	#$7F,d2
	addq.w	#$1,d2
	bra.b	CopyBackwardRun
Opcode_CopyBackwardExtended1						;opcode A
	move.b	-$1(a0),d0		;step back to the opcode byte just read
	asl.w	#$8,d0
	move.b	(a0),d0
	lsr.w	#$6,d0
	andi.w	#$3F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	andi.w	#$3F,d2
	addq.w	#$1,d2
	bra.b	CopyBackwardRun
Opcode_CopyBackwardExtended2						;opcode B
	move.b	-$1(a0),d0		;step back to the opcode byte just read
	asl.w	#$8,d0
	move.b	(a0),d0
	lsr.w	#$5,d0
	andi.w	#$7F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	andi.w	#$1F,d2
	addq.w	#$1,d2
	bra.b	CopyBackwardRun
Opcode_CopyBackwardReverseShort						;opcodes C-D, copy backwards through the source
	move.b	-$1(a0),d0		;step back to the opcode byte just read
	andi.w	#$3,d0
	addq.w	#$1,d0
	move.b	-$1(a0),d2		;step back to the opcode byte just read
	lsr.w	#$2,d2
	andi.w	#$7,d2
	addq.w	#$1,d2
CopyBackwardReverseRun						;shared reverse copy loop
	neg.b	d2
	add.b	d1,d2
.loop	move.b	(a1,d2.w),(a1,d1.w)
	subq.b	#$1,d2
	addq.b	#$1,d1
	bne.w	.next
	bsr.w	FlushOutputBuffer		;buffer full
.next	dbra	d0,.loop
	rts
Opcode_CopyBackwardReverseMedium						;opcode E. Distance 0 is the end code
	move.b	-$1(a0),d0		;step back to the opcode byte just read
	andi.w	#$F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	bne.b	CopyBackwardReverseRun
	tst.w	d1		;end of data
	beq.w	.fin		;buffer empty
	bsr.w	FlushOutputBuffer
.fin	addq.w	#$4,sp		;drop the handler return: rts goes to DecompressBytecode's caller
	movem.l	(sp)+,d0-d3/a0-a2
	rts
Opcode_CopyBackwardReverseLong						;opcode F
	move.b	(a0),d0
	asl.b	#$1,d0
	move.b	-$1(a0),d0		;step back to the opcode byte just read
	roxl.b	#$1,d0
	andi.w	#$1F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	andi.w	#$7F,d2
	addq.w	#$1,d2
	bra.b	CopyBackwardReverseRun
FlushOutputBuffer						;Write d1 bytes (0 = 256) of the ring buffer to vram d3, advance d3
	movem.l	d0-d1/a0-a1,-(sp)
	move.w	d1,d0
	bne.w	.size
	move.w	#$100,d0		;full buffer
.size	lsr.w	#$1,d0		;bytes to words
	move.w	d3,d1		;vram address
	add.w	d0,d3
	add.w	d0,d3
	movea.l	a1,a0
	tst.l	(a4)
	beq.w	.dma
	movea.l	(a4),a1		;remap table
	jsr	(a5)		;remap
	bra.w	.done
.dma	jsr	(a6)
.done	movem.l	(sp)+,d0-d1/a0-a1
	rts