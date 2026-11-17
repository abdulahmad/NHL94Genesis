checkpuckcoll_sfx						;Entered from checkpuckcoll. Puck in the air: sfx 5 once when sflags4 bit
									;2 is set
	bclr	#$2,$17F72.l
	beq.w	rtss2
	move.w	#$5,-(sp)
	bra.w	sfx
L3B882	cmpi.w	#$190,$14(a3)
	bgt.w	.l20896
	cmpi.w	#$FE70,$14(a3)
	bgt.w	.l2089A
.l20896	clr.w	$2A(a3)
.l2089A	cmpi.w	#$10,$18(a3)
	bgt.w	checkpuckcoll_sfx
	move.w	$52(a3),d0
	asl.w	#$1,d0
	movea.l	#$17CA0,a0
	movea.l	#$17CC0,a1
	movea.l	#$17C80,a2
	move.w	(a0,d0.w),d1
	cmpi.w	#$F,d1
	beq.w	.l208E8
	clr.w	d4
	move.b	$1(a1,d1.w),d4
	move.w	(a2,d4.w),d5
	sub.w	$14(a3),d5
	cmpi.w	#$16,d5
	bgt.w	.l208E8
	bsr.w	L3B912
	addq.w	#$1,d1
	dc.w	$6000,$FFDA
.l208E8	move.w	(a0,d0.w),d1
	beq.w	.l20910
	clr.w	d4
	move.b	-$1(a1,d1.w),d4
	move.w	$14(a3),d5
	sub.w	(a2,d4.w),d5
	cmpi.w	#$16,d5
	bgt.w	.l20910
	bsr.w	L3B912
	subq.w	#$1,d1
	dc.w	$6600,$FFE2
.l20910	rts
L3B912	movem.l	d0-d7/a0-a3,-(sp)
	lsr.w	#$1,d4
	cmp.w	$17BE0.l,d4
	beq.w	.l20A36
	cmpi.w	#$B,d4
	bgt.w	.l20A36
	asl.w	#$7,d4
	movea.l	#$17480,a2
	adda.w	d4,a2
	btst.b	#$2,$17F70.l
	beq.w	.l20956
	asr.w	#$7,d4
	cmp.w	$19368.l,d4
	beq.w	.l20956
	cmp.w	$1936A.l,d4
	bne.w	.l20A36
.l20956	btst.b	#$2,$62(a2)
	bne.w	.l20A36
	tst.b	$5E(a2)
	bne.w	.l20A36
	btst.b	#$2,$63(a2)
	bne.w	.l209E0
	cmpi.w	#$5,$18(a3)
	bgt.w	.l209E0
	cmpi.w	#$200,$2C(a3)
	bgt.w	.l209E0
	move.l	a2,-(sp)
	dc.w	$6100,$A9D8
	add.w	$0(a2),d0
	sub.w	$0(a3),d0
	cmpi.w	#$E,d0
	bgt.w	.l209E0
	cmpi.w	#$FFF2,d0
	blt.w	.l209E0
	add.w	$14(a2),d1
	sub.w	$14(a3),d1
	cmpi.w	#$E,d1
	bgt.w	.l209E0
	cmpi.w	#$FFF2,d1
	blt.w	.l209E0
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	move.l	#$C4,d1
	tst.b	$5E(a3)
	ble.w	.l209D2
	lsr.w	#$2,d1
.l209D2	cmp.l	d1,d0
	bhi.w	.l209E0
	bsr.w	puckstick
	bra.w	.l20A36
.l209E0	tst.w	$34(a2)
	beq.w	L3BA8C
	btst.b	#$3,$64(a2)
	bne.w	.l20A36
	move.w	$0(a2),d0
	sub.w	$0(a3),d0
	cmpi.w	#$8,d0
	bgt.w	.l20A36
	cmpi.w	#$FFF8,d0
	blt.w	.l20A36
	move.w	$14(a2),d1
	sub.w	$14(a3),d1
	cmpi.w	#$8,d1
	bgt.w	.l20A36
	cmpi.w	#$FFF8,d1
	blt.w	.l20A36
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmpi.l	#$40,d0
	bhi.w	.l20A36
	bsr.w	puckbody
