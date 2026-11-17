NameLetterGrid						;Name entry: the letter grid ("D-Pad to a letter.", "C to select letter.",
									;"A to go back.")
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	CC_Font1Pri,$1,$14
	move.w	#$16,d0
	move.w	#$7,d1
	move.w	#$7FF,d2		;blank char
	jsr	(eraser).l
	bchg	#$0,$1A567.l
	bne.w	.next
	jsr	(printz).l
	String	CC_Font1Pri,$19,$11
	movea.l	#$26DD0,a0		;print the 5 rows of 6 letters
	moveq	#$4,d0		;5 rows
.loop	moveq	#$5,d1		;6 letters
	movea.l	#mesarea,a1
	move.w	#$E,(a1)+		;String of 6 letters with spaces: 12 bytes + header
.loop2	move.b	(a0)+,(a1)+
	move.b	#$20,(a1)+
	dbra	d1,.loop2
	movea.l	#mesarea,a1
	jsr	(print).l
	addi.w	#$2,(printy).l
	subi.w	#$C,(printx).l
	dbra	d0,.loop
	jsr	(printz).l
	String	CC_Font2,$1,$14
	moveq	#$16,d0
	moveq	#$7,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	CC_Font1Pri,$2,$15,'D-Pad to a letter.'
	move.w	#$2,(printx).l
	addi.w	#$1,(printy).l
	move.w	(printx).l,-(sp)
	jsr	(printz).l
	String	'C to select letter.'
	move.w	(sp),(printx).l
	addi.w	#$1,(printy).l
	jsr	(printz).l
	String	'A to go back.'
	move.w	(sp),(printx).l
	addi.w	#$1,(printy).l
	jsr	(printz).l
	String	'B to cancel.'
	move.w	(sp)+,(printx).l
	addi.w	#$1,(printy).l
	jsr	(printz).l
	String	'START when done.'
.loop3	movem.l	(sp)+,d0-d7/a0-a6
	rts
.next	movea.l	#$1A37C,a1
	bsr.w	GetLogName		;copy the log name
	move.w	#$0,(printx).l
	move.w	#$F,(printy).l
	move.w	#$28,d0
	move.w	#$D,d1
	move.w	#$7FF,d2		;blank char
	jsr	(eraser).l
	jsr	(printz).l
	String	CC_Font2,$1,$14
	moveq	#$16,d0
	moveq	#$7,d1
	jsr	(Framer).l
	bsr.w	NameEntryHelp
	bra.w	.loop3

