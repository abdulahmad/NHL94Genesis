;	Multi-game season injuries (ported from NHL 95 injury95.asm).

SeasonMultiGameInjury	;Maybe assign multi-game injury after a game-length hurt; a0 = team struct, d1 = tmpdst offset
	movem.l	d0-d1/d7,-(sp)
	btst	#3,(GameFlags).w
	beq.w	.done
	btst	#2,(SeasonFlags).w
	beq.w	.done
	move.w	#$64,d0
	jsr	(randomd0).l
	cmp.w	#$32,d0
	blt.w	.done
	movem.w	d1,-(sp)
	clr.w	d0
	move.b	(SeasonLength).w,d0
	clr.w	d1
	move.b	(SeasonDay).w,d1
	sub.w	d1,d0
	movem.w	(sp)+,d1
	cmp.w	#2,d0
	blt.w	.done
	subq.w	#1,d0
	cmp.w	#5,d0
	ble.w	.s3
	move.w	#5,d0
.s3
	jsr	(randomd0).l
	addq.w	#1,d0
	move.w	$28(a0),d7
	move.w	(TempPlOffset).w,d1
	andi.w	#$FF,d1
	bset	#1,(sflags13).w
	jsr	(SetInjuryGames).l
.done
	movem.l	(sp)+,d0-d1/d7
	rts

SetSeasonInjuries	;Players of team a2 with injury games left (SRAM SRInjuries) are out ($FFFC)
	movem.l	d0-d3/a0/a2,-(sp)
	movea.l	#SaveRAM+2*SRInjuries,a0
	move.w	Xvel(a2),d0
	mulu.w	#$1C,d0
	adda.l	d0,a0
	lea	tmpdst(a2),a2
	move.w	#$19,d3
.loop
	move.w	(a0),d1
	andi.w	#$F0,d1
	beq.w	.1
	move.w	#$FFFC,(a2)
.1
	addq.w	#2,a2
	subq.w	#1,d3
	bmi.w	.3
	move.w	(a0),d1
	andi.w	#$F,d1
	beq.w	.2
	move.w	#$FFFC,(a2)
.2
	addq.w	#2,a2
	addq.w	#2,a0
	dbf	d3,.loop
.3
	movem.l	(sp)+,d0-d3/a0/a2
	rts

TickTeamInjuries	;A game played: one injury game off for teams d0 and d1, then save RAM checksum
	movem.l	d2-d4/a0,-(sp)
	bsr.w	TickInjuries
	move.w	d1,d0
	bsr.w	TickInjuries
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d2-d4/a0
	rts

TickInjuries	;One game off every injury of team d0 (SRAM SRInjuries, a nibble per player)
	movea.l	#SaveRAM+2*SRInjuries,a0
	mulu.w	#$1C,d0
	adda.l	d0,a0
	move.w	#$C,d2
.loop
	move.w	(a0),d3
	andi.w	#$F,d3
	beq.w	.1
	subq.w	#1,d3
	andi.w	#$F0,(a0)
	or.w	d3,(a0)
.1
	move.w	(a0),d3
	andi.w	#$F0,d3
	beq.w	.next
	subi.w	#$10,d3
	andi.w	#$F,(a0)
	or.w	d3,(a0)
.next
	addq.w	#2,a0
	dbf	d2,.loop
	rts

SetInjuryGames	;Injury games d0 for player d1 of team d7 (SRAM SRInjuries); sflags12 bit 1 and injurygames
	movem.l	d0-d7/a0-a7,-(sp)
	bset	#1,(sflags12).w
	move.w	d0,(injurygames).w
	mulu.w	#$1C,d7
	movea.l	#SaveRAM+2*SRInjuries,a0
	adda.l	d7,a0
	move.w	d1,d2
	lsr.w	#1,d2
	add.w	d2,d2
	move.w	(a0,d2.w),d3
	btst	#0,d1
	bne.w	.0
	andi.w	#$F,d3
	asl.w	#4,d0
	or.w	d0,d3
	bra.w	.1
.0
	andi.w	#$F0,d3
	or.w	d0,d3