.l20A36	movem.l	(sp)+,d0-d7/a0-a3
	rts
	dc.b	$00,$0C,$00,$0C,$00,$0D,$00,$0D,$00,$0D,$00,$0D,$00,$0D,$00,$0D	; ................
	dc.b	$00,$0D,$00,$0D,$00,$0E,$00,$0E,$00,$0E,$00,$0E,$00,$0F,$00,$0F	; ................
	dc.b	$00,$0F,$00,$0F,$00,$0F,$00,$0F,$00,$90,$00,$90,$00,$A9,$00,$A9	; ................
	dc.b	$00,$A9,$00,$A9,$00,$A9,$00,$A9,$00,$A9,$00,$A9,$00,$C4,$00,$C4	; ................
	dc.b	$00,$C4,$00,$C4,$00,$E1,$00,$E1,$00,$E1,$00,$E1,$00,$E1,$00,$E1	; ................
L3BA8C	move.l	a0,-(sp)
	movea.l	#$3BA3C,a0
	clr.w	d0
	move.b	$68(a2),d0
	btst.b	#$1,$17F7C.l
	bne.w	.l20AB2
	btst.b	#$6,$17F7A.l
	beq.w	.l20AB6
.l20AB2	addi.b	#$2,d0
.l20AB6	lsr.w	#$1,d0
	btst.b	#$3,$62(a2)
	beq.w	.l20AC6
	move.w	#$F,d0
.l20AC6	add.w	d0,d0
	btst.b	#$0,$17F78.l
	beq.w	.l20ADE
	tst.w	d0
	beq.w	.l20ADE
	subi.w	#$2,d0
.l20ADE	cmpi.w	#$1E,d0
	blt.w	.l20AEA
	move.w	#$1E,d0
.l20AEA	move.w	(a0,d0.w),$17EB4.l
	movea.l	#$3BA64,a0
	clr.l	$17EB6.l
	move.w	(a0,d0.w),$17EB8.l
	move.w	$17EB4.l,$17EBA.l
	neg.w	$17EBA.l
	btst.b	#$1,$17F76.l
	beq.w	.l20B3C
	move.w	#$C,$17EB4.l
	move.l	#$90,$17EB6.l
	move.w	#$FFF4,$17EBA.l
.l20B3C	cmpi.w	#$250,$58(a2)
	beq.w	.l20B50
	cmpi.w	#$2A2,$58(a2)
	bne.w	.l20B6A
.l20B50	move.w	#$12,$17EB4.l
	move.l	#$144,$17EB6.l
	move.w	#$FFEE,$17EBA.l
.l20B6A	movea.l	(sp)+,a0
	cmpi.w	#$F,$17B98.l
	bgt.w	.l20C0A
	move.w	$0(a2),d0
	cmpi.w	#$250,$58(a2)
	beq.w	.l20B98
	cmpi.w	#$2A2,$58(a2)
	bne.w	.l20BB6
	move.w	#$6,d1
	bra.w	.l20B9C
.l20B98	move.w	#$FFFA,d1
.l20B9C	btst.b	#$7,$62(a2)
	bne.w	.l20BA8
	neg.w	d1
.l20BA8	btst.b	#$0,$76(a2)
	beq.w	.l20BB4
	neg.w	d1
.l20BB4	add.w	d1,d0
.l20BB6	sub.w	$0(a3),d0
	cmp.w	$17EB4.l,d0
	bgt.w	.l20C0A
	cmp.w	$17EBA.l,d0
	blt.w	.l20C0A
	move.w	$14(a2),d1
	sub.w	$14(a3),d1
	cmp.w	$17EB4.l,d1
	bgt.w	.l20C0A
	cmp.w	$17EBA.l,d1
	blt.w	.l20C0A
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	$17EB6.l,d0
	movem.w	(sp)+,d0-d1
	bhi.w	.l20C0A
	dc.w	$6100,$03FE
	dc.w	$6000,$FE2E
.l20C0A	bclr.b	#$2,$17F72.l
	dc.w	$6700,$FE22
	move.w	$17BE0.l,d0
	cmp.w	$52(a2),d0
	dc.w	$6700,$FE14
	move.w	#$5,-(sp)
	bsr.w	sfx
	dc.w	$6000,$FE08
puckstick						;puck collides with stick. a2 = player who collided, a3 = puck, d0 =
									;distance^2 (from checkpuckcoll .ccx). A stick check on the puck carrier
									;can steal the puck (Stk rolls, smaller ranges when the carrier is in the
									;slot, sflags6 bit 5), else a slow enough puck is caught (puckglue); a
									;one-timer shoots it (onetimershot). Uses the slot ranges and the
									;skater, or no highlight: the stick takes the puck (steal check if someone
									;has it)
	tst.w	$34(a2)		;a2 = player who collided
	bne.w	.next		;branch if not goalie
	btst	#$4,$17F68.l
	bne.w	rtss2		;exit if so (goalie always lets the shot in)
