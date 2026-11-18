;	chgplayer: the pad takes the nearest free skater, plus the far thunks
;	(swpchk, j_setc1player, j_setc2player). New in 94. The 92/93 changeplayer
;	body stays in logic94.

chgplayer							;The pad d4 takes the nearest free skater to where the puck is going (not
									;a goalie, not locked or unavailable; in a penalty shot / shootout only
									;BA_Sktr_SCnum or BA_Goalie_SCnum), or sweep checks when it is the same
									;one. Called from changeplayer
	btst	#6,(sflags5).w			;Check bit 6. This is never set anywhere
	bne.w	rtsChgplayer
	movem.l	d0-d6/a0-a1,-(sp)
	move.w	(puckvx).w,d0			;lead puck slightly
	asr.w	#8,d0
	add.w	(puckx).w,d0			;plus the puck X
	move.w	(puckvy).w,d1
	asr.w	#8,d1
	add.w	(pucky).w,d1			;plus the puck Y
	movem.w	d0-d1,-(sp)
	moveq	#5,d2					;6 players of the team
	move.w	d4,d3
	eori.w	#2,d3					;other controller
	moveq	#-1,d5
	movea.w	#(SortCords-M68K_RAM),a0
	movea.w	#(cont1team-M68K_RAM),a1
	cmpi.w	#1,0(a1,d4.w)			;team 1 starts at the first struct
	beq.w	.t1
	adda.w	#$300,a0				;controller is on other team
.t1									;this controller's team
	movea.w	#(c1playernum-M68K_RAM),a1
.top								;each player
	tst.w	position(a0)
	ble.w	.next					;cant switch to goalie
	btst	#pf2unav,pflags2(a0)
	bne.w	.next					;this player is unavailable for some reason
	movem.w	d1,-(sp)
	move.w	SCnum(a0),d1
	cmp.w	0(a1,d4.w),d1			;this pad's player?
	movem.w	(sp)+,d1
	beq.w	.0						;his own player: allowed even though controlled
	btst	#3,pflags(a0)			;is player controlled?
	bne.w	.next
.0									;this pad's player, or not controlled
	btst	#2,(BA_PS_flags).w		;penalty shot / shootout?
	beq.w	.1						;not a penalty shot / shootout
	movem.l	d0,-(sp)
	move.w	(BA_Sktr_SCnum).w,d0
	cmp.w	SCnum(a0),d0			;this one?
	movem.l	(sp)+,d0
	beq.w	.1						;shooter allowed
	movem.l	d0,-(sp)
	move.w	(BA_Goalie_SCnum).w,d0
	cmp.w	SCnum(a0),d0			;this one?
	movem.l	(sp)+,d0
	bne.w	.next					;only the shooter and goalie may be picked
.1									;the player may be picked
	btst	#pfalock,pflags(a0)
	bne.w	.next
	movem.w	(sp),d0-d1				;distance squared to the puck target
	sub.w	(a0),d0					;Xpos
	muls.w	d0,d0
	sub.w	Ypos(a0),d1
	muls.w	d1,d1
	add.l	d1,d0					;distance squared
	cmp.l	d5,d0					;closer?
	bhi.w	.next
	move.w	SCnum(a0),d1
	cmp.w	0(a1,d3.w),d1			;other pad's player?
	beq.w	.next					;the other pad has him
	move.l	d0,d5					;closest so far
	move.w	d1,d6
.next								;next player
	adda.w	#$80,a0					;size of SCstruct
	dbf	d2,.top						;loop
	addq.w	#4,sp					;drop the target point
	pea	(.ex).l
	cmp.w	0(a1,d4.w),d6			;same player?
	beq.w	swpchk					;player is same so sweep check
	move.w	d6,d0					;d0 = new player
	tst.w	d4						;controller 1?
	beq.w	j_setc1player
	bra.w	j_setc2player
.ex									;exit: restore the registers
	movem.l	(sp)+,d0-d6/a0-a1
rtsChgplayer						;shared rts
	rts
swpchk								;Sweepcheck
	jmp	Sweepcheck
j_setc1player						;jump to the routine of the same name
	jmp	setc1player
j_setc2player						;jump to the routine of the same name
	jmp	setc2player
