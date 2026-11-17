	include	segacd\hockey.inc
	include	macros\genesis.mac

AttribWgtList	equ	$26266
CC_Font1Pri	equ	$BF
CC_Font2	equ	$FE
CopyString	equ	$25818
CrowdPeak	equ	$17F92
Framer	equ	$38CA0
GAttribOverallMask	equ	$41DD2
GetGoalieCount	equ	$2ED60
GetPlayerCount	equ	$2EDBC
HomeTeam	equ	$17FAE
LOAD	equ	$1B000
LetterGrid	equ	$26DD0
NoNameTxt	equ	$25E54
OptUserRec	equ	$18C06
OvrDividend	equ	$1A572
OvrDivisor	equ	$1A570
OvrGoalWgtList	equ	$26256
OvrPlayerWgtList	equ	$26246
PAttribOverallMask	equ	$41C70
ReadCrowdRecord	equ	$2258E
TeamList	equ	$1B00C
TempWord1	equ	$17E62
ThreeStars	equ	$BC000
ValidSRAM	equ	$193BA
VisTeam	equ	$17FB0
appstring	equ	$39208
awayuser	equ	$18BF6
awtmstruct	equ	$186B2
eraser	equ	$38C06
homeuser	equ	$18BF4
mesarea	equ	$17EF2
move	equ	$2C9C8
namelog	equ	$1A2FC
print	equ	$38F80
printx	equ	$18D58
printy	equ	$18D5A
printz	equ	$38F6E
sflags6	equ	$17F76
swap	equ	$2779A
tmstruct	equ	$1834C
X_7534	equ	$7534
X_7582	equ	$7582
X_75CC	equ	$75CC
X_75D8	equ	$75D8
X_7616	equ	$7616
X_BA00	equ	$BA00

	org	$AA4A

UpdateRecords						;With save RAM (ValidSRAM) and user records on (OptUserRec 0), update the
									;team and player records after a game (UpdateTeamRecord UpdateCrowdRecord,
									;UpdatePlayerRecords), then the save RAM checksum (MakeSRAMChecksum).
									;Called from Intermission
	dc.w	$0004,$2000
	tst.w	(ValidSRAM).l
	bmi.w	.lAB76		;no save RAM: nothing to update
	tst.w	(OptUserRec).l
	bne.w	.lAB76		;user records turned off in the options
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	.lAD8C		;goalies of each team
	bsr.w	.lADBA		;players of each team
	move.w	(HomeTeam).l,d1
	ext.l	d1
	movea.l	#ThreeStars,a0
	movea.l	#tmstruct,a2
	move.w	$193AA.l,d5		;goalie count: the first players of the roster are goalies
	move.w	(VisTeam).l,d6		;opponent team for the records
	bsr.w	.lAD0E
	move.w	(VisTeam).l,d1
	ext.l	d1
	movea.l	#awtmstruct,a2
	move.w	$193AC.l,d5
	move.w	(HomeTeam).l,d6
	bsr.w	.lAD0E
	clr.w	d7		;d7 = "a record was changed" flag
	movea.l	#tmstruct,a1
	move.w	(homeuser).l,d4
	move.w	(awayuser).l,d5
	move.w	(HomeTeam).l,d1
	move.w	(VisTeam).l,d2
	move.w	$193AA.l,d6
	ext.l	d1
	movea.l	#ThreeStars,a0
	bsr.w	.lAC54
	movea.l	#awtmstruct,a1
	move.w	(awayuser).l,d4
	move.w	(homeuser).l,d5
	move.w	(VisTeam).l,d1
	move.w	(HomeTeam).l,d2
	move.w	$193AC.l,d6
	ext.l	d1
	movea.l	#ThreeStars,a0
	bsr.w	.lAC54
	movea.l	#ThreeStars,a0
	move.w	(homeuser).l,d1
	ext.l	d1
	move.w	(awayuser).l,d2
	move.w	(HomeTeam).l,d3
	move.w	(VisTeam).l,d4
	movea.l	#tmstruct,a1
	movea.l	#awtmstruct,a2		;opponent team struct
	bsr.w	.lAB78
	movea.l	#ThreeStars,a0
	move.w	(awayuser).l,d1
	ext.l	d1
	move.w	(homeuser).l,d2
	move.w	(VisTeam).l,d3
	move.w	(HomeTeam).l,d4
	movea.l	#awtmstruct,a1
	movea.l	#tmstruct,a2
	bsr.w	.lAB78
	movem.l	(sp)+,d0-d7/a0-a6
