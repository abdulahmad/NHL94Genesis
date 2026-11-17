	include	segacd\hockey.inc
	include	macros\genesis.mac

DecompressGraphicsPlain	equ	$38958
DoDMApro	equ	$37762
FramerMap	equ	$47D10
LOAD	equ	$1B000
PeriodLabelTable	equ	$390E4
ThreeStars	equ	$BC000
VmMAP1	equ	$18D34
disflags	equ	$18D64
framercset	equ	$18D4E
move	equ	$2C9C8
print	equ	$38F80
printa	equ	$18D5C
printbig	equ	$3926A
printm	equ	$18D5E
printx	equ	$18D58
printy	equ	$18D5A
remap	equ	$36C14
sflags6	equ	$17F76
smallfontchars	equ	$18D42
swap	equ	$2779A
X_1BC14	equ	$1BC14
X_1C762	equ	$1C762
X_1D71E	equ	$1D71E
X_1DA34	equ	$1DA34
X_1DDF8	equ	$1DDF8
X_1DE92	equ	$1DE92
X_1DF14	equ	$1DF14
X_1DF26	equ	$1DF26
X_21EBE	equ	$21EBE

	org	$1D2D0

	dc.w	$00FF,$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6
	dc.w	$08B9,$0007,$00FF,$800F,$303C,$9001,$0C79,$0006
	dc.w	$0001,$8D36,$6700,$0006,$303C,$9003,$0839,$0007
	dc.w	$00FF,$800E,$66F6,$33C0,$00FF,$8022,$33FC,$000A
	dc.w	$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6
	dc.w	$08B9,$0007,$00FF,$800F,$303C,$8200,$1039,$0001
	dc.w	$8D34,$E408,$0200,$0038,$0839,$0007,$00FF,$800E
	dc.w	$66F6,$33C0,$00FF,$8022,$33FC,$000A,$00FF,$8020
	dc.w	$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$303C,$8400,$1039,$0001,$8D38,$EA08
	dc.w	$0839,$0007,$00FF,$800E,$66F6,$33C0,$00FF,$8022
	dc.w	$33FC,$000A,$00FF,$8020,$08F9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF
	dc.w	$800F,$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$66F6,$08B9,$0007,$00FF,$800F,$303C,$8300
	dc.w	$1039,$0001,$8D3C,$E408,$0200,$003E,$0839,$0007
	dc.w	$00FF,$800E,$66F6,$33C0,$00FF,$8022,$33FC,$000A
	dc.w	$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6
	dc.w	$08B9,$0007,$00FF,$800F,$303C,$8500,$1039,$0001
	dc.w	$8D32,$E208,$0839,$0007,$00FF,$800E,$66F6,$33C0
	dc.w	$00FF,$8022,$33FC,$000A,$00FF,$8020,$08F9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9
	dc.w	$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F
	dc.w	$303C,$8D00,$1039,$0001,$8D30,$E408,$0839,$0007
	dc.w	$00FF,$800E,$66F6,$33C0,$00FF,$8022,$33FC,$000A
	dc.w	$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6
	dc.w	$08B9,$0007,$00FF,$800F,$0839,$0007,$00FF,$800E
	dc.w	$66F6,$33FC,$9100,$00FF,$8022,$33FC,$000A,$00FF
	dc.w	$8020,$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$33FC,$9200,$00FF,$8022,$33FC,$000A,$00FF,$8020
	dc.w	$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$0839,$0007,$00FF,$800E,$66F6,$33FC
	dc.w	$8700,$00FF,$8022,$33FC,$000A,$00FF,$8020,$08F9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6
	dc.w	$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF
	dc.w	$800F,$0839,$0007,$00FF,$800E,$66F6,$33FC,$8B00
	dc.w	$00FF,$8022,$33FC,$000A,$00FF,$8020,$08F9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9
	dc.w	$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F
	dc.w	$0839,$0007,$00FF,$800E,$66F6,$23FC,$4000,$0010
	dc.w	$00FF,$8022,$33FC,$000B,$00FF,$8020,$08F9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9
	dc.w	$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F
	dc.w	$0839,$0007,$00FF,$800E,$66F6,$23FC,$0000,$0000
	dc.w	$00FF,$8022,$33FC,$000E,$00FF,$8020,$08F9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9
	dc.w	$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F
	dc.w	$33DF,$0001,$8D64,$2F0E,$2C79,$0001,$9360,$4A5E
	dc.w	$670A,$08F9,$0005,$00FF,$800F,$6008,$08B9,$0005
	dc.w	$00FF,$800F,$23CE,$0001,$9360,$2C5F,$4E75,$207C
	dc.w	$00C0,$0000,$E580,$E448,$0040,$4000,$4840,$0240
	dc.w	$0003,$0839,$0007,$00FF,$800E,$66F6,$23C0,$00FF
	dc.w	$8022,$33FC,$000B,$00FF,$8020,$08F9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007
	dc.w	$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F,$4E75
	dc.w	$207C,$00C0,$0000,$E580,$E448,$0040,$4000,$4840
	dc.w	$0240,$0003,$0839,$0004,$00FF,$800E,$66F6,$33FC
	dc.w	$0030,$00FF,$8026,$23C0,$00FF,$8028,$08F9,$0003
	dc.w	$00FF,$800F,$0839,$0003,$00FF,$800E,$67F6,$08F9
	dc.w	$0004,$00FF,$800F,$08B9,$0003,$00FF,$800F,$0839
	dc.w	$0003,$00FF,$800E,$66F6,$08B9,$0004,$00FF,$800F
	dc.w	$4E75,$2F0E,$2C79,$0001,$9360,$0839,$0005,$00FF
	dc.w	$800F,$6706,$3D3C,$0001,$6004
