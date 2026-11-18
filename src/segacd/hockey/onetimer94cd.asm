puckvzadj						;set puckvz for a top shelf shot from the distance to the goal line ($108)
	
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(pucky).l,d0
	bpl.w	.dist
	neg.w	d0
.dist	subi.w	#$108,d0
	bpl.w	.0
	neg.w	d0
.0	swap	d0
	andi.l	#$FFFF0000,d0
	move.w	(puckvy).l,d1
	beq.w	.x
	bpl.w	.speed
	neg.w	d1
.speed	move.w	#$11,d2
	tst.w	(PalMode).l
	beq.w	.div
	move.w	#$16,d2
.div	divu.w	d1,d0
	andi.l	#$FFFF,d0
	divu.w	d2,d0
	tst.w	d0
	bne.w	.calc
	move.w	#$1,d0
.calc	move.l	#$A0000,d1
	move.w	d0,d3
	mulu.w	d2,d0
	divu.w	d0,d1
	move.w	d2,d4
	add.w	d2,d2
	add.w	d4,d2
	mulu.w	d3,d2
	cmpi.l	#$7FFF,d2
	blt.w	.addvz
	move.w	#$7FFF,d2
.addvz	add.w	d2,d1
	tst.w	d1
	bpl.w	.setvz
	move.w	#$7FFF,d1
.setvz	move.w	d1,(puckvz).l
.x	movem.l	(sp)+,d0-d7/a0-a6
	rts
OneTimerPass						;One-timer pass: puckvz = sqrt(12 * onetimerheight), then puckvx / puckvy
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$C,d0
	move.w	(onetimerheight).l,d1
	mulu.w	d1,d0
	swap	d0
	andi.l	#$FFFF0000,d0
	jsr	(Sroot).l
	move.w	d0,(puckvz).l
	ext.l	d0
	move.w	#$3,d4
	divu.w	d4,d0
	clr.l	d1
	move.w	(onetimertargetx).l,d1
	sub.w	(puckx).l,d1
	swap	d1
	tst.w	d0
	bne.w	.setv
	move.w	#$1,d0
.setv	divs.w	d0,d1
	move.w	d1,(puckvx).l
	clr.l	d1
	move.w	(onetimertargety).l,d1
	sub.w	(pucky).l,d1
	swap	d1
	divs.w	d0,d1
	move.w	d1,(puckvy).l
	movea.l	#puckx,a3
	move.w	(puckvz).l,d0
	jsr	(puckflip).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
OneTimerTarget						;One-timer pass target for receiver a3: an offset by facing from
	
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#$2,(sflags6).l
	tst.w	position(a3)
	bne.w	.skater
	movea.l	#$22906,a0
	bra.w	.facing
.skater	move.w	Ypos(a3),d0
	btst	#pfgoal,$62(a3)
	bne.w	.near
	neg.w	d0
.near	bset	#$2,(sflags6).l
	movea.l	#$228C6,a0
	cmpi.w	#$58,d0
	blt.w	.facing
	movea.l	#$228E6,a0
	bclr	#$2,(sflags6).l
.facing	move.w	facedir(a3),d0
	btst	#pfgoal,$62(a3)
	bne.w	.offset
	addi.w	#$4,d0
	andi.w	#$7,d0
.offset	asl.w	#$2,d0
	move.w	(a0,d0.w),d1
	move.w	$2(a0,d0.w),d2
	cmpa.l	#$228E6,a0
	bne.w	.side
	move.w	Ypos(a3),d0
	bpl.w	.next5
	neg.w	d0
.next5	cmpi.w	#$8A,d0
	blt.w	.side
	move.w	$0(a3),d0
	bpl.w	.next6
	neg.w	d0
.next6	cmpi.w	#$37,d0
	bgt.w	.side
	move.w	#$103,d2
.side	btst	#pfgoal,$62(a3)
	bne.w	.rand
	neg.w	d1
	neg.w	d2
