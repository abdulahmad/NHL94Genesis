; Increments the frame timer
PlTimerTick	addq.w	#$1,$EC(a6)
	rts
; Vblank handler of the player screen
PlVblankHandler	move.w	#$1,$102(a6)
	addi.l	#$1,$96(a6)
	cmpi.w	#$2,$DE(a6)
	beq.w	.next9
	cmpi.w	#$1,$DE(a6)
	beq.w	.next10
	cmpi.w	#$3,$DE(a6)
	beq.w	.next5
	cmpi.w	#$4,$DE(a6)
	beq.w	.next6
	cmpi.w	#$5,$DE(a6)
	beq.w	.next7
	cmpi.w	#$6,$DE(a6)
	beq.w	.next8
	cmpi.w	#$7,$DE(a6)
	beq.w	.next4
	cmpi.w	#$8,$DE(a6)
	beq.w	.next3
	cmpi.w	#$9,$DE(a6)
	beq.w	.next2
	cmpi.w	#$A,$DE(a6)
	beq.w	.next
	bra.w	.next14
.next	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	move.w	$E2(a6),d0
	move.w	$E0(a6),d1
	addi.w	#$9200,d0
.loop	btst.b	#$4,$FF800E.l
	bne.b	.loop
	move.w	#$39,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop2	btst.b	#$3,$FF800E.l
	beq.b	.loop2
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop3	btst.b	#$3,$FF800E.l
	bne.b	.loop3
	bclr.b	#$4,$FF800F.l
	addi.w	#$9100,d1
.loop4	btst.b	#$4,$FF800E.l
	bne.b	.loop4
	move.w	#$39,$FF8026.l
	move.w	d1,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop5	btst.b	#$3,$FF800E.l
	beq.b	.loop5
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop6	btst.b	#$3,$FF800E.l
	bne.b	.loop6
	bclr.b	#$4,$FF800F.l
	bra.w	.next13
.next2	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	move.w	$E2(a6),d0
	andi.w	#$3FF,d0
.loop7	btst.b	#$4,$FF800E.l
	bne.b	.loop7
	move.w	#$30,$FF8026.l
	move.l	#$70000003,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop8	btst.b	#$3,$FF800E.l
	beq.b	.loop8
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop9	btst.b	#$3,$FF800E.l
	bne.b	.loop9
	bclr.b	#$4,$FF800F.l
.loop10	btst.b	#$4,$FF800E.l
	bne.b	.loop10
	move.w	#$31,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop11	btst.b	#$3,$FF800E.l
	beq.b	.loop11
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop12	btst.b	#$3,$FF800E.l
	bne.b	.loop12
	bclr.b	#$4,$FF800F.l
	add.w	$E0(a6),d0
	move.w	d0,$E2(a6)
	bra.w	.next13
.next3	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	bsr.w	GiveWordRam
.loop13	btst.b	#$4,$FF800E.l
	bne.b	.loop13
	move.w	#$2C,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop14	btst.b	#$3,$FF800E.l
	beq.b	.loop14
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop15	btst.b	#$3,$FF800E.l
	bne.b	.loop15
	bclr.b	#$4,$FF800F.l
	bsr.w	WaitDmnaSet
	bra.w	.next13
.next4	movem.l	d0-d3/a0-a2,-(sp)
.loop16	btst.b	#$4,$FF800E.l
	bne.b	.loop16
	move.w	#$30,$FF8026.l
	move.l	#$40000010,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop17	btst.b	#$3,$FF800E.l
	beq.b	.loop17
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop18	btst.b	#$3,$FF800E.l
	bne.b	.loop18
	bclr.b	#$4,$FF800F.l
	clr.w	$DE(a6)
	move.w	$E2(a6),d0
	move.w	$E0(a6),d1
	add.w	d1,d0
.loop19	btst.b	#$4,$FF800E.l
	bne.b	.loop19
	move.w	#$31,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop20	btst.b	#$3,$FF800E.l
	beq.b	.loop20
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop21	btst.b	#$3,$FF800E.l
	bne.b	.loop21
	bclr.b	#$4,$FF800F.l
	move.w	d0,$E2(a6)
	bra.w	.next13
.next5	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	moveq	#$0,d0
	bsr.w	GateArrayLoadFont
.loop22	btst.b	#$4,$FF800E.l
	bne.b	.loop22
	move.w	#$39,$FF8026.l
	move.w	#$9001,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop23	btst.b	#$3,$FF800E.l
	beq.b	.loop23
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop24	btst.b	#$3,$FF800E.l
	bne.b	.loop24
	bclr.b	#$4,$FF800F.l
	bra.w	.next13
.next6	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
.loop25	btst.b	#$4,$FF800E.l
	bne.b	.loop25
	move.w	#$39,$FF8026.l
	move.w	#$9003,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop26	btst.b	#$3,$FF800E.l
	beq.b	.loop26
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop27	btst.b	#$3,$FF800E.l
	bne.b	.loop27
	bclr.b	#$4,$FF800F.l
	bra.w	.next13
.next7	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
.loop28	btst.b	#$4,$FF800E.l
	bne.b	.loop28
	move.w	#$39,$FF8026.l
	move.w	$E2(a6),$FF8028.l
	bset.b	#$3,$FF800F.l
.loop29	btst.b	#$3,$FF800E.l
	beq.b	.loop29
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop30	btst.b	#$3,$FF800E.l
	bne.b	.loop30
	bclr.b	#$4,$FF800F.l
.loop31	btst.b	#$4,$FF800E.l
	bne.b	.loop31
	move.w	#$30,$FF8026.l
	move.l	#$40000010,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop32	btst.b	#$3,$FF800E.l
	beq.b	.loop32
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop33	btst.b	#$3,$FF800E.l
	bne.b	.loop33
	bclr.b	#$4,$FF800F.l
.loop34	btst.b	#$4,$FF800E.l
	bne.b	.loop34
	move.w	#$31,$FF8026.l
	move.w	#$0,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop35	btst.b	#$3,$FF800E.l
	beq.b	.loop35
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop36	btst.b	#$3,$FF800E.l
	bne.b	.loop36
	bclr.b	#$4,$FF800F.l
	bra.w	.next13
.next8	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	moveq	#$0,d0
	move.w	$E0(a6),d0
	move.l	d0,$BBC88.l
	move.w	$E2(a6),d0
	move.l	d0,$BBC8C.l
	move.w	$E4(a6),d0
	move.l	d0,$BBC90.l
	bsr.w	GiveWordRam
.loop37	btst.b	#$4,$FF800E.l
	bne.b	.loop37
	move.w	#$3A,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop38	btst.b	#$3,$FF800E.l
	beq.b	.loop38
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop39	btst.b	#$3,$FF800E.l
	bne.b	.loop39
	bclr.b	#$4,$FF800F.l
	bsr.w	WaitDmnaSet
	bra.w	.next13
.next9	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	moveq	#$0,d0
	move.w	$E0(a6),d0
	move.l	d0,$BBC88.l
	move.w	$E2(a6),d0
	move.l	d0,$BBC8C.l
	move.l	$E4(a6),$BBC90.l
	bsr.w	GiveWordRam
.loop40	btst.b	#$4,$FF800E.l
	bne.b	.loop40
	move.w	#$3B,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop41	btst.b	#$3,$FF800E.l
	beq.b	.loop41
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop42	btst.b	#$3,$FF800E.l
	bne.b	.loop42
	bclr.b	#$4,$FF800F.l
	bsr.w	WaitDmnaSet
	bra.w	.next13
.next10	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	move.w	$E0(a6),d0
	move.w	$E2(a6),d1
	movea.l	$E4(a6),a0
	cmpa.l	#$80000,a0
	bge.w	.next12
	move.l	d0,d3
	movea.l	#$BC000,a2
	lsr.w	#$1,d3
	bcc.w	.next11
	move.w	(a0)+,(a2)+
