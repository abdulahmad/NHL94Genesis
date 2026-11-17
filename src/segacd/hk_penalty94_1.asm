	include	segacd\hockey.inc
	include	macros\genesis.mac

BA_Checker_Offset	equ	$19370
BA_Goalie_SCnum	equ	$1936A
BA_Sktr_SCnum	equ	$19368
BA_Team	equ	$19366
BigFontMap	equ	$47D38
BigFontchars	equ	$18D40
CC_Font1	equ	$FF
CC_Font1Pri	equ	$BF
Crowdlevel	equ	$17CD2
CwdExciteLvl	equ	$17CD8
ExtraChars	equ	$18D56
LOAD	equ	$1B000
OptPen	equ	$18C08
PenBuf	equ	$18022
PenCntDwn	equ	$18064
PenShotPenalties	equ	$4198A
PenSumLength	equ	$1825A
Penaltylist	equ	$4165C
Penaltytimer	equ	$18066
RefCnt	equ	$1806E
RefMap2	equ	$47D20
RefPen	equ	$18072
RefStep	equ	$18070
RefsMap	equ	$47D1C
SortCords	equ	$17480
TempPlOffset	equ	$180EE
TextBuffer	equ	$17EF4
bfasciicon	equ	$419BA
disflags	equ	$18D64
getGoalieSCnum	equ	$30A70
mesarea	equ	$17EF2
move	equ	$2C9C8
msgtimer	equ	$17F98
penmsgtimer	equ	$1806C
print	equ	$38F80
printa	equ	$18D5C
printm	equ	$18D5E
printx	equ	$18D58
printy	equ	$18D5A
printz	equ	$38F6E
priolist	equ	$41AD6
pspenalty	equ	$19372
puckx	equ	$17B80
pucky	equ	$17B94
sfx	equ	$3710C
stop_current_song	equ	$47DB0
tmstruct	equ	$1834C
updatePPTeamTime	equ	$29FF8
X_1B2E4	equ	$1B2E4
X_1E372	equ	$1E372
X_1E576	equ	$1E576
X_1E584	equ	$1E584
X_1E586	equ	$1E586
X_1EC1C	equ	$1EC1C
X_1ED96	equ	$1ED96
X_1EEE4	equ	$1EEE4
X_1EFE8	equ	$1EFE8
X_1EFEC	equ	$1EFEC
X_2051E	equ	$2051E
X_21000	equ	$21000
X_21666	equ	$21666
X_22754	equ	$22754
X_22770	equ	$22770
X_25AFA	equ	$25AFA

	org	$1E26A

printbig
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movem.l	d0-d7/a0/a2,-(sp)
	move.w	(printx).l,d4
	move.w	(printy).l,d5
	move.w	(printa).l,d6
	add.w	(BigFontchars).l,d6
	move.w	(a1)+,d3
	subi.w	#$2,d3
	bra.w	.l1E30A
.l1E29E	move.b	(a1)+,d0
	beq.w	.l1E30A
	ext.w	d0
	bpl.w	.l1E2EE
	neg.w	d0
	move.w	d0,d6
	asl.w	#$8,d6
	asl.w	#$1,d6
	andi.w	#$F800,d6
	move.w	d6,(printa).l
	add.w	(BigFontchars).l,d6
	andi.w	#$3,d0
	asl.w	#$2,d0
	subi.w	#$4,d0
	move.w	d0,(printm).l
	move.b	(a1)+,d4
	ext.w	d4
	move.w	d4,(printx).l
	move.b	(a1)+,d5
	ext.w	d5
	move.w	d5,(printy).l
	subi.w	#$2,d3
	bra.w	.l1E30A
.l1E2EE	cmpi.b	#$61,d0
	blt.w	.l1E302
	cmpi.b	#$7A,d0
	bgt.w	.l1E302
	addi.b	#$E0,d0
.l1E302	move.w	d3,-(sp)
	bsr.w	PrintBigChar
	move.w	(sp)+,d3
.l1E30A	dbra	d3,.l1E29E
	move.w	d4,(printx).l
	move.w	d5,(printy).l
	movem.l	(sp)+,d0-d7/a0/a2
	move.w	(sp)+,(disflags).l
	rts
PrintBigChar
	subi.w	#$20,d0
	movea.l	#bfasciicon,a0
	moveq	#$1,d2
	move.b	(a0,d0.w),d1
	ext.w	d1
	bpl.w	.l1E340
	neg.w	d1
	clr.w	d2
.l1E340	asl.w	#$1,d1
	movea.l	(BigFontMap).l,a0
	adda.l	$4(a0),a0
.l1E34C	move.w	$4(a0,d1.w),d3
	bsr.w	X_1E372
	move.w	(a0),d7
	asl.w	#$1,d7
	add.w	d7,d1
	move.w	$4(a0,d1.w),d3
	sub.w	d7,d1
	addq.w	#$1,d5
	bsr.w	X_1E372
	subq.w	#$1,d5
	addq.w	#$1,d4
	addq.w	#$2,d1
	dbra	d2,.l1E34C
	rts
	dc.w	$D646,$48E7,$4080,$3005,$207C,$0001,$8D34,$D0F9
	dc.w	$0001,$8D5E,$3228,$0002,$E360,$D044,$E340,$D050
	dc.w	$6100,$F38A,$0839,$0007,$00FF,$800E,$66F6,$33C3
	dc.w	$00FF,$8022,$33FC,$000D,$00FF,$8020,$08F9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9
	dc.w	$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F
	dc.w	$4CDF,$0102,$4E75,$33C4,$0001,$8D42,$2479,$0004
	dc.w	$7D3C,$508A,$6000,$F560,$2479,$0004,$7D10,$508A
	dc.w	$33C4,$0001,$8D4E,$6000,$F54E,$7802,$2479,$0004
	dc.w	$7D44,$508A,$6000,$F540
