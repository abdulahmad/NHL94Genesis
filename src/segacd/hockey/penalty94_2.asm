;	HOCKEY.BIN $212D0-$22425 (runtime $3C2D0-$3D425): penalty94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Part 2 of penalty94, from updatepwrplay (see penalty94.asm).

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

null	equ	$1B008
TeamList	equ	$1B00C
UpdateRecords	equ	$25A4E
LoadHomeTeamGfx	equ	$2A9D0
restoreteams	equ	$2B996
DoGameFrame	equ	$2BB8E
Pausemode_pall	equ	$2C1F8
Pausemode_top	equ	$2C2F8
DrawMenuScreen	equ	$2C310
PutTeamBlock	equ	$2C59E
WeightedRandomSelect	equ	$36BE2
forceblack	equ	$36D0A
randomd0	equ	$37050
song	equ	$371D2
waitxsr	equ	$37340
orjoy	equ	$37460
DoFill	equ	$37AA2
dobitmap	equ	$387E2
DecompressGraphicsPlain	equ	$38958
eraser	equ	$38C06
Framer	equ	$38CA0
printsmall	equ	$38D9E
printz	equ	$38F6E
print	equ	$38F80
PushTime	equ	$390F4
PushNumber	equ	$3915E
PushNumberWidth	equ	$3919A
appendz	equ	$39200
appstring	equ	$39208
printbig	equ	$3926A
GetLowestPen	equ	$3A0A6
rtss2	equ	$3C000
setpersonel	equ	$3D426
forcepldata	equ	$3D668
ResetBench	equ	$3D6E2
setvideo	equ	$3DD16
setupice_highlight	equ	$3EB3C
SprSort	equ	$3F03E
resetplstuff	equ	$3F0C6
clearTeamStats	equ	$3F11E
setplayercolors	equ	$3F24C
GetShifter	equ	$4081C
ConvertByteToDigits	equ	$412A8
PerLabels	equ	$41A34
PerLabels2	equ	$41A48
priolist	equ	$41AD6
ShootoutIntermissionMenu	equ	$42250
StartGameText	equ	$422D4
StartGameTextPO	equ	$42388
IntermissionText	equ	$42454
ExitGameText	equ	$425B0
ExitGameTextPO	equ	$426C4
p_turnoff	equ	$47DAC
KillCrowd	equ	$48208

	org	$3C2D0

updatepwrplay						;show graphic and time remaining for power plays. Nothing when gmode2 bit
									;1 is set, and no song at the start of a home power
									;play (the gmode2 test is kept but both ways go to .uppt). Prints the time
									;and the team on the power play
	btst.b	#1,(gmode2).l
	bne.w	rtss2
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	lea	tmsize(a2),a3				;tmsize
	move.w	tmap(a2),d0				;tmap
	sub.w	tmap(a3),d0				;players on ice: team 1 minus team 2
	beq.w	.clrpwrplay				;same number on the ice
	bpl.w	.t0						;team 1 has more
	btst.b	#sf2pwrtm,(sflags2).l	;sf2pwrtm: 0 home, 1 visitors
	bne.w	.upp
	bsr.w	.clrpwrplay				;power play team changed: remove the old display
	bset.b	#sf2pwrtm,(sflags2).l
	bra.w	.upp
.t0									;power play team 1
	exg	a2,a3						;a2 = shorthanded team 2, a3 = power play team 1
	btst.b	#sf2pwrtm,(sflags2).l
	beq.w	.upp
	bsr.w	.clrpwrplay
	bclr.b	#sf2pwrtm,(sflags2).l
.upp								;power play side noted
	bset.b	#sf2pwrplay,(sflags2).l	;sf2pwrplay
	bne.w	.uppt					;already showing a power play
	addi.w	#1,tmPwrPlays(a3)		;tmPwrPlays
	cmpa.l	#$1834C,a3				;home team (93 played song $33 here) (CD: the cartridge has
									;#(tmstruct-M68K_RAM))
	bne.w	.away
.home								;(the same code for both teams)
	bra.w	.uppt
.away								;a3 <> tmstruct
	bra.w	.home
.uppt								;print the power play display
	bsr.w	printz
	String	CC_Font1Pri,1,$19,'   ',$16,$17,$18,$19,CC_Font1Pri,1,$1A,'  ',0
	bsr.w	GetLowestPen			;d0 = time left
	bsr.w	PushTime				;a1 = m:ss string
	bsr.w	print
	movea.l	tmdata(a3),a0			;tmdata
	movea.l	#$17EF2,a3				;CD: the cartridge has #(mesarea-M68K_RAM)
	move.w	#2,(a3)					;empty string in mesarea, then append the position string and name
	bsr.w	appendz
	String	CC_Font1Pri,1,$19
	adda.w	Teamname(a0),a0			;team name
	adda.w	(a0),a0
	movea.l	a0,a1
	bsr.w	appstring
;CD: no cartridge twin
	movea.l	a3,a1
	bra.w	print
.clrpwrplay							;d0 = 0
	bclr.b	#sf2pwrplay,(sflags2).l
	beq.w	rtss2
	bra.w	EASNLogo