.next11	subq.w	#$1,d3
.loop43	move.l	(a0)+,(a2)+
	dbra	d3,.loop43
	movea.l	#$BC000,a0
.next12	lea.l	$C00004.l,a1
	move.l	(a0),$BBC96.l
	move.l	d1,$BBC9A.l
	adda.l	#$180002,a0
	move.w	#$8154,$BBC88.l
	move.w	#$8F02,$BBC8A.l
	move.w	#$9300,d2
	move.b	d0,d2
	move.w	d2,$BBC8C.l
	move.w	#$9400,d2
	lsr.w	#$8,d0
	move.b	d0,d2
	move.w	d2,$BBC8E.l
	move.l	a0,d0
	lsr.l	#$1,d0
	move.w	#$9500,d2
	move.b	d0,d2
	move.w	d2,$BBC90.l
	lsr.l	#$8,d0
	move.w	#$9600,d2
	move.b	d0,d2
	move.w	d2,$BBC92.l
	lsr.l	#$8,d0
	andi.b	#$7F,d0
	move.w	#$9700,d2
	move.b	d0,d2
	move.w	d2,$BBC94.l
	clr.l	d0
	move.w	d1,d0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	move.l	d0,d3
	ori.l	#$804000,d0
	move.l	d0,$BBC9E.l
	bsr.w	GiveWordRam
.loop44	btst.b	#$4,$FF800E.l
	bne.b	.loop44
	move.w	#$32,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop45	btst.b	#$3,$FF800E.l
	beq.b	.loop45
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop46	btst.b	#$3,$FF800E.l
	bne.b	.loop46
	bclr.b	#$4,$FF800F.l
	bsr.w	WaitDmnaSet
.next13	movem.l	(sp)+,d0-d3/a0-a2
.next14	tst.w	$FA(a6)
	beq.w	PlVblankTimers
	movem.l	d0-d3/a0-a2,-(sp)
	move.w	$F6(a6),d0
	cmp.w	$F4(a6),d0
	bgt.w	.next16
	cmpi.w	#$1,$F8(a6)
	beq.w	.next15
	neg.w	d0
.next15	add.w	$F2(a6),d0
	bsr.w	GateArrayLoadFont
	addi.w	#$6,$F6(a6)
	bra.w	.next18
.next16	move.w	$F6(a6),d0
	subi.w	#$6,d0
	move.w	d0,$F6(a6)
	sub.w	$F4(a6),d0
	neg.w	d0
	add.w	$F6(a6),d0
	tst.w	$F8(a6)
	bne.w	.next17
	neg.w	d0
.next17	add.w	$F2(a6),d0
	bsr.w	GateArrayLoadFont
	clr.w	$FA(a6)
	clr.w	$F6(a6)
	andi.w	#$3FF,d0
	move.w	d0,$F2(a6)
.next18	movem.l	(sp)+,d0-d3/a0-a2
; Vblank: ticks the timers
PlVblankTimers	movem.l	d0-d5/a0-a1,-(sp)
	bsr.w	TickTimers
	movem.l	(sp)+,d0-d5/a0-a1
	rts
; Sends the font load command through the gate-array registers.
GateArrayLoadFont	btst.b	#$4,$FF800E.l
	bne.b	GateArrayLoadFont
	move.w	#$30,$FF8026.l
	move.l	#$70000003,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop	btst.b	#$3,$FF800E.l
	beq.b	.loop
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop2	btst.b	#$3,$FF800E.l
	bne.b	.loop2
	bclr.b	#$4,$FF800F.l
.loop3	btst.b	#$4,$FF800E.l
	bne.b	.loop3
	move.w	#$31,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop4	btst.b	#$3,$FF800E.l
	beq.b	.loop4
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop5	btst.b	#$3,$FF800E.l
	bne.b	.loop5
	bclr.b	#$4,$FF800F.l
.loop6	btst.b	#$4,$FF800E.l
	bne.b	.loop6
	move.w	#$31,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop7	btst.b	#$3,$FF800E.l
	beq.b	.loop7
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop8	btst.b	#$3,$FF800E.l
	bne.b	.loop8
	bclr.b	#$4,$FF800F.l
	rts
