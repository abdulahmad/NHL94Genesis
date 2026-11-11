;	HOCKEY.BIN $11660-$13E03 (runtime $2C660-$2EE03): stats94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Scores, line editor, roster and the stat screens are the cartridge code.
;
;	CD: their graphics come through the pointer table ($47D0C ...) and some screen writes are commands to the
;	main CPU ($FF8022 / $FF8020); PrintGameInfo, DrawStatsRow, PrintCrowdMeter and ExitStatsScreen start with
;	new lines (their names are placed where the disc calls them).

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

null	equ	$1B008
TeamList	equ	$1B00C
ReadCrowdRecord	equ	$2258E
CalcAttrib	equ	$2610C
WriteLineData	equ	$2A5C8
GetLeagueCrowdRecord	equ	$2AC02
AttribAdjust	equ	$2AE82
Pausemode_top	equ	$2C2F8
HandleMenuInput	equ	$2C368
PutTeamBlock	equ	$2C59E
MenuWaitVblank	equ	$2C63A
StatsOffsetTbl2	equ	$2E40E
StatColumnOffsets	equ	$2E422
getpzjoy	equ	$2F2F0
rtss8	equ	$2F988
nodiag	equ	$37496
ProcessInputWithRepeat	equ	$374BE
dobitmap	equ	$387E2
eraser	equ	$38C06
Framer	equ	$38CA0
printsmallz	equ	$38D8C
printsmall	equ	$38D9E
printz	equ	$38F6E
print	equ	$38F80
FormatAndPrintTime	equ	$390C0
PushTime	equ	$390F4
PushNumber	equ	$3915E
PushNumberWidth	equ	$3919A
printbigz	equ	$39258
AddSmallFont	equ	$393E8
AddFramer	equ	$393FA
rtss2	equ	$3C000
RestoreTeamEnergy	equ	$3C9B6
Fprintsmall	equ	$3CEBE
AdvanceStringPtr	equ	$3CEC6
setpersonel	equ	$3D426
setupIceRinkPal	equ	$3EC60
setupEASportsMap	equ	$3EC78
ReloadEnergyBarTiles	equ	$3EC94
ReloadCrowdTiles	equ	$3ECA6
setplayercolors	equ	$3F24C
GetShifter	equ	$4081C
ReadTeamStats	equ	$408E0
getname	equ	$4112E
FormatPlayerNumInitial	equ	$41192
FormatPlayerName	equ	$411D6
FormatPlayerNameShort	equ	$41226
Penaltylist	equ	$4165C
linelist	equ	$419F6
PlayerPositionText	equ	$41A20
PerLabels	equ	$41A34
PAttribColumns	equ	$41C48
GAttribColumns	equ	$41DAA
PauseText2	equ	$420DC
LineEditorMenuText	equ	$427D8
LineEditorMenuNoLoad	equ	$42848
LoadHomeTeamGfx	equ	$2A9D0
forceblack	equ	$36D0A
Sroot	equ	$3708E
waitx	equ	$372D0
Vmaddr	equ	$3871E
DecompressGraphicsWithRemap	equ	$38946
DecompressGraphicsPlain	equ	$38958

	org	$2C660

;	Stats screens. Each one runs as an item of the pause menu: scores, the line editor, team
;	roster, scoring and penalty summaries, player and playoff stats, the crowd meter with the
;	arena and league records, the timeout and goalie selection.

ShowScores							;"Scores" screen: the other games of the night in gstruct over the Scores
									;bitmap (ScoresMap); up / down scroll, start exits (ExitStatsScreen). Menu
									;item handler (menu lists)
	moveq	#6,d0					;SetupScreen d0/d1: bitmap row offset / height
	moveq	#$1A,d1
	bsr.w	SetupScreen				;set up the screen
	jsr	(printz).l
	String	CC_Font3Pri,5,0
	moveq	#$1E,d0
	moveq	#6,d1
	jsr	(Framer).l					;draw the frame
	jsr	(printbigz).l
	String	CC_Font3Pri,$E,3,'Scores',CC_Font3Pri,$B,1
;CD: no cartridge twin
	movea.l	(ScoresMapPtr).l,a1
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
	clr.w	(VertLineScrolling).l
	bsr.w	UpdateVertScrollReg
	jsr	(GetShifter).l				;d1 = number of games to list
	move.w	d1,d3					;d3 = games - 1 (GetShifter)
	ble.w	.skip					;no other games: nothing to list
.game								;print each game
	bsr.w	DisplayGameInfo
	dbf	d3,.game					;next game
.skip								;all games printed
	clr.w	(SelectedPlayerIdx).l	;max scroll = 0 unless the list is long
	move.w	(printy).l,d0
	subi.w	#$15,d0					;rows printed past row $15 can be scrolled to
	bmi.w	.loop					;list fits on the screen: no scrolling
	asl.w	#3,d0					;8 pixels per row
	move.w	d0,(SelectedPlayerIdx).l
	bsr.w	DrawScrollArrows
.loop								;each frame: read the pad
	bsr.w	MenuWaitVblank			;wait for the next frame
	bsr.w	getpzjoy				;read the pads
	btst	#7,d3					;start: leave
	bne.w	ExitStatsScreen
	moveq	#-2,d0					;up: scroll -2 pixels a frame
	btst	#0,d3					;up?
	bne.w	.set
	neg.w	d0
	btst	#1,d3					;down?
	beq.w	.scroll
.set								;up or down: scroll by d0 each frame
	move.w	d0,(PlayerScrollCtr).l
.scroll								;nothing pressed: carry on any scroll still moving
	bsr.w	UpdateScoresScroll
	bra.w	.loop
UpdateScoresScroll					;Called every frame by ShowScores: add PlayerScrollCtr to
									;VertLineScrolling (0 ... SelectedPlayerIdx), stop
									;on a 24 line boundary (DrawScrollArrows). Falls into UpdateVertScrollReg
	move.w	(PlayerScrollCtr).l,d0
	beq.w	rtss8
	add.w	(VertLineScrolling).l,d0	;new position
	bmi.w	rtss8					;would pass the top: stop
	cmp.w	(SelectedPlayerIdx).l,d0
	bgt.w	rtss8					;would pass the bottom: stop
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divu.w	#$18,d0					;3 rows of 8 pixels
	swap	d0
	tst.w	d0
	bne.w	UpdateVertScrollReg		;not on a 3 row boundary yet
	bsr.w	DrawScrollArrows
	clr.w	(PlayerScrollCtr).l
UpdateVertScrollReg					;VSRAM word 1 = VertLineScrolling - $30
	move.w	(disflags).l,-(sp)
	bset.b	#dfng,(disflags).l		;don't int graphics
	movea.l	#Vdata,a0				;a0 = VDP data port
;CD: no cartridge twin
.L2C780
	btst.b	#$7,$FF800E.l
	bne.s	.L2C780
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2C7A4
	btst.b	#$6,$FF800E.l
	beq.s	.L2C7A4
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2C7BE
	btst.b	#$6,$FF800E.l
	bne.s	.L2C7BE
	bclr.b	#$7,$FF800F.l
	move.w	#$FFD0,d0
	add.w	(VertLineScrolling).l,d0
.L2C7DA
	btst.b	#$7,$FF800E.l
	bne.s	.L2C7DA
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2C7FA
	btst.b	#$6,$FF800E.l
	beq.s	.L2C7FA
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2C814
	btst.b	#$6,$FF800E.l
	bne.s	.L2C814
	bclr.b	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
DisplayGameInfo						;Print game d3 of gstruct (16 bytes each; not the current game gamenum,
									;not one with flag bit 1 or 2 set)
									;the two teams and scores (PrintGameInfo) and the period (PerLabels)
	cmp.w	(gamenum).l,d3
	beq.w	rtss8					;the current game is not listed
	moveq	#gssize,d0				;bytes per game
	mulu.w	d3,d0
	movea.l	#(gstruct-M68K_RAM),a0
	adda.w	d0,a0					;a0 = this game
	btst.b	#gsfhl,gsflags(a0)
	bne.w	rtss8					;(highlighted game: not shown)
	btst.b	#gsfso,gsflags(a0)
	bne.w	rtss8					;(series over: not shown)
	move.w	gst2(a0),d0				;first team / score
	move.w	gss2(a0),d1
	bsr.w	PrintGameInfo			;print it
	addi.w	#1,(printy).l
	move.w	0(a0),d0				;second team / score
	move.w	gss1(a0),d1
	bsr.w	PrintGameInfo			;print it
	move.w	gsper(a0),d0			;period, 1 based
	subi.w	#1,d0
	movea.l	#PerLabels,a1			;period names
	move.w	#$1C,(printx).l
	jsr	(Fprintsmall).l				;print the period
	addi.w	#2,(printy).l			;two rows down
	rts
PrintGameInfo						;Print team d0's name (TeamList) at x 6 and score d1 (2 digits) at x $18
	movea.l	#TeamList,a1
	asl.w	#2,d0
	movea.l	(a1,d0.w),a1
	adda.w	Teamname(a1),a1
	move.w	#6,(printx).l
	jsr	(print).l
	move.w	#$18,(printx).l
	move.w	d1,d0
	moveq	#2,d1					;2 digits
	jsr	(PushNumberWidth).l
	jmp	(print).l
DrawScrollArrows					;ShowScores up / down arrows (ScrollArrowTable). Saves d0-d1/a1
	movem.l	d0-d1/a1,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,3,4,6,CC_SetFont,1
	clr.w	d0						;d0 = up arrow flag, d1 = down arrow flag
	move.w	(VertLineScrolling).l,d1
	tst.w	d1
	sgt.b	d0
	neg.b	d0						;1 if scrolled down at all
	cmp.w	(SelectedPlayerIdx).l,d1
	slt.b	d1
	neg.b	d1						;1 if more below
	add.b	d1,d0
	add.b	d1,d0					;string = up + 2*down
	lea	ScrollArrowTable(pc),a1
	jsr	(Fprintsmall).l				;print it
	movem.l	(sp)+,d0-d1/a1
	rts
ScrollArrowTable					;DrawScrollArrows Strings: none, up, down (only 3 entries)
	String	' ',CC_AddX,$FF,CC_AddY,$13,' ',CC_SetFont
	String	'{',CC_AddX,$FF,CC_AddY,$13,' ',CC_SetFont
	String	' ',CC_AddX,$FF,CC_AddY,$13,'}',CC_SetFont
LineEditor							;"Line Editor" screen for team a2: line slot cursor (TestList), C picks a
									;player for the slot from the list, start runs the exit menu
									;(LineEditorExit). OptLine (manual lines off) limits the cursor. Menu item
									;handler
	bset.b	#tmflcc,tmflags(a2)		;set on entry to the line editor
	moveq	#0,d0					;bitmap row 0
	moveq	#$1C,d1
	bsr.w	SetupScreen				;set up the screen
	clr.w	(DispAttribCtr).l		;attribute page 0
	clr.w	(PlayerScrollCtr).l
	move.w	#1,(TestList).l			;cursor = first slot
LineEditorRedraw					;Clear the screen and redraw everything. Also entered from LineEditorExit
	jsr	(printsmallz).l
	String	CC_SetMap,2,CC_SetX,0,CC_SetY
	moveq	#$28,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l
	st.b	(redrawicons).l
	bsr.w	ClearMenuFlags			;clear the highlight colours
LineEditorMenu						;Slot cursor loop: start exits, C picks a player for the slot
									;(SelectLinePlayer), up / down /
									;left / right move the slot cursor (LineCursorTable). Also entered from
									;SelectLinePlayer when it is done
	bsr.w	DrawTeamScreen
	bsr.w	DrawLineIcons
.loop								;each frame: read the pad
	bsr.w	MenuWaitVblank			;wait for the next frame
	bsr.w	getpzjoy				;read the pads
	jsr	(ProcessInputWithRepeat).l
	btst	#7,d1					;start: exit menu
	bne.w	LineEditorExit
	btst	#5,d1					;C: pick a player for this slot
	bne.w	SelectLinePlayer		;C: pick a player for the slot
	moveq	#1,d0
	btst	#1,d1					;down?
	bne.w	.move
	moveq	#-1,d0
	btst	#0,d1					;up?
	bne.w	.move
	moveq	#8,d0					;right: next line (8 slots per line)
	btst	#3,d1					;right?
	bne.w	.move
	moveq	#$FFFFFFF8,d0			;left: previous line
	btst	#2,d1					;left?
	beq.w	.loop
.move								;a direction pressed: move the cursor
	add.w	(TestList).l,d0			;d0 = tentative new slot
	tst.w	(OptLine).l
	beq.w	.set					;manual lines off: free movement
	cmpi.w	#1,d0
	blt.w	.loop					;OptLine set: only slots 1-5
	cmpi.w	#5,d0
	bgt.w	.loop
.set								;slot allowed: look up the slot after the move
	lea	LineCursorTable(pc),a0		;the slot after the move
	move.b	$8(a0,d0.w),(TestList+1).l	;wrap/skip through the table
	bsr.w	DrawLineIcons
	bra.w	.loop
SelectLinePlayer					;Line editor: C pressed on slot TestList. Build the list of players that
									;can go in the slot in Satt (roster order is goalies, forwards, defense)
									;and let the user pick one (left / right pages the attribute columns). C
									;stores the pick with SetLineSlot, start goes back. Both return to
									;LineEditorMenu
	bsr.w	GetGoalieCount
	move.w	d0,d1					;d1 = first forward
	bsr.w	GetForwardCount
	move.w	(TestList).l,d2
	andi.w	#7,d2					;slot within the line
	cmpi.w	#2,d2
	bgt.w	.n						;slots 3-5 (forwards): after the goalies
	add.w	d0,d1					;slots 1-2 (defense): after goalies+forwards
	bsr.w	GetPlayerCount
	sub.w	d1,d0					;d0 = candidates, d1 = first roster index
.n									;candidate range chosen (goalies for slot 0)
	subi.w	#1,d0					;count - 1 for dbf
	move.w	d0,(screentimer).l		;last candidate row (also the dbf count)
	clr.w	(PlayerScrollCtr).l
	clr.w	(VertLineScrolling).l
	movea.l	#(Satt-M68K_RAM),a0
	clr.w	d2
.fill								;list every candidate's roster index
	move.b	d1,(a0,d2.w)			;store the roster index
	cmp.w	d1,d6					;player now in the slot?
	bne.w	.nc
	move.w	d2,(VertLineScrolling).l	;start the cursor on him
.nc									;not in the slot now
	addi.w	#1,d1					;next candidate
	addi.w	#1,d2
	dbf	d0,.fill					;loop
	bsr.w	ClearLineEditorTop		;clear the top area
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,0,3,1,0
	moveq	#$12,d0
	moveq	#3,d1
	jsr	(Framer).l					;draw the frame
	jsr	(printsmallz).l
	String	CC_SetX,$15,CC_SetY
	moveq	#$12,d0
	moveq	#3,d1
	jsr	(Framer).l					;draw the frame
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,2,2,1,'{Select  Player}'
	clr.w	d0						;draw the list with the cursor
	bra.w	.vert
.loop								;each frame: read the pad
	bsr.w	MenuWaitVblank			;wait for the next frame
	bsr.w	getpzjoy				;read the pads
	jsr	(ProcessInputWithRepeat).l
	btst	#7,d1					;start: back to slot cursor
	bne.w	LineEditorMenu
	btst	#5,d1					;C: take this player
	bne.w	.pick
	moveq	#1,d0
	btst	#1,d1
	bne.w	.vert
	btst	#3,d1					;right: next attribute page
	bne.w	.horz
	moveq	#-1,d0
	btst	#0,d1
	bne.w	.vert
	btst	#2,d1					;left: previous attribute page
	bne.w	.horz
	bra.w	.loop
.horz								;left / right: change the attribute page
	add.w	(DispAttribCtr).l,d0	;change attribute page (not below 0)
	bmi.w	.loop					;below 0: ignore
	move.w	d0,(DispAttribCtr).l
	bsr.w	PrintAttribHeader
.back								;(not branched to)
	bra.w	.loop
.vert								;up / down: move the cursor row
	add.w	(VertLineScrolling).l,d0	;Cursor row 0..screentimer
	bmi.w	.loop					;above the top: ignore
	cmp.w	(screentimer).l,d0		;past the last?
	bgt.w	.loop
	move.w	d0,(VertLineScrolling).l
.first								;(not branched to)
	cmp.w	(PlayerScrollCtr).l,d0	;above the first row shown?
.chkfirst							;(not branched to)
	bgt.w	.top
	move.w	d0,(PlayerScrollCtr).l	;scroll up to it
.top								;cursor not above the first row shown
	subi.w	#5,d0					;6 rows shown
	cmp.w	(PlayerScrollCtr).l,d0	;below the last row shown?
	ble.w	.draw
	move.w	d0,(PlayerScrollCtr).l	;scroll down to it
.draw								;cursor inside the 6 rows shown: redraw
	bsr.w	PrintAttribHeader
	bra.w	.loop
.pick								;C: put the player in the slot
	movea.l	#(Satt-M68K_RAM),a3		;C: chosen row's roster index
	adda.w	(VertLineScrolling).l,a3
	move.b	(a3),d0
	addi.b	#1,d0					;SetLineSlot wants 1 based
	move.w	(TestList).l,d2
	bsr.w	SetLineSlot				;put the picked player in the slot
	bra.w	LineEditorMenu			;back to the slot cursor
PrintAttribHeader					;Line editor player list: the column header of attribute page
									;DispAttribCtr, then 6 rows of names and that attribute, the selected row
									;highlighted
	jsr	(printz).l
	String	CC_Font2Pri,$16,1
.top								;(also re-entered when the page is past the end)
	movea.l	#PAttribColumns,a1		;list of column entries: word length, 4 byte flags, text
	move.w	(DispAttribCtr).l,d0
	bra.w	.2
.next								;skip one column entry: text + flags
	adda.w	(a1),a1
;CD: no cartridge twin
	adda.w	#$4,a1
.2									;is this the page?
	tst.w	(a1)					;Negative = end of list
	dbmi	d0,.next
	bpl.w	.found
	subi.w	#1,(DispAttribCtr).l	;past the last page: back one
	bra.w	.top
.found								;page found: print its header
	jsr	(print).l
	move.l	(a1),d4					;column flags for GetNameandAttrib
	movea.l	#(Satt-M68K_RAM),a3
	move.w	(PlayerScrollCtr).l,d2	;d2 = first row shown
	move.w	(screentimer).l,d1
	sub.w	d2,d1					;rows below the first shown
	cmpi.w	#5,d1
	bls.w	.4
	moveq	#5,d1					;at most 6 rows
.4									;row count set
	move.w	#2,(printy).l
.row								;each row shown
	jsr	(printsmallz).l
	String	CC_SetAttribute,4,CC_SetX,5,CC_AddY,1,'                      ',CC_SetX,5
	cmp.w	(VertLineScrolling).l,d2	;cursor row?
	bne.w	.5
	move.w	d7,(printa).l			;use the highlight attribute
.5									;cursor row highlighted, others normal
	clr.w	d0
	move.b	(a3,d2.w),d0			;roster index
	bsr.w	GetNameandAttrib		;print his name and attributes
	addi.w	#1,d2
	dbf	d1,.row						;loop
	rts
DrawLineIcons						;Line editor: draw the line icons for the cursor's line (LineIconGroups
									;bit masks, DrawLineIcon), then the selected player box
	moveq	#6,d5					;7 lines
	lea	LineIconGroups(pc),a0
	move.w	(TestList).l,d0
	lsr.w	#3,d0					;line number
	adda.w	d0,a0					;this line's group
	tst.w	(OptLine).l
	beq.w	.0
;CD: no cartridge twin
	suba.w	#$1,a0
.0									;group table chosen
	move.b	(a0),d0					;group mask for this line
	cmp.b	(redrawicons).l,d0
	beq.w	.line					;same group as last time: no clear
	move.b	d0,(redrawicons).l
	bsr.w	ClearLineArea
.line								;draw every line of the group
	btst.b	d5,(redrawicons).l		;Line d5 in this group?
	beq.w	.2
	bsr.w	DrawLineIcon
.2									;not in the group: next line
	dbf	d5,.line					;loop
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,2,8,7,CC_SetFont,1
	moveq	#$18,d0
	moveq	#3,d1
	jsr	(Framer).l					;draw the frame
	jsr	(printsmallz).l
	String	CC_SetX,$15,CC_SetY,8
	move.w	d6,d0					;name of the cursor slot's player
	jsr	(getname).l
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).l			;...used to centre it
	move.w	d7,(printa).l
	jsr	(printsmall).l				;print it
	clr.w	(printfontset).l
	rts
	dc.b	1						;the entry before LineIconGroups (read with OptLine set)
LineIconGroups						;Per line: bit mask of the lines drawn together
	dc.b	7,7,7,$18,$18,$60,$60
DrawLineIcon						;Line editor: draw line d5 (its name from linelist, then its player slots)
									;at LineIconPosTable (OptLine: the entry before)
	moveq	#6,d0					;6 bytes per entry
	mulu.w	d5,d0
	lea	LineIconPosTable(pc),a0		;position table
	adda.w	d0,a0
	tst.w	(OptLine).l
	beq.w	.0
;CD: no cartridge twin
	suba.w	#$6,a0
.0									;position table chosen
	move.w	(a0),(printx).l			;x, y of the entry
	move.w	2(a0),(printy).l
	move.w	d5,d0					;line name string index
	movea.l	#linelist,a1
	move.w	#$8000,(printa).l		;priority
	jsr	(Fprintsmall).l				;print the line name
	jsr	(printsmallz).l
	String	' Line'
	move.w	(a0),(printx).l
	move.w	d5,d4
	asl.w	#3,d4					;8 slots per line
	addi.w	#1,d4					;slots are 1-5 (LD RD LW C RW)
	move.w	2(a0),(printy).l
	move.w	4(a0),d3				;slot count - 1
	lea	tmlines(a2),a3
.slot								;each slot of the line
	move.w	(a0),(printx).l
	jsr	(printsmallz).l
	String	CC_AddX,$FF,CC_AddY,2,CC_SetAttribute,6
	clr.w	d0
	move.b	(a3,d4.w),d0			;player in this slot
	subi.w	#1,d0					;0-based
	jsr	(FormatPlayerNameShort).l
	cmp.w	(TestList).l,d4			;cursor slot?
	bne.w	.nocur
	move.w	d0,d6					;player in the cursor slot
	move.w	(printa).l,d7
	move.w	#2,(printfontset).l		;highlight while printing
.nocur								;cursor slot highlighted, others normal
	jsr	(printsmall).l				;print it
	clr.w	(printfontset).l
	addi.w	#1,d4
	dbf	d3,.slot					;loop
	rts
ClearLineArea						;Line editor: erase the line area and print the
									;position header (LD RD LW C RW)
	jsr	(printsmallz).l
	String	CC_SetMap,2,CC_SetX,0,CC_SetY,$A
.erase								;(not branched to)
	moveq	#$28,d0
	moveq	#$12,d1
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l
	move.w	(LineIconPosTable+2).l,(printy).l
	move.w	(LineIconPosTable).l,(printx).l
	tst.w	(OptLine).l				;OptLine set?
	beq.w	.0
	move.w	(LineIconPosTable-6).l,(printx).l	;OptLine: use the entry before
.0									;entry chosen: print the position header
	jsr	(printsmallz).l
	String	CC_SetAttribute,$04,CC_AddX,$FD,CC_AddY,$02,'LD',CC_AddX,$FE,CC_AddY,$02,'RD',CC_AddX,$FE,CC_AddY,$02,'LW',CC_AddX,$FE,CC_AddY,$02,'C ',CC_AddX,$FE,CC_AddY,$02,'RW'
	rts
DrawTeamScreen						;Line editor background: bitmap (EASportsBGMap), frame, "Line Editor"
									;title and
									;the team logo map (PutTeamBlock)
	bsr.w	ClearLineEditorTop
	movem.l	d0-d5/a0-a2,-(sp)
	jsr	(printz).l
	String	CC_Font3,0,0
;CD: no cartridge twin
	movea.l	(EASportsBGMapPtr).l,a1
	adda.l	jimdata(a1),a1
	movea.l	#null,a2				;a2 saved/restored around this block
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	moveq	#1,d4
	moveq	#0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d5/a0-a2
	jsr	(printz).l
	String	CC_Font2Pri,7,1
	moveq	#$1A,d0
	moveq	#6,d1
	jsr	(Framer).l					;draw the frame
	jsr	(printbigz).l
;CD: no cartridge twin
	dc.w	$0014,$BE0A
	dc.w	$044C
	dc.b	'ine Editor'
	dc.w	$BE0E
	btst	d0,d0
	clr.w	d0						;map offset: home 0, away $2C
	cmpa.l	#$1834C,a2				;home team? (CD: the cartridge has #(tmstruct-M68K_RAM))
	beq.w	PutTeamBlock
