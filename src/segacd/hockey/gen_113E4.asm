Pausemode_Pmenu						;Clamp the selection, scroll the 4 rows shown and print the menu:
									;title, the items (PrintMenuItem), the selected item marked, { / } when
									;there are items above / below.
									;Called from DrawMenuScreen and
									;HandleMenuInput
	move.w	$18AD2.l,d0
	bpl.w	.l113F6
	clr.w	$18AD2.l		;no item above the first
	clr.w	d0
.l113F6	movea.l	$18AD6.l,a0
	adda.w	(a0),a0
	adda.w	(a0),a0
	bra.w	.l1140E
.l11404	adda.w	(a0),a0		;advance to the next item entry
	adda.w	#$4,a0
	tst.w	$2(a0)		;negative: the last item
.l1140E	dbmi	d0,.l11404		;stop after d0 items or at the last item
	addi.w	#$1,d0		;d0 = items left unwalked (-1 if all walked), +1 = overshoot
	sub.w	d0,$18AD2.l		;no item below the last
	move.w	$18AD2.l,d0
	cmp.w	$18AD4.l,d0
	bge.w	.l11432
	move.w	d0,$18AD4.l		;scroll up
.l11432	subi.w	#$3,d0		;selection - 3 = first visible item if it is on the bottom row
	cmp.w	$18AD4.l,d0
	ble.w	.l11446
	move.w	d0,$18AD4.l		;scroll down
.l11446	bsr.w	SetMenuPrintX		;print the menu: title, then marker columns, then the 4 rows
	move.w	#$D,(printy).l
	movea.l	$18AD6.l,a1
	jsr	(printsmall).l
	jsr	(printsmallz).l
	dc.w	$0026
	dc.b	$FB,$01,$20,$FB,$FF,$FA,$01,$20,$FB,$FF,$FA,$01,$20,$FB,$FF,$FA,$01,$20,$FB,$12,$20,$FB,$FF,$FA,$FF,$20,$FB,$FF,$FA,$FF,$20,$FB,$FF,$FA,$FF,$20
	adda.w	(a1),a1
	move.w	$18AD4.l,d0		;skip to the first item shown
	bra.w	.l1149C
.l11496	adda.w	(a1),a1
	adda.w	#$4,a1
.l1149C	dbra	d0,.l11496
	moveq	#$3,d1		;4 rows
	move.w	#$C,(printy).l
	bsr.w	SetMenuPrintX
	move.w	$18AD4.l,d0
	beq.w	.l114CA
	jsr	(printsmallz).l
	dc.w	$000C
	dc.b	$FE,$05,$FB,$01,$FA,$01,$7B,$FA,$FF,$00
.l114CA	bsr.w	SetMenuPrintX
	jsr	(printsmallz).l
	dc.w	$0006
	dc.b	$FB,$02,$FA,$01
	move.l	a1,-(sp)
	movea.l	$18AD6.l,a1
	jsr	(printsmall).l
	cmp.w	$18AD2.l,d0
	bne.w	.l114F8
	jsr	(printsmall).l
.l114F8	movea.l	(sp)+,a1
	jsr	(PrintMenuItem).l
	addi.w	#$1,d0
	adda.w	#$4,a1
	tst.w	$2(a1)		;negative: the last item
	dbmi	d1,.l114CA
	bmi.w	.l11526
	bsr.w	SetMenuPrintX
	jsr	(printsmallz).l
	String	CC_Font2,$5,$FB,$1,'}'
.l11526	rts
PrintMenuItem						;Print menu item a1 and step a1 past it. An item whose text starts with
									;'x' is the goalie option: it prints Manual Goalie
									;(.manual) when the pause team word is 0, else Auto Goalie (.auto):
									;goaliemode2 with sflags bit 1 (sfpj) set, else goaliemode1. Called from
									;Pausemode_Pmenu
	cmpi.b	#$78,$2(a1)		;first char 'x'
	bne.w	.l1156E
	move.l	a1,-(sp)
	movea.l	#$2C576,a1
	btst	#$1,$17F6A.l
	beq.w	.l11550
	tst.w	$18C0E.l
	bra.w	.l11556
