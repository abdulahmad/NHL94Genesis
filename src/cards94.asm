;	New in 94: player cards and saved records. This file times and draws the player cards on the
;	game setup screen, loads team colors and featured player pictures, and keeps the team, player,
;	crowd and user records in save RAM. Print strings follow the calls that print them.

ResetCardTimer						;Reset the player card timer cardtimer to $AA ($53 if C was pressed).
									;Called from ReadSetupPads, PrintOptions and PlayerCardTimer
	move.w	#$AA,(cardtimer).w		;normal wait
	btst	#5,(setupcardflags).w	;C held (bit 5): use the shorter wait
	beq.w	.x
	move.w	#$53,(cardtimer).w		;shorter wait
.x									;exit (also the end of the code above)
	rts								;return
PlayerCardTimer						;Player cards, called each frame from ReadSetupPads in the first minute of
									;its wait. When carddelay runs out set setupcardflags bit 0; then count
									;cardtimer down (C skips $50); at $52 switch sides (bit 1), forget the
									;logos and draw the next card (PlayerCardScreen); below 0 restart the
									;timer (ResetCardTimer)
	subq.w	#1,(carddelay).w		;count down the start delay
	bpl.w	.x						;not yet
	move.w	#$FFFF,(carddelay).w	;keep it run out
	bset	#0,(setupcardflags).w	;first run out: the cards may start
	btst	#0,(setupcardflags).w	;cards allowed?
	beq.w	.x
	btst	#5,(setupcardflags).w	;C held?
	beq.w	.0
	cmpi.w	#$52,(cardtimer).w		;timer below $52?
	bge.w	.0
	subi.w	#$50,(cardtimer).w		;skip $50 of the wait
.0									;C held and the timer still above $52, or no C: count down normally
	subq.w	#1,(cardtimer).w
	bmi.w	.1						;timer ran out: start the next cycle
	cmpi.w	#$52,(cardtimer).w
	bne.w	.x						;only at $52 is a new card drawn
	bclr	#2,(setupcardflags).w	;clear setupcardflags bits 2 and 3
	bclr	#3,(setupcardflags).w
	bchg	#1,(setupcardflags).w	;the next card goes on the other side
	st	(setuphome).w				;force the logo boxes to be redrawn later
	st	(setupvis).w
	bclr	#6,(setupcardflags).w	;clear setupcardflags bits 6 and 7
	bclr	#7,(setupcardflags).w
	jsr	(PlayerCardScreen).l		;draw the card
.x									;exit (also the end of the code above)
	rts
.1									;cardtimer negative
	jmp	ResetCardTimer
PlayerCardScreen					;Draw a player card on one side. setupcardflags bit 1 set: visitors, logo
									;box and picture on the left (column 3), text frame at $B; clear: home,
									;logo box and picture on the right ($1C), text frame at 3. Shows featured
									;player featuredplayer (0-5, from the FeaturedPictures list of the team;
									;next one after each visitors card), his number and name, and with SRAM
									;his user records (PrintRecordValue, PrintRecordHolder, PrintRecordVs).
									;Called from PlayerCardTimer
	movem.l	d0-d7/a0-a6,-(sp)		;the whole card is drawn here, keep all registers
	jsr	(printz).l					;map 1
	String	-TXMAP1,0,0				;x3
	move.w	#$1C,(printx).w			;visitors: erase the other logo box at $1C
	btst	#1,(setupcardflags).w	;which side?
	bne.w	.0
	move.w	#3,(printx).w			;home: erase the one at 3
.0									;column chosen
	move.w	#5,(printy).w			;row 5
	move.w	#8,d0					;clear the 8 x 8 logo area
	move.w	#8,d1
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l					;erase it
	jsr	(printz).l					;map 1
	String	-TXMAP1,0,0				;x3
	move.w	#3,(printx).w			;column 3
	btst	#1,(setupcardflags).w
	bne.w	.1
	move.w	#$B,(printx).w			;column $B
.1									;visitors card: block at column 3, home at $B
	move.w	#5,(printy).w			;row 5
	move.w	#$19,d0					;clear the 25 x 8 card area
	move.w	#8,d1
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l					;erase it
	btst	#1,(setupcardflags).w	;which side?
	bne.w	.2
	bsr.w	LogoBoxRight			;home logo box
	bra.w	.3						;card next
.2									;bit 1 of setupcardflags set
	bsr.w	LogoBoxLeft
	addq.w	#1,(featuredplayer).w	;each visitors card moves to the next featured player
.3									;both sides: wrap featuredplayer after the sixth picture
	jsr	(printz).l
	String	-TXMAP1,0,0				;x3 / add.b
	cmpi.w	#6,(featuredplayer).l
	blt.w	.4
	clr.w	(featuredplayer).w		;back to the first picture
.4									;featuredplayer still 0-5: keep it
	move.w	(HomeTeam).w,d0
	move.w	#$1D,(printx).w
	btst	#1,(setupcardflags).w	;which side?
	beq.w	.5
	move.w	(VisTeam).w,d0
	move.w	#4,(printx).w
.5									;home card: home team and column $1D; visitors: VisTeam and column 4
	move.w	#6,(printy).w			;row 6
	move.w	(homepicchars).w,d4		;first picture char
	move.w	(featuredplayer).w,d3	;featured player number
	mulu.w	#6,d3					;6 bytes per entry: picture.l + roster index.w
	asl.w	#2,d0					;team number * 4 to index the list of team lists
	movea.l	#FeaturedPictures,a0	;pictures of each team: picture.l, roster index.w entries
	movea.l	0(a0,d0.w),a0			;this team's list
	move.w	4(a0,d3.w),(cardroster).w	;roster index
	movea.l	0(a0,d3.w),a0			;the picture
	movea.l	a0,a1					;a1 = picture header
	movea.l	a0,a2					;a2 = offsets
	adda.l	(a2)+,a0				;a0 = the picture's tile data
	movea.l	#PicturePalette,a0		;palette from PicturePalette
	adda.l	(a0),a0
	tst.l	(a2)					;no map: the PicturePalette one
	bne.w	.6
	movea.l	#PicturePalette,a1		;default map
	adda.l	jimdata(a1),a1			;its map data
	tst.l	(a2)+					;skip the map offset
	bra.w	.7
.6									;picture has its own map: use it
	adda.l	(a2)+,a1
.7									;both: unpack the tiles, map and palette into picturebuf
	bsr.w	UnpackPicture
	movea.l	#picturebuf,a2			;tiles
	move.w	(Vcount).w,d3			;current frame
.loop								;wait for the next vblank before drawing
	cmp.w	(Vcount).w,d3
	beq.s	.loop
	move.w	#6,d3					;height 6
	move.w	#6,d2					;width 6
	clr.w	d0						;x 0
	clr.w	d1						;y 0
	move.l	(palfadenew+$22).w,-(sp)	;keep palette colors $22-$29: dobitmap overwrites them
	move.l	(palfadenew+$26).w,-(sp)
	move.w	#2,d5					;palette 2
	jsr	(dobitmap).l				;draw the picture
	move.l	(sp)+,(palfadenew+$26).w	;restore the colors
	move.l	(sp)+,(palfadenew+$22).w
	jsr	(printz).l					;map 1 (priority)
	String	-(TXPRI+TXMAP1),0,0		;(the routine here)
	move.w	#$6000,(printa).w		;palette 3
	move.w	#3,(printx).w			;column 3
	move.w	#$19,d0					;width $19
	btst	#1,(setupcardflags).w	;which side?
	beq.w	.8
	move.w	#$B,(printx).w
	move.w	#$19,d0
.8									;visitors frame at column $B, home at 3
	move.w	#5,(printy).w
	move.w	#8,d1					;height 8
	move.w	(printx).w,(cardprintx).w	;text inside the frame starts one in and one down
	addq.w	#1,(cardprintx).w
	move.w	(printy).w,(cardprinty).w
	addq.w	#1,(cardprinty).w
	jsr	(Framer).l					;25 x 8 box
	move.w	(cardprintx).w,(printx).w	;text inside the frame
	move.w	(cardprinty).w,(printy).w
	move.w	#0,(printa).w			;palette 0
	move.w	#0,(printm).w			;print mode 0
	move.w	(HomeTeam).w,d0			;home team
	btst	#1,(setupcardflags).w	;which side?
	beq.w	.9
	move.w	(VisTeam).w,d0			;visitors
.9									;home card: home team, else the visitors
	move.w	d0,(cardteamnum).w
	movea.l	#TeamList,a2			;team address table
	asl.w	#2,d0					;long index
	movea.l	0(a2,d0.w),a2			;team data
	adda.w	(a2),a2					;a2 = first player record of the team
	move.w	(cardroster).w,d0		;skip cardroster players to reach the featured one
	bra.w	.10						;skip d0 players
.loop2								;skip one player record: name length + fixed part
	adda.w	(a2),a2
	addq.w	#pldsize,a2
.10									;loop until the featured player is reached
	dbf	d0,.loop2
	movea.l	#mesarea,a3				;string buffer
	lea	2(a3),a1					;text after the header
	move.w	#6,(a3)					;string header: 6 = print mode
	move.l	a2,-(sp)				;keep the player record
	adda.w	(a2),a2					;skip the name
	move.b	(a2),d0					;uniform number
	ext.w	d0						;word
	jsr	(ConvertByteToDigits).l		;uniform number as digits
	move.w	#$2000,4(a3)
	movea.l	(sp)+,a1				;player name
	jsr	(appstring).l				;then a space and the name
	movea.l	a3,a1
	bset	#3,(sflags6).w			;bit 3 of sflags6: printsmall uses the card font
	jsr	(printsmall).l				;print the number and name
	bclr	#3,(sflags6).w			;normal font
	movea.l	#mesarea,a1				;string buffer
	move.w	(cardteamnum).w,d0		;team
	move.w	(cardroster).w,d1		;roster index
	tst.w	(ValidSRAM).w			;no SRAM: no records
	bmi.w	.fade					;no SRAM
	jsr	(PrintRecordValue).l		;record value string
	cmpi.w	#2,(a1)					;PrintRecordValue left an empty string: no records to show
	beq.w	.fade
	move.w	(cardprintx).w,(printx).w	;left edge of the text
	addq.w	#2,(printy).w			;two rows down
	bset	#3,(sflags6).w			;card font
	jsr	(printsmall).l				;print it
	bclr	#3,(sflags6).w			;normal font
	movea.l	#mesarea,a1				;string buffer
	move.w	(cardteamnum).w,d0		;team
	move.w	(cardroster).w,d1		;roster index
	movea.l	#M68K_RAM,a0			;RAM base
	jsr	(PrintRecordHolder).l		;record holder string
	move.w	(cardprintx).w,(printx).w
	cmpi.w	#2,(a1)					;no record holder: skip the line
	beq.w	.11						;none
	addq.w	#1,(printy).w			;next row
	bset	#3,(sflags6).w			;card font
	jsr	(printsmall).l				;print it
	bclr	#3,(sflags6).w			;normal font
.11									;records holder printed, or none: the vs line next
	movea.l	#mesarea,a1				;string buffer
	move.w	(cardteamnum).w,d0		;team
	move.w	(cardroster).w,d1		;roster index
	movea.l	#M68K_RAM,a0			;RAM base
	jsr	(PrintRecordVs).l			;record vs string
	move.w	(cardprintx).w,(printx).w	;left edge of the text
	addq.w	#1,(printy).w			;next row
	bset	#3,(sflags6).w			;card font
	jsr	(printsmall).l				;print it
	bclr	#3,(sflags6).w			;normal font
.fade								;all lines printed (or no SRAM / no records): fade the card in
	move.w	#$64,(palcount).w		;fade the palette in over $64 frames
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return

wallcollduringcheck					;during a check, a skater a2 (not a goalie) near the wall: test the wall
									;at his position with his size + $17. Called from CCStart
	tst.w	position(a2)			;goalies have no wall check during a hit
	beq.w	.end
	movem.l	d0-d7,-(sp)				;save
	move.w	(a2),d2					;Xpos of checking player
	move.w	Ypos(a2),d3				;Ypos of checking player
	move.w	radiusx(a2),(wcradiusx).w	;make the test box $17 bigger than the skater
	addi.w	#$17,(wcradiusx).l		;add $17 to wcradiusx
	move.w	radiusy(a2),(wcradiusy).w	;radiusy into wcradiusy (height of graphic)
	addi.w	#$17,(wcradiusy).l		;add $17 to wcradiusy
	movem.l	a0-a6,-(sp)				;save
	exg	a2,a3						;checkcornercoll tests the object in a3
	jsr	(checkcornercoll).l
	exg	a2,a3						;swap a2 and a3
	movem.l	(sp)+,a0-a6
	movem.l	(sp)+,d0-d7
.end								;exit (also the end of the code above)
	rts
setSlotBit							;Sflags6 bit 5 (the slot) = the puck carrier is in the slot in front of
									;the goal. Called from DoGameFrame
	bclr	#5,(sflags6).w			;clears Slot Bit
	tst.w	(puckc).w
	bmi.w	.ex						;exit if no puckc
	movem.l	d0/a0,-(sp)
	movea.l	#SortCords,a0			;start of SCStructs
	move.w	(puckc).w,d0			;move puckc SCnum into d0
	asl.w	#7,d0					;mult by 128 decimal
	adda.w	d0,a0					;move to start of puckc SCstruct
	move.w	Ypos(a0),d0				;Ypos
	btst	#pfgoal,pflags(a0)		;pfgoal - which goal shooting at
	bne.w	.checkpos				;jump if top goal
	neg.w	d0						;negative d0
.checkpos							;carrier shooting at the top goal, or Ypos flipped for the bottom one
	cmp.w	#Blueline,d0			;only in the attacking zone (past the blue line)
	blt.w	.restore				;branch if not in off zone
	cmpi.w	#$47,(a0)				;and within $47 of the middle across the ice
	bgt.w	.restore				;branch if greater than 47
	cmpi.w	#$FFB9,(a0)				;compare X position to -$47
	blt.w	.restore				;branch if less than -47
	bset	#5,(sflags6).w			;set bit
.restore							;pop the d0/a0 saved above
	movem.l	(sp)+,d0/a0
.ex									;exit (also the end of the code above)
	rts