.next	bclr	#$0,$62(a2)
	move.w	$17BE0.l,d1		;move puckc into d1
	bmi.w	.next6		;branch if no puck carrier
	asl.w	#$7,d1
	movea.l	#$17480,a0
	adda.w	d1,a0		;a0 = Struct of puck carrier
	move.b	$62(a0),d1
	move.b	$62(a2),d2
	eor.w	d1,d2		;compare pflags of each player
	btst	#$6,d2		;check if on same team
	beq.w	rtss2		;no stealing from teammate
	btst	#$5,(sflags6).l		;check if puckc is in slot
	beq.w	.next2
	cmpi.l	#$40,d0		;steal range met: goalies always steal, nobody steals from a goalie
	bhi.w	rtss2
	bra.w	.next3
.next2	cmpi.l	#$24,d0
	bhi.w	rtss2
.next3	tst.w	$34(a2)		;check if colliding player is goalie
	beq.w	.next5
	tst.w	$34(a0)
	beq.w	rtss2		;no stealing from goalie
	move.b	$71(a0),d0
	lsr.b	#$1,d0
	bsr.w	makepde		;adjust for energy level
	move.w	d0,-(sp)
	exg.l	a0,a2		;swap a2 and a0 (a0 now collider)
	move.b	$71(a0),d0		;Stk for collider
	lsr.b	#$1,d0		;divie by 2
	bsr.w	makepde		;adjust for energy
	exg.l	a0,a2		;swap back (a0 now puckc)
	neg.w	d0
	add.w	(sp)+,d0		;add puckc modified Stk
	addi.w	#$24,d0		;add 24 hex (36 decimal)
	bsr.w	randomd0
	btst	#$5,(sflags6).l		;check if puckc is in slot
	beq.w	.next4
	cmpi.w	#$4,d0		;steal: the carrier cannot touch the puck for a while (stick handling,
	bhi.w	rtss2		;exit if higher (not losing puck)
	bra.w	.next5
.next4	cmpi.w	#$2,d0		;compare 2 to d0
	bhi.w	rtss2		;exit if higher (not losing puck)
.next5	move.b	$71(a0),d0		;Stk of puckc
	lsr.b	#$1,d0
	bsr.w	makepde		;adj for energy
	addi.w	#$14,d0		;add 14 hex (20 dec)
	move.b	d0,$5E(a0)		;move result into nopuck (cant get puck timer)
	exg.l	a0,a2		;swap a0 and a2 (a0 now collider)
	move.b	$71(a0),d0		;Stk of collider
	lsr.b	#$1,d0
	bsr.w	makepde		;adj for energy
	addi.w	#$14,d0		;add 14 hex (20 dec)
	move.b	d0,$5E(a0)		;move result into nopuck
	exg.l	a0,a2
	move.w	$52(a0),$17E2A.l
	bclr	#$2,$17F6A.l		;clear pass dir mode
	bclr	#$3,$17F6A.l		;clear shot dir mode
.loop	move.w	#$6,-(sp)
	bsr.w	sfx
	bsr.w	a2touchpuck		;deflect
	bra.w	deflect		;no carrier (goalie in the smaller range): one-timer check
.next6	tst.w	$34(a2)
	bne.w	.next7
	cmpi.l	#$40,d0
	bhi.w	rtss2		;smaller range for stealing puck
.next7	btst	#$3,$64(a2)
	beq.w	.next8
	cmpi.l	#$64,d0		;not a one-timer, or past its frame: catch or deflect by puck speed
	bhi.w	.next11
	cmpi.w	#$18,$5A(a2)
	bge.w	.next8
	move.w	#$18,$5A(a2)
	bset	#$7,$17F7C.l
.next8	move.w	$17BA8.l,d0
	move.w	$17BAA.l,d1
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	clr.w	d1
	btst	#$4,$17F6C.l		;check if shot was taken
	bne.w	.next9
	btst	#$3,$64(a2)		;check if one timer
	bne.w	.next10
	move.b	$71(a2),d1
	mulu.w	#$15E,d1
.next9	addi.w	#$32C8,d1
	mulu.w	d1,d1
	cmp.l	d1,d0
	bls.w	puckglue
	move.b	#$8,$5E(a2)
	bra.w	.loop
.next10	exg.l	a2,a3
	jsr	(onetimershot).l
	exg.l	a2,a3
	rts
.next11	cmpi.l	#$144,d0
	bhi.w	.ex
	cmpi.w	#$18,$5A(a2)
	bge.w	.ex
	move.w	#$18,$5A(a2)
