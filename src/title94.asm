;	Title screens and assorted helpers. This file picks the songs, keeps the saved line data and
;	win records, steers the skaters in the shootout, unpacks pictures and team graphics, and shows
;	the high score and title screens with the credits and team logo colors.

ChooseSong							;SongNum = byte SongIndex of the 6 song bytes of team HmTeam, or one of
									;the 8 of RandomSongs at random when 0; $FFFF with gmode bit 4. Called
									;from StartPer, checkgoal, puckshootout and LeadSong
	movem.l	d0-d1/a0-a1,-(sp)
	btst	#gmhl,(gmode).w			;highlight reel?
	beq.w	.0						;not the highlight reel: pick a song
	move.w	#$FFFF,d1				;highlights: no song
	bra.w	.1
.0									;normal game
	bclr	#6,(sflags8).w			;clear sflags8 bit 6
	movea.l	#TeamSongs,a0			;team song table
	movea.l	#RandomSongs,a1			;random song table
	move.w	(HmTeam).w,d0
	mulu.w	#6,d0					;6 song slots per team
	add.w	(SongIndex).w,d0
	clr.w	d1
	move.b	0(a0,d0.w),d1			;team song
	bne.w	.1						;a team song: use it
	move.w	#8,d0					;slot 0: one of the 8 random songs
	jsr	(randomd0).l
	andi.w	#7,d0
	move.b	0(a1,d0.w),d1			;random song
.1									;song chosen ($FFFF in the highlights)
	move.w	d1,(SongNum).w
	movem.l	(sp)+,d0-d1/a0-a1
	rts
TeamSongs							;ChooseSong: 6 songs per team (TeamList order), 0 = random (RandomSongs)
	dc.b	$77,$75,$76,0,$5A,0
	dc.b	$31,$32,$30,0,$5A,$31
	dc.b	$34,$33,$33,$34,$5A,0
	dc.b	$35,$37,$35,$37,$36,$36
	dc.b	$38,$3A,$39,$38,$5A,$65
	dc.b	$4A,$4B,$4B,0,$5A,0
	dc.b	$3B,$3C,$3D,0,$5A,$3C
	dc.b	$3E,$3F,$3F,0,$5A,0
	dc.b	$77,$75,$76,0,$5A,0
	dc.b	$40,$42,$41,$42,$5A,$40
	dc.b	$43,$43,$45,$44,$5A,$46
	dc.b	$4F,$4E,$4F,$4D,$5A,$4C
	dc.b	$50,$51,$50,0,$5A,$52
	dc.b	$47,$48,$47,$49,$5A,$49
	dc.b	$54,$55,$53,0,$5A,0
	dc.b	$77,$75,$76,0,$5A,0
	dc.b	$56,$57,$56,$58,0,$58
	dc.b	$59,$5B,$59,$5C,$5A,$5C
	dc.b	$5D,$5E,$5D,0,$5A,$5E
	dc.b	$5F,$60,$61,$63,$64,$65
	dc.b	$67,$68,$68,$67,$5A,$69
	dc.b	$6A,$6B,$6B,0,$5A,0
	dc.b	$6C,$6C,$6D,0,$5A,0
	dc.b	$6E,$6F,$70,0,$5A,0
	dc.b	$71,$73,$71,0,$5A,$74
	dc.b	$77,$75,$76,0,$5A,0
	dc.b	$54,$55,$53,0,$5A,0
	dc.b	$54,$55,$53,0,$5A,0
TeamSongsEnd						;end of TeamSongs (size check below)
	IF (TeamSongsEnd-TeamSongs)<>(NumTeams*6)
		inform	3,"TeamSongs needs 6 songs per team"
	ENDIF
RandomSongs							;ChooseSong: the 8 songs for a random pick
	dc.b	$34,$40,$42,$49,$58,$5C,$65,$66
ReadLineData						;Read the $100 bytes at save RAM LineDataBase to databuffer; sflags bit 4
									;cleared, lastsfx = -1, recbpr = $FFFF0000. Called from Begin and
									;GameSetUp
	movem.l	d0-d1/a0,-(sp)
	move.l	#$100,d1				;all $100 bytes of line data
	move.l	#LineDataBase,d0
	movea.l	#databuffer,a0
	jsr	(ReadSRAM).l
	bclr	#sfwrap,(sflags).w		;the SRAM routines leave these set: reset them
	move.w	#$FFFF,(lastsfx).w
	move.l	#M68K_RAM,(recbpr).w
	movem.l	(sp)+,d0-d1/a0
	rts
WriteLineData						;Write databuffer back to save RAM at LineDataBase (WriteSRAM,
									;MakeSRAMChecksum); as ReadLineData after. Called from EncodePW and
									;EncodeTeamLines
	movem.l	d0-d1/a0,-(sp)
	move.l	#$100,d1
	move.l	#LineDataBase,d0
	movea.l	#databuffer,a0
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	bclr	#sfwrap,(sflags).w
	move.w	#$FFFF,(lastsfx).w
	move.l	#M68K_RAM,(recbpr).w
	movem.l	(sp)+,d0-d1/a0
	rts
ClearWinRecords						;Clear bytes 8-$B of the 8 ThreeStars records and write the $80 bytes at
									;TeamRecBase (WriteSRAM, MakeSRAMChecksum). Called from
									;RecordHoldersScreen
									;(Record Holders)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#recordbuf,a0
	move.w	#7,d7					;8 user record blocks
.loop								;clear the wins and games of each
	clr.b	urwins(a0)
	clr.b	urwins+1(a0)
	clr.b	urgames(a0)
	clr.b	urgames+1(a0)
	adda.w	#$10,a0					;16 bytes per block
	dbf	d7,.loop
	move.l	#TeamRecBase,d0			;write all $80 bytes back
	move.l	#$80,d1
	movea.l	#recordbuf,a0
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PSandSOpassdir						;Penalty shot / shootout: passdir = sopathdir (the end of the skate path,
									;NextPathPoint), turned by passdirlist for the bottom net. Called from
									;shotdiradj
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(sopathdir).w,d0
	btst	#pfgoal,pflags(a3)		;check what net shooting at
	bne.w	.0						;top net: the direction is already right
	movea.l	#passdirlist,a0			;bottom net: use the mirrored direction
	add.w	d0,d0
	move.w	0(a0,d0.w),d0			;mirrored
.0									;direction ready
	move.w	d0,(passdir).w			;move d0 into passdir
	movem.l	(sp)+,d0-d7/a0-a6
	rts
