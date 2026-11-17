	include	segacd\hockey.inc
	include	macros\genesis.mac

CountButtonPress	equ	$2AD3A
LOAD	equ	$1B000
OptLine	equ	$18C0A
PuckOnAttackHalf	equ	$22CA4
SortCords	equ	$17480
TempWord1	equ	$17E62
assreplace	equ	$362E4
c1playernum	equ	$17F9E
c2playernum	equ	$17FA0
cont1team	equ	$17FA6
cont2team	equ	$17FA8
dirtab	equ	$36B8E
eraser	equ	$38C06
getpde	equ	$3C2A0
goaliemode1	equ	$18C0C
goaliemode2	equ	$18C0E
inputjoy	equ	$1AD7A
lastplayer	equ	$17E2A
move	equ	$2C9C8
passReceiverPlayerNum	equ	$17E30
passdir	equ	$17E2C
passmodetimer	equ	$17F9A
passspeed	equ	$17E2E
printy	equ	$18D5A
puckc	equ	$17BE0
pucky	equ	$17B94
setc1player	equ	$312B8
setc2player	equ	$312DC
setpde	equ	$3C2C2
tmstruct	equ	$1834C
X_15606	equ	$15606
X_15A6E	equ	$15A6E
X_15B08	equ	$15B08
X_15B50	equ	$15B50
X_15C08	equ	$15C08
X_15C9E	equ	$15C9E
X_15D64	equ	$15D64
X_15EC4	equ	$15EC4
X_15EF0	equ	$15EF0
X_16170	equ	$16170
X_16176	equ	$16176
X_1617A	equ	$1617A
X_162A4	equ	$162A4
X_163CA	equ	$163CA
X_16528	equ	$16528
X_167B6	equ	$167B6
X_18D20	equ	$18D20
X_1B3C0	equ	$1B3C0
X_1B3D6	equ	$1B3D6

	org	$15798

	dc.w	$3439,$0001,$7BE0,$B46B,$0052,$6600,$0004,$4240
	dc.w	$0C41,$0103,$6D00,$0006,$323C,$0103,$0C41,$FEFD
	dc.w	$6E00,$0006,$323C,$FEFD,$9243,$4E75,$0146,$0178
	dc.w	$0250,$02A2,$01EC,$021E,$148E,$14C0,$14F2,$1544
	dc.w	$082B,$0001,$0063,$6700,$0004,$4E75,$4A6B,$0034
	dc.w	$6600,$5BEC,$08B9,$0001,$0001,$7F70,$0C6B,$0024
	dc.w	$0000,$6F00,$001A,$4A6B,$0028,$6B00,$0012,$6700
	dc.w	$000E,$08F9,$0001,$0001,$7F70,$426B,$0028,$0C6B
	dc.w	$FFDC,$0000,$6C00,$0016,$4A6B,$0028,$6A00,$000E
	dc.w	$08F9,$0001,$0001,$7F70,$426B,$0028,$0C6B,$00E7
	dc.w	$0014,$6E00,$003A,$0C6B,$FF19,$0014,$6F00,$0030
	dc.w	$6000,$0002,$48A7,$C000,$302B,$0014,$322B,$002A
	dc.w	$B340,$4C9F,$0003,$6A00,$0016,$4A6B,$002A,$6700
	dc.w	$000E,$08F9,$0001,$0001,$7F70,$426B,$002A,$0839
	dc.w	$0001,$0001,$7F70,$6600,$FD86,$3039,$0001,$7E62
	dc.w	$6000,$5B4C
doinput_onetimer						;a3 is set for a one-timer: C (bit 5) starts the one-timer shot, else
									;skate
	move.w	(TempWord1).l,d0
	btst	#$3,$64(a3)
	bne.w	X_15A6E
	btst	#$5,d1
	beq.w	X_1B3D6
	movem.l	d7/a0,-(sp)
	move.w	(lastplayer).l,d7
	asl.w	#$7,d7
	movea.l	#SortCords,a0
	adda.w	d7,a0
	tst.w	$34(a0)
	movem.l	(sp)+,d7/a0
	beq.w	burst
	movem.w	d7,-(sp)
	move.w	$52(a3),d7
	cmp.w	(passReceiverPlayerNum).l,d7
	movem.w	(sp)+,d7
	bne.w	burst
	tst.w	(puckc).l
	bpl.w	burst
	jsr	(PuckOnAttackHalf).l
	beq.w	burst
	move.w	d0,-(sp)
	move.w	d4,(inputjoy).l
	move.w	$17F96.l,$1AD7C.l
	move.w	#$23,d0		;assonetimer
	jsr	(assreplace).l
	move.w	(sp)+,d0
	rts
doinput_ispc						;a3 has the puck: pass mode, shot mode, or start a pass / shot by the
									;buttons
	bsr.w	X_18D20
	tst.w	$34(a3)
	bne.w	.0
	btst	#$1,$63(a3)
	bne.w	X_15606
.0	btst	#$2,$17F6A.l
	bne.w	passmode
	btst	#$3,$17F6A.l
	bne.w	ShotMode
	btst	#$4,d1
	beq.w	.1
	jsr	(CountButtonPress).l
	bra.w	setpassmode
.1	btst	#$6,d1
	beq.w	.ahold
	tst.w	d4
	beq.w	.2
	move.b	#$F,$19381.l
	bra.w	.ahold
.2	move.b	#$F,$19380.l
.ahold	btst	#$6,d3
	beq.w	.arel
	tst.w	d4
	beq.w	.c1
	subi.b	#$1,$19381.l
	bpl.w	.4
	move.b	#$0,$19381.l
.4	tst.b	$19381.l
	bne.w	.arel
	bset	#$3,$17F74.l
	jsr	(setpassmode+LOAD).l
	bra.w	X_15B08
.c1	subi.b	#$1,$19380.l
	bpl.w	.6
	move.b	#$0,$19380.l
.6	tst.b	$19380.l
	bne.w	.arel
	bset	#$3,$17F74.l
	jsr	(setpassmode+LOAD).l
	bra.w	X_15B08
.arel	btst	#$6,d3
	bne.w	.8
	btst	#$6,d2
	beq.w	.8
	bset	#$3,$17F74.l
	bra.w	setpassmode
.8	tst.w	$34(a3)
	bne.w	.shot
	bra.w	X_1B3D6
.shot	btst	#$5,d1
	beq.w	X_1B3D6
	jsr	(CountButtonPress).l
	bra.w	X_163CA
doinput_islocked						;a3 is locked in an animation: B (bit 4) changes the controlled player
	move.w	(puckc).l,d5
	cmp.w	$52(a3),d5
	beq.w	X_15606
	btst	#$4,d1
	beq.w	X_15A6E
	btst	#$6,$17F74.l
	bne.w	X_15A6E
	bsr.w	X_162A4
	movem.l	d0/a0,-(sp)
	move.w	(c1playernum).l,d0
	tst.w	d4
	beq.w	.0
	move.w	(c2playernum).l,d0
.0	tst.w	d0
	bmi.w	.x
	asl.w	#$7,d0
	movea.l	#SortCords,a0
	adda.w	d0,a0
	bset	#$6,$64(a0)
.x	movem.l	(sp)+,d0/a0
	dc.w	$4E75
getGoalieSCnum						;d0 = SCnum of the goalie in the 6 sort objects
									;up to object d0, -1 if none
	movem.l	d1/a0,-(sp)
	movea.l	#SortCords,a0
	asl.w	#$7,d0
	adda.w	d0,a0
	move.w	#$5,d1
.loop	tst.w	$34(a0)
	beq.w	.goalie
	suba.w	#$80,a0
	dbra	d1,.loop
	move.w	#$FFFF,d0
	bra.w	.end
.goalie	move.w	$52(a0),d0
.end	movem.l	(sp)+,d1/a0
	rts
	dc.w	$0839,$0006,$0001,$7F74,$6700,$0004,$4E75,$382B
	dc.w	$0036,$0C33,$0017,$4038,$6600,$FFB0,$207C,$0001
	dc.w	$7EE6,$082B,$0007,$0062,$6700,$0008,$207C,$0001
	dc.w	$7EE8,$3080,$082B,$0001,$0063,$6700,$0008,$4EF9
	dc.w	$0003,$0AB0,$0801,$0004,$6700,$0010,$323C,$0FEA
	dc.w	$08EB,$0001,$0063,$6000,$58C4,$323C,$1014,$6000
	dc.w	$58BC,$4E75,$4A79,$0001,$8C0A,$6600,$FF5E,$0839
	dc.w	$0004,$0001,$7F7A,$6600,$FF52,$4EB9,$0003,$C958
	dc.w	$08EA,$0001,$0032,$6600,$FF42,$0839,$0003,$0001
	dc.w	$7F74,$6600,$000A,$08B9,$0002,$0001,$7F6A,$08B9
	dc.w	$0003,$0001,$7F6A,$08EB,$0003,$0063,$6100,$00B6
	dc.w	$0C79,$000F,$0001,$8D5A,$6D00,$000E,$08F9,$0000
	dc.w	$0001,$7F6E,$6000,$000C,$4EB9,$0004,$10EC,$6100
	dc.w	$0094,$4EB9,$0003,$8CA0,$0479,$0002,$0001,$8D5A
	dc.w	$0679,$0001,$0001,$8D58,$7802,$3004,$6100,$00C6
	dc.w	$4A40,$6B00,$0054,$082A,$0001,$0032,$6600,$000E
	dc.w	$B86A,$0030,$6600,$003A,$302A,$0016,$227C,$0001
	dc.w	$7EF2,$22BC,$0004,$4120,$D929,$0002,$4EB9,$0003
	dc.w	$8F80,$3F00,$227C,$0004,$19F6,$4EB9,$0003,$CEBE
	dc.w	$301F,$4EB9,$0003,$C746,$0479,$0005,$0001,$8D58
	dc.w	$0479,$0001,$0001,$8D5A,$51CC,$FFA0,$226A,$001E
	dc.w	$D2E9,$0004,$D2D1,$0679,$0002,$0001,$8D58,$4EF9
	dc.w	$0003,$8F80,$4240,$B5FC,$0001,$834C,$6600,$0006
	dc.w	$0A40,$0016,$0839,$0001,$0001,$7F68,$6700,$0006
	dc.w	$0A40,$0016,$4EB9,$0003,$8F6E,$0006,$BF16,$0000
	dc.w	$D179,$0001,$8D5A,$7002,$6100,$001A,$7206,$4A40
	dc.w	$6A00,$000E,$0441,$0001,$0679,$0001,$0001,$8D5A
	dc.w	$7009,$4E75,$48E7,$6000,$342A,$038C,$B5FC,$0001
	dc.w	$834C,$6700,$0006,$342A,$FCC0
getlchoice2						;add $15 to d0 for each player more or fewer than the other team has on
									;the ice
	sub.w	$26(a2),d2
	beq.w	.0
	addi.w	#$15,d0
	tst.w	d2
	bmi.w	.0
	addi.w	#$15,d0
.0	move.w	$16(a2),d1
	add.w	d1,d0
	add.w	d1,d0
	add.w	d1,d0
	lea.l	X_15C9E(pc),a0
	move.b	(a0,d0.w),d0
	ext.w	d0
	movem.l	(sp)+,d1-d2
	rts
	dc.w	$0001,$0201,$0200,$0200,$0100,$0102,$0001,$0200
	dc.w	$0102,$0001,$0203,$04FF,$0304,$FF03,$04FF,$0304
	dc.w	$FF04,$03FF,$0304,$FF03,$04FF,$0506,$FF05,$06FF
	dc.w	$0506,$FF05,$06FF,$0506,$FF05,$06FF,$0605,$FF00
lineinput						;process input for line changes
									;d1 = new button presses
	btst	#$3,$17F74.l
	beq.w	.0
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(passmode+LOAD).l
	movem.l	(sp)+,d0-d7/a0-a6
.0	move.w	d1,-(sp)
	movea.l	#tmstruct,a2
	btst	#$6,$62(a3)
	beq.w	.2
	adda.w	#$366,a2
.2	bclr	#$0,$32(a2)		;Flag to start lc mode
	beq.w	.1
	bsr.w	lcfound_close		;close the old box
	bsr.w	X_15B50		;start lc mode
.1	move.w	(sp)+,d1
	clr.w	d2
	btst	#$6,d1
	bne.w	X_15D64
	addi.w	#$1,d2
	btst	#$4,d1
	bne.w	X_15D64
	addi.w	#$1,d2
	btst	#$5,d1
	bne.w	X_15D64
	btst	#$3,$62(a3)
	beq.w	.x
	btst	#$5,$62(a3)
	bne.w	.x
	btst	#$0,$63(a3)
	beq.w	X_1B3D6		;skate with dpad if not fighting
.x	rts
	dc.w	$3002,$3542,$0030,$6100,$FEEC,$4A40,$6A00,$0008
	dc.w	$4EF9,$0003,$0AB0,$08AB,$0003,$0063,$08EB,$0003
	dc.w	$0062,$4EB9,$0003,$C958,$08AA,$0001,$0032,$3540
	dc.w	$0016,$4EB9,$0003,$D426
lcfound_close						;close lc box
	btst	#$7,$17F6A.l
	bne.w	X_15EC4
	bsr.w	X_15C08
	cmpi.w	#$F,(printy).l
	blt.w	.nollcm
	bclr	#$0,$17F6E.l
.nollcm	addi.w	#$1,d1		;d1 = 1 and d2 = $7FF tile: erase the box area
	move.w	#$7FF,d2
	bsr.w	eraser-LOAD
	jmp	$3C48C.l
burst						;cbut press check/speed. Also entered from check4check burst costs energy
									;$CC (only when line changes are on, OptLine = 0)
	jsr	(getpde).l		;get players energy
	tst.w	(OptLine).l
	bne.w	.0
	subi.w	#$CC,d0
	jsr	(setpde).l		;decrease players energy
	btst	#$4,$17F7A.l
	beq.w	.0
	move.w	#$1000,d0
.0	lsr.w	#$7,d0		;d0 will be $1000 with lines off
	move.w	d0,d1		;energy = speed increase (check violence)
	move.w	$54(a3),d2		;facedir
	asl.w	#$2,d2
	movea.l	#dirtab,a0
	muls.w	(a0,d2.w),d0
	muls.w	$2(a0,d2.w),d1
	add.w	d0,$28(a3)		;add to X Vel
	add.w	d1,$2A(a3)		;add to Y Vel
	bset	#$5,$62(a3)		;lock in this animation
	move.w	#$C5E,d1
	bra.w	X_1B3C0
Holdplayer						;abut press hold. a0 = the player this one is
									;assigned to, falls into Acheck
	bset	#$5,$62(a3)		;lock animation
	move.w	#$1122,d1		;move anim into d1 - normal hold check
	tst.w	$32(a3)		;check if impact = 0
	beq.w	X_1B3C0		;set anim if 0
	movea.l	#SortCords,a0		;move SortCord into a0
	move.w	$2E(a3),d0		;move last impact player into d0
	asl.w	#$7,d0		;calc offset
	adda.w	d0,a0		;add offset to a0
Acheck						;start SPAhook, or SPAHold if a0 is ahead
	bset	#$5,$62(a3)		;lock animation
	move.w	#$1122,d1		;move anim into d1 - normal hold check
	tst.w	$32(a3)		;check if impact = 0
	beq.w	.ex		;branch if 0
	move.w	$14(a3),d0		;move Ypos checker into d0
	sub.w	$14(a0),d0		;sub Ypos of player
	btst	#$7,$62(a3)		;check goal checker is shooting at
	beq.w	.air		;jump if bottom
	neg.w	d0		;make d0 negative
.air	bmi.w	.ex
	move.w	#$C90,d1		;set anim - hold check stick in air
.ex	bra.w	X_1B3C0
setpassmode						;initialize pass mode
	move.w	$54(a3),(passdir).l		;facedir, default pass direction
	andi.w	#$7,(passdir).l		;Passes first 3 bits of passdir
	btst	#$2,$17F70.l
	beq.w	.0
	bclr	#$2,$17F78.l
	bset	#$5,$17F70.l
	bne.w	X_15A6E
	bclr	#$5,$17F78.l
	move.w	#$64,(passmodetimer).l
.0	bset	#$2,$17F6A.l		;#sfspdir - set pass dir mode
	dc.w	$4E75
passmode						;dpad sets passdir until bbut changes
	btst	#$4,d2		;has b button changed?
	bne.w	X_15EF0		;yes
	btst	#$3,$17F74.l		;Not in NHL Hockey Source
	bne.w	X_15EF0
	btst	#$3,d0		;look for dpad
	bne.w	X_15EC4
	andi.w	#$7,d0		;pass first 3 bits of d0
	move.w	d0,(passdir).l		;new pass dir
	bset	#$3,d0
	dc.w	$48E7,$FCC0,$08B9,$0002,$0001,$7F6A,$50F9,$0001
	dc.w	$7BE0,$177C,$0010,$005E,$33EB,$0052,$0001,$7E2A
	dc.w	$08B9,$0003,$0001,$7F74,$6700,$002E,$4EB9,$0002
	dc.w	$27B8,$33FC,$0012,$0001,$937A,$0839,$0002,$0001
	dc.w	$7F76,$6700,$000A,$33FC,$003A,$0001,$937A,$4EB9
	dc.w	$0002,$273A,$6000,$0126,$7008,$4A6B,$0034,$6700
	dc.w	$0006,$102B,$006E,$E540,$E240,$0640,$00A0,$33C0
	dc.w	$0001,$7E2E,$082B,$0000,$006E,$6700,$000A,$E840
	dc.w	$D179,$0001,$7E2E,$78FF,$7605,$227C,$0001,$7480
	dc.w	$0C6B,$0006,$0052,$6D00,$0012,$D2FC,$0300,$0839
	dc.w	$0002,$0001,$7F70,$6600,$007E,$B7C9,$6700,$0062
	dc.w	$4A69,$0034,$6700,$005A,$0829,$0002,$0063,$6600
	dc.w	$0050,$3029,$0000,$9079,$0001,$7B80,$3229,$0014
	dc.w	$9279,$0001,$7B94,$48A7,$C000,$6100,$532C,$4C9F
	dc.w	$0006,$9079,$0001,$7E2C,$0240,$0007,$EB00,$4880
	dc.w	$E740,$C1C0,$0C80,$0001,$0000,$6200,$0014,$C3C1
	dc.w	$C5C2,$D481,$D480,$B484,$6200,$0006,$2802,$2049
	dc.w	$D2FC,$0080,$51CB,$FF94,$4A84,$6B00,$000A,$6100
	dc.w	$00DA,$6000,$0058,$3039,$0001,$7E2C,$E540,$207C
	dc.w	$0003,$6B8E,$3230,$0002,$C3F9,$0001,$7E2E,$243C
	dc.w	$0000,$000A,$E5A1,$83FC,$0BB8,$D26B,$002A,$33C1
	dc.w	$0001,$7BAA,$3230,$0000,$C3F9,$0001,$7E2E,$E5A1
	dc.w	$83FC,$0BB8,$D26B,$0028,$33C1,$0001,$7BA8,$303C
	dc.w	$1000,$6100,$5FEC,$33C0,$0001,$7BAC,$4A6B,$0034
	dc.w	$6600,$0024,$4A79,$0001,$7BAA,$082B,$0007,$0062
	dc.w	$6700,$000A,$6B00,$000A,$6000,$000C,$6B00,$0008
	dc.w	$4479,$0001,$7BAA,$3039,$0001,$7BA8,$3239,$0001
	dc.w	$7BAA,$6100,$5254,$323C,$0366,$4A6B,$0034,$6700
	dc.w	$0012,$323C,$0718,$6100,$02F2,$6700,$0006,$323C
	dc.w	$078A,$6100,$52FC,$08EB,$0005,$0062,$700C,$9039
	dc.w	$0001,$7BAC,$E448,$0240,$0003,$303C,$0010,$3F00
	dc.w	$6100,$602A,$4CDF,$033F,$4E75
passto						;pass the puck to player a0: a3 = passer
	btst	#$3,$62(a3)
	beq.w	X_1617A
	tst.w	$34(a3)
	bne.w	X_1617A
	movem.l	d0-d1,-(sp)
	btst	#$3,$62(a0)
	bne.w	X_16176
	bset	#$6,$64(a0)		;pflags3 bit 6
	move.w	(cont1team).l,d1
	cmp.w	(cont2team).l,d1		;checks to see if 2 player co-op (on same team)
	bne.w	.h2hor1p
	move.w	$52(a0),d0		;SCnum of receiver into d0
	move.w	$52(a3),d1		;SCnum of passer into d1
	cmp.w	(c1playernum).l,d1		;checks if cont 1 controlling passer
	bne.w	.p2passing
	jsr	(setc1player).l
	bra.w	X_16176
.p2passing	jsr	(setc2player).l
	bra.w	X_16176
.h2hor1p	move.w	#$1,d1
	btst	#$6,$62(a3)		;check if home or away team
	beq.w	.0		;branch if home
	move.w	#$2,d1		;away team
.0	move.w	$52(a0),d0		;move SCnum of receiver into d0
	cmp.w	(cont1team).l,d1		;compare cont1 team with d1 (1=home, 2=away)
	bne.w	X_16170
	jsr	(setc1player).l
	bra.w	X_16176
	dc.w	$4EB9,$0003,$12DC,$4CDF,$0003,$4EB9,$0003,$C958
	dc.w	$066A,$0001,$0012,$33E8,$0052,$0001,$7E30,$3A39
	dc.w	$0001,$7E2E,$E445,$C14B,$7013,$6100,$513C,$C14B
	dc.w	$2F08,$6100,$51BE,$D068,$0000,$9079,$0001,$7B80
	dc.w	$D268,$0014,$9279,$0001,$7B94,$48A7,$C000,$4C97
	dc.w	$000C,$E442,$E443,$3028,$0028,$C1FC,$00F0,$4840
	dc.w	$3228,$002A,$C3FC,$00F0,$4841,$48A7,$C000,$C1C2
	dc.w	$C3C3,$D041,$E340,$3800,$4C97,$0003,$C1C0,$C3C1
	dc.w	$CBC5,$4485,$DA80,$DA81,$C5C2,$C7C3,$D682,$C7C5
	dc.w	$E583,$3004,$C1C0,$9083,$6100,$5E84,$7601,$E445
	dc.w	$6600,$0004,$7A01,$3400,$4440,$9444,$48C2,$85C5
	dc.w	$5ACB,$FFF4,$6600,$0006,$0642,$0001,$0C42,$0018
	dc.w	$6300,$0004,$7418,$13C2,$0001,$7BAC,$0C42,$000C
	dc.w	$6D00,$000A,$13FC,$000C,$0001,$7BAC,$3002,$E740
	dc.w	$0440,$000A,$1140,$0040,$0440,$0006,$13C0,$0001
	dc.w	$7BDE,$4C9F,$0003,$C1C2,$E280,$D05F,$3179,$0001
	dc.w	$7B80,$0044,$D168,$0044,$C3C2,$E281,$D25F,$3179
	dc.w	$0001,$7B94,$0046,$D368,$0046,$C4FC,$0078,$4840
	dc.w	$81C2,$33C0,$0001,$7BA8,$4841,$83C2,$33C1,$0001
	dc.w	$7BAA,$4E75,$4EF9,$0002,$B4E2,$08EB,$0005,$0062
	dc.w	$323C,$0B24,$6000,$510A,$B079,$0001,$7F9E,$6700
	dc.w	$001A,$48E7,$40C0,$3239,$0001,$7F9E,$6100,$0032
	dc.w	$33C0,$0001,$7F9E,$4CDF,$0302,$4E75,$B079,$0001
	dc.w	$7FA0,$6700,$001A,$48E7,$40C0,$3239,$0001,$7FA0
	dc.w	$6100,$000E,$33C0,$0001,$7FA0,$4CDF,$0302,$4E75
restorepl						;restore old joy controlled player d1, give d0 the joystick; a d1 in line
									;change mode keeps control
	movea.l	#SortCords,a0
	tst.w	d1
	blt.w	.spd
	cmpi.w	#$B,d1
	bgt.w	.spd
	asl.w	#$7,d1		;multiply d0 by 80 hex (SCsize)
	btst	#$3,$63(a0,d1.w)		;#pfnp - no joystick pad
	beq.w	.cont
	lsr.w	#$7,d1		;divide by 80 hex
	move.w	d1,d0
	rts
.cont	bclr	#$3,$62(a0,d1.w)		;#pfjoycon
	btst	#$3,$64(a0,d1.w)		;bit 3, pflags3
	bne.w	.spd
	bset	#$1,$62(a0,d1.w)		;#pfna - new assignment
.spd	tst.w	d0		;checks if d0 0 or higher
	blt.w	.ex
	cmpi.w	#$B,d0		;checks if d0 11 or less
	bgt.w	.ex
	move.w	d0,d1		;copies d0 into d1
	asl.w	#$7,d1
	btst	#$2,$17F70.l
	bne.w	.chkgoalie
	btst	#$0,$17F78.l
	beq.w	.3
