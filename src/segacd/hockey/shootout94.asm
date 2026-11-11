;	HOCKEY.BIN $C860-$D1D3 (runtime $27860-$281D3): shootout94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	The shootout logic is the cartridge code. CD: the shooter list is kept in word RAM at $BBD30,
;	and the logo comes through the graphics pointer table ($47D0C).

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

null	equ	$1B008
TeamList	equ	$1B00C
EndShootout	equ	$291CE
StartShootoutPath	equ	$2A686
PutTeamBlock	equ	$2C59E
MenuWaitVblank	equ	$2C63A
GetNameandAttrib	equ	$2D56A
SetupScreen	equ	$2E728
ExitStatsScreen	equ	$2E980
GetGoalieCount	equ	$2ED60
GetPlayerCount	equ	$2EDBC
getpzjoy	equ	$2F2F0
ProcessInputWithRepeat	equ	$374BE
dobitmap	equ	$387E2
eraser	equ	$38C06
Framer	equ	$38CA0
printsmallz	equ	$38D8C
printsmall	equ	$38D9E
printz	equ	$38F6E
print	equ	$38F80
PushNumberWidth	equ	$3919A
printbigz	equ	$39258
printbig	equ	$3926A
prefmes	equ	$39D96
ExitToOpening	equ	$3F2BE
getname	equ	$4112E
FormatPlayerNumInitial	equ	$41192
FormatPlayerNameShort	equ	$41226
PAttribOverall	equ	$41C5E
GAttribOverall	equ	$41DC0
X_27A0A	equ	$27A0A

	org	$27860

;	New in 94: the shootout. This file draws the shootout mode box, sets the shooting order,
;	counts the goals, shows the winner and runs the screen where the shooters are chosen.

ShootoutModeBox						;Shootout "SHOOTOUT MODE" box: the shooter " vs." the goalie and both
									;teams' shootout goals. Jumped to from PenaltyShotBox
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$FFFF,d0
	jsr	(prefmes).l					;prepare the message area
	jsr	(printz).l
	String	CC_Font1Pri,3,2
	moveq	#$1B,d0
	moveq	#$C,d1
	jsr	(Framer).l					;draw the box
	lea	ShootoutModeBigTxt(pc),a1
	jsr	(printbig).l				;SHOOTOUT MODE
	move.w	(BA_Skater_Offset).l,d0	;shooter roster index
	movea.l	#tmstruct,a2
	tst.w	(BA_Team).l
	beq.w	.0
	movea.l	#awtmstruct,a2
.0									;team struct chosen
	jsr	(FormatPlayerNumInitial).l
	move.w	(printx).l,-(sp)
	jsr	(print).l
	move.w	(sp)+,(printx).l
	addi.w	#1,(printy).l
	addi.w	#6,(printx).l
	jsr	(printz).l
	String	' vs.',CC_Font1Pri,4,7
	move.w	(BA_Goalie_SCnum).l,d0	;goalie SCnum
	asl.w	#7,d0
	movea.l	#SortCords,a2
	adda.w	d0,a2
	clr.w	d0
	move.b	pnum(a2),d0				;goalie roster index
	movea.l	#awtmstruct,a2
	tst.w	(BA_Team).l
	beq.w	.1
	movea.l	#tmstruct,a2
.1									;other team chosen
	jsr	(FormatPlayerNumInitial).l
	jsr	(print).l
	jsr	(printz).l
	String	CC_Font1Pri,4,9
	movea.l	#tmstruct,a1
	movea.l	tmdata(a1),a1
	adda.w	Teamname(a1),a1
	jsr	(print).l					;print the team name
	move.w	#$15,(printx).l			;goals column
	move.w	(homeshootgoals).l,d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	CC_Font1Pri,4,$A
	movea.l	#awtmstruct,a1
	movea.l	tmdata(a1),a1
	adda.w	Teamname(a1),a1
	jsr	(print).l					;print the team name
	move.w	#$15,(printx).l
	move.w	(awayshootgoals).l,d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
;CD: no cartridge twin
	dc.w	$000A
	eor.b	d7,d4
	cmpi.w	#$6F75,(a2)
	bgt.s	X_27A0A
	move.l	d0,d0
	move.w	(shootoutround).l,d0
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
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
	move.w	#$3FF,d0
