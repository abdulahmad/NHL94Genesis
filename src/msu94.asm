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
;	splash and main menu song. VLC lists that recording as track 3 because track 1
;	is data. $79 (end of game) loops track 5, the intermission. The menu MSCPLAYR
;	stores 5 and cdstart stores 4; on this disc those two recordings are the other
;	way around. $7A (scouting) loops track 3: the disc ignores $7A, and track 3 is
;	the second music track.
;	Track 2 is the crowd bed. It loops while no song owns the CD voice. A play-once
;	song keeps the voice through the whistle and the FM stream. The driver already
;	pauses a $11 track (the same idea as MSCPLAY1). It does that about two seconds
;	before the next disc track, writes 1 to $A12021, and leaves the voice stopped.
;	It does not pick the next track. The next updatesound sees that 1, drops the
;	hold, and sends a normal play-loop of track 2, which is what cdtrack.asm does
;	after the BIOS has paused. Looping songs keep the driver's own end check. A
;	new command clears the byte. The PSG crowd in updatesound is never removed.
;	One CD-DA voice cannot play the bed under a song.

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
	bsr.w	MsuPlay
	rts

MsuHandleSong	;play_sfx_or_music_track, after stop_current_song, d0 = song id. Preserves regs.
	;MsuTryReady returns 0 or 1 in d0, so the song id is kept in d3 and passed to MsuStartSong.
	movem.l	d0-d4/a0-a2,-(sp)
	move.w	d0,d3
	cmpi.w	#2,(MsuReady).w
	bne.s	.try
	move.w	d3,(MsuLastId).w	;the splash asks before the TOC read has finished
	move.w	#1,(MsuMuteFm).w	;hold the FM arrangement until the CD track can start
	moveq	#64,d2			;about sixteen seconds; the title screen has not started yet
.wait
	move.w	#$FFFF,d1
.spin
	cmpi.b	#1,$A12020.l
	bne.s	.try
	dbf	d1,.spin
	dbf	d2,.wait
.try
	move.w	(MsuHold).w,d4		;nonzero if a play-once track was left running
	bsr.w	MsuTryReady
	bne.s	.fm
	tst.w	d4
	bne.s	.go			;this request replaces that track
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

MsuPollEnd	;Play-once: the driver pauses at the end and writes 1 to $A12021. It does not start the crowd.
	cmpi.w	#$11,(MsuHold).w
	bne.s	.x
	cmpi.b	#1,$A12021.l
	bne.s	.x
	clr.w	(MsuHold).w		;voice is free; the bed play below sends track 2
.x	rts

	even
MsuDriver	;krikzz msu-drv.bin. A play-once track pauses before the next disc track. See docs/msu.md.
	;Returns 0 in d0, or 1 if $400100 is not the Mega CD BIOS
	incbin	msu\msu-drv.bin
	even
