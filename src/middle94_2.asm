;	NHL 94 (retail) segment $1169A-$11F2B
;	92 Middle.Asm part 2, as 93 middle93_2.asm: dobitmap, the graphics decompressor (DecompressGraphicsWithCallback,
;	DoDMA_clearCallbackPointer, DecompressGraphics, DecompressBytecode, jump_table, the Opcode_* handlers,
;	FlushOutputBuffer), xyVmMap, eraser, Framer, printz2 / print2 and the control codes, printz / print,
;	FormatAndPrintTime, PeriodLabelTable, PushTime, PushNumber, PushNumberWidth, appendz / appstring, printbigz /
;	printbig, the 94 sub_11E8E / sub_11EDA, AddSmallFont, AddFramer, AddTeamBlock. AddPenalty (penalty94_1) follows
;	at $11F2C.
;	Transcribed from lst/nhl94.bin.lst lines 44878-45933. Global names are the 93 names where 93 has the routine
;	(IDA name in an ;IDA: comment); printz2 / print2 keep the IDA names that the earlier segments call (93
;	printsmallz / printsmall). The decompressor handlers and four control codes have no IDA label; the labels are
;	placed at the addresses in jump_table and ControlCodeJumpTable. Local labels are the IDA local names (_x -> .x)
;	or the IDA address (loc_116A8 -> .116A8).
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp /
;	cmpi; fixopcodes.js patches the cmp encoding after assembly.

dobitmap
	move.w	(printy).w,-(sp)
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w	;#dfng
	movem.l	d0-d3/d5-d6/a0-a3,-(sp)
	move.w	d1,d6
	movea.w	#(palfadenew-M68K_RAM),a3
	bra.w	.00
.01
	move.b	0(a0,d0.w),0(a3,d0.w)
	dbf	d0,.01
.02
	adda.l	#$20,a0
	adda.l	#$20,a3
.00
	moveq	#$1F,d0
	lsr.w	#1,d5
	bcs.s	.01
	bne.s	.02
	move.w	(printa).w,d5
	andi.w	#$F800,d5
	move.w	$E(sp),d2
	subq.w	#1,d2
.loop2
	bsr.w	xyVmMap
	move.w	d6,d0	;y start
	mulu.w	(a1),d0	;map width
	add.w	2(sp),d0
	asl.w	#1,d0
	move.w	$A(sp),d1
	subq.w	#1,d1
.loop1
	move.w	4(a1,d0.w),d3
	add.w	d4,d3
	eor.w	d5,d3
	move.w	d3,(a0)
	addq.w	#2,d0
	dbf	d1,.loop1
	addq.w	#1,(printy).w
	addq.w	#1,d6
	dbf	d2,.loop2
	btst	#0,(word_FFC2F8).w
	bne.w	.1171E
	bsr.w	DoDMA_clearCallbackPointer
.1171E
	movem.l	(sp)+,d0-d3/d5-d6/a0-a3
	move.w	(sp)+,(disflags).w
	move.w	(sp)+,(printy).w
	rts
DecompressGraphicsWithCallback	;IDA: sub_1172C (93 name). DecompressGraphics, then return 8 bytes past the call (callback data)
	move.l	(sp),(dword_FFCF32).w
	bsr.w	DecompressGraphics
	addq.l	#8,(sp)
	rts
DoDMA_clearCallbackPointer	;IDA: sub_11738 (93 name). Clear dword_FFCF32 (93 callbackPtr), fall into DecompressGraphics
	clr.l	(dword_FFCF32).w
DecompressGraphics	;IDA: sub_1173C (93 name). a2 = graphics data, d4 = start char
	movem.l	d0-d1/a0-a6,-(sp)
	movea.l	a2,a0
	move.w	d4,d1
	asl.w	#5,d1
	move.w	(a0)+,d0
	beq.w	.11774
	bmi.w	.1176A
	add.w	d0,d4
	asl.w	#4,d0
	pea	(.11774).l
	tst.l	(dword_FFCF32).w
	beq.w	DoDMApro
	movea.l	(dword_FFCF32).w,a1
	bra.w	remap
.1176A
	andi.w	#$7FFF,d0
	add.w	d0,d4
	bsr.w	DecompressBytecode
