Pausemode_Pmenu
	move.w	$18AD2.l,d0
	bpl.w	L113F6
	clr.w	$18AD2.l
	clr.w	d0
L113F6	dc.w	$2079,$0001,$8AD6
	adda.w	(a0),a0
	adda.w	(a0),a0
	bra.w	L1140E
L11404	adda.w	(a0),a0
	adda.w	#$4,a0
	tst.w	$2(a0)
L1140E	dbmi	d0,L11404
	addi.w	#$1,d0
	sub.w	d0,$18AD2.l
	move.w	$18AD2.l,d0
	cmp.w	$18AD4.l,d0
	bge.w	L11432
	move.w	d0,$18AD4.l
L11432	subi.w	#$3,d0
	cmp.w	$18AD4.l,d0
	ble.w	L11446
	move.w	d0,$18AD4.l
L11446	bsr.w	SetMenuPrintX
	move.w	#$D,(printy).l
	dc.w	$2279,$0001,$8AD6
	dc.w	$4EB9,$0003,$8D9E
	dc.w	$4EB9,$0003,$8D8C
	dc.w	$0026
	dc.b	$FB,$01,$20,$FB,$FF,$FA,$01,$20,$FB,$FF,$FA,$01,$20,$FB,$FF,$FA,$01,$20,$FB,$12,$20,$FB,$FF,$FA,$FF,$20,$FB,$FF,$FA,$FF,$20,$FB,$FF,$FA,$FF,$20
	adda.w	(a1),a1
	move.w	$18AD4.l,d0
	bra.w	L1149C
L11496	adda.w	(a1),a1
	adda.w	#$4,a1
L1149C	dbra	d0,L11496
	moveq	#$3,d1
	move.w	#$C,(printy).l
	bsr.w	SetMenuPrintX
	move.w	$18AD4.l,d0
	beq.w	L114CA
	dc.w	$4EB9,$0003,$8D8C
	dc.w	$000C
	dc.b	$FE,$05,$FB,$01,$FA,$01,$7B,$FA,$FF,$00
L114CA	bsr.w	SetMenuPrintX
	dc.w	$4EB9,$0003,$8D8C
	dc.w	$0006
	dc.b	$FB,$02,$FA,$01
	move.l	a1,-(sp)
	dc.w	$2279,$0001,$8AD6
	dc.w	$4EB9,$0003,$8D9E
	cmp.w	$18AD2.l,d0
	bne.w	L114F8
	dc.w	$4EB9,$0003,$8D9E
L114F8	movea.l	(sp)+,a1
	dc.w	$4EB9,$0002,$C528
	addi.w	#$1,d0
	adda.w	#$4,a1
	tst.w	$2(a1)
	dbmi	d1,L114CA
	bmi.w	L11526
	bsr.w	SetMenuPrintX
	dc.w	$4EB9,$0003,$8D8C
	String	CC_Font2,$5,$FB,$1,'}'
L11526	rts
PrintMenuItem
	cmpi.b	#$78,$2(a1)
	bne.w	L1156E
	move.l	a1,-(sp)
	dc.w	$227C,$0002,$C576
	btst	#$1,$17F6A.l
	beq.w	L11550
	dc.w	$4A79,$0001,$8C0E
	bra.w	L11556
L11550	dc.w	$4A79,$0001,$8C0C
L11556	beq.w	L11560
	movea.l	#$2C58A,a1
L11560	jsr	(printsmall).l
	movea.l	(sp)+,a1
	adda.w	(a1),a1
	bra.w	L11574
L1156E	jsr	(printsmall).l
L11574	rts
PutTeamBlock
	dc.w	$0014,$2020
	dc.w	$4D61,$6E75,$616C,$2047,$6F61,$6C69,$6520,$2020
	dc.w	$0014,$2020,$2041,$7574,$6F20,$476F,$616C,$6965
	dc.w	$2020,$2020