.rand	move.w	#$A,d0
	jsr	(randomd0).l
	add.w	d0,d1
	move.w	#$A,d0
	jsr	(randomd0).l
	add.w	d0,d2
	move.w	d1,(onetimertargetx).l
	tst.w	position(a3)
	beq.w	.sety
	sub.w	$0(a3),d1
	bmi.w	.left
	subi.w	#$3C,d1
	bpl.w	.sety
	neg.w	d1
	add.w	d1,(onetimertargetx).l
	bra.w	.sety
.left	addi.w	#$3C,d1
	bmi.w	.sety
	sub.w	d1,(onetimertargetx).l
.sety	move.w	d2,(onetimertargety).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
assonetimer						;Assignment $23 (asstab), player a3 shooting a one-timer: take control of
	
	
	
	ori.w	#$C2,$74(a4,d0.w)
; Instruction bytes inside assonetimer that the assembler would encode differently, kept as words (9 rows).
	dc.b	$00,$C2,$00,$74,$00,$C2,$00,$74,$00,$C2,$FF,$8C,$00,$C2,$FF,$8C	; ...t...t........
	dc.b	$00,$C2,$FF,$8C,$00,$C2,$FF,$8C,$00,$C2,$FF,$FB,$00,$AB,$FF,$FB	; ................
	dc.b	$00,$AB,$FF,$FB,$00,$AB,$FF,$FB,$00,$AB,$FF,$FB,$00,$AB,$FF,$FB	; ................
	dc.b	$00,$AB,$FF,$FB,$00,$AB,$FF,$FB,$00,$AB,$FF,$FB,$FF,$F7,$00,$32	; ...............2
	dc.b	$FF,$F7,$00,$32,$FF,$F7,$00,$32,$FF,$F7,$FF,$FB,$FF,$F7,$FF,$CE	; ...2...2........
	dc.b	$FF,$F7,$FF,$CE,$FF,$F7,$FF,$CE,$FF,$F7,$08,$AB,$00,$01,$00,$62	; ...............b
	dc.b	$67,$00,$01,$38,$08,$EB,$00,$03,$00,$64,$66,$00,$01,$2E,$08,$B9	; g..8.....df.....
	dc.b	$00,$00,$00,$01,$7E,$C6,$08,$B9,$00,$05,$00,$01,$7F,$7C,$42,$79	; ....~........|By
	dc.b	$00,$01,$7E,$C6,$42,$79,$00,$01,$7E,$BE,$50,$F9,$00,$01,$7E,$30	; ..~.By..~.P...~0
; Per-player control update for the object in a3 (player number $52, flags $62)
PlayerControlUpdate	movem.l	d0-d7/a0-a6,-(sp)
	move.w	$52(a3),d0
	move.w	d0,(onetimerplayer).l
	btst.b	#$3,$62(a3)
	bne.w	.next4
	tst.w	(inputjoy).l
	bmi.w	.next4
	beq.w	.next2
	cmpi.w	#$1,(TmpJoyPuckCarrier).l
	bne.w	.next
	move.w	(cont2team).l,-(sp)
	move.w	(c2playernum).l,-(sp)
	move.w	(cont4team).l,(cont2team).l
	move.w	(c4playernum).l,(c2playernum).l
	jsr	(setc2player).l
	move.w	(c2playernum).l,(c4playernum).l
	move.w	(cont2team).l,(cont4team).l
	move.w	(sp)+,(c2playernum).l
	move.w	(sp)+,(cont2team).l
	bra.w	.next4
.next	jsr	(setc2player).l
	bra.w	.next4
.next2	tst.w	(TmpJoyPuckCarrier).l
	bne.w	.next3
	move.w	(cont1team).l,-(sp)
	move.w	(c1playernum).l,-(sp)
	move.w	(cont3team).l,(cont1team).l
	move.w	(c3playernum).l,(c1playernum).l
	jsr	(setc1player).l
	move.w	(c1playernum).l,(c3playernum).l
	move.w	(cont1team).l,(cont3team).l
	move.w	(sp)+,(c1playernum).l
	move.w	(sp)+,(cont1team).l
	bra.w	.next4
.next3	jsr	(setc1player).l
	bra.w	.next4
.next4	move.w	d0,-(sp)
	bsr.w	PlayerPositionToScreen
	clr.w	$5A(a3)
	jsr	(SetSPA).l
	bset.b	#$5,$62(a3)
	bset.b	#$1,$63(a3)
	move.w	(sp)+,d0
	movem.l	(sp)+,d0-d7/a0-a6
	bra.w	.ex
	btst.b	#$0,(onetimerflags).l
	bne.w	.next9
	movem.w	d0-d1,-(sp)
	move.w	(puckx).l,d0
	sub.w	$0(a3),d0
	cmpi.w	#$3C,d0
	bgt.w	.next5
	cmpi.w	#$FFC4,d0
	bgt.w	.next6
.next5	move.w	(puckvx).l,d1
	eor.w	d1,d0
	bmi.w	.next6
.loop	movem.w	(sp)+,d0-d1
	bra.w	.next10
.next6	move.w	(pucky).l,d0
	sub.w	$14(a3),d0
	cmpi.w	#$3C,d0
	bgt.w	.next7
	cmpi.w	#$FFC4,d0
	bgt.w	.next8
.next7	move.w	(puckvy).l,d1
	eor.w	d1,d0
	bpl.w	.loop
.next8	movem.w	(sp)+,d0-d1
.next9	tst.w	(puckc).l
	bmi.w	.next11
.next10	bclr.b	#$7,(sflags8).l
	bra.w	.next27
.next11	btst.b	#$0,(gmode).l
	bne.w	.next27
	movem.l	d0-d1,-(sp)
	cmpi.w	#$10,$5A(a3)
	bge.w	.next20
	btst.b	#$2,(onetimerflags).l
	bne.w	.next20
	move.w	$0(a3),d0
	move.w	(puckx).l,d1
	sub.w	d1,d0
	bpl.w	.next12
	neg.w	d0
.next12	move.w	$14(a3),d1
	move.w	(pucky).l,d2
	sub.w	d2,d1
	bpl.w	.next13
	neg.w	d1
.next13	move.w	(puckvx).l,d2
	beq.w	.next14
	cmp.w	d0,d1
	ble.w	.next15
.next14	move.w	(puckvy).l,d2
	move.w	d1,d0
.next15	swap	d0
	andi.l	#$FFFF0000,d0
	tst.w	d2
	bpl.w	.next16
	neg.w	d2
.next16	move.w	#$11,d1
	tst.w	(PalMode).l
	beq.w	.next17
	move.w	#$16,d1
.next17	tst.w	d2
	bne.w	.next18
	move.w	#$1,d2
.next18	divu.w	d2,d0
	andi.l	#$FFFF,d0
	divu.w	d1,d0
	move.w	$5A(a3),d2
	lsr.w	#$2,d2
	subi.w	#$6,d2
	neg.w	d2
	asl.w	#$2,d2
	cmp.w	d2,d0
	bgt.w	.next19
	neg.w	$5A(a3)
	addi.w	#$18,$5A(a3)
	bra.w	.next23
.next19	add.w	d7,(onetimerclock).l
	bra.w	.next21
.next20	bset.b	#$2,(onetimerflags).l
	btst.b	#$1,(onetimerflags).l
	bne.w	.next21
	cmpi.w	#$18,$5A(a3)
	bne.w	.next21
	addi.w	#$30,$5C(a3)
	bset.b	#$1,(onetimerflags).l
.next21	btst.b	#$1,(onetimerflags).l
	beq.w	.next22
	cmpi.w	#$18,$5A(a3)
	ble.w	.next22
	btst.b	#$0,(onetimerflags).l
	bne.w	.next22
	movem.l	(sp)+,d0-d1
	bra.w	.next27
.next22	btst.b	#$0,(onetimerflags).l
	beq.w	.next23
	cmpi.w	#$18,$5A(a3)
	bne.w	.next23
	cmpi.w	#$1,$5C(a3)
	ble.w	.next23
	move.w	#$1,$5C(a3)
.next23	btst.b	#$1,$63(a3)
	bne.w	.next24
	movem.l	(sp)+,d0-d1
	bra.w	.next26