dobitmap
	move.w	#$0,-(a6)
	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	(printy).l,-(sp)
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movem.l	d0-d3/d5-d6/a0-a3,-(sp)
	move.w	d1,d6
	movea.l	#$BBCB0,a3
	bra.w	.l1D848
.l1D832	move.b	(a0,d0.w),(a3,d0.w)
	dbra	d0,.l1D832
.l1D83C	adda.l	#$20,a0
	adda.l	#$20,a3
.l1D848	moveq	#$1F,d0
	lsr.w	#$1,d5
	bcs.w	.l1D832
	bne.w	.l1D83C
	move.w	(printa).l,d5
	andi.w	#$F800,d5
	move.w	$E(sp),d2
	subi.w	#$1,d2
.l1D866	bsr.w	xyVmMap
	move.w	d6,d0
	mulu.w	(a1),d0
	add.w	$2(sp),d0
	asl.w	#$1,d0
	move.w	$A(sp),d1
	subi.w	#$1,d1
	move.w	d1,(ThreeStars).l
	lea.l	$BC002.l,a0
.l1D888	move.w	$4(a1,d0.w),d3
	add.w	d4,d3
	eor.w	d5,d3
	move.w	d3,(a0)+
	addi.w	#$2,d0
	dbra	d1,.l1D888
.l1D89A	btst	#$7,$FF800E.l
	bne.b	.l1D89A
	move.w	#$21,$FF8020.l
	jsr	$222C2.l
	bset	#$6,$FF800F.l
	jsr	$22268.l
.l1D8C0	btst	#$6,$FF800E.l
	beq.b	.l1D8C0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1D8DA	btst	#$6,$FF800E.l
	bne.b	.l1D8DA
	bclr	#$7,$FF800F.l
	addi.w	#$1,(printy).l
	addi.w	#$1,d6
	dbra	d2,.l1D866
	btst	#$0,(sflags6).l
	bne.w	.l1D90E
	jsr	(DecompressGraphicsPlain).l
.l1D90E	movem.l	(sp)+,d0-d3/d5-d6/a0-a3
	move.w	(sp)+,(disflags).l
	move.w	(sp)+,(printy).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	dc.w	$670A
	bset	#$5,$FF800F.l
	dc.w	$6008
.l1D934	bclr	#$5,$FF800F.l
.l1D93C	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
	move.l	(sp),$18AE4.l
	bsr.w	.l1D95E
	addi.l	#$8,(sp)
	rts
	clr.l	$18AE4.l
.l1D95E	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	dc.w	$6706
	move.w	#$1,-(a6)
	dc.w	$6004
.l1D976	move.w	#$0,-(a6)
.l1D97A	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movem.l	d0-d1/a0-a6,-(sp)
	moveq	#$0,d0
	moveq	#$0,d1
	movea.l	a2,a0
	move.w	d4,d1
	asl.w	#$5,d1
	move.w	(a0)+,d0
	beq.w	.l1D9CA
	bmi.w	.l1D9C0
	add.w	d0,d4
	asl.w	#$4,d0
	pea.l	$389CA.l
	tst.l	$18AE4.l
	beq.w	X_1C762
	movea.l	$18AE4.l,a1
	bra.w	X_1BC14
