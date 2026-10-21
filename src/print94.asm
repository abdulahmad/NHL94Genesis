;	Text printing (93G print93.asm): vram address from printx / printy, small and big font strings,
;	frames, numbers and times, and the font tile uploads. Included at the end of video94.asm.

; use print x/y/m to set vram address
xyVmMap								;use printx/y/m to set vram address. Returns a0 = Vdata.
									;Saves d0-d2 and calls Vmaddr
	movem.l	d0-d2,-(sp)				;save
	move.w	(printx).w,d0			;x
	move.w	(printy).w,d1			;y
	movea.l	#VmMAP1,a0				;map table
	adda.w	(printm).w,a0			;this map
	move.w	2(a0),d2				;map width shift
	asl.w	d2,d1					;y * map width
	add.w	d1,d0					;plus x
	asl.w	#1,d0					;2 bytes a cell
	add.w	(a0),d0					;plus the map address
	bsr.w	Vmaddr					;set the vram address
	movem.l	(sp)+,d0-d2				;restore
	rts								;return
; fill rectangle with char
; d0/d1 - x/y size of rectangle
; d2 = char word to fill with
; printx/y/m define top corner to start at
eraser								;fill rectangle with char. d0/d1 = x/y size of rectangle, d2 = char word
									;to fill with, printx/y/m define top left corner to start at
	movem.l	d0-d2/a0,-(sp)			;save
	move.w	(disflags).w,-(sp)		;save the flags
	bset	#dfng,(disflags).w		;#dfng
	movem.w	d0-d1,-(sp)				;(sp) = width, 2(sp) = rows left
.1									;loop
	bsr.s	xyVmMap					;one row: a0 = vram port at printx/y
	move.w	(sp),d0					;width
	subq.w	#1,d0					;minus 1
.0									;fill each cell of the row
	move.w	d2,(a0)					;fill one cell
	dbf	d0,.0
	addq.w	#1,(printy).w			;next row
	andi.w	#$1F,(printy).w			;31
	subq.w	#1,2(sp)				;rows left
	bne.s	.1						;loop
	addq.w	#4,sp					;drop the sizes
	move.w	(sp)+,(disflags).w		;restore the flags
	movem.l	(sp)+,d0-d2/a0			;restore
	rts								;return
; frame and fill (uses framer.map graphics and assumes tiles are already located at framercset)
; d0/d1 = x/y size of rectangle
; printx/y/m define top left corner to start at
Framer								;frame and fill (uses framer.map graphics and assums tiles are already
									;located at framercset). d0/d1 = x/y size of rectangle, printx/y/m define
									;top left corner to start at
	movem.l	d0-d4/a0-a1,-(sp)		;save
	move.w	(disflags).w,-(sp)		;save the flags
	bset	#dfng,(disflags).w		;#dfng
	movem.w	d0-d1,-(sp)				;(sp) = x size, 2(sp) = rows left; .tbline reads the x size at 4(sp)
	move.w	(printa).w,d2			;attribute
	add.w	(framercset).w,d2		;plus the frame chars
	movea.l	#FramerMap,a1			;frame map
	adda.l	jimdata(a1),a1			;map data
	addq.w	#4,a1					;skip the size words
	clr.w	d4						;d4 = offset of the frame map row (6 bytes per row: left, middle, right)
	bsr.w	.tbline					;top row
	subq.w	#3,2(sp)				;height-3: loop counter for the middle rows
.mtop								;loop
	bsr.w	.tbline					;middle row (height-2 times)
	subq.w	#6,d4					;stay on the middle map row
	subq.w	#1,2(sp)				;rows left
	bpl.s	.mtop					;loop
	addq.w	#6,d4					;step to the bottom map row
	bsr.w	.tbline					;bottom row
	addq.w	#4,sp					;drop the sizes
	move.w	(sp)+,(disflags).w		;restore the flags
	movem.l	(sp)+,d0-d4/a0-a1		;restore
	rts								;return
