	include	segacd\hockey.inc
	include	macros\genesis.mac

Crowdlevel	equ	$17CD2
CwdExciteLvl	equ	$17CD8
RefCnt	equ	$1806E
SortCords	equ	$17480
awtmstruct	equ	$186B2
move	equ	$2C9C8
puckc	equ	$17BE0
puckvy	equ	$17BAA
pucky	equ	$17B94
sfx	equ	$3710C
tmstruct	equ	$1834C
X_16906	equ	$16906
X_16AB6	equ	$16AB6
X_18446	equ	$18446
X_1B212	equ	$1B212
X_1B2C4	equ	$1B2C4
X_1B2E4	equ	$1B2E4
X_1ED02	equ	$1ED02

	org	$17E16

	dc.w	$C1C0,$C3C1,$D081,$0C80,$0000,$0384,$6200,$000A
	dc.w	$4C9F,$0003,$6000,$002C,$6100,$425E,$7401,$D440
	dc.w	$7812,$0839,$0003,$0001,$7F6A,$6700,$0006,$0644
	dc.w	$0008,$4C9F,$0003,$C3C4,$0644,$0008,$C1C4,$81C2
	dc.w	$83C2,$D243,$3401,$0839,$0000,$0001,$7F78,$6600
	dc.w	$005A,$0839,$0002,$0001,$7F70,$6600,$004E,$0839
	dc.w	$0003,$0001,$7F6A,$6700,$0042,$0C79,$00D0,$0001
	dc.w	$7B94,$6E00,$0012,$0C79,$FF30,$0001,$7B94,$6D00
	dc.w	$0006,$6000,$0026,$0C6B,$0014,$0000,$6E00,$001C
	dc.w	$0C6B,$FFEC,$0000,$6D00,$0012,$0839,$0001,$0001
	dc.w	$80E7,$6600,$0006,$6000,$0026,$0C68,$0022,$0002
	dc.w	$6200,$006C,$0C50,$0018,$6E00,$00C4,$0C50,$FFE8
	dc.w	$6D00,$00BC,$0C68,$000C,$0002,$6200,$002A,$0C79
	dc.w	$0108,$0001,$7B94,$6E00,$001E,$0C79,$FEF8,$0001
	dc.w	$7B94,$6D00,$0012,$08EB,$0001,$0063,$6600,$0008
	dc.w	$4EB9,$0003,$30AC,$3010,$0C79,$00FC,$0001,$7B94
	dc.w	$6E00,$000E,$0C79,$FF04,$0001,$7B94,$6E00,$0010
	dc.w	$7018,$4A79,$0001,$AD58,$6A00,$0004,$4440,$3202
	dc.w	$48A7,$C000,$102B,$0028,$4880,$4440,$D05F,$906B
	dc.w	$0000,$122B,$002A,$4881,$4441,$D25F,$926B,$0014
	dc.w	$0C40,$0004,$6E00,$001E,$0C40,$FFFC,$6D00,$0016
	dc.w	$0C41,$0004,$6E00,$000E,$0C41,$FFFC,$6D00,$0006
	dc.w	$4240,$4241,$6100,$337C,$1740,$0043,$142B,$0043
	dc.w	$4882,$0C42,$0007,$6F00,$38EA,$6000,$3BB2,$4A79
	dc.w	$0001,$7BE0,$6A00,$FF98,$0839,$0002,$0001,$7ECE
	dc.w	$6600,$FF8C,$227C,$0001,$834C,$45E9,$0366,$082B
	dc.w	$0006,$0062,$6700,$0004,$C34A,$0CA9,$0000,$1324
	dc.w	$002C,$6D00,$FF6A,$0CAA,$0000,$09C4,$002C,$6D00
	dc.w	$FF5E,$0C79,$00E0,$0001,$7B94,$6E00,$000E,$0C79
	dc.w	$FF20,$0001,$7B94,$6E00,$FF46,$4A79,$0001,$7BAA
	dc.w	$082B,$0007,$0062,$6700,$0006,$0A3C,$0008,$6B00
	dc.w	$FF2E,$3039,$0001,$7BA8,$6A00,$0004,$4440,$3239
	dc.w	$0001,$7BAA,$6A00,$0004,$4441,$B240,$6D00,$FF10
	dc.w	$700F,$6000,$32AE
