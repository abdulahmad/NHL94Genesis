	include	segacd\hockey.inc
	include	macros\genesis.mac

CrowdAvg	equ	$17F90
CrowdPeak	equ	$17F92
CrowdRecord	equ	$17F8E
Crowdlevel	equ	$17CD2
CurCrowdMeter	equ	$17F8C
CwdChkCntr	equ	$17F84
CwdExciteLvl	equ	$17CD8
EndOneTimer	equ	$2AF00
HomeTeam	equ	$17FAE
LOAD	equ	$1B000
NameLogBase	equ	$DA0
NameLogBytes	equ	$80
OneTimerFarTbl	equ	$228E6
OneTimerGoalieTbl	equ	$22906
OneTimerNearTbl	equ	$228C6
PadControlBits	equ	$17DC8
PadControlBits34	equ	$17DD6
PalMode	equ	$18C20
ReadCrowdRecord	equ	$2258E
ReadSRAM	equ	$22452
SetSPA	equ	$363C0
Sroot	equ	$3708E
ThreeStars	equ	$BC000
WriteSRAM	equ	$2246C
c1playernum	equ	$17F9E
c2playernum	equ	$17FA0
c3playernum	equ	$17FA2
c4playernum	equ	$17FA4
cont1team	equ	$17FA6
cont2team	equ	$17FA8
cont3team	equ	$17FAA
cont4team	equ	$17FAC
crowdnoisedelay	equ	$17F82
doshot	equ	$31528
inputjoy	equ	$1AD7A
move	equ	$2C9C8
namelog	equ	$1A2FC
onetimerflags	equ	$17EC6
onetimerheight	equ	$1937A
onetimerplayer	equ	$17EBC
onetimertargetx	equ	$19376
onetimertargety	equ	$19378
passReceiverPlayerNum	equ	$17E30
passdir	equ	$17E2C
puckflip	equ	$35EF8
puckvx	equ	$17BA8
puckvy	equ	$17BAA
puckvz	equ	$17BAC
puckx	equ	$17B80
pucky	equ	$17B94
randomd0	equ	$37050
setc1player	equ	$312B8
setc2player	equ	$312DC
sflags6	equ	$17F76
swap	equ	$2779A
tmstruct	equ	$1834C
vtoa	equ	$362F8

	org	$7000

	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$4E75,$0839,$0005,$00FF,$800E
	dc.w	$6700,$0072,$08F9,$0002,$00FF,$800F,$2F3C,$0002
	dc.w	$203A,$2F39,$0001,$8D66,$4E75,$4EB9,$0004,$7DB2
	dc.w	$0839,$0004,$00FF,$800E,$66F6,$33FC,$002F,$00FF
	dc.w	$8026,$08F9,$0003,$00FF,$800F,$0839,$0003,$00FF
	dc.w	$800E,$67F6,$08F9,$0004,$00FF,$800F,$08B9,$0003
	dc.w	$00FF,$800F,$0839,$0003,$00FF,$800E,$66F6,$08B9
	dc.w	$0004,$00FF,$800F,$08B9,$0002,$00FF,$800F,$5279
	dc.w	$0001,$7460,$4E75,$2E7C,$0000,$C458,$207C,$0001
	dc.w	$745C,$4298,$B1FC,$0001,$AD9A,$6D00,$FFF6,$3E3C
	dc.w	$000C,$4EB8,$6044,$33C0,$0001,$93BA,$4A79,$0001
	dc.w	$93BA,$663A,$4EB9,$0002,$243E,$303C,$0000,$41F9
	dc.w	$0007,$E000,$43F9,$0001,$7EF2,$4EB8,$5F16,$6516
	dc.w	$303C,$0003,$41F9,$0002,$240C,$43F9,$0001,$93BC
	dc.w	$4EB8,$5F16,$6008,$33FC,$FFFF,$0001,$93BA,$23FC
	dc.w	$0001,$9360,$0001,$9360,$4279,$0001,$AD94,$0839
	dc.w	$0007,$00FF,$800E,$66F6,$48E7,$0080,$41F9,$00C0
	dc.w	$0004,$23C8,$00FF,$8022,$33FC,$0018,$00FF,$8020
	dc.w	$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$67F6,$3039,$00FF,$8010,$08F9,$0007,$00FF,$800F
	dc.w	$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$66F6,$08B9,$0007,$00FF,$800F,$4CDF,$0100,$0240
	dc.w	$0001,$33C0,$0001,$8C20,$6700,$000A,$08F9,$0000
	dc.w	$0001,$AD94,$0839,$0007,$00FF,$800E,$66F6,$33FC
	dc.w	$002B,$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$67F6,$33F9,$00FF,$8010,$0001
	dc.w	$8BF8,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$33FC,$FFFF,$0001,$7DD6,$4EB9,$0002
	dc.w	$1FC8,$3E3C,$0003,$4EB8,$6044,$4EB9,$0003,$FDE8
	dc.w	$4EB9,$0002,$A58C,$4EB9,$0004,$0102,$33F9,$0001
	dc.w	$8C0A,$0001,$8C22,$33F9,$0001,$8BFA,$0001,$8C24
	dc.w	$4EB9,$0003,$7460,$4EF9,$0003,$F2D6,$0839,$0007
	dc.w	$00FF,$800E,$66F6,$0839,$0006,$00FF,$800E,$67F6
	dc.w	$08F9,$0006,$00FF,$800F,$08F9,$0007,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$66F6,$08B9,$0006,$00FF
	dc.w	$800F,$08B9,$0007,$00FF,$800F,$4E75,$08B9,$0002
	dc.w	$00FF,$8003,$66F6,$4E75,$0839,$0001,$00FF,$8003
	dc.w	$67F6,$4E75,$0839,$0007,$00FF,$800E,$66F6,$33FC
	dc.w	$0007,$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF,$800F
	dc.w	$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$66F6,$08B9,$0007,$00FF,$800F,$4EB9,$0002,$2268
	dc.w	$4E75,$08F9,$0000,$00FF,$8003,$0839,$0001,$00FF
	dc.w	$8003,$66F6,$4E75,$48E7,$C0C0,$303C,$0080,$4EB8
	dc.w	$5F22,$65F6,$4CDF,$0303,$4E75,$000D,$006C,$000E
	dc.w	$0060,$000E,$0061,$000E,$0062,$000E,$0063,$000E
	dc.w	$0064,$000E,$0065,$000E,$0066,$000E,$0067,$000E
	dc.w	$006D,$000E,$006E,$000E,$006F,$000E,$006B,$000E
	dc.w	$0600,$0A60,$00FF,$FF02,$0202,$00FF,$00FF,$0600
	dc.w	$0754,$00FF,$FF02,$0202,$00FF,$00FF,$0600,$0254
	dc.w	$00FF,$FF02,$0202,$00FF,$00FF,$0600,$0154,$00FF
	dc.w	$FF02,$0202,$00FF,$00FF,$0600,$0654,$00FF,$FF02
	dc.w	$0202,$00FF,$00FF,$0600,$045A,$00FF,$FF02,$0202
	dc.w	$00FF,$00FF,$0600,$005A,$00FF,$FF02,$0202,$00FF
	dc.w	$00FF,$0600,$035A,$00FF,$FF02,$0202,$00FF,$00FF
	dc.w	$0600,$0554,$00FF,$FF02,$0202,$0096,$00FF,$0600
	dc.w	$085A,$00FF,$FF02,$0202,$00FF,$00FF,$0600,$095A
	dc.w	$00FF,$FF02,$0202,$00FF,$00FF,$0608,$0B54,$00FF
	dc.w	$FF02,$0202,$00FF,$00FF,$0600,$0C5A,$00FF,$FF02
	dc.w	$0202,$00FF,$00FF,$0002,$0000,$0002,$0001,$0002
	dc.w	$0002,$0002,$0003,$0002,$0004,$0002,$0005,$0002
	dc.w	$0006,$0002,$0007,$0002,$0008,$0002,$0009,$0002
	dc.w	$000A,$0002,$000B,$0002,$000C,$FFFF,$4E48,$4C48
	dc.w	$4F43,$4B45,$5939,$3400,$0000,$0000,$4E48,$4C48
	dc.w	$4F43,$4B45,$5939,$3400,$003D,$41F9,$0001,$93BC
	dc.w	$7000,$323C,$0F1F,$D018,$51C9,$FFFC,$4E75,$41F9
	dc.w	$0001,$93BC,$303C,$0F1F,$4281,$10C1,$51C8,$FFFC
	dc.w	$4E75,$48E7,$C0C0,$2240,$D3FC,$0001,$93BC,$5381
	dc.w	$10D9,$51C9,$FFFC,$4CDF,$0303,$4E75,$48E7,$C0C0
	dc.w	$2F0E,$2C79,$0001,$9360,$0839,$0005,$00FF,$800F
	dc.w	$6706,$3D3C,$0001,$6004,$3D3C,$0000,$08B9,$0005
	dc.w	$00FF,$800F,$23CE,$0001,$9360,$2C5F,$2240,$D3FC
	dc.w	$0001,$93BC,$5381,$12D8,$51C9,$FFFC,$4A79,$0001
	dc.w	$93BA,$6B00,$0054,$4EB9,$0002,$242A,$23C0,$0001
	dc.w	$A2DC,$303C,$0000,$41F9,$000B,$C000,$43F9,$0001
	dc.w	$7EF2,$4EB8,$5F16,$6500,$0028,$303C,$0005,$41F9
	dc.w	$0002,$240C,$4EB8,$5F16,$303C,$0004,$41F9,$0002
	dc.w	$241C,$43F9,$0001,$93BC,$4EB8,$5F16,$6400,$000A
	dc.w	$33FC,$FFFF,$0001,$93BA,$2F0E,$2C79,$0001,$9360
	dc.w	$4A5E,$670A,$08F9,$0005,$00FF,$800F,$6008,$08B9
	dc.w	$0005,$00FF,$800F,$23CE,$0001,$9360,$2C5F,$4CDF
	dc.w	$0303,$4E75,$08B9,$0006,$0001,$7F76,$48E7,$C0C0
	dc.w	$E580,$0680,$0000,$0000,$227C,$0002,$266E,$D241
	dc.w	$3231,$1000,$E541,$48C1,$D081,$223C,$0000,$0004
	dc.w	$0839,$0006,$0001,$7F76,$6700,$000C,$4EB9,$0002
	dc.w	$246C,$6000,$0008,$4EB9,$0002,$2452,$4CDF,$0303
	dc.w	$4E75,$08F9,$0006,$0001,$7F76,$6000,$FFB0,$08B9
	dc.w	$0006,$0001,$7F76,$48E7,$C0C0,$2001,$E940,$0680
	dc.w	$0000,$0B60,$223C,$0000,$0010,$0839,$0006,$0001
	dc.w	$7F76,$6700,$000C,$4EB9,$0002,$246C,$6000,$0008
	dc.w	$4EB9,$0002,$2452,$4CDF,$0303,$4E75,$08F9,$0006
	dc.w	$0001,$7F76,$6000,$FFC0,$08B9,$0006,$0001,$7F76
	dc.w	$48E7,$C0C0,$2001,$E940,$0680,$0000,$0D20,$223C
	dc.w	$0000,$0010,$0839,$0006,$0001,$7F76,$6700,$000C
	dc.w	$4EB9,$0002,$246C,$6000,$0008,$4EB9,$0002,$2452
	dc.w	$4CDF,$0303,$4E75,$08F9,$0006,$0001,$7F76,$6000
	dc.w	$FFC0,$08F9,$0006,$0001,$7F76,$6000,$000A,$08B9
	dc.w	$0006,$0001,$7F76
NameLogIO
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	#NameLogBytes,d1
	move.l	#NameLogBase,d0
	movea.l	#namelog,a0
	btst	#$6,(sflags6).l
	beq.w	.l7662
	jsr	(WriteSRAM).l
	bra.w	.l7668
.l7662	jsr	(ReadSRAM).l
.l7668	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$0000,$001A,$0034,$004E,$0068,$0082,$009C,$00B6
	dc.w	$00D0,$00EA,$0104,$011E,$0138,$0152,$016C,$0186
	dc.w	$01A0,$01BA,$01D4,$01EE,$0208,$0222,$023C,$0256
	dc.w	$0270,$028A,$02A4,$02BE,$02D8
puckvzadj						;set puckvz for a top shelf shot from the distance to the goal line ($108)
									;over puckvy, at most $7FFF. Called from doshot
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(pucky).l,d0		;move pucky into d0
	bpl.w	.dist		;branch if positive
	neg.w	d0		;negate d0
.dist	subi.w	#$108,d0
	bpl.w	.0		;branch if positive
	neg.w	d0		;negate d0
.0	swap	d0		;swap d0 words
	andi.l	#$FFFF0000,d0		;pass upper word of d0
	move.w	(puckvy).l,d1		;move puckvy into d1
	beq.w	.x		;branch if zero
	bpl.w	.speed		;branch if positive
	neg.w	d1		;negate d1
.speed	move.w	#$11,d2		;move 11 into d2
	tst.w	(PalMode).l		;This byte is never set
	beq.w	.div		;branch if equal (always is)
	move.w	#$16,d2		;move 16 into d2
.div	divu.w	d1,d0		;divide d1 into d0
	andi.l	#$FFFF,d0		;pass lower word of d0
	divu.w	d2,d0		;divide d2 into d0
	tst.w	d0		;check d0
	bne.w	.calc		;branch if not zero
	move.w	#$1,d0		;move 1 into d0
.calc	move.l	#$A0000,d1
	move.w	d0,d3		;move d0 into d3
	mulu.w	d2,d0		;mult d2 and d0
	divu.w	d0,d1		;divide d0 into d1
	move.w	d2,d4		;move d2 into d4
	add.w	d2,d2		;double d2
	add.w	d4,d2		;add d4 to d2 (now d2 is d2 x 3)
	mulu.w	d3,d2		;multiply d3 and d2
	cmpi.l	#$7FFF,d2		;compare to d2
	blt.w	.addvz		;branch if less than
	move.w	#$7FFF,d2		;move 7FFF into d2
.addvz	add.w	d2,d1		;add d2 to d1
	tst.w	d1		;test d1
	bpl.w	.setvz		;branch if positive
	move.w	#$7FFF,d1		;move 7FFF into d1
.setvz	move.w	d1,(puckvz).l		;move d1 into puckvz
.x	movem.l	(sp)+,d0-d7/a0-a6
	rts
OneTimerPass						;One-timer pass: puckvz = sqrt(12 * onetimerheight), then puckvx / puckvy
									;toward the target onetimertargetx / onetimertargety in puckvz / 3 frames;
									;flip the puck (puckflip, a3 = the puck at puckx). Called from passmode
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$C,d0
	move.w	(onetimerheight).l,d1
	mulu.w	d1,d0
	swap	d0
	andi.l	#$FFFF0000,d0
	jsr	(Sroot).l
	move.w	d0,(puckvz).l
	ext.l	d0
	move.w	#$3,d4
	divu.w	d4,d0
	clr.l	d1
	move.w	(onetimertargetx).l,d1
	sub.w	(puckx).l,d1
	swap	d1
	tst.w	d0
	bne.w	.setv
	move.w	#$1,d0
.setv	divs.w	d0,d1
	move.w	d1,(puckvx).l
	clr.l	d1
	move.w	(onetimertargety).l,d1
	sub.w	(pucky).l,d1
	swap	d1
	divs.w	d0,d1
	move.w	d1,(puckvy).l
	movea.l	#puckx,a3
	move.w	(puckvz).l,d0
	jsr	(puckflip).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
OneTimerTarget						;One-timer pass target for receiver a3: an offset by facing from
									;OneTimerNearTbl / OneTimerFarTbl (skater, near or far from the goal) or
									;OneTimerGoalieTbl (goalie), +-10 at random, into onetimertargetx /
									;onetimertargety; sflags6 bit 2 = near. Called from passmode
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#$2,(sflags6).l
	tst.w	$34(a3)
	bne.w	.skater
	movea.l	#OneTimerGoalieTbl,a0
	bra.w	.facing
.skater	move.w	$14(a3),d0
	btst	#$7,$62(a3)
	bne.w	.near
	neg.w	d0
.near	bset	#$2,(sflags6).l
	movea.l	#OneTimerNearTbl,a0
	cmpi.w	#$58,d0
	blt.w	.facing
	movea.l	#OneTimerFarTbl,a0
	bclr	#$2,(sflags6).l
.facing	move.w	$54(a3),d0
	btst	#$7,$62(a3)
	bne.w	.offset
	addi.w	#$4,d0
	andi.w	#$7,d0
.offset	asl.w	#$2,d0
	move.w	(a0,d0.w),d1
	move.w	$2(a0,d0.w),d2
	cmpa.l	#$228E6,a0
	bne.w	.side
	move.w	$14(a3),d0
	bpl.w	.chky
	neg.w	d0
.chky	cmpi.w	#$8A,d0
	blt.w	.side
	move.w	$0(a3),d0
	bpl.w	.chkx
	neg.w	d0
.chkx	cmpi.w	#$37,d0
	bgt.w	.side
	move.w	#$103,d2
.side	btst	#$7,$62(a3)
	bne.w	.rand
	neg.w	d1
	neg.w	d2
.rand	move.w	#$A,d0
	jsr	(randomd0).l
	add.w	d0,d1
	move.w	#$A,d0
	jsr	(randomd0).l
	add.w	d0,d2
	move.w	d1,(onetimertargetx).l
	tst.w	$34(a3)
	beq.w	.sety
	sub.w	$0(a3),d1
	bmi.w	.left
	subi.w	#$3C,d1
	bpl.w	.sety
	neg.w	d1
	add.w	d1,(onetimertargetx).l
	bra.w	.sety
.left	addi.w	#$3C,d1
	bmi.w	.sety
	sub.w	d1,(onetimertargetx).l
.sety	move.w	d2,(onetimertargety).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
assonetimer						;Assignment $23 (asstab), player a3 shooting a one-timer: take control of
									;him (setc1player / setc2player, also for pads 3 and 4), start the
									;animation (setonetimeranim), then shoot when the puck arrives
									;(EndOneTimer)
	ori.w	#$C2,$74(a4,d0.w)
	dc.w	$00C2
	ori.w	#$C2,$74(a4,d0.w)
	dc.w	$00C2
	dc.w	$FF8C
	dc.w	$00C2
	dc.w	$FF8C
	dc.w	$00C2
	dc.w	$FF8C
	dc.w	$00C2
	dc.w	$FF8C
	dc.w	$00C2
	dc.w	$FFFB
	ori.l	#$FFFB00AB,-$5(a3)
	ori.l	#$FFFB00AB,-$5(a3)
	ori.l	#$FFFB00AB,-$5(a3)
	ori.l	#$FFFB00AB,-$5(a3)
	dc.w	$FFF7
	dc.w	$0032,$FFF7,$0032
	dc.w	$FFF7
	dc.w	$0032,$FFF7,$FFFB,$FFF7,$FFCE,$FFF7
	dc.w	$FFCE
	dc.w	$FFF7
	dc.w	$FFCE
	dc.w	$FFF7
	bclr	#$1,$62(a3)		;pfna - clear new assignment
	beq.w	.checkxpos		;branch if not new assignment
	bset	#$3,$64(a3)		;set one timer bit
	bne.w	.checkxpos		;branch if already set
	bclr	#$0,(onetimerflags).l
	bclr	#$5,$17F7C.l
	clr.w	(onetimerflags).l
	clr.w	$17EBE.l
	st.b	(passReceiverPlayerNum).l
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	$52(a3),d0		;move a3 SCnum into d0
	move.w	d0,(onetimerplayer).l		;move d0
	btst	#$3,$62(a3)		;check if joystick controlled
	bne.w	.setanim		;branch if so
	tst.w	(inputjoy).l		;check input controller
	bmi.w	.setanim		;branch if minus (no control)
	beq.w	.cont1or3		;branch if controller 1 or 3
	cmpi.w	#$1,$1AD7C.l		;compare if puck carrier is player 4
	bne.w	.setplayer2		;branch if not
	move.w	(cont2team).l,-(sp)
	move.w	(c2playernum).l,-(sp)
	move.w	(cont4team).l,(cont2team).l
	move.w	(c4playernum).l,(c2playernum).l
	jsr	(setc2player).l
	move.w	(c2playernum).l,(c4playernum).l
	move.w	(cont2team).l,(cont4team).l
	move.w	(sp)+,(c2playernum).l
	move.w	(sp)+,(cont2team).l
	bra.w	.setanim
.setplayer2	jsr	(setc2player).l
	bra.w	.setanim
.cont1or3	tst.w	$1AD7C.l		;check if puck carrier is player 3
	bne.w	.setplayer1		;branch if not
	move.w	(cont1team).l,-(sp)
	move.w	(c1playernum).l,-(sp)
	move.w	(cont3team).l,(cont1team).l
	move.w	(c3playernum).l,(c1playernum).l
	jsr	(setc1player).l
	move.w	(c1playernum).l,(c3playernum).l
	move.w	(cont1team).l,(cont3team).l
	move.w	(sp)+,(c1playernum).l
	move.w	(sp)+,(cont1team).l
	bra.w	.setanim
.setplayer1	jsr	(setc1player).l
	bra.w	.setanim		;*+4
.setanim	move.w	d0,-(sp)
	bsr.w	.l7C68		;sets the one timer animation
	clr.w	$5A(a3)		;clear SPAnum
	jsr	(SetSPA).l
	bset	#$5,$62(a3)		;lock animation
	bset	#$1,$63(a3)		;set anim in progress
	move.w	(sp)+,d0
	movem.l	(sp)+,d0-d7/a0-a6
	bra.w	.ex
.checkxpos	btst	#$0,(onetimerflags).l		;check if shot initiated
	bne.w	.chkcarrier		;branch if set
	movem.w	d0-d1,-(sp)		;push to stack
	move.w	(puckx).l,d0		;move puckx to d0
	sub.w	$0(a3),d0		;sub Xpos from d0
	cmpi.w	#$3C,d0		;compare diff to 3C (60 pixels)
	bgt.w	.chkxvel		;branch if greater than
	cmpi.w	#$FFC4,d0		;compare to -60 pixels
	bgt.w	.chkypos		;branch if greater than
.chkxvel	move.w	(puckvx).l,d1		;move puckvx into d1
	eor.w	d1,d0		;EOR d1 with d0
	bmi.w	.chkypos		;branch if minus
.notcoming	movem.w	(sp)+,d0-d1		;pop from stack d0 and d1
	bra.w	.cancel
.chkypos	move.w	(pucky).l,d0		;move pucky into d0
	sub.w	$14(a3),d0		;sub Ypos from d0
	cmpi.w	#$3C,d0		;compare diff to 60 pix
	bgt.w	.chkyvel		;branch if greater than
	cmpi.w	#$FFC4,d0		;check with -60 pix
	bgt.w	.coming		;branch if greater than
.chkyvel	move.w	(puckvy).l,d1		;move puckvy into d0
	eor.w	d1,d0		;EOR d1 with d0
	bpl.w	.notcoming		;branch if positive
.coming	movem.w	(sp)+,d0-d1		;pop d0 and d1 from stack
.chkcarrier	tst.w	$17BE0.l		;check if puck carrier
	bmi.w	.loose		;branch if no puck carrier
.cancel	bclr	#$7,$17F7C.l		;clear bit 7
	bra.w	.shoot
.loose	btst	#$0,$17F68.l		;check if game clock
	bne.w	.shoot		;branch if clock stopped
	movem.l	d0-d1,-(sp)		;push to stack
	cmpi.w	#$10,$5A(a3)		;compare 10 to SPAnum
	bge.w	.windup		;branch if greater than or equal
	btst	#$2,(onetimerflags).l		;check bit 2
	bne.w	.windup		;branch if set
	move.w	$0(a3),d0		;move Xpos into d0
	move.w	(puckx).l,d1		;move puckx into d1
	sub.w	d1,d0		;sub d1 from d0
	bpl.w	.dy		;branch if positive
	neg.w	d0		;negate d0
.dy	move.w	$14(a3),d1		;move Ypos into d1
	move.w	(pucky).l,d2		;move pucky into d2
	sub.w	d2,d1		;sub d2 from d1
	bpl.w	.vel		;branch if positive
	neg.w	d1		;negate d1
.vel	move.w	(puckvx).l,d2		;move puckvx into d2
	beq.w	.usey		;branch if d2 is 0
	cmp.w	d0,d1		;compare d0 to d1
	ble.w	.frames		;branch if less than or equal
.usey	move.w	(puckvy).l,d2
	move.w	d1,d0
.frames	swap	d0
	andi.l	#$FFFF0000,d0
	tst.w	d2
	bpl.w	.speed
	neg.w	d2
.speed	move.w	#$11,d1
	tst.w	(PalMode).l
	beq.w	.chkzero
	move.w	#$16,d1
.chkzero	tst.w	d2
	bne.w	.div
	move.w	#$1,d2
.div	divu.w	d2,d0
	andi.l	#$FFFF,d0
	divu.w	d1,d0
	move.w	$5A(a3),d2
	lsr.w	#$2,d2
	subi.w	#$6,d2
	neg.w	d2
	asl.w	#$2,d2
	cmp.w	d2,d0
	bgt.w	.wait
	neg.w	$5A(a3)
	addi.w	#$18,$5A(a3)
	bra.w	.chkanim
.wait	add.w	d7,$17EBE.l
	bra.w	.chkhold
.windup	bset	#$2,(onetimerflags).l
	btst	#$1,(onetimerflags).l
	bne.w	.chkhold
	cmpi.w	#$18,$5A(a3)
	bne.w	.chkhold
	addi.w	#$30,$5C(a3)
	bset	#$1,(onetimerflags).l
.chkhold	btst	#$1,(onetimerflags).l
	beq.w	.chkshot
	cmpi.w	#$18,$5A(a3)
	ble.w	.chkshot
	btst	#$0,(onetimerflags).l
	bne.w	.chkshot
	movem.l	(sp)+,d0-d1
	bra.w	.shoot
.chkshot	btst	#$0,(onetimerflags).l
	beq.w	.chkanim
	cmpi.w	#$18,$5A(a3)
	bne.w	.chkanim
	cmpi.w	#$1,$5C(a3)
	ble.w	.chkanim
	move.w	#$1,$5C(a3)
.chkanim	btst	#$1,$63(a3)
	bne.w	.animon
	movem.l	(sp)+,d0-d1
	bra.w	.chkdone
.animon	move.w	$5A(a3),d0
	movem.l	(sp)+,d0-d1
	btst	#$0,(onetimerflags).l
	beq.w	.nop
	bclr	#$5,$62(a3)
	bra.w	.chkdone
.nop	nop
.chkdone	btst	#$1,$63(a3)
	bne.w	.ex
.shoot	jsr	(EndOneTimer).l
.ex	rts
.l7C68	move.w	#$7FC,d1
	movem.w	d0-d1,-(sp)
	move.w	$0(a3),d0
	neg.w	d0
	move.w	#$108,d1
	btst	#$7,$62(a3)
	bne.w	.l7C86
	neg.w	d1
.l7C86	sub.w	$14(a3),d1
	jsr	(vtoa).l
	jsr	(CheckOneTimerFacing+LOAD).l
	movem.w	(sp)+,d0-d1
	beq.w	.l7CA2
	move.w	#$92E,d1
.l7CA2	rts
PuckOnAttackHalf						;d0 = 1 when the puck is on the half of the goal player a3 shoots at, else
									;0 (the code after the bra is never used). Called from doinput and
	movem.w	d0-d1,-(sp)
	move.w	(pucky).l,d0
	btst	#$7,$62(a3)		;pfgoal - check which goal shooting at
	bne.w	.cont		;branch if top goal
	neg.w	d0
.cont	tst.w	d0		;check if d0 is 0
	bpl.w	.plus		;branch if higher
	bra.w	.minus
	move.w	(passdir).l,d0		;code never used from here up to .minus
	addi.w	#$4,d0
	andi.w	#$7,d0
	move.w	$54(a3),d1
	cmp.w	d0,d1
	bra.w	.plus
	beq.w	.plus
	addi.w	#$1,d1
	andi.w	#$7,d1
	cmp.w	d0,d1
	beq.w	.plus
	addi.w	#$1,d1
	andi.w	#$7,d1
	cmp.w	d0,d1
	beq.w	.plus
	subi.w	#$3,d1
	andi.w	#$7,d1
	cmp.w	d0,d1
	beq.w	.plus
	subi.w	#$1,d1
	andi.w	#$7,d1
	beq.w	.plus
.minus	move.w	#$0,d0
	bra.w	.ex
.plus	move.w	#$1,d0
.ex	movem.w	(sp)+,d0-d1
	rts
onetimershot						;Do the one-timer shot (doshot), credit the last two passers as the
									;assists, add to Crowdlevel /
									;CwdExciteLvl and to the one-timer attempts (tmOneTimers).
									;Called from puckstick
	move.w	#$4,(passdir).l
	jsr	(doshot).l
	movem.l	d0/a0,-(sp)
	movea.l	#tmstruct,a0		;Home Stats
	btst	#$6,$62(a3)		;check if home or away
	beq.w	.home		;branch if home
	lea.l	$366(a0),a0		;add if away
.home	clr.w	d0
	move.b	$66(a3),d0		;player offset in roster
	move.w	$1A(a0),$1C(a0)		;move assist 1 player to assist 2
	move.w	$18(a0),$1A(a0)		;move last player to touch puck to assist 1
	move.w	d0,$18(a0)		;move d0 into player touching puck
	bset	#$7,$17F7C.l		;set bit 7
	addi.w	#$96,(Crowdlevel).l		;add to Crowdlevel
	addi.w	#$A,(CwdExciteLvl).l		;add to Excite Level
	addi.w	#$1,$35E(a0)		;add to the one-timer attempts
	movem.l	(sp)+,d0/a0
	bset	#$0,(onetimerflags).l		;set bit 0
	bset	#$1,$63(a3)		;set animation in progress
	bset	#$1,(sflags6).l		;set bit 1
	rts
CheckOneTimerFacing						;called from setonetimeranim. it does nothing, d0 and d1 are restored at
									;the end; it seems meant to change the way the one-timer player faces
	movem.w	d0-d1,-(sp)		;push d0 and d1 on stack
	neg.w	d0		;negate d0
	addi.w	#$8,d0		;add 8 to d0
	andi.w	#$7,d0		;pass first 3 bits of d0
	move.w	$54(a3),d1		;move facedir into d1
	add.w	d0,d1		;add d0 to d1
	andi.w	#$7,d1		;pass first 3 bits of d1
	cmpi.w	#$4,d1		;compare to 4
	bgt.w	.g0		;branch if greater than
	move.w	$4(a3),d0		;move attribute into d0
	eori.w	#$FFFF,d0		;EOR FFFF with d0. Makes d0 opposite.
	andi.w	#$800,d0		;pass 12th bit of d0
	bra.w	.ex
.g0	move.w	$4(a3),d0		;move attribute into d0
	andi.w	#$800,d0		;pass 12th bit of d0
.ex	movem.w	(sp)+,d0-d1		;pop from stack
	rts
	dc.w	$4E75,$4E75
Set4WayPlayer
	cmpi.w	#$FFFF,(PadControlBits).l
	beq.w	.l7E36
	movem.l	d0-d2,-(sp)
	move.w	#$1,d0
	btst	#$6,$62(a3)
	beq.w	.l7E02
	move.w	#$2,d0
.l7E02	cmp.w	(cont3team).l,d0
	beq.w	.l7E18
	move.w	#$F,d1
	move.w	#$4,d0
	bra.w	.l7E20
.l7E18	move.w	#$F0,d1
	move.w	#$0,d0
.l7E20	and.w	d1,(PadControlBits34).l
	move.w	$52(a3),d1
	asl.w	d0,d1
	or.w	d1,(PadControlBits34).l
	movem.l	(sp)+,d0-d2
.l7E36	rts
LoadCrowdRec
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(HomeTeam).l,d1
	ext.l	d1
	movea.l	#ThreeStars,a0
	jsr	(ReadCrowdRecord).l
	move.b	$8(a0),d0
	beq.w	.l7E60
	andi.w	#$FF,d0
	bra.w	.l7E64
.l7E60	move.w	#$50,d0
.l7E64	move.w	d0,(CrowdRecord).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
Crowd_Noise
	btst	#$7,$17F6A.l
	bne.w	.l7F72
	btst	#$0,$17F78.l
	bne.w	.l7F72
	btst	#$0,$17F6E.l
	bne.w	.l7EBC
	btst	#$7,$17F74.l
	bne.w	.l7EF2
	tst.w	(crowdnoisedelay).l
	beq.w	.l7EBE
	subi.w	#$1,(crowdnoisedelay).l
	bpl.w	.l7F72
	clr.w	(crowdnoisedelay).l
.l7EBC	rts
.l7EBE	move.w	(CrowdRecord).l,d0
	move.w	d0,(CrowdAvg).l
	subi.w	#$B,(CrowdAvg).l
	subi.w	#$49,d0
	muls.w	d0,d0
	asr.l	#$2,d0
	addi.w	#$6,d0
	cmp.w	(CwdExciteLvl).l,d0
	bgt.w	.l7F72
	bset	#$7,$17F74.l
	rts
.l7EF2	move.w	(CrowdAvg).l,d0
	subi.w	#$41,d0
	muls.w	d0,d0
	asr.l	#$2,d0
	cmp.w	(CwdExciteLvl).l,d0
	blt.w	.l7F12
	bclr	#$7,$17F74.l
.l7F12	sub.w	d7,(CwdChkCntr).l
	bpl.w	.l7F72
	move.w	#$14,(CwdChkCntr).l
	addi.w	#$1,$17F86.l
	move.w	(CwdExciteLvl).l,d0
	ext.l	d0
	asl.w	#$2,d0
	jsr	(Sroot).l
	addi.w	#$41,d0
	move.w	d0,(CurCrowdMeter).l
	cmp.w	(CrowdPeak).l,d0
	ble.w	.l7F56
	move.w	d0,(CrowdPeak).l
.l7F56	move.w	(CurCrowdMeter).l,d0
	cmp.w	(CrowdRecord).l,d0
	blt.w	.l7F6A
	bra.w	.l7F6A
.l7F6A	movem.l	d0-d7/a0-a6,-(sp)
	movem.l	(sp)+,d0-d7/a0-a6
.l7F72	rts
stopna2
	tst.w	$28(a3)
	bpl.w	.l7F8A
	addi.w	#$7D0,$28(a3)
	bmi.w	.l7F98
	clr.w	$28(a3)
.l7F8A	subi.w	#$7D0,$28(a3)
	bpl.w	.l7F98
	clr.w	$28(a3)
.l7F98	tst.w	$2A(a3)
	bpl.w	.l7FAE
	addi.w	#$7D0,$2A(a3)
	bmi.w	.l7FBC
	clr.w	$2A(a3)
.l7FAE	subi.w	#$7D0,$2A(a3)
	bpl.w	.l7FBC
	clr.w	$2A(a3)
.l7FBC	rts
