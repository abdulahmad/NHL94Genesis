;	NHL 94 (retail) segment $FFEA-$10EDF
;	92 Logic.Asm part 5, as 93 logic93_5.asm: ChkOffsides, ClearOffsidesIfAllPlayers, a2offsides, a2touchpuck,
;	puckIChk, puckunflip / puckflip / puckshadow, findpc, skateto, avdgoal, skatetopuckinit / skatetopuck, assexit /
;	assinsert / assreplace, vtoa, GetHot, SetSPA, doplayeracc, goalieacc, noturn0 / noturn, playeracc, MaxSpeed,
;	dostop, stopna, dirtab, UnpackNibbles, WeightedRandomSelect. remap (middle94_1) follows at $10EE0.
;	Transcribed from lst/nhl94.bin.lst lines 42598-43998. Global names are the IDA names except
;	ClearOffsidesIfAllPlayers (IDA sub_100A6), UnpackNibbles (sub_10E88) and WeightedRandomSelect (sub_10EB4), the
;	93 names. Local labels are the IDA local names (_x -> .x) or the IDA address (loc_10012 -> .10012).
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp /
;	cmpi; fixopcodes.js patches the cmp encoding after assembly.
;	SortCords offsets (93 names): Xpos 0, attribute 4, Ypos $14, Zpos $18, Xvel $28, Yvel $2A, position $34,
;	SCnum $52, facedir $54, SPA $58, SPAnum $5A, SPAcnt $5C, pflags $62, pflags2 $63.

ChkOffsides
	btst	#5,(gmode).w
	beq.w	rtss2
	btst	#2,(BA_PS_flags).w
	bne.w	rtss2
	movea.w	#(HmShots-M68K_RAM),a1
	lea	$364(a1),a2
	bsr.w	ClearOffsidesIfAllPlayers
	exg	a1,a2
	bsr.w	ClearOffsidesIfAllPlayers
	move.w	#$54,d0
	cmp.w	$14(a3),d0
	bgt.w	.1005C
	cmp.w	$20(a3),d0
	ble.w	rtss2
	addi.w	#$A,d0
	btst	#1,(gmode).w
	beq.w	.10034
	exg	a2,a1
.10034
	moveq	#5,d2
	movea.w	$22(a2),a0
.1003A
	tst.w	$34(a0)
	bmi.w	.10052
	cmp.w	$14(a0),d0
	bge.w	.10052
	bset	#4,$30(a2)
	rts
.10052
	adda.w	#$80,a0
	dbf	d2,.1003A
	rts
.1005C
	neg.w	d0
	cmp.w	$14(a3),d0
	blt.w	rtss2
	cmp.w	$20(a3),d0
	bge.w	rtss2
	subi.w	#$A,d0
	btst	#1,(gmode).w
	bne.w	.1007E
	exg	a2,a1
.1007E
	moveq	#5,d2
	movea.w	$22(a2),a0
.10084
	tst.w	$34(a0)
	bmi.w	.1009C
	cmp.w	$14(a0),d0
	ble.w	.1009C
	bset	#4,$30(a2)
	rts
.1009C
	adda.w	#$80,a0
	dbf	d2,.10084
	rts
ClearOffsidesIfAllPlayers	;IDA: sub_100A6 (93 name). a2 = team struct: clear the team offsides flag once no skater is past the line
	btst	#4,$30(a2)
	beq.w	rtss2
	movea.w	$22(a2),a0
	moveq	#5,d1
.100B6
	tst.w	$34(a0)
	bmi.w	.100CE
	move.w	$14(a0),d0
	btst	#7,$62(a0)
	bne.w	.100CE
	neg.w	d0
.100CE
	adda.w	#$80,a0
	cmp.w	#$58,d0
	dbgt	d1,.100B6
	bgt.w	rtss2
	bclr	#4,$30(a2)
	rts
a2offsides
	btst	#5,(gmode).w
	beq.w	rtss2
	move.w	(pucky).w,d0
	btst	#7,$62(a2)
	bne.w	.10100
	neg.w	d0
.10100
	cmp.w	#$68,d0
	blt.w	rtss2
	movea.w	#(HmShots-M68K_RAM),a0
	btst	#6,$62(a2)
	beq.w	.1011A
	adda.w	#$364,a0
.1011A
	btst	#4,$30(a0)
	beq.w	rtss2
	btst	#4,(gmode).w
	bne.w	rtss2
	exg	a2,a3
	move.l	#$10,d0
	bsr.w	AddPenalty
	exg	a2,a3
	rts
; player a2 touches puck
; look for penalties/offsides/other junk
a2touchpuck
	move.w	(a2),(ltx).w	;move Xpos to last touch X
	move.w	$14(a2),(lty).w	;move Ypos to last touch Y
	move.w	$52(a2),(ltplayer).w	;move SCnum to last touch player
	movea.w	#(HmShots-M68K_RAM),a0	;move Home Shots into a0
	btst	#6,$62(a2)	;check if home or away
	beq.w	.10160	;branch if home
	lea	$364(a0),a0	;add to a0 if away
.10160
	clr.w	d0
	move.b	$66(a2),d0	;move pnum into d0
	btst	#3,$64(a2)	;check if one timer
	beq.w	.10176	;branch if not
	bset	#7,(byte_FFC2FE).w	;set if one timer
.10176
	cmp.w	$18(a0),d0	;compare value in C6E6 (home) to d0
	beq.w	.101A4	;branch if equal
	bclr	#3,$30(a0)	;clear bit 3
	bne.w	.10194	;branch if not cleared before
	move.w	$1A(a0),$1C(a0)	;move current player to assist slot
	move.w	$18(a0),$1A(a0)	;move current player to last player slot
.10194
	move.w	d0,$18(a0)	;move pnum into current player
	cmp.w	$1C(a0),d0	;compare if same player as assist slot
	bne.w	.101A4	;branch if not
	st	$1C(a0)	;set FFFF to assist slot
