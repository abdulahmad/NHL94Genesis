ShowScores						;"Scores" screen: the other games of the night in gstruct over the Scores
	
	
	moveq	#$6,d0
	moveq	#$1A,d1
	bsr.w	CrowdMeterFadeIn
	jsr	(printz).l
	String	CC_Font3Pri,$5,$0
	moveq	#$1E,d0
	moveq	#$6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	CC_Font3Pri,$E,$3,'Scores',CC_Font3Pri,$B,$1
	movea.l	$47D58.l,a1
	lea.l	$8(a1),a2
	adda.l	$4(a1),a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	clr.w	d5
	jsr	(dobitmap).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$4,$0
	clr.w	(VertLineScrolling).l
	bsr.w	ScoresScrollBlitSetup
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
	beq.w	updatereplayExit
	add.w	(VertLineScrolling).l,d0
	bmi.w	updatereplayExit
	cmp.w	(SelectedPlayerIdx).l,d0
	bgt.w	updatereplayExit
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divu.w	#$18,d0
	swap	d0
	tst.w	d0
	bne.w	ScoresScrollBlitSetup
	bsr.w	PrintGameInfoHeader
	clr.w	(PlayerScrollCtr).l
; Sets up the VDP DMA write for the scores scroll.
ScoresScrollBlitSetup	move.w	(disflags).l,-(sp)
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
DisplayGameInfo	cmp.w	$18A98.l,d3
	beq.w	updatereplayExit
	moveq	#$10,d0
	mulu.w	d3,d0
	movea.l	#$18A18,a0
	adda.w	d0,a0
	btst	#$1,$E(a0)
	bne.w	updatereplayExit
	btst	#$2,$E(a0)
	bne.w	updatereplayExit
	move.w	$2(a0),d0
	move.w	$C(a0),d1
	bsr.w	PrintGameInfo
	addi.w	#$1,(printy).l
	move.w	$0(a0),d0
	move.w	$A(a0),d1
	bsr.w	PrintGameInfo
	move.w	$8(a0),d0
	subi.w	#$1,d0
	movea.l	#PerLabels,a1
	move.w	#$1C,(printx).l
	jsr	(PrintTickerEntry).l
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
	jsr	(PrintTickerEntry).l
	movem.l	(sp)+,d0-d1/a1
	rts
; Table of 32 words after PrintGameInfoHeader, 64 bytes: $000A,$20FB,$FFFA,$1320,$F900,$000A ...
.next	dc.w	$000A,$20FB,$FFFA,$1320,$F900,$000A,$7BFB,$FFFA
	dc.w	$1320,$F900,$000A,$20FB,$FFFA,$137D,$F900,$08EA
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
	st.b	$17F60.l
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
	tst.w	$18C0A.l
	beq.w	.set
	cmpi.w	#$1,d0
	blt.w	.loop
	cmpi.w	#$5,d0
	bgt.w	.loop
.set	lea.l	LineCursorTable(pc),a0
	move.b	$8(a0,d0.w),$1A45B.l		;wrap/skip through the table
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
	movea.l	#$BBD30,a0
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
.next	movea.l	#$BBD30,a3
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
.loop	adda.w	(a1),a1
	adda.w	#$4,a1
.2	tst.w	(a1)
	dbmi	d0,.loop
	bpl.w	.found
	subi.w	#$1,(scoutcolumn).l
	bra.w	.top
.found	jsr	(print).l
	move.l	(a1),d4
	movea.l	#$BBD30,a3
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
	
	moveq	#$6,d5
	dc.w	$41FA,$008F		; lea.l X_2CCB7(pc),a0
	move.w	(TestList).l,d0
	lsr.w	#$3,d0
	adda.w	d0,a0
	tst.w	$18C0A.l
	beq.w	.0
	suba.w	#$1,a0
.0	move.b	(a0),d0
	cmp.b	$17F60.l,d0
	beq.w	.loop
	move.b	d0,$17F60.l
	bsr.w	DrawLineIconErase
.loop	btst	d5,$17F60.l
	beq.w	.next
	bsr.w	DrawLineIcon
.next	dbra	d5,.loop
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$8,$7,CC_SetFont,$1
	moveq	#$18,d0
	moveq	#$3,d1
	jsr	(Framer).l
	jsr	(printsmallz).l
	String	CC_Font3,$15,$FC,$8
	move.w	d6,d0
	jsr	(GetPlayerNameBuild).l
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	move.w	d7,(printa).l
	jsr	(printsmall).l
	clr.w	(printfontset).l
	rts
	btst	d0,d7
	btst	d3,d7
	move.b	(a0)+,d4
; Instruction bytes inside DrawLineIcons that the assembler would encode differently, kept as words (1 row).
	dc.w	$6060
DrawLineIcon						;Line editor: draw line d5 (its name from linelist, then its player slots)
	
	moveq	#$6,d0
	mulu.w	d5,d0
	lea.l	LineIconPosTable(pc),a0
	adda.w	d0,a0
	tst.w	$18C0A.l
	beq.w	.0
	suba.w	#$6,a0
.0	move.w	(a0),(printx).l
	move.w	$2(a0),(printy).l
	move.w	d5,d0
	movea.l	#linelist,a1
	move.w	#$8000,(printa).l
	jsr	(PrintTickerEntry).l
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
	jsr	(FormatLastNameStart).l
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
	tst.w	$18C0A.l
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
	adda.l	$4(a1),a1
	movea.l	#$1B008,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
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
	cmpa.l	#$1834C,a2
	beq.w	PutTeamBlockDraw
	moveq	#$2C,d0
	bra.w	PutTeamBlockDraw
ClearLineEditorTop						;Erase 40 x 10 at the top of map 2
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	moveq	#$28,d0
	moveq	#$A,d1
	move.w	#$7FF,d2
	jmp	(eraser).l
; Clears two marker words.
ClearLineEditorMarks
	clr.w	$BBD0A.l
	clr.w	$BBD2A.l
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
	move.l	$18AD2.l,-(sp)
	move.l	$18AD6.l,-(sp)
	move.l	$18ADA.l,-(sp)
	movea.l	#$3C000,a1
	movea.l	#LineEditorMenuText,a0
	movea.l	#$18C26,a3
	move.w	$2A(a2),d0
	addi.w	#$1,d0
	cmp.b	(a3),d0
	beq.w	.next
	movea.l	#LineEditorMenuNoLoad,a0