.tbline								;local subroutine
	bsr.w	xyVmMap					;draw one frame row: left cell, width-2 middle cells, right cell
	addq.w	#1,(printy).w			;next row
	bsr.w	.setter					;left cell
	addq.w	#2,d4					;next cell
	move.w	4(sp),d0				;width
	subq.w	#3,d0					;minus 3: middle count
.tblp								;each middle cell
	bsr.w	.setter					;middle cells
	dbf	d0,.tblp					;loop
	addq.w	#2,d4					;next cell
	bsr.w	.setter					;right cell
	addq.w	#2,d4					;d4 = next map row
	rts								;return
.setter								;local subroutine
	move.w	0(a1,d4.w),d3			;map word
	add.w	d2,d3					;plus attribute and chars
	move.w	d3,(a0)					;write the cell
	rts								;return
; see print
; string macro should follow jsr to this routine
printsmallz							;String macro follows the call
	move.l	a1,-(sp)				;4(sp) = return address = the String after the call
	movea.l	4(sp),a1				;string after the call
	bsr.w	printsmall				;print it
	move.l	a1,4(sp)				;return past the string
	movea.l	(sp)+,a1				;restore
	rts								;return
; a1 = string macro
; printx/y = x/y coordinate on map for printing
; printm = map to print on
; printa = attribute for characters
;
; string \-$ab,$xx,$yy,'Sample!'\
;
; a = map number (1-3)
; b = color/priority (0-3 = color fam,prio off), (4-7 = color fam, prio on)
; xx = x coord to print at
; yy = y coord to print at
printsmall							;Print string macro a1 at printx/y/m with printa; uses the setup font
									;(setupfontchars) when sflags6 bit 3 is set
	move.w	(disflags).w,-(sp)		;save the flags
	bset	#dfng,(disflags).w		;no graphics
	movem.l	d0-d3/a0/a2-a3,-(sp)	;save
	movea.w	#(smallfontchars-M68K_RAM),a3	;char set bases, picked by printfontset
	btst	#3,(sflags6).w			;setup font?
	beq.w	.start					;no
	movea.w	#(setupfontchars-M68K_RAM),a3	;setup font char base
.start								;font chosen
	bsr.w	xyVmMap					;vram address
	move.w	(printa).w,d2			;attribute
	move.w	(a1)+,d3				;string length
	subq.w	#2,d3					;minus the length word
	bra.w	.1						;start
.0									;each string byte
	move.b	(a1)+,d0				;next string byte
	ext.w	d0						;word
	bgt.w	.nocom					;> 0: character
	neg.w	d0						;control code (0 = padding)
	asl.w	#2,d0					;long index
	movea.l	#ControlCodeJumpTable,a2	;control code table
	movea.l	0(a2,d0.w),a2			;its routine
	jsr	(a2)						;run it
	bra.w	.1						;next
.nocom								;not a control code
	cmp.b	#$40,d0					;'@'?
	bne.w	.noblank				;no
	move.w	#$7FF,d0				;blank char
	bra.w	.p						;write it
.noblank							;d0 <> $40
	cmp.b	#$5E,d0					;'^'?
	beq.w	.skip					;yes: skip
	asl.w	#1,d0					;ascii -> word index into the font map
	movea.l	#SmallFontMap,a2		;small font map
	btst	#3,(sflags6).w			;setup font?
	beq.w	.4						;no
	movea.l	#PrintFont2Map,a2		;second font map
.4									;font map chosen
	adda.l	jimdata(a2),a2			;map data
	move.w	mapwords(a2,d0.w),d0	;char of the font
	move.w	(printfontset).w,d1		;char set
	add.w	0(a3,d1.w),d0			;plus its base
.p									;print the cell
	add.w	d2,d0					;for alternate paletes
	move.w	d0,(a0)					;write the cell
	addq.w	#1,(printx).w			;next column
.1									;loop the string
	dbf	d3,.0						;d3 = bytes left in the string
	movem.l	(sp)+,d0-d3/a0/a2-a3	;restore
	move.w	(sp)+,(disflags).w		;return
	rts
.skip								;d0 = $5E
	addq.w	#1,(printx).w			;'^': skip a column
	bsr.w	xyVmMap					;vram address
	bra.s	.1						;next