ClampYPosition						;d1 = y clamped to +-$103, minus goal line d3. d0 = 0 if a3 has the puck
	move.w	(puckc).l,d2
	cmp.w	$52(a3),d2		;is this player the puck carrier?
	bne.w	.0
	clr.w	d0		;carrier: d0 = 0
.0	cmpi.w	#$103,d1		;clamp d1 to the range -$103..$103
	blt.w	.1
	move.w	#$103,d1		;upper limit
.1	cmpi.w	#$FEFD,d1
	bgt.w	.2
	move.w	#$FEFD,d1
.2	sub.w	d3,d1
	rts
AdjustFacingDirection						;Turn facedir one step toward direction d0
	dc.w	$322B,$0054
	dc.w	$9041
	dc.w	$6700,$EA56
	dc.w	$4440
	dc.w	$0240,$0004
	dc.w	$E248
	dc.w	$0440,$0001
	dc.w	$082B,$0003,$0062
	dc.w	$6600,$002A
	dc.w	$033C,$0042,$6700
	dc.w	$0022,$D240
	dc.w	$082B,$0007,$0062
	dc.w	$6600,$000A
	dc.w	$033C,$0083,$6000
	dc.w	$0006,$033C
	dc.w	$0038,$6700,$0008
	dc.w	$4440
	dc.w	$D240
.l180A0	dc.w	$D240
	dc.w	$0241,$0007
	dc.w	$3741,$0054
	dc.w	$4E75
	dc.w	$3010,$906B,$0000,$3203,$926B,$0014,$6100,$323E
	dc.w	$906B,$0054,$0240,$0007,$3600,$E448,$082B,$0003
	dc.w	$0004,$6700,$0006,$0A40,$0001,$0C79,$0008,$0001
	dc.w	$7B98,$6E00,$0012,$0C79,$0800,$0001,$7BAC,$6E00
	dc.w	$0006,$6000,$0030,$48E7,$8000,$302B,$0000,$9050
	dc.w	$0C40,$0010,$6E00,$0016,$0C40,$FFF0,$6D00,$000E
	dc.w	$4CDF,$0001,$0640,$0006,$6000,$00C4,$4CDF,$0001
	dc.w	$6000,$00BC,$0640,$0004,$0C68,$0008,$0002,$6300
	dc.w	$0084,$0C6B,$0002,$0054,$6700,$00A4,$0C6B,$0006
	dc.w	$0054,$6700,$009A,$4A79,$0001,$7BE0,$6B00,$0090
	dc.w	$0440,$0002,$3F01,$323C,$1000,$3741,$0028,$0040
	dc.w	$0001,$082B,$0007,$0062,$6600,$0006,$0A40,$0001
	dc.w	$323C,$FFFA,$4A6B,$0028,$6B00,$0006,$446B,$0028
	dc.w	$4A6B,$0000,$6A00,$0016,$4A6B,$0028,$6A00,$0006
	dc.w	$446B,$0028,$323C,$0006,$0A40,$0001,$D36B,$0000
	dc.w	$082B,$0000,$0076,$6700,$0006,$0A40,$0001,$321F
	dc.w	$6000,$002C,$48E7,$8000,$302B,$0000,$9050,$0C40
	dc.w	$0010,$6F00,$000A,$4CDF,$0001,$6000,$000E,$0C40
	dc.w	$FFF0,$4CDF,$0001,$6E00,$0006,$0640,$0004,$D040
	dc.w	$43FA,$004A,$3231,$0000,$0C41,$0178,$6600,$0018
	dc.w	$0243,$0003,$6700,$0010,$0C2B,$000B,$0073,$6D00
	dc.w	$0006,$323C,$01AA,$6100,$31BC,$0679,$0096,$0001
	dc.w	$7CD2,$0679,$000A,$0001,$7CD8,$E0EB,$0028,$E0EB
	dc.w	$0028,$E0EB,$002A,$E0EB,$002A,$4E75,$0146,$0178
	dc.w	$0250,$02A2,$01EC,$021E,$148E,$14C0,$14F2,$1544
