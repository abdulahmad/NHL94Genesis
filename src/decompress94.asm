;	Graphics decompression (93G decompress93.asm): DecompressGraphics sends packed tiles to vram
;	through DecompressBytecode and its 256 byte ring buffer. Included at the end of video94.asm.

DecompressGraphicsWithRemap			;DecompressGraphics, then return 8 bytes past the call (remap table)
	move.l	(sp),(remapTablePtr).w
	bsr.w	DecompressGraphics
	addq.l	#8,(sp)					;skip the inline remap table
	rts
DecompressGraphicsPlain				;Clear remapTablePtr, fall into DecompressGraphics
	clr.l	(remapTablePtr).w
DecompressGraphics					;a2 = graphics data, d4 = start char. Returns d4 past the last char
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
	tst.l	(remapTablePtr).w
	beq.w	DoDMApro
	movea.l	(remapTablePtr).w,a1	;remap table
	bra.w	remap
.packed								;packed tiles
	andi.w	#$7FFF,d0				;tile count
	add.w	d0,d4
	bsr.w	DecompressBytecode
.done								;exit: restore the registers
	movem.l	(sp)+,d0-d1/a0-a6
	rts
DecompressBytecode					;Unpack a0 into the 256 byte ring buffer at decompbuffer. d1 = vram
									;address in (kept in d3; d1 then = buffer offset)
	movea.w	#(decompbuffer-M68K_RAM),a1
	movea.w	#(decompbuffer-M68K_RAM),a3	;unused by the handlers
	movea.w	#(remapTablePtr-M68K_RAM),a4
	movea.l	#remap,a5
	movea.l	#DoDMApro,a6
	movem.l	d0-d3/a0-a2,-(sp)
	move.w	d1,d3					;d3 = vram address
	clr.w	d1						;d1 = output buffer offset
	clr.w	d2						;scratch
.loop								;loop
	move.b	(a0)+,d0				;read opcode
	andi.w	#$F0,d0
	lsr.w	#3,d0					;upper nibble * 2
	lea	DecompressOpcodeTable(pc),a2
	move.w	0(a2,d0.w),d0
	jsr	0(a2,d0.w)
	bra.s	.loop
DecompressOpcodeTable				;DecompressBytecode handler offsets, one per opcode high nibble
	dc.w	Opcode_CopyLiteral-DecompressOpcodeTable	;0
	dc.w	Opcode_CopyLiteral-DecompressOpcodeTable	;1
	dc.w	Opcode_ClearBytes-DecompressOpcodeTable	;2
	dc.w	Opcode_FillBytes-DecompressOpcodeTable	;3
	dc.w	Opcode_CopyBackwardShort-DecompressOpcodeTable	;4
	dc.w	Opcode_CopyBackwardShort-DecompressOpcodeTable	;5
	dc.w	Opcode_CopyBackwardShort-DecompressOpcodeTable	;6
	dc.w	Opcode_CopyBackwardShort-DecompressOpcodeTable	;7
	dc.w	Opcode_CopyBackwardMedium-DecompressOpcodeTable	;8
	dc.w	Opcode_CopyBackwardLong-DecompressOpcodeTable	;9
	dc.w	Opcode_CopyBackwardExtended1-DecompressOpcodeTable	;A
	dc.w	Opcode_CopyBackwardExtended2-DecompressOpcodeTable	;B
	dc.w	Opcode_CopyBackwardReverseShort-DecompressOpcodeTable	;C
	dc.w	Opcode_CopyBackwardReverseShort-DecompressOpcodeTable	;D
	dc.w	Opcode_CopyBackwardReverseMedium-DecompressOpcodeTable	;E
	dc.w	Opcode_CopyBackwardReverseLong-DecompressOpcodeTable	;F
Opcode_CopyLiteral					;opcodes 0-1, copy (low 5 bits)+1 bytes from the data
	move.b	-1(a0),d0				;step back to the opcode byte just read
	andi.w	#$1F,d0
.loop								;copy each byte
	move.b	(a0)+,0(a1,d1.w)
	addq.b	#1,d1					;d1 is a byte index: wraps to 0 after 256 bytes
	bne.w	.next
	bsr.w	FlushOutputBuffer		;buffer full
.next								;loop the run
	dbf	d0,.loop
	rts
Opcode_ClearBytes					;opcode 2, write (low 4 bits)+1 zero bytes
	move.b	-1(a0),d0				;step back to the opcode byte just read
	andi.w	#$F,d0
.loop								;clear each byte
	clr.b	0(a1,d1.w)
	addq.b	#1,d1
	bne.w	.next
	bsr.w	FlushOutputBuffer		;buffer full
.next								;loop the run
	dbf	d0,.loop
	rts
Opcode_FillBytes					;opcode 3, write the next data byte (low 4 bits)+3 times
	move.b	-1(a0),d0				;step back to the opcode byte just read
	andi.w	#$F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
.loop								;write each byte
	move.b	d2,0(a1,d1.w)
	addq.b	#1,d1
	bne.w	.next
	bsr.w	FlushOutputBuffer		;buffer full
.next								;loop the run
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
.loop								;copy each byte
	move.b	0(a1,d2.w),0(a1,d1.w)
	addq.b	#1,d2
	addq.b	#1,d1
	bne.w	.next
	bsr.w	FlushOutputBuffer		;buffer full
.next								;loop the run
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
	asl.w	#8,d0					;first byte to the high half
	move.b	(a0),d0					;second byte as the low half
	lsr.w	#6,d0					;shift down 6
	andi.w	#$3F,d0					;mask 6 bits
	addq.w	#2,d0					;plus 2: copy distance
	move.b	(a0)+,d2				;second byte again, advance
	andi.w	#$3F,d2					;mask 6 bits
	addq.w	#1,d2					;plus 1: run length
	bra.s	CopyBackwardRun			;copy the run
Opcode_CopyBackwardExtended2		;opcode B
	move.b	-1(a0),d0				;step back to the opcode byte just read
	asl.w	#8,d0					;first byte to the high half
	move.b	(a0),d0					;second byte as the low half
	lsr.w	#5,d0					;shift down 5
	andi.w	#$7F,d0					;mask 7 bits
	addq.w	#2,d0					;plus 2: copy distance
	move.b	(a0)+,d2				;second byte again, advance
	andi.w	#$1F,d2					;mask 5 bits
	addq.w	#1,d2					;plus 1: run length
	bra.s	CopyBackwardRun			;copy the run
Opcode_CopyBackwardReverseShort		;opcodes C-D, copy backwards through the source
	move.b	-1(a0),d0				;step back to the opcode byte just read
	andi.w	#3,d0
	addq.w	#1,d0
	move.b	-1(a0),d2				;step back to the opcode byte just read
	lsr.w	#2,d2
	andi.w	#7,d2
	addq.w	#1,d2
CopyBackwardReverseRun				;shared reverse copy loop
	neg.b	d2						;negate the distance
	add.b	d1,d2					;plus the position
.loop								;copy each byte, reversed
	move.b	0(a1,d2.w),0(a1,d1.w)	;copy one byte from behind, reversed
	subq.b	#1,d2					;source goes back
	addq.b	#1,d1					;destination goes on
	bne.w	.next					;not wrapped: loop
	bsr.w	FlushOutputBuffer		;buffer full
.next								;loop the run
	dbf	d0,.loop					;loop for the run
	rts								;done
Opcode_CopyBackwardReverseMedium	;opcode E. Distance 0 is the end code
	move.b	-1(a0),d0				;step back to the opcode byte just read
	andi.w	#$F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
	bne.s	CopyBackwardReverseRun
	tst.w	d1						;end of data
	beq.w	.fin					;buffer empty
	bsr.w	FlushOutputBuffer
.fin								;all written
	addq.w	#4,sp					;drop the handler return: rts goes to DecompressBytecode's caller
	movem.l	(sp)+,d0-d3/a0-a2
	rts
Opcode_CopyBackwardReverseLong		;opcode F
	move.b	(a0),d0					;next byte
	asl.b	#1,d0					;shift left, top bit to carry
	move.b	-1(a0),d0				;step back to the opcode byte just read
	roxl.b	#1,d0					;rotate the carry in
	andi.w	#$1F,d0					;keep 5 bits
	addq.w	#2,d0					;plus 2: copy distance
	move.b	(a0)+,d2				;byte again, advance
	andi.w	#$7F,d2					;mask 7 bits
	addq.w	#1,d2					;plus 1: run length
	bra.s	CopyBackwardReverseRun	;copy the run reversed
FlushOutputBuffer					;Write d1 bytes (0 = 256) of the ring buffer to vram d3, advance d3
	movem.l	d0-d1/a0-a1,-(sp)
	move.w	d1,d0
	bne.w	.size
	move.w	#$100,d0				;full buffer
.size								;byte count
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
.dma								;a4 = 0
	jsr	(a6)
.done								;exit: restore the registers
	movem.l	(sp)+,d0-d1/a0-a1
	rts
