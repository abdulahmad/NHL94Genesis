;	NHL 94 (retail) segment $150E4-$15D99
;	92 hockey.asm part 2 tail, then the 92 part 3 player-roster code, as 93 hockey93_05.asm: puckstick, puckglue, puckbody,
;	rtss2 (the shared rts), puckgoalie, deflect, makepde, getpde, setpde, SetPersonel, SetPlList, findAvailablePlayer, the
;	94-only sub_1592C, forcepldata, ResetBench, Setplass, setplayer, checkattriblimits. The vblank handler (93 VBlank,
;	IDA loc_15D9A, video94_1) follows at $15D9A.
;	Transcribed from lst/nhl94.bin.lst lines 50532-51764. Global names are the IDA names. IDA _glue (puckstick, also
;	entered from puckgoalie) is the 93 global puckglue. IDA labels that would split a routine are locals:
;	.CheckStkForContactWithSkater and .PlayerPassOrLoosePuckStkLoad in puckstick, .AwayTeam in setplayer. Local labels are
;	the IDA local names (_x -> .x) or the IDA address (loc_15140 -> .15140).
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi;
;	fixopcodes.js patches the cmp encoding after assembly.
;	Sort struct (SortCords, $80 each): 0 Xpos, 4 attribute, 6 frame, $14 Ypos, $18 Zpos, $28 Xvel, $2A Yvel, $2C Zvel,
;	$34 position, $46 temp4, $48 temp5, $52 SCnum, $54 facedir, $58 SPA, $5A, $5E nopuck (byte), $60 newpos, $61 newpnum,
;	$62 pflags, $63 pflags2, $64 bit 3 one-timer, $66 pnum, then the attributes setplayer writes: $67 Wgt, $68 Agl,
;	$69 Spd, $6A OfA, $6B DfA, $6C ShP, $6D ShA, $6E Pas, $6F jersey, $70 PS bias, $71 Stk, $72 End, $73 Agr, $74 Fgt,
;	$75 Chk, $76 handed.
;	94 team struct from HmShots (tmsize $364): $E faceoffs won, $14 passes completed, $16 tmline, $1A / $1C assists, $1E
;	tmdata, $22 tmsort, $24 tmap, $26 tmgoalie, $30 tmflags, $32 tmpde, $66 tmpdst (-4 / -3 injured, -2 bench, -1 ice,
;	>0 penalty box), $16A line sets.

puckstick	;puck collides with stick. a2 = player who collided, a3 = puck, d0 = distance^2 (from checkpuckcoll .ccx). A stick check on the puck
	;carrier can steal the puck (Stk rolls, smaller ranges when the carrier is in the slot, word_FFC2F8 bit 5), else a slow enough puck is caught
	;(puckglue); a one-timer shoots it (onetimershot). 94 adds the slot ranges and the one-timer path
	tst.w	$34(a2)	;a2 = player who collided
	;a3 = puck
	bne.w	.0	;branch if not goalie
	btst	#4,(gmode).w	;check if highlight
	bne.w	rtss2	;exit if so (goalie always lets the shot in)
.0
	bclr	#0,$62(a2)	;clear offside bit
	move.w	(puckc).w,d1	;move puckc into d1
	bmi.w	.nosteal	;branch if no puck carrier
	asl.w	#7,d1
	movea.w	#(SortCords-M68K_RAM),a0
	adda.w	d1,a0	;a0 = Struct of puck carrier
	move.b	$62(a0),d1
	move.b	$62(a2),d2
	eor.w	d1,d2	;compare pflags of each player
	btst	#6,d2	;check if on same team
	beq.w	rtss2	;no stealing from teammate
	btst	#5,(word_FFC2F8).w	;check if puckc is in slot
	beq.w	.noslot	;branch if not
	cmp.l	#$40,d0
	bhi.w	rtss2
	bra.w	.15140
.noslot
	cmp.l	#$24,d0
	bhi.w	rtss2
.15140
	tst.w	$34(a2)	;check if colliding player is goalie
	beq.w	.steal	;branch if goalie
	tst.w	$34(a0)	;check if goalie
	beq.w	rtss2	;no stealing from goalie
.CheckStkForContactWithSkater	;IDA: CheckStkForContactWithSkater (no xref; a label inside puckstick). Stk for puckc
	;Stk for puckc
	move.b	$71(a0),d0
	lsr.b	#1,d0	;divide by 2
	bsr.w	makepde	;adjust for energy level
	move.w	d0,-(sp)	;push onto stack
	exg	a0,a2	;swap a2 and a0 (a0 now collider)
	move.b	$71(a0),d0	;Stk for collider
	lsr.b	#1,d0	;divie by 2
	bsr.w	makepde	;adjust for energy
	exg	a0,a2	;swap back (a0 now puckc)
	neg.w	d0	;negate d0
	add.w	(sp)+,d0	;add puckc modified Stk
	addi.w	#$24,d0	;add 24 hex (36 decimal)
	bsr.w	randomd0	;RNG
	btst	#5,(word_FFC2F8).w	;check if puckc is in slot
	beq.w	.1518C	;branch if not
	cmp.w	#4,d0	;compare 4 to d0
	bhi.w	rtss2	;exit if higher (not losing puck)
	bra.w	.steal
.1518C
	cmp.w	#2,d0	;compare 2 to d0
	bhi.w	rtss2	;exit if higher (not losing puck)
.steal
	move.b	$71(a0),d0	;Stk of puckc
	lsr.b	#1,d0	;divide by 2
	bsr.w	makepde	;adj for energy
	addi.w	#$14,d0	;add 14 hex (20 dec)
	move.b	d0,$5E(a0)	;move result into nopuck (cant get puck timer)
	exg	a0,a2	;swap a0 and a2 (a0 now collider)
	move.b	$71(a0),d0	;Stk of collider
	lsr.b	#1,d0	;divide by 2
	bsr.w	makepde	;adj for energy
	addi.w	#$14,d0	;add 14 hex (20 dec)
	move.b	d0,$5E(a0)	;move result into nopuck
	exg	a0,a2	;swap back
	move.w	$52(a0),(lastplayer).w	;SCNum of puckc into lastplayer
	bclr	#2,(sflags).w	;clear pass dir mode
	bclr	#3,(sflags).w	;clear shot dir mode
