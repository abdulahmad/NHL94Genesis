;	New in 95: Create Player. The list, the letter grid, the rating pool and the save
;	into the created-player records.

CreateScreenGfx	;Set up VDP planes and load create-player graphics/palettes
	move.l	#VBlank_SetOptions,(vbint).w
	move	#$2500,sr
	bclr	#0,(disflags).w
	bset	#2,(disflags).w
	bclr	#1,(disflags).w
	move.w	#0,(VSCRLPM).w
	move.w	#$B400,(VSPRITES).w
.0
	move.w	#$B800,(VmMap3).w
	move.w	#5,(Map3col1).w
	move.w	#$C000,(VmMap2).w
	move.w	#6,(Map2col1).w
	move.w	#$E000,(VmMap1).w
	move.w	#6,(Map1col1).w
	move.w	#0,d0
	jsr	(setVram).l
	jsr	(orjoy).l
	move.w	#1,d4
	move.w	d4,(smallfontchars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$23,$44,$67,$89,$AB,$CD,$EF
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$23,$4C,$67,$89,$AB,$CD,$EF
	move.w	d4,(smallfont3chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$23,$47,$67,$89,$AB,$CD,$EF
	move.w	d4,(smallfont4chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$BB,$23,$44,$67,$89,$AB,$CD,$EF
	move.l	#SmallFontMap,(smallfontptr).l
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$67,$89,$AB,$CD,$EF
	move.w	d4,(teamblocksmapptr).w
	movea.l	#Teamblocksmap+8,a2
	jsr	(DecompressGraphicsPlain).l
	movea.l	#CreateFramerMap+8,a2
	move.w	d4,(framercset).w
	move.l	#CreateFramerMap,(framermapptr).l
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$67,$89,$AB,$CD,$EF
	jsr	(printz).l
	String	-TXMAP2,0,0,0
	movea.l	#CreateBgMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#$1C,d3
	moveq	#$F,d5
	jsr	(dobitmap).l
	move.w	d4,(StatWork+$3C).w
	rts

CreatePlayer	;Create Player screen entry: load graphics, draw title, init player list and name editor
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#1,(BA_PS_flags).w
	bsr.w	CreateRatingsGfx
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$67,$89,$AB,$CD,$EF
	move.w	d4,(spritechars).w
	movea.l	#NameEntryBgMap+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	#$18,(palcount).w
	bclr	#2,(disflags).w

.createPlayerRedraw	;(re)draw "Create Player" title and player list
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),7,2,'Create Player'
	bsr.w	ReadCreatedPlayers
	clr.w	(CreateListOldRow).w
	move.w	#1,(CreateListRow).w
	clr.w	d0
	move.w	(createdcount).l,d0
	subq.w	#1,d0
.0
	move.w	d0,(CreateListSel).l
	subq.w	#6,d0
	bpl.w	.1
	clr.w	d0
.1
	move.w	d0,(CreateListTop).l
	move.w	(CreateListSel).l,d0
	addq.w	#1,d0
	move.w	d0,(CreateListRow).w
	movea.l	#CreateNameBuf,a1
	bsr.w	GetCreateName
	bsr.w	DrawCreateList
	clr.w	d4
	bsr.w	FixFirstLetter
	bsr.w	rtsCreate2
	bsr.w	GridLetterPos
	move.w	(printx).w,-(sp)
	move.w	(printy).w,-(sp)
	jsr	(NameEntryFramer).l
	move.w	(sp)+,(printy).w
	addq.w	#1,(printy).w
.2
	move.w	(sp)+,(printx).w
	addq.w	#1,(printx).w
.3
	bsr.w	PrintGridLetter
	move.w	#1,(NameEntryMode).w
	bsr.w	NameEntry
	clr.w	d0
	bra.w	.nameCursorMove

.createPlayerLoop	;Main input loop: list mode scrolls players, edit mode moves name/char cursors
	bsr.w	CountNameLength
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),5,$12,0
	tst.w	(NameEntryMode).w
	beq.w	.4
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),9,5,0
	move.w	(CreateListRow).w,d0
	sub.w	(CreateListTop).l,d0
	add.w	d0,(printy).w
	movea.l	#CreateNameBuf,a1
	bsr.w	PrintEditName
.4
	bsr.w	MoveListMarkers
.loop
	move.w	(vcount).w,d0
.loop2
	cmp.w	(vcount).w,d0
	beq.s	.loop2
	jsr	(ReadJoy1).l
	tst.w	d1
	beq.s	.loop
	tst.w	(NameEntryMode).w
	bne.w	.edit
	move.w	#1,d0
	btst	#7,d1
	bne.w	.createPlayerExit
	btst	#1,d1
	bne.w	.createListMove
	move.w	#$FFFF,d0
	btst	#0,d1
	bne.w	.createListMove
	btst	#4,d1
	beq.w	.createPlayerLoop
	clr.w	d4
	clr.w	d5
	bsr.w	NameEntry
	clr.w	d0
	bra.w	.createListMove
.edit
	moveq	#$FFFFFFFF,d0
	btst	#7,d1
	bne.w	.createNameDone
	btst	#6,d1
	bne.w	.nameCursorMove
	neg.w	d0
	btst	#5,d1
	bne.w	.nameCursorMove
	btst	#3,d1
	bne.w	.gridCursorMove
	neg.w	d0
	btst	#2,d1
	bne.w	.gridCursorMove
	moveq	#6,d0
	btst	#1,d1
	bne.w	.gridCursorMove
	neg.w	d0
	btst	#0,d1
	bne.w	.gridCursorMove
	btst	#4,d1
	beq.w	.createPlayerLoop
	bsr.w	NameEntry
	bra.w	.createPlayerLoop

.createListMove	;Move player-list selection by d0 and scroll the list window
	add.w	d0,(CreateListRow).w
	move.w	(CreateListRow).w,d1
	cmp.w	(createdcount).l,d1
	ble.w	.8
	sub.w	d0,(CreateListRow).w
.8
	tst.w	(CreateListRow).w
	bne.w	.9
	sub.w	d0,(CreateListRow).w
.9
	move.w	(CreateListRow).w,d0
	subq.w	#1,d0
	cmp.w	(CreateListTop).l,d0
	bge.w	.10
	subq.w	#1,(CreateListTop).l
	subq.w	#1,(CreateListSel).l
	bsr.w	DrawCreateList
.10
	cmp.w	(CreateListSel).l,d0
	ble.w	.11
	addq.w	#1,(CreateListTop).l
	addq.w	#1,(CreateListSel).l
	bsr.w	DrawCreateList
.11
	movea.l	#CreateNameBuf,a1
	bsr.w	GetCreateName
	tst.w	(NameEntryMode).w
	bne.w	.12
	jsr	(NameListHelp).l
	bra.w	.createPlayerLoop
.12
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),4,$13,0
	add.w	d4,(printx).w
	jsr	(printz).l
	String	'   ',0
	bsr.w	GridLetterPos
	moveq	#1,d2
	move.w	(printx).w,-(sp)
	move.w	(printy).w,-(sp)
	jsr	(eraser).l
	move.w	(sp)+,(printy).w
	addq.w	#1,(printy).w
	move.w	(sp)+,(printx).w
	addq.w	#1,(printx).w
	bsr.w	PrintGridLetter
	bsr.w	FixFirstLetter
	move.w	d4,d0
	neg.w	d0
	bra.w	.nameCursorMove

.nameCursorMove	;Move name cursor (d4, 0-$11) by d0
	add.w	d4,d0
	cmp.w	#$11,d0
	bhi.w	.createPlayerLoop
	move.w	d0,d4
	bsr.w	rtsCreate2
	movea.l	#CreateNameBuf,a0
	clr.w	d0
	cmpi.b	#$2D,(a0,d4.w)
	beq.w	.gridCursorMove
	move.b	(a0,d4.w),d0
	ext.w	d0
	bsr.w	FindGridLetter
	sub.w	d5,d0

.gridCursorMove	;Move character-grid cursor (d5, 0-$1D) by d0 and write char into name buffer
	add.w	d5,d0
	cmp.w	#$1D,d0
	bhi.w	.createPlayerLoop
	move.w	d0,-(sp)
	bsr.w	GridLetterPos
	moveq	#1,d2
	move.w	(printx).w,-(sp)
	move.w	(printy).w,-(sp)
	jsr	(eraser).l
	move.w	(sp)+,(printy).w
	addq.w	#1,(printy).w
	move.w	(sp)+,(printx).w
	addq.w	#1,(printx).w
	bsr.w	PrintGridLetter
	move.w	(sp)+,d5
	bsr.w	GridLetterPos
	move.w	(printx).w,-(sp)
	move.w	(printy).w,-(sp)
	tst.w	(NameEntryMode).w
	beq.w	.13
	jsr	(NameEntryFramer).l
.13
	move.w	(sp)+,(printy).w
	addq.w	#1,(printy).w
	move.w	(sp)+,(printx).w
	addq.w	#1,(printx).w
	bsr.w	PrintGridLetter
	movea.l	#CreateNameBuf,a0
	movea.l	#CreateLetterGrid,a1
	move.b	(a1,d5.w),d0
	move.b	d0,(a0,d4.w)
	bra.w	.createPlayerLoop

.createNameDone	;Start in edit mode: validate name, save player and continue, else clear and redraw
	bsr.w	SaveCreateName
	bmi.w	.invalid
	bsr.w	InitCreateRecord
	jsr	(MakeSRAMChecksum).l
	jmp	(ModifyRatings).l
.invalid
	jsr	(printz).l
	String	-TXMAP1,0,0,0
	moveq	#$28,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	bra.w	.createPlayerRedraw

.createPlayerExit	;Start in list mode: leave create-player screen back to main flow
	movem.l	(sp)+,d0-d7/a0-a6
	bset	#6,(setupcardflags).w
	jmp	(Opening2).l

NameEntry	;Create Player name entry: toggle grid/edit mode, draw letter grid + help text, or the name list + arrow help
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$0,$D,$0
	move.w	#$28,d0
	move.w	#9,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	bchg	#0,(NameEntryMode+1).w
	bne.w	NameListMode
	bsr.w	NameEntryBg
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$A,$F,$0
	movea.l	#CreateLetterGrid,a0
	moveq	#4,d0
.loop
	moveq	#5,d1
	movea.l	#mesarea,a1
	move.w	#$E,(a1)+
.loop2
	move.b	(a0)+,(a1)+
	move.b	#$20,(a1)+
	dbf	d1,.loop2
	movea.w	#(mesarea-M68K_RAM),a1
	jsr	(print).l
	addq.w	#2,(printy).w
	subi.w	#$C,(printx).w
	dbf	d0,.loop
	jsr	(printz).l
	String	-TXMAP2,$16,$E,$0
	moveq	#$16,d0
	moveq	#7,d1
	jsr	(printsmallz).l
	String	CC_SetFont,$2
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$17,$F,$0
	jsr	(printsmallz).l
	String	'D-Pad to a   ',$0
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$17,$10,$0
	jsr	(printsmallz).l
	String	'letter.      ',$0
	move.w	#$17,(printx).w
	addq.w	#1,(printy).w
	move.w	(printx).w,-(sp)
	jsr	(printsmallz).l
	String	'C to select   '
	move.w	(sp),(printx).w
	addq.w	#1,(printy).w
	jsr	(printsmallz).l
	String	'letter.       '
	move.w	(sp),(printx).w
	addq.w	#1,(printy).w
	jsr	(printsmallz).l
	String	'A to go back. '
	move.w	(sp),(printx).w
	addq.w	#1,(printy).w
.2
	jsr	(printsmallz).l
	String	'B to cancel.  '
	move.w	(sp),(printx).w
.3
	addq.w	#2,(printy).w
	jsr	(printsmallz).l
	String	'START when    '
	move.w	(sp)+,(printx).w
	addq.w	#1,(printy).w
	jsr	(printsmallz).l
	String	'done.         '
.4
	jsr	(printsmallz).l
	String	CC_SetFont,$2

NameEntryDone	;NameEntry: return
	movem.l	(sp)+,d0-d7/a0-a6
.exit
	rts

NameEntryBg	;Draw name entry background graphic (NameEntryBgMap) at the printz position
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(spritechars).w,d4
	jsr	(printz).l
	String	-TXMAP1,$16,$E,$0
.0
	movea.l	#NameEntryBgMap,a0
	movea.l	a0,a1

NameEntryBgTail	;Unreferenced label: map draw tail of NameEntryBg
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#1,d2
	moveq	#$A,d3
	moveq	#$F,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

NameListMode	;NameEntry: name list mode (list and arrow help)
	movea.l	#CreateNameBuf,a1
	bsr.w	GetCreateName
	move.w	#0,(printx).w
.0
	move.w	#$F,(printy).w
	move.w	#$28,d0
	move.w	#$D,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	jsr	(printz).l
	String	-TXMAP2,$16,$E,$0
	moveq	#$16,d0
	moveq	#7,d1
	bsr.w	DrawCreateList
	bsr.w	NameListHelp
	bra.s	NameEntryDone

NameListHelp	;Print help text for name list mode (D-Pad up/down / START exit / B edit)
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printsmallz).l
	String	CC_SetFont,$2
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$17,$F,$0
	jsr	(printsmallz).l
	String	'D-Pad up/down '
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$17,$10,$0
	jsr	(printsmallz).l
	String	'moves arrows. '
	move.w	#$17,(printx).w
	move.w	(printx).w,-(sp)
	addq.w	#2,(printy).w
	jsr	(printsmallz).l
	String	'Press START to'
	addq.w	#1,(printy).w
	move.w	(sp),(printx).w
	jsr	(printsmallz).l
	String	'exit.         '
	addq.w	#2,(printy).w
	move.w	(sp),(printx).w
	jsr	(printsmallz).l
	String	'Press B to    '
	move.w	(sp)+,(printx).w
	addq.w	#1,(printy).w
