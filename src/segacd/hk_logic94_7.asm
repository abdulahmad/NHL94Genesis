	include	segacd\hockey.inc
	include	macros\genesis.mac

AwGoals	equ	$186BE
HmGoals	equ	$18358
OptPlayMode	equ	$18BFA
move	equ	$2C9C8
puckc	equ	$17BE0
puckvx	equ	$17BA8
puckvy	equ	$17BAA
puckx	equ	$17B80
pucky	equ	$17B94
swap	equ	$2779A
X_1BD0A	equ	$1BD0A
X_21000	equ	$21000

	org	$1AA3E

PeriodOver
	addi.w	#$1,$180E4.l
	bchg	#$1,$17F68.l
	cmpi.w	#$3,$180E4.l
	blt.w	.l1AA90
	beq.w	.l1AA78
	move.w	#$3,$180E4.l
	tst.w	(OptPlayMode).l
	bne.w	.l1AA78
	move.w	#$4,$180E4.l
.l1AA78	move.w	(HmGoals).l,d0
	sub.w	(AwGoals).l,d0
	beq.w	.l1AA90
	move.w	#$4,$180E4.l
.l1AA90	bsr.w	X_1BD0A
	dc.w	$4EB9,$0002,$B9BC,$3F3C,$0079,$6100,$1732,$6100
	dc.w	$70FC,$0C79,$0004,$0001,$80E4,$6600,$0008,$4EB9
	dc.w	$0004,$0838,$6100,$6F52,$0C79,$0004,$0001,$80E4
	dc.w	$6700,$0008,$4EF9,$0002,$BA1E,$4EF9,$0003,$F29E
	dc.w	$0839,$0002,$0001,$7F70,$6700,$0006,$6100,$F0BE
	dc.w	$08AB,$0001,$0062,$6700,$000C,$426B,$0040,$377C
	dc.w	$0078,$0042,$227C,$0001,$7E36,$9F69,$0002,$9F69
	dc.w	$0006,$9F6B,$0040,$6A00,$000C,$066B,$0005,$0040
	dc.w	$6100,$0460,$3039,$0001,$7BE0,$6B00,$003E,$EF40
	dc.w	$247C,$0001,$7480,$D4C0,$6100,$01FA,$2F0A,$6100
	dc.w	$082E,$D06A,$0000,$906B,$0000,$E440,$D16B,$0000
	dc.w	$D26A,$0014,$926B,$0014,$E441,$D36B,$0014,$376A
	dc.w	$0028,$0028,$376A,$002A,$002A,$6100,$02F8,$6100
	dc.w	$0062,$0839,$0000,$0001,$7F68,$6600,$003E,$4A79
	dc.w	$0001,$7BE0,$6A00,$002E,$302B,$0000,$B06B,$001C
	dc.w	$6600,$0022,$302B,$0014,$B06B,$0020,$6600,$0016
	dc.w	$7006,$046B,$0001,$0042,$6A00,$0006,$6100,$38B4
	dc.w	$6000,$0008,$377C,$0078,$0042,$4A2B,$002C,$6600
	dc.w	$5CCE,$4A6B,$0018,$6600,$5CC6,$6100,$030E,$6000
	dc.w	$5CBE,$0839,$0005,$0001,$7F68,$6700,$6430,$0839
	dc.w	$0002,$0001,$7F70,$6600,$6424,$227C,$0001,$834C
	dc.w	$45E9,$0366,$6100,$00A2,$C34A,$6100,$009C,$303C
	dc.w	$0054,$B06B,$0014,$6E00,$0044,$B06B,$0020,$6F00
	dc.w	$63FC,$0640,$000A,$0839,$0001,$0001,$7F68,$6700
	dc.w	$0004,$C34A,$7405,$206A,$0022,$4A68,$0034,$6B00
	dc.w	$0012,$B068,$0014,$6C00,$000A,$08EA,$0004,$0032
	dc.w	$4E75,$D0FC,$0080,$51CA,$FFE2,$4E75,$4440,$B06B
	dc.w	$0014,$6D00,$63B8,$B06B,$0020,$6C00,$63B0,$0440
	dc.w	$000A,$0839,$0001,$0001,$7F68,$6600,$0004,$C34A
	dc.w	$7405,$206A,$0022,$4A68,$0034,$6B00,$0012,$B068
	dc.w	$0014,$6F00,$000A,$08EA,$0004,$0032,$4E75,$D0FC
	dc.w	$0080,$51CA,$FFE2,$4E75