.stdef
	move.w	#6,-(sp)	;#SFXstdef
	bsr.w	sfx
	bsr.w	a2touchpuck	;deflect (93 .stdef falls into deflect)
	bra.w	deflect
.nosteal
	tst.w	$34(a2)	;check if goalie
	bne.w	.onetimerchk	;branch if not
	cmp.l	#$40,d0
	bhi.w	rtss2	;smaller range for stealing puck
.onetimerchk
	btst	#3,$64(a2)	;check if onetimer
	beq.w	.nosteal2	;branch if not
	cmp.l	#$64,d0
	bhi.w	.15268
	cmpi.w	#$18,$5A(a2)
	bge.w	.nosteal2
	move.w	#$18,$5A(a2)
	bset	#7,(byte_FFC2FE).w
.nosteal2
	move.w	(puckvx).w,d0
	move.w	(puckvy).w,d1
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	clr.w	d1
	btst	#4,(sflags2).w	;check if shot was taken
	bne.w	.15246	;branch if so
	btst	#3,$64(a2)	;check if one timer
	bne.w	.onetimer	;branch if so
.PlayerPassOrLoosePuckStkLoad	;IDA: PlayerPassOrLoosePuckStkLoad (no xref; a label inside puckstick)
	move.b	$71(a2),d1
	mulu.w	#$15E,d1
.15246
	addi.w	#$32C8,d1
	mulu.w	d1,d1
	cmp.l	d1,d0
	bls.w	puckglue
	move.b	#8,$5E(a2)
	bra.w	.stdef
.onetimer
	exg	a2,a3
	jsr	(onetimershot).l	;94 only
	exg	a2,a3
	rts
.15268
	cmp.l	#$144,d0
	bhi.w	.ex2
	cmpi.w	#$18,$5A(a2)
	bge.w	.ex2
	move.w	#$18,$5A(a2)
.ex2
	rts
puckglue	;IDA: _glue, a local of puckstick that puckgoalie also branches to (93 name). Player a2 takes the puck (92 puckstick .glue): faceoff
	;and pass stats, crowd song, goalie hold time (temp5), then .setd0player
	move.w	#7,-(sp)	;SFXpuckget (song)
	move.w	$52(a2),d0	;move SCnum into d0
	move.w	d0,(puckc).w	;move d0 into puckc
	movea.w	#(HmShots-M68K_RAM),a0	;Move Home Stats struct into a0
	lea	$364(a0),a1	;tmsize
	btst	#6,$62(a2)	;check if player is home or away
	bne.w	.152A4	;branch if away
	exg	a0,a1	;swap struct addresses
.152A4
	st	$1A(a0)	;FF into assist 1
	st	$1C(a0)	;FF into assist 2
	bset	#3,$30(a0)	;set a flag (not sure what)
	bclr	#4,(sflags3).w	;clear flag (not sure what, might have to do with faceoff)
	beq.w	.152DC	;branch if it was cleared already
	addq.w	#1,$E(a1)	;add 1 to faceoff won
	addi.w	#$C8,(crowdlevel).w	;add to crowdlevel
	move.w	#$C,(sp)	;move C to stack
	cmpa.w	#(HmShots-M68K_RAM),a1	;compare if a1 is home
	bne.w	.152DC	;branch if not
	addi.w	#$A,(CwdExciteLvl).w	;add to CwdExciteLvl
	move.w	#$B,(sp)	;Move B into stack
.152DC
	bsr.w	song
	move.w	$52(a2),d0	;move SCnum into d0
	cmp.w	(passplayer).w,d0	;compare to d0
	bne.w	.152F0	;branch if not equal
	addq.w	#1,$14(a1)	;add 1 to pass completed
.152F0
	st	(passplayer).w	;set to FFFF
	bclr	#2,(sflags).w	;clear pass dir mode
	bclr	#3,(sflags).w	;clear shot dir mode
	tst.w	$34(a2)	;check if a2 is goalie
	bne.w	.setd0player	;branch if not
	bsr.w	ChkShotStat
	move.w	#$8C,$48(a2)	;move 8C to temp5 - countdown for faceoff?
	cmpi.w	#$2F4,$58(a2)	;SPAgdive. check for goalie dive animation
	bne.w	.setd0player	;branch if not equal
	move.w	#5,$48(a2)	;set temp5 to 5
.setd0player	;IDA: _setd0player (93 setd0player). Give control of player d0 to a controller if his team is controlled. 94 checks the pads 3 and 4 too (cont3team / cont4team)
	cmp.w	(c1playernum).w,d0
	beq.w	rtss2	;exit if player controlled
	cmp.w	(c2playernum).w,d0
	beq.w	rtss2	;exit if player controlled
	tst.w	(cont3team).w
	beq.w	.cont4chk	;branch if 0
	cmp.w	(c3playernum).w,d0
	beq.w	rtss2	;exit if player controlled
.cont4chk
	tst.w	(cont4team).w
	beq.w	.15352	;branch if 0
	cmp.w	(c4playernum).w,d0
	beq.w	rtss2	;exit if player controlled
.15352
	tst.w	(cont3team).w
	bne.w	.15362	;branch if no team
	tst.w	(cont4team).w
	beq.w	.setd0player2	;branch if no team
.15362
	movem.l	d0/a3,-(sp)
	asl.w	#7,d0
	movea.l	#SortCords,a3
	tst.w	$34(a3,d0.w)	;check if goalie
	bne.w	.15386	;branch if not
	btst	#3,$62(a3,d0.w)	;check if d0 player controlled
	beq.w	.15386	;branch if not
	movem.l	(sp)+,d0/a3	;exit if player controlled
	rts
.15386
	movem.l	(sp)+,d0/a3
.setd0player2
	cmp.w	#6,d0
	slt	d1
	ext.w	d1
	addq.w	#2,d1
	move.w	(lastplayer).w,d2
	cmp.w	(c2playernum).w,d2
	beq.w	.153AE
	cmp.w	(cont1team).w,d1
	bne.w	.153AE
	jmp	setc1player	;logic94_1
.153AE
	cmp.w	(cont2team).w,d1
	bne.w	.153BC
	jmp	setc2player	;logic94_1