.l11550	tst.w	$18C0C.l
.l11556	beq.w	.l11560
	movea.l	#$2C58A,a1
.l11560	jsr	(printsmall).l
	movea.l	(sp)+,a1
	adda.w	(a1),a1		;skip the 'x' item text
	bra.w	.l11574
.l1156E	jsr	(printsmall).l
.l11574	rts
PutTeamBlock						;Copy 2 rows of 11 map words from TeamBlockMap+d0 to printx / printy, then
									;printx += 11.
									;Saves d0-d2/a0-a1. Called from PrintTeamLogoAndScore and the stats code
	dc.w	$0014,$2020
	dc.b	'Manual Goalie   '
	dc.b	$00,$14,'   Auto Goalie'
	dc.w	$2020,$2020
Sub_2C59E
	movem.l	d0-d2/a0-a1,-(sp)
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$17FB2,a1
	adda.w	d0,a1
	moveq	#$1,d2
.l115BA	jsr	(xyVmMap).l
	moveq	#$A,d1
.l115C2	btst	#$7,$FF800E.l
	bne.b	.l115C2
	move.w	(a1)+,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
.l115E2	btst	#$6,$FF800E.l
	beq.b	.l115E2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l115FC	btst	#$6,$FF800E.l
	bne.b	.l115FC
	bclr	#$7,$FF800F.l
	dbra	d1,.l115C2
	addi.w	#$1,(printy).l
	dbra	d2,.l115BA
	addi.w	#$B,(printx).l
	subi.w	#$2,(printy).l
	move.w	(sp)+,(disflags).l
	movem.l	(sp)+,d0-d2/a0-a1
	rts
MenuWaitVblank						;wait till Vcount changes, then resync Vcount. Saves d0. Reads OldVcount
									;twice (93 once). Called from PauseMode, and the stats code
	move.w	d0,-(sp)
	move.w	$17476.l,d0
	move.w	$17476.l,d0
.l11648	cmp.w	(ScoutSubStatus).l,d0
	beq.w	.l11648
	move.w	$17476.l,(ScoutSubStatus).l
	move.w	(sp)+,d0
	rts
ShowScores						;"Scores" screen: the other games of the night in gstruct over the Scores
	
	
	moveq	#$6,d0
	moveq	#$1A,d1
	bsr.w	Sub_2E728
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
	bsr.w	L1176C
	jsr	(GetShifter).l
	move.w	d1,d3
	ble.w	.skip
.game	bsr.w	L1182E
	dbra	d3,.game
.skip	clr.w	(SelectedPlayerIdx).l
	move.w	(printy).l,d0
	subi.w	#$15,d0
	bmi.w	.loop
	asl.w	#$3,d0
	move.w	d0,(SelectedPlayerIdx).l
	bsr.w	L118D4
.loop	bsr.w	MenuWaitVblank
	bsr.w	Sub_2F2F0
	btst	#$7,d3
	bne.w	Sub_2E980
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
	beq.w	Sub_2F988
	add.w	(VertLineScrolling).l,d0
	bmi.w	Sub_2F988
	cmp.w	(SelectedPlayerIdx).l,d0
	bgt.w	Sub_2F988
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divu.w	#$18,d0
	swap	d0
	tst.w	d0
	bne.w	L1176C
	bsr.w	L118D4
	clr.w	(PlayerScrollCtr).l
L1176C	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$C00000,a0
.l11780	btst	#$7,$FF800E.l
	bne.b	.l11780
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
.l117A4	btst	#$6,$FF800E.l
	beq.b	.l117A4
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l117BE	btst	#$6,$FF800E.l
	bne.b	.l117BE
	bclr	#$7,$FF800F.l
	move.w	#$FFD0,d0
	add.w	(VertLineScrolling).l,d0
