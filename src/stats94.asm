;	Stats screens. Each one runs as an item of the pause menu: scores, the line editor, team
;	roster, scoring and penalty summaries, player and playoff stats, the crowd meter with the
;	arena and league records, the timeout and goalie selection.

ShowScores							;"Scores" screen: the other games of the night in gsstruct over the Scores
									;bitmap (ScoresMap); up / down scroll, start exits (ExitStatsScreen). Menu
									;item handler (menu lists)
	moveq	#6,d0					;SetupScreen d0/d1: bitmap row offset / height
	moveq	#$1A,d1
	bsr.w	SetupScreen
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),5,0
	moveq	#$1E,d0
	moveq	#6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP3),$E,3,'Scores',-(TXPRI+TXMAP3),$B,1
	movea.l	#ScoresMap,a1
	lea	jimtilecount(a1),a2
	adda.l	jimdata(a1),a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	clr.w	d5
	jsr	(dobitmap).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,2,4,0
	clr.w	(VertLineScrolling).w
	bsr.w	UpdateVertScrollReg
	jsr	(GetShifter).l				;d1 = number of games to list
	move.w	d1,d3					;d3 = games - 1 (GetShifter)
	ble.w	.skip					;no other games: nothing to list
.game								;print each game
	bsr.w	DisplayGameInfo
	dbf	d3,.game
.skip								;all games printed
	clr.w	(SelectedPlayerIdx).w	;max scroll = 0 unless the list is long
	move.w	(printy).w,d0
	subi.w	#$15,d0					;rows printed past row $15 can be scrolled to
	bmi.w	.loop					;list fits on the screen: no scrolling
	asl.w	#3,d0					;8 pixels per row
	move.w	d0,(SelectedPlayerIdx).w	;scroll limit
	bsr.w	DrawScrollArrows
.loop								;each frame: read the pad
	bsr.w	vcountwait
	bsr.w	getpzjoy
	btst	#7,d3					;start: leave
	bne.w	ExitStatsScreen
	moveq	#-2,d0					;up: scroll -2 pixels a frame
	btst	#0,d3
	bne.w	.set
	neg.w	d0						;down: +2
	btst	#1,d3
	beq.w	.scroll
.set								;up or down: scroll by d0 each frame
	move.w	d0,(PlayerScrollCtr).w
.scroll								;nothing pressed: carry on any scroll still moving
	bsr.w	UpdateScoresScroll
	bra.s	.loop
UpdateScoresScroll					;Called every frame by ShowScores: add PlayerScrollCtr to
									;VertLineScrolling (0 ... SelectedPlayerIdx), stop
									;on a 24 line boundary (DrawScrollArrows). Falls into UpdateVertScrollReg
	move.w	(PlayerScrollCtr).w,d0
	beq.w	rtss8					;not scrolling
	add.w	(VertLineScrolling).w,d0
	bmi.w	rtss8					;would pass the top: stop
	cmp.w	(SelectedPlayerIdx).w,d0
	bgt.w	rtss8					;would pass the bottom: stop
	move.w	d0,(VertLineScrolling).w
	ext.l	d0
	divu.w	#$18,d0
	swap	d0						;remainder
	tst.w	d0
	bne.w	UpdateVertScrollReg		;not on a 3 row boundary yet
	bsr.w	DrawScrollArrows
	clr.w	(PlayerScrollCtr).w
UpdateVertScrollReg					;VSRAM word 1 = VertLineScrolling - $30
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w		;don't int graphics
	movea.l	#Vdata,a0				;a0 = VDP data port, +4 = control port
	move.l	#VSRAM_W+(2<<16),Vctrl-Vdata(a0)
	move.w	#$FFD0,d0				;-$30
	add.w	(VertLineScrolling).w,d0
	move.w	d0,(a0)
	move.w	(sp)+,(disflags).w
	rts
DisplayGameInfo						;Print game d3 of gsstruct (16 bytes each; not the current game gamenum,
									;not one with flag bit 1 or 2 set)
									;the two teams and scores (PrintGameInfo) and the period (PerLabels)
	cmp.w	(gamenum).w,d3
	beq.w	rtss8					;the current game is not listed
	moveq	#$10,d0
	mulu.w	d3,d0
	movea.w	#(gsstruct-M68K_RAM),a0
	adda.w	d0,a0
	btst	#1,gsflags(a0)
	bne.w	rtss8					;(flag bit 1: game not shown)
	btst	#2,gsflags(a0)
	bne.w	rtss8					;(flag bit 2: game not shown)
	move.w	2(a0),d0				;first team / score
	move.w	gss2(a0),d1
	bsr.w	PrintGameInfo
	addq.w	#1,(printy).w
	move.w	(a0),d0					;second team / score
	move.w	gss1(a0),d1
	bsr.w	PrintGameInfo
	move.w	8(a0),d0				;period, 1 based
	subq.w	#1,d0
	movea.l	#PerLabels,a1
	move.w	#$1C,(printx).w
	jsr	(Fprintsmall).l
	addq.w	#2,(printy).w
	rts
PrintGameInfo						;Print team d0's name (TeamList) at x 6 and score d1 (2 digits) at x $18
	movea.w	#TeamList,a1			;team address table
	asl.w	#2,d0
	movea.l	0(a1,d0.w),a1
	adda.w	Teamname(a1),a1
	move.w	#6,(printx).w
	jsr	(print).l
	move.w	#$18,(printx).w
	move.w	d1,d0
	moveq	#2,d1
	jsr	(PushNumberWidth).l
	jmp	print
DrawScrollArrows					;ShowScores up / down arrows (ScrollArrowTable). Saves d0-d1/a1
	movem.l	d0-d1/a1,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,3,4,6,CC_SetFont,1
	clr.w	d0						;d0 = up arrow flag, d1 = down arrow flag
	move.w	(VertLineScrolling).w,d1
	tst.w	d1
	sgt	d0
	neg.b	d0						;1 if scrolled down at all
	cmp.w	(SelectedPlayerIdx).w,d1
	slt	d1
	neg.b	d1						;1 if more below
	add.b	d1,d0
	add.b	d1,d0					;string = up + 2*down
	lea	ScrollArrowTable(pc),a1
	jsr	(Fprintsmall).l
	movem.l	(sp)+,d0-d1/a1
	rts
ScrollArrowTable					;DrawScrollArrows Strings: none, up, down (only 3 entries)
	String	' ',$FB,$FF,$FA,$13,' ',$F9
	String	'{',$FB,$FF,$FA,$13,' ',$F9
	String	' ',$FB,$FF,$FA,$13,'}',$F9
LineEditor							;"Line Editor" screen for team a2: line slot cursor (TestList), C picks a
									;player for the slot from the list, start runs the exit menu
									;(LineEditorExit). OptLine (manual lines off) limits the cursor. Menu item
									;handler
	bset	#tmflcc,tmflags(a2)		;set on entry to the line editor
	moveq	#0,d0
	moveq	#$1C,d1
	bsr.w	SetupScreen
	clr.w	(DispAttribCtr).w
	clr.w	(PlayerScrollCtr).w
	move.w	#1,(TestList).w			;cursor = first slot
LineEditorRedraw					;Clear the screen and redraw everything. Also entered from LineEditorExit
	jsr	(printsmallz).l
	String	CC_SetMap,2,CC_SetX,0,CC_SetY
	moveq	#$28,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	st	(redrawicons).w
	bsr.w	ClearMenuFlags
LineEditorMenu						;Slot cursor loop: start exits, C picks a player for the slot
									;(SelectLinePlayer), up / down /
									;left / right move the slot cursor (LineCursorTable). Also entered from
									;SelectLinePlayer when it is done
	bsr.w	DrawTeamScreen
	bsr.w	DrawLineIcons
.loop								;each frame: read the pad
	bsr.w	vcountwait
	bsr.w	getpzjoy
	jsr	(ProcessInputWithRepeat).l
	btst	#7,d1					;start: exit menu
	bne.w	LineEditorExit
	btst	#5,d1					;C: pick a player for this slot
	bne.w	SelectLinePlayer		;C: pick a player for the slot
	moveq	#1,d0					;down: next slot
	btst	#1,d1
	bne.w	.move
	moveq	#-1,d0					;up: previous slot
	btst	#0,d1
	bne.w	.move
	moveq	#8,d0					;right: next line (8 slots per line)
	btst	#3,d1
	bne.w	.move
	moveq	#$FFFFFFF8,d0			;left: previous line
	btst	#2,d1
	beq.s	.loop
.move								;a direction pressed: move the cursor
	add.w	(TestList).w,d0			;d0 = tentative new slot
	tst.w	(OptLine).w
	beq.w	.set					;manual lines off: free movement
	cmp.w	#1,d0
	blt.s	.loop					;OptLine set: only slots 1-5
	cmp.w	#5,d0
	bgt.s	.loop
.set								;slot allowed: look up the slot after the move
	lea	LineCursorTable(pc),a0		;the slot after the move
	move.b	8(a0,d0.w),(TestList+1).w	;wrap/skip through the table
	bsr.w	DrawLineIcons
	bra.s	.loop
SelectLinePlayer					;Line editor: C pressed on slot TestList. Build the list of players that
									;can go in the slot in Satt (roster order is goalies, forwards, defense)
									;and let the user pick one (left / right pages the attribute columns). C
									;stores the pick with SetLineSlot, start goes back. Both return to
									;LineEditorMenu
	bsr.w	GetGoalieCount
	move.w	d0,d1
	bsr.w	GetForwardCount
	move.w	(TestList).w,d2
	andi.w	#7,d2					;slot within the line
	cmp.w	#2,d2
	bgt.w	.n						;slots 3-5 (forwards): after the goalies
	add.w	d0,d1					;slots 1-2 (defense): after goalies+forwards
	bsr.w	GetPlayerCount
	sub.w	d1,d0					;d0 = candidates, d1 = first roster index
.n									;candidate range chosen (goalies for slot 0)
	subq.w	#1,d0					;count - 1 for dbf
	move.w	d0,(screentimer).w		;last candidate row (also the dbf count)
	clr.w	(PlayerScrollCtr).w
	clr.w	(VertLineScrolling).w
	movea.w	#(Satt-M68K_RAM),a0
	clr.w	d2
.fill								;list every candidate's roster index
	move.b	d1,0(a0,d2.w)
	cmp.w	d1,d6					;player now in the slot?
	bne.w	.nc
	move.w	d2,(VertLineScrolling).w	;start the cursor on him
.nc									;not in the slot now
	addq.w	#1,d1					;next candidate
	addq.w	#1,d2
	dbf	d0,.fill
	bsr.w	ClearLineEditorTop
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,0,3,1,0
	moveq	#$12,d0
	moveq	#3,d1
	jsr	(Framer).l
	jsr	(printsmallz).l
	String	CC_SetX,$15,CC_SetY
	moveq	#$12,d0
	moveq	#3,d1
	jsr	(Framer).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,2,2,1,'{Select  Player}'
	clr.w	d0						;draw the list with the cursor
	bra.w	.vert
.loop								;each frame: read the pad
	bsr.w	vcountwait
	bsr.w	getpzjoy
	jsr	(ProcessInputWithRepeat).l
	btst	#7,d1					;start: back to slot cursor
	bne.w	LineEditorMenu
	btst	#5,d1					;C: take this player
	bne.w	.pick
	moveq	#1,d0
	btst	#1,d1					;down
	bne.w	.vert
	btst	#3,d1					;right: next attribute page
	bne.w	.horz
	moveq	#-1,d0
	btst	#0,d1					;up
	bne.w	.vert
	btst	#2,d1					;left: previous attribute page
	bne.w	.horz
	bra.s	.loop