.11774
	movem.l	(sp)+,d0-d1/a0-a6
	rts
DecompressBytecode	;IDA: sub_1177A (93 name). Unpack a0 into the 256 byte ring buffer at ThreeStars (93 DispAttribCtr)
	movea.w	#(ThreeStars-M68K_RAM),a1
	movea.w	#(ThreeStars-M68K_RAM),a3
	movea.w	#(dword_FFCF32-M68K_RAM),a4
	movea.l	#remap,a5
	movea.l	#DoDMApro,a6
	movem.l	d0-d3/a0-a2,-(sp)
	move.w	d1,d3
	clr.w	d1
	clr.w	d2
.1179C
	move.b	(a0)+,d0
	andi.w	#$F0,d0
	lsr.w	#3,d0
	lea	jump_table(pc),a2
	move.w	0(a2,d0.w),d0
	jsr	0(a2,d0.w)
	bra.s	.1179C
jump_table	;IDA: unk_117B2 (93 name). DecompressBytecode handler offsets, one per opcode high nibble
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
Opcode_CopyLiteral	;93: opcodes 0-1, copy (low 5 bits)+1 bytes from the data
	move.b	-1(a0),d0
	andi.w	#$1F,d0
.117DA
	move.b	(a0)+,0(a1,d1.w)
	addq.b	#1,d1
	bne.w	.117E8
	bsr.w	FlushOutputBuffer
.117E8
	dbf	d0,.117DA
	rts
Opcode_ClearBytes	;93: opcode 2, write (low 4 bits)+1 zero bytes
	move.b	-1(a0),d0
	andi.w	#$F,d0
.117F6
	clr.b	0(a1,d1.w)
	addq.b	#1,d1
	bne.w	.11804
	bsr.w	FlushOutputBuffer
.11804
	dbf	d0,.117F6
	rts
Opcode_Fillbytes	;93: opcode 3, write the next data byte (low 4 bits)+3 times
	move.b	-1(a0),d0
	andi.w	#$F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
.11816
	move.b	d2,0(a1,d1.w)
	addq.b	#1,d1
	bne.w	.11824
	bsr.w	FlushOutputBuffer
.11824
	dbf	d0,.11816
	rts
Opcode_CopyBackwardShort	;93: opcodes 4-7, copy from back in the output buffer
	move.b	-1(a0),d0
	andi.w	#7,d0
	addq.w	#1,d0
	move.b	-1(a0),d2
	lsr.w	#3,d2
	andi.w	#7,d2
	addq.w	#1,d2
CopyBackwardRun	;IDA: loc_11840. 93: shared copy loop, d0 = count-1, d2 = distance back
	neg.b	d2
	add.b	d1,d2
.11844
	move.b	0(a1,d2.w),0(a1,d1.w)
	addq.b	#1,d2
	addq.b	#1,d1
	bne.w	.11856
	bsr.w	FlushOutputBuffer
.11856
	dbf	d0,.11844
	rts
Opcode_CopyBackwardMedium	;93: opcode 8
	move.b	-1(a0),d0
	andi.w	#$F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
	bra.s	CopyBackwardRun
Opcode_CopyBackwardLong	;93: opcode 9
	move.b	(a0),d0
	asl.b	#1,d0
	move.b	-1(a0),d0
	roxl.b	#1,d0
	andi.w	#$1F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
	andi.w	#$7F,d2
	addq.w	#1,d2
	bra.s	CopyBackwardRun
Opcode_CopyBackwardExtended1	;93: opcode A
	move.b	-1(a0),d0
	asl.w	#8,d0
	move.b	(a0),d0
	lsr.w	#6,d0
	andi.w	#$3F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
	andi.w	#$3F,d2
	addq.w	#1,d2
	bra.s	CopyBackwardRun
Opcode_CopyBackwardExtended2	;93: opcode B. IDA left this handler as dc.b; written from the retail bytes
	move.b	-1(a0),d0
	asl.w	#8,d0
	move.b	(a0),d0
	lsr.w	#5,d0
	andi.w	#$7F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
	andi.w	#$1F,d2
	addq.w	#1,d2
	bra.s	CopyBackwardRun
