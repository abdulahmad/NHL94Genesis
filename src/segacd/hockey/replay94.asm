;	HOCKEY.BIN $13E04-$14989 (runtime $2EE04-$2F989): replay94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	The replay is the cartridge code; CD: its graphics come through the pointer table ($47D18,
;	$47D64, $47D68).

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

MenuWaitVblank	equ	$2C63A
ReloadRinkGraphics	equ	$2E986
setpads	equ	$318DE
vtoa	equ	$362F8
forceblack	equ	$36D0A
forceblack2	equ	$36D38
sfx	equ	$3710C
DecompressGraphicsPlain	equ	$38958
eraser	equ	$38C06
printz	equ	$38F6E
ClrHor	equ	$3C3AC
SetHor	equ	$3C40A
setvideo	equ	$3DD16
setupEASportsMap	equ	$3EC78
ReloadEnergyBarTiles	equ	$3EC94
ReloadCrowdTiles	equ	$3ECA6
ReloadRefTiles	equ	$3ECCA
ReloadFaceOffTiles	equ	$3ECDC
ReloadFaceOffMap	equ	$3ECEE
SprSort	equ	$3F03E
revframetbl	equ	$4761C
null	equ	$1B008
ReadJoy1	equ	$374F0
ReadJoy2	equ	$3750E
ReadJoy3	equ	$3752C
ReadJoy4	equ	$3754A
dobitmap	equ	$387E2
SPFPen	equ	$179
SPFbglass	equ	$28D
SPFfight	equ	$162
SPFpuck	equ	$18A

	org	$2EE04

;	Instant replay. This file records each frame of play, plays it back with the replay icon and
;	banner, moves the camera and restores the frames. New in 94: the reverse angle replay.

ReplayMode							;Instant replay play-back control and display code.
									;Called from the pause menu.
									;Tracking: a d-pad press picks the nearest object in that direction and
									;the camera follows it
	bclr.b	#0,(sflags5).l			;not slow mode
	bsr.w	forceblack				;screen off
	move.w	(disflags).l,-(sp)
	bset.b	#sf2replay,(sflags2).l	;flag that replay is on
	bclr.b	#4,(sflags4).l			;normal angle
	jsr	(ClrHor).l					;horizontal interrupt off
	move.w	#$400,d0				;$400 cells
	move.w	(VmMAP3).l,d1
	move.w	#$7FF,d2				;blank char
;CD: no cartridge twin
	jsr	$37AA2.l
	move.w	$18D56.l,d4
	movea.l	(ReplayMapPtr).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	jsr	(ShowReplayIcon).l
	bclr.b	#sfscrl,(sflags).l		;manual scroll is off
	bclr.b	#sf3track,(sflags3).l
	st.b	(replayactive).l
	movea.l	(recbpr).l,a4			;record buffer pointer (current frame)
.rwd								;loop
	bsr.w	suba4					;Rewind to first frame
	tst.w	d7						;more to rewind?
	bne.w	.rwd
	jsr	(SprSort).l
	jsr	(setvideo).l
	bclr.b	#sf3rmplay,(sflags3).l
	clr.l	(padcont).l
	clr.l	(padcont+4).l
	clr.l	(padcont+8).l
	move.w	#$18,(palcount).l		;fade in
	moveq	#1,d7					;1 frame
.top								;loop
	move.w	(Vcount).l,d0			;wait until d7 frames have passed
	sub.w	(OldVcount).l,d0		;frames since the last
	cmp.w	d0,d7					;enough?
	bhi.w	.top
	move.w	(Vcount).l,(OldVcount).l	;new frame count
	tst.w	(replayicontimer).l		;icon showing?
	bmi.w	.0
	sub.w	d7,(replayicontimer).l
	bpl.w	.0
	clr.w	(replayicontimer).l
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
	btst.b	#0,(sflags5).l			;slow mode?
	beq.w	.2
	andi.w	#$FFF0,d0				;direction bits only
	ori.w	#8,d0					;no direction
	andi.w	#$FFF0,d1
	andi.w	#$FFF0,d3
