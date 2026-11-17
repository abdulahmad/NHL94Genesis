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
	beq.w	.next		;buffer empty
	bsr.w	FlushOutputBuffer
.next	addq.w	#$4,sp		;drop the handler return: rts goes to DecompressBytecode's caller
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
	bne.w	.next
	move.w	#$100,d0		;full buffer
.next	lsr.w	#$1,d0		;bytes to words
	move.w	d3,d1		;vram address
	add.w	d0,d3
	add.w	d0,d3
	movea.l	a1,a0
	tst.l	(a4)
	beq.w	.next2
	movea.l	(a4),a1		;remap table
	jsr	(a5)		;remap
	bra.w	.next3
.next2	jsr	(a6)
.next3	movem.l	(sp)+,d0-d1/a0-a1
	rts
xyVmMap						;use printx/y/m to set vram address. Returns a0 = Vdata.
	
	movem.l	d0-d2,-(sp)
	move.w	(printx).l,d0
	move.w	(printy).l,d1
	movea.l	#VmMAP1,a0
	adda.w	$18D5E.l,a0
	move.w	$2(a0),d2
	asl.w	d2,d1
	add.w	d1,d0
	asl.w	#$1,d0
	add.w	(a0),d0
	bsr.w	SetVramWriteAddr1
	movem.l	(sp)+,d0-d2
	rts
eraser						;fill rectangle with char. d0/d1 = x/y size of rectangle, d2 = char word
	
	movem.l	d0-d2/a0,-(sp)
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movem.w	d0-d1,-(sp)
.1	bsr.w	xyVmMap
	move.w	(sp),d0
	subi.w	#$1,d0
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	d2,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	dbra	d0,.loop
	addi.w	#$1,(printy).l
	andi.w	#$1F,(printy).l
	subi.w	#$1,$2(sp)
	bne.w	.1
	adda.w	#$4,sp
	move.w	(sp)+,(disflags).l
	movem.l	(sp)+,d0-d2/a0
	rts