.loop								;clear each word
	clr.w	(a0)+
	dbf	d0,.loop					;clear the player structs
	clr.w	(shootoutdelay).l
	move.w	#1,(shootoutround).l
	bclr.b	#3,(gmode2).l
	clr.w	(homeshootgoals).l
	clr.w	(awayshootgoals).l
	clr.w	(homeshootnum).l
	clr.w	(shootoutteam).l
.0									;(not branched to)
	bsr.w	InitShooters
	move.w	#1,(shootoutteam).l
	bsr.w	InitShooters
	clr.w	(shootoutteam).l
	rts
NextShooter							;Shootout: the next shooter (BA_Team, BA_Goalie_SCnum, StartShootoutPath),
									;or the end (ExitToOpening).
	btst.b	#3,(gmode2).l
	beq.w	.0						;shootout running?
	jmp	(ExitToOpening).l			;shootout over: back to the title
.0									;bit 3 of gmode2 clear
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	StartShootoutPath
	move.w	(shootoutteam).l,(BA_Team).l
	move.w	#$B,(BA_Goalie_SCnum).l	;home goalie slot $B
	movea.l	#homeshooters,a0
	tst.w	(shootoutteam).l		;visitors shoot?
	beq.w	.1
	move.w	#5,(BA_Goalie_SCnum).l	;away goalie slot 5
	movea.l	#awayshooters,a0
.1									;shooter list chosen
	move.w	(homeshootnum).l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),(BA_Skater_Offset).l	;this round's shooter
	bclr.b	#pfnc,(SortCords+(puckscnum*SCstruct)+pflags).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
CountShootoutGoals					;Shootout: count the goals and end it when one team cannot catch up
									;(EndShootout, high ROM). Called from EndPenaltyShotPlay
	movem.l	d0-d7/a0-a6,-(sp)
	btst.b	#0,(shootoutteam+1).l	;away just shot?
	beq.w	.switch					;home just shot: other team
	cmpi.w	#5,(shootoutround).l	;round 5 or later?
	blt.w	.switch					;before round 5: keep going
	move.w	(homeshootgoals).l,d0
	cmp.w	(awayshootgoals).l,d0	;goals differ?
	beq.w	.switch					;tied: keep going
	bset.b	#3,(gmode2).l			;shootout over
	jsr	(EndShootout).l
	bra.w	.x
.switch								;switch the shooting team
	eori.w	#1,(shootoutteam).l
	bne.w	.x						;home shoots next: done
	addi.w	#1,(homeshootnum).l
	cmpi.w	#5,(homeshootnum).l		;past the 5th?
	blt.w	.1
	clr.w	(homeshootnum).l		;back to the first shooter
.1									;round counted
	addi.w	#1,(shootoutround).l
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
InitShooters						;Shootout: the 6 starters of the home (shootoutteam 0) or away team as the
									;shooter list below homeshootnum / shootoutteam
	movea.l	#homeshootnum,a0
	move.w	(HomeTeam).l,d0
	tst.w	(shootoutteam).l
	beq.w	.0
	move.w	(VisTeam).l,d0
	movea.l	#shootoutteam,a0
.0									;team chosen
	movea.l	#TeamList,a1
	asl.w	#2,d0
	movea.l	(a1,d0.w),a1
	adda.w	LineSets(a1),a1
	move.w	#5,d0					;6 starters
.loop								;each starter
	clr.w	d1
	move.b	(a1)+,d1
	subi.w	#1,d1					;roster index 0-based
	move.w	d1,-(a0)				;store the roster index
	dbf	d0,.loop
	rts
ShootoutWonBy						;Shootout: "SHOOTOUT WON BY" (printbig). Called from SetPA
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	CC_Font1Pri,1,$D
	move.w	#6,d1
	move.w	#$1E,d0
	jsr	(Framer).l					;draw the box
	jsr	(printbigz).l
	String	CC_Font1Pri,2,$E,'SHOOTOUT WON BY'
	addi.w	#2,(printy).l
	move.w	(HomeTeam).l,d1
	move.w	(homeshootgoals).l,d0
	cmp.w	(awayshootgoals).l,d0
	bgt.w	.0						;home leads?
	move.w	(VisTeam).l,d1