Opcode_CopyBackwardReverseShort	;93: opcodes C-D, copy backwards through the source
	move.b	-1(a0),d0
	andi.w	#3,d0
	addq.w	#1,d0
	move.b	-1(a0),d2
	lsr.w	#2,d2
	andi.w	#7,d2
	addq.w	#1,d2
CopyBackwardReverseRun	;IDA: loc_118CE. 93: shared reverse copy loop
	neg.b	d2
	add.b	d1,d2
.118D2
	move.b	0(a1,d2.w),0(a1,d1.w)
	subq.b	#1,d2
	addq.b	#1,d1
	bne.w	.118E4
	bsr.w	FlushOutputBuffer
.118E4
	dbf	d0,.118D2
	rts
Opcode_CopyBackwardReverseMedium	;93: opcode E. Distance 0 is the end code
	move.b	-1(a0),d0
	andi.w	#$F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
	bne.s	CopyBackwardReverseRun
	tst.w	d1
	beq.w	.11902
	bsr.w	FlushOutputBuffer
.11902
	addq.w	#4,sp
	movem.l	(sp)+,d0-d3/a0-a2
	rts
Opcode_CopyBackwardReverseLong	;93: opcode F
	move.b	(a0),d0
	asl.b	#1,d0
	move.b	-1(a0),d0
	roxl.b	#1,d0
	andi.w	#$1F,d0
	addq.w	#2,d0
	move.b	(a0)+,d2
	andi.w	#$7F,d2
	addq.w	#1,d2
	bra.s	CopyBackwardReverseRun
FlushOutputBuffer	;IDA: sub_11924 (93 name). Write the full ring buffer to vram
	movem.l	d0-d1/a0-a1,-(sp)
	move.w	d1,d0
	bne.w	.11932
	move.w	#$100,d0
.11932
	lsr.w	#1,d0
	move.w	d3,d1
	add.w	d0,d3
	add.w	d0,d3
	movea.l	a1,a0
	tst.l	(a4)
	beq.w	.1194A
	movea.l	(a4),a1
	jsr	(a5)
	bra.w	.1194C
.1194A
	jsr	(a6)
.1194C
	movem.l	(sp)+,d0-d1/a0-a1
	rts
; use print x/y/m to set vram address
xyVmMap
	movem.l	d0-d2,-(sp)
	move.w	(printx).w,d0
	move.w	(printy).w,d1
	movea.l	#$FFFFB004,a0	;#VmMap1
	adda.w	(printm).w,a0
	move.w	2(a0),d2
	asl.w	d2,d1
	add.w	d1,d0
	asl.w	#1,d0
	add.w	(a0),d0
	bsr.w	Vmaddr
	movem.l	(sp)+,d0-d2
	rts
; fill rectangle with char
; d0/d1 - x/y size of rectangle
; d2 = char word to fill with
; printx/y/m define top corner to start at
eraser
	movem.l	d0-d2/a0,-(sp)
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w	;#dfng
	movem.w	d0-d1,-(sp)
.1
	bsr.s	xyVmMap
	move.w	(sp),d0
	subq.w	#1,d0
.0
	move.w	d2,(a0)
	dbf	d0,.0
	addq.w	#1,(printy).w
	andi.w	#$1F,(printy).w
	subq.w	#1,2(sp)
	bne.s	.1
	addq.w	#4,sp
	move.w	(sp)+,(disflags).w
	movem.l	(sp)+,d0-d2/a0
	rts
; frame and fill (uses framer.map graphics and assumes tiles are already located at framercset)
; d0/d1 = x/y size of rectangle
; printx/y/m define top left corner to start at
Framer
	movem.l	d0-d4/a0-a1,-(sp)
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w	;#dfng
	movem.w	d0-d1,-(sp)
	move.w	(printa).w,d2
	add.w	(framercset).w,d2
	movea.l	#framermap,a1
	adda.l	4(a1),a1
	addq.w	#4,a1
	clr.w	d4
	bsr.w	.tbline
	subq.w	#3,2(sp)