.lAB76	rts
.lAB78	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	X_75D8
	st.b	d7
	movem.w	d0,-(sp)
	clr.w	d0
	move.b	$A(a0),d0
	lsl.w	#$8,d0
	move.b	$B(a0),d0
	cmpi.w	#$2328,d0
	bge.w	.lABF0
	addi.w	#$1,d0
	move.b	d0,$B(a0)
	lsr.w	#$8,d0
	move.b	d0,$A(a0)
	move.w	$C(a1),d0
	cmp.w	$C(a2),d0
	bgt.w	.lABD6
	blt.w	.lABF0
	clr.w	d0
	move.b	$C(a0),d0
	lsl.w	#$8,d0
	move.b	$D(a0),d0
	addi.w	#$1,d0
	move.b	d0,$D(a0)
	lsr.w	#$8,d0
	move.b	d0,$C(a0)
	bra.w	.lABF0
.lABD6	clr.w	d0
	move.b	$8(a0),d0
	lsl.w	#$8,d0
	move.b	$9(a0),d0
	addi.w	#$1,d0
	move.b	d0,$9(a0)
	lsr.w	#$8,d0
	move.b	d0,$8(a0)
.lABF0	movem.w	(sp)+,d0
	movem.w	d0,-(sp)
	move.w	$C(a1),d0
	cmp.w	$C(a2),d0
	movem.w	(sp)+,d0
	ble.w	.lAC4A
	move.w	$C(a1),d5
	cmp.b	$0(a0),d5
	ble.w	.lAC26
	st.b	d7
	move.b	d5,$0(a0)
	move.b	d3,$1(a0)
	move.b	d4,$2(a0)
	move.b	d2,$3(a0)
.lAC26	move.w	$C(a2),d5
	move.w	$0(a2),d6
	sub.w	d5,d6
	cmp.b	$4(a0),d6
	ble.w	.lAC4A
	st.b	d7
	move.b	d6,$4(a0)
	move.b	d3,$5(a0)
	move.b	d4,$6(a0)
	move.b	d2,$7(a0)
.lAC4A	bsr.w	X_7616
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.lAC54	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	ReadCrowdRecord-LOAD
	move.w	$C(a1),d3
	cmp.b	$0(a0),d3
	ble.w	.lAC7A
	move.b	d3,$0(a0)
	move.b	d4,$1(a0)
	move.b	d5,$3(a0)
	move.b	d2,$2(a0)
	st.b	d7
.lAC7A	subi.w	#$1,d6
	clr.w	d3
.lAC80	move.w	d6,d0
	addi.w	#$EA,d0
	move.b	(a1,d0.w),(TempWord1).l
	addi.w	#$FFCC,d0
	move.b	(a1,d0.w),d0
	sub.b	d0,(TempWord1).l
	cmp.b	(TempWord1).l,d3
	bge.w	.lACAC
	move.b	(TempWord1).l,d3
.lACAC	dbra	d6,.lAC80
	cmp.b	$4(a0),d3
	ble.w	.lACCA
	st.b	d7
	move.b	d3,$4(a0)
	move.b	d4,$5(a0)
	move.b	d5,$7(a0)
	move.b	d2,$6(a0)
.lACCA	cmp.w	(HomeTeam).l,d1
	bne.w	.lACFE
	move.b	$8(a0),d3
	andi.w	#$FF,d3
	cmp.w	(CrowdPeak).l,d3
	bge.w	.lACFE
	move.w	(CrowdPeak).l,d3
	st.b	d7
	move.b	d3,$8(a0)
	move.b	d4,$9(a0)
	move.b	d5,$B(a0)
	move.b	d2,$A(a0)
.lACFE	tst.w	d7
	beq.w	.lAD08
	bsr.w	X_75CC
.lAD08	movem.l	(sp)+,d0-d7/a0-a6
	rts
.lAD0E	clr.l	d0
	move.w	#$19,d2
