;	New in 94: the shootout. This file draws the shootout mode box, sets the shooting order,
;	counts the goals, shows the winner and runs the screen where the shooters are chosen.

ShootoutModeBox						;Shootout "SHOOTOUT MODE" box: the shooter " vs." the goalie and both
									;teams' shootout goals. Jumped to from PenaltyShotBox
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$FFFF,d0
	jsr	(prefmes).l					;prepare the message area
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),3,2
	moveq	#$1B,d0
	moveq	#$C,d1
	jsr	(Framer).l					;draw the box
	lea	ShootoutModeBigTxt(pc),a1
	jsr	(printbig).l				;SHOOTOUT MODE
	move.w	(BA_Skater_Offset).w,d0	;shooter roster index
	movea.l	#tmstruct,a2			;home team
	tst.w	(BA_Team).w
	beq.w	.0
	movea.l	#AwShots,a2
.0									;team struct chosen
	jsr	(FormatPlayerNumInitial).l	;number and initial
	move.w	(printx).w,-(sp)
	jsr	(print).l					;print the shooter
	move.w	(sp)+,(printx).w
	addq.w	#1,(printy).w
	addq.w	#6,(printx).w
	jsr	(printz).l
	String	' vs.',-(TXPRI+TXMAP1),4,7
	move.w	(BA_Goalie_SCnum).w,d0	;goalie SCnum
	asl.w	#7,d0					;struct size
	movea.l	#SortCords,a2
	adda.w	d0,a2					;goalie struct
	clr.w	d0
	move.b	pnum(a2),d0				;goalie roster index
	movea.l	#AwShots,a2
	tst.w	(BA_Team).w
	beq.w	.1
	movea.l	#tmstruct,a2
.1									;other team chosen
	jsr	(FormatPlayerNumInitial).l
	jsr	(print).l					;print the goalie
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),4,9
	movea.l	#tmstruct,a1			;home team
	movea.l	tmdata(a1),a1
	adda.w	Teamname(a1),a1			;team name
	jsr	(print).l					;print the team name
	move.w	#$15,(printx).w			;goals column
	move.w	(homeshootgoals).w,d0	;home goals
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l					;print the score
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),4,$A
	movea.l	#AwShots,a1				;visitors
	movea.l	tmdata(a1),a1
	adda.w	Teamname(a1),a1			;team name
	jsr	(print).l					;print the team name
	move.w	#$15,(printx).w
	move.w	(awayshootgoals).w,d0	;away goals
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l					;print the score
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),4,$C,'Round '
	move.w	(shootoutround).w,d0	;round number
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l					;print the round
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ShootoutModeBigTxt	dc.b	0		;ShootoutModeBox big text
	dc.b	$16,$BF,4,3
	dc.b	$53						;S
	dc.b	$48						;H
	dc.b	$4F						;O
	dc.b	$4F						;O
	dc.b	$54						;T
	dc.b	$4F						;O
	dc.b	$55						;U
	dc.b	$54						;T
	dc.b	$20
	dc.b	$4D						;M
	dc.b	$4F						;O
	dc.b	$44						;D
	dc.b	$45						;E
	dc.b	$BF,4,5,0

ClearShootout						;Clear the player structs (SortCords) and the shootout state.
	movea.l	#SortCords,a0
	move.w	#$3FF,d0				;$400 words
.loop								;clear each word
	clr.w	(a0)+
	dbf	d0,.loop					;clear the player structs
	clr.w	(shootoutdelay).w
	move.w	#1,(shootoutround).w	;round 1
	bclr	#3,(gmode2).w
	clr.w	(homeshootgoals).w
	clr.w	(awayshootgoals).w
	clr.w	(homeshootnum).w		;first shooter
	clr.w	(shootoutteam).w		;home shoots first
.0									;(not branched to)
	bsr.w	InitShooters			;home list
	move.w	#1,(shootoutteam).w		;visitors
	bsr.w	InitShooters			;visitors' list
	clr.w	(shootoutteam).w
	rts