ClrHor								;revert the graphics back to vertical ice rink mode. Reloads Rinktiles and
									;calls LoadHomeTeamGfx
	movem.l	d0-d7/a0-a6,-(sp)
	bclr.b	#sfhor,(sflags).l		;sfhor
	move.w	#$3E8,(Oldrow).l		;1000
	move.w	(rinkvrcset).l,d4
;CD: no cartridge twin
	movea.l	(RinktilelistPtr).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	jsr	(LoadHomeTeamGfx).l
	bsr.w	SprSort
	btst.b	#sfpz,(sflags).l		;sfpz
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
	bset.b	#sfhor,(sflags).l		;sfhor
.p									;loop
	btst.b	#dfok,(disflags).l		;dfok
	bne.w	.p
	clr.w	(Hscroll).l
	clr.w	(Vscroll).l
	bsr.w	SprSort
	bsr.w	printz
	String	CC_Font2,0,0
;CD: no cartridge twin
	movea.l	(IceRinkHorMapPtr).l,a1
	adda.l	$4(a1),a1
	movea.l	(IceRinkHorMapPtr).l,a2
	addq.l	#$8,a2
	clr.w	d0
	move.w	#0,d1
	moveq	#$20,d2					;32
	moveq	#$1C,d3					;28
	move.w	(rinkvrcset).l,d4		;start char of the rink tiles
	moveq	#0,d5					;no palette lines
	bsr.w	dobitmap
	bsr.w	USBoard					;draw the score board and penalty box lines
	btst.b	#sfpz,(sflags).l		;sfpz
	bne.w	.ex
	move.w	#$800,d0				;92 $1000
	move.w	(VmMAP1).l,d1
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
	btst.b	#sfhor,(sflags).l		;sfhor
	bne.w	.sbscreen
	bclr.b	#7,(sflags5).l
	beq.w	.0
	move.w	#$78,(crowdnoisedelay).l
.0									;crowd noise delay set after a noise stop
	bsr.w	printz
	String	CC_Font1Pri,0,$17
	moveq	#9,d0					;period box: 9x5 frame at x 0, y $17
	moveq	#5,d1
	bsr.w	Framer
	bset.b	#dfclock,(disflags).l	;dfclock
	bsr.w	printz
	String	CC_Font1Pri,1,$18
	move.w	(gsp).l,d0				;period name
	movea.l	#PerLabels,a1
	btst.b	#1,(gmode2).l
	beq.w	.1
	move.w	#4,d0
	movea.l	#PerLabels2,a1
.1									;period names chosen
	bsr.w	Fprintsmall				;print the period name in the box
	bsr.w	EASNLogo				;logo under it (unless a power play is shown)
	btst.b	#sf3llcs,(sflags3).l	;sf3llcs: lower line change box is up
	bne.w	.ex
	bsr.w	printz
	String	CC_Font1Pri,$17,$17
	moveq	#8,d0					;score box: 8x5 frame at x $17, y $17
	moveq	#5,d1
	bsr.w	Framer
	bsr.w	printz
	String	CC_Font1Pri,$18,$1A		;home team on the lower row
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
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
	move.w	(gsp).l,d0
	btst.b	#0,(gmode2).l
	beq.w	.2
	move.w	#4,d0
.2									;period index chosen
	movea.l	#PerLabels2,a1			;the horizontal rink always takes the name from PerLabels2
	bsr.w	AdvanceStringPtr
	move.w	(a1),d0					;center the period name on x $11
	lsr.w	#1,d0					;center the period name on x $11
	sub.w	d0,(printx).l
	bsr.w	print
	bsr.w	printz
	String	CC_Font2Pri,$17,2
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	clr.w	d0						;home logo data offset
	bsr.w	PrintTeamLogoAndScore
	bsr.w	printz
	String	CC_Font2Pri,8,2
	adda.w	#tmsize,a2				;tmsize
;CD: no cartridge twin
	moveq	#$2C,d0
	bsr.w	PrintTeamLogoAndScore
	bra.w	.ex
printscores1_ps						;Print the team name of team a2 at printx/printy, then its score as 2
									;digits at x $1C. Called twice from printscores1
	movea.l	tmdata(a2),a1			;tmdata
	adda.w	Teamname(a1),a1
	adda.w	(a1),a1					;skip the first string to the team name
	bsr.w	print
	move.w	#$1C,(printx).l			;score column
	move.w	tmscore(a2),d0			;tmscore
	moveq	#2,d1					;2 digits
	bsr.w	PushNumberWidth
	bra.w	print					;print the score and return
PrintTeamLogoAndScore				;Draw the team logo map (PutTeamBlock, d0 = offset) 5 columns left of
									;printx then the score of team a2 in big font, centered 2 rows lower; a 2
									;digit score is moved one more left.
									;Called twice from printscores1
	move.w	(printx).l,-(sp)
	subi.w	#5,(printx).l
	jsr	(PutTeamBlock).l
	move.w	(sp)+,(printx).l
	addi.w	#2,(printy).l
	move.w	tmscore(a2),d0			;tmscore
	cmpi.w	#$A,d0
	bge.w	.0
	bra.w	.1