.l117DA	btst	#$7,$FF800E.l
	bne.b	.l117DA
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
.l117FA	btst	#$6,$FF800E.l
	beq.b	.l117FA
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l11814	btst	#$6,$FF800E.l
	bne.b	.l11814
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
L1182E	cmp.w	$18A98.l,d3
	beq.w	Sub_2F988
	moveq	#$10,d0
	mulu.w	d3,d0
	movea.l	#$18A18,a0
	adda.w	d0,a0
	btst	#$1,$E(a0)
	bne.w	Sub_2F988
	btst	#$2,$E(a0)
	bne.w	Sub_2F988
	move.w	$2(a0),d0
	move.w	$C(a0),d1
	bsr.w	PrintGameInfo
	addi.w	#$1,(printy).l
	move.w	$0(a0),d0
	move.w	$A(a0),d1
	bsr.w	PrintGameInfo
	move.w	$8(a0),d0
	subi.w	#$1,d0
	movea.l	#$41A34,a1
	move.w	#$1C,(printx).l
	jsr	(Sub_3CEBE).l
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
L118D4	movem.l	d0-d1/a1,-(sp)
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
	dc.w	$43FA,$000E
	jsr	(Sub_3CEBE).l
	movem.l	(sp)+,d0-d1/a1
	rts
	dc.w	$000A,$20FB,$FFFA,$1320,$F900,$000A,$7BFB,$FFFA
	dc.w	$1320,$F900,$000A,$20FB,$FFFA,$137D,$F900,$08EA
	dc.w	$0000,$0032,$7000,$721C,$6100,$1DEA,$4279,$0001
	dc.w	$A44E,$4279,$0001,$A452,$33FC,$0001,$0001,$A45A
Sub_2C954
	jsr	(printsmallz).l
	dc.w	$0008
	dc.b	$FF,$02,$FD,$00,$FC,$00
	moveq	#$28,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	st.b	$17F60.l
	bsr.w	Sub_2CE80
LineEditorMenu						;Slot cursor loop: start exits, C picks a player for the slot
	
	
	
	bsr.w	DrawTeamScreen
	bsr.w	DrawLineIcons
.loop	bsr.w	MenuWaitVblank
	bsr.w	Sub_2F2F0
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
	bsr.w	Sub_2F2F0
	jsr	(ProcessInputWithRepeat).l
	btst	#$7,d1
	bne.w	LineEditorMenu
	btst	#$5,d1
	bne.w	.l11B54
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
.l11B54	movea.l	#$BBD30,a3
	adda.w	(VertLineScrolling).l,a3
	move.b	(a3),d0
	addi.b	#$1,d0		;SetLineSlot wants 1 based
	move.w	(TestList).l,d2
	bsr.w	SetLineSlot		;put the picked player in the slot
	bra.w	LineEditorMenu		;back to the slot cursor
PrintAttribHeader						;Line editor player list: the column header of attribute page
	
	
	jsr	(printz).l
	String	CC_Font2Pri,$16,$1
.top	movea.l	#$41C48,a1
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
	movea.l	#$BBD30,a3
	move.w	(PlayerScrollCtr).l,d2
	move.w	(screentimer).l,d1
	sub.w	d2,d1
	cmpi.w	#$5,d1
	bls.w	.4
	moveq	#$5,d1
.4	move.w	#$2,(printy).l
.row	jsr	(printsmallz).l
	dc.w	$0020
	dc.b	$FE,$04,$FD,$05,$FA,$01,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$FD,$05
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
	dc.w	$41FA,$008F
	move.w	(TestList).l,d0
	lsr.w	#$3,d0
	adda.w	d0,a0
	tst.w	$18C0A.l
	beq.w	.0
	suba.w	#$1,a0
.0	move.b	(a0),d0
	cmp.b	$17F60.l,d0
	beq.w	.l11C58
	move.b	d0,$17F60.l
	bsr.w	Sub_2CD7A
.l11C58	btst	d5,$17F60.l
	beq.w	.l11C66
	bsr.w	DrawLineIcon
.l11C66	dbra	d5,.l11C58
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$8,$7,CC_SetFont,$1
	moveq	#$18,d0
	moveq	#$3,d1
	jsr	(Framer).l
	jsr	(printsmallz).l
	String	CC_Font3,$15,$FC,$8
	move.w	d6,d0
	jsr	(Sub_4112E).l
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	move.w	d7,(printa).l
	jsr	(printsmall).l
	clr.w	(printfontset).l
	rts
	dc.w	$0107,$0707,$1818,$6060		;the entry before LineIconGroups (read with OptLine set)