.chkgoalie	tst.w	$34(a0,d1.w)
	bne.w	.3
	btst	#$6,$62(a0,d1.w)		;check if home or away
	beq.w	.0
	tst.w	(goaliemode2).l
	bra.w	.1
.0	tst.w	(goaliemode1).l
.1	beq.w	.3
	move.w	#$0,d0		;first position of home SCNum
	btst	#$6,$62(a0,d1.w)		;check if home or away
	beq.w	.2
	move.w	#$6,d0		;first position of away SCNum
.2	bra.w	.ex
.3	bset	#$3,$62(a0,d1.w)		;set pfjoycon for SCNum
.ex	rts
	dc.w	$4440,$D06B,$0054,$0240,$0007,$082B,$0003,$0004
	dc.w	$6700,$0008,$013C,$00F0,$4E75,$013C,$001E,$4E75
	dc.w	$0839,$0002,$0001,$7F70,$6700,$0026,$08B9,$0002
	dc.w	$0001,$7F78,$08F9,$0005,$0001,$7F70,$6600,$F686
	dc.w	$08B9,$0005,$0001,$7F78,$33FC,$0064,$0001,$7F9A
	dc.w	$33FC,$0008,$0001,$7E2C,$08F9,$0003,$0001,$7F6A
	dc.w	$4240,$323C,$0128,$082B,$0007,$0062,$6600,$0004
	dc.w	$4441,$906B,$0000,$926B,$0014,$6100,$4ED2,$33FC
	dc.w	$000F,$0001,$7E2E,$323C,$07FC,$6100,$FF74,$6700
	dc.w	$000E,$323C,$092E,$33FC,$000F,$0001,$7E2E,$6000
	dc.w	$4F76
ShotMode						;shot input
									;swing frame reached (anim frame 7*4): shoot, else dpad sets shot
									;direction
	cmpi.w	#$1C,$5A(a3)
	bge.w	prepshot		;end of animation so shoot
	btst	#$3,d0		;checks dpad for direction
	bne.w	.ss0
	andi.w	#$7,d0		;pass the first 3 bits of d0
	move.w	d0,(passdir).l		;set shot direction
.ss0	cmpi.w	#$10,$5A(a3)
	bge.w	X_167B6		;past full windup so no more passspeed
	add.w	d7,(passspeed).l
	cmpi.b	#$14,$6C(a3)		;6C = shot speed
	bge.w	.checkcbut
	cmpi.w	#$8,$5A(a3)		;SPANum
	bgt.w	.chganim
.checkcbut	btst	#$5,d2		;5 = #cbut
	beq.w	X_167B6		;button hasnt changed so continue windup
.chganim	neg.w	$5A(a3)		;end windup and swing through
	addi.w	#$1C,$5A(a3)		;Add to SPANum
	rts
prepshot						;check the conditions before a shot: d0 = SCnum of the opposing goalie
									;(getGoalieSCnum)
	bclr	#$4,$17F74.l
	move.w	#$B,d0
	btst	#$6,$62(a3)		;check if home or away
	beq.w	.getGoalie		;gets opponents Goalie SCnum
	move.w	#$5,d0		;opponent is home
.getGoalie	jsr	(getGoalieSCnum+LOAD).l
	tst.w	d0
	bmi.w	.nogoalie
	movem.l	a0,-(sp)
	asl.w	#$7,d0
	movea.l	#SortCords,a0
	cmpi.w	#$250,$58(a0,d0.w)		;Checking goalie animations - pad stack right
	beq.w	.svgoalie
	cmpi.w	#$2A2,$58(a0,d0.w)		;Checking another goalie animation - pad stack left
.svgoalie	movem.l	(sp)+,a0		;pop stack value into a0
	bne.w	.cont
.nogoalie	cmpi.w	#$1,(passdir).l
	ble.w	.dir017		;branch if passdir is 0 or 1
	cmpi.w	#$7,(passdir).l
	bne.w	.cont		;branch if passdir is not 7
.dir017	move.w	(pucky).l,d0
	btst	#$7,$62(a3)		;#pfgoal - goal to shoot at (0=bottom, 1=top)
	bne.w	.cmppuck		;branch if top
	neg.w	d0		;flips d0 for compare calc
.cmppuck	cmpi.w	#$D8,d0		;compares location of puck
	blt.w	.cont
	bset	#$4,$17F74.l		;set flag for in-close top shelf shooting
.cont	bra.w	X_16528
