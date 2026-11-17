setpersonel
	movem.l	d0-d5/a0-a4,-(sp)
	movea.l	$22(a2),a3
	moveq	#$5,d4
.loop	st.b	$60(a3)
	st.b	$61(a3)
	adda.w	#$80,a3
	dbra	d4,.loop
	bsr.w	SetPlList
	moveq	#$5,d4
	movea.l	#$18AC6,a4
.loop2	clr.w	d5
	move.b	(a4,d4.w),d5
	beq.w	.next
	subi.w	#$1,d5
	moveq	#$5,d3
	movea.l	$22(a2),a3
	suba.w	#$80,a3
.loop3	adda.w	#$80,a3
	cmp.b	$66(a3),d5
	dbeq	d3,.loop3
	bne.w	.next
	move.b	$6(a4,d4.w),$60(a3)
	move.b	d5,$61(a3)
	clr.b	(a4,d4.w)
.next	dbra	d4,.loop2
	moveq	#$5,d4
	movea.l	#$18AC6,a4
.loop4	clr.w	d5
	move.b	(a4,d4.w),d5
	beq.w	.next3
	subi.w	#$1,d5
	moveq	#$5,d3
	movea.l	$22(a2),a3
	suba.w	#$80,a3
.loop5	adda.w	#$80,a3
	tst.b	$61(a3)
	dbmi	d3,.loop5
	bpl.w	.next2
	movea.l	a3,a0
.next2	tst.w	$34(a3)
	dbpl	d3,.loop5
	move.b	$6(a4,d4.w),$60(a0)
	move.b	d5,$61(a0)
	clr.b	(a4,d4.w)
.next3	dbra	d4,.loop4
	movem.l	(sp)+,d0-d5/a0-a4
	rts
SetPlList						;create PlList of players who we want on the ice now. a2 = team struct.
									;Takes the current line (tmline) by priolist; an unavailable
									;player (in the box or injured, -3 / -4) is replaced from sublist, or from
									;the whole roster
	movea.l	#$18AC6,a4
	clr.l	(a4)		;goalie present: use the position priority list from the start
	clr.w	$4(a4)
	movea.l	#priolist,a0
	tst.w	$28(a2)
	bpl.w	.next		;branch if theres a goalie
	adda.w	#$1,a0		;add 1 to a0
.next	lea.l	$16C(a2),a1		;loop: d5 = position, PlList slot = the line's player there (no player:
	move.w	$16(a2),d0		;current line selected
	asl.w	#$3,d0
	adda.w	d0,a1		;add to a1 to set a1 to currently selected line
	move.w	$26(a2),d4		;tmap - active players (4-6 in normal ROM)
	bra.w	.next2
.loop	clr.w	d5
	move.b	(a0,d4.w),d5		;move position into d5
	move.b	(a1,d5.w),(a4,d4.w)
	move.b	d5,$6(a4,d4.w)
	bne.w	.next2
	moveq	#$1,d3		;loop: replace injured or penalized players
	add.w	$28(a2),d3
	move.b	d3,(a4,d4.w)
.next2	dbra	d4,.loop
	moveq	#$5,d4		;now check to see if player is available
.loop2	move.b	(a4,d4.w),d3
	beq.w	.loop4
	ext.w	d3
	subi.w	#$1,d3
	add.w	d3,d3
	cmpi.w	#$FFFD,$68(a2,d3.w)		;injured or not on the bench: find a substitute from sublist
	beq.w	.next3
	cmpi.w	#$FFFC,$68(a2,d3.w)		;check if player injured for game
	beq.w	.next3
	tst.w	$68(a2,d3.w)
	ble.w	.loop4
.next3	lea.l	$16C(a2),a1		;now find a player of similar position who is available move Line Lists
	move.b	$6(a4,d4.w),d0		;move 6+a4+d4 into d0 (previous d5)
	ext.w	d0
	asl.w	#$1,d0
	movea.l	#sublist,a0		;move sublist into a0
	adda.w	(a0,d0.w),a0		;move a0+d0 into a0
.loop3	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	.next4
	move.b	(a1,d0.w),d0
	bsr.w	TryAddPlayerToList
	beq.w	.loop3
.loop4	dbra	d4,.loop2
	rts
.next4	jsr	(GetPlayerCount).l		;then try the players from d0 down
	move.w	d0,d3
.loop5	move.w	d3,d0		;d0 = candidate player number, d3 counts down
	subi.w	#$1,d3
	bmi.w	.loop4		;none available
	bsr.w	TryAddPlayerToList
	beq.w	.loop5
	bra.w	.loop4