DrawLineIcon						;Line editor: draw line d5 (its name from linelist, then its player slots)
	
	moveq	#$6,d0
	mulu.w	d5,d0
	dc.w	$41FA,$01D0
	adda.w	d0,a0
	tst.w	$18C0A.l
	beq.w	.0
	suba.w	#$6,a0
.0	move.w	(a0),(printx).l
	move.w	$2(a0),(printy).l
	move.w	d5,d0
	movea.l	#$419F6,a1
	move.w	#$8000,(printa).l
	jsr	(Sub_3CEBE).l
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
	dc.w	$0008
	dc.b	$FB,$FF,$FA,$02,$FE,$06
	clr.w	d0
	move.b	(a3,d4.w),d0
	subi.w	#$1,d0
	jsr	$41226.l
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
Sub_2CD7A
	jsr	(printsmallz).l
	dc.w	$0008
	dc.b	$FF,$02,$FD,$00,$FC,$0A
	moveq	#$28,d0
	moveq	#$12,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	$2CE96.l,(printy).l
	move.w	(LineIconPosTable).l,(printx).l
	tst.w	$18C0A.l
	beq.w	.l11DBE
	move.w	$2CE8E.l,(printx).l
.l11DBE	jsr	(printsmallz).l
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
	beq.w	Sub_2C59E
	moveq	#$2C,d0
	bra.w	Sub_2C59E
ClearLineEditorTop						;Erase 40 x 10 at the top of map 2
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	moveq	#$28,d0
	moveq	#$A,d1
	move.w	#$7FF,d2
	jmp	(eraser).l
Sub_2CE80
	clr.w	$BBD0A.l
	clr.w	$BBD2A.l
	rts
	dc.w	$0010,$000C,$0004
LineIconPosTable						;Line icons: x, y, slot count - 1 per line
	dc.w	$0004,$000C,$0004,$0010,$000C,$0004,$001C,$000C
	dc.w	$0004,$0004,$000C,$0004,$0010,$000C,$0004,$0004
	dc.w	$000C,$0003,$0010,$000C,$0003,$FFFF
