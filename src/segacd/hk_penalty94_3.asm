	include	segacd\hockey.inc
	include	macros\genesis.mac

BA_Goalie_SCnum	equ	$1936A
BA_Sktr_SCnum	equ	$19368
Framer	equ	$38CA0
GetPlayerCount	equ	$2EDBC
LOAD	equ	$1B000
game	equ	$2C6D6
move	equ	$2C9C8
printa	equ	$18D5C
printx	equ	$18D58
printy	equ	$18D5A
printz	equ	$38F6E
priolist	equ	$41AD6
sublist	equ	$41A6C
X_1B2E4	equ	$1B2E4
X_21000	equ	$21000
X_21D1C	equ	$21D1C
X_21E98	equ	$21E98
X_21F04	equ	$21F04
X_22312	equ	$22312
X_2231E	equ	$2231E
X_223BA	equ	$223BA
X_22754	equ	$22754
X_22770	equ	$22770
X_2581C	equ	$2581C

	org	$21D3E

NewTicker3						;Display ticker score for game d3 (a0 = gstruct entry), skip if d3 is
									;negative. Called from chkprogress, Intermission and StartHL2
	tst.w	d3
	bmi.w	X_21000
	bsr.w	X_21E98		;d0/d1 = box size
	bsr.w	Framer-LOAD		;draw the ticker box
	addi.w	#$1,(printx).l		;inside the frame, top row
	subi.w	#$4,(printy).l
	move.w	(printx).l,-(sp)		;box x: .tn reads it at 4(sp), above its return address
	bsr.w	X_2581C
	move.w	#$A000,(printa).l
	bsr.w	printz-LOAD
	String	'                        '		;24 spaces
	dc.w	$33D7,$0001,$8D58,$7001,$D079,$0001,$8A9E,$4A79
	dc.w	$0001,$8BFA,$6600,$0004,$4240,$43FA,$0094,$6100
	dc.w	$0112,$3028,$0008,$0440,$0001,$227C,$0004,$1A34
	dc.w	$6100,$0108,$3011,$E248,$4440,$D057,$0640,$0017
	dc.w	$33C0,$0001,$8D58,$6100,$C1AC,$33FC,$8000,$0001
	dc.w	$8D5C,$3028,$0002,$3228,$000C,$6100,$0014,$3028
	dc.w	$0000,$3228,$000A,$6100,$0008,$DEFC,$0002,$4E75
	dc.w	$33EF,$0004,$0001,$8D58,$0679,$0001,$0001,$8D5A
	dc.w	$227C,$0001,$B00C,$E540,$2271,$0000,$D2E9,$0004
	dc.w	$6100,$C162,$33EF,$0004,$0001,$8D58,$0679,$0015
	dc.w	$0001,$8D58,$3001,$7202,$6100,$C364,$6000,$C146
	dc.w	$0012,$4541,$2048,$6F63,$6B65,$7920,$4E69,$6768
	dc.w	$7400,$0018,$5374,$616E,$6C65,$7920,$4375,$7020
	dc.w	$5175,$616C,$6966,$6965,$7200,$000E,$5175,$6172
	dc.w	$7465,$7266,$696E,$616C,$0018,$5374,$616E,$6C65
	dc.w	$7920,$4375,$7020,$5365,$6D69,$6669,$6E61,$6C00
	dc.w	$6100,$000A,$343C,$07FF,$6000,$BD70,$6100,$C0D4
	dc.w	$0006,$BD03,$1700,$0839,$0000,$0001,$7F6A,$6600
	dc.w	$000C,$6100,$C0BE,$0006,$BF03,$1700,$701A,$7205
	dc.w	$4E75,$6100,$0006,$6000,$BEDA,$6000,$0004,$D2D1
	dc.w	$51C8,$FFFC,$4E75
DoHiLights						;Hilites logic: search for hilite game and show
									;hilite. Called from Intermission
	bsr.w	X_2581C		;d1 = highest game index
	moveq	#$10,d3		;gssize
	mulu.w	d1,d3
	movea.l	#$18A18,a0
	adda.w	d3,a0
.top	btst	#$2,$E(a0)		;gsfso
	bne.w	.next		;series over
	bclr	#$1,$E(a0)		;gsfhl
	beq.w	.next		;no highlight requested
	bsr.w	X_21F04
.next	suba.w	#$10,a0		;gssize
	dbra	d1,.top
	rts
	dc.w	$48E7,$FFFE