.2									;positions rounded in slow mode
	movea.l	#(CameraPosStruct-M68K_RAM),a5
	btst.b	#sf3track,(sflags3).l	;tracking an object?
	beq.w	.dir
	move.w	d1,d5
	andi.w	#$F,d5					;new d-pad press?
	beq.w	.nomans
.dir								;not tracking, or a new d-pad press: manual camera
	btst	#3,d0					;no direction?
	bne.w	.nomans
	cmpi.w	#$FF60,0(a5)			;X past the left?
	bgt.w	.3
	move.w	#0,0(a5)				;centre
	bra.w	.3
.3									;X inside the rink
	cmpi.w	#$FED0,Ypos(a5)			;Y past the bottom?
	bgt.w	.4
	move.w	#0,Ypos(a5)				;centre
.4									;Y inside the rink
	bset.b	#sfscrl,(sflags).l		;manual scrolling is on
	bne.w	.man					;scrolling?
	move.w	(Hpos).l,0(a5)			;first frame: camera starts at the screen
	move.w	(Vpos).l,Ypos(a5)
.man								;camera on manual
	move.w	d0,d5					;d5 = d-pad direction
	andi.w	#7,d5					;direction
	eori.w	#4,d5					;opposite
	movea.l	#$17480,a1				;CD: the cartridge has #(SortCords-M68K_RAM)
	st.b	d3						;no object to skip
	bclr.b	#sf3track,(sflags3).l
	beq.w	.find					;was not tracking
	move.w	camtrack(a5),d3			;skip the object tracked now
.find								;search start, skipping the tracked object
	move.w	0(a5),d0				;camera position d0/d1: search 12 players
	move.w	Ypos(a5),d1
	moveq	#$B,d2
	move.l	#$100,d4				;nearest distance squared so far
	movem.w	d0-d1,-(sp)				;save the camera position
.loop								;each player
	cmp.w	SCnum(a1),d3			;loop over the 12 players, skipping the tracked one
	beq.w	.skip					;tracked object?
	movem.w	(sp),d0-d1				;camera position
	sub.w	0(a1),d0
	sub.w	Ypos(a1),d1
	jsr	(vtoa).l					;direction to object
	btst	#3,d0					;no direction?
	bne.w	.skip
	sub.w	d5,d0					;minus the pad direction
	addi.w	#1,d0
	andi.w	#7,d0
	cmpi.w	#2,d0					;within 45 degrees?
	bhi.w	.skip					;not within 45 degrees of the d-pad
	movem.w	(sp),d0-d1				;camera position
	sub.w	0(a1),d0
	sub.w	Ypos(a1),d1
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0					;distance squared
	cmpi.l	#4,d0					;too close?
	bls.w	.skip					;too close
	cmp.l	d4,d0					;closer?
	bhi.w	.skip
	move.l	d0,d4					;closest so far
	move.w	SCnum(a1),camtrack(a5)
	bset.b	#sf3track,(sflags3).l
;CD: no cartridge twin
.skip								;CD: placed where the disc branches to it
	adda.l	#$80,a1
	dbf	d2,.loop
	adda.w	#$4,sp
	btst.b	#sf3track,(sflags3).l	;tracking?
	beq.w	.scrl					;nothing found: scroll by hand
	move.w	camtrack(a5),d0
	asl.w	#7,d0					;* SCstruct
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
	adda.w	d0,a3
	moveq	#4,d4					;4 pads
	bsr.w	setpads					;set the pads
	bsr.w	UpdateCameraPos
	jsr	(setvideo).l
	bra.w	.top
.scrl								;sf3track clear
	bset.b	#sfscrl,(sflags).l		;no object found: scroll the camera by hand
	eori.w	#4,d5					;opposite
	asl.w	#2,d5
	lea	.dirtab(pc),a0
	move.w	(a0,d5.w),d0
	add.w	0(a5),d0				;plus the camera X
	cmpi.w	#$88,d0					;past the right?
	bgt.w	.nox
	cmpi.w	#$FF78,d0				;past the left?
	blt.w	.nox
	move.w	d0,0(a5)
