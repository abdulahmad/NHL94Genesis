DrawMenuScreen						;Call the draw routine, frame the menu box, print the items and fade in.
	
	movea.l	(menudraw).l,a0
	jsr	(a0)
	jsr	(printsmallz).l
	String	CC_Font2,$4,$FC,$C
	bsr.w	SetMenuPrintX
	moveq	#$16,d0
	moveq	#$6,d1
	jsr	(Framer).l
	bsr.w	Pausemode_Pmenu
	move.w	#$18,(palcount).l
.loop	tst.w	(palcount).l
	bpl.w	.loop
	rts
SetMenuPrintX						;printx = the left edge of the menu box: 5 in 32 column mode, else 9
	move.w	#$5,(printx).l
	btst	#df32c,(disflags).l
	bne.w	rtss8
	addi.w	#$4,(printx).l
	rts
HandleMenuInput						;Act on the pad bits d1 for the current menu: down / up move the
	
	
	
	
	btst	#sbut,d1
	bne.w	.next5
	btst	#dbut,d1
	beq.w	.up
	addi.w	#$1,(menuitem).l
	bra.w	Pausemode_Pmenu
.up	btst	#ubut,d1
	beq.w	.sel
	subi.w	#$1,(menuitem).l
	bra.w	Pausemode_Pmenu
.sel	btst	#cbut,d1
	beq.w	.next5
	bsr.w	seta2
	move.w	(menuitem).l,d0
	movea.l	(menulist).l,a0
	adda.w	(a0),a0
	adda.w	(a0),a0
	bra.w	.next3
.3	adda.w	#$4,a0
.next3	adda.w	(a0),a0
	dbra	d0,.3
	movea.l	(a0),a0
	jsr	(a0)
	bclr	#$1,(sflags5).l
	bne.w	.noredraw
	bsr.w	DrawMenuScreen
.noredraw	tst.w	(menuitem).l		;item 0 (resume) leaves the menu
	rts
.next5	eori.b	#$4,ccr		;invert Z
	rts

Pausemode_Pmenu						;Clamp the selection, scroll the 4 rows shown and print the menu:
									;title, the items (PrintMenuItem), the selected item marked, { / } when
									;there are items above / below.
									;Called from DrawMenuScreen and
									;HandleMenuInput
	move.w	(menuitem).l,d0
	bpl.w	.0
	clr.w	(menuitem).l		;no item above the first
	clr.w	d0
.0	movea.l	(menulist).l,a0
	adda.w	(a0),a0
	adda.w	(a0),a0
	bra.w	.2
.next	adda.w	(a0),a0		;advance to the next item entry
	adda.w	#$4,a0
	tst.w	strtext(a0)		;negative: the last item
.2	dbmi	d0,.next		;stop after d0 items or at the last item
	addi.w	#$1,d0		;d0 = items left unwalked (-1 if all walked), +1 = overshoot
	sub.w	d0,(menuitem).l		;no item below the last
	move.w	(menuitem).l,d0
	cmp.w	(MenuScrollTop).l,d0
	bge.w	.next3
	move.w	d0,(MenuScrollTop).l		;scroll up
.next3	subi.w	#$3,d0		;selection - 3 = first visible item if it is on the bottom row
	cmp.w	(MenuScrollTop).l,d0
	ble.w	.print
	move.w	d0,(MenuScrollTop).l		;scroll down
.print	bsr.w	SetMenuPrintX		;print the menu: title, then marker columns, then the 4 rows
	move.w	#$D,(printy).l
	movea.l	(menulist).l,a1
	jsr	(printsmall).l
	jsr	(printsmallz).l
; Inline data read by printsmallz from the return address (2 rows).
	dc.w	$0026
	dc.b	$FB,$01,$20,$FB,$FF,$FA,$01,$20,$FB,$FF,$FA,$01,$20,$FB,$FF,$FA,$01,$20,$FB,$12,$20,$FB,$FF,$FA,$FF,$20,$FB,$FF,$FA,$FF,$20,$FB,$FF,$FA,$FF,$20
	adda.w	(a1),a1
	move.w	(MenuScrollTop).l,d0		;skip to the first item shown
	bra.w	.next5
.skip	adda.w	(a1),a1
	adda.w	#$4,a1