TeamPalettes						;Matchup and player card palettes: 56 of 16 colors, two per team (28
									;teams, TeamList order). A is the matchup logo palette (the
									;TeamLogoPalettes
									;entry, except BOS, FLA, HFD, SJ), B the other side (A with colors 1-2 and
									;3-4 swapped). Used by DrawMatchupBitmaps and the player cards
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalANHA.pal	;ANH matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalANHB.pal	;ANH other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalBOSA.pal	;BOS matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalBOSB.pal	;BOS other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalBUFA.pal	;BUF matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalBUFB.pal	;BUF other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalCGYA.pal	;CGY matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalCGYB.pal	;CGY other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalCHIA.pal	;CHI matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalCHIB.pal	;CHI other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalDALA.pal	;DAL matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalDALB.pal	;DAL other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalDETA.pal	;DET matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalDETB.pal	;DET other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalEDMA.pal	;EDM matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalEDMB.pal	;EDM other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalFLAA.pal	;FLA matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalFLAB.pal	;FLA other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalHFDA.pal	;HFD matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalHFDB.pal	;HFD other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalLAA.pal	;LA matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalLAB.pal	;LA other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalMTLA.pal	;MTL matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalMTLB.pal	;MTL other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalNJA.pal	;NJ matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalNJB.pal	;NJ other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalNYIA.pal	;NYI matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalNYIB.pal	;NYI other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalNYRA.pal	;NYR matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalNYRB.pal	;NYR other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalOTWA.pal	;OTW matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalOTWB.pal	;OTW other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalPHIA.pal	;PHI matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalPHIB.pal	;PHI other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalPITA.pal	;PIT matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalPITB.pal	;PIT other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalQUEA.pal	;QUE matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalQUEB.pal	;QUE other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalSJA.pal	;SJ matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalSJB.pal	;SJ other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalSTLA.pal	;STL matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalSTLB.pal	;STL other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalTBA.pal	;TB matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalTBB.pal	;TB other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalTORA.pal	;TOR matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalTORB.pal	;TOR other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalVANA.pal	;VAN matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalVANB.pal	;VAN other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalWSHA.pal	;WSH matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalWSHB.pal	;WSH other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalWPGA.pal	;WPG matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalWPGB.pal	;WPG other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalASEA.pal	;ASE matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalASEB.pal	;ASE other side
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalASWA.pal	;ASW matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalASWB.pal	;ASW other side
TeamPalettesEnd						;end of TeamPalettes (size check below)
	IF (TeamPalettesEnd-TeamPalettes)<>(NumTeams*64)
		inform	3,"TeamPalettes needs two palettes per team"
	ENDIF
FeaturedPictures					;The featured player pictures
									;of each team (TeamList order): a list of picture.l (NoPicSkater1 ...
									;Card<player>) and roster index.w, 0 ends
	dc.l	.ANH,.BOS,.BUF,.CGY
	dc.l	.CHI,.DAL,.DET,.EDM
	dc.l	.FLA,.HFD,.LA,.MTL
	dc.l	.NJ,.NYI,.NYR,.OTW
	dc.l	.PHI,.PIT,.QUE,.SJ
	dc.l	.STL,.TB,.TOR,.VAN
	dc.l	.WSH,.WPG,.ASE,.ASW
.listend							;end of the team list (size check below)
	IF (.listend-FeaturedPictures)<>(NumTeams*4)
		inform	3,"FeaturedPictures needs one entry per team"
	ENDIF
.FLA								;FLA featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	NoPicGoalie2
	dc.w	0
	dc.l	NoPicSkater2
	dc.w	13
	dc.l	NoPicSkater2
	dc.w	11
	dc.l	NoPicSkater1
	dc.w	7
	dc.l	NoPicSkater1
	dc.w	4
	dc.l	NoPicSkater2
	dc.w	3
	dc.l	0
.ANH								;ANH featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	NoPicGoalie2
	dc.w	0
	dc.l	NoPicSkater1
	dc.w	11
	dc.l	NoPicSkater1
	dc.w	13
	dc.l	NoPicSkater1
	dc.w	3
	dc.l	NoPicSkater2
	dc.w	5
	dc.l	NoPicSkater1
	dc.w	7
	dc.l	0
.BOS								;BOS featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardAndyMoog
	dc.w	0
	dc.l	CardDonSweeney
	dc.w	18
	dc.l	CardRayBourque
	dc.w	17
	dc.l	CardJoeJuneau
	dc.w	6
	dc.l	CardAdamOates
	dc.w	2
	dc.l	CardCamNeely
	dc.w	11
	dc.l	NoPicSkater2
	dc.w	19
	dc.l	0
.BUF								;BUF featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardGrantFuhr
	dc.w	0
	dc.l	CardDougBodger
	dc.w	17
	dc.l	CardPetrSvoboda
	dc.w	18
	dc.l	CardDaleHawerchuk
	dc.w	4
	dc.l	CardPatLaFontaine
	dc.w	3
	dc.l	CardAlexnderMogilny
	dc.w	12
	dc.l	0
.CGY								;CGY featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardMikeVernon
	dc.w	0
	dc.l	CardGarySuter
	dc.w	15
	dc.l	CardAlMacInnis
	dc.w	16
	dc.l	CardGaryRoberts
	dc.w	6
	dc.l	CardJoeNieuwendyk
	dc.w	2
	dc.l	CardTheorenFleury
	dc.w	11
	dc.l	0
.CHI								;CHI featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardEdBelfour
	dc.w	0
	dc.l	CardSteveSmith
	dc.w	18
	dc.l	CardChrisChelios
	dc.w	17
	dc.l	CardMichelGoulet
	dc.w	6
	dc.l	CardJeremyRoenick
	dc.w	2
	dc.l	CardSteveLarmer
	dc.w	11
	dc.l	0
.DAL								;DAL featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardJonCasey
	dc.w	0
	dc.l	CardMarkTinordi
	dc.w	16
	dc.l	CardTommySjodin
	dc.w	17
	dc.l	CardDaveGagner
	dc.w	3
	dc.l	CardMikeModano
	dc.w	2
	dc.l	CardRussCourtnall
	dc.w	10
	dc.l	0
.DET								;DET featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardTimCheveldae
	dc.w	0
	dc.l	CardSteveChiasson
	dc.w	18
	dc.l	CardPaulCoffey
	dc.w	17
	dc.l	CardSergeiFedorov
	dc.w	3
	dc.l	CardSteveYzerman
	dc.w	2
	dc.l	CardDinoCiccarelli
	dc.w	12
	dc.l	0
.EDM								;EDM featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardBillRanford
	dc.w	0
	dc.l	CardDaveManson
	dc.w	17
	dc.l	CardIgorKravchuk
	dc.w	18
	dc.l	CardShayneCorson
	dc.w	8
	dc.l	CardDougWeight
	dc.w	2
	dc.l	CardPetrKlima
	dc.w	14
	dc.l	0
.HFD								;HFD featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardSeanBurke
	dc.w	0
	dc.l	CardZarleyZalapski
	dc.w	18
	dc.l	CardEricWeinrich
	dc.w	19
	dc.l	CardGeoffSanderson
	dc.w	8
	dc.l	CardAndrewCassels
	dc.w	3
	dc.l	CardPatVerbeek
	dc.w	13
	dc.l	0
.LA									;LA featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardKellyHrudey
	dc.w	0
	dc.l	CardRobBlake
	dc.w	16
	dc.l	CardMartyMcSorley
	dc.w	17
	dc.l	CardLucRobitaille
	dc.w	7
	dc.l	CardWayneGretzky
	dc.w	3
	dc.l	CardTomasSandstrom
	dc.w	12
	dc.l	NoPicSkater2
	dc.w	13
	dc.l	0
.MTL								;MTL featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardPatrickRoy
	dc.w	0
	dc.l	CardMattSchneider
	dc.w	17
	dc.l	CardEricDesjardins
	dc.w	16
	dc.l	CardVincentDamphousse
	dc.w	6
	dc.l	CardKirkMuller
	dc.w	2
	dc.l	CardBrianBellows
	dc.w	11
	dc.l	0
.NJ									;NJ featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardChrisTerreri
	dc.w	0
	dc.l	CardVachslavFetisov
	dc.w	18
	dc.l	CardScottStevens
	dc.w	17
	dc.l	CardStephaneRicher
	dc.w	11
	dc.l	CardAlexnderSemak
	dc.w	2
	dc.l	CardClaudeLemieux
	dc.w	12
	dc.l	0
.NYI								;NYI featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardGlennHealy
	dc.w	0
	dc.l	CardDariusKasparitis
	dc.w	18
	dc.l	CardVladimirMalakhov
	dc.w	17
	dc.l	CardSteveThomas
	dc.w	8
	dc.l	CardPierreTurgeon
	dc.w	2
	dc.l	CardBenoitHogue
	dc.w	3
	dc.l	0
.NYR								;NYR featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardJohnVanbiesbrk
	dc.w	0
	dc.l	CardJamesPatrick
	dc.w	18
	dc.l	CardBrianLeetch
	dc.w	17
	dc.l	CardEsaTikkanen
	dc.w	6
	dc.l	CardMarkMessier
	dc.w	2
	dc.l	CardMikeGartner
	dc.w	11
	dc.l	0
.OTW								;OTW featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardPeterSidorkwicz
	dc.w	0
	dc.l	CardBradShaw
	dc.w	19
	dc.l	CardNormMaciver
	dc.w	18
	dc.l	CardSylvainTurgeon
	dc.w	9
	dc.l	CardJamieBaker
	dc.w	2
	dc.l	CardBobKudelski
	dc.w	14
	dc.l	0
.PHI								;PHI featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardTommySoderstrom
	dc.w	0
	dc.l	CardDimitriYushkevich
	dc.w	18
	dc.l	CardGarryGalley
	dc.w	17
	dc.l	CardRodBrindAmour
	dc.w	4
	dc.l	CardEricLindros
	dc.w	3
	dc.l	CardMarkRecchi
	dc.w	14
	dc.l	0
.PIT								;PIT featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardTomBarrasso
	dc.w	0
	dc.l	CardLarryMurphy
	dc.w	16
	dc.l	CardUlfSamuelsson
	dc.w	17
	dc.l	CardKevinStevens
	dc.w	6
	dc.l	CardMarioLemieux
	dc.w	2
	dc.l	CardJaromirJagr
	dc.w	10
	dc.l	NoPicSkater2
	dc.w	11
	dc.l	NoPicGoalie1
	dc.w	1
	dc.l	0
.QUE								;QUE featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardRonHextall
	dc.w	0
	dc.l	CardCurtisLeschyshyn
	dc.w	18
	dc.l	CardSteveDuchesne
	dc.w	17
	dc.l	CardJoeSakic
	dc.w	2
	dc.l	CardMatsSundin
	dc.w	13
	dc.l	CardOwenNolan
	dc.w	14
	dc.l	0
.SJ									;SJ featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardArtursIrbe
	dc.w	0
	dc.l	CardNeilWilkinson
	dc.w	17
	dc.l	CardDougWilson
	dc.w	16
	dc.l	CardJohanGarpenlov
	dc.w	9
	dc.l	CardKellyKisio
	dc.w	3
	dc.l	CardPatFalloon
	dc.w	13
	dc.l	0
.STL								;STL featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardCurtisJoseph
	dc.w	0
	dc.l	CardJeffBrown
	dc.w	16
	dc.l	CardGarthButcher
	dc.w	17
	dc.l	CardBrendanShanahan
	dc.w	11
	dc.l	CardCraigJanney
	dc.w	2
	dc.l	CardBrettHull
	dc.w	12
	dc.l	0
.TB									;TB featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardWendellYoung
	dc.w	0
	dc.l	CardRomanHamrlik
	dc.w	19
	dc.l	CardBobBeers
	dc.w	18
	dc.l	CardMikaelAndersson
	dc.w	11
	dc.l	CardBrianBradley
	dc.w	3
	dc.l	CardChrisKontos
	dc.w	4
	dc.l	0
.TOR								;TOR featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardFelixPotvin
	dc.w	0
	dc.l	CardDaveEllett
	dc.w	18
	dc.l	CardToddGill
	dc.w	17
	dc.l	CardDaveAndreychuk
	dc.w	8
	dc.l	CardDougGilmour
	dc.w	3
	dc.l	CardNikolaiBorshevsky
	dc.w	12
	dc.l	0
.VAN								;VAN featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardKirkMcLean
	dc.w	0
	dc.l	CardDougLidster
	dc.w	18
	dc.l	CardJyrkiLumme
	dc.w	17
	dc.l	CardGeoffCourtnall
	dc.w	6
	dc.l	CardCliffRonning
	dc.w	2
	dc.l	CardPavelBure
	dc.w	12
	dc.l	0
.WSH								;WSH featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardDonBeaupre
	dc.w	0
	dc.l	CardAlIafrate
	dc.w	17
	dc.l	CardKevinHatcher
	dc.w	16
	dc.l	CardDimitriKhristich
	dc.w	3
	dc.l	CardMikeRidley
	dc.w	2
	dc.l	CardPeterBondra
	dc.w	11
	dc.l	NoPicSkater1
	dc.w	18
	dc.l	0
.WPG								;WPG featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardBobEssensa
	dc.w	0
	dc.l	CardTeppoNumminen
	dc.w	18
	dc.l	CardPhilHousley
	dc.w	17
	dc.l	CardThomasSteen
	dc.w	3
	dc.l	CardAlexeiZhamnov
	dc.w	2
	dc.l	CardTeemuSelanne
	dc.w	12
	dc.l	0
.ASE								;ASE featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardPatrickRoy
	dc.w	0
	dc.l	CardRayBourque
	dc.w	18
	dc.l	CardLarryMurphy
	dc.w	17
	dc.l	CardAdamOates
	dc.w	6
	dc.l	CardMarioLemieux
	dc.w	3
	dc.l	CardAlexnderMogilny
	dc.w	15
	dc.l	CardGrantFuhr
	dc.w	1
	dc.l	CardTomBarrasso
	dc.w	2
	dc.l	CardMarkMessier
	dc.w	4
	dc.l	CardKirkMuller
	dc.w	5
	dc.l	CardJoeSakic
	dc.w	7
	dc.l	CardPierreTurgeon
	dc.w	8
	dc.l	CardPatLaFontaine
	dc.w	9
	dc.l	CardKevinStevens
	dc.w	10
	dc.l	CardJaromirJagr
	dc.w	11
	dc.l	CardPeterBondra
	dc.w	12
	dc.l	CardMikeGartner
	dc.w	13
	dc.l	NoPicSkater2
	dc.w	14
	dc.l	CardMarkRecchi
	dc.w	16
	dc.l	CardBrianLeetch
	dc.w	19
	dc.l	CardSteveDuchesne
	dc.w	20
	dc.l	CardAlIafrate
	dc.w	21
	dc.l	CardScottStevens
	dc.w	22
	dc.l	CardZarleyZalapski
	dc.w	23
	dc.l	NoPicSkater2
	dc.w	24
	dc.l	0
