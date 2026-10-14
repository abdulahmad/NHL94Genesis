;	New in 95: rosters and trades. Season rosters live in save RAM. The Trade Players
;	screen checks a trade against the rules, asks the general manager, then makes the trade.

DefaultRosters	;Build the default roster tables for the 28 teams in RAM (RosterTable $38 bytes a team: player ids, then the
	;goalie, defense and forward counts; RosterRatings $20 a team) from TeamList
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#0,d1
	movea.l	#RosterTable,a6
	movea.l	#RosterRatings,a4
.team
	clr.w	d2
	movea.l	a6,a0
	move.w	#$19,d5
.clr
	move.w	#$8000,(a0)+
	dbf	d5,.clr
	movea.l	a6,a0
	movea.l	a4,a2
	movea.l	#TeamList,a1
	move.w	d1,d0
	asl.w	#2,d0
	movea.l	(a1,d0.w),a1
	adda.w	(a1),a1
	bra.w	.store
.player
	cmpi.w	#2,(a1)
	beq.w	.counts
	addq.w	#1,d2
.store
	move.b	d1,(a0)+
	move.b	d2,(a0)+
	adda.w	(a1),a1
	move.b	(a1),d4
	move.b	d4,(a2)+
	addq.w	#8,a1
	bra.s	.player
.counts
	movem.l	d1-d7/a0,-(sp)
	move.w	d1,d7
	movea.l	#TeamList,a0
	asl.w	#2,d7
	movea.l	(a0,d7.w),a0
	adda.w	$A(a0),a0
	move.w	(a0),d1
	clr.w	d0
.goalies
	addq.w	#1,d0
	asl.w	#4,d1
	bne.s	.goalies
	movea.l	a6,a0
	move.b	d0,$34(a0)
	move.w	d0,d4
	movea.l	#TeamList,a0
	movea.l	(a0,d7.w),a0
	adda.w	8(a0),a0
	move.b	3(a0),d0
	lsr.w	#4,d0
	andi.w	#$F,d0
	movea.l	a6,a0
	move.b	d0,$36(a0)
	addq.w	#1,d2
	add.b	d4,d0
	sub.b	d0,d2
	move.b	d2,$35(a0)
	movem.l	(sp)+,d1-d7/a0
	adda.l	#$38,a6
	adda.l	#$20,a4
	addq.w	#1,d1
	cmp.w	#NumTeams,d1
	blt.w	.team
	movem.l	(sp)+,d0-d7/a0-a6
	rts

GetRosterId	;d0 = roster id word of player d0 of team d7 (season roster in save RAM SRRosters, or d7 << 8 | d0 outside a season)
	movem.l	d1/d6-d7/a0,-(sp)
	btst	#6,(sflags11).w
	beq.w	.season
	asl.w	#8,d7
	andi.w	#$FF,d0
	or.w	d7,d0
	bra.w	.done
.season
	mulu.w	#$38,d7
	add.w	d0,d0
	ext.l	d0
	add.l	d7,d0
	addi.l	#SRRosters,d0
	moveq	#2,d1
	movea.l	#SRAMbyte,a0
	jsr	(ReadSRAM).l
	move.w	(a0),d0
.done
	movem.l	(sp)+,d1/d6-d7/a0
	rts

GetCreatedName	;a1 = player record of roster id d0 (created players from save RAM SRCreatedPlayers)
	movem.l	d0-d1/d5-d7/a0,-(sp)
	bra.w	GetRosterNameTail
	rts

GetRosterName	;a1 = player record of player d0 of team d7: TeamList outside a season, else from the season roster
	;(team $1C: the free agent list SRFreeAgentList)
	movem.l	d0-d1/d5-d7/a0,-(sp)
	btst	#6,(sflags11).w
	beq.w	.season
	move.w	d7,d6
	movea.l	#TeamList,a1
	asl.w	#2,d6
	movea.l	(a1,d6.w),a1
	adda.w	(a1),a1
	bra.w	.next
.skip
	adda.w	(a1),a1
	addq.w	#8,a1
.next
	dbf	d0,.skip
	movem.l	(sp)+,d0-d1/d5-d7/a0
	rts
.season
	cmp.w	#FreeAgentTeam,d7
	bne.w	.team
	add.w	d0,d0
	ext.l	d0
	addi.l	#SRFreeAgentList,d0
	bra.w	.read
.team
	move.w	d7,d6
	mulu.w	#$38,d7
	add.w	d0,d0
	ext.l	d0
	add.l	d7,d0
	addi.l	#SRRosters,d0
.read
	moveq	#2,d1
	movea.l	#SRAMbyte,a0
	jsr	(ReadSRAM).l
	move.w	(a0),d0

GetRosterNameTail	;GetCreatedName / GetRosterName: a1 = the player record of roster id d0
	move.w	d0,-(sp)
	andi.w	#$1F00,d0
	cmp.w	#$1E00,d0
	bne.w	.team
	move.w	(sp)+,d0
	andi.w	#$FF,d0
	asl.w	#5,d0
	ext.l	d0
	addi.l	#SRCreatedPlayers,d0
	moveq	#$20,d1
	movea.l	#CreatedPlayerBuf+$2,a0
	jsr	(ReadSRAM).l
	movea.l	a0,a1
	bra.w	.done
.team
	move.w	(sp)+,d0
	move.w	d0,d6
	lsr.w	#8,d6
	andi.w	#$1F,d6
	andi.w	#$FF,d0
	movea.l	#TeamList,a1
	asl.w	#2,d6
	movea.l	(a1,d6.w),a1
	adda.w	(a1),a1
	bra.w	.next
.skip
	adda.w	(a1),a1
	addq.w	#8,a1
.next
	dbf	d0,.skip
.done
	movem.l	(sp)+,d0-d1/d5-d7/a0
	rts

ReadTeamRoster	;Read team d7's $38 byte season roster from save RAM SRRosters into a0
	movem.l	d0-d1,-(sp)
	move.w	d7,d0
	mulu.w	#$38,d0
	addi.l	#SRRosters,d0
	moveq	#$38,d1
	jsr	(ReadSRAM).l
	movem.l	(sp)+,d0-d1
	rts

WriteTeamRoster	;Write team d7's $38 byte season roster to save RAM SRRosters and update the checksum
	movem.l	d0-d1,-(sp)
	move.w	d7,d0
	mulu.w	#$38,d0
	addi.l	#SRRosters,d0
	moveq	#$38,d1
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d1
	rts

GetJerseyNumber	;jerseynum = the jersey number byte of player d0 of team d7 (TeamList or the season roster)
	movem.l	d0-d1/a0,-(sp)
	btst	#6,(sflags11).w
	beq.w	.season
	move.w	d7,-(sp)
	movea.l	#TeamList,a0
	asl.w	#2,d7
	movea.l	(a0,d7.w),a0
	adda.w	(a0),a0
	bra.w	.next
.skip
	adda.w	(a0),a0
	addq.w	#8,a0
.next
	dbf	d0,.skip
	adda.w	(a0),a0
	clr.w	(CreatedPlayerBuf).w
	move.b	(a0),(jerseynum).w
	move.w	(sp)+,d7
	bra.w	.done
.season
	move.w	d7,d1
	asl.w	#5,d1
	ext.l	d1
	ext.l	d0
	add.l	d1,d0
	addi.l	#SRJerseyNums,d0
	moveq	#1,d1
	movea.l	#CreatedPlayerBuf,a0
	clr.b	(a0)+
	jsr	(ReadSRAM).l
	move.b	(a0),(jerseynum).w
.done
	movem.l	(sp)+,d0-d1/a0
	rts

FixJerseyNumber	;Give player d0 of team d7 a jersey number no teammate has (save RAM SRJerseyNums): step it up in BCD,
	;99 wrapping to 1, until it is unique
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d0,d2
	jsr	(GetPlayerCountD7).l
	move.w	d0,d3
	movea.l	#ThreeStars,a0
	asl.w	#5,d7
	ext.l	d7
	addi.l	#SRJerseyNums,d7
	move.l	d7,d0
	moveq	#$20,d1
	movem.l	d0-d1/a0,-(sp)
	jsr	(ReadSRAM).l
.retry
	move.b	(a0,d2.w),d4
	move.w	d3,d5
	subq.w	#1,d5
	clr.w	d0
.cmp
	cmp.w	d0,d2
	beq.w	.next
	cmp.b	(a0,d0.w),d4
	bne.w	.next
	addq.b	#1,d4
	move.b	d4,d6
	andi.w	#$F,d6
	cmp.b	#$A,d6
	bne.w	.set
	addi.b	#$10,d4
	andi.w	#$F0,d4
	cmp.b	#$A0,d4
	bne.w	.set
	move.b	#1,d4
.set
	move.b	d4,(a0,d2.w)
	bra.s	.retry
.next
	addq.w	#1,d0
	dbf	d5,.cmp
	movem.l	(sp)+,d0-d1/a0
	jsr	(WriteSRAM).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ExecuteTrade	;Do the trade: tag the chosen players of both lists with their position (TagTradePositions), take each out
	;of his team (ExtractTradedPlayer) and put him into the other (InsertTradedPlayer), keeping the list numbers right
	;(ShiftTradeDown / ShiftTradeUp); then CheckSavedLines
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tradeteam1,a0
	bsr.w	TagTradePositions
	movea.l	#tradeteam2,a0
	bsr.w	TagTradePositions
	movea.w	#(tradeteam1-M68K_RAM),a0
	movea.w	#(tradeteam2-M68K_RAM),a1
	move.w	#2,d6
.slot
	movea.l	#M68K_RAM,a2
	move.w	(a0),(TradeFromTeam).w
	move.w	(a0,d6.w),d0
	bmi.w	.team2
	move.w	d0,(TempWord1).w
	bsr.w	ExtractTradedPlayer
	bsr.w	ShiftTradeDown
.team2
	movea.l	#TradeBuf,a2
	move.w	(a1),(TradeFromTeam).w
	move.w	(a1,d6.w),d0
	bmi.w	.add1
	move.w	d0,(TempWord1).w
	bsr.w	ExtractTradedPlayer
	exg	a1,a0
	bsr.w	ShiftTradeDown
	exg	a1,a0
