;	NHL 94 (retail) segment $11F2C-$12C03
;	92 Penalty.Asm part 1, as 93 penalty93_1.asm: AddPenalty, AddPenalty2, PenaltyManager, chkprogress, the 94-only
;	PenShotChk and getBAplayerInfo (penalty shot on a breakaway), InProgress, coinsearch, checkfornewpen, Stop4Pen,
;	limitfo, UpdatePA, SetPA, SetPA2, PushRef, prefmes, PrintPenaltyMessagesString, PenGoalStuff, clrPenBuf,
;	updatepentime, ProcessPenaltyList, RemovePlayerFromList, chkatop, releasepl, CalcPenTime, updatepwrplay, ClrHor,
;	SetHor. PrintScores1 (penalty94_2) follows at $12C04. The PenaltyList data is at $18E0C.
;	Transcribed from lst/nhl94.bin.lst lines 45937-47135. Global names are the IDA names, or the 93 name where IDA has
;	an auto name or a spelling variant (IDA name in an ;IDA: comment). Local labels are the IDA local names (_x -> .x)
;	or the IDA address (loc_12052 -> .12052).
;	IDA shows the printz / appendz strings as dc.b or ori.b; they are written with the String macro (length word
;	includes itself and the 0 pad). The instruction IDA hid in the SetHor string is written out.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi;
;	fixopcodes.js patches the cmp encoding after assembly.
;	Penalty numbers are PenaltyList word offsets, as 93: EOG 4, OOP 6, whistle $A, icing $C, goal $E, offsides $10,
;	delay $2C. 94 team struct from HmShots (tmsize $364, 93 $1A2): 2 tmPwrGoals, 4 tmPwrPlays, 6 tmPenalties,
;	8 tmPenmin, $A attack time, $1E tmdata, $22 tmsort, $24 tmap, $26 tmgoalie, $30 tmflags, $66 tmpdst, $9A penalty
;	box list (bytes, -1 end), $102 per-player penalty minutes. Sort struct (SortCords, $80 each): $34 position,
;	$40 temp1, $52 SCnum, $62 pflags, $63 pflags2, $64 bit 1 breakaway, $66 pnum.

AddPenalty	;add penalty d0 (PenaltyList offset) for player a3. Ignored while the clock is stopped, when penalties are off, for a player with
	;pflags2 bit 2 set (94), or offsides when offsides are off. Falls into AddPenalty2
	btst	#0,(gmode).w	;gmclock
	bne.w	rtss2
	cmp.w	#$C,d0	;icing (92 PenIcing = 8)
	beq.w	AddPenalty2
	tst.w	(OptPen).w
	beq.w	rtss2	;penalties off
	btst	#2,$63(a3)	;94 only. pflags2 bit 2, which releasepl sets (93 comment: 92 pf2unav)
	bne.w	rtss2
	btst	#5,(gmode).w	;gmoffs: offsides on
	bne.w	AddPenalty2
	cmp.w	#$10,d0	;offsides (92 PenOffsides = $A)
	beq.w	rtss2
AddPenalty2	;forced penalties like face off and game over. d0 = penalty number, a3 = player or player on penalized team. From $E (goal) up: crowd
	;and song. 94: a penalty with minutes sets DelayedPen bit 1 (home) or bit 2 (away)
	btst	#7,(sflags).w	;sfhor: nothing in horizontal mode
	bne.w	rtss2
	movem.l	d1/a0-a1,-(sp)
	cmp.w	#$E,d0	;goal (92 PenGoal = 6) and up
	blt.w	.nonoise
	addi.w	#$C8,(crowdlevel).w	;200
	move.w	#$C,-(sp)	;song $C for the home team
	btst	#6,$62(a3)	;pfteam
	beq.w	.song
	addi.w	#$14,(CwdExciteLvl).w	;visitors: +20 excitement
	move.w	#$B,(sp)	;song $B
.song
	bsr.w	song
.nonoise
	movea.w	#(PenBuf-M68K_RAM),a1
	moveq	#$1F,d1	;MaxPen-1
.0
	tst.w	(a1)+
	dbeq	d1,.0	;find a free slot
	bne.w	.noplayer	;buffer full
	move.b	$53(a3),-(a1)	;SCnum+1
	move.b	d0,-(a1)
	movea.l	#PenaltyList,a0
	adda.w	0(a0,d0.w),a0
	tst.b	1(a0)	;penalty minutes
	beq.w	.noplayer
	bmi.w	.noplayer	;94: negative minutes too
	btst	#6,$62(a3)	;pfteam. 94 only: DelayedPen bit 1 home, bit 2 away
	bne.w	.away
	bset	#1,(DelayedPen).w
	bra.w	.setpenflag
.away
	bset	#2,(DelayedPen).w
.setpenflag
	bset	#4,$63(a3)	;pflags2 bit 4 (92 pf2pen, bit 6 in 92)
	beq.w	.noplayer
	clr.w	(a1)	;player already has a penalty, drop this one
.noplayer
	movem.l	(sp)+,d1/a0-a1
	rts
PenaltyManager	;called periodically. d7 = elapsed time since last call
	bsr.w	updatepentime
	bsr.w	checkfornewpen
	bsr.w	chkprogress
	bra.w	UpdatePA