AddPenalty						;add penalty d0 (Penaltylist offset) for player a3. Ignored while the
									;clock is stopped, when penalties are off, for a player with pflags2 bit 2
									;set, or offsides when offsides are off. Falls into AddPenalty2
	btst	#$0,$17F68.l		;gmclock
	bne.w	X_21000
	cmpi.w	#$C,d0		;icing (92 used 8)
	beq.w	AddPenalty2		;icing is always called
	tst.w	(OptPen).l
	beq.w	X_21000		;penalties off
	btst	#$2,$63(a3)		;pflags2 bit 2, which releasepl sets
	bne.w	X_21000
	btst	#$5,$17F68.l		;gmoffs: offsides on
	bne.w	AddPenalty2
	cmpi.w	#$10,d0		;offsides (92 used $A)
	beq.w	X_21000
AddPenalty2						;forced penalties like face off and game over. d0 = penalty number, a3 =
									;player or player on penalized team. From $E (goal) up: crowd sound. A
									;penalty with minutes sets DelayedPen bit 1 (home) or bit 2 (away)
	btst	#$7,$17F6A.l		;sfhor: nothing in horizontal mode
	bne.w	X_21000
	movem.l	d1/a0-a1,-(sp)
	cmpi.w	#$E,d0		;goal (92 used 6) and up
	blt.w	.nonoise
	addi.w	#$C8,(Crowdlevel).l		;200
	move.w	#$C,-(sp)		;crowd boo sound effect (home team)
	btst	#$6,$62(a3)		;pfteam
	beq.w	.song
	addi.w	#$14,(CwdExciteLvl).l		;visitors: +20 excitement
	move.w	#$B,(sp)		;crowd cheer sound effect
.song	bsr.w	sfx-LOAD
.nonoise	movea.l	#PenBuf,a1
	moveq	#$1F,d1		;MaxPen-1
.0	tst.w	(a1)+		;find free slot
	dbeq	d1,.0		;find a free slot
	bne.w	.noplayer		;buffer full
	move.b	$53(a3),-(a1)		;SCnum+1
	move.b	d0,-(a1)		;and the penalty number (first byte)
	movea.l	#Penaltylist,a0
	adda.w	(a0,d0.w),a0
	tst.b	$1(a0)		;penalty minutes
	beq.w	.noplayer
	bmi.w	.noplayer		;negative minutes too
	btst	#$6,$62(a3)		;pfteam. DelayedPen bit 1 home, bit 2 away
	bne.w	.away
	bset	#$1,$17F7E.l
	bra.w	.setpenflag
.away	bset	#$2,$17F7E.l
.setpenflag	bset	#$4,$63(a3)		;pflags2 bit 4
	beq.w	.noplayer
	clr.w	(a1)		;player already has a penalty, drop this one
.noplayer	movem.l	(sp)+,d1/a0-a1
	rts
	dc.w	$6100,$0A00,$6100,$04B2,$6100,$0006,$6000,$06C2
chkprogress						;control progress of ref and game control thru penalty events. While
									;BA_PS_flags bit 2 is set (penalty shot), bit 7 calls PenaltyShotBox and
									;msgtimer counts down; when it runs out the message area is erased. Then,
									;when the stop delay runs out and a penalty with minutes is in PenBuf,
									;switch to the horizontal rink for the player to enter the penalty box
	btst	#$2,$17F70.l		;to.cont
	beq.w	X_1E586
	btst	#$7,$17F70.l
	bne.w	X_1E576
	tst.w	(msgtimer).l
	bmi.w	X_1E586
	subi.w	#$1,(msgtimer).l
	bpl.w	X_1E584
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#$2,$17F6C.l		;sf2drec
	bclr	#$7,$17F78.l
	bsr.w	printz-LOAD
	String	CC_Font1,$3,$2
	dc.w	$701B,$7208,$0839,$0000,$0001,$7F78,$6700,$0006
	dc.w	$323C,$000C,$243C,$0000,$07FF,$4EB9,$0003,$8C06
	dc.w	$4CDF,$7FFF,$6000,$0010,$4EB9,$0004,$0DFC,$08B9
	dc.w	$0007,$0001,$7F70,$4E75,$0839,$0002,$0001,$7F68
	dc.w	$6700,$2A70,$4A79,$0001,$8064,$6B00,$01D8,$9F79
	dc.w	$0001,$8064,$6A00,$2A5C,$08B9,$0003,$0001,$7F68
	dc.w	$207C,$0001,$8022,$4A58,$6700,$2A48,$4240,$1028
	dc.w	$FFFE,$227C,$0004,$165C,$D2F1,$0000,$4A29,$0001
	dc.w	$6700,$FFE4,$6B00,$FFE0,$08F9,$0002,$0001,$7F6C
	dc.w	$3F39,$0001,$7474,$6100,$D724,$33DF,$0001,$7474
	dc.w	$6100,$2E1A,$3839,$0001,$8D56,$2479,$0004,$7D20
	dc.w	$508A,$6100,$F356,$6100,$36EC,$6100,$3734,$50F9
	dc.w	$0001,$7BE0,$267C,$0001,$7B80,$701A,$6100,$CCBC
	dc.w	$377C,$1C20,$0040,$50F9,$0001,$8070,$4279,$0001
	dc.w	$806E,$6100,$0590,$33FC,$0032,$0001,$806E,$4240
	dc.w	$6100,$06C2,$33FC,$0018,$0001,$8D62,$4E75