.add1
	movea.l	#M68K_RAM,a2
	move.w	(a1),(TradeToTeam).w
	move.w	(a0,d6.w),d5
	bmi.w	.add2
	andi.w	#$FF00,d5
	move.w	(a1),d7
	cmp.w	#0,d5
	bne.w	.3
	jsr	(GetGoalieCountD7).l
	bra.w	.pos
.3
	cmp.w	#$100,d5
	bne.w	.4
	jsr	(GetDefenseStartD7).l
	bra.w	.pos
.4
	jsr	(GetPlayerCountD7).l
.pos
	or.w	d0,d5
	move.w	d5,(TempWord2).w
	bsr.w	InsertTradedPlayer
	movem.l	d0-d7/a0-a6,-(sp)
	exg	a0,a1
	bsr.w	ShiftTradeUp
	exg	a0,a1
	movem.l	(sp)+,d0-d7/a0-a6
.add2
	movea.l	#TradeBuf,a2
	move.w	(a0),(TradeToTeam).w
	move.w	(a1,d6.w),d5
	bmi.w	.next
	andi.w	#$FF00,d5
	move.w	(a0),d7
	cmp.w	#0,d5
	bne.w	.7
	jsr	(GetGoalieCountD7).l
	bra.w	.pos2
.7
	cmp.w	#$100,d5
	bne.w	.8
	jsr	(GetDefenseStartD7).l
	bra.w	.pos2
.8
	jsr	(GetPlayerCountD7).l
.pos2
	or.w	d0,d5
	move.w	d5,(TempWord2).w
	bsr.w	InsertTradedPlayer
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	ShiftTradeUp
	movem.l	(sp)+,d0-d7/a0-a6
.next
	addq.w	#2,d6
	cmp.w	#8,d6
	blt.w	.slot
	jsr	(CheckSavedLines).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

TagTradePositions	;Put the position (0 goalie, 1 forward, 2 defense) in the high byte of each chosen player of a trade list
	move.w	(a0)+,d7
	move.w	#2,d6
.player
	move.w	(a0)+,d1
	bmi.w	.next
	andi.w	#$FF,d1
	move.w	#0,d2
	jsr	(GetGoalieCountD7).l
	cmp.w	d0,d1
	blt.w	.set
	move.w	#1,d2
	jsr	(GetDefenseStartD7).l
	cmp.w	d0,d1
	blt.w	.set
	move.w	#2,d2
.set
	move.b	d2,-2(a0)
.next
	dbf	d6,.player
	rts

ShiftTradeUp	;Trade list: the later player numbers at or after an inserted player (TempWord2) go up one
	move.b	(TempWord2+1).w,d0
.loop
	tst.w	(a0,d6.w)
	bmi.w	.exit
	cmp.b	1(a0,d6.w),d0
	bgt.w	.next
	addq.b	#1,1(a0,d6.w)
.next
	addq.w	#2,d6
	cmp.w	#8,d6
	blt.s	.loop
.exit
	rts

ShiftTradeDown	;Trade list: the later player numbers after a removed player (d0) go down one
	movem.l	d0-d7/a0-a6,-(sp)
	addq.w	#2,d6
	cmp.w	#8,d6
	bge.w	.done
.next
	tst.w	(a0,d6.w)
	bmi.w	.done
	cmp.b	1(a0,d6.w),d0
	bgt.w	.skip
	subq.b	#1,1(a0,d6.w)
.skip
	addq.w	#2,d6
	cmp.w	#8,d6
	blt.s	.next
.done
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ExtractTradedPlayer	;Take player TempWord1 out of team TradeFromTeam into the buffer a2 (roster id, jersey, stats, injury):
	;roster, jersey numbers, player stats, saved lines (FixLinesRemoved) and injury slot
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	a2,-(sp)
	bset	#7,(GameFlags).w
	move.w	(TempWord1).w,d0
	andi.w	#$FF,d0
	move.w	(TradeFromTeam).w,d7
	movem.w	d0/d7,-(sp)
	jsr	(GetRosterId).l
	move.w	d0,(a2)+
	movem.w	(sp)+,d0/d7
	jsr	(GetJerseyNumber).l
	move.w	(CreatedPlayerBuf).w,(a2)+
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#ThreeStars,a0
	move.w	d7,d0
	asl.w	#5,d0
	ext.l	d0
	addi.l	#SRJerseyNums,d0
	moveq	#$20,d1
	movem.l	d0-d1/a0,-(sp)
	jsr	(ReadSRAM).l
	move.w	(TempWord1).w,d0
	andi.w	#$FF,d0
	move.w	#$19,d1
	sub.w	d0,d1
	beq.w	.jdone
.jersey
	move.b	1(a0,d0.w),d2
	move.b	d2,(a0,d0.w)
	addq.w	#1,d0
	dbf	d1,.jersey
.jdone
	movem.l	(sp)+,d0-d1/a0
	jsr	(WriteSRAM).l
	movem.l	(sp)+,d0-d7/a0-a6
	movea.l	#ThreeStars,a0
	jsr	(ReadTeamRoster).l
	move.w	(TempWord1).w,d0
	andi.w	#$FF,d0
	add.w	d0,d0
	move.w	#$32,d3
.roster
	move.w	2(a0,d0.w),d1
	move.w	d1,(a0,d0.w)
	addq.w	#2,d0
	cmp.w	d3,d0
	blt.s	.roster
	move.w	#$8000,(a0,d0.w)
	move.w	(TempWord1).w,d0
	lsr.w	#8,d0
	add.w	d0,d0
	movea.l	#TradeCountOffsets,a3
	move.w	(a3,d0.w),d0
	subq.b	#1,(a0,d0.w)
	jsr	(WriteTeamRoster).l
	cmp.w	#$19,d7
	bgt.w	.injury
	jsr	(ReadTeamPlayerStats).l
	movea.l	#ThreeStars,a3
	move.w	#4,d6
.stat
	move.w	(TempWord1).w,d0
	andi.w	#$FF,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d3
	move.w	d3,(a2)+
	move.w	#$32,d3
.shift
	move.w	2(a3,d0.w),d1
	move.w	d1,(a3,d0.w)
	addq.w	#2,d0
	cmp.w	d3,d0
	blt.s	.shift
	clr.w	(a3,d0.w)
	adda.w	#$34,a3
	dbf	d6,.stat
	jsr	(WriteTeamPlayerStats).l
	move.w	#3,d6
.lines
	bsr.w	FixLinesRemoved
	dbf	d6,.lines
.injury
	movea.l	(sp)+,a2
	move.w	(TempWord1).w,d1
	andi.w	#$FF,d1
	move.w	(TradeFromTeam).w,d7
	jsr	(GetInjuryGames).l
	adda.l	#$E,a2
	move.w	d0,(a2)
	clr.w	d0
	jsr	(SetInjuryGames).l
	jsr	(DeleteInjurySlot).l
	bclr	#7,(GameFlags).w
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

TradeCountOffsets	;Roster count byte per position ($34 goalies, $36 forwards, $35 defense)
	dc.w	$34,$36,$35

FixLinesRemoved	;Fix saved line block d6 (TeamRecordSRAM) of team TradeFromTeam after a removed player: later slots
	;down one, his own slots $FF (refilled by CheckSavedLines), except slot numbers 1-2
	movea.l	#TeamRecordSRAM,a0
	move.w	d6,d2
	asl.w	#3,d2
	move.l	(a0,d2.w),d0
	move.l	4(a0,d2.w),d1
	move.w	(TradeFromTeam).w,d2
	mulu.w	d1,d2
	add.l	d2,d0
	movea.l	#ThreeStars,a0
	jsr	(ReadSRAM).l
	cmpi.b	#$64,-1(a0,d1.w)
	bne.w	.exit
	movem.l	d0-d1/a0,-(sp)
	subq.w	#2,d1
	move.w	(TempWord1).w,d3
	andi.w	#$FF,d3
	addq.w	#1,d3
.slot
	cmp.b	(a0,d1.w),d3
	bgt.w	.next
	beq.w	.same
	cmpi.b	#1,(a0,d1.w)
	ble.w	.next
	subq.b	#1,(a0,d1.w)
	bra.w	.next
.same
	cmp.b	#1,d3
	beq.w	.next
	cmp.b	#2,d3
	beq.w	.next
	move.b	#$FF,(a0,d1.w)
.next
	dbf	d1,.slot
	movem.l	(sp)+,d0-d1/a0
	jsr	(WriteSRAM).l
.exit
	rts

TeamRecordSRAM	;Save RAM blocks of the saved team lines (offset, size a team)
	dc.l	SRLines,$41
	dc.l	SRSavedLines1,$39
	dc.l	SRSavedLines2,$39
	dc.l	SRSavedLines3,$39

InsertTradedPlayer	;Put the player in the buffer a2 into team TradeToTeam at TempWord2: roster, player stats, saved lines
	;(FixLinesInserted), jersey number (FixJerseyNumber) and injury slot
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	a2,-(sp)
	bset	#7,(GameFlags).w
	move.w	(TradeToTeam).w,d7
	move.w	(TempWord2).w,d0
	andi.w	#$FF,d0
	movea.l	#ThreeStars,a0
	jsr	(ReadTeamRoster).l
	add.w	d0,d0
	move.w	#$34,d3
	bra.w	.rnext
.roster
	move.w	-2(a0,d3.w),d1
	move.w	d1,(a0,d3.w)
.rnext
	subq.w	#2,d3
	cmp.w	d0,d3
	ble.w	.put
	bra.s	.roster
.put
	move.w	(a2)+,(a0,d0.w)
	move.w	(a2)+,(CreatedPlayerBuf).w
	move.w	(TempWord2).w,d0
	lsr.w	#8,d0
	add.w	d0,d0
	movea.l	#TradeCountOffsets2,a3
	move.w	(a3,d0.w),d0
	addq.b	#1,(a0,d0.w)
	jsr	(WriteTeamRoster).l
	cmp.w	#$19,d7
	bgt.w	.injury
	jsr	(ReadTeamPlayerStats).l
	movea.l	#ThreeStars,a3
	move.w	#4,d6