.horz								;left / right: change the attribute page
	add.w	(DispAttribCtr).w,d0	;change attribute page (not below 0)
	bmi.s	.loop
	move.w	d0,(DispAttribCtr).w
	bsr.w	PrintAttribHeader
.back								;(not branched to)
	bra.s	.loop
.vert								;up / down: move the cursor row
	add.w	(VertLineScrolling).w,d0	;Cursor row 0..screentimer
	bmi.s	.loop
	cmp.w	(screentimer).w,d0
	bgt.s	.loop
	move.w	d0,(VertLineScrolling).w
.first								;(not branched to)
	cmp.w	(PlayerScrollCtr).w,d0
.chkfirst							;(not branched to)
	bgt.w	.top
	move.w	d0,(PlayerScrollCtr).w
.top								;cursor not above the first row shown
	subq.w	#5,d0					;6 rows shown
	cmp.w	(PlayerScrollCtr).w,d0
	ble.w	.draw
	move.w	d0,(PlayerScrollCtr).w
.draw								;cursor inside the 6 rows shown: redraw
	bsr.w	PrintAttribHeader
	bra.w	.loop
.pick								;C: put the player in the slot
	movea.w	#(Satt-M68K_RAM),a3		;C: chosen row's roster index
	adda.w	(VertLineScrolling).w,a3
	move.b	(a3),d0
	addq.b	#1,d0					;SetLineSlot wants 1 based
	move.w	(TestList).w,d2
	bsr.w	SetLineSlot				;put the picked player in the slot
	bra.w	LineEditorMenu
PrintAttribHeader					;Line editor player list: the column header of attribute page
									;DispAttribCtr, then 6 rows of names and that attribute, the selected row
									;highlighted
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$16,1
.top								;(also re-entered when the page is past the end)
	movea.l	#PAttribColumns,a1		;list of column entries: word length, 4 byte flags, text
	move.w	(DispAttribCtr).w,d0	;skip d0 entries
	bra.w	.2
.next								;skip one column entry: text + flags
	adda.w	(a1),a1
	addq.w	#4,a1
.2									;is this the page?
	tst.w	(a1)					;Negative = end of list
	dbmi	d0,.next
	bpl.w	.found
	subq.w	#1,(DispAttribCtr).w	;past the last page: back one
	bra.s	.top
.found								;page found: print its header
	jsr	(print).l
	move.l	(a1),d4					;column flags for GetNameandAttrib
	movea.w	#(Satt-M68K_RAM),a3
	move.w	(PlayerScrollCtr).w,d2	;d2 = first row shown
	move.w	(screentimer).w,d1
	sub.w	d2,d1
	cmp.w	#5,d1
	bls.w	.4
	moveq	#5,d1					;at most 6 rows
.4									;row count set
	move.w	#2,(printy).w
.row								;each row shown
	jsr	(printsmallz).l
	String	CC_SetAttribute,4,CC_SetX,5,CC_AddY,1,'                      ',CC_SetX,5
	cmp.w	(VertLineScrolling).w,d2	;cursor row?
	bne.w	.5
	move.w	d7,(printa).w			;use the highlight attribute
.5									;cursor row highlighted, others normal
	clr.w	d0
	move.b	0(a3,d2.w),d0
	bsr.w	GetNameandAttrib
	addq.w	#1,d2
	dbf	d1,.row
	rts
DrawLineIcons						;Line editor: draw the line icons for the cursor's line (LineIconGroups
									;bit masks, DrawLineIcon), then the selected player box
	moveq	#6,d5					;7 lines
	lea	LineIconGroups(pc),a0
	move.w	(TestList).w,d0
	lsr.w	#3,d0					;line number
	adda.w	d0,a0
	tst.w	(OptLine).w
	beq.w	.0
	subq.w	#1,a0					;OptLine set: table starts one byte earlier
.0									;group table chosen
	move.b	(a0),d0					;group mask for this line
	cmp.b	(redrawicons).w,d0
	beq.w	.line					;same group as last time: no clear
	move.b	d0,(redrawicons).w
	bsr.w	ClearLineArea
.line								;draw every line of the group
	btst	d5,(redrawicons).w		;Line d5 in this group?
	beq.w	.2
	bsr.w	DrawLineIcon
.2									;not in the group: next line
	dbf	d5,.line
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,2,8,7,CC_SetFont,1
	moveq	#$18,d0
	moveq	#3,d1
	jsr	(Framer).l
	jsr	(printsmallz).l
	String	CC_SetX,$15,CC_SetY,8
	move.w	d6,d0					;name of the cursor slot's player
	jsr	(getname).l
	move.w	(a1),d0					;string length word...
	lsr.w	#1,d0
	sub.w	d0,(printx).w			;...used to centre it
	move.w	d7,(printa).w
	jsr	(printsmall).l
	clr.w	(printfontset).w
	rts
	dc.b	1						;the entry before LineIconGroups (read with OptLine set)
LineIconGroups						;Per line: bit mask of the lines drawn together
	dc.b	7,7,7,$18,$18,$60,$60
DrawLineIcon						;Line editor: draw line d5 (its name from linelist, then its player slots)
									;at LineIconPosTable (OptLine: the entry before)
	moveq	#6,d0					;6 bytes per entry
	mulu.w	d5,d0
	lea	LineIconPosTable(pc),a0
	adda.w	d0,a0
	tst.w	(OptLine).w
	beq.w	.0
	subq.w	#6,a0					;OptLine set: use the entry before
.0									;position table chosen
	move.w	(a0),(printx).w			;x, y of the entry
	move.w	2(a0),(printy).w
	move.w	d5,d0					;line name string index
	movea.l	#linelist,a1
	move.w	#$8000,(printa).w
	jsr	(Fprintsmall).l
	jsr	(printsmallz).l
	String	' Line'
	move.w	(a0),(printx).w	
	move.w	d5,d4
	asl.w	#3,d4					;8 slots per line
	addq.w	#1,d4					;slots are 1-5 (LD RD LW C RW)
	move.w	2(a0),(printy).w
	move.w	4(a0),d3				;slot count - 1
	lea	tmlines(a2),a3				;team line table
.slot								;each slot of the line
	move.w	(a0),(printx).w
	jsr	(printsmallz).l
	String	CC_AddX,$FF,CC_AddY,2,CC_SetAttribute,6
	clr.w	d0
	move.b	0(a3,d4.w),d0
	subq.w	#1,d0
	jsr	(FormatPlayerNameShort).l
	cmp.w	(TestList).w,d4			;cursor slot?
	bne.w	.nocur
	move.w	d0,d6					;player in the cursor slot
	move.w	(printa).w,d7
	move.w	#2,(printfontset).w		;highlight while printing
.nocur								;cursor slot highlighted, others normal
	jsr	(printsmall).l
	clr.w	(printfontset).w
	addq.w	#1,d4					;next slot
	dbf	d3,.slot
	rts
ClearLineArea						;Line editor: erase the line area and print the
									;position header (LD RD LW C RW)
	jsr	(printsmallz).l
	String	CC_SetMap,2,CC_SetX,0,CC_SetY,$A
.erase								;(not branched to)
	moveq	#$28,d0					;40 x 18
	moveq	#$12,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	(LineIconPosTable+2).l,(printy).l
	move.w	(LineIconPosTable).l,(printx).l
	tst.w	(OptLine).w
	beq.w	.0
	move.w	(LineIconPosTable-6).l,(printx).l	;OptLine: use the entry before
.0									;entry chosen: print the position header
	jsr	(printsmallz).l
	dc.w	$0022					;String length: too many arguments for the String macro
	dc.b	$FE,4,$FB,$FD,$FA,2,'LD',$FB,$FE,$FA,2,'RD',$FB,$FE,$FA,2,'LW',$FB,$FE,$FA,2,'C ',$FB,$FE,$FA,2,'RW'
	rts
DrawTeamScreen						;Line editor background: bitmap (ScoutMap), frame, "Line Editor" title and
									;the team logo map (PutTeamBlock)
	bsr.w	ClearLineEditorTop
	movem.l	d0-d5/a0-a2,-(sp)
	jsr	(printz).l
	String	-TXMAP3,0,0
	movea.l	#ScoutMap,a1
	adda.l	jimdata(a1),a1
	movea.w	#null,a2				;a2 saved/restored around this block
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	moveq	#1,d4
	moveq	#0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d5/a0-a2
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),7,1
	moveq	#$1A,d0
	moveq	#6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP2),$A,4,'Line  Editor',-(TXPRI+TXMAP2),$E,1
	clr.w	d0						;map offset: home 0, away $30
	cmpa.w	#(tmstruct-M68K_RAM),a2	;home team?
	beq.w	PutTeamBlock
	move.w	#$2C,d0
	bra.w	PutTeamBlock
ClearLineEditorTop					;Erase 40 x 10 at the top of map 2
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),0,0
	moveq	#$28,d0
	moveq	#$A,d1
	move.w	#$7FF,d2
	jmp	eraser
ClearMenuFlags						;Clear palfadenew+$5A and palfadenew+$7A
	clr.w	(palfadenew+$5A).w
	clr.w	(palfadenew+$7A).w
	rts
	;LineIconPosTable-6: the line icon entry used with OptLine set (x, y, slot count - 1)
	dc.w	$10,$C,4				;Entry used when OptLine is set
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
									;right)
	dc.b	1,1,2,3,4,5,$19,1
	dc.b	1,1,2,3,4,5,$19,1
	dc.b	9,9,$A,$B,$C,$D,$21,1
	dc.b	$11,$11,$12,$13,$14,$15,$21,1
	dc.b	5,$19,$1A,$1B,$1C,$1D,$29,1
	dc.b	$D,$21,$22,$23,$24,$25,$31,1
	dc.b	$1D,$29,$2A,$2B,$2C,$2C,1,1
	dc.b	$25,$31,$32,$33,$34,$34,1,1
	dc.b	$25,$31,$32,$33,$34,$34,1,1
LineEditorExit						;Line editor: start pressed. Run the exit menu
									;(LineEditorMenuText, or LineEditorMenuNoLoad when databuffer holds
									;another team), then redraw the editor or leave (ExitStatsScreen)
	bsr.w	ClearMenuFlags
	move.w	#$18,(palcount).w
	move.l	(menuitem).w,-(sp)
	move.l	(menulist).w,-(sp)
	move.l	(menudraw).w,-(sp)
	movea.l	#rtss2,a1
	movea.l	#LineEditorMenuText,a0
	movea.w	#(databuffer-M68K_RAM),a3
	move.w	tmteam(a2),d0			;team number + 1 = first databuffer byte?
	addq.w	#1,d0
	cmp.b	(a3),d0
	beq.w	.0
	movea.l	#LineEditorMenuNoLoad,a0	;no load option for another team's data
.0									;menu with or without the load option
	jsr	(printsmallz).l
	String	CC_SetMap,2
	bsr.w	InitMenuState