; Countdown timer tick at $EC(a6).
TickTimers	tst.w	$EC(a6)
	bmi.w	.ex
	cmpi.w	#$64,$EC(a6)
	beq.w	.next
	subq.w	#$1,$EC(a6)
	bmi.w	.ex
	clr.l	d0
	move.w	$EC(a6),d0
	cmpi.w	#$18,d0
	bgt.w	.ex
	divu.w	#$3,d0
	swap	d0
	asl.w	#$2,d0
	moveq	#$2,d3
	asl.w	d0,d3
	moveq	#$E,d5
	asl.w	d0,d5
	move.w	d5,d4
	not.w	d4
	move.l	d3,$BBC88.l
	move.l	d4,$BBC8C.l
	move.l	d5,$BBC90.l
	bsr.w	GiveWordRam
.loop	btst.b	#$4,$FF800E.l
	bne.b	.loop
	move.w	#$1D,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop2	btst.b	#$3,$FF800E.l
	beq.b	.loop2
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop3	btst.b	#$3,$FF800E.l
	bne.b	.loop3
	bclr.b	#$4,$FF800F.l
	bsr.w	WaitDmnaSet
.ex	rts
.next	movea.l	#$BBCB0,a1
.loop4	btst.b	#$4,$FF800E.l
	bne.b	.loop4
	move.w	#$30,$FF8026.l
	move.l	#$C0000000,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop5	btst.b	#$3,$FF800E.l
	beq.b	.loop5
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop6	btst.b	#$3,$FF800E.l
	bne.b	.loop6
	bclr.b	#$4,$FF800F.l
	moveq	#$1F,d0
.loop7	btst.b	#$4,$FF800E.l
	bne.b	.loop7
	move.w	#$33,$FF8026.l
	move.l	(a1)+,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop8	btst.b	#$3,$FF800E.l
	beq.b	.loop8
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop9	btst.b	#$3,$FF800E.l
	bne.b	.loop9
	bclr.b	#$4,$FF800F.l
	dbra	d0,.loop7
	st.b	$EC(a6)
	rts
; Decodes pad 1 and computes newly pressed buttons.
UpdatePad1	move.b	$C2(a6),d0
	bsr.w	DecodePadBits
	move.w	$C6(a6),d2
	move.w	d1,$C6(a6)
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
; Decodes pad 2 and computes newly pressed buttons.
UpdatePad2	move.b	$C3(a6),d0
	bsr.w	DecodePadBits
	move.w	$C8(a6),d2
	move.w	d1,$C8(a6)
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
	move.b	$C4(a6),d0
	bsr.w	DecodePadBits
	move.w	$CA(a6),d2
	move.w	d1,$CA(a6)
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
	move.b	$C5(a6),d0
	bsr.w	DecodePadBits
	move.w	$CC(a6),d2
	move.w	d1,$CC(a6)
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
; Inverts the raw pad byte and splits direction and button bits.
DecodePadBits	not.b	d0
	clr.w	d1
	move.b	d0,d1
	move.w	d1,-(sp)
	andi.w	#$F0,d0
	andi.w	#$F,d1
	lea.l	.next(pc),a0
	move.b	(a0,d1.w),d1
	or.w	d1,d0
	move.w	(sp)+,d1
	rts
.next	dc.b	$08,$00,$04,$08,$06,$07,$05,$08,$02,$01,$03,$08,$08,$08,$08,$08	; ................
; Player screen routine
; Reads the pad state into the four direction/button fields
PlReadPadFields	movem.l	d1/a0,-(sp)
	tst.w	$BC(a6)
	beq.w	.next
	bsr.b	.loop
	move.b	d0,$C2(a6)
	bsr.w	.loop4
	move.b	d0,$C3(a6)
	bsr.w	.loop7
	move.b	d0,$C4(a6)
	bsr.w	.loop10
	move.b	d0,$C5(a6)
	bra.w	.next2