.0									;d0 >= $A
	subi.w	#1,(printx).l
.1									;score position set
	bsr.w	PushNumber				;a1 = score string
	move.w	(a1),d0					;center on the old printx
	subi.w	#2,d0
	lsr.w	#1,d0
	sub.w	d0,(printx).l
	addi.w	#1,(printx).l
	bra.w	printbig
EASNLogo							;Draw the EASN logo map at x 1, y $19 on the vertical ice rink if no power
									;play. Called from printscores1 and updatepwrplay
	btst.b	#sf2pwrplay,(sflags2).l	;sf2pwrplay
	bne.w	rtss2
	bsr.w	printz
	String	CC_Font1Pri,1,$19
;CD: no cartridge twin
	movea.l	(EASportsMapPtr).l,a1
	adda.l	jimdata(a1),a1
	movea.l	#null,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2					;width and height from the map header
	move.w	mapheight(a1),d3
	move.w	(EASNcset).l,d4
	clr.w	d5
	bra.w	dobitmap
USBoard								;Update score board, including the players in the penalty box and their
									;time remaining. Called from InProgress and SetHor
	movem.l	d0-d7/a0-a3,-(sp)
	bset.b	#dfclock,(disflags).l	;dfclock
	bsr.w	printscores1
	bsr.w	printz
	String	CC_Font2Pri,$14,8
	movea.l	#$1834C,a2				;home team (CD: the cartridge has #(tmstruct-M68K_RAM))
	bsr.w	.dispen
	bsr.w	printz
	String	CC_Font2Pri,5,8
	movea.l	#$186B2,a2				;visitors (CD: the cartridge has #(awtmstruct-M68K_RAM))
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
	btst.b	#6,tmpdst(a2,d0.w)		;coincidental (tmpdst high byte bit 6)
	bne.w	.l1
	bsr.w	pplpen
	bra.w	.l1
.p2									;d0 negative
	lea	tmboxlist(a2),a0
.l2									;loop
	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	rtss2
	btst.b	#6,tmpdst(a2,d0.w)
	beq.w	.l2
	bsr.w	pplpen
	bra.w	.l2
pplpen								;print one penalty box line: player number and time remaining. a2 = team,
									;d0 = roster offset (player*2). Only
									;rows up to y $A are printed; printy += 1. Called from USBoard .dispen
	cmpi.w	#$A,(printy).l
	bhi.w	rtss2					;no room for more rows
	move.w	tmpdst(a2,d0.w),d2
	andi.w	#$7FF,d2				;penalty time
	movea.l	tmdata(a2),a1			;tmdata
	adda.w	0(a1),a1				;a1 = roster in the team data
	lsr.w	#1,d0					;d0 = player index
.find								;skip one roster entry
	adda.w	(a1),a1					;skip d0+1 roster entries (name string + 8 bytes)
;CD: no cartridge twin
	adda.w	#$8,a1
	dbf	d0,.find
	clr.w	d0
	move.b	pldnum-pldsize(a1),d0	;player number (BCD)
	move.w	(printx).l,-(sp)
	movea.l	#$17EF4,a1				;mesarea+2 (CD: the cartridge has #(TextBuffer-M68K_RAM))
	bsr.w	ConvertByteToDigits		;two digits to TextBuffer
	movea.l	#$17EF2,a1				;CD: the cartridge has #(mesarea-M68K_RAM)
	move.w	#4,(a1)					;string length: 2 digits
	bsr.w	print					;print the number
	move.w	d2,d0
	bsr.w	PushTime				;m:ss string
	bsr.w	print					;print the time next to it
	move.w	(sp)+,(printx).l
	addi.w	#1,(printy).l			;next row
	rts
linebar								;Draw the energy bar of line d0 for team a2 at printx/printy (bitmap from
									;the bar map, 16 steps). Called from SetLCmode2
	movem.l	d0-d5/a0-a2,-(sp)
	bsr.w	getlinee
	move.w	(printa).l,-(sp)
	move.w	#$8000,(printa).l		;priority attribute for the bar
	ext.l	d0
	divu.w	#$100,d0				;4096/16
	cmpi.w	#$F,d0
	bls.w	.ok
	moveq	#$F,d0					;clamp to 15
.ok									;d0 = energy step 0-15
	moveq	#$F,d1					;d1 = bar frame (15 = empty)
	sub.w	d0,d1					;d1 = bar frame (15 = empty)
	clr.w	d0
;CD: no cartridge twin
	movea.l	(EnergyBarMapPtr).l,a1
	adda.l	jimdata(a1),a1
	movea.l	#null,a2				;tile pointer null (as in SetHor)
	move.w	(a1),d2					;map width
	moveq	#1,d3					;1 row high
	move.w	(energybarchars).l,d4
	moveq	#0,d5
	bsr.w	dobitmap				;d1 = start row in the map = frame
	move.w	(sp)+,(printa).l
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
	move.b	(a0,d4.w),d5			;position
	beq.w	.next					;goalie energy doesn't count
	clr.w	d3
	move.b	(a1,d5.w),d3			;player number
	asl.w	#1,d3
	addi.w	#1,d1