.loop								;each frame: run the exit menu
	bsr.w	vcountwait
	bsr.w	getpzjoy
	jsr	(ProcessInputWithRepeat).l
	move.w	d1,-(sp)
	bsr.w	HandleMenuInput
	move.w	(sp)+,d1
	andi.w	#$A0,d1					;start or C
	beq.s	.loop
	jsr	(printsmallz).l
	String	CC_SetFont
	move.w	(menuitem).w,d0
	move.l	(sp)+,(menudraw).w
	move.l	(sp)+,(menulist).w
	move.l	(sp)+,(menuitem).w
	tst.w	d0
	bne.w	LineEditorRedraw
	bra.w	ExitStatsScreen
SetLineSlot							;Put player d0 (1 based) in line slot d2 of team a2; if he is already in
									;another slot of the same line, the old occupant of d2 moves there (swap)
	movem.l	d0-d2/a0-a1,-(sp)
	lea	tmlines(a2),a0				;a0 = team line table (8 bytes per line)
	move.w	d2,d1
	andi.w	#$FFF8,d1
	lea	0(a0,d1.w),a1
	moveq	#5,d1
.find								;look for player d0 in the line
	cmp.b	1(a1,d1.w),d0			;is player d0 already in this line?
	dbeq	d1,.find
	bne.w	.put					;not there: just put him in
	move.b	0(a0,d2.w),1(a1,d1.w)	;already in the line: move the old occupant to his slot
.put								;put the player in the slot
	move.b	d0,0(a0,d2.w)
	movem.l	(sp)+,d0-d2/a0-a1
	rts
DecodeTeamLines						;Load team a2's lines from databuffer: byte 0 = team + 1, then one nibble
									;per slot in AttributeOffsetTbl order, relative to the first forward (or
									;defenseman for slots 1-2). Menu item handler
	movem.l	d0-d4/a0/a3,-(sp)
	movea.w	#(databuffer-M68K_RAM),a0
	addq.w	#1,a0
	bsr.w	GetGoalieCount
	move.w	d0,d1
	bsr.w	GetForwardCount
	move.w	d0,d3
	movea.l	#AttributeOffsetTbl,a3
	clr.w	d4
	clr.w	d2
.next								;each slot in AttributeOffsetTbl order
	move.b	(a3),d2					;d2 = next slot from AttributeOffsetTbl
	bmi.w	.done					;$FF: finished
	bchg	#0,d4					;d4 bit 0 toggles low/high nibble
	bne.w	.hi
	move.b	(a0),d0					;first nibble of the byte: low
	bra.w	.nib
.hi									;second slot of the byte: high nibble
	move.b	(a0)+,d0
	lsr.w	#4,d0
.nib								;nibble ready
	andi.w	#$F,d0					;nibble value
	add.b	d1,d0					;+ goalie count
	andi.w	#7,d2
	cmp.w	#2,d2
	bgt.w	.store					;slots 3-5 are forwards
	add.b	d3,d0					;slots 1-2 defense: + forward count
.store								;forward slot, or defense with the forward count added
	addq.b	#1,d0					;1 based player number
	andi.w	#$FF,d0
	move.b	(a3)+,d2				;d2 = slot index
	bsr.w	SetLineSlot
	bra.s	.next
.done								;exit: restore the registers
	movem.l	(sp)+,d0-d4/a0/a3
	rts
EncodeTeamLines						;Reverse of DecodeTeamLines: pack team a2's lines into databuffer and
									;convert it (WriteLineData, high ROM). Menu item handler
	movem.l	d0-d4/a0-a3,-(sp)
	movea.w	#(databuffer-M68K_RAM),a0
	move.w	tmteam(a2),d0
	addq.w	#1,d0
	move.b	d0,(a0)+
	lea	tmlines(a2),a1
	bsr.w	GetGoalieCount
	move.w	d0,d1
	bsr.w	GetForwardCount
	movea.l	#AttributeOffsetTbl,a3
	clr.w	d4
	clr.w	d2
.next								;each slot
	move.b	(a3)+,d2
	bmi.w	.done
	move.b	0(a1,d2.w),d3
	subq.b	#1,d3
	sub.b	d1,d3					;relative to the first non-goalie
	andi.w	#7,d2
	cmp.w	#2,d2
	bgt.w	.pack					;slots 3-5: forwards
	sub.b	d0,d3					;slots 1-2: also minus forward count
.pack								;forward slot, or defense made relative to the first defenseman
	bchg	#0,d4					;alternate low / high nibble
	bne.w	.hi
	move.b	d3,(a0)					;low nibble (high is or'ed in next)
	bra.s	.next
.hi									;second slot of the byte: high nibble
	asl.b	#4,d3					;second nibble goes in the high half
	or.b	d3,(a0)+
	bra.s	.next
.done								;all slots packed: save them
	jsr	(WriteLineData).l
	movem.l	(sp)+,d0-d4/a0-a3
	rts
AttributeOffsetTbl					;Line slots saved in databuffer ($FF ends)
	dc.b	1,2,3,4,5
	dc.b	9,$A,$B,$C,$D
	dc.b	$11,$12,$13,$14,$15
	dc.b	$19,$1A,$1B,$1C,$1D
	dc.b	$21,$22,$23,$24,$25
	dc.b	$29,$2A,$2B,$2C,$31
	dc.b	$32,$33,$34,$FF
TeamRosterScreen					;"Team Roster" screen for team a2: pages of players (DisplayPlayerList:
									;goalies, then the lines), left / right attribute column, A switches
									;teams, start exits. Menu item handler
	moveq	#$D,d0
	moveq	#$17,d1
	bsr.w	SetupScreen
	moveq	#1,d0
	add.w	tmline(a2),d0			;start on the current line
	move.w	d0,(SelectedPlayerIdx).w	;page 0 = goalies, 1.. = lines
	clr.w	(DispAttribCtr).w
.redraw								;(also the target after A switches teams)
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),7,1
	moveq	#$1A,d0
	moveq	#6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP3),9,4,'Team  Roster',-(TXPRI+TXMAP3),$E,1
	clr.w	d0						;logo map offset: home 0, away $30
	cmpa.w	#(tmstruct-M68K_RAM),a2
	beq.w	.home
	move.w	#$2C,d0
.home								;home team at 0, away at $2C
	bsr.w	PutTeamBlock
.header								;(not branched to)
	jsr	(printsmallz).l
	dc.w	$0034					;String length: too many arguments for the String macro
	dc.b	$F8,6,3,2,$C,$F9,1,'Pos.^Player',$FD,$1E,$FC,$C,'Rating',$FD,$C,$FC,$1A,'A^-^Switch^Teams',$F9,0
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),1,8
	moveq	#$12,d0
	moveq	#3,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),$15,8
	moveq	#$12,d0
	moveq	#3,d1
	jsr	(Framer).l
	bsr.w	DisplayPlayerList		;draw the current page
	move.w	(SelectedPlayerIdx).w,d0
	mulu.w	#$80,d0					;128 pixels per line page
	move.w	d0,(VertLineScrolling).w
	bsr.w	UpdatePlayerListScroll	;set the scroll register for it
	clr.w	(PlayerScrollCtr).w
.loop								;each frame: read the pad
	bsr.w	vcountwait
.pad								;(not branched to)
	bsr.w	getpzjoy
.repeat								;(not branched to)
	jsr	(ProcessInputWithRepeat).l
.start								;(not branched to)
	btst	#7,d3
	bne.w	ExitStatsScreen
.abut								;(not branched to)
	btst	#6,d1
.chka								;(not branched to)
	bne.w	.team
	jsr	(nodiag).l
	moveq	#1,d0
.right								;(not branched to)
	btst	#3,d1
.chkright							;(not branched to)
	bne.w	.col
	neg.w	d0
	btst	#2,d1
	bne.w	.col
	tst.w	(PlayerScrollCtr).w		;still scrolling
	bne.w	.scroll
	moveq	#-2,d0
	btst	#0,d3
	bne.w	.set
	neg.w	d0
	btst	#1,d3
	beq.w	.scroll
.set								;up or down: scroll by d0 each frame
	move.w	d0,(PlayerScrollCtr).w
.scroll								;nothing new pressed: carry on any scroll still moving
	bsr.w	CheckPlayerListScroll
	bra.s	.loop
.col								;left / right: change the attribute column page
	add.w	(DispAttribCtr).w,d0	;new attribute column page (not below 0)
	bmi.s	.scroll
	move.w	d0,(DispAttribCtr).w
	bsr.w	DisplayPlayerList
	bra.s	.scroll
.team								;A: the other team
	lea	tmsize(a2),a2
	cmpa.w	#(AwShots-M68K_RAM),a2
	beq.w	.redraw
	movea.w	#(tmstruct-M68K_RAM),a2	;away -> back to home
	bra.w	.redraw
CheckPlayerListScroll				;TeamRosterScreen per frame: add PlayerScrollCtr to VertLineScrolling (0
									;... $380)
	move.w	(PlayerScrollCtr).w,d0
	beq.w	rtss8
	add.w	(VertLineScrolling).w,d0	;new position
	bmi.w	StopPlayerListScroll
	cmp.w	#$380,d0
	bgt.w	StopPlayerListScroll
UpdatePlayerListScroll				;Set VertLineScrolling = d0. Stop on a page boundary ($80), draw the page
									;coming into view, VSRAM = VertLineScrolling - $70
	move.w	(VertLineScrolling).w,d1	;d1 = old position
	move.w	d0,(VertLineScrolling).w
	ext.l	d0
	divs.w	#$80,d0					;low word of d0 after swap = offset within the page
	swap	d0
	tst.w	d0
	bne.w	.0
	clr.w	(PlayerScrollCtr).w		;exactly on a page: stop
.0									;between pages: keep scrolling
	andi.w	#$7F,d1					;was the old position on a page boundary?
	bne.w	.2
	cmp.w	#$7E,d0					;moved back 2 pixels: draw previous page
	bne.w	.1
	bsr.w	DisplayPlayerListUp
.1									;not moving up
	cmp.w	#2,d0					;moved on 2 pixels: draw next page
	bne.w	.2
	bsr.w	DisplayPlayerListDown
.2									;only on the first step off a page boundary
	move.w	(disflags).w,-(sp)		;set the VSRAM scroll value
	bset	#dfng,(disflags).w
	movea.l	#Vdata,a0
	move.l	#VSRAM_W+(2<<16),Vctrl-Vdata(a0)
	move.w	#$FF90,d0				;-$70
	add.w	(VertLineScrolling).w,d0
	move.w	d0,(a0)
	move.w	(sp)+,(disflags).w
	rts
StopPlayerListScroll				;Out of range: stop scrolling
	clr.w	(PlayerScrollCtr).w
	rts
DisplayPlayerListUp					;d0 = divs result (quotient in the high word): draw that page
	move.l	d0,-(sp)
	swap	d0
	move.w	d0,(SelectedPlayerIdx).w
	bsr.w	DisplayPlayerList
	move.l	(sp)+,d0
	rts
DisplayPlayerListDown				;Draw the page after the quotient in the high word of d0
	move.l	d0,-(sp)
	swap	d0
	addq.w	#1,d0
	move.w	d0,(SelectedPlayerIdx).w
	bsr.w	DisplayPlayerList
	move.l	(sp)+,d0
	rts
DisplayPlayerList					;Draw roster page SelectedPlayerIdx (0 goalies, 1-7 lines): title
									;(PlayerStatMenuTxt), column header, then
									;the rows (GoalieRowText / PlayerPositionText, getNameandAttrib)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,7,3,2,9,CC_SetFont,1
	move.w	(SelectedPlayerIdx).w,d0
	lea	PlayerStatMenuTxt(pc),a1
	jsr	(AdvanceStringPtr).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	CC_SetX,$16,CC_SetY,9