.next24	move.w	$5A(a3),d0
	movem.l	(sp)+,d0-d1
	btst.b	#$0,(onetimerflags).l
	beq.w	.next25
	bclr.b	#$5,$62(a3)
	bra.w	.next26
.next25	nop
.next26	btst.b	#$1,$63(a3)
	bne.w	.ex
.next27	jsr	(EndOneTimer).l
.ex	rts
; Turns the position of the object in a3 into screen coordinates and draws its marker
PlayerPositionToScreen	move.w	#$7FC,d1
	movem.w	d0-d1,-(sp)
	move.w	$0(a3),d0
	neg.w	d0
	move.w	#$108,d1
	btst.b	#$7,$62(a3)
	bne.w	.next
	neg.w	d1
.next	sub.w	$14(a3),d1
	jsr	(vtoa).l
	jsr	(CheckOneTimerFacing).l
	movem.w	(sp)+,d0-d1
	beq.w	.ex
	move.w	#$92E,d1
.ex	rts
PuckOnAttackHalf						;d0 = 1 when the puck is on the half of the goal player a3 shoots at, else
	
	movem.w	d0-d1,-(sp)
	move.w	(pucky).l,d0
	btst	#pfgoal,$62(a3)
	bne.w	.cont
	neg.w	d0
.cont	tst.w	d0
	bpl.w	.plus
	bra.w	.minus
	move.w	(passdir).l,d0			;code never used from here up to .minus (the disc keeps addi / subi here)
	addi.w	#$4,d0
	andi.w	#$7,d0
	move.w	facedir(a3),d1
	cmp.w	d0,d1
	bra.w	.plus
	beq.w	.plus
	addi.w	#$1,d1
	andi.w	#$7,d1
	cmp.w	d0,d1
	beq.w	.plus
	addi.w	#$1,d1
	andi.w	#$7,d1
	cmp.w	d0,d1
	beq.w	.plus
	subi.w	#$3,d1
	andi.w	#$7,d1
	cmp.w	d0,d1
	beq.w	.plus
	subi.w	#$1,d1
	andi.w	#$7,d1
	beq.w	.plus
.minus
	move.w	#$0,d0
	bra.w	.ex
.plus
	move.w	#$1,d0
.ex	movem.w	(sp)+,d0-d1
	rts
onetimershot						;Do the one-timer shot (doshot), credit the last two passers as the
	
	
	
	move.w	#$4,(passdir).l
	jsr	(doshot).l
	movem.l	d0/a0,-(sp)
	movea.l	#tmstruct,a0
	btst	#pfteam,$62(a3)
	beq.w	.home
	lea.l	$366(a0),a0
.home	clr.w	d0
	move.b	pnum(a3),d0
	move.w	tmtouch2(a0),tmtouch3(a0)
	move.w	tmtouch1(a0),tmtouch2(a0)
	move.w	d0,tmtouch1(a0)
	bset	#$7,(sflags8).l
	addi.w	#$96,(Crowdlevel).l
	addi.w	#$A,(CwdExciteLvl).l
	addi.w	#$1,$35E(a0)
	movem.l	(sp)+,d0/a0
	bset	#$0,(onetimerflags).l
	bset	#$1,$63(a3)
	bset	#$1,(sflags6).l
	rts
CheckOneTimerFacing						;called from setonetimeranim. it does nothing, d0 and d1 are restored at
	
	movem.w	d0-d1,-(sp)
	neg.w	d0
	addi.w	#$8,d0
	andi.w	#$7,d0
	move.w	facedir(a3),d1
	add.w	d0,d1
	andi.w	#$7,d1
	cmpi.w	#$4,d1
	bgt.w	.g0
	move.w	attribute(a3),d0
	eori.w	#$FFFF,d0
	andi.w	#$800,d0
	bra.w	.ex
.g0	move.w	attribute(a3),d0
	andi.w	#$800,d0
.ex	movem.w	(sp)+,d0-d1
	rts
	rts
; Return point of CheckOneTimerFacing.
CheckOneTimerFacingReturn
	rts