chkprogress	;control progress of ref and game control thru penalty events. 94: while BA_PS_flags bit 2 is set (penalty shot), bit 7 calls
	;sub_187B8 and word_FFC31A counts down; when it runs out the message area is erased. Then as 93: when the stop delay runs out and a penalty
	;with minutes is in PenBuf, switch to the horizontal rink for the player to enter the penalty box
	btst	#2,(BA_PS_flags).w	;94 only, to .cont
	beq.w	.cont
	btst	#7,(BA_PS_flags).w
	bne.w	.sops
	tst.w	(word_FFC31A).w
	bmi.w	.cont
	subq.w	#1,(word_FFC31A).w
	bpl.w	.ex
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#2,(sflags2).w	;sf2drec
	bclr	#7,(word_FFC2FA).w
	bsr.w	printz
	String	$FF,3,2
	moveq	#$1B,d0
	moveq	#8,d1
	btst	#0,(word_FFC2FA).w
	beq.w	.12052
	move.w	#$C,d1	;12 rows when word_FFC2FA bit 0 is set
.12052
	move.l	#$7FF,d2	;blank tile
	jsr	(eraser).l
	movem.l	(sp)+,d0-d7/a0-a6
	bra.w	.ex
.sops
	jsr	(sub_187B8).l
	bclr	#7,(BA_PS_flags).w
.ex
	rts
.cont
	btst	#2,(gmode).w	;gmpen: penalty called
	beq.w	rtss2	;exit if not
	tst.w	(Pencntdwn).w
	bmi.w	InProgress
	sub.w	d7,(Pencntdwn).w
	bpl.w	rtss2
	bclr	#3,(gmode).w	;gmpendel
	movea.w	#(PenBuf-M68K_RAM),a0
.12098
	tst.w	(a0)+	;IDA: loc_12098. any penalty with minutes
	beq.w	rtss2
	clr.w	d0
	move.b	-2(a0),d0
	movea.l	#PenaltyList,a1
	adda.w	0(a1,d0.w),a1
	tst.b	1(a1)	;penalty minutes
	beq.s	.12098
	bmi.s	.12098	;94: negative minutes too
	bset	#2,(sflags2).w	;sf2drec: switch to horizontal mode for player to enter penalty box
	move.w	(vcount).w,-(sp)
	bsr.w	forceblack
	move.w	(sp)+,(vcount).w
	bsr.w	SetHor
	move.w	(ExtraChars).w,d4	;load horizontal ref tiles
	movea.l	#unk_5CF6C,a2	;93 RefMap2+8
	bsr.w	DoDMA_clearCallbackPointer
	bsr.w	NewTicker
	bsr.w	NewTicker3pt2	;93 NewTicker3
	st	(puckc).w
	movea.w	#(puckx-M68K_RAM),a3
	move.l	#$1A,d0	;puckunflip (asstab $18DE4)
	bsr.w	assinsert
	move.w	#$1C20,$40(a3)	;temp1 = 120*60
	st	(RefStep).w
	clr.w	(RefCnt).w
	bsr.w	UpdatePA
	move.w	#$32,(RefCnt).w	;50
	clr.w	d0
	bsr.w	PushRef	;ref frame 0
	move.w	#$18,(palcount).w	;24
	rts
PenShotChk	;94 only. a3 = checker, a2 = player hit, d0 = penalty. If a2 is on a breakaway ($64 bit 1), no penalty shot is pending (BA_PS_flags
	;bit 3) and unk_1913A has an entry for d0, getBAplayerInfo sets one up and d0 = that penalty (also word_FFD410). Called from CCStart before
	;AddPenalty
	movem.l	d1-d3/a0,-(sp)
	btst	#1,$64(a2)	;breakaway
	beq.w	.12132
	btst	#3,(BA_PS_flags).w	;penalty shot pending
	beq.w	.1213A
.12132
	move.w	#$FFFF,d1
	bra.w	.end
.1213A
	movea.l	#unk_1913A,a0
	move.w	0(a0,d0.w),d1	;penalty shot penalty for d0, -1 = none
	bmi.w	.end
	move.w	$52(a2),d2	;SCnum
	movem.w	d0-d1,-(sp)
	move.w	d2,d0
	jsr	(getBAplayerInfo).l
	movem.w	(sp)+,d0-d1
	bpl.w	.12168	;N clear: penalty shot set up
	bclr	#3,(BA_PS_flags).w
	bra.s	.12132
.12168
	move.w	d1,(word_FFD410).w
	move.w	d1,d0	;return the penalty shot penalty
.end
	movem.l	(sp)+,d1-d3/a0
	rts
getBAplayerInfo	;94 only. d0 = SCnum (0-5 home team, 6-11 away team) of the player on the breakaway, a3 = checker. If penalties are on and the other
	;team has a goalie in, set BA_PS_flags bit 3 and save BA_Sktr_SCnum, BA_Team, BA_Goalie_SCnum and the skater, goalie and checker team position
	;offsets ($66). Returns N clear when the penalty shot is set up
	movem.l	d1-d3/a1,-(sp)
	tst.w	(OptPen).w
	beq.w	.noPen
	bset	#3,(BA_PS_flags).w
	movem.w	d0,-(sp)
	move.w	#5,d1
	move.w	#0,d2
	cmp.w	#5,d0
	bgt.w	.findgoalie	;away player: search the home team for its goalie (d1 = 5), else the visitors (d1 = $B)
	move.w	#$B,d1
	move.w	#1,d2
.findgoalie
	move.w	d1,d0
	jsr	(getGoalieSCnum).l
	tst.w	d0
	bpl.w	.goaliein	;branch if there's a goalie
	movem.w	(sp)+,d0	;no goalie
	bclr	#3,(BA_PS_flags).w
	bra.w	.end
.goaliein
	move.w	d0,d1	;d1 = goalie's SCnum
	move.w	(sp)+,d0	;d0 now back to player checked on breakaway SCnum
	move.w	d0,(BA_Sktr_SCnum).w
	movea.l	#SortCords,a1
	move.w	d0,d3
	asl.w	#7,d3	;scsize
	move.w	#0,(BA_Team).w
	btst	#6,$62(a1,d3.w)	;pfteam
	beq.w	.121E6	;branch if home
	move.w	#1,(BA_Team).w
.121E6
	move.w	#0,(BA_Skater_Offset).w
	move.b	$66(a1,d3.w),(BA_Skater_Offset+1).w	;store BA player's team position offset
	move.w	d1,(BA_Goalie_SCnum).w
	asl.w	#7,d1	;scsize
	move.w	#0,(BA_Goalie_Offset).w
	move.b	$66(a1,d1.w),(BA_Goalie_Offset+1).w	;store goalie's team position offset
	move.w	#0,(BA_Checker_Offset).w
	move.b	$66(a3),(BA_Checker_Offset+1).w	;store checker's team position offset
.end
	movem.l	(sp)+,d1-d3/a1
	rts
.noPen
	move.w	#$FFFF,d1	;N set: no penalty shot
	bra.s	.end
InProgress	;ref in progress-- update graphics and stats and penalty information. As 93: takes the last PenBuf entry; the first pass logs a penalty
	;with minutes and sends the player to the box, later passes wait until he is off the ice and drop the entry. When PenBuf is empty, recount
	;players and go to the face off, or (94) the penalty shot. 94: only a 5 minute penalty is matched as coincidental. Entered from chkprogress
	tst.w	(RefCnt).w
	bpl.w	rtss2	;animation in progress
	tst.w	(RefStep).w
	bpl.w	rtss2
	movem.l	d0/a0-a3,-(sp)
.12230
	movea.w	#(PenBuf-M68K_RAM),a0	;IDA: loc_12230 (93 .top)
	tst.w	(a0)+
	beq.w	.123A2
.1223A
	tst.w	(a0)+
	bne.s	.1223A	;find end of list
	subq.w	#4,a0
	bclr	#7,1(a0)	;player who is guilty
	bne.w	.1226A
	move.l	a3,-(sp)
	clr.w	d1
	move.b	1(a0),d1
	asl.w	#7,d1	;scsize
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d1,a3
	tst.w	$34(a3)	;position
	movea.l	(sp)+,a3
	bpl.w	.123D8	;still on the ice
	clr.w	(a0)
	bra.w	.123D8
.1226A
	clr.w	d0
	move.b	(a0),d0
	movea.l	#PenaltyList,a1
	adda.w	0(a1,d0.w),a1
	bclr	#5,(word_FFC2F6).w	;94 only: bit 5 = this penalty is 5 minutes
	clr.w	d2
	move.b	1(a1),d2	;penalty minutes
	beq.w	.1238E	;no player involved
	bmi.w	.1238E	;94: negative minutes too
	cmp.b	#5,d2
	bne.w	.1229A
	bset	#5,(word_FFC2F6).w
.1229A
	movem.l	d0-d1/a1-a4,-(sp)
	bsr.w	sub_14A94	;93 GetPeriodTimeRemaining. Log time, penalty and player
	movea.w	#(PenSum-M68K_RAM),a4	;93 unk_FFC3F6
	adda.w	(PenSumLength).w,a4	;93 word_FFC3F4
	cmpi.w	#$EC,(PenSumLength).w	;log full: keep overwriting the last entry
	beq.w	.122B8
	addq.w	#4,(PenSumLength).w
.122B8
	move.w	d0,(a4)+	;time
	move.b	(a0),(a4)+	;penalty
	clr.w	d1
	move.b	1(a0),d1
	asl.w	#7,d1	;scsize
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d1,a3
	clr.w	d0
	movea.w	#(HmShots-M68K_RAM),a2
	lea	$364(a2),a1	;tmsize: visitors
	btst	#6,$62(a3)	;pfteam
	beq.w	.122EA
	bset	#7,-1(a4)	;log: visitors
	move.w	#$8000,d0
	exg	a1,a2
.122EA
	addq.w	#1,6(a2)	;tmPenalties
	add.w	d2,8(a2)	;tmPenmin
	move.b	$66(a3),d0	;pnum
	move.b	d0,(a4)	;log: player
	move.w	d0,(TempPlOffset).w
	ext.w	d0
	addi.w	#$102,d0	;per-player penalty minutes byte at $102+pnum
	add.b	d2,0(a2,d0.w)
	subi.w	#$102,d0
	asl.w	#1,d0
	ext.w	d2
	mulu.w	#$3C,d2	;60
	bset	#$D,d2	;tmpdst bit 13
	tst.w	$66(a2,d0.w)	;tmpdst
	bmi.w	.1232C
	btst	#4,$66(a2,d0.w)
	beq.w	.1232C
	bset	#$C,d2	;keep byte bit 4 (word bit 12) of an old penalty time
.1232C
	move.w	d2,$66(a2,d0.w)
	andi.w	#$EFFF,d2
	moveq	#$34,d1	;(MaxRos-1)*2+2
.12336
	subq.w	#2,d1	;IDA: loc_12336. same time on the other team
	bmi.w	.1235C
	move.w	$66(a1,d1.w),d3
	andi.w	#$EFFF,d3
	cmp.w	d3,d2
	bne.s	.12336
	btst	#5,(word_FFC2F6).w	;94 only: coincidental for a 5 minute penalty only
	beq.s	.12336
	bset	#6,$66(a1,d1.w)	;coincidental (byte bit 6, word bit 14)
	bset	#6,$66(a2,d0.w)
.1235C
	movem.l	a0,-(sp)
	lea	$9A(a2),a0	;add player to penalty box list
	moveq	#$18,d1
.12366
	tst.b	(a0)+
	dbmi	d1,.12366	;find end of list
	move.b	d0,-1(a0)
	st	(a0)
	movem.l	(sp)+,a0
	move.w	#$C,d0	;asspenalty
	bsr.w	assreplace
	movem.l	(sp)+,d0-d1/a1-a4
	bsr.w	SetPA
	bsr.w	sub_12DA6	;93 USBoard
	bra.w	.123D8
.1238E
	clr.w	(a0)	;93 .sa2
	btst	#7,(sflags).w	;sfhor
	bne.w	.12230
	bsr.w	SetPA
	bra.w	.123D8
.123A2
	movea.w	#(HmShots-M68K_RAM),a2	;IDA: loc_123A2 (93 .exit). home team struct
	bsr.w	coinsearch
	adda.w	#$364,a2	;tmsize
	bsr.w	coinsearch
	bclr	#2,(gmode).w	;gmpen
	movea.w	#(puckx-M68K_RAM),a3
	bclr	#6,(BA_PS_flags).w	;94 only
	move.w	#$1B,d0	;puckfaceoff (asstab $18DE8)
	btst	#3,(BA_PS_flags).w
	beq.w	.123D4
	move.w	#$1E,d0	;puckshootout (asstab $18DF4): penalty shot
.123D4
	bsr.w	assreplace
.123D8
	movem.l	(sp)+,d0/a0-a3
	rts
coinsearch	;IDA: sub_123DE (93 IDA name). a2 = team. Clears tmpdst bit 5, counts players kept off the ice by penalties (coincidental and bit 4
	;times do not count, at most 2) and sets tmap. Called twice from InProgress
	moveq	#6,d1
	moveq	#$32,d0	;(MaxRos-1)*2
.123E2
	tst.w	$66(a2,d0.w)
	ble.w	.1240E
	bclr	#5,$66(a2,d0.w)
	btst	#6,$66(a2,d0.w)	;coincidental
	bne.w	.1240E
	btst	#4,$66(a2,d0.w)
	bne.w	.1240E
	cmp.w	#4,d1	;never below 4 players
	beq.w	.1240E
	subq.w	#1,d1
.1240E
	subq.w	#2,d0
	bpl.s	.123E2
	move.w	d1,$24(a2)	;tmap
	rts
checkfornewpen	;look for new penalty (entered thru addpenalty(2)). Stops play at once for penalties without minutes or when the guilty team does not
	;have the puck, otherwise starts a delayed penalty call
	btst	#7,(sflags).w	;sfhor
	bne.w	rtss2
.12422	;IDA label, no xref
	movea.w	#(PenBuf-M68K_RAM),a0
.next
	tst.w	(a0)+
	beq.w	rtss2
	btst	#2,(gmode).w	;gmpen
	bne.w	.iscalled
	clr.w	d0
	move.b	-2(a0),d0
	movea.l	#PenaltyList,a1
	adda.w	0(a1,d0.w),a1
	tst.b	1(a1)	;time for penalty
	beq.w	.callit
	move.w	(puckc).w,d0
	bmi.w	.dc
	subq.w	#6,d0
	move.b	-1(a0),d1	;player penalized
	ext.w	d1
	subq.w	#6,d1
	eor.w	d1,d0
	bmi.w	.dc	;delayed penalty call
.callit
	bsr.w	Stop4Pen
.iscalled
	bset	#7,-1(a0)
	bne.s	.next
	clr.w	d0
	move.b	-2(a0),d0	;penalty called
	movea.l	#PenaltyList,a1
	adda.w	0(a1,d0.w),a1
	clr.w	d1
	move.b	(a1),d1	;delay for stopping action
	asl.w	#5,d1
	cmp.w	(Pencntdwn).w,d1
	ble.s	.next
	move.w	d1,(Pencntdwn).w
	bra.s	.next
.dc
	bset	#3,(gmode).w	;gmpendel
	bne.s	.next
	move.w	#$2C,d0	;delayed penalty (92 PenDelay = $24)
	bsr.w	SetPA
	bra.s	.next
Stop4Pen	;a0 = penaltylist penalty +2. Stop the clock, set the face off spot from the penalty type, blow the whistle. 94 adds sub_1A304 before the whistle. Also entered from puckfaceoff
	bset	#0,(gmode).w	;gmclock
	bne.w	.skipfo
	clr.w	d0
	clr.w	d1
	cmpi.b	#$E,-2(a0)	;goal (92 PenGoal = 6): center ice
	beq.w	.noticing
	move.w	(ltx).w,d0
	move.w	(lty).w,d1
	cmpi.b	#6,-2(a0)	;OOP (92 PenOOP = $C)
	beq.w	.noticing
	move.w	(puckx).w,d0
	move.w	(pucky).w,d1
	cmpi.b	#$C,-2(a0)	;icing (92 PenIcing = 8)
	bne.w	.noticing
	move.l	a3,-(sp)
	movea.w	#(SortCords-M68K_RAM),a3
	move.b	-1(a0),d1
	ext.w	d1
	asl.w	#7,d1	;scsize
	adda.w	d1,a3
	move.w	#$258,d1	;600
	btst	#7,$62(a3)	;pfgoal
	movea.l	(sp)+,a3
	beq.w	.noticing
	neg.w	d1
.noticing
	movem.w	d0-d1,-(sp)
	cmp.w	#$46,d0	;.xspot = 70
	blt.w	.0
	move.w	#$46,d0