.top								;(also re-entered when the page is past the end)
	movea.l	#PAttribColumns,a1		;skater column list (goalie page: GAttribColumns)
	move.w	(DispAttribCtr).w,d0
	tst.w	(SelectedPlayerIdx).w
	bne.w	.2
	movea.l	#GAttribColumns,a1
	bra.w	.2
.next								;skip one column entry: text + flags
	adda.w	(a1),a1
	addq.w	#4,a1
.2									;is this the page?
	tst.w	(a1)					;negative = end of list
	dbmi	d0,.next
	bpl.w	.found
	subq.w	#1,(DispAttribCtr).w	;past the last page: back one and retry
	bra.s	.top
.found								;page found: print its header
	jsr	(printsmall).l
	move.l	(a1),d4
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,2,0,0,CC_SetFont,0
	btst	#0,(SelectedPlayerIdx+1).w	;odd pages are 16 rows lower
	beq.w	.4
	addi.w	#$10,(printy).w
.4									;page area chosen
	move.w	(printy).w,-(sp)		;erase the page area first
	moveq	#$28,d0
	moveq	#$10,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	(sp)+,(printy).w
	bsr.w	GetGoalieCount
	move.w	d0,d1
	subq.w	#1,d1					;goalie page: one row per goalie
	movea.l	#GoalieRowText,a5		;a5 = position label strings
	movea.w	#(Satt-M68K_RAM),a3		;goalie page: players 1-4
	move.l	#$1020304,(a3)
	move.w	(SelectedPlayerIdx).w,d0
	subq.w	#1,d0					;line number
	bmi.w	.row
	asl.w	#3,d0					;8 bytes per line
	lea	tmlines(a2),a3				;a3 = player numbers of that line (skip byte 0)
	lea	1(a3,d0.w),a3
	movea.l	#PlayerPositionText,a5
	moveq	#4,d1					;5 positions
	cmpi.w	#5,(SelectedPlayerIdx).w
	ble.w	.row
	subq.w	#1,d1					;penalty kill lines: 4
.row								;rows set up (goalies, lines, or 4-man penalty kill)
	move.w	#2,(printx).w
	movea.l	a5,a1
	jsr	(print).l
	movea.l	a1,a5
	move.w	#7,(printx).w			;then name and column value
	clr.w	d0
	move.b	(a3)+,d0
	subq.w	#1,d0					;0 based player index
	bsr.w	GetNameandAttrib
	addq.w	#2,(printy).w			;2 text rows per player
	dbf	d1,.row
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
GetNameandAttrib					;Print player d0's name, then at x $1E the column d4 picks (attribjmp;
									;above 2 a rating through CalcAttrib, high ROM). Saves d0-d4/a0-a1/a4-a5
	movem.l	d0-d4/a0-a1/a4-a5,-(sp)
	pea	.x(pc)
	jsr	(getname).l
	jsr	(print).l
	move.w	#$1E,(printx).w
	cmp.w	#2,d4
	bls.w	.jump
	jsr	(CalcAttrib).l
	swap	d4
.jump								;column handler for d4
	lea	attribjmp(pc),a0
	adda.w	0(a0,d4.w),a0
	jmp	(a0)
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d4/a0-a1/a4-a5
	rts
attribjmp							;getNameandAttrib column handlers, offsets from attribjmp
	dc.w	AttribStatus-attribjmp
	dc.w	AttribEnergy-attribjmp
	dc.w	AttribHanded-attribjmp
	dc.w	AttribWeight-attribjmp
	dc.w	AttribFighting-attribjmp
	dc.w	AttribRating-attribjmp
AttribStatus						;Player d0's tmpdst word: Ice, Bench, injured, or penalty time
	add.w	d0,d0					;jump for status
	move.w	tmpdst(a2,d0.w),d0
	bpl.w	.pen					;positive: serving a penalty
	not.w	d0						;negative: status 0-2
	cmp.w	#3,d0
	bls.w	.st
	moveq	#1,d0					;anything else shown as Bench
	bra.w	.st
.inj								;injured: status 3
	moveq	#3,d0
.st									;print the status text
	lea	StatusTextTbl(pc),a1
	jmp	Fprintsmall
.pen								;penalty time, or injured goalie
	btst	#$C,d0					;bit $C: injured goalie
	bne.s	.inj
	subq.w	#1,(printx).w
	move.w	d0,d1
	andi.w	#$FFF,d0				;penalty time
	jsr	(PushTime).l
	jsr	(print).l
	moveq	#4,d0					;string 4 = blank padding
	bclr	#$E,d1					;bit $E: prints C
	beq.w	.t
	moveq	#5,d0					;string 5 = ' C  '
.t									;padding or " C " chosen
	lea	StatusTextTbl(pc),a1
	jmp	Fprintsmall
StatusTextTbl						;AttribStatus Strings
	String	'Ice     '
	String	'Bench   '
	String	'Injury P'
	String	'Injury G'
	String	'    '
	String	' C  '
AttribEnergy						;Energy: tmpde(a2) word / 40, at most 100 (AttribPrintPct)
	add.w	d0,d0					;jump for energy
	move.w	tmpde(a2,d0.w),d0
	ext.l	d0
	divu.w	#$28,d0
	cmp.w	#$64,d0
	ble.w	AttribPrintPct
	moveq	#$64,d0
	bra.w	AttribPrintPct
AttribFighting						;Bit 0 of the nibble is the handedness: drop it, then a rating out of d1 -
									;1
	andi.w	#$E,d0					;jump for fighting attrib - ignore bit 0 (remove Handedness)
	subq.w	#1,d1					;sub 1 from d1
AttribRating						;d0 * 100 / d1, adjusted (AttribAdjust, high ROM); falls into
									;AttribPrintPct
	mulu.w	#$64,d0					;'d'   ; mult by 100 dec
	divu.w	d1,d0					;divide by d1 (usually 100 dec)
	jsr	(AttribAdjust).l
AttribPrintPct						;Print d0 4 wide, then 4 blanks
	moveq	#4,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	'    '
	rts
AttribHanded						;Bit 0 of the sum: Righty / Lefty (HandedTextTbl)
	andi.w	#1,d0
	eori.w	#1,d0
	lea	HandedTextTbl(pc),a1
	jmp	Fprintsmall
HandedTextTbl						;AttribHanded Strings
	String	'Righty  '
	String	'Lefty   '
AttribWeight						;Weight: 140 + 8 * rating lb
	asl.w	#3,d0					;jump for weight - mult by 8
	addi.w	#$8C,d0					;add 140 lbs (minimum weight)
	jsr	(PushNumber).l
	jsr	(print).l
	jsr	(printz).l
	String	' lb  '
	rts
ScoringSummaryScreen				;"Scoring Summary": one 4 row entry per goal (6 bytes each from ScoreSum),
									;scrolled with up / down, start exits. Menu item handler
	moveq	#$A,d0					;SetupScreen d0/d1: row offset / height
	moveq	#$1A,d1
	bsr.w	SetupScreen
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),4,1
	moveq	#$20,d0
	moveq	#6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP3),6,4,'Scoring Summary',-(TXPRI+TXMAP3),7,1
	move.w	#$2C,d0
	bsr.w	PutTeamBlock
	addq.w	#4,(printx).w
	clr.w	d0
	bsr.w	PutTeamBlock
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,6,3,0,8,CC_SetFont,1,'^Per^^Time^^Tm^^Goal/Assist^^^^^^^^P/S^^',CC_SetFont,0
	clr.l	d0
	move.w	(ScoreSumbytes).w,d0
	divu.w	#6,d0					;goals
	asl.w	#5,d0					;32 pixels per entry
	move.w	d0,(VertLineScrolling).w
	subi.w	#$80,d0					;4 entries fit on screen
	bpl.w	.0
	clr.w	d0
.0									;scroll limit set
	move.w	d0,(SelectedPlayerIdx).w
	move.w	(VertLineScrolling).w,d0
.toend								;loop
	bsr.w	vcountwait
	bsr.w	UpdateScoringScroll
	move.w	(VertLineScrolling).w,d0
	subq.w	#2,d0
	cmp.w	(SelectedPlayerIdx).w,d0
	bge.s	.toend
	clr.w	(PlayerScrollCtr).w
.loop								;loop
	bsr.w	vcountwait
	bsr.w	getpzjoy
	btst	#7,d3					;start: leave
	bne.w	ExitStatsScreen
	moveq	#-2,d0					;up: -2 pixels
	btst	#0,d3
	bne.w	.set
	neg.w	d0						;down: +2
	btst	#1,d3
	beq.w	.scroll
.set								;up or down: scroll by d0 each frame
	move.w	d0,(PlayerScrollCtr).w
.scroll								;nothing new pressed: carry on any scroll still moving
	bsr.w	CheckScoringScroll
	bra.s	.loop
CheckScoringScroll					;ScoringSummaryScreen per frame: add PlayerScrollCtr to VertLineScrolling
									;(0 ... SelectedPlayerIdx). Falls into UpdateScoringScroll
	move.w	(PlayerScrollCtr).w,d0
	beq.w	rtss8
	add.w	(VertLineScrolling).w,d0
	bmi.w	rtss8
	cmp.w	(SelectedPlayerIdx).w,d0
	bgt.w	rtss8
UpdateScoringScroll					;Set VertLineScrolling = d0. Stop on an entry boundary (32 lines; arrows
									;by DrawScrollArrowsPenalty) draw the entry coming into view, VSRAM =
									;VertLineScrolling - $50
	move.w	(VertLineScrolling).w,d1	;d1 = old position
	move.w	d0,(VertLineScrolling).w
	ext.l	d0
	divs.w	#$20,d0					;32 pixels per entry; remainder in the low word after swap
	swap	d0
	tst.w	d0
	bne.w	.0
	bsr.w	DrawScrollArrowsPenalty	;on an entry boundary: update arrows and stop
	clr.w	(PlayerScrollCtr).w
.0									;between entries: keep scrolling
	andi.w	#$1F,d1					;was the old position on a boundary?
	bne.w	.2
	move.l	d0,-(sp)
	cmp.w	#$1E,d0					;moved back 2: draw the entry above
	bne.w	.1
	bsr.w	DrawScoringRowUp
.1									;not moving up
	move.l	(sp)+,d0				;restore remainder
	cmp.w	#2,d0					;moved on 2: draw the entry below
	bne.w	.2
	bsr.w	DrawScoringRowDown
.2									;only on the first step off an entry boundary
	move.w	(disflags).w,-(sp)		;set the VSRAM scroll value, as in UpdateVertScrollReg
	bset	#dfng,(disflags).w
	movea.l	#Vdata,a0
	move.l	#VSRAM_W+(2<<16),Vctrl-Vdata(a0)
	moveq	#$FFFFFFB0,d0
	add.w	(VertLineScrolling).w,d0
	move.w	d0,(a0)
	move.w	(sp)+,(disflags).w
	rts
DrawScoringRowUp					;Draw goal entry (d0 high word) at the top of the window
	move.l	d0,-(sp)
	swap	d0						;d0 = entry number (quotient)
	moveq	#6,d3
	mulu.w	d0,d3					;d3 = byte offset into ScoreSum
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),0,0
	move.w	(VertLineScrolling).w,d0
	lsr.w	#3,d0					;scroll position in 8 pixel rows
	subq.w	#3,d0					;row just above the window, wrapped to 32 map rows
	andi.w	#$1F,d0
	move.w	d0,(printy).w
	bsr.w	DrawScoringRow
	move.l	(sp)+,d0
	rts
