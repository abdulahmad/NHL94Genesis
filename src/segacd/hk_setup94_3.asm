	include	segacd\hockey.inc
	include	macros\genesis.mac

BA_Checker_Offset	equ	$19370
BA_Team	equ	$19366
CC_Font1Pri	equ	$BF
GetGoalieCount	equ	$2ED60
LOAD	equ	$1B000
ScoreSumbytes	equ	$180F0
TempPlOffset	equ	$180EE
TextBuffer	equ	$17EF4
appendz	equ	$39200
awtmstruct	equ	$186B2
lcfound_close	equ	$30D9C
mesarea	equ	$17EF2
move	equ	$2C9C8
print	equ	$38F80
printz	equ	$38F6E
tmstruct	equ	$1834C
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
	dc.w	$2062,$79BF,$0408
	move.w	(BA_Checker_Offset).l,d0
	movea.l	#awtmstruct,a2
	tst.w	(BA_Team).l
	beq.w	.l25ED2
	movea.l	#tmstruct,a2
.l25ED2	jsr	(FormatPlayerNumInitial+LOAD).l
	jsr	(print).l
	movem.l	(sp)+,d0-d2/a0-a4
	rts
	dc.w	$0016,$BF04,$0350,$454E,$414C,$5459,$2053,$484F
	dc.w	$5421,$BF04,$0500
ShowGoalBox						;Goal box. Closes both line change boxes, then printbig 'GOAL!' ('PP
									;GOAL!' when DelayedPen bit 0 is set, cleared here), or 'HAT TRICK!' on
									;the scorer's third goal when the scorer's slot is at least scorergoalies
									;(homegoalies home / awaygoalies visitors), then the scorer and up to two
									;assists of the last goal entry (FormatPlayerName). Calls CountGoalies,
									;StartArenaAnim (home hat trick),
									;PrintPlayerGoals and PrintPlayerAssists; BA_PS_flags bit 2 sets sflags2
									;bit 2. Called from SetPA
	movem.l	d0-d2/a0-a4,-(sp)
	btst	#$2,$17F70.l		;penalty shot?
	beq.w	.0
	bset	#$2,$17F6C.l		;record the replay
.0	movea.l	#tmstruct,a2
	jsr	(lcfound_close).l		;close lc box
	adda.w	#$366,a2
	jsr	(lcfound_close).l		;close its box
	movea.l	#$180EC,a4		;+ ScoreSumbytes = last goal entry
	adda.w	(ScoreSumbytes).l,a4
	jsr	(printz).l
	String	CC_Font1Pri,$B,$2
	dc.w	$7013,$323C,$0005,$4A2C,$0004,$6B00,$0012,$0641
	dc.w	$0002,$4A2C,$0005,$6B00,$0006,$0641,$0001,$4EB9
	dc.w	$0003,$8CA0,$4EB9,$0002,$5D8C,$247C,$0001,$834C
	dc.w	$33F9,$0001,$93AA,$0001,$7E98,$082C,$0007,$0002
	dc.w	$6700,$0010,$D4FC,$0366,$33F9,$0001,$93AC,$0001
	dc.w	$7E98,$43FA,$0116,$08B9,$0000,$0001,$7F7E,$6700
	dc.w	$0006,$43FA,$0126,$4240,$102C,$0003,$0640,$00B6
	dc.w	$0C32,$0003,$0000,$6600,$0038,$48A7,$4000,$4241
	dc.w	$122C,$0003,$B279,$0001,$7E98,$4C9F,$0002,$6D00
	dc.w	$0020,$D2D1,$3F00,$302A,$002A,$B079,$0001,$7FAE
	dc.w	$6600,$000C,$303C,$0000,$4EB9,$0002,$A41E,$301F
	dc.w	$4EB9,$0003,$926A,$4240,$102C,$0003,$3F00,$33FC
	dc.w	$000C,$0001,$8D58,$6100,$01CE,$4EB9,$0003,$8F80
	dc.w	$301F,$48A7,$4000,$4241,$122C,$0003,$B279,$0001
	dc.w	$7E98,$4C9F,$0002,$6D00,$0008,$4EB9,$0002,$AA80
	dc.w	$4240,$102C,$0004,$6B00,$0064,$08B9,$0005,$0001
	dc.w	$7F72,$6600,$0058,$4EB9,$0003,$8F6E,$0012,$BF0E
	dc.w	$0641,$7373,$6973,$7420,$6279,$3ABF,$0C07,$3F00
	dc.w	$6100,$0174,$4EB9,$0003,$8F80,$301F,$4EB9,$0002
	dc.w	$AA6A,$4240,$102C,$0005,$6B00,$0022,$4EB9,$0003
	dc.w	$8F6E,$0006,$BF0C,$0800,$3F00,$6100,$014A,$4EB9
	dc.w	$0003,$8F80,$301F,$4EB9,$0002,$AA6A,$08B9,$0005
	dc.w	$0001,$7F72,$4CDF,$1F07,$4E75,$000E,$BF0F,$0347
	dc.w	$4F41,$4C21,$BF0C,$0500,$0012,$BF0C,$0348,$4154
	dc.w	$2054,$5249,$434B,$21BF,$0C05,$0010,$BF0D,$0350
	dc.w	$5020,$474F,$414C,$21BF,$0C05,$0012,$BF0C,$0348
	dc.w	$4154,$2054,$5249,$434B,$21BF,$0C05,$4EB9,$0003
	dc.w	$8F6E,$0006,$FF0B,$0200,$7013,$7208,$243C,$0000
	dc.w	$07FF,$4EF9,$0003,$8C06,$48E7,$8020,$247C,$0001
	dc.w	$834C,$3039,$0001,$80EE,$6A00,$000A,$0240,$00FF
	dc.w	$D4FC,$0366,$6100,$0008,$4CDF,$0401,$4E75
getname						;gets player number and name, appends to string: a1 = mesarea "NN First
									;Last" for player d0 (roster offset) of team struct a2. The number is the
									;bcd byte after the name
	movem.l	d0-d3/a0/a2-a3,-(sp)
	bsr.w	X_26290		;get to start of player name
	move.l	a0,-(sp)		;push a0 (address to start of player name) to stack
	movea.l	#mesarea,a3		;move mesarea to a3 address
	move.w	#$4,(a3)		;move 4 into a3 address location
	lea.l	$2(a3),a1		;move long address at a3+2 into a1
	adda.w	(a0),a0		;add data at a0 (player name length) to a0
	move.b	(a0),d0		;move a0 data (jersey #) to d0
	bsr.w	ConvertByteToDigits		;convert JNo to ascii
	jsr	(appendz).l
	String	' '
	dc.w	$225F,$4EB9,$0003,$9208,$227C,$0001,$7EF2,$4CDF
	dc.w	$0D0F,$4E75
GetPlayerNumInitial						;a1 = mesarea "NN F. Last" (FormatPlayerNumInitial) for player
									;TempPlOffset (bit 15 set: away team). Called from ShowInjuryBox
	movem.l	d0/a2,-(sp)
	movea.l	#tmstruct,a2
	move.w	(TempPlOffset).l,d0
	bpl.w	.get
	andi.w	#$FF,d0
	adda.w	#$366,a2
.get	bsr.w	FormatPlayerNumInitial		;name for d0 of team a2
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
	dc.w	$48E7,$F0A0,$6100,$0076,$227C,$0001,$7EF4,$6000
	dc.w	$0014,$48E7,$F0A0,$6100,$0064,$227C,$0001,$7EF4
	dc.w	$12FC,$0020
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