;CD: no cartridge twin
	add.w	$32(a2,d3.w),d0
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
;CD: no cartridge twin
	movea.l	$22(a2),a0
.loop								;each sort object of the team
	tst.w	position(a0)			;position
	ble.w	.next
	clr.w	d3
	move.b	pnum(a0),d3				;pnum
	add.w	d3,d3
	add.w	tmpde(a2,d3.w),d0		;tmpde
	addi.w	#1,d1
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
	btst.b	#gmclock,(gmode).l		;gmclock: clock stopped
	bne.w	rtss2					;exit if so
	btst.b	#gmhl,(gmode).l			;gmhl: highlight
	bne.w	rtss2					;exit if so
	bclr.b	#sf2shot,(sflags2).l	;sf2shot: shot taken
	bne.w	.Cwdupdate				;it was set
	btst.b	#0,(sflags4).l
	beq.w	rtss2					;exit if cleared
	bclr.b	#3,(sflags8).l
	bne.w	.0
	bset.b	#3,(sflags8).l
	bra.w	rtss2
.0									;3 was set
	movem.l	d0-d1/a1-a3,-(sp)
	move.l	a4,-(sp)
	movea.l	#$180EC,a4				;ChkCnt. +ScoreSumbytes, then 2(a4) = the last ScoreSum entry (CD: the
									;cartridge has #ScoreSum-6)
	adda.w	(ScoreSumbytes).l,a4
	movea.l	#tmstruct,a2			;home team
	btst.b	#7,ssflags(a4)			;entry flag: visitors
	beq.w	.pllookup
	adda.w	#tmsize,a2				;tmsize
.pllookup							;team of the scorer chosen
	clr.w	d0
	move.b	ssscorer(a4),d0			;pnum (roster offset)
	movea.l	(sp)+,a4
;CD: no cartridge twin
	movea.l	$22(a2),a2
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
	addi.w	#$64,(Crowdlevel).l		;100
	addi.w	#$A,(CwdExciteLvl).l
	move.w	(shotplayer).l,d0
.addShot							;credit the shot to player d0
	asl.w	#scsize,d0				;scsize
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
	adda.w	d0,a3
	bsr.w	loadTeamStruct
	addi.w	#1,0(a2)				;tmshots
	btst.b	#sf2pwrplay,(sflags2).l	;sf2pwrplay
	beq.w	.2
	btst.b	#sf2pwrtm,(sflags2).l	;sf2pwrtm: 0 home, 1 visitors
	bne.w	.1
	btst.b	#pfteam,pflags(a3)		;pfteam
	bne.w	.2						;not the team on the power play
.PPshot								;loop
	addi.w	#1,tmPPShots(a2)		;power play shots
	bra.w	.2
.1									;sf2pwrtm set
	btst.b	#pfteam,pflags(a3)		;pfteam
	bne.w	.PPshot
.2									;not a power play shot
	move.l	a2,-(sp)
	move.w	(gsp).l,d0				;period
	add.w	d0,d0
	adda.w	d0,a2
	addi.w	#1,tmPerShots(a2)		;shots by period
	movea.l	(sp)+,a2
	clr.w	d0
	move.b	pnum(a3),d0				;pnum
	addi.w	#tmpshots,d0
	addi.b	#1,(a2,d0.w)			;shooter's shot count
	move.w	tmgoalie(a1),d0			;other team's tmgoalie
	bmi.w	.ex						;empty net
	addi.w	#tmpshots,d0
	addi.b	#1,(a1,d0.w)			;goalie's shots against
.ex									;exit: restore the registers
	movem.l	(sp)+,d0-d1/a1-a3
	rts
loadTeamStruct						;return a2 = team struct of player a3, a1 = the other team's struct.
									;Called from ChkShotStat and updateplayers
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	lea	tmsize(a2),a1				;tmsize
	btst.b	#pfteam,pflags(a3)		;pfteam
	beq.w	rtss2
	exg	a1,a2
	rts
SetupTeamForIntermission			;Reset the bench, then for each team refill energy and pick the starting
									;line: power play 1 (3) for the team with more players on ice, PK1 (5) for
									;the team with fewer, else 0. Called from Intermission
	bsr.w	ResetBench
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	lea	tmsize(a2),a3
	bsr.w	.r
	exg	a2,a3						;falls in for the other team
.r									;refill this team
	bsr.w	reenergizeteam			;refill energy for this team
	clr.w	tmline(a3)				;tmline
	tst.w	(OptLine).l
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
	subi.w	#2,d0
	bpl.w	.loop
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
	subi.w	#2,d0
	bpl.w	.loop
	rts