Framer						;frame and fill (uses framer.map graphics and assums tiles are already
	
	
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
	bsr.w	.tbline
	subi.w	#$3,$2(sp)
.mtop	bsr.w	.tbline
	subi.w	#$6,d4
	subi.w	#$1,$2(sp)
	bpl.w	.mtop
	addi.w	#$6,d4
	bsr.w	.tbline
	adda.w	#$4,sp
	move.w	(sp)+,(disflags).l
	movem.l	(sp)+,d0-d4/a0-a1
	rts
.tbline	bsr.w	xyVmMap
	addi.w	#$1,(printy).l
	bsr.w	.setter
	addi.w	#$2,d4
	move.w	$4(sp),d0
	subi.w	#$3,d0
.tblp	bsr.w	.setter
	dbra	d0,.tblp
	addi.w	#$2,d4
	bsr.w	.setter
	addi.w	#$2,d4
	rts
.setter	move.w	(a1,d4.w),d3
	add.w	d2,d3
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	d3,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	rts
printsmallz						;String macro follows the call
	move.l	a1,-(sp)
	movea.l	$4(sp),a1
	bsr.w	printsmall
	move.l	a1,$4(sp)
	movea.l	(sp)+,a1
	rts
printsmall						;Print string macro a1 at printx/y/m with printa; uses the setup font
	
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movem.l	d0-d3/a0/a2-a3,-(sp)
	movea.l	#$18D42,a3
	btst	#$3,(sflags6).l
	beq.w	.start
	movea.l	#$17EA2,a3
.start	bsr.w	xyVmMap
	move.w	(printa).l,d2
	move.w	(a1)+,d3
	subi.w	#$2,d3
	bra.w	.loop4
.0	move.b	(a1)+,d0
	ext.w	d0
	bgt.w	.nocom
	neg.w	d0
	asl.w	#$2,d0
	movea.l	#$38EB2,a2
	movea.l	(a2,d0.w),a2
	jsr	(a2)
	bra.w	.loop4
.nocom	cmpi.b	#$40,d0
	bne.w	.noblank
	move.w	#$7FF,d0
	bra.w	.p
.noblank	cmpi.b	#$5E,d0
	beq.w	.skip
	asl.w	#$1,d0
	movea.l	(SmallFontMap).l,a2
	btst	#$3,(sflags6).l
	beq.w	.4
	movea.l	$47D70.l,a2
.4	adda.l	$4(a2),a2
	move.w	$4(a2,d0.w),d0
	move.w	(printfontset).l,d1
	add.w	(a3,d1.w),d0
.p	add.w	d2,d0
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	addi.w	#$1,(printx).l
.loop4	dbra	d3,.0
	movem.l	(sp)+,d0-d3/a0/a2-a3
	move.w	(sp)+,(disflags).l
	rts
.skip	addi.w	#$1,(printx).l
	bsr.w	xyVmMap
	bra.w	.loop4
ControlCode_SetMapAndPosition						;control code -8, next 4 bytes = attribute, map, x, y
ControlCode_SetMapAndPositionTbl1	dc.w	$0003,$C000
	dc.w	$0003,$8EE6
	dc.w	$0003,$8F00
	dc.w	$0003,$8F14
	dc.w	$0003,$8F26
	dc.w	$0003,$8F38
	dc.w	$0003,$8F4A
	dc.w	$0003,$8F5C
	dc.w	$0003,$8ED6
	bsr.w	.next2
	bsr.w	.next
	bsr.w	.next3
	bra.w	.next4
.next	move.b	(a1)+,d0
	subi.w	#$1,d3
	andi.w	#$3,d0
	asl.w	#$2,d0
	subi.w	#$4,d0
	move.w	d0,$18D5E.l
	bra.w	xyVmMap
.next2	move.b	(a1)+,d2
	andi.w	#$7,d2
	subi.w	#$1,d3
	ror.w	#$3,d2
	move.w	d2,(printa).l
	rts
.next3	clr.w	d0
	move.b	(a1)+,d0
	subi.w	#$1,d3
	move.w	d0,(printx).l
	bra.w	xyVmMap
.next4	clr.w	d0
	move.b	(a1)+,d0
	subi.w	#$1,d3
	move.w	d0,(printy).l
	bra.w	xyVmMap
	dc.w	$1019,$4880,$0443,$0001,$D179,$0001,$8D58,$6000
	dc.w	$FC8C,$1019,$4880,$0443,$0001,$D179,$0001,$8D5A
	dc.w	$6000,$FC7A,$4240,$1019,$0443,$0001,$E340,$33C0
	dc.w	$0001,$8D60,$4E75
printz						;print the String that follows the bsr/jsr to this routine, then return
	
	move.l	a1,-(sp)
	movea.l	$4(sp),a1
	bsr.w	print
	move.l	a1,$4(sp)
	movea.l	(sp)+,a1
	rts
print						;a1 = string macro, printx/y = x/y cordinate on map for printing, printm =
	
	
	
	
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	xyVmMap
	move.w	(printa).l,d2
	move.w	(a1)+,d3
	subi.w	#$2,d3
	bra.w	.loop4
.0	move.b	(a1)+,d0
	beq.w	.loop4
	ext.w	d0
	bpl.w	.nocom
	neg.w	d0
	move.w	d0,d2
	asl.w	#$8,d2
	asl.w	#$1,d2
	andi.w	#$F800,d2
	move.w	d2,(printa).l
	andi.w	#$3,d0
	asl.w	#$2,d0
	subi.w	#$4,d0
	move.w	d0,$18D5E.l
	move.b	(a1)+,d0
	ext.w	d0
	move.w	d0,(printx).l
	move.b	(a1)+,d1
	ext.w	d1
	move.w	d1,(printy).l
	bsr.w	xyVmMap
	subi.w	#$2,d3
	bra.w	.loop4
.nocom	cmpi.b	#$40,d0
	bne.w	.noblank
	move.w	#$7FF,d0
	bra.w	.next2
.noblank	cmpi.b	#$5E,d0
	beq.w	.skip
	asl.w	#$1,d0
	movea.l	(SmallFontMap).l,a2
	btst	#$3,(sflags6).l
	beq.w	.2
	movea.l	$47D70.l,a2
.2	adda.l	$4(a2),a2
	move.w	$4(a2,d0.w),d0
	btst	#$3,(sflags6).l
	beq.w	.next
	add.w	$17EA2.l,d0
	bra.w	.next2
.next	add.w	$18D42.l,d0
.next2	add.w	d2,d0
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	addi.w	#$1,(printx).l
.loop4	dbra	d3,.0
	movem.l	(sp)+,d0-d3/a0/a2
	move.w	(sp)+,(disflags).l
	rts
.skip	addi.w	#$1,(printx).l
	bsr.w	xyVmMap
	bra.w	.loop4
FormatAndPrintTime						;d0 bits 14-15 = period, bits 0-13 = seconds
	swap	d0
	clr.w	d0
	rol.l	#$2,d0
	movea.l	#$390E4,a1
	bsr.w	PrintTickerEntry
	addi.w	#$2,(printx).l
	swap	d0
	lsr.w	#$2,d0
	bsr.w	PushTime
	bra.w	print
FormatAndPrintTimeTbl1	dc.w	$0004,$2031,$0004,$2032,$0004,$2033,$0004,$4F54
PushTime						;convert d0 into string format of minutes:seconds. Return a1 = string.
	
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
	beq.w	.noz
	addi.w	#$30,d0
	move.b	d0,(a1)
.noz	move.l	(sp)+,d0
	sub.l	a1,d0
	addi.w	#$2,d0
	btst	#$0,d0
	beq.w	.1
	clr.b	-(a1)
	addi.w	#$1,d0
.1	move.w	d0,-(a1)
	move.l	(sp)+,d0
	rts
PushNumber						;convert d0 into string format of base 10 number, no leading zeros. Return
	
	movea.l	#$17F5E,a1
	move.l	d0,-(sp)
	move.l	a1,-(sp)
.0	ext.l	d0
	divu.w	#$A,d0
	swap	d0
	addi.w	#$30,d0
	move.b	d0,-(a1)
	swap	d0
	tst.w	d0
	bne.w	.0
	move.l	(sp)+,d0
	sub.l	a1,d0
	addi.w	#$2,d0
	btst	#$0,d0
	beq.w	.1
	clr.b	-(a1)
	addi.w	#$1,d0
.1	move.w	d0,-(a1)
	move.l	(sp)+,d0
	rts
PushNumberWidth						;right-justified number
	movem.l	d0-d3,-(sp)
	movea.l	#$17F58,a1
	moveq	#$1,d2
	sub.w	d2,d1
	bra.w	.next
.mul	mulu.w	#$A,d2
.next	dbra	d1,.mul
	moveq	#$20,d3
.loop	ext.l	d0
	divu.w	d2,d0
	bne.w	.0
	cmpi.w	#$1,d2
	beq.w	.0
	move.w	d3,d0
	bra.w	.put
.0	moveq	#$30,d3
	add.w	d3,d0
.put	move.b	d0,(a1)+
	swap	d0
	divu.w	#$A,d2
	bne.w	.loop
	move.l	a1,d0
	subi.l	#$17F56,d0
	btst	#$0,d0
	beq.w	.00
	clr.b	(a1)+
	addi.w	#$1,d0
.00	movea.l	#$17F56,a1
	move.w	d0,(a1)
	movem.l	(sp)+,d0-d3
	rts
; Appends the number string, then returns through a1.
PushNumberWidthString
	movea.l	(sp)+,a1
	bsr.w	appstring
	jmp	(a1)
appstring						;append string a1 to string a3
	movem.l	d0/a0,-(sp)
	lea.l	$2(a3),a0
	move.w	(a3),d0
	subi.w	#$3,d0
	bmi.w	.1
.0	adda.w	#$1,a0
	tst.b	(a0)
	dbeq	d0,.0
.1	move.w	(a1)+,d0
	subi.w	#$3,d0
	bmi.w	.next2
.2	move.b	(a1)+,(a0)+
	bne.w	.next
	suba.w	#$1,a0
.next	dbra	d0,.2
	move.l	a0,d0
	btst	#$0,d0
	beq.w	.4
	clr.b	(a0)+
	addi.l	#$1,d0
.4	sub.l	a3,d0
	move.w	d0,(a3)
.next2	movem.l	(sp)+,d0/a0
	rts
printbigz						;String macro follows the call
	move.l	a1,-(sp)
	movea.l	$4(sp),a1
	bsr.w	printbig
	move.l	a1,$4(sp)
	movea.l	(sp)+,a1
	rts
printbig						;same as print, only use bigfont.map graphics. a1 = string macro, printx/y
	
	
	
	
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movem.l	d0-d7/a0/a2,-(sp)
	move.w	(printx).l,d4
	move.w	(printy).l,d5
	move.w	(printa).l,d6
	add.w	(BigFontchars).l,d6
	move.w	(a1)+,d3
	subi.w	#$2,d3
	bra.w	.next
.0	move.b	(a1)+,d0
	beq.w	.next
	ext.w	d0
	bpl.w	.nocom
	neg.w	d0
	move.w	d0,d6
	asl.w	#$8,d6
	asl.w	#$1,d6
	andi.w	#$F800,d6
	move.w	d6,(printa).l
	add.w	(BigFontchars).l,d6
	andi.w	#$3,d0
	asl.w	#$2,d0
	subi.w	#$4,d0
	move.w	d0,$18D5E.l
	move.b	(a1)+,d4
	ext.w	d4
	move.w	d4,(printx).l
	move.b	(a1)+,d5
	ext.w	d5
	move.w	d5,(printy).l
	subi.w	#$2,d3
	bra.w	.next
.nocom	cmpi.b	#$61,d0
	blt.w	.2
	cmpi.b	#$7A,d0
	bgt.w	.2
	addi.b	#$E0,d0
.2	move.w	d3,-(sp)
	bsr.w	PrintBigChar
	move.w	(sp)+,d3
.next	dbra	d3,.0
	move.w	d4,(printx).l
	move.w	d5,(printy).l
	movem.l	(sp)+,d0-d7/a0/a2
	move.w	(sp)+,(disflags).l
	rts
PrintBigChar						;print big font char d0 (ascii) through bfasciicon
	subi.w	#$20,d0
	movea.l	#$419BA,a0
	moveq	#$1,d2
	move.b	(a0,d0.w),d1
	ext.w	d1
	bpl.w	.0
	neg.w	d1
	clr.w	d2
.0	asl.w	#$1,d1
	movea.l	(BigFontMap).l,a0
	adda.l	$4(a0),a0
.loop	move.w	$4(a0,d1.w),d3
	bsr.w	PutBigTile
	move.w	(a0),d7
	asl.w	#$1,d7
	add.w	d7,d1
	move.w	$4(a0,d1.w),d3
	sub.w	d7,d1
	addq.w	#$1,d5
	bsr.w	PutBigTile
	subq.w	#$1,d5
	addq.w	#$1,d4
	addq.w	#$2,d1
	dbra	d2,.loop
	rts
PutBigTile						;write one big font tile to the map at printx / printy
	add.w	d6,d3
	movem.l	d1/a0,-(sp)
	move.w	d5,d0
	movea.l	#VmMAP1,a0
	adda.w	$18D5E.l,a0
	move.w	$2(a0),d1
	asl.w	d1,d0
	add.w	d4,d0
	asl.w	#$1,d0
	add.w	(a0),d0
	bsr.w	SetVramWriteAddr1
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	d3,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	movem.l	(sp)+,d1/a0
	rts
AddSmallFont						;transfer smallfont.map tiles to vram. d4 = char to start tiles at, return
	
	move.w	d4,$18D42.l
	movea.l	(SmallFontMap).l,a2
	addq.l	#$8,a2
	bra.w	DecompressGraphicsPlain
; Loads the small font from the framer map.
AddSmallFontFramer
	movea.l	(FramerMap).l,a2
	addq.l	#$8,a2
	move.w	d4,(framercset).l
	bra.w	DecompressGraphicsPlain
; Loads the small font from the second map.
AddSmallFontAlt
	moveq	#$2,d4
	movea.l	$47D44.l,a2
	addq.l	#$8,a2
	bra.w	DecompressGraphicsPlain
AddPenalty						;add penalty d0 (Penaltylist offset) for player a3. Ignored while the
	
	
	btst	#$0,$17F68.l
	bne.w	rtss2
	cmpi.w	#$C,d0
	beq.w	AddPenalty2
	tst.w	$18C08.l
	beq.w	rtss2
	btst	#$2,$63(a3)
	bne.w	rtss2
	btst	#$5,$17F68.l
	bne.w	AddPenalty2
	cmpi.w	#$10,d0		;offsides (92 used $A)
	beq.w	rtss2
AddPenalty2						;forced penalties like face off and game over. d0 = penalty number, a3 =
	
	
	btst	#$7,$17F6A.l
	bne.w	rtss2
	movem.l	d1/a0-a1,-(sp)
	cmpi.w	#$E,d0
	blt.w	.next2
	addi.w	#$C8,(Crowdlevel).l
	move.w	#$C,-(sp)
	btst	#$6,$62(a3)
	beq.w	.next
	addi.w	#$14,$17CD8.l
	move.w	#$B,(sp)
.next	bsr.w	sfx
.next2	movea.l	#$18022,a1
	moveq	#$1F,d1
.loop	tst.w	(a1)+
	dbeq	d1,.loop
	bne.w	.next5
	move.b	$53(a3),-(a1)
	move.b	d0,-(a1)
	movea.l	#$4165C,a0
	adda.w	(a0,d0.w),a0
	tst.b	$1(a0)
	beq.w	.next5
	bmi.w	.next5
	btst	#$6,$62(a3)
	bne.w	.next3
	bset	#$1,$17F7E.l
	bra.w	.next4
.next3	bset	#$2,$17F7E.l
.next4	bset	#$4,$63(a3)
	beq.w	.next5
	clr.w	(a1)
.next5	movem.l	(sp)+,d1/a0-a1
	rts
PenaltyManager						;called periodically. d7 = elapsed time since last call
	bsr.w	updatepentime
	bsr.w	checkfornewpen
	bsr.w	.next
	bra.w	UpdatePA
.next	btst	#$2,$17F70.l
	beq.w	.next4
	btst	#$7,$17F70.l
	bne.w	.next3
	tst.w	$17F98.l
	bmi.w	.next4
	subi.w	#$1,$17F98.l
	bpl.w	.ex
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#$2,$17F6C.l
	bclr	#$7,$17F78.l
	bsr.w	printz
	String	CC_Font1,$3,$2
	moveq	#$1B,d0
	moveq	#$8,d1
	btst	#$0,$17F78.l
	beq.w	.next2
	move.w	#$C,d1
.next2	move.l	#$7FF,d2
	jsr	(eraser).l
	movem.l	(sp)+,d0-d7/a0-a6
	bra.w	.ex
.next3	jsr	$40DFC.l
	bclr	#$7,$17F70.l
.ex	rts
.next4	btst	#$2,$17F68.l
	beq.w	rtss2
	tst.w	$18064.l
	bmi.w	InProgress
	sub.w	d7,$18064.l
	bpl.w	rtss2
	bclr	#$3,$17F68.l
	movea.l	#$18022,a0
.loop	tst.w	(a0)+
	beq.w	rtss2
	clr.w	d0
	move.b	-$2(a0),d0
	movea.l	#$4165C,a1
	adda.w	(a1,d0.w),a1
	tst.b	$1(a1)
	beq.w	.loop
	bmi.w	.loop
	bset	#$2,$17F6C.l
	move.w	(ScoutSubStatus).l,-(sp)
	bsr.w	forceblack
	move.w	(sp)+,(ScoutSubStatus).l
	bsr.w	SetHor
	move.w	$18D56.l,d4
	movea.l	$47D20.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	bsr.w	NewTickerCheckBusy
	bsr.w	NewTicker3
	st.b	$17BE0.l
	movea.l	#$17B80,a3
	moveq	#$1A,d0
	bsr.w	AssistListPush
	move.w	#$1C20,$40(a3)
	st.b	$18070.l
	clr.w	$1806E.l
	bsr.w	UpdatePA
	move.w	#$32,$1806E.l
	clr.w	d0
	bsr.w	PushRef
	move.w	#$18,(palcount).l
	rts
PenShotChk						;a3 = checker, a2 = player hit, d0 = penalty. If a2 is on a breakaway ($64
	
	
	
	
	movem.l	d1-d3/a0,-(sp)
	btst	#$1,$64(a2)
	beq.w	.loop
	btst	#$3,$17F70.l
	beq.w	.next
.loop	move.w	#$FFFF,d1
	bra.w	.next3
.next	movea.l	#$4198A,a0
	move.w	(a0,d0.w),d1
	bmi.w	.next3
	move.w	$52(a2),d2
	movem.w	d0-d1,-(sp)
	move.w	d2,d0
	jsr	(getBAplayerInfo).l
	movem.w	(sp)+,d0-d1
	bpl.w	.next2
	bclr	#$3,$17F70.l
	bra.w	.loop
.next2	move.w	d1,$19372.l
	move.w	d1,d0		;return the penalty shot penalty
.next3	movem.l	(sp)+,d1-d3/a0
	rts
getBAplayerInfo						;d0 = SCnum (0-5 home team, 6-11 away team) of the player on the
	
	
	
	
	movem.l	d1-d3/a1,-(sp)
	tst.w	$18C08.l
	beq.w	.next4
	bset	#$3,$17F70.l
	movem.w	d0,-(sp)
	move.w	#$5,d1
	move.w	#$0,d2
	cmpi.w	#$5,d0
	bgt.w	.next
	move.w	#$B,d1
	move.w	#$1,d2
.next	move.w	d1,d0
	jsr	(getGoalieSCnum).l
	tst.w	d0
	bpl.w	.next2
	movem.w	(sp)+,d0
	bclr	#$3,$17F70.l
	bra.w	.loop
.next2	move.w	d0,d1
	move.w	(sp)+,d0
	move.w	d0,$19368.l
	movea.l	#$17480,a1
	move.w	d0,d3
	asl.w	#$7,d3
	move.w	#$0,$19366.l
	btst	#$6,$62(a1,d3.w)
	beq.w	.next3
	move.w	#$1,$19366.l
.next3	move.w	#$0,$1936C.l
	move.b	$66(a1,d3.w),$1936D.l
	move.w	d1,$1936A.l
	asl.w	#$7,d1
	move.w	#$0,$1936E.l
	move.b	$66(a1,d1.w),$1936F.l
	move.w	#$0,$19370.l
	move.b	$66(a3),$19371.l
.loop	movem.l	(sp)+,d1-d3/a1
	rts
.next4	move.w	#$FFFF,d1		;N set: no penalty shot
	bra.w	.loop
InProgress						;ref in progress-- update graphics and stats and penalty information.
	
	
	
	
	
	tst.w	$1806E.l
	bpl.w	rtss2
	tst.w	$18070.l
	bpl.w	rtss2
	movem.l	d0/a0-a3,-(sp)
.loop	movea.l	#$18022,a0
	tst.w	(a0)+
	beq.w	.next8
.loop2	tst.w	(a0)+
	bne.w	.loop2
	suba.w	#$4,a0
	bclr	#$7,$1(a0)
	bne.w	.next
	move.l	a3,-(sp)
	clr.w	d1
	move.b	$1(a0),d1
	asl.w	#$7,d1
	movea.l	#$17480,a3
	adda.w	d1,a3
	tst.w	$34(a3)
	movea.l	(sp)+,a3
	bpl.w	.next10
	clr.w	(a0)
	bra.w	.next10
.next	clr.w	d0
	move.b	(a0),d0
	movea.l	#$4165C,a1
	adda.w	(a1,d0.w),a1
	bclr	#$5,$17F74.l
	clr.w	d2
	move.b	$1(a1),d2
	beq.w	.next7
	bmi.w	.next7
	cmpi.b	#$5,d2
	bne.w	.next2
	bset	#$5,$17F74.l
.next2	movem.l	d0-d1/a1-a4,-(sp)
	bsr.w	GetPeriodTimeRemaining
	movea.l	#$1825C,a4
	adda.w	$1825A.l,a4
	cmpi.w	#$EC,$1825A.l
	beq.w	.next3
	addi.w	#$4,$1825A.l
.next3	move.w	d0,(a4)+
	move.b	(a0),(a4)+
	clr.w	d1
	move.b	$1(a0),d1
	asl.w	#$7,d1
	movea.l	#$17480,a3
	adda.w	d1,a3
	clr.w	d0
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a1
	btst	#$6,$62(a3)
	beq.w	.next4
	bset	#$7,-$1(a4)
	move.w	#$8000,d0
	exg.l	a1,a2
.next4	addi.w	#$1,$6(a2)
	add.w	d2,$8(a2)
	move.b	$66(a3),d0
	move.b	d0,(a4)
	move.w	d0,$180EE.l
	ext.w	d0
	addi.w	#$104,d0
	add.b	d2,(a2,d0.w)
	subi.w	#$104,d0
	asl.w	#$1,d0
	ext.w	d2
	mulu.w	#$3C,d2
	bset	#$D,d2
	tst.w	$68(a2,d0.w)
	bmi.w	.next5
	btst	#$4,$68(a2,d0.w)
	beq.w	.next5
	bset	#$C,d2
.next5	move.w	d2,$68(a2,d0.w)
	andi.w	#$EFFF,d2
	moveq	#$34,d1
.loop3	subi.w	#$2,d1
	bmi.w	.next6
	move.w	$68(a1,d1.w),d3
	andi.w	#$EFFF,d3
	cmp.w	d3,d2
	bne.w	.loop3
	btst	#$5,$17F74.l
	beq.w	.loop3
	bset	#$6,$68(a1,d1.w)
	bset	#$6,$68(a2,d0.w)
.next6	movem.l	a0,-(sp)
	lea.l	$9C(a2),a0
	moveq	#$18,d1
.loop4	tst.b	(a0)+
	dbmi	d1,.loop4
	move.b	d0,-$1(a0)
	st.b	(a0)
	movem.l	(sp)+,a0
	move.w	#$C,d0
	bsr.w	assreplace
	movem.l	(sp)+,d0-d1/a1-a4
	bsr.w	SetPA
	bsr.w	USBoard
	bra.w	.next10
.next7	clr.w	(a0)
	btst	#$7,$17F6A.l
	bne.w	.loop
	bsr.w	SetPA
	bra.w	.next10
.next8	movea.l	#tmstruct,a2
	bsr.w	InProgress_ap
	adda.w	#$366,a2
	bsr.w	InProgress_ap
	bclr	#$2,$17F68.l
	movea.l	#$17B80,a3
	bclr	#$6,$17F70.l
	move.w	#$1B,d0
	btst	#$3,$17F70.l
	beq.w	.next9
	move.w	#$1E,d0		;puckshootout: penalty shot
.next9	bsr.w	assreplace
.next10	movem.l	(sp)+,d0/a0-a3
	rts
InProgress_ap						;a2 = team. Clears tmpdst bit 5, counts players kept off the ice by
	
	
	
	moveq	#$6,d1
	moveq	#$32,d0
.loop	tst.w	$68(a2,d0.w)
	ble.w	.next
	bclr	#$5,$68(a2,d0.w)
	btst	#$6,$68(a2,d0.w)
	bne.w	.next
	btst	#$4,$68(a2,d0.w)
	bne.w	.next
	cmpi.w	#$4,d1
	beq.w	.next
	subi.w	#$1,d1
.next	subi.w	#$2,d0
	bpl.w	.loop
	move.w	d1,$26(a2)		;tmap
	rts
checkfornewpen						;look for new penalty (entered thru addpenalty(2)). Stops play at once for
	
	
	btst	#$7,$17F6A.l
	bne.w	rtss2
	movea.l	#$18022,a0
.loop	tst.w	(a0)+
	beq.w	rtss2
	btst	#$2,$17F68.l
	bne.w	.next2
	clr.w	d0
	move.b	-$2(a0),d0
	movea.l	#$4165C,a1
	adda.w	(a1,d0.w),a1
	tst.b	$1(a1)
	beq.w	.next
	move.w	$17BE0.l,d0
	bmi.w	.next3
	subi.w	#$6,d0
	move.b	-$1(a0),d1
	ext.w	d1
	subi.w	#$6,d1
	eor.w	d1,d0
	bmi.w	.next3
.next	bsr.w	Stop4Pen
.next2	bset	#$7,-$1(a0)
	bne.w	.loop
	clr.w	d0
	move.b	-$2(a0),d0
	movea.l	#$4165C,a1
	adda.w	(a1,d0.w),a1
	clr.w	d1
	move.b	$0(a1),d1
	asl.w	#$5,d1
	cmp.w	$18064.l,d1
	ble.w	.loop
	move.w	d1,$18064.l
	bra.w	.loop
.next3	bset	#$3,$17F68.l
	bne.w	.loop
	move.w	#$2C,d0
	bsr.w	SetPA
	bra.w	.loop
Stop4Pen						;a0 = penaltylist penalty +2. Stop the clock, set the face off spot from
	
	
	bset	#$0,$17F68.l
	bne.w	.next6
	clr.w	d0
	clr.w	d1
	cmpi.b	#$E,-$2(a0)
	beq.w	.next
	move.w	$17ECA.l,d0
	move.w	$17ECC.l,d1
	cmpi.b	#$6,-$2(a0)
	beq.w	.next
	move.w	$17B80.l,d0
	move.w	$17B94.l,d1
	cmpi.b	#$C,-$2(a0)
	bne.w	.next
	move.l	a3,-(sp)
	movea.l	#$17480,a3
	move.b	-$1(a0),d1
	ext.w	d1
	asl.w	#$7,d1
	adda.w	d1,a3
	move.w	#$258,d1
	btst	#$7,$62(a3)
	movea.l	(sp)+,a3
	beq.w	.next
	neg.w	d1
.next	movem.w	d0-d1,-(sp)
	cmpi.w	#$46,d0
	blt.w	.next2
	move.w	#$46,d0
.next2	cmpi.w	#$FFBA,d0
	bgt.w	.next3
	move.w	#$FFBA,d0
.next3	cmpi.w	#$A6,d1
	blt.w	.next4
	move.w	#$CE,d1
	move.w	#$46,d0
	tst.w	(sp)
	bpl.w	.next4
	neg.w	d0
.next4	cmpi.w	#$FF5A,d1
	bgt.w	.next5
	move.w	#$FF32,d1
	move.w	#$46,d0
	tst.w	(sp)
	bpl.w	.next5
	neg.w	d0
.next5	move.w	d0,$17EE2.l
	move.w	d1,$17EE4.l
	adda.w	#$4,sp
	bsr.w	limitfo
.next6	clr.w	$18064.l
	bset	#$2,$17F68.l
	jsr	$47DB0.l
	move.w	#$3,-(sp)
	bsr.w	sfx
	move.w	#$A,d0		;whistle (92 used $26)
	bra.w	SetPA