.nox								;X step taken (or out of range)
	move.w	$2(a0,d5.w),d1
	add.w	Ypos(a5),d1				;plus the camera Y
	cmpi.w	#$126,d1				;past the top?
	bgt.w	.noy
	cmpi.w	#$FEDA,d1				;past the bottom?
	blt.w	.noy
	move.w	d1,Ypos(a5)
;CD: no cartridge twin
.noy								;CD: placed where the disc branches to it
	movea.l	a5,a3
	clr.w	camidle(a5)				;camera moving
	andi.w	#$FFF,(PadControlBits).l	;keep the low bits
	ori.w	#$E000,(PadControlBits).l	;pads off
	bsr.w	UpdateCameraPos			;camera position
	jsr	(setvideo).l
	bra.w	.top
.dirtab								;scroll step per d-pad direction 0-7: x, y
	dc.w	0,2, 2,2
	dc.w	2,0, 2,-2
	dc.w	0,-2, -2,-2
	dc.w	-2,0, -2,2
.nomans								;d5 = 0 or bit 3 of d0 set
	st.b	camidle(a5)
	btst	#5,d1					;C?
	beq.w	.00
	btst.b	#0,(sflags5).l			;slow mode?
	bne.w	.00
	bchg.b	#sf3rmplay,(sflags3).l
.00									;C toggles play mode (not in slow mode)
	btst	#6,d3					;A held?
	beq.w	.5
	btst.b	#0,(sflags5).l			;slow mode?
	bne.w	.5
	bsr.w	suba4					;fast rewind
	bsr.w	suba4					;back a frame
	bsr.w	suba4					;back a frame
	bsr.w	suba4					;back a frame
	jsr	(SprSort).l
	jsr	(setvideo).l
	moveq	#1,d7					;1 frame
	bclr.b	#sf3rmplay,(sflags3).l	;turn off play mode
.5									;A: back a frame, unless slow mode
	btst.b	#0,(sflags5).l			;slow mode?
	bne.w	.1
	btst	#4,d3					;B held?
	beq.w	.1
	btst	#6,d3					;A too?
	beq.w	.f1
	bclr.b	#sf3track,(sflags3).l
	bclr.b	#sfscrl,(sflags).l		;a+b but = manual scroll off (hidden feature)
	move.w	d0,-(sp)
	move.w	(PadControlBits).l,d0
	andi.w	#$FFF,d0				;keep the low bits
	ori.w	#$E000,d0				;pads off
	move.w	d0,(PadControlBits).l
	move.w	(sp)+,d0
	bra.w	.top
.f1									;bit 6 of d3 clear
	bsr.w	adda4					;forward a frame
	jsr	(SprSort).l
	jsr	(setvideo).l
	asl.w	#1,d7					;double delay time between frames = 1/2 speed slow motion
	bclr.b	#sf3rmplay,(sflags3).l	;turn off play mode
.1									;B: forward at half speed, unless slow mode
	btst.b	#sf3rmplay,(sflags3).l	;play mode on?
	beq.w	.noplay
	st.b	(lastsfx).l				;play mode is on = advance one frame at original speed
	bsr.w	adda4					;forward a frame
	move.w	(lastsfx).l,-(sp)		;play sound effects
	bsr.w	sfx
	jsr	(SprSort).l
.noplay								;frame advanced or not, redraw
	jsr	(setvideo).l
	btst.b	#0,(sflags5).l			;slow mode?
	bne.w	.6
	btst	#7,d1					;start?
	beq.w	.top
	jsr	(ShowReplayBanner).l
	bclr.b	#sf3rmplay,(sflags3).l
	bset.b	#0,(sflags5).l			;slow mode
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
	bset.b	#6,(sflags4).l			;reverse angle change
	bclr.b	#0,(sflags5).l			;not slow mode
	jsr	(EraseReplayBanner).l
	bsr.w	adda4					;forward a frame
	jsr	(SprSort).l
	bra.w	.top
.7									;bit 6 of d1 set
	jmp	(.top).l
