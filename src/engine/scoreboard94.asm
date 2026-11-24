; Scoreboard, ticker and highlights. This file shows the power play graphic and the time remaining,
; switches the rink between its horizontal and vertical views (ClrHor, SetHor), draws the scoreboard and
; the energy bars, counts shot stats, runs the end of period intermission, the ticker scores and the
; highlights (DoHiLights).

updatepwrplay						;show graphic and time remaining for power plays. Nothing when gmode2 bit
									;1 is set, and no song at the start of a home power
									;play (the gmode2 test is kept but both ways go to .uppt). Prints the time
									;and the team on the power play
	btst	#1,(gmode2).w
	bne.w	rtss2
	movea.w	#(tmstruct-M68K_RAM),a2
	lea	tmsize(a2),a3				;tmsize
	move.w	tmap(a2),d0				;tmap
	sub.w	tmap(a3),d0				;players on ice: team 1 minus team 2
	beq.w	.clrpwrplay				;same number on the ice
	bpl.w	.t0						;team 1 has more
	btst	#sf2pwrtm,(sflags2).w	;sf2pwrtm: 0 home, 1 visitors
	bne.w	.upp
	bsr.w	.clrpwrplay				;power play team changed: remove the old display
	bset	#sf2pwrtm,(sflags2).w
	bra.w	.upp
.t0									;power play team 1
	exg	a2,a3						;a2 = shorthanded team 2, a3 = power play team 1
	btst	#sf2pwrtm,(sflags2).w
	beq.w	.upp
	bsr.w	.clrpwrplay
	bclr	#sf2pwrtm,(sflags2).w
.upp								;power play side noted
	bset	#sf2pwrplay,(sflags2).w	;sf2pwrplay
	bne.w	.uppt					;already showing a power play
	addq.w	#1,tmPwrPlays(a3)		;tmPwrPlays
	cmpa.w	#(tmstruct-M68K_RAM),a3	;home team (93 played song $33 here)
	bne.w	.away
.home								;(the same code for both teams)
	bra.w	.uppt
.away								;a3 <> tmstruct
	bra.s	.home
.uppt								;print the power play display
	bsr.w	printz
	String	CC_Font1Pri,1,$19,'   ',$16,$17,$18,$19,CC_Font1Pri,1,$1A,'  ',0
	bsr.w	GetLowestPen			;d0 = time left
	bsr.w	PushTime				;a1 = m:ss string
	bsr.w	print
	movea.l	tmdata(a3),a0			;tmdata
	movea.w	#(mesarea-M68K_RAM),a3
	move.w	#2,(a3)					;empty string in mesarea, then append the position string and name
	bsr.w	appendz
	String	CC_Font1Pri,1,$19
	adda.w	Teamname(a0),a0			;team name
	adda.w	(a0),a0
	movea.l	a0,a1
	bsr.w	appstring
	movea.w	a3,a1
	bra.w	print
.clrpwrplay							;d0 = 0
	bclr	#sf2pwrplay,(sflags2).w
	beq.w	rtss2
	bra.w	EASNLogo
ClrHor								;revert the graphics back to vertical ice rink mode. Reloads Rinktiles and
									;calls LoadHomeTeamGfx
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#sfhor,(sflags).w		;sfhor
	move.w	#$3E8,(Oldrow).w		;1000
	move.w	(rinkvrcset).w,d4
	movea.l	#Rinktiles,a2
	jsr	(DecompressGraphicsPlain).l
	jsr	(LoadHomeTeamGfx).l
	bsr.w	SprSort
	btst	#sfpz,(sflags).w		;sfpz
	bne.w	.ex
	bsr.w	printz
	String	CC_Font1,0,0
	moveq	#$20,d0					;32
	moveq	#$1C,d1					;28
	move.w	#$7FF,d2				;blank tile
	bsr.w	eraser					;blank the 32x28 area
	bsr.w	printscores1			;redraw the score board
.ex									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SetHor								;switch graphics to horizontal ice rink graphics mode
	movem.l	d0-d7/a0-a6,-(sp)
	bset	#sfhor,(sflags).w		;sfhor
.p									;loop
	btst	#dfok,(disflags).w		;dfok
	bne.s	.p
	clr.w	(Hscroll).w
	clr.w	(Vscroll).w
	bsr.w	SprSort
	bsr.w	printz
	String	CC_Font2,0,0
	movea.l	#IceRinkHorMap,a1		;tiles start at IceRinkHorMap+8
	adda.l	jimdata(a1),a1
	movea.l	#IceRinkHorTiles,a2		;rink tiles
	clr.w	d0
	move.w	#0,d1
	moveq	#$20,d2					;32
	moveq	#$1C,d3					;28
	move.w	(rinkvrcset).w,d4		;start char of the rink tiles
	moveq	#0,d5					;no palette lines
	bsr.w	dobitmap
	bsr.w	USBoard					;draw the score board and penalty box lines
	btst	#sfpz,(sflags).w		;sfpz
	bne.w	.ex
	move.w	#$800,d0				;92 $1000
	move.w	(VmMAP1).w,d1
	move.w	#$7FF,d2				;blank tile
	bsr.w	DoFill					;fill d0 words at VmMAP1 with the blank tile
.ex									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
;	Scoreboard, score ticker, intermission and highlight routines, from printscores1 to StartHL2.
;
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp /
;	cmpi; fixopcodes.js patches the cmp encoding after assembly.

;Team struct (tmstruct / awtmstruct, tmsize bytes) and game struct (gstruct, gssize each): fields named in
;ram94.asm. 94 adds shots by period and power play shots at the end of the team struct.

printscores1						;Draw scoreboard. Vertical rink: period box and the score box (team names
									;and scores). Horizontal rink .sbscreen: period and both team logos with
									;big scores. The period name is gsp of PerLabels, or name 4 of PerLabels2
									;when gmode2 bit 1 is set; the horizontal rink uses PerLabels2 (name 4
									;when bit 0 is set).
									;sflags5 bit 7 sets crowdnoisedelay = $78. Called from USBoard, Pausemode,
									;lcfound_close and others
	movem.l	d0-d2/a0-a3,-(sp)
	btst	#sfhor,(sflags).w		;sfhor
	bne.w	.sbscreen
	bclr	#7,(sflags5).w
	beq.w	.0
	move.w	#$78,(crowdnoisedelay).w
