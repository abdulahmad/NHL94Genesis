ReadLineData
	moveq	#$0,d3
	addq.b	#$5,d0
	move.w	(a2,d3.w),-(a0)
	dc.w	$5A31,$3433
	dc.w	$3334,$5A00
	dc.w	$3537,$3537,$3636,$383A,$3938,$5A65
	dc.w	$4A4B
	dc.w	$4B00
	addq.b	#$5,d0
	move.w	#$3D00,-(a5)
	dc.w	$5A3C,$3E3F,$3F00,$5A00,$7775,$7600,$5A00,$4042
	dc.w	$4142,$5A40,$4343,$4544,$5A46,$4F4E,$4F4D,$5A4C
	dc.w	$5051,$5000,$5A52,$4748,$4749,$5A49,$5455,$5300
	dc.w	$5A00,$7775,$7600,$5A00,$5657,$5658,$0058,$595B
	dc.w	$595C,$5A5C,$5D5E,$5D00,$5A5E,$5F60,$6163,$6465
	dc.w	$6768,$6867,$5A69,$6A6B,$6B00,$5A00,$6C6C,$6D00
	dc.w	$5A00,$6E6F,$7000,$5A00,$7173,$7100,$5A74,$7775
	dc.w	$7600,$5A00,$5455,$5300,$5A00,$5455,$5300,$5A00
	dc.w	$3440,$4249,$585C,$6566
	movem.l	d0-d1/a0,-(sp)
	move.l	#$100,d1
	move.l	#$E20,d0
	movea.l	#$18C26,a0
	jsr	$22452.l
	bclr	#$4,$17F6A.l
	move.w	#$FFFF,(lastsfx).l
	dc.w	$23FC,$0000,$C45C,$0001,$7470
	movem.l	(sp)+,d0-d1/a0
	rts
	movem.l	d0-d1/a0,-(sp)
	move.l	#$100,d1
	move.l	#$E20,d0
	movea.l	#$18C26,a0
	jsr	$2246C.l
	bclr	#$4,$17F6A.l
	move.w	#$FFFF,(lastsfx).l
	dc.w	$23FC,$0000,$C45C,$0001,$7470
	movem.l	(sp)+,d0-d1/a0
	rts
Sub_2A604
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#ThreeStars,a0
	move.w	#$7,d7
LF612	clr.b	$8(a0)
	clr.b	$9(a0)
	clr.b	$A(a0)
	clr.b	$B(a0)
	adda.w	#$10,a0
	dbra	d7,LF612
	dc.w	$203C,$0000,$0D20
	dc.w	$223C,$0000,$0080
	movea.l	#ThreeStars,a0
	jsr	$2246C.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PSandSOpassdir
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$3039,$0001,$A8BC
	btst	#$7,$62(a3)
	bne.w	LF668
	movea.l	#$2A674,a0
	add.w	d0,d0
	move.w	(a0,d0.w),d0
LF668	dc.w	$33C0,$0001,$7E2C
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$0000,$0007,$0006,$0005,$0004,$0003,$0002,$0001
	dc.w	$0008
StartShootoutPath
	movem.l	d0-d7/a0-a6,-(sp)
LF68A	move.w	#$7,d0
	dc.w	$4EB9,$0003,$7050
	cmpi.w	#$6,d0
	bgt.w	LF68A
	dc.w	$33C0,$0001,$A8B4
	bclr	#$3,$17F7A.l
	move.w	#$FFFF,$1A8B6.l
	dc.w	$4279,$0001,$A8B8
	bsr.w	Sub_2A736
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$0002,$A6DE,$0002,$A6EA,$0002,$A6FA,$0002,$A706
	dc.w	$0002,$A712,$0002,$A71E,$0002,$A72A,$0010,$00E2
	dc.w	$0010,$00D0,$8020,$0005,$FFC9,$00A0,$FFFF,$00C8
	dc.w	$FFE0,$00D0,$8020,$0005,$FFB0,$0040,$001A,$00BC
	dc.w	$8020,$0005,$FFCE,$0058,$0014,$00D0,$802C,$0005
	dc.w	$FFCE,$0008,$0020,$00D0,$8028,$0006,$001C,$00F4
	dc.w	$0008,$00E0,$8020,$0006,$FFE6,$00F8,$0000,$00E0
	dc.w	$8020,$0002