.ASW								;ASW featured pictures: picture and roster index pairs, goalie first, 0
									;ends
	dc.l	CardEdBelfour
	dc.w	0
	dc.l	CardPaulCoffey
	dc.w	19
	dc.l	CardPhilHousley
	dc.w	21
	dc.l	CardLucRobitaille
	dc.w	10
	dc.l	CardSteveYzerman
	dc.w	3
	dc.l	CardTeemuSelanne
	dc.w	14
	dc.l	CardTimCheveldae
	dc.w	1
	dc.l	CardFelixPotvin
	dc.w	2
	dc.l	CardMikeModano
	dc.w	4
	dc.l	CardJeremyRoenick
	dc.w	5
	dc.l	CardBrianBradley
	dc.w	6
	dc.l	CardDougGilmour
	dc.w	7
	dc.l	CardWayneGretzky
	dc.w	8
	dc.l	CardGaryRoberts
	dc.w	9
	dc.l	CardTheorenFleury
	dc.w	11
	dc.l	CardBrettHull
	dc.w	12
	dc.l	CardPavelBure
	dc.w	13
	dc.l	CardPatFalloon
	dc.w	15
	dc.l	NoPicSkater2
	dc.w	16
	dc.l	CardGarySuter
	dc.w	17
	dc.l	CardJeffBrown
	dc.w	18
	dc.l	CardChrisChelios
	dc.w	20
	dc.l	CardDaveManson
	dc.w	22
	dc.l	CardSteveSmith
	dc.w	23
	dc.l	CardSteveChiasson
	dc.w	24
	dc.l	0
PrintRecordValue					;Record line for a player card (PlayerCardScreen): copy RecordTxt to a3,
									;then the record value of player d1 (GetRecordValue) and goals / goal or
									;saves / save. An empty String when there is no value
	movem.l	d0-d7/a1-a6,-(sp)		;save
	move.l	a1,-(sp)				;keep the output start: it is reset if there is no record
	movea.l	a1,a3					;output
	movea.l	#RecordTxt,a1			;"Record "
	movem.l	d0-d1,-(sp)				;save team and player
	bsr.w	CopyString				;output starts with "Record "
	movem.l	(sp)+,d0-d1				;restore
	bsr.w	GetRecordValue			;d0 = value, d1 = 1 for a goalie
	tst.w	d0						;any value?
	bne.w	.0						;record value 0: no record for this player
	movea.l	(sp)+,a1				;output start
	move.w	#2,(a1)					;length 2 = empty String, the card skips this line
	bra.w	.x						;done
.0									;player has a record: append the number and the unit
	movea.l	#TempBuffer,a1
	move.w	d0,(TempWord2).w		;keep the value: AppendNumber's result is joined next
	bsr.w	AppendNumber			;value as a String
	movea.l	(sp),a3					;output start
	movea.l	#TempBuffer,a1			;the number
	jsr	(appstring).l				;append it
	move.w	(TempWord2).w,d0		;value
	movea.l	#RecSavesTxt,a1			;goalie units: "saves", or "save" when it is 1
	cmp.w	#1,d0					;just one?
	bne.w	.1
	movea.l	#RecSaveTxt,a1
.1									;more than one save, or a skater: check the skater unit
	tst.w	d1						;d1 = 0: a skater, so goals instead of saves
	bne.w	.2
	movea.l	#RecGoalsTxt,a1
	cmp.w	#1,d0
	bne.w	.2
	movea.l	#RecGoalTxt,a1
.2									;unit chosen (goals/goal/saves/save): append it
	movea.l	(sp)+,a3				;output start
	jsr	(appstring).l				;append the unit
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a1-a6
	rts								;return
RecordTxt	dc.b	0				;PrintRecordValue text
	dc.b	$A
	dc.b	$52						;R
	dc.b	$65						;e
	dc.b	$63						;c
	dc.b	$6F						;o
	dc.b	$72						;r
	dc.b	$64						;d
	dc.b	$20,0
RecGoalsTxt	dc.b	0				;PrintRecordValue text
	dc.b	8,$20
	dc.b	$67						;g
	dc.b	$6F						;o
	dc.b	$61						;a
	dc.b	$6C						;l
	dc.b	$73						;s
RecGoalTxt	dc.b	0				;PrintRecordValue text
	dc.b	8,$20
	dc.b	$67						;g
	dc.b	$6F						;o
	dc.b	$61						;a
	dc.b	$6C						;l
	dc.b	0
RecSavesTxt	dc.b	0				;PrintRecordValue text
	dc.b	8,$20
	dc.b	$73						;s
	dc.b	$61						;a
	dc.b	$76						;v
	dc.b	$65						;e
	dc.b	$73						;s
RecSaveTxt	dc.b	0				;PrintRecordValue text
	dc.b	8,$20
	dc.b	$73						;s
	dc.b	$61						;a
	dc.b	$76						;v
	dc.b	$65						;e
	dc.b	0
CopyString							;Copy String a1 (length word first) to a3
	movem.l	d0,-(sp)				;save
	move.w	(a1),d0					;the length word counts the header too
	subq.w	#1,d0					;bytes - 1
.loop								;copy one byte
	move.b	(a1)+,(a3)+				;copy the whole String including its length word
	dbf	d0,.loop					;next byte
	movem.l	(sp)+,d0				;restore
	rts								;return
AppendNumber						;Write d0 (0 ... 999, no leading zeros) as a String at a1, padded to an
									;even length
	movem.w	d0-d6/a0,-(sp)			;save
	move.l	a1,-(sp)				;keep the String start
	move.w	d0,d6					;keep the value
	addq.l	#2,a1					;leave room for the length word
	clr.w	d1						;d1 = length
	ext.l	d0						;clear the remainder
	divu.w	#$64,d0					;hundreds digit
	tst.w	d0						;any hundreds?
	beq.w	.0						;no hundreds: no leading zero
	addi.w	#$30,d0					;'0'
	move.b	d0,(a1)+				;write it
	addq.w	#1,d1					;count it
.0									;no hundreds digit, or it was written: now the tens
	swap	d0						;remainder
	ext.l	d0						;clear the high word
	divu.w	#$A,d0					;tens digit
	addi.w	#$30,d0
	cmp.b	#$30,d0					;tens 0 is skipped only for values below 10
	bne.w	.1						;non-zero: write it
	cmp.w	#$A,d6					;below 10?
	blt.w	.2						;yes: no tens digit
.1									;tens digit wanted (non-zero, or a hundreds digit came before)
	move.b	d0,(a1)+				;write it
	addq.w	#1,d1					;count it
.2									;value below 10, or the tens is written: now the ones
	swap	d0						;ones digit from the remainder
	addi.w	#$30,d0
	move.b	d0,(a1)+				;write it
	addq.w	#1,d1					;count it
	btst	#0,d1					;odd length: pad with a 0 byte so the String stays word aligned
	beq.w	.3						;even already
	move.b	#0,(a1)+				;pad byte
	addq.w	#1,d1					;count it
.3									;length now even: write the length word
	movea.l	(sp)+,a0				;String start
	addq.w	#2,d1					;length counts the 2-byte header
	move.w	d1,(a0)					;store it
	movem.w	(sp)+,d0-d6/a0			;restore
	rts								;return
GetRecordValue						;d0 = record d0 of player d1 of team d0 from save RAM (ReadPlayerRecord
									;into M68K_RAM); d1 = 1 when the player is a goalie
	movem.l	d2-d7/a0-a6,-(sp)		;save
	move.w	d0,-(sp)				;keep the team
	movea.l	#TeamList,a2			;team address table
	asl.w	#2,d0					;long index
	movea.l	0(a2,d0.w),a2			;team data
	adda.w	(a2),a2					;a2 = the team's first player record
	move.w	d1,d0					;skip d1 records to reach the player
	bra.w	.0						;skip d0 players
.loop								;skip one player record: name length + fixed part
	adda.w	(a2),a2
	addq.w	#pldsize,a2
.0									;loop until the player is reached
	dbf	d0,.loop
	move.w	d1,d0					;d0 = player
	move.w	(sp)+,d1				;d1 = team
	move.w	d0,d5					;d5 = player
	move.w	d1,d4					;d4 = team
	ext.l	d0
	movea.l	#M68K_RAM,a0			;record buffer
	bsr.w	ReadPlayerRecord		;his save record into M68K_RAM
	move.b	(a0),d0					;byte 0 = the record value
	ext.w	d0
	movea.l	#TeamList,a5			;team address table
	asl.w	#2,d4					;long index
	movea.l	0(a5,d4.w),a5			;team data
	adda.w	GoalieOdds(a5),a5		;the goalie nibbles in GoalieOdds give the goalie count
	move.w	(a5),d1					;goalie word
	movem.w	d0,-(sp)				;keep the value
	clr.w	d0						;count
.loop2								;count the nibbles of the goalie word
	addq.w	#1,d0
	asl.w	#4,d1					;next nibble
	bne.s	.loop2
	cmp.w	d5,d0					;roster index past the goalies: a skater
	movem.w	(sp)+,d0				;restore the value
	bgt.w	.1						;index below the goalie count: a goalie
	clr.w	d1						;d1 = 0: a skater
	bra.w	.x						;done
.1									;player is one of the goalies
	move.w	#1,d1					;d1 = 1: a goalie
.x									;exit: restore the registers
	movem.l	(sp)+,d2-d7/a0-a6
	rts								;return
PrintRecordHolder					;Record holder line: RecByTxt ("by") then the holder's user name
									;(AppendRecordHolder). An empty String when there is none
	movem.l	d0-d7/a1-a6,-(sp)		;save
	move.l	a1,-(sp)				;keep the output start
	movea.l	a1,a3					;output
	movea.l	#RecByTxt,a1			;"by "
	movem.l	d0-d1,-(sp)				;save team and player
	bsr.w	CopyString				;copy it
	movem.l	(sp)+,d0-d1				;restore
	movea.l	#TempBuffer,a1			;holder name buffer
	bsr.w	AppendRecordHolder		;holder name
	movea.l	(sp)+,a3				;output start
	cmpi.w	#2,(a1)					;no holder name: give back an empty String
	bne.w	.0
	move.w	#2,(a3)					;length 2 = empty String
	bra.w	.x						;done
.0									;holder name found: append it after "by "
	jsr	(appstring).l				;append the name
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a1-a6
	rts								;return
RecByTxt	dc.b	0				;PrintRecordHolder text
	dc.b	6
	dc.b	$62						;b
	dc.b	$79						;y
	dc.b	$20,0
PrintRecordVs						;Record line: RecVsTxt ("vs.") then the user name and the opponent team
									;(AppendRecordVs)
	movem.l	d0-d7/a1-a6,-(sp)		;save
	move.l	a1,-(sp)				;keep the output start
	movea.l	a1,a3					;output
	movea.l	#RecVsTxt,a1			;"vs. "
	movem.l	d0-d1,-(sp)				;save team and player
	bsr.w	CopyString				;copy it
	movem.l	(sp)+,d0-d1				;restore
	movea.l	#TempBuffer,a1			;buffer
	bsr.w	AppendRecordVs			;user name and opponent
	movea.l	(sp)+,a3				;output start
	jsr	(appstring).l				;append it
	movem.l	(sp)+,d0-d7/a1-a6		;restore
	rts								;return
RecVsTxt	dc.b	0				;PrintRecordVs text
	dc.b	6
	dc.b	$76						;v
	dc.b	$73						;s
	dc.b	$2E
	dc.b	$20
AppendRecordHolder					;Append the user name of the record holder (byte 1 of record a0, or read
									;record d0 / d1 when a0 is 0) to a1 (AppendUserName)
	movem.l	d0-d7/a1-a2,-(sp)		;save
	cmpa.l	#0,a0
	bne.w	.0						;a record was passed in a0: use it
	movem.l	d0-d7/a1-a6,-(sp)		;save
	move.w	d0,-(sp)				;swap d0 and d1
	move.w	d1,d0					;swap d0/d1 into ReadPlayerRecord's order: d0 player, d1 team
	move.w	(sp)+,d1
	ext.l	d1						;player
	ext.l	d0						;team
	movea.l	#M68K_RAM,a0			;record buffer
	bsr.w	ReadPlayerRecord		;read the record
	movea.l	#M68K_RAM,a0			;a0 = the record
	movem.l	(sp)+,d0-d7/a1-a6		;restore
.0									;record ready (passed in, or read into M68K_RAM): byte 1 = holder
	move.b	1(a0),d2
	ext.w	d2						;user number
	bset	#7,(sflags6).w			;bit 7 of sflags6: AppendUserName uses the record name list
	bsr.w	AppendUserName			;append the name
	movem.l	(sp)+,d0-d7/a1-a2		;restore
	rts								;return
AppendRecordVs						;Append the user name (byte 3 of record a0), a space and the opponent team
									;name (byte 2, AppendTeamName) to a1
	movem.l	d0-d7/a0-a6,-(sp)		;save
	cmpa.l	#0,a0
	bne.w	.0						;a record was passed in a0: use it
	movem.l	d0-d7/a1-a6,-(sp)		;save
	move.w	d0,-(sp)				;swap d0 and d1
	move.w	d1,d0					;swap d0/d1 into ReadPlayerRecord's order: d0 player, d1 team
	move.w	(sp)+,d1
	ext.l	d1						;player
	ext.l	d0						;team
	movea.l	#M68K_RAM,a0			;record buffer
	bsr.w	ReadPlayerRecord		;read the record
	movea.l	#M68K_RAM,a0			;a0 = the record
	movem.l	(sp)+,d0-d7/a1-a6		;restore
.0									;record ready (passed in, or read into M68K_RAM): byte 3 = the user
	move.b	3(a0),d2
	ext.w	d2						;user number
	movem.l	d0/a1,-(sp)				;save
	bset	#7,(sflags6).w			;record name list
	bsr.w	AppendUserName			;append the name
	movea.l	a1,a3					;output
	movea.l	#RecSpaceTxt,a1			;" "
	jsr	(appstring).l				;append it
	movem.l	(sp)+,d0/a1				;restore
	move.b	2(a0),d0				;byte 2 = the opponent team
	jsr	(AppendTeamName).l			;append the team name
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
RecSpaceTxt	dc.b	0				;AppendRecordVs text
	dc.b	4,$20,0