Intermission						;end of period junk (zamboni/stats). Opens the pause menu screen (item
									;list by period, +5 in playoffs), shows the ticker scores of the other
									;games, then the highlights; Start on either pad cuts it short. When gsp
									;is 4 the clock is cleared and UpdateRecords runs first, and gmode2 bit 0
									;picks the ShootoutIntermissionMenu item list.
									;Called from PeriodOver
	cmpi.w	#4,(gsp).l
	bne.w	.1
	move.w	#0,(gameclock).l
	jsr	(UpdateRecords).l
.1									;records updated after the last period
	bsr.w	SetupTeamForIntermission
	moveq	#$F,d0
	movea.l	#$17480,a0				;CD: the cartridge has #(SortCords-M68K_RAM)
.clr								;clear the Xpos of each sort object
	clr.w	0(a0)					;Xpos
	adda.w	#SCstruct,a0			;SCstruct
	dbf	d0,.clr
	move.w	(ExtraChars).l,d4
;CD: no cartridge twin
	movea.l	(ZamSpritesPtr).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	move.w	#$140,(Zamx).l			;320
	move.w	(gsp).l,d0
	tst.w	(OptPlayMode).l
	beq.w	.ss
	addi.w	#5,d0					;playoffs
.ss									;period index (+5 in the playoffs)
	asl.w	#2,d0
	lea	.sslist(pc),a0
	movea.l	(a0,d0.w),a0
	btst.b	#0,(gmode2).l
	beq.w	.2
	movea.l	#ShootoutIntermissionMenu,a0
.2									;menu chosen (shootout menu in a shootout)
	bset.b	#sfpz,(sflags).l		;sfpz
	movea.l	#Pausemode_pall,a1
	jsr	(Pausemode_top).l
	bsr.w	GetShifter				;d1 = highest game index
	move.w	d1,(TickerNum).l		;ticker starts from the last game
;CD: no cartridge twin
	bset.b	#$5,$FF800F.l
.top								;loop
	tst.w	(TickerNum).l			;one ticker game per pass
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
	beq.w	.top
.clrh								;start pressed: show the highlights
	bset.b	#sf3sbut,(sflags3).l	;sf3sbut
.doh								;show the highlights
	bsr.w	DoHiLights				;show the requested highlights
	bclr.b	#sf3sbut,(sflags3).l
	bne.w	.clrz					;start pressed (flag set by .clrh or by a highlight): leave
.wait								;loop
	move.w	#$1E0,d0				;480 frames
	bsr.w	waitxsr
	btst	#7,d1
	bne.w	.clrz
	tst.w	(cont1team).l
	bne.w	.wait					;keep waiting while a pad is on a team
	tst.w	(cont2team).l
	bne.w	.wait
.clrz								;no pad on a team: leave
	st.b	(Zamx).l				;zamboni off
	rts
.sslist								;menu item lists by period, then playoff period
	dc.l	StartGameText,IntermissionText,IntermissionText,IntermissionText,ExitGameText
	dc.l	StartGameTextPO,IntermissionText,IntermissionText,IntermissionText,ExitGameTextPO
InitScores							;initialize other games scores/period in playoffs. Called from StartGame
	cmpi.w	#1,(gamelevel).l
	bgt.w	rtss2
	bsr.w	GetShifter
	movea.l	#(gstruct-M68K_RAM),a0
	moveq	#gssize,d0				;gssize
	mulu.w	d1,d0
	adda.w	d0,a0					;a0 = gstruct of game d1, counting down
.top								;each game
	cmp.w	(gamenum).l,d1			;per game
	beq.w	.next					;not the game being played
	btst.b	#gsfso,gsflags(a0)		;gsfso
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
	move.w	d1,(TickerNum).l		;restart the ticker
	movea.l	#(gstruct-M68K_RAM),a0
	moveq	#gssize,d0				;gssize
	mulu.w	d1,d0
	adda.w	d0,a0					;a0 = gstruct of game d1, counting down
.top								;each game
	cmp.w	(gamenum).l,d1			;per game
	beq.w	.next					;not the game being played
	bclr.b	#gsfhl,gsflags(a0)		;gsfhl
	btst.b	#gsfso,gsflags(a0)		;gsfso
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
	cmpi.w	#1,d0
	bgt.w	.ex
	cmpi.w	#$FFFF,d0
	blt.w	.ex
	move.w	#3,gsper(a0)			;close game: overtime
	bset.b	#gsfhl,gsflags(a0)		;gsfhl
	bra.w	.ex
.o									;not the last period: next period
	addi.w	#1,gsper(a0)
	move.w	0(a0),d0				;gst1
	move.w	gst2(a0),d1				;gst2
	bsr.w	.getscore
	add.w	d0,gss1(a0)				;gss1
	move.w	gst2(a0),d0
	move.w	0(a0),d1
	bsr.w	.getscore				;goals for team 2
	add.w	d0,gss2(a0)				;gss2
.ex									;exit: restore the registers
	movem.l	(sp)+,d0-d1/a0-a1
	rts