StartHL2						;Play hilite for game a0. Start skips it with a random result. A tied game
									;is replayed (beq StartHL2). Uses
									;song $79, setupice_highlight, setplayercolors
	btst	#$3,$17F6E.l		;sf3sbut
	bne.w	X_2231E		;start already pressed: just pick a random result
	bsr.w	X_223BA		;save the real game state (gmode ... ScoreSumbytes)
	move.w	d1,d3
	bsr.w	X_21D1C
	bsr.w	NewTicker3		;show score from hilight game
	btst	#$3,$17F6E.l
	bne.w	X_22312
	move.w	#$4,(printx).l		;"Highlight from game:" box, 24x3 above the ticker
	subi.w	#$6,(printy).l
	moveq	#$18,d0		;24
	moveq	#$3,d1
	bsr.w	Framer-LOAD
	addi.w	#$1,(printx).l
	subi.w	#$2,(printy).l
	bsr.w	printz-LOAD
	String	'Highlight from game:'		;the text as code
	dc.w	$303C,$00B4,$6100,$A3CA,$0801,$0007,$6600,$0394
	dc.w	$50F9,$0001,$7CE2,$4279,$0001,$7CD8,$33E8,$0000
	dc.w	$0001,$7FAE,$33E8,$0002,$0001,$7FB0,$2F08,$4279
	dc.w	$0001,$8374,$4279,$0001,$86DA,$4EB9,$0003,$F11E
	dc.w	$4EB9,$0002,$B996,$50F9,$0001,$7F9E,$50F9,$0001
	dc.w	$7FA0,$4279,$0001,$7FA6,$4279,$0001,$7FA8,$7078
	dc.w	$6100,$A07E,$0640,$003C,$33C0,$0001,$80E6,$2057
	dc.w	$33E8,$0008,$0001,$80E4,$0479,$0001,$0001,$80E4
	dc.w	$33E8,$000A,$0001,$8358,$33E8,$000C,$0001,$86BE
	dc.w	$13FC,$0010,$0001,$7F68,$0839,$0000,$0001,$80E5
	dc.w	$6700,$000A,$08F9,$0001,$0001,$7F68,$4239,$0001
	dc.w	$7F6A,$13FC,$0004,$0001,$7F6C,$4239,$0001,$7F6E
	dc.w	$08B9,$0004,$0001,$8D64,$08F9,$0003,$0001,$8D64
	dc.w	$4279,$0001,$7E32,$4239,$0001,$7ECE,$50F9,$0001
	dc.w	$806E,$50F9,$0001,$7E38,$50F9,$0001,$7E3C,$4EB9
	dc.w	$0004,$7DAC,$6100,$1AD6,$33FC,$0001,$0001,$7468
	dc.w	$6100,$F33A,$33FC,$0000,$0001,$7468,$207C,$00C0
	dc.w	$0000,$0839,$0007,$00FF,$800E,$66F6,$33FC,$9100
	dc.w	$00FF,$8022,$33FC,$000A,$00FF,$8020,$08F9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9
	dc.w	$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F
	dc.w	$0839,$0007,$00FF,$800E,$66F6,$33FC,$9200,$00FF
	dc.w	$8022,$33FC,$000A,$00FF,$8020,$08F9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007
	dc.w	$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F,$3839
	dc.w	$0001,$8D56,$2479,$0004,$7D1C,$508A,$6100,$B82A
	dc.w	$4279,$0001,$7CEA,$4279,$0001,$7CEE,$6100,$05A4
	dc.w	$247C,$0001,$834C,$6100,$01DE,$D4FC,$0366,$6100
	dc.w	$01D6,$6100,$1F72,$700B,$207C,$0003,$D3F6,$227C
	dc.w	$0001,$7480,$3229,$0034,$0829,$0007,$0062,$6600
	dc.w	$0006,$0641,$0006,$E541,$3370,$1000,$0000,$3370
	dc.w	$1002,$0014,$4269,$0028,$4269,$002A,$D2FC,$0080
	dc.w	$51C8,$FFD2,$6100,$1EA8,$33FC,$0018,$0001,$8D62
	dc.w	$33F9,$0001,$7474,$0001,$7476,$3F3C,$00B4,$4EB9
	dc.w	$0002,$BB8E,$0839,$0000,$0001,$7F68,$6700,$000A
	dc.w	$0457,$0001,$6B00,$0086,$6100,$A296,$0801,$0005
	dc.w	$6600,$000A,$0801,$0007,$6700,$FFD4,$3039,$0001
	dc.w	$8358,$B079,$0001,$86BE,$6600,$0062,$0839,$0007
	dc.w	$00FF,$800E,$66F6,$33FC,$001B,$00FF,$8020,$08F9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6
	dc.w	$3039,$00FF,$8010,$08F9,$0007,$00FF,$800F,$08B9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6
	dc.w	$08B9,$0007,$00FF,$800F,$0240,$0001,$D179,$0001
	dc.w	$8358,$0A40,$0001,$D179,$0001,$86BE,$DEFC,$0002
	dc.w	$205F,$48E7,$4080,$4EB9,$0004,$8208,$4EB9,$0004
	dc.w	$7DAC,$4CDF,$0102,$3179,$0001,$8358,$000A,$3179
	dc.w	$0001,$86BE,$000C,$6100,$9A92,$700F,$207C,$0001
	dc.w	$7480,$4268,$0000,$D0FC,$0080,$51C8,$FFF6,$6100
	dc.w	$0148,$6100,$1FB8,$6100,$F172,$6100,$0A7A,$4EB9
	dc.w	$0002,$C1F8,$4EB9,$0002,$C310,$33FC,$0018,$0001
	dc.w	$8D62,$3F3C,$0079,$6100,$9F1A,$4CD7,$7FFF,$317C
	dc.w	$0004,$0008,$3028,$000A,$B068,$000C,$6700,$FC3A
	dc.w	$317C,$0005,$0008,$3601,$6100,$FA42,$6100,$FA60
	dc.w	$303C,$00B4,$6100,$A05A,$0801,$0007,$6600,$0016
	dc.w	$6100,$FB9A,$303C,$003C,$6100,$A046,$0801,$0007
	dc.w	$6700,$000A,$08F9,$0003,$0001,$7F6E,$4CDF,$7FFF
	dc.w	$4E75,$6100,$00C4,$6100,$0032,$6000,$FFE8,$6100
	dc.w	$002A,$6000,$FFE8,$4EB9,$0003,$C9E0,$6100,$00F8
	dc.w	$6100,$0336,$50EA,$0018,$08B9,$0007,$0001,$7F7C
	dc.w	$50EA,$001A,$50EA,$001C,$4E75,$3028,$000A,$B068
	dc.w	$000C,$6600,$005E,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$33FC,$001B,$00FF,$8020,$08F9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$67F6,$3039,$00FF,$8010
	dc.w	$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF
	dc.w	$800F,$0240,$0001,$D168,$000A,$0A40,$0001,$D168
	dc.w	$000C,$317C,$0005,$0008,$4E75,$303C,$0557,$227C
	dc.w	$0001,$7F68,$247C,$0000,$C45C,$34D9,$51C8,$FFFC
	dc.w	$34F9,$0001,$80F0,$4E75,$303C,$0557,$247C,$0001
	dc.w	$7F68,$227C,$0000,$C45C,$34D9,$51C8,$FFFC,$33D9
	dc.w	$0001,$80F0,$4E75,$0000,$FF10,$FFBA,$FF74,$0014
	dc.w	$FF92,$FF9C,$FFC4,$0019,$FFD8,$0046,$FFB0,$0000
	dc.w	$00F0,$0022,$005A,$FFC9,$0050,$0064,$0028,$FFF6
	dc.w	$000A,$FFCE,$0000,$48E7,$FCF8,$266A,$0022,$7805
	dc.w	$50EB,$0060,$50EB,$0061,$D6FC,$0080,$51CC,$FFF2
	dc.w	$6100,$0096,$7805,$287C,$0001,$8AC6,$4245,$1A34
	dc.w	$4000,$6700,$002E,$0445,$0001,$7605,$266A,$0022
	dc.w	$96FC,$0080,$D6FC,$0080,$BA2B,$0066,$57CB,$FFF6
	dc.w	$6600,$0010,$1774,$4006,$0060,$1745,$0061,$4234
	dc.w	$4000,$51CC,$FFC8,$7805,$287C,$0001,$8AC6,$4245
	dc.w	$1A34,$4000,$6700,$0038,$0445,$0001,$7605,$266A
	dc.w	$0022,$96FC,$0080,$D6FC,$0080,$4A2B,$0061,$5BCB
	dc.w	$FFF6,$6A00,$0004,$204B,$4A6B,$0034,$5ACB,$FFE8
	dc.w	$1174,$4006,$0060,$1145,$0061,$4234,$4000,$51CC
	dc.w	$FFBE,$4CDF,$1F3F,$4E75
