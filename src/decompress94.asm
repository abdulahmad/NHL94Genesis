;	Graphics decompression (93G decompress93.asm): DecompressGraphics sends packed tiles to vram
;	through DecompressBytecode and its 256 byte ring buffer. Included at the end of video94.asm.

DecompressGraphicsWithCallback		;DecompressGraphics, then return 8 bytes past the call (callback data)
	move.l	(sp),(callbackPtr).w
	bsr.w	DecompressGraphics
	addq.l	#8,(sp)					;skip the inline remap table
	rts
DecompressGraphicsPlain				;Clear callbackPtr, fall into DecompressGraphics
	clr.l	(callbackPtr).w
DecompressGraphics					;a2 = graphics data, d4 = start char
	movem.l	d0-d1/a0-a6,-(sp)
	movea.l	a2,a0					;a0 = compressed data
	move.w	d4,d1
	asl.w	#5,d1					;d1 = vram address of start char
	move.w	(a0)+,d0				;tile count
	beq.w	.done					;no tiles
	bmi.w	.packed					;bit 15: compressed
	add.w	d0,d4
	asl.w	#4,d0					;words to transfer
	pea	(.done).l
	tst.l	(callbackPtr).w
	beq.w	DoDMApro
	movea.l	(callbackPtr).w,a1		;remap table
	bra.w	remap
.packed
	andi.w	#$7FFF,d0				;tile count
	add.w	d0,d4
	bsr.w	DecompressBytecode
.done
	movem.l	(sp)+,d0-d1/a0-a6
	rts
DecompressBytecode					;Unpack a0 into the 256 byte ring buffer at ThreeStars
	movea.w	#(ThreeStars-M68K_RAM),a1
	movea.w	#(ThreeStars-M68K_RAM),a3
	movea.w	#(callbackPtr-M68K_RAM),a4
	movea.l	#remap,a5
	movea.l	#DoDMApro,a6
	movem.l	d0-d3/a0-a2,-(sp)
	move.w	d1,d3					;d3 = vram address
	clr.w	d1						;d1 = output buffer offset
	clr.w	d2
.loop
	move.b	(a0)+,d0				;read opcode
	andi.w	#$F0,d0
	lsr.w	#3,d0					;upper nibble * 2
	lea	jump_table(pc),a2
	move.w	0(a2,d0.w),d0
	jsr	0(a2,d0.w)
	bra.s	.loop
jump_table							;DecompressBytecode handler offsets, one per opcode high nibble
	dc.w	Opcode_CopyLiteral-jump_table	;0
	dc.w	Opcode_CopyLiteral-jump_table	;1
	dc.w	Opcode_ClearBytes-jump_table	;2
	dc.w	Opcode_Fillbytes-jump_table	;3
	dc.w	Opcode_CopyBackwardShort-jump_table	;4
	dc.w	Opcode_CopyBackwardShort-jump_table	;5
	dc.w	Opcode_CopyBackwardShort-jump_table	;6
	dc.w	Opcode_CopyBackwardShort-jump_table	;7
	dc.w	Opcode_CopyBackwardMedium-jump_table	;8
	dc.w	Opcode_CopyBackwardLong-jump_table	;9
	dc.w	Opcode_CopyBackwardExtended1-jump_table	;A
	dc.w	Opcode_CopyBackwardExtended2-jump_table	;B
	dc.w	Opcode_CopyBackwardReverseShort-jump_table	;C
	dc.w	Opcode_CopyBackwardReverseShort-jump_table	;D
	dc.w	Opcode_CopyBackwardReverseMedium-jump_table	;E
	dc.w	Opcode_CopyBackwardReverseLong-jump_table	;F
Opcode_CopyLiteral					;opcodes 0-1, copy (low 5 bits)+1 bytes from the data
	move.b	-1(a0),d0				;step back to the opcode byte just read
	andi.w	#$1F,d0
.loop
	move.b	(a0)+,0(a1,d1.w)
	addq.b	#1,d1					;d1 is a byte index: wraps to 0 after 256 bytes
	bne.w	.next
	bsr.w	FlushOutputBuffer		;buffer full
.next
	dbf	d0,.loop
	rts
Opcode_ClearBytes					;opcode 2, write (low 4 bits)+1 zero bytes
	move.b	-1(a0),d0				;step back to the opcode byte just read
	andi.w	#$F,d0
.loop
	clr.b	0(a1,d1.w)
	addq.b	#1,d1
	bne.w	.next
	bsr.w	FlushOutputBuffer		;buffer full
.next
	dbf	d0,.loop
	rts
Opcode_Fillbytes					;opcode 3, write the next data byte (low 4 bits)+3 times
	move.b	-1(a0),d0				;step back to the opcode byte just read
	andi.w	#$F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
