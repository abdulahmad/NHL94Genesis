donothing
	btst	#$5,$62(a3)
	bne.w	check4benchExit
	btst	#$3,$62(a3)
	bne.w	check4benchExit
	moveq	#$8,d0
	bra.w	doplayeracc
; AI target setup: flags 5 and 1 of $62
AssistTargetSetup	btst.b	#$5,$62(a3)
	bne.w	check4benchExit
	bclr.b	#$1,$62(a3)
	beq.w	.next2
	move.w	#$5A,$44(a3)
	tst.w	$17CEE.l
	bpl.w	.next
	neg.w	$44(a3)
.next	move.w	$17CEA.l,$46(a3)
	move.w	#$109E,d1
	bsr.w	SetSPA
.next2	move.w	$44(a3),d0
	sub.w	$0(a3),d0
	move.w	$46(a3),d1
	sub.w	$14(a3),d1
	bsr.w	vtoa
	cmpi.w	#$7,d0
	bgt.w	check4benchExit
	move.w	d0,d2
	move.w	d2,$54(a3)
	bra.w	playeracc
	btst.b	#$5,$62(a3)
	bne.w	check4benchExit
	bclr.b	#$1,$62(a3)
	beq.w	.next4
	bsr.w	AssistRandomTimer
	move.w	#$8,$42(a3)
	move.w	#$5A,$44(a3)
	tst.w	$17CEE.l
	bpl.w	.next3
	neg.w	$44(a3)
.next3	move.w	$17CEA.l,$46(a3)
.next4	movea.l	#$31AB6,a0
	move.w	$44(a3),d0
	move.w	$46(a3),d1
	btst.b	#$0,$17F78.l
	beq.w	.next7
	tst.w	$1AD72.l
	beq.w	.next5
	subi.w	#$1,$1AD72.l
	bne.w	.next5
	bset.b	#$2,$17F6C.l
.next5	cmpi.w	#$88,$0(a3)
	bgt.w	.next6
	cmpi.w	#$FF78,$0(a3)
	bgt.w	.next7
.next6	clr.w	d1
.next7	sub.w	d7,$40(a3)
	bpl.w	AssistSkateOrExit
	bset.b	#$5,$62(a3)
	move.w	#$E8A,d1
	move.w	$17E28.l,d0
	cmp.w	$52(a3),d0
	bne.w	.next8
	move.w	#$EFC,d1
.next8	bsr.w	SetSPA
; Sets a random timer (0 to $78) in $40
AssistRandomTimer	moveq	#$78,d0
	bsr.w	randomd0
	move.w	d0,$40(a3)
	rts
; Skates to the target or returns
AssistSkateOrExit	btst.b	#$3,$62(a3)
	beq.w	skateto
	rts
	btst.b	#$5,$62(a3)
	bne.w	check4benchExit
	btst.b	#$0,$17F68.l
	bne.w	donothing
	bsr.w	check4bench
	btst.b	#$3,$62(a3)
	bne.w	check4benchExit
	bclr.b	#$1,$62(a3)
	beq.w	.next
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
.next	sub.b	d7,$40(a3)
	bpl.w	.next5
	move.b	$6A(a3),$40(a3)
	jsr	$2AEDC.l
	bmi.w	.next2
	btst.b	#$6,$17F7A.l
	beq.w	.next3
	tst.b	$40(a3)
	beq.w	.next3
.next2	subi.b	#$1,$40(a3)
.next3	moveq	#$2,d0
	btst.b	#$4,$32(a2)
	bne.w	assreplace
	move.w	$17B94.l,d1
	btst.b	#$7,$62(a3)
	bne.w	.next4
	neg.w	d1