;CD: no cartridge twin
	moveq	#$2C,d0
	bra.w	PutTeamBlock
ClearLineEditorTop					;Erase 40 x 10 at the top of map 2
	jsr	(printz).l
	String	CC_Font2Pri,0,0
	moveq	#$28,d0
	moveq	#$A,d1
	move.w	#$7FF,d2				;blank char
	jmp	(eraser).l
ClearMenuFlags						;Clear palfadenew+$5A and palfadenew+$7A
	clr.w	(palfadenew+$5A).l		;clear one highlight colour
	clr.w	(palfadenew+$7A).l
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
	bsr.w	ClearMenuFlags			;clear the highlight colours
	move.w	#$18,(palcount).l		;fade over $18 frames
;CD: no cartridge twin
.L2CF14
	tst.w	(palcount).l
	bpl.w	.L2CF14
	move.l	(menuitem).l,-(sp)		;save the menu state
	move.l	(menulist).l,-(sp)
	move.l	(menudraw).l,-(sp)
	movea.l	#rtss2,a1
	movea.l	#LineEditorMenuText,a0
	movea.l	#$18C26,a3				;saved line data (CD: the cartridge has #(databuffer-M68K_RAM))
	move.w	tmteam(a2),d0			;team number + 1 = first databuffer byte?
	addi.w	#1,d0
	cmp.b	(a3),d0					;this team's data?
	beq.w	.0
	movea.l	#LineEditorMenuNoLoad,a0	;no load option for another team's data
.0									;menu with or without the load option
	jsr	(printsmallz).l				;small font at the menu position
	String	CC_SetMap,2
	bsr.w	Pausemode_top
.loop								;each frame: run the exit menu
	bsr.w	MenuWaitVblank			;wait for the next frame
	bsr.w	getpzjoy				;read the pads
	jsr	(ProcessInputWithRepeat).l
	move.w	d1,-(sp)
	bsr.w	HandleMenuInput
	move.w	(sp)+,d1
	andi.w	#$A0,d1
	beq.w	.loop
	jsr	(printsmallz).l				;small font at the menu position
	String	CC_SetFont
	move.w	(menuitem).l,d0
	move.l	(sp)+,(menudraw).l		;restore the menu state
	move.l	(sp)+,(menulist).l
	move.l	(sp)+,(menuitem).l
	tst.w	d0						;item 0?
	bne.w	LineEditorRedraw		;no: back to the editor
	bra.w	ExitStatsScreen
SetLineSlot							;Put player d0 (1 based) in line slot d2 of team a2; if he is already in
									;another slot of the same line, the old occupant of d2 moves there (swap)
	movem.l	d0-d2/a0-a1,-(sp)
	lea	tmlines(a2),a0				;a0 = team line table (8 bytes per line)
	move.w	d2,d1
	andi.w	#$FFF8,d1				;start of its line
	lea	(a0,d1.w),a1				;a1 = the line
	moveq	#5,d1
.find								;look for player d0 in the line
	cmp.b	$1(a1,d1.w),d0			;is player d0 already in this line?
	dbeq	d1,.find
	bne.w	.put					;not there: just put him in
	move.b	(a0,d2.w),$1(a1,d1.w)	;already in the line: move the old occupant to his slot
.put								;put the player in the slot
	move.b	d0,(a0,d2.w)			;player into the slot
	movem.l	(sp)+,d0-d2/a0-a1
	rts
DecodeTeamLines						;Load team a2's lines from databuffer: byte 0 = team + 1, then one nibble
									;per slot in AttributeOffsetTbl order, relative to the first forward (or
									;defenseman for slots 1-2). Menu item handler
	movem.l	d0-d4/a0/a3,-(sp)
	movea.l	#$18C26,a0				;saved line data (CD: the cartridge has #(databuffer-M68K_RAM))
;CD: no cartridge twin
	adda.w	#$1,a0
	bsr.w	GetGoalieCount
	move.w	d0,d1
	bsr.w	GetForwardCount
	move.w	d0,d3
	movea.l	#AttributeOffsetTbl,a3
	clr.w	d4
	clr.w	d2
.next								;each slot in AttributeOffsetTbl order
	move.b	(a3),d2					;d2 = next slot from AttributeOffsetTbl
	bmi.w	.done
	bchg	#0,d4					;d4 bit 0 toggles low/high nibble
	bne.w	.hi
	move.b	(a0),d0					;first nibble of the byte: low
	bra.w	.nib
.hi									;second slot of the byte: high nibble
	move.b	(a0)+,d0				;high nibble, next byte
	lsr.w	#4,d0
.nib								;nibble ready
	andi.w	#$F,d0					;nibble value
	add.b	d1,d0
	andi.w	#7,d2					;slot within the line
	cmpi.w	#2,d2					;defense?
	bgt.w	.store					;slots 3-5 are forwards
	add.b	d3,d0					;slots 1-2 defense: + forward count
.store								;forward slot, or defense with the forward count added
	addi.b	#1,d0					;1 based player number
	andi.w	#$FF,d0
	move.b	(a3)+,d2				;d2 = slot index
	bsr.w	SetLineSlot				;put him in the slot
	bra.w	.next
.done								;exit: restore the registers
	movem.l	(sp)+,d0-d4/a0/a3
	rts
EncodeTeamLines						;Reverse of DecodeTeamLines: pack team a2's lines into databuffer and
									;convert it (WriteLineData, high ROM). Menu item handler
	movem.l	d0-d4/a0-a3,-(sp)
	movea.l	#$18C26,a0				;saved line data (CD: the cartridge has #(databuffer-M68K_RAM))
	move.w	tmteam(a2),d0
	addi.w	#1,d0
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
	move.b	(a1,d2.w),d3			;player in the slot
	subi.b	#1,d3					;0-based
	sub.b	d1,d3					;relative to the first non-goalie
	andi.w	#7,d2
	cmpi.w	#2,d2					;defense?
	bgt.w	.pack
	sub.b	d0,d3					;slots 1-2: also minus forward count