PenShotChk						;a3 = checker, a2 = player hit, d0 = penalty. If a2 is on a breakaway ($64
									;bit 1), no penalty shot is pending (BA_PS_flags
									;bit 3) and PenShotPenalties has an entry for d0, getBAplayerInfo sets one
									;up and d0 = that penalty (also pspenalty). Called from CCStart before
									;AddPenalty
	movem.l	d1-d3/a0,-(sp)
	btst	#$1,$64(a2)		;breakaway
	beq.w	.loop
	btst	#$3,$17F70.l		;penalty shot pending
	beq.w	.0
.loop	move.w	#$FFFF,d1
	bra.w	.end
.0	movea.l	#PenShotPenalties,a0
	move.w	(a0,d0.w),d1		;penalty shot penalty for d0, -1 = none
	bmi.w	.end
	move.w	$52(a2),d2		;SCnum
	movem.w	d0-d1,-(sp)
	move.w	d2,d0
	jsr	(getBAplayerInfo+LOAD).l
	movem.w	(sp)+,d0-d1
	bpl.w	.found		;N clear: penalty shot set up
	bclr	#$3,$17F70.l
	bra.w	.loop
.found	move.w	d1,(pspenalty).l
	move.w	d1,d0		;return the penalty shot penalty
.end	movem.l	(sp)+,d1-d3/a0
	rts
getBAplayerInfo						;d0 = SCnum (0-5 home team, 6-11 away team) of the player on the
									;breakaway, a3 = checker. If penalties are on and the other team has a
									;goalie in, set BA_PS_flags bit 3 and save BA_Sktr_SCnum, BA_Team,
									;BA_Goalie_SCnum and the skater, goalie and checker team position offsets
									;(pnum). Returns N clear when the penalty shot is set up
	movem.l	d1-d3/a1,-(sp)
	tst.w	(OptPen).l
	beq.w	.noPen
	bset	#$3,$17F70.l
	movem.w	d0,-(sp)
	move.w	#$5,d1
	move.w	#$0,d2
	cmpi.w	#$5,d0
	bgt.w	.findgoalie		;away player: search the home team for its goalie (d1 = 5), else the
	move.w	#$B,d1
	move.w	#$1,d2
.findgoalie	move.w	d1,d0
	jsr	(getGoalieSCnum).l
	tst.w	d0
	bpl.w	.goaliein		;branch if there's a goalie
	movem.w	(sp)+,d0		;no goalie
	bclr	#$3,$17F70.l
	bra.w	.end
.goaliein	move.w	d0,d1		;d1 = goalie's SCnum
	move.w	(sp)+,d0		;d0 now back to player checked on breakaway SCnum
	move.w	d0,(BA_Sktr_SCnum).l
	movea.l	#SortCords,a1
	move.w	d0,d3
	asl.w	#$7,d3		;scsize
	move.w	#$0,(BA_Team).l
	btst	#$6,$62(a1,d3.w)		;pfteam
	beq.w	.0		;branch if home
	move.w	#$1,(BA_Team).l
.0	move.w	#$0,$1936C.l
	move.b	$66(a1,d3.w),$1936D.l		;store BA player's team position offset
	move.w	d1,(BA_Goalie_SCnum).l
	asl.w	#$7,d1		;scsize
	move.w	#$0,$1936E.l
	move.b	$66(a1,d1.w),$1936F.l		;store goalie's team position offset
	move.w	#$0,(BA_Checker_Offset).l
	move.b	$66(a3),$19371.l		;store checker's team position offset
.end	movem.l	(sp)+,d1-d3/a1
	rts
.noPen	move.w	#$FFFF,d1		;N set: no penalty shot
	bra.w	.end
InProgress						;ref in progress-- update graphics and stats and penalty information.
									;Takes the last PenBuf entry; the first pass logs a penalty
									;with minutes and sends the player to the box, later passes wait until he
									;is off the ice and drop the entry. When PenBuf is empty, recount players
									;and go to the face off, or the penalty shot. Only a 5 minute penalty is
									;matched as coincidental. Entered from chkprogress
	tst.w	(RefCnt).l
	bpl.w	X_21000		;animation in progress
	tst.w	(RefStep).l
	bpl.w	X_21000
	movem.l	d0/a0-a3,-(sp)
.top	movea.l	#PenBuf,a0		;penalty buffer
	tst.w	(a0)+
	beq.w	.4
.0	tst.w	(a0)+		;find end of list
	bne.w	.0		;find end of list
	suba.w	#$4,a0		;a0 = last entry (penalty byte, player byte)
	bclr	#$7,$1(a0)		;player who is guilty
	bne.w	.Sa		;first pass: log it
	move.l	a3,-(sp)
	clr.w	d1
	move.b	$1(a0),d1
	asl.w	#$7,d1		;scsize
	movea.l	#SortCords,a3
	adda.w	d1,a3		;a3 = the player
	tst.w	$34(a3)		;position
	movea.l	(sp)+,a3
	bpl.w	.ex		;still on the ice
	clr.w	(a0)		;gone: remove the entry
	bra.w	.ex
.Sa	clr.w	d0		;first pass: d0 = penalty number
	move.b	(a0),d0
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	bclr	#$5,$17F74.l		;bit 5 = this penalty is 5 minutes
	clr.w	d2
	move.b	$1(a1),d2		;penalty minutes
	beq.w	.sa2		;no player involved
	bmi.w	.sa2		;negative minutes too
	cmpi.b	#$5,d2
	bne.w	.1
	bset	#$5,$17F74.l
.1	movem.l	d0-d1/a1-a4,-(sp)
	bsr.w	X_2051E		;log time, penalty and player
	movea.l	#$1825C,a4
	adda.w	(PenSumLength).l,a4
	cmpi.w	#$EC,(PenSumLength).l		;log full: keep overwriting the last entry
	beq.w	.full
	addi.w	#$4,(PenSumLength).l
.full	move.w	d0,(a4)+		;time
	move.b	(a0),(a4)+		;penalty
	clr.w	d1
	move.b	$1(a0),d1
	asl.w	#$7,d1		;scsize
	movea.l	#SortCords,a3
	adda.w	d1,a3		;a3 = the guilty player
	clr.w	d0		;d0 = player id (bit 15 = visitors)
	movea.l	#tmstruct,a2		;a2 = his team, a1 = the other team
	lea.l	$366(a2),a1		;tmsize: visitors
	btst	#$6,$62(a3)		;pfteam
	beq.w	.2
	bset	#$7,-$1(a4)		;log: visitors
	move.w	#$8000,d0
	exg.l	a1,a2
.2	addi.w	#$1,$6(a2)		;tmPenalties
	add.w	d2,$8(a2)		;tmPenmin
	move.b	$66(a3),d0		;pnum
	move.b	d0,(a4)		;log: player
	move.w	d0,(TempPlOffset).l
	ext.w	d0
	addi.w	#$104,d0		;per-player penalty minutes byte at $102+pnum
	add.b	d2,(a2,d0.w)
	subi.w	#$104,d0
	asl.w	#$1,d0		;d0 = roster offset (player*2) for tmpdst
	ext.w	d2
	mulu.w	#$3C,d2		;60
	bset	#$D,d2		;tmpdst bit 13
	tst.w	$68(a2,d0.w)		;tmpdst
	bmi.w	.3
	btst	#$4,$68(a2,d0.w)
	beq.w	.3
	bset	#$C,d2		;keep byte bit 4 (word bit 12) of an old penalty time
.3	move.w	d2,$68(a2,d0.w)		;store the penalty time (seconds) for this player
	andi.w	#$EFFF,d2		;drop bit 12 for the comparison below
	moveq	#$34,d1		;(MaxRos-1)*2+2
.ctop	subi.w	#$2,d1		;same time on the other team
	bmi.w	.nocoin
	move.w	$68(a1,d1.w),d3
	andi.w	#$EFFF,d3
	cmp.w	d3,d2
	bne.w	.ctop
	btst	#$5,$17F74.l		;coincidental for a 5 minute penalty only
	beq.w	.ctop
	bset	#$6,$68(a1,d1.w)		;coincidental (byte bit 6, word bit 14)
	bset	#$6,$68(a2,d0.w)
.nocoin	movem.l	a0,-(sp)		;add player to penalty box list
	lea.l	$9C(a2),a0		;add player to penalty box list
	moveq	#$18,d1
	tst.b	(a0)+		;find end of list
	dbmi	d1,$1E8E6		;find end of list
	move.b	d0,-$1(a0)		;append the roster offset
	st.b	(a0)		;and a new -1 terminator
	movem.l	(sp)+,a0
	move.w	#$C,d0		;asspenalty
	bsr.w	X_1B2E4		;a3 = the player: send him to the penalty box
	movem.l	(sp)+,d0-d1/a1-a4
	bsr.w	X_1EC1C		;ref animation and message for this penalty
	bsr.w	X_21666		;update the penalty box lines on the score board
	bra.w	.ex
.sa2	clr.w	(a0)		;clear the entry
	btst	#$7,$17F6A.l		;sfhor
	bne.w	.top		;horizontal mode: go on with the next entry
	bsr.w	X_1EC1C
	bra.w	.ex
.4	movea.l	#tmstruct,a2		;home team struct
	bsr.w	InProgress_ap
	adda.w	#$366,a2		;tmsize
	bsr.w	InProgress_ap
	bclr	#$2,$17F68.l		;gmpen
	movea.l	#puckx,a3		;a3 = puck object
	bclr	#$6,$17F70.l
	move.w	#$1B,d0		;puckfaceoff
	btst	#$3,$17F70.l
	beq.w	.5
	move.w	#$1E,d0		;puckshootout: penalty shot
.5	bsr.w	X_1B2E4
.ex	movem.l	(sp)+,d0/a0-a3
	rts
InProgress_ap						;a2 = team. Clears tmpdst bit 5, counts players kept off the ice by
									;penalties (coincidental and bit 4
									;times do not count, at most 2) and sets tmap. Called twice from
									;InProgress
	moveq	#$6,d1		;d1 = players on ice, starts at 6
	moveq	#$32,d0		;(MaxRos-1)*2
.loop	tst.w	$68(a2,d0.w)		;loop over the roster (d0 = player*2, counting down)
	ble.w	.nap		;not in the penalty box
	bclr	#$5,$68(a2,d0.w)		;clear the "just called" bit
	btst	#$6,$68(a2,d0.w)		;coincidental
	bne.w	.nap
	btst	#$4,$68(a2,d0.w)
	bne.w	.nap
	cmpi.w	#$4,d1		;never below 4 players
	beq.w	.nap
	subi.w	#$1,d1		;this player keeps the team one man short
.nap	subi.w	#$2,d0
	bpl.w	.loop
	move.w	d1,$26(a2)		;tmap
	rts
	dc.w	$0839,$0007,$0001,$7F6A,$6600,$264C,$207C,$0001
	dc.w	$8022,$4A58,$6700,$2640,$0839,$0002,$0001,$7F68
	dc.w	$6600,$003C,$4240,$1028,$FFFE,$227C,$0004,$165C
	dc.w	$D2F1,$0000,$4A29,$0001,$6700,$0020,$3039,$0001
	dc.w	$7BE0,$6B00,$0050,$0440,$0006,$1228,$FFFF,$4881
	dc.w	$0441,$0006,$B340,$6B00,$003C,$6100,$0050,$08E8
	dc.w	$0007,$FFFF,$6600,$FFAC,$4240,$1028,$FFFE,$227C
	dc.w	$0004,$165C,$D2F1,$0000,$4241,$1229,$0000,$EB41
	dc.w	$B279,$0001,$8064,$6F00,$FF8A,$33C1,$0001,$8064
	dc.w	$6000,$FF80,$08F9,$0003,$0001,$7F68,$6600,$FF74
	dc.w	$303C,$002C,$6100,$01CC,$6000,$FF68
Stop4Pen						;a0 = penaltylist penalty +2. Stop the clock, set the face off spot from
									;the penalty type, blow the whistle, with stop_current_song before the
									;whistle. Also entered from puckfaceoff
	bset	#$0,$17F68.l		;gmclock
	bne.w	.skipfo		;already stopped: keep the face off spot
	clr.w	d0
	clr.w	d1
	cmpi.b	#$E,-$2(a0)		;goal (92 used 6): center ice
	beq.w	.noticing
	move.w	$17ECA.l,d0
	move.w	$17ECC.l,d1
	cmpi.b	#$6,-$2(a0)		;OOP (92 used $C)
	beq.w	.noticing
	move.w	(puckx).l,d0
	move.w	(pucky).l,d1
	cmpi.b	#$C,-$2(a0)		;icing (92 used 8)
	bne.w	.noticing
	move.l	a3,-(sp)		;icing: the sign of y depends on the pfgoal flag of the icing player
	movea.l	#SortCords,a3
	move.b	-$1(a0),d1		;step back: player byte of the entry just read
	ext.w	d1
	asl.w	#$7,d1		;scsize
	adda.w	d1,a3		;a3 = the icing player
	move.w	#$258,d1		;600
	btst	#$7,$62(a3)		;pfgoal
	movea.l	(sp)+,a3
	beq.w	.noticing
	neg.w	d1
.noticing	movem.w	d0-d1,-(sp)		;keep the unclamped x/y (x sign is tested below)
	cmpi.w	#$46,d0		;.xspot = 70
	blt.w	.0
	move.w	#$46,d0
.0	cmpi.w	#$FFBA,d0		;-.xspot
	bgt.w	.1
	move.w	#$FFBA,d0
.1	cmpi.w	#$A6,d1		;.yspot-.ygive = 206-40
	blt.w	.2
	move.w	#$CE,d1		;.yspot = 206
	move.w	#$46,d0
	tst.w	(sp)
	bpl.w	.2
	neg.w	d0
.2	cmpi.w	#$FF5A,d1		;-.yspot+.ygive
	bgt.w	.3
	move.w	#$FF32,d1		;-.yspot
	move.w	#$46,d0
	tst.w	(sp)
	bpl.w	.3
	neg.w	d0
.3	move.w	d0,$17EE2.l		;store the face off spot
	move.w	d1,$17EE4.l
	adda.w	#$4,sp
	bsr.w	limitfo		;pull it away from walls near any penalized player's end
.skipfo	clr.w	(PenCntDwn).l
	bset	#$2,$17F68.l		;gmpen
	jsr	(stop_current_song).l
	move.w	#$3,-(sp)		;whistle (92 used 10)
	bsr.w	sfx-LOAD
	move.w	#$A,d0		;whistle (92 used $26)
	bra.w	X_1EC1C
limitfo						;limit face off to 5-20 feet from walls of rink.
									;Checks every player in PenBuf
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	#PenBuf,a0
.loop	bsr.w	.lf		;adjust for this entry's player
	adda.w	#$2,a0		;next entry
	tst.w	(a0)
	bne.w	.loop
	movem.l	(sp)+,d0-d1/a0-a1
	rts
.lf	move.b	$1(a0),d0
	andi.w	#$7F,d0
	asl.w	#$7,d0		;scsize
	movea.l	#SortCords,a1
	move.w	#$58,d1		;limit +-88 on foy, by the player's pfgoal side
	btst	#$7,$62(a1,d0.w)		;pfgoal
	bne.w	.0
	neg.w	d1
	cmp.w	$17EE4.l,d1
	blt.w	X_21000
	move.w	#$FFBF,$17EE4.l		;-.nuy = -65
	bra.w	.sx
.0	cmp.w	$17EE4.l,d1
	bgt.w	X_21000
	move.w	#$41,$17EE4.l		;.nuy = 65
.sx	move.w	#$46,d0		;.nux = 70
	tst.w	$17EE2.l
	bpl.w	.1
	neg.w	d0		;keep the sign of fox