.101A4
	bclr	#4,(sflags2).w	;clear shot taken
	bsr.w	a2offsides
	btst	#2,(iflags).w	;check if icing
	beq.w	.notice	;branch if not
	btst	#0,(iflags).w	;test if crossed goalline
	beq.w	.notice	;branch if not
	tst.w	$34(a2)	;check if goalie
	beq.w	.notice	;branch if so
	btst	#1,(iflags).w	;check if must cross top line
	bne.w	.up	;branch if so
	btst	#7,$62(a2)	;check if top or bottom shooting goal
	beq.w	.notice	;branch if bottom
.icing
	clr.w	d0
	move.b	(icingPlayer).w,d0	;move iflags+1 into d0
	asl.w	#7,d0
	move.l	a3,-(sp)	;push on stack
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3	;a3 now player struct
	move.w	#$C,d0	;#PenIcing
	bsr.w	AddPenalty
	movea.l	(sp)+,a3
	rts
.up
	btst	#7,$62(a2)	;check top or bottom shooting goal
	beq.s	.icing	;branch if bottom
.notice
	clr.b	(iflags).w
	move.b	$53(a2),(icingPlayer).w	;move SCnum+1 into icingPlayer
	move.w	(pucky).w,d0	;move pucky into d0
	btst	#7,$62(a2)	;check if shooting up or down
	beq.w	.0	;branch if down
	bset	#1,(iflags).w	;set icing direction up
	neg.w	d0	;negate d0
.0
	bmi.w	rtss2	;exit if minus
	move.w	(tmap).w,d0
	sub.w	(tmsize).w,d0
	btst	#6,$62(a2)	;check home or away
	beq.w	.1	;branch if home
	neg.w	d0	;negate d0
.1
	bmi.w	rtss2	;exit if minus
	bset	#2,(iflags).w	;set icing flag
	rts
; check for icing of puck penalty
puckIChk
	btst	#2,(iflags).w	;#ifok
	beq.w	rtss2
	btst	#0,(iflags).w	;#ifcgl - if crossed goal line
	bne.w	rtss2
	tst.w	(puckc).w
	bpl.w	rtss2
	move.w	#$108,d0	;goalline
	btst	#1,(iflags).w	;#ifdir - 1 = must cross top line
	bne.w	.0
	neg.w	d0
	cmp.w	(pucky).w,d0	;check other goalline
	bgt.w	.set
	rts
.0
	cmp.w	(pucky).w,d0
	bgt.w	rtss2
.set
	cmpi.w	#$2C,(puckx).w	;',' ; 2C - edge of crease
	bgt.w	.102A0
	cmpi.w	#$FFD4,(puckx).w	;FFD4 - edge of crease
	blt.w	.102A0
	bclr	#2,(iflags).w	;#ifok cleared
	rts
.102A0
	bset	#0,(iflags).w	;#ifcgl
	rts
; stop spinning puck
; a3 = puck
puckunflip
	cmpi.w	#8,$5A(a3)
	blt.w	.k
	cmpi.w	#$18,$5A(a3)
	bge.w	.k
	eori.w	#2,$54(a3)	;facedir
.k
	ori.w	#4,$54(a3)
	clr.w	$5A(a3)	;SPAnum
	st	$5C(a3)	;SPAcnt
	rts
; start puck spinning
; a3 = puck
puckflip
	andi.w	#1,d0
	eor.w	d0,$54(a3)	;facedir
	andi.w	#3,$54(a3)
	st	$5C(a3)	;SPAcnt
	move.w	#$46A,d1	;#SPApflip
	bra.w	SetSPA
; assignment for puck shadow
; a3 = puck shadow
puckshadow
	cmpi.w	#$18A,6(a3)	;#SPFpuck, frame
	bne.w	.siren	;shadow turns into siren on goals
	move.w	-$80(a3),(a3)	;Xpos-SCstruct, Xpos
	move.w	-$6C(a3),$14(a3)	;Ypos-SCstruct, Ypos
	clr.w	$18(a3)	;Zpos
	moveq	#$14,d0	;Ypos
	btst	#7,(sflags).w	;#sfhor - check if horizontal mode
	beq.w	.nhor
	moveq	#0,d0	;Xpos
.nhor
	addq.w	#1,0(a3,d0.w)
	rts
.siren
	tst.w	6(a3)	;frame
	beq.w	rtss2
	clr.w	(a3)	;Xpos
	move.w	#$12C,$14(a3)	;Ypos
	move.w	#$E,$18(a3)	;Zpos
	tst.w	-$6C(a3)	;Ypos-SCstruct
	bpl.w	.s0
	move.w	#$8000,4(a3)	;attribute
	neg.w	$14(a3)	;Ypos
	subq.w	#1,$18(a3)	;Zpos
.s0
	rts
; find puck crossing lines
; calculate when puck will cross goalline (if at all)
findpc
	movem.l	d0-d4/a1-a2,-(sp)
	movea.w	#(puckcross-M68K_RAM),a1
	move.w	#$88,d1	;sideline - distance from center to side boards
	move.w	#$108,d4	;goaline
	bsr.w	.calc
	neg.w	d4	;make d4 negative to check bottom goal line
	bsr.w	.calc
	movem.l	(sp)+,d0-d4/a1-a2
	rts
.calc
	move.w	d4,d0	;move goaline into d0
	sub.w	(pucky).w,d0	;sub pucky from d0
	tst.w	(puckvy).w	;check puckvy
	beq.w	.nocross	;branch if 0
	move.w	d0,d2	;move d0 into d2
	swap	d2	;swap upper and lower word of d2
	clr.w	d2	;clear bottom word of d2
	asr.l	#4,d2	;shift 4 bits right (divide by 16)
	divs.w	(puckvy).w,d2	;divide puckvy into d2
	bmi.w	.nocross	;branch if negative
	move.w	d2,2(a1)	;time until crossing in frames (puckcross y)
	muls.w	(puckvx).w,d0	;mult puckvx with d0
	divs.w	(puckvy).w,d0	;divide puckvy into d0
	bvs.w	.nocross	;branch if overflow set
	add.w	(puckx).w,d0	;add puckx to d0
	cmp.w	d1,d0	;compare d1 (sideline) to d0
	blt.w	.o1	;branch if less than (in play)
	neg.w	d0	;negate d0
	add.w	d1,d0	;add d1 3 times to d0
	add.w	d1,d0
	add.w	d1,d0
.o1
	neg.w	d1	;negate d1
	cmp.w	d1,d0	;compare d1 (other sideline) to d0
	bgt.w	.o2	;branch if greater than (in play)
	neg.w	d0	;negate d0
	add.w	d1,d0	;add d1 to d0 3 times
	add.w	d1,d0
	add.w	d1,d0
.o2
	neg.w	d1	;negate d1
	move.w	d0,(a1)	;move d0 into puckcross
	bra.w	.next
.nocross
	move.w	#$FFFF,2(a1)	;move -1 into puckcross y
.next
	addq.w	#4,a1	;add 4 to puckcross (to move to the other goal line)
	rts
; a0 = extra routine for collision avoidance
; d0/d1 = x/y coord to skate to
; d7 = elapsed frames
skateto
	sub.b	d7,$42(a3)	;sub d7 from temp2
	bpl.w	.ex	;exit if not 0 or less
	addi.b	#$C,$42(a3)	;add 12 - only execute every 12 frames
	bsr.w	avdgoal	;avoid the goal nets
	movem.w	d0-d1,-(sp)
	move.w	$28(a3),d0	;Xvel
	asr.w	#8,d0	;divide by 256
	neg.w	d0	;make negative
	add.w	(sp)+,d0	;add new x coord from stack
	sub.w	(a3),d0	;sub Xpos
	move.w	$2A(a3),d1	;Yvel
	asr.w	#8,d1	;divide by 256
	neg.w	d1	;make negative
	add.w	(sp)+,d1	;add new y coord from stack
	sub.w	$14(a3),d1	;sub Ypos
	cmp.w	#$C,d0	;compare 12 to d0
	bgt.w	.vt
	cmp.w	#$FFF4,d0	;cmp -12
	blt.w	.vt
	cmp.w	#$C,d1	;compare 12 to d1
	bgt.w	.vt
	cmp.w	#$FFF4,d1	;cmp -12
	blt.w	.vt
	moveq	#9,d0
	bra.w	.nvt
.vt
	bsr.w	vtoa
.nvt
	jsr	(a0)	;extra collision routine
	move.b	d0,$43(a3)	;move d0 into temp2+1
	cmp.w	#7,d0	;compare to 7
	ble.w	.ex
	move.w	$28(a3),d0	;Xvel
	or.w	$2A(a3),d0	;Yvel
	bne.w	.ex
	move.w	(puckx).w,d0	;move puckx into d0
	move.w	(pucky).w,d1	;move pucky into d1
	btst	#0,(puck_pflags2).w	;#pf2fight, puckx+pflags2
	beq.w	.nf
	move.w	(xc1).w,d0	;scroll lock x coord
	move.w	(yc1).w,d1	;scroll lock y coord
.nf
	sub.w	(a3),d0	;Xpos
	sub.w	$14(a3),d1	;Ypos - face towards puck
	bsr.w	vtoa
	sub.w	$54(a3),d0	;facedir
	beq.w	.ex
	neg.w	d0
	andi.w	#4,d0
	lsr.w	#1,d0	;divide by 2
	subq.w	#1,d0
	add.w	$54(a3),d0	;facedir
	andi.w	#7,d0
	move.w	d0,$54(a3)	;facedir
.ex
	clr.w	d0
	move.b	$43(a3),d0	;temp2+1
	bra.w	doplayeracc
; Don't try to skate through goal
; If d0/d1 coords intersect through goal, then provide new d0/d1 coords
; a3 = player
; .xr = 80
; .yr = 30
; .ye = 30
; .gl = 258
avdgoal
	clr.w	(deltax).w
	clr.w	(deltay).w
	tst.w	$34(a3)	;goalie? If so, quit
	beq.w	rtss2
	move.w	(a3),d2	;Xpos
	eor.w	d0,d2
	bpl.w	.chbar
	move.w	d1,d2
	sub.w	$14(a3),d2	;Ypos
	move.w	(a3),d3	;Xpos
	muls.w	d3,d2
	sub.w	d0,d3
	divs.w	d3,d2
	add.w	$14(a3),d2	;Ypos
	cmp.w	#$121,d2	;.gl+.yr
	bgt.w	.chbar
	cmp.w	#$DB,d2	;.gl-.yr
	blt.w	.lower
	move.w	#$144,d3	;.gl-.yr-.ye
	cmp.w	#$FE,d2	;.gl
	bgt.w	.2
	blt.w	.1
	cmpi.w	#$FE,$14(a3)	;.gl, Ypos
	bgt.w	.2
.1
	move.w	#$B8,d3	;.gl-.yr-.ye
.2
	sub.w	d2,d3
	move.w	d3,(deltay).w
	bra.w	.chbar
.lower
	cmp.w	#$FF25,d2	;-.gl+.yr
	bgt.w	.chbar
	cmp.w	#$FEDF,d2	;-.gl-.yr
	blt.w	.chbar
	move.w	#$FF48,d3	;-.gl+.yr+.ye
	cmp.w	#$FF02,d2	;-.gl
	bgt.w	.4
	blt.w	.3
	cmpi.w	#$FF02,$14(a3)	;-.gl, Ypos
	bgt.w	.4
.3
	move.w	#$FEBC,d3	;-.gl-.yr-.ye
.4
	sub.w	d2,d3
	move.w	d3,(deltay).w
.chbar
	move.w	d1,d3
	subi.w	#$FE,d3
	move.w	$14(a3),d2
	subi.w	#$FE,d2
	bsr.w	ch1
	move.w	d1,d3
	addi.w	#$FE,d3
	move.w	$14(a3),d2
	addi.w	#$FE,d2
	bsr.w	ch1
	add.w	(deltax).w,d0
	add.w	(deltay).w,d1
	rts
ch1
	move.w	d3,d4
	eor.w	d2,d4
	bpl.w	rtss2
	move.w	d0,d4
	sub.w	(a3),d4	;Xpos
	muls.w	d2,d4
	sub.w	d3,d2
	divs.w	d2,d4
	add.w	(a3),d4	;Xpos
	cmp.w	#$50,d4	;'P'   ; #.xr
	bgt.w	rtss2
	cmp.w	#$FFB0,d4	;#-.xr
	blt.w	rtss2
	moveq	#$50,d3	;'P'   ; #.xr
	tst.w	d4
	bne.w	.1057A
	tst.w	(a3)	;Xpos
.1057A
	bpl.w	.10580
	neg.w	d3
.10580
	sub.w	d4,d3
	move.w	d3,(deltax).w
	rts
; find where the puck is going to be
skatetopuckinit
	move.b	(puckvx).w,d0
	asr.b	#1,d0
	ext.w	d0
	add.w	(puckx).w,d0
	move.b	(puckvy).w,d1
	asr.b	#1,d1
	ext.w	d1
	add.w	(pucky).w,d1
	rts
; player a3 should skate to puck
skatetopuck
	bsr.s	skatetopuckinit
	sub.b	d7,$42(a3)	;temp2
	bpl.w	.ex
	addi.b	#$A,$42(a3)	;temp2
	bsr.w	avdgoal
	movem.w	d0-d1,-(sp)
	move.l	a3,-(sp)
	bsr.w	GetHot
	neg.b	d0
	neg.b	d1
	sub.b	$28(a3),d0	;Xvel
	ext.w	d0
	add.w	(sp)+,d0
	sub.w	(a3),d0	;Xpos
	sub.b	$2A(a3),d1	;Yvel
	ext.w	d1
	add.w	(sp)+,d1
	sub.w	$14(a3),d1	;Ypos
	bsr.w	vtoa
	move.b	d0,$43(a3)	;temp2 lower byte
	tst.w	$34(a3)
	beq.w	.ex
	move.w	(puckvx).w,d0
	move.w	(puckvy).w,d1
	bsr.w	vtoa
	eori.w	#4,d0
	cmp.w	$54(a3),d0	;facedir
	beq.w	.ex
	move.w	(puckx).w,d0
	sub.w	(a3),d0	;Xpos
	move.w	(pucky).w,d1
	sub.w	$14(a3),d1	;Ypos
	movem.w	d0-d1,-(sp)
	bsr.w	vtoa
	cmp.w	$54(a3),d0	;$54 = facedir
	movem.w	(sp)+,d0-d1
	bne.w	.ex
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	#$384,d0	;#30^2
	bls.w	.ex
	cmp.l	#$5A4,d0	;#38^2
	bls.w	Sweepcheck
.ex
	move.b	$43(a3),d0
	bra.w	doplayeracc
; exit current assignment on player a3
assexit
	addq.w	#1,$36(a3)	;add 1 to current assignment index
	andi.w	#7,$36(a3)	;mask passing first 3 bits
	bset	#1,$62(a3)	;signal next assignment
	rts
; insert new assignment on player a3
assinsert
	subq.w	#1,$36(a3)	;$36 = assnum
	andi.w	#7,$36(a3)
; replace current assignment on player a3
assreplace
	move.l	d1,-(sp)	;push on stack
	move.w	$36(a3),d1	;$36 = assnum
	move.b	d0,$38(a3,d1.w)	;replace current assignment with d0 on asslist
	bset	#1,$62(a3)	;set flag to start new assignment
	move.l	(sp)+,d1	;pop on stack
	rts
; d0/d1 are x/y distances which are converted into direction 0-7 and returned in d0
vtoa
	movem.l	d2/a0,-(sp)
	move.w	d0,d2
	or.w	d1,d2
	beq.w	.nodir
	clr.w	d2
	tst.w	d0
	bpl.w	.0
	neg.w	d0
	bset	#0,d2
.0
	tst.w	d1
	bpl.w	.1
	neg.w	d1
	bset	#1,d2
.1
	asl.w	#1,d1
	cmp.w	d1,d0
	bhi.w	.2
	bset	#2,d2
.2
	lsr.w	#1,d1
	asl.w	#1,d0
	cmp.w	d0,d1
	bhi.w	.3
	bset	#3,d2
.3
	movea.l	#.dt,a0	;#.dt
	clr.w	d0
	move.b	0(a0,d2.w),d0
	movem.l	(sp)+,d2/a0
	rts
.nodir
	moveq	#8,d0
	movem.l	(sp)+,d2/a0
	rts
.dt	dc.b	1
	dc.b	7,3,5,0,0,4,4,2,6,2,6,1,7,3,5
; Push long address of structure to get hot spot from
; hot spot x/y returned in d0/d1
GetHot
	movem.l	a0-a1,-(sp)
	movea.l	$C(sp),a0	;move stored address before sub routine call into a0
	clr.w	d0	;clear d0
	clr.w	d1	;clear d1
	tst.w	6(a0)	;$6 = frame
	ble.w	.ex	;branch if <= 0
	movea.l	#Hotlist,a1	;move Hotlist address into a1
	move.w	6(a0),d0	;move frame into d0
	add.w	d0,d0	;double d0
	move.b	1(a1,d0.w),d1	;SprStrHot Y byte
	ext.w	d1	;extend d1
	move.b	0(a1,d0.w),d0	;SprStrHot X byte
	ext.w	d0	;extend d0
	btst	#3,4(a0)	;check attribute for X flip
	beq.w	.nox	;branch if equal
	neg.w	d0	;negate d0 (flip)
.nox
	btst	#4,4(a0)	;check attribute for Y flip
	bne.w	.noy	;branch if no flip
	neg.w	d1	;negate d1 (flip)
.noy
	btst	#7,(sflags).w	;check if horizontal mode
	beq.w	.ex	;branch if not
	exg	d0,d1	;swap d0 and d1
	neg.w	d1	;ngate d1 (x now)
.ex
	movem.l	(sp)+,a0-a1
	move.l	(sp)+,(sp)
	rts
; set sprite animation on struct a3
; d1 = new animation
SetSPA
	cmp.w	$58(a3),d1
	beq.w	rtss2
	clr.w	$5A(a3)
	move.w	d1,$58(a3)
	st	$5C(a3)	;restart animation
	rts
; player a3 gets acc. in d0 dir
doplayeracc
	tst.w	$34(a3)
	beq.w	goalieacc	;goalie is special
	move.w	#$50C,d1	;#SPAglide
	btst	#4,$62(a3)	;check if skating backwards
	beq.w	.d0	;branch if not
	move.w	#$A60,d1	;#SPAglideback
.d0
	andi.w	#$F,d0	;pass first 4 bits of d0
	cmp.w	#7,d0	;compare to 7
	ble.w	.d1	;branch if less than
	cmp.w	#9,d0	;compare to 9
	bne.w	.cgl	;branch if not equal
	move.w	$28(a3),d0	;Xvel
	or.w	$2A(a3),d0	;OR Yvel with Xvel
	bne.w	dostop	;stop if not equal
.cgl
	btst	#1,$63(a3)	;check if anim in progress
	beq.s	SetSPA	;if not set animation
	rts
.d1
	movem.w	d0-d1,-(sp)
	move.w	d0,d2
	move.w	$52(a3),d0	;move SCnum into d0
	cmp.w	(puckc).w,d0	;check if puckc
	beq.w	.clrrev	;branch if so
	move.w	(puckx).w,d0	;puckx into d0
	sub.w	(a3),d0	;sub Xpos
	move.w	$14(a3),d3	;Ypos into d3
	move.b	(puckvy).w,d1	;puckvy into d1
	ext.w	d1
	add.w	(pucky).w,d1	;add pucky to d1
	sub.w	d3,d1	;sub Ypos from d1
	btst	#7,$62(a3)	;check which goal shooting at
	bne.w	.c1	;branch if top
	neg.w	d0
	neg.w	d1
	neg.w	d3
	eori.w	#4,d2
.c1
	btst	#4,$62(a3)	;check if skating in reverse
	bne.w	.inrev	;branch if so
	tst.w	d3
	bpl.w	.clrrev	;skate back in own zone only
	cmp.w	#4,d2
	bne.w	.clrrev
	bsr.w	vtoa
	addq.w	#1,d0
	andi.w	#7,d0
	cmp.w	#2,d0
	bhi.w	.clrrev
	bra.w	.rev
.inrev
	subq.w	#3,d2
	andi.w	#7,d2
	cmp.w	#2,d2
	bhi.w	.clrrev
	bsr.w	vtoa
	addq.w	#2,d0
	andi.w	#7,d0
	cmp.w	#4,d0
	bhi.w	.clrrev
.rev
	btst	#4,$62(a3)	;check if skating in reverse
	bne.w	.done	;branch if so
	move.w	$28(a3),d0	;move Xvel into d0
	or.w	$2A(a3),d0	;or with Yvel
	beq.w	.setrev	;branch if equal
	move.w	$28(a3),d0	;move Xvel into d0
	move.w	$2A(a3),d1	;Yvel to d1
	bsr.w	vtoa
	sub.w	(sp),d0
	addq.w	#1,d0
	andi.w	#7,d0
	cmp.w	#2,d0
	bhi.w	.done
.setrev
	bset	#4,$62(a3)	;set skating in reverse flag
	bra.w	.done
.clrrev
	bclr	#4,$62(a3)	;clear skating in reverse flag
.done
	movem.w	(sp)+,d0-d1
	move.w	$54(a3),d2	;facedir into d2
	sub.w	d2,d0
	andi.w	#7,d0
	movea.l	#.ftab,a0
	asl.w	#1,d0
	tst.w	0(a0,d0.w)
	beq.w	noturn0
	move.w	$28(a3),d4	;Xvel to d4
	muls.w	d4,d4	;square d4
	move.w	$2A(a3),d3	;Yvel to d3
	muls.w	d3,d3	;square d3
	add.l	d4,d3	;add d4 and d3
	swap	d3	;swap upper and lower words
	move.w	#$300,d4
	sub.w	d3,d4
	cmp.w	#$180,d4	;compare to d4
	bge.w	.iok	;branch if greater than or equal
	move.w	#$180,d4
.iok
	muls.w	0(a0,d0.w),d4
	btst	#4,$62(a3)	;check if skating in reverse
	beq.w	.i0	;branch if not
	neg.l	d4
.i0
	add.l	d4,$54(a3)	;add d4 to facedir
	andi.w	#7,$54(a3)	;pass the first 3 bits to facedir
	move.w	$54(a3),d2	;move facedir to d2
	cmp.w	#$14,d3
	bls.w	.s3
	clr.w	d1
	tst.w	0(a0,d0.w)
	bpl.w	.s1
	eori.w	#$FFCE,d1	;#SPAturnl-#SPAturnr
.s1
	btst	#3,4(a3)	;test bit 3 of attribute
	beq.w	.s2
	eori.w	#$FFCE,d1	;#SPAturnl-#SPAturnr
.s2
	addi.w	#$694,d1	;#SPAturnr
	bset	#1,$63(a3)	;set animation in progress flag
.s3
	bsr.w	SetSPA
	cmp.w	#2,d3
	bhi.w	noturn
	rts
.ftab	dc.w	0
	dc.w	$10
	dc.w	$10
	dc.w	$10
	dc.w	0
	dc.w	$FFF0
	dc.w	$FFF0
	dc.w	$FFF0
goalieacc
	btst	#3,$62(a3)
	beq.w	.10A42
	movem.w	d0,-(sp)
	move.w	(puckc).w,d0
	cmp.w	$52(a3),d0
	movem.w	(sp)+,d0
	beq.w	.10A42
	cmpi.w	#$30,(a3)
	bgt.w	.10A42
	cmpi.w	#$FFD0,(a3)
	blt.w	.10A42
	cmpi.w	#$FF40,$14(a3)
	bgt.w	.10950
	cmpi.w	#$FEFA,$14(a3)
	blt.w	.10A42
	bra.w	.10964
.10950
	cmpi.w	#$C0,$14(a3)
	blt.w	.10A42
	cmpi.w	#$106,$14(a3)
	bgt.w	.10A42
.10964
	movem.w	d0-d1,-(sp)
	move.w	(puckx).w,d0
	sub.w	(a3),d0
	move.w	(pucky).w,d1
	sub.w	$14(a3),d1
	cmp.w	#$10,d0
	bgt.w	.1099E
	cmp.w	#$FFF0,d0
	blt.w	.1099E
	cmp.w	#$10,d1
	bgt.w	.1099E
	cmp.w	#$FFF0,d1
	blt.w	.1099E
	move.w	$54(a3),d0
	bra.w	.109A2
.1099E
	bsr.w	vtoa
.109A2
	btst	#0,(word_FFC2F4).w
	bne.w	.109B8
	bsr.w	sub_DB68
	movem.w	(sp)+,d0-d1
	bra.w	.109D0
.109B8
	movem.w	(sp)+,d0-d1
	cmp.w	#8,d0
	beq.w	.109D0
	movem.w	d0-d1,-(sp)
	bsr.w	sub_DB68
	movem.w	(sp)+,d0-d1
.109D0
	move.w	#2,d1
	btst	#1,$63(a3)
	bne.w	.10ADA
	bsr.w	SetSPA
	cmp.w	#8,d0
	bne.w	.10A3C
	tst.w	$34(a3)
	bne.w	.10A3C
	btst	#3,$62(a3)
	beq.w	.10A3C
	move.w	d0,-(sp)
	move.w	$14(a3),d0
	btst	#7,$62(a3)
	beq.w	.10A0E
	neg.w	d0
.10A0E
	cmp.w	#$D8,d0
	blt.w	.10A34
	move.w	(a3),d0
	cmp.w	#$20,d0
	bgt.w	.10A34
	cmp.w	#$FFE0,d0
	blt.w	.10A34
	move.w	(sp)+,d0
	jsr	(stopna2).l
	bra.w	.10A3C
.10A34
	jsr	(stopna2).l
	move.w	(sp)+,d0
.10A3C
	move.w	d0,d2
	bra.w	playeracc
.10A42
	move.w	#2,d1
	btst	#3,$62(a3)
	beq.w	.goalieacc2
	btst	#2,$62(a3)
	bne.w	.cgl
	cmp.w	#8,d0
	bne.w	.10AA6
	tst.w	$34(a3)
	bne.w	.cgl
	move.w	d0,-(sp)
	move.w	$14(a3),d0
	btst	#7,$62(a3)
	beq.w	.10A7C
	neg.w	d0
.10A7C
	cmp.w	#$D8,d0
	blt.w	.10AA0
	move.w	(a3),d0
	cmp.w	#$20,d0
	bgt.w	.10AA0
	cmp.w	#$FFE0,d0
	blt.w	.10AA0
	move.w	(sp)+,d0
	bsr.w	stopna
	bra.w	.cgl
.10AA0
	move.w	(sp)+,d0
	bra.w	.cgl
.10AA6
	bra.w	.d1
.goalieacc2
	andi.w	#$F,d0
	cmp.w	#7,d0
	ble.w	.d1
	cmp.w	#9,d0
	bne.w	.cgl
	move.w	$28(a3),d0
	or.w	$2A(a3),d0
	beq.w	.cgl
	jmp	stopna2
.cgl
	btst	#1,$63(a3)
	beq.w	SetSPA
.10ADA
	rts
.d1
	sub.w	$54(a3),d0
	beq.w	.d11
	neg.w	d0
	andi.w	#4,d0
	lsr.w	#1,d0
	subq.w	#1,d0
	add.w	$54(a3),d0
	andi.w	#7,d0
	move.w	d0,$54(a3)
.d11
	move.w	#$3D8,d1
	bsr.w	SetSPA
	move.w	$54(a3),d2
	bra.w	playeracc
noturn0
	moveq	#2,d4
	btst	#4,$62(a3)
	beq.w	.10B1C
	addq.w	#4,d4
	eori.w	#8,d0
.10B1C
	tst.w	d0
	beq.w	.10B76
	move.w	$28(a3),d0
	move.w	$2A(a3),d1
	bsr.w	vtoa
	btst	#3,d0
	bne.w	.10B48
	sub.w	$54(a3),d0
	add.w	d4,d0
	andi.w	#7,d0
	cmp.w	#4,d0
	blt.w	dostop
.10B48
	addq.w	#1,$54(a3)
	btst	#3,4(a3)
	beq.w	.10B5A
	subq.w	#2,$54(a3)
.10B5A
	andi.w	#7,$54(a3)
	move.w	#$50C,d1
	btst	#4,$62(a3)
	beq.w	SetSPA
	move.w	#$A60,d1
	bra.w	SetSPA
.10B76
	move.w	#$A92,d1
	btst	#4,$62(a3)
	bne.w	.10BA6
	move.w	#$5D0,d1
	btst	#6,$63(a3)
	beq.w	.10B96
	move.w	#$11E6,d1
.10B96
	move.w	(puckc).w,d4
	cmp.w	$52(a3),d4
	bne.w	.10BA6
	move.w	#$53E,d1
.10BA6
	btst	#1,$63(a3)
	bne.w	noturn
	bsr.w	SetSPA
noturn
	btst	#4,$62(a3)
	beq.w	playeracc
	eori.w	#4,d2
; d2 = direction of acc
playeracc
	asl.w	#2,d2
	lea	dirtab(pc),a0
	move.w	2(a0,d2.w),d1	;Y Inc
	move.w	0(a0,d2.w),d0	;x Inc
	move.w	$50(a3),d2	;check acc dir and dont push wall
	;wallsin
	beq.w	.nox
	eor.w	d0,d2
	bpl.w	.nox
	clr.w	d0
.nox
	move.w	$4E(a3),d2	;wallcos
	beq.w	.noy
	eor.w	d1,d2
	bmi.w	.noy
	clr.w	d1
.noy
	clr.w	d2	;clear d2
	move.b	$67(a3),d2	;move wgt of player into d2
	lsr.w	#2,d2	;divide d2 by 2
	neg.w	d2	;make it negative
	addi.w	#$40,d2	;'@'   ; add 40 hex (64 decimal) to d2
	add.b	$68(a3),d2	;add agl (legstr) of player to d2
	btst	#1,(byte_FFC2FE).w
	bne.w	.incagl
	btst	#6,(byte_FFC2FC).w	;check flag for crowd meter record
	beq.w	.incaglg	;branch if not set
.incagl
	addq.b	#2,d2	;add 2 to d2 (crowd meter boost)
.incaglg
	tst.w	$34(a3)	;test for goalie
	bne.w	.noy2
	add.b	$68(a3),d2	;goalie gets double agl
	addi.w	#$10,d2	;double agl + 10 hex
.noy2
	asr.w	#1,d2	;divide by 2
	muls.w	d2,d0	;x
	muls.w	d2,d1	;y
	asr.l	#5,d0	;divide by 32
	asr.l	#5,d1
	muls.w	d7,d0	;mult d0 with frames elapsed (d7)
	muls.w	d7,d1	;mult d1 by frames elapsed (d7)
	tst.w	$34(a3)	;test goalie
	bne.w	.noy3
	btst	#3,$62(a3)	;joypad controlled
	beq.w	.noy3	;no, then jump
	move.w	(puckc).w,d2	;puck carrier SCnum
	cmp.w	$52(a3),d2	;carrying puck?
	bne.w	.noy3	;jump if not
	asr.w	#1,d0	;divide by 2 (puck carrier, joypad controlled)
	asr.w	#1,d1	;divide by 2
.noy3
	add.w	$28(a3),d0	;Xvel
	add.w	$2A(a3),d1	;Yvel
	move.w	d0,d2	;move d0 into d2
	move.w	d1,d3	;move d1 into d3
	muls.w	d2,d2	;square d2
	muls.w	d3,d3	;square d3
	add.l	d2,d3	;add together
	movem.w	d0-d1,-(sp)	;push d0 and d1 to stack
	bsr.w	getpde
	btst	#4,(byte_FFC2FC).w
	beq.w	.noy4
	move.w	#$1000,d0	;d0 = energy, move 1000 hex into d0
.noy4
	clr.w	d2	;clear d2
	move.b	$69(a3),d2	;add speed (legspd) to d2
	btst	#1,(byte_FFC2FE).w
	bne.w	.incspd
	btst	#6,(byte_FFC2FC).w	;skip boost if 0
	beq.w	.noy5
.incspd
	addq.b	#2,d2	;add 2 to d2 (speed)
	cmp.b	#$1E,d2	;compare to max speed attribute (1E or 30)
	ble.w	.noy5	;branch if less than
	move.b	#$1E,d2	;limit it to max speed
.noy5
	move.w	d2,(TempRawSpd).w	;hold spd value
	lsr.w	#1,d2	;divide by 2
	mulu.w	d0,d2	;multiply energy with spd
	asl.l	#4,d2	;mult by 16
	swap	d2	;swap d2 words (this math is to adjust for energy. Line Changes off, d2 = Spd value / 2)
	asl.w	#2,d2	;mult by 4 (No Line changes result from above = Spd value * 2)
	andi.w	#$3F,d2	;'?'   ; pass first 6 bits. Limits d2 to $3F (63 decimal)
	lea	MaxSpeed(pc),a2	;move Maxspeed table address into a2
	move.w	d2,(TempEnergySpd).w	;hold new spd value
	move.l	0(a2,d2.w),d2	;use value from MaxSpeed list
	move.l	d2,(TempMaxSpd).w	;hold MaxSpeed value
	cmpi.w	#$3C,(TempEnergySpd).w	;'<' ; compare new spd value with 60 decimal
	bge.w	.fgtinj	;branch if greater than or equal
	btst	#0,(TempRawSpd+1).w	;check if TempRawSpd is odd
	beq.w	.fgtinj	;branch if even
	move.w	(TempEnergySpd).w,d2	;move TempEnergySpd into d2
	addq.w	#4,d2	;add 4 to d2
	move.l	0(a2,d2.w),d2	;use value from MaxSpeed list (rounding the odd number up)
	sub.l	(TempMaxSpd).w,d2	;sub TempMaxSpd from d2
	asr.l	#1,d2	;divide by 2
	add.l	(TempMaxSpd).w,d2	;add TempMaxSpd to d2 (so halves the difference between the 2 Speed steps)
.fgtinj
	btst	#6,$63(a3)	;check if injured during fight
	beq.w	.puckc	;branch if not
	lsr.l	#3,d2	;divide d2 by 8
.puckc
	tst.w	$34(a3)	;test goalie
	bne.w	.noy6	;branch if not goalie
	move.w	(puckc).w,d0	;puck carrier SCnum
	cmp.w	$52(a3),d0	;check if puck carrier
	bne.w	.noy6	;branch if not puck carrier
	asr.l	#1,d2	;divide d2 by 2
.noy6
	movem.w	(sp)+,d0-d1	;pop from stack
	cmp.l	d2,d3	;Compare d3 to d2 (max speed check)
	bhi.w	.sube	;branch if d3 is higher than d2 (no increase in velocity)
	move.w	d0,$28(a3)	;move new Xvel into Xvel
	move.w	d1,$2A(a3)	;move new Yvel into Yvel
.sube
	tst.w	(OptLine).w
	bne.w	rtss2
	move.w	(VDP_CNTR).l,d0
	andi.w	#$7F,d0
	bne.w	rtss2
	bsr.w	getpde
	subi.w	#$21,d0
	cmp.w	#$C00,d0
	blt.w	setpde
	move.b	$72(a3),d2	;endurance
	ext.w	d2
	lsr.w	#1,d2
	add.w	d2,d0
	bsr.w	setpde
	btst	#0,$72(a3)
	beq.w	.ex
	btst	#0,(vcount+1).w
	beq.w	.ex
	addq.w	#1,d0
	bra.w	setpde
.ex
	rts
MaxSpeed	;max speed values for each rating level 0-$F: ((n+20)*275)^2 (as 93; 92 used 250)
	dc.l	(20*275)*(20*275)	;$1CD9410
	dc.l	(21*275)*(21*275)	;$1FCE3E1
	dc.l	(22*275)*(22*275)	;$22E8284
	dc.l	(23*275)*(23*275)	;$2626FF9
	dc.l	(24*275)*(24*275)	;$298AC40
	dc.l	(25*275)*(25*275)	;$2D13759
	dc.l	(26*275)*(26*275)	;$30C1144
	dc.l	(27*275)*(27*275)	;$3493A01
	dc.l	(28*275)*(28*275)	;$388B190
	dc.l	(29*275)*(29*275)	;$3CA77F1
	dc.l	(30*275)*(30*275)	;$40E8D24
	dc.l	(31*275)*(31*275)	;$454F129
	dc.l	(32*275)*(32*275)	;$49DA400
	dc.l	(33*275)*(33*275)	;$4E8A5A9
	dc.l	(34*275)*(34*275)	;$535F624
	dc.l	(35*275)*(35*275)	;$5859571
; player a3 stops
; .slim = 1000
dostop
	cmpi.w	#$1000,$28(a3)	;Xvel
	bgt.w	.set
	cmpi.w	#$F000,$28(a3)
	blt.w	.set
	cmpi.w	#$1000,$2A(a3)	;Yvel
	bgt.w	.set
	cmpi.w	#$F000,$2A(a3)
	blt.w	.set
	tst.w	$34(a3)	;check if goalie
	bne.w	stopna
	jmp	stopna2
	bra.w	stopna
.set
	move.w	#$50C,d1	;#SPAglide
	btst	#4,$62(a3)	;#pfrev - skating backwards
	bne.w	.0
	bset	#1,$63(a3)	;#pf2aip
	move.w	#$6C6,d1	;#SPAstop
.0
	bsr.w	SetSPA
	tst.w	$34(a3)
	bne.w	stopna
	jmp	stopna2
; stop with no animation
stopna
	tst.w	$28(a3)	;Xvel
	bpl.w	.xp
	addi.w	#$96,$28(a3)
	bmi.w	.y
	clr.w	$28(a3)
.xp
	subi.w	#$96,$28(a3)
	bpl.w	.y
	clr.w	$28(a3)
.y
	tst.w	$2A(a3)	;Yvel
	bpl.w	.yp
	addi.w	#$96,$2A(a3)
	bmi.w	rtss2
	clr.w	$2A(a3)
.yp
	subi.w	#$96,$2A(a3)
	bpl.w	rtss2
	clr.w	$2A(a3)
	rts
dirtab	dc.w	0
	;X/Y acc speed for each direction 0-7
	;runspeed constant = 200 ($C8)
	dc.w	$C8
	dc.w	$8D	;runspeed / sqrt(2)
	dc.w	$8D
	dc.w	$C8
	dc.w	0
	dc.w	$8D
	dc.w	$FF73	;- runspeed / sqrt(2)
	dc.w	0
	dc.w	$FF38	;- runspeed
	dc.w	$FF73
	dc.w	$FF73
	dc.w	$FF38
	dc.w	0
	dc.w	$FF73
	dc.w	$8D
	dc.w	0
	dc.w	0
UnpackNibbles	;IDA: sub_10E88 (93 name). a0 = packed data, d0 = count: unpack 4-bit values into words at dword_FFD036
	movem.l	d0-d2/a0-a1,-(sp)
	movea.w	#(dword_FFD036-M68K_RAM),a1
	clr.w	d2
	bra.w	.10EAA
.10E96
	move.b	(a0)+,d1
	bchg	#0,d2
	bne.w	.10EA4
	subq.w	#1,a0
	lsr.w	#4,d1
.10EA4
	andi.w	#$F,d1
	move.w	d1,(a1)+
.10EAA
	dbf	d0,.10E96
	movem.l	(sp)+,d0-d2/a0-a1
	rts
WeightedRandomSelect	;IDA: sub_10EB4 (93 name). d0 = number of word weights at dword_FFD036: return a weighted random index
	movem.l	d1/a1,-(sp)
	movea.w	#(dword_FFD036-M68K_RAM),a1
	clr.w	d1
	bra.w	.10EC4
.10EC2
	add.w	(a1)+,d1
.10EC4
	dbf	d0,.10EC2
	move.w	d1,d0
	bsr.w	randomd0
.10ECE
	sub.w	-(a1),d0
	bpl.s	.10ECE
	suba.w	#$D036,a1
	move.w	a1,d0
	lsr.w	#1,d0
	movem.l	(sp)+,d1/a1
	rts