ControlCodeJumpTable				;printsmall control codes, indexed by -byte
	dc.l	rtss2					;0: padding, no-op
	dc.l	ControlCode_SetMap		;-1: map
	dc.l	ControlCode_SetAttribute	;-2: palette/priority
	dc.l	ControlCode_SetX		;-3: x
	dc.l	ControlCode_SetY		;-4: y
	dc.l	ControlCode_AddX		;-5: x offset
	dc.l	ControlCode_AddY		;-6: y offset
	dc.l	ControlCode_SetFont		;-7: char set
	dc.l	ControlCode_SetMapAndPosition	;-8: attribute, map, x, y
ControlCode_SetMapAndPosition		;control code -8, next 4 bytes = attribute, map, x, y
	bsr.w	ControlCode_SetAttribute	;attribute
	bsr.w	ControlCode_SetMap		;map
	bsr.w	ControlCode_SetX		;x
	bra.w	ControlCode_SetY		;y
ControlCode_SetMap					;Control code -1, next byte = map number -> printm
	move.b	(a1)+,d0				;map number
	subq.w	#1,d3					;byte used
	andi.w	#3,d0					;0-3
	asl.w	#2,d0					;times 4
	subq.w	#4,d0					;minus 4
	move.w	d0,(printm).w			;store it
	bra.w	xyVmMap					;vram address
ControlCode_SetAttribute			;Control code -2, next byte = palette/priority -> printa
	move.b	(a1)+,d2				;palette/priority
	andi.w	#7,d2					;0-7
	subq.w	#1,d3					;byte used
	ror.w	#3,d2					;to bits 15-13
	move.w	d2,(printa).w			;store it
	rts								;return
ControlCode_SetX					;Control code -3, next byte = printx
	clr.w	d0						;clear
	move.b	(a1)+,d0				;x
	subq.w	#1,d3					;byte used
	move.w	d0,(printx).w			;store it
	bra.w	xyVmMap					;vram address
ControlCode_SetY					;Control code -4, next byte = printy
	clr.w	d0						;clear
	move.b	(a1)+,d0				;y
	subq.w	#1,d3					;byte used
	move.w	d0,(printy).w			;store it
	bra.w	xyVmMap					;vram address
ControlCode_AddX					;control code -5, add the next (signed) byte to printx
	move.b	(a1)+,d0				;byte
	ext.w	d0						;signed
	subq.w	#1,d3					;byte used
	add.w	d0,(printx).w			;add it
	bra.w	xyVmMap					;vram address
ControlCode_AddY					;control code -6, add the next (signed) byte to printy
	move.b	(a1)+,d0				;byte
	ext.w	d0						;signed
	subq.w	#1,d3					;byte used
	add.w	d0,(printy).w			;add it
	bra.w	xyVmMap					;vram address
ControlCode_SetFont					;control code -7, next byte = char set index
	clr.w	d0						;clear
	move.b	(a1)+,d0				;char set
	subq.w	#1,d3					;byte used
	asl.w	#1,d0					;word index
	move.w	d0,(printfontset).w		;store it
	rts								;return
; see print
; string macro should follow jsr to this routine
printz								;print the String that follows the bsr/jsr to this routine, then return
									;past it
	move.l	a1,-(sp)				;4(sp) = return address = the String after the call
	movea.l	4(sp),a1				;string after the call
	bsr.w	print					;print it
	move.l	a1,4(sp)				;return past the string
	movea.l	(sp)+,a1				;restore
	rts								;return
; a1 = string macro
; printx/y = x/y coordinate on map for printing
; printm = map to print on
; printa = attribute for characters
;
; string \-$ab,$xx,$yy,'Sample!'\
; a = map number (1-3)
; b = color/priority (0-3 = color fam, prio off), (4-7 = color fam, prio on)
; xx = x coord to print at
; yy = y coord to print at
print								;a1 = string macro, printx/y = x/y cordinate on map for printing, printm =
									;map to print on, printa = attribute for characters. string
									;\-$ab,$xx,$yy,'Sample!'\ : a = map number (1-3), b = color/priority (0-3
									;= color fam, prio off),(4-7 = color fam, prio on), xx/yy = x/y cord to
									;print at. '@' = char $7FF, '^' = skip a column
	move.w	(disflags).w,-(sp)		;save the flags
	bset	#dfng,(disflags).w		;no graphics
	movem.l	d0-d3/a0/a2,-(sp)		;save
	bsr.w	xyVmMap					;vram address
	move.w	(printa).w,d2			;attribute
	move.w	(a1)+,d3				;string length
	subq.w	#2,d3					;minus the length word
	bra.w	.1						;start