DrawScoringRowDown					;Draw goal entry (d0 high word) + 4 at the bottom of the window
	move.l	d0,-(sp)
	swap	d0
	addq.w	#4,d0					;entry 4 below the top one
	moveq	#6,d3
	mulu.w	d0,d3					;d3 = byte offset into ScoreSum
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),0,0
	move.w	(VertLineScrolling).w,d0
	lsr.w	#3,d0					;scroll position in 8 pixel rows
	addi.w	#$10,d0					;16 rows below the top, wrapped to 32 map rows
	andi.w	#$1F,d0
	move.w	d0,(printy).w
	bsr.w	DrawScoringRow
	move.l	(sp)+,d0
	rts
DrawScoringRow						;Print ScoreSum entry d3: time, team (bit 7 of byte 2 = away), goal type
									;(GoalTypeTbl), scorer and the two assists (PrintScorerName)
	move.w	(printy).w,-(sp)
	moveq	#$28,d0					;width 40 cells
	moveq	#4,d1					;4 rows high
	move.w	#$7FF,d2				;blank tile
	jsr	(eraser).l
	move.w	(sp)+,(printy).w
	movea.w	#(ScoreSum-M68K_RAM),a0
	move.w	0(a0,d3.w),d0
	move.w	#1,(printx).w
	jsr	(FormatAndPrintTime).l
	movea.w	#(tmstruct-M68K_RAM),a2
	btst	#7,ssflags(a0,d3.w)
	beq.w	.0						;home goal
	adda.w	#tmsize,a2				;away team struct
.0									;team chosen
	movea.l	tmdata(a2),a1			;team data -> team name string
	adda.w	Teamname(a1),a1
	adda.w	(a1),a1
	move.w	#$C,(printx).w
	jsr	(print).l
	move.w	#$23,(printx).w
	lea	GoalTypeTbl(pc),a1
	move.b	ssflags(a0,d3.w),d0
	andi.w	#$7F,d0					;strip the away bit -> string index
	jsr	(Fprintsmall).l
	move.w	#$10,(printx).w
	move.b	ssscorer(a0,d3.w),d0
	bsr.w	PrintScorerName
	move.w	#$E000,(printa).w
	move.w	#$12,(printx).w
	move.b	ssassist1(a0,d3.w),d0
	bsr.w	PrintScorerName			;first assist
	move.w	#$12,(printx).w
	move.b	ssassist2(a0,d3.w),d0	;second assist, falls into PrintScorerName
PrintScorerName						;Print player d0 (byte, negative = none) and go down a row
	ext.w	d0						;sign extend: $FF = no player
	bmi.w	.0						;nothing to print, just advance the row
	jsr	(FormatPlayerNumInitial).l	;a1 = "NN F. Last" for player d0 of team a2
	jsr	(print).l
.0									;row printed (or none)
	addq.w	#1,(printy).w
	rts
GoalTypeTbl							;ScoreSum byte 2 & $7F: SH2, SH, even, PP, PP2
	String	'SH2'
	String	'SH'
	String	' '
	String	'PP'
	String	'PP2'
PenaltySummaryScreen				;"Penalty Summary": one 3 row entry per penalty (4 bytes each from PenSum,
									;PenSumLength bytes), scrolled as ScoringSummaryScreen. Menu item handler
	moveq	#$A,d0
	moveq	#$19,d1
	bsr.w	SetupScreen
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),4,1
	moveq	#$20,d0
	moveq	#6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP3),5,4,'Penalty  Summary',-(TXPRI+TXMAP3),7,1
	move.w	#$2C,d0
	bsr.w	PutTeamBlock
	addq.w	#4,(printx).w
	clr.w	d0
	bsr.w	PutTeamBlock
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,6,3,0,8,CC_SetFont,1,'^Per^^Time^^Tm^^Player/Penalty^^^^min^^^',CC_SetFont,0
	clr.l	d0
	move.w	(PenSumLength).w,d0		;penalty bytes
	lsr.w	#2,d0					;/4 bytes per entry = number of penalties
	mulu.w	#$18,d0					;24 pixels per entry
	move.w	d0,(VertLineScrolling).w
	subi.w	#$78,d0					;5 entries fit on screen
	bpl.w	.0
	clr.w	d0						;fewer than 5 entries: no scrolling
.0									;scroll limit set
	move.w	d0,(SelectedPlayerIdx).w
	move.w	(VertLineScrolling).w,d0
.toend								;scroll down to the end of the list first
	bsr.w	vcountwait
	bsr.w	UpdatePenaltyScroll		;set scroll to d0, drawing entries as they come into view
	move.w	(VertLineScrolling).w,d0
	subq.w	#2,d0
	cmp.w	(SelectedPlayerIdx).w,d0
	bge.s	.toend					;not there yet
	clr.w	(PlayerScrollCtr).w
.loop								;each frame: read the pad
	bsr.w	vcountwait
	bsr.w	getpzjoy				;d3 = held buttons of the pad that paused
	btst	#7,d3
	bne.w	ExitStatsScreen			;Start
	moveq	#-2,d0
	btst	#0,d3
	bne.w	.set					;up held: scroll up
	neg.w	d0						;+2
	btst	#1,d3
	beq.w	.scroll					;neither: keep the current PlayerScrollCtr (it is cleared at entry
									;boundaries)
.set								;up or down: scroll by d0 each frame
	move.w	d0,(PlayerScrollCtr).w
.scroll								;nothing new pressed: carry on any scroll still moving
	bsr.w	CheckPenaltyScroll
	bra.s	.loop
CheckPenaltyScroll					;PenaltySummaryScreen per frame: add PlayerScrollCtr to VertLineScrolling
									;(0 ... SelectedPlayerIdx). Falls into UpdatePenaltyScroll
	move.w	(PlayerScrollCtr).w,d0
	beq.w	rtss8
	add.w	(VertLineScrolling).w,d0
	bmi.w	rtss8
	cmp.w	(SelectedPlayerIdx).w,d0
	bgt.w	rtss8
UpdatePenaltyScroll					;Set VertLineScrolling = d0. Stop on an entry boundary (24 lines), draw
									;the entry coming into view, VSRAM = VertLineScrolling - $50
	move.w	(VertLineScrolling).w,d1
	move.w	d0,(VertLineScrolling).w
	ext.l	d0
	divs.w	#$18,d0
	swap	d0						;low word = remainder, high word = entry
	tst.w	d0
	bne.w	.0
	bsr.w	DrawScrollArrowsPenalty	;landed on an entry boundary: refresh arrows and stop scrolling
	clr.w	(PlayerScrollCtr).w
.0									;between entries: keep scrolling
	ext.l	d1						;d1 = old position / 24, remainder in the low word
	divs.w	#$18,d1
	swap	d1
	tst.w	d1
	bne.w	.2
	move.l	d0,-(sp)
	cmp.w	#$16,d0					;22 pixels in: moved up, the entry above is coming into view
	bne.w	.1
	bsr.w	DisplayPenaltyLineUp
.1									;not moving up
	move.l	(sp)+,d0				;restore the new position quotient/remainder
	cmp.w	#2,d0					;2 pixels in: moved down, the entry below is coming into view
	bne.w	.2
	bsr.w	DisplayPenaltyLineDown
.2									;only on the first step off an entry boundary
	move.w	(disflags).w,-(sp)		;set the vertical scroll (VSRAM)
	bset	#dfng,(disflags).w		;don't int graphics while the VDP is being addressed
	movea.l	#Vdata,a0
	move.l	#VSRAM_W+(2<<16),Vctrl-Vdata(a0)
	move.w	#$FFB0,d0				;-$50
	add.w	(VertLineScrolling).w,d0
	move.w	d0,(a0)
	move.w	(sp)+,(disflags).w
	rts
DisplayPenaltyLineUp				;Draw penalty entry (d0 high word) at the top of the window
	move.l	d0,-(sp)
	swap	d0						;d0 = entry index
	move.w	d0,d3
	asl.w	#2,d3					;d3 = byte offset into PenSum (4 per entry)
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),0,0
	move.w	(VertLineScrolling).w,d0
	lsr.w	#3,d0					;scroll in 8 pixel cell rows
	subq.w	#2,d0					;2 rows above the window top
	andi.w	#$1F,d0					;wrap in the 32 row map
	move.w	d0,(printy).w
	bsr.w	DisplayPenaltyEntry
	move.l	(sp)+,d0
	rts
DisplayPenaltyLineDown				;Draw penalty entry (d0 high word) + 5 at the bottom of the window
	move.l	d0,-(sp)
	swap	d0						;d0 = entry index
	addq.w	#5,d0					;the entry 5 below it
	move.w	d0,d3
	asl.w	#2,d3					;d3 = byte offset into PenSum (4 per entry)
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),0,0
	move.w	(VertLineScrolling).w,d0
	lsr.w	#3,d0					;scroll in 8 pixel cell rows
	addi.w	#$F,d0					;15 rows below the window top
	andi.w	#$1F,d0					;wrap in the 32 row map
	move.w	d0,(printy).w
	bsr.w	DisplayPenaltyEntry
	move.l	(sp)+,d0
	rts
DisplayPenaltyEntry					;Print PenSum entry d3: time, team (bit 7 of byte 2 = away), minutes and
									;name from Penaltylist, player (byte 3)
	move.w	(printy).w,-(sp)
	moveq	#$28,d0					;width 40 cells
	moveq	#3,d1					;3 rows high
	move.w	#$7FF,d2				;blank tile
	jsr	(eraser).l
	move.w	(sp)+,(printy).w
	movea.w	#(PenSum-M68K_RAM),a0
	move.w	0(a0,d3.w),d0
	move.w	#1,(printx).w
	jsr	(FormatAndPrintTime).l
	movea.w	#(tmstruct-M68K_RAM),a2
	btst	#7,pspen(a0,d3.w)
	beq.w	.0						;home penalty
	adda.w	#tmsize,a2				;away team struct
.0									;team chosen
	movea.l	tmdata(a2),a1			;team data -> team name string
	adda.w	Teamname(a1),a1
	adda.w	(a1),a1
	move.w	#$C,(printx).w
	jsr	(print).l
	move.b	pspen(a0,d3.w),d0
	andi.w	#$7F,d0					;strip the away bit
	movea.l	#Penaltylist,a3
	adda.w	0(a3,d0.w),a3
	clr.w	d0
	move.b	1(a3),d0
	jsr	(PushNumber).l
	move.w	#$23,(printx).w
	jsr	(print).l
	move.w	#$10,(printx).w
	clr.w	d0
	move.b	psplayer(a0,d3.w),d0
	jsr	(FormatPlayerNumInitial).l
	jsr	(print).l
	addq.w	#1,(printy).w
	move.w	#$13,(printx).w
	move.w	#$E000,(printa).w
	lea	2(a3),a1					;penalty name string
	jmp	(print).l