.lAD14	bsr.w	X_7534
	cmp.w	d5,d0
	blt.w	.lAD2E
	move.w	d0,-(sp)
	addi.w	#$B6,d0
	move.b	(a2,d0.w),d4
	move.w	(sp)+,d0
	bra.w	.lAD42
.lAD2E	move.w	d0,-(sp)
	addi.w	#$EA,d0
	move.b	(a2,d0.w),d4
	addi.w	#$FFCC,d0
	sub.b	(a2,d0.w),d4
	move.w	(sp)+,d0
.lAD42	move.b	$0(a0),d3
	cmp.b	d3,d4
	ble.w	.lAD82
	move.b	d4,$0(a0)
	move.b	$18BF5.l,$1(a0)
	move.b	$18BF7.l,$3(a0)
	cmpa.l	#$1834C,a2
	beq.w	.lAD7A
	move.b	$18BF7.l,$1(a0)
	move.b	$18BF5.l,$3(a0)
.lAD7A	move.b	d6,$2(a0)
	bsr.w	X_7582
.lAD82	addi.w	#$1,d0
	dbra	d2,.lAD14
	rts
.lAD8C	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a2
	jsr	(GetGoalieCount).l
	move.w	d0,$193AA.l
	movea.l	#awtmstruct,a2
	jsr	(GetGoalieCount).l
	move.w	d0,$193AC.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.lADBA	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a2
	jsr	(GetPlayerCount).l
	move.w	d0,$193AE.l
	movea.l	#awtmstruct,a2
	jsr	(GetPlayerCount).l
	move.w	d0,$193B0.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
AppendUserName						;Append user name d2 (12 bytes of the name log at namelog, spaces for 0)
									;to a1, or NoNameTxt when d2 is 0; trailing spaces trimmed (TrimSpaces)
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	a1,a2		;keep the String start
	tst.w	d2		;no user?
	beq.w	.2
	move.w	#$B,d0
	clr.w	d3
	movea.l	#namelog,a0
	mulu.w	#$C,d2		;12 bytes per name
	adda.l	d2,a0		;this user's name
.loop	move.b	(a0,d3.w),d1		;0 bytes print as spaces
	bne.w	.0
	move.b	#$20,d1
.0	move.b	d1,$2(a1)		;after the length word
	tst.b	(a1)+
	addi.w	#$1,d3		;next name byte
	dbra	d0,.loop
	move.w	#$E,(a2)		;length = 12 + header
	btst	#$7,(sflags6).l
	beq.w	.1		;trim only when asked (bit 7)
	bsr.w	TrimSpaces		;trim the trailing spaces
.1	bra.w	.x
.2	movea.l	a1,a3
	move.l	a3,-(sp)
	movea.l	#NoNameTxt,a1
	jsr	(CopyString).l
	movea.l	(sp)+,a2
	bsr.w	TrimSpaces		;trim the trailing spaces
.x	movem.l	(sp)+,d0-d3/a0-a3
	rts
	dc.w	$0002,$48E7,$FFFE,$3E3C,$0009,$4EB8,$6044,$207C
	dc.w	$000A,$FF60,$0839,$0007,$00FF,$800E,$66F6,$23FC
	dc.w	$0000,$0000,$00FF,$8022,$33FC,$000B,$00FF,$8020
	dc.w	$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$203C,$0000,$3FFF,$0839,$0007,$00FF
	dc.w	$800E,$66F6,$33FC,$0016,$00FF,$8020,$08F9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6,$20F9
	dc.w	$00FF,$8010,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$51C8,$FFB2,$203C,$0000,$0027
	dc.w	$0839,$0007,$00FF,$800E,$66F6,$23FC,$0000,$0010
	dc.w	$00FF,$8022,$33FC,$000B,$00FF,$8020,$08F9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9
	dc.w	$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F
	dc.w	$0839,$0007,$00FF,$800E,$66F6,$33FC,$0015,$00FF
	dc.w	$8020,$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$67F6,$30F9,$00FF,$8010,$08F9,$0007,$00FF
	dc.w	$800F,$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$66F6,$08B9,$0007,$00FF,$800F,$51C8,$FFB2
	dc.w	$4EB9,$0003,$6D0A,$2F0E,$2C79,$0001,$9360,$0839
	dc.w	$0005,$00FF,$800F,$6706,$3D3C,$0001,$6004,$3D3C
	dc.w	$0000,$08B9,$0005,$00FF,$800F,$23CE,$0001,$9360
	dc.w	$2C5F,$3039,$0001,$8BFE,$3239,$0001,$8C00,$3439
	dc.w	$0001,$8BF8,$3E3C,$0005,$4EB8,$6044,$4EB9,$0002
	dc.w	$B614,$4EB9,$0002,$1FC8,$303C,$0002,$4EB8,$5F22
	dc.w	$303C,$0080,$4EB8,$5F22,$6500,$FFF6,$303C,$0081
	dc.w	$4EB8,$5F22,$3410,$0242,$FF00,$0C42,$0000,$66EC
	dc.w	$33FC,$0005,$0001,$9364,$303C,$0013,$41F9,$0001
	dc.w	$9364,$4EB8,$5F22,$4EB9,$0003,$6D0A,$303C,$8000
	dc.w	$323C,$0000,$207C,$000A,$FF60,$4EB9,$0003,$7762
	dc.w	$4EB9,$0003,$816C,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$33FC,$0027,$00FF,$8020,$08F9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF
	dc.w	$800F,$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$66F6,$08B9,$0007,$00FF,$800F,$4CDF,$7FFF
	dc.w	$2F0E,$2C79,$0001,$9360,$4A5E,$670A,$08F9,$0005
	dc.w	$00FF,$800F,$6008,$08B9,$0005,$00FF,$800F,$23CE
	dc.w	$0001,$9360,$2C5F,$4EF9,$0002,$E980
