puckvzadj						;set puckvz for a top shelf shot from the distance to the goal line ($108)
	
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	$17B94.l,d0
	bpl.w	.dist
	neg.w	d0
.dist	subi.w	#$108,d0
	bpl.w	.0
	neg.w	d0
.0	swap	d0
	andi.l	#$FFFF0000,d0
	move.w	$17BAA.l,d1
	beq.w	.x
	bpl.w	.speed
	neg.w	d1
.speed	move.w	#$11,d2
	tst.w	$18C20.l
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
.setvz	move.w	d1,$17BAC.l
.x	movem.l	(sp)+,d0-d7/a0-a6
	rts
OneTimerPass						;One-timer pass: puckvz = sqrt(12 * onetimerheight), then puckvx / puckvy
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$C,d0
	move.w	$1937A.l,d1
	mulu.w	d1,d0
	swap	d0
	andi.l	#$FFFF0000,d0
	jsr	(Sroot).l
	move.w	d0,$17BAC.l
	ext.l	d0
	move.w	#$3,d4
	divu.w	d4,d0
	clr.l	d1
	move.w	$19376.l,d1
	sub.w	$17B80.l,d1
	swap	d1
	tst.w	d0
	bne.w	.setv
	move.w	#$1,d0
.setv	divs.w	d0,d1
	move.w	d1,$17BA8.l
	clr.l	d1
	move.w	$19378.l,d1
	sub.w	$17B94.l,d1
	swap	d1
	divs.w	d0,d1
	move.w	d1,$17BAA.l
	movea.l	#$17B80,a3
	move.w	$17BAC.l,d0
	jsr	(puckflip).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
OneTimerTarget						;One-timer pass target for receiver a3: an offset by facing from
	
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#$2,(sflags6).l
	tst.w	$34(a3)
	bne.w	.skater
	movea.l	#$22906,a0
	bra.w	.facing
.skater	move.w	$14(a3),d0
	btst	#$7,$62(a3)
	bne.w	.near
	neg.w	d0
.near	bset	#$2,(sflags6).l
	movea.l	#$228C6,a0
	cmpi.w	#$58,d0
	blt.w	.facing
	movea.l	#$228E6,a0
	bclr	#$2,(sflags6).l
.facing	move.w	$54(a3),d0
	btst	#$7,$62(a3)
	bne.w	.offset
	addi.w	#$4,d0
	andi.w	#$7,d0
.offset	asl.w	#$2,d0
	move.w	(a0,d0.w),d1
	move.w	$2(a0,d0.w),d2
	cmpa.l	#$228E6,a0
	bne.w	.side
	move.w	$14(a3),d0
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
.side	btst	#$7,$62(a3)
	bne.w	.rand
	neg.w	d1
	neg.w	d2
.rand	move.w	#$A,d0
	jsr	(randomd0).l
	add.w	d0,d1
	move.w	#$A,d0
	jsr	(randomd0).l
	add.w	d0,d2
	move.w	d1,$19376.l
	tst.w	$34(a3)
	beq.w	.sety
	sub.w	$0(a3),d1
	bmi.w	.left
	subi.w	#$3C,d1
	bpl.w	.sety
	neg.w	d1
	add.w	d1,$19376.l
	bra.w	.sety
.left	addi.w	#$3C,d1
	bmi.w	.sety
	sub.w	d1,$19376.l
.sety	move.w	d2,$19378.l
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
	move.w	d0,$17EBC.l
	btst.b	#$3,$62(a3)
	bne.w	.next4
	tst.w	$1AD7A.l
	bmi.w	.next4
	beq.w	.next2
	cmpi.w	#$1,$1AD7C.l
	bne.w	.next
	move.w	$17FA8.l,-(sp)
	move.w	$17FA0.l,-(sp)
	move.w	$17FAC.l,$17FA8.l
	move.w	$17FA4.l,$17FA0.l
	jsr	(setc2player).l
	move.w	$17FA0.l,$17FA4.l
	move.w	$17FA8.l,$17FAC.l
	move.w	(sp)+,$17FA0.l
	move.w	(sp)+,$17FA8.l
	bra.w	.next4
.next	jsr	(setc2player).l
	bra.w	.next4
.next2	tst.w	$1AD7C.l
	bne.w	.next3
	move.w	$17FA6.l,-(sp)
	move.w	$17F9E.l,-(sp)
	move.w	$17FAA.l,$17FA6.l
	move.w	$17FA2.l,$17F9E.l
	jsr	(setc1player).l
	move.w	$17F9E.l,$17FA2.l
	move.w	$17FA6.l,$17FAA.l
	move.w	(sp)+,$17F9E.l
	move.w	(sp)+,$17FA6.l
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
	btst.b	#$0,$17EC6.l
	bne.w	.next9
	movem.w	d0-d1,-(sp)
	move.w	$17B80.l,d0
	sub.w	$0(a3),d0
	cmpi.w	#$3C,d0
	bgt.w	.next5
	cmpi.w	#$FFC4,d0
	bgt.w	.next6
.next5	move.w	$17BA8.l,d1
	eor.w	d1,d0
	bmi.w	.next6
.loop	movem.w	(sp)+,d0-d1
	bra.w	.next10
.next6	move.w	$17B94.l,d0
	sub.w	$14(a3),d0
	cmpi.w	#$3C,d0
	bgt.w	.next7
	cmpi.w	#$FFC4,d0
	bgt.w	.next8