.153BC
	cmp.w	(cont1team).w,d1
	bne.w	rtss2
	jmp	setc1player	;logic94_1
puckbody	;puck hits player a2. a3 = puck, d0 = distance^2 (from checkpuckcoll .ccx). The puck bounces off. A high puck (Zpos > 8) that is fast
	;makes a2 fall (FallDown, Zpos > $C); a slower one starts SPAcatch ($10D0) on a2
	btst	#3,$64(a2)
	bne.w	rtss2
	cmpi.w	#8,$18(a3)
	bgt.w	.hit
	move.w	d0,d1
	andi.w	#$F,d1
	bne.w	rtss2
.hit
	bsr.w	a2touchpuck
	move.w	#$24,-(sp)	;SFXpuckbody
	bsr.w	sfx
	clr.w	$2C(a3)
	move.b	#8,$5E(a2)
	move.w	(a3),d0
	sub.w	(a2),d0
	move.w	$14(a3),d1
	sub.w	$14(a2),d1
	bne.w	.15414
	move.l	a2,-(sp)
	bsr.w	GetHot
.15414
	move.w	$28(a3),d2
	move.w	$2A(a3),d3
	move.b	d0,$28(a3)
	move.b	d1,$2A(a3)
	bsr.w	puckflip
	cmpi.w	#8,$18(a3)
	ble.w	rtss2
	muls.w	d2,d2
	muls.w	d3,d3
	add.l	d3,d2
	cmp.l	#$9000000,d2	;fast puck
	bls.w	.1544E
	cmpi.w	#$C,$18(a3)
	bgt.w	FallDown
	rts
.1544E
	bset	#5,$62(a2)
	bne.w	rtss2
	move.w	#$10D0,d1	;SPAcatch
	exg	a2,a3
	bsr.w	SetSPA
	exg	a2,a3
rtss2	;shared rts (93 rtss), branched to from many segments
	rts
puckgoalie	;puck hits goalie a2. a3 = puck, d0/d1 = goalie - puck x/y. The save odds come from the goalie's glove / stick attributes (.list) and
	;the frame tables .list2 (93 goalie frames) and .list3 (94 frames from $292); a save bounces the puck off (.bounceoff), a slow puck near the
	;crease is held (puckglue)
	btst	#4,(gmode).w	;check if highlight
	bne.s	rtss2	;exit if highlight
	clr.w	d2	;puck region
	cmpi.w	#8,$18(a3)	;compare to Zpos
	bgt.w	.1
	addq.w	#2,d2	;add 2 to d2
.1
	neg.w	d0	;negate d0
	neg.w	d1	;negate d1
	bsr.w	vtoa	;convert directions
	sub.w	$54(a2),d0	;sub facedir into d0
	andi.w	#7,d0	;pass first 3 bits to d0
	;0 = puck straight in front of G
	;1-3 = puck to G right
	;4 = puck straight behind G
	;5-7 = puck to G left
	move.w	d0,d1	;move d0 into d1
	andi.w	#3,d1	;pass first 2 bits of d1
	bne.w	.2	;will branch if puck is to the left or right of G
	move.w	(VDP_CNTR).l,d0	;just for random bit
.2
	andi.w	#4,d0	;pass 3rd bit of d0. d0 will be either 4 (left) or 0 (right)
	lsr.w	#2,d0	;divide by 4. d0 will be either 1 (left) or 0 (right)
	eori.w	#1,d0	;XOR d0 - will make 1 a 0 (left), and 0 a 1 (right)
	add.w	d0,d2	;add to d2. d2 will now be 0 or 1 (Zpos > 8) or 2 or 3 (Zpos <= 8)
	add.w	d2,d2	;add d2 to itself. 0 Glove L, 2 Glove R, 4 Stick L, 6 Stick R
	lea	.list(pc),a0	;contains offsets for save attributes
	move.w	0(a0,d2.w),d0	;move from list into d0
	moveq	#$F,d1	;move F into d1
	add.b	0(a2,d0.w),d1	;save odds = save attribute + F (15 dec)
	lea	.list2(pc),a0
	btst	#3,4(a2)	;attribute a2 - x flip?
	beq.w	.3
	eori.w	#2,d2	;XOR d2 with 2
.3
	move.w	6(a2),d0	;move frame into d0
	move.w	#$197,-(sp)	;SPFgoalie (frames94)
	cmp.w	#$233,d0	;compare 233 hex to d0 (goal light frame, all frames before are goalie frames)
	blt.w	.32	;branch if less than (old goalie frame)
	move.w	#$292,(sp)	;94: the goalie frames added in 94
	lea	.list3(pc),a0
.32
	sub.w	(sp)+,d0	;sub stack value (SPFgoalie) from d0
	move.b	0(a0,d0.w),d0	;move value from list2 or list3 at offset to d0
	lsr.w	d2,d0	;shift d0 by d2
	andi.w	#3,d0	;pass first 2 bits of d0
	bclr	#2,(word_FFC2F4).w	;clear bit 2 - this is not used anywhere, might have been a debug flag
	bsr.w	ChkShotStat
	bsr.w	a2touchpuck
	cmpi.w	#$3000,(puckvy).w	;compare with puck velocity y
	bgt.w	.setsfx	;branch if greater
	cmpi.w	#$D000,(puckvy).w	;compare -3000 with puckvy
	bgt.w	.15526	;branch if greater
.setsfx
	move.w	#$B,-(sp)	;home song
	btst	#6,$62(a2)	;check home or away
	beq.w	.15522	;branch if home
	move.w	#$D,(sp)	;away song
.15522
	bsr.w	song
.15526
	move.w	#$24,-(sp)	;#SFXpuckbody
	bsr.w	sfx
	move.w	(puckc).w,d2	;move puckc into d2
	bmi.w	.chkanim	;branch if no puckc
	st	(puckc).w
	asl.w	#7,d2
	movea.w	#(SortCords-M68K_RAM),a0
	adda.w	d2,a0
	move.b	#$14,$5E(a0)
	move.w	$52(a0),(lastplayer).w
	bclr	#2,(sflags).w
	bclr	#3,(sflags).w