.l1D9C0	andi.w	#$7FFF,d0
	add.w	d0,d4
	bsr.w	DecompressBytecode
.l1D9CA	movem.l	(sp)+,d0-d1/a0-a6
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	dc.w	$670A
	bset	#$5,$FF800F.l
	dc.w	$6008
.l1D9E4	bclr	#$5,$FF800F.l
.l1D9EC	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
DecompressBytecode						;Unpack a0 into the 256 byte ring buffer at decompbuffer. d1 = vram
									;address in (kept in d3; d1 then = buffer offset)
	movea.l	#ThreeStars,a1
	movea.l	#ThreeStars,a3		;unused by the handlers
	movea.l	#$18AE4,a4
	movea.l	#remap,a5
	movea.l	#DoDMApro,a6
	movem.l	d0-d3/a0-a2,-(sp)
	move.w	d1,d3		;d3 = vram address
	clr.w	d1		;d1 = output buffer offset
	clr.w	d2		;scratch
.loop	move.b	(a0)+,d0		;read opcode
	andi.w	#$F0,d0
	lsr.w	#$3,d0		;upper nibble * 2
	lea.l	X_1DA34(pc),a2
	move.w	(a2,d0.w),d0
	jsr	(a2,d0.w)
	bra.b	.loop
	dc.w	$0020,$0020,$003C,$0058,$0078,$0078,$0078,$0078
	dc.w	$00AA,$00B8,$00D2,$00EC,$0106,$0106,$0138,$0158
Opcode_CopyLiteral						;opcodes 0-1, copy (low 5 bits)+1 bytes from the data
	move.b	-$1(a0),d0		;step back to the opcode byte just read
	andi.w	#$1F,d0
.loop	move.b	(a0)+,(a1,d1.w)
	addq.b	#$1,d1		;d1 is a byte index: wraps to 0 after 256 bytes
	bne.w	.l1DA6A
	bsr.w	FlushOutputBuffer		;buffer full
.l1DA6A	dbra	d0,.loop
	rts
Opcode_ClearBytes						;opcode 2, write (low 4 bits)+1 zero bytes
	move.b	-$1(a0),d0		;step back to the opcode byte just read
	andi.w	#$F,d0
.loop	clr.b	(a1,d1.w)
	addq.b	#$1,d1
	bne.w	.l1DA86
	bsr.w	FlushOutputBuffer		;buffer full
.l1DA86	dbra	d0,.loop
	rts
Opcode_FillBytes						;opcode 3, write the next data byte (low 4 bits)+3 times
	move.b	-$1(a0),d0		;step back to the opcode byte just read
	andi.w	#$F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
.loop	move.b	d2,(a1,d1.w)
	addq.b	#$1,d1
	bne.w	.l1DAA6
	bsr.w	FlushOutputBuffer		;buffer full
.l1DAA6	dbra	d0,.loop
	rts
Opcode_CopyBackwardShort						;opcodes 4-7, copy from back in the output buffer
	move.b	-$1(a0),d0		;step back to the opcode byte just read
	andi.w	#$7,d0
	addq.w	#$1,d0		;count-1
	move.b	-$1(a0),d2		;step back to the opcode byte just read
	lsr.w	#$3,d2
	andi.w	#$7,d2
	addq.w	#$1,d2		;distance
CopyBackwardRun						;shared copy loop, d0 = count-1, d2 = distance back
	neg.b	d2
	add.b	d1,d2		;source offset in the ring buffer
.loop	move.b	(a1,d2.w),(a1,d1.w)
	addq.b	#$1,d2
	addq.b	#$1,d1
	bne.w	.l1DAD8
	bsr.w	FlushOutputBuffer		;buffer full
.l1DAD8	dbra	d0,.loop
	rts
Opcode_CopyBackwardMedium						;opcode 8
	move.b	-$1(a0),d0		;step back to the opcode byte just read
	andi.w	#$F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	bra.b	CopyBackwardRun
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
	move.b	-$1(a0),d0
	asl.w	#$8,d0
	dc.w	$1010,$EA48,$0240,$007F,$5440,$1418,$0242,$001F
	dc.w	$5242,$6088,$1028,$FFFF,$0240,$0003,$5240,$1428
	dc.w	$FFFF,$E44A,$0242,$0007,$5242