.8									;bit 7 of d1 set
	clr.w	(menuitem).l
	bset.b	#1,(sflags5).l			;back to the menu
.exit								;leave the replay
	bsr.w	forceblack				;screen off
	ori.w	#$F000,(PadControlBits).l	;pads off
	bclr.b	#sfscrl,(sflags).l
	movea.l	(recbpr).l,a4			;back to the current frame
	bclr.b	#4,(sflags4).l			;normal angle
	bsr.w	RestoreReplayFrame		;restore the frame
	jsr	(SprSort).l
	bclr.b	#sf2replay,(sflags2).l
	move.w	(sp)+,(disflags).l
	jsr	(ReloadRinkGraphics).l
	jsr	(setupEASportsMap).l
	jsr	(ReloadEnergyBarTiles).l
	jsr	(ReloadCrowdTiles).l
	jsr	(ReloadRefTiles).l
	btst.b	#4,(disflags).l			;faceoff showing?
	beq.w	.10
	jsr	(ReloadFaceOffMap).l
	jsr	(ReloadFaceOffTiles).l
.10									;faceoff map reloaded when it was showing
	jsr	(SetHor).l					;horizontal interrupt on
	jsr	(setvideo).l
	move.w	#$18,(palcount).l		;fade in
	rts								;exit replay mode
getpzjoy							;read the joystick of the pad that paused. pads 3 and 4 when FourWayPlay
									;(pausepad = 3 or 4)
	tst.w	(FourWayPlay).l			;four way?
	bne.w	.0
.loop								;loop
	btst.b	#sfpj,(sflags).l		;pad 2 paused?
;CD: no cartridge twin
	beq.s	.L2F30A
	jmp	(ReadJoy2).l
.L2F30A
	jmp	(ReadJoy1).l
.0									;FourWayPlay <> 0
	tst.w	(pausepad).l			;pad 1 or 2?
	beq.w	.loop
	cmpi.w	#3,(pausepad).l			;pad 3?
;CD: no cartridge twin
	bne.s	.L2F32A
	jmp	(ReadJoy3).l
.L2F32A
	jmp	(ReadJoy4).l
ShowReplayIcon						;CD: placed where the disc branches to it
	move.w	#$F0,(replayicontimer).l
	jsr	(printz).l
	String	CC_Font3Pri,2,2
	moveq	#$20,d0
	moveq	#$55,d1
	moveq	#8,d2
	moveq	#4,d3
	move.w	(rinkvrcset).l,d4
	move.w	#0,d5					;no palette lines
;CD: no cartridge twin
	movea.l	(RinktilelistPtr).l,a1
	btst.b	#$4,(sflags4).l
	beq.w	.L2F36E
	movea.l	(RevRinkTilelistPtr).l,a1
.L2F36E
	adda.l	$4(a1),a1
	movea.l	#null,a2
	jmp	(dobitmap).l
EraseReplayIcon						;Erase the 8 x 4 replay icon (replayicontimer timer ran out)
	jsr	(printz).l					;map at the icon
	String	CC_Font3Pri,2,2
	move.w	#8,d0					;8 wide
	move.w	#4,d1
	move.w	#$7FF,d2				;blank char
	jmp	(eraser).l
ShowReplayBanner					;Show ReplayMap at 0,0 (16 x 11) and stop the replayicontimer timer
	st.b	(replayicontimer).l
;CD: no cartridge twin
	jsr	(printz).l
	String	CC_Font3Pri,2,0
	moveq	#0,d0
	moveq	#0,d1
	moveq	#$10,d2
	moveq	#$B,d3
	move.w	(ExtraChars).l,d4
	move.w	#0,d5					;no palette lines
;CD: no cartridge twin
	movea.l	(ReplayMapPtr).l,a1
	adda.l	$4(a1),a1
	movea.l	#null,a2
	jmp	(dobitmap).l
EraseReplayBanner					;Erase the 16 x 11 area ShowReplayBanner drew
	jsr	(printz).l					;map at the top left
	String	CC_Font3Pri,2,2
	move.w	#$10,d0					;16 wide
	move.w	#$B,d1
	move.w	#$7FF,d2				;blank char
	jmp	(eraser).l
