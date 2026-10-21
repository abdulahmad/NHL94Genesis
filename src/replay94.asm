;	Instant replay. This file records each frame of play, plays it back with the replay icon and
;	banner, moves the camera and restores the frames. It then updates every player and animation
;	each frame and keeps the scroll window on the play. New in 94: the reverse angle replay.

ReplayMode							;Instant replay play-back control and display code.
									;Called from the pause menu.
									;Tracking: a d-pad press picks the nearest object in that direction and
									;the camera follows it
	bclr	#0,(sflags5).w			;not slow mode
	bsr.w	forceblack				;screen off
	move.w	(disflags).w,-(sp)		;save the flags
	bset	#sf2replay,(sflags2).w	;flag that replay is on
	bclr	#4,(sflags4).w			;normal angle
	jsr	(ClrHor).l					;horizontal interrupt off
	move.w	#$400,d0				;$400 cells
	move.w	(VmMAP3).w,d1			;map 3
	move.w	#$7FF,d2				;blank char
	bsr.w	DoFill					;clear map 3
	move.w	(ExtraChars).w,d4		;extra chars
	movea.l	#ReplayMap+8,a2			;replay tiles
	jsr	(DecompressGraphicsPlain).l	;send them
	jsr	(ShowReplayIcon).l			;show the icon
	bclr	#sfscrl,(sflags).w		;manual scroll is off
	bclr	#sf3track,(sflags3).w	;no tracked object
	st	(replayactive).w			;replay on
	movea.l	(recbpr).w,a4			;record buffer pointer (current frame)
.rwd								;loop
	bsr.w	suba4					;Rewind to first frame
	tst.w	d7						;more to rewind?
	bne.s	.rwd					;loop
	jsr	(SprSort).l					;sort the sprites
	jsr	(setvideo).l				;video update
	bclr	#sf3rmplay,(sflags3).w	;not playing
	clr.l	(padcont).w				;no pad input
	clr.l	(padcont+4).w
	clr.l	(padcont+8).w
	move.w	#$18,(palcount).w		;fade in
	moveq	#1,d7					;1 frame
.top								;loop
	move.w	(Vcount).w,d0			;wait until d7 frames have passed
	sub.w	(OldVcount).w,d0		;frames since the last
	cmp.w	d0,d7					;enough?
	bhi.s	.top					;wait d7 frames
	move.w	(Vcount).w,(OldVcount).w	;new frame count
	tst.w	(replayicontimer).w		;icon showing?
	bmi.w	.0						;no
	sub.w	d7,(replayicontimer).w	;count down
	bpl.w	.0						;not yet
	clr.w	(replayicontimer).w		;0
	jsr	(EraseReplayIcon).l			;erase it
.0									;icon timer handled
	movem.l	d0/a3,-(sp)				;save
	movea.l	#SortCords+(12*SCstruct),a3	;object 12
	move.w	#1,oldframe(a3)			;redraw it
	movea.l	#SortCords+(13*SCstruct),a3	;object 13
	move.w	#1,oldframe(a3)			;redraw it
	movem.l	(sp)+,d0/a3				;restore
	moveq	#1,d7					;1 frame
	bsr.w	getpzjoy				;read the paused pad
	btst	#0,(sflags5).w			;slow mode?
	beq.w	.2						;no
	andi.w	#$FFF0,d0				;direction bits only
	ori.w	#8,d0					;no direction
	andi.w	#$FFF0,d1
	andi.w	#$FFF0,d3
.2									;positions rounded in slow mode
	movea.w	#(CameraPosStruct-M68K_RAM),a5	;camera struct
	btst	#sf3track,(sflags3).w	;tracking an object?
	beq.w	.dir
	move.w	d1,d5					;presses
	andi.w	#$F,d5					;new d-pad press?
	beq.w	.nomans					;no: keep tracking
.dir								;not tracking, or a new d-pad press: manual camera
	btst	#3,d0					;no direction?
	bne.w	.nomans					;yes
	cmpi.w	#$FF60,(a5)				;X past the left?
	bgt.w	.3						;no
	move.w	#0,(a5)					;centre
	bra.w	*+4						;(next line)
.3									;X inside the rink
	cmpi.w	#$FED0,Ypos(a5)			;Y past the bottom?
	bgt.w	.4						;no
	move.w	#0,Ypos(a5)				;centre
.4									;Y inside the rink
	bset	#sfscrl,(sflags).w		;manual scrolling is on
	bne.w	.man					;scrolling?
	move.w	(Hpos).w,(a5)			;first frame: camera starts at the screen
	move.w	(Vpos).w,Ypos(a5)		;camera Y
.man								;camera on manual
	move.w	d0,d5					;d5 = d-pad direction
	andi.w	#7,d5					;direction
	eori.w	#4,d5					;opposite
	movea.w	#(SortCords-M68K_RAM),a1	;objects
	st	d3							;no object to skip
	bclr	#sf3track,(sflags3).w	;stop tracking
	beq.w	.find					;was not tracking
	move.w	camtrack(a5),d3			;skip the object tracked now
.find								;search start, skipping the tracked object
	move.w	(a5),d0					;camera position d0/d1: search 12 players
	move.w	Ypos(a5),d1				;camera Y
	moveq	#$B,d2					;12 players
	move.l	#$100,d4				;nearest distance squared so far
	movem.w	d0-d1,-(sp)				;save the camera position
.loop								;each player
	cmp.w	SCnum(a1),d3			;loop over the 12 players, skipping the tracked one
	beq.w	.skip					;tracked object?
	movem.w	(sp),d0-d1				;camera position
	sub.w	(a1),d0					;dx
	sub.w	Ypos(a1),d1				;dy
	jsr	(vtoa).l					;direction to object
	btst	#3,d0					;no direction?
	bne.w	.skip					;yes: skip
	sub.w	d5,d0					;minus the pad direction
	addq.w	#1,d0					;plus 1
	andi.w	#7,d0					;0-7
	cmp.w	#2,d0					;within 45 degrees?
	bhi.w	.skip					;not within 45 degrees of the d-pad
	movem.w	(sp),d0-d1				;camera position
	sub.w	(a1),d0					;dx
	sub.w	Ypos(a1),d1				;dy
	muls.w	d0,d0					;dx squared
	muls.w	d1,d1					;dy squared
	add.l	d1,d0					;distance squared
	cmp.l	#4,d0					;too close?
	bls.w	.skip					;too close
	cmp.l	d4,d0					;closer?
	bhi.w	.skip					;not nearer
	move.l	d0,d4					;closest so far
	move.w	SCnum(a1),camtrack(a5)	;new target
	bset	#sf3track,(sflags3).w	;tracking
.skip								;next player
	adda.w	#SCstruct,a1			;next object
	dbf	d2,.loop					;loop
	addq.w	#4,sp					;drop the camera position
	btst	#sf3track,(sflags3).w	;tracking?
	beq.w	.scrl					;nothing found: scroll by hand
	move.w	camtrack(a5),d0			;tracked object
	asl.w	#7,d0					;* SCstruct
	movea.w	#(SortCords-M68K_RAM),a3	;objects
	adda.w	d0,a3					;this object
	moveq	#4,d4					;4 pads
	bsr.w	setpads					;set the pads
	bsr.w	UpdateCameraPos			;camera on it
	jsr	(setvideo).l				;video update
	bra.w	.top					;loop
.scrl								;sf3track clear
	bset	#sfscrl,(sflags).w		;no object found: scroll the camera by hand
	eori.w	#4,d5					;opposite
	asl.w	#2,d5					;long index
	lea	.dirtab(pc),a0				;step table
	move.w	0(a0,d5.w),d0			;X step
	add.w	(a5),d0					;plus the camera X
	cmp.w	#$88,d0					;past the right?
	bgt.w	.nox					;yes
	cmp.w	#$FF78,d0				;past the left?
	blt.w	.nox					;yes
	move.w	d0,(a5)					;store it
.nox								;X step taken (or out of range)
	move.w	2(a0,d5.w),d1			;y step
	add.w	Ypos(a5),d1				;plus the camera Y
	cmp.w	#$126,d1				;past the top?
	bgt.w	.noy					;yes
	cmp.w	#$FEDA,d1				;past the bottom?
	blt.w	.noy					;yes
	move.w	d1,Ypos(a5)				;store it
.noy								;Y step taken (or out of range)
	movea.w	a5,a3					;camera struct is the object to follow
	clr.w	camidle(a5)				;camera moving
	andi.w	#$FFF,(PadControlBits).w	;keep the low bits
	ori.w	#$E000,(PadControlBits).w	;pads off
	bsr.w	UpdateCameraPos			;camera position
	jsr	(setvideo).l				;video update
	bra.w	.top					;loop
.dirtab								;scroll step per d-pad direction 0-7: x, y
	dc.w	0,2, 2,2
	dc.w	2,0, 2,-2
	dc.w	0,-2, -2,-2
	dc.w	-2,0, -2,2
.nomans								;d5 = 0 or bit 3 of d0 set
	st	camidle(a5)					;camera idle
	btst	#5,d1					;C?
	beq.w	.00						;no
	btst	#0,(sflags5).w			;slow mode?
	bne.w	.00						;yes
	bchg	#sf3rmplay,(sflags3).w	;toggle play
.00									;C toggles play mode (not in slow mode)
	btst	#6,d3					;A held?
	beq.w	.5						;no
	btst	#0,(sflags5).w			;slow mode?
	bne.w	.5						;yes
	bsr.w	suba4					;fast rewind
	bsr.w	suba4					;back a frame
	bsr.w	suba4					;back a frame
	bsr.w	suba4					;back a frame
	jsr	(SprSort).l					;sort the sprites
	jsr	(setvideo).l				;video update
	moveq	#1,d7					;1 frame
	bclr	#sf3rmplay,(sflags3).w	;turn off play mode
.5									;A: back a frame, unless slow mode
	btst	#0,(sflags5).w			;slow mode?
	bne.w	.1						;yes
	btst	#4,d3					;B held?
	beq.w	.1						;no
	btst	#6,d3					;A too?
	beq.w	.f1						;no
	bclr	#sf3track,(sflags3).w	;stop tracking
	bclr	#sfscrl,(sflags).w		;a+b but = manual scroll off (hidden feature)
	move.w	d0,-(sp)				;save
	move.w	(PadControlBits).w,d0	;pad bits
	andi.w	#$FFF,d0				;keep the low bits
	ori.w	#$E000,d0				;pads off
	move.w	d0,(PadControlBits).w	;store it
	move.w	(sp)+,d0				;restore
	bra.w	.top					;loop
.f1									;bit 6 of d3 clear
	bsr.w	adda4					;forward a frame
	jsr	(SprSort).l					;sort the sprites
	jsr	(setvideo).l				;video update
	asl.w	#1,d7					;double delay time between frames = 1/2 speed slow motion
	bclr	#sf3rmplay,(sflags3).w	;turn off play mode
.1									;B: forward at half speed, unless slow mode
	btst	#sf3rmplay,(sflags3).w	;play mode on?
	beq.w	.noplay					;no
	st	(lastsfx).w					;play mode is on = advance one frame at original speed
	bsr.w	adda4					;forward a frame
	move.w	(lastsfx).w,-(sp)		;play sound effects
	bsr.w	sfx						;play it
	jsr	(SprSort).l					;sort the sprites
.noplay								;frame advanced or not, redraw
	jsr	(setvideo).l				;video update
	btst	#0,(sflags5).w			;slow mode?
	bne.w	.6						;yes
	btst	#7,d1					;start?
	beq.w	.top					;no: loop
	jsr	(ShowReplayBanner).l		;show the banner
	bclr	#sf3rmplay,(sflags3).w	;not playing
	bset	#0,(sflags5).w			;slow mode
	bne.w	.6						;was set
	bra.w	.top					;loop
.6									;bit 0 of sflags5 set or 0 was set
	btst	#7,d1					;start?
	bne.w	.8						;yes
	btst	#6,d1					;A?
	bne.w	.7						;yes
	btst	#4,d1					;B?
	bne.w	.exit					;yes: leave
	btst	#5,d1					;C?
	beq.w	.top					;no: loop
	bset	#6,(sflags4).w			;reverse angle change
	bclr	#0,(sflags5).w			;not slow mode
	jsr	(EraseReplayBanner).l		;erase the banner
	bsr.w	adda4					;forward a frame
	jsr	(SprSort).l					;sort the sprites
	bra.w	.top					;loop
.7									;bit 6 of d1 set
	jmp	.top						;loop
.8									;bit 7 of d1 set
	clr.w	(menuitem).w			;first menu item
	bset	#1,(sflags5).w			;back to the menu
.exit								;leave the replay
	bsr.w	forceblack				;screen off
	ori.w	#$F000,(PadControlBits).w	;pads off
	bclr	#sfscrl,(sflags).w		;not scrolling
	movea.l	(recbpr).w,a4			;back to the current frame
	bclr	#4,(sflags4).w			;normal angle
	bsr.w	RestoreReplayFrame		;restore the frame
	jsr	(SprSort).l					;sort the sprites
	bclr	#sf2replay,(sflags2).w	;replay off
	move.w	(sp)+,(disflags).w		;restore the flags
	jsr	(ReloadRinkGraphics).l		;rink graphics
	jsr	(setupEASNmap).l			;EASN logo
	jsr	(ReloadEnergyBarTiles).l	;energy bar
	jsr	(ReloadCrowdTiles).l		;crowd
	jsr	(ReloadRefTiles).l			;referee
	btst	#4,(disflags).w			;faceoff showing?
	beq.w	.10						;no
	jsr	(ReloadFaceOffMap).l		;faceoff map
	jsr	(ReloadFaceOffTiles).l		;faceoff tiles
.10									;faceoff map reloaded when it was showing
	jsr	(SetHor).l					;horizontal interrupt on
	jsr	(setvideo).l				;restore old video
	move.w	#$18,(palcount).w		;fade in
	rts								;exit replay mode
getpzjoy							;read the joystick of the pad that paused. pads 3 and 4 when FourWayPlay
									;(pausepad = 3 or 4)
	tst.w	(FourWayPlay).w			;four way?
	bne.w	.0						;yes
.loop								;loop
	btst	#sfpj,(sflags).w		;pad 2 paused?
	bne.w	ReadJoy2				;pad 2
	bra.w	ReadJoy1				;pad 1
.0									;FourWayPlay <> 0
	tst.w	(pausepad).w			;pad 1 or 2?
	beq.s	.loop					;yes
	cmpi.w	#3,(pausepad).w			;pad 3?
	beq.w	ReadJoy3				;pad 3
	bra.w	ReadJoy4				;pad 4
ShowReplayIcon						;Show the replay icon and start the $F0 frame replayicontimer timer
	move.w	#$F0,(replayicontimer).w	;$F0 frames
	bsr.w	printz					;map at the icon
	String	-(TXPRI+TXMAP3),2,2
	moveq	#$20,d0					;x $20
	moveq	#$55,d1					;y $55
	moveq	#8,d2					;width 8
	moveq	#4,d3					;height 4
	move.w	(rinkvrcset).w,d4		;rink chars
	move.w	#0,d5					;no palette lines
	movea.l	#Rinktilelist,a1		;rink tile list
	btst	#4,(sflags4).w			;check if reverse angle replay
	beq.w	.0						;branch if not
	movea.l	#RevRinkTilelist,a1		;reverse rink tile list
.0									;normal or reverse rink tiles chosen
	adda.l	jimdata(a1),a1			;map data
	movea.w	#null,a2				;no tiles
	bra.w	dobitmap				;draw it
EraseReplayIcon						;Erase the 8 x 4 replay icon (replayicontimer timer ran out)
	jsr	(printz).l					;map at the icon
	String	-(TXPRI+TXMAP3),2,2
	move.w	#8,d0					;8 wide
	move.w	#4,d1					;4 high
	move.w	#$7FF,d2				;blank char
	jmp	eraser						;erase it
ShowReplayBanner					;Show ReplayMap at 0,0 (16 x 11) and stop the replayicontimer timer
	st	(replayicontimer).w			;no icon timer
	bsr.w	printz					;map at the top left
	String	-(TXPRI+TXMAP3),2,0
	moveq	#0,d0					;x 0
	moveq	#0,d1					;y 0
	moveq	#$10,d2					;width $10
	moveq	#$B,d3					;height $B
	move.w	(ExtraChars).w,d4		;extra chars
	move.w	#0,d5					;no palette lines
	movea.l	#ReplayMap,a1			;replay map
	adda.l	jimdata(a1),a1			;map data
	movea.w	#null,a2				;no tiles
	bra.w	dobitmap				;draw it
EraseReplayBanner					;Erase the 16 x 11 area ShowReplayBanner drew
	jsr	(printz).l					;map at the top left
	String	-(TXPRI+TXMAP3),2,2
	move.w	#$10,d0					;16 wide
	move.w	#$B,d1					;11 high
	move.w	#$7FF,d2				;blank char
	jmp	eraser						;erase it
suba4								;a4 = current replay frame. Back up 1 frame and set video parameters for
									;display.
									;d7 = delay between frames, or zero at the end of the replay
	cmpa.l	#M68K_RAM,a4			;at the start of the buffer?
	bne.w	.1						;no
	btst	#sfwrap,(sflags).w		;wrapped?
	beq.w	.end					;no: the end
	movea.l	#replayend,a4			;end of the buffer
.1									;frame pointer ready (wrapped to the end of the buffer)
	suba.w	#replaysize,a4			;back a frame
	cmpa.l	(recbpr).w,a4			;at the oldest?
	bne.w	RestoreReplayFrame		;no: restore it
	adda.w	#replaysize,a4			;forward again
.end								;at an end of the replay
	bsr.w	RestoreReplayFrame		;at either end of the replay: show frame, d7 = 0
	clr.w	d7						;no more
	rts								;return
adda4								;Step forward 1 frame. First handles a reverse
									;angle switch (sflags4 bit 6)
	bclr	#6,(sflags4).w			;reverse angle change?
	beq.w	.1						;no
	movem.l	d0-d7/a0-a6,-(sp)		;save
	bchg	#4,(sflags4).w			;toggle reverse angle
	move.w	(Hpos).w,-(sp)			;save X
	move.w	(Vpos).w,-(sp)			;save Y
	bsr.w	forceblack2				;fade to black
	jsr	(vcountwait).l				;frame
	jsr	(vcountwait).l				;frame
	jsr	(ReloadRinkGraphics).l		;rink graphics
	clr.w	(Hpos).w				;X 0
	clr.w	(Vpos).w				;Y 0
	move.w	#$7D0,(Oldrow).w		;redraw all rows
	move.w	#1,d0					;2 frames
.loop								;2 frames to redraw
	jsr	(setvideo).l				;video update
	jsr	(vcountwait).l				;frame
	dbf	d0,.loop					;loop
	move.w	(sp)+,(Vpos).w			;restore Y
	move.w	(sp)+,(Hpos).w			;restore X
	move.w	#1,d0					;2 frames
	jsr	(setvideo).l				;video update
.loop2								;wait 2 more frames
	jsr	(vcountwait).l				;frame
	dbf	d0,.loop2					;loop
	movem.l	a0,-(sp)				;save
	movea.l	#SortCords+(12*SCstruct),a0	;object 12
	move.w	#1,oldframe(a0)			;redraw it
	adda.w	#$80,a0					;object 13
	move.w	#1,oldframe(a0)			;redraw it
	movem.l	(sp)+,a0				;restore
	bsr.w	RevReplayAdj			;reverse adjust
	btst	#sfscrl,(sflags).w		;scrolling?
	beq.w	*+4						;(next line)
.0									;(not branched to)
	jsr	(ShowReplayIcon).l			;show the icon
	move.w	#$64,(palcount).w		;copy now
	movem.l	(sp)+,d0-d7/a0-a6		;restore
.1									;end of the reload
	clr.w	d7						;clear
	btst	#sf2drec,(sflags2).w	;recording?
	beq.w	adda42					;no
	movem.l	a4,-(sp)				;save
	bsr.w	adda43					;look ahead
	cmpa.l	(recbpr).w,a4			;at the newest?
	movem.l	(sp)+,a4				;restore
	beq.w	rtss8					;yes: done
adda42								;adda4 without the sf2drec look-ahead: stop at the record point, else show
									;the frame and fall into adda43
	cmpa.l	(recbpr).w,a4			;at the newest?
	beq.w	rtss8					;yes: done
	bsr.w	RestoreReplayFrame		;restore it
adda43								;a4 += replay frame size ($62), wrapping from replayend to M68K_RAM
	adda.w	#replaysize,a4			;next frame
	cmpa.l	#replayend,a4			;past the end?
	bne.w	rtss8					;no
	movea.l	#M68K_RAM,a4			;wrap to the start
	rts								;return
UpdateCameraPos						;Camera struct a5 = object a3 x/y (negated for the reverse angle),
									;Hpos/Vpos clamped
	movem.l	d0-d2,-(sp)				;save
	move.w	(a3),d0					;object X
	btst	#7,(sflags4).w			;reverse angle?
	beq.w	.0						;no
	neg.w	d0						;mirror
.0									;X mirrored for reverse angle
	move.w	d0,(a5)					;camera X
	move.w	Ypos(a3),d1				;object Y
	btst	#7,(sflags4).w			;reverse angle?
	beq.w	.2						;no
	neg.w	d1						;mirror
.2									;Y mirrored for reverse angle
	move.w	d1,Ypos(a5)				;camera Y
	cmp.w	#$3C,d0					;past $3C?
	blt.w	.4						;no
	move.w	#$3C,d0					;$3C
.4									;X not past the right limit
	cmp.w	#$FFC4,d0				;past -$3C?
	bgt.w	.1						;no
	move.w	#$FFC4,d0				;-$3C
.1									;X inside the limits
	move.w	d0,(Hpos).w				;view X
	cmp.w	#$100,d1				;past $100?
	blt.w	.5						;no
	move.w	#$100,d1				;$100
.5									;Y not past the top limit
	cmp.w	#$FF38,d1				;past -$C8?
	bgt.w	.3						;no
	move.w	#$FF38,d1				;-$C8
.3									;Y inside the limits
	move.w	d1,(Vpos).w				;set Vpos
	movem.l	(sp)+,d0-d2				;restore
	rts								;return
; set flag for reverse replay setup if needed
RevReplayAdj						;Set sflags4 bit 7 for a reverse angle replay, then fall into
									;RestoreReplayFrame
	btst	#4,(sflags4).w			;check if reverse angle replay
	beq.w	RestoreReplayFrame		;branch if not
	bset	#7,(sflags4).w			;set bit 7
; a4 = current replay frame address to convert into normal coordinates
RestoreReplayFrame					;a4 = current replay frame address to convert into normal cordinates, then
									;the other replay variables. Flips x/y and frames for the reverse angle
	movem.l	d0-d2/a0/a6,-(sp)		;save
	movea.l	#revframetbl,a6			;reverse frame table
	movea.l	a4,a0					;frame data
	moveq	#$F,d1					;16 objects to convert (12 players/2 nets/puck/puck shadow)
	movea.w	#(SortCords-M68K_RAM),a3	;objects
.top								;each of the 16 objects
	move.w	2(a0),d2				;loop over the 16 objects: x from word 1
	andi.w	#$3FF,d2				;10 bits
	btst	#9,d2					;negative?
	beq.w	.chkrevx				;no
	ori.w	#$FC00,d2				;sign extend
.chkrevx							;X sign extended
	btst	#4,(sflags4).w			;check if reverse angle
	beq.w	.p						;branch if not
	neg.w	d2						;mirror
.p									;X mirrored for reverse angle
	move.w	d2,(a3)					;update Xpos
	move.l	(a0),d2					;frame long
	asr.l	#4,d2					;down 4
	asr.w	#6,d2					;down 6 more
	btst	#9,d2					;negative?
	beq.w	.chkrevy				;no
	ori.w	#$FC00,d2				;sign extend
.chkrevy							;Y sign extended
	btst	#4,(sflags4).w			;check if reverse angle
	beq.w	.p1						;branch if not
	neg.w	d2						;mirror
	cmp.w	#0,d1					;check if last object (puck shadow)
	bne.w	.p1						;branch if not
	addq.w	#2,d2					;update puck shadow Xpos
.p1									;Y mirrored (puck shadow shifted) for reverse angle
	move.w	d2,Ypos(a3)				;update Ypos
	move.w	(a0),d2					;frame word
	asr.w	#4,d2					;down 4
	andi.w	#$3FF,d2				;10 bits
	btst	#4,(sflags4).w			;check if reverse angle
	beq.w	.2						;branch if not
	asl.w	#1,d2					;word index
	move.w	0(a6,d2.w),d2			;look up table to adjust d2
	cmpi.w	#$F,SCnum(a3)			;check if puck shadow
	bne.w	.0						;branch if not
	cmp.w	#SPFpuck,d2				;puck?
	beq.w	.0						;yes
	move.w	#$FC00,Ypos(a3)			;update Ypos of puck shadow
.0									;puck shadow handled
	cmp.w	#1,d2					;check if frame is before frame 1 (out of range)
	blt.w	.1						;branch if so
	cmp.w	#$34E,d2				;check if frame is >= 846 (last frame +1)
	bge.w	.1						;branch if so
	bra.w	.2						;branch if valid object frame
.1									;d2 < 1 or d2 >= $34E
	move.w	(a0),d2					;frame word
	asr.w	#4,d2					;down 4
	andi.w	#$3FF,d2				;10 bits
.2									;frame number ready
	move.w	d2,frame(a3)			;store it
	cmp.w	#SPFbglass,d2			;check if frame is before glass shatter frames
	blt.w	.3						;branch if so
	cmp.w	#SPFbglass+5,d2			;check if frame is after glass shatter frames
	bge.w	.3						;branch if so
	btst	#4,(sflags4).w			;reverse angle?
	beq.w	.3						;no
	move.w	#$190,Ypos(a3)			;glass Y
.3									;glass shatter moved for reverse angle
	move.w	(a0),d2					;frame word
	asr.w	#3,d2					;down 3
	andi.w	#$1800,d2				;flip bits
	andi.w	#$E7FF,attribute(a3)	;flip bits
	or.w	d2,attribute(a3)		;set them
	btst	#4,(sflags4).w			;check if reverse angle replay
	beq.w	.4						;branch if not
	move.w	frame(a3),d2			;move frame into d2
	cmp.w	#SPFfight,d2			;check if frame is before old fight frames
	blt.w	.4						;branch if so
	cmp.w	#SPFPen,d2				;check if frame is after old fight frames
	bge.w	.4						;branch if so
	bchg	#3,attribute(a3)		;change X flip attribute for object
.4									;fight frames flipped
	addq.w	#4,a0					;next object data
	adda.w	#SCstruct,a3			;next object
	dbf	d1,.top						;loop to next object
	moveq	#5,d2					;6 pairs of players
	movea.w	#(SortCords-M68K_RAM),a3	;objects
.loop								;each pair of players
	move.b	(a0)+,rostnum(a3)		;loop over the 6 pairs of players
	move.b	(a0),d0					;position byte
	andi.w	#$F,d0					;low nibble
	cmp.w	#$F,d0					;$F?
	bne.w	.5						;no
	moveq	#-1,d0					;-1
.5									;$F = no position (-1)
	move.w	d0,position(a3)			;position of the first player of the pair
	adda.w	#SCstruct,a3			;next object
	move.b	(a0)+,d0				;roster byte
	lsr.b	#4,d0					;high nibble
	move.b	d0,rostnum(a3)			;store it
	move.b	(a0),d0					;next byte
	asl.b	#4,d0					;low nibble up
	or.b	d0,rostnum(a3)			;merge it
	move.b	(a0)+,d0				;position byte
	lsr.b	#4,d0					;high nibble
	andi.w	#$F,d0					;4 bits
	cmp.w	#$F,d0					;$F?
	bne.w	.6						;no
	moveq	#-1,d0					;-1
.6									;$F = no position (-1)
	move.w	d0,position(a3)			;store it
	adda.w	#SCstruct,a3			;next object
	dbf	d2,.loop					;loop
	move.b	(a0)+,d0				;byte
	ext.w	d0						;word
	move.w	d0,(puckz).w			;puck z cord
	move.b	(a0)+,d0				;byte
	ext.w	d0						;word
	move.w	d0,(SortCords+((puckscnum+1)*SCstruct)+Zpos).w	;puck shadow Z
	move.b	(a0)+,d0				;byte
	ext.w	d0						;word
	move.w	d0,(lastsfx).w			;sound effect cue
	clr.w	d7						;clear
	move.b	(a0)+,d7				;frame delay
	move.w	(a0)+,d0				;pad bits
	andi.w	#$FFF,d0				;low 12 bits
	andi.w	#$F000,(PadControlBits).w	;keep the top
	or.w	d0,(PadControlBits).w	;merge them
	move.w	(a0)+,(Crowdframe).w	;crowd frame
	move.w	(a0)+,(glovecords).w	;glove
	move.b	(a0)+,(PBnum).w			;penalty box count
	clr.w	d0						;clear
	move.b	(a0)+,d0				;byte
	lsl.w	#4,d0					;up 4
	ori.w	#$F00F,d0				;other bits set
	move.w	d0,(PadControlBits34).w	;store it
	btst	#sfscrl,(sflags).w		;scrolling?
	beq.w	.pos					;no
	movea.w	a5,a3					;camera struct
	btst	#sf3track,(sflags3).w	;tracking an object?
	beq.w	.cam					;tracking?
	clr.w	camidle(a5)				;camera moving
	move.w	camtrack(a5),d0			;tracked object
	asl.w	#7,d0					;* SCstruct
	movea.w	#(SortCords-M68K_RAM),a3	;objects
	adda.w	d0,a3					;this object
.cam								;camera follows a3
	bsr.w	UpdateCameraPos			;camera position
	bra.w	.7						;done
.pos								;sfscrl clear
	move.w	(a0)+,(Hpos).w			;view X
	move.w	(a0)+,(Vpos).w			;view Y
	btst	#4,(sflags4).w			;reverse angle?
	beq.w	.7						;no
	neg.w	(Hpos).w				;mirror X
	neg.w	(Vpos).w				;mirror Y
	jsr	(ClampReplayView).l			;clamp the view
.7									;view clamped
	bclr	#7,(sflags4).w			;clear the reverse flag
	movem.l	(sp)+,d0-d2/a0/a6		;restore
	rts								;return
ClampReplayView						;Clamp Hpos to -$3C..$3C and Vpos to -$C8..$100
	move.w	d0,-(sp)				;save
	move.w	#$3C,d0					;$3C
	cmp.w	(Hpos).w,d0				;Hpos past it?
	blt.w	.0						;yes
	move.w	#$FFC4,d0				;-$3C
	cmp.w	(Hpos).w,d0				;Hpos inside?
	ble.w	.1						;yes
.0									;Hpos past the limit: clamp
	move.w	d0,(Hpos).w				;clamp
.1									;Hpos inside the limits
	move.w	#$100,d0				;$100
	cmp.w	(Vpos).w,d0				;Vpos past it?
	blt.w	.2						;yes
	move.w	#$FF38,d0				;-$C8
	cmp.w	(Vpos).w,d0				;Vpos inside?
	ble.w	.3						;yes
.2									;Vpos past the limit: clamp
	move.w	d0,(Vpos).w				;clamp
.3									;Vpos inside the limits
	move.w	(sp)+,d0				;restore
	rts								;return
; called every frame to save replay events
; d7 = elapsed frames
updatereplay						;called every frame to save replay events, d7 = elapsed frames
	btst	#gmhl,(gmode).w			;check if highlight
	bne.w	rtss8					;exit if so
	btst	#sf2drec,(sflags2).w	;check if replay record disabled
	beq.w	.0						;branch if not
	tst.w	(replaydelay).w			;delay?
	beq.w	.rec					;no
	subq.w	#1,(replaydelay).w		;count down
	bpl.w	.0						;still delaying
	clr.w	(replaydelay).w			;0
	bra.w	.rec					;record
.0									;sf2drec clear or replaydelay >= 0
	addi.l	#replaysize,(recbpr).w	;next slot
	cmpi.l	#replayend,(recbpr).w	;replayend
	bne.w	.rec					;not at the end
	bset	#sfwrap,(sflags).w		;wrapped
	move.l	#M68K_RAM,(recbpr).w	;back to the start
.rec								;record into the next slot
	movea.l	(recbpr).w,a0			;a0 = the record slot
	moveq	#$F,d2					;16 objects
	movea.w	#(SortCords-M68K_RAM),a3	;objects
.top								;pack each of the 16 objects
	clr.l	(a0)					;loop over the 16 objects: pack x, y, frame, flip bits
	move.w	(a3),d1					;Xpos
	andi.w	#$3FF,d1				;10 bits
	move.w	d1,2(a0)				;store X
	clr.l	d1						;clear
	move.w	Ypos(a3),d1				;Ypos
	asl.w	#6,d1					;up 6
	asl.l	#4,d1					;up 4 more
	or.l	d1,(a0)					;merge Y
	move.w	frame(a3),d1			;frame
	asl.w	#4,d1					;up 4
	or.w	d1,(a0)					;merge it
	move.w	attribute(a3),d1		;attribute
	andi.w	#$1800,d1				;flip bits
	asl.w	#3,d1					;up 3
	or.w	d1,(a0)					;merge them
	addq.w	#4,a0					;next slot
	adda.w	#SCstruct,a3			;next object
	dbf	d2,.top						;loop
	moveq	#5,d2					;6 pairs of players
	movea.w	#(SortCords-M68K_RAM),a3	;objects
.loop								;each pair of players
	move.b	rostnum(a3),(a0)+		;loop over the 6 pairs of players
	move.w	position(a3),d0			;position
	bpl.w	.n0						;on the ice
	moveq	#$F,d0					;not on ice
.n0									;off the ice: $F
	andi.w	#$F,d0					;position nibble
	move.b	d0,(a0)					;store it
	adda.w	#SCstruct,a3			;next object
	move.b	rostnum(a3),d0			;roster number
	asl.w	#4,d0					;up 4
	or.b	d0,(a0)+				;merge it
	move.b	rostnum(a3),d0			;roster number
	lsr.b	#4,d0					;high nibble
	move.b	d0,(a0)					;store it
	move.w	position(a3),d0			;position
	bpl.w	.n1						;on the ice
	moveq	#$F,d0					;not on ice
.n1									;position nibble ready
	asl.w	#4,d0					;position to the high nibble
	or.b	d0,(a0)+				;merge it
	adda.w	#SCstruct,a3			;next object
	dbf	d2,.loop					;loop
	move.b	(puckz+1).w,(a0)+		;puck Z
	move.b	(SortCords+((puckscnum+1)*SCstruct)+Zpos+1).w,(a0)+	;puck shadow Z
	move.b	(lastsfx+1).w,(a0)+		;sound effect cue
	bset	#7,(lastsfx+1).w		;cue saved
	move.b	d7,(a0)+				;save elapsed frames
	move.w	(PadControlBits).w,(a0)+	;pad bits
	move.w	(Crowdframe).w,(a0)+	;crowd frame
	move.w	(glovecords).w,(a0)+	;glove
	move.b	(PBnum).w,(a0)+			;penalty box count
	move.w	d0,-(sp)				;save
	move.w	(PadControlBits34).w,d0	;pads 3 and 4 bits
	lsr.w	#4,d0					;down 4
	move.b	d0,(a0)+				;store it
	move.w	(sp)+,d0				;restore
	move.w	(Hpos).w,(a0)+			;view X
	move.w	(Vpos).w,(a0)+			;view Y
rtss8								;shared rts for the early exits nearby
	rts								;return
; this routine calls all collision/animation/assignment code for all players
; d7 = elapse frames since last call
updateplayers						;this routine calls all collision/animation/assignment code for all
									;players. d7 = elapsed frames
	btst	#sfhor,(sflags).w		;check if screen is in horiz mode
	bne.w	.checkcrowd				;jump if horiz mode
	ori.w	#$F,(PadControlBits).w	;pads off
	cmpi.w	#5,(puckz).w			;check puckz with 5
	bgt.w	.gt						;branch if greater
.clrcnt								;loop
	clr.w	(PuckZCntr).w			;clear counter
	bra.w	.checkcrowd				;next
.gt									;puckz > 5
	move.w	(TmpPuckZ).w,d0			;last puck Z
	cmp.w	(puckz).w,d0			;same?
	beq.w	.pzeq					;branch if puckz equal to TmpPuckZ
	move.w	(puckz).w,(TmpPuckZ).w	;new puck Z
	bra.s	.clrcnt					;loop
.pzeq								;d0 = puckz
	addq.w	#1,(PuckZCntr).w		;add 1 to counter
	cmpi.w	#$10,(PuckZCntr).w		;compare counter to 10 (16 decmial)
	blt.w	.checkcrowd				;branch if less than
	clr.w	(PuckZCntr).w			;clear counter
	subq.w	#1,(puckz).w			;subtract 1 from puckz
.checkcrowd							;puck height done
	bclr	#6,(sflags7).w			;Bit 6 = Crowd Meter bit
	move.w	(CurCrowdMeter).w,d0	;Move cur crowd meter to d0
	cmp.w	(CrowdRecord).w,d0		;compare with crowd record
	blt.w	.nobreak				;branch if less than
	bset	#6,(sflags7).w			;set Crowd Meter bit
.nobreak							;crowd record flag set when the meter passes it
	jsr	(SetSflags8Bit1).l			;turn on bit 1 of sflags8
	tst.w	(puckc).w
	bmi.w	.scload					;branch if no puck carrier
	bclr	#7,(sflags8).w
	bclr	#1,(sflags6).w
	move.w	(puckc).w,d0			;move puckc SCnum into d0
	asl.w	#7,d0
	movea.l	#SortCords,a3			;start of player SCstructs
	adda.w	d0,a3					;add offset to a3
	btst	#pf3break,pflags3(a3)	;checks if there is a breakaway
	beq.w	.scload					;branch if no breakaway
	bclr	#4,(gmode2).w			;clear if breakaway
.scload								;breakaway flag handled
	movea.w	#(SortCords-M68K_RAM),a3	;objects