NextShooter							;Shootout: the next shooter (BA_Team, BA_Goalie_SCnum, StartShootoutPath),
									;or the end (ExitToOpening).
	btst	#3,(gmode2).w
	beq.w	.0						;shootout running?
	jmp	ExitToOpening				;shootout over: back to the title
.0									;bit 3 of gmode2 clear
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	StartShootoutPath		;skate the path
	move.w	(shootoutteam).w,(BA_Team).w	;shooting team
	move.w	#$B,(BA_Goalie_SCnum).w	;home goalie slot $B
	movea.l	#homeshooters,a0		;home shooters
	tst.w	(shootoutteam).w		;visitors shoot?
	beq.w	.1
	move.w	#5,(BA_Goalie_SCnum).w	;away goalie slot 5
	movea.l	#awayshooters,a0		;away shooters
.1									;shooter list chosen
	move.w	(homeshootnum).w,d0		;shooter number
	add.w	d0,d0					;word per slot
	move.w	0(a0,d0.w),(BA_Skater_Offset).w	;this round's shooter
	bclr	#pfnc,(SortCords+(puckscnum*SCstruct)+pflags).w	;puck collides again
	movem.l	(sp)+,d0-d7/a0-a6
	rts
CountShootoutGoals					;Shootout: count the goals and end it when one team cannot catch up
									;(EndShootout, high ROM). Called from EndPenaltyShotPlay
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#0,(shootoutteam+1).w	;away just shot?
	beq.w	.switch					;home just shot: other team
	cmpi.w	#5,(shootoutround).w	;round 5 or later?
	blt.w	.switch					;before round 5: keep going
	move.w	(homeshootgoals).w,d0
	cmp.w	(awayshootgoals).w,d0	;goals differ?
	beq.w	.switch					;tied: keep going
	bset	#3,(gmode2).w			;shootout over
	jsr	(EndShootout).l				;end the shootout
	bra.w	.x
.switch								;switch the shooting team
	eori.w	#1,(shootoutteam).w		;other team shoots
	bne.w	.x						;home shoots next: done
	addq.w	#1,(homeshootnum).w		;next shooter
	cmpi.w	#5,(homeshootnum).w		;past the 5th?
	blt.w	.1
	clr.w	(homeshootnum).w		;back to the first shooter
.1									;round counted
	addq.w	#1,(shootoutround).w	;next round
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
InitShooters						;Shootout: the 6 starters of the home (shootoutteam 0) or away team as the
									;shooter list below homeshootnum / shootoutteam
	movea.l	#homeshootnum,a0
	move.w	(HomeTeam).w,d0			;home team
	tst.w	(shootoutteam).w
	beq.w	.0
	move.w	(VisTeam).w,d0			;visitors
	movea.l	#shootoutteam,a0
.0									;team chosen
	movea.l	#TeamList,a1			;team data table
	asl.w	#2,d0
	movea.l	0(a1,d0.w),a1			;team data
	adda.w	LineSets(a1),a1			;first line
	move.w	#5,d0					;6 starters
.loop								;each starter
	clr.w	d1
	move.b	(a1)+,d1				;player number
	subq.w	#1,d1					;roster index 0-based
	move.w	d1,-(a0)				;store the roster index
	dbf	d0,.loop
	rts
ShootoutWonBy						;Shootout: "SHOOTOUT WON BY" (printbig). Called from SetPA
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),1,$D
	move.w	#6,d1
	move.w	#$1E,d0
	jsr	(Framer).l					;draw the box
	jsr	(printbigz).l				;big text
	String	-(TXPRI+TXMAP1),2,$E,'SHOOTOUT WON BY'
	addq.w	#2,(printy).w
	move.w	(HomeTeam).w,d1			;home won
	move.w	(homeshootgoals).w,d0
	cmp.w	(awayshootgoals).w,d0
	bgt.w	.0						;home leads?
	move.w	(VisTeam).w,d1			;visitors won
