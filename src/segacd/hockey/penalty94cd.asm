AddPenalty						;add penalty d0 (Penaltylist offset) for player a3. Ignored while the
	
	
	btst	#gmclock,(gmode).l
	bne.w	rtss2
	cmpi.w	#$C,d0
	beq.w	AddPenalty2
	tst.w	(OptPen).l
	beq.w	rtss2
	btst	#$2,pflags2(a3)
	bne.w	rtss2
	btst	#gmoffs,(gmode).l
	bne.w	AddPenalty2
	cmpi.w	#$10,d0		;offsides (92 used $A)
	beq.w	rtss2
AddPenalty2						;forced penalties like face off and game over. d0 = penalty number, a3 =
	
	
	btst	#sfhor,(sflags).l
	bne.w	rtss2
	movem.l	d1/a0-a1,-(sp)
	cmpi.w	#$E,d0
	blt.w	.next2
	addi.w	#$C8,(Crowdlevel).l
	move.w	#$C,-(sp)
	btst	#pfteam,pflags(a3)
	beq.w	.song
	addi.w	#$14,(CwdExciteLvl).l
	move.w	#$B,(sp)
.song	bsr.w	sfx
.next2	movea.l	#PenBuf,a1
	moveq	#$1F,d1
.0	tst.w	(a1)+
	dbeq	d1,.0
	bne.w	.noplayer
	move.b	SCnum+1(a3),-(a1)
	move.b	d0,-(a1)
	movea.l	#Penaltylist,a0
	adda.w	(a0,d0.w),a0
	tst.b	penmins(a0)
	beq.w	.noplayer
	bmi.w	.noplayer
	btst	#pfteam,pflags(a3)
	bne.w	.away
	bset	#$1,(DelayedPen).l
	bra.w	.setpenflag
.away	bset	#$2,(DelayedPen).l
.setpenflag	bset	#pf2pen,pflags2(a3)
	beq.w	.noplayer
	clr.w	(a1)
.noplayer	movem.l	(sp)+,d1/a0-a1
	rts
PenaltyManager						;called periodically. d7 = elapsed time since last call
	bsr.w	updatepentime
	bsr.w	checkfornewpen
	bsr.w	chkprogress
	bra.w	UpdatePA
chkprogress	btst	#$2,(BA_PS_flags).l
	beq.w	.next4
	btst	#$7,(BA_PS_flags).l
	bne.w	.next3
	tst.w	(msgtimer).l
	bmi.w	.next4
	subi.w	#$1,(msgtimer).l
	bpl.w	.ex
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#$2,(sflags2).l
	bclr	#$7,(gmode2).l
	bsr.w	printz
	String	CC_Font1,$3,$2
	moveq	#$1B,d0
	moveq	#$8,d1
	btst	#$0,(gmode2).l
	beq.w	.next2
	move.w	#$C,d1
.next2	move.l	#$7FF,d2
	jsr	(eraser).l
	movem.l	(sp)+,d0-d7/a0-a6
	bra.w	.ex
.next3	jsr	(PenaltyShotBox).l
	bclr	#$7,(BA_PS_flags).l
.ex	rts
.next4	btst	#$2,(gmode).l
	beq.w	rtss2
	tst.w	(PenCntDwn).l
	bmi.w	InProgress
	sub.w	d7,(PenCntDwn).l
	bpl.w	rtss2
	bclr	#$3,(gmode).l
	movea.l	#PenBuf,a0
.loop	tst.w	(a0)+
	beq.w	rtss2
	clr.w	d0
	move.b	-$2(a0),d0
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	tst.b	penmins(a1)
	beq.w	.loop
	bmi.w	.loop
	bset	#$2,(sflags2).l
	move.w	(Vcount).l,-(sp)
	bsr.w	forceblack
	move.w	(sp)+,(Vcount).l
	bsr.w	SetHor
	move.w	(ExtraChars).l,d4
	movea.l	(RefMap2).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	bsr.w	NewTickerCheckBusy
	bsr.w	NewTicker3
	st.b	(puckc).l
	movea.l	#puckx,a3
	moveq	#$1A,d0
	bsr.w	assinsert
	move.w	#$1C20,temp1(a3)
	st.b	(RefStep).l
	clr.w	(RefCnt).l
	bsr.w	UpdatePA
	move.w	#$32,(RefCnt).l
	clr.w	d0
	bsr.w	PushRef
	move.w	#$18,(palcount).l
	rts