ClearOffsidesIfAllPlayers						;a2 = team struct: clear the team offsides flag once no skater is past the
									;line
	btst	#$4,$32(a2)
	beq.w	X_21000
	movea.l	$22(a2),a0
	moveq	#$5,d1
	tst.w	$34(a0)		;position: off ice keeps the last d0
	bmi.w	.next
	move.w	$14(a0),d0		;d0 = y toward the goal this player shoots at
	btst	#$7,$62(a0)
	bne.w	.next
	neg.w	d0
.next	adda.w	#$80,a0
	cmpi.w	#$58,d0
	dbgt	d1,$1AC9C
	bgt.w	X_21000
	bclr	#$4,$32(a2)
	rts
	dc.w	$0839,$0005,$0001,$7F68,$6700,$632A,$3039,$0001
	dc.w	$7B94,$082A,$0007,$0062,$6600,$0004,$4440,$0C40
	dc.w	$0068,$6D00,$6310,$207C,$0001,$834C,$082A,$0006
	dc.w	$0062,$6700,$0006,$D0FC,$0366,$0828,$0004,$0032
	dc.w	$6700,$62F2,$0839,$0004,$0001,$7F68,$6600,$62E6
	dc.w	$C54B,$7010,$6100,$36F8,$C54B,$4E75,$33EA,$0000
	dc.w	$0001,$7ECA,$33EA,$0014,$0001,$7ECC,$33EA,$0052
	dc.w	$0001,$7EC8,$207C,$0001,$834C,$082A,$0006,$0062
	dc.w	$6700,$0006,$41E8,$0366,$4240,$102A,$0066,$082A
	dc.w	$0003,$0064,$6700,$000A,$08F9,$0007,$0001,$7F7C
	dc.w	$B068,$0018,$6700,$0028,$08A8,$0003,$0032,$6600
	dc.w	$000E,$3168,$001A,$001C,$3168,$0018,$001A,$3140
	dc.w	$0018,$B068,$001C,$6600,$0006,$50E8,$001C,$08B9
	dc.w	$0004,$0001,$7F6C,$6100,$FF28,$0839,$0002,$0001
	dc.w	$7ECE,$6700,$0056,$0839,$0000,$0001,$7ECE,$6700
	dc.w	$004A,$4A6A,$0034,$6700,$0042,$0839,$0001,$0001
	dc.w	$7ECE,$6600,$002C,$082A,$0007,$0062,$6700,$002C
	dc.w	$4240,$1039,$0001,$7ECF,$EF40,$2F0B,$267C,$0001
	dc.w	$7480,$D6C0,$303C,$000C,$6100,$3624,$265F,$4E75
	dc.w	$082A,$0007,$0062,$6700,$FFD8,$4239,$0001,$7ECE
	dc.w	$13EA,$0053,$0001,$7ECF,$3039,$0001,$7B94,$082A
	dc.w	$0007,$0062,$6700,$000C,$08F9,$0001,$0001,$7ECE
	dc.w	$4440,$6B00,$61D0,$3039,$0001,$8372,$9079,$0001
	dc.w	$86D8,$082A,$0006,$0062,$6700,$0004,$4440,$6B00
	dc.w	$61B4,$08F9,$0002,$0001,$7ECE,$4E75
PuckIChk						;check for icing of puck penalty. Called from pucknorm
	btst	#$2,$17ECE.l		;#ifok
	beq.w	X_21000
	btst	#$0,$17ECE.l		;#ifcgl - if crossed goal line
	bne.w	X_21000
	tst.w	(puckc).l
	bpl.w	X_21000
	move.w	#$108,d0		;goalline
	btst	#$1,$17ECE.l		;#ifdir - 1 = must cross top line
	bne.w	.0
	neg.w	d0		;other direction: d0 = -(goal line y)
	cmp.w	(pucky).l,d0		;check other goalline
	bgt.w	.chkx		;puck y reached the goal line
	rts
.0	cmp.w	(pucky).l,d0
	bgt.w	X_21000
.chkx	cmpi.w	#$2C,(puckx).l		;2C - edge of crease
	bgt.w	.set
	cmpi.w	#$FFD4,(puckx).l		;FFD4 - edge of crease
	blt.w	.set
	bclr	#$2,$17ECE.l		;#ifok cleared
	rts
.set	bset	#$0,$17ECE.l		;#ifcgl
	rts
puckunflip						;stop spinning puck. a3 = puck. Entered from
									;pucknothing, called from pucknorm
	cmpi.w	#$8,$5A(a3)		;2*4 SPAnum
	blt.w	.k
	cmpi.w	#$18,$5A(a3)		;6*4
	bge.w	.k
	eori.w	#$2,$54(a3)		;facedir
.k	ori.w	#$4,$54(a3)		;facedir bit 2 set
	clr.w	$5A(a3)		;SPAnum
	st.b	$5C(a3)		;SPAcnt
	rts
	dc.w	$0240,$0001,$B16B,$0054,$026B,$0003,$0054,$50EB
	dc.w	$005C,$323C,$046A,$6000,$04B0,$0C6B,$018A,$0006
	dc.w	$6600,$002A,$376B,$FF80,$0000,$376B,$FF94,$0014
	dc.w	$426B,$0018,$7014,$0839,$0007,$0001,$7F6A,$6700
	dc.w	$0004,$7000,$0673,$0001,$0000,$4E75,$4A6B,$0006
	dc.w	$6700,$60B6,$426B,$0000,$377C,$012C,$0014,$377C
	dc.w	$000E,$0018,$4A6B,$FF94,$6A00,$0012,$377C,$8000
	dc.w	$0004,$446B,$0014,$046B,$0001,$0018,$4E75
findpc						;find puck crossing lines: calculate when puck will cross goalline (if at
									;all). Called from pucknorm fills puckcross (2 entries of x word, time
									;word): top goal line first, then bottom
	movem.l	d0-d4/a1-a2,-(sp)
	movea.l	#$17E36,a1
	move.w	#$88,d1		;sideline - distance from center to side boards
	move.w	#$108,d4		;goaline
	bsr.w	.calc		;top goal line (y = d4)
	neg.w	d4		;make d4 negative to check bottom goal line
	bsr.w	.calc		;bottom goal line (y = -d4)
	movem.l	(sp)+,d0-d4/a1-a2
	rts
.calc	move.w	d4,d0		;move goaline into d0
	sub.w	(pucky).l,d0		;sub pucky from d0
	tst.w	(puckvy).l		;check puckvy
	beq.w	.nocross		;branch if 0
	move.w	d0,d2		;move d0 into d2
	swap	d2		;swap upper and lower word of d2
	clr.w	d2		;clear bottom word of d2
	asr.l	#$4,d2		;shift 4 bits right (divide by 16)
	divs.w	(puckvy).l,d2		;divide puckvy into d2
	bmi.w	.nocross		;branch if negative
	move.w	d2,$2(a1)		;time until crossing in frames (puckcross y)
	muls.w	(puckvx).l,d0		;mult puckvx with d0
	divs.w	(puckvy).l,d0		;divide puckvy into d0
	bvs.w	.nocross		;branch if overflow set
	add.w	(puckx).l,d0		;add puckx to d0
	cmp.w	d1,d0		;compare d1 (sideline) to d0
	blt.w	.o1		;branch if less than (in play)
	neg.w	d0		;negate d0
	add.w	d1,d0		;add d1 3 times to d0
	add.w	d1,d0
	add.w	d1,d0
.o1	neg.w	d1		;negate d1
	cmp.w	d1,d0		;compare d1 (other sideline) to d0
	bgt.w	.o2		;branch if greater than (in play)
	neg.w	d0		;negate d0
	add.w	d1,d0		;add d1 to d0 3 times
	add.w	d1,d0
	add.w	d1,d0
.o2	neg.w	d1		;negate d1
	move.w	d0,(a1)		;move d0 into puckcross
	bra.w	.next
