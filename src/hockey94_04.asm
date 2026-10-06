;	NHL 94 (retail) segment $1454A-$150E3
;	92 hockey.asm part 2, second half, as 93 hockey93_04.asm: checkfight (an rts in 94; 93 SetInst is gone), checkwallcoll2,
;	checkgoal (with the 93 Goal code as .goal), setass, GetPeriodTimeRemaining, checkgoalp, CheckBump, wallcollb2, wallcoll,
;	checkpuckcoll_sfx and checkpuckcoll. puckstick (hockey94_05) follows at $150E4 (bsr.w displacement at $14EC8).
;	Transcribed from lst/nhl94.bin.lst lines 49543-50531. Global names are the IDA names, or the 93 name where IDA has an auto
;	name (IDA name in an ;IDA: comment). IDA _sfx (before checkpuckcoll, entered from it) is the global checkpuckcoll_sfx.
;	Local labels are the IDA local names (_x -> .x) or the IDA address (loc_14592 -> .14592).
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi;
;	fixopcodes.js patches the cmp encoding after assembly.
;	Sort struct (SortCords, $80 each): 0 Xpos, 4 attribute, 6 frame, $14 Ypos, $18 Zpos, $1C OldXpos, $20 OldYpos,
;	$24 OldZpos, $28 Xvel, $2A Yvel, $2C Zvel, $32 impact, $34 position, $4E wallcos, $50 wallsin, $52 SCnum, $58 SPA,
;	$5E nopuck (byte), $62 pflags, $63 pflags2, $64 bit 3 one-timer, bit 4 wall collision, $68 Agl, $76 handedness.
;	94 team struct from HmShots / AwShots (tmsize $364): $C tmscore, $18-$1C scorer and assists, $22 tmsort, $24 tmap,
;	$26 tmgoalie, $B4 / $CE goal / assist bytes per player, $342 goals by period, $356 PP goals, $35A BA goals, $362 SH goals.

checkfight	;94: an rts. 93 checkfight looked for the start of a fight between players a2 and a3 (94 has no fight code). Called from checkcx (hockey94_03)
	rts
checkwallcoll2	;IDA name (93 checkwallcoll). d2/d3 = x/y to test, a3 = object, wcradiusx/wcradiusy = radius. Check the corner circles, the goals
	;(checkgoal with a2 = unk_FFB6CA top, unk_FFB64A bottom) and then the side and end boards. Calls wallcollb2 on a hit, with d0/d1 = cos/sin of
	;the wall. Called from checkcoll (hockey94_03)
	bclr	#4,$64(a3)	;wall collision bit
	move.w	#$88,d4	;92 Sideline (a RAM word); 136
	sub.w	(wcradiusx).w,d4
	move.w	#$12A,d5	;298: end boards
	sub.w	(wcradiusy).w,d5
	movem.w	d2-d5,-(sp)
	neg.w	d4
	neg.w	d5
	addi.w	#$40,d4	;corner circle radius 64
	addi.w	#$40,d5
	cmp.w	d5,d3
	bgt.w	.14592
	cmp.w	d4,d2
	blt.w	.145B4
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.145B4
	movea.w	#(unk_FFB6CA-M68K_RAM),a2
	bsr.w	checkgoal
	bra.w	.145E6
.14592
	neg.w	d5
	cmp.w	d5,d3
	blt.w	.145E6
	cmp.w	d4,d2
	blt.w	.145B4
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.145B4
	movea.w	#(unk_FFB64A-M68K_RAM),a2
	bsr.w	checkgoal
	bra.w	.145E6
.145B4
	sub.w	d4,d2
	sub.w	d5,d3
	move.w	d3,d0
	move.w	d2,d1
	neg.w	d1
	muls.w	d3,d3
	muls.w	d2,d2
	add.l	d2,d3
	cmp.l	#$1000,d3	;inside the corner circle (64*64)
	bls.w	.145E6
	exg	d0,d3
	bsr.w	sroot	;distance from the circle center
	exg	d0,d3
	ext.l	d0
	asl.l	#8,d0
	divs.w	d3,d0
	ext.l	d1
	asl.l	#8,d1
	divs.w	d3,d1
	bsr.w	wallcollb2
.145E6
	movem.w	(sp)+,d2-d5
	move.w	$4E(a3),d0	;wallcos: already hit
	or.w	$50(a3),d0	;wallsin
	bne.w	rtss2
	move.w	#$100,d0
	clr.w	d1
	cmp.w	d5,d3
	bge.w	wallcollb2
	neg.w	d5
	neg.w	d0
	cmp.w	d5,d3
	ble.w	wallcollb2
	exg	d0,d1
	cmp.w	d4,d2
	bge.w	wallcollb2
	neg.w	d4
	neg.w	d1
	cmp.w	d4,d2
	ble.w	wallcollb2
	rts
checkgoal	;look for coll with goal/net. a2 = goal struct, a3 = object, d2/d3 = x/y. A puck under the crossbar hits a post or the net (deflect,
	;sfx $25 or 8 and crowd) or goes in (.goal); a player goes to checkgoalp. Called from checkwallcoll2
	cmpi.w	#$D,$18(a3)	;13 pix for zside = height of goal (puck only check)
	bgt.w	rtss2	;over goal
	cmpi.w	#$E,$52(a3)	;puckSCnum
	bne.w	checkgoalp	;coll with player not puck
	sub.w	(a2),d2	;Xpos
	moveq	#$10,d4	;xside = 16  width of goal/2
	add.w	(wcradiusx).w,d4
	cmp.w	d4,d2
	bgt.w	rtss2
	neg.w	d4
	cmp.w	d4,d2
	blt.w	rtss2
	sub.w	$14(a2),d3	;Ypos
	move.w	#2,d5	;yside = 2 depth of goal/2
	add.w	(wcradiusy).w,d5
	cmp.w	d5,d3
	bgt.w	rtss2
	neg.w	d5
	cmp.w	d5,d3
	blt.w	rtss2
	st	(collflag).w	;inside goal area now
	cmpi.w	#$D,$24(a3)	;compare OldZpos to zside
	blt.w	.nod	;branch if less than (in net)
	move.w	$24(a3),$18(a3)
	bra.w	.deflectz
.nod
	bclr	#7,$62(a3)
	move.w	(puckc).w,d0
	bmi.w	.nocon
	st	(puckc).w
	asl.w	#7,d0
	movea.w	#(SortCords-M68K_RAM),a0
	move.b	#8,$5E(a0,d0.w)
	move.w	(pucky).w,d1
	btst	#7,$62(a0,d0.w)
	bne.w	.an
	neg.w	d1
.an
	tst.w	d1
	bpl.w	.nocon
	bset	#7,$62(a3)
.nocon
	move.w	#$FF00,d0
	move.l	$14(a3),d1
	sub.l	$20(a3),d1
	asr.l	#8,d1
	beq.w	.sideentry
	bmi.w	.0
	neg.w	d0	;check top entry
	neg.w	d5
.0
	add.w	d3,d5
	move.l	(a3),d3
	sub.l	$1C(a3),d3
	asr.l	#8,d3
	muls.w	d3,d5
	divs.w	d1,d5
	bvs.w	.sideentry
	sub.w	d5,d2
	cmp.w	d4,d2
	blt.w	.sideentry
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.sideentry
	clr.w	d1
	move.w	$14(a3),d3
	eor.w	d0,d3
	bmi.w	wallcoll
	neg.w	d0
	btst	#7,$62(a3)
	bne.w	wallcoll
	cmpi.w	#$D,$18(a3)
	beq.w	.deflectsf
	subq.w	#1,d4
	cmp.w	d4,d2
	bgt.w	.deflectsf
	neg.w	d4
	cmp.w	d4,d2
	bge.w	.goal
.deflectsf
	bsr.w	ChkShotStat	;deflection: count the shot
	move.w	#$25,-(sp)	;sfx $25 when the clock is stopped (92 SFXpuckpost = 9)
	btst	#0,(gmode).w	;gmclock: no goal after the whistle
	bne.w	.deflectsf2
	move.w	#8,(sp)	;sfx 8 (92 SFXoooh = 31) and crowd
	addi.w	#$12C,(crowdlevel).w
	addi.w	#$28,(CwdExciteLvl).w
.deflectsf2
	bsr.w	sfx
	move.w	#$1000,d0
	bsr.w	randomd0
	tst.w	$14(a3)
	bmi.w	.df0
	neg.w	d0
.df0
	move.w	d0,$2A(a3)
	move.w	#$1000,d0
	bsr.w	randomd0s
	move.w	d0,$28(a3)
	move.w	#$1000,d0
	bsr.w	randomd0s
	move.w	d0,$2C(a3)
	bra.w	puckflip
.deflectz
	neg.w	$2C(a3)
	bpl.w	rtss2
	neg.w	$2C(a3)
	rts
.sideentry
	clr.w	d0
	move.w	#$100,d1
	move.w	(a3),d2
	sub.w	$1C(a3),d2
	bmi.w	wallcoll
	neg.w	d1
	bra.w	wallcoll
.goal	;93 Goal: puck in goal. 94 first: in a penalty shot or shootout (BA_PS_flags bit 2) only the shooter's end counts (word_FFC2FA bit 0:
	;shootout, word_FFD594 picks the end); it counts the shootout goal (word_FFD574 / word_FFD576) and calls sub_F37C
	btst	#2,(BA_PS_flags).w
	beq.w	.1481E
	btst	#0,(word_FFC2FA).w
	bne.w	.147D8
	movem.l	d0/a0,-(sp)
	move.w	(BA_Sktr_SCnum).w,d0
	asl.w	#7,d0
	movea.l	#SortCords,a0
	adda.w	d0,a0
	btst	#7,$62(a0)
	movem.l	(sp)+,d0/a0
	bne.w	.147E0
	bra.w	.147EC
.147D8
	tst.w	(word_FFD594).w
	bne.w	.147EC
.147E0
	tst.w	(pucky).w
	bmi.w	rtss2
	bra.w	.147F4
.147EC
	tst.w	(pucky).w
	bpl.w	rtss2