ReadPlayerRecord					;Read the 4 byte player record d1 (PlayerRecordOffsets) of team d0 from
									;save RAM to a0
	bclr	#6,(sflags6).w			;bit 6 clear = read
PlayerRecordIO						;Read (sflags6 bit 6 clear) or write a save RAM record block (ReadSRAM /
									;WriteSRAM). Entered from WritePlayerRecord
	movem.l	d0-d1/a0-a1,-(sp)		;save
	asl.l	#2,d0					;team d0 * 4 bytes ... (record base 0)
	addi.l	#0,d0					;plus the record base
	movea.l	#PlayerRecordOffsets,a1	;record slot of each player
	add.w	d1,d1					;PlayerRecordOffsets is word sized
	move.w	0(a1,d1.w),d1			;his slot
	asl.w	#2,d1					;slot * 4 bytes per record
	ext.l	d1
	add.l	d1,d0					;SRAM offset
	moveq	#4,d1					;4 bytes per record
	btst	#6,(sflags6).w			;write?
	beq.w	.read
	jsr	(WriteSRAM).l				;a0 to SRAM
	bra.w	.x						;done
.read								;read: SRAM to a0
	jsr	(ReadSRAM).l
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d1/a0-a1
	rts								;return
WritePlayerRecord					;Write the 4 byte player record
	bset	#6,(sflags6).w			;bit 6 set = write
	bra.s	PlayerRecordIO
ReadCrowdRecord						;Read the 16 byte crowd record block of team d1 from save RAM
									;(CrowdRecBase + team * 16) to a0. Called from
									;LoadCrowdRec and PrintCrowdMeter
	bclr	#6,(sflags6).w			;bit 6 clear = read
CrowdRecordIO						;The crowd record block: read or write (sflags6 bit 6). Entered from
									;ReadCrowdRecord and WriteCrowdRecord
	movem.l	d0-d1/a0-a1,-(sp)		;save
	move.l	d1,d0					;team
	asl.w	#4,d0					;16 bytes per team
	addi.l	#CrowdRecBase,d0		;plus the crowd record base
	moveq	#$10,d1					;16 bytes
	btst	#6,(sflags6).w			;write?
	beq.w	.read
	jsr	(WriteSRAM).l				;a0 to SRAM
	bra.w	.x						;done
.read								;read: SRAM to a0
	jsr	(ReadSRAM).l
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d1/a0-a1
	rts								;return
WriteCrowdRecord					;Write the 16 byte crowd record block of team d1 (CrowdRecordIO)
	bset	#6,(sflags6).w			;bit 6 set = write
	bra.s	CrowdRecordIO
ReadTeamRecord						;Read the 16 byte team record block of team d1 (TeamRecBase + team * 16)
									;to a0 (TeamRecordIO)
	bclr	#6,(sflags6).w			;bit 6 clear = read
TeamRecordIO						;A save RAM record block: read or write (sflags6 bit 6)
	movem.l	d0-d1/a0-a1,-(sp)		;save
	move.l	d1,d0					;team
	asl.w	#4,d0					;16 bytes per team
	addi.l	#TeamRecBase,d0			;plus the team record base
	moveq	#$10,d1					;16 bytes
	btst	#6,(sflags6).w			;write?
	beq.w	.read
	jsr	(WriteSRAM).l				;a0 to SRAM
	bra.w	.x						;done
.read								;read: SRAM to a0
	jsr	(ReadSRAM).l
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d1/a0-a1
	rts								;return
WriteTeamRecord						;Write the team record block (TeamRecordIO)
	bset	#6,(sflags6).w			;bit 6 set = write
	bra.s	TeamRecordIO
WriteNameLog						;Write the user name log ($80 bytes at namelog) to save RAM at NameLogBase
									;(NameLogIO)
	bset	#6,(sflags6).w			;bit 6 set = write
	bra.w	NameLogIO
ReadNameLog							;Read the user name log from save RAM at NameLogBase to namelog. Called
									;from GameSetUp
	bclr	#6,(sflags6).w			;bit 6 clear = read
NameLogIO							;A user record block: read or write (sflags6 bit 6)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	move.l	#NameLogBytes,d1		;size
	move.l	#NameLogBase,d0			;SRAM offset
	movea.l	#namelog,a0				;buffer
	btst	#6,(sflags6).w			;write?
	beq.w	.read
	jsr	(WriteSRAM).l				;namelog to SRAM
	bra.w	.x						;done
.read								;read: SRAM to namelog
	jsr	(ReadSRAM).l
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts								;return
PlayerRecordOffsets	dc.b	0		;Record offsets for ReadPlayerRecord
	dc.b	0,0,$1A,0
	dc.b	$34						;4
	dc.b	0
	dc.b	$4E						;N
	dc.b	0
	dc.b	$68						;h
	dc.b	0,$82,0,$9C,0,$B6,0,$D0,0,$EA,1,4,1,$1E,1
	dc.b	$38						;8
	dc.b	1
	dc.b	$52						;R
	dc.b	1
	dc.b	$6C						;l
	dc.b	1,$86,1,$A0,1,$BA,1,$D4,1,$EE,2,8,2
	dc.b	$22						;"
	dc.b	2
	dc.b	$3C						;<
	dc.b	2
	dc.b	$56						;V
	dc.b	2
	dc.b	$70						;p
	dc.b	2,$8A,2,$A4,2,$BE,2,$D8
UpdateRecords						;With save RAM (ValidSRAM) and user records on (OptUserRec 0), update the
									;team and player records after a game (UpdateTeamRecord UpdateCrowdRecord,
									;UpdatePlayerRecords), then the save RAM checksum (MakeSRAMChecksum).
									;Called from Intermission
	tst.w	(ValidSRAM).w
	bmi.w	.x						;no save RAM: nothing to update
	tst.w	(OptUserRec).w
	bne.w	.x						;user records turned off in the options
	movem.l	d0-d7/a0-a6,-(sp)		;save
	bsr.w	CountGoalies			;goalies of each team
	bsr.w	CountPlayers			;players of each team
	move.w	(HomeTeam).w,d1			;home team
	ext.l	d1
	movea.l	#recordbuf,a0			;record buffer
	movea.l	#tmstruct,a2			;home team struct
	move.w	(homegoalies).w,d5		;goalie count: the first players of the roster are goalies
	move.w	(VisTeam).w,d6			;opponent team for the records
	bsr.w	UpdatePlayerRecords
	move.w	(VisTeam).w,d1			;away team
	ext.l	d1
	movea.l	#AwShots,a2				;away team struct
	move.w	(awaygoalies).w,d5		;away goalie count
	move.w	(HomeTeam).w,d6			;opponent team
	bsr.w	UpdatePlayerRecords		;away player records
	clr.w	d7						;d7 = "a record was changed" flag
	movea.l	#tmstruct,a1			;home team struct
	move.w	(homeuser).w,d4			;its user
	move.w	(awayuser).w,d5			;opponent user
	move.w	(HomeTeam).w,d1			;team
	move.w	(VisTeam).w,d2			;opponent team
	move.w	(homegoalies).w,d6		;goalie count
	ext.l	d1
	movea.l	#recordbuf,a0			;record buffer
	bsr.w	UpdateCrowdRecord		;home crowd records
	movea.l	#AwShots,a1				;away team struct
	move.w	(awayuser).w,d4			;its user
	move.w	(homeuser).w,d5			;opponent user
	move.w	(VisTeam).w,d1			;team
	move.w	(HomeTeam).w,d2			;opponent team
	move.w	(awaygoalies).w,d6		;goalie count
	ext.l	d1
	movea.l	#recordbuf,a0			;record buffer
	bsr.w	UpdateCrowdRecord		;away crowd records
	movea.l	#recordbuf,a0			;record buffer
	move.w	(homeuser).w,d1			;user
	ext.l	d1
	move.w	(awayuser).w,d2			;opponent user
	move.w	(HomeTeam).w,d3			;team
	move.w	(VisTeam).w,d4			;opponent team
	movea.l	#tmstruct,a1			;team struct
	movea.l	#AwShots,a2				;opponent team struct
	bsr.w	UpdateTeamRecord		;home team record
	movea.l	#recordbuf,a0			;record buffer
	move.w	(awayuser).w,d1			;user
	ext.l	d1
	move.w	(homeuser).w,d2			;opponent user
	move.w	(VisTeam).w,d3			;team
	move.w	(HomeTeam).w,d4			;opponent team
	movea.l	#AwShots,a1				;team struct
	movea.l	#tmstruct,a2			;opponent team struct
	bsr.w	UpdateTeamRecord		;away team record
	jsr	(MakeSRAMChecksum).l		;new save RAM checksum
	movem.l	(sp)+,d0-d7/a0-a6		;restore
.x									;exit (also the end of the code above)
	rts
UpdateTeamRecord					;After a game: add the game to team record block d1 (games, wins, ties),
									;and keep the biggest win and loss margins with the user names
	movem.l	d0-d7/a0-a6,-(sp)		;save
	bsr.w	ReadTeamRecord			;team record block to a0
	st	d7							;d7 set: the team record is always written back
	movem.w	d0,-(sp)				;save
	clr.w	d0						;games, big endian
	move.b	urgames(a0),d0
	lsl.w	#8,d0
	move.b	urgames+1(a0),d0
	cmp.w	#$2328,d0				;stop counting games at 9000
	bge.w	.1
	addq.w	#1,d0					;count the game
	move.b	d0,urgames+1(a0)		;store it
	lsr.w	#8,d0
	move.b	d0,urgames(a0)
	move.w	tmscore(a1),d0			;team goals
	cmp.w	tmscore(a2),d0			;against the opponent's
	bgt.w	.0						;home team won: count a win
	blt.w	.1						;lost: only the game is counted
	clr.w	d0						;tie: count a tie
	move.b	urties(a0),d0			;ties, big endian
	lsl.w	#8,d0
	move.b	urties+1(a0),d0
	addq.w	#1,d0					;count it
	move.b	d0,urties+1(a0)			;store it
	lsr.w	#8,d0
	move.b	d0,urties(a0)
	bra.w	.1
.0									;won: count a win
	clr.w	d0
	move.b	urwins(a0),d0			;wins, big endian
	lsl.w	#8,d0
	move.b	urwins+1(a0),d0
	addq.w	#1,d0					;count it
	move.b	d0,urwins+1(a0)			;store it
	lsr.w	#8,d0
	move.b	d0,urwins(a0)
.1									;game counted: now the margin records
	movem.w	(sp)+,d0				;restore
	movem.w	d0,-(sp)				;save
	move.w	tmscore(a1),d0			;team goals
	cmp.w	tmscore(a2),d0			;against the opponent's
	movem.w	(sp)+,d0				;restore
	ble.w	.write					;not a win: no margin record
	move.w	tmscore(a1),d5			;team goals
	cmp.b	(a0),d5					;biggest goals scored in a win
	ble.w	.2
	st	d7							;changed
	move.b	d5,(a0)					;new goals record
	move.b	d3,urgoalsteam(a0)		;team
	move.b	d4,urgoalsopp(a0)		;opponent
	move.b	d2,urgoalsoppuser(a0)	;opponent user
.2									;goals record kept or set: check the saves record
	move.w	tmscore(a2),d5			;opponent goals
	move.w	(a2),d6					;shots - goals = saves of the other goalie
	sub.w	d5,d6					;saves
	cmp.b	ursaves(a0),d6			;above the record?
	ble.w	.write
	st	d7							;changed
	move.b	d6,ursaves(a0)			;new saves record
	move.b	d3,ursavesteam(a0)		;team
	move.b	d4,ursavesopp(a0)		;opponent
	move.b	d2,ursavesoppuser(a0)	;opponent user
.write								;write the block back to save RAM
	bsr.w	WriteTeamRecord
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
UpdateCrowdRecord					;Update the crowd records (ReadCrowdRecord, WriteCrowdRecord)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	bsr.w	ReadCrowdRecord			;crowd record block to a0
	move.w	$C(a1),d3				;team goals of this game
	cmp.b	(a0),d3					;more goals than the record: new crowd goals record
	ble.w	.0
	move.b	d3,(a0)					;new record
	move.b	d4,crgoalsuser(a0)		;user
	move.b	d5,crgoalsoppuser(a0)	;opponent user
	move.b	d2,crgoalsopp(a0)		;opponent team
	st	d7							;changed
.0									;goals record done: find the best goalie save total
	subq.w	#1,d6					;d6 = goalie count - 1
	clr.w	d3						;best so far
.loop								;saves of goalie d6 = shots against - goals against
	move.w	d6,d0					;goalie
	addi.w	#tmpshots,d0			;his shots against
	move.b	0(a1,d0.w),(TempWord1).w
	addi.w	#tmgoals-tmpshots,d0	;his goals against
	move.b	0(a1,d0.w),d0
	sub.b	d0,(TempWord1).w		;saves
	cmp.b	(TempWord1).w,d3		;best so far?
	bge.w	.1						;keep the biggest
	move.b	(TempWord1).w,d3		;new best
.1									;next goalie
	dbf	d6,.loop
	cmp.b	crsaves(a0),d3			;best saves above the record: new saves record
	ble.w	.2
	st	d7
	move.b	d3,crsaves(a0)			;new record
	move.b	d4,crsavesuser(a0)		;user
	move.b	d5,crsavesoppuser(a0)	;opponent user
	move.b	d2,crsavesopp(a0)		;opponent team
.2									;saves record done: crowd peak only for the home team
	cmp.w	(HomeTeam).w,d1			;home team?
	bne.w	.3						;no
	move.b	crpeak(a0),d3			;peak record
	andi.w	#$FF,d3					;byte
	cmp.w	(CrowdPeak).w,d3
	bge.w	.3						;the record is as loud or louder: keep it
	move.w	(CrowdPeak).w,d3		;new peak
	st	d7							;changed
	move.b	d3,crpeak(a0)			;store it
	move.b	d4,crpeakuser(a0)		;user
	move.b	d5,crpeakoppuser(a0)	;opponent user
	move.b	d2,crpeakopp(a0)		;opponent team