.0									;crowd noise delay set after a noise stop
	bsr.w	printz
	String	CC_Font1Pri,0,$17
	moveq	#9,d0					;period box: 9x5 frame at x 0, y $17
	moveq	#5,d1
	bsr.w	Framer
	bset	#dfclock,(disflags).w	;dfclock
	bsr.w	printz
	String	CC_Font1Pri,1,$18
	move.w	(gsp).w,d0				;period name
	movea.l	#PerLabels,a1
	btst	#1,(gmode2).w
	beq.w	.1
	move.w	#4,d0
	movea.l	#PerLabels2,a1
.1									;period names chosen
	bsr.w	Fprintsmall				;print the period name in the box
	bsr.w	EASNLogo				;logo under it (unless a power play is shown)
	btst	#sf3llcs,(sflags3).w	;sf3llcs: lower line change box is up
	bne.w	.ex
	bsr.w	printz
	String	CC_Font1Pri,$17,$17
	moveq	#8,d0					;score box: 8x5 frame at x $17, y $17
	moveq	#5,d1
	bsr.w	Framer
	bsr.w	printz
	String	CC_Font1Pri,$18,$1A		;home team on the lower row
	movea.w	#(tmstruct-M68K_RAM),a2
	bsr.w	printscores1_ps
	bsr.w	printz
	String	CC_Font1Pri,$18,$18
	adda.w	#tmsize,a2				;tmsize
	bsr.w	printscores1_ps
.ex									;exit: restore the registers
	movem.l	(sp)+,d0-d2/a0-a3
	rts
.sbscreen							;sfhor set
	bsr.w	printz
	String	CC_Font2Pri,$11,2
	move.w	(gsp).w,d0
	btst	#0,(gmode2).w
	beq.w	.2
	move.w	#4,d0
.2									;period index chosen
	movea.l	#PerLabels2,a1			;the horizontal rink always takes the name from PerLabels2
	bsr.w	AdvanceStringPtr
	move.w	(a1),d0					;center the period name on x $11
	lsr.w	#1,d0					;center the period name on x $11
	sub.w	d0,(printx).w
	bsr.w	print
	bsr.w	printz
	String	CC_Font2Pri,$17,2
	movea.w	#(tmstruct-M68K_RAM),a2
	clr.w	d0						;home logo data offset
	bsr.w	PrintTeamLogoAndScore
	bsr.w	printz
	String	CC_Font2Pri,8,2
	adda.w	#tmsize,a2				;tmsize
	move.w	#$2C,d0					;visitor logo data offset
	bsr.w	PrintTeamLogoAndScore
	bra.s	.ex
printscores1_ps						;Print the team name of team a2 at printx/printy, then its score as 2
									;digits at x $1C. Called twice from printscores1
	movea.l	tmdata(a2),a1			;tmdata
	adda.w	Teamname(a1),a1
	adda.w	(a1),a1					;skip the first string to the team name
	bsr.w	print
	move.w	#$1C,(printx).w			;score column
	move.w	tmscore(a2),d0			;tmscore
	moveq	#2,d1					;2 digits
	bsr.w	PushNumberWidth
	bra.w	print					;print the score and return
PrintTeamLogoAndScore				;Draw the team logo map (PutTeamBlock, d0 = offset) 5 columns left of
									;printx then the score of team a2 in big font, centered 2 rows lower; a 2
									;digit score is moved one more left.
									;Called twice from printscores1
	move.w	(printx).w,-(sp)
	subq.w	#5,(printx).w
	jsr	(PutTeamBlock).l
	move.w	(sp)+,(printx).w
	addq.w	#2,(printy).w
	move.w	tmscore(a2),d0			;tmscore
	cmp.w	#$A,d0
	bge.w	.0
	bra.w	.1
.0									;d0 >= $A
	subq.w	#1,(printx).w
.1									;score position set
	bsr.w	PushNumber				;a1 = score string
	move.w	(a1),d0					;center on the old printx
	subq.w	#2,d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	addq.w	#1,(printx).w
	bra.w	printbig
EASNLogo							;Draw the EASN logo map at x 1, y $19 on the vertical ice rink if no power
									;play. Called from printscores1 and updatepwrplay
	btst	#sf2pwrplay,(sflags2).w	;sf2pwrplay
	bne.w	rtss2
	bsr.w	printz
	String	CC_Font1Pri,1,$19
	movea.l	#EASportsMap,a1
	adda.l	jimdata(a1),a1
	movea.w	#null,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2					;width and height from the map header
	move.w	mapheight(a1),d3
	move.w	(EASNcset).w,d4
	clr.w	d5
	bra.w	dobitmap
USBoard								;Update score board, including the players in the penalty box and their
									;time remaining. Called from InProgress and SetHor
	movem.l	d0-d7/a0-a3,-(sp)
	bset	#dfclock,(disflags).w	;dfclock
	bsr.w	printscores1
	bsr.w	printz
	String	CC_Font2Pri,$14,8
	movea.w	#(tmstruct-M68K_RAM),a2	;home team
	bsr.w	.dispen
	bsr.w	printz
	String	CC_Font2Pri,5,8
	movea.w	#(awtmstruct-M68K_RAM),a2	;visitors
	bsr.w	.dispen
	movem.l	(sp)+,d0-d7/a0-a3
	rts
.dispen								;penalty box list of team a2: the players without a coincidental penalty
									;first, then those with one
	lea	tmboxlist(a2),a0
.l1									;loop
	clr.w	d0						;pass 1: players with bit 14 (coincidental) clear
	move.b	(a0)+,d0
	bmi.w	.p2						;end of list
	btst	#6,tmpdst(a2,d0.w)		;coincidental (tmpdst high byte bit 6)
	bne.s	.l1
	bsr.w	pplpen
	bra.s	.l1