.stat
	move.w	(TempWord2).w,d0
	andi.w	#$FF,d0
	add.w	d0,d0
	move.w	#$34,d3
	bra.w	.snext
.shift
	move.w	-2(a3,d3.w),d1
	move.w	d1,(a3,d3.w)
.snext
	subq.w	#2,d3
	cmp.w	d0,d3
	ble.w	.sput
	bra.s	.shift
.sput
	move.w	(a2)+,d1
	move.w	d1,(a3,d3.w)
	adda.w	#$34,a3
	dbf	d6,.stat
	jsr	(WriteTeamPlayerStats).l
	move.w	#3,d6
.lines
	bsr.w	FixLinesInserted
	dbf	d6,.lines
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#ThreeStars,a0
	move.w	(TradeToTeam).w,d7
	move.w	d7,d0
	asl.w	#5,d0
	ext.l	d0
	addi.l	#SRJerseyNums,d0
	moveq	#$20,d1
	movem.l	d0-d1/a0,-(sp)
	jsr	(ReadSRAM).l
	move.w	(TempWord2).w,d0
	andi.w	#$FF,d0
	move.w	#$19,d1
.jersey
	cmp.w	d0,d1
	beq.w	.jput
	move.b	-1(a0,d1.w),d2
	move.b	d2,(a0,d1.w)
	dbf	d1,.jersey
.jput
	move.b	(jerseynum).w,(a0,d1.w)
	movem.l	(sp)+,d0-d1/a0
	jsr	(WriteSRAM).l
	movem.l	(sp)+,d0-d7/a0-a6
	move.w	(TempWord2).w,d0
	andi.w	#$FF,d0
	move.w	(TradeToTeam).w,d7
	jsr	(FixJerseyNumber).l
.injury
	move.w	(TempWord2).w,d1
	andi.w	#$FF,d1
	move.w	(TradeToTeam).w,d7
	jsr	(InsertInjurySlot).l
	movea.l	(sp)+,a2
	adda.l	#$E,a2
	move.w	(a2),d0
	jsr	(SetInjuryGames).l
	bclr	#7,(GameFlags).w
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

TradeCountOffsets2	;As TradeCountOffsets, for InsertTradedPlayer
	dc.w	$34,$36,$35

FixLinesInserted	;Fix saved line block d6 of team TradeToTeam after an inserted player: slots at or after him up one
	movea.l	#TeamRecordSRAM,a0
	move.w	d6,d2
	asl.w	#3,d2
	move.l	(a0,d2.w),d0
	move.l	4(a0,d2.w),d1
	move.w	(TradeToTeam).w,d2
	mulu.w	d1,d2
	add.l	d2,d0
	movea.l	#ThreeStars,a0
	jsr	(ReadSRAM).l
	cmpi.b	#$64,-1(a0,d1.w)
	bne.w	.exit
	movem.l	d0-d1/a0,-(sp)
	subq.w	#2,d1
	move.w	(TempWord2).w,d3
	andi.w	#$FF,d3
	addq.w	#1,d3
.slot
	cmp.b	(a0,d1.w),d3
	bgt.w	.next
	addq.b	#1,(a0,d1.w)
.next
	dbf	d1,.slot
	movem.l	(sp)+,d0-d1/a0
	jsr	(WriteSRAM).l
.exit
	rts

TradePlayers	;Trade Player screen: the two rosters with position / rating; A team, B cancel, C choose player, start checks
	;the trade (CheckTrade) and goes on to TradeDone
	jsr	(forceblack).l
	bsr.w	TradeGfx
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),$9,$2,'Trade Player',$0
	clr.w	(TradeData+$4).l
	clr.w	(TradeData+$8).l
	move.w	#5,(TradeData+$6).l
	move.w	#5,(TradeData+$A).l
	clr.w	(TradeData+$C).l
	clr.w	(TradeData).l
	clr.w	(TradeData+$2).l
	jsr	(clearTeamStats).l
	move.w	(HomeTeam).w,d7
	movea.l	#TradeRoster1,a0
	movea.l	#TradeWork,a1
	btst	#3,(sflags10).w
	bne.w	.vis
	bsr.w	BuildTradeRoster
	bsr.w	rtsTrade
.vis
	movea.l	#TradeRoster2,a0
.1
	movea.l	#TradeWork+$6,a1
	move.w	(VisTeam).w,d7
	bclr	#3,(sflags10).w
	bne.w	.drawn
	bsr.w	BuildTradeRoster
	bsr.w	rtsTrade
.drawn
	move.w	#$18,(palcount).w
	bclr	#2,(disflags).w
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$0,$0,$0
	bsr.w	DrawHomeTradeRoster
	bsr.w	DrawVisTradeRoster
	move.w	#$FFFF,(setupdir).w
.redraw
	move.w	(HomeTeam).w,d1
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$8,$6,$0
	bsr.w	DrawTradeLogo
	move.w	(VisTeam).w,d1
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$8,$10,$0
	bsr.w	DrawTradeLogo
	jsr	(printsmallz).l
	String	CC_SetFont,$2,CC_SetX,$15,CC_SetY,$7,'POSITION',CC_SetX,$1F,'RATING'
	jsr	(printsmallz).l
	String	CC_SetFont,$2,CC_SetX,$15,CC_SetY,$11,'POSITION',CC_SetX,$1F,'RATING'
	jsr	(printsmallz).l
	dc.w	$16	;String length
	dc.b	$F9,$1,$FD,$4,$FC,$19,'A',$FD
	dc.b	$C,'B',$FD,$16,'C',$FD,$1F,'Start'
	jsr	(printsmallz).l
	dc.w	$26	;String length
	dc.b	$FD,$2,$FC,$1A,'Team',$FD,$A,'Cancel'
	dc.b	$FD,$14,'Player',$FD,$1E,'Evaluate',$F9,$0
.input
	cmpi.w	#$FFFF,(setupdir).w
	beq.w	.read
	bsr.w	DrawHomeTradeRoster
	bsr.w	DrawVisTradeRoster
.read
	move.w	#$FFFF,(setupdir).w
	bsr.w	ReadTradePads
	tst.w	d1
	beq.w	TradeExit
	move.w	#$FFFF,(setupdir).w
	btst	#7,d1
	bne.w	.evaluate
	btst	#5,d1
	bne.w	.mark
	btst	#6,d1
	bne.w	.switch
	btst	#0,d1
	bne.w	.up
	btst	#1,d1
.6
	bne.w	.down
.7
	btst	#4,d1
	beq.s	.input
.8
	bra.w	TradeExit
.down
	movea.l	#TradeData+$4,a0
	movea.l	#TradeData+$6,a1
.10
	movea.l	#TradeData,a2
	move.w	(TradeWork+$4).l,d3
	tst.w	(TradeData+$C).l
	beq.w	.chkdown
	movea.l	#TradeData+$8,a0
	movea.l	#TradeData+$A,a1
	movea.l	#TradeData+$2,a2
	move.w	(TradeWork+$A).l,d3
.chkdown
	subq.w	#1,d3
	cmpi.w	#5,(a2)
	blt.w	.curdown
	cmp.w	(a1),d3
	beq.w	.input
	addq.w	#1,(a0)
	addq.w	#1,(a1)
	bra.w	.moved
.curdown
	addq.w	#1,(a2)
.moved
	move.w	#1,(setupdir).w
	bra.w	.input
.up
	movea.l	#TradeData+$4,a0
	movea.l	#TradeData+$6,a1
	movea.l	#TradeData,a2
	tst.w	(TradeData+$C).l
	beq.w	.chkup
	movea.l	#TradeData+$8,a0
	movea.l	#TradeData+$A,a1
	movea.l	#TradeData+$2,a2
.chkup
	tst.w	(a2)
	bne.w	.curup
	tst.w	(a0)
	beq.w	.input
	subq.w	#1,(a0)
	subq.w	#1,(a1)
	bra.w	.movedup
.curup
	subq.w	#1,(a2)
.movedup
	move.w	#0,(setupdir).w
	bra.w	.input
.switch
	move.w	#6,(setupdir).w
	eori.w	#1,(TradeData+$C).l
	bra.w	.input
.mark
	move.w	#5,(setupdir).w
	move.w	(TradeData).l,d0
	add.w	(TradeData+$4).l,d0
	movea.l	#TradeRoster1,a0
	tst.w	(TradeData+$C).l
	beq.w	.toggle
	move.w	(TradeData+$2).l,d0
	add.w	(TradeData+$8).l,d0
	movea.l	#TradeRoster2,a0
.toggle
	asl.w	#2,d0
	eori.b	#1,(a0,d0.w)
	bra.w	.input
.evaluate
	bsr.w	CheckTrade
	bne.w	TradeDone
	move.w	#7,(setupdir).w
	bra.w	.redraw

DrawHomeTradeRoster	;Draw the roster of HomeTeam with the chosen marks; falls into DrawTradeRosterRows
	move.w	(TradeData).l,d5
	tst.w	(TradeData+$C).l
	beq.w	.0
	move.w	#$FFFF,d5
.0
	movea.l	#TradeData+$4,a5
	movea.l	#TradeRoster1,a4
	move.w	#9,(printy).w
	move.w	(HomeTeam).w,d7
	bra.w	DrawTradeRosterRows

DrawVisTradeRoster	;Draw the roster of VisTeam with the chosen marks
	move.w	(TradeData+$2).l,d5
	tst.w	(TradeData+$C).l
	bne.w	.0
	move.w	#$FFFF,d5
.0
	movea.l	#TradeData+$8,a5
	movea.l	#TradeRoster2,a4
	move.w	#$13,(printy).w
	move.w	(VisTeam).w,d7

DrawTradeRosterRows	;Draw the roster rows of team d7 (name, position, rating), * for the chosen players
	move.w	(printy).w,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$0,$0,$0
	move.w	(sp)+,(printy).w
	clr.w	d6
	move.w	(a5),d0
	asl.w	#2,d0
	ext.l	d0
	adda.l	d0,a4
.row
	jsr	(printsmallz).l
	String	CC_SetX,$0,'                                       ',$0
	move.w	#6,(printx).w
	jsr	(printsmallz).l
	String	CC_SetFont,$0
	cmp.w	d5,d6
	bne.w	.mark
	jsr	(printsmallz).l
	String	CC_SetFont,$1