Sub_2C59E
	movem.l	d0-d2/a0-a1,-(sp)
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$17FB2,a1
	adda.w	d0,a1
	moveq	#$1,d2
L115BA	jsr	(xyVmMap).l
	moveq	#$A,d1
L115C2	btst	#$7,$FF800E.l
	bne.b	L115C2
	move.w	(a1)+,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
L115E2	btst	#$6,$FF800E.l
	beq.b	L115E2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L115FC	btst	#$6,$FF800E.l
	bne.b	L115FC
	bclr	#$7,$FF800F.l
	dbra	d1,L115C2
	addi.w	#$1,(printy).l
	dbra	d2,L115BA
	addi.w	#$B,(printx).l
	subi.w	#$2,(printy).l
	move.w	(sp)+,(disflags).l
	movem.l	(sp)+,d0-d2/a0-a1
	rts
MenuWaitVblank
	move.w	d0,-(sp)
	dc.w	$3039,$0001,$7476
	dc.w	$3039,$0001,$7476
L11648	cmp.w	(ScoutSubStatus).l,d0
	beq.w	L11648
	dc.w	$33F9,$0001,$7476,$0001,$7474
	move.w	(sp)+,d0
	rts
ShowScores
	moveq	#$6,d0
	moveq	#$1A,d1
	bsr.w	Sub_2E728
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font3Pri,$5,$0
	moveq	#$1E,d0
	moveq	#$6,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$9258
	String	CC_Font3Pri,$E,$3,'Scores',CC_Font3Pri,$B,$1
	movea.l	$47D58.l,a1
	lea.l	$8(a1),a2
	adda.l	$4(a1),a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	clr.w	d5
	dc.w	$4EB9,$0003,$87E2
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetMapAndPosition,$4,$2,$4,$0
	clr.w	(VertLineScrolling).l
	bsr.w	L1176C
	dc.w	$4EB9,$0004,$081C
	move.w	d1,d3
	ble.w	L116DE
L116D6	bsr.w	L1182E
	dbra	d3,L116D6
L116DE	clr.w	(SelectedPlayerIdx).l
	move.w	(printy).l,d0
	subi.w	#$15,d0
	bmi.w	L116FE
	asl.w	#$3,d0
	move.w	d0,(SelectedPlayerIdx).l
	bsr.w	L118D4
L116FE	bsr.w	MenuWaitVblank
	bsr.w	Sub_2F2F0
	btst	#$7,d3
	bne.w	Sub_2E980
	moveq	#-2,d0
	btst	#$0,d3
	bne.w	L11722
	neg.w	d0
	btst	#$1,d3
	beq.w	L11728
L11722	move.w	d0,(PlayerScrollCtr).l
L11728	bsr.w	UpdateScoresScroll
	bra.w	L116FE
UpdateScoresScroll
	move.w	(PlayerScrollCtr).l,d0
	beq.w	Sub_2F988
	add.w	(VertLineScrolling).l,d0
	bmi.w	Sub_2F988
	cmp.w	(SelectedPlayerIdx).l,d0
	bgt.w	Sub_2F988
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divu.w	#$18,d0
	swap	d0
	tst.w	d0
	bne.w	L1176C
	bsr.w	L118D4
	clr.w	(PlayerScrollCtr).l
L1176C	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$C00000,a0
L11780	btst	#$7,$FF800E.l
	bne.b	L11780
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
L117A4	btst	#$6,$FF800E.l
	beq.b	L117A4
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L117BE	btst	#$6,$FF800E.l
	bne.b	L117BE
	bclr	#$7,$FF800F.l
	move.w	#$FFD0,d0
	add.w	(VertLineScrolling).l,d0