.p2									;d0 negative
	lea	tmboxlist(a2),a0
.l2									;loop
	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	rtss2
	btst	#6,tmpdst(a2,d0.w)
	beq.s	.l2
	bsr.w	pplpen
	bra.s	.l2
pplpen								;print one penalty box line: player number and time remaining. a2 = team,
									;d0 = roster offset (player*2). Only
									;rows up to y $A are printed; printy += 1. Called from USBoard .dispen
	cmpi.w	#$A,(printy).w
	bhi.w	rtss2					;no room for more rows
	move.w	tmpdst(a2,d0.w),d2
	andi.w	#$7FF,d2				;penalty time
	movea.l	tmdata(a2),a1			;tmdata
	adda.w	(a1),a1					;a1 = roster in the team data
	lsr.w	#1,d0					;d0 = player index
.find								;skip one roster entry
	adda.w	(a1),a1					;skip d0+1 roster entries (name string + 8 bytes)
	addq.w	#pldsize,a1
	dbf	d0,.find
	clr.w	d0
	move.b	pldnum-pldsize(a1),d0	;player number (BCD)
	move.w	(printx).w,-(sp)
	movea.w	#(TextBuffer-M68K_RAM),a1	;mesarea+2
	bsr.w	ConvertByteToDigits		;two digits to TextBuffer
	movea.w	#(mesarea-M68K_RAM),a1
	move.w	#4,(a1)					;string length: 2 digits
	bsr.w	print					;print the number
	move.w	d2,d0
	bsr.w	PushTime				;m:ss string
	bsr.w	print					;print the time next to it
	move.w	(sp)+,(printx).w
	addq.w	#1,(printy).w			;next row
	rts
linebar								;Draw the energy bar of line d0 for team a2 at printx/printy (bitmap from
									;the bar map, 16 steps). Called from SetLCmode2
	movem.l	d0-d5/a0-a2,-(sp)
	bsr.w	getlinee
	move.w	(printa).w,-(sp)
	move.w	#$8000,(printa).w		;priority attribute for the bar
	ext.l	d0
	divu.w	#$100,d0				;4096/16
	cmp.w	#$F,d0
	bls.w	.ok
	moveq	#$F,d0					;clamp to 15
.ok									;d0 = energy step 0-15
	moveq	#$F,d1					;d1 = bar frame (15 = empty)
	sub.w	d0,d1					;d1 = bar frame (15 = empty)
	clr.w	d0
	movea.l	#EnergyBarMap,a1
	adda.l	jimdata(a1),a1
	movea.w	#null,a2				;tile pointer null (as in SetHor)
	move.w	(a1),d2					;map width
	moveq	#1,d3					;1 row high
	move.w	(energybarchars).w,d4
	moveq	#0,d5
	bsr.w	dobitmap				;d1 = start row in the map = frame
	move.w	(sp)+,(printa).w
	movem.l	(sp)+,d0-d5/a0-a2
	rts
getlinee							;d0 = line number, a2 = team struct. Return d0 = energy level of this line
	movem.l	d1-d5/a0-a3,-(sp)
	lea	tmlines(a2),a1				;line sets
	asl.w	#3,d0					;8 bytes per line
	adda.w	d0,a1					;a1 = this line (one player number per position)
	clr.l	d0						;d0 = energy sum
	clr.w	d1						;d1 = players counted
	movea.l	#priolist,a0
	move.w	tmap(a2),d4				;tmap
	bra.w	.next
.loop								;add the energy of each player on the ice
	clr.w	d5
	move.b	0(a0,d4.w),d5			;position
	beq.w	.next					;goalie energy doesn't count
	clr.w	d3
	move.b	0(a1,d5.w),d3			;player number
	asl.w	#1,d3
	addq.w	#1,d1
	add.w	tmpde-2(a2,d3.w),d0		;tmpde-2
.next								;next player
	dbf	d4,.loop					;loop over tmap players
	divu.w	d1,d0					;average energy
	movem.l	(sp)+,d1-d5/a0-a3
	rts
AvgCline							;Return d0 = average energy of current line on team a2
	movem.l	d1-d3/a0,-(sp)
	clr.l	d0						;d0 = energy sum
	clr.w	d1						;d1 = skaters counted
	moveq	#5,d2					;6 sort objects of the team
	movea.w	tmsort(a2),a0			;tmsort
.loop								;each sort object of the team
	tst.w	position(a0)			;position
	ble.w	.next
	clr.w	d3
	move.b	pnum(a0),d3				;pnum
	add.w	d3,d3
	add.w	tmpde(a2,d3.w),d0		;tmpde
	addq.w	#1,d1
.next								;next object
	adda.w	#SCstruct,a0
	dbf	d2,.loop
	tst.w	d1
	beq.w	.ex						;nobody: avoid the divide
	divu.w	d1,d0					;average
.ex									;exit: restore the registers
	movem.l	(sp)+,d1-d3/a0
	rts
ChkShotStat							;determine if shot taken, add to appropriate stats: crowd, team, shooter
									;and goalie shots against. Nothing while the
									;clock is stopped or in a highlight, PP shots and period shots
									;and a second path (sflags4 bit 0, sflags8 bit 3 every second
									;call) that counts the shot for the player in the last ScoreSum entry
	btst	#gmclock,(gmode).w		;gmclock: clock stopped
	bne.w	rtss2					;exit if so
	btst	#gmhl,(gmode).w			;gmhl: highlight
	bne.w	rtss2					;exit if so
	bclr	#sf2shot,(sflags2).w	;sf2shot: shot taken
	bne.w	.Cwdupdate				;it was set
	btst	#0,(sflags4).w
	beq.w	rtss2					;exit if cleared
	bclr	#3,(sflags8).w
	bne.w	.0
	bset	#3,(sflags8).w
	bra.w	rtss2