Sub_2A736
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$0C39,$0080,$0001,$A8B8
	beq.w	LF7B0
	addi.w	#$1,$1A8B6.l
	move.w	$1A8B6.l,d0
	asl.w	#$2,d0
	movea.l	#$2A6C2,a0
	dc.w	$3239,$0001,$A8B4
	asl.w	#$2,d1
	movea.l	(a0,d1.w),a0
	dc.w	$33F0,$0000,$0001,$A8B8
	btst	#$0,$76(a3)
	beq.w	LF780
	dc.w	$4479,$0001,$A8B8
LF780	move.w	$2(a0,d0.w),$1A8BA.l
	cmpi.b	#$80,$4(a0,d0.w)
	bne.w	LF7B0
	bset	#$3,$17F7A.l
	clr.w	$1A8BE.l
	move.b	$5(a0,d0.w),$1A8BF.l
	dc.w	$33F0,$0006,$0001,$A8BC
LF7B0	movem.l	(sp)+,d0-d7/a0-a6
	rts
	movem.l	d2-d7/a0-a6,-(sp)
	dc.w	$0C39,$0080,$0001,$A8B8
	beq.w	LF844
	dc.w	$3039,$0001,$A8B8
	move.w	$1A8BA.l,d1
	btst	#$7,$62(a3)
	bne.w	LF7E0
	neg.w	d0
	neg.w	d1
LF7E0	sub.w	$0(a3),d0
	bpl.w	LF7EA
	neg.w	d0
LF7EA	tst.w	$28(a3)
	bne.w	LF802
	tst.w	$2A(a3)
	bne.w	LF802
	cmpi.w	#$12,d0
	ble.w	LF80A
LF802	cmpi.w	#$A,d0
	bgt.w	LF838
LF80A	sub.w	$14(a3),d1
	bpl.w	LF814
	neg.w	d1
LF814	tst.w	$28(a3)
	bne.w	LF82C
	tst.w	$2A(a3)
	bne.w	LF82C
	cmpi.w	#$12,d1
	ble.w	LF834
LF82C	cmpi.w	#$A,d1
	bgt.w	LF838
LF834	bsr.w	Sub_2A736
LF838	dc.w	$3039,$0001,$A8B8
	move.w	$1A8BA.l,d1
LF844	movem.l	(sp)+,d2-d7/a0-a6
	rts
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#$1,$17F78.l
	beq.w	LF8F8
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	bne.w	LF8F8
	dc.w	$0C79,$0003,$0001,$93B6
	ble.w	LF8F2
	dc.w	$0C39,$0080,$0001,$A8B8
	beq.w	LF8F2
	btst	#$3,$17F7A.l
	bne.w	LF8B0
	dc.w	$4A79,$0001,$7BA8
	bne.w	LF8F8
	dc.w	$4A79,$0001,$7BAA
	bne.w	LF8F8
	dc.w	$0C79,$000F,$0001,$93B6
	blt.w	LF8F2
	bra.w	LF8F8
LF8B0	dc.w	$3039,$0001,$A8B8
	move.w	$1A8BA.l,d1
	btst	#$7,$62(a3)
	bne.w	LF8CA
	neg.w	d0
	neg.w	d1
LF8CA	sub.w	$0(a3),d0
	bpl.w	LF8D4
	neg.w	d0
LF8D4	sub.w	$14(a3),d1
	bpl.w	LF8DE
	neg.w	d1
LF8DE	cmp.w	$1A8BE.l,d0
	bgt.w	LF8F8
	cmp.w	$1A8BE.l,d1
	bgt.w	LF8F8
LF8F2	clr.w	d0
	bra.w	LF8FC
LF8F8	move.w	#$1,d0
LF8FC	movem.l	(sp)+,d0-d7/a0-a6
	rts
UnpackPicture
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#picturebuf,a0
	dc.w	$227C,$0001,$AD42
	move.w	(a2)+,d0
	move.w	d0,(a0)+
	asl.w	#$3,d0
	subi.w	#$1,d0