L117DA	btst	#$7,$FF800E.l
	bne.b	L117DA
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
L117FA	btst	#$6,$FF800E.l
	beq.b	L117FA
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L11814	btst	#$6,$FF800E.l
	bne.b	L11814
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
L1182E	dc.w	$B679,$0001,$8A98
	beq.w	Sub_2F988
	moveq	#$10,d0
	mulu.w	d3,d0
	movea.l	#$18A18,a0
	adda.w	d0,a0
	btst	#$1,$E(a0)
	bne.w	Sub_2F988
	btst	#$2,$E(a0)
	bne.w	Sub_2F988
	move.w	$2(a0),d0
	move.w	$C(a0),d1
	bsr.w	PrintGameInfo
	addi.w	#$1,(printy).l
	move.w	$0(a0),d0
	move.w	$A(a0),d1
	bsr.w	PrintGameInfo
	move.w	$8(a0),d0
	subi.w	#$1,d0
	movea.l	#$41A34,a1
	move.w	#$1C,(printx).l
	dc.w	$4EB9,$0003,$CEBE
	addi.w	#$2,(printy).l
	rts
PrintGameInfo
	movea.l	#TeamList,a1
	asl.w	#$2,d0
	movea.l	(a1,d0.w),a1
	adda.w	$4(a1),a1
	move.w	#$6,(printx).l
	dc.w	$4EB9,$0003,$8F80
	move.w	#$18,(printx).l
	move.w	d1,d0
	moveq	#$2,d1
	dc.w	$4EB9,$0003,$919A
	dc.w	$4EF9,$0003,$8F80
L118D4	movem.l	d0-d1/a1,-(sp)
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetMapAndPosition,$4,$3,$4,$6,CC_SetFont,$1
	clr.w	d0
	move.w	(VertLineScrolling).l,d1
	tst.w	d1
	sgt.b	d0
	neg.b	d0
	cmp.w	(SelectedPlayerIdx).l,d1
	slt.b	d1
	neg.b	d1
	add.b	d1,d0
	add.b	d1,d0
	dc.w	$43FA,$000E
	dc.w	$4EB9,$0003,$CEBE
	movem.l	(sp)+,d0-d1/a1
	rts
	dc.w	$000A,$20FB,$FFFA,$1320,$F900,$000A,$7BFB,$FFFA
	dc.w	$1320,$F900,$000A,$20FB,$FFFA,$137D,$F900,$08EA
	dc.w	$0000,$0032,$7000,$721C,$6100,$1DEA,$4279,$0001
	dc.w	$A44E,$4279,$0001,$A452,$33FC,$0001,$0001,$A45A
Sub_2C954
	dc.w	$4EB9,$0003,$8D8C
	dc.w	$0008
	dc.b	$FF,$02,$FD,$00,$FC,$00
	moveq	#$28,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	dc.w	$4EB9,$0003,$8C06
	dc.w	$50F9,$0001,$7F60
	bsr.w	Sub_2CE80
LineEditorMenu
	bsr.w	DrawTeamScreen
	bsr.w	DrawLineIcons
L11982	bsr.w	MenuWaitVblank
	bsr.w	Sub_2F2F0
	dc.w	$4EB9,$0003,$74BE
	btst	#$7,d1
	bne.w	Sub_2CF08
	btst	#$5,d1
	bne.w	SelectLinePlayer
	moveq	#$1,d0
	btst	#$1,d1
	bne.w	L119C8
	moveq	#-1,d0
	btst	#$0,d1
	bne.w	L119C8
	moveq	#$8,d0
	btst	#$3,d1
	bne.w	L119C8
	moveq	#-8,d0
	btst	#$2,d1
	beq.w	L11982
L119C8	add.w	(TestList).l,d0
	dc.w	$4A79,$0001,$8C0A
	beq.w	L119E8
	cmpi.w	#$1,d0
	blt.w	L11982
	cmpi.w	#$5,d0
	bgt.w	L11982
L119E8	lea.l	LineCursorTable(pc),a0
	move.b	$8(a0,d0.w),$1A45B.l
	bsr.w	DrawLineIcons
	bra.w	L11982