.0									;winning team chosen
	asl.w	#2,d1
	movea.l	#TeamList,a1
	movea.l	0(a1,d1.w),a1			;team data
	adda.w	Teamname(a1),a1			;team name
	move.w	#2,(printx).w
	jsr	(printbig).l				;print the team name
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ShootoutShooters					;Shootout shooters menu item (menu lists): pick
									;the 3 shooters of each team
	btst	#0,(gmode2).w			;shootout?
	beq.w	ShootersExit			;no shootout: leave
	moveq	#0,d0
	moveq	#$1C,d1
	jsr	(SetupScreen).l				;set up the screen
	clr.w	(DispAttribCtr).w
	clr.w	(PlayerScrollCtr).w
	jsr	(printsmallz).l
	String	CC_SetMap,2,CC_SetX,0,CC_SetY
	moveq	#$28,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	jsr	(eraser).l					;clear the screen
	bsr.w	ResetShooterScroll		;scroll to the top
	bsr.w	PrintShooterSlots		;the slot numbers
	move.w	#0,(TestList).w			;cursor on slot 0
ShootersRedraw						;Shootout shooters: redraw (ShootersBackground,
									;PrintShooterBox, PrintShooterNames)
	bsr.w	ShootersBackground
	bsr.w	PrintShooterNames
	bsr.w	PrintShooterBox
ShootersLoop						;Shootout shooters: the input loop
	jsr	(vcountwait).l				;wait for the frame
	jsr	(getpzjoy).l				;read the pads
	jsr	(ProcessInputWithRepeat).l	;pad presses with repeat
	btst	#7,d1					;start?
	bne.w	ShootersExit			;start: leave
	move.w	#1,d0
	btst	#1,d1					;down?
	bne.w	ShootersMove			;down: move down
	move.w	#$FFFF,d0
	btst	#0,d1					;up?
	bne.w	ShootersMove			;up: move up
	move.w	#0,d0
	btst	#2,d1					;left?
	bne.w	ShootersPick			;left: the first slot
	move.w	#5,d0
	btst	#3,d1					;right?
	bne.w	ShootersPick			;right: the goalie slot
	btst	#5,d1
	bne.w	ShooterSelectList		;C: the player list
	bra.s	ShootersLoop
ShootersExit						;Leave (ExitStatsScreen)
	jmp	ExitStatsScreen
ShooterSelectList					;Shootout shooters: "{Select Player}" list
	move.w	#$C000,d7				;highlight palette
	movea.l	#homeshooters,a0		;home shooters
	cmpa.l	#tmstruct,a2
	beq.w	.0
	movea.l	#awayshooters,a0
.0									;shooter list chosen
	move.w	(TestList).w,d0			;cursor slot
	asl.w	#1,d0					;word per slot
	move.w	0(a0,d0.w),d6			;current shooter
	jsr	(GetGoalieCount).l
	move.w	d0,d1					;goalie count
	jsr	(GetPlayerCount).l			;roster size
	sub.w	d1,d0					;skater count
	subq.w	#1,d0					;last row
	cmpi.w	#5,(TestList).w			;goalie slot?
	bne.w	.1
	move.w	d1,d0					;goalie count
	subq.w	#1,d0					;last goalie
	clr.w	d1						;goalies come first
.1									;candidate range set
	move.w	d0,(screentimer).w		;last row
	clr.w	(PlayerScrollCtr).w		;scroll to the top
	clr.w	(VertLineScrolling).w	;cursor on row 0
	movea.w	#(Satt-M68K_RAM),a0		;candidate list
	clr.w	d2						;first row
.loop								;list each candidate
	move.b	d1,0(a0,d2.w)			;row = roster index
	cmp.w	d1,d6					;current shooter?
	bne.w	.2
	move.w	d2,(VertLineScrolling).w	;cursor starts on him
.2									;not the current shooter
	addq.w	#1,d1					;next roster index
	addq.w	#1,d2					;next row
	dbf	d0,.loop					;next candidate
	bsr.w	ClearShooterScreen		;clear the screen
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,0,3,1,0
	move.w	#$12,d0
	move.w	#3,d1
	jsr	(Framer).l					;frame of the title
	jsr	(printsmallz).l
	String	CC_SetX,$15,CC_SetY
	move.w	#$12,d0
	move.w	#3,d1
	jsr	(Framer).l					;frame of the list
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,2,2,1,'{Select Player}'	;title
	clr.w	d0
	bra.w	.scroll					;draw the list