.pack								;forward slot, or defense made relative to the first defenseman
	bchg	#0,d4					;alternate low / high nibble
	bne.w	.hi
	move.b	d3,(a0)					;low nibble (high is or'ed in next)
	bra.w	.next
.hi									;second slot of the byte: high nibble
	asl.b	#4,d3					;second nibble goes in the high half
	or.b	d3,(a0)+
	bra.w	.next
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
	moveq	#$D,d0					;bitmap row $D
	moveq	#$17,d1
	bsr.w	SetupScreen				;set up the screen
	moveq	#1,d0
	add.w	tmline(a2),d0			;start on the current line
	move.w	d0,(SelectedPlayerIdx).l	;page 0 = goalies, 1.. = lines
	clr.w	(DispAttribCtr).l		;attribute page 0
.redraw								;(also the target after A switches teams)
	jsr	(printz).l
	String	CC_Font3Pri,7,1
	moveq	#$1A,d0
	moveq	#6,d1
	jsr	(Framer).l					;draw the frame
	jsr	(printbigz).l
	String	CC_Font3Pri,9,4,'Team  Roster',CC_Font3Pri,$E,1
	clr.w	d0						;logo map offset: home 0, away $2C
	cmpa.l	#$1834C,a2				;home team? (CD: the cartridge has #(tmstruct-M68K_RAM))
	beq.w	.home
;CD: no cartridge twin
	moveq	#$2C,d0
.home								;home team at 0, away at $2C
	bsr.w	PutTeamBlock
.header								;(not branched to)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$06,$03,$02,$0C,CC_SetFont,$01,'Pos.^Player',CC_SetX,$1E,CC_SetY,$0C,'Rating',CC_SetX,$0C,CC_SetY,$1A,'A^-^Switch^Teams',CC_SetFont
	jsr	(printz).l
	String	CC_Font3Pri,1,8
	moveq	#$12,d0
	moveq	#3,d1
	jsr	(Framer).l					;draw the frame
	jsr	(printz).l
	String	CC_Font3Pri,$15,8
	moveq	#$12,d0
	moveq	#3,d1
	jsr	(Framer).l					;draw the frame
	bsr.w	DisplayPlayerList		;draw the current page
	move.w	(SelectedPlayerIdx).l,d0
	mulu.w	#$80,d0					;128 pixels per line page
	move.w	d0,(VertLineScrolling).l
	bsr.w	UpdatePlayerListScroll	;set the scroll register for it
	clr.w	(PlayerScrollCtr).l
.loop								;each frame: read the pad
	bsr.w	MenuWaitVblank			;wait for the next frame
.pad								;(not branched to)
	bsr.w	getpzjoy				;read the pads
.repeat								;(not branched to)
	jsr	(ProcessInputWithRepeat).l
.start								;(not branched to)
	btst	#7,d3					;start?
	bne.w	ExitStatsScreen
.abut								;(not branched to)
	btst	#6,d1					;A?
.chka								;(not branched to)
	bne.w	.team
	jsr	(nodiag).l
	moveq	#1,d0
.right								;(not branched to)
	btst	#3,d1					;right?
.chkright							;(not branched to)
	bne.w	.col
	neg.w	d0
	btst	#2,d1					;left?
	bne.w	.col					;previous column page
	tst.w	(PlayerScrollCtr).l
	bne.w	.scroll
	moveq	#-2,d0
	btst	#0,d3					;up?
	bne.w	.set
	neg.w	d0
	btst	#1,d3					;down?
	beq.w	.scroll
.set								;up or down: scroll by d0 each frame
	move.w	d0,(PlayerScrollCtr).l
.scroll								;nothing new pressed: carry on any scroll still moving
	bsr.w	CheckPlayerListScroll
	bra.w	.loop
.col								;left / right: change the attribute column page
	add.w	(DispAttribCtr).l,d0	;new attribute column page (not below 0)
	bmi.w	.scroll					;below 0: ignore
	move.w	d0,(DispAttribCtr).l
	bsr.w	DisplayPlayerList
	bra.w	.scroll
.team								;A: the other team
	lea	tmsize(a2),a2
	cmpa.l	#$186B2,a2				;was the home team? (CD: the cartridge has #(awtmstruct-M68K_RAM))
	beq.w	.redraw					;yes: show the away team
	movea.l	#$1834C,a2				;away -> back to home (CD: the cartridge has #(tmstruct-M68K_RAM))
	bra.w	.redraw
CheckPlayerListScroll				;TeamRosterScreen per frame: add PlayerScrollCtr to VertLineScrolling (0
									;... $380)
	move.w	(PlayerScrollCtr).l,d0
	beq.w	rtss8
	add.w	(VertLineScrolling).l,d0	;new position
	bmi.w	StopPlayerListScroll
	cmpi.w	#$380,d0				;past the last page?
	bgt.w	StopPlayerListScroll
UpdatePlayerListScroll				;Set VertLineScrolling = d0. Stop on a page boundary ($80), draw the page
									;coming into view, VSRAM = VertLineScrolling - $70
	move.w	(VertLineScrolling).l,d1	;d1 = old position
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divs.w	#$80,d0					;low word of d0 after swap = offset within the page
	swap	d0
	tst.w	d0
	bne.w	.0						;between pages
	clr.w	(PlayerScrollCtr).l		;exactly on a page: stop
.0									;between pages: keep scrolling
	andi.w	#$7F,d1					;was the old position on a page boundary?
	bne.w	.2
	cmpi.w	#$7E,d0					;moved back 2 pixels: draw previous page
	bne.w	.1
	bsr.w	DisplayPlayerListUp		;draw the previous page
.1									;not moving up
	cmpi.w	#2,d0					;moved on 2 pixels: draw next page
	bne.w	.2
	bsr.w	DisplayPlayerListDown	;draw the next page
.2									;only on the first step off a page boundary
	move.w	(disflags).l,-(sp)		;set the VSRAM scroll value
	bset.b	#dfng,(disflags).l
	movea.l	#Vdata,a0
;CD: no cartridge twin
.L2D2B8
	btst.b	#$7,$FF800E.l
	bne.s	.L2D2B8
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2D2DC
	btst.b	#$6,$FF800E.l
	beq.s	.L2D2DC
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2D2F6
	btst.b	#$6,$FF800E.l
	bne.s	.L2D2F6
	bclr.b	#$7,$FF800F.l
	move.w	#$FF90,d0
	add.w	(VertLineScrolling).l,d0
.L2D312
	btst.b	#$7,$FF800E.l
	bne.s	.L2D312
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2D332
	btst.b	#$6,$FF800E.l
	beq.s	.L2D332
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2D34C
	btst.b	#$6,$FF800E.l
	bne.s	.L2D34C
	bclr.b	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
StopPlayerListScroll				;Out of range: stop scrolling
	clr.w	(PlayerScrollCtr).l
	rts
DisplayPlayerListUp					;d0 = divs result (quotient in the high word): draw that page
	move.l	d0,-(sp)
	swap	d0
	move.w	d0,(SelectedPlayerIdx).l
	bsr.w	DisplayPlayerList
	move.l	(sp)+,d0
	rts
DisplayPlayerListDown				;Draw the page after the quotient in the high word of d0
	move.l	d0,-(sp)
	swap	d0
	addi.w	#1,d0					;next page
	move.w	d0,(SelectedPlayerIdx).l
	bsr.w	DisplayPlayerList
	move.l	(sp)+,d0
	rts
DisplayPlayerList					;Draw roster page SelectedPlayerIdx (0 goalies, 1-7 lines): title
									;(PlayerStatMenuTxt), column header, then
									;the rows (GoalieRowText / PlayerPositionText, getNameandAttrib)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,7,3,2,9,CC_SetFont,1
	move.w	(SelectedPlayerIdx).l,d0
	lea	PlayerStatMenuTxt(pc),a1	;page titles
	jsr	(AdvanceStringPtr).l		;a1 = this page's title
	jsr	(printsmall).l				;print it
	jsr	(printsmallz).l
	String	CC_SetX,$16,CC_SetY,9
.top								;(also re-entered when the page is past the end)
	movea.l	#PAttribColumns,a1		;skater column list (goalie page: GAttribColumns)
	move.w	(DispAttribCtr).l,d0	;attribute page
	tst.w	(SelectedPlayerIdx).l	;goalie page?
	bne.w	.2
	movea.l	#GAttribColumns,a1
	bra.w	.2						;find the page
.next								;skip one column entry: text + flags
	adda.w	(a1),a1
;CD: no cartridge twin
	adda.w	#$4,a1
.2									;is this the page?
	tst.w	(a1)					;negative = end of list
	dbmi	d0,.next
	bpl.w	.found
	subi.w	#1,(DispAttribCtr).l	;past the last page: back one and retry
	bra.w	.top
.found								;page found: print its header
	jsr	(printsmall).l				;print the header
	move.l	(a1),d4
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,2,0,0,CC_SetFont,0
	btst.b	#0,(SelectedPlayerIdx+1).l	;odd pages are 16 rows lower
	beq.w	.4
	addi.w	#$10,(printy).l			;16 rows lower
.4									;page area chosen
	move.w	(printy).l,-(sp)		;erase the page area first
	moveq	#$28,d0
	moveq	#$10,d1
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l
	move.w	(sp)+,(printy).l
	bsr.w	GetGoalieCount
	move.w	d0,d1
	subi.w	#1,d1					;goalie page: one row per goalie
	movea.l	#GoalieRowText,a5		;a5 = position label strings
	movea.l	#(Satt-M68K_RAM),a3		;goalie page: players 1-4
	move.l	#$1020304,(a3)
	move.w	(SelectedPlayerIdx).l,d0
	subi.w	#1,d0					;line number
	bmi.w	.row
	asl.w	#3,d0					;8 bytes per line
	lea	tmlines(a2),a3				;a3 = player numbers of that line (skip byte 0)
	lea	$1(a3,d0.w),a3				;skip the first byte
	movea.l	#PlayerPositionText,a5
	moveq	#4,d1					;5 positions
	cmpi.w	#5,(SelectedPlayerIdx).l	;penalty kill line?
	ble.w	.row
	subi.w	#1,d1					;penalty kill lines: 4
.row								;rows set up (goalies, lines, or 4-man penalty kill)
	move.w	#2,(printx).l
	movea.l	a5,a1					;position text
	jsr	(print).l
	movea.l	a1,a5					;next position text
	move.w	#7,(printx).l			;then name and column value
	clr.w	d0
	move.b	(a3)+,d0
	subi.w	#1,d0					;0 based player index
	bsr.w	GetNameandAttrib
	addi.w	#2,(printy).l			;2 text rows per player
	dbf	d1,.row						;loop
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
	pea	.x(pc)						;handlers return here
	jsr	(getname).l					;a1 = his number and name
	jsr	(print).l
	move.w	#$1E,(printx).l
	cmpi.w	#2,d4					;status or energy column?
	bls.w	.jump
	jsr	(CalcAttrib).l
	swap	d4
.jump								;column handler for d4
	lea	attribjmp(pc),a0
	adda.w	(a0,d4.w),a0			;this handler
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
	add.w	d0,d0
	move.w	tmpdst(a2,d0.w),d0		;his status
	bpl.w	.pen					;positive: serving a penalty
	not.w	d0
	cmpi.w	#3,d0					;valid?
	bls.w	.st
	moveq	#1,d0					;anything else shown as Bench
	bra.w	.st						;print it
.inj								;injured: status 3
	moveq	#3,d0					;Injured
.st									;print the status text
	lea	StatusTextTbl(pc),a1
	jmp	(Fprintsmall).l				;print it
.pen								;penalty time, or injured goalie
	btst	#$C,d0					;bit $C: injured goalie
	bne.w	.inj
	subi.w	#1,(printx).l
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
	jmp	(Fprintsmall).l				;print it
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
	cmpi.w	#$64,d0					;over 100?
	ble.w	AttribPrintPct
	moveq	#$64,d0
	bra.w	AttribPrintPct			;print it
AttribFighting						;Bit 0 of the nibble is the handedness: drop it, then a rating out of d1 -
									;1
	andi.w	#$E,d0					;jump for fighting attrib - ignore bit 0 (remove Handedness)
	subi.w	#1,d1					;sub 1 from d1
AttribRating						;d0 * 100 / d1, adjusted (AttribAdjust, high ROM); falls into
									;AttribPrintPct
	mulu.w	#$64,d0					;mult by 100 dec
	divu.w	d1,d0					;divide by d1 (usually 100 dec)
	jsr	(AttribAdjust).l
AttribPrintPct						;Print d0 4 wide, then 4 blanks
	moveq	#4,d1					;4 digits
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	'    '
	rts
AttribHanded						;Bit 0 of the sum: Righty / Lefty (HandedTextTbl)
	andi.w	#1,d0
	eori.w	#1,d0					;0 Righty, 1 Lefty
	lea	HandedTextTbl(pc),a1
	jmp	(Fprintsmall).l				;print it
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
	bsr.w	SetupScreen				;set up the screen
	jsr	(printz).l
	String	CC_Font3Pri,4,1
	moveq	#$20,d0
	moveq	#6,d1
	jsr	(Framer).l					;draw the frame
	jsr	(printbigz).l
	String	CC_Font3Pri,6,4,'Scoring Summary',CC_Font3Pri,7,1
;CD: no cartridge twin
	moveq	#$2C,d0
	bsr.w	PutTeamBlock
	addi.w	#4,(printx).l			;4 columns right
	clr.w	d0
	bsr.w	PutTeamBlock
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,6,3,0,8,CC_SetFont,1,'^Per^^Time^^Tm^^Goal/Assist^^^^^^^^P/S^^',CC_SetFont,0
	clr.l	d0
	move.w	(ScoreSumbytes).l,d0
	divu.w	#6,d0					;goals
	asl.w	#5,d0					;32 pixels per entry
	move.w	d0,(VertLineScrolling).l	;start at the end
	subi.w	#$80,d0					;4 entries fit on screen
	bpl.w	.0
	clr.w	d0
.0									;scroll limit set
	move.w	d0,(SelectedPlayerIdx).l
	move.w	(VertLineScrolling).l,d0	;start position
.toend								;loop
	bsr.w	MenuWaitVblank			;wait for the next frame
	bsr.w	UpdateScoringScroll
	move.w	(VertLineScrolling).l,d0	;position
	subi.w	#2,d0
	cmp.w	(SelectedPlayerIdx).l,d0	;reached the limit?
	bge.w	.toend
	clr.w	(PlayerScrollCtr).l
.loop								;loop
	bsr.w	MenuWaitVblank			;wait for the next frame
	bsr.w	getpzjoy				;read the pads
	btst	#7,d3					;start: leave
	bne.w	ExitStatsScreen
	moveq	#-2,d0
	btst	#0,d3					;up?
	bne.w	.set
	neg.w	d0
	btst	#1,d3					;down?
	beq.w	.scroll
.set								;up or down: scroll by d0 each frame
	move.w	d0,(PlayerScrollCtr).l
.scroll								;nothing new pressed: carry on any scroll still moving
	bsr.w	CheckScoringScroll
	bra.w	.loop
CheckScoringScroll					;ScoringSummaryScreen per frame: add PlayerScrollCtr to VertLineScrolling
									;(0 ... SelectedPlayerIdx). Falls into UpdateScoringScroll
	move.w	(PlayerScrollCtr).l,d0
	beq.w	rtss8
	add.w	(VertLineScrolling).l,d0	;new position
	bmi.w	rtss8					;above the top: ignore
	cmp.w	(SelectedPlayerIdx).l,d0	;past the limit?
	bgt.w	rtss8
UpdateScoringScroll					;Set VertLineScrolling = d0. Stop on an entry boundary (32 lines; arrows
									;by DrawScrollArrowsPenalty) draw the entry coming into view, VSRAM =
									;VertLineScrolling - $50
	move.w	(VertLineScrolling).l,d1	;d1 = old position
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divs.w	#$20,d0					;32 pixels per entry; remainder in the low word after swap
	swap	d0
	tst.w	d0						;on a boundary?
	bne.w	.0
	bsr.w	DrawScrollArrowsPenalty	;on an entry boundary: update arrows and stop
	clr.w	(PlayerScrollCtr).l
.0									;between entries: keep scrolling
	andi.w	#$1F,d1					;was the old position on a boundary?
	bne.w	.2
	move.l	d0,-(sp)
	cmpi.w	#$1E,d0					;moved back 2: draw the entry above
	bne.w	.1
	bsr.w	DrawScoringRowUp
.1									;not moving up
	move.l	(sp)+,d0
	cmpi.w	#2,d0					;moved on 2: draw the entry below
	bne.w	.2
	bsr.w	DrawScoringRowDown
.2									;only on the first step off an entry boundary
	move.w	(disflags).l,-(sp)		;set the VSRAM scroll value, as in UpdateVertScrollReg
	bset.b	#dfng,(disflags).l
	movea.l	#Vdata,a0
;CD: no cartridge twin
.L2D858
	btst.b	#$7,$FF800E.l
	bne.s	.L2D858
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2D87C
	btst.b	#$6,$FF800E.l
	beq.s	.L2D87C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2D896
	btst.b	#$6,$FF800E.l
	bne.s	.L2D896
	bclr.b	#$7,$FF800F.l
	moveq	#-80,d0
	add.w	(VertLineScrolling).l,d0
.L2D8B0
	btst.b	#$7,$FF800E.l
	bne.s	.L2D8B0
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2D8D0
	btst.b	#$6,$FF800E.l
	beq.s	.L2D8D0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2D8EA
	btst.b	#$6,$FF800E.l
	bne.s	.L2D8EA
	bclr.b	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
DrawScoringRowUp					;Draw goal entry (d0 high word) at the top of the window
	move.l	d0,-(sp)
	swap	d0						;d0 = entry number (quotient)
	moveq	#6,d3					;6 bytes per entry
	mulu.w	d0,d3					;d3 = byte offset into ScoreSum
	jsr	(printz).l					;map at the row position
	String	CC_Font2Pri,0,0
	move.w	(VertLineScrolling).l,d0
	lsr.w	#3,d0					;scroll position in 8 pixel rows
	subi.w	#3,d0					;row just above the window, wrapped to 32 map rows
	andi.w	#$1F,d0
	move.w	d0,(printy).l
	bsr.w	DrawScoringRow
	move.l	(sp)+,d0
	rts
DrawScoringRowDown					;Draw goal entry (d0 high word) + 4 at the bottom of the window
	move.l	d0,-(sp)
	swap	d0
	addi.w	#4,d0					;entry 4 below the top one
	moveq	#6,d3
	mulu.w	d0,d3					;d3 = byte offset into ScoreSum
	jsr	(printz).l					;map at the row position
	String	CC_Font2Pri,0,0
	move.w	(VertLineScrolling).l,d0
	lsr.w	#3,d0					;scroll position in 8 pixel rows
	addi.w	#$10,d0					;16 rows below the top, wrapped to 32 map rows
	andi.w	#$1F,d0
	move.w	d0,(printy).l
	bsr.w	DrawScoringRow
	move.l	(sp)+,d0
	rts
DrawScoringRow						;Print ScoreSum entry d3: time, team (bit 7 of byte 2 = away), goal type
									;(GoalTypeTbl), scorer and the two assists (PrintScorerName)
	move.w	(printy).l,-(sp)
	moveq	#$28,d0					;width 40 cells
	moveq	#4,d1					;4 rows high
	move.w	#$7FF,d2				;blank tile
	jsr	(eraser).l
	move.w	(sp)+,(printy).l
	movea.l	#(ScoreSum-M68K_RAM),a0
	move.w	(a0,d3.w),d0			;goal time
	move.w	#1,(printx).l
	jsr	(FormatAndPrintTime).l		;print it
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	btst.b	#7,ssflags(a0,d3.w)
	beq.w	.0
	adda.w	#tmsize,a2
.0									;team chosen
	movea.l	tmdata(a2),a1			;team data -> team name string
	adda.w	Teamname(a1),a1
	adda.w	(a1),a1
	move.w	#$C,(printx).l
	jsr	(print).l
	move.w	#$23,(printx).l
	lea	GoalTypeTbl(pc),a1
	move.b	ssflags(a0,d3.w),d0
	andi.w	#$7F,d0					;strip the away bit -> string index
	jsr	(Fprintsmall).l				;print the type
	move.w	#$10,(printx).l
	move.b	ssscorer(a0,d3.w),d0
	bsr.w	PrintScorerName			;print him
	move.w	#$E000,(printa).l
	move.w	#$12,(printx).l
	move.b	ssassist1(a0,d3.w),d0
	bsr.w	PrintScorerName
	move.w	#$12,(printx).l
	move.b	ssassist2(a0,d3.w),d0	;second assist, falls into PrintScorerName
PrintScorerName						;Print player d0 (byte, negative = none) and go down a row
	ext.w	d0						;sign extend: $FF = no player
	bmi.w	.0						;nothing to print, just advance the row
	jsr	(FormatPlayerNumInitial).l	;a1 = "NN F. Last" for player d0 of team a2
	jsr	(print).l
.0									;row printed (or none)
	addi.w	#1,(printy).l
	rts
GoalTypeTbl							;ScoreSum byte 2 & $7F: SH2, SH, even, PP, PP2
	String	'SH2'
	String	'SH'
	String	' '
	String	'PP'
	String	'PP2'
PenaltySummaryScreen				;"Penalty Summary": one 3 row entry per penalty (4 bytes each from PenSum,
									;PenSumLength bytes), scrolled as ScoringSummaryScreen. Menu item handler
	moveq	#$A,d0					;bitmap row $A
	moveq	#$19,d1
	bsr.w	SetupScreen				;set up the screen
	jsr	(printz).l
	String	CC_Font3Pri,4,1
	moveq	#$20,d0
	moveq	#6,d1
	jsr	(Framer).l					;draw the frame
	jsr	(printbigz).l
	String	CC_Font3Pri,5,4,'Penalty  Summary',CC_Font3Pri,7,1
;CD: no cartridge twin
	moveq	#$2C,d0
	bsr.w	PutTeamBlock
	addi.w	#4,(printx).l			;4 columns right
	clr.w	d0
	bsr.w	PutTeamBlock
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,6,3,0,8,CC_SetFont,1,'^Per^^Time^^Tm^^Player/Penalty^^^^min^^^',CC_SetFont,0
	clr.l	d0
	move.w	(PenSumLength).l,d0
	lsr.w	#2,d0					;/4 bytes per entry = number of penalties
	mulu.w	#$18,d0					;24 pixels per entry
	move.w	d0,(VertLineScrolling).l	;start at the end
	subi.w	#$78,d0					;5 entries fit on screen
	bpl.w	.0
	clr.w	d0						;fewer than 5 entries: no scrolling
.0									;scroll limit set
	move.w	d0,(SelectedPlayerIdx).l
	move.w	(VertLineScrolling).l,d0	;start position
.toend								;scroll down to the end of the list first
	bsr.w	MenuWaitVblank			;wait for the next frame
	bsr.w	UpdatePenaltyScroll		;set scroll to d0, drawing entries as they come into view
	move.w	(VertLineScrolling).l,d0	;position
	subi.w	#2,d0
	cmp.w	(SelectedPlayerIdx).l,d0	;reached the limit?
	bge.w	.toend					;not there yet
	clr.w	(PlayerScrollCtr).l
.loop								;each frame: read the pad
	bsr.w	MenuWaitVblank			;wait for the next frame
	bsr.w	getpzjoy				;d3 = held buttons of the pad that paused
	btst	#7,d3					;start?
	bne.w	ExitStatsScreen			;Start
	moveq	#-2,d0
	btst	#0,d3					;up?
	bne.w	.set					;up held: scroll up
	neg.w	d0
	btst	#1,d3					;down?
	beq.w	.scroll					;neither: keep the current PlayerScrollCtr (it is cleared at entry
									;boundaries)
.set								;up or down: scroll by d0 each frame
	move.w	d0,(PlayerScrollCtr).l
.scroll								;nothing new pressed: carry on any scroll still moving
	bsr.w	CheckPenaltyScroll
	bra.w	.loop
CheckPenaltyScroll					;PenaltySummaryScreen per frame: add PlayerScrollCtr to VertLineScrolling
									;(0 ... SelectedPlayerIdx). Falls into UpdatePenaltyScroll
	move.w	(PlayerScrollCtr).l,d0
	beq.w	rtss8
	add.w	(VertLineScrolling).l,d0	;new position
	bmi.w	rtss8					;above the top: ignore
	cmp.w	(SelectedPlayerIdx).l,d0	;past the limit?
	bgt.w	rtss8
UpdatePenaltyScroll					;Set VertLineScrolling = d0. Stop on an entry boundary (24 lines), draw
									;the entry coming into view, VSRAM = VertLineScrolling - $50
	move.w	(VertLineScrolling).l,d1	;d1 = old position
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divs.w	#$18,d0					;24 pixels an entry
	swap	d0						;low word = remainder, high word = entry
	tst.w	d0						;on a boundary?
	bne.w	.0
	bsr.w	DrawScrollArrowsPenalty	;landed on an entry boundary: refresh arrows and stop scrolling
	clr.w	(PlayerScrollCtr).l
.0									;between entries: keep scrolling
	ext.l	d1						;d1 = old position / 24, remainder in the low word
	divs.w	#$18,d1
	swap	d1
	tst.w	d1						;was the old one on a boundary?
	bne.w	.2
	move.l	d0,-(sp)
	cmpi.w	#$16,d0					;22 pixels in: moved up, the entry above is coming into view
	bne.w	.1
	bsr.w	DisplayPenaltyLineUp
.1									;not moving up
	move.l	(sp)+,d0				;restore the new position quotient/remainder
	cmpi.w	#2,d0					;2 pixels in: moved down, the entry below is coming into view
	bne.w	.2
	bsr.w	DisplayPenaltyLineDown
.2									;only on the first step off an entry boundary
	move.w	(disflags).l,-(sp)		;set the vertical scroll (VSRAM)
	bset.b	#dfng,(disflags).l		;don't int graphics while the VDP is being addressed
	movea.l	#Vdata,a0
;CD: no cartridge twin
.L2DBD4
	btst.b	#$7,$FF800E.l
	bne.s	.L2DBD4
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2DBF8
	btst.b	#$6,$FF800E.l
	beq.s	.L2DBF8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2DC12
	btst.b	#$6,$FF800E.l
	bne.s	.L2DC12
	bclr.b	#$7,$FF800F.l
	move.w	#$FFB0,d0
	add.w	(VertLineScrolling).l,d0
.L2DC2E
	btst.b	#$7,$FF800E.l
	bne.s	.L2DC2E
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2DC4E
	btst.b	#$6,$FF800E.l
	beq.s	.L2DC4E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2DC68
	btst.b	#$6,$FF800E.l
	bne.s	.L2DC68
	bclr.b	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
DisplayPenaltyLineUp				;Draw penalty entry (d0 high word) at the top of the window
	move.l	d0,-(sp)
	swap	d0						;d0 = entry index
	move.w	d0,d3
	asl.w	#2,d3					;d3 = byte offset into PenSum (4 per entry)
	jsr	(printz).l					;map at the row position
	String	CC_Font2Pri,0,0
	move.w	(VertLineScrolling).l,d0
	lsr.w	#3,d0					;scroll in 8 pixel cell rows
	subi.w	#2,d0					;2 rows above the window top
	andi.w	#$1F,d0					;wrap in the 32 row map
	move.w	d0,(printy).l
	bsr.w	DisplayPenaltyEntry
	move.l	(sp)+,d0
	rts
DisplayPenaltyLineDown				;Draw penalty entry (d0 high word) + 5 at the bottom of the window
	move.l	d0,-(sp)
	swap	d0						;d0 = entry index
	addi.w	#5,d0					;the entry 5 below it
	move.w	d0,d3
	asl.w	#2,d3					;d3 = byte offset into PenSum (4 per entry)
	jsr	(printz).l					;map at the row position
	String	CC_Font2Pri,0,0
	move.w	(VertLineScrolling).l,d0
	lsr.w	#3,d0					;scroll in 8 pixel cell rows
	addi.w	#$F,d0					;15 rows below the window top
	andi.w	#$1F,d0					;wrap in the 32 row map
	move.w	d0,(printy).l
	bsr.w	DisplayPenaltyEntry
	move.l	(sp)+,d0
	rts
DisplayPenaltyEntry					;Print PenSum entry d3: time, team (bit 7 of byte 2 = away), minutes and
									;name from Penaltylist, player (byte 3)
	move.w	(printy).l,-(sp)
	moveq	#$28,d0					;width 40 cells
	moveq	#3,d1					;3 rows high
	move.w	#$7FF,d2				;blank tile
	jsr	(eraser).l
	move.w	(sp)+,(printy).l
	movea.l	#(PenSum-M68K_RAM),a0
	move.w	(a0,d3.w),d0			;penalty time
	move.w	#1,(printx).l
	jsr	(FormatAndPrintTime).l		;print it
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	btst.b	#7,pspen(a0,d3.w)		;away penalty?
	beq.w	.0
	adda.w	#tmsize,a2
.0									;team chosen
	movea.l	tmdata(a2),a1			;team data -> team name string
	adda.w	Teamname(a1),a1
	adda.w	(a1),a1
	move.w	#$C,(printx).l
	jsr	(print).l
	move.b	pspen(a0,d3.w),d0
	andi.w	#$7F,d0					;strip the away bit
	movea.l	#Penaltylist,a3
	adda.w	(a3,d0.w),a3
	clr.w	d0
	move.b	1(a3),d0				;penalty minutes
	jsr	(PushNumber).l
	move.w	#$23,(printx).l
	jsr	(print).l
	move.w	#$10,(printx).l
	clr.w	d0
	move.b	psplayer(a0,d3.w),d0
	jsr	(FormatPlayerNumInitial).l	;his number and name
	jsr	(print).l
	addi.w	#1,(printy).l
	move.w	#$13,(printx).l
	move.w	#$E000,(printa).l
	lea	2(a3),a1					;penalty name string
	jmp	(print).l
DrawScrollArrowsPenalty				;Summary screen up / down arrows (ScrollArrowTbl). Saves d0-d1/a1. Also
									;used by UpdateScoringScroll
	movem.l	d0-d1/a1,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,3,4,9,CC_SetFont,1
	clr.w	d0
	move.w	(VertLineScrolling).l,d1	;scroll position
	tst.w	d1						;scrolled?
	sgt.b	d0
	neg.b	d0						;1 if scrolled down at all
	cmp.w	(SelectedPlayerIdx).l,d1	;at the maximum?
	slt.b	d1
	neg.b	d1						;1 if not at the maximum
	add.b	d1,d0
	add.b	d1,d0
	lea	ScrollArrowTbl(pc),a1
	jsr	(Fprintsmall).l				;print it
	movem.l	(sp)+,d0-d1/a1
	rts
ScrollArrowTbl						;None, up, down, both
	String	' ',CC_AddX,$FF,CC_AddY,$11,' ',CC_SetFont
	String	'{',CC_AddX,$FF,CC_AddY,$11,' ',CC_SetFont
	String	' ',CC_AddX,$FF,CC_AddY,$11,'}',CC_SetFont
	String	'{',CC_AddX,$FF,CC_AddY,$11,'}',CC_SetFont
PlayoffStatsScreen					;"Playoff Stats": the playoff totals (ReadTeamStats) of the potreeteam
									;team as PlayerStatsList with d7 = 1. Called and the menu lists
	movem.l	a2,-(sp)
	jsr	(ReadTeamStats).l			;load the playoff team stats
	movea.l	#(potree-M68K_RAM),a0
	move.w	(potreeteam).l,d0		;user tree position
	move.b	(a0,d0.w),d0			;his team
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	cmp.w	tmteam(a2),d0			;is it home?
	beq.w	.0
	adda.w	#tmsize,a2
.0									;team struct of that team chosen
	moveq	#1,d7					;playoff mode: stats come from the playoff RAM tables
	bsr.w	PlayerStatsList
	movem.l	(sp)+,a2
	rts
PlayerStatsScreen					;"Player Stats": PlayerStatsList with d7 = 0
									;(this game). Menu item handler
	clr.w	d7						;game stats
PlayerStatsList						;Stats screen for team a2, d7 = 0 game / 1 playoff: the column headers,
									;the players sorted by the selected column (left / right), up / down
									;scroll, A switches teams (game stats only), start exits
	moveq	#$D,d0					;bitmap row $D
	moveq	#$16,d1
	bsr.w	SetupScreen				;set up the screen
	clr.w	(DispAttribCtr).l		;sort column: -1 goalie saves, 0-4 G A Pts SOG PIM; start with goals
	clr.w	(VertLineScrolling).l	;list scrolled to the top
.redraw								;loop
	clr.w	(PlayerScrollCtr).l
	jsr	(printz).l
	String	CC_Font3Pri,5,1
	moveq	#$1E,d0
	moveq	#6,d1
	jsr	(Framer).l					;draw the frame
	tst.w	d7						;playoff stats?
	beq.w	.title
	jsr	(printbigz).l
	String	CC_Font3Pri,7,4,'Playoff  Stats',CC_Font3Pri,$E,1
	bra.w	.team
.title								;d7 = 0
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,6,3,$C,$1A,CC_SetFont,1,'A^-^Switch^Teams',CC_SetFont,0
	jsr	(printbigz).l
	String	CC_Font3Pri,8,4,'Player  Stats',CC_Font3Pri,$E,1
.team								;print the team
	clr.w	d0						;TeamBlockMap offset: 0 for the home struct, $30 for the away struct
	cmpa.l	#$1834C,a2				;home team? (CD: the cartridge has #(tmstruct-M68K_RAM))
	beq.w	.home
;CD: no cartridge twin
	moveq	#$2C,d0
.home								;home team at 0, away at $2C
	bsr.w	PutTeamBlock			;draw the team block, then the list
	bsr.w	DrawStatsList
	bsr.w	DrawStatsListArrows
.loop								;loop
	bsr.w	MenuWaitVblank
	bsr.w	getpzjoy				;d1 = new presses, d3 = held
	btst	#7,d3
	bne.w	ExitStatsScreen			;Start
	btst	#6,d1					;A?
	bne.w	.switch
;CD: no cartridge twin
	jsr	(nodiag).l
	moveq	#1,d0
.right								;(not branched to)
	btst	#3,d1					;right?
	bne.w	.col					;right pressed: column +1
	neg.w	d0
	btst	#2,d1					;left?
	bne.w	.col					;left pressed: column -1
	moveq	#-2,d0
.updown								;(not branched to)
	btst	#0,d3					;up?
	bne.w	.set					;up held: scroll step -2
	neg.w	d0
	btst	#1,d3					;down?
	beq.w	.scroll					;nothing held: keep the current scroll step
.set								;up or down: scroll by d0 each frame
	move.w	d0,(PlayerScrollCtr).l
.scroll								;nothing new pressed: carry on any scroll still moving
	bsr.w	UpdateStatsListScroll
	bra.w	.loop
.col								;bit 3 of d1 set or bit 2 of d1 set
	add.w	(DispAttribCtr).l,d0
	cmpi.w	#$FFFF,d0				;below -1?
	blt.w	.scroll
	cmpi.w	#4,d0					;past 4?
	bgt.w	.scroll
	move.w	d0,(DispAttribCtr).l
	bsr.w	DrawStatsList
	bsr.w	DrawStatsListArrows
	bra.w	.scroll
.switch								;bit 6 of d1 set
	tst.w	d7						;No team switch in playoff stats
	bne.w	.scroll
	lea	tmsize(a2),a2
	cmpa.l	#$186B2,a2				;was the home team? (CD: the cartridge has #(awtmstruct-M68K_RAM))
	beq.w	.redraw					;was home, now away
	movea.l	#$1834C,a2				;was away, back to home (CD: the cartridge has #(tmstruct-M68K_RAM))
	bra.w	.redraw
UpdateStatsListScroll				;Stats screen per frame: scroll 0 ... SelectedPlayerIdx, stop on a 16 line
									;boundary, draw the row coming into view
	move.w	(PlayerScrollCtr).l,d0
	beq.w	rtss8
	add.w	(VertLineScrolling).l,d0	;new position
	bmi.w	rtss8					;above the top: ignore
	cmp.w	(SelectedPlayerIdx).l,d0	;past the limit?
	bgt.w	rtss8
	move.w	(VertLineScrolling).l,d1	;d1 = old position
	move.w	d0,(VertLineScrolling).l
	andi.w	#$F,d0					;pixels into the current 16 pixel row
	bne.w	.0
	bsr.w	DrawStatsListArrows		;landed on a row boundary: refresh arrows and stop scrolling
	clr.w	(PlayerScrollCtr).l
.0									;between rows: keep scrolling
	andi.w	#$F,d1					;old position within its row
	bne.w	SetStatsListScrollReg
	move.w	d0,-(sp)
	cmpi.w	#$E,d0					;14 pixels in: moved up, draw the row above
	bne.w	.1
	bsr.w	DrawStatsRowUp
.1									;not moving up
	move.w	(sp)+,d0				;restore the pixels into the row
	cmpi.w	#2,d0					;2 pixels in: moved down, draw the row below
	bne.w	SetStatsListScrollReg
	bsr.w	DrawStatsRowDown		;falls into the scroll register write
SetStatsListScrollReg				;VSRAM = VertLineScrolling - $68
	move.w	(disflags).l,-(sp)
	bset.b	#dfng,(disflags).l		;don't int graphics while the VDP is being addressed
	movea.l	#Vdata,a0
;CD: no cartridge twin
.L2E00E
	btst.b	#$7,$FF800E.l
	bne.s	.L2E00E
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2E032
	btst.b	#$6,$FF800E.l
	beq.s	.L2E032
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2E04C
	btst.b	#$6,$FF800E.l
	bne.s	.L2E04C
	bclr.b	#$7,$FF800F.l
	move.w	#$FF98,d0
	add.w	(VertLineScrolling).l,d0
.L2E068
	btst.b	#$7,$FF800E.l
	bne.s	.L2E068
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2E088
	btst.b	#$6,$FF800E.l
	beq.s	.L2E088
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2E0A2
	btst.b	#$6,$FF800E.l
	bne.s	.L2E0A2
	bclr.b	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
DrawStatsRowUp						;Draw the top row of the window
	move.w	(VertLineScrolling).l,d3	;scroll position
	lsr.w	#4,d3					;d3 = first visible Satt row (16 pixels per row)
	bra.w	DrawStatsRow
DrawStatsRowDown					;Draw the row below the window
	move.w	(VertLineScrolling).l,d3	;scroll position
	lsr.w	#4,d3					;first visible Satt row
	addi.w	#6,d3					;6 rows further down
	bra.w	DrawStatsRow
DrawStatsList						;Stats screen: column headers (sort column highlighted), the title of the
									;sort column (StatSortTitles), then the players sorted by it into Satt and
									;the rows drawn
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,6,3,4,$B,CC_SetFont,1,'Player',CC_AddX,7
	lea	StatColumnHeaders(pc),a1
	moveq	#5,d3					;goalie mode: d3 = 5 so only the first (goalie) string is printed
	tst.w	(DispAttribCtr).l		;goalie column?
	bmi.w	.head
	adda.w	(a1),a1					;skip the goalie header string, a1 = " G" string
	clr.w	d3						;d3 = column 0-4
.head								;each column header (only the goalie one in goalie mode)
	move.w	#$8000,(printa).l		;next column header, normal attribute
	cmp.w	(DispAttribCtr).l,d3	;this column?
	bne.w	.1
	move.w	#$C000,(printa).l		;highlight the sort column
.1									;sort column highlighted, others normal
	jsr	(printsmall).l				;print the header
	addi.w	#1,d3
	cmpi.w	#5,d3					;5 columns
	blt.w	.head
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,3,9,7
	moveq	#$16,d0
	moveq	#3,d1
	jsr	(Framer).l					;draw the frame
	jsr	(printz).l
	String	CC_Font3Pal3Pri,$A,8
	lea	StatSortTitles(pc),a1
	moveq	#1,d0
	add.w	(DispAttribCtr).l,d0	;string 0 = goalie saves, 1-5 = G A Pts SOG PIM
	jsr	(Fprintsmall).l				;print the title
	clr.w	(printfontset).l
	movea.l	#(Satt-M68K_RAM),a3
	clr.l	d6						;no player used yet
	tst.w	(DispAttribCtr).l		;goalie column?
	bpl.w	.sort
	bsr.w	GetGoalieCount			;goalie column: mark all skaters used
	bset	d0,d6					;(goalies come first in the roster: players 0 to count-1)
	subi.w	#1,d6
	not.l	d6						;bits count and up set = skaters
.sort								;pick the best remaining player each pass
	moveq	#-1,d4					;Selection sort, best so far
	st.b	d5						;d5 = $FF: none found
	bsr.w	GetPlayerCount			;d0 = number of players, loop counts d0 down from count-1
	bra.w	.next
.player								;each candidate
	btst	d0,d6
	bne.w	.next					;already used (or filtered out)
	clr.w	d2
	move.w	(DispAttribCtr).l,d1
	bmi.w	.4						;goalie column: key is just the tie-break byte
	bsr.w	GetStatColumn			;d2 = stat for player d0
.4									;sort key ready
	ext.l	d2						;d2 = stat value
	asl.l	#8,d2					;key = stat * 256 ...
	movea.l	tmdata(a2),a1			;walk the player records to record d0
	adda.w	0(a1),a1
	move.w	d0,d1
;CD: no cartridge twin
	suba.w	#$8,a1
.skip								;CD: placed where the disc branches to it
	adda.w	#$8,a1
	adda.w	(a1),a1
	dbf	d1,.skip					;loop
	move.b	#$FF,d2
	sub.b	(a1),d2					;ties: lower player byte first
	cmp.l	d4,d2					;... + ($FF - first byte of the player record)
	ble.w	.next					;not better than the best so far
	move.l	d2,d4
	move.w	d0,d5
.next								;next candidate
	dbf	d0,.player					;next candidate
	bset	d5,d6
	move.b	d5,(a3)+				;append the best player to the sorted list
	bpl.w	.sort					;until none left ($FF)
	moveq	#5,d0					;6 rows
.pad								;fill 6 $FF rows after the list
	st.b	(a3,d0.w)
	dbf	d0,.pad						;loop
;CD: no cartridge twin
	move.l	a3,d0
	subi.l	#$BBD36,d0
	bpl.w	.8						;more than 6 rows
	clr.w	d0
.8									;scroll limit: rows past the first 6
	asl.w	#4,d0					;16 pixels per row
	move.w	d0,(SelectedPlayerIdx).l
	cmp.w	(VertLineScrolling).l,d0	;past the limit?
	bcc.w	.9
	move.w	d0,(VertLineScrolling).l	;clamp the current scroll to the new maximum draw the 6 visible rows
.9									;scroll kept inside the limit
	moveq	#5,d4
.ent								;draw each visible row
	move.w	(VertLineScrolling).l,d3	;draw loop, d4 = row offset 5 to 0
	lsr.w	#4,d3
	add.w	d4,d3					;Satt row d3
	bsr.w	DrawStatsRow
	dbf	d4,.ent						;loop
	bra.w	SetStatsListScrollReg
DrawStatsRow						;Stats screen row d3 of Satt: rank, name, then the 5 columns, or for
									;goalies saves, shots and save %
	movea.l	#(Satt-M68K_RAM),a4
	adda.w	d3,a4
	jsr	(printz).l					;map at the list position
	String	CC_Font2Pri,0,0
	add.w	d3,d3					;2 map rows per Satt row
	andi.w	#$1F,d3					;wrap in the 32 row map
	move.w	d3,(printy).l
	moveq	#$28,d0					;erase one row, 40 cells wide
	moveq	#1,d1
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l
	tst.b	(a4)					;empty row?
	bmi.w	rtss8
	subi.w	#1,(printy).l			;eraser moved printy down one row; back to the row rank (2 digits) at x 1
	move.w	#1,(printx).l
;CD: no cartridge twin
	move.l	a4,d0
	subi.l	#$BBD2F,d0
	moveq	#2,d1					;2 digits
	move.w	#$E000,(printa).l
	jsr	(PushNumberWidth).l
	jsr	(print).l
	clr.w	d0
	move.b	(a4),d0
	jsr	(FormatPlayerName).l		;his number and last name
	addi.w	#1,(printx).l
	move.w	#$8000,(printa).l
	jsr	(print).l
	move.w	#$11,(printx).l			;stat columns start at x $11
	tst.w	(DispAttribCtr).l		;goalie column?
	bmi.w	.goalie
	clr.w	d5
.col								;loop
	clr.w	d0						;next stat column d5
	move.b	(a4),d0
	move.w	d5,d1
	bsr.w	GetStatColumn			;d2 = the stat
	move.w	d2,d0
	moveq	#4,d1					;4 digits
	jsr	(PushNumberWidth).l
	move.w	#$8000,(printa).l
	cmp.w	(DispAttribCtr).l,d5	;sort column?
	bne.w	.1
	move.w	#$C000,(printa).l		;highlighted sort column
.1									;sort column highlighted, others normal
	jsr	(print).l
	addi.w	#1,d5
	cmpi.w	#5,d5					;5 columns
	bne.w	.col
	bra.w	.x
.goalie								;DispAttribCtr negative
	clr.w	d0						;Shots against
	move.b	(a4),d0
	moveq	#3,d1					;column 3 (SOG array)
	bsr.w	ReadStatColumn			;d2 = shots against
	clr.w	d0
	move.b	(a4),d0
	moveq	#0,d1					;goals against
	move.w	d2,-(sp)
	bsr.w	ReadStatColumn			;d2 = goals against
	move.w	(sp)+,d0
	move.w	d0,d3
	sub.w	d2,d0					;saves = shots - goals against
	bpl.w	.2
	clr.w	d0
.2									;saves ready (not below 0)
	move.w	d0,d2
	moveq	#4,d1					;4 digits
	jsr	(PushNumberWidth).l
	addi.w	#1,(printx).l
	jsr	(print).l
	move.w	d3,d0
	moveq	#4,d1					;4 digits
	jsr	(PushNumberWidth).l
	addi.w	#2,(printx).l			;two columns right
	jsr	(print).l
	tst.w	d3
	beq.w	.3						;no shots: percentage is just d2 (0)
	mulu.w	#$64,d2
	divu.w	d3,d2					;saves * 100 / shots
.3									;save % ready (0 with no shots)
	move.w	d2,d0
	moveq	#4,d1					;4 digits
	jsr	(PushNumberWidth).l
	addi.w	#2,(printx).l			;two columns right
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
	cmp.w	d2,d0					;goalie?
	bge.w	ReadStatColumn			;skater: read the column as is
	clr.w	d2						;goalie: columns 1 and 2 (A, Pts) show column 1 (assists), the rest 0
	btst	d1,#6					;written as btst Dn,#imm
	beq.w	rtss8					;other goalie columns: 0
	moveq	#1,d1					;show Pts
ReadStatColumn						;d2 = stat column d1 for player d0. d7 = 0: the team struct byte arrays
									;(StatColumnOffsets); d7 = 1: the playoff tables (GetStatsValue)
	tst.w	d7						;playoff stats?
	bne.w	.stats
	lea	StatColumnOffsets(pc),a1
	asl.w	#2,d1					;2 words per column
	adda.w	d1,a1
;CD: no cartridge twin
	clr.l	d1
	move.w	(a1),d1
	add.w	d0,d1
	clr.l	d2
	move.b	(a2,d1.l),d2
	move.w	2(a1),d1				;second array offset
	bmi.w	rtss8
	add.w	d0,d1
	clr.w	d3
;CD: no cartridge twin
	move.b	(a2,d1.l),d3
	add.w	d3,d2
	rts
.stats								;d7 <> 0
	asl.w	#2,d1					;2 words per column
	add.w	d0,d0
	clr.w	d2
	bsr.w	GetStatsValue
	addi.w	#2,d1					;second table of the pair
	bsr.w	GetStatsValue
	lsr.w	#1,d0					;restore the player index
	rts
GetStatsValue						;d2 += word d0 of the RAM table at StatsOffsetTbl2+d1 (0 = none)
	movea.l	#StatsOffsetTbl2,a1		;playoff stat tables
	tst.w	(a1,d1.w)				;none?
	beq.w	rtss8
	movea.w	(a1,d1.w),a1
;CD: no cartridge twin
	move.l	d7,-(sp)
	move.l	a1,d7
	andi.l	#$FFFF,d7
	movea.l	d7,a1
	move.l	(sp)+,d7
	add.w	(a1,d0.w),d2
	rts
	cmp.b	d0,d0
	dc.w	$0000,$B034
	dc.w	$0000,$B000
	cmp.b	$68(a4,a3.w),d0
	dc.w	$0000,$B09C
	dc.w	$0000
	dc.w	$00B6
	dc.w	$FFFF
	dc.w	$00D0
	dc.w	$FFFF
	dc.w	$00B6
	dc.w	$00D0
	dc.w	$00EA
	dc.w	$FFFF
	btst	d0,d4
	dc.w	$FFFF
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
	move.w	(VertLineScrolling).l,d1	;scroll position
	tst.w	d1						;scrolled?
	sgt.b	d0
	neg.b	d0						;1 if scrolled down at all
	cmp.w	(SelectedPlayerIdx).l,d1	;at the maximum?
	slt.b	d1
	neg.b	d1						;1 if not at the maximum
	add.b	d1,d0
	add.b	d1,d0
	lea	ScrollArrowTbl2(pc),a1
	jsr	(Fprintsmall).l				;print string d0 of the table
	movem.l	(sp)+,d0-d1/a1
	rts
ScrollArrowTbl2						;None, up, down, both
	String	' ',CC_AddX,$FF,CC_AddY,$C,' ',CC_SetFont
	String	'{',CC_AddX,$FF,CC_AddY,$C,' ',CC_SetFont
	String	' ',CC_AddX,$FF,CC_AddY,$C,'}',CC_SetFont
	String	'{',CC_AddX,$FF,CC_AddY,$C,'}',CC_SetFont
CrowdMeterScreen					;"Crowd Meter": current, average and peak level (PrintCrowdMeter), plus
									;the arena and league records; start exits. Menu item handler
	moveq	#9,d0					;bitmap row 9
	moveq	#$1C,d1
	bsr.w	SetupScreen				;set up the screen
	jsr	(printz).l
	String	CC_Font3Pri,6,1
	moveq	#$1C,d0					;frame 28 wide, 6 high
	moveq	#6,d1
	jsr	(Framer).l					;CD: the cartridge has (printbigz).l
;CD: no cartridge twin
	jsr	(printbigz).l
	dc.w	$0014,$BD09
	subi.w	#$726F,d3
	dc.b	'wd  Meter'
	dc.b	$BD
	btst	d3,d1
	moveq	#$2C,d0
	bsr.w	PutTeamBlock
	addi.w	#4,(printx).l			;4 columns right
	clr.w	d0
	bsr.w	PutTeamBlock
	bsr.w	PrintCrowdMeter			;the three level rows
.loop								;loop
	bsr.w	Pausemode_rjoy			;wait for a new button press
	btst	#7,d1					;start?
	bne.w	ExitStatsScreen
	bra.w	.loop
;CD: no cartridge twin
PrintCrowdMeter						;CD: placed where the disc branches to it
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,2,4,$C,'Current Level',CC_SetX,$1C
	move.w	(CwdExciteLvl).l,d0		;current level
	bsr.w	PrintCrowdDB			;print it
;CD: no cartridge twin
	jsr	(printsmallz).l
	String	CC_SetX,4,CC_AddY,2,'Average Level',CC_SetX,$1C
	move.l	(SumCwdExciteLvl).l,d0	;sum of the levels
	divu.w	(NumCwdExciteLvl).l,d0
	bsr.w	PrintCrowdDB			;print it
;CD: no cartridge twin
	jsr	(printsmallz).l
	String	CC_SetX,4,CC_AddY,2,'Peak Level',CC_SetX,$1C
	move.w	(MaxCwdExciteLvl).l,d0	;peak level
	bsr.w	PrintCrowdDB			;print it
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(ValidSRAM).l			;save RAM?
	bmi.w	.x
	move.w	(HomeTeam).l,d1
	ext.l	d1
	movea.l	#recordbuf,a0
	jsr	(ReadCrowdRecord).l
	move.b	crpeak(a0),d0
	bne.w	.gotarena
	move.b	#$50,d0					;none: $50
.gotarena							;arena record, or $50 dB when none
	andi.w	#$FF,d0
	move.w	d0,-(sp)
;CD: no cartridge twin
	jsr	(printsmallz).l
	String	CC_SetX,4,CC_AddY,2,'Arena Record',CC_SetX,$1C
	move.w	(sp)+,d0
	move.w	#3,d1					;3 digits
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
	move.w	#$50,d0					;none: $50
.gotleague							;league record, or $50 dB when none
	andi.w	#$FF,d0
	move.w	d0,-(sp)
;CD: no cartridge twin
	jsr	(printsmallz).l
	String	CC_SetX,4,CC_AddY,2,'League Record',CC_SetX,$1C
	move.w	(sp)+,d0
.leaguew							;(not branched to)
	move.w	#3,d1
.leaguenum							;(not branched to)
	jsr	(PushNumberWidth).l
	jsr	(print).l
;CD: no cartridge twin
	jsr	(printz).l
	String	' dB'
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PrintCrowdDB						;Print crowd level d0 as sqrt(d0 * 4) + 65 " dB"
	ext.l	d0
	asl.w	#2,d0					;level * 4
;CD: no cartridge twin
	jsr	(Sroot).l
	addi.w	#$41,d0
	moveq	#3,d1					;3 digits
	jsr	(PushNumberWidth).l
;CD: no cartridge twin
	jsr	(print).l
	jsr	(printz).l
	String	' dB'
	rts
SetupScreen							;Common start of the stats screens: blank, 40 cell mode, the framer and
									;small font tiles, the background bitmap (EASportsBGMap) from row d0, d1
									;rows
									;high
	movem.l	d0-d1/a2,-(sp)			;keep d0/d1 (first/last row) and a2 (team) for the caller
;CD: no cartridge twin
	jsr	(forceblack).l
	bclr.b	#dfok,(disflags).l		;graphics not ready for transfer
	move.w	(disflags).l,-(sp)
.noint								;(not branched to)
	bset.b	#dfng,(disflags).l
	move.w	(VSPRITES).l,d0
;CD: no cartridge twin
	jsr	(Vmaddr).l
.L2E754
	btst.b	#$7,$FF800E.l
	bne.s	.L2E754
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2E778
	btst.b	#$6,$FF800E.l
	beq.s	.L2E778
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2E792
	btst.b	#$6,$FF800E.l
	bne.s	.L2E792
	bclr.b	#$7,$FF800F.l
.L2E7A4
	btst.b	#$7,$FF800E.l
	bne.s	.L2E7A4
	move.w	#$8C81,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2E7C6
	btst.b	#$6,$FF800E.l
	beq.s	.L2E7C6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2E7E0
	btst.b	#$6,$FF800E.l
	bne.s	.L2E7E0
	bclr.b	#$7,$FF800F.l
	move.w	#$6,(Map3col).l
.L2E7FA
	btst.b	#$7,$FF800E.l
	bne.s	.L2E7FA
	move.w	#$8D00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2E81C
	btst.b	#$6,$FF800E.l
	beq.s	.L2E81C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2E836
	btst.b	#$6,$FF800E.l
	bne.s	.L2E836
	bclr.b	#$7,$FF800F.l
	clr.w	d0
	jsr	(Vmaddr).l
.L2E850
	btst.b	#$7,$FF800E.l
	bne.s	.L2E850
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2E874
	btst.b	#$6,$FF800E.l
	beq.s	.L2E874
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2E88E
	btst.b	#$6,$FF800E.l
	bne.s	.L2E88E
	bclr.b	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	bclr.b	#df32c,(disflags).l		;not in 32 cell mode
	move.w	(framercset).l,d4		;frame chars
;CD: no cartridge twin
	movea.l	(FramerMapPtr).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$91234567,$89ABCDEF		;remap table
	move.w	(smallfontchars).l,d4
	jsr	(AddSmallFont).l
;CD: no cartridge twin
	jsr	(printz).l
	dc.w	$0006,$BD00
	dc.w	$0000,$2279
	dc.w	$0004,$7D0C
	adda.l	jimdata(a1),a1
	movea.l	#null,a2
	clr.w	d0						;start x/y 0 in the map
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	moveq	#1,d4
	moveq	#0,d5					;no palette lines
;CD: no cartridge twin
	jsr	(dobitmap).l
	jsr	(printz).l
	String	CC_Font3,0,0
	movem.l	(sp),d0-d1/a2
	add.w	d0,(printy).l
;CD: no cartridge twin
	movea.l	(EASportsBGMapPtr).l,a0
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2
	adda.l	(a2)+,a0				;a0 = tile data
	adda.l	(a2)+,a1				;a1 = map data
	move.w	d1,d3
	sub.w	d0,d3					;height = last row - first row
	move.w	d0,d1					;start y = first row
	clr.w	d0
	moveq	#$28,d2
	moveq	#$D,d5					;copy palette lines 0, 2 and 3
;CD: no cartridge twin
	jsr	(dobitmap).l
	move.w	d4,(smallfont2chars).l
	movea.l	(SmallFontMapPtr).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
	add.b	d0,-(a3)
	dc.w	$4567
	or.l	d4,-$3211(a3)
	jsr	(printz).l
	String	CC_Font2,0,0
	moveq	#$40,d0
	moveq	#$20,d1
	move.w	#$7FF,d2				;blank char
;CD: no cartridge twin
	jsr	(eraser).l
	move.w	#$18,(palcount).l		;start a palette fade in
	movem.l	(sp)+,d0-d1/a2
	rts
;CD: no cartridge twin
ExitStatsScreen						;CD: placed where the disc branches to it
	jsr	(forceblack).l
ReloadRinkGraphics					;after the forceblack: back to 32 cell mode and reload the rink (Rinktiles
									;or RevRinkTiles in a reverse angle
									;replay), font, framer, EASN and team graphics. Falls out through
									;setplayercolors. Also called from the replay code
	move.w	(disflags).l,-(sp)
	bset.b	#dfng,(disflags).l
	move.w	$18D30.l,d0				;CD: the cartridge has (VSCRLPM).w
;CD: no cartridge twin
	jsr	(Vmaddr).l
.L2E9A0
	btst.b	#$7,$FF800E.l
	bne.s	.L2E9A0
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2E9C4
	btst.b	#$6,$FF800E.l
	beq.s	.L2E9C4
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2E9DE
	btst.b	#$6,$FF800E.l
	bne.s	.L2E9DE
	bclr.b	#$7,$FF800F.l
	move.w	#$8D00,d0				;register $D: hscroll table
	move.b	$18D30.l,d0				;CD: the cartridge has (VSCRLPM).w
	lsr.b	#2,d0
;CD: no cartridge twin
.L2E9FC
	btst.b	#$7,$FF800E.l
	bne.s	.L2E9FC
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2EA1C
	btst.b	#$6,$FF800E.l
	beq.s	.L2EA1C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2EA36
	btst.b	#$6,$FF800E.l
	bne.s	.L2EA36
	bclr.b	#$7,$FF800F.l
.L2EA48
	btst.b	#$7,$FF800E.l
	bne.s	.L2EA48
	move.w	#$8C00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2EA6A
	btst.b	#$6,$FF800E.l
	beq.s	.L2EA6A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2EA84
	btst.b	#$6,$FF800E.l
	bne.s	.L2EA84
	bclr.b	#$7,$FF800F.l
	move.w	#$5,(Map3col).l
.L2EA9E
	tst.w	(palcount).l
	bpl.w	.L2EA9E
	move.w	(sp)+,(disflags).l
	bset.b	#df32c,(disflags).l
	move.w	(rinkvrcset).l,d4
;CD: no cartridge twin
	movea.l	(RinktilelistPtr).l,a2
	addq.l	#$8,a2
	btst.b	#$4,(sflags4).l
	beq.w	.L2EAD8
	movea.l	(RevRinkTilelistPtr).l,a2
	addq.l	#$8,a2
.L2EAD8
	jsr	(DecompressGraphicsPlain).l
	jsr	(LoadHomeTeamGfx).l
	move.w	(smallfontchars).l,d4
	movea.l	(SmallFontMapPtr).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$43434567,$89ABCDEF		;remap table
	move.w	(framercset).l,d4		;frame chars
	jsr	(AddFramer).l				;send the frame tiles
	jsr	(setupEASportsMap).l
	jsr	(ReloadEnergyBarTiles).l
	jsr	(ReloadCrowdTiles).l
	jsr	(setupIceRinkPal).l
	jmp	(setplayercolors).l
TimeoutMenu							;Pause menu "Timeout" for team a2: switch the menu to PauseText2, show the
									;team name, rest both teams (RestoreTeamEnergy), wait $78 frames (waitx).
									;Menu item handler
	subi.w	#1,(menuitem).l
	subi.w	#1,(menuitem+2).l
	move.l	#PauseText2,(menulist).l	;pause menu without Timeout
	bset.b	#tmftimeout,tmflags(a2)
;CD: no cartridge twin
	jsr	(printz).l
	String	CC_Font3Pri,5,$C
	moveq	#$16,d0					;frame 22 wide, 6 high
	moveq	#6,d1
;CD: no cartridge twin
	jsr	(Framer).l
	jsr	(printz).l
	String	CC_Font3Pri,$C,$E,'Timeout',CC_Font3Pri,$11,$F
	movea.l	tmdata(a2),a1			;team name, centred
	adda.w	Teamname(a1),a1
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).l
;CD: no cartridge twin
	jsr	(print).l
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	jsr	(RestoreTeamEnergy).l
	adda.l	#tmsize,a2
	jsr	(RestoreTeamEnergy).l
	moveq	#$78,d0
