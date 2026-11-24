xyVmMap						;use printx/y/m to set vram address. Returns a0 = Vdata.
	
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
	bsr.w	SetVramWriteAddr1
	movem.l	(sp)+,d0-d2
	rts
eraser						;fill rectangle with char. d0/d1 = x/y size of rectangle, d2 = char word
	
	movem.l	d0-d2/a0,-(sp)
	move.w	(disflags).l,-(sp)
	bset	#dfng,(disflags).l
	movem.w	d0-d1,-(sp)
.1	bsr.w	xyVmMap
	move.w	(sp),d0
	subi.w	#$1,d0
.loop	btst	#$7,(GA_COMFLAGS).l
	bne.b	.loop
	move.w	d2,(GA_COMSTAT1).l
	move.w	#$D,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.loop2	btst	#$6,(GA_COMFLAGS).l
	beq.b	.loop2
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.loop3	btst	#$6,(GA_COMFLAGS).l
	bne.b	.loop3
	bclr	#$7,(GA_COMFLAGS+1).l
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
	bset	#dfng,(disflags).l
	movem.w	d0-d1,-(sp)
	move.w	(printa).l,d2
	add.w	(framercset).l,d2
	movea.l	(FramerMap).l,a1
	adda.l	jimdata(a1),a1
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
.loop	btst	#$7,(GA_COMFLAGS).l
	bne.b	.loop
	move.w	d3,(GA_COMSTAT1).l
	move.w	#$D,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.loop2	btst	#$6,(GA_COMFLAGS).l
	beq.b	.loop2
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.loop3	btst	#$6,(GA_COMFLAGS).l
	bne.b	.loop3
	bclr	#$7,(GA_COMFLAGS+1).l
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
	bset	#dfng,(disflags).l
	movem.l	d0-d3/a0/a2-a3,-(sp)
	movea.l	#smallfontchars,a3
	btst	#$3,(sflags6).l
	beq.w	.start
	movea.l	#setupfontchars,a3
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
	movea.l	#ControlCode_SetMapAndPosition,a2
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
	movea.l	(PrintFont2Map).l,a2
.4	adda.l	jimdata(a2),a2
	move.w	mapwords(a2,d0.w),d0
	move.w	(printfontset).l,d1
	add.w	(a3,d1.w),d0
.p	add.w	d2,d0
.loop	btst	#$7,(GA_COMFLAGS).l
	bne.b	.loop
	move.w	d0,(GA_COMSTAT1).l
	move.w	#$D,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.loop2	btst	#$6,(GA_COMFLAGS).l
	beq.b	.loop2
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.loop3	btst	#$6,(GA_COMFLAGS).l
	bne.b	.loop3
	bclr	#$7,(GA_COMFLAGS+1).l
	addi.w	#$1,(printx).l
.loop4	dbra	d3,.0
	movem.l	(sp)+,d0-d3/a0/a2-a3
	move.w	(sp)+,(disflags).l
	rts
.skip	addi.w	#$1,(printx).l
	bsr.w	xyVmMap
	bra.w	.loop4
ControlCode_SetMapAndPosition						;control code -8, next 4 bytes = attribute, map, x, y
; Data that follows ControlCode_SetMapAndPosition (strings, small tables)
ControlCode_SetMapAndPositionData	dc.w	$0003,$C000
	dc.w	$0003,$8EE6
	dc.w	$0003,$8F00
	dc.w	$0003,$8F14
	dc.w	$0003,$8F26
	dc.w	$0003,$8F38
	dc.w	$0003,$8F4A
	dc.w	$0003,$8F5C
	dc.w	$0003,$8ED6
	bsr.w	ControlCode_SetAttribute
	bsr.w	ControlCode_SetMap
	bsr.w	ControlCode_SetX
	bra.w	ControlCode_SetY
ControlCode_SetMap	move.b	(a1)+,d0
	subi.w	#$1,d3
	andi.w	#$3,d0
	asl.w	#$2,d0
	subi.w	#$4,d0
	move.w	d0,(printm).l
	bra.w	xyVmMap
ControlCode_SetAttribute	move.b	(a1)+,d2
	andi.w	#$7,d2
	subi.w	#$1,d3
	ror.w	#$3,d2
	move.w	d2,(printa).l
	rts
ControlCode_SetX	clr.w	d0
	move.b	(a1)+,d0
	subi.w	#$1,d3
	move.w	d0,(printx).l
	bra.w	xyVmMap
ControlCode_SetY	clr.w	d0
	move.b	(a1)+,d0
	subi.w	#$1,d3
	move.w	d0,(printy).l
	bra.w	xyVmMap
ControlCode_AddX
	move.b	(a1)+,d0
	ext.w	d0
	subi.w	#$1,d3
	add.w	d0,(printx).l
	bra.w	xyVmMap
ControlCode_AddY
	move.b	(a1)+,d0
	ext.w	d0
	subi.w	#$1,d3
	add.w	d0,(printy).l
	bra.w	xyVmMap