.next	jsr	(printsmallz).l
	String	CC_Font1,$2
	bsr.w	SetMenuScreenHandler
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
	move.w	$18AD2.l,d0
	move.l	(sp)+,$18ADA.l
	move.l	(sp)+,$18AD6.l
	move.l	(sp)+,$18AD2.l
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
	movea.l	#$18C26,a0
	adda.w	#$1,a0
	bsr.w	GetGoalieCount
	move.w	d0,d1
	bsr.w	GetForwardCount
	move.w	d0,d3
	movea.l	#$2D0B2,a3
	clr.w	d4
	clr.w	d2
.loop	move.b	(a3),d2
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
	bra.w	.loop
.done	movem.l	(sp)+,d0-d4/a0/a3
	rts
EncodeTeamLines						;Reverse of DecodeTeamLines: pack team a2's lines into databuffer and
	
	movem.l	d0-d4/a0-a3,-(sp)
	movea.l	#$18C26,a0
	move.w	$2A(a2),d0
	addi.w	#$1,d0
	move.b	d0,(a0)+
	lea.l	$16C(a2),a1
	bsr.w	GetGoalieCount
	move.w	d0,d1
	bsr.w	GetForwardCount
	movea.l	#$2D0B2,a3
	clr.w	d4
	clr.w	d2
.loop	move.b	(a3)+,d2
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
	bra.w	.loop
.hi	asl.b	#$4,d3
	or.b	d3,(a0)+
	bra.w	.loop
.done	jsr	(ReadLineDataBackupWrite).l
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
	bsr.w	CrowdMeterFadeIn
	moveq	#$1,d0
	add.w	$16(a2),d0
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
	cmpa.l	#$1834C,a2
	beq.w	.next
	moveq	#$2C,d0
.next	bsr.w	PutTeamBlockDraw
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
	bsr.w	PlayerListScrollStep
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
	cmpa.l	#$186B2,a2
	beq.w	.redraw
	movea.l	#tmstruct,a2		;away -> back to home
	bra.w	.redraw
CheckPlayerListScroll						;TeamRosterScreen per frame: add PlayerScrollCtr to VertLineScrolling (0
	
	move.w	(PlayerScrollCtr).l,d0
	beq.w	updatereplayExit
	add.w	(VertLineScrolling).l,d0
	bmi.w	CheckPlayerListScrollReset
	cmpi.w	#$380,d0
	bgt.w	CheckPlayerListScrollReset
; Scrolling step in units of $80.
PlayerListScrollStep
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
	bsr.w	PlayerListSelectHigh
.next2	cmpi.w	#$2,d0
	bne.w	.next3
	bsr.w	PlayerListSelectHighNext
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
CheckPlayerListScrollReset	clr.w	(PlayerScrollCtr).l
	rts
; Selects the player from the high word of d0 and redraws.
PlayerListSelectHigh	move.l	d0,-(sp)
	swap	d0
	move.w	d0,(SelectedPlayerIdx).l
	bsr.w	PlayerListDrawSelected
	move.l	(sp)+,d0
	rts
; Selects the player after the high word of d0 and redraws.
PlayerListSelectHighNext	move.l	d0,-(sp)
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
	dc.w	$43FA,$012C		; lea.l X_2D4DA(pc),a1
	jsr	(SkipListEntries).l
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
	btst	#$0,$1A455.l
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
	movea.l	#$2D4CA,a5
	movea.l	#$BBD30,a3
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
; Data that follows CheckPlayerListScroll (strings, small tables)
CheckPlayerListScrollData	dc.w	$0004,$4700,$0004,$4700,$0004,$4700,$0004,$4700
	dc.b	$00,$12,'    Goalies   '
	dc.b	' }',$00,$12,'{  Scoring  '
	dc.b	'1  }',$00,$12,'{  Scoring'
	dc.b	'  2  }',$00,$12,'{   Chec'
	dc.b	'king   }',$00,$12,'{ Powe'
	dc.b	'r Play 1 }',$00,$12,'{ Po'
	dc.b	'wer Play 2 }',$00,$12,'{P'
	dc.b	'enalty Kill 1}',$00,$12
	dc.b	'{Penalty Kill 2 '
GetNameandAttrib						;Print player d0's name, then at x $1E the column d4 picks (attribjmp;
									;above 2 a rating through CalcAttrib, high ROM). Saves d0-d4/a0-a1/a4-a5
	movem.l	d0-d4/a0-a1/a4-a5,-(sp)
	dc.w	$487A,$0030		; pea.l X_2D5A0(pc)
	jsr	(GetPlayerNameBuild).l
	jsr	(print).l
	move.w	#$1E,(printx).l
	cmpi.w	#$2,d4		;status or energy column?
	bls.w	.next
	jsr	(CalcAttrib).l
	swap	d4
.next	dc.w	$41FA,$000E		; lea.l X_2D5A6(pc),a0
	adda.w	(a0,d4.w),a0
	jmp	(a0)
; Table of 106 words after GetNameandAttrib, 164 bytes: $4CDF,$331F,$4E75,$000C,$009E,$00E8 ...
	dc.w	$4CDF,$331F,$4E75,$000C,$009E,$00E8,$010E,$00B8
	dc.w	$00C0,$D040,$3032,$0068,$6A00,$001E,$4640,$0C40
	dc.w	$0003,$6300,$000A,$7001,$6000,$0004,$7003,$43FA
	dc.w	$0040,$4EF9,$0003,$CEBE,$0800,$000C,$6600,$FFEE
	dc.w	$0479,$0001,$0001,$8D58,$3200,$0240,$0FFF,$4EB9
	dc.w	$0003,$90F4,$4EB9,$0003,$8F80,$7004,$0881,$000E
	dc.w	$6700,$0004,$7005,$43FA,$0008,$4EF9,$0003,$CEBE
	dc.b	$00,$0A,'Ice     ',$00,$0A,'Benc'
	dc.b	'h   ',$00,$0A,'Injury P',$00,$0A
	dc.b	'Injury G',$00,$06,'    ',$00,$06
	dc.w	$2043,$2020
AttribEnergy						;Energy: tmpde(a2) word / 40, at most 100 (AttribPrintPct)
	add.w	d0,d0
	move.w	$34(a2,d0.w),d0		;his energy
	ext.l	d0
	divu.w	#$28,d0
	cmpi.w	#$64,d0		;over 100?
	ble.w	AttribPrintPct
	moveq	#$64,d0
	bra.w	AttribPrintPct		;print it