.0									;each string byte
	move.b	(a1)+,d0				;next string byte
	beq.w	.1						;padding
	ext.w	d0
	bpl.w	.nocom					;> 0: character
	neg.w	d0						;-$ab: new attribute, map, x, y
	move.w	d0,d2					;code
	asl.w	#8,d2					;shift left 9 in all
	asl.w	#1,d2
	andi.w	#$F800,d2				;b (bits 7-4 of the code) -> palette/priority bits 15-11
	move.w	d2,(printa).w			;store it
	andi.w	#3,d0					;a = map number
	asl.w	#2,d0					;times 4
	subq.w	#4,d0					;printm = (map-1)*4
	move.w	d0,(printm).w			;store it
	move.b	(a1)+,d0				;xx
	ext.w	d0						;signed
	move.w	d0,(printx).w			;store it
	move.b	(a1)+,d1				;yy
	ext.w	d1						;signed
	move.w	d1,(printy).w			;store it
	bsr.w	xyVmMap					;vram address
	subq.w	#2,d3					;two extra bytes
	bra.w	.1						;next
.nocom								;d0 >= 0
	cmp.b	#$40,d0					;'@'?
	bne.w	.noblank				;no
	move.w	#$7FF,d0				;blank char
	bra.w	.p						;write it
.noblank							;d0 <> $40
	cmp.b	#$5E,d0					;'^'?
	beq.w	.skip					;yes: skip
	asl.w	#1,d0					;ascii -> word index into the font map
	movea.l	#SmallFontMap,a2		;small font map
	btst	#3,(sflags6).w			;setup font?
	beq.w	.2						;no
	movea.l	#PrintFont2Map,a2		;second font map
.2									;font map chosen
	adda.l	jimdata(a2),a2			;map data
	move.w	mapwords(a2,d0.w),d0	;char of the font
	btst	#3,(sflags6).w			;setup font?
	beq.w	.3						;no
	add.w	(setupfontchars).w,d0	;plus its base
	bra.w	.p						;write it
.3									;bit 3 of sflags6 clear
	add.w	(smallfontchars).w,d0	;plus the small font base
.p									;print the cell
	add.w	d2,d0					;for alternate palettes
	move.w	d0,(a0)					;write the cell
	addq.w	#1,(printx).w
.1									;loop the string
	dbf	d3,.0						;d3 = bytes left in the string
	movem.l	(sp)+,d0-d3/a0/a2		;restore
	move.w	(sp)+,(disflags).w		;return
	rts
.skip								;d0 = $5E
	addq.w	#1,(printx).w			;'^': skip a column
	bsr.w	xyVmMap					;vram address
	bra.s	.1						;next
FormatAndPrintTime					;d0 bits 14-15 = period, bits 0-13 = seconds
	swap	d0						;period to the low word
	clr.w	d0						;clear
	rol.l	#2,d0					;d0.w = period
	movea.l	#PeriodLabelTable,a1	;period labels
	bsr.w	Fprintsmall				;print it
	addq.w	#2,(printx).w			;2 columns right
	swap	d0						;seconds back
	lsr.w	#2,d0					;seconds
	bsr.w	PushTime				;as a String
	bra.w	print					;print it
PeriodLabelTable					;String list for FormatAndPrintTime: " 1", " 2", " 3", "OT"
	dc.w	4
	dc.b	' 1'
	dc.w	4
	dc.b	' 2'
	dc.w	4
	dc.b	' 3'
	dc.w	4
	dc.b	'OT'
