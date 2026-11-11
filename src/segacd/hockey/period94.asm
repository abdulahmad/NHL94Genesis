;	HOCKEY.BIN $E1CE-$F1A9 (runtime $291CE-$2A1A9): period94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Period stats, game statistics and Manual Goalie are the cartridge code. CD: the team logos come
;	through the graphics pointer table ($47D8C) and BIOS calls ($6044 with d7 = 2), and a stat line
;	is sent to the main CPU with command $B; the first lines of PrintStatValue have no twin.

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

TeamList	equ	$1B00C
TeamLogoPalettes	equ	$2AF56
HotColdIcon	equ	$2B3FE
PutTeamBlock	equ	$2C59E
MenuWaitVblank	equ	$2C63A
SetupScreen	equ	$2E728
ExitStatsScreen	equ	$2E980
Pausemode_rjoy	equ	$2EDE2
getpzjoy	equ	$2F2F0
freezewindow	equ	$30094
setc1player	equ	$312B8
setc2player	equ	$312DC
assinsert	equ	$362D8
nodiag	equ	$37496
dobitmap	equ	$387E2
Framer	equ	$38CA0
printsmallz	equ	$38D8C
printz	equ	$38F6E
print	equ	$38F80
PushTime	equ	$390F4
PushNumber	equ	$3915E
PushNumberWidth	equ	$3919A
appendz	equ	$39200
appstring	equ	$39208
printbigz	equ	$39258
setplayer	equ	$3D770
FormatPlayerNumInitial	equ	$41192
FormatPlayerName	equ	$411D6

	org	$291CE

;	Period stats, game statistics, the shootout-end celebration, and the
;	Manual Goalie pause item. New in 94. ROM-contiguous through ManualGoalieMenu.

EndShootout							;Shootout over (CountShootoutGoals): freezewindow, then the 5 skaters of
									;player slots 1-5 (homeshootgoals > awayshootgoals) or 7-$B are set up
									;(setplayer) above or below the view and get assscore (assinsert 7)
	movem.l	d0-d7/a0-a6,-(sp)
	bset.b	#sf2drec,(sflags2).l	;replay recording
	jsr	(freezewindow).l
	move.w	#$60,(shootoutdelay).l	;delay before the end
	movea.l	#SortCords,a3
	move.w	#0,d0
	move.w	(homeshootgoals).l,d2
	cmp.w	(awayshootgoals).l,d2
	bgt.w	.0						;home won?
	move.w	#6,d0					;visitors won: slot 6
.0									;the winning side's players
	asl.w	#7,d0
	adda.w	d0,a3
	move.w	#4,d2					;5 skaters
	move.w	#6,d3
	bra.w	.2
.loop								;each skater of that team
	movem.w	d2-d3,-(sp)
	jsr	(setplayer).l				;set up the player
	move.w	#2,position(a3)
	move.w	#$F0,d0					;below the view
	tst.w	(Vpos).l
	bmi.w	.1						;view going down?
	move.w	#$FF10,d0				;above the view
.1									;lined up at this end of the view
	add.w	(Vpos).l,d0				;relative to the view
	move.w	d0,Ypos(a3)
	move.w	#0,0(a3)				;X center
	move.w	#7,d0					;score assignment
	jsr	(assinsert).l
	bclr.b	#pfalock,pflags(a3)
	bclr.b	#pf2aip,pflags2(a3)
	bclr.b	#pfnc,pflags(a3)		;no collisions off
	movem.w	(sp)+,d2-d3
.2									;next player
	adda.l	#$80,a3
	dbf	d2,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ClampPositionBox					;Unreferenced. Clamp temp3 / temp4(a3) to the box for position(a3) in
									;PositionBoxes (PositionBoxesTop when bit 7 of
									;pflags(a3), the top net)
	movem.l	d0-d7/a0,-(sp)
	move.w	position(a3),d7
	subi.w	#1,d7					;position 1 is entry 0
	movea.l	#PositionBoxes,a0
	btst.b	#pfgoal,pflags(a3)		;which net?
	beq.w	.0
	movea.l	#PositionBoxesTop,a0
.0									;position boxes for his end
	add.w	d7,d7					;word per position
	move.w	(a0,d7.w),d0			;X min of the box
	cmp.w	temp3(a3),d0
	blt.w	.1
	move.w	d0,temp3(a3)			;clamp to the left
.1									;X not left of the box
	move.w	$2(a0,d7.w),d0			;X max of the box
	cmp.w	temp3(a3),d0
	bgt.w	.2
	move.w	d0,temp3(a3)			;clamp to the right
.2									;X inside the box
	move.w	$4(a0,d7.w),d0			;Y min of the box
	cmp.w	temp4(a3),d0
	blt.w	.3
	move.w	d0,temp4(a3)			;clamp to the bottom
.3									;Y not below the box
	move.w	$6(a0,d7.w),d0			;Y max of the box
	cmp.w	temp4(a3),d0
	bgt.w	.x
	move.w	d0,temp4(a3)			;clamp to the top
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0
	rts
PositionBoxes						;ClampPositionBox boxes: min / max of $44, then of $46, per position
	dc.w	$FFB5,0,0,$108,0,$4B,0,$108
