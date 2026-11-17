limitfo						;limit face off to 5-20 feet from walls of rink.
	
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	#$18022,a0
.loop	bsr.w	.next
	adda.w	#$2,a0
	tst.w	(a0)
	bne.w	.loop
	movem.l	(sp)+,d0-d1/a0-a1
	rts
.next	move.b	$1(a0),d0
	andi.w	#$7F,d0
	asl.w	#$7,d0
	movea.l	#$17480,a1
	move.w	#$58,d1
	btst	#$7,$62(a1,d0.w)
	bne.w	.0
	neg.w	d1
	cmp.w	$17EE4.l,d1
	blt.w	rtss2
	move.w	#$FFBF,$17EE4.l
	bra.w	.sx
.0	cmp.w	$17EE4.l,d1
	bgt.w	rtss2
	move.w	#$41,$17EE4.l
.sx	move.w	#$46,d0
	tst.w	$17EE2.l
	bpl.w	.1
	neg.w	d0
.1	move.w	d0,$17EE2.l
	rts
UpdatePA						;animate ref in ref window. Runs ShowThreeStars for game over, and the
	
	tst.w	$1806E.l
	bmi.w	rtss2
	sub.w	d7,$1806E.l
	bpl.w	.next
	bsr.w	SetPA2
.next	cmpi.w	#$4,$18072.l
	bne.w	.next2
	bsr.w	ShowThreeStars
.next2	sub.w	d7,$1806C.l
	bpl.w	rtss2
	move.w	#$7FFF,$1806C.l
	bsr.w	ClearPenaltyMessage
	bsr.w	printz
	String	CC_Font1Pri,$11,$B
	bsr.w	GetPlayerName
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	bra.w	print
SetPA
	move.w	d0,$18072.l
	cmpi.w	#$2E,d0
	blt.w	.next
	rts
.next	clr.w	$18070.l
	bsr.w	prefmes
	cmpi.w	#$E,d0
	bne.w	.next2
	bsr.w	ShowGoalBoxDraw
.next2	btst	#$0,$17F78.l
	beq.w	.next3
	btst	#$3,$17F78.l
	beq.w	.next3
	jsr	(ShootoutWonBy).l
.next3	move.w	#$7FFF,$1806C.l
	btst	#$7,$17F6A.l
	beq.w	SetPA2
	move.w	#$3C,$1806C.l
SetPA2						;update animation for ref. Next frame/delay pair from the Penaltylist
	
	
	movem.l	d0-d2/a0-a1,-(sp)
	moveq	#$40,d0
	tst.w	$18070.l
	bmi.w	.pr
	move.w	$18070.l,d0
	addi.w	#$2,$18070.l
	move.w	$18072.l,d1
	movea.l	#Penaltylist,a0
	adda.w	(a0,d1.w),a0
	adda.w	#$2,a0
	adda.w	(a0),a0
	move.w	(a0,d0.w),d0
	bpl.w	.0
	neg.w	d0
	st.b	$18070.l
.0	clr.w	d1
	move.b	d0,d1
	asl.w	#$3,d1
	move.w	d1,$1806E.l
	btst	#$0,$17F78.l
	beq.w	.1
	btst	#$3,$17F78.l
	beq.w	.1
	move.w	d0,-(sp)
	move.w	$1806E.l,d0
	add.w	d0,d0
	move.w	d0,$1806E.l
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
	movea.l	$47D1C.l,a0
	btst	#$7,$17F6A.l
	beq.w	.m1
	movea.l	$47D20.l,a0
.m1	adda.l	$4(a0),a0
	adda.w	#$4,a0
	adda.w	d0,a0
	movea.l	#$18074,a1
	move.w	$18D56.l,d2
	btst	#$7,$17F6A.l
	bne.w	.4
	ori.w	#$8000,d2
.4	moveq	#$37,d0
.1	move.w	(a0)+,(a1)
	add.w	d2,(a1)+
	dbra	d0,.1
	bset	#$1,$17F6C.l
	bra.w	.next
.clearit	btst	#$7,$17F6A.l
	bne.w	.cl
	movea.l	#$18074,a1
	moveq	#$37,d0
.2	move.w	#$7FF,(a1)+
	dbra	d0,.2
	bset	#$1,$17F6C.l
.cl	moveq	#-1,d0
	bsr.w	prefmes
.next	movem.l	(sp)+,d0-d2/a0-a1
	rts