SetPlList
	movea.l	#$18AC6,a4
	clr.l	(a4)
	clr.w	$4(a4)
	movea.l	#priolist,a0
	tst.w	$28(a2)
	bpl.w	.l224F6
	adda.w	#$1,a0
.l224F6	lea.l	$16C(a2),a1
	move.w	$16(a2),d0
	asl.w	#$3,d0
	adda.w	d0,a1
	move.w	$26(a2),d4
	bra.w	.l22528
.l2250A	clr.w	d5
	move.b	(a0,d4.w),d5
	move.b	(a1,d5.w),(a4,d4.w)
	move.b	d5,$6(a4,d4.w)
	bne.w	.l22528
	moveq	#$1,d3
	add.w	$28(a2),d3
	move.b	d3,(a4,d4.w)
.l22528	dbra	d4,.l2250A
	moveq	#$5,d4
.l2252E	move.b	(a4,d4.w),d3
	beq.w	.l22584
	ext.w	d3
	subi.w	#$1,d3
	add.w	d3,d3
	cmpi.w	#$FFFD,$68(a2,d3.w)
	beq.w	.l2255A
	cmpi.w	#$FFFC,$68(a2,d3.w)
	beq.w	.l2255A
	tst.w	$68(a2,d3.w)
	ble.w	.l22584