.3									;records checked: write back only when one changed (d7)
	tst.w	d7
	beq.w	.x						;nothing changed
	bsr.w	WriteCrowdRecord		;write the block back
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts								;return
UpdatePlayerRecords					;After a game: for the 26 players of team a2, keep each new best (goals,
									;or saves for the goalies) in his player record with the user names and
									;opponent d6
	clr.l	d0						;player 0
	move.w	#$19,d2					;26 roster slots
.loop								;each player: read his record
	bsr.w	ReadPlayerRecord		;his record to a0
	cmp.w	d5,d0					;goalie?
	blt.w	.0						;d0 >= goalie count: a skater, use his goals
	move.w	d0,-(sp)				;save
	addi.w	#tmgoals,d0				;goals of this game
	move.b	0(a2,d0.w),d4			;d4 = goals
	move.w	(sp)+,d0				;restore
	bra.w	.1						;compare
.0									;a goalie: saves = shots against - goals against
	move.w	d0,-(sp)				;save
	addi.w	#tmpshots,d0			;his shots against
	move.b	0(a2,d0.w),d4			;d4 = shots against
	addi.w	#tmgoals-tmpshots,d0	;his goals against
	sub.b	0(a2,d0.w),d4			;d4 = saves
	move.w	(sp)+,d0				;restore
.1									;this game's value in d4
	move.b	(a0),d3					;his record
	cmp.b	d3,d4
	ble.w	.3						;not above his record: next player
	move.b	d4,(a0)					;new record
	move.b	(homeuser+1).w,pruser(a0)	;home team: the home user holds it
	move.b	(awayuser+1).w,proppuser(a0)	;opponent user
	cmpa.l	#tmstruct,a2			;home team?
	beq.w	.2						;home team: names already right
	move.b	(awayuser+1).w,pruser(a0)	;away user
	move.b	(homeuser+1).w,proppuser(a0)	;opponent user
.2									;user names set for this team
	move.b	d6,propp(a0)			;opponent team
	bsr.w	WritePlayerRecord		;write it back
.3									;next player
	addq.w	#1,d0					;next player
	dbf	d2,.loop					;loop
	rts								;return
CountGoalies						;homegoalies / awaygoalies = goalies of the home / away team
									;(GetGoalieCount). Called and PlayerCards
	movem.l	d0-d7/a0-a6,-(sp)		;save
	movea.l	#tmstruct,a2			;home team struct
	jsr	(GetGoalieCount).l			;count its goalies
	move.w	d0,(homegoalies).w
	movea.l	#AwShots,a2				;away team struct
	jsr	(GetGoalieCount).l			;count its goalies
	move.w	d0,(awaygoalies).w
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
CountPlayers						;homeplayers / awayplayers = players of the home / away team
									;(GetPlayerCount)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	movea.l	#tmstruct,a2			;home team struct
	jsr	(GetPlayerCount).l			;count its players
	move.w	d0,(homeplayers).w
	movea.l	#AwShots,a2				;away team struct
	jsr	(GetPlayerCount).l			;count its players
	move.w	d0,(awayplayers).w
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
AppendUserName						;Append user name d2 (12 bytes of the name log at namelog, spaces for 0)
									;to a1, or NoNameTxt when d2 is 0; trailing spaces trimmed (TrimSpaces)
	movem.l	d0-d3/a0-a3,-(sp)		;save
	movea.l	a1,a2					;keep the String start
	tst.w	d2						;no user?
	beq.w	.2
	move.w	#$B,d0					;12 bytes
	clr.w	d3						;byte index
	movea.l	#namelog,a0				;user name log
	mulu.w	#$C,d2					;12 bytes per name
	adda.l	d2,a0					;this user's name
.loop								;copy one name byte
	move.b	0(a0,d3.w),d1			;0 bytes print as spaces
	bne.w	.0
	move.b	#$20,d1
.0									;name byte ready (a 0 became a space)
	move.b	d1,2(a1)				;after the length word
	tst.b	(a1)+					;next output byte
	addq.w	#1,d3					;next name byte
	dbf	d0,.loop					;loop
	move.w	#$E,(a2)				;length = 12 + header
	btst	#7,(sflags6).w
	beq.w	.1						;trim only when asked (bit 7)
	bsr.w	TrimSpaces				;trim the trailing spaces
.1									;name copied
	bra.w	.x
.2									;no user: "No Name" instead
	movea.l	a1,a3					;output
	move.l	a3,-(sp)				;keep it
	movea.l	#NoNameTxt,a1
	jsr	(CopyString).l				;copy it
	movea.l	(sp)+,a2				;String start
	bsr.w	TrimSpaces				;trim the trailing spaces
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d3/a0-a3
	rts								;return
NoNameTxt	dc.b	0				;AppendUserName data
	dc.b	2
PlayerCards							;"Player Cards" menu item (menu lists), with save RAM only: the player
									;card screens (DrawPlayerCard), A / C to page, start exits
									;(ExitStatsScreen)
	tst.w	(ValidSRAM).w
	bpl.w	.0						;no save RAM: the menu item does nothing
	rts
.0									;save RAM present: open the card screen
	movem.l	d0-d7/a0-a6,-(sp)		;save
	jsr	(forceblack).l				;screen off while it is built
	bclr	#dfok,(disflags).w
	move.w	(disflags).w,-(sp)		;save
	bset	#dfng,(disflags).w		;no game drawing during the screen
	move.w	(VSPRITES).w,d0			;sprite table
	jsr	(Vmaddr).l					;vram address
	move.l	#0,(a0)					;clear the first sprite
	move.w	#VDPR_MODE4+$81,Vctrl-Vdata(a0)	;32 cell wide mode
	move.w	#6,(Map3col).w			;map 3 width
	move.w	#VDPR_HSCROLL,Vctrl-Vdata(a0)	;hscroll register
	clr.w	d0						;hscroll table
	jsr	(Vmaddr).l					;vram address
	move.l	#0,(a0)					;clear the scroll
	move.w	(sp)+,(disflags).w		;restore
	bclr	#df32c,(disflags).w		;32 cell flag off
	bsr.w	CountGoalies			;goalies of each team
	bsr.w	CountPlayers			;players of each team
	move.w	(smallfontchars).w,d4	;load the small font
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l	;send the font
	dc.l	$05234167,$89ABCDEF		;remap table
	jsr	(printz).l					;map 3 at 0,0
	String	-TXMAP3,0,0
	movea.l	#PlayerCardsScreenPic,a0	;the Player Cards screen picture
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2					;a2 = offsets
	adda.l	(a2)+,a0				;a0 = tile data
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d1						;y 0
	clr.w	d0						;x 0
	moveq	#$28,d2					;width 40
	move.w	#$1C,d3					;height 28
	moveq	#$D,d5					;palette 0 (flags $D)
	move.w	#1,d4					;first char
	jsr	(dobitmap).l				;draw the screen
	move.w	d4,(cardlogochars1).w	;tile bases of the two logo slots
	addi.w	#$24,d4
	move.w	d4,(cardlogochars2).w
	addi.w	#$24,d4
	move.w	d4,-(sp)				;save
	jsr	(printz).l					;map 2 at 0,0
	String	-TXMAP2,0,0
	moveq	#$40,d0					;width 64
	moveq	#$20,d1					;height 32
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l					;clear map 2
	move.w	(sp)+,d4				;restore
	jsr	(printz).l					;map 2 (priority) at 1,1
	String	-(TXPRI+TXMAP2),1,1
	movea.l	#CornerLogoMap,a0		;corner logo map
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2					;a2 = offsets
	adda.l	(a2)+,a0				;a0 = tile data
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d1						;y 0
	clr.w	d0						;x 0
	moveq	#6,d2					;width 6
	move.w	#6,d3					;height 6
	moveq	#8,d5					;palette flags 8
	jsr	(dobitmap).l				;draw the corner logo
	jsr	(printz).l					;map 2 (priority) at column 33, row 1
	String	-(TXPRI+TXMAP2),'!',1
	movea.l	#ArenaGfxBank,a0		;arena logo bank
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2					;a2 = offsets
	adda.l	(a2)+,a0				;a0 = tile data
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d1						;y 0
	clr.w	d0						;x 0
	moveq	#6,d2					;width 6
	move.w	#6,d3					;height 6
	moveq	#0,d5					;palette flags 0
	jsr	(dobitmap).l				;draw the arena logo
	bsr.w	BuildCardPlayerLists	;the card player lists
	move.w	#$18,(palcount).w		;fade in over $18 frames
	clr.w	(homecardidx).w			;home: first card
	clr.w	(awaycardidx).w			;visitors: first card
	tst.w	(FourWayPlay).w			;4-way play?
	beq.w	.1						;one or two pads
	cmpi.w	#3,(pausepad).w			;4-way: pausepad 3 gets the home cards
	beq.w	.3
	bra.w	.2						;controller 2
.1									;two players: sfpj set picks controller 2's team
	btst	#sfpj,(sflags).w
	beq.w	.3
.2									;controller 2 chooses the side
	move.w	(cont2team).w,d0
	bra.w	.4
.3									;controller 1 chooses the side
	move.w	(cont1team).w,d0
.4									;team side code 1 or 2: make it 0 home, 1 visitors
	subq.w	#1,d0
	bpl.w	.5						;was 1 or 2
	clr.w	d0
.5									;clamp: unassigned (0) shows the home team
	andi.w	#1,d0					;0 home, 1 visitors
	movea.l	#awaycardidx,a0			;visitors index
	move.w	d0,(cardvis).w			;side shown
	bne.w	.draw					;visitors
	movea.l	#homecardidx,a0			;home index
.draw								;draw the first card of that side
	bsr.w	DrawPlayerCard
.loop								;each frame: read the pad
	jsr	(vcountwait).l				;wait for the next frame
	jsr	(getpzjoy).l				;read the pads
	jsr	(ProcessInputWithRepeat).l	;with key repeat
	btst	#7,d3					;start?
	bne.w	.exit					;start exits
	btst	#6,d1					;A: switch team
	beq.w	.7
	eori.w	#1,(cardvis).w			;other side
	clr.w	d0						;first card
	bra.w	.8						;draw it
.7									;not A: C pages forward, left/right page by one
	move.w	#1,d0					;step +1
	btst	#5,d1					;C?
	bne.w	.8						;C: next card
	moveq	#1,d0					;right: next card
	jsr	(nodiag).l					;no diagonals
	btst	#3,d1					;right?
	bne.w	.8						;yes: next card
	neg.w	d0						;step -1
	btst	#2,d1					;left: previous card
	bne.w	.8
	bra.s	.loop					;nothing pressed: keep waiting
.8									;step the side's card index by d0 and redraw
	movea.l	#homecardidx,a0			;home index
	move.w	(homeplayers).w,(cardcount).w	;home card count
	tst.w	(cardvis).w				;which side?
	beq.w	.9						;home
	movea.l	#awaycardidx,a0			;visitors index
	move.w	(awayplayers).w,(cardcount).w	;visitors card count
.9									;visitors index and count chosen, or the home ones
	add.w	d0,(a0)					;step the index
	bsr.w	WrapCardIndex			;keep it in range
	bsr.w	DrawPlayerCard			;draw the card
	bra.w	.loop					;loop
.exit								;pop the d0-d7/a0-a6 saved above
	movem.l	(sp)+,d0-d7/a0-a6
	jmp	ExitStatsScreen				;back to the stats menu
WrapCardIndex						;Wrap the card index (a0) into 0 ... cardcount - 1
	move.w	d0,-(sp)				;save
	move.w	(cardcount).w,d0		;card count
	addq.w	#1,d0					;plus the team card
	cmp.w	(a0),d0					;past the last card: back to 0
	bne.w	.0
	clr.w	(a0)
.0									;not past the end: check for below 0
	tst.w	(a0)					;below 0?
	bpl.w	.1						;no
	subq.w	#1,d0					;last card
	move.w	d0,(a0)					;wrap to it
.1									;index in range
	move.w	(sp)+,d0				;restore
	rts								;return
DrawPlayerCard						;Draw a player card: picture (DrawPictureBox), name, "Records" and "This
									;Game" columns (PrintCardRecords, PrintSaveRecordLine,
									;PrintGoalRecordLine), Overall Rating (PrintOverallRating), Starting Line
									;(PrintStartingLine), position, goals / assists or saves
									;(PrintGoalsAssists, PrintSaves)
	movem.l	d0-d7/a1-a6,-(sp)		;save
	move.l	a0,-(sp)				;keep the index pointer
	move.w	(HomeTeam).w,d0			;home team
	tst.w	(cardvis).w				;which side?
	beq.w	.0
	move.w	(VisTeam).w,d0			;visitors
.0									;team side chosen: load its palette
	asl.w	#6,d0					;64 bytes of palettes per team
	movea.l	#TeamPalettes,a6		;team palettes
	move.l	$26(a6,d0.w),(palfadenew+$22).w	;the team's card colors into the palette
	move.w	#$64,(palcount).w		;fade over $64 frames
	jsr	(printz).l					;map 2 (priority) at 0,7
	String	-(TXPRI+TXMAP2),0,7
	move.w	#$28,d0					;width 40
	move.w	#$15,d1					;height 21
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l					;clear the card area
	jsr	(printz).l					;map 2 (priority) at 0,0
	String	-(TXPRI+TXMAP2),0,0
	movea.l	(sp),a0					;index pointer
	tst.w	(a0)
	bne.w	.1						;index 0 is the team records card
	bsr.w	PrintCardRecords		;team records card
	bra.w	.2						;done
.1									;a player card
	bsr.w	.3						;player card
.2									;card drawn
	movea.l	(sp)+,a0				;restore
	movem.l	(sp)+,d0-d7/a1-a6		;restore
	rts								;return
.3									;draw a player card for index (a0)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	move.w	(a0),(cardindex).w		;card number
	bsr.w	DrawPictureBox			;picture box
	move.w	#$21,d0					;width
	move.w	#8,d1					;height 8
	jsr	(ClearCardText).l			;clear the text area
	move.w	#$64,(palcount).w		;fade over $64 frames
	jsr	(printz).l					;map 2 (priority) at 0,0
	String	-(TXPRI+TXMAP2),0,0
	move.w	(HomeTeam).w,d0			;home team
	tst.w	(cardvis).w				;which side?
	beq.w	.4
	move.w	(VisTeam).w,d0			;visitors
.4									;team side chosen
	move.w	d0,(TempWord2).w		;keep the team
	movea.l	#TeamList,a2			;team address table
	asl.w	#2,d0					;long index
	movea.l	0(a2,d0.w),a2			;team data
	adda.w	(a2),a2					;first player record
	bsr.w	GetCardPlayer			;d0 = roster index of the card
	bra.w	.5						;skip d0 players
