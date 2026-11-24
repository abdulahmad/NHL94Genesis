ShowScores						;"Scores" screen: the other games of the night in gstruct over the Scores
	
	
	moveq	#$6,d0
	moveq	#$1A,d1
	bsr.w	SetupScreen
	jsr	(printz).l
	String	CC_Font3Pri,$5,$0
	moveq	#$1E,d0
	moveq	#$6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	CC_Font3Pri,$E,$3,'Scores',CC_Font3Pri,$B,$1
	movea.l	$47D58.l,a1
	lea.l	$8(a1),a2
	adda.l	jimdata(a1),a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	clr.w	d5
	jsr	(dobitmap).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$4,$0
	clr.w	(VertLineScrolling).l
	bsr.w	UpdateVertScrollReg
	jsr	(GetShifter).l
	move.w	d1,d3
	ble.w	.skip
.game	bsr.w	DisplayGameInfo
	dbra	d3,.game
.skip	clr.w	(SelectedPlayerIdx).l
	move.w	(printy).l,d0
	subi.w	#$15,d0
	bmi.w	.loop
	asl.w	#$3,d0
	move.w	d0,(SelectedPlayerIdx).l
	bsr.w	PrintGameInfoHeader
.loop	bsr.w	MenuWaitVblank
	bsr.w	ReadActiveJoypad
	btst	#$7,d3
	bne.w	StatsScreenFadeIn
	moveq	#-2,d0
	btst	#$0,d3
	bne.w	.set
	neg.w	d0
	btst	#$1,d3
	beq.w	.scroll
.set	move.w	d0,(PlayerScrollCtr).l
.scroll	bsr.w	UpdateScoresScroll
	bra.w	.loop
UpdateScoresScroll						;Called every frame by ShowScores: add PlayerScrollCtr to
	
	
	move.w	(PlayerScrollCtr).l,d0
	beq.w	rtss8
	add.w	(VertLineScrolling).l,d0
	bmi.w	rtss8
	cmp.w	(SelectedPlayerIdx).l,d0
	bgt.w	rtss8
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divu.w	#$18,d0
	swap	d0
	tst.w	d0
	bne.w	UpdateVertScrollReg
	bsr.w	PrintGameInfoHeader
	clr.w	(PlayerScrollCtr).l
; Sets up the VDP DMA write for the scores scroll.
UpdateVertScrollReg	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$C00000,a0
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	move.w	#$FFD0,d0
	add.w	(VertLineScrolling).l,d0
.loop4	btst	#$7,$FF800E.l
	bne.b	.loop4
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
.loop5	btst	#$6,$FF800E.l
	beq.b	.loop5
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	bne.b	.loop6
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
DisplayGameInfo	cmp.w	(gamenum).l,d3
	beq.w	rtss8
	moveq	#gssize,d0
	mulu.w	d3,d0
	movea.l	#gstruct,a0
	adda.w	d0,a0
	btst	#gsfhl,gsflags(a0)
	bne.w	rtss8
	btst	#gsfso,gsflags(a0)
	bne.w	rtss8
	move.w	gst2(a0),d0
	move.w	gss2(a0),d1
	bsr.w	PrintGameInfo
	addi.w	#$1,(printy).l
	move.w	$0(a0),d0
	move.w	gss1(a0),d1
	bsr.w	PrintGameInfo
	move.w	gsper(a0),d0
	subi.w	#$1,d0
	movea.l	#PerLabels,a1
	move.w	#$1C,(printx).l
	jsr	(Fprintsmall).l
	addi.w	#$2,(printy).l
	rts
PrintGameInfo						;Print team d0's name (TeamList) at x 6 and score d1 (2 digits) at x $18
	movea.l	#TeamList,a1
	asl.w	#$2,d0
	movea.l	(a1,d0.w),a1
	adda.w	$4(a1),a1
	move.w	#$6,(printx).l
	jsr	(print).l
	move.w	#$18,(printx).l
	move.w	d1,d0
	moveq	#$2,d1
	jsr	(PushNumberWidth).l
	jmp	(print).l
; Prints the game info header.
PrintGameInfoHeader	movem.l	d0-d1/a1,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$4,$6,CC_SetFont,$1
	clr.w	d0
	move.w	(VertLineScrolling).l,d1
	tst.w	d1
	sgt.b	d0
	neg.b	d0
	cmp.w	(SelectedPlayerIdx).l,d1
	slt.b	d1
	neg.b	d1
	add.b	d1,d0
	add.b	d1,d0
	lea.l	.next(pc),a1
	jsr	(Fprintsmall).l
	movem.l	(sp)+,d0-d1/a1
	rts
; Table of 32 words after PrintGameInfoHeader, 64 bytes: $000A,$20FB,$FFFA,$1320,$F900,$000A ...
.next	dc.w	$000A,$20FB,$FFFA,$1320,$F900,$000A,$7BFB,$FFFA
	dc.w	$1320,$F900,$000A,$20FB,$FFFA,$137D,$F900,$08EA
LineEditor
	dc.w	$0000,$0032,$7000,$721C,$6100,$1DEA,$4279,$0001
	dc.w	$A44E,$4279,$0001,$A452,$33FC,$0001,$0001,$A45A
; Prints the game info lines in the small font
PrintGameInfoBody
	jsr	(printsmallz).l
; Inline data read by printsmallz from the return address (2 rows).
	dc.w	$0008
	dc.b	$FF,$02,$FD,$00,$FC,$00
	moveq	#$28,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	st.b	(redrawicons).l
	bsr.w	ClearLineEditorMarks
LineEditorMenu						;Slot cursor loop: start exits, C picks a player for the slot
	
	
	
	bsr.w	DrawTeamScreen
	bsr.w	DrawLineIcons
.loop	bsr.w	MenuWaitVblank
	bsr.w	ReadActiveJoypad
	jsr	(ProcessInputWithRepeat).l
	btst	#$7,d1
	bne.w	LineEditorExit
	btst	#$5,d1
	bne.w	SelectLinePlayer
	moveq	#$1,d0
	btst	#$1,d1
	bne.w	.move
	moveq	#-1,d0
	btst	#$0,d1
	bne.w	.move
	moveq	#$8,d0
	btst	#$3,d1
	bne.w	.move
	moveq	#-8,d0
	btst	#$2,d1
	beq.w	.loop
.move	add.w	(TestList).l,d0
	tst.w	(OptLine).l
	beq.w	.set
	cmpi.w	#$1,d0
	blt.w	.loop
	cmpi.w	#$5,d0
	bgt.w	.loop
.set	lea.l	LineCursorTable(pc),a0
	move.b	$8(a0,d0.w),(TestList+1).l		;wrap/skip through the table
	bsr.w	DrawLineIcons
	bra.w	.loop
SelectLinePlayer						;Line editor: C pressed on slot TestList. Build the list of players that
	
	
	
	
	bsr.w	GetGoalieCount
	move.w	d0,d1
	bsr.w	GetForwardCount
	move.w	(TestList).l,d2
	andi.w	#$7,d2
	cmpi.w	#$2,d2
	bgt.w	.n
	add.w	d0,d1
	bsr.w	GetPlayerCount
	sub.w	d1,d0
.n	subi.w	#$1,d0
	move.w	d0,(screentimer).l
	clr.w	(PlayerScrollCtr).l
	clr.w	(VertLineScrolling).l
	movea.l	#Satt,a0
	clr.w	d2
.fill	move.b	d1,(a0,d2.w)
	cmp.w	d1,d6
	bne.w	.nc
	move.w	d2,(VertLineScrolling).l
.nc	addi.w	#$1,d1
	addi.w	#$1,d2
	dbra	d0,.fill
	bsr.w	ClearLineEditorTop
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$0,$3,$1,$0
	moveq	#$12,d0
	moveq	#$3,d1
	jsr	(Framer).l
	jsr	(printsmallz).l
	String	CC_Font3,$15,$FC
	moveq	#$12,d0
	moveq	#$3,d1
	jsr	(Framer).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$2,$1,'{Select  Player}'
	clr.w	d0
	bra.w	.vert
.loop	bsr.w	MenuWaitVblank
	bsr.w	ReadActiveJoypad
	jsr	(ProcessInputWithRepeat).l
	btst	#$7,d1
	bne.w	LineEditorMenu
	btst	#$5,d1
	bne.w	.next
	moveq	#$1,d0
	btst	#$1,d1
	bne.w	.vert
	btst	#$3,d1
	bne.w	.horz
	moveq	#-1,d0
	btst	#$0,d1
	bne.w	.vert
	btst	#$2,d1
	bne.w	.horz
	bra.w	.loop
.horz	add.w	(scoutcolumn).l,d0
	bmi.w	.loop
	move.w	d0,(scoutcolumn).l
	bsr.w	PrintAttribHeader
	bra.w	.loop
.vert	add.w	(VertLineScrolling).l,d0
	bmi.w	.loop
	cmp.w	(screentimer).l,d0
	bgt.w	.loop
	move.w	d0,(VertLineScrolling).l
	cmp.w	(PlayerScrollCtr).l,d0
	bgt.w	.top
	move.w	d0,(PlayerScrollCtr).l
.top	subi.w	#$5,d0
	cmp.w	(PlayerScrollCtr).l,d0
	ble.w	.draw
	move.w	d0,(PlayerScrollCtr).l
.draw	bsr.w	PrintAttribHeader
	bra.w	.loop
.next	movea.l	#Satt,a3
	adda.w	(VertLineScrolling).l,a3
	move.b	(a3),d0
	addi.b	#$1,d0		;SetLineSlot wants 1 based
	move.w	(TestList).l,d2
	bsr.w	SetLineSlot		;put the picked player in the slot
	bra.w	LineEditorMenu		;back to the slot cursor
PrintAttribHeader						;Line editor player list: the column header of attribute page
	
	
	jsr	(printz).l
	String	CC_Font2Pri,$16,$1
.top	movea.l	#PAttribColumns,a1
	move.w	(scoutcolumn).l,d0
	bra.w	.2
.next	adda.w	(a1),a1
	adda.w	#$4,a1
.2	tst.w	(a1)
	dbmi	d0,.next
	bpl.w	.found
	subi.w	#$1,(scoutcolumn).l
	bra.w	.top
.found	jsr	(print).l
	move.l	(a1),d4
	movea.l	#Satt,a3
	move.w	(PlayerScrollCtr).l,d2
	move.w	(screentimer).l,d1
	sub.w	d2,d1
	cmpi.w	#$5,d1
	bls.w	.4
	moveq	#$5,d1
.4	move.w	#$2,(printy).l
.row	jsr	(printsmallz).l
; Inline data read by printsmallz from the return address (2 rows).
	dc.w	$0020
	dc.b	$FE,$04,$FD,$05,$FA,$01,'                      ',$FD,$05
	cmp.w	(VertLineScrolling).l,d2
	bne.w	.5
	move.w	d7,(printa).l
.5	clr.w	d0
	move.b	(a3,d2.w),d0
	bsr.w	GetNameandAttrib
	addi.w	#$1,d2
	dbra	d1,.row
	rts
DrawLineIcons						;Line editor: draw the line icons for the cursor's line (LineIconGroups
	
	moveq	#$6,d5		;7 lines
	lea	LineIconGroups(pc),a0
	move.w	(TestList).l,d0
	lsr.w	#$3,d0
	adda.w	d0,a0
	tst.w	(OptLine).l
	beq.w	.0
	suba.w	#$1,a0