CopyBackwardReverseRun						;shared reverse copy loop
	neg.b	d2
	add.b	d1,d2
.loop	move.b	(a1,d2.w),(a1,d1.w)
	subq.b	#$1,d2
	addq.b	#$1,d1
	bne.w	.l1DB66
	bsr.w	FlushOutputBuffer		;buffer full
.l1DB66	dbra	d0,.loop
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
xyVmMap
	movem.l	d0-d2,-(sp)
	move.w	(printx).l,d0
	move.w	(printy).l,d1
	movea.l	#VmMAP1,a0
	adda.w	(printm).l,a0
	move.w	$2(a0),d2
	asl.w	d2,d1
	add.w	d1,d0
	asl.w	#$1,d0
	add.w	(a0),d0
	bsr.w	X_1D71E
	movem.l	(sp)+,d0-d2
	rts
eraser
	movem.l	d0-d2/a0,-(sp)
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movem.w	d0-d1,-(sp)
.l1DC1C	bsr.w	xyVmMap
	move.w	(sp),d0
	subi.w	#$1,d0
.l1DC26	btst	#$7,$FF800E.l
	bne.b	.l1DC26
	move.w	d2,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
.l1DC46	btst	#$6,$FF800E.l
	beq.b	.l1DC46
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1DC60	btst	#$6,$FF800E.l
	bne.b	.l1DC60
	bclr	#$7,$FF800F.l
	dbra	d0,.l1DC26
	addi.w	#$1,(printy).l
	andi.w	#$1F,(printy).l
	subi.w	#$1,$2(sp)
	bne.w	.l1DC1C
	adda.w	#$4,sp
	move.w	(sp)+,(disflags).l
	movem.l	(sp)+,d0-d2/a0
	rts
Framer
	movem.l	d0-d4/a0-a1,-(sp)
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movem.w	d0-d1,-(sp)
	move.w	(printa).l,d2
	add.w	(framercset).l,d2
	movea.l	(FramerMap).l,a1
	adda.l	$4(a1),a1
	adda.w	#$4,a1
	clr.w	d4
	bsr.w	.l1DD06
	subi.w	#$3,$2(sp)
.l1DCDC	bsr.w	.l1DD06
	subi.w	#$6,d4
	subi.w	#$1,$2(sp)
	bpl.w	.l1DCDC
	addi.w	#$6,d4
	bsr.w	.l1DD06
	adda.w	#$4,sp
	move.w	(sp)+,(disflags).l
	movem.l	(sp)+,d0-d4/a0-a1
	rts
.l1DD06	bsr.w	xyVmMap
	addi.w	#$1,(printy).l
	bsr.w	.l1DD38
	addi.w	#$2,d4
	move.w	$4(sp),d0
	subi.w	#$3,d0
.l1DD22	bsr.w	.l1DD38
	dbra	d0,.l1DD22
	addi.w	#$2,d4
	bsr.w	.l1DD38
	addi.w	#$2,d4
	rts
.l1DD38	move.w	(a1,d4.w),d3
	add.w	d2,d3
.l1DD3E	btst	#$7,$FF800E.l
	bne.b	.l1DD3E
	dc.w	$33C3,$00FF,$8022,$33FC,$000D,$00FF,$8020,$08F9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6
	dc.w	$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF
	dc.w	$800F,$4E75
printsmallz
	move.l	a1,-(sp)
	movea.l	$4(sp),a1
	bsr.w	.l1DD9E
	move.l	a1,$4(sp)
	movea.l	(sp)+,a1
	rts
.l1DD9E	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movem.l	d0-d3/a0/a2-a3,-(sp)
	movea.l	#smallfontchars,a3
	btst	#$3,(sflags6).l
	beq.w	.l1DDC8
	movea.l	#$17EA2,a3