.1
	move.w	d3,(a0,d2.w)
	movem.l	(sp)+,d0-d7/a0-a7
	rts

GetInjuryGames	;d0 = injury games of player d1 of team d7 (SRAM SRInjuries)
	movem.l	d1-d7/a0,-(sp)
	movea.l	#SaveRAM+2*SRInjuries,a0
	mulu.w	#$1C,d7
	adda.l	d7,a0
	move.w	d1,d2
	lsr.w	#1,d2
	add.w	d2,d2
	move.w	(a0,d2.w),d0
	btst	#0,d1
	bne.w	.0
	lsr.w	#4,d0
.0
	andi.w	#$F,d0
	movem.l	(sp)+,d1-d7/a0
	rts

InsertInjurySlot	;Open an injury slot at player d1 of team d7 (later nibbles up one); player traded in
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#SaveRAM+2*SRInjuries,a0
	mulu.w	#$1C,d7
	adda.l	d7,a0
	adda.l	#$18,a0
	move.w	#$19,d3
.loop
	move.w	(a0),d0
	subq.w	#2,a0
	cmp.w	d1,d3
	ble.w	.1
	asr.w	#4,d0
	andi.w	#$F,d0
.1
	subq.w	#1,d3
	bmi.w	.3
	cmp.w	d1,d3
	ble.w	.2
	move.w	(a0),d4
	asl.w	#4,d4
	andi.w	#$F0,d4
	andi.w	#$F,d0
	or.w	d4,d0
.2
	andi.w	#$FF,d0
	move.w	d0,2(a0)
	dbf	d3,.loop
.3
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DeleteInjurySlot	;Remove injury slot of player d1 of team d7 (later nibbles down one); player traded out
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#SaveRAM+2*SRInjuries,a0
	mulu.w	#$1C,d7
	adda.l	d7,a0
	move.w	#$D,d2
	clr.w	d3
.loop
	move.w	(a0)+,d0
	cmp.w	d1,d3
	blt.w	.1
	asl.w	#4,d0
.1
	subq.w	#1,d2
	bmi.w	.3
	addq.w	#1,d3
	cmp.w	d1,d3
	blt.w	.2
	move.w	(a0),d4
	asr.w	#4,d4
	andi.w	#$F,d4
	andi.w	#$F0,d0
	or.w	d4,d0
.2
	andi.w	#$FF,d0
	move.w	d0,-2(a0)
	addq.w	#1,d3
	dbf	d2,.loop
.3
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SeasonShowInjury	;Injury message when InjCntDown reached zero (period, game, or n games)
	btst	#1,(sflags12).w
	beq.w	.1
	jsr	(MakeSRAMChecksum).l
.1
	movem.l	d0-d2/a0-a4,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$B,$3,$0
	moveq	#$12,d0
	moveq	#5,d1
	jsr	(Framer).l
	btst	#1,(sflags12).w
	bne.w	.3
	btst	#5,(sflags7).w
	bne.w	.2
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$C,$4,'Injury to:',-(TXPRI+TXMAP1),$C,$6,'Out for period',-(TXPRI+TXMAP1),$C,$5,$0
	bra.w	.6
.2
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$C,$4,'Injury to:',-(TXPRI+TXMAP1),$C,$6,'Out for game',-(TXPRI+TXMAP1),$C,$5,$0
	bra.w	.6
.3
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$C,$4,'Injury to:',-(TXPRI+TXMAP1),$C,$6,'Out for '
	move.w	(injurygames).w,d0
	move.w	#1,d1
	jsr	(PushNumberWidth).l
.4
	jsr	(print).l
	cmpi.w	#1,(injurygames).w
	bgt.w	.5
	jsr	(printz).l
	String	' game',-(TXPRI+TXMAP1),$C,$5
	bra.w	.6
.5
	jsr	(printz).l
	String	' games',-(TXPRI+TXMAP1),$C,$5,$0
.6
	jsr	(GetPlayerNumInitial).l
	jsr	(print).l
	btst	#0,(puck_pflags2).w
	beq.w	.done
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$14,$6,'the game',$0
.done
	movem.l	(sp)+,d0-d2/a0-a4
	rts