passdirlist	dc.w	0				;PSandSOpassdir: passdir for the other net
	dc.w	7
	dc.w	6
	dc.w	5
	dc.w	4
	dc.w	3
	dc.w	2
	dc.w	1
	dc.w	8
StartShootoutPath					;Shootout: pick one of the 7 skate paths (ShootoutPaths) at random
									;(sopath) and start it (NextPathPoint). Called from NextShooter and
									;puckshootout
	movem.l	d0-d7/a0-a6,-(sp)
.loop								;random 0-6
	move.w	#7,d0					;random 0-7
	jsr	(randomd0).l
	cmp.w	#6,d0
	bgt.s	.loop					;7 is out of range: pick again
	move.w	d0,(sopath).w
	bclr	#3,(sflags7).w			;not at the path end yet
	move.w	#$FFFF,(sopathpoint).w	;the first NextPathPoint call takes point 0
	clr.w	(sopathx).w
	bsr.w	NextPathPoint
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ShootoutPaths						;The 7 shootout skate paths (NextPathPoint)
	dc.l	ShootoutPath1
	dc.l	ShootoutPath2
	dc.l	ShootoutPath3
	dc.l	ShootoutPath4
	dc.l	ShootoutPath5
	dc.l	ShootoutPath6
	dc.l	ShootoutPath7
ShootoutPath1						;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte:
									;sopathend, then sopathdir)
	dc.w	$10,$E2,$10,$D0,$8020,5
ShootoutPath2						;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte:
									;sopathend, then sopathdir)
	dc.w	$FFC9,$A0,$FFFF,$C8,$FFE0,$D0,$8020,5
ShootoutPath3						;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte:
									;sopathend, then sopathdir)
	dc.w	$FFB0,$40,$1A,$BC,$8020,5
ShootoutPath4						;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte:
									;sopathend, then sopathdir)
	dc.w	$FFCE,$58,$14,$D0,$802C,5
ShootoutPath5						;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte:
									;sopathend, then sopathdir)
	dc.w	$FFCE,8,$20,$D0,$8028,6
ShootoutPath6						;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte:
									;sopathend, then sopathdir)
	dc.w	$1C,$F4,8,$E0,$8020,6
ShootoutPath7						;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte:
									;sopathend, then sopathdir)
	dc.w	$FFE6,$F8,0,$E0,$8020,2
NextPathPoint						;Next point of shootout path sopath: sopathx / sopathy = x (turned by bit
									;0 of handed(a3)) / y; at the end ($80) sflags7 bit 3, sopathend and
									;sopathdir
	movem.l	d0-d7/a0-a6,-(sp)
	cmpi.b	#$80,(sopathx).w		;path already ended: keep the last point
	beq.w	.x
	addq.w	#1,(sopathpoint).w
	move.w	(sopathpoint).w,d0
	asl.w	#2,d0					;4 bytes per point
	movea.l	#ShootoutPaths,a0
	move.w	(sopath).w,d1
	asl.w	#2,d1					;4 bytes per path address
	movea.l	0(a0,d1.w),a0			;its points
	move.w	0(a0,d0.w),(sopathx).w	;point X
	btst	#0,handed(a3)			;left handed: mirror the path
	beq.w	.0
	neg.w	(sopathx).w
.0									;point X ready
	move.w	2(a0,d0.w),(sopathy).w	;point Y
	cmpi.b	#$80,4(a0,d0.w)			;next entry not the end marker: done
	bne.w	.x
	bset	#3,(sflags7).w			;end reached: flag it and keep the end values
	clr.w	(sopathend).w
	move.b	5(a0,d0.w),(sopathend+1).w	;end distance
	move.w	6(a0,d0.w),(sopathdir).w	;end pass direction
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SkatePath							;Shootout skate path: d0 / d1 = the point (mirrored for the bottom net);
									;within $A of it ($12 while Xvel / Yvel(a3) are 0) take the next one
									;(NextPathPoint). Called from asspuckc
	movem.l	d2-d7/a0-a6,-(sp)
	cmpi.b	#$80,(sopathx).w		;path ended?
	beq.w	.x						;path ended: keep heading to the last point
	move.w	(sopathx).w,d0
	move.w	(sopathy).w,d1
	btst	#pfgoal,pflags(a3)		;top net?
	bne.w	.0						;top net: path as stored
	neg.w	d0
	neg.w	d1
.0									;point for this end of the ice
	sub.w	(a3),d0					;minus the player X
	bpl.w	.1
	neg.w	d0
.1									;|dx| ready
	tst.w	Xvel(a3)				;moving?
	bne.w	.2						;moving: the closer limit
	tst.w	Yvel(a3)				;moving?
	bne.w	.2
	cmp.w	#$12,d0					;standing: within $12 is close enough
	ble.w	.3						;close enough
.2									;moving: within $A
	cmp.w	#$A,d0					;within $A?
	bgt.w	.7
.3									;close in X: check Y
	sub.w	Ypos(a3),d1				;minus the player Y
	bpl.w	.4
	neg.w	d1
.4									;|dy| ready
	tst.w	Xvel(a3)				;moving?
	bne.w	.5						;moving: the closer limit
	tst.w	Yvel(a3)				;moving?
	bne.w	.5
	cmp.w	#$12,d1					;standing: within $12
	ble.w	.nextpt					;close enough
.5									;moving: within $A
	cmp.w	#$A,d1					;within $A?
	bgt.w	.7
.nextpt								;close to the point: take the next one
	bsr.w	NextPathPoint
.7									;d0 / d1 = the point to skate to
	move.w	(sopathx).w,d0
	move.w	(sopathy).w,d1
.x									;exit: restore the registers
	movem.l	(sp)+,d2-d7/a0-a6
	rts
ShootoutShootCheck					;Shootout, skater a3 has the puck (gmode2 bit 1): Z set (d0 is restored) =
									;shoot now: after 3 (shootoutclock) at the path
									;end, within sopathend of its last point, or with the puck stopped before
									;$F. Called from asspuckc
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#1,(gmode2).w			;shootout?
	beq.w	.yes					;not a shootout: shoot whenever
	move.w	SCnum(a3),d0
	cmp.w	(puckc).w,d0			;puck carrier?
	bne.w	.yes					;not the puck carrier: d0 = 1
	cmpi.w	#3,(shootoutclock).w	;past tick 3?
	ble.w	.no						;first 3 ticks: keep skating
	cmpi.b	#$80,(sopathx).w		;path ended?
	beq.w	.no						;path over: skate to the net, no shot yet
	btst	#3,(sflags7).w			;at the path end?
	bne.w	.0						;at the path end: check the distance
	tst.w	(puckvx).w				;puck moving?
	bne.w	.yes					;puck moving: shoot
	tst.w	(puckvy).w				;puck moving?
	bne.w	.yes
	cmpi.w	#$F,(shootoutclock).w	;puck stopped: shoot from tick $F
	blt.w	.no						;before tick $F
	bra.w	.yes
