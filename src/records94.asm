;	New in 94: user records. This file lets players enter their names and shows the Record
;	Holders screen with the win, goal and save records kept in save RAM.

NameEntryScreen						;"NAME ENTRY" screen for the user records (own vblank VBlank_SetOptions):
									;pick a name from the name log or enter a new one (NameLetterGrid ...
									;SkipOtherUserName). Called from UserNameEntry
	movem.l	d0-d7/a0-a6,-(sp)
	move	#$2700,sr				;interrupts off while the screen is set up
	move.w	#2,d4					;first free tile
	move.l	#VBlank_SetOptions,(VBint).w	;this screen's own vblank handler
	bclr	#dfok,(disflags).w		;display not ready
	bset	#dfng,(disflags).w		;no game drawing while the screen is built
	bclr	#df32c,(disflags).w		;32 cell flag off
	move.w	#0,(VSCRLPM).w			;plain scroll and the map / sprite table layout of the setup screens
	move.w	#$B400,(VSPRITES).w		;sprites address
	move.w	#$B800,(VmMAP3).w		;map 3 address
	move.w	#5,(Map3col).w			;map 3 width
	move.w	#$C000,(VmMAP2).w		;map 2 address
	move.w	#6,(Map2col).w			;map 2 width
	move.w	#$E000,(VmMAP1).w		;map 1 address
	move.w	#6,(Map1col).w			;map 1 width
	move.w	#0,d0					;clear VRAM
	jsr	(setVram).l					;set up vram
	move	#$2500,sr				;interrupts back on
	jsr	(orjoy).l					;forget any held button
	move.w	d4,(framercset).w		;d4 = next free tile: frame, font and logo tiles follow
	movea.l	#FramerMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l	;frame tiles
	dc.l	$91234567,$89ABCDEF		;remap table
	move.w	d4,(nameframechars).w	;name frame tiles
	movea.l	#FramerMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l	;the same frame tiles again
	dc.l	$91234560,$89ABCDEF		;remap table
	move.w	d4,(smallfontchars).w	;small font tiles
	jsr	(AddSmallFont).l			;send them
	jsr	(printz).l
	String	-TXMAP1,0,0
	moveq	#$28,d0					;clear the text map
	moveq	#$1C,d1
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l
	jsr	(setupIceRinkPal).l			;rink colors
	jsr	(printz).l
	String	-TXMAP2,0,0
	movea.l	#ScoutMap,a0			;the background picture
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2					;a2 = offsets
	adda.l	(a2)+,a0				;a0 = tile data
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0						;x 0
	clr.w	d1						;y 0
	moveq	#$28,d2					;width 40
	moveq	#$1C,d3					;height 28
	moveq	#$D,d5					;palette flags $D
	jsr	(dobitmap).l				;draw it
	move.w	d4,(homepicchars).w		;tile base for the team logo
	addi.w	#$24,d4					;36 logo chars
	move.w	d4,(logobox1chars).w	;logo box tiles
	movea.l	#LogoBoxMap+8,a2
	jsr	(DecompressGraphicsPlain).l	;send them
	move.w	d4,(BigFontchars).w		;the big font for the title
	movea.l	#BigFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l	;send them
	dc.l	$71234567,$89ABCDEF		;remap table
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$1F,6
	move.w	(HomeTeam).w,d0			;team of this name entry (nameentryvis: 0 home, 1 visitors)
	tst.w	(nameentryvis).w		;which side?
	beq.w	.0
	move.w	(VisTeam).w,d0			;visitors
.0									;team chosen: print its name centred over the logo
	movea.l	#TeamList,a1			;team address table
	asl.w	#2,d0					;long index
	movea.l	0(a1,d0.w),a1			;team data
	adda.w	Teamname(a1),a1			;team Strings: the city
	move.w	(a1),d0					;its length
	subq.w	#2,d0					;half the name length left of column $1F
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	jsr	(print).l					;print the city
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$1B,7
	move.w	#8,d0					;8 x 8 frame round the logo
	move.w	#8,d1					;height 8
	jsr	(Framer).l					;draw it
	jsr	(printz).l
	String	-(TXPRI+TXPAL3+TXMAP1),$1C,8
	move.w	(HomeTeam).w,d3			;the same team for the logo
	tst.w	(nameentryvis).w		;which side?
	beq.w	.1
	move.w	(VisTeam).w,d3			;visitors
.1									;team chosen: draw its logo
	asl.w	#2,d3					;long index
	movea.l	#TeamLogoBitmaps,a0		;team logo maps
	movea.l	0(a0,d3.w),a0			;this team's logo
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2					;a2 = offsets
	adda.l	(a2)+,a0				;a0 = tile data
	asl.w	#3,d3					;32 bytes of logo palette per team
	movea.l	#TeamLogoPalettes,a0
	subi.w	#$40,d3					;less two teams' palettes
	adda.w	d3,a0					;a0 = logo palette
	adda.l	(a2)+,a1				;a1 = map data
	move.w	#6,d3					;height 6
	move.w	#6,d2					;width 6
	clr.w	d0						;x 0
	clr.w	d1						;y 0
	move.w	#4,d5					;palette flags 4
	move.w	(homepicchars).w,d4		;logo chars
	jsr	(dobitmap).l				;draw the logo
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),2,0
	move.w	#$24,d0					;frame round the whole screen
	move.w	#6,d1					;height 6
	jsr	(Framer).l					;draw it
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),$A,2,'NAME  ENTRY'
	bsr.w	ReadNameLog				;the saved names
	clr.w	(namelogarrows).w		;no log arrows yet
	move.w	#1,(namelogsel).w		;start on log slot 1
	clr.w	d0
	bsr.w	SkipOtherUserName		;move off the other user's name if it is there
	movea.l	#nameentrybuf,a1		;load the selected name for editing
	bsr.w	GetLogName				;copy the log name
	bsr.w	PrintNameLog			;print the name log
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),7,6,'Name Log'
	move.w	#$18,(palcount).w		;fade in over $18 frames
	bclr	#dfng,(disflags).w		;display ready
	clr.w	d4						;d4 = cursor position in the name (0-11)
	bsr.w	SyncLetterCursor		;d5 = grid letter under the first character
	bsr.w	PrintNameCursor			;name cursor
	bsr.w	LetterGridPos			;printx / printy of grid letter d5
.2									;(not branched to)
	move.w	(printx).w,-(sp)		;frame the selected grid letter
	move.w	(printy).w,-(sp)		;save
	jsr	(NameEntryFramer).l
	move.w	(sp)+,(printy).w		;restore
	addq.w	#1,(printy).w			;inside the frame
	move.w	(sp)+,(printx).w
	addq.w	#1,(printx).w
	bsr.w	PrintCurLetter			;print the letter
	move.w	#1,(cursoron).w			;start in edit mode; NameLetterGrid flips it to log mode
	bsr.w	NameLetterGrid			;flip to log mode
	clr.w	d0						;d0 = 0: put the name cursor on position 0
	bra.w	.11
.loop								;each pass: redraw the name and prompt
	bsr.w	GetNameLength			;d0 = name length
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),5,$12
	tst.w	(cursoron).w			;log mode: no name field or prompt
	beq.w	.3
	movea.l	#nameentrybuf,a1		;the name
	bsr.w	PrintNameField			;print it
	bsr.w	PrintNamePrompt			;and the prompt