.top								;loop
	move.l	(a3),OldXpos(a3)		;Xpos, oldXpos
	move.l	Ypos(a3),OldYpos(a3)	;Ypos, oldYpos
	move.l	Zpos(a3),OldZpos(a3)	;Zpos, oldZpos
	btst	#pf3fall,pflags3(a3)	;falling down?
	beq.w	.top2					;branch if not
	clr.w	Xvel(a3)				;clear Xvel
	clr.w	Yvel(a3)				;clear Yvel
	tst.w	SPAnum(a3)				;check animation index
	bne.w	.0						;branch if index not 0
	jsr	(PlaceBoardFall).l			;place him on the boards
	bra.w	.top2					;next
.0									;falling in mid animation
	cmpi.w	#SPAbenchcheckl,SPA(a3)	;check animation
	beq.w	.10						;yes
	cmpi.w	#SPAbenchcheckr,SPA(a3)	;right bench check?
	beq.w	.8						;yes
	cmpi.w	#SPAboardleft,SPA(a3)	;left boards?
	beq.w	.9						;yes
	cmpi.w	#SPAboardright,SPA(a3)	;right boards?
	beq.w	.7						;yes
	cmpi.w	#SPAboardfront,SPA(a3)	;front boards?
	beq.w	.1						;yes
	cmpi.w	#SPAboardback,SPA(a3)	;back boards?
	beq.w	.4						;yes
	bra.w	.top2					;next
.1									;front boards: the wall Y
	move.w	#$124,d0				;wall Y
	cmpi.w	#$56,(FallXPos).w		;right corner?
	bgt.w	.2						;yes
	cmpi.w	#$FFAA,(FallXPos).w		;middle?
	bgt.w	.3						;yes
.2									;near a corner: the closer wall
	move.w	#$116,d0				;closer wall
.3									;set Y on the wall
	move.w	d0,Ypos(a3)				;set Y
	bra.w	.top2					;next
.4									;back boards
	move.w	#$FEDC,d0				;wall Y
	cmpi.w	#$56,(FallXPos).w		;right corner?
	bgt.w	.5						;yes
	cmpi.w	#$FFAA,(FallXPos).w		;middle?
	bgt.w	.6						;yes
.5									;near a corner: the closer wall
	move.w	#$FEEA,d0				;closer wall
.6									;set Y on the wall
	move.w	d0,Ypos(a3)				;set Y
	bra.w	.top2					;next
.7									;right boards
	move.w	#$82,(a3)				;wall X
	btst	#3,attribute(a3)		;flipped?
	beq.w	.top2					;no
	move.w	#$FF7E,(a3)				;other side
	bra.w	.top2					;next
.8									;right bench boards
	move.w	#$88,(a3)				;wall X
	btst	#3,attribute(a3)		;flipped?
	beq.w	.top2					;no
	move.w	#$FF78,(a3)				;other side
	bra.w	.top2					;next
.9									;left boards
	move.w	#$FF7E,(a3)				;wall X
	btst	#3,attribute(a3)		;flipped?
	beq.w	.top2					;no
	move.w	#$82,(a3)				;other side
	bra.w	.top2					;next
.10									;left bench boards
	move.w	#$FF78,(a3)				;wall X
	btst	#3,attribute(a3)		;flipped?
	beq.w	.top2					;no
	move.w	#$88,(a3)				;other side
.top2								;each player on the ice
	tst.w	position(a3)			;check if on ice
	bmi.w	.nf1					;branch if not on ice
	move.w	SCnum(a3),d0			;SCnum
	cmp.w	(puckc).w,d0			;check if player has puck
	beq.w	.top3					;branch if puck carrier
	bclr	#pf3break,pflags3(a3)	;clear breakaway bit
	bclr	#pf3oside,pflags3(a3)	;clear offsides bit
.top3								;puck carrier keeps his flags
	bsr.w	updateanim				;animation
	sub.b	d7,nopuck(a3)			;no puck control
	bpl.w	.np						;not below 0
	clr.b	nopuck(a3)				;clear upper byte of nopuck
.np									;upper byte done
	sub.b	d7,nopuck+1(a3)			;subtract # of frames from nopuck+1
	bpl.w	.np2					;not below 0
	clr.b	nopuck+1(a3)			;clear lower byte of nopuck
.np2								;lower byte done
	btst	#sf3icetime,(sflags3).w	;check if penalty timer is up
	beq.w	.11						;no
	clr.w	d0						;clear
	move.b	pnum(a3),d0				;player offset on roster
	bmi.w	.11						;not on ice
	add.w	d0,d0					;word index
	addi.w	#$136,d0				;ice time table
	jsr	(loadTeamStruct).l			;a2 = team struct
	addq.w	#1,0(a2,d0.w)			;add 1 to TOI for player
.11									;ice time counted
	cmpi.w	#SPAinjuryfall,SPA(a3)	;check animation
	beq.w	.done					;yes
	cmpi.w	#SPAinjury1,SPA(a3)		;check animation
	beq.w	.done					;yes
	moveq	#$11,d4					;NTSC speed
	tst.w	(PalMode).w				;PAL?
	beq.w	.notoside				;no
	moveq	#$16,d4					;PAL speed
.notoside							;speed scale for NTSC or PAL
	mulu.w	d7,d4					;update velocity
	tst.w	Zpos(a3)				;Zpos
	bne.w	.y2						;no deceleration
	moveq	#6,d2					;normal deceleration
	btst	#pfdoff,pflags(a3)		;pfdoff - player deceleration
	beq.w	.off					;no
	moveq	#9,d2					;this value used when player receiving pass. Also the puck will use this
									;when "normal"
.off								;deceleration shift chosen
	move.w	Xvel(a3),d0				;Xvel
	beq.w	.x2						;no speed
	asr.w	d2,d0					;shift d0 right d2 times
	bne.w	.x1						;branch if d0 not zero
	moveq	#1,d0					;make d0 1 if it was 0
.x1									;at least 1
	sub.w	d0,Xvel(a3)				;Xvel
.x2									;Xvel slowed
	move.w	Yvel(a3),d0				;Yvel
	beq.w	.y2						;branch if d0 is 0
	asr.w	d2,d0					;shift d0 to the right d2 times
	bne.w	.y1						;branch if d0 not 0
	moveq	#1,d0					;make d0 1 if it was 0
.y1									;at least 1
	sub.w	d0,Yvel(a3)				;sub d0 from Yvel
.y2									;Yvel slowed
	move.w	Xvel(a3),d0				;Xvel
	beq.w	.x3						;branch if d0 is 0
	muls.w	d4,d0					;mult d0 by d4
	add.l	d0,(a3)					;add to Xpos
.x3									;X moved
	move.w	Yvel(a3),d0				;Yvel
	beq.w	.y3						;branch if d0 is 0
	muls.w	d4,d0					;mult d0 by d4
	add.l	d0,Ypos(a3)				;add to Ypos
.y3									;Y moved
	tst.w	Zpos(a3)				;check Zpos
	bmi.w	.done					;branch if negative
	bne.w	.z1						;branch if not 0
	tst.w	Zvel(a3)				;check Zvel
	beq.w	.done					;branch if 0
.z1									;in the air: gravity
	asl.w	#1,d4					;mult d4 by 2
	sub.w	d4,Zvel(a3)				;sub d4 from Zvel
	asl.w	#1,d4					;mult d4 by 2
	sub.w	d4,Zvel(a3)				;sub d4 from Zvel
	lsr.w	#2,d4					;divide d4 by 4
	move.w	Zvel(a3),d0				;move Zvel into d0
	muls.w	d4,d0					;mult d0 by d4
	add.l	d0,Zpos(a3)				;add d0 to Zpos
	bpl.w	.done					;branch if d0+Zpos is positive
	clr.l	Zpos(a3)				;clear Zpos
	neg.w	Zvel(a3)				;negate Zvel
	asr.w	Zvel(a3)				;divide Zvel by 2
	moveq	#5,d0					;move 5 into d0
	sub.b	Zvel(a3),d0				;sub Zvel from d0
	bpl.w	.chkpuck				;branch if result is positive
	clr.w	d0						;clear d0