DrawScrollArrowsPenalty				;Summary screen up / down arrows (ScrollArrowTbl). Saves d0-d1/a1. Also
									;used by UpdateScoringScroll
	movem.l	d0-d1/a1,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,3,4,9,CC_SetFont,1
	clr.w	d0
	move.w	(VertLineScrolling).w,d1
	tst.w	d1
	sgt	d0
	neg.b	d0						;1 if scrolled down at all
	cmp.w	(SelectedPlayerIdx).w,d1
	slt	d1
	neg.b	d1						;1 if not at the maximum
	add.b	d1,d0
	add.b	d1,d0					;+2
	lea	ScrollArrowTbl(pc),a1
	jsr	(Fprintsmall).l
	movem.l	(sp)+,d0-d1/a1
	rts
ScrollArrowTbl						;None, up, down, both
	String	' ',$FB,$FF,$FA,$11,' ',$F9
	String	'{',$FB,$FF,$FA,$11,' ',$F9
	String	' ',$FB,$FF,$FA,$11,'}',$F9
	String	'{',$FB,$FF,$FA,$11,'}',$F9
PlayoffStatsScreen					;"Playoff Stats": the playoff totals (ReadTeamStats) of the potreeteam
									;team as PlayerStatsList with d7 = 1. Called and the menu lists
	movem.l	a2,-(sp)
	jsr	(ReadTeamStats).l			;load the playoff team stats
	movea.w	#(potree-M68K_RAM),a0
	move.w	(potreeteam).w,d0
	move.b	0(a0,d0.w),d0
	movea.w	#(tmstruct-M68K_RAM),a2
	cmp.w	tmteam(a2),d0
	beq.w	.0
	adda.w	#tmsize,a2
.0									;team struct of that team chosen
	moveq	#1,d7					;playoff mode: stats come from the playoff RAM tables
	bsr.w	PlayerStatsList
	movem.l	(sp)+,a2
	rts
PlayerStatsScreen					;"Player Stats": PlayerStatsList with d7 = 0
									;(this game). Menu item handler
	clr.w	d7
PlayerStatsList						;Stats screen for team a2, d7 = 0 game / 1 playoff: the column headers,
									;the players sorted by the selected column (left / right), up / down
									;scroll, A switches teams (game stats only), start exits
	moveq	#$D,d0
	moveq	#$16,d1
	bsr.w	SetupScreen
	clr.w	(DispAttribCtr).w		;sort column: -1 goalie saves, 0-4 G A Pts SOG PIM; start with goals
	clr.w	(VertLineScrolling).w	;list scrolled to the top
.redraw								;loop
	clr.w	(PlayerScrollCtr).w
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),5,1
	moveq	#$1E,d0
	moveq	#6,d1
	jsr	(Framer).l
	tst.w	d7
	beq.w	.title
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP3),7,4,'Playoff  Stats',-(TXPRI+TXMAP3),$E,1
	bra.w	.team
.title								;d7 = 0
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,6,3,$C,$1A,CC_SetFont,1,'A^-^Switch^Teams',CC_SetFont,0
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP3),8,4,'Player  Stats',-(TXPRI+TXMAP3),$E,1
.team								;print the team
	clr.w	d0						;TeamBlockMap offset: 0 for the home struct, $30 for the away struct
	cmpa.w	#(tmstruct-M68K_RAM),a2
	beq.w	.home
	move.w	#$2C,d0
.home								;home team at 0, away at $30
	bsr.w	PutTeamBlock			;draw the team block, then the list
	bsr.w	DrawStatsList
	bsr.w	DrawStatsListArrows
.loop								;loop
	bsr.w	vcountwait
	bsr.w	getpzjoy				;d1 = new presses, d3 = held
	btst	#7,d3
	bne.w	ExitStatsScreen			;Start
	btst	#6,d1
	bne.w	.switch					;A pressed
	bsr.w	nodiag					;ignore diagonals
	moveq	#1,d0
.right								;(not branched to)
	btst	#3,d1
	bne.w	.col					;right pressed: column +1
	neg.w	d0
	btst	#2,d1
	bne.w	.col					;left pressed: column -1
	moveq	#-2,d0
.updown								;(not branched to)
	btst	#0,d3
	bne.w	.set					;up held: scroll step -2
	neg.w	d0
	btst	#1,d3
	beq.w	.scroll					;nothing held: keep the current scroll step
.set								;up or down: scroll by d0 each frame
	move.w	d0,(PlayerScrollCtr).w
.scroll								;nothing new pressed: carry on any scroll still moving
	bsr.w	UpdateStatsListScroll
	bra.s	.loop
.col								;bit 3 of d1 set or bit 2 of d1 set
	add.w	(DispAttribCtr).w,d0
	cmp.w	#$FFFF,d0
	blt.s	.scroll
	cmp.w	#4,d0
	bgt.s	.scroll
	move.w	d0,(DispAttribCtr).w
	bsr.w	DrawStatsList
	bsr.w	DrawStatsListArrows
	bra.s	.scroll
.switch								;bit 6 of d1 set
	tst.w	d7						;No team switch in playoff stats
	bne.s	.scroll
	lea	tmsize(a2),a2
	cmpa.w	#(AwShots-M68K_RAM),a2
	beq.w	.redraw					;was home, now away
	movea.w	#(tmstruct-M68K_RAM),a2	;was away, back to home
	bra.w	.redraw
UpdateStatsListScroll				;Stats screen per frame: scroll 0 ... SelectedPlayerIdx, stop on a 16 line
									;boundary, draw the row coming into view
	move.w	(PlayerScrollCtr).w,d0
	beq.w	rtss8
	add.w	(VertLineScrolling).w,d0
	bmi.w	rtss8
	cmp.w	(SelectedPlayerIdx).w,d0
	bgt.w	rtss8
	move.w	(VertLineScrolling).w,d1	;d1 = old position
	move.w	d0,(VertLineScrolling).w
	andi.w	#$F,d0					;pixels into the current 16 pixel row
	bne.w	.0
	bsr.w	DrawStatsListArrows		;landed on a row boundary: refresh arrows and stop scrolling
	clr.w	(PlayerScrollCtr).w
.0									;between rows: keep scrolling
	andi.w	#$F,d1					;old position within its row
	bne.w	SetStatsListScrollReg
	move.w	d0,-(sp)
	cmp.w	#$E,d0					;14 pixels in: moved up, draw the row above
	bne.w	.1
	bsr.w	DrawStatsRowUp
.1									;not moving up
	move.w	(sp)+,d0				;restore the pixels into the row
	cmp.w	#2,d0					;2 pixels in: moved down, draw the row below
	bne.w	SetStatsListScrollReg
	bsr.w	DrawStatsRowDown		;falls into the scroll register write
SetStatsListScrollReg				;VSRAM = VertLineScrolling - $68
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w		;don't int graphics while the VDP is being addressed
	movea.l	#Vdata,a0
	move.l	#VSRAM_W+(2<<16),Vctrl-Vdata(a0)
	move.w	#$FF98,d0				;-$68
	add.w	(VertLineScrolling).w,d0
	move.w	d0,(a0)
	move.w	(sp)+,(disflags).w
	rts
DrawStatsRowUp						;Draw the top row of the window
	move.w	(VertLineScrolling).w,d3
	lsr.w	#4,d3					;d3 = first visible Satt row (16 pixels per row)
	bra.w	DrawStatsRow
DrawStatsRowDown					;Draw the row below the window
	move.w	(VertLineScrolling).w,d3
	lsr.w	#4,d3					;first visible Satt row
	addq.w	#6,d3					;6 rows further down
	bra.w	DrawStatsRow
DrawStatsList						;Stats screen: column headers (sort column highlighted), the title of the
									;sort column (StatSortTitles), then the players sorted by it into Satt and
									;the rows drawn
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,6,3,4,$B,CC_SetFont,1,'Player',CC_AddX,7
	lea	StatColumnHeaders(pc),a1
	moveq	#5,d3					;goalie mode: d3 = 5 so only the first (goalie) string is printed
	tst.w	(DispAttribCtr).w
	bmi.w	.head
	adda.w	(a1),a1					;skip the goalie header string, a1 = " G" string
	clr.w	d3						;d3 = column 0-4
.head								;each column header (only the goalie one in goalie mode)
	move.w	#$8000,(printa).w		;next column header, normal attribute
	cmp.w	(DispAttribCtr).w,d3
	bne.w	.1
	move.w	#$C000,(printa).w		;highlight the sort column
.1									;sort column highlighted, others normal
	jsr	(printsmall).l
	addq.w	#1,d3
	cmp.w	#5,d3
	blt.s	.head
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,3,9,7
	moveq	#$16,d0
	moveq	#3,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	-(TXPRI+TXPAL3+TXMAP3),$A,8
	lea	StatSortTitles(pc),a1
	moveq	#1,d0
	add.w	(DispAttribCtr).w,d0	;string 0 = goalie saves, 1-5 = G A Pts SOG PIM
	jsr	(Fprintsmall).l
	clr.w	(printfontset).w
	movea.w	#(Satt-M68K_RAM),a3
	clr.l	d6
	tst.w	(DispAttribCtr).w
	bpl.w	.sort
	bsr.w	GetGoalieCount			;goalie column: mark all skaters used
	bset	d0,d6					;(goalies come first in the roster: players 0 to count-1)
	subq.w	#1,d6
	not.l	d6						;bits count and up set = skaters
.sort								;pick the best remaining player each pass
	moveq	#-1,d4					;Selection sort, best so far
	st	d5							;d5 = $FF: none found
	bsr.w	GetPlayerCount			;d0 = number of players, loop counts d0 down from count-1
	bra.w	.next
.player								;each candidate
	btst	d0,d6					;candidate player d0
	bne.w	.next					;already used (or filtered out)
	clr.w	d2
	move.w	(DispAttribCtr).w,d1
	bmi.w	.4						;goalie column: key is just the tie-break byte
	bsr.w	GetStatColumn			;d2 = stat for player d0
.4									;sort key ready
	ext.l	d2						;d2 = stat value
	asl.l	#8,d2					;key = stat * 256 ...
	movea.l	tmdata(a2),a1			;walk the player records to record d0
	adda.w	(a1),a1
	move.w	d0,d1
	subq.w	#8,a1
.skip								;skip one player record
	addq.w	#8,a1					;next player record
	adda.w	(a1),a1
	dbf	d1,.skip
	move.b	#$FF,d2
	sub.b	(a1),d2					;ties: lower player byte first
	cmp.l	d4,d2					;... + ($FF - first byte of the player record)
	ble.w	.next					;not better than the best so far
	move.l	d2,d4
	move.w	d0,d5
.next								;next candidate
	dbf	d0,.player					;next candidate
	bset	d5,d6					;used
	move.b	d5,(a3)+				;append the best player to the sorted list
	bpl.s	.sort					;until none left ($FF)
	moveq	#5,d0
.pad								;fill 6 $FF rows after the list
	st	0(a3,d0.w)
	dbf	d0,.pad
	move.w	a3,d0
	subi.w	#$C01E,d0
	bpl.w	.8
	clr.w	d0
.8									;scroll limit: rows past the first 6
	asl.w	#4,d0					;16 pixels per row
	move.w	d0,(SelectedPlayerIdx).w
	cmp.w	(VertLineScrolling).w,d0
	bcc.w	.9
	move.w	d0,(VertLineScrolling).w	;clamp the current scroll to the new maximum draw the 6 visible rows
.9									;scroll kept inside the limit
	moveq	#5,d4
.ent								;draw each visible row
	move.w	(VertLineScrolling).w,d3	;draw loop, d4 = row offset 5 to 0
	lsr.w	#4,d3
	add.w	d4,d3					;Satt row d3
	bsr.w	DrawStatsRow
	dbf	d4,.ent
	bra.w	SetStatsListScrollReg