.ex	rts
puckglue						;part of puckstick that puckgoalie also branches to. Player a2 takes the
									;puck: faceoff and pass stats, crowd song, goalie hold time (temp5), then
									;.setd0player
	move.w	#$7,-(sp)
	move.w	$52(a2),d0		;move SCnum into d0
	move.w	d0,$17BE0.l		;move d0 into puckc
	movea.l	#tmstruct,a0		;Move Home Stats struct into a0
	lea.l	$366(a0),a1
	btst	#$6,$62(a2)		;check if player is home or away
	bne.w	.next
	exg.l	a0,a1
.next	st.b	$1A(a0)		;FF into assist 1
	st.b	$1C(a0)		;FF into assist 2
	bset	#$3,$32(a0)		;set a flag (not sure what)
	bclr	#$4,$17F6E.l		;clear flag (not sure what, might have to do with faceoff)
	beq.w	.next2		;branch if it was cleared already
	addi.w	#$1,$E(a1)		;add 1 to faceoff won
	addi.w	#$C8,(Crowdlevel).l
	move.w	#$C,(sp)		;move C to stack
	cmpa.l	#$1834C,a1		;compare if a1 is home
	bne.w	.next2
	addi.w	#$A,$17CD8.l
	move.w	#$B,(sp)		;Move B into stack
.next2	bsr.w	sfx
	move.w	$52(a2),d0		;move SCnum into d0
	cmp.w	$17E30.l,d0
	bne.w	.next3
	addi.w	#$1,$14(a1)
.next3	st.b	$17E30.l
	bclr	#$2,$17F6A.l		;clear pass dir mode
	bclr	#$3,$17F6A.l		;clear shot dir mode
	tst.w	$34(a2)		;check if a2 is goalie
	bne.w	.next4
	bsr.w	ChkShotStat
	move.w	#$8C,$48(a2)		;move 8C to temp5 - countdown for faceoff?
	cmpi.w	#$2F4,$58(a2)		;check for goalie dive animation
	bne.w	.next4		;branch if not equal
	move.w	#$5,$48(a2)		;set temp5 to 5
.next4	cmp.w	$17F9E.l,d0
	beq.w	rtss2
	cmp.w	$17FA0.l,d0
	beq.w	rtss2
	tst.w	$17FAA.l
	beq.w	.next5
	cmp.w	$17FA2.l,d0
	beq.w	rtss2
.next5	tst.w	$17FAC.l
	beq.w	.next6
	cmp.w	$17FA4.l,d0
	beq.w	rtss2
.next6	tst.w	$17FAA.l
	bne.w	.next7
	tst.w	$17FAC.l
	beq.w	.next9		;branch if no team
.next7	movem.l	d0/a3,-(sp)
	asl.w	#$7,d0
	movea.l	#$17480,a3
	tst.w	$34(a3,d0.w)
	bne.w	.next8
	btst	#$3,$62(a3,d0.w)		;check if d0 player controlled
	beq.w	.next8
	movem.l	(sp)+,d0/a3		;exit if player controlled
	rts
.next8	movem.l	(sp)+,d0/a3
.next9	cmpi.w	#$6,d0
	slt.b	d1
	ext.w	d1
	addi.w	#$2,d1
	move.w	$17E2A.l,d2
	cmp.w	$17FA0.l,d2
	beq.w	.next10
	cmp.w	$17FA6.l,d1
	bne.w	.next10
	jmp	(setc1player).l
.next10	cmp.w	$17FA8.l,d1
	bne.w	.next11
	jmp	(setc2player).l
.next11	cmp.w	$17FA6.l,d1
	bne.w	rtss2
	jmp	(setc1player).l
puckbody						;puck hits player a2. a3 = puck, d0 = distance^2 (from checkpuckcoll
									;.ccx). The puck bounces off. A high puck (Zpos > 8) that is fast makes a2
									;fall (FallDown, Zpos > $C); a slower one starts SPAcatch on a2
	btst	#$3,$64(a2)
	bne.w	rtss2		;real hit (low or near center): a2 touched the puck
	cmpi.w	#$8,$18(a3)
	bgt.w	.next
	move.w	d0,d1
	andi.w	#$F,d1		;radius^2 from center
	bne.w	rtss2
.next	bsr.w	a2touchpuck		;real hit: a2 touched the puck
	move.w	#$24,-(sp)
	bsr.w	sfx
	clr.w	$2C(a3)
	move.b	#$8,$5E(a2)
	move.w	$0(a3),d0		;Xpos
	sub.w	$0(a2),d0
	move.w	$14(a3),d1
	sub.w	$14(a2),d1
	bne.w	.next2
	move.l	a2,-(sp)
	bsr.w	GetHotCount