.0									;path end reached: compare the distance to the last point with sopathend
	move.w	(sopathx).w,d0
	move.w	(sopathy).w,d1
	btst	#pfgoal,pflags(a3)		;top net?
	bne.w	.1						;top net: point as stored
	neg.w	d0
	neg.w	d1
.1									;point for this end of the ice
	sub.w	(a3),d0					;minus the player X
	bpl.w	.2
	neg.w	d0
.2									;|dx| ready
	sub.w	Ypos(a3),d1				;minus the player Y
	bpl.w	.3
	neg.w	d1
.3									;|dy| ready
	cmp.w	(sopathend).w,d0		;close enough in X?
	bgt.w	.yes					;farther than sopathend from the last point: d0 = 1
	cmp.w	(sopathend).w,d1		;close enough in Y?
	bgt.w	.yes
.no									;no shot: d0 = 0 (Z set)
	clr.w	d0
	bra.w	.x
.yes								;shoot: d0 = 1
	move.w	#1,d0					;shoot
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
UnpackPicture						;Unpack a picture a2: count.w, then 3 bytes per row of 8 pixels to 4 bit
									;pixels + 5 at picturebuf (count first). Called from DrawPictureBox,
									;DrawMatchupPicture and PlayerCardScreen
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#picturebuf,a0
	movea.l	#picturebits,a1
	move.w	(a2)+,d0				;row count: first word of the picture
	move.w	d0,(a0)+
	asl.w	#3,d0					;8 rows per tile
	subq.w	#1,d0
.loop								;each row: 3 bytes = 8 pixels of 3 bits
	clr.l	(a0)
	clr.l	(a1)
	move.b	(a2)+,(a1)
	move.b	(a2)+,1(a1)
	move.b	(a2)+,2(a1)
	move.l	#0,-(sp)				;build the 8 pixels of 4 bits each, + 5 for the card palette
	move.l	(a1),d2
	andi.l	#$E0000000,d2			;pixel 0 (bits 31-29)
	lsr.l	#1,d2
	addi.l	#$50000000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$1C000000,d2			;pixel 1
	lsr.l	#2,d2
	addi.l	#$5000000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$3800000,d2			;pixel 2
	lsr.l	#3,d2
	addi.l	#$500000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$700000,d2				;pixel 3
	lsr.l	#4,d2
	addi.l	#$50000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$E0000,d2				;pixel 4
	lsr.l	#5,d2
	addi.l	#$5000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$1C000,d2				;pixel 5
	lsr.l	#6,d2
	addi.l	#$500,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$3800,d2				;pixel 6
	lsr.l	#7,d2
	addi.l	#$50,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$700,d2				;pixel 7
	move.w	#8,d5
	lsr.l	d5,d2
	addq.l	#5,d2
	or.l	d2,(sp)
	move.l	(sp)+,(a0)+
	dbf	d0,.loop					;loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts
LoadHomeTeamGfx						;Load the HomeTeam graphics of TeamGfxList to VRAM d4 - $18
									;(DecompressGraphicsPlain). Called from setupice, ClrHor and
									;ReloadRinkGraphics
	move.w	d0,-(sp)
	subi.w	#$18,d4					;the team graphics sit $18 tiles before d4
	movea.l	#TeamGfxList,a2
	move.w	(HomeTeam).w,d0
	asl.w	#2,d0
	movea.l	0(a2,d0.w),a2			;its graphics
	addq.w	#8,a2					;skip the header
	jsr	(DecompressGraphicsPlain).l
	move.w	(sp)+,d0
	rts
TeamGfxList							;LoadHomeTeamGfx: one address per team (TeamList order) in ArenaGfxBank
	dc.l	ArenaGfxBank+$3FB4,ArenaGfxBank+$8BAE,ArenaGfxBank+$42BE,ArenaGfxBank+$45C8
	dc.l	ArenaGfxBank+$48D2,ArenaGfxBank+$4BDC,ArenaGfxBank+$4EE6,ArenaGfxBank+$51F0
	dc.l	ArenaGfxBank+$54FA,ArenaGfxBank+$5804,ArenaGfxBank+$5B0E,ArenaGfxBank+$5E18
	dc.l	ArenaGfxBank+$6122,ArenaGfxBank+$642C,ArenaGfxBank+$6736,ArenaGfxBank+$6A40
	dc.l	ArenaGfxBank+$6D4A,ArenaGfxBank+$7054,ArenaGfxBank+$735E,ArenaGfxBank+$7668
	dc.l	ArenaGfxBank+$7972,ArenaGfxBank+$7C7C,ArenaGfxBank+$7F86,ArenaGfxBank+$8290
	dc.l	ArenaGfxBank+$859A,ArenaGfxBank+$88A4,ArenaGfxBank+$8EB8,ArenaGfxBank+$8EB8
TeamGfxListEnd						;end of TeamGfxList (size check below)
	IF (TeamGfxListEnd-TeamGfxList)<>(NumTeams*4)
		inform	3,"TeamGfxList needs one entry per team"
	ENDIF
PrintPlayerAssists					;Print " (n)": tmassists + d0 of team a2, then the next row at x $E.
									;Called from ShowGoalBox
	movem.l	d0/a2,-(sp)
	jsr	(printz).l					;print " ("
	String	' ('
	adda.w	#tmassists,a2			;assists of this game
	bra.w	PrintParenNumber
PrintPlayerGoals					;As PrintPlayerAssists with tmgoals + d0. Called from ShowGoalBox
	movem.l	d0/a2,-(sp)
	jsr	(printz).l					;print " ("
	String	' ('
	adda.w	#tmgoals,a2				;goals of this game
PrintParenNumber					;PrintPlayerAssists / PrintPlayerGoals: the number (1 to 3 digits,
									;PushNumberWidth) and ")"
	move.b	0(a2,d0.w),d0
	ext.w	d0
	move.w	#1,d1					;width 1 digit
	cmp.w	#9,d0					;over 9?
	ble.w	.0						;up to 9: 1 digit
	move.w	#2,d1					;2 wide
	cmp.w	#$63,d0					;up to 99: 2 digits
	ble.w	.0						;up to 99: 2 digits
	move.w	#3,d1					;3 wide
.0									;width chosen
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l					;print ")"
	String	')'
	addq.w	#1,(printy).w			;the next line of the goal box
	move.w	#$E,(printx).w
	movem.l	(sp)+,d0/a2
	rts