LF91C	clr.l	(a0)
	clr.l	(a1)
	move.b	(a2)+,(a1)
	move.b	(a2)+,$1(a1)
	move.b	(a2)+,$2(a1)
	dc.w	$2F3C,$0000,$0000
	move.l	(a1),d2
	andi.l	#$E0000000,d2
	lsr.l	#$1,d2
	addi.l	#$50000000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$1C000000,d2
	lsr.l	#$2,d2
	addi.l	#$5000000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$3800000,d2
	lsr.l	#$3,d2
	addi.l	#$500000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$700000,d2
	lsr.l	#$4,d2
	addi.l	#$50000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$E0000,d2
	lsr.l	#$5,d2
	addi.l	#$5000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$1C000,d2
	lsr.l	#$6,d2
	addi.l	#$500,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$3800,d2
	lsr.l	#$7,d2
	addi.l	#$50,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$700,d2
	move.w	#$8,d5
	lsr.l	d5,d2
	addi.l	#$5,d2
	or.l	d2,(sp)
	move.l	(sp)+,(a0)+
	dbra	d0,LF91C
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	move.w	d0,-(sp)
	subi.w	#$18,d4
	tst.w	$17468.l
	dc.w	$6708
	movea.l	$47DA8.l,a2
	dc.w	$6006
LF9E6	movea.l	$47D90.l,a2
LF9EC	adda.w	#$8,a2
	dc.w	$4EB9,$0003,$8958
	move.w	(sp)+,d0
	rts
TeamGfxListEnd
	ori.b	#$23,d0
	ori.b	#$3C,d0
	ori.b	#$24,d0
	ori.b	#$25,d0
	ori.b	#$26,d0
	ori.b	#$27,d0
	ori.b	#$28,d0
	ori.b	#$29,d0
	ori.b	#$2A,d0
	ori.b	#$2B,d0
	ori.b	#$2C,d0
	ori.b	#$2D,d0
	ori.b	#$2E,d0
	ori.b	#$2F,d0
	ori.b	#$30,d0
	ori.b	#$31,d0
	ori.b	#$32,d0
	ori.b	#$33,d0
	ori.b	#$34,d0
	ori.b	#$35,d0
	ori.b	#$36,d0
	ori.b	#$37,d0
	ori.b	#$38,d0
	ori.b	#$39,d0
	ori.b	#$3A,d0
	ori.b	#$3B,d0
	ori.b	#$3D,d0
	ori.b	#$3E,d0
	movem.l	d0/a2,-(sp)
	dc.w	$4EB9,$0003,$8F6E
	String	' ('
	adda.w	#$D0,a2
	bra.w	PrintParenNumber
	movem.l	d0/a2,-(sp)
	dc.w	$4EB9,$0003,$8F6E
	String	' ('
	adda.w	#$B6,a2
PrintParenNumber
	move.b	(a2,d0.w),d0
	ext.w	d0
	move.w	#$1,d1
	cmpi.w	#$9,d0
	ble.w	LFAB4
	move.w	#$2,d1
	cmpi.w	#$63,d0
	ble.w	LFAB4
	move.w	#$3,d1
LFAB4	jsr	(PushNumberWidth).l
	dc.w	$4EB9,$0003,$8F80
	dc.w	$4EB9,$0003,$8F6E
	String	')'
	addi.w	#$1,(printy).l
	move.w	#$E,(printx).l
	movem.l	(sp)+,d0/a2
	rts
PlaceBoardFall
	cmpi.w	#$193E,$58(a3)
	beq.w	LFBE4
	cmpi.w	#$1A00,$58(a3)
	beq.w	LFBA4
	cmpi.w	#$18CC,$58(a3)
	beq.w	LFBC4
	cmpi.w	#$17E8,$58(a3)
	beq.w	LFB84
	cmpi.w	#$1776,$58(a3)
	beq.w	LFB20
	cmpi.w	#$185A,$58(a3)
	beq.w	LFB52
	bra.w	LFC00
LFB20	move.w	#$124,d0
	cmpi.w	#$56,$1937E.l
	bgt.w	LFB3C
	cmpi.w	#$FFAA,$1937E.l
	bgt.w	LFB40
LFB3C	move.w	#$116,d0
LFB40	sub.w	$14(a3),d0
	bmi.w	LFC00
	asr.w	#$1,d0
	add.w	d0,$14(a3)
	bra.w	LFC00
LFB52	move.w	#$FEDC,d0
	cmpi.w	#$56,$1937E.l
	bgt.w	LFB6E
	cmpi.w	#$FFAA,$1937E.l
	bgt.w	LFB72
LFB6E	move.w	#$FEEA,d0
LFB72	sub.w	$14(a3),d0
	bpl.w	LFC00
	asr.w	#$1,d0
	add.w	d0,$14(a3)
	bra.w	LFC00
LFB84	move.w	#$82,d0
	btst	#$3,$4(a3)
	beq.w	LFB96
	move.w	#$FF7E,d0
LFB96	sub.w	$0(a3),d0
	asr.w	#$1,d0
	add.w	d0,$0(a3)
	bra.w	LFC00
LFBA4	move.w	#$88,d0
	btst	#$3,$4(a3)
	beq.w	LFBB6
	move.w	#$FF78,d0
LFBB6	sub.w	$0(a3),d0
	asr.w	#$1,d0
	add.w	d0,$0(a3)
	bra.w	LFC00
LFBC4	move.w	#$FF7E,d0
	btst	#$3,$4(a3)
	beq.w	LFBD6
	move.w	#$82,d0
LFBD6	sub.w	$0(a3),d0
	asr.w	#$1,d0
	add.w	d0,$0(a3)
	bra.w	LFC00
LFBE4	move.w	#$FF78,d0
	btst	#$3,$4(a3)
	beq.w	LFBF6
	move.w	#$88,d0
LFBF6	sub.w	$0(a3),d0
	asr.w	#$1,d0
	add.w	d0,$0(a3)
LFC00	rts
GetLeagueCrowdRecord
	movem.l	d1-d7/a0-a6,-(sp)
	move.w	#$1B,d1
	ext.l	d1
	clr.w	d7
	movea.l	#ThreeStars,a0
LFC14	jsr	(ReadCrowdRecord).l
	clr.w	d2
	move.b	$8(a0),d2
	bne.w	LFC28
	move.w	#$50,d2
LFC28	cmp.w	d7,d2
	ble.w	LFC32
	move.w	d2,d7
	move.w	d1,d0
LFC32	dbra	d1,LFC14
	movem.l	(sp)+,d1-d7/a0-a6
	rts
getFgtbyte
	clr.w	d0
	move.b	$74(a2),d0
	lsr.w	#$2,d0
	rts
	btst	#$1,$74(a2)
	rts
RandomFaceoffAnim
	movem.l	a0,-(sp)
	movea.l	#$2AC8E,a0
	move.w	#$64,d0
	dc.w	$4EB9,$0003,$7050
	andi.w	#$7,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d0
	cmpi.w	#$FFC0,$17EE2.l
	bgt.w	LFC88
	cmpi.w	#$C0,$17EE4.l
	bgt.w	LFC88
	move.w	#$6,d0
LFC88	movem.l	(sp)+,a0
	rts
	dc.w	$0003,$0005,$0003,$0001,$0005,$0002,$0003,$0003
	dc.w	$FFFF
CheckScoreLeader
	movem.l	d0-d2/a0-a2,-(sp)
	movea.l	#tmstruct,a0
	movea.l	#awtmstruct,a1
	move.w	$26(a0),d0
	sub.w	$26(a1),d0
	beq.w	LFCCC
	bpl.w	LFCC2
	exg.l	a0,a1
LFCC2	cmpi.w	#$13,$2A(a0)
	bne.w	LFCCC
LFCCC	movem.l	(sp)+,d0-d2/a0-a2
	rts
DrawPlayoffSprite
	dc.w	$2C7C,$000B,$BD30
	moveq	#$1,d6
	movea.l	$47D94.l,a0
	dc.w	$3639,$0001,$8D46
	ori.w	#$8000,d3
	dc.w	$3039,$0001,$7CE4
	dc.w	$3239,$0001,$7CE6
	move.w	#$1,d2
	dc.w	$4EB9,$0003,$E028
	cmpa.l	#$BBD30,a6
	bne.w	LFD0E
	clr.l	(a6)+
	clr.l	(a6)+
LFD0E	clr.b	-$5(a6)
	move.l	a6,d0
	subi.l	#$BBD30,d0
	lsr.w	#$1,d0
	dc.w	$33C0,$0001,$7F66
	rts
GetTeamStruct
	movea.l	#tmstruct,a2
	cmp.w	$2A(a2),d2
	beq.w	LFD38
	movea.l	#awtmstruct,a2
LFD38	rts
	movem.l	d1/a0,-(sp)
	btst	#$0,$17F68.l
	bne.w	LFD80
	dc.w	$3239,$0001,$7E62
	movea.l	#$1AD46,a0
	tst.w	d4
	beq.w	LFD62
	movea.l	#$1AD4E,a0
LFD62	addi.l	#$1,(a0)
	cmpi.w	#$8,d1
	beq.w	LFD80
	cmp.w	$54(a3),d1
	beq.w	LFD80
	addi.l	#$1,$4(a0)
LFD80	movem.l	(sp)+,d1/a0
	rts
