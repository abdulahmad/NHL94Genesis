.next4
	moveq	#$2,d1
	lea.l	.next5(pc),a0
	cmpi.w	#$2,$180E4.l
	bne.w	.loop2
	move.w	$C(a2),d2
	cmp.w	$C(a1),d2
	beq.w	.loop2
	adda.w	#$6,a0
	bgt.w	.loop2
	adda.w	#$6,a0
.loop2	move.w	(a0)+,d0
	bsr.w	getlinee
	cmpi.w	#$C00,d0
	dbhi	d1,.loop2
	move.w	-(a0),$16(a2)
	bra.w	.loop
.next5	incbin	..\Extracted\SegaCD\HOCKEY\hockey_1A218.bin
ResetAndSelectPlayers						;c1playernum / c2playernum = -1, then changeplayer for each human team
	move.w	#$FFFF,$17F9E.l
	move.w	#$FFFF,$17FA0.l
	tst.w	$17FA6.l
	beq.w	.next
	clr.w	d4
	bsr.w	PassToJump
.next	tst.w	$17FA8.l
	beq.w	.next2
	moveq	#$2,d4
	bsr.w	PassToJump
.next2	tst.w	$17FAA.l
	beq.w	.next3
	move.w	$17FA6.l,-(sp)
	move.w	$17FAA.l,$17FA6.l
	move.w	$17F9E.l,-(sp)
	move.w	#$FFFF,$17F9E.l
	clr.w	d4
	jsr	(PassToJump).l
	move.w	$17F9E.l,$17FA2.l
	move.w	$17FA6.l,$17FAA.l
	move.w	(sp)+,$17F9E.l
	move.w	(sp)+,$17FA6.l
.next3	tst.w	$17FAC.l
	beq.w	.ex
	move.w	$17FA8.l,-(sp)
	move.w	$17FAC.l,$17FA8.l
	move.w	$17FA0.l,-(sp)
	move.w	#$FFFF,$17FA0.l
	move.w	#$2,d4
	jsr	(PassToJump).l
	move.w	$17FA0.l,$17FA4.l
	move.w	$17FA8.l,$17FAC.l
	move.w	(sp)+,$17FA0.l
	move.w	(sp)+,$17FA8.l
.ex	rts
updatefaceoff						;a3 = puck. Drop animation frame from temp1; at 0 erases the faceoff box
	move.w	$40(a3),d0
	beq.w	.erase
	addi.w	#$6,d0
	lsr.w	#$3,d0
	cmpi.w	#$2,d0
	bgt.w	rtss2
	neg.w	d0
	addi.w	#$A,d0
	move.w	d0,$17D00.l
	rts
.erase	bclr	#$4,(disflags).l
	bsr.w	printz
	String	CC_Font1Pri,$0,$0
	move.w	$1746C.l,d0
	subi.w	#$2E,d0
	asr.w	#$3,d0
	move.w	d0,(printx).l
	moveq	#$64,d0
	move.w	$1746E.l,d0
	subi.w	#$44,d0
	asr.w	#$3,d0
	move.w	d0,(printy).l
	moveq	#$C,d0
	moveq	#$D,d1
	move.w	#$7FF,d2
	bra.w	eraser
Endfaceoff						;drop the puck: pick the faceoff winner and send the puck off
	movea.l	#$BBD30,a0
	move.w	$17F66.l,d0
	move.w	$18D32.l,d1
	jsr	(DoDMAProQueue).l
	move.w	#$2F,-(sp)
	bsr.w	sfx
	bclr	#$0,$17F6C.l
	move.w	#$3C,$19374.l
	move.w	$18D56.l,d4
	movea.l	$47D1C.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	bclr	#$2,$17F6C.l
	bclr	#$0,$17F68.l
	bclr	#$0,$63(a3)
	clr.w	$17F82.l
	bset	#$4,$17F6E.l
	move.w	$17EE6.l,d3
	move.w	#$800,d4
	movea.l	#$35A38,a0
	movea.l	#$17CF8,a1
	moveq	#$10,d2
	move.w	(a1),d1
	sub.b	-$1(a0,d1.w),d2
	move.w	$4(a1),d1
	add.b	-$1(a0,d1.w),d2
	moveq	#$21,d0
	bsr.w	randomd0
	cmp.b	d0,d2
	bls.w	.p1won
	adda.w	#$4,a1
.p1won	btst	#$3,$2(a1)
	beq.w	.pos
	move.w	$17EE8.l,d3
	neg.w	d4
.pos	move.w	d3,d0
	btst	#$3,d0
	bne.w	.nojoy
	andi.w	#$7,d0
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	move.w	$FF8010.l,d1
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	andi.w	#$3,d1
	bne.w	.nj2