; Table of 10 words after AttribEnergy, 20 bytes: $0240,$000E,$0441,$0001,$C0FC,$0064 ...
	dc.w	$0240,$000E,$0441,$0001,$C0FC,$0064,$80C1,$4EB9
	dc.w	$0002,$AE82
AttribPrintPct
	moveq	#$4,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	'    '
	rts
; Table of 10 words after AttribPrintPct, 20 bytes: $0240,$0001,$0A40,$0001,$43FA,$0008 ...
	dc.w	$0240,$0001,$0A40,$0001,$43FA,$0008,$4EF9,$0003
	dc.w	$CEBE,$000A
AttribWeight						;Weight: 140 + 8 * rating lb
	addq.w	#$1,$6768(a1)
	moveq	#$79,d2
	move.l	-(a0),d0
; Text of AttribWeight (3 rows).
	dc.b	$00,$0A,'Lefty   ',$E7,'@',$06,'@',$00,$8C
	dc.w	$4EB9,$0003,$915E,$4EB9,$0003,$8F80,$4EB9,$0003
	dc.b	$8F,'n',$00,$08,' lb  ',$00,'Nu'
ScoringSummaryScreen						;"Scoring Summary": one 4 row entry per goal (6 bytes each from ScoreSum),
									;scrolled with up / down, start exits. Menu item handler
	moveq	#$A,d0		;SetupScreen d0/d1: row offset / height
	moveq	#$1A,d1
	bsr.w	CrowdMeterFadeIn		;set up the screen
	jsr	(printz).l
	String	CC_Font3Pri,$4,$1
	moveq	#$20,d0
	moveq	#$6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	CC_Font3Pri,$6,$4,'Scoring Summary',CC_Font3Pri,$7,$1
	moveq	#$2C,d0
	bsr.w	PutTeamBlockDraw
	addi.w	#$4,(printx).l		;4 columns right
	clr.w	d0
	bsr.w	PutTeamBlockDraw
	jsr	(printsmallz).l
; Inline data read by printsmallz from the return address (2 rows).
	dc.w	$0034
	dc.b	$F8,$06,$03,$00,$08,$F9,$01,'^Per^^Time^^Tm^^Goal/Assist^^^^^^^^P/S^^',$F9,$00,$00
	clr.l	d0
	move.w	$180F0.l,d0
	divu.w	#$6,d0		;goals
	asl.w	#$5,d0		;32 pixels per entry
	move.w	d0,(VertLineScrolling).l		;start at the end
	subi.w	#$80,d0		;4 entries fit on screen
	bpl.w	.0
	clr.w	d0
.0	move.w	d0,(SelectedPlayerIdx).l
	move.w	(VertLineScrolling).l,d0		;start position
.toend	bsr.w	MenuWaitVblank		;wait for the next frame
	bsr.w	ScoringScrollStep
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
	beq.w	updatereplayExit
	add.w	(VertLineScrolling).l,d0		;new position
	bmi.w	updatereplayExit		;above the top: ignore
	cmp.w	(SelectedPlayerIdx).l,d0		;past the limit?
	bgt.w	updatereplayExit
; Scrolling step in units of $20.
ScoringScrollStep	move.w	(VertLineScrolling).l,d1
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
	bsr.w	.next4
.next2	move.l	(sp)+,d0
	cmpi.w	#$2,d0
	bne.w	.next3
	bsr.w	.next5
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
.next4	move.l	d0,-(sp)
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
.next5	move.l	d0,-(sp)
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
	movea.l	#$180F2,a0
	move.w	(a0,d3.w),d0		;goal time
	move.w	#$1,(printx).l
	jsr	(FormatAndPrintTime).l
	movea.l	#tmstruct,a2
	btst	#$7,$2(a0,d3.w)
	beq.w	.0
	adda.w	#$366,a2
.0	movea.l	$1E(a2),a1		;team data -> team name string
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	move.w	#$C,(printx).l
	jsr	(print).l
	move.w	#$23,(printx).l
	dc.w	$43FA,$0060		; lea.l X_2DA34(pc),a1
	move.b	$2(a0,d3.w),d0
	andi.w	#$7F,d0
	jsr	(PrintTickerEntry).l
	move.w	#$10,(printx).l
	move.b	$3(a0,d3.w),d0
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
; Table of 16 words after PrintScorerName, 24 bytes: $0006,$5348,$3200,$0004,$5348,$0004 ...
	dc.w	$0006,$5348,$3200,$0004,$5348,$0004,$2000,$0004
	dc.b	'PP',$00,$06,'PP2',$00
PenaltySummaryScreen						;"Penalty Summary": one 3 row entry per penalty (4 bytes each from PenSum,
									;PenSumLength bytes), scrolled as ScoringSummaryScreen. Menu item handler
	moveq	#$A,d0		;bitmap row $A
	moveq	#$19,d1
	bsr.w	CrowdMeterFadeIn		;set up the screen
	jsr	(printz).l
	String	CC_Font3Pri,$4,$1
	moveq	#$20,d0
	moveq	#$6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	CC_Font3Pri,$5,$4,'Penalty  Summary',CC_Font3Pri,$7,$1
	moveq	#$2C,d0
	bsr.w	PutTeamBlockDraw
	addi.w	#$4,(printx).l		;4 columns right
	clr.w	d0
	bsr.w	PutTeamBlockDraw
	jsr	(printsmallz).l
; Inline data read by printsmallz from the return address (2 rows).
	dc.w	$0034
	dc.b	$F8,$06,$03,$00,$08,$F9,$01,'^Per^^Time^^Tm^^Player/Penalty^^^^min^^^',$F9,$00,$00
	clr.l	d0
	move.w	$1825A.l,d0
	lsr.w	#$2,d0		;/4 bytes per entry = number of penalties
	mulu.w	#$18,d0		;24 pixels per entry
	move.w	d0,(VertLineScrolling).l		;start at the end
	subi.w	#$78,d0		;5 entries fit on screen
	bpl.w	.0
	clr.w	d0		;fewer than 5 entries: no scrolling
.0	move.w	d0,(SelectedPlayerIdx).l
	move.w	(VertLineScrolling).l,d0		;start position
.toend	bsr.w	MenuWaitVblank		;wait for the next frame
	bsr.w	PenaltyScrollStep		;set scroll to d0, drawing entries as they come into view
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
	beq.w	updatereplayExit
	add.w	(VertLineScrolling).l,d0		;new position
	bmi.w	updatereplayExit		;above the top: ignore
	cmp.w	(SelectedPlayerIdx).l,d0		;past the limit?
	bgt.w	updatereplayExit