.loop								;skip one player record: name length + fixed part
	adda.w	(a2),a2
	addq.w	#pldsize,a2
.5									;loop until the card player is reached
	dbf	d0,.loop
	clr.w	d7						;first name length
	movea.l	#ThreeStars,a3			;name buffer
	movea.l	a2,a1					;player name
	bsr.w	CopyString				;copy it
	movea.l	#ThreeStars+2,a3		;cut the name at the first space: the first name
.loop2								;loop
	addq.w	#1,d7
	cmpi.b	#$20,(a3)+				;space?
	bne.s	.loop2					;no: next character
	subq.w	#1,d7					;first name length
	move.b	#0,-(a3)				;end the first name with a 0
	movea.l	#ThreeStars,a3			;name buffer
	addq.w	#1,d7					;round up
	andi.w	#$FE,d7					;round the length up to even and add the header
	addq.w	#2,d7
	move.w	d7,(a3)					;store it
	movea.l	a3,a1					;first name
	move.w	#8,(printx).l			;column 8
	move.w	#$B,(printy).l			;row $B
	jsr	(printsmall).l				;print it
	bsr.w	GetCardPlayer			;d0 = roster index of the card
	movea.l	#tmstruct,a2			;home team stats
	tst.w	(cardvis).w				;which side?
	beq.w	.6
	movea.l	#AwShots,a2				;visitors stats
.6									;team side chosen: the stats table
	jsr	(FormatPlayerNameLast).l
	move.w	#8,(printx).l			;column 8
	move.w	#$C,(printy).l			;row $C
	jsr	(printsmall).l				;print the last name
	move.w	#8,d1					;row 8
	jsr	(PrintCardTeam).l			;team name
	move.w	#$15,(printx).l			;column $15
	move.w	#$C,(printy).l			;row $C
	move.w	(printx).w,-(sp)		;save the column
	jsr	(printsmallz).l				;print
	String	'  Records'
	move.w	(sp)+,(printx).w		;same column
	addq.w	#1,(printy).w			;next row
	jsr	(printsmallz).l				;print
	String	'-----------'
	move.w	#$15,(printx).l			;column $15
	move.w	#$12,(printy).l			;row $12
	move.w	(printx).w,-(sp)		;save the column
	jsr	(printsmallz).l				;print
	String	' This Game '
	move.w	(sp)+,(printx).w		;same column
	addq.w	#1,(printy).w			;next row
	jsr	(printsmallz).l				;print
	String	'-----------'
	move.w	(HomeTeam).w,d1			;records of the team on this side
	tst.w	(cardvis).w				;which side?
.7									;(not branched to)
	beq.w	.8
	move.w	(VisTeam).w,d1			;visitors
.8									;team side chosen
	ext.l	d1
	bsr.w	GetCardPlayer			;d0 = roster index of the card
	ext.l	d0						;player
	movea.l	#recordbuf,a0			;record buffer
	bsr.w	ReadPlayerRecord		;read his record
	movea.l	#recordbuf,a0			;a0 = the record
	move.b	(a0),d2					;record value
	move.b	pruser(a0),d3			;user
	move.b	proppuser(a0),d4		;opponent user
	move.b	propp(a0),d5			;opponent team
	move.w	#$E,d1					;print row $E
	move.w	(homegoalies).w,d0		;home goalie count
	tst.w	(cardvis).w				;which side?
.9									;(not branched to)
	beq.w	.11
.10									;(not branched to)
	move.w	(awaygoalies).w,d0		;away goalie count
.11									;goalie count of this side
	cmp.w	(cardplayer).w,d0
	ble.w	.12						;index past the goalies: a skater
	move.w	#$15,d0					;column $15
	bsr.w	PrintSaveRecordLine		;saves record
	bsr.w	GetCardPlayer			;d0 = roster index of the card
	move.w	#$15,d1					;column $15
	move.w	#$14,d2					;row $14
	bsr.w	PrintSaves				;this game's saves
	st	(matchup).w					;matchup set: the card shows goalie stats
	bra.w	.13
.12									;a skater: goals record and goals / assists
	move.w	#$15,d0					;column $15
	bsr.w	PrintGoalRecordLine		;goals record
	bsr.w	GetCardPlayer			;d0 = roster index of the card
	move.w	#$15,d1					;column $15
	move.w	#$14,d2					;row $14
	bsr.w	PrintGoalsAssists		;this game's goals and assists
	clr.w	(matchup).w				;skater card
.13									;both: rating and position
	move.w	#3,d1					;column 3
	move.w	#$11,d2					;row $11
	bsr.w	GetCardPlayer			;d0 = roster index of the card
	bsr.w	PrintOverallRating		;overall rating
	move.w	#3,d1					;column 3
	move.w	#$F,d2					;row $F
	bsr.w	GetCardPlayer			;d0 = roster index of the card
	bsr.w	PrintCardPosition		;position
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
PrintCardRecords					;Player card "Records" column
	movem.l	d0-d7/a0-a6,-(sp)		;save
	move.w	#$21,d0					;column $21
	move.w	#8,d1					;row 8
	jsr	(ClearCardText).l			;clear the text area
	move.w	#1,d0					;column 1
	move.w	#8,d1					;row 8
	bset	#0,(sflags6).w			;bit 0: clear the left text column too
	jsr	(ClearCardText).l			;clear it
	bclr	#0,(sflags6).w			;back off
	move.w	#$64,(palcount).w		;fade over $64 frames
	jsr	(printz).l					;map 2 (priority) at 0,0
	String	-(TXPRI+TXMAP2),0,0
	move.w	#8,d1					;row 8
	jsr	(PrintCardTeam).l			;team name
	move.w	#3,d0					;column 3
	move.w	#$F,d1					;row $F
	jsr	(PrintStartingLine).l		;starting line
	move.w	#8,d0					;column 8
	move.w	#$B,d1					;row $B
	jsr	(PrintTeamRating).l			;team rating
	move.w	#$15,(printx).w			;column $15
	move.w	#$C,(printy).w			;row $C
	move.w	(printx).w,-(sp)		;save the column
	jsr	(printsmallz).l				;print
	String	'  Records'
	move.w	(sp)+,(printx).w		;same column
	addq.w	#1,(printy).w			;next row
	jsr	(printsmallz).l				;print
	String	'-----------'
	move.w	(HomeTeam).w,d1			;home team
	tst.w	(cardvis).w				;which side?
	beq.w	.0
	move.w	(VisTeam).w,d1			;visitors
.0									;team side chosen: its crowd record block
	ext.l	d1						;team
	movea.l	#recordbuf,a0			;record buffer
	move.l	a0,-(sp)				;keep it
	jsr	(ReadCrowdRecord).l			;read the crowd records
	move.w	#$15,d0					;column $15
	move.w	#$E,d1					;row $E
	move.b	(a0),d2					;goals record
	move.b	crgoalsuser(a0),d3		;user
	move.b	crgoalsoppuser(a0),d4	;opponent user
	move.b	crgoalsopp(a0),d5		;opponent team
	bsr.w	PrintGoalRecordLine		;print it
	movea.l	(sp),a0					;record buffer
	move.w	#$15,d0					;column $15
	move.w	#$12,d1					;row $12
	move.b	crsaves(a0),d2			;saves record
	move.b	crsavesuser(a0),d3		;user
.1									;(not branched to)
	move.b	crsavesoppuser(a0),d4	;opponent user
	move.b	crsavesopp(a0),d5		;opponent team
	bsr.w	PrintSaveRecordLine		;print it
	movea.l	(sp)+,a0				;record buffer
	move.w	#$15,d0					;column $15
	move.w	#$16,d1					;row $16
	move.b	crpeak(a0),d2			;crowd peak record
	move.b	crpeakuser(a0),d3		;user
	move.b	crpeakoppuser(a0),d4	;opponent user
	move.b	crpeakopp(a0),d5		;opponent team
	bsr.w	PrintCrowdRecordLine	;print it
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
ClearCardText						;Player card: erase the text area and redraw the team bitmap behind it
									;(dobitmap)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	jsr	(printz).l					;map 2 (priority) at 0,0
	String	-(TXPRI+TXMAP2),0,0
	move.w	d0,(printx).w			;column
	move.w	d1,(printy).w			;row
	move.w	(cardlogochars1).w,d4	;first logo char
	move.w	(HomeTeam).w,d3			;home team
	tst.w	(cardvis).w				;which side?
	beq.w	.0
	move.w	(VisTeam).w,d3			;visitors
.0									;team side chosen: its logo
	asl.w	#2,d3					;4 bytes per TeamLogoBitmaps entry
	movea.l	#TeamLogoBitmaps,a0
	movea.l	0(a0,d3.w),a0			;logo bitmap
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2					;a2 = offsets
	adda.l	(a2)+,a0				;a0 = tile data
	asl.w	#3,d3					;32 bytes of logo palette per team
	movea.l	#TeamLogoPalettes,a0
	subi.w	#$20,d3					;less one team (palettes start at team 1)
	adda.w	d3,a0					;a0 = logo palette
	adda.l	(a2)+,a1				;a1 = map data
	move.w	#6,d3					;height 6
	move.w	#6,d2					;width 6
	clr.w	d0						;x 0
	clr.w	d1						;y 0
	move.l	(palfadenew+$22).w,-(sp)	;keep palette colors $22-$29: dobitmap overwrites them
	move.l	(palfadenew+$26).w,-(sp)
	move.w	#2,d5					;palette 2
	jsr	(dobitmap).l				;draw the logo
	move.l	(sp)+,(palfadenew+$26).w	;restore the colors
	move.l	(sp)+,(palfadenew+$22).w
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
PrintCrowdRecordLine				;Player card record line: the arena crowd record (CrowdLevelTxt,
									;PrintCardRecordLine)
	move.l	#CrowdLevelTxt,(TempMaxSpd).l	;label text
	bra.w	PrintCardRecordLine		;print the line
CrowdLevelTxt	dc.b	0			;PrintCrowdRecordLine text
	dc.b	$12,$20
	dc.b	$64						;d
	dc.b	$42						;B
	dc.b	$20
	dc.b	$43						;C
	dc.b	$72						;r
	dc.b	$6F						;o
	dc.b	$77						;w
	dc.b	$64						;d
	dc.b	$20
	dc.b	$4C						;L
	dc.b	$65						;e
	dc.b	$76						;v
	dc.b	$65						;e
	dc.b	$6C						;l
	dc.b	0
PrintSaveRecordLine					;Player card record line: the saves record (CardSavesTxt / CardSavesByTxt,
									;PrintCardRecordLine)
	movem.l	a1-a3,-(sp)				;save
	movea.l	#CardSavesTxt,a1
	tst.w	d3						;d3 = holder user: "by" form when there is one
	beq.w	.0
	movea.l	#CardSavesByTxt,a1
.0									;form chosen: one save uses the singular String that follows
	cmp.b	#1,d2					;one save?
	bne.w	.1
	adda.w	(a1),a1					;next String
.1									;text chosen for PrintCardRecordLine
	move.l	a1,(TempMaxSpd).w		;label text
	movem.l	(sp)+,a1-a3				;restore
	bra.w	PrintCardRecordLine		;print the line
CardSavesTxt	dc.b	0			;PrintSaveRecordLine text
	dc.b	$A,$20
	dc.b	$53						;S
	dc.b	$61						;a
	dc.b	$76						;v
	dc.b	$65						;e
	dc.b	$73						;s
	dc.b	$20,0,0,8,$20
	dc.b	$53						;S
	dc.b	$61						;a
	dc.b	$76						;v
	dc.b	$65						;e
	dc.b	$20
CardSavesByTxt	dc.b	0			;PrintSaveRecordLine text
	dc.b	$C,$20
	dc.b	$53						;S
	dc.b	$61						;a
	dc.b	$76						;v
	dc.b	$65						;e
	dc.b	$73						;s
	dc.b	$20
	dc.b	$62						;b
	dc.b	$79						;y
	dc.b	0,0,$A,$20
	dc.b	$53						;S
	dc.b	$61						;a
	dc.b	$76						;v
	dc.b	$65						;e
	dc.b	$20
	dc.b	$62						;b
	dc.b	$79						;y
PrintGoalRecordLine					;Player card record line: the goals record (CardGoalsTxt / CardGoalsByTxt,
									;PrintCardRecordLine)
	movem.l	a1-a3,-(sp)				;save
	movea.l	#CardGoalsTxt,a1
	tst.w	d3						;d3 = holder user: "by" form when there is one
	beq.w	.0
	movea.l	#CardGoalsByTxt,a1
.0									;form chosen: one goal uses the singular String that follows
	cmp.b	#1,d2					;one goal?
	bne.w	.1
	adda.w	(a1),a1					;next String
.1									;text chosen for PrintCardRecordLine
	move.l	a1,(TempMaxSpd).w		;label text
	movem.l	(sp)+,a1-a3				;restore
	bra.w	PrintCardRecordLine		;print the line
CardGoalsTxt	dc.b	0			;PrintGoalRecordLine text
	dc.b	$A,$20
	dc.b	$47						;G
	dc.b	$6F						;o
	dc.b	$61						;a
	dc.b	$6C						;l
	dc.b	$73						;s
	dc.b	$20,0,0,8,$20
	dc.b	$47						;G
	dc.b	$6F						;o
	dc.b	$61						;a
	dc.b	$6C						;l
	dc.b	$20
CardGoalsByTxt	dc.b	0			;PrintGoalRecordLine text
	dc.b	$C,$20
	dc.b	$47						;G
	dc.b	$6F						;o
	dc.b	$61						;a
	dc.b	$6C						;l
	dc.b	$73						;s
	dc.b	$20
	dc.b	$62						;b
	dc.b	$79						;y
	dc.b	0,0,$A,$20
	dc.b	$47						;G
	dc.b	$6F						;o
	dc.b	$61						;a
	dc.b	$6C						;l
	dc.b	$20
	dc.b	$62						;b
	dc.b	$79						;y
PrintCardRecordLine					;Print a player card record line: label (appstring), value (AppendNumber /
									;AppendUserName / AppendTeamName)
	tst.b	d2
	bne.w	.0						;no record value: print nothing
	rts								;return