.next4	cmpi.w	#$5D,d1
	blt.w	assreplace
	move.w	$17BE0.l,d1
	bmi.w	.next5
	subi.w	#$6,d1
	move.w	$52(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	bmi.w	assreplace
.next5	dc.w	$41FA,$1BCE
	moveq	#$50,d0
	cmpi.w	#$2,$34(a3)
	beq.w	.next6
	neg.w	d0
.next6	move.w	#$62,d1
	btst.b	#$7,$62(a3)
	bne.w	.next7
	neg.w	d0
	neg.w	d1
.next7	move.w	$17B80.l,d2
	eor.w	d0,d2
	bmi.w	.next8
	move.w	$17B80.l,d0
	bra.w	skateto
.next8	move.w	$17B80.l,d2
	asr.w	#$1,d2
	add.w	d2,d0
	bra.w	skateto
	btst.b	#$5,$62(a3)
	bne.w	check4benchExit
	btst.b	#$0,$17F68.l
	bne.w	donothing
	bsr.w	check4bench
	btst.b	#$3,$62(a3)
	bne.w	check4benchExit
	bclr.b	#$1,$62(a3)
	beq.w	.next9
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
.next9	sub.b	d7,$40(a3)
	bpl.w	.next22
	move.b	$6B(a3),$40(a3)
	btst.b	#$6,$17F7A.l
	beq.w	.next10
	tst.b	$40(a3)
	beq.w	.next10
	subi.b	#$1,$40(a3)
.next10	move.w	$17B94.l,d1
	move.w	$17BAA.l,d3
	asr.w	#$6,d3
	btst.b	#$7,$62(a3)
	bne.w	.next11
	neg.w	d1
	neg.w	d3
.next11	tst.w	d3
	bpl.w	.next12
	clr.w	d3
.next12	add.w	d1,d3
	cmpi.w	#$58,d3
	blt.w	.next13
	btst.b	#$4,$32(a2)
	bne.w	.next13
	move.w	$17BE0.l,d1
	bmi.w	.next13
	bsr.w	chkpk
	beq.w	.next13
	moveq	#$1,d0
	subi.w	#$6,d1
	move.w	$52(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	bpl.w	assreplace
.next13	move.w	#$41,$44(a3)
	cmpi.w	#$2,$34(a3)
	beq.w	.next14
	neg.w	$44(a3)
.next14	movea.l	#$17480,a0
	cmpi.w	#$6,$52(a3)
	bge.w	.next15
	adda.w	#$300,a0
.next15	moveq	#$5,d2
	move.w	#$FC18,d0
	btst.b	#$7,$62(a3)
	beq.w	.loop2
	neg.w	d0
.loop	btst.b	#$2,$63(a0)
	bne.w	.next17
	tst.w	$34(a0)
	bmi.w	.next17
	move.w	$2A(a0),d1
	bmi.w	.next16
	clr.w	d1
.next16	asr.w	#$4,d1
	add.w	$14(a0),d1
	cmp.w	d0,d1
	bgt.w	.next17
	move.w	d1,d0
.next17	adda.w	#$80,a0
	dbra	d2,.loop
	subi.w	#$32,d0
	cmpi.w	#$FF42,d0
	bgt.w	.next18
	move.w	#$FF24,d0
.next18	move.w	d0,$46(a3)
	move.w	$17B80.l,d0
	move.w	$44(a3),d1
	eor.w	d0,d1
	bpl.w	.next22
	clr.w	$44(a3)
	bra.w	.next22
.loop2	btst.b	#$2,$63(a0)
	bne.w	.next20
	tst.w	$34(a0)
	bmi.w	.next20
	move.w	$2A(a0),d1
	bpl.w	.next19
	clr.w	d1
.next19	asr.w	#$4,d1
	add.w	$14(a0),d1
	cmp.w	d0,d1
	blt.w	.next20
	move.w	d1,d0
.next20	adda.w	#$80,a0
	dbra	d2,.loop2
	addi.w	#$32,d0
	cmpi.w	#$BE,d0
	blt.w	.next21
	move.w	#$DC,d0
.next21	move.w	d0,$46(a3)
	neg.w	$44(a3)
	move.w	$17B80.l,d0
	move.w	$44(a3),d1
	eor.w	d0,d1
	bpl.w	.next22
	clr.w	$44(a3)
.next22	move.w	$44(a3),d0
	move.w	$46(a3),d1
	movea.l	#$33C6E,a0
	bsr.w	skateto
	bra.w	CheckCheckerSet
.loop3	rts
	btst.b	#$5,$62(a3)
	bne.w	.loop3
	btst.b	#$0,$17F68.l
	bne.w	donothing
	bsr.w	check4bench
	btst.b	#$3,$62(a3)
	bne.w	.loop3
	bclr.b	#$1,$62(a3)
	beq.w	.next23
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
.next23	sub.b	d7,$40(a3)
	bpl.w	.next25
	move.b	$6B(a3),$40(a3)
	btst.b	#$6,$17F7A.l
	beq.w	.next24
	tst.b	$40(a3)
	beq.w	.next24
	subi.b	#$1,$40(a3)
.next24	move.w	$17BE0.l,d1
	bmi.w	.next25
	moveq	#$4,d0
	subi.w	#$6,d1
	move.w	$52(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	bpl.w	assreplace
.next25	moveq	#$64,d0
	cmpi.w	#$5,$34(a3)
	bne.w	.next26
	neg.w	d0
.next26	move.l	#$9E,d1
	btst.b	#$7,$62(a3)
	beq.w	.next28
	neg.w	d0
	neg.w	d1
	moveq	#-78,d2
	btst.b	#$4,$32(a2)
	bne.w	.next30
	cmp.w	$17B94.l,d2
	bgt.w	.next27
	move.w	$17B94.l,d1
	bra.w	.next31
.next27	move.w	#$FEF8,d2
	cmp.w	$17B94.l,d2
	blt.w	.next31
	move.w	d2,d1
	bra.w	.next31
.next28	moveq	#$4E,d2
	btst.b	#$4,$32(a2)
	bne.w	.next30
	cmp.w	$17B94.l,d2
	blt.w	.next29
	move.w	$17B94.l,d1
	bra.w	.next31
.next29	move.w	#$108,d2
	cmp.w	$17B94.l,d2
	bgt.w	.next31
.next30	move.w	d2,d1
.next31	lea.l	$322B0.l,a0
	move.w	$17B80.l,d2
	eor.w	d0,d2
	bmi.w	skateto
	move.w	$17B80.l,d0
	bra.w	skateto
	btst.b	#$5,$62(a3)
	bne.w	.loop3
	btst.b	#$0,$17F68.l
	bne.w	donothing
	bsr.w	check4bench
	btst.b	#$3,$62(a3)
	bne.w	.loop3
	bclr.b	#$1,$62(a3)
	beq.w	.next32
	st.b	$48(a3)
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
.next32	sub.b	d7,$40(a3)
	bpl.w	AssistTargetFlip
	move.b	$6B(a3),$40(a3)
	btst.b	#$6,$17F7A.l
	beq.w	.next33
	tst.b	$40(a3)
	beq.w	.next33
	subi.b	#$1,$40(a3)
.next33	moveq	#$3,d0
	move.w	$17BE0.l,d1
	bmi.w	.next34
	subi.w	#$6,d1
	move.w	$52(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	bmi.w	assreplace
.next34	move.w	$17B94.l,d0
	move.w	$17BAA.l,d3
	asr.w	#$6,d3
	add.w	d0,d3
	btst.b	#$7,$62(a3)
	bne.w	.next35
	neg.w	d0
	neg.w	d3
.next35	clr.w	d2
	cmpi.w	#$FFA8,d3
	blt.w	.next36
	addi.w	#$8,d2
	cmpi.w	#$58,d0
	blt.w	.next36
	btst.b	#$4,$32(a2)
	bne.w	.next36
	addi.w	#$8,d2
	cmpi.w	#$108,d3
	blt.w	.next36
	addi.w	#$8,d2
.next36	cmp.w	$48(a3),d2
	bne.w	.next37
.loop4	btst.b	#$7,$FF800E.l
	bne.s	.loop4
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop5	btst.b	#$6,$FF800E.l
	beq.s	.loop5
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	bne.s	.loop6
	bclr.b	#$7,$FF800F.l
	andi.w	#$7F,d0
	bne.w	AssistTargetFlip
.next37	move.w	d2,$48(a3)
	lea.l	AssistLimitsTable(pc),a0
	move.w	$2(a0,d2.w),d0
	bsr.w	randomd0s
	add.w	(a0,d2.w),d0
	move.w	d0,$44(a3)
	move.w	$6(a0,d2.w),d0
	bsr.w	randomd0s
	add.w	$4(a0,d2.w),d0
	move.w	d0,$46(a3)
	bra.w	AssistTargetFlip
; Word table of position limits
AssistLimitsTable	dc.b	$00,$50,$00,$14,$FF,$BA,$00,$0A,$00,$64,$00,$14,$00,$3A,$00,$05	; .P.......d...:..
	dc.b	$00,$3C,$00,$32,$00,$E6,$00,$14,$00,$50,$00,$1E,$00,$FA,$00,$14	; .<.2.....P......
; Mirrors the target x for the side
AssistTargetFlip	move.w	$44(a3),d0
	cmpi.w	#$5,$34(a3)
	beq.w	.next
	neg.w	d0
.next	move.w	$46(a3),d1
	btst.b	#$7,$62(a3)
	bne.w	.next2
	neg.w	d0
	neg.w	d1
.next2	dc.w	$41FA,$1700
	bra.w	skateto
.loop	rts
	btst.b	#$5,$62(a3)
	bne.w	.loop
	btst.b	#$0,$17F68.l
	bne.w	donothing
	bsr.w	check4bench
	btst.b	#$3,$62(a3)
	bne.w	.loop
	bclr.b	#$1,$62(a3)
	beq.w	.next3
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
.next3	sub.b	d7,$40(a3)
	bpl.w	.next5
	move.b	$6B(a3),$40(a3)
	btst.b	#$6,$17F7A.l
	beq.w	.next4
	tst.b	$40(a3)
	beq.w	.next4
	subi.b	#$1,$40(a3)
.next4	move.w	$17BE0.l,d1
	bmi.w	.next5
	moveq	#$6,d0
	subi.w	#$6,d1
	move.w	$52(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	bpl.w	assreplace
.next5	move.w	$17B80.l,d0
	asr.w	#$1,d0
	move.w	$17B94.l,d2
	btst.b	#$7,$62(a3)
	bne.w	.next6
	neg.w	d2
.next6	moveq	#-128,d1
	cmpi.w	#$FFA8,d2
	blt.w	.next7
	add.w	$17B94.l,d1
	asr.w	#$1,d1
.next7	btst.b	#$7,$62(a3)
	bne.w	.next8
	neg.w	d1
.next8	lea.l	$32574.l,a0
	bra.w	skateto
	btst.b	#$5,$62(a3)
	bne.w	.loop
	btst.b	#$0,$17F68.l
	bne.w	donothing
	bsr.w	check4bench
	btst.b	#$3,$62(a3)
	bne.w	.loop
	bclr.b	#$1,$62(a3)
	beq.w	.next9
	st.b	$48(a3)
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
.next9	sub.b	d7,$40(a3)
	bpl.w	AssistTargetFlipGoalie
	move.b	$6B(a3),$40(a3)
	btst.b	#$6,$17F7A.l
	beq.w	.next10
	tst.b	$40(a3)
	beq.w	.next10
	subi.b	#$1,$40(a3)
.next10	move.w	$17BE0.l,d1
	bmi.w	.next11
	moveq	#$5,d0
	subi.w	#$6,d1
	move.w	$52(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	bmi.w	assreplace
.next11	move.w	$17B94.l,d0
	btst.b	#$7,$62(a3)
	bne.w	.next12
	neg.w	d0
.next12	clr.w	d2
	cmpi.w	#$FFA8,d0
	blt.w	.next13
	addi.w	#$8,d2
	cmpi.w	#$58,d0
	blt.w	.next13
	btst.b	#$4,$32(a2)
	bne.w	.next13
	addi.w	#$8,d2
	cmpi.w	#$108,d0
	blt.w	.next13
	addi.w	#$8,d2
.next13	cmp.w	$48(a3),d2
	bne.w	.next14
.loop2	btst.b	#$7,$FF800E.l
	bne.s	.loop2
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	beq.s	.loop3
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop4	btst.b	#$6,$FF800E.l
	bne.s	.loop4
	bclr.b	#$7,$FF800F.l
	andi.w	#$7F,d0
	bne.w	AssistTargetFlipGoalie
.next14	move.w	d2,$48(a3)
	lea.l	AssistLimitsTableGoalie(pc),a0
	move.w	$2(a0,d2.w),d0
	bsr.w	randomd0s
	add.w	(a0,d2.w),d0
	move.w	d0,$44(a3)
	move.w	$6(a0,d2.w),d0
	bsr.w	randomd0s
	add.w	$4(a0,d2.w),d0
	move.w	d0,$46(a3)
	bra.w	AssistTargetFlipGoalie
; Word table of position limits for the goalie
AssistLimitsTableGoalie	dc.b	$00,$00,$00,$3C,$FF,$BA,$00,$0A,$00,$00,$00,$3C,$00,$3C,$00,$0A	; ...<.......<.<..
	dc.b	$00,$00,$00,$28,$00,$AA,$00,$1E,$00,$00,$00,$50,$00,$AA,$00,$14	; ...(.......P....
; Mirrors the target for the goalie
AssistTargetFlipGoalie	move.w	$44(a3),d0
	move.w	$46(a3),d1
	btst.b	#$7,$62(a3)
	bne.w	.next
	neg.w	d1
.next	dc.w	$41FA,$14B6
	bra.w	skateto
assgoaliectrl						;joypad controlled goalie control: a3 = goalie; a goalie not on the
									;joystick leaves through assexit
	btst	#$3,$62(a3)		;is player joystick controlled?
	bne.w	.goaliectrl		;branch is so
	bra.w	assexit
.goaliectrl	btst	#$1,$62(a3)		;check if new assignment
	bne.w	.na		;branch if new assignment
	movem.w	d0-d1,-(sp)		;push to stack
	move.w	$0(a3),d0		;Xpos
	move.w	$14(a3),d1		;Ypos
	cmpi.w	#$AA,d1		;compare $AA to Ypos
	bgt.w	.next
	cmpi.w	#$FF56,d1		;check -$AA to Ypos
	blt.w	.next		;branch if less than
	btst	#$0,$17F68.l		;check if clock stopped
	bne.w	.next		;branch if so
	move.w	d0,-(sp)		;push to stack
	move.w	#$8,d0		;clock stoppage due to goalie out of range
	jsr	(AddPenalty2).l
	move.w	(sp)+,d0
.next	sub.w	$17CEE.l,d0
	sub.w	$17CEA.l,d1
	bclr	#$2,$64(a3)		;clear goalie control bit?
	cmpi.w	#$74,d0		;compare $74 to Xpos diff
	blt.w	.0		;branch if less than
	bset	#$2,$64(a3)		;set goalie control bit?
	bra.w	.cont2
.0	cmpi.w	#$FF8C,d0		;compare -$74 to Xpos diff
	bgt.w	.1		;branch if greater than
	bset	#$2,$64(a3)		;set goalie control bit?
	bra.w	.cont2
.1	cmpi.w	#$64,d1		;compare $64 to Ypos diff
	blt.w	.2		;branch if less than
	bset	#$2,$64(a3)		;set goalie control bit?
	bra.w	.cont2
.2	cmpi.w	#$FF9C,d1		;compare -$64 to Ypos diff
	bgt.w	.cont2		;branch if greater than
	bset	#$2,$64(a3)		;set goalie control bit?
.cont2	movem.w	(sp)+,d0-d1		;pop from stack
	btst	#$2,$64(a3)		;check goalie ctrl bit
	bne.w	checkanimFlags		;branch if set
.na	btst	#$5,$62(a3)		;check if anim lock
	bne.w	check4benchExit		;exit if so
	bsr.w	check4bench
	bclr	#$1,$62(a3)		;clear new assignment bit
	beq.w	.nna		;branch if already cleared
	clr.w	$40(a3)		;clear temp1
	move.w	#$8,$42(a3)		;move 8 into temp2
	st.b	$46(a3)		;FFFF to temp4
.nna	btst	#$1,$63(a3)		;check if anim in progress
	bne.w	.ex		;exit if so
	btst	#$0,$17F68.l		;check if clock stopped
	bne.w	check4benchExit		;exit if so
	tst.w	$48(a3)		;test temp5
	bmi.w	.nofo		;branch if less than 0
	move.w	$52(a3),d0		;move SCnum into d0
	cmp.w	$17BE0.l,d0		;check if puckc is goalie
	beq.w	.mbfo		;branch if equal
	st.b	$48(a3)		;set temp5 to -1
	bra.w	.nofo
.mbfo	sub.w	d7,$48(a3)		;subtract d7(frames elapsed) from temp5
	bpl.w	.nofo		;branch if more than 0
	btst	#$2,$17F70.l		;check bit 2
	beq.w	.next2		;branch if not set
	bset	#$4,$17F70.l
	bra.w	.nofo
.next2	moveq	#$8,d0
	bsr.w	AddPenalty2
.nofo	sub.b	d7,$40(a3)		;sub d7(frames elapsed) from temp1
	bpl.w	.ex		;branch if positive
	move.b	$6B(a3),d0		;DfA into d0
	beq.w	.3		;branch if value was 0
	btst	#$6,$17F7A.l		;check if crowd meter broken
	beq.w	.3		;jump if not
	subi.b	#$1,d0		;sub 1 from d0
.3	lsr.b	#$2,d0		;divide by 4
	move.b	d0,$40(a3)		;move d0 into temp1
	move.w	$52(a3),d0		;move SCnum into d0
	cmp.w	$17BE0.l,d0		;compare puckc to d0
	beq.w	.ex		;jump to assgoaliecpu if the same
.ex	rts
checkanim
	btst	#$3,$62(a3)
	bne.w	assgoaliectrl