.3									;then move the ] [ arrows if the log selection changed
	bsr.w	MoveLogArrows
.loop2								;wait for a press
	move.w	(Vcount).w,d0
.loop3								;wait for the next vblank
	cmp.w	(Vcount).w,d0
	beq.s	.loop3
	movem.w	d1,-(sp)				;save
	move.w	(cont1team).w,d1		;the pad of this team: controller 1 if it is on this side
	subq.w	#1,d1					;0 home, 1 visitors
	cmp.w	(nameentryvis).w,d1
	movem.w	(sp)+,d1				;restore
	beq.w	.input					;controller 1 owns this team
	jsr	(ReadJoy2).l				;otherwise controller 2
	tst.w	d1
	beq.s	.loop2					;nothing pressed
	bra.w	.5						;handle it
.input								;controller 1's team: read pad 1
	jsr	(ReadJoy1).l
	tst.w	d1						;anything pressed?
	beq.s	.loop2
.5									;a button pressed
	btst	#7,d1
	bne.w	.14						;start: done
	tst.w	(cursoron).w
	bne.w	.6						;edit mode: the letter controls
	move.w	#1,d0					;log mode: down = next name
	btst	#1,d1
	bne.w	.7
	move.w	#$FFFF,d0				;up = previous name
	btst	#0,d1
	bne.w	.7
	btst	#4,d1					;B: switch to editing
	beq.w	.loop
	bsr.w	NameLetterGrid
	clr.w	d0
	bra.w	.7						;(d0 = 0 just reloads the name)
.6									;edit mode
	moveq	#-1,d0					;A: cursor back one
	btst	#6,d1
	bne.w	.11
	neg.w	d0						;C: cursor forward one
	btst	#5,d1
	bne.w	.11
	btst	#3,d1					;right: next grid letter
	bne.w	.12
	neg.w	d0						;left: previous grid letter
	btst	#2,d1
	bne.w	.12
	moveq	#6,d0					;down: grid letter one row lower
	btst	#1,d1
	bne.w	.12
	neg.w	d0						;up: one row higher
	btst	#0,d1
	bne.w	.12
	btst	#4,d1					;B: back to the name log
	beq.w	.loop
	bsr.w	NameLetterGrid
	bra.w	.loop
.7									;log mode: move the selection by d0
	add.w	d0,(namelogsel).w
.loop4								;wrap into slots 1-7
	cmpi.w	#7,(namelogsel).w
	ble.w	.8
	move.w	#1,(namelogsel).w
.8									;at or below 7
	tst.w	(namelogsel).w
	bne.w	.9
	move.w	#7,(namelogsel).w
.9									;slot in range: skip the other user's name
	bsr.w	SkipOtherUserName
	beq.s	.loop4					;that slot is the other user: move on
	movea.l	#nameentrybuf,a1
	bsr.w	GetLogName				;copy the log name
	tst.w	(cursoron).w			;edit mode: show the letters again
	bne.w	.10
	jsr	(NameEntryHelp).l			;log mode: the help text
	bra.w	.loop					;loop
.10									;edit mode: clear the cursor and the old grid frame
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),4,$13
	add.w	d4,(printx).w			;at the cursor
	jsr	(printz).l
	String	'   '
	bsr.w	LetterGridPos			;printx / printy of grid letter d5
	moveq	#1,d2					;height 1
	move.w	(printx).w,-(sp)		;save
	move.w	(printy).w,-(sp)
	jsr	(eraser).l					;erase the frame
	move.w	(sp)+,(printy).w		;restore
	addq.w	#1,(printy).w
	move.w	(sp)+,(printx).w		;inside the frame
	addq.w	#1,(printx).w
	bsr.w	PrintCurLetter			;print the letter
	bsr.w	SyncLetterCursor		;d5 = grid letter under the cursor
	move.w	d4,d0					;d0 = -d4: the cursor goes back to position 0
	neg.w	d0
	bra.w	*+4						;(branches to the next line)
.11									;move the name cursor by d0
	add.w	d4,d0
	cmp.w	#$B,d0
	bhi.w	.loop					;outside 0-11: ignore
	move.w	d0,d4					;new cursor position
	bsr.w	PrintNameCursor			;move the name cursor
	movea.l	#nameentrybuf,a0		;the name
	clr.w	d0						;no move
	cmpi.b	#$2D,0(a0,d4.w)			;a "-" keeps the grid letter where it is
	beq.w	.12
	move.b	0(a0,d4.w),d0			;the letter
	ext.w	d0
	bsr.w	FindLetter				;grid index of the letter under the cursor
	sub.w	d5,d0					;d0 = that index - d5, so .12 lands on it
.12									;move the grid cursor by d0
	add.w	d5,d0
	cmp.w	#$1D,d0					;outside the 30 letters: ignore
	bhi.w	.loop
	move.w	d0,-(sp)				;erase the frame of the old letter
	bsr.w	LetterGridPos			;printx / printy of grid letter d5
	moveq	#1,d2					;height 1
	move.w	(printx).w,-(sp)		;save
	move.w	(printy).w,-(sp)
	jsr	(eraser).l					;erase it
	move.w	(sp)+,(printy).w		;restore
	addq.w	#1,(printy).w
	move.w	(sp)+,(printx).w		;inside the frame
	addq.w	#1,(printx).w
	bsr.w	PrintCurLetter			;print the letter
	move.w	(sp)+,d5				;d5 = new grid letter
	bsr.w	LetterGridPos			;its printx / printy
	move.w	(printx).w,-(sp)		;save
	move.w	(printy).w,-(sp)
	tst.w	(cursoron).w			;edit mode?
	beq.w	.13						;log mode: no frame
	jsr	(NameEntryFramer).l
.13									;frame drawn (edit mode only): print the letter
	move.w	(sp)+,(printy).w
	addq.w	#1,(printy).w			;inside the frame
	move.w	(sp)+,(printx).w
	addq.w	#1,(printx).w			;inside the frame
	bsr.w	PrintCurLetter
	movea.l	#nameentrybuf,a0
	movea.l	#LetterGrid,a1			;the chosen letter goes into the name at the cursor
	move.b	0(a1,d5.w),d0			;the letter
	move.b	d0,0(a0,d4.w)			;into the name
	bra.w	.loop					;loop
.14									;start: save the name and leave
	bsr.w	StoreUserName			;save it in the name log
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
NameLetterGrid						;Name entry: the letter grid ("D-Pad to a letter.", "C to select letter.",
									;"A to go back.")
	movem.l	d0-d7/a0-a6,-(sp)		;save
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),1,$14
	move.w	#$16,d0					;width $16
	move.w	#7,d1					;height 7
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l					;clear the help area
	bchg	#0,(cursoron+1).w		;flip between edit and log mode
	bne.w	.1						;now log mode: show the help instead
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$19,$11
	movea.l	#LetterGrid,a0			;print the 5 rows of 6 letters
	moveq	#4,d0					;5 rows
.loop								;each row
	moveq	#5,d1					;6 letters
	movea.l	#mesarea,a1				;row buffer
	move.w	#$E,(a1)+				;String of 6 letters with spaces: 12 bytes + header
.loop2								;letter and a space
	move.b	(a0)+,(a1)+
	move.b	#$20,(a1)+
	dbf	d1,.loop2					;next letter
	movea.w	#(mesarea-M68K_RAM),a1	;row buffer
	jsr	(print).l					;print the row
	addq.w	#2,(printy).w			;two rows down
	subi.w	#$C,(printx).w			;back to the row start
	dbf	d0,.loop					;next row
	jsr	(printz).l
	String	-TXMAP2,1,$14
	moveq	#$16,d0					;width $16
	moveq	#7,d1					;height 7
	jsr	(Framer).l					;draw the frame
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),2,$15,'D-Pad to a letter.'
	move.w	#2,(printx).w			;column 2
	addq.w	#1,(printy).w			;next row
	move.w	(printx).w,-(sp)		;save the column
	jsr	(printz).l
	String	'C to select letter.'
	move.w	(sp),(printx).w			;same column
	addq.w	#1,(printy).w			;next row
	jsr	(printz).l
	String	'A to go back.'
	move.w	(sp),(printx).w			;same column
	addq.w	#1,(printy).w			;next row
	jsr	(printz).l
	String	'B to cancel.'
	move.w	(sp)+,(printx).w		;same column
	addq.w	#1,(printy).w			;next row