.0									;winning team chosen
	asl.w	#2,d1
	movea.l	#TeamList,a1
	movea.l	(a1,d1.w),a1
	adda.w	Teamname(a1),a1
	move.w	#2,(printx).l
	jsr	(printbig).l				;print the team name
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ShootoutShooters					;Shootout shooters menu item (menu lists): pick
									;the 3 shooters of each team
	btst.b	#0,(gmode2).l			;shootout?
	beq.w	ShootersExit
	moveq	#0,d0
	moveq	#$1C,d1
	jsr	(SetupScreen).l				;set up the screen
	clr.w	(DispAttribCtr).l
	clr.w	(PlayerScrollCtr).l
	jsr	(printsmallz).l
	String	CC_SetMap,2,CC_SetX,0,CC_SetY
	moveq	#$28,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	bsr.w	ResetShooterScroll		;scroll to the top
	bsr.w	PrintShooterSlots
	move.w	#0,(TestList).l			;cursor on slot 0
ShootersRedraw						;Shootout shooters: redraw (ShootersBackground,
									;PrintShooterBox, PrintShooterNames)
	bsr.w	ShootersBackground
	bsr.w	PrintShooterNames
	bsr.w	PrintShooterBox
ShootersLoop						;Shootout shooters: the input loop
	jsr	(MenuWaitVblank).l			;wait for the frame
	jsr	(getpzjoy).l				;read the pads
	jsr	(ProcessInputWithRepeat).l	;pad presses with repeat
	btst	#7,d1					;start?
	bne.w	ShootersExit
	move.w	#1,d0
	btst	#1,d1					;down?
	bne.w	ShootersMove
	move.w	#$FFFF,d0
	btst	#0,d1					;up?
	bne.w	ShootersMove
	move.w	#0,d0
	btst	#2,d1					;left?
	bne.w	ShootersPick			;left: the first slot
	move.w	#5,d0
	btst	#3,d1					;right?
	bne.w	ShootersPick			;right: the goalie slot
	btst	#5,d1
	bne.w	ShooterSelectList		;C: the player list
	bra.w	ShootersLoop
ShootersExit						;Leave (ExitStatsScreen)
	jmp	(ExitStatsScreen).l
ShooterSelectList					;Shootout shooters: "{Select Player}" list
	move.w	#$C000,d7				;highlight palette
	movea.l	#homeshooters,a0
	cmpa.l	#tmstruct,a2
	beq.w	.0
	movea.l	#awayshooters,a0
.0									;shooter list chosen
	move.w	(TestList).l,d0
	asl.w	#1,d0					;word per slot
	move.w	(a0,d0.w),d6			;current shooter
	jsr	(GetGoalieCount).l
	move.w	d0,d1
	jsr	(GetPlayerCount).l
	sub.w	d1,d0
	subi.w	#1,d0
	cmpi.w	#5,(TestList).l			;goalie slot?
	bne.w	.1
	move.w	d1,d0
	subi.w	#1,d0					;last goalie
	clr.w	d1						;goalies come first
.1									;candidate range set
	move.w	d0,(screentimer).l
	clr.w	(PlayerScrollCtr).l		;scroll to the top
	clr.w	(VertLineScrolling).l	;cursor on row 0
	movea.l	#(Satt-M68K_RAM),a0
	clr.w	d2
.loop								;list each candidate
	move.b	d1,(a0,d2.w)			;row = roster index
	cmp.w	d1,d6					;current shooter?
	bne.w	.2
	move.w	d2,(VertLineScrolling).l	;cursor starts on him
.2									;not the current shooter
	addi.w	#1,d1					;next roster index
	addi.w	#1,d2
	dbf	d0,.loop					;next candidate
	bsr.w	ClearShooterScreen
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
	bra.w	.scroll
.loop2								;loop
	jsr	(MenuWaitVblank).l
	jsr	(getpzjoy).l
	jsr	(ProcessInputWithRepeat).l
	btst	#7,d1
	bne.w	ShootersRedraw			;start: back to the shooters
	btst	#5,d1
	bne.w	.pick
	moveq	#1,d0					;down / right: +1
	btst	#1,d1
	bne.w	.scroll
	btst	#3,d1
	bne.w	.page
	moveq	#-1,d0					;up / left: -1
	btst	#0,d1
	bne.w	.scroll
	btst	#2,d1
	bne.w	.page
	bra.w	.loop2