SelectLinePlayer
	bsr.w	GetGoalieCount
	move.w	d0,d1
	bsr.w	GetForwardCount
	move.w	(TestList).l,d2
	andi.w	#$7,d2
	cmpi.w	#$2,d2
	bgt.w	L11A20
	add.w	d0,d1
	bsr.w	Sub_2EDBC
	sub.w	d1,d0
L11A20	subi.w	#$1,d0
	move.w	d0,(screentimer).l
	clr.w	(PlayerScrollCtr).l
	clr.w	(VertLineScrolling).l
	dc.w	$207C,$000B,$BD30
	clr.w	d2
L11A3E	move.b	d1,(a0,d2.w)
	cmp.w	d1,d6
	bne.w	L11A4E
	move.w	d2,(VertLineScrolling).l
L11A4E	addi.w	#$1,d1
	addi.w	#$1,d2
	dbra	d0,L11A3E
	bsr.w	ClearLineEditorTop
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetMapAndPosition,$0,$3,$1,$0
	moveq	#$12,d0
	moveq	#$3,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$8D8C
	String	CC_Font3,$15,$FC
	moveq	#$12,d0
	moveq	#$3,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetMapAndPosition,$4,$2,$2,$1,'{Select  Player}'
	clr.w	d0
	bra.w	L11B0E
L11AB0	bsr.w	MenuWaitVblank
	bsr.w	Sub_2F2F0
	dc.w	$4EB9,$0003,$74BE
	btst	#$7,d1
	bne.w	LineEditorMenu
	btst	#$5,d1
	bne.w	L11B54
	moveq	#$1,d0
	btst	#$1,d1
	bne.w	L11B0E
	btst	#$3,d1
	bne.w	L11AF6
	moveq	#-1,d0
	btst	#$0,d1
	bne.w	L11B0E
	btst	#$2,d1
	bne.w	L11AF6
	bra.w	L11AB0
L11AF6	add.w	(scoutcolumn).l,d0
	bmi.w	L11AB0
	move.w	d0,(scoutcolumn).l
	bsr.w	PrintAttribHeader
	bra.w	L11AB0
L11B0E	add.w	(VertLineScrolling).l,d0
	bmi.w	L11AB0
	cmp.w	(screentimer).l,d0
	bgt.w	L11AB0
	move.w	d0,(VertLineScrolling).l
	cmp.w	(PlayerScrollCtr).l,d0
	bgt.w	L11B38
	move.w	d0,(PlayerScrollCtr).l
L11B38	subi.w	#$5,d0
	cmp.w	(PlayerScrollCtr).l,d0
	ble.w	L11B4C
	move.w	d0,(PlayerScrollCtr).l
L11B4C	bsr.w	PrintAttribHeader
	bra.w	L11AB0
L11B54	dc.w	$267C,$000B,$BD30
	adda.w	(VertLineScrolling).l,a3
	move.b	(a3),d0
	addi.b	#$1,d0
	move.w	(TestList).l,d2
	bsr.w	SetLineSlot
	bra.w	LineEditorMenu
PrintAttribHeader
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pri,$16,$1
L11B80	movea.l	#$41C48,a1
	move.w	(scoutcolumn).l,d0
	bra.w	L11B96
L11B90	adda.w	(a1),a1
	adda.w	#$4,a1
L11B96	tst.w	(a1)
	dbmi	d0,L11B90
	bpl.w	L11BAC
	subi.w	#$1,(scoutcolumn).l
	bra.w	L11B80
L11BAC	jsr	(print).l
	move.l	(a1),d4
	dc.w	$267C,$000B,$BD30
	move.w	(PlayerScrollCtr).l,d2
	move.w	(screentimer).l,d1
	sub.w	d2,d1
	cmpi.w	#$5,d1
	bls.w	L11BD2
	moveq	#$5,d1