.next	bsr.w	.next5
	move.b	d0,$C2(a6)
	bsr.w	.next4
	move.b	d0,$C3(a6)
.next2	movem.l	(sp)+,d1/a0
	rts
.loop	btst.b	#$4,$FF800E.l
	bne.b	.loop
	move.b	#$C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop2	btst.b	#$4,$FF800E.l
	beq.b	.loop2
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop3	btst.b	#$3,$FF800E.l
	bne.b	.loop3
	bclr.b	#$4,$FF800F.l
	bra.w	.next3
.loop4	btst.b	#$4,$FF800E.l
	bne.b	.loop4
	move.b	#$1C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop5	btst.b	#$4,$FF800E.l
	beq.b	.loop5
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop6	btst.b	#$3,$FF800E.l
	bne.b	.loop6
	bclr.b	#$4,$FF800F.l
	bra.w	.next3
.loop7	btst.b	#$4,$FF800E.l
	bne.b	.loop7
	move.b	#$2C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop8	btst.b	#$4,$FF800E.l
	beq.b	.loop8
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop9	btst.b	#$3,$FF800E.l
	bne.b	.loop9
	bclr.b	#$4,$FF800F.l
	bra.w	.next3
.loop10	btst.b	#$4,$FF800E.l
	bne.b	.loop10
	move.b	#$3C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop11	btst.b	#$4,$FF800E.l
	beq.b	.loop11
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop12	btst.b	#$3,$FF800E.l
	bne.b	.loop12
	bclr.b	#$4,$FF800F.l
.next3	movem.l	d1/a0,-(sp)
	bra.w	.next6
.next4	movem.l	d1/a0,-(sp)
	bra.w	.next7
.next5	movem.l	d1/a0,-(sp)
.next6	moveq	#$0,d0
.loop13	btst.b	#$4,$FF800E.l
	bne.b	.loop13
	move.b	#$0,$FF8028.l
	move.w	#$36,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop14	btst.b	#$3,$FF800E.l
	beq.b	.loop14
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop15	btst.b	#$3,$FF800E.l
	bne.b	.loop15
	bclr.b	#$4,$FF800F.l
.loop16	btst.b	#$4,$FF800E.l
	bne.b	.loop16
	move.w	#$37,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop17	btst.b	#$3,$FF800E.l
	beq.b	.loop17
	move.b	$FF8018.l,d0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop18	btst.b	#$3,$FF800E.l
	bne.b	.loop18
	bclr.b	#$4,$FF800F.l
.loop19	btst.b	#$4,$FF800E.l
	bne.b	.loop19
	move.b	#$40,$FF8028.l
	move.w	#$36,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop20	btst.b	#$3,$FF800E.l
	beq.b	.loop20
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop21	btst.b	#$3,$FF800E.l
	bne.b	.loop21
	bclr.b	#$4,$FF800F.l
.loop22	btst.b	#$4,$FF800E.l
	bne.b	.loop22
	move.w	#$37,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop23	btst.b	#$3,$FF800E.l
	beq.b	.loop23
	move.b	$FF8018.l,d1
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop24	btst.b	#$3,$FF800E.l
	bne.b	.loop24
	bclr.b	#$4,$FF800F.l
	dc.w	$6000,$013C
.next7	moveq	#$0,d0
.loop25	btst.b	#$4,$FF800E.l
	bne.b	.loop25
	move.b	#$0,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop26	btst.b	#$4,$FF800E.l
	beq.b	.loop26
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop27	btst.b	#$3,$FF800E.l
	bne.b	.loop27
	bclr.b	#$4,$FF800F.l
.loop28	btst.b	#$4,$FF800E.l
	bne.b	.loop28
	move.w	#$38,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop29	btst.b	#$3,$FF800E.l
	beq.b	.loop29
	move.b	$FF8018.l,d0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop30	btst.b	#$3,$FF800E.l
	bne.b	.loop30
	bclr.b	#$4,$FF800F.l