prefmes						;print message for penalty d0 (negative clears it). Vertical mode: framed
	
	movem.l	d0-d2/a1,-(sp)
	btst	#$7,$17F6A.l
	bne.w	.hor
	tst.w	d0
	bpl.w	.noblank
	bsr.w	printz
	String	CC_Font1Pri,$0,$A
	moveq	#$D,d0
	moveq	#$3,d1
	move.w	#$7FF,d2
	bsr.w	eraser
	bra.w	.next
.noblank	bsr.w	printz
	String	CC_Font1Pri,$5,$A
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	adda.w	#$2,a1
	move.w	(a1),d0
	subi.w	#$2,d0
	beq.w	.next
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
	bra.w	.next
.hor	bsr.w	ClearPenaltyMessage
	tst.w	d0
	bmi.w	.next
	bsr.w	printz
	String	CC_Font1Pri,$11,$B
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	adda.w	#$2,a1
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	bsr.w	print
.next	movem.l	(sp)+,d0-d2/a1
	rts
ClearPenaltyMessage						;Blank the horizontal mode penalty message line (22 spaces at x 5, y $B).
	
	bsr.w	printz
	String	CC_Font1Pri,$5,$B,'                      '
	rts
PenGoalStuff						;do this stuff after a goal. a1 = scored on team, a2 = scoring team.
	
	
	
	
	movem.l	d0-d2/a0,-(sp)
	cmpi.w	#$6,$26(a1)
	bne.w	.1
	bsr.w	ClearPenaltyBuffer
.1	move.w	$26(a2),d2
	cmp.w	$26(a1),d2
	ble.w	.next
	lea.l	$9C(a1),a0
.0	clr.w	d2
	move.b	(a0)+,d2
	bmi.w	.next
	btst	#$6,$68(a1,d2.w)
	bne.w	.0
	clr.w	$68(a1,d2.w)
	bsr.w	ShiftListDown
	bset	#$0,$17F7E.l
	addi.w	#$1,$26(a1)
	addi.w	#$1,$2(a2)
	bset	#$0,$1837E.l		;home tmflags: tmflcc
	bset	#$0,$186E4.l		;visitors tmflags: tmflcc
.next	movem.l	(sp)+,d0-d2/a0
	rts
ClearPenaltyBuffer						;Clear PenBuf. Called from clockcont and PenGoalStuff
	moveq	#$1F,d0
	movea.l	#$18022,a0
.loop	clr.w	(a0)+
	dbra	d0,.loop
	rts
updatepentime						;update the time remaining on all penalized players, once a second. Sets
	
	
	bclr	#$6,$17F6E.l
	btst	#$0,$17F68.l
	bne.w	rtss2
	sub.w	d7,$18066.l
	bpl.w	rtss2
	addi.w	#$18,$18066.l
	bset	#$6,$17F6E.l
	bsr.w	chkatop
	jsr	(updatePPTeamTime).l
	movea.l	#tmstruct,a2
	bsr.w	updatepentime_ut
	adda.w	#$366,a2		;tmsize
updatepentime_ut						;a2 = team. Walks the penalty box list (tmboxlist): the first two players
	
	
	
	lea.l	$9C(a2),a0
	movea.l	#mesarea,a1
	moveq	#$2,d1
	moveq	#$2,d3
.loop	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	.done
	btst	#$6,$68(a2,d0.w)
	bne.w	.1
	subi.w	#$1,d1
	bmi.w	.loop
	move.w	d0,(a1)+
	subi.w	#$1,$68(a2,d0.w)
	bne.w	.cont
	bsr.w	ShiftListDown
.cont	bra.w	.loop
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
.0	cmpi.w	#$5,$68(a2,d0.w)
	bgt.w	rtss2
	move.w	#$1,-(sp)
	tst.w	$68(a2,d0.w)
	bne.w	.snd
	bsr.w	releasepl
	move.w	#$2,(sp)
.snd	bsr.w	sfx
	rts
.1	subi.w	#$1,$68(a2,d0.w)
	btst	#$3,$68(a2,d0.w)
	beq.w	.loop
	btst	#$4,$68(a2,d0.w)
	bne.w	RemovePlayerFromList
	move.w	#$1000,$68(a2,d0.w)
	bra.w	ShiftListDown
RemovePlayerFromList						;Remove the entry before a0 from a penalty box list by shifting the rest
	
	
	clr.w	$68(a2,d0.w)