.chkpuck							;bounce sound strength
	cmp.w	#3,d0					;compare d0 to 3
	bhi.w	.done					;branch if higher than 3
	addi.w	#SFXpuckice,d0			;#SFXpuckice
	move.w	d0,-(sp)				;sound
	bsr.w	sfx						;play it
.done								;movement done
	move.w	SCnum(a3),d6			;SCnum
	cmp.w	(puckc).w,d6			;check if puck carrier
	bne.w	.tp						;not puck carrier
	btst	#pf2fight,pflags2(a3)	;pf2fight - check if fighting
	bne.w	.tp						;no
	btst	#sfhor,(sflags).w		;#sfhor - check if in horiz mode
	bne.w	.tp						;yes
	moveq	#-2,d4					;-2 - pad index for puck carrier
	bsr.w	setpads					;set the pads
.tp									;pads checked
	btst	#sf2faceoff,(sflags2).w	;sf2faceoff- check for faceoff
	bne.w	.tp2					;branch if faceoff
	tst.w	(holdreset).w			;reset hold?
	beq.w	.tp2					;no
	subq.w	#1,(holdreset).w		;count down
	beq.w	.12						;ran out
	bpl.w	.tp2					;not yet
.12									;hold timer ran out: reset the hold timers
	clr.w	(holdreset).w			;0
	move.w	#$1111,(bholdtimer).w	;reset the B hold timers
	move.w	#$1111,(bholdtimer34).w
.tp2								;check each pad's player
	cmp.w	(c1playernum).w,d6		;check if cont 1 is puck carrier
	bne.w	.t0						;no
	bsr.w	ReadJoy1				;read pad 1
	clr.w	d4						;pad index for cont 1 player
	move.w	#$FFFF,(joypuckcarrier).w	;home pad
	bsr.w	doinput					;B button
	bra.w	.t1						;next
.t0									;d6 <> c1playernum
	cmp.w	(c2playernum).w,d6		;check if cont 2 is puck carrier
	bne.w	.t1						;no
	bsr.w	ReadJoy2				;read pad 2
	moveq	#2,d4					;pad index for cont 2 player
	move.w	#$FFFF,(joypuckcarrier).w
	bsr.w	doinput					;B button
.t1									;pad 2 done
	cmp.w	#$B,d6					;check if SCnum 0-11 were puck carrier (players)
	bgt.w	.t1cont					;jump if not
	tst.w	(cont3team).w			;check if there is 3 controllers?
	beq.w	.13						;no
	cmp.w	(c3playernum).w,d6		;pad 3's player?
	bne.w	.13						;no
	jsr	(ReadJoy3).l				;read pad 3
	clr.l	d4						;pad index 0
	clr.w	(joypuckcarrier).w
	move.w	(cont1team).w,-(sp)		;swap pad 3 into pad 1
	move.w	(cont3team).w,(cont1team).w
	move.w	(c1playernum).w,-(sp)
	move.w	(c3playernum).w,(c1playernum).w
	move.w	(bholdtimer).w,-(sp)
	move.w	(bholdtimer34).w,(bholdtimer).w
	move.w	(padword1).w,-(sp)
	move.w	(padword3).w,(padword1).w
	move.w	(aholdtimer).w,-(sp)
	move.w	(aholdtimer34).w,(aholdtimer).w
	move.w	(PadControlBits).w,-(sp)
	move.w	(PadControlBits34).w,(PadControlBits).w
	bsr.w	doinput					;B button
	move.w	(PadControlBits).w,(PadControlBits34).w	;swap back
	move.w	(sp)+,(PadControlBits).w
	move.w	(aholdtimer).w,(aholdtimer34).w
	move.w	(sp)+,(aholdtimer).w
	move.w	(padword1).w,(padword3).w
	move.w	(sp)+,(padword1).w
	move.w	(bholdtimer).w,(bholdtimer34).w
	move.w	(sp)+,(bholdtimer).w
	move.w	(c1playernum).w,(c3playernum).w
	move.w	(sp)+,(c1playernum).w
	move.w	(cont1team).w,(cont3team).w
	move.w	(sp)+,(cont1team).w
.13									;pad 3 swap done
	tst.w	(cont4team).w			;check if there is 4 controllers?
	beq.w	.t1cont					;no
	cmp.w	(c4playernum).w,d6		;pad 4's player?
	bne.w	.t1cont					;no
	jsr	(ReadJoy4).l				;read pad 4
	moveq	#2,d4					;pad index 2
	move.w	#1,(joypuckcarrier).w
	move.w	(cont2team).w,-(sp)		;swap pad 4 into pad 2
	move.w	(cont4team).w,(cont2team).w
	move.w	(c2playernum).w,-(sp)
	move.w	(c4playernum).w,(c2playernum).w
	move.w	(bholdtimer).w,-(sp)
	move.w	(bholdtimer34).w,(bholdtimer).w
	move.w	(padword2).w,-(sp)
	move.w	(padword4).w,(padword2).w
	move.w	(aholdtimer).w,-(sp)
	move.w	(aholdtimer34).w,(aholdtimer).w
	move.w	(PadControlBits).w,-(sp)
	move.w	(PadControlBits34).w,(PadControlBits).w
	bsr.w	doinput					;B button
	move.w	(PadControlBits).w,(PadControlBits34).w	;swap back
	move.w	(sp)+,(PadControlBits).w
	move.w	(aholdtimer).w,(aholdtimer34).w
	move.w	(sp)+,(aholdtimer).w
	move.w	(padword2).w,(padword4).w
	move.w	(sp)+,(padword2).w
	move.w	(bholdtimer).w,(bholdtimer34).w
	move.w	(sp)+,(bholdtimer).w
	move.w	(c2playernum).w,(c4playernum).w
	move.w	(sp)+,(c2playernum).w
	move.w	(cont2team).w,(cont4team).w
	move.w	(sp)+,(cont2team).w
.t1cont								;pads done
	move.w	assnum(a3),d0			;assnum
	clr.w	d1						;clear
	move.b	asslist(a3,d0.w),d1		;asslist of SCstruct
	asl.w	#2,d1					;mult by 4
	movea.l	#asstab,a0				;assignment table
	movea.l	0(a0,d1.w),a0			;get address of assignment to use for jmp
	jsr	(loadTeamStruct).l			;a2 = team struct
	jsr	(a0)						;call assignment for this player
	clr.w	Wallcos(a3)				;clear wallcos
	clr.w	Wallsin(a3)				;clear wallsin
	move.w	(a3),d2					;Xpos
	move.w	Ypos(a3),d3				;Ypos
	cmp.w	OldXpos(a3),d2			;compare to oldXpos
	bne.w	.cc						;branch if not equal
	cmp.w	OldYpos(a3),d3			;compare to oldYpos
	beq.w	.nf						;branch if equal
.cc									;moved: check for collisions
	jsr	(checkcoll).l				;check for collisions
.nf									;collisions done or not moved
	move.w	d7,d0					;move d7 into d0 (elapsed frames)
	asl.w	#1,d0					;mult by 2
	sub.w	d0,impact(a3)			;reduce impact at a constant rate
	bpl.w	.nf1					;branch if positive
	clr.w	impact(a3)				;clear impact if negative or zero
.nf1								;impact ready
	move.w	impact(a3),limpact(a3)	;move impact into limpact
	adda.w	#SCstruct,a3			;SCstruct size
	cmpi.w	#$F,SCnum-SCstruct(a3)	;compare Sortobjs-1 to SCnum-SCstruct
	blt.w	.top					;loop for all Sort objects
	rts								;return