assgoalietopuck						;goalie skates out to a loose puck (inserted by
									;assgoalie)
	btst	#$3,$62(a3)		;human controlled goalie: nothing to do
	bne.w	X_1B2C4
	btst	#$0,$17F68.l		;clock stopped: nothing to do
	bne.w	X_1B2C4
	bsr.w	X_16906
	bclr	#$1,$62(a3)		;new assignment? (clears the flag)
	beq.w	.0
	clr.w	$40(a3)
.0	sub.b	d7,$40(a3)		;count the timer down by d7 (elapsed frames)
	bpl.w	.go		;still running: keep skating to the puck
	move.b	$6B(a3),d0		;aidef
	beq.w	.1
	btst	#$6,$17F7A.l
	beq.w	.1
	subi.b	#$1,d0
.1	lsr.b	#$2,d0
	move.b	d0,$40(a3)		;reload timer = defensive rating / 4
	tst.w	(puckc).l
	bpl.w	X_1B2C4		;someone has the puck: stay
	tst.w	(puckvy).l		;N = puck y velocity sign
	btst	#$7,$62(a3)
	beq.w	.dir
	eori.b	#$8,ccr		;flip N for the other goal end
.dir	bmi.w	X_1B2C4		;puck moving away from this goalie
	movea.l	#tmstruct,a1		;load home team struct into a1
	lea.l	$366(a1),a2		;load away team struct into a2
	btst	#$6,$62(a3)		;check if player is home or away
	beq.w	.t0		;branch if home
	exg.l	a1,a2		;swap if away
.t0	cmpi.l	#$E10,$2C(a1)		;each team's nearest distance^2 (tmnear) vs limits
	blt.w	X_1B2C4
	cmpi.l	#$640,$2C(a2)
	blt.w	X_1B2C4
.go	bra.w	X_1B212
breakaway						;puck carrier a3 on a breakaway: beep on a new assignment and check the
									;skating direction toward the net
	bset	#$2,$17F74.l
	bclr	#$1,$62(a3)		;pfna - clear new assignment
	beq.w	.nna		;jump if no new assignment
	move.w	#$2,-(sp)		;ding SFX
	jsr	(sfx).l
	movem.l	a2,-(sp)		;push a2 on stack
	movea.l	#tmstruct,a2		;move Home Team Struct into a2
	btst	#$6,$62(a3)		;pfteam - check if home or away
	beq.w	.c0		;jump if home
	movea.l	#awtmstruct,a2		;move Away Team Struct into a2
.c0	addi.w	#$1,$35A(a2)		;add one to breakaway attempt
	addi.w	#$14,(CwdExciteLvl).l		;add to CwdExcite
	addi.w	#$C8,(Crowdlevel).l		;add to Crowdlevel
	movem.l	(sp)+,a2
.nna	movem.w	d1,-(sp)		;push d1 on stack
	move.w	$14(a3),d0		;move Ypos into d0
	move.w	$2A(a3),d1		;move Yvel into d1
	beq.w	.yvel0		;jump if Yvel = 0
	eor.w	d1,d0		;EOR d1 with d0. d0 will be negative if skating opposite direction of net
.exit	movem.w	(sp)+,d1		;pop d1 off stack
	rts
.yvel0	move.w	#$FFFF,d1
	bra.w	.exit