; convert d0 into string format of min:sec
PushTime							;convert d0 into string format of minutes:seconds. Return a1 = string.
									;pads the minutes to 2 places with a space
	movea.w	#(mesarea+30-M68K_RAM),a1	;end of the buffer
	move.l	d0,-(sp)				;save
	move.l	a1,-(sp)				;save the end
	ext.l	d0						;long
	divu.w	#$A,d0					;/ 10
	swap	d0						;remainder
	addi.w	#$30,d0					;'0'
	move.b	d0,-(a1)				;ones of seconds
	swap	d0						;quotient
	ext.l	d0						;long
	divu.w	#6,d0					;/ 6
	swap	d0						;remainder
	addi.w	#$30,d0					;'0'
	move.b	d0,-(a1)				;tens of seconds
	swap	d0						;quotient
	move.b	#$3A,-(a1)				;':'
	ext.l	d0						;long
	divu.w	#$A,d0					;/ 10
	swap	d0						;remainder
	addi.w	#$30,d0					;'0'
	move.b	d0,-(a1)				;ones of minutes
	swap	d0						;quotient
	move.b	#$20,-(a1)				;' '
	tst.w	d0						;tens of minutes?
	beq.w	.noz					;no
	addi.w	#$30,d0					;'0'
	move.b	d0,(a1)					;tens of minutes
.noz								;leading zero blanked
	move.l	(sp)+,d0				;d0 = end address of the string
	sub.l	a1,d0					;minus the start
	addq.w	#2,d0					;length incl. the length word
	btst	#0,d0					;odd?
	beq.w	.1						;no
	clr.b	-(a1)					;pad to an even length
	addq.w	#1,d0					;one more
.1									;length made even
	move.w	d0,-(a1)				;string length word in front
	move.l	(sp)+,d0				;restore
	rts								;return
PushNumber							;convert d0 into string format of base 10 number, no leading zeros. Return
									;a1 = string
	movea.w	#(PushNumberBuf-M68K_RAM),a1	;end of the buffer
	move.l	d0,-(sp)				;save
	move.l	a1,-(sp)				;save the end
.0									;loop
	ext.l	d0						;long
	divu.w	#$A,d0					;/ 10
	swap	d0						;remainder
	addi.w	#$30,d0					;'0'
	move.b	d0,-(a1)				;digit
	swap	d0						;quotient
	tst.w	d0						;more?
	bne.s	.0						;quotient left: more digits
	move.l	(sp)+,d0				;d0 = end address of the string
	sub.l	a1,d0					;minus the start
	addq.w	#2,d0					;length incl. the length word
	btst	#0,d0					;odd?
	beq.w	.1						;no
	clr.b	-(a1)					;pad to an even length
	addq.w	#1,d0					;one more
.1									;length made even
	move.w	d0,-(a1)				;string length word in front
	move.l	(sp)+,d0				;restore
	rts								;return
PushNumberWidth						;right-justified number
	movem.l	d0-d3,-(sp)				;push to stack
	movea.w	#(PushWidthBuf+2-M68K_RAM),a1	;a1 = the digits after the PushWidthBuf length word
	moveq	#1,d2					;move 1 into d2
	sub.w	d2,d1					;sub d2 from d1
	bra.w	.loop					;branch
.mul								;power of 10 for the width
	mulu.w	#$A,d2					;mult d2 by 10 dec
.loop								;loop the width
	dbf	d1,.mul						;exit when d1 is 0
	moveq	#$20,d3					;' '   ; move 20 into d3
.loop2								;loop
	ext.l	d0						;sign extend d0
	divu.w	d2,d0					;divide d2 into d0
	bne.w	.0						;branch if not equal
	cmp.w	#1,d2					;compare d2 to 1
	beq.w	.0						;branch if equal
	move.w	d3,d0					;move d3 into d0
	bra.w	.put					;store it
.0									;a digit (or a needed 0)
	;DeterStrLength?+26   j
	moveq	#$30,d3					;'0'   ; move 48 dec into d3
	add.w	d3,d0					;add d3 to d0