.0
	jsr	(printsmallz).l
	String	'edit.         '
	jsr	(printsmallz).l
	String	CC_SetFont,$0
	movem.l	(sp)+,d0-d7/a0-a6
.exit
	rts

FixFirstLetter	;Normalize first letter of name buffer to a letter grid char (unknown -> A)
	movem.l	d0-d4/a0-a6,-(sp)
	move.b	(CreateNameBuf).w,d0
	bsr.w	FindGridLetter
	cmp.w	#$1E,d0
	blt.w	.0
	clr.w	d5
	bra.w	.2
.0
	move.w	d0,d5
.1
	movea.l	#CreateLetterGrid,a0
	move.b	(a0,d5.w),(CreateNameBuf).w
.2
	movem.l	(sp)+,d0-d4/a0-a6
	rts

FindGridLetter	;Find char d0 in letter grid table, return index in d0 ($1E if not found)
	movem.l	d1-d3/a0-a6,-(sp)
	movea.l	#CreateLetterGrid,a0
	move.b	d0,d1
.0
	clr.w	d0
	move.w	#$1E,d3
.loop
	cmp.b	(a0,d0.w),d1
	beq.w	.2
	addq.w	#1,d0
	dbf	d3,.loop
	move.w	#$1E,d0
.2
	movem.l	(sp)+,d1-d3/a0-a6
	rts

rtsCreate2	;Empty return
	rts

PrintGridLetter	;If grid mode, print letter d5 of the grid table (cursor letter)
	tst.w	(NameEntryMode).w
	beq.s	rtsCreate2
	movea.l	#StatBuf,a1
	move.w	#4,(a1)
	move.b	#0,3(a1)
	movea.l	#CreateLetterGrid,a0
	move.b	(a0,d5.w),d0
	move.b	d0,2(a1)
	jmp	(print).l

GridLetterPos	;Set print position for letter grid cell d5 (6 per row), d0/d1 = frame size
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$9,$E,$0
	move.w	d5,d0
	ext.l	d0
	divu.w	#6,d0
	asl.w	#1,d0
	add.w	d0,(printy).w
	swap	d0
	asl.w	#1,d0
	add.w	d0,(printx).w
	moveq	#3,d0
	moveq	#3,d1
	rts

DrawCreateList	;Draw list of up to 6 player names starting at player CreateListTop
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(NameEntryLen).w,-(sp)
	move.w	(CreateListRow).w,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$9,$6,$0
	move.w	#6,d7
	cmp.w	(createdcount).l,d7
	blt.w	.0
	move.w	(createdcount).l,d7
	subq.w	#1,d7
.0
	move.w	(CreateListTop).l,(CreateListRow).w
	addq.w	#1,(CreateListRow).w
	movea.l	#StatWork,a1
.loop
	bsr.w	GetCreateName
	move.w	(printx).w,-(sp)
	bsr.w	PrintEditName
	move.w	(sp)+,(printx).w
	addq.w	#1,(printy).w
	addq.w	#1,(CreateListRow).w
	dbf	d7,.loop
	move.w	(sp)+,(CreateListRow).w
	move.w	(sp)+,(NameEntryLen).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts

MoveListMarkers	;Move selection arrows to the current list row if it changed
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(CreateListRow).w,d0
	cmp.w	(CreateListOldRow).w,d0
	beq.w	.0
	movea.l	#ListMarkersOff,a1
	bsr.w	PrintListMarkers
	movea.l	#ListMarkers,a1
	bsr.w	PrintListMarkers
.0
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrintListMarkers	;Print the 2 strings at a1 on old list row (left and x=$1C), then old row = current
	tst.w	(CreateListOldRow).w
	beq.w	.0
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$7,$6,$0
	move.w	(CreateListOldRow).w,d0
	subq.w	#1,d0
	sub.w	(CreateListTop).l,d0
	add.w	d0,(printy).w
	move.l	a1,-(sp)
	jsr	(print).l
	movea.l	(sp)+,a1
	adda.w	(a1),a1
	move.w	#$1C,(printx).w
	jsr	(print).l
.0
	move.w	(CreateListRow).w,(CreateListOldRow).w
	rts