suba4								;a4 = current replay frame. Back up 1 frame and set video parameters for
									;display.
									;d7 = delay between frames, or zero at the end of the replay
	cmpa.l	#$C45C,a4				;at the start of the buffer? (CD: the cartridge has #M68K_RAM)
	bne.w	.1
	btst.b	#sfwrap,(sflags).l		;wrapped?
	beq.w	.end
	movea.l	#replayend,a4			;end of the buffer
.1									;frame pointer ready (wrapped to the end of the buffer)
	suba.w	#replaysize,a4			;back a frame
	cmpa.l	(recbpr).l,a4			;at the oldest?
	bne.w	RestoreReplayFrame
	adda.w	#replaysize,a4
.end								;at an end of the replay
	bsr.w	RestoreReplayFrame		;at either end of the replay: show frame, d7 = 0
	clr.w	d7
	rts
adda4								;Step forward 1 frame. First handles a reverse
									;angle switch (sflags4 bit 6)
	bclr.b	#6,(sflags4).l			;reverse angle change?
	beq.w	.1
	movem.l	d0-d7/a0-a6,-(sp)
	bchg.b	#4,(sflags4).l			;toggle reverse angle
	move.w	(Hpos).l,-(sp)
	move.w	(Vpos).l,-(sp)
	bsr.w	forceblack2
	jsr	(MenuWaitVblank).l			;frame
	jsr	(MenuWaitVblank).l			;frame
	jsr	(ReloadRinkGraphics).l
	clr.w	(Hpos).l
	clr.w	(Vpos).l
	move.w	#$7D0,(Oldrow).l		;redraw all rows
	move.w	#1,d0
.loop								;2 frames to redraw
	jsr	(setvideo).l
	jsr	(MenuWaitVblank).l			;frame
	dbf	d0,.loop					;loop
	move.w	(sp)+,(Vpos).l
	move.w	(sp)+,(Hpos).l
	move.w	#1,d0
	jsr	(setvideo).l
.loop2								;wait 2 more frames
	jsr	(MenuWaitVblank).l			;frame
	dbf	d0,.loop2					;loop
	movem.l	a0,-(sp)
	movea.l	#SortCords+(12*SCstruct),a0
	move.w	#1,oldframe(a0)
;CD: no cartridge twin
	adda.l	#$80,a0
	move.w	#1,oldframe(a0)
	movem.l	(sp)+,a0
	bsr.w	RevReplayAdj			;reverse adjust
	btst.b	#sfscrl,(sflags).l		;scrolling?
	beq.w	.0
.0									;(not branched to)
	jsr	(ShowReplayIcon).l
	move.w	#$64,(palcount).l		;copy now
	movem.l	(sp)+,d0-d7/a0-a6
.1									;end of the reload
	clr.w	d7
	btst.b	#sf2drec,(sflags2).l	;recording?
	beq.w	adda42
	movem.l	a4,-(sp)
	bsr.w	adda43					;look ahead
	cmpa.l	(recbpr).l,a4			;at the newest?
	movem.l	(sp)+,a4
	beq.w	rtss8
adda42								;adda4 without the sf2drec look-ahead: stop at the record point, else show
									;the frame and fall into adda43
	cmpa.l	(recbpr).l,a4			;at the newest?
	beq.w	rtss8
	bsr.w	RestoreReplayFrame
adda43								;a4 += replay frame size ($62), wrapping from replayend to M68K_RAM
	adda.w	#replaysize,a4			;next frame
	cmpa.l	#replayend,a4			;past the end?
	bne.w	rtss8
	movea.l	#$C45C,a4				;wrap to the start (CD: the cartridge has #M68K_RAM)
	rts
UpdateCameraPos						;Camera struct a5 = object a3 x/y (negated for the reverse angle),
									;Hpos/Vpos clamped
	movem.l	d0-d2,-(sp)
	move.w	0(a3),d0
	btst.b	#7,(sflags4).l			;reverse angle?
	beq.w	.0
	neg.w	d0