.0									;3 was set
	movem.l	d0-d1/a1-a3,-(sp)
	move.l	a4,-(sp)
	movea.l	#ScoreSum-6,a4			;ChkCnt. +ScoreSumbytes, then 2(a4) = the last ScoreSum entry
	adda.w	(ScoreSumbytes).w,a4
	movea.l	#tmstruct,a2			;home team
	btst	#7,ssflags(a4)			;entry flag: visitors
	beq.w	.pllookup
	adda.w	#tmsize,a2				;tmsize
.pllookup							;team of the scorer chosen
	clr.w	d0
	move.b	ssscorer(a4),d0			;pnum (roster offset)
	movea.l	(sp)+,a4
	movea.w	tmsort(a2),a2			;tmsort
	move.w	#5,d1
.findplayer							;find the scorer among the team's objects
	cmp.b	pnum(a2),d0				;pnum
	beq.w	.foundplayer
	adda.w	#$80,a2					;SCstruct
	dbf	d1,.findplayer
	bra.w	.ex
.foundplayer						;scorer found: credit his shot
	move.w	SCnum(a2),d0			;SCnum
	bra.w	.addShot
.Cwdupdate							;sf2shot was set
	movem.l	d0-d1/a1-a3,-(sp)
	addi.w	#$64,(Crowdlevel).w		;100
	addi.w	#$A,(CwdExciteLvl).w
	move.w	(shotplayer).w,d0
.addShot							;credit the shot to player d0
	asl.w	#scsize,d0				;scsize
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3
	bsr.w	loadTeamStruct
	addq.w	#1,(a2)					;tmshots
	btst	#sf2pwrplay,(sflags2).w	;sf2pwrplay
	beq.w	.2
	btst	#sf2pwrtm,(sflags2).w	;sf2pwrtm: 0 home, 1 visitors
	bne.w	.1
	btst	#pfteam,pflags(a3)		;pfteam
	bne.w	.2						;not the team on the power play
.PPshot								;loop
	addq.w	#1,tmPPShots(a2)		;power play shots
	bra.w	.2
.1									;sf2pwrtm set
	btst	#pfteam,pflags(a3)		;pfteam
	bne.s	.PPshot
.2									;not a power play shot
	move.l	a2,-(sp)
	move.w	(gsp).w,d0				;period
	add.w	d0,d0
	adda.w	d0,a2
	addq.w	#1,tmPerShots(a2)		;shots by period
	movea.l	(sp)+,a2
	clr.w	d0
	move.b	pnum(a3),d0				;pnum
	addi.w	#tmpshots,d0
	addq.b	#1,0(a2,d0.w)			;shooter's shot count
	move.w	tmgoalie(a1),d0			;other team's tmgoalie
	bmi.w	.ex						;empty net
	addi.w	#tmpshots,d0
	addq.b	#1,0(a1,d0.w)			;goalie's shots against
.ex									;exit: restore the registers
	movem.l	(sp)+,d0-d1/a1-a3
	rts
loadTeamStruct						;return a2 = team struct of player a3, a1 = the other team's struct.
									;Called from ChkShotStat and updateplayers
	movea.w	#(tmstruct-M68K_RAM),a2
	lea	tmsize(a2),a1				;tmsize
	btst	#pfteam,pflags(a3)		;pfteam
	beq.w	rtss2
	exg	a1,a2
	rts
SetupTeamForIntermission			;Reset the bench, then for each team refill energy and pick the starting
									;line: power play 1 (3) for the team with more players on ice, PK1 (5) for
									;the team with fewer, else 0. Called from Intermission
	bsr.w	ResetBench
	movea.w	#(tmstruct-M68K_RAM),a2
	lea	tmsize(a2),a3
	bsr.w	.r
	exg	a2,a3						;falls in for the other team
.r									;refill this team
	bsr.w	reenergizeteam			;refill energy for this team
	clr.w	tmline(a3)				;tmline
	tst.w	(OptLine).w
	bne.w	rtss2					;line changes off
	move.w	tmap(a3),d0
	sub.w	tmap(a2),d0
	beq.w	rtss2
	move.w	#3,tmline(a3)			;Pw1
	tst.w	d0
	bpl.w	rtss2
	move.w	#5,tmline(a3)			;PK1
	rts
RestoreTeamEnergy					;a2 = team: max energy (tmpde $1000) for every player. The skip needs
									;tmpdst to be both -3 and -4, so it never happens.
									;Called from the menu code before ReplayMode
	moveq	#(maxros-1)*2,d0		;(MaxRos-1)*2
.loop								;loop
	cmpi.w	#$FFFD,tmpdst(a2,d0.w)
	bne.w	.0
	cmpi.w	#$FFFC,tmpdst(a2,d0.w)
	bne.w	.0
	bra.w	.1
.0									;not injured: full energy
	move.w	#$1000,tmpde(a2,d0.w)	;tmpde
.1									;next player
	subq.w	#2,d0
	bpl.s	.loop
	rts
reenergizeteam						;Set all players to max energy on team a2 except those at tmpdst -4;
									;players marked -3 in tmpdst go to
									;the bench (-2). Called from SetupTeamForIntermission and StartHL2
									;.setteam
	moveq	#(maxros-1)*2,d0		;(MaxRos-1)*2
.loop								;loop
	cmpi.w	#$FFFC,tmpdst(a2,d0.w)
	beq.w	.nb
	move.w	#$1000,tmpde(a2,d0.w)	;tmpde
	cmpi.w	#$FFFD,tmpdst(a2,d0.w)
	bne.w	.nb
	move.w	#$FFFE,tmpdst(a2,d0.w)	;on bench
.nb									;next player
	subq.w	#2,d0
	bpl.s	.loop
	rts
Intermission						;end of period junk (zamboni/stats). Opens the pause menu screen (item
									;list by period, +5 in playoffs), shows the ticker scores of the other
									;games, then the highlights; Start on either pad cuts it short. When gsp
									;is 4 the clock is cleared and UpdateRecords runs first, and gmode2 bit 0
									;picks the ShootoutIntermissionMenu item list.
									;Called from PeriodOver
	cmpi.w	#4,(gsp).w
	bne.w	.1
	move.w	#0,(gameclock).w
	jsr	(UpdateRecords).l