PenShotChk						;a3 = checker, a2 = player hit, d0 = penalty. If a2 is on a breakaway ($64
	
	
	
	
	movem.l	d1-d3/a0,-(sp)
	btst	#pf3break,pflags3(a2)
	beq.w	.loop
	btst	#$3,(BA_PS_flags).l
	beq.w	.0
.loop	move.w	#$FFFF,d1
	bra.w	.end
.0	movea.l	#PenShotPenalties,a0
	move.w	(a0,d0.w),d1
	bmi.w	.end
	move.w	SCnum(a2),d2
	movem.w	d0-d1,-(sp)
	move.w	d2,d0
	jsr	(getBAplayerInfo).l
	movem.w	(sp)+,d0-d1
	bpl.w	.found
	bclr	#$3,(BA_PS_flags).l
	bra.w	.loop
.found	move.w	d1,(pspenalty).l
	move.w	d1,d0		;return the penalty shot penalty
.end	movem.l	(sp)+,d1-d3/a0
	rts
getBAplayerInfo						;d0 = SCnum (0-5 home team, 6-11 away team) of the player on the
	
	
	
	
	movem.l	d1-d3/a1,-(sp)
	tst.w	(OptPen).l
	beq.w	.noPen
	bset	#$3,(BA_PS_flags).l
	movem.w	d0,-(sp)
	move.w	#$5,d1
	move.w	#$0,d2
	cmpi.w	#$5,d0
	bgt.w	.findgoalie
	move.w	#$B,d1
	move.w	#$1,d2
.findgoalie	move.w	d1,d0
	jsr	(getGoalieSCnum).l
	tst.w	d0
	bpl.w	.goaliein
	movem.w	(sp)+,d0
	bclr	#$3,(BA_PS_flags).l
	bra.w	.end
.goaliein	move.w	d0,d1
	move.w	(sp)+,d0
	move.w	d0,(BA_Sktr_SCnum).l
	movea.l	#SortCords,a1
	move.w	d0,d3
	asl.w	#scsize,d3
	move.w	#$0,(BA_Team).l
	btst	#pfteam,pflags(a1,d3.w)
	beq.w	.0
	move.w	#$1,(BA_Team).l
.0	move.w	#$0,(BA_Skater_Offset).l
	move.b	pnum(a1,d3.w),(BA_Skater_Offset+1).l
	move.w	d1,(BA_Goalie_SCnum).l
	asl.w	#scsize,d1
	move.w	#$0,(BA_Goalie_Offset).l
	move.b	pnum(a1,d1.w),(BA_Goalie_Offset+1).l
	move.w	#$0,(BA_Checker_Offset).l
	move.b	pnum(a3),(BA_Checker_Offset+1).l
.end	movem.l	(sp)+,d1-d3/a1
	rts
.noPen	move.w	#$FFFF,d1		;N set: no penalty shot
	bra.w	.end
InProgress						;ref in progress-- update graphics and stats and penalty information.
	
	
	
	
	
	tst.w	(RefCnt).l
	bpl.w	rtss2
	tst.w	(RefStep).l
	bpl.w	rtss2
	movem.l	d0/a0-a3,-(sp)
.loop	movea.l	#PenBuf,a0
	tst.w	(a0)+
	beq.w	.next8
.0	tst.w	(a0)+
	bne.w	.0
	suba.w	#$4,a0
	bclr	#$7,pbscnum(a0)
	bne.w	.Sa
	move.l	a3,-(sp)
	clr.w	d1
	move.b	pbscnum(a0),d1
	asl.w	#scsize,d1
	movea.l	#SortCords,a3
	adda.w	d1,a3
	tst.w	position(a3)
	movea.l	(sp)+,a3
	bpl.w	.ex
	clr.w	(a0)
	bra.w	.ex
.Sa	clr.w	d0
	move.b	(a0),d0
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	bclr	#$5,(sflags5).l
	clr.w	d2
	move.b	penmins(a1),d2
	beq.w	.sa2
	bmi.w	.sa2
	cmpi.b	#$5,d2
	bne.w	.1
	bset	#$5,(sflags5).l
.1	movem.l	d0-d1/a1-a4,-(sp)
	bsr.w	GetPeriodTimeRemaining
	movea.l	#PenSum,a4
	adda.w	(PenSumLength).l,a4
	cmpi.w	#$EC,(PenSumLength).l
	beq.w	.full
	addi.w	#$4,(PenSumLength).l
.full	move.w	d0,(a4)+
	move.b	(a0),(a4)+
	clr.w	d1
	move.b	pbscnum(a0),d1
	asl.w	#scsize,d1
	movea.l	#SortCords,a3
	adda.w	d1,a3
	clr.w	d0
	movea.l	#tmstruct,a2
	lea.l	tmsize(a2),a1
	btst	#pfteam,pflags(a3)
	beq.w	.next4
	bset	#$7,-$1(a4)
	move.w	#$8000,d0
	exg.l	a1,a2
.next4	addi.w	#$1,tmPenalties(a2)
	add.w	d2,tmPenmin(a2)
	move.b	pnum(a3),d0
	move.b	d0,(a4)
	move.w	d0,(TempPlOffset).l
	ext.w	d0
	addi.w	#$104,d0
	add.b	d2,(a2,d0.w)
	subi.w	#$104,d0
	asl.w	#$1,d0
	ext.w	d2
	mulu.w	#$3C,d2
	bset	#$D,d2
	tst.w	tmpdst(a2,d0.w)
	bmi.w	.3
	btst	#$4,tmpdst(a2,d0.w)
	beq.w	.3
	bset	#$C,d2
.3	move.w	d2,tmpdst(a2,d0.w)
	andi.w	#$EFFF,d2
	moveq	#$34,d1
.loop3	subi.w	#$2,d1
	bmi.w	.nocoin
	move.w	tmpdst(a1,d1.w),d3
	andi.w	#$EFFF,d3
	cmp.w	d3,d2
	bne.w	.loop3
	btst	#$5,(sflags5).l
	beq.w	.loop3
	bset	#$6,tmpdst(a1,d1.w)
	bset	#$6,tmpdst(a2,d0.w)
.nocoin	movem.l	a0,-(sp)
	lea.l	tmboxlist(a2),a0
	moveq	#$18,d1
.pl	tst.b	(a0)+
	dbmi	d1,.pl
	move.b	d0,-$1(a0)
	st.b	(a0)
	movem.l	(sp)+,a0
	move.w	#$C,d0
	bsr.w	assreplace
	movem.l	(sp)+,d0-d1/a1-a4
	bsr.w	SetPA
	bsr.w	USBoard
	bra.w	.ex
.sa2	clr.w	(a0)
	btst	#sfhor,(sflags).l
	bne.w	.loop
	bsr.w	SetPA
	bra.w	.ex
.next8	movea.l	#tmstruct,a2
	bsr.w	InProgress_ap
	adda.w	#tmsize,a2
	bsr.w	InProgress_ap
	bclr	#gmpen,(gmode).l
	movea.l	#puckx,a3
	bclr	#$6,(BA_PS_flags).l
	move.w	#$1B,d0
	btst	#$3,(BA_PS_flags).l
	beq.w	.5
	move.w	#$1E,d0		;puckshootout: penalty shot
.5	bsr.w	assreplace
.ex	movem.l	(sp)+,d0/a0-a3
	rts
InProgress_ap						;a2 = team. Clears tmpdst bit 5, counts players kept off the ice by
	
	
	
	moveq	#$6,d1
	moveq	#$32,d0
.loop	tst.w	tmpdst(a2,d0.w)
	ble.w	.next
	bclr	#$5,tmpdst(a2,d0.w)
	btst	#$6,tmpdst(a2,d0.w)
	bne.w	.next
	btst	#$4,tmpdst(a2,d0.w)
	bne.w	.next
	cmpi.w	#$4,d1
	beq.w	.next
	subi.w	#$1,d1
.next	subi.w	#$2,d0
	bpl.w	.loop
	move.w	d1,tmap(a2)		;tmap
	rts
checkfornewpen						;look for new penalty (entered thru addpenalty(2)). Stops play at once for
	
	
	btst	#sfhor,(sflags).l
	bne.w	rtss2
	movea.l	#PenBuf,a0
.next	tst.w	(a0)+
	beq.w	rtss2
	btst	#gmpen,(gmode).l
	bne.w	.iscalled
	clr.w	d0
	move.b	-$2(a0),d0
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	tst.b	penmins(a1)
	beq.w	.callit
	move.w	(puckc).l,d0
	bmi.w	.dc
	subi.w	#$6,d0
	move.b	-$1(a0),d1
	ext.w	d1
	subi.w	#$6,d1
	eor.w	d1,d0
	bmi.w	.dc
.callit	bsr.w	Stop4Pen
.iscalled	bset	#$7,-$1(a0)
	bne.w	.next
	clr.w	d0
	move.b	-$2(a0),d0
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	clr.w	d1
	move.b	$0(a1),d1
	asl.w	#$5,d1
	cmp.w	(PenCntDwn).l,d1
	ble.w	.next
	move.w	d1,(PenCntDwn).l
	bra.w	.next
.dc	bset	#gmpendel,(gmode).l
	bne.w	.next
	move.w	#$2C,d0
	bsr.w	SetPA
	bra.w	.next
Stop4Pen						;a0 = penaltylist penalty +2. Stop the clock, set the face off spot from
	
	
	bset	#gmclock,(gmode).l
	bne.w	.skipfo
	clr.w	d0
	clr.w	d1
	cmpi.b	#$E,-$2(a0)
	beq.w	.noticing
	move.w	(ltx).l,d0
	move.w	(lty).l,d1
	cmpi.b	#$6,-$2(a0)
	beq.w	.noticing
	move.w	(puckx).l,d0
	move.w	(pucky).l,d1
	cmpi.b	#$C,-$2(a0)
	bne.w	.noticing
	move.l	a3,-(sp)
	movea.l	#SortCords,a3
	move.b	-$1(a0),d1
	ext.w	d1
	asl.w	#scsize,d1
	adda.w	d1,a3
	move.w	#$258,d1
	btst	#pfgoal,pflags(a3)
	movea.l	(sp)+,a3
	beq.w	.noticing
	neg.w	d1
.noticing	movem.w	d0-d1,-(sp)
	cmpi.w	#$46,d0
	blt.w	.next2
	move.w	#$46,d0
.next2	cmpi.w	#$FFBA,d0
	bgt.w	.next3
	move.w	#$FFBA,d0
.next3	cmpi.w	#$A6,d1
	blt.w	.next4
	move.w	#$CE,d1
	move.w	#$46,d0
	tst.w	(sp)
	bpl.w	.next4
	neg.w	d0
.next4	cmpi.w	#$FF5A,d1
	bgt.w	.3
	move.w	#$FF32,d1
	move.w	#$46,d0
	tst.w	(sp)
	bpl.w	.3
	neg.w	d0
.3	move.w	d0,(fox).l
	move.w	d1,(foy).l
	adda.w	#$4,sp
	bsr.w	limitfo
.skipfo	clr.w	(PenCntDwn).l
	bset	#gmpen,(gmode).l
	jsr	(stop_current_song).l
	move.w	#$3,-(sp)
	bsr.w	sfx
	move.w	#$A,d0		;whistle (92 used $26)
	bra.w	SetPA

limitfo						;limit face off to 5-20 feet from walls of rink.
	
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	#PenBuf,a0
.loop	bsr.w	.lf
	adda.w	#$2,a0
	tst.w	(a0)
	bne.w	.loop
	movem.l	(sp)+,d0-d1/a0-a1
	rts
.lf	move.b	pbscnum(a0),d0
	andi.w	#$7F,d0
	asl.w	#scsize,d0
	movea.l	#SortCords,a1
	move.w	#$58,d1
	btst	#pfgoal,pflags(a1,d0.w)
	bne.w	.0
	neg.w	d1
	cmp.w	(foy).l,d1
	blt.w	rtss2
	move.w	#$FFBF,(foy).l
	bra.w	.sx
.0	cmp.w	(foy).l,d1
	bgt.w	rtss2
	move.w	#$41,(foy).l
.sx	move.w	#$46,d0
	tst.w	(fox).l
	bpl.w	.1
	neg.w	d0
.1	move.w	d0,(fox).l
	rts
UpdatePA						;animate ref in ref window. Runs ShowThreeStars for game over, and the
	
	tst.w	(RefCnt).l
	bmi.w	rtss2
	sub.w	d7,(RefCnt).l
	bpl.w	.0
	bsr.w	SetPA2
.0	cmpi.w	#$4,(RefPen).l
	bne.w	.1
	bsr.w	ShowThreeStars
.1	sub.w	d7,(penmsgtimer).l
	bpl.w	rtss2
	move.w	#$7FFF,(penmsgtimer).l
	bsr.w	ClearPenaltyMessage
	bsr.w	printz
	String	CC_Font1Pri,$11,$B
	bsr.w	GetPlayerName
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	bra.w	print
SetPA
	move.w	d0,(RefPen).l
	cmpi.w	#$2E,d0
	blt.w	.1
	rts
.1	clr.w	(RefStep).l
	bsr.w	prefmes
	cmpi.w	#$E,d0
	bne.w	.2
	bsr.w	ShowGoalBox
.2	btst	#$0,(gmode2).l
	beq.w	.0
	btst	#$3,(gmode2).l
	beq.w	.0
	jsr	(ShootoutWonBy).l
.0	move.w	#$7FFF,(penmsgtimer).l
	btst	#sfhor,(sflags).l
	beq.w	SetPA2
	move.w	#$3C,(penmsgtimer).l
SetPA2						;update animation for ref. Next frame/delay pair from the Penaltylist
	
	
	movem.l	d0-d2/a0-a1,-(sp)
	moveq	#$40,d0
	tst.w	(RefStep).l
	bmi.w	.pr
	move.w	(RefStep).l,d0
	addi.w	#$2,(RefStep).l
	move.w	(RefPen).l,d1
	movea.l	#Penaltylist,a0
	adda.w	(a0,d1.w),a0
	adda.w	#$2,a0
	adda.w	(a0),a0
	move.w	(a0,d0.w),d0
	bpl.w	.0
	neg.w	d0
	st.b	(RefStep).l
.0	clr.w	d1
	move.b	d0,d1
	asl.w	#$3,d1
	move.w	d1,(RefCnt).l
	btst	#$0,(gmode2).l
	beq.w	.1
	btst	#$3,(gmode2).l
	beq.w	.1
	move.w	d0,-(sp)
	move.w	(RefCnt).l,d0
	add.w	d0,d0
	move.w	d0,(RefCnt).l
	move.w	(sp)+,d0
.1	lsr.w	#$8,d0
.pr	bsr.w	PushRef
	movem.l	(sp)+,d0-d2/a0-a1
	rts
PushRef						;tell vblank what to display. d0 = ref frame, $40 clears the window. The
	
	movem.l	d0-d2/a0-a1,-(sp)
	cmpi.w	#$40,d0
	beq.w	.clearit
	mulu.w	#$70,d0
	movea.l	(RefsMap).l,a0
	btst	#sfhor,(sflags).l
	beq.w	.m1
	movea.l	(RefMap2).l,a0
.m1	adda.l	jimdata(a0),a0
	adda.w	#$4,a0
	adda.w	d0,a0
	movea.l	#RefRamMap,a1
	move.w	(ExtraChars).l,d2
	btst	#sfhor,(sflags).l
	bne.w	.4
	ori.w	#$8000,d2
.4	moveq	#$37,d0
.1	move.w	(a0)+,(a1)
	add.w	d2,(a1)+
	dbra	d0,.1
	bset	#sf2refref,(sflags2).l
	bra.w	.ex
.clearit	btst	#sfhor,(sflags).l
	bne.w	.cl
	movea.l	#RefRamMap,a1
	moveq	#$37,d0
.2	move.w	#$7FF,(a1)+
	dbra	d0,.2
	bset	#sf2refref,(sflags2).l
.cl	moveq	#-1,d0
	bsr.w	prefmes
.ex	movem.l	(sp)+,d0-d2/a0-a1
	rts
prefmes						;print message for penalty d0 (negative clears it). Vertical mode: framed
	
	movem.l	d0-d2/a1,-(sp)
	btst	#sfhor,(sflags).l
	bne.w	.hor
	tst.w	d0
	bpl.w	.noblank
	bsr.w	printz
	String	CC_Font1Pri,$0,$A
	moveq	#$D,d0
	moveq	#$3,d1
	move.w	#$7FF,d2
	bsr.w	eraser
	bra.w	.ex
.noblank	bsr.w	printz
	String	CC_Font1Pri,$5,$A
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	adda.w	#$2,a1
	move.w	(a1),d0
	subi.w	#$2,d0
	beq.w	.ex
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	bpl.w	.nb0
	clr.w	(printx).l
.nb0	move.w	(a1),d0
	tst.b	-$1(a1,d0.w)
	bne.w	.nb1
	subi.w	#$1,d0
.nb1	moveq	#$3,d1
	bsr.w	Framer
	subi.w	#$2,(printy).l
	addi.w	#$1,(printx).l
	bsr.w	print
	bra.w	.ex
.hor	bsr.w	ClearPenaltyMessage
	tst.w	d0
	bmi.w	.ex
	bsr.w	printz
	String	CC_Font1Pri,$11,$B
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	adda.w	#$2,a1
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	bsr.w	print
.ex	movem.l	(sp)+,d0-d2/a1
	rts
ClearPenaltyMessage						;Blank the horizontal mode penalty message line (22 spaces at x 5, y $B).
	
	bsr.w	printz
	String	CC_Font1Pri,$5,$B,'                      '
	rts
PenGoalStuff						;do this stuff after a goal. a1 = scored on team, a2 = scoring team.
	
	
	
	
	movem.l	d0-d2/a0,-(sp)
	cmpi.w	#$6,tmap(a1)
	bne.w	.1
	bsr.w	ClearPenaltyBuffer
.1	move.w	tmap(a2),d2
	cmp.w	tmap(a1),d2
	ble.w	.ex
	lea.l	tmboxlist(a1),a0
.0	clr.w	d2
	move.b	(a0)+,d2
	bmi.w	.ex
	btst	#$6,tmpdst(a1,d2.w)
	bne.w	.0
	clr.w	tmpdst(a1,d2.w)
	bsr.w	RemovePlayerFromList
	bset	#$0,(DelayedPen).l
	addi.w	#$1,tmap(a1)
	addi.w	#$1,tmPwrGoals(a2)
	bset	#tmflcc,(tmstruct+tmflags).l		;home tmflags: tmflcc
	bset	#tmflcc,(awtmstruct+tmflags).l		;visitors tmflags: tmflcc
.ex	movem.l	(sp)+,d0-d2/a0
	rts
ClearPenaltyBuffer						;Clear PenBuf. Called from clockcont and PenGoalStuff
	moveq	#$1F,d0
	movea.l	#PenBuf,a0
.loop	clr.w	(a0)+
	dbra	d0,.loop
	rts
updatepentime						;update the time remaining on all penalized players, once a second. Sets
	
	
	bclr	#sf3icetime,(sflags3).l
	btst	#gmclock,(gmode).l
	bne.w	rtss2
	sub.w	d7,(Penaltytimer).l
	bpl.w	rtss2
	addi.w	#jps,(Penaltytimer).l
	bset	#sf3icetime,(sflags3).l
	bsr.w	chkatop
	jsr	(updatePPTeamTime).l
	movea.l	#tmstruct,a2
	bsr.w	updatepentime_ut
	adda.w	#tmsize,a2		;tmsize
updatepentime_ut						;a2 = team. Walks the penalty box list (tmboxlist): the first two players
	
	
	
	lea.l	tmboxlist(a2),a0
	movea.l	#mesarea,a1
	moveq	#$2,d1
	moveq	#$2,d3
.next	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	.done
	btst	#$6,tmpdst(a2,d0.w)
	bne.w	.1
	subi.w	#$1,d1
	bmi.w	.next
	move.w	d0,(a1)+
	subi.w	#$1,$68(a2,d0.w)
	bne.w	.cont
	bsr.w	RemovePlayerFromList
.cont	bra.w	.next
.done	move.w	(mesarea).l,d0
	cmpi.w	#$1,d1
	beq.w	.0
	tst.w	d1
	bne.w	.n1
	bsr.w	.0
	bra.w	.two
.n1	cmpi.w	#$FFFF,d1
	bne.w	rtss2
.two	move.w	(TextBuffer).l,d0
.0	cmpi.w	#$5,tmpdst(a2,d0.w)
	bgt.w	rtss2
	move.w	#$1,-(sp)
	tst.w	tmpdst(a2,d0.w)
	bne.w	.snd
	bsr.w	releasepl
	move.w	#$2,(sp)
.snd	bsr.w	sfx
	rts
.1	subi.w	#$1,$68(a2,d0.w)
	btst	#$3,tmpdst(a2,d0.w)
	beq.w	.next
	btst	#$4,tmpdst(a2,d0.w)
	bne.w	updatepentime_ut_2
	move.w	#$1000,tmpdst(a2,d0.w)
	bra.w	RemovePlayerFromList
updatepentime_ut_2						;Remove the entry before a0 from a penalty box list by shifting the rest
	
	
	clr.w	tmpdst(a2,d0.w)
; Shifts the byte list down by one entry.
RemovePlayerFromList	moveq	#-1,d2
.shift	addi.w	#$1,d2
	move.b	(a0,d2.w),-$1(a0,d2.w)
	bpl.w	.shift
	suba.w	#$1,a0		;a0 = the slot that was removed
	rts
chkatop						;attack time of possession stat update. Called once a second from
	
	moveq	#$0,d1
	move.w	(pucky).l,d0
	cmpi.w	#$58,d0
	bgt.w	.1
	move.l	#tmsize,d1
	neg.w	d0
	cmpi.w	#$58,d0
	blt.w	rtss2
.1	btst	#gmdir,(gmode).l
	beq.w	.0
	eori.w	#tmsize,d1
.0	movea.l	#tmstruct,a2
	addi.w	#$1,$A(a2,d1.w)
	rts
releasepl						;player's penalty time is up so let him out (if appropriate). a2 = team,
	
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	tmsort(a2),a3
	suba.w	#$80,a3
.0	adda.w	#$80,a3
	tst.w	position(a3)
	bpl.w	.0
	move.w	d0,d3
	lsr.w	#$1,d3
	move.w	tmap(a2),d1
	addi.w	#$1,tmap(a2)
	bset	#tmflcc,(tmstruct+tmflags).l
	bset	#tmflcc,(awtmstruct+tmflags).l
	movea.l	#priolist,a0
	tst.w	tmgoalie(a2)
	bpl.w	.1
	adda.w	#$1,a0
.1	clr.w	position(a3)
	move.b	(a0,d1.w),position+1(a3)
	bsr.w	Setplass
	bsr.w	setplayer
	bset	#pf2unav,pflags2(a3)
	movem.l	(sp)+,d0-d3/a0-a3
	rts
GetLowestPen						;a2 = shorthanded team, a3 = team on the power play. Return d0 = power
	
	clr.w	d0
	clr.w	d3
	lea.l	tmboxlist(a2),a0
.getstatus	clr.w	d2
	move.b	(a0)+,d2
	bmi.w	.endoflist
	move.w	tmpdst(a2,d2.w),d2
	btst	#$E,d2
	bne.w	.getstatus
	sub.w	d3,d2
	add.w	d2,d0
	move.w	d2,d3
	bra.w	.getstatus
.endoflist	cmpi.w	#$6,tmap(a3)
	beq.w	rtss2
	sub.w	d3,d0
	lea.l	tmboxlist(a3),a0
	clr.w	d2
.getstatusopp	move.b	(a0)+,d2
	bmi.w	rtss2
	btst	#$6,tmpdst(a3,d2.w)
	bne.w	.getstatusopp
	cmp.w	tmpdst(a3,d2.w),d0
	blt.w	rtss2
	add.w	d3,d0
	rts