AppendTeamName						;Append the city name of team d0 (TeamList block Strings) to a1
									;(appstring)
	movem.l	d0/a0-a3,-(sp)
	ext.w	d0
	asl.w	#$2,d0
	movea.l	#TeamList,a0
	movea.l	(a0,d0.w),a0
	move.w	$4(a0),d0		;offset of the team's Strings block
	ext.l	d0
	adda.l	d0,a0		;a0 = Strings block
	adda.w	(a0),a0		;first String: the city
	movea.l	a1,a3
	movea.l	a0,a1		;city name
	jsr	(appstring).l
	movem.l	(sp)+,d0/a0-a3
	rts
CalcAttrib						;The overall rating of player d0: his attributes weighted by
									;OvrPlayerWgtList (skaters) or
									;OvrGoalWgtList (goalies), and by AttribWgtList. Called from
									;getNameandAttrib and PrintOverallRating
	move.l	a6,-(sp)		;push a6 to stack
	clr.w	(OvrDivisor).l
	clr.w	(OvrDividend).l
	movea.l	#AttribWgtList,a6
	cmp.l	(PAttribOverallMask).l,d4		;compare long word (1FBA000A) to d4
	bne.w	.1		;branch if not equal
	movea.l	#OvrPlayerWgtList,a6
.1	cmp.l	(GAttribOverallMask).l,d4		;compare long word 130F000A to d4
	bne.w	.11		;branch if not equal
	movea.l	#OvrGoalWgtList,a6
.11	movea.l	$1E(a2),a0		;move ROM address of Team Data into a0
	lea.l	$1A4(a2),a4		;move start of Hot/Cold table to a4
	clr.l	d1
	move.w	d0,d1		;move d0 into d1. d0 is the offset of the player
	asl.w	#$4,d1		;mult d1 by 16
	adda.l	d1,a4		;add d1 to a4
	adda.l	#$10,a4		;add 16 dec to a4. Move to start of Hot/Cold for player.
	adda.w	$0(a0),a0		;add player table offset to Team Data start
.skip	adda.w	(a0),a0		;add Player Name length to a0
	adda.w	#$8,a0		;add 8 (skips attributes)
	dbra	d0,.skip
	clr.w	d0
	clr.w	d1
	moveq	#$F,d2		;move 15 dec into d2 (start at bit 15)
	swap	d4		;swap words in d4
.bit	btst	d2,d4		;bit test d2 bit in d4
	beq.w	.lB20A		;branch if bit is 0
	move.w	d2,d3		;move d2 into d3
	lsr.w	#$1,d3		;divide d3 by 2
	neg.w	d3
	move.b	-$1(a0,d3.w),d3		;move a0+d3-1 into d3. a0 currently at end of player data.
	btst	#$0,d2		;test bit 0 of d2
	beq.w	.0
	lsr.w	#$4,d3		;divide d3 by 16. Shifts upper nibble to lower in case d2 was odd
.0	andi.w	#$F,d3		;pass bottom nibble of d3
	cmpi.w	#$D,d2		;compare d2 to 13 dec (check if Wgt nibble)
	bne.w	.cont		;branch if not equal
	bra.w	.00
.cont	cmpi.w	#$6,d2		;compare d2 to 6 (Fight nibble)
	beq.w	.00
	movem.l	d5-d7,-(sp)
	move.b	(a6,d2.w),d5		;move a6+d2 into d5
	ext.w	d5
	cmpi.w	#$2,d5		;comare d5 to 2
	beq.w	.000
	move.w	d3,-(sp)		;push d3 to stack (current attribute)
	subi.w	#$2,d5		;sub 2 from d5
.attribadd	add.w	(sp),d3		;add stack value to d3
	dbra	d5,.attribadd
	asr.w	#$1,d3		;divide d3 by 2
	tst.w	(sp)+		;test stack and increment
.000	movem.l	(sp)+,d5-d7		;pop off stack into d5-d7
	cmpa.l	#$26266,a6		;check if a6 is AttribWgtList
	beq.w	.2
	neg.w	d2
	move.w	d7,-(sp)		;push d7 to stack
	move.b	-$1(a4,d2.w),d7		;move data at a4+d2-1 into d7
	ext.w	d7
	add.w	d7,(OvrDivisor).l		;add d7 to OvrDivisor
	addi.w	#$1,(OvrDividend).l		;add 1 to OvrDividend
	move.w	(sp)+,d7		;pop from stack into d7
	neg.w	d2
	bra.w	.00
.2	move.w	d3,-(sp)		;push d3 onto stack
	asl.w	#$4,d3		;mult d3 by 16
	add.w	(sp),d3		;add value on stack to d3
	add.w	(sp)+,d3		;add value again from stack into d3 and increment
	neg.w	d2
	add.b	-$1(a4,d2.w),d3		;add data at a4+s2-1 into d3
	bpl.w	.pos
	clr.b	d3
.pos	neg.w	d2
.00	add.w	d3,d0		;add d3 to d0 (d0 = attribute value)
	addi.w	#$64,d1		;add 100 dec to d1
.lB20A	dbra	d2,.bit
	cmpa.l	#$26266,a6		;compare AttribWgtList with a6
	beq.w	.3
	move.w	#$64,d1		;move 100 dec into d1
	movem.l	d6-d7,-(sp)		;push d6 and d7 to stack
	move.w	(OvrDivisor).l,d6
	ext.l	d6
	move.w	(OvrDividend).l,d7
	divs.w	d7,d6		;divide d7 into d6
	add.w	d6,d0		;add d6 to d0
	movem.l	(sp)+,d6-d7
.3	cmp.w	d1,d0
	blt.w	.4
	move.w	d0,d1
	subi.w	#$1,d0
.4	movea.l	(sp)+,a6
	rts
	dc.w	$0202,$0202
	dc.w	$0406,$0204
	dc.w	$0204,$0606
	dc.w	$0402,$0202
	dc.w	$0202,$0202
	dc.w	$0202,$0202
	movep.w	$202(a1),d4
	btst	d4,d2
	dc.w	$0202,$0202
	dc.w	$0202,$0202
	dc.w	$0202,$0202
	dc.w	$0202,$0202
	dc.w	$0202,$48E7
	dc.w	$FF7E
	movea.l	$47D88.l,a0
	move.w	d1,d2
	asl.w	#$2,d2
	movea.l	(a0,d2.w),a0
	move.w	#$FFFF,d2
	bra.w	.lB2A4
.lB290	cmp.w	$4(a0),d0
	bne.w	.lB29E
	movea.l	(a0),a0
	bra.w	.lB316
.lB29E	adda.l	#$6,a0
.lB2A4	addi.w	#$1,d2
	tst.l	(a0)
	bne.w	.lB290
	movea.l	#TeamList,a0
	asl.w	#$2,d1
	movea.l	(a0,d1.w),a0
	movea.l	a0,a6
	move.w	d0,d6
	adda.w	$0(a6),a6
	bra.w	.lB2CC
.lB2C6	adda.w	(a6),a6
	adda.w	#$8,a6
.lB2CC	dbra	d6,.lB2C6
	adda.w	(a6),a6
	adda.w	$A(a0),a0
	move.w	(a0),d1
	clr.w	d3
.lB2DA	addi.w	#$1,d3
	asl.w	#$4,d1
	bne.w	.lB2DA
	movea.l	#$433AA,a0
	btst	#$0,$4(a6)
	bne.w	.lB2FA
	movea.l	#$43714,a0
.lB2FA	cmp.w	d3,d0
	blt.w	.lB316
	movea.l	#$43040,a0
	btst	#$0,$4(a6)
	bne.w	.lB316
	movea.l	#$42CD6,a0
.lB316	movem.l	(sp)+,d0-d7/a1-a6
	rts
TrimSpaces						;Trim the trailing spaces of String a2 and pad it to an even length
	movem.l	a3,-(sp)
	movea.l	a2,a3
	adda.w	(a2),a3		;a3 = end of the String
.loop	move.b	-(a3),d0
	cmpi.b	#$20,d0		;space?
	bne.w	.0		;last character not a space: done
	move.b	#$0,(a3)
	subi.w	#$1,(a2)		;one shorter
	bra.w	.loop
.0	addi.w	#$1,(a2)
	andi.w	#$FE,(a2)
	movem.l	(sp)+,a3
	rts
	dc.w	$48E7,$FFFE,$08B9,$0005,$00FF,$800F,$383C,$0002
	dc.w	$23FC,$0004,$00D0,$0001,$8D66,$08B9,$0000,$0001
	dc.w	$8D64,$08F9,$0002,$0001,$8D64,$08B9,$0001,$0001
	dc.w	$8D64,$33FC,$0000,$0001,$8D30,$33FC,$B400,$0001
	dc.w	$8D32,$33FC,$B800,$0001,$8D3C,$33FC,$0005,$0001
	dc.w	$8D3E,$33FC,$C000,$0001,$8D38,$33FC,$0006,$0001
	dc.w	$8D3A,$33FC,$E000,$0001,$8D34,$33FC,$0006,$0001
	dc.w	$8D36,$303C,$0000,$4EB9,$0003,$7B5A,$08F9,$0005
	dc.w	$00FF,$800F,$4EB9,$0003,$7460,$33C4,$0001,$8D4E
	dc.w	$2479,$0004,$7D10,$508A,$4EB9,$0003,$8946,$9123
	dc.w	$4567,$89AB,$CDEF,$33C4,$0001,$A3D2,$2479,$0004
	dc.w	$7D10,$508A,$4EB9,$0003,$8946,$9123,$4560,$89AB
	dc.w	$CDEF,$33C4,$0001,$8D42,$4EB9,$0003,$93E8,$4EB9
	dc.w	$0003,$8F6E,$0006,$FF00,$0000,$7028,$721C,$343C
	dc.w	$07FF,$4EB9,$0003,$8C06,$4EB9,$0003,$EC60,$4EB9
	dc.w	$0003,$8F6E,$0006,$FE00,$0000,$2079,$0004,$7D0C
	dc.w	$2248,$2448,$D1DA,$D3DA,$4240,$4241,$7428,$761C
	dc.w	$7A0D,$4EB9,$0003,$87E2,$4EB9,$0003,$6F72,$33C4
	dc.w	$0001,$9392,$0644,$0024,$33C4,$0001,$9398,$2479
	dc.w	$0004,$7D7C,$508A,$4EB9,$0003,$8958,$33C4,$0001
	dc.w	$8D40,$2479,$0004,$7D38,$508A,$4EB9,$0003,$8946
	dc.w	$7123,$4567,$89AB,$CDEF,$4EB9,$0003,$8F6E,$0006
	dc.w	$BF1F,$0600,$3039,$0001,$7FAE,$4A79,$0001,$A390
	dc.w	$6700,$0008,$3039,$0001,$7FB0,$227C,$0001,$B00C
	dc.w	$E540,$2271,$0000,$D2E9,$0004,$3011,$0440,$0002
	dc.w	$E248,$9179,$0001,$8D58,$4EB9,$0003,$8F80,$4EB9
	dc.w	$0003,$8F6E,$0006,$BF1B,$0700,$303C,$0008,$323C
	dc.w	$0008,$4EB9,$0003,$8CA0,$4EB9,$0003,$8F6E,$0006
	dc.w	$8F1C,$0800,$3639,$0001,$7FAE,$4A79,$0001,$A390
	dc.w	$6700,$0008,$3639,$0001,$7FB0,$E543,$2079,$0004
	dc.w	$7D8C,$2070,$3000,$2248,$2448,$D1DA,$E743,$207C
	dc.w	$0002,$AF56,$0443,$0040,$D0C3,$D3DA,$363C,$0006
	dc.w	$343C,$0006,$4240,$4241,$3A3C,$0004,$3839,$0001
	dc.w	$9392,$4EB9,$0003,$87E2,$4EB9,$0003,$8F6E,$0006
	dc.w	$BF02,$0000,$303C,$0024,$323C,$0006,$4EB9,$0003
	dc.w	$8CA0,$4EB9,$0003,$9258,$0010,$BF0A,$024E,$414D
	dc.w	$4520,$2045,$4E54,$5259,$6100,$C09C,$4279,$0001
	dc.w	$A38E,$33FC,$0001,$0001,$A38C,$4240,$6100,$0AFA
	dc.w	$227C,$0001,$A37C,$6100,$085E,$6100,$06AC,$4EB9
	dc.w	$0003,$8F6E,$000E,$BF07,$064E,$616D,$6520,$4C6F
	dc.w	$6700,$33FC,$0018,$0001,$8D62,$08B9,$0002,$0001
	dc.w	$8D64,$4244,$6100,$0570,$6100,$05CA,$6100,$061E
	dc.w	$3F39,$0001,$8D58,$3F39,$0001,$8D5A,$4EB9,$0002
	dc.w	$6DF0,$33DF,$0001,$8D5A,$0679,$0001,$0001,$8D5A
	dc.w	$33DF,$0001,$8D58,$0679,$0001,$0001,$8D58,$6100
	dc.w	$05BE,$33FC,$0001,$0001,$A566,$6100,$028C,$4240
	dc.w	$6000,$01B0,$6100,$0724,$4EB9,$0003,$8F6E,$0006
	dc.w	$BF05,$1200,$4A79,$0001,$A566,$6700,$0010,$227C
	dc.w	$0001,$A37C,$6100,$0738,$6100,$04C8,$6100,$0672
	dc.w	$3039,$0001,$7474,$B079,$0001,$7474,$6700,$FFF8
	dc.w	$48A7,$4000,$3239,$0001,$7FA6,$0441,$0001,$B279
	dc.w	$0001,$A390,$4C9F,$0002,$6700,$0012,$4EB9,$0003
	dc.w	$750E,$4A41,$6700,$FFCA,$6000,$000E,$4EB9,$0003
	dc.w	$74F0,$4A41,$6700,$FFBA,$0801,$0007,$6600,$0200
	dc.w	$4A79,$0001,$A566,$6600,$002C,$303C,$0001,$0801
	dc.w	$0001,$6600,$006A,$303C,$FFFF,$0801,$0000,$6600
	dc.w	$005E,$0801,$0004,$6700,$FF5C,$6100,$01DC,$4240
	dc.w	$6000,$004C,$70FF,$0801,$0006,$6600,$00F6,$4440
	dc.w	$0801,$0005,$6600,$00EC,$0801,$0003,$6600,$0112
	dc.w	$4440,$0801,$0002,$6600,$0108,$7006,$0801,$0001
	dc.w	$6600,$00FE,$4440,$0801,$0000,$6600,$00F4,$0801
	dc.w	$0004,$6700,$FF10,$6100,$0190,$6000,$FF08,$D179
	dc.w	$0001,$A38C,$0C79,$0007,$0001,$A38C,$6F00,$000A
	dc.w	$33FC,$0001,$0001,$A38C,$4A79,$0001,$A38C,$6600
	dc.w	$000A,$33FC,$0007,$0001,$A38C,$6100,$094C,$6700
	dc.w	$FFD4,$227C,$0001,$A37C,$6100,$06AC,$4A79,$0001
	dc.w	$A566,$6600,$000C,$4EB9,$0002,$6A4A,$6000,$FEB6
	dc.w	$4EB9,$0003,$8F6E,$0006,$BF04,$1300,$D979,$0001
	dc.w	$8D58,$4EB9,$0003,$8F6E,$0006,$2020,$2000,$6100
	dc.w	$046C,$7401,$3F39,$0001,$8D58,$3F39,$0001,$8D5A
	dc.w	$4EB9,$0003,$8C06,$33DF,$0001,$8D5A,$0679,$0001
	dc.w	$0001,$8D5A,$33DF,$0001,$8D58,$0679,$0001,$0001
	dc.w	$8D58,$6100,$040A,$6100,$037E,$3004,$4440,$6000
	dc.w	$0002,$D044,$0C40,$000B,$6200,$FE4A,$3800,$6100
	dc.w	$03C4,$207C,$0001,$A37C,$4240,$0C30,$002D,$4000
	dc.w	$6700,$000E,$1030,$4000,$4880,$6100,$037C,$9045
	dc.w	$D045,$0C40,$001D,$6200,$FE1C,$3F00,$6100,$03EE
	dc.w	$7401,$3F39,$0001,$8D58,$3F39,$0001,$8D5A,$4EB9
	dc.w	$0003,$8C06,$33DF,$0001,$8D5A,$0679,$0001,$0001
	dc.w	$8D5A,$33DF,$0001,$8D58,$0679,$0001,$0001,$8D58
	dc.w	$6100,$038C,$3A1F,$6100,$03B4,$3F39,$0001,$8D58
	dc.w	$3F39,$0001,$8D5A,$4A79,$0001,$A566,$6700,$0008
	dc.w	$4EB9,$0002,$6DF0,$33DF,$0001,$8D5A,$0679,$0001
	dc.w	$0001,$8D5A,$33DF,$0001,$8D58,$0679,$0001,$0001
	dc.w	$8D58,$6100,$034A,$207C,$0001,$A37C,$227C,$0002
	dc.w	$6DD0,$1031,$5000,$1180,$4000,$6000,$FD88,$6100
	dc.w	$05B6,$4CDF,$7FFF,$4E75
NameLetterGrid
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	CC_Font1Pri,$1,$14
	move.w	#$16,d0
	move.w	#$7,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	bchg	#$0,$1A567.l
	bne.w	X_BA00
	jsr	(printz).l
	String	CC_Font1Pri,$19,$11
	movea.l	#LetterGrid,a0
	moveq	#$4,d0
.lB8F2	moveq	#$5,d1
	movea.l	#mesarea,a1
	move.w	#$E,(a1)+
.lB8FE	move.b	(a0)+,(a1)+
	move.b	#$20,(a1)+
	dbra	d1,.lB8FE
	movea.l	#mesarea,a1
	jsr	(print).l
	addi.w	#$2,(printy).l
	subi.w	#$C,(printx).l
	dbra	d0,.lB8F2
	jsr	(printz).l
	String	CC_Font2,$1,$14
	moveq	#$16,d0
	moveq	#$7,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	CC_Font1Pri,$2,$15,'D-Pad to a letter.'
	move.w	#$2,(printx).l
	addi.w	#$1,(printy).l
	move.w	(printx).l,-(sp)
	jsr	(printz).l
	String	'C to select letter.'
	move.w	(sp),(printx).l
	addi.w	#$1,(printy).l
	jsr	(printz).l
	String	'A to go back.'
	move.w	(sp),(printx).l
	addi.w	#$1,(printy).l
	jsr	(printz).l
	String	'B to cancel.'
	dc.w	$33DF,$0001,$8D58,$0679,$0001,$0001,$8D5A,$4EB9
	dc.w	$0003,$8F6E,$0012,$5354,$4152,$5420,$7768,$656E
	dc.w	$2064,$6F6E,$652E,$4CDF,$7FFF,$4E75,$227C,$0001
	dc.w	$A37C,$6100,$0406,$33FC,$0000,$0001,$8D58,$33FC
	dc.w	$000F,$0001,$8D5A,$303C,$0028,$323C,$000D,$343C
	dc.w	$07FF,$4EB9,$0003,$8C06,$4EB9,$0003,$8F6E,$0006
	dc.w	$FE01,$1400,$7016,$7207,$4EB9,$0003,$8CA0,$6100
	dc.w	$0006,$6000,$FFB2
