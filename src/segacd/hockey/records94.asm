;	HOCKEY.BIN $B348-$C85F (runtime $26348-$2785F): records94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Name entry and the Record Holders screen are the cartridge code. CD: the graphics come through
;	the pointer table ($47D0C ...), the screen setup sets / clears bit 5 of $FF800F (the sub CPU flag)
;	where the cartridge masks interrupts, and the goal and save record titles differ slightly.

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

TeamList	equ	$1B00C
ReadSRAM	equ	$22452
WriteSRAM	equ	$2246C
WriteNameLog	equ	$22622
ReadNameLog	equ	$2262E
CopyString	equ	$25818
AppendUserName	equ	$25DE8
AppendTeamName	equ	$260E0
ClearWinRecords	equ	$2A604
TeamLogoPalettes	equ	$2AF56
MenuWaitVblank	equ	$2C63A
SetupScreen	equ	$2E728
ExitStatsScreen	equ	$2E980
getpzjoy	equ	$2F2F0
ProcessInputWithRepeat	equ	$374BE
ReadJoy1	equ	$374F0
ReadJoy2	equ	$3750E
setVram	equ	$37B5A
dobitmap	equ	$387E2
DecompressGraphicsWithRemap	equ	$38946
eraser	equ	$38C06
Framer	equ	$38CA0
printsmallz	equ	$38D8C
printsmall	equ	$38D9E
printz	equ	$38F6E
print	equ	$38F80
PushNumberWidth	equ	$3919A
appstring	equ	$39208
printbigz	equ	$39258
AddSmallFont	equ	$393E8
setupIceRinkPal	equ	$3EC60
VBlank_SetOptions	equ	$400D0
orjoy	equ	$37460
DecompressGraphicsPlain	equ	$38958

	org	$26348

;	New in 94: user records. This file lets players enter their names and shows the Record
;	Holders screen with the win, goal and save records kept in save RAM.

NameEntryScreen						;"NAME ENTRY" screen for the user records (own vblank VBlank_SetOptions):
									;pick a name from the name log or enter a new one (NameLetterGrid ...
									;SkipOtherUserName). Called from UserNameEntry
	movem.l	d0-d7/a0-a6,-(sp)
;CD: no cartridge twin
	bclr.b	#$5,$FF800F.l
	move.w	#2,d4					;first free tile
	move.l	#VBlank_SetOptions,(VBint).l	;this screen's own vblank handler
	bclr.b	#dfok,(disflags).l		;display not ready
	bset.b	#dfng,(disflags).l		;no game drawing while the screen is built
	bclr.b	#df32c,(disflags).l		;32 cell flag off
	move.w	#0,$18D30.l				;plain scroll and the map / sprite table layout of the setup screens (CD:
									;the cartridge has (VSCRLPM).w)
	move.w	#$B400,(VSPRITES).l
	move.w	#$B800,(VmMAP3).l
	move.w	#5,(Map3col).l
	move.w	#$C000,(VmMAP2).l
	move.w	#6,(Map2col).l
	move.w	#$E000,(VmMAP1).l
	move.w	#6,(Map1col).l
	move.w	#0,d0
	jsr	(setVram).l
;CD: no cartridge twin
	bset.b	#$5,$FF800F.l
	jsr	(orjoy).l
	move.w	d4,(framercset).l
	movea.l	(FramerMapPtr).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l	;frame tiles
	dc.l	$91234567,$89ABCDEF		;remap table
	move.w	d4,(nameframechars).l	;name frame tiles
;CD: no cartridge twin
	movea.l	(FramerMapPtr).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l	;the same frame tiles again
	dc.l	$91234560,$89ABCDEF		;remap table
	move.w	d4,(smallfontchars).l
	jsr	(AddSmallFont).l
	jsr	(printz).l
	String	CC_Font1,0,0
	moveq	#$28,d0					;clear the text map
	moveq	#$1C,d1
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l
	jsr	(setupIceRinkPal).l
	jsr	(printz).l
	String	CC_Font2,0,0
;CD: no cartridge twin
	movea.l	(EASportsBGMapPtr).l,a0
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2
	adda.l	(a2)+,a0				;a0 = tile data
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#$1C,d3
	moveq	#$D,d5
	jsr	(dobitmap).l
;CD: no cartridge twin
	jsr	$36F72.l
	move.w	d4,(homepicchars).l		;tile base for the team logo
	addi.w	#$24,d4					;36 logo chars
	move.w	d4,(logobox1chars).l	;logo box tiles
;CD: no cartridge twin
	movea.l	(LogoBoxMapPtr).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,$18D40.l
	movea.l	(BigFontMapPtr).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$71234567,$89ABCDEF		;remap table
	jsr	(printz).l
	String	CC_Font1Pri,$1F,6
	move.w	(HomeTeam).l,d0			;team of this name entry (nameentryvis: 0 home, 1 visitors)
	tst.w	(nameentryvis).l		;which side?
	beq.w	.0
	move.w	(VisTeam).l,d0
.0									;team chosen: print its name centred over the logo
	movea.l	#TeamList,a1
	asl.w	#2,d0
	movea.l	(a1,d0.w),a1
	adda.w	Teamname(a1),a1			;team Strings: the city
	move.w	(a1),d0
	subi.w	#2,d0					;half the name length left of column $1F
	lsr.w	#1,d0
	sub.w	d0,(printx).l
	jsr	(print).l
	jsr	(printz).l
	String	CC_Font1Pri,$1B,7
	move.w	#8,d0					;8 x 8 frame round the logo
	move.w	#8,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	CC_Font1Pal3Pri,$1C,8
	move.w	(HomeTeam).l,d3			;the same team for the logo
	tst.w	(nameentryvis).l		;which side?
	beq.w	.1
	move.w	(VisTeam).l,d3
.1									;team chosen: draw its logo
	asl.w	#2,d3