; frame switch control on struct a3
updateanim							;frame switch control on struct a3
	tst.w	SPA(a3)					;test SPA
	bne.w	.ia						;branch if not 0
	bclr	#pfalock,pflags(a3)		;clear anim lock
	bclr	#pf2aip,pflags2(a3)		;clear anim in progress
	rts								;return
.ia									;an animation is set
	movea.l	#SPAlist,a0				;animation data tables
	adda.w	SPA(a3),a0				;add SPA to a0 address
	move.w	SPAattr(a0),d1			;16 dec - attributes for anim
	move.w	facedir(a3),d0			;facedir into d0
	btst	#sfhor,(sflags).w		;check if horizontal mode
	beq.w	.nhor					;branch if not
	cmpi.w	#$C,SCnum(a3)			;compare to 12 (check if a player, not the puck or nets)
	bge.w	.nhor					;branch if greater than (puck or nets)
	subq.w	#2,d0					;direction adjust for horizontal rink
	andi.w	#7,d0					;0-7
.nhor								;direction ready
	btst	#3,attribute(a3)		;x flip flag
	beq.w	.nox					;branch if no flip
	neg.w	d0						;negate d0
	addq.w	#8,d0					;add 8 to d0 for flipping
	andi.w	#7,d0					;pass first 3 bits
.nox								;flip handled
	asl.w	#1,d0					;mult by 2
	adda.w	0(a0,d0.w),a0			;add a0 + d0 offset to a0 - This moves the SPF value into a0
	move.w	SPAnum(a3),d0			;SPANum into d0 (index into animation)
	move.w	0(a0,d0.w),d2			;a0 + d0 offset into d2 - this is the new SPF frame of this animation
	tst.w	SPAcnt(a3)				;check if SPAcnt is 0 (time for a new frame)
	bmi.w	.1						;branch if so (SPAcnt is negative)
	sub.w	d7,SPAcnt(a3)			;sub frames elasped from SPAcnt
	bpl.w	.cframe					;branch if SPAcnt is positive
	addq.w	#4,SPAnum(a3)			;add 4 to SPAnum (set for next index)
	addq.w	#4,d0					;add 4 to d0 (currently holds current index)
	tst.w	-2(a0,d0.w)				;test -2 offset from a0 + d0 (this is the frame
									;time for the previous frame)
	bpl.w	.1						;branch if positive (not the end of the animation)
	clr.w	d0						;clear d0
	clr.w	SPAnum(a3)				;clear SPANum
	bclr	#pfalock,pflags(a3)		;clear animation lock
	bclr	#pf2aip,pflags2(a3)		;clear animation in progress
	bclr	#pf3fall,pflags3(a3)	;clear fall down flag
	btst	#0,d1					;check if anim attribute loops
	bne.w	.1						;loop
	clr.w	SPA(a3)					;clear SPA
.1									;looping animation keeps SPA
	move.w	2(a0,d0.w),d0			;move frame time for animation frame into d0
	bpl.w	.0						;branch if positive
	neg.w	d0						;make d0 negative (this is the case if final frame)
.0									;frame time ready
	move.w	d0,SPAcnt(a3)			;move d0 into SPAcnt
.cframe								;count down to the next frame
	sub.b	d7,glitch(a3)			;sub frames elapsed from glitch - limit minimum
									;time between frame switches
	bpl.w	.rtss					;branch if glitch is positive still
	clr.b	glitch(a3)				;clear glitch
	cmp.w	frame(a3),d2			;compare frame to d2
	beq.w	.rtss					;branch if equal
	move.w	d2,frame(a3)			;move d2 into frame
	move.b	#4,glitch(a3)			;move 4 into glitch - /60 sec min frame switch time
.rtss								;exit (also the end of the code above)
	rts								;return
freezewindow						;lock scrolling to the current position
	move.w	(Vpos).w,(yc1).w		;lock Y
	move.w	(Hpos).w,(xc1).w		;lock X
	bset	#sfslock,(sflags).w		;scroll locked
	rts								;return
checkwindow							;set Hpos and Vpos according to how the screen should follow the puck
	move.w	(yc1).w,d2				;locked Y
	move.w	(xc1).w,d3				;if locked, use these cordinates
	btst	#sfslock,(sflags).w		;locked?
	bne.w	.dd						;yes
	movea.w	#(puckx-M68K_RAM),a3	;follow the puck
	move.w	(puckc).w,d0			;puck carrier
	bmi.w	.0						;none
	asl.w	#7,d0					;* SCstruct
	movea.w	#(SortCords-M68K_RAM),a3	;objects
	adda.w	d0,a3					;the carrier
	move.w	d7,d0					;frames
	add.w	d0,d0					;times 2
	btst	#pfgoal,pflags(a3)		;top goal?
	beq.w	.gd						;no
	add.w	d0,(yleader).w			;lead up
	cmpi.w	#$32,(yleader).w		;.ylmax = 50
	blt.w	.0						;not past it
	move.w	#$32,(yleader).w		;limit
	bra.w	.0						;done
.gd									;pfgoal clear
	sub.w	d0,(yleader).w			;lead down
	cmpi.w	#$FFCE,(yleader).w		;past -$32?
	bgt.w	.0						;no
	move.w	#$FFCE,(yleader).w		;limit
.0									;leader at its limit
	move.w	Yvel(a3),d2				;target y = Ypos + Yvel/128 + yleader
	asr.w	#7,d2					;/ 128
	add.w	Ypos(a3),d2				;plus Ypos
	add.w	(yleader).w,d2			;plus the lead
	move.w	(a3),d3					;Xpos
	move.w	d2,(yc1).w				;save Y
	move.w	d3,(xc1).w				;save X
.dd									;target ready: scroll toward it
	move.w	d2,d0					;target Y
	sub.w	(Vpos).w,d0				;minus Vpos
	cmp.w	#$FFF6,d0				;near the top?
	bge.w	.1						;no
	move.w	d2,d1					;target
	subi.w	#$FFF6,d1				;-.ylim
	cmp.w	#$FF38,d1				;past -$C8?
	bgt.w	.2						;no
	move.w	#$FF38,d1				;limit
	bra.w	.2						;scroll
.1									;below the top edge zone
	cmp.w	#$A,d0					;near the bottom?
	ble.w	.2x						;no
	move.w	d2,d1					;target
	subi.w	#$A,d1					;minus $A
	cmp.w	#$100,d1				;past $100?
	blt.w	.2						;no
	move.w	#$100,d1				;limit
.2									;scroll target set
	sub.w	(Vpos).w,d1				;d1 = distance to scroll
	beq.w	.2x						;no scroll
	asr.w	#4,d1					;/ 16
	bne.w	.v2						;not 0
	addq.w	#1,d1					;at least 1
.v2									;at least 1 pixel
	add.w	d1,(Vpos).w				;scroll
.2x									;vertical done
	move.w	d3,d0					;target X
	sub.w	(Hpos).w,d0				;minus Hpos
	cmp.w	#$FFD8,d0				;near the left?
	bge.w	.3						;no
	move.w	d3,d1					;target
	subi.w	#$FFD8,d1				;plus $28
	cmp.w	#$FFC4,d1				;past -$3C?
	bge.w	.4						;no
	move.w	#$FFC4,d1				;limit
	bra.w	.4						;scroll
.3									;right of the left edge zone
	cmp.w	#$28,d0					;near the right?
	ble.w	.x						;no
	move.w	d3,d1					;target
	subi.w	#$28,d1					;minus $28
	cmp.w	#$3C,d1					;past $3C?
	ble.w	.4						;no
	move.w	#$3C,d1					;limit
.4									;scroll target set
	sub.w	(Hpos).w,d1				;distance
	beq.w	.x						;no scroll
	asr.w	#4,d1					;/ 16
	bne.w	.h2						;not 0
	addq.w	#1,d1					;at least 1
.h2									;at least 1 pixel
	add.w	d1,(Hpos).w				;scroll
.x									;exit (also the end of the code above)
	rts								;return