.147F4
	bset	#5,(word_FFC2F4).w	;94 only: penalty shot / shootout goal
	tst.w	(word_FFD594).w
	beq.w	.1480A
	addq.w	#1,(word_FFD576).w
	bra.w	.1480E
.1480A
	addq.w	#1,(word_FFD574).w
.1480E
	bset	#0,(byte_FFC2FE).w
	jsr	(sub_F37C).l
	bra.w	.14828
.1481E
	btst	#0,(gmode).w
	bne.w	rtss2
.14828
	bset	#0,(word_FFC2F4).w	;94 only
	bclr	#3,(byte_FFC2FE).w
	bsr.w	ChkShotStat
	bsr.w	sub_1A304	;94 only
	move.w	d0,-(sp)
	move.w	(vcount).w,d0
.14842
	cmp.w	(vcount).w,d0	;wait for the next vblank
	beq.s	.14842
	move.w	(sp)+,d0
	move.w	#0,-(sp)	;SFXsiren (92 same, 0)
	bsr.w	sfx
	jsr	(freezewindow).l
	addi.w	#$1F4,(crowdlevel).w	;add 500 (92 800)
	movea.w	#(HmShots-M68K_RAM),a2
	lea	$364(a2),a1	;tmsize
	tst.w	$14(a3)
	bpl.w	.14870
	exg	a2,a1
.14870
	btst	#1,(gmode).w	;gmdir
	beq.w	.1487C
	exg	a2,a1
.1487C
	addq.w	#1,$C(a2)	;tmscore: add to Goals
	btst	#5,(word_FFC2F4).w	;94 only: goal stats
	beq.w	.14898
	btst	#0,(word_FFC2FA).w	;94: no new assignments in a shootout
	bne.w	.14898
	addq.w	#1,$362(a2)	;add to SH Goals (IDA comment)
.14898
	bclr	#4,(word_FFC2FA).w
	beq.w	.148A6
	addq.w	#1,$35A(a2)	;add to BA Goals (IDA comment)
.148A6
	btst	#5,(sflags2).w	;sf2pwrplay
	beq.w	.148D4
	btst	#6,(sflags2).w	;sf2pwrtm: 0 home, 1 visitors
	bne.w	.148CC
	cmpa.l	#AwShots,a2
	bne.w	.148D4
.148C4
	addq.w	#1,$356(a2)	;power play goals
	bra.w	.148D4
.148CC
	cmpa.l	#HmShots,a2
	beq.s	.148C4
.148D4
	movem.l	d0/a2,-(sp)
	move.w	(gsp).w,d0
	add.w	d0,d0
	adda.w	d0,a2
	addq.w	#1,$342(a2)	;goals by period
	movem.l	(sp)+,d0/a2
	bclr	#7,(byte_FFC2FE).w
	beq.w	.148F6
	addq.w	#1,$35E(a2)	;byte_FFC2FE bit 7 goals
.148F6
	cmpa.w	#(HmShots-M68K_RAM),a2	;home goal: ChooseSong (93 song $30)
	bne.w	.1491E
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#3,(SongIndex).w
	jsr	(ChooseSong).l
	move.w	#$78,(word_FFDECC).w
	move.w	(SongNum).w,-(sp)
	move.w	(sp)+,(word_FFDECE).w
.1491E
	cmpi.w	#$168,(ScoreSumbytes).w	;60 entries of 6 bytes full? (93 $B4, 30)
	bne.w	.1492C
	subq.w	#6,(ScoreSumbytes).w	;overwrite the last entry
.1492C
	movea.w	#(ScoreSum-M68K_RAM),a0
	adda.w	(ScoreSumbytes).w,a0
	addq.w	#6,(ScoreSumbytes).w
	bsr.w	GetPeriodTimeRemaining
	move.w	d0,(a0)+	;entry word 0 = period/time
	moveq	#2,d0
	add.w	$24(a2),d0
	sub.w	$24(a1),d0
	move.b	d0,(a0)+	;byte 2 = 2 + tmap(a2) - tmap(a1)
	addi.w	#$1E,(CwdExciteLvl).w
	cmpa.w	#(HmShots-M68K_RAM),a2
	beq.w	.14964
	subi.w	#$14,(CwdExciteLvl).w	;less for an away goal
	bset	#7,-1(a0)	;byte 2 bit 7 = away team scored
.14964
	move.w	$18(a2),d0	;scorer
	move.b	d0,(a0)+
	move.w	#$FFFF,(a0)	;no assists yet
	addi.w	#$B4,d0
	addq.b	#1,0(a2,d0.w)	;team byte $B4 + scorer +1
	move.w	$1A(a2),d0	;first assist
	bmi.w	.149AA
	cmp.w	$18(a2),d0
	beq.w	.149AA
	move.b	d0,(a0)+
	addi.w	#$CE,d0
	addq.b	#1,0(a2,d0.w)
	move.w	$1C(a2),d0	;second assist
	bmi.w	.149AA
	cmp.w	$18(a2),d0
	beq.w	.149AA
	move.b	d0,(a0)
	addi.w	#$CE,d0
	addq.b	#1,0(a2,d0.w)
.149AA
	move.w	$26(a1),d0	;tmgoalie of the other team
	bmi.w	.149BA
	addi.w	#$B4,d0
	addq.b	#1,0(a1,d0.w)
.149BA
	bsr.w	ChkShotStat
	bsr.w	PenGoalStuff	;penalty94_1 (IDA sub_1284A)
	bclr	#3,(BA_PS_flags).w
	bsr.w	PrintScores1
	move.w	#$2710,(word_FFC304).w	;94 only
	btst	#0,(word_FFC2FA).w
	beq.w	.149E0
	bra.w	.149EA
.149E0
	move.l	#7,d0	;assignment 7 (92 ascore = 8)
	bsr.w	setass
.149EA
	clr.w	(collflag).w
	clr.w	$28(a3)
	clr.w	$2A(a3)
	moveq	#6,d0
	tst.w	(a3)
	bpl.w	.14A00
	neg.w	d0
.14A00
	move.w	d0,(a3)
	move.w	#$110,d0	;92 blueline+goalline+8
	tst.w	$14(a3)
	bpl.w	.14A10
	neg.w	d0
.14A10
	move.w	d0,$14(a3)
	move.w	#$600,$2C(a3)	;Zvel
	clr.w	$18(a3)
	st	(puckcross2).w
	st	(puckcross6).w
	bset	#2,$62(a3)	;pfnc
	move.w	#$1A,d0	;puckunflip (93 pnothing)
	bsr.w	assreplace
	move.l	a3,-(sp)
	adda.w	#$80,a3	;SCstruct
	move.w	#$102E,d1	;siren SPA (92 SPAsiren = $FE8)
	bsr.w	SetSPA
	movea.w	$22(a1),a3	;first sort obj of the other team
	move.l	#$E,d0	;penalty $E (92 PenGoal = 6)
	bsr.w	AddPenalty2
	movea.l	(sp)+,a3
	rts
setass	;IDA name (93 Goal .setass, IDA ResetTeamPlayerAssignments). d0 = assignment, a2 = team. Give each skater of team a2 that is not fighting
	;assignment d0, clear pfnc. 94 also clears $64 bit 3 (one-timer) and then calls sub_FEFF0. Called from checkgoal
	move.l	a3,-(sp)
	movea.w	$22(a2),a3	;tmsort
	moveq	#5,d3
.14A5C
	tst.w	$34(a3)	;position
	ble.w	.14A88
	btst	#0,$63(a3)	;pf2fight
	bne.w	.14A88
	bclr	#2,$62(a3)	;pfnc
	bclr	#3,$64(a3)	;94 only
	beq.w	.14A84
	jsr	(sub_FEFF0).l
.14A84
	bsr.w	assinsert
.14A88
	adda.w	#$80,a3
	dbf	d3,.14A5C
	movea.l	(sp)+,a3
	rts
GetPeriodTimeRemaining	;IDA: sub_14A94 (93 name). Return d0 = (gsp << 14 | PerTimeTotal) - gameclock. Called from checkgoal (ScoreSum entry) and InProgress (penalty94_1)
	move.w	(gsp).w,d0
	swap	d0
	clr.w	d0
	lsr.l	#2,d0	;gsp in bits 14-15
	or.w	(PerTimeTotal).w,d0
	sub.w	(gameclock).w,d0
	rts
checkgoalp	;check for player a3 collision with goal/net a2. Entered from checkgoal. Oval goal; skipped for no player coll (pflags2 bit 5), a high
	;player or a non-player. CheckBump, then wallcoll with word_FFC2F8 bit 4 set (no wall collision bit)
	btst	#5,$63(a3)	;pflags2 bit 5: no player coll
	bne.w	rtss2
	cmpi.w	#$A,$18(a3)	;Zpos
	bgt.w	rtss2
	cmpi.w	#$B,$52(a3)	;SCnum: players only
	bgt.w	rtss2
	movem.w	d2-d3,-(sp)
	sub.w	$14(a2),d3
	move.w	d3,d0
	sub.w	(a2),d2
	move.w	d2,d1
	neg.w	d0
	asl.w	#4,d2
	muls.w	d2,d2
	divu.w	#$400,d2
	cmp.w	#$100,d2
	bhi.w	.14B32
	asl.w	#4,d3
	muls.w	d3,d3
	divu.w	#$79,d3
	add.w	d2,d3
	cmp.w	#$100,d3
	bhi.w	.14B32
	movem.w	(sp)+,d2-d3
	bsr.w	CheckBump
	movem.w	d2-d3,-(sp)
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	bsr.w	sroot
	move.w	d0,d2
	movem.w	(sp)+,d0-d1
	addq.w	#1,d2
	asl.l	#8,d0
	divs.w	d2,d0
	asl.l	#8,d1
	divs.w	d2,d1
	bset	#4,(word_FFC2F8).w	;wallcoll: do not set the wall collision bit
	bsr.w	wallcoll
	bclr	#4,(word_FFC2F8).w
.14B32
	movem.w	(sp)+,d2-d3
	rts
CheckBump	;supply minimum separation velocity for coll with walls/goal/net. a2 = goal, a3 = player. On one frame in 32, a player near the puck
	;in y moving faster than $2000 knocks the net (a2 gets a quarter of a3's velocity, a3 stops, sfslock) and, while the clock runs, calls penalty
	;8. Called from checkgoalp
	movem.l	d0-d1,-(sp)
	move.w	(VDP_CNTR).l,d0
	andi.w	#$1F,d0
	bne.w	.14B8A
	move.w	(pucky).w,d0
	sub.w	$14(a2),d0
	cmp.w	#$28,d0
	bgt.w	.14B8A
	cmp.w	#$FFD8,d0
	blt.w	.14B8A
	move.w	$28(a3),d0
	move.w	$2A(a3),d1
	cmp.w	#$2000,d0
	bgt.w	.14B90
	cmp.w	#$E000,d0
	blt.w	.14B90
	cmp.w	#$2000,d1
	bgt.w	.14B90
	cmp.w	#$E000,d1
	blt.w	.14B90
.14B8A
	movem.l	(sp)+,d0-d1
	rts
.14B90
	adda.w	#$C,sp	;drop the saved d0-d1 and the return to checkgoalp: return to checkgoal's caller
	asr.w	#2,d0
	asr.w	#2,d1
	move.w	d0,$28(a2)
	move.w	d1,$2A(a2)
	clr.w	$28(a3)
	clr.w	$2A(a3)
	bset	#6,(sflags).w	;sfslock
	btst	#0,(gmode).w	;gmclock
	bne.w	rtss2
	move.l	#8,d0
	bra.w	AddPenalty2
wallcollb2	;IDA name (93 wallcollb). Check for puck over wall. a3 = object, d0/d1 = cos/sin of the wall. Not the puck, or Zpos up to $12:
	;wallcoll. Zpos above $1D, or above $12 with Ypos below $118: out of play. Otherwise only at x $D-$F with Yvel >= $FA0 (else wallcoll): halve
	;Yvel, SPA $1078 on the next struct, sfx $E and crowd, then out of play. Out of play: sfslock, pfnc, and while the clock runs penalty 6
	;(PenOOP) for ltplayer. Called from checkwallcoll2
	cmpi.w	#$E,$52(a3)	;#puckSCnum
	bne.w	wallcoll	;not puck so wall coll
	cmpi.w	#$1D,$18(a3)	;#12*8/3, Zpos
	bgt.w	.0
	cmpi.w	#$12,$18(a3)	;#8*8/3, Zpos
	bls.w	wallcoll
	cmpi.w	#$118,$14(a3)	;#280, Ypos
	blt.w	.0
	cmpi.w	#$D,(a3)	;14, Xpos
	blt.w	wallcoll
	cmpi.w	#$F,(a3)	;15, Xpos
	bgt.w	wallcoll
	cmpi.w	#$FA0,$2A(a3)	;#4000, Yvel
	blt.w	wallcoll
	move.l	a3,-(sp)
	asr.w	$2A(a3)	;Yvel / 2
	adda.w	#$80,a3	;next struct (SCstruct)
	move.w	#$1078,d1
	bsr.w	SetSPA
	movea.l	(sp)+,a3
	move.w	#$E,-(sp)
	bsr.w	sfx
	addi.w	#$258,(crowdlevel).w
	addi.w	#$F,(CwdExciteLvl).w
.0
	bset	#6,(sflags).w	;#sfslock
	bset	#2,$62(a3)	;#pfnc
	tst.w	$14(a3)	;Ypos
	bpl.w	.1
	ori.w	#$8000,4(a3)	;attribute(a3)
.1
	clr.w	$86(a3)	;frame+SCstruct(a3)
	btst	#0,(gmode).w	;#gmclock
	bne.w	rtss2
	move.l	a3,-(sp)
	move.w	(ltplayer).w,d0
	asl.w	#7,d0	;#scsize
	movea.w	#(SortCords-M68K_RAM),a3	;#sortcords
	adda.w	d0,a3
	move.l	#6,d0	;#PenOOP
	bsr.w	AddPenalty2
	movea.l	(sp)+,a3
	rts
wallcoll	;d0 = cosine, d1 = sine of angle of incidence with wall, a3 = object. Bounce a3 off the wall: the puck loses speed, flips and plays
	;sfx $28-$2B; a player sets the wall collision bit (unless word_FFC2F8 bit 4) and plays SFXplayerwall on a hard hit. Called from checkgoal,
	;checkgoalp and wallcollb2
	move.w	d0,$4E(a3)	;wallcos
	move.w	d1,$50(a3)	;wallsin
	movem.l	d2-d3,-(sp)
	movem.w	d0-d1,-(sp)
	muls.w	$2A(a3),d0	;Yvel
	muls.w	$28(a3),d1	;Xvel
	sub.l	d1,d0
	asr.l	#8,d0
	move.w	d0,d2	;v1n
	movem.w	(sp),d0-d1
	muls.w	$28(a3),d0	;Xvel
	muls.w	$2A(a3),d1	;Yvel
	add.l	d1,d0
	asr.l	#8,d0
	move.w	d0,d3	;v1t
	neg.w	d2
	cmpi.w	#$E,$52(a3)	;#puckSCnum, SCnum
	bne.w	.player
	bclr	#4,(sflags2).w	;#sf2shot
	tst.w	d2
	bpl.w	.nocoll
	asr.w	#2,d2	;reduce normal speed on puck
	cmp.w	#$FC00,d2	;#-400
	bgt.w	.pok
	move.w	#$800,d0
	bsr.w	randomd0
	neg.w	d0
	move.w	d0,$2C(a3)	;Zvel
	bsr.w	puckflip
	move.w	d2,d0
	asr.w	#8,d0
	asr.w	#2,d0
	addq.w	#4,d0
	bpl.w	.14CE2
	clr.w	d0
.14CE2
	andi.w	#3,d0
	addi.w	#$28,d0
	move.w	d0,-(sp)
	bsr.w	sfx
.pok
	move.w	d3,d0	;reduce tangent speed on puck
	asr.w	#6,d0
	sub.w	d0,d3
	asr.w	#1,d0
	sub.w	d0,d3
	bra.w	.noadd
.player
	cmp.w	#$3E8,d2	;#1000
	bgt.w	.nocoll
	bclr	#4,(word_FFC2F8).w	;94 only: set by checkgoalp
	bne.w	.14D16
	bset	#4,$64(a3)	;set wall collision bit
.14D16
	cmp.w	#$F000,d2	;$-1000
	bgt.w	.nosfx
	cmpi.w	#$A,$32(a3)	;impact(a3)
	blt.w	.nosfx
	move.w	#$20,-(sp)	;#SFXplayerwall
	bsr.w	sfx
.nosfx
	asr.w	#2,d2
	cmp.w	#$FC7C,d2	;#-900
	blt.w	.noadd
	move.w	#$FC18,d2	;#-1000
.noadd
	movem.w	(sp),d0-d1
	movem.w	d2-d3,-(sp)
	muls.w	d0,d3
	muls.w	d1,d2
	sub.l	d2,d3
	asr.l	#8,d3
	move.w	d3,$28(a3)	;Xvel
	movem.w	(sp)+,d2-d3
	movem.w	(sp),d0-d1
	muls.w	d1,d3
	muls.w	d0,d2
	add.l	d2,d3
	asr.l	#8,d3
	move.w	d3,$2A(a3)	;Yvel
	tst.w	$2C(a3)	;Zvel
	bmi.w	.nocoll
	clr.w	$2C(a3)	;Zvel
.nocoll
	addq.w	#4,sp
	movem.l	(sp)+,d2-d3
	rts
checkpuckcoll_sfx	;IDA: _sfx (a local of wallcoll in IDA, entered from checkpuckcoll; a global so it does not clash with sfx). Puck in the air: sfx 5 once when word_FFC2F4 bit 2 is set
	bclr	#2,(word_FFC2F4).w
	beq.w	rtss2
	move.w	#5,-(sp)
	bra.w	sfx
checkpuckcoll	;look for puck coll with players. a3 = puck. Clears Yvel past the back boards, then walks up and down the OOlist from the puck and
	;runs .ccx on each object within 22 in y: stick (puckstick), body (puckbody) or goalie (puckgoalie). 94: in a penalty shot only the shooter
	;and the goalie touch the puck, and the goalie reach comes from .cbg / .cbgsq by Agl. Entered from pucknorm (logic94_4)
	cmpi.w	#$190,$14(a3)	;compare 190 hex to Ypos (back board?)
	bgt.w	.resetYvel	;branch if greater than
	cmpi.w	#$FE70,$14(a3)	;compare -190 to Ypos (back board?)
	bgt.w	.setup	;branch if greater than
.resetYvel
	clr.w	$2A(a3)	;clear Yvel
.setup
	cmpi.w	#$10,$18(a3)	;compare 10 hex to Zpos (feet in air)
	bgt.s	checkpuckcoll_sfx
	move.w	$52(a3),d0	;move SCnum into d0
	asl.w	#1,d0	;current obj number
	movea.w	#(OOlistpos-M68K_RAM),a0
	movea.w	#(OOlist-M68K_RAM),a1
	movea.w	#(Ylist-M68K_RAM),a2
	move.w	0(a0,d0.w),d1	;current obj position in OOlist
.0
	cmp.w	#$F,d1	;15 = Total sprites -1
	beq.w	.cl	;it is top sprite on screen
	clr.w	d4
	move.b	1(a1,d1.w),d4	;next higher object number
	move.w	0(a2,d4.w),d5	;Y pos of next higher object
	sub.w	$14(a3),d5	;sub Ypos from d5
	cmp.w	#$16,d5	;16 = cbody + cstick
	bgt.w	.cl	;no higher sprite coll
	bsr.w	.ccx
	addq.w	#1,d1
	bra.s	.0
.cl
	move.w	0(a0,d0.w),d1
	beq.w	.ex
.1
	clr.w	d4
	move.b	-1(a1,d1.w),d4	;next lower object number
	move.w	$14(a3),d5	;move Ypos into d5
	sub.w	0(a2,d4.w),d5	;sub Y pos of next lower object
	cmp.w	#$16,d5	;compare cbody+cstick to d5
	bgt.w	.ex
	bsr.w	.ccx
	subq.w	#1,d1
	bne.s	.1
.ex
	rts
.ccx
	movem.l	d0-d7/a0-a3,-(sp)
	lsr.w	#1,d4	;divide by 2
	cmp.w	(puckc).w,d4	;compare puckc to d4
	beq.w	.exit
	cmp.w	#$B,d4	;compare 11 to d4
	bgt.w	.exit
	asl.w	#7,d4	;#scsize
	movea.w	#(SortCords-M68K_RAM),a2
	adda.w	d4,a2	;a2 now has address of player struct
	btst	#2,(BA_PS_flags).w	;check bit 2
	beq.w	.ccx2	;branch if not set
	asr.w	#7,d4	;change d4 back to SCnum of puckc
	cmp.w	(BA_Sktr_SCnum).w,d4	;check d4 with SCnum of breakaway skater
	beq.w	.ccx2	;branch if the same
	cmp.w	(BA_Goalie_SCnum).w,d4	;check d4 with SCnum of breakaway goalie
	bne.w	.exit	;exit if not equal
.ccx2
	btst	#2,$62(a2)	;check if no player collision
	bne.w	.exit	;exit if set
	tst.b	$5E(a2)	;check if nopuck collision
	bne.w	.exit	;branch if nopuck
	btst	#2,$63(a2)	;check if player unavailable
	bne.w	.chkbody	;branch if so
	cmpi.w	#5,$18(a3)	;compare 5 to Zpos
	bgt.w	.chkbody	;branch if higher
	cmpi.w	#$200,$2C(a3)	;compare 200 hex to Zvel
	bgt.w	.chkbody	;branch if higher
	move.l	a2,-(sp)
	bsr.w	GetHot	;Get Hot Spot d0/d1 = x/y
	add.w	(a2),d0	;add Xpos a2
	sub.w	(a3),d0	;sub Xpos a3
	cmp.w	#$E,d0	;compare to cstick (E hex)
	bgt.w	.chkbody	;branch if greater
	cmp.w	#$FFF2,d0	;compare to -cstick
	blt.w	.chkbody	;branch if less than
	add.w	$14(a2),d1	;add Ypos a2
	sub.w	$14(a3),d1	;sub Ypos a3
	cmp.w	#$E,d1	;compare to cstick
	bgt.w	.chkbody	;branch if greater
	cmp.w	#$FFF2,d1	;compare to -cstick
	blt.w	.chkbody	;branch if less than
	muls.w	d0,d0	;square d0
	muls.w	d1,d1	;square d1
	add.l	d1,d0	;add d1 to d0
	move.l	#$C4,d1	;move cstick squared to d1
	tst.b	$5E(a3)	;check nopuck - puck not ready to be caught
	ble.w	.lo	;branch if less than or equal
	lsr.w	#2,d1	;divide d1 by 4
.lo
	cmp.l	d1,d0	;compare d1 to d0
	bhi.w	.chkbody	;branch if higher
	bsr.w	puckstick
	bra.w	.exit
.chkbody
	tst.w	$34(a2)	;check if goalie
	beq.w	.chkgoalie	;branch if goalie
	btst	#3,$64(a2)	;check if doing one timer
	bne.w	.exit	;exit if so
	move.w	(a2),d0	;Xpos into d0
	sub.w	(a3),d0	;sub Xpos a3
	cmp.w	#8,d0	;compare to cbody
	bgt.w	.exit	;exit if greater
	cmp.w	#$FFF8,d0	;compare to -cbody
	blt.w	.exit	;exit if less than
	move.w	$14(a2),d1	;Ypos into d1
	sub.w	$14(a3),d1	;sub Ypos a3
	cmp.w	#8,d1	;compare cbody
	bgt.w	.exit	;exit if greater
	cmp.w	#$FFF8,d1	;compare -cbody
	blt.w	.exit	;exit if less than
	muls.w	d0,d0	;square d0
	muls.w	d1,d1	;square d1
	add.l	d1,d0	;add d1 to d0
	cmp.l	#$40,d0	;compare cbody squared to d0
	bhi.w	.exit	;exit if higher
	bsr.w	puckbody
.14F22	;IDA: loc_14F22 and _exit (two names)
.exit
	movem.l	(sp)+,d0-d7/a0-a3
	rts
.cbg	;IDA: _cbg. Goalie body reach by Agl/2 (words, 0-$1E)
	dc.w	$C	;Agility 0 (rounded down to nearest even number)
	dc.w	$C	;2
	dc.w	$D	;4 (0.8 or 1)
	dc.w	$D	;6
	dc.w	$D	;8
	dc.w	$D	;10 (2 or 2.2)
	dc.w	$D	;12
	dc.w	$D	;14 (2.8 or 3)
	dc.w	$D	;16
	dc.w	$D	;18
	dc.w	$E	;20 (4 or 4.2)
	dc.w	$E	;22
	dc.w	$E	;24
	dc.w	$E	;26
	dc.w	$F	;28
	dc.w	$F	;30 (6)
	dc.w	$F	;32
	dc.w	$F	;34
	dc.w	$F	;36
	dc.w	$F	;38
.cbgsq	;IDA: _cbgsq. Reach squared
	dc.w	$90
	dc.w	$90
	dc.w	$A9
	dc.w	$A9
	dc.w	$A9
	dc.w	$A9
	dc.w	$A9
	dc.w	$A9
	dc.w	$A9
	dc.w	$A9
	dc.w	$C4
	dc.w	$C4
	dc.w	$C4
	dc.w	$C4
	dc.w	$E1
	dc.w	$E1
	dc.w	$E1
	dc.w	$E1
	dc.w	$E1
	dc.w	$E1
.chkgoalie
	move.l	a0,-(sp)	;push on stack
	movea.l	#.cbg,a0
	clr.w	d0
	move.b	$68(a2),d0	;move Agl into d0
	btst	#1,(byte_FFC2FE).w	;check if cwd meter broken (always is)
	bne.w	.boost
	btst	#6,(byte_FFC2FC).w	;check if crowd meter currently broken
	beq.w	.joycont	;branch if not
.boost
	addq.b	#2,d0
.joycont
	lsr.w	#1,d0	;divide by 2
	btst	#3,$62(a2)	;check if joystick controlled
	beq.w	.calcagl	;branch if not
	move.w	#$F,d0	;move F into d0 (remove Agl)
.calcagl
	add.w	d0,d0	;add d0 to itself
	btst	#0,(word_FFC2FA).w	;check if shootout
	beq.w	.maxagl	;branch if not
	tst.w	d0	;check that d0 is 0
	beq.w	.maxagl	;branch if zero
	subq.w	#2,d0	;sub 2 from d0
.maxagl
	cmp.w	#$1E,d0	;compare to 1E
	blt.w	.checkbody	;branch if less than
	move.w	#$1E,d0	;move 1E into d0
.checkbody
	move.w	0(a0,d0.w),(ChkBodyG).w
	movea.l	#.cbgsq,a0
	clr.l	(ChkBodySqG).w
	move.w	0(a0,d0.w),(ChkBodySqG+2).w
	move.w	(ChkBodyG).w,(NegChkBodyG).w
	neg.w	(NegChkBodyG).w
	btst	#1,(word_FFC2F8).w	;check if one timer
	beq.w	.1500A	;branch if not set
	move.w	#$C,(ChkBodyG).w
	move.l	#$90,(ChkBodySqG).w
	move.w	#$FFF4,(NegChkBodyG).w
.1500A
	cmpi.w	#$250,$58(a2)	;check animation (pad stack)
	beq.w	.1501E	;branch if equal
	cmpi.w	#$2A2,$58(a2)	;check animation (pad stack)
	bne.w	.15032	;branch if not equal
.1501E
	move.w	#$12,(ChkBodyG).w
	move.l	#$144,(ChkBodySqG).w
	move.w	#$FFEE,(NegChkBodyG).w
.15032
	movea.l	(sp)+,a0	;pop stack into a0
	cmpi.w	#$F,(puckz).w	;compare F to puckz
	bgt.w	.exit2	;exit if higher
	move.w	(a2),d0	;Xpos into d0
	cmpi.w	#$250,$58(a2)	;compare animation (pad stack)
	beq.w	.neg	;branch if equal
	cmpi.w	#$2A2,$58(a2)	;compare animation (pad stack)
	bne.w	.1507A	;branch if not equal
	move.w	#6,d1	;move 6 into d1
	bra.w	.15060
.neg
	move.w	#$FFFA,d1	;move -6 into d1
.15060
	btst	#7,$62(a2)	;check which goal shooting at
	bne.w	.1506C	;branch if top
	neg.w	d1	;negate d1
.1506C
	btst	#0,$76(a2)	;check bit zero of handedness
	beq.w	.15078	;branch if equal
	neg.w	d1	;negate d1
.15078
	add.w	d1,d0	;add d1 to d0
.1507A
	sub.w	(a3),d0	;sub Xpos a3 from d0
	cmp.w	(ChkBodyG).w,d0	;compare to d0
	bgt.w	.exit2	;exit if greater than
	cmp.w	(NegChkBodyG).w,d0	;compare to d0
	blt.w	.exit2	;exit if less than
	move.w	$14(a2),d1	;move Ypos into d1
	sub.w	$14(a3),d1	;sub Ypos a3 from d1
	cmp.w	(ChkBodyG).w,d1	;compare to d1
	bgt.w	.exit2	;exit if greater
	cmp.w	(NegChkBodyG).w,d1	;compare to d1
	blt.w	.exit2	;exit if less than
	movem.w	d0-d1,-(sp)	;push to stack
	muls.w	d0,d0	;square d0
	muls.w	d1,d1	;square d1
	add.l	d1,d0	;add d1 to d0
	cmp.l	(ChkBodySqG).w,d0	;compare to d0
	movem.w	(sp)+,d0-d1	;pop from stack
	bhi.w	.exit2	;exit if higher
	bsr.w	puckgoalie
	bra.w	.exit
.exit2
	bclr	#2,(word_FFC2F4).w	;clear bit 2
	beq.w	.exit	;exit if it was cleared already
	move.w	(puckc).w,d0	;move puckc into d0
	cmp.w	$52(a2),d0	;compare SCnum to d0
	beq.w	.exit	;branch if equal
	move.w	#5,-(sp)	;sound
	bsr.w	sfx
	bra.w	.exit
