	include	segacd\hockey.inc
	include	macros\genesis.mac

CC_Font1Pri	equ	$BF
Framer	equ	$38CA0
GetGoalieCount	equ	$2ED60
HomeTeam	equ	$17FAE
ScoreSum	equ	$180EC
ScoreSumbytes	equ	$180F0
StartArenaAnim	equ	$2A41E
TempPlOffset	equ	$180EE
TextBuffer	equ	$17EF4
appendz	equ	$39200
appstring	equ	$39208
eraser	equ	$38C06
lcfound_close	equ	$30D9C
mesarea	equ	$17EF2
move	equ	$2C9C8
print	equ	$38F80
printbig	equ	$3926A
printx	equ	$18D58
printz	equ	$38F6E
tmstruct	equ	$1834C
X_260AA	equ	$260AA
X_260CA	equ	$260CA
X_26290	equ	$26290

	org	$25CAC

CalcTeamStarScores						;Star scores of team a2 (a3 = other team) to (a4)+, one long per roster
									;slot (26). Each starts at the goal difference. Skaters: goals*11000 +
									;assists*10100 + shots*10, or in a tied game shots*1000 + frames on ice.
									;Goalies on ice at least d5 with shots against: +32000 if goals
									;against*100/shots <= 4, +75000 more for a shutout. Called from
									;CalcStarScores
	movea.l	a2,a1		;a1 = ice time table
	move.w	$C(a2),d3		;our goals
	sub.w	$C(a3),d3		;goal difference (HmGoals / AwGoals)
	ext.l	d3
	moveq	#$19,d4
	jsr	(GetGoalieCount).l		;d0 = goalies on the team
	neg.w	d0
	add.w	d4,d0		;d4 above $19 - goalies: goalie slot
.loop	move.l	d3,(a4)		;slot d4: start at the goal difference
	cmp.w	d0,d4		;goalie slot?
	bhi.w	.goalie
	clr.w	d1
	move.b	$B6(a2),d1
	mulu.w	#$2AF8,d1		;goals * 11000
	add.l	d1,(a4)
	clr.w	d1
	move.b	$D0(a2),d1
	mulu.w	#$2774,d1		;assists * 10100
	add.l	d1,(a4)
	clr.w	d1
	move.b	$EA(a2),d1
	mulu.w	#$A,d1		;shots * 10
	tst.w	d3
	bne.w	.add		;not tied: shots * 10
	mulu.w	#$64,d1		;tied: shots * 1000
	add.l	d1,(a4)
	clr.l	d1
	add.w	$138(a1),d1		;+ frames on ice
.add	add.l	d1,(a4)
	bra.w	.next
.goalie	cmp.w	$138(a1),d5		;goalie slot: needs enough frames on ice
	bhi.w	.next		;not on ice long enough
	clr.w	d1
	move.b	$B6(a2),d1
	mulu.w	#$64,d1
	clr.w	d2
	move.b	$EA(a2),d2
	beq.w	.next		;no shots: nothing
	divu.w	d2,d1		;goals against %
	cmpi.w	#$4,d1		;4% or less?
	bhi.w	.next
	addi.l	#$7D00,(a4)
	tst.w	d1		;no goals?
	bne.w	.next
	addi.l	#$124F8,(a4)		;75000 for a shutout
.next	adda.w	#$2,a1		;next slot (word, byte, long tables)
	adda.w	#$1,a2
	adda.w	#$4,a4		;next score
	dbra	d4,.loop
	rts
	dc.w	$48E7,$E0F8,$4EB9,$0003,$8F6E,$0006,$BF0B,$0300
	dc.w	$7012,$7205,$4EB9,$0003,$8CA0,$0839,$0005,$0001
	dc.w	$7F7A,$6600,$0030,$4EB9,$0003,$8F6E,$0024,$BF0C
	dc.w	$0449,$6E6A,$7572,$7920,$746F,$3ABF,$0C06,$4F75
	dc.w	$7420,$666F,$7220,$7065,$7269,$6F64,$BF0C,$0500
	dc.w	$6000,$002A,$4EB9,$0003,$8F6E,$0022,$BF0C,$0449
	dc.w	$6E6A,$7572,$7920,$746F,$3ABF,$0C06,$4F75,$7420
	dc.w	$666F,$7220,$6761,$6D65,$BF0C,$0500,$6100,$039E
	dc.w	$4EB9,$0003,$8F80,$0839,$0000,$0001,$7BE3,$6700
	dc.w	$0016,$4EB9,$0003,$8F6E,$000E,$BF14,$0674,$6865
	dc.w	$2067,$616D,$6500,$4CDF,$1F07,$4E75,$08F9,$0007
	dc.w	$0001,$7F78,$0839,$0000,$0001,$7F78,$6700,$0008
	dc.w	$4EF9,$0002,$7860,$48E7,$E0F8,$303C,$FFFF,$4EB9
	dc.w	$0003,$9D96,$4EB9,$0003,$8F6E,$0006,$BF03,$0200
	dc.w	$701B,$7208,$4EB9,$0003,$8CA0,$43FA,$00A8,$4EB9
	dc.w	$0003,$926A,$3039,$0001,$9368,$EF40,$247C,$0001
	dc.w	$7480,$D4C0,$4240,$102A,$0066,$247C,$0001,$834C
	dc.w	$4A79,$0001,$9366,$6700,$0008,$247C,$0001,$86B2
	dc.w	$6100,$0320,$4EB9,$0003,$8F80,$4EB9,$0003,$8F6E
	dc.w	$0006,$BF04,$0700,$48E7,$0050,$3039,$0001,$9372
	dc.w	$227C,$0004,$165C,$D2F1,$0000,$43E9,$0002,$4EB9
	dc.w	$0003,$8F80,$4CDF,$0A00,$4EB9,$0003,$8F6E,$0008
	dc.w	$2062,$79BF,$0408,$3039,$0001,$9370,$247C,$0001
	dc.w	$86B2,$4A79,$0001,$9366,$6700,$0008,$247C,$0001
	dc.w	$834C,$4EB9,$0004,$1192,$4EB9,$0003,$8F80,$4CDF
	dc.w	$1F07,$4E75
ShowGoalBox						;Goal box. Closes both line change boxes, then printbig 'GOAL!' ('PP
									;GOAL!' when DelayedPen bit 0 is set, cleared here), or 'HAT TRICK!' on
									;the scorer's third goal when the scorer's slot is at least scorergoalies
									;(homegoalies home / awaygoalies visitors), then the scorer and up to two
									;assists of the last goal entry (FormatPlayerName). Calls CountGoalies,
									;StartArenaAnim (home hat trick),
									;PrintPlayerGoals and PrintPlayerAssists; BA_PS_flags bit 2 sets sflags2
									;bit 2. Called from SetPA
	dc.w	$0016,$BF04
	bchg	d1,(a0)
	dc.w	$454E
	dc.w	$414C
	addq.w	#$2,(a1)+
	movea.l	(a3),a0
	dc.w	$484F
	addq.b	#$2,-(a1)
	eor.b	d7,d4
	btst	d2,d0
	movem.l	d0-d2/a0-a4,-(sp)
	btst	#$2,$17F70.l		;penalty shot?
	beq.w	.0
	bset	#$2,$17F6C.l		;record the replay
.0	movea.l	#tmstruct,a2
	jsr	(lcfound_close).l		;close lc box
	adda.w	#$366,a2
	jsr	(lcfound_close).l		;close its box
	movea.l	#ScoreSum,a4		;+ ScoreSumbytes = last goal entry
	adda.w	(ScoreSumbytes).l,a4
	jsr	(printz).l
	String	CC_Font1Pri,$B,$2
	moveq	#$13,d0
	move.w	#$5,d1		;5 rows: no assist
	tst.b	$4(a4)
	bmi.w	.l25F5E
	addi.w	#$2,d1		;7: one assist
	tst.b	$5(a4)
	bmi.w	.l25F5E
	addi.w	#$1,d1		;8: two assists
.l25F5E	jsr	(Framer).l
	jsr	$25D8C.l		;goalies of each team
	movea.l	#tmstruct,a2
	move.w	$193AA.l,$17E98.l
	btst	#$7,$2(a4)
	beq.w	.1
	adda.w	#$366,a2
	move.w	$193AC.l,$17E98.l
.1	lea.l	X_260AA(pc),a1
	bclr	#$0,$17F7E.l		;power play goal?
	beq.w	.2
	lea.l	X_260CA(pc),a1
.2	clr.w	d0
	move.b	$3(a4),d0
	addi.w	#$B6,d0		;goals of the scorer
	cmpi.b	#$3,(a2,d0.w)		;goals
	bne.w	.l25FF0		;not a hat trick
	movem.w	d1,-(sp)
	clr.w	d1
	move.b	$3(a4),d1
	cmp.w	$17E98.l,d1		;a goalie?
	movem.w	(sp)+,d1
	blt.w	.l25FF0		;yes: no hat trick
	adda.w	(a1),a1		;HAT TRICK!
	move.w	d0,-(sp)
	move.w	$2A(a2),d0
	cmp.w	(HomeTeam).l,d0		;home team?
	bne.w	.3
	move.w	#$0,d0		;animation 0
	jsr	(StartArenaAnim).l
.3	move.w	(sp)+,d0
.l25FF0	jsr	(printbig).l
	clr.w	d0
	move.b	$3(a4),d0
	move.w	d0,-(sp)
	move.w	#$C,(printx).l
	bsr.w	FormatPlayerName		;a1 = his name
	jsr	(print).l
	move.w	(sp)+,d0
	movem.w	d1,-(sp)
	clr.w	d1
	move.b	$3(a4),d1
	cmp.w	$17E98.l,d1		;a goalie?
	movem.w	(sp)+,d1
	blt.w	.5
	jsr	$2AA80.l
.5	clr.w	d0
	move.b	$4(a4),d0
	bmi.w	.6
	bclr	#$5,$17F72.l
	bne.w	.6		;sflags4 bit 5 set: no assists
	jsr	(printz).l
	String	CC_Font1Pri,$E,$6,'Assist by:',CC_Font1Pri,$C,$7
	move.w	d0,-(sp)
	bsr.w	FormatPlayerName		;a1 = his name
	jsr	(print).l
	move.w	(sp)+,d0
	jsr	$2AA6A.l
	clr.w	d0
	move.b	$5(a4),d0
	bmi.w	.6
	jsr	(printz).l
	String	CC_Font1Pri,$C,$8
	move.w	d0,-(sp)
	bsr.w	FormatPlayerName		;a1 = his name
	jsr	(print).l
	move.w	(sp)+,d0
	jsr	$2AA6A.l
.6	bclr	#$5,$17F72.l		;clear the no assists flag
	movem.l	(sp)+,d0-d2/a0-a4
	rts
	dc.w	$000E
	cmpm.b	(sp)+,(sp)+
	bchg	d1,d7
	dc.w	$4F41
	dc.w	$4C21
	cmpm.b	(a4)+,(sp)+
	btst	d2,d0
	dc.w	$0012,$BF0C
	movep.l	$4154(a0),d1
	movea.l	(a4),a0
	addq.w	#$1,a1
	dc.w	$434B
	dc.w	$21BF
	cmpi.b	#$10,d5
	cmpm.b	(a5)+,(sp)+
	bchg	d1,(a0)
	addq.b	#$8,-(a0)
	dc.w	$474F
	dc.w	$414C
	dc.w	$21BF
	cmpi.b	#$12,d5
	cmpm.b	(a4)+,(sp)+
	movep.l	$4154(a0),d1
	movea.l	(a4),a0
	addq.w	#$1,a1
	dc.w	$434B
	dc.w	$21BF
	dc.w	$0C05,$4EB9
	dc.w	$0003,$8F6E
	dc.w	$0006,$FF0B
	dc.w	$0200,$7013
	moveq	#$8,d1
	move.l	#$7FF,d2
	jmp	(eraser).l
GetPlayerName						;but that is the same symbol as getplayername (SNASM symbols are
									;case-insensitive).
									;a1 = mesarea "NN First Last" (getname) for player TempPlOffset (bit 15
									;set: away team). Called from UpdatePA
	movem.l	d0/a2,-(sp)
	movea.l	#tmstruct,a2
	move.w	(TempPlOffset).l,d0
	bpl.w	.0
	andi.w	#$FF,d0
	adda.w	#$366,a2
.0	bsr.w	.l2612E		;name for d0 of team a2
	movem.l	(sp)+,d0/a2
	rts
.l2612E	movem.l	d0-d3/a0/a2-a3,-(sp)
	bsr.w	X_26290
	move.l	a0,-(sp)
	movea.l	#mesarea,a3
	move.w	#$4,(a3)
	lea.l	$2(a3),a1
	adda.w	(a0),a0
	move.b	(a0),d0
	bsr.w	ConvertByteToDigits
	jsr	(appendz).l
	String	' '
	movea.l	(sp)+,a1
	jsr	(appstring).l
	movea.l	#mesarea,a1
	movem.l	(sp)+,d0-d3/a0/a2-a3
	rts
	movem.l	d0/a2,-(sp)
	movea.l	#tmstruct,a2
	move.w	(TempPlOffset).l,d0
	bpl.w	.l26188
	andi.w	#$FF,d0
	adda.w	#$366,a2
.l26188	bsr.w	FormatPlayerNumInitial
	movem.l	(sp)+,d0/a2
	rts
FormatPlayerNumInitial						;a1 = mesarea string "NN F. Last" for player d0 of team a2, built in
									;TextBuffer. Called from PenaltyShotBox and others
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	X_26290		;a0 = player record
	move.l	a0,-(sp)
	movea.l	#TextBuffer,a1
	adda.w	(a0),a0		;byte after the name: number
	move.b	(a0),d0
	bsr.w	ConvertByteToDigits
	move.b	#$20,(a1)+
	movea.l	(sp)+,a0
	move.w	(a0)+,d0
	lea.l	-$2(a0,d0.w),a2		;end of the name
	move.b	(a0)+,(a1)+
	move.w	#$2E20,(a1)+
.skip	cmpi.b	#$20,(a0)+		;space?
	bne.w	.skip
.copy	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2		;end of the name?
	bne.w	.copy
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
FormatPlayerName						;a1 = mesarea string "NN Last" for player d0 of team a2, built in
									;TextBuffer. Called from ShowGoalBox and others
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	X_26290		;a0 = player record
	move.l	a0,-(sp)
	movea.l	#TextBuffer,a1
	adda.w	(a0),a0		;byte after the name: number
	move.b	(a0),d0
	bsr.w	ConvertByteToDigits
	move.b	#$20,(a1)+
	movea.l	(sp)+,a0
	move.w	(a0)+,d0
	lea.l	-$2(a0,d0.w),a2		;end of the name
.skip	cmpi.b	#$20,(a0)+		;space?
	bne.w	.skip
.copy	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2		;end of the name?
	bne.w	.copy
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
FormatPlayerNameLast						;FormatPlayerNameShort without the leading space ("Last", space padded).
									;Branches into FormatLastName
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	X_26290		;a0 = player record
	movea.l	#TextBuffer,a1
	bra.w	FormatLastName
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	X_26290
	movea.l	#TextBuffer,a1
	move.b	#$20,(a1)+
FormatLastName						;Skip the first name, copy the last name, pad; branched to from
									;FormatPlayerNameLast, so global
	move.w	(a0)+,d0
	lea.l	-$2(a0,d0.w),a2		;end of the name
.loop	cmpi.b	#$20,(a0)+		;space?
	bne.w	.loop
.loop2	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2		;end of the name?
	beq.w	.pad
	tst.b	(a0)		;0 byte?
	bne.w	.loop2
	bra.w	.pad
.loop3	move.b	#$20,(a1)+
.pad	cmpa.l	#$17F00,a1
	blt.w	.loop3
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
FinalizeTextBuffer						;mesarea length word = a1 - mesarea, with a 0 pad byte when odd. Returns
									;a1 = mesarea. Called from the FormatPlayerName routines
	move.l	a1,d0
	subi.l	#$17EF2,d0
	btst	#$0,d0		;odd?
	beq.w	.even
	clr.b	(a1)+
	addi.w	#$1,d0
.even	movea.l	#mesarea,a1
	move.w	d0,(a1)
	rts
	dc.w	$206A,$001E,$D0E8,$0000,$6000,$0008,$D0D0,$D0FC
	dc.w	$0008,$51C8,$FFF8,$4E75
ConvertByteToDigits						;converts decimal number in d0 to ascii: two ascii digits of bcd byte d0
									;to (a1)+, a leading 0 becomes a space ($F0 + '0')
	move.w	d0,-(sp)
	lsr.b	#$4,d0		;divide by 16 (get upper digit in d0)
	bne.w	.n0		;branch if not 0
	move.b	#$F0,d0		;move $F0 into d0
.n0	addi.b	#$30,d0
	move.b	d0,(a1)+		;move d0 into a1 and increment
	move.w	(sp)+,d0		;pop d0 from stack
	andi.w	#$F,d0		;pass bottom 4 bytes of d0 (lower digit in d0)
	addi.b	#$30,d0
	move.b	d0,(a1)+		;move d0 into a1 and increment
	rts
	dc.w	$08B9,$0005,$00FF,$800F,$4EB9,$0003,$9258,$0012
	dc.w	$BD00,$0041,$6464,$7265,$7373,$2045,$7272,$6F72
	dc.w	$202F,$000A,$222F,$0002,$6000,$005C,$08B9,$0005
	dc.w	$00FF,$800F,$4EB9,$0003,$9258,$0018,$BD00,$0049
	dc.w	$6C6C,$6567,$616C,$2049,$6E73,$7472,$7563,$7469
	dc.w	$6F6E,$202F,$0002,$2200,$6000,$002C,$08B9,$0005
	dc.w	$00FF,$800F,$4EB9,$0003,$9258,$0016,$BD00,$0044
	dc.w	$6976,$6973,$696F,$6E20,$6279,$207A,$6572,$6F00
	dc.w	$202F,$0002,$2200,$207C,$0001,$7EF2,$30FC,$0018
	dc.w	$10FC,$00BD,$10FC,$0000,$10FC,$0002,$2F01,$6100
	dc.w	$01C2,$10FC,$00BD,$10FC,$0000,$10FC,$0004,$201F
	dc.w	$6100,$01B0,$227C,$0001,$7EF2,$4EB9,$0003,$926A
	dc.w	$207C,$00C0,$0000,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$33FC,$9100,$00FF,$8022,$33FC,$000A,$00FF,$8020
	dc.w	$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$0839,$0007,$00FF,$800E,$66F6,$33FC
	dc.w	$9206,$00FF,$8022,$33FC,$000A,$00FF,$8020,$08F9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6
	dc.w	$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF
	dc.w	$800F,$0839,$0007,$00FF,$800E,$66F6,$33FC,$8F02
	dc.w	$00FF,$8022,$33FC,$000A,$00FF,$8020,$08F9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9
	dc.w	$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F
	dc.w	$0839,$0007,$00FF,$800E,$66F6,$23FC,$C020,$0000
	dc.w	$00FF,$8022,$33FC,$000B,$00FF,$8020,$08F9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9
	dc.w	$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F
	dc.w	$2279,$0004,$7D18,$D3D1,$D2FC,$0020,$7007,$0839
	dc.w	$0007,$00FF,$800E,$66F6,$23D9,$00FF,$8022,$33FC
	dc.w	$000E,$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF,$800F
	dc.w	$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$66F6,$08B9,$0007,$00FF,$800F,$51C8,$FFB2,$6000
	dc.w	$FFFE,$7407,$E998,$3200,$0241,$000F,$0641,$0030
	dc.w	$0C41,$0039,$6F00,$0006,$0641,$0007,$10C1,$51CA
	dc.w	$FFE4,$4E75
