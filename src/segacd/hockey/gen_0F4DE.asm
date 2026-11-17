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
ReadLineDataStr1	dc.b	'4@BIX',$5C,'ef'
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
.loop	clr.b	$8(a0)
	clr.b	$9(a0)
	clr.b	$A(a0)
	clr.b	$B(a0)
	adda.w	#$10,a0
	dbra	d7,.loop
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
	bne.w	.next
	movea.l	#$2A674,a0
	add.w	d0,d0
	move.w	(a0,d0.w),d0
.next	move.w	d0,$17E2C.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PSandSOpassdirTbl1	dc.w	$0000,$0007,$0006,$0005,$0004,$0003,$0002,$0001
	dc.w	$0008
StartShootoutPath						;Shootout: pick one of the 7 skate paths (ShootoutPaths) at random
	
	
	movem.l	d0-d7/a0-a6,-(sp)
.loop	move.w	#$7,d0
	jsr	(randomd0).l
	cmpi.w	#$6,d0
	bgt.w	.loop
	move.w	d0,$1A8B4.l
	bclr	#$3,$17F7A.l
	move.w	#$FFFF,$1A8B6.l
	clr.w	$1A8B8.l
	bsr.w	NextPathPoint
	movem.l	(sp)+,d0-d7/a0-a6
	rts
StartShootoutPathTbl1	dc.w	$0002,$A6DE,$0002,$A6EA,$0002,$A6FA,$0002,$A706
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
	beq.w	.next2
	addi.w	#$1,$1A8B6.l
	move.w	$1A8B6.l,d0
	asl.w	#$2,d0
	movea.l	#$2A6C2,a0
	move.w	$1A8B4.l,d1
	asl.w	#$2,d1
	movea.l	(a0,d1.w),a0
	move.w	(a0,d0.w),$1A8B8.l
	btst	#$0,$76(a3)
	beq.w	.next
	neg.w	$1A8B8.l
.next	move.w	$2(a0,d0.w),$1A8BA.l
	cmpi.b	#$80,$4(a0,d0.w)
	bne.w	.next2
	bset	#$3,$17F7A.l
	clr.w	$1A8BE.l
	move.b	$5(a0,d0.w),$1A8BF.l
	move.w	$6(a0,d0.w),$1A8BC.l
.next2	movem.l	(sp)+,d0-d7/a0-a6
	rts
	movem.l	d2-d7/a0-a6,-(sp)
	cmpi.b	#$80,$1A8B8.l
	beq.w	.next11
	move.w	$1A8B8.l,d0
	move.w	$1A8BA.l,d1
	btst	#$7,$62(a3)
	bne.w	.next3
	neg.w	d0
	neg.w	d1
.next3	sub.w	$0(a3),d0
	bpl.w	.next4
	neg.w	d0
.next4	tst.w	$28(a3)
	bne.w	.next5
	tst.w	$2A(a3)
	bne.w	.next5
	cmpi.w	#$12,d0
	ble.w	.next6
.next5	cmpi.w	#$A,d0
	bgt.w	.next10
.next6	sub.w	$14(a3),d1
	bpl.w	.next7
	neg.w	d1
.next7	tst.w	$28(a3)
	bne.w	.next8
	tst.w	$2A(a3)
	bne.w	.next8
	cmpi.w	#$12,d1
	ble.w	.next9
.next8	cmpi.w	#$A,d1
	bgt.w	.next10
.next9	bsr.w	NextPathPoint
.next10	move.w	$1A8B8.l,d0
	move.w	$1A8BA.l,d1
.next11	movem.l	(sp)+,d2-d7/a0-a6
	rts
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#$1,$17F78.l
	beq.w	.next17
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	bne.w	.next17
	cmpi.w	#$3,$193B6.l
	ble.w	.next16
	cmpi.b	#$80,$1A8B8.l
	beq.w	.next16
	btst	#$3,$17F7A.l
	bne.w	.next12
	tst.w	$17BA8.l
	bne.w	.next17
	tst.w	$17BAA.l
	bne.w	.next17
	cmpi.w	#$F,$193B6.l
	blt.w	.next16
	bra.w	.next17