.mtop
	bsr.w	.tbline
	subq.w	#6,d4
	subq.w	#1,2(sp)
	bpl.s	.mtop
	addq.w	#6,d4
	bsr.w	.tbline
	addq.w	#4,sp
	move.w	(sp)+,(disflags).w
	movem.l	(sp)+,d0-d4/a0-a1
	rts
.tbline
	bsr.w	xyVmMap
	addq.w	#1,(printy).w
	bsr.w	.setter
	addq.w	#2,d4
	move.w	4(sp),d0
	subq.w	#3,d0
.11A1A
	bsr.w	.setter
	dbf	d0,.11A1A
	addq.w	#2,d4
	bsr.w	.setter
	addq.w	#2,d4
	rts
.setter
	move.w	0(a1,d4.w),d3
	add.w	d2,d3
	move.w	d3,(a0)
	rts
; see print
; string macro should follow jsr to this routine
printz2	;IDA name (93 printsmallz). String macro follows the call
	move.l	a1,-(sp)
	movea.l	4(sp),a1
	bsr.w	print2
	move.l	a1,4(sp)
	movea.l	(sp)+,a1
	rts
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
print2	;IDA name (93 printsmall)
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	movem.l	d0-d3/a0/a2-a3,-(sp)
	movea.w	#(word_FFB012-M68K_RAM),a3
	btst	#3,(word_FFC2F8).w
	beq.w	.start
	movea.w	#(word_FFBF52-M68K_RAM),a3
.start
	bsr.w	xyVmMap
	move.w	(printa).w,d2
	move.w	(a1)+,d3
	subq.w	#2,d3
	bra.w	.1
.0
	move.b	(a1)+,d0
	ext.w	d0
	bgt.w	.11A94
	neg.w	d0
	asl.w	#2,d0
	movea.l	#ControlCodeJumpTable,a2
	movea.l	0(a2,d0.w),a2
	jsr	(a2)
	bra.w	.1
.11A94
	cmp.b	#$40,d0
	bne.w	.11AA4
	move.w	#$7FF,d0
	bra.w	.11AD4
.11AA4
	cmp.b	#$5E,d0
	beq.w	.11AEA
	asl.w	#1,d0
	movea.l	#unk_AAC52,a2
	btst	#3,(word_FFC2F8).w
	beq.w	.11AC4
	movea.l	#unk_BE26A,a2
.11AC4
	adda.l	4(a2),a2
	move.w	4(a2,d0.w),d0
	move.w	(word_FFB030).w,d1
	add.w	0(a3,d1.w),d0
.11AD4
	add.w	d2,d0
	move.w	d0,(a0)
	addq.w	#1,(printx).w
.1
	dbf	d3,.0
	movem.l	(sp)+,d0-d3/a0/a2-a3
	move.w	(sp)+,(disflags).w
	rts
.11AEA
	addq.w	#1,(printx).w
	bsr.w	xyVmMap
	bra.s	.1
ControlCodeJumpTable	;IDA: unk_11AF4 (93 name). print2 control codes, indexed by -byte
	dc.l	rtss2		;0: padding, no-op
	dc.l	ControlCode_SetMap		;-1: map
	dc.l	ControlCode_SetAttribute		;-2: palette/priority
	dc.l	ControlCode_SetX		;-3: x
	dc.l	ControlCode_SetY		;-4: y
	dc.l	ControlCode_AddX		;-5: x offset
	dc.l	ControlCode_AddY		;-6: y offset
	dc.l	ControlCode_SetFont		;-7: char set
	dc.l	ControlCode_SetMapAndPosition		;-8: attribute, map, x, y
ControlCode_SetMapAndPosition	;93: print2 control code -8, next 4 bytes = attribute, map, x, y
	bsr.w	ControlCode_SetAttribute
	bsr.w	ControlCode_SetMap
	bsr.w	ControlCode_SetX
	bra.w	ControlCode_SetY
ControlCode_SetMap	;IDA: sub_11B28 (93 name). Control code -1, next byte = map number -> printm
	move.b	(a1)+,d0
	subq.w	#1,d3
	andi.w	#3,d0
	asl.w	#2,d0
	subq.w	#4,d0
	move.w	d0,(printm).w
	bra.w	xyVmMap
