;	HOCKEY.BIN $104E2-$10613 (runtime $2B4E2-$2B613): chgplayer94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	chgplayer and its far thunks are the cartridge code, with a few lines changed (CD blocks).

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

Sweepcheck	equ	$312AA
setc1player	equ	$312B8
setc2player	equ	$312DC

	org	$2B4E2

;	chgplayer: the pad takes the nearest free skater, plus the far thunks
;	(swpchk, j_setc1player, j_setc2player). New in 94. The 92/93 changeplayer
;	body stays in logic94.

chgplayer							;The pad d4 takes the nearest free skater to where the puck is going (not
									;a goalie, not locked or unavailable; in a penalty shot / shootout only
									;BA_Sktr_SCnum or BA_Goalie_SCnum), or sweep checks when it is the same
									;one. Called from changeplayer
	btst.b	#6,(sflags5).l			;Check bit 6. This is never set anywhere
	bne.w	rtsChgplayer
	movem.l	d0-d6/a0-a1,-(sp)
	move.w	(puckvx).l,d0			;lead puck slightly
	asr.w	#8,d0
	add.w	(puckx).l,d0			;plus the puck X
	move.w	(puckvy).l,d1
	asr.w	#8,d1
	add.w	(pucky).l,d1			;plus the puck Y
	movem.w	d0-d1,-(sp)
	moveq	#5,d2					;6 players of the team
	move.w	d4,d3
	eori.w	#2,d3					;other controller
	moveq	#-1,d5
	movea.l	#$17480,a0				;CD: the cartridge has #(SortCords-M68K_RAM)
	movea.l	#$17FA6,a1				;CD: the cartridge has #(cont1team-M68K_RAM)
	cmpi.w	#1,(a1,d4.w)			;team 1 starts at the first struct
	beq.w	.t1
	adda.w	#$300,a0				;controller is on other team
.t1									;this controller's team
	movea.l	#$17F9E,a1				;CD: the cartridge has #(c1playernum-M68K_RAM)
.top								;each player
	tst.w	position(a0)
	ble.w	.next					;cant switch to goalie
	btst.b	#pf2unav,pflags2(a0)
	bne.w	.next					;this player is unavailable for some reason
	movem.w	d1,-(sp)
	move.w	SCnum(a0),d1
	cmp.w	(a1,d4.w),d1			;this pad's player?
	movem.w	(sp)+,d1
	beq.w	.0						;his own player: allowed even though controlled
	btst.b	#3,pflags(a0)			;is player controlled?
	bne.w	.next
.0									;this pad's player, or not controlled
	btst.b	#2,(BA_PS_flags).l		;penalty shot / shootout?
	beq.w	.1						;not a penalty shot / shootout
	movem.l	d0,-(sp)
	move.w	(BA_Sktr_SCnum).l,d0
	cmp.w	SCnum(a0),d0			;this one?
	movem.l	(sp)+,d0
	beq.w	.1						;shooter allowed
	movem.l	d0,-(sp)
	move.w	(BA_Goalie_SCnum).l,d0
	cmp.w	SCnum(a0),d0			;this one?
	movem.l	(sp)+,d0
	bne.w	.next					;only the shooter and goalie may be picked
.1									;the player may be picked
	btst.b	#pfalock,pflags(a0)
	bne.w	.next
	movem.w	(sp),d0-d1				;distance squared to the puck target
	sub.w	0(a0),d0				;Xpos
	muls.w	d0,d0
	sub.w	Ypos(a0),d1
	muls.w	d1,d1
	add.l	d1,d0					;distance squared
	cmp.l	d5,d0					;closer?
	bhi.w	.next
	move.w	SCnum(a0),d1
	cmp.w	(a1,d3.w),d1			;other pad's player?
	beq.w	.next					;the other pad has him
	move.l	d0,d5					;closest so far
	move.w	d1,d6
.next								;next player
	adda.w	#$80,a0					;size of SCstruct
	dbf	d2,.top						;loop
;CD: no cartridge twin
	adda.w	#$4,sp
	pea	(.ex).l
	cmp.w	(a1,d4.w),d6			;same player?
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
	jmp	(Sweepcheck).l
j_setc1player						;jump to the routine of the same name
	jmp	(setc1player).l
j_setc2player						;jump to the routine of the same name
	jmp	(setc2player).l