.0									;(not branched to)
	jsr	(printz).l
	String	'START when done.'
.x									;pop the registers saved at entry
	movem.l	(sp)+,d0-d7/a0-a6		;restore
.x2									;(not branched to)
	rts								;return
.1									;log mode: reload the name, clear the field area, frame the help box
	movea.l	#nameentrybuf,a1		;the name
.2									;(not branched to)
	bsr.w	GetLogName				;copy the log name
	move.w	#0,(printx).w			;column 0
.3									;(not branched to)
	move.w	#$F,(printy).w			;row $F
	move.w	#$28,d0					;width 40
.4									;(not branched to)
	move.w	#$D,d1					;height 13
	move.w	#$7FF,d2				;blank char
.5									;(not branched to)
	jsr	(eraser).l					;clear it
.6									;(not branched to)
	jsr	(printz).l
	String	-TXMAP2,1,$14
	moveq	#$16,d0					;width $16
	moveq	#7,d1					;height 7
.7									;(not branched to)
	jsr	(Framer).l					;draw the frame
	bsr.w	NameEntryHelp			;the help text
	bra.s	.x						;done
NameEntryHelp						;Name entry help text ("D-Pad up/down to move arrows.", "Press START to
									;select name.", "Press B to edit.")
	movem.l	d0-d7/a0-a6,-(sp)		;save
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),2,$15,'D-Pad up/down to    '
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),2,$16,'move arrows.        '
	move.w	#2,(printx).w			;column 2
	move.w	(printx).w,-(sp)		;save the column
	addq.w	#1,(printy).w			;next row
	jsr	(printz).l
	String	'Press START to      '
	addq.w	#1,(printy).w			;next row
	move.w	(sp),(printx).w			;same column
	jsr	(printz).l
	String	'select name.        '
	addq.w	#1,(printy).w			;next row
	move.w	(sp)+,(printx).w		;same column
	jsr	(printz).l
	String	'Press B to edit.    '
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
PrintNamePrompt						;Name entry: "Enter new name:" for an empty name log slot namelogsel, else
									;"Select or replace:"
	movem.l	d0-d7/a0-a6,-(sp)		;save
	move.w	(namelogsel).w,d0		;log slot
	mulu.w	#$C,d0					;12 bytes per name
	movea.l	#namelog,a0				;user name log
	movea.l	#EnterNameTxt,a1
	tst.b	0(a0,d0.w)				;empty slot: "Enter new name:"
	beq.w	.0
	movea.l	#SelectNameTxt,a1
.0									;text chosen: print it
	jsr	(print).l					;print it
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
SyncLetterCursor					;Name entry: the letter grid cursor d5 = the grid index of the current
									;letter (FindLetter), 0 when it is not in the grid
	movem.l	d0-d4/a0-a6,-(sp)		;save
	move.b	(nameentrybuf).w,d0		;first letter of the name
	bsr.w	FindLetter				;d0 = its grid index
	cmp.w	#$1E,d0					;not in the grid: cursor on the first letter
	blt.w	.0
	clr.w	d5
	bra.w	.x						;done
.0									;letter found: d5 = its index
	move.w	d0,d5
	movea.l	#LetterGrid,a0
	move.b	0(a0,d5.w),(nameentrybuf).w	;unknown letters are turned into the first grid letter
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d4/a0-a6		;restore
	rts								;return
FindLetter							;d0 = index of letter d0 in LetterGrid, $1E when not found
	movem.l	d1-d3/a0-a6,-(sp)		;save
	movea.l	#LetterGrid,a0			;letter grid
	move.b	d0,d1					;d1 = letter
	clr.w	d0						;index 0
	move.w	#$1E,d3					;31 tries
.loop								;compare with each grid letter
	cmp.b	0(a0,d0.w),d1
	beq.w	.x						;found
	addq.w	#1,d0					;next index
	dbf	d3,.loop					;all 31 tried: not found
	move.w	#$1E,d0					;not found
.x									;exit: restore the registers
	movem.l	(sp)+,d1-d3/a0-a6		;restore
	rts								;return
PrintNameCursor						;Name entry: the " < " cursor
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),4,$13
	add.w	d4,(printx).w			;at the cursor
	tst.w	(cursoron).w			;cursor on?
	beq.w	rtsNameCursor			;cursor off: print nothing
	jsr	(printz).l
	String	' < '
rtsNameCursor						;(the shared rts here)
	rts
PrintCurLetter						;Name entry: print grid letter d5 (with the cursor on, cursoron)
	tst.w	(cursoron).w			;cursor on?
	beq.s	rtsNameCursor			;no: nothing
	movea.l	#ThreeStars,a1			;letter String
	move.w	#4,(a1)					;String of 1 letter (length 4)
	move.b	#0,3(a1)				;end of string
	movea.l	#LetterGrid,a0			;letter grid
	move.b	0(a0,d5.w),d0			;the letter
	move.b	d0,2(a1)				;into the String
	jmp	print						;print it
LetterGridPos						;Name entry: printx / printy of grid letter d5 (6 letters a row, 2 cells
									;apart); d0 / d1 = 3 x 3 box
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$18,$10
	move.w	d5,d0					;grid index
	ext.l	d0						;clear the high word
	divu.w	#6,d0					;row = index / 6, column = remainder
	asl.w	#1,d0					;rows are 2 apart
	add.w	d0,(printy).w
	swap	d0						;remainder
	asl.w	#1,d0					;columns are 2 apart
	add.w	d0,(printx).w
	moveq	#3,d0					;width 3
	moveq	#3,d1					;height 3
	rts								;return
EnterNameTxt	dc.b	0			;PrintNamePrompt table
	dc.b	$18,$BF,2,$10,$20,$20
	dc.b	$45						;E
	dc.b	$6E						;n
	dc.b	$74						;t
	dc.b	$65						;e
	dc.b	$72						;r
	dc.b	$20
	dc.b	$6E						;n
	dc.b	$65						;e
	dc.b	$77						;w
	dc.b	$20
	dc.b	$6E						;n
	dc.b	$61						;a
	dc.b	$6D						;m
	dc.b	$65						;e
	dc.b	$3A						;:
	dc.b	$20,0
SelectNameTxt	dc.b	0			;PrintNamePrompt table
	dc.b	$18,$BF,2,$10
	dc.b	$53						;S
	dc.b	$65						;e
	dc.b	$6C						;l
	dc.b	$65						;e
	dc.b	$63						;c
	dc.b	$74						;t
	dc.b	$20
	dc.b	$6F						;o
	dc.b	$72						;r
	dc.b	$20
	dc.b	$72						;r
	dc.b	$65						;e
	dc.b	$70						;p
	dc.b	$6C						;l
	dc.b	$61						;a
	dc.b	$63						;c
	dc.b	$65						;e
	dc.b	$3A						;:
	dc.b	0
PrintNameLog						;Name entry: the "Name Log" list (PrintNameField, GetLogName)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	move.w	(namelength).w,-(sp)	;save
	move.w	(namelogsel).w,-(sp)	;save the selection
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),5,8
	move.w	#6,d7					;7 log slots
	move.w	#1,(namelogsel).w		;from slot 1
	movea.l	#TempBuffer,a1			;name buffer