;CD: no cartridge twin
	movea.l	(TeamLogoBitmapsPtr).l,a0
	movea.l	(a0,d3.w),a0			;this team's logo
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2
	adda.l	(a2)+,a0				;a0 = tile data
	asl.w	#3,d3					;32 bytes of logo palette per team
	movea.l	#TeamLogoPalettes,a0
	subi.w	#$40,d3					;less two teams' palettes
	adda.w	d3,a0					;a0 = logo palette
	adda.l	(a2)+,a1				;a1 = map data
	move.w	#6,d3
	move.w	#6,d2
	clr.w	d0
	clr.w	d1
	move.w	#4,d5
	move.w	(homepicchars).l,d4
	jsr	(dobitmap).l
	jsr	(printz).l
	String	CC_Font1Pri,2,0
	move.w	#$24,d0					;frame round the whole screen
	move.w	#6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	CC_Font1Pri,$A,2,'NAME  ENTRY'
	bsr.w	ReadNameLog
	clr.w	(namelogarrows).l		;no log arrows yet
	move.w	#1,(namelogsel).l		;start on log slot 1
	clr.w	d0
	bsr.w	SkipOtherUserName		;move off the other user's name if it is there
	movea.l	#nameentrybuf,a1		;load the selected name for editing
	bsr.w	GetLogName				;copy the log name
	bsr.w	PrintNameLog			;print the name log
	jsr	(printz).l
	String	CC_Font1Pri,7,6,'Name Log'
	move.w	#$18,(palcount).l		;fade in over $18 frames
	bclr.b	#dfng,(disflags).l		;display ready
	clr.w	d4						;d4 = cursor position in the name (0-11)
	bsr.w	SyncLetterCursor		;d5 = grid letter under the first character
	bsr.w	PrintNameCursor
	bsr.w	LetterGridPos			;printx / printy of grid letter d5
.2									;(not branched to)
	move.w	(printx).l,-(sp)		;frame the selected grid letter
	move.w	(printy).l,-(sp)
	jsr	(NameEntryFramer).l
	move.w	(sp)+,(printy).l
	addi.w	#1,(printy).l			;inside the frame
	move.w	(sp)+,(printx).l
	addi.w	#1,(printx).l
	bsr.w	PrintCurLetter			;print the letter
	move.w	#1,(cursoron).l			;start in edit mode; NameLetterGrid flips it to log mode
	bsr.w	NameLetterGrid			;flip to log mode
	clr.w	d0						;d0 = 0: put the name cursor on position 0
	bra.w	.11
.loop								;each pass: redraw the name and prompt
	bsr.w	GetNameLength			;d0 = name length
	jsr	(printz).l
	String	CC_Font1Pri,5,$12
	tst.w	(cursoron).l			;log mode: no name field or prompt
	beq.w	.3
	movea.l	#nameentrybuf,a1
	bsr.w	PrintNameField			;print it
	bsr.w	PrintNamePrompt
