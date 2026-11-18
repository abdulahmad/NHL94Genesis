;	Team logo palettes, then LeadSong, ClearPenalties and the hot/cold icon.
;	New in 94. ROM-contiguous from TeamLogoPalettes through HotColdIcon.

TeamLogoPalettes					;Team logo palettes, 16 colors per team. Used by PeriodStatsScreen,
									;ClearCardText, DrawMatchupLogo and DrawTeamLogo
									;24 are the matchup logo palettes of TeamPalettes and incbin those files;
									;BOS, FLA, HFD and SJ differ and have their own
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalANHA.pal	;ANH, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\TeamLogoPalBOS.pal	;BOS: differs from MatchupPalBOSA.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalBUFA.pal	;BUF, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalCGYA.pal	;CGY, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalCHIA.pal	;CHI, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalDALA.pal	;DAL, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalDETA.pal	;DET, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalEDMA.pal	;EDM, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\TeamLogoPalFLA.pal	;FLA: differs from MatchupPalFLAA.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\TeamLogoPalHFD.pal	;HFD: differs from MatchupPalHFDA.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalLAA.pal	;LA, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalMTLA.pal	;MTL, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalNJA.pal	;NJ, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalNYIA.pal	;NYI, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalNYRA.pal	;NYR, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalOTWA.pal	;OTW, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalPHIA.pal	;PHI, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalPITA.pal	;PIT, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalQUEA.pal	;QUE, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\TeamLogoPalSJ.pal	;SJ: differs from MatchupPalSJA.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalSTLA.pal	;STL, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalTBA.pal	;TB, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalTORA.pal	;TOR, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalVANA.pal	;VAN, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalWSHA.pal	;WSH, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalWPGA.pal	;WPG, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalASEA.pal	;ASE, the TeamPalettes matchup logo palette
	incbin	..\Extracted\NHL94\Graphics\Pals\MatchupPalASWA.pal	;ASW, the TeamPalettes matchup logo palette
TeamLogoPalettesEnd					;end of TeamLogoPalettes (size check below)
	IF (TeamLogoPalettesEnd-TeamLogoPalettes)<>(NumTeams*32)
		inform	3,"TeamLogoPalettes needs one palette per team"
	ENDIF
LeadSong							;Not in a shootout (gmode2 bit 1), scores not level: once (sflags2 bit 5),
									;ChooseSong with SongIndex 1 (home ahead) or 4
									;and sflags8 bit 6; sflags2 is put back on exit. Called from puckfaceoff2
	movem.l	d0/a0-a3,-(sp)
	move.w	(sflags2).w,-(sp)
	btst	#1,(gmode2).w			;shootout?
	bne.w	LeadSongExit			;shootout: no lead songs
	movea.w	#(tmstruct-M68K_RAM),a2
	lea	tmsize(a2),a3
	move.w	tmap(a2),d0				;home players on ice
	sub.w	tmap(a3),d0
	beq.w	LeadSongExit			;tied: no change
	bpl.w	.0
	btst	#sf2pwrtm,(sflags2).w	;away ahead: was it already?
	bne.w	.1
	bsr.w	ClearLeadSong			;the lead changed: allow a new song
	bset	#sf2pwrtm,(sflags2).w	;away lead noted
	bra.w	.1						;away lead noted
.0									;home ahead
	exg	a2,a3						;a3 = the team ahead
	btst	#sf2pwrtm,(sflags2).w	;home lead already noted?
	beq.w	.1
	bsr.w	ClearLeadSong			;the lead changed: allow a new song
	bclr	#sf2pwrtm,(sflags2).w	;home lead noted
.1									;lead noted
	bset	#sf2pwrplay,(sflags2).w	;one song per lead
	bne.w	LeadSongExit			;already played?
	cmpa.w	#(tmstruct-M68K_RAM),a3	;a3 the away struct?
	bne.w	.2						;home ahead?
	move.w	(HomeTeam).w,(HmTeam).w	;away ahead: song slot 1
	move.w	#SngPPAway,(SongIndex).w	;away ahead: song slot 1
	jsr	(ChooseSong).l
