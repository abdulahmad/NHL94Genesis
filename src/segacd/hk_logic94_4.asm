	include	segacd\hockey.inc
	include	macros\genesis.mac

AddPenalty2	equ	$39456
Crowdlevel	equ	$17CD2
Hpos	equ	$17CEE
LOAD	equ	$1B000
SortCords	equ	$17480
Vpos	equ	$17CEA
move	equ	$2C9C8
puckvx	equ	$17BA8
puckvy	equ	$17BAA
puckx	equ	$17B80
pucky	equ	$17B94
sfx	equ	$3710C
vtoa	equ	$362F8
X_16906	equ	$16906
X_16AB6	equ	$16AB6
X_17D2C	equ	$17D2C
X_17F34	equ	$17F34
X_17F82	equ	$17F82
X_18056	equ	$18056
X_18AFA	equ	$18AFA
X_1B008	equ	$1B008
X_1B2C4	equ	$1B2C4
X_1B2D8	equ	$1B2D8
X_1B3C0	equ	$1B3C0

	org	$16FE6

rtss6						;shared rts for the early exits nearby
	btst	#$3,$62(a3)
	beq.w	X_1B008
	rts
	btst	#$5,$62(a3)
	bne.w	X_16AB6
	btst	#$0,$17F68.l
	dc.w	$6600,$FEAC,$6100,$F8FC,$082B,$0003,$0062,$6600
	dc.w	$FAA2,$08AB,$0001,$0062,$6700,$000C,$426B,$0040
	dc.w	$377C,$0008,$0042,$9F2B,$0040,$6A00,$006E,$176B
	dc.w	$006A,$0040,$4EB9,$0002,$AEDC,$6B00,$0016,$0839
	dc.w	$0006,$0001,$7F7A,$6700,$0010,$4A2B,$0040,$6700
	dc.w	$0008,$042B,$0001,$0040,$7002,$082A,$0004,$0032
	dc.w	$6600,$427E,$3239,$0001,$7B94,$082B,$0007,$0062
	dc.w	$6600,$0004,$4441,$0C41,$005D,$6D00,$4264,$3239
	dc.w	$0001,$7BE0,$6B00,$0014,$0441,$0006,$342B,$0052
	dc.w	$0442,$0006,$B541,$6B00,$4248,$41FA,$1BCE,$7050
	dc.w	$0C6B,$0002,$0034,$6700,$0004,$4440,$323C,$0062
	dc.w	$082B,$0007,$0062,$6600,$0006,$4440,$4441,$3439
	dc.w	$0001,$7B80,$B142,$6B00,$000C,$3039,$0001,$7B80
	dc.w	$6000,$3F32,$3439,$0001,$7B80,$E242,$D042,$6000
	dc.w	$3F24,$082B,$0005,$0062,$6600,$F9C8,$0839,$0000
	dc.w	$0001,$7F68,$6600,$FDB8,$6100,$F808,$082B,$0003
	dc.w	$0062,$6600,$F9AE,$08AB,$0001,$0062,$6700,$000C
	dc.w	$426B,$0040,$377C,$0008,$0042,$9F2B,$0040,$6A00
	dc.w	$0176,$176B,$006B,$0040,$0839,$0006,$0001,$7F7A
	dc.w	$6700,$0010,$4A2B,$0040,$6700,$0008,$042B,$0001
	dc.w	$0040,$3239,$0001,$7B94,$3639,$0001,$7BAA,$EC43
	dc.w	$082B,$0007,$0062,$6600,$0006,$4441,$4443,$4A43
	dc.w	$6A00,$0004,$4243,$D641,$0C43,$0058,$6D00,$0032
	dc.w	$082A,$0004,$0032,$6600,$0028,$3239,$0001,$7BE0
	dc.w	$6B00,$001E,$6100,$172C,$6700,$0016,$7001,$0441
	dc.w	$0006,$342B,$0052,$0442,$0006,$B541,$6A00,$4142
	dc.w	$377C,$0041,$0044,$0C6B,$0002,$0034,$6700,$0006
	dc.w	$446B,$0044,$207C,$0001,$7480,$0C6B,$0006,$0052
	dc.w	$6C00,$0006,$D0FC,$0300,$7405,$303C,$FC18,$082B
	dc.w	$0007,$0062,$6700,$0062,$4440,$0828,$0002,$0063
	dc.w	$6600,$0022,$4A68,$0034,$6B00,$001A,$3228,$002A
	dc.w	$6B00,$0004,$4241,$E841,$D268,$0014,$B240,$6E00
	dc.w	$0004,$3001,$D0FC,$0080,$51CA,$FFD0,$0440,$0032
	dc.w	$0C40,$FF42,$6E00,$0006,$303C,$FF24,$3740,$0046
	dc.w	$3039,$0001,$7B80,$322B,$0044,$B141,$6A00,$0068
	dc.w	$426B,$0044,$6000,$0060,$0828,$0002,$0063,$6600
	dc.w	$0022,$4A68,$0034,$6B00,$001A,$3228,$002A,$6A00
	dc.w	$0004,$4241,$E841,$D268,$0014,$B240,$6D00,$0004
	dc.w	$3001,$D0FC,$0080,$51CA,$FFD0,$0640,$0032,$0C40
	dc.w	$00BE,$6D00,$0006,$303C,$00DC,$3740,$0046,$446B
	dc.w	$0044,$3039,$0001,$7B80,$322B,$0044,$B141,$6A00
	dc.w	$0006,$426B,$0044,$302B,$0044,$322B,$0046,$207C
	dc.w	$0003,$3C6E,$6100,$3D5E,$6000,$1F7C,$4E75,$082B
	dc.w	$0005,$0062,$6600,$FFF6,$0839,$0000,$0001,$7F68
	dc.w	$6600,$FBEC,$6100,$F63C,$082B,$0003,$0062,$6600
	dc.w	$FFDC,$08AB,$0001,$0062,$6700,$000C,$426B,$0040
	dc.w	$377C,$0008,$0042,$9F2B,$0040,$6A00,$0040,$176B
	dc.w	$006B,$0040,$0839,$0006,$0001,$7F7A,$6700,$0010
	dc.w	$4A2B,$0040,$6700,$0008,$042B,$0001,$0040,$3239
	dc.w	$0001,$7BE0,$6B00,$0016,$7004,$0441,$0006,$342B
	dc.w	$0052,$0442,$0006,$B541,$6A00,$3FB6,$7064,$0C6B
	dc.w	$0005,$0034,$6600,$0004,$4440,$223C,$0000,$009E
	dc.w	$082B,$0007,$0062,$6700,$003A,$4440,$4441,$74B2
	dc.w	$082A,$0004,$0032,$6600,$0058,$B479,$0001,$7B94
	dc.w	$6E00,$000C,$3239,$0001,$7B94,$6000,$0046,$343C
	dc.w	$FEF8,$B479,$0001,$7B94,$6D00,$0038,$3202,$6000
	dc.w	$0032,$744E,$082A,$0004,$0032,$6600,$0024,$B479
	dc.w	$0001,$7B94,$6D00,$000C,$3239,$0001,$7B94,$6000
	dc.w	$0012,$343C,$0108,$B479,$0001,$7B94,$6E00,$0004
	dc.w	$3202,$41F9,$0003,$22B0,$3439,$0001,$7B80,$B142
	dc.w	$6B00,$3C42,$3039,$0001,$7B80,$6000,$3C38,$082B
	dc.w	$0005,$0062,$6600,$FED6,$0839,$0000,$0001,$7F68
	dc.w	$6600,$FACC,$6100,$F51C,$082B,$0003,$0062,$6600
	dc.w	$FEBC,$08AB,$0001,$0062,$6700,$0010,$50EB,$0048
	dc.w	$426B,$0040,$377C,$0008,$0042,$9F2B,$0040,$6A00
	dc.w	$0136,$176B,$006B,$0040,$0839,$0006,$0001,$7F7A
	dc.w	$6700,$0010,$4A2B,$0040,$6700,$0008,$042B,$0001
	dc.w	$0040,$7003,$3239,$0001,$7BE0,$6B00,$0014,$0441
	dc.w	$0006,$342B,$0052,$0442,$0006,$B541,$6B00,$3E92
	dc.w	$3039,$0001,$7B94,$3639,$0001,$7BAA,$EC43,$D640
	dc.w	$082B,$0007,$0062,$6600,$0006,$4440,$4443,$4242
	dc.w	$0C43,$FFA8,$6D00,$0028,$0642,$0008,$0C40,$0058
	dc.w	$6D00,$001C,$082A,$0004,$0032,$6600,$0012,$0642
	dc.w	$0008,$0C43,$0108,$6D00,$0006,$0642,$0008,$B46B
	dc.w	$0048,$6600,$0056,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$33FC,$001B,$00FF,$8020,$08F9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$67F6,$3039,$00FF,$8010
	dc.w	$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF
	dc.w	$800F,$0240,$007F,$6600,$004E,$3742,$0048,$41FA
	dc.w	$0026,$3030,$2002,$6100,$4B38,$D070,$2000,$3740
	dc.w	$0044,$3030,$2006,$6100,$4B28,$D070,$2004,$3740
	dc.w	$0046,$6000,$0022,$0050,$0014,$FFBA,$000A,$0064
	dc.w	$0014,$003A,$0005,$003C,$0032,$00E6,$0014,$0050
	dc.w	$001E,$00FA,$0014,$302B,$0044,$0C6B,$0005,$0034
	dc.w	$6700,$0004,$4440,$322B,$0046,$082B,$0007,$0062
	dc.w	$6600,$0006,$4440,$4441,$41FA,$1700,$6000,$3A96
	dc.w	$4E75,$082B,$0005,$0062,$6600,$FFF6,$0839,$0000
	dc.w	$0001,$7F68,$6600,$F928,$6100,$F378,$082B,$0003
	dc.w	$0062,$6600,$FFDC,$08AB,$0001,$0062,$6700,$000C
	dc.w	$426B,$0040,$377C,$0008,$0042,$9F2B,$0040,$6A00
	dc.w	$0040,$176B,$006B,$0040,$0839,$0006,$0001,$7F7A
	dc.w	$6700,$0010,$4A2B,$0040,$6700,$0008,$042B,$0001
	dc.w	$0040,$3239,$0001,$7BE0,$6B00,$0016,$7006,$0441
	dc.w	$0006,$342B,$0052,$0442,$0006,$B541,$6A00,$3CF2
	dc.w	$3039,$0001,$7B80,$E240,$3439,$0001,$7B94,$082B
	dc.w	$0007,$0062,$6600,$0004,$4442,$7280,$0C42,$FFA8
	dc.w	$6D00,$000A,$D279,$0001,$7B94,$E241,$082B,$0007
	dc.w	$0062,$6600,$0004,$4441,$41F9,$0003,$2574,$6000
	dc.w	$39D4,$082B,$0005,$0062,$6600,$FF36,$0839,$0000
	dc.w	$0001,$7F68,$6600,$F868,$6100,$F2B8,$082B,$0003
	dc.w	$0062,$6600,$FF1C,$08AB,$0001,$0062,$6700,$0010
	dc.w	$50EB,$0048,$426B,$0040,$377C,$0008,$0042,$9F2B
	dc.w	$0040,$6A00,$012A,$176B,$006B,$0040,$0839,$0006
	dc.w	$0001,$7F7A,$6700,$0010,$4A2B,$0040,$6700,$0008
	dc.w	$042B,$0001,$0040,$3239,$0001,$7BE0,$6B00,$0016
	dc.w	$7005,$0441,$0006,$342B,$0052,$0442,$0006,$B541
	dc.w	$6B00,$3C2E,$3039,$0001,$7B94,$082B,$0007,$0062
	dc.w	$6600,$0004,$4440,$4242,$0C40,$FFA8,$6D00,$0028
	dc.w	$0642,$0008,$0C40,$0058,$6D00,$001C,$082A,$0004
	dc.w	$0032,$6600,$0012,$0642,$0008,$0C40,$0108,$6D00
	dc.w	$0006,$0642,$0008,$B46B,$0048,$6600,$0056,$0839
	dc.w	$0007,$00FF,$800E,$66F6,$33FC,$001B,$00FF,$8020
	dc.w	$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$67F6,$3039,$00FF,$8010,$08F9,$0007,$00FF,$800F
	dc.w	$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$66F6,$08B9,$0007,$00FF,$800F,$0240,$007F,$6600
	dc.w	$004E,$3742,$0048,$41FA,$0026,$3030,$2002,$6100
	dc.w	$48E0,$D070,$2000,$3740,$0044,$3030,$2006,$6100
	dc.w	$48D0,$D070,$2004,$3740,$0046,$6000,$0022,$0000
	dc.w	$003C,$FFBA,$000A,$0000,$003C,$003C,$000A,$0000
	dc.w	$0028,$00AA,$001E,$0000,$0050,$00AA,$0014,$302B
	dc.w	$0044,$322B,$0046,$082B,$0007,$0062,$6600,$0004
	dc.w	$4441,$41FA,$14B6,$6000,$384C