.0
	cmp.w	#$FFBA,d0	;-.xspot
	bgt.w	.1
	move.w	#$FFBA,d0
.1
	cmp.w	#$A6,d1	;.yspot-.ygive = 206-40
	blt.w	.2
	move.w	#$CE,d1	;.yspot = 206
	move.w	#$46,d0
	tst.w	(sp)
	bpl.w	.2
	neg.w	d0
.2
	cmp.w	#$FF5A,d1	;-.yspot+.ygive
	bgt.w	.3
	move.w	#$FF32,d1	;-.yspot
	move.w	#$46,d0
	tst.w	(sp)
	bpl.w	.3
	neg.w	d0
.3
	move.w	d0,(fox).w
	move.w	d1,(foy).w
	addq.w	#4,sp
	bsr.w	limitfo
.skipfo
	clr.w	(Pencntdwn).w
	bset	#2,(gmode).w	;gmpen
	jsr	(sub_1A304).l	;94 only
	move.w	#3,-(sp)	;whistle (92 SFXwhistle = 10)
	bsr.w	sfx
	move.w	#$A,d0	;whistle (92 PenWhistle = $26)
	bra.w	SetPA
limitfo	;limit face off to 5-20 feet from walls of rink. Checks every player in PenBuf
	movem.l	d0-d1/a0-a1,-(sp)
	movea.w	#(PenBuf-M68K_RAM),a0
.12586
	bsr.w	.12596	;93 .lf
	addq.w	#2,a0
	tst.w	(a0)
	bne.s	.12586
	movem.l	(sp)+,d0-d1/a0-a1
	rts
.12596
	move.b	1(a0),d0
	andi.w	#$7F,d0
	asl.w	#7,d0	;scsize
	movea.w	#(SortCords-M68K_RAM),a1
	move.w	#$58,d1	;92 blueline
	btst	#7,$62(a1,d0.w)	;pfgoal
	bne.w	.125C6
	neg.w	d1
	cmp.w	(foy).w,d1
	blt.w	rtss2
	move.w	#$FFBF,(foy).w	;-.nuy = -65
	bra.w	.125D4
.125C6
	cmp.w	(foy).w,d1
	bgt.w	rtss2
	move.w	#$41,(foy).w	;.nuy = 65
.125D4
	move.w	#$46,d0	;.nux = 70
	tst.w	(fox).w
	bpl.w	.125E2
	neg.w	d0
.125E2
	move.w	d0,(fox).w
	rts
UpdatePA	;animate ref in ref window. As 93: DisplayPeriodOver (94 sub_1850A) for game over, and the horizontal penalty message line is reprinted when word_FFC3EE (93 word_FFC2BA) runs out
	tst.w	(RefCnt).w
	bmi.w	rtss2
	sub.w	d7,(RefCnt).w
	bpl.w	.125FC
	bsr.w	SetPA2
.125FC
	cmpi.w	#4,(RefPen).l	;game over (92 PenEOG = 4)
	bne.w	.1260C
	bsr.w	sub_1850A	;93 DisplayPeriodOver
.1260C
	sub.w	d7,(word_FFC3EE).w
	bpl.w	rtss2
	move.w	#$7FFF,(word_FFC3EE).w
	bsr.w	PrintPenaltyMessagesString
	bsr.w	printz
	String	$BF,$11,$B	;IDA: ori.b / btst d5,d0
	bsr.w	sub_18A6E	;93 GetPlayerName
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w	;center it
	bra.w	print
SetPA	;start ref animation. d0 = animation (penalty number). 94: animations from $2E up are ignored, and sub_FC5AE is called when word_FFC2FA bits 0
	;and 3 are set. Goal calls loc_1889A (93 DisplayPlayerAttributeMenu). Falls into SetPA2
	move.w	d0,(RefPen).w
	cmp.w	#$2E,d0	;94 only: not on the penalty list
	blt.w	.12646
	rts
.12646
	clr.w	(RefStep).w
	bsr.w	prefmes
	cmp.w	#$E,d0	;goal (92 PenGoal = 6)
	bne.w	.1265A
	bsr.w	loc_1889A	;93 DisplayPlayerAttributeMenu
.1265A
	btst	#0,(word_FFC2FA).w	;94 only
	beq.w	.12674
	btst	#3,(word_FFC2FA).w
	beq.w	.12674
	jsr	(sub_FC5AE).l
.12674
	move.w	#$7FFF,(word_FFC3EE).w
	btst	#7,(sflags).w	;sfhor
	beq.w	SetPA2
	move.w	#$3C,(word_FFC3EE).w	;60
SetPA2	;IDA: setPA2 (93 SetPA2). update animation for ref. Next frame/delay pair from the PenaltyList animation of RefPen. 94: the delay is doubled
	;when word_FFC2FA bits 0 and 3 are set. Also called from UpdatePA
	movem.l	d0-d2/a0-a1,-(sp)
	moveq	#$40,d0	;clear ref window
	tst.w	(RefStep).w
	bmi.w	.126EE
	move.w	(RefStep).w,d0
	addq.w	#2,(RefStep).w
	move.w	(RefPen).w,d1
	movea.l	#PenaltyList,a0
	adda.w	0(a0,d1.w),a0
	addq.w	#2,a0
	adda.w	(a0),a0
	move.w	0(a0,d0.w),d0
	bpl.w	.126C0
	neg.w	d0	;negative = last frame
	st	(RefStep).w