.next5	dbra	d0,.skip
	moveq	#$3,d1		;4 rows
	move.w	#$C,(printy).l
	bsr.w	SetMenuPrintX
	move.w	(MenuScrollTop).l,d0
	beq.w	.row
	jsr	(printsmallz).l
; Inline data read by printsmallz from the return address (2 rows).
	dc.w	$000C
	dc.b	$FE,$05,$FB,$01,$FA,$01,$7B,$FA,$FF,$00
.row	bsr.w	SetMenuPrintX
	jsr	(printsmallz).l
; Inline data read by printsmallz from the return address (2 rows).
	dc.w	$0006
	dc.b	$FB,$02,$FA,$01
	move.l	a1,-(sp)
	movea.l	(menulist).l,a1
	jsr	(printsmall).l
	cmp.w	(menuitem).l,d0
	bne.w	.nosel
	jsr	(printsmall).l
.nosel	movea.l	(sp)+,a1
	jsr	(PrintMenuItem).l
	addi.w	#$1,d0
	adda.w	#$4,a1
	tst.w	strtext(a1)		;negative: the last item
	dbmi	d1,.row
	bmi.w	.x
	bsr.w	SetMenuPrintX
	jsr	(printsmallz).l
	String	CC_Font2,$5,$FB,$1,'}'
.x	rts
PrintMenuItem						;Print menu item a1 and step a1 past it. An item whose text starts with
									;'x' is the goalie option: it prints Manual Goalie
									;(.manual) when the pause team word is 0, else Auto Goalie (.auto):
									;goaliemode2 with sflags bit 1 (sfpj) set, else goaliemode1. Called from
									;Pausemode_Pmenu
	cmpi.b	#$78,$2(a1)		;first char 'x'
	bne.w	.plain
	move.l	a1,-(sp)
	movea.l	#PrintMenuItem_manual,a1
	btst	#sfpj,(sflags).l
	beq.w	.homegoalie
	tst.w	(goaliemode2).l
	bra.w	.chkgoalie
.homegoalie	tst.w	(goaliemode1).l
.chkgoalie	beq.w	.print
	movea.l	#PutTeamBlockAutoGoalieText,a1
.print	jsr	(printsmall).l
	movea.l	(sp)+,a1
	adda.w	(a1),a1		;skip the 'x' item text
	bra.w	.x
.plain	jsr	(printsmall).l
.x	rts
PrintMenuItem_manual						;Copy 2 rows of 11 map words from TeamBlockMap+d0 to printx / printy, then
									;printx += 11.
									;Saves d0-d2/a0-a1. Called from PrintTeamLogoAndScore and the stats code
; "Manual Goalie" String
PutTeamBlockManualGoalieText	dc.w	$0014,$2020
	dc.b	'Manual Goalie   '
; " Auto Goalie" String
PutTeamBlockAutoGoalieText	dc.b	$00,$14,'   Auto Goalie'
	dc.w	$2020,$2020
; Draws a team block with display flags set.
PutTeamBlock
	movem.l	d0-d2/a0-a1,-(sp)
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#TeamBlockMap,a1
	adda.w	d0,a1
	moveq	#$1,d2
.loop	jsr	(xyVmMap).l
	moveq	#$A,d1
.loop2	btst	#$7,(GA_COMFLAGS).l
	bne.b	.loop2
	move.w	(a1)+,(GA_COMSTAT1).l
	move.w	#$D,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.loop3	btst	#$6,(GA_COMFLAGS).l
	beq.b	.loop3
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.loop4	btst	#$6,(GA_COMFLAGS).l
	bne.b	.loop4
	bclr	#$7,(GA_COMFLAGS+1).l
	dbra	d1,.loop2
	addi.w	#$1,(printy).l
	dbra	d2,.loop
	addi.w	#$B,(printx).l
	subi.w	#$2,(printy).l
	move.w	(sp)+,(disflags).l
	movem.l	(sp)+,d0-d2/a0-a1
	rts
MenuWaitVblank						;wait till Vcount changes, then resync Vcount. Saves d0. Reads OldVcount
									;twice (93 once). Called from PauseMode, and the stats code
	move.w	d0,-(sp)
	move.w	(OldVcount).l,d0
	move.w	(OldVcount).l,d0
.wait	cmp.w	(Vcount).l,d0
	beq.w	.wait
	move.w	(OldVcount).l,(Vcount).l
	move.w	(sp)+,d0
	rts