.1	move.w	d0,$17EE2.l
	rts
UpdatePA						;animate ref in ref window. Runs ShowThreeStars for game over, and the
									;horizontal penalty message line is reprinted when penmsgtimer runs out
	tst.w	(RefCnt).l
	bmi.w	X_21000
	sub.w	d7,(RefCnt).l
	bpl.w	.0		;frame delay not over
	bsr.w	SetPA2		;next frame
.0	cmpi.w	#$4,(RefPen).l		;game over (92 used 4)
	bne.w	.1
	bsr.w	X_25AFA
.1	sub.w	d7,(penmsgtimer).l
	bpl.w	X_21000
	move.w	#$7FFF,(penmsgtimer).l		;timer ran out (horizontal mode): reprint the line again
	bsr.w	ClearPenaltyMessage		;with the penalized player's name (TempPlOffset) at x $11, row $B
	bsr.w	printz-LOAD
	String	CC_Font1Pri,$11,$B
	dc.w	$6100,$74FC,$3011,$E248,$9179,$0001,$8D58,$6000
	dc.w	$F366,$33C0,$0001,$8072,$0C40,$002E,$6D00,$0004
	dc.w	$4E75,$4279,$0001,$8070,$6100,$0162,$0C40,$000E
	dc.w	$6600,$0006,$6100,$72BA,$0839,$0000,$0001,$7F78
	dc.w	$6700,$0014,$0839,$0003,$0001,$7F78,$6700,$0008
	dc.w	$4EB9,$0002,$7B50,$33FC,$7FFF,$0001,$806C,$0839
	dc.w	$0007,$0001,$7F6A,$6700,$000A,$33FC,$003C,$0001
	dc.w	$806C
SetPA2						;update animation for ref. Next frame/delay pair from the Penaltylist
									;animation of RefPen. The delay is doubled
									;when gmode2 bits 0 and 3 are set. Also called from UpdatePA
	movem.l	d0-d2/a0-a1,-(sp)
	moveq	#$40,d0		;clear ref window
	tst.w	(RefStep).l
	bmi.w	.pr		;idle: clear the window
	move.w	(RefStep).l,d0		;d0 = offset into the animation list
	addi.w	#$2,(RefStep).l
	move.w	(RefPen).l,d1
	movea.l	#Penaltylist,a0
	adda.w	(a0,d1.w),a0
	adda.w	#$2,a0
	adda.w	(a0),a0
	move.w	(a0,d0.w),d0
	bpl.w	.0
	neg.w	d0		;negative = last frame
	st.b	(RefStep).l		;ref idle after this frame
.0	clr.w	d1		;low byte = delay
	move.b	d0,d1		;delay
	asl.w	#$3,d1		;delay * 8 = frames to show this ref frame
	move.w	d1,(RefCnt).l
	btst	#$0,$17F78.l
	beq.w	.1
	btst	#$3,$17F78.l
	beq.w	.1
	move.w	d0,-(sp)
	move.w	(RefCnt).l,d0
	add.w	d0,d0
	move.w	d0,(RefCnt).l
	move.w	(sp)+,d0
.1	lsr.w	#$8,d0
.pr	bsr.w	PushRef		;show the frame (d0 = $40 clears the window)
	movem.l	(sp)+,d0-d2/a0-a1
	rts
PushRef						;tell vblank what to display. d0 = ref frame, $40 clears the window. The
									;horizontal ref uses RefMap2
	movem.l	d0-d2/a0-a1,-(sp)
	cmpi.w	#$40,d0
	beq.w	.clearit
	mulu.w	#$70,d0		;refwidth*refheight*2
	movea.l	(RefsMap).l,a0		;vertical ref map
	btst	#$7,$17F6A.l		;sfhor
	beq.w	.m1
	movea.l	(RefMap2).l,a0		;horizontal ref map
.m1	adda.l	$4(a0),a0		;skip to the map data (offset in the header)
	adda.w	#$4,a0
	adda.w	d0,a0		;+ frame offset
	movea.l	#$18074,a1		;a1 = ram copy of the ref map that vblank sends to vram
	move.w	(ExtraChars).l,d2		;d2 = start char of the ref tiles
	btst	#$7,$17F6A.l
	bne.w	.4
	ori.w	#$8000,d2		;priority
.4	moveq	#$37,d0		;(refheight*refwidth)-1
.1	move.w	(a0)+,(a1)		;map word + start char/attributes
	add.w	d2,(a1)+
	dbra	d0,.1
	bset	#$1,$17F6C.l		;sf2refref
	bra.w	.ex
.clearit	btst	#$7,$17F6A.l		;sfhor: horizontal mode only clears the line
	bne.w	.cl
	movea.l	#$18074,a1
	moveq	#$37,d0		;(refheight*refwidth)-1
.2	move.w	#$7FF,(a1)+		;blank tile
	dbra	d0,.2
	bset	#$1,$17F6C.l		;sf2refref
.cl	moveq	#-1,d0		;clear line
	bsr.w	X_1ED96
.ex	movem.l	(sp)+,d0-d2/a0-a1
	rts
	dc.w	$48E7,$E040,$0839,$0007,$0001,$7F6A,$6600,$0082
	dc.w	$4A40,$6A00,$001C,$6100,$F1C0,$0006,$BF00,$0A00
	dc.w	$700D,$7203,$343C,$07FF,$6100,$EE46,$6000,$0092
	dc.w	$6100,$F1A6,$0006,$BF05,$0A00,$227C,$0004,$165C
	dc.w	$D2F1,$0000,$D2FC,$0002,$3011,$0440,$0002,$6700
	dc.w	$0070,$E248,$9179,$0001,$8D58,$6A00,$0008,$4279
	dc.w	$0001,$8D58,$3011,$4A31,$00FF,$6600,$0006,$0440
	dc.w	$0001,$7203,$6100,$EE94,$0479,$0002,$0001,$8D5A
	dc.w	$0679,$0001,$0001,$8D58,$6100,$F160,$6000,$0032
	dc.w	$6100,$0034,$4A40,$6B00,$0028,$6100,$F13C,$0006
	dc.w	$BF11,$0B00
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	adda.w	#$2,a1
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	bsr.w	print-LOAD
	movem.l	(sp)+,d0-d2/a1
	rts
ClearPenaltyMessage						;Blank the horizontal mode penalty message line (22 spaces at x 5, y $B).
									;Called from UpdatePA and prefmes
	bsr.w	printz-LOAD
	String	CC_Font1Pri,$5,$B,'                      '
	dc.w	$4E75
PenGoalStuff						;do this stuff after a goal. a1 = scored on team, a2 = scoring team.
									;Clears PenBuf only when the scored
									;on team has 6 on the ice. If the scoring team had more players on ice,
									;the first scored on player in the box without a coincidental penalty is
									;released (also sets DelayedPen bit 0)
	movem.l	d0-d2/a0,-(sp)
	cmpi.w	#$6,$26(a1)		;tmap
	bne.w	.1
	bsr.w	X_1EEE4
.1	move.w	$26(a2),d2		;end p.killing by scored on team
	cmp.w	$26(a1),d2
	ble.w	.ex		;scoring team did not have more players on the ice
	lea.l	$9C(a1),a0		;penalty box list of the scored on team
.0	clr.w	d2		;next box list entry
	move.b	(a0)+,d2		;d2 = roster offset of the next player in the box
	bmi.w	.ex		;end of list
	btst	#$6,$68(a1,d2.w)		;coincidental
	bne.w	.0		;skip those
	clr.w	$68(a1,d2.w)		;release this player
	bsr.w	X_1EFEC
	bset	#$0,$17F7E.l
	addi.w	#$1,$26(a1)		;tmap
	addi.w	#$1,$2(a2)		;tmPwrGoals
	bset	#$0,$1837E.l		;home tmflags: tmflcc
	bset	#$0,$186E4.l		;visitors tmflags: tmflcc
.ex	movem.l	(sp)+,d0-d2/a0
	rts
	dc.w	$701F,$207C,$0001,$8022,$4258,$51C8,$FFFC,$4E75
updatepentime						;update the time remaining on all penalized players, once a second. Sets
									;sflags3 bit 6 on that tick, then updatePPTeamTime. Falls into
									;updatepentime_ut for team 2
	bclr	#$6,$17F6E.l		;clear last second's tick flag
	btst	#$0,$17F68.l		;gmclock
	bne.w	X_21000
	sub.w	d7,(Penaltytimer).l
	bpl.w	X_21000
	addi.w	#$18,(Penaltytimer).l		;jps
	bset	#$6,$17F6E.l		;one second tick
	bsr.w	chkatop		;attack time stat
	jsr	(updatePPTeamTime).l
	movea.l	#tmstruct,a2		;team 1, then fall through for team 2
	bsr.w	updatepentime_ut
	adda.w	#$366,a2		;tmsize
updatepentime_ut						;a2 = team. Walks the penalty box list (tmboxlist): the first two players
									;without a coincidental penalty count down one second and the rest wait.
									;Beeps when the first served time gets to 5 or less and releases the
									;player at 0. Coincidental penalties count down on their own
	lea.l	$9C(a2),a0		;penalty box list
	movea.l	#mesarea,a1		;serving players
	moveq	#$2,d1		;two can serve at once
	moveq	#$2,d3
.next	clr.w	d0		;next list entry
	move.b	(a0)+,d0
	bmi.w	.done		;end of list
	btst	#$6,$68(a2,d0.w)		;coincidental
	bne.w	.1
	subi.w	#$1,d1
	bmi.w	.next		;third or later player waits
	move.w	d0,(a1)+		;remember the serving player
	subi.w	#$1,$68(a2,d0.w)		;one second off
	bne.w	.cont
	bsr.w	X_1EFEC		;time is up
.cont	bra.w	.next
.done	move.w	(mesarea).l,d0		;first serving player
	cmpi.w	#$1,d1		;one serving
	beq.w	.0
	tst.w	d1
	bne.w	.n1
	bsr.w	.0		;two serving: check the first, then the second
	bra.w	.two
.n1	cmpi.w	#$FFFF,d1		;exactly three in the list: check the second only
	bne.w	X_21000
.two	move.w	(TextBuffer).l,d0		;second serving player (mesarea+2)
.0	cmpi.w	#$5,$68(a2,d0.w)
	bgt.w	X_21000
	move.w	#$1,-(sp)		;SFXbeep1
	tst.w	$68(a2,d0.w)
	bne.w	.snd
	bsr.w	releasepl		;time is 0: let him out
	move.w	#$2,(sp)		;SFXbeep2
.snd	bsr.w	sfx-LOAD
	rts