.loop								;print each slot's name on its own row
	bsr.w	GetLogName				;copy the log name
	move.w	(printx).w,-(sp)		;save the column
	bsr.w	PrintNameField			;print it
	move.w	(sp)+,(printx).w		;same column
	addq.w	#1,(printy).w			;next row
	addq.w	#1,(namelogsel).w		;next slot
	dbf	d7,.loop					;loop
	move.w	(sp)+,(namelogsel).w	;put back the caller's selection
	move.w	(sp)+,(namelength).w	;restore
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
MoveLogArrows						;Name entry: when the name log selection namelogsel changed, erase the old
									;] [ arrows and print them at the new row (PrintLogArrows)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	move.w	(namelogsel).w,d0		;selection
	cmp.w	(namelogarrows).w,d0	;arrows already there?
	beq.w	.x						;same row: nothing to do
	movea.l	#LogArrowsClrTxt,a1		;blank arrows
	bsr.w	PrintLogArrows			;erase the old ones
	movea.l	#LogArrowsTxt,a1		;the arrows
	bsr.w	PrintLogArrows			;print the new ones
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts								;return
PrintLogArrows						;Name entry: print the two arrow Strings at a1 on name log row
									;namelogarrows, then namelogarrows = namelogsel
	tst.w	(namelogarrows).w
	beq.w	.0						;no arrows drawn yet: nothing to erase
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),3,8
	move.w	(namelogarrows).w,d0	;arrow row
	subq.w	#1,d0					;rows from 1
	add.w	d0,(printy).w
	move.l	a1,-(sp)				;save
	jsr	(print).l					;left arrow
	movea.l	(sp)+,a1				;restore
	adda.w	(a1),a1					;the second String (right arrow) follows the first
	move.w	#$12,(printx).w			;column $12
	jsr	(print).l					;right arrow
.0									;old arrows handled: remember the new row
	move.w	(namelogsel).w,(namelogarrows).w
	rts								;return