.nojoy	moveq	#$5,d0
	bsr.w	randomd0
	subi.w	#$2,d0
	andi.w	#$7,d0
	tst.w	d4
	bmi.w	.nj2
	eori.w	#$4,d0
.nj2	asl.w	#$2,d0
	movea.l	#$36B8E,a0
	move.w	(a0,d0.w),d1
	asl.w	#$5,d1
	move.w	d1,$28(a3)
	move.w	$2(a0,d0.w),d1
	asl.w	#$5,d1
	add.w	d4,d1
	move.w	d1,$2A(a3)
	move.w	#$800,d0
	bsr.w	randomd0
	move.w	d0,$2C(a3)
	clr.w	$17B98.l
	bclr	#$2,$62(a3)
	moveq	#$18,d0
	bra.w	assreplace
EndfaceoffTbl1	dc.w	$0008,$1000,$0810
PeriodOver						;what to do if period over. Branched to from puckfaceoff when the clock
									;runs out. After period 3 a tied game goes to
									;overtime (gsp 3), else the game is over (gsp 4); after overtime only a
									;tied playoff game plays on. Falls into PeriodOver_sp
	addi.w	#$1,$180E4.l		;period number
	bchg	#$1,$17F68.l		;flip the attack direction
	cmpi.w	#$3,$180E4.l		;period 3 or later?
	blt.w	.next2
	beq.w	.next		;period 3 just ended
	move.w	#$3,$180E4.l		;overtime done: stay at 3
	tst.w	$18BFA.l
	bne.w	.next
	move.w	#$4,$180E4.l
.next	move.w	$18358.l,d0
	sub.w	$186BE.l,d0
	beq.w	.next2		;tied: play overtime
	move.w	#$4,$180E4.l		;game over
.next2	bsr.w	forceblack
	jsr	(ResetClock).l
	move.w	#$79,-(sp)
	bsr.w	song
	bsr.w	UpdateScores
	cmpi.w	#$4,$180E4.l
	bne.w	.next3
	jsr	(AddPlayoffTeamStats).l
.next3	bsr.w	Intermission
	cmpi.w	#$4,$180E4.l
	beq.w	.next4
	jmp	$2BA1E.l
.next4	jmp	(GameOver).l
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_1AAD4.bin
ClearOffsidesIfAllPlayers						;a2 = team struct: clear the team offsides flag once no skater is past the
	
	btst	#$4,$32(a2)
	beq.w	rtss2
	movea.l	$22(a2),a0
	moveq	#$5,d1
.top	tst.w	$34(a0)
	bmi.w	.next
	move.w	$14(a0),d0
	btst	#$7,$62(a0)
	bne.w	.next
	neg.w	d0
.next	adda.w	#$80,a0
	cmpi.w	#$58,d0
	dbgt	d1,.top
	bgt.w	rtss2
	bclr	#$4,$32(a2)
	rts
a2offsides						;player a2 touched the puck: offsides penalty if his team is flagged and
	
	btst	#$5,$17F68.l
	beq.w	rtss2
	move.w	$17B94.l,d0
	btst	#$7,$62(a2)
	bne.w	.0
	neg.w	d0
.0	cmpi.w	#$68,d0
	blt.w	rtss2
	movea.l	#tmstruct,a0
	btst	#$6,$62(a2)
	beq.w	.1
	adda.w	#$366,a0
.1	btst	#$4,$32(a0)
	beq.w	rtss2
	btst	#$4,$17F68.l
	bne.w	rtss2
	exg.l	a2,a3
	moveq	#$10,d0
	bsr.w	AddPenalty
	exg.l	a2,a3
	rts
a2touchpuck
	move.w	$0(a2),$17ECA.l
	move.w	$14(a2),$17ECC.l
	move.w	$52(a2),$17EC8.l
	movea.l	#tmstruct,a0
	btst	#$6,$62(a2)
	beq.w	.next
	lea.l	$366(a0),a0
.next	clr.w	d0
	move.b	$66(a2),d0
	btst	#$3,$64(a2)
	beq.w	.next2
	bset	#$7,$17F7C.l
.next2	cmp.w	$18(a0),d0
	beq.w	.next4
	bclr	#$3,$32(a0)
	bne.w	.next3
	move.w	$1A(a0),$1C(a0)
	move.w	$18(a0),$1A(a0)
.next3	move.w	d0,$18(a0)
	cmp.w	$1C(a0),d0
	bne.w	.next4
	st.b	$1C(a0)
.next4	bclr	#$4,$17F6C.l
	bsr.w	a2offsides
	btst	#$2,$17ECE.l
	beq.w	.next6
	btst	#$0,$17ECE.l
	beq.w	.next6
	tst.w	$34(a2)
	beq.w	.next6
	btst	#$1,$17ECE.l
	bne.w	.next5
	btst	#$7,$62(a2)
	beq.w	.next6