; Shifts the byte list down by one entry.
ShiftListDown	moveq	#-1,d2
.shift	addi.w	#$1,d2
	move.b	(a0,d2.w),-$1(a0,d2.w)
	bpl.w	.shift
	suba.w	#$1,a0		;a0 = the slot that was removed
	rts
chkatop						;attack time of possession stat update. Called once a second from
	
	moveq	#$0,d1
	move.w	$17B94.l,d0
	cmpi.w	#$58,d0
	bgt.w	.1
	move.l	#$366,d1
	neg.w	d0
	cmpi.w	#$58,d0
	blt.w	rtss2
.1	btst	#$1,$17F68.l
	beq.w	.0
	eori.w	#$366,d1
.0	movea.l	#tmstruct,a2
	addi.w	#$1,$A(a2,d1.w)
	rts
releasepl						;player's penalty time is up so let him out (if appropriate). a2 = team,
	
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	$22(a2),a3
	suba.w	#$80,a3
.0	adda.w	#$80,a3
	tst.w	$34(a3)
	bpl.w	.0
	move.w	d0,d3
	lsr.w	#$1,d3
	move.w	$26(a2),d1
	addi.w	#$1,$26(a2)
	bset	#$0,$1837E.l
	bset	#$0,$186E4.l
	movea.l	#priolist,a0
	tst.w	$28(a2)
	bpl.w	.1
	adda.w	#$1,a0
.1	clr.w	$34(a3)
	move.b	(a0,d1.w),$35(a3)
	bsr.w	Setplass
	bsr.w	SetPlayerSide
	bset	#$2,$63(a3)
	movem.l	(sp)+,d0-d3/a0-a3
	rts
GetLowestPen						;a2 = shorthanded team, a3 = team on the power play. Return d0 = power
	
	clr.w	d0
	clr.w	d3
	lea.l	$9C(a2),a0
.getstatus	clr.w	d2
	move.b	(a0)+,d2
	bmi.w	.endoflist
	move.w	$68(a2,d2.w),d2
	btst	#$E,d2
	bne.w	.getstatus
	sub.w	d3,d2
	add.w	d2,d0
	move.w	d2,d3
	bra.w	.getstatus
.endoflist	cmpi.w	#$6,$26(a3)
	beq.w	rtss2
	sub.w	d3,d0
	lea.l	$9C(a3),a0
	clr.w	d2
.getstatusopp	move.b	(a0)+,d2
	bmi.w	rtss2
	btst	#$6,$68(a3,d2.w)
	bne.w	.getstatusopp
	cmp.w	$68(a3,d2.w),d0
	blt.w	rtss2
	add.w	d3,d0
	rts
checkcoll						;d2 = new x coord, d3 = new y coord, a3 = struct of object. Check wall
									;collision (around the hot spot and the end of the stick) and player
									;collisions, then move a3 in the OOlist sort order by its y. If a player
									;collision set collflag, restore the old x/y instead. Called from
									;updateplayers
	clr.w	$17EEE.l
	btst	#$7,$17F6A.l		;check if in horiz mode
	beq.w	.next		;branch if not horizontal
	exg.l	d2,d3
.next	btst	#$2,$62(a3)		;check if in no collision mode
	bne.w	.next3		;branch if no collision
	movem.l	d0-d7,-(sp)
	move.w	$0(a3),d2		;Xpos
	move.w	$14(a3),d3		;Ypos - check coll around hot spot with wall
	move.w	$4A(a3),$17CF4.l
	move.w	$4C(a3),$17CF6.l
	bsr.w	checkwallcoll
	move.w	$4E(a3),d0
	or.w	$50(a3),d0
	bne.w	.next2		;coll didnt happen
	cmpi.w	#$B,$52(a3)		;check if a3 is a player
	bgt.w	.next2		;branch if not a player
	movem.l	(sp),d0-d7
	move.l	a3,-(sp)
	bsr.w	GetHotCount
	move.w	$0(a3),d2		;Xpos
	move.w	$14(a3),d3
	add.w	d0,d2
	add.w	d1,d3		;check coll around end of stick with wall
	move.w	#$1,$17CF4.l
	move.w	#$1,$17CF6.l
	bsr.w	checkwallcoll
.next2	movem.l	(sp)+,d0-d7
	bsr.w	checkplcoll		;check coll with other players
.next3	tst.w	$17EEE.l		;now check order of sprites
	bne.w	.next6
	move.w	$52(a3),d0
	asl.w	#$1,d0		;current object number
	movea.l	#$17CA0,a0
	movea.l	#$17CC0,a1
	movea.l	#$17C80,a2
	move.w	(a0,d0.w),d1		;current objects pos in OOlist
.loop	cmpi.w	#$F,d1		;Sortobjs-1
	beq.w	.next4		;is it top sprite on screen
	clr.w	d4
	move.b	$1(a1,d1.w),d4		;next higher object number
	cmp.w	(a2,d4.w),d3		;YPos of next higher object
	ble.w	.next4
	addq.w	#$1,(a0,d0.w)
	subq.w	#$1,(a0,d4.w)
	move.b	d4,(a1,d1.w)		;next higher object into this entry
	move.b	d0,$1(a1,d1.w)		;this object into the next entry
	addq.w	#$1,d1
	bra.w	.loop
.next4	move.w	(a0,d0.w),d1		;current objects pos in OOlist
	beq.w	.next5
.loop2	clr.w	d4
	move.b	-$1(a1,d1.w),d4		;next lower object number
	cmp.w	(a2,d4.w),d3		;compare to Y pos of next lower object
	bge.w	.next5
	subq.w	#$1,(a0,d0.w)
	addq.w	#$1,(a0,d4.w)
	move.b	d4,(a1,d1.w)		;next lower object into this entry
	move.b	d0,-$1(a1,d1.w)		;this object into the previous entry
	subq.w	#$1,d1
	bne.w	.loop2
.next5	move.w	d3,(a2,d0.w)		;update Ylist
	rts
.next6	move.w	$1C(a3),$0(a3)		;move OldXpos into Xpos
	move.w	$20(a3),$14(a3)		;move OldYpos into Ypos
	rts
checkplcoll						;check collision with other players. d2/d3 = x/y cords, a3 = struct. Walk
									;up and down the OOlist from a3 and call checkcx for each object within
									;$10 in y. Called from checkcoll
	btst	#$5,$63(a3)		;no player collision?
	bne.w	.ex
	cmpi.w	#$B,$52(a3)
	bgt.w	.ex
	move.w	$52(a3),d0
	asl.w	#$1,d0		;current object number
	movea.l	#$17CA0,a0
	movea.l	#$17CC0,a1
	movea.l	#$17C80,a2
	move.w	(a0,d0.w),d1		;current objects pos in OOlist
.loop	cmpi.w	#$F,d1		;#sortobjs-1
	beq.w	.next		;it is top sprite on screen
	clr.w	d4
	move.b	$1(a1,d1.w),d4		;next higher object number
	move.w	(a2,d4.w),d5		;y pos of next higher object
	sub.w	d3,d5
	cmpi.w	#$10,d5
	bgt.w	.next		;no higher sprite coll
	bsr.w	checkcx
	addq.w	#$1,d1
	bra.w	.loop
.next	move.w	(a0,d0.w),d1
	beq.w	.ex
.loop2	clr.w	d4		;loop: lower neighbours
	move.b	-$1(a1,d1.w),d4		;next lower object number
	move.w	d3,d5
	sub.w	(a2,d4.w),d5		;y pos of next lower object
	cmpi.w	#$10,d5
	bgt.w	.ex
	bsr.w	checkcx
	subq.w	#$1,d1
	bne.w	.loop2
.ex	rts
checkcx						;d4 = obj. # * 2 for possible collision so check x range and distance for
									;collision. d2 = x, d5 = delta y, a3 = moving object. Opposing players add
									;impact and run newcheck, checkint, checkcheck and checkfight (an rts);
									;then momentum moves from a3 to a2. Called from checkplcoll
	movem.l	d0-d7/a0-a3,-(sp)
	asl.w	#$6,d4
	movea.l	#$17480,a2
	adda.w	d4,a2		;add d4 to a2. a2 now address of SCStruct-1
	btst	#$2,$62(a2)		;test pfnc pflags = no collision mode
	bne.w	.loop		;object has no collision mode on
	btst	#$5,$63(a2)		;pf2npc(pflags2) = another no collision mode
	bne.w	.loop		;exit if no collision mode on
	cmpi.w	#$B,$52(a2)		;comparing 11 with SCnum for player. Player SCnum are 0-11.
	bgt.w	.loop
	move.w	$0(a2),d0		;Xpos
	btst	#$7,$17F6A.l		;sfhor(sflags) = screen in horizontal mode
	beq.w	.next		;branch if not in horiz mode
	move.w	$14(a2),d0
.next	sub.w	d2,d0		;subtract d2 from d0
	cmpi.w	#$FFF0,d0		;compare delta Xpos to -collrad*2
	blt.w	.loop		;branch if less than
	cmpi.w	#$10,d0		;compare delta Xpos to collrad*2
	bgt.w	.loop		;branch if greater than
	muls.w	d5,d5
	muls.w	d0,d0
	add.l	d5,d0
	cmpi.l	#$100,d0		;compare d0 to (collrad*2)*(collrad*2)
	bgt.w	.loop		;branch if outside of radius
	move.w	#$0,$17EF0.l		;evalue = elasticity value
	move.b	$62(a3),d6		;move pflags into d6
	move.b	$62(a2),d0		;move pflags into d0
	eor.b	d0,d6		;xor d0 with d6
	move.w	$28(a3),d0		;Now do momentum transfer from object a3 to object a2 Xvel
	sub.w	$28(a2),d0		;subtract Xvel a2 from Xvel a3 (Vx)
	move.w	$2A(a3),d1
	sub.w	$2A(a2),d1		;subtract Yvel a2 from Yvel a3 (Vy)
	move.w	$0(a3),d2		;Xpos
	sub.w	$0(a2),d2		;subtract Xpos of a2 from Xpos of a3
	neg.w	d2
	move.w	$14(a3),d3
	sub.w	$14(a2),d3		;subtract Ypos of a2 from Ypos of a3
	neg.w	d3
	movem.w	d0-d1,-(sp)
	muls.w	d3,d1
	muls.w	d2,d0
	add.l	d0,d1
	bmi.w	.next8		;no collision if v1n < 0
	asr.l	#$4,d1
	btst	#$6,d6
	beq.w	.next7		;players are on same team
	move.w	d1,d4
	lsr.w	#$8,d4
	cmpi.w	#$5,d4
	bgt.w	.next2
	moveq	#$5,d4		;minimum impact value
.next2	add.w	d4,$32(a3)
	add.w	d4,$32(a2)
	btst	#$0,$63(a2)
	bne.w	.next3
	move.w	$52(a3),$2E(a2)		;SCnum(a3), impactp(a2) = moves a3 SCnum into past impact player for a2
.next3	btst	#$0,$63(a3)
	bne.w	.next4
	move.w	$52(a2),$2E(a3)		;SCnum(a2), impactp(a3) = moves a2 SCnum into past impact player for a3
.next4	cmpi.w	#$14,d4		;impact under 20: no check sound
	blt.w	.next6
	move.w	$17BE0.l,d0		;check sound only if one of them has the puck
	cmp.w	$52(a3),d0
	beq.w	.next5
	cmp.w	$52(a2),d0
	bne.w	.next6
.next5	bsr.w	newcheck
.next6	bsr.w	checkint		;interference, check and fight tests
	bsr.w	CheckIntBothSides
	bsr.w	setInjuryTypeExit
.next7	move.w	d1,d4
	movem.w	(sp)+,d0-d1
	tst.w	$17EEE.l		;set to -1 by holdcheck / Bcheck: no transfer
	bmi.w	.loop
	muls.w	d2,d1
	muls.w	d3,d0
	sub.l	d1,d0
	asr.l	#$4,d0
	move.w	d0,d5
	clr.w	d0
	move.b	$67(a3),d0		;wgt, m1 in calc below
	addi.w	#$8C,d0
	clr.w	d1
	move.b	$67(a2),d1		;wgt, m2 in calc below
	addi.w	#$8C,d1
	move.w	$17EF0.l,d7
	mulu.w	d1,d7
	lsr.w	#$4,d7
	add.w	d0,d1
	sub.w	d7,d0
	muls.w	d4,d0
	divs.w	d1,d0
	move.w	$17EF0.l,d1
	muls.w	d4,d1
	asr.w	#$4,d1
	add.w	d0,d1
	movem.w	d2-d3,-(sp)
	muls.w	d5,d3
	muls.w	d0,d2
	add.l	d2,d3
	asr.l	#$4,d3
	add.w	$28(a2),d3
	move.w	d3,$28(a3)
	movem.w	(sp),d2-d3
	muls.w	d5,d2
	muls.w	d0,d3
	sub.l	d2,d3
	asr.l	#$4,d3
	add.w	$2A(a2),d3
	move.w	d3,$2A(a3)
	movem.w	(sp)+,d2-d3		;Pop d2 and d3 off stack
	muls.w	d1,d2
	asr.l	#$4,d2
	add.w	d2,$28(a2)
	muls.w	d1,d3
	asr.l	#$4,d3
	add.w	d3,$2A(a2)
	st.b	$17EEE.l