;CD: no cartridge twin
	jmp	(waitx).l
Pausemode_go						;Pick team a2's goalie (or no goalie) from a
									;list (Pausemode_gnum) with up / down, C or start; sets tmgoalie and
									;SetPersonel. Menu item handler
	move.w	(menuitem).l,-(sp)		;save the menu state
	move.w	(menuitem+2).l,-(sp)
	bsr.w	GetGoalieCount
	move.w	d0,(menuitem+2).l
;CD: no cartridge twin
	jsr	(printz).l
	String	CC_Font3Pri,4,$C
	moveq	#$18,d0
	moveq	#3,d1
	add.w	(menuitem+2).l,d1		;plus a row per goalie
;CD: no cartridge twin
	jsr	(Framer).l
	move.w	$28(a2),d0
	bpl.w	.0
	moveq	#-1,d0
.0									;row of the current goalie (0 = goalie pulled)
	addi.w	#1,d0
	move.w	d0,(menuitem).l
.loop								;loop
	bsr.w	Pausemode_gnum
.pad								;(not branched to)
	bsr.w	Pausemode_rjoy			;wait for a press
	btst	#7,d1
	bne.w	.done					;Start confirms
	btst	#5,d1
	bne.w	.done
	btst	#1,d1
	beq.w	.up
	move.w	(menuitem).l,d0
	addq.w	#1,d0
	cmp.w	(menuitem+2).l,d0		;past the last?
	bgt.w	.loop					;already on the last row
	move.w	d0,(menuitem).l
