ShootoutModeBox						;Shootout "SHOOTOUT MODE" box: the shooter " vs." the goalie and both
									;teams' shootout goals. Jumped to from PenaltyShotBox
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$FFFF,d0
	jsr	(prefmes).l
	jsr	(printz).l
	String	CC_Font1Pri,$3,$2
	moveq	#$1B,d0
	moveq	#$C,d1
	jsr	(Framer).l
	lea.l	.next3(pc),a1
	jsr	(printbig).l
	move.w	(BA_Skater_Offset).l,d0
	movea.l	#tmstruct,a2
	tst.w	(BA_Team).l
	beq.w	.0
	movea.l	#awtmstruct,a2
.0	jsr	(FormatPlayerNumInitial).l
	move.w	(printx).l,-(sp)
	jsr	(print).l
	move.w	(sp)+,(printx).l
	addi.w	#$1,(printy).l
	addi.w	#$6,(printx).l
	jsr	(printz).l
	String	' vs.',CC_Font1Pri,$4,$7
	move.w	(BA_Goalie_SCnum).l,d0
	asl.w	#$7,d0
	movea.l	#SortCords,a2
	adda.w	d0,a2
	clr.w	d0
	move.b	pnum(a2),d0		;goalie roster index
	movea.l	#awtmstruct,a2
	tst.w	(BA_Team).l
	beq.w	.1
	movea.l	#tmstruct,a2
.1	jsr	(FormatPlayerNumInitial).l
	jsr	(print).l
	jsr	(printz).l
	String	CC_Font1Pri,$4,$9
	movea.l	#tmstruct,a1
	movea.l	tmdata(a1),a1
	adda.w	$4(a1),a1
	jsr	(print).l
	move.w	#$15,(printx).l
	move.w	(homeshootgoals).l,d0
	move.w	#$3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	CC_Font1Pri,$4,$A
	movea.l	#awtmstruct,a1
	movea.l	tmdata(a1),a1
	adda.w	$4(a1),a1
	jsr	(print).l
	move.w	#$15,(printx).l
	move.w	(awayshootgoals).l,d0
	move.w	#$3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	CC_Font1Pri,$4,$C,'Round'
	move.l	d0,d0
	move.w	(shootoutround).l,d0
	move.w	#$2,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Text of ShootoutModeBox (2 rows).
.next3	dc.b	$00,$16,$BF,$04,$03,'SHOOTOUT MO'
	dc.w	$4445,$BF04,$0500
ClearShootout						;Clear the player structs (SortCords) and the shootout state.
	movea.l	#SortCords,a0
	move.w	#$3FF,d0
.loop	clr.w	(a0)+
	dbra	d0,.loop
	clr.w	(shootoutdelay).l
	move.w	#$1,(shootoutround).l
	bclr	#$3,(gmode2).l
	clr.w	(homeshootgoals).l
	clr.w	(awayshootgoals).l
	clr.w	(homeshootnum).l
	clr.w	(shootoutteam).l
	bsr.w	InitShooters
	move.w	#$1,(shootoutteam).l
	bsr.w	InitShooters
	clr.w	(shootoutteam).l
	rts

NextShooter						;Shootout: the next shooter (BA_Team, BA_Goalie_SCnum, StartShootoutPath),
	
	btst	#$3,(gmode2).l
	beq.w	.0
	jmp	(GameOverCheckScroll).l
.0	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	StartShootoutPath
	move.w	(shootoutteam).l,(BA_Team).l
	move.w	#$B,(BA_Goalie_SCnum).l
	movea.l	#homeshooters,a0
	tst.w	(shootoutteam).l
	beq.w	.1
	move.w	#$5,(BA_Goalie_SCnum).l
	movea.l	#awayshooters,a0
.1	move.w	(homeshootnum).l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),(BA_Skater_Offset).l
	bclr	#pfnc,(SortCords+(puckscnum*SCstruct)+pflags).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
CountShootoutGoals						;Shootout: count the goals and end it when one team cannot catch up
	
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#$0,(shootoutteam+1).l
	beq.w	.switch
	cmpi.w	#$5,(shootoutround).l
	blt.w	.switch
	move.w	(homeshootgoals).l,d0
	cmp.w	(awayshootgoals).l,d0
	beq.w	.switch
	bset	#$3,(gmode2).l
	jsr	(EndShootout).l
	bra.w	.x
.switch	eori.w	#$1,(shootoutteam).l
	bne.w	.x
	addi.w	#$1,(homeshootnum).l
	cmpi.w	#$5,(homeshootnum).l
	blt.w	.1
	clr.w	(homeshootnum).l