ControlCode_SetFont
	clr.w	d0
	move.b	(a1)+,d0
	subi.w	#$1,d3
	asl.w	#$1,d0
	move.w	d0,(printfontset).l
	rts	
printz						;print the String that follows the bsr/jsr to this routine, then return
	
	move.l	a1,-(sp)
	movea.l	$4(sp),a1
	bsr.w	print
	move.l	a1,$4(sp)
	movea.l	(sp)+,a1
	rts
print						;a1 = string macro, printx/y = x/y cordinate on map for printing, printm =
	
	
	
	
	move.w	(disflags).l,-(sp)
	bset	#dfng,(disflags).l
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
	move.w	d0,(printm).l
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
	bra.w	.p
.noblank	cmpi.b	#$5E,d0
	beq.w	.skip
	asl.w	#$1,d0
	movea.l	(SmallFontMap).l,a2
	btst	#$3,(sflags6).l
	beq.w	.2
	movea.l	(PrintFont2Map).l,a2
.2	adda.l	jimdata(a2),a2
	move.w	mapwords(a2,d0.w),d0
	btst	#$3,(sflags6).l
	beq.w	.3
	add.w	(setupfontchars).l,d0
	bra.w	.p
.3	add.w	(smallfontchars).l,d0
.p	add.w	d2,d0
.loop	btst	#$7,(GA_COMFLAGS).l
	bne.b	.loop
	move.w	d0,(GA_COMSTAT1).l
	move.w	#$D,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.loop2	btst	#$6,(GA_COMFLAGS).l
	beq.b	.loop2
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.loop3	btst	#$6,(GA_COMFLAGS).l
	bne.b	.loop3
	bclr	#$7,(GA_COMFLAGS+1).l
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
	movea.l	#PeriodLabelTable,a1
	bsr.w	Fprintsmall
	addi.w	#$2,(printx).l
	swap	d0
	lsr.w	#$2,d0
	bsr.w	PushTime
	bra.w	print
; Data that follows FormatAndPrintTime (strings, small tables)
PeriodLabelTable	dc.w	$0004,$2031,$0004,$2032,$0004,$2033,$0004,$4F54
PushTime						;convert d0 into string format of minutes:seconds. Return a1 = string.
	
	movea.l	#mesarea+30,a1
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
	
	movea.l	#PushNumberBuf,a1
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
	movea.l	#PushWidthBuf+2,a1
	moveq	#$1,d2
	sub.w	d2,d1
	bra.w	.next
.mul	mulu.w	#$A,d2
.next	dbra	d1,.mul
	moveq	#$20,d3
.loop2	ext.l	d0
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
	bne.w	.loop2
	move.l	a1,d0
	subi.l	#PushWidthBuf,d0
	btst	#$0,d0
	beq.w	.00
	clr.b	(a1)+
	addi.w	#$1,d0
.00	movea.l	#PushWidthBuf,a1
	move.w	d0,(a1)
	movem.l	(sp)+,d0-d3
	rts
; Appends the number string, then returns through a1.
appendz
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
	bmi.w	.ex
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
.ex	movem.l	(sp)+,d0/a0
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
	bset	#dfng,(disflags).l
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
	move.w	d0,(printm).l
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
	movea.l	#bfasciicon,a0
	moveq	#$1,d2
	move.b	(a0,d0.w),d1
	ext.w	d1
	bpl.w	.0
	neg.w	d1
	clr.w	d2
.0	asl.w	#$1,d1
	movea.l	(BigFontMap).l,a0
	adda.l	jimdata(a0),a0
.loop	move.w	mapwords(a0,d1.w),d3
	bsr.w	PutBigTile
	move.w	(a0),d7
	asl.w	#$1,d7
	add.w	d7,d1
	move.w	mapwords(a0,d1.w),d3
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
	adda.w	(printm).l,a0
	move.w	$2(a0),d1
	asl.w	d1,d0
	add.w	d4,d0
	asl.w	#$1,d0
	add.w	(a0),d0
	bsr.w	SetVramWriteAddr1
.loop	btst	#$7,(GA_COMFLAGS).l
	bne.b	.loop
	move.w	d3,(GA_COMSTAT1).l
	move.w	#$D,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.loop2	btst	#$6,(GA_COMFLAGS).l
	beq.b	.loop2
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.loop3	btst	#$6,(GA_COMFLAGS).l
	bne.b	.loop3
	bclr	#$7,(GA_COMFLAGS+1).l
	movem.l	(sp)+,d1/a0
	rts
AddSmallFont						;transfer smallfont.map tiles to vram. d4 = char to start tiles at, return
	
	move.w	d4,(smallfontchars).l
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
AddTeamBlock
	moveq	#$2,d4
	movea.l	(Teamblocksmap).l,a2
	addq.l	#$8,a2
	bra.w	DecompressGraphicsPlain