LineCursorTable						;The slot after a cursor move: indexed by slot + 8 (up / down / left /
	
	dc.w	$0101,$0203,$0405,$1901,$0101,$0203,$0405,$1901
	dc.w	$0909,$0A0B,$0C0D,$2101,$1111,$1213,$1415,$2101
	dc.w	$0519,$1A1B,$1C1D,$2901,$0D21,$2223,$2425,$3101
	dc.b	$1D,')*+,,',$01,$01,'%12344',$01,$01
	dc.b	'%12344',$01,$01
LineEditorExit
	bsr.w	Sub_2CE80
	move.w	#$18,(palcount).l
.l11F14	tst.w	(palcount).l
	bpl.w	.l11F14
	move.l	$18AD2.l,-(sp)
	move.l	$18AD6.l,-(sp)
	move.l	$18ADA.l,-(sp)
	movea.l	#$3C000,a1
	movea.l	#$427D8,a0
	movea.l	#$18C26,a3
	move.w	$2A(a2),d0
	addi.w	#$1,d0
	cmp.b	(a3),d0
	beq.w	.l11F56
	movea.l	#$42848,a0
.l11F56	jsr	(printsmallz).l
	String	CC_Font1,$2
	bsr.w	Sub_2C2F8
.l11F64	bsr.w	MenuWaitVblank
	bsr.w	Sub_2F2F0
	jsr	(ProcessInputWithRepeat).l
	move.w	d1,-(sp)
	bsr.w	HandleMenuInput
	move.w	(sp)+,d1
	andi.w	#$A0,d1
	beq.w	.l11F64
	jsr	(printsmallz).l
	String	CC_SetFont
	move.w	$18AD2.l,d0
	move.l	(sp)+,$18ADA.l
	move.l	(sp)+,$18AD6.l
	move.l	(sp)+,$18AD2.l
	tst.w	d0
	bne.w	Sub_2C954
	bra.w	Sub_2E980
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
.done	jsr	$2A5C8.l
	movem.l	(sp)+,d0-d4/a0-a3
	rts
AttributeOffsetTbl						;Line slots saved in databuffer ($FF ends)
	dc.w	$0102,$0304,$0509,$0A0B,$0C0D,$1112,$1314,$1519
	dc.b	$1A,$1B,$1C,$1D,'!"#$%)*+,123'
	dc.w	$34FF
TeamRosterScreen						;"Team Roster" screen for team a2: pages of players (DisplayPlayerList:
	
	
	moveq	#$D,d0
	moveq	#$17,d1
	bsr.w	Sub_2E728
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
	beq.w	.l1212C
	moveq	#$2C,d0
.l1212C	bsr.w	Sub_2C59E
	jsr	(printsmallz).l
	dc.w	$0034
	dc.b	$F8,$06,$03,$02,$0C,$F9,$01,$50,$6F,$73,$2E,$5E,$50,$6C,$61,$79,$65,$72,$FD,$1E,$FC,$0C,$52,$61,$74,$69,$6E,$67,$FD,$0C,$FC,$1A,$41,$5E,$2D,$5E,$53,$77,$69,$74,$63,$68,$5E,$54,$65,$61,$6D,$73,$F9,$00
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
	bsr.w	Sub_2D396
	move.w	(SelectedPlayerIdx).l,d0
	mulu.w	#$80,d0
	move.w	d0,(VertLineScrolling).l
	bsr.w	Sub_2D264
	clr.w	(PlayerScrollCtr).l
.loop	bsr.w	MenuWaitVblank
	bsr.w	Sub_2F2F0
	jsr	(ProcessInputWithRepeat).l
	btst	#$7,d3
	bne.w	Sub_2E980
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
	bsr.w	Sub_2D396
	bra.w	.scroll
.team	lea.l	$366(a2),a2
	cmpa.l	#$186B2,a2
	beq.w	.redraw
	movea.l	#tmstruct,a2		;away -> back to home
	bra.w	.redraw
CheckPlayerListScroll						;TeamRosterScreen per frame: add PlayerScrollCtr to VertLineScrolling (0
	
	move.w	(PlayerScrollCtr).l,d0
	beq.w	Sub_2F988
	add.w	(VertLineScrolling).l,d0
	bmi.w	L12366
	cmpi.w	#$380,d0
	bgt.w	L12366
Sub_2D264
	move.w	(VertLineScrolling).l,d1
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divs.w	#$80,d0
	swap	d0
	tst.w	d0
	bne.w	.l12284
	clr.w	(PlayerScrollCtr).l
.l12284	andi.w	#$7F,d1
	bne.w	.l122A4
	cmpi.w	#$7E,d0
	bne.w	.l12298
	bsr.w	L1236E
.l12298	cmpi.w	#$2,d0
	bne.w	.l122A4
	bsr.w	L12380
.l122A4	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$C00000,a0
.l122B8	btst	#$7,$FF800E.l
	bne.b	.l122B8
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
.l122DC	btst	#$6,$FF800E.l
	beq.b	.l122DC
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l122F6	btst	#$6,$FF800E.l
	bne.b	.l122F6
	bclr	#$7,$FF800F.l
	move.w	#$FF90,d0
	add.w	(VertLineScrolling).l,d0
.l12312	btst	#$7,$FF800E.l
	bne.b	.l12312
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
.l12332	btst	#$6,$FF800E.l
	beq.b	.l12332
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1234C	btst	#$6,$FF800E.l
	bne.b	.l1234C
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
L12366	clr.w	(PlayerScrollCtr).l
	rts
L1236E	move.l	d0,-(sp)
	swap	d0
	move.w	d0,(SelectedPlayerIdx).l
	bsr.w	Sub_2D396
	move.l	(sp)+,d0
	rts
L12380	move.l	d0,-(sp)
	swap	d0
	addi.w	#$1,d0
	move.w	d0,(SelectedPlayerIdx).l
	bsr.w	Sub_2D396
	move.l	(sp)+,d0
	rts