.mark
	tst.b	(a4)
	beq.w	.name
	jsr	(printsmallz).l
	String	'*',$0
.name
	move.w	#8,(printx).w
	clr.w	d0
	move.b	2(a4),d0
	jsr	(FormatPlayerNameD7).l
	jsr	(printsmall).l
	move.w	#$18,(printx).w
	movea.l	#PositionLetters,a1
	clr.w	d0
	move.b	1(a4),d0
	jsr	(PrintSmallListItem).l
	move.w	#$21,(printx).w
	clr.w	d0
	move.b	3(a4),d0
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	addq.l	#4,a4
	addq.w	#1,(printy).w
	addq.w	#1,d6
	cmp.w	#6,d6
	blt.w	.row
	rts

PositionLetters	;G, F, D
	String	'G',$0
	String	'F',$0
	String	'D',$0

ReadTradePads	;Wait up to $5460 frames for a pad 1 / 2 press (ProcessInputWithRepeat), d1 = buttons
	move.l	#$5460,d6
.wait
	move.w	(vcount).w,d1
	sub.w	(oldvcount).w,d1
	beq.s	.wait
	move.w	(vcount).w,(oldvcount).w
	jsr	(ReadJoy1).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.pad2
	bra.w	.exit
.pad2
	jsr	(ReadJoy2).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.next
	bra.w	.exit
.next
	dbf	d6,.wait
.exit
	rts

TradeDone	;After a trade: rebuild both teams' trade lists (BuildTradeList) and go to EvaluateTrade
	jsr	(forceblack).l
	movea.l	#tradeteam1,a1
	movea.l	#TradeRoster1,a2
	move.w	(HomeTeam).w,d7
	move.w	(TradeWork+$4).l,d6
	bsr.w	BuildTradeList
	movea.l	#tradeteam2,a1
	movea.l	#TradeRoster2,a2
	move.w	(VisTeam).w,d7
	move.w	(TradeWork+$A).l,d6
	bsr.w	BuildTradeList
	jmp	EvaluateTrade

TradeExit	;Leave the trade screen: set setupcardflags bit 6 and go to Opening2
	bset	#6,(setupcardflags).w
	jmp	(Opening2).l

CheckTrade	;Check the trade: players chosen on both teams, at most three a team, and after it each team has 17-25 players,
	;2-3 goalies, 9-15 forwards and 6-15 defensemen; else INVALID TRADE with the reason (InvalidTradeText). Z clear
	;when valid
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#StatWork,a0
	movea.l	#TradeRoster1,a1
	move.w	(TradeWork+$4).l,d0
	bsr.w	CountChosen
	movea.l	#StatWork+$A,a0
	movea.l	#TradeRoster2,a1
	move.w	(TradeWork+$A).l,d0
	bsr.w	CountChosen
	clr.w	d0
	move.w	#5,d1
	movea.l	#StatWork,a0
.sum
	add.w	(a0)+,d0
	dbf	d1,.sum
	tst.w	d0
	bne.w	.chk
	move.w	#0,(StatWork+$14).w
	bra.w	.invalid
.oneside
	move.w	#2,(StatWork+$14).w
	bra.w	.invalid
.toomany
	move.w	#3,(StatWork+$14).w
	bra.w	.invalid
.chk
	move.w	(StatWork).w,d0
	add.w	(StatWork+2).w,d0
	add.w	(SeasonGameCount).w,d0
	cmp.w	#3,d0
	bgt.s	.toomany
	move.w	(StatWork+$A).w,d0
	add.w	(StatWork+$C).w,d0
	add.w	(StatWork+$E).w,d0
	cmp.w	#3,d0
	bgt.s	.toomany
	move.w	(StatWork).w,d0
	add.w	(StatWork+2).w,d0
	add.w	(SeasonGameCount).w,d0
	beq.s	.oneside
	move.w	(StatWork+$A).w,d0
	add.w	(StatWork+$C).w,d0
	add.w	(StatWork+$E).w,d0
	beq.s	.oneside
	move.w	(TradeWork+$4).l,d0
	sub.w	(StatWork).w,d0
	sub.w	(StatWork+2).w,d0
	sub.w	(SeasonGameCount).w,d0
	add.w	(StatWork+$A).w,d0
	add.w	(StatWork+$C).w,d0
	add.w	(StatWork+$E).w,d0
	cmp.w	#$19,d0
	ble.w	.chkmin
.counts
	move.w	#1,(StatWork+$14).w
	bra.w	.invalid
.chkmin
	cmp.w	#$11,d0
	bge.w	.chkpos
	bra.s	.counts
.chkpos
	move.w	(TradeWork).l,d0
	sub.w	(StatWork).w,d0
	add.w	(StatWork+$A).w,d0
	cmp.w	#2,d0
	blt.s	.counts
	cmp.w	#3,d0
	bgt.s	.counts
	move.w	(TradeWork+$6).l,d0
	sub.w	(StatWork+$A).w,d0
	add.w	(StatWork).w,d0
	cmp.w	#2,d0
	blt.s	.counts
	cmp.w	#3,d0
	bgt.s	.counts
	move.w	(TradeWork+$2).l,d0
	sub.w	(TradeWork).l,d0
	sub.w	(StatWork+2).w,d0
	add.w	(StatWork+$C).w,d0
	cmp.w	#9,d0
	blt.s	.counts
	cmp.w	#$F,d0
	bgt.s	.counts
	move.w	(TradeWork+$8).l,d0
	sub.w	(TradeWork+$6).l,d0
	sub.w	(StatWork+$C).w,d0
	add.w	(StatWork+2).w,d0
	cmp.w	#9,d0
	blt.w	.counts
	cmp.w	#$F,d0
	bgt.w	.counts
	move.w	(TradeWork+$4).l,d0
	sub.w	(TradeWork+$2).l,d0
	sub.w	(SeasonGameCount).w,d0
	add.w	(StatWork+$E).w,d0
	cmp.w	#6,d0
	blt.w	.counts
	cmp.w	#$F,d0
	bgt.w	.counts
	move.w	(TradeWork+$A).l,d0
	sub.w	(TradeWork+$8).l,d0
	sub.w	(StatWork+$E).w,d0
	add.w	(SeasonGameCount).w,d0
	cmp.w	#6,d0
	blt.w	.counts
	cmp.w	#$F,d0
	bgt.w	.counts
	bra.w	.valid
.invalid
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$5,$A,$0
	move.w	#$1E,d0
	move.w	#$E,d1
	jsr	(Framer).l
	jsr	(printsmallz).l
	String	CC_SetFont,$3,CC_SetX,$D,CC_SetY,$B,'INVALID  TRADE'
	move.w	(StatWork+$14).w,d0
	movea.l	#InvalidTradeText,a1
	jsr	(PrintSmallListItem).l
	bsr.w	ReadTradePads
	move.w	#$7FF,d2
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$5,$A,$0
	move.w	#$1E,d0
	move.w	#$E,d1
	jsr	(eraser).l
	bra.w	.fail
.valid
	move.w	#1,d0
	bra.w	.done
.fail
	clr.w	d0
.done
	movem.l	(sp)+,d0-d7/a0-a6
	rts

CountChosen	;Count the chosen players of a trade list by position into the three words at a0
	clr.w	(a0)
	clr.w	2(a0)
	clr.w	4(a0)
	subq.w	#1,d0
.player
	tst.b	(a1)
	beq.w	.next
	tst.b	1(a1)
	beq.w	.goalie
	cmpi.b	#1,1(a1)
	beq.w	.fwd
	addq.w	#1,4(a0)
	bra.w	.next
.fwd
	addq.w	#1,2(a0)
	bra.w	.next
.goalie
	addq.w	#1,(a0)
.next
	tst.l	(a1)+
	dbf	d0,.player
	rts

InvalidTradeText	;INVALID TRADE reasons (PrintSmallListItem)
	String	$FD,$6,$FC,$D,'* No players chosen.'

TradeRulesText	;The roster rules text
	dc.w	$7A	;String length
	dc.b	$FD,$6,$FC,$D,'All teams must have:',$FA,$1,$FD
	dc.b	$6,'* 17 to 25 players.',$FA,$1,$FD,$6,'*  2 to  3 goalies.',$FA
	dc.b	$1,$FD,$6,'*  9 to 15 forwards.',$FA,$1,$FD,$6
	dc.b	'*  6 to 15 defensemen.'
	String	$FD,$6,$FC,$D,'* No players chosen on one',$FA,$1,$FD,$8,'team.',$0
	String	$FD,$6,$FC,$D,'* More than three players',$FA,$1,$FD,$8,'chosen on a team.'

BuildTradeList	;Trade list of team d7: the chosen players ($FFFF = none)
	move.w	d7,(a1)+
	move.w	#$FFFF,(a1)
	move.w	#$FFFF,2(a1)
	move.w	#$FFFF,4(a1)
	subq.w	#1,d6
.player
	tst.b	(a2)
	beq.w	.next
	clr.w	d0
	move.b	2(a2),d0
	move.w	d0,(a1)+
.next
	tst.l	(a2)+
	dbf	d6,.player
	rts