.1									;records updated after the last period
	bsr.w	SetupTeamForIntermission
	moveq	#$F,d0
	movea.w	#(SortCords-M68K_RAM),a0
.clr								;clear the Xpos of each sort object
	clr.w	(a0)					;Xpos
	adda.w	#SCstruct,a0			;SCstruct
	dbf	d0,.clr
	move.w	(ExtraChars).w,d4
	movea.l	#ZamSprites+8,a2		;+8
	bsr.w	DecompressGraphicsPlain
	move.w	#$140,(Zamx).w			;320
	move.w	(gsp).w,d0
	tst.w	(OptPlayMode).w
	beq.w	.ss
	addq.w	#5,d0					;playoffs
.ss									;period index (+5 in the playoffs)
	asl.w	#2,d0
	lea	.sslist(pc),a0
	movea.l	0(a0,d0.w),a0
	btst	#0,(gmode2).w
	beq.w	.2
	movea.l	#ShootoutIntermissionMenu,a0
.2									;menu chosen (shootout menu in a shootout)
	bset	#sfpz,(sflags).w		;sfpz
	movea.l	#Pausemode_pall,a1
	jsr	(Pausemode_top).w
	bsr.w	GetShifter				;d1 = highest game index
	move.w	d1,(TickerNum).w		;ticker starts from the last game
.top								;loop
	tst.w	(TickerNum).w			;one ticker game per pass
	bmi.w	.doh					;no more ticker games
	bsr.w	NewTicker2				;d3 = next game to show
	bsr.w	NewTicker3				;show its score
	move.w	#$96,d0					;150 frames
	bsr.w	waitxsr
	btst	#sbut,d1				;Start?
	bne.w	.clrh
	bsr.w	ClearTickerArea			;blank pause, then the next game
	move.w	#$3C,d0					;60 frames
	bsr.w	waitxsr
	btst	#7,d1
	beq.s	.top
.clrh								;start pressed: show the highlights
	bset	#sf3sbut,(sflags3).w	;sf3sbut
.doh								;show the highlights
	bsr.w	DoHiLights				;show the requested highlights
	bclr	#sf3sbut,(sflags3).w
	bne.w	.clrz					;start pressed (flag set by .clrh or by a highlight): leave
.wait								;loop
	move.w	#$1E0,d0				;480 frames
	bsr.w	waitxsr
	btst	#7,d1
	bne.w	.clrz
	tst.w	(cont1team).w
	bne.s	.wait					;keep waiting while a pad is on a team
	tst.w	(cont2team).w
	bne.s	.wait
.clrz								;no pad on a team: leave
	st	(Zamx).w					;zamboni off
	rts
.sslist								;menu item lists by period, then playoff period
	dc.l	StartGameText,IntermissionText,IntermissionText,IntermissionText,ExitGameText
	dc.l	StartGameTextPO,IntermissionText,IntermissionText,IntermissionText,ExitGameTextPO
InitScores							;initialize other games scores/period in playoffs. Called from StartGame
	cmpi.w	#1,(gamelevel).w
	bgt.w	rtss2
	bsr.w	GetShifter
	movea.w	#(gstruct-M68K_RAM),a0
	moveq	#gssize,d0				;gssize
	mulu.w	d1,d0
	adda.w	d0,a0					;a0 = gstruct of game d1, counting down
.top								;each game
	cmp.w	(gamenum).w,d1			;per game
	beq.w	.next					;not the game being played
	btst	#gsfso,gsflags(a0)		;gsfso
	bne.w	.next					;series already over
	clr.w	gsper(a0)				;gsper
	moveq	#3,d0
	bsr.w	randomd0				;random 0-2: score that many plus one periods
	bra.w	.1
.0									;score one more period
	bsr.w	SetScore
.1									;loop the random count
	dbf	d0,.0
.next								;next game
	suba.w	#gssize,a0				;gssize
	dbf	d1,.top						;next game
	rts
UpdateScores						;update ticker score values. Called from PeriodOver
	bsr.w	GetShifter				;d1 = highest game index
	move.w	d1,(TickerNum).w		;restart the ticker
	movea.w	#(gstruct-M68K_RAM),a0
	moveq	#gssize,d0				;gssize
	mulu.w	d1,d0
	adda.w	d0,a0					;a0 = gstruct of game d1, counting down
.top								;each game
	cmp.w	(gamenum).w,d1			;per game
	beq.w	.next					;not the game being played
	bclr	#gsfhl,gsflags(a0)		;gsfhl
	btst	#gsfso,gsflags(a0)		;gsfso
	bne.w	.next					;series over
	bsr.w	SetScore				;one more period for this game
.next								;next game
	suba.w	#gssize,a0				;gssize
	dbf	d1,.top
	rts
SetScore							;add to score for game in a0. After period 3 a game within one goal goes
									;to OT (gsper 3) and asks for a highlight
	cmpi.w	#4,gsper(a0)			;gsper
	bge.w	rtss2
	movem.l	d0-d1/a0-a1,-(sp)
	cmpi.w	#3,gsper(a0)
	bne.w	.o
	move.w	#5,gsper(a0)			;final
	move.w	gss1(a0),d0				;gss1
	sub.w	gss2(a0),d0				;gss2
	cmp.w	#1,d0
	bgt.w	.ex
	cmp.w	#$FFFF,d0
	blt.w	.ex
	move.w	#3,gsper(a0)			;close game: overtime
	bset	#gsfhl,gsflags(a0)		;gsfhl
	bra.w	.ex
.o									;not the last period: next period
	addq.w	#1,gsper(a0)
	move.w	(a0),d0					;gst1
	move.w	gst2(a0),d1				;gst2
	bsr.w	.getscore
	add.w	d0,gss1(a0)				;gss1
	move.w	gst2(a0),d0
	move.w	(a0),d1
	bsr.w	.getscore				;goals for team 2
	add.w	d0,gss2(a0)				;gss2