.0	move.b	(a0),d0
	cmp.b	(redrawicons).l,d0
	beq.w	.line
	move.b	d0,(redrawicons).l
	bsr.w	DrawLineIconErase
.line	btst	d5,(redrawicons).l
	beq.w	.next
	bsr.w	DrawLineIcon
.next	dbra	d5,.line
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$8,$7,CC_SetFont,$1
	moveq	#$18,d0
	moveq	#$3,d1
	jsr	(Framer).l
	jsr	(printsmallz).l
	String	CC_Font3,$15,$FC,$8
	move.w	d6,d0
	jsr	(getname).l
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	move.w	d7,(printa).l
	jsr	(printsmall).l
	clr.w	(printfontset).l
	rts
	dc.b	$1		;the entry before LineIconGroups (read with OptLine set)
LineIconGroups						;Per line: bit mask of the lines drawn together
	dc.b	$7,$7,$7,$18,$18,$60,$60
DrawLineIcon						;Line editor: draw line d5 (its name from linelist, then its player slots)
	
	moveq	#$6,d0
	mulu.w	d5,d0
	lea.l	LineIconPosTable(pc),a0
	adda.w	d0,a0
	tst.w	(OptLine).l
	beq.w	.0
	suba.w	#$6,a0
.0	move.w	(a0),(printx).l
	move.w	$2(a0),(printy).l
	move.w	d5,d0
	movea.l	#linelist,a1
	move.w	#$8000,(printa).l
	jsr	(Fprintsmall).l
	jsr	(printsmallz).l
	String	' Line'
	move.w	(a0),(printx).l
	move.w	d5,d4
	asl.w	#$3,d4
	addi.w	#$1,d4
	move.w	$2(a0),(printy).l
	move.w	$4(a0),d3
	lea.l	$16C(a2),a3
.slot	move.w	(a0),(printx).l
	jsr	(printsmallz).l
; Inline data read by printsmallz from the return address (2 rows).
	dc.w	$0008
	dc.b	$FB,$FF,$FA,$02,$FE,$06
	clr.w	d0
	move.b	(a3,d4.w),d0
	subi.w	#$1,d0
	jsr	(FormatPlayerNameShort).l
	cmp.w	(TestList).l,d4
	bne.w	.nocur
	move.w	d0,d6
	move.w	(printa).l,d7
	move.w	#$2,(printfontset).l
.nocur	jsr	(printsmall).l
	clr.w	(printfontset).l
	addi.w	#$1,d4
	dbra	d3,.slot
	rts
; Erases the line icon area after printing.
DrawLineIconErase
	jsr	(printsmallz).l
; Inline data read by printsmallz from the return address (2 rows).
	dc.w	$0008
	dc.b	$FF,$02,$FD,$00,$FC,$0A
	moveq	#$28,d0
	moveq	#$12,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	$2CE96.l,(printy).l
	move.w	(LineIconPosTable).l,(printx).l
	tst.w	(OptLine).l
	beq.w	.next
	move.w	ClearLineEditorTopData.l,(printx).l
.next	jsr	(printsmallz).l
; Inline data read by printsmallz from the return address (2 rows).
	dc.w	$0022
	dc.b	$FE,$04,$FB,$FD,$FA,$02,$4C,$44,$FB,$FE,$FA,$02,$52,$44,$FB,$FE,$FA,$02,$4C,$57,$FB,$FE,$FA,$02,$43,$20,$FB,$FE,$FA,$02,$52,$57
	rts
DrawTeamScreen						;Line editor background: bitmap (EASportsBGMap), frame, "Line Editor"
	
	
	bsr.w	ClearLineEditorTop
	movem.l	d0-d5/a0-a2,-(sp)
	jsr	(printz).l
	String	CC_Font3,$0,$0
	movea.l	(EASportsBGMap).l,a1
	adda.l	jimdata(a1),a1
	movea.l	#null,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	moveq	#$1,d4
	moveq	#$0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d5/a0-a2
	jsr	(printz).l
	String	CC_Font2Pri,$7,$1
	moveq	#$1A,d0
	moveq	#$6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	CC_Font2Pri,$A,$4,'Line Editor',CC_Font2Pri,$E,$1
	clr.w	d0
	cmpa.l	#tmstruct,a2
	beq.w	PutTeamBlock
	moveq	#$2C,d0
	bra.w	PutTeamBlock
ClearLineEditorTop						;Erase 40 x 10 at the top of map 2
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	moveq	#$28,d0
	moveq	#$A,d1
	move.w	#$7FF,d2
	jmp	(eraser).l
; Clears two marker words.
ClearLineEditorMarks
	clr.w	(palfadenew+$5A).l
	clr.w	(palfadenew+$7A).l
	rts
; Data that follows ClearLineEditorTop (strings, small tables)
ClearLineEditorTopData	dc.w	$0010,$000C,$0004
LineIconPosTable					;Line icons: x, y, slot count - 1 per line
	dc.w	4,$C,4					;at +2
	dc.w	$10,$C,4
	dc.w	$1C,$C,4
	dc.w	4,$C,4
	dc.w	$10,$C,4
	dc.w	4,$C,3
	dc.w	$10,$C,3
	dc.w	$FFFF
