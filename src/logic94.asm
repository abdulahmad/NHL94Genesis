;	Player and animation update, and the scroll window. updateplayers runs every object
;	through collision, animation and assignment; checkwindow keeps the view on the play.

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
