;	HOCKEY.BIN $FF56-$104E1 (runtime $2AF56-$2B4E1): logos94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	TeamLogoPalettes, the lead song and ClearPenalties are the cartridge's. CD: a few palette
;	words differ, and the hot / cold icons come through the graphics pointer table ($47D98, $47D9C).

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

null	equ	$1B008
ChooseSong	equ	$2A478
dobitmap	equ	$387E2
eraser	equ	$38C06

	org	$2AF56

;	Team logo palettes, then LeadSong, ClearPenalties and the hot/cold icon.
;	New in 94. ROM-contiguous from TeamLogoPalettes through HotColdIcon.

TeamLogoPalettes					;Team logo palettes, 16 colors per team. Used by PeriodStatsScreen,
									;ClearCardText, DrawMatchupLogo and DrawTeamLogo
									;24 are the matchup logo palettes of TeamPalettes and incbin those files;
									;BOS, FLA, HFD and SJ differ and have their own
	incbin	..\cdbin\HOCKEY.BIN,$FF56,32	;ANH, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$FF76,32	;BOS: differs from MatchupPalBOSA.pal (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$FF96,32	;BUF, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$FFB6,32	;CGY, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$FFD6,32	;CHI, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$FFF6,32	;DAL, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$10016,32	;DET, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$10036,32	;EDM, the TeamPalettes matchup logo palette (from the disc file)
;CD: no cartridge twin
	dc.w	$0E0E
	ori.b	#$8C,d0
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EEE
	dc.w	$0000,$0E00
	dc.w	$0400,$0600
	dc.w	$000E
	dc.w	$000A
	dc.w	$0288
	andi.w	#$2AA,-(a6)
	dc.w	$0CCC
	incbin	..\cdbin\HOCKEY.BIN,$10076,32	;HFD: differs from MatchupPalHFDA.pal (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$10096,32	;LA, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$100B6,32	;MTL, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$100D6,32	;NJ, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$100F6,32	;NYI, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$10116,32	;NYR, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$10136,32	;OTW, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$10156,32	;PHI, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$10176,32	;PIT, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$10196,32	;QUE, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$101B6,32	;SJ: differs from MatchupPalSJA.pal (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$101D6,32	;STL, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$101F6,32	;TB, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$10216,32	;TOR, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$10236,32	;VAN, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$10256,32	;WSH, the TeamPalettes matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$10276,32	;WPG, the TeamPalettes matchup logo palette (from the disc file)
;CD: no cartridge twin
	dc.w	$0EE8
	ori.b	#$6A,d6
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EEE
	dc.w	$0000,$0AAA
	dc.w	$0888
	addi.l	#$444022C,d4
	dc.w	$0008
	dc.w	$0880
	addi.w	#$440,-(a0)
	dc.w	$0EE8
	ori.b	#$6A,d6
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EEE
	dc.w	$0000,$0AAA
	dc.w	$0888
	subi.w	#$444,-(a6)
	andi.b	#$8,$400(a4)
	dc.w	$0800
	dc.w	$0C00
LeadSong							;CD: entered here; the cartridge LeadSong starts at its first twin line,
									;$2B2DA
	movem.l	d0/a0-a3,-(sp)
	move.w	(sflags2).l,-(sp)
	btst.b	#1,(gmode2).l			;shootout?
	bne.w	LeadSongExit			;shootout: no lead songs
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	lea	tmsize(a2),a3
	move.w	tmap(a2),d0				;home players on ice
	sub.w	tmap(a3),d0
	beq.w	LeadSongExit			;tied: no change
	bpl.w	.0
	btst.b	#sf2pwrtm,(sflags2).l	;away ahead: was it already?
	bne.w	.1
	bsr.w	ClearLeadSong			;the lead changed: allow a new song
	bset.b	#sf2pwrtm,(sflags2).l	;away lead noted
	bra.w	.1						;away lead noted
.0									;home ahead
	exg	a2,a3						;a3 = the team ahead
	btst.b	#sf2pwrtm,(sflags2).l	;home lead already noted?
	beq.w	.1
	bsr.w	ClearLeadSong			;the lead changed: allow a new song
	bclr.b	#sf2pwrtm,(sflags2).l	;home lead noted
.1									;lead noted
	bset.b	#sf2pwrplay,(sflags2).l	;one song per lead
	bne.w	LeadSongExit			;already played?
	cmpa.l	#$1834C,a3				;a3 the away struct? (CD: the cartridge has #(tmstruct-M68K_RAM))
	bne.w	.2						;home ahead?
	move.w	(HomeTeam).l,(HmTeam).l	;away ahead: song slot 1
	move.w	#SngPPAway,(SongIndex).l	;away ahead: song slot 1
	jsr	(ChooseSong).l
.loop								;(not looped: a song is now playing)
	bset.b	#6,(sflags8).l			;lead song done
	bra.w	LeadSongExit
.2									;home ahead: song slot 4
	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#SngPP,(SongIndex).l
	jsr	(ChooseSong).l
	bra.w	.loop
ClearLeadSong						;Clear sflags2 bit 5
	bclr.b	#sf2pwrplay,(sflags2).l
	rts
LeadSongExit						;LeadSong exit
	move.w	(sp)+,(sflags2).l
	movem.l	(sp)+,d0/a0-a3
	rts
ClearPenalties						;Clear the penalties: PBnum, Penaltytimer, PenCntDwn, PenBuf and both
									;teams' penalty slots (clrTmPdst). Called from clockcont_0
	movem.l	d0/a0,-(sp)
	clr.w	(PBnum).l				;no penalty box players
	clr.w	(Penaltytimer).l
	clr.w	(PenCntDwn).l
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
;CD: no cartridge twin
	adda.w	#$68,a0
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
	move.w	#2,(iconx).l
	cmpa.l	#tmstruct,a2			;home team?
	bne.w	.0
	movea.l	#homehotplayer,a0		;home: the home lists and column $20
	move.w	#$20,(iconx).l
.0									;team chosen
	move.w	#0,d0					;1 hot player per team
.loop								;is he the hot one?
	move.w	(a0)+,d1
	cmp.w	(iconplayer).l,d1		;this one?
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
	cmp.w	(iconplayer).l,d1		;this one?
	beq.w	.cold
	dbf	d0,.loop2					;neither: clear the icon area
	move.w	(iconx).l,(printx).l
	move.w	#$19,(printy).l
	move.w	#8,d0
	move.w	#3,d1
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l
	bra.w	.x
.hot								;he is hot: the hot icon
	move.w	(hoticonchars).l,d4
;CD: no cartridge twin
	movea.l	(HotMapPtr).l,a0
	bra.w	.draw
.cold								;CD: placed where the disc branches to it
	move.w	(coldiconchars).l,d4
	movea.l	(ColdMapPtr).l,a0
.draw								;draw the icon
	move.w	(iconx).l,(printx).l
	move.w	#$19,(printy).l
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	movea.l	#null,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	moveq	#0,d5					;no palette lines
	jsr	(dobitmap).l
.x									;exit: restore the registers
	movem.l	(sp)+,d0/a0-a1
	rts