.next2	move.w	$28(a3),d2
	move.w	$2A(a3),d3
	move.b	d0,$28(a3)
	move.b	d1,$2A(a3)
	bsr.w	puckflip
	cmpi.w	#$8,$18(a3)
	ble.w	rtss2
	muls.w	d2,d2
	muls.w	d3,d3
	add.l	d3,d2		;slow puck: a2 catches it (SPAcatch) unless locked
	cmpi.l	#$9000000,d2		;fast puck
	bls.w	.next3
	cmpi.w	#$C,$18(a3)
	bgt.w	FallDown
	rts
.next3	bset	#$5,$62(a2)
	bne.w	rtss2
	move.w	#$10D0,d1
	exg.l	a2,a3
	bsr.w	SetSPA
	exg.l	a2,a3
rtss2						;shared rts
	rts
L3C002	btst.b	#$4,$17F68.l
	bne.w	rtss2
	clr.w	d2
	cmpi.w	#$8,$18(a3)
	bgt.w	.l2101E
	addi.w	#$2,d2
.l2101E	neg.w	d0
	neg.w	d1
	bsr.w	vtoa
	sub.w	$54(a2),d0
	andi.w	#$7,d0
	move.w	d0,d1
	andi.w	#$3,d1
	bne.w	.l21084
	btst.b	#$7,$FF800E.l
	dc.w	$66F6
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
	btst.b	#$6,$FF800E.l
	dc.w	$67F6
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
	btst.b	#$6,$FF800E.l
	dc.w	$66F6
	bclr.b	#$7,$FF800F.l
.l21084	andi.w	#$4,d0
	lsr.w	#$2,d0
	eori.w	#$1,d0
	add.w	d0,d2
	add.w	d2,d2
	lea.l	L3C23E(pc),a0
	move.w	(a0,d2.w),d0
	moveq	#$F,d1
	add.b	(a2,d0.w),d1
	dc.w	$41FA,$01A4
	btst.b	#$3,$4(a2)
	beq.w	.l210B2
	eori.w	#$2,d2
.l210B2	move.w	$6(a2),d0
	move.w	#$197,-(sp)
	cmpi.w	#$233,d0
	blt.w	.l210CA
	move.w	#$292,(sp)
	dc.w	$41FA,$017E
.l210CA	sub.w	(sp)+,d0
	move.b	(a0,d0.w),d0
	lsr.w	d2,d0
	andi.w	#$3,d0
	bclr.b	#$2,$17F72.l
	bsr.w	ChkShotStat
	dc.w	$6100,$9C44
	cmpi.w	#$3000,$17BAA.l
	bgt.w	.l210FE
	cmpi.w	#$D000,$17BAA.l
	bgt.w	.l21114
.l210FE	move.w	#$B,-(sp)
	btst.b	#$6,$62(a2)
	beq.w	.l21110
	move.w	#$D,(sp)
.l21110	bsr.w	sfx
.l21114	move.w	#$24,-(sp)
	bsr.w	sfx
	move.w	$17BE0.l,d2
	bmi.w	.l21194
	st.b	$17BE0.l
	asl.w	#$7,d2
	movea.l	#$17480,a0
	adda.w	d2,a0
	move.b	#$14,$5E(a0)
	move.w	$52(a0),$17E2A.l
	bclr.b	#$2,$17F6A.l
	bclr.b	#$3,$17F6A.l
	clr.w	$2C(a3)
	move.b	#$A,$5E(a2)
	move.w	#$4,$46(a2)
	move.w	$0(a3),d0
	sub.w	$0(a2),d0
	move.w	$14(a3),d1
	sub.w	$14(a2),d1
	bne.w	.l2117E
	move.l	a2,-(sp)
	dc.w	$6100,$A1E6
.l2117E	move.b	d0,$28(a3)
	move.b	d1,$2A(a3)
	bra.w	puckflip
	bset.b	#$2,$17F72.l
	rts
.l21194	cmpi.w	#$2F4,$58(a2)
	dc.w	$6700,$FFB8
	moveq	#$2,d0
	add.b	$6C(a2),d0
	asl.w	#$8,d0
	asl.w	#$1,d0
	bsr.w	randomd0
	addi.w	#$C00,d0
	add.w	d0,d0
	bpl.w	.l211BA
	move.w	#$7FFF,d0
.l211BA	btst.b	#$1,$63(a2)
	bne.w	.l21202
	cmpi.w	#$2C,$0(a3)
	bgt.w	.l21202
	cmpi.w	#$FFD4,$0(a3)
	blt.w	.l21202
	cmpi.w	#$10E,$14(a3)
	bgt.w	.l21202
	cmpi.w	#$FEF2,$14(a3)
	blt.w	.l21202
	cmpi.w	#$D2,$14(a3)
	bgt.w	.l21200
	cmpi.w	#$FF2E,$14(a3)
	bgt.w	.l21202