LogArrowsTxt	dc.b	0			;MoveLogArrows data
	dc.b	4
	dc.b	$5D						;]
	dc.b	0,0,4
	dc.b	$5B						;[
	dc.b	0
LogArrowsClrTxt	dc.b	0			;MoveLogArrows data
	dc.b	4,$20,0,0,4,$20,0
GetNameLength						;namelength = length of the name being entered
									;(up to '-' or 0, at most 12)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	move.w	#$B,d3					;at most 12 characters
	movea.l	#nameentrybuf,a0		;the name
	clr.w	(namelength).w			;count 0
.loop								;check each character
	cmpi.b	#$2D,(a0)				;a '-' ends the name
	beq.w	.x
	tst.b	(a0)+					;so does a 0
	beq.w	.x
	addq.w	#1,(namelength).w		;count it
	dbf	d3,.loop					;next character
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
PrintNameField						;Name entry: print the 12 character name field from a1, '-' past the
									;length namelength
	movem.l	d0-d7/a0-a6,-(sp)		;save
	movea.l	#ThreeStars,a0			;String buffer
	move.w	(namelength).w,d0		;(d0 unused)
	move.w	#0,d3					;character index
	move.w	#$E,(a0)+				;String of 12 characters
.loop								;each character of the field
	move.b	0(a1,d3.w),d1			;the character
	cmp.w	(namelength).w,d3		;past the name?
	blt.w	.0						;inside the name: print it
	move.b	#$2D,d1
.0									;past the name: '-'
	move.b	d1,(a0)+				;store it
	addq.w	#1,d3					;next character
	cmp.w	#$C,d3					;12 characters
	blt.s	.loop					;loop
	movea.l	#ThreeStars,a1			;the field
	jsr	(print).l					;print it
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
LetterGrid	dc.b	$41				;Name entry data
	dc.b	$42						;B
	dc.b	$43						;C
	dc.b	$44						;D
	dc.b	$45						;E
	dc.b	$46						;F
	dc.b	$47						;G
	dc.b	$48						;H
	dc.b	$49						;I
	dc.b	$4A						;J
	dc.b	$4B						;K
	dc.b	$4C						;L
	dc.b	$4D						;M
	dc.b	$4E						;N
	dc.b	$4F						;O
	dc.b	$50						;P
	dc.b	$51						;Q
	dc.b	$52						;R
	dc.b	$53						;S
	dc.b	$54						;T
	dc.b	$55						;U
	dc.b	$56						;V
	dc.b	$57						;W
	dc.b	$58						;X
	dc.b	$59						;Y
	dc.b	$5A						;Z
	dc.b	$2E
	dc.b	$31						;1
	dc.b	$32						;2
	dc.b	$20
	dc.b	$2D						;-
	dc.b	0
NameEntryFramer						;Framer with the name entry frame tiles (nameframechars as framercset)
	move.w	(framercset).w,-(sp)	;save the frame tiles
	move.w	(nameframechars).w,(framercset).w	;use the name entry frame tiles
	jsr	(Framer).l					;draw the frame
	move.w	(sp)+,(framercset).w	;restore
	rts								;return
GetLogName							;Copy name log entry namelogsel to a1 ('-' for
									;empty), namelength = its length
	movem.l	d0-d7/a0-a6,-(sp)		;save
	movea.l	#namelog,a0				;user name log
	move.w	(namelogsel).w,d2		;log slot
	mulu.w	#$C,d2					;12 bytes per name
	move.w	#0,(namelength).w		;length 0
	move.w	#$B,d3					;12 characters
.loop								;each character
	move.b	0(a0,d2.w),d0
	beq.w	.0						;0 = unused character
	bra.w	.1						;a letter: copy it
.0									;empty: '-' and not counted
	move.b	#$2D,d0
	subq.w	#1,(namelength).w
.1									;character ready
	move.b	d0,(a1)+				;store it
	addq.w	#1,(namelength).w		;count it
	addq.w	#1,d2					;next character
	dbf	d3,.loop					;loop
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
StoreUserName						;Name entry: store the name in save RAM
									;(WriteNameRecord, MakeSRAMChecksum)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	movea.l	#namelog,a0				;user name log
	move.w	(namelogsel).w,d0		;log slot
	mulu.w	#$C,d0					;12 bytes per name
	adda.w	d0,a0					;this slot
	movea.l	#nameentrybuf,a1		;the entered name
	move.w	#$B,d4					;12 characters
.loop								;compare the entered name with the logged one
	cmpi.b	#$2D,(a1)
	bne.w	.0
	move.b	#0,(a1)					;'-' means an unused character: 0 in the log
.0									;character ready
	move.b	(a1)+,d1				;the character
	cmp.b	(a0)+,d1				;same as the log?
	bne.w	.1						;a difference: store the new name
	dbf	d4,.loop					;next character
	bra.w	.3						;same name: nothing to write
.1									;new name: copy it into the log slot
	movea.l	#namelog,a0				;user name log
	move.w	(namelogsel).w,d0		;log slot
	mulu.w	#$C,d0					;12 bytes per name
	adda.w	d0,a0					;this slot
	movea.l	#nameentrybuf,a1		;the entered name
	move.w	#$B,d4					;12 characters
.loop2								;copy 12 characters
	move.b	(a1)+,d1				;the character
	cmp.b	#$2D,d1					;'-'?
	bne.w	.2
	move.b	#0,d1					;'-' becomes 0
.2									;character ready
	move.b	d1,(a0)+
	dbf	d4,.loop2					;next character
	bsr.w	WriteNameLog			;save the log, then drop the old name's records
	jsr	(WriteNameRecord).l			;clear the old name's records
	jsr	(MakeSRAMChecksum).l		;new save RAM checksum
.3									;name stored or unchanged: this side's user number
	movea.l	#homeuser,a5			;home side
	tst.w	(nameentryvis).w
	beq.w	.4
	movea.l	#awayuser,a5			;visitors side: awayuser
.4									;user field chosen
	tst.b	(nameentrybuf).w		;empty name?
	bne.w	.5						;a name was entered
	clr.w	(namelogsel).w			;empty name: no user (0)
.5									;user number = log slot
	move.w	(namelogsel).w,(a5)
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
WriteNameRecord						;Write the name record (ReadSRAM / WriteSRAM)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	move.w	#$2D7,d7				;$2D8 player records of 4 bytes
	moveq	#0,d0					;first record
	moveq	#4,d1					;4 bytes
	movea.l	#recordbuf,a0			;record buffer
	move.w	(namelogsel).w,d6		;d6 = the slot whose name was replaced
.loop								;each player record: clear the old holder
	clr.w	d5
	jsr	(ReadSRAM).l				;read the record
	cmp.b	pruser(a0),d6			;the record holder?
	bne.w	.0						;no
	clr.b	pruser(a0)				;clear it
	st	d5							;changed
.0									;proppuser: the other user
	cmp.b	proppuser(a0),d6		;is it this slot?
	bne.w	.1						;no
	clr.b	proppuser(a0)			;clear it
	st	d5							;changed
.1									;write back only when changed
	tst.w	d5
	beq.w	.2						;no
	jsr	(WriteSRAM).l				;write it back
.2									;next record
	addq.l	#4,d0					;next record
	dbf	d7,.loop					;loop
	move.w	#NumTeams-1,d7			;each team's crowd record block
	move.l	#CrowdRecBase,d0		;first block
	moveq	#$10,d1					;16 bytes
	movea.l	#recordbuf,a0			;record buffer
	move.w	(namelogsel).w,d6		;the replaced slot
.loop2								;clear the old user from each crowd record
	clr.w	d5						;(holder and opponent of the goals, saves and peak records)
	jsr	(ReadSRAM).l				;read the block
	cmp.b	crgoalsuser(a0),d6		;goals record holder?
	bne.w	.3						;no
	clr.b	crgoalsuser(a0)			;clear it
	st	d5							;changed
.3									;goals holder done: goals opponent
	cmp.b	crgoalsoppuser(a0),d6	;goals record opponent?
	bne.w	.4						;no
	clr.b	crgoalsoppuser(a0)		;clear it
	st	d5							;changed
.4									;saves holder
	cmp.b	crsavesuser(a0),d6		;saves record holder?
	bne.w	.5						;no
	clr.b	crsavesuser(a0)			;clear it
	st	d5							;changed
.5									;saves opponent
	cmp.b	crsavesoppuser(a0),d6	;saves record opponent?
	bne.w	.6						;no
	clr.b	crsavesoppuser(a0)		;clear it
	st	d5							;changed
.6									;peak holder
	cmp.b	crpeakuser(a0),d6		;peak record holder?
	bne.w	.7						;no
	clr.b	crpeakuser(a0)			;clear it
	st	d5							;changed
.7									;peak opponent
	cmp.b	crpeakoppuser(a0),d6	;peak record opponent?
	bne.w	.8						;no
	clr.b	crpeakoppuser(a0)		;clear it
	st	d5							;changed
.8									;write back only when changed
	tst.w	d5
	beq.w	.9						;no
	jsr	(WriteSRAM).l				;write it back
.9									;next block
	addi.l	#CrowdRecBytes,d0		;next block
	dbf	d7,.loop2					;next team
	move.l	#TeamRecBase,d0			;and wipe the new slot's own 16 byte user record
	move.w	(namelogsel).w,d3		;log slot
	asl.w	#4,d3
	ext.l	d3						;long
	add.l	d3,d0					;its user record
	moveq	#$10,d1					;16 bytes
	movea.l	#recordbuf,a0			;record buffer
	jsr	(ReadSRAM).l				;read it
	move.l	a0,-(sp)				;keep the buffer
	move.w	#$F,d3					;16 bytes
.loop3								;clear 16 bytes
	clr.b	(a0)+
	dbf	d3,.loop3					;next byte
	movea.l	(sp)+,a0				;record buffer
	jsr	(WriteSRAM).l				;write it back
	jsr	(MakeSRAMChecksum).l		;new save RAM checksum
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return

UserNameEntry						;With user records on (OptUserRec 0): the name entry (NameEntryScreen) for
									;the pads in use. Called from Opening2
	tst.w	(OptUserRec).w
	bne.w	.x						;user records off: no name entry
	clr.w	(homeuser).w			;no home user yet
	clr.w	(awayuser).w			;no away user yet
	tst.w	(cont1team).w			;controller 1 on a team: enter its name
	beq.w	.0
	move.w	(cont1team).w,(nameentryvis).w
	subq.w	#1,(nameentryvis).w		;nameentryvis = 0 home, 1 visitors
	jsr	(NameEntryScreen).l
.0									;controller 1 done or unused: now controller 2
	tst.w	(cont2team).w
	beq.w	.x						;controller 2 not on a team
	movem.w	d0,-(sp)				;save
	move.w	(cont1team).w,d0		;controller 1 team
	cmp.w	(cont2team).w,d0		;same as controller 2?
	movem.w	(sp)+,d0				;restore
	beq.w	.x						;both pads on the same team: one name only
	move.w	(cont2team).w,(nameentryvis).w
	subq.w	#1,(nameentryvis).w
	jsr	(NameEntryScreen).l			;controller 2's name
.x									;exit (also the end of the code above)
	rts
SkipOtherUserName					;Name entry: step the selection namelogsel past the name the other pad
									;picked (homeuser / awayuser), in the direction on the stack
	movem.w	d0,-(sp)				;d0 = the step direction (passed on the stack)
	move.w	(awayuser).w,d0			;the other side's user
	tst.w	(nameentryvis).w		;which side?
	beq.w	.0
	move.w	(homeuser).w,d0			;visitors: the home user
.0									;other user chosen
	cmp.w	(namelogsel).w,d0
	bne.w	.x						;not his slot: keep it
	move.w	#1,d0					;his slot: step past it (+1, or -1 when the stack word is negative)
	tst.w	(sp)
	bpl.w	.1						;forward
	move.w	#$FFFF,d0				;back
.1									;direction chosen
	add.w	d0,(namelogsel).w
	clr.w	d0						;d0 = 0 tells the caller to check the slot again
.x									;exit: restore the registers
	movem.w	(sp)+,d0
	rts
RecordHoldersScreen					;"Record Holders" menu item (menu lists): the save RAM record holders
									;(PrintRecordTitles ... ReadTeamRecords)
	move.w	#0,d0					;setup screen with the frame layout
	move.w	#$1A,d1					;height $1A
	jsr	(SetupScreen).l				;set it up
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),1,1
	movea.l	#CornerLogoMap,a0		;corner logo map
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2					;a2 = offsets
	adda.l	(a2)+,a0				;a0 = tile data
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d1						;y 0
	clr.w	d0						;x 0
	moveq	#6,d2					;width 6
	move.w	#6,d3					;height 6
	moveq	#8,d5					;palette flags 8
	jsr	(dobitmap).l				;draw it
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),'!',1
	movea.l	#ArenaGfxBank,a0		;arena logo bank
	movea.l	a0,a1					;a1 = map header