.0									;record value: number, label, then the user names
	move.w	d0,(printx).w			;column
	move.w	d1,(printy).w			;row
	move.w	d2,d0					;record value
	andi.w	#$FF,d0					;byte
	movea.l	#mesarea,a1				;line buffer
	move.l	a1,-(sp)				;keep it
	jsr	(AppendNumber).l			;value as a String
	movea.l	(sp)+,a1				;line buffer
	movea.l	a1,a3					;output
	movea.l	(TempMaxSpd).w,a1		;the label chosen by the caller
	jsr	(appstring).l				;append the label
	move.w	(printx).w,-(sp)		;save the column
	movea.l	#mesarea,a1				;line buffer
	jsr	(printsmall).l				;print it
	move.w	(sp)+,(printx).w		;same column
	addq.w	#1,(printy).w			;next row
	movea.l	#mesarea,a1				;line buffer
	move.w	d3,d2					;next line: the holder (d3) "vs." ...
	ext.w	d2
	bset	#7,(sflags6).w			;record name list
	jsr	(AppendUserName).l			;holder's name
	movea.l	a1,a3					;output
	movea.l	#CardVsTxt,a1			;" vs."
	jsr	(appstring).l				;append it
	move.w	(printx).w,-(sp)		;save the column
	movea.l	#mesarea,a1				;line buffer
	jsr	(printsmall).l				;print it
	move.w	(sp)+,(printx).w		;same column
	addq.w	#1,(printy).w			;next row
	move.w	d4,d2					;next line: the opponent user (d4) and his team (d5)
	ext.w	d2
	movea.l	#mesarea,a1				;line buffer
	bset	#7,(sflags6).w			;record name list
	jsr	(AppendUserName).l			;opponent user's name
	movea.l	a1,a3					;output
	movea.l	#CardEmptyTxt,a1		;separator
	jsr	(appstring).l				;append it
	move.w	d5,d0					;opponent team
	movea.l	#mesarea,a1				;line buffer
	jsr	(AppendTeamName).l			;append its name
	movea.l	#mesarea,a1				;line buffer
	jsr	(printsmall).l				;print it
	rts								;return
CardVsTxt	dc.b	0				;PrintCardRecordLine text
	dc.b	6,$20
	dc.b	$76						;v
	dc.b	$73						;s
	dc.b	$2E
CardEmptyTxt	dc.b	0			;PrintCardRecordLine text
	dc.b	4,$20,0
AppendTeamName						;Append the city name of team d0 (TeamList block Strings) to a1
									;(appstring)
	movem.l	d0/a0-a3,-(sp)			;save
	ext.w	d0						;team
	asl.w	#2,d0					;long index
	movea.l	#TeamList,a0			;team address table
	movea.l	0(a0,d0.w),a0			;team data
	move.w	Teamname(a0),d0			;offset of the team's Strings block
	ext.l	d0
	adda.l	d0,a0					;a0 = Strings block
	adda.w	(a0),a0					;first String: the city
	movea.l	a1,a3					;output
	movea.l	a0,a1					;city name
	jsr	(appstring).l				;append it
	movem.l	(sp)+,d0/a0-a3			;restore
	rts								;return
PrintOverallRating					;Player card "Overall Rating" (CalcAttrib, AttribAdjust)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	move.w	d1,(printx).w			;column
	move.w	d2,(printy).w			;row
	move.w	d1,-(sp)				;save the column
	jsr	(printsmallz).l				;print
	String	'Overall'
	move.w	(sp)+,(printx).w		;same column
	addq.w	#1,(printy).w			;next row
	jsr	(printsmallz).l				;print
	String	'Rating   '
	movea.l	#tmstruct,a2			;home team stats
	tst.w	(cardvis).w				;which side?
	beq.w	.0
	movea.l	#AwShots,a2				;visitors stats
.0									;team side chosen
	move.l	(PAttribOverallMask).l,d4	;skater mask, or the goalie mask on a goalie card
	tst.w	(matchup).w				;goalie card?
	beq.w	.1
	move.l	(GAttribOverallMask).l,d4
.1									;mask chosen
	bsr.w	CalcAttrib				;d0 = total, d1 = maximum
	mulu.w	#$64,d0					;scale to a 0-99 rating
	divu.w	d1,d0
	bsr.w	AttribAdjust			;rating adjustment
	movea.l	#mesarea,a1				;output
	bsr.w	AppendNumber			;rating as a String
	movea.l	#mesarea,a1				;output
	jsr	(printsmall).l				;print it
	movem.l	(sp)+,d0-d7/a0-a6		;restore
CardStub							;An rts with no caller
	rts
PrintStartingLine					;Player card "Starting Line": the line slots the player starts in
									;(LinePosNames position names)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	move.w	(HomeTeam).w,d2			;home team
	bsr.w	GetTeamStruct			;its team struct
	tst.w	(cardvis).w				;home team struct unless this is the visitors card
.0									;(not branched to)
	beq.w	.1
	move.w	(VisTeam).w,d2			;visitors
	bsr.w	GetTeamStruct			;its team struct
.1									;team side chosen: its line sets (LineSets)
	movea.l	#TeamList,a0			;team address table
	asl.w	#2,d2					;long index
	ext.l	d2
	adda.l	d2,a0
	movea.l	(a0),a0					;team data
	move.w	LineSets(a0),d2			;offset of the line sets
	ext.l	d2
	adda.l	d2,a0					;a0 = line sets
	move.w	d0,(printx).w			;column
	move.w	d1,(printy).w			;row
	move.w	d0,-(sp)				;save the column
	jsr	(printsmallz).l				;print
	String	'Starting Line'
	addq.w	#2,(printy).w			;two rows down
	move.w	(sp),(printx).w			;same column
	movea.l	#LinePosNames,a1
.loop								;one position per row
	cmpi.w	#2,(a1)					;the empty String ends the list
	beq.w	.2						;done
	move.w	(sp),(printx).w			;same column
	move.l	a1,-(sp)				;keep the name
	jsr	(printsmall).l				;print the position name
	move.b	(a0)+,d0				;roster slot (1-based) of this position
	ext.w	d0
	subq.w	#1,d0					;0-based
	jsr	(FormatPlayerNameShort).l	;his short name
	jsr	(printsmall).l				;print it
	movea.l	(sp)+,a1				;position name
	move.w	(a1),d0					;its length
	ext.l	d0
	adda.l	d0,a1					;next position name
	addq.w	#1,(printy).w			;next row
	bra.s	.loop					;loop
.2									;all positions printed
	move.w	(sp)+,d0				;drop the column
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
LinePosNames						;Position names; an empty String ends the list
	String	'G   '
	String	'LD  '
	String	'RD  '
	String	'LW  '
	String	'C   '
	String	'RW  '
	dc.w	2
CalcAttrib							;The overall rating of player d0: his attributes weighted by
									;OvrPlayerWgtList (skaters) or
									;OvrGoalWgtList (goalies), and by AttribWgtList. Called from
									;getNameandAttrib and PrintOverallRating
	move.l	a6,-(sp)				;push a6 to stack
	clr.w	(OvrDivisor).w
	clr.w	(OvrDividend).w
	movea.l	#AttribWgtList,a6		;a6 = AttribWgtList
	cmp.l	(PAttribOverallMask).l,d4	;compare long word (1FBA000A) to d4
	bne.w	.1						;branch if not equal
	movea.l	#OvrPlayerWgtList,a6	;a6 = OvrPlayerWgtList
.1									;not the skater mask: maybe the goalie mask
	cmp.l	(GAttribOverallMask).l,d4	;compare long word 130F000A to d4
	bne.w	.11						;branch if not equal
	movea.l	#OvrGoalWgtList,a6		;a6 = OvrGoalWgtList
.11									;weight list chosen (AttribWgtList unless an overall mask)
	movea.l	tmdata(a2),a0			;move ROM address of Team Data into a0
	lea	tmHotCold(a2),a4			;move start of Hot/Cold table to a4
	clr.l	d1						;clear d1
	move.w	d0,d1					;move d0 into d1. d0 is the offset of the player
	asl.w	#4,d1					;mult d1 by 16
	adda.l	d1,a4					;add d1 to a4
	adda.l	#$10,a4					;add 16 dec to a4. Move to start of Hot/Cold for player.
	adda.w	(a0),a0					;add player table offset to Team Data start
.skip								;skip one player record: name length + fixed part
	adda.w	(a0),a0					;add Player Name length to a0
	addq.w	#pldsize,a0				;add 8 (skips attributes)
	dbf	d0,.skip					;skip until at player
	clr.w	d0						;clear d0
	clr.w	d1						;clear d1
	moveq	#$F,d2					;move 15 dec into d2 (start at bit 15)
	swap	d4						;swap words in d4
.bit								;each set bit of the mask is an attribute in the rating
	btst	d2,d4					;bit test d2 bit in d4
	beq.w	.next					;branch if bit is 0
	move.w	d2,d3					;move d2 into d3
	lsr.w	#1,d3					;divide d3 by 2
	neg.w	d3						;negate d3
	move.b	-1(a0,d3.w),d3			;move a0+d3-1 into d3. a0 currently at end of player data.
									;Sets d3 byte to attribute
	btst	#0,d2					;test bit 0 of d2
	beq.w	.0						;branch if equal
	lsr.w	#4,d3					;divide d3 by 16. Shifts upper nibble to lower in case d2 was odd
.0									;attribute nibble in the low 4 bits
	andi.w	#$F,d3					;pass bottom nibble of d3
	cmp.w	#$D,d2					;compare d2 to 13 dec (check if Wgt nibble)
	bne.w	.cont					;branch if not equal
	bra.w	.00
.cont								;d2 <> $D
	cmp.w	#6,d2					;compare d2 to 6 (Fight nibble)
	beq.w	.00
	movem.l	d5-d7,-(sp)				;push to stack
	move.b	0(a6,d2.w),d5			;move a6+d2 into d5
	ext.w	d5						;sign extend d5
	cmp.w	#2,d5					;comare d5 to 2
	beq.w	.000					;branch if equal
	move.w	d3,-(sp)				;push d3 to stack (current attribute)
	subq.w	#2,d5					;sub 2 from d5
.attribadd							;add the attribute d5 - 1 more times, then halve: weight d5 / 2
	add.w	(sp),d3					;add stack value to d3
	dbf	d5,.attribadd				;loop until d5 is 0
	asr.w	#1,d3					;divide d3 by 2
	tst.w	(sp)+					;test stack and increment
.000								;pop the d5-d7 saved above
	movem.l	(sp)+,d5-d7				;pop off stack into d5-d7
	cmpa.l	#AttribWgtList,a6		;check if a6 is AttribWgtList
	beq.w	.2						;branch if equal
	neg.w	d2						;negate d2
	move.w	d7,-(sp)				;push d7 to stack
	move.b	-1(a4,d2.w),d7			;move data at a4+d2-1 into d7
	ext.w	d7						;sign extend d7
	add.w	d7,(OvrDivisor).w		;add d7 to OvrDivisor
	addq.w	#1,(OvrDividend).w		;add 1 to OvrDividend
	move.w	(sp)+,d7				;pop from stack into d7
	neg.w	d2						;negate d2
	bra.w	.00						;branch
.2									;a6 = #AttribWgtList
	move.w	d3,-(sp)				;push d3 onto stack
	asl.w	#4,d3					;mult d3 by 16
	add.w	(sp),d3					;add value on stack to d3
	add.w	(sp)+,d3				;add value again from stack into d3 and increment
	neg.w	d2						;negate d2
	add.b	-1(a4,d2.w),d3			;add data at a4+s2-1 into d3
	bpl.w	.pos					;branch if positive
	clr.b	d3						;clear d3
.pos								;adjusted value clamped at 0
	neg.w	d2						;negate d2
.00									;weighted value ready (or Wgt / Fight, unweighted)
	add.w	d3,d0					;add d3 to d0 (d0 = attribute value)
	addi.w	#$64,d1					;'d'   ; add 100 dec to d1
.next								;next mask bit
	dbf	d2,.bit
	cmpa.l	#AttribWgtList,a6		;compare AttribWgtList with a6
	beq.w	.3						;branch if equal
	move.w	#$64,d1					;'d'   ; move 100 dec into d1
	movem.l	d6-d7,-(sp)				;push d6 and d7 to stack
	move.w	(OvrDivisor).w,d6		;move into d6
	ext.l	d6						;word extend d6
	move.w	(OvrDividend).w,d7		;move into d7
	divs.w	d7,d6					;divide d7 into d6
	add.w	d6,d0					;add d6 to d0
	movem.l	(sp)+,d6-d7				;pop from stack
.3									;rating summed: keep it below the maximum d1
	cmp.w	d1,d0
	blt.w	.4
	move.w	d0,d1
	subq.w	#1,d0
.4									;rating in range
	movea.l	(sp)+,a6
	rts
OvrPlayerWgtList	dc.b	2		;CalcAttrib skater weights
	dc.b	2,2,2,4,6,2,4,2,4,6,6,4,2,2,2
OvrGoalWgtList	dc.b	2			;CalcAttrib goalie weights
	dc.b	2,2,2,2,2,2,2,9,9,2,2,9,2,2,2
AttribWgtList	dc.b	2			;CalcAttrib attribute weights
	dc.b	2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
PrintCardPosition					;Player card position: Goalie, Forward or Defenseman (from the roster
									;index: GetGoalieCount, GetDefenseStart)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	movea.l	#mesarea,a1				;output
	bsr.w	GetJerseyString
	move.w	d1,(printx).w			;column
	move.w	d2,(printy).w			;row
	jsr	(printsmall).l				;print the number
	movea.l	#tmstruct,a2			;home team stats
	tst.w	(cardvis).w				;which side?
	beq.w	.0
	movea.l	#AwShots,a2				;visitors stats
.0									;team side chosen
	move.w	d0,-(sp)				;keep the index
	jsr	(GetDefenseStart).l			;index at or past the defense start: not a forward
	cmp.w	(sp),d0					;against the index
	ble.w	.2						;index below the defense start: forward or goalie
	move.w	(sp),d0					;index
	jsr	(GetGoalieCount).l			;d0 = goalie count
	cmp.w	(sp),d0					;against the index
	ble.w	.1						;index below the goalie count: goalie
	jsr	(printsmallz).l
	String	' Goalie'
	bra.w	.3						;done
.1									;between goalies and defense: a forward
	jsr	(printsmallz).l
	String	' Forward'
	bra.w	.3						;done
.2									;defense start or later: a defenseman
	jsr	(printsmallz).l
	String	' Defenseman'