.loop								;(not looped: a song is now playing)
	bset	#6,(sflags8).w			;lead song done
	bra.w	LeadSongExit
.2									;home ahead: song slot 4
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#SngPP,(SongIndex).w
	jsr	(ChooseSong).l
	bra.s	.loop
ClearLeadSong						;Clear sflags2 bit 5
	bclr	#sf2pwrplay,(sflags2).w
	rts
LeadSongExit						;LeadSong exit
	move.w	(sp)+,(sflags2).w
	movem.l	(sp)+,d0/a0-a3
	rts
ClearPenalties						;Clear the penalties: PBnum, Penaltytimer, PenCntDwn, PenBuf and both
									;teams' penalty slots (clrTmPdst). Called from clockcont_0
	movem.l	d0/a0,-(sp)
	clr.w	(PBnum).w				;no penalty box players
	clr.w	(Penaltytimer).w
	clr.w	(PenCntDwn).w
	move.w	#$10,d0					;$11 longs
	movea.l	#PenBuf,a0
.loop								;clear PenBuf
	clr.l	(a0)+
	dbf	d0,.loop					;loop
	movea.l	#tmstruct,a0
	bsr.w	clrTmPdst
	movea.l	#awtmstruct,a0
	bsr.w	clrTmPdst
	movem.l	(sp)+,d0/a0
	rts
clrTmPdst							;Put all 26 players of team struct a0 on the bench (tmpdst -2), then the
									;end word -1
	move.w	#$19,d0					;19 = 25 decimal (max roster size)
	adda.w	#$66,a0					;tmpdst
.loop								;mark each player
	move.w	#$FFFE,(a0)+			;-2 = bench
	dbf	d0,.loop
	move.w	#$FFFF,(a0)				;-1 = ice
	rts
HotColdIcon							;The icon by the name of player iconplayer of team a2 at x iconx, y $19:
									;HotMap when he is awayhotplayer /
									;homehotplayer, ColdMap when awaycoldplayer / homecoldplayer, else
									;clear it (eraser)
	movem.l	d0/a0-a1,-(sp)
	movea.l	#awayhotplayer,a0
	move.w	#2,(iconx).w
	cmpa.l	#tmstruct,a2			;home team?
	bne.w	.0
	movea.l	#homehotplayer,a0		;home: the home lists and column $20
	move.w	#$20,(iconx).w
.0									;team chosen
	move.w	#0,d0					;1 hot player per team
.loop								;is he the hot one?
	move.w	(a0)+,d1
	cmp.w	(iconplayer).w,d1		;this one?
	beq.w	.hot
	dbf	d0,.loop					;loop
	movea.l	#awaycoldplayer,a0		;not hot: is he the cold one?
	cmpa.l	#tmstruct,a2			;home team?
	bne.w	.1
	movea.l	#homecoldplayer,a0
.1									;team chosen
	move.w	#0,d0					;1 cold player
.loop2								;check each cold player
	move.w	(a0)+,d1
	cmp.w	(iconplayer).w,d1		;this one?
	beq.w	.cold
	dbf	d0,.loop2					;neither: clear the icon area
	move.w	(iconx).w,(printx).w
	move.w	#$19,(printy).w
	move.w	#8,d0
	move.w	#3,d1
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l
	bra.w	.x
.hot								;he is hot: the hot icon
	move.w	(hoticonchars).w,d4
	movea.l	#HotMap,a0
	bra.w	.draw
.cold								;he is cold: the cold icon
	move.w	(coldiconchars).w,d4
	movea.l	#ColdMap,a0
.draw								;draw the icon
	move.w	(iconx).w,(printx).w
	move.w	#$19,(printy).w
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	movea.w	#null,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	moveq	#0,d5					;no palette lines
	jsr	(dobitmap).l
.x									;exit: restore the registers
	movem.l	(sp)+,d0/a0-a1
	rts