ControlCode_SetAttribute	;IDA: sub_11B3C (93 name). Control code -2, next byte = palette/priority -> printa
	move.b	(a1)+,d2
	andi.w	#7,d2
	subq.w	#1,d3
	ror.w	#3,d2
	move.w	d2,(printa).w
	rts
ControlCode_SetX	;IDA: sub_11B4C (93 name). Control code -3, next byte = printx
	clr.w	d0
	move.b	(a1)+,d0
	subq.w	#1,d3
	move.w	d0,(printx).w
	bra.w	xyVmMap
ControlCode_SetY	;IDA: loc_11B5A (93 name). Control code -4, next byte = printy
	clr.w	d0
	move.b	(a1)+,d0
	subq.w	#1,d3
	move.w	d0,(printy).w
	bra.w	xyVmMap
ControlCode_AddX	;93: control code -5, add the next (signed) byte to printx
	move.b	(a1)+,d0
	ext.w	d0
	subq.w	#1,d3
	add.w	d0,(printx).w
	bra.w	xyVmMap
ControlCode_AddY	;93: control code -6, add the next (signed) byte to printy
	move.b	(a1)+,d0
	ext.w	d0
	subq.w	#1,d3
	add.w	d0,(printy).w
	bra.w	xyVmMap
ControlCode_SetFont	;93: control code -7, next byte = char set index
	clr.w	d0
	move.b	(a1)+,d0
	subq.w	#1,d3
	asl.w	#1,d0
	move.w	d0,(word_FFB030).w
	rts
; see print
; string macro should follow jsr to this routine
printz
	move.l	a1,-(sp)
	movea.l	4(sp),a1
	bsr.w	print
	move.l	a1,4(sp)
	movea.l	(sp)+,a1
	rts
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
print
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	xyVmMap
	move.w	(printa).w,d2
	move.w	(a1)+,d3
	subq.w	#2,d3
	bra.w	.1
.0
	move.b	(a1)+,d0
	beq.w	.1
	ext.w	d0
	bpl.w	.nocom
	neg.w	d0
	move.w	d0,d2
	asl.w	#8,d2
	asl.w	#1,d2
	andi.w	#$F800,d2
	move.w	d2,(printa).w
	andi.w	#3,d0
	asl.w	#2,d0
	subq.w	#4,d0
	move.w	d0,(printm).w
	move.b	(a1)+,d0
	ext.w	d0
	move.w	d0,(printx).w
	move.b	(a1)+,d1
	ext.w	d1
	move.w	d1,(printy).w
	bsr.w	xyVmMap
	subq.w	#2,d3
	bra.w	.1
.nocom
	cmp.b	#$40,d0
	bne.w	.noblank
	move.w	#$7FF,d0
	bra.w	.p
.noblank
	cmp.b	#$5E,d0
	beq.w	.11C68
	asl.w	#1,d0
	movea.l	#unk_AAC52,a2
	btst	#3,(word_FFC2F8).w
	beq.w	.11C34
	movea.l	#unk_BE26A,a2
.11C34
	adda.l	4(a2),a2
	move.w	4(a2,d0.w),d0
	btst	#3,(word_FFC2F8).w
	beq.w	.11C4E
	add.w	(word_FFBF52).w,d0
	bra.w	.p
.11C4E
	add.w	(word_FFB012).w,d0
.p
	add.w	d2,d0	;for alternate palettes
	move.w	d0,(a0)
	addq.w	#1,(printx).w
.1
	dbf	d3,.0
	movem.l	(sp)+,d0-d3/a0/a2
	move.w	(sp)+,(disflags).w
	rts
.11C68
	addq.w	#1,(printx).w
	bsr.w	xyVmMap
	bra.s	.1
FormatAndPrintTime	;IDA: sub_11C72 (93 name). d0 bits 14-15 = period, bits 0-13 = seconds
	swap	d0
	clr.w	d0
	rol.l	#2,d0
	movea.l	#PeriodLabelTable,a1
	bsr.w	sub_13508
	addq.w	#2,(printx).w
	swap	d0
	lsr.w	#2,d0
	bsr.w	PushTime
	bra.w	print