.l21200	asr.w	#$2,d0
.l21202	cmp.w	$17BA8.l,d0
	dc.w	$6D00,$FF4A
	cmp.w	$17BAA.l,d0
	dc.w	$6D00,$FF40
	neg.w	d0
	cmp.w	$17BA8.l,d0
	dc.w	$6E00,$FF34
	cmp.w	$17BAA.l,d0
	dc.w	$6E00,$FF2A
	btst.b	#$2,$63(a2)
	dc.w	$6600,$FF20
	clr.w	$2C(a3)
	bra.w	puckglue
L3C23E	dc.b	$00,$73,$00,$6E,$00,$70,$00,$72	; .s.n.p.r
deflect
	st.b	$17BE0.l
	move.w	#$1000,d0
	bsr.w	randomd0s
	move.w	d0,$2A(a3)
	move.w	#$1000,d0
	bsr.w	randomd0s
	move.w	d0,$28(a3)
	move.w	#$1000,d0
	bsr.w	randomd0
	move.w	d0,$2C(a3)
	bra.w	puckflip
makepde						;pass d0 as value to be scaled by player a0's energy level (full energy
									;while sflags7 bit 4 is set). Return d0 as result
	ext.w	d0
	move.w	d0,-(sp)
	movem.l	d1/a2-a3,-(sp)
	movea.l	a0,a3
	bsr.w	getpde
	btst	#$4,$17F7A.l
	beq.w	.next
	move.w	#$1000,d0
.next	movem.l	(sp)+,d1/a2-a3
	muls.w	(sp)+,d0
	asl.l	#$4,d0
	swap	d0
	ext.l	d0		;d0 = d0 * energy / 4096
	rts
getpde						;get player a3's energy level into d0. Return a2 = his team struct, d1 =
									;pnum*2
	movea.l	#tmstruct,a2
	btst	#$6,$62(a3)		;#pfteam - home or away
	beq.w	.next
	adda.w	#$366,a2
.next	move.b	$66(a3),d1
	ext.w	d1
	add.w	d1,d1
	move.w	$34(a2,d1.w),d0
	rts
setpde
	tst.w	d0
	bpl.w	.next
	clr.w	d0
.next	move.w	d0,$34(a2,d1.w)
	rts
updatepwrplay						;show graphic and time remaining for power plays. Nothing when gmode2 bit
	
	
	
	btst	#$1,$17F78.l
	bne.w	rtss2
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a3
	move.w	$26(a2),d0
	sub.w	$26(a3),d0
	beq.w	.clrpwrplay
	bpl.w	.t0
	btst	#$6,$17F6C.l
	bne.w	.upp
	bsr.w	.clrpwrplay
	bset	#$6,$17F6C.l
	bra.w	.upp
.t0	exg.l	a2,a3
	btst	#$6,$17F6C.l
	beq.w	.upp
	bsr.w	.clrpwrplay
	bclr	#$6,$17F6C.l
.upp	bset	#$5,$17F6C.l
	bne.w	.uppt
	addi.w	#$1,$4(a3)
	cmpa.l	#$1834C,a3
	bne.w	.away
.home	bra.w	.uppt
.away	bra.w	.home
.uppt	bsr.w	printz
	dc.w	$0012
	dc.b	$BF,$01,$19,$20,$20,$20,$16,$17,$18,$19,$BF,$01,$1A,$20,$20,$00
	bsr.w	GetLowestPen
	bsr.w	PushTime
	bsr.w	print
	movea.l	$1E(a3),a0
	movea.l	#mesarea,a3
	move.w	#$2,(a3)
	bsr.w	PushNumberWidthString
	String	CC_Font1Pri,$1,$19
	adda.w	$4(a0),a0
	adda.w	(a0),a0
	movea.l	a0,a1
	bsr.w	appstring
	movea.l	a3,a1
	bra.w	print
.clrpwrplay	bclr	#$5,$17F6C.l
	beq.w	rtss2
	bra.w	EASNLogo
ClrHor						;revert the graphics back to vertical ice rink mode. Reloads Rinktiles and
	
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#$7,$17F6A.l
	move.w	#$3E8,$17CEC.l
	move.w	$18D48.l,d4
	movea.l	$47D18.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	jsr	$2A9D0.l
	bsr.w	SprSortSetup
	btst	#$0,$17F6A.l
	bne.w	.next
	bsr.w	printz
	String	CC_Font1,$0,$0
	moveq	#$20,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	bsr.w	eraser
	bsr.w	printscores1
.next	movem.l	(sp)+,d0-d7/a0-a6
	rts
SetHor						;switch graphics to horizontal ice rink graphics mode
	movem.l	d0-d7/a0-a6,-(sp)
	bset	#$7,$17F6A.l
.p	btst	#$0,(disflags).l
	bne.w	.p
	clr.w	$17CF0.l
	clr.w	$17CF2.l
	bsr.w	SprSortSetup
	bsr.w	printz
	String	CC_Font2,$0,$0
	movea.l	$47D6C.l,a1
	adda.l	$4(a1),a1
	movea.l	$47D6C.l,a2
	addq.l	#$8,a2
	clr.w	d0
	move.w	#$0,d1
	moveq	#$20,d2
	moveq	#$1C,d3
	move.w	$18D48.l,d4
	moveq	#$0,d5
	bsr.w	dobitmap
	bsr.w	USBoard
	btst	#$0,$17F6A.l
	bne.w	.next
	move.w	#$800,d0
	move.w	(VmMAP1).l,d1
	move.w	#$7FF,d2
	bsr.w	DoDMANd2Queue
.next	movem.l	(sp)+,d0-d7/a0-a6
	rts
printscores1						;Draw scoreboard. Vertical rink: period box and the score box (team names
	
	
	
	
	
	
	movem.l	d0-d2/a0-a3,-(sp)
	btst	#$7,$17F6A.l
	bne.w	.sbscreen
	bclr	#$7,$17F74.l
	beq.w	.0
	move.w	#$78,$17F82.l
.0	bsr.w	printz
	String	CC_Font1Pri,$0,$17
	moveq	#$9,d0
	moveq	#$5,d1
	bsr.w	Framer
	bset	#$3,(disflags).l
	bsr.w	printz
	String	CC_Font1Pri,$1,$18
	move.w	$180E4.l,d0
	movea.l	#$41A34,a1
	btst	#$1,$17F78.l
	beq.w	.1
	move.w	#$4,d0
	movea.l	#$41A48,a1
.1	bsr.w	PrintTickerEntry
	bsr.w	EASNLogo
	btst	#$0,$17F6E.l
	bne.w	.loop
	bsr.w	printz
	String	CC_Font1Pri,$17,$17
	moveq	#$8,d0
	moveq	#$5,d1
	bsr.w	Framer
	bsr.w	printz
	String	CC_Font1Pri,$18,$1A
	movea.l	#tmstruct,a2
	bsr.w	printscores1_ps
	bsr.w	printz
	String	CC_Font1Pri,$18,$18
	adda.w	#$366,a2
	bsr.w	printscores1_ps
.loop	movem.l	(sp)+,d0-d2/a0-a3
	rts
.sbscreen	bsr.w	printz
	String	CC_Font2Pri,$11,$2
	move.w	$180E4.l,d0
	btst	#$0,$17F78.l
	beq.w	.2
	move.w	#$4,d0
.2	movea.l	#$41A48,a1
	bsr.w	SkipListEntries
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	bsr.w	print
	bsr.w	printz
	String	CC_Font2Pri,$17,$2
	movea.l	#tmstruct,a2
	clr.w	d0
	bsr.w	PrintTeamLogoAndScore
	bsr.w	printz
	String	CC_Font2Pri,$8,$2
	adda.w	#$366,a2		;tmsize
	moveq	#$2C,d0
	bsr.w	PrintTeamLogoAndScore
	bra.w	.loop
printscores1_ps						;Print the team name of team a2 at printx/printy, then its score as 2
	
	movea.l	$1E(a2),a1
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	bsr.w	print
	move.w	#$1C,(printx).l
	move.w	$C(a2),d0
	moveq	#$2,d1
	bsr.w	PushNumberWidth
	bra.w	print		;print the score and return
PrintTeamLogoAndScore						;Draw the team logo map (PutTeamBlock, d0 = offset) 5 columns left of
	
	
	
	move.w	(printx).l,-(sp)
	subi.w	#$5,(printx).l
	jsr	(PutTeamBlockDraw).l
	move.w	(sp)+,(printx).l
	addi.w	#$2,(printy).l
	move.w	$C(a2),d0
	cmpi.w	#$A,d0
	bge.w	.0
	bra.w	.1
.0	subi.w	#$1,(printx).l
.1	bsr.w	PushNumber
	move.w	(a1),d0
	subi.w	#$2,d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	addi.w	#$1,(printx).l
	bra.w	printbig
EASNLogo						;Draw the EASN logo map at x 1, y $19 on the vertical ice rink if no power
	
	btst	#$5,$17F6C.l
	bne.w	rtss2
	bsr.w	printz
	String	CC_Font1Pri,$1,$19
	movea.l	$47D4C.l,a1
	adda.l	$4(a1),a1
	movea.l	#$1B008,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	move.w	$18D50.l,d4
	clr.w	d5
	bra.w	dobitmap
USBoard						;Update score board, including the players in the penalty box and their
	
	movem.l	d0-d7/a0-a3,-(sp)
	bset	#$3,(disflags).l
	bsr.w	printscores1
	bsr.w	printz
	String	CC_Font2Pri,$14,$8
	dc.w	$247C,$0001,$834C,$6100,$001C,$6100,$C8E2,$0006
	dc.w	$BE05,$0800,$247C,$0001,$86B2,$6100,$0008,$4CDF
	dc.w	$0FFF,$4E75,$41EA,$009C,$4240,$1018,$6B00,$0014
	dc.w	$0832,$0006,$0068,$6600,$FFF0,$6100,$0024,$6000
	dc.w	$FFE8,$41EA,$009C,$4240,$1018,$6B00,$F934,$0832
	dc.w	$0006,$0068,$6700,$FFF0,$6100,$0006,$6000,$FFE8
pplpen						;print one penalty box line: player number and time remaining. a2 = team,
	
	
	cmpi.w	#$A,(printy).l
	bhi.w	rtss2
	move.w	$68(a2,d0.w),d2
	andi.w	#$7FF,d2
	movea.l	$1E(a2),a1
	adda.w	$0(a1),a1
	lsr.w	#$1,d0
.find	adda.w	(a1),a1
	adda.w	#$8,a1
	dbra	d0,.find
	clr.w	d0
	move.b	-$8(a1),d0
	move.w	(printx).l,-(sp)
	movea.l	#TextBuffer,a1
	bsr.w	ConvertByteToDigits
	movea.l	#mesarea,a1
	move.w	#$4,(a1)
	bsr.w	print
	move.w	d2,d0
	bsr.w	PushTime
	bsr.w	print
	move.w	(sp)+,(printx).l
	addi.w	#$1,(printy).l		;next row
	rts
linebar						;Draw the energy bar of line d0 for team a2 at printx/printy (bitmap from
	
	movem.l	d0-d5/a0-a2,-(sp)
	bsr.w	getlinee
	move.w	(printa).l,-(sp)
	move.w	#$8000,(printa).l
	ext.l	d0
	divu.w	#$100,d0
	cmpi.w	#$F,d0
	bls.w	.ok
	moveq	#$F,d0
.ok	moveq	#$F,d1
	sub.w	d0,d1
	clr.w	d0
	movea.l	$47D40.l,a1
	adda.l	$4(a1),a1
	movea.l	#$1B008,a2
	move.w	(a1),d2
	moveq	#$1,d3
	move.w	$18D46.l,d4
	moveq	#$0,d5
	bsr.w	dobitmap
	move.w	(sp)+,(printa).l
	movem.l	(sp)+,d0-d5/a0-a2
	rts
getlinee						;d0 = line number, a2 = team struct. Return d0 = energy level of this line
	movem.l	d1-d5/a0-a3,-(sp)
	lea.l	$16C(a2),a1
	asl.w	#$3,d0
	adda.w	d0,a1
	clr.l	d0
	clr.w	d1
	movea.l	#$41AD6,a0
	move.w	$26(a2),d4
	bra.w	.next
.loop	clr.w	d5
	move.b	(a0,d4.w),d5
	beq.w	.next
	clr.w	d3
	move.b	(a1,d5.w),d3
	asl.w	#$1,d3
	addi.w	#$1,d1
	add.w	$32(a2,d3.w),d0
.next	dbra	d4,.loop
	divu.w	d1,d0
	movem.l	(sp)+,d1-d5/a0-a3
	rts
AvgCline						;Return d0 = average energy of current line on team a2
	movem.l	d1-d3/a0,-(sp)
	clr.l	d0
	clr.w	d1
	moveq	#$5,d2
	movea.l	$22(a2),a0
.loop	tst.w	$34(a0)
	ble.w	.next
	clr.w	d3
	move.b	$66(a0),d3
	add.w	d3,d3
	add.w	$34(a2,d3.w),d0
	addi.w	#$1,d1
.next	adda.w	#$80,a0
	dbra	d2,.loop
	tst.w	d1
	beq.w	.next2
	divu.w	d1,d0
.next2	movem.l	(sp)+,d1-d3/a0
	rts