.0									;(not branched to)
	movea.l	a0,a2					;a2 = offsets
	adda.l	(a2)+,a0				;a0 = tile data
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d1						;y 0
	clr.w	d0						;x 0
	moveq	#6,d2					;width 6
	move.w	#6,d3					;height 6
	moveq	#0,d5					;palette flags 0
	jsr	(dobitmap).l				;draw it
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),$B,1
	move.w	#$12,d0					;width $12
	move.w	#7,d1					;height 7
	jsr	(Framer).l					;draw the frame
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP3),$E,2,'Record',-(TXPRI+TXMAP3),$D,5,'Holders',-(TXPRI+TXMAP3),1,9
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,6,3,5,8,CC_SetFont,1,'Name',CC_SetFont,0
	bsr.w	ReadNameLog				;the user names
	clr.w	(TempWord1).w			;page 0: win records
	bclr	#6,(sflags6).w			;the goals sort (sflags6 bit 6 clear)
	bsr.w	ReadTeamRecords
	bset	#6,(sflags6).w			;then the saves sort
	bsr.w	ReadTeamRecords
	bsr.w	CalcWinPercents			;win percentages
	bsr.w	PrintRecordTitles		;first page: titles and win records
	bsr.w	PrintWinRecords
.loop								;each frame: read the pad
	jsr	(vcountwait).l				;wait for the next frame
	jsr	(getpzjoy).l				;read the pads
	jsr	(ProcessInputWithRepeat).l	;with key repeat
	btst	#7,d3					;start?
	beq.w	.1						;start leaves the screen
	jmp	ExitStatsScreen				;back to the stats menu
.1									;page 0: A + C clears the win records
	tst.w	(TempWord1).w			;page 0?
.2									;(not branched to)
	bne.w	.right
	btst	#6,d3					;A?
	beq.w	.right
.3									;(not branched to)
	btst	#5,d3					;C?
	beq.w	.right
	bsr.w	ClearWinRecords			;clear the win records
	bsr.w	CalcWinPercents			;recalculate
.show								;(not branched to)
	bsr.w	PrintWinRecords			;print them again
	bra.s	.loop					;loop
.right								;right: next page (up to page 2)
	btst	#3,d1
	beq.w	.left					;no
	cmpi.w	#2,(TempWord1).w		;last page?
	beq.s	.loop
	bsr.w	ClearRecordArea			;clear the rows
	addq.w	#1,(TempWord1).w		;next page
	bsr.w	PrintRecordTitles		;its titles
	bsr.w	PrintRecordPage			;its rows
	bra.s	.loop					;loop
.left								;left: previous page
	btst	#2,d1
	beq.s	.loop					;no
	tst.w	(TempWord1).w			;first page?
	beq.s	.loop
	bsr.w	ClearRecordArea			;clear the rows
	subq.w	#1,(TempWord1).w		;previous page
	bsr.w	PrintRecordTitles		;its titles
	bsr.w	PrintRecordPage			;its rows
	bra.w	.loop					;loop
	dc.b	$4E						;N
	dc.b	$75						;u
PrintRecordPage						;Record Holders: print one page
									;(TempWord1 = page: 0 wins, 1 goals, 2 saves)
	tst.w	(TempWord1).w
	beq.w	PrintWinRecords			;page 0: wins
	bra.w	PrintPlayerRecords		;pages 1 and 2
PrintRecordTitles					;Record Holders: the record titles (WinRecTitles, GoalRecTitles,
									;SaveRecTitles)
	movea.l	#WinRecTitles,a1		;page 0
	tst.w	(TempWord1).w			;page 0: the win titles
	beq.w	.0						;yes
	movea.l	#SaveRecTitles,a1
	cmpi.w	#2,(TempWord1).w
	beq.w	.0						;page 2: the saves titles
	movea.l	#GoalRecTitles,a1
.0									;page titles chosen
	jsr	(printsmall).l				;print them
	rts								;return
WinRecTitles	dc.b	0			;PrintRecordTitles Strings
	dc.b	$52						;R
	dc.b	$F8,6,3,$10,8,$F9,1,$20,$20,$20
	dc.b	$57						;W
	dc.b	$69						;i
	dc.b	$6E						;n
	dc.b	$20
	dc.b	$25						;%
	dc.b	$20,$20,$20
	dc.b	$57						;W
	dc.b	$69						;i
	dc.b	$6E						;n
	dc.b	$2D						;-
	dc.b	$4C						;L
	dc.b	$6F						;o
	dc.b	$73						;s
	dc.b	$73						;s
	dc.b	$2D						;-
	dc.b	$54						;T
	dc.b	$69						;i
	dc.b	$65						;e
	dc.b	$FD,4,$FC,$19
	dc.b	$55						;U
	dc.b	$73						;s
	dc.b	$65						;e
	dc.b	$20
	dc.b	$41						;A
	dc.b	$2B						;+
	dc.b	$43						;C
	dc.b	$20
	dc.b	$74						;t
	dc.b	$6F						;o
	dc.b	$20
	dc.b	$63						;c
	dc.b	$6C						;l
	dc.b	$65						;e
	dc.b	$61						;a
	dc.b	$72						;r
	dc.b	$20
	dc.b	$41						;A
	dc.b	$4C						;L
	dc.b	$4C						;L
	dc.b	$20
	dc.b	$77						;w
	dc.b	$69						;i
	dc.b	$6E						;n
	dc.b	$20
	dc.b	$72						;r
	dc.b	$65						;e
	dc.b	$63						;c
	dc.b	$6F						;o
	dc.b	$72						;r
	dc.b	$64						;d
	dc.b	$73						;s
	dc.b	$FD,$10,$FC,$1A,$20,$20
	dc.b	$4D						;M
	dc.b	$6F						;o
	dc.b	$72						;r
	dc.b	$65						;e
	dc.b	$20
	dc.b	$5D						;]
	dc.b	$F9,0
GoalRecTitles	dc.b	0			;PrintRecordTitles Strings
	dc.b	$50						;P
	dc.b	$F8,6,3,$12,8,$F9,1
	dc.b	$47						;G
	dc.b	$6F						;o
	dc.b	$61						;a
	dc.b	$6C						;l
	dc.b	$73						;s
	dc.b	$20,$20,$20,$20,$20,$20,$20
	dc.b	$54						;T
	dc.b	$65						;e
	dc.b	$61						;a
	dc.b	$6D						;m
	dc.b	$73						;s
	dc.b	$20,$20,$20,$20,$FD,4,$FC,$19,$20,$20,$20,$20
	dc.b	$54						;T
	dc.b	$45						;E
	dc.b	$41						;A
	dc.b	$4D						;M
	dc.b	$20
	dc.b	$4D						;M
	dc.b	$55						;U
	dc.b	$53						;S
	dc.b	$54						;T
	dc.b	$20
	dc.b	$57						;W
	dc.b	$49						;I
	dc.b	$4E						;N
	dc.b	$20
	dc.b	$54						;T
	dc.b	$4F						;O
	dc.b	$20
	dc.b	$51						;Q
	dc.b	$55						;U
	dc.b	$41						;A
	dc.b	$4C						;L
	dc.b	$49						;I
	dc.b	$46						;F
	dc.b	$59						;Y
	dc.b	$20,$20,$20,$20,$FD,$10,$FC,$1A
	dc.b	$5B						;[
	dc.b	$20
	dc.b	$4D						;M
	dc.b	$6F						;o
	dc.b	$72						;r
	dc.b	$65						;e
	dc.b	$20
	dc.b	$5D						;]
	dc.b	$F9,0