.bounceoff
	clr.w	$2C(a3)	;clear puck Zvel
	move.b	#$A,$5E(a2)	;move A into nopuck collision
	move.w	#4,$46(a2)	;move 4 into temp4
	move.w	(a3),d0	;move puck Xpos into d0
	sub.w	(a2),d0	;sub Xpos of goalie from d0
	move.w	$14(a3),d1	;move puck Ypos into d1
	sub.w	$14(a2),d1	;sub Ypos of goalie from d1
	bne.w	.15580	;branch if not equal
	move.l	a2,-(sp)	;pop onto stack
	bsr.w	GetHot
.15580
	move.b	d0,$28(a3)	;move d0 into puck Xvel
	move.b	d1,$2A(a3)	;move d1 into puck Yvel
	bra.w	puckflip	;flip puck
	bset	#2,(word_FFC2F4).w	;not reached (after bra.w puckflip)
	rts
.chkanim
	cmpi.w	#$2F4,$58(a2)	;SPAgdive. check for goalie dive animation
	beq.s	.bounceoff	;branch if equal
	moveq	#2,d0	;move 2 into d0
	add.b	$6C(a2),d0	;add puck control to d0
	asl.w	#8,d0	;mult by 256
	asl.w	#1,d0	;mult by 2
	bsr.w	randomd0	;random
	addi.w	#$C00,d0	;add C00 to d0
	add.w	d0,d0	;double d0
	bpl.w	.pos	;branch if positive
	move.w	#$7FFF,d0	;make max positive
.pos
	btst	#1,$63(a2)	;check if in animation
	bne.w	.chkpuckv	;branch if so
	cmpi.w	#$2C,(a3)	;compare 2C to Xpos of puck
	bgt.w	.chkpuckv	;branch if greater than
	cmpi.w	#$FFD4,(a3)
	blt.w	.chkpuckv	;branch if less than -2C
	cmpi.w	#$10E,$14(a3)	;compare 10E to puck Ypos
	bgt.w	.chkpuckv	;branch if greater than
	cmpi.w	#$FEF2,$14(a3)	;compare to -10E
	blt.w	.chkpuckv	;branch if less than
	cmpi.w	#$D2,$14(a3)	;compare D2 to Ypos
	bgt.w	.closepuck	;branch if greater than
	cmpi.w	#$FF2E,$14(a3)	;compare -D2 to Ypos
	bgt.w	.chkpuckv	;branch if greater than
.closepuck
	asr.w	#2,d0	;divide by 4
.chkpuckv
	cmp.w	(puckvx).w,d0	;compare puckvx with d0
	blt.w	.bounceoff	;branch if less than
	cmp.w	(puckvy).w,d0	;compare puckvy to d0
	blt.w	.bounceoff	;branch if less than
	neg.w	d0	;negate d0, compare if shot going down
	cmp.w	(puckvx).w,d0
	bgt.w	.bounceoff	;branch if greater than
	cmp.w	(puckvy).w,d0
	bgt.w	.bounceoff	;branch if greater than
	btst	#2,$63(a2)	;check if player unavailable
	bne.w	.bounceoff	;branch if so
	clr.w	$2C(a3)	;clear puck Zvel
	bra.w	puckglue
.list	dc.w	$73	;IDA: _list. Save attribute offsets: GGSleft
	;GGSleft
	dc.w	$6E	;GGSright
	dc.w	$70	;GSSleft
	dc.w	$72	;GSSright
.list2	dc.b	$55	;IDA: _list2. 2 bit save odds per quadrant, one byte per goalie frame from SPFgoalie
	;odds for stopping puck in each quadrant for each possible goalie frame
	dc.b	$9D
	dc.b	$67	;g
	dc.b	$55	;U
	dc.b	$9D
	dc.b	$67	;g
	dc.b	$55	;U
	dc.b	$9D
	dc.b	$67	;g
	dc.b	$55	;U
	dc.b	$9D
	dc.b	$67	;g
	dc.b	$55	;U
	dc.b	$9D
	dc.b	$67	;g
	dc.b	$55	;U
	dc.b	$9D
	dc.b	$67	;g
	dc.b	$55	;U
	dc.b	$9D
	dc.b	$67	;g
	dc.b	$55	;U
	dc.b	$9D
	dc.b	$67	;g
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$F0
	dc.b	$55	;U
	dc.b	$F0
	dc.b	$55	;U
	dc.b	$F0
	dc.b	$55	;U
	dc.b	$F0
	dc.b	$55	;U
	dc.b	$F0
	dc.b	$55	;U
	dc.b	$F0
	dc.b	$55	;U
	dc.b	$F0
	dc.b	$55	;U
	dc.b	$F0
	dc.b	$55	;U
	dc.b	$F0
	dc.b	$55	;U
	dc.b	$F0
	dc.b	$55	;U
	dc.b	$F0
	dc.b	$55	;U
	dc.b	$F0,$D5
	dc.b	$75	;u
	dc.b	$D5
	dc.b	$75	;u
	dc.b	$D5
	dc.b	$75	;u
	dc.b	$D5
	dc.b	$75	;u
	dc.b	$D5
	dc.b	$75	;u
	dc.b	$D5
	dc.b	$75	;u
	dc.b	$D5
	dc.b	$75	;u
	dc.b	$D5
	dc.b	$75	;u
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$55	;U
	dc.b	$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	dc.b	$57	;W
	dc.b	$57	;W
	dc.b	$57	;W
	dc.b	$57	;W
	dc.b	$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5
	dc.b	$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5
.list3	dc.b	$9D	;IDA: _list3. The same for the 94 goalie frames from $292
	dc.b	$67	;g
	dc.b	$9D
	dc.b	$67	;g
	dc.b	$9D
	dc.b	$67	;g
	dc.b	$9D
	dc.b	$67	;g
	dc.b	$9D
	dc.b	$67	;g
	dc.b	$9D
	dc.b	$67	;g
	dc.b	$9D
	dc.b	$67	;g
	dc.b	$9D
	dc.b	$67	;g
	dc.b	$D5,$D5
	dc.b	$75	;u
	dc.b	$75	;u
	dc.b	$D5,$D5
	dc.b	$75	;u
	dc.b	$75	;u
	dc.b	$D5,$D5
	dc.b	$75	;u
	dc.b	$75	;u
	dc.b	$D5,$D5
	dc.b	$75	;u
	dc.b	$75	;u
	dc.b	$D5,$D5
	dc.b	$75	;u
	dc.b	$75	;u
	dc.b	$D5,$D5
	dc.b	$75	;u
	dc.b	$75	;u
	dc.b	$D5,$D5
	dc.b	$75	;u
	dc.b	$75	;u
	dc.b	$D5,$D5
	dc.b	$75	;u
	dc.b	$75	;u