assgoaliectrl						;joypad controlled goalie control: a3 = goalie; a goalie not on the
									;joystick leaves through assexit
	btst	#$3,$62(a3)		;is player joystick controlled?
	bne.w	.goaliectrl		;branch is so
	bra.w	X_1B2C4
.goaliectrl	btst	#$1,$62(a3)		;check if new assignment
	bne.w	.na		;branch if new assignment
	movem.w	d0-d1,-(sp)		;push to stack
	move.w	$0(a3),d0		;Xpos
	move.w	$14(a3),d1		;Ypos
	cmpi.w	#$AA,d1		;compare $AA to Ypos
	bgt.w	.cont
	cmpi.w	#$FF56,d1		;check -$AA to Ypos
	blt.w	.cont		;branch if less than
	btst	#$0,$17F68.l		;check if clock stopped
	bne.w	.cont		;branch if so
	move.w	d0,-(sp)		;push to stack
	move.w	#$8,d0		;clock stoppage due to goalie out of range
	jsr	(AddPenalty2).l
	move.w	(sp)+,d0		;pop from stack
.cont	sub.w	(Hpos).l,d0		;sub ice rink horiz position from Xpos
	sub.w	(Vpos).l,d1		;sub ice rink vert position from Ypos
	bclr	#$2,$64(a3)		;clear goalie control bit?
	cmpi.w	#$74,d0		;compare $74 to Xpos diff
	blt.w	.0		;branch if less than
	bset	#$2,$64(a3)		;set goalie control bit?
	bra.w	.cont2
.0	cmpi.w	#$FF8C,d0		;compare -$74 to Xpos diff
	bgt.w	.1		;branch if greater than
	bset	#$2,$64(a3)		;set goalie control bit?
	bra.w	.cont2
.1	cmpi.w	#$64,d1		;compare $64 to Ypos diff
	blt.w	.2		;branch if less than
	bset	#$2,$64(a3)		;set goalie control bit?
	bra.w	.cont2
.2	cmpi.w	#$FF9C,d1		;compare -$64 to Ypos diff
	bgt.w	.cont2		;branch if greater than
	bset	#$2,$64(a3)		;set goalie control bit?
.cont2	movem.w	(sp)+,d0-d1		;pop from stack
	btst	#$2,$64(a3)		;check goalie ctrl bit
	bne.w	.l17930		;branch if set
.na	btst	#$5,$62(a3)		;check if anim lock
	bne.w	X_16AB6		;exit if so
	bsr.w	X_16906
	bclr	#$1,$62(a3)		;clear new assignment bit
	beq.w	.nna		;branch if already cleared
	clr.w	$40(a3)		;clear temp1
	move.w	#$8,$42(a3)		;move 8 into temp2
	st.b	$46(a3)		;FFFF to temp4
.nna	btst	#$1,$63(a3)		;check if anim in progress
	bne.w	.ex		;exit if so
	btst	#$0,$17F68.l		;check if clock stopped
	bne.w	X_16AB6		;exit if so
	tst.w	$48(a3)		;test temp5
	bmi.w	.nofo		;branch if less than 0
	move.w	$52(a3),d0		;move SCnum into d0
	cmp.w	$17BE0.l,d0		;check if puckc is goalie
	beq.w	.mbfo		;branch if equal
	st.b	$48(a3)		;set temp5 to -1
	bra.w	.nofo