.l2255A	lea.l	$16C(a2),a1
	move.b	$6(a4,d4.w),d0
	ext.w	d0
	asl.w	#$1,d0
	movea.l	#sublist,a0
	adda.w	(a0,d0.w),a0
.l22570	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	.l2258A
	move.b	(a1,d0.w),d0
	bsr.w	TryAddPlayerToList
	beq.w	.l22570
.l22584	dbra	d4,.l2252E
	rts
.l2258A	jsr	(GetPlayerCount).l
	move.w	d0,d3
.l22592	move.w	d3,d0
	subi.w	#$1,d3
	bmi.w	.l22584
	bsr.w	TryAddPlayerToList
	beq.w	.l22592
	bra.w	.l22584
TryAddPlayerToList
	move.w	d0,d1
	subi.w	#$1,d0
	add.w	d0,d0
	tst.w	$68(a2,d0.w)
	bgt.w	.l225E0
	cmpi.w	#$FFFD,$68(a2,d0.w)
	beq.w	.l225E0
	cmpi.w	#$FFFC,$68(a2,d0.w)
	beq.w	.l225E0
	moveq	#$5,d0
.l225CE	cmp.b	(a4,d0.w),d1
	dbeq	d0,.l225CE
	beq.w	.l225E0
	move.b	d1,(a4,d4.w)
	rts
.l225E0	clr.w	d1
	rts
SetupPenaltyShot
	movem.l	d0-d5/a0-a3,-(sp)
	movea.l	$22(a2),a3
	moveq	#$5,d4
.l225EE	move.w	$52(a3),d0
	cmp.w	(BA_Sktr_SCnum).l,d0
	beq.w	.l22618
	cmp.w	(BA_Goalie_SCnum).l,d0
	beq.w	.l22636
	bset	#$2,$63(a3)
	move.w	#$20,d0
	bsr.w	X_1B2E4
	bra.w	.l22652
.l22618	bsr.w	X_22754
	move.b	$61(a3),$17F9C.l
	move.b	$1936D.l,$61(a3)
	move.w	#$4,$34(a3)
	bra.w	.l2263E
.l22636	bsr.w	X_22754
	clr.w	$34(a3)
.l2263E	clr.w	d3
	move.b	$61(a3),d3
	add.w	d3,d3
	move.w	#$FFFF,$68(a2,d3.w)
	lsr.w	#$1,d3
	bsr.w	X_22770
.l22652	st.b	$61(a3)
	st.b	$60(a3)
	adda.w	#$80,a3
	dbra	d4,.l225EE
	movem.l	(sp)+,d0-d5/a0-a3
	rts
	dc.w	$48E7,$F8F0,$266A,$0022,$7805,$102B,$0060,$4880
	dc.w	$4A6B,$0034,$6600,$001C,$4A40,$6700,$0016,$3F2B
	dc.w	$0052,$377C,$000F,$0052,$4EB9,$0002,$2DDE,$375F
	dc.w	$0052,$3740,$0034,$6B00,$002A,$6100,$00B0,$0C6B
	dc.w	$0004,$0034,$6600,$0008,$7011,$6100,$8C24,$4243
	dc.w	$162B,$0061,$D643,$35BC,$FFFF,$3068,$E24B,$6100
	dc.w	$00A8,$50EB,$0061,$50EB,$0060,$D7FC,$0000,$0080
	dc.w	$51CC,$FF98,$4CDF,$0F1F,$4E75