ListMarkers	;Row markers ] and [
	String	']',$0;row marker chars (left of name, at x=$1C)
	String	'[',$0

ListMarkersOff	;Blanks that erase the row markers
	String	' ',$0;blanks (erase arrows)
	String	' ',$0

CountNameLength	;Count name length of name buffer CreateNameBuf into NameEntryLen
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$11,d3
	movea.l	#CreateNameBuf,a0
	clr.w	(NameEntryLen).w
.loop
	cmpi.b	#$2D,(a0)
	bne.w	.1
	tst.b	(a0)+
	bra.w	.2
.1
	tst.b	(a0)+
	beq.w	.3
	addq.w	#1,(NameEntryLen).w
.2
	dbf	d3,.loop
.3
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrintEditName	;Print 18-char name from a1 with - padding, highlight cursor char d4 in grid mode
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(NameEntryLen).w,-(sp)
	move.w	#$12,(NameEntryLen).w
	movea.l	#StatBuf,a0
	move.w	(NameEntryLen).w,d0
	move.w	#0,d3
	move.w	#$16,(a0)+
.loop
	cmp.w	#8,d3
	bne.w	.1
	move.b	#$20,(a0)+
.1
	move.b	(a1,d3.w),d1
	cmp.w	(NameEntryLen).w,d3
	blt.w	.2
	move.b	#$2D,d1
.2
	cmp.b	#$20,d1
	bne.w	.3
	move.b	#$2D,d1
.3
	move.b	d1,(a0)+
	addq.w	#1,d3
	cmp.w	#$12,d3
	blt.s	.loop
	movea.l	#StatBuf,a1
	move.w	(printx).w,d7
	move.l	a1,-(sp)
	jsr	(print).l
	movea.l	(sp)+,a1
	tst.w	(NameEntryMode).w
	beq.w	.6
	adda.w	d4,a1
	cmp.w	#8,d4
	blt.w	.4
	addq.w	#1,a1
.4
	addq.w	#2,a1
	movea.l	#StatWork,a0
	move.w	#4,(a0)
	move.b	(a1),2(a0)
	clr.b	3(a0)
	movea.l	a0,a1
	jsr	(printsmallz).l
	String	CC_SetFont,$1
	add.w	d4,d7
	cmp.w	#8,d4
	blt.w	.5
	addq.w	#1,d7
.5
	move.w	d7,(printx).w
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	CC_SetFont,$0
.6
	move.w	(sp)+,(NameEntryLen).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts

CreateLetterGrid	;Name entry letter grid (6 per row), $FF end
	dc.b	'ABCDEFGHIJKLMNOPQRSTUVWXYZ.12 -',$FF;letter grid characters (5 rows of 6)

GetCreateName	;Copy player name (CreateListRow-1)*18 from M68K_RAM to a1, 0->-, length to NameEntryLen
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#M68K_RAM,a0
	move.w	(CreateListRow).w,d2
	subq.w	#1,d2
	mulu.w	#$12,d2
	move.w	#0,(NameEntryLen).w
	move.w	#$11,d3
.loop
	move.b	(a0,d2.w),d0
	beq.w	.1
	bra.w	.2
.1
	move.b	#$2D,d0
	subq.w	#1,(NameEntryLen).w
	move.b	d0,(a1)+
	bra.w	.4
.2
	cmp.b	#$2D,d0
	bne.w	.3
	move.b	#$20,d0
.3
	move.b	d0,(a1)+
.4
	addq.w	#1,(NameEntryLen).w
	addq.w	#1,d2
	dbf	d3,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SaveCreateName	;Save entered name to the created-player record (new or existing); invalid name -> message; d0=0 ok/-1
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	BuildEnteredName
	bmi.w	InvalidName
	move.w	(CreateListRow).w,d0
	subq.w	#1,d0
	add.w	d0,d0
	movea.l	#CreatedIds,a0
	tst.w	(a0,d0.w)
	bmi.w	SaveNewName
	movem.l	d1-d3/a1,-(sp)
	movea.l	#SaveRAM+2*SRFreeAgentList,a1
	move.w	#0,d2
.loop
	move.w	(a1,d2.w),d3
	andi.w	#$FF,d3
	lsl.w	#8,d3
	move.w	2(a1,d2.w),d1
	andi.w	#$FF,d1
	or.w	d1,d3
	cmp.w	(a0,d0.w),d3
	beq.w	.1
	addq.w	#4,d2
	cmp.w	#$68,d2
	blt.s	.loop
	clr.w	d2
.1
	asr.w	#2,d2
	move.w	d2,(CreateWork).l
	movem.l	(sp)+,d1-d3/a1
	move.w	(a0,d0.w),d1
	andi.w	#$FF,d1
	move.w	d1,(CreateIndex).l
	asl.w	#5,d1
	add.w	d1,d1
	movea.l	#SaveRAM+2*SRCreatedPlayers,a0
	adda.w	d1,a0
	bsr.w	CopyNameWords
	bra.w	SaveNameOk

CopyNameWords	;Copy the length-prefixed name at StatWork into a0 as words
	movea.l	#StatWork,a1
	move.w	(a1),d0
	subq.w	#1,d0
	clr.w	d1
.loop
	move.b	(a1)+,d1
	move.w	d1,(a0)+
	dbf	d0,.loop
	rts

SaveNewName	;SaveCreateName, new player: take a free SRCreatedPlayers slot, store the name and add it to the free agent list
	bsr.w	CheckCreateSlots
	bmi.w	SaveNameNoSlot
	movea.l	#SaveRAM+2*SRCreatedPlayers,a0
	clr.w	d6
	move.w	#$13,d5
.loop
	tst.b	1(a0)
	bne.w	.1
	tst.b	3(a0)
	beq.w	.2
.1
	adda.l	#$40,a0
	addq.w	#1,d6
	dbf	d5,.loop
	bra.w	SaveNameNoSlot
.2
	bsr.s	CopyNameWords
	addq.w	#1,(SaveRAM+2*SRCreateCount).l
	movea.l	#SaveRAM+2*SRFreeAgentList,a0
	move.w	(SaveRAM+2*SRFreeAgentCount).l,d0
	cmp.b	#$1A,d0
	bge.w	SaveNameListFull
	clr.w	(CreateWork).l
.loop2
	tst.b	1(a0)
	bmi.w	.4
	addq.l	#4,a0
	addq.w	#1,(CreateWork).l
	bra.s	.loop2
.4
	move.b	d6,3(a0)
	andi.w	#$FF,d6
	move.w	d6,(CreateIndex).l
	move.b	#$1E,1(a0)
	addq.w	#1,(SaveRAM+2*SRFreeAgentCount).l

SaveNameOk	;SaveCreateName: name stored
	bra.w	SaveNameDone

SaveNameListFull	;SaveCreateName: free agent list full, fail
	bra.w	SaveNameError

SaveNameNoSlot	;SaveCreateName: no free created player slot, fail
	bra.w	SaveNameError

InvalidName	;SaveCreateName: "Invalid Name. Make sure player has both a first and last name." box
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$5,$5,$0
	move.w	#$1E,d0
	move.w	#$F,d1
	jsr	(Framer).l
	jsr	(printsmallz).l
	dc.w	$4C	;String length
	dc.b	$F9,$3,$FD,$6,$FC,$6,'Invalid Name.',$FD
	dc.b	$6,$FA,$1,'Make sure player has',$FD,$6,$FA,$1
	dc.b	'both a first and last name.'
	move.w	(vcount).w,d0
.loop
	cmp.w	(vcount).w,d0
	beq.s	.loop
.1
	jsr	(ReadJoy1).l
	tst.w	d1
	beq.s	.loop

SaveNameError	;SaveCreateName: back to font 0, d0 = -1
	jsr	(printsmallz).l
	String	CC_SetFont,$0
	move.w	#$FFFF,d0
	bra.w	SaveNameRet

SaveNameDone	;SaveCreateName: d0 = 0
	clr.w	d0

SaveNameRet	;SaveCreateName: return
	movem.l	(sp)+,d0-d7/a0-a6
.exit
	rts

ReadCreatedPlayers	;Read created players: load $36-byte list from save RAM SRFreeAgentList, build 18-byte name records at M68K_RAM and ids at CreatedIds, count in createdcount, add an empty slot if room
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	(createdcount).l
.0
	movea.l	#TradeBuf,a0
.1
	move.l	#SRFreeAgentList,d0
	moveq	#$36,d1
	jsr	(ReadSRAM).l
	move.w	#$1A,d6
	movea.l	#CreatedIds,a3
.2
	movea.l	#M68K_RAM,a2
.3
	move.w	#$FFFF,d5
.4
	bra.w	.6
.loop
	tst.w	(a0)+
	bmi.w	.6
	move.w	-2(a0),d0
	andi.w	#$1F00,d0
	cmp.w	#$1E00,d0
	bne.w	.6
	move.w	-2(a0),d0
	jsr	(GetCreatedName).l
	bsr.w	FormatNameRecord
	adda.w	#$12,a2
	move.w	-2(a0),d0
	move.w	d0,(a3)+
	addq.w	#1,(createdcount).l
.6
	addq.w	#1,d5
	dbf	d6,.loop
	cmpi.w	#$14,(createdcount).l
	bge.w	.8
	move.w	(SaveRAM+2*SRCreateCount).l,d0
	cmp.b	#$14,d0
	bge.w	.8
	move.w	#$11,d0
.loop2
	move.b	#0,(a2)+
	dbf	d0,.loop2
	move.w	#$8000,(a3)
	addq.w	#1,(createdcount).l
.8
	movem.l	(sp)+,d0-d7/a0-a6
	rts

BuildEnteredName	;Build the entered name (from CreateNameBuf, spaces/dashes dropped, space after first name) as a length-word string
	;at StatWork and check it has a first and last name; d0 = 0 ok, -1 invalid
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#linemarkbuf+2,a0
	movea.l	#CreateNameBuf,a1
	move.w	(NameEntryLen).w,d0
	subq.w	#1,d0
	clr.w	d5
	clr.w	d6
.loop
	cmp.w	#8,d6
	bne.w	.1
	move.b	#$20,(a0)+
	addq.w	#1,d5
.1
	move.b	(a1)+,d1
	cmp.b	#$20,d1
	beq.w	.2
	cmp.b	#$2D,d1
	beq.w	.2
	move.b	d1,(a0)+
	addq.w	#1,d5
.2
	addq.w	#1,d6
	dbf	d0,.loop
	btst	#0,d5
	beq.w	.3
	move.b	#0,(a0)
	addq.w	#1,d5
.3
	addq.w	#2,d5
	move.w	d5,(StatWork).w
	cmp.w	#6,d5
	blt.w	.7
	movea.l	#StatWork,a0
	adda.w	(a0),a0
	move.b	-(a0),d0
	tst.b	d0
	bne.w	.4
	move.b	-(a0),d0
.4
	cmp.b	#$20,d0
	beq.w	.7
	movea.w	#(StatWork-M68K_RAM),a0
	move.w	(a0)+,d0
	subq.w	#1,d0
.loop2
	cmpi.b	#$20,(a0)+
	beq.w	.6
	dbf	d0,.loop2
	bra.w	.7
.6
	clr.w	d0
	bra.w	.8
.7
	move.w	#$FFFF,d0
.8
	movem.l	(sp)+,d0-d7/a0-a6
	rts

FormatNameRecord	;Format name string at a1 into an 18-byte record at a2: first name padded to 8 and last name to 10 with dashes
	movem.l	d0-d7/a1-a2,-(sp)
	move.w	(a1)+,d7
	subq.w	#3,d7
	move.w	#7,d6
.loop
	cmpi.b	#$20,(a1)
	beq.w	.1
	move.b	(a1)+,d0
	move.b	d0,(a2)+
	subq.w	#1,d7
	dbf	d6,.loop
.1
	tst.w	d6
	bmi.w	.3
.loop2
	move.b	#$2D,(a2)+
	dbf	d6,.loop2
.3
	addq.w	#1,a1
	subq.w	#1,d7
	move.w	#9,d6
.loop3
	move.b	(a1)+,d0
	move.b	d0,(a2)+
	subq.w	#1,d6
	dbf	d7,.loop3
	tst.w	d6
	bmi.w	.6
.loop4
	move.b	#$2D,(a2)+
	dbf	d6,.loop4
.6
	movem.l	(sp)+,d0-d7/a1-a2
	rts

NewCreateRecord	;Same as InitCreateRecord but with bit 2 of sflags8 set (skips the read)
	bset	#2,(sflags8).w
	bra.w	InitCreateRecord2

InitCreateRecord	;Read 32-byte create record #CreateIndex from save RAM (SRCreatedPlayers) to CreateRecord, put an 8-byte tail on it by flag $1F, write it back
	bclr	#2,(sflags8).w

InitCreateRecord2	;InitCreateRecord without the bset (NewCreateRecord enters here)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#CreateRecord,a0
	clr.l	d0
	move.w	(CreateIndex).l,d0
	asl.w	#5,d0
	addi.l	#SRCreatedPlayers,d0
	moveq	#$20,d1
	movem.l	d0-d1/a0,-(sp)
	btst	#2,(sflags8).w
	bne.w	.0
	jsr	(ReadSRAM).l
.0
	movea.l	#CreateRecordTail2,a1
	tst.b	$1F(a0)
	bne.w	.1
	movea.l	#CreateRecordTail1,a1
.1
	adda.w	(a0),a0
	move.w	#7,d0
.loop
	move.b	(a1)+,(a0)+
	dbf	d0,.loop
	movem.l	(sp)+,d0-d1/a0
	jsr	(WriteSRAM).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

CreateRecordTail1	;8 byte record tail (record byte $1F clear)
	dc.b	$20
	dc.b	$82
	dc.b	$22
	dc.b	$22
	dc.b	0
	dc.b	0
	dc.b	$22
	dc.b	$22

CreateRecordTail2	;8 byte record tail (record byte $1F set)
	dc.b	$20
	dc.b	$82
	dc.b	$22
	dc.b	$22
	dc.b	$22
	dc.b	$42
	dc.b	$22
	dc.b	$22

CreateRatingsGfx	;Set up the create player screen: VDP setup, decompress graphics, print, draw background map
	move	#$2700,sr
	move.w	#2,d4
	move.l	#VBlank_SetOptions,(vbint).w
	bclr	#0,(disflags).w
	bset	#2,(disflags).w
	bclr	#1,(disflags).w
	move.w	#0,(VSCRLPM).w
	move.w	#$B400,(VSPRITES).w
	move.w	#$B800,(VmMap3).w
	move.w	#5,(Map3col1).w
	move.w	#$C000,(VmMap2).w
	move.w	#6,(Map2col1).w
	move.w	#$E000,(VmMap1).w
	move.w	#6,(Map1col1).w
	move.w	#0,d0
	jsr	(setVram).l
	move	#$2500,sr
	jsr	(orjoy).l
	move.w	d4,(framercset).w
	movea.l	#CreateFramerMap+8,a2
	move.l	#CreateFramerMap,(framermapptr).l
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$67,$89,$AB,$CD,$EF
	move.w	d4,(nameframechars).w
	movea.l	#CreateFramerMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$60,$89,$AB,$CD,$EF
	move.w	d4,(smallfontchars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$23,$44,$67,$89,$AB,$CD,$EF
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$23,$4C,$67,$89,$AB,$CD,$EF
	move.w	d4,(smallfont3chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$23,$47,$67,$89,$AB,$CD,$EF
	move.w	d4,(smallfont4chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$BB,$23,$44,$67,$89,$AB,$CD,$EF
	move.l	#SmallFontMap,(smallfontptr).l
	jsr	(printz).l
	String	-TXMAP1,$0,$0,$0
	moveq	#$28,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	jsr	(setupIceRinkPal).l
	jsr	(printz).l
	String	-TXMAP2,$0,$0,$0
	movea.l	#ControllerBgMap,a0
	btst	#1,(BA_PS_flags).w
	beq.w	.0
	movea.l	#TradeBgMap,a0
.0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#$1C,d3
	moveq	#$F,d5
	jsr	(dobitmap).l
	rts

CheckCreateSlots	;Check free create slots: d0/flags = -1 (N set) if 20 created players exist, else 1
	movem.w	d0,-(sp)
	move.w	(SaveRAM+2*SRCreateCount).l,d0
	cmp.b	#$14,d0
	blt.w	.0
	move.w	#$FFFF,d0
	bra.w	.1
.0
	move.w	#1,d0
.1
	movem.w	(sp)+,d0
	rts

ClearCreatedPlayers	;Clear the created players list at CreatedList (26 x $8000 + 0 terminator)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#CreatedList,a0
	move.w	#$19,d6
.loop
	move.w	#$8000,(a0)+
	dbf	d6,.loop
	move.b	#0,(a0)
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DeleteCreatedPlayer	;Delete created player #TempWord1: remove it from the save RAM records, roster list and team lines
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$1C,d7
	bset	#7,(GameFlags).w
	move.w	(TempWord1).w,d0
	andi.w	#$FF,d0
	movem.w	d0/d7,-(sp)
	jsr	(GetCreatedId).l
	move.w	d0,(a2)+
	movem.w	(sp)+,d0/d7
	jsr	(GetJerseyNumber).l
	move.w	(CreatedPlayerBuf).w,(a2)+
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#StatBuf,a0
	move.w	d7,d0
	asl.w	#5,d0
	ext.l	d0
	addi.l	#SRJerseyNums,d0
	moveq	#$20,d1
	movem.l	d0-d1/a0,-(sp)
	jsr	(ReadSRAM).l
	move.w	(TempWord1).w,d0
	andi.w	#$FF,d0
	move.w	#$19,d1
	sub.w	d0,d1
	beq.w	.1
.loop
	move.b	1(a0,d0.w),d2
	move.b	d2,(a0,d0.w)
	addq.w	#1,d0
	dbf	d1,.loop
.1
	movem.l	(sp)+,d0-d1/a0
	jsr	(WriteSRAM).l
	movem.l	(sp)+,d0-d7/a0-a6
	movea.l	#StatBuf,a0
	jsr	(ReadCreateList).l
	move.w	(TempWord1).w,d0
	andi.w	#$FF,d0
	add.w	d0,d0
	cmp.w	#$32,d0
	bne.w	.2
	move.w	#$8000,(StatBuf+$32).w
	bra.w	.4
.2
	move.w	#$32,d3
.loop2
	move.w	2(a0,d0.w),d1
	move.w	d1,(a0,d0.w)
	addq.w	#2,d0
	cmp.w	d3,d0
	blt.s	.loop2
	move.w	#$8000,(a0,d0.w)
.4
	subq.b	#1,$35(a0)
	jsr	(WriteCreateList).l
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$1A,d7
	jsr	(ReadTeamPlayerStats).l
	movea.l	#StatBuf,a3
	move.w	#4,d6
.loop3
	move.w	(TempWord1).w,d0
	andi.w	#$FF,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d3
	move.w	d3,(a2)+
	move.w	#$32,d3
.loop4
	move.w	2(a3,d0.w),d1
	move.w	d1,(a3,d0.w)
	addq.w	#2,d0
	cmp.w	d3,d0
	blt.s	.loop4
	clr.w	(a3,d0.w)
	adda.w	#$34,a3
	dbf	d6,.loop3
	jsr	(WriteTeamPlayerStats).l
	movem.l	(sp)+,d0-d7/a0-a6
	bclr	#7,(GameFlags).w
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

GetCreatedId	;Return player id word for created entry d0 from table SRFreeAgentList (4-byte entries)
	movem.l	d1-d7/a0-a6,-(sp)
	movea.l	#SaveRAM+2*SRFreeAgentList,a0
	add.w	d0,d0
	add.w	d0,d0
	adda.w	d0,a0
	move.w	2(a0),d0
	andi.w	#$FF,d0
	move.w	(a0),d7
	lsl.w	#8,d7
	andi.w	#$FF00,d7
	or.w	d7,d0
	movem.l	(sp)+,d1-d7/a0-a6
	rts

ReadCreateList	;Read the $36-byte created player list from save RAM SRFreeAgentList into a0
	movem.l	d0-d1,-(sp)
	move.l	#SRFreeAgentList,d0
	moveq	#$36,d1
	jsr	(ReadSRAM).l
	movem.l	(sp)+,d0-d1
	rts

WriteCreateList	;Write the $36-byte created player list at a0 to save RAM SRFreeAgentList (WriteSRAM). Saves d0-d1
	movem.l	d0-d1,-(sp)
	move.l	#SRFreeAgentList,d0
	moveq	#$36,d1
	jsr	(WriteSRAM).l
	movem.l	(sp)+,d0-d1
	rts

ModifyRatings	;Create Player "Modify Ratings" screen: load graphics/text, then joypad loop (up/down/left/right pick rating, A/B change it, START done)
	move	#$2700,sr
	move.w	#2,d4
	move.l	#VBlank_SetOptions,(vbint).w
	bclr	#0,(disflags).w
	bset	#2,(disflags).w
	bclr	#1,(disflags).w
	move.w	#0,(VSCRLPM).w
	move.w	#$B400,(VSPRITES).w
	move.w	#$B800,(VmMap3).w
	move.w	#5,(Map3col1).w
	move.w	#$C000,(VmMap2).w
	move.w	#6,(Map2col1).w
	move.w	#$E000,(VmMap1).w
	move.w	#6,(Map1col1).w
	move.w	#0,d0
	jsr	(setVram).l
	move	#$2500,sr
	jsr	(orjoy).l
	move.w	d4,(framercset).w
	move.l	#CreateFramerMap,(framermapptr).l
	movea.l	#CreateFramerMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$67,$89,$AB,$CD,$EF
	move.w	d4,(nameframechars).w
	movea.l	#CreateFramerMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$60,$89,$AB,$CD,$EF
	move.w	d4,(smallfontchars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$23,$44,$67,$89,$AB,$CD,$EF
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$23,$4C,$67,$89,$AB,$CD,$EF
	move.w	d4,(smallfont3chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$23,$47,$67,$89,$AB,$CD,$EF
	move.w	d4,(smallfont4chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$BB,$23,$44,$67,$89,$AB,$CD,$EF
	jsr	(printz).l
	String	-TXMAP1,$0,$0,$0
	moveq	#$28,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	jsr	(setupIceRinkPal).l
	jsr	(printz).l
	String	-TXMAP2,$0,$0,$0
	movea.l	#ControllerBgMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#$1C,d3
	moveq	#$F,d5
	jsr	(dobitmap).l
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$67,$89,$AB,$CD,$EF
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),$7,$2,'Modify Ratings',$0
	jsr	(printsmallz).l
	dc.w	$44	;String length
	dc.b	$F9,$1,$FD,$9,$FC,$19,'{}[] = Select Rating',$FA
	dc.b	$1,$FD,$4,'A,B=Decrease/Increase',$FD,$1C,'START=Done',$F9
	dc.b	$0,$0
	move.w	#$18,(palcount).w
	bclr	#2,(disflags).w
	bsr.w	ClearAttribDeltas
	bsr.w	LoadCreateTemplate
	bsr.w	SetPointsPool
	bsr.w	PrintCreateName
	clr.w	(CreateCursorY).l
	move.w	#2,(CreateCursorX).l
.draw
	bsr.w	DrawRatings
.frame
	move.w	(vcount).w,d0
.vwait
	cmp.w	(vcount).w,d0
	beq.s	.vwait
	jsr	(ReadJoy1).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.s	.frame
	btst	#7,d1
	beq.w	.3
	jsr	(CommitCreatedPlayer).l
	bra.w	.done
.3
	btst	#0,d1
	beq.w	.6
	tst.w	(CreateCursorY).l
	bne.w	.5
	cmpi.w	#1,(CreateCursorX).l
	beq.w	.4
	bra.s	.frame
.4
	move.w	#2,(CreateCursorX).l
	move.w	#1,(CreateCursorY).l
	bra.s	.draw
.5
	subq.w	#1,(CreateCursorY).l
	bra.s	.draw
.6
	btst	#1,d1
	beq.w	.9
	move.w	(CreateCursorX).l,d6
	bsr.w	LastFieldRow
	cmp.w	(CreateCursorY).l,d4
	ble.w	.7
	addq.w	#1,(CreateCursorY).l
	bra.w	.draw
.7
	cmpi.w	#2,(CreateCursorX).l
	beq.w	.8
	cmpi.w	#3,(CreateCursorX).l
	bne.w	.frame
.8
	move.w	#1,(CreateCursorX).l
	clr.w	(CreateCursorY).l
	bra.w	.draw
.9
	btst	#3,d1
	beq.w	.13
	move.w	(CreateCursorX).l,d6
	addq.w	#1,d6
	cmp.w	#4,d6
	blt.w	.column
	clr.w	d6
.column
	bsr.w	LastFieldRow
.clamp
	cmp.w	(CreateCursorY).l,d4
	bge.w	.12
	subq.w	#1,(CreateCursorY).l
	bra.s	.clamp
.12
	move.w	d6,(CreateCursorX).l
	bra.w	.draw
.13
	btst	#2,d1
	beq.w	.14
	move.w	(CreateCursorX).l,d6
	subq.w	#1,d6
	bpl.s	.column
	move.w	#3,d6
	bra.s	.column
.14
	btst	#6,d1
	beq.w	.15
	move.w	#$FFFF,d0
	bsr.w	EditField
	bra.w	.draw
.15
	btst	#4,d1
	beq.w	.16
	move.w	#1,d0
	bsr.w	EditField
	bra.w	.draw
.16
	bra.w	.frame
.done
	bset	#6,(setupcardflags).w
	jmp	(Opening2).l

PrintCreateName	;Prints Name First:/Last: from CreateRecord+2 (split at the space) via mesarea
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$4,$6,'Name',-(TXPRI+TXMAP1),$4,$7,'First:',-(TXPRI+TXMAP1),$4,$8,'Last:'
	movea.l	#TextBuffer,a0
	movea.l	#CreateRecord+$2,a1
	move.w	#2,(mesarea).w
.loop
	move.b	(a1)+,d0
	cmp.b	#$20,d0
	beq.w	.1
	move.b	d0,(a0)+
	addq.w	#1,(mesarea).w
	bra.s	.loop
.1
	clr.b	(a0)
	addq.w	#1,(mesarea).w
	andi.w	#$FFFE,(mesarea).w
	movea.l	#mesarea,a1
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$A,$7,$0
	jsr	(print).l
	movea.l	#TextBuffer,a0
	movea.l	#CreateRecord+$2,a1
	move.w	#2,(mesarea).w
	move.w	(CreateRecord).l,d6
	subq.w	#3,d6
.loop2
	move.b	(a1)+,d0
	subq.w	#1,d6
	cmp.b	#$20,d0
	bne.s	.loop2
.loop3
	move.b	(a1)+,(a0)+
	addq.w	#1,(mesarea).w
	dbf	d6,.loop3
	clr.b	(a0)
	addq.w	#1,(mesarea).w
	andi.w	#$FFFE,(mesarea).w
	movea.l	#mesarea,a1
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$A,$8,$0
	jsr	(print).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DrawRatings	;Redraws every rating cell (4 columns x rows from LastFieldRow, each via DrawField), then Max Unallocated Points
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d6
	clr.w	d7
.loop
	bsr.w	LastFieldRow
.loop2
	bsr.w	DrawField
	addq.w	#1,d7
	cmp.w	d4,d7
	ble.s	.loop2
	clr.w	d7
	addq.w	#1,d6
	cmp.w	#4,d6
	blt.s	.loop
	bsr.w	rtsCreate3
	bsr.w	PrintUnallocated
	movem.l	(sp)+,d0-d7/a0-a6
	rts

rtsCreate3	;Empty stub (called from DrawRatings)
	rts

PrintUnallocated	;Prints "Maximum Unallocated Points" and its value CreatePoints
	jsr	(printsmallz).l
	String	CC_SetFont,$0,CC_SetX,$4,CC_SetY,$17,'Maximum Unallocated Points',CC_SetX,'"'
	move.w	(CreatePoints).l,d0
	move.w	#4,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	rts

DrawRatingValue	;Call the cell routine for column d6 / row d7 from table SkaterFieldTbls (GoalieFieldTbls if CreateType=0), a2 = player record
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#SkaterFieldTbls,a0
	tst.w	(CreateType).l
	bne.w	.0
	movea.l	#GoalieFieldTbls,a0
.0
	move.w	d6,d0
	asl.w	#2,d0
	movea.l	(a0,d0.w),a0
	move.w	d7,d0
	asl.w	#2,d0
	movea.l	(a0,d0.w),a0
	movea.l	#CreateRecord,a2
	adda.w	(a2),a2
	jsr	(a0)
	movem.l	(sp)+,d0-d7/a0-a6
	rts

FieldSpeed	;Field: draw cursor, print rating from record via PAttribOverallMask+$42 (Speed)
	bsr.w	FieldHighlight
	bsr.w	FieldPrintSetup
	move.l	(PAttribOverallMask+$42).l,d4
	jsr	(CalcAttribRating).l
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldPrintSetup	;Set print target a4/a0 (record+8) and number-print table a6 for a field value
	movea.l	#FieldTextBuf,a4
	movea.l	a2,a0
	addq.w	#8,a0
	movea.l	#AttribWgtList,a6
	rts

FieldAgility	;Field: draw cursor, print rating from record via PAttribOverallMask+$2C (Agility)
	bsr.w	FieldHighlight
	bsr.s	FieldPrintSetup
	move.l	(PAttribOverallMask+$2C).l,d4
	jsr	(CalcAttribRating).l
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldEndurance	;Field: draw cursor, print rating from record via PAttribOverallMask+$108 (Endurance)
	bsr.w	FieldHighlight
	bsr.s	FieldPrintSetup
	move.l	(PAttribOverallMask+$108).l,d4
	jsr	(CalcAttribRating).l
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldOffAware	;Field: draw cursor, print rating from record via PAttribOverallMask+$6E (Off. Awareness)
	bsr.w	FieldHighlight
	bsr.s	FieldPrintSetup
	move.l	(PAttribOverallMask+$6E).l,d4
	jsr	(CalcAttribRating).l
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldDefAware	;Field: draw cursor, print rating from record via PAttribOverallMask+$84 (Def. Awareness)
	bsr.w	FieldHighlight
	bsr.w	FieldPrintSetup
	move.l	(PAttribOverallMask+$84).l,d4
	jsr	(CalcAttribRating).l
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldStickhandling	;Field: draw cursor, print rating from record via PAttribOverallMask+$DC (Stick Handling)
	bsr.w	FieldHighlight
	bsr.w	FieldPrintSetup
	move.l	(PAttribOverallMask+$DC).l,d4
	jsr	(CalcAttribRating).l
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldWeight	;Field Wt.: print weight = value*8+140 (via PAttribOverallMask+$F2 (Weight))
	bsr.w	FieldHighlight
	bsr.w	FieldPrintSetup
	move.l	(PAttribOverallMask+$F2).l,d4
	jsr	(CalcAttribRating).l
	asl.w	#3,d0
	addi.w	#$8C,d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldShotPower	;Field: draw cursor, print rating from record via PAttribOverallMask+$9A (Shot Power)
	bsr.w	FieldHighlight
	bsr.w	FieldPrintSetup
	move.l	(PAttribOverallMask+$9A).l,d4
	jsr	(CalcAttribRating).l
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldShotAcc	;Field: draw cursor, print rating from record via PAttribOverallMask+$B0 (Shot Accuracy)
	bsr.w	FieldHighlight
	bsr.w	FieldPrintSetup
	move.l	(PAttribOverallMask+$B0).l,d4
	jsr	(CalcAttribRating).l
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldPassAcc	;Field: draw cursor, print rating from record via PAttribOverallMask+$C6 (Pass Accuracy)
	bsr.w	FieldHighlight
	bsr.w	FieldPrintSetup
	move.l	(PAttribOverallMask+$C6).l,d4
	jsr	(CalcAttribRating).l
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldAggression	;Field: draw cursor, print rating from record via PAttribOverallMask+$11E (Aggressiveness)
	bsr.w	FieldHighlight
	bsr.w	FieldPrintSetup
	move.l	(PAttribOverallMask+$11E).l,d4
	jsr	(CalcAttribRating).l
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldChecking	;Field: draw cursor, print rating from record via PAttribOverallMask+$134 (Checking)
	bsr.w	FieldHighlight
	bsr.w	FieldPrintSetup
	move.l	(PAttribOverallMask+$134).l,d4
	jsr	(CalcAttribRating).l
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldBlank1	;Field with no value: draw cursor only (unreferenced)
	bsr.w	FieldHighlight
	bra.w	FieldDone

FieldBlank2	;Field with no value: draw cursor only (unreferenced)
	bsr.w	FieldHighlight
	bra.w	FieldDone

FieldJersey	;Field Unif.: print BCD jersey byte at (a2) as decimal
	bsr.w	FieldHighlight
	clr.w	d4
	move.b	(a2),d4
	lsr.w	#4,d4
	mulu.w	#$A,d4
	move.b	(a2),d0
	andi.b	#$F,d0
	add.b	d4,d0
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldGAgility	;Field: draw cursor, print rating from record via GAttribOverallMask+$16 (Agility)
	bsr.w	FieldHighlight
	bsr.w	FieldPrintSetup
	move.l	(GAttribOverallMask+$16).l,d4
	jsr	(CalcAttribRating).l
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldGDefAware	;Field: draw cursor, print rating from record via GAttribOverallMask+$58 (Def. Awareness)
	bsr.w	FieldHighlight
	bsr.w	FieldPrintSetup
	move.l	(GAttribOverallMask+$58).l,d4
	jsr	(CalcAttribRating).l
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldGPuckCtrl	;Field: draw cursor, print rating from record via GAttribOverallMask+$6E (Puck Control)
	bsr.w	FieldHighlight
	bsr.w	FieldPrintSetup
	move.l	(GAttribOverallMask+$6E).l,d4
	jsr	(CalcAttribRating).l
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldGStickR	;Field: draw cursor, print rating from record via GAttribOverallMask+$84 (Stick Right)
	bsr.w	FieldHighlight
	bsr.w	FieldPrintSetup
	move.l	(GAttribOverallMask+$84).l,d4
	jsr	(CalcAttribRating).l
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldGStickL	;Field: draw cursor, print rating from record via GAttribOverallMask+$9A (Stick Left)
	bsr.w	FieldHighlight
	bsr.w	FieldPrintSetup
	move.l	(GAttribOverallMask+$9A).l,d4
	jsr	(CalcAttribRating).l
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldGGloveR	;Field: draw cursor, print rating from record via GAttribOverallMask+$B0 (Glove Right)
	bsr.w	FieldHighlight
	bsr.w	FieldPrintSetup
	move.l	(GAttribOverallMask+$B0).l,d4
	jsr	(CalcAttribRating).l
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldGGloveL	;Field: draw cursor, print rating from record via GAttribOverallMask+$C6 (Glove Left)
	bsr.w	FieldHighlight
	bsr.w	FieldPrintSetup
	move.l	(GAttribOverallMask+$C6).l,d4
	jsr	(CalcAttribRating).l
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	bra.w	FieldDone

FieldHand	;Field Hand: print R/L from bit 0 of record byte 4
	bsr.w	FieldHighlight
	move.b	4(a2),d0
	andi.w	#1,d0
	movea.l	#HandText,a1
	jsr	(PrintSmallListItem).l
	bra.w	FieldDone

HandText	;R, L
	String	'R',0
	String	'L',0

FieldPos	;Field Pos.: print G/F/D indexed by CreateType
	bsr.w	FieldHighlight
	move.w	(CreateType).l,d0
	movea.l	#PosText,a1
	jsr	(PrintSmallListItem).l

FieldDone	;Common field exit: back to font 0
	jsr	(printsmallz).l
	String	CC_SetFont,0
	rts

PosText	;G, F, D
	String	'G',0
	String	'F',0
	String	'D',0

FieldHighlight	;Set normal text color, highlight if (d6,d7) is the cursor (CreateCursorX / CreateCursorY)
	jsr	(printsmallz).l
	String	CC_SetFont,0
	cmp.w	(CreateCursorX).l,d6
	bne.w	.exit
	cmp.w	(CreateCursorY).l,d7
	bne.w	.exit
	jsr	(printsmallz).l
	String	CC_SetFont,1
.exit
	rts

SkaterFieldTbls	;Skater field-routine tables by column
	dc.l	SkaterFieldCol1,SkaterFieldCol2,FieldCol3,FieldCol4

GoalieFieldTbls	;Goalie field-routine tables by column
	dc.l	GoalieFieldCol1,GoalieFieldCol2,FieldCol3,FieldCol4

SkaterFieldCol1	;Field routines of a column
	dc.l	FieldSpeed,FieldAgility,FieldEndurance,FieldOffAware,FieldDefAware,FieldStickhandling

SkaterFieldCol2	;Field routines of a column
	dc.l	FieldShotPower,FieldShotAcc,FieldPassAcc,FieldAggression,FieldChecking

FieldCol3	;Field routines of a column
	dc.l	FieldPos,FieldWeight

FieldCol4	;Field routines of a column
	dc.l	FieldHand,FieldJersey

GoalieFieldCol1	;Field routines of a column
	dc.l	FieldGAgility,FieldGDefAware,FieldGPuckCtrl

GoalieFieldCol2	;Field routines of a column
	dc.l	FieldGStickR,FieldGStickL,FieldGGloveR,FieldGGloveL

DrawField	;Draw one Create Player field (d6=column,d7=row): label then value, all regs saved
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	PrintFieldLabel
	bsr.w	DrawRatingValue
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrintFieldLabel	;print field label: pick skater/goalie label list, highlight if cursor, print entry d7
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	#SkaterLabelLists,a1
	tst.w	(CreateType).l
	bne.w	.0
	movea.l	#GoalieLabelLists,a1
.0
	move.w	d6,d0
	asl.w	#2,d0
	movea.l	(a1,d0.w),a1
	move.w	d7,d0
	movem.l	d0/a1,-(sp)
	jsr	(printsmallz).l
	String	CC_SetFont,0
	cmp.w	(CreateCursorX).l,d6
	bne.w	.1
	cmp.w	(CreateCursorY).l,d7
	bne.w	.1
	jsr	(printsmallz).l
	String	CC_SetFont,1
.1
	movem.l	(sp)+,d0/a1
	jsr	(PrintSmallListItem).l
	movem.l	(sp)+,d0-d1/a0-a1
	rts

SkaterLabelLists	;Skater attribute-label lists by column
	dc.l	SkaterSkillLabels,SkaterShotLabels,PosWeightLabels,HandUniformLabels

GoalieLabelLists	;Goalie attribute-label lists by column
	dc.l	GoalieSkillLabels,GoalieSaveLabels,PosWeightLabels,HandUniformLabels

SkaterSkillLabels	;Create Player labels, skater column 1: skating and awareness ratings
	String	$FD,$4,$FC,$A,'Speed',$FD,$13,$0
	String	$FD,$4,$FC,$C,'Agility',$FD,$13,$0
	String	$FD,$4,$FC,$E,'Endurance',$FD,$13,$0
	String	$FD,$4,$FC,$10,'Off.Awareness',$FD,$13,$0
	String	$FD,$4,$FC,$12,'Def.Awareness',$FD,$13,$0
	String	$FD,$4,$FC,$14,'Stickhandling',$FD,$13,$0

SkaterShotLabels	;Create Player labels, skater column 2: shooting, passing and checking ratings
	String	$FD,$16,$FC,$A,'Shot Power',$FD,'$'
	String	$FD,$16,$FC,$C,'Shot Accuracy',$FD,'$',$0
	String	$FD,$16,$FC,$E,'Pass Accuracy',$FD,'$',$0
	String	$FD,$16,$FC,$10,'Aggression',$FD,'$'
	String	$FD,$16,$FC,$12,'Checking',$FD,'$'

PosWeightLabels	;Create Player labels, column 3 (both): position and weight
	String	$FD,$16,$FC,$7,'Pos. ',$0
	String	$FD,$16,$FC,$8,'Wt. '

HandUniformLabels	;Create Player labels, column 4 (both): handedness and uniform number
	String	$FD,$1E,$FC,$7,'Hand',$FD,'$'
	String	$FD,$1E,$FC,$8,'Unif.',$FD,'$',$0

GoalieSkillLabels	;Create Player labels, goalie column 1: agility, awareness and puck control
	String	$FD,$4,$FC,$B,'Agility',$FD,$13,$0
	String	$FD,$4,$FC,$D,'Def.Awareness',$FD,$13,$0
	String	$FD,$4,$FC,$F,'Puck Control',$FD,$13

GoalieSaveLabels	;Create Player labels, goalie column 2: stick and glove side ratings
	String	$FD,$16,$FC,$B,'Stick Right',$FD,'"',$0
	String	$FD,$16,$FC,$D,'Stick Left',$FD,'"'
	String	$FD,$16,$FC,$F,'Glove Right',$FD,'"',$0
	String	$FD,$16,$FC,$11,'Glove Left',$FD,'"'

LastFieldRow	;d4 = last row index for column d6 (skater or goalie table)
	movem.l	d6/a0,-(sp)
	movea.l	#SkaterLastRows,a0
	tst.w	(CreateType).l
	bne.w	.0
	movea.l	#GoalieLastRows,a0
.0
	add.w	d6,d6
	move.w	(a0,d6.w),d4
	movem.l	(sp)+,d6/a0
	rts

SkaterLastRows	;Skater last row index per column
	dc.w	5,4,1,1

GoalieLastRows	;Goalie last row index per column
	dc.w	2,3,1,1

EditField	;Run the edit handler of the cursor field (CreateCursorX / CreateCursorY) for the player type
	movea.l	#GoalieEditTbl,a0
	tst.w	(CreateType).l
	beq.w	.0
	movea.l	#SkaterEditTbl,a0
.0
	move.w	(CreateCursorX).l,d1
	asl.w	#2,d1
	movea.l	(a0,d1.w),a0
	move.w	(CreateCursorY).l,d1
	asl.w	#2,d1
	movea.l	(a0,d1.w),a0
	jsr	(a0)
	rts

GoalieEditTbl	;Edit handlers for a goalie (CreateType 0): one list per column (CreateCursorX), indexed by row (CreateCursorY)
	dc.l	GoalieEditCol1
	dc.l	GoalieEditCol2
	dc.l	EditCol3
	dc.l	EditCol4

GoalieEditCol1	;Goalie column 1: agility, awareness, puck control
	dc.l	EditGAgility
	dc.l	EditGDefAware
	dc.l	EditGPuckCtrl

GoalieEditCol2	;Goalie column 2: stick and glove sides
	dc.l	EditGStickR
	dc.l	EditGStickL
	dc.l	EditGGloveR
	dc.l	EditGGloveL

EditCol3	;Column 3 (both): position, weight
	dc.l	EditPlayerType
	dc.l	EditWeight

EditCol4	;Column 4 (both): hand, uniform number
	dc.l	EditHand
	dc.l	EditJersey

SkaterEditTbl	;Edit handlers for a skater (CreateType 1 / 2), same layout
	dc.l	SkaterEditCol1
	dc.l	SkaterEditCol2
	dc.l	EditCol3
	dc.l	EditCol4

SkaterEditCol1	;Skater column 1: skating, awareness, stickhandling
	dc.l	EditSpeed
	dc.l	EditAgility
	dc.l	EditEndurance
	dc.l	EditOffAware
	dc.l	EditDefAware
	dc.l	EditStickhandling

SkaterEditCol2	;Skater column 2: shooting, passing, aggression, checking
	dc.l	EditShotPower
	dc.l	EditShotAcc
	dc.l	EditPassAcc
	dc.l	EditAggression
	dc.l	EditChecking
	dc.l	EditNone

EditPlayerType	;Change the position (CreateType 0 G, 1 F, 2 D) by d0 with wrap; switching to or from goalie reloads the record,
	;template and points pool
	add.w	(CreateType).l,d0
	bpl.w	.0
	move.w	#2,d0
.0
	cmp.w	#2,d0
	ble.w	.1
	clr.w	d0
.1
	move.w	(CreateType).l,d1
	tst.w	d1
	beq.w	.2
	tst.w	d0
	bne.w	.3
.2
	bsr.w	ClearAttribDeltas
	movea.l	#CreateRecord,a0
	move.b	d0,$1F(a0)
	jsr	(NewCreateRecord).l
	bsr.w	LoadCreateTemplate
	bsr.w	ClearCreateArea
	bsr.w	PrintCreateName
	move.w	d0,(CreateType).l
	bsr.w	SetPointsPool
.3
	move.w	d0,(CreateType).l
	movea.l	#CreateRecord,a0
	move.b	d0,$1F(a0)
	rts

EditGAgility	;Adjust the goalie Agility rating (d4 = its nibble mask)
	move.l	(GAttribOverallMask+$16).l,d4

AdjustAttrib	;Adjust attribute selected by d4 bit by d0, paying from points pool CreatePoints
	move.w	(CreatePoints).l,d1
	move.w	d1,(TempPlOffset).w
	move.w	d0,d2
	neg.w	d2
	add.w	d2,d1
	bmi.w	rtsAdjustAttrib
	move.w	d1,(CreatePoints).l
	movea.l	#AttribDeltas,a0
	swap	d4
.loop
	btst	#$F,d4
	bne.w	.1
	addq.w	#1,a0
	asl.w	#1,d4
	bra.s	.loop
.1
	tst.w	d0
	bpl.w	.2
	movem.w	d2-d3,-(sp)
	move.b	(a0),d2
	cmp.b	#0,d2
	movem.w	(sp)+,d2-d3
	ble.w	.undo
.2
	add.b	d0,(a0)
	bra.w	rtsAdjustAttrib
.undo
	move.w	(TempPlOffset).w,(CreatePoints).l

rtsAdjustAttrib	;rts of AdjustAttrib
	rts

EditGDefAware	;Adjust the goalie Def. Awareness rating (d4 = its nibble mask)
	move.l	(GAttribOverallMask+$58).l,d4
	bra.s	AdjustAttrib

EditGPuckCtrl	;Adjust the goalie Puck Control rating (d4 = its nibble mask)
	move.l	(GAttribOverallMask+$6E).l,d4
	bra.s	AdjustAttrib

EditWeight	;Adjust the weight (high nibble of record byte 1) by d0, 0-15
	movea.l	#CreateRecord,a0
	adda.w	(a0),a0
	clr.w	d1
	move.b	1(a0),d1
	lsr.w	#4,d1
	andi.w	#$F,d1
	add.w	d0,d1
	bmi.s	rtsAdjustAttrib
	cmp.w	#$F,d1
	bgt.s	rtsAdjustAttrib
	lsl.w	#4,d1
	move.b	1(a0),d0
	andi.w	#$F,d0
	or.w	d1,d0
	move.b	d0,1(a0)
	rts

EditGStickR	;Adjust the goalie Stick Right rating (d4 = its nibble mask)
	move.l	(GAttribOverallMask+$84).l,d4
	bra.w	AdjustAttrib

EditGStickL	;Adjust the goalie Stick Left rating (d4 = its nibble mask)
	move.l	(GAttribOverallMask+$9A).l,d4
	bra.w	AdjustAttrib

EditGGloveR	;Adjust the goalie Glove Right rating (d4 = its nibble mask)
	move.l	(GAttribOverallMask+$B0).l,d4
	bra.w	AdjustAttrib

EditGGloveL	;Adjust the goalie Glove Left rating (d4 = its nibble mask)
	move.l	(GAttribOverallMask+$C6).l,d4
	bra.w	AdjustAttrib

EditHand	;Toggle the hand (bit 0 of record byte 4)
	movea.l	#CreateRecord,a0
	adda.w	(a0),a0
	eori.b	#1,4(a0)
	rts

EditJersey	;Adjust BCD jersey number in record byte 0 by d0, wrap 1..99
	movea.l	#CreateRecord,a0
	adda.w	(a0),a0
	clr.w	d1
	move.b	(a0),d1
	andi.w	#$F,d1
	clr.w	d2
	move.b	(a0),d2
	lsr.w	#4,d2
	mulu.w	#$A,d2
	add.w	d2,d1
	add.b	d1,d0
	bpl.w	.0
	move.w	#$63,d0
.0
	tst.b	d0
	bne.w	.1
	move.w	#$63,d0
.1
	cmp.b	#$63,d0
	ble.w	.2
	move.w	#1,d0
.2
	tst.b	d0
	bne.w	.3
	move.w	#1,d0
.3
	andi.l	#$FF,d0
	divu.w	#$A,d0
	move.w	d0,d1
	lsl.w	#4,d1
	swap	d0
	or.b	d0,d1
	move.b	d1,(a0)
	rts

EditSpeed	;Adjust the skater Speed rating (d4 = its nibble mask)
	move.l	(PAttribOverallMask+$42).l,d4
	bra.w	AdjustAttrib

EditAgility	;Adjust the skater Agility rating (d4 = its nibble mask)
	move.l	(PAttribOverallMask+$2C).l,d4
	bra.w	AdjustAttrib

EditEndurance	;Adjust the skater Endurance rating (d4 = its nibble mask)
	move.l	(PAttribOverallMask+$108).l,d4
	bra.w	AdjustAttrib

EditOffAware	;Adjust the skater Off. Awareness rating (d4 = its nibble mask)
	move.l	(PAttribOverallMask+$6E).l,d4
	bra.w	AdjustAttrib

EditDefAware	;Adjust the skater Def. Awareness rating (d4 = its nibble mask)
	move.l	(PAttribOverallMask+$84).l,d4
	bra.w	AdjustAttrib

EditStickhandling	;Adjust the skater Stickhandling rating (d4 = its nibble mask)
	move.l	(PAttribOverallMask+$DC).l,d4
	bra.w	AdjustAttrib

EditShotPower	;Adjust the skater Shot Power rating (d4 = its nibble mask)
	move.l	(PAttribOverallMask+$9A).l,d4
	bra.w	AdjustAttrib

EditShotAcc	;Adjust the skater Shot Accuracy rating (d4 = its nibble mask)
	move.l	(PAttribOverallMask+$B0).l,d4
	bra.w	AdjustAttrib

EditPassAcc	;Adjust the skater Pass Accuracy rating (d4 = its nibble mask)
	move.l	(PAttribOverallMask+$C6).l,d4
	bra.w	AdjustAttrib

EditAggression	;Adjust the skater Aggression rating (d4 = its nibble mask)
	move.l	(PAttribOverallMask+$11E).l,d4
	bra.w	AdjustAttrib

EditChecking	;Adjust the skater Checking rating (d4 = its nibble mask)
	move.l	(PAttribOverallMask+$134).l,d4
	bra.w	AdjustAttrib

EditNone	;No-op handler
	rts

ClearAttribDeltas	;Clear 16-byte attribute buffer AttribDeltas
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#AttribDeltas,a0
	move.w	#3,d0
.loop
	clr.l	(a0)+
	dbf	d0,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts

LoadCreateTemplate	;Copy 32-word player template (index CreateIndex) from SRCreatedPlayers into byte record CreateRecord, set CreateType from last byte
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$1F,d0
	movea.l	#SaveRAM+2*SRCreatedPlayers,a0
	move.w	(CreateIndex).l,d1
	asl.w	#5,d1
	add.w	d1,d1
	adda.w	d1,a0
	movea.l	#CreateRecord,a1
.loop
	move.w	(a0)+,d2
	move.b	d2,(a1)+
	dbf	d0,.loop
	clr.w	(CreateType).l
	move.b	-1(a1),(CreateType+1).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ClearCreateArea	;Clear the ratings area of map 1 ($28 x $14 from row 5)
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),0,5,0
	move.w	#$28,d0
	move.w	#$14,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SetPointsPool	;CreatePoints = 300 for a goalie, 450 for a skater
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$12C,(CreatePoints).l
	tst.w	(CreateType).l
	beq.w	.0
	move.w	#$1C2,(CreatePoints).l
.0
	movem.l	(sp)+,d0-d7/a0-a6
	rts

CommitCreatedPlayer	;Commit created player: store type bits, add attribute deltas into record via CommitAttribJumps handlers, save record via WriteSRAM and MakeSRAMChecksum
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#SaveRAM+2*SRFreeAgentList,a0
	move.w	(CreateWork).l,d0
	asl.w	#2,d0
	adda.w	d0,a0
	move.w	(a0),d0
	andi.w	#$1F,d0
	move.w	(CreateType).l,d1
	lsl.w	#5,d1
	or.w	d1,d0
	move.w	d0,(a0)
	movea.l	#CreateRecord,a0
	adda.w	(a0),a0
	movea.l	#AttribDeltas,a2
	move.w	#$F,d0
.loop
	move.w	d0,d1
	lsr.w	#1,d1
	movem.l	d1/a0,-(sp)
	clr.w	d2
	clr.w	d3
	move.b	(a0,d1.w),d3
	move.b	(a2,d0.w),d2
	btst	#0,d0
	bne.w	.1
	lsr.w	#4,d3
.1
	andi.w	#$F,d3
	movea.l	#CommitAttribJumps,a1
	move.w	d0,d1
	asl.w	#2,d1
	movea.l	(a1,d1.w),a1
	jsr	(a1)
	movem.l	(sp)+,d1/a0
	move.b	(a0,d1.w),d2
	btst	#0,d0
	bne.w	.2
	andi.w	#$F,d2
	lsl.w	#4,d3
	andi.w	#$F0,d3
	bra.w	.3
.2
	andi.w	#$F0,d2
	andi.w	#$F,d3
.3
	or.w	d3,d2
	move.b	d2,(a0,d1.w)
	dbf	d0,.loop
	movea.l	#CreateRecord,a0
	clr.l	d0
	move.w	(CreateIndex).l,d0
	asl.w	#5,d0
	addi.l	#SRCreatedPlayers,d0
	moveq	#$20,d1
	jsr	(WriteSRAM).l
	movea.l	#CreateRecord,a0
	adda.w	(a0),a0
	clr.w	d6
	move.b	(a0),d6
	move.w	(CreateWork).l,d0
	ext.l	d0
	moveq	#$1C,d1
	asl.l	#5,d1
	add.l	d0,d1
	add.l	d1,d1
	movea.l	#SaveRAM+2*SRJerseyNums,a0
	move.w	d6,(a0,d1.l)
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

CommitAttribJumps	;Commit handler per attribute nibble (16 entries)
	dc.l	CommitNone1
	dc.l	CommitNone1
	dc.l	CommitNone2
	dc.l	CrScale
	dc.l	CrScale
	dc.l	CrScale
	dc.l	CrScale
	dc.l	CrScale
	dc.l	CrScale
	dc.l	CrScaleEven
	dc.l	CrScaleLookup
	dc.l	CrScale
	dc.l	CrScale
	dc.l	CrScale
	dc.l	CrScale
	dc.l	CrScale

CrScale	;d3 += d2/14 (signed)
	ext.l	d2
	divs.w	#$E,d2
	add.w	d2,d3
	rts

CommitNone1	;No-op
	rts

CommitNone2	;No-op
	rts

CrScaleEven	;Scale even part of d3 via CrScale, keep low bit of d3
	move.w	d3,-(sp)
	andi.w	#$FE,d3
	jsr	(CrScale).l
	move.w	d3,d2
	move.w	(sp)+,d3
	andi.w	#1,d3
	andi.w	#$FE,d2
	or.w	d2,d3
	rts

CrScaleLookup	;CrScale, then d3 = byte lookup in StickHandTable+$10[d3]
	bsr.s	CrScale
	movem.l	d0/a0,-(sp)
	movea.l	#StickHandTable+$10,a0
	move.b	d3,d0
	ext.w	d0
	move.b	(a0,d0.w),d3
	ext.w	d3
	movem.l	(sp)+,d0/a0
	rts


CalcAttribRating	;The rating sum of CalcAttrib: d0 / d1 = weighted sum of the attributes in d4 bits (weights a6), d1 the maximum. With AttribWgtList (create
	;player) it clamps the attribute to 0-$63 and adjusts CreatePoints
	clr.w	(attribsum).w
	clr.w	(attribcount).w
	clr.w	d0
	clr.w	d1
	moveq	#$F,d2
	swap	d4
.bit
	btst	d2,d4
	beq.w	.next
	move.w	d2,d3
	lsr.w	#1,d3
	neg.w	d3
	move.b	-1(a0,d3.w),d3
	btst	#0,d2
	beq.w	.1
	lsr.w	#4,d3
.1
	andi.w	#$F,d3
	cmp.w	#$D,d2
	bne.w	.2
	bra.w	.add
.2
	cmp.w	#5,d2
	bne.w	.3
	move.l	a0,-(sp)
	movea.l	#StickHandTable,a0
	move.b	(a0,d3.w),d3
	movea.l	(sp)+,a0
.3
	cmp.w	#6,d2
	beq.w	.add
	movem.l	d5-d7,-(sp)
	move.b	(a6,d2.w),d5
	ext.w	d5
	cmp.w	#2,d5
	beq.w	.5
	move.w	d3,-(sp)
	subq.w	#2,d5
.attribadd
	add.w	(sp),d3
	dbf	d5,.attribadd
	asr.w	#1,d3
	tst.w	(sp)+
.5
	movem.l	(sp)+,d5-d7
	cmpa.l	#AttribWgtList,a6
	beq.w	.create
	neg.w	d2
	move.w	d7,-(sp)
	move.b	-1(a4,d2.w),d7
	ext.w	d7
	add.w	d7,(attribsum).w
	addq.w	#1,(attribcount).w
	move.w	(sp)+,d7
	neg.w	d2
	bra.w	.add
.create
	move.w	d3,-(sp)
	asl.w	#4,d3
	add.w	(sp),d3
	add.w	(sp)+,d3
	neg.w	d2
	add.b	-1(a4,d2.w),d3
	bpl.w	.chkmax
	clr.b	d3
	addq.b	#1,-1(a4,d2.w)
	opt	osq-	;keep the retail subi / addi (SNASM would make subq / addq)
	subi.w	#1,(CreatePoints).l
	opt	osq+
.chkmax
	cmp.b	#$63,d3
	ble.w	.pos
	move.b	#$63,d3
	subq.b	#1,-1(a4,d2.w)
	opt	oaq-
	addi.w	#1,(CreatePoints).l
	opt	oaq+
.pos
	neg.w	d2
.add
	add.w	d3,d0
	addi.w	#$64,d1
.next
	dbf	d2,.bit
	cmpa.l	#AttribWgtList,a6
	beq.w	.11
	move.w	#$64,d1
	movem.l	d6-d7,-(sp)
	move.w	(attribsum).w,d6
	ext.l	d6
	move.w	(attribcount).w,d7
	divs.w	d7,d6
	add.w	d6,d0
	movem.l	(sp)+,d6-d7
.11
	cmp.w	d1,d0
	blt.w	.exit
	move.w	d0,d1
	subq.w	#1,d0
.exit
	rts


PrintSmallListItem	;printsmall String d0 of the list a1
	jsr	(AdvanceStringPtr).l
	jmp	(printsmall).l


StickHandTable	;setplayer: the stick handling nibble 0-15 to 0-6, before AttributeCalc
	dc.b	0,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6	;Stk nibble 0-15 to 0-6
	dc.b	0,1,3,6,9,$C,$F,$FF	;CrScaleLookup (StickHandTable+$10)


SignFreeAgents	;Sign Free Agents screen: draw, input loop
	jsr	(forceblack).l
	jsr	(TradeGfx).l
	jsr	(printz).l
	String	-TXMAP2,$9,$6,$0
	movea.l	#FreeAgentMap1,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	-TXMAP2,$9,$15,$0
	movea.l	#FreeAgentMap2,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),$7,$2,'Sign Free Agent'
	jsr	(printsmallz).l
	dc.w	$18	;String length
	dc.b	$F9,$1,$FD,$7,$FC,$19,'A,B',$FD
	dc.b	$17,'C',$FD,$1F,'Start',$FA,$1,$0
	jsr	(printsmallz).l
	String	CC_SetX,$3,'Switch Team',CC_SetX,$12,'Sign Player',CC_SetX,' Exit',CC_SetFont,$0
	move.w	#3,d0
	movea.l	#AttribDeltas,a0
.loop
	clr.l	(a0)+
	dbf	d0,.loop
.1
	clr.w	(TradeData+$C).l
.2
	clr.w	(TradeData).l
	bsr.w	FreeAgentTeamBlock
	move.w	#$18,(palcount).w
	bclr	#2,(disflags).w

FreeAgentRedraw	;SignFreeAgents: redraw the lists
	jsr	(MarkSeasonRosters).l
	bsr.w	TestFreeAgents
	beq.w	FreeAgentsEmpty
	clr.w	(TradeData+$4).l
	move.w	(SaveRAM+2*SRFreeAgentCount).l,d0
	subq.b	#1,d0
.0
	andi.w	#$FF,d0
.1
	cmp.w	#5,d0
	ble.w	.3
.2
	move.w	#5,d0
.3
	move.w	d0,(TradeData+$6).l
	movea.l	#TradeRoster1,a0
	bsr.w	BuildFreeAgentList
.4
	bsr.w	rtsCreate4
	move.w	#$FFFF,(setupdir).w

FreeAgentLoop	;SignFreeAgents: input loop
	bsr.w	FreeAgentTeamBlock
	bsr.w	DrawFreeAgents
	bsr.w	FreeAgentArrows
.check
	cmpi.w	#$FFFF,(setupdir).w
	beq.w	.input
	bsr.w	FreeAgentTeamBlock
	bsr.w	DrawFreeAgents
	bsr.w	FreeAgentArrows
.input
	move.w	#$FFFF,(setupdir).w
	bsr.w	ReadFreeAgentPads
	tst.w	d1
	beq.w	FreeAgentExit
	btst	#0,d1
	beq.w	.3
	tst.w	(TradeData).l
	beq.w	.2
	subq.w	#1,(TradeData).l
	bra.s	FreeAgentLoop
.2
	tst.w	(TradeData+$4).l
	beq.s	.input
	subq.w	#1,(TradeData+$4).l
	subq.w	#1,(TradeData+$6).l
	bra.s	FreeAgentLoop
.3
	btst	#1,d1
	beq.w	.5
	move.w	(TradeData).l,d0
	add.w	(TradeData+$4).l,d0
	cmp.w	(TradeData+$6).l,d0
	beq.w	.4
	addq.w	#1,(TradeData).l
	bra.w	FreeAgentLoop
.4
	move.w	(SaveRAM+2*SRFreeAgentCount).l,d0
	andi.w	#$FF,d0
	subq.w	#1,d0
	cmp.w	(TradeData+$6).l,d0
	ble.s	.input
	addq.w	#1,(TradeData+$4).l
	addq.w	#1,(TradeData+$6).l
	bra.w	FreeAgentLoop
.5
	btst	#4,d1
	beq.w	.6
	addq.w	#1,(TradeData+$C).l
	cmpi.w	#$1A,(TradeData+$C).l
	blt.w	FreeAgentLoop
	clr.w	(TradeData+$C).l
	bra.w	FreeAgentLoop
.6
	btst	#6,d1
	beq.w	.7
	subq.w	#1,(TradeData+$C).l
	bpl.w	FreeAgentLoop
	move.w	#$19,(TradeData+$C).l
	bra.w	FreeAgentLoop
.7
	btst	#7,d1
	bne.w	FreeAgentExit
	btst	#5,d1
	beq.w	.9
	move.w	(TradeData+$C).l,d7
	jsr	(GetPlayerCountD7).l
	cmp.w	#$19,d0
	beq.w	FreeAgentViolation
	movea.l	#TradeRoster1,a0
	move.w	(TradeData+$4).l,d0
	add.w	(TradeData).l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d0
	move.w	#$D,d2
	lsr.w	d2,d0
	andi.w	#3,d0
	asl.w	#2,d0
	movea.l	#PositionMaxChecks,a0
	movea.l	(a0,d0.w),a0
	jsr	(a0)
	beq.w	FreeAgentViolation
	movea.l	#TradeRoster2,a0
	move.w	(TradeData+$4).l,d0
	add.w	(TradeData).l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d0
	move.w	d0,(TempWord1).w
	move.w	#$1C,d7
	move.w	(TempWord1).w,d0
	jsr	(GetJerseyNumber).l
	move.b	(jerseynum).w,(TempWord1).w
	movea.l	#M68K_RAM,a2
	move.w	(TempWord1).w,-(sp)
	jsr	(DeleteCreatedPlayer).l
	move.w	(sp)+,(TempWord1).w
	move.w	(TradeData+$C).l,(TempMaxSpd).w
	move.w	(TempWord1).w,d0
	andi.w	#$FF,d0
	movea.l	#TradeRoster1,a0
	add.w	d0,d0
	move.w	(a0,d0.w),d0
	move.w	#$D,d2
	lsr.w	d2,d0
	andi.w	#3,d0
	move.w	d0,(PenBuf).w
	move.w	(TradeData+$C).l,d7
	asl.w	#2,d0
	movea.l	#PositionCountFns,a0
	movea.l	(a0,d0.w),a0
	jsr	(a0)
	move.w	(PenBuf).w,d1
	lsl.w	#8,d1
	or.w	d1,d0
	move.w	d0,(TempWord2).w
	move.w	(TradeData+$C).l,(TempMaxSpd).w
	movea.l	#M68K_RAM,a2
	move.w	(TempWord1).w,-(sp)
	move.w	(TempWord2).w,-(sp)
	move.w	(TempMaxSpd).w,-(sp)
	jsr	(InsertTradedPlayer).l
	move.w	(sp)+,(TempMaxSpd).w
	move.w	(sp)+,(TempWord2).w
	move.w	(sp)+,(TempWord1).w
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$B,$9,$0
	move.w	#$7FF,d2
	move.w	#$1C,d0
	move.w	#$B,d1
	jsr	(eraser).l
	tst.w	(TradeData).l
	beq.w	.8
	subq.w	#1,(TradeData).l
.8
	bra.w	FreeAgentRedraw
.9
	bra.w	.check

PositionCountFns	;Per-position roster index routines (end of the position group in the roster)
	dc.l	GetGoalieCountD7
	dc.l	GetDefenseStartD7
	dc.l	GetPlayerCountD7

PositionMaxChecks	;Per-position check routines
	dc.l	CheckMaxGoalies
	dc.l	CheckMaxForwards
	dc.l	CheckMaxDefense

CheckMaxGoalies	;Compare GetGoalieCountD7 result with 3
	jsr	(GetGoalieCountD7).l
	cmp.w	#3,d0
	rts

CheckMaxForwards	;Compare GetForwardCountD7 result with $F
	jsr	(GetForwardCountD7).l
	cmp.w	#$F,d0
	rts

CheckMaxDefense	;Compare GetPlayerCountD7 - GetDefenseStartD7 with $F
	jsr	(GetDefenseStartD7).l
	move.w	d0,-(sp)
	jsr	(GetPlayerCountD7).l
	sub.w	(sp)+,d0
	cmp.w	#$F,d0
	rts

FreeAgentArrows	;Draw scroll up/down arrows for the list
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printsmallz).l
	String	CC_SetFont,$1
	move.w	(TradeData+$4).l,d0
	add.w	(TradeData).l,d0
	beq.w	.0
	jsr	(printsmallz).l
	String	CC_SetX,$9,CC_SetY,$9,'{',$0
	bra.w	.1
.0
	jsr	(printsmallz).l
	String	CC_SetX,$9,CC_SetY,$9,' ',$0
.1
	move.w	(TradeData).l,d1
	add.w	(TradeData+$4).l,d1
	move.w	(SaveRAM+2*SRFreeAgentCount).l,d0
	andi.w	#$FF,d0
	subq.w	#1,d0
	cmp.w	d0,d1
	bge.w	.2
	jsr	(printsmallz).l
	String	CC_SetX,$9,CC_SetY,$13,'}',$0
	bra.w	.3
.2
	jsr	(printsmallz).l
	String	CC_SetX,$9,CC_SetY,$13,' ',$0
.3
	jsr	(printsmallz).l
	String	CC_SetFont,$0
	movem.l	(sp)+,d0-d7/a0-a6
	rts

FreeAgentViolation	;Show VIOLATION OF ROSTER RULES message, wait, erase
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$5,$A,$0
	move.w	#$1F,d0
	move.w	#$E,d1
	jsr	(Framer).l
	jsr	(printsmallz).l
	String	CC_SetFont,$3,CC_SetX,$7,CC_SetY,$B,'VIOLATION OF ROSTER RULES',$0
	movea.l	#TradeRulesText,a1
	jsr	(printsmall).l
	bsr.w	ReadFreeAgentPads
	move.w	#$7FF,d2
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$5,$A,$0
	move.w	#$1F,d0
	move.w	#$E,d1
	jsr	(eraser).l
	jsr	(printsmallz).l
	String	CC_SetFont,$0
	bra.w	FreeAgentLoop

FreeAgentTeamBlock	;Draw team header (DrawTradeLogo) for team TradeData+$C
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(TradeData+$C).l,d1
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$19,$15,$0
	jsr	(DrawTradeLogo).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DrawFreeAgents	;Draw visible free agent rows (pos, name, rating)
	move.w	(TradeData).l,d5
	movea.l	#TradeData+$4,a5
	movea.l	#TradeRoster1,a4
	movea.l	#TradeRoster2,a3
	move.w	#9,(printy).w
	move.w	#$1C,d7
	move.w	(printy).w,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$0,$0,$0
	move.w	(sp)+,(printy).w
	clr.w	d6
	move.w	(a5),d0
	asl.w	#1,d0
	ext.l	d0
	adda.l	d0,a4
	adda.l	d0,a3
.loop
	jsr	(printsmallz).l
	String	CC_SetX,$0,'                                       ',$0
	move.w	#$B,(printx).w
	jsr	(printsmallz).l
	String	CC_SetFont,$0
	cmp.w	d5,d6
	bne.w	.1
	jsr	(printsmallz).l
	String	CC_SetFont,$1
.1
	move.w	(a3)+,d0
	move.w	#$1C,d7
	jsr	(FormatPlayerNameD7).l
	jsr	(printsmall).l
	move.w	#$1C,(printx).w
	movea.l	#PositionLetters3,a1
	move.w	(a4),d0
	move.w	#$D,d2
	lsr.w	d2,d0
	andi.w	#3,d0
	move.w	d0,(PenBuf).w
	jsr	(PrintSmallListItem).l
	move.w	#$21,(printx).w
	move.w	(a4),d0
	jsr	(GetCreatedName).l
	adda.w	(a1),a1
	addq.w	#8,a1
	movea.l	a1,a0
	movem.l	a4,-(sp)
	movea.l	#FieldTextBuf,a4
	movea.l	#OvrGoalWgtList,a6
	move.l	(GAttribOverallMask).l,d4
	tst.w	(PenBuf).w
	beq.w	.2
	movea.l	#OvrPlayerWgtList,a6
	move.l	(PAttribOverallMask).l,d4
.2
	jsr	(CalcAttribRating).l
	movem.l	(sp)+,a4
	mulu.w	#$64,d0
	divu.w	d1,d0
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	addq.l	#2,a4
	addq.w	#2,(printy).w
	addq.w	#1,d6
	move.w	(TradeData+$4).l,d0
	add.w	d6,d0
	cmp.w	(TradeData+$6).l,d0
	ble.w	.loop
	rts

PositionLetters3	;Position letters G/F/D
	String	'G',0
	String	'F',0
	String	'D',0

ReadFreeAgentPads	;Wait for a joypad press (polls both pads via ReadJoy1/ReadJoy2 + ProcessInputWithRepeat each frame); d1 = buttons
	move.l	#$5460,d6
.wait
	move.w	#$64,d6
	move.w	(vcount).w,d1
	sub.w	(oldvcount).w,d1
	beq.s	.wait
	move.w	(vcount).w,(oldvcount).w
	jsr	(ReadJoy1).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.1
	bra.w	.exit
.1
	jsr	(ReadJoy2).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.2
	bra.w	.exit
.2
	dbf	d6,.wait
.exit
	rts

FreeAgentExit	;Exit free-agent screen: set bit 6 of setupcardflags, jump to Opening2
	bset	#6,(setupcardflags).w
	jmp	(Opening2).l

FreeAgentsEmpty	;"Free agent list is now empty." message box, wait for a key, then exit
	clr.w	d0
	bra.w	.freeAgentMessage

.freeAgentMessage	;Show message box (string list FreeAgentMsgText, index d0), wait for key, exit via FreeAgentExit
	move.w	d0,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),5,$A,0
	move.w	#$1F,d0
	move.w	#$E,d1
	jsr	(Framer).l
	move.w	(sp)+,d0
	movea.l	#FreeAgentMsgText,a1
	jsr	(PrintSmallListItem).l
	bsr.w	ReadFreeAgentPads
	bra.s	FreeAgentExit

FreeAgentMsgText	;Message string list for PrintSmallListItem
	String	$F9,3,$FD,6,$FC,$D,'Free agent list is now empty.',0
	rts

BuildFreeAgentList	;Copy the free agent list (SRFreeAgentList, count in SRFreeAgentCount) to work table TradeRoster1 and index list TradeRoster2
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(SaveRAM+2*SRFreeAgentCount).l,d0
	andi.w	#$FF,d0
	subq.w	#1,d0
	movea.l	#SaveRAM+2*SRFreeAgentList,a0
	movea.l	#TradeRoster1,a1
	movea.l	#TradeRoster2,a5
	clr.w	d6
.loop
	move.l	(a0)+,d1
	move.b	d1,d2
	andi.w	#$FF,d2
	swap	d1
	lsl.w	#8,d1
	or.w	d1,d2
	move.w	d2,(a1)+
	move.w	d6,(a5)+
	addq.w	#1,d6
	dbf	d0,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts

rtsCreate4	;Empty routine
	rts

TestFreeAgents	;Test free-agent count byte (SRFreeAgentCount+1), flags only, d0 preserved
	movem.w	d0,-(sp)
	move.w	(SaveRAM+2*SRFreeAgentCount).l,d0
	tst.b	d0
	movem.w	(sp)+,d0
	rts

ReleasePlayers	;Release Player screen: up/down scroll roster, switch team, release highlighted player to the free-agent list (exits if list full)
	jsr	(forceblack).l
	jsr	(TradeGfx).l
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),7,2,'Release Player',0
	jsr	(printsmallz).l
	String	CC_SetFont,1,CC_SetX,6,CC_SetY,$19,'A,B',CC_SetX,$16,'C',CC_SetX,' Start',CC_AddY,1,0
	jsr	(printsmallz).l
	String	CC_SetX,2,'Switch Team',CC_SetX,$10,'Release Player',CC_SetX,'!Exit',CC_SetFont,0,0
	jsr	(printsmallz).l
	String	CC_SetFont,2,CC_SetX,$1B,CC_SetY,7,'POS.',CC_SetX,' RTG.',CC_SetFont,0
	clr.w	(TradeData+$C).l
	clr.w	(TradeData).l
	move.w	#0,(HomeTeam).w
	move.w	#0,(VisTeam).w
	jsr	(clearTeamStats).l
	bsr.w	ReleaseTeamBlock
	move.w	#$18,(palcount).w
	bclr	#2,(disflags).w

ReleaseRedraw	;ReleasePlayers: redraw the roster
	move.w	(SaveRAM+2*SRFreeAgentCount).l,d0
	andi.w	#$FF,d0
	cmp.w	#$1A,d0
	bge.w	FreeAgentsFull
	clr.w	(TradeData+$4).l
	move.w	(TradeData+$C).l,d7
	move.w	d7,(HomeTeam).w
	move.w	d7,(VisTeam).w
	jsr	(clearTeamStats).l
	jsr	(GetPlayerCountD7).l
	subq.w	#1,d0
	cmp.w	#5,d0
	ble.w	.0
	move.w	#5,d0
.0
	move.w	d0,(TradeData+$6).l
	movea.l	#TradeRoster1,a0
	movea.l	#TradeWork,a1
	bsr.w	BuildTradeRoster
	bsr.w	rtsCreate5
	move.w	#$FFFF,(setupdir).w

ReleaseLoop	;ReleasePlayers: input loop
	bsr.w	ReleaseTeamBlock
	bsr.w	DrawReleaseRoster
	bsr.w	ReleaseArrows
.check
	cmpi.w	#$FFFF,(setupdir).w
	beq.w	.input
	bsr.w	ReleaseTeamBlock
	bsr.w	DrawReleaseRoster
.input
	move.w	#$FFFF,(setupdir).w
	bsr.w	ReadReleasePads
	tst.w	d1
	beq.w	ReleaseExit
	btst	#0,d1
	beq.w	.3
	tst.w	(TradeData).l
	beq.w	.2
	subq.w	#1,(TradeData).l
	bra.s	ReleaseLoop
.2
	tst.w	(TradeData+$4).l
	beq.s	.input
	subq.w	#1,(TradeData+$4).l
	subq.w	#1,(TradeData+$6).l
	bra.s	ReleaseLoop
.3
	btst	#1,d1
	beq.w	.5
	move.w	(TradeData).l,d0
	add.w	(TradeData+$4).l,d0
	cmp.w	(TradeData+$6).l,d0
	beq.w	.4
	addq.w	#1,(TradeData).l
	bra.w	ReleaseLoop
.4
	move.w	(TradeData+$C).l,d7
	jsr	(GetPlayerCountD7).l
	subq.w	#1,d0
	cmp.w	(TradeData+$6).l,d0
	ble.s	.input
	addq.w	#1,(TradeData+$4).l
	addq.w	#1,(TradeData+$6).l
	bra.w	ReleaseLoop
.5
	btst	#4,d1
	beq.w	.6
	clr.w	(TradeData).l
	clr.w	(TradeData+$4).l
	move.w	#5,(TradeData+$6).l
	addq.w	#1,(TradeData+$C).l
	cmpi.w	#$1A,(TradeData+$C).l
	blt.w	ReleaseRedraw
	clr.w	(TradeData+$C).l
	bra.w	ReleaseRedraw
.6
	btst	#6,d1
	beq.w	.7
	clr.w	(TradeData).l
	clr.w	(TradeData+$4).l
	move.w	#5,(TradeData+$6).l
	subq.w	#1,(TradeData+$C).l
	bpl.w	ReleaseRedraw
	move.w	#$19,(TradeData+$C).l
	bra.w	ReleaseRedraw
.7
	btst	#7,d1
	bne.w	ReleaseExit
	btst	#5,d1
	beq.w	.16
	move.w	(TradeData+$C).l,d7
	jsr	(GetPlayerCountD7).l
	cmp.w	#$11,d0
	beq.w	ReleaseViolation
	movea.l	#TradeRoster1,a0
	move.w	(TradeData+$4).l,d0
	add.w	(TradeData).l,d0
	asl.w	#2,d0
	adda.w	d0,a0
	clr.w	d0
	move.b	1(a0),d0
	asl.w	#2,d0
	movea.l	#PositionMinChecks,a0
	movea.l	(a0,d0.w),a0
	jsr	(a0)
	beq.w	ReleaseViolation
	movea.l	#TradeRoster1,a0
	move.w	(TradeData+$4).l,d0
	add.w	(TradeData).l,d0
	asl.w	#2,d0
	adda.w	d0,a0
	move.b	1(a0),(TempWord1).w
	move.b	2(a0),(TempWord1+1).w
	move.w	(TradeData+$C).l,(TempRawSpd).w
	movea.l	#M68K_RAM,a2
	jsr	(ExtractTradedPlayer).l
	move.w	(TradeData+$C).l,(tradeteam1).w
	move.w	(TradeData+$C).l,(tradeteam2).w
	jsr	(CheckSavedLines).l
	movea.l	#SaveRAM+2*SRFreeAgentList,a0
	clr.w	(rosterscroll).w
.find
	tst.b	1(a0)
	bmi.w	.9
	addq.l	#4,a0
	addq.w	#1,(rosterscroll).w
	bra.s	.find
.9
	move.w	(M68K_RAM).l,d0
	andi.w	#$1FFF,d0
	move.b	(TempWord1).w,d1
	andi.w	#3,d1
	move.w	#$D,d2
	lsl.w	d2,d1
	or.w	d1,d0
	move.w	d0,d1
	lsr.w	#8,d1
	andi.w	#$FF,d1
	move.w	d1,(a0)
	andi.w	#$FF,d0
	move.w	d0,2(a0)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$1A,d7
	jsr	(ReadTeamPlayerStats).l
	movea.l	#StatBuf,a3
	movea.l	#M68K_RAM+4,a2
.10
	move.w	#4,d6
.block
	move.w	(rosterscroll).w,d0
	andi.w	#$FF,d0
	add.w	d0,d0
	move.w	#$34,d3
	bra.w	.13
.shift
	move.w	-2(a3,d3.w),d1
	move.w	d1,(a3,d3.w)
.13
	subq.w	#2,d3
	cmp.w	d0,d3
	ble.w	.14
	bra.s	.shift
.14
	move.w	(a2)+,d1
	move.w	d1,(a3,d3.w)
	adda.w	#$34,a3
	dbf	d6,.block
	jsr	(WriteTeamPlayerStats).l
	movem.l	(sp)+,d0-d7/a0-a6
	movea.l	#SaveRAM+2*SRFreeAgentJerseys,a0
	move.w	(rosterscroll).w,d0
	add.w	d0,d0
	adda.w	d0,a0
	move.w	(M68K_RAM+2).l,d1
	move.w	d1,(a0)
	addq.w	#1,(SaveRAM+2*SRFreeAgentCount).l
	jsr	(MakeSRAMChecksum).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$B,9,0
	move.w	#$7FF,d2
	move.w	#$1C,d0
	move.w	#6,d1
	jsr	(eraser).l
	tst.w	(TradeData).l
	beq.w	.15
	subq.w	#1,(TradeData).l
.15
	bra.w	ReleaseRedraw
.16
	bra.w	.check
	dc.l	GetGoalieCountD7,GetDefenseStartD7,GetPlayerCountD7	;unused pointers

PositionMinChecks	;Roster-minimum check per position code (0 G, 1 F, 2 D); Z set = cannot release
	dc.l	CheckMinGoalies,CheckMinForwards,CheckMinDefense

CheckMinGoalies	;Position 0 (G): count from GetGoalieCountD7, Z if == 2
	jsr	(GetGoalieCountD7).l
	cmp.w	#2,d0
	rts

CheckMinForwards	;Position 1 (F): count from GetForwardCountD7, Z if == 9
	jsr	(GetForwardCountD7).l
	cmp.w	#9,d0
	rts

CheckMinDefense	;Position 2 (D): GetPlayerCountD7 roster size minus GetDefenseStartD7 count, Z if == 6
	jsr	(GetDefenseStartD7).l
	move.w	d0,-(sp)
	jsr	(GetPlayerCountD7).l
	sub.w	(sp)+,d0
	cmp.w	#6,d0
	rts

ReleaseArrows	;Draw scroll arrows ({ above / } below) beside the roster list
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printsmallz).l
	String	CC_SetFont,1
	move.w	(TradeData+$4).l,d0
	add.w	(TradeData).l,d0
	beq.w	.0
	jsr	(printsmallz).l
	String	CC_SetX,9,CC_SetY,9,'{',0
	bra.w	.1
.0
	jsr	(printsmallz).l
	String	CC_SetX,9,CC_SetY,9,' ',0
.1
	move.w	(TradeData).l,d1
	add.w	(TradeData+$4).l,d1
	move.w	(TradeData+$C).l,d7
	jsr	(GetPlayerCountD7).l
	subq.w	#1,d0
	cmp.w	d0,d1
	bge.w	.2
	jsr	(printsmallz).l
	String	CC_SetX,9,CC_SetY,$15,'}',0
	bra.w	.3
.2
	jsr	(printsmallz).l
	String	CC_SetX,9,CC_SetY,$15,' ',0
.3
	jsr	(printsmallz).l
	String	CC_SetFont,0
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ReleaseViolation	;"VIOLATION OF ROSTER RULES" message box, wait for key, close it, back to the screen loop
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),5,$A,0
	move.w	#$1E,d0
	move.w	#$E,d1
	jsr	(Framer).l
	jsr	(printsmallz).l
	String	CC_SetFont,3,CC_SetX,7,CC_SetY,$B,'VIOLATION OF ROSTER RULES',0
	movea.l	#TradeRulesText,a1
	jsr	(printsmall).l
	bsr.w	ReadReleasePads
	move.w	#$7FF,d2
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),5,$A,0
	move.w	#$1E,d0
	move.w	#$E,d1
	jsr	(eraser).l
	jsr	(printsmallz).l
	String	CC_SetFont,0
	bra.w	ReleaseLoop