.3									;then move the ] [ arrows if the log selection changed
	bsr.w	MoveLogArrows
.loop2								;wait for a press
	move.w	(Vcount).l,d0
.loop3								;wait for the next vblank
	cmp.w	(Vcount).l,d0
	beq.w	.loop3
	movem.w	d1,-(sp)
	move.w	(cont1team).l,d1		;the pad of this team: controller 1 if it is on this side
	subi.w	#1,d1					;0 home, 1 visitors
	cmp.w	(nameentryvis).l,d1
	movem.w	(sp)+,d1
	beq.w	.input					;controller 1 owns this team
	jsr	(ReadJoy2).l				;otherwise controller 2
	tst.w	d1
	beq.w	.loop2					;nothing pressed
	bra.w	.5
.input								;controller 1's team: read pad 1
	jsr	(ReadJoy1).l
	tst.w	d1						;anything pressed?
	beq.w	.loop2
.5									;a button pressed
	btst	#7,d1
	bne.w	.14
	tst.w	(cursoron).l
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
	add.w	d0,(namelogsel).l
.loop4								;wrap into slots 1-7
	cmpi.w	#7,(namelogsel).l
	ble.w	.8
	move.w	#1,(namelogsel).l
.8									;at or below 7
	tst.w	(namelogsel).l
	bne.w	.9
	move.w	#7,(namelogsel).l
.9									;slot in range: skip the other user's name
	bsr.w	SkipOtherUserName
	beq.w	.loop4					;that slot is the other user: move on
	movea.l	#nameentrybuf,a1
	bsr.w	GetLogName				;copy the log name
	tst.w	(cursoron).l			;edit mode: show the letters again
	bne.w	.10
	jsr	(NameEntryHelp).l			;log mode: the help text
	bra.w	.loop
.10									;edit mode: clear the cursor and the old grid frame
	jsr	(printz).l
	String	CC_Font1Pri,4,$13
	add.w	d4,(printx).l
	jsr	(printz).l
	String	'   '
	bsr.w	LetterGridPos			;printx / printy of grid letter d5
	moveq	#1,d2
	move.w	(printx).l,-(sp)
	move.w	(printy).l,-(sp)
	jsr	(eraser).l					;erase the frame
	move.w	(sp)+,(printy).l
	addi.w	#1,(printy).l
	move.w	(sp)+,(printx).l		;inside the frame
	addi.w	#1,(printx).l
	bsr.w	PrintCurLetter			;print the letter
	bsr.w	SyncLetterCursor		;d5 = grid letter under the cursor
	move.w	d4,d0					;d0 = -d4: the cursor goes back to position 0
	neg.w	d0
	bra.w	.11						;(branches to the next line)
.11									;move the name cursor by d0
	add.w	d4,d0
	cmpi.w	#$B,d0
	bhi.w	.loop					;outside 0-11: ignore
	move.w	d0,d4					;new cursor position
	bsr.w	PrintNameCursor			;move the name cursor
	movea.l	#nameentrybuf,a0
	clr.w	d0
	cmpi.b	#$2D,(a0,d4.w)			;a "-" keeps the grid letter where it is
	beq.w	.12
	move.b	(a0,d4.w),d0			;the letter
	ext.w	d0
	bsr.w	FindLetter				;grid index of the letter under the cursor
	sub.w	d5,d0					;d0 = that index - d5, so .12 lands on it
.12									;move the grid cursor by d0
	add.w	d5,d0
	cmpi.w	#$1D,d0					;outside the 30 letters: ignore
	bhi.w	.loop
	move.w	d0,-(sp)				;erase the frame of the old letter
	bsr.w	LetterGridPos			;printx / printy of grid letter d5
	moveq	#1,d2
	move.w	(printx).l,-(sp)
	move.w	(printy).l,-(sp)
	jsr	(eraser).l
	move.w	(sp)+,(printy).l
	addi.w	#1,(printy).l
	move.w	(sp)+,(printx).l		;inside the frame
	addi.w	#1,(printx).l
	bsr.w	PrintCurLetter			;print the letter
	move.w	(sp)+,d5				;d5 = new grid letter
	bsr.w	LetterGridPos			;its printx / printy
	move.w	(printx).l,-(sp)
	move.w	(printy).l,-(sp)
	tst.w	(cursoron).l			;edit mode?
	beq.w	.13						;log mode: no frame
	jsr	(NameEntryFramer).l
.13									;frame drawn (edit mode only): print the letter
	move.w	(sp)+,(printy).l
	addi.w	#1,(printy).l			;inside the frame
	move.w	(sp)+,(printx).l
	addi.w	#1,(printx).l			;inside the frame
	bsr.w	PrintCurLetter
	movea.l	#nameentrybuf,a0
	movea.l	#LetterGrid,a1			;the chosen letter goes into the name at the cursor
	move.b	(a1,d5.w),d0			;the letter
	move.b	d0,(a0,d4.w)			;into the name
	bra.w	.loop
.14									;start: save the name and leave
	bsr.w	StoreUserName			;save it in the name log
	movem.l	(sp)+,d0-d7/a0-a6
	rts
NameLetterGrid						;Name entry: the letter grid ("D-Pad to a letter.", "C to select letter.",
									;"A to go back.")
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	CC_Font1Pri,1,$14
	move.w	#$16,d0
	move.w	#7,d1
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l					;clear the help area
	bchg.b	#0,(cursoron+1).l		;flip between edit and log mode
	bne.w	.1						;now log mode: show the help instead
	jsr	(printz).l
	String	CC_Font1Pri,$19,$11
	movea.l	#LetterGrid,a0			;print the 5 rows of 6 letters
	moveq	#4,d0					;5 rows
.loop								;each row
	moveq	#5,d1					;6 letters
	movea.l	#mesarea,a1
	move.w	#$E,(a1)+				;String of 6 letters with spaces: 12 bytes + header
.loop2								;letter and a space
	move.b	(a0)+,(a1)+
	move.b	#$20,(a1)+
	dbf	d1,.loop2					;next letter
	movea.l	#$17EF2,a1				;CD: the cartridge has #(mesarea-M68K_RAM)
	jsr	(print).l
	addi.w	#2,(printy).l			;two rows down
	subi.w	#$C,(printx).l			;back to the row start
	dbf	d0,.loop					;next row
	jsr	(printz).l
	String	CC_Font2,1,$14
	moveq	#$16,d0
	moveq	#7,d1
	jsr	(Framer).l					;draw the frame
	jsr	(printz).l
	String	CC_Font1Pri,2,$15,'D-Pad to a letter.'
	move.w	#2,(printx).l
	addi.w	#1,(printy).l
	move.w	(printx).l,-(sp)
	jsr	(printz).l
	String	'C to select letter.'
	move.w	(sp),(printx).l
	addi.w	#1,(printy).l
	jsr	(printz).l
	String	'A to go back.'
	move.w	(sp),(printx).l
	addi.w	#1,(printy).l
	jsr	(printz).l
	String	'B to cancel.'
	move.w	(sp)+,(printx).l
	addi.w	#1,(printy).l
.0									;(not branched to)
	jsr	(printz).l
	String	'START when done.'
.x									;pop the registers saved at entry
	movem.l	(sp)+,d0-d7/a0-a6
.x2									;(not branched to)
	rts
.1									;log mode: reload the name, clear the field area, frame the help box
	movea.l	#nameentrybuf,a1
.2									;(not branched to)
	bsr.w	GetLogName				;copy the log name
	move.w	#0,(printx).l
.3									;(not branched to)
	move.w	#$F,(printy).l
	move.w	#$28,d0
.4									;(not branched to)
	move.w	#$D,d1
	move.w	#$7FF,d2				;blank char
.5									;(not branched to)
	jsr	(eraser).l
.6									;(not branched to)
	jsr	(printz).l
	String	CC_Font2,1,$14
	moveq	#$16,d0
	moveq	#7,d1
.7									;(not branched to)
	jsr	(Framer).l					;draw the frame
	bsr.w	NameEntryHelp
	bra.w	.x
NameEntryHelp						;Name entry help text ("D-Pad up/down to move arrows.", "Press START to
									;select name.", "Press B to edit.")
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	CC_Font1Pri,2,$15,'D-Pad up/down to    '
	jsr	(printz).l
	String	CC_Font1Pri,2,$16,'move arrows.        '
	move.w	#2,(printx).l
	move.w	(printx).l,-(sp)
	addi.w	#1,(printy).l
	jsr	(printz).l
	String	'Press START to      '
	addi.w	#1,(printy).l
	move.w	(sp),(printx).l
	jsr	(printz).l
	String	'select name.        '
	addi.w	#1,(printy).l
	move.w	(sp)+,(printx).l
	jsr	(printz).l
	String	'Press B to edit.    '
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PrintNamePrompt						;Name entry: "Enter new name:" for an empty name log slot namelogsel, else
									;"Select or replace:"
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(namelogsel).l,d0
	mulu.w	#$C,d0					;12 bytes per name
	movea.l	#namelog,a0
	movea.l	#EnterNameTxt,a1
	tst.b	(a0,d0.w)				;empty slot: "Enter new name:"
	beq.w	.0
	movea.l	#SelectNameTxt,a1
.0									;text chosen: print it
	jsr	(print).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SyncLetterCursor					;Name entry: the letter grid cursor d5 = the grid index of the current
									;letter (FindLetter), 0 when it is not in the grid
	movem.l	d0-d4/a0-a6,-(sp)
	move.b	(nameentrybuf).l,d0		;first letter of the name
	bsr.w	FindLetter				;d0 = its grid index
	cmpi.w	#$1E,d0					;not in the grid: cursor on the first letter
	blt.w	.0
	clr.w	d5
	bra.w	.x
.0									;letter found: d5 = its index
	move.w	d0,d5
	movea.l	#LetterGrid,a0
	move.b	(a0,d5.w),(nameentrybuf).l	;unknown letters are turned into the first grid letter
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d4/a0-a6
	rts
FindLetter							;d0 = index of letter d0 in LetterGrid, $1E when not found
	movem.l	d1-d3/a0-a6,-(sp)
	movea.l	#LetterGrid,a0
	move.b	d0,d1
	clr.w	d0
	move.w	#$1E,d3					;31 tries
.loop								;compare with each grid letter
	cmp.b	(a0,d0.w),d1
	beq.w	.x
	addi.w	#1,d0
	dbf	d3,.loop					;all 31 tried: not found
	move.w	#$1E,d0					;not found
.x									;exit: restore the registers
	movem.l	(sp)+,d1-d3/a0-a6
	rts
PrintNameCursor						;Name entry: the " < " cursor
	jsr	(printz).l
	String	CC_Font1Pri,4,$13
	add.w	d4,(printx).l
	tst.w	(cursoron).l			;cursor on?
	beq.w	rtsNameCursor			;cursor off: print nothing
	jsr	(printz).l
	String	' < '
rtsNameCursor						;(the shared rts here)
	rts
PrintCurLetter						;Name entry: print grid letter d5 (with the cursor on, cursoron)
	tst.w	(cursoron).l			;cursor on?
	beq.w	rtsNameCursor
	movea.l	#ThreeStars,a1
	move.w	#4,(a1)					;String of 1 letter (length 4)
	move.b	#0,3(a1)
	movea.l	#LetterGrid,a0
	move.b	(a0,d5.w),d0			;the letter
	move.b	d0,2(a1)
	jmp	(print).l
LetterGridPos						;Name entry: printx / printy of grid letter d5 (6 letters a row, 2 cells
									;apart); d0 / d1 = 3 x 3 box
	jsr	(printz).l
	String	CC_Font1Pri,$18,$10
	move.w	d5,d0
	ext.l	d0						;clear the high word
	divu.w	#6,d0					;row = index / 6, column = remainder
	asl.w	#1,d0					;rows are 2 apart
	add.w	d0,(printy).l
	swap	d0
	asl.w	#1,d0					;columns are 2 apart
	add.w	d0,(printx).l
	moveq	#3,d0
	moveq	#3,d1
	rts
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
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(namelength).l,-(sp)
	move.w	(namelogsel).l,-(sp)
	jsr	(printz).l
	String	CC_Font1Pri,5,8
	move.w	#6,d7					;7 log slots
	move.w	#1,(namelogsel).l
	movea.l	#TempBuffer,a1
.loop								;print each slot's name on its own row
	bsr.w	GetLogName				;copy the log name
	move.w	(printx).l,-(sp)
	bsr.w	PrintNameField			;print it
	move.w	(sp)+,(printx).l
	addi.w	#1,(printy).l
	addi.w	#1,(namelogsel).l
	dbf	d7,.loop					;loop
	move.w	(sp)+,(namelogsel).l	;put back the caller's selection
	move.w	(sp)+,(namelength).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
MoveLogArrows						;Name entry: when the name log selection namelogsel changed, erase the old
									;] [ arrows and print them at the new row (PrintLogArrows)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(namelogsel).l,d0
	cmp.w	(namelogarrows).l,d0	;arrows already there?
	beq.w	.x						;same row: nothing to do
	movea.l	#LogArrowsClrTxt,a1
	bsr.w	PrintLogArrows			;erase the old ones
	movea.l	#LogArrowsTxt,a1
	bsr.w	PrintLogArrows			;print the new ones
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PrintLogArrows						;Name entry: print the two arrow Strings at a1 on name log row
									;namelogarrows, then namelogarrows = namelogsel
	tst.w	(namelogarrows).l
	beq.w	.0						;no arrows drawn yet: nothing to erase
	jsr	(printz).l
	String	CC_Font1Pri,3,8
	move.w	(namelogarrows).l,d0
	subi.w	#1,d0					;rows from 1
	add.w	d0,(printy).l
	move.l	a1,-(sp)
	jsr	(print).l
	movea.l	(sp)+,a1
	adda.w	(a1),a1					;the second String (right arrow) follows the first
	move.w	#$12,(printx).l
	jsr	(print).l
.0									;old arrows handled: remember the new row
	move.w	(namelogsel).l,(namelogarrows).l
	rts
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
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$B,d3					;at most 12 characters
	movea.l	#nameentrybuf,a0
	clr.w	(namelength).l
.loop								;check each character
	cmpi.b	#$2D,(a0)				;a '-' ends the name
	beq.w	.x
	tst.b	(a0)+					;so does a 0
	beq.w	.x
	addi.w	#1,(namelength).l
	dbf	d3,.loop					;next character
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PrintNameField						;Name entry: print the 12 character name field from a1, '-' past the
									;length namelength
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#ThreeStars,a0
	move.w	(namelength).l,d0		;(d0 unused)
	move.w	#0,d3					;character index
	move.w	#$E,(a0)+				;String of 12 characters
.loop								;each character of the field
	move.b	(a1,d3.w),d1			;the character
	cmp.w	(namelength).l,d3		;past the name?
	blt.w	.0						;inside the name: print it
	move.b	#$2D,d1
.0									;past the name: '-'
	move.b	d1,(a0)+
	addi.w	#1,d3					;next character
	cmpi.w	#$C,d3					;12 characters
	blt.w	.loop
	movea.l	#ThreeStars,a1
	jsr	(print).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
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
	move.w	(framercset).l,-(sp)	;save the frame tiles
	move.w	(nameframechars).l,(framercset).l	;use the name entry frame tiles
	jsr	(Framer).l					;draw the frame
	move.w	(sp)+,(framercset).l
	rts
GetLogName							;Copy name log entry namelogsel to a1 ('-' for
									;empty), namelength = its length
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#namelog,a0
	move.w	(namelogsel).l,d2
	mulu.w	#$C,d2					;12 bytes per name
	move.w	#0,(namelength).l
	move.w	#$B,d3					;12 characters
.loop								;each character
	move.b	(a0,d2.w),d0
	beq.w	.0						;0 = unused character
	bra.w	.1						;a letter: copy it
.0									;empty: '-' and not counted
	move.b	#$2D,d0
	subi.w	#1,(namelength).l
.1									;character ready
	move.b	d0,(a1)+
	addi.w	#1,(namelength).l
	addi.w	#1,d2					;next character
	dbf	d3,.loop					;loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts
StoreUserName						;Name entry: store the name in save RAM
									;(WriteNameRecord, MakeSRAMChecksum)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#namelog,a0
	move.w	(namelogsel).l,d0
	mulu.w	#$C,d0					;12 bytes per name
	adda.w	d0,a0
	movea.l	#nameentrybuf,a1
	move.w	#$B,d4					;12 characters
.loop								;compare the entered name with the logged one
	cmpi.b	#$2D,(a1)
	bne.w	.0
	move.b	#0,(a1)					;'-' means an unused character: 0 in the log
.0									;character ready
	move.b	(a1)+,d1
	cmp.b	(a0)+,d1				;same as the log?
	bne.w	.1						;a difference: store the new name
	dbf	d4,.loop					;next character
	bra.w	.3						;same name: nothing to write
.1									;new name: copy it into the log slot
	movea.l	#namelog,a0
	move.w	(namelogsel).l,d0
	mulu.w	#$C,d0					;12 bytes per name
	adda.w	d0,a0
	movea.l	#nameentrybuf,a1
	move.w	#$B,d4					;12 characters
.loop2								;copy 12 characters
	move.b	(a1)+,d1
	cmpi.b	#$2D,d1					;'-'?
	bne.w	.2
	move.b	#0,d1					;'-' becomes 0
.2									;character ready
	move.b	d1,(a0)+
	dbf	d4,.loop2					;next character
	bsr.w	WriteNameLog			;save the log, then drop the old name's records
	jsr	(WriteNameRecord).l			;clear the old name's records
.3									;name stored or unchanged: this side's user number
	movea.l	#homeuser,a5
	tst.w	(nameentryvis).l
	beq.w	.4
	movea.l	#awayuser,a5
.4									;user field chosen
	tst.b	(nameentrybuf).l		;empty name?
	bne.w	.5						;a name was entered
	clr.w	(namelogsel).l			;empty name: no user (0)
.5									;user number = log slot
	move.w	(namelogsel).l,(a5)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
WriteNameRecord						;Write the name record (ReadSRAM / WriteSRAM)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$2D7,d7				;$2D8 player records of 4 bytes
	move.l	#0,d0					;first record
	move.l	#4,d1
	movea.l	#recordbuf,a0
	move.w	(namelogsel).l,d6		;d6 = the slot whose name was replaced
.loop								;each player record: clear the old holder
	clr.w	d5
	jsr	(ReadSRAM).l
	cmp.b	pruser(a0),d6			;the record holder?
	bne.w	.0
	clr.b	pruser(a0)
	st.b	d5
.0									;proppuser: the other user
	cmp.b	proppuser(a0),d6		;is it this slot?
	bne.w	.1
	clr.b	proppuser(a0)
	st.b	d5
.1									;write back only when changed
	tst.w	d5
	beq.w	.2
	jsr	(WriteSRAM).l
.2									;next record
	addi.l	#4,d0					;next record
	dbf	d7,.loop					;loop
	move.w	#NumTeams-1,d7			;each team's crowd record block
	move.l	#CrowdRecBase,d0		;first block
	move.l	#$10,d1
	movea.l	#recordbuf,a0
	move.w	(namelogsel).l,d6
.loop2								;clear the old user from each crowd record
	clr.w	d5						;(holder and opponent of the goals, saves and peak records)
	jsr	(ReadSRAM).l
	cmp.b	crgoalsuser(a0),d6		;goals record holder?
	bne.w	.3
	clr.b	crgoalsuser(a0)
	st.b	d5
.3									;goals holder done: goals opponent
	cmp.b	crgoalsoppuser(a0),d6	;goals record opponent?
	bne.w	.4
	clr.b	crgoalsoppuser(a0)
	st.b	d5
.4									;saves holder
	cmp.b	crsavesuser(a0),d6		;saves record holder?
	bne.w	.5
	clr.b	crsavesuser(a0)
	st.b	d5
.5									;saves opponent
	cmp.b	crsavesoppuser(a0),d6	;saves record opponent?
	bne.w	.6
	clr.b	crsavesoppuser(a0)
	st.b	d5
.6									;peak holder
	cmp.b	crpeakuser(a0),d6		;peak record holder?
	bne.w	.7
	clr.b	crpeakuser(a0)
	st.b	d5
.7									;peak opponent
	cmp.b	crpeakoppuser(a0),d6	;peak record opponent?
	bne.w	.8
	clr.b	crpeakoppuser(a0)
	st.b	d5
.8									;write back only when changed
	tst.w	d5
	beq.w	.9
	jsr	(WriteSRAM).l
.9									;next block
	addi.l	#CrowdRecBytes,d0		;next block
	dbf	d7,.loop2					;next team
	move.l	#TeamRecBase,d0			;and wipe the new slot's own 16 byte user record
	move.w	(namelogsel).l,d3
	asl.w	#4,d3
	ext.l	d3
	add.l	d3,d0					;its user record
	move.l	#$10,d1
	movea.l	#recordbuf,a0
	jsr	(ReadSRAM).l
	move.l	a0,-(sp)
	move.w	#$F,d3
.loop3								;clear 16 bytes
	clr.b	(a0)+
	dbf	d3,.loop3					;next byte
	movea.l	(sp)+,a0
	jsr	(WriteSRAM).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

UserNameEntry						;With user records on (OptUserRec 0): the name entry (NameEntryScreen) for
									;the pads in use. Called from Opening2
	tst.w	(OptUserRec).l
	bne.w	.x						;user records off: no name entry
	clr.w	(homeuser).l			;no home user yet
	clr.w	(awayuser).l			;no away user yet
	tst.w	(cont1team).l			;controller 1 on a team: enter its name
	beq.w	.0
	move.w	(cont1team).l,(nameentryvis).l
	subi.w	#1,(nameentryvis).l		;nameentryvis = 0 home, 1 visitors
	jsr	(NameEntryScreen).l
.0									;controller 1 done or unused: now controller 2
	tst.w	(cont2team).l
	beq.w	.x						;controller 2 not on a team
	movem.w	d0,-(sp)
	move.w	(cont1team).l,d0
	cmp.w	(cont2team).l,d0		;same as controller 2?
	movem.w	(sp)+,d0
	beq.w	.x						;both pads on the same team: one name only
	move.w	(cont2team).l,(nameentryvis).l
	subi.w	#1,(nameentryvis).l
	jsr	(NameEntryScreen).l
.x									;exit (also the end of the code above)
	rts
SkipOtherUserName					;Name entry: step the selection namelogsel past the name the other pad
									;picked (homeuser / awayuser), in the direction on the stack
	movem.w	d0,-(sp)				;d0 = the step direction (passed on the stack)
	move.w	(awayuser).l,d0			;the other side's user
	tst.w	(nameentryvis).l		;which side?
	beq.w	.0
	move.w	(homeuser).l,d0			;visitors: the home user
.0									;other user chosen
	cmp.w	(namelogsel).l,d0
	bne.w	.x						;not his slot: keep it
	move.w	#1,d0					;his slot: step past it (+1, or -1 when the stack word is negative)
	tst.w	(sp)
	bpl.w	.1
	move.w	#$FFFF,d0
.1									;direction chosen
	add.w	d0,(namelogsel).l
	clr.w	d0						;d0 = 0 tells the caller to check the slot again
.x									;exit: restore the registers
	movem.w	(sp)+,d0
	rts
RecordHoldersScreen					;"Record Holders" menu item (menu lists): the save RAM record holders
									;(PrintRecordTitles ... ReadTeamRecords)
	move.w	#0,d0					;setup screen with the frame layout
	move.w	#$1A,d1
	jsr	(SetupScreen).l
	jsr	(printz).l
	String	CC_Font2Pri,1,1
;CD: no cartridge twin
	movea.l	(NHLLogoMapPtr).l,a0
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2
	adda.l	(a2)+,a0				;a0 = tile data
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d1
	clr.w	d0
	moveq	#6,d2
	move.w	#6,d3
	moveq	#8,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	CC_Font2Pri,'!',1
;CD: no cartridge twin
	movea.l	(NHLPALogoMapPtr).l,a0
	movea.l	a0,a1					;a1 = map header
.0									;(not branched to)
	movea.l	a0,a2
	adda.l	(a2)+,a0				;a0 = tile data
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d1
	clr.w	d0
	moveq	#6,d2
	move.w	#6,d3
	moveq	#0,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	CC_Font3Pri,$B,1
	move.w	#$12,d0
	move.w	#7,d1
	jsr	(Framer).l					;draw the frame
	jsr	(printbigz).l
	String	CC_Font3Pri,$E,2,'Record',CC_Font3Pri,$D,5,'Holders',CC_Font3Pri,1,9
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,6,3,5,8,CC_SetFont,1,'Name',CC_SetFont,0
	bsr.w	ReadNameLog
	clr.w	(TempWord1).l			;page 0: win records
	bclr.b	#6,(sflags6).l			;the goals sort (sflags6 bit 6 clear)
	bsr.w	ReadTeamRecords
	bset.b	#6,(sflags6).l			;then the saves sort
	bsr.w	ReadTeamRecords
	bsr.w	CalcWinPercents
	bsr.w	PrintRecordTitles		;first page: titles and win records
	bsr.w	PrintWinRecords
.loop								;each frame: read the pad
	jsr	(MenuWaitVblank).l			;wait for the next frame
	jsr	(getpzjoy).l				;read the pads
	jsr	(ProcessInputWithRepeat).l
	btst	#7,d3					;start?
	beq.w	.1						;start leaves the screen
	jmp	(ExitStatsScreen).l			;back to the stats menu
.1									;page 0: A + C clears the win records
	tst.w	(TempWord1).l			;page 0?
.2									;(not branched to)
	bne.w	.right
	btst	#6,d3					;A?
	beq.w	.right
.3									;(not branched to)
	btst	#5,d3					;C?
	beq.w	.right
	bsr.w	ClearWinRecords			;clear the win records
	bsr.w	CalcWinPercents
.show								;(not branched to)
	bsr.w	PrintWinRecords			;print them again
	bra.w	.loop
.right								;right: next page (up to page 2)
	btst	#3,d1
	beq.w	.left
	cmpi.w	#2,(TempWord1).l		;last page?
	beq.w	.loop
	bsr.w	ClearRecordArea
	addi.w	#1,(TempWord1).l		;next page
	bsr.w	PrintRecordTitles
	bsr.w	PrintRecordPage
	bra.w	.loop
.left								;left: previous page
	btst	#2,d1
	beq.w	.loop
	tst.w	(TempWord1).l			;first page?
	beq.w	.loop
	bsr.w	ClearRecordArea
	subi.w	#1,(TempWord1).l		;previous page
	bsr.w	PrintRecordTitles
	bsr.w	PrintRecordPage
	bra.w	.loop
	dc.b	$4E						;N
	dc.b	$75						;u
PrintRecordPage						;Record Holders: print one page
									;(TempWord1 = page: 0 wins, 1 goals, 2 saves)
	tst.w	(TempWord1).l
	beq.w	PrintWinRecords			;page 0: wins
	bra.w	PrintPlayerRecords		;pages 1 and 2
PrintRecordTitles					;Record Holders: the record titles (WinRecTitles, GoalRecTitles,
									;SaveRecTitles)
	movea.l	#WinRecTitles,a1
	tst.w	(TempWord1).l			;page 0: the win titles
	beq.w	.0
	movea.l	#SaveRecTitles,a1
	cmpi.w	#2,(TempWord1).l
	beq.w	.0						;page 2: the saves titles
	movea.l	#GoalRecTitles,a1
.0									;page titles chosen
	jsr	(printsmall).l				;print them
	rts
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
;CD: no cartridge twin
	dc.b	$52
	dc.b	$F8,6,3,$12,8,$F9,1
	dc.b	$47						;G
	dc.b	$6F						;o
	dc.b	$61						;a
	dc.b	$6C						;l
	dc.b	$73						;s
	dc.b	$20,$20,$20,$20,$20,$20,$20
;CD: no cartridge twin
	dc.b	'  Teams'
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
;CD: no cartridge twin
	dc.b	$52
	dc.b	$F8,6,3,$12,8,$F9,1
	dc.b	$53						;S
	dc.b	$61						;a
	dc.b	$76						;v
	dc.b	$65						;e
	dc.b	$73						;s
	dc.b	$20,$20,$20,$20,$20,$20,$20
;CD: no cartridge twin
	dc.b	'  Teams'
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
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,2,2,$A,CC_SetFont,0
	move.w	#6,d7					;7 rows
	movea.l	#winsort,a0				;users in win order
	movea.l	#winpcts,a2
	movea.l	#recordbuf,a5
.loop								;each row: the user in sort order
	move.w	#2,(printx).l
	move.b	(a0)+,d0
	ext.w	d0
	move.b	(a2,d0.w),d5			;his win %
	asl.w	#4,d0					;16 bytes per user record
	move.b	urgames(a5,d0.w),d4		;games, big endian
	lsl.w	#8,d4
	move.b	urgames+1(a5,d0.w),d4
	move.w	d4,-(sp)
	move.b	urties(a5,d0.w),d4		;ties, big endian
	lsl.w	#8,d4
	move.b	urties+1(a5,d0.w),d4
	move.w	d4,(recties).l
	move.b	urwins(a5,d0.w),d4		;wins, big endian
	lsl.w	#8,d4
	move.b	urwins+1(a5,d0.w),d4
	move.w	d4,(recwins).l
	add.w	(recties).l,d4			;losses = games - wins - ties
	sub.w	(sp),d4
	neg.w	d4
	move.w	d4,(reclosses).l
	move.w	(sp)+,d4
	tst.w	d4						;no games: "( )" instead
	beq.w	.0
	bsr.w	PrintRecordName
	move.w	#$13,(printx).l			;win %, wins, losses and ties columns
	move.w	d0,-(sp)
	move.w	d5,d0
	move.w	#3,d1					;3 digits
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l				;print it
	move.w	#$1A,(printx).l
	move.w	(recwins).l,d0
	move.w	#4,d1					;4 digits
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l				;print it
	move.w	#$1F,(printx).l
	move.w	(reclosses).l,d0
	move.w	#4,d1					;4 digits
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l				;print it
	move.w	#$24,(printx).l
	move.w	(recties).l,d0
	move.w	#3,d1					;3 digits
	jsr	(PushNumberWidth).l
	move.w	(sp)+,d0
	bra.w	.1
.0									;user has no games
	movea.l	#RecParenTxt,a1
.1									;print the last part
	jsr	(printsmall).l
	addi.w	#2,(printy).l			;rows are 2 apart
	dbf	d7,.loop					;next row
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ClearRecordArea						;Record Holders: erase the record rows ($28 x $12), keeping printx /
									;printy / printm
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(printx).l,-(sp)
	move.w	(printy).l,-(sp)
	move.w	(printm).l,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,2,0,$A
	move.w	#$28,d0
	move.w	#$12,d1
	jsr	(eraser).l
	move.w	(sp)+,(printm).l
	move.w	(sp)+,(printy).l
	move.w	(sp)+,(printx).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PrintPlayerRecords					;Record Holders: the rows of the other page (PrintRecordName)
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,2,2,$A,CC_SetFont,0
	move.w	#6,d7					;7 rows
	movea.l	#recsort1,a0			;page 1: the goals sort
	cmpi.w	#1,(TempWord1).l
	beq.w	.0
	movea.l	#recsort2,a0
.0									;sort list chosen
	movea.l	#recordbuf,a2
.loop								;each row
	move.w	#2,(printx).l
	move.b	(a0)+,d0
	ext.w	d0
	asl.w	#4,d0					;16 bytes per user record
	move.b	(a2,d0.w),d5			;goals record, or the saves one on page 2
	cmpi.w	#1,(TempWord1).l
	beq.w	.1
	move.b	ursaves(a2,d0.w),d5
.1									;record value chosen
	tst.b	d5
	beq.w	.none					;no record: "( )"
	bsr.w	PrintRecordName
	move.w	#$12,(printx).l
	move.w	d0,-(sp)
	cmpi.w	#1,(TempWord1).l		;page 1?
	bne.w	.2						;page 2: saves
	move.b	(a2,d0.w),d0
	bra.w	.3
.2									;page 2: the saves value
	move.b	ursaves(a2,d0.w),d0
.3									;value chosen: print it
	andi.w	#$FF,d0
	move.w	#3,d1					;3 digits
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l				;print it
	move.w	(sp)+,d0
	move.w	#$19,(printx).l
	movea.l	#RecHolderByTxt,a1
	movea.l	#mesarea,a3
	bsr.w	CopyString
	move.w	d0,-(sp)
	cmpi.w	#1,(TempWord1).l		;page 1?
	bne.w	.4						;page 2: the saves team
	move.b	urgoalsteam(a2,d0.w),d0
	bra.w	.5
.4									;page 2: the saves team
	move.b	ursavesteam(a2,d0.w),d0
.5									;team chosen
	andi.w	#$FF,d0
	movea.l	#mesarea,a1
	bsr.w	AppendTeamName			;append the team name
	movea.l	#RecHolderVsTxt,a1
	movea.l	#mesarea,a3
	jsr	(appstring).l
	movea.l	#mesarea,a1
	move.w	(sp)+,d0
	cmpi.w	#1,(TempWord1).l		;page 1?
	bne.w	.6						;page 2: the saves opponent
	move.b	urgoalsopp(a2,d0.w),d0
	bra.w	.7
.6									;page 2: the saves opponent
	move.b	ursavesopp(a2,d0.w),d0
.7									;opponent chosen
	andi.w	#$FF,d0
	bsr.w	AppendTeamName			;append the team name
	bra.w	.print
.none								;no record: "( )"
	movea.l	#RecParenTxt,a1
.print								;print the row
	jsr	(printsmall).l
	addi.w	#2,(printy).l
	dbf	d7,.loop					;loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts
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
	addi.w	#7,d7
	addi.w	#$30,d7
	movea.l	#mesarea,a1
	move.w	#6,(a1)
	move.b	d7,2(a1)				;row digit
	move.b	#$2E,3(a1)
	move.b	#$20,4(a1)
	move.b	#0,5(a1)
	jsr	(printsmall).l				;print it
	move.w	(sp)+,d7
	move.b	-1(a0),d2				;user number of this row
	ext.w	d2
	movea.l	#mesarea,a1
	bclr.b	#7,(sflags6).l			;bit 7 clear: AppendUserName does not trim
	bsr.w	AppendUserName
	jmp	(printsmall).l				;print the name
CalcWinPercents						;Record Holders: for the 8 user record blocks at recordbuf, the win %
									;(winpcts), games (wingames) and ties (winties), then sort the rows
									;(winsort)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#recordbuf,a0
	movea.l	#winpcts,a1
	movea.l	#winties,a6
	movea.l	#wingames,a5
	move.w	#7,d7					;8 user blocks
.loop								;each user record
	move.b	urwins(a0),d0			;wins, big endian
	lsl.w	#8,d0
	move.b	urwins+1(a0),d0
	move.b	urgames(a0),d1			;games, big endian
	lsl.w	#8,d1
	move.b	urgames+1(a0),d1
	move.w	d1,(a5)+
	tst.w	d1
	bne.w	.0
	clr.w	d0
	bra.w	.1
.0									;games played: win % = wins * 100 / games
	mulu.w	#$64,d0
	divu.w	d1,d0
.1									;% ready
	move.b	d0,(a1)+
	move.b	urties(a0),(a6)+
	move.b	urties+1(a0),(a6)+
	adda.w	#$10,a0					;next 16 byte block
	dbf	d7,.loop					;next user
	movea.l	#winsort,a1
	move.l	a1,-(sp)
	move.w	#1,d0					;the sort list starts as users 1-7
	move.w	#6,d7					;7 users
.loop2								;fill in users 1-7
	move.b	d0,(a1)+
	addi.w	#1,d0					;next user
	dbf	d7,.loop2					;loop
	movea.l	(sp),a1
	movea.l	#winpcts,a0
	movea.l	#winties,a6
	movea.l	#wingames,a5
.loop3								;bubble sort: win %, then ties, then games
	movea.l	(sp),a1
	move.w	#5,d7					;6 pairs
	clr.w	d6
.loop4								;compare a pair with the next
	move.b	(a1)+,d1
	ext.w	d1
	move.b	(a1),d2
	ext.w	d2
	move.b	(a0,d1.w),d0			;this user's %
	move.b	(a0,d2.w),d3			;next user's %
	cmp.b	d3,d0
	bgt.w	.next
	blt.w	.swap
	movem.l	d1-d3,-(sp)
	add.w	d1,d1
	add.w	d2,d2
	move.w	(a6,d1.w),d0			;this user's ties
	move.w	(a6,d2.w),d3			;next user's ties
	cmp.w	d3,d0
	movem.l	(sp)+,d1-d3
	bgt.w	.next					;same %: more ties first
	blt.w	.swap
	movem.l	d1-d3,-(sp)
	add.w	d1,d1
	add.w	d2,d2
	move.w	(a5,d1.w),d0			;this user's games
	move.w	(a5,d2.w),d3			;next user's games
	cmp.w	d3,d0
	movem.l	(sp)+,d1-d3
	bge.w	.next					;same ties: more games first
.swap								;out of order: swap
	move.b	(a1),d0
	move.b	-1(a1),d1				;previous entry
	move.b	d0,-1(a1)				;swap them
	move.b	d1,(a1)
	st.b	d6
.next								;next pair
	dbf	d7,.loop4					;next pair
	tst.w	d6
	bne.w	.loop3					;repeat until no swap
	movea.l	(sp)+,a1
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ReadTeamRecords						;Record Holders: read the records (ReadSRAM)
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	#TeamRecBase,d0			;first user block
	move.l	#$80,d1					;all 8 user blocks
	movea.l	#recordbuf,a0
	jsr	(ReadSRAM).l
	movea.l	#recsort1,a1			;the goals sort list, or the saves one (bit 6)
	btst.b	#6,(sflags6).l
	beq.w	.0
	movea.l	#recsort2,a1
.0									;list chosen
	move.l	a1,-(sp)
	move.w	#1,d0					;start with users 1-7
	move.w	#6,d7					;7 users
.loop								;fill in users 1-7
	move.b	d0,(a1)+
	addi.w	#1,d0					;next user
	dbf	d7,.loop					;loop
	movea.l	(sp),a1
	movea.l	#recordbuf,a0
.loop2								;bubble sort by the record value
	movea.l	(sp),a1
	move.w	#5,d7					;6 pairs
	clr.w	d6
.loop3								;compare a pair with the next
	move.b	(a1)+,d1
	ext.w	d1
	move.b	(a1),d2
	ext.w	d2
	asl.w	#4,d1					;16 bytes per user record
	asl.w	#4,d2
	move.b	(a0,d1.w),d0			;urgoals: goals record
	move.b	(a0,d2.w),d3			;next user's
	btst.b	#6,(sflags6).l			;bit 6: sort by saves instead
	beq.w	.1
	move.b	ursaves(a0,d1.w),d0
	move.b	ursaves(a0,d2.w),d3
.1									;values chosen
	cmp.b	d3,d0
	bge.w	.next
	move.b	(a1),d0
	move.b	-1(a1),d1				;previous entry
	move.b	d0,-1(a1)				;swap them
	move.b	d1,(a1)
	st.b	d6
.next								;in order or swapped
	dbf	d7,.loop3
	tst.w	d6						;any swap?
	bne.w	.loop2					;repeat until no swap
	movea.l	(sp)+,a1
	movem.l	(sp)+,d0-d7/a0-a6
	rts
