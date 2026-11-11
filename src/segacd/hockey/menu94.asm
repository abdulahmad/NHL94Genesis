;	HOCKEY.BIN $112F8-$1165F (runtime $2C2F8-$2C65F): menu94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	The menu core is the cartridge code; CD: a few lines wait on the main CPU flag ($FF800E).

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

seta2	equ	$2C2C8
rtss8	equ	$2F988
xyVmMap	equ	$38BD4
Framer	equ	$38CA0
printsmallz	equ	$38D8C
printsmall	equ	$38D9E

	org	$2C2F8

;	Menu engine. This file runs the scrolling menu of the pause screen, including the Manual and
;	Auto Goalie item, and holds a few helpers for drawing team blocks and waiting for the screen.

Pausemode_top						;Start a menu: a0 = item list, a1 = screen draw routine; selection and
									;first shown item 0. Falls into
									;DrawMenuScreen. Called from PauseMode, and the stats code
	move.l	a0,(menulist).l			;item list
	move.l	a1,(menudraw).l			;draw routine
	clr.w	(menuitem).l			;selected item
	clr.w	(menuitem+2).l			;first item shown
DrawMenuScreen						;Call the draw routine, frame the menu box, print the items and fade in.
									;Called from HandleMenuInput
	movea.l	(menudraw).l,a0
	jsr	(a0)
	jsr	(printsmallz).l
	String	CC_SetAttribute,4,CC_SetY,$C
	bsr.w	SetMenuPrintX
	moveq	#$16,d0					;22 wide
	moveq	#6,d1					;6 high
	jsr	(Framer).l
	bsr.w	Pausemode_Pmenu
	move.w	#$18,(palcount).l		;fade in
;CD: no cartridge twin
.L2C33E
	tst.w	(palcount).l
	bpl.w	.L2C33E
	rts
SetMenuPrintX						;printx = the left edge of the menu box: 5 in 32 column mode, else 9
	move.w	#5,(printx).l
	btst.b	#df32c,(disflags).l		;df32c: 32 column mode on
	bne.w	rtss8
	addi.w	#4,(printx).l
	rts
HandleMenuInput						;Act on the pad bits d1 for the current menu: down / up move the
									;selection, C runs the item's handler and
									;redraws the menu (not if the handler set sflags5 bit 1). Returns eq to
									;leave the menu (start, or C on item 0), ne to stay. Called from
									;PauseMode, and the stats code
	btst	#sbut,d1				;Start?
	bne.w	.flip					;start: Z clear, flipped to eq
	btst	#dbut,d1				;down?
	beq.w	.up
	addi.w	#1,(menuitem).l			;next lower item
	bra.w	Pausemode_Pmenu
.up									;dbut clear
	btst	#ubut,d1				;up?
	beq.w	.sel
	subi.w	#1,(menuitem).l			;next higher item
	bra.w	Pausemode_Pmenu
.sel								;ubut clear
	btst	#cbut,d1				;C?
	beq.w	.flip					;nothing: Z set, flipped to ne
	bsr.w	seta2
	move.w	(menuitem).l,d0			;find the handler of the selected item
	movea.l	(menulist).l,a0
	adda.w	(a0),a0
	adda.w	(a0),a0
	bra.w	.3
;CD: no cartridge twin
.next								;CD: placed where the disc branches to it
	adda.w	#$4,a0
.3									;loop the walk
	adda.w	(a0),a0					;add the entry's word offset to reach the following one
	dbf	d0,.next					;d0 = selected item number: repeat until the selected entry
	movea.l	(a0),a0
	jsr	(a0)						;the handler of the selected item
	bclr.b	#1,(sflags5).l			;the handler drew its own screen
	bne.w	.noredraw
	bsr.w	DrawMenuScreen
.noredraw							;menu redrawn if needed
	tst.w	(menuitem).l			;item 0 (resume) leaves the menu
	rts
.flip								;sbut set or cbut clear
	eori.b	#4,ccr					;invert Z
	rts
Pausemode_Pmenu						;Clamp the selection, scroll the 4 rows shown and print the menu:
									;title, the items (PrintMenuItem), the selected item marked, { / } when
									;there are items above / below.
									;Called from DrawMenuScreen and
									;HandleMenuInput
	move.w	(menuitem).l,d0
	bpl.w	.0
	clr.w	(menuitem).l			;no item above the first
	clr.w	d0
.0									;selection not negative
	movea.l	(menulist).l,a0			;walk the item list d0 entries, stopping at the last one
	adda.w	(a0),a0
	adda.w	(a0),a0
	bra.w	.2
.next								;next item entry
	adda.w	(a0),a0					;advance to the next item entry
;CD: no cartridge twin
	adda.w	#$4,a0
	tst.w	strtext(a0)				;negative: the last item
.2									;loop the walk
	dbmi	d0,.next				;stop after d0 items or at the last item
	addi.w	#1,d0					;d0 = items left unwalked (-1 if all walked), +1 = overshoot
	sub.w	d0,(menuitem).l			;no item below the last
	move.w	(menuitem).l,d0
	cmp.w	(menuitem+2).l,d0
	bge.w	.3
	move.w	d0,(menuitem+2).l		;scroll up
.3									;scrolled up if needed
	subi.w	#3,d0					;selection - 3 = first visible item if it is on the bottom row
	cmp.w	(menuitem+2).l,d0
	ble.w	.print
	move.w	d0,(menuitem+2).l		;scroll down