NameEntryHelp						;Name entry help text ("D-Pad up/down to move arrows.", "Press START to
	
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	CC_Font1Pri,$2,$15,'D-Pad up/down to    '
	jsr	(printz).l
	String	CC_Font1Pri,$2,$16,'move arrows.        '
	move.w	#$2,(printx).l
	move.w	(printx).l,-(sp)
	addi.w	#$1,(printy).l
	jsr	(printz).l
	String	'Press START to      '
	addi.w	#$1,(printy).l
	move.w	(sp),(printx).l
	jsr	(printz).l
	String	'select name.        '
	addi.w	#$1,(printy).l
	move.w	(sp)+,(printx).l
	jsr	(printz).l
	String	'Press B to edit.    '
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PrintNamePrompt						;Name entry: "Enter new name:" for an empty name log slot namelogsel, else
	
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	$1A38C.l,d0
	mulu.w	#$C,d0
	movea.l	#$1A2FC,a0
	movea.l	#$26C30,a1
	tst.b	(a0,d0.w)
	beq.w	.0
	movea.l	#$26C48,a1
.0	jsr	(print).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SyncLetterCursor						;Name entry: the letter grid cursor d5 = the grid index of the current
	
	movem.l	d0-d4/a0-a6,-(sp)
	move.b	$1A37C.l,d0
	bsr.w	FindLetter
	cmpi.w	#$1E,d0
	blt.w	.0
	clr.w	d5
	bra.w	.x
.0	move.w	d0,d5
	movea.l	#$26DD0,a0
	move.b	(a0,d5.w),$1A37C.l
.x	movem.l	(sp)+,d0-d4/a0-a6
	rts
FindLetter						;d0 = index of letter d0 in LetterGrid, $1E when not found
	movem.l	d1-d3/a0-a6,-(sp)
	movea.l	#$26DD0,a0
	move.b	d0,d1
	clr.w	d0
	move.w	#$1E,d3
.loop	cmp.b	(a0,d0.w),d1
	beq.w	.x
	addi.w	#$1,d0
	dbra	d3,.loop
	move.w	#$1E,d0
.x	movem.l	(sp)+,d1-d3/a0-a6
	rts
PrintNameCursor						;Name entry: the " < " cursor
	jsr	(printz).l
	String	CC_Font1Pri,$4,$13
	add.w	d4,(printx).l
	tst.w	$1A566.l
	beq.w	PrintNameCursorExit
	jsr	(printz).l
	String	' < '
; Return of PrintNameCursor
PrintNameCursorExit	rts
PrintCurLetter						;Name entry: print grid letter d5 (with the cursor on, cursoron)
	tst.w	$1A566.l
	beq.w	PrintNameCursorExit
	movea.l	#ThreeStars,a1
	move.w	#$4,(a1)
	move.b	#$0,$3(a1)
	movea.l	#$26DD0,a0
	move.b	(a0,d5.w),d0
	move.b	d0,$2(a1)
	jmp	(print).l
LetterGridPos						;Name entry: printx / printy of grid letter d5 (6 letters a row, 2 cells
	
	jsr	(printz).l
	String	CC_Font1Pri,$18,$10
	move.w	d5,d0
	ext.l	d0
	divu.w	#$6,d0
	asl.w	#$1,d0
	add.w	d0,(printy).l
	swap	d0
	asl.w	#$1,d0
	add.w	d0,(printx).l
	moveq	#$3,d0
	moveq	#$3,d1
	rts
PrintNameLog						;Name entry: the "Name Log" list (PrintNameField, GetLogName)
PrintNameLogEnterText				;the prompt String of the name entry screen (length word, map and position codes, text)
; Data of PrintNameLogEnterText (2 rows): table or constants used by it.
	dc.w	$0018
	dc.b	$BF,$02,$10,'  Enter new name: ',$00
PrintNameLogSelectText				;the prompt String of the Name Log list
; Data of PrintNameLogSelectText (2 rows): table or constants used by it.
	dc.w	$0018
	dc.b	$BF,$02,$10,'Select or replace:',$00
PrintNameLogList					;draw the Name Log list screen: prompt, then the log names
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	$1A38A.l,-(sp)
	move.w	$1A38C.l,-(sp)
	jsr	(printz).l				;the String that follows
; Inline data read by printz from the return address (1 row).
	dc.w	$0006,$BF05,$0800
	move.w	#$6,d7
PrintNameLogRows
	move.w	#$1,$1A38C.l
	movea.l	#TempBuffer,a1
.loop	bsr.w	GetLogName
	move.w	(printx).l,-(sp)
	bsr.w	PrintNameField
	move.w	(sp)+,(printx).l
	addi.w	#$1,(printy).l
	addi.w	#$1,$1A38C.l
	dbra	d7,.loop
	move.w	(sp)+,$1A38C.l
	move.w	(sp)+,$1A38A.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
MoveLogArrows						;Name entry: when the name log selection namelogsel changed, erase the old
	
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	$1A38C.l,d0
	cmp.w	$1A38E.l,d0
	beq.w	.x
	movea.l	#$26D4A,a1
	bsr.w	.next
	movea.l	#$26D42,a1
	bsr.w	.next
.x	movem.l	(sp)+,d0-d7/a0-a6
	rts
.next	tst.w	$1A38E.l
	beq.w	.next2
	jsr	(printz).l
	String	CC_Font1Pri,$3,$8
	move.w	$1A38E.l,d0
	subi.w	#$1,d0
	add.w	d0,(printy).l
	move.l	a1,-(sp)
	jsr	(print).l
	movea.l	(sp)+,a1
	adda.w	(a1),a1
	move.w	#$12,(printx).l
	jsr	(print).l
.next2	move.w	$1A38C.l,$1A38E.l
	rts
; Data that follows MoveLogArrows (strings, small tables)
MoveLogArrowsData	dc.w	$0004,$5D00,$0004,$5B00,$0004,$2000,$0004,$2000
GetNameLength						;namelength = length of the name being entered
	
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$B,d3
	movea.l	#$1A37C,a0
	clr.w	$1A38A.l
.loop	cmpi.b	#$2D,(a0)
	beq.w	.next
	tst.b	(a0)+
	beq.w	.next
	addi.w	#$1,$1A38A.l
	dbra	d3,.loop
.next	movem.l	(sp)+,d0-d7/a0-a6
	rts
PrintNameField						;Name entry: print the 12 character name field from a1, '-' past the
	
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#ThreeStars,a0
	move.w	$1A38A.l,d0
	move.w	#$0,d3
	move.w	#$E,(a0)+
.loop	move.b	(a1,d3.w),d1
	cmp.w	$1A38A.l,d3
	blt.w	.0
	move.b	#$2D,d1
.0	move.b	d1,(a0)+
	addi.w	#$1,d3
	cmpi.w	#$C,d3
	blt.w	.loop
	movea.l	#ThreeStars,a1
	jsr	(print).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Data that follows PrintNameField (strings, small tables)
PrintNameFieldTexts	dc.b	'ABCDEFGHIJKLMNOP'
NameEntryFramer						;Framer with the name entry frame tiles (nameframechars as framercset)
	subq.w	#$8,(a2)
	subq.w	#$1,(a4)
	subq.w	#$2,(a6)
	subq.w	#$3,(a0)+
	subq.w	#$4,(a2)+
	dc.w	$2E31,$3220		; move.l $20(a1,d3.w),d7
	move.l	d0,-(a6)
	move.w	(framercset).l,-(sp)
	move.w	$1A3D2.l,(framercset).l
	jsr	(Framer).l
	move.w	(sp)+,(framercset).l
	rts
GetLogName						;Copy name log entry namelogsel to a1 ('-' for
	
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#$1A2FC,a0
	move.w	$1A38C.l,d2
	mulu.w	#$C,d2
	move.w	#$0,$1A38A.l
	move.w	#$B,d3
.loop	move.b	(a0,d2.w),d0
	beq.w	.0
	bra.w	.next
.0	move.b	#$2D,d0
	subi.w	#$1,$1A38A.l
.next	move.b	d0,(a1)+
	addi.w	#$1,$1A38A.l
	addi.w	#$1,d2
	dbra	d3,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts
StoreUserName						;Name entry: store the name in save RAM
	
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#$1A2FC,a0
	move.w	$1A38C.l,d0
	mulu.w	#$C,d0
	adda.w	d0,a0
	movea.l	#$1A37C,a1
	move.w	#$B,d4
.loop	cmpi.b	#$2D,(a1)
	bne.w	.0
	move.b	#$0,(a1)
.0	move.b	(a1)+,d1
	cmp.b	(a0)+,d1
	bne.w	.next
	dbra	d4,.loop
	bra.w	.next2
.next	movea.l	#$1A2FC,a0
	move.w	$1A38C.l,d0
	mulu.w	#$C,d0
	adda.w	d0,a0
	movea.l	#$1A37C,a1
	move.w	#$B,d4
.loop2	move.b	(a1)+,d1
	cmpi.b	#$2D,d1
	bne.w	.2
	move.b	#$0,d1
.2	move.b	d1,(a0)+
	dbra	d4,.loop2
	bsr.w	WriteNameLog
	jsr	$26F06.l
.next2	movea.l	#$18BF4,a5
	tst.w	$1A390.l
	beq.w	.next3
	movea.l	#$18BF6,a5
.next3	tst.b	$1A37C.l
	bne.w	.next4
	clr.w	$1A38C.l
.next4	move.w	$1A38C.l,(a5)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$2D7,d7
	move.l	#$0,d0
	move.l	#$4,d1
	movea.l	#ThreeStars,a0
	move.w	$1A38C.l,d6
.loop3	clr.w	d5
	jsr	$22452.l
	cmp.b	$1(a0),d6
	bne.w	.next5
	clr.b	$1(a0)
	st.b	d5
.next5	cmp.b	$3(a0),d6
	bne.w	.next6
	clr.b	$3(a0)
	st.b	d5
.next6	tst.w	d5
	beq.w	.next7
	jsr	$2246C.l
.next7	addi.l	#$4,d0
	dbra	d7,.loop3
	move.w	#$1B,d7
	move.l	#$B60,d0
	move.l	#$10,d1
	movea.l	#ThreeStars,a0
	move.w	$1A38C.l,d6
.loop4	clr.w	d5
	jsr	$22452.l
	cmp.b	$1(a0),d6
	bne.w	.next8
	clr.b	$1(a0)
	st.b	d5
.next8	cmp.b	$3(a0),d6
	bne.w	.next9
	clr.b	$3(a0)
	st.b	d5
.next9	cmp.b	$5(a0),d6
	bne.w	.next10
	clr.b	$5(a0)
	st.b	d5
.next10	cmp.b	$7(a0),d6
	bne.w	.next11
	clr.b	$7(a0)
	st.b	d5
.next11	cmp.b	$9(a0),d6
	bne.w	.next12
	clr.b	$9(a0)
	st.b	d5
.next12	cmp.b	$B(a0),d6
	bne.w	.next13
	clr.b	$B(a0)
	st.b	d5
.next13	tst.w	d5
	beq.w	.next14
	jsr	$2246C.l
.next14	addi.l	#$10,d0
	dbra	d7,.loop4
	move.l	#$D20,d0
	move.w	$1A38C.l,d3
	asl.w	#$4,d3
	ext.l	d3
	add.l	d3,d0
	move.l	#$10,d1
	movea.l	#ThreeStars,a0
	jsr	$22452.l
	move.l	a0,-(sp)
	move.w	#$F,d3
.loop5	clr.b	(a0)+
	dbra	d3,.loop5
	movea.l	(sp)+,a0
	jsr	$2246C.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
UserNameEntry						;With user records on (OptUserRec 0): the name entry (NameEntryScreen) for
	
	tst.w	$18C06.l
	bne.w	.ex
	clr.w	$18BF4.l
	clr.w	$18BF6.l
	tst.w	$17FA6.l
	beq.w	.next
	move.w	$17FA6.l,$1A390.l
	subi.w	#$1,$1A390.l
	jsr	$26348.l
.next	tst.w	$17FA8.l
	beq.w	.ex
	movem.w	d0,-(sp)
	move.w	$17FA6.l,d0
	cmp.w	$17FA8.l,d0
	movem.w	(sp)+,d0
	beq.w	.ex
	move.w	$17FA8.l,$1A390.l
	subi.w	#$1,$1A390.l
	jsr	$26348.l
.ex	rts
SkipOtherUserName						;Name entry: step the selection namelogsel past the name the other pad
	
	movem.w	d0,-(sp)
	move.w	$18BF6.l,d0
	tst.w	$1A390.l
	beq.w	.next
	move.w	$18BF4.l,d0
.next	cmp.w	$1A38C.l,d0
	bne.w	.x
	move.w	#$1,d0
	tst.w	(sp)
	bpl.w	.next2
	move.w	#$FFFF,d0
.next2	add.w	d0,$1A38C.l
	clr.w	d0
.x	movem.w	(sp)+,d0
	rts
RecordHoldersScreen						;"Record Holders" menu item (menu lists): the save RAM record holders
	
	move.w	#$0,d0
	move.w	#$1A,d1
	jsr	(CrowdMeterFadeIn).l
	jsr	(printz).l
	String	CC_Font2Pri,$1,$1
	movea.l	$47D80.l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d1
	clr.w	d0
	moveq	#$6,d2
	move.w	#$6,d3
	moveq	#$8,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	CC_Font2Pri,$21,$1
	movea.l	$47D84.l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d1
	clr.w	d0
	moveq	#$6,d2
	move.w	#$6,d3
	moveq	#$0,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	CC_Font3Pri,$B,$1
	move.w	#$12,d0
	move.w	#$7,d1
	jsr	(Framer).l
	jsr	(printbigz).l
; Inline data read by printbigz from the return address (2 rows).
	dc.w	$0018
	dc.b	$BD,$0E,$02,'Record',$BD,$0D,$05,'Holders',$BD,$01,$09
	jsr	(printsmallz).l
; Inline data read by printsmallz from the return address (2 rows).
	dc.w	$0010
	dc.b	$F8,$06,$03,$05,$08,$F9,$01,'Name',$F9,$00,$00
	bsr.w	ReadNameLog
	clr.w	$17E62.l
	bclr	#$6,(sflags6).l
	bsr.w	ReadTeamRecords
	bset	#$6,(sflags6).l
	bsr.w	ReadTeamRecords
	bsr.w	CalcWinPercents
	bsr.w	PrintRecordTitles
	bsr.w	PrintRecordTitlesBody
.loop	jsr	(MenuWaitVblank).l
	jsr	(ReadActiveJoypad).l
	jsr	(ProcessInputWithRepeat).l
	btst	#$7,d3
	beq.w	.next
	jmp	(StatsScreenFadeIn).l
.next	tst.w	$17E62.l
	bne.w	.right
	btst	#$6,d3
	beq.w	.right
	btst	#$5,d3
	beq.w	.right
	bsr.w	ClearWinRecords
	bsr.w	CalcWinPercents
	bsr.w	PrintRecordTitlesBody
	bra.w	.loop
.right	btst	#$3,d1
	beq.w	.left
	cmpi.w	#$2,$17E62.l
	beq.w	.loop
	bsr.w	ClearRecordArea
	addi.w	#$1,$17E62.l
	bsr.w	PrintRecordTitles
	bsr.w	PrintRecordPage
	bra.w	.loop
.left	btst	#$2,d1
	beq.w	.loop
	tst.w	$17E62.l
	beq.w	.loop
	bsr.w	ClearRecordArea
	subi.w	#$1,$17E62.l
	bsr.w	PrintRecordTitles
	bsr.w	PrintRecordPage
	bra.w	.loop
	dc.w	$4E75		;N
PrintRecordPage
	tst.w	$17E62.l
	beq.w	PrintRecordTitlesBody
	bra.w	ClearRecordAreaRows
PrintRecordTitles						;Record Holders: the record titles (WinRecTitles, GoalRecTitles,
	
	movea.l	#$272A2,a1
	tst.w	$17E62.l
	beq.w	.0
	movea.l	#$27346,a1
	cmpi.w	#$2,$17E62.l
	beq.w	.0
	movea.l	#$272F4,a1
.0	jsr	(printsmall).l
	rts
; Data that follows PrintRecordTitles (strings, small tables)
PrintRecordTitlesData	dc.w	$0052,$F806,$0310,$08F9,$0120,$2020,$5769,$6E20
	dc.b	'%   Win-Loss-Tie'
	dc.b	$FD,$04,$FC,$19,'Use A+C to c'
	dc.b	'lear ALL win rec'
	dc.b	'ords',$FD,$10,$FC,$1A,'  More ]'
	dc.w	$F900,$0052,$F806,$0312,$08F9,$0147,$6F61,$6C73
	dc.b	'         Teams  '
	dc.b	'  ',$FD,$04,$FC,$19,'    TEAM M'
	dc.b	'UST WIN TO QUALI'
	dc.b	'FY    ',$FD,$10,$FC,$1A,'[ More'
	dc.w	$205D,$F900,$0052,$F806,$0312,$08F9,$0153,$6176
	dc.b	'es         Teams'
	dc.b	'    ',$FD,$04,$FC,$19,'    TEAM'
	dc.b	' MUST WIN TO QUA'
	dc.b	'LIFY    ',$FD,$10,$FC,$1A,'[ Mo'
	dc.b	're  ',$F9,$00
; Prints the record titles with ThreeStars data.
PrintRecordTitlesBody
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$2,$A,CC_SetFont,$0
	move.w	#$6,d7
	movea.l	#$1A3E4,a0
	movea.l	#$1A3EC,a2
	movea.l	#ThreeStars,a5
.loop	move.w	#$2,(printx).l
	move.b	(a0)+,d0
	ext.w	d0
	move.b	(a2,d0.w),d5
	asl.w	#$4,d0
	move.b	$A(a5,d0.w),d4
	lsl.w	#$8,d4
	move.b	$B(a5,d0.w),d4
	move.w	d4,-(sp)
	move.b	$C(a5,d0.w),d4
	lsl.w	#$8,d4
	move.b	$D(a5,d0.w),d4
	move.w	d4,$17E9A.l
	move.b	$8(a5,d0.w),d4
	lsl.w	#$8,d4
	move.b	$9(a5,d0.w),d4
	move.w	d4,$17E9E.l
	add.w	$17E9A.l,d4
	sub.w	(sp),d4
	neg.w	d4
	move.w	d4,$17E9C.l
	move.w	(sp)+,d4
	tst.w	d4
	beq.w	.next
	bsr.w	PrintRecordName
	move.w	#$13,(printx).l
	move.w	d0,-(sp)
	move.w	d5,d0
	move.w	#$3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	move.w	#$1A,(printx).l
	move.w	$17E9E.l,d0
	move.w	#$4,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	move.w	#$1F,(printx).l
	move.w	$17E9C.l,d0
	move.w	#$4,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	move.w	#$24,(printx).l
	move.w	$17E9A.l,d0
	move.w	#$3,d1
	jsr	(PushNumberWidth).l
	move.w	(sp)+,d0
	bra.w	.next2
.next	movea.l	#$27630,a1
.next2	jsr	(printsmall).l
	addi.w	#$2,(printy).l
	dbra	d7,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ClearRecordArea						;Record Holders: erase the record rows ($28 x $12), keeping printx /
	
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(printx).l,-(sp)
	move.w	(printy).l,-(sp)
	move.w	$18D5E.l,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$0,$A
	move.w	#$28,d0
	move.w	#$12,d1
	jsr	(eraser).l
	move.w	(sp)+,$18D5E.l
	move.w	(sp)+,(printy).l
	move.w	(sp)+,(printx).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Clears the record rows: prints the row prefix and loops over the rows
ClearRecordAreaRows
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$2,$A,CC_SetFont,$0
	move.w	#$6,d7
	movea.l	#$1A3D4,a0
	cmpi.w	#$1,$17E62.l
	beq.w	.next
	movea.l	#$1A3DC,a0
.next	movea.l	#ThreeStars,a2
.loop	move.w	#$2,(printx).l
	move.b	(a0)+,d0
	ext.w	d0
	asl.w	#$4,d0
	move.b	(a2,d0.w),d5
	cmpi.w	#$1,$17E62.l
	beq.w	.next2
	move.b	$4(a2,d0.w),d5
.next2	tst.b	d5
	beq.w	.next9
	bsr.w	PrintRecordName
	move.w	#$12,(printx).l
	move.w	d0,-(sp)
	cmpi.w	#$1,$17E62.l
	bne.w	.next3
	move.b	(a2,d0.w),d0
	bra.w	.next4
.next3	move.b	$4(a2,d0.w),d0
.next4	andi.w	#$FF,d0
	move.w	#$3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	move.w	(sp)+,d0
	move.w	#$19,(printx).l
	movea.l	#$27658,a1
	movea.l	#mesarea,a3
	bsr.w	CopyString
	move.w	d0,-(sp)
	cmpi.w	#$1,$17E62.l
	bne.w	.next5
	move.b	$1(a2,d0.w),d0
	bra.w	.next6
.next5	move.b	$5(a2,d0.w),d0
.next6	andi.w	#$FF,d0
	movea.l	#mesarea,a1
	bsr.w	AppendTeamName
	movea.l	#$2765E,a1
	movea.l	#mesarea,a3
	jsr	(appstring).l
	movea.l	#mesarea,a1
	move.w	(sp)+,d0
	cmpi.w	#$1,$17E62.l
	bne.w	.next7
	move.b	$2(a2,d0.w),d0
	bra.w	.next8
.next7	move.b	$6(a2,d0.w),d0
.next8	andi.w	#$FF,d0
	bsr.w	AppendTeamName
	bra.w	.next10
.next9	movea.l	#$27630,a1
.next10	jsr	(printsmall).l
	addi.w	#$2,(printy).l
	dbra	d7,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Data that follows ClearRecordArea (strings, small tables)
ClearRecordAreaData	dc.b	$00,'(              '
	dc.b	'                '
	dc.b	'        ',$00,$06,'by ',$00,$00,$08
	dc.b	' vs. ',$00
PrintRecordName
	move.w	d7,-(sp)
	neg.w	d7
	addi.w	#$7,d7
	addi.w	#$30,d7
	movea.l	#mesarea,a1
	move.w	#$6,(a1)
	move.b	d7,$2(a1)
	move.b	#$2E,$3(a1)
	move.b	#$20,$4(a1)
	move.b	#$0,$5(a1)
	jsr	(printsmall).l
	move.w	(sp)+,d7
	move.b	-$1(a0),d2
	ext.w	d2
	movea.l	#mesarea,a1
	bclr	#$7,(sflags6).l
	bsr.w	AppendUserName
	jmp	(printsmall).l
CalcWinPercents						;Record Holders: for the 8 user record blocks at recordbuf, the win %
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#ThreeStars,a0
	movea.l	#$1A3EC,a1
	movea.l	#$1A3F4,a6
	movea.l	#$1A404,a5
	move.w	#$7,d7
.loop	move.b	$8(a0),d0
	lsl.w	#$8,d0
	move.b	$9(a0),d0
	move.b	$A(a0),d1
	lsl.w	#$8,d1
	move.b	$B(a0),d1
	move.w	d1,(a5)+
	tst.w	d1
	bne.w	.0
	clr.w	d0
	bra.w	.1
.0	mulu.w	#$64,d0
	divu.w	d1,d0
.1	move.b	d0,(a1)+
	move.b	$C(a0),(a6)+
	move.b	$D(a0),(a6)+
	adda.w	#$10,a0
	dbra	d7,.loop
	movea.l	#$1A3E4,a1
	move.l	a1,-(sp)
	move.w	#$1,d0
	move.w	#$6,d7
.loop2	move.b	d0,(a1)+
	addi.w	#$1,d0
	dbra	d7,.loop2
	movea.l	(sp),a1
	movea.l	#$1A3EC,a0
	movea.l	#$1A3F4,a6
	movea.l	#$1A404,a5
.loop3	movea.l	(sp),a1
	move.w	#$5,d7
	clr.w	d6
.loop4	move.b	(a1)+,d1
	ext.w	d1
	move.b	(a1),d2
	ext.w	d2
	move.b	(a0,d1.w),d0
	move.b	(a0,d2.w),d3
	cmp.b	d3,d0
	bgt.w	.next
	blt.w	.swap
	movem.l	d1-d3,-(sp)
	add.w	d1,d1
	add.w	d2,d2
	move.w	(a6,d1.w),d0
	move.w	(a6,d2.w),d3
	cmp.w	d3,d0
	movem.l	(sp)+,d1-d3
	bgt.w	.next
	blt.w	.swap
	movem.l	d1-d3,-(sp)
	add.w	d1,d1
	add.w	d2,d2
	move.w	(a5,d1.w),d0
	move.w	(a5,d2.w),d3
	cmp.w	d3,d0
	movem.l	(sp)+,d1-d3
	bge.w	.next
.swap	move.b	(a1),d0
	move.b	-$1(a1),d1
	move.b	d0,-$1(a1)
	move.b	d1,(a1)
	st.b	d6
.next	dbra	d7,.loop4
	tst.w	d6
	bne.w	.loop3
	movea.l	(sp)+,a1
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ReadTeamRecords						;Record Holders: read the records (ReadSRAM)
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	#$D20,d0
	move.l	#$80,d1
	movea.l	#ThreeStars,a0
	jsr	$22452.l
	movea.l	#$1A3D4,a1
	btst	#$6,(sflags6).l
	beq.w	.0
	movea.l	#$1A3DC,a1
.0	move.l	a1,-(sp)
	move.w	#$1,d0
	move.w	#$6,d7
.loop	move.b	d0,(a1)+
	addi.w	#$1,d0
	dbra	d7,.loop
	movea.l	(sp),a1
	movea.l	#ThreeStars,a0
.loop2	movea.l	(sp),a1
	move.w	#$5,d7
	clr.w	d6
.loop3	move.b	(a1)+,d1
	ext.w	d1
	move.b	(a1),d2
	ext.w	d2
	asl.w	#$4,d1
	asl.w	#$4,d2
	move.b	(a0,d1.w),d0
	move.b	(a0,d2.w),d3
	btst	#$6,(sflags6).l
	beq.w	.1
	move.b	$4(a0,d1.w),d0
	move.b	$4(a0,d2.w),d3
.1	cmp.b	d3,d0
	bge.w	.next
	move.b	(a1),d0
	move.b	-$1(a1),d1
	move.b	d0,-$1(a1)
	move.b	d1,(a1)
	st.b	d6
.next	dbra	d7,.loop3
	tst.w	d6
	bne.w	.loop2
	movea.l	(sp)+,a1
	movem.l	(sp)+,d0-d7/a0-a6
	rts