PlaceBoardFall						;A player falling into the boards (SPAboardfront ... SPAbenchcheckl). For
									;frames SPAboardfront / SPAboardback (y to $124 / $FEDC, or $116 / $FEEA
									;by FallXPos) and SPAboardright / SPAbenchcheckr / SPAboardleft /
									;SPAbenchcheckl (x to +-$82 / $88 by attribute bit 3) of SPA(a3): move
									;player a3 half way there. Called from updateplayers
	cmpi.w	#SPAbenchcheckl,SPA(a3)	;left bench check?
	beq.w	.12
	cmpi.w	#SPAbenchcheckr,SPA(a3)	;right bench check?
	beq.w	.8
	cmpi.w	#SPAboardleft,SPA(a3)	;left boards?
	beq.w	.10
	cmpi.w	#SPAboardright,SPA(a3)	;right boards?
	beq.w	.6
	cmpi.w	#SPAboardfront,SPA(a3)	;front boards?
	beq.w	.0
	cmpi.w	#SPAboardback,SPA(a3)	;back boards?
	beq.w	.3
	bra.w	.x						;any other frame: nothing to move
.0									;front boards: the wall Y, closer in near the corners
	move.w	#$124,d0
	cmpi.w	#$56,(FallXPos).w		;right corner: closer wall
	bgt.w	.1
	cmpi.w	#$FFAA,(FallXPos).w		;middle: the full wall
	bgt.w	.2
.1									;near a corner: the closer wall
	move.w	#$116,d0
.2									;wall Y chosen: move half way there
	sub.w	Ypos(a3),d0
	bmi.w	.x						;already past it
	asr.w	#1,d0
	add.w	d0,Ypos(a3)
	bra.w	.x
.3									;back boards: the same at the far end
	move.w	#$FEDC,d0
	cmpi.w	#$56,(FallXPos).w		;right corner: closer wall
	bgt.w	.4
	cmpi.w	#$FFAA,(FallXPos).w		;middle: the full wall
	bgt.w	.5
.4									;near a corner: the closer wall
	move.w	#$FEEA,d0
.5									;wall Y chosen: move half way there
	sub.w	Ypos(a3),d0
	bpl.w	.x						;already past it
	asr.w	#1,d0
	add.w	d0,Ypos(a3)
	bra.w	.x
.6									;right boards: X to the wall
	move.w	#$82,d0
	btst	#3,attribute(a3)		;attribute bit 3: the other wall
	beq.w	.7
	move.w	#$FF7E,d0
.7									;move half way there
	sub.w	(a3),d0
	asr.w	#1,d0
	add.w	d0,(a3)
	bra.w	.x
.8									;right bench boards: a little further out
	move.w	#$88,d0					;bench wall X
	btst	#3,attribute(a3)		;attribute bit 3: the other side
	beq.w	.9
	move.w	#$FF78,d0				;other side
.9									;move half way there
	sub.w	(a3),d0
	asr.w	#1,d0
	add.w	d0,(a3)
	bra.w	.x
.10									;left boards
	move.w	#$FF7E,d0				;wall X
	btst	#3,attribute(a3)		;attribute bit 3: the other side
	beq.w	.11
	move.w	#$82,d0					;other side
.11									;move half way there
	sub.w	(a3),d0
	asr.w	#1,d0
	add.w	d0,(a3)
	bra.w	.x
.12									;left bench boards
	move.w	#$FF78,d0				;bench wall X
	btst	#3,attribute(a3)		;attribute bit 3: the other side
	beq.w	.13
	move.w	#$88,d0					;other side
.13									;move half way there
	sub.w	(a3),d0
	asr.w	#1,d0
	add.w	d0,(a3)
.x									;exit (also the end of the code above)
	rts
GetLeagueCrowdRecord				;d0 = the team (of NumTeams) with the highest crowd record (crpeak)
									;(ReadCrowdRecord; 0 counts as $50). Called from PrintCrowdMeter
	movem.l	d1-d7/a0-a6,-(sp)
	move.w	#NumTeams-1,d1
	ext.l	d1
	clr.w	d7						;d7 = highest so far
	movea.l	#ThreeStars,a0
.loop								;read each team's crowd block
	jsr	(ReadCrowdRecord).l			;read team d1's records
	clr.w	d2
	move.b	crpeak(a0),d2
	bne.w	.0						;a record: use it
	move.w	#$50,d2					;none: $50 dB
.0									;this team's peak
	cmp.w	d7,d2					;higher?
	ble.w	.next
	move.w	d2,d7
	move.w	d1,d0
.next								;next team
	dbf	d1,.loop					;loop
	movem.l	(sp)+,d1-d7/a0-a6
	rts
getFgtbyte							;d0 = fighting byte of a2 / 4. Called from setInjuryType
	clr.w	d0
	move.b	fighting(a2),d0			;move H/F bit into d0 (this is always even)
	lsr.w	#2,d0					;shift 2 right (divide by 4)
	rts
chkFgtBit1							;test bit 1 of fighting(a2). Called from setInjuryType
	btst	#1,fighting(a2)
	rts
RandomFaceoffAnim					;d0 = a random faceoff animation from FaceoffAnims, 6 when fox <= -$40 and
									;foy <= $C0. Called from puckfaceoff
	movem.l	a0,-(sp)
	movea.l	#FaceoffAnims,a0
	move.w	#$64,d0					;random 0-99
	jsr	(randomd0).l
	andi.w	#7,d0
	add.w	d0,d0
	move.w	0(a0,d0.w),d0			;the animation number
	cmpi.w	#$FFC0,(fox).w			;dropped left of center?
	bgt.w	.x						;puck dropped off center: keep the random one
	cmpi.w	#$C0,(foy).w			;dropped below?
	bgt.w	.x
	move.w	#6,d0					;center ice: animation 6
.x									;exit: restore the registers
	movem.l	(sp)+,a0
	rts
FaceoffAnims						;RandomFaceoffAnim animations
	dc.w	3,5,3,1,5,2,3,3,$FFFF
CheckScoreLeader					;Compare tmap (players on ice) of tmstruct / AwShots and test tmteam of
									;the team with more for $13 (SJ); the result is not used (bne.w *+4).
									;Called from puckfaceoff
	movem.l	d0-d2/a0-a2,-(sp)
	movea.l	#tmstruct,a0
	movea.l	#AwShots,a1
	move.w	tmap(a0),d0				;home players on ice
	sub.w	tmap(a1),d0
	beq.w	.x						;same number on the ice: done
	bpl.w	.0						;home has more: test home
	exg	a0,a1						;away has more: test the away team