.next7	move.w	$17BAA.l,d1
	eor.w	d1,d0
	bpl.w	.loop
.next8	movem.w	(sp)+,d0-d1
.next9	tst.w	$17BE0.l
	bmi.w	.next11
.next10	bclr.b	#$7,$17F7C.l
	bra.w	.next27
.next11	btst.b	#$0,$17F68.l
	bne.w	.next27
	movem.l	d0-d1,-(sp)
	cmpi.w	#$10,$5A(a3)
	bge.w	.next20
	btst.b	#$2,$17EC6.l
	bne.w	.next20
	move.w	$0(a3),d0
	move.w	$17B80.l,d1
	sub.w	d1,d0
	bpl.w	.next12
	neg.w	d0
.next12	move.w	$14(a3),d1
	move.w	$17B94.l,d2
	sub.w	d2,d1
	bpl.w	.next13
	neg.w	d1
.next13	move.w	$17BA8.l,d2
	beq.w	.next14
	cmp.w	d0,d1
	ble.w	.next15
.next14	move.w	$17BAA.l,d2
	move.w	d1,d0
.next15	swap	d0
	andi.l	#$FFFF0000,d0
	tst.w	d2
	bpl.w	.next16
	neg.w	d2
.next16	move.w	#$11,d1
	tst.w	$18C20.l
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
.next19	add.w	d7,$17EBE.l
	bra.w	.next21
.next20	bset.b	#$2,$17EC6.l
	btst.b	#$1,$17EC6.l
	bne.w	.next21
	cmpi.w	#$18,$5A(a3)
	bne.w	.next21
	addi.w	#$30,$5C(a3)
	bset.b	#$1,$17EC6.l
.next21	btst.b	#$1,$17EC6.l
	beq.w	.next22
	cmpi.w	#$18,$5A(a3)
	ble.w	.next22
	btst.b	#$0,$17EC6.l
	bne.w	.next22
	movem.l	(sp)+,d0-d1
	bra.w	.next27
.next22	btst.b	#$0,$17EC6.l
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
	btst.b	#$0,$17EC6.l
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
	move.w	$17B94.l,d0
	btst	#$7,$62(a3)
	bne.w	.cont
	neg.w	d0
.cont	tst.w	d0
	bpl.w	.plus
	bra.w	.minus
; Code kept as words after PuckOnAttackHalf (the 82 bytes are decoded in the row comments).
	dc.w	$3039,$0001,$7E2C,$0640,$0004,$0240,$0007,$322B		; move.w $17e2c.l, d0 / addi.w #$4, d0 / andi.w #$7, d0 / move.w $54(a3), d1
	dc.w	$0054,$B240,$6000,$0044,$6700,$0040,$0641,$0001		; cmp.w d0, d1 / bra.w *+70 / beq.w *+66 / addi.w #$1, d1
	dc.w	$0241,$0007,$B240,$6700,$0032,$0641,$0001,$0241		; andi.w #$7, d1 / cmp.w d0, d1 / beq.w *+52 / addi.w #$1, d1 / andi.w #$7, d1
	dc.w	$0007,$B240,$6700,$0024,$0441,$0003,$0241,$0007		; cmp.w d0, d1 / beq.w *+38 / subi.w #$3, d1 / andi.w #$7, d1
	dc.w	$B240,$6700,$0016,$0441,$0001,$0241,$0007,$6700		; cmp.w d0, d1 / beq.w *+24 / subi.w #$1, d1 / andi.w #$7, d1 / beq.w *+12
	dc.w	$000A
.minus
	move.w	#$0,d0
	bra.w	.ex
.plus
	move.w	#$1,d0
.ex	movem.w	(sp)+,d0-d1
	rts
onetimershot						;Do the one-timer shot (doshot), credit the last two passers as the
	
	
	
	move.w	#$4,$17E2C.l
	jsr	(doshot).l
	movem.l	d0/a0,-(sp)
	movea.l	#tmstruct,a0
	btst	#$6,$62(a3)
	beq.w	.home
	lea.l	$366(a0),a0
.home	clr.w	d0
	move.b	$66(a3),d0
	move.w	$1A(a0),$1C(a0)
	move.w	$18(a0),$1A(a0)
	move.w	d0,$18(a0)
	bset	#$7,$17F7C.l
	addi.w	#$96,(Crowdlevel).l
	addi.w	#$A,$17CD8.l
	addi.w	#$1,$35E(a0)
	movem.l	(sp)+,d0/a0
	bset	#$0,$17EC6.l
	bset	#$1,$63(a3)
	bset	#$1,(sflags6).l
	rts
CheckOneTimerFacing						;called from setonetimeranim. it does nothing, d0 and d1 are restored at
	
	movem.w	d0-d1,-(sp)
	neg.w	d0
	addi.w	#$8,d0
	andi.w	#$7,d0
	move.w	$54(a3),d1
	add.w	d0,d1
	andi.w	#$7,d1
	cmpi.w	#$4,d1
	bgt.w	.g0
	move.w	$4(a3),d0
	eori.w	#$FFFF,d0
	andi.w	#$800,d0
	bra.w	.ex
.g0	move.w	$4(a3),d0
	andi.w	#$800,d0
.ex	movem.w	(sp)+,d0-d1
	rts
	rts
; Return point of CheckOneTimerFacing.
CheckOneTimerFacingReturn
	rts