.l1DDC8	bsr.w	xyVmMap
	move.w	(printa).l,d2
	move.w	(a1)+,d3
	subi.w	#$2,d3
	bra.w	X_1DE92
	move.b	(a1)+,d0
	ext.w	d0
	bgt.w	X_1DDF8
	dc.w	$4440,$E540,$247C,$0003,$8EB2,$2472,$0000,$4E92
	dc.w	$6000,$009C,$0C00,$0040,$6600,$000A,$303C,$07FF
	dc.w	$6000,$0036,$0C00,$005E,$6700,$0094,$E340,$2479
	dc.w	$0004,$7D3C,$0839,$0003,$0001,$7F76,$6700,$0008
	dc.w	$2479,$0004,$7D70,$D5EA,$0004,$3032,$0004,$3239
	dc.w	$0001,$8D60,$D073,$1000,$D042,$0839,$0007,$00FF
	dc.w	$800E,$66F6,$33C0,$00FF,$8022,$33FC,$000D,$00FF
	dc.w	$8020,$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$0679,$0001,$0001,$8D58,$51CB
	dc.w	$FF48,$4CDF,$0D0F,$33DF,$0001,$8D64,$4E75,$0679
	dc.w	$0001,$0001,$8D58,$6100,$FD28,$6000,$FFE2
ControlCode_SetMapAndPosition
	dc.w	$0003,$C000
	dc.w	$0003,$8EE6
	dc.w	$0003,$8F00
	dc.w	$0003,$8F14
	dc.w	$0003,$8F26
	dc.w	$0003,$8F38
	dc.w	$0003,$8F4A
	dc.w	$0003,$8F5C
	dc.w	$0003,$8ED6
	bsr.w	.l1DF00
	bsr.w	.l1DEE6
	bsr.w	X_1DF14
	bra.w	X_1DF26
.l1DEE6	move.b	(a1)+,d0
	subi.w	#$1,d3
	andi.w	#$3,d0
	asl.w	#$2,d0
	subi.w	#$4,d0
	move.w	d0,(printm).l
	bra.w	xyVmMap
.l1DF00	move.b	(a1)+,d2
	dc.w	$0242,$0007,$0443,$0001,$E65A,$33C2,$0001,$8D5C
	dc.w	$4E75,$4240,$1019,$0443,$0001,$33C0,$0001,$8D58
	dc.w	$6000,$FCB0,$4240,$1019,$0443,$0001,$33C0,$0001
	dc.w	$8D5A,$6000,$FC9E,$1019,$4880,$0443,$0001,$D179
	dc.w	$0001,$8D58,$6000,$FC8C,$1019,$4880,$0443,$0001
	dc.w	$D179,$0001,$8D5A,$6000,$FC7A,$4240,$1019,$0443
	dc.w	$0001,$E340,$33C0,$0001,$8D60,$4E75,$2F09,$226F
	dc.w	$0004,$6100,$000A,$2F49,$0004,$225F,$4E75,$3F39
	dc.w	$0001,$8D64,$08F9,$0002,$0001,$8D64,$48E7,$F0A0
	dc.w	$6100,$FC40,$3439,$0001,$8D5C,$3619,$0443,$0002
	dc.w	$6000,$00FC,$1019,$6700,$00F6,$4880,$6A00,$0044
	dc.w	$4440,$3400,$E142,$E342,$0242,$F800,$33C2,$0001
	dc.w	$8D5C,$0240,$0003,$E540,$0440,$0004,$33C0,$0001
	dc.w	$8D5E,$1019,$4880,$33C0,$0001,$8D58,$1219,$4881
	dc.w	$33C1,$0001,$8D5A,$6100,$FBEA,$0443,$0002,$6000
	dc.w	$00AE,$0C00,$0040,$6600,$000A,$303C,$07FF,$6000
	dc.w	$0048,$0C00,$005E,$6700,$00A6,$E340,$2479,$0004
	dc.w	$7D3C,$0839,$0003,$0001,$7F76,$6700,$0008,$2479
	dc.w	$0004,$7D70,$D5EA,$0004,$3032,$0004,$0839,$0003
	dc.w	$0001,$7F76,$6700,$000C,$D079,$0001,$7EA2,$6000
	dc.w	$0008,$D079,$0001,$8D42,$D042,$0839,$0007,$00FF
	dc.w	$800E,$66F6,$33C0,$00FF,$8022,$33FC,$000D,$00FF
	dc.w	$8020,$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$0679,$0001,$0001,$8D58,$51CB
	dc.w	$FF04,$4CDF,$050F,$33DF,$0001,$8D64,$4E75,$0679
	dc.w	$0001,$0001,$8D58,$6100,$FB1A,$6000,$FFE2
