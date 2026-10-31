;	Player logic. Turns controller input into skater actions (passing, shooting, checking, line changes) and
;	runs the computer players, with an assignment per position and for the goalie, bench and penalty box.
;	Also the puck at faceoffs, offsides and icing, plus the per-frame player update and scroll window.


; this routine calls all collision/animation/assignment code for all players
; d7 = elapse frames since last call
updateplayers						;this routine calls all collision/animation/assignment code for all
									;players. d7 = elapsed frames
	btst	#sfhor,(sflags).w		;check if screen is in horiz mode
	bne.w	.checkcrowd				;jump if horiz mode
	ori.w	#$F,(PadControlBits).w	;pads off
	cmpi.w	#5,(puckz).w			;check puckz with 5
	bgt.w	.gt
.clrcnt								;loop
	clr.w	(PuckZCntr).w
	bra.w	.checkcrowd
.gt									;puckz > 5
	move.w	(TmpPuckZ).w,d0
	cmp.w	(puckz).w,d0			;same?
	beq.w	.pzeq					;branch if puckz equal to TmpPuckZ
	move.w	(puckz).w,(TmpPuckZ).w
	bra.s	.clrcnt
.pzeq								;d0 = puckz
	addq.w	#1,(PuckZCntr).w		;add 1 to counter
	cmpi.w	#$10,(PuckZCntr).w		;compare counter to 10 (16 decmial)
	blt.w	.checkcrowd				;branch if less than
	clr.w	(PuckZCntr).w
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
	movea.w	#(SortCords-M68K_RAM),a3
.top								;loop
	move.l	(a3),OldXpos(a3)		;Xpos, oldXpos
	move.l	Ypos(a3),OldYpos(a3)
	move.l	Zpos(a3),OldZpos(a3)
	btst	#pf3fall,pflags3(a3)	;falling down?
	beq.w	.top2
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	tst.w	SPAnum(a3)
	bne.w	.0						;branch if index not 0
	jsr	(PlaceBoardFall).l			;place him on the boards
	bra.w	.top2
.0									;falling in mid animation
	cmpi.w	#SPAbenchcheckl,SPA(a3)
	beq.w	.10
	cmpi.w	#SPAbenchcheckr,SPA(a3)	;right bench check?
	beq.w	.8
	cmpi.w	#SPAboardleft,SPA(a3)	;left boards?
	beq.w	.9
	cmpi.w	#SPAboardright,SPA(a3)	;right boards?
	beq.w	.7
	cmpi.w	#SPAboardfront,SPA(a3)	;front boards?
	beq.w	.1
	cmpi.w	#SPAboardback,SPA(a3)	;back boards?
	beq.w	.4
	bra.w	.top2
.1									;front boards: the wall Y
	move.w	#$124,d0				;wall Y
	cmpi.w	#$56,(FallXPos).w		;right corner?
	bgt.w	.2
	cmpi.w	#$FFAA,(FallXPos).w		;middle?
	bgt.w	.3
.2									;near a corner: the closer wall
	move.w	#$116,d0				;closer wall
.3									;set Y on the wall
	move.w	d0,Ypos(a3)
	bra.w	.top2
.4									;back boards
	move.w	#$FEDC,d0				;wall Y
	cmpi.w	#$56,(FallXPos).w		;right corner?
	bgt.w	.5
	cmpi.w	#$FFAA,(FallXPos).w		;middle?
	bgt.w	.6
.5									;near a corner: the closer wall
	move.w	#$FEEA,d0				;closer wall
.6									;set Y on the wall
	move.w	d0,Ypos(a3)
	bra.w	.top2
.7									;right boards
	move.w	#$82,(a3)				;wall X
	btst	#3,attribute(a3)		;flipped?
	beq.w	.top2
	move.w	#$FF7E,(a3)				;other side
	bra.w	.top2
.8									;right bench boards
	move.w	#$88,(a3)				;wall X
	btst	#3,attribute(a3)		;flipped?
	beq.w	.top2
	move.w	#$FF78,(a3)				;other side
	bra.w	.top2
.9									;left boards
	move.w	#$FF7E,(a3)				;wall X
	btst	#3,attribute(a3)		;flipped?
	beq.w	.top2
	move.w	#$82,(a3)				;other side
	bra.w	.top2
.10									;left bench boards
	move.w	#$FF78,(a3)				;wall X
	btst	#3,attribute(a3)		;flipped?
	beq.w	.top2
	move.w	#$88,(a3)				;other side
.top2								;each player on the ice
	tst.w	position(a3)			;check if on ice
	bmi.w	.nf1					;branch if not on ice
	move.w	SCnum(a3),d0
	cmp.w	(puckc).w,d0			;check if player has puck
	beq.w	.top3					;branch if puck carrier
	bclr	#pf3break,pflags3(a3)	;clear breakaway bit
	bclr	#pf3oside,pflags3(a3)
.top3								;puck carrier keeps his flags
	bsr.w	updateanim
	sub.b	d7,nopuck(a3)
	bpl.w	.np
	clr.b	nopuck(a3)				;clear upper byte of nopuck
.np									;upper byte done
	sub.b	d7,nopuck+1(a3)			;subtract # of frames from nopuck+1
	bpl.w	.np2
	clr.b	nopuck+1(a3)			;clear lower byte of nopuck
.np2								;lower byte done
	btst	#sf3icetime,(sflags3).w	;check if penalty timer is up
	beq.w	.11
	clr.w	d0
	move.b	pnum(a3),d0				;player offset on roster
	bmi.w	.11
	add.w	d0,d0
	addi.w	#$136,d0				;ice time table
	jsr	(loadTeamStruct).l			;a2 = team struct
	addq.w	#1,0(a2,d0.w)			;add 1 to TOI for player
.11									;ice time counted
	cmpi.w	#SPAinjuryfall,SPA(a3)
	beq.w	.done
	cmpi.w	#SPAinjury1,SPA(a3)
	beq.w	.done
	moveq	#$11,d4					;NTSC speed
	tst.w	(PalMode).w				;PAL?
	beq.w	.notoside
	moveq	#$16,d4					;PAL speed
.notoside							;speed scale for NTSC or PAL
	mulu.w	d7,d4
	tst.w	Zpos(a3)
	bne.w	.y2
	moveq	#6,d2					;normal deceleration
	btst	#pfdoff,pflags(a3)		;pfdoff - player deceleration
	beq.w	.off
	moveq	#9,d2					;this value used when player receiving pass. Also the puck will use this
									;when "normal"
.off								;deceleration shift chosen
	move.w	Xvel(a3),d0
	beq.w	.x2
	asr.w	d2,d0					;shift d0 right d2 times
	bne.w	.x1						;branch if d0 not zero
	moveq	#1,d0					;make d0 1 if it was 0
.x1									;at least 1
	sub.w	d0,Xvel(a3)
.x2									;Xvel slowed
	move.w	Yvel(a3),d0
	beq.w	.y2						;branch if d0 is 0
	asr.w	d2,d0					;shift d0 to the right d2 times
	bne.w	.y1						;branch if d0 not 0
	moveq	#1,d0					;make d0 1 if it was 0
.y1									;at least 1
	sub.w	d0,Yvel(a3)				;sub d0 from Yvel
.y2									;Yvel slowed
	move.w	Xvel(a3),d0
	beq.w	.x3						;branch if d0 is 0
	muls.w	d4,d0					;mult d0 by d4
	add.l	d0,(a3)					;add to Xpos
.x3									;X moved
	move.w	Yvel(a3),d0
	beq.w	.y3						;branch if d0 is 0
	muls.w	d4,d0					;mult d0 by d4
	add.l	d0,Ypos(a3)
.y3									;Y moved
	tst.w	Zpos(a3)
	bmi.w	.done
	bne.w	.z1						;branch if not 0
	tst.w	Zvel(a3)
	beq.w	.done
.z1									;in the air: gravity
	asl.w	#1,d4					;gravity: d4 = 32*d7
	sub.w	d4,Zvel(a3)				;Zvel -= it
	asl.w	#1,d4					;d4 = 64*d7
	sub.w	d4,Zvel(a3)				;Zvel -= it (96*d7 a frame in all)
	lsr.w	#2,d4					;d4 back to 16*d7, the position step
	move.w	Zvel(a3),d0				;move Zvel into d0
	muls.w	d4,d0					;mult d0 by d4
	add.l	d0,Zpos(a3)				;add d0 to Zpos
	bpl.w	.done					;branch if d0+Zpos is positive
	clr.l	Zpos(a3)
	neg.w	Zvel(a3)
	asr.w	Zvel(a3)				;divide Zvel by 2
	moveq	#5,d0					;move 5 into d0
	sub.b	Zvel(a3),d0				;sub Zvel from d0
	bpl.w	.chkpuck				;branch if result is positive
	clr.w	d0
.chkpuck							;bounce sound strength
	cmp.w	#3,d0					;compare d0 to 3
	bhi.w	.done					;branch if higher than 3
	addi.w	#SFXpuckice,d0
	move.w	d0,-(sp)
	bsr.w	sfx
.done								;movement done
	move.w	SCnum(a3),d6
	cmp.w	(puckc).w,d6			;check if puck carrier
	bne.w	.tp						;not puck carrier
	btst	#pf2fight,pflags2(a3)	;pf2fight - check if fighting
	bne.w	.tp
	btst	#sfhor,(sflags).w		;#sfhor - check if in horiz mode
	bne.w	.tp
	moveq	#-2,d4					;-2 - pad index for puck carrier
	bsr.w	setpads					;set the pads
.tp									;pads checked
	btst	#sf2faceoff,(sflags2).w	;sf2faceoff- check for faceoff
	bne.w	.tp2
	tst.w	(holdreset).w			;reset hold?
	beq.w	.tp2
	subq.w	#1,(holdreset).w
	beq.w	.12						;ran out
	bpl.w	.tp2
.12									;hold timer ran out: reset the hold timers
	clr.w	(holdreset).w
	move.w	#$1111,(bholdtimer).w	;reset the B hold timers
	move.w	#$1111,(bholdtimer34).w
.tp2								;check each pad's player
	cmp.w	(c1playernum).w,d6		;check if cont 1 is puck carrier
	bne.w	.t0
	bsr.w	ReadJoy1
	clr.w	d4						;pad index for cont 1 player
	move.w	#$FFFF,(joypuckcarrier).w	;home pad
	bsr.w	doinput
	bra.w	.t1
.t0									;d6 <> c1playernum
	cmp.w	(c2playernum).w,d6		;check if cont 2 is puck carrier
	bne.w	.t1
	bsr.w	ReadJoy2
	moveq	#2,d4					;pad index for cont 2 player
	move.w	#$FFFF,(joypuckcarrier).w
	bsr.w	doinput
.t1									;pad 2 done
	cmp.w	#$B,d6					;check if SCnum 0-11 were puck carrier (players)
	bgt.w	.t1cont
	tst.w	(cont3team).w			;check if there is 3 controllers?
	beq.w	.13
	cmp.w	(c3playernum).w,d6		;pad 3's player?
	bne.w	.13
	jsr	(ReadJoy3).l
	clr.l	d4
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
	bsr.w	doinput
	move.w	(PadControlBits).w,(PadControlBits34).w
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
	beq.w	.t1cont
	cmp.w	(c4playernum).w,d6		;pad 4's player?
	bne.w	.t1cont
	jsr	(ReadJoy4).l
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
	bsr.w	doinput
	move.w	(PadControlBits).w,(PadControlBits34).w
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
	move.w	assnum(a3),d0
	clr.w	d1
	move.b	asslist(a3,d0.w),d1		;asslist of SCstruct
	asl.w	#2,d1
	movea.l	#asstab,a0
	movea.l	0(a0,d1.w),a0			;get address of assignment to use for jmp
	jsr	(loadTeamStruct).l			;a2 = team struct
	jsr	(a0)						;call assignment for this player
	clr.w	Wallcos(a3)
	clr.w	Wallsin(a3)
	move.w	(a3),d2					;Xpos
	move.w	Ypos(a3),d3
	cmp.w	OldXpos(a3),d2
	bne.w	.cc						;branch if not equal
	cmp.w	OldYpos(a3),d3
	beq.w	.nf
.cc									;moved: check for collisions
	jsr	(checkcoll).l
.nf									;collisions done or not moved
	move.w	d7,d0					;move d7 into d0 (elapsed frames)
	asl.w	#1,d0
	sub.w	d0,impact(a3)			;reduce impact at a constant rate
	bpl.w	.nf1
	clr.w	impact(a3)				;clear impact if negative or zero
.nf1								;impact ready
	move.w	impact(a3),limpact(a3)	;move impact into limpact
	adda.w	#SCstruct,a3
	cmpi.w	#$F,SCnum-SCstruct(a3)	;compare Sortobjs-1 to SCnum-SCstruct
	blt.w	.top					;loop for all Sort objects
	rts
; frame switch control on struct a3
updateanim							;frame switch control on struct a3
	tst.w	SPA(a3)
	bne.w	.ia						;branch if not 0
	bclr	#pfalock,pflags(a3)
	bclr	#pf2aip,pflags2(a3)		;clear anim in progress
	rts
.ia									;an animation is set
	movea.l	#SPAlist,a0				;animation data tables
	adda.w	SPA(a3),a0				;add SPA to a0 address
	move.w	SPAattr(a0),d1			;16 dec - attributes for anim
	move.w	facedir(a3),d0
	btst	#sfhor,(sflags).w		;check if horizontal mode
	beq.w	.nhor
	cmpi.w	#$C,SCnum(a3)			;compare to 12 (check if a player, not the puck or nets)
	bge.w	.nhor					;branch if greater than (puck or nets)
	subq.w	#2,d0					;direction adjust for horizontal rink
	andi.w	#7,d0
.nhor								;direction ready
	btst	#3,attribute(a3)		;x flip flag
	beq.w	.nox					;branch if no flip
	neg.w	d0
	addq.w	#8,d0					;add 8 to d0 for flipping
	andi.w	#7,d0					;pass first 3 bits
.nox								;flip handled
	asl.w	#1,d0
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
	clr.w	d0
	clr.w	SPAnum(a3)
	bclr	#pfalock,pflags(a3)
	bclr	#pf2aip,pflags2(a3)		;clear animation in progress
	bclr	#pf3fall,pflags3(a3)	;clear fall down flag
	btst	#0,d1					;check if anim attribute loops
	bne.w	.1
	clr.w	SPA(a3)
.1									;looping animation keeps SPA
	move.w	2(a0,d0.w),d0			;move frame time for animation frame into d0
	bpl.w	.0
	neg.w	d0						;make d0 negative (this is the case if final frame)
.0									;frame time ready
	move.w	d0,SPAcnt(a3)			;move d0 into SPAcnt
.cframe								;count down to the next frame
	sub.b	d7,glitch(a3)			;sub frames elapsed from glitch - limit minimum
									;time between frame switches
	bpl.w	.rtss					;branch if glitch is positive still
	clr.b	glitch(a3)
	cmp.w	frame(a3),d2			;compare frame to d2
	beq.w	.rtss
	move.w	d2,frame(a3)			;move d2 into frame
	move.b	#4,glitch(a3)			;move 4 into glitch - /60 sec min frame switch time
.rtss								;exit (also the end of the code above)
	rts
freezewindow						;lock scrolling to the current position
	move.w	(Vpos).w,(yc1).w
	move.w	(Hpos).w,(xc1).w
	bset	#sfslock,(sflags).w
	rts
checkwindow							;set Hpos and Vpos according to how the screen should follow the puck
	move.w	(yc1).w,d2
	move.w	(xc1).w,d3				;if locked, use these cordinates
	btst	#sfslock,(sflags).w		;locked?
	bne.w	.dd
	movea.w	#(puckx-M68K_RAM),a3
	move.w	(puckc).w,d0
	bmi.w	.0
	asl.w	#7,d0					;* SCstruct
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3
	move.w	d7,d0
	add.w	d0,d0
	btst	#pfgoal,pflags(a3)		;top goal?
	beq.w	.gd
	add.w	d0,(yleader).w
	cmpi.w	#$32,(yleader).w		;.ylmax = 50
	blt.w	.0
	move.w	#$32,(yleader).w		;limit
	bra.w	.0
.gd									;pfgoal clear
	sub.w	d0,(yleader).w
	cmpi.w	#$FFCE,(yleader).w		;past -$32?
	bgt.w	.0
	move.w	#$FFCE,(yleader).w		;limit
.0									;leader at its limit
	move.w	Yvel(a3),d2				;target y = Ypos + Yvel/128 + yleader
	asr.w	#7,d2
	add.w	Ypos(a3),d2
	add.w	(yleader).w,d2
	move.w	(a3),d3					;Xpos
	move.w	d2,(yc1).w
	move.w	d3,(xc1).w
.dd									;target ready: scroll toward it
	move.w	d2,d0
	sub.w	(Vpos).w,d0
	cmp.w	#$FFF6,d0				;near the top?
	bge.w	.1
	move.w	d2,d1
	subi.w	#$FFF6,d1				;-.ylim
	cmp.w	#$FF38,d1				;past -$C8?
	bgt.w	.2
	move.w	#$FF38,d1				;limit
	bra.w	.2
.1									;below the top edge zone
	cmp.w	#$A,d0					;near the bottom?
	ble.w	.2x
	move.w	d2,d1
	subi.w	#$A,d1
	cmp.w	#$100,d1				;past $100?
	blt.w	.2
	move.w	#$100,d1				;limit
.2									;scroll target set
	sub.w	(Vpos).w,d1				;d1 = distance to scroll
	beq.w	.2x
	asr.w	#4,d1
	bne.w	.v2
	addq.w	#1,d1					;at least 1
.v2									;at least 1 pixel
	add.w	d1,(Vpos).w
.2x									;vertical done
	move.w	d3,d0
	sub.w	(Hpos).w,d0
	cmp.w	#$FFD8,d0				;near the left?
	bge.w	.3
	move.w	d3,d1
	subi.w	#$FFD8,d1
	cmp.w	#$FFC4,d1				;past -$3C?
	bge.w	.4
	move.w	#$FFC4,d1				;limit
	bra.w	.4
.3									;right of the left edge zone
	cmp.w	#$28,d0					;near the right?
	ble.w	.x
	move.w	d3,d1
	subi.w	#$28,d1
	cmp.w	#$3C,d1					;past $3C?
	ble.w	.4
	move.w	#$3C,d1					;limit
.4									;scroll target set
	sub.w	(Hpos).w,d1
	beq.w	.x
	asr.w	#4,d1
	bne.w	.h2
	addq.w	#1,d1					;at least 1
.h2									;at least 1 pixel
	add.w	d1,(Hpos).w
.x									;exit (also the end of the code above)
	rts


doinput								;process controller input: d0 = dpad, d1 = new buttons, d2 = changed
									;buttons, d3 = held buttons, d4 = controller 0/2
	btst	#4,d1					;B button
	beq.w	.1						;branch if not pressed
	btst	#5,d1					;C button
	beq.w	.1						;branch if not pressed
	bclr	#4,d1
	bset	#6,pflags3(a3)
	bra.w	.5
.1									;bit 4 of d1 clear or bit 5 of d1 clear
	btst	#4,d1
	beq.w	.2
	bclr	#6,pflags3(a3)
.2									;bit 4 of d2 check
	btst	#4,d2
	beq.w	.5
	bclr	#6,pflags3(a3)
	beq.w	.5
	tst.w	d4
	bne.w	.3
	move.b	#$11,(bholdtimer).w
	bra.w	.4
.3									;d4 <> 0
	move.b	#$11,(bholdtimer+1).w
.4									;timer set: drop the B change bit
	bclr	#4,d2
.5									;A+B+C cases done; in goalie mode shorten the message timer
	btst	#7,(gmode2).w
	beq.w	.6
	cmp.b	#8,d0
	beq.w	.6
	jsr	(ShortenMsgTimer).l
.6									;keep the pad
	move.w	d0,(TempWord1).w
	andi.w	#$F,(TempWord1).w
	bsr.w	setpads
	btst	#7,d1					;start button
	beq.w	.nostart				;branch if no start button pressed
	tst.w	(joypuckcarrier).w
	bpl.w	.7
	tst.w	d4
	beq.w	startpause1
	bra.w	startpause2
.7									;joypuckcarrier >= 0
	btst	#7,d1
	beq.w	.nostart
	tst.w	(joypuckcarrier).w
	beq.w	startpause3
	bra.w	startpause4
.nostart							;bit 7 of d1 clear
	btst	#sfhor,(sflags).w
	beq.w	.nhor
	btst	#3,d0
	bne.w	.nhor
	addq.w	#2,d0
	andi.w	#7,d0
.nhor								;faceoff check
	btst	#sf2faceoff,(sflags2).w
	bne.w	faceoffinput
	btst	#pf2lcm,pflags2(a3)
	bne.w	lineinput
	btst	#pfjoycon,pflags(a3)
	beq.w	rtss15
	movem.l	d0-d2/a0/a3,-(sp)
	move.w	(lastplayer).w,d0
	cmp.w	SCnum(a3),d0
	bne.w	.noot
	tst.w	(passReceiverPlayerNum).w
	bmi.w	.noot
	tst.w	(onetimerplayer).w
	bpl.w	.noot
	btst	#5,d1
	beq.w	.noot
	move.w	(passReceiverPlayerNum).w,d0
	asl.w	#7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	tst.w	position(a3)
	beq.w	.noot
	jsr	(PuckOnAttackHalf).l
	beq.w	.noot
	btst	#pfjoycon,pflags(a3)
	bne.w	.noot
	btst	#pf3onetimer,pflags3(a3)
	bne.w	.noot
	move.w	d4,(inputjoy).w
	move.w	(joypuckcarrier).w,(TmpJoyPuckCarrier).w
	move.w	#$23,d0					;assonetimer
	jsr	(assreplace).l
	movem.l	(sp)+,d0-d2/a0/a3
	rts
.noot								;pop the d0-d2/a0/a3 saved above
	movem.l	(sp)+,d0-d2/a0/a3
	btst	#pf3onetimer,pflags3(a3)
	bne.w	.chkfight
	btst	#pfalock,pflags(a3)
	bne.w	doinput_islocked
.chkfight							;fighting?
	btst	#pf2fight,pflags2(a3)	;fighting in progress
	bne.w	fightinput
	move.w	(puckc).w,d5
	cmp.w	SCnum(a3),d5
	beq.w	doinput_ispc
	tst.w	position(a3)
	beq.w	.11
	btst	#pf3onetimer,pflags3(a3)
	beq.w	.10
	bra.w	.11
.10									;pf3onetimer clear
	btst	#6,d1
	bne.w	Holdplayer
.11									;skater (position <> 0) or goalie: pick how B is handled
	tst.w	position(a3)
	beq.w	.12
	btst	#2,(BA_PS_flags).w
	bne.w	.noswitch
	bra.w	.bhold
.12									;goalie: B switches players only in goalie mode, and not from the puck
									;carrier
	btst	#6,(sflags5).w
	bne.w	.bhold
	tst.w	d4
	beq.w	.13
	tst.w	(goaliemode2).w
	bra.w	.14
.13									;d4 = 0
	tst.w	(goaliemode1).w
.14									;flags from this pad's goaliemode: off = B hold checks
	beq.w	.bhold
	movem.w	d0,-(sp)
	move.w	SCnum(a3),d0
	cmp.w	(puckc).w,d0
	movem.w	(sp)+,d0
	beq.w	.bhold
	bra.w	changeplayer
.bhold								;B still held (no holdreset): count down the hold timer, else treat it as
									;a press
	btst	#4,d3
	beq.w	.bpress
	tst.w	(holdreset).w
	bne.w	.bpress
	tst.w	d4
	beq.w	.c1
	tst.b	(bholdtimer+1).w
	beq.w	.noswitch
	subq.b	#1,(bholdtimer+1).w
	bpl.w	.16
	move.b	#0,(bholdtimer+1).w
.16									;timer clamped at 0
	tst.b	(bholdtimer+1).w
	bne.w	.bpress
	tst.w	d4
	beq.w	.17
	tst.w	(goaliemode2).w
	bra.w	.18
.17									;d4 = 0
	tst.w	(goaliemode1).w
.18									;goalie mode: handle as a press, else go to the goalie
	bne.w	.bpress
	bra.w	.goalie
.c1									;d4 = 0
	tst.b	(bholdtimer).w
	beq.w	.noswitch
	subq.b	#1,(bholdtimer).w
	bpl.w	.20
	move.b	#0,(bholdtimer).w
.20									;timer clamped at 0
	tst.w	d4
	beq.w	.21
	tst.w	(goaliemode2).w
	bra.w	.22
.21									;d4 = 0
	tst.w	(goaliemode1).w
.22									;goalie mode: press; else the goalie once the hold timer is out
	bne.w	.bpress
	tst.b	(bholdtimer).w
	beq.w	.goalie
.bpress								;B pressed: start this pad's hold timer; released (.brel): switch players
	btst	#4,d1
	beq.w	.brel
	tst.w	d4
	bne.w	.24
	move.b	#$11,(bholdtimer).w
	bra.w	.noswitch
.24									;d4 <> 0
	move.b	#$11,(bholdtimer+1).w
	bra.w	.noswitch
.brel								;bit 4 of d1 clear
	btst	#4,d2
	beq.w	.noswitch
	btst	#4,d3
	bne.w	.noswitch
	move.w	(bholdtimer).w,d0
	tst.w	d4
	beq.w	.28
	move.b	#$11,(bholdtimer+1).w
	andi.w	#$FF,d0
	bne.w	changeplayer
	tst.w	d4
	beq.w	.26
	tst.w	(goaliemode2).w
	bra.w	.27
.26									;d4 = 0
	tst.w	(goaliemode1).w
.27									;goalie mode: switch players, else take the goalie
	bne.w	changeplayer
	bra.w	.goalie
.28									;d4 = 0
	move.b	#$11,(bholdtimer).w
	andi.w	#$FF00,d0
	bne.w	changeplayer
	tst.w	d4
	beq.w	.29
	tst.w	(goaliemode2).w
	bra.w	.30
.29									;d4 = 0
	tst.w	(goaliemode1).w
.30									;goalie mode: switch players, else take the goalie
	bne.w	changeplayer
.goalie								;take the goalie of a3's team (SCnum 5 home, 11 away) unless holdreset
	tst.w	(holdreset).w
	bne.w	changeplayer
	move.w	#5,d0
	cmp.w	#5,d6
	ble.w	.32
	move.w	#$B,d0
.32									;pad's goalie
	jsr	(getGoalieSCnum).l
	tst.w	d0
	bmi.w	rtss15
	movem.l	d0/a3,-(sp)
	movea.l	#SortCords,a3
	asl.w	#7,d0
	adda.w	d0,a3
	btst	#pfjoycon,pflags(a3)
	movem.l	(sp)+,d0/a3
	bne.w	rtss15
	tst.w	d4
	beq.w	setc1player
	bra.w	setc2player
.noswitch							;no switch: one-timer setup, A pass / line change, or the C button
	tst.w	position(a3)
	bne.w	doinput_onetimer
	btst	#6,d1
	beq.w	doinput_cbut
	move.w	(TempWord1).w,d0
	cmp.b	#8,d0
	beq.w	doinput_cbut
	move.w	d0,facedir(a3)
	move.b	#8,nopuck(a3)
	move.w	#SPAgdive,d1			;goalie dive animation
	bsr.w	SetSPA
	bset	#pf2aip,pflags2(a3)
	bset	#pfalock,pflags(a3)
	addi.w	#$96,(Crowdlevel).w
rtss15								;shared rts for the early exits nearby
	rts
doinput_cbut						;C button (bit 5): hold / release handling for a3, then doinput_chkanim
	btst	#5,d1
	bne.w	.press
	btst	#5,d3
	bne.w	.held
	bclr	#7,pflags2(a3)
	bra.w	doinput_chkanim
.held								;bit 5 of d3 set
	btst	#7,pflags2(a3)
	beq.w	doinput_chkanim
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	#SPAlist,a0
	adda.w	SPA(a3),a0
	move.w	facedir(a3),d0
	btst	#3,attribute(a3)
	beq.w	.1
	neg.w	d0
	addq.w	#8,d0
	andi.w	#7,d0
.1									;facedir mirrored for flipped animations (attribute bit 3)
	asl.w	#1,d0
	adda.w	0(a0,d0.w),a0
	tst.b	SPAnum+1(a3)
	movem.l	(sp)+,d0-d3/a0-a3
	bpl.s	rtss15
	move.w	#$A,SPAcnt(a3)
	rts
.press								;bit 5 of d1 set
	btst	#pfalock,pflags(a3)
	bne.w	doinput_chkanim
	movem.w	d0-d1,-(sp)
	move.w	(puckx).w,d0
	sub.w	(a3),d0
	move.w	(pucky).w,d1
	sub.w	Ypos(a3),d1
	bsr.w	vtoa
	move.w	d0,facedir(a3)
	movem.w	(sp)+,d0-d1
	move.w	(TempWord1).w,d0
	bclr	#0,(BA_PS_flags).w
	move.w	(gameclock).w,d0
	andi.w	#7,d0
	asl.w	#4,d0
	addi.w	#$A0,d0
	cmpi.w	#$DB,(pucky).w
	bgt.w	.3
	cmpi.w	#$FF25,(pucky).w
	bgt.w	.4
.3									;puck Y outside the zone
	subi.w	#$40,d0
.4									;d0 = lead time: shorter near the ends (pucky past the blue lines)
	move.w	d0,d1
	muls.w	(puckvx).w,d0
	swap	d0
	add.w	(puckx).w,d0
	muls.w	(puckvy).w,d1
	swap	d1
	add.w	(pucky).w,d1
	bsr.w	ClampTargetY
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	#$384,d0
	bhi.w	.far
	movem.w	(sp)+,d0-d1
	bra.w	.near
.far								;d0 > $384
	bsr.w	Sroot
	moveq	#1,d2
	add.w	d0,d2
	moveq	#$12,d4
	btst	#sfssdir,(sflags).w
	beq.w	.6
	addq.w	#8,d4
.6									;pop the d0-d1 saved above
	movem.w	(sp)+,d0-d1
	muls.w	d4,d1
	addq.w	#8,d4
	muls.w	d4,d0
	divs.w	d2,d0
	divs.w	d2,d1
.near								;target within 30 pixels: no scaling
	add.w	d3,d1
	move.w	d1,d2
	cmpi.w	#$22,2(a0)
	cmpi.w	#$18,(a0)
	cmpi.w	#$FFE8,(a0)
	cmpi.w	#$C,2(a0)
	cmpi.w	#$108,(pucky).w
	cmpi.w	#$FEF8,(pucky).w
	bset	#pf2aip,pflags2(a3)
	bne.w	doinput_chkanim
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#puckcross,a0
	move.w	#$108,d3
	btst	#pfgoal,pflags(a3)		;check which net shooting on
	beq.w	.save					;branch if bottom net
	neg.w	d3						;negate d3 (-108 hex)
	addq.w	#pcsize,a0				;bottom goalie puckcross entry
.save								;goalie save
	jsr	(goaliesave).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ClampTargetY						;clamp the target y d1 for player a3 (d0 cleared when a3 has the puck)
	move.w	(puckc).w,d2
	cmp.w	SCnum(a3),d2
	bne.w	.0
	clr.w	d0
.0									;d0 cleared when a3 is the puck carrier
	cmp.w	#$103,d1
	blt.w	.1
	move.w	#$103,d1
.1									;clamp X high
	cmp.w	#$FEFD,d1
	bgt.w	.2
	move.w	#$FEFD,d1
.2									;clamp d1 to the top limit
	sub.w	d3,d1
	rts
	;10 SPA offsets, unreferenced: SPAgglover, SPAgglovel, SPAgstackr, SPAgstackl
	;SPAgstickr, SPAgstickl, then the newer tables SPAghighr, SPAghighl, SPAgstick2r, SPAgstick2l
	dc.w	SPAgglover,SPAgglovel,SPAgstackr,SPAgstackl,SPAgstickr,SPAgstickl,SPAghighr,SPAghighl,SPAgstick2r,SPAgstick2l
doinput_chkanim						;Nothing while a3's animation runs (pflags2 bit 1); else skate a3
									;(doplayeracc)
	btst	#pf2aip,pflags2(a3)
	beq.w	.0
	rts
.0									;pf2aip clear
	tst.w	position(a3)
	bne.w	doplayeracc
	bclr	#1,(BA_PS_flags).w
	cmpi.w	#$24,(a3)
	ble.w	.1
	tst.w	Xvel(a3)
	bmi.w	.1
	beq.w	.1
	bset	#1,(BA_PS_flags).w
	clr.w	Xvel(a3)
.1									;both x limits checked; now y
	cmpi.w	#$FFDC,(a3)
	bge.w	.2
	tst.w	Xvel(a3)
	bpl.w	.2
	bset	#1,(BA_PS_flags).w
	clr.w	Xvel(a3)
.2									;x inside -36: keep Xvel
	cmpi.w	#$E7,Ypos(a3)
	bgt.w	.4
	cmpi.w	#$FF19,Ypos(a3)
	ble.w	.4
	bra.w	*+4
.3									;in the y band: test whether a3 skates outward
	movem.w	d0-d1,-(sp)
	move.w	Ypos(a3),d0
	move.w	Yvel(a3),d1
	eor.w	d1,d0
	movem.w	(sp)+,d0-d1
	bpl.w	.4
	tst.w	Yvel(a3)
	beq.w	.4
	bset	#1,(BA_PS_flags).w
	clr.w	Yvel(a3)
.4									;stopped at a limit (BA_PS_flags bit 1): no skating this frame
	btst	#1,(BA_PS_flags).w
	bne.w	rtss15
	move.w	(TempWord1).w,d0
	bra.w	doplayeracc
doinput_onetimer					;a3 is set for a one-timer: C (bit 5) starts the one-timer shot, else
									;skate
	move.w	(TempWord1).w,d0
	btst	#pf3onetimer,pflags3(a3)
	bne.w	rtss7
	btst	#5,d1
	beq.w	doplayeracc
	movem.l	d7-a0,-(sp)
	move.w	(lastplayer).w,d7
	asl.w	#7,d7
	movea.l	#SortCords,a0
	adda.w	d7,a0
	tst.w	position(a0)
	movem.l	(sp)+,d7-a0
	beq.w	burst
	movem.w	d7,-(sp)
	move.w	SCnum(a3),d7
	cmp.w	(passReceiverPlayerNum).w,d7
	movem.w	(sp)+,d7
	bne.w	burst
	tst.w	(puckc).w
	bpl.w	burst
	jsr	(PuckOnAttackHalf).l
	beq.w	burst
	move.w	d0,-(sp)
	move.w	d4,(inputjoy).w
	move.w	(joypuckcarrier).w,(TmpJoyPuckCarrier).w
	move.w	#$23,d0					;assonetimer
	jsr	(assreplace).l
	move.w	(sp)+,d0
	rts
doinput_ispc						;a3 has the puck: pass mode, shot mode, or start a pass / shot by the
									;buttons
	bsr.w	checkob
	tst.w	position(a3)
	bne.w	.0
	btst	#pf2aip,pflags2(a3)
	bne.w	rtss15
.0									;goalies without pf2aip go on to pass / shot mode
	btst	#sfspdir,(sflags).w
	bne.w	passmode
	btst	#sfssdir,(sflags).w
	bne.w	ShotMode
	btst	#4,d1
	beq.w	.1
	jsr	(CountButtonPress).l
	bra.w	setpassmode
.1									;bit 4 of d1 clear
	btst	#6,d1
	beq.w	.ahold
	tst.w	d4
	beq.w	.2
	move.b	#$F,(aholdtimer+1).w
	bra.w	.ahold
.2									;d4 = 0
	move.b	#$F,(aholdtimer).w
.ahold								;B hold timer set for this pad
	btst	#6,d3
	beq.w	.arel
	tst.w	d4
	beq.w	.c1
	subq.b	#1,(aholdtimer+1).w
	bpl.w	.4
	move.b	#0,(aholdtimer+1).w
.4									;timer clamped at 0
	tst.b	(aholdtimer+1).w
	bne.w	.arel
	bset	#3,(sflags5).w
	jsr	(setpassmode).l
	bra.w	SetLCmode
.c1									;d4 = 0
	subq.b	#1,(aholdtimer).w
	bpl.w	.6
	move.b	#0,(aholdtimer).w
.6									;timer clamped at 0
	tst.b	(aholdtimer).w
	bne.w	.arel
	bset	#3,(sflags5).w
	jsr	(setpassmode).l
	bra.w	SetLCmode
.arel								;A not held: release starts a pass or a line change
	btst	#6,d3
	bne.w	.8
	btst	#6,d2
	beq.w	.8
	bset	#3,(sflags5).w
	bra.w	setpassmode
.8									;bit 6 of d3 set or bit 6 of d2 clear
	tst.w	position(a3)
	bne.w	.shot
	bra.w	doplayeracc
.shot								;skater: C starts a shot
	btst	#5,d1
	beq.w	doplayeracc
	jsr	(CountButtonPress).l
	bra.w	SetShotMode
doinput_islocked					;a3 is locked in an animation: B (bit 4) changes the controlled player
	move.w	(puckc).w,d5
	cmp.w	SCnum(a3),d5
	beq.w	rtss15
	btst	#4,d1
	beq.w	rtss7
	btst	#6,(sflags5).w
	bne.w	rtss7
	bsr.w	changeplayer
	movem.l	d0/a0,-(sp)
	move.w	(c1playernum).w,d0
	tst.w	d4
	beq.w	.0
	move.w	(c2playernum).w,d0
.0									;player chosen
	tst.w	d0
	bmi.w	.x
	asl.w	#7,d0
	movea.l	#SortCords,a0
	adda.w	d0,a0
	bset	#6,pflags3(a0)
.x									;exit: restore the registers
	movem.l	(sp)+,d0/a0
rtss7								;shared rts for the early exits nearby
	rts
; Find goalie SCnum, store in d0
; If no goalie, store FFFF in d0
getGoalieSCnum						;d0 = SCnum of the goalie in the 6 sort objects
									;up to object d0, -1 if none
	movem.l	d1/a0,-(sp)
	movea.l	#SortCords,a0
	asl.w	#7,d0
	adda.w	d0,a0
	move.w	#5,d1
.loop								;scan the 6 objects down from d0 for the goalie (position 0)
	tst.w	position(a0)
	beq.w	.goalie
	suba.w	#$80,a0
	dbf	d1,.loop
	move.w	#$FFFF,d0
	bra.w	.end
.goalie								;found: d0 = its SCnum
	move.w	SCnum(a0),d0
.end								;exit: restore the registers
	movem.l	(sp)+,d1/a0
	rts
faceoffinput						;controller processing for faceoff
	btst	#6,(sflags5).w
	beq.w	.0
	rts
.0									;bit 6 of sflags5 clear
	move.w	assnum(a3),d4			;move assnum into d4
	cmpi.b	#$17,asslist(a3,d4.w)	;check if afaceoffpl is in asslist at assnum position
	bne.s	rtss7					;exit if this is not a faceoff player
	movea.w	#(fodir1-M68K_RAM),a0	;faceoff direction of puck control variable
	btst	#pfgoal,pflags(a3)		;check which goal shooting on
	beq.w	.2						;branch if bottom goal
	movea.w	#(fodir2-M68K_RAM),a0
.2									;store the faceoff dpad
	move.w	d0,(a0)					;store dpad for faceoff pull
	btst	#pf2aip,pflags2(a3)		;check if anim in progress
	bne.s	rtss7					;exit if anim in progress
	btst	#4,d1					;test for b button press
	beq.w	.1						;branch if pressed
	move.w	#SPAfaceoff,d1
	bset	#pf2aip,pflags2(a3)		;set anim in progress
	bra.w	SetSPA
.1									;bit 4 of d1 clear
	move.w	#SPAfaceoffr,d1			;#SPAfaceoffr anim
	bra.w	SetSPA
fightinput							;controller processing for fighting
	rts								;controller processing for fighting
; initiate line change option if available
SetLCmode							;Initiate line change option if available (abut
									;pressed by the puck carrier)
	tst.w	(OptLine).w
	bne.w	rtss7
	btst	#4,(sflags7).w
	bne.w	rtss7
	bsr.w	loadTeamStruct
	bset	#tmflcm,tmflags(a2)
	bne.w	rtss7
	btst	#3,(sflags5).w
	bne.w	.0
	bclr	#sfspdir,(sflags).w
.0									;clear the shot dir
	bclr	#sfssdir,(sflags).w
	bset	#pf2lcm,pflags2(a3)
SetLCmode2							;a2 = team struct. Draw the line change box
	bsr.w	setlccords				;set screen cords for this teams lc box
	cmpi.w	#$F,(printy).w
	blt.w	.box
	bset	#sf3llcs,(sflags3).w	;flag for lower (on screen) line change
	bra.w	.frame
.box								;printy < $F
	jsr	(box).l
	bsr.w	setlccords
.frame								;draw the frame around the line change box
	bsr.w	Framer
	subq.w	#2,(printy).w
.0									;first row: the three line choices
	addq.w	#1,(printx).w
	moveq	#2,d4
.loop								;d4 = 2..0: one row per button
	move.w	d4,d0					;next row; d4 = row/button number
	bsr.w	getlchoice
	tst.w	d0
	bmi.w	.next					;no line for this button
	btst	#tmflcm,tmflags(a2)
	bne.w	.pr
	cmp.w	tmlcchoice(a2),d4		;box being closed: only the chosen row
	bne.w	.up
	move.w	tmline(a2),d0
.pr									;print the row
	movea.w	#(mesarea-M68K_RAM),a1	;a1 = message area; row letter string
	move.l	#$44120,(a1)			;String length 4, 'A '
	add.b	d4,2(a1)				;'A'-'C'
	bsr.w	print
	move.w	d0,-(sp)
	movea.l	#linelist,a1
	bsr.w	Fprintsmall
	move.w	(sp)+,d0
	bsr.w	linebar
	subq.w	#5,(printx).w
.up									;next row up
	subq.w	#1,(printy).w
.next								;loop the rows
	dbf	d4,.loop					;repeat for the other rows
	movea.l	tmdata(a2),a1			;team name
	adda.w	Teamname(a1),a1
	adda.w	(a1),a1
	addq.w	#2,(printx).w
	bra.w	print
setlccords							;set printx/y to cords for lc box on team a2
	clr.w	d0
	cmpa.w	#(tmstruct-M68K_RAM),a2
	bne.w	.0
	eori.w	#$16,d0
.0									;side chosen
	btst	#gmdir,(gmode).w		;reverse direction: flip to the other end
	beq.w	.noflip
	eori.w	#$16,d0
.noflip								;print at the box
	bsr.w	printz
	String	CC_Font1Pri,$16,0,0
	add.w	d0,(printy).w
	moveq	#2,d0
	bsr.w	getlchoice
	moveq	#6,d1					;3 rows
	tst.w	d0
	bpl.w	.ex
	subq.w	#1,d1					;no third choice: 2 rows
	addq.w	#1,(printy).w
.ex									;set the box size
	moveq	#9,d0
	rts
getlchoice							;d0 = 0-2 (a2 = team)
	movem.l	d1-d2,-(sp)
	move.w	tmsize+tmap(a2),d2
	cmpa.w	#(tmstruct-M68K_RAM),a2
	beq.w	getlchoice2
	move.w	tmap-tmsize(a2),d2
getlchoice2							;add $15 to d0 for each player more or fewer than the other team has on
									;the ice
	sub.w	tmap(a2),d2
	beq.w	.0
	addi.w	#$15,d0
	tst.w	d2
	bmi.w	.0
	addi.w	#$15,d0
.0									;row offset chosen
	move.w	tmline(a2),d1
	add.w	d1,d0
	add.w	d1,d0
	add.w	d1,d0
	lea	.tab(pc),a0
	move.b	0(a0,d0.w),d0
	ext.w	d0
	movem.l	(sp)+,d1-d2
	rts
.tab	dc.b	0
	dc.b	1,2,1,2,0,2,0,1,0,1,2,0,1,2,0,1
	dc.b	2,0,1,2,3,4,$FF,3,4,$FF,3,4,$FF,3,4,$FF
	dc.b	4,3,$FF,3,4,$FF,3,4,$FF,5,6,$FF,5,6,$FF,5
	dc.b	6,$FF,5,6,$FF,5,6,$FF,5,6,$FF,6,5,$FF,$FF
; process input for line changes
; d1 = new button presses
lineinput							;process input for line changes
									;d1 = new button presses
	btst	#3,(sflags5).w
	beq.w	.0
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(passmode).l
	movem.l	(sp)+,d0-d7/a0-a6
.0									;line change check
	move.w	d1,-(sp)
	movea.w	#(tmstruct-M68K_RAM),a2
	btst	#pfteam,pflags(a3)
	beq.w	.2
	adda.w	#tmsize,a2
.2									;team struct chosen
	bclr	#tmflcc,tmflags(a2)		;Flag to start lc mode
	beq.w	.1
	bsr.w	lcfound_close			;close the old box
	bsr.w	SetLCmode2				;start lc mode
.1									;restore d1
	move.w	(sp)+,d1
	clr.w	d2
	btst	#6,d1
	bne.w	lcfound
	addq.w	#1,d2
	btst	#4,d1
	bne.w	lcfound
	addq.w	#1,d2
	btst	#5,d1
	bne.w	lcfound
	btst	#pfjoycon,pflags(a3)
	beq.w	.x
	btst	#pfalock,pflags(a3)
	bne.w	.x
	btst	#pf2fight,pflags2(a3)
	beq.w	doplayeracc				;skate with dpad if not fighting
.x									;exit (also the end of the code above)
	rts
; d2 = choice made 0-2
lcfound								;d2 = choice made 0-2
	move.w	d2,d0
	move.w	d2,tmlcchoice(a2)		;chosen row: the box redraw shows only that row
	bsr.w	getlchoice				;translate choice 0-2 into line number 0-6
	tst.w	d0
	bmi.w	rtss8
	bclr	#pf2lcm,pflags2(a3)		;pf2lcm
	bset	#pfjoycon,pflags(a3)
	bsr.w	loadTeamStruct
	bclr	#tmflcm,tmflags(a2)
	move.w	d0,tmline(a2)
	jsr	(setpersonel).l
lcfound_close						;close lc box
	btst	#sfhor,(sflags).w
	bne.w	rtss
	bsr.w	setlccords
	cmpi.w	#$F,(printy).w
	blt.w	.nollcm
	bclr	#sf3llcs,(sflags3).w
.nollcm								;erase the box
	addq.w	#1,d1					;d1 = 1 and d2 = $7FF tile: erase the box area
	move.w	#$7FF,d2
	bsr.w	eraser
	bra.w	printscores1
; c button press check/speed
burst								;cbut press check/speed. Also entered from check4check burst costs energy
									;$CC (only when line changes are on, OptLine = 0)
	jsr	(getpde).l					;get players energy
	tst.w	(OptLine).w
	bne.w	.0
	subi.w	#$CC,d0
	jsr	(setpde).l					;decrease players energy
	btst	#4,(sflags7).w
	beq.w	.0
	move.w	#$1000,d0
.0									;energy drain for the line time
	lsr.w	#7,d0					;d0 will be $1000 with lines off
									;d0 / 64 will be 20 hex if max energy
	move.w	d0,d1					;energy = speed increase (check violence)
	move.w	facedir(a3),d2			;facedir
	asl.w	#2,d2
	movea.l	#dirtab,a0
	muls.w	0(a0,d2.w),d0
	muls.w	2(a0,d2.w),d1
	add.w	d0,Xvel(a3)				;add to X Vel
	add.w	d1,Yvel(a3)				;add to Y Vel
	bset	#pfalock,pflags(a3)		;lock in this animation
	move.w	#SPAburst,d1
	bra.w	SetSPA
; A button press hold
; CPU hold jumps in at Acheck
;
; a3 = holder
; a0 = player being held
Holdplayer							;abut press hold. a0 = the player this one is
									;assigned to, falls into Acheck
	bset	#pfalock,pflags(a3)		;lock animation
	move.w	#SPAhook,d1				;move anim into d1 - normal hold check
	tst.w	impact(a3)				;check if impact = 0
	beq.w	SetSPA					;set anim if 0
	movea.w	#(SortCords-M68K_RAM),a0	;move SortCord into a0
	move.w	impactp(a3),d0			;move last impact player into d0
	asl.w	#7,d0					;calc offset
	adda.w	d0,a0					;add offset to a0
Acheck								;start SPAhook, or SPAHold if a0 is ahead
	bset	#pfalock,pflags(a3)		;lock animation
	move.w	#SPAhook,d1				;move anim into d1 - normal hold check
	tst.w	impact(a3)				;check if impact = 0
	beq.w	.ex						;branch if 0
	move.w	Ypos(a3),d0				;move Ypos checker into d0
	sub.w	Ypos(a0),d0				;sub Ypos of player
	btst	#pfgoal,pflags(a3)		;check goal checker is shooting at
	beq.w	.air					;jump if bottom
	neg.w	d0						;make d0 negative
.air								;in the air?
	bmi.w	.ex
	move.w	#SPAHold,d1				;set anim - hold check stick in air
.ex									;either way: start the animation in d1
	bra.w	SetSPA
; initialize pass mode
setpassmode							;initialize pass mode
	move.w	facedir(a3),(passdir).w	;facedir, default pass direction
	andi.w	#7,(passdir).w			;Passes first 3 bits of passdir
	btst	#2,(BA_PS_flags).w
	beq.w	.0
	bclr	#2,(gmode2).w
	bset	#5,(BA_PS_flags).w
	bne.w	rtss7
	bclr	#5,(gmode2).w
	move.w	#$64,(passmodetimer).w
.0									;set pass dir mode
	bset	#sfspdir,(sflags).w		;#sfspdir - set pass dir mode
rtss								;shared rts
	rts
; start passing sequence
passmode							;dpad sets passdir until bbut changes
	btst	#4,d2					;has b button changed?
	bne.w	dopass					;yes
	btst	#3,(sflags5).w			;Not in NHL Hockey Source
	bne.w	dopass
	btst	#3,d0					;look for dpad
	bne.s	rtss
	andi.w	#7,d0					;pass first 3 bits of d0
	move.w	d0,(passdir).w			;new pass dir
	bset	#3,d0
dopass								;pass the puck in passdir, to the best teammate there if any
	movem.l	d0-d5/a0-a1,-(sp)
	bclr	#sfspdir,(sflags).w		;#sfspdir
	st	(puckc).w					;player is not puck handler anymore
	move.b	#$10,nopuck(a3)
	move.w	SCnum(a3),(lastplayer).w
	bclr	#3,(sflags5).w			;Not in NHL Hockey Source
	beq.w	.noot
	jsr	(OneTimerTarget).l
	move.w	#$12,(onetimerheight).w
	btst	#2,(sflags6).w
	beq.w	.1
	move.w	#$3A,(onetimerheight).w
.1									;pass to the one timer
	jsr	(OneTimerPass).l
	bra.w	.exit
.noot								;3 was clear
	moveq	#8,d0					;moves 8 into d0
	tst.w	position(a3)			;checks if goalie
	beq.w	.calc					;jump if goalie
.LoadPassAttribForPassStart			;skater: pass speed from passacc
	move.b	passacc(a3),d0			;Passacc
.calc								;d0 = passacc (8 for a goalie)
	asl.w	#2,d0					;d0 = passacc for player, 8 for goalie
	asr.w	#1,d0					;change from NHL Hockey Source,
									;because max passacc can be 30
									;(15 in 92)
	addi.w	#$A0,d0
	move.w	d0,(passspeed).w		;Passspeed = PassAcc (0 to 30 decimal) * 2 + A0 (160 decimal)
	btst	#0,passacc(a3)			;Checks to see if bit 0 in Passacc is 0
	beq.w	.findplayer				;Jumps if 0 (even number)
	asr.w	#4,d0					;divide d0 by 16
	add.w	d0,(passspeed).w		;add d0 to passspeed
.findplayer							;odd passacc: speed + 1/16
	moveq	#-1,d4					;look for closest and best player to pass to
	moveq	#5,d3					;Set total number of players (6 total, set to 5)
	movea.w	#(SortCords-M68K_RAM),a1	;start of the home players' sort objects
	cmpi.w	#6,SCnum(a3)			;compares 6 to SCnum(a3) (current player with puck) to check if
									;player is away team or home team
	blt.w	.0						;Jump if player is Home, continue if Away
	adda.w	#6*SCstruct,a1			;Switch to Away Team Players
	btst	#2,(BA_PS_flags).w
	bne.w	.nopp
.0									;a1 = the passer's team (away +6 objects)
	cmpa.l	a1,a3					;Check to see if passing to self
	beq.w	.next					;skip if this is passing player
	tst.w	position(a1)			;position(a1)
	beq.w	.next					;skip if goalie
	btst	#pf2unav,pflags2(a1)	;check if player is unavailable
	bne.w	.next					;player unavailable
	move.w	(a1),d0					;X Position of receiving player
	sub.w	(puckx).w,d0			;sub puckx from d0
	move.w	Ypos(a1),d1				;Y position of receiving player
	sub.w	(pucky).w,d1			;sub pucky from d1
	movem.w	d0-d1,-(sp)				;push to stack
	bsr.w	vtoa					;get direction of pass in d0
	movem.w	(sp)+,d1-d2				;pop from stack d1 is dX, d2 is dY
	sub.w	(passdir).w,d0			;sub passdir from d0
	andi.w	#7,d0					;pass only lower 3 bits in d0
	asl.b	#5,d0					;Multiply d0 by 32 (224 decimal is max)
	ext.w	d0						;sign extend d0 byte to d0 word
	asl.w	#3,d0					;mult d0 by 8 (700 decimal max)
	muls.w	d0,d0					;square d0 = max is 490000 decimal
	cmp.l	#$10000,d0				;compare to 65536 decimal (#256^2: power, SNASM ^ is xor)
	bhi.w	.next					;if higher branch to next
	muls.w	d1,d1					;square d1 (dX)
	muls.w	d2,d2					;square d2 (dY)
	add.l	d1,d2					;add together
	add.l	d0,d2					;add modified passdir to d2
	cmp.l	d4,d2					;compare d4 to d2
	bhi.w	.next					;branch if higher (player is farther away than the closest player)
	move.l	d2,d4					;move d2 into d4
	movea.l	a1,a0					;move a1 address into a0 (receiving player)
.next								;next teammate
	adda.w	#SCstruct,a1			;Skip to next player (80 hex is length of player struct)
	dbf	d3,.0
	tst.l	d4						;check if there's a player to pass to
	bmi.w	.nopp					;skip if no player to pass to
	bsr.w	passto
	bra.w	.exit
.nopp								;bit 2 of BA_PS_flags set or d4 negative
	move.w	(passdir).w,d0			;just hit puck in pass dir not to any player
	asl.w	#2,d0
	movea.l	#dirtab,a0
	move.w	2(a0,d0.w),d1			;y inc
	muls.w	(passspeed).w,d1
	moveq	#$A,d2
	asl.l	d2,d1
	divs.w	#runspeed*15,d1
	add.w	Yvel(a3),d1				;Yvel
	move.w	d1,(puckvy).w
	move.w	0(a0,d0.w),d1			;X inc
	muls.w	(passspeed).w,d1
	asl.l	d2,d1
	divs.w	#runspeed*15,d1
	add.w	Xvel(a3),d1				;Xvel
	move.w	d1,(puckvx).w
	move.w	#$1000,d0
	bsr.w	randomd0
	move.w	d0,(puckvz).w
.exit								;goalie passes: point the puck up ice
	tst.w	position(a3)			;$34 = position
	bne.w	.notgoalie
	tst.w	(puckvy).w
	btst	#pfgoal,pflags(a3)		;$62 = pflags Checks for what goal team is shooting at (0=bottom, 1=top)
	beq.w	.g0
	bmi.w	.nvy
	bra.w	.notgoalie
.g0									;pfgoal clear
	bmi.w	.notgoalie
.nvy								;goalie shooting at the top net with the puck moving down (or the bottom
									;and up): flip it
	neg.w	(puckvy).w				;negative velocity on puck
.notgoalie							;d0/d1 = puck velocity for the pass animation direction
	move.w	(puckvx).w,d0			;d0/d1 = puck velocity -> direction for the animation (goalie swing,
									;forehand or backhand pass)
	move.w	(puckvy).w,d1
	bsr.w	vtoa
	move.w	#SPAgswing,d1			;SPA = Sprite Animation
	tst.w	position(a3)			;$34 = position
	beq.w	.e1						;goalie anim.
	move.w	#SPApassf,d1
	bsr.w	Findhittype
	beq.w	.e1
	move.w	#SPApassb,d1
.e1									;goalie: swing animation
	bsr.w	SetSPA					;start the pass animation d1
	bset	#pfalock,pflags(a3)		;#pfalock, $62 = pflags
	moveq	#$C,d0					;Rest to rts, not in NHL Hockey Source
									;Used to make puck sound
	sub.b	(puckvz).w,d0
	lsr.w	#2,d0
	andi.w	#3,d0
	addi.w	#$10,d0
	move.w	d0,-(sp)				;#SFXpass
	bsr.w	sfx
	movem.l	(sp)+,d0-d5/a0-a1
	rts
; pass puck to player a0
; a3 = passer
passto								;pass the puck to player a0: a3 = passer
	btst	#pfjoycon,pflags(a3)
	beq.w	passtoa0
	tst.w	position(a3)
	bne.w	passtoa0
	movem.l	d0-d1,-(sp)
	btst	#3,pflags(a0)
	bne.w	.stack
	bset	#6,pflags3(a0)			;pflags3 bit 6
	move.w	(cont1team).w,d1
	cmp.w	(cont2team).w,d1		;checks to see if 2 player co-op (on same team)
	bne.w	.h2hor1p
	move.w	SCnum(a0),d0			;SCnum of receiver into d0
	move.w	SCnum(a3),d1			;SCnum of passer into d1
	cmp.w	(c1playernum).w,d1		;checks if cont 1 controlling passer
	bne.w	.p2passing
	jsr	(setc1player).l
	bra.w	.stack
.p2passing							;d1 <> c1playernum
	jsr	(setc2player).l
	bra.w	.stack
.h2hor1p							;d1 <> cont2team
	move.w	#1,d1
	btst	#pfteam,pflags(a3)		;check if home or away team
	beq.w	.0						;branch if home
	move.w	#2,d1					;away team
.0									;receiver's team pad
	move.w	SCnum(a0),d0			;move SCnum of receiver into d0
	cmp.w	(cont1team).w,d1		;compare cont1 team with d1 (1=home, 2=away)
	bne.w	.diffteam
	jsr	(setc1player).l
	bra.w	.stack
.diffteam							;d1 <> cont1team
	jsr	(setc2player).l
.stack								;pop the d0-d1 saved above
	movem.l	(sp)+,d0-d1
passtoa0							;pass puck to player a0
	bsr.w	loadTeamStruct
	addq.w	#1,tmpasses(a2)			;add 1 to total pass attempts
	move.w	SCnum(a0),(passReceiverPlayerNum).w	;Moves index number for a0 player
	move.w	(passspeed).w,d5		;passspeed = pix/sec
	asr.w	#2,d5					;divides pass speed by 4
	exg	a0,a3						;tell pass recipient to get puck - swaps a3 and a0 for assinsert
	move.l	#$13,d0					;#apassrec - assignment for receiving pass
	bsr.w	assinsert
	exg	a0,a3
	move.l	a0,-(sp)				;This routine uses passspeed and player's a0 x/y speed to determine the
									;x/y velocity of the puck so it will meet player a0
	bsr.w	GetHot					;and player's a0 x/y speed to determine
	add.w	(a0),d0					;Xpos
	sub.w	(puckx).w,d0			;meet player a0
	add.w	Ypos(a0),d1				;Ypos
	sub.w	(pucky).w,d1
	movem.w	d0-d1,-(sp)
	movem.w	(sp),d2-d3				;pop d0-d1 off into d2-d3
	asr.w	#2,d2					;d2 divide by 4
	asr.w	#2,d3					;d3 divide by 4
	move.w	Xvel(a0),d0				;Xvel
	muls.w	#$F0,d0					;#(16 * 60)/4 = $F0 xpix / (1/4) sec
	swap	d0						;swap upper and lower bytes
	move.w	Yvel(a0),d1				;Yvel
	muls.w	#$F0,d1
	swap	d1						;swap upper and lower bytes
	movem.w	d0-d1,-(sp)				;push on stack
	muls.w	d2,d0					;d0 = (d2 = Xpos puck / 4) * d0 (x pix per 1/4 sec)
	muls.w	d3,d1					;d1 = (d3 = Ypos puck /4) * d1 (y pix per 1/4 sec)
	add.w	d1,d0					;add d1 to d0
	asl.w	#1,d0					;d0 mult by 2
	move.w	d0,d4					;j = move d0 into d4
	movem.w	(sp),d0-d1				;pop d0 and d1 off stack
	muls.w	d0,d0					;(x pix per 1/4 sec)^2
	muls.w	d1,d1					;(y pix per 1/4 sec)^2
	muls.w	d5,d5					;passspeed^2
	neg.l	d5						;negative d5
	add.l	d0,d5					;add d0 to d5
	add.l	d1,d5					;k = add d1 to d5
	muls.w	d2,d2
	muls.w	d3,d3
	add.l	d2,d3					;a^2 = add d2 to d3
	muls.w	d5,d3					;multiply k * a^2
	asl.l	#2,d3					;divide by 4
	move.w	d4,d0					;d0 = j
	muls.w	d0,d0					;j^2
	sub.l	d3,d0					;j^2 - ((k*a^2)/4)
	bsr.w	Sroot					;square root of d0
	moveq	#1,d3					;limit infinite loop
	asr.w	#2,d5					;k divide by 4
	bne.w	.0
	moveq	#1,d5					;no div by zero
.0									;k at least 1
	move.w	d0,d2					;d2 = (sqrt(disc) - j) / k = intercept time; dbpl retries with the other
									;root (d0 negated)
	neg.w	d0
	sub.w	d4,d2
	ext.l	d2
	divs.w	d5,d2
	dbpl	d3,.0
	bne.w	.1
	addq.w	#1,d2					;can't be zero
.1									;time to the target, at least 1
	cmp.w	#$18,d2					;limit to 3 sec.
	bls.w	.2
	moveq	#$18,d2					;d2 = time in 1/8 sec to intersection
.2									;time clamped
	move.b	d2,(puckvz).w
	cmp.w	#$C,d2
	blt.w	.3
	move.b	#$C,(puckvz).w
.3									;puckvz clamped
	move.w	d2,d0					;d2 = time (1/8 s): receiver temp1(a0) = d2*8-10
									;(temp1), puck lockout = that - 6
	asl.w	#3,d0
	subi.w	#$A,d0					;only subtract #6 in NHL Hockey
	move.b	d0,temp1(a0)			;$40 = temp1
	subq.w	#6,d0					;sub. #10 in NHL Hockey
	move.b	d0,(puckx_nopuck).w
	movem.w	(sp)+,d0-d1
	muls.w	d2,d0
	asr.l	#1,d0
	add.w	(sp)+,d0				;x distance
	move.w	(puckx).w,temp3(a0)		;receiver target x/y
	add.w	d0,temp3(a0)			;$44 = temp3
	muls.w	d2,d1
	asr.l	#1,d1
	add.w	(sp)+,d1				;y distance
	move.w	(pucky).w,temp4(a0)
	add.w	d1,temp4(a0)			;$46 = temp4
	mulu.w	#$78,d2					;$78 = 60*2
	swap	d0
	divs.w	d2,d0
	move.w	d0,(puckvx).w
	swap	d1
	divs.w	d2,d1
	move.w	d1,(puckvy).w
	rts
; Attributes: thunk
changeplayer						;switch controller d4 (0/2) to the teammate nearest the puck, or sweep
									;check if that is the current player
	jmp	chgplayer
	bne.w	.x
	movem.l	d0-d6/a0-a1,-(sp)
	move.w	(puckvx).w,d0			;lead puck slightly
	asr.w	#8,d0
	add.w	(puckx).w,d0
	move.w	(puckvy).w,d1
	asr.w	#8,d1
	add.w	(pucky).w,d1
	movem.w	d0-d1,-(sp)
	moveq	#5,d2
	move.w	d4,d3
	eori.w	#2,d3					;other controller
	moveq	#-1,d5
	movea.w	#(SortCords-M68K_RAM),a0	;start of search
	movea.w	#(cont1team-M68K_RAM),a1
	cmpi.w	#1,0(a1,d4.w)
	beq.w	.t1
	adda.w	#6*SCstruct,a0
.t1									;a0 = this pad's team (away +6 objects)
	movea.w	#(c1playernum-M68K_RAM),a1
.loop								;scan the teammates for the one nearest the puck
	tst.w	position(a0)			;skip goalie, unavailable and animation-locked players, and the controller
									;current player
	ble.w	.next					;can't switch to goalie
	btst	#pf2unav,pflags2(a0)	;pf2unav
	bne.w	.next					;this player is unavailable for some reason
	btst	#pfjoycon,pflags(a0)
	bne.w	.next
	btst	#2,(BA_PS_flags).w
	beq.w	.0
	movem.l	d0,-(sp)
	move.w	(BA_Sktr_SCnum).w,d0
	cmp.w	SCnum(a0),d0
	movem.l	(sp)+,d0
	beq.w	.0
	movem.l	d0,-(sp)
	move.w	(BA_Goalie_SCnum).w,d0
	cmp.w	SCnum(a0),d0
	movem.l	(sp)+,d0
	bne.w	.next
.0									;check the player
	btst	#5,pflags(a0)
	bne.w	.next					;this player is locked
	movem.w	(sp),d0-d1
	sub.w	(a0),d0
	muls.w	d0,d0
	sub.w	Ypos(a0),d1
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	d5,d0
	bhi.w	.next
	move.w	SCnum(a0),d1
	cmp.w	0(a1,d3.w),d1
	beq.w	.next					;this is current player
	move.l	d0,d5
	move.w	d1,d6
.next								;next teammate
	adda.w	#SCstruct,a0
	dbf	d2,.loop
	addq.w	#4,sp
	pea	(.ex).l
	cmp.w	0(a1,d4.w),d6
	beq.w	Sweepcheck				;player is same so sweep check
	move.w	d6,d0
	tst.w	d4
	beq.w	setc1player
	bra.w	setc2player
.ex									;pop the d0-d6/a0-a1 saved above
	movem.l	(sp)+,d0-d6/a0-a1
.x									;exit (also the end of the code above)
	rts
Sweepcheck							;start sweep check on player a3
	bset	#pfalock,pflags(a3)
	move.w	#SPAsweepchk,d1
	bra.w	SetSPA
; restore old player and switch to new d0 player on cont. 1
setc1player							;restore old player and switch to new d0 player on cont. 1
	cmp.w	(c1playernum).w,d0
	beq.w	.ex
	movem.l	d1/a0-a1,-(sp)
	move.w	(c1playernum).w,d1
	bsr.w	restorepl
	move.w	d0,(c1playernum).w
	movem.l	(sp)+,d1/a0-a1
.ex									;exit (also the end of the code above)
	rts
; restore old player and switch to new d0 player on cont. 2
setc2player							;restore old player and switch to new d0 player on cont. 2
	cmp.w	(c2playernum).w,d0
	beq.w	.ex
	movem.l	d1/a0-a1,-(sp)
	move.w	(c2playernum).w,d1
	bsr.w	restorepl
	move.w	d0,(c2playernum).w
	movem.l	(sp)+,d1/a0-a1
.ex									;exit (also the end of the code above)
	rts
; d1 = old player
restorepl							;restore old joy controlled player d1, give d0 the joystick; a d1 in line
									;change mode keeps control
	movea.w	#(SortCords-M68K_RAM),a0
	tst.w	d1
	blt.w	.spd
	cmp.w	#$B,d1
	bgt.w	.spd
	asl.w	#scsize,d1				;multiply d0 by 80 hex (SCsize)
	btst	#pf2lcm,pflags2(a0,d1.w)	;#pfnp - no joystick pad
	beq.w	.cont
	lsr.w	#7,d1					;divide by 80 hex
	move.w	d1,d0
	rts
.cont								;pf2lcm clear
	bclr	#pfjoycon,pflags(a0,d1.w)	;#pfjoycon
	btst	#3,pflags3(a0,d1.w)		;bit 3, pflags3
	bne.w	.spd
	bset	#pfna,pflags(a0,d1.w)	;#pfna - new assignment
.spd								;d0 = the new player: take the joystick if it is in range
	tst.w	d0						;checks if d0 0 or higher
	blt.w	.ex
	cmp.w	#$B,d0					;checks if d0 11 or less
	bgt.w	.ex
	move.w	d0,d1					;copies d0 into d1
	asl.w	#7,d1
	btst	#2,(BA_PS_flags).w
	bne.w	.chkgoalie
	btst	#0,(gmode2).w
	beq.w	.3
.chkgoalie							;Local: only restorepl uses it, and a global here would split restorepl
	tst.w	position(a0,d1.w)
	bne.w	.3
	btst	#6,pflags(a0,d1.w)		;check if home or away
	beq.w	.0
	tst.w	(goaliemode2).w
	bra.w	.1
.0									;pad 1: goaliemode1 sets the flags
	tst.w	(goaliemode1).w
.1									;no goalie mode: the goalie keeps no joystick
	beq.w	.3
	move.w	#0,d0					;first position of home SCNum
	btst	#6,pflags(a0,d1.w)		;check if home or away
	beq.w	.2
	move.w	#6,d0					;first position of away SCNum
.2									;d0 = first SCnum of the team
	bra.w	.ex
.3									;goalie mode (or a skater): this player gets the joystick
	bset	#pfjoycon,pflags(a0,d1.w)	;set pfjoycon for SCNum
.ex									;exit (also the end of the code above)
	rts
; look for type of swing (forehand or backhand)
; input d0 = launch dir
Findhittype							;look for type of swing (forhand or backhand)
									;input d0 = launch dir
									;ouput beq forhand
	neg.w	d0
	add.w	facedir(a3),d0			;facedir
	andi.w	#7,d0
	btst	#3,attribute(a3)		;attribute bit 3
	beq.w	.1
	btst	d0,#$F0					;%11110000: beq forehand, bne backhand. show btst Dn,#imm
	rts
.1	btst	d0,#$1E					;%00011110
	rts
; initiate shot by player a3
SetShotMode							;initiate shot by player a3
	btst	#2,(BA_PS_flags).w		;check for PS or SO
	beq.w	.start					;branch if not
	bclr	#2,(gmode2).w
	bset	#5,(BA_PS_flags).w
	bne.w	rtss7
	bclr	#5,(gmode2).w
	move.w	#$64,(passmodetimer).w
.start								;start the shot
	move.w	#8,(passdir).w			;default shot direction
	bset	#sfssdir,(sflags).w		;#sfssdir
	clr.w	d0						;find dx/dy for shot
	move.w	#$128,d1				;#296 = top Y boards
	btst	#pfgoal,pflags(a3)		;#pfgoal - which goal to shoot on
	bne.w	.ck0					;branch if top goal
	neg.w	d1						;flip if bottom goal
.ck0								;dx / dy to the goal
	sub.w	(a3),d0					;Sub Xpos of player from d0. d0 starts as 0 (middle of rink in X)
	sub.w	Ypos(a3),d1				;Sub Ypos of player from Y boards
	bsr.w	vtoa
	move.w	#$F,(passspeed).w
	move.w	#SPAshotf,d1
	bsr.s	Findhittype
	beq.w	.ck1
	move.w	#SPAshotb,d1
	move.w	#$F,(passspeed).w		;minimum shot speed
.ck1								;forehand or backhand chosen: start the shot animation
	bra.w	SetSPA
; shot input
ShotMode							;shot input
									;swing frame reached (anim frame 7*4): shoot, else dpad sets shot
									;direction
	cmpi.w	#$1C,SPAnum(a3)
	bge.w	prepshot				;end of animation so shoot
	btst	#3,d0					;checks dpad for direction
	bne.w	.ss0
	andi.w	#7,d0					;pass the first 3 bits of d0
	move.w	d0,(passdir).w			;set shot direction
.ss0								;shot animation check
	cmpi.w	#$10,SPAnum(a3)
	bge.w	.end					;past full windup so no more passspeed
	add.w	d7,(passspeed).w
	cmpi.b	#$14,shotspd(a3)		;6C = shot speed
	bge.w	.checkcbut
	cmpi.w	#8,SPAnum(a3)			;SPANum
	bgt.w	.chganim
.checkcbut							;under full shot speed: check for the C release
	btst	#cbut,d2				;5 = #cbut
	beq.w	.end					;button hasnt changed so continue windup
.chganim							;C released or past the windup: swing through
	neg.w	SPAnum(a3)				;end windup and swing through
	addi.w	#$1C,SPAnum(a3)			;Add to SPANum
.end								;exit (also the end of the code above)
	rts
; Check certain conditions before shooting
prepshot							;check the conditions before a shot: d0 = SCnum of the opposing goalie
									;(getGoalieSCnum)
	bclr	#4,(sflags5).w
	move.w	#$B,d0
	btst	#pfteam,pflags(a3)		;check if home or away
	beq.w	.getGoalie				;gets opponents Goalie SCnum
	move.w	#5,d0					;opponent is home
.getGoalie							;opponent goalie
	jsr	(getGoalieSCnum).l
	tst.w	d0
	bmi.w	.nogoalie
	movem.l	a0,-(sp)
	asl.w	#7,d0
	movea.l	#SortCords,a0
	cmpi.w	#SPAgstackr,SPA(a0,d0.w)	;Checking goalie animations - pad stack right
	beq.w	.svgoalie
	cmpi.w	#SPAgstackl,SPA(a0,d0.w)	;Checking another goalie animation - pad stack left
.svgoalie							;pop the a0 saved above
	movem.l	(sp)+,a0				;pop stack value into a0
	bne.w	.cont
.nogoalie							;no goalie in a save
	cmpi.w	#1,(passdir).w
	ble.w	.dir017					;branch if passdir is 0 or 1
	cmpi.w	#7,(passdir).w
	bne.w	.cont					;branch if passdir is not 7
.dir017								;shooting straight: check the puck Y
	move.w	(pucky).w,d0
	btst	#pfgoal,pflags(a3)		;#pfgoal - goal to shoot at (0=bottom, 1=top)
	bne.w	.cmppuck				;branch if top
	neg.w	d0						;flips d0 for compare calc
.cmppuck							;puck Y for his end
	cmp.w	#$D8,d0					;compares location of puck
	blt.w	.cont
	bset	#4,(sflags5).w			;set flag for in-close top shelf shooting
.cont								;no in-close top shelf flag
	bra.w	*+4
; stick is at puck so launch puck toward goal
; a3 = shooter
doshot								;stick is at puck so launch puck toward goal
	movem.l	d0-d7/a0-a3,-(sp)
	bclr	#4,(gmode2).w
	btst	#pf3break,pflags3(a3)	;check if player on breakaway
	beq.w	.cont
	bset	#4,(gmode2).w			;set if breakaway
.cont								;shot direction adjust
	bsr.w	shotdiradj
	move.w	#SFXshotwiff,-(sp)		;#SFXshotwiff - sound effect
	move.w	SCnum(a3),(shotplayer).w
	bclr	#sfssdir,(sflags).w		;#sfssdir - shot direction mode
	bset	#pfalock,pflags(a3)		;#pfalock
	btst	#pf3onetimer,pflags3(a3)	;check if shooting one timer
	bne.w	.shottype				;jump if yes
	move.w	(puckc).w,d0			;puck carrier SCnum into d0
	cmp.w	SCnum(a3),d0			;is player puck carrier?
	bne.w	.ex						;wiffed shot
.shottype							;shot sound
	move.w	#SFXshotfh,(sp)			;#SFXshotfh
	bset	#sf2shot,(sflags2).w	;#sf2shot - shot was taken
	cmpi.w	#SPAshotb,SPA(a3)
	bne.w	.nbh					;no backhand
	move.w	#SFXshotbh,(sp)			;#SFXshotbh
	move.w	(passspeed).w,d0
	lsr.w	#2,d0					;sub 25% for backhand shots
	sub.w	d0,(passspeed).w
.nbh								;forehand shot or backhand already reduced
	btst	#pf3onetimer,pflags3(a3)	;check if shooting one timer
	beq.w	.cont2					;jump if not
	movem.l	d0-d1,-(sp)				;push d0-d1 on stack
	move.w	#$1F,d0					;1F into d0 - one timer min speed
	move.w	d0,(passspeed).w		;make passspeed start with a higher value
	movem.l	(sp)+,d0-d1				;Pop off stack d0-d1
.cont2								;shot speed
	clr.w	d0
	move.b	shotspd(a3),d0			;6C = shotspd (ShP)
	lsr.b	#1,d0					;divide by 2
	movea.l	a3,a0					;move a3 address into a0
	jsr	(makepde).l					;scale d0 based on energy level
	addi.w	#$14,d0					;add 14 to d0
	mulu.w	(passspeed).w,d0		;shot speed ranged by energy level
	mulu.w	#$5249,d0				;($4000*45)/35
	swap	d0						;swaps the upper and lower words of d0
	move.w	d0,(passspeed).w		;move d0 into passspeed
	btst	#0,shotspd(a3)			;checks if ShP value is even or odd
	beq.w	.even
	asr.w	#4,d0					;divide by 16
	add.w	(passspeed).w,d0		;add passspeed to d0
.even								;odd shotspd: speed + 1/16
	lsr.w	#4,d0					;divide by 16 (d0 is passspeed)
	neg.w	d0						;negative
	addq.w	#3,d0					;add 3 to d0
	bpl.w	.nbh2
	clr.w	d0						;clear if negative
.nbh2								;speed bonus for the sound
	add.w	d0,(sp)					;add to stack current value (Shot SFX)
	st	(puckc).w					;clear puck carrier
	move.b	#$10,nopuck(a3)			;5E = nopuck - no puck collision till 0
	move.w	SCnum(a3),(lastplayer).w	;SCNum
	move.w	#$108,d1				;$108 = top goal line Y position
	btst	#pfgoal,pflags(a3)		;pfgoal, pflags
	bne.w	.0						;branch if shooting up
	neg.w	d1						;flip d1 if shooting down
.0									;aim for the goal line
	move.w	(passdir).w,d2			;passdir into d2
	asl.w	#2,d2					;mult by 4
	lea	shotsets(pc),a0				;table of shot directions
	move.w	0(a0,d2.w),d0			;xoffset
	move.w	2(a0,d2.w),d2			;z offset
	sub.w	(puckx).w,d0
	sub.w	(pucky).w,d1
	movem.w	d0-d2,-(sp)				;push d0-d2(dx,dy,z offset) on stack
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	bsr.w	Sroot
	tst.w	d0						;distance in pix to goal
	bne.w	.1
	addq.w	#1,d0
.1									;distance at least 1
	move.w	d0,d3					;straight line distance from puck to spot aiming for with passdir
	btst	#gmhl,(gmode).w			;check if highlight (always perfect)
	bne.w	.perf
	cmp.w	#$C8,d3					;C8 = 200 decimal
	bhi.w	.notperf				;too far away from perfect shot
	jsr	(ReadGoaliePulled).l		;checks if shooting team's G pulled
	bmi.w	.perf					;perfect shot with pulled goalie
	btst	#0,(gmode2).w			;check if shootout
	bne.w	.perf					;perfect shot in shootout
	moveq	#$10,d0					;start value for ShA calc
	add.b	shotacc(a3),d0			;shotacc(a3)
	bsr.w	randomd0
	cmp.w	#$E,d0					;chance of perfect shot
	bgt.w	.perf					;branch if higher - perfect shot
.notperf							;random miss
	clr.w	d0
	move.b	shotacc(a3),d0			;shotacc(a3)
	lsr.w	#1,d0					;divide by 2
	move.b	d0,-(sp)				;push on stack
	move.w	(passspeed).w,d0		;move passspeed into d0
	lsr.w	#4,d0					;divide by 16
	sub.b	(sp)+,d0				;shotacc(a3) / 2
	addi.b	#$10,d0					;add $10 to d0
	mulu.w	d3,d0					;mult straight line distance with d0
	lsr.w	#6,d0					;shot accuracy adjust - divide by 64
	cmp.w	#$FA,d3					;250 pixels straight line distance
	bhi.w	.chkvalue				;branch if higher
	lsr.w	#1,d0					;extra shot accuracy adjust
.chkvalue							;adjust clamped
	cmp.w	#$88,d0					;compare to $88 (max adj value in X)
	blt.w	.cont3
	move.w	#$88,d0
.cont3								;push the adjust
	move.w	d0,-(sp)				;push adjusting value: 2(sp) / 4(sp) = x / y diff pushed before
	bsr.w	randomd0s				;RNG adj value
	add.w	d0,2(sp)				;add result to x diff
	move.w	(sp),d0					;move adjusting value into d0
	cmp.w	#$3C,d0					;compare to $3C (max adjustment in Y)
	bls.w	.lessx					;branch if less
	moveq	#$3C,d0
	move.w	d0,(sp)
.lessx								;Y adjust clamped
	tst.w	4(sp)
	bpl.w	.ycalc
	lsr.w	#1,d0
.ycalc								;d0 = random adjustment of the y aim
	bsr.w	randomd0s				;RNG adjustment
	add.w	d0,4(sp)				;add to y diff
	move.w	(sp)+,d0				;pop adj value
	lsr.w	#1,d0					;divide by 2
	bsr.w	randomd0				;RNG result
	add.w	d0,4(sp)				;add to Z diff
.perf								;aim set: puck velocity from shot speed and distance
	move.w	(passspeed).w,d2		;shot speed
	muls.w	#$44,d2					;1024/15
	muls.w	(sp)+,d2				;mult by x dist
	divs.w	d3,d2					;divide d2 by straight line distance
	move.w	d2,(puckvx).w			;move into puckvx
	move.w	(passspeed).w,d2
	muls.w	#$44,d2					;1024/15
	muls.w	(sp)+,d2				;mult by y dist
	divs.w	d3,d2					;divide d2 by straight line distance
	move.w	d2,(puckvy).w			;move into puckvy
	move.w	#$8000,d1				;this is the highest negative puckvy possible
	btst	#pfgoal,pflags(a3)		;check direction of shooting net
	beq.w	.2						;branch if bottom goal
	clr.w	d1
.2									;limit puckvy
	eor.w	d2,d1					;EOR - checking to see if exceeding maximum puckvy
	bpl.w	.3						;branch if positive
	move.w	#$3810,(puckvy).w		;move into puckvy
	btst	#pfgoal,pflags(a3)		;check net shooting on
	bne.w	.3						;branch if top
	move.w	#$C7F0,(puckvy).w		;move into puckvy (shooting on bottom net)
.3									;puck height in the goal (pix)
	move.w	(sp)+,d1				;pix height in goal
	beq.w	.ex						;exit if zero
	mulu.w	(passspeed).w,d1
	mulu.w	#$44,d1					;1024/15
	divu.w	d3,d1					;by d3 = distance in pix to goal
	mulu.w	#$B33,d3				;(1024*42)/15
	divu.w	(passspeed).w,d3		;divide by passspeed
	add.w	d1,d3
	cmp.w	#$1800,d3
	bls.w	.noup					;branch if less than
	move.w	#$1800,d3				;set max puckvz
.noup								;puckvz set (capped)
	move.w	d3,(puckvz).w			;move into puckvz
	bclr	#4,(sflags5).w			;check in-close top shelf bit
	beq.w	.ex						;if bit was cleared, exit
	btst	#pf3onetimer,pflags3(a3)	;check if one timer
	bne.w	.ex						;branch if so
	jsr	(puckvzadj).l				;adjust puckvz for top shelf shot
.ex									;play the shot sound and return
	bsr.w	sfx						;play the shot sound
	movem.l	(sp)+,d0-d7/a0-a3
	rts
shotsets	dc.w	0				;shot offsets for each pass direction (x,z word pairs), read by the shot
									;code
	;offsets for different directions on the shot
	;passdir 0(x,z)
	dc.w	$C
	dc.w	$10						;passdir 1
	dc.w	$C
	dc.w	$10						;passdir 2
	dc.w	6
	dc.w	$10						;passdir 3
	dc.w	0
	dc.w	0						;passdir 4
	dc.w	0
	dc.w	$FFF0					;passdir 5
	dc.w	0
	dc.w	$FFF0					;passdir 6
	dc.w	6
	dc.w	$FFF0					;passdir 7
	dc.w	$C
	dc.w	0						;passdir 8
	dc.w	6
; a3 = shooter
; Determines where to shoot for CPU player or on a one timer
shotdiradj							;If the opposing goalie
									;covers the middle of the net, set passdir 2 or 6 to shoot at the open
									;side, else 0. Skipped for computer players (pfjoycon clear)
	btst	#pf3onetimer,pflags3(a3)	;check if shooting one timer
	bne.w	.0						;jump if shooting one timer
	btst	#pfjoycon,pflags(a3)	;pfjoycon - checks if player is joystick controlled
	bne.w	.ex						;exit if joystick
.0									;aim adjust
	moveq	#8,d0
	moveq	#5,d1
	movea.w	#(GoalieStruct-M68K_RAM),a0	;SC Struct start - 80
	btst	#pfteam,pflags(a3)		;pfteam - check if home or away
	bne.w	.loop					;jump if away
	adda.w	#$300,a0				;add 300 to a0 (start on away team)
.loop								;each player of the other team
	adda.w	#$80,a0					;move to next player struct
	tst.w	position(a0)			;check if goalie. Find opponents goalie
	dbeq	d1,.loop
	bne.w	.setpassdir				;branches if no goalie
	move.b	Xvel(a0),d0				;Opponent's G is A0. Move Xvel into d0
	ext.w	d0						;sign extend d0
	asr.w	#1,d0					;divide by 2
	add.w	(a0),d0					;Xpos
	sub.w	(puckx).w,d0			;sub puckx from d0
	move.b	Yvel(a0),d1				;Yvel
	ext.w	d1						;sign extend d1
	asr.w	#1,d1					;divide by 2
	add.w	Ypos(a0),d1				;Ypos
	sub.w	(pucky).w,d1			;sub pucky from d1
	movem.w	d0-d1,-(sp)				;push to stack
	muls.w	d0,d0					;square d0
	muls.w	d1,d1					;square d1
	add.l	d1,d0					;add d1 to d0
	addq.l	#1,d0					;add 1 to d0
	bsr.w	Sroot					;get square root
	move.w	d0,d2					;move result into d2
	movem.w	(sp)+,d0-d1				;pop from stack (distance x and y from G to puck)
	moveq	#$12,d3					;post?
	move.w	#$108,d4				;Goal line
	btst	#pfgoal,pflags(a3)		;check which goal shooting at
	bne.w	.chkposts				;jump if top goal
	neg.w	d4						;negate if bottom goal
.chkposts							;check the posts
	movem.w	d3-d4,-(sp)				;push to stack
	bsr.w	CalcAngleOffset
	move.w	d4,d5
	movem.w	(sp)+,d3-d4				;pop from stack
	neg.w	d3						;negate d3 (other post)
	bsr.w	CalcAngleOffset
	add.w	d5,d4					;add results to d4
	clr.w	d0						;clear d0
	cmp.w	#$2C,d4					;2C - right X edge of crease
	bgt.w	.setpassdir
	cmp.w	#$FFD4,d4				;FFD4 - left X edge of crease
	blt.w	.setpassdir
	btst	#pfgoal,pflags(a3)		;check what net shooting on
	beq.w	.passdir				;branch if bottom
	neg.w	d4						;negate d4
.passdir							;direction from the crease side
	moveq	#2,d0					;move 2 into d0
	tst.w	d4						;check if d4 is 0
	bpl.w	.setpassdir				;branch if positive
	moveq	#6,d0					;move 6 into d0
.setpassdir							;passdir 2 or 6 toward the goalie side, then shootout / penalty shot
									;handling
	move.w	d0,(passdir).w			;will be 0,2,6, or 8 (no goalie)
	btst	#2,(BA_PS_flags).w
	bne.w	.PSorSO					;branch if bit 2 is set
	btst	#0,(gmode2).w			;check if shootout
	beq.w	.ex						;branch if not set
.PSorSO								;penalty shot or shootout: aim direction
	jsr	(PSandSOpassdir).l
.ex									;exit (also the end of the code above)
	rts
; Gets the area with respect to puck location, goalie location, and the post and divides it by the straight
; distance from goalie to puck
;
; d0 = difference in X from G to puck
; d1 = difference in Y from G to puck
; d2 = distance from G to puck (straight line)
; d3 = post X position
; d4 = goalline
;
CalcAngleOffset						;d4 = cross product of goalie vector d0/d1 and post vector d3/d4 (relative
									;to the puck), divided by d2
	sub.w	(puckx).w,d3			;sub puckx from post X
	sub.w	(pucky).w,d4			;sub pucky from goalline
	muls.w	d0,d4					;mult d0 with d4
	muls.w	d1,d3					;mult d1 with d3
	sub.l	d3,d4					;sub d3 from d4
	divs.w	d2,d4					;divide d2 into d4
	rts
; copy info into pad cont so graphics know which player/number
setpads								;Put SCnum of a3 in the d4 nibble of PadControlBits ; d4 = -2 puck
									;carrier, 0 / 2 pads, 4 replay target. Falls into rtss3
	movem.l	d0-d1,-(sp)
	moveq	#2,d0
	add.w	d4,d0
	add.w	d0,d0
	move.w	#$FFF0,d1
	rol.w	d0,d1
	and.w	d1,(PadControlBits).w
	move.w	SCnum(a3),d1
	asl.w	d0,d1
	or.w	d1,(PadControlBits).w
	movem.l	(sp)+,d0-d1
rtss3								;shared rts for the early exits nearby
	rts

check4bench							;check if player a3 should go to bench
	btst	#2,(BA_PS_flags).w
	bne.s	rtss3
	btst	#pfjoycon,pflags(a3)
	bne.s	rtss3
	btst	#pf2pen,pflags2(a3)
	bne.s	rtss3
	tst.b	newpos(a3)
	bpl.w	.0
	tst.b	newpnum(a3)
	bmi.s	rtss3
.0									;a line change is pending (new position, or a new player number)
	move.b	newpnum(a3),d0			;new player number differs from current -> go to the bench; else only
									;change position
	cmp.b	pnum(a3),d0
	beq.w	.samepl					;player should just change positions
	move.w	assnum(a3),d0
	cmpi.b	#$B,asslist(a3,d0.w)	;already going to bench
	beq.s	rtss3
	move.w	SCnum(a3),d0
	cmp.w	(puckc).w,d0
	beq.s	rtss3
	addq.w	#4,sp
	bset	#pf2unav,pflags2(a3)	;set player unavailable (pf2unav)
	clr.w	temp1(a3)
	move.l	#$B,d0					;assbench
	bra.w	assreplace
.samepl								;same player: no trip to the bench, take the new position here
	addq.w	#4,sp					;drop return address (takes over the assignment); apply new position now
	bclr	#pf2unav,pflags2(a3)
	bclr	#pfnc,pflags(a3)
	st	newpnum(a3)
	st	newpos(a3)
	move.w	position(a3),d0
	tst.b	newpos(a3)
	bpl.w	.1
	jmp	Setplass
.1									;newpos set: use it as the position
	move.b	newpos(a3),d0
	ext.w	d0
	move.w	d0,position(a3)
	jmp	Setplass
; player a3 should go to bench

assbench							;player a3 should goto bench
	btst	#pfalock,pflags(a3)
	bne.w	rtss3
	cmpi.w	#$64,temp1(a3)			;temp1 = 100 flag: at the bench door
	beq.w	.done
	bsr.w	check4bench
	btst	#pf2pen,pflags2(a3)		;pf2pen
	bne.w	assexit
	bclr	#pfna,pflags(a3)
	beq.w	.nna
	move.w	#8,temp2(a3)
	moveq	#$50,d0					;80
	btst	#pfteam,pflags(a3)
	bne.w	.0
	neg.w	d0
.0									;d0 = bench y: +80 away, -80 home
	move.w	d0,temp4(a3)
	move.w	#$88,temp3(a3)
	neg.w	temp3(a3)
	subq.w	#8,temp3(a3)			;temp3 = bench x
	clr.w	temp1(a3)
.nna								;every call: same player only changes position; otherwise skate to the
									;bench door
	move.b	newpnum(a3),d0			;same player? just change position
	cmp.b	pnum(a3),d0
	beq.w	.nobench				;same player, just change position
	sub.w	d7,temp1(a3)
	bpl.w	.nodec
	addq.w	#8,temp1(a3)
	move.w	Ypos(a3),d0
	sub.w	temp4(a3),d0
	cmp.w	#$28,d0
	bgt.w	.nodec
	cmp.w	#$FFD8,d0
	blt.w	.nodec
	move.w	(a3),d0
	sub.w	temp3(a3),d0
	cmp.w	#$20,d0
	bgt.w	.nodec
	move.w	#SPAglide,d1
	tst.w	position(a3)
	bne.w	.gli
	move.w	#SPAgready,d1
.gli								;close to the door: glide (goalie: ready) and turn to face the bench
	bsr.w	SetSPA					;glide (goalie: ready) animation
	bset	#pfnc,pflags(a3)
	cmpi.w	#4,facedir(a3)
	beq.w	.ok
	addq.w	#1,facedir(a3)			;turn toward the bench
	andi.w	#7,facedir(a3)
.ok									;facing the bench: slide left, at the door hop the boards (wall animation,
									;door flag 100)
	clr.w	Yvel(a3)
	move.w	#$F800,Xvel(a3)
	cmp.w	#$10,d0
	bgt.w	.x
	clr.w	Xvel(a3)
	cmpi.w	#4,facedir(a3)
	bne.w	.x
	move.w	#$F800,Xvel(a3)
	move.w	#2,facedir(a3)
	move.w	#SPAwallleft,d1
	bsr.w	SetSPA
	bset	#pfalock,pflags(a3)
	move.w	#$64,temp1(a3)			;100
.x									;return; skating continues next call
	rts
.done								;door flag 100: the wall animation is over, swap in the new player
	clr.w	frame(a3)				;at the bench door: mark this roster slot on the bench (tmpdst -2),
									;install the new player (d3)
	clr.w	d0
	move.b	pnum(a3),d0
	add.w	d0,d0
	movea.l	#tmstruct,a0
	btst	#pfteam,pflags(a3)
	beq.w	.t0
	adda.w	#tmsize,a0
.t0									;put him on the bench
	move.w	#$FFFE,tmpdst(a0,d0.w)	;tmpdst: put used player on bench
	move.b	newpnum(a3),d3
	bsr.w	.nobench2
	jmp	setplayer
.nodec								;not at the door yet: keep skating to temp3/temp4 (unless pfnc stops the
									;skating)
	btst	#pfnc,pflags(a3)
	bne.s	.x
	move.w	temp3(a3),d0
	move.w	temp4(a3),d1
	movea.l	#EvadePC,a0
	bra.w	skateto
.nobench							;same player: just take the new position, no bench trip
	bclr	#pf2unav,pflags2(a3)
.nobench2							;local subroutine
	move.b	newpos(a3),d0			;position = newpos; clear newpos and newpnum
	ext.w	d0
	move.w	d0,position(a3)
	jsr	(Setplass).l
	st	newpnum(a3)
	st	newpos(a3)
rtss4								;shared rts for the early exits nearby
	rts
; player a3 should exit bench area
asseben								;Player a3 should exit the bench area
	btst	#pfalock,pflags(a3)
	bne.s	rtss4
	bclr	#pfna,pflags(a3)
	beq.w	.nna
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	move.w	SCnum(a3),d0
	subq.w	#6,d0
	bmi.w	.0
	addq.w	#1,d0
.0									;d0 = bench seat: home SCnum - 6 (negative), away SCnum - 5
	muls.w	#$E,d0
	move.w	d0,Ypos(a3)
	move.w	#$88,(a3)
	neg.w	(a3)
	move.w	#2,facedir(a3)
	bset	#pfalock,pflags(a3)
	move.w	#SPAwallright,d1
	bra.w	SetSPA
.nna								;wall animation over: face the rink and skate out
	move.w	#4,facedir(a3)			;after the wall animation
	bclr	#pfnc,pflags(a3)
	bclr	#pf2npc,pflags2(a3)		;pf2npc
	bclr	#pf2unav,pflags2(a3)	;pf2unav
	clr.w	SPA(a3)
	move.w	#$1000,Xvel(a3)
	bra.w	assexit
; player a3 should go to penalty box
asspenalty							;player a3 should goto penalty box
	btst	#pfalock,pflags(a3)
	bne.s	rtss4
	bclr	#pfna,pflags(a3)
	beq.w	.nna
	bset	#pf2unav,pflags2(a3)	;set player unavailable (pf2unav)
	bsr.w	.clrplayer
	moveq	#-2,d4					;move -2 into d4
	bsr.w	setpads					;moves player number into a temp value so graphics know who it is
	move.w	#8,temp2(a3)			;move 8 into temp2
	moveq	#$B,d0					;move 11 dec into d0
	move.b	(PBnum).w,d1			;gets number of players in PB. 00HV (H=Home, V=Visitors)
	btst	#pfteam,pflags(a3)		;checks if player is home or away
	bne.w	.0						;branch if away
	lsr.w	#4,d1					;shift 4 bits to get Home players in PB
	neg.w	d0						;make d0 negative (different box)
.0									;d0 = box side (-11 home, 11 away), d1 = that team's players in the box
	andi.w	#$F,d1					;pass the first 4 bits of d1 (the team's player total in PB)
	cmp.w	#2,d1					;compare to 2
	bls.w	.1						;branch if less than (1 player in box or less)
	moveq	#2,d1					;add 2 if more than 1 player in box
.1									;seat 3 to 5 by the number of players already in the box
	addq.w	#3,d1					;add 3 to d1
	muls.w	d0,d1					;mult d0 with d1, store result in d1
	move.w	d1,temp4(a3)			;move d1 into temp4 (skateto YPos)
	move.w	#$88,temp3(a3)			;move 136 decimal into temp3 (skateto XPos)
	clr.w	temp1(a3)				;clear temp1
	bset	#pf2npc,pflags2(a3)		;set bit for no player collision
	clr.w	Wallcos(a3)				;clear wallCos (angle of last collision)
	clr.w	Wallsin(a3)				;clear wallSin (angle of last collision)
.nna								;every call: at the box door turn and hop in, else skate on (.st)
	move.w	Ypos(a3),d0				;Current Ypos of player
	sub.w	temp4(a3),d0			;sub temp4 (Y pos to skate to) from Ypos
	cmp.w	#$C,d0					;compare to 13 decimal
	bgt.w	.st						;branch if greater than (still skateto)
	;If its within 13 decimal, it will start the animation for hopping over the board
	cmp.w	#$FFF4,d0
	blt.w	.st
	move.w	(a3),d0
	sub.w	temp3(a3),d0
	cmp.w	#$FFE8,d0
	blt.w	.st
	sub.w	d7,temp1(a3)
	bpl.w	rtss4
	addq.w	#8,temp1(a3)
	bset	#pfnc,pflags(a3)
	move.w	#SPAglide,d1
	bsr.w	SetSPA
	moveq	#6,d2
	tst.b	handed(a3)
	beq.w	.left
	moveq	#2,d2					;left handed: face 2 (right)
.left								;label name is 92G's; the branch is taken by right handed players
									;(handed 0), who keep d2 = 6 (face left); left handed set d2 = 2
									;turn one step a frame: right handed faces 6 (left, away
									;from the box), left handed 2 (right, toward the box).
									;Righty faces 6 (mirrored to frame dir 2), lefty faces 2:
									;both show the same glide frame, the righty x-flipped
	cmp.w	facedir(a3),d2			;turn one step toward d2
	beq.w	.ok
	addq.w	#1,facedir(a3)
	andi.w	#7,facedir(a3)
.ok									;slide into the box; when stopped and facing it, hop the boards and go to
									;assdopen
	clr.w	Yvel(a3)
	move.w	#$1000,Xvel(a3)
	cmp.w	#$FFF8,d0
	blt.w	rtss4
	clr.w	Xvel(a3)
	cmp.w	facedir(a3),d2
	bne.w	rtss4
	bset	#pfalock,pflags(a3)
	move.w	#2,facedir(a3)
	move.w	#SPAwallright,d1
	bsr.w	SetSPA
	bclr	#pf2pen,pflags2(a3)		;pf2pen
	move.l	#$D,d0					;assdopen
	bra.w	assreplace
.st									;not at the box yet: skate to temp3/temp4
	move.w	temp3(a3),d0
	move.w	temp4(a3),d1
	movea.l	#rtss2,a0
	bra.w	skateto
.clrplayer							;take the joystick off player a3
	btst	#pfjoycon,pflags(a3)
	beq.w	rtss4
	clr.w	d4
	move.w	SCnum(a3),d0
	cmp.w	(c1playernum).w,d0
	beq.w	changeplayer
	moveq	#2,d4
	bra.w	changeplayer
; add player a3 to penalty box
assdopen							;add player a3 to penalty box
	btst	#pfalock,pflags(a3)
	bne.w	rtss4
	moveq	#$10,d0
	btst	#pfteam,pflags(a3)
	beq.w	.1
	moveq	#1,d0
.1									;into the box
	add.b	d0,(PBnum).w			;Players in penalty box
	st	position(a3)
	clr.w	frame(a3)
	rts
; player a3 should exit penalty area
assepen								;player a3 should exit penalty area
	btst	#pfalock,pflags(a3)
	bne.w	rtss4
	bclr	#pfna,pflags(a3)
	beq.w	.nna
	bset	#pfnc,pflags(a3)		;set player in no collision mode
	bset	#pf2unav,pflags2(a3)	;set player unavailable
	moveq	#$10,d0
	moveq	#$FFFFFFC4,d1
	btst	#pfteam,pflags(a3)
	beq.w	.0
	moveq	#1,d0
	neg.w	d1
.0									;leave the box
	sub.b	d0,(PBnum).w			;Players in penalty box
	move.w	d1,Ypos(a3)
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	move.w	#$86,(a3)
	move.w	#2,facedir(a3)
	bset	#pfalock,pflags(a3)
	move.w	#SPAwallleft,d1
	bsr.w	SetSPA
	jmp	SprSort
.nna								;pfna was clear
	move.w	#4,facedir(a3)
	st	newpnum(a3)
	st	newpos(a3)
	bclr	#pfjoycon,pflags(a3)
	bclr	#pfnc,pflags(a3)
	bclr	#pf2npc,pflags2(a3)		;pf2npc
	bclr	#pf2unav,pflags2(a3)	;pf2unav
	move.w	#$F000,Xvel(a3)
	bra.w	assexit
; moves the goalie not being used during shootout/pen shot off the screen
; a3 = goalie who is to be taken off ice
assgoaliebreakwait					;asstab entry. In a shootout or penalty shot park the idle goalie off the
									;ice, else exit
	btst	#pfalock,pflags(a3)		;check if animation locked
	bne.w	.exit					;exit if so
	btst	#2,(BA_PS_flags).w		;check if pen shot
	bne.w	.park					;branch if so
	btst	#0,(gmode2).w			;check for shootout
	bne.w	.park					;branch if so
	nop
	bra.w	assexit
.park								;bit 2 of BA_PS_flags set or bit 0 of gmode2 set
	clr.w	Xvel(a3)				;clear Xvel
	clr.w	Yvel(a3)				;clear Yvel
	movem.l	d0/a0,-(sp)				;push d0 and a0 on stack
	movea.l	#SortCords,a0			;Home SC Sctruct start
	move.w	(BA_Goalie_SCnum).w,d0	;move Goalie SCNum into d0
	asl.w	#7,d0					;shift d0 7 bits left
	adda.w	d0,a0					;add d0 to address a0
	move.w	#$191,Ypos(a3)			;move 401 decimal into Ypos
	btst	#7,pflags(a0)			;check if shooting up or down (a0 is goalie being shot on)
	bne.w	.popstack				;branch if shooting up
	move.w	#$FE6F,Ypos(a3)			;move -191 decimal into Ypos (goalie not being shot on)
.popstack							;pop the d0/a0 saved above
	movem.l	(sp)+,d0/a0
.exit								;exit (also the end of the code above)
	rts
; players do nothing until faceoff is over
assfaceoff							;players do nothing until faceoff is over
	btst	#pfalock,pflags(a3)
	bne.w	.exit
	btst	#sf2faceoff,(sflags2).w
	beq.w	assexit
.exit								;exit (also the end of the code above)
	rts
; assignment for players actually participating in faceoff
; a3 = player
assfaceoffpl						;Face off player
	btst	#pfalock,pflags(a3)
	bne.w	.exit2
	btst	#sf2faceoff,(sflags2).w
	beq.w	.exit
	bclr	#pfna,pflags(a3)
	beq.w	.nna
	clr.w	temp1(a3)
.nna								;every call: set the big faceoff sprite frame for this team
	movea.l	#fofdata2,a0			;a0 = fofdata2 (home) or +4 (visitor): big faceoff sprite data
	btst	#pfteam,pflags(a3)
	beq.w	.0
	addq.w	#4,a0
.0									;a0 = this team's big sprite entry (visitor +4)
	move.w	SPAnum(a3),d0			;d0 = SPAnum/4 + 1, +3 for right handed: frame code for the big sprite
	lsr.w	#2,d0
	addq.w	#1,d0
	tst.b	handed(a3)
	bne.w	.lefty
	addq.w	#3,d0
.lefty								;store the frame; computer players also start the faceoff stance once
	move.w	d0,(a0)
	btst	#pfjoycon,pflags(a3)
	bne.w	.exit2
	bset	#pf2aip,pflags2(a3)
	bne.w	.exit2
	move.w	#SPAfaceoff,d1
	cmpi.w	#$10,(SortCords+(puckscnum*SCstruct)+temp1).w
	bls.w	.d
	moveq	#8,d0
	bsr.w	randomd0
	tst.w	d0
	beq.w	.d
	move.w	#SPAfaceoffr,d1
.d									;one in 8 computer centers takes the alternate stance (SPAfaceoffr)
	bset	#pf2aip,pflags2(a3)
	bra.w	SetSPA
.exit								;shared exit of assfaceoffpl
	move.b	#$14,nopuck(a3)
	bra.w	assexit
.exit2								;exit
	rts
assfight							;rts only: there is no fighting
	rts								;assfight - possible location where fighting logic used to be
assfwatch							;rts only: there is no fighting
	rts								;assfwatch - possible location where players watching fight
; player should do nothing
donothing							;player should do nothing
	btst	#pfalock,pflags(a3)		;#pfalock
	bne.s	assfwatch
	btst	#pfjoycon,pflags(a3)	;#pfjoycon
	bne.s	assfwatch
	moveq	#8,d0
	bra.w	doplayeracc
; player skates with stanley cup overhead
assstanley							;player a3 skates with stanley cup overhead
	btst	#pfalock,pflags(a3)
	bne.s	assfwatch
	bclr	#pfna,pflags(a3)
	beq.w	.nna
	move.w	#$5A,temp3(a3)			;90
	tst.w	(Hpos).w
	bpl.w	.0
	neg.w	temp3(a3)
.0									;target Y from Vpos
	move.w	(Vpos).w,temp4(a3)		;temp4 = y from Vpos
	move.w	#SPAstanley,d1
	bsr.w	SetSPA
.nna								;skate toward the target
	move.w	temp3(a3),d0			;face and accelerate toward the target
	sub.w	(a3),d0
	move.w	temp4(a3),d1
	sub.w	Ypos(a3),d1
	bsr.w	vtoa
	cmp.w	#7,d0
	bgt.s	assfwatch
	move.w	d0,d2
	move.w	d2,facedir(a3)
	bra.w	playeracc
; player a3 celebrates, if scoreing player then do arm pump
assscore							;player a3 celebrates, if scoring player then do arm pump
	btst	#pfalock,pflags(a3)
	bne.s	assfwatch
	bclr	#pfna,pflags(a3)
	beq.w	.nna
	bsr.w	.1
	move.w	#8,temp2(a3)
	move.w	#$5A,temp3(a3)
	tst.w	(Hpos).w
	bpl.w	.0
	neg.w	temp3(a3)
.0									;temp4 = Vpos; celebrate where the camera is
	move.w	(Vpos).w,temp4(a3)
.nna								;every call: in a shootout hold the skater until shootoutdelay runs out
	movea.l	#rtss2,a0
	move.w	temp3(a3),d0
	move.w	temp4(a3),d1
	btst	#0,(gmode2).w			;start of new code
	beq.w	.noso
	tst.w	(shootoutdelay).w
	beq.w	.chkx
	subq.w	#1,(shootoutdelay).w
	bne.w	.chkx
	bset	#sf2drec,(sflags2).w
.chkx								;shootout: skater near the middle (x within -$88..$88) stays on the center
									;line
	cmpi.w	#$88,(a3)
	bgt.w	.3
	cmpi.w	#$FF78,(a3)
	bgt.w	.noso
.3									;outside that band: y = 0
	clr.w	d1						;end of new code
.noso								;celebration timer: when it runs out start a new celebrate (pump for the
									;scorer)
	sub.w	d7,temp1(a3)
	bpl.w	.ckcon
	bset	#pfalock,pflags(a3)
	move.w	#SPAcelebrate,d1
	move.w	(shotplayer).w,d0
	cmp.w	SCnum(a3),d0
	bne.w	.nopump
	move.w	#SPApump,d1
.nopump								;shooter or not: set the animation and a new random time
	bsr.w	SetSPA
.1									;local subroutine
	moveq	#$78,d0					;120
	bsr.w	randomd0
	move.w	d0,temp1(a3)
	rts
.ckcon								;timer still running: computer players skate to the spot
	btst	#pfjoycon,pflags(a3)
	beq.w	skateto
rtss6								;shared rts for the early exits nearby
	rts
; player a3 is defensive player on offense
assdefo								;player a3 is defensive player on offense
	btst	#pfalock,pflags(a3)
	bne.s	rtss6
	btst	#gmclock,(gmode).w		;#gmclock
	bne.w	donothing				;Whistle blown, do nothing
	bsr.w	check4bench				;check if player should go to bench
	btst	#pfjoycon,pflags(a3)	;#pfjoycon - is player joystick controlled
	bne.s	rtss6					;yes, then exit
	bclr	#pfna,pflags(a3)		;#pfna - checks if theres a new assignment
	beq.w	.nna
	clr.w	temp1(a3)				;clears temp1 if new assignment
	move.w	#8,temp2(a3)			;moves 8 into temp2 if new assignment
.nna								;count down the timer
	sub.b	d7,temp1(a3)			;subtract frames elapsed since last call from temp1
	bpl.w	.nodec					;temp1 not zero or negative
	move.b	aioff(a3),temp1(a3)		;Loads aioff into temp1
	jsr	(ReadGoaliePulled).l
	bmi.w	.boost					;branch if goalie is pulled
	btst	#6,(sflags7).w			;check if crowd meter broken
	beq.w	.noboost				;branch if not
	tst.b	temp1(a3)				;check if temp1 is 0
	beq.w	.noboost				;branch if so
.boost								;goalie pulled, or crowd meter broken: temp1 one lower (probably a quicker
									;reaction)
	subq.b	#1,temp1(a3)			;sub 1 from temp1
.noboost							;switch to assdefd when offside, then pick the spot by the puck carrier
	move.l	#2,d0					;assdefd
	btst	#tmfoside,tmflags(a2)	;check if team is offsides
	bne.w	assreplace				;if so, assreplace
	move.w	(pucky).w,d1			;move pucky into d1
	btst	#pfgoal,pflags(a3)		;#pfgoal - check which net to score on
	bne.w	.de1					;branch if top
	neg.w	d1						;Negates d1- shooting on bottom net
.de1								;puck Y for his end
	cmp.w	#$5D,d1					;slightly above top blueline - checks Y position of puck
	blt.w	assreplace				;not in offensive zone, change assignment
	move.w	(puckc).w,d1			;puck carrier (SCnum) into d1
	bmi.w	.nodec					;branch if no puckc
	subq.w	#6,d1					;sub 6 from d1
	move.w	SCnum(a3),d2			;move SCnum into d2
	subq.w	#6,d2					;sub 6 from d2
	eor.w	d2,d1					;EOR d2 with d1
	bmi.w	assreplace				;ass replace if puckc not on same team
.nodec								;no carrier or our team has the puck: hold the blue line (x 80 to the side
									;of the position)
	lea	EvadePC(pc),a0				;EvadePC, extra collision routine for skateto
	moveq	#$50,d0					;move 80 dec into d0
	cmpi.w	#2,position(a3)			;position(a3) - checks that player is RD
	beq.w	.1						;branch if RD
	neg.w	d0						;player is LD, so negates d0
.1									;d0 = x for RD (+80) or LD (-80); d1 = just inside the blue line
	move.w	#$62,d1					;just inside of blueline
	btst	#pfgoal,pflags(a3)		;#pfgoal
	bne.w	.0						;branch if top net shooting
	neg.w	d0						;shooting on bottom net, so negate d0 and d1
	neg.w	d1
.0									;coordinates for his end
	move.w	(puckx).w,d2			;move puckx into d2
	eor.w	d0,d2					;XOR d0 with d2
	bmi.w	.2						;branch if puck on the other side of X center
	move.w	(puckx).w,d0			;move puckx to d0
	bra.w	skateto					;d0/d1 are x/y positions, a0 is extra collision routine
.2									;puck on our side of center: move half way toward it
	move.w	(puckx).w,d2			;move puckx into d2
	asr.w	#1,d2					;divide by 2
	add.w	d2,d0					;add d2 to d0
	bra.w	skateto					;skateto routine
; player a3 is defensive player on defense
assdefd								;player a3 is defensive player on defense
	btst	#pfalock,pflags(a3)		;check if locked in animiation
	bne.w	rtss6					;exit if so
	btst	#gmclock,(gmode).w		;check if clock running
	bne.w	donothing				;donothing if no clock
	bsr.w	check4bench				;check if going to bench
	btst	#pfjoycon,pflags(a3)	;check if joystick controlled
	bne.w	rtss6					;exit if so
	bclr	#pfna,pflags(a3)		;clear new assignment bit
	beq.w	.nna					;branch if no new assignment
	clr.w	temp1(a3)				;clear temp1
	move.w	#8,temp2(a3)			;move 8 into temp2
.nna								;count down the timer
	sub.b	d7,temp1(a3)			;sub frames elapsed from temp1
	bpl.w	.nodec					;branch if not 0
	move.b	aidef(a3),temp1(a3)		;move DfA into temp1
	btst	#6,(sflags7).w			;check if crowd meter currently broken
	beq.w	.noboost				;branch if not
	tst.b	temp1(a3)				;check if temp1 is 0
	beq.w	.noboost				;branch if so
	subq.b	#1,temp1(a3)			;sub 1 from temp1
.noboost							;defenseman: shadow the puck, using its y velocity to lead it
	move.w	(pucky).w,d1			;move pucky into d1
	move.w	(puckvy).w,d3			;move puckvy into d3
	asr.w	#6,d3					;divide by 64
	btst	#pfgoal,pflags(a3)		;check which net shooting on
	bne.w	.de00					;branch if top
	neg.w	d1						;negate d1 and d3 if bottom
	neg.w	d3
.de00								;puck Y for his end
	tst.w	d3						;check if d3 is zero
	bpl.w	.de000					;branch if positive
	clr.w	d3						;clear d3
.de000								;look-ahead at least 0
	add.w	d1,d3					;add d1 to d3
	cmp.w	#Blueline,d3			;compare top blueline to d3
	blt.w	.de0
	btst	#tmfoside,tmflags(a2)	;check if team is offsides
	bne.w	.de0					;branch if offsides
	move.w	(puckc).w,d1			;move puckc into d1
	bmi.w	.de0					;branch if no puckc
	bsr.w	chkpk					;check if theres a PK
	beq.w	.de0					;branch if on PK
	move.l	#1,d0					;assdefo into d0
	subq.w	#6,d1					;sub 6 from d1
	move.w	SCnum(a3),d2			;move SCnum into d2
	subq.w	#6,d2					;sub 6 from d2
	eor.w	d2,d1					;EOR d2 and d1
	bpl.w	assreplace				;assreplace if puckc on same team
.de0								;other team has the puck: guard x 65 to our side
	move.w	#$41,temp3(a3)			;move 65 dec into temp3
	cmpi.w	#2,position(a3)			;compare if player is RD
	beq.w	.de1					;branch if RD
	neg.w	temp3(a3)				;negate temp3 if LD
.de1								;a0 = the opposing team's players (home 0-5, away 6-11)
	movea.w	#(SortCords-M68K_RAM),a0	;move SC struct start into a0
	cmpi.w	#6,SCnum(a3)			;compare 6 with player SCnum
	bge.w	.de2					;branch if away team
	adda.w	#6*SCstruct,a0			;add 300 to a0 (start at away SC Struct)
.de2								;find the deepest opponent (d2 = 5..0, start d0 = -1000 or 1000)
	moveq	#5,d2					;move 5 into d2
	move.w	#$FC18,d0				;move -1000 dec into d0
	btst	#pfgoal,pflags(a3)		;check what net shooting at
	beq.w	.gdwn					;branch if bottom net
	neg.w	d0						;negate d0
.gup								;d0 = the smallest opponent y (led by Yvel / 16) when we shoot at the top
									;net
	btst	#pf2unav,pflags2(a0)	;check if a0 player unavailable
	bne.w	.gu0					;branch if so
	tst.w	position(a0)			;check a0 position
	bmi.w	.gu0					;branch if empty position
	move.w	Yvel(a0),d1				;move Yvel of a0 into d1
	bmi.w	.gu2					;branch if Yvel was negative
	clr.w	d1						;clear d1
.gu2								;look-ahead Y (back only)
	asr.w	#4,d1					;divide d1 by 16
	add.w	Ypos(a0),d1				;add Ypos of a0 player to d1
	cmp.w	d0,d1					;compare d0 to d1
	bgt.w	.gu0					;branch if d1 is greater
	move.w	d1,d0					;move d1 into d0
.gu0								;next opponent
	adda.w	#SCstruct,a0			;add 80 (offset to next player struct) to a0
	dbf	d2,.gup						;loop
	subi.w	#$32,d0					;sub $32 (50 dec) from d0
	cmp.w	#$FF42,d0				;compare to $FF42 (-190 dec)
	bgt.w	.gu1					;branch if greater than
	move.w	#$FF24,d0				;move -220 dec into d0
.gu1								;temp4 = guard y; if the puck is across center, stay in the middle (x 0)
	move.w	d0,temp4(a3)			;move d0 into temp4
	move.w	(puckx).w,d0			;move puckx into d0
	move.w	temp3(a3),d1			;move temp3 into d1
	eor.w	d0,d1					;EOR d0 and d1
	bpl.w	.nodec					;branch if puck on same side
	clr.w	temp3(a3)				;clear temp3 if not
	bra.w	.nodec
.gdwn								;pfgoal clear
	btst	#pf2unav,pflags2(a0)	;check if player a0 unavail
	bne.w	.gd0					;branch if so
	tst.w	position(a0)			;check a0 position
	bmi.w	.gd0					;branch if empty (goalie)
	move.w	Yvel(a0),d1				;move Yvel of a0 into d1
	bpl.w	.gd2					;branch if positive
	clr.w	d1						;clear d1
.gd2								;look-ahead Y (forward only)
	asr.w	#4,d1					;divide d1 by 16
	add.w	Ypos(a0),d1				;add Ypos of a0 to d1
	cmp.w	d0,d1					;compare d0 to d1
	blt.w	.gd0					;branch if less than d0
	move.w	d1,d0					;move d1 into d0
.gd0								;next opponent (bottom net: d0 = the largest y)
	adda.w	#SCstruct,a0			;add offset to next player struct
	dbf	d2,.gdwn					;loop
	addi.w	#$32,d0					;add 32 to d0
	cmp.w	#$BE,d0					;compare 190 dec to d0
	blt.w	.gd1					;branch if d0 less than
	move.w	#$DC,d0					;move 220 dec into d0
.gd1								;target Y clamped
	move.w	d0,temp4(a3)			;move d0 into temp4
	neg.w	temp3(a3)				;negate temp3
	move.w	(puckx).w,d0			;move puckx into d0
	move.w	temp3(a3),d1			;move temp3 into d1
	eor.w	d0,d1					;EOR d0 and d1
	bpl.w	.nodec					;branch if puck on same side
	clr.w	temp3(a3)				;clear temp3 if not
.nodec								;skate to the guard spot with collision avoidance, then try a check
	move.w	temp3(a3),d0			;move temp3 to d0
	move.w	temp4(a3),d1			;move temp4 to d1
	movea.l	#EvadePC,a0				;EvadePC to a0
	bsr.w	skateto
	bra.w	check4check
rtss21								;shared rts for the early exits nearby
	rts
; player a3 is winger on defense
asswingd							;player a3 is wing on defense
	btst	#pfalock,pflags(a3)		;check if locked in animation
	bne.s	rtss21					;exit if so
	btst	#gmclock,(gmode).w		;check if clock is running
	bne.w	donothing				;donothing if its stopped
	bsr.w	check4bench				;check if going to bench
	btst	#pfjoycon,pflags(a3)	;check if joystick controlled
	bne.s	rtss21					;exit if so
	bclr	#pfna,pflags(a3)		;clear new assignment bit
	beq.w	.nna					;branch if cleared already (no new assignment)
	clr.w	temp1(a3)				;clear temp1
	move.w	#8,temp2(a3)			;move 8 into temp2
.nna								;count down the timer
	sub.b	d7,temp1(a3)			;sub frames elapsed from temp1
	bpl.w	.nodec					;branch if not 0
	move.b	aidef(a3),temp1(a3)		;move DfA into temp1
	btst	#6,(sflags7).w			;check if crowd meter currently broken
	beq.w	.noboost				;branch if not
	tst.b	temp1(a3)				;check if temp1 is 0
	beq.w	.noboost				;branch if 0
	subq.b	#1,temp1(a3)			;sub 1 from temp1
.noboost							;if our team has the puck, switch to asswingo
	move.w	(puckc).w,d1			;move puckc into d1
	bmi.w	.nodec					;branch if no puck carrier
	move.l	#4,d0					;asswingo into d0
	subq.w	#6,d1					;sub 6 from d1
	move.w	SCnum(a3),d2			;move SCnum into d2
	subq.w	#6,d2					;sub 6 from d2
	eor.w	d2,d1					;EOR d2 with d1. Checks if player on same team
	bpl.w	assreplace				;branch if team has puck
.nodec								;defending: x 100 to the wing side, y below our blue line
	moveq	#$64,d0					;move 64 (100 dec) into d0
	cmpi.w	#5,position(a3)			;check if player is RW
	bne.w	.1						;branch if not
	neg.w	d0						;make d0 negative
.1									;d1 = blue line + 70 for the side we defend
	move.l	#$9E,d1					;move $9E into d1 (blueline + 70 dec)
	btst	#pfgoal,pflags(a3)		;check which goal shooting at
	beq.w	.0						;branch if bottom goal
	neg.w	d0						;negate d0
	neg.w	d1						;negate d1
	moveq	#$FFFFFFB2,d2			;move into d2 (slightly above bottom blue line)
	btst	#tmfoside,tmflags(a2)	;currently offside (tmfoside of the team's tmflags)
									;the home team's (tmstruct) or the away team's
									;(awtmstruct) flags word
	bne.w	.dg11					;branch if set
	cmp.w	(pucky).w,d2			;compare pucky to d2
	bgt.w	.ug1					;branch if puck in defensive zone
	move.w	(pucky).w,d1			;move pucky into d1
	bra.w	.z1
.ug1								;d2 > pucky
	move.w	#$FEF8,d2				;move bottom goal line into d2
	cmp.w	(pucky).w,d2			;compare pucky to d2
	blt.w	.z1						;branch if puck in defensive zone
	move.w	d2,d1					;move d2 into d1 if puck behind goal line
	bra.w	.z1
.0									;pfgoal clear
	moveq	#$4E,d2					;defending top goal
									;4E - slightly below top blue line
	btst	#tmfoside,tmflags(a2)	;currently offside (tmfoside of the team's tmflags)
									;the home team's (tmstruct) or the away team's
									;(awtmstruct) flags word
	bne.w	.dg11					;branch if set
	cmp.w	(pucky).w,d2			;compare pucky to d2
	blt.w	.dg1					;branch if puck in defensive zone
	move.w	(pucky).w,d1			;move pucky into d1
	bra.w	.z1
.dg1								;d2 < pucky
	move.w	#$108,d2				;move top goal line into d2
	cmp.w	(pucky).w,d2			;compare pucky to d2
	bgt.w	.z1						;branch if puck in between goal line and blue line
.dg11								;clamp to the goal line
	move.w	d2,d1					;move d2 into d1 if puck behind goal line
.z1									;puck on the other side of center: hold x; else follow the puck x
	lea	rtss21(pc),a0
	move.w	(puckx).w,d2			;move puckx into d2
	eor.w	d0,d2					;EOR d0 and d2
	bmi.w	skateto					;branch if minus - skate to d0/d1, no extra routine
	move.w	(puckx).w,d0			;move puckx into d0
	bra.w	skateto					;skate to d0/d1 no extra routine
; player a3 is winger on offense

asswingo							;player a3 is winger on offense
	btst	#pfalock,pflags(a3)		;check if locked in animation
	bne.w	rtss21					;exit if so
	btst	#gmclock,(gmode).w		;check game clock
	bne.w	donothing				;donothing if stopped
	bsr.w	check4bench				;check if player going to bench
	btst	#pfjoycon,pflags(a3)	;check if joystick controlled
	bne.w	rtss21					;exit if so
	bclr	#pfna,pflags(a3)		;clear new assignment bit
	beq.w	.nna					;branch if it was already cleared
	st	temp5(a3)					;set old zone # (temp5)
	clr.w	temp1(a3)				;clear temp1
	move.w	#8,temp2(a3)			;move 8 into temp2
.nna								;count down the timer
	sub.b	d7,temp1(a3)			;subtract frames elapsed from temp1
	bpl.w	.nodec					;branch if positive
	move.b	aidef(a3),temp1(a3)		;move DfA into temp1
	btst	#6,(sflags7).w			;check if crowd meter currently broken
	beq.w	.noboost
	tst.b	temp1(a3)				;check if temp1 is 0
	beq.w	.noboost
	subq.b	#1,temp1(a3)			;subtract 1 from temp1
.noboost							;winger on offense: switch to asswingd if the other team has the puck
	move.l	#3,d0					;move asswingd into d0
	move.w	(puckc).w,d1			;move puckc SCnum into d1
	bmi.w	.de0					;branch if no puckc
	subq.w	#6,d1					;sub 6 from d1
	move.w	SCnum(a3),d2			;move SCnum into d2
	subq.w	#6,d2					;sub 6 from d2
	eor.w	d2,d1					;EOR d2 with d1. Checks if puckc on same team
	bmi.w	assreplace				;if not, branch to assreplace
.de0								;puck carrier on his team
	move.w	(pucky).w,d0			;pucky into d0
	move.w	(puckvy).w,d3			;puckvy into d3
	asr.w	#6,d3					;divide d3 by 64
	add.w	d0,d3					;add d0 to d3
	btst	#pfgoal,pflags(a3)		;check which goal shooting on
	bne.w	.de1					;branch if top goal
	neg.w	d0						;negate d0
	neg.w	d3						;negate d3
.de1								;coordinates for his end
	clr.w	d2						;clear zone number
	cmp.w	#$FFA8,d3				;compare bottom blue line with d3
	blt.w	.de2					;branch if in defensive zone
	addq.w	#8,d2					;add 8 to d2 (d2 = 8)
	cmp.w	#$58,d0					;compare top blue line with d0
	blt.w	.de2					;branch if in neutral zone
	btst	#tmfoside,tmflags(a2)	;currently offside (tmfoside of the team's tmflags)
									;(the home team's tmstruct or the away team's awtmstruct)
	bne.w	.de2					;branch if set
	addq.w	#8,d2					;add 8 to d2 (d2 = $10)
	cmp.w	#$108,d3				;compare top goal line with d3
	blt.w	.de2					;branch if in offensive zone
	addq.w	#8,d2					;add 8 to d2 (d2 = $18)
.de2								;d2 = zone index by where the puck is (offensive zone and past the goal
									;line)
	cmp.w	temp5(a3),d2			;compare temp5 with d2
	bne.w	.de3					;branch if different zone
	move.w	(HVcount).l,d0			;move frame counter into d0
	andi.w	#$7F,d0					;pass first 7 bits
	bne.w	.nodec					;branch if not equal to 0 - this allows random
									;movement in zone while waiting
.de3								;new zone (or 1 frame in 128): pick a new random spot from .dedata
	move.w	d2,temp5(a3)			;move d2 into temp5
	lea	.dedata(pc),a0				;move zonedata address into a0
	move.w	2(a0,d2.w),d0			;move X Coord into d0
	bsr.w	randomd0s				;RNG d0
	add.w	0(a0,d2.w),d0			;add X Coord offset to d0
	move.w	d0,temp3(a3)			;move d0 into temp3
	move.w	6(a0,d2.w),d0			;move Y Coord into d0
	bsr.w	randomd0s				;RNG d0
	add.w	4(a0,d2.w),d0			;add Y Coord offset into d0
	move.w	d0,temp4(a3)			;move d0 into temp4
	bra.w	.nodec
.dedata								;x, x random, y, y random
	dc.w	$50						;Skating zones:
									;Defensive zone
	dc.w	$14
	dc.w	$FFBA
	dc.w	$A
	dc.w	$64						;neutral zone
	dc.w	$14
	dc.w	$3A
	dc.w	5
	dc.w	$3C						;offensive zone
	dc.w	$32
	dc.w	$E6
	dc.w	$14
	dc.w	$50						;past goalline
	dc.w	$1E
	dc.w	$FA
	dc.w	$14
.nodec								;skate to the spot; LW mirrors x
	move.w	temp3(a3),d0			;move temp3 into d0
	cmpi.w	#5,position(a3)			;compare 5 (RW) to position
	beq.w	.1						;branch if RW
	neg.w	d0						;negate d0
.1									;d1 = spot y; flip both for the bottom net
	move.w	temp4(a3),d1			;move temp4 into d1
	btst	#pfgoal,pflags(a3)		;check if shooting up or down
	bne.w	.0						;branch if shooting up
	neg.w	d0						;negate d0
	neg.w	d1						;negate d1
.0									;coordinates for his end
	lea	EvadePC(pc),a0				;add EvadePC as aux routine
	bra.w	skateto					;skate to d0/d1 position
rtss11								;shared rts for the early exits nearby
	rts
; player a3 is center on defense
; d7 = elapsed frames
asscenterd							;player a3 is center on defense
	btst	#pfalock,pflags(a3)		;pfalock - locked animation
	bne.s	rtss11					;exit if locked
	btst	#gmclock,(gmode).w		;gmclock - check if clock is running
	bne.w	donothing				;exit if stoppage
	bsr.w	check4bench
	btst	#pfjoycon,pflags(a3)	;pfjoycon - check if joystick controlled
	bne.s	rtss11					;exit if joystick controlled
	bclr	#pfna,pflags(a3)		;pfna - new assignment
	beq.w	.nna					;branch if no new assignment
	clr.w	temp1(a3)				;clear temp1
	move.w	#8,temp2(a3)			;move 8 into temp2
.nna								;count down the timer
	sub.b	d7,temp1(a3)			;subtract d7 from temp1
	bpl.w	.nodec
	move.b	aidef(a3),temp1(a3)		;move aidef into temp1
	btst	#6,(sflags7).w			;check for crowd record flag
	beq.w	.puckcarrier			;jump if not set
	tst.b	temp1(a3)				;check if 0
	beq.w	.puckcarrier
	subq.b	#1,temp1(a3)			;subtract 1 from temp1
.puckcarrier						;center on defense: switch to asscentero if our team has the puck
	move.w	(puckc).w,d1			;move puck carrier SCnum into d1
	bmi.w	.nodec
	move.l	#6,d0					;asscentero
	subq.w	#6,d1					;subtract 6 from d1
	move.w	SCnum(a3),d2			;move player's SCnum into d2
	subq.w	#6,d2					;subtract 6 from d2
	eor.w	d2,d1					;compare d2 and d1
	bpl.w	assreplace				;if team has puck, replace assignment with acentero
.nodec								;no carrier or the other team has it: cover between the puck and our net
	move.w	(puckx).w,d0			;Xpos of puck
	asr.w	#1,d0					;divide by 2
	move.w	(pucky).w,d2			;Ypos of puck
	btst	#pfgoal,pflags(a3)		;pfgoal - check which net to shoot on
	bne.w	.1						;branch if top net
	neg.w	d2						;negate d2 if shooting on bottom net
.1									;X for his end
	moveq	#$FFFFFF80,d1			;-128 - own high slot
	cmp.w	#$FFA8,d2				;-88 - own blue line
	blt.w	.chkgoal				;branch if puck in defensive zone
	add.w	(pucky).w,d1			;add pucky position to d1
	asr.w	#1,d1					;divide by 2
.chkgoal							;puck in our zone: use its y as is
	btst	#pfgoal,pflags(a3)		;pfgoal - check which net to shoot at
	bne.w	.z1						;branch if top net
	neg.w	d1						;shooting at bottom net
.z1									;Y for his end
	lea	rtss11(pc),a0				;no extra collision routine
	bra.w	skateto					;d0/d1 - x/y coord for skating to
; player a3 is center on offense
asscentero							;player a3 is center on offense
	btst	#pfalock,pflags(a3)		;pfalock
	bne.w	rtss11					;exit if anim locked
	btst	#gmclock,(gmode).w		;#gmclock
	bne.w	donothing				;do nothing
	bsr.w	check4bench
	btst	#pfjoycon,pflags(a3)	;pfjoycon - check if joystick controlled
	bne.w	rtss11					;exit if controlled
	bclr	#pfna,pflags(a3)		;clear pfna
	beq.w	.nna
	st	temp5(a3)					;old zone number - temp5
	clr.w	temp1(a3)				;clear temp1
	move.w	#8,temp2(a3)			;move 8 into temp2
.nna								;count down the timer
	sub.b	d7,temp1(a3)			;subtract d7 from temp1 (d7 = elapsed frames)
	bpl.w	.nodec					;branch if temp1 not zero or neg
	move.b	aidef(a3),temp1(a3)		;move aidef into temp1
	btst	#6,(sflags7).w			;check if crowd record broken
	beq.w	.noboost
	tst.b	temp1(a3)				;check if temp1 is 0
	beq.w	.noboost
	subq.b	#1,temp1(a3)			;sub 1 from temp1
.noboost							;center on offense: switch to asscenterd if the other team has the puck
	move.w	(puckc).w,d1			;move puck carrier SCnum into d1
	bmi.w	.de0
	move.l	#5,d0					;asscenterd
	subq.w	#6,d1
	move.w	SCnum(a3),d2			;move SCnum into d2
	subq.w	#6,d2
	eor.w	d2,d1					;checks to see if puck carrier is on team
	bmi.w	assreplace				;if not switch to acenterd
.de0								;puck carrier on his team
	move.w	(pucky).w,d0			;pucky in d0
	btst	#pfgoal,pflags(a3)		;#pfgoal - check what goal shooting on
	bne.w	.de1					;branch if top
	neg.w	d0						;negate if bottom net
.de1								;coordinates for his end
	clr.w	d2						;d2 = zone number
	cmp.w	#$FFA8,d0				;check if own blue line
	blt.w	.de2					;branch if in def zone
	addq.w	#8,d2					;set zone to 8
	cmp.w	#$58,d0					;check opponents blue line
	blt.w	.de2					;branch if in neutral zone
	btst	#tmfoside,tmflags(a2)	;Checks if currently offside
									;the home team's (tmstruct) or the away team's
									;(awtmstruct) flags word
	bne.w	.de2					;branch if offside
	addq.w	#8,d2
	cmp.w	#$108,d0				;check opponents goal line
	blt.w	.de2					;branch if in offensive zone
	addq.w	#8,d2					;add if past goal line
.de2								;d2 = zone index by where the puck is
	cmp.w	temp5(a3),d2			;compare temp5 to d2
	bne.w	.de3
	move.w	(HVcount).l,d0			;move frame counter into d0.
									;This allows a chance for random movement in zone when waiting
	andi.w	#$7F,d0					;pass bottom 7 bits
	bne.w	.nodec
.de3								;new zone (or 1 frame in 128): pick a new random spot from .dedata
	move.w	d2,temp5(a3)			;move zone into temp5
	lea	.dedata(pc),a0
	move.w	2(a0,d2.w),d0			;move zone into d0
	bsr.w	randomd0s				;randomize d0
	add.w	0(a0,d2.w),d0			;add to d0
	move.w	d0,temp3(a3)			;move into temp3 (X coord)
	move.w	6(a0,d2.w),d0			;move into d0
	bsr.w	randomd0s				;randomize d0
	add.w	4(a0,d2.w),d0			;add into d0
	move.w	d0,temp4(a3)			;move into temp4 (Y coord)
	bra.w	.nodec
.dedata								;x, x random, y, y random per zone
	dc.w	0						;Skating Zones
									;puck location = defensive zone
	dc.w	$3C
	dc.w	$FFBA
	dc.w	$A
	dc.w	0						;neutral zone
	dc.w	$3C
	dc.w	$3C
	dc.w	$A
	dc.w	0						;offensive zone
	dc.w	$28
	dc.w	$AA
	dc.w	$1E
	dc.w	0						;below offensive goal line
	dc.w	$50
	dc.w	$AA
	dc.w	$14
.nodec								;skate to the spot, mirrored for the bottom net
	move.w	temp3(a3),d0			;move temp3 into d0 (x coord to skate to)
	move.w	temp4(a3),d1			;move temp4 into d1 (y coord to skate to)
	btst	#pfgoal,pflags(a3)		;pfgoal
	bne.w	.0						;branch if top
	neg.w	d1						;negate if bottom
.0									;Y for his end
	lea	EvadePC(pc),a0
	bra.w	skateto
; joypad controlled goalie control
; a3 = goalie
assgoaliectrl						;joypad controlled goalie control: a3 = goalie; a goalie not on the
									;joystick leaves through assexit
	btst	#pfjoycon,pflags(a3)	;is player joystick controlled?
	bne.w	.goaliectrl				;branch is so
	bra.w	assexit
.goaliectrl							;pfjoycon set
	btst	#pfna,pflags(a3)		;check if new assignment
	bne.w	.na						;branch if new assignment
	movem.w	d0-d1,-(sp)				;push to stack
	move.w	(a3),d0					;Xpos
	move.w	Ypos(a3),d1				;Ypos
	cmp.w	#$AA,d1					;compare $AA to Ypos
	bgt.w	.cont
	cmp.w	#$FF56,d1				;check -$AA to Ypos
	blt.w	.cont					;branch if less than
	btst	#gmclock,(gmode).w		;check if clock stopped
	bne.w	.cont					;branch if so
	move.w	d0,-(sp)				;push to stack
	move.w	#8,d0					;clock stoppage due to goalie out of range
	jsr	(AddPenalty2).l
	move.w	(sp)+,d0				;pop from stack
.cont								;goalie on the joystick: clear control when far from the screen center
	sub.w	(Hpos).w,d0				;sub ice rink horiz position from Xpos
	sub.w	(Vpos).w,d1				;sub ice rink vert position from Ypos
	bclr	#pf3gctrl,pflags3(a3)	;clear goalie control bit?
	cmp.w	#$74,d0					;compare $74 to Xpos diff
	blt.w	.0						;branch if less than
	bset	#pf3gctrl,pflags3(a3)	;set goalie control bit?
	bra.w	.cont2
.0									;d0 < $74
	cmp.w	#$FF8C,d0				;compare -$74 to Xpos diff
	bgt.w	.1						;branch if greater than
	bset	#pf3gctrl,pflags3(a3)	;set goalie control bit?
	bra.w	.cont2
.1									;x on screen: check y
	cmp.w	#$64,d1					;compare $64 to Ypos diff
	blt.w	.2						;branch if less than
	bset	#pf3gctrl,pflags3(a3)	;set goalie control bit?
	bra.w	.cont2
.2									;d1 < $64
	cmp.w	#$FF9C,d1				;compare -$64 to Ypos diff
	bgt.w	.cont2					;branch if greater than
	bset	#pf3gctrl,pflags3(a3)	;set goalie control bit?
.cont2								;pop the d0-d1 saved above
	movem.w	(sp)+,d0-d1				;pop from stack
	btst	#pf3gctrl,pflags3(a3)	;check goalie ctrl bit
	bne.w	checkanim				;branch if set
.na									;no new assignment
	btst	#pfalock,pflags(a3)		;check if anim lock
	bne.w	rtss2					;exit if so
	bsr.w	check4bench
	bclr	#pfna,pflags(a3)		;clear new assignment bit
	beq.w	.nna					;branch if already cleared
	clr.w	temp1(a3)				;clear temp1
	move.w	#8,temp2(a3)			;move 8 into temp2
	st	temp4(a3)					;FFFF to temp4
.nna								;count down the timer
	btst	#pf2aip,pflags2(a3)		;check if anim in progress
	bne.w	rtss2					;exit if so
	btst	#gmclock,(gmode).w		;check if clock stopped
	bne.w	rtss2					;exit if so
	tst.w	temp5(a3)				;test temp5
	bmi.w	.nofo					;branch if less than 0
	move.w	SCnum(a3),d0			;move SCnum into d0
	cmp.w	(puckc).w,d0			;check if puckc is goalie
	beq.w	.mbfo					;branch if equal
	st	temp5(a3)					;set temp5 to -1
	bra.w	.nofo
.mbfo								;d0 = puckc
	sub.w	d7,temp5(a3)			;subtract d7(frames elapsed) from temp5
	bpl.w	.nofo					;branch if more than 0
	btst	#2,(BA_PS_flags).w		;check bit 2
	beq.w	.stoppage				;branch if not set
	bset	#4,(BA_PS_flags).w
	bra.w	.nofo
.stoppage							;bit 2 of BA_PS_flags clear
	move.l	#8,d0
	bsr.w	AddPenalty2
.nofo								;no faceoff needed: count down the reaction timer (defensive awareness)
	sub.b	d7,temp1(a3)			;sub d7(frames elapsed) from temp1
	bpl.w	.ex						;branch if positive
	move.b	aidef(a3),d0			;DfA into d0
	beq.w	.3						;branch if value was 0
	btst	#6,(sflags7).w			;check if crowd meter broken
	beq.w	.3						;jump if not
	subq.b	#1,d0					;sub 1 from d0
.3									;random check
	lsr.b	#2,d0					;divide by 4
	move.b	d0,temp1(a3)			;move d0 into temp1
	move.w	SCnum(a3),d0			;move SCnum into d0
	cmp.w	(puckc).w,d0			;compare puckc to d0
	beq.w	*+4						;jump to assgoaliecpu if the same
.ex									;exit (also the end of the code above)
	rts
; a3 = goalie
assgoalie							;Player a3 is goalie (92 name; asstab agoalie and assnearest)
assgoaliecpu						;CPU goalie logic (a joypad goalie goes to assgoaliectrl)
	btst	#pfjoycon,pflags(a3)	;is goalie joystick controlled?
	bne.w	assgoaliectrl			;branch if so
checkanim							;Goalie animation check; assgoaliectrl branches here too
	move.w	(puckx).w,(TmpPuckX).w
	btst	#0,(sflags4).w			;test bit 0
	beq.w	.assstart
	btst	#pf2aip,pflags2(a3)		;check if animation in progress
	bne.w	.assstart				;branch if so
	btst	#1,(sflags4).w			;test bit 1
	beq.w	.0						;branch if 0
	btst	#3,(sflags4).w			;test bit 3
	bne.w	.assstart				;branch if set
	cmpi.w	#SPFslamtop,frame(a3)	;compare to alice frame number
	bne.w	.assstart				;branch if not equal
	cmpi.w	#SPFslambot,frame(a3)	;compare to alice frame number
	bne.w	.assstart				;branch if not equal
	bset	#3,(sflags4).w			;set bit 3
	move.w	#SFXcheck,-(sp)			;SFX
	bsr.w	sfx
	bra.w	.assstart				;set bit 3
.0									;bit 1 of sflags4 clear
	movem.w	d0-d1,-(sp)
	move.w	(pucky).w,d0			;pucky to d0
	move.w	Ypos(a3),d1				;move Ypos to d1
	eor.w	d1,d0					;XOR d1 to d0
	movem.w	(sp)+,d0-d1
	bmi.w	.assstart				;branch if d0 is negative
	cmpi.w	#$14,(a3)				;compare 14 to Xpos
	bgt.w	.assstart				;branch if greater
	cmpi.w	#$FFEC,(a3)				;compare -14 to Xpos
	ble.w	.assstart				;branch if less than
	bset	#1,(sflags4).w			;set bit 1
	bclr	#3,(sflags4).w			;clear bit 3
	move.w	#SPAgslamtop,d1			;goalie stick slam after a goal, top net
	btst	#pfgoal,pflags(a3)		;check what goal shooting at
	beq.w	.1						;branch if bottom
	move.w	#SPAgslambot,d1			;bottom net
.1									;slam animation set
	bsr.w	SetSPA					;set animation of d1
	bset	#pf2aip,pflags2(a3)		;set anim in progress
.assstart							;goalie assignment proper: bench check and new assignment setup
	btst	#pfalock,pflags(a3)		;check if locked in animation
	bne.w	rtss2					;exit if so
	bsr.w	check4bench
	bclr	#pfna,pflags(a3)		;clear new assignment
	beq.w	.nna					;jump if it was cleared already
	clr.w	temp1(a3)				;clear temp1
	move.w	#8,temp2(a3)			;move 8 into temp2
	st	temp4(a3)					;set temp5 (FFFF)
.nna								;count down the timer
	cmpi.w	#$34,(a3)				;compare 34 hex with Xpos
	bgt.w	.nna2					;branch if greater
	cmpi.w	#$FFCC,(a3)				;compare -34 hex with Xpos
	blt.w	.nna2					;branch if less than
	cmpi.w	#$10E,Ypos(a3)			;compare 10E with Ypos
	bgt.w	.nna2
	cmpi.w	#$FEF2,Ypos(a3)
	blt.w	.nna2
	cmpi.w	#$D2,Ypos(a3)
	bgt.w	.noskate
	cmpi.w	#$FF2E,Ypos(a3)
	blt.w	.noskate
.nna2								;near the net: skate back to the middle of the crease
	lea	rtss2(pc),a0				;goalie will skate back to middle position
	moveq	#4,d0
	tst.w	(a3)					;test Xpos
	bpl.w	.2						;branch if positive
	neg.w	d0
.2									;set the X offset
	move.w	#$E4,d1
	btst	#pfgoal,pflags(a3)		;check what goal shooting at
	beq.w	skateto					;branch if bottom
	neg.w	d1
	bra.w	skateto
.noskate							;in position: ready stance, facing up or down the ice
	btst	#pf2aip,pflags2(a3)		;check if anim in progress
	bne.w	rtss2					;exit if so
	btst	#0,(sflags4).w			;check bit 0
	beq.w	.noskate3				;branch if not set
	cmpi.w	#SPFslamtop+1,frame(a3)	;check alice frame
	beq.w	.noskate2				;branch if equal
	cmpi.w	#SPFslambot+1,frame(a3)	;check alice frame
	bne.w	.noskate3				;branch if not equal
	move.w	#4,facedir(a3)			;set 4 to facedir - face down
	bra.w	.noskate3
.noskate2							;facing the top net
	move.w	#0,facedir(a3)			;set 0 to facedir - face up
.noskate3							;ready stance; a penalty shot keeps the goalie set
	move.w	#SPAgready,d1
	bsr.w	SetSPA
	btst	#2,(BA_PS_flags).w		;check bit 2
	bne.w	.noskate4				;branch if set
	btst	#gmclock,(gmode).w		;check if clock
	bne.w	rtss2					;exit if clock stopped
.noskate4							;skate to the spot
	tst.w	temp5(a3)				;temp5
	bmi.w	.nofo					;branch if minus
	move.w	SCnum(a3),d0			;move SCnum to d0
	cmp.w	(puckc).w,d0			;check if puckc
	beq.w	.mbfo					;branch if so
	st	temp5(a3)					;set temp5 to FFFF
	bra.w	.nofo
.mbfo								;d0 = puckc
	sub.w	d7,temp5(a3)			;subtract frames from temp5
	bpl.w	.nofo					;branch if positive
	btst	#2,(BA_PS_flags).w		;check if bit 2 set
	beq.w	.mbfo2					;branch if not
	bset	#4,(BA_PS_flags).w		;set bit 4
	bra.w	.nofo
.mbfo2								;bit 2 of BA_PS_flags clear
	move.l	#PenGhold,d0
	bsr.w	AddPenalty2				;blow whistle for FO
.nofo								;no faceoff: count down the reaction timer
	sub.b	d7,temp1(a3)			;sub d7 from temp1
	bpl.w	.nodec					;branch if still positive
	move.b	aidef(a3),d0			;move aidef into d0 (DfA)
	beq.w	.nofo2					;branch if 0
	btst	#6,(sflags7).w			;check if crowd meter broken
	beq.w	.nofo2					;branch if not
	subq.b	#1,d0					;sub from d0
.nofo2								;faceoff odds
	lsr.b	#2,d0					;divide by 4
	move.b	d0,temp1(a3)			;move d0 into temp1
	btst	#pfjoycon,pflags(a3)	;check if joy controlled
	beq.w	.nocontrol				;branch if not
	btst	#pf3gctrl,pflags3(a3)	;check bit 2
	bne.w	.nocontrol				;branch if set
	move.l	#$1D,d0					;assignment assgoaliectrl
	bra.w	assinsert
.nocontrol							;pfjoycon clear or pf3gctrl set
	move.w	(pucky).w,d0			;move pucky into d0
	move.w	Ypos(a3),d1				;move Ypos into d1
	eor.w	d0,d1					;XOR
	bpl.w	.3						;branch if positive
	clr.w	d0
	move.w	#$F4,d2					;move F4 into d2
	btst	#pfgoal,pflags(a3)		;check which net shooting at
	beq.w	.de5					;branch if bottom
	neg.w	d2
	bra.w	.de5
.3									;timer out: count temp4 down to -1
	subq.w	#1,temp4(a3)			;sub 1 from temp4
	bpl.w	.4						;branch if positive
	move.w	#$FFFF,temp4(a3)		;move -1 into temp4
.4									;is the goalie the puck carrier?
	move.w	SCnum(a3),d0			;SCnum into d0
	cmp.w	(puckc).w,d0			;check if puckc
	bne.w	.notpuckc				;branch if not
	tst.w	temp5(a3)				;check temp5
	bpl.w	.5						;branch if positive
	move.w	#$5A,temp5(a3)			;move 5A into temp5
.5									;goalie holding the puck: freeze timer at 90, then pass or whistle
	st	temp4(a3)					;FFFF into temp4
	cmpi.w	#$5A,temp5(a3)			;compare to temp5
	bgt.w	.de1					;branch if greater
	move.w	(HVcount).l,d0
	andi.w	#3,d0					;pass first 2 bits
	bne.w	.de1					;branch if not 0
	moveq	#5,d0
	movea.w	#(SortCords-M68K_RAM),a0
	btst	#pfteam,pflags(a3)		;check home or away
	bne.w	.opploop				;branch if away
	adda.w	#$300,a0
.opploop							;each player of the other team
	btst	#pf2unav,pflags2(a0)	;check if player unavailable
	bne.w	.opploop2				;branch if so
	move.w	(pucky).w,d1			;pucky into d1
	sub.w	Ypos(a0),d1				;sub Ypos a0 from d1
	cmp.w	#$1C,d1					;compare 1C to difference
	bgt.w	.opploop2				;branch if greater
	cmp.w	#$FFE4,d1				;compare -1C
	blt.w	.opploop2				;branch if less than
	move.w	(puckx).w,d1			;puckx into d1
	sub.w	(a0),d1					;sub Xpos a0 from d1
	cmp.w	#$19,d1					;compare 19 to difference
	bgt.w	.opploop2				;branch if greater
	cmp.w	#$FFE7,d1				;compare -19 to diff
	bgt.w	.de1					;branch if greater
.opploop2							;next opponent; none close: look for a pass
	adda.w	#$80,a0					;move to next struct
	dbf	d0,.opploop
	move.w	#1,(threat).w			;dir of threat on puck handler
	bsr.w	chk4pass
	bra.w	.de1
.notpuckc							;d0 <> puckc
	tst.w	temp4(a3)				;check temp4
	bne.w	.de1					;branch if not 0
	tst.w	(puckc).w				;check puckc
	bpl.w	.de1					;branch if there is a puckc
	move.w	(puckx).w,d0
	sub.w	(a3),d0					;sub Xpos
	cmp.w	#$14,d0					;compare 14 to diff
	bgt.w	.de1					;branch if greater
	cmp.w	#$FFEC,d0				;-14
	blt.w	.de1					;branch if less
	move.w	(pucky).w,d1
	cmp.w	#$108,d1				;check goalline
	bgt.w	.de1					;branch if past goalline
	cmp.w	#$FEF8,d1				;check other goalline
	blt.w	.de1					;branch if past
	sub.w	Ypos(a3),d1				;sub Ypos from d1
	cmp.w	#$1E,d1					;compare to 1E
	bgt.w	.de1					;branch if greater
	cmp.w	#$FFE2,d1				;compare to -1E
	blt.w	.de1					;branch if less
	movem.w	d0-d1,-(sp)
	move.w	(puckvx).w,d0
	bpl.w	.6
	neg.w	d0
.6									;|puckvx|
	move.w	(puckvy).w,d1
	bpl.w	.7
	neg.w	d1
.7									;|puckvy|
	add.w	d1,d0					;add puckvx and vy
	cmp.w	#$1000,d0				;compare to 1000
	movem.w	(sp)+,d0-d1
	bgt.w	.de1					;branch if greater
	bsr.w	vtoa
	move.w	d0,facedir(a3)			;d0 into facedir. Goalie will face puck
	move.b	#8,nopuck(a3)			;move 8 to nopuck collision
	move.w	#SPAgdive,d1			;goalie dive anim.
	bsr.w	SetSPA					;set animation
	bset	#pf2aip,pflags2(a3)		;set anim in progress
	addi.w	#$96,(Crowdlevel).w
	rts
.de1								;not holding the puck: play the shot (puckcross at the goal line)
	movea.w	#(puckcross-M68K_RAM),a0	;puckcross = xcord/frames top to bottom for goalies to react to
	move.w	#$104,d3
	btst	#pfgoal,pflags(a3)		;check what net shooting at
	beq.w	.8						;branch if bottom
	addq.w	#4,a0
	neg.w	d3
.8									;coordinates for his end
	cmpi.w	#$104,Ypos(a3)
	bgt.w	.9
	cmpi.w	#$FEFC,Ypos(a3)
	bgt.w	.10
.9									;far from the goal line: stand in the crease middle
	clr.w	d2
	clr.w	d0
	cmpi.w	#$2C,(a3)
	bgt.w	.de5
	cmpi.w	#$FFD4,(a3)
	blt.w	.de5
	move.w	#$88,d0
	tst.w	(a3)
	bpl.w	.de5
	neg.w	d0
	bra.w	.de5
.10									;near the goal line: follow the puck
	tst.w	(puckc).w
	bmi.w	.11
	move.w	SCnum(a3),d0
	cmp.w	(puckc).w,d0
	beq.w	.11
	move.l	a0,-(sp)
	movea.l	#SortCords,a0
	move.w	(puckc).w,d0
	asl.w	#7,d0
	adda.w	d0,a0
	move.w	(puckx).w,d0
	sub.w	(a0),d0
	asr.w	#1,d0
	add.w	(a0),d0
	move.w	d0,(TmpPuckX).w
	movea.l	(sp)+,a0
.11									;target X set
	move.w	(TmpPuckX).w,d0
	move.w	(pucky).w,d1
	bsr.w	ClampYPosition
	bsr.w	vtoa
	bsr.w	AdjustFacingDirection
	move.w	(gameclock).w,d0
	andi.w	#7,d0
	asl.w	#4,d0
	addi.w	#$A0,d0
	cmpi.w	#$DB,(pucky).w
	bgt.w	.12
	cmpi.w	#$FF25,(pucky).w
	bgt.w	.13
.12									;puck outside the zone
	subi.w	#$40,d0
.13									;d0 = lead time (shorter near the ends): where the puck will be
	move.w	d0,d1
	muls.w	(puckvx).w,d0
	swap	d0
	add.w	(TmpPuckX).w,d0
	muls.w	(puckvy).w,d1
	swap	d1
	add.w	(pucky).w,d1
	bsr.w	ClampYPosition
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	#$384,d0
	bhi.w	.far
	movem.w	(sp)+,d0-d1
	bra.w	.near
.far								;d0 > $384
	bsr.w	Sroot
	moveq	#1,d2
	add.w	d0,d2
	moveq	#$12,d4
	btst	#sfssdir,(sflags).w
	beq.w	.15
	addq.w	#8,d4
.15									;pop the d0-d1 saved above
	movem.w	(sp)+,d0-d1
	muls.w	d4,d1
	addq.w	#8,d4
	muls.w	d4,d0
	divs.w	d2,d0
	divs.w	d2,d1
.near								;target set: d2 = goal line; shootouts skip the next test
	add.w	d3,d1
	move.w	d1,d2
	btst	#0,(gmode2).w
	bne.w	.18
	btst	#2,(BA_PS_flags).w
	bne.w	.18
	btst	#sfssdir,(sflags).w
	beq.w	.18
	cmpi.w	#$D0,(pucky).w
	bgt.w	.17
	cmpi.w	#$FF30,(pucky).w
	blt.w	.17
	bra.w	.18
.17									;puck in front of the net: stay in the crease width
	cmpi.w	#$14,(a3)
	bgt.w	.18
	cmpi.w	#$FFEC,(a3)
	blt.w	.18
	btst	#1,(gameclock+1).w
	bne.w	.18
	bra.w	.save
.18									;crossing point near enough: try a save
	cmpi.w	#$22,2(a0)
	bhi.w	.de5
	cmpi.w	#$18,(a0)
	bgt.w	.22
	cmpi.w	#$FFE8,(a0)
	blt.w	.22
	cmpi.w	#$C,2(a0)
	bhi.w	.20
.save								;puck inside the goal lines: save attempt (once, pf2aip)
	cmpi.w	#$108,(pucky).w
	bgt.w	.20
	cmpi.w	#$FEF8,(pucky).w
	blt.w	.20
	bset	#pf2aip,pflags2(a3)
	bne.w	.20
	jsr	(goaliesave).l
.20									;follow the crossing x along the goal line
	move.w	(a0),d0
	cmpi.w	#$FC,(pucky).w
	bgt.w	.21
	cmpi.w	#$FF04,(pucky).w
	bgt.w	.de5
.21									;puck in the zone
	moveq	#$18,d0
	tst.w	(TmpPuckX).w
	bpl.w	.de5
	neg.w	d0
.de5								;d0/d1 = the spot; turn the goalie toward it
	move.w	d2,d1
	movem.w	d0-d1,-(sp)
	move.b	Xvel(a3),d0
	ext.w	d0
	neg.w	d0
	add.w	(sp)+,d0
	sub.w	(a3),d0
	move.b	Yvel(a3),d1
	ext.w	d1
	neg.w	d1
	add.w	(sp)+,d1
	sub.w	Ypos(a3),d1
	cmp.w	#4,d0
	bgt.w	.vt
	cmp.w	#$FFFC,d0
	blt.w	.vt
	cmp.w	#4,d1
	bgt.w	.vt
	cmp.w	#$FFFC,d1
	blt.w	.vt
	clr.w	d0
	clr.w	d1
.vt									;direction to the spot (zero when close)
	bsr.w	vtoa
	move.b	d0,temp2+1(a3)			;move d0 into temp2+1
.nodec								;d2 = wanted direction: accelerate (or stop for 8)
	move.b	temp2+1(a3),d2			;temp2+1
	ext.w	d2
	cmp.w	#7,d2
	ble.w	playeracc
	bra.w	stopna
.22									;nobody has the puck and no icing: follow it
	tst.w	(puckc).w
	bpl.s	.de5
	btst	#ifok,(iflags).w
	bne.s	.de5
	movea.w	#(tmstruct-M68K_RAM),a1
	lea	tmsize(a1),a2
	btst	#pfteam,pflags(a3)
	beq.w	.23
	exg	a1,a2
.23									;team structs chosen
	cmpi.l	#$1324,tmnear(a1)
	blt.w	.de5
	cmpi.l	#$9C4,tmnear(a2)
	blt.w	.de5
	cmpi.w	#$E0,(pucky).w
	bgt.w	.24
	cmpi.w	#$FF20,(pucky).w
	bgt.w	.de5
.24									;puck past the circles
	tst.w	(puckvy).w
	btst	#pfgoal,pflags(a3)
	beq.w	.25
	eori	#8,ccr
.25									;puck direction check
	bmi.w	.de5
	move.w	(puckvx).w,d0
	bpl.w	.26
	neg.w	d0
.26									;|puckvx|
	move.w	(puckvy).w,d1
	bpl.w	.27
	neg.w	d1
.27									;|puckvy|
	cmp.w	d0,d1
	blt.w	.de5
	move.l	#$F,d0					;assignment DD2E?
	bra.w	assinsert
ClampYPosition						;d1 = y clamped to +-$103, minus goal line d3. d0 = 0 if a3 has the puck
	move.w	(puckc).w,d2
	cmp.w	SCnum(a3),d2			;is this player the puck carrier?
	bne.w	.0
	clr.w	d0						;carrier: d0 = 0
.0									;d0 cleared when a3 is the carrier
	cmp.w	#$103,d1				;clamp d1 to the range -$103..$103
	blt.w	.1
	move.w	#$103,d1				;upper limit
.1									;clamp the bottom
	cmp.w	#$FEFD,d1
	bgt.w	.2
	move.w	#$FEFD,d1
.2									;y clamped: minus the goal line
	sub.w	d3,d1
	rts
AdjustFacingDirection				;Turn facedir one step toward direction d0
	move.w	facedir(a3),d1			;facedir
	sub.w	d1,d0					;d0 = wanted - current
	beq.w	rtss2
	neg.w	d0
	andi.w	#4,d0					;bit 2 of (current - wanted) picks the turn sense
	lsr.w	#1,d0
	subq.w	#1,d0					;d0 = +1/-1
	btst	#pfjoycon,pflags(a3)	;pfjoycon
	bne.w	.add
	btst	d1,#$42					;facing 1 or 6
	beq.w	.add					;no: plain single step
	add.w	d0,d1					;step once and test the new facing
	btst	#pfgoal,pflags(a3)		;pfgoal
	bne.w	.dn
	btst	d1,#$83					;0, 1 or 7
	bra.w	.t
.dn	btst	d1,#$38					;3, 4 or 5
.t	beq.w	.set					;new facing not in the mask: keep the step
	neg.w	d0						;in the mask: undo it and turn the other way instead
	add.w	d0,d1
.add	add.w	d0,d1				;apply the step
.set	andi.w	#7,d1				;wrap to 0-7
	move.w	d1,facedir(a3)			;facedir
	rts
; set save animation for goalie depending on puck location
; a3 = goalie
; a0 = puckcross
; d3 = goalline of goalie
goaliesave							;pick the goalie save for a puck crossing the goal line: a0 = puckcross,
									;d3 = goal line of goalie
	move.w	(a0),d0					;puckcross x frames into d0
	sub.w	(a3),d0					;sub goalie Xpos from d0
	move.w	d3,d1					;move goalline into d1
	sub.w	Ypos(a3),d1				;sub goalie Ypos from d1
	bsr.w	vtoa
	sub.w	facedir(a3),d0			;sub facedir from d0
	andi.w	#7,d0					;pass first 3 bits of d0
	move.w	d0,d3					;move d0 into d3
	lsr.w	#2,d0					;divide d0 by 4
	btst	#3,attribute(a3)
	beq.w	.0
	eori.w	#1,d0
.0									;mirrored for flipped goalies; low or high save by the puck height
	cmpi.w	#8,(puckz).w
	bgt.w	.1
	cmpi.w	#$800,(puckvz).w
	bgt.w	.1
	bra.w	.low
.1									;puckz > 8 or puckvz > $800
	movem.l	d0,-(sp)
	move.w	(a3),d0
	sub.w	(a0),d0
	cmp.w	#$10,d0
	bgt.w	.2
	cmp.w	#$FFF0,d0
	blt.w	.2
	movem.l	(sp)+,d0
	addq.w	#6,d0
	bra.w	.done
.2									;pop the d0 saved above
	movem.l	(sp)+,d0
	bra.w	.done
.low								;low save (entry +4) unless the puck is close
	addq.w	#4,d0
	cmpi.w	#8,2(a0)
	bls.w	.9
	cmpi.w	#2,facedir(a3)
	beq.w	.done
	cmpi.w	#6,facedir(a3)
	beq.w	.done
	tst.w	(puckc).w
	bmi.w	.done
	subq.w	#2,d0
	move.w	d1,-(sp)
	move.w	#$1000,d1
	move.w	d1,Xvel(a3)
	ori.w	#1,d0
	btst	#pfgoal,pflags(a3)
	bne.w	.4
	eori.w	#1,d0
.4									;post for his end
	move.w	#$FFFA,d1
	tst.w	Xvel(a3)
	bmi.w	.5
	neg.w	Xvel(a3)
.5									;keep the goalie inside the posts while sliding
	tst.w	(a3)
	bpl.w	.7
	tst.w	Xvel(a3)
	bpl.w	.6
	neg.w	Xvel(a3)
.6									;other post
	move.w	#6,d1
	eori.w	#1,d0
.7									;post set
	add.w	d1,(a3)
	btst	#0,handed(a3)			;check hand of goalie
	beq.w	.8						;Branch if goalie is Full Right
	eori.w	#1,d0
.8									;glove hand flips the side
	move.w	(sp)+,d1
	bra.w	.done
.9									;puck not straight in: save by side
	movem.l	d0,-(sp)
	move.w	(a3),d0
	sub.w	(a0),d0
	cmp.w	#$10,d0
	ble.w	.10
	movem.l	(sp)+,d0
	bra.w	.11
.10									;d0 <= $10
	cmp.w	#$FFF0,d0
	movem.l	(sp)+,d0
	bgt.w	.done
.11									;high on the far side: entry +4
	addq.w	#4,d0
.done								;d1 = the save animation (glove right/left, stick, ...)
	add.w	d0,d0
	lea	.saveanim(pc),a1
	move.w	0(a1,d0.w),d1
	cmp.w	#SPAgglovel,d1
	bne.w	.13
	andi.w	#3,d3
	beq.w	.13
	cmpi.b	#$B,GGSleft(a3)			;goalie glove save left rating 11 or more?
	blt.w	.13						;branch if less than
	move.w	#SPAgglovel2,d1			;reach out glove save
.13									;start the save animation and excite the crowd
	bsr.w	SetSPA
	addi.w	#$96,(Crowdlevel).w
	addi.w	#$A,(CwdExciteLvl).w
	asr.w	Xvel(a3)
	asr.w	Xvel(a3)
	asr.w	Yvel(a3)
	asr.w	Yvel(a3)
	rts
.saveanim							;SPA per save type. Same 10 words as the
									;unreferenced table in the input code
	dc.w	SPAgglover
	;blocker save
	dc.w	SPAgglovel				;glove save
	dc.w	SPAgstackr				;pad stack right
	dc.w	SPAgstackl				;pad stack left
	dc.w	SPAgstickr				;kick save
	dc.w	SPAgstickl				;blocking butterfly save
	dc.w	SPAghighr				;high shoulder save right
	dc.w	SPAghighl				;high shoulder save left
	dc.w	SPAgstick2r				;stick save right
	dc.w	SPAgstick2l				;stick save left
; assignment to have goalie skate to the puck when it is loose
assgoalietopuck						;goalie skates out to a loose puck (inserted by
									;assgoalie)
	btst	#pfjoycon,pflags(a3)	;human controlled goalie: nothing to do
	bne.w	assexit
	btst	#gmclock,(gmode).w		;clock stopped: nothing to do
	bne.w	assexit
	bsr.w	check4bench
	bclr	#pfna,pflags(a3)		;new assignment? (clears the flag)
	beq.w	.0
	clr.w	temp1(a3)
.0									;count down the timer
	sub.b	d7,temp1(a3)			;count the timer down by d7 (elapsed frames)
	bpl.w	.go						;still running: keep skating to the puck
	move.b	aidef(a3),d0			;aidef
	beq.w	.1
	btst	#6,(sflags7).w
	beq.w	.1
	subq.b	#1,d0
.1									;random check
	lsr.b	#2,d0
	move.b	d0,temp1(a3)			;reload timer = defensive rating / 4
	tst.w	(puckc).w
	bpl.w	assexit					;someone has the puck: stay
	tst.w	(puckvy).w				;N = puck y velocity sign
	btst	#pfgoal,pflags(a3)
	beq.w	.dir
	eori	#8,ccr					;flip N for the other goal end
.dir								;direction for his end
	bmi.w	assexit					;puck moving away from this goalie
	movea.w	#(tmstruct-M68K_RAM),a1	;load home team struct into a1
	lea	tmsize(a1),a2				;load away team struct into a2
	btst	#pfteam,pflags(a3)		;check if player is home or away
	beq.w	.t0						;branch if home
	exg	a1,a2						;swap if away
.t0									;team structs chosen
	cmpi.l	#$E10,tmnear(a1)		;each team's nearest distance^2 (tmnear) vs limits
	blt.w	assexit
	cmpi.l	#$640,tmnear(a2)
	blt.w	assexit
.go									;puck close enough and both teams far: skate to it
	bra.w	skatetopuck
breakaway							;puck carrier a3 on a breakaway: beep on a new assignment and check the
									;skating direction toward the net
	bset	#2,(sflags5).w
	bclr	#pfna,pflags(a3)		;pfna - clear new assignment
	beq.w	.nna					;jump if no new assignment
	move.w	#SFXbeep1,-(sp)			;ding SFX
	jsr	(sfx).l
	movem.l	a2,-(sp)				;push a2 on stack
	movea.l	#tmstruct,a2			;move Home Team Struct into a2
	btst	#pfteam,pflags(a3)		;pfteam - check if home or away
	beq.w	.c0						;jump if home
	movea.l	#awtmstruct,a2			;move Away Team Struct into a2
.c0									;team struct chosen
	addq.w	#1,tmBreakaways(a2)		;add one to breakaway attempt
	addi.w	#$14,(CwdExciteLvl).w	;add to CwdExcite
	addi.w	#$C8,(Crowdlevel).w		;add to Crowdlevel
	movem.l	(sp)+,a2
.nna								;count down the timer
	movem.w	d1,-(sp)				;push d1 on stack
	move.w	Ypos(a3),d0				;move Ypos into d0
	move.w	Yvel(a3),d1				;move Yvel into d1
	beq.w	.yvel0					;jump if Yvel = 0
	eor.w	d1,d0					;EOR d1 with d0. d0 will be negative if skating opposite direction of net
.exit								;exit: restore the registers
	movem.w	(sp)+,d1				;pop d1 off stack
	rts
.yvel0								;d1 = 0
	move.w	#$FFFF,d1
	bra.s	.exit
BreakawayOffsidesFlagSet			;On a new assignment clear the offsides and breakaway bits of a3. Behind
									;the goal line or not yet in the attack zone set pf3oside, else end the
									;assignment
	btst	#pfna,pflags(a3)		;check for new assignment
	beq.w	.loadYpos				;branch if no new assignment
	bclr	#pf3oside,pflags3(a3)	;clear player offsides flag
	bclr	#pf3break,pflags3(a3)	;clear player breakaway flag
.loadYpos							;load Ypos
	movem.w	d0-d1/a0,-(sp)
	move.w	#$108,d0				;108 = top goal line Y pos
	move.w	Ypos(a3),d1				;Ypos
	bpl.w	.cmpgoalline			;branch if Ypos is positive
	neg.w	d1						;negate d1
.cmpgoalline						;|Ypos|
	cmp.w	d0,d1					;compare position to top goal line
	bge.w	.nogood					;Branch if above it
	move.w	#$58,d0					;58 = top blue line Y pos
	move.w	Ypos(a3),d1				;Ypos
	btst	#pfgoal,pflags(a3)		;check goal to shoot on (0=bottom, 1=top)
	bne.w	.top					;branch if top goal
	neg.w	d0						;bottom goal, so negate d0
	cmp.w	d1,d0					;compare Ypos to blue line Y
	blt.w	.setoffside				;branch if not in attack zone
	bra.w	.offzone				;branch if in attack zone
.top								;pfgoal set
	cmp.w	d1,d0					;compare Ypos to blue line Y
	blt.w	.offzone				;branch if in offensive zone
.setoffside							;set offside
	bset	#pf3oside,pflags3(a3)	;set offsides flag
	bra.w	.nogood
.offzone							;carrier not offside: check for defenders ahead
	bclr	#pf3oside,pflags3(a3)	;clear offside bit
	beq.w	.nogood					;branch if on the blue line
	movea.l	#SortCords+(11*SCstruct),a0	;loads last SCScruct player struct (Away pos #6)
	move.w	#$B,d0					;B = # of player structs to check (12)
	tst.w	d1						;checks if d1 is negative (determines what zone to check)
	bmi.w	.checkYpos
.checkYpos2							;loop: any skater of the other team ahead of the carrier (top end)?
	cmp.w	Ypos(a0),d1				;compare Ypos of a0 player to d1 (Ypos puckc)
	bge.w	.substruct2				;branch if d1 greater than or equal
	tst.w	position(a0)			;check if goalie
	beq.w	.substruct2				;branch if goalie
	bra.w	.nogood
.substruct2							;next player
	suba.w	#$80,a0
	dbf	d0,.checkYpos2
.setBAbit							;loop
	bset	#pf3break,pflags3(a3)	;set breakaway bit
	move.w	#1,d0					;moves 1 into d0 (used by returned subroutine)
.exit								;exit: restore the registers
	movem.w	(sp)+,d0-d1/a0
	rts
.nogood								;not a breakaway: d0 = 0
	move.w	#0,d0					;move 0 into d0 (used on return to subroutine)
	bra.s	.exit
.checkYpos							;d1 negative
	cmp.w	Ypos(a0),d1				;check Ypos with d1 (d1 = blue line Y)
	ble.w	.substruct
	tst.w	position(a0)			;checks if goalie (who would be below blue line)
	beq.w	.substruct
	bra.s	.nogood
.substruct							;next player (bottom end)
	suba.w	#$80,a0					;subtract SCstruct size (80 hex)
	dbf	d0,.checkYpos
	bra.s	.setBAbit
chkpuckc							;puck carrier a3: check for a breakaway (not in a shootout or penalty
									;shot), else assign asspuckc
	btst	#0,(gmode2).w
	bne.w	.0
	btst	#2,(BA_PS_flags).w
	bne.w	.0
	bsr.w	breakaway
	bpl.w	asspuckc				;currently skating towards net in Y
.0									;penalty shot / shootout path
	bclr	#pf3break,pflags3(a3)	;clear breakaway bit
	move.w	#$10,d0					;asspuckc
	bsr.w	assreplace
asspuckc							;player a3 is puck handler
	bclr	#2,(sflags5).w
	bne.w	.0
	bclr	#pf3break,pflags3(a3)
.0									;check the message timer
	move.w	(puckc).w,d0
	cmp.w	SCnum(a3),d0
	bne.w	assexit
	btst	#2,(BA_PS_flags).w
	beq.w	.1
	cmpi.w	#1,(msgtimer).w
	bgt.w	.x
.1									;breakaway check
	btst	#pf3break,pflags3(a3)
	bne.w	.2
	btst	#2,(BA_PS_flags).w
	bne.w	.2
	jsr	(BreakawayOffsidesFlagSet).l
	beq.w	.2						;branch if breakaway flag not set
	move.w	#$21,d0					;chkpuckc assignment
	bsr.w	assreplace
	bra.w	*+4
.2									;no breakaway: normal puck carrier play
	btst	#pfalock,pflags(a3)
	bne.w	rtss2
	btst	#2,(BA_PS_flags).w
	bne.w	.3
	btst	#gmclock,(gmode).w
	bne.w	donothing
.3									;breakaway check
	btst	#pfjoycon,pflags(a3)
	bne.w	assexit
	bclr	#pfna,pflags(a3)
	beq.w	.7
	btst	#pf3break,pflags3(a3)
	beq.w	.4
	move.w	#SFXbeep1,-(sp)
	jsr	(sfx).l
.4									;breakaway crowd
	btst	#pf3break,pflags3(a3)
	beq.w	.6
	movem.l	a2,-(sp)
	movea.l	#tmstruct,a2
	btst	#pfteam,pflags(a3)
	beq.w	.5
	movea.l	#awtmstruct,a2
.5									;team struct chosen
	addq.w	#1,tmBreakaways(a2)
	addi.w	#$14,(CwdExciteLvl).w
	addi.w	#$C8,(Crowdlevel).w
	movem.l	(sp)+,a2
.6									;breakaway check done
	clr.w	temp1(a3)
	move.w	#8,temp2(a3)
	move.w	(HVcount).l,d0
	andi.w	#3,d0
	move.w	d0,temp3(a3)
.7									;count down the timer
	sub.b	d7,temp1(a3)
	bpl.w	.nodec
	move.b	aioff(a3),temp1(a3)
	jsr	(ReadGoaliePulled).l
	bmi.w	.8
	btst	#6,(sflags7).w
	beq.w	.9
	tst.b	temp1(a3)
	beq.w	.9
.8									;goalie pulled or crowd meter broken: quicker decisions
	subq.b	#1,temp1(a3)
.9									;shootout or penalty shot: the shootout shot check
	btst	#2,(BA_PS_flags).w
	bne.w	.soshot
	btst	#0,(gmode2).w
	bne.w	.soshot
	bsr.w	checkob
	bsr.w	chk4lc
	btst	#0,(gmode2).w
	bne.w	.soshot
	btst	#2,(BA_PS_flags).w
	bne.w	.soshot
	btst	#pf3break,pflags3(a3)
	bne.w	.shot
	move.w	#1,d0
	btst	#pfteam,pflags(a3)
	beq.w	.10
	move.w	#2,d0
.10									;team pad chosen
	cmp.w	(cont1team).w,d0
	beq.w	.shot
	cmp.w	(cont2team).w,d0
	beq.w	.shot
	btst	#1,(Vcount+1).w
	bne.w	.pass
.shot								;shoot check (on a computer pad, every other frame)
	bsr.w	chk4shot
	bra.w	.pass
.soshot								;bit 2 of BA_PS_flags set or bit 0 of gmode2 set
	jsr	(ShootoutShootCheck).l
	bne.w	.nodec
	jsr	(CompShoot).l
.pass								;then the pass check
	bsr.w	chk4pass
.nodec								;skate on toward the target spot (.postab2)
	moveq	#6,d0
	add.w	temp3(a3),d0			;add temp3 to d0
	lea	.postab2(pc),a0
	btst	#sf2offsig,(sflags2).w	;#sf2offsig
	beq.w	.nd1
	move.w	position(a3),d0			;position
.nd1								;position for the offside check
	asl.w	#2,d0
	move.w	2(a0,d0.w),d1
	move.w	0(a0,d0.w),d0
	btst	#2,(BA_PS_flags).w
	bne.w	.path
	btst	#0,(gmode2).w
	beq.w	.15
.path								;skate the shootout path
	jsr	(SkatePath).l
	cmpi.b	#$80,(sopathx).w
	beq.w	.x
.15									;normal skating
	btst	#pfgoal,pflags(a3)		;pfgoal - 0 for bottom 1 for top
	bne.w	.nd0
	neg.w	d0
	neg.w	d1
.nd0								;coordinates for his end
	lea	.chkdir(pc),a0
	btst	#2,(BA_PS_flags).w
	bne.w	.16
	btst	#0,(gmode2).w
	beq.w	.17
.16									;shootout or penalty shot: path done
	lea	.x(pc),a0
.17									;skate the path
	bra.w	skateto
.chkdir								;d0 = wanted direction: look for opponents in the way
	ext.w	d0
	move.b	Xvel(a3),d2				;Xvel
	ext.w	d2
	add.w	(puckx).w,d2
	move.b	Yvel(a3),d3				;Yvel
	ext.w	d3
	add.w	(pucky).w,d3
	clr.w	(threat).w
	moveq	#5,d4
	movea.w	#(SortCords-M68K_RAM),a0
	cmpi.w	#6,SCnum(a3)
	bge.w	.loop
	adda.w	#6*SCstruct,a0			;away team SCstruct start
.loop								;loop over the opponents
	move.b	Xvel(a0),d1				;Xvel
	ext.w	d1
	add.w	(a0),d1					;Xpos
	sub.w	d2,d1
	cmp.w	#$14,d1
	bgt.w	.next
	cmp.w	#$FFEC,d1
	blt.w	.next
	move.b	Yvel(a0),d1				;Yvel
	ext.w	d1
	add.w	Ypos(a0),d1				;Ypos
	sub.w	d3,d1
	cmp.w	#$14,d1
	bgt.w	.next
	cmp.w	#$FFEC,d1
	blt.w	.next
	addq.w	#1,(threat).w
	move.w	(a3),d0					;Xpos
	sub.w	(a0),d0
	move.w	Ypos(a3),d1				;Ypos
	sub.w	Ypos(a0),d1
	bsr.w	vtoa
	move.w	facedir(a3),d1			;facedir
	eori.w	#4,d1
	cmp.w	d0,d1
	bne.w	.next
	move.w	(HVcount).l,d1
	andi.w	#1,d1
	add.w	d1,d0
	andi.w	#7,d0
.next								;next opponent
	adda.w	#SCstruct,a0			;SCstruct size
	dbf	d4,.loop
.x									;exit (also the end of the code above)
	rts
.postab2	dc.w	$FF9C
	dc.w	$FFEC
	dc.w	$64
	dc.w	$FFEC
	dc.w	$FF88
	dc.w	$28
	dc.w	$14
	dc.w	$28
	dc.w	$78
	dc.w	$28
	dc.w	$FFEC
	dc.w	$28
	dc.w	$FFD8
	dc.w	$F0
	dc.w	0
	dc.w	$DC
	dc.w	$14
	dc.w	$E6
	dc.w	$1E
	dc.w	$E6
chk4lc								;see if computer should call line change
	btst	#4,(sflags7).w
	bne.w	rtss2
	move.w	(pucky).w,d0
	btst	#pfgoal,pflags(a3)
	bne.w	.0
	neg.w	d0
.0									;coordinates for his end
	tst.w	d0
	bmi.w	rtss2
	cmp.w	#$58,d0
	bgt.w	rtss2
	move.w	(HVcount).l,d0
	andi.w	#3,d0
	bne.w	rtss2
	btst	#pf2lcm,pflags2(a3)
	bne.w	rtss2
	movea.w	#(tmstruct-M68K_RAM),a2	;a2 = own team struct, a1 = the other one
	lea	tmsize(a2),a1
	btst	#pfteam,pflags(a3)
	beq.w	.1
	exg	a2,a1
.1									;team structs chosen
	bsr.w	AvgCline
	cmp.w	#$C00,d0
	bhi.w	rtss2
	bsr.w	CompLine				;pick and apply the new line
	bsr.w	setpersonel
	bsr.w	printscores1
	bra.w	CompShoot				;then clear the puck by shooting it
; return z flag set if killing penalty
; return z flag clr if not
chkpk								;return z flag set if killing penalty
									;return z flag clr if not
	btst	#sf2pwrplay,(sflags2).w	;#sf2pwrplay - check if power play in progress
	bne.w	chkpk2
	eori	#4,ccr					;Z flag
	rts
chkpk2								;return z flag set if a3's team is the one on the power play (sf2pwrtm
									;against pfteam)
	movem.l	d0-d1,-(sp)
	btst	#sf2pwrtm,(sflags2).w	;#sf2pwrtm - 0 for team 1, 1 for team 2
	move	sr,d0
	btst	#pfteam,pflags(a3)		;pfteam - 0 home, 1 away
	move	sr,d1
	eor.w	d1,d0
	move	d0,ccr
	movem.l	(sp)+,d0-d1
	rts
; player a3 looks for shot (computer controlled)
chk4shot							;player a3 looks for shot (computer controlled)
									;decide whether the computer carrier shoots; rtss = no shot, else falls to
									;CompShoot
	bsr.s	chkpk
	bne.w	.pkill					;killing penalty
	tst.w	(threat).w
	beq.w	.pkill					;no threat
	move.w	(HVcount).l,d0
	andi.w	#3,d0
	bne.w	.pkill
	move.w	#$58,d0					;top blue line Y position
	btst	#pfgoal,pflags(a3)
	beq.w	.cmphome
	move.w	#$FFA8,d0				;bottom blue line Y pos
	cmp.w	Ypos(a3),d0
	blt.w	CompShoot				;clear puck
	bra.w	.0
.cmphome							;pfgoal clear
	cmp.w	Ypos(a3),d0
	bgt.w	CompShoot				;clear puck
.0									;clear the puck: pass straight ahead
	bset	#3,(sflags5).w
	jmp	dopass
	dc.b	$60						;`
	dc.b	0,1
	dc.b	$30						;0
.pkill								;penalty kill: shoot it out on a breakaway roll
	btst	#pf3break,pflags3(a3)
	beq.w	.npk
	move.w	#$1E,d0
	jsr	(randomd0).l
	addi.w	#$82,d0
	cmp.w	(pucky).w,d0
	blt.w	.1
	neg.w	d0
	cmp.w	(pucky).w,d0
	bgt.w	.1
	bra.w	.npk
.1									;d0 < pucky or d0 > pucky
	move.w	#2,d0
	jsr	(randomd0s).l
	add.w	facedir(a3),d0
	andi.w	#7,d0
	move.w	d0,facedir(a3)
	bra.w	CompShoot
.npk								;d4 = shot range from the shot odds (spodds)
	moveq	#$20,d4
	clr.w	d1
	move.b	spodds(a3),d1
	lsr.w	#1,d1
	sub.b	d1,d4
	asl.w	#4,d4
	move.w	#$108,d1				;top goal line Y
	btst	#pfgoal,pflags(a3)
	bne.w	.c0
	neg.w	d1
.c0									;Y for his end
	sub.w	(pucky).w,d1			;d1 = y distance to the goal line, d0 = x distance to center
	move.w	(puckx).w,d0
	neg.w	d0
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d0,d1					;distance from goal squared
	cmp.l	#$2710,d1
	movem.w	(sp)+,d0-d1
	bhi.w	.no1					;farther than 100 from the goal: keep d4 as is
	lsr.w	#4,d4					;close: d4 = $20 - odds
	bsr.w	vtoa					;d0 = direction to the goal
	move.w	d0,d5					;d5 = shot direction
	moveq	#5,d3					;check the 6 opposing sort objects
	movea.w	#(SortCords-M68K_RAM),a1
	cmpi.w	#6,SCnum(a3)
	bge.w	.loop
	adda.w	#6*SCstruct,a1
.loop								;loop over the opponents: defenders in the shot line make the range bigger
	tst.w	position(a1)
	beq.w	.2
	move.w	(a1),d0					;direction from puck to this skater
	sub.w	(puckx).w,d0
	move.w	Ypos(a1),d1
	sub.w	(pucky).w,d1
	bsr.w	vtoa
	cmp.w	d5,d0
	bne.w	.co1
	asl.w	#1,d4					;defender in the shot line
	bra.w	.co1
.2									;goalie: shoot now if he is busy
	btst	#pf2aip,pflags2(a1)		;goalie busy, shoot now
	beq.w	.co1
	clr.w	d3						;end the loop after this object
	moveq	#1,d4					;tiny range: shot is almost certain
.co1								;next opponent
	adda.w	#SCstruct,a1
	dbf	d3,.loop
.no1								;roll against the range
	move.w	d4,d0
	bsr.w	randomd0
	btst	#0,spodds(a3)
	beq.w	.3
	cmp.w	#7,d0
	bgt.w	rtss2
	bra.w	.4
.3									;odd spodds: a roll of 7 or less shoots; even: 8 or less
	cmp.w	#8,d0
	bgt.w	rtss2
.4									;shoot only from inside the shooting distance
	move.w	(pucky).w,d0
	btst	#pfgoal,pflags(a3)
	bne.w	.ds0
	neg.w	d0
.ds0								;coordinates for his end
	tst.w	d0
	bmi.w	rtss2
	move.w	#$108,d1
	sub.w	d0,d1
	bmi.w	rtss2
	btst	#sf2offsig,(sflags2).w
	bne.w	rtss2
CompShoot							;computer shot: drop the return address and aim from the puck's distance
									;to the goal line
	addq.w	#4,sp					;don't return
	move.w	(pucky).w,d0
	btst	#pfgoal,pflags(a3)
	bne.w	.ds0
	neg.w	d0
.ds0								;coordinates for his end
	move.w	#$108,d1				;d0 is now puck y toward the goal I shoot at
	sub.w	d0,d1					;d1 = distance to $108 along the shooting direction
	lsr.w	#3,d1
	cmp.w	#$14,d1
	blt.w	.0
	moveq	#$14,d1
.0									;d1 clamped
	move.w	d1,temp2(a3)
	move.l	#$12,d0					;assshoot
	bra.w	assreplace
chk4pass							;player a3 looks for good pass (computer controlled)
	tst.w	(threat).w
	bne.w	.dp0					;an opponent is close: always consider a pass
	moveq	#$10,d0
	add.b	spodds(a3),d0
	bsr.w	randomd0				;0 <= d0 < $10 + odds
	cmp.w	#$C,d0
	bgt.w	rtss2
.dp0								;threat check passed
	moveq	#6,d0					;Set up pass assignment
	bsr.w	randomd0				;d0 = random teammate index 0-5
	cmpi.w	#6,SCnum(a3)
	blt.w	.0
	addq.w	#6,d0
.0									;d0 = random teammate on a3's team
	tst.w	position(a3)
	beq.w	.1
	cmpi.w	#$28,(puckx).w
	bgt.w	.1
	cmpi.w	#$FFD8,(puckx).w
	blt.w	.1
	cmpi.w	#$CC,(pucky).w
	bgt.w	rtss2
	cmpi.w	#$FF34,(pucky).w
	blt.w	rtss2
.1									;not to himself
	cmp.w	SCnum(a3),d0
	beq.w	rtss2
	asl.w	#7,d0					;d0 * SCstruct ($80)
	movea.w	#(SortCords-M68K_RAM),a0
	adda.w	d0,a0					;a0 = receiver sort object
	tst.w	position(a0)
	ble.w	rtss2
	btst	#pf2unav,pflags2(a0)
	bne.w	rtss2
	btst	#pfalock,pflags(a0)
	bne.w	rtss2
	move.w	Ypos(a0),d0				;check for pass across blue line
	move.w	Ypos(a3),d1				;d0 = receiver y, d1 = my y (toward the goal I shoot at)
	btst	#pfgoal,pflags(a3)
	bne.w	.f0
	neg.w	d0
	neg.w	d1
.f0									;coordinates for his end
	btst	#gmoffs,(gmode).w		;offsides on?
	beq.w	.oko
	movem.w	d0-d1,-(sp)
	subi.w	#$58,d0					;y relative to the blue line
	subi.w	#$58,d1
	eor.w	d0,d1					;sign differs if the pass crosses the blue line
	movem.w	(sp)+,d0-d1
	bmi.w	rtss2
.oko								;not across the blue line
	cmp.w	#$58,d0
	bgt.w	.ok
	sub.w	d1,d0
	cmp.w	#$FFF1,d0
	blt.w	rtss2
.ok									;pass is safe
	move.w	(a0),d0					;receiver accepted: get the pass direction
	sub.w	(puckx).w,d0
	move.w	Ypos(a0),d1
	sub.w	(pucky).w,d1
	movem.w	d0-d1,-(sp)
	bsr.w	vtoa					;direction puck -> receiver
	move.w	d0,(passdir).w
	movem.w	(sp)+,d1-d2
	muls.w	d1,d1
	muls.w	d2,d2
	add.l	d1,d2					;d2 = squared distance to the receiver
	moveq	#5,d3
	movea.w	#(SortCords-M68K_RAM),a1
	cmpi.w	#6,SCnum(a3)
	bge.w	.co0
	adda.w	#6*SCstruct,a1			;loop over the 6 opponents
.co0								;loop over the 6 opponents: anyone in the pass lane?
	move.w	(a1),d0					;next opponent: is he in the pass lane?
	sub.w	(puckx).w,d0
	move.w	Ypos(a1),d1
	sub.w	(pucky).w,d1
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d0,d1					;d1 = squared distance to this opponent
	cmp.l	d2,d1
	movem.w	(sp)+,d0-d1
	bhi.w	.co1					;farther than the receiver: ignore
	bsr.w	vtoa
	cmp.w	(passdir).w,d0
	beq.w	rtss2
.co1								;next opponent
	adda.w	#SCstruct,a1			;next opponent
	dbf	d3,.co0
	bsr.w	dopass					;lane is clear: pass in passdir
	tst.w	position(a3)
	beq.w	rtss2
	addq.w	#4,sp
	bra.w	assexit
; player a3 should avoid the puck carrier if he's on their team
EvadePC								;player a3 should avoid the puck carrier if he's on my team out: d0 =
									;direction 0-7 pointing away from the puck (from vtoa), adjusted near the
									;blue line
	tst.w	(puckc).w
	bmi.w	rtss2					;no puck carrier
	move.b	Xvel(a3),d2				;Xvel
	sub.b	(puckvx).w,d2			;sub puckvx from Xvel
	ext.w	d2
	add.w	(a3),d2					;add Xpos
	sub.w	(puckx).w,d2			;Sub puckx
	cmp.w	#$28,d2					;compare to 40 decimal
	bgt.w	rtss2					;exit if greater than 40
	cmp.w	#$FFD8,d2				;compare to -40
	blt.w	rtss2					;exit if less than -40
	move.b	Yvel(a3),d1				;Yvel
	sub.b	(puckvy).w,d1			;sub puckvy from Yvel
	ext.w	d1
	add.w	Ypos(a3),d1				;add Ypos to d1
	sub.w	(pucky).w,d1			;Sub pucky
	cmp.w	#$28,d1					;compare to 40 dec
	bgt.w	rtss2					;exit if greater than
	cmp.w	#$FFD8,d1				;compare to -40 dec
	blt.w	rtss2					;exit if less than
	move.w	(a3),d0					;Xpos
	sub.w	(puckx).w,d0			;Sub puckx from Xpos
	move.w	Ypos(a3),d1				;Ypos
	sub.w	(pucky).w,d1			;Sub pucky from Ypos
	bsr.w	vtoa					;find direction and convert to 0-7
	btst	#gmoffs,(gmode).w		;check if offsides is on
	beq.w	.ex						;exit if not
	move.w	Ypos(a3),d1				;Ypos
	btst	#pfgoal,pflags(a3)		;check what net shooting at
	bne.w	.0						;branch if top
	neg.w	d1						;negate d1 (Ypos)
.0									;Y for his end
	subi.w	#$58,d1					;sub 88 from Ypos (top blue line)
	cmp.w	#$A,d1					;compare to 10 decimal
	bgt.w	.ex						;exit if greater
	cmp.w	#-50,d1
	blt.w	.ex						;branch if less than
	moveq	#2,d0					;near the blue line: go sideways, d0 = 2 if x > puck x...
	move.w	(a3),d1					;Xpos
	cmp.w	(puckx).w,d1			;compare puckx with Ypos difference
	bgt.w	.ex						;exit if greater
	moveq	#6,d0
.ex									;exit (also the end of the code above)
	rts
;	Late routines of the logic code: offsides, the puck state routines, skating and acceleration.
;	The penalty shot and faceoff code sit among the assignment routines.
;
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp /
;	cmpi; fixopcodes.js patches the cmp encoding after assembly.

;SortCords offsets: Xpos 0, Ypos $14, Xvel $28, Yvel $2A, position $34, assnum $36, temp1 $40,
;temp3 $44, temp4 $46, SCnum $52, facedir $54, SPA $58, pflags $62, pflags2 $63.

checkob								;bring up little warning ref if a player on your team is over blue line
	btst	#gmoffs,(gmode).w
	beq.w	rtss2
	btst	#2,(BA_PS_flags).w
	bne.w	rtss2
	movem.l	d0-d1/a0,-(sp)
	moveq	#5,d0					;6 players of a3's team
	movea.w	#(SortCords-M68K_RAM),a0
	cmpi.w	#6,SCnum(a3)
	blt.w	.0
	adda.w	#6*SCstruct,a0			;a0 = first sort object of a3's team
.0									;d1 = the blue line for the net a3 shoots at
	moveq	#$5C,d1
	btst	#pfgoal,pflags(a3)
	bne.w	.top					;shooting at the top goal: mirrored tests below
	neg.w	d1						;d1 = -$5C
	cmp.w	(pucky).w,d1
	bgt.w	.nob					;puck already across the line: nobody can be offside
.bottom								;loop: any player over the blue line (bottom end)?
	tst.w	position(a0)			;loop over the team, skipping negative positions
	bmi.w	.bn
	cmp.w	Ypos(a0),d1
	bgt.w	.ob						;this player is over the line
.bn									;next player
	adda.w	#SCstruct,a0
	dbf	d0,.bottom
.nob								;next player down
	moveq	#$40,d0					;no one offside: d0 = $40 = clear the ref window (PushRef)
	bclr	#sf2offsig,(sflags2).w	;clear the offsides ref flag
	bne.w	.dref					;it was on: update the ref
.ex									;exit: restore the registers
	movem.l	(sp)+,d0-d1/a0
	rts
.ob									;offside: show the little ref once
	moveq	#6,d0
	bset	#sf2offsig,(sflags2).w	;someone is offsides: show the little ref
	bne.s	.ex						;already shown
.dref								;show the little ref
	tst.w	(RefCnt).w				;only when the ref queue is idle (negative)
	bpl.s	.ex
	bsr.w	PushRef
	bra.s	.ex
.top								;pfgoal set
	cmp.w	(pucky).w,d1
	blt.s	.nob
.top1								;loop: any player over the blue line (top end)?
	tst.w	position(a0)			;loop over the team's players (top goal)
	bmi.w	.tn
	cmp.w	Ypos(a0),d1
	blt.s	.ob
.tn									;next player
	adda.w	#SCstruct,a0			;next player
	dbf	d0,.top1
	bra.s	.nob
; assignment for breakaway
assbreakaway						;assignment for a breakaway: the puck carrier skates in, anyone else goes
									;back to assnearest
	move.w	SCnum(a3),d0			;Move SCnum into d0
	cmp.w	(puckc).w,d0			;compare puck carrier SCnum with d0
	beq.w	.puckc					;branch if puck carrier
.notpuckc							;loop
	bclr	#pf3break,pflags3(a3)	;clear breakaway bit
	move.w	#$11,d0					;11 - assnearest
	bsr.w	assreplace
	bra.w	assnearest
.puckc								;d0 = puckc
	jsr	(breakaway).l
	bmi.s	.notpuckc
; this is a special assignment used for the player who is nearest the puck but doesn't have it
assnearest							;this is a special assignment used for the player who is nearest the puck
									;but doesn't have it. Assignment anearest ($11)
									;a2 = a3's team struct, d7 = elapsed frames. temp1 = re-evaluation timer,
									;temp3 = hold timer
	bclr	#2,(sflags5).w
	bne.w	.chkpuck
	bclr	#pf3break,pflags3(a3)	;clear breakaway bit
.chkpuck							;check the puck
	move.w	SCnum(a3),d0			;move SCnum into d0
	cmp.w	(puckc).w,d0			;compare with puck carrier SCnum
	bne.w	.chkbreak				;jump if not puck carrier
	btst	#pf3break,pflags3(a3)	;check breakaway bit
	bne.w	.chkbreak				;jump if set
	btst	#2,(BA_PS_flags).w		;check if bit 2 set (cleared on Faceoffs)
	bne.w	.chkbreak				;jump if set
	jsr	(BreakawayOffsidesFlagSet).l
	beq.w	.chkbreak
	move.w	#$22,d0					;22 - assbreakaway if flag set
	bsr.w	assreplace				;assreplace with assbreakaway
	bra.w	*+4
.chkbreak							;assnearest: breakaway carriers switch to assbreakaway
	bclr	#pfna,pflags(a3)		;pfna - clear new assignment
	beq.w	.nna
	btst	#pf3break,pflags3(a3)	;check if breakaway
	beq.w	.chkbreak2				;jump if not
	move.w	#SFXbeep1,-(sp)			;ding SFX
	jsr	(sfx).l
.chkbreak2							;breakaway crowd
	btst	#pf3break,pflags3(a3)	;check if breakaway
	beq.w	.nobreak				;jump if not
	movem.l	a2,-(sp)				;push a2 to stack
	movea.l	#tmstruct,a2			;put Home Team Struct into a2
	btst	#pfteam,pflags(a3)		;pfteam - check home or away
	beq.w	.addcrowd				;jump if home
	movea.l	#awtmstruct,a2			;put Away Team Struct into a2
.addcrowd							;team struct chosen
	addq.w	#1,tmBreakaways(a2)		;add to breakaway attempt
	addi.w	#$14,(CwdExciteLvl).w	;add to excite level
	addi.w	#$C8,(Crowdlevel).w		;add to crowd level
	movem.l	(sp)+,a2				;pop off stack into a2
.nobreak							;breakaway check done
	clr.w	temp3(a3)				;clear temp3
	move.w	#8,temp2(a3)			;move 8 into temp2
	clr.w	temp1(a3)				;clear temp1
.nna								;count down the timer
	move.w	SCnum(a3),d1			;checks if puck carrier
	cmp.w	(puckc).w,d1
	bne.w	.nopc					;jumps if not
	tst.w	position(a3)			;check if goalie
	beq.w	assgoalie				;branch if goalie
	move.l	#$10,d0					;10 = asspuckc
	btst	#pfjoycon,pflags(a3)	;pfjoycon - check if controlled
	beq.w	assinsert				;jump if not
	rts								;human controlled: leave as is
.nopc								;d1 <> puckc
	sub.b	d7,temp1(a3)			;subtract d7 (elapsed frames) from temp1
	bpl.w	.nodec					;jump if positive
	move.b	aioff(a3),temp1(a3)		;move aioff into temp1
	jsr	(ReadGoaliePulled).l		;check if goalie is pulled
	bmi.w	.bonus
	btst	#6,(sflags7).w			;check if crowd meter currently broken
	beq.w	.nopc2					;jump if not broken
	tst.b	temp1(a3)				;check if temp1 is 0
	beq.w	.nopc2					;jump if so
.bonus								;goalie pulled or crowd meter broken: quicker reactions
	subq.b	#1,temp1(a3)			;subtract 1 from temp1
.nopc2								;puck carrier in the slot: count it for the right team
	btst	#5,(sflags6).w			;check if slot bit is set (puckc in slot)
	beq.w	.nopc3					;branch if not set
	move.w	(puckc).w,d1			;move puck carrier SCnum
	cmp.w	#5,d1					;check if its home (5 or less) or away (6-11)
	bgt.w	.pcaway					;jump if away
	btst	#pfteam,pflags(a3)		;pfteam
	beq.w	.nopc3					;jump if home
.tmnopc								;loop
	move.b	temp1(a3),d1			;temp1 into d1
	ext.w	d1						;extend d1
	asr.w	#1,d1					;divide by 2
	move.b	d1,temp1(a3)			;move d1 into temp1 - cutting the timer in half
	bne.w	.nopc3					;jump if not zero
	move.b	#1,temp1(a3)			;move 1 into temp1
	bra.w	.nopc3
.pcaway								;d1 > 5
	btst	#pfteam,pflags(a3)		;pfteam - 0 home, 1 away
	beq.s	.tmnopc					;jump if home
.nopc3								;find our skater nearest the puck
	clr.l	tmnear(a2)				;no nearest skater yet
	move.w	(puckc).w,d1			;move puck carrier SCnum into d1
	bmi.w	.np						;branch if no puck carrier
	asl.w	#scsize,d1				;scsize
	movea.w	#(SortCords-M68K_RAM),a1	;Move SortCords into a1
	adda.w	d1,a1					;use d1 as offset
	move.b	pflags(a1),d0			;pflags of puck carrier
	move.b	pflags(a3),d1			;pflags of current player
	eor.b	d0,d1					;XOR pflags
	btst	#pfteam,d1				;check pfteam
	beq.w	.switch					;branch if on same team
.np									;not the carrier
	moveq	#-1,d2					;-1
	moveq	#5,d4					;5 = # of players on team
	movea.w	tmsort(a2),a0			;SortCord start value for team
.de0								;loop over our skaters: d2 = smallest distance^2 to the puck
	tst.w	position(a0)			;check if goalie
	ble.w	.next					;branch if goalie
	tst.b	nopuck(a0)				;check if nopuck (cant touch puck)
	bne.w	.next					;branch if nopuck timer not 0
	btst	#pf2unav,pflags2(a0)	;pf2unav - unavailable
	bne.w	.next					;branch if unavailable
	move.w	assnum(a0),d0			;assnum - current assignment
	cmpi.b	#$13,asslist(a0,d0.w)	;check if current assignment is asspassrec
	beq.w	.next					;branch if a0 is going to receive puck
	move.l	a0,-(sp)				;push onto stack
	bsr.w	GetHot					;get hot spot
	add.w	(a0),d0					;Xpos to d0
	sub.w	(puckx).w,d0			;sub puck Xpos
	add.w	Ypos(a0),d1				;add Ypos to d1
	sub.w	(pucky).w,d1			;sub puck Ypos
	move.w	(puckvx).w,d3			;puckvx into d3
	asr.w	#6,d3					;divide by 64
	sub.w	d3,d0					;sub d3 from d0 (X distance between player and puck)
	move.w	(puckvy).w,d3			;puckvy into d3
	asr.w	#6,d3					;divide by 64
	sub.w	d3,d1					;sub d3 from d1 (Y distance between player and puck)
	muls.w	d0,d0					;square d0
	muls.w	d1,d1					;square d1
	add.l	d1,d0					;add d1 to d0
	cmp.l	d2,d0					;compare d2 to d0
	bhi.w	.next					;branch if d0 higher than d2 (0 or a positive # first run)
	move.l	d0,d2					;move d0 into d2
	movea.w	a0,a1					;move a0 address into a1
.next								;next skater
	adda.w	#SCstruct,a0			;SCstruct size
	dbf	d4,.de0						;iterate through loop
	tst.l	d2						;check if 0
	bmi.w	.de1					;branch if less (no one near puck)
	move.l	d2,tmnear(a2)			;nearest skater's distance^2 to the puck
.switch								;nearest skater found
	cmpa.w	a1,a3					;a1 = closest to the puck, or puckc (if on same team)
	beq.w	.de1					;branch if same
	btst	#gmclock,(gmode).w		;gmclock - 1 if stopped
	bne.w	.de1					;jump if stopped
	btst	#pf2unav,pflags2(a1)	;pf2unav
	bne.w	.de1					;jump if unavailable
	btst	#pf3onetimer,pflags3(a1)	;shooting one timer
	bne.w	.de1					;jump if shooting
	exg	a1,a3						;swap addresses
	bclr	#pfdoff,pflags(a3)		;clear pfdoff
	move.l	#$11,d0					;assnearest
	bsr.w	assinsert				;... and give him the assnearest assignment
	exg	a1,a3
	bra.w	assexit					;I (old a3) drop this assignment
.de1								;nobody nearer: go to the puck
	btst	#pfalock,pflags(a3)		;pfalock - check if locked in animation
	bne.w	rtss2					;exit if locked
	moveq	#2,d1					;move 2 into d1
	cmp.w	#$190,d2				;compare $190 (20^2) to d2. d2 = distance to puck^2
	bhi.w	.nfar					;branch if d2 higher
	subq.w	#2,d1					;close: d1 = 0
	cmpi.w	#2,position(a3)			;compare if position is F or D (1 and 2 are D)
	bls.w	.nodec					;jump if D
.nfar								;far from the puck
	btst	#sf2pwrplay,(sflags2).w	;sf2pwrplay - check if PP
	beq.w	.x						;branch if no PP
	subq.w	#2,d1					;sub 2 from d1
	bsr.w	chkpk2
	bne.w	.x						;branch if on PK
	addq.w	#4,d1					;add 4 to d1
.x									;d1 = shift for the check odds (penalty kill uses less)
	move.w	#$28,d0					;move $28 into d0 (40 dec)
	sub.b	checking(a3),d0			;sub checking from d0
	asl.w	d1,d0					;shift d0 by value of d1
	bsr.w	randomd0				;RNG
	cmp.w	#2,d0					;compare 2 to d0
	bhi.w	.nodec					;branch if d0 more than 2
	move.w	#$F0,temp3(a3)			;move 240 dec into temp3
.nodec								;temp3 = 240 on a low roll: probably a hit timer
	btst	#pfalock,pflags(a3)		;pfalock - check if anim lock
	bne.w	rtss2					;exit if locked
	btst	#2,(BA_PS_flags).w		;check bit 2
	beq.w	.gmclock				;jump if not set
	btst	#5,(BA_PS_flags).w		;check bit 5
	beq.w	.nodec2					;jump if not set
.gmclock							;clock running?
	btst	#gmclock,(gmode).w		;check if clock running
	bne.w	donothing				;branch if not
.nodec2								;clock running: count down
	btst	#pfjoycon,pflags(a3)	;pfjoycon - check if controlled
	bne.w	rtss2					;jump if controlled
	btst	#tmfmid,tmflags(a2)		;tmfmid of tmflags(a2)
	bne.w	.nodec22
	tst.w	(puckc).w				;check if theres a puck carrier
	bmi.w	.topuck					;jump if no puck carrier
	sub.w	d7,temp3(a3)			;subtract frames from temp3
	bpl.w	.topuck					;jump if positive
	clr.w	temp3(a3)				;clear temp3
.nodec22							;skate to the puck
	bsr.w	skatetopuckinit			;d0/d1 = halfway between
	movem.w	d0-d1,-(sp)				;d0 = future puckx, d1 = future pucky push on stack
	neg.w	d0						;or (0,-$F4) if pfgoal
	neg.w	d1
	addi.w	#$F4,d1					;add goalline - 20 decimal
	btst	#pfgoal,pflags(a3)		;pfgoal - check what net shooting on
	beq.w	.nd0					;branch if bottom
	subi.w	#$1E8,d1				;sub bottom goalline - 20 decimal
.nd0								;Y target for his end
	asr.w	#1,d0					;divide by 2
	asr.w	#1,d1					;divide by 2
	add.w	(sp)+,d0				;add original future puckx
	add.w	(sp)+,d1				;add original future pucky
	btst	#tmfmid,tmflags(a2)		;?? - doesn't seem to be set anywhere
	beq.w	.spdboost
	btst	#pfgoal,pflags(a3)		;pfgoal
	beq.w	.botshoot				;branch if bottom
	cmp.w	#$53,d1					;check if y pos of puck near blue line
	blt.w	.spdboost				;branch if in neutral zone or D zone
	move.w	#$44,d1					;move 44 hex into d1
	bra.w	.spdboost
.botshoot							;pfgoal clear
	cmp.w	#$FFAD,d1				;check if pucky near bottom blue line
	bgt.w	.spdboost				;branch if in neutral zone or D zone
	move.w	#$FFBC,d1				;move FFBC into d1
.spdboost							;carrier in the slot: speed boost toward the puck
	btst	#5,(sflags6).w			;check if puckc is in the slot
	beq.w	.noslot					;branch if not
	move.b	legspd(a3),(TempLegSpd).w	;legspd into TempLegSpd
	addq.b	#6,legspd(a3)			;add 6 to legspd
	btst	#1,(sflags8).w			;check if crowd meter broken (always is)
	bne.w	.spdboostex				;jump if set
	btst	#6,(sflags7).w			;check if crowd meter currently broken
	beq.w	.spdlimit				;jump if not set
.spdboostex							;crowd meter boost
	addq.b	#2,legspd(a3)
.spdlimit							;limit the speed
	cmpi.b	#$1E,legspd(a3)			;check speed limit
	ble.w	.cont
	move.b	#$1E,legspd(a3)			;limit legspd to $1E (30 decimal)
.cont								;skate, then put the leg speed back
	lea	rtss2(pc),a0
	bsr.w	skateto
	move.b	(TempLegSpd).w,legspd(a3)	;move original legpsd back into player
	bra.w	.chkslot
.noslot								;bit 5 of sflags6 clear
	lea	rtss2(pc),a0
	bsr.w	skateto
.chkslot							;in the slot: chase the carrier
	btst	#5,(sflags6).w
	beq.w	.chkcont
	move.w	(pucky).w,d0
	move.w	Ypos(a3),d2				;Ypos into d2
	tst.w	d0						;check if d0 is 0
	bpl.w	.pospuck				;branch if positive
	neg.w	d0						;make d0 negative
	neg.w	d2						;make d2 negative
.pospuck							;puck side
	sub.w	d0,d2					;sub d0 from d2 (equals how far puck is from player Ypos)
	cmp.w	#$A,d2					;check difference with A (10 decimal)
	blt.w	.exit
	move.w	(a3),d0					;Xpos of player (gets here if player is between net and puck carrier)
	sub.w	(puckx).w,d0			;sub puckx from Xpos
	bpl.w	.chkx					;branch if positive difference
	neg.w	d0						;make d0 negative
.chkx								;|dx|
	cmp.w	#$F,d0					;compare F (15 dec) with Xpos difference
	blt.w	.chkcont				;branch if less than (within 15 pix in X direction)
.exit								;exit (also the end of the code above)
	rts
.chkcont							;bit 5 of sflags6 clear or d0 < $F
	btst	#5,(sflags6).w			;check if puckc is in the slot
	beq.w	check4check				;branch if not in slot
	move.b	checking(a3),d0			;move Chk into d0
	ext.w	d0						;clear top byte of d0
	movem.l	d0/a3,-(sp)				;push to stack
	add.b	d0,d0					;add d0 to itself
	cmp.b	#$1E,d0					;compare max Chk to d0
	blt.w	.chkcont2				;branch if less
	move.b	#$1E,d0					;move 1E into d0
.chkcont2							;check odds clamped
	move.b	d0,checking(a3)			;move d0 into Chk
	bsr.w	check4check
	movem.l	(sp)+,d0/a3				;pop off stack
	move.b	d0,checking(a3)			;move original Chk into player
	rts
.topuck								;skate to the puck (falls into check4check)
	bsr.w	skatetopuck
; look for good opportunity for checking opponent
; a3 = player
check4check							;look for good opportunity for checking opponent. Falls in from
									;assnearest; also entered from assfwatch and asswingd roll against
									;the checking rating first, then look for an opponent within 30 units
									;whom a3 is facing
	tst.w	position(a3)			;check if goalie
	bne.w	.player					;branch if not
	rts
.player								;skater: d0 = check range, less checking skill, more with penalties off
	move.w	#$28,d0					;start with 28 hex (40 decimal)
	sub.b	checking(a3),d0			;subtract Chk from d0 (Chk max is 1E or 30 decimal)
	tst.w	(OptPen).w				;check for penalties option
	beq.w	.nopen					;branch if not on
	asl.w	#1,d0					;mult by 2
.nopen								;penalty odds
	bsr.w	randomd0				;RNG d0
	cmp.w	#6,d0					;compare 6 to d0
	bhi.w	rtss2					;exit if d0 higher than 6
	moveq	#5,d2					;move 5 into d2
	movea.w	#(SortCords-M68K_RAM),a0
	cmpi.w	#6,SCnum(a3)			;check if player on home team
	bge.w	.0						;branch if away
	adda.w	#6*SCstruct,a0			;add if home (checks opposite team in loop)
.0									;loop over the opponents for a check target
	tst.w	position(a0)			;check if goalie
	beq.w	.next					;branch if goalie
	btst	#pfalock,pflags(a0)		;check if locked in anim
	bne.w	.next					;branch if locked
	btst	#pf2fight,pflags2(a0)	;check if fighting
	bne.w	.next					;branch if fighting
	move.w	(a0),d0					;move Xpos into d0
	sub.w	(a3),d0					;sub a3 from a0
	cmp.w	#$1E,d0					;compare to 30 decimal
	bgt.w	.next					;branch if more than 30 decimal
	cmp.w	#$FFE2,d0				;compare to -30 decimal
	blt.w	.next					;branch if less than -30
	move.w	Ypos(a0),d1				;Ypos
	sub.w	Ypos(a3),d1				;subtract checker Ypos from d1
	cmp.w	#$1E,d1					;compare to 30 decimal
	bgt.w	.next					;branch if more
	cmp.w	#$FFE2,d1				;check with -30 decimal
	blt.w	.next					;branch if less
	bsr.w	vtoa					;determine direction
	cmp.w	facedir(a3),d0			;compare facedir with vtoa result
	bne.w	.next					;branch if not facing in that direction
	btst	#5,(sflags6).w			;check if puckc in slot
	bne.w	Acheck					;branch if in slot
	move.w	(HVcount).l,d0			;move HVcounter into d0
	andi.w	#3,d0					;pass first 2 bits
	bne.w	burst					;throw check
	bra.w	Acheck					;1 in 4: hold or hook on a0
.next								;next opponent
	adda.w	#SCstruct,a0			;move to next SCstruct
	dbf	d2,.0
	rts
; assignment for catching pass
asspassrec							;assignment for catching a pass (apassrec)
	btst	#pfalock,pflags(a3)		;pfalock - animation lock
	bne.w	rtss2					;exit if locked
	btst	#gmclock,(gmode).w		;gmclock - check if clock running
	bne.w	donothing				;exit if clock stopped
	btst	#pfjoycon,pflags(a3)	;pfjoycon - joystick controlled?
	bne.w	assexit					;exit if controlled
	bclr	#pfna,pflags(a3)		;#pfna - clear new assignment
	beq.w	.nna
	bset	#pfdoff,pflags(a3)		;#pfdoff - set decceleration off
	move.b	#8,temp2+1(a3)			;move into temp2+1
	clr.b	temp2(a3)				;clear temp2 byte
	move.w	#$FFFE,temp4(a3)		;move into temp4
.nna								;count down the timer
	tst.w	(puckc).w				;check if there is a puck carrier
	bpl.w	.exit					;exit if puck still in possession
	addq.w	#1,temp4(a3)			;add to temp4
	beq.w	.0						;branch if temp4 is zero
	bpl.w	.ex2					;branch if temp4 is positive
.0									;pass missed or gone: back to normal play unless a one-timer is set
	tst.w	(onetimerplayer).w
	bpl.w	.ex2
	tst.w	position(a3)			;test if goalie
	beq.w	.ex2					;exit if goalie
	move.w	d0,-(sp)				;push d0 on stack
	clr.w	temp4(a3)				;clear temp4
	move.w	#1,d0
	btst	#pfteam,pflags(a3)		;check if home or away
	beq.w	.1
	move.w	#2,d0					;away team
.1									;team pad chosen
	cmp.w	(cont1team).w,d0		;check if player on cont 1 team
	beq.w	.pop					;branch if so
	cmp.w	(cont2team).w,d0		;check if player on cont 2 team
	beq.w	.pop					;branch if so
	jsr	(PuckOnAttackHalf).l
	beq.w	.pop
	move.w	Ypos(a3),d0				;Ypos
	btst	#pfgoal,pflags(a3)		;pfgoal
	bne.w	.chkpos					;branch if shooting at top
	neg.w	d0
.chkpos								;position check
	cmp.w	#Blueline,d0			;blueline
	blt.w	.nozone
	cmp.w	#Blueline+goalline,d0	;goalline
	bgt.w	.nozone
	bra.w	.atkzone
.nozone								;d0 < #Blueline or d0 > #Blueline+goalline
	move.w	#8,d0					;outside of attack zone
	jsr	(randomd0).l
	tst.w	d0						;check if d0 is zero
	bne.w	.pop
.atkzone							;in the attack zone (or 1 in 8 outside): set up a one-timer
	move.w	(sp)+,d0
	move.w	#$FFFF,(inputjoy).w
	move.w	#$23,d0					;assonetimer
	jmp	assreplace
.pop								;no one-timer: drop the saved d0
	move.w	(sp)+,d0
.ex2								;count down the pass timer; when out, back to normal play
	sub.b	d7,temp1(a3)
	bpl.w	rtss2
.exit								;exit
	bclr	#pfdoff,pflags(a3)
	bra.w	assexit
SkateToTempTarget					;unreferenced. Skate to temp3 / temp4, then rts
	move.w	temp3(a3),d0			;temp3
	move.w	temp4(a3),d1			;temp4
	lea	rtss2(pc),a0
	bra.w	skateto

; assignment for computer shooting
assshoot							;assignment for computer shooting. Assignment ashoot ($12)
	btst	#pfalock,pflags(a3)		;pfalock - animation locked
	bne.w	rtss2
	bclr	#pfna,pflags(a3)		;clear pfna
	beq.w	.nna
	bra.w	SetShotMode				;first frame: start the shot (temp2 = swing time set by CompShoot)
.nna								;pfna was clear
	btst	#sfssdir,(sflags).w		;#sfssdir
	beq.w	assexit					;no: the shot is done
	clr.w	d2
	sub.w	d7,temp2(a3)			;count the swing time down
	bpl.w	ShotMode				;still swinging: feed ShotMode no buttons
	bset	#cbut,d2				;#cbut
	bra.w	ShotMode				;swing time over: press the shot button (cbut)
puckshootout						;puck logic for the shootout: on a new assignment clear the pads and
									;select the skater, then run the attempt
	bclr	#pfna,pflags(a3)
	beq.w	.selectskater
	bset	#7,(sflags7).w
	clr.l	(padcont).w
	clr.l	(padcont+4).w
	clr.l	(padcont+8).w
	bclr	#7,(gmode2).w
	btst	#0,(gmode2).w
	beq.w	.startattempt
	jsr	(NextShooter).l
	bra.w	.initflags
.startattempt						;bit 0 of gmode2 clear
	jsr	(StartShootoutPath).l
	move.l	a2,-(sp)
	movea.l	#tmstruct,a2
	tst.w	(BA_Team).w
	beq.w	.countattempt
	movea.l	#awtmstruct,a2
.countattempt						;count the attempt
	addq.w	#1,tmPenShots(a2)
	movea.l	(sp)+,a2
.initflags							;attempt counted: clear the penalty shot state flags
	bclr	#2,(BA_PS_flags).w
	bclr	#4,(BA_PS_flags).w
	bclr	#5,(BA_PS_flags).w
	bclr	#6,(BA_PS_flags).w
	bset	#1,(sflags6).w
	btst	#gmpendel,(gmode).w
	bne.w	Stop4Pen
	bclr	#pfna,pflags(a3)
	btst	#0,(gmode2).w
	beq.w	.selectsong
	tst.w	(shootoutteam).w
	bne.w	.setstopped
	tst.w	(homeshootnum).w
	bne.w	.setstopped
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#SngFaceoff,(SongIndex).w
	jsr	(ChooseSong).l
	move.w	(SongNum).w,-(sp)
	bra.w	.playsong
.selectsong							;bit 0 of gmode2 clear
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#SngFaceoff,(SongIndex).w
	jsr	(ChooseSong).l
	move.w	(SongNum).w,-(sp)
.playsong							;play the chosen song, then stop the clock for the attempt
	bsr.w	song
.setstopped							;stop the clock
	bset	#gmclock,(gmode).w
	bset	#1,(gmode2).w
	clr.w	(puckvx).w
	clr.w	(puckvy).w
	move.w	#$19,(shootoutclock).w
	bsr.w	ReturnGoalies
	st	temp1(a3)
	st	temp2(a3)
.selectskater						;select the skater
	bset	#2,(BA_PS_flags).w
	movem.w	d1-d2,-(sp)
	jsr	(SelectPenaltyShotSkater).l
	bmi.w	.noeligible
	movem.w	(sp)+,d1-d2
	bra.w	.checkgoalie
.noeligible							;pop the d1-d2 saved above
	movem.w	(sp)+,d1-d2
	bclr	#2,(BA_PS_flags).w
	move.w	#$1B,d0					;puckfaceoff
	bsr.w	assreplace
	rts
.checkgoalie						;shootout: make sure the shooting team's goalie is in net
	movem.w	d1-d2,-(sp)
	move.w	(BA_Goalie_SCnum).w,d0
	movea.l	#SortCords,a2
	asl.w	#7,d0
	adda.w	d0,a2
	tst.w	position(a2)
	bne.w	.findgoalie
	btst	#2,pflags2(a2)
	beq.w	.startpenshot
.findgoalie							;goalie not available: search the team for another goalie slot
	move.w	(BA_Goalie_SCnum).w,d0
	move.w	#6,d2
.goalieloop							;loop
	subq.w	#1,d2
	bmi.s	.noeligible
	subq.w	#1,d0
	bpl.w	.wraphome
	move.w	#5,d0
	bra.w	.checkcandidate
.wraphome							;d0 >= 0
	cmp.w	#5,d0
	bne.w	.checkcandidate
	move.w	#$B,d0
.checkcandidate						;wrap from home to away numbering, then try this candidate
	movea.l	#SortCords,a2
	move.w	d0,d1
	asl.w	#7,d1
	adda.w	d1,a2
	tst.w	position(a2)
	bne.s	.goalieloop
	btst	#2,pflags2(a2)
	bne.s	.goalieloop
	move.w	d0,(BA_Goalie_SCnum).w
.startpenshot						;pop the d1-d2 saved above
	movem.w	(sp)+,d1-d2
	movea.w	#(tmstruct-M68K_RAM),a2
	move.w	#$1F,d0					;puckpenshot
	bra.w	assreplace
SelectPenaltyShotSkater				;pick the skater for the penalty shot from team BA_Team
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a0
	tst.w	(BA_Team).w
	beq.w	.hometeam
	movea.l	#awtmstruct,a0
.hometeam							;team struct chosen
	move.w	#0,d1
	move.w	#$FFFF,d6
	move.w	#$FFFF,d5
	movea.l	tmdata(a0),a2
	adda.w	(a2),a2
.playerloop							;loop
	cmpi.w	#2,(a2)
	beq.w	.doneplayers
	adda.w	(a2),a2
	move.w	d1,d7
	asl.w	#1,d7
	move.b	pldstick(a2),d0
	andi.w	#$F,d0
	cmp.b	#1,d0
	ble.w	.nextplayer
	btst	#0,(gmode2).w
	bne.w	.setskaterscnum
	cmpi.w	#$FFFE,tmpdst(a0,d7.w)
	beq.w	.scorecandidate
	cmpi.w	#$FFFF,tmpdst(a0,d7.w)
	bne.w	.nextplayer
.scorecandidate						;on the bench or ice: rate this player as a shooter
	clr.w	d3
	clr.w	d0
	move.b	pldweight(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	pldlegspd(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	pldlegspd(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	move.b	pldaidef(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	pldaidef(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	move.b	pldstick(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	pldstick(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	move.b	pldendur(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	move.b	pldpass(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	cmp.w	(BA_Skater_Offset).w,d1
	bne.w	.comparebest
	move.w	#$7FFF,d3
.comparebest						;compare with the best
	cmp.w	d6,d3
	blt.w	.nextplayer
	move.w	d3,d6
	move.w	d1,d5
	bra.w	*+4
.nextplayer							;next roster player
	addq.l	#pldsize,a2
	addq.w	#1,d1
	cmp.w	#$1A,d1
	blt.w	.playerloop
.doneplayers						;all players checked
	tst.w	d5
	bmi.w	.noeligible
	move.w	d5,(BA_Skater_Offset).w
.setskaterscnum						;set the skater SCnum
	move.w	#0,(BA_Sktr_SCnum).w
	tst.w	(BA_Team).w
	beq.w	.loadskater
	move.w	#6,(BA_Sktr_SCnum).w
.loadskater							;load the skater
	move.w	(BA_Sktr_SCnum).w,d0
	asl.w	#7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	move.w	(BA_Skater_Offset).w,d3
	bra.w	.eligible
.noeligible							;d5 negative
	move.w	#$FFFF,d0
	bra.w	.exit
.eligible							;found a skater: d0 = 1
	move.w	#1,d0
.exit								;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; puck start for penalty shot/shootout
puckpenshot							;puck start for a penalty shot or shootout: on the first call (pfna) black
									;the screen and set up the shot
	bclr	#pfna,pflags(a3)
	beq.w	.resumeplay
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	forceblack
.waitvblank							;loop
	btst	#dfok,(disflags).w
	bne.s	.waitvblank
	cmpi.w	#$258,(Crowdlevel).w
	bls.w	.setuprink
	move.w	#$258,(Crowdlevel).w
	addi.w	#$14,(CwdExciteLvl).w
.setuprink							;set up the rink
	move.w	(ExtraChars).w,d4
	movea.l	#RefsMap+8,a2
	jsr	(DecompressGraphicsPlain).l
	bset	#dfclock,(disflags).w
	bclr	#sfpz,(sflags).w
	bclr	#sf3llcs,(sflags3).w
	clr.w	(glovecords).w
	clr.b	(iflags).w
	st	(RefCnt).w
	bclr	#sf2refref,(sflags2).w
	st	(passReceiverPlayerNum).w
	bsr.w	ClrHor
	clr.w	(Vpos).w
	clr.w	(Hpos).w
	move.w	#0,(puckx).w
	move.w	#0,(pucky).w
	clr.w	(puckz).w
	clr.w	(puckvx).w
	clr.w	(puckvy).w
	clr.w	(puckvz).w
	st	(puckc).w
	movea.w	#(SortCords+(12*SCstruct)-M68K_RAM),a0	;goal net SCstruct
	clr.w	Xvel(a0)
	clr.w	Yvel(a0)
	clr.w	(a0)
	move.w	#$10C,Ypos(a0)
	adda.w	#$80,a0					;move to second goal net SCstruct
	clr.w	Xvel(a0)
	clr.w	Yvel(a0)
	clr.w	(a0)
	move.w	#$FEF4,Ypos(a0)
	movea.w	#(SortCords+((puckscnum+1)*SCstruct)-M68K_RAM),a0	;puck shadow SCstruct
	move.w	#SPFpuck,frame(a0)
	clr.w	SPA(a0)
	clr.w	attribute(a0)
	clr.w	(SortCords+(puckscnum*SCstruct)+attribute).w
	bclr	#sfslock,(sflags).w
	moveq	#$64,d4
.scrollloop							;run the scroll window 101 times so it settles
	bsr.w	checkwindow
	dbf	d4,.scrollloop
	move.w	#$3C,(yleader).w
	bsr.w	ResetBench
	movea.w	#(tmstruct-M68K_RAM),a2
	bsr.w	setpersonel
	bsr.w	SetupPenaltyShot
	adda.w	#tmsize,a2
	bsr.w	setpersonel
	bsr.w	SetupPenaltyShot
	jsr	(resetplstuff).l
	move.l	a3,-(sp)
	movea.l	#SortCords+(11*SCstruct),a3	;away goalie SCstruct
	move.w	#$B,d2					;11 = # of player SCstructs
.playerloop							;loop over the 12 players: set up the shooter and goalie, park the rest
	cmp.w	(BA_Sktr_SCnum).w,d2
	beq.w	.setupskater
	cmp.w	(BA_Goalie_SCnum).w,d2
	beq.w	.setupgoalie
	move.w	#$FF10,(a3)
	clr.w	Ypos(a3)
	clr.w	frame(a3)
	move.w	#$20,d0
	bsr.w	assinsert
	bra.w	.nextplayer
.setupskater						;d2 = BA_Sktr_SCnum
	tst.w	position(a3)
	bpl.w	.placeskater
	bclr	#2,pflags2(a3)
	beq.w	.placeskater
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d3
	move.b	pnum(a3),d3
	jsr	(setplayer).l
	movem.l	(sp)+,d0-d7/a0-a6
	tst.w	position(a3)
	beq.w	.skaterready
	bpl.w	.placeskater
.skaterready						;shooter on the ice: place him at the puck
	nop
.placeskater						;shooter starts at the puck, facing the goal he shoots at
	move.w	(puckx).w,d0
	subi.w	#0,d0
	move.w	d0,(a3)
	move.w	(pucky).w,d0
	btst	#pfgoal,pflags(a3)
	bne.w	.skaterattop
	addi.w	#$10,d0
	move.w	#4,facedir(a3)
	bra.w	.setskaterpos
.skaterattop						;pfgoal set
	addi.w	#-$10,d0
	move.w	#0,facedir(a3)
.setskaterpos						;set the shooter's y and stop him
	move.w	d0,Ypos(a3)
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	clr.w	Zvel(a3)
	move.w	#$11,d0
	bsr.w	assinsert
	bra.w	.nextplayer
.setupgoalie						;d2 = BA_Goalie_SCnum
	btst	#0,(gmode2).w
	beq.w	.goalieactive
	move.b	(shootoutteam-1).w,pnum(a3)
	tst.w	(shootoutteam).w
	beq.w	.loadgoalieplayer
	move.b	(homeshootnum-1).w,pnum(a3)
	bra.w	.loadgoalieplayer
.goalieactive						;bit 0 of gmode2 clear
	tst.w	position(a3)
	bpl.w	.placegoalie
	bclr	#2,pflags2(a3)
	beq.w	.placegoalie
.loadgoalieplayer					;goalie not on the ice: bring him on
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d3
	move.b	pnum(a3),d3
	jsr	(setplayer).l
	movem.l	(sp)+,d0-d7/a0-a6
	tst.w	position(a3)
	bne.w	.goalieok
	bpl.w	.placegoalie
.goalieok							;goalie on the ice
	nop
.placegoalie						;goalie in his crease, facing out
	bclr	#2,pflags2(a3)
	move.w	#0,d0
	move.w	#$E5,d1
	btst	#pfgoal,pflags(a3)
	bne.w	.goalieattop
	move.w	#$FF1B,d1
.goalieattop						;goalie Y set
	move.w	d0,(a3)
	move.w	d1,Ypos(a3)
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	clr.w	Zpos(a3)
	sub.w	(puckx).w,d0
	sub.w	(pucky).w,d1
	neg.w	d0
	neg.w	d1
	bsr.w	vtoa
	move.w	d0,facedir(a3)
	bclr	#2,pflags2(a3)
	bclr	#pfalock,pflags(a3)
	move.w	#SPAglide,d1
	bsr.w	SetSPA
.nextplayer							;next player
	suba.l	#$80,a3
	dbf	d2,.playerloop				;cycle to next player
	bsr.w	SprSort
	movea.l	(sp)+,a3
	bsr.w	ResetAndSelectPlayers
	move.w	(BA_Goalie_SCnum).w,d0
	asl.w	#7,d0
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3
	move.w	#0,(a3)
	move.w	#$FF06,Ypos(a3)
	btst	#pfgoal,pflags(a3)
	bne.w	.goalieatbottom
	move.w	#$FA,Ypos(a3)
.goalieatbottom						;goalie Y set
	move.w	(BA_Goalie_SCnum).w,d0
	move.w	#1,d1
	btst	#pfteam,pflags(a3)
	beq.w	.checkcont1
	move.w	#2,d1
.checkcont1							;pad for his team
	cmp.w	(cont1team).w,d1
	bne.w	.checkcont2
	jsr	(setc1player).l
	bra.w	.setgoalieassignment
.checkcont2							;d1 <> cont1team
	cmp.w	(cont2team).w,d1
	bne.w	.setgoalieassignment
	jsr	(setc2player).l
.setgoalieassignment				;give the goalie his penalty shot assignment
	move.w	#$E,d0					;assignment D51C?
	bsr.w	assreplace
	bset	#7,(BA_PS_flags).w
	bset	#sf2drec,(sflags2).w
	move.w	#$190,(msgtimer).w
	tst.w	(cont1team).w
	bne.w	.finishsetup
	tst.w	(cont2team).w
	bne.w	.finishsetup
	move.w	#$64,(msgtimer).w
.finishsetup						;finish the setup
	move.w	#$18,(palcount).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.resumeplay							;pfna was clear
	bset	#2,(gmode2).w
	move.w	#$18,d0					;pucknorm
	bsr.w	assreplace
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	rts
	dc.b	0,1,2,3,4,5,6,0,0,1,5,3,4,2,0,0
	dc.b	0,3,5,1,4,0,0,0,0,0,$FF,6,$FF,$DD,$FF,$CE
	dc.b	0
	dc.b	$23						;#
	dc.b	$FF,$CE,$FF,$CE,$FF,$F6,0,0,$FF,$F1,0
	dc.b	$32						;2
	dc.b	$FF,$F6,0,0,$FF,$C4
UpdatePenaltyShotEnd				;end the penalty shot when the goalie has the puck, the puck is loose or
									;the timer runs out
	movem.w	d0,-(sp)
	move.w	(puckc).w,d0
	cmp.w	(BA_Goalie_SCnum).w,d0
	movem.w	(sp)+,d0
	beq.w	.setended
	btst	#5,(BA_PS_flags).w
	beq.w	.checktimer
	btst	#5,(gmode2).w
	bne.w	.puckloose
	tst.w	(puckc).w
	bpl.w	.countdown
	bset	#5,(gmode2).w
.puckloose							;puck loose
	tst.w	(puckc).w
	bpl.w	.setended
.countdown							;count down the shot clock
	tst.w	(passmodetimer).w
	bmi.w	.setended
	subq.w	#1,(passmodetimer).w
	bra.w	.checktimer
.setended							;pass mode timer out: the attempt is over
	bset	#4,(BA_PS_flags).w
.checktimer							;shootout clock out: the attempt is over
	tst.w	(shootoutclock).w
	bne.w	.checkended
	bset	#4,(BA_PS_flags).w
.checkended							;check the end
	btst	#4,(BA_PS_flags).w
	bne.w	.finishshot
	rts
.finishshot							;bit 4 of BA_PS_flags set
	btst	#6,(BA_PS_flags).w
	bne.w	PenaltyShotEndReturn
	bset	#6,(BA_PS_flags).w
	move.w	#$A,d0
	jsr	(AddPenalty2).l
EndPenaltyShotPlay					;stop play after a penalty shot or shootout attempt: freeze the window,
									;stop the clock, clear the penalty shot flags
	jsr	(freezewindow).l
	btst	#0,(gmode2).w
	bne.w	.stopplay
	move.w	#$A,(replaydelay).w
	bset	#sf2drec,(sflags2).w
.stopplay							;stop play
	bset	#gmclock,(gmode).w
	bclr	#2,(gmode2).w
	bclr	#2,(BA_PS_flags).w
	bclr	#3,(BA_PS_flags).w
	bclr	#5,(BA_PS_flags).w
	bclr	#4,(BA_PS_flags).w
	bclr	#6,(BA_PS_flags).w
	movem.l	d0/a0,-(sp)
	movea.l	#SortCords,a0
	move.w	(BA_Sktr_SCnum).w,d0
	asl.w	#7,d0
	move.b	(savednewpnum).w,newpnum(a0,d0.w)
	movem.l	(sp)+,d0/a0
	jsr	(CountShootoutGoals).l
PenaltyShotEndReturn				;penalty shot already finished: return without adding another
	rts
; this is where the action starts
puckfaceoff							;puck controller for the face off: a3 = the face off controller (shootout
									;mode skips to its own setup)
	bclr	#4,(sflags8).w
	btst	#0,(gmode2).w
	beq.w	.normalfaceoff
	clr.w	(puckvx).w
	clr.w	(puckvy).w
	move.w	#$1E,d0					;assignment ECB6?
	bra.w	assreplace
.normalfaceoff						;bit 0 of gmode2 clear
	bclr	#pfna,pflags(a3)
	beq.w	WaitForFaceoffLineChanges
	bclr	#0,(sflags8).w
	beq.w	.resetpads
	clr.w	(fox).w
	clr.w	(foy).w
.resetpads							;reset the pads
	bclr	#7,(sflags7).w
	clr.l	(padcont).w
	clr.l	(padcont+4).w
	clr.l	(padcont+8).w
	bclr	#6,(sflags7).w
	bclr	#2,(sflags7).w
	jsr	(CheckScoreLeader).l
	tst.w	(faceoffanim).w
	bmi.w	.choosefaceoffspot
	move.w	(faceoffanim).w,d0
	bra.w	.handlefaceoffspot
.choosefaceoffspot					;faceoffanim negative
	jsr	(RandomFaceoffAnim).l
	tst.w	d0
	bmi.w	.checkperiod
.handlefaceoffspot					;set the faceoff animation for the spot
	jsr	(SetFaceoffAnim).l
.checkperiod						;period check
	bclr	#1,(sflags6).w
	bclr	#1,(gmode2).w
	tst.w	(gameclock).w
	beq.w	PeriodOver
	btst	#gmeog,(gmode).w
	bne.w	PeriodOver
	cmpi.w	#3,(gsp).w
	bne.w	.npo
	move.w	(HmGoals).w,d0
	cmp.w	(AwGoals).w,d0
	bne.w	clockcont_0
.npo								;no overtime win
	btst	#gmpendel,(gmode).w
	bne.w	Stop4Pen
	move.w	(PerTimeTotal).w,d0
	asr.w	#1,d0
	cmp.w	(gameclock).w,d0
	bls.w	.returngoalies
	cmpi.w	#$3C,(gameclock).w
	blt.w	.returngoalies
	bclr	#sf3fosong,(sflags3).w
	beq.w	.returngoalies
	btst	#gmclock,(gmode).w
	beq.w	.returngoalies
	btst	#6,(sflags8).w
	bne.w	.returngoalies
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#SngFaceoff,(SongIndex).w
	jsr	(ChooseSong).l
	bset	#4,(sflags8).w
.returngoalies						;return pulled goalies and start the faceoff timers
	bsr.w	ReturnGoalies
	st	temp1(a3)
	st	temp2(a3)
	tst.w	(OptLine).w
	bne.w	WaitForFaceoffLineChanges
	bclr	#tmflcm,(tmstruct+tmflags).w
	bclr	#tmflcm,(awtmstruct+tmflags).w
	movea.w	#(SortCords-M68K_RAM),a0
	moveq	#$B,d0
.clearlcmloop						;loop: clear the line change mode of all 12 players
	bclr	#pf2lcm,pflags2(a0)
	adda.w	#SCstruct,a0
	dbf	d0,.clearlcmloop
	move.w	(cont1team).w,d0
	or.w	(cont2team).w,d0
	beq.w	.checkc1line
	btst	#sfhor,(sflags).w
	beq.w	.checkc1line
	bsr.w	forceblack
	bset	#sfslock,(sflags).w
	bsr.w	ClrHor
	move.w	#$18,(palcount).w
	tst.w	(OptLine).w
	bne.w	.checkc1line
	btst	#4,(sflags7).w
	beq.w	.checkc1line
	clr.w	(palcount).w
.checkc1line						;start the line change box for each pad's team
	move.w	(c1playernum).w,d0
	bmi.w	.checkc2line
	bsr.w	StartFaceoffLineChange
.checkc2line						;pad 2 line change
	move.w	(c2playernum).w,d0
	bmi.w	.checkcomputerline
	bsr.w	StartFaceoffLineChange
.checkcomputerline					;computer line change
	movea.w	#(tmstruct-M68K_RAM),a1
	lea	tmsize(a1),a2
	moveq	#2,d0
	bsr.w	SetFaceoffComputerLine
	bra.w	WaitForFaceoffLineChanges
SetFaceoffComputerLine				;faceoff: start a line change for team d0 when the computer controls it
									;(line changes on)
	tst.w	(OptLine).w
	bne.w	rtss2
	btst	#4,(sflags7).w
	bne.w	.dochange
	cmp.w	(cont1team).w,d0
	beq.w	rtss2
	cmp.w	(cont2team).w,d0
	beq.w	rtss2
.dochange							;change the line
	bsr.w	CompLine
	bsr.w	setpersonel
	bsr.w	printscores1
	move.w	#$2710,(crowdnoisedelay).w
	rts
StartFaceoffLineChange				;start the line change box for team d0's sort object before a faceoff
	exg	a2,a3
	asl.w	#7,d0
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3
	bclr	#3,pflags2(a3)
	move.l	a2,-(sp)
	bsr.w	SetLCmode
	movea.l	(sp)+,a2
	btst	#3,pflags2(a3)
	beq.w	.exit
	btst	#pfteam,pflags(a3)
	beq.w	.homeplayer
	move.w	#$168,temp2(a2)
	move.w	SCnum(a3),temp4(a2)
	bra.w	.exit
.homeplayer							;pfteam clear
	move.w	#$258,temp1(a2)
	move.w	SCnum(a3),temp3(a2)
.exit								;return with a2/a3 swapped back
	exg	a2,a3
	rts
WaitForFaceoffLineChanges			;run both teams' faceoff line change timers (temp1 / temp2); continue when
									;both have run out
	move.w	#$40,d0
	bsr.w	UpdateFaceoffLineChangeTimer
	move.w	#$42,d0
	bsr.w	UpdateFaceoffLineChangeTimer
	tst.w	temp1(a3)
	bpl.w	rtss2
	tst.w	temp2(a3)
	bpl.w	rtss2
	movea.w	#(tmstruct-M68K_RAM),a2
	lea	tmsize(a2),a1
	moveq	#1,d0
	bsr.w	SetFaceoffComputerLine
	move.w	#$FFFF,(facelcwait).w
	move.w	#$1C,d0					;puckfaceoff2
	bra.w	assreplace
UpdateFaceoffLineChangeTimer		;count down one team's faceoff line change timer at offset d0 of a3
	tst.w	0(a3,d0.w)
	bmi.w	rtss2
	move.w	4(a3,d0.w),d1
	asl.w	#7,d1
	movea.w	#(SortCords-M68K_RAM),a0
	movea.w	#(tmstruct-M68K_RAM),a2
	btst	#6,pflags(a0,d1.w)
	beq.w	.checkactive
	adda.w	#tmsize,a2
.checkactive						;a2 = that team's struct: still in line change mode, count down
	btst	#pf2lcm,pflags2(a0,d1.w)
	bne.w	.countdown
	st	0(a3,d0.w)
	bra.w	SetLCmode2
.countdown							;pf2lcm set
	sub.w	d7,0(a3,d0.w)
	bpl.w	rtss2
	move.l	a3,-(sp)
	lea	0(a0,d1.w),a3
	btst	#3,pflags2(a3)
	beq.w	.exit
	clr.w	d2
	bsr.w	lcfound
	bsr.w	SetLCmode2
.exit								;done
	movea.l	(sp)+,a3
	rts
; computer pulls goalie on delayed penalty
ChkGoalies							;computer pulls goalie on delayed penalty. Called from periodicevents
	btst	#gmclock,(gmode).w		;check if clock running
	bne.w	rtss2
	movea.w	#(tmstruct-M68K_RAM),a2	;a2 = team being tested, a1 = the other team
	lea	tmsize(a2),a1
	moveq	#1,d0					;d0 = team number (1 home, 2 visitors)
	bsr.w	.chkgoalie
	moveq	#2,d0
	exg	a1,a2
.chkgoalie							;local subroutine
	tst.w	tmgoalie(a2)			;check for goalie
	bmi.w	rtss2					;no goalie, exit
	move.w	(puckc).w,d1			;move puck carrier SCnum into d1
	bmi.w	rtss2
	subq.w	#6,d1
	cmpa.w	#(tmstruct-M68K_RAM),a2
	beq.w	.chkpen
	not.w	d1						;makes d1 negative if away team
.chkpen								;penalty check
	tst.w	d1
	bpl.w	rtss2
	btst	#gmpendel,(gmode).w		;#gmpendel - delayed penalty called
	beq.w	.nopen
	st	tmgoalie(a2)				;sets to FFFF (no goalie)
	bra.w	setpersonel
.nopen								;gmpendel clear
	cmp.w	(cont1team).w,d0
	beq.w	rtss2					;exit if team is joy controlled
	cmp.w	(cont2team).w,d0
	beq.w	rtss2					;exit if team is joy controlled
	move.w	(pucky).w,d1
	bra.w	CPgoalie
; if computer pulled goalie, look to see if computer should return him
ReturnGoalies						;if computer pulled goalie, look to see if computer should return him.
									;Called from puckfaceoff
	movea.w	#(tmstruct-M68K_RAM),a2	;a2 = team being tested, a1 = the other team
	lea	tmsize(a2),a1
	moveq	#1,d0					;d0 = team number
	bsr.w	.r						;home team first ...
	moveq	#2,d0
	exg	a1,a2						;... then fall into .r for the visitors
.r									;local subroutine
	cmpi.w	#$FFFF,tmgoalie(a2)
	beq.w	rtss2					;still no goalie
	clr.b	tmgoalie(a2)			;clear for goalie return
	cmp.w	(cont1team).w,d0
	beq.w	rtss2					;exit if team is joy controlled
	cmp.w	(cont2team).w,d0
	beq.w	rtss2					;exit if team is joy controlled
	move.w	(foy).w,d1
; see if computer should pull his goalie
; d1 = Faceoff Y position
CPgoalie							;see if computer should pull his goalie. d1 = puck/faceoff y. Falls in
									;from ReturnGoalies; also entered from ChkGoalies
	cmpi.w	#2,(gsp).w				;check if 3rd period
	bne.w	rtss2					;exit if not
	move.w	tmscore(a1),d0			;tmscore
	sub.w	tmscore(a2),d0
	bmi.w	rtss2					;exit if leading in the game
	cmp.w	#2,d0
	bne.w	rtss2					;exit if behind by more than 2
	cmpi.w	#$3C,(gameclock).w		;#60
	bgt.w	rtss2					;exit if more than 1 min left
	move.l	a0,-(sp)
	movea.w	tmsort(a2),a0			;moves a player struct address into a0
	btst	#pfgoal,pflags(a0)		;#pfgoal
	movea.l	(sp)+,a0
	bne.w	.0
	neg.w	d1						;make y positive toward the goal I shoot at
.0									;Y for his end
	tst.w	d1
	bmi.w	rtss2					;exit if d1 negative (faceoff in own zone)
	st	tmgoalie(a2)				;set to FFFF (no goalie)
	bra.w	setpersonel
; find good line for comp to switch to
CompLine							;find good line for comp to switch to. a2 = team, a1 = other team. Called
									;from chk4lc and puckfaceoff
	movem.l	d0-d2/a0,-(sp)
	moveq	#3,d0					;d0 = first of the 2 special lines (3-4) used with a man advantage
	move.w	tmap(a2),d1				;tmap
	sub.w	tmap(a1),d1				;compare the numbers of active players
	beq.w	.nopwr					;equal: normal line
	bpl.w	.0
	addq.w	#2,d0					;fewer players: lines 5-6 instead
.0									;d0 = line set (+2 when short handed): pick the freshest line
	move.w	d0,-(sp)				;find pk/pp line
	bsr.w	getlinee				;d0 = energy of the first candidate
	move.w	d0,d1
	move.w	(sp),d0
	addq.w	#1,d0
	bsr.w	getlinee				;d0 = energy of the second candidate
	cmp.w	d0,d1
	bge.w	.1
	addq.w	#1,(sp)					;second one has more energy: take it
.1									;more rested player chosen
	move.w	(sp)+,tmline(a2)		;tmline
.ex									;exit: restore the registers
	movem.l	(sp)+,d0-d2/a0
	rts
.nopwr								;d1 = 0
	cmpa.w	#(tmstruct-M68K_RAM),a2	;find normal line
	bne.w	.away					;visitors use the other table
	moveq	#2,d1
	lea	.hl1(pc),a0					;a0 = row of .hl1 (7 words, indexed by the other team's line)
	cmpi.w	#2,(gsp).w
	bne.w	.h0						;not 3rd period: first row
	move.w	tmscore(a2),d2			;tmscore
	cmp.w	tmscore(a1),d2
	beq.w	.h0						;tied: first row
	adda.w	#$E,a0					;(adda keeps the flags of the cmp) next row ...
	bgt.w	.h0						;... if leading
	adda.w	#$E,a0					;third row if trailing
.h0									;a0 = the line order row for the score (tied, leading, trailing)
	move.w	tmline(a1),d1			;tmline
	asl.w	#1,d1
	move.w	0(a0,d1.w),d0
	bsr.w	getlinee
	cmp.w	#$C00,d0				;#(3*$1000)/4
	bls.w	.away
	move.w	0(a0,d1.w),tmline(a2)	;tmline
	bra.s	.ex
.hl1								;line order table for the home team
	dc.w	0
	dc.w	1
	dc.w	2
	dc.w	0
	dc.w	1
	dc.w	0
	dc.w	1
	dc.w	2
	dc.w	0
	dc.w	1
	dc.w	2
	dc.w	0
	dc.w	2
	dc.w	0
	dc.w	0
	dc.w	1
	dc.w	0
	dc.w	0
	dc.w	1
	dc.w	0
	dc.w	1
.away								;a2 <> tmstruct or d0 <= $C00
	moveq	#2,d1					;try up to 3 lines in the row order
	lea	.al1(pc),a0
	cmpi.w	#2,(gsp).w
	bne.w	.a0
	move.w	tmscore(a2),d2			;tmscore
	cmp.w	tmscore(a1),d2
	beq.w	.a0						;tied or not 3rd period: first row
	addq.w	#6,a0					;(flags of the cmp are kept) next row ...
	bgt.w	.a0						;... if leading
	addq.w	#6,a0					;third row if trailing
.a0									;try the lines in order until one has energy over 3/4
	move.w	(a0)+,d0
	bsr.w	getlinee
	cmp.w	#$C00,d0				;#(19*$1000)/20
	dbhi	d1,.a0					;energy above 3/4: stop, else try the next
	move.w	-(a0),tmline(a2)		;tmline
	bra.w	.ex
.al1								;line order table for the away team
	dc.w	0
	dc.w	1
	dc.w	2
	dc.w	0
	dc.w	2
	dc.w	1
	dc.w	0
	dc.w	1
	dc.w	0
; face off control logic and general setup for action
puckfaceoff2						;face off control logic and general setup for action a3 = the puck. First
									;call sets the whole face off up (players, puck, scoreboard box, map);
									;later calls count temp1 down to the drop (updatefaceoff / Endfaceoff)
	bclr	#pfna,pflags(a3)		;new assignment? (clears the flag)
	beq.w	.nna					;not first time thru
	bclr	#2,(BA_PS_flags).w
	bclr	#5,(BA_PS_flags).w
	bclr	#0,(sflags4).w
	bclr	#1,(sflags4).w
	bclr	#0,(DelayedPen).w
	bclr	#1,(DelayedPen).w
	bclr	#2,(DelayedPen).w
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	forceblack
.p									;loop
	btst	#dfok,(disflags).w
	bne.s	.p
	move	sr,-(sp)
	move.w	#$3C,(holdreset).w
	tst.w	(fox).w
	bne.w	.lockinterrupts
	tst.w	(foy).w
	bne.w	.lockinterrupts
	move.w	#$FFFF,(faceoffanim).w
	bra.w	.limitcrowd
.lockinterrupts						;fox <> 0 or foy <> 0
	move	#$2700,sr
.limitcrowd							;cap the crowd level
	cmpi.w	#$258,(Crowdlevel).w
	bls.w	.ntm
	move.w	#$258,(Crowdlevel).w	;limit crowd level
.ntm								;crowd level set
	bset	#dfclock,(disflags).w	;stop clock
	bclr	#sfpz,(sflags).w		;no pause
	bclr	#sf3llcs,(sflags3).w	;no line changes
	clr.w	(glovecords).w			;no fighting gloves
	clr.b	(iflags).w				;no icing
	st	(RefCnt).w					;no refs
	st	(puckcross2).w				;no goalie moves
	st	(puckcross6).w
	bclr	#sf2refref,(sflags2).w	;no ref refresh
	bset	#sf2faceoff,(sflags2).w	;face off in progress
	bset	#sf2drec,(sflags2).w	;dont record yet
	st	(passReceiverPlayerNum).w
	st	(onetimerplayer).w
	bset	#dffaceoff,(disflags).w
	bsr.w	ClrHor					;vertical ice rink
	move.w	#$2710,(crowdnoisedelay).w
	clr.w	(Vpos).w				;clear h/v pos
	clr.w	(Hpos).w
	move.w	(fox).w,(puckx).w		;puck on the face off spot (fox/foy)
	move.w	(foy).w,(pucky).w
	st	(puckz).w					;no visible puck
	clr.w	(puckvx).w
	clr.w	(puckvy).w
	clr.w	(puckvz).w
	st	(puckc).w					;nobody carries it
	movea.w	#(SortCords+(12*SCstruct)-M68K_RAM),a0	;reposition goal nets
	clr.w	Xvel(a0)				;Xvel
	clr.w	Yvel(a0)				;Yvel
	clr.w	(a0)					;Xpos
	move.w	#$10C,Ypos(a0)			;Ypos
	adda.w	#SCstruct,a0			;add SCstruct to move to next goal net
	clr.w	Xvel(a0)
	clr.w	Yvel(a0)
	clr.w	(a0)
	move.w	#$FEF4,Ypos(a0)			;Ypos
	movea.w	#(SortCords+((puckscnum+1)*SCstruct)-M68K_RAM),a0	;move to puck shadow SCnum
	move.w	#SPFpuck,frame(a0)
	clr.w	SPA(a0)					;SPA
	clr.w	attribute(a0)			;attribute
	clr.w	(SortCords+(puckscnum*SCstruct)+attribute).w	;clear puck SCnum attribute
	bclr	#sfslock,(sflags).w		;free up scrolling
	moveq	#$64,d4					;run the scroll window 101 times so it settles
.cw									;run the scroll window 101 times so it settles
	bsr.w	checkwindow				;scroll to faceoff spot
	dbf	d4,.cw
	move.w	#$3C,(yleader).w
	bsr.w	ResetBench
	movea.w	#(tmstruct-M68K_RAM),a2	;set personnel and player data for both teams
	bsr.w	setpersonel
	bsr.w	forcepldata
	adda.w	#tmsize,a2
	bsr.w	setpersonel
	bsr.w	forcepldata
	bsr.w	resetplstuff
	move.l	a3,-(sp)				;keep the puck pointer
	movea.w	#(SortCords-M68K_RAM),a3
	moveq	#$B,d2					;loop over the 12 players
.10									;loop over the 12 players: park them off ice, then set the faceoff spots
	move.w	#$FF10,(a3)				;-240, Xpos
	clr.w	Ypos(a3)				;Ypos
	clr.w	frame(a3)				;frame
	move.w	position(a3),d1			;position
	bmi.w	.next					;absent
	beq.w	.goalie1				;goalie: no assignment change
	move.l	#$16,d0					;#afaceoff - assignment faceoff
	cmp.w	#4,d1					;find the center (position 4)
	bne.w	.11
	movea.w	#(tmstruct-M68K_RAM),a2
	btst	#pfteam,pflags(a3)		;#pfgoal - what goal to score on
	beq.w	.clr
	adda.w	#tmsize,a2
.clr								;clear the touches
	clr.w	tmtouch1(a2)
	move.b	pnum(a3),tmtouch1+1(a2)	;this player is the last touch
	bclr	#7,(sflags8).w
	st	tmtouch2(a2)				;clear last player to touch puck (assist 1)
	st	tmtouch3(a2)				;clear second last player to touch puck (assist 2)
	bclr	#tmflast,tmflags(a2)
	move.l	#$17,d0					;#afaceoffpl - faceoff player assignment
.11									;player position
	bsr.w	assinsert
.goalie1							;d4 = active players of this player's team
	move.w	(tmstruct+tmap).w,d4	;tmap = active players on ice (4-6). (tmap).w
	btst	#pfteam,pflags(a3)		;#pfteam - 0=home 1=away
	beq.w	.t0
	move.w	(awtmstruct+tmap).w,d4	;(tmsize).w
.t0									;players to place
	neg.w	d4						;d4 = 6 - active players: formation row
	addq.w	#6,d4					;6 - active players
	asl.w	#3,d4					;8 bytes per row of .apl
	movea.l	#.apl,a1
	adda.w	d4,a1					;row for this team size ...
	move.b	0(a1,d1.w),d4
	asl.w	#2,d4
	movea.l	#.ptab,a1
	move.w	0(a1,d4.w),d0
	move.w	2(a1,d4.w),d1
	btst	#pfgoal,pflags(a3)		;#pfgoal - 0=bottom, 1=top
	bne.w	.f0
	neg.w	d0						;mirror for the team shooting the other way
	neg.w	d1
.f0									;coordinates for his end
	tst.w	position(a3)			;check for goalie
	beq.w	.goalie2
	cmp.w	#8,d4
	bgt.w	.nodef					;slots above 2 are not shifted by the spot
	move.w	(fox).w,d3
	eor.w	d0,d3
	bpl.w	.notmid					;fox and slot x on the same side
	move.w	(foy).w,d3
	asr.w	#3,d3
	sub.w	d3,d1					;opposite side: also pull y toward the spot
.notmid								;pull the slot x toward the faceoff spot
	move.w	(fox).w,d3				;pull x toward the spot by fox/4
	asr.w	#2,d3
	sub.w	d3,d0
.nodef								;set the position
	add.w	(fox).w,d0
	add.w	(foy).w,d1
.goalie2							;place the player at the slot plus the spot
	move.w	d0,(a3)					;Xpos
	move.w	d1,Ypos(a3)				;Ypos
	clr.w	Xvel(a3)				;Xvel
	clr.w	Yvel(a3)				;Yvel
	sub.w	(puckx).w,d0
	sub.w	(pucky).w,d1
	neg.w	d0
	neg.w	d1
	bsr.w	vtoa					;face the direction from the puck to the player
	move.w	d0,facedir(a3)			;facedir
	bclr	#pf2unav,pflags2(a3)	;#pf2unav
	bclr	#pfalock,pflags(a3)		;#pfalock
	move.w	#SPAglide,d1
	bsr.w	SetSPA					;glide animation
.next								;next player
	adda.w	#$80,a3					;#Scstruct
	dbf	d2,.10
	bsr.w	SprSort
	movea.l	(sp)+,a3
	bsr.w	ResetAndSelectPlayers
	move.w	(ExtraChars).w,d4
	movea.l	#FaceOffMap+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(faceoffvrcset).w
	movea.l	#FaceOffSprites+8,a2
	bsr.w	DecompressGraphicsPlain
	move.w	#$FFFF,(arenaanim).w
	btst	#0,(sflags7).w
	beq.w	.drawfaceoffwindow
	move.w	(faceoffanim).w,d0
	bmi.w	.drawfaceoffwindow
	jsr	(StartArenaAnim).l
.drawfaceoffwindow					;draw the faceoff window
	bsr.w	printz
	dc.b	0,6,$FF,0,0,0
	moveq	#$36,d0					;X Position of the faceoff window
	tst.w	(fox).w
	bpl.w	.fok
	move.w	#$BE,d0					;(18*8)+46
.fok								;faceoff X set
	move.w	d0,(fodropx).w			;drop box x: left or right depending on the sign of fox
	subi.w	#$2E,d0
	asr.w	#3,d0
	move.w	d0,(printx).w			;print column = (x - 46) / 8
	moveq	#$5C,d0					;Y position of the faceoff window
	move.w	d0,(fodropy).w
	subi.w	#$44,d0
	asr.w	#3,d0
	move.w	d0,(printy).w			;print row = (y - 68) / 8
	move.w	(ExtraChars).w,d4		;space for faceoff map
	movea.l	#FaceOffMap,a0			;a0/a1 = the two bitmaps found via the offsets at the start
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0						;d0/d1 = 0, d2/d3 = $C/$A (dobitmap size arguments)
	clr.w	d1
	moveq	#$C,d2
	moveq	#$A,d3
	moveq	#0,d5
	bset	#0,(sflags6).w
	bsr.w	dobitmap
	bclr	#0,(sflags6).w
	tst.w	(OptLine).w
	bne.w	.setdroptime
	bsr.w	printsmallz
	String	CC_AddY,$A,CC_SetAttribute,4	;$FBC2. ori.b #$A,d6 and drops the $FE04 word
	moveq	#$C,d0					;frame the line names box (Framer args d0 = $C, d1 = 3)
	moveq	#3,d1
	bsr.w	Framer
	move.w	(tmstruct+tmline).w,d0	;d0/d1 = current lines of home / visitors
	move.w	(awtmstruct+tmline).w,d1
	btst	#gmdir,(gmode).w
	bne.w	.printline2
	exg	d0,d1
.printline2							;print the line names
	bsr.w	printsmallz
	String	CC_AddX,1,CC_AddY,$FE
	movea.l	#linelist,a1
	bsr.w	Fprintsmall				;first line name (d0)
	addq.w	#4,(printx).w
	move.w	d1,d0
	movea.l	#linelist,a1
	bsr.w	Fprintsmall				;second line name (d1)
.setdroptime						;drop time
	move.w	#$78,d0					;random time before the puck drop
	bsr.w	randomd0				;0-$77
	addi.w	#$B4,d0					;$B4-$12B frames until the drop
	cmpi.w	#0,(arenaanim).w
	beq.w	.chkmintime
	cmpi.w	#1,(arenaanim).w
	beq.w	.chkmintime
	cmpi.w	#5,(arenaanim).w
	beq.w	.chkmintime
	cmpi.w	#4,(arenaanim).w
	beq.w	.chkmintime
	cmpi.w	#2,(arenaanim).w
	bne.w	.time
.chkmintime							;an arena animation is running: wait at least $10E frames
	cmp.w	#$10E,d0
	bgt.w	.time
	move.w	#$10E,d0				;sets minimum value in d0 to 10E
.time								;set the drop time
	move.w	d0,temp1(a3)			;time for puck drop
	move.w	#$18,(palcount).w
	movea.l	#fofdata2,a0			;second half of the big face off sprite data
	move.w	#1,(a0)
	move.w	#$8000,foattr(a0)
	move.w	#4,fosize+foframe(a0)
	move.w	#$A800,fosize+foattr(a0)
	move.w	#7,2*fosize+foframe(a0)	;frame of ref
	move.w	#$8000,2*fosize+foattr(a0)
	btst	#gmdir,(gmode).w		;#gmdir - 0 = home team goes up
	bne.w	.nfl
	eori.w	#$800,foattr(a0)		;flip attribute bit $800 (two of the sprites) when gmdir is clear
	eori.w	#$800,fosize+foattr(a0)
.nfl								;draw the faceoff sprites
	move.w	#$FFFF,(fodir1).w		;-1
	move.w	#$FFFF,(fodir2).w		;-1
	jsr	(LeadSong).l
	bclr	#6,(sflags8).w
	bne.w	.playqueuedsong
	bclr	#4,(sflags8).w
	beq.w	.restorestate
.playqueuedsong						;play the queued song
	bclr	#4,(sflags8).w
	move.w	(SongNum).w,-(sp)
	bsr.w	song
.restorestate						;restore the state
	move.w	#$18,(palcount).w
	move	(sp)+,sr
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.nna								;pfna was clear
	subq.w	#1,temp1(a3)
	bpl.w	updatefaceoff
	jsr	(EndArenaAnim).l
	bra.w	Endfaceoff
.apl	dc.b	0
	dc.b	1,2,3,4,5,6,0,0,1,5,3,4,2,0,0,0
	dc.b	3,5,1,4,0,0,0
.ptab								;faceoff slot offsets by position (x, y pairs)
	dc.w	0
	dc.w	$FF06
	dc.w	$FFDD
	dc.w	$FFCE
	dc.w	$23
	dc.w	$FFCE
	dc.w	$FFCE
	dc.w	$FFF6
	dc.w	0
	dc.w	$FFF1
	dc.w	$32
	dc.w	$FFF6
	dc.w	0
	dc.w	$FFC4
ResetAndSelectPlayers				;c1playernum / c2playernum = -1, then changeplayer for each human team
	move.w	#$FFFF,(c1playernum).w
	move.w	#$FFFF,(c2playernum).w
	tst.w	(cont1team).w
	beq.w	.checkcont2
	clr.w	d4
	bsr.w	changeplayer
.checkcont2							;pad 2
	tst.w	(cont2team).w
	beq.w	.checkcont3
	moveq	#2,d4
	bsr.w	changeplayer
.checkcont3							;pads 3 and 4
	tst.w	(cont3team).w
	beq.w	.checkcont4
	move.w	(cont1team).w,-(sp)
	move.w	(cont3team).w,(cont1team).w
	move.w	(c1playernum).w,-(sp)
	move.w	#$FFFF,(c1playernum).w
	clr.w	d4
	jsr	(changeplayer).l
	move.w	(c1playernum).w,(c3playernum).w
	move.w	(cont1team).w,(cont3team).w
	move.w	(sp)+,(c1playernum).w
	move.w	(sp)+,(cont1team).w
.checkcont4							;restore pad 4
	tst.w	(cont4team).w
	beq.w	.exit
	move.w	(cont2team).w,-(sp)
	move.w	(cont4team).w,(cont2team).w
	move.w	(c2playernum).w,-(sp)
	move.w	#$FFFF,(c2playernum).w
	move.w	#2,d4
	jsr	(changeplayer).l
	move.w	(c2playernum).w,(c4playernum).w
	move.w	(cont2team).w,(cont4team).w
	move.w	(sp)+,(c2playernum).w
	move.w	(sp)+,(cont2team).w
.exit								;exit (also the end of the code above)
	rts
updatefaceoff						;a3 = puck. Drop animation frame from temp1; at 0 erases the faceoff box
	move.w	temp1(a3),d0			;frames left until the drop
	beq.w	.erase					;0: remove the face off box
	addq.w	#6,d0
	lsr.w	#3,d0					;(temp1 + 6) / 8
	cmp.w	#2,d0
	bgt.w	rtss2
	neg.w	d0
	addi.w	#$A,d0					;frame $A - d0 (8 to 10) as the drop approaches
	move.w	d0,(fofdata).w			;+8
	rts
.erase								;d0 = 0
	bclr	#dffaceoff,(disflags).w
	bsr.w	printz
	String	CC_Font1Pri,0,0,0
	move.w	(fodropx).w,d0
	subi.w	#$2E,d0
	asr.w	#3,d0
	move.w	d0,(printx).w			;same print column as in puckfaceoff2
	moveq	#$64,d0					;(4*8)+68, overwritten (as in 92)
	move.w	(fodropy).w,d0
	subi.w	#$44,d0
	asr.w	#3,d0
	move.w	d0,(printy).w
	moveq	#$C,d0					;eraser: d0/d1 = x/y size, d2 = fill char word
	moveq	#$D,d1
	move.w	#$7FF,d2
	bra.w	eraser
Endfaceoff							;drop the puck: pick the faceoff winner and send the puck off
	move.w	#SFXpuckice+3,-(sp)		;SFXpuckice
	bsr.w	sfx
	bclr	#sf2faceoff,(sflags2).w	;face off over
	move.w	#$3C,(holdreset).w
	move.w	(ExtraChars).w,d4
	movea.l	#RefsMap+8,a2
	bsr.w	DecompressGraphicsPlain	;ref cam chars
	bclr	#sf2drec,(sflags2).w	;replay recording may start
	bclr	#gmclock,(gmode).w		;start the game clock
	bclr	#pf2fight,pflags2(a3)
	clr.w	(crowdnoisedelay).w
	bset	#sf3fo,(sflags3).w		;flag the faceoff drop
	move.w	(fodir1).w,d3			;figure out who won face off
	move.w	#$800,d4				;d4 = y velocity added to the puck: +$800 ...
	movea.l	#.ftab,a0
	movea.w	#(fofdata2-M68K_RAM),a1	;a1 = the two face off sprite records
	moveq	#$10,d2
	move.w	(a1),d1					;first record's word 0 (index into .ftab, 1-based)
	sub.b	-1(a0,d1.w),d2			;d2 = $10 - .ftab[first] ...
	move.w	fosize+foframe(a1),d1
	add.b	-1(a0,d1.w),d2			;... + .ftab[second]
	moveq	#$21,d0
	bsr.w	randomd0				;random 0-$20
	cmp.b	d0,d2
	bls.w	.p1won					;d2 <= random: stay with the first record
	addq.w	#4,a1					;else use the second record
.p1won								;faceoff record chosen
	btst	#3,foattr(a1)			;bit 3 of the winner's attribute word ($800 flips)
	beq.w	.pos
	move.w	(fodir2).w,d3			;visiting player won: use his pull direction ...
	neg.w	d4						;... and push the puck the other way (-$800)
.pos								;d0 = the winner's pull direction (bit 3 = none: random)
	move.w	d3,d0					;d0 = winner's pull direction; bit 3 set = no joystick
	btst	#3,d0
	bne.w	.nojoy
	andi.w	#7,d0
	move.w	(HVcount).l,d1			;hvcount
	andi.w	#3,d1
	bne.w	.nj2					;3 in 4: use his direction as is
.nojoy								;random direction
	moveq	#5,d0					;no direction (or 1 in 4): random 0-4 ...
	bsr.w	randomd0
	subq.w	#2,d0
	andi.w	#7,d0					;... minus 2, wrapped to 0-7
	tst.w	d4
	bmi.w	.nj2
	eori.w	#4,d0					;home won: turn the direction around
.nj2								;faceoff direction set
	asl.w	#2,d0
	movea.l	#dirtab,a0
	move.w	0(a0,d0.w),d1
	asl.w	#5,d1
	move.w	d1,Xvel(a3)				;puck x velocity = dirtab x * 32
	move.w	2(a0,d0.w),d1
	asl.w	#5,d1
	add.w	d4,d1
.setpuckvy							;puck y velocity from dirtab, then a random lift
	move.w	d1,Yvel(a3)				;puck y velocity = dirtab y * 32 +- $800
	move.w	#$800,d0
	bsr.w	randomd0
	move.w	d0,Zvel(a3)				;random upward velocity 0-$7FF
	clr.w	(puckz).w				;puck now at ice level (visible)
	bclr	#pfnc,pflags(a3)		;collisions on
	move.l	#$18,d0					;pucknorm
	bra.w	assreplace
.ftab								;direction offsets into dirtab for the faceoff pull
	dc.b	0,8,$10,0,8,$10
; assignment for puck most of the time
; a3 = puck
; d7 = elapse frames since last call
pucknorm							;assignment for puck most of the time. a3 = puck, d7 = elapse frames since
									;last call
	btst	#2,(BA_PS_flags).w		;check if flag is clear (normal play)
	beq.w	.normalplay
	bsr.w	UpdatePenaltyShotEnd
.normalplay							;normal play
	bclr	#pfna,pflags(a3)		;#pfna clear
	beq.w	.nna
	clr.w	temp1(a3)				;temp1
	move.w	#$78,temp2(a3)			;temp2
.nna								;count down the timer
	movea.w	#(puckcross-M68K_RAM),a1	;table for puck crossing lines
	sub.w	d7,pcframes(a1)			;sub elapse frames from time til crossing
	sub.w	d7,pcsize+pcframes(a1)
	sub.w	d7,temp1(a3)			;temp1
	bpl.w	.0
	addq.w	#5,temp1(a3)
	bsr.w	findpc
.0									;puck carried: the puck follows the carrier's stick
	move.w	(puckc).w,d0			;is the puck carried?
	bmi.w	.nothandled				;loose puck
	asl.w	#scsize,d0				;#scsize
	movea.w	#(SortCords-M68K_RAM),a2
	adda.w	d0,a2					;a2 = the puck carrier
	bsr.w	a2touchpuck
	move.l	a2,-(sp)				;GetHot takes the structure address on the stack
	bsr.w	GetHot					;d0/d1 = hot spot of the carrier
	add.w	(a2),d0					;Xpos - bungie the puck towards the hot spot on player a2
	sub.w	(a3),d0
	asr.w	#2,d0					;move a quarter of the distance per call
	add.w	d0,(a3)
	add.w	Ypos(a2),d1				;Ypos
	sub.w	Ypos(a3),d1
	asr.w	#2,d1
	add.w	d1,Ypos(a3)
	move.w	Xvel(a2),Xvel(a3)		;Xvel
	move.w	Yvel(a2),Yvel(a3)		;Yvel
.nothandled							;done
	bsr.w	PuckIChk				;icing check
	bsr.w	ChkOffsides				;offsides check
	btst	#gmclock,(gmode).w		;check for play stoppage
	bne.w	.end
	tst.w	(puckc).w
	bpl.w	.resetstilltimer
	move.w	(a3),d0					;Xpos
	cmp.w	OldXpos(a3),d0			;oldXpos
	bne.w	.resetstilltimer
	move.w	Ypos(a3),d0				;Ypos
	cmp.w	OldYpos(a3),d0			;oldYpos
	bne.w	.resetstilltimer
	move.l	#6,d0
	subq.w	#1,temp2(a3)			;temp3
.maybepenalty						;still puck timer out: whistle (penalty number 6)
	bpl.w	.stillpuckdone
	bsr.w	AddPenalty2
.stillpuckdone						;puck has moved or the penalty is in: on to the collision checks
	bra.w	.end
.resetstilltimer					;puck moved: restart the still puck timer (120 frames)
	move.w	#$78,temp2(a3)			;move 78 hex into temp2
.end								;puck in the air or above the ice: collision checks
	tst.b	Zvel(a3)				;Zvel
	bne.w	checkpuckcoll
	tst.w	Zpos(a3)				;Zpos
	bne.w	checkpuckcoll
	bsr.w	puckunflip				;on the ice and not rising: stop the spin
	bra.w	checkpuckcoll
;	Helpers from PuckIChk to WeightedRandomSelect: puck flipping, skating, assignment lists and
;	acceleration. remap follows.
;
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp /
;	cmpi; fixopcodes.js patches the cmp encoding after assembly.

;SortCords offsets: Xpos 0, attribute 4, Ypos $14, Zpos $18, Xvel $28, Yvel $2A, position $34
;SCnum $52, facedir $54, SPA $58, SPAnum $5A, SPAcnt $5C, pflags $62, pflags2 $63.

ChkOffsides							;check for offsides penalty. a3 = puck. Flags the whole team
	btst	#gmoffs,(gmode).w
	beq.w	rtss2
	btst	#2,(BA_PS_flags).w
	bne.w	rtss2
	movea.w	#(tmstruct-M68K_RAM),a1
	lea	tmsize(a1),a2				;team 2 (tmsize)
	bsr.w	ClearOffsidesIfAllPlayers	;first drop the flag of any team with no one over the line
	exg	a1,a2
	bsr.w	ClearOffsidesIfAllPlayers
	move.w	#$54,d0
	cmp.w	Ypos(a3),d0
	bgt.w	.neg					;puck y < Blueline-4: go to the bottom line test
	cmp.w	OldYpos(a3),d0			;OldYpos: puck crossed the top line this frame?
	ble.w	rtss2
	addi.w	#$A,d0					;d0 = Blueline+6: players must be past this
	btst	#gmdir,(gmode).w		;pick which team is attacking this end
	beq.w	.t0
	exg	a2,a1
.t0									;team structs chosen
	moveq	#5,d2
	movea.w	tmsort(a2),a0
.0									;loop over the team: anyone past the blue line?
	tst.w	position(a0)			;position: skip off ice
	bmi.w	.1
	cmp.w	Ypos(a0),d0
	bge.w	.1						;not past the line
	bset	#tmfoside,tmflags(a2)	;player past the line: team offsides
	rts
.1									;next player
	adda.w	#SCstruct,a0			;next player
	dbf	d2,.0
	rts
.neg								;bottom blue line: the same test mirrored
	neg.w	d0
	cmp.w	Ypos(a3),d0
	blt.w	rtss2
	cmp.w	OldYpos(a3),d0
	bge.w	rtss2
	subi.w	#$A,d0
	btst	#gmdir,(gmode).w
	bne.w	.t1
	exg	a2,a1
.t1									;team structs chosen
	moveq	#5,d2
	movea.w	tmsort(a2),a0
.2									;loop over the team (bottom line)
	tst.w	position(a0)			;loop over the team's players (bottom line)
	bmi.w	.3
	cmp.w	Ypos(a0),d0
	ble.w	.3						;not past the line
	bset	#tmfoside,tmflags(a2)	;team offsides
	rts
.3									;next player
	adda.w	#SCstruct,a0			;next player
	dbf	d2,.2
	rts
ClearOffsidesIfAllPlayers			;a2 = team struct: clear the team offsides flag once no skater is past the
									;line
	btst	#tmfoside,tmflags(a2)
	beq.w	rtss2
	movea.w	tmsort(a2),a0
	moveq	#5,d1
.top								;loop: d0 = each player's y toward the goal he shoots at
	tst.w	position(a0)			;position: off ice keeps the last d0
	bmi.w	.next
	move.w	Ypos(a0),d0				;d0 = y toward the goal this player shoots at
	btst	#pfgoal,pflags(a0)
	bne.w	.next
	neg.w	d0
.next								;next player; stop when one is past the line
	adda.w	#SCstruct,a0
	cmp.w	#$58,d0
	dbgt	d1,.top
	bgt.w	rtss2
	bclr	#tmfoside,tmflags(a2)
	rts
a2offsides							;player a2 touched the puck: offsides penalty if his team is flagged and
									;the puck is past the blue line
	btst	#gmoffs,(gmode).w
	beq.w	rtss2
	move.w	(pucky).w,d0			;puck y toward the goal a2 shoots at
	btst	#pfgoal,pflags(a2)
	bne.w	.0
	neg.w	d0
.0									;Y for his end
	cmp.w	#$68,d0
	blt.w	rtss2
	movea.w	#(tmstruct-M68K_RAM),a0	;a0 = a2's team struct
	btst	#pfteam,pflags(a2)
	beq.w	.1
	adda.w	#tmsize,a0
.1									;team struct chosen
	btst	#tmfoside,tmflags(a0)
	beq.w	rtss2
	btst	#gmhl,(gmode).w
	bne.w	rtss2
	exg	a2,a3
	move.l	#$10,d0
	bsr.w	AddPenalty
	exg	a2,a3
	rts
; player a2 touches puck
; look for penalties/offsides/other junk
a2touchpuck							;player a2 touches puck. Look for penalties/offsides/other junk. Called
									;from pucknorm, puckstick and others
	move.w	(a2),(ltx).w			;move Xpos to last touch X
	move.w	Ypos(a2),(lty).w		;move Ypos to last touch Y
	move.w	SCnum(a2),(ltplayer).w	;move SCnum to last touch player
	movea.w	#(tmstruct-M68K_RAM),a0	;move Home Shots into a0
	btst	#pfteam,pflags(a2)		;check if home or away
	beq.w	.t						;branch if home
	lea	tmsize(a0),a0				;add to a0 if away
.t									;team struct chosen
	clr.w	d0
	move.b	pnum(a2),d0				;move pnum into d0
	btst	#pf3onetimer,pflags3(a2)	;check if one timer
	beq.w	.checklast				;branch if not
	bset	#7,(sflags8).w			;set if one timer
.checklast							;last touch
	cmp.w	tmtouch1(a0),d0			;already the last touch?
	beq.w	.same					;branch if equal
	bclr	#tmflast,tmflags(a0)	;clear bit 3
	bne.w	.st						;branch if not cleared before
	move.w	tmtouch2(a0),tmtouch3(a0)	;first assist becomes second assist
	move.w	tmtouch1(a0),tmtouch2(a0)	;last touch becomes first assist
.st									;scorer and assists set
	move.w	d0,tmtouch1(a0)			;this player is the last touch
	cmp.w	tmtouch3(a0),d0			;also the second assist?
	bne.w	.same					;branch if not
	st	tmtouch3(a0)				;then clear the second assist
.same								;assists updated: clear the shot flag, then offside and icing checks
	bclr	#sf2shot,(sflags2).w	;clear shot taken
	bsr.w	a2offsides
	btst	#ifok,(iflags).w		;check if icing
	beq.w	.notice					;branch if not
	btst	#ifcgl,(iflags).w		;test if crossed goalline
	beq.w	.notice					;branch if not
	tst.w	position(a2)			;check if goalie
	beq.w	.notice					;branch if so
	btst	#ifdir,(iflags).w		;check if must cross top line
	bne.w	.up						;branch if so
	btst	#pfgoal,pflags(a2)		;check if top or bottom shooting goal
	beq.w	.notice					;branch if bottom
.icing								;loop
	clr.w	d0
	move.b	(icingPlayer).w,d0		;move iflags+1 into d0
	asl.w	#7,d0
	move.l	a3,-(sp)				;push on stack
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3					;a3 now player struct
	move.w	#PenIcing,d0
	bsr.w	AddPenalty
	movea.l	(sp)+,a3
	rts
.up									;ifdir set
	btst	#pfgoal,pflags(a2)		;check top or bottom shooting goal
	beq.s	.icing					;branch if bottom
.notice								;start a new icing check from where this player touched the puck
	clr.b	(iflags).w				;start over: clear the icing state
	move.b	SCnum+1(a2),(icingPlayer).w	;move SCnum+1 into icingPlayer
	move.w	(pucky).w,d0			;move pucky into d0
	btst	#pfgoal,pflags(a2)		;check if shooting up or down
	beq.w	.0						;branch if down
	bset	#ifdir,(iflags).w		;set icing direction up
	neg.w	d0						;negate d0
.0									;icing check
	bmi.w	rtss2					;exit if minus
	move.w	(tmstruct+tmap).w,d0	;(tmap).w
	sub.w	(awtmstruct+tmap).w,d0	;(tmsize).w
	btst	#pfteam,pflags(a2)		;check home or away
	beq.w	.1						;branch if home
	neg.w	d0						;negate d0
.1									;icing for his team
	bmi.w	rtss2					;exit if minus
	bset	#ifok,(iflags).w		;set icing flag
	rts
; check for icing of puck penalty
PuckIChk							;check for icing of puck penalty. Called from pucknorm
	btst	#ifok,(iflags).w		;#ifok
	beq.w	rtss2
	btst	#ifcgl,(iflags).w		;#ifcgl - if crossed goal line
	bne.w	rtss2
	tst.w	(puckc).w
	bpl.w	rtss2
	move.w	#Blueline+goalline,d0	;goalline
	btst	#ifdir,(iflags).w		;#ifdir - 1 = must cross top line
	bne.w	.0
	neg.w	d0						;other direction: d0 = -(goal line y)
	cmp.w	(pucky).w,d0			;check other goalline
	bgt.w	.chkx					;puck y reached the goal line
	rts
.0									;ifdir set
	cmp.w	(pucky).w,d0
	bgt.w	rtss2
.chkx								;check the X
	cmpi.w	#$2C,(puckx).w			;2C - edge of crease
	bgt.w	.set
	cmpi.w	#$FFD4,(puckx).w		;FFD4 - edge of crease
	blt.w	.set
	bclr	#ifok,(iflags).w		;#ifok cleared
	rts
.set								;puck within the crease width: icing goes on to the goal line check
	bset	#ifcgl,(iflags).w		;#ifcgl
	rts
; stop spinning puck
; a3 = puck
puckunflip							;stop spinning puck. a3 = puck. Entered from
									;pucknothing, called from pucknorm
	cmpi.w	#8,SPAnum(a3)			;2*4 SPAnum
	blt.w	.k
	cmpi.w	#$18,SPAnum(a3)			;6*4
	bge.w	.k
	eori.w	#2,facedir(a3)			;facedir
.k									;set facedir bit 2 (puck lies flat) and stop the spin animation
	ori.w	#4,facedir(a3)			;facedir bit 2 set
	clr.w	SPAnum(a3)				;SPAnum
	st	SPAcnt(a3)					;SPAcnt
	rts
; start puck spinning
; a3 = puck
puckflip							;start puck spinning. a3 = puck, d0 bit 0 = flip. Called from checkgoal,
									;wallcoll and others
	andi.w	#1,d0
	eor.w	d0,facedir(a3)			;facedir
	andi.w	#3,facedir(a3)			;keep 0-3
	st	SPAcnt(a3)					;SPAcnt
	move.w	#SPApflip,d1
	bra.w	SetSPA					;start the puck flip animation
; assignment for puck shadow
; a3 = puck shadow
puckshadow							;assignment for puck shadow. a3 = puck shadow (struct after the puck)
	cmpi.w	#SPFpuck,frame(a3)
	bne.w	.siren					;shadow turns into siren on goals
	move.w	Xpos-SCstruct(a3),(a3)	;Xpos-SCstruct, Xpos
	move.w	Ypos-SCstruct(a3),Ypos(a3)	;Ypos-SCstruct, Ypos
	clr.w	Zpos(a3)				;Zpos
	moveq	#Ypos,d0				;Ypos
	btst	#sfhor,(sflags).w		;#sfhor - check if horizontal mode
	beq.w	.nhor
	moveq	#Xpos,d0				;Xpos
.nhor								;coordinate chosen
	addq.w	#1,0(a3,d0.w)
	rts
.siren								;the goal light: only when it is lit
	tst.w	frame(a3)				;frame
	beq.w	rtss2
	clr.w	(a3)					;Xpos
	move.w	#$12C,Ypos(a3)			;Ypos
	move.w	#$E,Zpos(a3)			;Zpos
	tst.w	Ypos-SCstruct(a3)		;Ypos-SCstruct
	bpl.w	.s0						;puck y >= 0: siren at the top, as set
	move.w	#$8000,attribute(a3)	;attribute
	neg.w	Ypos(a3)				;Ypos
	subq.w	#1,Zpos(a3)				;Zpos
.s0									;exit (also the end of the code above)
	rts
; find puck crossing lines
; calculate when puck will cross goalline (if at all)
findpc								;find puck crossing lines: calculate when puck will cross goalline (if at
									;all). Called from pucknorm fills puckcross (2 entries of x word, time
									;word): top goal line first, then bottom
	movem.l	d0-d4/a1-a2,-(sp)
	movea.w	#(puckcross-M68K_RAM),a1
	move.w	#Sideline,d1			;sideline - distance from center to side boards
	move.w	#$108,d4				;goaline
	bsr.w	.calc					;top goal line (y = d4)
	neg.w	d4						;make d4 negative to check bottom goal line
	bsr.w	.calc					;bottom goal line (y = -d4)
	movem.l	(sp)+,d0-d4/a1-a2
	rts
.calc								;local subroutine
	move.w	d4,d0					;move goaline into d0
	sub.w	(pucky).w,d0			;sub pucky from d0
	tst.w	(puckvy).w				;check puckvy
	beq.w	.nocross				;branch if 0
	move.w	d0,d2					;move d0 into d2
	swap	d2						;swap upper and lower word of d2
	clr.w	d2						;clear bottom word of d2
	asr.l	#4,d2					;shift 4 bits right (divide by 16)
	divs.w	(puckvy).w,d2			;divide puckvy into d2
	bmi.w	.nocross				;branch if negative
	move.w	d2,pcframes(a1)			;time until crossing in frames (puckcross y)
	muls.w	(puckvx).w,d0			;mult puckvx with d0
	divs.w	(puckvy).w,d0			;divide puckvy into d0
	bvs.w	.nocross				;branch if overflow set
	add.w	(puckx).w,d0			;add puckx to d0
	cmp.w	d1,d0					;compare d1 (sideline) to d0
	blt.w	.o1						;branch if less than (in play)
	neg.w	d0						;negate d0
	add.w	d1,d0					;add d1 3 times to d0
	add.w	d1,d0
	add.w	d1,d0
.o1									;offset added
	neg.w	d1						;negate d1
	cmp.w	d1,d0					;compare d1 (other sideline) to d0
	bgt.w	.o2						;branch if greater than (in play)
	neg.w	d0						;negate d0
	add.w	d1,d0					;add d1 to d0 3 times
	add.w	d1,d0
	add.w	d1,d0
.o2									;offset added
	neg.w	d1						;negate d1
	move.w	d0,(a1)					;move d0 into puckcross
	bra.w	.next
.nocross							;puck does not reach this goal line
	move.w	#$FFFF,pcframes(a1)		;move -1 into puckcross y
.next								;next puckcross entry (the other goal line)
	addq.w	#pcsize,a1				;next puckcross entry (the other goal line)
	rts
; a0 = extra routine for collision avoidance
; d0/d1 = x/y coord to skate to
; d7 = elapsed frames
skateto								;a0 = extra routine for collision avoidance, d0/d1 = x/y cord to skate to,
									;d7 = elapse frames
	sub.b	d7,temp2(a3)			;sub d7 from temp2
	bpl.w	.ex						;exit if not 0 or less
	addi.b	#$C,temp2(a3)			;add 12 - only execute every 12 frames
	bsr.w	avdgoal					;avoid the goal nets
	movem.w	d0-d1,-(sp)				;no deltax/deltay test
	move.w	Xvel(a3),d0				;Xvel
	asr.w	#8,d0					;divide by 256
	neg.w	d0						;make negative
	add.w	(sp)+,d0				;add new x coord from stack
	sub.w	(a3),d0					;sub Xpos
	move.w	Yvel(a3),d1				;Yvel
	asr.w	#8,d1					;divide by 256
	neg.w	d1						;make negative
	add.w	(sp)+,d1				;add new y coord from stack
	sub.w	Ypos(a3),d1				;sub Ypos
	cmp.w	#$C,d0					;compare 12 to d0
	bgt.w	.vt
	cmp.w	#$FFF4,d0				;cmp -12
	blt.w	.vt
	cmp.w	#$C,d1					;compare 12 to d1
	bgt.w	.vt
	cmp.w	#$FFF4,d1				;cmp -12
	blt.w	.vt
	moveq	#9,d0					;close enough: no direction
	bra.w	.nvt
.vt									;direction to the target
	bsr.w	vtoa
.nvt								;let the extra routine (a0) change the direction
	jsr	(a0)						;extra collision routine
	move.b	d0,temp2+1(a3)			;move d0 into temp2+1
	cmp.w	#7,d0					;compare to 7
	ble.w	.ex						;a real direction: go accelerate
	move.w	Xvel(a3),d0				;Xvel
	or.w	Yvel(a3),d0				;Yvel
	bne.w	.ex						;still moving
	move.w	(puckx).w,d0			;move puckx into d0
	move.w	(pucky).w,d1			;move pucky into d1
	btst	#pf2fight,(puck_pflags2).w	;#pf2fight, puckx+pflags2
	beq.w	.nf
	move.w	(xc1).w,d0				;scroll lock x coord
	move.w	(yc1).w,d1				;scroll lock y coord
.nf									;scroll to the target
	sub.w	(a3),d0					;Xpos
	sub.w	Ypos(a3),d1				;Ypos - face towards puck
	bsr.w	vtoa
	sub.w	facedir(a3),d0			;facedir
	beq.w	.ex						;already facing it
	neg.w	d0
	andi.w	#4,d0
	lsr.w	#1,d0					;divide by 2
	subq.w	#1,d0					;+1/-1: one step in the shorter turn direction
	add.w	facedir(a3),d0			;facedir
	andi.w	#7,d0
	move.w	d0,facedir(a3)			;facedir
.ex									;accelerate in the stored direction
	clr.w	d0						;d0 = stored direction
	move.b	temp2+1(a3),d0			;temp2+1
	bra.w	doplayeracc				;accelerate that way
; Don't try to skate through goal
; If d0/d1 coords intersect through goal, then provide new d0/d1 coords
; a3 = player
; .xr = 80
; .yr = 30
; .ye = 30
; .gl = 258
avdgoal								;don't try to skate thru goal: if d0/d1 cords intersect thru goal then
									;provide new d0/d1 cords. a3 = player. .gl 254 ($FE), .yr/.ye 35 (92
									;258/30/30), .xr 80 in: d0/d1 = target x/y. out: d0/d1 moved by (deltax,
									;deltay) so the straight line from a3 to the target misses both nets (x
									;within +-$50, y within 35 of the goal lines at +-254)
	clr.w	(deltax).w
	clr.w	(deltay).w
	tst.w	position(a3)			;goalie? If so, quit
	beq.w	rtss2
	move.w	(a3),d2					;Xpos
	eor.w	d0,d2
	bpl.w	.chbar					;target on the same side of x = 0: line does not cross the center
	move.w	d1,d2					;d2 = y where the line a3 -> target crosses x = 0
	sub.w	Ypos(a3),d2				;Ypos
	move.w	(a3),d3					;Xpos
	muls.w	d3,d2
	sub.w	d0,d3
	divs.w	d3,d2
	add.w	Ypos(a3),d2				;Ypos
	cmp.w	#$121,d2				;.gl+.yr
	bgt.w	.chbar					;passes above the top net area
	cmp.w	#$DB,d2					;.gl-.yr
	blt.w	.lower					;below the top net area: maybe the bottom one
	move.w	#$144,d3				;.gl-.yr-.ye
	cmp.w	#$FE,d2					;.gl
	bgt.w	.2						;above the goal line: go around the outside
	blt.w	.1						;below it: go around the inside
	cmpi.w	#$FE,Ypos(a3)			;.gl, Ypos
	bgt.w	.2						;exactly on it: decide by which side I am on
.1									;above the net: go around the outside
	move.w	#$B8,d3					;.gl-.yr-.ye
.2									;deltay = wanted y - crossing y
	sub.w	d2,d3					;deltay = wanted y - crossing y
	move.w	d3,(deltay).w			;deltay = wanted y - crossing y
	bra.w	.chbar
.lower								;d2 < $DB
	cmp.w	#$FF25,d2				;-.gl+.yr
	bgt.w	.chbar
	cmp.w	#$FEDF,d2				;-.gl-.yr
	blt.w	.chbar
	move.w	#$FF48,d3				;-.gl+.yr+.ye
	cmp.w	#$FF02,d2				;-.gl
	bgt.w	.4
	blt.w	.3
	cmpi.w	#$FF02,Ypos(a3)			;-.gl, Ypos
	bgt.w	.4
.3									;below the bottom net: go around
	move.w	#$FEBC,d3				;-.gl-.yr-.ye
.4									;deltay for the bottom net
	sub.w	d2,d3
	move.w	d3,(deltay).w
.chbar								;second test: does the path cross a goal line inside the net width?
	move.w	d1,d3					;second test: does the line cross a goal line inside the net width?
	subi.w	#$FE,d3					;.gl
	move.w	Ypos(a3),d2
	subi.w	#$FE,d2
	bsr.w	.ch1					;top goal line
	move.w	d1,d3
	addi.w	#$FE,d3
	move.w	Ypos(a3),d2
	addi.w	#$FE,d2
	bsr.w	.ch1					;bottom goal line
	add.w	(deltax).w,d0			;apply the corrections to the target
	add.w	(deltay).w,d1
	rts
.ch1								;local subroutine
	move.w	d3,d4
	eor.w	d2,d4
	bpl.w	rtss2
	move.w	d0,d4
	sub.w	(a3),d4					;Xpos
	muls.w	d2,d4
	sub.w	d3,d2
	divs.w	d2,d4
	add.w	(a3),d4					;Xpos
	cmp.w	#$50,d4					;#.xr
	bgt.w	rtss2
	cmp.w	#$FFB0,d4				;#-.xr
	blt.w	rtss2
	moveq	#$50,d3					;#.xr
	tst.w	d4
	bne.w	.ch2
	tst.w	(a3)					;Xpos
.ch2								;X sign
	bpl.w	.ch3
	neg.w	d3
.ch3								;compare the distance
	sub.w	d4,d3					;deltax = net edge - crossing x
	move.w	d3,(deltax).w			;deltax = net edge - crossing x
	rts
; find where the puck is going to be
skatetopuckinit						;from 92 skatetopuck head. d0/d1 = puck x/y plus half the high byte of its
									;velocity. Called from skatetopuck and assnearest
	move.b	(puckvx).w,d0			;high byte of the puck x velocity (signed)
	asr.b	#1,d0					;halved
	ext.w	d0
	add.w	(puckx).w,d0			;d0 = puck x + vx/2
	move.b	(puckvy).w,d1
	asr.b	#1,d1
	ext.w	d1
	add.w	(pucky).w,d1			;d1 = puck y + vy/2
	rts
; player a3 should skate to puck
skatetopuck							;player a3 should skate to puck. d7 = elapse frames
	bsr.s	skatetopuckinit			;d0/d1 = predicted puck spot
	sub.b	d7,temp2(a3)			;temp2
	bpl.w	.ex						;not due: reuse the last direction
	addi.b	#$A,temp2(a3)			;temp2
	bsr.w	avdgoal					;go around the nets
	movem.w	d0-d1,-(sp)				;save the target
	move.l	a3,-(sp)				;GetHot argument: this player
	bsr.w	GetHot					;d0/d1 = hot spot x/y of this player
	neg.b	d0
	neg.b	d1
	sub.b	Xvel(a3),d0				;Xvel
	ext.w	d0
	add.w	(sp)+,d0				;+ target x
	sub.w	(a3),d0					;Xpos
	sub.b	Yvel(a3),d1				;Yvel
	ext.w	d1
	add.w	(sp)+,d1
	sub.w	Ypos(a3),d1				;Ypos
	bsr.w	vtoa					;direction to the puck
	move.b	d0,temp2+1(a3)			;temp2 lower byte
	tst.w	position(a3)			;goalie skips the sweep check
	beq.w	.ex
	move.w	(puckvx).w,d0
	move.w	(puckvy).w,d1
	bsr.w	vtoa					;direction the puck is moving
	eori.w	#4,d0					;opposite of that
	cmp.w	facedir(a3),d0			;facedir
	beq.w	.ex						;puck is coming towards players
	move.w	(puckx).w,d0
	sub.w	(a3),d0					;Xpos
	move.w	(pucky).w,d1
	sub.w	Ypos(a3),d1				;Ypos
	movem.w	d0-d1,-(sp)
	bsr.w	vtoa					;direction from me to the puck
	cmp.w	facedir(a3),d0
	movem.w	(sp)+,d0-d1
	bne.w	.ex						;not facing the puck
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0					;squared distance to the puck
	cmp.l	#$384,d0				;#30^2
	bls.w	.ex
	cmp.l	#$5A4,d0				;#38^2
	bls.w	Sweepcheck
.ex									;not near enough to check: keep skating that way
	move.b	temp2+1(a3),d0
	bra.w	doplayeracc
; exit current assignment on player a3
assexit								;exit current assignment on player a3
	addq.w	#1,assnum(a3)			;add 1 to current assignment index
	andi.w	#7,assnum(a3)			;mask passing first 3 bits
	bset	#pfna,pflags(a3)		;signal next assignment
	rts
; insert new assignment on player a3
assinsert							;insert new assignment on player a3. d0 =
									;assignment. Falls into assreplace
	subq.w	#1,assnum(a3)
	andi.w	#7,assnum(a3)
; replace current assignment on player a3
assreplace							;replace current assignment on player a3. d0 = assignment
	move.l	d1,-(sp)				;push on stack
	move.w	assnum(a3),d1
	move.b	d0,asslist(a3,d1.w)		;replace current assignment with d0 on asslist
	bset	#pfna,pflags(a3)		;set flag to start new assignment
	move.l	(sp)+,d1				;pop on stack
	rts
; d0/d1 are x/y distances which are converted into direction 0-7 and returned in d0
vtoa								;d0/d1 are x/y distances which are converted into direction 0-7 and
									;returned in d0 (8 = no direction)
	movem.l	d2/a0,-(sp)
	move.w	d0,d2
	or.w	d1,d2
	beq.w	.nodir					;both zero: no direction
	clr.w	d2						;d2 = 4 bit index built from the signs and slope tests
	tst.w	d0
	bpl.w	.0
	neg.w	d0						;|dx|
	bset	#0,d2					;bit 0: dx negative
.0									;|dy|
	tst.w	d1						;y sign
	bpl.w	.1
	neg.w	d1						;|dy|
	bset	#1,d2					;bit 1: dy negative
.1									;|dx| check
	asl.w	#1,d1					;slope test: |dx| against 2|dy|
	cmp.w	d1,d0
	bhi.w	.2						;|dx| > 2|dy|
	bset	#2,d2					;bit 2: |dx| <= 2|dy|
.2									;|dy| check
	lsr.w	#1,d1					;slope test: |dy| against 2|dx|
	asl.w	#1,d0
	cmp.w	d0,d1
	bhi.w	.3						;|dy| > 2|dx|
	bset	#3,d2					;bit 3: |dy| <= 2|dx|
.3									;direction bits set
	movea.l	#.dt,a0					;#.dt
	clr.w	d0
	move.b	0(a0,d2.w),d0
	movem.l	(sp)+,d2/a0
	rts
.nodir								;d2 = 0
	moveq	#8,d0					;8 = no direction
	movem.l	(sp)+,d2/a0
	rts
.dt	dc.b	1
	dc.b	7,3,5,0,0,4,4,2,6,2,6,1,7,3,5
; Push long address of structure to get hot spot from
; hot spot x/y returned in d0/d1
GetHot								;push long address of structure to get hot spot from. Hot spot x/y
									;returned in d0/d1. Reads a byte pair per frame from HotList
	movem.l	a0-a1,-(sp)				;$C(sp) = the address the caller pushed (above 2 longs and the return
									;address)
	movea.l	$C(sp),a0				;move stored address before sub routine call into a0
	clr.w	d0						;clear d0
	clr.w	d1						;clear d1
	tst.w	frame(a0)
	ble.w	.ex						;branch if <= 0
	movea.l	#HotList,a1				;move HotList address into a1
	move.w	frame(a0),d0			;move frame into d0
	add.w	d0,d0					;double d0
	move.b	1(a1,d0.w),d1			;SprStrHot Y byte
	ext.w	d1						;extend d1
	move.b	0(a1,d0.w),d0			;SprStrHot X byte
	ext.w	d0						;extend d0
	btst	#3,attribute(a0)		;check attribute for X flip
	beq.w	.nox					;branch if equal
	neg.w	d0						;negate d0 (flip)
.nox								;x flipped sprites mirror the hot spot x
	btst	#4,attribute(a0)		;check attribute for Y flip
	bne.w	.noy					;branch if no flip
	neg.w	d1						;negate d1 (flip)
.noy								;y flipped sprites mirror the hot spot y; horizontal mode swaps x and y
	btst	#sfhor,(sflags).w		;check if horizontal mode
	beq.w	.ex						;branch if not
	exg	d0,d1						;swap d0 and d1
	neg.w	d1						;ngate d1 (x now)
.ex									;pop the a0-a1 saved above
	movem.l	(sp)+,a0-a1				;restore registers, drop the argument
	move.l	(sp)+,(sp)				;drop the caller's argument (replaces it with the return address)
	rts
; set sprite animation on struct a3
; d1 = new animation
SetSPA								;set sprite animation on struct a3. d1 = new animation
	cmp.w	SPA(a3),d1
	beq.w	rtss2
	clr.w	SPAnum(a3)
	move.w	d1,SPA(a3)
	st	SPAcnt(a3)					;restart animation
	rts
; player a3 gets acc. in d0 dir
doplayeracc							;player a3 gets acc. in d0 dir
									;in: d0 = wanted direction (0-7; 8/9 = none), d7 = elapsed frames. Chooses
									;forward or backward skating, turns facedir gradually, and ends in
									;playeracc (accelerate along d2)
	tst.w	position(a3)
	beq.w	goalieacc				;goalie is special
	move.w	#SPAglide,d1			;d1 = animation to use if standing: glide
	btst	#pfrev,pflags(a3)		;check if skating backwards
	beq.w	.d0						;branch if not
	move.w	#SPAglideback,d1		;skating backwards: glide back
.d0									;set the glide
	andi.w	#$F,d0					;pass first 4 bits of d0
	cmp.w	#7,d0					;compare to 7
	ble.w	.d1						;branch if less than
	cmp.w	#9,d0					;compare to 9
	bne.w	.cgl					;branch if not equal
	move.w	Xvel(a3),d0				;Xvel
	or.w	Yvel(a3),d0				;OR Yvel with Xvel
	bne.w	dostop					;stop if not equal
.cgl								;glide check
	btst	#pf2aip,pflags2(a3)		;check if anim in progress
	beq.s	SetSPA					;if not set animation
	rts
.d1									;d0 <= 7
	movem.w	d0-d1,-(sp)				;save wanted direction and animation
	move.w	d0,d2					;d2 = wanted direction
	move.w	SCnum(a3),d0			;move SCnum into d0
	cmp.w	(puckc).w,d0			;check if puckc
	beq.w	.clrrev					;branch if so
	move.w	(puckx).w,d0			;puckx into d0
	sub.w	(a3),d0					;sub Xpos
	move.w	Ypos(a3),d3				;Ypos into d3
	move.b	(puckvy).w,d1			;puckvy into d1
	ext.w	d1
	add.w	(pucky).w,d1			;add pucky to d1
	sub.w	d3,d1					;sub Ypos from d1
	btst	#pfgoal,pflags(a3)		;check which goal shooting at
	bne.w	.c1						;branch if top
	neg.w	d0						;mirror everything into the frame of the team shooting
	neg.w	d1						;toward +y (d3 = my y, d2 = wanted direction)
	neg.w	d3
	eori.w	#4,d2
.c1									;direction check
	btst	#pfrev,pflags(a3)		;check if skating in reverse
	bne.w	.inrev					;branch if so
	tst.w	d3
	bpl.w	.clrrev					;skate back in own zone only
	cmp.w	#4,d2
	bne.w	.clrrev
	bsr.w	vtoa					;direction to the puck (mirrored frame)
	addq.w	#1,d0
	andi.w	#7,d0
	cmp.w	#2,d0
	bhi.w	.clrrev
	bra.w	.rev
.inrev								;pfrev set
	subq.w	#3,d2					;already backwards: stay so only if the wanted direction ...
	andi.w	#7,d2
	cmp.w	#2,d2
	bhi.w	.clrrev
	bsr.w	vtoa
	addq.w	#2,d0
	andi.w	#7,d0
	cmp.w	#4,d0
	bhi.w	.clrrev
.rev								;within one step of the motion: skate backwards (pfrev)
	btst	#pfrev,pflags(a3)		;check if skating in reverse
	bne.w	.done					;branch if so
	move.w	Xvel(a3),d0				;move Xvel into d0
	or.w	Yvel(a3),d0				;or with Yvel
	beq.w	.setrev					;branch if equal
	move.w	Xvel(a3),d0				;move Xvel into d0
	move.w	Yvel(a3),d1				;Yvel to d1
	bsr.w	vtoa					;direction of motion
	sub.w	(sp),d0					;minus the wanted direction
	addq.w	#1,d0
	andi.w	#7,d0
	cmp.w	#2,d0
	bhi.w	.done					;motion not within one step of the wanted direction: stay forward
.setrev								;skate backward
	bset	#pfrev,pflags(a3)		;set skating in reverse flag
	bra.w	.done
.clrrev								;too far round: skate forwards
	bclr	#pfrev,pflags(a3)		;clear skating in reverse flag
.done								;pop the d0-d1 saved above
	movem.w	(sp)+,d0-d1				;d0 = wanted direction, d1 = animation
	move.w	facedir(a3),d2			;facedir into d2
	sub.w	d2,d0
	andi.w	#7,d0					;d0 = wanted - facing (0-7)
	movea.l	#.ftab,a0
	asl.w	#1,d0
	tst.w	0(a0,d0.w)
	beq.w	noturn0					;facing the right way (or opposite): no turn rate
	move.w	Xvel(a3),d4				;Xvel to d4
	muls.w	d4,d4					;square d4
	move.w	Yvel(a3),d3				;Yvel to d3
	muls.w	d3,d3					;square d3
	add.l	d4,d3					;add d4 and d3
	swap	d3						;swap upper and lower words
	move.w	#$300,d4
	sub.w	d3,d4					;turn rate falls as speed rises ...
	cmp.w	#$180,d4				;compare to d4
	bge.w	.iok					;branch if greater than or equal
	move.w	#$180,d4				;... down to $180
.iok								;turn rate clamped
	muls.w	0(a0,d0.w),d4
	btst	#pfrev,pflags(a3)		;check if skating in reverse
	beq.w	.i0						;branch if not
	neg.l	d4						;backwards: turn the other way
.i0									;turn rate
	add.l	d4,facedir(a3)			;add d4 to facedir
	andi.w	#7,facedir(a3)			;pass the first 3 bits to facedir
	move.w	facedir(a3),d2			;move facedir to d2
	cmp.w	#$14,d3
	bls.w	.s3
	clr.w	d1
	tst.w	0(a0,d0.w)
	bpl.w	.s1
	eori.w	#SPAturnl-SPAturnr,d1
.s1									;turn sense from the table sign
	btst	#3,attribute(a3)		;test bit 3 of attribute
	beq.w	.s2
	eori.w	#SPAturnl-SPAturnr,d1	;attribute bit 3 swaps the sense
.s2									;flipped sprites swap the turn sense; start the turn animation
	addi.w	#SPAturnr,d1
	bset	#pf2aip,pflags2(a3)		;set animation in progress flag
.s3									;turn done
	bsr.w	SetSPA					;set the animation
	cmp.w	#2,d3
	bhi.w	noturn					;moving at some speed: accelerate (reversed when pfrev)
	rts								;almost still: no acceleration this call
.ftab	dc.w	0
	dc.w	$10
	dc.w	$10
	dc.w	$10
	dc.w	0
	dc.w	$FFF0
	dc.w	$FFF0
	dc.w	$FFF0
goalieacc							;goalie gets acc. in direction d0. Turns facedir one step toward d0
	btst	#pfjoycon,pflags(a3)
	beq.w	.normalgoalie
	movem.w	d0,-(sp)
	move.w	(puckc).w,d0
	cmp.w	SCnum(a3),d0
	movem.w	(sp)+,d0
	beq.w	.normalgoalie
	cmpi.w	#$30,(a3)
	bgt.w	.normalgoalie
	cmpi.w	#$FFD0,(a3)
	blt.w	.normalgoalie
	cmpi.w	#$FF40,Ypos(a3)
	bgt.w	.checkbottom
	cmpi.w	#$FEFA,Ypos(a3)
	blt.w	.normalgoalie
	bra.w	.facepuck
.checkbottom						;near the bottom net: face the puck
	cmpi.w	#$C0,Ypos(a3)
	blt.w	.normalgoalie
	cmpi.w	#$106,Ypos(a3)
	bgt.w	.normalgoalie
.facepuck							;in the crease: turn toward the puck
	movem.w	d0-d1,-(sp)
	move.w	(puckx).w,d0
	sub.w	(a3),d0
	move.w	(pucky).w,d1
	sub.w	Ypos(a3),d1
	cmp.w	#$10,d0
	bgt.w	.usevtoa
	cmp.w	#$FFF0,d0
	blt.w	.usevtoa
	cmp.w	#$10,d1
	bgt.w	.usevtoa
	cmp.w	#$FFF0,d1
	blt.w	.usevtoa
	move.w	facedir(a3),d0
	bra.w	.checkadjust
.usevtoa							;direction to the puck
	bsr.w	vtoa
.checkadjust						;turn one step toward it (sflags4 bit 0 keeps the direction)
	btst	#0,(sflags4).w
	bne.w	.adjustkeepdir
	bsr.w	AdjustFacingDirection
	movem.w	(sp)+,d0-d1
	bra.w	.setready
.adjustkeepdir						;pop the d0-d1 saved above
	movem.w	(sp)+,d0-d1
	cmp.w	#8,d0
	beq.w	.setready
	movem.w	d0-d1,-(sp)
	bsr.w	AdjustFacingDirection
	movem.w	(sp)+,d0-d1
.setready							;ready stance unless a save animation runs
	move.w	#SPAgready,d1
	btst	#pf2aip,pflags2(a3)
	bne.w	.exit
	bsr.w	SetSPA
	cmp.w	#8,d0
	bne.w	.playermove
	tst.w	position(a3)
	bne.w	.playermove
	btst	#pfjoycon,pflags(a3)
	beq.w	.playermove
	move.w	d0,-(sp)
	move.w	Ypos(a3),d0
	btst	#pfgoal,pflags(a3)
	beq.w	.topstay
	neg.w	d0
.topstay							;stay at the spot
	cmp.w	#$D8,d0
	blt.w	.stopandrestore
	move.w	(a3),d0
	cmp.w	#$20,d0
	bgt.w	.stopandrestore
	cmp.w	#$FFE0,d0
	blt.w	.stopandrestore
	move.w	(sp)+,d0
	jsr	(stopna2).l
	bra.w	.playermove
.stopandrestore						;stop and restore the direction
	jsr	(stopna2).l
	move.w	(sp)+,d0
.playermove							;accelerate in d0
	move.w	d0,d2
	bra.w	playeracc
.normalgoalie						;out of the crease: normal goalie skating
	move.w	#SPAgready,d1
	btst	#pfjoycon,pflags(a3)
	beq.w	.goalieacc2
	btst	#pfnc,pflags(a3)
	bne.w	.cgl
	cmp.w	#8,d0
	bne.w	.turnskater
	tst.w	position(a3)
	bne.w	.cgl
	move.w	d0,-(sp)
	move.w	Ypos(a3),d0
	btst	#pfgoal,pflags(a3)
	beq.w	.topstop
	neg.w	d0
.topstop							;stop at the spot
	cmp.w	#$D8,d0
	blt.w	.restoreidle
	move.w	(a3),d0
	cmp.w	#$20,d0
	bgt.w	.restoreidle
	cmp.w	#$FFE0,d0
	blt.w	.restoreidle
	move.w	(sp)+,d0
	bsr.w	stopna
	bra.w	.cgl
.restoreidle						;restore the direction, then the glide check
	move.w	(sp)+,d0
	bra.w	.cgl
.turnskater							;d0 <> 8
	bra.w	.d1
.goalieacc2							;pfjoycon clear
	andi.w	#$F,d0
	cmp.w	#7,d0
	ble.w	.d1
	cmp.w	#9,d0
	bne.w	.cgl
	move.w	Xvel(a3),d0
	or.w	Yvel(a3),d0
	beq.w	.cgl
	jmp	stopna2
.cgl								;not moving: ready / glide animation unless one runs
	btst	#pf2aip,pflags2(a3)
	beq.w	SetSPA
.exit								;exit (also the end of the code above)
	rts
.d1									;d0 = turn needed: one step a frame
	sub.w	facedir(a3),d0
	beq.w	.d11
	neg.w	d0
	andi.w	#4,d0
	lsr.w	#1,d0
	subq.w	#1,d0
	add.w	facedir(a3),d0
	andi.w	#7,d0
	move.w	d0,facedir(a3)
.d11								;facing set
	move.w	#SPAgskate,d1
	bsr.w	SetSPA
	move.w	facedir(a3),d2
	bra.w	playeracc
noturn0								;doplayeracc when the wanted direction needs no turn (.ftab entry 0). d0 =
									;direction minus facedir, times 2
	moveq	#2,d4					;d4 = 2 forwards, 6 when skating backwards
	btst	#pfrev,pflags(a3)
	beq.w	.0
	addq.w	#4,d4
	eori.w	#8,d0					;backwards: swap "straight" and "opposite"
.0									;turn direction
	tst.w	d0						;straight ahead?
	beq.w	.nochg					;the wanted direction is already the way I skate
	move.w	Xvel(a3),d0				;opposite: look at the current motion
	move.w	Yvel(a3),d1
	bsr.w	vtoa
	btst	#3,d0					;not moving
	bne.w	.nostop
	sub.w	facedir(a3),d0
	add.w	d4,d0
	andi.w	#7,d0
	cmp.w	#4,d0
	blt.w	dostop					;moving along the facing: brake first
.nostop								;turn toward the wanted direction
	addq.w	#1,facedir(a3)			;turn one step (the way depends on attribute bit 3)
	btst	#3,attribute(a3)
	beq.w	.nos0
	subq.w	#2,facedir(a3)
.nos0								;wrap the facing; glide (or the backwards glide)
	andi.w	#7,facedir(a3)			;wrap facing to 0-7
	move.w	#SPAglide,d1
	btst	#pfrev,pflags(a3)
	beq.w	SetSPA
	move.w	#SPAglideback,d1
	bra.w	SetSPA
.nochg								;d0 = 0
	move.w	#SPAskateback,d1		;pick the skating animation
	btst	#pfrev,pflags(a3)
	bne.w	.ns
	move.w	#SPAskate,d1
	btst	#pf2inj,pflags2(a3)		;injured: stumble animation
	beq.w	.nb6
	move.w	#SPAstumble,d1
.nb6								;set the animation
	move.w	(puckc).w,d4			;puck carrier check
	cmp.w	SCnum(a3),d4
	bne.w	.ns
	move.w	#SPAskatewp,d1			;carrying the puck: skate with puck animation
.ns									;skate (or skate with the puck) unless an animation runs
	btst	#pf2aip,pflags2(a3)		;set the animation unless one is in progress
	bne.w	noturn					;animation in progress: leave it
	bsr.w	SetSPA
noturn								;reverse the acc. direction when skating backwards, then falls into
									;playeracc
	btst	#pfrev,pflags(a3)
	beq.w	playeracc
	eori.w	#4,d2					;opposite direction
; d2 = direction of acc
playeracc							;d2 = direction of acc
	asl.w	#2,d2					;4 bytes per dirtab entry
	lea	dirtab(pc),a0
	move.w	2(a0,d2.w),d1			;Y Inc
	move.w	0(a0,d2.w),d0			;x Inc
	move.w	Wallsin(a3),d2			;check acc dir and dont push wall
									;wallsin
	beq.w	.nox
	eor.w	d0,d2
	bpl.w	.nox					;same sign as the wall normal: allowed
	clr.w	d0						;pushing into the wall in x: cancel x
.nox								;x allowed; test y against the wall
	move.w	Wallcos(a3),d2			;wallcos
	beq.w	.noy
	eor.w	d1,d2
	bmi.w	.noy
	clr.w	d1						;same for y (the sign test is the other way round)
.noy								;y done: acceleration scaled by weight (lighter is faster)
	clr.w	d2						;clear d2
	move.b	weight(a3),d2			;move wgt of player into d2
	lsr.w	#2,d2					;divide d2 by 2
	neg.w	d2						;make it negative
	addi.w	#$40,d2					;add 40 hex (64 decimal) to d2
	add.b	legstr(a3),d2			;add agl (legstr) of player to d2
	btst	#1,(sflags8).w
	bne.w	.incagl
	btst	#6,(sflags7).w			;check flag for crowd meter record
	beq.w	.incaglg				;branch if not set
.incagl								;crowd meter boost
	addq.b	#2,d2					;add 2 to d2 (crowd meter boost)
.incaglg							;agility clamped
	tst.w	position(a3)			;test for goalie
	bne.w	.noy2
	add.b	legstr(a3),d2			;goalie gets double agl
	addi.w	#$10,d2					;double agl + 10 hex
.noy2								;goalies use double agility
	asr.w	#1,d2					;divide by 2
	muls.w	d2,d0					;x
	muls.w	d2,d1					;y
	asr.l	#5,d0					;divide by 32
	asr.l	#5,d1
	muls.w	d7,d0					;mult d0 with frames elapsed (d7)
	muls.w	d7,d1					;mult d1 by frames elapsed (d7)
	tst.w	position(a3)			;test goalie
	bne.w	.noy3
	btst	#pfjoycon,pflags(a3)	;joypad controlled
	beq.w	.noy3					;no, then jump
	move.w	(puckc).w,d2			;puck carrier SCnum
	cmp.w	SCnum(a3),d2			;carrying puck?
	bne.w	.noy3					;jump if not
	asr.w	#1,d0					;divide by 2 (puck carrier, joypad controlled)
	asr.w	#1,d1					;divide by 2
.noy3								;puck carrier on the joystick: half the acceleration
	add.w	Xvel(a3),d0				;Xvel
	add.w	Yvel(a3),d1				;Yvel
	move.w	d0,d2					;move d0 into d2
	move.w	d1,d3					;move d1 into d3
	muls.w	d2,d2					;square d2
	muls.w	d3,d3					;square d3
	add.l	d2,d3					;add together
	movem.w	d0-d1,-(sp)				;push d0 and d1 to stack
	bsr.w	getpde					;d0 = this player's energy level
	btst	#4,(sflags7).w
	beq.w	.noy4
	move.w	#$1000,d0				;d0 = energy, move 1000 hex into d0
.noy4								;speed from energy
	clr.w	d2						;clear d2
	move.b	legspd(a3),d2			;add speed (legspd) to d2
	btst	#1,(sflags8).w
	bne.w	.incspd
	btst	#6,(sflags7).w			;skip boost if 0
	beq.w	.noy5
.incspd								;crowd meter boost
	addq.b	#2,d2					;add 2 to d2 (speed)
	cmp.b	#$1E,d2					;compare to max speed attribute (1E or 30)
	ble.w	.noy5					;branch if less than
	move.b	#$1E,d2					;limit it to max speed
.noy5								;speed clamped
	move.w	d2,(TempRawSpd).w		;hold spd value
	lsr.w	#1,d2					;divide by 2
	mulu.w	d0,d2					;multiply energy with spd
	asl.l	#4,d2					;mult by 16
	swap	d2						;swap d2 words (this math is to adjust for energy. Line Changes off, d2 =
									;Spd value / 2)
	asl.w	#2,d2					;mult by 4 (No Line changes result from above = Spd value * 2)
	andi.w	#$3F,d2					;pass first 6 bits. Limits d2 to $3F (63 decimal)
	lea	MaxSpeed(pc),a2				;move Maxspeed table address into a2
	move.w	d2,(TempEnergySpd).w	;hold new spd value
	move.l	0(a2,d2.w),d2			;use value from MaxSpeed list
	move.l	d2,(TempMaxSpd).w		;hold MaxSpeed value
	cmpi.w	#$3C,(TempEnergySpd).w	;compare new spd value with 60 decimal
	bge.w	.fgtinj					;branch if greater than or equal
	btst	#0,(TempRawSpd+1).w		;check if TempRawSpd is odd
	beq.w	.fgtinj					;branch if even
	move.w	(TempEnergySpd).w,d2	;move TempEnergySpd into d2
	addq.w	#4,d2					;add 4 to d2
	move.l	0(a2,d2.w),d2			;use value from MaxSpeed list (rounding the odd number up)
	sub.l	(TempMaxSpd).w,d2		;sub TempMaxSpd from d2
	asr.l	#1,d2					;divide by 2
	add.l	(TempMaxSpd).w,d2		;add TempMaxSpd to d2 (so halves the difference between the 2 Speed steps)
.fgtinj								;injured in a fight: one eighth of the top speed
	btst	#pf2inj,pflags2(a3)		;check if injured during fight
	beq.w	.puckc					;branch if not
	lsr.l	#3,d2					;divide d2 by 8
.puckc								;puck carrier check
	tst.w	position(a3)			;test goalie
	bne.w	.noy6					;branch if not goalie
	move.w	(puckc).w,d0			;puck carrier SCnum
	cmp.w	SCnum(a3),d0			;check if puck carrier
	bne.w	.noy6					;branch if not puck carrier
	asr.l	#1,d2					;divide d2 by 2
.noy6								;pop the d0-d1 saved above
	movem.w	(sp)+,d0-d1				;pop from stack
	cmp.l	d2,d3					;Compare d3 to d2 (max speed check)
	bhi.w	.sube					;branch if d3 is higher than d2 (no increase in velocity)
	move.w	d0,Xvel(a3)				;move new Xvel into Xvel
	move.w	d1,Yvel(a3)				;move new Yvel into Yvel
.sube								;energy drain
	tst.w	(OptLine).w
	bne.w	rtss2
	move.w	(HVcount).l,d0
	andi.w	#$7F,d0
	bne.w	rtss2
	bsr.w	getpde
	subi.w	#$21,d0					;33
	cmp.w	#$C00,d0
	blt.w	setpde					;below $C00: just lower by 33
	move.b	endurance(a3),d2		;endurance
	ext.w	d2
	lsr.w	#1,d2
	add.w	d2,d0
	bsr.w	setpde
	btst	#0,endurance(a3)
	beq.w	.ex
	btst	#0,(Vcount+1).w
	beq.w	.ex
	addq.w	#1,d0
	bra.w	setpde
.ex									;exit
	rts
MaxSpeed							;max speed values for each rating level 0-$F: ((n+20)*275)^2 (92 used 250)
	dc.l	(20*275)*(20*275)		;$1CD9410
	dc.l	(21*275)*(21*275)		;$1FCE3E1
	dc.l	(22*275)*(22*275)		;$22E8284
	dc.l	(23*275)*(23*275)		;$2626FF9
	dc.l	(24*275)*(24*275)		;$298AC40
	dc.l	(25*275)*(25*275)		;$2D13759
	dc.l	(26*275)*(26*275)		;$30C1144
	dc.l	(27*275)*(27*275)		;$3493A01
	dc.l	(28*275)*(28*275)		;$388B190
	dc.l	(29*275)*(29*275)		;$3CA77F1
	dc.l	(30*275)*(30*275)		;$40E8D24
	dc.l	(31*275)*(31*275)		;$454F129
	dc.l	(32*275)*(32*275)		;$49DA400
	dc.l	(33*275)*(33*275)		;$4E8A5A9
	dc.l	(34*275)*(34*275)		;$535F624
	dc.l	(35*275)*(35*275)		;$5859571
; player a3 stops
; .slim = 1000
dostop								;player a3 stops. Entered from doplayeracc and noturn0
	cmpi.w	#$1000,Xvel(a3)			;Xvel
	bgt.w	.set
	cmpi.w	#$F000,Xvel(a3)
	blt.w	.set
	cmpi.w	#$1000,Yvel(a3)			;Yvel
	bgt.w	.set
	cmpi.w	#$F000,Yvel(a3)
	blt.w	.set
	tst.w	position(a3)			;check if goalie
	bne.w	stopna
	jmp	stopna2
	bra.w	stopna
.set								;not stopped yet: skid animation (forward only)
	move.w	#SPAglide,d1			;backwards: plain glide animation, no skid
	btst	#pfrev,pflags(a3)		;#pfrev - skating backwards
	bne.w	.0
	bset	#pf2aip,pflags2(a3)		;#pf2aip
	move.w	#SPAstop,d1				;... the skid stop
.0									;set the stop animation
	bsr.w	SetSPA
	tst.w	position(a3)
	bne.w	stopna
	jmp	stopna2
; stop with no animation
stopna								;slow player a3 by 150 on each axis, no animation change. Falls in from
									;dostop, also entered from goalieacc and others
	tst.w	Xvel(a3)				;Xvel
	bpl.w	.xp
	addi.w	#$96,Xvel(a3)			;150
	bmi.w	.y						;still negative: done
	clr.w	Xvel(a3)				;crossed zero: clear (the code below then also ends at 0)
.xp									;positive x speed: subtract 150, stop at 0
	subi.w	#$96,Xvel(a3)			;positive x: subtract 150
	bpl.w	.y
	clr.w	Xvel(a3)
.y									;same for y
	tst.w	Yvel(a3)				;Yvel
	bpl.w	.yp
	addi.w	#$96,Yvel(a3)
	bmi.w	rtss2
	clr.w	Yvel(a3)
.yp									;positive y speed: subtract 150, stop at 0
	subi.w	#$96,Yvel(a3)
	bpl.w	rtss2
	clr.w	Yvel(a3)
	rts
runspeed	equ	200					;acc speed equate for table below
dirtab	dc.w	0					;x,y speed for each direction 0-7 (8 x,y word pairs); diagonals are
									;runspeed/1.414
	;X/Y acc speed for each direction 0-7
	dc.w	runspeed
	dc.w	runspeed*1000/1414		;runspeed / sqrt(2)
	dc.w	runspeed*1000/1414
	dc.w	runspeed
	dc.w	0
	dc.w	runspeed*1000/1414
	dc.w	-runspeed*1000/1414		;- runspeed / sqrt(2)
	dc.w	0
	dc.w	-runspeed				;- runspeed
	dc.w	-runspeed*1000/1414
	dc.w	-runspeed*1000/1414
	dc.w	-runspeed
	dc.w	0
	dc.w	-runspeed*1000/1414
	dc.w	runspeed*1000/1414
	dc.w	0
	dc.w	0