; Scrolling step in units of $18.
PenaltyScrollStep	move.w	(VertLineScrolling).l,d1
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
	bsr.w	.next4
.next2	move.l	(sp)+,d0
	cmpi.w	#$2,d0
	bne.w	.next3
	bsr.w	.next5
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
.next4	move.l	d0,-(sp)
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
.next5	move.l	d0,-(sp)
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
	movea.l	#$1825C,a0
	move.w	(a0,d3.w),d0		;penalty time
	move.w	#$1,(printx).l
	jsr	(FormatAndPrintTime).l
	movea.l	#tmstruct,a2
	btst	#$7,$2(a0,d3.w)		;away penalty?
	beq.w	.0
	adda.w	#$366,a2
.0	movea.l	$1E(a2),a1		;team data -> team name string
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	move.w	#$C,(printx).l
	jsr	(print).l
	move.b	$2(a0,d3.w),d0
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
	jsr	(PrintTickerEntry).l
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
	movea.l	#$18AA6,a0
	move.w	$18AA0.l,d0
	move.b	(a0,d0.w),d0		;his team
	movea.l	#tmstruct,a2
	cmp.w	$2A(a2),d0		;is it home?
	beq.w	.0
	adda.w	#$366,a2
.0	moveq	#$1,d7		;playoff mode: stats come from the playoff RAM tables
	bsr.w	PlayerStatsList
	movem.l	(sp)+,a2
	rts
; Table of 1 word after PlayoffStatsScreen, 2 bytes: $4247 ...
	dc.w	$4247
PlayerStatsList						;Stats screen for team a2, d7 = 0 game / 1 playoff: the column headers,
									;the players sorted by the selected column (left / right), up / down
									;scroll, A switches teams (game stats only), start exits
	moveq	#$D,d0		;bitmap row $D
	moveq	#$16,d1
	bsr.w	CrowdMeterFadeIn		;set up the screen
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
	cmpa.l	#$1834C,a2		;home team?
	beq.w	.home
	moveq	#$2C,d0
.home	bsr.w	PutTeamBlockDraw		;draw the team block, then the list
	bsr.w	StatsListDrawHeader
	bsr.w	StatColumnHeader
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
	bsr.w	StatColumnHeader
	bra.w	.scroll
.switch	tst.w	d7		;No team switch in playoff stats
	bne.w	.scroll
	lea.l	$366(a2),a2
	cmpa.l	#$186B2,a2		;was the home team?
	beq.w	.redraw		;was home, now away
	movea.l	#tmstruct,a2		;was away, back to home
	bra.w	.redraw
UpdateStatsListScroll						;Stats screen per frame: scroll 0 ... SelectedPlayerIdx, stop on a 16 line
									;boundary, draw the row coming into view
	move.w	(PlayerScrollCtr).l,d0
	beq.w	updatereplayExit
	add.w	(VertLineScrolling).l,d0		;new position
	bmi.w	updatereplayExit		;above the top: ignore
	cmp.w	(SelectedPlayerIdx).l,d0		;past the limit?
	bgt.w	updatereplayExit
	move.w	(VertLineScrolling).l,d1		;d1 = old position
	move.w	d0,(VertLineScrolling).l
	andi.w	#$F,d0		;pixels into the current 16 pixel row
	bne.w	.0
	bsr.w	StatColumnHeader		;landed on a row boundary: refresh arrows and stop scrolling
	clr.w	(PlayerScrollCtr).l
.0	andi.w	#$F,d1		;old position within its row
	bne.w	UpdateStatsListScrollWait
	move.w	d0,-(sp)
	cmpi.w	#$E,d0		;14 pixels in: moved up, draw the row above
	bne.w	.1
	bsr.w	StatsListDrawTopRow
.1	move.w	(sp)+,d0		;restore the pixels into the row
	cmpi.w	#$2,d0		;2 pixels in: moved down, draw the row below
	bne.w	UpdateStatsListScrollWait
	bsr.w	StatsListDrawBottomRow		;falls into the scroll register write
; Waits for the sub CPU before the next scroll step
UpdateStatsListScrollWait	move.w	(disflags).l,-(sp)
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
StatsListDrawTopRow	move.w	(VertLineScrolling).l,d3
	lsr.w	#$4,d3
	bra.w	DrawStatsRow
; Draws the stats row six lines below the first.
StatsListDrawBottomRow	move.w	(VertLineScrolling).l,d3
	lsr.w	#$4,d3
	addi.w	#$6,d3
	bra.w	DrawStatsRow
; Prints the 'Player' column header.
StatsListDrawHeader	jsr	(printsmallz).l
	dc.w	$0012
	dc.b	$F8,$06,$03,$04,$0B,$F9,$01,'Player',$FB,$07,$00
	dc.w	$43FA,$0344
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
	dc.w	$43FA,$0314		; lea.l X_2E46A(pc),a1
	moveq	#$1,d0
	add.w	(scoutcolumn).l,d0
	jsr	(PrintTickerEntry).l
	clr.w	(printfontset).l
	movea.l	#$BBD30,a3
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
	subi.l	#$BBD36,d0
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
	bra.w	UpdateStatsListScrollWait
DrawStatsRow						;Stats screen row d3 of Satt: rank, name, then the 5 columns, or for
									;goalies saves, shots and save %
	movea.l	#$BBD30,a4
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
	bmi.w	updatereplayExit
	subi.w	#$1,(printy).l		;eraser moved printy down one row; back to the row rank (2 digits) at x 1
	move.w	#$1,(printx).l
	move.l	a4,d0
	subi.l	#$BBD2F,d0		;rank (1-based)
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
	bra.w	.ex
.goalie	clr.w	d0		;Shots against
	move.b	(a4),d0
	moveq	#$3,d1		;column 3 (SOG array)
	bsr.w	ReadStatColumnTable		;d2 = shots against
	clr.w	d0
	move.b	(a4),d0
	moveq	#$0,d1		;goals against
	move.w	d2,-(sp)
	bsr.w	ReadStatColumnTable		;d2 = goals against
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
.ex	rts

GetStatColumn						;d2 = stat column d1 for player d0. Goalies only have PIM (btst d1,#6
									;picks the columns kept)
	move.w	d0,-(sp)
	bsr.w	GetGoalieCount
	move.w	d0,d2
	move.w	(sp)+,d0
	cmp.w	d2,d0		;goalie?
	bge.w	ReadStatColumnTable		;skater: read the column as is
	clr.w	d2		;goalie: columns 1 and 2 (A, Pts) show column 1 (assists), the rest 0
; Instruction bytes inside GetStatColumn that the assembler would encode differently, kept as words (2 rows).
	dc.w	$033C,$0006,$6700
	dc.w	$15E8
ReadStatColumn						;d2 = stat column d1 for player d0. d7 = 0: the team struct byte arrays
									;(StatColumnOffsets); d7 = 1: the playoff tables (GetStatsValue)
	moveq	#$1,d1
; Selects the stat column table and indexes it.
ReadStatColumnTable
	tst.w	d7
	bne.w	.next
	dc.w	$43FA,$0076		; lea.l X_2E422(pc),a1
	asl.w	#$2,d1
	adda.w	d1,a1
	clr.l	d1
	move.w	(a1),d1
	add.w	d0,d1
	clr.l	d2
	move.b	(a2,d1.l),d2
	move.w	$2(a1),d1
	bmi.w	updatereplayExit
	add.w	d0,d1
	clr.w	d3
	move.b	(a2,d1.l),d3
	add.w	d3,d2
	rts
.next	asl.w	#$2,d1
	add.w	d0,d0
	clr.w	d2
	bsr.w	.next2
	addi.w	#$2,d1
	bsr.w	.next2
	lsr.w	#$1,d0
	rts
.next2	movea.l	#$2E40E,a1
	tst.w	(a1,d1.w)
	beq.w	updatereplayExit
	movea.w	(a1,d1.w),a1
	move.l	d7,-(sp)
	move.l	a1,d7
	andi.l	#$FFFF,d7
	movea.l	d7,a1
	move.l	(sp)+,d7
	add.w	(a1,d0.w),d2
	rts
; Data that follows ReadStatColumn (strings, small tables)
ReadStatColumnData	dc.w	$B000,$0000,$B034,$0000,$B000,$B034,$B068,$0000
	dc.w	$B09C,$0000,$00B6,$FFFF,$00D0,$FFFF,$00B6,$00D0
	dc.w	$00EA,$FFFF,$0104,$FFFF,$0016,$5361,$7665,$7320
	dc.b	'Shots Save %  ',$00,$06
	dc.b	'   G',$00,$06,'   A',$00,$06,' Pts'
	dc.b	$00,$06,' SOG',$00,$06,' PIM'
	dc.b	$00,$16,'  '
	dc.b	'  Goalie Saves  '
	dc.b	' ]',$00,$16,'[      Goals'
	dc.b	'       ]',$00,$16,'[     '
	dc.b	'Assists      ]',$00,$16
	dc.b	'[      Points   '
	dc.b	'   ]',$00,$16,'[  Shots O'
	dc.b	'n Goal   ]',$00,$16,'[ Pe'
	dc.b	'nalty Minutes   '
; Prints the stat column header.
StatColumnHeader
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
	lea.l	.next(pc),a1
	jsr	(PrintTickerEntry).l
	movem.l	(sp)+,d0-d1/a1
	rts
; Table of 1 word after StatColumnHeader, 2 bytes: $000A ...
.next	dc.w	$000A
CrowdMeterScreen						;"Crowd Meter": current, average and peak level (PrintCrowdMeter), plus
									;the arena and league records; start exits. Menu item handler