.mbfo	sub.w	d7,$48(a3)		;subtract d7(frames elapsed) from temp5
	bpl.w	.nofo		;branch if more than 0
	btst	#$2,$17F70.l		;check bit 2
	beq.w	.l178EA		;branch if not set
	bset	#$4,$17F70.l
	bra.w	.nofo
.l178EA	moveq	#$8,d0
	bsr.w	AddPenalty2-LOAD
.nofo	sub.b	d7,$40(a3)		;sub d7(frames elapsed) from temp1
	bpl.w	.ex		;branch if positive
	move.b	$6B(a3),d0		;DfA into d0
	beq.w	.3		;branch if value was 0
	btst	#$6,$17F7A.l		;check if crowd meter broken
	beq.w	.3		;jump if not
	subi.b	#$1,d0		;sub 1 from d0
.3	lsr.b	#$2,d0		;divide by 4
	move.b	d0,$40(a3)		;move d0 into temp1
	move.w	$52(a3),d0		;move SCnum into d0
	cmp.w	$17BE0.l,d0		;compare puckc to d0
	beq.w	.ex		;jump to assgoaliecpu if the same
.ex	rts
	btst	#$3,$62(a3)
	bne.w	assgoaliectrl
.l17930	move.w	(puckx).l,$1AD58.l
	btst	#$0,$17F72.l
	beq.w	.l179E8
	btst	#$1,$63(a3)
	bne.w	.l179E8
	btst	#$1,$17F72.l
	beq.w	.l17990
	btst	#$3,$17F72.l
	bne.w	.l179E8
	cmpi.w	#$2C4,$6(a3)
	bne.w	.l179E8
	cmpi.w	#$2C8,$6(a3)
	bne.w	.l179E8
	bset	#$3,$17F72.l
	move.w	#$1C,-(sp)
	bsr.w	sfx-LOAD
	bra.w	.l179E8