.loop
	move.b	d2,0(a1,d1.w)
	addq.b	#1,d1
	bne.w	.next
	bsr.w	FlushOutputBuffer		;buffer full
.next
	dbf	d0,.loop
	rts
Opcode_CopyBackwardShort			;opcodes 4-7, copy from back in the output buffer
	move.b	-1(a0),d0				;step back to the opcode byte just read
	andi.w	#7,d0
	addq.w	#1,d0					;count-1
	move.b	-1(a0),d2				;step back to the opcode byte just read
	lsr.w	#3,d2
	andi.w	#7,d2
	addq.w	#1,d2					;distance
CopyBackwardRun						;shared copy loop, d0 = count-1, d2 = distance back
	neg.b	d2
	add.b	d1,d2					;source offset in the ring buffer
.loop
	move.b	0(a1,d2.w),0(a1,d1.w)
	addq.b	#1,d2
	addq.b	#1,d1
	bne.w	.next
	bsr.w	FlushOutputBuffer		;buffer full
.next
	dbf	d0,.loop
	rts
Opcode_CopyBackwardMedium			;opcode 8
	move.b	-1(a0),d0				;step back to the opcode byte just read
	andi.w	#$F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
	bra.s	CopyBackwardRun
Opcode_CopyBackwardLong				;opcode 9
	move.b	(a0),d0
	asl.b	#1,d0					;x = bit 7 of the next byte
	move.b	-1(a0),d0				;step back to the opcode byte just read
	roxl.b	#1,d0
	andi.w	#$1F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
	andi.w	#$7F,d2
	addq.w	#1,d2
	bra.s	CopyBackwardRun
Opcode_CopyBackwardExtended1		;opcode A
	move.b	-1(a0),d0				;step back to the opcode byte just read
	asl.w	#8,d0
	move.b	(a0),d0
	lsr.w	#6,d0
	andi.w	#$3F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
	andi.w	#$3F,d2
	addq.w	#1,d2
	bra.s	CopyBackwardRun
Opcode_CopyBackwardExtended2		;opcode B
	move.b	-1(a0),d0				;step back to the opcode byte just read
	asl.w	#8,d0
	move.b	(a0),d0
	lsr.w	#5,d0
	andi.w	#$7F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
	andi.w	#$1F,d2
	addq.w	#1,d2
	bra.s	CopyBackwardRun
Opcode_CopyBackwardReverseShort		;opcodes C-D, copy backwards through the source
	move.b	-1(a0),d0				;step back to the opcode byte just read
	andi.w	#3,d0
	addq.w	#1,d0
	move.b	-1(a0),d2				;step back to the opcode byte just read
	lsr.w	#2,d2
	andi.w	#7,d2
	addq.w	#1,d2
CopyBackwardReverseRun				;shared reverse copy loop
	neg.b	d2
	add.b	d1,d2
.loop
	move.b	0(a1,d2.w),0(a1,d1.w)
	subq.b	#1,d2
	addq.b	#1,d1
	bne.w	.next
	bsr.w	FlushOutputBuffer		;buffer full
.next
	dbf	d0,.loop
	rts
Opcode_CopyBackwardReverseMedium	;opcode E. Distance 0 is the end code
	move.b	-1(a0),d0				;step back to the opcode byte just read
	andi.w	#$F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
	bne.s	CopyBackwardReverseRun
	tst.w	d1						;end of data
	beq.w	.fin					;buffer empty
	bsr.w	FlushOutputBuffer
.fin
	addq.w	#4,sp					;drop the return into DecompressBytecode
	movem.l	(sp)+,d0-d3/a0-a2
	rts
Opcode_CopyBackwardReverseLong		;opcode F
	move.b	(a0),d0
	asl.b	#1,d0
	move.b	-1(a0),d0				;step back to the opcode byte just read
	roxl.b	#1,d0
	andi.w	#$1F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
	andi.w	#$7F,d2
	addq.w	#1,d2
	bra.s	CopyBackwardReverseRun
FlushOutputBuffer					;Write the full ring buffer to vram
	movem.l	d0-d1/a0-a1,-(sp)
	move.w	d1,d0
	bne.w	.size
	move.w	#$100,d0				;full buffer
.size
	lsr.w	#1,d0					;bytes to words
	move.w	d3,d1					;vram address
	add.w	d0,d3
	add.w	d0,d3
	movea.l	a1,a0
	tst.l	(a4)
	beq.w	.dma
	movea.l	(a4),a1					;remap table
	jsr	(a5)						;remap
	bra.w	.done
.dma
	jsr	(a6)
.done
	movem.l	(sp)+,d0-d1/a0-a1
	rts
