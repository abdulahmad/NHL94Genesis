updateplayers
	btst	#sfhor,(sflags).l
	bne.w	.checkcrowd
	ori.w	#$F,(PadControlBits).l
	cmpi.w	#$5,(puckz).l
	bgt.w	.gt
.clrcnt	clr.w	(PuckZCntr).l
	bra.w	.checkcrowd
.gt	move.w	(TmpPuckZ).l,d0
	cmp.w	(puckz).l,d0
	beq.w	.next2
	move.w	(puckz).l,(TmpPuckZ).l
	bra.w	.clrcnt
.next2	addi.w	#$1,(PuckZCntr).l
	cmpi.w	#$10,(PuckZCntr).l
	blt.w	.checkcrowd
	clr.w	(PuckZCntr).l
	subi.w	#$1,(puckz).l
.checkcrowd	bclr	#$6,(sflags7).l
	move.w	(CurCrowdMeter).l,d0
	cmp.w	(CrowdRecord).l,d0
	blt.w	.nobreak
	bset	#$6,(sflags7).l
.nobreak	jsr	(PlayedByAwayClearFlag).l
	tst.w	(puckc).l
	bmi.w	.next5
	bclr	#$7,(sflags8).l
	bclr	#$1,(sflags6).l
	move.w	(puckc).l,d0
	asl.w	#$7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	btst	#pf3break,pflags3(a3)
	beq.w	.next5
	bclr	#$4,(gmode2).l
.next5	movea.l	#SortCords,a3
.top	move.l	$0(a3),OldXpos(a3)
	move.l	Ypos(a3),OldYpos(a3)
	move.l	Zpos(a3),OldZpos(a3)
	btst	#pf3fall,pflags3(a3)
	beq.w	.top2
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	tst.w	SPAnum(a3)
	bne.w	.0
	jsr	(PlaceBoardFall).l
	bra.w	.top2
.0	cmpi.w	#$193E,SPA(a3)
	beq.w	.10
	cmpi.w	#$1A00,SPA(a3)
	beq.w	.8
	cmpi.w	#$18CC,SPA(a3)
	beq.w	.9
	cmpi.w	#$17E8,SPA(a3)
	beq.w	.7
	cmpi.w	#$1776,SPA(a3)
	beq.w	.1
	cmpi.w	#$185A,SPA(a3)
	beq.w	.4
	bra.w	.top2
.1	move.w	#$124,d0
	cmpi.w	#$56,(FallXPos).l
	bgt.w	.2
	cmpi.w	#$FFAA,(FallXPos).l
	bgt.w	.3
.2	move.w	#$116,d0
.3	move.w	d0,Ypos(a3)
	bra.w	.top2
.4	move.w	#$FEDC,d0
	cmpi.w	#$56,(FallXPos).l
	bgt.w	.5
	cmpi.w	#$FFAA,(FallXPos).l
	bgt.w	.6
.5	move.w	#$FEEA,d0
.6	move.w	d0,Ypos(a3)
	bra.w	.top2
.7	move.w	#$82,$0(a3)
	btst	#$3,attribute(a3)
	beq.w	.top2
	move.w	#$FF7E,$0(a3)
	bra.w	.top2
.8	move.w	#$88,$0(a3)
	btst	#$3,attribute(a3)
	beq.w	.top2
	move.w	#$FF78,$0(a3)
	bra.w	.top2
.9	move.w	#$FF7E,$0(a3)
	btst	#$3,attribute(a3)
	beq.w	.top2
	move.w	#$82,$0(a3)
	bra.w	.top2
.10	move.w	#$FF78,$0(a3)
	btst	#$3,attribute(a3)
	beq.w	.top2
	move.w	#$88,$0(a3)
.top2	tst.w	position(a3)
	bmi.w	.nf1
	move.w	SCnum(a3),d0
	cmp.w	(puckc).l,d0
	beq.w	.top3
	bclr	#pf3break,pflags3(a3)
	bclr	#pf3oside,pflags3(a3)
.top3	bsr.w	updateanim
	sub.b	d7,nopuck(a3)
	bpl.w	.np
	clr.b	nopuck(a3)
.np	sub.b	d7,$5F(a3)
	bpl.w	.np2
	clr.b	$5F(a3)
.np2	btst	#sf3icetime,(sflags3).l
	beq.w	.11
	clr.w	d0
	move.b	pnum(a3),d0
	bmi.w	.11
	add.w	d0,d0
	addi.w	#$138,d0
	jsr	(loadTeamStruct).l
	addi.w	#$1,(a2,d0.w)
.11	cmpi.w	#$145C,SPA(a3)
	beq.w	.done
	cmpi.w	#$1AF4,SPA(a3)
	beq.w	.done
	moveq	#$11,d4
	tst.w	(PalMode).l
	beq.w	.notoside
	moveq	#$16,d4
.notoside	mulu.w	d7,d4
	tst.w	Zpos(a3)
	bne.w	.y2
	moveq	#$6,d2
	btst	#pfdoff,pflags(a3)
	beq.w	.off
	moveq	#$9,d2
.off	move.w	Xvel(a3),d0
	beq.w	.x2
	asr.w	d2,d0
	bne.w	.x1
	move.l	#$1,d0
.x1	sub.w	d0,Xvel(a3)
.x2	move.w	Yvel(a3),d0
	beq.w	.y2
	asr.w	d2,d0
	bne.w	.y1
	move.l	#$1,d0
.y1	sub.w	d0,Yvel(a3)
.y2	move.w	Xvel(a3),d0
	beq.w	.x3
	muls.w	d4,d0
	add.l	d0,$0(a3)
.x3	move.w	Yvel(a3),d0
	beq.w	.y3
	muls.w	d4,d0
	add.l	d0,Ypos(a3)
.y3	tst.w	Zpos(a3)
	bmi.w	.done
	bne.w	.z1
	tst.w	Zvel(a3)
	beq.w	.done
.z1	asl.w	#$1,d4
	sub.w	d4,Zvel(a3)
	asl.w	#$1,d4
	sub.w	d4,Zvel(a3)
	lsr.w	#$2,d4
	move.w	Zvel(a3),d0
	muls.w	d4,d0
	add.l	d0,Zpos(a3)
	bpl.w	.done
	clr.l	Zpos(a3)
	neg.w	Zvel(a3)
	asr.w	Zvel(a3)
	moveq	#$5,d0
	sub.b	Zvel(a3),d0
	bpl.w	.next31
	clr.w	d0
.next31	cmpi.w	#$3,d0
	bhi.w	.done
	addi.w	#$2C,d0
	move.w	d0,-(sp)
	bsr.w	sfx
.done	move.w	SCnum(a3),d6
	cmp.w	(puckc).l,d6
	bne.w	.tp
	btst	#pf2fight,pflags2(a3)
	bne.w	.tp
	btst	#sfhor,(sflags).l
	bne.w	.tp
	moveq	#-2,d4
	bsr.w	setpads
.tp	btst	#sf2faceoff,(sflags2).l
	bne.w	.tp2
	tst.w	(holdreset).l
	beq.w	.tp2
	subi.w	#$1,(holdreset).l
	beq.w	.12
	bpl.w	.tp2
.12	clr.w	(holdreset).l
	move.w	#$1111,(bholdtimer).l
	move.w	#$1111,(bholdtimer34).l
.tp2	cmp.w	(c1playernum).l,d6
	bne.w	.t0
	bsr.w	ReadJoy1
	clr.w	d4
	move.w	#$FFFF,(joypuckcarrier).l
	bsr.w	doinput
	bra.w	.next37
.t0	cmp.w	(c2playernum).l,d6
	bne.w	.next37
	bsr.w	ReadJoy2
	move.l	#$2,d4
	move.w	#$FFFF,(joypuckcarrier).l
	bsr.w	doinput
.next37	cmpi.w	#$B,d6
	bgt.w	.t1cont
	tst.w	(cont3team).l
	beq.w	.13
	cmp.w	(c3playernum).l,d6
	bne.w	.13
	jsr	(ReadJoy3).l
	clr.l	d4
	clr.w	(joypuckcarrier).l
	move.w	(cont1team).l,-(sp)
	move.w	(cont3team).l,(cont1team).l
	move.w	(c1playernum).l,-(sp)
	move.w	(c3playernum).l,(c1playernum).l
	move.w	(bholdtimer).l,-(sp)
	move.w	(bholdtimer34).l,(bholdtimer).l
	move.w	(padword1).l,-(sp)
	move.w	(padword3).l,(padword1).l
	move.w	(aholdtimer).l,-(sp)
	move.w	(aholdtimer34).l,(aholdtimer).l
	move.w	(PadControlBits).l,-(sp)
	move.w	(PadControlBits34).l,(PadControlBits).l
	bsr.w	doinput
	move.w	(PadControlBits).l,(PadControlBits34).l
	move.w	(sp)+,(PadControlBits).l
	move.w	(aholdtimer).l,(aholdtimer34).l
	move.w	(sp)+,(aholdtimer).l
	move.w	(padword1).l,(padword3).l
	move.w	(sp)+,(padword1).l
	move.w	(bholdtimer).l,(bholdtimer34).l
	move.w	(sp)+,(bholdtimer).l
	move.w	(c1playernum).l,(c3playernum).l
	move.w	(sp)+,(c1playernum).l
	move.w	(cont1team).l,(cont3team).l
	move.w	(sp)+,(cont1team).l
.13	tst.w	(cont4team).l
	beq.w	.t1cont
	cmp.w	(c4playernum).l,d6
	bne.w	.t1cont
	jsr	(ReadJoy4).l
	move.l	#$2,d4
	move.w	#$1,(joypuckcarrier).l
	move.w	(cont2team).l,-(sp)
	move.w	(cont4team).l,(cont2team).l
	move.w	(c2playernum).l,-(sp)
	move.w	(c4playernum).l,(c2playernum).l
	move.w	(bholdtimer).l,-(sp)
	move.w	(bholdtimer34).l,(bholdtimer).l
	move.w	(padword2).l,-(sp)
	move.w	(padword4).l,(padword2).l
	move.w	(aholdtimer).l,-(sp)
	move.w	(aholdtimer34).l,(aholdtimer).l
	move.w	(PadControlBits).l,-(sp)
	move.w	(PadControlBits34).l,(PadControlBits).l
	bsr.w	doinput
	move.w	(PadControlBits).l,(PadControlBits34).l
	move.w	(sp)+,(PadControlBits).l
	move.w	(aholdtimer).l,(aholdtimer34).l
	move.w	(sp)+,(aholdtimer).l
	move.w	(padword2).l,(padword4).l
	move.w	(sp)+,(padword2).l
	move.w	(bholdtimer).l,(bholdtimer34).l
	move.w	(sp)+,(bholdtimer).l
	move.w	(c2playernum).l,(c4playernum).l
	move.w	(sp)+,(c2playernum).l
	move.w	(cont2team).l,(cont4team).l
	move.w	(sp)+,(cont2team).l
.t1cont	move.w	assnum(a3),d0
	clr.w	d1
	move.b	asslist(a3,d0.w),d1
	asl.w	#$2,d1
	movea.l	#asstab,a0
	movea.l	(a0,d1.w),a0
	jsr	(loadTeamStruct).l
	jsr	(a0)
	clr.w	Wallcos(a3)
	clr.w	Wallsin(a3)
	move.w	$0(a3),d2
	move.w	Ypos(a3),d3
	cmp.w	OldXpos(a3),d2
	bne.w	.cc
	cmp.w	OldYpos(a3),d3
	beq.w	.nf
.cc	jsr	(checkcoll).l
.nf	move.w	d7,d0
	asl.w	#$1,d0
	sub.w	d0,impact(a3)
	bpl.w	.nf1
	clr.w	impact(a3)
.nf1	move.w	impact(a3),limpact(a3)
	adda.l	#$80,a3
	cmpi.w	#$F,-$2E(a3)
	blt.w	.top
	rts
updateanim						;frame switch control on struct a3
	tst.w	SPA(a3)
	bne.w	.ia		;branch if not 0
	bclr	#pfalock,pflags(a3)
	bclr	#$1,pflags2(a3)		;clear anim in progress
	rts
.ia	movea.l	#SPAlist,a0		;animation data tables
	adda.w	SPA(a3),a0		;add SPA to a0 address
	move.w	SPAattr(a0),d1		;16 dec - attributes for anim
	move.w	facedir(a3),d0
	btst	#sfhor,(sflags).l		;check if horizontal mode
	beq.w	.nhor
	cmpi.w	#$C,SCnum(a3)		;compare to 12 (check if a player, not the puck or nets)
	bge.w	.nhor		;branch if greater than (puck or nets)
	subi.w	#$2,d0		;direction adjust for horizontal rink
	andi.w	#$7,d0
.nhor	btst	#$3,attribute(a3)		;x flip flag
	beq.w	.nox		;branch if no flip
	neg.w	d0
	addi.w	#$8,d0		;add 8 to d0 for flipping
	andi.w	#$7,d0		;pass first 3 bits
.nox	asl.w	#$1,d0
	adda.w	(a0,d0.w),a0		;add a0 + d0 offset to a0 - This moves the SPF value into a0
	move.w	SPAnum(a3),d0		;SPANum into d0 (index into animation)
	move.w	(a0,d0.w),d2		;a0 + d0 offset into d2 - this is the new SPF frame of this animation
	tst.w	SPAcnt(a3)		;check if SPAcnt is 0 (time for a new frame)
	bmi.w	.1		;branch if so (SPAcnt is negative)
	sub.w	d7,SPAcnt(a3)		;sub frames elasped from SPAcnt
	bpl.w	.cframe		;branch if SPAcnt is positive
	addi.w	#$4,$5A(a3)		;add 4 to SPAnum (set for next index)
	addi.w	#$4,d0		;add 4 to d0 (currently holds current index)
	tst.w	-$2(a0,d0.w)		;test -2 offset from a0 + d0 (this is the frame
	bpl.w	.1		;branch if positive (not the end of the animation)
	clr.w	d0
	clr.w	SPAnum(a3)
	bclr	#pfalock,pflags(a3)
	bclr	#$1,pflags2(a3)		;clear animation in progress
	bclr	#pf3fall,pflags3(a3)		;clear fall down flag
	btst	#$0,d1		;check if anim attribute loops
	bne.w	.1
	clr.w	SPA(a3)
.1	move.w	$2(a0,d0.w),d0		;move frame time for animation frame into d0
	bpl.w	.0
	neg.w	d0		;make d0 negative (this is the case if final frame)
.0	move.w	d0,SPAcnt(a3)		;move d0 into SPAcnt
.cframe	sub.b	d7,glitch(a3)		;sub frames elapsed from glitch - limit minimum
	bpl.w	.rtss		;branch if glitch is positive still
	clr.b	glitch(a3)
	cmp.w	frame(a3),d2		;compare frame to d2
	beq.w	.rtss
	move.w	d2,frame(a3)		;move d2 into frame
	move.b	#$4,glitch(a3)		;move 4 into glitch - /60 sec min frame switch time
.rtss	rts
freezewindow						;lock scrolling to the current position
	move.w	(Vpos).l,(yc1).l
	move.w	(Hpos).l,(xc1).l
	bset	#sfslock,(sflags).l
	rts
checkwindow
	move.w	(yc1).l,d2
	move.w	(xc1).l,d3
	btst	#sfslock,(sflags).l
	bne.w	.dd
	movea.l	#puckx,a3
	move.w	(puckc).l,d0
	bmi.w	.0
	asl.w	#$7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	move.w	d7,d0
	add.w	d0,d0
	btst	#pfgoal,pflags(a3)
	beq.w	.gd
	add.w	d0,(yleader).l
	cmpi.w	#$32,(yleader).l
	blt.w	.0
	move.w	#$32,(yleader).l
	bra.w	.0
.gd	sub.w	d0,(yleader).l
	cmpi.w	#$FFCE,(yleader).l
	bgt.w	.0
	move.w	#$FFCE,(yleader).l
.0	move.w	Yvel(a3),d2
	asr.w	#$7,d2
	add.w	Ypos(a3),d2
	add.w	(yleader).l,d2
	move.w	$0(a3),d3
	move.w	d2,(yc1).l
	move.w	d3,(xc1).l
.dd	move.w	d2,d0
	sub.w	(Vpos).l,d0
	cmpi.w	#$FFF6,d0
	bge.w	.next4
	move.w	d2,d1
	subi.w	#$FFF6,d1
	cmpi.w	#$FF38,d1
	bgt.w	.2
	move.w	#$FF38,d1
	bra.w	.2
.next4	cmpi.w	#$A,d0
	ble.w	.2x
	move.w	d2,d1
	subi.w	#$A,d1
	cmpi.w	#$100,d1
	blt.w	.2
	move.w	#$100,d1
.2	sub.w	(Vpos).l,d1
	beq.w	.2x
	asr.w	#$4,d1
	bne.w	.v2
	addi.w	#$1,d1
.v2	add.w	d1,(Vpos).l
.2x	move.w	d3,d0
	sub.w	(Hpos).l,d0
	cmpi.w	#$FFD8,d0
	bge.w	.next8
	move.w	d3,d1
	subi.w	#$FFD8,d1
	cmpi.w	#$FFC4,d1
	bge.w	.4
	move.w	#$FFC4,d1
	bra.w	.4
.next8	cmpi.w	#$28,d0
	ble.w	.x
	move.w	d3,d1
	subi.w	#$28,d1
	cmpi.w	#$3C,d1
	ble.w	.4
	move.w	#$3C,d1
.4	sub.w	(Hpos).l,d1
	beq.w	.x
	asr.w	#$4,d1
	bne.w	.h2
	addi.w	#$1,d1
.h2	add.w	d1,(Hpos).l
.x	rts

doinput
	btst	#$4,d1
	beq.w	.1
	btst	#$5,d1
	beq.w	.1
	bclr	#$4,d1
	bset	#$6,pflags3(a3)
	bra.w	.5
.1	btst	#$4,d1
	beq.w	.2
	bclr	#$6,pflags3(a3)
.2	btst	#$4,d2
	beq.w	.5
	bclr	#$6,pflags3(a3)
	beq.w	.5
	tst.w	d4
	bne.w	.3
	move.b	#$11,(bholdtimer).l
	bra.w	.4
.3	move.b	#$11,(PlayerSwitchDelay).l
.4	bclr	#$4,d2
.5	btst	#$7,(gmode2).l
	beq.w	.6
	bclr	#$6,d0
	bclr	#$6,d1
	bclr	#$6,d2
	bclr	#$6,d3
	cmpi.b	#$8,d0
	beq.w	.6
	jsr	(ShortenMsgTimer).l
	move.l	#$8,d0
	clr.l	d1
	clr.l	d2
	clr.l	d3
.6	move.w	d0,(TempWord1).l
	andi.w	#$F,(TempWord1).l
	bsr.w	setpads
	btst	#$7,d1
	beq.w	.nostart
	tst.w	(joypuckcarrier).l
	bpl.w	.7
	tst.w	d4
	beq.w	startpause1
	bra.w	startpause2
.7	btst	#$7,d1
	beq.w	.nostart
	tst.w	(joypuckcarrier).l
	beq.w	startpause3
	bra.w	startpause4
.nostart	btst	#sfhor,(sflags).l
	beq.w	.nhor
	btst	#$3,d0
	bne.w	.nhor
	addi.w	#$2,d0
	andi.w	#$7,d0
.nhor	btst	#sf2faceoff,(sflags2).l
	bne.w	faceoffinput
	btst	#pf2lcm,pflags2(a3)
	bne.w	lineinput
	btst	#pfjoycon,pflags(a3)
	beq.w	rtss15
	movem.l	d0-d2/a0/a3,-(sp)
	move.w	(lastplayer).l,d0
	cmp.w	SCnum(a3),d0
	bne.w	.noot
	tst.w	(passReceiverPlayerNum).l
	bmi.w	.noot
	tst.w	(onetimerplayer).l
	bpl.w	.noot
	btst	#$5,d1
	beq.w	.noot
	move.w	(passReceiverPlayerNum).l,d0
	asl.w	#$7,d0
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
	move.w	d4,(inputjoy).l
	move.w	(joypuckcarrier).l,(TmpJoyPuckCarrier).l
	move.w	#$23,d0
	jsr	(assreplace).l
	movem.l	(sp)+,d0-d2/a0/a3
	rts
.noot	movem.l	(sp)+,d0-d2/a0/a3
	btst	#pf3onetimer,pflags3(a3)
	bne.w	.chkfight
	btst	#pfalock,pflags(a3)
	bne.w	doinput_islocked
.chkfight	btst	#pf2fight,pflags2(a3)
	bne.w	fightinput
	move.w	(puckc).l,d5
	cmp.w	SCnum(a3),d5
	beq.w	doinput_ispc
	tst.w	position(a3)
	beq.w	.11
	btst	#pf3onetimer,pflags3(a3)
	beq.w	.10
	bra.w	.11
.10	btst	#$6,d1
	bne.w	Holdplayer
.11	tst.w	position(a3)
	beq.w	.12
	btst	#$2,(BA_PS_flags).l
	bne.w	.noswitch
	bra.w	.bhold
.12	btst	#$6,(sflags5).l
	bne.w	.bhold
	tst.w	d4
	beq.w	.13
	tst.w	(goaliemode2).l
	bra.w	.14
.13	tst.w	(goaliemode1).l
.14	beq.w	.bhold
	movem.w	d0,-(sp)
	move.w	SCnum(a3),d0
	cmp.w	(puckc).l,d0
	movem.w	(sp)+,d0
	beq.w	.bhold
	bra.w	PassToJump
.bhold	btst	#$4,d3
	beq.w	.bpress
	tst.w	(holdreset).l
	bne.w	.bpress
	tst.w	d4
	beq.w	.c1
	tst.b	(PlayerSwitchDelay).l
	beq.w	.noswitch
	subi.b	#$1,(PlayerSwitchDelay).l
	bpl.w	.16
	move.b	#$0,(PlayerSwitchDelay).l
.16	tst.b	(PlayerSwitchDelay).l
	bne.w	.bpress
	tst.w	d4
	beq.w	.17
	tst.w	(goaliemode2).l
	bra.w	.18
.17	tst.w	(goaliemode1).l
.18	bne.w	.bpress
	bra.w	.goalie
.c1	tst.b	(bholdtimer).l
	beq.w	.noswitch
	subi.b	#$1,(bholdtimer).l
	bpl.w	.20
	move.b	#$0,(bholdtimer).l
.20	tst.w	d4
	beq.w	.21
	tst.w	(goaliemode2).l
	bra.w	.22
.21	tst.w	(goaliemode1).l
.22	bne.w	.bpress
	tst.b	(bholdtimer).l
	beq.w	.goalie
.bpress	btst	#$4,d1
	beq.w	.brel
	tst.w	d4
	bne.w	.24
	move.b	#$11,(bholdtimer).l
	bra.w	.noswitch
.24	move.b	#$11,(PlayerSwitchDelay).l
	bra.w	.noswitch
.brel	btst	#$4,d2
	beq.w	.noswitch
	btst	#$4,d3
	bne.w	.noswitch
	move.w	(bholdtimer).l,d0
	tst.w	d4
	beq.w	.28
	move.b	#$11,(PlayerSwitchDelay).l
	andi.w	#$FF,d0
	bne.w	PassToJump
	tst.w	d4
	beq.w	.26
	tst.w	(goaliemode2).l
	bra.w	.27
.26	tst.w	(goaliemode1).l
.27	bne.w	PassToJump
	bra.w	.goalie
.28	move.b	#$11,(bholdtimer).l
	andi.w	#$FF00,d0
	bne.w	PassToJump
	tst.w	d4
	beq.w	.29
	tst.w	(goaliemode2).l
	bra.w	.30
.29	tst.w	(goaliemode1).l
.30	bne.w	PassToJump
.goalie	tst.w	(holdreset).l
	bne.w	PassToJump
	move.w	#$5,d0
	cmpi.w	#$5,d6
	ble.w	.32
	move.w	#$B,d0
.32	jsr	(getGoalieSCnum).l
	tst.w	d0
	bmi.w	rtss15
	movem.l	d0/a3,-(sp)
	movea.l	#SortCords,a3
	asl.w	#$7,d0
	adda.w	d0,a3
	btst	#pfjoycon,pflags(a3)
	movem.l	(sp)+,d0/a3
	bne.w	rtss15
	tst.w	d4
	beq.w	setc1player
	bra.w	setc2player
.noswitch	tst.w	position(a3)
	bne.w	doinput_onetimer
	btst	#$6,d1
	beq.w	doinput_cbut
	move.w	(TempWord1).l,d0
	cmpi.b	#$8,d0
	beq.w	doinput_cbut
	move.w	d0,facedir(a3)
	move.b	#$8,nopuck(a3)
	move.w	#$2F4,d1
	bsr.w	SetSPA
	bset	#$1,pflags2(a3)
	bset	#pfalock,pflags(a3)
	addi.w	#$96,(Crowdlevel).l
rtss15
	rts
; doinput: button checks at the exit
doinput_cbut	btst	#$5,d1
	bne.w	.next3
	btst	#$5,d3
	bne.w	.next
	bclr	#$7,pflags2(a3)
	bra.w	doinput_chkanim
.next	btst	#$7,pflags2(a3)
	beq.w	doinput_chkanim
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	#SPAlist,a0
	adda.w	SPA(a3),a0
	move.w	facedir(a3),d0
	btst	#$3,attribute(a3)
	beq.w	.next2
	neg.w	d0
	addi.w	#$8,d0
	andi.w	#$7,d0
.next2	asl.w	#$1,d0
	adda.w	(a0,d0.w),a0
	tst.b	$5B(a3)
	movem.l	(sp)+,d0-d3/a0-a3
	bpl.w	rtss15
	move.w	#$A,SPAcnt(a3)
	rts
.next3	btst	#$5,pflags(a3)
	bne.w	doinput_chkanim
	movem.w	d0-d1,-(sp)
	move.w	(puckx).l,d0
	sub.w	$0(a3),d0
	move.w	(pucky).l,d1
	sub.w	Ypos(a3),d1
	bsr.w	vtoa
	move.w	d0,facedir(a3)
	movem.w	(sp)+,d0-d1
	move.w	(TempWord1).l,d0
	bclr	#$0,(BA_PS_flags).l
	move.w	(gameclock).l,d0
	andi.w	#$7,d0
	asl.w	#$4,d0
	addi.w	#$A0,d0
	cmpi.w	#$DB,(pucky).l
	bgt.w	.next4
	cmpi.w	#$FF25,(pucky).l
	bgt.w	.next5
.next4	subi.w	#$40,d0
.next5	move.w	d0,d1
	muls.w	(puckvx).l,d0
	swap	d0
	add.w	(puckx).l,d0
	muls.w	(puckvy).l,d1
	swap	d1
	add.w	(pucky).l,d1
	bsr.w	ClampTargetY
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmpi.l	#$384,d0
	bhi.w	.next6
	movem.w	(sp)+,d0-d1
	bra.w	.next8
.next6	bsr.w	Sroot
	moveq	#$1,d2
	add.w	d0,d2
	moveq	#$12,d4
	btst	#$3,(sflags).l
	beq.w	.next7
	addi.w	#$8,d4
.next7	movem.w	(sp)+,d0-d1
	muls.w	d4,d1
	addi.w	#$8,d4
	muls.w	d4,d0
	divs.w	d2,d0
	divs.w	d2,d1
.next8	add.w	d3,d1
	move.w	d1,d2
	cmpi.w	#$22,$2(a0)
	cmpi.w	#$18,(a0)
	cmpi.w	#$FFE8,(a0)
	cmpi.w	#$C,$2(a0)
	cmpi.w	#$108,(pucky).l
	cmpi.w	#$FEF8,(pucky).l
	bset	#$1,pflags2(a3)
	bne.w	doinput_chkanim
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#puckcross,a0
	move.w	#$108,d3
	btst	#$7,pflags(a3)
	beq.w	.next9
	neg.w	d3
	adda.w	#$4,a0
.next9	jsr	(goaliesave).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ClampTargetY	move.w	(puckc).l,d2
	cmp.w	SCnum(a3),d2
	bne.w	.next11
	clr.w	d0
.next11	cmpi.w	#$103,d1
	blt.w	.next12
	move.w	#$103,d1
.next12	cmpi.w	#$FEFD,d1
	bgt.w	.next13
	move.w	#$FEFD,d1
.next13	sub.w	d3,d1
	rts
ClampTargetY_2A						;Nothing while a3's animation runs (pflags2 bit 1); else skate a3
									;(doplayeracc)
	bchg	d0,d6
	bchg	d0,$250.w
	andi.l	#$1EC021E,-(a2)
; Instruction bytes inside ClampTargetY_2A that the assembler would encode differently, kept as words (1 row).
	dc.w	$148E,$14C0,$14F2,$1544
; doinput: skips when flag 1 of $63 is clear
doinput_chkanim
	btst	#$1,pflags2(a3)
	beq.w	.next
	rts
.next	tst.w	position(a3)
	bne.w	doplayeracc
	bclr	#$1,(BA_PS_flags).l
	cmpi.w	#$24,$0(a3)
	ble.w	.next2
	tst.w	Xvel(a3)
	bmi.w	.next2
	beq.w	.next2
	bset	#$1,(BA_PS_flags).l
	clr.w	Xvel(a3)
.next2	cmpi.w	#$FFDC,$0(a3)
	bge.w	.next3
	tst.w	Xvel(a3)
	bpl.w	.next3
	bset	#$1,(BA_PS_flags).l
	clr.w	Xvel(a3)
.next3	cmpi.w	#$E7,Ypos(a3)
	bgt.w	.next5
	cmpi.w	#$FF19,Ypos(a3)
	ble.w	.next5
	bra.w	.next4
.next4	movem.w	d0-d1,-(sp)
	move.w	Ypos(a3),d0
	move.w	Yvel(a3),d1
	eor.w	d1,d0
	movem.w	(sp)+,d0-d1
	bpl.w	.next5
	tst.w	Yvel(a3)
	beq.w	.next5
	bset	#$1,(BA_PS_flags).l
	clr.w	Yvel(a3)
.next5	btst	#$1,(BA_PS_flags).l
	bne.w	rtss15
	move.w	(TempWord1).l,d0
	bra.w	doplayeracc
doinput_onetimer						;a3 is set for a one-timer: C (bit 5) starts the one-timer shot, else
									;skate
	move.w	(TempWord1).l,d0
	btst	#pf3onetimer,pflags3(a3)
	bne.w	rtss7
	btst	#$5,d1
	beq.w	doplayeracc
	movem.l	d7/a0,-(sp)
	move.w	(lastplayer).l,d7
	asl.w	#$7,d7
	movea.l	#SortCords,a0
	adda.w	d7,a0
	tst.w	position(a0)
	movem.l	(sp)+,d7/a0
	beq.w	burst
	movem.w	d7,-(sp)
	move.w	SCnum(a3),d7
	cmp.w	(passReceiverPlayerNum).l,d7
	movem.w	(sp)+,d7
	bne.w	burst
	tst.w	(puckc).l
	bpl.w	burst
	jsr	(PuckOnAttackHalf).l
	beq.w	burst
	move.w	d0,-(sp)
	move.w	d4,(inputjoy).l
	move.w	(joypuckcarrier).l,(TmpJoyPuckCarrier).l
	move.w	#$23,d0
	jsr	(assreplace).l
	move.w	(sp)+,d0
	rts
doinput_ispc						;a3 has the puck: pass mode, shot mode, or start a pass / shot by the
									;buttons
	bsr.w	checkob
	tst.w	position(a3)
	bne.w	.0
	btst	#$1,pflags2(a3)
	bne.w	rtss15
.0	btst	#sfspdir,(sflags).l
	bne.w	passmode
	btst	#sfssdir,(sflags).l
	bne.w	ShotMode
	btst	#$4,d1
	beq.w	.1
	jsr	(GetTeamStructCount).l
	bra.w	setpassmode
.1	btst	#$6,d1
	beq.w	.ahold
	tst.w	d4
	beq.w	.2
	move.b	#$F,(aholdtimer+1).l
	bra.w	.ahold
.2	move.b	#$F,(aholdtimer).l
.ahold	btst	#$6,d3
	beq.w	.arel
	tst.w	d4
	beq.w	.c1
	subi.b	#$1,(aholdtimer+1).l
	bpl.w	.4
	move.b	#$0,(aholdtimer+1).l
.4	tst.b	(aholdtimer+1).l
	bne.w	.arel
	bset	#$3,(sflags5).l
	jsr	(setpassmode).l
	bra.w	SetLCmode
.c1	subi.b	#$1,(aholdtimer).l
	bpl.w	.6
	move.b	#$0,(aholdtimer).l
.6	tst.b	(aholdtimer).l
	bne.w	.arel
	bset	#$3,(sflags5).l
	jsr	(setpassmode).l
	bra.w	SetLCmode
.arel	btst	#$6,d3
	bne.w	.8
	btst	#$6,d2
	beq.w	.8
	bset	#$3,(sflags5).l
	bra.w	setpassmode
.8	tst.w	position(a3)
	bne.w	.shot
	bra.w	doplayeracc
.shot	btst	#$5,d1
	beq.w	doplayeracc
	jsr	(GetTeamStructCount).l
	bra.w	SetShotMode
doinput_islocked						;a3 is locked in an animation: B (bit 4) changes the controlled player
	move.w	(puckc).l,d5
	cmp.w	SCnum(a3),d5
	beq.w	rtss15
	btst	#$4,d1
	beq.w	rtss7
	btst	#$6,(sflags5).l
	bne.w	rtss7
	bsr.w	PassToJump
	movem.l	d0/a0,-(sp)
	move.w	(c1playernum).l,d0
	tst.w	d4
	beq.w	.0
	move.w	(c2playernum).l,d0
.0	tst.w	d0
	bmi.w	.x
	asl.w	#$7,d0
	movea.l	#SortCords,a0
	adda.w	d0,a0
	bset	#$6,pflags3(a0)
.x	movem.l	(sp)+,d0/a0
rtss7
	rts
getGoalieSCnum						;d0 = SCnum of the goalie in the 6 sort objects
									;up to object d0, -1 if none
	movem.l	d1/a0,-(sp)
	movea.l	#SortCords,a0
	asl.w	#$7,d0
	adda.w	d0,a0
	move.w	#$5,d1
.loop	tst.w	position(a0)
	beq.w	.goalie
	suba.w	#$80,a0
	dbra	d1,.loop
	move.w	#$FFFF,d0
	bra.w	.end
.goalie	move.w	SCnum(a0),d0
.end	movem.l	(sp)+,d1/a0
	rts
faceoffinput						;controller processing for faceoff
	btst	#$6,(sflags5).l
	beq.w	FaceoffInputBody
FaceoffInputReturn	rts
FaceoffInputBody	move.w	assnum(a3),d4		;move assnum into d4
	cmpi.b	#$17,asslist(a3,d4.w)		;check if afaceoffpl is in asslist at assnum position
	bne.w	rtss7		;exit if this is not a faceoff player
	movea.l	#fodir1,a0		;faceoff direction of puck control variable
	btst	#$7,pflags(a3)		;check which goal shooting on
	beq.w	.2		;branch if bottom goal
	movea.l	#fodir2,a0
.2	move.w	d0,(a0)		;store dpad for faceoff pull
	btst	#$1,pflags2(a3)		;check if anim in progress
	beq.w	.next
	jmp	(FaceoffInputReturn).l
.next	btst	#$4,d1		;test for b button press
	beq.w	.1		;branch if pressed
	move.w	#$FEA,d1
	bset	#$1,pflags2(a3)		;set anim in progress
	bra.w	SetSPA
.1	move.w	#$1014,d1		;#SPAfaceoffr anim
	bra.w	SetSPA
fightinput
	rts
; Leaves faceoff input when the player is locked.
SetLCmode
	tst.w	(OptLine).l
	bne.w	rtss7
	btst	#$4,(sflags7).l
	bne.w	rtss7
	jsr	(loadTeamStruct).l
	bset	#$1,tmflags(a2)
	bne.w	rtss7
	btst	#$3,(sflags5).l
	bne.w	.next
	bclr	#$2,(sflags).l
.next	bclr	#$3,(sflags).l
	bset	#$3,pflags2(a3)
SetLCmode2
	bsr.w	setlccords
	cmpi.w	#$F,(printy).l
	blt.w	.box
	bset	#sf3llcs,(sflags3).l
	bra.w	.next2
.box	jsr	(box).l
	bsr.w	setlccords
.next2	jsr	(Framer).l
	subi.w	#$2,(printy).l
	addi.w	#$1,(printx).l
	moveq	#$2,d4
.loop	move.w	d4,d0
	bsr.w	getlchoice
	tst.w	d0
	bmi.w	.next5
	btst	#$1,tmflags(a2)
	bne.w	.next3
	cmp.w	tmlcchoice(a2),d4
	bne.w	.next4
	move.w	tmline(a2),d0
.next3	movea.l	#mesarea,a1
	move.l	#$44120,(a1)		;String length 4, 'A ' (a constant, not an address)
	add.b	d4,$2(a1)
	jsr	(print).l
	move.w	d0,-(sp)
	movea.l	#linelist,a1
	jsr	(Fprintsmall).l
	move.w	(sp)+,d0
	jsr	(linebar).l
	subi.w	#$5,(printx).l
.next4	subi.w	#$1,(printy).l
.next5	dbra	d4,.loop
	movea.l	tmdata(a2),a1
	adda.w	Teamname(a1),a1
	adda.w	(a1),a1
	addi.w	#$2,(printx).l
	jmp	(print).l
setlccords						;set printx/y to cords for lc box on team a2
	clr.w	d0
	cmpa.l	#tmstruct,a2
	bne.w	.0
	eori.w	#$16,d0
.0	btst	#gmdir,(gmode).l		;reverse direction: flip to the other end
	beq.w	.next
	eori.w	#$16,d0
.next	jsr	(printz).l
	String	CC_Font1Pri,$16,$0
	add.w	d0,(printy).l
	moveq	#$2,d0
	bsr.w	getlchoice
	moveq	#$6,d1		;3 rows
	tst.w	d0
	bpl.w	.ex
	subi.w	#$1,d1		;no third choice: 2 rows
	addi.w	#$1,(printy).l
.ex	moveq	#$9,d0
	rts
; Picks the line-change coordinates for the current side.
getlchoice
	movem.l	d1-d2,-(sp)
	move.w	$38C(a2),d2
	cmpa.l	#tmstruct,a2
	beq.w	getlchoice2
	move.w	-$340(a2),d2
getlchoice2						;add $15 to d0 for each player more or fewer than the other team has on
									;the ice
	sub.w	tmap(a2),d2
	beq.w	.0
	addi.w	#$15,d0
	tst.w	d2
	bmi.w	.0
	addi.w	#$15,d0
.0	move.w	tmline(a2),d1
	add.w	d1,d0
	add.w	d1,d0
	add.w	d1,d0
	lea.l	.next(pc),a0
	move.b	(a0,d0.w),d0
	ext.w	d0
	movem.l	(sp)+,d1-d2
	rts
; Table of 32 words after getlchoice2, 64 bytes: $0001,$0201,$0200,$0200,$0100,$0102 ...
.next	dc.w	$0001,$0201,$0200,$0200,$0100,$0102,$0001,$0200
	dc.w	$0102,$0001,$0203,$04FF,$0304,$FF03,$04FF,$0304
	dc.w	$FF04,$03FF,$0304,$FF03,$04FF,$0506,$FF05,$06FF
	dc.w	$0506,$FF05,$06FF,$0506,$FF05,$06FF,$0605,$FF00
lineinput						;process input for line changes
									;d1 = new button presses
	btst	#$3,(sflags5).l
	beq.w	.0
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(passmode).l
	movem.l	(sp)+,d0-d7/a0-a6
.0	move.w	d1,-(sp)
	movea.l	#tmstruct,a2
	btst	#pfteam,pflags(a3)
	beq.w	.2
	adda.w	#tmsize,a2
.2	bclr	#tmflcc,tmflags(a2)		;Flag to start lc mode
	beq.w	.1
	bsr.w	lcfound_close		;close the old box
	bsr.w	SetLCmode2		;start lc mode
.1	move.w	(sp)+,d1
	clr.w	d2
	btst	#$6,d1
	bne.w	lcfound
	addi.w	#$1,d2
	btst	#$4,d1
	bne.w	lcfound
	addi.w	#$1,d2
	btst	#$5,d1
	bne.w	lcfound
	btst	#pfjoycon,pflags(a3)
	beq.w	.x
	btst	#pfalock,pflags(a3)
	bne.w	.x
	btst	#pf2fight,pflags2(a3)
	beq.w	doplayeracc		;skate with dpad if not fighting
.x	rts
; Stores the choice and sets its coordinates.
lcfound
	move.w	d2,d0
	move.w	d2,tmlcchoice(a2)
	bsr.w	getlchoice
	tst.w	d0
	bpl.w	.next
	jmp	(FaceoffInputReturn).l
.next	bclr	#$3,pflags2(a3)
	bset	#$3,pflags(a3)
	jsr	(loadTeamStruct).l
	bclr	#$1,tmflags(a2)
	move.w	d0,tmline(a2)
	jsr	(setpersonel).l
lcfound_close						;close lc box
	btst	#sfhor,(sflags).l
	bne.w	rtss
	bsr.w	setlccords
	cmpi.w	#$F,(printy).l
	blt.w	.nollcm
	bclr	#sf3llcs,(sflags3).l
.nollcm	addi.w	#$1,d1		;d1 = 1 and d2 = $7FF tile: erase the box area
	move.w	#$7FF,d2
	bsr.w	eraser
	jmp	(printscores1).l
burst						;cbut press check/speed. Also entered from check4check burst costs energy
									;$CC (only when line changes are on, OptLine = 0)
	jsr	(getpde).l
	tst.w	(OptLine).l
	bne.w	.0
	subi.w	#$CC,d0
	jsr	(setpde).l
	btst	#$4,(sflags7).l
	beq.w	.0
	move.w	#$1000,d0
.0	lsr.w	#$7,d0		;d0 will be $1000 with lines off
	move.w	d0,d1		;energy = speed increase (check violence)
	move.w	facedir(a3),d2		;facedir
	asl.w	#$2,d2
	movea.l	#dirtab,a0
	muls.w	(a0,d2.w),d0
	muls.w	$2(a0,d2.w),d1
	add.w	d0,Xvel(a3)		;add to X Vel
	add.w	d1,Yvel(a3)		;add to Y Vel
	bset	#pfalock,pflags(a3)		;lock in this animation
	move.w	#$C5E,d1
	bra.w	SetSPA
Holdplayer						;abut press hold. a0 = the player this one is
									;assigned to, falls into Acheck
	bset	#pfalock,pflags(a3)		;lock animation
	move.w	#$1122,d1		;move anim into d1 - normal hold check
	tst.w	impact(a3)		;check if impact = 0
	beq.w	SetSPA		;set anim if 0
	movea.l	#SortCords,a0
	move.w	impactp(a3),d0		;move last impact player into d0
	asl.w	#$7,d0		;calc offset
	adda.w	d0,a0		;add offset to a0
Acheck						;start SPAhook, or SPAHold if a0 is ahead
	bset	#pfalock,pflags(a3)		;lock animation
	move.w	#$1122,d1		;move anim into d1 - normal hold check
	tst.w	impact(a3)		;check if impact = 0
	beq.w	.ex		;branch if 0
	move.w	Ypos(a3),d0		;move Ypos checker into d0
	sub.w	Ypos(a0),d0		;sub Ypos of player
	btst	#pfgoal,pflags(a3)		;check goal checker is shooting at
	beq.w	.air		;jump if bottom
	neg.w	d0		;make d0 negative
.air	bmi.w	.ex
	move.w	#$C90,d1		;set anim - hold check stick in air
.ex	bra.w	SetSPA
setpassmode						;initialize pass mode
	move.w	facedir(a3),(passdir).l
	andi.w	#$7,(passdir).l
	btst	#$2,(BA_PS_flags).l
	beq.w	.0
	bclr	#$2,(gmode2).l
	bset	#$5,(BA_PS_flags).l
	bne.w	rtss7
	bclr	#$5,(gmode2).l
	move.w	#$64,(passmodetimer).l
.0	bset	#sfspdir,(sflags).l
; Return of setpassmode
rtss	rts
passmode						;dpad sets passdir until bbut changes
	btst	#$4,d2		;has b button changed?
	bne.w	dopass		;yes
	btst	#$3,(sflags5).l		;Not in NHL Hockey Source
	bne.w	dopass
	btst	#$3,d0		;look for dpad
	bne.w	rtss
	andi.w	#$7,d0		;pass first 3 bits of d0
	move.w	d0,(passdir).l
	bset	#$3,d0
dopass						;pass the puck in passdir, to the best teammate there if any
	movem.l	d0-d5/a0-a1,-(sp)
	bclr	#sfspdir,(sflags).l		;#sfspdir
	st.b	(puckc).l		;player is not puck handler anymore
	move.b	#$10,nopuck(a3)
	move.w	SCnum(a3),(lastplayer).l
	bclr	#$3,(sflags5).l		;Not in NHL Hockey Source
	beq.w	.noot
	jsr	(OneTimerTarget).l
	move.w	#$12,(onetimerheight).l
	btst	#$2,(sflags6).l
	beq.w	.1
	move.w	#$3A,(onetimerheight).l
.1	jsr	(OneTimerPass).l
	bra.w	.exit
.noot	moveq	#$8,d0		;moves 8 into d0
	tst.w	position(a3)		;checks if goalie
	beq.w	.calc		;jump if goalie
	move.b	passacc(a3),d0		;Passacc
.calc	asl.w	#$2,d0		;d0 = passacc for player, 8 for goalie
	asr.w	#$1,d0		;change from NHL Hockey Source,
	addi.w	#$A0,d0
	move.w	d0,(passspeed).l
	btst	#$0,passacc(a3)		;Checks to see if bit 0 in Passacc is 0
	beq.w	.findplayer		;Jumps if 0 (even number)
	asr.w	#$4,d0		;divide d0 by 16
	add.w	d0,(passspeed).l
.findplayer	moveq	#-1,d4
	moveq	#$5,d3
	movea.l	#SortCords,a1
	cmpi.w	#$6,SCnum(a3)		;compares 6 to SCnum(a3) (current player with puck) to check if
	blt.w	.0		;Jump if player is Home, continue if Away
	adda.w	#$300,a1		;Switch to Away Team Players
	btst	#$2,(BA_PS_flags).l
	bne.w	.nopp
.0	cmpa.l	a1,a3		;Check to see if passing to self
	beq.w	.next		;skip if this is passing player
	tst.w	position(a1)		;position(a1)
	beq.w	.next		;skip if goalie
	btst	#pf2unav,pflags2(a1)		;check if player is unavailable
	bne.w	.next		;player unavailable
	move.w	$0(a1),d0		;X Position of receiving player
	sub.w	(puckx).l,d0
	move.w	Ypos(a1),d1
	sub.w	(pucky).l,d1
	movem.w	d0-d1,-(sp)		;push to stack
	bsr.w	vtoa		;get direction of pass in d0
	movem.w	(sp)+,d1-d2		;pop from stack d1 is dX, d2 is dY
	sub.w	(passdir).l,d0
	andi.w	#$7,d0		;pass only lower 3 bits in d0
	asl.b	#$5,d0		;Multiply d0 by 32 (224 decimal is max)
	ext.w	d0		;sign extend d0 byte to d0 word
	asl.w	#$3,d0		;mult d0 by 8 (700 decimal max)
	muls.w	d0,d0		;square d0 = max is 490000 decimal
	cmpi.l	#$10000,d0		;compare to 65536 decimal (#256^2: power, SNASM ^ is xor)
	bhi.w	.next		;if higher branch to next
	muls.w	d1,d1		;square d1 (dX)
	muls.w	d2,d2		;square d2 (dY)
	add.l	d1,d2		;add together
	add.l	d0,d2		;add modified passdir to d2
	cmp.l	d4,d2		;compare d4 to d2
	bhi.w	.next		;branch if higher (player is farther away than the closest player)
	move.l	d2,d4		;move d2 into d4
	movea.l	a1,a0		;move a1 address into a0 (receiving player)
.next	adda.w	#$80,a1		;Skip to next player (80 hex is length of player struct)
	dbra	d3,.0
	tst.l	d4		;check if there's a player to pass to
	bmi.w	.nopp		;skip if no player to pass to
	bsr.w	passto
	bra.w	.exit
.nopp	move.w	(passdir).l,d0
	asl.w	#$2,d0
	movea.l	#dirtab,a0
	move.w	$2(a0,d0.w),d1		;y inc
	muls.w	(passspeed).l,d1
	move.l	#$A,d2
	asl.l	d2,d1
	divs.w	#$BB8,d1
	add.w	Yvel(a3),d1		;Yvel
	move.w	d1,(puckvy).l
	move.w	(a0,d0.w),d1
	muls.w	(passspeed).l,d1
	asl.l	d2,d1
	divs.w	#$BB8,d1
	add.w	Xvel(a3),d1		;Xvel
	move.w	d1,(puckvx).l
	move.w	#$1000,d0
	bsr.w	randomd0
	move.w	d0,(puckvz).l
.exit	tst.w	position(a3)
	bne.w	.notgoalie
	tst.w	(puckvy).l
	btst	#pfgoal,pflags(a3)		;$62 = pflags Checks for what goal team is shooting at (0=bottom, 1=top)
	beq.w	.g0
	bmi.w	.nvy
	bra.w	.notgoalie
.g0	bmi.w	.notgoalie
.nvy	neg.w	(puckvy).l
.notgoalie	move.w	(puckvx).l,d0
	move.w	(puckvy).l,d1
	bsr.w	vtoa
	move.w	#$366,d1		;SPA = Sprite Animation
	tst.w	position(a3)		;$34 = position
	beq.w	.e1		;goalie anim.
	move.w	#$718,d1
	bsr.w	Findhittype
	beq.w	.e1
	move.w	#$78A,d1
.e1	bsr.w	SetSPA		;start the pass animation d1
	bset	#pfalock,pflags(a3)		;#pfalock, $62 = pflags
	moveq	#$C,d0		;Rest to rts, not in NHL Hockey Source
	sub.b	(puckvz).l,d0
	lsr.w	#$2,d0
	andi.w	#$3,d0
	move.w	#$10,d0
	move.w	d0,-(sp)		;#SFXpass
	bsr.w	sfx
	movem.l	(sp)+,d0-d5/a0-a1
	rts

passto						;pass the puck to player a0: a3 = passer
	btst	#pfjoycon,pflags(a3)
	beq.w	passtoa0
	tst.w	position(a3)
	bne.w	passtoa0
	movem.l	d0-d1,-(sp)
	btst	#$3,pflags(a0)
	bne.w	.stack
	bset	#$6,pflags3(a0)		;pflags3 bit 6
	move.w	(cont1team).l,d1
	cmp.w	(cont2team).l,d1
	bne.w	.h2hor1p
	move.w	SCnum(a0),d0		;SCnum of receiver into d0
	move.w	SCnum(a3),d1		;SCnum of passer into d1
	cmp.w	(c1playernum).l,d1
	bne.w	.p2passing
	jsr	(setc1player).l
	bra.w	.stack
.p2passing	jsr	(setc2player).l
	bra.w	.stack
.h2hor1p	move.w	#$1,d1
	btst	#pfteam,pflags(a3)		;check if home or away team
	beq.w	.0		;branch if home
	move.w	#$2,d1		;away team
.0	move.w	SCnum(a0),d0		;move SCnum of receiver into d0
	cmp.w	(cont1team).l,d1
	bne.w	.diffteam
	jsr	(setc1player).l
	bra.w	.stack
.diffteam	jsr	(setc2player).l
.stack	movem.l	(sp)+,d0-d1
passtoa0	jsr	(loadTeamStruct).l
	addi.w	#$1,$12(a2)
	move.w	SCnum(a0),(passReceiverPlayerNum).l
	move.w	(passspeed).l,d5
	asr.w	#$2,d5
	exg.l	a0,a3
	moveq	#$13,d0
	bsr.w	assinsert
	exg.l	a0,a3
	move.l	a0,-(sp)
	bsr.w	GetHot
	add.w	$0(a0),d0
	sub.w	(puckx).l,d0
	add.w	Ypos(a0),d1
	sub.w	(pucky).l,d1
	movem.w	d0-d1,-(sp)
	movem.w	(sp),d2-d3
	asr.w	#$2,d2
	asr.w	#$2,d3
	move.w	Xvel(a0),d0
	muls.w	#$F0,d0
	swap	d0
	move.w	Yvel(a0),d1
	muls.w	#$F0,d1
	swap	d1
	movem.w	d0-d1,-(sp)
	muls.w	d2,d0
	muls.w	d3,d1
	add.w	d1,d0
	asl.w	#$1,d0
	move.w	d0,d4
	movem.w	(sp),d0-d1
	muls.w	d0,d0
	muls.w	d1,d1
	muls.w	d5,d5
	neg.l	d5
	add.l	d0,d5
	add.l	d1,d5
	muls.w	d2,d2
	muls.w	d3,d3
	add.l	d2,d3
	muls.w	d5,d3
	asl.l	#$2,d3
	move.w	d4,d0
	muls.w	d0,d0
	sub.l	d3,d0
	bsr.w	Sroot
	moveq	#$1,d3
	asr.w	#$2,d5
	bne.w	.loop
	moveq	#$1,d5
.loop	move.w	d0,d2
	neg.w	d0
	sub.w	d4,d2
	ext.l	d2
	divs.w	d5,d2
	dbpl	d3,.loop
	bne.w	.next2
	addi.w	#$1,d2
.next2	cmpi.w	#$18,d2
	bls.w	.next3
	moveq	#$18,d2
.next3	move.b	d2,(puckvz).l
	cmpi.w	#$C,d2
	blt.w	.next4
	move.b	#$C,(puckvz).l
.next4	move.w	d2,d0
	asl.w	#$3,d0
	subi.w	#$A,d0
	move.b	d0,temp1(a0)
	subi.w	#$6,d0
	move.b	d0,(puckx_nopuck).l
	movem.w	(sp)+,d0-d1
	muls.w	d2,d0
	asr.l	#$1,d0
	add.w	(sp)+,d0
	move.w	(puckx).l,temp3(a0)
	add.w	d0,temp3(a0)
	muls.w	d2,d1
	asr.l	#$1,d1
	add.w	(sp)+,d1
	move.w	(pucky).l,temp4(a0)
	add.w	d1,temp4(a0)
	mulu.w	#$78,d2
	swap	d0
	divs.w	d2,d0
	move.w	d0,(puckvx).l
	swap	d1
	divs.w	d2,d1
	move.w	d1,(puckvy).l
	rts
; Jumps to the pass routine at $2B4E2.
PassToJump
	jmp	(chgplayer).l
Sweepcheck						;start sweep check on player a3
	bset	#pfalock,pflags(a3)
	move.w	#$B24,d1
	bra.w	SetSPA
setc1player
	cmp.w	(c1playernum).l,d0
	beq.w	.ex
	movem.l	d1/a0-a1,-(sp)
	move.w	(c1playernum).l,d1
	bsr.w	restorepl
	move.w	d0,(c1playernum).l
	movem.l	(sp)+,d1/a0-a1
.ex	rts
setc2player
	cmp.w	(c2playernum).l,d0
	beq.w	.ex
	movem.l	d1/a0-a1,-(sp)
	move.w	(c2playernum).l,d1
	bsr.w	restorepl
	move.w	d0,(c2playernum).l
	movem.l	(sp)+,d1/a0-a1
.ex	rts
restorepl						;restore old joy controlled player d1, give d0 the joystick; a d1 in line
									;change mode keeps control
	movea.l	#SortCords,a0
	tst.w	d1
	blt.w	.spd
	cmpi.w	#$B,d1
	bgt.w	.spd
	asl.w	#scsize,d1		;multiply d0 by 80 hex (SCsize)
	btst	#pf2lcm,pflags2(a0,d1.w)		;#pfnp - no joystick pad
	beq.w	.cont
	lsr.w	#$7,d1		;divide by 80 hex
	move.w	d1,d0
	rts
.cont	bclr	#pfjoycon,pflags(a0,d1.w)		;#pfjoycon
	btst	#$3,pflags3(a0,d1.w)		;bit 3, pflags3
	bne.w	.spd
	bset	#pfna,pflags(a0,d1.w)		;#pfna - new assignment
.spd	tst.w	d0		;checks if d0 0 or higher
	blt.w	.ex
	cmpi.w	#$B,d0		;checks if d0 11 or less
	bgt.w	.ex
	move.w	d0,d1		;copies d0 into d1
	asl.w	#$7,d1
	btst	#$2,(BA_PS_flags).l
	bne.w	.chkgoalie
	btst	#$0,(gmode2).l
	beq.w	.3
.chkgoalie	tst.w	position(a0,d1.w)
	bne.w	.3
	btst	#$6,pflags(a0,d1.w)		;check if home or away
	beq.w	.0
	tst.w	(goaliemode2).l
	bra.w	.1
.0	tst.w	(goaliemode1).l
.1	beq.w	.3
	move.w	#$0,d0		;first position of home SCNum
	btst	#$6,pflags(a0,d1.w)		;check if home or away
	beq.w	.2
	move.w	#$6,d0		;first position of away SCNum
.2	bra.w	.ex
.3	bset	#pfjoycon,pflags(a0,d1.w)		;set pfjoycon for SCNum
.ex	rts
Findhittype						;look for type of swing (forhand or backhand)
									;input d0 = launch dir
									;ouput beq forhand
	neg.w	d0
	add.w	facedir(a3),d0		;facedir
	andi.w	#$7,d0
	btst	#$3,attribute(a3)		;attribute bit 3
	beq.w	.next
	btst	d0,#$F0		;%11110000: beq forehand, bne backhand
	rts
.next	btst	d0,#$1E		;%00011110
	rts
SetShotMode
	btst	#$2,(BA_PS_flags).l
	beq.w	.start
	bclr	#$2,(gmode2).l
	bset	#$5,(BA_PS_flags).l
	bne.w	rtss7
	bclr	#$5,(gmode2).l
	move.w	#$64,(passmodetimer).l
.start	move.w	#$8,(passdir).l
	bset	#sfssdir,(sflags).l
	clr.w	d0
	move.w	#$128,d1
	btst	#pfgoal,pflags(a3)
	bne.w	.ck0
	neg.w	d1
.ck0	sub.w	$0(a3),d0
	sub.w	Ypos(a3),d1
	bsr.w	vtoa
	move.w	#$F,(passspeed).l
	move.w	#$7FC,d1
	bsr.w	Findhittype
	beq.w	.ck1
	move.w	#$92E,d1
	move.w	#$F,(passspeed).l
.ck1	bra.w	SetSPA
ShotMode						;shot input
									;swing frame reached (anim frame 7*4): shoot, else dpad sets shot
									;direction
	cmpi.w	#$1C,SPAnum(a3)
	bge.w	prepshot		;end of animation so shoot
	btst	#$3,d0		;checks dpad for direction
	bne.w	.ss0
	andi.w	#$7,d0		;pass the first 3 bits of d0
	move.w	d0,(passdir).l
.ss0	cmpi.w	#$10,SPAnum(a3)
	bge.w	doshotExit
	add.w	d7,(passspeed).l
	cmpi.b	#$14,shotspd(a3)		;6C = shot speed
	bge.w	.checkcbut
	cmpi.w	#$8,SPAnum(a3)		;SPANum
	bgt.w	.chganim
.checkcbut	btst	#cbut,d2		;5 = #cbut
	beq.w	doshotExit		;button hasnt changed so continue windup
.chganim	neg.w	SPAnum(a3)		;end windup and swing through
	addi.w	#$1C,SPAnum(a3)		;Add to SPANum
	rts
prepshot						;check the conditions before a shot: d0 = SCnum of the opposing goalie
									;(getGoalieSCnum)
	bclr	#$4,(sflags5).l
	move.w	#$B,d0
	btst	#pfteam,pflags(a3)		;check if home or away
	beq.w	.getGoalie		;gets opponents Goalie SCnum
	move.w	#$5,d0		;opponent is home
.getGoalie	jsr	(getGoalieSCnum).l
	tst.w	d0
	bmi.w	.nogoalie
	movem.l	a0,-(sp)
	asl.w	#$7,d0
	movea.l	#SortCords,a0
	cmpi.w	#$250,SPA(a0,d0.w)		;Checking goalie animations - pad stack right
	beq.w	.svgoalie
	cmpi.w	#$2A2,SPA(a0,d0.w)		;Checking another goalie animation - pad stack left
.svgoalie	movem.l	(sp)+,a0		;pop stack value into a0
	bne.w	.cont
.nogoalie	cmpi.w	#$1,(passdir).l
	ble.w	.dir017
	cmpi.w	#$7,(passdir).l
	bne.w	.cont
.dir017	move.w	(pucky).l,d0
	btst	#pfgoal,pflags(a3)		;#pfgoal - goal to shoot at (0=bottom, 1=top)
	bne.w	.cmppuck		;branch if top
	neg.w	d0		;flips d0 for compare calc
.cmppuck	cmpi.w	#$D8,d0		;compares location of puck
	blt.w	.cont
	bset	#$4,(sflags5).l		;set flag for in-close top shelf shooting
.cont	bra.w	doshot
doshot						;stick is at puck so launch puck toward goal
	movem.l	d0-d7/a0-a3,-(sp)
	bclr	#$4,(gmode2).l
	btst	#pf3break,pflags3(a3)		;check if player on breakaway
	beq.w	.cont
	bset	#$4,(gmode2).l		;set if breakaway
.cont	bsr.w	shotdiradj
	move.w	#$5,-(sp)		;#SFXshotwiff - sound effect
	move.w	SCnum(a3),(shotplayer).l
	bclr	#sfssdir,(sflags).l		;#sfssdir - shot direction mode
	bset	#pfalock,pflags(a3)		;#pfalock
	btst	#pf3onetimer,pflags3(a3)		;check if shooting one timer
	bne.w	.shottype		;jump if yes
	move.w	(puckc).l,d0		;puck carrier SCnum into d0
	cmp.w	SCnum(a3),d0		;is player puck carrier?
	bne.w	.ex		;wiffed shot
.shottype	move.w	#$18,(sp)		;#SFXshotfh
	bset	#sf2shot,(sflags2).l		;#sf2shot - shot was taken
	cmpi.w	#$92E,SPA(a3)
	bne.w	.nbh		;no backhand
	move.w	#$14,(sp)		;#SFXshotbh
	move.w	(passspeed).l,d0
	lsr.w	#$2,d0
	sub.w	d0,(passspeed).l
.nbh	btst	#pf3onetimer,pflags3(a3)		;check if shooting one timer
	beq.w	.cont2		;jump if not
	movem.l	d0-d1,-(sp)		;push d0-d1 on stack
	move.w	#$1F,d0		;1F into d0 - one timer min speed
	move.w	d0,(passspeed).l
	movem.l	(sp)+,d0-d1		;Pop off stack d0-d1
.cont2	clr.w	d0
	move.b	shotspd(a3),d0		;6C = shotspd (ShP)
	lsr.b	#$1,d0		;divide by 2
	movea.l	a3,a0		;move a3 address into a0
	jsr	(makepde).l
	addi.w	#$14,d0
	mulu.w	(passspeed).l,d0
	mulu.w	#$5249,d0
	swap	d0
	move.w	d0,(passspeed).l
	btst	#$0,shotspd(a3)		;checks if ShP value is even or odd
	beq.w	.even
	asr.w	#$4,d0		;divide by 16
	add.w	(passspeed).l,d0
.even	lsr.w	#$4,d0		;divide by 16 (d0 is passspeed)
	neg.w	d0		;negative
	addi.w	#$3,d0		;add 3 to d0
	bpl.w	.nbh2
	clr.w	d0		;clear if negative
.nbh2	add.w	d0,(sp)		;add to stack current value (Shot SFX)
	st.b	(puckc).l		;clear puck carrier
	move.b	#$10,nopuck(a3)		;5E = nopuck - no puck collision till 0
	move.w	SCnum(a3),(lastplayer).l
	move.w	#$108,d1		;$108 = top goal line Y position
	btst	#pfgoal,pflags(a3)		;pfgoal, pflags
	bne.w	.0		;branch if shooting up
	neg.w	d1		;flip d1 if shooting down
.0	move.w	(passdir).l,d2
	asl.w	#$2,d2
	lea.l	shotsets(pc),a0
	move.w	(a0,d2.w),d0
	move.w	$2(a0,d2.w),d2
	sub.w	(puckx).l,d0
	sub.w	(pucky).l,d1
	movem.w	d0-d2,-(sp)		;push d0-d2(dx,dy,z offset) on stack
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	bsr.w	Sroot
	tst.w	d0		;distance in pix to goal
	bne.w	.1
	addi.w	#$1,d0
.1	move.w	d0,d3		;straight line distance from puck to spot aiming for with passdir
	btst	#gmhl,(gmode).l		;check if highlight (always perfect)
	bne.w	.perf
	cmpi.w	#$C8,d3		;C8 = 200 decimal
	bhi.w	.notperf		;too far away from perfect shot
	jsr	(ReadGoaliePulled).l		;checks if shooting team's G pulled
	bmi.w	.perf		;perfect shot with pulled goalie
	btst	#$0,(gmode2).l		;check if shootout
	bne.w	.perf		;perfect shot in shootout
	moveq	#$10,d0		;start value for ShA calc
	add.b	shotacc(a3),d0		;shotacc(a3)
	bsr.w	randomd0
	cmpi.w	#$E,d0		;chance of perfect shot
	bgt.w	.perf		;branch if higher - perfect shot
.notperf	clr.w	d0
	move.b	shotacc(a3),d0		;shotacc(a3)
	lsr.w	#$1,d0		;divide by 2
	move.b	d0,-(sp)		;push on stack
	move.w	(passspeed).l,d0
	lsr.w	#$4,d0		;divide by 16
	sub.b	(sp)+,d0		;shotacc(a3) / 2
	addi.b	#$10,d0		;add $10 to d0
	mulu.w	d3,d0		;mult straight line distance with d0
	lsr.w	#$6,d0		;shot accuracy adjust - divide by 64
	cmpi.w	#$FA,d3		;250 pixels straight line distance
	bhi.w	.chkvalue		;branch if higher
	lsr.w	#$1,d0		;extra shot accuracy adjust
.chkvalue	cmpi.w	#$88,d0		;compare to $88 (max adj value in X)
	blt.w	.cont3
	move.w	#$88,d0
.cont3	move.w	d0,-(sp)		;push adjusting value: 2(sp) / 4(sp) = x / y diff pushed before
	bsr.w	randomd0s		;RNG adj value
	add.w	d0,$2(sp)		;add result to x diff
	move.w	(sp),d0		;move adjusting value into d0
	cmpi.w	#$3C,d0		;compare to $3C (max adjustment in Y)
	bls.w	.lessx		;branch if less
	moveq	#$3C,d0
	move.w	d0,(sp)
.lessx	tst.w	$4(sp)
	bpl.w	.ycalc
	lsr.w	#$1,d0
.ycalc	bsr.w	randomd0s		;RNG adjustment
	add.w	d0,$4(sp)		;add to y diff
	move.w	(sp)+,d0		;pop adj value
	lsr.w	#$1,d0		;divide by 2
	bsr.w	randomd0		;RNG result
	add.w	d0,$4(sp)		;add to Z diff
.perf	move.w	(passspeed).l,d2
	muls.w	#$44,d2		;1024/15
	muls.w	(sp)+,d2		;mult by x dist
	divs.w	d3,d2		;divide d2 by straight line distance
	move.w	d2,(puckvx).l
	move.w	(passspeed).l,d2
	muls.w	#$44,d2		;1024/15
	muls.w	(sp)+,d2		;mult by y dist
	divs.w	d3,d2		;divide d2 by straight line distance
	move.w	d2,(puckvy).l
	move.w	#$8000,d1		;this is the highest negative puckvy possible
	btst	#pfgoal,pflags(a3)		;check direction of shooting net
	beq.w	.2		;branch if bottom goal
	clr.w	d1
.2	eor.w	d2,d1		;EOR - checking to see if exceeding maximum puckvy
	bpl.w	.3		;branch if positive
	move.w	#$3810,(puckvy).l
	btst	#pfgoal,pflags(a3)
	bne.w	.3
	move.w	#$C7F0,(puckvy).l
.3	move.w	(sp)+,d1
	beq.w	.ex
	mulu.w	(passspeed).l,d1
	mulu.w	#$44,d1		;1024/15
	divu.w	d3,d1		;by d3 = distance in pix to goal
	mulu.w	#$B33,d3		;(1024*42)/15
	divu.w	(passspeed).l,d3
	add.w	d1,d3
	cmpi.w	#$1800,d3
	bls.w	.noup		;branch if less than
	move.w	#$1800,d3		;set max puckvz
.noup	move.w	d3,(puckvz).l
	bclr	#$4,(sflags5).l		;check in-close top shelf bit
	beq.w	.ex		;if bit was cleared, exit
	btst	#pf3onetimer,pflags3(a3)		;check if one timer
	bne.w	.ex		;branch if so
	jsr	(puckvzadj).l		;adjust puckvz for top shelf shot
.ex	bsr.w	sfx		;play the shot sound
	movem.l	(sp)+,d0-d7/a0-a3
; Return of doshot
doshotExit	rts
shotsets						;If the opposing goalie
									;covers the middle of the net, set passdir 2 or 6 to shoot at the open
									;side, else 0. Skipped for computer players (pfjoycon clear)
	ori.b	#$C,d0
	ori.b	#$C,(a0)
	ori.b	#$6,(a0)
	ori.b	#$0,(a0)
	ori.b	#$0,d0
; Instruction bytes inside shotsets that the assembler would encode differently, kept as words (4 rows).
	dc.w	$FFF0
	dc.l	$FFF0
	dc.w	$0006,$FFF0
	dc.w	$000C,$0000,$0006
; Checks the direction bits before adjusting a shot.
shotdiradj
	btst	#$3,pflags3(a3)
	bne.w	.next
	btst	#$3,pflags(a3)
	bne.w	.ex
.next	moveq	#$8,d0
	moveq	#$5,d1
	movea.l	#GoalieStruct,a0
	btst	#$6,pflags(a3)
	bne.w	.loop
	adda.w	#$300,a0
.loop	adda.w	#$80,a0
	tst.w	position(a0)
	dbeq	d1,.loop
	bne.w	.next4
	move.b	Xvel(a0),d0
	ext.w	d0
	asr.w	#$1,d0
	add.w	$0(a0),d0
	sub.w	(puckx).l,d0
	move.b	Yvel(a0),d1
	ext.w	d1
	asr.w	#$1,d1
	add.w	Ypos(a0),d1
	sub.w	(pucky).l,d1
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	addq.l	#$1,d0
	bsr.w	Sroot
	move.w	d0,d2
	movem.w	(sp)+,d0-d1
	moveq	#$12,d3
	move.w	#$108,d4
	btst	#$7,pflags(a3)
	bne.w	.next2
	neg.w	d4
.next2	movem.w	d3-d4,-(sp)
	bsr.w	CalcAngleOffset
	move.w	d4,d5
	movem.w	(sp)+,d3-d4
	neg.w	d3
	bsr.w	CalcAngleOffset
	add.w	d5,d4
	clr.w	d0
	cmpi.w	#$2C,d4
	bgt.w	.next4
	cmpi.w	#$FFD4,d4
	blt.w	.next4
	btst	#$7,pflags(a3)
	beq.w	.next3
	neg.w	d4
.next3	moveq	#$2,d0
	tst.w	d4
	bpl.w	.next4
	moveq	#$6,d0
.next4	move.w	d0,(passdir).l
	btst	#$2,(BA_PS_flags).l
	bne.w	.next5
	btst	#$0,(gmode2).l
	beq.w	.ex
.next5	jsr	(PSandSOpassdir).l
.ex	rts
CalcAngleOffset	sub.w	(puckx).l,d3
	sub.w	(pucky).l,d4
	muls.w	d0,d4
	muls.w	d1,d3
	sub.l	d3,d4
	divs.w	d2,d4
	rts
setpads						;Put SCnum of a3 in the d4 nibble of PadControlBits ; d4 = -2 puck
									;carrier, 0 / 2 pads, 4 replay target. Falls into rtss3
	movem.l	d0-d1,-(sp)
	moveq	#$2,d0
	add.w	d4,d0
	add.w	d0,d0
	move.w	#$FFF0,d1
	rol.w	d0,d1
	and.w	d1,(PadControlBits).l
	move.w	SCnum(a3),d1
	asl.w	d0,d1
	or.w	d1,(PadControlBits).l
	movem.l	(sp)+,d0-d1
; Return of setpads
rtss3	rts
check4bench
	btst	#$2,(BA_PS_flags).l
	bne.w	rtss3
	btst	#pfjoycon,pflags(a3)
	bne.w	rtss3
	btst	#pf2pen,pflags2(a3)
	bne.w	rtss3
	tst.b	newpos(a3)
	bpl.w	.0
	tst.b	newpnum(a3)
	bmi.w	rtss3
.0	move.b	newpnum(a3),d0
	cmp.b	pnum(a3),d0
	beq.w	.next2
	move.w	assnum(a3),d0
	cmpi.b	#$B,asslist(a3,d0.w)
	beq.w	rtss3
	move.w	SCnum(a3),d0
	cmp.w	(puckc).l,d0
	beq.w	rtss3
	adda.w	#$4,sp
	bset	#pf2unav,pflags2(a3)
	clr.w	temp1(a3)
	moveq	#$B,d0
	bra.w	assreplace
.next2	adda.w	#$4,sp
	bclr	#pf2unav,pflags2(a3)
	bclr	#pfnc,pflags(a3)
	st.b	newpnum(a3)
	st.b	newpos(a3)
	move.w	position(a3),d0
	tst.b	newpos(a3)
	bpl.w	.1
	jmp	(Setplass).l
.1	move.b	newpos(a3),d0
	ext.w	d0
	move.w	d0,position(a3)
	jmp	(Setplass).l
; Bench check: flag 5 means skip, a $64 counter means go to the bench
assbench	btst.b	#$5,pflags(a3)
	bne.w	rtss3
	cmpi.w	#$64,temp1(a3)
	beq.w	BenchGoToBench
	bsr.w	check4bench
	btst.b	#$4,pflags2(a3)
	bne.w	assexit
	bclr.b	#$1,pflags(a3)
	beq.w	.next2
	move.w	#$8,temp2(a3)
	moveq	#$50,d0
	btst.b	#$6,pflags(a3)
	bne.w	.next
	neg.w	d0
.next	move.w	d0,temp4(a3)
	move.w	#$88,temp3(a3)
	neg.w	temp3(a3)
	subi.w	#$8,$44(a3)
	clr.w	temp1(a3)
.next2	move.b	newpnum(a3),d0
	cmp.b	pnum(a3),d0
	beq.w	BenchSamePlayer
	sub.w	d7,temp1(a3)
	bpl.w	BenchWalkTarget
	addi.w	#$8,$40(a3)
	move.w	Ypos(a3),d0
	sub.w	temp4(a3),d0
	cmpi.w	#$28,d0
	bgt.w	BenchWalkTarget
	cmpi.w	#$FFD8,d0
	blt.w	BenchWalkTarget
	move.w	$0(a3),d0
	sub.w	temp3(a3),d0
	cmpi.w	#$20,d0
	bgt.w	BenchWalkTarget
	move.w	#$50C,d1
	tst.w	position(a3)
	bne.w	.next3
	move.w	#$2,d1
.next3	bsr.w	SetSPA
	bset.b	#$2,pflags(a3)
	cmpi.w	#$4,facedir(a3)
	beq.w	.next4
	addi.w	#$1,$54(a3)
	andi.w	#$7,facedir(a3)
.next4	clr.w	Yvel(a3)
	move.w	#$F800,Xvel(a3)
	cmpi.w	#$10,d0
	bgt.w	check4benchExit
	clr.w	Xvel(a3)
	cmpi.w	#$4,facedir(a3)
	bne.w	check4benchExit
	move.w	#$F800,Xvel(a3)
	move.w	#$2,facedir(a3)
	move.w	#$FAC,d1
	bsr.w	SetSPA
	bset.b	#$5,pflags(a3)
	move.w	#$64,temp1(a3)
check4benchExit
	rts
; Sends the player to the bench: clears the speed and looks up the team struct
BenchGoToBench	clr.w	frame(a3)
	clr.w	d0
	move.b	pnum(a3),d0
	add.w	d0,d0
	movea.l	#tmstruct,a0
	btst.b	#$6,pflags(a3)
	beq.w	.next
	adda.w	#$366,a0
.next	move.w	#$FFFE,tmpdst(a0,d0.w)
	move.b	newpnum(a3),d3
	bsr.w	BenchSetAnimation
	jmp	(setplayer).l
; Walks the player towards the bench door
BenchWalkTarget	btst.b	#$2,pflags(a3)
	bne.w	check4benchExit
	move.w	temp3(a3),d0
	move.w	temp4(a3),d1
	movea.l	#EvadePC,a0
	bra.w	skateto
BenchSamePlayer						;same player: just take the new position, no bench trip (cartridge assbench .nobench)
	bclr	#pf2unav,pflags2(a3)
BenchSetAnimation						;position = newpos; clear newpos and newpnum (cartridge .nobench2)
	move.b	newpos(a3),d0
	ext.w	d0
	move.w	d0,position(a3)
	jsr	(Setplass).l
	st.b	newpnum(a3)
	st.b	newpos(a3)
rtss4
	rts
asseben
	btst.b	#$5,pflags(a3)
	bne.w	check4benchExit
	bclr.b	#$1,pflags(a3)
	beq.w	.next2
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	move.w	SCnum(a3),d0
	subi.w	#$6,d0
	bmi.w	.next
	addi.w	#$1,d0
.next	muls.w	#$E,d0
	move.w	d0,Ypos(a3)
	move.w	#$88,$0(a3)
	neg.w	$0(a3)
	move.w	#$2,facedir(a3)
	bset.b	#$5,pflags(a3)
	move.w	#$F6E,d1
	bra.w	SetSPA
.next2	move.w	#$4,facedir(a3)
	bclr.b	#$2,pflags(a3)
	bclr.b	#$5,pflags2(a3)
	bclr.b	#$2,pflags2(a3)
	clr.w	SPA(a3)
	move.w	#$1000,Xvel(a3)
	bra.w	assexit
asspenalty
	btst.b	#$5,pflags(a3)
	bne.w	check4benchExit
	bclr.b	#$1,pflags(a3)
	beq.w	.next5
	bset.b	#$2,pflags2(a3)
	bsr.w	BenchControlledCheck
	moveq	#-2,d4
	bsr.w	setpads
	move.w	#$8,temp2(a3)
	moveq	#$B,d0
	move.b	(PBnum).l,d1
	btst.b	#$6,pflags(a3)
	bne.w	.next3
	lsr.w	#$4,d1
	neg.w	d0
.next3	andi.w	#$F,d1
	cmpi.w	#$2,d1
	bls.w	.next4
	moveq	#$2,d1
.next4	addq.w	#$3,d1
	muls.w	d0,d1
	move.w	d1,temp4(a3)
	move.w	#$88,temp3(a3)
	clr.w	temp1(a3)
	bset.b	#$5,pflags2(a3)
	clr.w	Wallcos(a3)
	clr.w	Wallsin(a3)
.next5	move.w	Ypos(a3),d0
	sub.w	temp4(a3),d0
	cmpi.w	#$C,d0
	bgt.w	.next8
	cmpi.w	#$FFF4,d0
	blt.w	.next8
	move.w	$0(a3),d0
	sub.w	temp3(a3),d0
	cmpi.w	#$FFE8,d0
	blt.w	.next8
	sub.w	d7,temp1(a3)
	bpl.w	check4benchExit
	addi.w	#$8,$40(a3)
	bset.b	#$2,pflags(a3)
	move.w	#$50C,d1
	bsr.w	SetSPA
	moveq	#$6,d2
	tst.b	handed(a3)
	beq.w	.next6
	moveq	#$2,d2
.next6	cmp.w	facedir(a3),d2
	beq.w	.next7
	addi.w	#$1,$54(a3)
	andi.w	#$7,facedir(a3)
.next7	clr.w	Yvel(a3)
	move.w	#$1000,Xvel(a3)
	cmpi.w	#$FFF8,d0
	blt.w	check4benchExit
	clr.w	Xvel(a3)
	cmp.w	facedir(a3),d2
	bne.w	check4benchExit
	bset.b	#$5,pflags(a3)
	move.w	#$2,facedir(a3)
	move.w	#$F6E,d1
	bsr.w	SetSPA
	bclr.b	#$4,pflags2(a3)
	moveq	#$D,d0
	bra.w	assreplace
.next8	move.w	temp3(a3),d0
	move.w	temp4(a3),d1
	movea.l	#check4benchExit,a0
	bra.w	skateto
; Bench: checks the controlled player
BenchControlledCheck	btst.b	#$3,pflags(a3)
	beq.w	check4benchExit
	clr.w	d4
	move.w	SCnum(a3),d0
	cmp.w	(c1playernum).l,d0
	beq.w	PassToJump
	moveq	#$2,d4
	bra.w	PassToJump
assdopen						;add player a3 to penalty box
	btst	#pfalock,pflags(a3)
	bne.w	check4benchExit
	moveq	#$10,d0
	btst	#pfteam,pflags(a3)
	beq.w	.1
	moveq	#$1,d0
.1	add.b	d0,(PBnum).l
	st.b	position(a3)
	clr.w	frame(a3)
	rts
assepen						;player a3 should exit penalty area
	btst	#pfalock,pflags(a3)
	bne.w	check4benchExit
	bclr	#pfna,pflags(a3)
	beq.w	.nna
	bset	#pfnc,pflags(a3)		;set player in no collision mode
	bset	#pf2unav,pflags2(a3)		;set player unavailable
	moveq	#$10,d0
	moveq	#-60,d1
	btst	#pfteam,pflags(a3)
	beq.w	.0
	moveq	#$1,d0
	neg.w	d1
.0	sub.b	d0,(PBnum).l
	move.w	d1,Ypos(a3)
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	move.w	#$86,$0(a3)
	move.w	#$2,facedir(a3)
	bset	#pfalock,pflags(a3)
	move.w	#$FAC,d1
	bsr.w	SetSPA
	jmp	(SprSort).l
.nna	move.w	#$4,facedir(a3)
	st.b	newpnum(a3)
	st.b	newpos(a3)
	bclr	#pfjoycon,pflags(a3)
	bclr	#pfnc,pflags(a3)
	bclr	#pf2npc,pflags2(a3)		;pf2npc
	bclr	#pf2unav,pflags2(a3)		;pf2unav
	move.w	#$F000,Xvel(a3)
	bra.w	assexit
assgoaliebreakwait						;asstab entry. In a shootout or penalty shot park the idle goalie off the
									;ice, else exit
	btst	#pfalock,pflags(a3)		;check if animation locked
	bne.w	.exit		;exit if so
	btst	#$2,(BA_PS_flags).l		;check if pen shot
	bne.w	.park		;branch if so
	btst	#$0,(gmode2).l		;check for shootout
	bne.w	.park		;branch if so
	nop
	bra.w	assexit
.park	clr.w	Xvel(a3)		;clear Xvel
	clr.w	Yvel(a3)		;clear Yvel
	movem.l	d0/a0,-(sp)		;push d0 and a0 on stack
	movea.l	#SortCords,a0
	move.w	(BA_Goalie_SCnum).l,d0
	asl.w	#$7,d0		;shift d0 7 bits left
	adda.w	d0,a0		;add d0 to address a0
	move.w	#$191,Ypos(a3)		;move 401 decimal into Ypos
	btst	#$7,pflags(a0)		;check if shooting up or down (a0 is goalie being shot on)
	bne.w	.popstack		;branch if shooting up
	move.w	#$FE6F,Ypos(a3)		;move -191 decimal into Ypos (goalie not being shot on)
.popstack	movem.l	(sp)+,d0/a0
.exit	rts
assfaceoff						;players do nothing until faceoff is over
	btst	#pfalock,pflags(a3)
	bne.w	assfaceoffExit
	btst	#sf2faceoff,(sflags2).l
	beq.w	assexit
; Return of assfaceoff
assfaceoffExit	rts
assfaceoffpl						;Face off player
	btst	#pfalock,pflags(a3)
	bne.w	assfaceoffExit
	btst	#sf2faceoff,(sflags2).l
	beq.w	.exit
	bclr	#pfna,pflags(a3)
	beq.w	.nna
	clr.w	temp1(a3)
.nna	movea.l	#fofdata2,a0
	btst	#pfteam,pflags(a3)
	beq.w	.0
	adda.w	#$4,a0
.0	move.w	SPAnum(a3),d0		;d0 = SPAnum/4 + 1, +3 for right handed: frame code for the big sprite
	lsr.w	#$2,d0
	addi.w	#$1,d0
	tst.b	handed(a3)
	bne.w	.lefty
	addi.w	#$3,d0
.lefty	move.w	d0,(a0)
	btst	#pfjoycon,pflags(a3)
	bne.w	check4benchExit
	bset	#$1,pflags2(a3)
	bne.w	check4benchExit
	move.w	#$FEA,d1
	cmpi.w	#$10,(SortCords+(puckscnum*SCstruct)+temp1).l
	bls.w	.d
	moveq	#$8,d0
	bsr.w	randomd0
	tst.w	d0
	beq.w	.d
	move.w	#$1014,d1
.d	bset	#$1,pflags2(a3)
	bra.w	SetSPA
.exit	move.b	#$14,nopuck(a3)
	bra.w	assexit
assfight							;rts only: there is no fighting
	rts
assfwatch							;rts only: there is no fighting
	rts

donothing
	btst	#pfalock,pflags(a3)
	bne.w	check4benchExit
	btst	#pfjoycon,pflags(a3)
	bne.w	check4benchExit
	moveq	#$8,d0
	bra.w	doplayeracc
; AI target setup: flags 5 and 1 of $62
assstanley	btst.b	#$5,pflags(a3)
	bne.w	check4benchExit
	bclr.b	#$1,pflags(a3)
	beq.w	.next2
	move.w	#$5A,temp3(a3)
	tst.w	(Hpos).l
	bpl.w	.next
	neg.w	temp3(a3)
.next	move.w	(Vpos).l,temp4(a3)
	move.w	#$109E,d1
	bsr.w	SetSPA
.next2	move.w	temp3(a3),d0
	sub.w	$0(a3),d0
	move.w	temp4(a3),d1
	sub.w	Ypos(a3),d1
	bsr.w	vtoa
	cmpi.w	#$7,d0
	bgt.w	check4benchExit
	move.w	d0,d2
	move.w	d2,facedir(a3)
	bra.w	playeracc
assscore
	btst.b	#$5,pflags(a3)
	bne.w	check4benchExit
	bclr.b	#$1,pflags(a3)
	beq.w	.next4
	bsr.w	AssistRandomTimer
	move.w	#$8,temp2(a3)
	move.w	#$5A,temp3(a3)
	tst.w	(Hpos).l
	bpl.w	.next3
	neg.w	temp3(a3)
.next3	move.w	(Vpos).l,temp4(a3)
.next4	movea.l	#check4benchExit,a0
	move.w	temp3(a3),d0
	move.w	temp4(a3),d1
	btst.b	#$0,(gmode2).l
	beq.w	.next7
	tst.w	(shootoutdelay).l
	beq.w	.next5
	subi.w	#$1,(shootoutdelay).l
	bne.w	.next5
	bset.b	#$2,(sflags2).l
.next5	cmpi.w	#$88,$0(a3)
	bgt.w	.next6
	cmpi.w	#$FF78,$0(a3)
	bgt.w	.next7
.next6	clr.w	d1
.next7	sub.w	d7,temp1(a3)
	bpl.w	AssistSkateOrExit
	bset.b	#$5,pflags(a3)
	move.w	#$E8A,d1
	move.w	(shotplayer).l,d0
	cmp.w	SCnum(a3),d0
	bne.w	.next8
	move.w	#$EFC,d1
.next8	bsr.w	SetSPA
; Sets a random timer (0 to $78) in $40
AssistRandomTimer	moveq	#$78,d0
	bsr.w	randomd0
	move.w	d0,temp1(a3)
	rts
; Skates to the target or returns
AssistSkateOrExit	btst.b	#$3,pflags(a3)
	beq.w	skateto
rtss6
	rts
assdefo
	btst.b	#$5,pflags(a3)
	bne.w	check4benchExit
	btst.b	#$0,(gmode).l
	bne.w	donothing
	bsr.w	check4bench
	btst.b	#$3,pflags(a3)
	bne.w	check4benchExit
	bclr.b	#$1,pflags(a3)
	beq.w	.next
	clr.w	temp1(a3)
	move.w	#$8,temp2(a3)
.next	sub.b	d7,temp1(a3)
	bpl.w	.next5
	move.b	aioff(a3),temp1(a3)
	jsr	(ReadGoaliePulled).l
	bmi.w	.next2
	btst.b	#$6,(sflags7).l
	beq.w	.next3
	tst.b	temp1(a3)
	beq.w	.next3
.next2	subi.b	#$1,$40(a3)
.next3	moveq	#$2,d0
	btst.b	#$4,tmflags(a2)
	bne.w	assreplace
	move.w	(pucky).l,d1
	btst.b	#$7,pflags(a3)
	bne.w	.next4
	neg.w	d1
.next4	cmpi.w	#$5D,d1
	blt.w	assreplace
	move.w	(puckc).l,d1
	bmi.w	.next5
	subi.w	#$6,d1
	move.w	SCnum(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	bmi.w	assreplace
.next5	lea	EvadePC(pc),a0
	moveq	#$50,d0
	cmpi.w	#$2,position(a3)
	beq.w	.next6
	neg.w	d0
.next6	move.w	#$62,d1
	btst.b	#$7,pflags(a3)
	bne.w	.next7
	neg.w	d0
	neg.w	d1
.next7	move.w	(puckx).l,d2
	eor.w	d0,d2
	bmi.w	.next8
	move.w	(puckx).l,d0
	bra.w	skateto
.next8	move.w	(puckx).l,d2
	asr.w	#$1,d2
	add.w	d2,d0
	bra.w	skateto
assdefd
	btst.b	#$5,pflags(a3)
	bne.w	check4benchExit
	btst.b	#$0,(gmode).l
	bne.w	donothing
	bsr.w	check4bench
	btst.b	#$3,pflags(a3)
	bne.w	check4benchExit
	bclr.b	#$1,pflags(a3)
	beq.w	.next9
	clr.w	temp1(a3)
	move.w	#$8,temp2(a3)
.next9	sub.b	d7,temp1(a3)
	bpl.w	.next22
	move.b	aidef(a3),temp1(a3)
	btst.b	#$6,(sflags7).l
	beq.w	.next10
	tst.b	temp1(a3)
	beq.w	.next10
	subi.b	#$1,$40(a3)
.next10	move.w	(pucky).l,d1
	move.w	(puckvy).l,d3
	asr.w	#$6,d3
	btst.b	#$7,pflags(a3)
	bne.w	.next11
	neg.w	d1
	neg.w	d3
.next11	tst.w	d3
	bpl.w	.next12
	clr.w	d3
.next12	add.w	d1,d3
	cmpi.w	#$58,d3
	blt.w	.next13
	btst.b	#$4,tmflags(a2)
	bne.w	.next13
	move.w	(puckc).l,d1
	bmi.w	.next13
	bsr.w	chkpk
	beq.w	.next13
	moveq	#$1,d0
	subi.w	#$6,d1
	move.w	SCnum(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	bpl.w	assreplace
.next13	move.w	#$41,temp3(a3)
	cmpi.w	#$2,position(a3)
	beq.w	.next14
	neg.w	temp3(a3)
.next14	movea.l	#SortCords,a0
	cmpi.w	#$6,SCnum(a3)
	bge.w	.next15
	adda.w	#$300,a0
.next15	moveq	#$5,d2
	move.w	#$FC18,d0
	btst.b	#$7,pflags(a3)
	beq.w	.loop2
	neg.w	d0
.loop	btst.b	#$2,pflags2(a0)
	bne.w	.next17
	tst.w	position(a0)
	bmi.w	.next17
	move.w	Yvel(a0),d1
	bmi.w	.next16
	clr.w	d1
.next16	asr.w	#$4,d1
	add.w	Ypos(a0),d1
	cmp.w	d0,d1
	bgt.w	.next17
	move.w	d1,d0
.next17	adda.w	#$80,a0
	dbra	d2,.loop
	subi.w	#$32,d0
	cmpi.w	#$FF42,d0
	bgt.w	.next18
	move.w	#$FF24,d0
.next18	move.w	d0,temp4(a3)
	move.w	(puckx).l,d0
	move.w	temp3(a3),d1
	eor.w	d0,d1
	bpl.w	.next22
	clr.w	temp3(a3)
	bra.w	.next22
.loop2	btst.b	#$2,pflags2(a0)
	bne.w	.next20
	tst.w	position(a0)
	bmi.w	.next20
	move.w	Yvel(a0),d1
	bpl.w	.next19
	clr.w	d1
.next19	asr.w	#$4,d1
	add.w	Ypos(a0),d1
	cmp.w	d0,d1
	blt.w	.next20
	move.w	d1,d0
.next20	adda.w	#$80,a0
	dbra	d2,.loop2
	addi.w	#$32,d0
	cmpi.w	#$BE,d0
	blt.w	.next21
	move.w	#$DC,d0
.next21	move.w	d0,temp4(a3)
	neg.w	temp3(a3)
	move.w	(puckx).l,d0
	move.w	temp3(a3),d1
	eor.w	d0,d1
	bpl.w	.next22
	clr.w	temp3(a3)
.next22	move.w	temp3(a3),d0
	move.w	temp4(a3),d1
	movea.l	#EvadePC,a0
	bsr.w	skateto
	bra.w	check4check
rtss21	rts
asswingd							;player a3 is wing on defense
	btst.b	#$5,pflags(a3)
	bne.w	rtss21
	btst.b	#$0,(gmode).l
	bne.w	donothing
	bsr.w	check4bench
	btst.b	#$3,pflags(a3)
	bne.w	rtss21
	bclr.b	#$1,pflags(a3)
	beq.w	.next23
	clr.w	temp1(a3)
	move.w	#$8,temp2(a3)
.next23	sub.b	d7,temp1(a3)
	bpl.w	.next25
	move.b	aidef(a3),temp1(a3)
	btst.b	#$6,(sflags7).l
	beq.w	.next24
	tst.b	temp1(a3)
	beq.w	.next24
	subi.b	#$1,$40(a3)
.next24	move.w	(puckc).l,d1
	bmi.w	.next25
	moveq	#$4,d0
	subi.w	#$6,d1
	move.w	SCnum(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	bpl.w	assreplace
.next25	moveq	#$64,d0
	cmpi.w	#$5,position(a3)
	bne.w	.next26
	neg.w	d0
.next26	move.l	#$9E,d1
	btst.b	#$7,pflags(a3)
	beq.w	.next28
	neg.w	d0
	neg.w	d1
	moveq	#-78,d2
	btst.b	#$4,tmflags(a2)
	bne.w	.next30
	cmp.w	(pucky).l,d2
	bgt.w	.next27
	move.w	(pucky).l,d1
	bra.w	.next31
.next27	move.w	#$FEF8,d2
	cmp.w	(pucky).l,d2
	blt.w	.next31
	move.w	d2,d1
	bra.w	.next31
.next28	moveq	#$4E,d2
	btst.b	#$4,tmflags(a2)
	bne.w	.next30
	cmp.w	(pucky).l,d2
	blt.w	.next29
	move.w	(pucky).l,d1
	bra.w	.next31
.next29	move.w	#$108,d2
	cmp.w	(pucky).l,d2
	bgt.w	.next31
.next30	move.w	d2,d1
.next31	lea.l	(rtss21).l,a0		;the cartridge uses lea rtss21(pc),a0
	move.w	(puckx).l,d2
	eor.w	d0,d2
	bmi.w	skateto
	move.w	(puckx).l,d0
	bra.w	skateto
asswingo							;player a3 is wing on offense
	btst.b	#$5,pflags(a3)
	bne.w	rtss21
	btst.b	#$0,(gmode).l
	bne.w	donothing
	bsr.w	check4bench
	btst.b	#$3,pflags(a3)
	bne.w	rtss21
	bclr.b	#$1,pflags(a3)
	beq.w	.next32
	st.b	temp5(a3)
	clr.w	temp1(a3)
	move.w	#$8,temp2(a3)
.next32	sub.b	d7,temp1(a3)
	bpl.w	AssistTargetFlip
	move.b	aidef(a3),temp1(a3)
	btst.b	#$6,(sflags7).l
	beq.w	.next33
	tst.b	temp1(a3)
	beq.w	.next33
	subi.b	#$1,$40(a3)
.next33	moveq	#$3,d0
	move.w	(puckc).l,d1
	bmi.w	.next34
	subi.w	#$6,d1
	move.w	SCnum(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	bmi.w	assreplace
.next34	move.w	(pucky).l,d0
	move.w	(puckvy).l,d3
	asr.w	#$6,d3
	add.w	d0,d3
	btst.b	#$7,pflags(a3)
	bne.w	.next35
	neg.w	d0
	neg.w	d3
.next35	clr.w	d2
	cmpi.w	#$FFA8,d3
	blt.w	.next36
	addi.w	#$8,d2
	cmpi.w	#$58,d0
	blt.w	.next36
	btst.b	#$4,tmflags(a2)
	bne.w	.next36
	addi.w	#$8,d2
	cmpi.w	#$108,d3
	blt.w	.next36
	addi.w	#$8,d2
.next36	cmp.w	temp5(a3),d2
	bne.w	.next37
.loop4	btst.b	#$7,(GA_COMFLAGS).l
	bne.s	.loop4
	move.w	#$1B,(GA_COMSTAT0).l
	bset.b	#$6,(GA_COMFLAGS+1).l
.loop5	btst.b	#$6,(GA_COMFLAGS).l
	beq.s	.loop5
	move.w	(GA_COMCMD0).l,d0
	bset.b	#$7,(GA_COMFLAGS+1).l
	bclr.b	#$6,(GA_COMFLAGS+1).l
.loop6	btst.b	#$6,(GA_COMFLAGS).l
	bne.s	.loop6
	bclr.b	#$7,(GA_COMFLAGS+1).l
	andi.w	#$7F,d0
	bne.w	AssistTargetFlip
.next37	move.w	d2,temp5(a3)
	lea.l	AssistLimitsTable(pc),a0
	move.w	$2(a0,d2.w),d0
	bsr.w	randomd0s
	add.w	(a0,d2.w),d0
	move.w	d0,temp3(a3)
	move.w	$6(a0,d2.w),d0
	bsr.w	randomd0s
	add.w	$4(a0,d2.w),d0
	move.w	d0,temp4(a3)
	bra.w	AssistTargetFlip
; Word table of position limits
AssistLimitsTable	dc.b	$00,$50,$00,$14,$FF,$BA,$00,$0A,$00,$64,$00,$14,$00,$3A,$00,$05	; .P.......d...:..
	dc.b	$00,$3C,$00,$32,$00,$E6,$00,$14,$00,$50,$00,$1E,$00,$FA,$00,$14	; .<.2.....P......
; Mirrors the target x for the side
AssistTargetFlip	move.w	temp3(a3),d0
	cmpi.w	#$5,position(a3)
	beq.w	.next
	neg.w	d0
.next	move.w	temp4(a3),d1
	btst.b	#$7,pflags(a3)
	bne.w	.next2
	neg.w	d0
	neg.w	d1
.next2	lea.l	EvadePC(pc),a0
	bra.w	skateto
rtss11								;shared rts for the early exits nearby
	rts
asscenterd							;player a3 is center on defense
	btst.b	#$5,pflags(a3)
	bne.w	rtss11
	btst.b	#$0,(gmode).l
	bne.w	donothing
	bsr.w	check4bench
	btst.b	#$3,pflags(a3)
	bne.w	rtss11
	bclr.b	#$1,pflags(a3)
	beq.w	.next3
	clr.w	temp1(a3)
	move.w	#$8,temp2(a3)
.next3	sub.b	d7,temp1(a3)
	bpl.w	.next5
	move.b	aidef(a3),temp1(a3)
	btst.b	#$6,(sflags7).l
	beq.w	.next4
	tst.b	temp1(a3)
	beq.w	.next4
	subi.b	#$1,$40(a3)
.next4	move.w	(puckc).l,d1
	bmi.w	.next5
	moveq	#$6,d0
	subi.w	#$6,d1
	move.w	SCnum(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	bpl.w	assreplace
.next5	move.w	(puckx).l,d0
	asr.w	#$1,d0
	move.w	(pucky).l,d2
	btst.b	#$7,pflags(a3)
	bne.w	.next6
	neg.w	d2
.next6	moveq	#-128,d1
	cmpi.w	#$FFA8,d2
	blt.w	.next7
	add.w	(pucky).l,d1
	asr.w	#$1,d1
.next7	btst.b	#$7,pflags(a3)
	bne.w	.next8
	neg.w	d1
.next8	lea.l	(rtss11).l,a0		;the cartridge uses lea rtss11(pc),a0
	bra.w	skateto
asscentero							;player a3 is center on offense
	btst.b	#$5,pflags(a3)
	bne.w	rtss11
	btst.b	#$0,(gmode).l
	bne.w	donothing
	bsr.w	check4bench
	btst.b	#$3,pflags(a3)
	bne.w	rtss11
	bclr.b	#$1,pflags(a3)
	beq.w	.next9
	st.b	temp5(a3)
	clr.w	temp1(a3)
	move.w	#$8,temp2(a3)
.next9	sub.b	d7,temp1(a3)
	bpl.w	AssistTargetFlipGoalie
	move.b	aidef(a3),temp1(a3)
	btst.b	#$6,(sflags7).l
	beq.w	.next10
	tst.b	temp1(a3)
	beq.w	.next10
	subi.b	#$1,$40(a3)
.next10	move.w	(puckc).l,d1
	bmi.w	.next11
	moveq	#$5,d0
	subi.w	#$6,d1
	move.w	SCnum(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	bmi.w	assreplace
.next11	move.w	(pucky).l,d0
	btst.b	#$7,pflags(a3)
	bne.w	.next12
	neg.w	d0
.next12	clr.w	d2
	cmpi.w	#$FFA8,d0
	blt.w	.next13
	addi.w	#$8,d2
	cmpi.w	#$58,d0
	blt.w	.next13
	btst.b	#$4,tmflags(a2)
	bne.w	.next13
	addi.w	#$8,d2
	cmpi.w	#$108,d0
	blt.w	.next13
	addi.w	#$8,d2
.next13	cmp.w	temp5(a3),d2
	bne.w	.next14
.loop2	btst.b	#$7,(GA_COMFLAGS).l
	bne.s	.loop2
	move.w	#$1B,(GA_COMSTAT0).l
	bset.b	#$6,(GA_COMFLAGS+1).l
.loop3	btst.b	#$6,(GA_COMFLAGS).l
	beq.s	.loop3
	move.w	(GA_COMCMD0).l,d0
	bset.b	#$7,(GA_COMFLAGS+1).l
	bclr.b	#$6,(GA_COMFLAGS+1).l
.loop4	btst.b	#$6,(GA_COMFLAGS).l
	bne.s	.loop4
	bclr.b	#$7,(GA_COMFLAGS+1).l
	andi.w	#$7F,d0
	bne.w	AssistTargetFlipGoalie
.next14	move.w	d2,temp5(a3)
	lea.l	AssistLimitsTableGoalie(pc),a0
	move.w	$2(a0,d2.w),d0
	bsr.w	randomd0s
	add.w	(a0,d2.w),d0
	move.w	d0,temp3(a3)
	move.w	$6(a0,d2.w),d0
	bsr.w	randomd0s
	add.w	$4(a0,d2.w),d0
	move.w	d0,temp4(a3)
	bra.w	AssistTargetFlipGoalie
; Word table of position limits for the goalie
AssistLimitsTableGoalie	dc.b	$00,$00,$00,$3C,$FF,$BA,$00,$0A,$00,$00,$00,$3C,$00,$3C,$00,$0A	; ...<.......<.<..
	dc.b	$00,$00,$00,$28,$00,$AA,$00,$1E,$00,$00,$00,$50,$00,$AA,$00,$14	; ...(.......P....
; Mirrors the target for the goalie
AssistTargetFlipGoalie	move.w	temp3(a3),d0
	move.w	temp4(a3),d1
	btst.b	#$7,pflags(a3)
	bne.w	.next
	neg.w	d1
.next	lea.l	EvadePC(pc),a0
	bra.w	skateto
assgoaliectrl						;joypad controlled goalie control: a3 = goalie; a goalie not on the
									;joystick leaves through assexit
	btst	#pfjoycon,pflags(a3)		;is player joystick controlled?
	bne.w	.goaliectrl		;branch is so
	bra.w	assexit
.goaliectrl	btst	#pfna,pflags(a3)		;check if new assignment
	bne.w	.na		;branch if new assignment
	movem.w	d0-d1,-(sp)		;push to stack
	move.w	$0(a3),d0		;Xpos
	move.w	Ypos(a3),d1		;Ypos
	cmpi.w	#$AA,d1		;compare $AA to Ypos
	bgt.w	.cont
	cmpi.w	#$FF56,d1		;check -$AA to Ypos
	blt.w	.cont		;branch if less than
	btst	#gmclock,(gmode).l		;check if clock stopped
	bne.w	.cont		;branch if so
	move.w	d0,-(sp)		;push to stack
	move.w	#$8,d0		;clock stoppage due to goalie out of range
	jsr	(AddPenalty2).l
	move.w	(sp)+,d0
.cont	sub.w	(Hpos).l,d0
	sub.w	(Vpos).l,d1
	bclr	#pf3gctrl,pflags3(a3)		;clear goalie control bit?
	cmpi.w	#$74,d0		;compare $74 to Xpos diff
	blt.w	.0		;branch if less than
	bset	#pf3gctrl,pflags3(a3)		;set goalie control bit?
	bra.w	.cont2
.0	cmpi.w	#$FF8C,d0		;compare -$74 to Xpos diff
	bgt.w	.1		;branch if greater than
	bset	#pf3gctrl,pflags3(a3)		;set goalie control bit?
	bra.w	.cont2
.1	cmpi.w	#$64,d1		;compare $64 to Ypos diff
	blt.w	.2		;branch if less than
	bset	#pf3gctrl,pflags3(a3)		;set goalie control bit?
	bra.w	.cont2
.2	cmpi.w	#$FF9C,d1		;compare -$64 to Ypos diff
	bgt.w	.cont2		;branch if greater than
	bset	#pf3gctrl,pflags3(a3)		;set goalie control bit?
.cont2	movem.w	(sp)+,d0-d1		;pop from stack
	btst	#pf3gctrl,pflags3(a3)		;check goalie ctrl bit
	bne.w	checkanim		;branch if set
.na	btst	#pfalock,pflags(a3)		;check if anim lock
	bne.w	check4benchExit		;exit if so
	bsr.w	check4bench
	bclr	#pfna,pflags(a3)		;clear new assignment bit
	beq.w	.nna		;branch if already cleared
	clr.w	temp1(a3)		;clear temp1
	move.w	#$8,temp2(a3)		;move 8 into temp2
	st.b	temp4(a3)		;FFFF to temp4
.nna	btst	#$1,pflags2(a3)		;check if anim in progress
	bne.w	.ex		;exit if so
	btst	#gmclock,(gmode).l		;check if clock stopped
	bne.w	check4benchExit		;exit if so
	tst.w	temp5(a3)		;test temp5
	bmi.w	.nofo		;branch if less than 0
	move.w	SCnum(a3),d0		;move SCnum into d0
	cmp.w	(puckc).l,d0		;check if puckc is goalie
	beq.w	.mbfo		;branch if equal
	st.b	temp5(a3)		;set temp5 to -1
	bra.w	.nofo
.mbfo	sub.w	d7,temp5(a3)		;subtract d7(frames elapsed) from temp5
	bpl.w	.nofo		;branch if more than 0
	btst	#$2,(BA_PS_flags).l		;check bit 2
	beq.w	.next2		;branch if not set
	bset	#$4,(BA_PS_flags).l
	bra.w	.nofo
.next2	moveq	#$8,d0
	bsr.w	AddPenalty2
.nofo	sub.b	d7,temp1(a3)		;sub d7(frames elapsed) from temp1
	bpl.w	.ex		;branch if positive
	move.b	aidef(a3),d0		;DfA into d0
	beq.w	.3		;branch if value was 0
	btst	#$6,(sflags7).l		;check if crowd meter broken
	beq.w	.3		;jump if not
	subi.b	#$1,d0		;sub 1 from d0
.3	lsr.b	#$2,d0		;divide by 4
	move.b	d0,temp1(a3)		;move d0 into temp1
	move.w	SCnum(a3),d0		;move SCnum into d0
	cmp.w	(puckc).l,d0		;compare puckc to d0
	beq.w	.ex		;jump to assgoaliecpu if the same
.ex	rts
assgoalie
	btst	#$3,$62(a3)
	bne.w	assgoaliectrl

; checkanim: stores the frame counter and tests the flags
checkanim
	move.w	(puckx).l,(TmpPuckX).l
	btst	#$0,(sflags4).l
	beq.w	.next3
	btst	#$1,pflags2(a3)
	bne.w	.next3
	btst	#$1,(sflags4).l
	beq.w	.next
	btst	#$3,(sflags4).l
	bne.w	.next3
	cmpi.w	#$2C4,frame(a3)
	bne.w	.next3
	cmpi.w	#$2C8,frame(a3)
	bne.w	.next3
	bset	#$3,(sflags4).l
	move.w	#$1C,-(sp)
	bsr.w	sfx
	bra.w	.next3
.next	movem.w	d0-d1,-(sp)
	move.w	(pucky).l,d0
	move.w	Ypos(a3),d1
	eor.w	d1,d0
	movem.w	(sp)+,d0-d1
	bmi.w	.next3
	cmpi.w	#$14,$0(a3)
	bgt.w	.next3
	cmpi.w	#$FFEC,$0(a3)
	ble.w	.next3
	bset	#$1,(sflags4).l
	bclr	#$3,(sflags4).l
	move.w	#$1596,d1
	btst	#$7,pflags(a3)
	beq.w	.next2
	move.w	#$1684,d1
.next2	bsr.w	SetSPA
	bset	#$1,pflags2(a3)
.next3	btst	#$5,pflags(a3)
	bne.w	ClampYPositionExit
	bsr.w	check4bench
	bclr	#$1,pflags(a3)
	beq.w	.next4
	clr.w	temp1(a3)
	move.w	#$8,temp2(a3)
	st.b	temp4(a3)
.next4	cmpi.w	#$34,$0(a3)
	bgt.w	.next5
	cmpi.w	#$FFCC,$0(a3)
	blt.w	.next5
	cmpi.w	#$10E,Ypos(a3)
	bgt.w	.next5
	cmpi.w	#$FEF2,Ypos(a3)
	blt.w	.next5
	cmpi.w	#$D2,Ypos(a3)
	bgt.w	.next7
	cmpi.w	#$FF2E,Ypos(a3)
	blt.w	.next7
.next5	lea.l	ClampYPositionExit(pc),a0
	moveq	#$4,d0
	tst.w	$0(a3)
	bpl.w	.next6
	neg.w	d0
.next6	move.w	#$E4,d1
	btst	#$7,pflags(a3)
	beq.w	skateto
	neg.w	d1
	bra.w	skateto
.next7	btst	#$1,pflags2(a3)
	bne.w	ClampYPositionExit
	btst	#$0,(sflags4).l
	beq.w	.next9
	cmpi.w	#$2C5,frame(a3)
	beq.w	.next8
	cmpi.w	#$2C9,frame(a3)
	bne.w	.next9
	move.w	#$4,facedir(a3)
	bra.w	.next9
.next8	move.w	#$0,facedir(a3)
.next9	move.w	#$2,d1
	bsr.w	SetSPA
	btst	#$2,(BA_PS_flags).l
	bne.w	.next10
	btst	#$0,(gmode).l
	bne.w	ClampYPositionExit
.next10	tst.w	temp5(a3)
	bmi.w	.next13
	move.w	SCnum(a3),d0
	cmp.w	(puckc).l,d0
	beq.w	.next11
	st.b	temp5(a3)
	bra.w	.next13
.next11	sub.w	d7,temp5(a3)
	bpl.w	.next13
	btst	#$2,(BA_PS_flags).l
	beq.w	.next12
	bset	#$4,(BA_PS_flags).l
	bra.w	.next13
.next12	moveq	#$8,d0
	bsr.w	AddPenalty2
.next13	sub.b	d7,temp1(a3)
	bpl.w	.next39
	move.b	aidef(a3),d0
	beq.w	.next14
	btst	#$6,(sflags7).l
	beq.w	.next14
	subi.b	#$1,d0
.next14	lsr.b	#$2,d0
	move.b	d0,temp1(a3)
	btst	#$3,pflags(a3)
	beq.w	.next15
	btst	#$2,pflags3(a3)
	bne.w	.next15
	moveq	#$1D,d0
	bra.w	assinsert
.next15	move.w	(pucky).l,d0
	move.w	Ypos(a3),d1
	eor.w	d0,d1
	bpl.w	.next16
	clr.w	d0
	move.w	#$F4,d2
	btst	#$7,pflags(a3)
	beq.w	.loop5
	neg.w	d2
	bra.w	.loop5
.next16	subi.w	#$1,$46(a3)
	bpl.w	.next17
	move.w	#$FFFF,temp4(a3)
.next17	move.w	SCnum(a3),d0
	cmp.w	(puckc).l,d0
	bne.w	.next20
	tst.w	temp5(a3)
	bpl.w	.next18
	move.w	#$5A,temp5(a3)
.next18	st.b	temp4(a3)
	cmpi.w	#$5A,temp5(a3)
	bgt.w	.next23
.loop	btst	#$7,(GA_COMFLAGS).l
	bne.b	.loop
	move.w	#$1B,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.loop2	btst	#$6,(GA_COMFLAGS).l
	beq.b	.loop2
	move.w	(GA_COMCMD0).l,d0
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.loop3	btst	#$6,(GA_COMFLAGS).l
	bne.b	.loop3
	bclr	#$7,(GA_COMFLAGS+1).l
	andi.w	#$3,d0
	bne.w	.next23
	moveq	#$5,d0
	movea.l	#SortCords,a0
	btst	#$6,pflags(a3)
	bne.w	.loop4
	adda.w	#$300,a0
.loop4	btst	#$2,pflags2(a0)
	bne.w	.next19
	move.w	(pucky).l,d1
	sub.w	Ypos(a0),d1
	cmpi.w	#$1C,d1
	bgt.w	.next19
	cmpi.w	#$FFE4,d1
	blt.w	.next19
	move.w	(puckx).l,d1
	sub.w	$0(a0),d1
	cmpi.w	#$19,d1
	bgt.w	.next19
	cmpi.w	#$FFE7,d1
	bgt.w	.next23
.next19	adda.w	#$80,a0
	dbra	d0,.loop4
	move.w	#$1,(threat).l
	bsr.w	chk4pass
	bra.w	.next23
.next20	tst.w	temp4(a3)
	bne.w	.next23
	tst.w	(puckc).l
	bpl.w	.next23
	move.w	(puckx).l,d0
	sub.w	$0(a3),d0
	cmpi.w	#$14,d0
	bgt.w	.next23
	cmpi.w	#$FFEC,d0
	blt.w	.next23
	move.w	(pucky).l,d1
	cmpi.w	#$108,d1
	bgt.w	.next23
	cmpi.w	#$FEF8,d1
	blt.w	.next23
	sub.w	Ypos(a3),d1
	cmpi.w	#$1E,d1
	bgt.w	.next23
	cmpi.w	#$FFE2,d1
	blt.w	.next23
	movem.w	d0-d1,-(sp)
	move.w	(puckvx).l,d0
	bpl.w	.next21
	neg.w	d0
.next21	move.w	(puckvy).l,d1
	bpl.w	.next22
	neg.w	d1
.next22	add.w	d1,d0
	cmpi.w	#$1000,d0
	movem.w	(sp)+,d0-d1
	bgt.w	.next23
	bsr.w	vtoa
	move.w	d0,facedir(a3)
	move.b	#$8,nopuck(a3)
	move.w	#$2F4,d1
	bsr.w	SetSPA
	bset	#$1,pflags2(a3)
	addi.w	#$96,(Crowdlevel).l
	rts
.next23	movea.l	#puckcross,a0
	move.w	#$104,d3
	btst	#$7,pflags(a3)
	beq.w	.next24
	adda.w	#$4,a0
	neg.w	d3
.next24	cmpi.w	#$104,Ypos(a3)
	bgt.w	.next25
	cmpi.w	#$FEFC,Ypos(a3)
	bgt.w	.next26
.next25	clr.w	d2
	clr.w	d0
	cmpi.w	#$2C,$0(a3)
	bgt.w	.loop5
	cmpi.w	#$FFD4,$0(a3)
	blt.w	.loop5
	move.w	#$88,d0
	tst.w	$0(a3)
	bpl.w	.loop5
	neg.w	d0
	bra.w	.loop5
.next26	tst.w	(puckc).l
	bmi.w	.next27
	move.w	SCnum(a3),d0
	cmp.w	(puckc).l,d0
	beq.w	.next27
	move.l	a0,-(sp)
	movea.l	#SortCords,a0
	move.w	(puckc).l,d0
	asl.w	#$7,d0
	adda.w	d0,a0
	move.w	(puckx).l,d0
	sub.w	$0(a0),d0
	asr.w	#$1,d0
	add.w	$0(a0),d0
	move.w	d0,(TmpPuckX).l
	movea.l	(sp)+,a0
.next27	move.w	(TmpPuckX).l,d0
	move.w	(pucky).l,d1
	bsr.w	ClampYPosition
	bsr.w	vtoa
	bsr.w	AdjustFacingDirection
	move.w	(gameclock).l,d0
	andi.w	#$7,d0
	asl.w	#$4,d0
	addi.w	#$A0,d0
	cmpi.w	#$DB,(pucky).l
	bgt.w	.next28
	cmpi.w	#$FF25,(pucky).l
	bgt.w	.next29
.next28	subi.w	#$40,d0
.next29	move.w	d0,d1
	muls.w	(puckvx).l,d0
	swap	d0
	add.w	(TmpPuckX).l,d0
	muls.w	(puckvy).l,d1
	swap	d1
	add.w	(pucky).l,d1
	bsr.w	ClampYPosition
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmpi.l	#$384,d0
	bhi.w	.next30
	movem.w	(sp)+,d0-d1
	bra.w	.next32
.next30	bsr.w	Sroot
	moveq	#$1,d2
	add.w	d0,d2
	moveq	#$12,d4
	btst	#$3,(sflags).l
	beq.w	.next31
	addi.w	#$8,d4
.next31	movem.w	(sp)+,d0-d1
	muls.w	d4,d1
	addi.w	#$8,d4
	muls.w	d4,d0
	divs.w	d2,d0
	divs.w	d2,d1
.next32	add.w	d3,d1
	move.w	d1,d2
	btst	#$0,(gmode2).l
	bne.w	.next34
	btst	#$2,(BA_PS_flags).l
	bne.w	.next34
	btst	#$3,(sflags).l
	beq.w	.next34
	cmpi.w	#$D0,(pucky).l
	bgt.w	.next33
	cmpi.w	#$FF30,(pucky).l
	blt.w	.next33
	bra.w	.next34
.next33	cmpi.w	#$14,$0(a3)
	bgt.w	.next34
	cmpi.w	#$FFEC,$0(a3)
	blt.w	.next34
	btst	#$1,(gameclock+1).l
	bne.w	.next34
	bra.w	.next35
.next34	cmpi.w	#$22,$2(a0)
	bhi.w	.loop5
	cmpi.w	#$18,(a0)
	bgt.w	.next40
	cmpi.w	#$FFE8,(a0)
	blt.w	.next40
	cmpi.w	#$C,$2(a0)
	bhi.w	.next36
.next35	cmpi.w	#$108,(pucky).l
	bgt.w	.next36
	cmpi.w	#$FEF8,(pucky).l
	blt.w	.next36
	bset	#$1,pflags2(a3)
	bne.w	.next36
	jsr	(goaliesave).l
.next36	move.w	(a0),d0
	cmpi.w	#$FC,(pucky).l
	bgt.w	.next37
	cmpi.w	#$FF04,(pucky).l
	bgt.w	.loop5
.next37	moveq	#$18,d0
	tst.w	(TmpPuckX).l
	bpl.w	.loop5
	neg.w	d0
.loop5	move.w	d2,d1
	movem.w	d0-d1,-(sp)
	move.b	Xvel(a3),d0
	ext.w	d0
	neg.w	d0
	add.w	(sp)+,d0
	sub.w	$0(a3),d0
	move.b	Yvel(a3),d1
	ext.w	d1
	neg.w	d1
	add.w	(sp)+,d1
	sub.w	Ypos(a3),d1
	cmpi.w	#$4,d0
	bgt.w	.next38
	cmpi.w	#$FFFC,d0
	blt.w	.next38
	cmpi.w	#$4,d1
	bgt.w	.next38
	cmpi.w	#$FFFC,d1
	blt.w	.next38
	clr.w	d0
	clr.w	d1
.next38	bsr.w	vtoa
	move.b	d0,$43(a3)
.next39	move.b	$43(a3),d2
	ext.w	d2
	cmpi.w	#$7,d2
	ble.w	playeracc
	bra.w	stopna
.next40	tst.w	(puckc).l
	bpl.w	.loop5
	btst	#$2,(iflags).l
	bne.w	.loop5
	movea.l	#tmstruct,a1
	lea.l	tmsize(a1),a2
	btst	#$6,pflags(a3)
	beq.w	.next41
	exg.l	a1,a2
.next41	cmpi.l	#$1324,tmnear(a1)
	blt.w	.loop5
	cmpi.l	#$9C4,tmnear(a2)
	blt.w	.loop5
	cmpi.w	#$E0,(pucky).l
	bgt.w	.next42
	cmpi.w	#$FF20,(pucky).l
	bgt.w	.loop5
.next42	tst.w	(puckvy).l
	btst	#$7,pflags(a3)
	beq.w	.next43
	eori.b	#$8,ccr
.next43	bmi.w	.loop5
	move.w	(puckvx).l,d0
	bpl.w	.next44
	neg.w	d0
.next44	move.w	(puckvy).l,d1
	bpl.w	.next45
	neg.w	d1
.next45	cmp.w	d0,d1
	blt.w	.loop5
	moveq	#$F,d0
	bra.w	assinsert
ClampYPosition						;d1 = y clamped to +-$103, minus goal line d3. d0 = 0 if a3 has the puck
	move.w	(puckc).l,d2
	cmp.w	SCnum(a3),d2		;is this player the puck carrier?
	bne.w	.0
	clr.w	d0		;carrier: d0 = 0
.0	cmpi.w	#$103,d1		;clamp d1 to the range -$103..$103
	blt.w	.1
	move.w	#$103,d1		;upper limit
.1	cmpi.w	#$FEFD,d1
	bgt.w	.2
	move.w	#$FEFD,d1
.2	sub.w	d3,d1
; Return of ClampYPosition
ClampYPositionExit	rts
AdjustFacingDirection						;Turn facedir one step toward direction d0
	move.w	facedir(a3),d1		;facedir
	sub.w	d1,d0		;d0 = wanted - current
	beq.w	check4benchExit
	neg.w	d0
	andi.w	#$4,d0		;bit 2 of (current - wanted) picks the turn sense
	lsr.w	#$1,d0
	subi.w	#$1,d0		;d0 = +1/-1
	btst	#pfjoycon,pflags(a3)		;pfjoycon
	bne.w	.add
	btst	d1,#$42		;facing 1 or 6
	beq.w	.add		;no: plain single step
	add.w	d0,d1		;step once and test the new facing
	btst	#pfgoal,pflags(a3)
	bne.w	.dn
	btst	d1,#$83		;0, 1 or 7
	bra.w	.t
.dn	btst	d1,#$38		;3, 4 or 5
.t	beq.w	.set		;new facing not in the mask: keep the step
	neg.w	d0		;in the mask: undo it and turn the other way instead
	add.w	d0,d1
.add	add.w	d0,d1		;apply the step
.set	andi.w	#$7,d1		;wrap to 0-7
	move.w	d1,facedir(a3)		;facedir
	rts
; Computes the facing step from the position difference.
goaliesave
	move.w	(a0),d0
	sub.w	$0(a3),d0
	move.w	d3,d1
	sub.w	Ypos(a3),d1
	bsr.w	vtoa
	sub.w	facedir(a3),d0
	andi.w	#$7,d0
	move.w	d0,d3
	lsr.w	#$2,d0
	btst	#$3,attribute(a3)
	beq.w	.next
	eori.w	#$1,d0
.next	cmpi.w	#$8,(puckz).l
	bgt.w	.next2
	cmpi.w	#$800,(puckvz).l
	bgt.w	.next2
	bra.w	.next4
.next2	movem.l	d0,-(sp)
	move.w	$0(a3),d0
	sub.w	(a0),d0
	cmpi.w	#$10,d0
	bgt.w	.next3
	cmpi.w	#$FFF0,d0
	blt.w	.next3
	movem.l	(sp)+,d0
	addi.w	#$6,d0
	bra.w	.next13
.next3	movem.l	(sp)+,d0
	bra.w	.next13
.next4	addi.w	#$4,d0
	cmpi.w	#$8,$2(a0)
	bls.w	.next10
	cmpi.w	#$2,facedir(a3)
	beq.w	.next13
	cmpi.w	#$6,facedir(a3)
	beq.w	.next13
	tst.w	(puckc).l
	bmi.w	.next13
	subi.w	#$2,d0
	move.w	d1,-(sp)
	move.w	#$1000,d1
	move.w	d1,Xvel(a3)
	ori.w	#$1,d0
	btst	#$7,pflags(a3)
	bne.w	.next5
	eori.w	#$1,d0
.next5	move.w	#$FFFA,d1
	tst.w	Xvel(a3)
	bmi.w	.next6
	neg.w	Xvel(a3)
.next6	tst.w	$0(a3)
	bpl.w	.next8
	tst.w	Xvel(a3)
	bpl.w	.next7
	neg.w	Xvel(a3)
.next7	move.w	#$6,d1
	eori.w	#$1,d0
.next8	add.w	d1,$0(a3)
	btst	#$0,handed(a3)
	beq.w	.next9
	eori.w	#$1,d0
.next9	move.w	(sp)+,d1
	bra.w	.next13
.next10	movem.l	d0,-(sp)
	move.w	$0(a3),d0
	sub.w	(a0),d0
	cmpi.w	#$10,d0
	ble.w	.next11
	movem.l	(sp)+,d0
	bra.w	.next12
.next11	cmpi.w	#$FFF0,d0
	movem.l	(sp)+,d0
	bgt.w	.next13
.next12	addi.w	#$4,d0
.next13	add.w	d0,d0
	lea.l	.next15(pc),a1
	move.w	(a1,d0.w),d1
	cmpi.w	#$178,d1
	bne.w	.next14
	andi.w	#$3,d3
	beq.w	.next14
	cmpi.b	#$B,GGSleft(a3)
	blt.w	.next14
	move.w	#$1AA,d1
.next14	bsr.w	SetSPA
	addi.w	#$96,(Crowdlevel).l
	addi.w	#$A,(CwdExciteLvl).l
	asr.w	Xvel(a3)
	asr.w	Xvel(a3)
	asr.w	Yvel(a3)
	asr.w	Yvel(a3)
	rts
; Table of 10 words after AdjustFacingDirection, 20 bytes: $0146,$0178,$0250,$02A2,$01EC,$021E ...
.next15	dc.w	$0146,$0178,$0250,$02A2,$01EC,$021E,$148E,$14C0
	dc.w	$14F2,$1544
assgoalietopuck						;goalie skates out to a loose puck (inserted by
									;assgoalie)
	btst	#pfjoycon,pflags(a3)		;human controlled goalie: nothing to do
	bne.w	assexit
	btst	#gmclock,(gmode).l		;clock stopped: nothing to do
	bne.w	assexit
	bsr.w	check4bench
	bclr	#pfna,pflags(a3)		;new assignment? (clears the flag)
	beq.w	.0
	clr.w	temp1(a3)
.0	sub.b	d7,temp1(a3)		;count the timer down by d7 (elapsed frames)
	bpl.w	.go		;still running: keep skating to the puck
	move.b	aidef(a3),d0		;aidef
	beq.w	.1
	btst	#$6,(sflags7).l
	beq.w	.1
	subi.b	#$1,d0
.1	lsr.b	#$2,d0
	move.b	d0,temp1(a3)		;reload timer = defensive rating / 4
	tst.w	(puckc).l
	bpl.w	assexit		;someone has the puck: stay
	tst.w	(puckvy).l
	btst	#pfgoal,pflags(a3)
	beq.w	.dir
	eori.b	#$8,ccr		;flip N for the other goal end
.dir	bmi.w	assexit		;puck moving away from this goalie
	movea.l	#tmstruct,a1		;load home team struct into a1
	lea.l	tmsize(a1),a2		;load away team struct into a2
	btst	#pfteam,pflags(a3)		;check if player is home or away
	beq.w	.t0		;branch if home
	exg.l	a1,a2		;swap if away
.t0	cmpi.l	#$E10,tmnear(a1)		;each team's nearest distance^2 (tmnear) vs limits
	blt.w	assexit
	cmpi.l	#$640,tmnear(a2)
	blt.w	assexit
.go	bra.w	skatetopuck
breakaway						;puck carrier a3 on a breakaway: beep on a new assignment and check the
									;skating direction toward the net
	bset	#$2,(sflags5).l
	bclr	#pfna,pflags(a3)		;pfna - clear new assignment
	beq.w	.nna		;jump if no new assignment
	move.w	#$2,-(sp)		;ding SFX
	jsr	(sfx).l
	movem.l	a2,-(sp)		;push a2 on stack
	movea.l	#tmstruct,a2		;move Home Team Struct into a2
	btst	#pfteam,pflags(a3)		;pfteam - check if home or away
	beq.w	.c0		;jump if home
	movea.l	#awtmstruct,a2		;move Away Team Struct into a2
.c0	addi.w	#$1,$35A(a2)		;add one to breakaway attempt
	addi.w	#$14,(CwdExciteLvl).l
	addi.w	#$C8,(Crowdlevel).l		;add to Crowdlevel
	movem.l	(sp)+,a2
.nna	movem.w	d1,-(sp)		;push d1 on stack
	move.w	Ypos(a3),d0		;move Ypos into d0
	move.w	Yvel(a3),d1		;move Yvel into d1
	beq.w	.yvel0		;jump if Yvel = 0
	eor.w	d1,d0		;EOR d1 with d0. d0 will be negative if skating opposite direction of net
.exit	movem.w	(sp)+,d1		;pop d1 off stack
	rts
.yvel0	move.w	#$FFFF,d1
	bra.w	.exit
BreakawayOffsidesFlagSet						;On a new assignment clear the offsides and breakaway bits of a3. Behind
									;the goal line or not yet in the attack zone set pf3oside, else end the
									;assignment
	btst	#pfna,pflags(a3)		;check for new assignment
	beq.w	.loadYpos		;branch if no new assignment
	bclr	#pf3oside,pflags3(a3)		;clear player offsides flag
	bclr	#pf3break,pflags3(a3)		;clear player breakaway flag
.loadYpos	movem.w	d0-d1/a0,-(sp)
	move.w	#$108,d0		;108 = top goal line Y pos
	move.w	Ypos(a3),d1		;Ypos
	bpl.w	.cmpgoalline		;branch if Ypos is positive
	neg.w	d1		;negate d1
.cmpgoalline	cmp.w	d0,d1		;compare position to top goal line
	bge.w	.nogood		;Branch if above it
	move.w	#$58,d0		;58 = top blue line Y pos
	move.w	Ypos(a3),d1		;Ypos
	btst	#pfgoal,pflags(a3)		;check goal to shoot on (0=bottom, 1=top)
	bne.w	.top		;branch if top goal
	neg.w	d0		;bottom goal, so negate d0
	cmp.w	d1,d0		;compare Ypos to blue line Y
	blt.w	.setoffside		;branch if not in attack zone
	bra.w	.offzone		;branch if in attack zone
.top	cmp.w	d1,d0		;compare Ypos to blue line Y
	blt.w	.offzone		;branch if in offensive zone
.setoffside	bset	#pf3oside,pflags3(a3)		;set offsides flag
	bra.w	.nogood
.offzone	bclr	#pf3oside,pflags3(a3)		;clear offside bit
	beq.w	.nogood		;branch if on the blue line
	movea.l	#SortCords+(11*SCstruct),a0		;loads last SCScruct player struct (Away pos #6)
	move.w	#$B,d0		;B = # of player structs to check (12)
	tst.w	d1		;checks if d1 is negative (determines what zone to check)
	bmi.w	.checkYpos
.checkYpos2	cmp.w	Ypos(a0),d1		;compare Ypos of a0 player to d1 (Ypos puckc)
	bge.w	.substruct2		;branch if d1 greater than or equal
	tst.w	position(a0)		;check if goalie
	beq.w	.substruct2		;branch if goalie
	bra.w	.nogood
.substruct2	suba.w	#$80,a0
	dbra	d0,.checkYpos2
.setBAbit	bset	#pf3break,pflags3(a3)		;set breakaway bit
	move.w	#$1,d0		;moves 1 into d0 (used by returned subroutine)
.exit	movem.w	(sp)+,d0-d1/a0
	rts
.nogood	move.w	#$0,d0		;move 0 into d0 (used on return to subroutine)
	bra.w	.exit
.checkYpos	cmp.w	Ypos(a0),d1		;check Ypos with d1 (d1 = blue line Y)
	ble.w	.substruct
	tst.w	position(a0)		;checks if goalie (who would be below blue line)
	beq.w	.substruct
	bra.w	.nogood
.substruct	suba.w	#$80,a0		;subtract SCstruct size (80 hex)
	dbra	d0,.checkYpos
	bra.w	.setBAbit
chkpuckc						;puck carrier a3: check for a breakaway (not in a shootout or penalty
									;shot), else assign asspuckc
	btst	#$0,(gmode2).l
	bne.w	.0
	btst	#$2,(BA_PS_flags).l
	bne.w	.0
	bsr.w	breakaway
	bpl.w	asspuckc		;currently skating towards net in Y
.0	bclr	#pf3break,pflags3(a3)		;clear breakaway bit
	move.w	#$10,d0		;asspuckc
	bsr.w	assreplace
asspuckc						;player a3 is puck handler
	bclr	#$2,(sflags5).l
	bne.w	.0
	bclr	#pf3break,pflags3(a3)
.0	move.w	(puckc).l,d0
	cmp.w	SCnum(a3),d0
	bne.w	assexit
	btst	#$2,(BA_PS_flags).l
	beq.w	.1
	cmpi.w	#$1,(msgtimer).l
	bgt.w	.x
.1	btst	#pf3break,pflags3(a3)
	bne.w	.2
	btst	#$2,(BA_PS_flags).l
	bne.w	.2
	jsr	(BreakawayOffsidesFlagSet).l
	beq.w	.2		;branch if breakaway flag not set
	move.w	#$21,d0		;chkpuckc assignment
	bsr.w	assreplace
	bra.w	.2
.2	btst	#pfalock,pflags(a3)
	bne.w	.x
	btst	#$2,(BA_PS_flags).l
	bne.w	.3
	btst	#gmclock,(gmode).l
	bne.w	donothing
.3	btst	#pfjoycon,pflags(a3)
	bne.w	assexit
	bclr	#pfna,pflags(a3)
	beq.w	.7
	btst	#pf3break,pflags3(a3)
	beq.w	.4
	move.w	#$2,-(sp)
	jsr	(sfx).l
.4	btst	#pf3break,pflags3(a3)
	beq.w	.6
	movem.l	a2,-(sp)
	movea.l	#tmstruct,a2
	btst	#pfteam,pflags(a3)
	beq.w	.5
	movea.l	#awtmstruct,a2
.5	addi.w	#$1,$35A(a2)
	addi.w	#$14,(CwdExciteLvl).l
	addi.w	#$C8,(Crowdlevel).l
	movem.l	(sp)+,a2
.6	clr.w	temp1(a3)
	move.w	#$8,temp2(a3)
.rloop	btst	#$7,(GA_COMFLAGS).l
	bne.b	.rloop
	move.w	#$1B,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.rloop2	btst	#$6,(GA_COMFLAGS).l
	beq.b	.rloop2
	move.w	(GA_COMCMD0).l,d0
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.rloop3	btst	#$6,(GA_COMFLAGS).l
	bne.b	.rloop3
	bclr	#$7,(GA_COMFLAGS+1).l
	andi.w	#$3,d0
	move.w	d0,temp3(a3)
.7	sub.b	d7,temp1(a3)
	bpl.w	.nodec
	move.b	aioff(a3),temp1(a3)
	jsr	(ReadGoaliePulled).l
	bmi.w	.8
	btst	#$6,(sflags7).l
	beq.w	.9
	tst.b	temp1(a3)
	beq.w	.9
.8	subi.b	#$1,$40(a3)
.9	btst	#$2,(BA_PS_flags).l
	bne.w	.soshot
	btst	#$0,(gmode2).l
	bne.w	.soshot
	bsr.w	checkob
	bsr.w	chk4lc
	btst	#$0,(gmode2).l
	bne.w	.soshot
	btst	#$2,(BA_PS_flags).l
	bne.w	.soshot
	btst	#pf3break,pflags3(a3)
	bne.w	.shot
	move.w	#$1,d0
	btst	#pfteam,pflags(a3)
	beq.w	.10
	move.w	#$2,d0
.10	cmp.w	(cont1team).l,d0
	beq.w	.shot
	cmp.w	(cont2team).l,d0
	beq.w	.shot
	btst	#$1,(Vcount+1).l
	bne.w	.pass
.shot	bsr.w	CheckPuckHolder2
	bra.w	.pass
.soshot	jsr	(ShootoutShootCheck).l
	bne.w	.nodec
	jsr	(CompShoot).l
.pass	bsr.w	chk4pass
.nodec	moveq	#$6,d0
	add.w	temp3(a3),d0		;add temp3 to d0
	lea.l	.postab2(pc),a0
	btst	#sf2offsig,(sflags2).l		;#sf2offsig
	beq.w	.nd1
	move.w	position(a3),d0		;position
.nd1	asl.w	#$2,d0
	move.w	$2(a0,d0.w),d1
	move.w	(a0,d0.w),d0
	btst	#$2,(BA_PS_flags).l
	bne.w	.path
	btst	#$0,(gmode2).l
	beq.w	.15
.path	jsr	(SkatePath).l
	cmpi.b	#$80,(sopathx).l
	beq.w	.x
.15	btst	#pfgoal,pflags(a3)		;pfgoal - 0 for bottom 1 for top
	bne.w	.next2
	neg.w	d0
	neg.w	d1
.next2	lea.l	.chkdir(pc),a0
	btst	#$2,(BA_PS_flags).l
	bne.w	.16
	btst	#$0,(gmode2).l
	beq.w	.17
.16	lea.l	.x(pc),a0
.17	bra.w	skateto
.chkdir								;d0 = wanted direction: look for opponents in the way (skateto calls this)
	ext.w	d0
	move.b	Xvel(a3),d2
	ext.w	d2
	add.w	(puckx).l,d2
	move.b	Yvel(a3),d3
	ext.w	d3
	add.w	(pucky).l,d3
	clr.w	(threat).l
	moveq	#$5,d4
	movea.l	#SortCords,a0
	cmpi.w	#$6,SCnum(a3)
	bge.w	.loop
	adda.w	#$300,a0			;6*SCstruct: away team SCstruct start
.loop								;loop over the opponents
	move.b	Xvel(a0),d1
	ext.w	d1
	add.w	$0(a0),d1			;Xpos
	sub.w	d2,d1
	cmpi.w	#$14,d1
	bgt.w	.next
	cmpi.w	#$FFEC,d1
	blt.w	.next
	move.b	Yvel(a0),d1
	ext.w	d1
	add.w	Ypos(a0),d1
	sub.w	d3,d1
	cmpi.w	#$14,d1
	bgt.w	.next
	cmpi.w	#$FFEC,d1
	blt.w	.next
	addi.w	#$1,(threat).l
	move.w	$0(a3),d0			;Xpos
	sub.w	$0(a0),d0			;Xpos
	move.w	Ypos(a3),d1
	sub.w	Ypos(a0),d1
	bsr.w	vtoa
	move.w	facedir(a3),d1
	eori.w	#$4,d1
	cmp.w	d0,d1
	bne.w	.next
.rnd	btst	#$7,(GA_COMFLAGS).l			;random number from the sub CPU (command $1B), where the cartridge reads HVcount
	bne.b	.rnd
	move.w	#$1B,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.rnd2	btst	#$6,(GA_COMFLAGS).l
	beq.b	.rnd2
	move.w	(GA_COMCMD0).l,d1
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.rnd3	btst	#$6,(GA_COMFLAGS).l
	bne.b	.rnd3
	bclr	#$7,(GA_COMFLAGS+1).l
	andi.w	#$1,d1
	add.w	d1,d0
	andi.w	#$7,d0
.next								;next opponent
	adda.w	#$80,a0			;SCstruct size
	dbra	d4,.loop
.x									;exit (also the end of the code above)
	rts
.postab2	dc.w	$FF9C,$FFEC,$64,$FFEC,$FF88,$28,$14,$28,$78,$28	;target spots (x,y pairs)
	dc.w	$FFEC,$28,$FFD8,$F0,0,$DC,$14,$E6,$1E,$E6
; Checks the line-change input state.
chk4lc
	btst	#$4,(sflags7).l
	bne.w	.ex
	move.w	(pucky).l,d0
	btst	#$7,pflags(a3)
	bne.w	.next
	neg.w	d0
.next	tst.w	d0
	bmi.w	check4benchExit
	cmpi.w	#$58,d0
	bgt.w	check4benchExit
.loop	btst	#$7,(GA_COMFLAGS).l
	bne.b	.loop
	move.w	#$1B,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.loop2	btst	#$6,(GA_COMFLAGS).l
	beq.b	.loop2
	move.w	(GA_COMCMD0).l,d0
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.loop3	btst	#$6,(GA_COMFLAGS).l
	bne.b	.loop3
	bclr	#$7,(GA_COMFLAGS+1).l
	andi.w	#$3,d0
	bne.w	check4benchExit
	btst	#$3,pflags2(a3)
	bne.w	check4benchExit
	movea.l	#tmstruct,a2
	lea.l	tmsize(a2),a1
	btst	#$6,pflags(a3)
	beq.w	.next2
	exg.l	a1,a2
.next2	jsr	(AvgCline).l
	cmpi.w	#$C00,d0
	bhi.w	check4benchExit
	bsr.w	CompLine
	jsr	(setpersonel).l
	jsr	(printscores1).l
	bra.w	CompShoot
.ex	rts
chkpk
	btst	#sf2pwrplay,(sflags2).l
	bne.w	chkpk2
	eori.b	#$4,ccr
	rts
chkpk2						;return z flag set if a3's team is the one on the power play (sf2pwrtm
									;against pfteam)
	movem.l	d0-d1,-(sp)
	btst	#sf2pwrtm,(sflags2).l		;#sf2pwrtm - 0 for team 1, 1 for team 2
	move.w	sr,d0
	btst	#pfteam,pflags(a3)		;pfteam - 0 home, 1 away
	move.w	sr,d1
	eor.w	d1,d0
	move.w	d0,ccr
	movem.l	(sp)+,d0-d1
	rts

; Checks the puck holder and waits for DMA.
CheckPuckHolder2
	bsr.w	chkpk
	bne.w	CheckPuckHolder2Random
	tst.w	(threat).l
	beq.w	CheckPuckHolder2Random
.loop	btst	#$7,(GA_COMFLAGS).l
	bne.b	.loop
	move.w	#$1B,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.loop2	btst	#$6,(GA_COMFLAGS).l
	beq.b	.loop2
	move.w	(GA_COMCMD0).l,d0
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.loop3	btst	#$6,(GA_COMFLAGS).l
	bne.b	.loop3
	bclr	#$7,(GA_COMFLAGS+1).l
	andi.w	#$3,d0
	bne.w	CheckPuckHolder2Random
	move.w	#$58,d0
	btst	#$7,$62(a3)
	beq.w	.next
	move.w	#$FFA8,d0
	cmp.w	$14(a3),d0
	blt.w	CompShoot
	bra.w	.next2
.next	cmp.w	$14(a3),d0
	bgt.w	CompShoot
.next2	bset	#$3,(sflags5).l
	jmp	(dopass).l
	bra.w	CompShoot
; Random check ($1E) when flag 1 of $64 is set
CheckPuckHolder2Random
	btst	#$1,$64(a3)
	beq.w	.next2
	move.w	#$1E,d0
	jsr	(randomd0).l
	addi.w	#$82,d0
	cmp.w	(pucky).l,d0
	blt.w	.next
	neg.w	d0
	cmp.w	(pucky).l,d0
	bgt.w	.next
	bra.w	.next2
.next	move.w	#$2,d0
	jsr	(randomd0s).l
	add.w	$54(a3),d0
	andi.w	#$7,d0
	move.w	d0,$54(a3)
	bra.w	CompShoot
.next2	moveq	#$20,d4
	clr.w	d1
	move.b	$70(a3),d1
	lsr.w	#$1,d1
	sub.b	d1,d4
	asl.w	#$4,d4
	move.w	#$108,d1
	btst	#$7,$62(a3)
	bne.w	.next3
	neg.w	d1
.next3	sub.w	(pucky).l,d1
	move.w	(puckx).l,d0
	neg.w	d0
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d0,d1
	cmpi.l	#$2710,d1
	movem.w	(sp)+,d0-d1
	bhi.w	.next6
	lsr.w	#$4,d4
	bsr.w	vtoa
	move.w	d0,d5
	moveq	#$5,d3
	movea.l	#SortCords,a1
	cmpi.w	#$6,$52(a3)
	bge.w	.loop
	adda.w	#$300,a1
.loop	tst.w	$34(a1)
	beq.w	.next4
	move.w	$0(a1),d0
	sub.w	(puckx).l,d0
	move.w	$14(a1),d1
	sub.w	(pucky).l,d1
	bsr.w	vtoa
	cmp.w	d5,d0
	bne.w	.next5
	asl.w	#$1,d4
	bra.w	.next5
.next4	btst	#$1,$63(a1)
	beq.w	.next5
	clr.w	d3
	moveq	#$1,d4
.next5	adda.w	#$80,a1
	dbra	d3,.loop
.next6	move.w	d4,d0
	bsr.w	randomd0
	btst	#$0,$70(a3)
	beq.w	.next7
	cmpi.w	#$7,d0
	bgt.w	check4benchExit
	bra.w	.next8
.next7	cmpi.w	#$8,d0
	bgt.w	check4benchExit
.next8	move.w	(pucky).l,d0
	btst	#$7,$62(a3)
	bne.w	.next9
	neg.w	d0
.next9	tst.w	d0
	bmi.w	check4benchExit
	move.w	#$108,d1
	sub.w	d0,d1
	bmi.w	check4benchExit
	btst	#$7,(sflags2).l
	bne.w	check4benchExit
CompShoot						;computer shot: drop the return address and aim from the puck's distance
									;to the goal line
	adda.w	#$4,sp
	move.w	(pucky).l,d0
	btst	#pfgoal,pflags(a3)
	bne.w	.ds0
	neg.w	d0
.ds0	move.w	#$108,d1		;d0 is now puck y toward the goal I shoot at
	sub.w	d0,d1		;d1 = distance to $108 along the shooting direction
	lsr.w	#$3,d1
	cmpi.w	#$14,d1
	blt.w	.0
	moveq	#$14,d1
.0	move.w	d1,temp2(a3)
	moveq	#$12,d0
	bra.w	assreplace
chk4pass						;player a3 looks for good pass (computer controlled)
	tst.w	(threat).l
	bne.w	.dp0		;an opponent is close: always consider a pass
	moveq	#$10,d0
	add.b	spodds(a3),d0
	bsr.w	randomd0		;0 <= d0 < $10 + odds
	cmpi.w	#$C,d0
	bgt.w	check4benchExit
.dp0	moveq	#$6,d0		;Set up pass assignment
	bsr.w	randomd0		;d0 = random teammate index 0-5
	cmpi.w	#$6,SCnum(a3)
	blt.w	.0
	addi.w	#$6,d0
.0	tst.w	position(a3)
	beq.w	.1
	cmpi.w	#$28,(puckx).l
	bgt.w	.1
	cmpi.w	#$FFD8,(puckx).l
	blt.w	.1
	cmpi.w	#$CC,(pucky).l
	bgt.w	check4benchExit
	cmpi.w	#$FF34,(pucky).l
	blt.w	check4benchExit
.1	cmp.w	SCnum(a3),d0
	beq.w	check4benchExit
	asl.w	#$7,d0		;d0 * SCstruct ($80)
	movea.l	#SortCords,a0
	adda.w	d0,a0		;a0 = receiver sort object
	tst.w	position(a0)
	ble.w	check4benchExit
	btst	#pf2unav,pflags2(a0)
	bne.w	check4benchExit
	btst	#pfalock,pflags(a0)
	bne.w	check4benchExit
	move.w	Ypos(a0),d0		;check for pass across blue line
	move.w	Ypos(a3),d1		;d0 = receiver y, d1 = my y (toward the goal I shoot at)
	btst	#pfgoal,pflags(a3)
	bne.w	.f0
	neg.w	d0
	neg.w	d1
.f0	btst	#gmoffs,(gmode).l		;offsides on?
	beq.w	.oko
	movem.w	d0-d1,-(sp)
	subi.w	#$58,d0		;y relative to the blue line
	subi.w	#$58,d1
	eor.w	d0,d1		;sign differs if the pass crosses the blue line
	movem.w	(sp)+,d0-d1
	bmi.w	check4benchExit
.oko	cmpi.w	#$58,d0
	bgt.w	.ok
	sub.w	d1,d0
	cmpi.w	#$FFF1,d0
	blt.w	check4benchExit
.ok	move.w	$0(a0),d0		;receiver accepted: get the pass direction
	sub.w	(puckx).l,d0
	move.w	Ypos(a0),d1
	sub.w	(pucky).l,d1
	movem.w	d0-d1,-(sp)
	bsr.w	vtoa
	move.w	d0,(passdir).l
	movem.w	(sp)+,d1-d2
	muls.w	d1,d1
	muls.w	d2,d2
	add.l	d1,d2		;d2 = squared distance to the receiver
	moveq	#$5,d3
	movea.l	#SortCords,a1
	cmpi.w	#$6,SCnum(a3)
	bge.w	.co0
	adda.w	#$300,a1		;loop over the 6 opponents
.co0	move.w	$0(a1),d0		;next opponent: is he in the pass lane?
	sub.w	(puckx).l,d0
	move.w	Ypos(a1),d1
	sub.w	(pucky).l,d1
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d0,d1		;d1 = squared distance to this opponent
	cmp.l	d2,d1
	movem.w	(sp)+,d0-d1
	bhi.w	.co1		;farther than the receiver: ignore
	bsr.w	vtoa
	cmp.w	(passdir).l,d0
	beq.w	check4benchExit
.co1	adda.w	#$80,a1
	dbra	d3,.co0
	bsr.w	dopass		;lane is clear: pass in passdir
	tst.w	position(a3)
	beq.w	check4benchExit
	adda.w	#$4,sp
	bra.w	assexit
EvadePC						;player a3 should avoid the puck carrier if he's on my team out: d0 =
									;direction 0-7 pointing away from the puck (from vtoa), adjusted near the
									;blue line
	tst.w	(puckc).l
	bmi.w	check4benchExit		;no puck carrier
	move.b	Xvel(a3),d2
	sub.b	(puckvx).l,d2		;sub puckvx from Xvel
	ext.w	d2
	add.w	Xpos(a3),d2
	sub.w	(puckx).l,d2
	cmpi.w	#$28,d2		;compare to 40 decimal
	bgt.w	check4benchExit		;exit if greater than 40
	cmpi.w	#$FFD8,d2		;compare to -40
	blt.w	check4benchExit
	move.b	Yvel(a3),d1
	sub.b	(puckvy).l,d1		;sub puckvy from Yvel
	ext.w	d1
	add.w	Ypos(a3),d1
	sub.w	(pucky).l,d1
	cmpi.w	#$28,d1
	bgt.w	check4benchExit
	cmpi.w	#$FFD8,d1
	blt.w	check4benchExit
	move.w	Xpos(a3),d0
	sub.w	(puckx).l,d0
	move.w	Ypos(a3),d1
	sub.w	(pucky).l,d1
	bsr.w	vtoa		;find direction and convert to 0-7
	btst	#gmoffs,(gmode).l		;check if offsides is on
	beq.w	.ex
	move.w	Ypos(a3),d1
	btst	#pfgoal,pflags(a3)		;check what net shooting at
	bne.w	.0		;branch if top
	neg.w	d1
.0	subi.w	#$58,d1		;sub 88 from Ypos (top blue line)
	cmpi.w	#$A,d1
	bgt.w	.ex
	cmpi.w	#-50,d1
	blt.w	.ex
	moveq	#$2,d0		;near the blue line: go sideways, d0 = 2 if x > puck x
	move.w	Xpos(a3),d1
	cmp.w	(puckx).l,d1
	bgt.w	.ex
	moveq	#$6,d0
.ex	rts
checkob						;bring up little warning ref if a player on your team is over blue line
	btst	#gmoffs,(gmode).l
	beq.w	check4benchExit
	btst	#$2,(BA_PS_flags).l
	bne.w	.ex
	movem.l	d0-d1/a0,-(sp)
	moveq	#$5,d0		;6 players of a3's team
	movea.l	#SortCords,a0
	cmpi.w	#$6,SCnum(a3)
	blt.w	.0
	adda.w	#$300,a0		;a0 = first sort object of a3's team
.0	moveq	#$5C,d1
	btst	#pfgoal,pflags(a3)
	bne.w	.top		;shooting at the top goal: mirrored tests below
	neg.w	d1		;d1 = -$5C
	cmp.w	(pucky).l,d1
	bgt.w	.nob		;puck already across the line: nobody can be offside
.bottom	tst.w	position(a0)		;loop over the team, skipping negative positions
	bmi.w	.bn
	cmp.w	Ypos(a0),d1
	bgt.w	.ob		;this player is over the line
.bn	adda.w	#$80,a0
	dbra	d0,.bottom
.nob	moveq	#$40,d0		;no one offside: d0 = $40 = clear the ref window (PushRef)
	bclr	#sf2offsig,(sflags2).l		;clear the offsides ref flag
	bne.w	.dref		;it was on: update the ref
.loop	movem.l	(sp)+,d0-d1/a0
.ex	rts
.ob	moveq	#$6,d0
	bset	#sf2offsig,(sflags2).l		;someone is offsides: show the little ref
	bne.w	.loop		;already shown
.dref	tst.w	(RefCnt).l
	bpl.w	.loop
	bsr.w	PushRef
	bra.w	.loop
.top	cmp.w	(pucky).l,d1
	blt.w	.nob
.top1	tst.w	position(a0)		;loop over the team's players (top goal)
	bmi.w	.tn
	cmp.w	Ypos(a0),d1
	blt.w	.ob
.tn	adda.w	#$80,a0		;next player
	dbra	d0,.top1
	bra.w	.nob
assbreakaway						;assignment for a breakaway: the puck carrier skates in, anyone else goes
									;back to assnearest
	move.w	SCnum(a3),d0		;Move SCnum into d0
	cmp.w	(puckc).l,d0		;compare puck carrier SCnum with d0
	beq.w	assbreakaway_puckc		;branch if puck carrier
; Clears the breakaway flag and replaces the assist
assbreakawayStart	bclr	#$1,pflags3(a3)		;clear breakaway bit
	move.w	#$11,d0		;11 - assnearest
	bsr.w	assreplace
	bra.w	assnearest
assbreakaway_puckc						;this is a special assignment used for the player who is nearest the puck
									;but doesn't have it. Assignment anearest ($11)
									;a2 = a3's team struct, d7 = elapsed frames. temp1 = re-evaluation timer,
									;temp3 = hold timer
	jsr	(breakaway).l
	bmi.w	assbreakawayStart
; assnearest: tests the nearest flag and the puck holder
assnearest	bclr	#$2,(sflags5).l
	bne.w	.chkpuck
	bclr	#$1,pflags3(a3)		;clear breakaway bit
.chkpuck	move.w	SCnum(a3),d0		;move SCnum into d0
	cmp.w	(puckc).l,d0		;compare with puck carrier SCnum
	bne.w	.chkbreak		;jump if not puck carrier
	btst	#$1,pflags3(a3)		;check breakaway bit
	bne.w	.chkbreak		;jump if set
	btst	#$2,(BA_PS_flags).l		;check if bit 2 set (cleared on Faceoffs)
	bne.w	.chkbreak		;jump if set
	jsr	(BreakawayOffsidesFlagSet).l
	beq.w	.chkbreak
	move.w	#$22,d0		;22 - assbreakaway if flag set
	bsr.w	assreplace		;assreplace with assbreakaway
	bra.w	.chkbreak
.chkbreak	bclr	#$1,pflags(a3)		;pfna - clear new assignment
	beq.w	.nna
	btst	#$1,pflags3(a3)		;check if breakaway
	beq.w	.chkbreak2		;jump if not
	move.w	#$2,-(sp)		;ding SFX
	jsr	(sfx).l
.chkbreak2	btst	#$1,pflags3(a3)		;check if breakaway
	beq.w	.nobreak		;jump if not
	movem.l	a2,-(sp)		;push a2 to stack
	movea.l	#tmstruct,a2		;put Home Team Struct into a2
	btst	#$6,pflags(a3)		;pfteam - check home or away
	beq.w	.addcrowd		;jump if home
	movea.l	#awtmstruct,a2		;put Away Team Struct into a2
.addcrowd	addi.w	#$1,$35A(a2)		;add to breakaway attempt
	addi.w	#$14,(CwdExciteLvl).l
	addi.w	#$C8,(Crowdlevel).l		;add to crowd level
	movem.l	(sp)+,a2		;pop off stack into a2
.nobreak	clr.w	temp3(a3)		;clear temp3
	move.w	#$8,temp2(a3)		;move 8 into temp2
	clr.w	temp1(a3)		;clear temp1
.nna	move.w	SCnum(a3),d1		;checks if puck carrier
	cmp.w	(puckc).l,d1
	bne.w	.nopc		;jumps if not
	tst.w	position(a3)		;check if goalie
	beq.w	assgoalie		;branch if goalie
	moveq	#$10,d0
	btst	#$3,pflags(a3)		;pfjoycon - check if controlled
	beq.w	assinsert		;jump if not
	rts		;human controlled: leave as is
.nopc	sub.b	d7,temp1(a3)		;subtract d7 (elapsed frames) from temp1
	bpl.w	.nodec		;jump if positive
	move.b	aioff(a3),temp1(a3)		;move aioff into temp1
	jsr	(ReadGoaliePulled).l		;check if goalie is pulled
	bmi.w	.bonus
	btst	#$6,(sflags7).l		;check if crowd meter currently broken
	beq.w	.nopc2		;jump if not broken
	tst.b	temp1(a3)		;check if temp1 is 0
	beq.w	.nopc2		;jump if so
.bonus	subi.b	#$1,$40(a3)		;subtract 1 from temp1
.nopc2	btst	#$5,(sflags6).l		;check if slot bit is set (puckc in slot)
	beq.w	.nopc3		;branch if not set
	move.w	(puckc).l,d1		;move puck carrier SCnum
	cmpi.w	#$5,d1		;check if its home (5 or less) or away (6-11)
	bgt.w	.pcaway		;jump if away
	btst	#$6,pflags(a3)		;pfteam
	beq.w	.nopc3		;jump if home
.tmnopc	move.b	temp1(a3),d1		;temp1 into d1
	ext.w	d1		;extend d1
	asr.w	#$1,d1		;divide by 2
	move.b	d1,temp1(a3)		;move d1 into temp1 - cutting the timer in half
	bne.w	.nopc3		;jump if not zero
	move.b	#$1,temp1(a3)		;move 1 into temp1
	bra.w	.nopc3
.pcaway	btst	#$6,pflags(a3)		;pfteam - 0 home, 1 away
	beq.w	.tmnopc		;jump if home
.nopc3	clr.l	tmnear(a2)		;no nearest skater yet
	move.w	(puckc).l,d1		;move puck carrier SCnum into d1
	bmi.w	.np		;branch if no puck carrier
	asl.w	#$7,d1		;scsize
	movea.l	#SortCords,a1
	adda.w	d1,a1		;use d1 as offset
	move.b	pflags(a1),d0		;pflags of puck carrier
	move.b	pflags(a3),d1		;pflags of current player
	eor.b	d0,d1		;XOR pflags
	btst	#$6,d1		;check pfteam
	beq.w	.switch		;branch if on same team
.np	moveq	#-1,d2		;-1
	moveq	#$5,d4		;5 = # of players on team
	movea.l	tmsort(a2),a0		;SortCord start value for team
.de0	tst.w	position(a0)		;check if goalie
	ble.w	.next		;branch if goalie
	tst.b	nopuck(a0)		;check if nopuck (cant touch puck)
	bne.w	.next		;branch if nopuck timer not 0
	btst	#$2,pflags2(a0)		;pf2unav - unavailable
	bne.w	.next		;branch if unavailable
	move.w	assnum(a0),d0		;assnum - current assignment
	cmpi.b	#$13,asslist(a0,d0.w)		;check if current assignment is asspassrec
	beq.w	.next		;branch if a0 is going to receive puck
	move.l	a0,-(sp)		;push onto stack
	bsr.w	GetHot		;get hot spot
	add.w	$0(a0),d0		;Xpos to d0
	sub.w	(puckx).l,d0
	add.w	Ypos(a0),d1
	sub.w	(pucky).l,d1
	move.w	(puckvx).l,d3
	asr.w	#$6,d3
	sub.w	d3,d0
	move.w	(puckvy).l,d3
	asr.w	#$6,d3		;divide by 64
	sub.w	d3,d1		;sub d3 from d1 (Y distance between player and puck)
	muls.w	d0,d0		;square d0
	muls.w	d1,d1		;square d1
	add.l	d1,d0		;add d1 to d0
	cmp.l	d2,d0		;compare d2 to d0
	bhi.w	.next		;branch if d0 higher than d2 (0 or a positive # first run)
	move.l	d0,d2		;move d0 into d2
	movea.l	a0,a1		;move a0 address into a1
.next	adda.w	#$80,a0		;SCstruct size
	dbra	d4,.de0
	tst.l	d2		;check if 0
	bmi.w	.de1		;branch if less (no one near puck)
	move.l	d2,tmnear(a2)		;nearest skater's distance^2 to the puck
.switch	cmpa.l	a1,a3		;a1 = closest to the puck, or puckc (if on same team)
	beq.w	.de1		;branch if same
	btst	#$0,(gmode).l		;gmclock - 1 if stopped
	bne.w	.de1		;jump if stopped
	btst	#$2,pflags2(a1)		;pf2unav
	bne.w	.de1		;jump if unavailable
	btst	#$3,pflags3(a1)		;shooting one timer
	bne.w	.de1		;jump if shooting
	exg.l	a1,a3		;swap addresses
	bclr	#$0,pflags(a3)		;clear pfdoff
	moveq	#$11,d0
	bsr.w	assinsert		;... and give him the assnearest assignment
	exg.l	a1,a3
	bra.w	assexit		;I (old a3) drop this assignment
.de1	btst	#$5,pflags(a3)		;pfalock - check if locked in animation
	bne.w	check4benchExit		;exit if locked
	moveq	#$2,d1		;move 2 into d1
	cmpi.w	#$190,d2		;compare $190 (20^2) to d2. d2 = distance to puck^2
	bhi.w	.nfar		;branch if d2 higher
	subi.w	#$2,d1		;close: d1 = 0
	cmpi.w	#$2,position(a3)		;compare if position is F or D (1 and 2 are D)
	bls.w	.nodec		;jump if D
.nfar	btst	#$5,(sflags2).l		;sf2pwrplay - check if PP
	beq.w	.next2		;branch if no PP
	subi.w	#$2,d1		;sub 2 from d1
	bsr.w	chkpk2
	bne.w	.next2		;branch if on PK
	addi.w	#$4,d1		;add 4 to d1
.next2	moveq	#$28,d0
	sub.b	checking(a3),d0		;sub checking from d0
	asl.w	d1,d0		;shift d0 by value of d1
	bsr.w	randomd0		;RNG
	cmpi.w	#$2,d0		;compare 2 to d0
	bhi.w	.nodec		;branch if d0 more than 2
	move.w	#$F0,temp3(a3)		;move 240 dec into temp3
.nodec	btst	#$5,pflags(a3)		;pfalock - check if anim lock
	bne.w	check4benchExit		;exit if locked
	btst	#$2,(BA_PS_flags).l		;check bit 2
	beq.w	.gmclock		;jump if not set
	btst	#$5,(BA_PS_flags).l		;check bit 5
	beq.w	.nodec2		;jump if not set
.gmclock	btst	#$0,(gmode).l		;check if clock running
	bne.w	donothing		;branch if not
.nodec2	btst	#$3,pflags(a3)		;pfjoycon - check if controlled
	bne.w	check4benchExit		;jump if controlled
	btst	#$2,tmflags(a2)		;tmfmid of tmflags(a2)
	bne.w	.nodec22
	tst.w	(puckc).l		;check if theres a puck carrier
	bmi.w	assnearest_topuck		;jump if no puck carrier
	sub.w	d7,temp3(a3)		;subtract frames from temp3
	bpl.w	assnearest_topuck		;jump if positive
	clr.w	temp3(a3)		;clear temp3
.nodec22	bsr.w	skatetopuckinit		;d0/d1 = halfway between
	movem.w	d0-d1,-(sp)		;d0 = future puckx, d1 = future pucky push on stack
	neg.w	d0		;or (0,-$F4) if pfgoal
	neg.w	d1
	addi.w	#$F4,d1		;add goalline - 20 decimal
	btst	#$7,pflags(a3)		;pfgoal - check what net shooting on
	beq.w	.nd0		;branch if bottom
	subi.w	#$1E8,d1		;sub bottom goalline - 20 decimal
.nd0	asr.w	#$1,d0		;divide by 2
	asr.w	#$1,d1		;divide by 2
	add.w	(sp)+,d0		;add original future puckx
	add.w	(sp)+,d1		;add original future pucky
	btst	#$2,tmflags(a2)		;?? - doesn't seem to be set anywhere
	beq.w	.spdboost
	btst	#$7,pflags(a3)		;pfgoal
	beq.w	.botshoot		;branch if bottom
	cmpi.w	#$53,d1		;check if y pos of puck near blue line
	blt.w	.spdboost		;branch if in neutral zone or D zone
	move.w	#$44,d1		;move 44 hex into d1
	bra.w	.spdboost
.botshoot	cmpi.w	#$FFAD,d1		;check if pucky near bottom blue line
	bgt.w	.spdboost		;branch if in neutral zone or D zone
	move.w	#$FFBC,d1		;move FFBC into d1
.spdboost	btst	#$5,(sflags6).l		;check if puckc is in the slot
	beq.w	.noslot		;branch if not
	move.b	legspd(a3),(TempLegSpd).l		;legspd into TempLegSpd
	addi.b	#$6,$69(a3)		;add 6 to legspd
	btst	#$1,(sflags8).l		;check if crowd meter broken (always is)
	bne.w	.spdboostex		;jump if set
	btst	#$6,(sflags7).l		;check if crowd meter currently broken
	beq.w	.spdlimit		;jump if not set
.spdboostex	addi.b	#$2,$69(a3)
.spdlimit	cmpi.b	#$1E,legspd(a3)		;check speed limit
	ble.w	.cont
	move.b	#$1E,legspd(a3)		;limit legspd to $1E (30 decimal)
.cont	lea.l	(.exit).l,a0		;the cartridge uses lea rtss2(pc),a0
	bsr.w	skateto
	move.b	(TempLegSpd).l,legspd(a3)		;move original legpsd back into player
	bra.w	.chkslot
.noslot	lea.l	(.exit).l,a0		;the cartridge uses lea rtss2(pc),a0
	bsr.w	skateto
.chkslot	btst	#$5,(sflags6).l
	beq.w	.chkcont
	move.w	(pucky).l,d0
	move.w	Ypos(a3),d2		;Ypos into d2
	tst.w	d0		;check if d0 is 0
	bpl.w	.pospuck		;branch if positive
	neg.w	d0		;make d0 negative
	neg.w	d2		;make d2 negative
.pospuck	sub.w	d0,d2		;sub d0 from d2 (equals how far puck is from player Ypos)
	cmpi.w	#$A,d2		;check difference with A (10 decimal)
	blt.w	.exit
	move.w	$0(a3),d0		;Xpos of player (gets here if player is between net and puck carrier)
	sub.w	(puckx).l,d0
	bpl.w	.chkx		;branch if positive difference
	neg.w	d0		;make d0 negative
.chkx	cmpi.w	#$F,d0		;compare F (15 dec) with Xpos difference
	blt.w	.chkcont		;branch if less than (within 15 pix in X direction)
.exit	rts
.chkcont	btst	#$5,(sflags6).l		;check if puckc is in the slot
	beq.w	check4check		;branch if not in slot
	move.b	checking(a3),d0		;move Chk into d0
	ext.w	d0		;clear top byte of d0
	movem.l	d0/a3,-(sp)		;push to stack
	add.b	d0,d0		;add d0 to itself
	cmpi.b	#$1E,d0		;compare max Chk to d0
	blt.w	.chkcont2		;branch if less
	move.b	#$1E,d0		;move 1E into d0
.chkcont2	move.b	d0,checking(a3)		;move d0 into Chk
	bsr.w	check4check
	movem.l	(sp)+,d0/a3		;pop off stack
	move.b	d0,checking(a3)		;move original Chk into player
	rts
assnearest_topuck						;look for good opportunity for checking opponent. Falls in from
									;assnearest; also entered from assfwatch and asswingd roll against
									;the checking rating first, then look for an opponent within 30 units
									;whom a3 is facing
	bsr.w	skatetopuck
; Returns unless the player has a checker set at $34.
check4check	tst.w	position(a3)		;check if goalie
	bne.w	.player		;branch if not
	rts
.player	move.w	#$28,d0		;start with 28 hex (40 decimal)
	sub.b	checking(a3),d0		;subtract Chk from d0 (Chk max is 1E or 30 decimal)
	tst.w	(OptPen).l
	beq.w	.nopen		;branch if not on
	asl.w	#$1,d0		;mult by 2
.nopen	bsr.w	randomd0		;RNG d0
	cmpi.w	#$6,d0		;compare 6 to d0
	bhi.w	check4benchExit		;exit if d0 higher than 6
	moveq	#$5,d2		;move 5 into d2
	movea.l	#SortCords,a0
	cmpi.w	#$6,SCnum(a3)		;check if player on home team
	bge.w	.0		;branch if away
	adda.w	#$300,a0		;add if home (checks opposite team in loop)
.0	tst.w	position(a0)		;check if goalie
	beq.w	.next		;branch if goalie
	btst	#$5,pflags(a0)		;check if locked in anim
	bne.w	.next		;branch if locked
	btst	#$0,pflags2(a0)		;check if fighting
	bne.w	.next		;branch if fighting
	move.w	$0(a0),d0		;move Xpos into d0
	sub.w	$0(a3),d0		;sub a3 from a0
	cmpi.w	#$1E,d0		;compare to 30 decimal
	bgt.w	.next		;branch if more than 30 decimal
	cmpi.w	#$FFE2,d0		;compare to -30 decimal
	blt.w	.next		;branch if less than -30
	move.w	Ypos(a0),d1		;Ypos
	sub.w	Ypos(a3),d1		;subtract checker Ypos from d1
	cmpi.w	#$1E,d1		;compare to 30 decimal
	bgt.w	.next		;branch if more
	cmpi.w	#$FFE2,d1		;check with -30 decimal
	blt.w	.next		;branch if less
	bsr.w	vtoa		;determine direction
	cmp.w	facedir(a3),d0		;compare facedir with vtoa result
	bne.w	.next		;branch if not facing in that direction
	btst	#$5,(sflags6).l		;check if puckc in slot
	bne.w	Acheck		;branch if in slot
.loop	btst	#$7,(GA_COMFLAGS).l
	bne.b	.loop
	move.w	#$1B,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.loop2	btst	#$6,(GA_COMFLAGS).l
	beq.b	.loop2
	move.w	(GA_COMCMD0).l,d0
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.loop3	btst	#$6,(GA_COMFLAGS).l
	bne.b	.loop3
	bclr	#$7,(GA_COMFLAGS+1).l
	andi.w	#$3,d0		;pass first 2 bits
	bne.w	burst		;throw check
	bra.w	Acheck		;1 in 4: hold or hook on a0
.next	adda.w	#$80,a0		;move to next SCstruct
	dbra	d2,.0
	rts
asspassrec						;assignment for catching a pass (apassrec)
	btst	#pfalock,pflags(a3)		;pfalock - animation lock
	bne.w	check4benchExit		;exit if locked
	btst	#gmclock,(gmode).l		;gmclock - check if clock running
	bne.w	donothing		;exit if clock stopped
	btst	#pfjoycon,pflags(a3)		;pfjoycon - joystick controlled?
	bne.w	assexit		;exit if controlled
	bclr	#pfna,pflags(a3)		;#pfna - clear new assignment
	beq.w	.nna
	bset	#pfdoff,pflags(a3)		;#pfdoff - set decceleration off
	move.b	#$8,$43(a3)		;move into temp2+1
	clr.b	temp2(a3)		;clear temp2 byte
	move.w	#$FFFE,temp4(a3)		;move into temp4
.nna	tst.w	(puckc).l		;check if there is a puck carrier
	bpl.w	.exit		;exit if puck still in possession
	addi.w	#$1,$46(a3)		;add to temp4
	beq.w	.0		;branch if temp4 is zero
	bpl.w	.ex2		;branch if temp4 is positive
.0	tst.w	(onetimerplayer).l
	bpl.w	.ex2
	tst.w	position(a3)		;test if goalie
	beq.w	.ex2		;exit if goalie
	move.w	d0,-(sp)		;push d0 on stack
	clr.w	temp4(a3)		;clear temp4
	move.w	#$1,d0
	btst	#pfteam,pflags(a3)		;check if home or away
	beq.w	.1
	move.w	#$2,d0		;away team
.1	cmp.w	(cont1team).l,d0
	beq.w	.pop
	cmp.w	(cont2team).l,d0
	beq.w	.pop		;branch if so
	jsr	(PuckOnAttackHalf).l
	beq.w	.pop
	move.w	Ypos(a3),d0		;Ypos
	btst	#pfgoal,pflags(a3)		;pfgoal
	bne.w	.chkpos		;branch if shooting at top
	neg.w	d0
.chkpos	cmpi.w	#$58,d0		;blueline
	blt.w	.nozone
	cmpi.w	#$108,d0		;goalline
	bgt.w	.nozone
	bra.w	.atkzone
.nozone	move.w	#$8,d0		;outside of attack zone
	jsr	(randomd0).l
	tst.w	d0		;check if d0 is zero
	bne.w	.pop
.atkzone	move.w	(sp)+,d0
	move.w	#$FFFF,(inputjoy).l
	move.w	#$23,d0
	jmp	(assreplace).l
.pop	move.w	(sp)+,d0
.ex2	sub.b	d7,temp1(a3)
	bpl.w	check4benchExit
.exit	bclr	#pfdoff,pflags(a3)
	bra.w	assexit
SkateToTempTarget
	move.w	temp3(a3),d0
	move.w	temp4(a3),d1
	lea.l	rtss2(pc),a0
	bra.w	skateto
assshoot						;assignment for computer shooting. Assignment ashoot ($12)
	btst	#pfalock,pflags(a3)		;pfalock - animation locked
	bne.w	check4benchExit
	bclr	#pfna,pflags(a3)		;clear pfna
	beq.w	.nna
	bra.w	SetShotMode		;first frame: start the shot (temp2 = swing time set by CompShoot)
.nna	btst	#sfssdir,(sflags).l		;#sfssdir
	beq.w	assexit		;no: the shot is done
	clr.w	d2
	sub.w	d7,temp2(a3)		;count the swing time down
	bpl.w	ShotMode		;still swinging: feed ShotMode no buttons
	bset	#cbut,d2		;#cbut
	bra.w	ShotMode		;swing time over: press the shot button (cbut)
puckshootout						;puck logic for the shootout: on a new assignment clear the pads and
									;select the skater, then run the attempt
	bclr	#pfna,pflags(a3)
	beq.w	.selectskater
	bset	#$7,(sflags7).l
	clr.l	(padcont).l
	clr.l	(padcont+4).l
	clr.l	(padcont+8).l
	bclr	#$7,(gmode2).l
	btst	#$0,(gmode2).l
	beq.w	.startattempt
	jsr	(NextShooter).l
	bra.w	.initflags
.startattempt	jsr	(StartShootoutPath).l
	move.l	a2,-(sp)
	movea.l	#tmstruct,a2
	tst.w	(BA_Team).l
	beq.w	.countattempt
	movea.l	#awtmstruct,a2
.countattempt	addi.w	#$1,$362(a2)
	movea.l	(sp)+,a2
.initflags	bclr	#$2,(BA_PS_flags).l
	bclr	#$4,(BA_PS_flags).l
	bclr	#$5,(BA_PS_flags).l
	bclr	#$6,(BA_PS_flags).l
	bset	#$1,(sflags6).l
	btst	#gmpendel,(gmode).l
	bne.w	Stop4Pen
	bclr	#pfna,pflags(a3)
	btst	#$0,(gmode2).l
	beq.w	.selectsong
	tst.w	(shootoutteam).l
	bne.w	.setstopped
	tst.w	(homeshootnum).l
	bne.w	.setstopped
	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#SngFaceoff,(SongIndex).l
	jsr	(ChooseSong).l
	move.w	(SongNum).l,-(sp)
	bra.w	.playsong
.selectsong	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#SngFaceoff,(SongIndex).l
	jsr	(ChooseSong).l
	move.w	(SongNum).l,-(sp)
.playsong	bsr.w	song
.setstopped	bset	#gmclock,(gmode).l
	bset	#$1,(gmode2).l
	clr.w	(puckvx).l
	clr.w	(puckvy).l
	move.w	#$19,(shootoutclock).l
	bsr.w	ReturnGoalies
	st.b	temp1(a3)
	st.b	temp2(a3)
.selectskater	bset	#$2,(BA_PS_flags).l
	movem.w	d1-d2,-(sp)
	jsr	(SelectPenaltyShotSkater).l
	bmi.w	.noeligible
	movem.w	(sp)+,d1-d2
	bra.w	.checkgoalie
.noeligible	movem.w	(sp)+,d1-d2
	bclr	#$2,(BA_PS_flags).l
	move.w	#$1B,d0		;puckfaceoff
	bsr.w	assreplace
	rts
.checkgoalie	movem.w	d1-d2,-(sp)
	move.w	(BA_Goalie_SCnum).l,d0
	movea.l	#SortCords,a2
	asl.w	#$7,d0
	adda.w	d0,a2
	tst.w	position(a2)
	bne.w	.findgoalie
	btst	#$2,pflags2(a2)
	beq.w	.startpenshot
.findgoalie	move.w	(BA_Goalie_SCnum).l,d0
	move.w	#$6,d2
.goalieloop	subi.w	#$1,d2
	bmi.w	.noeligible
	subi.w	#$1,d0
	bpl.w	.wraphome
	move.w	#$5,d0
	bra.w	.checkcandidate
.wraphome	cmpi.w	#$5,d0
	bne.w	.checkcandidate
	move.w	#$B,d0
.checkcandidate	movea.l	#SortCords,a2
	move.w	d0,d1
	asl.w	#$7,d1
	adda.w	d1,a2
	tst.w	position(a2)
	bne.w	.goalieloop
	btst	#$2,pflags2(a2)
	bne.w	.goalieloop
	move.w	d0,(BA_Goalie_SCnum).l
.startpenshot	movem.w	(sp)+,d1-d2
	movea.l	#tmstruct,a2
	move.w	#$1F,d0		;puckpenshot
	bra.w	assreplace

SelectPenaltyShotSkater						;pick the skater for the penalty shot from team BA_Team
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a0
	tst.w	(BA_Team).l
	beq.w	.hometeam
	movea.l	#awtmstruct,a0
.hometeam	move.w	#$0,d1
	move.w	#$FFFF,d6
	move.w	#$FFFF,d5
	movea.l	tmdata(a0),a2
	adda.w	$0(a2),a2
.playerloop	cmpi.w	#$2,(a2)
	beq.w	.doneplayers
	adda.w	(a2),a2
	move.w	d1,d7
	asl.w	#$1,d7
	move.b	pldstick(a2),d0
	andi.w	#$F,d0
	cmpi.b	#$1,d0
	ble.w	.nextplayer
	btst	#$0,(gmode2).l
	bne.w	.setskaterscnum
	cmpi.w	#$FFFE,tmpdst(a0,d7.w)
	beq.w	.scorecandidate
	cmpi.w	#$FFFF,tmpdst(a0,d7.w)
	bne.w	.nextplayer
.scorecandidate	clr.w	d3
	clr.w	d0
	move.b	pldweight(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	pldlegspd(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	pldlegspd(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	pldaidef(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	pldaidef(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	pldstick(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	pldstick(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	pldendur(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	pldpass(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	cmp.w	(BA_Skater_Offset).l,d1
	bne.w	.comparebest
	move.w	#$7FFF,d3
.comparebest	cmp.w	d6,d3
	blt.w	.nextplayer
	move.w	d3,d6
	move.w	d1,d5
	bra.w	.nextplayer
.nextplayer	adda.l	#$8,a2
	addi.w	#$1,d1
	cmpi.w	#$1A,d1
	blt.w	.playerloop
.doneplayers	tst.w	d5
	bmi.w	.noeligible
	move.w	d5,(BA_Skater_Offset).l
.setskaterscnum	move.w	#$0,(BA_Sktr_SCnum).l
	tst.w	(BA_Team).l
	beq.w	.loadskater
	move.w	#$6,(BA_Sktr_SCnum).l
.loadskater	move.w	(BA_Sktr_SCnum).l,d0
	asl.w	#$7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	move.w	(BA_Skater_Offset).l,d3
	bra.w	.eligible
.noeligible	move.w	#$FFFF,d0
	bra.w	.exit
.eligible	move.w	#$1,d0
.exit	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Penalty shot: fade out and show the skater selection
puckpenshot	bclr.b	#$1,pflags(a3)
	beq.w	.next19
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	forceblack
.loop	btst.b	#$0,(disflags).l
	bne.w	.loop
	cmpi.w	#$258,(Crowdlevel).l
	bls.w	.next
	move.w	#$258,(Crowdlevel).l
	addi.w	#$14,(CwdExciteLvl).l
.next	move.w	(ExtraChars).l,d4
	movea.l	(RefsMap).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	bset.b	#$3,(disflags).l
	bclr.b	#$0,(sflags).l
	bclr.b	#$0,(sflags3).l
	clr.w	(glovecords).l
	clr.b	(iflags).l
	st.b	(RefCnt).l
	bclr.b	#$1,(sflags2).l
	st.b	(passReceiverPlayerNum).l
	bsr.w	ClrHor
	clr.w	(Vpos).l
	clr.w	(Hpos).l
	move.w	#$0,(puckx).l
	move.w	#$0,(pucky).l
	clr.w	(puckz).l
	clr.w	(puckvx).l
	clr.w	(puckvy).l
	clr.w	(puckvz).l
	st.b	(puckc).l
	movea.l	#SortCords+(12*SCstruct),a0
	clr.w	Xvel(a0)
	clr.w	Yvel(a0)
	clr.w	$0(a0)
	move.w	#$10C,Ypos(a0)
	adda.w	#$80,a0
	clr.w	Xvel(a0)
	clr.w	Yvel(a0)
	clr.w	$0(a0)
	move.w	#$FEF4,Ypos(a0)
	movea.l	#SortCords+((puckscnum+1)*SCstruct),a0
	move.w	#$18A,frame(a0)
	clr.w	SPA(a0)
	clr.w	attribute(a0)
	clr.w	(SortCords+(puckscnum*SCstruct)+attribute).l
	bclr.b	#$6,(sflags).l
	moveq	#$64,d4
.loop2	bsr.w	checkwindow
	dbra	d4,.loop2
	move.w	#$3C,(yleader).l
	jsr	(ResetBench).l
	movea.l	#tmstruct,a2
	jsr	(setpersonel).l
	jsr	(SetupPenaltyShot).l
	adda.l	#$366,a2
	jsr	(setpersonel).l
	jsr	(SetupPenaltyShot).l
	jsr	(resetplstuff).l
	move.l	a3,-(sp)
	movea.l	#SortCords+(11*SCstruct),a3
	move.w	#$B,d2
.loop3	cmp.w	(BA_Sktr_SCnum).l,d2
	beq.w	.next2
	cmp.w	(BA_Goalie_SCnum).l,d2
	beq.w	.next7
	move.w	#$FF10,$0(a3)
	clr.w	Ypos(a3)
	clr.w	frame(a3)
	move.w	#$20,d0
	bsr.w	assinsert
	bra.w	.next13
.next2	tst.w	position(a3)
	bpl.w	.next4
	bclr.b	#$2,pflags2(a3)
	beq.w	.next4
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d3
	move.b	pnum(a3),d3
	jsr	(setplayer).l
	movem.l	(sp)+,d0-d7/a0-a6
	tst.w	position(a3)
	beq.w	.next3
	bpl.w	.next4
.next3	nop
.next4	move.w	(puckx).l,d0
	subi.w	#$0,d0
	move.w	d0,$0(a3)
	move.w	(pucky).l,d0
	btst.b	#$7,pflags(a3)
	bne.w	.next5
	addi.w	#$10,d0
	move.w	#$4,facedir(a3)
	bra.w	.next6
.next5	addi.w	#$FFF0,d0
	move.w	#$0,facedir(a3)
.next6	move.w	d0,Ypos(a3)
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	clr.w	Zvel(a3)
	move.w	#$11,d0
	bsr.w	assinsert
	bra.w	.next13
.next7	btst.b	#$0,(gmode2).l
	beq.w	.next8
	move.b	(shootoutteam-1).l,pnum(a3)
	tst.w	(shootoutteam).l
	beq.w	.next9
	move.b	(homeshootnum-1).l,pnum(a3)
	bra.w	.next9
.next8	tst.w	position(a3)
	bpl.w	.next11
	bclr.b	#$2,pflags2(a3)
	beq.w	.next11
.next9	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d3
	move.b	pnum(a3),d3
	jsr	(setplayer).l
	movem.l	(sp)+,d0-d7/a0-a6
	tst.w	position(a3)
	bne.w	.next10
	bpl.w	.next11
.next10	nop
.next11	bclr.b	#$2,pflags2(a3)
	move.w	#$0,d0
	move.w	#$E5,d1
	btst.b	#$7,pflags(a3)
	bne.w	.next12
	move.w	#$FF1B,d1
.next12	move.w	d0,$0(a3)
	move.w	d1,Ypos(a3)
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	clr.w	Zpos(a3)
	sub.w	(puckx).l,d0
	sub.w	(pucky).l,d1
	neg.w	d0
	neg.w	d1
	bsr.w	vtoa
	move.w	d0,facedir(a3)
	bclr.b	#$2,pflags2(a3)
	bclr.b	#$5,pflags(a3)
	move.w	#$50C,d1
	bsr.w	SetSPA
.next13	suba.l	#$80,a3
	dbra	d2,.loop3
	jsr	(SprSort).l
	movea.l	(sp)+,a3
	bsr.w	ResetAndSelectPlayers
	move.w	(BA_Goalie_SCnum).l,d0
	asl.w	#$7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	move.w	#$0,$0(a3)
	move.w	#$FF06,Ypos(a3)
	btst.b	#$7,pflags(a3)
	bne.w	.next14
	move.w	#$FA,Ypos(a3)
.next14	move.w	(BA_Goalie_SCnum).l,d0
	move.w	#$1,d1
	btst.b	#$6,pflags(a3)
	beq.w	.next15
	move.w	#$2,d1
.next15	cmp.w	(cont1team).l,d1
	bne.w	.next16
	jsr	(setc1player).l
	bra.w	.next17
.next16	cmp.w	(cont2team).l,d1
	bne.w	.next17
	jsr	(setc2player).l
.next17	move.w	#$E,d0
	bsr.w	assreplace
	bset.b	#$7,(BA_PS_flags).l
	bset.b	#$2,(sflags2).l
	move.w	#$190,(msgtimer).l
	tst.w	(cont1team).l
	bne.w	.next18
	tst.w	(cont2team).l
	bne.w	.next18
	move.w	#$64,(msgtimer).l
.next18	move.w	#$18,(palcount).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.next19	bset.b	#$2,(gmode2).l
	move.w	#$18,d0
	bsr.w	assreplace
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	rts
; Table of 52 bytes after puckpenshot, 52 bytes: $00,$01,$02,$03,$04,$05 ...
	dc.b	$00,$01,$02,$03,$04,$05,$06,$00,$00,$01,$05,$03,$04,$02,$00,$00	; ................
	dc.b	$00,$03,$05,$01,$04,$00,$00,$00,$00,$00,$FF,$06,$FF,$DD,$FF,$CE	; ................
	dc.b	$00,$23,$FF,$CE,$FF,$CE,$FF,$F6,$00,$00,$FF,$F1,$00,$32,$FF,$F6	; .#...........2..
	dc.b	$00,$00,$FF,$C4	; ....
UpdatePenaltyShotEnd						;end the penalty shot when the goalie has the puck, the puck is loose or
									;the timer runs out
	movem.w	d0,-(sp)
	move.w	(puckc).l,d0
	cmp.w	(BA_Goalie_SCnum).l,d0
	movem.w	(sp)+,d0
	beq.w	.setended
	btst	#$5,(BA_PS_flags).l
	beq.w	.checktimer
	btst	#$5,(gmode2).l
	bne.w	.puckloose
	tst.w	(puckc).l
	bpl.w	.countdown
	bset	#$5,(gmode2).l
.puckloose	tst.w	(puckc).l
	bpl.w	.setended
.countdown	tst.w	(passmodetimer).l
	bmi.w	.setended
	subq.w	#$1,(passmodetimer).l
	bra.w	.checktimer
.setended	bset	#$4,(BA_PS_flags).l
.checktimer	tst.w	(shootoutclock).l
	bne.w	.checkended
	bset	#$4,(BA_PS_flags).l
.checkended	btst	#$4,(BA_PS_flags).l
	bne.w	.finishshot
	rts
.finishshot	btst	#$6,(BA_PS_flags).l
	bne.w	PenaltyShotEndReturn
	bset	#$6,(BA_PS_flags).l
	move.w	#$A,d0
	jsr	(AddPenalty2).l
EndPenaltyShotPlay						;stop play after a penalty shot or shootout attempt: freeze the window,
									;stop the clock, clear the penalty shot flags
	jsr	(freezewindow).l
	btst	#$0,(gmode2).l
	bne.w	.stopplay
	move.w	#$A,(replaydelay).l
	bset	#sf2drec,(sflags2).l
.stopplay	bset	#gmclock,(gmode).l
	bclr	#$2,(gmode2).l
	bclr	#$2,(BA_PS_flags).l
	bclr	#$3,(BA_PS_flags).l
	bclr	#$5,(BA_PS_flags).l
	bclr	#$4,(BA_PS_flags).l
	bclr	#$6,(BA_PS_flags).l
	movem.l	d0/a0,-(sp)
	movea.l	#SortCords,a0
	move.w	(BA_Sktr_SCnum).l,d0
	asl.w	#$7,d0
	move.b	(savednewpnum).l,newpnum(a0,d0.w)
	movem.l	(sp)+,d0/a0
	jsr	(CountShootoutGoals).l
; Return of EndPenaltyShotPlay
PenaltyShotEndReturn	rts
; Penalty shot: clears the flags and the timers
puckfaceoff	bclr.b	#$4,(sflags8).l
	btst.b	#$0,(gmode2).l
	beq.w	.next
	clr.w	(puckvx).l
	clr.w	(puckvy).l
	move.w	#$1E,d0
	bra.w	assreplace
.next	bclr.b	#$1,pflags(a3)
	beq.w	WaitForFaceoffLineChanges
	bclr.b	#$0,(sflags8).l
	beq.w	.next2
	clr.w	(fox).l
	clr.w	(foy).l
.next2	bclr.b	#$7,(sflags7).l
	clr.l	(padcont).l
	clr.l	(padcont+4).l
	clr.l	(padcont+8).l
	bclr.b	#$6,(sflags7).l
	bclr.b	#$2,(sflags7).l
	jsr	(CheckScoreLeader).l
	tst.w	(faceoffanim).l
	bmi.w	.next3
	move.w	(faceoffanim).l,d0
	bra.w	.next4
.next3	jsr	(RandomFaceoffAnim).l
	tst.w	d0
	bmi.w	.next5
.next4	jsr	(SetFaceoffAnim).l
.next5	bclr.b	#$1,(sflags6).l
	bclr.b	#$1,(gmode2).l
	tst.w	(gameclock).l
	beq.w	PeriodOver
	btst.b	#$6,(gmode).l
	bne.w	PeriodOver
	cmpi.w	#$3,(gsp).l
	bne.w	.next6
	move.w	(HmGoals).l,d0
	cmp.w	(AwGoals).l,d0
	bne.w	FaceoffContinueClock
.next6	btst.b	#$3,(gmode).l
	bne.w	Stop4Pen
	move.w	(PerTimeTotal).l,d0
	asr.w	#$1,d0
	cmp.w	(gameclock).l,d0
	bls.w	.next7
	cmpi.w	#$3C,(gameclock).l
	blt.w	.next7
	btst.b	#$7,(sflags3).l
	beq.w	.next7
	btst.b	#$0,(gmode).l
	beq.w	.next7
	btst.b	#$6,(sflags8).l
	bne.w	.next7
	bclr.b	#$7,(sflags3).l
	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#$2,(SongIndex).l
	jsr	(ChooseSong).l
	move.w	(SongNum).l,-(sp)
	bsr.w	song
.next7	bsr.w	ReturnGoalies
	st.b	temp1(a3)
	st.b	temp2(a3)
	tst.w	(OptLine).l
	bne.w	WaitForFaceoffLineChanges
	bclr.b	#tmflcm,(tmstruct+tmflags).l
	bclr.b	#tmflcm,(awtmstruct+tmflags).l
	movea.l	#SortCords,a0
	moveq	#$B,d0
.loop	bclr.b	#$3,pflags2(a0)
	adda.w	#$80,a0
	dbra	d0,.loop
	move.w	(cont1team).l,d0
	or.w	(cont2team).l,d0
	beq.w	.next8
	btst.b	#$7,(sflags).l
	beq.w	.next8
	bsr.w	forceblack
	bset.b	#$6,(sflags).l
	bsr.w	ClrHor
	move.w	#$18,(palcount).l
	tst.w	(OptLine).l
	bne.w	.next8
	btst.b	#$4,(sflags7).l
	beq.w	.next8
	clr.w	(palcount).l
.next8	move.w	(c1playernum).l,d0
	bmi.w	.next9
	bsr.w	StartFaceoffLineChange
.next9	move.w	(c2playernum).l,d0
	bmi.w	.next10
	bsr.w	StartFaceoffLineChange
.next10	movea.l	#tmstruct,a1
	lea.l	tmsize(a1),a2
	moveq	#$2,d0
	bsr.w	SetFaceoffComputerLine
	bra.w	WaitForFaceoffLineChanges
SetFaceoffComputerLine	tst.w	(OptLine).l
	bne.w	rtss2
	btst	#$4,(sflags7).l
	bne.w	.dochange
	cmp.w	(cont1team).l,d0
	beq.w	rtss2
	cmp.w	(cont2team).l,d0
	beq.w	rtss2
.dochange	bsr.w	CompLine
	jsr	(setpersonel).l
	bsr.w	printscores1
	move.w	#$2710,(crowdnoisedelay).l
	rts
StartFaceoffLineChange						;start the line change box for team d0's sort object before a faceoff
	exg.l	a2,a3
	asl.w	#$7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	bclr	#$3,pflags2(a3)
	move.l	a2,-(sp)
	bsr.w	SetLCmode
	movea.l	(sp)+,a2
	btst	#$3,pflags2(a3)
	beq.w	.exit
	btst	#pfteam,pflags(a3)
	beq.w	.homeplayer
	move.w	#$168,temp2(a2)
	move.w	SCnum(a3),temp4(a2)
	bra.w	.exit
.homeplayer	move.w	#$258,temp1(a2)
	move.w	SCnum(a3),temp3(a2)
.exit	exg.l	a2,a3
	rts
WaitForFaceoffLineChanges						;run both teams' faceoff line change timers (temp1 / temp2); continue when
									;both have run out
	move.w	#$40,d0
	bsr.w	UpdateFaceoffLineChangeTimer
	move.w	#$42,d0
	bsr.w	UpdateFaceoffLineChangeTimer
	tst.w	temp1(a3)
	bpl.w	rtss2
	tst.w	temp2(a3)
	bpl.w	rtss2
	movea.l	#tmstruct,a2
	lea.l	tmsize(a2),a1
	moveq	#$1,d0
	bsr.w	SetFaceoffComputerLine
	move.w	#$FFFF,(facelcwait).l
	move.w	#$1C,d0		;puckfaceoff2
	bra.w	assreplace
UpdateFaceoffLineChangeTimer						;count down one team's faceoff line change timer at offset d0 of a3
	tst.w	(a3,d0.w)
	bmi.w	rtss2
	move.w	$4(a3,d0.w),d1
	asl.w	#$7,d1
	movea.l	#SortCords,a0
	movea.l	#tmstruct,a2
	btst	#$6,pflags(a0,d1.w)
	beq.w	.checkactive
	adda.w	#tmsize,a2
.checkactive	btst	#pf2lcm,pflags2(a0,d1.w)
	bne.w	.countdown
	st.b	(a3,d0.w)
	bra.w	SetLCmode2
.countdown	sub.w	d7,(a3,d0.w)
	bpl.w	rtss2
	move.l	a3,-(sp)
	lea.l	(a0,d1.w),a3
	btst	#$3,pflags2(a3)
	beq.w	.exit
	clr.w	d2
	bsr.w	lcfound
	bsr.w	SetLCmode2
.exit	movea.l	(sp)+,a3
	rts
; Jumps back into clockcont
FaceoffContinueClock	jmp	(clockcont_0).l
ChkGoalies						;computer pulls goalie on delayed penalty. Called from periodicevents
	btst	#gmclock,(gmode).l		;check if clock running
	bne.w	rtss2
	movea.l	#tmstruct,a2		;a2 = team being tested, a1 = the other team
	lea.l	tmsize(a2),a1
	moveq	#$1,d0		;d0 = team number (1 home, 2 visitors)
	bsr.w	.chkgoalie
	moveq	#$2,d0
	exg.l	a1,a2
.chkgoalie	tst.w	tmgoalie(a2)		;check for goalie
	bmi.w	rtss2		;no goalie, exit
	move.w	(puckc).l,d1		;move puck carrier SCnum into d1
	bmi.w	rtss2
	subi.w	#$6,d1
	cmpa.l	#tmstruct,a2
	beq.w	.chkpen
	not.w	d1		;makes d1 negative if away team
.chkpen	tst.w	d1
	bpl.w	rtss2
	btst	#gmpendel,(gmode).l		;#gmpendel - delayed penalty called
	beq.w	.nopen
	st.b	tmgoalie(a2)		;sets to FFFF (no goalie)
	jmp	(setpersonel).l
.nopen	cmp.w	(cont1team).l,d0
	beq.w	rtss2
	cmp.w	(cont2team).l,d0
	beq.w	rtss2
	move.w	(pucky).l,d1
	bra.w	CPgoalie
ReturnGoalies						;if computer pulled goalie, look to see if computer should return him.
									;Called from puckfaceoff
	movea.l	#tmstruct,a2		;a2 = team being tested, a1 = the other team
	lea.l	tmsize(a2),a1
	moveq	#$1,d0		;d0 = team number
	bsr.w	.r		;home team first ...
	moveq	#$2,d0
	exg.l	a1,a2		;... then fall into .r for the visitors
.r	cmpi.w	#$FFFF,tmgoalie(a2)
	beq.w	rtss2		;still no goalie
	clr.b	tmgoalie(a2)		;clear for goalie return
	cmp.w	(cont1team).l,d0
	beq.w	rtss2
	cmp.w	(cont2team).l,d0
	beq.w	rtss2
	move.w	(foy).l,d1
CPgoalie						;see if computer should pull his goalie. d1 = puck/faceoff y. Falls in
									;from ReturnGoalies; also entered from ChkGoalies
	cmpi.w	#$2,(gsp).l		;check if 3rd period
	bne.w	rtss2		;exit if not
	move.w	tmscore(a1),d0		;tmscore
	sub.w	tmscore(a2),d0
	bmi.w	rtss2		;exit if leading in the game
	cmpi.w	#$2,d0
	bne.w	rtss2		;exit if behind by more than 2
	cmpi.w	#$3C,(gameclock).l
	bgt.w	rtss2		;exit if more than 1 min left
	move.l	a0,-(sp)
	movea.l	tmsort(a2),a0		;moves a player struct address into a0
	btst	#pfgoal,pflags(a0)		;#pfgoal
	movea.l	(sp)+,a0
	bne.w	.0
	neg.w	d1		;make y positive toward the goal I shoot at
.0	tst.w	d1
	bmi.w	rtss2		;exit if d1 negative (faceoff in own zone)
	st.b	tmgoalie(a2)		;set to FFFF (no goalie)
	jmp	(setpersonel).l
CompLine						;find good line for comp to switch to. a2 = team, a1 = other team. Called
									;from chk4lc and puckfaceoff
	movem.l	d0-d2/a0,-(sp)
	moveq	#$3,d0		;d0 = first of the 2 special lines (3-4) used with a man advantage
	move.w	tmap(a2),d1		;tmap
	sub.w	tmap(a1),d1		;compare the numbers of active players
	beq.w	.next		;equal: normal line
	bpl.w	.0
	addi.w	#$2,d0		;fewer players: lines 5-6 instead
.0	move.w	d0,-(sp)		;find pk/pp line
	bsr.w	getlinee		;d0 = energy of the first candidate
	move.w	d0,d1
	move.w	(sp),d0
	addi.w	#$1,d0
	bsr.w	getlinee		;d0 = energy of the second candidate
	cmp.w	d0,d1
	bge.w	.1
	addi.w	#$1,(sp)		;second one has more energy: take it
.1	move.w	(sp)+,tmline(a2)		;tmline
.ex
	movem.l	(sp)+,d0-d2/a0
	rts
.next	cmpa.l	#tmstruct,a2
	bne.w	.away
	moveq	#$2,d1
	lea.l	.next3(pc),a0
	cmpi.w	#$2,(gsp).l
	bne.w	.h0
	move.w	tmscore(a2),d2
	cmp.w	tmscore(a1),d2
	beq.w	.h0
	adda.w	#$E,a0
	bgt.w	.h0
	adda.w	#$E,a0
.h0	move.w	tmline(a1),d1
	asl.w	#$1,d1
	move.w	(a0,d1.w),d0
	bsr.w	getlinee
	cmpi.w	#$C00,d0
	bls.w	.away
	move.w	(a0,d1.w),tmline(a2)
	bra.w	.ex
; Table of 21 words after CompLine, 42 bytes: $0000,$0001,$0002,$0000,$0001,$0000 ...
.next3	dc.w	$0000,$0001,$0002,$0000,$0001,$0000,$0001,$0002
	dc.w	$0000,$0001,$0002,$0000,$0002,$0000,$0000,$0001
	dc.w	$0000,$0000,$0001,$0000,$0001

.away
	moveq	#$2,d1
	lea.l	.next5(pc),a0
	cmpi.w	#$2,(gsp).l
	bne.w	.a0
	move.w	tmscore(a2),d2
	cmp.w	tmscore(a1),d2
	beq.w	.a0
	adda.w	#$6,a0
	bgt.w	.a0
	adda.w	#$6,a0
.a0	move.w	(a0)+,d0
	bsr.w	getlinee
	cmpi.w	#$C00,d0
	dbhi	d1,.a0
	move.w	-(a0),tmline(a2)
	bra.w	.ex
.next5
	dc.w	$0000,$0001,$0002,$0000,$0002,$0001,$0000,$0001,$0000
puckfaceoff2						;face off control logic and general setup for action a3 = the puck. First
									;call sets the whole face off up (players, puck, scoreboard box, map);
									;later calls count temp1 down to the drop (updatefaceoff / Endfaceoff).
									;The disc-only labels below (CompLineScreen to FaceoffSongPick) are inside it
	bclr	#pfna,pflags(a3)		;new assignment? (clears the flag)
	beq.w	FaceoffTimerStep		;not first time thru (the cartridge's .nna)
	bclr	#$2,(BA_PS_flags).l
	bclr	#$5,(BA_PS_flags).l
	bclr	#$0,(sflags4).l
	bclr	#$1,(sflags4).l
	bclr	#$0,(DelayedPen).l
	bclr	#$1,(DelayedPen).l
	bclr	#$2,(DelayedPen).l
; Line change screen: fades out and sets the timer
CompLineScreen	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	forceblack
.loop	btst.b	#$0,(disflags).l
	bne.w	.loop
	move.w	#$3C,(holdreset).l
	tst.w	(fox).l
	bne.w	CompLineScreenFlag
	tst.w	(foy).l
	bne.w	CompLineScreenFlag
	move.w	#$FFFF,(faceoffanim).l
	bra.w	CompLineScreenLimit
; Clears flag 5 of the gate array flags
CompLineScreenFlag	bclr.b	#$5,(GA_COMFLAGS+1).l
; Limits the line change timer to $258
CompLineScreenLimit	cmpi.w	#$258,(Crowdlevel).l
	bls.w	.next
	move.w	#$258,(Crowdlevel).l
.next	bset.b	#$3,(disflags).l
	bclr.b	#$0,(sflags).l
	bclr.b	#$0,(sflags3).l
	clr.w	(glovecords).l
	clr.b	(iflags).l
	st.b	(RefCnt).l
	st.b	(puckcross2).l
	st.b	(puckcross6).l
	bclr.b	#$1,(sflags2).l
	bset.b	#$0,(sflags2).l
	bset.b	#$2,(sflags2).l
	st.b	(passReceiverPlayerNum).l
	st.b	(onetimerplayer).l
	bset.b	#$4,(disflags).l
	bsr.w	ClrHor
	move.w	#$2710,(crowdnoisedelay).l
	clr.w	(Vpos).l
	clr.w	(Hpos).l
	move.w	(fox).l,(puckx).l
	move.w	(foy).l,(pucky).l
	st.b	(puckz).l
	clr.w	(puckvx).l
	clr.w	(puckvy).l
	clr.w	(puckvz).l
	st.b	(puckc).l
	movea.l	#SortCords+(12*SCstruct),a0
	clr.w	Xvel(a0)
	clr.w	Yvel(a0)
	clr.w	$0(a0)
	move.w	#$10C,Ypos(a0)
	adda.l	#$80,a0
	clr.w	Xvel(a0)
	clr.w	Yvel(a0)
	clr.w	$0(a0)
	move.w	#$FEF4,Ypos(a0)
	movea.l	#SortCords+((puckscnum+1)*SCstruct),a0
	move.w	#$18A,frame(a0)
	clr.w	SPA(a0)
	clr.w	attribute(a0)
	clr.w	(SortCords+(puckscnum*SCstruct)+attribute).l
	bclr.b	#$6,(sflags).l
	moveq	#$64,d4
.loop	bsr.w	checkwindow
	dbra	d4,.loop
	move.w	#$3C,(yleader).l
	jsr	(ResetBench).l
	movea.l	#tmstruct,a2
	jsr	(setpersonel).l
	jsr	(forcepldata).l
	adda.w	#$366,a2
	jsr	(setpersonel).l
	jsr	(forcepldata).l
	jsr	(resetplstuff).l
	move.l	a3,-(sp)
	movea.l	#SortCords,a3
	moveq	#$B,d2
.loop2	move.w	#$FF10,$0(a3)
	clr.w	Ypos(a3)
	clr.w	frame(a3)
	move.w	position(a3),d1
	bmi.w	.next10
	beq.w	.next4
	moveq	#$16,d0
	cmpi.w	#$4,d1
	bne.w	.next3
	movea.l	#tmstruct,a2
	btst.b	#$6,pflags(a3)
	beq.w	.next2
	adda.w	#$366,a2
.next2	clr.w	tmtouch1(a2)
	move.b	pnum(a3),$19(a2)
	bclr.b	#$7,(sflags8).l
	st.b	tmtouch2(a2)
	st.b	tmtouch3(a2)
	bclr.b	#$3,tmflags(a2)
	moveq	#$17,d0
.next3	bsr.w	assinsert
.next4	move.w	(tmstruct+tmap).l,d4
	btst.b	#$6,pflags(a3)
	beq.w	.next5
	move.w	(awtmstruct+tmap).l,d4
.next5	neg.w	d4
	addi.w	#$6,d4
	asl.w	#$3,d4
	movea.l	#puckfaceoff2_apl,a1
	adda.w	d4,a1
	move.b	(a1,d1.w),d4
	asl.w	#$2,d4
	movea.l	#puckfaceoff2_ptab,a1
	move.w	(a1,d4.w),d0
	move.w	$2(a1,d4.w),d1
	btst.b	#$7,pflags(a3)
	bne.w	.next6
	neg.w	d0
	neg.w	d1
.next6	tst.w	position(a3)
	beq.w	.next9
	cmpi.w	#$8,d4
	bgt.w	.next8
	move.w	(fox).l,d3
	eor.w	d0,d3
	bpl.w	.next7
	move.w	(foy).l,d3
	asr.w	#$3,d3
	sub.w	d3,d1
.next7	move.w	(fox).l,d3
	asr.w	#$2,d3
	sub.w	d3,d0
.next8	add.w	(fox).l,d0
	add.w	(foy).l,d1
.next9	move.w	d0,$0(a3)
	move.w	d1,Ypos(a3)
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	sub.w	(puckx).l,d0
	sub.w	(pucky).l,d1
	neg.w	d0
	neg.w	d1
	bsr.w	vtoa
	move.w	d0,facedir(a3)
	bclr.b	#$2,pflags2(a3)
	bclr.b	#$5,pflags(a3)
	move.w	#$50C,d1
	bsr.w	SetSPA
.next10	adda.l	#$80,a3
	dbra	d2,.loop2
	jsr	(SprSort).l
	movea.l	(sp)+,a3
	bsr.w	ResetAndSelectPlayers
	move.w	(ExtraChars).l,d4
	movea.l	(FaceOffMap).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(faceoffvrcset).l
	movea.l	(FaceOffSprites).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	move.w	#$FFFF,(arenaanim).l
	btst.b	#$0,(sflags7).l
	beq.w	.next11
	move.w	(faceoffanim).l,d0
	bmi.w	.next11
	jsr	(StartArenaAnim).l
.next11	bsr.w	printz
; Inline data read by printz from the return address (1 row).
	dc.b	$00,$06,$FF,$00,$00,$00	; ......
; Picks the song for the faceoff
FaceoffSongPick	moveq	#$36,d0
	tst.w	(fox).l
	bpl.w	.next
	move.w	#$BE,d0
.next	move.w	d0,(fodropx).l
	subi.w	#$2E,d0
	asr.w	#$3,d0
	move.w	d0,(printx).l
	moveq	#$5C,d0
	move.w	d0,(fodropy).l
	subi.w	#$44,d0
	asr.w	#$3,d0
	move.w	d0,(printy).l
	move.w	(ExtraChars).l,d4
	movea.l	(FaceOffMap).l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$C,d2
	moveq	#$A,d3
	moveq	#$0,d5
	bset.b	#$0,(sflags6).l
	bsr.w	dobitmap
	bclr.b	#$0,(sflags6).l
	tst.w	(OptLine).l
	bne.w	FaceoffRandomDelay
	bsr.w	printsmallz
; Inline data read by printsmallz from the return address (1 row).
	dc.b	$00,$06,$FA,$0A,$FE,$04	; ......
	moveq	#$C,d0
	moveq	#$3,d1
	bsr.w	Framer
	move.w	(tmstruct+tmline).l,d0
	move.w	(awtmstruct+tmline).l,d1
	btst.b	#$1,(gmode).l
	bne.w	.next2
	exg.l	d0,d1
.next2	bsr.w	printsmallz
; Inline data read by printsmallz from the return address (1 row).
	dc.b	$00,$06,$FB,$01,$FA,$FE	; ......
; Prints the line list
FaceoffLineList	movea.l	#linelist,a1
	bsr.w	Fprintsmall
	addi.w	#$4,(printx).l
	move.w	d1,d0
	movea.l	#linelist,a1
	bsr.w	Fprintsmall
; Random delay ($B4 to $12B) before the faceoff
FaceoffRandomDelay	move.w	#$78,d0
	bsr.w	randomd0
	addi.w	#$B4,d0
	cmpi.w	#$0,(arenaanim).l
	beq.w	.next
	cmpi.w	#$1,(arenaanim).l
	beq.w	.next
	cmpi.w	#$5,(arenaanim).l
	beq.w	.next
	cmpi.w	#$4,(arenaanim).l
	beq.w	.next
	cmpi.w	#$2,(arenaanim).l
	bne.w	.next2
.next	cmpi.w	#$10E,d0
	bgt.w	.next2
	move.w	#$10E,d0
.next2	move.w	d0,temp1(a3)
	move.w	#$18,(palcount).l
	movea.l	#fofdata2,a0
	move.w	#$1,(a0)
	move.w	#$8000,foattr(a0)
	move.w	#$4,$4(a0)
	move.w	#$A800,$6(a0)
	move.w	#$7,$8(a0)
	move.w	#$8000,$A(a0)
	btst.b	#$1,(gmode).l
	bne.w	.next3
	eori.w	#$800,foattr(a0)
	eori.w	#$800,$6(a0)
.next3	move.w	#$FFFF,(fodir1).l
	move.w	#$FFFF,(fodir2).l
	jsr	(TeamLogoPalettesEnd).l
	bclr.b	#$6,(sflags8).l
	bne.w	.next4
	bclr.b	#$4,(sflags8).l
	beq.w	.next5
.next4	bclr.b	#$4,(sflags8).l
	move.w	(SongNum).l,-(sp)
	bsr.w	song
.next5	move.w	#$18,(palcount).l
	bset.b	#$5,(GA_COMFLAGS+1).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Counts the faceoff timer down and ends the faceoff
FaceoffTimerStep	subi.w	#$1,$40(a3)
	bpl.w	updatefaceoff
	jsr	(EndArenaAnim).l
	bra.w	Endfaceoff
; Table of 52 bytes after FaceoffTimerStep, 52 bytes: $00,$01,$02,$03,$04,$05 ...
puckfaceoff2_apl	dc.b	$00,$01,$02,$03,$04,$05,$06,$00,$00,$01,$05,$03,$04,$02,$00,$00	; ................
	dc.b	$0,$3,$5,$1,$4,$0,$0,$0
puckfaceoff2_ptab	dc.b	$0,$0,$FF,$6,$FF,$DD,$FF,$CE
	dc.b	$00,$23,$FF,$CE,$FF,$CE,$FF,$F6,$00,$00,$FF,$F1,$00,$32,$FF,$F6	; .#...........2..
	dc.b	$00,$00,$FF,$C4	; ....
ResetAndSelectPlayers						;c1playernum / c2playernum = -1, then changeplayer for each human team
	move.w	#$FFFF,(c1playernum).l
	move.w	#$FFFF,(c2playernum).l
	tst.w	(cont1team).l
	beq.w	.checkcont2
	clr.w	d4
	bsr.w	PassToJump
.checkcont2	tst.w	(cont2team).l
	beq.w	.checkcont3
	moveq	#$2,d4
	bsr.w	PassToJump
.checkcont3	tst.w	(cont3team).l
	beq.w	.checkcont4
	move.w	(cont1team).l,-(sp)
	move.w	(cont3team).l,(cont1team).l
	move.w	(c1playernum).l,-(sp)
	move.w	#$FFFF,(c1playernum).l
	clr.w	d4
	jsr	(PassToJump).l
	move.w	(c1playernum).l,(c3playernum).l
	move.w	(cont1team).l,(cont3team).l
	move.w	(sp)+,(c1playernum).l
	move.w	(sp)+,(cont1team).l
.checkcont4	tst.w	(cont4team).l
	beq.w	.exit
	move.w	(cont2team).l,-(sp)
	move.w	(cont4team).l,(cont2team).l
	move.w	(c2playernum).l,-(sp)
	move.w	#$FFFF,(c2playernum).l
	move.w	#$2,d4
	jsr	(PassToJump).l
	move.w	(c2playernum).l,(c4playernum).l
	move.w	(cont2team).l,(cont4team).l
	move.w	(sp)+,(c2playernum).l
	move.w	(sp)+,(cont2team).l
.exit	rts
updatefaceoff						;a3 = puck. Drop animation frame from temp1; at 0 erases the faceoff box
	move.w	temp1(a3),d0
	beq.w	.erase
	addi.w	#$6,d0
	lsr.w	#$3,d0
	cmpi.w	#$2,d0
	bgt.w	rtss2
	neg.w	d0
	addi.w	#$A,d0
	move.w	d0,(fofdata).l
	rts
.erase	bclr	#dffaceoff,(disflags).l
	bsr.w	printz
	String	CC_Font1Pri,$0,$0
	move.w	(fodropx).l,d0
	subi.w	#$2E,d0
	asr.w	#$3,d0
	move.w	d0,(printx).l
	moveq	#$64,d0
	move.w	(fodropy).l,d0
	subi.w	#$44,d0
	asr.w	#$3,d0
	move.w	d0,(printy).l
	moveq	#$C,d0
	moveq	#$D,d1
	move.w	#$7FF,d2
	bra.w	eraser
Endfaceoff						;drop the puck: pick the faceoff winner and send the puck off
	movea.l	#Satt,a0
	move.w	(Sattsize).l,d0
	move.w	(VSPRITES).l,d1
	jsr	(DoDMAProQueue).l
	move.w	#$2F,-(sp)
	bsr.w	sfx
	bclr	#sf2faceoff,(sflags2).l
	move.w	#$3C,(holdreset).l
	move.w	(ExtraChars).l,d4
	movea.l	(RefsMap).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	bclr	#sf2drec,(sflags2).l
	bclr	#gmclock,(gmode).l
	bclr	#pf2fight,pflags2(a3)
	clr.w	(crowdnoisedelay).l
	bset	#sf3fo,(sflags3).l
	move.w	(fodir1).l,d3
	move.w	#$800,d4
	movea.l	#EndfaceoffData,a0
	movea.l	#fofdata2,a1
	moveq	#$10,d2
	move.w	(a1),d1
	sub.b	-$1(a0,d1.w),d2
	move.w	$4(a1),d1
	add.b	-$1(a0,d1.w),d2
	moveq	#$21,d0
	bsr.w	randomd0
	cmp.b	d0,d2
	bls.w	.p1won
	adda.w	#$4,a1
.p1won	btst	#$3,foattr(a1)
	beq.w	.pos
	move.w	(fodir2).l,d3
	neg.w	d4
.pos	move.w	d3,d0
	btst	#$3,d0
	bne.w	.nojoy
	andi.w	#$7,d0
.loop	btst	#$7,(GA_COMFLAGS).l
	bne.b	.loop
	move.w	#$1B,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.loop2	btst	#$6,(GA_COMFLAGS).l
	beq.b	.loop2
	move.w	(GA_COMCMD0).l,d1
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.loop3	btst	#$6,(GA_COMFLAGS).l
	bne.b	.loop3
	bclr	#$7,(GA_COMFLAGS+1).l
	andi.w	#$3,d1
	bne.w	.nj2
.nojoy	moveq	#$5,d0
	bsr.w	randomd0
	subi.w	#$2,d0
	andi.w	#$7,d0
	tst.w	d4
	bmi.w	.nj2
	eori.w	#$4,d0
.nj2	asl.w	#$2,d0
	movea.l	#dirtab,a0
	move.w	(a0,d0.w),d1
	asl.w	#$5,d1
	move.w	d1,Xvel(a3)
	move.w	$2(a0,d0.w),d1
	asl.w	#$5,d1
	add.w	d4,d1
	move.w	d1,Yvel(a3)
	move.w	#$800,d0
	bsr.w	randomd0
	move.w	d0,Zvel(a3)
	clr.w	(puckz).l
	bclr	#pfnc,pflags(a3)
	moveq	#$18,d0
	bra.w	assreplace
; Data that follows Endfaceoff (strings, small tables)
EndfaceoffData	dc.w	$0008,$1000,$0810
	include	segacd\hockey\periodover94cd.asm
ClearOffsidesIfAllPlayers						;a2 = team struct: clear the team offsides flag once no skater is past the
	
	btst	#tmfoside,tmflags(a2)
	beq.w	rtss2
	movea.l	tmsort(a2),a0
	moveq	#$5,d1
.top	tst.w	position(a0)
	bmi.w	.next
	move.w	Ypos(a0),d0
	btst	#pfgoal,pflags(a0)
	bne.w	.next
	neg.w	d0
.next	adda.w	#$80,a0
	cmpi.w	#$58,d0
	dbgt	d1,.top
	bgt.w	rtss2
	bclr	#tmfoside,tmflags(a2)
	rts
a2offsides						;player a2 touched the puck: offsides penalty if his team is flagged and
	
	btst	#gmoffs,(gmode).l
	beq.w	rtss2
	move.w	(pucky).l,d0
	btst	#pfgoal,pflags(a2)
	bne.w	.0
	neg.w	d0
.0	cmpi.w	#$68,d0
	blt.w	rtss2
	movea.l	#tmstruct,a0
	btst	#pfteam,pflags(a2)
	beq.w	.1
	adda.w	#tmsize,a0
.1	btst	#tmfoside,tmflags(a0)
	beq.w	rtss2
	btst	#gmhl,(gmode).l
	bne.w	rtss2
	exg.l	a2,a3
	moveq	#$10,d0
	bsr.w	AddPenalty
	exg.l	a2,a3
	rts
a2touchpuck
	move.w	$0(a2),(ltx).l
	move.w	Ypos(a2),(lty).l
	move.w	SCnum(a2),(ltplayer).l
	movea.l	#tmstruct,a0
	btst	#pfteam,pflags(a2)
	beq.w	.t
	lea.l	tmsize(a0),a0
.t	clr.w	d0
	move.b	pnum(a2),d0
	btst	#pf3onetimer,pflags3(a2)
	beq.w	.checklast
	bset	#$7,(sflags8).l
.checklast	cmp.w	tmtouch1(a0),d0
	beq.w	.same
	bclr	#tmflast,tmflags(a0)
	bne.w	.st
	move.w	tmtouch2(a0),tmtouch3(a0)
	move.w	tmtouch1(a0),tmtouch2(a0)
.st	move.w	d0,tmtouch1(a0)
	cmp.w	tmtouch3(a0),d0
	bne.w	.same
	st.b	tmtouch3(a0)
.same	bclr	#sf2shot,(sflags2).l
	bsr.w	a2offsides
	btst	#ifok,(iflags).l
	beq.w	.notice
	btst	#ifcgl,(iflags).l
	beq.w	.notice
	tst.w	position(a2)
	beq.w	.notice
	btst	#ifdir,(iflags).l
	bne.w	.up
	btst	#pfgoal,pflags(a2)
	beq.w	.notice
.icing	clr.w	d0
	move.b	(icingPlayer).l,d0
	asl.w	#$7,d0
	move.l	a3,-(sp)
	movea.l	#SortCords,a3
	adda.w	d0,a3
	move.w	#$C,d0
	bsr.w	AddPenalty
	movea.l	(sp)+,a3
	rts
.up	btst	#pfgoal,pflags(a2)
	beq.w	.icing
.notice	clr.b	(iflags).l
	move.b	$53(a2),(icingPlayer).l
	move.w	(pucky).l,d0
	btst	#pfgoal,pflags(a2)
	beq.w	.0
	bset	#ifdir,(iflags).l
	neg.w	d0
.0	bmi.w	rtss2
	move.w	(tmstruct+tmap).l,d0
	sub.w	(awtmstruct+tmap).l,d0
	btst	#pfteam,pflags(a2)
	beq.w	.1
	neg.w	d0
.1	bmi.w	rtss2
	bset	#ifok,(iflags).l
	rts
PuckIChk						;check for icing of puck penalty. Called from pucknorm
	btst	#ifok,(iflags).l
	beq.w	rtss2
	btst	#ifcgl,(iflags).l
	bne.w	rtss2
	tst.w	(puckc).l
	bpl.w	rtss2
	move.w	#$108,d0
	btst	#ifdir,(iflags).l
	bne.w	.0
	neg.w	d0
	cmp.w	(pucky).l,d0
	bgt.w	.chkx
	rts
.0	cmp.w	(pucky).l,d0
	bgt.w	rtss2
.chkx	cmpi.w	#$2C,(puckx).l
	bgt.w	.set
	cmpi.w	#$FFD4,(puckx).l
	blt.w	.set
	bclr	#ifok,(iflags).l
	rts
.set	bset	#ifcgl,(iflags).l
	rts
puckunflip						;stop spinning puck. a3 = puck. Entered from
	
	cmpi.w	#$8,SPAnum(a3)
	blt.w	.k
	cmpi.w	#$18,SPAnum(a3)
	bge.w	.k
	eori.w	#$2,facedir(a3)
.k	ori.w	#$4,facedir(a3)
	clr.w	SPAnum(a3)
	st.b	SPAcnt(a3)
	rts
puckflip						;start puck spinning. a3 = puck, d0 bit 0 = flip. Called from checkgoal,
	
	andi.w	#$1,d0
	eor.w	d0,facedir(a3)
	andi.w	#$3,facedir(a3)
	st.b	SPAcnt(a3)
	move.w	#$46A,d1
	bra.w	SetSPA
puckshadow
	cmpi.w	#$18A,frame(a3)
	bne.w	.next2
	move.w	-$80(a3),$0(a3)
	move.w	-$6C(a3),Ypos(a3)
	clr.w	Zpos(a3)
	moveq	#$14,d0
	btst.b	#$7,(sflags).l
	beq.w	.next
	moveq	#$0,d0
.next	addi.w	#$1,(a3,d0.w)
	rts	
.next2	tst.w	frame(a3)
	beq.w	rtss2
	clr.w	$0(a3)
	move.w	#$12C,Ypos(a3)
	move.w	#$E,Zpos(a3)
	tst.w	-$6C(a3)
	bpl.w	.ex
	move.w	#$8000,attribute(a3)
	neg.w	Ypos(a3)
	subi.w	#$1,$18(a3)
.ex	rts	
findpc						;find puck crossing lines: calculate when puck will cross goalline (if at
	
	
	movem.l	d0-d4/a1-a2,-(sp)
	movea.l	#puckcross,a1
	move.w	#Sideline,d1
	move.w	#$108,d4
	bsr.w	.calc
	neg.w	d4
	bsr.w	.calc
	movem.l	(sp)+,d0-d4/a1-a2
	rts
.calc	move.w	d4,d0
	sub.w	(pucky).l,d0
	tst.w	(puckvy).l
	beq.w	.nocross
	move.w	d0,d2
	swap	d2
	clr.w	d2
	asr.l	#$4,d2
	divs.w	(puckvy).l,d2
	bmi.w	.nocross
	move.w	d2,pcframes(a1)
	muls.w	(puckvx).l,d0
	divs.w	(puckvy).l,d0
	bvs.w	.nocross
	add.w	(puckx).l,d0
	cmp.w	d1,d0
	blt.w	.o1
	neg.w	d0
	add.w	d1,d0
	add.w	d1,d0
	add.w	d1,d0
.o1	neg.w	d1
	cmp.w	d1,d0
	bgt.w	.o2
	neg.w	d0
	add.w	d1,d0
	add.w	d1,d0
	add.w	d1,d0
.o2	neg.w	d1
	move.w	d0,(a1)
	bra.w	.next
.nocross	move.w	#$FFFF,pcframes(a1)
.next	adda.w	#$4,a1		;next puckcross entry (the other goal line)
	rts

skateto						;a0 = extra routine for collision avoidance, d0/d1 = x/y cord to skate to,
	
	sub.b	d7,temp2(a3)
	bpl.w	.ex
	addi.b	#$C,temp2(a3)
	bsr.w	avdgoal
	movem.w	d0-d1,-(sp)
	move.w	Xvel(a3),d0
	asr.w	#$8,d0
	neg.w	d0
	add.w	(sp)+,d0
	sub.w	$0(a3),d0
	move.w	Yvel(a3),d1
	asr.w	#$8,d1
	neg.w	d1
	add.w	(sp)+,d1
	sub.w	Ypos(a3),d1
	cmpi.w	#$C,d0
	bgt.w	.vt
	cmpi.w	#$FFF4,d0
	blt.w	.vt
	cmpi.w	#$C,d1
	bgt.w	.vt
	cmpi.w	#$FFF4,d1
	blt.w	.vt
	moveq	#$9,d0
	bra.w	.nvt
.vt	bsr.w	vtoa
.nvt	jsr	(a0)
	move.b	d0,$43(a3)
	cmpi.w	#$7,d0
	ble.w	.ex
	move.w	Xvel(a3),d0
	or.w	Yvel(a3),d0
	bne.w	.ex
	move.w	(puckx).l,d0
	move.w	(pucky).l,d1
	btst	#pf2fight,(puck_pflags2).l
	beq.w	.nf
	move.w	(xc1).l,d0
	move.w	(yc1).l,d1
.nf	sub.w	$0(a3),d0
	sub.w	Ypos(a3),d1
	bsr.w	vtoa
	sub.w	facedir(a3),d0
	beq.w	.ex
	neg.w	d0
	andi.w	#$4,d0
	lsr.w	#$1,d0
	subi.w	#$1,d0
	add.w	facedir(a3),d0
	andi.w	#$7,d0
	move.w	d0,facedir(a3)
.ex	clr.w	d0
	move.b	$43(a3),d0
	bra.w	doplayeracc
avdgoal	clr.w	(deltax).l
	clr.w	(deltay).l
	tst.w	position(a3)
	beq.w	rtss2
	move.w	$0(a3),d2
	eor.w	d0,d2
	bpl.w	.chbar
	move.w	d1,d2
	sub.w	Ypos(a3),d2
	move.w	$0(a3),d3
	muls.w	d3,d2
	sub.w	d0,d3
	divs.w	d3,d2
	add.w	Ypos(a3),d2
	cmpi.w	#$121,d2
	bgt.w	.chbar
	cmpi.w	#$DB,d2
	blt.w	.next3
	move.w	#$144,d3
	cmpi.w	#$FE,d2
	bgt.w	.2
	blt.w	.1
	cmpi.w	#$FE,Ypos(a3)
	bgt.w	.2
.1	move.w	#$B8,d3
.2	sub.w	d2,d3
	move.w	d3,(deltay).l
	bra.w	.chbar
.next3	cmpi.w	#$FF25,d2
	bgt.w	.chbar
	cmpi.w	#$FEDF,d2
	blt.w	.chbar
	move.w	#$FF48,d3
	cmpi.w	#$FF02,d2
	bgt.w	.4
	blt.w	.3
	cmpi.w	#$FF02,Ypos(a3)
	bgt.w	.4
.3	move.w	#$FEBC,d3
.4	sub.w	d2,d3
	move.w	d3,(deltay).l
.chbar	move.w	d1,d3
	subi.w	#$FE,d3
	move.w	Ypos(a3),d2
	subi.w	#$FE,d2
	bsr.w	.ch1
	move.w	d1,d3
	addi.w	#$FE,d3
	move.w	Ypos(a3),d2
	addi.w	#$FE,d2
	bsr.w	.ch1
	add.w	(deltax).l,d0
	add.w	(deltay).l,d1
	rts
.ch1	move.w	d3,d4
	eor.w	d2,d4
	bpl.w	rtss2
	move.w	d0,d4
	sub.w	$0(a3),d4
	muls.w	d2,d4
	sub.w	d3,d2
	divs.w	d2,d4
	add.w	$0(a3),d4
	cmpi.w	#$50,d4
	bgt.w	rtss2
	cmpi.w	#$FFB0,d4
	blt.w	rtss2
	moveq	#$50,d3
	tst.w	d4
	bne.w	.ch2
	tst.w	$0(a3)
.ch2	bpl.w	.ch3
	neg.w	d3
.ch3	sub.w	d4,d3
	move.w	d3,(deltax).l
	rts
skatetopuckinit						;d0/d1 = puck x/y plus half the high byte of its
	
	move.b	(puckvx).l,d0
	asr.b	#$1,d0
	ext.w	d0
	add.w	(puckx).l,d0
	move.b	(puckvy).l,d1
	asr.b	#$1,d1
	ext.w	d1
	add.w	(pucky).l,d1
	rts
skatetopuck						;player a3 should skate to puck. d7 = elapse frames
	bsr.w	skatetopuckinit
	sub.b	d7,temp2(a3)
	bpl.w	.ex
	addi.b	#$A,temp2(a3)
	bsr.w	avdgoal
	movem.w	d0-d1,-(sp)
	move.l	a3,-(sp)
	bsr.w	GetHot
	neg.b	d0
	neg.b	d1
	sub.b	Xvel(a3),d0
	ext.w	d0
	add.w	(sp)+,d0
	sub.w	$0(a3),d0
	sub.b	Yvel(a3),d1
	ext.w	d1
	add.w	(sp)+,d1
	sub.w	Ypos(a3),d1
	bsr.w	vtoa
	move.b	d0,$43(a3)
	tst.w	position(a3)
	beq.w	.ex
	move.w	(puckvx).l,d0
	move.w	(puckvy).l,d1
	bsr.w	vtoa
	eori.w	#$4,d0
	cmp.w	facedir(a3),d0
	beq.w	.ex
	move.w	(puckx).l,d0
	sub.w	$0(a3),d0
	move.w	(pucky).l,d1
	sub.w	Ypos(a3),d1
	movem.w	d0-d1,-(sp)
	bsr.w	vtoa
	cmp.w	facedir(a3),d0
	movem.w	(sp)+,d0-d1
	bne.w	.ex
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmpi.l	#$384,d0
	bls.w	.ex
	cmpi.l	#$5A4,d0
	bls.w	Sweepcheck
.ex	move.b	$43(a3),d0
	bra.w	doplayeracc
assexit
	addi.w	#$1,$36(a3)
	andi.w	#$7,assnum(a3)
	bset	#pfna,pflags(a3)
	rts
; Pushes a player on the assist ring buffer ($36 index).
assinsert
	subi.w	#$1,$36(a3)
	andi.w	#$7,assnum(a3)
assreplace
	move.l	d1,-(sp)
	move.w	assnum(a3),d1
	move.b	d0,asslist(a3,d1.w)
	bset	#pfna,pflags(a3)
	move.l	(sp)+,d1
	rts
vtoa						;d0/d1 are x/y distances which are converted into direction 0-7 and
	
	movem.l	d2/a0,-(sp)
	move.w	d0,d2
	or.w	d1,d2
	beq.w	.nodir
	clr.w	d2
	tst.w	d0
	bpl.w	.0
	neg.w	d0
	bset	#$0,d2
.0	tst.w	d1
	bpl.w	.1
	neg.w	d1
	bset	#$1,d2
.1	asl.w	#$1,d1
	cmp.w	d1,d0
	bhi.w	.2
	bset	#$2,d2
.2	lsr.w	#$1,d1
	asl.w	#$1,d0
	cmp.w	d0,d1
	bhi.w	.3
	bset	#$3,d2
.3	movea.l	#vtoa_dt,a0
	clr.w	d0
	move.b	(a0,d2.w),d0
	movem.l	(sp)+,d2/a0
	rts
.nodir	moveq	#$8,d0
	movem.l	(sp)+,d2/a0
	rts
vtoa_dt						;vtoa: direction 0-7 for the 4 bit sign / slope index (cartridge vtoa .dt)
	dc.b	$1,$7,$3,$5,$0,$0,$4,$4,$2,$6,$2,$6,$1,$7,$3,$5
; Counts the hot entries of a record.
GetHot
	movem.l	a0-a1,-(sp)
	movea.l	$C(sp),a0
	clr.w	d0
	clr.w	d1
	tst.w	frame(a0)
	ble.w	.next3
	movea.l	(HotList).l,a1
	subq.l	#$2,a1
	move.w	frame(a0),d0
	add.w	d0,d0
	move.b	$1(a1,d0.w),d1
	ext.w	d1
	move.b	(a1,d0.w),d0
	ext.w	d0
	btst	#$3,attribute(a0)
	beq.w	.next
	neg.w	d0
.next	btst	#$4,attribute(a0)
	bne.w	.next2
	neg.w	d1
.next2	btst	#$7,(sflags).l
	beq.w	.next3
	exg.l	d0,d1
	neg.w	d1
.next3	movem.l	(sp)+,a0-a1
	move.l	(sp)+,(sp)
	rts
SetSPA
	cmp.w	SPA(a3),d1
	beq.w	rtss2
	clr.w	SPAnum(a3)
	move.w	d1,SPA(a3)
	st.b	SPAcnt(a3)
	rts
doplayeracc
	tst.w	position(a3)
	beq.w	goalieacc
	move.w	#$50C,d1
	btst	#$4,pflags(a3)
	beq.w	.d0
	move.w	#$A60,d1
.d0	andi.w	#$F,d0
	cmpi.w	#$7,d0
	ble.w	.d1
	cmpi.w	#$9,d0
	bne.w	.cgl
	move.w	Xvel(a3),d0
	or.w	Yvel(a3),d0
	bne.w	dostop
.cgl	btst	#$1,pflags2(a3)
	beq.w	SetSPA
	rts
.d1	movem.w	d0-d1,-(sp)
	move.w	d0,d2
	move.w	SCnum(a3),d0
	cmp.w	(puckc).l,d0
	beq.w	.clrrev
	move.w	(puckx).l,d0
	sub.w	$0(a3),d0
	move.w	Ypos(a3),d3
	move.b	(puckvy).l,d1
	ext.w	d1
	add.w	(pucky).l,d1
	sub.w	d3,d1
	btst	#pfgoal,pflags(a3)
	bne.w	.c1
	neg.w	d0
	neg.w	d1
	neg.w	d3
	eori.w	#$4,d2
.c1	btst	#$4,pflags(a3)
	bne.w	.next5
	tst.w	d3
	bpl.w	.clrrev
	cmpi.w	#$4,d2
	bne.w	.clrrev
	bsr.w	vtoa
	addi.w	#$1,d0
	andi.w	#$7,d0
	cmpi.w	#$2,d0
	bhi.w	.clrrev
	bra.w	.rev
.next5	subi.w	#$3,d2
	andi.w	#$7,d2
	cmpi.w	#$2,d2
	bhi.w	.clrrev
	bsr.w	vtoa
	addi.w	#$2,d0
	andi.w	#$7,d0
	cmpi.w	#$4,d0
	bhi.w	.clrrev
.rev	btst	#$4,pflags(a3)
	bne.w	.done
	move.w	Xvel(a3),d0
	or.w	Yvel(a3),d0
	beq.w	.setrev
	move.w	Xvel(a3),d0
	move.w	Yvel(a3),d1
	bsr.w	vtoa
	sub.w	(sp),d0
	addi.w	#$1,d0
	andi.w	#$7,d0
	cmpi.w	#$2,d0
	bhi.w	.done
.setrev	bset	#$4,pflags(a3)
	bra.w	.done
.clrrev	bclr	#$4,pflags(a3)
.done	movem.w	(sp)+,d0-d1
	move.w	facedir(a3),d2
	sub.w	d2,d0
	andi.w	#$7,d0
	movea.l	#doplayeracc_ftab,a0
	asl.w	#$1,d0
	tst.w	(a0,d0.w)
	beq.w	noturn0
	move.w	Xvel(a3),d4
	muls.w	d4,d4
	move.w	Yvel(a3),d3
	muls.w	d3,d3
	add.l	d4,d3
	swap	d3
	move.w	#$300,d4
	sub.w	d3,d4
	cmpi.w	#$180,d4
	bge.w	.iok
	move.w	#$180,d4
.iok	muls.w	(a0,d0.w),d4
	btst	#$4,pflags(a3)
	beq.w	.i0
	neg.l	d4
.i0	add.l	d4,facedir(a3)
	andi.w	#$7,facedir(a3)
	move.w	facedir(a3),d2
	cmpi.w	#$14,d3
	bls.w	.s3
	clr.w	d1
	tst.w	(a0,d0.w)
	bpl.w	.s1
	eori.w	#$FFCE,d1
.s1	btst	#$3,attribute(a3)
	beq.w	.s2
	eori.w	#$FFCE,d1
.s2	addi.w	#$694,d1
	bset	#$1,pflags2(a3)
.s3	bsr.w	SetSPA
	cmpi.w	#$2,d3
	bhi.w	noturn
	rts
doplayeracc_ftab						;doplayeracc: turn rate sign by wanted - facing (0-7), 0 = no turn (cartridge .ftab)
	dc.w	$0,$10,$10,$10,$0,$FFF0,$FFF0,$FFF0
; goalieacc: the controlled goalie case
goalieacc	btst	#$3,pflags(a3)
	beq.w	.normalgoalie
	movem.w	d0,-(sp)
	move.w	(puckc).l,d0
	cmp.w	SCnum(a3),d0
	movem.w	(sp)+,d0
	beq.w	.normalgoalie
	cmpi.w	#$30,$0(a3)
	bgt.w	.normalgoalie
	cmpi.w	#$FFD0,$0(a3)
	blt.w	.normalgoalie
	cmpi.w	#$FF40,Ypos(a3)
	bgt.w	.checkbottom
	cmpi.w	#$FEFA,Ypos(a3)
	blt.w	.normalgoalie
	bra.w	.facepuck
.checkbottom	cmpi.w	#$C0,Ypos(a3)
	blt.w	.normalgoalie
	cmpi.w	#$106,Ypos(a3)
	bgt.w	.normalgoalie
.facepuck	movem.w	d0-d1,-(sp)
	move.w	(puckx).l,d0
	sub.w	$0(a3),d0
	move.w	(pucky).l,d1
	sub.w	Ypos(a3),d1
	cmpi.w	#$10,d0
	bgt.w	.usevtoa
	cmpi.w	#$FFF0,d0
	blt.w	.usevtoa
	cmpi.w	#$10,d1
	bgt.w	.usevtoa
	cmpi.w	#$FFF0,d1
	blt.w	.usevtoa
	move.w	facedir(a3),d0
	bra.w	.checkadjust
.usevtoa	bsr.w	vtoa
.checkadjust	btst	#$0,(sflags4).l
	bne.w	.adjustkeepdir
	bsr.w	AdjustFacingDirection
	movem.w	(sp)+,d0-d1
	bra.w	.setready
.adjustkeepdir	movem.w	(sp)+,d0-d1
	cmpi.w	#$8,d0
	beq.w	.setready
	movem.w	d0-d1,-(sp)
	bsr.w	AdjustFacingDirection
	movem.w	(sp)+,d0-d1
.setready	move.w	#$2,d1
	btst	#$1,pflags2(a3)
	bne.w	.exit
	bsr.w	SetSPA
	cmpi.w	#$8,d0
	bne.w	.playermove
	tst.w	position(a3)
	bne.w	.playermove
	btst	#$3,pflags(a3)
	beq.w	.playermove
	move.w	d0,-(sp)
	move.w	Ypos(a3),d0
	btst	#$7,pflags(a3)
	beq.w	.topstay
	neg.w	d0
.topstay	cmpi.w	#$D8,d0
	blt.w	.stopandrestore
	move.w	$0(a3),d0
	cmpi.w	#$20,d0
	bgt.w	.stopandrestore
	cmpi.w	#$FFE0,d0
	blt.w	.stopandrestore
	move.w	(sp)+,d0
	jsr	(stopna2).l
	bra.w	.playermove
.stopandrestore	jsr	(stopna2).l
	move.w	(sp)+,d0
.playermove	move.w	d0,d2
	bra.w	playeracc
.normalgoalie	move.w	#$2,d1
	btst	#$3,pflags(a3)
	beq.w	.goalieacc2
	btst	#$2,pflags(a3)
	bne.w	.cgl
	cmpi.w	#$8,d0
	bne.w	.turnskater
	tst.w	position(a3)
	bne.w	.cgl
	move.w	d0,-(sp)
	move.w	Ypos(a3),d0
	btst	#$7,pflags(a3)
	beq.w	.topstop
	neg.w	d0
.topstop	cmpi.w	#$D8,d0
	blt.w	.restoreidle
	move.w	$0(a3),d0
	cmpi.w	#$20,d0
	bgt.w	.restoreidle
	cmpi.w	#$FFE0,d0
	blt.w	.restoreidle
	move.w	(sp)+,d0
	bsr.w	stopna
	bra.w	.cgl
.restoreidle	move.w	(sp)+,d0
	bra.w	.cgl
.turnskater	bra.w	.d1
.goalieacc2	andi.w	#$F,d0
	cmpi.w	#$7,d0
	ble.w	.d1
	cmpi.w	#$9,d0
	bne.w	.cgl
	move.w	Xvel(a3),d0
	or.w	Yvel(a3),d0
	beq.w	.cgl
	jmp	(stopna2).l
.cgl	btst	#$1,pflags2(a3)
	beq.w	SetSPA
.exit	rts
.d1	sub.w	facedir(a3),d0
	beq.w	.d11
	neg.w	d0
	andi.w	#$4,d0
	lsr.w	#$1,d0
	subi.w	#$1,d0
	add.w	facedir(a3),d0
	andi.w	#$7,d0
	move.w	d0,facedir(a3)
.d11	move.w	#$3D8,d1
	bsr.w	SetSPA
	move.w	facedir(a3),d2
	bra.w	playeracc
noturn0						;doplayeracc when the wanted direction needs no turn (.ftab entry 0). d0 =
	
	moveq	#$2,d4
	btst	#$4,pflags(a3)
	beq.w	.0
	addi.w	#$4,d4
	eori.w	#$8,d0
.0	tst.w	d0
	beq.w	noturn0_nochg
	move.w	Xvel(a3),d0
	move.w	Yvel(a3),d1
	bsr.w	vtoa
	btst	#$3,d0
	bne.w	.nostop
	sub.w	facedir(a3),d0
	add.w	d4,d0
	andi.w	#$7,d0
	cmpi.w	#$4,d0
	blt.w	dostop
.nostop	addi.w	#$1,$54(a3)
	btst	#$3,attribute(a3)
	beq.w	.nos0
	subi.w	#$2,$54(a3)
.nos0	andi.w	#$7,facedir(a3)
	move.w	#$50C,d1
	btst	#$4,pflags(a3)
	beq.w	SetSPA
	move.w	#$A60,d1
	bra.w	SetSPA
noturn0_nochg						;reverse the acc. direction when skating backwards, then falls into
	
	move.w	#$A92,d1
	btst	#$4,pflags(a3)
	bne.w	.next2
	move.w	#$5D0,d1
	btst	#$6,pflags2(a3)
	beq.w	.next
	move.w	#$11E6,d1
.next	move.w	(puckc).l,d4
	cmp.w	SCnum(a3),d4
	bne.w	.next2
	move.w	#$53E,d1
.next2	btst	#$1,pflags2(a3)
	bne.w	noturn
	bsr.w	SetSPA
; noturn: flag 4 swaps the direction
noturn	btst	#$4,pflags(a3)
	beq.w	playeracc
	eori.w	#$4,d2		;opposite direction
playeracc
	asl.w	#$2,d2
	lea.l	dirtab(pc),a0
	move.w	$2(a0,d2.w),d1
	move.w	(a0,d2.w),d0
	move.w	Wallsin(a3),d2
	beq.w	.nox
	eor.w	d0,d2
	bpl.w	.nox
	clr.w	d0
.nox	move.w	Wallcos(a3),d2
	beq.w	.noy
	eor.w	d1,d2
	bmi.w	.noy
	clr.w	d1
.noy	clr.w	d2
	move.b	weight(a3),d2
	lsr.w	#$2,d2
	neg.w	d2
	addi.w	#$40,d2
	add.b	legstr(a3),d2
	btst	#$1,(sflags8).l
	bne.w	.next3
	btst	#$6,(sflags7).l
	beq.w	.incaglg
.next3	addi.b	#$2,d2
	addi.b	#$2,d2
.incaglg	tst.w	position(a3)
	bne.w	.noy2
	add.b	legstr(a3),d2
	addi.w	#$10,d2
.noy2	asr.w	#$1,d2
	muls.w	d2,d0
	muls.w	d2,d1
	asr.l	#$5,d0
	asr.l	#$5,d1
	muls.w	d7,d0
	muls.w	d7,d1
	tst.w	position(a3)
	bne.w	.noy3
	btst	#pfjoycon,pflags(a3)
	beq.w	.noy3
	move.w	(puckc).l,d2
	cmp.w	SCnum(a3),d2
	bne.w	.noy3
	asr.w	#$1,d0
	asr.w	#$1,d1
.noy3	add.w	Xvel(a3),d0
	add.w	Yvel(a3),d1
	move.w	d0,d2
	move.w	d1,d3
	muls.w	d2,d2
	muls.w	d3,d3
	add.l	d2,d3
	movem.w	d0-d1,-(sp)
	bsr.w	getpde
	btst	#$4,(sflags7).l
	beq.w	.noy4
	move.w	#$1000,d0
.noy4	clr.w	d2
	move.b	legspd(a3),d2
	btst	#$1,(sflags8).l
	bne.w	.next8
	btst	#$6,(sflags7).l
	beq.w	.noy5
.next8	addi.b	#$2,d2
	cmpi.b	#$1E,d2
	ble.w	.noy5
	move.b	#$1E,d2
.noy5	move.w	d2,(TempRawSpd).l
	lsr.w	#$1,d2
	mulu.w	d0,d2
	asl.l	#$4,d2
	swap	d2
	asl.w	#$2,d2
	andi.w	#$3F,d2
	lea.l	MaxSpeed(pc),a2
	move.w	d2,(TempEnergySpd).l
	move.l	(a2,d2.w),d2
	move.l	d2,(TempMaxSpd).l
	cmpi.w	#$3C,(TempEnergySpd).l
	bge.w	.fgtinj
	btst	#$0,(TempRawSpd+1).l
	beq.w	.fgtinj
	move.w	(TempEnergySpd).l,d2
	addi.w	#$4,d2
	move.l	(a2,d2.w),d2
	sub.l	(TempMaxSpd).l,d2
	asr.l	#$1,d2
	add.l	(TempMaxSpd).l,d2
.fgtinj	btst	#$6,pflags2(a3)
	beq.w	.puckc
	lsr.l	#$3,d2
.puckc	tst.w	position(a3)
	bne.w	.noy6
	move.w	(puckc).l,d0
	cmp.w	SCnum(a3),d0
	bne.w	.noy6
	asr.l	#$1,d2
.noy6	movem.w	(sp)+,d0-d1
	cmp.l	d2,d3
	bhi.w	.sube
	move.w	d0,Xvel(a3)
	move.w	d1,Yvel(a3)
.sube	tst.w	(OptLine).l
	bne.w	rtss2
.loop	btst	#$7,(GA_COMFLAGS).l
	bne.b	.loop
	move.w	#$1B,(GA_COMSTAT0).l
	bset	#$6,(GA_COMFLAGS+1).l
.loop2	btst	#$6,(GA_COMFLAGS).l
	beq.b	.loop2
	move.w	(GA_COMCMD0).l,d0
	bset	#$7,(GA_COMFLAGS+1).l
	bclr	#$6,(GA_COMFLAGS+1).l
.loop3	btst	#$6,(GA_COMFLAGS).l
	bne.b	.loop3
	bclr	#$7,(GA_COMFLAGS+1).l
	andi.w	#$7F,d0
	bne.w	rtss2
	bsr.w	getpde
	subi.w	#$21,d0
	cmpi.w	#$C00,d0
	blt.w	setpde
	move.b	endurance(a3),d2
	ext.w	d2
	lsr.w	#$1,d2
	add.w	d2,d0
	bsr.w	setpde
	btst	#$0,endurance(a3)
	beq.w	.ex
	btst	#$0,(Vcount+1).l
	beq.w	.ex
	addi.w	#$1,d0
	bra.w	setpde
.ex	rts
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
dostop
	cmpi.w	#$1000,Xvel(a3)
	bgt.w	.set
	cmpi.w	#$F000,Xvel(a3)
	blt.w	.set
	cmpi.w	#$1000,Yvel(a3)
	bgt.w	.set
	cmpi.w	#$F000,Yvel(a3)
	blt.w	.set
	tst.w	position(a3)
	bne.w	stopna
	jmp	(stopna2).l
	bra.w	stopna
.set
	move.w	#$50C,d1
	btst	#$4,pflags(a3)
	bne.w	.0
	bset	#$1,pflags2(a3)
	move.w	#$6C6,d1
.0	bsr.w	SetSPA
	tst.w	position(a3)
	bne.w	stopna
	jmp	(stopna2).l
stopna						;slow player a3 by 150 on each axis, no animation change. Falls in from
	
	tst.w	Xvel(a3)
	bpl.w	.xp
	addi.w	#$96,Xvel(a3)
	bmi.w	.y
	clr.w	Xvel(a3)
.xp	subi.w	#$96,Xvel(a3)
	bpl.w	.y
	clr.w	Xvel(a3)
.y	tst.w	Yvel(a3)
	bpl.w	.yp
	addi.w	#$96,Yvel(a3)
	bmi.w	rtss2
	clr.w	Yvel(a3)
.yp	subi.w	#$96,Yvel(a3)
	bpl.w	rtss2
	clr.w	Yvel(a3)
	rts
; Data that follows stopna (strings, small tables)
dirtab	dc.w	$0000,$00C8,$008D,$008D,$00C8,$0000,$008D,$FF73
	dc.w	$0000,$FF38,$FF73,$FF73,$FF38,$0000,$FF73,$008D
	dc.w	$0000,$0000