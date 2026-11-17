ReadLineData						;Read the $100 bytes at save RAM LineDataBase to databuffer; sflags bit 4
	
	
	moveq	#$0,d3
	addq.b	#$5,d0
	move.w	(a2,d3.w),-(a0)
	dc.w	$5A31,$3433
	dc.w	$3334,$5A00
	dc.b	'5757668:98Ze'
	dc.w	$4A4B
	dc.w	$4B00
	addq.b	#$5,d0
	move.w	#$3D00,-(a5)
	dc.b	'Z<>??',$00,'Z',$00,'wuv',$00,'Z',$00,'@B'
	dc.b	'ABZ@CCEDZFONOMZL'
	dc.b	'PQP',$00,'ZRGHGIZITUS',$00
	dc.b	'Z',$00,'wuv',$00,'Z',$00,'VWVX',$00,'XY['
	dc.b	'Y',$5C,'Z',$5C,']^]',$00,'Z^_`acde'
	dc.b	'ghhgZijkk',$00,'Z',$00,'llm',$00
	dc.b	'Z',$00,'nop',$00,'Z',$00,'qsq',$00,'Ztwu'
	dc.b	'v',$00,'Z',$00,'TUS',$00,'Z',$00,'TUS',$00,'Z',$00
	dc.b	'4@BIX',$5C,'ef'
	movem.l	d0-d1/a0,-(sp)
	move.l	#$100,d1
	move.l	#$E20,d0
	movea.l	#$18C26,a0
	jsr	$22452.l
	bclr	#$4,$17F6A.l
	move.w	#$FFFF,(lastsfx).l
	move.l	#$C45C,$17470.l
	movem.l	(sp)+,d0-d1/a0
	rts
	movem.l	d0-d1/a0,-(sp)
	move.l	#$100,d1
	move.l	#$E20,d0
	movea.l	#$18C26,a0
	jsr	$2246C.l
	bclr	#$4,$17F6A.l
	move.w	#$FFFF,(lastsfx).l
	move.l	#$C45C,$17470.l
	movem.l	(sp)+,d0-d1/a0
	rts
ClearWinRecords
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#ThreeStars,a0
	move.w	#$7,d7
.lF612	clr.b	$8(a0)
	clr.b	$9(a0)
	clr.b	$A(a0)
	clr.b	$B(a0)
	adda.w	#$10,a0
	dbra	d7,.lF612
	move.l	#$D20,d0
	move.l	#$80,d1
	movea.l	#ThreeStars,a0
	jsr	$2246C.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PSandSOpassdir						;Penalty shot / shootout: passdir = sopathdir (the end of the skate path,
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	$1A8BC.l,d0
	btst	#$7,$62(a3)
	bne.w	.lF668
	movea.l	#$2A674,a0
	add.w	d0,d0
	move.w	(a0,d0.w),d0
.lF668	move.w	d0,$17E2C.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$0000,$0007,$0006,$0005,$0004,$0003,$0002,$0001
	dc.w	$0008
StartShootoutPath						;Shootout: pick one of the 7 skate paths (ShootoutPaths) at random
	
	
	movem.l	d0-d7/a0-a6,-(sp)
.lF68A	move.w	#$7,d0
	jsr	(randomd0).l
	cmpi.w	#$6,d0
	bgt.w	.lF68A
	move.w	d0,$1A8B4.l
	bclr	#$3,$17F7A.l
	move.w	#$FFFF,$1A8B6.l
	clr.w	$1A8B8.l
	bsr.w	NextPathPoint
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
NextPathPoint
	movem.l	d0-d7/a0-a6,-(sp)
	cmpi.b	#$80,$1A8B8.l
	beq.w	.lF7B0
	addi.w	#$1,$1A8B6.l
	move.w	$1A8B6.l,d0
	asl.w	#$2,d0
	movea.l	#$2A6C2,a0
	move.w	$1A8B4.l,d1
	asl.w	#$2,d1
	movea.l	(a0,d1.w),a0
	move.w	(a0,d0.w),$1A8B8.l
	btst	#$0,$76(a3)
	beq.w	.lF780
	neg.w	$1A8B8.l
.lF780	move.w	$2(a0,d0.w),$1A8BA.l
	cmpi.b	#$80,$4(a0,d0.w)
	bne.w	.lF7B0
	bset	#$3,$17F7A.l
	clr.w	$1A8BE.l
	move.b	$5(a0,d0.w),$1A8BF.l
	move.w	$6(a0,d0.w),$1A8BC.l
.lF7B0	movem.l	(sp)+,d0-d7/a0-a6
	rts
	movem.l	d2-d7/a0-a6,-(sp)
	cmpi.b	#$80,$1A8B8.l
	beq.w	.lF844
	move.w	$1A8B8.l,d0
	move.w	$1A8BA.l,d1
	btst	#$7,$62(a3)
	bne.w	.lF7E0
	neg.w	d0
	neg.w	d1
.lF7E0	sub.w	$0(a3),d0
	bpl.w	.lF7EA
	neg.w	d0
.lF7EA	tst.w	$28(a3)
	bne.w	.lF802
	tst.w	$2A(a3)
	bne.w	.lF802
	cmpi.w	#$12,d0
	ble.w	.lF80A
.lF802	cmpi.w	#$A,d0
	bgt.w	.lF838
.lF80A	sub.w	$14(a3),d1
	bpl.w	.lF814
	neg.w	d1
.lF814	tst.w	$28(a3)
	bne.w	.lF82C
	tst.w	$2A(a3)
	bne.w	.lF82C
	cmpi.w	#$12,d1
	ble.w	.lF834
.lF82C	cmpi.w	#$A,d1
	bgt.w	.lF838
.lF834	bsr.w	NextPathPoint
.lF838	move.w	$1A8B8.l,d0
	move.w	$1A8BA.l,d1
.lF844	movem.l	(sp)+,d2-d7/a0-a6
	rts
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#$1,$17F78.l
	beq.w	.lF8F8
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	bne.w	.lF8F8
	cmpi.w	#$3,$193B6.l
	ble.w	.lF8F2
	cmpi.b	#$80,$1A8B8.l
	beq.w	.lF8F2
	btst	#$3,$17F7A.l
	bne.w	.lF8B0
	tst.w	$17BA8.l
	bne.w	.lF8F8
	tst.w	$17BAA.l
	bne.w	.lF8F8
	cmpi.w	#$F,$193B6.l
	blt.w	.lF8F2
	bra.w	.lF8F8
.lF8B0	move.w	$1A8B8.l,d0
	move.w	$1A8BA.l,d1
	btst	#$7,$62(a3)
	bne.w	.lF8CA
	neg.w	d0
	neg.w	d1
.lF8CA	sub.w	$0(a3),d0
	bpl.w	.lF8D4
	neg.w	d0
.lF8D4	sub.w	$14(a3),d1
	bpl.w	.lF8DE
	neg.w	d1
.lF8DE	cmp.w	$1A8BE.l,d0
	bgt.w	.lF8F8
	cmp.w	$1A8BE.l,d1
	bgt.w	.lF8F8
.lF8F2	clr.w	d0
	bra.w	.lF8FC
.lF8F8	move.w	#$1,d0
.lF8FC	movem.l	(sp)+,d0-d7/a0-a6
	rts
UnpackPicture						;Unpack a picture a2: count.w, then 3 bytes per row of 8 pixels to 4 bit
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#picturebuf,a0
	movea.l	#$1AD42,a1
	move.w	(a2)+,d0
	move.w	d0,(a0)+
	asl.w	#$3,d0
	subi.w	#$1,d0
.loop	clr.l	(a0)
	clr.l	(a1)
	move.b	(a2)+,(a1)
	move.b	(a2)+,$1(a1)
	move.b	(a2)+,$2(a1)
	move.l	#$0,-(sp)
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
	dbra	d0,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	move.w	d0,-(sp)
	subi.w	#$18,d4
	tst.w	$17468.l
	beq.s	.lF9E6
	movea.l	$47DA8.l,a2
	bra.s	.lF9EC
.lF9E6	movea.l	$47D90.l,a2
.lF9EC	adda.w	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	(sp)+,d0
	rts
TeamGfxListEnd						;end of TeamGfxList (size check below)
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
	jsr	(printz).l
	String	' ('
	adda.w	#$D0,a2
	bra.w	PrintParenNumber
	movem.l	d0/a2,-(sp)
	jsr	(printz).l
	String	' ('
	adda.w	#$B6,a2
PrintParenNumber						;PrintPlayerAssists / PrintPlayerGoals: the number (1 to 3 digits,
	
	move.b	(a2,d0.w),d0
	ext.w	d0
	move.w	#$1,d1
	cmpi.w	#$9,d0
	ble.w	.0
	move.w	#$2,d1
	cmpi.w	#$63,d0
	ble.w	.0
	move.w	#$3,d1
.0	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	')'
	addi.w	#$1,(printy).l
	move.w	#$E,(printx).l
	movem.l	(sp)+,d0/a2
	rts
PlaceBoardFall						;A player falling into the boards (SPAboardfront ... SPAbenchcheckl). For
	
	
	
	
	cmpi.w	#$193E,$58(a3)
	beq.w	.12
	cmpi.w	#$1A00,$58(a3)
	beq.w	.8
	cmpi.w	#$18CC,$58(a3)
	beq.w	.10
	cmpi.w	#$17E8,$58(a3)
	beq.w	.6
	cmpi.w	#$1776,$58(a3)
	beq.w	.0
	cmpi.w	#$185A,$58(a3)
	beq.w	.3
	bra.w	.x
.0	move.w	#$124,d0
	cmpi.w	#$56,$1937E.l
	bgt.w	.1
	cmpi.w	#$FFAA,$1937E.l
	bgt.w	.2
.1	move.w	#$116,d0
.2	sub.w	$14(a3),d0
	bmi.w	.x
	asr.w	#$1,d0
	add.w	d0,$14(a3)
	bra.w	.x
.3	move.w	#$FEDC,d0
	cmpi.w	#$56,$1937E.l
	bgt.w	.4
	cmpi.w	#$FFAA,$1937E.l
	bgt.w	.5
.4	move.w	#$FEEA,d0
.5	sub.w	$14(a3),d0
	bpl.w	.x
	asr.w	#$1,d0
	add.w	d0,$14(a3)
	bra.w	.x
.6	move.w	#$82,d0
	btst	#$3,$4(a3)
	beq.w	.7
	move.w	#$FF7E,d0
.7	sub.w	$0(a3),d0
	asr.w	#$1,d0
	add.w	d0,$0(a3)
	bra.w	.x
.8	move.w	#$88,d0
	btst	#$3,$4(a3)
	beq.w	.9
	move.w	#$FF78,d0
.9	sub.w	$0(a3),d0
	asr.w	#$1,d0
	add.w	d0,$0(a3)
	bra.w	.x
.10	move.w	#$FF7E,d0
	btst	#$3,$4(a3)
	beq.w	.11
	move.w	#$82,d0
.11	sub.w	$0(a3),d0
	asr.w	#$1,d0
	add.w	d0,$0(a3)
	bra.w	.x
.12	move.w	#$FF78,d0
	btst	#$3,$4(a3)
	beq.w	.13
	move.w	#$88,d0
.13	sub.w	$0(a3),d0
	asr.w	#$1,d0
	add.w	d0,$0(a3)
.x	rts
GetLeagueCrowdRecord						;d0 = the team (of NumTeams) with the highest crowd record (crpeak)
	
	movem.l	d1-d7/a0-a6,-(sp)
	move.w	#$1B,d1
	ext.l	d1
	clr.w	d7
	movea.l	#ThreeStars,a0
.loop	jsr	(ReadCrowdRecord).l
	clr.w	d2
	move.b	$8(a0),d2
	bne.w	.0
	move.w	#$50,d2
.0	cmp.w	d7,d2
	ble.w	.lFC32
	move.w	d2,d7
	move.w	d1,d0
.lFC32	dbra	d1,.loop
	movem.l	(sp)+,d1-d7/a0-a6
	rts
getFgtbyte						;d0 = fighting byte of a2 / 4. Called from setInjuryType
	clr.w	d0
	move.b	$74(a2),d0
	lsr.w	#$2,d0
	rts
	btst	#$1,$74(a2)
	rts
RandomFaceoffAnim						;d0 = a random faceoff animation from FaceoffAnims, 6 when fox <= -$40 and
	
	movem.l	a0,-(sp)
	movea.l	#$2AC8E,a0
	move.w	#$64,d0
	jsr	(randomd0).l
	andi.w	#$7,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d0
	cmpi.w	#$FFC0,$17EE2.l
	bgt.w	.x
	cmpi.w	#$C0,$17EE4.l
	bgt.w	.x
	move.w	#$6,d0
.x	movem.l	(sp)+,a0
	rts
	dc.w	$0003,$0005,$0003,$0001,$0005,$0002,$0003,$0003
	dc.w	$FFFF
CheckScoreLeader						;Compare tmap (players on ice) of tmstruct / awtmstruct and test tmteam of
	
	
	movem.l	d0-d2/a0-a2,-(sp)
	movea.l	#tmstruct,a0
	movea.l	#awtmstruct,a1
	move.w	$26(a0),d0
	sub.w	$26(a1),d0
	beq.w	.x
	bpl.w	.0
	exg.l	a0,a1
.0	cmpi.w	#$13,$2A(a0)
	bne.w	.x
.x	movem.l	(sp)+,d0-d2/a0-a2
	rts
DrawPlayoffSprite						;The StanleyCupSprite sprite at playoffspritex / playoffspritey in Satt,
	
	
	movea.l	#$BBD30,a6
	moveq	#$1,d6
	movea.l	$47D94.l,a0
	move.w	$18D46.l,d3
	ori.w	#$8000,d3
	move.w	$17CE4.l,d0
	move.w	$17CE6.l,d1
	move.w	#$1,d2
	jsr	(SetSframe).l
	cmpa.l	#$BBD30,a6
	bne.w	.0
	clr.l	(a6)+
	clr.l	(a6)+
.0	clr.b	-$5(a6)
	move.l	a6,d0
	subi.l	#$BBD30,d0
	lsr.w	#$1,d0
	move.w	d0,$17F66.l
	rts
GetTeamStruct						;a2 = tmstruct, or awtmstruct when team d2 is not tmteam of tmstruct.
	
	movea.l	#tmstruct,a2
	cmp.w	$2A(a2),d2
	beq.w	.x
	movea.l	#awtmstruct,a2
.x	rts
	movem.l	d1/a0,-(sp)
	btst	#$0,$17F68.l
	bne.w	.lFD80
	move.w	$17E62.l,d1
	movea.l	#$1AD46,a0
	tst.w	d4
	beq.w	.lFD62
	movea.l	#$1AD4E,a0
.lFD62	addi.l	#$1,(a0)
	cmpi.w	#$8,d1
	beq.w	.lFD80
	cmp.w	$54(a3),d1
	beq.w	.lFD80
	addi.l	#$1,$4(a0)
.lFD80	movem.l	(sp)+,d1/a0
	rts
TerminateLogName						;Unreferenced. The GetLogName String at lognametext, ended with 0 at
	
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#$1AD5C,a1
	bsr.w	GetLogName
	move.w	$1A38A.l,d0
	move.b	#$0,(a1,d0.w)
	addi.w	#$1,d0
	andi.w	#$FFFE,d0
	move.w	d0,-$2(a1)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PlayedByHome						;a1 = String "(played by NAME)" for homeuser (GetLogName name), or an
	
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	$18BF4.l,d0
PlayedByText						;PlayedByHome / PlayedByAway body
	tst.w	d0
	beq.w	PlayedByNone
	movea.l	#$1A37E,a1
	move.w	d0,$1A38C.l
	bsr.w	GetLogName
	adda.w	$1A38A.l,a1
	move.b	#$0,(a1)
	addi.w	#$1,$1A38A.l
	andi.w	#$FFFE,$1A38A.l
	addi.w	#$2,$1A38A.l
	move.w	$1A38A.l,$1A37C.l
	movea.l	#$1A37C,a1
	move.l	a1,-(sp)
	movea.l	#TempBuffer,a3
	movea.l	#$2AE40,a1
	bsr.w	CopyString
	movea.l	(sp)+,a1
	movea.l	#TempBuffer,a3
	jsr	(appstring).l
	movea.l	#TempBuffer,a3
	jsr	(PushNumberWidthSub1).l
	String	')'
	movea.l	#TempBuffer,a1
PlayedByExit
	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
	dc.b	$00,$0E,'(played by ',$00,$00,$02
PlayedByNone
	movea.l	#$2AE4E,a1
	bra.w	PlayedByExit
PlayedByAway						;As PlayedByHome for awayuser. Called from UpdateScoutingDisplay
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	$18BF6.l,d0
	bra.w	PlayedByText
	bra.w	PlayedByAwaySub1
	dc.w	$08B9,$0001,$0001,$7F7C,$6000,$000A
PlayedByAwaySub1
	bset	#$1,$17F7C.l
	rts
AttribAdjust						;An attribute under $32 becomes d0 / 2 + $19. Called from AttribRating,
	
	cmpi.w	#$32,d0
	bge.w	.lFE90
	asr.w	#$1,d0
	addi.w	#$19,d0
.lFE90	rts
	dc.w	$48A7,$C000,$3039,$0001,$7B80,$906B,$0000,$0C40
	dc.w	$001E,$6E00,$0030,$3239,$0001,$7BA8,$B340,$0240
	dc.w	$8000,$6700,$0020,$3039,$0001,$7B94,$906B,$0014
	dc.w	$0C40,$001E,$6E00,$000E,$3239,$0001,$7BAA,$B340
	dc.w	$0240,$8000,$4C9F,$0003,$4E75
ReadGoaliePulled						;Z clear when the team of a3 pulled its goalie ($26 of the team struct).
	
	movem.l	a1,-(sp)
	movea.l	#tmstruct,a1
	btst	#$6,$62(a3)
	beq.w	.lFEF6
	movea.l	#awtmstruct,a1
.lFEF6	tst.w	$28(a1)
	movem.l	(sp)+,a1
	rts
EndOneTimer						;End a one-timer for a3: bits cleared, onetimerplayer = -1, SetSPA
	
	
	movem.l	d0/a0,-(sp)
	bclr	#$3,$64(a3)
	bclr	#$5,$62(a3)
	bclr	#$1,$63(a3)
	clr.w	$17EC6.l
	st.b	$17EBC.l
	move.w	d1,-(sp)
	move.w	#$50C,d1
	jsr	(SetSPA).l
	tst.w	$34(a3)
	bpl.w	.lFF40
	jsr	(assexit).l
	bra.w	.lFF46
.lFF40	jsr	(Setplass).l
.lFF46	clr.w	$5A(a3)
	st.b	$5C(a3)
	move.w	(sp)+,d1
	movem.l	(sp)+,d0/a0
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_0FF56.bin
ClearPenalties						;Clear the penalties: PBnum, Penaltytimer, PenCntDwn, PenBuf and both
									;teams' penalty slots (clrTmPdst). Called from clockcont_0
	movem.l	d0/a0,-(sp)
	clr.w	$18068.l
	clr.w	$18066.l
	clr.w	$18064.l
	move.w	#$10,d0
	movea.l	#$18022,a0
.l103C8	clr.l	(a0)+
	dbra	d0,.l103C8
	movea.l	#tmstruct,a0
	bsr.w	clrTmPdst
	movea.l	#awtmstruct,a0
	bsr.w	clrTmPdst
	movem.l	(sp)+,d0/a0
	rts
clrTmPdst						;Put all 26 players of team struct a0 on the bench (tmpdst -2), then the
									;end word -1
	move.w	#$19,d0		;19 = 25 decimal (max roster size)
	adda.w	#$68,a0		;tmpdst
.l103F0	move.w	#$FFFE,(a0)+		;-2 = bench
	dbra	d0,.l103F0
	move.w	#$FFFF,(a0)
	rts