.0									;X mirrored for reverse angle
	move.w	d0,0(a5)
	move.w	Ypos(a3),d1
	btst.b	#7,(sflags4).l			;reverse angle?
	beq.w	.2
	neg.w	d1
.2									;Y mirrored for reverse angle
	move.w	d1,Ypos(a5)
	cmpi.w	#$3C,d0					;past $3C?
	blt.w	.4
	move.w	#$3C,d0
.4									;X not past the right limit
	cmpi.w	#$FFC4,d0				;past -$3C?
	bgt.w	.1
	move.w	#$FFC4,d0
.1									;X inside the limits
	move.w	d0,(Hpos).l
	cmpi.w	#$100,d1				;past $100?
	blt.w	.5
	move.w	#$100,d1
.5									;Y not past the top limit
	cmpi.w	#$FF38,d1				;past -$C8?
	bgt.w	.3
	move.w	#$FF38,d1
.3									;Y inside the limits
	move.w	d1,(Vpos).l
	movem.l	(sp)+,d0-d2
	rts
; set flag for reverse replay setup if needed
RevReplayAdj						;Set sflags4 bit 7 for a reverse angle replay, then fall into
									;RestoreReplayFrame
	btst.b	#4,(sflags4).l			;check if reverse angle replay
	beq.w	RestoreReplayFrame
	bset.b	#7,(sflags4).l
; a4 = current replay frame address to convert into normal coordinates
RestoreReplayFrame					;a4 = current replay frame address to convert into normal cordinates, then
									;the other replay variables. Flips x/y and frames for the reverse angle
	movem.l	d0-d2/a0/a6,-(sp)
	movea.l	#revframetbl,a6			;reverse frame table
	movea.l	a4,a0					;frame data
	moveq	#$F,d1					;16 objects to convert (12 players/2 nets/puck/puck shadow)
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
.top								;each of the 16 objects
	move.w	2(a0),d2				;loop over the 16 objects: x from word 1
	andi.w	#$3FF,d2
	btst	#9,d2					;negative?
	beq.w	.chkrevx
	ori.w	#$FC00,d2
.chkrevx							;X sign extended
	btst.b	#4,(sflags4).l			;check if reverse angle
	beq.w	.p
	neg.w	d2
.p									;X mirrored for reverse angle
	move.w	d2,0(a3)				;update Xpos
	move.l	(a0),d2					;frame long
	asr.l	#4,d2
	asr.w	#6,d2
	btst	#9,d2					;negative?
	beq.w	.chkrevy
	ori.w	#$FC00,d2
.chkrevy							;Y sign extended
	btst.b	#4,(sflags4).l			;check if reverse angle
	beq.w	.p1
	neg.w	d2
	cmpi.w	#0,d1					;check if last object (puck shadow)
	bne.w	.p1
	addi.w	#2,d2					;update puck shadow Xpos
.p1									;Y mirrored (puck shadow shifted) for reverse angle
	move.w	d2,Ypos(a3)
	move.w	(a0),d2					;frame word
	asr.w	#4,d2
	andi.w	#$3FF,d2
	btst.b	#4,(sflags4).l			;check if reverse angle
	beq.w	.2
	asl.w	#1,d2
	move.w	(a6,d2.w),d2			;look up table to adjust d2
	cmpi.w	#$F,SCnum(a3)			;check if puck shadow
	bne.w	.0
	cmpi.w	#SPFpuck,d2				;puck?
	beq.w	.0
	move.w	#$FC00,Ypos(a3)			;update Ypos of puck shadow
.0									;puck shadow handled
	cmpi.w	#1,d2					;check if frame is before frame 1 (out of range)
	blt.w	.1
	cmpi.w	#$34E,d2				;check if frame is >= 846 (last frame +1)
	bge.w	.1
	bra.w	.2						;branch if valid object frame
.1									;d2 < 1 or d2 >= $34E
	move.w	(a0),d2					;frame word
	asr.w	#4,d2
	andi.w	#$3FF,d2