PositionBoxesTop					;ClampPositionBox boxes, top net
	dc.w	$FFB5,0,$FEF8,0,0,$4B,$FEF8,0
ClearGameStats						;Clear the game stats: shootoutstate (19 words), both team structs
									;(tmstruct, awtmstruct), PenBuf, BA_PS_flags, sflags4 / F8 / FA and
									;setupcardflags / featuredplayer. Called from GameSetUp
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#shootoutstate,a0
	move.l	#$12,d0
.loop								;clear the shootout state
	clr.w	(a0)+
	dbf	d0,.loop
	movea.l	#tmstruct,a0
	move.w	#tmsize-1,d0
.loop2								;clear both team structs (tmsize words)
	clr.w	(a0)+
	dbf	d0,.loop2
	movea.l	#PenBuf,a0
	move.l	#$24,d0
.loop3								;clear PenBuf
	clr.w	(a0)+
	dbf	d0,.loop3
	clr.w	(BA_PS_flags).l			;no penalty shot
	clr.w	(sflags4).l
	clr.w	(sflags6).l
	clr.w	(gmode2).l				;game mode 2 cleared
	clr.w	(setupcardflags).l		;no setup card flags
	clr.w	(featuredplayer).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
AddArenaAnimSprite					;Add the frame arenaframe of the arena animation (sprite list
									;arenaspritelist, see RunArenaAnim) to the sprite table a6 (d6 sprites, 64
									;at most) for the pieces inside the view (Hpos / Vpos). Not in a reverse
									;angle replay (sflags4 bit 4), sflags2 bit 3 or sflags bit 7. Called from
									;setvideo
	tst.w	(arenaanim).l
	bmi.w	.x2
	tst.l	(arenaspritelist).l
	beq.w	.x2						;not loaded: none
	btst.b	#4,(sflags4).l			;check if reverse angle replay
	bne.w	.x2
	btst.b	#sf2replay,(sflags2).l
	bne.w	.x2						;replay: none
	btst.b	#sfhor,(sflags).l
	bne.w	.x2						;horizontal mode: none
	movea.l	(arenaspritelist).l,a1
	adda.l	jimdata(a1),a1
	move.w	(Hpos).l,d4
	move.w	(Vpos).l,d5
	move.w	(arenaframe).l,d0		;current frame
	bra.w	.spr					;draw the current frame
	andi.w	#$F,d2					;nothing branches here: draw d2 + 1 (4 at most) frames from d3 (.2)
	cmpi.w	#3,d2
	bls.w	.0
	moveq	#3,d2
.0									;count clamped to 3
	bra.w	.1
.loop								;each frame
	move.w	d3,d0					;first frame
	add.w	d2,d0					;frame number
	bsr.w	.spr
.1									;loop the count
	dbf	d2,.loop
	rts
.spr								;draw one frame
	ext.w	d0						;frame number
	beq.w	.x2						;frame 0: nothing
	cmpi.w	#$40,d6					;64 sprites?
	bge.w	.x2
	movem.l	d0-d5,-(sp)
	add.w	d0,d0					;word per frame
	movea.l	a1,a0
	move.w	$2(a0,d0.w),d1			;next frame offset
	sub.w	(a0,d0.w),d1			;frame length
	lsr.w	#3,d1					;8 bytes per sprite
	subi.w	#1,d1					;minus 1 for dbf
	move.w	d1,-(sp)
	adda.w	(a0,d0.w),a0			;the frame's sprites
	move.w	d4,d0
	addi.w	#$C0,d0					;view X center
	move.w	d0,d1
	subi.w	#$90,d0					;X left limit
	addi.w	#$80,d1					;X right limit
	move.w	#$170,d2				;view Y center
	sub.w	d5,d2					;minus the camera Y
	move.w	d2,d3
	subi.w	#$80,d2					;Y top limit
	addi.w	#$70,d3					;Y bottom limit
	move.w	(sp)+,d4
.loop2								;each sprite of the frame
	cmp.w	seY(a0),d2
	bgt.w	.next					;above the view: skip
	cmp.w	seY(a0),d3
	blt.w	.next					;below the view: skip
	cmp.w	(a0),d0
	bgt.w	.next					;left of the view: skip
	cmp.w	(a0),d1
	blt.w	.next					;right of the view: skip
	move.w	seY(a0),d5
	addi.w	#$70,d5
	sub.w	d2,d5
	move.w	d5,(a6)+
	move.b	seSize(a0),(a6)+
	move.b	d6,(a6)+
	move.w	seAttr(a0),d5			;attribute
	andi.w	#$F800,d5				;flip and palette bits
	add.w	seTile(a0),d5
	add.w	(arenaanimchars).l,d5	;plus the animation tile base
	move.w	d5,(a6)+
	move.w	(a0),d5
	addi.w	#$70,d5
	sub.w	d0,d5
	move.w	d5,(a6)+
	addi.w	#1,d6
	cmpi.w	#$40,d6					;64 sprites at most?
	beq.w	.x						;table full: stop
;CD: no cartridge twin
.next								;CD: placed where the disc branches to it
	adda.w	#$8,a0
	dbf	d4,.loop2					;next sprite
.x									;pop the d0-d5 saved above
	movem.l	(sp)+,d0-d5
.x2									;exit (also the end of the code above)
	rts
PrintPlayerNameRight				;Print the name of player d0 of team a2 (FormatPlayerName), moved left so
									;it ends before column $29 (a trailing pad byte or
									;two not counted), then the icon of HotColdIcon. Called from
									;PrintMatchupRatings
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d0,(iconplayer).l		;player for the icon
	move.l	a2,-(sp)
	jsr	(FormatPlayerName).l
	movea.l	a1,a0
	move.w	(a0),d0
	move.w	d0,d5
	tst.b	-$1(a0,d5.w)			;trailing pad byte?
	bne.w	.0
	subi.w	#1,d0					;first pad byte
	tst.b	-$2(a0,d5.w)			;second pad byte?
	bne.w	.0
	subi.w	#1,d0					;second pad byte
.0									;text width without the padding
	add.w	(printx).l,d0
	subi.w	#$29,d0					;past column $29?
	bmi.w	.1						;fits: leave printx
	neg.w	d0
	add.w	d0,(printx).l
.1									;clamped to the right edge
	movea.l	a0,a1
	jsr	(print).l
	movea.l	(sp)+,a2
	jsr	(HotColdIcon).l				;hot / cold icon
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SkipNameNumber						;Unreferenced. A1 = the FormatPlayerNumInitial String without its first 2
									;characters (the length word moved up 2)
	movem.l	d0-d7/a0/a2-a3,-(sp)
	jsr	(FormatPlayerNumInitial).l
	move.w	(a1),d0
	subi.w	#2,d0
	move.w	d0,2(a1)				;2 characters shorter
;CD: no cartridge twin
	adda.w	#$2,a1
	movem.l	(sp)+,d0-d7/a0/a2-a3
	rts
	String	' . '
PeriodStatsScreen					;"Period Stats" menu item (menu lists): both team logos (TeamLogoBitmaps,
									;TeamLogoPalettes palettes), then the goals (matchup 0) or shots of each
									;team by period (at the end of the team struct; OT when sflags7 bit 1)
									;and the total. Left / right switch, start exits (ExitStatsScreen)
	movem.l	d0-d7/a0-a6,-(sp)
;CD: no cartridge twin
	movem.l	d7/a0,-(sp)
	movea.l	$47D24.l,a0
	move.w	#$2,d7
	jsr	$6044.w
	movem.l	(sp)+,d7/a0
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.s	.L29540
	move.w	#$1,-(a6)
	bra.s	.L29544
.L29540
	move.w	#$0,-(a6)
.L29544
	bclr.b	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$4,d0
	jsr	$6044.w
	move.l	a0,(TeamLogoBitmapsPtr).l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.L29584
	bset.b	#$5,$FF800F.l
	bra.s	.L2958C
.L29584
	bclr.b	#$5,$FF800F.l
.L2958C
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	#$2,d0
	jsr	$5F22.w
	move.w	#$2,d0
	jsr	$5F22.w
.L295A4
	move.w	#$80,d0
	jsr	$5F22.w
	bcs.w	.L295A4
.L295B0
	move.w	#$81,d0
	jsr	$5F22.w
	move.w	(a0),d2
	andi.w	#$FF00,d2
	cmpi.w	#$0,d2
	bne.s	.L295B0
	move.w	#$5,$19364.l
	move.w	#$13,d0
	lea	$19364.l,a0
	jsr	$5F22.w
	jsr	$376D4.l
	clr.w	(matchup).l				;goals page first
	moveq	#0,d0
	moveq	#$1C,d1
	jsr	(SetupScreen).l				;set up the screen
	jsr	(printz).l
	String	CC_Font2Pri,1,$B
	move.w	#8,d0
	move.w	#8,d1
	jsr	(Framer).l					;visitors logo frame
	jsr	(printz).l
	String	CC_Font2Pri,1,$13
	move.w	#8,d0
	move.w	#8,d1
	jsr	(Framer).l					;home logo frame
	jsr	(printz).l
	String	CC_Font2Pal2Pri,2,$C
;CD: no cartridge twin
	movea.l	(TeamLogoBitmapsPtr).l,a0
	move.w	(VisTeam).l,d0
	asl.w	#2,d0
	movea.l	(a0,d0.w),a0			;visitors logo
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#3,d0					;32 bytes per palette
	movea.l	#TeamLogoPalettes,a0
	subi.w	#$40,d0
	adda.w	d0,a0					;palette of the team
	adda.l	(a2)+,a1
;CD: no cartridge twin
	clr.l	d1
	clr.l	d0
	moveq	#6,d2					;6 tiles wide
	move.w	#6,d3
	moveq	#4,d5
	jsr	(dobitmap).l				;draw the visitors logo
	movea.l	#palfadenew+$40,a0
	movea.l	#palfadenew+$60,a1
	move.w	#7,d0					;8 longs
.loop								;copy palette 2 to 3
	move.l	(a0)+,(a1)+
	dbf	d0,.loop					;next long
	jsr	(printz).l
	String	CC_Font2Pal3Pri,2,$14
;CD: no cartridge twin
	movea.l	(TeamLogoBitmapsPtr).l,a0
	move.w	(HomeTeam).l,d0
	asl.w	#2,d0
	movea.l	(a0,d0.w),a0			;home logo
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#3,d0
	subi.w	#$40,d0
	movea.l	#TeamLogoPalettes,a0
	adda.w	d0,a0					;palette of the team
	adda.l	(a2)+,a1
	clr.w	d1
	clr.w	d0
	moveq	#6,d2					;6 tiles wide
	move.w	#6,d3
	moveq	#4,d5
	jsr	(dobitmap).l				;draw the home logo
	jsr	(printz).l
	String	CC_Font3Pri,4,1
	moveq	#$20,d0
	moveq	#6,d1
	jsr	(Framer).l					;draw the box
	jsr	(printbigz).l
	String	CC_Font3Pri,6,3,'  Period Stats  ',CC_Font2Pri,6,1	;Period Stats title
	btst.b	#1,(sflags7).l			;overtime played?
	beq.w	.0
	jsr	(printz).l
	String	CC_Font2Pri,$0C,$09,'1',CC_Font2Pri,$11,$09,'2',CC_Font2Pri,$16,$09,'3',CC_Font2Pri,$1A,$09,'OT',CC_Font2Pri,' ',$09,'Total'
	jsr	(printz).l
	String	CC_Font2Pri,$0C,$0A,'<',CC_Font2Pri,$11,$0A,'<',CC_Font2Pri,$16,$0A,'<',CC_Font2Pri,$1A,$0A,'<<',CC_Font2Pri,' ',$0A,'<<<<<'
	bra.w	.1
.0									;bit 1 of sflags7 clear
	jsr	(printz).l
	String	CC_Font2Pri,$0C,$09,'1',CC_Font2Pri,$11,$09,'2',CC_Font2Pri,$16,$09,'3',CC_Font2Pri,' ',$09,'Total'
	jsr	(printz).l
	String	CC_Font2Pri,$0C,$0A,'<',CC_Font2Pri,$11,$0A,'<',CC_Font2Pri,$16,$0A,'<',CC_Font2Pri,' ',$0A,'<<<<<'
.1									;print the title and lines
	bsr.w	.title
	bsr.w	.lines
	move.w	#$18,(palcount).l		;fade in
.loop2								;loop
	jsr	(Pausemode_rjoy).l			;left (bit 2) goals, right (bit 3) shots, start exits
	btst	#7,d1					;start?
	bne.w	.exit
	btst	#2,d1					;left?
	bne.w	.3
	btst	#3,d1					;right?
	bne.w	.2
	bra.w	.loop2
.2									;bit 3 of d1 set
	tst.w	(matchup).l				;goals page?
	bne.w	.loop2					;already: ignore
	st.b	(matchup).l				;shots page
	bsr.w	.title
	bsr.w	.lines
	bra.w	.loop2					;next frame
.3									;bit 2 of d1 set
	tst.w	(matchup).l				;shots page?
	beq.w	.loop2					;already: ignore
	clr.w	(matchup).l				;goals page
	bsr.w	.title
	bsr.w	.lines
	bra.w	.loop2					;next frame
.exit								;pop the d0-d7/a0-a6 saved above
	movem.l	(sp)+,d0-d7/a0-a6
;CD: no cartridge twin
	movem.l	d7/a0,-(sp)
	movea.l	(TeamLogoBitmapsPtr).l,a0
	move.w	#$2,d7
	jsr	$6044.w
	movem.l	(sp)+,d7/a0
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.s	.L29822
	move.w	#$1,-(a6)
	bra.s	.L29826
.L29822
	move.w	#$0,-(a6)
.L29826
	bclr.b	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$2,d0
	jsr	$6044.w
	move.l	a0,$47D24.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.L29866
	bset.b	#$5,$FF800F.l
	bra.s	.L2986E
.L29866
	bclr.b	#$5,$FF800F.l
.L2986E
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	#$2,d0
	jsr	$5F22.w
.L2987E
	move.w	#$80,d0
	jsr	$5F22.w
	bcs.w	.L2987E
.L2988A
	move.w	#$81,d0
	jsr	$5F22.w
	move.w	(a0),d2
	andi.w	#$FF00,d2
	cmpi.w	#$0,d2
	bne.s	.L2988A
	move.w	#$5,$19364.l
	move.w	#$13,d0
	lea	$19364.l,a0
	jsr	$5F22.w
	jmp	(ExitStatsScreen).l			;back to the menu
.title								;local subroutine
	tst.w	(matchup).l				;shots page?
	beq.w	.6						;goals page
	jsr	(printz).l					;shots title
	String	CC_Font2Pri,$12,7,'Shots',CC_Font2Pri,$F,$1A,'[ For Goals'
	rts
.6									;matchup = 0
	jsr	(printz).l
	String	CC_Font2Pri,$12,7,'Goals',CC_Font2Pri,$F,$1A,'For Shots ]'	;goals title
	rts
.lines								;local subroutine
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	CC_Font2Pri,0,0
	movea.l	#awtmstruct,a2
	move.w	#$E,(printy).l
	bsr.w	.team
	movea.l	#tmstruct,a2
	move.w	#$16,(printy).l
	bsr.w	.team
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.team								;local subroutine
	lea	tmPerGoals(a2),a0
	tst.w	(matchup).l				;shots page?
	beq.w	.9						;goals page
	lea	tmPerShots(a2),a0
.9									;goals, or shots on the shots page
	clr.w	(matchuptimer).l
	move.w	#$B,(printx).l
	bsr.w	.num
	cmpi.w	#1,(gsp).l				;in the 2nd?
	blt.w	.10
	move.w	#$10,(printx).l			;second column
	bsr.w	.num					;second period
	cmpi.w	#2,(gsp).l				;in the 3rd?
	blt.w	.10
	move.w	#$15,(printx).l			;third column
	bsr.w	.num					;third period
	cmpi.w	#3,(gsp).l				;in overtime?
	blt.w	.10
	btst.b	#1,(sflags7).l			;overtime?
	beq.w	.10						;no overtime played
	move.w	#$1A,(printx).l
	bsr.w	.num
.10									;the total
	move.w	#$21,(printx).l			;total column
	jsr	(printz).l
	String	'   '					;clear the column
	subi.w	#3,(printx).l			;back to the column
	move.w	(matchuptimer).l,d0
	move.w	#2,d1					;2 digits
	cmpi.w	#$64,d0					;100 or more?
	blt.w	.11
	move.w	#3,d1					;3 digits
.11									;width for the number
	jsr	(PushNumberWidth).l
	jsr	(print).l
	rts
.num								;local subroutine
	move.w	(a0)+,d0
	add.w	d0,(matchuptimer).l		;add to the total
	jsr	(printz).l
	String	'   '					;clear the column
	subi.w	#3,(printx).l			;back to the column
	move.w	#2,d1					;2 digits
	cmpi.w	#$64,d0					;100 or more?
	blt.w	.13
	move.w	#3,d1					;3 digits
.13									;width for the number
	jsr	(PushNumberWidth).l
	jmp	(print).l
StatsReport							;"Game Statistics" menu item (menu lists): both
									;teams' totals (DisplayStats). There are more rows than the screen:
									;up / down scroll them (matchupvis the most, $70 or $30 without penalties,
									;OptPen), start exits (ExitStatsScreen)
	moveq	#9,d0
	moveq	#$1A,d1
	jsr	(SetupScreen).l				;set up the screen
	jsr	(printz).l
	String	CC_Font3Pri,4,1
	moveq	#$20,d0
	moveq	#6,d1
	jsr	(Framer).l					;draw the box
	jsr	(printbigz).l
	String	CC_Font3Pri,6,4,'Game  Statistics',CC_Font3Pri,7,1
	move.w	#$2C,d0					;visitors block
	jsr	(PutTeamBlock).l
	addi.w	#4,(printx).l
	clr.w	d0
	jsr	(PutTeamBlock).l
	clr.w	(DispAttribCtr).l
	clr.w	(VertLineScrolling).l
	clr.w	(PlayerScrollCtr).l
	move.w	#$70,(matchupvis).l		;the most scroll: 15 rows
	tst.w	(OptPen).l
	bne.w	.0
	move.w	#$30,(matchupvis).l		;11 rows
.0									;scroll limit set
	bsr.w	DisplayStats
	bsr.w	PrintStatScrollArrows
.loop								;loop
	jsr	(MenuWaitVblank).l			;wait for the frame
	jsr	(getpzjoy).l				;read the pads
	btst	#7,d3					;start?
	beq.w	.1
	jmp	(ExitStatsScreen).l
.1									;bit 7 of d3 clear
	jsr	(nodiag).l
	move.w	#$FFFE,d0
	btst	#0,d3					;up?
	bne.w	.2
	neg.w	d0
	btst	#1,d3					;down?
	beq.w	.3						;neither: carry on
.2									;up or down: scroll by d0 each frame
	move.w	d0,(PlayerScrollCtr).l
.3									;nothing new pressed: carry on any scroll still moving
	bsr.w	.scroll
	bsr.w	PrintStatScrollArrows
	bra.w	.loop					;next frame
.scroll								;local subroutine
	move.w	(PlayerScrollCtr).l,d0
	beq.w	rtsStatTables
	add.w	(VertLineScrolling).l,d0
	bmi.w	rtsStatTables			;above the top: stop
	cmp.w	(matchupvis).l,d0		;past the end?
	bgt.w	rtsStatTables			;past the end: stop
	move.w	(VertLineScrolling).l,d1
	move.w	d0,(VertLineScrolling).l
	andi.w	#$F,d0					;row step?
	bne.w	.5						;between rows
	clr.w	(PlayerScrollCtr).l		;on a row: stop
.5									;between rows: keep scrolling
	andi.w	#$F,d1					;old scroll on a row step?
	bne.w	SetStatScroll			;not on a row step yet
	move.w	d0,-(sp)
	cmpi.w	#$E,d0					;moving up?
	bne.w	.6						;not a row step
	bsr.w	StatScrollRow			;draw the next row above
.6									;not moving up
	move.w	(sp)+,d0
	cmpi.w	#2,d0					;moving down?
	bne.w	SetStatScroll			;not a row step
	bsr.w	StatScrollRowEnd		;draw the next row below
SetStatScroll						;Plane A vertical scroll (VSRAM 0) = VertLineScrolling - $50, with
									;disflags bit 2 set while it writes
	move.w	(disflags).l,-(sp)		;save the display flags
	bset.b	#dfng,(disflags).l		;no interrupt graphics
	movea.l	#Vdata,a0
;CD: no cartridge twin
.L29B72
	btst.b	#$7,$FF800E.l
	bne.s	.L29B72
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L29B96
	btst.b	#$6,$FF800E.l
	beq.s	.L29B96
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L29BB0
	btst.b	#$6,$FF800E.l
	bne.s	.L29BB0
	bclr.b	#$7,$FF800F.l
	move.w	#$FFB0,d0
	add.w	(VertLineScrolling).l,d0
.L29BCC
	btst.b	#$7,$FF800E.l
	bne.s	.L29BCC
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L29BEC
	btst.b	#$6,$FF800E.l
	beq.s	.L29BEC
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L29C06
	btst.b	#$6,$FF800E.l
	bne.s	.L29C06
	bclr.b	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l		;restore the display flags
	rts
StatScrollRow						;d3 = VertLineScrolling / 16 (StatsReport, at a scroll step)
	move.w	(VertLineScrolling).l,d3
	lsr.w	#4,d3
	bra.w	rtsStatScroll
StatScrollRowEnd					;d3 = VertLineScrolling / 16 + 6 (StatsReport, at a scroll step)
	move.w	(VertLineScrolling).l,d3
	lsr.w	#4,d3
	addi.w	#6,d3					;plus 6 rows
	bra.w	rtsStatScroll
rtsStatScroll						;rts of StatScrollRow / StatScrollRowEnd
	rts
PrintStatScrollArrows				;StatsReport scroll arrows (printz2): up ($7B) when VertLineScrolling > 0,
									;down ($7D) when it is below matchupvis
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printsmallz).l
	String	CC_SetFont,1			;arrow font
	tst.w	(VertLineScrolling).l	;at the top?
	beq.w	.0						;at the top: none
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,3,'&',8,CC_SetFont,1,'{'	;up arrow
	bra.w	.1
.0									;VertLineScrolling = 0
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,3,'&',8,CC_SetFont,1,' '	;no up arrow
.1									;up arrow done
	move.w	(matchupvis).l,d0
	cmp.w	(VertLineScrolling).l,d0	;at the end?
	beq.w	.2						;at the end: none
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,3,'&',$1A,CC_SetFont,1,'}'	;down arrow
	bra.w	.3
.2									;d0 = VertLineScrolling
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,4,3,'&',$1A,CC_SetFont,1,' '	;no down arrow
.3									;down arrow done
	jsr	(printsmallz).l
	String	CC_SetFont				;normal font
	movem.l	(sp)+,d0-d7/a0-a6
	rts
DisplayStats						;Team logos (PutTeamBlock), then each
									;TeamStatTextTbl row (TeamStatTextTblNoPen when penalties are off, OptPen)
									;centred, with the home value at x $22 and the visitors' at x 9
									;(PrintStatValue); SetStatScroll first
	jsr	(printz).l
	String	CC_Font3Pri,2,7			;visitors logo position
	move.w	#$2C,d0
	jsr	(PutTeamBlock).l
	jsr	(printz).l
	String	CC_Font3Pri,$1A,7		;home logo position
	moveq	#0,d0
	jsr	(PutTeamBlock).l
	bsr.w	SetStatScroll
	jsr	(printz).l
	String	CC_Font2Pri,0,0
	moveq	#$E,d6					;15 rows
	lea	TeamStatTextTbl(pc),a1
	tst.w	(OptPen).l
	bne.w	.row
	move.w	#$A,d6					;11 rows
	lea	TeamStatTextTblNoPen(pc),a1
.row								;label table chosen
	move.w	(a1),d0
	lsr.w	#1,d0					;half the label width
	neg.w	d0
	addi.w	#$15,d0					;centre the label around x $15
	move.w	d0,(printx).l
	jsr	(print).l
	movea.l	a1,a0					;a0 = stat offsets
	move.w	#$22,(printx).l
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	bsr.w	PrintStatValue
	move.w	#9,(printx).l
	lea	tmsize(a2),a2
	bsr.w	PrintStatValue			;away team value, centred at x 9
	lea	4(a0),a1
	addi.w	#2,(printy).l			;2 map rows per table row
	dbf	d6,.row						;next row
	rts
PrintStatValue						;Print TeamStatTextTbl entry a0 for team a2 centred at printx: the value
									;(tmATOP and tmPwrPlayTime are times
									;PushTime), "/second" if any, " (pct%)" for passing. Offset $FFFF is the
									;shooting percentage (tmscore * 100 / tmshots), printed with a "%"
	movea.l	#$17EF2,a3				;CD: the cartridge has #(mesarea-M68K_RAM)
	move.w	#2,(a3)					;empty string
	cmpi.w	#$FFFF,(a0)				;shooting percentage row
	bne.w	.1
	move.w	#tmscore,d0
	move.w	(a2,d0.w),d0
	mulu.w	#$64,d0
	move.w	#tmshots,d1
	move.w	(a2,d1.w),d1
	beq.w	.0
	divu.w	d1,d0
.0									;% ready (0 with no shots)
	jsr	(PushNumber).l
	jsr	(appstring).l
	jsr	(appendz).l
	String	'%'
	bra.w	.6						;print it
.1									;not the shooting percentage: the value
	move.w	(a0),d0
	move.w	(a2,d0.w),d0
	cmpi.w	#tmPwrPlayTime,(a0)		;PP minutes row?
	bne.w	.2
	bsr.w	.8
	bra.w	.4						;time appended
.2									;a0 <> #tmPwrPlayTime
	cmpi.w	#$A,(a0)				;ATOP row?
	beq.w	.3
	bsr.w	.7
.3									;time line done
	cmpi.w	#$A,(a0)				;ATOP row?
	bne.w	.4
	bsr.w	.8
.4									;print the label
	jsr	(appstring).l
	move.w	2(a0),d0				;second offset
	bmi.w	.6
	jsr	(appendz).l
	String	'/'
	move.w	(a2,d0.w),d0
	jsr	(PushNumber).l
	jsr	(appstring).l
	cmpi.w	#$14,(a0)				;passing row?
	bne.w	.6
	jsr	(appendz).l
	String	' ('
	move.w	(a0),d0
	move.w	(a2,d0.w),d0
	mulu.w	#$64,d0
	move.w	2(a0),d1
	move.w	(a2,d1.w),d1
	beq.w	.5
	divu.w	d1,d0
.5									;% ready (0 when the divisor is 0)
	jsr	(PushNumber).l
	jsr	(appstring).l
	jsr	(appendz).l
	String	'%)'
;CD: no cartridge twin
.6									;CD: placed where the disc branches to it
	movea.l	a3,a1
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).l
	jmp	(print).l
.7									;local subroutine
	jmp	(PushNumber).l
.8									;local subroutine
	jmp	(PushTime).l
TeamStatTextTbl						;Label, then the team struct stat offset and the second offset ($FFFF
									;none). 15 rows
	String	'Score'
	dc.w	tmscore,$FFFF
	String	'Shots'
	dc.w	tmshots,$FFFF
	String	'Shooting Pct'
	dc.w	$FFFF,$FFFF
	String	'Power Play'
	dc.w	tmPwrGoals,tmPwrPlays
	String	'PP Minutes'
	dc.w	tmPwrPlayTime,$FFFF
	String	'PP Shots'
	dc.w	tmPPShots,$FFFF
	String	'SH Goals'
	dc.w	tmSHGoals,$FFFF
	String	'Breakaways'
	dc.w	tmBreakawayGoals,tmBreakaways
	String	'One-Timers'
	dc.w	tmOneTimerGoals,tmOneTimers
	String	'Penalty Shots'
	dc.w	tmPenShotGoals,tmPenShots
	String	'Faceoffs Won'
	dc.w	tmfowon,$FFFF
	String	'Body Checks'
	dc.w	tmchecks,$FFFF
	String	'Penalties'
	dc.w	tmPenalties,tmPenmin
	String	'Attack Zone'
	dc.w	tmATOP,$FFFF
	String	'Passing'
	dc.w	tmpasscomp,tmpasses
TeamStatTextTblNoPen				;The rows without the power play ones, used when penalties are off. 11
									;rows
	String	'Score'
	dc.w	tmscore,$FFFF
	String	'Shots'
	dc.w	tmshots,$FFFF
	String	'Shooting Pct'
	dc.w	$FFFF,$FFFF
	String	'Breakaways'
	dc.w	tmBreakawayGoals,tmBreakaways
	String	'One-Timers'
	dc.w	tmOneTimerGoals,tmOneTimers
	String	'Penalty Shots'
	dc.w	tmPenShotGoals,tmPenShots
	String	'Faceoffs Won'
	dc.w	tmfowon,$FFFF
	String	'Body Checks'
	dc.w	tmchecks,$FFFF
	String	'Penalties'
	dc.w	tmPenalties,tmPenmin
	String	'Attack Zone'
	dc.w	tmATOP,$FFFF
	String	'Passing'
	dc.w	tmpasscomp,tmpasses
rtsStatTables						;rts after the stat tables (StatsReport scroll step)
	rts
updatePPTeamTime					;One more second of power play time (tmPwrPlayTime) for the team
									;on the power play (sflags2 bit 5, bit 6 the visitors). Called from
									;updatepentime
	btst.b	#sf2pwrplay,(sflags2).l
	beq.w	.x
	movea.l	#tmstruct,a2			;move home team struct into a2
	btst.b	#sf2pwrtm,(sflags2).l	;check who's on PP
	beq.w	.0						;branch if home (team 1)
	movea.l	#awtmstruct,a2			;move away team struct into a2
.0									;team on the power play chosen
	addi.w	#1,tmPwrPlayTime(a2)	;one more second of power play time