FormatAndPrintTime
	swap	d0
	clr.w	d0
	rol.l	#$2,d0
	movea.l	#PeriodLabelTable,a1
	bsr.w	X_21EBE
	addi.w	#$2,(printx).l
	swap	d0
	lsr.w	#$2,d0
	bsr.w	PushTime
	bra.w	print-LOAD
	dc.w	$0004,$2031,$0004,$2032,$0004,$2033,$0004,$4F54
PushTime
	movea.l	#$17F10,a1
	move.l	d0,-(sp)
	move.l	a1,-(sp)
	ext.l	d0
	divu.w	#$A,d0
	swap	d0
	addi.w	#$30,d0
	move.b	d0,-(a1)
	swap	d0
	ext.l	d0
	divu.w	#$6,d0
	swap	d0
	addi.w	#$30,d0
	move.b	d0,-(a1)
	swap	d0
	move.b	#$3A,-(a1)
	ext.l	d0
	divu.w	#$A,d0
	swap	d0
	addi.w	#$30,d0
	move.b	d0,-(a1)
	swap	d0
	move.b	#$20,-(a1)
	tst.w	d0
	beq.w	.l1E142
	addi.w	#$30,d0
	move.b	d0,(a1)
.l1E142	move.l	(sp)+,d0
	sub.l	a1,d0
	addi.w	#$2,d0
	btst	#$0,d0
	beq.w	.l1E158
	clr.b	-(a1)
	addi.w	#$1,d0
.l1E158	move.w	d0,-(a1)
	move.l	(sp)+,d0
	rts
PushNumber
	movea.l	#$17F5E,a1
	move.l	d0,-(sp)
	move.l	a1,-(sp)
.l1E168	ext.l	d0
	divu.w	#$A,d0
	swap	d0
	addi.w	#$30,d0
	move.b	d0,-(a1)
	swap	d0
	tst.w	d0
	bne.w	.l1E168
	move.l	(sp)+,d0
	sub.l	a1,d0
	addi.w	#$2,d0
	btst	#$0,d0
	beq.w	.l1E194
	clr.b	-(a1)
	addi.w	#$1,d0
.l1E194	move.w	d0,-(a1)
	move.l	(sp)+,d0
	rts
PushNumberWidth
	movem.l	d0-d3,-(sp)
	movea.l	#$17F58,a1
	moveq	#$1,d2
	sub.w	d2,d1
	bra.w	.l1E1B0
.l1E1AC	mulu.w	#$A,d2
.l1E1B0	dbra	d1,.l1E1AC
	moveq	#$20,d3
.l1E1B6	ext.l	d0
	divu.w	d2,d0
	bne.w	.l1E1CC
	cmpi.w	#$1,d2
	beq.w	.l1E1CC
	move.w	d3,d0
	bra.w	.l1E1D0
.l1E1CC	moveq	#$30,d3
	add.w	d3,d0
.l1E1D0	move.b	d0,(a1)+
	swap	d0
	divu.w	#$A,d2
	bne.w	.l1E1B6
	move.l	a1,d0
	subi.l	#$17F56,d0
	btst	#$0,d0
	beq.w	.l1E1F2
	clr.b	(a1)+
	addi.w	#$1,d0
.l1E1F2	movea.l	#$17F56,a1
	move.w	d0,(a1)
	movem.l	(sp)+,d0-d3
	rts
	dc.w	$225F,$6100,$0004,$4ED1
appstring
	movem.l	d0/a0,-(sp)
	lea.l	$2(a3),a0
	move.w	(a3),d0
	subi.w	#$3,d0
	bmi.w	.l1E224
.l1E21A	adda.w	#$1,a0
	tst.b	(a0)
	dbeq	d0,.l1E21A
.l1E224	move.w	(a1)+,d0
	subi.w	#$3,d0
	bmi.w	.l1E252
.l1E22E	move.b	(a1)+,(a0)+
	bne.w	.l1E238
	suba.w	#$1,a0
.l1E238	dbra	d0,.l1E22E
	move.l	a0,d0
	btst	#$0,d0
	beq.w	.l1E24E
	clr.b	(a0)+
	addi.l	#$1,d0
.l1E24E	sub.l	a3,d0
	move.w	d0,(a3)
.l1E252	movem.l	(sp)+,d0/a0
	rts
printbigz
	move.l	a1,-(sp)
	movea.l	$4(sp),a1
	bsr.w	printbig-LOAD
	move.l	a1,$4(sp)
	movea.l	(sp)+,a1
	rts