.getscore							;d0 = scoring team, d1 = other team. Adds the scoring team's (bits 4-6)
									;and the other team's (bits 0-2) sctab rows as weights. Return d0 = goals
									;0-3
	asl.w	#2,d0
	movea.l	#TeamList,a1
	movea.l	(a1,d0.w),a1
	adda.w	ScoutReport(a1),a1
	move.b	(a1),d0
	andi.w	#$70,d0
	lsr.w	#1,d0					;row * 8
	lea	sctab(pc),a1
	move.l	(a1,d0.w),$18BE8.l		;CD: the cartridge has (nibblebuffer).w
	move.l	$4(a1,d0.w),$18BEC.l	;CD: the cartridge has (nibblebuffer+4).w
	asl.w	#2,d1
	movea.l	#TeamList,a1
	movea.l	(a1,d1.w),a1
	adda.w	ScoutReport(a1),a1
	move.b	(a1),d0
	andi.w	#7,d0
	asl.w	#3,d0
	lea	sctab(pc),a1
	move.l	(a1,d0.w),d1
	add.l	d1,$18BE8.l				;CD: the cartridge has (nibblebuffer).w
	move.l	$4(a1,d0.w),d1
	add.l	d1,$18BEC.l				;CD: the cartridge has (nibblebuffer+4).w
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
	cmpi.w	#$1E0,(gameclock).l		;480
	bgt.w	rtss2
NewTicker2							;goto next ticker. Return d3 = game, or neg if none left. Falls into
									;NewTicker3
	move.w	(TickerNum).l,d3
	bmi.w	rtss2
	subi.w	#1,(TickerNum).l
	cmp.w	(gamenum).l,d3			;don't show current game as ticker
	beq.w	NewTicker2
CheckGameTickerStatus				;d3 = game. Return a0 = its gstruct; skip to the next ticker game if a
									;highlight is coming up or the series is over. Called from StartHL2
	moveq	#gssize,d0				;gssize
	mulu.w	d3,d0
	movea.l	#(gstruct-M68K_RAM),a0
	adda.w	d0,a0
	btst.b	#gsfhl,gsflags(a0)		;gsfhl
	bne.w	NewTicker2				;don't show if hilite coming up
	btst.b	#gsfso,gsflags(a0)		;gsfso
	bne.w	NewTicker2				;don't show if the series is over for this game
	rts
NewTicker3							;Display ticker score for game d3 (a0 = gstruct entry), skip if d3 is
									;negative. Called from chkprogress, Intermission and StartHL2
	tst.w	d3
	bmi.w	rtss2
	bsr.w	SetTickerAreaPosition	;d0/d1 = box size
	bsr.w	Framer					;draw the ticker box
	addi.w	#1,(printx).l			;inside the frame, top row
	subi.w	#4,(printy).l
	move.w	(printx).l,-(sp)		;box x: .tn reads it at 4(sp), above its return address
	bsr.w	GetShifter
	move.w	#$A000,(printa).l
	bsr.w	printz
	String	'                        '	;24 spaces
	move.w	(sp),(printx).l
	moveq	#1,d0
	add.w	(gamelevel).l,d0		;playoffs: label 1 + round
	tst.w	(OptPlayMode).l
	bne.w	.0
	clr.w	d0						;not playoffs: 'EA Hockey Night'
.0									;ticker title index chosen
	lea	GameLabels(pc),a1			;a1 = ticker title list
	bsr.w	Fprintsmall				;print the ticker title
	move.w	gsper(a0),d0			;gsper
	subi.w	#1,d0
	movea.l	#PerLabels,a1
	bsr.w	AdvanceStringPtr
	move.w	(a1),d0					;period name centered on x+$17
	lsr.w	#1,d0
	neg.w	d0
	add.w	(sp),d0
	addi.w	#$17,d0
	move.w	d0,(printx).l
	bsr.w	print
	move.w	#$8000,(printa).l
	move.w	gst2(a0),d0				;gst2
	move.w	gss2(a0),d1				;gss2
	bsr.w	.tn						;team 2 on the first row
	move.w	0(a0),d0				;gst1
	move.w	gss1(a0),d1				;gss1
	bsr.w	.tn						;team 1 on the second row
;CD: no cartridge twin
	adda.w	#$2,sp
	rts
.tn									;print team d0 name and score d1 on the next row
	move.w	4(sp),(printx).l		;print team d0 name and score d1 on the next row
	addi.w	#1,(printy).l
	movea.l	#TeamList,a1			;team address table
	asl.w	#2,d0
	movea.l	(a1,d0.w),a1
	adda.w	Teamname(a1),a1			;team name
	bsr.w	print
	move.w	4(sp),(printx).l
	addi.w	#$15,(printx).l			;92 23
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
	btst.b	#sfpz,(sflags).l		;sfpz
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
	movea.l	#(gstruct-M68K_RAM),a0
	adda.w	d3,a0