SaveRecTitles	dc.b	0			;PrintRecordTitles Strings
	dc.b	$50						;P
	dc.b	$F8,6,3,$12,8,$F9,1
	dc.b	$53						;S
	dc.b	$61						;a
	dc.b	$76						;v
	dc.b	$65						;e
	dc.b	$73						;s
	dc.b	$20,$20,$20,$20,$20,$20,$20
	dc.b	$54						;T
	dc.b	$65						;e
	dc.b	$61						;a
	dc.b	$6D						;m
	dc.b	$73						;s
	dc.b	$20,$20,$20,$20,$FD,4,$FC,$19,$20,$20,$20,$20
	dc.b	$54						;T
	dc.b	$45						;E
	dc.b	$41						;A
	dc.b	$4D						;M
	dc.b	$20
	dc.b	$4D						;M
	dc.b	$55						;U
	dc.b	$53						;S
	dc.b	$54						;T
	dc.b	$20
	dc.b	$57						;W
	dc.b	$49						;I
	dc.b	$4E						;N
	dc.b	$20
	dc.b	$54						;T
	dc.b	$4F						;O
	dc.b	$20
	dc.b	$51						;Q
	dc.b	$55						;U
	dc.b	$41						;A
	dc.b	$4C						;L
	dc.b	$49						;I
	dc.b	$46						;F
	dc.b	$59						;Y
	dc.b	$20,$20,$20,$20,$FD,$10,$FC,$1A
	dc.b	$5B						;[
	dc.b	$20
	dc.b	$4D						;M
	dc.b	$6F						;o
	dc.b	$72						;r
	dc.b	$65						;e
	dc.b	$20,$20,$F9,0
PrintWinRecords						;Record Holders: the rows (PrintRecordName)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,2,2,$A,CC_SetFont,0
	move.w	#6,d7					;7 rows
	movea.l	#winsort,a0				;users in win order
	movea.l	#winpcts,a2				;win percentages
	movea.l	#recordbuf,a5			;user records
.loop								;each row: the user in sort order
	move.w	#2,(printx).w			;column 2
	move.b	(a0)+,d0				;user
	ext.w	d0						;word
	move.b	0(a2,d0.w),d5			;his win %
	asl.w	#4,d0					;16 bytes per user record
	move.b	urgames(a5,d0.w),d4		;games, big endian
	lsl.w	#8,d4
	move.b	urgames+1(a5,d0.w),d4
	move.w	d4,-(sp)				;keep the games
	move.b	urties(a5,d0.w),d4		;ties, big endian
	lsl.w	#8,d4
	move.b	urties+1(a5,d0.w),d4
	move.w	d4,(recties).w			;store them
	move.b	urwins(a5,d0.w),d4		;wins, big endian
	lsl.w	#8,d4
	move.b	urwins+1(a5,d0.w),d4
	move.w	d4,(recwins).w			;store them
	add.w	(recties).w,d4			;losses = games - wins - ties
	sub.w	(sp),d4
	neg.w	d4
	move.w	d4,(reclosses).w		;store them
	move.w	(sp)+,d4				;games
	tst.w	d4						;no games: "( )" instead
	beq.w	.0
	bsr.w	PrintRecordName			;user name
	move.w	#$13,(printx).w			;win %, wins, losses and ties columns
	move.w	d0,-(sp)				;save the user
	move.w	d5,d0					;win %
	move.w	#3,d1					;3 digits
	jsr	(PushNumberWidth).l			;as a String
	jsr	(printsmall).l				;print it
	move.w	#$1A,(printx).w
	move.w	(recwins).w,d0			;wins
	move.w	#4,d1					;4 digits
	jsr	(PushNumberWidth).l			;as a String
	jsr	(printsmall).l				;print it
	move.w	#$1F,(printx).w
	move.w	(reclosses).w,d0		;losses
	move.w	#4,d1					;4 digits
	jsr	(PushNumberWidth).l			;as a String
	jsr	(printsmall).l				;print it
	move.w	#$24,(printx).w
	move.w	(recties).w,d0			;ties
	move.w	#3,d1					;3 digits
	jsr	(PushNumberWidth).l			;as a String
	move.w	(sp)+,d0				;restore the user
	bra.w	.1
.0									;user has no games
	movea.l	#RecParenTxt,a1
.1									;print the last part
	jsr	(printsmall).l
	addq.w	#2,(printy).w			;rows are 2 apart
	dbf	d7,.loop					;next row
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
ClearRecordArea						;Record Holders: erase the record rows ($28 x $12), keeping printx /
									;printy / printm
	movem.l	d0-d7/a0-a6,-(sp)		;save
	move.w	(printx).w,-(sp)		;save
	move.w	(printy).w,-(sp)		;save
	move.w	(printm).w,-(sp)		;save
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,2,0,$A
	move.w	#$28,d0					;width $28
	move.w	#$12,d1					;height $12
	jsr	(eraser).l					;erase it
	move.w	(sp)+,(printm).w		;restore
	move.w	(sp)+,(printy).w		;restore
	move.w	(sp)+,(printx).w		;restore
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
PrintPlayerRecords					;Record Holders: the rows of the other page (PrintRecordName)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,2,2,$A,CC_SetFont,0
	move.w	#6,d7					;7 rows
	movea.l	#recsort1,a0			;page 1: the goals sort
	cmpi.w	#1,(TempWord1).w
	beq.w	.0
	movea.l	#recsort2,a0
.0									;sort list chosen
	movea.l	#recordbuf,a2			;user records
.loop								;each row
	move.w	#2,(printx).w			;column 2
	move.b	(a0)+,d0				;user
	ext.w	d0						;word
	asl.w	#4,d0					;16 bytes per user record
	move.b	0(a2,d0.w),d5			;goals record, or the saves one on page 2
	cmpi.w	#1,(TempWord1).w
	beq.w	.1
	move.b	ursaves(a2,d0.w),d5
.1									;record value chosen
	tst.b	d5
	beq.w	.none					;no record: "( )"
	bsr.w	PrintRecordName			;user name
	move.w	#$12,(printx).w			;column $12
	move.w	d0,-(sp)				;save the user
	cmpi.w	#1,(TempWord1).w		;page 1?
	bne.w	.2						;page 2: saves
	move.b	0(a2,d0.w),d0
	bra.w	.3
.2									;page 2: the saves value
	move.b	ursaves(a2,d0.w),d0
.3									;value chosen: print it
	andi.w	#$FF,d0					;byte
	move.w	#3,d1					;3 digits
	jsr	(PushNumberWidth).l			;as a String
	jsr	(printsmall).l				;print it
	move.w	(sp)+,d0				;restore the user
	move.w	#$19,(printx).w			;column $19
	movea.l	#RecHolderByTxt,a1		;"by" the team
	movea.l	#mesarea,a3				;output
	bsr.w	CopyString
	move.w	d0,-(sp)				;save the user
	cmpi.w	#1,(TempWord1).w		;page 1?
	bne.w	.4						;page 2: the saves team
	move.b	urgoalsteam(a2,d0.w),d0
	bra.w	.5
.4									;page 2: the saves team
	move.b	ursavesteam(a2,d0.w),d0
.5									;team chosen
	andi.w	#$FF,d0					;byte
	movea.l	#mesarea,a1				;output
	bsr.w	AppendTeamName			;append the team name
	movea.l	#RecHolderVsTxt,a1		;"vs." the opponent
	movea.l	#mesarea,a3				;output
	jsr	(appstring).l				;append it
	movea.l	#mesarea,a1				;output
	move.w	(sp)+,d0				;restore the user
	cmpi.w	#1,(TempWord1).w		;page 1?
	bne.w	.6						;page 2: the saves opponent
	move.b	urgoalsopp(a2,d0.w),d0
	bra.w	.7
.6									;page 2: the saves opponent
	move.b	ursavesopp(a2,d0.w),d0
.7									;opponent chosen
	andi.w	#$FF,d0					;byte
	bsr.w	AppendTeamName			;append the team name
	bra.w	.print					;print the line
.none								;no record: "( )"
	movea.l	#RecParenTxt,a1
.print								;print the row
	jsr	(printsmall).l
	addq.w	#2,(printy).w			;next row
	dbf	d7,.loop					;loop
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
RecParenTxt	dc.b	0				;PrintWinRecords data
	dc.b	$28						;(
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	dc.b	$20,$20,$20,$20,$20,$20
RecHolderByTxt	dc.b	0			;PrintPlayerRecords data
	dc.b	6
	dc.b	$62						;b
	dc.b	$79						;y
	dc.b	$20,0
RecHolderVsTxt	dc.b	0			;PrintPlayerRecords data
	dc.b	8,$20
	dc.b	$76						;v
	dc.b	$73						;s
	dc.b	$2E
	dc.b	$20,0
PrintRecordName						;Record Holders: print a value (AppendUserName)
	move.w	d7,-(sp)				;save the row counter
	neg.w	d7						;row number = 7 - d7
	addq.w	#7,d7
	addi.w	#$30,d7					;"N. "
	movea.l	#mesarea,a1				;output
	move.w	#6,(a1)					;length 6
	move.b	d7,2(a1)				;row digit
	move.b	#$2E,3(a1)				;'.'
	move.b	#$20,4(a1)				;space
	move.b	#0,5(a1)				;end of string
	jsr	(printsmall).l				;print it
	move.w	(sp)+,d7				;restore
	move.b	-1(a0),d2				;user number of this row
	ext.w	d2
	movea.l	#mesarea,a1				;output
	bclr	#7,(sflags6).w			;bit 7 clear: AppendUserName does not trim
	bsr.w	AppendUserName
	jmp	printsmall					;print the name
CalcWinPercents						;Record Holders: for the 8 user record blocks at recordbuf, the win %
									;(winpcts), games (wingames) and ties (winties), then sort the rows
									;(winsort)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	movea.l	#recordbuf,a0			;user records
	movea.l	#winpcts,a1				;win percentages
	movea.l	#winties,a6				;ties
	movea.l	#wingames,a5			;games
	move.w	#7,d7					;8 user blocks
.loop								;each user record
	move.b	urwins(a0),d0			;wins, big endian
	lsl.w	#8,d0
	move.b	urwins+1(a0),d0
	move.b	urgames(a0),d1			;games, big endian
	lsl.w	#8,d1
	move.b	urgames+1(a0),d1
	move.w	d1,(a5)+				;store the games
	tst.w	d1						;no games: 0%
	bne.w	.0
	clr.w	d0
	bra.w	.1
.0									;games played: win % = wins * 100 / games
	mulu.w	#$64,d0
	divu.w	d1,d0
.1									;% ready
	move.b	d0,(a1)+				;store the %
	move.b	urties(a0),(a6)+		;store the ties
	move.b	urties+1(a0),(a6)+
	adda.w	#$10,a0					;next 16 byte block
	dbf	d7,.loop					;next user
	movea.l	#winsort,a1				;sort list
	move.l	a1,-(sp)				;keep it
	move.w	#1,d0					;the sort list starts as users 1-7
	move.w	#6,d7					;7 users
.loop2								;fill in users 1-7
	move.b	d0,(a1)+
	addq.w	#1,d0					;next user
	dbf	d7,.loop2					;loop
	movea.l	(sp),a1					;sort list
	movea.l	#winpcts,a0				;win percentages
	movea.l	#winties,a6				;ties
	movea.l	#wingames,a5			;games
.loop3								;bubble sort: win %, then ties, then games
	movea.l	(sp),a1					;sort list
	move.w	#5,d7					;6 pairs
	clr.w	d6						;no swap yet
.loop4								;compare a pair with the next
	move.b	(a1)+,d1				;this user
	ext.w	d1
	move.b	(a1),d2					;next user
	ext.w	d2
	move.b	0(a0,d1.w),d0			;this user's %
	move.b	0(a0,d2.w),d3			;next user's %
	cmp.b	d3,d0
	bgt.w	.next					;higher % first
	blt.w	.swap
	movem.l	d1-d3,-(sp)				;save
	add.w	d1,d1					;word index
	add.w	d2,d2
	move.w	0(a6,d1.w),d0			;this user's ties
	move.w	0(a6,d2.w),d3			;next user's ties
	cmp.w	d3,d0					;compare
	movem.l	(sp)+,d1-d3				;restore
	bgt.w	.next					;same %: more ties first
	blt.w	.swap
	movem.l	d1-d3,-(sp)				;save
	add.w	d1,d1					;word index
	add.w	d2,d2
	move.w	0(a5,d1.w),d0			;this user's games
	move.w	0(a5,d2.w),d3			;next user's games
	cmp.w	d3,d0					;compare
	movem.l	(sp)+,d1-d3				;restore
	bge.w	.next					;same ties: more games first
.swap								;out of order: swap
	move.b	(a1),d0					;this entry
	move.b	-1(a1),d1				;previous entry
	move.b	d0,-1(a1)				;swap them
	move.b	d1,(a1)
	st	d6							;swapped
.next								;next pair
	dbf	d7,.loop4					;next pair
	tst.w	d6
	bne.s	.loop3					;repeat until no swap
	movea.l	(sp)+,a1				;drop the list
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
ReadTeamRecords						;Record Holders: read the records (ReadSRAM)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	move.l	#TeamRecBase,d0			;first user block
	move.l	#$80,d1					;all 8 user blocks
	movea.l	#recordbuf,a0			;record buffer
	jsr	(ReadSRAM).l				;read them
	movea.l	#recsort1,a1			;the goals sort list, or the saves one (bit 6)
	btst	#6,(sflags6).w
	beq.w	.0
	movea.l	#recsort2,a1
.0									;list chosen
	move.l	a1,-(sp)				;keep the list
	move.w	#1,d0					;start with users 1-7
	move.w	#6,d7					;7 users
.loop								;fill in users 1-7
	move.b	d0,(a1)+
	addq.w	#1,d0					;next user
	dbf	d7,.loop					;loop
	movea.l	(sp),a1					;sort list
	movea.l	#recordbuf,a0			;record buffer
.loop2								;bubble sort by the record value
	movea.l	(sp),a1					;sort list
	move.w	#5,d7					;6 pairs
	clr.w	d6						;no swap yet
.loop3								;compare a pair with the next
	move.b	(a1)+,d1				;this user
	ext.w	d1
	move.b	(a1),d2					;next user
	ext.w	d2
	asl.w	#4,d1					;16 bytes per user record
	asl.w	#4,d2
	move.b	0(a0,d1.w),d0			;urgoals: goals record
	move.b	0(a0,d2.w),d3			;next user's
	btst	#6,(sflags6).w			;bit 6: sort by saves instead
	beq.w	.1
	move.b	ursaves(a0,d1.w),d0
	move.b	ursaves(a0,d2.w),d3
.1									;values chosen
	cmp.b	d3,d0
	bge.w	.next					;in order
	move.b	(a1),d0					;this entry
	move.b	-1(a1),d1				;previous entry
	move.b	d0,-1(a1)				;swap them
	move.b	d1,(a1)
	st	d6							;swapped
.next								;in order or swapped
	dbf	d7,.loop3
	tst.w	d6						;any swap?
	bne.s	.loop2					;repeat until no swap
	movea.l	(sp)+,a1				;drop the list
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