.print								;print the menu
	bsr.w	SetMenuPrintX			;print the menu: title, then marker columns, then the 4 rows
	move.w	#$D,(printy).l
	movea.l	(menulist).l,a1
	jsr	(printsmall).l				;the menu title
	jsr	(printsmallz).l				;clear the 4 item rows
	StringStart						;36 bytes: past String's 31-arg limit
	dc.b	$FB,$01,$20,$FB,$FF,$FA,$01,$20,$FB,$FF,$FA,$01
	dc.b	$20,$FB,$FF,$FA,$01,$20,$FB,$12,$20,$FB,$FF,$FA
	dc.b	$FF,$20,$FB,$FF,$FA,$FF,$20,$FB,$FF,$FA,$FF,$20
	StringEnd
	adda.w	(a1),a1
	move.w	(menuitem+2).l,d0		;skip to the first item shown
	bra.w	.6
.skip								;skip one item entry
	adda.w	(a1),a1
;CD: no cartridge twin
	adda.w	#$4,a1
.6									;loop the skip
	dbf	d0,.skip					;loop until a1 = first visible item
	moveq	#3,d1					;4 rows
	move.w	#$C,(printy).l
	bsr.w	SetMenuPrintX
	move.w	(menuitem+2).l,d0
	beq.w	.row
	jsr	(printsmallz).l				;more items above
	String	CC_SetAttribute,5,CC_AddX,1,CC_AddY,1,'{',CC_AddY,$FF	;(and hid the rest)
.row								;d0 = 0
	bsr.w	SetMenuPrintX
	jsr	(printsmallz).l				;start of an item row
	String	CC_AddX,2,CC_AddY,1
	move.l	a1,-(sp)
	movea.l	(menulist).l,a1
	jsr	(printsmall).l
	cmp.w	(menuitem).l,d0
	bne.w	.nosel
	jsr	(printsmall).l				;the selected item marker
.nosel								;marker done
	movea.l	(sp)+,a1
;CD: no cartridge twin
	jsr	(PrintMenuItem).l
	addi.w	#$1,d0
	adda.w	#$4,a1
	tst.w	strtext(a1)				;negative: the last item
	dbmi	d1,.row
	bmi.w	.x
	bsr.w	SetMenuPrintX
	jsr	(printsmallz).l				;more items below
	String	CC_SetAttribute,5,CC_AddX,1,'}'	;(and hid the rest)
.x									;exit
	rts
PrintMenuItem						;Print menu item a1 and step a1 past it. An item whose text starts with
									;'x' is the goalie option: it prints Manual Goalie
									;(.manual) when the pause team word is 0, else Auto Goalie (.auto):
									;goaliemode2 with sflags bit 1 (sfpj) set, else goaliemode1. Called from
									;Pausemode_Pmenu
	cmpi.b	#$78,2(a1)				;first char 'x'
	bne.w	.plain
	move.l	a1,-(sp)
	movea.l	#.manual,a1
	btst.b	#sfpj,(sflags).l		;sfpj: the pause pad
	beq.w	.homegoalie
	tst.w	(goaliemode2).l
	bra.w	.chkgoalie
.homegoalie							;sfpj clear
	tst.w	(goaliemode1).l
.chkgoalie							;goalie mode of the pad's team
	beq.w	.print
	movea.l	#.auto,a1
.print								;print the mode
	jsr	(printsmall).l
	movea.l	(sp)+,a1
	adda.w	(a1),a1					;skip the 'x' item text
	bra.w	.x
.plain								;item without a goalie mode
	jsr	(printsmall).l
.x									;exit (also the end of the code above)
	rts
.manual								;manual goalie text
	String	'  Manual Goalie   '	;no label
.auto								;auto goalie text
	String	'   Auto Goalie    '	;no label
PutTeamBlock						;Copy 2 rows of 11 map words from TeamBlockMap+d0 to printx / printy, then
									;printx += 11.
									;Saves d0-d2/a0-a1. Called from PrintTeamLogoAndScore and the stats code
	movem.l	d0-d2/a0-a1,-(sp)
	move.w	(disflags).l,-(sp)
	bset.b	#dfng,(disflags).l		;dfng: don't int graphics
	movea.l	#(TeamBlockMap-M68K_RAM),a1
	adda.w	d0,a1
	moveq	#1,d2					;2 rows
.row								;each row
	jsr	(xyVmMap).l
;CD: no cartridge twin
	moveq	#$A,d1
.1									;CD: placed where the disc branches to it
.L2C5C2
	btst.b	#$7,$FF800E.l
	bne.s	.L2C5C2
	move.w	(a1)+,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2C5E2
	btst.b	#$6,$FF800E.l
	beq.s	.L2C5E2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2C5FC
	btst.b	#$6,$FF800E.l
	bne.s	.L2C5FC
	bclr.b	#$7,$FF800F.l
	dbf	d1,.1
	addi.w	#1,(printy).l
	dbf	d2,.row
	addi.w	#$B,(printx).l
	subi.w	#2,(printy).l
	move.w	(sp)+,(disflags).l
	movem.l	(sp)+,d0-d2/a0-a1
	rts
MenuWaitVblank						;wait till Vcount changes, then resync Vcount. Saves d0. Reads OldVcount
									;twice (93 once). Called from PauseMode, and the stats code
	move.w	d0,-(sp)
	move.w	(OldVcount).l,d0
	move.w	(OldVcount).l,d0
.wait								;loop
	cmp.w	(Vcount).l,d0
	beq.w	.wait
	move.w	(OldVcount).l,(Vcount).l
	move.w	(sp)+,d0
	rts