.126C0
	clr.w	d1
	move.b	d0,d1
	asl.w	#3,d1
	move.w	d1,(RefCnt).w
	btst	#0,(word_FFC2FA).w	;94 only
	beq.w	.126EC
	btst	#3,(word_FFC2FA).w
	beq.w	.126EC
	move.w	d0,-(sp)
	move.w	(RefCnt).w,d0
	add.w	d0,d0
	move.w	d0,(RefCnt).w
	move.w	(sp)+,d0
.126EC
	lsr.w	#8,d0
.126EE
	bsr.w	PushRef
	movem.l	(sp)+,d0-d2/a0-a1
	rts
PushRef	;tell vblank what to display. d0 = ref frame, $40 clears the window. The horizontal ref uses unk_5CF64 (93 RefMap2)
	movem.l	d0-d2/a0-a1,-(sp)
	cmp.w	#$40,d0
	beq.w	.clearit
	mulu.w	#$70,d0	;refwidth*refheight*2
	movea.l	#RefsMap,a0
	btst	#7,(sflags).w	;sfhor
	beq.w	.1271E
	movea.l	#unk_5CF64,a0	;93 RefMap2
.1271E
	adda.l	4(a0),a0
	addq.w	#4,a0
	adda.w	d0,a0
	movea.w	#(RefRamMap-M68K_RAM),a1
	move.w	(ExtraChars).w,d2
	btst	#7,(sflags).w
	bne.w	.1273C
	ori.w	#$8000,d2	;priority
.1273C
	moveq	#$37,d0	;(refheight*refwidth)-1
.1273E
	move.w	(a0)+,(a1)
	add.w	d2,(a1)+
	dbf	d0,.1273E
	bset	#1,(sflags2).w	;sf2refref
	bra.w	.12774
.clearit
	btst	#7,(sflags).w	;sfhor: horizontal mode only clears the line
	bne.w	.1276E
	movea.w	#(RefRamMap-M68K_RAM),a1
	moveq	#$37,d0	;(refheight*refwidth)-1
.2
	move.w	#$7FF,(a1)+	;blank tile
	dbf	d0,.2
	bset	#1,(sflags2).w	;sf2refref
.1276E
	moveq	#-1,d0	;clear line
	bsr.w	prefmes
.12774
	movem.l	(sp)+,d0-d2/a0-a1
	rts
prefmes	;print message for penalty d0 (negative clears it). Vertical mode: framed under the ref. Horizontal mode: one centered line on row $B
	movem.l	d0-d2/a1,-(sp)
	btst	#7,(sflags).w	;sfhor
	bne.w	.hor
	tst.w	d0
	bpl.w	.noblank
	bsr.w	printz
	String	$BF,0,$A
	moveq	#$D,d0
	moveq	#3,d1
	move.w	#$7FF,d2	;blank tile
	bsr.w	eraser
	bra.w	.ex
.noblank
	bsr.w	printz
	String	$BF,5,$A
	movea.l	#PenaltyList,a1
	adda.w	0(a1,d0.w),a1
	addq.w	#2,a1
	move.w	(a1),d0
	subq.w	#2,d0	;empty string
	beq.w	.ex
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	bpl.w	.nb0
	clr.w	(printx).w
.nb0
	move.w	(a1),d0
	tst.b	-1(a1,d0.w)
	bne.w	.nb1
	subq.w	#1,d0
.nb1
	moveq	#3,d1
	bsr.w	Framer
	subq.w	#2,(printy).w
	addq.w	#1,(printx).w
	bsr.w	print
	bra.w	.ex
.hor
	bsr.w	PrintPenaltyMessagesString	;clear the line first
	tst.w	d0
	bmi.w	.ex
	bsr.w	printz
	String	$BF,$11,$B
	movea.l	#PenaltyList,a1
	adda.w	0(a1,d0.w),a1
	addq.w	#2,a1
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	bsr.w	print
.ex
	movem.l	(sp)+,d0-d2/a1
	rts
PrintPenaltyMessagesString	;IDA: sub_12828 (93 name). Blank the horizontal mode penalty message line (22 spaces at x 5, y $B). Called from UpdatePA and prefmes
	bsr.w	printz
	String	$BF,5,$B,'                      ',0	;22 spaces
	rts
PenGoalStuff	;IDA: sub_1284A (93 name). do this stuff after a goal. a1 = scored on team, a2 = scoring team. 94 clears PenBuf only when the scored
	;on team has 6 on the ice. If the scoring team had more players on ice, the first scored on player in the box without a coincidental penalty
	;is released (94 also sets DelayedPen bit 0)
	movem.l	d0-d2/a0,-(sp)
	cmpi.w	#6,$24(a1)	;94 only: tmap
	bne.w	.1285C
	bsr.w	clrPenBuf
.1285C
	move.w	$24(a2),d2	;end p.killing by scored on team
	cmp.w	$24(a1),d2
	ble.w	.1289E
	lea	$9A(a1),a0
.1286C
	clr.w	d2
	move.b	(a0)+,d2
	bmi.w	.1289E
	btst	#6,$66(a1,d2.w)	;coincidental
	bne.s	.1286C
	clr.w	$66(a1,d2.w)
	bsr.w	RemovePlayerFromList
	bset	#0,(DelayedPen).w	;94 only
	addq.w	#1,$24(a1)	;tmap
	addq.w	#1,2(a2)	;tmPwrGoals
	bset	#0,(byte_FFC6FE).w	;home tmflags: tmflcc
	bset	#0,(byte_FFCA62).w	;visitors tmflags: tmflcc
.1289E
	movem.l	(sp)+,d0-d2/a0
	rts