.ex									;exit: restore the registers
	movem.l	(sp)+,d0-d1/a0-a1
	rts
.getscore							;d0 = scoring team, d1 = other team. Adds the scoring team's (bits 4-6)
									;and the other team's (bits 0-2) sctab rows as weights. Return d0 = goals
									;0-3
	asl.w	#2,d0
	movea.w	#TeamList,a1
	movea.l	0(a1,d0.w),a1
	adda.w	ScoutReport(a1),a1
	move.b	(a1),d0
	andi.w	#$70,d0
	lsr.w	#1,d0					;row * 8
	lea	sctab(pc),a1
	move.l	0(a1,d0.w),(nibblebuffer).w
	move.l	4(a1,d0.w),(nibblebuffer+4).w
	asl.w	#2,d1
	movea.w	#TeamList,a1
	movea.l	0(a1,d1.w),a1
	adda.w	ScoutReport(a1),a1
	move.b	(a1),d0
	andi.w	#7,d0
	asl.w	#3,d0
	lea	sctab(pc),a1
	move.l	0(a1,d0.w),d1
	add.l	d1,(nibblebuffer).w
	move.l	4(a1,d0.w),d1
	add.l	d1,(nibblebuffer+4).w
	moveq	#4,d0					;4 weights
	bra.w	WeightedRandomSelect
sctab								;weights for 0, 1, 2, 3 goals, 8 rows (92 had 4 percent bytes per row)
	dc.w	$2B,$1E,$17,4
	dc.w	$27,$20,$18,5
	dc.w	$23,$21,$1A,6
	dc.w	$1E,$22,$1E,6
	dc.w	$1A,$24,$1E,8
	dc.w	$16,$25,$1F,$A
	dc.w	$13,$26,$1F,$C
	dc.w	$F,$26,$20,$F
NewTicker							;show the next ticker score once the clock is at 8:00 or less. d3 = -1 if
									;not. Called from chkprogress. Falls into NewTicker2
	moveq	#-1,d3					;none yet
	cmpi.w	#$1E0,(gameclock).w		;480
	bgt.w	rtss2
NewTicker2							;goto next ticker. Return d3 = game, or neg if none left. Falls into
									;NewTicker3
	move.w	(TickerNum).w,d3
	bmi.w	rtss2
	subq.w	#1,(TickerNum).w
	cmp.w	(gamenum).w,d3			;don't show current game as ticker
	beq.s	NewTicker2
CheckGameTickerStatus				;d3 = game. Return a0 = its gstruct; skip to the next ticker game if a
									;highlight is coming up or the series is over. Called from StartHL2
	moveq	#gssize,d0				;gssize
	mulu.w	d3,d0
	movea.w	#(gstruct-M68K_RAM),a0
	adda.w	d0,a0
	btst	#gsfhl,gsflags(a0)		;gsfhl
	bne.s	NewTicker2				;don't show if hilite coming up
	btst	#gsfso,gsflags(a0)		;gsfso
	bne.s	NewTicker2				;don't show if the series is over for this game
	rts
NewTicker3							;Display ticker score for game d3 (a0 = gstruct entry), skip if d3 is
									;negative. Called from chkprogress, Intermission and StartHL2
	tst.w	d3
	bmi.w	rtss2
	bsr.w	SetTickerAreaPosition	;d0/d1 = box size
	bsr.w	Framer					;draw the ticker box
	addq.w	#1,(printx).w			;inside the frame, top row
	subq.w	#4,(printy).w
	move.w	(printx).w,-(sp)		;box x: .tn reads it at 4(sp), above its return address
	bsr.w	GetShifter
	move.w	#$A000,(printa).w
	bsr.w	printz
	String	'                        '	;24 spaces
	move.w	(sp),(printx).w
	moveq	#1,d0
	add.w	(gamelevel).w,d0		;playoffs: label 1 + round
	tst.w	(OptPlayMode).w
	bne.w	.0
	clr.w	d0						;not playoffs: 'EA Hockey Night'
.0									;ticker title index chosen
	lea	GameLabels(pc),a1			;a1 = ticker title list
	bsr.w	Fprintsmall				;print the ticker title
	move.w	gsper(a0),d0			;gsper
	subq.w	#1,d0
	movea.l	#PerLabels,a1
	bsr.w	AdvanceStringPtr
	move.w	(a1),d0					;period name centered on x+$17
	lsr.w	#1,d0
	neg.w	d0
	add.w	(sp),d0
	addi.w	#$17,d0
	move.w	d0,(printx).w
	bsr.w	print
	move.w	#$8000,(printa).w
	move.w	gst2(a0),d0				;gst2
	move.w	gss2(a0),d1				;gss2
	bsr.w	.tn						;team 2 on the first row
	move.w	(a0),d0					;gst1
	move.w	gss1(a0),d1				;gss1
	bsr.w	.tn						;team 1 on the second row
	addq.w	#2,sp					;drop the saved printx
	rts
.tn									;print team d0 name and score d1 on the next row
	move.w	4(sp),(printx).w		;print team d0 name and score d1 on the next row
	addq.w	#1,(printy).w
	movea.w	#TeamList,a1			;team address table
	asl.w	#2,d0
	movea.l	0(a1,d0.w),a1
	adda.w	Teamname(a1),a1			;team name
	bsr.w	print
	move.w	4(sp),(printx).w
	addi.w	#$15,(printx).w			;92 23
	move.w	d1,d0
	moveq	#2,d1
	bsr.w	PushNumberWidth
	bra.w	print
GameLabels							;Ticker titles, by OptPlayMode and gamelevel
	String	'EA Hockey Night'
	String	'Stanley Cup Qualifier'
	String	'Quarterfinal'
	String	'Stanley Cup Semifinal'
ClearTickerArea						;Erase the ticker box. Called from Intermission and StartHL2
	bsr.w	SetTickerAreaPosition
	move.w	#$7FF,d2				;blank char
	bra.w	eraser