.nocross	move.w	#$FFFF,$2(a1)		;move -1 into puckcross y
.next	adda.w	#$4,a1		;next puckcross entry (the other goal line)
	rts
	dc.w	$9F2B,$0042,$6A00,$00C0,$062B,$000C,$0042,$6100
	dc.w	$00C0,$48A7,$C000,$302B,$0028,$E040,$4440,$D05F
	dc.w	$906B,$0000,$322B,$002A,$E041,$4441,$D25F,$926B
	dc.w	$0014,$0C40,$000C,$6E00,$0020,$0C40,$FFF4,$6D00
	dc.w	$0018,$0C41,$000C,$6E00,$0010,$0C41,$FFF4,$6D00
	dc.w	$0008,$7009,$6000,$0006,$6100,$0296,$4E90,$1740
	dc.w	$0043,$0C40,$0007,$6F00,$005E,$302B,$0028,$806B
	dc.w	$002A,$6600,$0052,$3039,$0001,$7B80,$3239,$0001
	dc.w	$7B94,$0839,$0000,$0001,$7BE3,$6700,$000E,$3039
	dc.w	$0001,$7EDC,$3239,$0001,$7EDE,$906B,$0000,$926B
	dc.w	$0014,$6100,$024C,$906B,$0054,$6700,$001A,$4440
	dc.w	$0240,$0004,$E248,$0440,$0001,$D06B,$0054,$0240
	dc.w	$0007,$3740,$0054,$4240,$102B,$0043,$6000,$0300
	dc.w	$4279,$0001,$7EEA,$4279,$0001,$7EEC,$4A6B,$0034
	dc.w	$6700,$5F16,$342B,$0000,$B142,$6A00,$0086,$3401
	dc.w	$946B,$0014,$362B,$0000,$C5C3,$9640,$85C3,$D46B
	dc.w	$0014,$0C42,$0121,$6E00,$006A,$0C42,$00DB,$6D00
	dc.w	$002C,$363C,$0144,$0C42,$00FE,$6E00,$0014,$6D00
	dc.w	$000C,$0C6B,$00FE,$0014,$6E00,$0006,$363C,$00B8
	dc.w	$9642,$33C3,$0001,$7EEC,$6000,$0038,$0C42,$FF25
	dc.w	$6E00,$0030,$0C42,$FEDF,$6D00,$0028,$363C,$FF48
	dc.w	$0C42,$FF02,$6E00,$0014,$6D00,$000C,$0C6B,$FF02
	dc.w	$0014,$6E00,$0006,$363C,$FEBC,$9642,$33C3,$0001
	dc.w	$7EEC,$3601,$0443,$00FE,$342B,$0014,$0442,$00FE
	dc.w	$6100,$0022,$3601,$0643,$00FE,$342B,$0014,$0642
	dc.w	$00FE,$6100,$0010,$D079,$0001,$7EEA,$D279,$0001
	dc.w	$7EEC,$4E75,$3803,$B544,$6A00,$5E4E,$3800,$986B
	dc.w	$0000,$C9C2,$9443,$89C2,$D86B,$0000,$0C44,$0050
	dc.w	$6E00,$5E36,$0C44,$FFB0,$6D00,$5E2E,$7650,$4A44
	dc.w	$6600,$0006,$4A6B,$0000,$6A00,$0004,$4443,$9644
	dc.w	$33C3,$0001,$7EEA,$4E75
skatetopuckinit						;d0/d1 = puck x/y plus half the high byte of its
									;velocity. Called from skatetopuck and assnearest
	move.b	(puckvx).l,d0		;high byte of the puck x velocity (signed)
	asr.b	#$1,d0		;halved
	ext.w	d0
	add.w	(puckx).l,d0		;d0 = puck x + vx/2
	move.b	(puckvy).l,d1
	asr.b	#$1,d1
	ext.w	d1
	add.w	(pucky).l,d1		;d1 = puck y + vy/2
	rts
	dc.w	$6100,$FFDC,$9F2B,$0042,$6A00,$00A0,$062B,$000A
	dc.w	$0042,$6100,$FEB2,$48A7,$C000,$2F0B,$6100,$0132
	dc.w	$4400,$4401,$902B,$0028,$4880,$D05F,$906B,$0000
	dc.w	$922B,$002A,$4881,$D25F,$926B,$0014,$6100,$00A8
	dc.w	$1740,$0043,$4A6B,$0034,$6700,$0060,$3039,$0001
	dc.w	$7BA8,$3239,$0001,$7BAA,$6100,$008C,$0A40,$0004
	dc.w	$B06B,$0054,$6700,$0044,$3039,$0001,$7B80,$906B
	dc.w	$0000,$3239,$0001,$7B94,$926B,$0014,$48A7,$C000
	dc.w	$6100,$0064,$B06B,$0054,$4C9F,$0003,$6600,$001C
	dc.w	$C1C0,$C3C1,$D081,$0C80,$0000,$0384,$6300,$000C
	dc.w	$0C80,$0000,$05A4,$6300,$AFF0,$102B,$0043,$6000
	dc.w	$0114,$066B,$0001,$0036,$026B,$0007,$0036,$08EB
	dc.w	$0001,$0062,$4E75,$046B,$0001,$0036,$026B,$0007
	dc.w	$0036,$2F01,$322B,$0036,$1780,$1038,$08EB,$0001
	dc.w	$0062,$221F,$4E75
vtoa						;d0/d1 are x/y distances which are converted into direction 0-7 and
									;returned in d0 (8 = no direction)
	movem.l	d2/a0,-(sp)
	move.w	d0,d2
	or.w	d1,d2
	beq.w	.nodir		;both zero: no direction
	clr.w	d2		;d2 = 4 bit index built from the signs and slope tests
	tst.w	d0
	bpl.w	.0
	neg.w	d0		;|dx|
	bset	#$0,d2		;bit 0: dx negative
.0	tst.w	d1		;y sign
	bpl.w	.1
	neg.w	d1		;|dy|
	bset	#$1,d2		;bit 1: dy negative
.1	asl.w	#$1,d1		;slope test: |dx| against 2|dy|
	cmp.w	d1,d0
	bhi.w	.2		;|dx| > 2|dy|
	bset	#$2,d2		;bit 2: |dx| <= 2|dy|
.2	lsr.w	#$1,d1		;slope test: |dy| against 2|dx|
	asl.w	#$1,d0
	cmp.w	d0,d1
	bhi.w	.3		;|dy| > 2|dx|
	bset	#$3,d2		;bit 3: |dy| <= 2|dx|
.3	movea.l	#$36352,a0		;#.dt
	clr.w	d0
	move.b	(a0,d2.w),d0
	movem.l	(sp)+,d2/a0
	rts
.nodir	moveq	#$8,d0		;8 = no direction
	movem.l	(sp)+,d2/a0
	rts
	dc.w	$0107,$0305,$0000,$0404,$0206,$0206,$0107,$0305
	dc.w	$48E7,$00C0,$206F,$000C,$4240,$4241,$4A68,$0006
	dc.w	$6F00,$0044,$2279,$0004,$7D28,$5589,$3028,$0006
	dc.w	$D040,$1231,$0001,$4881,$1031,$0000,$4880,$0828
	dc.w	$0003,$0004,$6700,$0004,$4440,$0828,$0004,$0004
	dc.w	$6600,$0004,$4441,$0839,$0007,$0001,$7F6A,$6700
	dc.w	$0006,$C141,$4441,$4CDF,$0300,$2E9F,$4E75,$B26B
	dc.w	$0058,$6700,$5C3A,$426B,$005A,$3741,$0058,$50EB
	dc.w	$005C,$4E75,$4A6B,$0034,$6700,$01C8,$323C,$050C
	dc.w	$082B,$0004,$0062,$6700,$0006,$323C,$0A60,$0240
	dc.w	$000F,$0C40,$0007,$6F00,$0022,$0C40,$0009,$6600
	dc.w	$000E,$302B,$0028,$806B,$002A,$6600,$06D2,$082B
	dc.w	$0001,$0063,$6700,$FFA8,$4E75,$48A7,$C000,$3400
	dc.w	$302B,$0052,$B079,$0001,$7BE0,$6700,$00C6,$3039
	dc.w	$0001,$7B80,$906B,$0000,$362B,$0014,$1239,$0001
	dc.w	$7BAA,$4881,$D279,$0001,$7B94,$9243,$082B,$0007
	dc.w	$0062,$6600,$000C,$4440,$4441,$4443,$0A42,$0004
	dc.w	$082B,$0004,$0062,$6600,$0028,$4A43,$6A00,$0084
	dc.w	$0C42,$0004,$6600,$007C,$6100,$FE7C,$0640,$0001
	dc.w	$0240,$0007,$0C40,$0002,$6200,$0068,$6000,$0026
	dc.w	$0442,$0003,$0242,$0007,$0C42,$0002,$6200,$0054
	dc.w	$6100,$FE54,$0640,$0002,$0240,$0007,$0C40,$0004
	dc.w	$6200,$0040,$082B,$0004,$0062,$6600,$003C,$302B
	dc.w	$0028,$806B,$002A,$6700,$0020,$302B,$0028,$322B
	dc.w	$002A,$6100,$FE22,$9057,$0640,$0001,$0240,$0007
	dc.w	$0C40,$0002,$6200,$0012,$08EB,$0004,$0062,$6000
	dc.w	$0008,$08AB,$0004,$0062,$4C9F,$0003,$342B,$0054
	dc.w	$9042,$0240,$0007,$207C,$0003,$6594,$E340,$4A70
	dc.w	$0000,$6700,$02A2,$382B,$0028,$C9C4,$362B,$002A
	dc.w	$C7C3,$D684,$4843,$383C,$0300,$9843,$0C44,$0180
	dc.w	$6C00,$0006,$383C,$0180,$C9F0,$0000,$082B,$0004
	dc.w	$0062,$6700,$0004,$4484,$D9AB,$0054,$026B,$0007
	dc.w	$0054,$342B,$0054,$0C43,$0014,$6300,$0028,$4241
	dc.w	$4A70,$0000,$6A00,$0006,$0A41,$FFCE,$082B,$0003
	dc.w	$0004,$6700,$0006,$0A41,$FFCE,$0641,$0694,$08EB
	dc.w	$0001,$0063,$6100,$FE38,$0C43,$0002,$6200,$02DA
	dc.w	$4E75,$0000,$0010,$0010,$0010,$0000,$FFF0,$FFF0
	dc.w	$FFF0,$082B,$0003,$0062,$6700,$0140,$48A7,$8000
	dc.w	$3039,$0001,$7BE0,$B06B,$0052,$4C9F,$0001,$6700
	dc.w	$012A,$0C6B,$0030,$0000,$6E00,$0120,$0C6B,$FFD0
	dc.w	$0000,$6D00,$0116,$0C6B,$FF40,$0014,$6E00,$0010
	dc.w	$0C6B,$FEFA,$0014,$6D00,$0102,$6000,$0016,$0C6B
	dc.w	$00C0,$0014,$6D00,$00F4,$0C6B,$0106,$0014,$6E00
	dc.w	$00EA,$48A7,$C000,$3039,$0001,$7B80,$906B,$0000
	dc.w	$3239,$0001,$7B94,$926B,$0014,$0C40,$0010,$6E00
	dc.w	$0022,$0C40,$FFF0,$6D00,$001A,$0C41,$0010,$6E00
	dc.w	$0012,$0C41,$FFF0,$6D00,$000A,$302B,$0054,$6000
	dc.w	$0006,$6100,$FCB2,$0839,$0000,$0001,$7F72,$6600
	dc.w	$000E,$6100,$CA02,$4C9F,$0003,$6000,$001A,$4C9F
	dc.w	$0003,$0C40,$0008,$6700,$000E,$48A7,$C000,$6100
	dc.w	$C9E6,$4C9F,$0003,$323C,$0002,$082B,$0001,$0063
	dc.w	$6600,$0102,$6100,$FD38,$0C40,$0008,$6600,$0056
	dc.w	$4A6B,$0034,$6600,$004E,$082B,$0003,$0062,$6700
	dc.w	$0044,$3F00,$302B,$0014,$082B,$0007,$0062,$6700
	dc.w	$0004,$4440,$0C40,$00D8,$6D00,$0022,$302B,$0000
	dc.w	$0C40,$0020,$6E00,$0016,$0C40,$FFE0,$6D00,$000E
	dc.w	$301F,$4EB9,$0002,$2F74,$6000,$000A,$4EB9,$0002
	dc.w	$2F74,$301F,$3400,$6000,$018E,$323C,$0002,$082B
	dc.w	$0003,$0062,$6700,$005E,$082B,$0002,$0062,$6600
	dc.w	$007A,$0C40,$0008,$6600,$0048,$4A6B,$0034,$6600
	dc.w	$006A,$3F00,$302B,$0014,$082B,$0007,$0062,$6700
	dc.w	$0004,$4440,$0C40,$00D8,$6D00,$0020,$302B,$0000
	dc.w	$0C40,$0020,$6E00,$0014,$0C40,$FFE0,$6D00,$000C
	dc.w	$301F,$6100,$03FE,$6000,$0032,$301F,$6000,$002C
	dc.w	$6000,$0034,$0240,$000F,$0C40,$0007,$6F00,$0028
	dc.w	$0C40,$0009,$6600,$0014,$302B,$0028,$806B,$002A
	dc.w	$6700,$0008,$4EF9,$0002,$2F74,$082B,$0001,$0063
	dc.w	$6700,$FC3C,$4E75,$906B,$0054,$6700,$001A,$4440
	dc.w	$0240,$0004,$E248,$0440,$0001,$D06B,$0054,$0240
	dc.w	$0007,$3740,$0054,$323C,$03D8,$6100,$FC12,$342B
	dc.w	$0054,$6000,$00C2