TradeGfx	;Trade screen video set up and graphics
	move.l	#VBlank_SetOptions,(vbint).w
	move	#$2500,sr
	bclr	#0,(disflags).w
	bset	#2,(disflags).w
	bclr	#1,(disflags).w
	move.w	#0,(VSCRLPM).w
	move.w	#$B400,(VSPRITES).w
	move.w	#$B800,(VmMap3).w
	move.w	#5,(Map3col1).w
	move.w	#$C000,(VmMap2).w
	move.w	#6,(Map2col1).w
	move.w	#$E000,(VmMap1).w
	move.w	#6,(Map1col1).w
	move.w	#0,d0
	jsr	(setVram).l
	jsr	(orjoy).l
	move.w	#1,d4
	move.w	d4,(smallfontchars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$23,$44,$67,$89,$AB,$CD,$EF
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$23,$4C,$67,$89,$AB,$CD,$EF
	move.w	d4,(smallfont3chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$23,$47,$67,$89,$AB,$CD,$EF
	move.w	d4,(smallfont4chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$BB,$23,$44,$67,$89,$AB,$CD,$EF
	move.l	#SmallFontMap,(smallfontptr).l
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$67,$89,$AB,$CD,$EF
	move.w	d4,(teamblocksmapptr).w
	movea.l	#Teamblocksmap+8,a2
	jsr	(DecompressGraphicsPlain).l
	movea.l	#CreateFramerMap+8,a2
	move.l	#CreateFramerMap,(framermapptr).l
	move.w	d4,(framercset).w
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$67,$89,$AB,$CD,$EF
	jsr	(printz).l
	String	-TXMAP2,$0,$0,$0
	movea.l	#TradeBgMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#$1C,d3
	moveq	#$F,d5
	jsr	(dobitmap).l
	rts

DrawTradeLogo	;Draw the team block of team d1
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d0
	asl.w	#1,d1
	move.w	(teamblocksmapptr).w,d4
	movea.l	#Teamblocksmap,a0
	movea.l	a0,a1
	adda.l	(a0),a0
	adda.l	4(a1),a1
	movea.l	#SeasonZero,a2
	move.w	(a1),d2
	moveq	#2,d3
	moveq	#0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

BuildTradeRoster	;Trade roster a0 of team d7: per player a chosen flag, position, number and overall rating (CalcAttrib,
	;AttribAdjust when out); the goalie / defense start / player counts at a1
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(GetGoalieCountD7).l
	move.w	d0,(a1)
	jsr	(GetDefenseStartD7).l
	move.w	d0,2(a1)
	jsr	(GetPlayerCountD7).l
	move.w	d0,4(a1)
	subq.w	#1,d0
	movea.l	a0,a2
	clr.w	d1
.player
	clr.l	(a2)
	move.b	d1,2(a2)
	move.w	#0,d3
	cmp.w	(a1),d1
	blt.w	.pos
	move.w	#1,d3
	cmp.w	2(a1),d1
	blt.w	.pos
	move.w	#2,d3
.pos
	move.b	d3,1(a2)
	movem.l	d0-d1/d4,-(sp)
	move.l	a2,-(sp)
	clr.w	d0
	move.b	2(a2),d0
	move.w	d0,(screenarg).w
	movea.l	#tmstruct,a2
	cmp.w	(HomeTeam).w,d7
	beq.w	.team
	movea.l	#AwShots,a2
.team
	move.l	(PAttribOverallMask).l,d4
	tst.w	d3
	bne.w	.calc
	move.l	(GAttribOverallMask).l,d4
.calc
	jsr	(CalcAttrib).l
	mulu.w	#$64,d0
	divu.w	d1,d0
	movem.l	d0,-(sp)
	move.w	(screenarg).w,d0
	jsr	(SeasonPlayerOut).l
	movem.l	(sp)+,d0
	beq.w	.store
	jsr	(AttribAdjust).l
.store
	movea.l	(sp)+,a2
	move.b	d0,3(a2)
	movem.l	(sp)+,d0-d1/d4
	tst.l	(a2)+
	addq.w	#1,d1
	dbf	d0,.player
	movem.l	(sp)+,d0-d7/a0-a6
	rts

rtsTrade	;rts
	rts

EvaluateTrade	;Evaluate Trade screen (GMDecisionGfx): the chosen players of both teams; A cancel, B modify, C execute,
	;start propose (GMDecisionScreen)
	jsr	(forceblack).l
	jsr	(GMDecisionGfx).l
	jsr	(printsmallz).l
	String	CC_SetFont,$1,CC_SetX,$1,CC_SetY,$19,'     A        B         C       Start',$0
	jsr	(printsmallz).l
	String	CC_SetFont,$1,CC_SetX,$1,CC_SetY,$1A,'   Cancel   Modify   Execute   Propose'
.0
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),$6,$2,'Evaluate Trade',$0
	move.w	#$18,(palcount).w
	bclr	#2,(disflags).w
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$0,$0,$0
	jsr	(printsmallz).l
	String	CC_SetFont,$0,CC_SetX,$F,CC_SetY,$9
	movea.l	#TradeRoster1,a0
.1
	move.w	(TradeWork+$4).l,d3
.2
	move.w	(HomeTeam).w,d7
.3
	bsr.w	PrintTradeNames
	jsr	(printsmallz).l
	String	CC_SetFont,$0,CC_SetX,$F,CC_SetY,$13
.4
	movea.l	#TradeRoster2,a0
.5
	move.w	(TradeWork+$A).l,d3
	move.w	(VisTeam).w,d7
	bsr.w	PrintTradeNames
.input
	bsr.w	ReadEvalTradePads
	tst.w	d1
	beq.w	.exit
	btst	#7,d1
.7
	bne.w	.propose
	btst	#6,d1
	bne.w	.cancel
	btst	#4,d1
	bne.w	.modify
	btst	#5,d1
	bne.w	.execute
	bra.s	.input
.execute
	jsr	(forceblack).l
	jsr	(ExecuteTrade).l
.exit
	bset	#6,(setupcardflags).w
	jmp	(Opening2).l
.modify
	bset	#3,(sflags10).w
	jmp	TradePlayers
.cancel
	bra.s	.exit
.propose
	jmp	GMDecisionScreen

PrintTradeNames	;Print the chosen players of a trade list with their position
	subq.w	#1,d3
.player
	tst.b	(a0)
	beq.w	.next
	move.w	#$F,(printx).w
	clr.w	d0
	move.b	2(a0),d0
	jsr	(FormatPlayerNumInitialD7).l
	jsr	(printsmall).l
	move.w	#$20,(printx).w
	movea.l	#PositionLetters2,a1
	clr.w	d0
	move.b	1(a0),d0
	jsr	(PrintSmallListItem).l
	move.w	#$23,(printx).w
	clr.w	d0
	move.b	3(a0),d0
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	addq.w	#1,(printy).w
.next
	tst.l	(a0)+
	dbf	d3,.player
	rts

PositionLetters2	;G, F, D
	String	'G',$0
	String	'F',$0
	String	'D',$0

ReadEvalTradePads	;Wait for a pad 1 / 2 press (ProcessInputWithRepeat), d1 = buttons; the frame count is reset every frame, so
	;there is no timeout
	move.l	#$5460,d6
.wait
	move.w	#$64,d6
	move.w	(vcount).w,d1
	sub.w	(oldvcount).w,d1
	beq.s	.wait
	move.w	(vcount).w,(oldvcount).w
	jsr	(ReadJoy1).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.pad2
	bra.w	.exit
.pad2
	jsr	(ReadJoy2).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.next
	bra.w	.exit
.next
	dbf	d6,.wait
.exit
	rts

GMDecisionGfx	;The trade graphics (TradeGfx), the GM decision bitmap, both team logos with their palettes and team blocks
	jsr	(TradeGfx).l
	jsr	(printz).l
	String	-TXMAP2,$E,$10,$0
	movea.l	#GMDecisionMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
	move.w	d4,(TradeToTeam).w
	jsr	(printz).l
	String	-(TXPRI+TXPAL2+TXMAP2),$8,$8,$0
	movea.l	#TeamLogoBitmaps,a0
	move.w	(HomeTeam).w,d0
	asl.w	#2,d0
	movea.l	(a0,d0.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#3,d0
	movea.l	#TeamLogoPalettes,a0
	subi.w	#$40,d0
	adda.w	d0,a0
	adda.l	(a2)+,a1
	clr.w	d1
	clr.w	d0
	moveq	#6,d2
	move.w	#6,d3
	moveq	#4,d5
	jsr	(dobitmap).l
	movea.l	#palfadenew+$40,a0
	movea.l	#palfadenew+$60,a1
	move.w	#7,d0
.pal
	move.l	(a0)+,(a1)+
	dbf	d0,.pal
	jsr	(printz).l
	String	-(TXPRI+TXPAL3+TXMAP2),$8,$12,$0
	movea.l	#TeamLogoBitmaps,a0
	move.w	(VisTeam).w,d0
	asl.w	#2,d0
	movea.l	(a0,d0.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#3,d0
	subi.w	#$40,d0
	movea.l	#TeamLogoPalettes,a0
	adda.w	d0,a0
	adda.l	(a2)+,a1
	clr.w	d1
	clr.w	d0
	moveq	#6,d2
	move.w	#6,d3
	moveq	#4,d5
	jsr	(dobitmap).l
	move.w	(HomeTeam).w,d1
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$8,$6,$0
	bsr.w	DrawTradeLogo
	move.w	(VisTeam).w,d1
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$8,$10,$0
	bsr.w	DrawTradeLogo
	rts

GMDecisionScreen	;GM DECISION: rate both sides (TradeValue); a difference of 2 or more shows the ADVANTAGE team and start
	;executes the trade, else start just leaves; B back to TradePlayers
	jsr	(CreateScreenGfx).l
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),$B,$2,'GM DECISION'
	jsr	(printsmallz).l
	String	CC_SetFont,$1,CC_SetX,$8,CC_SetY,$1A,'B=Modify',CC_SetX,$12,'Start=Continue'
	jsr	(printsmallz).l
	String	CC_SetFont,$2,CC_SetX,$12,CC_SetY,$8,'FOR',$0
	move.w	(HomeTeam).w,d1
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$4,$5,$0
	bsr.w	DrawTradeLogo
	move.w	(VisTeam).w,d1
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$17,$5,$0
	bsr.w	DrawTradeLogo
	movea.l	#TradeRoster1,a0
	move.w	(TradeWork+$4).l,d3
	move.w	(HomeTeam).w,d7
	bsr.w	TradeValue
	move.w	d0,(TempWord1).w
.0
	movea.l	#TradeRoster2,a0
	move.w	(TradeWork+$A).l,d3
	move.w	(VisTeam).w,d7
	bsr.w	TradeValue
.1
	move.w	d0,(TempWord2).w
.2
	sub.w	(TempWord1).w,d0
	bpl.w	.diff
	neg.w	d0
.diff
	clr.w	(rosterteam).w
	cmp.w	#2,d0
	blt.w	.even
	st	(rosterteam).w
	move.w	(StatWork+$3C).w,d4
	jsr	(printz).l
	String	-TXMAP1,$0,$B,$0
	movea.l	#TradeAdvantageMap1,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$13,d2
	moveq	#7,d3
	moveq	#0,d5
	jsr	(dobitmap).l
	move.w	(HomeTeam).w,d7
	move.w	(TempWord2).w,d0
	cmp.w	(TempWord1).w,d0
	bgt.w	.winner
	move.w	(VisTeam).w,d7
.winner
	jsr	(printsmallz).l
	String	CC_SetFont,$0,CC_SetX,$9,CC_SetY,$11,'ADVANTAGE',CC_AddY,$1,CC_SetX,$9,$0
	movea.l	#TeamList,a1
	asl.w	#2,d7
	movea.l	(a1,d7.w),a1
	adda.w	4(a1),a1
	jsr	(printsmall).l
	bra.w	.players
.even
	move.w	(StatWork+$3C).w,d4
	jsr	(printz).l
	String	-TXMAP1,$0,$B,$0
	movea.l	#TradeAdvantageMap2,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$13,d2
	moveq	#7,d3
	moveq	#0,d5
	jsr	(dobitmap).l
.players
	jsr	(printsmallz).l
	String	CC_SetFont,$0,CC_SetX,$4,CC_SetY,$8
	movea.l	#tradeteam1,a0
	bsr.w	PrintTradedPlayers
	jsr	(printsmallz).l
	String	CC_SetFont,$0,CC_SetX,$17,CC_SetY,$8
	movea.l	#tradeteam2,a0
	bsr.w	PrintTradedPlayers
	move.w	#$18,(palcount).w
	bclr	#2,(disflags).w
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$0,$0,$0
.input
	bsr.w	ReadGMDecisionPads
	tst.w	d1
	beq.w	.exit
	btst	#7,d1
	bne.w	.execute
	btst	#4,d1
	beq.s	.input
	bset	#3,(sflags10).w
	jmp	TradePlayers
.execute
	tst.w	(rosterteam).w
	bmi.w	.exit
	jsr	(forceblack).l
	jsr	(ExecuteTrade).l
.exit
	bset	#6,(setupcardflags).w
	jmp	(Opening2).l

PrintTradedPlayers	;Print the players of a trade list (up to 3)
	move.w	(printx).w,-(sp)
	move.w	(a0)+,d7
	move.w	#2,d6
.player
	move.w	(a0)+,d0
	bmi.w	.done
	andi.w	#$FF,d0
	jsr	(FormatPlayerInitialD7).l
	jsr	(printsmall).l
	addq.w	#1,(printy).w
	move.w	(sp),(printx).w
	dbf	d6,.player
.done
	move.w	(sp)+,(printx).w
	rts

ReadGMDecisionPads	;Wait for a pad press (pads 3, 4 with FourWayPlay), d1 = buttons; no timeout, as ReadEvalTradePads
	move.l	#$5460,d6
.wait
	move.w	#$64,d6
	move.w	(vcount).w,d1
	sub.w	(oldvcount).w,d1
	beq.s	.wait
	move.w	(vcount).w,(oldvcount).w
	jsr	(ReadJoy1).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.pad2
	bra.w	.exit
.pad2
	jsr	(ReadJoy2).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.chkfour
	bra.w	.exit
.chkfour
	tst.w	(FourWayPlay).w
	beq.w	.next
	jsr	(ReadJoy3).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.pad4
	bra.w	.exit
.pad4
	jsr	(ReadJoy4).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.next
	bra.w	.exit
.next
	dbf	d6,.wait
.exit
	rts

TradeValue	;d0 = trade value of the d3 players at a0: each rating (byte 3) mapped through TradeRatingSteps / TradeRatingValues
	subq.w	#1,d3
	clr.w	d0
.player
	tst.b	(a0)
	beq.w	.next
	move.b	3(a0),d1
	movea.l	#TradeRatingSteps,a1
	movea.l	#TradeRatingValues,a2
	clr.w	d4
.step
	cmp.b	(a1,d4.w),d1
	blt.w	.value
	addq.w	#1,d4
	bra.s	.step
.value
	move.b	(a2,d4.w),d4
	ext.w	d4
	add.w	d4,d0
.next
	tst.l	(a0)+
	dbf	d3,.player
	rts

TradeRatingSteps	;Rating steps
	dc.b	$32,$3C,$46,$50,$5A,$60,$65

TradeRatingValues	;Trade value of each rating step
	dc.b	1,3,4,6,8,$A,$C

getplayernameD7	;a0 = the name of player d0 on team d7
	movem.l	d0/d7/a2,-(sp)
	jsr	(GetRosterName).l
	movea.l	a1,a0
	movem.l	(sp)+,d0/d7/a2
	rts


FormatPlayerNameD7	;FormatPlayerName for team d7
	movem.l	d0-d3/d7-a0/a2,-(sp)
	bsr.w	getplayernameD7
	move.l	a0,-(sp)
	movea.w	#(TextBuffer-M68K_RAM),a1
	adda.w	(a0),a0
	jsr	(GetJerseyNumber).l
	move.b	(jerseynum).w,d0
	jsr	(ConvertByteToDigits).l
	move.b	#$20,(a1)+
	movea.l	(sp)+,a0
	move.w	(a0)+,d0
	lea	-2(a0,d0.w),a2
.skipfirst
	cmpi.b	#$20,(a0)+
	bne.s	.skipfirst
.copy
	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	bne.s	.copy
	jsr	(FinalizeTextBuffer).l
	movem.l	(sp)+,d0-d3/d7-a0/a2
	rts


GetGoalieCountD7	;d0 = goalies on team d7: from the season data in save RAM (SRRosters+$34 + team * $38), or with sflags11 bit 6 from the team data nibbles
	btst	#6,(sflags11).w
	bne.w	.teamdata
	movem.l	d1-d7/a0,-(sp)
	move.w	d7,d0
	mulu.w	#$38,d0
	addi.l	#SRRosters+$34,d0
	moveq	#1,d1
	movea.l	#SRAMbyte,a0
	jsr	(ReadSRAM).l
	clr.w	d0
	move.b	(a0),d0
	movem.l	(sp)+,d1-d7/a0
	rts
.teamdata
	movem.l	d1/d7-a0,-(sp)
	movea.l	#TeamList,a0
	asl.w	#2,d7
	movea.l	(a0,d7.w),a0
	adda.w	$A(a0),a0
	move.w	(a0),d1
	clr.w	d0
.count
	addq.w	#1,d0
	asl.w	#4,d1
	bne.s	.count
	movem.l	(sp)+,d1/d7-a0
	rts


GetDefenseStartD7	;GetDefenseStart for team d7
	jsr	(GetGoalieCountD7).l
	move.w	d0,-(sp)
	jsr	(GetForwardCountD7).l
	add.w	(sp)+,d0
	rts


GetForwardCountD7	;d0 = forwards on team d7 from the season data (save RAM SRRosters+$36 + team * $38)
	movem.l	d1-d7/a0,-(sp)
	move.w	d7,d0
	bra.w	GetForwardCountSeason


GetPlayerCountD7	;d0 = players on team d7: in a season (sflags11 bit 6 clear) the sum of three save RAM bytes
	;(ReadSRAM at $1B80 + $38 * team), else from the roster in TeamList (records until a length word of 2)
	btst	#6,(sflags11).w
	bne.w	.0
	movem.l	d1-d7/a0,-(sp)
	move.w	d7,d0
	mulu.w	#$38,d0
	addi.l	#SRRosters+$34,d0
	moveq	#3,d1
	movea.l	#SRAMbyte,a0
	jsr	(ReadSRAM).l
	clr.w	d0
	move.b	(a0)+,d0
	add.b	(a0)+,d0
	add.b	(a0)+,d0
	movem.l	(sp)+,d1-d7/a0
	rts
.0
	movem.l	d7-a0,-(sp)
	movea.l	#TeamList,a0
	asl.w	#2,d7
	movea.l	(a0,d7.w),a0
	adda.w	(a0),a0
	clr.w	d0
.1
	addq.w	#1,d0
	adda.w	(a0),a0
	addq.w	#8,a0
	cmpi.w	#2,(a0)
	bne.s	.1
	movem.l	(sp)+,d7-a0
	rts


CheckSavedLines	;CheckTeamLines for tradeteam1 and tradeteam2. Called from the trade code
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(tradeteam1).w,d7
	bsr.w	CheckTeamLines
	move.w	(tradeteam2).w,d7
	bsr.w	CheckTeamLines
	movem.l	(sp)+,d0-d7/a0-a6
	rts


CheckTeamLines	;Check the saved lines of team d7 in the 4 TeamRecordSRAM records ($64 marks a valid one): each slot
	;with bit 7 set is refilled by LineSlotFixTbl (slot & 7), then written back (WriteSRAM, MakeSRAMChecksum)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#3,d6
.rec
	movea.l	#TeamRecordSRAM,a0
	move.w	d6,d2
	asl.w	#3,d2
	move.l	(a0,d2.w),d0
	move.l	4(a0,d2.w),d1
	move.w	d1,(gameclock).w
	move.w	d7,d2
	mulu.w	d1,d2
	add.l	d2,d0
	movea.l	#ThreeStars,a0
	movem.l	d0-d1/a0,-(sp)
	jsr	(ReadSRAM).l
	cmpi.b	#$64,-1(a0,d1.w)
	bne.w	.invalid
	clr.w	d5
	subq.w	#2,d1
.slot
	tst.b	(a0,d5.w)
	bpl.w	.nextslot
	move.w	d5,d4
	andi.w	#7,d4
	asl.w	#2,d4
	movea.l	#LineSlotFixTbl,a2
	movea.l	(a2,d4.w),a2
	jsr	(a2)
.nextslot
	addq.w	#1,d5
	dbf	d1,.slot
	movem.l	(sp)+,d0-d1/a0
	jsr	(WriteSRAM).l
.nextrec
	dbf	d6,.rec
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.invalid
	movem.l	(sp)+,d0-d1/a0
	bra.s	.nextrec


ReadTeamPlayerStats	;Read the five stat blocks (goals, assists, shots, games played, penalty minutes) of team d7 to a0, $34 bytes each
	;playoff blocks with SeasonDay bit 5
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d7,d0
	mulu.w	#$34,d0
	move.l	d0,-(sp)
	btst	#5,(SeasonDay+1).w
	beq.w	.0
	addi.l	#SRPOGoals,d0
	bra.w	.1
.0
	addi.l	#SRGoals,d0
.1
	movea.l	#StatBuf,a0
	moveq	#$34,d1
	jsr	(ReadSRAM).l
	move.l	(sp),d0
	btst	#5,(SeasonDay+1).w
	beq.w	.2
	addi.l	#SRPOAssists,d0
	bra.w	.3
.2
	addi.l	#SRAssists,d0
.3
	adda.w	#$34,a0
	jsr	(ReadSRAM).l
	move.l	(sp),d0
	btst	#5,(SeasonDay+1).w
	beq.w	.4
	addi.l	#SRPOShots,d0
	bra.w	.5
.4
	addi.l	#SRShots,d0
.5
	adda.w	#$34,a0
	jsr	(ReadSRAM).l
	move.l	(sp),d0
	btst	#5,(SeasonDay+1).w
	beq.w	.6
	addi.l	#SRPOGamesPlayed,d0
	bra.w	.7
.6
	addi.l	#SRGamesPlayed,d0
.7
	adda.w	#$34,a0
	jsr	(ReadSRAM).l
	move.l	(sp)+,d0
	btst	#5,(SeasonDay+1).w
	beq.w	.8
	addi.l	#SRPOPenMin,d0
	bra.w	.9
.8
	addi.l	#SRPenMin,d0
.9
	adda.w	#$34,a0
	jsr	(ReadSRAM).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts


WriteTeamPlayerStats	;Write the five stat blocks of team d7 from a0 (as ReadTeamPlayerStats)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d7,d0
	mulu.w	#$34,d0
	move.l	d0,-(sp)
	btst	#5,(SeasonDay+1).w
	beq.w	.0
	addi.l	#SRPOGoals,d0
	bra.w	.1
.0
	addi.l	#SRGoals,d0
.1
	movea.l	#StatBuf,a0
	moveq	#$34,d1
	jsr	(WriteSRAM).l
	move.l	(sp),d0
	btst	#5,(SeasonDay+1).w
	beq.w	.2
	addi.l	#SRPOAssists,d0
	bra.w	.3
.2
	addi.l	#SRAssists,d0
.3
	adda.w	#$34,a0
	jsr	(WriteSRAM).l
	move.l	(sp),d0
	btst	#5,(SeasonDay+1).w
	beq.w	.4
	addi.l	#SRPOShots,d0
	bra.w	.5
.4
	addi.l	#SRShots,d0
.5
	adda.w	#$34,a0
	jsr	(WriteSRAM).l
	move.l	(sp),d0
	btst	#5,(SeasonDay+1).w
	beq.w	.6
	addi.l	#SRPOGamesPlayed,d0
	bra.w	.7
.6
	addi.l	#SRGamesPlayed,d0
.7
	adda.w	#$34,a0
	jsr	(WriteSRAM).l
	move.l	(sp)+,d0
	btst	#5,(SeasonDay+1).w
	beq.w	.8
	addi.l	#SRPOPenMin,d0
	bra.w	.9
.8
	addi.l	#SRPenMin,d0
.9
	adda.w	#$34,a0
	jsr	(WriteSRAM).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts


MarkSeasonRosters	;Set bit 15 of every player's goals and shots words in save RAM, for all $1A teams (all on the roster)
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d7
	movea.l	#SaveRAM+2*SRGoals,a0
	movea.l	#SaveRAM+2*SRShots,a1
.loop
	jsr	(GetGoalieCountD7).l
	subq.w	#1,d0
	clr.w	d1
.loop2
	move.w	(a0,d1.w),d2
	ori.w	#$80,d2
	move.w	d2,(a0,d1.w)
	move.w	(a1,d1.w),d2
	ori.w	#$80,d2
	move.w	d2,(a1,d1.w)
	addq.w	#4,d1
	dbf	d0,.loop2
	addq.w	#1,d7
	adda.l	#$68,a0
	adda.l	#$68,a1
	cmp.w	#$1A,d7
	blt.s	.loop
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts


LineSlotFixTbl	;CheckTeamLines slot handlers by slot & 7: goalie (the best one), defense, defense, forward, forward
	;forward, extra, none
	dc.l	.goalie,.defense,.defense,.forward,.forward,.forward,.extra,.none
.goalie
	movem.l	d0-d7/a3,-(sp)
	jsr	(GetGoalieCountD7).l
	subq.w	#1,d0
	move.w	d0,d1
	clr.w	d0
	clr.w	d6
	move.b	#$FF,d4
.grate
	jsr	(GetRosterName).l
	adda.w	(a1),a1
	move.b	1(a1),d3
	andi.w	#$F,d3
	cmp.b	d4,d3
	ble.w	.2
	move.w	d0,d6
	move.b	d3,d4
.2
	addq.w	#1,d0
	dbf	d1,.grate
	addq.w	#1,d6
	move.b	d6,(a0,d5.w)
	movem.l	(sp)+,d0-d7/a3
	rts
.none
	clr.b	(a0,d5.w)
	rts
.defense
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#6,(sflags6).w
	jsr	(GetPlayerCountD7).l
	move.w	d0,d2
	jsr	(GetDefenseStartD7).l
	clr.w	d1
	movea.l	#linemarkbuf,a1
.dcand
	cmp.w	d0,d2
	ble.w	.dpick
	btst	#6,(sflags6).w
	bne.w	.dadd
	bsr.w	.inlines
	beq.w	.dnext
.dadd
	move.b	d0,(a1)+
	addq.w	#1,d1
.dnext
	addq.w	#1,d0
	bra.s	.dcand
.dpick
	tst.w	d1
	bne.w	.dbest
	bset	#6,(sflags6).w
	bra.w	.dany
.dbest
	movea.l	#linemarkbuf,a1
	subq.w	#1,d1
	bmi.w	.dany
	clr.w	d4
	move.b	#$FF,d3
.drate
	move.b	(a1,d1.w),d0
	ext.w	d0
	movem.l	d6/a1,-(sp)
	jsr	(GetRosterName).l
	adda.w	(a1),a1
	move.b	1(a1),d2
	andi.w	#$F,d2
	move.b	2(a1),d6
	lsr.b	#4,d6
	andi.b	#$F,d6
	add.b	d6,d2
	move.b	3(a1),d6
	lsr.b	#4,d6
	andi.b	#$F,d6
	add.b	d6,d2
	move.b	4(a1),d6
	lsr.b	#4,d6
	andi.b	#$F,d6
	add.b	d6,d2
	movem.l	(sp)+,d6/a1
	cmp.b	d3,d2
	ble.w	.11
	move.w	d0,d4
	move.b	d2,d3
.11
	dbf	d1,.drate
	addq.b	#1,d4
	move.b	d4,(a0,d5.w)
	bra.w	.ddone
.dany
	jsr	(GetDefenseStartD7).l
.dtry
	addq.w	#1,d0
	movem.w	d1/d5,-(sp)
	andi.w	#$FFF8,d5
	move.w	#7,d1
.dline
	cmp.b	(a0,d5.w),d0
	beq.w	.15
	addq.w	#1,d5
	dbf	d1,.dline
.15
	tst.w	d1
	movem.w	(sp)+,d1/d5
	bpl.s	.dtry
	move.b	d0,(a0,d5.w)
.ddone
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.inlines
	movem.l	d0-d2/a0,-(sp)
	move.w	(gameclock).w,d1
	subq.w	#2,d1
	addq.b	#1,d0
.search
	cmp.b	(a0,d1.w),d0
	beq.w	.found
	dbf	d1,.search
	move.w	#1,d0
.found
	movem.l	(sp)+,d0-d2/a0
	rts
.forward
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#6,(sflags6).w
	jsr	(GetDefenseStartD7).l
	move.w	d0,d2
	jsr	(GetGoalieCountD7).l
	clr.w	d1
	movea.l	#linemarkbuf,a1
.fcand
	cmp.w	d0,d2
	ble.w	.fpick
	btst	#6,(sflags6).w
	bne.w	.fadd
	bsr.s	.inlines
	beq.w	.fnext
.fadd
	move.b	d0,(a1)+
	addq.w	#1,d1
.fnext
	addq.w	#1,d0
	bra.s	.fcand
.fpick
	tst.w	d1
	bne.w	.fbest
	bset	#6,(sflags6).w
	bra.w	.fany
.fbest
	movea.l	#linemarkbuf,a1
	subq.w	#1,d1
	bmi.w	.fany
	clr.w	d4
	move.b	#$FF,d3
.frate
	move.b	(a1,d1.w),d0
	ext.w	d0
	movem.l	d6/a1,-(sp)
	jsr	(GetRosterName).l
	adda.w	(a1),a1
	move.b	1(a1),d2
	andi.w	#$F,d2
	move.b	2(a1),d6
	andi.b	#$F,d6
	add.b	d6,d2
	move.b	2(a1),d6
	lsr.b	#4,d6
	andi.b	#$F,d6
	move.b	5(a1),d6
	andi.b	#$F,d6
	add.b	d6,d2
	move.b	5(a1),d6
	lsr.b	#4,d6
	andi.b	#$F,d6
	add.b	d6,d2
	movem.l	(sp)+,d6/a1
	cmp.b	d3,d2
	ble.w	.27
	move.w	d0,d4
	move.b	d2,d3
.27
	dbf	d1,.frate
	addq.b	#1,d4
	move.b	d4,(a0,d5.w)
	bra.w	.fdone
.fany
	jsr	(GetGoalieCountD7).l
.ftry
	addq.w	#1,d0
	movem.w	d1/d5,-(sp)
	andi.w	#$FFF8,d5
	move.w	#7,d1
.fline
	cmp.b	(a0,d5.w),d0
	beq.w	.31
	addq.w	#1,d5
	dbf	d1,.fline
.31
	tst.w	d1
	movem.w	(sp)+,d1/d5
	bpl.s	.ftry
	move.b	d0,(a0,d5.w)
.fdone
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.extra
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(GetGoalieCountD7).l
.xtry
	bsr.w	.inlines
	bne.w	.xset
	addq.w	#1,d0
	bra.s	.xtry
.xset
	addq.w	#1,d0
	move.b	d0,(a0,d5.w)
	movem.l	(sp)+,d0-d7/a0-a6
	rts

GetForwardCountSeason	;Shared tail of GetForwardCountD7: forwards byte of team d0
	mulu.w	#$38,d0
	addi.l	#SRRosters+$36,d0
	moveq	#1,d1
	movea.l	#SRAMbyte,a0
	jsr	(ReadSRAM).l
	clr.w	d0
	move.b	(a0),d0
	movem.l	(sp)+,d1-d7/a0
	rts

FormatPlayerInitialD7	;a1 = mesarea "F. Last" for player d0 of team d7
	movem.l	d0-d3/d7-a0/a2,-(sp)
	bsr.w	getplayernameD7
	move.l	a0,-(sp)
	movea.w	#(TextBuffer-M68K_RAM),a1
	adda.w	(a0),a0
	movea.l	(sp)+,a0
	move.w	(a0)+,d0
	lea	-2(a0,d0.w),a2
	move.b	(a0)+,(a1)+
	move.b	#$2E,(a1)+
	move.b	#$20,(a1)+
.skipfirst
	cmpi.b	#$20,(a0)+
	bne.s	.skipfirst
.copy
	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	bne.s	.copy
	jsr	(FinalizeTextBuffer).l
	movem.l	(sp)+,d0-d3/d7-a0/a2
	rts


FormatPlayerNumInitialD7	;FormatPlayerNumInitial for team d7
	movem.l	d0-d3/d7-a0/a2,-(sp)
	bsr.w	getplayernameD7
	bra.w	NumInitialBody


GoalieCountHook	;GetGoalieCount: saved roster when sflags11 bit 6 is clear, else the team-data nibbles
	btst	#6,(sflags11).w
	bne.w	.rom
	move.w	Xvel(a2),d7
	jmp	(GetGoalieCountD7).l
.rom
	movem.l	d1/a0,-(sp)
	movea.l	tmdata(a2),a0
	adda.w	$A(a0),a0
	move.w	(a0),d1
	clr.w	d0
.count
	addq.w	#1,d0
	asl.w	#4,d1
	bne.s	.count
	movem.l	(sp)+,d1/a0
	rts

DefenseStartHook	;GetDefenseStart: saved roster when sflags11 bit 6 is clear, else goalies plus the forward nibble
	btst	#6,(sflags11).w
	bne.w	.rom
	move.w	Xvel(a2),d7
	jmp	(GetDefenseStartD7).l
.rom
	movem.l	a0,-(sp)
	jsr	(GetGoalieCount).l
	move.w	d0,-(sp)
	movea.l	tmdata(a2),a0
	adda.w	8(a0),a0
	move.b	3(a0),d0
	lsr.w	#4,d0
	andi.w	#$F,d0
	add.w	(sp)+,d0
	movem.l	(sp)+,a0
	rts

ForwardCountHook	;GetForwardCount: saved roster when sflags11 bit 6 is clear, else the team-data nibble
	btst	#6,(sflags11).w
	bne.w	.rom
	move.w	Xvel(a2),d7
	jmp	(GetForwardCountD7).l
.rom
	movem.l	a0,-(sp)
	movea.l	tmdata(a2),a0
	adda.w	8(a0),a0
	move.b	3(a0),d0
	lsr.w	#4,d0
	andi.w	#$F,d0
	movem.l	(sp)+,a0
	rts

PlayerCountHook	;GetPlayerCount: saved roster when sflags11 bit 6 is clear, else the team-data records
	btst	#6,(sflags11).w
	bne.w	.rom
	move.w	Xvel(a2),d7
	jmp	(GetPlayerCountD7).l
.rom
	movem.l	a0,-(sp)
	movea.l	tmdata(a2),a0
	adda.w	(a0),a0
	clr.w	d0
.loop
	addq.w	#1,d0
	adda.w	(a0),a0
	addq.w	#8,a0
	cmpi.w	#2,(a0)
	bne.s	.loop
	movem.l	(sp)+,a0
	rts

LoadTeamLines	;Line sets of team struct a2 ($16A) from save RAM (SRLines + team * $41) when that copy is valid.
	;Line changes on also falls back to team data when sflags11 bit 6 is set. Jumped to from InitTeamStructure
	tst.w	(OptLine).w
	beq.w	.nolc
	tst.w	(ValidSRAM).w
	bmi.w	.teamdata
	movem.l	d0-d2,-(sp)
	move.l	#SRLines,d0
	move.w	Xvel(a2),d2
	mulu.w	#$41,d2
	add.l	d2,d0
	moveq	#$41,d1
	movea.l	#ThreeStars,a0
	jsr	(ReadSRAM).l
	movem.l	(sp)+,d0-d2
	btst	#6,(sflags11).w
	bne.w	.teamdata
	bra.w	.copy
.teamdata
	movea.l	$1E(a2),a0
	adda.w	6(a0),a0
.copy
	lea	$16A(a2),a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	addq.w	#8,a0
	move.w	#$B,d0
.loop
	move.l	(a0)+,(a1)+
	dbf	d0,.loop
	rts
.nolc
	tst.w	(ValidSRAM).w
	bmi.w	.teamdata2
	movem.l	d0-d2,-(sp)
	move.l	#SRLines,d0
	move.w	Xvel(a2),d2
	mulu.w	#$41,d2
	add.l	d2,d0
	moveq	#$41,d1
	movea.l	#ThreeStars,a0
	jsr	(ReadSRAM).l
	movem.l	(sp)+,d0-d2
	bra.w	.copy2
.teamdata2
	movea.l	$1E(a2),a0
	adda.w	6(a0),a0
.copy2
	moveq	#$D,d0
	addq.w	#8,a0
	lea	$16A(a2),a1
.loop2
	move.l	(a0)+,(a1)+
	dbf	d0,.loop2
	rts

SeasonSetPlayerRecord	;setplayer, saved roster: a0 = the attribute bytes of player d3 on rosterteam, and rostnum is his jersey
	movem.l	d0/d7/a1,-(sp)
	move.w	d3,d0
	move.w	(rosterteam).w,d7
	jsr	(GetRosterName).l
	movea.l	a1,a0
	adda.w	(a0),a0
	addq.w	#8,a0
	movem.l	(sp)+,d0/d7/a1
	subq.w	#8,a0
	movem.w	d0/d7,-(sp)
	move.w	(rosterteam).w,d7
	move.w	d3,d0
	jsr	(GetJerseyNumber).l
	move.b	(jerseynum).w,rostnum(a3)
	movem.w	(sp)+,d0/d7
	rts

SeasonPlayerOut	;Unless sflags11 bit 6: Z set when player d0 of team d7 is out (roster $1E or SRInjuries games left)
	btst	#6,(sflags11).w
	bne.w	.exit
	movem.l	d0/d7-a0,-(sp)
	move.w	d0,d4
	move.w	d7,d5
	asl.w	#2,d4
	ext.l	d4
	movea.l	#SaveRAM+2*SRRosters,a0
	move.w	d5,d6
	mulu.w	#$38,d6
	move.l	d6,d7
	add.l	d7,d7
	add.l	d4,d7
	move.w	(a0,d7.l),d0
	andi.w	#$1F,d0
	cmp.w	#$1E,d0
	beq.w	.out
	move.w	d4,d1
	lsr.w	#2,d1
	move.w	d5,d7
	jsr	(GetInjuryGames).l
	tst.w	d0
	beq.w	.in
.out
	moveq	#0,d0
	tst.b	d0
	movem.l	(sp)+,d0/d7-a0
	rts
.in
	moveq	#1,d0
	tst.b	d0
	movem.l	(sp)+,d0/d7-a0
.exit
	rts

NumInitialBody	;Shared body of FormatPlayerNumInitial
	move.l	a0,-(sp)
	movea.w	#(TextBuffer-M68K_RAM),a1
	adda.w	(a0),a0
	jsr	(GetJerseyNumber).l
	move.b	(jerseynum).w,d0
	jsr	(ConvertByteToDigits).l
	move.b	#$20,(a1)+
	movea.l	(sp)+,a0
	move.w	(a0)+,d0
	lea	-2(a0,d0.w),a2
	move.b	(a0)+,(a1)+
	move.w	#$2E20,(a1)+
.skipfirst
	cmpi.b	#$20,(a0)+
	bne.s	.skipfirst
.copy
	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	bne.s	.copy
	jsr	(FinalizeTextBuffer).l
	movem.l	(sp)+,d0-d3/d7-a0/a2
	rts


DefaultLineData	;Copy each club's default lines into the save-RAM line block
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#M68K_RAM+SRLines,a0
	movea.l	#TeamList,a3
	move.w	#$1B,d1
	clr.w	d7
.team
	move.w	d7,d0
	asl.w	#2,d0
	movea.l	(a3,d0.w),a1
	adda.w	6(a1),a1
	move.w	#7,d2
.set
	move.b	(a1)+,(a0)+
	move.b	(a1)+,(a0)+
	move.b	(a1)+,(a0)+
	move.b	(a1)+,(a0)+
	move.b	(a1)+,(a0)+
	move.b	(a1)+,(a0)+
	move.b	(a1)+,(a0)+
	move.b	(a1)+,(a0)+
	dbf	d2,.set
	move.b	#$64,(a0)+
	addq.w	#1,d7
	dbf	d1,.team
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SeasonZero	;empty tile list for a team block with no picture
	dc.l	0

GMDecisionMap
	incbin	..\Extracted\NHL94\Season\GMDecisionMap.map.jim
	even
FreeAgentMap1
	incbin	..\Extracted\NHL94\Season\FreeAgentMap1.map.jim
	even
FreeAgentMap2
	incbin	..\Extracted\NHL94\Season\FreeAgentMap2.map.jim
	even
TradeAdvantageMap1
	incbin	..\Extracted\NHL94\Season\TradeAdvantageMap1.map.jim
	even
TradeAdvantageMap2
	incbin	..\Extracted\NHL94\Season\TradeAdvantageMap2.map.jim
	even