L11BD2	move.w	#$2,(printy).l
L11BDA	jsr	(printsmallz).l
	dc.w	$0020
	dc.b	$FE,$04,$FD,$05,$FA,$01,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$FD,$05
	cmp.w	(VertLineScrolling).l,d2
	bne.w	L11C10
	move.w	d7,(printa).l
L11C10	clr.w	d0
	move.b	(a3,d2.w),d0
	bsr.w	GetNameandAttrib
	addi.w	#$1,d2
	dbra	d1,L11BDA
	rts
DrawLineIcons
	moveq	#$6,d5
	dc.w	$41FA,$008F
	move.w	(TestList).l,d0
	lsr.w	#$3,d0
	adda.w	d0,a0
	dc.w	$4A79,$0001,$8C0A
	beq.w	L11C42
	suba.w	#$1,a0
L11C42	move.b	(a0),d0
	dc.w	$B039,$0001,$7F60
	beq.w	L11C58
	dc.w	$13C0,$0001,$7F60
	bsr.w	Sub_2CD7A
L11C58	dc.w	$0B39,$0001,$7F60
	beq.w	L11C66
	bsr.w	DrawLineIcon
L11C66	dbra	d5,L11C58
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetMapAndPosition,$4,$2,$8,$7,CC_SetFont,$1
	moveq	#$18,d0
	moveq	#$3,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$8D8C
	String	CC_Font3,$15,$FC,$8
	move.w	d6,d0
	dc.w	$4EB9,$0004,$112E
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	move.w	d7,(printa).l
	dc.w	$4EB9,$0003,$8D9E
	clr.w	(printfontset).l
	rts
	dc.w	$0107,$0707,$1818,$6060
DrawLineIcon
	moveq	#$6,d0
	mulu.w	d5,d0
	dc.w	$41FA,$01D0
	adda.w	d0,a0
	dc.w	$4A79,$0001,$8C0A
	beq.w	L11CD6
	suba.w	#$6,a0
L11CD6	move.w	(a0),(printx).l
	move.w	$2(a0),(printy).l
	move.w	d5,d0
	movea.l	#$419F6,a1
	move.w	#$8000,(printa).l
	dc.w	$4EB9,$0003,$CEBE
	dc.w	$4EB9,$0003,$8D8C
	String	' Line'
	move.w	(a0),(printx).l
	move.w	d5,d4
	asl.w	#$3,d4
	addi.w	#$1,d4
	move.w	$2(a0),(printy).l
	move.w	$4(a0),d3
	lea.l	$16C(a2),a3
L11D26	move.w	(a0),(printx).l
	dc.w	$4EB9,$0003,$8D8C
	dc.w	$0008
	dc.b	$FB,$FF,$FA,$02,$FE,$06
	clr.w	d0
	move.b	(a3,d4.w),d0
	subi.w	#$1,d0
	jsr	$41226.l
	cmp.w	(TestList).l,d4
	bne.w	L11D64
	move.w	d0,d6
	move.w	(printa).l,d7
	move.w	#$2,(printfontset).l
L11D64	jsr	(printsmall).l
	clr.w	(printfontset).l
	addi.w	#$1,d4
	dbra	d3,L11D26
	rts
Sub_2CD7A
	dc.w	$4EB9,$0003,$8D8C
	dc.w	$0008
	dc.b	$FF,$02,$FD,$00,$FC,$0A
	moveq	#$28,d0
	moveq	#$12,d1
	move.w	#$7FF,d2
	dc.w	$4EB9,$0003,$8C06
	move.w	$2CE96.l,(printy).l
	move.w	(LineIconPosTable).l,(printx).l
	dc.w	$4A79,$0001,$8C0A
	beq.w	L11DBE
	move.w	$2CE8E.l,(printx).l
L11DBE	jsr	(printsmallz).l
	dc.w	$0022
	dc.b	$FE,$04,$FB,$FD,$FA,$02,$4C,$44,$FB,$FE,$FA,$02,$52,$44,$FB,$FE,$FA,$02,$4C,$57,$FB,$FE,$FA,$02,$43,$20,$FB,$FE,$FA,$02,$52,$57
	rts
DrawTeamScreen
	bsr.w	ClearLineEditorTop
	movem.l	d0-d5/a0-a2,-(sp)
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font3,$0,$0
	movea.l	(EASportsBGMap).l,a1
	adda.l	$4(a1),a1
	movea.l	#$1B008,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	moveq	#$1,d4
	moveq	#$0,d5
	dc.w	$4EB9,$0003,$87E2
	movem.l	(sp)+,d0-d5/a0-a2
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pri,$7,$1
	moveq	#$1A,d0
	moveq	#$6,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$9258
	String	CC_Font2Pri,$A,$4,'Line Editor',CC_Font2Pri,$E,$1
	clr.w	d0
	cmpa.l	#$1834C,a2
	beq.w	Sub_2C59E
	moveq	#$2C,d0
	bra.w	Sub_2C59E
ClearLineEditorTop
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pri,$0,$0
	moveq	#$28,d0
	moveq	#$A,d1
	move.w	#$7FF,d2
	dc.w	$4EF9,$0003,$8C06
Sub_2CE80
	clr.w	$BBD0A.l
	clr.w	$BBD2A.l
	rts
	dc.w	$0010,$000C,$0004
LineIconPosTable
	dc.w	$0004,$000C,$0004,$0010,$000C,$0004,$001C,$000C
	dc.w	$0004,$0004,$000C,$0004,$0010,$000C,$0004,$0004
	dc.w	$000C,$0003,$0010,$000C,$0003,$FFFF
LineCursorTable
	dc.w	$0101,$0203,$0405,$1901,$0101,$0203,$0405,$1901
	dc.w	$0909,$0A0B,$0C0D,$2101,$1111,$1213,$1415,$2101
	dc.w	$0519,$1A1B,$1C1D,$2901,$0D21,$2223,$2425,$3101
	dc.w	$1D29,$2A2B,$2C2C,$0101,$2531,$3233,$3434,$0101
	dc.w	$2531,$3233,$3434,$0101
Sub_2CF08
	bsr.w	Sub_2CE80
	move.w	#$18,(palcount).l
L11F14	tst.w	(palcount).l
	bpl.w	L11F14
	move.l	$18AD2.l,-(sp)
	dc.w	$2F39,$0001,$8AD6
	dc.w	$2F39,$0001,$8ADA
	dc.w	$227C,$0003,$C000
	movea.l	#$427D8,a0
	movea.l	#$18C26,a3
	move.w	$2A(a2),d0
	addi.w	#$1,d0
	cmp.b	(a3),d0
	beq.w	L11F56
	movea.l	#$42848,a0
L11F56	jsr	(printsmallz).l
	String	CC_Font1,$2
	bsr.w	Sub_2C2F8
L11F64	bsr.w	MenuWaitVblank
	bsr.w	Sub_2F2F0
	dc.w	$4EB9,$0003,$74BE
	move.w	d1,-(sp)
	bsr.w	HandleMenuInput
	move.w	(sp)+,d1
	andi.w	#$A0,d1
	beq.w	L11F64
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetFont
	move.w	$18AD2.l,d0
	dc.w	$23DF,$0001,$8ADA
	dc.w	$23DF,$0001,$8AD6
	move.l	(sp)+,$18AD2.l
	tst.w	d0
	bne.w	Sub_2C954
	bra.w	Sub_2E980
SetLineSlot
	movem.l	d0-d2/a0-a1,-(sp)
	lea.l	$16C(a2),a0
	move.w	d2,d1
	andi.w	#$FFF8,d1
	lea.l	(a0,d1.w),a1
	moveq	#$5,d1