deflect	;random puck direction on deflection, puck = a3. Entered from puckstick
	st	(puckc).w
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
makepde	;pass d0 as value to be scaled by player a0's energy level (94: full energy while byte_FFC2FC bit 4 is set). Return d0 as result
	ext.w	d0
	move.w	d0,-(sp)
	movem.l	d1/a2-a3,-(sp)
	movea.l	a0,a3
	bsr.w	getpde
	btst	#4,(byte_FFC2FC).w	;94 only
	beq.w	.0
	move.w	#$1000,d0
.0
	movem.l	(sp)+,d1/a2-a3
	muls.w	(sp)+,d0
	asl.l	#4,d0
	swap	d0
	ext.l	d0
	rts
getpde	;get player a3's energy level into d0. Return a2 = his team struct, d1 = pnum*2
	movea.w	#(HmShots-M68K_RAM),a2
	btst	#6,$62(a3)	;#pfteam - home or away
	beq.w	.0
	adda.w	#$364,a2	;team is away
.0
	move.b	$66(a3),d1	;pnum
	ext.w	d1
	add.w	d1,d1
	move.w	$32(a2,d1.w),d0
	rts
setpde	;d1 = rostnum of player * 2, a2 = team struct, d0 = new energy level (0 if negative)
	tst.w	d0
	bpl.w	.0
	clr.w	d0
.0
	move.w	d0,$32(a2,d1.w)
	rts
SetPersonel	;IDA name (93 setpersonel). This will set personnel on team a2 according to team a2's registers: PlList (SetPlList) gives the players
	;wanted on the ice; each sort obj gets newpos / newpnum
	movem.l	d0-d5/a0-a4,-(sp)
	movea.w	$22(a2),a3	;#tmsort
	moveq	#5,d4	;# of players on team for loop
.10
	st	$60(a3)	;set newpos (FF)
	st	$61(a3)	;set newpnum
	adda.w	#$80,a3	;add size of player struct to a3
	dbf	d4,.10	;loop through each player on team
	bsr.w	SetPlList
	moveq	#5,d4
	movea.w	#(PlList-M68K_RAM),a4	;list of players we want on ice
.1
	clr.w	d5
	move.b	0(a4,d4.w),d5
	beq.w	.next
	subq.w	#1,d5
	moveq	#5,d3
	movea.w	$22(a2),a3	;#tmsort into a3
	suba.w	#$80,a3	;sub player struct size from a3
.2
	adda.w	#$80,a3	;add player struct size to a3
	cmp.b	$66(a3),d5	;compare pnum to d5
	dbeq	d3,.2	;loop through player structs while pnum != d5 (find player d5)
	bne.w	.next	;branches if player not found
	move.b	6(a4,d4.w),$60(a3)	;move a4+d4+6 into newpos
	move.b	d5,$61(a3)	;move d5 into newpnum
	clr.b	0(a4,d4.w)	;clear a4+d4
.next
	dbf	d4,.1
	moveq	#5,d4
	movea.w	#(PlList-M68K_RAM),a4
.3
	clr.w	d5
	move.b	0(a4,d4.w),d5
	beq.w	.next2
	subq.w	#1,d5
	moveq	#5,d3
	movea.w	$22(a2),a3
	suba.w	#$80,a3
.4
	adda.w	#$80,a3
	tst.b	$61(a3)
	dbmi	d3,.4
	bpl.w	.15812
	movea.w	a3,a0
.15812
	tst.w	$34(a3)
	dbpl	d3,.4
	move.b	6(a4,d4.w),$60(a0)
	move.b	d5,$61(a0)
	clr.b	0(a4,d4.w)
.next2
	dbf	d4,.3
	movem.l	(sp)+,d0-d5/a0-a4
	rts
SetPlList	;create PlList of players who we want on the ice now. a2 = team struct. Takes the current line (tmline) by priolist; an unavailable
	;player (in the box or injured, -3 / -4) is replaced from sublist (findAvailablePlayer), or from the whole roster (sub_9F9A)
	movea.w	#(PlList-M68K_RAM),a4
	clr.l	(a4)	;clear 6 bytes (PlList)
	clr.w	4(a4)
	movea.l	#priolist,a0	;priority of positions
	tst.w	$26(a2)	;test tmgoalie
	bpl.w	.gin	;branch if theres a goalie
	addq.w	#1,a0	;add 1 to a0
.gin
	lea	$16A(a2),a1	;moves address of team lines list into a1
	move.w	$16(a2),d0	;current line selected
	asl.w	#3,d0	;mult by 8
	adda.w	d0,a1	;add to a1 to set a1 to currently selected line
	move.w	$24(a2),d4	;tmap - active players (4-6 in normal ROM)
	bra.w	.next
.0
	clr.w	d5
	move.b	0(a0,d4.w),d5	;move position into d5
	move.b	0(a1,d5.w),0(a4,d4.w)
	move.b	d5,6(a4,d4.w)
	bne.w	.next
	moveq	#1,d3
	add.w	$26(a2),d3
	move.b	d3,0(a4,d4.w)
.next
	dbf	d4,.0
	moveq	#5,d4	;now check to see if player is available
.1
	move.b	0(a4,d4.w),d3
	beq.w	.next1
	ext.w	d3
	subq.w	#1,d3
	add.w	d3,d3
	cmpi.w	#$FFFD,$66(a2,d3.w)	;check if player injured for period
	beq.w	.unavail
	cmpi.w	#$FFFC,$66(a2,d3.w)	;check if player injured for game
	beq.w	.unavail
	tst.w	$66(a2,d3.w)
	ble.w	.next1	;player is ok
.unavail
	lea	$16A(a2),a1	;now find a player of similar position who is available
	;move Line Lists again into d0
	move.b	6(a4,d4.w),d0	;move 6+a4+d4 into d0 (previous d5)
	ext.w	d0	;extend d0
	asl.w	#1,d0	;mult by 2
	movea.l	#sublist,a0	;move sublist into a0
	adda.w	0(a0,d0.w),a0	;move a0+d0 into a0
.s1
	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	.error
	move.b	0(a1,d0.w),d0
	bsr.w	findAvailablePlayer
	beq.s	.s1
.next1
	dbf	d4,.1
	rts
.error
	jsr	(sub_9F9A).l	;then try the players from d0 down
	move.w	d0,d3
.158E4
	move.w	d3,d0
	subq.w	#1,d3
	bmi.s	.next1
	bsr.w	findAvailablePlayer
	beq.s	.158E4
	bra.s	.next1
findAvailablePlayer	;IDA name (93 TryAddPlayerToList). d0 = player number (1 based), d4 = PlList slot. Put d0 in the slot if he is on the bench or
	;ice (not in the box, not injured) and not in PlList yet; return d1 = 0 (Z set) if not
	move.w	d0,d1
	subq.w	#1,d0
	add.w	d0,d0
	tst.w	$66(a2,d0.w)
	bgt.w	.15928
	cmpi.w	#$FFFD,$66(a2,d0.w)
	beq.w	.15928
	cmpi.w	#$FFFC,$66(a2,d0.w)
	beq.w	.15928
	moveq	#5,d0
.15916
	cmp.b	0(a4,d0.w),d1
	dbeq	d0,.15916
	beq.w	.15928
	move.b	d1,0(a4,d4.w)
	rts
.15928
	clr.w	d1
	rts
sub_1592C	;94 only. Penalty shot set up for team a2 (called from puckpenshot): the shooter (BA_Sktr_SCnum) plays center from BA_Skater_Offset,
	;the goalie (BA_Goalie_SCnum) stays; every other player is made unavailable with assignment $20 (assgoaliebreakwait)
	movem.l	d0-d5/a0-a3,-(sp)
	movea.w	$22(a2),a3
	moveq	#5,d4
.15936
	move.w	$52(a3),d0
	cmp.w	(BA_Sktr_SCnum).w,d0
	beq.w	.1595C
	cmp.w	(BA_Goalie_SCnum).w,d0
	beq.w	.15976
	bset	#2,$63(a3)	;set player unavailable
	move.w	#$20,d0	;assgoaliebreakwait (asstab $18DFC)
	bsr.w	assreplace
	bra.w	.15992
.1595C
	bsr.w	Setplass
	move.b	$61(a3),(byte_FFC31E).w
	move.b	(BA_Skater_Offset+1).w,$61(a3)
	move.w	#4,$34(a3)
	bra.w	.1597E
.15976
	bsr.w	Setplass
	clr.w	$34(a3)
.1597E
	clr.w	d3
	move.b	$61(a3),d3
	add.w	d3,d3
	move.w	#$FFFF,$66(a2,d3.w)
	lsr.w	#1,d3
	bsr.w	setplayer
.15992
	st	$61(a3)
	st	$60(a3)
	adda.w	#$80,a3
	dbf	d4,.15936
	movem.l	(sp)+,d0-d5/a0-a3
	rts
forcepldata	;no skating on/off: force players to correct data (for faceoffs only). a2 = team struct
	movem.l	d0-d4/a0-a3,-(sp)
	movea.w	$22(a2),a3	;22 offset of team struct is tmsort (address of first sort obj)
	moveq	#5,d4	;will run the loop 6 times
.top
	move.b	$60(a3),d0	;newpos = requested next pos of player
	ext.w	d0
	tst.w	$34(a3)	;check for goalie
	bne.w	.159DA
	tst.w	d0	;is he staying as a goalie?
	beq.w	.159DA
	move.w	$52(a3),-(sp)	;push SCNum to stack
	move.w	#$F,$52(a3)	;put F into SCNum
	jsr	(nullsub_2).l	;IDA nullsub: an rts
	move.w	(sp)+,$52(a3)	;pop original SCNum back into SCNum
.159DA
	move.w	d0,$34(a3)	;move newpos(d0) into position
	bmi.w	.next
	bsr.w	Setplass
	cmpi.w	#4,$34(a3)	;check if C
	bne.w	.notnear	;branch if not
	move.l	#$11,d0	;$11 = anearest
	bsr.w	assinsert
.notnear
	clr.w	d3
	move.b	$61(a3),d3	;move newpnum into d3
	add.w	d3,d3	;add d3 to itself
	move.w	#$FFFF,$66(a2,d3.w)	;move -1 into tmpdst
	;put player on the ice
	lsr.w	#1,d3	;divide d3 by 2
	bsr.w	setplayer
.next
	st	$61(a3)	;set newpnum to FF
	st	$60(a3)	;set newpos to FF
	adda.w	#$80,a3	;move to next sortobj (player struct)
	dbf	d4,.top
	movem.l	(sp)+,d0-d4/a0-a3
	rts
ResetBench	;remove all players from penalty box / put all players on their own bench (not the injured, -3 / -4). Counts the players left in the
	;box in PBnum (home in the high nibble). .rb runs for the home team, then falls in for the visitors
	clr.b	(PBnum).w	;PBnum = HV00
	;H = home players in PB
	;V = away players in PB
	moveq	#$10,d1
	movea.w	#(HmShots-M68K_RAM),a0
	bsr.w	.rb
	moveq	#1,d1
	adda.w	#$364,a0	;change to Away Team
.rb
	moveq	#$32,d0	;$32 = (MaxRos-1)*2 = 50 decimal
.rb1
	add.b	d1,(PBnum).w
	tst.w	$66(a0,d0.w)	;check tmpdst
	;check and see which players are in the box
	;(-2=bench, -1=ice, 0+=pen box)
	;starts from end of list and works backwards through loop
	ble.w	.cont
	btst	#4,$66(a0,d0.w)	;test 3rd bit in tmpdst (4 decimal)
	beq.w	.next
	move.w	$66(a0,d0.w),d2	;move tmpdst into d2
	andi.w	#$7FF,d2	;mask 7FF with d2. Passes lowest 11 bits
	bne.w	.next
	sub.b	d1,(PBnum).w
	bra.w	.next
.cont
	sub.b	d1,(PBnum).w
	cmpi.w	#$FFFD,$66(a0,d0.w)	;compare -4 with tmpdst
	beq.w	.next
	cmpi.w	#$FFFC,$66(a0,d0.w)	;compare -3 with tmpdst
	beq.w	.next
	move.w	#$FFFE,$66(a0,d0.w)	;move -2 into tmpdst
.next
	subq.w	#2,d0
	bpl.s	.rb1
	rts
Setplass	;set players (a3) initial assignment from .alist by position
	move.w	$34(a3),d0
	bmi.w	rtss2
	lea	.alist(pc),a0
	move.b	0(a0,d0.w),d0
	bra.w	assreplace
.alist	dc.b	$E	;IDA: _alist. assgoalie
	;assgoalie??
	dc.b	2	;assdefd
	dc.b	2	;assdefd
	dc.b	3	;asswingd
	dc.b	5	;asscenterd
	dc.b	3	;asswingd
	dc.b	5	;asscenterd
	dc.b	$FF
setplayer	;bring player onto the ice and set his attributes. d3 = offset of player on roster, a3 = sortcord of player. Reads the roster bytes
	;through AttributeCalc (attribute number in word_FFBF14). 94 adds the PP / PK, home / away and third period bonuses (team ScoreOdds bytes) to
	;some attributes and clamps them with checkattriblimits
	bclr	#6,$63(a3)	;clear line change mode? (I believe pflags2 are 1 off because of fighting missing)
	movea.w	#(HmShots-M68K_RAM),a0	;Start of Team Struct
	btst	#6,$62(a3)	;checks if home or away (if 0, home)
	beq.w	.0
.AwayTeam	;IDA: AwayTeam (no xref; a label inside setplayer)
	;$364 = size of Team Struct
	adda.w	#$364,a0
.0
	move.b	d3,$66(a3)	;move d3 into pnum (offset on roster)
	move.l	#$A,d0	;$A = #aepen
	ext.w	d3
	add.w	d3,d3	;in NHL92 = asl #1,d3. Accomplishes the same. Doubles d3
	move.w	$66(a0,d3.w),d1	;move tmpdst(a0, d3) into d1
	bpl.w	.da
	move.l	#9,d0	;assben
	cmp.w	#$FFFE,d1	;-2 in this case
	bne.w	.nda
.da
	bsr.w	assinsert
	bclr	#5,$62(a3)
	clr.w	$58(a3)
.nda
	move.w	#$FFFF,$66(a0,d3.w)	;clear out temp space
	lsr.w	#1,d3	;shift d3 back to its original value
	movea.l	$1E(a0),a0	;Offset 1E from Team Struct = The address where the team's data is stored (roster, etc)
	move.l	a0,-(sp)	;pushes starting position onto the stack
	adda.w	8(a0),a0	;moves to offset where Off/Def byte is. From here 94 differs from 92
	clr.l	(PPBonus).w	;Clears all bonuses
	tst.w	$34(a3)	;check if goalie
	beq.w	.playdatamove
	btst	#5,(sflags2).w	;might be checking for a PP
	beq.w	.habonus
	bsr.w	chkpk2	;prob determines what team is PP or PK
	beq.w	.pk
	move.b	1(a0),(PPBonus).w	;moves PP/PK byte into PPBonus
	andi.b	#$F,(PPBonus).w	;passes lower nibble of PP/PK byte (bug)
	bra.w	.habonus
.pk
	move.b	1(a0),d0	;moves PP/PK byte into d0
	lsr.b	#4,d0	;shifts d0.b 4 places, to remove the lower nibble
	neg.b	d0	;switches value to negative (because its a PK, its negative bonus)
	move.b	d0,(PKBonus).w	;move d0 into PKBonus
.habonus
	move.b	2(a0),d0	;This is location of Home/Away adv
	andi.b	#$F,d0	;pass the lower nibble (Away) to d0
	neg.b	d0	;make d0 negative (away disadvantage)
	btst	#6,$62(a3)	;check if player is home or away
	bne.w	.3rdperbonuscheck
	move.b	2(a0),d0	;player is home, move Home/Away byte back in to d0
	lsr.b	#4,d0	;Shift d0 4 places right, to move upper nibble into d0
.3rdperbonuscheck
	move.b	d0,(HmAwBonus).w	;move d0 into HA bonus
	cmpi.w	#2,(gsp).w	;Check if period is 3rd or OT
	blt.w	.playdatamove
	bgt.w	.chklead	;branch if OT
	jsr	(GetPeriodTime).w	;hockey94_01 (IDA ClockLength). Find period length
	lsr.w	#1,d0	;divide by 2 (5 min length = 2:30)
	cmp.w	(gameclock).w,d0	;compare to game clock
	bgt.w	.playdatamove	;branch if d0 greater than gameclock (bug)
.chklead
	move.w	(HmGoals).w,d0
	sub.w	(AwGoals).w,d0	;HmGoals-AwGoals
	beq.w	.load3pbonus	;branch if tied
	btst	#6,$62(a3)	;Check if home or away
	beq.w	.home	;branch if home
	eori	#8,ccr	;If Aw team, checks if N flag is set from HmGoals-AwGoals.
	;Xors the CCR, if N flag set, it will make it 0, if cleared, will make it 1.
	;If Aw team leading, it will jump boost for away team.
.home
	bpl.w	.playdatamove	;branch for the team who is leading
.load3pbonus
	move.b	#2,(ThirdPBonus).w	;move 2 into 3rd Per Bonus
.playdatamove
	movea.l	(sp)+,a0	;moves Team Data start to a0
	adda.w	(a0),a0	;moves to player data offset (byte 0 and 1 of Team Data)