LineCursorTable						;The slot after a cursor move: indexed by slot + 8 (up / down / left /
	
; Table of 48 words after LineCursorTable, 72 bytes: $0101,$0203,$0405,$1901,$0101,$0203 ...
	dc.w	$0101,$0203,$0405,$1901,$0101,$0203,$0405,$1901
	dc.w	$0909,$0A0B,$0C0D,$2101,$1111,$1213,$1415,$2101
	dc.w	$0519,$1A1B,$1C1D,$2901,$0D21,$2223,$2425,$3101
	dc.b	$1D,')*+,,',$01,$01,'%12344',$01,$01
	dc.b	'%12344',$01,$01
LineEditorExit
	bsr.w	ClearLineEditorMarks
	move.w	#$18,(palcount).l
.loop	tst.w	(palcount).l
	bpl.w	.loop
	move.l	(menuitem).l,-(sp)
	move.l	(menulist).l,-(sp)
	move.l	(menudraw).l,-(sp)
	movea.l	#rtss2,a1
	movea.l	#LineEditorMenuText,a0
	movea.l	#databuffer,a3
	move.w	tmteam(a2),d0
	addi.w	#$1,d0
	cmp.b	(a3),d0
	beq.w	.0
	movea.l	#LineEditorMenuNoLoad,a0
.0	jsr	(printsmallz).l
	String	CC_Font1,$2
	bsr.w	Pausemode_top
.loop2	bsr.w	MenuWaitVblank
	bsr.w	ReadActiveJoypad
	jsr	(ProcessInputWithRepeat).l
	move.w	d1,-(sp)
	bsr.w	HandleMenuInput
	move.w	(sp)+,d1
	andi.w	#$A0,d1
	beq.w	.loop2
	jsr	(printsmallz).l
	String	CC_SetFont
	move.w	(menuitem).l,d0
	move.l	(sp)+,(menudraw).l
	move.l	(sp)+,(menulist).l
	move.l	(sp)+,(menuitem).l
	tst.w	d0
	bne.w	PrintGameInfoBody
	bra.w	StatsScreenFadeIn
SetLineSlot						;Put player d0 (1 based) in line slot d2 of team a2; if he is already in
	
	movem.l	d0-d2/a0-a1,-(sp)
	lea.l	$16C(a2),a0
	move.w	d2,d1
	andi.w	#$FFF8,d1
	lea.l	(a0,d1.w),a1
	moveq	#$5,d1
.find	cmp.b	$1(a1,d1.w),d0
	dbeq	d1,.find
	bne.w	.put
	move.b	(a0,d2.w),$1(a1,d1.w)
.put	move.b	d0,(a0,d2.w)
	movem.l	(sp)+,d0-d2/a0-a1
	rts
DecodeTeamLines						;Load team a2's lines from databuffer: byte 0 = team + 1, then one nibble
	
	
	movem.l	d0-d4/a0/a3,-(sp)
	movea.l	#databuffer,a0
	adda.w	#$1,a0
	bsr.w	GetGoalieCount
	move.w	d0,d1
	bsr.w	GetForwardCount
	move.w	d0,d3
	movea.l	#AttributeOffsetTbl,a3
	clr.w	d4
	clr.w	d2
.next	move.b	(a3),d2
	bmi.w	.done
	bchg	#$0,d4
	bne.w	.hi
	move.b	(a0),d0
	bra.w	.nib
.hi	move.b	(a0)+,d0
	lsr.w	#$4,d0
.nib	andi.w	#$F,d0
	add.b	d1,d0
	andi.w	#$7,d2
	cmpi.w	#$2,d2
	bgt.w	.store
	add.b	d3,d0
.store	addi.b	#$1,d0
	andi.w	#$FF,d0
	move.b	(a3)+,d2
	bsr.w	SetLineSlot
	bra.w	.next
.done	movem.l	(sp)+,d0-d4/a0/a3
	rts
EncodeTeamLines						;Reverse of DecodeTeamLines: pack team a2's lines into databuffer and
	
	movem.l	d0-d4/a0-a3,-(sp)
	movea.l	#databuffer,a0
	move.w	tmteam(a2),d0
	addi.w	#$1,d0
	move.b	d0,(a0)+
	lea.l	$16C(a2),a1
	bsr.w	GetGoalieCount
	move.w	d0,d1
	bsr.w	GetForwardCount
	movea.l	#AttributeOffsetTbl,a3
	clr.w	d4
	clr.w	d2
.next	move.b	(a3)+,d2
	bmi.w	.done
	move.b	(a1,d2.w),d3
	subi.b	#$1,d3
	sub.b	d1,d3
	andi.w	#$7,d2
	cmpi.w	#$2,d2
	bgt.w	.pack
	sub.b	d0,d3
.pack	bchg	#$0,d4
	bne.w	.hi
	move.b	d3,(a0)
	bra.w	.next
.hi	asl.b	#$4,d3
	or.b	d3,(a0)+
	bra.w	.next
.done	jsr	(WriteLineData).l
	movem.l	(sp)+,d0-d4/a0-a3
	rts
AttributeOffsetTbl						;Line slots saved in databuffer ($FF ends)
; Data that follows AttributeOffsetTbl (strings, small tables)
AttributeOffsetTblData	dc.w	$0102,$0304,$0509,$0A0B,$0C0D,$1112,$1314,$1519
	dc.b	$1A,$1B,$1C,$1D,'!"#$%)*+,123'
	dc.w	$34FF
TeamRosterScreen						;"Team Roster" screen for team a2: pages of players (DisplayPlayerList:
	
	
	moveq	#$D,d0
	moveq	#$17,d1
	bsr.w	SetupScreen
	moveq	#$1,d0
	add.w	tmline(a2),d0
	move.w	d0,(SelectedPlayerIdx).l
	clr.w	(scoutcolumn).l
.redraw	jsr	(printz).l
	String	CC_Font3Pri,$7,$1
	moveq	#$1A,d0
	moveq	#$6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	CC_Font3Pri,$9,$4,'Team  Roster',CC_Font3Pri,$E,$1
	clr.w	d0
	cmpa.l	#tmstruct,a2
	beq.w	.home
	moveq	#$2C,d0
.home	bsr.w	PutTeamBlock
	jsr	(printsmallz).l
; Inline data read by printsmallz from the return address (2 rows).
	dc.w	$0034
	dc.b	$F8,$06,$03,$02,$0C,$F9,$01,'Pos.^Player',$FD,$1E,$FC,$0C,'Rating',$FD,$0C,$FC,$1A,'A^-^Switch^Teams',$F9,$00
	jsr	(printz).l
	String	CC_Font3Pri,$1,$8
	moveq	#$12,d0
	moveq	#$3,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	CC_Font3Pri,$15,$8
	moveq	#$12,d0
	moveq	#$3,d1
	jsr	(Framer).l
	bsr.w	PlayerListDrawSelected
	move.w	(SelectedPlayerIdx).l,d0
	mulu.w	#$80,d0
	move.w	d0,(VertLineScrolling).l
	bsr.w	UpdatePlayerListScroll
	clr.w	(PlayerScrollCtr).l
.loop	bsr.w	MenuWaitVblank
	bsr.w	ReadActiveJoypad
	jsr	(ProcessInputWithRepeat).l
	btst	#$7,d3
	bne.w	StatsScreenFadeIn
	btst	#$6,d1
	bne.w	.team
	jsr	(nodiag).l
	moveq	#$1,d0
	btst	#$3,d1
	bne.w	.col
	neg.w	d0
	btst	#$2,d1
	bne.w	.col
	tst.w	(PlayerScrollCtr).l
	bne.w	.scroll
	moveq	#-2,d0
	btst	#$0,d3
	bne.w	.set
	neg.w	d0
	btst	#$1,d3
	beq.w	.scroll
.set	move.w	d0,(PlayerScrollCtr).l
.scroll	bsr.w	CheckPlayerListScroll
	bra.w	.loop
.col	add.w	(scoutcolumn).l,d0
	bmi.w	.scroll
	move.w	d0,(scoutcolumn).l
	bsr.w	PlayerListDrawSelected
	bra.w	.scroll
.team	lea.l	$366(a2),a2
	cmpa.l	#awtmstruct,a2
	beq.w	.redraw
	movea.l	#tmstruct,a2		;away -> back to home
	bra.w	.redraw
CheckPlayerListScroll						;TeamRosterScreen per frame: add PlayerScrollCtr to VertLineScrolling (0
	
	move.w	(PlayerScrollCtr).l,d0
	beq.w	rtss8
	add.w	(VertLineScrolling).l,d0
	bmi.w	StopPlayerListScroll
	cmpi.w	#$380,d0
	bgt.w	StopPlayerListScroll
; Scrolling step in units of $80.
UpdatePlayerListScroll
	move.w	(VertLineScrolling).l,d1
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divs.w	#$80,d0
	swap	d0
	tst.w	d0
	bne.w	.next
	clr.w	(PlayerScrollCtr).l
.next	andi.w	#$7F,d1
	bne.w	.next3
	cmpi.w	#$7E,d0
	bne.w	.next2
	bsr.w	DisplayPlayerListUp
.next2	cmpi.w	#$2,d0
	bne.w	.next3
	bsr.w	DisplayPlayerListDown
.next3	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$C00000,a0
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	move.w	#$FF90,d0
	add.w	(VertLineScrolling).l,d0
.loop4	btst	#$7,$FF800E.l
	bne.b	.loop4
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
.loop5	btst	#$6,$FF800E.l
	beq.b	.loop5
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	bne.b	.loop6
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
; Clears the player list scroll counter
StopPlayerListScroll	clr.w	(PlayerScrollCtr).l
	rts
; Selects the player from the high word of d0 and redraws.
DisplayPlayerListUp	move.l	d0,-(sp)
	swap	d0
	move.w	d0,(SelectedPlayerIdx).l
	bsr.w	PlayerListDrawSelected
	move.l	(sp)+,d0
	rts
; Selects the player after the high word of d0 and redraws.
DisplayPlayerListDown	move.l	d0,-(sp)
	swap	d0
	addi.w	#$1,d0
	move.w	d0,(SelectedPlayerIdx).l
	bsr.w	PlayerListDrawSelected
	move.l	(sp)+,d0
	rts

; Draws the selected player's entry.
PlayerListDrawSelected
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$7,$3,$2,$9,CC_SetFont,$1
	move.w	(SelectedPlayerIdx).l,d0
	lea	PlayerStatMenuTxt(pc),a1
	jsr	(AdvanceStringPtr).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	CC_Font3,$16,$FC,$9
.loop	movea.l	#PAttribColumns,a1
	move.w	(scoutcolumn).l,d0
	tst.w	(SelectedPlayerIdx).l
	bne.w	.next
	movea.l	#GAttribColumns,a1
	bra.w	.next
.loop2	adda.w	(a1),a1
	adda.w	#$4,a1
.next	tst.w	(a1)
	dbmi	d0,.loop2
	bpl.w	.next2
	subi.w	#$1,(scoutcolumn).l
	bra.w	.loop
.next2	jsr	(printsmall).l
	move.l	(a1),d4
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$0,$0,CC_SetFont,$0
	btst	#$0,(SelectedPlayerIdx+1).l
	beq.w	.next3
	addi.w	#$10,(printy).l
.next3	move.w	(printy).l,-(sp)
	moveq	#$28,d0
	moveq	#$10,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	(sp)+,(printy).l
	bsr.w	GetGoalieCount
	move.w	d0,d1
	subi.w	#$1,d1
	movea.l	#GoalieRowText,a5
	movea.l	#Satt,a3
	move.l	#$1020304,(a3)
	move.w	(SelectedPlayerIdx).l,d0
	subi.w	#$1,d0
	bmi.w	.loop3
	asl.w	#$3,d0
	lea.l	$16C(a2),a3
	lea.l	$1(a3,d0.w),a3
	movea.l	#PlayerPositionText,a5
	moveq	#$4,d1
	cmpi.w	#$5,(SelectedPlayerIdx).l
	ble.w	.loop3
	subi.w	#$1,d1
.loop3	move.w	#$2,(printx).l
	movea.l	a5,a1
	jsr	(print).l
	movea.l	a1,a5
	move.w	#$7,(printx).l
	clr.w	d0
	move.b	(a3)+,d0
	subi.w	#$1,d0
	bsr.w	GetNameandAttrib
	addi.w	#$2,(printy).l
	dbra	d1,.loop3
	rts
GoalieRowText						;Position text for the goalie rows
	String	'G'
	String	'G'
	String	'G'
	String	'G'
PlayerStatMenuTxt					;Roster page titles; { } are the left / right arrows
	String	'    Goalies    }'
	String	'{  Scoring  1  }'
	String	'{  Scoring  2  }'
	String	'{   Checking   }'
	String	'{ Power Play 1 }'
	String	'{ Power Play 2 }'
	String	'{Penalty Kill 1}'
	String	'{Penalty Kill 2 '
GetNameandAttrib						;Print player d0's name, then at x $1E the column d4 picks (attribjmp;
									;above 2 a rating through CalcAttrib, high ROM). Saves d0-d4/a0-a1/a4-a5
	movem.l	d0-d4/a0-a1/a4-a5,-(sp)
	pea	.x(pc)		;handlers return here
	jsr	(getname).l
	jsr	(print).l
	move.w	#$1E,(printx).l
	cmpi.w	#$2,d4		;status or energy column?
	bls.w	.jump
	jsr	(CalcAttrib).l
	swap	d4
.jump	lea	attribjmp(pc),a0		;column handler for d4
	adda.w	(a0,d4.w),a0
	jmp	(a0)
.x	movem.l	(sp)+,d0-d4/a0-a1/a4-a5		;exit: restore the registers
	rts
attribjmp							;GetNameandAttrib column handlers, offsets from attribjmp
	dc.w	AttribStatus-attribjmp
	dc.w	AttribEnergy-attribjmp
	dc.w	AttribHanded-attribjmp
	dc.w	AttribWeight-attribjmp
	dc.w	AttribFighting-attribjmp
	dc.w	AttribRating-attribjmp
AttribStatus						;Player d0's tmpdst word: Ice, Bench, injured, or penalty time
	add.w	d0,d0
	move.w	tmpdst(a2,d0.w),d0		;his status
	bpl.w	.pen		;positive: serving a penalty
	not.w	d0
	cmpi.w	#$3,d0		;valid?
	bls.w	.st
	moveq	#$1,d0		;anything else shown as Bench
	bra.w	.st
.inj	moveq	#$3,d0		;injured: status 3
.st	lea	StatusTextTbl(pc),a1		;print the status text
	jmp	(Fprintsmall).l
.pen	btst	#$C,d0		;penalty time, or injured goalie (bit $C)
	bne.w	.inj
	subi.w	#$1,(printx).l
	move.w	d0,d1
	andi.w	#$FFF,d0		;penalty time
	jsr	(PushTime).l
	jsr	(print).l
	moveq	#$4,d0		;string 4 = blank padding
	bclr	#$E,d1		;bit $E: prints C
	beq.w	.t
	moveq	#$5,d0		;string 5 = ' C  '
.t	lea	StatusTextTbl(pc),a1
	jmp	(Fprintsmall).l
StatusTextTbl						;AttribStatus Strings
	String	'Ice     '
	String	'Bench   '
	String	'Injury P'
	String	'Injury G'
	String	'    '
	String	' C  '
AttribEnergy						;Energy: tmpde(a2) word / 40, at most 100 (AttribPrintPct)
	add.w	d0,d0
	move.w	tmpde(a2,d0.w),d0		;his energy
	ext.l	d0
	divu.w	#$28,d0
	cmpi.w	#$64,d0		;over 100?
	ble.w	AttribPrintPct
	moveq	#$64,d0
	bra.w	AttribPrintPct		;print it
AttribFighting						;Bit 0 of the nibble is the handedness: drop it, then a rating out of d1 - 1
	andi.w	#$E,d0
	subi.w	#$1,d1
AttribRating						;d0 * 100 / d1, adjusted (AttribAdjust); falls into AttribPrintPct
	mulu.w	#$64,d0
	divu.w	d1,d0
	jsr	(AttribAdjust).l
AttribPrintPct						;Print d0 4 wide, then 4 blanks
	moveq	#$4,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	'    '
	rts
AttribHanded						;Bit 0 of the sum: Righty / Lefty (HandedTextTbl)
	andi.w	#$1,d0
	eori.w	#$1,d0		;0 Righty, 1 Lefty
	lea	HandedTextTbl(pc),a1
	jmp	(Fprintsmall).l
HandedTextTbl						;AttribHanded Strings
	String	'Righty  '
	String	'Lefty   '
AttribWeight						;Weight: 140 + 8 * rating lb
	asl.w	#$3,d0
	addi.w	#$8C,d0		;add 140 lbs (minimum weight)
	jsr	(PushNumber).l
	jsr	(print).l
	jsr	(printz).l
	String	' lb  '
	rts
ScoringSummaryScreen						;"Scoring Summary": one 4 row entry per goal (6 bytes each from ScoreSum),
									;scrolled with up / down, start exits. Menu item handler
	moveq	#$A,d0		;SetupScreen d0/d1: row offset / height
	moveq	#$1A,d1
	bsr.w	SetupScreen		;set up the screen
	jsr	(printz).l
	String	CC_Font3Pri,$4,$1
	moveq	#$20,d0
	moveq	#$6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	CC_Font3Pri,$6,$4,'Scoring Summary',CC_Font3Pri,$7,$1
	moveq	#$2C,d0
	bsr.w	PutTeamBlock
	addi.w	#$4,(printx).l		;4 columns right
	clr.w	d0
	bsr.w	PutTeamBlock
	jsr	(printsmallz).l
; Inline data read by printsmallz from the return address (2 rows).
	dc.w	$0034
	dc.b	$F8,$06,$03,$00,$08,$F9,$01,'^Per^^Time^^Tm^^Goal/Assist^^^^^^^^P/S^^',$F9,$00,$00
	clr.l	d0
	move.w	(ScoreSumbytes).l,d0
	divu.w	#$6,d0		;goals
	asl.w	#$5,d0		;32 pixels per entry
	move.w	d0,(VertLineScrolling).l		;start at the end
	subi.w	#$80,d0		;4 entries fit on screen
	bpl.w	.0
	clr.w	d0
.0	move.w	d0,(SelectedPlayerIdx).l
	move.w	(VertLineScrolling).l,d0		;start position
.toend	bsr.w	MenuWaitVblank		;wait for the next frame
	bsr.w	UpdateScoringScroll
	move.w	(VertLineScrolling).l,d0		;position
	subi.w	#$2,d0
	cmp.w	(SelectedPlayerIdx).l,d0		;reached the limit?
	bge.w	.toend
	clr.w	(PlayerScrollCtr).l
.loop	bsr.w	MenuWaitVblank		;wait for the next frame
	bsr.w	ReadActiveJoypad		;read the pads
	btst	#$7,d3		;start: leave
	bne.w	StatsScreenFadeIn
	moveq	#-2,d0
	btst	#$0,d3		;up?
	bne.w	.set
	neg.w	d0
	btst	#$1,d3		;down?
	beq.w	.scroll
.set	move.w	d0,(PlayerScrollCtr).l
.scroll	bsr.w	CheckScoringScroll
	bra.w	.loop
CheckScoringScroll						;ScoringSummaryScreen per frame: add PlayerScrollCtr to VertLineScrolling
									;(0 ... SelectedPlayerIdx). Falls into UpdateScoringScroll
	move.w	(PlayerScrollCtr).l,d0
	beq.w	rtss8
	add.w	(VertLineScrolling).l,d0		;new position
	bmi.w	rtss8		;above the top: ignore
	cmp.w	(SelectedPlayerIdx).l,d0		;past the limit?
	bgt.w	rtss8
; Scrolling step in units of $20.
UpdateScoringScroll	move.w	(VertLineScrolling).l,d1
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divs.w	#$20,d0
	swap	d0
	tst.w	d0
	bne.w	.next
	bsr.w	PenaltyEntryHeader
	clr.w	(PlayerScrollCtr).l
.next	andi.w	#$1F,d1
	bne.w	.next3
	move.l	d0,-(sp)
	cmpi.w	#$1E,d0
	bne.w	.next2
	bsr.w	DrawScoringRowUp
.next2	move.l	(sp)+,d0
	cmpi.w	#$2,d0
	bne.w	.next3
	bsr.w	DrawScoringRowDown
.next3	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$C00000,a0
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	moveq	#-80,d0
	add.w	(VertLineScrolling).l,d0
.loop4	btst	#$7,$FF800E.l
	bne.b	.loop4
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
.loop5	btst	#$6,$FF800E.l
	beq.b	.loop5
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	bne.b	.loop6
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
DrawScoringRowUp	move.l	d0,-(sp)
	swap	d0
	moveq	#$6,d3
	mulu.w	d0,d3
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	move.w	(VertLineScrolling).l,d0
	lsr.w	#$3,d0
	subi.w	#$3,d0
	andi.w	#$1F,d0
	move.w	d0,(printy).l
	bsr.w	DrawScoringRow
	move.l	(sp)+,d0
	rts
DrawScoringRowDown	move.l	d0,-(sp)
	swap	d0
	addi.w	#$4,d0
	moveq	#$6,d3
	mulu.w	d0,d3
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	move.w	(VertLineScrolling).l,d0
	lsr.w	#$3,d0
	addi.w	#$10,d0
	andi.w	#$1F,d0
	move.w	d0,(printy).l
	bsr.w	DrawScoringRow
	move.l	(sp)+,d0
	rts
DrawScoringRow						;Print ScoreSum entry d3: time, team (bit 7 of byte 2 = away), goal type
									;(GoalTypeTbl), scorer and the two assists (PrintScorerName)
	move.w	(printy).l,-(sp)
	moveq	#$28,d0		;width 40 cells
	moveq	#$4,d1		;4 rows high
	move.w	#$7FF,d2		;blank tile
	jsr	(eraser).l
	move.w	(sp)+,(printy).l
	movea.l	#ScoreSum,a0
	move.w	(a0,d3.w),d0		;goal time
	move.w	#$1,(printx).l
	jsr	(FormatAndPrintTime).l
	movea.l	#tmstruct,a2
	btst	#$7,ssflags(a0,d3.w)
	beq.w	.0
	adda.w	#tmsize,a2
.0	movea.l	tmdata(a2),a1		;team data -> team name string
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	move.w	#$C,(printx).l
	jsr	(print).l
	move.w	#$23,(printx).l
	lea	GoalTypeTbl(pc),a1
	move.b	ssflags(a0,d3.w),d0
	andi.w	#$7F,d0
	jsr	(Fprintsmall).l
	move.w	#$10,(printx).l
	move.b	ssscorer(a0,d3.w),d0
	bsr.w	PrintScorerName		;print him
	move.w	#$E000,(printa).l
	move.w	#$12,(printx).l
	move.b	$4(a0,d3.w),d0
	bsr.w	PrintScorerName
	move.w	#$12,(printx).l
	move.b	$5(a0,d3.w),d0		;second assist, falls into PrintScorerName
PrintScorerName						;Print player d0 (byte, negative = none) and go down a row
	ext.w	d0
	bmi.w	.next
	jsr	(FormatPlayerNumInitial).l
	jsr	(print).l
.next	addi.w	#$1,(printy).l
	rts
GoalTypeTbl							;ScoreSum byte 2 & $7F: SH2, SH, even, PP, PP2
	String	'SH2'
	String	'SH'
	String	' '
	String	'PP'
	String	'PP2'
PenaltySummaryScreen						;"Penalty Summary": one 3 row entry per penalty (4 bytes each from PenSum,
									;PenSumLength bytes), scrolled as ScoringSummaryScreen. Menu item handler
	moveq	#$A,d0		;bitmap row $A
	moveq	#$19,d1
	bsr.w	SetupScreen		;set up the screen
	jsr	(printz).l
	String	CC_Font3Pri,$4,$1
	moveq	#$20,d0
	moveq	#$6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	CC_Font3Pri,$5,$4,'Penalty  Summary',CC_Font3Pri,$7,$1
	moveq	#$2C,d0
	bsr.w	PutTeamBlock
	addi.w	#$4,(printx).l		;4 columns right
	clr.w	d0
	bsr.w	PutTeamBlock
	jsr	(printsmallz).l
; Inline data read by printsmallz from the return address (2 rows).
	dc.w	$0034
	dc.b	$F8,$06,$03,$00,$08,$F9,$01,'^Per^^Time^^Tm^^Player/Penalty^^^^min^^^',$F9,$00,$00
	clr.l	d0
	move.w	(PenSumLength).l,d0
	lsr.w	#$2,d0		;/4 bytes per entry = number of penalties
	mulu.w	#$18,d0		;24 pixels per entry
	move.w	d0,(VertLineScrolling).l		;start at the end
	subi.w	#$78,d0		;5 entries fit on screen
	bpl.w	.0
	clr.w	d0		;fewer than 5 entries: no scrolling
.0	move.w	d0,(SelectedPlayerIdx).l
	move.w	(VertLineScrolling).l,d0		;start position
.toend	bsr.w	MenuWaitVblank		;wait for the next frame
	bsr.w	UpdatePenaltyScroll		;set scroll to d0, drawing entries as they come into view
	move.w	(VertLineScrolling).l,d0		;position
	subi.w	#$2,d0
	cmp.w	(SelectedPlayerIdx).l,d0		;reached the limit?
	bge.w	.toend		;not there yet
	clr.w	(PlayerScrollCtr).l
.loop	bsr.w	MenuWaitVblank		;wait for the next frame
	bsr.w	ReadActiveJoypad		;d3 = held buttons of the pad that paused
	btst	#$7,d3		;start?
	bne.w	StatsScreenFadeIn		;Start
	moveq	#-2,d0
	btst	#$0,d3		;up?
	bne.w	.set		;up held: scroll up
	neg.w	d0
	btst	#$1,d3		;down?
	beq.w	.scroll		;neither: keep the current PlayerScrollCtr (it is cleared at entry
.set	move.w	d0,(PlayerScrollCtr).l
.scroll	bsr.w	CheckPenaltyScroll
	bra.w	.loop
CheckPenaltyScroll						;PenaltySummaryScreen per frame: add PlayerScrollCtr to VertLineScrolling
									;(0 ... SelectedPlayerIdx). Falls into UpdatePenaltyScroll
	move.w	(PlayerScrollCtr).l,d0
	beq.w	rtss8
	add.w	(VertLineScrolling).l,d0		;new position
	bmi.w	rtss8		;above the top: ignore
	cmp.w	(SelectedPlayerIdx).l,d0		;past the limit?
	bgt.w	rtss8
; Scrolling step in units of $18.
UpdatePenaltyScroll	move.w	(VertLineScrolling).l,d1
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divs.w	#$18,d0
	swap	d0
	tst.w	d0
	bne.w	.next
	bsr.w	PenaltyEntryHeader
	clr.w	(PlayerScrollCtr).l
.next	ext.l	d1
	divs.w	#$18,d1
	swap	d1
	tst.w	d1
	bne.w	.next3
	move.l	d0,-(sp)
	cmpi.w	#$16,d0
	bne.w	.next2
	bsr.w	DisplayPenaltyLineUp
.next2	move.l	(sp)+,d0
	cmpi.w	#$2,d0
	bne.w	.next3
	bsr.w	DisplayPenaltyLineDown
.next3	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$C00000,a0
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	move.w	#$FFB0,d0
	add.w	(VertLineScrolling).l,d0
.loop4	btst	#$7,$FF800E.l
	bne.b	.loop4
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
.loop5	btst	#$6,$FF800E.l
	beq.b	.loop5
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	bne.b	.loop6
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
DisplayPenaltyLineUp	move.l	d0,-(sp)
	swap	d0
	move.w	d0,d3
	asl.w	#$2,d3
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	move.w	(VertLineScrolling).l,d0
	lsr.w	#$3,d0
	subi.w	#$2,d0
	andi.w	#$1F,d0
	move.w	d0,(printy).l
	bsr.w	DisplayPenaltyEntry
	move.l	(sp)+,d0
	rts
DisplayPenaltyLineDown	move.l	d0,-(sp)
	swap	d0
	addi.w	#$5,d0
	move.w	d0,d3
	asl.w	#$2,d3
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	move.w	(VertLineScrolling).l,d0
	lsr.w	#$3,d0
	addi.w	#$F,d0
	andi.w	#$1F,d0
	move.w	d0,(printy).l
	bsr.w	DisplayPenaltyEntry
	move.l	(sp)+,d0
	rts
DisplayPenaltyEntry						;Print PenSum entry d3: time, team (bit 7 of byte 2 = away), minutes and
									;name from Penaltylist, player (byte 3)
	move.w	(printy).l,-(sp)
	moveq	#$28,d0		;width 40 cells
	moveq	#$3,d1		;3 rows high
	move.w	#$7FF,d2		;blank tile
	jsr	(eraser).l
	move.w	(sp)+,(printy).l
	movea.l	#PenSum,a0
	move.w	(a0,d3.w),d0		;penalty time
	move.w	#$1,(printx).l
	jsr	(FormatAndPrintTime).l
	movea.l	#tmstruct,a2
	btst	#$7,pspen(a0,d3.w)		;away penalty?
	beq.w	.0
	adda.w	#tmsize,a2
.0	movea.l	tmdata(a2),a1		;team data -> team name string
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	move.w	#$C,(printx).l
	jsr	(print).l
	move.b	pspen(a0,d3.w),d0
	andi.w	#$7F,d0
	movea.l	#Penaltylist,a3
	adda.w	(a3,d0.w),a3
	clr.w	d0
	move.b	$1(a3),d0		;penalty minutes
	jsr	(PushNumber).l
	move.w	#$23,(printx).l
	jsr	(print).l
	move.w	#$10,(printx).l
	clr.w	d0
	move.b	$3(a0,d3.w),d0
	jsr	(FormatPlayerNumInitial).l
	jsr	(print).l
	addi.w	#$1,(printy).l
	move.w	#$13,(printx).l
	move.w	#$E000,(printa).l
	lea.l	$2(a3),a1		;penalty name string
	jmp	(print).l
; Prints the penalty entry header.
PenaltyEntryHeader
	movem.l	d0-d1/a1,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$4,$9,CC_SetFont,$1
	clr.w	d0
	move.w	(VertLineScrolling).l,d1
	tst.w	d1
	sgt.b	d0
	neg.b	d0
	cmp.w	(SelectedPlayerIdx).l,d1
	slt.b	d1
	neg.b	d1
	add.b	d1,d0
	add.b	d1,d0
	lea.l	.next(pc),a1
	jsr	(Fprintsmall).l
	movem.l	(sp)+,d0-d1/a1
	rts
; Table of 20 words after PenaltyEntryHeader, 40 bytes: $000A,$20FB,$FFFA,$1120,$F900,$000A ...
.next	dc.w	$000A,$20FB,$FFFA,$1120,$F900,$000A,$7BFB,$FFFA
	dc.w	$1120,$F900,$000A,$20FB,$FFFA,$117D,$F900,$000A
	dc.w	$7BFB,$FFFA,$117D,$F900
PlayoffStatsScreen						;"Playoff Stats": the playoff totals (ReadTeamStats) of the potreeteam
									;team as PlayerStatsList with d7 = 1. Called and the menu lists
	movem.l	a2,-(sp)
	jsr	(ReadTeamStats).l
	movea.l	#potree,a0
	move.w	(potreeteam).l,d0
	move.b	(a0,d0.w),d0		;his team
	movea.l	#tmstruct,a2
	cmp.w	tmteam(a2),d0		;is it home?
	beq.w	.0
	adda.w	#tmsize,a2
.0	moveq	#$1,d7		;playoff mode: stats come from the playoff RAM tables
	bsr.w	PlayerStatsList
	movem.l	(sp)+,a2
	rts
; Table of 1 word after PlayoffStatsScreen, 2 bytes: $4247 ...
PlayerStatsScreen
	dc.w	$4247
PlayerStatsList						;Stats screen for team a2, d7 = 0 game / 1 playoff: the column headers,
									;the players sorted by the selected column (left / right), up / down
									;scroll, A switches teams (game stats only), start exits
	moveq	#$D,d0		;bitmap row $D
	moveq	#$16,d1
	bsr.w	SetupScreen		;set up the screen
	clr.w	(scoutcolumn).l		;sort column: -1 goalie saves, 0-4 G A Pts SOG PIM; start with goals
	clr.w	(VertLineScrolling).l		;list scrolled to the top
.redraw	clr.w	(PlayerScrollCtr).l
	jsr	(printz).l
	String	CC_Font3Pri,$5,$1
	moveq	#$1E,d0
	moveq	#$6,d1
	jsr	(Framer).l
	tst.w	d7
	beq.w	.title
	jsr	(printbigz).l
	String	CC_Font3Pri,$7,$4,'Playoff  Stats',CC_Font3Pri,$E,$1
	bra.w	.team
.title	jsr	(printsmallz).l
; Inline data read by printsmallz from the return address (2 rows).
	dc.w	$001C
	dc.b	$F8,$06,$03,$0C,$1A,$F9,$01,'A^-^Switch^Teams',$F9,$00,$00
	jsr	(printbigz).l
	String	CC_Font3Pri,$8,$4,'Player  Stats',CC_Font3Pri,$E,$1
.team	clr.w	d0		;TeamBlockMap offset: 0 for the home struct, $30 for the away struct
	cmpa.l	#tmstruct,a2		;home team?
	beq.w	.home
	moveq	#$2C,d0
.home	bsr.w	PutTeamBlock		;draw the team block, then the list
	bsr.w	StatsListDrawHeader
	bsr.w	DrawStatsListArrows
.loop	bsr.w	MenuWaitVblank
	bsr.w	ReadActiveJoypad		;d1 = new presses, d3 = held
	btst	#$7,d3
	bne.w	StatsScreenFadeIn		;Start
	btst	#$6,d1		;A?
	bne.w	.switch
	jsr	(nodiag).l
	moveq	#$1,d0
	btst	#$3,d1		;right?
	bne.w	.col		;right pressed: column +1
	neg.w	d0
	btst	#$2,d1		;left?
	bne.w	.col		;left pressed: column -1
	moveq	#-2,d0
	btst	#$0,d3		;up?
	bne.w	.set		;up held: scroll step -2
	neg.w	d0
	btst	#$1,d3		;down?
	beq.w	.scroll		;nothing held: keep the current scroll step
.set	move.w	d0,(PlayerScrollCtr).l
.scroll	bsr.w	UpdateStatsListScroll
	bra.w	.loop
.col	add.w	(scoutcolumn).l,d0
	cmpi.w	#$FFFF,d0		;below -1?
	blt.w	.scroll
	cmpi.w	#$4,d0		;past 4?
	bgt.w	.scroll
	move.w	d0,(scoutcolumn).l
	bsr.w	StatsListDrawHeader
	bsr.w	DrawStatsListArrows
	bra.w	.scroll
.switch	tst.w	d7		;No team switch in playoff stats
	bne.w	.scroll
	lea.l	$366(a2),a2
	cmpa.l	#awtmstruct,a2		;was the home team?
	beq.w	.redraw		;was home, now away
	movea.l	#tmstruct,a2		;was away, back to home
	bra.w	.redraw
UpdateStatsListScroll						;Stats screen per frame: scroll 0 ... SelectedPlayerIdx, stop on a 16 line
									;boundary, draw the row coming into view
	move.w	(PlayerScrollCtr).l,d0
	beq.w	rtss8
	add.w	(VertLineScrolling).l,d0		;new position
	bmi.w	rtss8		;above the top: ignore
	cmp.w	(SelectedPlayerIdx).l,d0		;past the limit?
	bgt.w	rtss8
	move.w	(VertLineScrolling).l,d1		;d1 = old position
	move.w	d0,(VertLineScrolling).l
	andi.w	#$F,d0		;pixels into the current 16 pixel row
	bne.w	.0
	bsr.w	DrawStatsListArrows		;landed on a row boundary: refresh arrows and stop scrolling
	clr.w	(PlayerScrollCtr).l
.0	andi.w	#$F,d1		;old position within its row
	bne.w	SetStatsListScrollReg
	move.w	d0,-(sp)
	cmpi.w	#$E,d0		;14 pixels in: moved up, draw the row above
	bne.w	.1
	bsr.w	DrawStatsRowUp
.1	move.w	(sp)+,d0		;restore the pixels into the row
	cmpi.w	#$2,d0		;2 pixels in: moved down, draw the row below
	bne.w	SetStatsListScrollReg
	bsr.w	DrawStatsRowDown		;falls into the scroll register write
; Waits for the sub CPU before the next scroll step
SetStatsListScrollReg	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$C00000,a0
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	move.w	#$FF98,d0
	add.w	(VertLineScrolling).l,d0
.loop4	btst	#$7,$FF800E.l
	bne.b	.loop4
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
.loop5	btst	#$6,$FF800E.l
	beq.b	.loop5
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	bne.b	.loop6
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
; Draws the first visible stats row.
DrawStatsRowUp	move.w	(VertLineScrolling).l,d3
	lsr.w	#$4,d3
	bra.w	DrawStatsRow
; Draws the stats row six lines below the first.
DrawStatsRowDown	move.w	(VertLineScrolling).l,d3
	lsr.w	#$4,d3
	addi.w	#$6,d3
	bra.w	DrawStatsRow
; Prints the 'Player' column header.
StatsListDrawHeader	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$6,$3,$4,$B,CC_SetFont,$1,'Player',CC_AddX,$7
	lea	StatColumnHeaders(pc),a1
	moveq	#$5,d3
	tst.w	(scoutcolumn).l
	bmi.w	.loop
	adda.w	(a1),a1
	clr.w	d3
.loop	move.w	#$8000,(printa).l
	cmp.w	(scoutcolumn).l,d3
	bne.w	.next
	move.w	#$C000,(printa).l
.next	jsr	(printsmall).l
	addi.w	#$1,d3
	cmpi.w	#$5,d3
	blt.w	.loop
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$9,$7
	moveq	#$16,d0
	moveq	#$3,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	CC_Font3Pal3Pri,$A,$8
	lea	StatSortTitles(pc),a1
	moveq	#$1,d0
	add.w	(scoutcolumn).l,d0
	jsr	(Fprintsmall).l
	clr.w	(printfontset).l
	movea.l	#Satt,a3
	clr.l	d6
	tst.w	(scoutcolumn).l
	bpl.w	.loop2
	bsr.w	GetGoalieCount
	bset	d0,d6
	subi.w	#$1,d6
	not.l	d6
.loop2	moveq	#-1,d4
	st.b	d5
	bsr.w	GetPlayerCount
	bra.w	.next3
.loop3	btst	d0,d6
	bne.w	.next3
	clr.w	d2
	move.w	(scoutcolumn).l,d1
	bmi.w	.next2
	bsr.w	GetStatColumn
.next2	ext.l	d2
	asl.l	#$8,d2
	movea.l	$1E(a2),a1
	adda.w	$0(a1),a1
	move.w	d0,d1
	suba.w	#$8,a1
.loop4	adda.w	#$8,a1
	adda.w	(a1),a1
	dbra	d1,.loop4
	move.b	#$FF,d2
	sub.b	(a1),d2
	cmp.l	d4,d2
	ble.w	.next3
	move.l	d2,d4
	move.w	d0,d5
.next3	dbra	d0,.loop3
	bset	d5,d6
	move.b	d5,(a3)+
	bpl.w	.loop2
	moveq	#$5,d0
.loop5	st.b	(a3,d0.w)
	dbra	d0,.loop5
	move.l	a3,d0
	subi.l	#Satt+6,d0
	bpl.w	.next4
	clr.w	d0
.next4	asl.w	#$4,d0
	move.w	d0,(SelectedPlayerIdx).l
	cmp.w	(VertLineScrolling).l,d0
	bcc.w	.next5
	move.w	d0,(VertLineScrolling).l
.next5	moveq	#$5,d4
.loop6	move.w	(VertLineScrolling).l,d3
	lsr.w	#$4,d3
	add.w	d4,d3
	bsr.w	DrawStatsRow
	dbra	d4,.loop6
	bra.w	SetStatsListScrollReg
DrawStatsRow						;Stats screen row d3 of Satt: rank, name, then the 5 columns, or for
									;goalies saves, shots and save %
	movea.l	#Satt,a4
	adda.w	d3,a4
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	add.w	d3,d3		;2 map rows per Satt row
	andi.w	#$1F,d3		;wrap in the 32 row map
	move.w	d3,(printy).l
	moveq	#$28,d0		;erase one row, 40 cells wide
	moveq	#$1,d1
	move.w	#$7FF,d2		;blank char
	jsr	(eraser).l
	tst.b	(a4)		;empty row?
	bmi.w	rtss8
	subi.w	#$1,(printy).l		;eraser moved printy down one row; back to the row rank (2 digits) at x 1
	move.w	#$1,(printx).l
	move.l	a4,d0
	subi.l	#Satt-1,d0		;rank (1-based)
	moveq	#$2,d1		;2 digits
	move.w	#$E000,(printa).l
	jsr	(PushNumberWidth).l
	jsr	(print).l
	clr.w	d0
	move.b	(a4),d0
	jsr	(FormatPlayerName).l
	addi.w	#$1,(printx).l
	move.w	#$8000,(printa).l
	jsr	(print).l
	move.w	#$11,(printx).l		;stat columns start at x $11
	tst.w	(scoutcolumn).l		;goalie column?
	bmi.w	.goalie
	clr.w	d5
.col	clr.w	d0		;next stat column d5
	move.b	(a4),d0
	move.w	d5,d1
	bsr.w	GetStatColumn		;d2 = the stat
	move.w	d2,d0
	moveq	#$4,d1		;4 digits
	jsr	(PushNumberWidth).l
	move.w	#$8000,(printa).l
	cmp.w	(scoutcolumn).l,d5		;sort column?
	bne.w	.1
	move.w	#$C000,(printa).l		;highlighted sort column
.1	jsr	(print).l
	addi.w	#$1,d5
	cmpi.w	#$5,d5		;5 columns
	bne.w	.col
	bra.w	.x
.goalie	clr.w	d0		;Shots against
	move.b	(a4),d0
	moveq	#$3,d1		;column 3 (SOG array)
	bsr.w	ReadStatColumn		;d2 = shots against
	clr.w	d0
	move.b	(a4),d0
	moveq	#$0,d1		;goals against
	move.w	d2,-(sp)
	bsr.w	ReadStatColumn		;d2 = goals against
	move.w	(sp)+,d0
	move.w	d0,d3
	sub.w	d2,d0		;saves = shots - goals against
	bpl.w	.2
	clr.w	d0
.2	move.w	d0,d2
	moveq	#$4,d1		;4 digits
	jsr	(PushNumberWidth).l
	addi.w	#$1,(printx).l
	jsr	(print).l
	move.w	d3,d0
	moveq	#$4,d1
	jsr	(PushNumberWidth).l
	addi.w	#$2,(printx).l
	jsr	(print).l
	tst.w	d3
	beq.w	.3		;no shots: percentage is just d2 (0)
	mulu.w	#$64,d2
	divu.w	d3,d2		;saves * 100 / shots
.3	move.w	d2,d0
	moveq	#$4,d1		;4 digits
	jsr	(PushNumberWidth).l
	addi.w	#$2,(printx).l
	jsr	(print).l
	jsr	(printz).l
	String	'%'
.x	rts

GetStatColumn						;d2 = stat column d1 for player d0. Goalies only have PIM (btst d1,#6
									;picks the columns kept)
	move.w	d0,-(sp)
	bsr.w	GetGoalieCount
	move.w	d0,d2
	move.w	(sp)+,d0
	cmp.w	d2,d0		;goalie?
	bge.w	ReadStatColumn		;skater: read the column as is
	clr.w	d2		;goalie: columns 1 and 2 (A, Pts) show column 1 (assists), the rest 0
	btst	d1,#$6
	beq.w	rtss8
GetStatColumn_1A						;d2 = stat column d1 for player d0. d7 = 0: the team struct byte arrays
									;(StatColumnOffsets); d7 = 1: the playoff tables (GetStatsValue)
	moveq	#$1,d1
; Selects the stat column table and indexes it.
ReadStatColumn
	tst.w	d7
	bne.w	.next
	lea	StatColumnOffsets(pc),a1
	asl.w	#$2,d1
	adda.w	d1,a1
	clr.l	d1
	move.w	(a1),d1
	add.w	d0,d1
	clr.l	d2
	move.b	(a2,d1.l),d2
	move.w	$2(a1),d1
	bmi.w	rtss8
	add.w	d0,d1
	clr.w	d3
	move.b	(a2,d1.l),d3
	add.w	d3,d2
	rts
.next	asl.w	#$2,d1
	add.w	d0,d0
	clr.w	d2
	bsr.w	GetStatsValue
	addi.w	#$2,d1
	bsr.w	GetStatsValue
	lsr.w	#$1,d0
	rts
GetStatsValue	movea.l	#StatsOffsetTbl2,a1
	tst.w	(a1,d1.w)
	beq.w	rtss8
	movea.w	(a1,d1.w),a1
	move.l	d7,-(sp)
	move.l	a1,d7
	andi.l	#$FFFF,d7
	movea.l	d7,a1
	move.l	(sp)+,d7
	add.w	(a1,d0.w),d2
	rts
StatsOffsetTbl2						;Playoff stat tables per column (G, A, G+A, SOG, PIM), read as movea.w (GetStatsValue)
	dc.w	$B000,$0,$B034,$0,$B000,$B034,$B068,$0,$B09C,$0
StatColumnOffsets					;Team struct byte arrays per column, same order (each 2 above the cartridge's)
	dc.w	tmgoals,$FFFF,$D0,$FFFF,tmgoals,$D0,tmpshots,$FFFF,$104,$FFFF
StatColumnHeaders					;Stats screen column headers (goalie header, then 5 columns)
	String	'Saves Shots Save %  '
	String	'   G'
	String	'   A'
	String	' Pts'
	String	' SOG'
	String	' PIM'
StatSortTitles						;the lea in DrawStatsList. Sort column titles
	String	'    Goalie Saves   ]'
	String	'[      Goals       ]'
	String	'[     Assists      ]'
	String	'[      Points      ]'
	String	'[  Shots On Goal   ]'
	String	'[ Penalty Minutes   '
DrawStatsListArrows					;Stats screen up / down arrows (ScrollArrowTbl2). Saves d0-d1/a1
	movem.l	d0-d1/a1,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$2,$B,CC_SetFont,$1
	clr.w	d0
	move.w	(VertLineScrolling).l,d1
	tst.w	d1
	sgt.b	d0
	neg.b	d0
	cmp.w	(SelectedPlayerIdx).l,d1
	slt.b	d1
	neg.b	d1
	add.b	d1,d0
	add.b	d1,d0
	lea	ScrollArrowTbl2(pc),a1
	jsr	(Fprintsmall).l
	movem.l	(sp)+,d0-d1/a1
	rts
ScrollArrowTbl2						;None, up, down, both
	String	' ',CC_AddX,$FF,CC_AddY,$C,' ',CC_SetFont
	String	'{',CC_AddX,$FF,CC_AddY,$C,' ',CC_SetFont
	String	' ',CC_AddX,$FF,CC_AddY,$C,'}',CC_SetFont
	String	'{',CC_AddX,$FF,CC_AddY,$C,'}',CC_SetFont
CrowdMeterScreen						;"Crowd Meter": current, average and peak level (PrintCrowdMeter), plus
									;the arena and league records; start exits. Menu item handler
	moveq	#$9,d0		;bitmap row 9
	moveq	#$1C,d1
	bsr.w	SetupScreen		;set up the screen
	jsr	(printz).l
	String	CC_Font3Pri,$6,$1
	moveq	#$1C,d0		;frame 28 wide, 6 high
	moveq	#$6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	CC_Font3Pri,$9,$4,'Crowd  Meter',CC_Font3Pri,$7,$1
	moveq	#$2C,d0		;away team block
	bsr.w	PutTeamBlock
	addi.w	#$4,(printx).l		;4 columns right
	clr.w	d0
	bsr.w	PutTeamBlock
	bsr.w	PrintCrowdMeter		;the three level rows
.loop	bsr.w	Pausemode_rjoy		;wait for a new button press
	btst	#$7,d1		;start?
	bne.w	StatsScreenFadeIn
	bra.w	.loop
PrintCrowdMeter						;Crowd meter rows: CwdExciteLvl, the average (SumCwdExciteLvl /
									;NumCwdExciteLvl) and MaxCwdExciteLvl in dB (PrintCrowdDB). With save RAM
									;(ValidSRAM) the arena record of HomeTeam and the league record
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$4,$C,'Current Level',CC_SetX,$1C
	move.w	(CwdExciteLvl).l,d0		;current level
	bsr.w	PrintCrowdDB						;Print crowd level d0 as sqrt(d0 * 4) + 65 " dB"
	jsr	(printsmallz).l
	String	CC_SetX,$4,CC_AddY,$2,'Average Level',CC_SetX,$1C
	move.l	(SumCwdExciteLvl).l,d0		;sum of the levels
	divu.w	(NumCwdExciteLvl).l,d0
	bsr.w	PrintCrowdDB						;Print crowd level d0 as sqrt(d0 * 4) + 65 " dB"
	jsr	(printsmallz).l
	String	CC_SetX,$4,CC_AddY,$2,'Peak Level',CC_SetX,$1C
	move.w	(MaxCwdExciteLvl).l,d0		;peak level
	bsr.w	PrintCrowdDB						;Print crowd level d0 as sqrt(d0 * 4) + 65 " dB"
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(ValidSRAM).l
	bmi.w	.x		;no save RAM
	move.w	(HomeTeam).l,d1
	ext.l	d1
	movea.l	#recordbuf,a0
	jsr	(ReadCrowdRecord).l
	move.b	crpeak(a0),d0
	bne.w	.gotarena
	move.b	#$50,d0		;none: $50
.gotarena	andi.w	#$FF,d0
	move.w	d0,-(sp)
	jsr	(printsmallz).l
	String	CC_SetX,$4,CC_AddY,$2,'Arena Record',CC_SetX,$1C
	move.w	(sp)+,d0
	move.w	#$3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	' dB'
	jsr	(GetLeagueCrowdRecord).l
	move.w	d0,d1
	ext.l	d1
	movea.l	#recordbuf,a0
	jsr	(ReadCrowdRecord).l
	move.b	crpeak(a0),d0
	bne.w	.gotleague
	move.w	#$50,d0		;none: $50
.gotleague	andi.w	#$FF,d0
	move.w	d0,-(sp)
	jsr	(printsmallz).l
	String	CC_SetX,$4,CC_AddY,$2,'League Record',CC_SetX,$1C
	move.w	(sp)+,d0
	move.w	#$3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	' dB'
.x	movem.l	(sp)+,d0-d7/a0-a6
	rts
PrintCrowdDB						;Print crowd level d0 as sqrt(d0 * 4) + 65 " dB"
	ext.l	d0
	asl.w	#$2,d0
	jsr	(Sroot).l
	addi.w	#$41,d0
	moveq	#$3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	' dB'
	rts
; Forces black and sets display flags for the crowd meter screen.
SetupScreen
	movem.l	d0-d1/a2,-(sp)
	jsr	(forceblack).l
	bclr	#$0,(disflags).l
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	move.w	(VSPRITES).l,d0
	jsr	(SetVramWriteAddr1).l
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
.loop4	btst	#$7,$FF800E.l
	bne.b	.loop4
	move.w	#$8C81,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop5	btst	#$6,$FF800E.l
	beq.b	.loop5
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	bne.b	.loop6
	bclr	#$7,$FF800F.l
	move.w	#$6,(Map3col).l
.loop7	btst	#$7,$FF800E.l
	bne.b	.loop7
	move.w	#$8D00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop8	btst	#$6,$FF800E.l
	beq.b	.loop8
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop9	btst	#$6,$FF800E.l
	bne.b	.loop9
	bclr	#$7,$FF800F.l
	clr.w	d0
	jsr	(SetVramWriteAddr1).l
.loop10	btst	#$7,$FF800E.l
	bne.b	.loop10
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset	#$6,$FF800F.l
.loop11	btst	#$6,$FF800E.l
	beq.b	.loop11
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop12	btst	#$6,$FF800E.l
	bne.b	.loop12
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	bclr	#$1,(disflags).l
	move.w	(framercset).l,d4
	movea.l	(FramerMap).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$91234567,$89ABCDEF		;remap table
	move.w	(smallfontchars).l,d4
	jsr	(AddSmallFont).l
	jsr	(printz).l
	String	CC_Font3Pri,$0,$0
	movea.l	(EASportsBGMap).l,a1
	adda.l	jimdata(a1),a1
	movea.l	#null,a2
	clr.w	d0		;start x/y 0 in the map
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	moveq	#$1,d4
	moveq	#$0,d5		;no palette lines
	jsr	(dobitmap).l
	jsr	(printz).l
	String	CC_Font3,$0,$0
	movem.l	(sp),d0-d1/a2
	add.w	d0,(printy).l
	movea.l	(EASportsBGMap).l,a0
	movea.l	a0,a1		;a1 = map header
	movea.l	a0,a2
	adda.l	(a2)+,a0		;a0 = tile data
	adda.l	(a2)+,a1		;a1 = map data
	move.w	d1,d3
	sub.w	d0,d3		;height = last row - first row
	move.w	d0,d1		;start y = first row
	clr.w	d0
	moveq	#$28,d2
	moveq	#$D,d5		;copy palette lines 0, 2 and 3
	jsr	(dobitmap).l
	move.w	d4,(smallfont2chars).l		;second small font chars
	movea.l	(SmallFontMap).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$D1234567,$89ABCDEF		;remap table
	jsr	(printz).l
	String	CC_Font2,$0,$0
	moveq	#$40,d0
	moveq	#$20,d1
	move.w	#$7FF,d2		;blank char
	jsr	(eraser).l
	move.w	#$18,(palcount).l
	movem.l	(sp)+,d0-d1/a2
	rts
; Black out, set the display flags and fade a stats screen in
StatsScreenFadeIn
	jsr	(forceblack).l
; Stats screen: clears VRAM through the gate array while fading in.
StatsScreenFadeInClear
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	move.w	(VSCRLPM).l,d0
	jsr	(SetVramWriteAddr1).l
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	move.w	#$8D00,d0
	move.b	(VSCRLPM).l,d0
	lsr.b	#$2,d0
.loop4	btst	#$7,$FF800E.l
	bne.b	.loop4
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop5	btst	#$6,$FF800E.l
	beq.b	.loop5
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	bne.b	.loop6
	bclr	#$7,$FF800F.l
.loop7	btst	#$7,$FF800E.l
	bne.b	.loop7
	move.w	#$8C00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop8	btst	#$6,$FF800E.l
	beq.b	.loop8
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop9	btst	#$6,$FF800E.l
	bne.b	.loop9
	bclr	#$7,$FF800F.l
	move.w	#$5,(Map3col).l
.loop10	tst.w	(palcount).l
	bpl.w	.loop10
	move.w	(sp)+,(disflags).l
	bset	#$1,(disflags).l
	move.w	(rinkvrcset).l,d4
	movea.l	$47D18.l,a2
	addq.l	#$8,a2
	btst	#$4,(sflags4).l
	beq.w	.next
	movea.l	$47D64.l,a2
	addq.l	#$8,a2
.next	jsr	(DecompressGraphicsPlain).l
	jsr	(LoadHomeTeamGfx).l
	move.w	(smallfontchars).l,d4
	movea.l	(SmallFontMap).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
; Inline data read by DecompressGraphicsWithRemap from the return address (1 row).
	dc.l	$43434567,$89ABCDEF
	move.w	(framercset).l,d4
	jsr	(AddSmallFontFramer).l
	jsr	(SetupIceRinkPalRemap).l
	jsr	(IceRinkRemapGfxE).l
	jsr	(IceRinkRemapGfxF).l
	jsr	(setupIceRinkPal).l
	jmp	(CopyTeamLinesCheckTeam).l
; Pause menu "Timeout" for team a2 (cartridge TimeoutMenu): switch the menu to PauseText2, show the team name, rest both teams, wait $78 frames
TimeoutMenu	subi.w	#$1,(menuitem).l
	subi.w	#$1,(MenuScrollTop).l
	move.l	#PauseText2,(menulist).l		;pause menu without Timeout
	bset.b	#$2,tmflags(a2)
	jsr	(printz).l
	String	CC_Font3Pri,$5,$C
	moveq	#$16,d0		;frame 22 wide, 6 high
	moveq	#$6,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	CC_Font3Pri,$C,$E,'Timeout',CC_Font3Pri,$11,$F
	movea.l	tmdata(a2),a1		;team name, centred
	adda.w	$4(a1),a1
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	jsr	(print).l
	movea.l	#tmstruct,a2
	jsr	(RestoreTeamEnergy).l
	adda.l	#tmsize,a2
	jsr	(RestoreTeamEnergy).l
	moveq	#$78,d0
	jmp	(waitx).l
; Pause menu "Change Goalie" (cartridge Pausemode_go): pick team a2's goalie (or no goalie) from a list with up / down, C or start; sets tmgoalie and calls setpersonel
Pausemode_go	move.w	(menuitem).l,-(sp)		;save the menu state
	move.w	(MenuScrollTop).l,-(sp)
	bsr.w	GetGoalieCount
	move.w	d0,(MenuScrollTop).l
	jsr	(printz).l
	String	CC_Font3Pri,$4,$C
	moveq	#$18,d0
	moveq	#$3,d1
	add.w	(MenuScrollTop).l,d1		;plus a row per goalie
	jsr	(Framer).l
	move.w	tmgoalie(a2),d0
	bpl.w	.0
	moveq	#-1,d0
.0	addi.w	#$1,d0		;row of the current goalie (0 = goalie pulled)
	move.w	d0,(menuitem).l
.loop	bsr.w	Pausemode_gnum
	bsr.w	Pausemode_rjoy		;wait for a press
	btst	#$7,d1
	bne.w	.done		;Start confirms
	btst	#$5,d1
	bne.w	.done
	btst	#$1,d1
	beq.w	.up
	move.w	(menuitem).l,d0
	addq.w	#$1,d0
	cmp.w	(MenuScrollTop).l,d0		;past the last?
	bgt.w	.loop
	move.w	d0,(menuitem).l
.up	btst	#$0,d1		;up pressed: move the selection up
	beq.w	.loop
	subi.w	#$1,(menuitem).l
	bpl.w	.loop
	clr.w	(menuitem).l		;stop at the first row
	bra.w	.loop
.done	move.w	(menuitem).l,d0
	subi.w	#$1,d0		;goalie number
	bpl.w	.set
	cmpi.w	#$FFFF,tmgoalie(a2)		;already pulled?
	blt.w	.x		;yes: nothing to do
.set	move.w	d0,tmgoalie(a2)		;a goalie row: put him in
	jsr	(setpersonel).l
.x	move.w	(sp)+,(MenuScrollTop).l
	move.w	(sp)+,(menuitem).l
	rts
; Stats rows: starts at row $D
Pausemode_gnum	move.w	#$D,(printy).l
	move.w	(MenuScrollTop).l,d1
	moveq	#$0,d0
; Stats rows: prints one row of the table
StatsRowsLoop	move.w	#$5,(printx).l
	move.w	#$A000,(printa).l
	cmp.w	(menuitem).l,d0
	bne.w	.next
	move.w	#$8000,(printa).l
.next	jsr	(printz).l
; Inline data read by $38F6E from the return address (2 rows).
	dc.b	$00,$18,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20	; ..              
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20	;         
; Stats rows: prints "no goalie" when the team has none
StatsRowNoGoalie	tst.w	d0
	bne.w	StatsRowGoalieName
	move.w	#$B,(printx).l
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$0C,$6E,$6F,$20,$67,$6F,$61,$6C,$69,$65,$00	; ..no goalie.
	bra.w	StatsRowsNext
; Stats rows: finds the goalie name
StatsRowGoalieName	movea.l	$1E(a2),a1
	adda.w	$0(a1),a1
	move.w	d0,d2
	subi.w	#$1,d2
	bra.w	.next
.loop	adda.w	(a1),a1
	adda.w	#$8,a1
.next	dbra	d2,.loop
	move.w	#$8,(printx).l
	jsr	(print).l
	move.b	(a1),d2
	lsr.b	#$4,d2
	addi.b	#$30,d2
	move.b	d2,(TextBuffer).l
	move.b	(a1),d2
	andi.b	#$F,d2
	addi.b	#$30,d2
	move.b	d2,(TextBuffer+1).l
	movea.l	#mesarea,a1
	move.w	#$4,(a1)
	move.w	#$5,(printx).l
	jsr	(print).l
; Stats rows: next row
StatsRowsNext	addi.w	#$1,(printy).l
	addi.w	#$1,d0
	dbra	d1,StatsRowsLoop
	rts
GetGoalieCount						;d0 = goalies on team a2 (nibbles in a team data word)
	movem.l	d1/a0,-(sp)
	movea.l	tmdata(a2),a0
	adda.w	$A(a0),a0
	move.w	(a0),d1		;word with one nibble per goalie slot
	clr.w	d0
.count	addi.w	#$1,d0		;count nibbles by shifting 4 bits out until the word is 0
	asl.w	#$4,d1
	bne.w	.count
	movem.l	(sp)+,d1/a0
	rts
GetDefenseStart						;d0 = goalies + forwards of team a2 (GetGoalieCount + GetForwardCount),
									;the roster index of the first defenseman (roster order is goalies,
									;forwards, defense). Called from the high ROM player cards
	movem.l	a0,-(sp)
	bsr.w	GetGoalieCount
	move.w	d0,-(sp)
	movea.l	tmdata(a2),a0
	adda.w	$8(a0),a0
	move.b	srforwards(a0),d0
	lsr.w	#$4,d0		;high nibble
	add.w	(sp)+,d0
	movem.l	(sp)+,a0
	rts
GetForwardCount						;d0 = forwards on team a2 (high nibble of team data byte 3 at +8)
	movem.l	a0,-(sp)
	movea.l	tmdata(a2),a0
	adda.w	$8(a0),a0
	move.b	srforwards(a0),d0
	lsr.w	#$4,d0		;high nibble = forward count
	andi.w	#$F,d0		;forward count
	movem.l	(sp)+,a0
	rts
GetPlayerCount
	movem.l	a0,-(sp)
	movea.l	tmdata(a2),a0
	adda.w	$0(a0),a0
	clr.w	d0
.loop	addi.w	#$1,d0
	adda.w	(a0),a0
	adda.w	#$8,a0
	cmpi.w	#$2,(a0)
	bne.w	.loop
	movem.l	(sp)+,a0
	rts
; Waits for the next frame count change, then runs the sub CPU step
Pausemode_rjoy	move.w	(Vcount).l,d1
.loop	cmp.w	(Vcount).l,d1
	beq.w	.loop
	bsr.w	ReadActiveJoypad
	jsr	(nodiag).l
	tst.b	d1
	beq.w	Pausemode_rjoy
	rts
ReplayMode
	bclr.b	#$0,(sflags5).l
	bsr.w	forceblack
	move.w	(disflags).l,-(sp)
	bset.b	#$3,(sflags2).l
	bclr.b	#$4,(sflags4).l
	jsr	(ClrHor).l
	move.w	#$400,d0
	move.w	(VmMAP3).l,d1
	move.w	#$7FF,d2
	jsr	(DoDMANd2Queue).l
	move.w	(ExtraChars).l,d4
	movea.l	$47D68.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	jsr	(ShowReplayIcon).l
	bclr.b	#$5,(sflags).l
	bclr.b	#$5,(sflags3).l
	st.b	(replayactive).l
	movea.l	(recbpr).l,a4
.loop2	bsr.w	suba4
	tst.w	d7
	bne.w	.loop2
	jsr	(SprSort).l
	jsr	(setvideo).l
	bclr.b	#$1,(sflags3).l
	clr.l	(padcont).l
	clr.l	(padcont+4).l
	clr.l	(padcont+8).l
	move.w	#$18,(palcount).l
	moveq	#$1,d7
; Waits until d7 frames have passed
WaitFramesD7	move.w	(Vcount).l,d0
	sub.w	(OldVcount).l,d0
	cmp.w	d0,d7
	bhi.w	WaitFramesD7
	move.w	(Vcount).l,(OldVcount).l
	tst.w	(replayicontimer).l
	bmi.w	.next
	sub.w	d7,(replayicontimer).l
	bpl.w	.next
	clr.w	(replayicontimer).l
	jsr	(ControllerTextClear).l
.next	movem.l	d0/a3,-(sp)
	movea.l	#SortCords+(12*SCstruct),a3
	move.w	#$1,$8(a3)
	movea.l	#SortCords+(13*SCstruct),a3
	move.w	#$1,$8(a3)
	movem.l	(sp)+,d0/a3
	moveq	#$1,d7
	bsr.w	ReadActiveJoypad
	btst.b	#$0,(sflags5).l
	beq.w	.next2
	andi.w	#$FFF0,d0
	ori.w	#$8,d0
	andi.w	#$FFF0,d1
	andi.w	#$FFF0,d3
.next2	movea.l	#CameraPosStruct,a5
	btst.b	#$5,(sflags3).l
	beq.w	.next3
	move.w	d1,d5
	andi.w	#$F,d5
	beq.w	DirectionPressCheck
.next3	btst	#$3,d0
	bne.w	DirectionPressCheck
	cmpi.w	#$FF60,$0(a5)
	bgt.w	.next4
	move.w	#$0,$0(a5)
	bra.w	.next4
.next4	cmpi.w	#$FED0,$14(a5)
	bgt.w	.next5
	move.w	#$0,$14(a5)
.next5	bset.b	#$5,(sflags).l
	bne.w	.next6
	move.w	(Hpos).l,$0(a5)
	move.w	(Vpos).l,$14(a5)
.next6	move.w	d0,d5
	andi.w	#$7,d5
	eori.w	#$4,d5
	movea.l	#SortCords,a1
	st.b	d3
	bclr.b	#$5,(sflags3).l
	beq.w	.next7
	move.w	$16(a5),d3
.next7	move.w	$0(a5),d0
	move.w	$14(a5),d1
	moveq	#$B,d2
	move.l	#$100,d4
	movem.w	d0-d1,-(sp)
.loop	cmp.w	$52(a1),d3
	beq.w	.next8
	movem.w	(sp),d0-d1
	sub.w	$0(a1),d0
	sub.w	$14(a1),d1
	jsr	(vtoa).l
	btst	#$3,d0
	bne.w	.next8
	sub.w	d5,d0
	addi.w	#$1,d0
	andi.w	#$7,d0
	cmpi.w	#$2,d0
	bhi.w	.next8
	movem.w	(sp),d0-d1
	sub.w	$0(a1),d0
	sub.w	$14(a1),d1
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmpi.l	#$4,d0
	bls.w	.next8
	cmp.l	d4,d0
	bhi.w	.next8
	move.l	d0,d4
	move.w	$52(a1),$16(a5)
	bset.b	#$5,(sflags3).l
.next8	adda.l	#$80,a1
	dbra	d2,.loop
	adda.w	#$4,sp
	btst.b	#$5,(sflags3).l
	beq.w	.next9
	move.w	$16(a5),d0
	asl.w	#$7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	moveq	#$4,d4
	bsr.w	setpads
	bsr.w	UpdateCameraPos
	jsr	(setvideo).l
	bra.w	WaitFramesD7
.next9	bset.b	#$5,(sflags).l
	eori.w	#$4,d5
	asl.w	#$2,d5
	lea.l	DirectionStepTable(pc),a0
	move.w	(a0,d5.w),d0
	add.w	$0(a5),d0
	cmpi.w	#$88,d0
	bgt.w	.next10
	cmpi.w	#$FF78,d0
	blt.w	.next10
	move.w	d0,$0(a5)
.next10	move.w	$2(a0,d5.w),d1
	add.w	$14(a5),d1
	cmpi.w	#$126,d1
	bgt.w	.next11
	cmpi.w	#$FEDA,d1
	blt.w	.next11
	move.w	d1,$14(a5)
.next11	movea.l	a5,a3
	clr.w	$18(a5)
	andi.w	#$FFF,(PadControlBits).l
	ori.w	#$E000,(PadControlBits).l
	bsr.w	UpdateCameraPos
	jsr	(setvideo).l
	bra.w	WaitFramesD7
; Word pairs: x and y step for each of the 8 directions
DirectionStepTable	dc.b	$00,$00,$00,$02,$00,$02,$00,$02,$00,$02,$00,$00,$00,$02,$FF,$FE	; ................
	dc.b	$00,$00,$FF,$FE,$FF,$FE,$FF,$FE,$FF,$FE,$00,$00,$FF,$FE,$00,$02	; ................
; Checks the direction buttons after a wait
DirectionPressCheck	st.b	$18(a5)
	btst	#$5,d1
	beq.w	.next
	btst.b	#$0,(sflags5).l
	bne.w	.next
	bchg.b	#$1,(sflags3).l
.next	btst	#$6,d3
	beq.w	.next2
	btst.b	#$0,(sflags5).l
	bne.w	.next2
	bsr.w	suba4
	bsr.w	suba4
	bsr.w	suba4
	bsr.w	suba4
	jsr	(SprSort).l
	jsr	(setvideo).l
	moveq	#$1,d7
	bclr.b	#$1,(sflags3).l
.next2	btst.b	#$0,(sflags5).l
	bne.w	.next4
	btst	#$4,d3
	beq.w	.next4
	btst	#$6,d3
	beq.w	.next3
	bclr.b	#$5,(sflags3).l
	bclr.b	#$5,(sflags).l
	move.w	d0,-(sp)
	move.w	(PadControlBits).l,d0
	andi.w	#$FFF,d0
	ori.w	#$E000,d0
	move.w	d0,(PadControlBits).l
	move.w	(sp)+,d0
	bra.w	WaitFramesD7
.next3	bsr.w	adda4
	jsr	(SprSort).l
	jsr	(setvideo).l
	asl.w	#$1,d7
	bclr.b	#$1,(sflags3).l
.next4	btst.b	#$1,(sflags3).l
	beq.w	.next5
	st.b	(lastsfx).l
	bsr.w	adda4
	move.w	(lastsfx).l,-(sp)
	bsr.w	sfx
	jsr	(SprSort).l
.next5	jsr	(setvideo).l
	btst.b	#$0,(sflags5).l
	bne.w	.next6
	btst	#$7,d1
	beq.w	WaitFramesD7
	jsr	(ShowReplayBanner).l
	bclr.b	#$1,(sflags3).l
	bset.b	#$0,(sflags5).l
	bne.w	.next6
	bra.w	WaitFramesD7
.next6	btst	#$7,d1
	bne.w	.next8
	btst	#$6,d1
	bne.w	.next7
	btst	#$4,d1
	bne.w	.next9
	btst	#$5,d1
	beq.w	WaitFramesD7
	bset.b	#$6,(sflags4).l
	bclr.b	#$0,(sflags5).l
	jsr	(ControllerPictureClear).l
	bsr.w	adda4
	jsr	(SprSort).l
	bra.w	WaitFramesD7
.next7	jmp	(WaitFramesD7).l
.next8	clr.w	(menuitem).l
	bset.b	#$1,(sflags5).l
.next9	bsr.w	forceblack
	ori.w	#$F000,(PadControlBits).l
	bclr.b	#$5,(sflags).l
	movea.l	(recbpr).l,a4
	bclr.b	#$4,(sflags4).l
	bsr.w	RestoreReplayFrame
	jsr	(SprSort).l
	bclr.b	#$3,(sflags2).l
	move.w	(sp)+,(disflags).l
	jsr	(StatsScreenFadeInClear).l
	jsr	(SetupIceRinkPalRemap).l
	jsr	(IceRinkRemapGfxE).l
	jsr	(IceRinkRemapGfxF).l
	jsr	(IceRinkRemapGfxB).l
	btst.b	#$4,(disflags).l
	beq.w	.next10
	jsr	(IceRinkRemapGfxD).l
	jsr	(IceRinkRemapGfxC).l
.next10	jsr	(SetHor).l
	jsr	(setvideo).l
	move.w	#$18,(palcount).l
	rts

; Reads joypad 2 or 1 depending on the port flag.
ReadActiveJoypad
	tst.w	(FourWayPlay).l
	bne.w	.next2
.loop	btst	#$1,(sflags).l
	beq.s	.next
	jmp	(ReadJoy2).l
.next	jmp	(ReadJoy1).l
.next2	tst.w	(pausepad).l
	beq.w	.loop
	cmpi.w	#$3,(pausepad).l
	bne.s	.next3
	jmp	(ReadJoy3).l
.next3	jmp	(ReadJoy4).l
; Prints the controller text on the pad test screen.
ShowReplayIcon
	move.w	#$F0,(replayicontimer).l
	jsr	(printz).l
	String	CC_Font3Pri,$2,$2
	moveq	#$20,d0
	moveq	#$55,d1
	moveq	#$8,d2
	moveq	#$4,d3
	move.w	(rinkvrcset).l,d4
	move.w	#$0,d5
	movea.l	$47D18.l,a1
	btst	#$4,(sflags4).l
	beq.w	.next4
	movea.l	$47D64.l,a1
.next4	adda.l	$4(a1),a1
	movea.l	#null,a2
	jmp	(dobitmap).l
; Clears the controller text on the pad screen: prints an empty string and erases the 8x4 text box.
ControllerTextClear
	jsr	(printz).l
	String	CC_Font3Pri,$2,$2
	move.w	#$8,d0
	move.w	#$4,d1
	move.w	#$7FF,d2
	jmp	(eraser).l
; Draws the controller picture on the pad screen and arms the text timer.
ShowReplayBanner
	st.b	(replayicontimer).l
	jsr	(printz).l
	String	CC_Font3Pri,$2,$0
	moveq	#$0,d0
	moveq	#$0,d1
	moveq	#$10,d2
	moveq	#$B,d3
	move.w	(ExtraChars).l,d4
	move.w	#$0,d5
	movea.l	$47D68.l,a1
	adda.l	$4(a1),a1
	movea.l	#null,a2
	jmp	(dobitmap).l
; Erases the controller picture (16x11 tiles) from the pad screen.
ControllerPictureClear
	jsr	(printz).l
	String	CC_Font3Pri,$2,$2
	move.w	#$10,d0
	move.w	#$B,d1
	move.w	#$7FF,d2
	jmp	(eraser).l