;	Instant replay. This file records each frame of play, plays it back with the replay icon and
;	banner, moves the camera and restores the frames. New in 94: the reverse angle replay.

ReplayMode							;Instant replay play-back control and display code.
									;Called from the pause menu.
									;Tracking: a d-pad press picks the nearest object in that direction and
									;the camera follows it
	bclr	#0,(sflags5).w			;not slow mode
	bsr.w	forceblack				;screen off
	move.w	(disflags).w,-(sp)
	bset	#sf2replay,(sflags2).w	;flag that replay is on
	bclr	#4,(sflags4).w			;normal angle
	jsr	(ClrHor).l					;horizontal interrupt off
	move.w	#$400,d0				;$400 cells
	move.w	(VmMAP3).w,d1
	move.w	#$7FF,d2				;blank char
	bsr.w	DoFill
	move.w	(ExtraChars).w,d4
	movea.l	#ReplayMap+8,a2
	jsr	(DecompressGraphicsPlain).l
	jsr	(ShowReplayIcon).l
	bclr	#sfscrl,(sflags).w		;manual scroll is off
	bclr	#sf3track,(sflags3).w
	st	(replayactive).w
	movea.l	(recbpr).w,a4			;record buffer pointer (current frame)
.rwd								;loop
	bsr.w	suba4					;Rewind to first frame
	tst.w	d7						;more to rewind?
	bne.s	.rwd
	jsr	(SprSort).l
	jsr	(setvideo).l
	bclr	#sf3rmplay,(sflags3).w
	clr.l	(padcont).w
	clr.l	(padcont+4).w
	clr.l	(padcont+8).w
	move.w	#$18,(palcount).w		;fade in
	moveq	#1,d7					;1 frame
.top								;loop
	move.w	(Vcount).w,d0			;wait until d7 frames have passed
	sub.w	(OldVcount).w,d0		;frames since the last
	cmp.w	d0,d7					;enough?
	bhi.s	.top
	move.w	(Vcount).w,(OldVcount).w	;new frame count
	tst.w	(replayicontimer).w		;icon showing?
	bmi.w	.0
	sub.w	d7,(replayicontimer).w
	bpl.w	.0
	clr.w	(replayicontimer).w
	jsr	(EraseReplayIcon).l
.0									;icon timer handled
	movem.l	d0/a3,-(sp)
	movea.l	#SortCords+(12*SCstruct),a3
	move.w	#1,oldframe(a3)
	movea.l	#SortCords+(13*SCstruct),a3
	move.w	#1,oldframe(a3)
	movem.l	(sp)+,d0/a3
	moveq	#1,d7					;1 frame
	bsr.w	getpzjoy				;read the paused pad
	btst	#0,(sflags5).w			;slow mode?
	beq.w	.2
	andi.w	#$FFF0,d0				;direction bits only
	ori.w	#8,d0					;no direction
	andi.w	#$FFF0,d1
	andi.w	#$FFF0,d3
.2									;positions rounded in slow mode
	movea.w	#(CameraPosStruct-M68K_RAM),a5
	btst	#sf3track,(sflags3).w	;tracking an object?
	beq.w	.dir
	move.w	d1,d5
	andi.w	#$F,d5					;new d-pad press?
	beq.w	.nomans
.dir								;not tracking, or a new d-pad press: manual camera
	btst	#3,d0					;no direction?
	bne.w	.nomans
	cmpi.w	#$FF60,(a5)				;X past the left?
	bgt.w	.3
	move.w	#0,(a5)					;centre
	bra.w	*+4
.3									;X inside the rink
	cmpi.w	#$FED0,Ypos(a5)			;Y past the bottom?
	bgt.w	.4
	move.w	#0,Ypos(a5)				;centre
.4									;Y inside the rink
	bset	#sfscrl,(sflags).w		;manual scrolling is on
	bne.w	.man					;scrolling?
	move.w	(Hpos).w,(a5)			;first frame: camera starts at the screen
	move.w	(Vpos).w,Ypos(a5)
.man								;camera on manual
	move.w	d0,d5					;d5 = d-pad direction
	andi.w	#7,d5					;direction
	eori.w	#4,d5					;opposite
	movea.w	#(SortCords-M68K_RAM),a1
	st	d3							;no object to skip
	bclr	#sf3track,(sflags3).w
	beq.w	.find					;was not tracking
	move.w	camtrack(a5),d3			;skip the object tracked now
.find								;search start, skipping the tracked object
	move.w	(a5),d0					;camera position d0/d1: search 12 players
	move.w	Ypos(a5),d1
	moveq	#$B,d2
	move.l	#$100,d4				;nearest distance squared so far
	movem.w	d0-d1,-(sp)				;save the camera position
.loop								;each player
	cmp.w	SCnum(a1),d3			;loop over the 12 players, skipping the tracked one
	beq.w	.skip					;tracked object?
	movem.w	(sp),d0-d1				;camera position
	sub.w	(a1),d0
	sub.w	Ypos(a1),d1
	jsr	(vtoa).l					;direction to object
	btst	#3,d0					;no direction?
	bne.w	.skip
	sub.w	d5,d0					;minus the pad direction
	addq.w	#1,d0
	andi.w	#7,d0
	cmp.w	#2,d0					;within 45 degrees?
	bhi.w	.skip					;not within 45 degrees of the d-pad
	movem.w	(sp),d0-d1				;camera position
	sub.w	(a1),d0
	sub.w	Ypos(a1),d1
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0					;distance squared
	cmp.l	#4,d0					;too close?
	bls.w	.skip					;too close
	cmp.l	d4,d0					;closer?
	bhi.w	.skip
	move.l	d0,d4					;closest so far
	move.w	SCnum(a1),camtrack(a5)
	bset	#sf3track,(sflags3).w
.skip								;next player
	adda.w	#SCstruct,a1
	dbf	d2,.loop					;loop
	addq.w	#4,sp					;drop the camera position
	btst	#sf3track,(sflags3).w	;tracking?
	beq.w	.scrl					;nothing found: scroll by hand
	move.w	camtrack(a5),d0
	asl.w	#7,d0					;* SCstruct
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3
	moveq	#4,d4					;4 pads
	bsr.w	setpads					;set the pads
	bsr.w	UpdateCameraPos
	jsr	(setvideo).l
	bra.w	.top
.scrl								;sf3track clear
	bset	#sfscrl,(sflags).w		;no object found: scroll the camera by hand
	eori.w	#4,d5					;opposite
	asl.w	#2,d5
	lea	.dirtab(pc),a0
	move.w	0(a0,d5.w),d0
	add.w	(a5),d0					;plus the camera X
	cmp.w	#$88,d0					;past the right?
	bgt.w	.nox
	cmp.w	#$FF78,d0				;past the left?
	blt.w	.nox
	move.w	d0,(a5)
.nox								;X step taken (or out of range)
	move.w	2(a0,d5.w),d1
	add.w	Ypos(a5),d1				;plus the camera Y
	cmp.w	#$126,d1				;past the top?
	bgt.w	.noy
	cmp.w	#$FEDA,d1				;past the bottom?
	blt.w	.noy
	move.w	d1,Ypos(a5)
.noy								;Y step taken (or out of range)
	movea.w	a5,a3					;camera struct is the object to follow
	clr.w	camidle(a5)				;camera moving
	andi.w	#$FFF,(PadControlBits).w	;keep the low bits
	ori.w	#$E000,(PadControlBits).w	;pads off
	bsr.w	UpdateCameraPos			;camera position
	jsr	(setvideo).l
	bra.w	.top
.dirtab								;scroll step per d-pad direction 0-7: x, y
	dc.w	0,2, 2,2
	dc.w	2,0, 2,-2
	dc.w	0,-2, -2,-2
	dc.w	-2,0, -2,2
.nomans								;d5 = 0 or bit 3 of d0 set
	st	camidle(a5)
	btst	#5,d1					;C?
	beq.w	.00
	btst	#0,(sflags5).w			;slow mode?
	bne.w	.00
	bchg	#sf3rmplay,(sflags3).w
.00									;C toggles play mode (not in slow mode)
	btst	#6,d3					;A held?
	beq.w	.5
	btst	#0,(sflags5).w			;slow mode?
	bne.w	.5
	bsr.w	suba4					;fast rewind
	bsr.w	suba4					;back a frame
	bsr.w	suba4					;back a frame
	bsr.w	suba4					;back a frame
	jsr	(SprSort).l
	jsr	(setvideo).l
	moveq	#1,d7					;1 frame
	bclr	#sf3rmplay,(sflags3).w	;turn off play mode
.5									;A: back a frame, unless slow mode
	btst	#0,(sflags5).w			;slow mode?
	bne.w	.1
	btst	#4,d3					;B held?
	beq.w	.1
	btst	#6,d3					;A too?
	beq.w	.f1
	bclr	#sf3track,(sflags3).w
	bclr	#sfscrl,(sflags).w		;a+b but = manual scroll off (hidden feature)
	move.w	d0,-(sp)
	move.w	(PadControlBits).w,d0
	andi.w	#$FFF,d0				;keep the low bits
	ori.w	#$E000,d0				;pads off
	move.w	d0,(PadControlBits).w
	move.w	(sp)+,d0
	bra.w	.top
.f1									;bit 6 of d3 clear
	bsr.w	adda4					;forward a frame
	jsr	(SprSort).l
	jsr	(setvideo).l
	asl.w	#1,d7					;double delay time between frames = 1/2 speed slow motion
	bclr	#sf3rmplay,(sflags3).w	;turn off play mode
.1									;B: forward at half speed, unless slow mode
	btst	#sf3rmplay,(sflags3).w	;play mode on?
	beq.w	.noplay
	st	(lastsfx).w					;play mode is on = advance one frame at original speed
	bsr.w	adda4					;forward a frame
	move.w	(lastsfx).w,-(sp)		;play sound effects
	bsr.w	sfx
	jsr	(SprSort).l
.noplay								;frame advanced or not, redraw
	jsr	(setvideo).l
	btst	#0,(sflags5).w			;slow mode?
	bne.w	.6
	btst	#7,d1					;start?
	beq.w	.top
	jsr	(ShowReplayBanner).l
	bclr	#sf3rmplay,(sflags3).w
	bset	#0,(sflags5).w			;slow mode
	bne.w	.6
	bra.w	.top
.6									;bit 0 of sflags5 set or 0 was set
	btst	#7,d1					;start?
	bne.w	.8
	btst	#6,d1					;A?
	bne.w	.7
	btst	#4,d1					;B?
	bne.w	.exit
	btst	#5,d1					;C?
	beq.w	.top
	bset	#6,(sflags4).w			;reverse angle change
	bclr	#0,(sflags5).w			;not slow mode
	jsr	(EraseReplayBanner).l
	bsr.w	adda4					;forward a frame
	jsr	(SprSort).l
	bra.w	.top
.7									;bit 6 of d1 set
	jmp	.top
.8									;bit 7 of d1 set
	clr.w	(menuitem).w
	bset	#1,(sflags5).w			;back to the menu
.exit								;leave the replay
	bsr.w	forceblack				;screen off
	ori.w	#$F000,(PadControlBits).w	;pads off
	bclr	#sfscrl,(sflags).w
	movea.l	(recbpr).w,a4			;back to the current frame
	bclr	#4,(sflags4).w			;normal angle
	bsr.w	RestoreReplayFrame		;restore the frame
	jsr	(SprSort).l
	bclr	#sf2replay,(sflags2).w
	move.w	(sp)+,(disflags).w
	jsr	(ReloadRinkGraphics).l
	jsr	(setupEASportsMap).l
	jsr	(ReloadEnergyBarTiles).l
	jsr	(ReloadCrowdTiles).l
	jsr	(ReloadRefTiles).l
	btst	#4,(disflags).w			;faceoff showing?
	beq.w	.10
	jsr	(ReloadFaceOffMap).l
	jsr	(ReloadFaceOffTiles).l
.10									;faceoff map reloaded when it was showing
	jsr	(SetHor).l					;horizontal interrupt on
	jsr	(setvideo).l
	move.w	#$18,(palcount).w		;fade in
	rts								;exit replay mode
getpzjoy							;read the joystick of the pad that paused. pads 3 and 4 when FourWayPlay
									;(pausepad = 3 or 4)
	tst.w	(FourWayPlay).w			;four way?
	bne.w	.0
.loop								;loop
	btst	#sfpj,(sflags).w		;pad 2 paused?
	bne.w	ReadJoy2
	bra.w	ReadJoy1
.0									;FourWayPlay <> 0
	tst.w	(pausepad).w			;pad 1 or 2?
	beq.s	.loop
	cmpi.w	#3,(pausepad).w			;pad 3?
	beq.w	ReadJoy3
	bra.w	ReadJoy4
ShowReplayIcon						;Show the replay icon and start the $F0 frame replayicontimer timer
	move.w	#$F0,(replayicontimer).w
	bsr.w	printz					;map at the icon
	String	CC_Font3Pri,2,2
	moveq	#$20,d0
	moveq	#$55,d1
	moveq	#8,d2
	moveq	#4,d3
	move.w	(rinkvrcset).w,d4
	move.w	#0,d5					;no palette lines
	movea.l	#Rinktilelist,a1
	btst	#4,(sflags4).w			;check if reverse angle replay
	beq.w	.0
	movea.l	#RevRinkTilelist,a1		;reverse rink tile list
.0									;normal or reverse rink tiles chosen
	adda.l	jimdata(a1),a1
	movea.w	#null,a2
	bra.w	dobitmap
EraseReplayIcon						;Erase the 8 x 4 replay icon (replayicontimer timer ran out)
	jsr	(printz).l					;map at the icon
	String	CC_Font3Pri,2,2
	move.w	#8,d0					;8 wide
	move.w	#4,d1
	move.w	#$7FF,d2				;blank char
	jmp	eraser
ShowReplayBanner					;Show ReplayMap at 0,0 (16 x 11) and stop the replayicontimer timer
	st	(replayicontimer).w
	bsr.w	printz					;map at the top left
	String	CC_Font3Pri,2,0
	moveq	#0,d0
	moveq	#0,d1
	moveq	#$10,d2
	moveq	#$B,d3
	move.w	(ExtraChars).w,d4
	move.w	#0,d5					;no palette lines
	movea.l	#ReplayMap,a1
	adda.l	jimdata(a1),a1
	movea.w	#null,a2
	bra.w	dobitmap
EraseReplayBanner					;Erase the 16 x 11 area ShowReplayBanner drew
	jsr	(printz).l					;map at the top left
	String	CC_Font3Pri,2,2
	move.w	#$10,d0					;16 wide
	move.w	#$B,d1
	move.w	#$7FF,d2				;blank char
	jmp	eraser
suba4								;a4 = current replay frame. Back up 1 frame and set video parameters for
									;display.
									;d7 = delay between frames, or zero at the end of the replay
	cmpa.l	#M68K_RAM,a4			;at the start of the buffer?
	bne.w	.1
	btst	#sfwrap,(sflags).w		;wrapped?
	beq.w	.end
	movea.l	#replayend,a4			;end of the buffer
.1									;frame pointer ready (wrapped to the end of the buffer)
	suba.w	#replaysize,a4			;back a frame
	cmpa.l	(recbpr).w,a4			;at the oldest?
	bne.w	RestoreReplayFrame
	adda.w	#replaysize,a4
.end								;at an end of the replay
	bsr.w	RestoreReplayFrame		;at either end of the replay: show frame, d7 = 0
	clr.w	d7
	rts
adda4								;Step forward 1 frame. First handles a reverse
									;angle switch (sflags4 bit 6)
	bclr	#6,(sflags4).w			;reverse angle change?
	beq.w	.1
	movem.l	d0-d7/a0-a6,-(sp)
	bchg	#4,(sflags4).w			;toggle reverse angle
	move.w	(Hpos).w,-(sp)
	move.w	(Vpos).w,-(sp)
	bsr.w	forceblack2
	jsr	(vcountwait).l				;frame
	jsr	(vcountwait).l				;frame
	jsr	(ReloadRinkGraphics).l
	clr.w	(Hpos).w
	clr.w	(Vpos).w
	move.w	#$7D0,(Oldrow).w		;redraw all rows
	move.w	#1,d0
.loop								;2 frames to redraw
	jsr	(setvideo).l
	jsr	(vcountwait).l				;frame
	dbf	d0,.loop					;loop
	move.w	(sp)+,(Vpos).w
	move.w	(sp)+,(Hpos).w
	move.w	#1,d0
	jsr	(setvideo).l
.loop2								;wait 2 more frames
	jsr	(vcountwait).l				;frame
	dbf	d0,.loop2					;loop
	movem.l	a0,-(sp)
	movea.l	#SortCords+(12*SCstruct),a0
	move.w	#1,oldframe(a0)
	adda.w	#$80,a0					;object 13
	move.w	#1,oldframe(a0)
	movem.l	(sp)+,a0
	bsr.w	RevReplayAdj			;reverse adjust
	btst	#sfscrl,(sflags).w		;scrolling?
	beq.w	*+4
.0									;(not branched to)
	jsr	(ShowReplayIcon).l
	move.w	#$64,(palcount).w		;copy now
	movem.l	(sp)+,d0-d7/a0-a6
.1									;end of the reload
	clr.w	d7
	btst	#sf2drec,(sflags2).w	;recording?
	beq.w	adda42
	movem.l	a4,-(sp)
	bsr.w	adda43					;look ahead
	cmpa.l	(recbpr).w,a4			;at the newest?
	movem.l	(sp)+,a4
	beq.w	rtss8
adda42								;adda4 without the sf2drec look-ahead: stop at the record point, else show
									;the frame and fall into adda43
	cmpa.l	(recbpr).w,a4			;at the newest?
	beq.w	rtss8
	bsr.w	RestoreReplayFrame
adda43								;a4 += replay frame size ($62), wrapping from replayend to M68K_RAM
	adda.w	#replaysize,a4			;next frame
	cmpa.l	#replayend,a4			;past the end?
	bne.w	rtss8
	movea.l	#M68K_RAM,a4			;wrap to the start
	rts
UpdateCameraPos						;Camera struct a5 = object a3 x/y (negated for the reverse angle),
									;Hpos/Vpos clamped
	movem.l	d0-d2,-(sp)
	move.w	(a3),d0
	btst	#7,(sflags4).w			;reverse angle?
	beq.w	.0
	neg.w	d0
.0									;X mirrored for reverse angle
	move.w	d0,(a5)
	move.w	Ypos(a3),d1
	btst	#7,(sflags4).w			;reverse angle?
	beq.w	.2
	neg.w	d1
.2									;Y mirrored for reverse angle
	move.w	d1,Ypos(a5)
	cmp.w	#$3C,d0					;past $3C?
	blt.w	.4
	move.w	#$3C,d0
.4									;X not past the right limit
	cmp.w	#$FFC4,d0				;past -$3C?
	bgt.w	.1
	move.w	#$FFC4,d0
.1									;X inside the limits
	move.w	d0,(Hpos).w
	cmp.w	#$100,d1				;past $100?
	blt.w	.5
	move.w	#$100,d1
.5									;Y not past the top limit
	cmp.w	#$FF38,d1				;past -$C8?
	bgt.w	.3
	move.w	#$FF38,d1
.3									;Y inside the limits
	move.w	d1,(Vpos).w
	movem.l	(sp)+,d0-d2
	rts
; set flag for reverse replay setup if needed
RevReplayAdj						;Set sflags4 bit 7 for a reverse angle replay, then fall into
									;RestoreReplayFrame
	btst	#4,(sflags4).w			;check if reverse angle replay
	beq.w	RestoreReplayFrame
	bset	#7,(sflags4).w
; a4 = current replay frame address to convert into normal coordinates
RestoreReplayFrame					;a4 = current replay frame address to convert into normal cordinates, then
									;the other replay variables. Flips x/y and frames for the reverse angle
	movem.l	d0-d2/a0/a6,-(sp)
	movea.l	#revframetbl,a6			;reverse frame table
	movea.l	a4,a0					;frame data
	moveq	#$F,d1					;16 objects to convert (12 players/2 nets/puck/puck shadow)
	movea.w	#(SortCords-M68K_RAM),a3
.top								;each of the 16 objects
	move.w	2(a0),d2				;loop over the 16 objects: x from word 1
	andi.w	#$3FF,d2
	btst	#9,d2					;negative?
	beq.w	.chkrevx
	ori.w	#$FC00,d2
.chkrevx							;X sign extended
	btst	#4,(sflags4).w			;check if reverse angle
	beq.w	.p
	neg.w	d2
.p									;X mirrored for reverse angle
	move.w	d2,(a3)					;update Xpos
	move.l	(a0),d2					;frame long
	asr.l	#4,d2
	asr.w	#6,d2
	btst	#9,d2					;negative?
	beq.w	.chkrevy
	ori.w	#$FC00,d2
.chkrevy							;Y sign extended
	btst	#4,(sflags4).w			;check if reverse angle
	beq.w	.p1
	neg.w	d2
	cmp.w	#0,d1					;check if last object (puck shadow)
	bne.w	.p1
	addq.w	#2,d2					;update puck shadow Xpos
.p1									;Y mirrored (puck shadow shifted) for reverse angle
	move.w	d2,Ypos(a3)
	move.w	(a0),d2					;frame word
	asr.w	#4,d2
	andi.w	#$3FF,d2
	btst	#4,(sflags4).w			;check if reverse angle
	beq.w	.2
	asl.w	#1,d2
	move.w	0(a6,d2.w),d2			;look up table to adjust d2
	cmpi.w	#$F,SCnum(a3)			;check if puck shadow
	bne.w	.0
	cmp.w	#SPFpuck,d2				;puck?
	beq.w	.0
	move.w	#$FC00,Ypos(a3)			;update Ypos of puck shadow
.0									;puck shadow handled
	cmp.w	#1,d2					;check if frame is before frame 1 (out of range)
	blt.w	.1
	cmp.w	#$34E,d2				;check if frame is >= 846 (last frame +1)
	bge.w	.1
	bra.w	.2						;branch if valid object frame
.1									;d2 < 1 or d2 >= $34E
	move.w	(a0),d2					;frame word
	asr.w	#4,d2
	andi.w	#$3FF,d2
.2									;frame number ready
	move.w	d2,frame(a3)
	cmp.w	#SPFbglass,d2			;check if frame is before glass shatter frames
	blt.w	.3
	cmp.w	#SPFbglass+5,d2			;check if frame is after glass shatter frames
	bge.w	.3
	btst	#4,(sflags4).w			;reverse angle?
	beq.w	.3
	move.w	#$190,Ypos(a3)			;glass Y
.3									;glass shatter moved for reverse angle
	move.w	(a0),d2					;frame word
	asr.w	#3,d2
	andi.w	#$1800,d2				;flip bits
	andi.w	#$E7FF,attribute(a3)	;flip bits
	or.w	d2,attribute(a3)
	btst	#4,(sflags4).w			;check if reverse angle replay
	beq.w	.4
	move.w	frame(a3),d2			;move frame into d2
	cmp.w	#SPFfight,d2			;check if frame is before old fight frames
	blt.w	.4
	cmp.w	#SPFPen,d2				;check if frame is after old fight frames
	bge.w	.4
	bchg	#3,attribute(a3)		;change X flip attribute for object
.4									;fight frames flipped
	addq.w	#4,a0					;next object data
	adda.w	#SCstruct,a3
	dbf	d1,.top						;loop to next object
	moveq	#5,d2					;6 pairs of players
	movea.w	#(SortCords-M68K_RAM),a3
.loop								;each pair of players
	move.b	(a0)+,rostnum(a3)		;loop over the 6 pairs of players
	move.b	(a0),d0					;position byte
	andi.w	#$F,d0					;low nibble
	cmp.w	#$F,d0					;$F?
	bne.w	.5
	moveq	#-1,d0
.5									;$F = no position (-1)
	move.w	d0,position(a3)			;position of the first player of the pair
	adda.w	#SCstruct,a3
	move.b	(a0)+,d0
	lsr.b	#4,d0					;high nibble
	move.b	d0,rostnum(a3)
	move.b	(a0),d0
	asl.b	#4,d0					;low nibble up
	or.b	d0,rostnum(a3)
	move.b	(a0)+,d0				;position byte
	lsr.b	#4,d0					;high nibble
	andi.w	#$F,d0
	cmp.w	#$F,d0					;$F?
	bne.w	.6
	moveq	#-1,d0
.6									;$F = no position (-1)
	move.w	d0,position(a3)
	adda.w	#SCstruct,a3
	dbf	d2,.loop					;loop
	move.b	(a0)+,d0
	ext.w	d0
	move.w	d0,(puckz).w
	move.b	(a0)+,d0
	ext.w	d0
	move.w	d0,(SortCords+((puckscnum+1)*SCstruct)+Zpos).w
	move.b	(a0)+,d0
	ext.w	d0
	move.w	d0,(lastsfx).w
	clr.w	d7
	move.b	(a0)+,d7				;frame delay
	move.w	(a0)+,d0
	andi.w	#$FFF,d0
	andi.w	#$F000,(PadControlBits).w
	or.w	d0,(PadControlBits).w	;merge them
	move.w	(a0)+,(Crowdframe).w	;crowd frame
	move.w	(a0)+,(glovecords).w
	move.b	(a0)+,(PBnum).w			;penalty box count
	clr.w	d0
	move.b	(a0)+,d0
	lsl.w	#4,d0
	ori.w	#$F00F,d0
	move.w	d0,(PadControlBits34).w
	btst	#sfscrl,(sflags).w		;scrolling?
	beq.w	.pos
	movea.w	a5,a3
	btst	#sf3track,(sflags3).w	;tracking an object?
	beq.w	.cam					;tracking?
	clr.w	camidle(a5)				;camera moving
	move.w	camtrack(a5),d0
	asl.w	#7,d0					;* SCstruct
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3
.cam								;camera follows a3
	bsr.w	UpdateCameraPos			;camera position
	bra.w	.7
.pos								;sfscrl clear
	move.w	(a0)+,(Hpos).w
	move.w	(a0)+,(Vpos).w
	btst	#4,(sflags4).w			;reverse angle?
	beq.w	.7
	neg.w	(Hpos).w
	neg.w	(Vpos).w
	jsr	(ClampReplayView).l
.7									;view clamped
	bclr	#7,(sflags4).w			;clear the reverse flag
	movem.l	(sp)+,d0-d2/a0/a6
	rts
ClampReplayView						;Clamp Hpos to -$3C..$3C and Vpos to -$C8..$100
	move.w	d0,-(sp)
	move.w	#$3C,d0
	cmp.w	(Hpos).w,d0				;Hpos past it?
	blt.w	.0
	move.w	#$FFC4,d0
	cmp.w	(Hpos).w,d0				;Hpos inside?
	ble.w	.1
.0									;Hpos past the limit: clamp
	move.w	d0,(Hpos).w
.1									;Hpos inside the limits
	move.w	#$100,d0
	cmp.w	(Vpos).w,d0				;Vpos past it?
	blt.w	.2
	move.w	#$FF38,d0
	cmp.w	(Vpos).w,d0				;Vpos inside?
	ble.w	.3
.2									;Vpos past the limit: clamp
	move.w	d0,(Vpos).w
.3									;Vpos inside the limits
	move.w	(sp)+,d0
	rts
; called every frame to save replay events
; d7 = elapsed frames
updatereplay						;called every frame to save replay events, d7 = elapsed frames
	btst	#gmhl,(gmode).w
	bne.w	rtss8
	btst	#sf2drec,(sflags2).w	;check if replay record disabled
	beq.w	.0
	tst.w	(replaydelay).w			;delay?
	beq.w	.rec
	subq.w	#1,(replaydelay).w
	bpl.w	.0						;still delaying
	clr.w	(replaydelay).w
	bra.w	.rec
.0									;sf2drec clear or replaydelay >= 0
	addi.l	#replaysize,(recbpr).w
	cmpi.l	#replayend,(recbpr).w
	bne.w	.rec					;not at the end
	bset	#sfwrap,(sflags).w
	move.l	#M68K_RAM,(recbpr).w	;back to the start
.rec								;record into the next slot
	movea.l	(recbpr).w,a0			;a0 = the record slot
	moveq	#$F,d2					;16 objects
	movea.w	#(SortCords-M68K_RAM),a3
.top								;pack each of the 16 objects
	clr.l	(a0)					;loop over the 16 objects: pack x, y, frame, flip bits
	move.w	(a3),d1					;Xpos
	andi.w	#$3FF,d1
	move.w	d1,2(a0)
	clr.l	d1
	move.w	Ypos(a3),d1
	asl.w	#6,d1
	asl.l	#4,d1
	or.l	d1,(a0)
	move.w	frame(a3),d1
	asl.w	#4,d1
	or.w	d1,(a0)
	move.w	attribute(a3),d1
	andi.w	#$1800,d1				;flip bits
	asl.w	#3,d1
	or.w	d1,(a0)					;merge them
	addq.w	#4,a0
	adda.w	#SCstruct,a3
	dbf	d2,.top						;loop
	moveq	#5,d2					;6 pairs of players
	movea.w	#(SortCords-M68K_RAM),a3
.loop								;each pair of players
	move.b	rostnum(a3),(a0)+		;loop over the 6 pairs of players
	move.w	position(a3),d0
	bpl.w	.n0
	moveq	#$F,d0					;not on ice
.n0									;off the ice: $F
	andi.w	#$F,d0					;position nibble
	move.b	d0,(a0)
	adda.w	#SCstruct,a3
	move.b	rostnum(a3),d0
	asl.w	#4,d0
	or.b	d0,(a0)+
	move.b	rostnum(a3),d0
	lsr.b	#4,d0					;high nibble
	move.b	d0,(a0)
	move.w	position(a3),d0
	bpl.w	.n1
	moveq	#$F,d0					;not on ice
.n1									;position nibble ready
	asl.w	#4,d0					;position to the high nibble
	or.b	d0,(a0)+
	adda.w	#SCstruct,a3
	dbf	d2,.loop					;loop
	move.b	(puckz+1).w,(a0)+
	move.b	(SortCords+((puckscnum+1)*SCstruct)+Zpos+1).w,(a0)+
	move.b	(lastsfx+1).w,(a0)+
	bset	#7,(lastsfx+1).w		;cue saved
	move.b	d7,(a0)+
	move.w	(PadControlBits).w,(a0)+
	move.w	(Crowdframe).w,(a0)+	;crowd frame
	move.w	(glovecords).w,(a0)+
	move.b	(PBnum).w,(a0)+			;penalty box count
	move.w	d0,-(sp)
	move.w	(PadControlBits34).w,d0	;pads 3 and 4 bits
	lsr.w	#4,d0
	move.b	d0,(a0)+
	move.w	(sp)+,d0
	move.w	(Hpos).w,(a0)+
	move.w	(Vpos).w,(a0)+
rtss8								;shared rts for the early exits nearby
	rts