SetTickerAreaPosition				;Set printx/printy/printm for the ticker box (x 3, y $17; the $BD map in
									;pause mode). Return d0 = $1A wide, d1 = 5 high. Called from NewTicker3pt2
									;and ClearTickerArea
	bsr.w	printz
	String	CC_Font3Pri,3,$17
	btst	#sfpz,(sflags).w		;sfpz
	bne.w	.1
	bsr.w	printz
	String	CC_Font1Pri,3,$17
.1									;sfpz set
	moveq	#$1A,d0					;box size 26x5
	moveq	#5,d1
	rts
Fprintsmall							;but printing with printsmall (92 used print). Print string d0
									;of the String list a1 with printsmall
	bsr.w	AdvanceStringPtr
	bra.w	printsmall
AdvanceStringPtr					;Return a1 = string d0 of the String list a1
	bra.w	.0
.loop								;skip one String
	adda.w	(a1),a1
.0									;loop d0 times
	dbf	d0,.loop
	rts
DoHiLights							;Hilites logic: search for hilite game and show
									;hilite. Called from Intermission
	bsr.w	GetShifter				;d1 = highest game index
	moveq	#gssize,d3				;gssize
	mulu.w	d1,d3
	movea.w	#(gstruct-M68K_RAM),a0
	adda.w	d3,a0
.top								;each game
	btst	#gsfso,gsflags(a0)		;gsfso
	bne.w	.next					;series over
	bclr	#gsfhl,gsflags(a0)		;gsfhl
	beq.w	.next					;no highlight requested
	bsr.w	StartHL
.next								;next game
	suba.w	#gssize,a0				;gssize
	dbf	d1,.top
	rts
StartHL								;Play hilite for game a0, d1 = game. Called from DoHiLights. Falls into
									;StartHL2
	movem.l	d0-d7/a0-a6,-(sp)
StartHL2							;Play hilite for game a0. Start skips it with a random result. A tied game
									;is replayed (beq StartHL2). Uses
									;song $79, setupice_highlight, setplayercolors
	btst	#sf3sbut,(sflags3).w	;sf3sbut
	bne.w	.nhl0					;start already pressed: just pick a random result
	bsr.w	.sv						;save the real game state (gmode ... ScoreSumbytes)
	move.w	d1,d3
	bsr.w	CheckGameTickerStatus
	bsr.w	NewTicker3				;show score from hilight game
	btst	#sf3sbut,(sflags3).w
	bne.w	.nhl1
	move.w	#4,(printx).w			;"Highlight from game:" box, 24x3 above the ticker
	subq.w	#6,(printy).w
	moveq	#$18,d0					;24
	moveq	#3,d1
	bsr.w	Framer
	addq.w	#1,(printx).w
	subq.w	#2,(printy).w
	bsr.w	printz
	String	'Highlight from game:'	;the text as code
	move.w	#$B4,d0					;180 frames
	bsr.w	waitxsr
	btst	#sbut,d1				;Start?
	bne.w	.nhl1					;start: skip the highlight
	st	(Zamx).w					;zamboni off
	clr.w	(CwdExciteLvl).w
	move.w	(a0),(HomeTeam).w		;set up teams for game in a0
	move.w	gst2(a0),(VisTeam).w
	move.l	a0,-(sp)				;keep the gstruct pointer
	clr.w	(tmstruct+tmgoalie).w
	clr.w	(awtmstruct+tmgoalie).w
	jsr	(clearTeamStats).l
	jsr	(restoreteams).w			;load both teams' data
	st	(c1playernum).w				;no human players
	st	(c2playernum).w
	clr.w	(cont1team).w
	clr.w	(cont2team).w
	moveq	#$78,d0					;120
	bsr.w	randomd0
	addi.w	#$3C,d0					;60
	move.w	d0,(gameclock).w		;random clock, 60 + 0-119
	movea.l	(sp),a0
	move.w	gsper(a0),(gsp).w		;gsper
	subq.w	#1,(gsp).w
	move.w	gss1(a0),(HmGoals).w	;gss1
	move.w	gss2(a0),(AwGoals).w	;gss2
	move.b	#$10,(gmode).w			;1<<gmhl
	btst	#0,(gsp+1).w			;odd period: gmdir set (home team goes the other way)
	beq.w	.ndi
	bset	#gmdir,(gmode).w		;gmdir
.ndi								;direction set for the period
	clr.b	(sflags).w				;fresh state flags for the highlight
	move.b	#4,(sflags2).w			;1<<sf2drec
	clr.b	(sflags3).w
	bclr	#dffaceoff,(disflags).w
	bset	#dfclock,(disflags).w	;dfclock
	clr.w	(glovecords).w
	clr.b	(iflags).w
	st	(RefCnt).w
	st	(puckcross2).w
	st	(puckcross6).w
	jsr	(p_turnoff).l
	bsr.w	setupice_highlight
	bsr.w	ClrHor					;vertical rink
	movea.l	#Vdata,a0
	move.w	#VDPR_WINX,Vctrl-Vdata(a0)	;window H position 0
	move.w	#VDPR_WINY,Vctrl-Vdata(a0)	;window V position 0
	move.w	(ExtraChars).w,d4		;ref cam chars
	movea.l	#RefsMap+8,a2			;+8
	bsr.w	DecompressGraphicsPlain
	clr.w	(Vpos).w
	clr.w	(Hpos).w
	bsr.w	ResetBench
	movea.w	#(tmstruct-M68K_RAM),a2
	bsr.w	.setteam
	adda.w	#tmsize,a2				;tmsize
	bsr.w	.setteam
	bsr.w	resetplstuff
	moveq	#$B,d0					;12 players: put each on his face off spot
	movea.l	#.postab,a0
	movea.w	#(SortCords-M68K_RAM),a1
.loop								;put each player on his face off spot
	move.w	position(a1),d1			;position
	btst	#pfgoal,pflags(a1)		;pfgoal
	bne.w	.pl0
	addq.w	#6,d1
.pl0								;spot for his end of the ice
	asl.w	#2,d1
	move.w	Xpos(a0,d1.w),(a1)		;Xpos
	move.w	2(a0,d1.w),Ypos(a1)		;Ypos
	clr.w	Xvel(a1)				;Xvel
	clr.w	Yvel(a1)				;Yvel
	adda.w	#SCstruct,a1
	dbf	d0,.loop
	bsr.w	SprSort
	move.w	#$18,(palcount).w		;24
	move.w	(Vcount).w,(OldVcount).w
	move.w	#$B4,-(sp)				;180 frames after the clock stops
.0									;loop
	jsr	(DoGameFrame).w
	btst	#gmclock,(gmode).w		;gmclock
	beq.w	.1						;clock running
	subq.w	#1,(sp)
	bmi.w	.endhl					;clock stopped for 180 frames: highlight over
.1									;clock running, or stopped less than 180 frames
	bsr.w	orjoy
	btst	#cbut,d1				;C?
	bne.w	.2
	btst	#sbut,d1				;Start?
	beq.s	.0
.2									;C or start: end the highlight now
	move.w	(HmGoals).w,d0			;tied: random winner
	cmp.w	(AwGoals).w,d0
	bne.w	.endhl
	move.w	(HVcount).l,d0			;hvcount
	andi.w	#1,d0
	add.w	d0,(HmGoals).w
	eori.w	#1,d0
	add.w	d0,(AwGoals).w
.endhl								;highlight over
	addq.w	#2,sp					;drop the frame counter
	movea.l	(sp)+,a0				;a0 = gstruct
	movem.l	d1/a0,-(sp)
	jsr	(KillCrowd).l
	jsr	(p_turnoff).l
	movem.l	(sp)+,d1/a0
	move.w	(HmGoals).w,gss1(a0)	;gss1
	move.w	(AwGoals).w,gss2(a0)	;gss2
	bsr.w	forceblack
	moveq	#$F,d0					;clear Xpos of the 16 sort objects
	movea.w	#(SortCords-M68K_RAM),a0
.clr								;clear the Xpos of each sort object
	clr.w	(a0)					;Xpos
	adda.w	#SCstruct,a0
	dbf	d0,.clr
	bsr.w	.lo						;restore the saved game state
	bsr.w	setplayercolors
	bsr.w	SetHor					;back to the intermission screen
	bsr.w	setvideo
	jsr	(Pausemode_pall).w			;pause menu screen
	jsr	(DrawMenuScreen).w
	move.w	#$18,(palcount).w		;24
	move.w	#SngEOP,-(sp)			;song $79
	bsr.w	song
	movem.l	(sp),d0-d7/a0-a6		;reload the registers StartHL pushed (a0 = gstruct, d1 = game)
	move.w	#4,gsper(a0)			;gsper: OT
	move.w	gss1(a0),d0				;gss1
	cmp.w	gss2(a0),d0				;gss2
	beq.w	StartHL2				;still tied: play another hilite
	move.w	#5,gsper(a0)			;final
	move.w	d1,d3
	bsr.w	CheckGameTickerStatus	;show the final score in the ticker
	bsr.w	NewTicker3
	move.w	#$B4,d0					;180 frames
	bsr.w	waitxsr
	btst	#7,d1
	bne.w	.exit2
	bsr.w	ClearTickerArea
	move.w	#$3C,d0					;60 frames
	bsr.w	waitxsr
	btst	#7,d1
	beq.w	.exit
.exit2								;start pressed: skip the rest
	bset	#sf3sbut,(sflags3).w	;sf3sbut
.exit								;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.nhl1								;sf3sbut set or sbut set
	bsr.w	.lo						;start pressed after .sv: restore the state, random result
	bsr.w	.ranres
	bra.s	.exit2
.nhl0								;sf3sbut set
	bsr.w	.ranres
	bra.s	.exit
.setteam							;refill energy, set personnel; also clears sflags8 bit 7
	jsr	(reenergizeteam).l			;refill energy and set tmtouch1/2/3(a2) per team (a2 = team)
	bsr.w	setpersonel
	bsr.w	forcepldata
	st	tmtouch1(a2)
	bclr	#7,(sflags8).w
	st	tmtouch2(a2)
	st	tmtouch3(a2)
	rts
.ranres								;random resolve of game (if tied = random score)
	move.w	gss1(a0),d0				;random resolve of game (if tied = random score)
	cmp.w	gss2(a0),d0
	bne.w	.rr0
	move.w	(HVcount).l,d0			;hvcount
	andi.w	#1,d0
	add.w	d0,gss1(a0)
	eori.w	#1,d0
	add.w	d0,gss2(a0)
.rr0								;result set: game final
	move.w	#5,gsper(a0)			;gsper: final
	rts
.sv									;save $5BE words from gmode to M68K_RAM, then ScoreSumbytes
	move.w	#$5BD,d0
	movea.w	#(gmode-M68K_RAM),a1
	movea.l	#M68K_RAM,a2
.sv1								;copy each word
	move.w	(a1)+,(a2)+				;copy words from gmode to ReplayStart
	dbf	d0,.sv1
	move.w	(ScoreSumbytes).w,(a2)+	;also save ScoreSumbytes
	rts
.lo									;restore what .sv saved
	move.w	#$5BD,d0
	movea.w	#(gmode-M68K_RAM),a2
	movea.l	#M68K_RAM,a1
.lo1								;copy each word back
	move.w	(a1)+,(a2)+				;copy the saved words back
	dbf	d0,.lo1
	move.w	(a1)+,(ScoreSumbytes).w
	rts
.postab								;Xpos,Ypos by position (goalie, l.def, r.def, l.wing, center, r.wing),
									;pfgoal set, then clear
	dc.w	0,-240,-70,-140,20,-110,-100,-60,25,-40,70,-80
	dc.w	0,240,34,90,-55,80,100,40,-10,10,-50,0