.1	subi.w	#$1,$68(a2,d0.w)		;coincidental penalty
	btst	#$3,$68(a2,d0.w)		;high byte bit 3 (word bit 11), probably set when the count has run out
	beq.w	.next
	btst	#$4,$68(a2,d0.w)		;high byte bit 4 (word bit 12)
	bne.w	X_1EFE8
	move.w	#$1000,$68(a2,d0.w)
	bra.w	X_1EFEC
	dc.w	$4272,$0068,$74FF,$0642,$0001,$11B0,$2000,$20FF
	dc.w	$6A00,$FFF4,$90FC,$0001,$4E75
chkatop						;attack time of possession stat update. Called once a second from
									;updatepentime
	moveq	#$0,d1		;d1 = struct offset of the team credited
	move.w	(pucky).l,d0
	cmpi.w	#$58,d0
	bgt.w	.1		;puck beyond y +$58: team 1 (d1 = 0)
	move.l	#$366,d1		;tmsize
	neg.w	d0
	cmpi.w	#$58,d0
	blt.w	X_21000
.1	btst	#$1,$17F68.l		;gmdir
	beq.w	.0
	eori.w	#$366,d1		;gmdir set: swap the teams
.0	movea.l	#tmstruct,a2		;a2 = team 1; d1 = offset of the credited team
	addi.w	#$1,$A(a2,d1.w)		;attack time
	rts
releasepl						;player's penalty time is up so let him out (if appropriate). a2 = team,
									;d0 = player*2. Called from updatepentime_ut
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	$22(a2),a3		;tmsort
	suba.w	#$80,a3
.0	adda.w	#$80,a3		;first sort obj not on the ice
	tst.w	$34(a3)
	bpl.w	.0		;position >= 0 = on the ice
	move.w	d0,d3
	lsr.w	#$1,d3		;d3 = player number
	move.w	$26(a2),d1		;tmap
	addi.w	#$1,$26(a2)		;one more on the ice
	bset	#$0,$1837E.l		;home tmflags: tmflcc
	bset	#$0,$186E4.l		;visitors tmflags: tmflcc
	movea.l	#priolist,a0
	tst.w	$28(a2)		;tmgoalie
	bpl.w	.1
	adda.w	#$1,a0
.1	clr.w	$34(a3)		;position
	move.b	(a0,d1.w),$35(a3)
	bsr.w	X_22754		;initial assignment
	bsr.w	X_22770		;bring him onto the ice
	bset	#$2,$63(a3)		;pflags2 bit 2
	movem.l	(sp)+,d0-d3/a0-a3
	rts
GetLowestPen						;a2 = shorthanded team, a3 = team on the power play. Return d0 = power
									;play time left from the penalty box times. Called from updatepwrplay
	clr.w	d0		;d0 = running total, d3 = previous time
	clr.w	d3
	lea.l	$9C(a2),a0		;penalty box list
.getstatus	clr.w	d2
	move.b	(a0)+,d2
	bmi.w	.endoflist
	move.w	$68(a2,d2.w),d2		;tmpdst
	btst	#$E,d2		;bit 14: coincidental
	bne.w	.getstatus
	sub.w	d3,d2
	add.w	d2,d0
	move.w	d2,d3
	bra.w	.getstatus
.endoflist	cmpi.w	#$6,$26(a3)		;tmap: 6 on ice, done
	beq.w	X_21000
	sub.w	d3,d0
	lea.l	$9C(a3),a0		;then the other team's box list
	clr.w	d2
.getstatusopp	move.b	(a0)+,d2
	bmi.w	X_21000
	btst	#$6,$68(a3,d2.w)		;coincidental (byte bit 6, word bit 14)
	bne.w	.getstatusopp
	cmp.w	$68(a3,d2.w),d0
	blt.w	X_21000
	add.w	d3,d0
	rts
	dc.w	$4279,$0001,$7EEE,$0839,$0007,$0001,$7F6A,$6700
	dc.w	$0004,$C543,$082B,$0002,$0062,$6600,$006A,$48E7
	dc.w	$FF00,$342B,$0000,$362B,$0014,$33EB,$004A,$0001
	dc.w	$7CF4,$33EB,$004C,$0001,$7CF6,$6100,$0E0A,$302B
	dc.w	$004E,$806B,$0050,$6600,$0036,$0C6B,$000B,$0052
	dc.w	$6E00,$002C,$4CD7,$00FF,$2F0B,$6100,$C20C,$342B
	dc.w	$0000,$362B,$0014,$D440,$D641,$33FC,$0001,$0001
	dc.w	$7CF4,$33FC,$0001,$0001,$7CF6,$6100,$0DCA,$4CDF
	dc.w	$00FF,$6100,$0094,$4A79,$0001,$7EEE,$6600,$007C
	dc.w	$302B,$0052,$E340,$207C,$0001,$7CA0,$227C,$0001
	dc.w	$7CC0,$247C,$0001,$7C80,$3230,$0000,$0C41,$000F
	dc.w	$6700,$0026,$4244,$1831,$1001,$B672,$4000,$6F00
	dc.w	$0018,$5270,$0000,$5370,$4000,$1384,$1000,$1380
	dc.w	$1001,$5241,$6000,$FFD6,$3230,$0000,$6700,$0026
	dc.w	$4244,$1831,$10FF,$B672,$4000,$6C00,$0018,$5370
	dc.w	$0000,$5270,$4000,$1384,$1000,$1380,$10FF,$5341
	dc.w	$6600,$FFDE,$3583,$0000,$4E75,$376B,$001C,$0000
	dc.w	$376B,$0020,$0014,$4E75