.0									;team with more players
	cmpi.w	#$13,tmteam(a0)
	bne.w	*+4						;(the branch goes to the next line either way)
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d2/a0-a2
	rts
DrawPlayoffSprite					;The PlayoffSprite sprite at playoffspritex / playoffspritey in Satt, then
									;end the sprite list (Sattsize = its size). Called from PlayoffScreen
	movea.w	#(Satt-M68K_RAM),a6
	moveq	#1,d6
	movea.l	#PlayoffSprite,a0
	move.w	(energybarchars).w,d3
	ori.w	#$8000,d3				;high priority
	move.w	(playoffspritex).w,d0
	move.w	(playoffspritey).w,d1
	move.w	#1,d2					;frame 1
	jsr	(SetSframe).l
	cmpa.w	#(Satt-M68K_RAM),a6		;any drawn?
	bne.w	.0						;sprites drawn: end the list
	clr.l	(a6)+					;no sprite drawn: add an empty one
	clr.l	(a6)+
.0									;end the link chain at the last sprite
	clr.b	satLink-satLen(a6)
	move.l	a6,d0					;end of the list
	subi.l	#Satt,d0
	lsr.w	#1,d0
	move.w	d0,(Sattsize).w
	rts
HiScoreScreen						;vb2, the bitmap and HiScoreImg, then wait up to $50 * 4 frames or a
									;button (waitx). Called from Begin (attract mode)
	move.l	#vb2,(VBint).w			;plain vblank
	bclr	#df32c,(disflags).w		;40 cell mode
	move.w	#5,(Map3col).w			;map layout of this screen
	move.w	#$A000,(VmMAP2).w
	move.w	#7,(Map2col).w
	move.w	#$C000,(VmMAP1).w
	move.w	#7,(Map1col).w
	move.w	#$F000,(VmMAP3).w
	move.w	#$F800,(VSPRITES).w
	move.w	#$FC00,(VSCRLPM).w
	jsr	(forceblack).l				;screen off
	movea.w	#(palfadenew-M68K_RAM),a0
	moveq	#$1F,d1					;clear the palette fade target
.loop								;clear 32 longs
	clr.l	(a0)+
	dbf	d1,.loop
	jsr	(setVram_0).l
	jsr	(printz).l					;map at the top left
	String	-(TXPRI+TXMAP2),$E,3
	movea.l	#PlayoffSprite+$12E0,a2	;the background picture after the playoff sprite tiles
	movea.l	a2,a0
	movea.l	a2,a1
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	clr.w	d4
	moveq	#$F,d5					;palette lines 0-3
	jsr	(dobitmap).l
	jsr	(printz).l					;map at the picture
	String	-(TXPRI+TXMAP2),$10,$10
	movea.l	#HiScoreImg,a2			;then the high score picture
	movea.l	a2,a0
	movea.l	a2,a1
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	moveq	#0,d5					;no palette lines
	jsr	(dobitmap).l
	move.w	#$18,(palcount).w		;fade in over $18 frames
	move	#$2500,sr
	move.w	#$50,(seed).w			;seed = count of 4 frame waits ($50)
.loop2								;wait 4 frames or a button
	moveq	#4,d0
	jsr	(waitx).l
	tst.w	d1						;any?
	bne.w	.0						;button: leave
	subq.w	#1,(seed).w
	bpl.s	.loop2
.0									;timed out or a button
	move	#$2700,sr				;interrupts off
	rts
GetTeamStruct						;a2 = tmstruct, or AwShots when team d2 is not tmteam of tmstruct.
									;Called from PrintStartingLine
	movea.l	#tmstruct,a2
	cmp.w	tmteam(a2),d2			;team d2 is the home team
	beq.w	.x
	movea.l	#AwShots,a2
.x									;exit (also the end of the code above)
	rts
CountButtonPress					;Not in gmode bit 0: add 1 to homepresses (awaypresses for d4), and to the
									;next long unless TempWord1 is 8 or facedir(a3). Called from doinput_ispc
	movem.l	d1-d7/a0,-(sp)
	btst	#gmclock,(gmode).w		;clock running?
	bne.w	.x						;no count while the clock is stopped
	move.w	(TempWord1).w,d1		;pad direction
	movea.l	#homepresses,a0			;home pad counters
	tst.w	d4						;away pad?
	beq.w	.0
	movea.l	#awaypresses,a0
.0									;pad counter chosen
	addq.l	#1,(a0)					;every press counts
	cmp.w	#8,d1
	beq.w	.x						;no direction: not a turn
	cmp.w	facedir(a3),d1
	beq.w	.x						;same direction as he faces: not a turn
	addq.l	#1,4(a0)				;presses that change direction
.x									;exit: restore the registers
	movem.l	(sp)+,d1-d7/a0
	rts
TerminateLogName					;Unreferenced. The GetLogName String at lognametext, ended with 0 at
									;namelength and its length word made even
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#lognametext,a1
	bsr.w	GetLogName
	move.w	(namelength).w,d0
	move.b	#0,(a1,d0.w)			;end the name with 0
	addq.w	#1,d0
	andi.w	#$FFFE,d0				;length rounded to even
	move.w	d0,-2(a1)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PlayedByHome						;a1 = String "(played by NAME)" for homeuser (GetLogName name), or an
									;empty String for 0. Called from UpdateScoutingDisplay
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	(homeuser).w,d0
PlayedByText						;PlayedByHome / PlayedByAway body
	tst.w	d0						;a user?
	beq.w	PlayedByNone			;no user: the empty String
	movea.l	#nameentrybuf+2,a1		;the name after a length word
	move.w	d0,(namelogsel).w
	bsr.w	GetLogName
	adda.w	(namelength).w,a1		;end the name with 0
	move.b	#0,(a1)
	addq.w	#1,(namelength).w
	andi.w	#$FFFE,(namelength).w	;rounded to even
	addq.w	#2,(namelength).w		;rounded to even + the header
	move.w	(namelength).w,(nameentrybuf).w
	movea.l	#nameentrybuf,a1
	move.l	a1,-(sp)
	movea.l	#TempBuffer,a3
	movea.l	#PlayedByTxt,a1			;"(played by " then the name and ")"
	bsr.w	CopyString				;copy "(played by "
	movea.l	(sp)+,a1
	movea.l	#TempBuffer,a3
	jsr	(appstring).l				;append the name
	movea.l	#TempBuffer,a3
	jsr	(appendz).l
	String	')'
	movea.l	#TempBuffer,a1			;a1 = the String
PlayedByExit						;Exit
	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
PlayedByTxt							;PlayedByHome text
	String	'(played by '
PlayedByEmptyTxt					;PlayedByHome: the empty String
	dc.w	2						;empty String
PlayedByNone						;PlayedByHome: no name
	movea.l	#PlayedByEmptyTxt,a1
	bra.s	PlayedByExit
PlayedByAway						;As PlayedByHome for awayuser. Called from UpdateScoutingDisplay
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	(awayuser).w,d0
	bra.w	PlayedByText			;share the body
SetSflags8Bit1						;Always sets sflags8 bit 1 (the bclr is skipped).
									;Called from updateplayers
	bra.w	.set					;(the bclr below is always skipped)
	bclr	#1,(sflags8).w
	bra.w	.ex
.set								;set bit 1 of sflags8
	bset	#1,(sflags8).w			;set bit 1 of sflags8
.ex									;exit (also the end of the code above)
	rts
AttribAdjust						;An attribute under $32 becomes d0 / 2 + $19. Called from AttribRating,
									;PrintOverallRating and PrintMatchupRatings
	cmp.w	#$32,d0					;compare $32 to d0
	bge.w	.exit					;branch if greater than
	asr.w	#1,d0
	addi.w	#$19,d0					;add $19 (25 dec)
.exit								;exit (also the end of the code above)
	rts
PuckComingToward					;nothing calls it. Z clear when the puck is within $1E of player a3 and
									;moving toward him (x, then y); d0-d1 kept
	movem.w	d0-d1,-(sp)
	move.w	(puckx).w,d0
	sub.w	(a3),d0					;minus the player X
	cmp.w	#$1E,d0					;puck more than $1E ahead in X: no
	bgt.w	.x
	move.w	(puckvx).w,d1
	eor.w	d1,d0					;sign of dx against the puck's X speed
	andi.w	#$8000,d0
	beq.w	.x						;same sign: moving away
	move.w	(pucky).w,d0
	sub.w	Ypos(a3),d0				;minus the player Y
	cmp.w	#$1E,d0					;puck more than $1E ahead in Y: no
	bgt.w	.x
	move.w	(puckvy).w,d1
	eor.w	d1,d0					;sign of dy against the Y speed (Z clear = toward him)
	andi.w	#$8000,d0
.x									;(Z holds the answer)
	movem.w	(sp)+,d0-d1
	rts
ReadGoaliePulled					;Z clear when the team of a3 pulled its goalie ($26 of the team struct).
									;Called from doshot assdefo, asspuckc and assnearest
	movem.l	a1,-(sp)
	movea.l	#tmstruct,a1
	btst	#pfteam,pflags(a3)		;check if home or away 0=home 1=away
	beq.w	.chkgoalie
	movea.l	#AwShots,a1
.chkgoalie							;team chosen: tmgoalie 0 = goalie in (Z set)
	tst.w	tmgoalie(a1)
	movem.l	(sp)+,a1
	rts
EndOneTimer							;End a one-timer for a3: bits cleared, onetimerplayer = -1, SetSPA
									;SPAglide, then assexit (goalie) or Setplass. Called from assonetimer and
									;checkgoal (.setass)
	movem.l	d0/a0,-(sp)
	bclr	#pf3onetimer,pflags3(a3)
	bclr	#pfalock,pflags(a3)		;clear the a lock
	bclr	#pf2aip,pflags2(a3)		;clear the AI flag
	clr.w	(onetimerflags).w		;clear the one-timer flags
	st	(onetimerplayer).w
	move.w	d1,-(sp)
	move.w	#SPAglide,d1
	jsr	(SetSPA).l
	tst.w	position(a3)			;a goalie: back to his goalie logic
	bpl.w	.0
	jsr	(assexit).l					;a skater: normal assignment
	bra.w	.1
.0									;skater: give him a new assignment
	jsr	(Setplass).l
.1									;both: restart the animation
	clr.w	SPAnum(a3)				;first frame
	st	SPAcnt(a3)
	move.w	(sp)+,d1
	movem.l	(sp)+,d0/a0
	rts
newTitleScreen						;the title screen (TitleScreenImg, NHLShieldImg, PAlogoImg, TitleImg) with
									;the vblank VBlank_TitleScreen, song $78, then the
									;scrolling credits (Credits, CreditsList text; CreditsPrintRow,
									;CreditsWait) until start. Called from Opening
	move	#$2700,sr				;interrupts off
	move.w	(HVcount).l,(seed).w	;seed the random numbers from the beam position
	move.w	(HVcount).l,(seed+2).w
	move.l	#VBlank_TitleScreen,(VBint).l
	bset	#df32c,(disflags).w		;32 cell mode
	move.w	#5,(Map3col).w
	move.w	#$A000,(VmMAP2).w
	move.w	#7,(Map2col).w
	move.w	#$C000,(VmMAP1).w
	move.w	#7,(Map1col).w
	move.w	#$F000,(VmMAP3).w
	move.w	#$F800,(VSPRITES).w
	move.w	#$FC00,(VSCRLPM).w
	move.w	#0,d0					;fade to color 0
	jsr	(setVram).l
	movea.l	#Vdata,a0
	move.w	#VDPR_WINX,Vctrl-Vdata(a0)
	move.w	#VDPR_WINY+$17,Vctrl-Vdata(a0)	;window plane for the bottom rows
	move.w	#VDPR_MODE3+$03,Vctrl-Vdata(a0)	;line scroll for the credits
	clr.w	(Vscroll).w
	jsr	(printz).l					;map 1 at the top left
	String	-TXMAP1,0,0
	move.l	#$80,d0					;clear both text maps
	moveq	#$20,d1
	move.l	#$7FF,d2				;blank char
	jsr	(eraser).l
	jsr	(printz).l					;map 3 at the top left
	String	-TXMAP2,0,0
	move.l	#$80,d0
	moveq	#$20,d1
	move.l	#$7FF,d2				;blank char
	jsr	(eraser).l
	clr.w	d4
	move.w	d4,-(sp)
	jsr	(printz).l					;map 2 at the top
	String	-TXMAP3,0,0
	movea.l	#TitleScreenImg,a0		;the top of the title picture
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	#$17,d3
	moveq	#$F,d5					;palette lines 0-3
	jsr	(dobitmap).l
	move.w	d4,(TempWord1).w
	move.w	(sp)+,d4
	jsr	(printz).l					;then its bottom 5 rows in the window plane
	String	-TXMAP2,0,$17
	movea.l	#TitleScreenImg,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0
	move.w	#$17,d1
	move.w	(a1),d2
	move.w	#5,d3
	moveq	#0,d5					;no palette lines
	bset	#0,(sflags6).w			;bit 0 of sflags6: dobitmap uses the map as is
	jsr	(dobitmap).l
	bclr	#0,(sflags6).w			;normal maps
	move.w	(TempWord1).w,d4
	jsr	(printz).l					;map at the shield
	String	-(TXPRI+TXMAP2),1,1
	movea.l	#NHLShieldImg,a0		;NHL shield, NHLPA logo and the title on top
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	moveq	#8,d5					;palette line 3
	jsr	(dobitmap).l
	jsr	(printz).l					;map at the NHLPA logo
	String	-(TXPRI+TXMAP2),$19,1
	movea.l	#PAlogoImg,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	moveq	#0,d5					;no palette lines
	jsr	(dobitmap).l
	jsr	(printz).l					;map at the title
	String	-(TXPRI+TXMAP2),1,$E
	movea.l	#TitleImg,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	moveq	#8,d5					;palette line 3
	jsr	(dobitmap).l
	clr.w	(palfadenew).w			;color 0 black and the fade targets cleared
	clr.l	(fofdata2).w
	clr.w	(fofdata2+4).w
	move.w	d4,(smallfontchars).w	;the small font for the credits
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$0D104567,$89ABCDEF		;remap table: palette assignment for the scrolling credits
	jsr	(printz).l					;map 1 at the top left
	String	-(TXPAL1+TXMAP1),0,0
	movea.l	#Credits,a1				;the first credits page
	jsr	(CreditsPrintRow).l			;print the first page
	addi.w	#$20,(Vscroll).w		;scroll down 32 lines
	move.w	#$104,(clampcounter).w	;clampcounter = how long the first page stays
	move.w	#$120,(playoffspritex).w
	move.w	#$D0,(playoffspritey).w
	clr.w	(asv).w					;(sprite and fade setup for the title)
	move.w	#$FFCE,(DispAttribCtr).w	;attribute display counter
	move.w	#$20,(palcount).w		;fade in
	move.w	#SngTitle,-(sp)			;the title song
	jsr	(song).l
	bsr.w	CreditsLineScroll		;set up the line scroll table
	move	#$2500,sr				;interrupts on
.loop								;wait out the first page
	jsr	(CreditsWait).l				;one frame
	tst.w	(clampcounter).w		;page time left?
	bne.s	.loop
	move.w	#$3C,d3
.loop2								;then $3C more frames
	jsr	(CreditsWait).l				;one frame
	dbf	d3,.loop2					;loop
	jsr	(printz).l					;map 1 at the top left
	String	-(TXPAL1+TXMAP1),0,0
	movea.l	#CreditsList,a1
.loop3								;each credits entry
	jsr	(CreditsPrintRow).l			;print the entry
	adda.w	(a1),a1
	moveq	#$27,d4					;scroll it up $28 lines, a line every 2 frames
.loop4								;one line up every 2 frames
	jsr	(CreditsWait).l				;frame
	jsr	(CreditsWait).l				;frame
	addq.w	#1,(Vscroll).w			;scroll one line
	dbf	d4,.loop4					;loop
	moveq	#$78,d4					;hold it $78 frames
.loop5								;wait
	jsr	(CreditsWait).l				;frame
	dbf	d4,.loop5					;loop
	tst.w	2(a1)					;until the end marker
	bpl.s	.loop3
	rts
CreditsPrintRow						;Credits: clear the row below the screen (Vscroll / 8 + $1C) and print the
									;Strings from a1 centred there
	move.w	(Vscroll).w,d0
	asr.w	#3,d0					;the row just below the screen
	addi.w	#$1C,d0					;plus $1C rows
	andi.w	#$1F,d0					;wrap at 32
	move.w	d0,(printy).w
	move.w	d0,-(sp)
	clr.w	(printx).w
	moveq	#$20,d0					;clear 6 rows there
	moveq	#6,d1
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l
	move.w	(sp)+,(printy).w
.loop								;each String of the entry
	move.w	(a1),d0
	asr.w	#1,d0					;centred: column $11 - length / 2
	neg.w	d0
	addi.w	#$11,d0
	move.w	d0,(printx).w
	jsr	(print).l
	addq.w	#1,(printy).w
	andi.w	#$1F,(printy).w			;the map wraps at 32 rows
	tst.w	2(a1)					;until the end marker
	bpl.s	.loop
	rts
CreditsWait							;Credits: wait for Vcount, run the clampcounter count down; start (orjoy
									;bit 7) returns from the caller too
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(Vcount).w,d0			;frame count
.loop								;wait for the next vblank
	cmp.w	(Vcount).w,d0
	beq.s	.loop
	subq.w	#2,(clampcounter).w		;count down the page time
	bpl.w	.0
	clr.w	(clampcounter).w
.0									;counter done: check the start button
	jsr	(orjoy).l					;read the pads
	btst	#7,d1					;start?
	movem.l	(sp)+,d0-d7/a0-a6		;(the flags of the btst survive the movem)
	beq.w	.x						;no start: keep waiting
	addq.w	#4,sp					;start: drop the caller's return address and leave his loop too
.x									;exit (also the end of the code above)
	rts
VBlank_TitleScreen					;newTitleScreen vblank: line scroll table (SortCords) and Vscroll,
									;sprites, cramfade, CreditsScrollStep, p_music_vblank
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#dfng,(disflags).w		;screen off?
	bne.w	.1						;screen off: skip the DMA
	movea.w	#(SortCords-M68K_RAM),a0
	move.w	(VSCRLPM).w,d1
	move.w	#$1C0,d0				;$1C0 bytes: the line scroll table
	jsr	(DoDMA).l
	movea.l	#Vdata,a0
	move.l	#VSRAM_W,Vctrl-Vdata(a0)
	move.w	(Vscroll).w,(a0)		;vertical scroll of the credits
	movea.w	#(Satt-M68K_RAM),a0
	move.w	(Sattsize).w,d0
	beq.w	.0						;no sprites this frame
	clr.w	(Sattsize).w
	move.w	(VSPRITES).w,d1
	jsr	(DoDMA).l
.0									;sprites done
	jsr	(cramfade).l
.1									;drawing done (or skipped)
	addq.w	#1,(Vcount).w			;count the frame
	jsr	(CreditsScrollStep).l
	jsr	(p_music_vblank).l
	movem.l	(sp)+,d0-d7/a0-a6
	rte
CreditsLineScroll					;Credits: the line scroll table at SortCords
	movem.l	d0-d1,-(sp)
	move.w	#$14,(Hscroll).w		;scroll step per update
	move.w	#$50,(TempWord2).w		;first update after $50 frames
	move.w	#$50,d0					;$51 lines: the top part, slanted
	movea.l	#SortCords,a0
	move.l	#$FD80,d1				;start far left
.loop								;fill the top lines
	move.l	d1,(a0)+
	btst	#0,d0					;every other line one pixel further
	bne.w	.0
	subq.w	#1,d1
.0									;next line
	dbf	d0,.loop					;loop
	move.w	#$60,d0					;the lower $61 lines
	move.l	#$100,d1
.loop2								;start further right each line
	move.l	d1,(a0)+
	addq.l	#4,d1
	dbf	d0,.loop2					;loop
	movem.l	(sp)+,d0-d1
	rts
CreditsScrollStep					;Credits: line scroll step, every TempWord2 frames
	subq.w	#1,(TempWord2).w
	bmi.w	.0
	rts
.0									;time for a step
	clr.w	(TempWord2).w
	movem.l	d0-d2/a0,-(sp)
	move.w	#$DF,d0					;each of the $E0 lines
	movea.w	#(SortCords-M68K_RAM),a0
.loop								;step each line
	tst.l	(a0)+
	cmp.w	#$28,d0					;the top $28 lines stay still
	ble.w	.2						;top lines: still
	move.w	(Hscroll).w,d1
	cmp.w	#$8F,d0					;lines from $8F: move right
	blt.w	.1						;middle lines
	move.w	-2(a0),d2				;this line
	beq.w	.2						;already at 0: stays
	add.w	d1,d2
	move.w	d2,-2(a0)
	andi.w	#$FC00,d2				;until they pass 0
	cmp.w	#$FC00,d2
	beq.w	.2
	move.w	#0,-2(a0)				;past 0: stop there
	bra.w	.2
.1									;middle lines: move left
	sub.w	d1,-2(a0)
	bpl.w	.2						;not past 0 yet
	clr.w	-2(a0)					;stop at 0
.2									;next line
	dbf	d0,.loop					;loop
	movem.l	(sp)+,d0-d2/a0
	rts
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
	move.w	#1,(SongIndex).w		;away ahead: song slot 1
	jsr	(ChooseSong).l
.loop								;(not looped: a song is now playing)
	bset	#6,(sflags8).w			;lead song done
	bra.w	LeadSongExit
.2									;home ahead: song slot 4
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#4,(SongIndex).w
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
	movea.l	#AwShots,a0
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
									;HotIconMap when he is awayhotplayer /
									;homehotplayer, ColdIconMap when awaycoldplayer / homecoldplayer, else
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
	movea.l	#HotIconMap,a0
	bra.w	.draw
.cold								;he is cold: the cold icon
	move.w	(coldiconchars).w,d4
	movea.l	#ColdIconMap,a0
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
chgplayer							;The pad d4 takes the nearest free skater to where the puck is going (not
									;a goalie, not locked or unavailable; in a penalty shot / shootout only
									;BA_Sktr_SCnum or BA_Goalie_SCnum), or sweep checks when it is the same
									;one. Called from changeplayer
	btst	#6,(sflags5).w			;Check bit 6. This is never set anywhere
	bne.w	rtsChgplayer
	movem.l	d0-d6/a0-a1,-(sp)
	move.w	(puckvx).w,d0			;lead puck slightly
	asr.w	#8,d0
	add.w	(puckx).w,d0			;plus the puck X
	move.w	(puckvy).w,d1
	asr.w	#8,d1
	add.w	(pucky).w,d1			;plus the puck Y
	movem.w	d0-d1,-(sp)
	moveq	#5,d2					;6 players of the team
	move.w	d4,d3
	eori.w	#2,d3					;other controller
	moveq	#-1,d5
	movea.w	#(SortCords-M68K_RAM),a0
	movea.w	#(cont1team-M68K_RAM),a1
	cmpi.w	#1,0(a1,d4.w)			;team 1 starts at the first struct
	beq.w	.t1
	adda.w	#$300,a0				;controller is on other team
.t1									;this controller's team
	movea.w	#(c1playernum-M68K_RAM),a1
.top								;each player
	tst.w	position(a0)
	ble.w	.next					;cant switch to goalie
	btst	#pf2unav,pflags2(a0)
	bne.w	.next					;this player is unavailable for some reason
	movem.w	d1,-(sp)
	move.w	SCnum(a0),d1
	cmp.w	0(a1,d4.w),d1			;this pad's player?
	movem.w	(sp)+,d1
	beq.w	.0						;his own player: allowed even though controlled
	btst	#3,pflags(a0)			;is player controlled?
	bne.w	.next
.0									;this pad's player, or not controlled
	btst	#2,(BA_PS_flags).w		;penalty shot / shootout?
	beq.w	.1						;not a penalty shot / shootout
	movem.l	d0,-(sp)
	move.w	(BA_Sktr_SCnum).w,d0
	cmp.w	SCnum(a0),d0			;this one?
	movem.l	(sp)+,d0
	beq.w	.1						;shooter allowed
	movem.l	d0,-(sp)
	move.w	(BA_Goalie_SCnum).w,d0
	cmp.w	SCnum(a0),d0			;this one?
	movem.l	(sp)+,d0
	bne.w	.next					;only the shooter and goalie may be picked
.1									;the player may be picked
	btst	#pfalock,pflags(a0)
	bne.w	.next
	movem.w	(sp),d0-d1				;distance squared to the puck target
	sub.w	(a0),d0					;Xpos
	muls.w	d0,d0
	sub.w	Ypos(a0),d1
	muls.w	d1,d1
	add.l	d1,d0					;distance squared
	cmp.l	d5,d0					;closer?
	bhi.w	.next
	move.w	SCnum(a0),d1
	cmp.w	0(a1,d3.w),d1			;other pad's player?
	beq.w	.next					;the other pad has him
	move.l	d0,d5					;closest so far
	move.w	d1,d6
.next								;next player
	adda.w	#$80,a0					;size of SCstruct
	dbf	d2,.top						;loop
	addq.w	#4,sp					;drop the target point
	pea	(.ex).l
	cmp.w	0(a1,d4.w),d6			;same player?
	beq.w	swpchk					;player is same so sweep check
	move.w	d6,d0					;d0 = new player
	tst.w	d4						;controller 1?
	beq.w	j_setc1player
	bra.w	j_setc2player
.ex									;exit: restore the registers
	movem.l	(sp)+,d0-d6/a0-a1
rtsChgplayer						;shared rts
	rts
swpchk								;Sweepcheck
	jmp	Sweepcheck
j_setc1player						;jump to the routine of the same name
	jmp	setc1player
j_setc2player						;jump to the routine of the same name
	jmp	setc2player