BreakawayOffsidesFlagSet						;On a new assignment clear the offsides and breakaway bits of a3. Behind
									;the goal line or not yet in the attack zone set pf3oside, else end the
									;assignment
	btst	#$1,$62(a3)		;check for new assignment
	beq.w	.loadYpos		;branch if no new assignment
	bclr	#$0,$64(a3)		;clear player offsides flag
	bclr	#$1,$64(a3)		;clear player breakaway flag
.loadYpos	movem.w	d0-d1/a0,-(sp)
	move.w	#$108,d0		;108 = top goal line Y pos
	move.w	$14(a3),d1		;Ypos
	bpl.w	.cmpgoalline		;branch if Ypos is positive
	neg.w	d1		;negate d1
.cmpgoalline	cmp.w	d0,d1		;compare position to top goal line
	bge.w	.nogood		;Branch if above it
	move.w	#$58,d0		;58 = top blue line Y pos
	move.w	$14(a3),d1		;Ypos
	btst	#$7,$62(a3)		;check goal to shoot on (0=bottom, 1=top)
	bne.w	.top		;branch if top goal
	neg.w	d0		;bottom goal, so negate d0
	cmp.w	d1,d0		;compare Ypos to blue line Y
	blt.w	.setoffside		;branch if not in attack zone
	bra.w	.offzone		;branch if in attack zone
.top	cmp.w	d1,d0		;compare Ypos to blue line Y
	blt.w	.offzone		;branch if in offensive zone
.setoffside	bset	#$0,$64(a3)		;set offsides flag
	bra.w	.nogood
.offzone	bclr	#$0,$64(a3)		;clear offside bit
	beq.w	.nogood		;branch if on the blue line
	movea.l	#$17A00,a0		;loads last SCScruct player struct (Away pos #6)
	move.w	#$B,d0		;B = # of player structs to check (12)
	tst.w	d1		;checks if d1 is negative (determines what zone to check)
	bmi.w	.checkYpos
.checkYpos2	cmp.w	$14(a0),d1		;compare Ypos of a0 player to d1 (Ypos puckc)
	bge.w	.substruct2		;branch if d1 greater than or equal
	tst.w	$34(a0)		;check if goalie
	beq.w	.substruct2		;branch if goalie
	bra.w	.nogood
.substruct2	suba.w	#$80,a0
	dbra	d0,.checkYpos2
.setBAbit	bset	#$1,$64(a3)		;set breakaway bit
	move.w	#$1,d0		;moves 1 into d0 (used by returned subroutine)
.exit	movem.w	(sp)+,d0-d1/a0
	rts
.nogood	move.w	#$0,d0		;move 0 into d0 (used on return to subroutine)
	bra.w	.exit
.checkYpos	cmp.w	$14(a0),d1		;check Ypos with d1 (d1 = blue line Y)
	ble.w	.substruct
	tst.w	$34(a0)		;checks if goalie (who would be below blue line)
	beq.w	.substruct
	bra.w	.nogood
.substruct	suba.w	#$80,a0		;subtract SCstruct size (80 hex)
	dbra	d0,.checkYpos
	bra.w	.setBAbit
chkpuckc						;puck carrier a3: check for a breakaway (not in a shootout or penalty
									;shot), else assign asspuckc
	btst	#$0,$17F78.l
	bne.w	.0
	btst	#$2,$17F70.l
	bne.w	.0
	bsr.w	breakaway
	bpl.w	X_18446		;currently skating towards net in Y
.0	bclr	#$1,$64(a3)		;clear breakaway bit
	move.w	#$10,d0		;asspuckc
	bsr.w	X_1B2E4
	dc.w	$08B9,$0002,$0001,$7F74,$6600,$0008,$08AB,$0001
	dc.w	$0064,$3039,$0001,$7BE0,$B06B,$0052,$6600,$2E60
	dc.w	$0839,$0002,$0001,$7F70,$6700,$000E,$0C79,$0001
	dc.w	$0001,$7F98,$6E00,$034C,$082B,$0001,$0064,$6600
	dc.w	$0024,$0839,$0002,$0001,$7F70,$6600,$0018,$4EB9
	dc.w	$0003,$334E,$6700,$000E,$303C,$0021,$6100,$2E40
	dc.w	$6000,$0002,$082B,$0005,$0062,$6600,$0316,$0839
	dc.w	$0002,$0001,$7F70,$6600,$000E,$0839,$0000,$0001
	dc.w	$7F68,$6600,$E9E8,$082B,$0003,$0062,$6600,$2DF0
	dc.w	$08AB,$0001,$0062,$6700,$00B2,$082B,$0001,$0064
	dc.w	$6700,$000C,$3F3C,$0002,$4EB9,$0003,$710C,$082B
	dc.w	$0001,$0064,$6700,$0036,$48E7,$0020,$247C,$0001
	dc.w	$834C,$082B,$0006,$0062,$6700,$0008,$247C,$0001
	dc.w	$86B2,$066A,$0001,$035A,$0679,$0014,$0001,$7CD8
	dc.w	$0679,$00C8,$0001,$7CD2,$4CDF,$0400,$426B,$0040
	dc.w	$377C,$0008,$0042,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$33FC,$001B,$00FF,$8020,$08F9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$67F6,$3039,$00FF,$8010
	dc.w	$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF
	dc.w	$800F,$0240,$0003,$3740,$0044,$9F2B,$0040,$6A00
	dc.w	$00BC,$176B,$006A,$0040,$4EB9,$0002,$AEDC,$6B00
	dc.w	$0016,$0839,$0006,$0001,$7F7A,$6700,$0010,$4A2B
	dc.w	$0040,$6700,$0008,$042B,$0001,$0040,$0839,$0002
	dc.w	$0001,$7F70,$6600,$0072,$0839,$0000,$0001,$7F78
	dc.w	$6600,$0066,$6100,$0744,$6100,$0212,$0839,$0000
	dc.w	$0001,$7F78,$6600,$0052,$0839,$0002,$0001,$7F70
	dc.w	$6600,$0046,$082B,$0001,$0064,$6600,$0034,$303C
	dc.w	$0001,$082B,$0006,$0062,$6700,$0006,$303C,$0002
	dc.w	$B079,$0001,$7FA6,$6700,$0018,$B079,$0001,$7FA8
	dc.w	$6700,$000E,$0839,$0001,$0001,$7475,$6600,$001A
	dc.w	$6100,$02B0,$6000,$0012,$4EB9,$0002,$A84A,$6600
	dc.w	$000C,$4EB9,$0003,$3AC8,$6100,$04AA,$7006,$D06B
	dc.w	$0044,$41FA,$0170,$0839,$0007,$0001,$7F6C,$6700
	dc.w	$0006,$302B,$0034,$E540,$3230,$0002,$3030,$0000
	dc.w	$0839,$0002,$0001,$7F70,$6600,$000E,$0839,$0000
	dc.w	$0001,$7F78,$6700,$0014,$4EB9,$0002,$A7B6,$0C39
	dc.w	$0080,$0001,$A8B8,$6700,$012A,$082B,$0007,$0062
	dc.w	$6600,$0006,$4440,$4441,$41FA,$0022,$0839,$0002
	dc.w	$0001,$7F70,$6600,$000E,$0839,$0000,$0001,$7F78
	dc.w	$6700,$0006,$41FA,$00FC,$6000,$2938,$4880,$142B
	dc.w	$0028,$4882,$D479,$0001,$7B80,$162B,$002A,$4883
	dc.w	$D679,$0001,$7B94,$4279,$0001,$7E34,$7805,$207C
	dc.w	$0001,$7480,$0C6B,$0006,$0052,$6C00,$0006,$D0FC
	dc.w	$0300,$1228,$0028,$4881,$D268,$0000,$9242,$0C41
	dc.w	$0014,$6E00,$00A6,$0C41,$FFEC,$6D00,$009E,$1228
	dc.w	$002A,$4881,$D268,$0014,$9243,$0C41,$0014,$6E00
	dc.w	$008A,$0C41,$FFEC,$6D00,$0082,$0679,$0001,$0001
	dc.w	$7E34,$302B,$0000,$9068,$0000,$322B,$0014,$9268
	dc.w	$0014,$6100,$2B9E,$322B,$0054,$0A41,$0004,$B240
	dc.w	$6600,$0058,$0839,$0007,$00FF,$800E,$66F6,$33FC
	dc.w	$001B,$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$67F6,$3239,$00FF,$8010,$08F9
	dc.w	$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F
	dc.w	$0241,$0001,$D041,$0240,$0007,$D0FC,$0080,$51CC
	dc.w	$FF42,$4E75,$FF9C,$FFEC,$0064,$FFEC,$FF88,$0028
	dc.w	$0014,$0028,$0078,$0028,$FFEC,$0028,$FFD8,$00F0
	dc.w	$0000,$00DC,$0014,$00E6,$001E,$00E6,$0839,$0004
	dc.w	$0001,$7F7A,$6600,$00B8,$3039,$0001,$7B94,$082B
	dc.w	$0007,$0062,$6600,$0004,$4440,$4A40,$6B00,$E2A2
	dc.w	$0C40,$0058,$6E00,$E29A,$0839,$0007,$00FF,$800E
	dc.w	$66F6,$33FC,$001B,$00FF,$8020,$08F9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$67F6,$3039,$00FF
	dc.w	$8010,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$0240,$0003,$6600,$E246,$082B,$0003
	dc.w	$0063,$6600,$E23C,$247C,$0001,$834C,$43EA,$0366
	dc.w	$082B,$0006,$0062,$6700,$0004,$C34A,$4EB9,$0003
	dc.w	$C7E2,$0C40,$0C00,$6200,$E218,$6100,$1878,$4EB9
	dc.w	$0003,$D426,$4EB9,$0003,$C48C,$6000,$0216,$4E75
	dc.w	$0839,$0005,$0001,$7F6C,$6600,$0008,$0A3C,$0004
	dc.w	$4E75
chkpk2						;return z flag set if a3's team is the one on the power play (sf2pwrtm
									;against pfteam)
	movem.l	d0-d1,-(sp)
	btst	#$6,$17F6C.l		;#sf2pwrtm - 0 for team 1, 1 for team 2
	move.w	sr,d0
	btst	#$6,$62(a3)		;pfteam - 0 home, 1 away
	move.w	sr,d1
	eor.w	d1,d0
	move.w	d0,ccr
	movem.l	(sp)+,d0-d1
	rts
	dc.w	$6100,$FFCC,$6600,$0098,$4A79,$0001,$7E34,$6700
	dc.w	$008E,$0839,$0007,$00FF,$800E,$66F6,$33FC,$001B
	dc.w	$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$67F6,$3039,$00FF,$8010,$08F9,$0007
	dc.w	$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F,$0240
	dc.w	$0003,$6600,$003A,$303C,$0058,$082B,$0007,$0062
	dc.w	$6700,$0012,$303C,$FFA8,$B06B,$0014,$6D00,$0162
	dc.w	$6000,$000A,$B06B,$0014,$6E00,$0156,$08F9,$0003
	dc.w	$0001,$7F74,$4EF9,$0003,$0EF0,$6000,$0144,$082B
	dc.w	$0001,$0064,$6700,$0044,$303C,$001E,$4EB9,$0003
	dc.w	$7050,$0640,$0082,$B079,$0001,$7B94,$6D00,$0012
	dc.w	$4440,$B079,$0001,$7B94,$6E00,$0006,$6000,$001C
	dc.w	$303C,$0002,$4EB9,$0003,$7044,$D06B,$0054,$0240
	dc.w	$0007,$3740,$0054,$6000,$00F8,$7820,$4241,$122B
	dc.w	$0070,$E249,$9801,$E944,$323C,$0108,$082B,$0007
	dc.w	$0062,$6600,$0004,$4441,$9279,$0001,$7B94,$3039
	dc.w	$0001,$7B80,$4440,$48A7,$C000,$C1C0,$C3C1,$D280
	dc.w	$0C81,$0000,$2710,$4C9F,$0003,$6200,$0062,$E84C
	dc.w	$6100,$28DE,$3A00,$7605,$227C,$0001,$7480,$0C6B
	dc.w	$0006,$0052,$6C00,$0006,$D2FC,$0300,$4A69,$0034
	dc.w	$6700,$0026,$3029,$0000,$9079,$0001,$7B80,$3229
	dc.w	$0014,$9279,$0001,$7B94,$6100,$28A6,$B045,$6600
	dc.w	$0016,$E344,$6000,$0010,$0829,$0001,$0063,$6700
	dc.w	$0006,$4243,$7801,$D2FC,$0080,$51CB,$FFC0,$3004
	dc.w	$6100,$35D6,$082B,$0000,$0070,$6700,$000E,$0C40
	dc.w	$0007,$6E00,$E02A,$6000,$000A,$0C40,$0008,$6E00
	dc.w	$E01E,$3039,$0001,$7B94,$082B,$0007,$0062,$6600
	dc.w	$0004,$4440,$4A40,$6B00,$E006,$323C,$0108,$9240
	dc.w	$6B00,$DFFC,$0839,$0007,$0001,$7F6C,$6600,$DFF0
CompShoot						;computer shot: drop the return address and aim from the puck's distance
									;to the goal line
	adda.w	#$4,sp		;don't return
	move.w	(pucky).l,d0
	btst	#$7,$62(a3)
	bne.w	.ds0
	neg.w	d0
.ds0	move.w	#$108,d1		;d0 is now puck y toward the goal I shoot at
	sub.w	d0,d1		;d1 = distance to $108 along the shooting direction
	lsr.w	#$3,d1
	cmpi.w	#$14,d1
	blt.w	.0
	moveq	#$14,d1
.0	move.w	d1,$42(a3)
	moveq	#$12,d0
	bra.w	X_1B2E4
	dc.w	$4A79,$0001,$7E34,$6600,$0014,$7010,$D02B,$0070
	dc.w	$6100,$3544,$0C40,$000C,$6E00,$DFA2,$7006,$6100
	dc.w	$3536,$0C6B,$0006,$0052,$6D00,$0006,$0640,$0006
	dc.w	$4A6B,$0034,$6700,$0032,$0C79,$0028,$0001,$7B80
	dc.w	$6E00,$0026,$0C79,$FFD8,$0001,$7B80,$6D00,$001A
	dc.w	$0C79,$00CC,$0001,$7B94,$6E00,$DF62,$0C79,$FF34
	dc.w	$0001,$7B94,$6D00,$DF56,$B06B,$0052,$6700,$DF4E
	dc.w	$EF40,$207C,$0001,$7480,$D0C0,$4A68,$0034,$6F00
	dc.w	$DF3C,$0828,$0002,$0063,$6600,$DF32,$0828,$0005
	dc.w	$0062,$6600,$DF28,$3028,$0014,$322B,$0014,$082B
	dc.w	$0007,$0062,$6600,$0006,$4440,$4441,$0839,$0005
	dc.w	$0001,$7F68,$6700,$0018,$48A7,$C000,$0440,$0058
	dc.w	$0441,$0058,$B141,$4C9F,$0003,$6B00,$DEF0,$0C40
	dc.w	$0058,$6E00,$000C,$9041,$0C40,$FFF1,$6D00,$DEDE
	dc.w	$3028,$0000,$9079,$0001,$7B80,$3228,$0014,$9279
	dc.w	$0001,$7B94,$48A7,$C000,$6100,$2704,$33C0,$0001
	dc.w	$7E2C,$4C9F,$0006,$C3C1,$C5C2,$D481,$7605,$227C
	dc.w	$0001,$7480,$0C6B,$0006,$0052,$6C00,$0006,$D2FC
	dc.w	$0300,$3029,$0000,$9079,$0001,$7B80,$3229,$0014
	dc.w	$9279,$0001,$7B94,$48A7,$C000,$C1C0,$C3C1,$D280
	dc.w	$B282,$4C9F,$0003,$6200,$0010,$6100,$26B2,$B079
	dc.w	$0001,$7E2C,$6700,$DE66,$D2FC,$0080,$51CB,$FFC4
	dc.w	$6100,$D294,$4A6B,$0034,$6700,$DE52,$DEFC,$0004
	dc.w	$6000,$2658,$4A79,$0001,$7BE0,$6B00,$DE40,$142B
	dc.w	$0028,$9439,$0001,$7BA8,$4882,$D46B,$0000,$9479
	dc.w	$0001,$7B80,$0C42,$0028,$6E00,$DE22,$0C42,$FFD8
	dc.w	$6D00,$DE1A,$122B,$002A,$9239,$0001,$7BAA,$4881
	dc.w	$D26B,$0014,$9279,$0001,$7B94,$0C41,$0028,$6E00
	dc.w	$DDFC,$0C41,$FFD8,$6D00,$DDF4,$302B,$0000,$9079
	dc.w	$0001,$7B80,$322B,$0014,$9279,$0001,$7B94,$6100
	dc.w	$261E,$0839,$0005,$0001,$7F68,$6700,$0038,$322B
	dc.w	$0014,$082B,$0007,$0062,$6600,$0004,$4441,$0441
	dc.w	$0058,$0C41,$000A,$6E00,$001C,$0C41,$FFCE,$6D00
	dc.w	$0014,$7002,$322B,$0000,$B279,$0001,$7B80,$6E00
	dc.w	$0004,$7006,$4E75