.up									;down handled: check up
	btst	#0,d1					;up pressed: move the selection up
	beq.w	.loop
	subi.w	#1,(menuitem).l
	bpl.w	.loop					;not past the first
	clr.w	(menuitem).l			;stop at the first row
	bra.w	.loop
.done								;bit 7 of d1 set or bit 5 of d1 set
	move.w	(menuitem).l,d0
	subi.w	#1,d0					;goalie number
	bpl.w	.set
	cmpi.w	#$FFFF,tmgoalie(a2)		;already pulled?
	blt.w	.x						;yes: nothing to do
.set								;a goalie row: put him in
	move.w	d0,tmgoalie(a2)
	jsr	(setpersonel).l				;put him on the ice
.x									;goalie set, or none and already pulled
	move.w	(sp)+,(menuitem+2).l	;restore the pause menu state
	move.w	(sp)+,(menuitem).l
	rts
Pausemode_gnum						;Draw the goalie list, row menuitem highlighted, each goalie with his two
									;digit number
	move.w	#$D,(printy).l
	move.w	(menuitem+2).l,d1
	moveq	#0,d0
.row								;each row of the list
	move.w	#5,(printx).l			;next list row d0
	move.w	#$A000,(printa).l		;palette 2 priority
	cmp.w	(menuitem).l,d0			;cursor row?
	bne.w	.1
	move.w	#$8000,(printa).l		;palette 0 priority