.loop	movem.l	(sp)+,d0-d7/a0-a3
	rts
.next8	addq.w	#$4,sp
	bra.w	.loop
newcheck						;start a new check sound: one of 4 sounds $1C-$1F, never the last one
									;again. Called from checkcx; FallDown branches here when the player who
									;fell did not have the puck
	move.l	d0,-(sp)
	moveq	#$3,d0
	bsr.w	randomd0
	addq.w	#$1,d0		;1-3 sounds on from the last one
	add.w	$17F62.l,d0
	andi.w	#$3,d0
	move.w	d0,$17F62.l
	addi.w	#$1C,d0		;first check sound (92 used 18)
	move.w	d0,-(sp)
	bsr.w	sfx
	move.l	(sp)+,d0
	rts
checkint						;check for interference penalty. player a2 interferes with a3 or
									;vice-versa; goalie is only player who can cause an interference call.
									;Called from checkcx
	move.l	d0,-(sp)
	bsr.w	.next
	exg.l	a2,a3
	bsr.w	.next
	exg.l	a2,a3
	move.l	(sp)+,d0
	rts
.next	tst.w	$34(a2)
	bne.w	rtss2		;exits if not goalie
	btst	#$0,$17F68.l		;test gmclock(gmode). Is there play
	bne.w	rtss2		;no fall downs during celebration
	move.w	$17BE0.l,d0		;Puck carrier's SCnum
	cmp.w	$52(a3),d0		;SCnum of this struct
	beq.w	.next2		;jump if a3 carrying puck
	cmpi.w	#$19,$32(a3)		;compare $19 to impact
	ble.w	rtss2		;exit if less than or equal
.next2	cmpi.w	#$2,$32(a3)		;compare 2 to impact
	ble.w	rtss2		;exit if impact is less than 2
	exg.l	a2,a3
	bsr.w	FallDown
	exg.l	a2,a3
	cmpi.w	#$1E,$32(a2)		;compare 30 decimal to impact
	ble.w	rtss2		;exit if impact is less than 30 decimal
	btst	#$4,$63(a3)		;pf2pen(pflags2) - Check if player already committed a penalty
	bne.w	rtss2		;exit if player is already penalized
	tst.w	$34(a2)
	bne.w	rtss2		;double check to make sure player is goalie
	move.w	#$1,d0		;set d0 to team1 value
	btst	#$6,$62(a3)		;check if home or away
	beq.w	.next3		;jump if home (team1)
	move.w	#$2,d0		;set d0 to team2 value
.next3	cmp.w	$17FA6.l,d0
	beq.w	.next4
	cmp.w	$17FA8.l,d0
	bne.w	.next5		;branch if controlled by CPU
.next4	btst	#$3,$62(a3)		;pfjoycon - check if player controlled
	beq.w	rtss2		;exit if not player controlled
.next5	move.w	$14(a2),d0
	btst	#$7,$62(a2)		;pfgoal - 0 shooting bottom, 1 shooting top
	beq.w	.next6
	neg.w	d0		;negative d0 if shooting bottom
.next6	cmpi.w	#$EF,d0		;compare to Ypos. Looks like it compares to both ends of crease
	blt.w	rtss2
	cmpi.w	#$10A,d0
	bgt.w	rtss2
	move.w	$0(a2),d0		;Xpos
	cmpi.w	#$14,d0		;compare Xpos to goalpost
	bgt.w	rtss2
	cmpi.w	#$FFEC,d0		;compare Xpos to goalpost
	blt.w	rtss2
	move.w	#$28,d0
	sub.b	$73(a3),d0
	bsr.w	randomd0
	cmpi.w	#$4,d0		;d0 = RNG(28-aggres)
	bhi.w	rtss2
	btst	#$4,$17F68.l		;Check if highlight, exit if so
	bne.w	rtss2
	moveq	#$22,d0
	bra.w	AddPenalty
; Runs the check for both a3 and a2.
CheckIntBothSides	movem.l	d0-d4/a0-a3,-(sp)
	bsr.w	.next
	exg.l	a2,a3
	bsr.w	.next
	movem.l	(sp)+,d0-d4/a0-a3
	rts
.next	cmpi.w	#$C90,$58(a2)
	beq.w	holdcheck
	cmpi.w	#$1122,$58(a2)
	beq.w	holdcheck
	cmpi.w	#$B24,$58(a2)
	beq.w	Bcheck
	cmpi.w	#$C5E,$58(a3)
	bne.w	rtss2
	btst	#$0,$17F68.l
	beq.w	.next2
	move.w	#$100,$32(a3)
	move.w	#$100,$32(a2)
.next2	move.w	$0(a2),d0
	sub.w	$0(a3),d0
	move.w	$14(a2),d1
	sub.w	$14(a3),d1
	bsr.w	vtoa
	sub.w	$54(a3),d0
	andi.w	#$7,d0
	btst	#$3,$4(a3)
	beq.w	.next3
	neg.w	d0
	addi.w	#$8,d0
	andi.w	#$7,d0
.next3	asl.w	#$1,d0
	lea.l	checkagr(pc),a0
	move.w	(a0,d0.w),d1
	bset	#$5,$62(a3)
	bsr.w	SetSPA
	tst.w	$34(a2)
	beq.w	rtss2
	cmpi.w	#$14,d4
	blt.w	rtss2
	moveq	#$78,d0
	btst	#$3,$62(a3)
	beq.w	.next4
	asl.w	#$1,d0
.next4	sub.b	$67(a3),d0
	add.b	$67(a2),d0
	lsr.w	#$1,d0
	exg.l	a2,a3
	jsr	$24FB4.l
	exg.l	a2,a3
	sub.w	$32(a2),d0
	beq.w	.next5
	bmi.w	.next5
	btst	#$4,$64(a3)
	bne.w	.next5
	bsr.w	randomd0
	clr.w	$17E62.l
	move.b	$75(a3),$17E63.l
	lsr.w	$17E62.l
	cmp.b	$17E63.l,d0
	ble.w	.next5
	bsr.w	CheckAggressionScale
	cmpi.w	#$4,d0
	bhi.w	rtss2
	btst	#$4,$17F68.l
	bne.w	rtss2
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1C,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	move.b	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	andi.w	#$2,d0
	addi.w	#$16,d0
	jsr	(PenShotChk).l
	bra.w	AddPenalty
.next5	bsr.w	CheckAggressionScale
	cmpi.w	#$3,d0
	bhi.w	.next6
	btst	#$4,$17F68.l
	bne.w	.next6
.loop4	btst	#$7,$FF800E.l
	bne.b	.loop4
	move.w	#$1C,$FF8020.l
	bset	#$6,$FF800F.l
.loop5	btst	#$6,$FF800E.l
	beq.b	.loop5
	move.b	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	bne.b	.loop6
	bclr	#$7,$FF800F.l
	andi.w	#$2,d0
	addi.w	#$1A,d0
	bsr.w	PenShotChk
	bsr.w	AddPenalty
.next6	bra.w	FallDown
checkagr						;use Agression attribute and RNG to determine if there will be a penalty.
									;a3 = checking player, a2 = player being checked. d0 =
									;randomd0(((40 - Agr) / 2) * 13), doubled for a joystick player, halved
									;within $28 of the puck in x and y.
									;Then: a2 on a breakaway rolls randomd0 again, of 8 / 7 / 4 / 3 by a2's
									;distance in y from the goal line; and d0 = $7F (no penalty) while the
									;other team has a delayed penalty (DelayedPen). The callers call a penalty
									;when d0 is small. Called from CCStart, holdcheck and Bcheck
	bclr	d5,(a6)
	movep.l	d5,$C2C(a0)
	dc.w	$0C2C,$0C2C,$0BFA
	dc.w	$0BFA,$0B96
; Scales the aggression value from $73.
CheckAggressionScale
	move.w	#$28,d0
	sub.b	$73(a3),d0
	lsr.b	#$1,d0
	mulu.w	#$D,d0
	btst	#$3,$62(a3)
	beq.w	.next
	asl.w	#$1,d0
.next	move.w	$0(a3),d1
	sub.w	$17B80.l,d1
	cmpi.w	#$28,d1
	bgt.w	.next2
	cmpi.w	#$FFD8,d1
	blt.w	.next2
	move.w	$14(a3),d1
	sub.w	$17B94.l,d1
	cmpi.w	#$28,d1
	bgt.w	.next2
	cmpi.w	#$FFD8,d1
	blt.w	.next2
	asr.w	#$1,d0