.next12	move.w	$1A8B8.l,d0
	move.w	$1A8BA.l,d1
	btst	#$7,$62(a3)
	bne.w	.next13
	neg.w	d0
	neg.w	d1
.next13	sub.w	$0(a3),d0
	bpl.w	.next14
	neg.w	d0
.next14	sub.w	$14(a3),d1
	bpl.w	.next15
	neg.w	d1
.next15	cmp.w	$1A8BE.l,d0
	bgt.w	.next17
	cmp.w	$1A8BE.l,d1
	bgt.w	.next17
.next16	clr.w	d0
	bra.w	.next18
.next17	move.w	#$1,d0
.next18	movem.l	(sp)+,d0-d7/a0-a6
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
	beq.s	.next
	movea.l	$47DA8.l,a2
	bra.s	.next2
.next	movea.l	$47D90.l,a2
.next2	adda.w	#$8,a2
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
	ble.w	.next
	move.w	d2,d7
	move.w	d1,d0
.next	dbra	d1,.loop
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
RandomFaceoffAnimTbl1	dc.w	$0003,$0005,$0003,$0001,$0005,$0002,$0003,$0003
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
	bne.w	.next2
	move.w	$17E62.l,d1
	movea.l	#$1AD46,a0
	tst.w	d4
	beq.w	.next
	movea.l	#$1AD4E,a0
.next	addi.l	#$1,(a0)
	cmpi.w	#$8,d1
	beq.w	.next2
	cmp.w	$54(a3),d1
	beq.w	.next2
	addi.l	#$1,$4(a0)
.next2	movem.l	(sp)+,d1/a0
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
	jsr	(PushNumberWidthString).l
	String	')'
	movea.l	#TempBuffer,a1
PlayedByExit
	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
PlayedByExitTbl1	dc.b	$00,$0E,'(played by ',$00,$00,$02
PlayedByNone
	movea.l	#$2AE4E,a1
	bra.w	PlayedByExit
PlayedByAway						;As PlayedByHome for awayuser. Called from UpdateScoutingDisplay
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	$18BF6.l,d0
	bra.w	PlayedByText
	bra.w	.next
	dc.w	$08B9,$0001,$0001,$7F7C,$6000,$000A
.next
	bset	#$1,$17F7C.l
	rts
AttribAdjust						;An attribute under $32 becomes d0 / 2 + $19. Called from AttribRating,
	
	cmpi.w	#$32,d0
	bge.w	.ex
	asr.w	#$1,d0
	addi.w	#$19,d0
.ex	rts
	dc.w	$48A7,$C000,$3039,$0001,$7B80,$906B,$0000,$0C40
	dc.w	$001E,$6E00,$0030,$3239,$0001,$7BA8,$B340,$0240
	dc.w	$8000,$6700,$0020,$3039,$0001,$7B94,$906B,$0014
	dc.w	$0C40,$001E,$6E00,$000E,$3239,$0001,$7BAA,$B340
	dc.w	$0240,$8000,$4C9F,$0003,$4E75
ReadGoaliePulled						;Z clear when the team of a3 pulled its goalie ($26 of the team struct).
	
	movem.l	a1,-(sp)
	movea.l	#tmstruct,a1
	btst	#$6,$62(a3)
	beq.w	.next
	movea.l	#awtmstruct,a1
.next	tst.w	$28(a1)
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
	bpl.w	.next
	jsr	(assexit).l
	bra.w	.next2
.next	jsr	(Setplass).l
.next2	clr.w	$5A(a3)
	st.b	$5C(a3)
	move.w	(sp)+,d1
	movem.l	(sp)+,d0/a0
	rts
;	Team logo palettes, then LeadSong, ClearPenalties and the hot/cold icon.
;	New in 94. ROM-contiguous from TeamLogoPalettes through HotColdIcon.