.1	addi.w	#$1,(shootoutround).l
.x	movem.l	(sp)+,d0-d7/a0-a6
	rts
InitShooters						;Shootout: the 6 starters of the home (shootoutteam 0) or away team as the
	
	movea.l	#homeshootnum,a0
	move.w	(HomeTeam).l,d0
	tst.w	(shootoutteam).l
	beq.w	.0
	move.w	(VisTeam).l,d0
	movea.l	#shootoutteam,a0
.0	movea.l	#TeamList,a1
	asl.w	#$2,d0
	movea.l	(a1,d0.w),a1
	adda.w	$6(a1),a1
	move.w	#$5,d0
.loop	clr.w	d1
	move.b	(a1)+,d1
	subi.w	#$1,d1
	move.w	d1,-(a0)
	dbra	d0,.loop
	rts
ShootoutWonBy						;Shootout: "SHOOTOUT WON BY" (printbig). Called from SetPA
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	CC_Font1Pri,$1,$D
	move.w	#$6,d1
	move.w	#$1E,d0
	jsr	(Framer).l
	jsr	(printbigz).l
	String	CC_Font1Pri,$2,$E,'SHOOTOUT WON BY'
	addi.w	#$2,(printy).l
	move.w	(HomeTeam).l,d1
	move.w	(homeshootgoals).l,d0
	cmp.w	(awayshootgoals).l,d0
	bgt.w	.0
	move.w	(VisTeam).l,d1
.0	asl.w	#$2,d1
	movea.l	#TeamList,a1
	movea.l	(a1,d1.w),a1
	adda.w	$4(a1),a1
	move.w	#$2,(printx).l
	jsr	(printbig).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ShootoutShooters						;Shootout shooters menu item (menu lists): pick
	
	btst	#$0,(gmode2).l
	beq.w	ShootersExit
	moveq	#$0,d0
	moveq	#$1C,d1
	jsr	(SetupScreen).l
	clr.w	(scoutcolumn).l
	clr.w	(PlayerScrollCtr).l
	jsr	(printsmallz).l
; Inline data read by printsmallz from the return address (2 rows).
	dc.w	$0008
	dc.b	$FF,$02,$FD,$00,$FC,$00
	moveq	#$28,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	bsr.w	ResetShooterScroll
	bsr.w	ShooterScreenTitles
	move.w	#$0,(TestList).l
; Redraws the shooter selection screen: list, rows and frame
ShootoutShootersRedraw	bsr.w	ShootersBackground
	bsr.w	ShooterScreenRows
	bsr.w	ShooterScreenFrame
ShootersLoop						;Shootout shooters: the input loop
	jsr	(MenuWaitVblank).l
	jsr	(ReadActiveJoypad).l
	jsr	(ProcessInputWithRepeat).l
	btst	#$7,d1
	bne.w	ShootersExit
	move.w	#$1,d0
	btst	#$1,d1
	bne.w	ShootersMove
	move.w	#$FFFF,d0
	btst	#$0,d1
	bne.w	ShootersMove
	move.w	#$0,d0
	btst	#$2,d1
	bne.w	ShootersPick
	move.w	#$5,d0
	btst	#$3,d1
	bne.w	ShootersPick
	btst	#$5,d1
	bne.w	ShooterSelectList
	bra.w	ShootersLoop
ShootersExit	jmp	(StatsScreenFadeIn).l
ShooterSelectList						;Shootout shooters: "{Select Player}" list
	move.w	#$C000,d7
	movea.l	#homeshooters,a0
	cmpa.l	#tmstruct,a2
	beq.w	.0
	movea.l	#awayshooters,a0
.0	move.w	(TestList).l,d0
	asl.w	#$1,d0
	move.w	(a0,d0.w),d6
	jsr	(GetGoalieCount).l
	move.w	d0,d1
	jsr	(GetPlayerCount).l
	sub.w	d1,d0
	subi.w	#$1,d0
	cmpi.w	#$5,(TestList).l
	bne.w	.1
	move.w	d1,d0
	subi.w	#$1,d0
	clr.w	d1
.1	move.w	d0,(screentimer).l
	clr.w	(PlayerScrollCtr).l
	clr.w	(VertLineScrolling).l
	movea.l	#Satt,a0
	clr.w	d2
.loop	move.b	d1,(a0,d2.w)
	cmp.w	d1,d6
	bne.w	.2
	move.w	d2,(VertLineScrolling).l
.2	addi.w	#$1,d1
	addi.w	#$1,d2
	dbra	d0,.loop
	bsr.w	ClearShooterScreen
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$0,$3,$1,$0
	move.w	#$12,d0
	move.w	#$3,d1
	jsr	(Framer).l
	jsr	(printsmallz).l
	String	CC_Font3,$15,$FC
	move.w	#$12,d0
	move.w	#$3,d1
	jsr	(Framer).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$2,$1,'{Select Player}'
	clr.w	d0
	bra.w	.scroll
.loop2	jsr	(MenuWaitVblank).l
	jsr	(ReadActiveJoypad).l
	jsr	(ProcessInputWithRepeat).l
	btst	#$7,d1
	bne.w	ShootoutShootersRedraw
	btst	#$5,d1
	bne.w	.next
	moveq	#$1,d0
	btst	#$1,d1
	bne.w	.scroll
	btst	#$3,d1
	bne.w	.page
	moveq	#-1,d0
	btst	#$0,d1
	bne.w	.scroll
	btst	#$2,d1
	bne.w	.page
	bra.w	.loop2
.page	add.w	(scoutcolumn).l,d0
	bmi.w	.loop2
	move.w	d0,(scoutcolumn).l
	bsr.w	PrintShooterList
	bra.w	.loop2
.scroll	add.w	(VertLineScrolling).l,d0
	bmi.w	.loop2
	cmp.w	(screentimer).l,d0
	bgt.w	.loop2
	move.w	d0,(VertLineScrolling).l
	cmp.w	(PlayerScrollCtr).l,d0
	bgt.w	.8
	move.w	d0,(PlayerScrollCtr).l
.8	subi.w	#$5,d0
	cmp.w	(PlayerScrollCtr).l,d0
	ble.w	.9
	move.w	d0,(PlayerScrollCtr).l
.9	bsr.w	PrintShooterList
	bra.w	.loop2
.next	movea.l	#Satt,a3
	adda.w	(VertLineScrolling).l,a3
	clr.w	d0
	move.b	(a3),d0
	move.w	(TestList).l,d2
	movea.l	#homeshooters,a0
	cmpa.l	#tmstruct,a2
	beq.w	.11
	movea.l	#awayshooters,a0
.11	asl.w	#$1,d2
	move.w	d0,(a0,d2.w)
	bra.w	ShootoutShootersRedraw
PrintShooterList						;Shootout shooters: the player list rows (getNameandAttrib)
	jsr	(printz).l
	String	CC_Font2Pri,$16,$1
.loop	movea.l	#PAttribOverall,a1
	cmpi.w	#$5,(TestList).l
	bne.w	.0
	movea.l	#GAttribOverall,a1
.0	move.w	(scoutcolumn).l,d0
	bra.w	.1
.loop2	adda.w	(a1),a1
	adda.w	#$4,a1
.1	tst.w	(a1)
	dbmi	d0,.loop2
	bpl.w	.found
	subi.w	#$1,(scoutcolumn).l
	bra.w	.loop
.found	cmpa.l	#PAttribOverall,a1
	bne.w	.3
	movea.l	#ShooterOverallTxt,a1
.3	cmpa.l	#GAttribOverall,a1
	bne.w	.4
	movea.l	#$27F3E,a1
.4	jsr	(print).l
	move.l	(a1),d4
	movea.l	#Satt,a3
	move.w	(PlayerScrollCtr).l,d2
	move.w	(screentimer).l,d1
	sub.w	d2,d1
	cmpi.w	#$5,d1
	bls.w	.5
	moveq	#$5,d1
.5	move.w	#$2,(printy).l
.loop3	jsr	(printsmallz).l
; Inline data read by printsmallz from the return address (2 rows).
	dc.w	$0020
	dc.b	$FE,$04,$FD,$05,$FA,$01,'                      ',$FD,$05
	cmp.w	(VertLineScrolling).l,d2
	bne.w	.6
	move.w	d7,(printa).l
.6	clr.w	d0
	move.b	(a3,d2.w),d0
	jsr	(GetNameandAttrib).l
	addi.w	#$1,d2
	dbra	d1,.loop3
	rts
; Data that follows PrintShooterList (strings, small tables)
ShooterOverallTxt	dc.b	$00,$12,'    Overall   '
	dc.b	' ]',$1F,':',$00,$0A,$00,$12,'    Over'
	dc.b	'all    ]',$1B,$0F,$00,$0A
ShootersPick
	cmp.w	(TestList).l,d0
	beq.w	ShootersLoop
	bra.w	ShootersSelect
ShootersMove						;Shootout shooters: move the slot cursor by d0, wrapping in 0 ... 4 (not
	
	cmpi.w	#$5,(TestList).l
	beq.w	ShootersLoop
	add.w	(TestList).l,d0
	bmi.w	ShootersMove_0
	cmpi.w	#$5,d0
	blt.w	ShootersSelect
	clr.w	d0
	bra.w	ShootersSelect
ShootersMove_0						;Shootout shooters: TestList = d0, redraw the names and the player box,
	
	move.w	#$4,d0
; Stores the chosen shooter and redraws the rows and frame
ShootersSelect	move.w	d0,(TestList).l
	bsr.w	ShooterScreenRows
	bsr.w	ShooterScreenFrame
	bra.w	ShootersLoop		;back to the input loop
; Clears the shooter screen and draws its backdrop.
ShootersBackground
	bsr.w	ClearShooterScreen
	movem.l	d0-d5/a0-a2,-(sp)
	jsr	(printz).l
	String	CC_Font3,$0,$0
	movea.l	(EASportsBGMap).l,a1
	adda.l	$4(a1),a1
	movea.l	#null,a2
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
	String	CC_Font2Pri,$A,$4,'  Shootout  ',CC_Font2Pri,$F,$1
	clr.w	d0
	cmpa.l	#tmstruct,a2
	beq.w	.next
	move.w	#$2C,d0
.next	jmp	(PutTeamBlock).l
ClearShooterScreen						;Shootout shooters: erase the screen
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	moveq	#$28,d0
	moveq	#$A,d1
	move.w	#$7FF,d2
	jmp	(eraser).l
ResetShooterScroll
	clr.w	(palfadenew+$5A).l
	clr.w	(palfadenew+$7A).l
	rts
; Prints the shooter screen heading.
ShooterScreenTitles
	jsr	(printsmallz).l
; Inline data read by printsmallz from the return address (2 rows).
	dc.w	$0008
	dc.b	$FF,$02,$FD,$00,$FC,$0A
	jsr	(printsmallz).l
	String	CC_Font2,$4
	jsr	(printsmallz).l
	String	CC_Font3,$7,$FC,$C,'Shooters'
	jsr	(printsmallz).l
	String	CC_Font3,$3,$FC,$E,'1. '
	jsr	(printsmallz).l
	String	CC_Font3,$3,$FC,$10,'2. '
	jsr	(printsmallz).l
	String	CC_Font3,$3,$FC,$12,'3. '
	jsr	(printsmallz).l
	String	CC_Font3,$3,$FC,$14,'4. '
	jsr	(printsmallz).l
	String	CC_Font3,$3,$FC,$16,'5. '
	jsr	(printsmallz).l
	String	CC_Font3,$1A,$FC,$C,'Goalie'
	rts
; Prints the shooter screen frame.
ShooterScreenFrame
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$8,$7,CC_SetFont,$1
	moveq	#$18,d0
	moveq	#$3,d1
	jsr	(Framer).l
	jsr	(printsmallz).l
	String	CC_Font3,$15,$FC,$8,CC_Font2,$6
	movea.l	#homeshooters,a1
	cmpa.l	#tmstruct,a2
	beq.w	.next
	movea.l	#awayshooters,a1
.next	move.w	(TestList).l,d0
	asl.w	#$1,d0
	move.w	(a1,d0.w),d0
	jsr	(getname).l
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	jsr	(printsmall).l
	clr.w	(printfontset).l
	rts
; Prints the shooter rows.
ShooterScreenRows
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printsmallz).l
	String	CC_Font3,$6,$FC,$E,CC_Font2,$6
	move.w	#$0,d1
	movea.l	#homeshooters,a0
	cmpa.l	#tmstruct,a2
	beq.w	.loop
	movea.l	#awayshooters,a0
.loop	move.w	d1,d0
	asl.w	#$1,d0
	move.w	(a0,d0.w),d0
	jsr	(FormatPlayerNameShort).l
	move.w	(printx).l,-(sp)
	cmp.w	(TestList).l,d1
	bne.w	.next
	move.w	#$2,(printfontset).l
.next	cmpi.w	#$5,d1
	bne.w	.next2
	move.w	#$19,(printx).l
	move.w	#$E,(printy).l
.next2	jsr	(printsmall).l
	clr.w	(printfontset).l
	move.w	(sp)+,(printx).l
	addi.w	#$2,(printy).l
	addi.w	#$1,d1
	cmpi.w	#$6,d1
	blt.w	.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts