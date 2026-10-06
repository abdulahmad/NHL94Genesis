;	NHL 94 (retail) segment $B0E8-$C70F
;	92 Logic.Asm part 1, as 93 logic93_1.asm: controller input for skaters (doinput ... setpads) and
;	check4bench. assbench (logic94_2) follows at $C710.
;	Transcribed from lst/nhl94.bin.lst lines 35886-37885. Global names are the IDA names, which are the
;	92 / 93 names here, except SetLCmode2 (IDA sub_B92E), setpads (IDA sub_C656) and restorepl (IDA restorep1).
;	Local labels are the IDA local names (_x -> .x, loop -> .loop, even -> .even) or the IDA address
;	(loc_B470 -> .B470, glb_B8AA -> .B8AA).
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp /
;	cmpi; fixopcodes.js patches the cmp encoding after assembly.
;	Inline print strings after printz use the String macro (length word includes itself).
;	SortCords offsets (93 names): Xpos 0, attribute 4, Ypos $14, Xvel $28, Yvel $2A, impact $32, position $34,
;	assnum $36, asslist $38, SCnum $52, facedir $54, SPA $58, SPAnum $5A, nopuck $5E, pflags $62, pflags2 $63.


doinput	;process controller input: d0 = dpad, d1 = new buttons, d2 = changed buttons, d3 = held buttons,
	;d4 = controller 0/2
	btst	#4,d1	;B button
	beq.w	.B106	;branch if not pressed
	btst	#5,d1	;C button
	beq.w	.B106	;branch if not pressed
	bclr	#4,d1
	bset	#6,$64(a3)
	bra.w	.B140
.B106
	btst	#4,d1
	beq.w	.B114
	bclr	#6,$64(a3)
.B114
	btst	#4,d2
	beq.w	.B140
	bclr	#6,$64(a3)
	beq.w	.B140
	tst.w	d4
	bne.w	.B136
	move.b	#$11,(word_FFBF06).w
	bra.w	.B13C
.B136
	move.b	#$11,(word_FFBF06+1).w
.B13C
	bclr	#4,d2
.B140
	btst	#7,(word_FFC2FA).w
	beq.w	.B158
	cmp.b	#8,d0
	beq.w	.B158
	jsr	(sub_FE1AA).l
.B158
	move.w	d0,(word_FFBF12).w
	andi.w	#$F,(word_FFBF12).w
	bsr.w	setpads
	btst	#7,d1	;start button
	beq.w	.B194	;branch if no start button pressed
	tst.w	(joypuckcarrier).w
	bpl.w	.B180
	tst.w	d4
	beq.w	startpause1
	bra.w	startpause2
.B180
	btst	#7,d1
	beq.w	.B194
	tst.w	(joypuckcarrier).w
	beq.w	startpause3
	bra.w	startpause4
.B194
	btst	#7,(sflags).w
	beq.w	.nhor
	btst	#3,d0
	bne.w	.nhor
	addq.w	#2,d0
	andi.w	#7,d0
.nhor
	btst	#0,(sflags2).w
	bne.w	faceoffinput
	btst	#3,$63(a3)
	bne.w	lineinput
	btst	#3,$62(a3)
	beq.w	rtss15
	movem.l	d0-d2/a0/a3,-(sp)
	move.w	(lastplayer).w,d0
	cmp.w	$52(a3),d0
	bne.w	.B240
	tst.w	(passplayer).w
	bmi.w	.B240
	tst.w	(onetimerplayer).w
	bpl.w	.B240
	btst	#5,d1
	beq.w	.B240
	move.w	(passplayer).w,d0
	asl.w	#7,d0
	movea.l	#$FFFFB04A,a3
	adda.w	d0,a3
	tst.w	$34(a3)
	beq.w	.B240
	jsr	(sub_F6C44).l
	beq.w	.B240
	btst	#3,$62(a3)
	bne.w	.B240
	btst	#3,$64(a3)
	bne.w	.B240
	move.w	d4,(inputjoy).w
	move.w	(joypuckcarrier).w,(TmpJoyPuckCarrier).w
	move.w	#$23,d0	;'#'   ; assonetimer
	jsr	(assreplace).l
	movem.l	(sp)+,d0-d2/a0/a3
	rts
.B240
	movem.l	(sp)+,d0-d2/a0/a3
	btst	#3,$64(a3)
	bne.w	.B258
	btst	#5,$62(a3)
	bne.w	loc_B81A
.B258
	btst	#0,$63(a3)	;fighting in progress
	bne.w	fightinput
	move.w	(puckc).w,d5
	cmp.w	$52(a3),d5
	beq.w	loc_B72E
	tst.w	$34(a3)
	beq.w	.B28C
	btst	#3,$64(a3)
	beq.w	.B284
	bra.w	.B28C
.B284
	btst	#6,d1
	bne.w	holdplayer
.B28C
	tst.w	$34(a3)
	beq.w	.B2A2
	btst	#2,(BA_PS_flags).w
	bne.w	.B42E
	bra.w	.B2DA
.B2A2
	btst	#6,(word_FFC2F6).w
	bne.w	.B2DA
	tst.w	d4
	beq.w	.B2BA
	tst.w	(word_FFD05C).w
	bra.w	.B2BE
.B2BA
	tst.w	(word_FFD05A).w
.B2BE
	beq.w	.B2DA
	movem.w	d0,-(sp)
	move.w	$52(a3),d0
	cmp.w	(puckc).w,d0
	movem.w	(sp)+,d0
	beq.w	.B2DA
	bra.w	changeplayer
.B2DA
	btst	#4,d3
	beq.w	.B35C
	tst.w	(word_FFD412).w
	bne.w	.B35C
	tst.w	d4
	beq.w	.B328
	tst.b	(word_FFBF06+1).w
	beq.w	.B42E
	subq.b	#1,(word_FFBF06+1).w
	bpl.w	.B306
	move.b	#0,(word_FFBF06+1).w
.B306
	tst.b	(word_FFBF06+1).w
	bne.w	.B35C
	tst.w	d4
	beq.w	.B31C
	tst.w	(word_FFD05C).w
	bra.w	.B320
.B31C
	tst.w	(word_FFD05A).w
.B320
	bne.w	.B35C
	bra.w	.B3E4
.B328
	tst.b	(word_FFBF06).w
	beq.w	.B42E
	subq.b	#1,(word_FFBF06).w
	bpl.w	.B33E
	move.b	#0,(word_FFBF06).w
.B33E
	tst.w	d4
	beq.w	.B34C
	tst.w	(word_FFD05C).w
	bra.w	.B350
.B34C
	tst.w	(word_FFD05A).w
.B350
	bne.w	.B35C
	tst.b	(word_FFBF06).w
	beq.w	.B3E4
.B35C
	btst	#4,d1
	beq.w	.B37E
	tst.w	d4
	bne.w	.B374
	move.b	#$11,(word_FFBF06).w
	bra.w	.B42E
.B374
	move.b	#$11,(word_FFBF06+1).w
	bra.w	.B42E
.B37E
	btst	#4,d2
	beq.w	.B42E
	btst	#4,d3
	bne.w	.B42E
	move.w	(word_FFBF06).w,d0
	tst.w	d4
	beq.w	.B3C0
	move.b	#$11,(word_FFBF06+1).w
	andi.w	#$FF,d0
	bne.w	changeplayer
	tst.w	d4
	beq.w	.B3B4
	tst.w	(word_FFD05C).w
	bra.w	.B3B8
.B3B4
	tst.w	(word_FFD05A).w
.B3B8
	bne.w	changeplayer
	bra.w	.B3E4
.B3C0
	move.b	#$11,(word_FFBF06).w
	andi.w	#$FF00,d0
	bne.w	changeplayer
	tst.w	d4
	beq.w	.B3DC
	tst.w	(word_FFD05C).w
	bra.w	.B3E0
.B3DC
	tst.w	(word_FFD05A).w
.B3E0
	bne.w	changeplayer
.B3E4
	tst.w	(word_FFD412).w
	bne.w	changeplayer
	move.w	#5,d0
	cmp.w	#5,d6
	ble.w	.B3FC
	move.w	#$B,d0
.B3FC
	jsr	(getGoalieSCnum).l
	tst.w	d0
	bmi.w	rtss15
	movem.l	d0/a3,-(sp)
	movea.l	#$FFFFB04A,a3
	asl.w	#7,d0
	adda.w	d0,a3
	btst	#3,$62(a3)
	movem.l	(sp)+,d0/a3
	bne.w	rtss15
	tst.w	d4
	beq.w	setc1player
	bra.w	setc2player
.B42E
	tst.w	$34(a3)
	bne.w	loc_B6BA
	btst	#6,d1
	beq.w	loc_B470
	move.w	(word_FFBF12).w,d0
	cmp.b	#8,d0
	beq.w	loc_B470
	move.w	d0,$54(a3)
	move.b	#8,$5E(a3)
	move.w	#$2F4,d1	;goalie dive animation
	bsr.w	SetSPA
	bset	#1,$63(a3)
	bset	#5,$62(a3)
	addi.w	#$96,(crowdlevel).w
rtss15
	rts
loc_B470	;IDA name. Global: doinput branches here across the global rtss15
	btst	#5,d1
	bne.w	.B4D0
	btst	#5,d3
	bne.w	.B48A
	bclr	#7,$63(a3)
	bra.w	loc_B616
.B48A
	btst	#7,$63(a3)
	beq.w	loc_B616
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	#$5B1C,a0
	adda.w	$58(a3),a0
	move.w	$54(a3),d0
	btst	#3,4(a3)
	beq.w	.B4B8
	neg.w	d0
	addq.w	#8,d0
	andi.w	#7,d0
.B4B8
	asl.w	#1,d0
	adda.w	0(a0,d0.w),a0
	tst.b	$5B(a3)
	movem.l	(sp)+,d0-d3/a0-a3
	bpl.s	rtss15
	move.w	#$A,$5C(a3)
	rts
.B4D0
	btst	#5,$62(a3)
	bne.w	loc_B616
	movem.w	d0-d1,-(sp)
	move.w	(puckx).w,d0
	sub.w	(a3),d0
	move.w	(pucky).w,d1
	sub.w	$14(a3),d1
	bsr.w	vtoa
	move.w	d0,$54(a3)
	movem.w	(sp)+,d0-d1
	move.w	(word_FFBF12).w,d0
	bclr	#0,(BA_PS_flags).w
	move.w	(gameclock).w,d0
	andi.w	#7,d0
	asl.w	#4,d0
	addi.w	#$A0,d0
	cmpi.w	#$DB,(pucky).w
	bgt.w	.B524
	cmpi.w	#$FF25,(pucky).w
	bgt.w	.B528
.B524
	subi.w	#$40,d0
.B528
	move.w	d0,d1
	muls.w	(puckvx).w,d0
	swap	d0
	add.w	(puckx).w,d0
	muls.w	(puckvy).w,d1
	swap	d1
	add.w	(pucky).w,d1
	bsr.w	sub_B5D8
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	#$384,d0
	bhi.w	.B55E
	movem.w	(sp)+,d0-d1
	bra.w	.B582
.B55E
	bsr.w	sroot
	moveq	#1,d2
	add.w	d0,d2
	moveq	#$12,d4
	btst	#3,(sflags).w
	beq.w	.B574
	addq.w	#8,d4
.B574
	movem.w	(sp)+,d0-d1
	muls.w	d4,d1
	addq.w	#8,d4
	muls.w	d4,d0
	divs.w	d2,d0
	divs.w	d2,d1
.B582
	add.w	d3,d1
	move.w	d1,d2
	cmpi.w	#$22,2(a0)
	cmpi.w	#$18,(a0)
	cmpi.w	#$FFE8,(a0)
	cmpi.w	#$C,2(a0)
	cmpi.w	#$108,(pucky).w
	cmpi.w	#$FEF8,(pucky).w
	bset	#1,$63(a3)
	bne.w	loc_B616
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#$FFFFBEE6,a0	;puckcross
	move.w	#$108,d3
	btst	#7,$62(a3)	;check which net shooting on
	beq.w	.B5CC	;branch if bottom net
	neg.w	d3	;negate d3 (-108 hex)
	addq.w	#4,a0	;puckcross+4 (for bottom goalie)
.B5CC
	jsr	(goaliesave).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_B5D8
	move.w	(puckc).w,d2
	cmp.w	$52(a3),d2
	bne.w	.B5E6
	clr.w	d0
.B5E6
	cmp.w	#$103,d1
	blt.w	.B5F2
	move.w	#$103,d1
.B5F2
	cmp.w	#$FEFD,d1
	bgt.w	.B5FE
	move.w	#$FEFD,d1
.B5FE
	sub.w	d3,d1
	rts
	;$B602: 10 SPA offsets (frames94), no reference in the listing: SPAgglover, SPAgglovel, SPAgstackr, SPAgstackl,
	;SPAgstickr, SPAgstickl (93 goalie saves), then the 94 tables SPA_148E, SPA_14C0, SPA_14F2, SPA_1544
	dc.w	$0146,$0178,$0250,$02A2,$01EC,$021E,$148E,$14C0,$14F2,$1544
loc_B616	;IDA name. Global: doinput branches here across sub_B5D8
	btst	#1,$63(a3)
	beq.w	.B622
	rts
.B622
	tst.w	$34(a3)
	bne.w	doplayeracc
	bclr	#1,(BA_PS_flags).w
	cmpi.w	#$24,(a3)
	ble.w	.B64E
	tst.w	$28(a3)
	bmi.w	.B64E
	beq.w	.B64E
	bset	#1,(BA_PS_flags).w
	clr.w	$28(a3)
.B64E
	cmpi.w	#$FFDC,(a3)
	bge.w	.B668
	tst.w	$28(a3)
	bpl.w	.B668
	bset	#1,(BA_PS_flags).w
	clr.w	$28(a3)
.B668
	cmpi.w	#$E7,$14(a3)
	bgt.w	.B6A8
	cmpi.w	#$FF19,$14(a3)
	ble.w	.B6A8
	bra.w	*+4
.B680
	movem.w	d0-d1,-(sp)
	move.w	$14(a3),d0
	move.w	$2A(a3),d1
	eor.w	d1,d0
	movem.w	(sp)+,d0-d1
	bpl.w	.B6A8
	tst.w	$2A(a3)
	beq.w	.B6A8
	bset	#1,(BA_PS_flags).w
	clr.w	$2A(a3)
.B6A8
	btst	#1,(BA_PS_flags).w
	bne.w	rtss15
	move.w	(word_FFBF12).w,d0
	bra.w	doplayeracc
loc_B6BA	;IDA name. Global: doinput branches here across loc_B616
	move.w	(word_FFBF12).w,d0
	btst	#3,$64(a3)
	bne.w	rtss7
	btst	#5,d1
	beq.w	doplayeracc
	movem.l	d7-a0,-(sp)
	move.w	(lastplayer).w,d7
	asl.w	#7,d7
	movea.l	#$FFFFB04A,a0
	adda.w	d7,a0
	tst.w	$34(a0)
	movem.l	(sp)+,d7-a0
	beq.w	burst
	movem.w	d7,-(sp)
	move.w	$52(a3),d7
	cmp.w	(passplayer).w,d7
	movem.w	(sp)+,d7
	bne.w	burst
	tst.w	(puckc).w
	bpl.w	burst
	jsr	(sub_F6C44).l
	beq.w	burst
	move.w	d0,-(sp)
	move.w	d4,(inputjoy).w
	move.w	(joypuckcarrier).w,(TmpJoyPuckCarrier).w
	move.w	#$23,d0	;'#'   ; assonetimer
	jsr	(assreplace).l
	move.w	(sp)+,d0
	rts
loc_B72E	;IDA name. Global: doinput branches here across loc_B6BA
	bsr.w	checkob
	tst.w	$34(a3)
	bne.w	.B744
	btst	#1,$63(a3)
	bne.w	rtss15
.B744
	btst	#2,(sflags).w
	bne.w	passmode
	btst	#3,(sflags).w
	bne.w	ShotMode
	btst	#4,d1
	beq.w	.B76A
	jsr	(sub_FEE60).l
	bra.w	setpassmode
.B76A
	btst	#6,d1
	beq.w	.B788
	tst.w	d4
	beq.w	.B782
	move.b	#$F,(word_FFD41E+1).w
	bra.w	.B788
.B782
	move.b	#$F,(word_FFD41E).w
.B788
	btst	#6,d3
	beq.w	.B7E2
	tst.w	d4
	beq.w	.B7BC
	subq.b	#1,(word_FFD41E+1).w
	bpl.w	.B7A4
	move.b	#0,(word_FFD41E+1).w
.B7A4
	tst.b	(word_FFD41E+1).w
	bne.w	.B7E2
	bset	#3,(word_FFC2F6).w
	jsr	(setpassmode).l
	bra.w	SetLCmode
.B7BC
	subq.b	#1,(word_FFD41E).w
	bpl.w	.B7CA
	move.b	#0,(word_FFD41E).w
.B7CA
	tst.b	(word_FFD41E).w
	bne.w	.B7E2
	bset	#3,(word_FFC2F6).w
	jsr	(setpassmode).l
	bra.w	SetLCmode
.B7E2
	btst	#6,d3
	bne.w	.B7FC
	btst	#6,d2
	beq.w	.B7FC
	bset	#3,(word_FFC2F6).w
	bra.w	setpassmode
.B7FC
	tst.w	$34(a3)
	bne.w	.B808
	bra.w	doplayeracc
.B808
	btst	#5,d1
	beq.w	doplayeracc
	jsr	(sub_FEE60).l
	bra.w	SetShotMode
loc_B81A	;IDA name. Global: doinput branches here across loc_B72E
	move.w	(puckc).w,d5
	cmp.w	$52(a3),d5
	beq.w	rtss15
	btst	#4,d1
	beq.w	rtss7
	btst	#6,(word_FFC2F6).w
	bne.w	rtss7
	bsr.w	changeplayer
	movem.l	d0/a0,-(sp)
	move.w	(c1playernum).w,d0
	tst.w	d4
	beq.w	.B84E
	move.w	(c2playernum).w,d0
.B84E
	tst.w	d0
	bmi.w	.B864
	asl.w	#7,d0
	movea.l	#$FFFFB04A,a0
	adda.w	d0,a0
	bset	#6,$64(a0)
.B864
	movem.l	(sp)+,d0/a0
rtss7
	rts
; Find goalie SCnum, store in d0
; If no goalie, store FFFF in d0
getGoalieSCnum
	movem.l	d1/a0,-(sp)
	movea.l	#$FFFFB04A,a0
	asl.w	#7,d0
	adda.w	d0,a0
	move.w	#5,d1
.loop
	tst.w	$34(a0)
	beq.w	.goalie
	suba.w	#$80,a0
	dbf	d1,.loop
	move.w	#$FFFF,d0
	bra.w	.end
.goalie
	move.w	$52(a0),d0
.end
	movem.l	(sp)+,d1/a0
	rts
faceoffinput
	btst	#6,(word_FFC2F6).w
	beq.w	.B8AA
	rts
.B8AA
	;move assnum into d4
	move.w	$36(a3),d4
	cmpi.b	#$17,$38(a3,d4.w)	;check if afaceoffpl is in asslist at assnum position
	bne.s	rtss7	;exit if this is not a faceoff player
	movea.w	#(fodir1-M68K_RAM),a0	;faceoff direction of puck control variable
	btst	#7,$62(a3)	;check which goal shooting on
	beq.w	.B8C8	;branch if bottom goal
	movea.w	#(fodir2-M68K_RAM),a0
.B8C8
	;store dpad for faceoff pull
	move.w	d0,(a0)
	btst	#1,$63(a3)	;check if anim in progress
	bne.s	rtss7	;exit if anim in progress
	btst	#4,d1	;test for b button press
	beq.w	.B8E8	;branch if pressed
	move.w	#$FEA,d1	;SPAfaceoff anim
	bset	#1,$63(a3)	;set anim in progress
	bra.w	SetSPA
.B8E8
	;#SPAfaceoffr anim
	move.w	#$1014,d1
	bra.w	SetSPA
fightinput
	rts	;controller processing for fighting
; initiate line change option if available
SetLCmode
	tst.w	(OptLine).w
	bne.w	rtss7
	btst	#4,(byte_FFC2FC).w
	bne.w	rtss7
	bsr.w	loadTeamStruct
	bset	#1,$30(a2)
	bne.w	rtss7
	btst	#3,(word_FFC2F6).w
	bne.w	.B922
	bclr	#2,(sflags).w
.B922
	bclr	#3,(sflags).w
	bset	#3,$63(a3)
SetLCmode2	;IDA: sub_B92E (93 name; 93 IDA showfaceoff). a2 = team struct. Draw the line change box
	bsr.w	setlccords
	cmpi.w	#$F,(printy).w
	blt.w	.B946
	bset	#0,(sflags3).w
	bra.w	.B950
.B946
	jsr	(box).l
	bsr.w	setlccords
.B950
	bsr.w	Framer
	subq.w	#2,(printy).w
.B958
	addq.w	#1,(printx).w
	moveq	#2,d4
.B95E
	move.w	d4,d0
	bsr.w	getlchoice
	tst.w	d0
	bmi.w	.B9AC
	btst	#1,$30(a2)
	bne.w	.B980
	cmp.w	$2E(a2),d4
	bne.w	.B9A8
	move.w	$16(a2),d0
.B980
	movea.w	#(mesarea-M68K_RAM),a1
	move.l	#unk_44120,(a1)
	add.b	d4,2(a1)
	bsr.w	print
	move.w	d0,-(sp)
	movea.l	#FaceOffsprites,a1
	bsr.w	sub_13508
	move.w	(sp)+,d0
	bsr.w	sub_12E66
	subq.w	#5,(printx).w
.B9A8
	subq.w	#1,(printy).w
.B9AC
	dbf	d4,.B95E
	movea.l	$1E(a2),a1
	adda.w	4(a1),a1
	adda.w	(a1),a1
	addq.w	#2,(printx).w
	bra.w	print
setlccords
	clr.w	d0
	cmpa.w	#$C6CE,a2
	bne.w	.B9D0
	eori.w	#$16,d0
.B9D0
	btst	#1,(gmode).w
	beq.w	.B9DE
	eori.w	#$16,d0
.B9DE
	bsr.w	printz
	String	$BF,$16,0,0		;IDA hid this, add.w and moveq in ori.b / ori.b / cmp.b
	add.w	d0,(printy).w
	moveq	#2,d0
	bsr.w	getlchoice
	moveq	#6,d1
	tst.w	d0
	bpl.w	.BA00
	subq.w	#1,d1
	addq.w	#1,(printy).w
.BA00
	moveq	#9,d0
	rts
getlchoice
	movem.l	d1-d2,-(sp)
	move.w	$388(a2),d2
	cmpa.w	#$C6CE,a2
	beq.w	getlchoice2
	move.w	-$340(a2),d2
getlchoice2
	sub.w	$24(a2),d2
	beq.w	.BA2E
	addi.w	#$15,d0
	tst.w	d2
	bmi.w	.BA2E
	addi.w	#$15,d0
.BA2E
	move.w	$16(a2),d1
	add.w	d1,d0
	add.w	d1,d0
	add.w	d1,d0
	lea	.tab(pc),a0
	move.b	0(a0,d0.w),d0
	ext.w	d0
	movem.l	(sp)+,d1-d2
	rts
.tab	dc.b	0
	dc.b	1,2,1,2,0,2,0,1,0,1,2,0,1,2,0,1
	dc.b	2,0,1,2,3,4,$FF,3,4,$FF,3,4,$FF,3,4,$FF
	dc.b	4,3,$FF,3,4,$FF,3,4,$FF,5,6,$FF,5,6,$FF,5
	dc.b	6,$FF,5,6,$FF,5,6,$FF,5,6,$FF,6,5,$FF,$FF
; process input for line changes
; d1 = new button presses
lineinput
	btst	#3,(word_FFC2F6).w
	beq.w	.BAA0
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(passmode).l
	movem.l	(sp)+,d0-d7/a0-a6
.BAA0
	move.w	d1,-(sp)
	movea.w	#(HmShots-M68K_RAM),a2
	btst	#6,$62(a3)
	beq.w	.BAB4
	adda.w	#$364,a2
.BAB4
	bclr	#0,$30(a2)
	beq.w	.BAC6
	bsr.w	lcfound2
	bsr.w	SetLCmode2
.BAC6
	move.w	(sp)+,d1
	clr.w	d2
	btst	#6,d1
	bne.w	lcfound
	addq.w	#1,d2
	btst	#4,d1
	bne.w	lcfound
	addq.w	#1,d2
	btst	#5,d1
	bne.w	lcfound
	btst	#3,$62(a3)
	beq.w	.BB04
	btst	#5,$62(a3)
	bne.w	.BB04
	btst	#0,$63(a3)
	beq.w	doplayeracc
.BB04
	rts
; d2 = choice made 0-2
lcfound
	move.w	d2,d0
	move.w	d2,$2E(a2)
	bsr.w	getlchoice	;translate choice 0-2 into line number 0-6
	tst.w	d0
	bmi.w	rtss8
	bclr	#3,$63(a3)
	bset	#3,$62(a3)
	bsr.w	loadTeamStruct
	bclr	#1,$30(a2)
	move.w	d0,$16(a2)
	jsr	(SetPersonel).l
lcfound2
	btst	#7,(sflags).w
	bne.w	rtss
	bsr.w	setlccords
	cmpi.w	#$F,(printy).w
	blt.w	.nollcm
	bclr	#0,(sflags3).w
.nollcm
	addq.w	#1,d1
	move.w	#$7FF,d2
	bsr.w	eraser
	bra.w	PrintScores1
; c button press check/speed
burst
	jsr	(getpde).l	;get players energy
	tst.w	(OptLine).w
	bne.w	.0
	subi.w	#$CC,d0
	jsr	(setpde).l	;decrease players energy
	btst	#4,(byte_FFC2FC).w
	beq.w	.0
	move.w	#$1000,d0
.0
	lsr.w	#7,d0	;d0 will be $1000 with lines off
	;d0 / 64 will be 20 hex if max energy
	move.w	d0,d1	;energy = speed increase (check violence)
	move.w	$54(a3),d2	;facedir
	asl.w	#2,d2
	movea.l	#dirtab,a0
	muls.w	0(a0,d2.w),d0
	muls.w	2(a0,d2.w),d1
	add.w	d0,$28(a3)	;add to X Vel
	add.w	d1,$2A(a3)	;add to Y Vel
	bset	#5,$62(a3)	;lock in this animation
	move.w	#$C5E,d1	;#SPAburst
	bra.w	SetSPA
; A button press hold
; CPU hold jumps in at Acheck
;
; a3 = holder
; a0 = player being held
holdplayer
	bset	#5,$62(a3)	;lock animation
	move.w	#$1122,d1	;move anim into d1 - normal hold check
	tst.w	$32(a3)	;check if impact = 0
	beq.w	SetSPA	;set anim if 0
	movea.w	#(SortCords-M68K_RAM),a0	;move SortCord into a0
	move.w	$2E(a3),d0	;move last impact player into d0
	asl.w	#7,d0	;calc offset
	adda.w	d0,a0	;add offset to a0
Acheck
	bset	#5,$62(a3)	;lock animation
	move.w	#$1122,d1	;move anim into d1 - normal hold check
	tst.w	$32(a3)	;check if impact = 0
	beq.w	.ex	;branch if 0
	move.w	$14(a3),d0	;move Ypos checker into d0
	sub.w	$14(a0),d0	;sub Ypos of player
	btst	#7,$62(a3)	;check goal checker is shooting at
	beq.w	.air	;jump if bottom
	neg.w	d0	;make d0 negative
.air
	bmi.w	.ex
	move.w	#$C90,d1	;set anim - hold check stick in air
.ex
	bra.w	SetSPA
; initialize pass mode
setpassmode
	move.w	$54(a3),(passdir).w	;facedir, default pass direction
	andi.w	#7,(passdir).w	;Passes first 3 bits of passdir
	btst	#2,(BA_PS_flags).w
	beq.w	.BC38
	bclr	#2,(word_FFC2FA).w
	bset	#5,(BA_PS_flags).w
	bne.w	rtss7
	bclr	#5,(word_FFC2FA).w
	move.w	#$64,(word_FFC31C).w
.BC38
	bset	#2,(sflags).w	;#sfspdir - set pass dir mode
rtss
	rts
; start passing sequence
passmode
	btst	#4,d2	;has b button changed?
	bne.w	dopass	;yes
	btst	#3,(word_FFC2F6).w	;Not in NHL Hockey Source
	bne.w	dopass
	btst	#3,d0	;look for dpad
	bne.s	rtss
	andi.w	#7,d0	;pass first 3 bits of d0
	move.w	d0,(passdir).w	;new pass dir
	bset	#3,d0
dopass
	movem.l	d0-d5/a0-a1,-(sp)
	bclr	#2,(sflags).w	;#sfspdir
	st	(puckc).w	;player is not puck handler anymore
	move.b	#$10,$5E(a3)	;$5E = nopuck
	move.w	$52(a3),(lastplayer).w	;$52 = offset of player on ice
	bclr	#3,(word_FFC2F6).w	;Not in NHL Hockey Source
	beq.w	.BCAE
	jsr	(sub_F67E4).l
	move.w	#$12,(word_FFD418).w
	btst	#2,(word_FFC2F8).w
	beq.w	.BCA4
	move.w	#$3A,(word_FFD418).w
.BCA4
	jsr	(sub_F6778).l
	bra.w	.exit
.BCAE
	moveq	#8,d0	;moves 8 into d0
	tst.w	$34(a3)	;checks if goalie
	beq.w	.calc	;jump if goalie
.LoadPassAttribForPassStart
	;Passacc
	move.b	$6E(a3),d0
.calc
	asl.w	#2,d0	;d0 = passacc for player, 8 for goalie
	asr.w	#1,d0	;change from NHL Hockey Source,
	;because max passacc can be 30
	;(15 in 92)
	addi.w	#$A0,d0
	move.w	d0,(passspeed).w	;Passspeed = PassAcc (0 to 30 decimal) * 2 + A0 (160 decimal)
	btst	#0,$6E(a3)	;Checks to see if bit 0 in Passacc is 0
	beq.w	.findplayer	;Jumps if 0 (even number)
	asr.w	#4,d0	;divide d0 by 16
	add.w	d0,(passspeed).w	;add d0 to passspeed
.findplayer
	moveq	#-1,d4	;look for closest and best player to pass to
	moveq	#5,d3	;Set total number of players (6 total, set to 5)
	movea.w	#(SortCords-M68K_RAM),a1	;B04A - Start of Home Players on Ice Arrays
	cmpi.w	#6,$52(a3)	;compares 6 to offset 52 from a3 (current player with puck) to check if player is away team or home team
	blt.w	.0	;Jump if player is Home, continue if Away
	adda.w	#$300,a1	;Switch to Away Team Players
	btst	#2,(BA_PS_flags).w
	bne.w	.nopp
.0
	cmpa.l	a1,a3	;Check to see if passing to self
	beq.w	.next	;skip if this is passing player
	tst.w	$34(a1)	;position(a1)
	beq.w	.next	;skip if goalie
	btst	#2,$63(a1)	;check if player is unavailable
	bne.w	.next	;player unavailable
	move.w	(a1),d0	;X Position of receiving player
	sub.w	(puckx).w,d0	;sub puckx from d0
	move.w	$14(a1),d1	;Y position of receiving player
	sub.w	(pucky).w,d1	;sub pucky from d1
	movem.w	d0-d1,-(sp)	;push to stack
	bsr.w	vtoa	;get direction of pass in d0
	movem.w	(sp)+,d1-d2	;pop from stack d1 is dX, d2 is dY
	sub.w	(passdir).w,d0	;sub passdir from d0
	andi.w	#7,d0	;pass only lower 3 bits in d0
	asl.b	#5,d0	;Multiply d0 by 32 (224 decimal is max)
	ext.w	d0	;sign extend d0 byte to d0 word
	asl.w	#3,d0	;mult d0 by 8 (700 decimal max)
	muls.w	d0,d0	;square d0 = max is 490000 decimal
	cmp.l	#$10000,d0		;compare to 65536 decimal (IDA #256^2: power, SNASM ^ is xor)
	bhi.w	.next	;if higher branch to next
	muls.w	d1,d1	;square d1 (dX)
	muls.w	d2,d2	;square d2 (dY)
	add.l	d1,d2	;add together
	add.l	d0,d2	;add modified passdir to d2
	cmp.l	d4,d2	;compare d4 to d2
	bhi.w	.next	;branch if higher (player is farther away than the closest player)
	move.l	d2,d4	;move d2 into d4
	movea.l	a1,a0	;move a1 address into a0 (receiving player)
.next
	adda.w	#$80,a1	;Skip to next player (80 hex is length of player struct)
	dbf	d3,.0
	tst.l	d4	;check if there's a player to pass to
	bmi.w	.nopp	;skip if no player to pass to
	bsr.w	passto
	bra.w	.exit
.nopp
	move.w	(passdir).w,d0	;just hit puck in pass dir not to any player
	asl.w	#2,d0
	movea.l	#dirtab,a0
	move.w	2(a0,d0.w),d1	;y inc
	muls.w	(passspeed).w,d1
	moveq	#$A,d2
	asl.l	d2,d1
	divs.w	#$BB8,d1	;#runspeed * 15
	add.w	$2A(a3),d1	;Yvel
	move.w	d1,(puckvy).w
	move.w	0(a0,d0.w),d1	;X inc
	muls.w	(passspeed).w,d1
	asl.l	d2,d1
	divs.w	#$BB8,d1	;#runspeed * 15
	add.w	$28(a3),d1	;Xvel
	move.w	d1,(puckvx).w
	move.w	#$1000,d0
	bsr.w	randomd0
	move.w	d0,(puckvz).w
.exit
	tst.w	$34(a3)	;$34 = position
	bne.w	.notgoalie
	tst.w	(puckvy).w
	btst	#7,$62(a3)	;$62 = pflags Checks for what goal team is shooting at (0=bottom, 1=top)
	beq.w	.g0
	bmi.w	.nvy
	bra.w	.notgoalie
.g0
	bmi.w	.notgoalie
.nvy
	neg.w	(puckvy).w	;negative velocity on puck
.notgoalie
	move.w	(puckvx).w,d0
	move.w	(puckvy).w,d1
	bsr.w	vtoa
	move.w	#$366,d1	;#SPAgswing Note: SPA = Sprite Animation
	tst.w	$34(a3)	;$34 = position
	beq.w	.e1	;goalie anim.
	move.w	#$718,d1	;#SPApassf
	bsr.w	Findhittype
	beq.w	.e1
	move.w	#$78A,d1	;#SPApassb
.e1
	bsr.w	SetSPA
	bset	#5,$62(a3)	;#pfalock, $62 = pflags
	moveq	#$C,d0	;Rest to rts, not in NHL Hockey Source
	;Used to make puck sound
	sub.b	(puckvz).w,d0
	lsr.w	#2,d0
	andi.w	#3,d0
	addi.w	#$10,d0
	move.w	d0,-(sp)	;#SFXpass
	bsr.w	sfx
	movem.l	(sp)+,d0-d5/a0-a1
	rts
; pass puck to player a0
; a3 = passer
passto
	btst	#3,$62(a3)
	beq.w	passtoa0
	tst.w	$34(a3)
	bne.w	passtoa0
	movem.l	d0-d1,-(sp)
	btst	#3,$62(a0)
	bne.w	.stack
	bset	#6,$64(a0)	;pflags3 bit 6
	move.w	(cont1team).w,d1
	cmp.w	(cont2team).w,d1	;checks to see if 2 player co-op (on same team)
	bne.w	.h2hor1p
	move.w	$52(a0),d0	;SCnum of receiver into d0
	move.w	$52(a3),d1	;SCnum of passer into d1
	cmp.w	(c1playernum).w,d1	;checks if cont 1 controlling passer
	bne.w	.p2passing
	jsr	(setc1player).l
	bra.w	.stack
.p2passing
	jsr	(setc2player).l
	bra.w	.stack
.h2hor1p
	move.w	#1,d1
	btst	#6,$62(a3)	;check if home or away team
	beq.w	.BE8E	;branch if home
	move.w	#2,d1	;away team
.BE8E
	move.w	$52(a0),d0	;move SCnum of receiver into d0
	cmp.w	(cont1team).w,d1	;compare cont1 team with d1 (1=home, 2=away)
	bne.w	.diffteam
	jsr	(setc1player).l
	bra.w	.stack
.diffteam
	jsr	(setc2player).l
.stack
	movem.l	(sp)+,d0-d1
passtoa0
	bsr.w	loadTeamStruct
	addq.w	#1,$12(a2)	;add 1 to total pass attempts
	move.w	$52(a0),(passplayer).w	;Moves index number for a0 player
	move.w	(passspeed).w,d5	;passspeed = pix/sec
	asr.w	#2,d5	;divides pass speed by 4
	exg	a0,a3	;tell pass recipient to get puck - swaps a3 and a0 for assinsert
	move.l	#$13,d0	;#apassrec - assignment for receiving pass
	bsr.w	assinsert
	exg	a0,a3
	move.l	a0,-(sp)	;This routine uses passspeed and player's a0 x/y speed to determine the x/y velocity of the puck so it will meet player a0
	bsr.w	GetHot
	add.w	(a0),d0	;Xpos
	sub.w	(puckx).w,d0
	add.w	$14(a0),d1	;Ypos
	sub.w	(pucky).w,d1
	movem.w	d0-d1,-(sp)
	movem.w	(sp),d2-d3	;pop d0-d1 off into d2-d3
	asr.w	#2,d2	;d2 divide by 4
	asr.w	#2,d3	;d3 divide by 4
	move.w	$28(a0),d0	;Xvel
	muls.w	#$F0,d0	;#(16 * 60)/4 = $F0 xpix / (1/4) sec
	swap	d0	;swap upper and lower bytes
	move.w	$2A(a0),d1	;Yvel
	muls.w	#$F0,d1
	swap	d1	;swap upper and lower bytes
	movem.w	d0-d1,-(sp)	;push on stack
	muls.w	d2,d0	;d0 = (d2 = Xpos puck / 4) * d0 (x pix per 1/4 sec)
	muls.w	d3,d1	;d1 = (d3 = Ypos puck /4) * d1 (y pix per 1/4 sec)
	add.w	d1,d0	;add d1 to d0
	asl.w	#1,d0	;d0 mult by 2
	move.w	d0,d4	;j = move d0 into d4
	movem.w	(sp),d0-d1	;pop d0 and d1 off stack
	muls.w	d0,d0	;(x pix per 1/4 sec)^2
	muls.w	d1,d1	;(y pix per 1/4 sec)^2
	muls.w	d5,d5	;passspeed^2
	neg.l	d5	;negative d5
	add.l	d0,d5	;add d0 to d5
	add.l	d1,d5	;k = add d1 to d5
	muls.w	d2,d2
	muls.w	d3,d3
	add.l	d2,d3	;a^2 = add d2 to d3
	muls.w	d5,d3	;multiply k * a^2
	asl.l	#2,d3	;divide by 4
	move.w	d4,d0	;d0 = j
	muls.w	d0,d0	;j^2
	sub.l	d3,d0	;j^2 - ((k*a^2)/4)
	bsr.w	sroot	;square root of d0
	moveq	#1,d3	;limit infinite loop
	asr.w	#2,d5	;k divide by 4
	bne.w	.0
	moveq	#1,d5	;no div by zero
.0
	move.w	d0,d2
	neg.w	d0
	sub.w	d4,d2
	ext.l	d2
	divs.w	d5,d2
	dbpl	d3,.0
	bne.w	.1
	addq.w	#1,d2	;can't be zero
.1
	cmp.w	#$18,d2	;limit to 3 sec.
	bls.w	.2
	moveq	#$18,d2	;d2 = time in 1/8 sec to intersection
.2
	move.b	d2,(puckvz).w
	cmp.w	#$C,d2
	blt.w	.3
	move.b	#$C,(puckvz).w
.3
	move.w	d2,d0
	asl.w	#3,d0
	subi.w	#$A,d0	;only subtract #6 in NHL Hockey
	move.b	d0,$40(a0)	;$40 = temp1
	subq.w	#6,d0	;sub. #10 in NHL Hockey
	move.b	d0,(puckx_nopuck).w
	movem.w	(sp)+,d0-d1
	muls.w	d2,d0
	asr.l	#1,d0
	add.w	(sp)+,d0	;x distance
	move.w	(puckx).w,$44(a0)
	add.w	d0,$44(a0)	;$44 = temp3
	muls.w	d2,d1
	asr.l	#1,d1
	add.w	(sp)+,d1	;y distance
	move.w	(pucky).w,$46(a0)
	add.w	d1,$46(a0)	;$46 = temp4
	mulu.w	#$78,d2	;'x'   ; $78 = 60*2
	swap	d0
	divs.w	d2,d0
	move.w	d0,(puckvx).w
	swap	d1
	divs.w	d2,d1
	move.w	d1,(puckvy).w
	rts
; Attributes: thunk
changeplayer
	jmp	chgplayer
	bne.w	.C0AC
	movem.l	d0-d6/a0-a1,-(sp)
	move.w	(puckvx).w,d0
	asr.w	#8,d0
	add.w	(puckx).w,d0
	move.w	(puckvy).w,d1
	asr.w	#8,d1
	add.w	(pucky).w,d1
	movem.w	d0-d1,-(sp)
	moveq	#5,d2
	move.w	d4,d3
	eori.w	#2,d3
	moveq	#-1,d5
	movea.w	#(SortCords-M68K_RAM),a0
	movea.w	#(cont1team-M68K_RAM),a1
	cmpi.w	#1,0(a1,d4.w)
	beq.w	.C002
	adda.w	#$300,a0
.C002
	movea.w	#(c1playernum-M68K_RAM),a1
.C006
	tst.w	$34(a0)
	ble.w	.C084
	btst	#2,$63(a0)
	bne.w	.C084
	btst	#3,$62(a0)
	bne.w	.C084
	btst	#2,(BA_PS_flags).w
	beq.w	.C054
	movem.l	d0,-(sp)
	move.w	(BA_Sktr_SCnum).w,d0
	cmp.w	$52(a0),d0
	movem.l	(sp)+,d0
	beq.w	.C054
	movem.l	d0,-(sp)
	move.w	(BA_Goalie_SCnum).w,d0
	cmp.w	$52(a0),d0
	movem.l	(sp)+,d0
	bne.w	.C084
.C054
	btst	#5,$62(a0)
	bne.w	.C084
	movem.w	(sp),d0-d1
	sub.w	(a0),d0
	muls.w	d0,d0
	sub.w	$14(a0),d1
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	d5,d0
	bhi.w	.C084
	move.w	$52(a0),d1
	cmp.w	0(a1,d3.w),d1
	beq.w	.C084
	move.l	d0,d5
	move.w	d1,d6
.C084
	adda.w	#$80,a0
	dbf	d2,.C006
	addq.w	#4,sp
	pea	(.C0A8).l
	cmp.w	0(a1,d4.w),d6
	beq.w	Sweepcheck
	move.w	d6,d0
	tst.w	d4
	beq.w	setc1player
	bra.w	setc2player
.C0A8
	movem.l	(sp)+,d0-d6/a0-a1
.C0AC
	rts
Sweepcheck
	bset	#5,$62(a3)
	move.w	#$B24,d1
	bra.w	SetSPA
; restore old player and switch to new d0 player on cont. 1
setc1player
	cmp.w	(c1playernum).w,d0
	beq.w	.ex
	movem.l	d1/a0-a1,-(sp)
	move.w	(c1playernum).w,d1
	bsr.w	restorepl
	move.w	d0,(c1playernum).w
	movem.l	(sp)+,d1/a0-a1
.ex
	rts
; restore old player and switch to new d0 player on cont. 2
setc2player
	cmp.w	(c2playernum).w,d0
	beq.w	.ex
	movem.l	d1/a0-a1,-(sp)
	move.w	(c2playernum).w,d1
	bsr.w	restorepl
	move.w	d0,(c2playernum).w
	movem.l	(sp)+,d1/a0-a1
.ex
	rts
; d1 = old player
restorepl	;IDA: restorep1 (93 restorepl)
	movea.w	#(SortCords-M68K_RAM),a0
	tst.w	d1
	blt.w	.spd
	cmp.w	#$B,d1
	bgt.w	.spd
	asl.w	#7,d1	;multiply d0 by 80 hex (SCsize)
	btst	#3,$63(a0,d1.w)	;#pfnp - no joystick pad
	beq.w	.cont
	lsr.w	#7,d1	;divide by 80 hex
	move.w	d1,d0
	rts
.cont
	bclr	#3,$62(a0,d1.w)	;#pfjoycon
	btst	#3,$64(a0,d1.w)	;bit 3, pflags3
	bne.w	.spd
	bset	#1,$62(a0,d1.w)	;#pfna - new assignment
.spd
	tst.w	d0	;checks if d0 0 or higher
	blt.w	.ex
	cmp.w	#$B,d0	;checks if d0 11 or less
	bgt.w	.ex
	move.w	d0,d1	;copies d0 into d1
	asl.w	#7,d1
	btst	#2,(BA_PS_flags).w
	bne.w	.chkgoalie
	btst	#0,(word_FFC2FA).w
	beq.w	.C190
.chkgoalie	;IDA: chkgoalie. Local: only restorepl uses it, and a global here would split restorepl
	tst.w	$34(a0,d1.w)
	bne.w	.C190
	btst	#6,$62(a0,d1.w)	;check if home or away
	beq.w	.C172
	tst.w	(word_FFD05C).w
	bra.w	.C176
.C172
	tst.w	(word_FFD05A).w
.C176
	beq.w	.C190
	move.w	#0,d0	;first position of home SCNum
	btst	#6,$62(a0,d1.w)	;check if home or away
	beq.w	.C18C
	move.w	#6,d0	;first position of away SCNum
.C18C
	bra.w	.ex
.C190
	bset	#3,$62(a0,d1.w)	;set pfjoycon for SCNum
.ex
	rts
; look for type of swing (forehand or backhand)
; input d0 = launch dir
Findhittype
	neg.w	d0
	add.w	$54(a3),d0	;facedir
	andi.w	#7,d0
	btst	#3,4(a3)	;attribute bit 3
	beq.w	.C1B2
	btst	d0,#$F0			;%11110000: beq forehand, bne backhand. IDA cannot show btst Dn,#imm
	rts
.C1B2	btst	d0,#$1E			;%00011110
	rts
; initiate shot by player a3
SetShotMode
	btst	#2,(BA_PS_flags).w	;check for PS or SO
	beq.w	.start	;branch if not
	bclr	#2,(word_FFC2FA).w
	bset	#5,(BA_PS_flags).w
	bne.w	rtss7
	bclr	#5,(word_FFC2FA).w
	move.w	#$64,(word_FFC31C).w
.start
	move.w	#8,(passdir).w	;default shot direction
	bset	#3,(sflags).w	;#sfssdir
	clr.w	d0	;find dx/dy for shot
	move.w	#$128,d1	;#296 = top Y boards
	btst	#7,$62(a3)	;#pfgoal - which goal to shoot on
	bne.w	.ck0	;branch if top goal
	neg.w	d1	;flip if bottom goal
.ck0
	sub.w	(a3),d0	;Sub Xpos of player from d0. d0 starts as 0 (middle of rink in X)
	sub.w	$14(a3),d1	;Sub Ypos of player from Y boards
	bsr.w	vtoa
	move.w	#$F,(passspeed).w
	move.w	#$7FC,d1	;#SPAshotf
	bsr.s	Findhittype
	beq.w	.ck1
	move.w	#$92E,d1	;#SPAshotb
	move.w	#$F,(passspeed).w	;minimum shot speed
.ck1
	bra.w	SetSPA
; shot input
ShotMode
	cmpi.w	#$1C,$5A(a3)
	bge.w	prepshot	;end of animation so shoot
	btst	#3,d0	;checks dpad for direction
	bne.w	.ss0
	andi.w	#7,d0	;pass the first 3 bits of d0
	move.w	d0,(passdir).w	;set shot direction
.ss0
	cmpi.w	#$10,$5A(a3)
	bge.w	.end	;past full windup so no more passspeed
	add.w	d7,(passspeed).w
	cmpi.b	#$14,$6C(a3)	;6C = shot speed
	bge.w	.checkcbut
	cmpi.w	#8,$5A(a3)	;SPANum
	bgt.w	.chganim
.checkcbut
	btst	#5,d2	;5 = #cbut
	beq.w	.end	;button hasnt changed so continue windup
.chganim
	neg.w	$5A(a3)	;end windup and swing through
	addi.w	#$1C,$5A(a3)	;Add to SPANum
.end
	rts
; Check certain conditions before shooting
prepshot
	bclr	#4,(word_FFC2F6).w
	move.w	#$B,d0
	btst	#6,$62(a3)	;check if home or away
	beq.w	.getGoalie	;gets opponents Goalie SCnum
	move.w	#5,d0	;opponent is home
.getGoalie
	jsr	(getGoalieSCnum).l
	tst.w	d0
	bmi.w	.nogoalie
	movem.l	a0,-(sp)
	asl.w	#7,d0
	movea.l	#$FFFFB04A,a0
	cmpi.w	#$250,$58(a0,d0.w)	;Checking goalie animations - pad stack right
	beq.w	.svgoalie
	cmpi.w	#$2A2,$58(a0,d0.w)	;Checking another goalie animation - pad stack left
.svgoalie
	movem.l	(sp)+,a0	;pop stack value into a0
	bne.w	.cont
.nogoalie
	cmpi.w	#1,(passdir).w
	ble.w	.dir017	;branch if passdir is 0 or 1
	cmpi.w	#7,(passdir).w
	bne.w	.cont	;branch if passdir is not 7
.dir017
	move.w	(pucky).w,d0
	btst	#7,$62(a3)	;#pfgoal - goal to shoot at (0=bottom, 1=top)
	bne.w	.cmppuck	;branch if top
	neg.w	d0	;flips d0 for compare calc
.cmppuck
	cmp.w	#$D8,d0	;compares location of puck
	blt.w	.cont
	bset	#4,(word_FFC2F6).w	;set flag for in-close top shelf shooting
.cont
	bra.w	*+4
; stick is at puck so launch puck toward goal
; a3 = shooter
doshot
	movem.l	d0-d7/a0-a3,-(sp)
	bclr	#4,(word_FFC2FA).w
	btst	#1,$64(a3)	;check if player on breakaway
	beq.w	.cont
	bset	#4,(word_FFC2FA).w	;set if breakaway
.cont
	bsr.w	shotdiradj
	move.w	#5,-(sp)	;#SFXshotwiff - sound effect
	move.w	$52(a3),(shotplayer).w
	bclr	#3,(sflags).w	;#sfssdir - shot direction mode
	bset	#5,$62(a3)	;#pfalock
	btst	#3,$64(a3)	;check if shooting one timer
	bne.w	.shottype	;jump if yes
	move.w	(puckc).w,d0	;puck carrier SCnum into d0
	cmp.w	$52(a3),d0	;is player puck carrier?
	bne.w	.ex	;wiffed shot
.shottype
	move.w	#$18,(sp)	;#SFXshotfh
	bset	#4,(sflags2).w	;#sf2shot - shot was taken
	cmpi.w	#$92E,$58(a3)	;#SPAshotb
	bne.w	.nbh	;no backhand
	move.w	#$14,(sp)	;#SFXshotbh
	move.w	(passspeed).w,d0
	lsr.w	#2,d0	;sub 25% for backhand shots
	sub.w	d0,(passspeed).w
.nbh
	btst	#3,$64(a3)	;check if shooting one timer
	beq.w	.cont2	;jump if not
	movem.l	d0-d1,-(sp)	;push d0-d1 on stack
	move.w	#$1F,d0	;1F into d0 - one timer min speed
	move.w	d0,(passspeed).w	;make passspeed start with a higher value
	movem.l	(sp)+,d0-d1	;Pop off stack d0-d1
.cont2
	clr.w	d0
	move.b	$6C(a3),d0	;6C = shotspd (ShP)
	lsr.b	#1,d0	;divide by 2
	movea.l	a3,a0	;move a3 address into a0
	jsr	(makepde).l	;scale d0 based on energy level
	addi.w	#$14,d0	;add 14 to d0
	mulu.w	(passspeed).w,d0	;shot speed ranged by energy level
	mulu.w	#$5249,d0	;($4000*45)/35
	swap	d0	;swaps the upper and lower words of d0
	move.w	d0,(passspeed).w	;move d0 into passspeed
	btst	#0,$6C(a3)	;checks if ShP value is even or odd
	beq.w	.even
	asr.w	#4,d0	;divide by 16
	add.w	(passspeed).w,d0	;add passspeed to d0
.even
	lsr.w	#4,d0	;divide by 16 (d0 is passspeed)
	neg.w	d0	;negative
	addq.w	#3,d0	;add 3 to d0
	bpl.w	.nbh2
	clr.w	d0	;clear if negative
.nbh2
	add.w	d0,(sp)	;add to stack current value (Shot SFX)
	st	(puckc).w	;clear puck carrier
	move.b	#$10,$5E(a3)	;5E = nopuck - no puck collision till 0
	move.w	$52(a3),(lastplayer).w	;SCNum
	move.w	#$108,d1	;$108 = top goal line Y position
	btst	#7,$62(a3)	;pfgoal, pflags
	bne.w	.0	;branch if shooting up
	neg.w	d1	;flip d1 if shooting down
.0
	move.w	(passdir).w,d2	;passdir into d2
	asl.w	#2,d2	;mult by 4
	lea	shotsets(pc),a0	;table of shot directions
	move.w	0(a0,d2.w),d0	;xoffset
	move.w	2(a0,d2.w),d2	;z offset
	sub.w	(puckx).w,d0
	sub.w	(pucky).w,d1
	movem.w	d0-d2,-(sp)	;push d0-d2(dx,dy,z offset) on stack
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	bsr.w	sroot
	tst.w	d0	;distance in pix to goal
	bne.w	.1
	addq.w	#1,d0
.1
	move.w	d0,d3	;straight line distance from puck to spot aiming for with passdir
	btst	#4,(gmode).w	;check if highlight (always perfect)
	bne.w	.perf
	cmp.w	#$C8,d3	;C8 = 200 decimal
	bhi.w	.notperf	;too far away from perfect shot
	jsr	(ReadGoaliePulled).l	;checks if shooting team's G pulled
	bmi.w	.perf	;perfect shot with pulled goalie
	btst	#0,(word_FFC2FA).w	;check if shootout
	bne.w	.perf	;perfect shot in shootout
	moveq	#$10,d0	;start value for ShA calc
	add.b	$6D(a3),d0	;shotacc(a3)
	bsr.w	randomd0
	cmp.w	#$E,d0	;chance of perfect shot
	bgt.w	.perf	;branch if higher - perfect shot
.notperf
	clr.w	d0
	move.b	$6D(a3),d0	;shotacc(a3)
	lsr.w	#1,d0	;divide by 2
	move.b	d0,-(sp)	;push on stack
	move.w	(passspeed).w,d0	;move passspeed into d0
	lsr.w	#4,d0	;divide by 16
	sub.b	(sp)+,d0	;shotacc(a3) / 2
	addi.b	#$10,d0	;add $10 to d0
	mulu.w	d3,d0	;mult straight line distance with d0
	lsr.w	#6,d0	;shot accuracy adjust - divide by 64
	cmp.w	#$FA,d3	;250 pixels straight line distance
	bhi.w	.chkvalue	;branch if higher
	lsr.w	#1,d0	;extra shot accuracy adjust
.chkvalue
	cmp.w	#$88,d0	;compare to $88 (max adj value in X)
	blt.w	.cont3
	move.w	#$88,d0
.cont3
	move.w	d0,-(sp)	;push adjusting value on stack
	bsr.w	randomd0s	;RNG adj value
	add.w	d0,2(sp)	;add result to x diff
	move.w	(sp),d0	;move adjusting value into d0
	cmp.w	#$3C,d0	;'<'   ; compare to $3C (max adjustment in Y)
	bls.w	.lessx	;branch if less
	moveq	#$3C,d0
	move.w	d0,(sp)
.lessx
	tst.w	4(sp)
	bpl.w	.ycalc
	lsr.w	#1,d0
.ycalc
	bsr.w	randomd0s	;RNG adjustment
	add.w	d0,4(sp)	;add to y diff
	move.w	(sp)+,d0	;pop adj value
	lsr.w	#1,d0	;divide by 2
	bsr.w	randomd0	;RNG result
	add.w	d0,4(sp)	;add to Z diff
.perf
	move.w	(passspeed).w,d2	;shot speed
	muls.w	#$44,d2	;'D'   ; 1024/15
	muls.w	(sp)+,d2	;mult by x dist
	divs.w	d3,d2	;divide d2 by straight line distance
	move.w	d2,(puckvx).w	;move into puckvx
	move.w	(passspeed).w,d2
	muls.w	#$44,d2	;'D'   ; 1024/15
	muls.w	(sp)+,d2	;mult by y dist
	divs.w	d3,d2	;divide d2 by straight line distance
	move.w	d2,(puckvy).w	;move into puckvy
	move.w	#$8000,d1	;this is the highest negative puckvy possible
	btst	#7,$62(a3)	;check direction of shooting net
	beq.w	.C4D8	;branch if bottom goal
	clr.w	d1