.2									;frame number ready
	move.w	d2,frame(a3)
	cmpi.w	#SPFbglass,d2			;check if frame is before glass shatter frames
	blt.w	.3
	cmpi.w	#SPFbglass+5,d2			;check if frame is after glass shatter frames
	bge.w	.3
	btst.b	#4,(sflags4).l			;reverse angle?
	beq.w	.3
	move.w	#$190,Ypos(a3)			;glass Y
.3									;glass shatter moved for reverse angle
	move.w	(a0),d2					;frame word
	asr.w	#3,d2
	andi.w	#$1800,d2				;flip bits
	andi.w	#$E7FF,attribute(a3)	;flip bits
	or.w	d2,attribute(a3)
	btst.b	#4,(sflags4).l			;check if reverse angle replay
	beq.w	.4
	move.w	frame(a3),d2			;move frame into d2
	cmpi.w	#SPFfight,d2			;check if frame is before old fight frames
	blt.w	.4
	cmpi.w	#SPFPen,d2				;check if frame is after old fight frames
	bge.w	.4
	bchg.b	#3,attribute(a3)		;change X flip attribute for object
;CD: no cartridge twin
.4									;CD: placed where the disc branches to it
	adda.w	#$4,a0
	adda.l	#$80,a3
	dbf	d1,.top						;loop to next object
	moveq	#5,d2					;6 pairs of players
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
.loop								;each pair of players
	move.b	(a0)+,rostnum(a3)		;loop over the 6 pairs of players
	move.b	(a0),d0					;position byte
	andi.w	#$F,d0					;low nibble
	cmpi.w	#$F,d0					;$F?
	bne.w	.5
	moveq	#-1,d0
.5									;$F = no position (-1)
	move.w	d0,position(a3)			;position of the first player of the pair
;CD: no cartridge twin
	adda.l	#$80,a3
	move.b	(a0)+,d0
	lsr.b	#4,d0					;high nibble
	move.b	d0,rostnum(a3)
	move.b	(a0),d0
	asl.b	#4,d0					;low nibble up
	or.b	d0,rostnum(a3)
	move.b	(a0)+,d0				;position byte
	lsr.b	#4,d0					;high nibble
	andi.w	#$F,d0
	cmpi.w	#$F,d0					;$F?
	bne.w	.6
	moveq	#-1,d0
.6									;$F = no position (-1)
	move.w	d0,position(a3)
;CD: no cartridge twin
	adda.l	#$80,a3
	dbf	d2,.loop					;loop
	move.b	(a0)+,d0
	ext.w	d0
	move.w	d0,(puckz).l
	move.b	(a0)+,d0
	ext.w	d0
	move.w	d0,(SortCords+((puckscnum+1)*SCstruct)+Zpos).l
	move.b	(a0)+,d0
	ext.w	d0
	move.w	d0,(lastsfx).l
	clr.w	d7
	move.b	(a0)+,d7				;frame delay
	move.w	(a0)+,d0
	andi.w	#$FFF,d0
	andi.w	#$F000,(PadControlBits).l
	or.w	d0,(PadControlBits).l	;merge them
	move.w	(a0)+,(Crowdframe).l	;crowd frame
	move.w	(a0)+,(glovecords).l
	move.b	(a0)+,(PBnum).l			;penalty box count
	clr.w	d0
	move.b	(a0)+,d0
	lsl.w	#4,d0
	ori.w	#$F00F,d0
	move.w	d0,(PadControlBits34).l
	btst.b	#sfscrl,(sflags).l		;scrolling?
	beq.w	.pos
;CD: no cartridge twin
	movea.l	a5,a3
	btst.b	#sf3track,(sflags3).l	;tracking an object?
	beq.w	.cam					;tracking?
	clr.w	camidle(a5)				;camera moving
	move.w	camtrack(a5),d0
	asl.w	#7,d0					;* SCstruct
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
	adda.w	d0,a3
.cam								;camera follows a3
	bsr.w	UpdateCameraPos			;camera position
	bra.w	.7
.pos								;sfscrl clear
	move.w	(a0)+,(Hpos).l
	move.w	(a0)+,(Vpos).l
	btst.b	#4,(sflags4).l			;reverse angle?
	beq.w	.7
	neg.w	(Hpos).l
	neg.w	(Vpos).l
	jsr	(ClampReplayView).l