TerminateLogName
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$227C,$0001,$AD5C
	bsr.w	GetLogName
	dc.w	$3039,$0001,$A38A
	move.b	#$0,(a1,d0.w)
	addi.w	#$1,d0
	andi.w	#$FFFE,d0
	move.w	d0,-$2(a1)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PlayedByHome
	movem.l	d0-d7/a0/a2-a6,-(sp)
	dc.w	$3039,$0001,$8BF4
PlayedByText
	tst.w	d0
	beq.w	Sub_2AE50
	movea.l	#$1A37E,a1
	dc.w	$33C0,$0001,$A38C
	bsr.w	GetLogName
	dc.w	$D2F9,$0001,$A38A
	move.b	#$0,(a1)
	dc.w	$0679,$0001,$0001,$A38A
	dc.w	$0279,$FFFE,$0001,$A38A
	dc.w	$0679,$0002,$0001,$A38A
	dc.w	$33F9,$0001,$A38A,$0001,$A37C
	movea.l	#$1A37C,a1
	move.l	a1,-(sp)
	movea.l	#TempBuffer,a3
	movea.l	#$2AE40,a1
	bsr.w	CopyString
	movea.l	(sp)+,a1
	movea.l	#TempBuffer,a3
	dc.w	$4EB9,$0003,$9208
	movea.l	#TempBuffer,a3
	dc.w	$4EB9,$0003,$9200
	String	')'
	movea.l	#TempBuffer,a1
Sub_2AE3A
	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
	dc.w	$000E,$2870,$6C61,$7965,$6420,$6279,$2000,$0002
Sub_2AE50
	movea.l	#$2AE4E,a1
	bra.w	Sub_2AE3A
PlayedByAway
	movem.l	d0-d7/a0/a2-a6,-(sp)
	dc.w	$3039,$0001,$8BF6
	bra.w	PlayedByText
	bra.w	Sub_2AE78
	dc.w	$08B9,$0001,$0001,$7F7C,$6000,$000A
Sub_2AE78
	bset	#$1,$17F7C.l
	rts
AttribAdjust
	cmpi.w	#$32,d0
	bge.w	LFE90
	asr.w	#$1,d0
	addi.w	#$19,d0
LFE90	rts
	dc.w	$48A7,$C000,$3039,$0001,$7B80,$906B,$0000,$0C40
	dc.w	$001E,$6E00,$0030,$3239,$0001,$7BA8,$B340,$0240
	dc.w	$8000,$6700,$0020,$3039,$0001,$7B94,$906B,$0014
	dc.w	$0C40,$001E,$6E00,$000E,$3239,$0001,$7BAA,$B340
	dc.w	$0240,$8000,$4C9F,$0003,$4E75
ReadGoaliePulled
	movem.l	a1,-(sp)
	movea.l	#tmstruct,a1
	btst	#$6,$62(a3)
	beq.w	LFEF6
	movea.l	#awtmstruct,a1
LFEF6	tst.w	$28(a1)
	movem.l	(sp)+,a1
	rts
EndOneTimer
	movem.l	d0/a0,-(sp)
	bclr	#$3,$64(a3)
	bclr	#$5,$62(a3)
	bclr	#$1,$63(a3)
	dc.w	$4279,$0001,$7EC6
	dc.w	$50F9,$0001,$7EBC
	move.w	d1,-(sp)
	move.w	#$50C,d1
	dc.w	$4EB9,$0003,$63C0
	tst.w	$34(a3)
	bpl.w	LFF40
	dc.w	$4EB9,$0003,$62C4
	bra.w	LFF46
LFF40	jsr	(Setplass).l
LFF46	clr.w	$5A(a3)
	st.b	$5C(a3)
	move.w	(sp)+,d1
	movem.l	(sp)+,d0/a0
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_0FF56.bin
ClearPenalties
	movem.l	d0/a0,-(sp)
	dc.w	$4279,$0001,$8068
	dc.w	$4279,$0001,$8066
	dc.w	$4279,$0001,$8064
	move.w	#$10,d0
	dc.w	$207C,$0001,$8022
L103C8	clr.l	(a0)+
	dbra	d0,L103C8
	movea.l	#tmstruct,a0
	bsr.w	clrTmPdst
	movea.l	#awtmstruct,a0
	bsr.w	clrTmPdst
	movem.l	(sp)+,d0/a0
	rts
clrTmPdst
	move.w	#$19,d0
	adda.w	#$68,a0
L103F0	move.w	#$FFFE,(a0)+
	dbra	d0,L103F0
	move.w	#$FFFF,(a0)
	rts