;CD: no cartridge twin
.1									;CD: placed where the disc branches to it
	jsr	(printz).l
	String	'                      '
	tst.w	d0						;first row?
	bne.w	.player
	move.w	#$B,(printx).l
;CD: no cartridge twin
	jsr	(printz).l
	String	'no goalie'
	bra.w	.next
.player								;d0 <> 0
	movea.l	tmdata(a2),a1			;goalie row: find the player record
	adda.w	0(a1),a1
	move.w	d0,d2
	subi.w	#1,d2					;goalie number
	bra.w	.3
.skip								;skip one player record
	adda.w	(a1),a1
;CD: no cartridge twin
	adda.w	#$8,a1
.3									;CD: placed where the disc branches to it
	dbf	d2,.skip
	move.w	#$8,(printx).l
	jsr	(print).l
	move.b	(a1),d2
	lsr.b	#4,d2					;tens
	addi.b	#$30,d2
	move.b	d2,(TextBuffer).l
	move.b	(a1),d2
	andi.b	#$F,d2					;ones
	addi.b	#$30,d2
	move.b	d2,(TextBuffer+1).l
	movea.l	#$17EF2,a1				;CD: the cartridge has #(mesarea-M68K_RAM)
	move.w	#4,(a1)					;string length word (2 chars + 2)
	move.w	#5,(printx).l