; Table of 245 words after CrowdMeterScreen, 250 bytes: $20FB,$FFFA,$0C20,$F900,$000A,$7B ...
	dc.w	$20FB,$FFFA,$0C20,$F900,$000A
	dc.b	$7B,$FB,$FF,$FA,$0C,$20,$F9,$00,$00,$0A,$20,$FB,$FF,$FA,$0C,$7D	; {.... .... ....}
	dc.b	$F9,$00,$00,$0A,$7B,$FB,$FF,$FA,$0C,$7D,$F9,$00,$70,$09,$72,$1C	; ....{....}..p.r.
	dc.b	$61,$00,$01,$CC,$4E,$B9,$00,$03,$8F,$6E,$00,$06,$BD,$06,$01,$00	; a...N....n......
	dc.b	$70,$1C,$72,$06,$4E,$B9,$00,$03,$8C,$A0,$4E,$B9,$00,$03,$92,$58	; p.r.N.....N....X
	dc.b	$00,$14,$BD,$09,$04,$43,$72,$6F,$77,$64,$20,$20,$4D,$65,$74,$65	; .....Crowd  Mete
	dc.b	$72,$BD,$07,$01,$70,$2C,$61,$00,$E0,$0C,$06,$79,$00,$04,$00,$01	; r...p,a....y....
	dc.b	$8D,$58,$42,$40,$61,$00,$DF,$FE,$61,$00,$00,$12,$61,$00,$08,$3A	; .XB@a...a...a..:
	dc.b	$08,$01,$00,$07,$66,$00,$03,$D0,$60,$00,$FF,$F2,$4E,$B9,$00,$03	; ....f...`...N...
	dc.b	$8D,$8C,$00,$16,$F8,$04,$02,$04,$0C,$43,$75,$72,$72,$65,$6E,$74	; .........Current
	dc.b	$20,$4C,$65,$76,$65,$6C,$FD,$1C,$30,$39,$00,$01,$7C,$D8,$61,$00	;  Level..09..|.a.
	dc.b	$01,$24,$4E,$B9,$00,$03,$8D,$8C,$00,$16,$FD,$04,$FA,$02,$41,$76	; .$N...........Av
	dc.b	$65,$72,$61,$67,$65,$20,$4C,$65,$76,$65,$6C,$FD,$1C,$00,$20,$39	; erage Level... 9
	dc.b	$00,$01,$7C,$DE,$80,$F9,$00,$01,$7C,$DC,$61,$00,$00,$F8,$4E,$B9	; ..|.....|.a...N.
	dc.b	$00,$03,$8D,$8C,$00,$12,$FD,$04,$FA,$02,$50,$65,$61,$6B,$20,$4C	; ..........Peak L
	dc.b	$65,$76,$65,$6C,$FD,$1C,$30,$39,$00,$01,$7C,$DA,$61,$00,$00,$D6	; evel..09..|.a...
; Crowd meter: reads the crowd record and prints the level
CrowdMeterScreenDraw	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	$193BA.l
	bmi.w	CrowdMeterScreenExit
	move.w	$17FAE.l,d1
	ext.l	d1
	movea.l	#$BC000,a0
	jsr	(ReadCrowdRecord).l
	move.b	$8(a0),d0
	bne.w	.next
	move.b	#$50,d0
.next	andi.w	#$FF,d0
	move.w	d0,-(sp)
	jsr	(printsmallz).l
; Inline data read by $38D8C from the return address (2 rows).
	dc.b	$00,$14,$FD,$04,$FA,$02,$41,$72,$65,$6E,$61,$20,$52,$65,$63,$6F	; ......Arena Reco
	dc.b	$72,$64,$FD,$1C	; rd..
	move.w	(sp)+,d0
	move.w	#$3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$20,$64,$42,$00	; .. dB.
	jsr	(GetLeagueCrowdRecord).l
	move.w	d0,d1
	ext.l	d1
	movea.l	#$BC000,a0
	jsr	(ReadCrowdRecord).l
	move.b	$8(a0),d0
	bne.w	.next2
	move.w	#$50,d0
.next2	andi.w	#$FF,d0
	move.w	d0,-(sp)
	jsr	(printsmallz).l
; Inline data read by $38D8C from the return address (2 rows).
	dc.b	$00,$16,$FD,$04,$FA,$02,$4C,$65,$61,$67,$75,$65,$20,$52,$65,$63	; ......League Rec
	dc.b	$6F,$72,$64,$FD,$1C,$00	; ord...
	move.w	(sp)+,d0
	move.w	#$3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$20,$64,$42,$00	; .. dB.
; Crowd meter: restores the registers and returns
CrowdMeterScreenExit	movem.l	(sp)+,d0-d7/a0-a6
	rts
	ext.l	d0
	asl.w	#$2,d0
	jsr	(Sroot).l
	addi.w	#$41,d0
	moveq	#$3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$20,$64,$42,$00	; .. dB.
	rts
; Forces black and sets display flags for the crowd meter screen.
CrowdMeterFadeIn
	movem.l	d0-d1/a2,-(sp)
	jsr	(forceblack).l
	bclr	#$0,(disflags).l
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	move.w	$18D32.l,d0
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
	move.w	#$6,$18D3E.l
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
; Inline data read by DecompressGraphicsWithRemap from the return address (13 rows).
	dc.l	$91234567,$89ABCDEF
	dc.w	$3839,$0001,$8D42,$4EB9,$0003,$93E8,$4EB9,$0003
	dc.w	$8F6E,$0006,$BD00,$0000,$2279,$0004,$7D0C,$D3E9
	dc.w	$0004,$247C,$0001,$B008,$4240,$4241,$3411,$3629
	dc.w	$0002,$7801,$7A00,$4EB9,$0003,$87E2,$4EB9,$0003
	dc.w	$8F6E,$0006,$FD00,$0000,$4CD7,$0403,$D179,$0001
	dc.w	$8D5A,$2079,$0004,$7D0C,$2248,$2448,$D1DA,$D3DA
	dc.w	$3601,$9640,$3200,$4240,$7428,$7A0D,$4EB9,$0003
	dc.w	$87E2,$33C4,$0001,$8D44,$2479,$0004,$7D3C,$508A
	dc.w	$4EB9,$0003,$8946,$D123,$4567,$89AB,$CDEF,$4EB9
	dc.w	$0003,$8F6E,$0006,$FE00,$0000,$7040,$7220,$343C
	dc.w	$07FF,$4EB9,$0003,$8C06,$33FC,$0018,$0001,$8D62
	dc.w	$4CDF,$0403,$4E75
; Black out, set the display flags and fade a stats screen in
StatsScreenFadeIn
	jsr	(forceblack).l
; Stats screen: clears VRAM through the gate array while fading in.
StatsScreenFadeInClear
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	move.w	$18D30.l,d0
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
	move.b	$18D30.l,d0
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
	move.w	#$5,$18D3E.l
.loop10	tst.w	(palcount).l
	bpl.w	.loop10
	move.w	(sp)+,(disflags).l
	bset	#$1,(disflags).l
	move.w	$18D48.l,d4
	movea.l	$47D18.l,a2
	addq.l	#$8,a2
	btst	#$4,$17F72.l
	beq.w	.next
	movea.l	$47D64.l,a2
	addq.l	#$8,a2
.next	jsr	(DecompressGraphicsPlain).l
	jsr	(UnpackPictureSelectGfx).l
	move.w	$18D42.l,d4
	movea.l	(SmallFontMap).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
; Inline data read by DecompressGraphicsWithRemap from the return address (1 row).
	dc.l	$43434567,$89ABCDEF
	move.w	$18D4E.l,d4
	jsr	(AddSmallFontFramer).l
	jsr	(SetupIceRinkPalRemap).l
	jsr	$3EC94.l
	jsr	$3ECA6.l
	jsr	(setupIceRinkPal).l
	jmp	(CopyTeamLinesCheckTeam).l
; Table of 336 bytes after StatsScreenFadeIn, 336 bytes: $04,$79,$00,$01,$00,$01 ...
	dc.b	$04,$79,$00,$01,$00,$01,$8A,$D2,$04,$79,$00,$01,$00,$01,$8A,$D4	; .y.......y......
	dc.b	$23,$FC,$00,$04,$20,$DC,$00,$01,$8A,$D6,$08,$EA,$00,$02,$00,$32	; #... ..........2
	dc.b	$4E,$B9,$00,$03,$8F,$6E,$00,$06,$BD,$05,$0C,$00,$70,$16,$72,$06	; N....n......p.r.
	dc.b	$4E,$B9,$00,$03,$8C,$A0,$4E,$B9,$00,$03,$8F,$6E,$00,$10,$BD,$0C	; N.....N....n....
	dc.b	$0E,$54,$69,$6D,$65,$6F,$75,$74,$BD,$11,$0F,$00,$22,$6A,$00,$1E	; .Timeout...."j..
	dc.b	$D2,$E9,$00,$04,$30,$11,$E2,$48,$91,$79,$00,$01,$8D,$58,$4E,$B9	; ....0..H.y...XN.
	dc.b	$00,$03,$8F,$80,$24,$7C,$00,$01,$83,$4C,$4E,$B9,$00,$03,$C9,$B6	; ....$|...LN.....
	dc.b	$D5,$FC,$00,$00,$03,$66,$4E,$B9,$00,$03,$C9,$B6,$70,$78,$4E,$F9	; .....fN.....pxN.
	dc.b	$00,$03,$72,$D0,$3F,$39,$00,$01,$8A,$D2,$3F,$39,$00,$01,$8A,$D4	; ..r.?9....?9....
	dc.b	$61,$00,$01,$A4,$33,$C0,$00,$01,$8A,$D4,$4E,$B9,$00,$03,$8F,$6E	; a...3.....N....n
	dc.b	$00,$06,$BD,$04,$0C,$00,$70,$18,$72,$03,$D2,$79,$00,$01,$8A,$D4	; ......p.r..y....
	dc.b	$4E,$B9,$00,$03,$8C,$A0,$30,$2A,$00,$28,$6A,$00,$00,$04,$70,$FF	; N.....0*.(j...p.
	dc.b	$06,$40,$00,$01,$33,$C0,$00,$01,$8A,$D2,$61,$00,$00,$84,$61,$00	; .@..3.....a...a.
	dc.b	$01,$E8,$08,$01,$00,$07,$66,$00,$00,$48,$08,$01,$00,$05,$66,$00	; ......f..H....f.
	dc.b	$00,$40,$08,$01,$00,$01,$67,$00,$00,$1A,$30,$39,$00,$01,$8A,$D2	; .@....g...09....
	dc.b	$52,$40,$B0,$79,$00,$01,$8A,$D4,$6E,$00,$FF,$D0,$33,$C0,$00,$01	; R@.y....n...3...
	dc.b	$8A,$D2,$08,$01,$00,$00,$67,$00,$FF,$C2,$04,$79,$00,$01,$00,$01	; ......g....y....
	dc.b	$8A,$D2,$6A,$00,$FF,$B6,$42,$79,$00,$01,$8A,$D2,$60,$00,$FF,$AC	; ..j...By....`...
	dc.b	$30,$39,$00,$01,$8A,$D2,$04,$40,$00,$01,$6A,$00,$00,$0C,$0C,$6A	; 09.....@..j....j
	dc.b	$FF,$FF,$00,$28,$6D,$00,$00,$0C,$35,$40,$00,$28,$4E,$B9,$00,$03	; ...(m...5@.(N...
	dc.b	$D4,$26,$33,$DF,$00,$01,$8A,$D4,$33,$DF,$00,$01,$8A,$D2,$4E,$75	; .&3.....3.....Nu
; Stats rows: starts at row $D
StatsRowsInit	move.w	#$D,$18D5A.l
	move.w	$18AD4.l,d1
	moveq	#$0,d0
; Stats rows: prints one row of the table
StatsRowsLoop	move.w	#$5,$18D58.l
	move.w	#$A000,$18D5C.l
	cmp.w	$18AD2.l,d0
	bne.w	.next
	move.w	#$8000,$18D5C.l
.next	jsr	(printz).l
; Inline data read by $38F6E from the return address (2 rows).
	dc.b	$00,$18,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20	; ..              
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20	;         
; Stats rows: prints "no goalie" when the team has none
StatsRowNoGoalie	tst.w	d0
	bne.w	StatsRowGoalieName
	move.w	#$B,$18D58.l
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
	move.w	#$8,$18D58.l
	jsr	(print).l
	move.b	(a1),d2
	lsr.b	#$4,d2
	addi.b	#$30,d2
	move.b	d2,$17EF4.l
	move.b	(a1),d2
	andi.b	#$F,d2
	addi.b	#$30,d2
	move.b	d2,$17EF5.l
	movea.l	#$17EF2,a1
	move.w	#$4,(a1)
	move.w	#$5,$18D58.l
	jsr	(print).l
; Stats rows: next row
StatsRowsNext	addi.w	#$1,$18D5A.l
	addi.w	#$1,d0
	dbra	d1,StatsRowsLoop
	rts
GetGoalieCount						;d0 = goalies on team a2 (nibbles in a team data word)
	movem.l	d1/a0,-(sp)
	movea.l	$1E(a2),a0
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
	movea.l	$1E(a2),a0
	adda.w	$8(a0),a0
	move.b	$3(a0),d0
	lsr.w	#$4,d0		;high nibble
	add.w	(sp)+,d0
	movem.l	(sp)+,a0
	rts
GetForwardCount						;d0 = forwards on team a2 (high nibble of team data byte 3 at +8)
	movem.l	a0,-(sp)
	movea.l	$1E(a2),a0
	adda.w	$8(a0),a0
	move.b	$3(a0),d0
	lsr.w	#$4,d0		;high nibble = forward count
	andi.w	#$F,d0		;forward count
	movem.l	(sp)+,a0
	rts
GetPlayerCount
	movem.l	a0,-(sp)
	movea.l	$1E(a2),a0
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
FrameWaitStep	move.w	$17474.l,d1
.loop	cmp.w	$17474.l,d1
	beq.w	.loop
	dc.w	$6100,$04FC		; bsr.w X_2F2F0
	jsr	(nodiag).l
	tst.b	d1
	beq.w	FrameWaitStep
	rts
	bclr.b	#$0,$17F74.l
	bsr.w	forceblack
	move.w	$18D64.l,-(sp)
	bset.b	#$3,$17F6C.l
	bclr.b	#$4,$17F72.l
	jsr	(ClrHor).l
	move.w	#$400,d0
	move.w	$18D3C.l,d1
	move.w	#$7FF,d2
	jsr	(DoDMANd2Queue).l
	move.w	$18D56.l,d4
	movea.l	$47D68.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	jsr	(ReadActiveJoypadPrint).l
	bclr.b	#$5,$17F6A.l
	bclr.b	#$5,$17F6E.l
	st.b	$17D6E.l
	movea.l	$17470.l,a4
.loop2	bsr.w	suba4
	tst.w	d7
	bne.w	.loop2
	jsr	(SprSort).l
	jsr	(setvideo).l
	bclr.b	#$1,$17F6E.l
	clr.l	$17DCA.l
	clr.l	$17DCE.l
	clr.l	$17DD2.l
	move.w	#$18,$18D62.l
	moveq	#$1,d7
; Waits until d7 frames have passed
WaitFramesD7	move.w	$17474.l,d0
	sub.w	$17476.l,d0
	cmp.w	d0,d7
	bhi.w	WaitFramesD7
	move.w	$17474.l,$17476.l
	tst.w	$1AD56.l
	bmi.w	.next
	sub.w	d7,$1AD56.l
	bpl.w	.next
	clr.w	$1AD56.l
	jsr	$2F37E.l
.next	movem.l	d0/a3,-(sp)
	movea.l	#$17A80,a3
	move.w	#$1,$8(a3)
	movea.l	#$17B00,a3
	move.w	#$1,$8(a3)
	movem.l	(sp)+,d0/a3
	moveq	#$1,d7
	dc.w	$6100,$03E0		; bsr.w X_2F2F0
	btst.b	#$0,$17F74.l
	beq.w	.next2
	andi.w	#$FFF0,d0
	ori.w	#$8,d0
	andi.w	#$FFF0,d1
	andi.w	#$FFF0,d3
.next2	movea.l	#$17D58,a5
	btst.b	#$5,$17F6E.l
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
.next5	bset.b	#$5,$17F6A.l
	bne.w	.next6
	move.w	$17CEE.l,$0(a5)
	move.w	$17CEA.l,$14(a5)
.next6	move.w	d0,d5
	andi.w	#$7,d5
	eori.w	#$4,d5
	movea.l	#$17480,a1
	st.b	d3
	bclr.b	#$5,$17F6E.l
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
	bset.b	#$5,$17F6E.l
.next8	adda.l	#$80,a1
	dbra	d2,.loop
	adda.w	#$4,sp
	btst.b	#$5,$17F6E.l
	beq.w	.next9
	move.w	$16(a5),d0
	asl.w	#$7,d0
	movea.l	#$17480,a3
	adda.w	d0,a3
	moveq	#$4,d4
	bsr.w	setpads
	bsr.w	UpdateCameraPos
	jsr	(setvideo).l
	bra.w	WaitFramesD7
.next9	bset.b	#$5,$17F6A.l
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
	andi.w	#$FFF,$17DC8.l
	ori.w	#$E000,$17DC8.l
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
	btst.b	#$0,$17F74.l
	bne.w	.next
	bchg.b	#$1,$17F6E.l
.next	btst	#$6,d3
	beq.w	.next2
	btst.b	#$0,$17F74.l
	bne.w	.next2
	bsr.w	suba4
	bsr.w	suba4
	bsr.w	suba4
	bsr.w	suba4
	jsr	(SprSort).l
	jsr	(setvideo).l
	moveq	#$1,d7
	bclr.b	#$1,$17F6E.l
.next2	btst.b	#$0,$17F74.l
	bne.w	.next4
	btst	#$4,d3
	beq.w	.next4
	btst	#$6,d3
	beq.w	.next3
	bclr.b	#$5,$17F6E.l
	bclr.b	#$5,$17F6A.l
	move.w	d0,-(sp)
	move.w	$17DC8.l,d0
	andi.w	#$FFF,d0
	ori.w	#$E000,d0
	move.w	d0,$17DC8.l
	move.w	(sp)+,d0
	bra.w	WaitFramesD7
.next3	bsr.w	adda4
	jsr	(SprSort).l
	jsr	(setvideo).l
	asl.w	#$1,d7
	bclr.b	#$1,$17F6E.l
.next4	btst.b	#$1,$17F6E.l
	beq.w	.next5
	st.b	$17F64.l
	bsr.w	adda4
	move.w	$17F64.l,-(sp)
	bsr.w	sfx
	jsr	(SprSort).l
.next5	jsr	(setvideo).l
	btst.b	#$0,$17F74.l
	bne.w	.next6
	btst	#$7,d1
	beq.w	WaitFramesD7
	jsr	$2F39C.l
	bclr.b	#$1,$17F6E.l
	bset.b	#$0,$17F74.l
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
	bset.b	#$6,$17F72.l
	bclr.b	#$0,$17F74.l
	jsr	$2F3D6.l
	bsr.w	adda4
	jsr	(SprSort).l
	bra.w	WaitFramesD7
.next7	jmp	(WaitFramesD7).l
.next8	clr.w	$18AD2.l
	bset.b	#$1,$17F74.l
.next9	bsr.w	forceblack
	ori.w	#$F000,$17DC8.l
	bclr.b	#$5,$17F6A.l
	movea.l	$17470.l,a4
	bclr.b	#$4,$17F72.l
	bsr.w	RestoreReplayFrameCopy
	jsr	(SprSort).l
	bclr.b	#$3,$17F6C.l
	move.w	(sp)+,$18D64.l
	jsr	(StatsScreenFadeInClear).l
	jsr	(SetupIceRinkPalRemap).l
	jsr	$3EC94.l
	jsr	$3ECA6.l
	jsr	(IceRinkRemapGfxB).l
	btst.b	#$4,$18D64.l
	beq.w	.next10
	jsr	(IceRinkRemapGfxD).l
	jsr	(IceRinkRemapGfxC).l
.next10	jsr	(SetHor).l
	jsr	(setvideo).l
	move.w	#$18,$18D62.l
	rts

; Reads joypad 2 or 1 depending on the port flag.
ReadActiveJoypad
	tst.w	$18BF8.l
	bne.w	.next2
.loop	btst	#$1,$17F6A.l
	beq.s	.next
	jmp	(ReadJoy2).l
.next	jmp	(ReadJoy1).l
.next2	tst.w	$17F94.l
	beq.w	.loop
	cmpi.w	#$3,$17F94.l
	bne.s	.next3
	jmp	(ReadJoy3).l
.next3	jmp	(ReadJoy4).l
; Prints the controller text on the pad test screen.
ReadActiveJoypadPrint
	move.w	#$F0,$1AD56.l
	jsr	(printz).l
	String	CC_Font3Pri,$2,$2
	moveq	#$20,d0
	moveq	#$55,d1
	moveq	#$8,d2
	moveq	#$4,d3
	move.w	$18D48.l,d4
	move.w	#$0,d5
	movea.l	$47D18.l,a1
	btst	#$4,$17F72.l
	beq.w	.next4
	movea.l	$47D64.l,a1
.next4	adda.l	$4(a1),a1
	movea.l	#$1B008,a2
	jmp	(dobitmap).l
; Table of 56 words after ReadActiveJoypad, 112 bytes: $4EB9,$0003,$8F6E,$0006,$BD02,$0200 ...
	dc.w	$4EB9,$0003,$8F6E,$0006,$BD02,$0200,$303C,$0008
	dc.w	$323C,$0004,$343C,$07FF,$4EF9,$0003,$8C06,$50F9
	dc.w	$0001,$AD56,$4EB9,$0003,$8F6E,$0006,$BD02,$0000
	dc.w	$7000,$7200,$7410,$760B,$3839,$0001,$8D56,$3A3C
	dc.w	$0000,$2279,$0004,$7D68,$D3E9,$0004,$247C,$0001
	dc.w	$B008,$4EF9,$0003,$87E2,$4EB9,$0003,$8F6E,$0006
	dc.w	$BD02,$0200,$303C,$0010,$323C,$000B,$343C,$07FF
	jmp	(eraser).l