TryAddPlayerToList						;d0 = player number (1 based), d4 = PlList slot. Put d0 in the slot if he
									;is on the bench or ice (not in the box, not injured) and not in PlList
									;yet; return d1 = 0 (Z set) if not
	move.w	d0,d1
	subi.w	#$1,d0
	add.w	d0,d0
	tst.w	$68(a2,d0.w)
	bgt.w	.next		;loop: is d1 already in PlList?
	cmpi.w	#$FFFD,$68(a2,d0.w)
	beq.w	.next
	cmpi.w	#$FFFC,$68(a2,d0.w)
	beq.w	.next
	moveq	#$5,d0
.loop	cmp.b	(a4,d0.w),d1
	dbeq	d0,.loop
	beq.w	.next
	move.b	d1,(a4,d4.w)
	rts
.next	clr.w	d1
	rts
SetupPenaltyShot						;Penalty shot set up for team a2 (called from puckpenshot): the shooter
									;loop over the team: shooter plays center, goalie stays, others leave
	movem.l	d0-d5/a0-a3,-(sp)
	movea.l	$22(a2),a3
	moveq	#$5,d4
.loop	move.w	$52(a3),d0
	cmp.w	$19368.l,d0
	beq.w	.next
	cmp.w	$1936A.l,d0
	beq.w	.next2
	bset	#$2,$63(a3)		;set player unavailable
	move.w	#$20,d0		;assgoaliebreakwait
	bsr.w	assreplace
	bra.w	.next4
.next	bsr.w	Setplass
	move.b	$61(a3),$17F9C.l
	move.b	$1936D.l,$61(a3)		;put the player on the ice
	move.w	#$4,$34(a3)
	bra.w	.next3
.next2	bsr.w	Setplass
	clr.w	$34(a3)
.next3	clr.w	d3		;next sort object
	move.b	$61(a3),d3
	add.w	d3,d3
	move.w	#$FFFF,$68(a2,d3.w)
	lsr.w	#$1,d3
	bsr.w	SetPlayerSide
.next4	st.b	$61(a3)
	st.b	$60(a3)
	adda.w	#$80,a3
	dbra	d4,.loop
	movem.l	(sp)+,d0-d5/a0-a3
	rts
forcepldata						;no skating on/off: force players to correct data (for faceoffs only). a2
									;= team struct
	movem.l	d0-d4/a0-a3,-(sp)
	movea.l	$22(a2),a3		;22 offset of team struct is tmsort (address of first sort obj)
	moveq	#$5,d4		;will run the loop 6 times
.loop	move.b	$60(a3),d0		;newpos = requested next pos of player
	ext.w	d0
	tst.w	$34(a3)
	bne.w	.next
	tst.w	d0		;set the position and its assignment; centers also get assnearest
	beq.w	.next
	move.w	$52(a3),-(sp)		;push SCNum to stack
	move.w	#$F,$52(a3)		;put F into SCNum
	jsr	$22DDE.l
	move.w	(sp)+,$52(a3)		;pop original SCNum back into SCNum
.next	move.w	d0,$34(a3)		;move newpos(d0) into position
	bmi.w	.next3		;put the requested player on the ice
	bsr.w	Setplass
	cmpi.w	#$4,$34(a3)
	bne.w	.next2
	moveq	#$11,d0
	bsr.w	AssistListPush
.next2	clr.w	d3		;d3 = requested player number
	move.b	$61(a3),d3		;next sort object
	add.w	d3,d3		;add d3 to itself
	move.w	#$FFFF,$68(a2,d3.w)		;move -1 into tmpdst
	lsr.w	#$1,d3		;divide d3 by 2
	bsr.w	SetPlayerSide
.next3	st.b	$61(a3)		;set newpnum to FF
	st.b	$60(a3)		;set newpos to FF
	adda.l	#$80,a3		;move to next sortobj (player struct)
	dbra	d4,.loop
	movem.l	(sp)+,d0-d4/a0-a3
	rts
ResetBench						;remove all players from penalty box / put all players on their own bench
									;(not the injured, -3 / -4). Counts the players left in the box in PBnum
									;(home in the high nibble). .rb runs for the home team, then falls in for
									;the visitors
	clr.b	$18068.l
	moveq	#$10,d1
	movea.l	#tmstruct,a0
	bsr.w	.next
	moveq	#$1,d1
	adda.w	#$366,a0		;change to Away Team
.next	moveq	#$32,d0		;$32 = (MaxRos-1)*2 = 50 decimal
.loop	add.b	d1,$18068.l
	tst.w	$68(a0,d0.w)
	ble.w	.next2
	btst	#$4,$68(a0,d0.w)		;test 3rd bit in tmpdst (4 decimal)
	beq.w	.next3		;not in the box: mark on the bench unless injured
	move.w	$68(a0,d0.w),d2		;move tmpdst into d2
	andi.w	#$7FF,d2		;mask 7FF with d2. Passes lowest 11 bits
	bne.w	.next3
	sub.b	d1,$18068.l
	bra.w	.next3
.next2	sub.b	d1,$18068.l
	cmpi.w	#$FFFD,$68(a0,d0.w)		;compare -3 with tmpdst
	beq.w	.next3
	cmpi.w	#$FFFC,$68(a0,d0.w)		;compare -4 with tmpdst
	beq.w	.next3
	move.w	#$FFFE,$68(a0,d0.w)		;move -2 into tmpdst
.next3	subi.w	#$2,d0		;previous roster entry
	bpl.w	.loop
	rts
Setplass						;set players (a3) initial assignment from .alist by position
	move.w	$34(a3),d0
	bmi.w	rtss2
	lea.l	.next(pc),a0
	move.b	(a0,d0.w),d0
	bra.w	assreplace
.next	dc.w	$0E02		;assgoalie
setplayer						;bring player onto the ice and set his attributes. d3 = offset of player
									;on roster, a3 = sortcord of player. Reads the roster bytes through
									;AttributeCalc (attribute number in TempWord2). Adds the PP / PK, home /
									;away and third period bonuses (team ScoutReport bytes) to some attributes
									;and clamps them with ClampNibble
; Data of setplayer (1 row): table or constants used by it.
	dc.w	$0203,$0503
	btst	d2,d0

; Chooses the team structure for the player.
SetPlayerSide
	bclr	#$6,$63(a3)
	movea.l	#tmstruct,a0
	btst	#$6,$62(a3)
	beq.w	.next
	adda.w	#$366,a0
.next	move.b	d3,$66(a3)
	moveq	#$A,d0
	ext.w	d3
	add.w	d3,d3
	move.w	$68(a0,d3.w),d1
	bpl.w	.next2
	moveq	#$9,d0
	cmpi.w	#$FFFE,d1
	bne.w	.next3
.next2	bsr.w	AssistListPush
	bclr	#$5,$62(a3)
	clr.w	$58(a3)
.next3	move.w	#$FFFF,$68(a0,d3.w)
	lsr.w	#$1,d3
	movea.l	$1E(a0),a0
	move.l	a0,-(sp)
	adda.w	$8(a0),a0
	clr.l	$18AE0.l
	tst.w	$34(a3)
	beq.w	.next10
	btst	#$5,$17F6C.l
	beq.w	.next5
	jsr	(chkpk2).l
	beq.w	.next4
	move.b	$1(a0),$18AE0.l
	andi.b	#$F,$18AE0.l
	bra.w	.next5
.next4	move.b	$1(a0),d0
	lsr.b	#$4,d0
	neg.b	d0
	move.b	d0,$18AE1.l
.next5	move.b	$2(a0),d0
	andi.b	#$F,d0
	neg.b	d0
	btst	#$6,$62(a3)
	bne.w	.next6
	move.b	$2(a0),d0
	lsr.b	#$4,d0
.next6	move.b	d0,$18AE3.l
	cmpi.w	#$2,$180E4.l
	blt.w	.next10
	bgt.w	.next7
	jsr	(GetPeriodTime).l
	lsr.w	#$1,d0
	cmp.w	$180E6.l,d0
	bgt.w	.next10
.next7	move.w	$18358.l,d0
	sub.w	$186BE.l,d0
	beq.w	.next9
	btst	#$6,$62(a3)
	beq.w	.next8
	eori.b	#$8,ccr
.next8	bpl.w	.next10
.next9	move.b	#$2,$18AE2.l
.next10	movea.l	(sp)+,a0
	adda.w	$0(a0),a0
.loop	adda.w	(a0),a0
	adda.w	#$8,a0
	dbra	d3,.loop
	suba.w	#$8,a0
	move.b	(a0),$6F(a3)
	move.b	$1(a0),d3
	andi.w	#$F0,d3
	lsr.w	#$1,d3
	move.b	d3,$67(a3)
	move.b	$1(a0),d3
	andi.b	#$F,d3
	move.w	#$3,$17E64.l
	jsr	(AttributeCalc).l
	move.b	d3,$68(a3)
	move.b	$2(a0),d3
	lsr.b	#$4,d3
	move.w	#$4,$17E64.l
	jsr	(AttributeCalc).l
	move.b	d3,$69(a3)
	move.b	$2(a0),d3
	andi.b	#$F,d3
	move.w	#$5,$17E64.l
	jsr	(AttributeCalc).l
	add.b	$18AE0.l,d3
	add.b	$18AE1.l,d3
	add.b	$18AE3.l,d3
	add.b	$18AE2.l,d3
	bsr.w	.next12
	lsr.b	#$1,d3
	eori.b	#$F,d3
	addi.b	#$F,d3
	lsr.b	#$1,d3
	move.b	d3,$6A(a3)
	move.b	$3(a0),d3
	lsr.b	#$4,d3
	move.w	#$6,$17E64.l
	jsr	(AttributeCalc).l
	add.b	$18AE3.l,d3
	bsr.w	.next12
	lsr.b	#$1,d3
	eori.b	#$F,d3
	addi.b	#$F,d3
	lsr.b	#$1,d3
	move.b	d3,$6B(a3)
	move.b	$3(a0),$6C(a3)
	andi.b	#$F,$6C(a3)
	move.b	$6C(a3),d3
	move.w	#$7,$17E64.l
	jsr	(AttributeCalc).l
	move.b	d3,$6C(a3)
	move.b	$4(a0),d3
	lsr.b	#$4,d3
	move.w	#$8,$17E64.l
	jsr	(AttributeCalc).l
	add.b	$18AE2.l,d3
	bsr.w	.next12
	move.b	d3,$75(a3)
	bclr	#$3,$4(a3)
	move.b	$4(a0),$76(a3)
	andi.b	#$1,$76(a3)
	eori.b	#$1,$76(a3)
	bne.w	.next11
	bset	#$3,$4(a3)
.next11	move.b	$4(a0),$74(a3)
	andi.b	#$E,$74(a3)
	move.b	$5(a0),d3
	lsr.b	#$4,d3
	move.w	#$A,$17E64.l
	jsr	(AttributeCalc).l
	add.b	$18AE0.l,d3
	add.b	$18AE1.l,d3
	add.b	$18AE3.l,d3
	bsr.w	.next12
	move.b	d3,$71(a3)
	move.b	$5(a0),d3
	andi.b	#$F,d3
	move.w	#$B,$17E64.l
	jsr	(AttributeCalc).l
	add.b	$18AE0.l,d3
	add.b	$18AE1.l,d3
	add.b	$18AE3.l,d3
	bsr.w	.next12
	move.b	d3,$6D(a3)
	move.b	$6(a0),d3
	lsr.b	#$4,d3
	move.w	#$C,$17E64.l
	jsr	(AttributeCalc).l
	move.b	d3,$72(a3)
	move.b	$6(a0),d3
	andi.b	#$F,d3
	move.w	#$D,$17E64.l
	jsr	(AttributeCalc).l
	add.b	$18AE2.l,d3
	add.b	$18AE2.l,d3
	bsr.w	.next12
	move.b	d3,$70(a3)
	move.b	$7(a0),d3
	lsr.b	#$4,d3
	move.w	#$E,$17E64.l
	jsr	(AttributeCalc).l
	add.b	$18AE0.l,d3
	add.b	$18AE3.l,d3
	bsr.w	.next12
	move.b	d3,$6E(a3)
	move.b	$7(a0),$73(a3)
	move.b	$73(a3),d3
	andi.b	#$F,d3
	move.w	#$F,$17E64.l
	jsr	(AttributeCalc).l
	move.b	d3,$73(a3)
	andi.b	#$F,$73(a3)
	rts
.next12	tst.b	d3
	bpl.w	.next13
	clr.w	d3
.next13	cmpi.b	#$1E,d3
	ble.w	.ex
	move.w	#$1E,d3
.ex	rts
; Vertical interrupt handler of the ice setup
SetupIceVBlankHandler
; Vertical interrupt body: dma list, palettes and the sub CPU handshake
VBlankMainHandler	movem.l	d0-d7/a0-a6,-(sp)
	btst.b	#$2,$18D64.l
	bne.w	.next2
	bclr.b	#$0,$18D64.l
	beq.w	.next
	bsr.w	VBlankDmaList
.next	bsr.w	ForceBlackStep
.next2	btst.b	#$0,$17F6A.l
	bne.w	.loop
	btst.b	#$2,$17F78.l
	bne.w	.next3
	btst.b	#$0,$17F68.l
	bne.w	.loop
.next3	btst.b	#$1,$17F78.l
	bne.w	.next4
	tst.w	$180E6.l
	beq.w	.loop
	subi.w	#$AAA,$180E8.l
	bcc.w	.loop
	bset.b	#$3,$18D64.l
	subq.w	#$1,$180E6.l
	cmpi.w	#$3D,$180E6.l
	bgt.w	.loop
	cmpi.w	#$3C,$180E6.l
	blt.w	.loop
	move.w	#$2,-(sp)
	bsr.w	GateArrayCommandSend
.loop	addq.w	#$1,$17474.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.next4	tst.w	$193B6.l
	beq.w	.loop
	subi.w	#$AAA,$193B8.l
	bcc.w	.loop
	bset.b	#$3,$18D64.l
	btst.b	#$7,$17F78.l
	bne.w	.loop
	subq.w	#$1,$193B6.l
	bra.w	.loop