DrawStatsRow						;Stats screen row d3 of Satt: rank, name, then the 5 columns, or for
									;goalies saves, shots and save %
	movea.w	#(Satt-M68K_RAM),a4
	adda.w	d3,a4
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),0,0
	add.w	d3,d3					;2 map rows per Satt row
	andi.w	#$1F,d3					;wrap in the 32 row map
	move.w	d3,(printy).w
	moveq	#$28,d0					;erase one row, 40 cells wide
	moveq	#1,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	tst.b	(a4)
	bmi.w	rtss8
	subq.w	#1,(printy).w			;eraser moved printy down one row; back to the row rank (2 digits) at x 1
	move.w	#1,(printx).w
	move.w	a4,d0
	subi.w	#$C017,d0
	moveq	#2,d1
	move.w	#$E000,(printa).w
	jsr	(PushNumberWidth).l
	jsr	(print).l
	clr.w	d0
	move.b	(a4),d0
	jsr	(FormatPlayerName).l
	addq.w	#1,(printx).w
	move.w	#$8000,(printa).w
	jsr	(print).l
	move.w	#$11,(printx).w			;stat columns start at x $11
	tst.w	(DispAttribCtr).w
	bmi.w	.goalie
	clr.w	d5
.col								;loop
	clr.w	d0						;next stat column d5
	move.b	(a4),d0
	move.w	d5,d1					;column
	bsr.w	GetStatColumn
	move.w	d2,d0
	moveq	#4,d1
	jsr	(PushNumberWidth).l
	move.w	#$8000,(printa).w
	cmp.w	(DispAttribCtr).w,d5
	bne.w	.1
	move.w	#$C000,(printa).w		;highlighted sort column
.1									;sort column highlighted, others normal
	jsr	(print).l
	addq.w	#1,d5
	cmp.w	#5,d5
	bne.s	.col
	bra.w	.x
.goalie								;DispAttribCtr negative
	clr.w	d0						;Shots against
	move.b	(a4),d0
	moveq	#3,d1					;column 3 (SOG array)
	bsr.w	ReadStatColumn
	clr.w	d0
	move.b	(a4),d0
	moveq	#0,d1					;goals against
	move.w	d2,-(sp)				;keep shots
	bsr.w	ReadStatColumn
	move.w	(sp)+,d0
	move.w	d0,d3					;d3 = shots
	sub.w	d2,d0					;saves = shots - goals against
	bpl.w	.2
	clr.w	d0
.2									;saves ready (not below 0)
	move.w	d0,d2
	moveq	#4,d1
	jsr	(PushNumberWidth).l
	addq.w	#1,(printx).w
	jsr	(print).l
	move.w	d3,d0
	moveq	#4,d1
	jsr	(PushNumberWidth).l
	addq.w	#2,(printx).w
	jsr	(print).l
	tst.w	d3
	beq.w	.3						;no shots: percentage is just d2 (0)
	mulu.w	#$64,d2
	divu.w	d3,d2					;saves * 100 / shots
.3									;save % ready (0 with no shots)
	move.w	d2,d0
	moveq	#4,d1
	jsr	(PushNumberWidth).l
	addq.w	#2,(printx).w
	jsr	(print).l
	jsr	(printz).l
	String	'%'
.x									;exit
	rts
GetStatColumn						;d2 = stat column d1 for player d0. Goalies only have PIM (btst d1,#6
									;picks the columns kept)
	move.w	d0,-(sp)
	bsr.w	GetGoalieCount
	move.w	d0,d2
	move.w	(sp)+,d0
	cmp.w	d2,d0
	bge.w	ReadStatColumn			;skater: read the column as is
	clr.w	d2						;goalie: columns 1 and 2 (A, Pts) show column 1 (assists), the rest 0
	btst	d1,#6					;written as btst Dn,#imm
	beq.w	rtss8
	moveq	#1,d1
ReadStatColumn						;d2 = stat column d1 for player d0. d7 = 0: the team struct byte arrays
									;(StatColumnOffsets); d7 = 1: the playoff tables (GetStatsValue)
	tst.w	d7
	bne.w	.stats					;playoff stats
	lea	StatColumnOffsets(pc),a1
	asl.w	#2,d1					;2 words per column
	adda.w	d1,a1
	move.w	(a1),d1					;first array offset
	add.w	d0,d1
	clr.w	d2
	move.b	0(a2,d1.w),d2
	move.w	2(a1),d1
	bmi.w	rtss8
	add.w	d0,d1
	clr.w	d3
	move.b	0(a2,d1.w),d3
	add.w	d3,d2
	rts
.stats								;d7 <> 0
	asl.w	#2,d1					;2 words per column
	add.w	d0,d0
	clr.w	d2
	bsr.w	GetStatsValue
	addq.w	#2,d1					;second table of the pair
	bsr.w	GetStatsValue
	lsr.w	#1,d0					;restore the player index
	rts
GetStatsValue						;d2 += word d0 of the RAM table at StatsOffsetTbl2+d1 (0 = none)
	movea.l	#StatsOffsetTbl2,a1
	tst.w	0(a1,d1.w)
	beq.w	rtss8
	movea.w	0(a1,d1.w),a1
	add.w	0(a1,d0.w),d2
	rts
StatsOffsetTbl2						;Playoff stat RAM tables per column (G, A, G+A, SOG, PIM)
	dc.w	$CD96,0,$CDCA,0,$CD96,$CDCA,$CDFE,0,$CE32,0
StatColumnOffsets					;Team struct byte arrays per column, same order
	dc.w	$B4,$FFFF,$CE,$FFFF,$B4,$CE,$E8,$FFFF,$102,$FFFF
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
	String	CC_SetMapAndPosition,4,3,2,$B,CC_SetFont,1
	clr.w	d0
	move.w	(VertLineScrolling).w,d1
	tst.w	d1
	sgt	d0
	neg.b	d0						;1 if scrolled down at all
	cmp.w	(SelectedPlayerIdx).w,d1
	slt	d1
	neg.b	d1						;1 if not at the maximum
	add.b	d1,d0
	add.b	d1,d0					;+2
	lea	ScrollArrowTbl2(pc),a1
	jsr	(Fprintsmall).l				;print string d0 of the table
	movem.l	(sp)+,d0-d1/a1
	rts
ScrollArrowTbl2						;None, up, down, both
	String	' ',$FB,$FF,$FA,$C,' ',$F9
	String	'{',$FB,$FF,$FA,$C,' ',$F9
	String	' ',$FB,$FF,$FA,$C,'}',$F9
	String	'{',$FB,$FF,$FA,$C,'}',$F9
CrowdMeterScreen					;"Crowd Meter": current, average and peak level (PrintCrowdMeter), plus
									;the arena and league records; start exits. Menu item handler
	moveq	#9,d0
	moveq	#$1C,d1
	bsr.w	SetupScreen
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),6,1
	moveq	#$1C,d0					;frame 28 wide, 6 high
	moveq	#6,d1
	bsr.w	Framer
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP3),9,4,'Crowd  Meter',-(TXPRI+TXMAP3),7,1
	move.w	#$2C,d0
	bsr.w	PutTeamBlock
	addq.w	#4,(printx).w
	clr.w	d0
	bsr.w	PutTeamBlock
	bsr.w	PrintCrowdMeter			;the three level rows
.loop								;loop
	bsr.w	WaitVSyncAndReadInput	;wait for a new button press
	btst	#7,d1
	bne.w	ExitStatsScreen
	bra.s	.loop
PrintCrowdMeter						;Crowd meter rows: CwdExciteLvl, the average (SumCwdExciteLvl /
									;NumCwdExciteLvl) and MaxCwdExciteLvl
									;in dB (PrintCrowdDB). With save RAM (ValidSRAM) the arena record of
									;HomeTeam and the league record, read into the buffer at ThreeStars by
									;ReadCrowdRecord (high ROM); 0 reads as $50
	bsr.w	printsmallz
	String	CC_SetMapAndPosition,4,2,4,$C,'Current Level',CC_SetX,$1C
	move.w	(CwdExciteLvl).w,d0
	bsr.w	PrintCrowdDB
	bsr.w	printsmallz
	String	CC_SetX,4,CC_AddY,2,'Average Level',CC_SetX,$1C
	move.l	(SumCwdExciteLvl).w,d0
	divu.w	(NumCwdExciteLvl).w,d0
	bsr.w	PrintCrowdDB
	bsr.w	printsmallz
	String	CC_SetX,4,CC_AddY,2,'Peak Level',CC_SetX,$1C
	move.w	(MaxCwdExciteLvl).w,d0
	bsr.w	PrintCrowdDB
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(ValidSRAM).w
	bmi.w	.x
	move.w	(HomeTeam).w,d1
	ext.l	d1
	movea.l	#recordbuf,a0
	jsr	(ReadCrowdRecord).l
	move.b	crpeak(a0),d0
	bne.w	.gotarena
	move.b	#$50,d0
.gotarena							;arena record, or $50 dB when none
	andi.w	#$FF,d0
	move.w	d0,-(sp)
.arena								;(not branched to)
	bsr.w	printsmallz
	String	CC_SetX,4,CC_AddY,2,'Arena Record',CC_SetX,$1C
	move.w	(sp)+,d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
.arenadb							;(not branched to)
	jsr	(printz).l
	String	' dB'
.league								;(not branched to)
	jsr	(GetLeagueCrowdRecord).l
	move.w	d0,d1
	ext.l	d1
	movea.l	#recordbuf,a0
	jsr	(ReadCrowdRecord).l
	move.b	crpeak(a0),d0
	bne.w	.gotleague
	move.w	#$50,d0
.gotleague							;league record, or $50 dB when none
	andi.w	#$FF,d0
	move.w	d0,-(sp)
	bsr.w	printsmallz
	String	CC_SetX,4,CC_AddY,2,'League Record',CC_SetX,$1C
	move.w	(sp)+,d0
.leaguew							;(not branched to)
	move.w	#3,d1
.leaguenum							;(not branched to)
	jsr	(PushNumberWidth).l
	jsr	(print).l
	bsr.w	printz
	String	' dB'
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PrintCrowdDB						;Print crowd level d0 as sqrt(d0 * 4) + 65 " dB"
	ext.l	d0
	asl.w	#2,d0					;level * 4
	bsr.w	Sroot					;d0 = square root
	addi.w	#$41,d0					;+ 65
	moveq	#3,d1					;3 digits
	jsr	(PushNumberWidth).l
	bsr.w	print
	bsr.w	printz
	String	' dB'
	rts
SetupScreen							;Common start of the stats screens: blank, 40 cell mode, the framer and
									;small font tiles, the background bitmap (ScoutMap) from row d0, d1 rows
									;high
	movem.l	d0-d1/a2,-(sp)			;keep d0/d1 (first/last row) and a2 (team) for the caller
	bsr.w	forceblack
	bclr	#dfok,(disflags).w		;graphics not ready for transfer
	move.w	(disflags).w,-(sp)
.noint								;(not branched to)
	bset	#dfng,(disflags).w
	move.w	(VSPRITES).w,d0
	bsr.w	Vmaddr
	move.l	#0,(a0)					;clear first sprite