L11FC2	cmp.b	$1(a1,d1.w),d0
	dbeq	d1,L11FC2
	bne.w	L11FD4
	move.b	(a0,d2.w),$1(a1,d1.w)
L11FD4	move.b	d0,(a0,d2.w)
	movem.l	(sp)+,d0-d2/a0-a1
	rts
DecodeTeamLines
	movem.l	d0-d4/a0/a3,-(sp)
	movea.l	#$18C26,a0
	adda.w	#$1,a0
	bsr.w	GetGoalieCount
	move.w	d0,d1
	bsr.w	GetForwardCount
	move.w	d0,d3
	dc.w	$267C,$0002,$D0B2
	clr.w	d4
	clr.w	d2
L12002	move.b	(a3),d2
	bmi.w	L12040
	bchg	#$0,d4
	bne.w	L12016
	move.b	(a0),d0
	bra.w	L1201A
L12016	move.b	(a0)+,d0
	lsr.w	#$4,d0
L1201A	andi.w	#$F,d0
	add.b	d1,d0
	andi.w	#$7,d2
	cmpi.w	#$2,d2
	bgt.w	L1202E
	add.b	d3,d0
L1202E	addi.b	#$1,d0
	andi.w	#$FF,d0
	move.b	(a3)+,d2
	bsr.w	SetLineSlot
	bra.w	L12002
L12040	movem.l	(sp)+,d0-d4/a0/a3
	rts
EncodeTeamLines
	movem.l	d0-d4/a0-a3,-(sp)
	movea.l	#$18C26,a0
	move.w	$2A(a2),d0
	addi.w	#$1,d0
	move.b	d0,(a0)+
	lea.l	$16C(a2),a1
	bsr.w	GetGoalieCount
	move.w	d0,d1
	bsr.w	GetForwardCount
	dc.w	$267C,$0002,$D0B2
	clr.w	d4
	clr.w	d2
L12072	move.b	(a3)+,d2
	bmi.w	L120A6
	move.b	(a1,d2.w),d3
	subi.b	#$1,d3
	sub.b	d1,d3
	andi.w	#$7,d2
	cmpi.w	#$2,d2
	bgt.w	L12090
	sub.b	d0,d3
L12090	bchg	#$0,d4
	bne.w	L1209E
	move.b	d3,(a0)
	bra.w	L12072
L1209E	asl.b	#$4,d3
	or.b	d3,(a0)+
	bra.w	L12072
L120A6	jsr	$2A5C8.l
	movem.l	(sp)+,d0-d4/a0-a3
	rts
AttributeOffsetTbl
	dc.w	$0102,$0304,$0509,$0A0B,$0C0D,$1112,$1314,$1519
	dc.w	$1A1B,$1C1D,$2122,$2324,$2529,$2A2B,$2C31,$3233
	dc.w	$34FF
TeamRosterScreen
	moveq	#$D,d0
	moveq	#$17,d1
	bsr.w	Sub_2E728
	moveq	#$1,d0
	add.w	$16(a2),d0
	move.w	d0,(SelectedPlayerIdx).l
	clr.w	(scoutcolumn).l
L120EE	jsr	(printz).l
	String	CC_Font3Pri,$7,$1
	moveq	#$1A,d0
	moveq	#$6,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$9258
	String	CC_Font3Pri,$9,$4,'Team  Roster',CC_Font3Pri,$E,$1
	clr.w	d0
	cmpa.l	#$1834C,a2
	beq.w	L1212C
	moveq	#$2C,d0
L1212C	bsr.w	Sub_2C59E
	dc.w	$4EB9,$0003,$8D8C
	dc.w	$0034
	dc.b	$F8,$06,$03,$02,$0C,$F9,$01,$50,$6F,$73,$2E,$5E,$50,$6C,$61,$79,$65,$72,$FD,$1E,$FC,$0C,$52,$61,$74,$69,$6E,$67,$FD,$0C,$FC,$1A,$41,$5E,$2D,$5E,$53,$77,$69,$74,$63,$68,$5E,$54,$65,$61,$6D,$73,$F9,$00
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font3Pri,$1,$8
	moveq	#$12,d0
	moveq	#$3,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font3Pri,$15,$8
	moveq	#$12,d0
	moveq	#$3,d1
	dc.w	$4EB9,$0003,$8CA0
	bsr.w	Sub_2D396
	move.w	(SelectedPlayerIdx).l,d0
	mulu.w	#$80,d0
	move.w	d0,(VertLineScrolling).l
	bsr.w	Sub_2D264
	clr.w	(PlayerScrollCtr).l
L121B4	bsr.w	MenuWaitVblank
	bsr.w	Sub_2F2F0
	dc.w	$4EB9,$0003,$74BE
	btst	#$7,d3
	bne.w	Sub_2E980
	btst	#$6,d1
	bne.w	L12230
	dc.w	$4EB9,$0003,$7496
	moveq	#$1,d0
	btst	#$3,d1
	bne.w	L12218
	neg.w	d0
	btst	#$2,d1
	bne.w	L12218
	tst.w	(PlayerScrollCtr).l
	bne.w	L12210
	moveq	#-2,d0
	btst	#$0,d3
	bne.w	L1220A
	neg.w	d0
	btst	#$1,d3
	beq.w	L12210
L1220A	move.w	d0,(PlayerScrollCtr).l
L12210	bsr.w	CheckPlayerListScroll
	bra.w	L121B4
L12218	add.w	(scoutcolumn).l,d0
	bmi.w	L12210
	move.w	d0,(scoutcolumn).l
	bsr.w	Sub_2D396
	bra.w	L12210
L12230	lea.l	$366(a2),a2
	cmpa.l	#$186B2,a2
	beq.w	L120EE
	movea.l	#tmstruct,a2
	bra.w	L120EE
CheckPlayerListScroll
	move.w	(PlayerScrollCtr).l,d0
	beq.w	Sub_2F988
	add.w	(VertLineScrolling).l,d0
	bmi.w	L12366
	cmpi.w	#$380,d0
	bgt.w	L12366
Sub_2D264
	move.w	(VertLineScrolling).l,d1
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divs.w	#$80,d0
	swap	d0
	tst.w	d0
	bne.w	L12284
	clr.w	(PlayerScrollCtr).l
L12284	andi.w	#$7F,d1
	bne.w	L122A4
	cmpi.w	#$7E,d0
	bne.w	L12298
	bsr.w	L1236E
L12298	cmpi.w	#$2,d0
	bne.w	L122A4
	bsr.w	L12380
L122A4	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$C00000,a0
L122B8	btst	#$7,$FF800E.l
	bne.b	L122B8
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
L122DC	btst	#$6,$FF800E.l
	beq.b	L122DC
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L122F6	btst	#$6,$FF800E.l
	bne.b	L122F6
	bclr	#$7,$FF800F.l
	move.w	#$FF90,d0
	add.w	(VertLineScrolling).l,d0
L12312	btst	#$7,$FF800E.l
	bne.b	L12312
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
L12332	btst	#$6,$FF800E.l
	beq.b	L12332
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1234C	btst	#$6,$FF800E.l
	bne.b	L1234C
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
L12366	clr.w	(PlayerScrollCtr).l
	rts
L1236E	move.l	d0,-(sp)
	swap	d0
	move.w	d0,(SelectedPlayerIdx).l
	bsr.w	Sub_2D396
	move.l	(sp)+,d0
	rts
L12380	move.l	d0,-(sp)
	swap	d0
	addi.w	#$1,d0
	move.w	d0,(SelectedPlayerIdx).l
	bsr.w	Sub_2D396
	move.l	(sp)+,d0
	rts