clrPenBuf	;clear PenBuf (93 ClearPenaltyBuffer). Called from clockcont and PenGoalStuff
	moveq	#$1F,d0	;MaxPen-1
	movea.w	#(PenBuf-M68K_RAM),a0
.loop
	clr.w	(a0)+
	dbf	d0,.loop
	rts
updatepentime	;update the time remaining on all penalized players, once a second. Sets sflags3 bit 6 on that tick. 94 adds updatePPTeamTime. Falls into ProcessPenaltyList for team 2
	bclr	#6,(sflags3).w
	btst	#0,(gmode).w	;gmclock
	bne.w	rtss2
	sub.w	d7,(Penaltytimer).w
	bpl.w	rtss2
	addi.w	#$18,(Penaltytimer).w	;jps
	bset	#6,(sflags3).w	;one second tick
	bsr.w	chkatop
	jsr	(updatePPTeamTime).l	;94 only
	movea.w	#(HmShots-M68K_RAM),a2
	bsr.w	ProcessPenaltyList
	adda.w	#$364,a2	;tmsize
ProcessPenaltyList	;IDA: loc_128EC (93 name). a2 = team. Walks the penalty box list ($9A): the first two players without a coincidental penalty
	;count down one second and the rest wait. Beeps when the first served time gets to 5 or less and releases the player at 0. Coincidental
	;penalties count down on their own
	lea	$9A(a2),a0	;penalty box list
	movea.w	#(mesarea-M68K_RAM),a1	;serving players
	moveq	#2,d1	;two can serve at once
	moveq	#2,d3
.128F8
	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	.1291E
	btst	#6,$66(a2,d0.w)	;coincidental
	bne.w	.12968
	subq.w	#1,d1
	bmi.s	.128F8	;third or later player waits
	move.w	d0,(a1)+
	subq.w	#1,$66(a2,d0.w)
	bne.w	.1291C
	bsr.w	RemovePlayerFromList	;time is up
.1291C
	bra.s	.128F8
.1291E
	move.w	(mesarea).w,d0	;first serving player
	cmp.w	#1,d1	;one serving
	beq.w	.12944
	tst.w	d1
	bne.w	.12938
	bsr.w	.12944	;two serving: check the first, then the second
	bra.w	.12940
.12938
	cmp.w	#$FFFF,d1	;exactly three in the list: check the second only
	bne.w	rtss2
.12940
	move.w	(word_FFBFA6).w,d0	;second serving player (mesarea+2, 93 TextBuffer)
.12944
	cmpi.w	#5,$66(a2,d0.w)
	bgt.w	rtss2
	move.w	#1,-(sp)	;SFXbeep1
	tst.w	$66(a2,d0.w)
	bne.w	.12962
	bsr.w	releasepl
	move.w	#2,(sp)	;SFXbeep2
.12962
	bsr.w	sfx
	rts
.12968
	subq.w	#1,$66(a2,d0.w)	;IDA: loc_12968. coincidental penalty
	btst	#3,$66(a2,d0.w)
	beq.s	.128F8
	btst	#4,$66(a2,d0.w)
	bne.w	.12988
	move.w	#$1000,$66(a2,d0.w)
	bra.w	RemovePlayerFromList
.12988
	clr.w	$66(a2,d0.w)	;falls into RemovePlayerFromList
RemovePlayerFromList	;IDA: loc_1298C (93 name). Remove the entry before a0 from a penalty box list by shifting the rest down (list ends with a
	;negative byte). Return a0 = removed slot. Called from PenGoalStuff, ProcessPenaltyList
	moveq	#-1,d2
.1298E
	addq.w	#1,d2
	move.b	0(a0,d2.w),-1(a0,d2.w)
	bpl.s	.1298E
	subq.w	#1,a0
	rts
chkatop	;attack time of possession stat update. Called once a second from updatepentime
	moveq	#0,d1
	move.w	(pucky).w,d0
	cmp.w	#$58,d0	;92 blueline
	bgt.w	.129BA
	move.l	#$364,d1	;tmsize
	neg.w	d0
	cmp.w	#$58,d0	;92 blueline
	blt.w	rtss2
.129BA
	btst	#1,(gmode).w	;gmdir
	beq.w	.129C8
	eori.w	#$364,d1
.129C8
	movea.w	#(HmShots-M68K_RAM),a2
	addq.w	#1,$A(a2,d1.w)	;attack time
	rts
releasepl	;IDA: sub_129D2 (93 name). player's penalty time is up so let him out (if appropriate). a2 = team, d0 = player*2. Called from ProcessPenaltyList
	movem.l	d0-d3/a0-a3,-(sp)
	movea.w	$22(a2),a3	;tmsort
	suba.w	#$80,a3
.129DE
	adda.w	#$80,a3	;IDA: loc_129DE. first sort obj not on the ice
	tst.w	$34(a3)
	bpl.s	.129DE
	move.w	d0,d3
	lsr.w	#1,d3
	move.w	$24(a2),d1	;tmap
	addq.w	#1,$24(a2)
	bset	#0,(byte_FFC6FE).w	;home tmflags: tmflcc
	bset	#0,(byte_FFCA62).w	;visitors tmflags: tmflcc
	movea.l	#priolist,a0
	tst.w	$26(a2)	;tmgoalie
	bpl.w	.12A10
	addq.w	#1,a0
.12A10
	clr.w	$34(a3)	;position
	move.b	0(a0,d1.w),$35(a3)
	bsr.w	Setplass
	bsr.w	setplayer
	bset	#2,$63(a3)	;pflags2 bit 2 (93: 92 pf2unav, bit 4 in 92)
	movem.l	(sp)+,d0-d3/a0-a3
	rts
CalcPenTime	;93 GetLowestPen. a2 = shorthanded team, a3 = team on the power play. Return d0 = power play time left from the penalty box times. Called from updatepwrplay
	clr.w	d0
	clr.w	d3
	lea	$9A(a2),a0	;penalty box list
.getstatus
	clr.w	d2
	move.b	(a0)+,d2
	bmi.w	.endoflist
	move.w	$66(a2,d2.w),d2	;tmpdst
	btst	#$E,d2	;bit 14: coincidental
	bne.s	.getstatus
	sub.w	d3,d2
	add.w	d2,d0
	move.w	d2,d3
	bra.s	.getstatus
.endoflist
	cmpi.w	#6,$24(a3)	;tmap: 6 on ice, done
	beq.w	rtss2
	sub.w	d3,d0
	lea	$9A(a3),a0
	clr.w	d2
.getstatusopp
	move.b	(a0)+,d2
	bmi.w	rtss2
	btst	#6,$66(a3,d2.w)	;coincidental (byte bit 6, word bit 14)
	bne.s	.getstatusopp
	cmp.w	$66(a3,d2.w),d0
	blt.w	rtss2
	add.w	d3,d0
	rts
updatepwrplay	;show graphic and time remaining for power plays. 94: nothing when word_FFC2FA bit 1 is set, and no song at the start of a home power
	;play (the 93 test is left and both ways go to .uppt). Prints the time and the team on the power play
	btst	#1,(word_FFC2FA).w	;94 only
	bne.w	rtss2
	movea.w	#(HmShots-M68K_RAM),a2
	lea	$364(a2),a3	;tmsize
	move.w	$24(a2),d0	;tmap
	sub.w	$24(a3),d0
	beq.w	.clrpwrplay	;same number on the ice
	bpl.w	.t0
	btst	#6,(sflags2).w	;sf2pwrtm: 0 home, 1 visitors
	bne.w	.upp
	bsr.w	.clrpwrplay
	bset	#6,(sflags2).w
	bra.w	.upp
.t0
	exg	a2,a3
	btst	#6,(sflags2).w
	beq.w	.upp
	bsr.w	.clrpwrplay
	bclr	#6,(sflags2).w
.upp
	bset	#5,(sflags2).w	;sf2pwrplay
	bne.w	.uppt
	addq.w	#1,4(a3)	;tmPwrPlays
	cmpa.w	#(HmShots-M68K_RAM),a3	;home: 93 plays song $33 here
	bne.w	.away
.home
	bra.w	.uppt
.away
	bra.s	.home
.uppt
	bsr.w	printz
	String	$BF,1,$19,'   ',$16,$17,$18,$19,$BF,1,$1A,'  ',0
	bsr.w	CalcPenTime
	bsr.w	PushTime
	bsr.w	print
	movea.l	$1E(a3),a0	;tmdata
	movea.w	#(mesarea-M68K_RAM),a3
	move.w	#2,(a3)
	bsr.w	appendz
	String	$BF,1,$19		;IDA: ori.b / move.b d0,-(a4)
	adda.w	4(a0),a0	;team name
	adda.w	(a0),a0
	movea.l	a0,a1
	bsr.w	appstring
	movea.w	a3,a1
	bra.w	print
.clrpwrplay
	bclr	#5,(sflags2).w
	beq.w	rtss2
	bra.w	sub_12D70
ClrHor	;revert the graphics back to vertical ice rink mode. 94 reloads Rinktiles and calls sub_FEA52
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#7,(sflags).w	;sfhor
	move.w	#$3E8,(Oldrow).w	;1000
	move.w	(rinkvrcset).w,d4	;94 only
	movea.l	#Rinktiles,a2
	jsr	(DoDMA_clearCallbackPointer).l
	jsr	(sub_FEA52).l
	bsr.w	SprSort
	btst	#0,(sflags).w	;sfpz
	bne.w	.ex
	bsr.w	printz
	String	$FF,0,0
	moveq	#$20,d0	;32
	moveq	#$1C,d1	;28
	move.w	#$7FF,d2	;blank tile
	bsr.w	eraser
	bsr.w	PrintScores1
.ex
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SetHor	;switch graphics to horizontal ice rink graphics mode
	movem.l	d0-d7/a0-a6,-(sp)
	bset	#7,(sflags).w	;sfhor
.12B9E
	btst	#0,(disflags).w	;dfok
	bne.s	.12B9E
	clr.w	(Hscroll).w
	clr.w	(Vscroll).w
	bsr.w	SprSort
	bsr.w	printz
	String	$FE,0,0
	movea.l	#unk_BC05C,a1	;IDA hid this in the string (ori.b x3). 93 IceRinkMap; IDA icerinkmap is unk_BC05C+8
	adda.l	4(a1),a1
	movea.l	#icerinkmap,a2	;93 #$310
	clr.w	d0
	move.w	#0,d1	;93 85
	moveq	#$20,d2	;32
	moveq	#$1C,d3	;28
	move.w	(rinkvrcset).w,d4
	moveq	#0,d5
	bsr.w	dobitmap
	bsr.w	sub_12DA6	;93 USBoard
	btst	#0,(sflags).w	;sfpz
	bne.w	.12BFE
	move.w	#$800,d0	;92 $1000
	move.w	(VmMap1).w,d1
	move.w	#$7FF,d2	;blank tile
	bsr.w	DoFill
.12BFE
	movem.l	(sp)+,d0-d7/a0-a6
	rts