.x									;exit (also the end of the code above)
	rts
GetTeamRating						;d0 = the TeamRatings byte of team tmteam(a2). Called from PrintTeamRating
									;(the player card "Team Rating") and PrintMatchupRating
	movem.l	d1-d7/a0-a6,-(sp)
	move.w	tmteam(a2),d0
	movea.l	#TeamRatings,a0
	clr.w	d1
	move.b	(a0,d0.w),d1
	move.w	d1,d0
	movem.l	(sp)+,d1-d7/a0-a6
	rts
TeamRatings							;GetTeamRating values, one byte per team (TeamList order)
	dc.b	$33,$4C,$49,$4B,$4E,$43,$4B,$43,$34,$42,$4A,$49,$44,$42
	dc.b	$4A,$37,$45,$4B,$47,$38,$45,$38,$48,$47,$48,$46,$5B,$59
TeamRatingsEnd						;end of TeamRatings (size check below)
	even
ShortenMsgTimer						;Cap msgtimer at 2, unless a second pad is on (cont2team) and a3 is not
									;the puck carrier. Called from doinput
	movem.l	d0,-(sp)
	tst.w	(cont2team).l
	beq.w	.0
	move.w	SCnum(a3),d0
	cmp.w	(puckc).l,d0
	bne.w	.x
.0									;message for the puck carrier (or one pad)
	cmpi.w	#2,(msgtimer).l
	ble.w	.x
	move.w	#2,(msgtimer).l
.x									;exit: restore the registers
	movem.l	(sp)+,d0
	rts
ManualGoalieMenu					;"x Manual Goalie" menu item (menu lists; PrintMenuItem prints Manual /
									;Auto Goalie from the same words): with OptNOP set, toggle the goalie mode
									;of the pause pad (goaliemode2 for pad 2, sflags bit 1, else goaliemode1;
									;both when the pads are on one team). In a penalty shot or shootout
									;(gmode2 bit 0, BA_PS_flags bit 2) the pad then takes player 0 / 6 or 5 /
									;$B by its mode, when BA_Sktr_SCnum is on its side (setc1player /
									;setc2player)
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(OptNOP).l				;goalie option set?
	beq.w	.chkso					;no goalie option: switch only
	move.w	(cont1team).l,d0
	cmp.w	(cont2team).l,d0		;same team?
	bne.w	.0						;pads on different teams
	eori.w	#1,(goaliemode2).l		;toggle pad 2's goalie mode
	bra.w	.g1						;same team: pad 1 too
.0									;d0 <> cont2team
	btst.b	#sfpj,(sflags).l		;which pad paused?
	beq.w	.g1						;pad 1 paused
	eori.w	#1,(goaliemode2).l		;toggle pad 2's goalie mode
	bra.w	.chkso
.g1									;pad 1's goalie mode
	eori.w	#1,(goaliemode1).l		;toggle pad 1's goalie mode
.chkso								;shootout or penalty shot?
	btst.b	#0,(gmode2).l			;shootout?
	bne.w	.so
	btst.b	#2,(BA_PS_flags).l		;penalty shot?
	beq.w	.x
.so									;shootout or penalty shot: switch the pad's player
	btst.b	#sfpj,(sflags).l		;which pad paused?
	bne.w	.p2						;pad 2 paused
	cmpi.w	#2,(OptNOP).l			;OptNOP 2?
	bne.w	.4
	cmpi.w	#5,(BA_Sktr_SCnum).l	;visiting shooter?
	bgt.w	.x						;skater on the other side
	bra.w	.5
.4									;OptNOP <> 2
	cmpi.w	#5,(BA_Sktr_SCnum).l	;home shooter?
	ble.w	.x						;skater on the other side
.5									;pad 1: goalie or skater
	move.w	#0,d0					;goalie slot 0
	cmpi.w	#2,(OptNOP).l
	bne.w	.6						;not OptNOP 2
	move.w	#6,d0					;OptNOP 2: slot 6
.6									;goalie slot chosen
	tst.w	(goaliemode1).l			;goalie mode of pad 1
	bne.w	.set1					;manual: the goalie
	move.w	#5,d0					;skater slot 5
	cmpi.w	#2,(OptNOP).l
	bne.w	.set1
	move.w	#$B,d0					;OptNOP 2: skater slot $B
.set1								;set pad 1's player
	jsr	(setc1player).l
	bra.w	.x
.p2									;sfpj set
	cmpi.w	#2,(OptNOP).l			;OptNOP 2?
	bne.w	.9
	cmpi.w	#5,(BA_Sktr_SCnum).l	;home shooter?
	ble.w	.x						;skater on the other side
	bra.w	.10
.9									;OptNOP <> 2
	cmpi.w	#5,(BA_Sktr_SCnum).l	;visiting shooter?
	bgt.w	.x						;skater on the other side
.10									;pad 2: goalie or skater
	move.w	#6,d0					;goalie slot 6
	tst.w	(goaliemode2).l			;goalie mode of pad 2
	bne.w	.set2					;manual: the goalie
	move.w	#$B,d0					;skater slot
.set2								;set pad 2's player
	jsr	(setc2player).l
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