.page								;bit 3 of d1 set or bit 2 of d1 set
	add.w	(DispAttribCtr).l,d0
	bmi.w	.loop2					;before the first page: ignore
	move.w	d0,(DispAttribCtr).l
.4									;(not branched to)
	bsr.w	PrintShooterList
.5									;(not branched to)
	bra.w	.loop2
.scroll								;up / down: move the cursor
	add.w	(VertLineScrolling).l,d0
	bmi.w	.loop2					;above the first: ignore
	cmp.w	(screentimer).l,d0
	bgt.w	.loop2					;past the last: ignore
.7									;(not branched to)
	move.w	d0,(VertLineScrolling).l
	cmp.w	(PlayerScrollCtr).l,d0	;above the rows shown?
	bgt.w	.8
	move.w	d0,(PlayerScrollCtr).l
.8									;cursor not above the first row shown
	subi.w	#5,d0					;6 rows shown
	cmp.w	(PlayerScrollCtr).l,d0	;below the rows shown?
	ble.w	.9
	move.w	d0,(PlayerScrollCtr).l
.9									;cursor inside the rows shown: redraw
	bsr.w	PrintShooterList
	bra.w	.loop2
.pick								;bit 5 of d1 set
	movea.l	#(Satt-M68K_RAM),a3
	adda.w	(VertLineScrolling).l,a3
	clr.w	d0
	move.b	(a3),d0
	move.w	(TestList).l,d2
	movea.l	#homeshooters,a0
	cmpa.l	#tmstruct,a2
	beq.w	.11
	movea.l	#awayshooters,a0
.11									;shooter list chosen
	asl.w	#1,d2					;word per slot
	move.w	d0,(a0,d2.w)			;store the pick
	bra.w	ShootersRedraw
PrintShooterList					;Shootout shooters: the player list rows (getNameandAttrib)
	jsr	(printz).l
	String	CC_Font2Pri,$16,1
.loop								;loop
	movea.l	#PAttribOverall,a1		;skater columns
	cmpi.w	#5,(TestList).l			;goalie slot?
	bne.w	.0
	movea.l	#GAttribOverall,a1		;goalie columns
.0									;column list chosen
	move.w	(DispAttribCtr).l,d0
	bra.w	.1
.loop2								;skip one column entry
	adda.w	(a1),a1
;CD: no cartridge twin
	adda.w	#$4,a1
.1									;is this the page?
	tst.w	(a1)
	dbmi	d0,.loop2
	bpl.w	.found					;page found?
	subi.w	#1,(DispAttribCtr).l	;past the end: back one page
	bra.w	.loop
.found								;page found
	cmpa.l	#PAttribOverall,a1		;skater columns?
	bne.w	.3
	movea.l	#ShooterOverallTxt,a1	;skater header
.3									;overall header text
	cmpa.l	#GAttribOverall,a1		;goalie columns?
	bne.w	.4
	movea.l	#ShooterOverallTxt2,a1	;goalie header
.4									;print the header
	jsr	(print).l
	move.l	(a1),d4					;rating weights
	movea.l	#(Satt-M68K_RAM),a3
	move.w	(PlayerScrollCtr).l,d2
	move.w	(screentimer).l,d1
	sub.w	d2,d1
	cmpi.w	#5,d1					;more than 6?
	bls.w	.5
	moveq	#5,d1					;at most 6 rows
.5									;row count set
	move.w	#2,(printy).l
.loop3								;each row shown
	jsr	(printsmallz).l
	String	CC_SetAttribute,4,CC_SetX,5,CC_AddY,1,'                      ',CC_SetX,5
	cmp.w	(VertLineScrolling).l,d2	;cursor row?
	bne.w	.6
	move.w	d7,(printa).l
.6									;cursor row highlighted
	clr.w	d0
	move.b	(a3,d2.w),d0			;roster index
	jsr	(GetNameandAttrib).l		;print name and rating
	addi.w	#1,d2
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
	cmp.w	(TestList).l,d0			;already there?
	beq.w	ShootersLoop			;same slot: nothing to do
	bra.w	ShootersSelect