.loop2								;loop
	jsr	(vcountwait).l
	jsr	(getpzjoy).l
	jsr	(ProcessInputWithRepeat).l
	btst	#7,d1
	bne.w	ShootersRedraw			;start: back to the shooters
	btst	#5,d1
	bne.w	.pick					;C: pick him
	moveq	#1,d0					;down / right: +1
	btst	#1,d1
	bne.w	.scroll					;down: move down
	btst	#3,d1
	bne.w	.page					;right: next page
	moveq	#-1,d0					;up / left: -1
	btst	#0,d1
	bne.w	.scroll					;up: move up
	btst	#2,d1
	bne.w	.page					;left: previous page
	bra.s	.loop2
.page								;bit 3 of d1 set or bit 2 of d1 set
	add.w	(DispAttribCtr).w,d0	;new page
	bmi.s	.loop2					;before the first page: ignore
	move.w	d0,(DispAttribCtr).w	;new page
.4									;(not branched to)
	bsr.w	PrintShooterList
.5									;(not branched to)
	bra.s	.loop2
.scroll								;up / down: move the cursor
	add.w	(VertLineScrolling).w,d0	;new cursor row
	bmi.s	.loop2					;above the first: ignore
	cmp.w	(screentimer).w,d0
	bgt.s	.loop2					;past the last: ignore
.7									;(not branched to)
	move.w	d0,(VertLineScrolling).w	;new cursor row
	cmp.w	(PlayerScrollCtr).w,d0	;above the rows shown?
	bgt.w	.8
	move.w	d0,(PlayerScrollCtr).w	;scroll up
.8									;cursor not above the first row shown
	subq.w	#5,d0					;6 rows shown
	cmp.w	(PlayerScrollCtr).w,d0	;below the rows shown?
	ble.w	.9
	move.w	d0,(PlayerScrollCtr).w	;scroll down
.9									;cursor inside the rows shown: redraw
	bsr.w	PrintShooterList
	bra.w	.loop2
.pick								;bit 5 of d1 set
	movea.w	#(Satt-M68K_RAM),a3		;candidate list
	adda.w	(VertLineScrolling).w,a3	;cursor row
	clr.w	d0
	move.b	(a3),d0					;roster index
	move.w	(TestList).w,d2			;cursor slot
	movea.l	#homeshooters,a0		;home shooters
	cmpa.l	#tmstruct,a2
	beq.w	.11
	movea.l	#awayshooters,a0
.11									;shooter list chosen
	asl.w	#1,d2					;word per slot
	move.w	d0,0(a0,d2.w)			;store the pick
	bra.w	ShootersRedraw			;redraw
PrintShooterList					;Shootout shooters: the player list rows (getNameandAttrib)
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$16,1
.loop								;loop
	movea.l	#PAttribOverall,a1		;skater columns
	cmpi.w	#5,(TestList).w			;goalie slot?
	bne.w	.0
	movea.l	#GAttribOverall,a1		;goalie columns
.0									;column list chosen
	move.w	(DispAttribCtr).w,d0	;page number
	bra.w	.1
.loop2								;skip one column entry
	adda.w	(a1),a1
	addq.w	#4,a1
.1									;is this the page?
	tst.w	(a1)
	dbmi	d0,.loop2
	bpl.w	.found					;page found?
	subq.w	#1,(DispAttribCtr).w	;past the end: back one page
	bra.s	.loop
.found								;page found
	cmpa.l	#PAttribOverall,a1		;skater columns?
	bne.w	.3
	movea.l	#ShooterOverallTxt,a1	;skater header
.3									;overall header text
	cmpa.l	#GAttribOverall,a1		;goalie columns?
	bne.w	.4
	movea.l	#ShooterOverallTxt2,a1	;goalie header
.4									;print the header
	jsr	(print).l					;print the header
	move.l	(a1),d4					;rating weights
	movea.w	#(Satt-M68K_RAM),a3		;candidate list
	move.w	(PlayerScrollCtr).w,d2	;first row shown
	move.w	(screentimer).w,d1		;list length
	sub.w	d2,d1					;rows left
	cmp.w	#5,d1					;more than 6?
	bls.w	.5
	moveq	#5,d1					;at most 6 rows
.5									;row count set
	move.w	#2,(printy).w			;first row
.loop3								;each row shown
	jsr	(printsmallz).l
	String	CC_SetAttribute,4,CC_SetX,5,CC_AddY,1,'                      ',CC_SetX,5
	cmp.w	(VertLineScrolling).w,d2	;cursor row?
	bne.w	.6
	move.w	d7,(printa).w			;highlight it
.6									;cursor row highlighted
	clr.w	d0
	move.b	0(a3,d2.w),d0			;roster index
	jsr	(GetNameandAttrib).l		;print name and rating
	addq.w	#1,d2					;next list entry
	dbf	d1,.loop3					;next row
	rts
ShooterOverallTxt	dc.b	0		;PrintShooterList data
	dc.b	$12,$20,$20,$20,$20
	dc.b	$4F						;O
	dc.b	$76						;v
	dc.b	$65						;e
	dc.b	$72						;r
	dc.b	$61						;a
	dc.b	$6C						;l
	dc.b	$6C						;l
	dc.b	$20,$20,$20,$20
	dc.b	$5D						;]
	dc.b	$1F
	dc.b	$3A						;:
	dc.b	0,$A
ShooterOverallTxt2	dc.b	0		;PrintShooterList data
	dc.b	$12,$20,$20,$20,$20
	dc.b	$4F						;O
	dc.b	$76						;v
	dc.b	$65						;e
	dc.b	$72						;r
	dc.b	$61						;a
	dc.b	$6C						;l
	dc.b	$6C						;l
	dc.b	$20,$20,$20,$20
	dc.b	$5D						;]
	dc.b	$1B,$F,0,$A
ShootersPick						;Shootout shooters: C on a slot; the same slot (TestList) goes back to the
									;loop, else select it (ShootersSelect)
	cmp.w	(TestList).w,d0			;already there?
	beq.w	ShootersLoop			;same slot: nothing to do
	bra.w	ShootersSelect			;select it
ShootersMove						;Shootout shooters: move the slot cursor by d0, wrapping in 0 ... 4 (not
									;on slot 5)
	cmpi.w	#5,(TestList).w			;on the goalie slot?
	beq.w	ShootersLoop			;goalie slot: no moving
	add.w	(TestList).w,d0			;new slot
	bmi.w	.0						;above the first?
	cmp.w	#5,d0					;past the 5th?
	blt.w	ShootersSelect
	clr.w	d0						;wrap to the first
	bra.w	ShootersSelect			;set it
.0									;d0 negative
	move.w	#4,d0					;wrap to the last shooter
ShootersSelect						;Shootout shooters: TestList = d0, redraw the names and the player box,
									;back to the loop
	move.w	d0,(TestList).w			;new cursor slot
	bsr.w	PrintShooterNames		;redraw the names
	bsr.w	PrintShooterBox			;redraw the box
	bra.w	ShootersLoop			;back to the input loop
ShootersBackground					;Shootout shooters background and "Shootout" title
	bsr.w	ClearShooterScreen		;clear the screen
	movem.l	d0-d5/a0-a2,-(sp)
	jsr	(printz).l
	String	-TXMAP3,0,0
	movea.l	#ScoutMap,a1			;background map
	adda.l	jimdata(a1),a1
	movea.w	#null,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2					;map width
	move.w	mapheight(a1),d3		;map height
	moveq	#1,d4
	moveq	#0,d5
	jsr	(dobitmap).l				;draw the background map
	movem.l	(sp)+,d0-d5/a0-a2
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),7,1
	moveq	#$1A,d0
	moveq	#6,d1
	jsr	(Framer).l					;draw the box
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP2),$A,4,'  Shootout  ',-(TXPRI+TXMAP2),$F,1	;Shootout title
	clr.w	d0
	cmpa.w	#(tmstruct-M68K_RAM),a2	;home team?
	beq.w	.0
	move.w	#$2C,d0
.0									;home team at 0, away at $2C
	jmp	PutTeamBlock				;the team's logo block
ClearShooterScreen					;Shootout shooters: erase the screen
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),0,0
	moveq	#$28,d0
	moveq	#$A,d1
	move.w	#$7FF,d2
	jmp	eraser						;erase it
ResetShooterScroll					;Shootout shooters: clear the list scroll words
									;palfadenew+$5A and palfadenew+$7A
	clr.w	(palfadenew+$5A).w		;home scroll
	clr.w	(palfadenew+$7A).w		;other team's scroll
	rts
PrintShooterSlots					;Shootout shooters: "Shooters" 1. 2. 3.
	jsr	(printsmallz).l
	String	CC_SetMap,2,CC_SetX,0,CC_SetY,$A
	jsr	(printsmallz).l
	String	CC_SetAttribute,4
	jsr	(printsmallz).l
	String	CC_SetX,7,CC_SetY,$C,'Shooters'	;shooters header
.0									;(not branched to)
	jsr	(printsmallz).l
	String	CC_SetX,3,CC_SetY,$E,'1. '
	jsr	(printsmallz).l
	String	CC_SetX,3,CC_SetY,$10,'2. '
	jsr	(printsmallz).l
	String	CC_SetX,3,CC_SetY,$12,'3. '
	jsr	(printsmallz).l
	String	CC_SetX,3,CC_SetY,$14,'4. '
	jsr	(printsmallz).l
	String	CC_SetX,3,CC_SetY,$16,'5. '
	jsr	(printsmallz).l
	String	CC_SetX,$1A,CC_SetY,$C,'Goalie'	;goalie header
	rts
PrintShooterBox						;Shootout shooters: the selected player box
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,2,8,7,CC_SetFont,1
	moveq	#$18,d0
	moveq	#3,d1
	jsr	(Framer).l					;draw the box
	jsr	(printsmallz).l
	String	CC_SetX,$15,CC_SetY,8,CC_SetAttribute,6	;name position
	movea.l	#homeshooters,a1		;home shooters
	cmpa.l	#tmstruct,a2
	beq.w	.0
	movea.l	#awayshooters,a1
.0									;shooter list chosen
	move.w	(TestList).w,d0			;cursor slot
	asl.w	#1,d0					;word per slot
	move.w	0(a1,d0.w),d0			;roster index
	jsr	(getname).l					;name
	move.w	(a1),d0					;name length
	lsr.w	#1,d0					;half its length
	sub.w	d0,(printx).w			;center it
	jsr	(printsmall).l				;print it
	clr.w	(printfontset).w
	rts
PrintShooterNames					;Shootout shooters: the shooters' names (FormatPlayerNameShort)
	movem.l	d0-d7/a0-a6,-(sp)
.0									;(not branched to)
	jsr	(printsmallz).l
	String	CC_SetX,6,CC_SetY,$E,CC_SetAttribute,6	;name column
	move.w	#0,d1					;first slot
	movea.l	#homeshooters,a0		;home shooters
	cmpa.l	#tmstruct,a2
	beq.w	.loop
	movea.l	#awayshooters,a0
.loop								;each shooter
	move.w	d1,d0					;slot
	asl.w	#1,d0					;word per slot
	move.w	0(a0,d0.w),d0			;roster index
	jsr	(FormatPlayerNameShort).l	;short name
	move.w	(printx).w,-(sp)
	cmp.w	(TestList).w,d1			;cursor slot?
	bne.w	.1
	move.w	#2,(printfontset).w		;highlight font
.1									;cursor shooter highlighted
	cmp.w	#5,d1
	bne.w	.2
	move.w	#$19,(printx).w			;goalie column
	move.w	#$E,(printy).w			;goalie row
.2									;goalie row placed
	jsr	(printsmall).l				;print the name
	clr.w	(printfontset).w		;normal font
	move.w	(sp)+,(printx).w		;back to the name column
	addq.w	#2,(printy).w			;next row
	addq.w	#1,d1					;next slot
	cmp.w	#6,d1					;6 rows (5 shooters and the goalie)
	blt.s	.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts
