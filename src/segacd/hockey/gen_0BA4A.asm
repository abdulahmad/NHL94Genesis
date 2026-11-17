NameEntryHelp
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1Pri,$2,$15,'D-Pad up/down to    '
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1Pri,$2,$16,'move arrows.        '
	move.w	#$2,(printx).l
	move.w	(printx).l,-(sp)
	addi.w	#$1,(printy).l
	dc.w	$4EB9,$0003,$8F6E
	String	'Press START to      '
	addi.w	#$1,(printy).l
	move.w	(sp),(printx).l
	dc.w	$4EB9,$0003,$8F6E
	String	'select name.        '
	addi.w	#$1,(printy).l
	move.w	(sp)+,(printx).l
	dc.w	$4EB9,$0003,$8F6E
	String	'Press B to edit.    '
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PrintNamePrompt
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$3039,$0001,$A38C
	mulu.w	#$C,d0
	dc.w	$207C,$0001,$A2FC
	dc.w	$227C,$0002,$6C30
	tst.b	(a0,d0.w)
	beq.w	LBB42
	movea.l	#$26C48,a1
LBB42	jsr	(print).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SyncLetterCursor
	movem.l	d0-d4/a0-a6,-(sp)
	move.b	$1A37C.l,d0
	bsr.w	FindLetter
	cmpi.w	#$1E,d0
	blt.w	LBB6A
	clr.w	d5
	bra.w	LBB7A
LBB6A	move.w	d0,d5
	movea.l	#$26DD0,a0
	move.b	(a0,d5.w),$1A37C.l
LBB7A	movem.l	(sp)+,d0-d4/a0-a6
	rts
FindLetter
	movem.l	d1-d3/a0-a6,-(sp)
	movea.l	#$26DD0,a0
	move.b	d0,d1
	clr.w	d0
	move.w	#$1E,d3
LBB92	cmp.b	(a0,d0.w),d1
	beq.w	LBBA6
	addi.w	#$1,d0
	dbra	d3,LBB92
	move.w	#$1E,d0
LBBA6	movem.l	(sp)+,d1-d3/a0-a6
	rts
PrintNameCursor
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1Pri,$4,$13
	add.w	d4,(printx).l
	dc.w	$4A79,$0001,$A566
	beq.w	LBBD4
	dc.w	$4EB9,$0003,$8F6E
	String	' < '
LBBD4	rts
PrintCurLetter
	dc.w	$4A79,$0001,$A566
	beq.w	LBBD4
	movea.l	#ThreeStars,a1
	move.w	#$4,(a1)
	move.b	#$0,$3(a1)
	movea.l	#$26DD0,a0
	move.b	(a0,d5.w),d0
	move.b	d0,$2(a1)
	dc.w	$4EF9,$0003,$8F80
LetterGridPos
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1Pri,$18,$10
	move.w	d5,d0
	ext.l	d0
	divu.w	#$6,d0
	asl.w	#$1,d0
	add.w	d0,(printy).l
	swap	d0
	asl.w	#$1,d0
	add.w	d0,(printx).l
	moveq	#$3,d0
	moveq	#$3,d1
	rts
PrintNameLog
	dc.w	$0018,$BF02
	move.b	-(a0),d0
	movea.l	d5,a0
	dc.w	$6E74
	dc.w	$6572
	movea.l	$6577(a6),a0
	movea.l	$616D(a6),a0
	dc.w	$653A
	move.l	d0,d0
	dc.w	$0018,$BF02
	dc.w	$1053,$656C,$6563,$7420,$6F72,$2072,$6570,$6C61
	dc.w	$6365,$3A00,$48E7,$FFFE,$3F39,$0001,$A38A,$3F39
	dc.w	$0001,$A38C,$4EB9,$0003,$8F6E,$0006,$BF05,$0800
	dc.w	$3E3C,$0006
Sub_26C80
	dc.w	$33FC,$0001,$0001,$A38C
	movea.l	#TempBuffer,a1
LBC8E	bsr.w	GetLogName
	move.w	(printx).l,-(sp)
	bsr.w	PrintNameField
	move.w	(sp)+,(printx).l
	addi.w	#$1,(printy).l
	dc.w	$0679,$0001,$0001,$A38C
	dbra	d7,LBC8E
	dc.w	$33DF,$0001,$A38C
	dc.w	$33DF,$0001,$A38A
	movem.l	(sp)+,d0-d7/a0-a6
	rts
MoveLogArrows
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$3039,$0001,$A38C
	dc.w	$B079,$0001,$A38E
	beq.w	LBCF0
	movea.l	#$26D4A,a1
	bsr.w	LBCF6
	movea.l	#$26D42,a1
	bsr.w	LBCF6
LBCF0	movem.l	(sp)+,d0-d7/a0-a6
	rts
LBCF6	dc.w	$4A79,$0001,$A38E
	beq.w	LBD36
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1Pri,$3,$8
	dc.w	$3039,$0001,$A38E
	subi.w	#$1,d0
	add.w	d0,(printy).l
	move.l	a1,-(sp)
	dc.w	$4EB9,$0003,$8F80
	movea.l	(sp)+,a1
	adda.w	(a1),a1
	move.w	#$12,(printx).l
	dc.w	$4EB9,$0003,$8F80
LBD36	dc.w	$33F9,$0001,$A38C,$0001,$A38E
	rts
	dc.w	$0004,$5D00,$0004,$5B00,$0004,$2000,$0004,$2000
GetNameLength
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$B,d3
	movea.l	#$1A37C,a0
	dc.w	$4279,$0001,$A38A
LBD66	cmpi.b	#$2D,(a0)
	beq.w	LBD80
	tst.b	(a0)+
	beq.w	LBD80
	dc.w	$0679,$0001,$0001,$A38A
	dbra	d3,LBD66
LBD80	movem.l	(sp)+,d0-d7/a0-a6
	rts
PrintNameField
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#ThreeStars,a0
	dc.w	$3039,$0001,$A38A
	move.w	#$0,d3
	move.w	#$E,(a0)+
LBD9E	move.b	(a1,d3.w),d1
	dc.w	$B679,$0001,$A38A
	blt.w	LBDB0
	move.b	#$2D,d1
LBDB0	move.b	d1,(a0)+
	addi.w	#$1,d3
	cmpi.w	#$C,d3
	blt.w	LBD9E
	movea.l	#ThreeStars,a1
	dc.w	$4EB9,$0003,$8F80
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$4142,$4344,$4546,$4748,$494A,$4B4C,$4D4E,$4F50
NameEntryFramer
	subq.w	#$8,(a2)
	subq.w	#$1,(a4)
	subq.w	#$2,(a6)
	subq.w	#$3,(a0)+
	subq.w	#$4,(a2)+
	dc.w	$2E31,$3220
	move.l	d0,-(a6)
	move.w	(framercset).l,-(sp)
	move.w	$1A3D2.l,(framercset).l
	dc.w	$4EB9,$0003,$8CA0
	move.w	(sp)+,(framercset).l
	rts
GetLogName
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$207C,$0001,$A2FC
	dc.w	$3439,$0001,$A38C
	mulu.w	#$C,d2
	dc.w	$33FC,$0000,$0001,$A38A
	move.w	#$B,d3
LBE2E	move.b	(a0,d2.w),d0
	beq.w	LBE3A
	bra.w	LBE46
LBE3A	move.b	#$2D,d0
	dc.w	$0479,$0001,$0001,$A38A
LBE46	move.b	d0,(a1)+
	dc.w	$0679,$0001,$0001,$A38A
	addi.w	#$1,d2
	dbra	d3,LBE2E
	movem.l	(sp)+,d0-d7/a0-a6
	rts
StoreUserName
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$207C,$0001,$A2FC
	dc.w	$3039,$0001,$A38C
	mulu.w	#$C,d0
	adda.w	d0,a0
	movea.l	#$1A37C,a1
	move.w	#$B,d4
LBE7E	cmpi.b	#$2D,(a1)
	bne.w	LBE8A
	move.b	#$0,(a1)
LBE8A	move.b	(a1)+,d1
	cmp.b	(a0)+,d1
	bne.w	LBE9A
	dbra	d4,LBE7E
	bra.w	LBED4
LBE9A	dc.w	$207C,$0001,$A2FC
	dc.w	$3039,$0001,$A38C
	mulu.w	#$C,d0
	adda.w	d0,a0
	movea.l	#$1A37C,a1
	move.w	#$B,d4
LBEB6	move.b	(a1)+,d1
	cmpi.b	#$2D,d1
	bne.w	LBEC4
	move.b	#$0,d1
LBEC4	move.b	d1,(a0)+
	dbra	d4,LBEB6
	bsr.w	Sub_22622
	jsr	$26F06.l
LBED4	dc.w	$2A7C,$0001,$8BF4
	dc.w	$4A79,$0001,$A390
	beq.w	LBEEA
	dc.w	$2A7C,$0001,$8BF6
LBEEA	tst.b	$1A37C.l
	bne.w	LBEFA
	dc.w	$4279,$0001,$A38C
LBEFA	dc.w	$3AB9,$0001,$A38C
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$2D7,d7
	dc.w	$203C,$0000,$0000
	dc.w	$223C,$0000,$0004
	movea.l	#ThreeStars,a0
	dc.w	$3C39,$0001,$A38C
LBF26	clr.w	d5
	jsr	$22452.l
	cmp.b	$1(a0),d6
	bne.w	LBF3C
	clr.b	$1(a0)
	st.b	d5
LBF3C	cmp.b	$3(a0),d6
	bne.w	LBF4A
	clr.b	$3(a0)
	st.b	d5
LBF4A	tst.w	d5
	beq.w	LBF56
	jsr	$2246C.l
LBF56	addi.l	#$4,d0
	dbra	d7,LBF26
	move.w	#$1B,d7
	move.l	#$B60,d0
	dc.w	$223C,$0000,$0010
	movea.l	#ThreeStars,a0
	dc.w	$3C39,$0001,$A38C
LBF7C	clr.w	d5
	jsr	$22452.l
	cmp.b	$1(a0),d6
	bne.w	LBF92
	clr.b	$1(a0)
	st.b	d5
LBF92	cmp.b	$3(a0),d6
	bne.w	LBFA0
	clr.b	$3(a0)
	st.b	d5
LBFA0	cmp.b	$5(a0),d6
	bne.w	LBFAE
	clr.b	$5(a0)
	st.b	d5
LBFAE	cmp.b	$7(a0),d6
	bne.w	LBFBC
	clr.b	$7(a0)
	st.b	d5
LBFBC	cmp.b	$9(a0),d6
	bne.w	LBFCA
	clr.b	$9(a0)
	st.b	d5
LBFCA	cmp.b	$B(a0),d6
	bne.w	LBFD8
	clr.b	$B(a0)
	st.b	d5
LBFD8	tst.w	d5
	beq.w	LBFE4
	jsr	$2246C.l
LBFE4	addi.l	#$10,d0
	dbra	d7,LBF7C
	dc.w	$203C,$0000,$0D20
	dc.w	$3639,$0001,$A38C
	asl.w	#$4,d3
	ext.l	d3
	add.l	d3,d0
	dc.w	$223C,$0000,$0010
	movea.l	#ThreeStars,a0
	jsr	$22452.l
	move.l	a0,-(sp)
	move.w	#$F,d3
LC018	clr.b	(a0)+
	dbra	d3,LC018
	movea.l	(sp)+,a0
	jsr	$2246C.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
UserNameEntry
	dc.w	$4A79,$0001,$8C06
	bne.w	LC09E
	dc.w	$4279,$0001,$8BF4
	dc.w	$4279,$0001,$8BF6
	dc.w	$4A79,$0001,$7FA6
	beq.w	LC064
	dc.w	$33F9,$0001,$7FA6,$0001,$A390
	dc.w	$0479,$0001,$0001,$A390
	jsr	$26348.l
LC064	dc.w	$4A79,$0001,$7FA8
	beq.w	LC09E
	movem.w	d0,-(sp)
	dc.w	$3039,$0001,$7FA6
	dc.w	$B079,$0001,$7FA8
	movem.w	(sp)+,d0
	beq.w	LC09E
	dc.w	$33F9,$0001,$7FA8,$0001,$A390
	dc.w	$0479,$0001,$0001,$A390
	jsr	$26348.l
LC09E	rts
SkipOtherUserName
	movem.w	d0,-(sp)
	dc.w	$3039,$0001,$8BF6
	dc.w	$4A79,$0001,$A390
	beq.w	LC0BA
	dc.w	$3039,$0001,$8BF4
LC0BA	dc.w	$B079,$0001,$A38C
	bne.w	LC0DA
	move.w	#$1,d0
	tst.w	(sp)
	bpl.w	LC0D2
	move.w	#$FFFF,d0
LC0D2	dc.w	$D179,$0001,$A38C
	clr.w	d0
LC0DA	movem.w	(sp)+,d0
	rts
RecordHoldersScreen
	move.w	#$0,d0
	move.w	#$1A,d1
	dc.w	$4EB9,$0002,$E728
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pri,$1,$1
	movea.l	$47D80.l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d1
	clr.w	d0
	moveq	#$6,d2
	move.w	#$6,d3
	moveq	#$8,d5
	dc.w	$4EB9,$0003,$87E2
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pri,$21,$1
	movea.l	$47D84.l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d1
	clr.w	d0
	moveq	#$6,d2
	move.w	#$6,d3
	moveq	#$0,d5
	dc.w	$4EB9,$0003,$87E2
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font3Pri,$B,$1
	move.w	#$12,d0
	move.w	#$7,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$9258
	dc.w	$0018
	dc.b	$BD,$0E,$02,$52,$65,$63,$6F,$72,$64,$BD,$0D,$05,$48,$6F,$6C,$64,$65,$72,$73,$BD,$01,$09
	dc.w	$4EB9,$0003,$8D8C
	dc.w	$0010
	dc.b	$F8,$06,$03,$05,$08,$F9,$01,$4E,$61,$6D,$65,$F9,$00,$00
	bsr.w	ReadNameLog
	dc.w	$4279,$0001,$7E62
	bclr	#$6,(sflags6).l
	bsr.w	ReadTeamRecords
	bset	#$6,(sflags6).l
	bsr.w	ReadTeamRecords
	bsr.w	CalcWinPercents
	bsr.w	PrintRecordTitles
	bsr.w	Sub_27398
LC1C2	jsr	(MenuWaitVblank).l
	dc.w	$4EB9,$0002,$F2F0
	dc.w	$4EB9,$0003,$74BE
	btst	#$7,d3
	beq.w	LC1E2
	dc.w	$4EF9,$0002,$E980
LC1E2	dc.w	$4A79,$0001,$7E62
	bne.w	LC20C
	btst	#$6,d3
	beq.w	LC20C
	btst	#$5,d3
	beq.w	LC20C
	bsr.w	Sub_2A604
	bsr.w	CalcWinPercents
	bsr.w	Sub_27398
	bra.w	LC1C2
LC20C	btst	#$3,d1
	beq.w	LC238
	dc.w	$0C79,$0002,$0001,$7E62
	beq.w	LC1C2
	bsr.w	ClearRecordArea
	dc.w	$0679,$0001,$0001,$7E62
	bsr.w	PrintRecordTitles
	bsr.w	Sub_27264
	bra.w	LC1C2
LC238	btst	#$2,d1
	beq.w	LC1C2
	dc.w	$4A79,$0001,$7E62
	beq.w	LC1C2
	bsr.w	ClearRecordArea
	dc.w	$0479,$0001,$0001,$7E62
	bsr.w	PrintRecordTitles
	bsr.w	Sub_27264
	bra.w	LC1C2
	dc.w	$4E75
Sub_27264
	dc.w	$4A79,$0001,$7E62
	beq.w	Sub_27398
	bra.w	Sub_274FA
PrintRecordTitles
	movea.l	#$272A2,a1
	dc.w	$4A79,$0001,$7E62
	beq.w	LC29A
	movea.l	#$27346,a1
	dc.w	$0C79,$0002,$0001,$7E62
	beq.w	LC29A
	movea.l	#$272F4,a1
LC29A	jsr	(printsmall).l
	rts
	dc.w	$0052,$F806,$0310,$08F9,$0120,$2020,$5769,$6E20
	dc.w	$2520,$2020,$5769,$6E2D,$4C6F,$7373,$2D54,$6965
	dc.w	$FD04,$FC19,$5573,$6520,$412B,$4320,$746F,$2063
	dc.w	$6C65,$6172,$2041,$4C4C,$2077,$696E,$2072,$6563
	dc.w	$6F72,$6473,$FD10,$FC1A,$2020,$4D6F,$7265,$205D
	dc.w	$F900,$0052,$F806,$0312,$08F9,$0147,$6F61,$6C73
	dc.w	$2020,$2020,$2020,$2020,$2054,$6561,$6D73,$2020
	dc.w	$2020,$FD04,$FC19,$2020,$2020,$5445,$414D,$204D
	dc.w	$5553,$5420,$5749,$4E20,$544F,$2051,$5541,$4C49
	dc.w	$4659,$2020,$2020,$FD10,$FC1A,$5B20,$4D6F,$7265
	dc.w	$205D,$F900,$0052,$F806,$0312,$08F9,$0153,$6176
	dc.w	$6573,$2020,$2020,$2020,$2020,$2054,$6561,$6D73
	dc.w	$2020,$2020,$FD04,$FC19,$2020,$2020,$5445,$414D
	dc.w	$204D,$5553,$5420,$5749,$4E20,$544F,$2051,$5541
	dc.w	$4C49,$4659,$2020,$2020,$FD10,$FC1A,$5B20,$4D6F
	dc.w	$7265,$2020,$F900
Sub_27398
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetMapAndPosition,$4,$2,$2,$A,CC_SetFont,$0
	move.w	#$6,d7
	dc.w	$207C,$0001,$A3E4
	dc.w	$247C,$0001,$A3EC
	movea.l	#ThreeStars,a5
LC3C2	move.w	#$2,(printx).l
	move.b	(a0)+,d0
	ext.w	d0
	move.b	(a2,d0.w),d5
	asl.w	#$4,d0
	move.b	$A(a5,d0.w),d4
	lsl.w	#$8,d4
	move.b	$B(a5,d0.w),d4
	move.w	d4,-(sp)
	move.b	$C(a5,d0.w),d4
	lsl.w	#$8,d4
	move.b	$D(a5,d0.w),d4
	move.w	d4,$17E9A.l
	move.b	$8(a5,d0.w),d4
	lsl.w	#$8,d4
	move.b	$9(a5,d0.w),d4
	move.w	d4,$17E9E.l
	add.w	$17E9A.l,d4
	sub.w	(sp),d4
	neg.w	d4
	move.w	d4,$17E9C.l
	move.w	(sp)+,d4
	tst.w	d4
	beq.w	LC492
	bsr.w	Sub_27666
	move.w	#$13,(printx).l
	move.w	d0,-(sp)
	move.w	d5,d0
	move.w	#$3,d1
	dc.w	$4EB9,$0003,$919A
	dc.w	$4EB9,$0003,$8D9E
	move.w	#$1A,(printx).l
	move.w	$17E9E.l,d0
	move.w	#$4,d1
	dc.w	$4EB9,$0003,$919A
	dc.w	$4EB9,$0003,$8D9E
	move.w	#$1F,(printx).l
	move.w	$17E9C.l,d0
	move.w	#$4,d1
	dc.w	$4EB9,$0003,$919A
	dc.w	$4EB9,$0003,$8D9E
	move.w	#$24,(printx).l
	move.w	$17E9A.l,d0
	move.w	#$3,d1
	dc.w	$4EB9,$0003,$919A
	move.w	(sp)+,d0
	bra.w	LC498
LC492	movea.l	#$27630,a1
LC498	jsr	(printsmall).l
	addi.w	#$2,(printy).l
	dbra	d7,LC3C2
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ClearRecordArea
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(printx).l,-(sp)
	move.w	(printy).l,-(sp)
	dc.w	$3F39,$0001,$8D5E
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetMapAndPosition,$4,$2,$0,$A
	move.w	#$28,d0
	move.w	#$12,d1
	dc.w	$4EB9,$0003,$8C06
	dc.w	$33DF,$0001,$8D5E
	move.w	(sp)+,(printy).l
	move.w	(sp)+,(printx).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
Sub_274FA
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetMapAndPosition,$4,$2,$2,$A,CC_SetFont,$0
	move.w	#$6,d7
	dc.w	$207C,$0001,$A3D4
	dc.w	$0C79,$0001,$0001,$7E62
	beq.w	LC52A
	dc.w	$207C,$0001,$A3DC
LC52A	movea.l	#ThreeStars,a2
LC530	move.w	#$2,(printx).l
	move.b	(a0)+,d0
	ext.w	d0
	asl.w	#$4,d0
	move.b	(a2,d0.w),d5
	dc.w	$0C79,$0001,$0001,$7E62
	beq.w	LC552
	move.b	$4(a2,d0.w),d5
LC552	tst.b	d5
	beq.w	LC612
	bsr.w	Sub_27666
	move.w	#$12,(printx).l
	move.w	d0,-(sp)
	dc.w	$0C79,$0001,$0001,$7E62
	bne.w	LC57A
	move.b	(a2,d0.w),d0
	bra.w	LC57E
LC57A	move.b	$4(a2,d0.w),d0
LC57E	andi.w	#$FF,d0
	move.w	#$3,d1
	dc.w	$4EB9,$0003,$919A
	dc.w	$4EB9,$0003,$8D9E
	move.w	(sp)+,d0
	move.w	#$19,(printx).l
	movea.l	#$27658,a1
	movea.l	#mesarea,a3
	bsr.w	CopyString
	move.w	d0,-(sp)
	dc.w	$0C79,$0001,$0001,$7E62
	bne.w	LC5C2
	move.b	$1(a2,d0.w),d0
	bra.w	LC5C6
LC5C2	move.b	$5(a2,d0.w),d0
LC5C6	andi.w	#$FF,d0
	movea.l	#mesarea,a1
	bsr.w	AppendTeamName
	movea.l	#$2765E,a1
	movea.l	#mesarea,a3
	dc.w	$4EB9,$0003,$9208
	movea.l	#mesarea,a1
	move.w	(sp)+,d0
	dc.w	$0C79,$0001,$0001,$7E62
	bne.w	LC602
	move.b	$2(a2,d0.w),d0
	bra.w	LC606
LC602	move.b	$6(a2,d0.w),d0
LC606	andi.w	#$FF,d0
	bsr.w	AppendTeamName
	bra.w	LC618
LC612	movea.l	#$27630,a1
LC618	jsr	(printsmall).l
	addi.w	#$2,(printy).l
	dbra	d7,LC530
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$0028,$2020,$2020,$2020,$2020,$2020,$2020,$2020
	dc.w	$2020,$2020,$2020,$2020,$2020,$2020,$2020,$2020
	dc.w	$2020,$2020,$2020,$2020,$0006,$6279,$2000,$0008
	dc.w	$2076,$732E,$2000
Sub_27666
	move.w	d7,-(sp)
	neg.w	d7
	addi.w	#$7,d7
	addi.w	#$30,d7
	movea.l	#mesarea,a1
	move.w	#$6,(a1)
	move.b	d7,$2(a1)
	move.b	#$2E,$3(a1)
	move.b	#$20,$4(a1)
	move.b	#$0,$5(a1)
	dc.w	$4EB9,$0003,$8D9E
	move.w	(sp)+,d7
	move.b	-$1(a0),d2
	ext.w	d2
	movea.l	#mesarea,a1
	bclr	#$7,(sflags6).l
	bsr.w	AppendUserName
	dc.w	$4EF9,$0003,$8D9E
CalcWinPercents
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#ThreeStars,a0
	dc.w	$227C,$0001,$A3EC
	dc.w	$2C7C,$0001,$A3F4
	dc.w	$2A7C,$0001,$A404
	move.w	#$7,d7
LC6D8	move.b	$8(a0),d0
	lsl.w	#$8,d0
	move.b	$9(a0),d0
	move.b	$A(a0),d1
	lsl.w	#$8,d1
	move.b	$B(a0),d1
	move.w	d1,(a5)+
	tst.w	d1
	bne.w	LC6FA
	clr.w	d0
	bra.w	LC700
LC6FA	mulu.w	#$64,d0
	divu.w	d1,d0
LC700	move.b	d0,(a1)+
	move.b	$C(a0),(a6)+
	move.b	$D(a0),(a6)+
	adda.w	#$10,a0
	dbra	d7,LC6D8
	dc.w	$227C,$0001,$A3E4
	move.l	a1,-(sp)
	move.w	#$1,d0
	move.w	#$6,d7
LC722	move.b	d0,(a1)+
	addi.w	#$1,d0
	dbra	d7,LC722
	movea.l	(sp),a1
	dc.w	$207C,$0001,$A3EC
	dc.w	$2C7C,$0001,$A3F4
	dc.w	$2A7C,$0001,$A404
LC740	movea.l	(sp),a1
	move.w	#$5,d7
	clr.w	d6
LC748	move.b	(a1)+,d1
	ext.w	d1
	move.b	(a1),d2
	ext.w	d2
	move.b	(a0,d1.w),d0
	move.b	(a0,d2.w),d3
	cmp.b	d3,d0
	bgt.w	LC7A8
	blt.w	LC79A
	movem.l	d1-d3,-(sp)
	add.w	d1,d1
	add.w	d2,d2
	move.w	(a6,d1.w),d0
	move.w	(a6,d2.w),d3
	cmp.w	d3,d0
	movem.l	(sp)+,d1-d3
	bgt.w	LC7A8
	blt.w	LC79A
	movem.l	d1-d3,-(sp)
	add.w	d1,d1
	add.w	d2,d2
	move.w	(a5,d1.w),d0
	move.w	(a5,d2.w),d3
	cmp.w	d3,d0
	movem.l	(sp)+,d1-d3
	bge.w	LC7A8
LC79A	move.b	(a1),d0
	move.b	-$1(a1),d1
	move.b	d0,-$1(a1)
	move.b	d1,(a1)
	st.b	d6
LC7A8	dbra	d7,LC748
	tst.w	d6
	bne.w	LC740
	movea.l	(sp)+,a1
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ReadTeamRecords
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$203C,$0000,$0D20
	dc.w	$223C,$0000,$0080
	movea.l	#ThreeStars,a0
	jsr	$22452.l
	dc.w	$227C,$0001,$A3D4
	btst	#$6,(sflags6).l
	beq.w	LC7EE
	dc.w	$227C,$0001,$A3DC
LC7EE	move.l	a1,-(sp)
	move.w	#$1,d0
	move.w	#$6,d7
LC7F8	move.b	d0,(a1)+
	addi.w	#$1,d0
	dbra	d7,LC7F8
	movea.l	(sp),a1
	movea.l	#ThreeStars,a0
LC80A	movea.l	(sp),a1
	move.w	#$5,d7
	clr.w	d6
LC812	move.b	(a1)+,d1
	ext.w	d1
	move.b	(a1),d2
	ext.w	d2
	asl.w	#$4,d1
	asl.w	#$4,d2
	move.b	(a0,d1.w),d0
	move.b	(a0,d2.w),d3
	btst	#$6,(sflags6).l
	beq.w	LC83A
	move.b	$4(a0,d1.w),d0
	move.b	$4(a0,d2.w),d3
LC83A	cmp.b	d3,d0
	bge.w	LC84E
	move.b	(a1),d0
	move.b	-$1(a1),d1
	move.b	d0,-$1(a1)
	move.b	d1,(a1)
	st.b	d6
LC84E	dbra	d7,LC812
	tst.w	d6
	bne.w	LC80A
	movea.l	(sp)+,a1
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ShootoutModeBox
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$FFFF,d0
	dc.w	$4EB9,$0003,$9D96
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1Pri,$3,$2
	moveq	#$1B,d0
	moveq	#$C,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$43FA,$013E
	dc.w	$4EB9,$0003,$926A
	dc.w	$3039,$0001,$936C
	movea.l	#tmstruct,a2
	dc.w	$4A79,$0001,$9366
	beq.w	LC8AA
	movea.l	#awtmstruct,a2
LC8AA	jsr	(FormatPlayerNumInitial).l
	move.w	(printx).l,-(sp)
	dc.w	$4EB9,$0003,$8F80
	move.w	(sp)+,(printx).l
	addi.w	#$1,(printy).l
	addi.w	#$6,(printx).l
	dc.w	$4EB9,$0003,$8F6E
	String	' vs.',CC_Font1Pri,$4,$7
	dc.w	$3039,$0001,$936A
	asl.w	#$7,d0
	dc.w	$247C,$0001,$7480
	adda.w	d0,a2
	clr.w	d0
	move.b	$66(a2),d0
	movea.l	#awtmstruct,a2
	dc.w	$4A79,$0001,$9366
	beq.w	LC90E
	movea.l	#tmstruct,a2
LC90E	jsr	(FormatPlayerNumInitial).l
	dc.w	$4EB9,$0003,$8F80
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1Pri,$4,$9
	movea.l	#tmstruct,a1
	movea.l	$1E(a1),a1
	adda.w	$4(a1),a1
	dc.w	$4EB9,$0003,$8F80
	move.w	#$15,(printx).l
	dc.w	$3039,$0001,$A416
	move.w	#$3,d1
	dc.w	$4EB9,$0003,$919A
	dc.w	$4EB9,$0003,$8F80
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1Pri,$4,$A
	movea.l	#awtmstruct,a1
	movea.l	$1E(a1),a1
	adda.w	$4(a1),a1
	dc.w	$4EB9,$0003,$8F80
	move.w	#$15,(printx).l
	dc.w	$3039,$0001,$A418
	move.w	#$3,d1
	dc.w	$4EB9,$0003,$919A
	dc.w	$4EB9,$0003,$8F80
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1Pri,$4,$C,'Round'
	move.l	d0,d0
	move.w	$1A41A.l,d0
	move.w	#$2,d1
	dc.w	$4EB9,$0003,$919A
	dc.w	$4EB9,$0003,$8F80
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$0016,$BF04,$0353,$484F,$4F54,$4F55,$5420,$4D4F
	dc.w	$4445,$BF04,$0500
ClearShootout
	dc.w	$207C,$0001,$7480
	move.w	#$3FF,d0
LC9E4	clr.w	(a0)+
	dbra	d0,LC9E4
	dc.w	$4279,$0001,$AD72
	move.w	#$1,$1A41A.l
	bclr	#$3,$17F78.l
	dc.w	$4279,$0001,$A416
	dc.w	$4279,$0001,$A418
	dc.w	$4279,$0001,$A428
	dc.w	$4279,$0001,$A436
	bsr.w	InitShooters
	dc.w	$33FC,$0001,$0001,$A436
	bsr.w	InitShooters
	dc.w	$4279,$0001,$A436
	rts