PeriodLabelTable	;IDA: unk_11C92 (93 name). String list for FormatAndPrintTime: " 1", " 2", " 3", "OT"
	dc.w	4
	dc.b	' 1'
	dc.w	4
	dc.b	' 2'
	dc.w	4
	dc.b	' 3'
	dc.w	4
	dc.b	'OT'
; convert d0 into string format of min:sec
PushTime
	movea.w	#(unk_FFBFC2-M68K_RAM),a1
	move.l	d0,-(sp)
	move.l	a1,-(sp)
	ext.l	d0
	divu.w	#$A,d0
	swap	d0
	addi.w	#$30,d0
	move.b	d0,-(a1)
	swap	d0
	ext.l	d0
	divu.w	#6,d0
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
	beq.w	.11CEE
	addi.w	#$30,d0
	move.b	d0,(a1)
.11CEE
	move.l	(sp)+,d0
	sub.l	a1,d0
	addq.w	#2,d0
	btst	#0,d0
	beq.w	.11D00
	clr.b	-(a1)
	addq.w	#1,d0
.11D00
	move.w	d0,-(a1)
	move.l	(sp)+,d0
	rts
PushNumber
	movea.w	#(unk_FFC010-M68K_RAM),a1
	move.l	d0,-(sp)
	move.l	a1,-(sp)
.11D0E
	ext.l	d0
	divu.w	#$A,d0
	swap	d0
	addi.w	#$30,d0
	move.b	d0,-(a1)
	swap	d0
	tst.w	d0
	bne.s	.11D0E
	move.l	(sp)+,d0
	sub.l	a1,d0
	addq.w	#2,d0
	btst	#0,d0
	beq.w	.11D34
	clr.b	-(a1)
	addq.w	#1,d0
.11D34
	move.w	d0,-(a1)
	move.l	(sp)+,d0
	rts
PushNumberWidth	;IDA: DeterStrLength? (93 name). Right-justified number
	movem.l	d0-d3,-(sp)	;push to stack
	movea.w	#(unk_FFC00A-M68K_RAM),a1	;move address FFC00A into a1
	moveq	#1,d2	;move 1 into d2
	sub.w	d2,d1	;sub d2 from d1
	bra.w	.loop	;branch
.11D4A
	mulu.w	#$A,d2	;mult d2 by 10 dec
.loop
	dbf	d1,.11D4A	;exit when d1 is 0
	moveq	#$20,d3	;' '   ; move 20 into d3
.loop2
	ext.l	d0	;sign extend d0
	divu.w	d2,d0	;divide d2 into d0
	bne.w	.0	;branch if not equal
	cmp.w	#1,d2	;compare d2 to 1
	beq.w	.0	;branch if equal
	move.w	d3,d0	;move d3 into d0
	bra.w	.11D6E
.0
	;DeterStrLength?+26   j
	moveq	#$30,d3	;'0'   ; move 48 dec into d3
	add.w	d3,d0	;add d3 to d0
.11D6E
	move.b	d0,(a1)+	;move d0 into a1 and increment a1
	swap	d0	;swap d0 words
	divu.w	#$A,d2	;divide d2 by 10 dec
	bne.s	.loop2	;branch if not equal to 0
	move.l	a1,d0	;move a1 into d0
	subi.w	#$C008,d0	;sub C008 from d0
	btst	#0,d0	;test bit 0 of d0
	beq.w	.00
	clr.b	(a1)+	;clear byte at a1 and increment
	addq.w	#1,d0	;add 1 to d0
.00
	movea.w	#(unk_FFC008-M68K_RAM),a1	;move address FFC008 back into a1
	move.w	d0,(a1)	;move d0 into a1 address location
	movem.l	(sp)+,d0-d3	;push from stack
	rts
appendz
	movea.l	(sp)+,a1
	bsr.w	appstring
	jmp	(a1)
; append string a1 to string a3
appstring
	movem.l	d0/a0,-(sp)
	lea	2(a3),a0
	move.w	(a3),d0
	subq.w	#3,d0
	bmi.w	.11DB6
.11DAE
	addq.w	#1,a0
	tst.b	(a0)
	dbeq	d0,.11DAE
.11DB6
	move.w	(a1)+,d0
	subq.w	#3,d0
	bmi.w	.11DDC
.11DBE
	move.b	(a1)+,(a0)+
	bne.w	.11DC6
	subq.w	#1,a0
.11DC6
	dbf	d0,.11DBE
	move.l	a0,d0
	btst	#0,d0
	beq.w	.11DD8
	clr.b	(a0)+
	addq.l	#1,d0
.11DD8
	sub.l	a3,d0
	move.w	d0,(a3)
.11DDC
	movem.l	(sp)+,d0/a0
	rts
printbigz	;IDA: sub_11DE2 (93 name). String macro follows the call
	move.l	a1,-(sp)
	movea.l	4(sp),a1
	bsr.w	printbig
	move.l	a1,4(sp)
	movea.l	(sp)+,a1
	rts
printbig
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	movem.l	d0-d7/a0/a2,-(sp)
	move.w	(printx).w,d4
	move.w	(printy).w,d5
	move.w	(printa).w,d6
	add.w	(word_FFB010).w,d6
	move.w	(a1)+,d3
	subq.w	#2,d3
	bra.w	.11E78
.11E1A
	move.b	(a1)+,d0
	beq.w	.11E78
	ext.w	d0
	bpl.w	.11E5C
	neg.w	d0
	move.w	d0,d6
	asl.w	#8,d6
	asl.w	#1,d6
	andi.w	#$F800,d6
	move.w	d6,(printa).w
	add.w	(word_FFB010).w,d6
	andi.w	#3,d0
	asl.w	#2,d0
	subq.w	#4,d0
	move.w	d0,(printm).w
	move.b	(a1)+,d4
	ext.w	d4
	move.w	d4,(printx).w
	move.b	(a1)+,d5
	ext.w	d5
	move.w	d5,(printy).w
	subq.w	#2,d3
	bra.w	.11E78
.11E5C
	cmp.b	#$61,d0
	blt.w	.11E70
	cmp.b	#$7A,d0
	bgt.w	.11E70
	addi.b	#-$20,d0
.11E70
	move.w	d3,-(sp)
	bsr.w	sub_11E8E
	move.w	(sp)+,d3
.11E78
	dbf	d3,.11E1A
	move.w	d4,(printx).w
	move.w	d5,(printy).w
	movem.l	(sp)+,d0-d7/a0/a2
	move.w	(sp)+,(disflags).w
	rts
sub_11E8E
	subi.w	#$20,d0
	movea.l	#unk_1916A,a0
	moveq	#1,d2
	move.b	0(a0,d0.w),d1
	ext.w	d1
	bpl.w	.11EA8
	neg.w	d1
	clr.w	d2
.11EA8
	asl.w	#1,d1
	movea.l	#unk_A9A10,a0
	adda.l	4(a0),a0
.11EB4
	move.w	4(a0,d1.w),d3
	bsr.w	sub_11EDA
	move.w	(a0),d7
	asl.w	#1,d7
	add.w	d7,d1
	move.w	4(a0,d1.w),d3
	sub.w	d7,d1
	addq.w	#1,d5
	bsr.w	sub_11EDA
	subq.w	#1,d5
	addq.w	#1,d4
	addq.w	#2,d1
	dbf	d2,.11EB4
	rts
sub_11EDA
	add.w	d6,d3
	movem.l	d1/a0,-(sp)
	move.w	d5,d0
	movea.l	#$FFFFB004,a0
	adda.w	(printm).w,a0
	move.w	2(a0),d1
	asl.w	d1,d0
	add.w	d4,d0
	asl.w	#1,d0
	add.w	(a0),d0
	bsr.w	Vmaddr
	move.w	d3,(a0)
	movem.l	(sp)+,d1/a0
	rts
AddSmallFont	;IDA: sub_11F04 (93 name)
	move.w	d4,(word_FFB012).w
	movea.l	#unk_AAC5A,a2
	bra.w	DoDMA_clearCallbackPointer
AddFramer	;IDA: sub_11F12 (93 name)
	movea.l	#unk_55B86,a2
	move.w	d4,(framercset).w
	bra.w	DoDMA_clearCallbackPointer
AddTeamBlock	;IDA: sub_11F20 (93 name)
	moveq	#2,d4
	movea.l	#unk_ABA1C,a2
	bra.w	DoDMA_clearCallbackPointer