.l17990	movem.w	d0-d1,-(sp)
	move.w	(pucky).l,d0
	move.w	$14(a3),d1
	eor.w	d1,d0
	movem.w	(sp)+,d0-d1
	bmi.w	.l179E8
	cmpi.w	#$14,$0(a3)
	bgt.w	.l179E8
	cmpi.w	#$FFEC,$0(a3)
	ble.w	.l179E8
	bset	#$1,$17F72.l
	bclr	#$3,$17F72.l
	move.w	#$1596,d1
	btst	#$7,$62(a3)
	beq.w	.l179DE
	move.w	#$1684,d1
.l179DE	bsr.w	X_1B3C0
	bset	#$1,$63(a3)
.l179E8	btst	#$5,$62(a3)
	bne.w	X_18056
	bsr.w	X_16906
	bclr	#$1,$62(a3)
	beq.w	.l17A0E
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
	st.b	$46(a3)
.l17A0E	cmpi.w	#$34,$0(a3)
	bgt.w	.l17A4A
	cmpi.w	#$FFCC,$0(a3)
	blt.w	.l17A4A
	cmpi.w	#$10E,$14(a3)
	bgt.w	.l17A4A
	cmpi.w	#$FEF2,$14(a3)
	blt.w	.l17A4A
	cmpi.w	#$D2,$14(a3)
	bgt.w	.l17A6E
	cmpi.w	#$FF2E,$14(a3)
	blt.w	.l17A6E
.l17A4A	lea.l	X_18056(pc),a0
	moveq	#$4,d0
	tst.w	$0(a3)
	bpl.w	.l17A5A
	neg.w	d0
.l17A5A	move.w	#$E4,d1
	btst	#$7,$62(a3)
	beq.w	X_1B008
	neg.w	d1
	bra.w	X_1B008
.l17A6E	btst	#$1,$63(a3)
	bne.w	X_18056
	btst	#$0,$17F72.l
	beq.w	.l17AA8
	cmpi.w	#$2C5,$6(a3)
	beq.w	.l17AA2
	cmpi.w	#$2C9,$6(a3)
	bne.w	.l17AA8
	move.w	#$4,$54(a3)
	bra.w	.l17AA8
.l17AA2	move.w	#$0,$54(a3)
.l17AA8	move.w	#$2,d1
	bsr.w	X_1B3C0
	btst	#$2,$17F70.l
	bne.w	.l17AC8
	btst	#$0,$17F68.l
	bne.w	X_18056
.l17AC8	tst.w	$48(a3)
	bmi.w	.l17B0C
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	beq.w	.l17AE6
	st.b	$48(a3)
	bra.w	.l17B0C
.l17AE6	sub.w	d7,$48(a3)
	bpl.w	.l17B0C
	btst	#$2,$17F70.l
	beq.w	.l17B06
	bset	#$4,$17F70.l
	bra.w	.l17B0C
.l17B06	moveq	#$8,d0
	bsr.w	AddPenalty2-LOAD
.l17B0C	sub.b	d7,$40(a3)
	bpl.w	X_17F82
	move.b	$6B(a3),d0
	beq.w	.l17B2C
	btst	#$6,$17F7A.l
	beq.w	.l17B2C
	subi.b	#$1,d0
.l17B2C	lsr.b	#$2,d0
	move.b	d0,$40(a3)
	btst	#$3,$62(a3)
	beq.w	.l17B4C
	btst	#$2,$64(a3)
	bne.w	.l17B4C
	moveq	#$1D,d0
	bra.w	X_1B2D8
.l17B4C	move.w	(pucky).l,d0
	move.w	$14(a3),d1
	eor.w	d0,d1
	bpl.w	.l17B72
	clr.w	d0
	move.w	#$F4,d2
	btst	#$7,$62(a3)
	beq.w	X_17F34
	neg.w	d2
	bra.w	X_17F34
.l17B72	subi.w	#$1,$46(a3)
	bpl.w	.l17B82
	move.w	#$FFFF,$46(a3)
.l17B82	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	bne.w	.l17C6C
	tst.w	$48(a3)
	bpl.w	.l17B9E
	move.w	#$5A,$48(a3)
.l17B9E	st.b	$46(a3)
	cmpi.w	#$5A,$48(a3)
	bgt.w	.l17D12
.l17BAC	btst	#$7,$FF800E.l
	bne.b	.l17BAC
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.l17BC6	btst	#$6,$FF800E.l
	beq.b	.l17BC6
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l17BE6	btst	#$6,$FF800E.l
	bne.b	.l17BE6
	bclr	#$7,$FF800F.l
	andi.w	#$3,d0
	bne.w	.l17D12
	moveq	#$5,d0
	movea.l	#SortCords,a0
	btst	#$6,$62(a3)
	bne.w	.l17C16
	adda.w	#$300,a0
.l17C16	btst	#$2,$63(a0)
	bne.w	.l17C54
	move.w	(pucky).l,d1
	sub.w	$14(a0),d1
	cmpi.w	#$1C,d1
	bgt.w	.l17C54
	cmpi.w	#$FFE4,d1
	blt.w	.l17C54
	move.w	(puckx).l,d1
	sub.w	$0(a0),d1
	cmpi.w	#$19,d1
	bgt.w	.l17C54
	cmpi.w	#$FFE7,d1
	bgt.w	.l17D12
.l17C54	adda.w	#$80,a0
	dbra	d0,.l17C16
	move.w	#$1,$17E34.l
	bsr.w	X_18AFA
	bra.w	.l17D12
.l17C6C	tst.w	$46(a3)
	bne.w	.l17D12
	tst.w	$17BE0.l
	bpl.w	.l17D12
	move.w	(puckx).l,d0
	sub.w	$0(a3),d0
	cmpi.w	#$14,d0
	bgt.w	.l17D12
	cmpi.w	#$FFEC,d0
	blt.w	.l17D12
	move.w	(pucky).l,d1
	cmpi.w	#$108,d1
	bgt.w	.l17D12
	cmpi.w	#$FEF8,d1
	blt.w	.l17D12
	sub.w	$14(a3),d1
	cmpi.w	#$1E,d1
	bgt.w	.l17D12
	cmpi.w	#$FFE2,d1
	blt.w	.l17D12
	movem.w	d0-d1,-(sp)
	move.w	(puckvx).l,d0
	bpl.w	.l17CD2
	neg.w	d0
.l17CD2	move.w	(puckvy).l,d1
	bpl.w	.l17CDE
	neg.w	d1
.l17CDE	add.w	d1,d0
	cmpi.w	#$1000,d0
	movem.w	(sp)+,d0-d1
	bgt.w	.l17D12
	bsr.w	vtoa-LOAD
	move.w	d0,$54(a3)
	move.b	#$8,$5E(a3)
	move.w	#$2F4,d1
	bsr.w	X_1B3C0
	bset	#$1,$63(a3)
	addi.w	#$96,(Crowdlevel).l
	rts
.l17D12	movea.l	#$17E36,a0
	move.w	#$104,d3
	btst	#$7,$62(a3)
	beq.w	X_17D2C
	dc.w	$D0FC,$0004,$4443,$0C6B,$0104,$0014,$6E00,$000C
	dc.w	$0C6B,$FEFC,$0014,$6E00,$002C,$4242,$4240,$0C6B
	dc.w	$002C,$0000,$6E00,$01E8,$0C6B,$FFD4,$0000,$6D00
	dc.w	$01DE,$303C,$0088,$4A6B,$0000,$6A00,$01D2,$4440
	dc.w	$6000,$01CC,$4A79,$0001,$7BE0,$6B00,$003A,$302B
	dc.w	$0052,$B079,$0001,$7BE0,$6700,$002C,$2F08,$207C
	dc.w	$0001,$7480,$3039,$0001,$7BE0,$EF40,$D0C0,$3039
	dc.w	$0001,$7B80,$9068,$0000,$E240,$D068,$0000,$33C0
	dc.w	$0001,$AD58,$205F,$3039,$0001,$AD58,$3239,$0001
	dc.w	$7B94,$6100,$0272,$6100,$353A,$6100,$0296,$3039
	dc.w	$0001,$80E6,$0240,$0007,$E940,$0640,$00A0,$0C79
	dc.w	$00DB,$0001,$7B94,$6E00,$000E,$0C79,$FF25,$0001
	dc.w	$7B94,$6E00,$0006,$0440,$0040,$3200,$C1F9,$0001
	dc.w	$7BA8,$4840,$D079,$0001,$AD58,$C3F9,$0001,$7BAA
	dc.w	$4841,$D279,$0001,$7B94,$6100,$021C,$48A7,$C000
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