.skiploop
	adda.w	(a0),a0	;skips the player's name length (current byte is name length)
	addq.w	#8,a0	;skips players attributes
	dbf	d3,.skiploop	;loops until current player index is met (which was stored in d3)
	subq.w	#8,a0	;Jump back to start of players attributes
	move.b	(a0),$6F(a3)	;Jersey Number
	move.b	1(a0),d3	;move Wgt/Agl byte to d3
	andi.w	#$F0,d3	;Mask Wgt nibble
	lsr.w	#1,d3	;shift d3 1 bit right (This is taking Wgt and mult by 8)
	move.b	d3,$67(a3)	;store in player struct
	move.b	1(a0),d3	;move Wgt/Agl byte to d3
	andi.b	#$F,d3	;mask Agl nibble
	move.w	#3,(word_FFBF14).w	;move 3 into BF14
	jsr	(AttributeCalc).l	;attribute math and add hot/cold
	move.b	d3,$68(a3)	;move Agl byte to player struct
	move.b	2(a0),d3	;load Spd/OfA byte to d3
	lsr.b	#4,d3	;remove OfA nibble by shifting 4 bits right, moving Spd into lower nibble
	move.w	#4,(word_FFBF14).w	;move 4 into BF14
	jsr	(AttributeCalc).l
	move.b	d3,$69(a3)	;move Spd byte into player struct
	move.b	2(a0),d3	;move Spd/OfA byte to d3
	andi.b	#$F,d3	;mask d3 and pass only OfA nibble
	move.w	#5,(word_FFBF14).w	;move 5 into BF14
	jsr	(AttributeCalc).l
	add.b	(PPBonus).w,d3	;add Bonsuses to OfA
	add.b	(PKBonus).w,d3
	add.b	(HmAwBonus).w,d3
	add.b	(ThirdPBonus).w,d3
	bsr.w	checkattriblimits
	lsr.b	#1,d3	;shift right 1 bit (divide by 2)
	eori.b	#$F,d3	;XOR d3 with F
	addi.b	#$F,d3	;add F to d3
	lsr.b	#1,d3	;divide by 2
	move.b	d3,$6A(a3)	;OfA byte = (30-((OfA + Bonuses)/2))/2
	move.b	3(a0),d3	;move DfA/ShP byte to d3
	lsr.b	#4,d3	;see above
	move.w	#6,(word_FFBF14).w
	jsr	(AttributeCalc).l
	add.b	(HmAwBonus).w,d3
	bsr.w	checkattriblimits
	lsr.b	#1,d3
	eori.b	#$F,d3
	addi.b	#$F,d3
	lsr.b	#1,d3
	move.b	d3,$6B(a3)	;same math and formula as OfA
	move.b	3(a0),$6C(a3)
	andi.b	#$F,$6C(a3)
	move.b	$6C(a3),d3
	move.w	#7,(word_FFBF14).w
	jsr	(AttributeCalc).l
	move.b	d3,$6C(a3)	;ShP does not get any bonuses
	move.b	4(a0),d3	;move Chk/Hnd byte into d3
	lsr.b	#4,d3
	move.w	#8,(word_FFBF14).w
	jsr	(AttributeCalc).l
	add.b	(ThirdPBonus).w,d3	;Chk gets 3rd P bonus only
	bsr.w	checkattriblimits
	move.b	d3,$75(a3)	;move Chk into player struct
	bclr	#3,4(a3)	;clear bit 3 in attribute of player struct
	move.b	4(a0),$76(a3)	;move Chk/Hnd byte to Hnd in player struct
	andi.b	#1,$76(a3)	;masks Hnd byte with 1, only passing first bit
	eori.b	#1,$76(a3)	;XOR Hnd byte with 1. Sets to opposite what the bit was.
	;So L will be a 1 and R will be a 0
	bne.w	.attribloadcont
	bset	#3,4(a3)	;sets bit 3 of attribute byte in player struct (to match Hnd if Hnd bit is set)
.attribloadcont
	move.b	4(a0),$74(a3)	;moves Chk/Hnd byte into Fgt byte in player struct
	andi.b	#$E,$74(a3)	;mask the byte with E, ignoring the Hnd bit - will always be even
	move.b	5(a0),d3	;move Stk/ShA byte into d3
	lsr.b	#4,d3
	move.w	#$A,(word_FFBF14).w
	jsr	(AttributeCalc).l
	add.b	(PPBonus).w,d3
	add.b	(PKBonus).w,d3
	add.b	(HmAwBonus).w,d3
	bsr.w	checkattriblimits
	move.b	d3,$71(a3)	;Stk gets PP/PK/Tm Bonus
	move.b	5(a0),d3
	andi.b	#$F,d3
	move.w	#$B,(word_FFBF14).w
	jsr	(AttributeCalc).l
	add.b	(PPBonus).w,d3
	add.b	(PKBonus).w,d3
	add.b	(HmAwBonus).w,d3
	bsr.w	checkattriblimits
	move.b	d3,$6D(a3)	;ShA gets PP/PK/Tm Bonus
	move.b	6(a0),d3	;move End/PS Bias byte into d3
	lsr.b	#4,d3
	move.w	#$C,(word_FFBF14).w
	jsr	(AttributeCalc).l
	move.b	d3,$72(a3)	;End gets no bonuses
	move.b	6(a0),d3
	andi.b	#$F,d3
	move.w	#$D,(word_FFBF14).w
	jsr	(AttributeCalc).l
	add.b	(ThirdPBonus).w,d3
	add.b	(ThirdPBonus).w,d3
	bsr.w	checkattriblimits
	move.b	d3,$70(a3)	;PS Bias gets a double 3rd P bonus
	move.b	7(a0),d3	;move Pas/Agr byte into d3
	lsr.b	#4,d3
	move.w	#$E,(word_FFBF14).w
	jsr	(AttributeCalc).l
	add.b	(PPBonus).w,d3
	add.b	(HmAwBonus).w,d3
	bsr.w	checkattriblimits
	move.b	d3,$6E(a3)	;Pas gets PP and Tm bonus
	move.b	7(a0),$73(a3)	;moves Pas/Agr into Agr byte in player struct
	move.b	$73(a3),d3	;moves Pas/Agr byte into d3 (weird way to do it)
	andi.b	#$F,d3
	move.w	#$F,(word_FFBF14).w
	jsr	(AttributeCalc).l
	move.b	d3,$73(a3)	;Agr gets no bonus
	andi.b	#$F,$73(a3)	;mask Agr byte with F, so max is 15 decimal
	rts
checkattriblimits	;IDA name (93 ClampNibble clamps 0-15). Clamp byte d3 to 0-$1E. Called by setplayer
	tst.b	d3	;test if d3 is zero or higher
	bpl.w	.pos
	clr.w	d3	;if negative, clear
.pos
	cmp.b	#$1E,d3	;compare upper limit
	ble.w	.withinlimits
	move.w	#$1E,d3	;if higher, set to 1E
.withinlimits
	rts