.put								;store the digit or space
	move.b	d0,(a1)+				;move d0 into a1 and increment a1
	swap	d0						;swap d0 words
	divu.w	#$A,d2					;divide d2 by 10 dec
	bne.s	.loop2					;branch if not equal to 0
	move.l	a1,d0					;move a1 into d0
	subi.w	#$C008,d0				;minus PushWidthBuf: the string length
	btst	#0,d0					;test bit 0 of d0
	beq.w	.00						;no
	clr.b	(a1)+					;clear byte at a1 and increment
	addq.w	#1,d0					;add 1 to d0
.00									;length made even
	movea.w	#(PushWidthBuf-M68K_RAM),a1	;a1 = PushWidthBuf again
	move.w	d0,(a1)					;move d0 into a1 address location
	movem.l	(sp)+,d0-d3				;push from stack
	rts
appendz								;see appstring. String macro should follow the bsr/jsr to this routine
	movea.l	(sp)+,a1				;the String
	bsr.w	appstring				;append it
	jmp	(a1)						;return after it
; append string a1 to string a3
appstring							;append string a1 to string a3
	movem.l	d0/a0,-(sp)				;save
	lea	2(a3),a0					;a0 scans a3's text for its terminating zero
	move.w	(a3),d0					;a3 length word
	subq.w	#3,d0					;minus 3
	bmi.w	.1						;empty
.0									;find the end of the text
	addq.w	#1,a0					;next byte of the destination
	tst.b	(a0)					;zero?
	dbeq	d0,.0					;stop at the zero byte
.1									;end found
	move.w	(a1)+,d0				;a1 length word
	subq.w	#3,d0					;minus 3
	bmi.w	.ex						;empty source: nothing to append
.2									;copy each char
	move.b	(a1)+,(a0)+				;copy one char
	bne.w	.3						;zero?
	subq.w	#1,a0					;a zero byte is not kept, so it gets overwritten next
.3									;next char
	dbf	d0,.2						;next char
	move.l	a0,d0
	btst	#0,d0					;odd?
	beq.w	.4						;no
	clr.b	(a0)+					;pad to an even length
	addq.l	#1,d0					;one more
.4									;length made even
	sub.l	a3,d0					;length
	move.w	d0,(a3)					;store it
.ex									;exit: restore the registers
	movem.l	(sp)+,d0/a0				;restore
	rts								;return
printbigz							;String macro follows the call
	move.l	a1,-(sp)				;4(sp) = return address = the String after the call
	movea.l	4(sp),a1				;string after the call
	bsr.w	printbig				;print it
	move.l	a1,4(sp)				;return past the string
	movea.l	(sp)+,a1				;restore
	rts								;return
printbig							;same as print, only use bigfont.map graphics. a1 = string macro, printx/y
									;= x/y cordinate on map for printing, printm = map to print on, printa =
									;attribute for characters. string \-$ab,$xx,$yy,'Sample!'\ : a = map
									;number (1-3), b = color/priority (0-3 = color fam, prio off),(4-7 = color
									;fam, prio on), xx/yy = x/y cord to print at
	move.w	(disflags).w,-(sp)		;save the flags
	bset	#dfng,(disflags).w		;no graphics
	movem.l	d0-d7/a0/a2,-(sp)		;save
	move.w	(printx).w,d4			;x
	move.w	(printy).w,d5			;y
	move.w	(printa).w,d6			;attribute
	add.w	(BigFontchars).w,d6
	move.w	(a1)+,d3				;string length
	subq.w	#2,d3					;minus the length word
	bra.w	.1						;start
.0									;each string byte
	move.b	(a1)+,d0				;next string byte
	beq.w	.1						;padding
	ext.w	d0						;signed
	bpl.w	.nocom					;> 0: character
	neg.w	d0						;-$ab: new attribute, map, x, y
	move.w	d0,d6					;code
	asl.w	#8,d6					;shift left 9 in all
	asl.w	#1,d6
	andi.w	#$F800,d6				;b -> palette/priority bits
	move.w	d6,(printa).w			;store it
	add.w	(BigFontchars).w,d6		;d6 = attribute + big font char base
	andi.w	#3,d0					;a = map number
	asl.w	#2,d0					;times 4
	subq.w	#4,d0					;printm = (map-1)*4
	move.w	d0,(printm).w			;store it
	move.b	(a1)+,d4				;xx
	ext.w	d4						;signed
	move.w	d4,(printx).w			;store it
	move.b	(a1)+,d5				;yy
	ext.w	d5						;signed
	move.w	d5,(printy).w			;store it
	subq.w	#2,d3					;two extra bytes consumed
	bra.w	.1						;next
