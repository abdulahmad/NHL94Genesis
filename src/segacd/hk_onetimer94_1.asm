	include	segacd\hockey.inc
	include	macros\genesis.mac

CrowdAvg	equ	$17F90
CrowdPeak	equ	$17F92
CrowdRecord	equ	$17F8E
Crowdlevel	equ	$17CD2
CurCrowdMeter	equ	$17F8C
CwdChkCntr	equ	$17F84
CwdExciteLvl	equ	$17CD8
HomeTeam	equ	$17FAE
NameLogBase	equ	$DA0
NameLogBytes	equ	$80
PadControlBits	equ	$17DC8
PadControlBits34	equ	$17DD6
PalMode	equ	$18C20
ReadCrowdRecord	equ	$2258E
ReadSRAM	equ	$22452
Sroot	equ	$3708E
ThreeStars	equ	$BC000
WriteSRAM	equ	$2246C
cont3team	equ	$17FAA
crowdnoisedelay	equ	$17F82
doshot	equ	$31528
move	equ	$2C9C8
namelog	equ	$1A2FC
onetimerflags	equ	$17EC6
onetimerheight	equ	$1937A
onetimertargetx	equ	$19376
onetimertargety	equ	$19378
passdir	equ	$17E2C
puckflip	equ	$35EF8
puckvx	equ	$17BA8
puckvy	equ	$17BAA
puckvz	equ	$17BAC
puckx	equ	$17B80
pucky	equ	$17B94
sflags6	equ	$17F76
swap	equ	$2779A
tmstruct	equ	$1834C

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
	dc.w	$48E7,$FFFE,$08B9,$0002,$0001,$7F76,$4A6B,$0034
	dc.w	$6600,$000C,$207C,$0002,$2906,$6000,$0036,$302B
	dc.w	$0014,$082B,$0007,$0062,$6600,$0004,$4440,$08F9
	dc.w	$0002,$0001,$7F76,$207C,$0002,$28C6,$0C40,$0058
	dc.w	$6D00,$0010,$207C,$0002,$28E6,$08B9,$0002,$0001
	dc.w	$7F76,$302B,$0054,$082B,$0007,$0062,$6600,$000A
	dc.w	$0640,$0004,$0240,$0007,$E540,$3230,$0000,$3430
	dc.w	$0002,$B1FC,$0002,$28E6,$6600,$002A,$302B,$0014
	dc.w	$6A00,$0004,$4440,$0C40,$008A,$6D00,$0018,$302B
	dc.w	$0000,$6A00,$0004,$4440,$0C40,$0037,$6E00,$0006
	dc.w	$343C,$0103,$082B,$0007,$0062,$6600,$0006,$4441
	dc.w	$4442,$303C,$000A,$4EB9,$0003,$7050,$D240,$303C
	dc.w	$000A,$4EB9,$0003,$7050,$D440,$33C1,$0001,$9376
	dc.w	$4A6B,$0034,$6700,$002C,$926B,$0000,$6B00,$0016
	dc.w	$0441,$003C,$6A00,$001C,$4441,$D379,$0001,$9376
	dc.w	$6000,$0010,$0641,$003C,$6B00,$0008,$9379,$0001
	dc.w	$9376,$33C2,$0001,$9378,$4CDF,$7FFF,$4E75,$0074
	dc.w	$00C2,$0074,$00C2,$0074,$00C2,$0074,$00C2,$FF8C
	dc.w	$00C2,$FF8C,$00C2,$FF8C,$00C2,$FF8C,$00C2,$FFFB
	dc.w	$00AB,$FFFB,$00AB,$FFFB,$00AB,$FFFB,$00AB,$FFFB
	dc.w	$00AB,$FFFB,$00AB,$FFFB,$00AB,$FFFB,$00AB,$FFFB
	dc.w	$FFF7,$0032,$FFF7,$0032,$FFF7,$0032,$FFF7,$FFFB
	dc.w	$FFF7,$FFCE,$FFF7,$FFCE,$FFF7,$FFCE,$FFF7,$08AB
	dc.w	$0001,$0062,$6700,$0138,$08EB,$0003,$0064,$6600
	dc.w	$012E,$08B9,$0000,$0001,$7EC6,$08B9,$0005,$0001
	dc.w	$7F7C,$4279,$0001,$7EC6,$4279,$0001,$7EBE,$50F9
	dc.w	$0001,$7E30,$48E7,$FFFE,$302B,$0052,$33C0,$0001
	dc.w	$7EBC,$082B,$0003,$0062,$6600,$00CE,$4A79,$0001
	dc.w	$AD7A,$6B00,$00C4,$6700,$0062,$0C79,$0001,$0001
	dc.w	$AD7C,$6600,$004C,$3F39,$0001,$7FA8,$3F39,$0001
	dc.w	$7FA0,$33F9,$0001,$7FAC,$0001,$7FA8,$33F9,$0001
	dc.w	$7FA4,$0001,$7FA0,$4EB9,$0003,$12DC,$33F9,$0001
	dc.w	$7FA0,$0001,$7FA4,$33F9,$0001,$7FA8,$0001,$7FAC
	dc.w	$33DF,$0001,$7FA0,$33DF,$0001,$7FA8,$6000,$006A
	dc.w	$4EB9,$0003,$12DC,$6000,$0060,$4A79,$0001,$AD7C
	dc.w	$6600,$004C,$3F39,$0001,$7FA6,$3F39,$0001,$7F9E
	dc.w	$33F9,$0001,$7FAA,$0001,$7FA6,$33F9,$0001,$7FA2
	dc.w	$0001,$7F9E,$4EB9,$0003,$12B8,$33F9,$0001,$7F9E
	dc.w	$0001,$7FA2,$33F9,$0001,$7FA6,$0001,$7FAA,$33DF
	dc.w	$0001,$7F9E,$33DF,$0001,$7FA6,$6000,$000C,$4EB9
	dc.w	$0003,$12B8,$6000,$0002,$3F00,$6100,$0224,$426B
	dc.w	$005A,$4EB9,$0003,$63C0,$08EB,$0005,$0062,$08EB
	dc.w	$0001,$0063,$301F,$4CDF,$7FFF,$6000,$0202,$0839
	dc.w	$0000,$0001,$7EC6,$6600,$005E,$48A7,$C000,$3039
	dc.w	$0001,$7B80,$906B,$0000,$0C40,$003C,$6E00,$000A
	dc.w	$0C40,$FFC4,$6E00,$0016,$3239,$0001,$7BA8,$B340
	dc.w	$6B00,$000A,$4C9F,$0003,$6000,$0036,$3039,$0001
	dc.w	$7B94,$906B,$0014,$0C40,$003C,$6E00,$000A,$0C40
	dc.w	$FFC4,$6E00,$000E,$3239,$0001,$7BAA,$B340,$6A00
	dc.w	$FFD4,$4C9F,$0003,$4A79,$0001,$7BE0,$6B00,$000E
	dc.w	$08B9,$0007,$0001,$7F7C,$6000,$017E,$0839,$0000
	dc.w	$0001,$7F68,$6600,$0172,$48E7,$C000,$0C6B,$0010
	dc.w	$005A,$6C00,$00AC,$0839,$0002,$0001,$7EC6,$6600
	dc.w	$00A0,$302B,$0000,$3239,$0001,$7B80,$9041,$6A00
	dc.w	$0004,$4440,$322B,$0014,$3439,$0001,$7B94,$9242
	dc.w	$6A00,$0004,$4441,$3439,$0001,$7BA8,$6700,$0008
	dc.w	$B240,$6F00,$000A,$3439,$0001,$7BAA,$3001,$4840
	dc.w	$0280,$FFFF,$0000,$4A42,$6A00,$0004,$4442,$323C
	dc.w	$0011,$4A79,$0001,$8C20,$6700,$0006,$323C,$0016
	dc.w	$4A42,$6600,$0006,$343C,$0001,$80C2,$0280,$0000
	dc.w	$FFFF,$80C1,$342B,$005A,$E44A,$0442,$0006,$4442
	dc.w	$E542,$B042,$6E00,$0010,$446B,$005A,$066B,$0018
	dc.w	$005A,$6000,$0088,$DF79,$0001,$7EBE,$6000,$002E
	dc.w	$08F9,$0002,$0001,$7EC6,$0839,$0001,$0001,$7EC6
	dc.w	$6600,$001A,$0C6B,$0018,$005A,$6600,$0010,$066B
	dc.w	$0030,$005C,$08F9,$0001,$0001,$7EC6,$0839,$0001
	dc.w	$0001,$7EC6,$6700,$0020,$0C6B,$0018,$005A,$6F00
	dc.w	$0016,$0839,$0000,$0001,$7EC6,$6600,$000A,$4CDF
	dc.w	$0003,$6000,$0064,$0839,$0000,$0001,$7EC6,$6700
	dc.w	$001C,$0C6B,$0018,$005A,$6600,$0012,$0C6B,$0001
	dc.w	$005C,$6F00,$0008,$377C,$0001,$005C,$082B,$0001
	dc.w	$0063,$6600,$000A,$4CDF,$0003,$6000,$0022,$302B
	dc.w	$005A,$4CDF,$0003,$0839,$0000,$0001,$7EC6,$6700
	dc.w	$000C,$08AB,$0005,$0062,$6000,$0004,$4E71,$082B
	dc.w	$0001,$0063,$6600,$0008,$4EB9,$0002,$AF00,$4E75
	dc.w	$323C,$07FC,$48A7,$C000,$302B,$0000,$4440,$323C
	dc.w	$0108,$082B,$0007,$0062,$6600,$0004,$4441,$926B
	dc.w	$0014,$4EB9,$0003,$62F8,$4EB9,$0002,$2D9E,$4C9F
	dc.w	$0003,$6700,$0006,$323C,$092E,$4E75
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
	dc.w	$4A6B,$0028,$6A00,$0010,$066B,$07D0,$0028,$6B00
	dc.w	$0014,$426B,$0028,$046B,$07D0,$0028,$6A00,$0006
	dc.w	$426B,$0028,$4A6B,$002A,$6A00,$0010,$066B,$07D0
	dc.w	$002A,$6B00,$0014,$426B,$002A,$046B,$07D0,$002A
	dc.w	$6A00,$0006,$426B,$002A,$4E75