.7									;view clamped
	bclr.b	#7,(sflags4).l			;clear the reverse flag
	movem.l	(sp)+,d0-d2/a0/a6
	rts
ClampReplayView						;Clamp Hpos to -$3C..$3C and Vpos to -$C8..$100
	move.w	d0,-(sp)
	move.w	#$3C,d0
	cmp.w	(Hpos).l,d0				;Hpos past it?
	blt.w	.0
	move.w	#$FFC4,d0
	cmp.w	(Hpos).l,d0				;Hpos inside?
	ble.w	.1
.0									;Hpos past the limit: clamp
	move.w	d0,(Hpos).l
.1									;Hpos inside the limits
	move.w	#$100,d0
	cmp.w	(Vpos).l,d0				;Vpos past it?
	blt.w	.2
	move.w	#$FF38,d0
	cmp.w	(Vpos).l,d0				;Vpos inside?
	ble.w	.3
.2									;Vpos past the limit: clamp
	move.w	d0,(Vpos).l
.3									;Vpos inside the limits
	move.w	(sp)+,d0
	rts
; called every frame to save replay events
; d7 = elapsed frames
updatereplay						;called every frame to save replay events, d7 = elapsed frames
	btst.b	#gmhl,(gmode).l
	bne.w	rtss8
	btst.b	#sf2drec,(sflags2).l	;check if replay record disabled
	beq.w	.0
	tst.w	(replaydelay).l			;delay?
	beq.w	.rec
	subi.w	#1,(replaydelay).l
	bpl.w	.0						;still delaying
	clr.w	(replaydelay).l
	bra.w	.rec
.0									;sf2drec clear or replaydelay >= 0
	addi.l	#replaysize,(recbpr).l
	cmpi.l	#replayend,(recbpr).l
	bne.w	.rec					;not at the end
	bset.b	#sfwrap,(sflags).l
	move.l	#$C45C,(recbpr).l		;back to the start (CD: the cartridge has #M68K_RAM)
.rec								;record into the next slot
	movea.l	(recbpr).l,a0			;a0 = the record slot
	moveq	#$F,d2					;16 objects
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
.top								;pack each of the 16 objects
	clr.l	(a0)					;loop over the 16 objects: pack x, y, frame, flip bits
	move.w	0(a3),d1				;Xpos
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
;CD: no cartridge twin
	adda.w	#$4,a0
	adda.l	#$80,a3
	dbf	d2,.top						;loop
	moveq	#5,d2					;6 pairs of players
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
.loop								;each pair of players
	move.b	rostnum(a3),(a0)+		;loop over the 6 pairs of players
	move.w	position(a3),d0
	bpl.w	.n0
	moveq	#$F,d0					;not on ice
.n0									;off the ice: $F
	andi.w	#$F,d0					;position nibble
	move.b	d0,(a0)
;CD: no cartridge twin
	adda.l	#$80,a3
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
;CD: no cartridge twin
	adda.l	#$80,a3
	dbf	d2,.loop					;loop
	move.b	(puckz+1).l,(a0)+
	move.b	(SortCords+((puckscnum+1)*SCstruct)+Zpos+1).l,(a0)+
	move.b	(lastsfx+1).l,(a0)+
	bset.b	#7,(lastsfx+1).l		;cue saved
	move.b	d7,(a0)+
	move.w	(PadControlBits).l,(a0)+
	move.w	(Crowdframe).l,(a0)+	;crowd frame
	move.w	(glovecords).l,(a0)+
	move.b	(PBnum).l,(a0)+			;penalty box count
	move.w	d0,-(sp)
	move.w	(PadControlBits34).l,d0	;pads 3 and 4 bits
	lsr.w	#4,d0
	move.b	d0,(a0)+
	move.w	(sp)+,d0
	move.w	(Hpos).l,(a0)+
	move.w	(Vpos).l,(a0)+
rtss8								;shared rts for the early exits nearby
	rts