TeamLogoPalettes					;Team logo palettes, 16 colors per team. Used by PeriodStatsScreen,
									;ClearCardText, DrawMatchupLogo and DrawTeamLogo
									;24 are the matchup logo palettes of TeamPalettes and incbin those files;
									;BOS, FLA, HFD and SJ differ and have their own
		dc.w	$0EEA,$0000,$0042,$0EEA		;ANH, the TeamPalettes matchup logo palette
	dc.w	$0EEA,$0EEE,$0000,$0888
	dc.w	$0AAA,$0068,$008A,$00CE
	dc.w	$0260,$0040,$0664,$0E8E
		dc.w	$0EE8,$008C,$0000,$0A0A		;BOS: differs from MatchupPalBOSA.pal
	dc.w	$0A0A,$0EEE,$0000,$0C8C
	dc.w	$008C,$0888,$0068,$0846
	dc.w	$0044,$0422,$08CE,$02AE
		dc.w	$0EE8,$0822,$008C,$0EE8		;BUF, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0EC8
	dc.w	$048C,$0C88,$006C,$0866
	dc.w	$0268,$0224,$0620,$00CE
		dc.w	$0EE8,$0006,$008C,$0EE8		;CGY, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$08EE
	dc.w	$02CE,$02AE,$026E,$000C
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0000,$0006,$0EE8		;CHI, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$08EE
	dc.w	$0A8E,$04AC,$0A88,$046C
	dc.w	$0226,$0644,$022E,$0262
		dc.w	$0EE8,$0000,$0042,$0EE8		;DAL, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$08AA
	dc.w	$0688,$0488,$0466,$0244
	dc.w	$0260,$0020,$0ACC,$0000
		dc.w	$0EE8,$0006,$0006,$0EE8		;DET, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0C8E
	dc.w	$086E,$044E,$082E,$020E
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0600,$004A,$0EE8		;EDM, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0CEA
	dc.w	$0A8E,$08A8,$044E,$0488
	dc.w	$002E,$0440,$0400,$0EE8
		dc.w	$0E0E,$0000,$008C,$0EE8		;FLA: differs from MatchupPalFLAA.pal
	dc.w	$0EE8,$0EEE,$0000,$0E00
	dc.w	$0400,$0600,$000E,$000A
	dc.w	$0288,$0266,$02AA,$0CCC
		dc.w	$0EE8,$0042,$0822,$0EE8		;HFD: differs from MatchupPalHFDA.pal
	dc.w	$0EE8,$0EEE,$0000,$0020
	dc.w	$0040,$0A8A,$0020,$0466
	dc.w	$0200,$0224,$0888,$0422
		dc.w	$0EE8,$0000,$0000,$0EE8		;LA, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$0888,$0666,$0444,$0222
	dc.w	$0CCC,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0600,$0006,$0EE8		;MTL, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$088E
	dc.w	$026E,$0C68,$002E,$0A24
	dc.w	$0EAA,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0020,$0006,$0EE8		;NJ, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$000A,$0888,$000C,$0022
	dc.w	$0006,$0CCC,$0EE8,$0EE8
		dc.w	$0EE8,$0822,$004A,$0EE8		;NYI, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0AA8
	dc.w	$066E,$0864,$022C,$062A
	dc.w	$0008,$0622,$0222,$0A8E
		dc.w	$0EE8,$0600,$0006,$0EE8		;NYR, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$0C86,$002E,$0C60,$0844
	dc.w	$0444,$0840,$0008,$0EC8
		dc.w	$0EE8,$0006,$006A,$0EE8		;OTW, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$068A
	dc.w	$0688,$0466,$0244,$022C
	dc.w	$0228,$0008,$0AAA,$0004
		dc.w	$0EE8,$0000,$004A,$0EE8		;PHI, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0CCC
	dc.w	$088E,$0AAA,$046E,$006E
	dc.w	$0888,$0666,$002E,$0444
		dc.w	$0EE8,$0000,$008C,$0EE8		;PIT, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$088A,$066A,$04EE,$0464
	dc.w	$0440,$02CE,$0244,$0AEE
		dc.w	$0EE8,$0600,$0006,$0EE8		;QUE, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0C00
	dc.w	$000E,$0E44,$0ECE,$0E80
	dc.w	$088E,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0000,$0822,$0EE8		;SJ: differs from MatchupPalSJA.pal
	dc.w	$0EE8,$0EEE,$0000,$0860
	dc.w	$0642,$0888,$0CA8,$0ACC
	dc.w	$02AE,$006E,$0048,$046A
		dc.w	$0EE8,$0822,$006A,$0EE8		;STL, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0602
	dc.w	$024C,$0002,$0026,$0068
	dc.w	$0428,$086E,$0EE8,$0EE8
		dc.w	$0EE8,$0000,$0600,$0EE8		;TB, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0C86
	dc.w	$0E84,$0A84,$0C44,$0822
	dc.w	$0E20,$0600,$0A00,$0EA8
		dc.w	$0EE8,$0600,$0600,$0EE8		;TOR, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0ECA
	dc.w	$0AAA,$0C66,$0822,$0CCC
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0000,$008C,$0EE8		;VAN, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$00CE
	dc.w	$006A,$004E,$0028,$0022
	dc.w	$0020,$008E,$0888,$06CE
		dc.w	$0EE8,$0006,$0600,$0EE8		;WSH, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$022C
	dc.w	$0C86,$0EA8,$088E,$0842
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0600,$0006,$0EE8		;WPG, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$022C
	dc.w	$0422,$0AAC,$0666,$0CAA
	dc.w	$0444,$066E,$08CE,$0226
		dc.w	$0EE8,$0006,$006A,$0EE8		;ASE, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$0888,$0684,$0444,$022C
	dc.w	$0008,$0880,$0660,$0440
		dc.w	$0EE8,$0006,$006A,$0EE8		;ASW, the TeamPalettes matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$0888,$0466,$0444,$022C
	dc.w	$0008,$0400,$0800,$0C00