.nocom								;d0 >= 0
	cmp.b	#$61,d0					;below 'a'?
	blt.w	.2						;yes
	cmp.b	#$7A,d0					;above 'z'?
	bgt.w	.2						;yes
	addi.b	#-$20,d0				;upper case
.2									;upper case
	move.w	d3,-(sp)				;save
	bsr.w	PrintBigChar			;print the char
	move.w	(sp)+,d3				;restore
.1									;loop the string
	dbf	d3,.0						;d3 = bytes left in the string
	move.w	d4,(printx).w			;restore x
	move.w	d5,(printy).w			;restore y
	movem.l	(sp)+,d0-d7/a0/a2		;restore
	move.w	(sp)+,(disflags).w		;restore the flags
	rts								;return
PrintBigChar						;print big font char d0 (ascii) through bfasciicon
	subi.w	#$20,d0					;from ' '
	movea.l	#bfasciicon,a0			;char table
	moveq	#1,d2					;2 columns
	move.b	0(a0,d0.w),d1			;tile offset
	ext.w	d1						;word
	bpl.w	.0						;positive: 2 wide
	neg.w	d1						;negative: 1 wide
	clr.w	d2						;1 column
.0									;tile offset ready
	asl.w	#1,d1					;word index
	movea.l	#BigFontMap,a0			;big font map
	adda.l	jimdata(a0),a0			;map data
.loop								;each tile of the char
	move.w	mapwords(a0,d1.w),d3	;top tile
	bsr.w	PutBigTile				;write it
	move.w	(a0),d7					;map width
	asl.w	#1,d7					;2 bytes a cell
	add.w	d7,d1					;next row
	move.w	mapwords(a0,d1.w),d3	;bottom tile
	sub.w	d7,d1					;back
	addq.w	#1,d5					;down a row
	bsr.w	PutBigTile				;write it
	subq.w	#1,d5					;up a row
	addq.w	#1,d4					;next column
	addq.w	#2,d1					;next tile
	dbf	d2,.loop					;loop
	rts								;return
PutBigTile							;write one big font tile to the map at printx / printy
	add.w	d6,d3					;plus attribute and chars
	movem.l	d1/a0,-(sp)				;save
	move.w	d5,d0					;y
	movea.l	#VmMAP1,a0				;map table
	adda.w	(printm).w,a0			;this map
	move.w	2(a0),d1				;map width shift
	asl.w	d1,d0					;y * map width
	add.w	d4,d0					;plus x
	asl.w	#1,d0					;2 bytes a cell
	add.w	(a0),d0					;plus the map address
	bsr.w	Vmaddr					;set the vram address
	move.w	d3,(a0)					;write the tile
	movem.l	(sp)+,d1/a0				;restore
	rts								;return
AddSmallFont						;transfer smallfont.map tiles to vram. d4 = char to start tiles at, return
									;d4 = end of tiles + 1. Goes through DecompressGraphics
	move.w	d4,(smallfontchars).w	;small font chars
	movea.l	#SmallFontMap+8,a2		;font tiles
	bra.w	DecompressGraphicsPlain	;send them
AddFramer							;transfer framer.map tiles to vram. d4 = char to start tiles at, return d4
									;= end of tiles + 1. Goes through DecompressGraphics
	movea.l	#FramerMap+8,a2			;frame tiles
	move.w	d4,(framercset).w		;frame chars
	bra.w	DecompressGraphicsPlain	;send them
AddTeamBlock						;transfer TeamBlocks.map tiles to vram at char 2. Return d4 = end of tiles
									;+ 1. Goes through DecompressGraphics
	moveq	#2,d4					;char 2
	movea.l	#Teamblocksmap+8,a2		;team block tiles
	bra.w	DecompressGraphicsPlain	;send them