.loop31	btst.b	#$4,$FF800E.l
	bne.b	.loop31
	move.b	#$40,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop32	btst.b	#$4,$FF800E.l
	beq.b	.loop32
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop33	btst.b	#$3,$FF800E.l
	bne.b	.loop33
	bclr.b	#$4,$FF800F.l
.loop34	btst.b	#$4,$FF800E.l
	bne.b	.loop34
	move.w	#$38,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop35	btst.b	#$3,$FF800E.l
	beq.b	.loop35
	move.b	$FF8018.l,d1
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop36	btst.b	#$3,$FF800E.l
	bne.b	.loop36
	bclr.b	#$4,$FF800F.l
	bra.w	.next8
.next8	asl.b	#$2,d0
	andi.b	#$C0,d0
	andi.b	#$3F,d1
	or.b	d1,d0
	not.b	d0
	not.b	d1
	andi.w	#$F,d1
	lea.l	.next9(pc),a0
	andi.b	#$F0,d0
	or.b	(a0,d1.w),d0
	not.b	d0
	movem.l	(sp)+,d1/a0
	rts
.next9	dc.b	$00,$01,$02,$01,$04,$05,$06,$06,$08,$09,$0A,$0A,$08,$09,$0A,$00	; ................
; Saves the vblank vector and points it at the page handler.
InstallVblankHook	move.l	$6038.w,$D6(a6)
	lea.l	PlVblankMainSync(pc),a0
	move.l	a0,$6038.w
	rts
; Restores the saved vblank vector.
RemoveVblankHook	move.l	$D6(a6),$6038.w
	rts
; Handshake with the main CPU through the gate array
; Vblank hook: handshake with the main CPU through the gate array
PlVblankMainSync	btst.b	#$5,$FF800E.l
	beq.w	.ex
	bset.b	#$2,$FF800F.l
	pea.l	.next(pc)
	move.l	$D2(a6),-(sp)
	rts
.next	bsr.w	PlReadPadFields
.loop	btst.b	#$4,$FF800E.l
	bne.b	.loop
	move.w	#$2F,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop2	btst.b	#$3,$FF800E.l
	beq.b	.loop2
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop3	btst.b	#$3,$FF800E.l
	bne.b	.loop3
	bclr.b	#$4,$FF800F.l
	bclr.b	#$2,$FF800F.l
.ex	rts
; Turns a linear cell index in d0 into a nametable address (40 columns).
TilemapAddr	movem.l	d0-d2/a0-a1/a5,-(sp)
	andi.l	#$FFFF,d0
	divu.w	#$28,d0
	move.w	d0,d2
	lsl.w	#$6,d2
	swap	d0
	add.w	d2,d0
	add.w	d0,d0
	moveq	#$0,d2
	move.w	#$B000,d2
	add.w	d0,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.loop	btst.b	#$7,$FF800E.l
	bne.b	.loop
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop2	btst.b	#$6,$FF800E.l
	beq.b	.loop2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	bne.b	.loop3
	bclr.b	#$7,$FF800F.l
	movea.l	$8E(a6),a5
	bsr.w	PrintTextLine
	movem.l	(sp)+,d0-d2/a0-a1/a5
	rts
; Player screen routine
; Converts a tile index into a VDP write command
PlTileIndexToVdpCmd	movem.l	d0-d2/a0-a1/a5,-(sp)
	andi.l	#$FFFF,d0
	divu.w	#$28,d0
	move.w	d0,d2
	lsl.w	#$7,d2
	swap	d0
	add.w	d2,d0
	add.w	d0,d0
	moveq	#$0,d2
	move.w	$EE(a6),d2
	subi.w	#$2000,d2
	add.w	d0,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.loop	btst.b	#$7,$FF800E.l
	bne.b	.loop
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop2	btst.b	#$6,$FF800E.l
	beq.b	.loop2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	bne.b	.loop3
	bclr.b	#$7,$FF800F.l
	movea.l	$8E(a6),a5
	bsr.w	PrintTextLine
	movem.l	(sp)+,d0-d2/a0-a1/a5
	rts