ReleaseTeamBlock	;Print team block for team TradeData+$C (DrawTradeLogo)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(TradeData+$C).l,d1
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$B,6,0
	jsr	(DrawTradeLogo).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DrawReleaseRoster	;Draw the visible roster rows (pos letter, name, rating) with highlight on cursor row
	move.w	(TradeData).l,d5
	movea.l	#TradeData+$4,a5
	movea.l	#TradeRoster1,a4
	move.w	#9,(printy).w
	move.w	(TradeData+$C).l,d7
	move.w	(printy).w,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),0,0,0
	move.w	(sp)+,(printy).w
	clr.w	d6
	move.w	(a5),d0
	asl.w	#2,d0
	ext.l	d0
	adda.l	d0,a4
.loop
	jsr	(printsmallz).l
	String	CC_SetX,0,'                                       ',0
	move.w	#$B,(printx).w
	jsr	(printsmallz).l
	String	CC_SetFont,0
	cmp.w	d5,d6
	bne.w	.1
	jsr	(printsmallz).l
	String	CC_SetFont,1
.1
	clr.w	d0
	move.b	2(a4),d0
	jsr	(FormatPlayerNameD7).l
	jsr	(printsmall).l
	move.w	#$1C,(printx).w
	movea.l	#PositionLetters4,a1
	clr.w	d0
	move.b	1(a4),d0
	move.w	d0,(PenBuf).w
	jsr	(PrintSmallListItem).l
	move.w	#$21,(printx).w
	clr.w	d0
	move.b	3(a4),d0
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	addq.l	#4,a4
	addq.w	#2,(printy).w
	addq.w	#1,d6
	move.w	(TradeData+$4).l,d0
	add.w	d6,d0
	cmp.w	(TradeData+$6).l,d0
	ble.w	.loop
	rts

PositionLetters4	;Position letter strings G/F/D for PrintSmallListItem
	String	'G',0
	String	'F',0
	String	'D',0

ReadReleasePads	;Wait for a joypad press on any of up to 4 pads (4-way play if FourWayPlay); d1 = buttons
	move.l	#$5460,d6
.wait
	move.w	#$64,d6
	move.w	(vcount).w,d1
	sub.w	(oldvcount).w,d1
	beq.s	.wait
	move.w	(vcount).w,(oldvcount).w
	jsr	(ReadJoy1).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.1
	bra.w	.exit
.1
	jsr	(ReadJoy2).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.2
	bra.w	.exit
.2
	tst.w	(FourWayPlay).w
	beq.w	.4
	jsr	(ReadJoy3).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.3
	bra.w	.exit
.3
	jsr	(ReadJoy4).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.4
	bra.w	.exit
.4
	dbf	d6,.wait
.exit
	rts

ReleaseExit	;Exit Release Player screen: set bit 6 of setupcardflags, jump to Opening2
	bset	#6,(setupcardflags).w
	jmp	(Opening2).l

FreeAgentsFull	;"Free agent list is full." message box, wait for key, then exit
	clr.w	d0
	bra.w	.releaseMessage

.releaseMessage	;Show message box (string list ReleaseMsgText, index d0), wait for key, exit via ReleaseExit
	move.w	d0,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),5,$A,0
	move.w	#$1E,d0
	move.w	#$E,d1
	jsr	(Framer).l
	move.w	(sp)+,d0
	movea.l	#ReleaseMsgText,a1
	jsr	(PrintSmallListItem).l
	bsr.w	ReadReleasePads
	bra.s	ReleaseExit

ReleaseMsgText	;Message string list for PrintSmallListItem
	String	$F9,3,$FD,6,$FC,$D,'Free agent list is full.'

rtsCreate5	;Empty routine
	rts

SeasonFramerMap	;Use the map a screen stored, or FramerMap when none is stored
	tst.l	(framermapptr).w
	beq.s	.def
	movea.l	(framermapptr).w,a1
	rts
.def	movea.l	#FramerMap,a1
	rts

CreateBgMap
	incbin	..\Extracted\NHL94\Season\CreateBgMap.map.jim
	even
NameEntryBgMap
	incbin	..\Extracted\NHL94\Season\NameEntryBgMap.map.jim
	even
CreateFramerMap
	incbin	..\Extracted\NHL94\Season\CreateFramerMap.map.jim
	even
ControllerBgMap
	incbin	..\Extracted\NHL94\Season\ControllerBgMap.map.jim
	even
TradeBgMap
	incbin	..\Extracted\NHL94\Season\TradeBgMap.map.jim
	even
