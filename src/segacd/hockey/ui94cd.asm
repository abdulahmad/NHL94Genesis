UnpackPicture						;Unpack a picture a2: count.w, then 3 bytes per row of 8 pixels to 4 bit
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#picturebuf,a0
	movea.l	#picturebits,a1
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
; Picks the picture graphics for the current side and decompresses them.
UnpackPictureSelectGfx
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
; Prints the opening bracket text before a team graphics entry.
TeamGfxListEndPrintA
	movem.l	d0/a2,-(sp)
	jsr	(printz).l
	String	' ('
	adda.w	#$D0,a2
	bra.w	PrintParenNumber
; Prints the opening bracket text before a team graphics entry (second form).
TeamGfxListEndPrintB
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
	
	
	
	
	cmpi.w	#$193E,SPA(a3)
	beq.w	.12
	cmpi.w	#$1A00,SPA(a3)
	beq.w	.8
	cmpi.w	#$18CC,SPA(a3)
	beq.w	.10
	cmpi.w	#$17E8,SPA(a3)
	beq.w	.6
	cmpi.w	#$1776,SPA(a3)
	beq.w	.0
	cmpi.w	#$185A,SPA(a3)
	beq.w	.3
	bra.w	.x
.0	move.w	#$124,d0
	cmpi.w	#$56,(FallXPos).l
	bgt.w	.1
	cmpi.w	#$FFAA,(FallXPos).l
	bgt.w	.2
.1	move.w	#$116,d0
.2	sub.w	Ypos(a3),d0
	bmi.w	.x
	asr.w	#$1,d0
	add.w	d0,Ypos(a3)
	bra.w	.x
.3	move.w	#$FEDC,d0
	cmpi.w	#$56,(FallXPos).l
	bgt.w	.4
	cmpi.w	#$FFAA,(FallXPos).l
	bgt.w	.5
.4	move.w	#$FEEA,d0
.5	sub.w	Ypos(a3),d0
	bpl.w	.x
	asr.w	#$1,d0
	add.w	d0,Ypos(a3)
	bra.w	.x
.6	move.w	#$82,d0
	btst	#$3,attribute(a3)
	beq.w	.7
	move.w	#$FF7E,d0
.7	sub.w	$0(a3),d0
	asr.w	#$1,d0
	add.w	d0,$0(a3)
	bra.w	.x
.8	move.w	#$88,d0
	btst	#$3,attribute(a3)
	beq.w	.9
	move.w	#$FF78,d0
.9	sub.w	$0(a3),d0
	asr.w	#$1,d0
	add.w	d0,$0(a3)
	bra.w	.x
.10	move.w	#$FF7E,d0
	btst	#$3,attribute(a3)
	beq.w	.11
	move.w	#$82,d0
.11	sub.w	$0(a3),d0
	asr.w	#$1,d0
	add.w	d0,$0(a3)
	bra.w	.x
.12	move.w	#$FF78,d0
	btst	#$3,attribute(a3)
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
	move.b	crpeak(a0),d2
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
	move.b	fighting(a2),d0
	lsr.w	#$2,d0
	rts
; Return point of getFgtbyte.
GetFgtByteReturn
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
	cmpi.w	#$FFC0,(fox).l
	bgt.w	.x
	cmpi.w	#$C0,(foy).l
	bgt.w	.x
	move.w	#$6,d0
.x	movem.l	(sp)+,a0
	rts
; Data that follows RandomFaceoffAnim (strings, small tables)
RandomFaceoffAnimData	dc.w	$0003,$0005,$0003,$0001,$0005,$0002,$0003,$0003
	dc.w	$FFFF
CheckScoreLeader						;Compare tmap (players on ice) of tmstruct / awtmstruct and test tmteam of
	
	
	movem.l	d0-d2/a0-a2,-(sp)
	movea.l	#tmstruct,a0
	movea.l	#awtmstruct,a1
	move.w	tmap(a0),d0
	sub.w	tmap(a1),d0
	beq.w	.x
	bpl.w	.0
	exg.l	a0,a1
.0	cmpi.w	#$13,tmteam(a0)
	bne.w	.x
.x	movem.l	(sp)+,d0-d2/a0-a2
	rts
DrawPlayoffSprite						;The StanleyCupSprite sprite at playoffspritex / playoffspritey in Satt,
	
	
	movea.l	#$BBD30,a6
	moveq	#$1,d6
	movea.l	$47D94.l,a0
	move.w	(energybarchars).l,d3
	ori.w	#$8000,d3
	move.w	(playoffspritex).l,d0
	move.w	(playoffspritey).l,d1
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
	move.w	d0,(Sattsize).l
	rts
GetTeamStruct						;a2 = tmstruct, or awtmstruct when team d2 is not tmteam of tmstruct.
	
	movea.l	#tmstruct,a2
	cmp.w	tmteam(a2),d2
	beq.w	.x
	movea.l	#awtmstruct,a2
.x	rts
; Counts a stat for the team at a0 in the running totals.
GetTeamStructCount
	movem.l	d1/a0,-(sp)
	btst	#$0,(gmode).l
	bne.w	.next2
	move.w	(TempWord1).l,d1
	movea.l	#homepresses,a0
	tst.w	d4
	beq.w	.next
	movea.l	#awaypresses,a0
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
	movea.l	#lognametext,a1
	bsr.w	GetLogName
	move.w	(namelength).l,d0
	move.b	#$0,(a1,d0.w)
	addi.w	#$1,d0
	andi.w	#$FFFE,d0
	move.w	d0,-$2(a1)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PlayedByHome						;a1 = String "(played by NAME)" for homeuser (GetLogName name), or an
	
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	(homeuser).l,d0
PlayedByText						;PlayedByHome / PlayedByAway body
	tst.w	d0
	beq.w	PlayedByNone
	movea.l	#$1A37E,a1
	move.w	d0,(namelogsel).l
	bsr.w	GetLogName
	adda.w	(namelength).l,a1
	move.b	#$0,(a1)
	addi.w	#$1,(namelength).l
	andi.w	#$FFFE,(namelength).l
	addi.w	#$2,(namelength).l
	move.w	(namelength).l,(nameentrybuf).l
	movea.l	#nameentrybuf,a1
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
; Data that follows PlayedByExit (strings, small tables)
PlayedByExitData	dc.b	$00,$0E,'(played by ',$00,$00,$02
PlayedByNone
	movea.l	#$2AE4E,a1
	bra.w	PlayedByExit
PlayedByAway						;As PlayedByHome for awayuser. Called from UpdateScoutingDisplay
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	(awayuser).l,d0
	bra.w	PlayedByText
; Clears flag 1 of $17F7C (played by the away side).
PlayedByAwayClearFlag
	bra.w	.next
	bclr.b	#$1,(sflags8).l
	dc.w	$6000,$000A		; bra.w X_2AE80
.next
	bset	#$1,(sflags8).l
	rts