.top								;each game
	btst.b	#gsfso,gsflags(a0)		;gsfso
	bne.w	.next					;series over
	bclr.b	#gsfhl,gsflags(a0)		;gsfhl
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
	btst.b	#sf3sbut,(sflags3).l	;sf3sbut
	bne.w	.nhl0					;start already pressed: just pick a random result
	bsr.w	.sv						;save the real game state (gmode ... ScoreSumbytes)
	move.w	d1,d3
	bsr.w	CheckGameTickerStatus
	bsr.w	NewTicker3				;show score from hilight game
	btst.b	#sf3sbut,(sflags3).l
	bne.w	.nhl1
	move.w	#4,(printx).l			;"Highlight from game:" box, 24x3 above the ticker
	subi.w	#6,(printy).l
	moveq	#$18,d0					;24
	moveq	#3,d1
	bsr.w	Framer
	addi.w	#1,(printx).l
	subi.w	#2,(printy).l
	bsr.w	printz
	String	'Highlight from game:'	;the text as code
	move.w	#$B4,d0					;180 frames
	bsr.w	waitxsr
	btst	#sbut,d1				;Start?
	bne.w	.nhl1					;start: skip the highlight
	st.b	(Zamx).l				;zamboni off
	clr.w	(CwdExciteLvl).l
	move.w	0(a0),(HomeTeam).l		;set up teams for game in a0
	move.w	2(a0),(VisTeam).l
	move.l	a0,-(sp)				;keep the gstruct pointer
	clr.w	(tmstruct+tmgoalie).l
	clr.w	(awtmstruct+tmgoalie).l
	jsr	(clearTeamStats).l
	jsr	(restoreteams).l			;load both teams' data
	st.b	(c1playernum).l			;no human players
	st.b	(c2playernum).l
	clr.w	(cont1team).l
	clr.w	(cont2team).l
	moveq	#$78,d0					;120
	bsr.w	randomd0
	addi.w	#$3C,d0					;60
	move.w	d0,(gameclock).l		;random clock, 60 + 0-119
	movea.l	(sp),a0
	move.w	gsper(a0),(gsp).l		;gsper
	subi.w	#1,(gsp).l
	move.w	gss1(a0),(HmGoals).l	;gss1
	move.w	gss2(a0),(AwGoals).l	;gss2
	move.b	#$10,(gmode).l			;1<<gmhl
	btst.b	#0,(gsp+1).l			;odd period: gmdir set (home team goes the other way)
	beq.w	.ndi
	bset.b	#gmdir,(gmode).l		;gmdir
.ndi								;direction set for the period
	clr.b	(sflags).l				;fresh state flags for the highlight
	move.b	#4,(sflags2).l			;1<<sf2drec
	clr.b	(sflags3).l
	bclr.b	#dffaceoff,(disflags).l
	bset.b	#dfclock,(disflags).l	;dfclock
	clr.w	(glovecords).l
	clr.b	(iflags).l
	st.b	(RefCnt).l
	st.b	(puckcross2).l
	st.b	(puckcross6).l
	jsr	(p_turnoff).l
	bsr.w	setupice_highlight
;CD: no cartridge twin
	move.w	#$1,$17468.l
	bsr.w	ClrHor
	move.w	#$0,$17468.l
	movea.l	#$C00000,a0
.L3D082
	btst.b	#$7,$FF800E.l
	bne.s	.L3D082
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3D0A4
	btst.b	#$6,$FF800E.l
	beq.s	.L3D0A4
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3D0BE
	btst.b	#$6,$FF800E.l
	bne.s	.L3D0BE
	bclr.b	#$7,$FF800F.l
.L3D0D0
	btst.b	#$7,$FF800E.l
	bne.s	.L3D0D0
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3D0F2
	btst.b	#$6,$FF800E.l
	beq.s	.L3D0F2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3D10C
	btst.b	#$6,$FF800E.l
	bne.s	.L3D10C
	bclr.b	#$7,$FF800F.l
	move.w	(ExtraChars).l,d4
	movea.l	(RefsMapPtr).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	clr.w	(Vpos).l
	clr.w	(Hpos).l
	bsr.w	ResetBench
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	bsr.w	.setteam
	adda.w	#tmsize,a2				;tmsize
	bsr.w	.setteam
	bsr.w	resetplstuff
	moveq	#$B,d0					;12 players: put each on his face off spot
	movea.l	#.postab,a0
	movea.l	#$17480,a1				;CD: the cartridge has #(SortCords-M68K_RAM)
.loop								;put each player on his face off spot
	move.w	position(a1),d1			;position
	btst.b	#pfgoal,pflags(a1)		;pfgoal
	bne.w	.pl0
	addi.w	#6,d1
.pl0								;spot for his end of the ice
	asl.w	#2,d1
	move.w	(a0,d1.w),0(a1)			;Xpos
	move.w	$2(a0,d1.w),Ypos(a1)	;Ypos
	clr.w	Xvel(a1)				;Xvel
	clr.w	Yvel(a1)				;Yvel
	adda.w	#SCstruct,a1
	dbf	d0,.loop
	bsr.w	SprSort
	move.w	#$18,(palcount).l		;24
	move.w	(Vcount).l,(OldVcount).l
	move.w	#$B4,-(sp)				;180 frames after the clock stops
.0									;loop
	jsr	(DoGameFrame).l
	btst.b	#gmclock,(gmode).l		;gmclock
	beq.w	.1						;clock running
	subi.w	#1,(sp)
	bmi.w	.endhl					;clock stopped for 180 frames: highlight over
.1									;clock running, or stopped less than 180 frames
	bsr.w	orjoy
	btst	#cbut,d1				;C?
	bne.w	.2
	btst	#sbut,d1				;Start?
	beq.w	.0
.2									;C or start: end the highlight now
	move.w	(HmGoals).l,d0			;tied: random winner
	cmp.w	(AwGoals).l,d0
	bne.w	.endhl
;CD: no cartridge twin
.L3D1EC
	btst.b	#$7,$FF800E.l
	bne.s	.L3D1EC
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3D206
	btst.b	#$6,$FF800E.l
	beq.s	.L3D206
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3D226
	btst.b	#$6,$FF800E.l
	bne.s	.L3D226
	bclr.b	#$7,$FF800F.l
	andi.w	#1,d0
	add.w	d0,(HmGoals).l
	eori.w	#1,d0
	add.w	d0,(AwGoals).l
;CD: no cartridge twin
.endhl								;CD: placed where the disc branches to it
	adda.w	#$2,sp
	movea.l	(sp)+,a0				;a0 = gstruct
	movem.l	d1/a0,-(sp)
	jsr	(KillCrowd).l
	jsr	(p_turnoff).l
	movem.l	(sp)+,d1/a0
	move.w	(HmGoals).l,gss1(a0)	;gss1
	move.w	(AwGoals).l,gss2(a0)	;gss2
	bsr.w	forceblack
	moveq	#$F,d0					;clear Xpos of the 16 sort objects
	movea.l	#$17480,a0				;CD: the cartridge has #(SortCords-M68K_RAM)
.clr								;clear the Xpos of each sort object
	clr.w	0(a0)					;Xpos
	adda.w	#SCstruct,a0
	dbf	d0,.clr
	bsr.w	.lo						;restore the saved game state
	bsr.w	setplayercolors
	bsr.w	SetHor					;back to the intermission screen
	bsr.w	setvideo
	jsr	(Pausemode_pall).l			;pause menu screen
	jsr	(DrawMenuScreen).l
	move.w	#$18,(palcount).l		;24
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
	bset.b	#sf3sbut,(sflags3).l	;sf3sbut
.exit								;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.nhl1								;sf3sbut set or sbut set
	bsr.w	.lo						;start pressed after .sv: restore the state, random result
	bsr.w	.ranres
	bra.w	.exit2
.nhl0								;sf3sbut set
	bsr.w	.ranres
	bra.w	.exit
.setteam							;refill energy, set personnel; also clears sflags8 bit 7
	jsr	(reenergizeteam).l			;refill energy and set tmtouch1/2/3(a2) per team (a2 = team)
	bsr.w	setpersonel
	bsr.w	forcepldata
	st.b	tmtouch1(a2)
	bclr.b	#7,(sflags8).l
	st.b	tmtouch2(a2)
	st.b	tmtouch3(a2)
	rts
.ranres								;random resolve of game (if tied = random score)
	move.w	gss1(a0),d0				;random resolve of game (if tied = random score)
	cmp.w	gss2(a0),d0
	bne.w	.rr0
;CD: no cartridge twin
.L3D356
	btst.b	#$7,$FF800E.l
	bne.s	.L3D356
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3D370
	btst.b	#$6,$FF800E.l
	beq.s	.L3D370
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3D390
	btst.b	#$6,$FF800E.l
	bne.s	.L3D390
	bclr.b	#$7,$FF800F.l
	andi.w	#1,d0
	add.w	d0,gss1(a0)
	eori.w	#1,d0
	add.w	d0,gss2(a0)
.rr0								;result set: game final
	move.w	#5,gsper(a0)			;gsper: final
	rts
.sv									;save $5BE words from gmode to M68K_RAM, then ScoreSumbytes
	move.w	#$557,d0				;CD: the cartridge has #$5BD
	movea.l	#$17F68,a1				;CD: the cartridge has #(gmode-M68K_RAM)
	movea.l	#$C45C,a2				;CD: the cartridge has #M68K_RAM
.sv1								;copy each word
	move.w	(a1)+,(a2)+				;copy words from gmode to ReplayStart
	dbf	d0,.sv1
	move.w	(ScoreSumbytes).l,(a2)+	;also save ScoreSumbytes
	rts
.lo									;restore what .sv saved
	move.w	#$557,d0				;CD: the cartridge has #$5BD
	movea.l	#$17F68,a2				;CD: the cartridge has #(gmode-M68K_RAM)
	movea.l	#$C45C,a1				;CD: the cartridge has #M68K_RAM
.lo1								;copy each word back
	move.w	(a1)+,(a2)+				;copy the saved words back
	dbf	d0,.lo1
	move.w	(a1)+,(ScoreSumbytes).l
	rts
.postab								;Xpos,Ypos by position (goalie, l.def, r.def, l.wing, center, r.wing),
									;pfgoal set, then clear
	dc.w	0,-240,-70,-140,20,-110,-100,-60,25,-40,70,-80
	dc.w	0,240,34,90,-55,80,100,40,-10,10,-50,0