checkob						;bring up little warning ref if a player on your team is over blue line
	btst	#$5,$17F68.l
	beq.w	X_16AB6
	btst	#$2,$17F70.l
	bne.w	.l18D94
	movem.l	d0-d1/a0,-(sp)
	moveq	#$5,d0		;6 players of a3's team
	movea.l	#SortCords,a0
	cmpi.w	#$6,$52(a3)
	blt.w	.0
	adda.w	#$300,a0		;a0 = first sort object of a3's team
.0	moveq	#$5C,d1
	btst	#$7,$62(a3)
	bne.w	.top		;shooting at the top goal: mirrored tests below
	neg.w	d1		;d1 = -$5C
	cmp.w	(pucky).l,d1
	bgt.w	.nob		;puck already across the line: nobody can be offside
.bottom	tst.w	$34(a0)		;loop over the team, skipping negative positions
	bmi.w	.bn
	cmp.w	$14(a0),d1
	bgt.w	.ob		;this player is over the line
.bn	adda.w	#$80,a0
	dbra	d0,.bottom
.nob	moveq	#$40,d0		;no one offside: d0 = $40 = clear the ref window (PushRef)
	bclr	#$7,$17F6C.l		;clear the offsides ref flag
	bne.w	.dref		;it was on: update the ref
.ex	movem.l	(sp)+,d0-d1/a0
.l18D94	rts
.ob	moveq	#$6,d0
	bset	#$7,$17F6C.l		;someone is offsides: show the little ref
	bne.w	.ex		;already shown
.dref	tst.w	(RefCnt).l		;only when the ref queue is idle (negative)
	bpl.w	.ex
	bsr.w	X_1ED02
	bra.w	.ex
.top	cmp.w	(pucky).l,d1
	blt.w	.nob
.top1	tst.w	$34(a0)		;loop over the team's players (top goal)
	bmi.w	.tn
	cmp.w	$14(a0),d1
	blt.w	.ob
.tn	adda.w	#$80,a0		;next player
	dbra	d0,.top1
	bra.w	.nob