.3									;drop the saved index
	tst.w	(sp)+
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
PrintTeamRating						;Player card "Team Rating" (GetTeamRating, high ROM)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	move.w	d0,(printx).w			;column
	move.w	d1,(printy).w			;row
	move.w	d0,-(sp)				;save the column
	jsr	(printsmallz).l				;print
	String	'Team'
	move.w	(sp)+,(printx).w		;same column
	addq.w	#1,(printy).w			;next row
	jsr	(printsmallz).l				;print
	String	'Rating  '
.0									;(not branched to)
	movea.l	#tmstruct,a0			;home team
	tst.w	(cardvis).w				;which side?
	beq.w	.1
	movea.l	#AwShots,a0				;visitors
.1									;team side chosen
	movea.l	a0,a2					;team struct
	bsr.w	GetTeamRating			;d0 = team rating
.2									;(not branched to)
	move.w	#2,d1					;2 digits
	jsr	(PushNumberWidth).l			;as a String
.3									;(not branched to)
	jsr	(printsmall).l				;print it
	movem.l	(sp)+,d0-d7/a0-a6		;restore
.x									;exit (also the end of the code above)
	rts
PrintCardTeam						;Player card: the city and nickname of the card's team (GetCardTeam
									;cardvis), each centred (PrintCentered) on rows d1 and d1 + 1
	movem.l	d0-d7/a0-a6,-(sp)		;save
	move.w	d1,(printy).w			;row
	movea.l	#tmstruct,a0			;home team
	tst.w	(cardvis).w				;which side?
	beq.w	.0
	movea.l	#AwShots,a0				;visitors
.0									;team side chosen
	movea.l	tmdata(a0),a0			;team data
	adda.w	Teamname(a0),a0			;team Strings
.1									;(not branched to)
	bsr.w	PrintCentered			;city
	adda.w	(a0),a0					;skip the city String to the nickname
	adda.w	(a0),a0
	addq.w	#1,(printy).w			;next row
	bsr.w	PrintCentered			;nickname
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts								;return
PrintCentered						;printsmall String a0 centred on column $14
	move.w	#$14,(printx).w
	move.w	(a0),d0					;String length
	subq.w	#2,d0					;half the text length left of the centre
	lsr.w	#1,d0
	sub.w	d0,(printx).w			;start column
	movea.l	a0,a1					;the String
	jmp	printsmall					;print it
GetJerseyString						;Player d0 of the card's team: his jersey number as a 2 digit String at a1
									;(space for a leading 0)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	movea.l	#tmstruct,a0			;home team
	tst.w	(cardvis).w				;which side?
	beq.w	.0
	movea.l	#AwShots,a0				;visitors
.0									;team side chosen
	movea.l	tmdata(a0),a0			;team data
	move.w	(a0),d1					;player table offset
	ext.l	d1
	adda.l	d1,a0					;first player record
.loop								;skip one player record: name length + 8 fixed bytes
	move.w	(a0),d1
	ext.l	d1
	adda.l	d1,a0
	addq.l	#8,a0
	dbf	d0,.loop					;until past player d0
	subq.l	#8,a0					;back to the jersey byte of the player
	move.w	#4,(a1)+				;String of 2 characters
	move.b	(a0),d0					;jersey byte
	lsr.w	#4,d0					;tens digit (BCD high nibble)
	andi.w	#$F,d0
	bne.w	.1						;no tens: a space
	move.b	#$20,d0
	bra.w	.2
.1									;tens digit as a character
	addi.b	#$30,d0
.2									;tens written: now the ones
	move.b	d0,(a1)+				;write the tens
	move.b	(a0),d0					;jersey byte
	andi.w	#$F,d0					;ones digit
	addi.b	#$30,d0					;'0'
	move.b	d0,(a1)+				;write the ones
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
PrintGoalsAssists					;Player card "Goals" / "Assists" (GetCardTeam)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	bsr.w	GetCardTeam				;a0 = team stats
	move.l	a0,-(sp)				;keep it
	adda.l	#tmgoals,a0				;goals of this game
	move.b	0(a0,d0.w),d3			;this player's goals
	ext.w	d3
	movea.l	(sp)+,a0				;team stats
	adda.l	#tmassists,a0			;assists of this game
	move.b	0(a0,d0.w),d4			;this player's assists
	ext.w	d4
	move.w	d1,(printx).w			;column
	move.w	d2,(printy).w			;row
	move.w	d1,-(sp)				;save the column
	jsr	(printsmallz).l				;print
	String	'Goals    '
	move.w	d0,-(sp)				;save the player
	move.w	d3,d0					;goals
	movea.l	#mesarea,a1				;output
	bsr.w	AppendNumber			;as a String
	move.w	(sp)+,d0				;restore the player
	movea.l	#mesarea,a1				;output
	jsr	(printsmall).l				;print it
	move.w	(sp)+,(printx).w		;same column
	addq.w	#1,(printy).w			;next row
	jsr	(printsmallz).l				;print
	String	'Assists  '
	move.w	d4,d0					;assists
	movea.l	#mesarea,a1				;output
	bsr.w	AppendNumber			;as a String
	movea.l	#mesarea,a1				;output
	jsr	(printsmall).l				;print it
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
PrintSaves							;Player card "Saves" / "Save %" (GetCardTeam)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	bsr.w	GetCardTeam				;a0 = team stats
	move.l	a0,-(sp)				;keep it
	adda.l	#tmgoals,a0				;goals against
.0									;(not branched to)
	move.b	0(a0,d0.w),d3			;this goalie's goals against
	ext.w	d3
	movea.l	(sp)+,a0				;team stats
	adda.l	#tmpshots,a0			;shots against
	move.b	0(a0,d0.w),d4			;this goalie's shots against
	ext.w	d4
	move.w	d4,d7					;d7 = shots
	sub.w	d3,d7					;saves = shots - goals
	move.w	d1,(printx).w			;column
	move.w	d2,(printy).w			;row
	move.w	d1,-(sp)				;save the column
	jsr	(printsmallz).l				;print
	String	'Saves    '
	move.w	d7,d0					;saves
	movea.l	#mesarea,a1				;output
	move.l	a1,-(sp)				;keep it
	bsr.w	AppendNumber			;as a String
	movea.l	(sp)+,a1				;output
	jsr	(printsmall).l				;print it
	move.w	(sp)+,(printx).w		;same column
	addq.w	#1,(printy).w			;next row
	jsr	(printsmallz).l				;print
	String	'Save %   '
	move.w	d7,d0					;saves
	mulu.w	#$64,d0					;save % = saves * 100 / shots
	tst.w	d4						;any shots?
	bne.w	.1						;no shots: 0%
	clr.w	d0
	bra.w	.2						;print it
.1									;shots faced: divide
	divu.w	d4,d0
.2									;print the percentage
	movea.l	#mesarea,a1				;output
	move.l	a1,-(sp)				;keep it
	bsr.w	AppendNumber			;as a String
	movea.l	(sp)+,a1				;output
	jsr	(printsmall).l				;print it
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
DrawPlayerPicture					;Draw the player picture (NoPicSkater1 ... NoPicGoalie2, Card<player>)
	movem.l	d0-d7/a1-a6,-(sp)		;save
	movea.l	#FeaturedPictures,a0	;featured picture lists
	move.w	d1,d2					;team
	asl.w	#2,d2					;long index
	movea.l	0(a0,d2.w),a0			;this team's list
	move.w	#$FFFF,d2				;d2 = entry counter
	bra.w	.1
.loop								;this team's featured list: look for player d0
	cmp.w	4(a0),d0
	bne.w	.0						;not him: next entry
	movea.l	(a0),a0					;his picture
	bra.w	.x						;done
.0									;not this entry: skip picture.l + index.w
	addq.l	#6,a0
.1									;stop at the 0 that ends the list
	addq.w	#1,d2
	tst.l	(a0)
	bne.s	.loop
	movea.l	#TeamList,a0			;no own picture: pick a generic one
	asl.w	#2,d1					;long index
	movea.l	0(a0,d1.w),a0			;team data
	movea.l	a0,a6					;a6 = team data
	move.w	d0,d6					;player
	adda.w	(a6),a6					;first player record
	bra.w	.2						;skip d6 players
.loop2								;skip one player record: name length + fixed part
	adda.w	(a6),a6
	addq.w	#pldsize,a6
.2									;loop until the player is reached
	dbf	d6,.loop2
	adda.w	(a6),a6					;past his name
	adda.w	GoalieOdds(a0),a0		;goalie weights
	move.w	(a0),d1					;goalie word
	clr.w	d3						;count
.loop3								;count the goalie nibbles
	addq.w	#1,d3
	asl.w	#4,d1					;next nibble
	bne.s	.loop3
	movea.l	#NoPicGoalie1,a0
	btst	#0,4(a6)				;bit 0 of the player byte picks one of the two generic pictures
	bne.w	.3
	movea.l	#NoPicGoalie2,a0
.3									;generic goalie picked: goalies stop here
	cmp.w	d3,d0					;a skater: the generic skater picture instead
	blt.w	.x						;goalie: done
	movea.l	#NoPicSkater2,a0
	btst	#0,4(a6)				;same bit picks the skater picture
	bne.w	.x						;NoPicSkater2
	movea.l	#NoPicSkater1,a0
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a1-a6
	rts								;return
DrawPictureBox						;Player card picture box (DrawPlayerPicture, UnpackPicture)
	movem.l	d0-d7/a0-a6,-(sp)		;save
	bsr.w	GetCardPlayer			;d0 = roster index of the card
	move.w	(HomeTeam).w,d1			;home team
	tst.w	(cardvis).w				;which side?
	beq.w	.0
	move.w	(VisTeam).w,d1			;visitors
.0									;team side chosen
	bsr.w	DrawPlayerPicture		;a0 = his picture
	jsr	(printz).l					;map 2 (priority, palette 3) at 1,8
	String	-(TXPRI+TXPAL3+TXMAP2),1,8
	move.w	(cardlogochars2).w,d4	;picture chars
	movea.l	a0,a1					;a1 = picture header
	movea.l	a0,a2					;a2 = offsets
	adda.l	(a2)+,a0				;a0 = tile data
	movea.l	#PicturePalette,a0		;palette from PicturePalette
	adda.l	(a0),a0
	tst.l	(a2)					;no map: the PicturePalette one
	bne.w	.1
	movea.l	#PicturePalette,a1		;default map
	adda.l	jimdata(a1),a1			;its map data
	tst.l	(a2)+					;skip the map offset
	bra.w	.2
.1									;picture has its own map
	adda.l	(a2)+,a1
.2									;both: unpack into picturebuf
	bsr.w	UnpackPicture
	movea.l	#picturebuf,a2			;tiles
	move.w	#6,d3					;height 6
	move.w	#6,d2					;width 6
	clr.w	d0						;x 0
	clr.w	d1						;y 0
	movem.l	d0/a0-a1,-(sp)			;save
	adda.w	#$20,a0					;the picture's 16 colors into palette 3
	movea.l	#palfadenew+$40,a1
	move.w	#7,d0					;8 longs
.loop								;copy 8 longs
	move.l	(a0)+,(a1)+
	dbf	d0,.loop					;next long
	movem.l	(sp)+,d0/a0-a1			;restore
	move.w	#0,d5					;palette 0
	jsr	(dobitmap).l				;draw the picture
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
GetCardTeam							;a0 = tmstruct, or AwShots when cardvis is set (the card's team)
	movea.l	#tmstruct,a0			;home team
	tst.w	(cardvis).w				;which side?
	beq.w	.x
	movea.l	#AwShots,a0				;visitors
.x									;exit (also the end of the code above)
	rts
TrimSpaces							;Trim the trailing spaces of String a2 and pad it to an even length
	movem.l	a3,-(sp)				;save
	movea.l	a2,a3					;String
	adda.w	(a2),a3					;a3 = end of the String
.loop								;loop
	move.b	-(a3),d0				;last character
	cmp.b	#$20,d0					;space?
	bne.w	.0						;last character not a space: done
	move.b	#0,(a3)					;clear it
	subq.w	#1,(a2)					;one shorter
	bra.s	.loop					;loop
.0									;add the header and round up to even
	addq.w	#1,(a2)
	andi.w	#$FE,(a2)
	movem.l	(sp)+,a3				;restore
	rts								;return
GetCardPlayer						;cardplayer = the roster index of card cardindex from the card's team list
									;(homecardlist, awaycardlist)
	movem.l	d1/a0,-(sp)				;save
	movea.l	#homecardlist,a0		;home card list
	tst.w	(cardvis).w				;which side?
	beq.w	.0
	movea.l	#awaycardlist,a0		;visitors card list
.0									;team side chosen
	move.w	(cardindex).w,d1		;card number
	subq.w	#1,d1					;cardindex is 1-based
	move.b	0(a0,d1.w),d0			;roster index
	ext.w	d0
	move.w	d0,(cardplayer).w		;store it
	movem.l	(sp)+,d1/a0				;restore
	rts								;return
BuildCardPlayerLists				;Build the player card order of both teams: home at homecardlist, away at
									;awaycardlist
	movem.l	d0-d7/a0-a6,-(sp)		;save
	movea.l	#homecardlist,a1		;home list
	movea.l	#tmstruct,a0			;home team stats
	bsr.w	BuildCardPlayerList		;build it
	movea.l	#awaycardlist,a1		;away list
	movea.l	#AwShots,a0				;away team stats
	bsr.w	BuildCardPlayerList		;build it
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
BuildCardPlayerList					;Player card order of team a0 into a1: the 6 starters (the first line of
									;LineSets) first, the other roster slots after them
	movea.l	tmdata(a0),a0			;team data
	adda.w	LineSets(a0),a0			;its line sets
	movea.l	a1,a2					;a2 = after the starters
	addq.w	#6,a2					;the 6 starters go first, the rest after them
	clr.w	d0						;roster slot 0
.loop								;each roster slot
	move.w	#5,d1					;6 starter slots
.loop2								;is slot d0 one of the 6 starters?
	move.b	0(a0,d1.w),d3			;starter slot
	subq.b	#1,d3					;0-based
	cmp.b	d3,d0					;this one?
	beq.w	.0
	dbf	d1,.loop2					;next starter
	move.b	d0,(a2)+				;not a starter: after the starters
	bra.w	.1
.0									;a starter: in the first 6
	move.b	d0,(a1)+				;first 6
.1									;next roster slot
	addq.w	#1,d0					;next slot
	cmp.w	#RosterSlots,d0
	blt.s	.loop					;loop
	rts								;return
