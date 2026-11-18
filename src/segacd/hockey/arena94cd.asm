RunArenaAnim						;Run the arena animation arenaanim (negative: none): the first time, its
									;frame list and graphics from ArenaAnims
									;(arenaframelist / arenaspritelist, tiles to VRAM d4 = arenaanimchars:
									;DecompressGraphicsPlain); then count down the frame time arenaframetime
									;by d7 and step (NextArenaFrame). Called from periodicevents and waitxsr
	tst.w	(arenaanim).l
	bmi.w	.x2
	movem.l	d0-d7/a0-a6,-(sp)
	tst.l	(arenaspritelist).l
	bne.w	.run
	move.w	(arenaanim).l,d0
	asl.w	#$3,d0
	movea.l	#$2A26C,a0
	move.l	(a0,d0.w),(arenaframelist).l
	move.l	$4(a0,d0.w),(arenaspritelist).l
	movea.l	$4(a0,d0.w),a2
	adda.w	#$8,a2
	move.w	(arenaanimchars).l,d4
	jsr	(DecompressGraphicsPlain).l
	clr.w	(arenaframeidx).l
	bsr.w	NextArenaFrame
	bra.w	.x
.run	sub.w	d7,(arenaframetime).l
	bpl.w	.x
	addi.w	#$1,(arenaframeidx).l
	bsr.w	NextArenaFrame		;read the next frame
.x	movem.l	(sp)+,d0-d7/a0-a6
.x2	rts
NextArenaFrame						;Read frame arenaframeidx of the list: arenaframe = frame, arenaframetime
									;= time; frame $FF loops to the start, $FE ends the animation
									;(EndArenaAnim)
	movea.l	(arenaframelist).l,a0
	move.w	(arenaframeidx).l,d0
	add.w	d0,d0		;2 bytes per entry
	move.b	(a0,d0.w),d1		;frame byte
	ext.w	d1
	move.w	d1,(arenaframe).l
	move.b	$1(a0,d0.w),d1
	ext.w	d1
	move.w	d1,(arenaframetime).l
	cmpi.w	#$FFFF,(arenaframe).l
	bne.w	.0
	clr.w	(arenaframeidx).l
	bra.w	NextArenaFrame
.0	cmpi.w	#$FFFE,(arenaframe).l
	bne.w	.x
	bsr.w	EndArenaAnim		;$FE: end the animation
.x	rts
; Table of 64 bytes after NextArenaFrame, 64 bytes: $00,$02,$A3,$E4,$00,$04 ...
	dc.b	$00,$02,$A3,$E4,$00,$04,$3A,$7E,$00,$02,$A3,$98,$00,$04,$42,$A2
	dc.b	$00,$02,$A3,$BE,$00,$04,$42,$A2,$00,$02,$A3,$86,$00,$04,$4F,$A8
	dc.b	$00,$02,$A3,$30,$00,$04,$5A,$16,$00,$02,$A3,$00,$00,$04,$5A,$16
	dc.b	$00,$02,$A2,$EA,$00,$04,$69,$42,$00,$02,$A2,$AC,$00,$04,$69,$42
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
	dc.b	$08,$F9,$00,$06,$00,$01,$7F,$6A,$33,$FC,$00,$00,$00,$01,$7E,$DC
	dc.b	$33,$FC,$01,$60,$00,$01,$7E,$DE
	rts
StartArenaAnim						;Start arena animation d0 (ArenaAnims): arenaanim = d0, RunArenaAnim loads
									;it. Called from FallDown (7)
									;ShowGoalBox (0 on a home hat trick) and puckfaceoff2 (the one
									;SetFaceoffAnim set)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d0,(arenaanim).l
	move.l	#$0,(arenaframelist).l
	move.l	#$0,(arenaspritelist).l
	move.w	#$1,(arenaframe).l
	clr.w	(arenaframeidx).l
	st.b	(faceoffanim).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SetFaceoffAnim						;Set the faceoff animation: sflags7 bit 0, faceoffanim = d0. Called from
									;puckfaceoff
	bset	#$0,(sflags7).l
	move.w	d0,(faceoffanim).l
	rts
EndArenaAnim
	move.w	#$FFFF,(arenaanim).l
	bclr	#$0,(sflags7).l
	rts
ChooseSong						;SongNum = byte SongIndex of the 6 song bytes of team HmTeam, or one of
									;the 8 of RandomSongs at random when 0; $FFFF with gmode bit 4. Called
									;from StartPer, checkgoal, puckshootout and LeadSong
	movem.l	d0-d1/a0-a1,-(sp)
	btst	#gmhl,(gmode).l		;highlight reel?
	beq.w	.0		;not the highlight reel: pick a song
	move.w	#$FFFF,d1		;highlights: no song
	bra.w	.1
.0	bclr	#$6,(sflags8).l		;clear sflags8 bit 6
	movea.l	#$2A4DC,a0
	movea.l	#$2A584,a1
	move.w	(HmTeam).l,d0
	mulu.w	#$6,d0
	add.w	(SongIndex).l,d0
	clr.w	d1
	move.b	(a0,d0.w),d1		;team song
	bne.w	.1		;a team song: use it
	move.w	#$8,d0		;slot 0: one of the 8 random songs
	jsr	(randomd0).l
	andi.w	#$7,d0
	move.b	(a1,d0.w),d1
.1	move.w	d1,(SongNum).l
	movem.l	(sp)+,d0-d1/a0-a1
	rts
TeamSongs						;ChooseSong: 6 songs per team (TeamList order), 0 = random (RandomSongs)
; Data that follows TeamSongs (strings, small tables)
TeamSongsData	dc.w	$7775
