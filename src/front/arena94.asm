;	Arena / faceoff animations, then the organ song pick (ChooseSong / TeamSongs /
;	RandomSongs). New in 94. ROM-contiguous through RandomSongs.

RunArenaAnim						;Run the arena animation arenaanim (negative: none): the first time, its
									;frame list and graphics from ArenaAnims
									;(arenaframelist / arenaspritelist, tiles to VRAM d4 = arenaanimchars:
									;DecompressGraphicsPlain); then count down the frame time arenaframetime
									;by d7 and step (NextArenaFrame). Called from periodicevents and waitxsr
	tst.w	(arenaanim).w			;any arena animation?
	bmi.w	.x2						;none running
	movem.l	d0-d7/a0-a6,-(sp)
	tst.l	(arenaspritelist).w		;first time?
	bne.w	.run					;already loaded: run it
	move.w	(arenaanim).w,d0
	asl.w	#3,d0					;8 bytes per animation
	movea.l	#ArenaAnims,a0
	move.l	0(a0,d0.w),(arenaframelist).w	;frame list
	move.l	4(a0,d0.w),(arenaspritelist).w
	movea.l	4(a0,d0.w),a2
	addq.w	#8,a2
	move.w	(arenaanimchars).w,d4
	jsr	(DecompressGraphicsPlain).l
	clr.w	(arenaframeidx).w		;start of the list
	bsr.w	NextArenaFrame			;first frame
	bra.w	.x
.run								;arenaspritelist <> 0
	sub.w	d7,(arenaframetime).w	;count down the frame time
	bpl.w	.x						;frame time not out yet
	addq.w	#1,(arenaframeidx).w
	bsr.w	NextArenaFrame			;read the next frame
.x									;pop the d0-d7/a0-a6 saved above
	movem.l	(sp)+,d0-d7/a0-a6
.x2									;exit (also the end of the code above)
	rts
NextArenaFrame						;Read frame arenaframeidx of the list: arenaframe = frame, arenaframetime
									;= time; frame $FF loops to the start, $FE ends the animation
									;(EndArenaAnim)
	movea.l	(arenaframelist).w,a0	;frame list
	move.w	(arenaframeidx).w,d0
	add.w	d0,d0					;2 bytes per entry
	move.b	0(a0,d0.w),d1			;frame byte
	ext.w	d1
	move.w	d1,(arenaframe).w		;frame number
	move.b	1(a0,d0.w),d1
	ext.w	d1
	move.w	d1,(arenaframetime).w	;frame time
	cmpi.w	#$FFFF,(arenaframe).w
	bne.w	.0
	clr.w	(arenaframeidx).w
	bra.s	NextArenaFrame			;$FF: back to the first frame
.0									;end of the frame list?
	cmpi.w	#$FFFE,(arenaframe).w
	bne.w	.x
	bsr.w	EndArenaAnim			;$FE: end the animation
.x									;exit (also the end of the code above)
	rts
ArenaAnims							;The 8 arena animations (StartArenaAnim d0): frame list, then the graphics
									;in NHLPALogoMap (sprite list at 4(x), tiles at 8(x))
	dc.l	ArenaFrames8,NHLPALogoMap+$416
	dc.l	ArenaFrames6,NHLPALogoMap+$C3A
	dc.l	ArenaFrames7,NHLPALogoMap+$C3A
	dc.l	ArenaFrames5,NHLPALogoMap+$1940
	dc.l	ArenaFrames4,NHLPALogoMap+$23AE
	dc.l	ArenaFrames3,NHLPALogoMap+$23AE
	dc.l	ArenaFrames2,NHLPALogoMap+$32DA
	dc.l	ArenaFrames1,NHLPALogoMap+$32DA
ArenaFrames1						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,1,$A,2,$A,3,$A,4,$A,5,$A,6,$A
	dc.b	7,$A,8,$A,9,$A,$A,$A,1,$A,2,$A,3,$A,4,$A
	dc.b	5,$A,6,$A,7,$A,8,$A,9,$A,$A,$A,$FE,0
ArenaFrames2						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,$FF,0
ArenaFrames3						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,$B,$A,$C,$A,$D,$A,$E,$A,$F,$A,$10,$A
	dc.b	$11,$A,$12,$A,$13,$A,$14,$A,$15,$A,$16,$A,$17,$A,$FE,0
ArenaFrames4						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,8,2,8,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	2,8,1,8,$FF,0
ArenaFrames5						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,8,2,8,3,8,4,8,5,8,6,8,7,8,8,8
	dc.b	$FF,0
ArenaFrames6						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,8,2,8,3,8,4,$1E,5,8,6,8,7,8,8,$1E
	dc.b	5,8,6,8,7,8,8,$1E,9,8,$A,8,$B,8,$C,8
	dc.b	$D,8,$E,8,$FE,0
ArenaFrames7						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	$F,8,$10,8,$11,8,$12,$1E,$13,8,$14,8,$15,8,$16,$1E
	dc.b	$13,8,$14,8,$15,8,$16,$1E,$17,8,$18,8,$19,8,$1A,8
	dc.b	$1B,8,$1C,8,$FE,0
ArenaFrames8						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,$B,$A,$C,$A,$D,$A,$E,$A,$F,$7F,$FE,0
SetCameraTop						;Unreferenced. Sflags bit 6, xc1 = 0, yc1 = $160
	bset	#sfslock,(sflags).w
	move.w	#0,(xc1).w
	move.w	#$160,(yc1).w
	rts
StartArenaAnim						;Start arena animation d0 (ArenaAnims): arenaanim = d0, RunArenaAnim loads
									;it. Called from FallDown (7)
									;ShowGoalBox (0 on a home hat trick) and puckfaceoff2 (the one
									;SetFaceoffAnim set)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d0,(arenaanim).w
	move.l	#0,(arenaframelist).w	;RunArenaAnim loads the lists
	move.l	#0,(arenaspritelist).w
	move.w	#1,(arenaframe).w		;first frame
	clr.w	(arenaframeidx).w
	st	(faceoffanim).w				;no faceoff animation queued
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SetFaceoffAnim						;Set the faceoff animation: sflags7 bit 0, faceoffanim = d0. Called from
									;puckfaceoff
	bset	#0,(sflags7).w			;faceoff animation pending
	move.w	d0,(faceoffanim).w
	rts
EndArenaAnim						;End the arena animation: arenaanim = -1, sflags7 bit 0 cleared. Called
									;from NextArenaFrame and puckfaceoff2
	move.w	#$FFFF,(arenaanim).w
	bclr	#0,(sflags7).w			;no faceoff animation
	rts
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
	dc.b	NHL94_music_072,NHL94_music_070,NHL94_music_071,0,NHL94_music_043,0
	dc.b	NHL94_music_002,NHL94_music_003,NHL94_music_001,0,NHL94_music_043,NHL94_music_002
	dc.b	NHL94_music_005,NHL94_music_004,NHL94_music_004,NHL94_music_005,NHL94_music_043,0
	dc.b	NHL94_music_006,NHL94_music_008,NHL94_music_006,NHL94_music_008,NHL94_music_007,NHL94_music_007
	dc.b	NHL94_music_009,NHL94_music_011,NHL94_music_010,NHL94_music_009,NHL94_music_043,NHL94_music_054
	dc.b	NHL94_music_027,NHL94_music_028,NHL94_music_028,0,NHL94_music_043,0
	dc.b	NHL94_music_012,NHL94_music_013,NHL94_music_014,0,NHL94_music_043,NHL94_music_013
	dc.b	NHL94_music_015,NHL94_music_016,NHL94_music_016,0,NHL94_music_043,0
	dc.b	NHL94_music_072,NHL94_music_070,NHL94_music_071,0,NHL94_music_043,0
	dc.b	NHL94_music_017,NHL94_music_019,NHL94_music_018,NHL94_music_019,NHL94_music_043,NHL94_music_017
	dc.b	NHL94_music_020,NHL94_music_020,NHL94_music_022,NHL94_music_021,NHL94_music_043,NHL94_music_023
	dc.b	NHL94_music_032,NHL94_music_031,NHL94_music_032,NHL94_music_030,NHL94_music_043,NHL94_music_029
	dc.b	NHL94_music_033,NHL94_music_034,NHL94_music_033,0,NHL94_music_043,NHL94_music_035
	dc.b	NHL94_music_024,NHL94_music_025,NHL94_music_024,NHL94_music_026,NHL94_music_043,NHL94_music_026
	dc.b	NHL94_music_037,NHL94_music_038,NHL94_music_036,0,NHL94_music_043,0
	dc.b	NHL94_music_072,NHL94_music_070,NHL94_music_071,0,NHL94_music_043,0
	dc.b	NHL94_music_039,NHL94_music_040,NHL94_music_039,NHL94_music_041,0,NHL94_music_041
	dc.b	NHL94_music_042,NHL94_music_044,NHL94_music_042,NHL94_music_045,NHL94_music_043,NHL94_music_045
	dc.b	NHL94_music_046,NHL94_music_047,NHL94_music_046,0,NHL94_music_043,NHL94_music_047
	dc.b	NHL94_music_048,NHL94_music_049,NHL94_music_050,NHL94_music_052,NHL94_music_053,NHL94_music_054
	dc.b	NHL94_music_056,NHL94_music_057,NHL94_music_057,NHL94_music_056,NHL94_music_043,NHL94_music_058
	dc.b	NHL94_music_059,NHL94_music_060,NHL94_music_060,0,NHL94_music_043,0
	dc.b	NHL94_music_061,NHL94_music_061,NHL94_music_062,0,NHL94_music_043,0
	dc.b	NHL94_music_063,NHL94_music_064,NHL94_music_065,0,NHL94_music_043,0
	dc.b	NHL94_music_066,NHL94_music_068,NHL94_music_066,0,NHL94_music_043,NHL94_music_069
	dc.b	NHL94_music_072,NHL94_music_070,NHL94_music_071,0,NHL94_music_043,0
	dc.b	NHL94_music_037,NHL94_music_038,NHL94_music_036,0,NHL94_music_043,0
	dc.b	NHL94_music_037,NHL94_music_038,NHL94_music_036,0,NHL94_music_043,0
TeamSongsEnd						;end of TeamSongs (size check below)
	IF (TeamSongsEnd-TeamSongs)<>(NumTeams*6)
		inform	3,"TeamSongs needs 6 songs per team"
	ENDIF
RandomSongs							;ChooseSong: the 8 songs for a random pick
	dc.b	NHL94_music_005,NHL94_music_017,NHL94_music_019,NHL94_music_026,NHL94_music_041,NHL94_music_045,NHL94_music_054,NHL94_music_055
