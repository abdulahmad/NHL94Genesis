;	Controller input for skaters. This file moves the player under control and lets him pass,
;	shoot and check. It also reads the pads at faceoffs and line changes and decides when a
;	player should head to the bench.


doinput								;process controller input: d0 = dpad, d1 = new buttons, d2 = changed
									;buttons, d3 = held buttons, d4 = controller 0/2
	btst	#4,d1					;B button
	beq.w	.1						;branch if not pressed
	btst	#5,d1					;C button
	beq.w	.1						;branch if not pressed
	bclr	#4,d1					;clear the B press
	bset	#6,pflags3(a3)			;set pflags3 bit 6
	bra.w	.5						;buttons done
.1									;bit 4 of d1 clear or bit 5 of d1 clear
	btst	#4,d1					;B pressed?
	beq.w	.2						;no: next check
	bclr	#6,pflags3(a3)			;clear pflags3 bit 6
.2									;bit 4 of d2 check
	btst	#4,d2					;B changed?
	beq.w	.5						;no: buttons done
	bclr	#6,pflags3(a3)			;clear pflags3 bit 6
	beq.w	.5						;it was clear: buttons done
	tst.w	d4						;which pad?
	bne.w	.3						;pad 2
	move.b	#$11,(bholdtimer).w		;pad 1 B hold timer
	bra.w	.4						;continue
.3									;d4 <> 0
	move.b	#$11,(bholdtimer+1).w	;pad 2 B hold timer
.4									;timer set: drop the B change bit
	bclr	#4,d2					;drop the B change
.5									;A+B+C cases done; in goalie mode shorten the message timer
	btst	#7,(gmode2).w			;goalie mode (gmode2 bit 7)?
	beq.w	.6						;no: continue
	cmp.b	#8,d0					;no direction?
	beq.w	.6						;yes: continue
	jsr	(ShortenMsgTimer).l			;shorten the message timer
.6									;keep the pad
	move.w	d0,(TempWord1).w		;keep the pad direction
	andi.w	#$F,(TempWord1).w		;4 bits only
	bsr.w	setpads					;set the pad bits for a3
	btst	#7,d1					;start button
	beq.w	.nostart				;branch if no start button pressed
	tst.w	(joypuckcarrier).w		;puck carrier of a pad?
	bpl.w	.7						;no: continue
	tst.w	d4						;d4 = 0?
	beq.w	startpause1				;pad 1: startpause1
	bra.w	startpause2				;pad 2: startpause2
.7									;joypuckcarrier >= 0
	btst	#7,d1					;START pressed?
	beq.w	.nostart				;no: continue
	tst.w	(joypuckcarrier).w		;joypuckcarrier 0?
	beq.w	startpause3				;puck carrier 0: startpause3
	bra.w	startpause4				;else startpause4
.nostart							;bit 7 of d1 clear
	btst	#sfhor,(sflags).w		;horizontal rink (sfhor)?
	beq.w	.nhor					;no: continue
	btst	#3,d0					;direction bit 3 set?
	bne.w	.nhor					;yes: continue
	addq.w	#2,d0					;turn the direction by 2
	andi.w	#7,d0					;0 to 7
.nhor								;faceoff check
	btst	#sf2faceoff,(sflags2).w	;faceoff (sf2faceoff)?
	bne.w	faceoffinput			;yes: faceoff input
	btst	#pf2lcm,pflags2(a3)		;line change mode?
	bne.w	lineinput				;yes: line input
	btst	#pfjoycon,pflags(a3)	;human controlled?
	beq.w	rtss15					;no: done
	movem.l	d0-d2/a0/a3,-(sp)		;save registers
	move.w	(lastplayer).w,d0		;d0 = last player
	cmp.w	SCnum(a3),d0			;is it a3?
	bne.w	.noot					;no: no one-timer
	tst.w	(passReceiverPlayerNum).w	;pass receiver set?
	bmi.w	.noot					;no: no one-timer
	tst.w	(onetimerplayer).w		;one-timer player set?
	bpl.w	.noot					;no: no one-timer
	btst	#5,d1					;C pressed?
	beq.w	.noot					;no: no one-timer
	move.w	(passReceiverPlayerNum).w,d0	;d0 = pass receiver
	asl.w	#7,d0					;times $80, the object size
	movea.l	#SortCords,a3			;a3 = sort objects
	adda.w	d0,a3					;a3 = the receiver
	tst.w	position(a3)			;goalie?
	beq.w	.noot					;yes: no one-timer
	jsr	(PuckOnAttackHalf).l		;puck on the attack half?
	beq.w	.noot					;no: no one-timer
	btst	#pfjoycon,pflags(a3)	;human controlled?
	bne.w	.noot					;yes: no one-timer
	btst	#pf3onetimer,pflags3(a3)	;already a one-timer?
	bne.w	.noot					;yes: no one-timer
	move.w	d4,(inputjoy).w			;input into inputjoy
	move.w	(joypuckcarrier).w,(TmpJoyPuckCarrier).w	;puck carrier pad to TmpJoyPuckCarrier
	move.w	#$23,d0					;assonetimer
	jsr	(assreplace).l				;assreplace: switch to assonetimer
	movem.l	(sp)+,d0-d2/a0/a3		;restore registers
	rts								;done
.noot								;pop the d0-d2/a0/a3 saved above
	movem.l	(sp)+,d0-d2/a0/a3		;restore registers
	btst	#pf3onetimer,pflags3(a3)	;already a one-timer?
	bne.w	.chkfight				;yes: check fighting
	btst	#pfalock,pflags(a3)		;locked (pfalock)?
	bne.w	doinput_islocked		;yes: locked input
.chkfight							;fighting?
	btst	#pf2fight,pflags2(a3)	;fighting in progress
	bne.w	fightinput				;fighting: fight input
	move.w	(puckc).w,d5			;d5 = SCnum of the puck carrier
	cmp.w	SCnum(a3),d5			;is it a3?
	beq.w	doinput_ispc			;yes: puck carrier input
	tst.w	position(a3)			;goalie?
	beq.w	.11						;yes: B handling
	btst	#pf3onetimer,pflags3(a3)	;one-timer?
	beq.w	.10						;no: check B
	bra.w	.11						;B handling
.10									;pf3onetimer clear
	btst	#6,d1					;A pressed?
	bne.w	Holdplayer				;yes: Holdplayer
.11									;skater (position <> 0) or goalie: pick how B is handled
	tst.w	position(a3)			;goalie?
	beq.w	.12						;yes: goalie B handling
	btst	#2,(BA_PS_flags).w		;BA_PS_flags bit 2 set?
	bne.w	.noswitch				;yes: no switch
	bra.w	.bhold					;B hold handling
.12									;goalie: B switches players only in goalie mode, and not from the puck
									;carrier
	btst	#6,(sflags5).w			;sflags5 bit 6 set?
	bne.w	.bhold					;yes: B hold handling
	tst.w	d4						;which pad?
	beq.w	.13						;pad 1
	tst.w	(goaliemode2).w			;pad 2 goalie mode
	bra.w	.14						;go on
.13									;d4 = 0
	tst.w	(goaliemode1).w			;pad 1 goalie mode
.14									;flags from this pad's goaliemode: off = B hold checks
	beq.w	.bhold					;off: B hold handling
	movem.w	d0,-(sp)				;save d0
	move.w	SCnum(a3),d0			;d0 = SCnum of a3
	cmp.w	(puckc).w,d0			;is it the puck carrier?
	movem.w	(sp)+,d0				;restore d0 (flags kept)
	beq.w	.bhold					;yes: B hold handling
	bra.w	changeplayer			;change the player
.bhold								;B still held (no holdreset): count down the hold timer, else treat it as
									;a press
	btst	#4,d3					;B held?
	beq.w	.bpress					;no: B press
	tst.w	(holdreset).w			;holdreset set?
	bne.w	.bpress					;yes: B press
	tst.w	d4						;which pad?
	beq.w	.c1						;pad 1
	tst.b	(bholdtimer+1).w		;pad 2 hold timer
	beq.w	.noswitch				;zero: no switch
	subq.b	#1,(bholdtimer+1).w		;count it down
	bpl.w	.16						;still positive: keep
	move.b	#0,(bholdtimer+1).w		;clamp at 0
.16									;timer clamped at 0
	tst.b	(bholdtimer+1).w		;pad 2 hold timer
	bne.w	.bpress					;not out: B press
	tst.w	d4						;which pad?
	beq.w	.17						;pad 1
	tst.w	(goaliemode2).w			;pad 2 goalie mode
	bra.w	.18						;go on
.17									;d4 = 0
	tst.w	(goaliemode1).w			;pad 1 goalie mode
.18									;goalie mode: handle as a press, else go to the goalie
	bne.w	.bpress					;on: B press
	bra.w	.goalie					;else the goalie
.c1									;d4 = 0
	tst.b	(bholdtimer).w			;pad 1 hold timer
	beq.w	.noswitch				;zero: no switch
	subq.b	#1,(bholdtimer).w		;count it down
	bpl.w	.20						;still positive: keep
	move.b	#0,(bholdtimer).w		;clamp at 0
.20									;timer clamped at 0
	tst.w	d4						;which pad?
	beq.w	.21						;pad 1
	tst.w	(goaliemode2).w			;pad 2 goalie mode
	bra.w	.22						;go on
.21									;d4 = 0
	tst.w	(goaliemode1).w			;pad 1 goalie mode
.22									;goalie mode: press; else the goalie once the hold timer is out
	bne.w	.bpress					;on: B press
	tst.b	(bholdtimer).w			;hold timer out?
	beq.w	.goalie					;yes: the goalie
.bpress								;B pressed: start this pad's hold timer; released (.brel): switch players
	btst	#4,d1					;B pressed?
	beq.w	.brel					;no: B released
	tst.w	d4						;which pad?
	bne.w	.24						;pad 2
	move.b	#$11,(bholdtimer).w		;pad 1 hold timer
	bra.w	.noswitch				;no switch
.24									;d4 <> 0
	move.b	#$11,(bholdtimer+1).w	;pad 2 hold timer
	bra.w	.noswitch				;no switch
.brel								;bit 4 of d1 clear
	btst	#4,d2					;B changed?
	beq.w	.noswitch				;no: no switch
	btst	#4,d3					;B still held?
	bne.w	.noswitch				;yes: no switch
	move.w	(bholdtimer).w,d0		;d0 = both hold timers
	tst.w	d4						;which pad?
	beq.w	.28						;pad 1
	move.b	#$11,(bholdtimer+1).w	;pad 2 hold timer
	andi.w	#$FF,d0					;pad 2 byte
	bne.w	changeplayer			;nonzero: change player
	tst.w	d4						;which pad?
	beq.w	.26						;pad 1
	tst.w	(goaliemode2).w			;pad 2 goalie mode
	bra.w	.27						;go on
.26									;d4 = 0
	tst.w	(goaliemode1).w			;pad 1 goalie mode
.27									;goalie mode: switch players, else take the goalie
	bne.w	changeplayer			;on: change player
	bra.w	.goalie					;else the goalie
.28									;d4 = 0
	move.b	#$11,(bholdtimer).w		;pad 1 hold timer
	andi.w	#$FF00,d0				;pad 1 byte
	bne.w	changeplayer			;nonzero: change player
	tst.w	d4						;which pad?
	beq.w	.29						;pad 1
	tst.w	(goaliemode2).w			;pad 2 goalie mode
	bra.w	.30						;go on
.29									;d4 = 0
	tst.w	(goaliemode1).w			;pad 1 goalie mode
.30									;goalie mode: switch players, else take the goalie
	bne.w	changeplayer			;on: change player
.goalie								;take the goalie of a3's team (SCnum 5 home, 11 away) unless holdreset
	tst.w	(holdreset).w			;holdreset set?
	bne.w	changeplayer			;yes: change player
	move.w	#5,d0					;d0 = 5, the home goalie
	cmp.w	#5,d6					;d6 above 5?
	ble.w	.32						;no: home
	move.w	#$B,d0					;d0 = $B, the away goalie
.32									;pad's goalie
	jsr	(getGoalieSCnum).l			;get the goalie's SCnum
	tst.w	d0						;none?
	bmi.w	rtss15					;yes: done
	movem.l	d0/a3,-(sp)				;save registers
	movea.l	#SortCords,a3			;a3 = sort objects
	asl.w	#7,d0					;times $80, the object size
	adda.w	d0,a3					;a3 = the goalie
	btst	#pfjoycon,pflags(a3)	;human controlled?
	movem.l	(sp)+,d0/a3				;restore registers (flags kept)
	bne.w	rtss15					;yes: done
	tst.w	d4						;which pad?
	beq.w	setc1player				;pad 1 takes the goalie
	bra.w	setc2player				;pad 2 takes the goalie
.noswitch							;no switch: one-timer setup, A pass / line change, or the C button
	tst.w	position(a3)			;goalie?
	bne.w	doinput_onetimer		;no: one-timer input
	btst	#6,d1					;A pressed?
	beq.w	doinput_cbut			;no: C button input
	move.w	(TempWord1).w,d0		;d0 = TempWord1
	cmp.b	#8,d0					;no direction?
	beq.w	doinput_cbut			;yes: C button
	move.w	d0,facedir(a3)			;face that direction
	move.b	#8,nopuck(a3)			;nopuck 8
	move.w	#SPAgdive,d1			;goalie dive animation
	bsr.w	SetSPA					;set the animation
	bset	#pf2aip,pflags2(a3)		;animation in progress
	bset	#pfalock,pflags(a3)		;locked (pfalock)
	addi.w	#$96,(Crowdlevel).w		;raise the crowd level by $96
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
	move.w	(puckc).w,d2			;d2 = SCnum of the puck carrier
	cmp.w	SCnum(a3),d2			;is a3 the carrier?
	bne.w	.0						;no: keep d0
	clr.w	d0
.0									;d0 cleared when a3 is the puck carrier
	cmp.w	#$103,d1				;upper limit $103 (signed)
	blt.w	.1						;d1 is below it: keep
	move.w	#$103,d1				;clamp d1 to $103
.1									;clamp X high
	cmp.w	#$FEFD,d1				;lower limit $FEFD (signed)
	bgt.w	.2						;d1 is above it: keep
	move.w	#$FEFD,d1				;clamp d1 to $FEFD
.2									;clamp d1 to the top limit
	sub.w	d3,d1					;take d3 off the clamped value
	rts								;done
	;10 SPA offsets, unreferenced: SPAgglover, SPAgglovel, SPAgstackr, SPAgstackl
	;SPAgstickr, SPAgstickl, then the newer tables SPAghighr, SPAghighl, SPAgstick2r, SPAgstick2l
	dc.w	SPAgglover,SPAgglovel,SPAgstackr,SPAgstackl,SPAgstickr,SPAgstickl,SPAghighr,SPAghighl,SPAgstick2r,SPAgstick2l
doinput_chkanim						;Nothing while a3's animation runs (pflags2 bit 1); else skate a3
									;(doplayeracc)
	btst	#pf2aip,pflags2(a3)		;animation in progress?
	beq.w	.0						;no: carry on
	rts								;yes: nothing to do
.0									;pf2aip clear
	tst.w	position(a3)			;not position 0 (the goalie)?
	bne.w	doplayeracc				;yes: skate
	bclr	#1,(BA_PS_flags).w		;clear the stopped flag
	cmpi.w	#$24,(a3)				;x against $24
	ble.w	.1						;not past it: skip
	tst.w	Xvel(a3)				;Xvel sign
	bmi.w	.1						;moving the other way: skip
	beq.w	.1						;not moving: skip
	bset	#1,(BA_PS_flags).w		;stopped at the x limit
	clr.w	Xvel(a3)				;stop it
.1									;both x limits checked; now y
	cmpi.w	#$FFDC,(a3)				;x against -36
	bge.w	.2						;not past it: skip
	tst.w	Xvel(a3)				;Xvel sign
	bpl.w	.2						;moving the other way: skip
	bset	#1,(BA_PS_flags).w		;stopped at the x limit
	clr.w	Xvel(a3)				;stop it
.2									;x inside -36: keep Xvel
	cmpi.w	#$E7,Ypos(a3)			;y against $E7
	bgt.w	.4						;above it: skip
	cmpi.w	#$FF19,Ypos(a3)			;y against -231
	ble.w	.4						;below it: skip
	bra.w	*+4						;fall through to the y band test
.3									;in the y band: test whether a3 skates outward
	movem.w	d0-d1,-(sp)				;save registers
	move.w	Ypos(a3),d0				;d0 = y
	move.w	Yvel(a3),d1				;d1 = y velocity
	eor.w	d1,d0					;N set when their signs differ
	movem.w	(sp)+,d0-d1				;restore registers (flags kept)
	bpl.w	.4						;same signs: skip
	tst.w	Yvel(a3)				;Yvel sign
	beq.w	.4						;not moving: skip
	bset	#1,(BA_PS_flags).w		;stopped at the y limit
	clr.w	Yvel(a3)				;stop it
.4									;stopped at a limit (BA_PS_flags bit 1): no skating this frame
	btst	#1,(BA_PS_flags).w		;stopped at a limit?
	bne.w	rtss15					;yes: no skating
	move.w	(TempWord1).w,d0		;no: d0 back from TempWord1
	bra.w	doplayeracc				;skate
doinput_onetimer					;a3 is set for a one-timer: C (bit 5) starts the one-timer shot, else
									;skate
	move.w	(TempWord1).w,d0		;d0 = TempWord1
	btst	#pf3onetimer,pflags3(a3)	;already a one-timer?
	bne.w	rtss7					;yes: ignore
	btst	#5,d1					;C pressed?
	beq.w	doplayeracc				;no: skate
	movem.l	d7-a0,-(sp)				;save registers
	move.w	(lastplayer).w,d7		;d7 = last player
	asl.w	#7,d7					;times $80, the object size
	movea.l	#SortCords,a0			;a0 = sort objects
	adda.w	d7,a0					;a0 = last player
	tst.w	position(a0)			;goalie?
	movem.l	(sp)+,d7-a0				;restore registers (flags kept)
	beq.w	burst					;yes: burst
	movem.w	d7,-(sp)				;save d7
	move.w	SCnum(a3),d7			;d7 = SCnum of a3
	cmp.w	(passReceiverPlayerNum).w,d7	;the pass receiver?
	movem.w	(sp)+,d7				;restore d7 (flags kept)
	bne.w	burst					;no: burst
	tst.w	(puckc).w				;puck carried?
	bpl.w	burst					;yes: burst
	jsr	(PuckOnAttackHalf).l		;puck on the attack half?
	beq.w	burst					;no: burst
	move.w	d0,-(sp)				;save d0
	move.w	d4,(inputjoy).w			;input into inputjoy
	move.w	(joypuckcarrier).w,(TmpJoyPuckCarrier).w	;puck carrier pad to TmpJoyPuckCarrier
	move.w	#$23,d0					;assonetimer
	jsr	(assreplace).l				;assreplace: switch to assonetimer
	move.w	(sp)+,d0				;restore d0
	rts								;done
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
	move.w	(puckc).w,d5			;d5 = SCnum of the puck carrier
	cmp.w	SCnum(a3),d5			;is it a3?
	beq.w	rtss15					;yes: ignore B
	btst	#4,d1					;B pressed?
	beq.w	rtss7					;no: done
	btst	#6,(sflags5).w			;flag set in sflags5?
	bne.w	rtss7					;yes: done
	bsr.w	changeplayer			;change the controlled player
	movem.l	d0/a0,-(sp)				;save registers
	move.w	(c1playernum).w,d0		;d0 = player of controller 1
	tst.w	d4						;d4 selects the controller
	beq.w	.0						;0: keep controller 1
	move.w	(c2playernum).w,d0		;else controller 2's player
.0									;player chosen
	tst.w	d0						;no player?
	bmi.w	.x						;none: skip
	asl.w	#7,d0					;SCnum * $80, the sort object size
	movea.l	#SortCords,a0			;a0 = sort objects
	adda.w	d0,a0					;a0 = that player's object
	bset	#6,pflags3(a0)			;flag it in pflags3
.x									;exit: restore the registers
	movem.l	(sp)+,d0/a0				;restore registers
rtss7								;shared rts for the early exits nearby
	rts
; Find goalie SCnum, store in d0
; If no goalie, store FFFF in d0
getGoalieSCnum						;d0 = SCnum of the goalie in the 6 sort objects
									;up to object d0, -1 if none
	movem.l	d1/a0,-(sp)				;save registers
	movea.l	#SortCords,a0			;a0 = sort objects
	asl.w	#7,d0					;start at object d0
	adda.w	d0,a0					;a0 = that object
	move.w	#5,d1					;check 6 objects
.loop								;scan the 6 objects down from d0 for the goalie (position 0)
	tst.w	position(a0)			;position 0 is the goalie
	beq.w	.goalie					;found
	suba.w	#$80,a0					;previous object
	dbf	d1,.loop					;loop
	move.w	#$FFFF,d0				;none found: d0 = -1
	bra.w	.end					;done
.goalie								;found: d0 = its SCnum
	move.w	SCnum(a0),d0			;d0 = goalie's SCnum
.end								;exit: restore the registers
	movem.l	(sp)+,d1/a0				;restore registers
	rts								;done
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
	tst.w	(OptLine).w				;OptLine set?
	bne.w	rtss7					;yes: nothing to do
	btst	#4,(sflags7).w			;sflags7 bit 4 set?
	bne.w	rtss7					;yes: nothing to do
	bsr.w	loadTeamStruct			;a2 = team structure
	bset	#tmflcm,tmflags(a2)		;set the line change mode flag
	bne.w	rtss7					;already set: done
	btst	#3,(sflags5).w			;sflags5 bit 3 set?
	bne.w	.0						;yes: keep the shot direction
	bclr	#sfspdir,(sflags).w		;clear sfspdir
.0									;clear the shot dir
	bclr	#sfssdir,(sflags).w		;clear sfssdir
	bset	#pf2lcm,pflags2(a3)		;a3 flagged pf2lcm
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
	sub.w	tmap(a2),d2				;d2 = player difference to the other team
	beq.w	.0						;equal: nothing to add
	addi.w	#$15,d0					;first step
	tst.w	d2						;sign of the difference
	bmi.w	.0						;negative: one step is enough
	addi.w	#$15,d0					;second step
.0									;row offset chosen
	move.w	tmline(a2),d1			;d1 = current line
	add.w	d1,d0					;d0 += 3 * line
	add.w	d1,d0					;(second)
	add.w	d1,d0					;(third)
	lea	.tab(pc),a0					;a0 = choice table
	move.b	0(a0,d0.w),d0			;look up the choice
	ext.w	d0						;word
	movem.l	(sp)+,d1-d2				;restore registers
	rts								;done
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
	btst	#sfhor,(sflags).w		;horizontal rink (sfhor)?
	bne.w	rtss					;yes: nothing to erase
	bsr.w	setlccords				;get the box position
	cmpi.w	#$F,(printy).w			;printy below $F?
	blt.w	.nollcm					;yes: keep sf3llcs
	bclr	#sf3llcs,(sflags3).w	;clear sf3llcs
.nollcm								;erase the box
	addq.w	#1,d1					;d1 = 1 and d2 = $7FF tile: erase the box area
	move.w	#$7FF,d2				;tile $7FF
	bsr.w	eraser					;erase the box
	bra.w	printscores1			;redraw the scores
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
	cmp.w	(c1playernum).w,d0		;already the controlled player?
	beq.w	.ex						;yes: nothing to do
	movem.l	d1/a0-a1,-(sp)			;save registers
	move.w	(c1playernum).w,d1		;d1 = old player
	bsr.w	restorepl				;restore the old player
	move.w	d0,(c1playernum).w		;new controlled player
	movem.l	(sp)+,d1/a0-a1			;restore registers
.ex									;exit (also the end of the code above)
	rts								;done
; restore old player and switch to new d0 player on cont. 2
setc2player							;restore old player and switch to new d0 player on cont. 2
	cmp.w	(c2playernum).w,d0		;already the controlled player?
	beq.w	.ex						;yes: nothing to do
	movem.l	d1/a0-a1,-(sp)			;save registers
	move.w	(c2playernum).w,d1		;d1 = old player
	bsr.w	restorepl				;restore the old player
	move.w	d0,(c2playernum).w		;new controlled player
	movem.l	(sp)+,d1/a0-a1			;restore registers
.ex									;exit (also the end of the code above)
	rts								;done
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
	movem.l	d0-d1,-(sp)				;save registers
	moveq	#2,d0					;d0 = 2
	add.w	d4,d0					;plus d4
	add.w	d0,d0					;times 2: the nibble shift
	move.w	#$FFF0,d1				;nibble mask
	rol.w	d0,d1					;mask over the nibble
	and.w	d1,(PadControlBits).w	;clear the nibble
	move.w	SCnum(a3),d1			;d1 = SCnum of a3
	asl.w	d0,d1					;into the nibble
	or.w	d1,(PadControlBits).w	;set it
	movem.l	(sp)+,d0-d1				;restore registers
rtss3								;shared rts for the early exits nearby
	rts