.C4D8
	eor.w	d2,d1	;EOR - checking to see if exceeding maximum puckvy
	bpl.w	.C4F4	;branch if positive
	move.w	#$3810,(puckvy).w	;move into puckvy
	btst	#7,$62(a3)	;check net shooting on
	bne.w	.C4F4	;branch if top
	move.w	#$C7F0,(puckvy).w	;move into puckvy (shooting on bottom net)
.C4F4
	move.w	(sp)+,d1	;pix height in goal
	beq.w	.ex	;exit if zero
	mulu.w	(passspeed).w,d1
	mulu.w	#$44,d1	;'D'   ; 1024/15
	divu.w	d3,d1	;d3 = distance in pix to goal
	mulu.w	#$B33,d3	;(1024*42)/15
	divu.w	(passspeed).w,d3	;divide by passspeed
	add.w	d1,d3
	cmp.w	#$1800,d3
	bls.w	.noup	;branch if less than
	move.w	#$1800,d3	;set max puckvz
.noup
	move.w	d3,(puckvz).w	;move into puckvz
	bclr	#4,(word_FFC2F6).w	;check in-close top shelf bit
	beq.w	.ex	;if bit was cleared, exit
	btst	#3,$64(a3)	;check if one timer
	bne.w	.ex	;branch if so
	jsr	(puckvzadj).l	;adjust puckvz for top shelf shot
.ex
	bsr.w	sfx
	movem.l	(sp)+,d0-d7/a0-a3
	rts
shotsets	dc.w	0
	;offsets for different directions on the shot
	;passdir 0(x,z)
	dc.w	$C
	dc.w	$10	;passdir 1
	dc.w	$C
	dc.w	$10	;passdir 2
	dc.w	6
	dc.w	$10	;passdir 3
	dc.w	0
	dc.w	0	;passdir 4
	dc.w	0
	dc.w	$FFF0	;passdir 5
	dc.w	0
	dc.w	$FFF0	;passdir 6
	dc.w	6
	dc.w	$FFF0	;passdir 7
	dc.w	$C
	dc.w	0	;passdir 8
	dc.w	6
; a3 = shooter
; Determines where to shoot for CPU player or on a one timer
shotdiradj
	btst	#3,$64(a3)	;check if shooting one timer
	bne.w	.C57A	;jump if shooting one timer
	btst	#3,$62(a3)	;pfjoycon - checks if player is joystick controlled
	bne.w	.ex	;exit if joystick
.C57A
	moveq	#8,d0
	moveq	#5,d1
	movea.w	#(unk_FFAFCA-M68K_RAM),a0	;SC Struct start - 80
	btst	#6,$62(a3)	;pfteam - check if home or away
	bne.w	.loop	;jump if away
	adda.w	#$300,a0	;add 300 to a0 (start on away team)
.loop
	adda.w	#$80,a0	;move to next player struct
	tst.w	$34(a0)	;check if goalie. Find opponents goalie
	dbeq	d1,.loop
	bne.w	.setpassdir	;branches if no goalie
	move.b	$28(a0),d0	;Opponent's G is A0. Move Xvel into d0
	ext.w	d0	;sign extend d0
	asr.w	#1,d0	;divide by 2
	add.w	(a0),d0	;Xpos
	sub.w	(puckx).w,d0	;sub puckx from d0
	move.b	$2A(a0),d1	;Yvel
	ext.w	d1	;sign extend d1
	asr.w	#1,d1	;divide by 2
	add.w	$14(a0),d1	;Ypos
	sub.w	(pucky).w,d1	;sub pucky from d1
	movem.w	d0-d1,-(sp)	;push to stack
	muls.w	d0,d0	;square d0
	muls.w	d1,d1	;square d1
	add.l	d1,d0	;add d1 to d0
	addq.l	#1,d0	;add 1 to d0
	bsr.w	sroot	;get square root
	move.w	d0,d2	;move result into d2
	movem.w	(sp)+,d0-d1	;pop from stack (distance x and y from G to puck)
	moveq	#$12,d3	;post?
	move.w	#$108,d4	;Goal line
	btst	#7,$62(a3)	;check which goal shooting at
	bne.w	.chkposts	;jump if top goal
	neg.w	d4	;negate if bottom goal
.chkposts
	movem.w	d3-d4,-(sp)	;push to stack
	bsr.w	shotdirmath
	move.w	d4,d5
	movem.w	(sp)+,d3-d4	;pop from stack
	neg.w	d3	;negate d3 (other post)
	bsr.w	shotdirmath
	add.w	d5,d4	;add results to d4
	clr.w	d0	;clear d0
	cmp.w	#$2C,d4	;','   ; 2C - right X edge of crease
	bgt.w	.setpassdir
	cmp.w	#$FFD4,d4	;FFD4 - left X edge of crease
	blt.w	.setpassdir
	btst	#7,$62(a3)	;check what net shooting on
	beq.w	.passdir	;branch if bottom
	neg.w	d4	;negate d4
.passdir
	moveq	#2,d0	;move 2 into d0
	tst.w	d4	;check if d4 is 0
	bpl.w	.setpassdir	;branch if positive
	moveq	#6,d0	;move 6 into d0
.setpassdir
	move.w	d0,(passdir).w	;will be 0,2,6, or 8 (no goalie)
	btst	#2,(BA_PS_flags).w
	bne.w	.PSorSO	;branch if bit 2 is set
	btst	#0,(word_FFC2FA).w	;check if shootout
	beq.w	.ex	;branch if not set
.PSorSO
	jsr	(PSandSOpassdir).l
.ex
	rts
; Gets the area with respect to puck location, goalie location, and the post and divides it by the straight distance from goalie to puck
;
; d0 = difference in X from G to puck
; d1 = difference in Y from G to puck
; d2 = distance from G to puck (straight line)
; d3 = post X position
; d4 = goalline
;
shotdirmath
	sub.w	(puckx).w,d3	;sub puckx from post X
	sub.w	(pucky).w,d4	;sub pucky from goalline
	muls.w	d0,d4	;mult d0 with d4
	muls.w	d1,d3	;mult d1 with d3
	sub.l	d3,d4	;sub d3 from d4
	divs.w	d2,d4	;divide d2 into d4
	rts
; copy info into pad cont so graphics know which player/number
setpads	;IDA: sub_C656. Put SCnum of a3 in the d4 nibble of word_FFBE78 (93 PadControlBits); d4 = -2 puck
	;carrier, 0 / 2 pads, 4 replay target. Falls into rtss3
	movem.l	d0-d1,-(sp)
	moveq	#2,d0
	add.w	d4,d0
	add.w	d0,d0
	move.w	#$FFF0,d1
	rol.w	d0,d1
	and.w	d1,(word_FFBE78).w
	move.w	$52(a3),d1
	asl.w	d0,d1
	or.w	d1,(word_FFBE78).w
	movem.l	(sp)+,d0-d1
rtss3
	rts
check4bench
	btst	#2,(BA_PS_flags).w
	bne.s	rtss3
	btst	#3,$62(a3)
	bne.s	rtss3
	btst	#4,$63(a3)
	bne.s	rtss3
	tst.b	$60(a3)
	bpl.w	.C6A0
	tst.b	$61(a3)
	bmi.s	rtss3
.C6A0
	move.b	$61(a3),d0
	cmp.b	$66(a3),d0
	beq.w	.C6D8
	move.w	$36(a3),d0
	cmpi.b	#$B,$38(a3,d0.w)
	beq.s	rtss3
	move.w	$52(a3),d0
	cmp.w	(puckc).w,d0
	beq.s	rtss3
	addq.w	#4,sp
	bset	#2,$63(a3)	;set player unavailable (pf2unav)
	clr.w	$40(a3)
	move.l	#$B,d0	;assbench
	bra.w	assreplace
.C6D8
	addq.w	#4,sp
	bclr	#2,$63(a3)
	bclr	#2,$62(a3)
	st	$61(a3)
	st	$60(a3)
	move.w	$34(a3),d0
	tst.b	$60(a3)
	bpl.w	.C700
	jmp	Setplass
.C700
	move.b	$60(a3),d0
	ext.w	d0
	move.w	d0,$34(a3)
	jmp	Setplass
; player a3 should go to bench