;CD: no cartridge twin
	jsr	(print).l
.next								;next row
	addi.w	#1,(printy).l			;next map row and list row
	addi.w	#1,d0
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
	addi.w	#1,d0					;count nibbles by shifting 4 bits out until the word is 0
	asl.w	#4,d1
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
	adda.w	ScoutReport(a0),a0
	move.b	srforwards(a0),d0
	lsr.w	#4,d0					;high nibble
	add.w	(sp)+,d0
	movem.l	(sp)+,a0
	rts
GetForwardCount						;d0 = forwards on team a2 (high nibble of team data byte 3 at +8)
	movem.l	a0,-(sp)
	movea.l	tmdata(a2),a0
	adda.w	ScoutReport(a0),a0
	move.b	srforwards(a0),d0
	lsr.w	#4,d0					;high nibble = forward count
	andi.w	#$F,d0					;forward count
	movem.l	(sp)+,a0
	rts
GetPlayerCount						;d0 = players on team a2 (records until a length word of 2)
	movem.l	a0,-(sp)
	movea.l	tmdata(a2),a0
	adda.w	0(a0),a0				;a0 = first player record
	clr.w	d0
.loop								;loop
	addi.w	#1,d0
	adda.w	(a0),a0
;CD: no cartridge twin
	adda.w	#$8,a0
	cmpi.w	#2,(a0)					;empty name ends the list
	bne.w	.loop
	movem.l	(sp)+,a0
	rts
Pausemode_rjoy						;Wait for Vcount to change and for a new button press (d1)
	move.w	(Vcount).l,d1			;current frame
.wait								;loop
	cmp.w	(Vcount).l,d1			;has Vcount changed?
	beq.w	.wait					;spin until the vblank counter changes
	bsr.w	getpzjoy				;d1 = new presses, d3 = held
;CD: no cartridge twin
	jsr	(nodiag).l
	tst.b	d1
	beq.w	Pausemode_rjoy			;nothing new pressed: wait again
	rts