L2B2D6	movem.l	d0/a0-a3,-(sp)
	move.w	$17F6C.l,-(sp)
	btst.b	#$1,$17F78.l
	dc.w	$6600,$00B2
	movea.l	#$1834C,a2
	lea.l	$366(a2),a3
	move.w	$26(a2),d0
	sub.w	$26(a3),d0
	dc.w	$6700,$009C
	bpl.w	.next
	btst.b	#$6,$17F6C.l
	bne.w	.next2
	bsr.w	L2B392
	bset.b	#$6,$17F6C.l
	bra.w	.next2
.next	exg.l	a2,a3
	btst.b	#$6,$17F6C.l
	beq.w	.next2
	bsr.w	L2B392
	bclr.b	#$6,$17F6C.l
.next2	bset.b	#$5,$17F6C.l
	dc.w	$6600,$0056
	cmpa.l	#$1834C,a3
	bne.w	.next3
	move.w	$17FAE.l,$1A56C.l
	move.w	#$1,$1A56E.l
	jsr	$2A478.l
	bset.b	#$6,$17F7C.l
	dc.w	$6000,$0028
.next3	move.w	$17FAE.l,$1A56C.l
	move.w	#$4,$1A56E.l
	jsr	$2A478.l
	dc.w	$6000,$FFDA
L2B392	bclr.b	#$5,$17F6C.l
	rts
	move.w	(sp)+,$17F6C.l
	movem.l	(sp)+,d0/a0-a3
	rts
ClearPenalties						;Clear the penalties: PBnum, Penaltytimer, PenCntDwn, PenBuf and both
									;teams' penalty slots (clrTmPdst). Called from clockcont_0
	movem.l	d0/a0,-(sp)
	clr.w	$18068.l
	clr.w	$18066.l
	clr.w	$18064.l
	move.w	#$10,d0
	movea.l	#$18022,a0
.loop	clr.l	(a0)+
	dbra	d0,.loop
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
.loop	move.w	#$FFFE,(a0)+		;-2 = bench
	dbra	d0,.loop
	move.w	#$FFFF,(a0)
	rts