.next2	bsr.w	randomd0
	btst	#$1,$64(a2)
	beq.w	.next5
	move.w	$14(a2),d1
	bpl.w	.next3
	neg.w	d1
.next3	subi.w	#$108,d1
	neg.w	d1
	move.w	#$8,d0
	cmpi.w	#$75,d1
	bgt.w	.next4
	move.w	#$7,d0
	cmpi.w	#$3A,d1
	bgt.w	.next4
	move.w	#$4,d0
	cmpi.w	#$2C,d1
	bgt.w	.next4
	move.w	#$3,d0
.next4	bsr.w	randomd0
.next5	btst	#$6,$62(a3)
	bne.w	.next6
	btst	#$2,$17F7E.l
	bne.w	.next7
	bra.w	.ex
.next6	btst	#$1,$17F7E.l
	beq.w	.ex
.next7	move.w	#$7F,d0
.ex	rts
holdcheck
	btst	#$5,$62(a3)
	bne.w	rtss2
	tst.w	$34(a3)
	beq.w	rtss2
	btst	#$0,$63(a3)
	bne.w	rtss2
	move.w	$0(a3),d0
	sub.w	$0(a2),d0
	move.w	$14(a3),d1
	sub.w	$14(a2),d1
	bsr.w	vtoa
	sub.w	$54(a2),d0
	addi.w	#$1,d0
	andi.w	#$7,d0
	cmpi.w	#$2,d0
	bhi.w	rtss2
	move.w	$17BE0.l,d0
	cmp.w	$52(a3),d0
	bne.w	.next
	bclr	#$3,$17F6A.l
.next	move.w	$28(a3),d0
	add.w	$28(a2),d0
	asr.w	#$1,d0
	move.w	d0,$28(a3)
	move.w	d0,$28(a2)
	move.w	$2A(a3),d0
	add.w	$2A(a2),d0
	asr.w	#$1,d0
	move.w	d0,$2A(a3)
	move.w	d0,$2A(a2)
	bset	#$5,$62(a3)
	move.w	#$CF4,d1
	bsr.w	SetSPA
	exg.l	a2,a3
	bset	#$5,$62(a3)
	move.w	#$CC2,d1
	cmpi.w	#$C90,$58(a3)
	beq.w	.next2
	move.w	#$1154,d1
.next2	bsr.w	SetSPA
	bsr.w	CheckAggressionScale
	cmpi.w	#$6,d0
	bhi.w	.next4
	btst	#$4,$17F68.l
	bne.w	.next4
	move.w	#$24,d0
	cmpi.w	#$CC2,$58(a3)
	beq.w	.next3
	move.w	#$1E,d0
.next3	jsr	(PenShotChk).l
	bsr.w	AddPenalty
.next4	exg.l	a2,a3
	st.b	$17EEE.l
	rts
Bcheck
	btst	#$5,$62(a3)
	bne.w	rtss2
	tst.w	$34(a3)
	beq.w	rtss2
	btst	#$0,$63(a3)
	bne.w	rtss2
	tst.w	$18C08.l
	bne.w	.next3
	btst	#$3,$62(a2)
	beq.w	.next3
	moveq	#$20,d0
	add.b	$75(a2),d0
	sub.b	$68(a3),d0
	btst	#$1,$17F7C.l
	bne.w	.next
	btst	#$6,$17F7A.l
	beq.w	.next2
.next	subi.b	#$2,d0
.next2	bsr.w	randomd0
	cmpi.w	#$18,d0
	blt.w	rtss2
.next3	move.w	$0(a3),d0
	sub.w	$0(a2),d0
	move.w	$14(a3),d1
	sub.w	$14(a2),d1
	bsr.w	vtoa
	sub.w	$54(a2),d0
	addi.w	#$1,d0
	andi.w	#$7,d0
	cmpi.w	#$2,d0
	bhi.w	rtss2
	exg.l	a2,a3
	bsr.w	FallDown
	bsr.w	CheckAggressionScale
	cmpi.w	#$4,d0
	bhi.w	.next4
	move.w	#$20,d0
	jsr	(PenShotChk).l
	bsr.w	AddPenalty
.next4	exg.l	a2,a3
	st.b	$17EEE.l
	rts
