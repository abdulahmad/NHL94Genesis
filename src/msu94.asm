;	MSU-MD playback for the cartridge ROM. Assembled only when MSU=1 (npm run build:msu).
;	The driver is krikzz's msu-drv.bin (MIT, src/msu/LICENSE): jsr it once, 0 in d0 if a
;	Mega CD was found. Commands are a word at $A12010 (command, then argument) and a bump
;	of the clock at $A1201F. Status $A12020 is 0 ready, 1 init, 2 busy.
;
;	Song ids $30-$77 use the disc's own numbers, track = id - $29 (tracks 7-$4E), the
;	same window cdrequest.asm writes, and they play once ($11), the way MSCPLAY1 does.
;	The faceoff whistle and the goal's stop_current_song do not pause that recording,
;	and the FM stream ending does not hand the voice to the crowd. It plays out until
;	a later song replaces it or p_turnoff pauses it. $78 (title) loops track 4, the
;	splash and main menu song. newTitleScreen asks for it before the pictures are
;	drawn, so the seek overlaps that work and the track is going when the fade
;	starts. The later song call still starts the FM arrangement then, and does not
;	restart a loop that is already playing. VLC lists that recording as track 3
;	because track 1 is data. $79 (end of game) loops track 5, the intermission. The menu MSCPLAYR
;	stores 5 and cdstart stores 4; on this disc those two recordings are the other
;	way around. $7A (scouting) loops track 3: the disc ignores $7A, and track 3 is
;	the second music track.
;	Track 2 is the crowd bed. It loops while no song owns the CD voice. A play-once
;	song keeps the voice through the whistle and the FM stream. BlastEm does not
;	let the cartridge read the CD position, so the game times the song from the
;	USA redump length (NTSC frames, one second short) and then sends a normal
;	play-loop of track 2. That is the handoff cdtrack.asm makes after MSCPLAY1.
;	Looping songs are not on that timer and keep the driver's own end check. The
;	PSG crowd in updatesound is never removed. One CD-DA voice cannot play the
;	bed under a song.

MsuCmd	;d0 = command word. Wait out status 2, write $A12010, bump $A1201F
	move.w	d1,-(sp)
	move.w	#$0FFF,d1
.wait
	cmpi.b	#2,$A12020.l
	bne.s	.go
	dbf	d1,.wait
.go
	move.w	d0,$A12010.l
	move.b	$A1201F.l,d1
	addq.b	#1,d1
	move.b	d1,$A1201F.l
	move.w	(sp)+,d1
	rts

MsuInit	;Called from Begin after the RAM clear. CD music On if the driver loads, otherwise Off
	clr.w	(MsuReady).w
	clr.w	(MsuHold).w
	clr.w	(MsuMuteFm).w
	clr.w	(MsuTrack).w
	clr.w	(MsuLastId).w
	clr.w	(MsuLeft).w
	move.w	#1,(MsuMusic).w
	movem.l	d0-d2,-(sp)
	bsr.w	MsuDriver
	tst.w	d0
	bne.w	.fail
	moveq	#16,d2
.outer
	move.w	#$FFFF,d1
.inner
	cmpi.b	#1,$A12020.l
	beq.s	.saw
	dbf	d1,.inner
	dbf	d2,.outer
	bra.w	.fail
.saw
	moveq	#16,d2
.outer2
	move.w	#$FFFF,d1
.inner2
	cmpi.b	#1,$A12020.l
	bne.s	.ready
	dbf	d1,.inner2
	dbf	d2,.outer2
	;Status reached 1, so the sub CPU is up, but it is still reading the TOC.
	;This disc has about 80 tracks, and that read runs longer than the boot wait.
	;Leave ready at 2 so a later poll can finish init. 0 means no Mega CD at all.
	move.w	#2,(MsuReady).w
	move.w	#1,(MsuMusic).w
	bra.w	.out
.ready
	move.w	#1,(MsuReady).w
	clr.w	(MsuMusic).w	;On
	move.w	#$1601,d0	;NOSEEK off: track changes do not wait out a seek
	bsr.w	MsuCmd
	bra.w	.out
.fail
	clr.w	(MsuReady).w
	move.w	#1,(MsuMusic).w
.out
	movem.l	(sp)+,d0-d2
	rts

MsuTryReady	;Z set if the driver is ready. Finishes init if the TOC completed after the boot wait
	cmpi.w	#1,(MsuReady).w
	beq.s	.yes
	cmpi.w	#2,(MsuReady).w
	bne.s	.no
	cmpi.b	#1,$A12020.l
	beq.s	.no
	move.w	#1,(MsuReady).w
	clr.w	(MsuMusic).w
	move.w	#$1601,d0
	bsr.w	MsuCmd
	cmpi.w	#$30,(MsuLastId).w
	blt.s	.yes
	move.w	#1,(MsuMuteFm).w
	move.w	(MsuLastId).w,d0
	bsr.w	MsuStartSong
.yes
	moveq	#0,d0
	rts
.no
	moveq	#1,d0
	rts

MsuPlay	;d0 = track 1-99, d1 = $11 play once or $12 loop. Volume $FF (255, the top of 0-255), then the play command
	movem.l	d0-d2,-(sp)
	move.w	#$15FF,d0
	bsr.w	MsuCmd
	movem.l	(sp)+,d0-d2
	andi.w	#$00FF,d0
	move.w	d0,(MsuTrack).w
	asl.w	#8,d1
	or.w	d1,d0
	bsr.w	MsuCmd
	rts

MsuMap	;song id d0 -> track d0, command d1. $30-$77 become id-$29
	cmpi.w	#SngScout,d0
	bne.s	.eog
	moveq	#3,d0
	moveq	#$12,d1
	rts
.eog
	cmpi.w	#SngEOG,d0
	bne.s	.title
	moveq	#5,d0
	moveq	#$12,d1
	rts
.title
	cmpi.w	#SngTitle,d0
	bne.s	.song
	moveq	#4,d0
	moveq	#$12,d1
	rts
.song
	subi.w	#$29,d0
	moveq	#$11,d1		;play once, same as MSCPLAY1
	rts

MsuStartSong	;d0 = song id. MsuHold keeps the play command: $11 once, $12 loop
	move.w	d0,(MsuLastId).w
	bsr.w	MsuMap
	move.w	d1,(MsuHold).w
	bsr.w	MsuArmOnce
	bsr.w	MsuPlay
	rts

MsuArmOnce	;d0 = track, d1 = command. One-shot songs get a frame count. Loops do not
	movem.l	d0-d2/a0,-(sp)
	clr.w	(MsuLeft).w
	cmpi.w	#$11,d1
	bne.s	.x
	move.w	d0,d2
	subi.w	#7,d2			;table is disc tracks 7-78
	bmi.s	.x
	cmpi.w	#72,d2
	bcc.s	.x
	add.w	d2,d2
	lea	MsuLengths(pc),a0
	move.w	(a0,d2.w),(MsuLeft).w
.x
	movem.l	(sp)+,d0-d2/a0
	rts

MsuPrimeTitle	;newTitleScreen, before the pictures. No FM stream. The seek runs while the art is drawn
	move.w	#SngTitle,d0
	bra.w	MsuHandleSong

MsuHandleSong	;play_sfx_or_music_track, after stop_current_song, d0 = song id. Preserves regs.
	;MsuTryReady returns 0 or 1 in d0, so the song id is kept in d3 and passed to MsuStartSong.
	;A $12 loop that is already this song is left playing. The title screen asks twice.
	movem.l	d0-d4/a0-a2,-(sp)
	move.w	d0,d3
	cmpi.w	#2,(MsuReady).w
	bne.s	.try
	move.w	d3,(MsuLastId).w	;the splash asks before the TOC read has finished
	move.w	#1,(MsuMuteFm).w	;hold the FM arrangement until the CD track can start
	moveq	#64,d2			;about sixteen seconds; the pictures are not up yet
.wait
	move.w	#$FFFF,d1
.spin
	cmpi.b	#1,$A12020.l
	bne.s	.try
	dbf	d1,.spin
	dbf	d2,.wait
.try
	move.w	(MsuHold).w,d4		;nonzero if a track was left running
	bsr.w	MsuTryReady
	bne.s	.fm
	tst.w	d4
	beq.s	.fresh
	cmpi.w	#$12,d4
	bne.s	.go			;a play-once track is replaced
	cmp.w	(MsuLastId).w,d3
	beq.s	.x			;this loop is already on the CD
	bra.s	.go
.fresh
	tst.w	(MsuHold).w
	bne.s	.x			;late init already started this song
.go
	tst.w	(MsuMusic).w
	bne.s	.fm
	move.w	#1,(MsuMuteFm).w
	move.w	d3,d0			;song id, not the 0 MsuTryReady left in d0
	bsr.w	MsuStartSong
	bra.s	.x
.fm
	cmpi.w	#2,(MsuReady).w
	beq.s	.x			;still waiting: leave the FM arrangement muted
	clr.w	(MsuMuteFm).w
	tst.w	(MsuMusic).w
	beq.s	.x			;CD is on: a failed init has nothing to pause
	bsr.w	MsuSilence		;FM mode: a play-once track was not paused by MsuRelease
.x
	movem.l	(sp)+,d0-d4/a0-a2
	rts

MsuSilence	;Pause the CD voice now. p_turnoff
	cmpi.w	#1,(MsuReady).w
	bne.s	.x
	clr.w	(MsuHold).w
	clr.w	(MsuMuteFm).w
	clr.w	(MsuTrack).w
	clr.w	(MsuLeft).w
	move.w	#$1300,d0	;PAUSE, fade 0
	bsr.w	MsuCmd
.x	rts

MsuRelease	;stop_current_song. A loop pauses. A play-once organ keeps going through the whistle
	cmpi.w	#$11,(MsuHold).w
	beq.s	.x
	tst.w	(MsuHold).w
	beq.s	.x
	bsr.w	MsuSilence
.x	rts

MsuStreamEnded	;A stream hit its end marker (a0). A loop gives the voice back. A play-once track does not
	cmpa.l	#fmtune_id_30_cmdstream,a0
	bcs.s	.x
	clr.w	(MsuMuteFm).w
	cmpi.w	#$11,(MsuHold).w
	beq.s	.x
	clr.w	(MsuHold).w
.x	rts

MsuFilterCmd	;ProcessOneMusicTrack. While MsuMuteFm is set, song events do not reach the FM chip
	tst.w	(MsuMuteFm).w
	beq.s	.x
	cmpa.l	#fmtune_id_30_cmdstream,a0
	bcs.s	.x
	lea	MsuDoNothing(pc),a2
.x	rts
MsuDoNothing
	rts

MsuCrowdBed	;updatesound. Loop track 2 while CD music is on and no song owns the voice
	movem.l	d0-d2,-(sp)
	bsr.w	MsuTryReady
	bne.s	.x
	tst.w	(MsuMusic).w
	bne.s	.x
	bsr.w	MsuPollEnd
	tst.w	(MsuHold).w
	bne.s	.x
	cmpi.w	#2,(MsuTrack).w
	beq.s	.x
	moveq	#2,d0
	moveq	#$12,d1
	bsr.w	MsuPlay
.x
	movem.l	(sp)+,d0-d2
	rts

MsuChangeOption	;Left / right on the CD Music line. d2 is the step (0 = redraw only)
	movem.l	d0-d3,-(sp)
	bsr.w	MsuTryReady
	bne.s	.off
	move.w	(MsuMusic).w,d3
	add.w	d2,d3
	bpl.s	.hi
	moveq	#1,d3
.hi
	cmpi.w	#2,d3
	blt.s	.set
	moveq	#0,d3
.set
	move.w	d3,(MsuMusic).w
	tst.w	d2
	beq.s	.x
	bsr.w	MsuApplyChoice
	bra.s	.x
.off
	move.w	#1,(MsuMusic).w
.x
	movem.l	(sp)+,d0-d3
	rts

MsuApplyChoice	;Replay the current song in the mode just chosen. No song: FM mode pauses the bed
	cmpi.w	#1,(MsuReady).w
	bne.s	.x
	move.w	(MsuLastId).w,d0
	cmpi.w	#$30,d0
	blt.s	.idle
	jsr	(play_sfx_or_music_track).l
	rts
.idle
	tst.w	(MsuMusic).w
	beq.s	.x
	bsr.w	MsuSilence
.x	rts

MsuPollEnd	;d7 = vblanks since the last game frame. A finished one-shot frees the voice
	cmpi.w	#$11,(MsuHold).w
	bne.s	.x
	move.w	(MsuLeft).w,d0
	sub.w	d7,d0
	bhi.s	.keep
	clr.w	(MsuHold).w		;voice is free; the bed play below sends track 2
	clr.w	(MsuLeft).w
	rts
.keep
	move.w	d0,(MsuLeft).w
.x	rts

MsuLengths	;NTSC frames for USA redump T-50015 tracks 7-78. sectors*60/75, minus 60
	dc.w	1359,1349,1527,948,1561,1245,1380,1432	;7
	dc.w	1406,1038,868,1439,1631,848,1204,1320	;15
	dc.w	1792,1600,1258,1163,1315,1561,1270,1504	;23
	dc.w	1317,1509,976,1116,1036,1034,823,1080	;31
	dc.w	1420,1228,1258,1181,1315,1195,992,1066	;39
	dc.w	1629,862,872,1362,1059,1065,1556,1544	;47
	dc.w	1528,1432,1860,1848,1328,2049,1626,1294	;55
	dc.w	1682,1073,951,824,1179,1060,787,980	;63
	dc.w	812,926,1686,1304,1776,1019,1405,1304	;71

	even
MsuDriver	;krikzz msu-drv.bin. Looping tracks end themselves. A play-once track does not. See docs/msu.md.
	;Returns 0 in d0, or 1 if $400100 is not the Mega CD BIOS
	incbin	msu\msu-drv.bin
	even