.loop	clr.w	d0
	move.b	$17ECF.l,d0
	asl.w	#$7,d0
	move.l	a3,-(sp)
	movea.l	#$17480,a3
	adda.w	d0,a3
	move.w	#$C,d0
	bsr.w	AddPenalty
	movea.l	(sp)+,a3
	rts
.next5	btst	#$7,$62(a2)
	beq.w	.loop
.next6	clr.b	$17ECE.l
	move.b	$53(a2),$17ECF.l
	move.w	$17B94.l,d0
	btst	#$7,$62(a2)
	beq.w	.next7
	bset	#$1,$17ECE.l
	neg.w	d0
.next7	bmi.w	rtss2
	move.w	$18372.l,d0
	sub.w	$186D8.l,d0
	btst	#$6,$62(a2)
	beq.w	.next8
	neg.w	d0
.next8	bmi.w	rtss2
	bset	#$2,$17ECE.l
	rts
PuckIChk						;check for icing of puck penalty. Called from pucknorm
	btst	#$2,$17ECE.l
	beq.w	rtss2
	btst	#$0,$17ECE.l
	bne.w	rtss2
	tst.w	$17BE0.l
	bpl.w	rtss2
	move.w	#$108,d0
	btst	#$1,$17ECE.l
	bne.w	.next
	neg.w	d0
	cmp.w	$17B94.l,d0
	bgt.w	.next2
	rts
.next	cmp.w	$17B94.l,d0
	bgt.w	rtss2
.next2	cmpi.w	#$2C,$17B80.l
	bgt.w	.set
	cmpi.w	#$FFD4,$17B80.l
	blt.w	.set
	bclr	#$2,$17ECE.l
	rts
.set	bset	#$0,$17ECE.l
	rts
puckunflip						;stop spinning puck. a3 = puck. Entered from
	
	cmpi.w	#$8,$5A(a3)
	blt.w	.k
	cmpi.w	#$18,$5A(a3)
	bge.w	.k
	eori.w	#$2,$54(a3)
.k	ori.w	#$4,$54(a3)
	clr.w	$5A(a3)
	st.b	$5C(a3)
	rts
puckflip						;start puck spinning. a3 = puck, d0 bit 0 = flip. Called from checkgoal,
	
	andi.w	#$1,d0
	eor.w	d0,$54(a3)
	andi.w	#$3,$54(a3)
	st.b	$5C(a3)
	move.w	#$46A,d1
	bra.w	SetSPA
	dc.w	$0C6B,$018A,$0006,$6600,$002A,$376B,$FF80,$0000
	dc.w	$376B,$FF94,$0014,$426B,$0018,$7014,$0839,$0007
	dc.w	$0001,$7F6A,$6700,$0004,$7000,$0673,$0001,$0000
	dc.b	'NuJk',$00,$06,'g',$00,'`',$B6,'Bk',$00,$00,'7|'
	dc.w	$012C,$0014,$377C,$000E,$0018,$4A6B,$FF94,$6A00
	dc.w	$0012,$377C,$8000,$0004,$446B,$0014,$046B,$0001
	dc.w	$0018,$4E75
findpc						;find puck crossing lines: calculate when puck will cross goalline (if at
	
	
	movem.l	d0-d4/a1-a2,-(sp)
	movea.l	#$17E36,a1
	move.w	#$88,d1
	move.w	#$108,d4
	bsr.w	.calc
	neg.w	d4
	bsr.w	.calc
	movem.l	(sp)+,d0-d4/a1-a2
	rts
.calc	move.w	d4,d0
	sub.w	$17B94.l,d0
	tst.w	$17BAA.l
	beq.w	.nocross
	move.w	d0,d2
	swap	d2
	clr.w	d2
	asr.l	#$4,d2
	divs.w	$17BAA.l,d2
	bmi.w	.nocross
	move.w	d2,$2(a1)
	muls.w	$17BA8.l,d0
	divs.w	$17BAA.l,d0
	bvs.w	.nocross
	add.w	$17B80.l,d0
	cmp.w	d1,d0
	blt.w	.o1
	neg.w	d0
	add.w	d1,d0
	add.w	d1,d0
	add.w	d1,d0
.o1	neg.w	d1
	cmp.w	d1,d0
	bgt.w	.o2
	neg.w	d0
	add.w	d1,d0
	add.w	d1,d0
	add.w	d1,d0
.o2	neg.w	d1
	move.w	d0,(a1)
	bra.w	.next
.nocross	move.w	#$FFFF,$2(a1)
.next	adda.w	#$4,a1		;next puckcross entry (the other goal line)
	rts