.vdpregs							;(not branched to)
	move.w	#VDPR_MODE4+$81,Vctrl-Vdata(a0)
	move.w	#6,(Map3col).w
	move.w	#VDPR_HSCROLL,Vctrl-Vdata(a0)
	clr.w	d0
	bsr.w	Vmaddr
	move.l	#0,(a0)
	move.w	(sp)+,(disflags).w
	bclr	#df32c,(disflags).w		;not in 32 cell mode
	move.w	(framercset).w,d4
	movea.l	#FramerMap+8,a2
	bsr.w	DecompressGraphicsWithCallback
	dc.l	$91234567,$89ABCDEF		;remap table
	move.w	(smallfontchars).w,d4
	jsr	(AddSmallFont).l
	bsr.w	printz
	String	-(TXPRI+TXMAP3),0,0
	movea.l	#ScoutMap,a1
	adda.l	jimdata(a1),a1
	movea.w	#null,a2
	clr.w	d0						;start x/y 0 in the map
	clr.w	d1
	move.w	(a1),d2					;map width
	move.w	mapheight(a1),d3		;map height
	moveq	#1,d4
	moveq	#0,d5					;no palette lines
	bsr.w	dobitmap
	bsr.w	printz
	String	-TXMAP3,0,0
	movem.l	(sp),d0-d1/a2
	add.w	d0,(printy).w
	movea.l	#ScoutMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	d1,d3
	sub.w	d0,d3					;height = last row - first row
	move.w	d0,d1					;start y = first row
	clr.w	d0						;start x 0
	moveq	#$28,d2					;width 40
	moveq	#$D,d5					;copy palette lines 0, 2 and 3
	bsr.w	dobitmap
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2
	bsr.w	DecompressGraphicsWithCallback
	dc.l	$D1234567,$89ABCDEF		;remap table
	bsr.w	printz
	String	-TXMAP2,0,0
	moveq	#$40,d0
	moveq	#$20,d1
	move.w	#$7FF,d2
	bsr.w	eraser
	move.w	#$18,(palcount).w		;start a palette fade in
	movem.l	(sp)+,d0-d1/a2
	rts
ExitStatsScreen						;Leave a stats screen: blank, then ReloadRinkGraphics
	bsr.w	forceblack
ReloadRinkGraphics					;after the forceblack: back to 32 cell mode and reload the rink (Rinktiles
									;or RevRinkTiles in a reverse angle
									;replay), font, framer, EASN and team graphics. Falls out through
									;setplayercolors. Also called from the replay code
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	move.w	(VSCRLPM).w,d0
	bsr.w	Vmaddr
	move.l	#0,(a0)
	move.w	#$8D00,d0
	move.b	(VSCRLPM).w,d0
	lsr.b	#2,d0
	move.w	d0,Vctrl-Vdata(a0)
	move.w	#VDPR_MODE4,Vctrl-Vdata(a0)
	move.w	#5,(Map3col).w
	move.w	(sp)+,(disflags).w
	bset	#df32c,(disflags).w
	move.w	(rinkvrcset).w,d4
	movea.l	#Rinktiles,a2			;load rink address
	btst	#4,(sflags4).w			;check if reverse angle replay
	beq.w	.load					;branch if not
	movea.l	#RevRinkTiles,a2		;load reverse rink address
.load								;normal or reverse angle rink tiles chosen
	bsr.w	DecompressGraphicsPlain
	jsr	(LoadHomeTeamGfx).l
	move.w	(smallfontchars).w,d4
	movea.l	#SmallFontMap+8,a2
	bsr.w	DecompressGraphicsWithCallback
	dc.l	$43434567,$89ABCDEF		;remap table
	move.w	(framercset).w,d4
	jsr	(AddFramer).l
	jsr	(setupEASNmap).l
	jsr	(ReloadEnergyBarTiles).l
	jsr	(ReloadCrowdTiles).l
	jsr	(setupIceRinkPal).l
	jmp	setplayercolors
TimeoutMenu							;Pause menu "Timeout" for team a2: switch the menu to PauseText2, show the
									;team name, rest both teams (RestoreTeamEnergy), wait $78 frames (waitx).
									;Menu item handler
	subq.w	#1,(menuitem).w
	subq.w	#1,(menuitem+2).w
	move.l	#PauseText2,(menulist).l	;pause menu without Timeout
	bset	#tmftimeout,tmflags(a2)	;timeout used
	bsr.w	printz
	String	-(TXPRI+TXMAP3),5,$C
	moveq	#$16,d0					;frame 22 wide, 6 high
	moveq	#6,d1
	bsr.w	Framer
	bsr.w	printz
	String	-(TXPRI+TXMAP3),$C,$E,'Timeout',-(TXPRI+TXMAP3),$11,$F
	movea.l	tmdata(a2),a1			;team name, centred
	adda.w	Teamname(a1),a1
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	bsr.w	print
	movea.w	#(tmstruct-M68K_RAM),a2
	jsr	(RestoreTeamEnergy).l
	adda.w	#tmsize,a2
	jsr	(RestoreTeamEnergy).l
	moveq	#$78,d0
	bra.w	waitx
SelectGoalieMenu					;it in TimeoutMenu's String. Pick team a2's goalie (or no goalie) from a
									;list (DrawGoalieSelectList) with up / down, C or start; sets tmgoalie and
									;SetPersonel. Menu item handler
	move.w	(menuitem).w,-(sp)
	move.w	(menuitem+2).w,-(sp)
	bsr.w	GetGoalieCount
	move.w	d0,(menuitem+2).w
	bsr.w	printz
	String	-(TXPRI+TXMAP3),4,$C
	moveq	#$18,d0
	moveq	#3,d1
	add.w	(menuitem+2).w,d1
	bsr.w	Framer
	move.w	tmgoalie(a2),d0
	bpl.w	.0
	moveq	#-1,d0
.0									;row of the current goalie (0 = goalie pulled)
	addq.w	#1,d0
	move.w	d0,(menuitem).w
.loop								;loop
	bsr.w	DrawGoalieSelectList
.pad								;(not branched to)
	bsr.w	WaitVSyncAndReadInput
	btst	#7,d1
	bne.w	.done					;Start confirms
	btst	#5,d1
	bne.w	.done					;C confirms
	btst	#1,d1
	beq.w	.up						;down not pressed
	move.w	(menuitem).w,d0
	addq.w	#1,d0
	cmp.w	(menuitem+2).w,d0
	bgt.s	.loop					;already on the last row
	move.w	d0,(menuitem).w
.up									;down handled: check up
	btst	#0,d1					;up pressed: move the selection up
	beq.s	.loop
	subq.w	#1,(menuitem).w
	bpl.s	.loop
	clr.w	(menuitem).w			;stop at the first row
	bra.s	.loop
.done								;bit 7 of d1 set or bit 5 of d1 set
	move.w	(menuitem).w,d0			;confirmed
	subq.w	#1,d0
	bpl.w	.set
	cmpi.w	#$FFFF,tmgoalie(a2)
	blt.w	.x
.set								;a goalie row: put him in
	move.w	d0,tmgoalie(a2)
	jsr	(setpersonel).l
.x									;goalie set, or none and already pulled
	move.w	(sp)+,(menuitem+2).w	;restore the pause menu state
	move.w	(sp)+,(menuitem).w
	rts
DrawGoalieSelectList				;Draw the goalie list, row menuitem highlighted, each goalie with his two
									;digit number
	move.w	#$D,(printy).w
	move.w	(menuitem+2).w,d1
	moveq	#0,d0
.row								;each row of the list
	move.w	#5,(printx).w			;next list row d0
	move.w	#$A000,(printa).w
	cmp.w	(menuitem).w,d0
	bne.w	.1
	move.w	#$8000,(printa).w
.1									;cursor row highlighted
	bsr.w	printz
	String	'                      '
	tst.w	d0
	bne.w	.player
	move.w	#$B,(printx).w
	bsr.w	printz
	String	'no goalie'
	bra.w	.next
.player								;d0 <> 0
	movea.l	tmdata(a2),a1			;goalie row: find the player record
	adda.w	(a1),a1
	move.w	d0,d2
	subq.w	#1,d2
	bra.w	.3
.skip								;skip one player record
	adda.w	(a1),a1
	addq.w	#pldsize,a1
.3									;loop until the goalie is reached
	dbf	d2,.skip					;repeat d0-1 times
	move.w	#8,(printx).w
	bsr.w	print					;goalie name at x 8
	move.b	(a1),d2
	lsr.b	#4,d2
	addi.b	#$30,d2
	move.b	d2,(TextBuffer).w		;high nibble
	move.b	(a1),d2
	andi.b	#$F,d2
	addi.b	#$30,d2
	move.b	d2,(TextBuffer+1).w		;low nibble
	movea.w	#(mesarea-M68K_RAM),a1
	move.w	#4,(a1)					;string length word (2 chars + 2)
	move.w	#5,(printx).w
	bsr.w	print
.next								;next row
	addq.w	#1,(printy).w			;next map row and list row
	addq.w	#1,d0
	dbf	d1,.row
	rts
GetGoalieCount						;d0 = goalies on team a2 (nibbles in a team data word)
	movem.l	d1/a0,-(sp)
	movea.l	tmdata(a2),a0
.word								;(not branched to)
	adda.w	GoalieOdds(a0),a0
	move.w	(a0),d1					;word with one nibble per goalie slot
	clr.w	d0
.count								;loop
	addq.w	#1,d0					;count nibbles by shifting 4 bits out until the word is 0
	asl.w	#4,d1
	bne.s	.count
	movem.l	(sp)+,d1/a0
	rts
GetDefenseStart						;d0 = goalies + forwards of team a2 (GetGoalieCount + GetForwardCount),
									;the roster index of the first defenseman (roster order is goalies,
									;forwards, defense). Called from the high ROM player cards
	movem.l	a0,-(sp)
	bsr.s	GetGoalieCount
	move.w	d0,-(sp)
	movea.l	tmdata(a2),a0
	adda.w	ScoutReport(a0),a0
	move.b	srforwards(a0),d0
	lsr.w	#4,d0
	andi.w	#$F,d0
	add.w	(sp)+,d0
	movem.l	(sp)+,a0
	rts
GetForwardCount						;d0 = forwards on team a2 (high nibble of team data byte 3 at +8)
	movem.l	a0,-(sp)
	movea.l	tmdata(a2),a0
	adda.w	ScoutReport(a0),a0
	move.b	srforwards(a0),d0
	lsr.w	#4,d0					;high nibble = forward count
	andi.w	#$F,d0
	movem.l	(sp)+,a0
	rts
GetPlayerCount						;d0 = players on team a2 (records until a length word of 2)
	movem.l	a0,-(sp)
	movea.l	tmdata(a2),a0
	adda.w	(a0),a0					;a0 = first player record
	clr.w	d0
.loop								;loop
	addq.w	#1,d0
	adda.w	(a0),a0
	addq.w	#pldsize,a0
	cmpi.w	#2,(a0)
	bne.s	.loop
	movem.l	(sp)+,a0
	rts
WaitVSyncAndReadInput				;Wait for Vcount to change and for a new button press (d1)
	move.w	(Vcount).w,d1
.wait								;loop
	cmp.w	(Vcount).w,d1			;has Vcount changed?
	beq.s	.wait					;spin until the vblank counter changes
	bsr.w	getpzjoy				;d1 = new presses, d3 = held
	bsr.w	nodiag					;drop diagonal presses
	tst.b	d1
	beq.s	WaitVSyncAndReadInput	;nothing new pressed: wait again
	rts