ShootersMove						;Shootout shooters: move the slot cursor by d0, wrapping in 0 ... 4 (not
									;on slot 5)
	cmpi.w	#5,(TestList).l			;on the goalie slot?
	beq.w	ShootersLoop			;goalie slot: no moving
	add.w	(TestList).l,d0
	bmi.w	.0						;above the first?
	cmpi.w	#5,d0					;past the 5th?
	blt.w	ShootersSelect
	clr.w	d0						;wrap to the first
	bra.w	ShootersSelect
.0									;d0 negative
	move.w	#4,d0					;wrap to the last shooter
ShootersSelect						;Shootout shooters: TestList = d0, redraw the names and the player box,
									;back to the loop
	move.w	d0,(TestList).l
	bsr.w	PrintShooterNames
	bsr.w	PrintShooterBox			;redraw the box
	bra.w	ShootersLoop			;back to the input loop
ShootersBackground					;Shootout shooters background and "Shootout" title
	bsr.w	ClearShooterScreen
	movem.l	d0-d5/a0-a2,-(sp)
	jsr	(printz).l
	String	CC_Font3,0,0
;CD: no cartridge twin
	movea.l	(EASportsBGMapPtr).l,a1
	adda.l	jimdata(a1),a1
	movea.l	#null,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	moveq	#1,d4
	moveq	#0,d5
	jsr	(dobitmap).l				;draw the background map
	movem.l	(sp)+,d0-d5/a0-a2
	jsr	(printz).l
	String	CC_Font2Pri,7,1
	moveq	#$1A,d0
	moveq	#6,d1
	jsr	(Framer).l					;draw the box
	jsr	(printbigz).l
	String	CC_Font2Pri,$A,4,'  Shootout  ',CC_Font2Pri,$F,1	;Shootout title
	clr.w	d0
	cmpa.l	#$1834C,a2				;home team? (CD: the cartridge has #(tmstruct-M68K_RAM))
	beq.w	.0
	move.w	#$2C,d0
.0									;home team at 0, away at $2C
	jmp	(PutTeamBlock).l			;the team's logo block
ClearShooterScreen					;Shootout shooters: erase the screen
	jsr	(printz).l
	String	CC_Font2Pri,0,0
	moveq	#$28,d0
	moveq	#$A,d1
	move.w	#$7FF,d2
	jmp	(eraser).l
ResetShooterScroll					;Shootout shooters: clear the list scroll words
									;palfadenew+$5A and palfadenew+$7A
	clr.w	(palfadenew+$5A).l
	clr.w	(palfadenew+$7A).l
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
	movea.l	#homeshooters,a1
	cmpa.l	#tmstruct,a2
	beq.w	.0
	movea.l	#awayshooters,a1
.0									;shooter list chosen
	move.w	(TestList).l,d0
	asl.w	#1,d0					;word per slot
	move.w	(a1,d0.w),d0			;roster index
	jsr	(getname).l
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).l
	jsr	(printsmall).l				;print it
	clr.w	(printfontset).l
	rts
PrintShooterNames					;Shootout shooters: the shooters' names (FormatPlayerNameShort)
	movem.l	d0-d7/a0-a6,-(sp)
.0									;(not branched to)
	jsr	(printsmallz).l
	String	CC_SetX,6,CC_SetY,$E,CC_SetAttribute,6	;name column
	move.w	#0,d1
	movea.l	#homeshooters,a0
	cmpa.l	#tmstruct,a2
	beq.w	.loop
	movea.l	#awayshooters,a0
.loop								;each shooter
	move.w	d1,d0
	asl.w	#1,d0					;word per slot
	move.w	(a0,d0.w),d0			;roster index
	jsr	(FormatPlayerNameShort).l
	move.w	(printx).l,-(sp)
	cmp.w	(TestList).l,d1			;cursor slot?
	bne.w	.1
	move.w	#2,(printfontset).l		;highlight font
.1									;cursor shooter highlighted
	cmpi.w	#5,d1
	bne.w	.2
	move.w	#$19,(printx).l			;goalie column
	move.w	#$E,(printy).l			;goalie row
.2									;goalie row placed
	jsr	(printsmall).l				;print the name
	clr.w	(printfontset).l
	move.w	(sp)+,(printx).l		;back to the name column
	addi.w	#2,(printy).l
	addi.w	#1,d1
	cmpi.w	#6,d1					;6 rows (5 shooters and the goalie)
	blt.w	.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts
