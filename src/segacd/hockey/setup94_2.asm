setupice_highlight
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(forceblack).l
	bclr	#$0,$17F6A.l
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	clr.w	$17CEE.l
	clr.w	$17CEA.l
	move.w	#$7D0,$17CEC.l
	st.b	$17CE2.l
	move.w	$18D54.l,d4
	bsr.w	CopyTeamBlockMapDataFill
	bsr.w	setupIceRinkPal
	btst	#$1,$17F68.l
	beq.w	.next
	movea.l	#$17480,a3
	moveq	#$B,d0
.loop	bchg	#$7,$62(a3)
	adda.w	#$80,a3
	dbra	d0,.loop
.next	bsr.w	CopyTeamLinesCheckTeam
	move.w	#$FFFF,$17DC8.l
	move.w	#$FFFF,$17DD6.l
	clr.l	$17DCA.l
	clr.l	$17DCE.l
	clr.l	$17DD2.l
	st.b	$17F9E.l
	st.b	$17FA0.l
	bsr.w	SetupIceRinkPalRemap
	movea.l	#$18D6A,a5
	movea.l	#$BBD30,a6
	moveq	#$1,d6
	movea.l	#$17D04,a3
	clr.w	d0
	clr.w	d1
	bsr.w	addframe2
	adda.w	#$1C,a3
	bsr.w	addframe2
	adda.w	#$1C,a3
	bsr.w	addframe2
	adda.w	#$1C,a3
	bsr.w	addframe2
	adda.w	#$1C,a3
	bsr.w	addframe2
	adda.w	#$1C,a3
	bsr.w	addframe2
	move.l	a5,$191CA.l
	bsr.w	dodmalist
	move.w	#$1C,(palcount).l
	move.w	(sp)+,(disflags).l
	move.l	#SetupIceVBlankHandler,(VBint).l
	bclr	#$0,(disflags).l
	bclr	#$2,(disflags).l
	bset	#$5,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
setupIceRinkPal
	movea.l	$47D18.l,a0
	adda.l	(a0),a0
	moveq	#$F,d0
	movea.l	#$BBCB0,a1
.loop	move.l	(a0)+,(a1)+
	dbra	d0,.loop
	rts
; Decompresses the rink palette with remap.
SetupIceRinkPalRemap
	move.w	$18D50.l,d4
	movea.l	$47D4C.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsWithRemap
	dc.w	$7123,$4567,$89AB,$CDEF,$4E75,$3839,$0001,$8D46
	dc.w	$2479,$0004,$7D40,$508A,$6000,$9CB4,$3839,$0001
	dc.w	$8D4A,$2479,$0004,$7D2C,$508A,$6000,$9CA2
	move.w	$18D56.l,d4
	movea.l	$47D20.l,a2
	addq.l	#$8,a2
	bra.w	DecompressGraphicsPlain
	move.w	$18D56.l,d4
	movea.l	$47D1C.l,a2
	addq.l	#$8,a2
	bra.w	DecompressGraphicsPlain
	move.w	$18D4C.l,d4
	movea.l	$47D30.l,a2
	addq.l	#$8,a2
	bra.w	DecompressGraphicsPlain
	move.w	$18D56.l,d4
	movea.l	$47D14.l,a2
	addq.l	#$8,a2
	bra.w	DecompressGraphicsPlain
setupTeamBlocksMap						;Load the TeamBlocks map tiles (Teamblocksmap) at d4+$2C and copy the home
	
	
	move.w	d4,$18D52.l
	addi.w	#$2C,d4
	movea.l	#$17FB2,a1
	movea.l	$47D44.l,a0
	lea.l	$8(a0),a2
	bsr.w	DecompressGraphicsPlain
	adda.l	$4(a0),a0
	move.l	a0,-(sp)
	move.w	(HomeTeam).l,d0
	move.w	$18D52.l,d1
	asl.w	#$5,d1
	bsr.w	CopyTeamBlockMapData
	movea.l	(sp)+,a0
	move.w	(VisTeam).l,d0
	move.w	$18D52.l,d1
	addi.w	#$16,d1
	asl.w	#$5,d1
	bsr.w	CopyTeamBlockMapData
	move.w	$18D52.l,d4
	addi.w	#$2C,d4
	rts
CopyTeamBlockMapData						;Copy one team's 22 block chars from the loaded tile set to vram at d1 by
	
	
	mulu.w	#$2C,d0
	lea.l	$4(a0,d0.w),a0
	move.w	#$15,d3
.row	moveq	#$20,d0
	move.w	d1,-(sp)
	move.b	(a0),(a1)
	andi.w	#$F800,(a1)
	lsr.w	#$5,d1
	ori.w	#$8000,d1
	or.w	d1,(a1)+
	move.w	(sp)+,d1
	move.w	(a0)+,d2
	andi.w	#$7FF,d2
	add.w	$18D52.l,d2
	addi.w	#$2C,d2
	asl.w	#$5,d2
	bsr.w	DoDMA_nd2
	addi.w	#$20,d1
	dbra	d3,.row
	rts
; Fills the four map entries from the table at $3EE08.
CopyTeamBlockMapDataFill
	movea.l	#$3EE08,a2
	movea.l	#$17DD8,a3
	moveq	#$3,d0
.loop	move.w	#$FFFF,$8(a3)
	move.w	(a2)+,$0(a3)
	move.w	(a2)+,$2(a3)
	move.w	(a2)+,$6(a3)
	move.w	(a2)+,$4(a3)
	move.w	d4,$12(a3)
	add.w	(a2)+,d4
	adda.w	#$14,a3
	dbra	d0,.loop
	movea.l	#$3EE30,a2
	movea.l	#$17D04,a3
	move.l	#$6,d0
.loop2	st.b	$8(a3)
	move.w	(a2)+,$0(a3)
	move.w	(a2)+,$14(a3)
	move.w	(a2)+,$18(a3)
	move.w	(a2)+,$6(a3)
	move.w	(a2)+,$4(a3)
	move.w	d4,$12(a3)
	add.w	(a2)+,d4
	adda.w	#$1C,a3
	dbra	d0,.loop2
	bra.w	SortObjectsInit
; Start of defaultsprites
defaultspritesStart						;objects which are tied to screen scrolling and have velocity: the 16
	
	
	ori.b	#$0,d0
	ori.b	#$0,d0
	dc.w	$0009,$0000,$0000,$0000,$0000,$0009,$0000,$0000
	dc.w	$0000,$0000,$0009,$0000,$0000,$0000,$0000,$0009
; Data that follows defaultsprites (strings, small tables)
defaultspritesData	dc.w	$0000,$0000,$FFFF,$0188,$0000,$0007,$0000,$0000
	dc.w	$FFFF,$0186,$0000,$0007,$0000,$0000,$FFFF,$0187
	dc.w	$0000,$0007,$0000,$0000,$FFFF,$0189,$8000,$0007
	dc.w	$0000,$0000,$FFFF,$034C,$0000,$0007,$0000,$0000
	dc.w	$FFFF,$034D,$0000,$0007,$0000,$0000,$FFFF,$0161
	dc.w	$0000,$0005
; Sets up the 16 sort objects from .list
SortObjectsInit
	clr.w	d6
	movea.l	#$17CC0,a1
	lea	.list(pc),a2
	movea.l	#$17480,a3
	movea.l	#$17CA0,a4
.loop	moveq	#$1F,d0
	movea.l	a3,a0
.loop2	clr.l	(a0)+
	dbra	d0,.loop2
	move.w	d6,$52(a3)
	st.b	$8(a3)
	st.b	$66(a3)
	move.w	(a2)+,$0(a3)
	move.w	(a2)+,$14(a3)
	move.w	(a2)+,$18(a3)
	move.w	(a2)+,$6(a3)
	move.w	(a2)+,$4(a3)
	move.w	d4,$12(a3)
	add.w	(a2)+,d4
	move.w	(a2)+,$4A(a3)
	move.w	(a2)+,$4C(a3)
	adda.w	#$1,a2
	move.b	(a2)+,$38(a3)
	adda.w	#$1,a2
	move.b	(a2)+,$62(a3)
	adda.w	#$80,a3
	asl.w	#$1,d6
	move.b	d6,(a1)+
	lsr.w	#$1,d6
	move.w	d6,(a4)+
	addq.w	#$1,d6
	cmpi.w	#$10,d6
	bne.w	.loop
	bra.w	SprSort
.list								;start values of the 16 sort objects
	dc.w	$180					;xcord,ycord,zcord,frame,att,crsize,radx,rady,asslist,pflags home team
	dc.w	$C0
	dc.w	0
	dc.w	1
	dc.w	0
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$80
	dc.w	$FF38					;home player 2
	dc.w	$FF9C
	dc.w	0
	dc.w	1
	dc.w	0
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$80
	dc.w	$FF38					;home player 3
	dc.w	$FFB0
	dc.w	0
	dc.w	1
	dc.w	0
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$80
	dc.w	$FF38					;home player 4
	dc.w	$FFC4
	dc.w	0
	dc.w	1
	dc.w	0
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$80
	dc.w	$FF38					;home player 5
	dc.w	$FFD8
	dc.w	0
	dc.w	1
	dc.w	0
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$80
	dc.w	$FF38					;home player 6
	dc.w	$FFEC
	dc.w	0
	dc.w	1
	dc.w	0
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$80
	dc.w	$C0						;visitor team
	dc.w	$C0
	dc.w	0
	dc.w	1
	dc.w	1
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$40
	dc.w	$FF38					;visitor player 2
	dc.w	$28
	dc.w	0
	dc.w	1
	dc.w	1
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$40
	dc.w	$FF38					;visitor player 3
	dc.w	$3C
	dc.w	0
	dc.w	1
	dc.w	1
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$40
	dc.w	$FF38					;visitor player 4
	dc.w	$50
	dc.w	0
	dc.w	1
	dc.w	1
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$40
	dc.w	$FF38					;visitor player 5
	dc.w	$64
	dc.w	0
	dc.w	1
	dc.w	1
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$40
	dc.w	$FF38					;visitor player 6
	dc.w	$78
	dc.w	0
	dc.w	1
	dc.w	1
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$40
	dc.w	0						;goal net
	dc.w	$10C
	dc.w	0
	dc.w	SPFgoal					;92 used $18E
	dc.w	0
	dc.w	$B
	dc.w	$14
	dc.w	6
	dc.w	0
	dc.w	0
	dc.w	0						;goal net 2
	dc.w	$FEF4
	dc.w	0
	dc.w	SPFgoal+1
	dc.w	0
	dc.w	$11
	dc.w	$14
	dc.w	6
	dc.w	0
	dc.w	0
	dc.w	0						;puck
	dc.w	0
	dc.w	0
	dc.w	SPFpuck+1
	dc.w	0
	dc.w	1
	dc.w	5
	dc.w	5
	dc.w	$18
	dc.w	1
	dc.w	0						;puck shadow
	dc.w	0
	dc.w	0
	dc.w	SPFpuck					;92 used $183, 4 chars
	dc.w	0
	dc.w	$11
	dc.w	3
	dc.w	3
	dc.w	$19
	dc.w	4
SprSort						;sort objects in struct SortObj and set corresponding tables for keeping
									;them sorted later (Ylist, OOlist, OOlistpos)
	movem.l	d0-d4/a0-a2,-(sp)
	movea.l	#$17CA0,a2
	movea.l	#$17C80,a1
	movea.l	#$17480,a0
	move.w	#$F,d3
.loop	move.w	$14(a0),d4
	btst	#$7,$17F6A.l
	beq.w	.next
	move.w	$0(a0),d4
.next	move.w	d4,(a1)+
	adda.w	#$80,a0
	dbra	d3,.loop
	movea.l	#$17C80,a1
.loop2	clr.w	d4
	movea.l	#$17CC0,a0
	move.w	#$E,d3
	clr.w	d0
	clr.w	d1
.loop3	move.b	(a0)+,d0
	move.b	(a0),d1
	move.w	(a1,d0.w),d2
	cmp.w	(a1,d1.w),d2
	ble.w	.next2
	move.b	d0,(a0)
	move.b	d1,-$1(a0)
	move.l	a0,d2
	subi.l	#$17CC0,d2
	move.w	d2,(a2,d0.w)
	subq.w	#$1,d2
	move.w	d2,(a2,d1.w)
	st.b	d4
.next2	dbra	d3,.loop3
	tst.w	d4
	bne.w	.loop2
	movem.l	(sp)+,d0-d4/a0-a2
	rts
resetplstuff
	movem.l	d0-d2/a0-a3,-(sp)
	movea.l	#tmstruct,a2
	bsr.w	.next
	movea.l	#awtmstruct,a2
	bsr.w	.next
	movem.l	(sp)+,d0-d2/a0-a3
	rts
.next	bclr	#$4,$32(a2)
	moveq	#$5,d2
	movea.l	$22(a2),a3
.loop	clr.b	$63(a3)
	tst.w	$34(a3)
	bmi.w	.next2
	move.w	#$50C,d1
	jsr	(SetSPA).l
	clr.w	$32(a3)
	clr.b	$5E(a3)
	andi.b	#$C2,$62(a3)
.next2	adda.w	#$80,a3
	dbra	d2,.loop
	rts
clearTeamStats						;clear both team structs (2 x tmsize) but keep each hot / cold table
	
	
	
	move.w	$18374.l,-(sp)
	move.w	$186DA.l,-(sp)
	movem.l	a1-a3,-(sp)
	move.w	#$19F,d0
	movea.l	#$18856,a1
	movea.l	#$184F0,a0
	movea.l	#$1A574,a2
	movea.l	#$1A714,a3
.loop	move.b	(a0)+,(a2)+
	move.b	(a1)+,(a3)+
	dbra	d0,.loop
	movem.l	(sp)+,a1-a3
	move.l	#$365,d0
	movea.l	#tmstruct,a0
.loop2	clr.b	(a0)+
	dbra	d0,.loop2
	movea.l	#awtmstruct,a0
	move.w	#$365,d0
.loop3	clr.b	(a0)+
	dbra	d0,.loop3
	movem.l	a1-a3,-(sp)
	move.w	#$19F,d0
	movea.l	#$18856,a1
	movea.l	#$184F0,a0
	movea.l	#$1A574,a2
	movea.l	#$1A714,a3
.loop4	move.b	(a2)+,(a0)+
	move.b	(a3)+,(a1)+
	dbra	d0,.loop4
	movem.l	(sp)+,a1-a3
	move.w	(sp)+,$186DA.l
	move.w	(sp)+,$18374.l
	st.b	$183E8.l
	st.b	$1874E.l
setteams						;Use hometeam/visteam to set team structures (InitTeamStructure for each).
	
	movem.l	d0/a0-a2,-(sp)
	movea.l	#tmstruct,a2
	move.w	(HomeTeam).l,d0
	move.l	#$17480,$22(a2)
	bsr.w	.next
	movea.l	#awtmstruct,a2
	move.w	(VisTeam).l,d0
	move.l	#$17780,$22(a2)
	bsr.w	.next
	movem.l	(sp)+,d0/a0-a2
	rts
.next	move.w	d0,$2A(a2)
	movea.l	#TeamList,a0
	asl.w	#$2,d0
	move.l	(a0,d0.w),$1E(a2)
CopyTeamLines						;'Set Original lines' (line editor exit menu): copy the team data line
	
	tst.w	$18C0A.l
	beq.w	.0
	movea.l	$1E(a2),a0
	adda.w	$6(a0),a0
	lea.l	$16C(a2),a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	adda.w	#$8,a0
	move.w	#$B,d0
.loop	move.l	(a0)+,(a1)+
	dbra	d0,.loop
	rts
.0	moveq	#$D,d0
	movea.l	$1E(a2),a0
	adda.w	$6(a0),a0
	adda.w	#$8,a0
	lea.l	$16C(a2),a1
.copy	move.l	(a0)+,(a1)+
	dbra	d0,.copy
	rts
; Checks teams for the special team number $13.
CopyTeamLinesCheckTeam
	clr.w	d1
	cmpi.w	#$13,(VisTeam).l
	beq.w	.next
	cmpi.w	#$13,(HomeTeam).l
	beq.w	.next
	bra.w	.next2
.next	move.w	#$860,$BBCDC.l
.next2	movea.l	#tmstruct,a0
	bsr.w	.next3
	moveq	#$20,d1
	adda.w	#$366,a0
.next3	movea.l	$1E(a0),a2
	adda.w	$2(a2),a2
	adda.w	d1,a2
	movea.l	#$BBCF0,a1
	adda.w	d1,a1
	moveq	#$7,d0
.loop	move.l	(a2)+,(a1)+
	dbra	d0,.loop
	rts
GameOver						;EncodePW (save the password), then in playoff mode PlayoffStatsScreen
	
	bsr.w	EncodePW
	tst.w	$18BFA.l
	beq.w	.po
	bclr	#$1,$17F6A.l
	jsr	(PlayoffStatsScreen).l
.po	bsr.w	GameOverCleanup
	tst.w	$191CE.l
	bne.s	.next
	move.w	#$1,ScrollDisplayUpData.l
	bsr.w	ScrollDisplayUpCall
.next	bra.w	.next2
	jsr	$48208.l
.next2
	jsr	$48208.l
	bclr	#$5,$FF800F.l
	movea.l	#$C458,sp
	movea.l	#$1745C,a0
.loop	clr.l	(a0)+
	cmpa.l	#$18BF0,a0
	blt.w	.loop
	move.l	#vb2,(VBint).l
	bset	#$5,$FF800F.l
	jsr	(GameSetUp).l
	jsr	(UserNameEntry).l
	bsr.w	GameOverCleanup
	btst	#$0,$17F78.l
	bne.w	.next3
	jsr	(ScoutingReport).l
.next3	jmp	$2B7F8.l
; Resets scroll state and clears the display request.
GameOverCleanup
	tst.w	$191CE.l
	bne.s	.next
	move.w	#$0,ScrollDisplayUpData.l
	bsr.w	ScrollDisplayUpCall
.next	bclr	#$5,$FF800F.l
	tst.w	$18BFA.l
	beq.w	rtss2
	move.l	#VBlank_Playoff,(VBint).l
	bset	#$5,$FF800F.l
	bclr	#$1,(disflags).l
	move.w	#$0,$18D30.l
	move.w	#$BC00,$18D32.l
	move.w	#$B000,$18D3C.l
	move.w	#$6,$18D3E.l
	move.w	#$C000,$18D38.l
	move.w	#$7,(Map2col).l
	move.w	#$E000,(VmMAP1).l
	move.w	#$7,(Map1col).l
	move.w	#$0,d0
	bsr.w	setVram
	bsr.w	printz
	String	CC_Font1,$0,$0
	move.l	#$80,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	bsr.w	eraser
	bsr.w	printz
	String	CC_Font3,$0,$0
	moveq	#$28,d0
	moveq	#$2,d1
	move.w	#$7FF,d2
	bsr.w	eraser
	bsr.w	AddSmallFontAlt
	bsr.w	AddSmallFont
	movea.l	$47D50.l,a2
	addq.l	#$8,a2
	move.w	d4,$18D56.l
	bsr.w	DecompressGraphicsPlain
	bsr.w	printz
	String	CC_Font2Pal3,$0,$0
	movea.l	(EASportsBGMap).l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	moveq	#$3,d5
	bsr.w	dobitmap
	movea.l	$47D94.l,a1
	lea.l	$8(a1),a2
	adda.l	(a1),a1
	moveq	#$7,d0
	movea.l	#$BBCF0,a0
.loop	move.l	-$40(a0),$20(a0)
	move.l	(a1)+,-$40(a0)
	move.l	-$20(a0),(a0)+
	dbra	d0,.loop
	move.w	#$860,$BBCDC.l
	move.w	#$860,$BBCFC.l
	move.w	d4,$18D46.l
	bsr.w	DecompressGraphicsPlain
	move.w	#$104,$17CE8.l
	move.w	#$A0,$17CE6.l
	movea.l	#$C00004,a0
.loop2	btst	#$7,$FF800E.l
	bne.b	.loop2
	move.w	#$9202,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	beq.b	.loop3
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop4	btst	#$6,$FF800E.l
	bne.b	.loop4
	bclr	#$7,$FF800F.l
	movea.l	#$18AA6,a1
	movea.l	#PlayoffScreen_setup,a0
	move.w	$18A9E.l,d0
	asl.w	#$1,d0
	adda.w	(a0,d0.w),a0
	clr.w	d4
	move.b	(a0)+,d4
.loop5	bsr.w	printz
	String	CC_Font1,$0,$0
	move.b	(a0)+,$18D59.l
	move.b	(a0)+,$18D5B.l
	clr.w	d1
	move.b	(a1)+,d1
	add.w	d1,d1
	bsr.w	PlayoffScreen_doteam
	dbra	d4,.loop5
	clr.w	d4
	move.b	(a0)+,d4
.loop6	bsr.w	printz
	String	CC_Font1,$0,$2
	move.b	(a0)+,$18D59.l
	clr.w	d0
	move.b	(a0)+,d0
	bsr.w	PlayoffScreen_doarrow
	dbra	d4,.loop6
	bsr.w	printz
	String	CC_Font1Pal1,$0,$0
	cmpi.w	#$7,$18A9C.l
	beq.w	.next2
	clr.w	d4
	move.b	(a0)+,d4
	bmi.w	.next2
	movea.l	#$18A18,a2
.loop7	move.b	(a0)+,$18D59.l
	move.b	(a0)+,$18D5B.l
	bsr.w	PlayoffScreen_doscores
	adda.w	#$10,a2
	dbra	d4,.loop7
.next2	bsr.w	printsmallz
	String	CC_SetMapAndPosition,$1,$1,$41,$1A
	dc.w	$43FA,$02AE,$3039,$0001,$8A9E,$6100,$D938,$3011
	dc.w	$E248,$9179,$0001,$8D58,$6100,$9802,$4A79,$0001
	dc.w	$8A9E,$6700,$0020,$6100,$99C4,$001A,$CD0A,$0150
	dc.b	'ress [ or ] to p'
	dc.w	$6167,$6500,$33FC,$0018,$0001,$8D62,$3F3C,$0079
	dc.w	$4EB9,$0003,$71D2,$4240,$4244,$33FC,$FFFF,$0001
	dc.w	$A452,$33FC,$0001,$0001,$A44E,$6100,$0052,$6100
	dc.w	$00C4,$207C,$0003,$C000,$4EB9,$0002,$ACD2,$6100
	dc.w	$0006,$6000,$FFEA,$4EB9,$0003,$74F0,$3F03,$4EB9
	dc.w	$0003,$750E,$865F,$0803,$0007,$6600,$0092,$0803
	dc.w	$0003,$6700,$000A,$33FC,$FFFE,$0001,$A452,$0803
	dc.w	$0002,$6700,$000A,$33FC,$0002,$0001,$A452
PlayoffScreen_scrup						;Move the tree one step (PlayerScrollCtr) and stop on a page boundary
	
	
	
	move.w	(PlayerScrollCtr).l,d0
	beq.w	rtss2
	add.w	(scoutcolumn).l,d0
	move.w	$18A9E.l,d1
	cmpi.w	#$3,d1
	bls.w	.lim
	moveq	#$3,d1
.lim	mulu.w	#$70,d1
	cmp.w	d1,d0
	bgt.w	rtss2
	neg.w	d1
	cmp.w	d1,d0
	blt.w	rtss2
	move.w	d0,(scoutcolumn).l
	clr.w	$17CE4.l
	move.w	d0,d1
	addi.w	#$100,d1
	cmpi.w	#$40,d1
	blt.w	.nox
	cmpi.w	#$200,d1
	bgt.w	.nox
	move.w	d1,$17CE4.l
.nox	ext.l	d0
	divs.w	#$70,d0
	swap	d0
	tst.w	d0
	bne.w	rtss2
	clr.w	(PlayerScrollCtr).l
	rts
	adda.w	#$4,sp
	rts	

waitxc1						;Each time palcount runs out, eor the color
									;word at palfadenew+$42 with $EE and restart palcount at $18; then wait
									;for the next vblank
	tst.w	(palcount).l
	bpl.w	.wait		;palcount still counting
	eori.w	#$EE,$BBCF2.l		;blink the color
	move.w	#$18,(palcount).l		;restart the count
.wait	move.w	(ScoutSubStatus).l,d0		;wait until the vblank handler bumps Vcount
	cmp.w	$17476.l,d0
	beq.w	.wait
	move.w	d0,$17476.l
	rts
PlayoffScreen_doscores						;Print best of 7 wins "t-b" for game struct a2 at printx/printy
	movea.l	#mesarea,a1
	move.w	#$6,(a1)+
	move.w	$4(a2),d0
	addi.w	#$30,d0
	move.b	d0,(a1)+
	move.b	#$2D,(a1)+
	move.w	$6(a2),d0
	addi.w	#$30,d0
	move.b	d0,(a1)+
	clr.b	(a1)+
	movea.l	#mesarea,a1
	bra.w	print
PlayoffScreen_doarrow						;Draw tree arrow d0 from the arrows map (Arrowsmap) at printx/printy
	movem.l	d0-d7/a0-a3,-(sp)
	movea.l	$47D50.l,a0		;a0 = arrows map
	movea.l	a0,a1		;a1 = map header
	adda.l	(a0),a0		;a0 = arrow frames
	adda.l	$4(a1),a1		;a1 = map data
	movea.l	#$1B008,a2
	clr.w	d1
	moveq	#$2,d2
	moveq	#$17,d3
	move.w	$18D56.l,d4
	moveq	#$0,d5
	bsr.w	dobitmap
	movem.l	(sp)+,d0-d7/a0-a3
	rts
PlayoffScreen_doteam						;Draw team block d1 (team*2) from the TeamBlocks map (Teamblocksmap) at
									;printx/printy; the user's team (potreeteam entry of potree) is
									;highlighted (printa $6000)
	movem.l	d0-d7/a0-a3,-(sp)
	movea.l	#$18AA6,a0
	move.w	$18AA0.l,d0
	move.b	(a0,d0.w),d0
	add.b	d0,d0
	cmp.b	d0,d1		;this block?
	bne.w	.nohi
	move.w	#$6000,(printa).l
.nohi	movea.l	$47D44.l,a1		;a1 = map header of the team blocks
	adda.l	$4(a1),a1
	movea.l	#$1B008,a2
	clr.w	d0
	move.w	(a1),d2
	moveq	#$2,d3
	moveq	#$2,d4
	moveq	#$0,d5
	bsr.w	dobitmap
	movem.l	(sp)+,d0-d7/a0-a3
	rts
VBlank_Playoff						;the PlayoffScreen vblank handler (VBint): dma the sprite table, write
									;$FEA0+DispAttribCtr to the hscroll, cramfade. Always Vcount+1,
									;p_music_vblank, rte
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#$2,(disflags).l
	bne.w	.next2
	movea.l	#$BBD30,a0
	move.w	$17F66.l,d0
	beq.w	.next
	clr.w	$17F66.l
	move.w	$18D32.l,d1
	jsr	$378D2.l
	move.w	$18D30.l,d0
	bsr.w	SetVramWriteAddr2
	move.w	#$FEA0,d0
	add.w	(scoutcolumn).l,d0
.loop	btst	#$4,$FF800E.l		;graphics not allowed?
	bne.b	.loop
	move.w	#$31,$FF8026.l		;sprite attribute table
	move.w	d0,$FF8028.l		;size of the table
	bset	#$3,$FF800F.l
.loop2	btst	#$3,$FF800E.l
	beq.b	.loop2
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop3	btst	#$3,$FF800E.l
	bne.b	.loop3
	bclr	#$4,$FF800F.l
.next	jsr	(ForceBlackStep).l
.next2	addq.w	#$1,(ScoutSubStatus).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.b	$00,$0A,'Playoffs',$00,$10,'Quar'
	dc.b	'terfinals',$00,$00,$0C,'Semi'
	dc.b	'finals',$00,$08,'Finals',$00,$0C
	dc.b	'Champions',$00
InitScoutingDisplay						;Start the text player UpdateScoutingDisplay: VertLineScrolling = -1,
									;PlayerScrollCtr = -1, clear SelectedPlayerIdx / ScoutingReportTimer;
									;return a0 =
									;TestList. Called from ScoutingReport
	move.w	#$FFFF,(VertLineScrolling).l
	move.w	#$FF00,(PlayerScrollCtr).l
	clr.w	(SelectedPlayerIdx).l		;TestList index
	clr.w	(ScoutingReportTimer).l
	movea.l	#TestList,a0
	rts
UpdateScoutingDisplay						;Text player for ScoutingReport: prints the ScoutingReportText script
									;word by word with a typing delay (ScoutingReportTimer, longer)
									;after , and .). $D ends a line; special characters ( _ + $ { } [ ] < > |
									;\ @ # % = * ^ ; ) insert team data through the team routines
									;(GetTeamNickname / GetTeamArena for tmstruct / awtmstruct). Line breaks
									;scroll the text box. Called from ScoutingReport
	cmpi.w	#$1000,(ScoutingReportTimer).l		;text finished?
	bgt.w	rtss2		;yes: nothing to do
	tst.w	(asv).l		;button held?
	bmi.w	.0
	subi.w	#$1,(ScoutingReportTimer).l		;count down the delay
	bpl.w	rtss2
.0	movea.l	(ScoutingReportText).l,a1
	moveq	#$0,d0
	move.w	(PlayerScrollCtr).l,d0
	cmpi.w	#$FF00,d0
	bne.w	.3
	clr.w	(scoutcolumn).l
	move.w	(SelectedPlayerIdx).l,d0		;TestList index
	addi.w	#$2,(SelectedPlayerIdx).l
	movea.l	#TestList,a0
	move.w	(a0,d0.w),d0		;this paragraph number
	bpl.w	.1		;not the end of the list
	move.w	#$7FFF,(ScoutingReportTimer).l		;text finished
	move.w	#$1E0,(screentimer).l		;and leave the screen in 480 frames
	rts
.1	bsr.w	ScrollDisplayUp
	move.l	(scoutparaoff).l,d0		;d0 = paragraph offset
.3	lea.l	(a1,d0.l),a2		;a2 = next character
	move.w	#$A,(ScoutingReportTimer).l		;typing delay
	move.w	(scoutcolumn).l,d0
	cmpi.b	#$5F,(a2)
	beq.w	.29
	cmpi.b	#$2B,(a2)
	beq.w	.27
	cmpi.b	#$24,(a2)
	beq.w	.20		;the hotter team's name
	cmpi.b	#$7B,(a2)		;'{' home team name
	beq.w	.29
	cmpi.b	#$7D,(a2)		;'}' away team name
	beq.w	.28
	cmpi.b	#$5B,(a2)		;'[' home player name
	beq.w	.23
	cmpi.b	#$5D,(a2)		;']' away player name
	beq.w	.22
	cmpi.b	#$3C,(a2)
	beq.w	.16		;next home hot player
	cmpi.b	#$3E,(a2)
	beq.w	.17		;next away hot player
	cmpi.b	#$7C,(a2)
	beq.w	.18		;next home cold player
	cmpi.b	#$5C,(a2)
	beq.w	.19		;next away cold player
	cmpi.b	#$40,(a2)
	beq.w	.9		;crowd record
	cmpi.b	#$23,(a2)
	beq.w	.10
	cmpi.b	#$25,(a2)
	beq.w	.11
	cmpi.b	#$3D,(a2)
	beq.w	.12
	cmpi.b	#$2A,(a2)
	beq.w	.13
	cmpi.b	#$5E,(a2)
	beq.w	.14
	cmpi.b	#$3B,(a2)
	beq.w	.15
	move.w	#$FF00,(PlayerScrollCtr).l
	movea.l	#TextBuffer,a0
	clr.w	d1
.loop	cmpi.b	#$21,(a2)
	bne.w	.next
	addq.l	#$3,a2
.next	cmpi.b	#$D,(a2)		;end of line?
	beq.w	.print		;yes: print what we have
	addi.w	#$1,d0
.loop2	move.b	(a2),(a0)+
	addi.w	#$1,d1
	cmpi.b	#$2C,(a2)
	beq.w	.4
	cmpi.b	#$2E,(a2)
	bne.w	.5
.4	addi.w	#$28,(ScoutingReportTimer).l		;longer delay
.5	cmpi.b	#$20,(a2)+		;space ends the word
	bne.w	.loop		;not a space: next character
	cmpi.b	#$20,(a2)		;more spaces?
	beq.w	.next2		;copy them too
	bra.w	.next3
.next2	addi.w	#$14,(ScoutingReportTimer).l
	addq.l	#$1,a2
	bra.w	.loop2
.next3	subi.w	#$1,d0
	cmpa.l	a2,a1
	ble.w	.next4
	move.w	#$FF00,(PlayerScrollCtr).l
	bra.s	.print
.next4	suba.l	a1,a2		;offset into the script
	move.w	a2,(PlayerScrollCtr).l		;offset of the next word
.print	move.w	d1,(mesarea).l
	addi.w	#$2,(mesarea).l		;plus the length word
	btst	#$0,d1		;odd length?
	beq.w	.7
	clr.b	(a0)
	addi.w	#$1,(mesarea).l		;count the pad
.7	movea.l	#mesarea,a1
.loop3	cmpi.w	#$1D,d0		;past column 29?
	ble.w	.8
	bsr.w	ScrollDisplayUp		;wrap to a new line
.8	bsr.w	printz		;map 1 at 9,4
	String	CC_Font1,$9,$4
	move.w	(scoutcolumn).l,d0
	add.w	d0,(printx).l		;x 9 + column
	move.w	(VertLineScrolling).l,d0
	add.w	d0,(printy).l		;y 4 + text line
	bsr.w	print
	add.w	d1,(scoutcolumn).l
	rts
.9	jsr	(ScoutCrowdRecord).l
	bra.w	.append
.10	jsr	(PlayedByHome).l
	bra.w	.append
.11	jsr	(PlayedByAway).l
	bra.w	.append
.12	move.l	a2,-(sp)		;save the script pointer
	movea.l	#tmstruct,a2
	jsr	(GetTeamNickname).l
	movea.l	(sp)+,a2
	bra.w	.append
.13	move.l	a2,-(sp)
	movea.l	#awtmstruct,a2
	jsr	(GetTeamNickname).l
	movea.l	(sp)+,a2
	bra.w	.append
.14	move.l	a2,-(sp)
	movea.l	#tmstruct,a2
	jsr	(GetTeamArena).l
	movea.l	(sp)+,a2
	bra.w	.append
.15	move.l	a2,-(sp)
	movea.l	#awtmstruct,a2
	jsr	(GetTeamArena).l
	movea.l	(sp)+,a2
	bra.w	.append
.16	jsr	(NextHomeHotPlayer).l
	bra.w	.roster		;player d1 of team a1
.17	jsr	(NextAwayHotPlayer).l
	bra.w	.roster		;player d1 of team a1
.18	jsr	(NextHomeColdPlayer).l
	bra.w	.roster		;player d1 of team a1
.19	jsr	(NextAwayColdPlayer).l
	bra.w	.roster		;player d1 of team a1
.20	movea.l	#tmstruct,a1
	tst.w	(awayhotter).l		;away team hotter?
	beq.w	.21
	movea.l	#awtmstruct,a1
.21	movea.l	$1E(a1),a1
	adda.w	$4(a1),a1
	bra.w	.append
.22	movea.l	#awtmstruct,a1
	bra.w	.24
.23	movea.l	#tmstruct,a1
.24	move.w	$28(a1),d1
.roster	movea.l	$1E(a1),a1
	adda.w	$0(a1),a1
	bra.w	.next5
.loop4	adda.w	(a1),a1
	adda.w	#$8,a1		;skip the fixed part
.next5	dbra	d1,.loop4
	bra.w	.append		;a1 = player name
.27	movea.l	(AwayTeamRosterPtr).l,a1
	adda.w	$4(a1),a1
	bra.w	.append
.28	movea.l	(AwayTeamRosterPtr).l,a1
	bra.w	.30
.29	movea.l	(HomeTeamRosterPtr).l,a1
.30	adda.w	$4(a1),a1
.append	addi.w	#$1,(PlayerScrollCtr).l		;go on after the special character
	add.w	(a1),d0		;column + string length - 1
	subi.w	#$1,d0
	move.w	(a1),d1
	subi.w	#$2,d1
	tst.b	$1(a1,d1.w)		;pad byte?
	bne.w	.loop3
	subi.w	#$1,d1		;less the pad byte
	bra.w	.loop3		;print it
ScrollDisplayUp						;Next text line for UpdateScoutingDisplay: VertLineScrolling + 1; at 7
									;lines, scroll the 8 rows up by vram dma (DoDMA_nd2)
	clr.w	(scoutcolumn).l
	addi.w	#$1,(VertLineScrolling).l
	cmpi.w	#$7,(VertLineScrolling).l		;past the box?
	blt.w	rtss2
	subi.w	#$1,(VertLineScrolling).l		;stay on the last line
	movem.l	d0-d3,-(sp)
	moveq	#$7,d3
	move.w	(VmMAP1).l,d1
	addi.w	#$212,d1
.loop	moveq	#$3A,d0
	move.w	d1,d2
	addi.w	#$80,d2		;text box top left
	move.w	sr,-(sp)		;copy 8 rows of the text box up by one row
	move.w	#$2700,sr
	jsr	(DoDMA_nd2).l
	move.w	(sp)+,sr
	move.w	d2,d1
	dbra	d3,.loop
	movem.l	(sp)+,d0-d3
	rts
; Data that follows ScrollDisplayUp (strings, small tables)
ScrollDisplayUpData	dc.w	$0000
; Calls the display helpers and the $6044 routine.
ScrollDisplayUpCall
	jsr	$37598.l
	tst.w	ScrollDisplayUpData.l
	beq.s	.next
	jsr	$376F2.l
.next	move.w	#$D,d7
	jsr	$6044.w
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$0,d0
	jsr	$6044.w
	move.l	a0,(ScoutCDArg).l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	move.w	#$3,d7
	jsr	$6044.w
	movea.l	(ScoutCDArg).l,a0
	move.l	a0,d0
	move.l	(a0)+,(ScoutingReportText).l
	add.l	d0,(ScoutingReportText).l
	move.l	(a0)+,(TeamLogoBitmaps).l
	add.l	d0,(TeamLogoBitmaps).l
	move.l	(a0)+,$47D88.l
	add.l	d0,$47D88.l
	move.l	(a0)+,(ScoutSpeechTable).l
	add.l	d0,(ScoutSpeechTable).l
	move.l	(a0)+,(SmallFontMap).l
	add.l	d0,(SmallFontMap).l
	move.l	(a0)+,(HotMap).l
	add.l	d0,(HotMap).l
	move.l	(a0)+,(ColdMap).l
	add.l	d0,(ColdMap).l
	move.l	(a0)+,$47D50.l
	add.l	d0,$47D50.l
	move.l	(a0)+,(BigFontMap).l
	add.l	d0,(BigFontMap).l
	move.l	(a0)+,(FramerMap).l
	add.l	d0,(FramerMap).l
	move.l	(a0)+,(RonBarrMap).l
	add.l	d0,(RonBarrMap).l
	move.l	(a0)+,$47D70.l
	add.l	d0,$47D70.l
	move.l	(a0)+,(EASportsBGMap).l
	add.l	d0,(EASportsBGMap).l
	move.l	(a0)+,$47D08.l
	add.l	d0,$47D08.l
	move.l	(a0)+,$47D78.l
	add.l	d0,$47D78.l
	move.l	(a0)+,$47D44.l
	add.l	d0,$47D44.l
	move.l	(a0)+,$47D7C.l
	add.l	d0,$47D7C.l
	move.l	(a0)+,$47D48.l
	add.l	d0,$47D48.l
	move.l	(a0)+,$47D94.l
	add.l	d0,$47D94.l
	move.l	(a0)+,$47D18.l
	add.l	d0,$47D18.l
	move.l	(a0)+,(ScoutSavedSP).l
	add.l	d0,(ScoutSavedSP).l
	move.l	(a0)+,$47D74.l
	add.l	d0,$47D74.l
	move.l	(a0)+,$47D04.l
	add.l	d0,$47D04.l
	bclr	#$5,$FF800F.l
	jsr	$375F4.l
	jsr	$376D4.l
	st.b	$191CE.l
	moveq	#$0,d0
	tst.w	ScrollDisplayUpData.l
	beq.s	.next2
	jsr	$37752.l
.next2	jsr	$21FC8.l
	move.w	#$2,d1
	move.w	#$96,d0
	jsr	$5F22.w
	jsr	$222D6.l
	move.w	#$4,$19364.l
	lea.l	$19364.l,a0
	move.w	#$15,d0
	jsr	$5F22.w
	lea.l	$19364.l,a0
	move.w	#$13,d0
	jsr	$5F22.w
	move.l	#$400,d1
	move.w	#$85,d0
	jsr	$5F22.w
	move.w	#$8400,d1
	move.w	#$85,d0
	jsr	$5F22.w
	rts
EASportsScreen						;Called from Begin. Show the EA Sports screen until a button, or $50 x 4
									;frames (about 5 s)
	move.w	#$1,ScrollDisplayUpData.l
	bsr.w	ScrollDisplayUpCall
	move.l	#vb2,(VBint).l
	bclr	#$1,(disflags).l
	move.w	#$5,$18D3E.l
	move.w	#$A000,$18D38.l
	move.w	#$7,(Map2col).l
	move.w	#$C000,(VmMAP1).l
	move.w	#$7,(Map1col).l
	move.w	#$F000,$18D3C.l
	move.w	#$F800,$18D32.l
	move.w	#$FC00,$18D30.l
	movea.l	#$BBCB0,a0
	moveq	#$1F,d1		;32 longs: all 64 colours black
.clr	clr.l	(a0)+
	dbra	d1,.clr
	jsr	$36F72.l
	jsr	$37B74.l
	rts
; EA Sports screen: waits for the sub CPU reply, then switches the vblank vector
EASportsScreenCheck	jsr	$374F0.l
	cmpi.b	#$E0,d3
	bne.w	rtss2
	bset.b	#$5,$FF800F.l
	move.l	#$3DB90,$18D66.l
	jsr	$47DAC.l
	jsr	$36D0A.l
	move.w	#$18,$18D62.l
	bsr.w	printsmallz
	dc.b	$00,$12,$F8,$04,$03,$0C,$01,$43,$68,$65,$63,$6B,$20,$53,$6F,$75	; .......Check Sou
	dc.b	$6E,$64	; nd
; EA Sports screen: frame wait loop
EASportsScreenWait	moveq	#$14,d6
.loop	move.w	$17474.l,d0
.loop2	cmp.w	$17474.l,d0
	beq.w	.loop2
	jsr	$374F0.l
	jsr	$374BE.l
	tst.b	d1
	beq.w	.loop
	btst	#$7,d1
	bne.w	rtss2
	btst	#$3,d1
	beq.w	.next
	addi.w	#$1,d6
.next	btst	#$2,d1
	beq.w	.next2
	subi.w	#$1,d6
.next2	btst	#$5,d1
	beq.w	.next3
	jsr	$3710C.l
.next3	move.w	d6,d0
	moveq	#$3,d1
	bsr.w	PushNumberWidth
	move.w	#$17,$18D58.l
	bsr.w	print
	bra.w	.loop
UpdatePlayoffLevel						;Set pojoy from the number of players for play modes 2 and 3.
	cmpi.w	#$2,$18BFA.l
	blt.w	rtss2
	cmpi.w	#$4,$18BFA.l
	beq.w	rtss2
	moveq	#$7,d0
	tst.w	$18BF8.l
	beq.w	.set
	move.w	#$B,d0		;4 way play
.set	sub.w	(OptNOP).l,d0		;pojoy = pad layouts minus the player count option
	move.w	d0,$18AA2.l
	rts
TeamIcons						;draw the visitor and home team bitmaps and set colors.
									;Called from PrintOptions. 92 TeamIcons drew name bars (dotb)
	movem.l	d0-d7/a0-a2,-(sp)
	cmpi.w	#$4,$18BFA.l
	beq.w	.next
	tst.w	$18BFA.l
	bne.w	.draw
.next	move.w	$18BFE.l,(HomeTeam).l
	move.w	$18C00.l,(VisTeam).l
.draw	bsr.w	printz		;teams set: print them
	String	CC_Font1Pri,$7,$1
	move.w	(VisTeam).l,d1
	move.w	d1,d0
	asl.w	#$6,d0		;64 bytes per team
	movea.l	#TeamPalettes,a0
	move.l	$26(a0,d0.w),$BBCD6.l		;B palette colors into palette 1
	move.w	$1939C.l,d4
	bsr.w	DrawTeamBitmap
	bsr.w	printz
	String	CC_Font1Pri,$16,$1
	move.w	(HomeTeam).l,d1
	move.w	d1,d0
	asl.w	#$6,d0		;64 bytes per team
	movea.l	#TeamPalettes,a0
	move.l	$2(a0,d0.w),$BBCD2.l		;A palette colors into palette 1
	move.w	#$EEE,$BBCDA.l		;colour 5 white
	move.w	#$2,d4		;first bitmap char
	bsr.w	DrawTeamBitmap		;draw the home team
	bsr.w	setteams		;set up the team structs
	move.w	#$64,(palcount).l		;fade over $64 frames
	movem.l	(sp)+,d0-d7/a0-a2
	rts
DrawTeamBitmap						;dobitmap entry d1 of TeamBitmaps (d4 from the caller)
	clr.w	d0
	asl.w	#$1,d1
	movea.l	$47D48.l,a0
	movea.l	a0,a1		;a1 = map header
	adda.l	(a0),a0		;a0 = tile data
	adda.l	$4(a1),a1		;a1 = map data
	movea.l	#$1B008,a2
	move.w	(a1),d2
	moveq	#$2,d3
	moveq	#$0,d5
	bra.w	dobitmap
dotb						;unreferenced. Like DrawTeamBitmap with Teamblocksmap, d4 = 2, d5 = 2
	clr.w	d0
	asl.w	#$1,d1
	movea.l	$47D44.l,a0
	movea.l	a0,a1		;a1 = map header
	adda.l	(a0),a0		;a0 = tile data
	adda.l	$4(a1),a1		;a1 = map data
	movea.l	#$1B008,a2		;tile data: word 0 at $310 = no tiles
	move.w	(a1),d2
	moveq	#$2,d3
	moveq	#$2,d4
	moveq	#$2,d5		;color fam 2
	bra.w	dobitmap
ClearRosterName						;unreferenced. Set the print position, then erase 12 x 2 at it
	bsr.w	.next
	moveq	#$C,d0
	moveq	#$2,d1
	move.w	#$7FF,d2		;blank char
	bra.w	eraser
.next	bsr.w	printz
	String	CC_Font1Pri,$2,$A
	cmpa.l	#$1834C,a2
	bne.w	rtss2
	move.w	#$1A,(printx).l
	rts
PickStartingGoalie						;unreferenced. tmgoalie = 0 if a pad has team a2, else (gamelevel <= 2,
									;line changes on) a value from the team's .godds
	movem.l	d0/a0,-(sp)
	clr.w	$28(a2)
	bsr.w	FigureJoy		;sets cont1team / cont2team
	cmpa.l	#$1834C,a2
	seq.b	d0		;home: d0 = -1
	ext.w	d0
	addi.w	#$2,d0		;1 for the home team, 2 for the away team
	cmp.w	$17FA6.l,d0
	beq.w	.x
	cmp.w	$17FA8.l,d0
	beq.w	.x
	moveq	#$0,d0
	cmpi.w	#$2,$18A9E.l
	bgt.w	.set
	tst.w	$18C0A.l
	bne.w	.set		;line changes off
	movea.l	#TeamList,a0
	move.w	$0(a2),d0
	asl.w	#$2,d0
	movea.l	(a0,d0.w),a0		;team block
	adda.w	$A(a0),a0		;GoalieOdds offset: a0 = .godds
	moveq	#$4,d0		;4 goalie weights
	jsr	(UnpackNibbles).l
	jsr	(WeightedRandomSelect).l
.set	move.w	d0,$28(a2)		;store the pick (0 = first goalie)
.x	movem.l	(sp)+,d0/a0
	rts
; Vertical interrupt handler of the menu screens
MenuVBlankHandler	dc.w	$48E7,$FFFE,$0839,$0002,$0001,$8D64,$6600,$0018
	dc.w	$08B9,$0000,$0001,$8D64,$6700,$0006,$6100,$DAC6
	dc.w	$4EB9,$0003,$6DF6,$5279,$0001,$7474,$4CDF,$7FFF
	rts
DefaultMenus						;Set the default menu choices for the beginning of the game: the 9 option
									;words from defmenuoptions (93 had 7). Called once from Begin
	st.b	$18C16.l
	movea.l	#$18BFA,a0
	movea.l	#$40120,a1		;Start of Menu Options in RAM
	move.w	#$8,d0
.loop	move.w	(a1)+,(a0)+		;9 options
	dbra	d0,.loop
	rts
; Data that follows DefaultMenus (strings, small tables)
DefaultMenusData	dc.w	$0000,$0001,$000B,$000A,$0001,$0000,$0001,$0000
	dc.w	$0001
	movem.l	d0-d7/a0-a3,-(sp)
	movea.l	#$18C38,a3
	bsr.w	InitPlayerSlots
	move.w	$18A9E.l,d0
	or.w	$18A9C.l,d0
	beq.w	.next5
	bsr.w	MakeTree
	moveq	#$7,d0
	tst.w	$18BF8.l
	beq.w	.next
	move.w	#$B,d0
.next	tst.w	$18BF8.l
	bne.w	.next2
	cmpi.w	#$2,$18AA2.l
	ble.w	.next4
	subi.w	#$2,$18AA2.l
	bra.w	.next4
.next2	cmpi.w	#$1,$18AA2.l
	bne.w	.next3
	move.w	#$3,$18AA2.l
	bra.w	.next4
.next3	cmpi.w	#$2,$18AA2.l
	bne.w	.next4
	move.w	#$4,$18AA2.l
.next4	sub.w	$18AA2.l,d0
	move.w	d0,(OptNOP).l
.next5	movem.l	(sp)+,d0-d7/a0-a3
	rts
	moveq	#$20,d0
	jsr	(randomd0).l
.loop	addi.w	#$1,d0
	andi.w	#$1F,d0
	asl.w	#$4,d0
	movea.l	#$1FFDA,a0
	adda.w	d0,a0
	lsr.w	#$4,d0
	moveq	#$F,d1
	move.w	$18BFE.l,d2
	cmpi.w	#$19,d2
	bls.w	.loop2
	moveq	#$19,d2
.loop2	cmp.b	(a0)+,d2
	dbeq	d1,.loop2
	bne.w	.loop
	eori.w	#$F,d1
	move.w	d1,$18AA0.l
	move.w	d0,$18A9A.l
	clr.w	$18A9E.l
	move.w	#$7,$18A9C.l
	cmpi.w	#$2,$18BFA.l
	beq.w	MakeTree
	clr.w	$18A9C.l
	moveq	#$7,d0
	movea.l	#$18A18,a0
.loop3	clr.w	$4(a0)
	clr.w	$6(a0)
	adda.w	#$10,a0
	dbra	d0,.loop3
MakeTree						;Make the playoff tree (potree) from playoffseats and WinBits, clear the
									;scores of this round's games and set their teams
									;(.sett), then FigureJoy. Called from ContinuePlayoffs and EncodePW; falls
									;in from NewPO
	movem.l	d0-d4/a0-a3,-(sp)
	move.w	$18A9A.l,d1
	asl.w	#$4,d1		;16 bytes a tree
	movea.l	#$18AA6,a0
	movea.l	#$1FFDA,a1
	adda.w	d1,a1
	move.l	(a1),(a0)		;first round: 16 teams from the tree
	move.l	$4(a1),$4(a0)
	move.l	$8(a1),$8(a0)
	move.l	$C(a1),$C(a0)
	lea.l	$10(a0),a1		;a1 = next round
	moveq	#$E,d2		;15 winners
	move.w	$18AA4.l,d0
.0	move.w	d0,d1		;d1 = lowest WinBits bit: pick the pair member
	andi.w	#$1,d1		;winbit picks the top or bottom team of the pair
	move.b	(a0,d1.w),(a1)+		;winner
	adda.w	#$2,a0		;next pair
	lsr.w	#$1,d0		;next winner bit
	dbra	d2,.0
	bsr.w	GetShifter		;d1 = games, d2 = first
	tst.w	d1		;any games left?
	bmi.w	.nogames		;playoffs over
	movea.l	#$18AA6,a0
	adda.w	d2,a0
	adda.w	d2,a0		;(2 bytes a game)
	movea.l	#$18A18,a1
.loop	clr.w	$A(a1)		;gstruct: gss1
	clr.w	$C(a1)
	clr.w	$8(a1)
	bclr	#$1,$E(a1)		;hilite requested
	bsr.w	.next
	adda.w	#$10,a1
	dbra	d1,.loop
	bsr.w	FigureJoy		;assign the pads
.nogames	movem.l	(sp)+,d0-d4/a0-a3
	rts
.next	cmpi.w	#$2,$18A9C.l
	beq.w	.1
	cmpi.w	#$3,$18A9C.l
	beq.w	.1
	cmpi.w	#$5,$18A9C.l
	beq.w	.1		;tree order
	bset	#$0,$E(a1)		;teams are flipped
	move.b	(a0)+,$3(a1)
	move.b	(a0)+,$1(a1)
	rts
.1	bclr	#$0,$E(a1)		;gsftf: teams not flipped
	move.b	(a0)+,$1(a1)
	move.b	(a0)+,$3(a1)
	rts
FigureJoy						;Set contteams appropriately: cont1team ... cont4team (3 and 4 for
									;FourWayPlay). In the playoffs (not Shootout, gmode2 bit 0) find this
									;round's game of the po team and set the teams and pads from .pojoylist
									;(.pojoylist2 with FourWayPlay); otherwise from .noplist by OptNOP.
									;After a demo (demoflag clear), and outside the playoffs, fill gstruct
									;with random matchups (InitializeGameStructures). Called from MakeTree and
									;GameSetUp
	movem.l	d0-d3/a0-a1,-(sp)
	clr.w	$17FA6.l
	clr.w	$17FA8.l
	clr.w	$17FAA.l
	clr.w	$17FAC.l
	tst.w	$18C16.l
	beq.w	.next12
	tst.w	$18BFA.l
	beq.w	.next10		;regular season
	btst	#$0,$17F78.l
	bne.w	.next10
	bsr.w	GetShifter		;d1 = last game
	movea.l	#$18AA6,a0
	move.w	$18AA0.l,d2
	move.b	(a0,d2.w),d2
	movea.l	#$18A18,a1
	moveq	#$10,d4
	mulu.w	d1,d4		;times the last game
	adda.w	d4,a1		;a1 = last game
	st.b	$18A98.l
	clr.w	d0
.f0	cmp.w	$0(a1),d2		;first team?
	beq.w	.next3
	cmp.w	$2(a1),d2		;second team?
	beq.w	.next
	suba.w	#$10,a1		;previous game
	dbra	d1,.f0
	bra.w	.next13
.next	moveq	#$4,d0
	tst.w	$18BF8.l
	beq.w	.next2
	move.w	#$5,d0
.next2	move.w	$0(a1),$18C00.l
	move.w	$2(a1),$18BFE.l
	bra.w	.next4
.next3	clr.w	d0
	move.w	$2(a1),$18C00.l
	move.w	$0(a1),$18BFE.l
.next4	add.w	$18AA2.l,d0
	move.w	d1,$18A98.l
	move.w	$0(a1),(HomeTeam).l
	move.w	$2(a1),(VisTeam).l
	asl.w	#$2,d0		;4 bytes an entry
	lea.l	.next8(pc),a0
	tst.w	$18BF8.l
	beq.w	.next5
	lea.l	.next9(pc),a0
.next5	move.w	(a0,d0.w),$17FA6.l
	move.w	$2(a0,d0.w),$17FA8.l
	tst.w	$18BF8.l
	beq.w	.next13
	cmpi.w	#$4,d0		;layout 1?
	beq.w	.next6		;pojoy 1: cont3team / cont4team = cont1team / cont2team
	cmpi.w	#$18,d0		;layout 6?
	beq.w	.next6
	bra.w	.2
.next6	move.w	$17FA6.l,$17FAA.l
	move.w	$17FA8.l,$17FAC.l
	bra.w	.next13
.2	cmpi.w	#$8,d0		;layout 2?
	beq.w	.next7		;pojoy 2: cont3team = cont1team, cont4team 0
	cmpi.w	#$1C,d0		;layout 7?
	beq.w	.next7
	bra.w	.next13
.next7	move.w	$17FA6.l,$17FAA.l
	move.w	#$0,$17FAC.l
	bra.w	.next13
.next8	dc.w	$0001,$0000,$0001,$0001,$0001,$0002,$0002,$0001
	dc.w	$0002,$0000,$0002,$0002,$0002,$0001,$0001,$0002
.next9	dc.w	$0001,$0000,$0001,$0002,$0001,$0002,$0001,$0001
	dc.w	$0001,$0002,$0002,$0000,$0002,$0001,$0002,$0001
	dc.w	$0002,$0002,$0002,$0001
.next10
	move.w	(OptNOP).l,d0
	asl.w	#$2,d0
	lea.l	InitializeGameStructures(pc),a0
	move.w	(a0,d0.w),$17FA6.l
	move.w	$2(a0,d0.w),$17FA8.l
	cmpi.w	#$14,d0
	bne.w	.next11
	move.w	$17FA6.l,$17FAA.l
	move.w	#$0,$17FAC.l
	bra.w	.next12
.next11	cmpi.w	#$18,d0
	bne.w	.next12
	move.w	$17FA6.l,$17FAA.l
	move.w	$17FA8.l,$17FAC.l
.next12
	bsr.w	InitTeamMask
.next13
	movem.l	(sp)+,d0-d3/a0-a1
	rts
InitializeGameStructures						;Random team pairs for all 8 gstruct games, none of them HomeTeam or
									;VisTeam. Called from FigureJoy
	ori.b	#$0,d0
	ori.b	#$0,d1
	ori.b	#$0,d2
	ori.b	#$1,d1
	ori.b	#$2,d1
	ori.b	#$2,d1
	ori.b	#$2,d1
; Builds the mask of the two playing teams.
InitTeamMask
	st.b	$18A98.l
	clr.l	d3
	move.w	(HomeTeam).l,d1
	bset	d1,d3
	move.w	(VisTeam).l,d1
	bset	d1,d3
	movea.l	#$18A18,a1
	moveq	#$7,d2
.loop	bsr.w	.loop2
	move.w	d0,$0(a1)
	bsr.w	.loop2
	move.w	d0,$2(a1)
	adda.w	#$10,a1
	dbra	d2,.loop
	rts
.loop2	moveq	#$1A,d0
	jsr	(randomd0).l
	bset	d0,d3
	bne.w	.loop2
	rts
; Initialises the player slot structures.
InitPlayerSlots
	moveq	#$4,d0
	lea.l	$A(a3),a0
.loop	move.w	-(a0),-(sp)
	dbra	d0,.loop
	moveq	#$7,d2
	movea.l	#$18A88,a1
.loop2	bclr	#$2,$E(a1)
	moveq	#$5,d0
	bsr.w	SuperDiv
	move.w	d0,$6(a1)
	cmpi.w	#$4,d0
	bne.w	.next
	bset	#$2,$E(a1)
.next	moveq	#$5,d0
	bsr.w	SuperDiv
	move.w	d0,$4(a1)
	cmpi.w	#$4,d0
	bne.w	.next2
	bset	#$2,$E(a1)
.next2	suba.w	#$10,a1
	dbra	d2,.loop2
	move.w	#$4000,d0
	bsr.w	SuperDiv
	move.w	d0,$18AA4.l
	move.w	#$8,d0
	bsr.w	SuperDiv
	move.w	d0,$18AA2.l
	tst.w	$18BF8.l
	beq.w	.next4
	cmpi.w	#$1,$18AA2.l
	bne.w	.next3
	move.w	#$3,$18AA2.l
	bra.w	.next4
.next3	cmpi.w	#$2,$18AA2.l
	bne.w	.next4
	move.w	#$4,$18AA2.l
.next4	moveq	#$10,d0
	bsr.w	SuperDiv
	move.w	d0,$18AA0.l
	moveq	#$4,d0
	bsr.w	SuperDiv
	move.w	d0,$18A9E.l
	moveq	#$8,d0
	bsr.w	SuperDiv
	move.w	d0,$18A9C.l
	moveq	#$20,d0
	bsr.w	SuperDiv
	move.w	d0,$18A9A.l
	moveq	#$4,d0
	lea.l	(a3),a0
.loop3	move.w	(sp)+,(a0)+
	dbra	d0,.loop3
	rts

EncodePW						;After a playoff game compute winners and save the bits if needed. Returns
	
	
	
	tst.w	(OptNOP).l
	beq.w	rtss2
	tst.w	$18BFA.l
	beq.w	rtss2
	cmpi.w	#$4,$18BFA.l
	beq.w	rtss2
	move.w	#$1,$18BFA.l
	move.w	#$1,$18C24.l
	bsr.w	ResolveGames
	bsr.w	MakeTree
	cmpi.w	#$4,$18A9E.l
	beq.w	.next
	tst.w	$18A98.l
	bmi.w	.next
	movea.l	#$18C38,a3
	bsr.w	WritePassBits
	jsr	$2A5C8.l
	btst	#$2,$17F6E.l
	beq.w	rtss2
	movea.l	#$18D26,a3
	bsr.w	InitPlayerSlots
	bra.w	MakeTree
.next	movea.l	#$18C38,a3
	bsr.w	ClrPassBits
	jsr	$2A5C8.l
	move.w	#$2,$18BFA.l
	move.w	#$2,$18C24.l
	cmpi.w	#$7,$18A9C.l
	beq.w	rtss2
	move.w	#$3,$18BFA.l
	move.w	#$3,$18C24.l
	rts
WritePassBits						;Transfer the game variables to the bits at a3 (pojoy range 8). Called
	
	bsr.w	ClrPassBits
	move.w	$18A9A.l,d0
	moveq	#$20,d1
	bsr.w	PushBits
	move.w	$18A9C.l,d0
	moveq	#$8,d1
	bsr.w	PushBits
	move.w	$18A9E.l,d0
	moveq	#$4,d1
	bsr.w	PushBits
	move.w	$18AA0.l,d0
	moveq	#$10,d1
	bsr.w	PushBits
	move.w	$18AA2.l,d0
	moveq	#$8,d1
	bsr.w	PushBits
	move.w	$18AA4.l,d0
	move.w	#$4000,d1
	bsr.w	PushBits
	moveq	#$5,d1
	moveq	#$7,d2
	movea.l	#$18A18,a1
.loop	move.w	$4(a1),d0
	bsr.w	PushBits
	move.w	$6(a1),d0
	bsr.w	PushBits
	adda.w	#$10,a1
	dbra	d2,.loop
	rts
PushBits						;bits = bits * d1 + d0. d1 = range 2^1-2^15, d0 = data
	movem.l	d0-d1,-(sp)
	exg.l	d0,d1
	bsr.w	SuperMult
	clr.l	d0
	move.w	d1,d0
	bsr.w	SuperAdd
	movem.l	(sp)+,d0-d1
	rts
ClrPassBits						;Clear the 5 words of bits at a3
	movea.l	a3,a0
	moveq	#$4,d0
.0	clr.w	(a0)+
	dbra	d0,.0
	rts
SuperAdd						;1 long (d0.L) added to the 5 words at a3
	movem.l	d1/a0,-(sp)
	lea.l	$A(a3),a0
	moveq	#$3,d1
	add.l	d0,-(a0)
	bra.w	.2
.1	addi.w	#$1,-(a0)
.2	dbcc	d1,.1
	movem.l	(sp)+,d1/a0
	rts
SuperMult						;1 word (d0) multiplied by the 5 words at a3
	movem.l	d1-d4/a0,-(sp)
	movea.l	a3,a0
	moveq	#$4,d4
.0	move.w	(a0),-(sp)
	clr.w	(a0)+
	dbra	d4,.0
	moveq	#$4,d4
.1	move.w	d0,d1
	mulu.w	(sp)+,d1
	lea.l	$2(a3),a0
	adda.w	d4,a0
	adda.w	d4,a0
	move.w	d4,d2
	add.l	d1,-(a0)
	bra.w	.3
.2	addi.w	#$1,-(a0)
.3	dbcc	d2,.2
	dbra	d4,.1
	movem.l	(sp)+,d1-d4/a0
	rts
SuperDiv						;5 words at a3 divided by 1 word (d0); d0 = remainder on exit
	movem.l	d1-d2/a0,-(sp)
	movea.l	a3,a0
	moveq	#$4,d1
	clr.l	d2
.0	move.w	(a0),d2
	divu.w	d0,d2
	move.w	d2,(a0)+
	dbra	d1,.0
	swap	d2
	move.w	d2,d0
	movem.l	(sp)+,d1-d2/a0
	rts
GetShifter						;Returns d1 = number of games - 1, d2 = first bit of WinBits
	move.l	d0,-(sp)
	moveq	#-16,d2
	moveq	#$10,d1
	move.w	$18A9E.l,d0
.loop	add.w	d1,d2
	lsr.w	#$1,d1
	dbra	d0,.loop
	subi.w	#$1,d1
	move.l	(sp)+,d0
	rts
AddPlayoffTeamStats						;Add the po team's game stats to its packed playoff totals: unpack them
	
	
	
	cmpi.w	#$1,$18BFA.l
	blt.w	rtss2
	bsr.w	ReadTeamStats
	movea.l	#$18AA6,a0
	move.w	$18AA0.l,d2
	move.b	(a0,d2.w),d2
	movea.l	#tmstruct,a2
	cmp.w	$2A(a2),d2
	beq.w	.0
	adda.w	#$366,a2
.0	adda.w	#$B6,a2
	moveq	#$67,d0
	movea.l	#$B000,a1
.loop	clr.w	d1
	move.b	(a2)+,d1
	add.w	d1,(a1)+
	dbra	d0,.loop
	movea.l	#$B000,a0
	movea.l	#$408DC,a1
	movea.l	#$18C42,a2
	moveq	#$67,d0
	clr.w	d4
.loop2	clr.l	d1
	move.w	(a0)+,d1
	move.w	d0,d2
	andi.w	#$3,d2
	move.b	(a1,d2.w),d2
	clr.l	d3
	bset	d2,d3
	subi.w	#$1,d3
	cmp.w	d3,d1
	ble.w	.1
	move.w	d3,d1
.1	not.l	d3
	move.w	d4,d5
	andi.w	#$F,d5
	rol.l	d5,d3
	rol.l	d5,d1
	move.w	d4,d5
	lsr.w	#$4,d5
	add.w	d5,d5
	neg.w	d5
	addi.w	#$100,d5
	and.l	d3,-$22(a2,d5.w)
	or.l	d1,-$22(a2,d5.w)
	add.w	d2,d4
	dbra	d0,.loop2
	rts
; Data that follows AddPlayoffTeamStats (strings, small tables)
AddPlayoffTeamStatsData	dc.w	$0C0E,$0A0A
ReadTeamStats						;Unpack the $68 playoff stat totals from the bit stream into statsbuffer
	
	movea.l	#$B000,a0
	movea.l	#$408DC,a1
	movea.l	#$18C42,a2
	moveq	#$67,d0
	clr.w	d4
.loop	move.w	d4,d5
	lsr.w	#$4,d5
	add.w	d5,d5
	neg.w	d5
	addi.w	#$100,d5
	move.l	-$22(a2,d5.w),d1
	move.w	d4,d5
	andi.w	#$F,d5
	lsr.l	d5,d1
	move.w	d0,d2
	andi.w	#$3,d2
	move.b	(a1,d2.w),d2
	add.w	d2,d4
	clr.w	d3
	bset	d2,d3
	subi.w	#$1,d3
	and.w	d3,d1
	move.w	d1,(a0)+
	dbra	d0,.loop
	rts
ResolveGames						;Compute winners and losers for playoff matchups. Called from EncodePW
	move.w	$18A98.l,d0
	mulu.w	#$10,d0
	movea.l	#$18A18,a0
	move.w	$18358.l,$A(a0,d0.w)
	move.w	$186BE.l,$C(a0,d0.w)
	bsr.w	GetShifter
	movea.l	#$18A18,a0
	moveq	#$10,d3
	mulu.w	d1,d3
	adda.w	d3,a0
	cmpi.w	#$7,$18A9C.l
	beq.w	.notbos
.loop	cmpi.w	#$4,$4(a0)
	beq.w	.b1
	cmpi.w	#$4,$6(a0)
	beq.w	.b1
	clr.w	d3
	btst	#$0,$E(a0)
	beq.w	.0
	eori.w	#$2,d3
.0	move.w	$A(a0),d0
	sub.w	$C(a0),d0
	bpl.w	.win
	eori.w	#$2,d3
.win	addi.w	#$1,$4(a0,d3.w)
.b1	suba.w	#$10,a0
	dbra	d1,.loop
	addi.w	#$1,$18A9C.l
	cmpi.w	#$7,$18A9C.l
	beq.w	.next2
	move.w	$18A98.l,d0
	mulu.w	#$10,d0
	movea.l	#$18A18,a0
	adda.w	d0,a0
	cmpi.w	#$4,$4(a0)
	beq.w	.next
	cmpi.w	#$4,$6(a0)
	bne.w	rtss2
.next	cmpi.w	#$3,$18A9E.l
	bge.w	.next2
	bsr.w	GetShifter
	movea.l	#$18A18,a0
	moveq	#$10,d3
	mulu.w	d1,d3
	adda.w	d3,a0
.loop2	cmp.w	$18A98.l,d1
	beq.w	.crn
	cmpi.w	#$4,$4(a0)
	beq.w	.crn
	cmpi.w	#$4,$6(a0)
	beq.w	.crn
	addi.w	#$1,$4(a0)
	move.l	#$C8,d0
	jsr	(randomd0).l
	andi.w	#$1,d0
	beq.w	.loop2
	subi.w	#$1,$4(a0)
	addi.w	#$1,$6(a0)
	bra.w	.loop2
.crn	suba.w	#$10,a0
	dbra	d1,.loop2
	movea.l	#$18D26,a3
	bsr.w	WritePassBits
	bset	#$2,$17F6E.l
.next2	clr.w	$18A9C.l
	bsr.w	GetShifter
	movea.l	#$18A18,a0
	moveq	#$10,d3
	mulu.w	d1,d3
	adda.w	d3,a0
	clr.w	d3
.loop3	cmpi.w	#$4,$4(a0)
	beq.w	.2
	bset	d1,d3
.2	clr.w	$4(a0)
	clr.w	$6(a0)
	suba.w	#$10,a0
	dbra	d1,.loop3
	moveq	#$1,d1
	asl.w	d2,d1
	subi.w	#$1,d1
	and.w	d1,$18AA4.l
	asl.w	d2,d3
	or.w	d3,$18AA4.l
	addi.w	#$1,$18A9E.l
	rts
.notbos	clr.w	d3
.loop4	move.w	$A(a0),d0
	cmp.w	$C(a0),d0
	bhi.w	.3
	bset	d1,d3
.3	btst	#$0,$E(a0)
	beq.w	.nb2
	bchg	d1,d3
.nb2	suba.w	#$10,a0
	dbra	d1,.loop4
	moveq	#$1,d1
	asl.w	d2,d1
	subi.w	#$1,d1
	and.w	d1,$18AA4.l
	asl.w	d2,d3
	or.w	d3,$18AA4.l
	addi.w	#$1,$18A9E.l
	rts
ShowThreeStars						;End of game Stars of the Game box. Called from UpdatePA while RefPen is
	
	
	
	
	
	cmpi.w	#$40,$1806E.l
	bgt.w	rtss2
	bset	#$7,$17F68.l
	bne.w	rtss2
	movem.l	d0/a1,-(sp)
	bset	#$3,(disflags).l
	move.w	(ScoutSubStatus).l,d0
.loop	cmp.w	(ScoutSubStatus).l,d0
	beq.w	.loop
	movem.l	(sp)+,d0/a1
	movem.l	d0-d5/a0-a4,-(sp)
	jsr	(printz).l
	String	CC_Font1Pri,$2,$E
	moveq	#$1C,d0
	moveq	#$9,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	CC_Font1Pri,$9,$10,'Stars of the Game',CC_Font1Pri,$3,$F
	movea.l	$47D18.l,a1
	movea.l	#$1B008,a2
	adda.l	$4(a1),a1
	moveq	#$D,d0
	moveq	#$5B,d1
	moveq	#$6,d2
	moveq	#$4,d3
	move.w	$18D48.l,d4
	clr.w	d5
	jsr	(dobitmap).l
	bsr.w	CalcStarScores
	move.w	#$12,(printy).l
	moveq	#$2,d2
.loop2	bsr.w	TakeTopStarScore
	move.w	#$1A,(printx).l
	addi.w	#$1,(printy).l
	movea.l	$1E(a2),a1
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	jsr	(print).l
	bsr.w	GetPlayerNameBuild
	move.w	#$3,(printx).l
	jsr	(print).l
	dbra	d2,.loop2
	move.w	$18358.l,d0
	sub.w	$186BE.l,d0
	ble.w	.nosong		;home didn't win
	move.w	#$F,-(sp)		;home team won (sound effect)
	jsr	(sfx).l
.nosong	movem.l	(sp)+,d0-d5/a0-a4
	rts
TakeTopStarScore						;Take the highest of the 52 star scores at ThreeStars and clear it.
	
	
	movem.l	d1-d2/a1/a4,-(sp)
	movea.l	#ThreeStars,a4
	clr.l	d0
	moveq	#$33,d2
.find	cmp.l	(a4)+,d0
	bge.w	.next
	lea.l	-$4(a4),a1
	move.l	(a1),d0
.next	dbra	d2,.find
	clr.l	(a1)
	move.l	a1,d0
	subi.l	#$BC000,d0
	lsr.w	#$2,d0
	movea.l	#tmstruct,a2
	cmpi.w	#$1A,d0
	blt.w	.home
	subi.w	#$1A,d0
	adda.w	#$366,a2
.home	movem.l	(sp)+,d1-d2/a1/a4
	rts
CalcStarScores						;Star score for every roster slot of both teams to ThreeStars (26 longs
	
	
	
	
	movea.l	#ThreeStars,a4
	jsr	(GetPeriodTime).l
	move.w	d0,d5
	add.w	d2,d5
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a3
	bsr.w	CalcTeamStarScores
	movea.l	a3,a2
	lea.l	-$366(a2),a3
	bsr.w	CalcTeamStarScores
	cmpi.w	#$3,$180E4.l
	bne.w	.x
	tst.w	d3
	beq.w	.x
	movea.l	#$180EC,a0
	adda.w	$180F0.l,a0
	clr.w	d0
	btst	#$7,$2(a0)
	beq.w	.slot
	addi.w	#$1A,d0
.slot	add.b	$3(a0),d0
	asl.w	#$2,d0
	movea.l	#ThreeStars,a0
	move.l	#$7FFFFFFF,(a0,d0.w)		;game winner is the first star
.x	rts
CalcTeamStarScores						;Star scores of team a2 (a3 = other team) to (a4)+, one long per roster
	
	
	
	
	
	movea.l	a2,a1
	move.w	$C(a2),d3
	sub.w	$C(a3),d3
	ext.l	d3
	moveq	#$19,d4
	jsr	(GetGoalieCount).l
	neg.w	d0
	add.w	d4,d0
.loop	move.l	d3,(a4)
	cmp.w	d0,d4
	bhi.w	.goalie
	clr.w	d1
	move.b	$B6(a2),d1
	mulu.w	#$2AF8,d1
	add.l	d1,(a4)
	clr.w	d1
	move.b	$D0(a2),d1
	mulu.w	#$2774,d1
	add.l	d1,(a4)
	clr.w	d1
	move.b	$EA(a2),d1
	mulu.w	#$A,d1
	tst.w	d3
	bne.w	.add
	mulu.w	#$64,d1
	add.l	d1,(a4)
	clr.l	d1
	add.w	$138(a1),d1
.add	add.l	d1,(a4)
	bra.w	.next
.goalie	cmp.w	$138(a1),d5
	bhi.w	.next
	clr.w	d1
	move.b	$B6(a2),d1
	mulu.w	#$64,d1
	clr.w	d2
	move.b	$EA(a2),d2
	beq.w	.next
	divu.w	d2,d1
	cmpi.w	#$4,d1
	bhi.w	.next
	addi.l	#$7D00,(a4)
	tst.w	d1
	bne.w	.next
	addi.l	#$124F8,(a4)
.next	adda.w	#$2,a1
	adda.w	#$1,a2
	adda.w	#$4,a4
	dbra	d4,.loop
	rts
	movem.l	d0-d2/a0-a4,-(sp)
	jsr	(printz).l
	String	CC_Font1Pri,$B,$3
	moveq	#$12,d0
	moveq	#$5,d1
	jsr	(Framer).l
	btst	#$5,$17F7A.l
	bne.w	.next2
	jsr	(printz).l
	dc.w	$0024
	dc.b	$BF,$0C,$04,'Injury to:',$BF,$0C,$06,'Out for period',$BF,$0C,$05,$00
	bra.w	.next3
.next2	jsr	(printz).l
	dc.w	$0022
	dc.b	$BF,$0C,$04,'Injury to:',$BF,$0C,$06,'Out for game',$BF,$0C,$05,$00
.next3	bsr.w	GetPlayerNumInitial
	jsr	(print).l
	btst	#$0,$17BE3.l
	beq.w	.next4
	jsr	(printz).l
	String	CC_Font1Pri,$14,$6,'the game'
.next4	movem.l	(sp)+,d0-d2/a0-a4
	rts
	bset	#$7,$17F78.l
	btst	#$0,$17F78.l
	beq.w	.next5
	jmp	(ShootoutModeBox).l
.next5	movem.l	d0-d2/a0-a4,-(sp)
	move.w	#$FFFF,d0
	jsr	(prefmes).l
	jsr	(printz).l
	String	CC_Font1Pri,$3,$2
	moveq	#$1B,d0
	moveq	#$8,d1
	jsr	(Framer).l
	lea.l	ShowGoalBox(pc),a1
	jsr	(printbig).l
	move.w	$19368.l,d0
	asl.w	#$7,d0
	movea.l	#$17480,a2
	adda.w	d0,a2
	clr.w	d0
	move.b	$66(a2),d0
	movea.l	#tmstruct,a2
	tst.w	$19366.l
	beq.w	.next6
	movea.l	#awtmstruct,a2
.next6	bsr.w	FormatPlayerNumInitial
	jsr	(print).l
	jsr	(printz).l
	String	CC_Font1Pri,$4,$7
	movem.l	a1/a3,-(sp)
	move.w	$19372.l,d0
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	lea.l	$2(a1),a1
	jsr	(print).l
	movem.l	(sp)+,a1/a3
	jsr	(printz).l
	String	' by',CC_Font1Pri,$4,$8
	move.w	$19370.l,d0
	movea.l	#awtmstruct,a2
	tst.w	$19366.l
	beq.w	.next7
	movea.l	#tmstruct,a2
.next7	jsr	(FormatPlayerNumInitial).l
	jsr	(print).l
	movem.l	(sp)+,d0-d2/a0-a4
	rts
ShowGoalBox						;Goal box. Closes both line change boxes, then printbig 'GOAL!' ('PP
	
	
	
									;assists of the last goal entry (FormatPlayerName). Calls CountGoalies,
									;StartArenaAnim (home hat trick),
									;PrintPlayerGoals and PrintPlayerAssists; BA_PS_flags bit 2 sets sflags2
									;bit 2. Called from SetPA
	dc.w	$0016,$BF04
	bchg	d1,(a0)
	dc.b	'ENALTY SHOT!',$BF,$04,$05,$00
; Draws the goal box after the flag checks.
ShowGoalBoxDraw
	movem.l	d0-d2/a0-a4,-(sp)
	btst	#$2,$17F70.l
	beq.w	.next
	bset	#$2,$17F6C.l
.next	movea.l	#tmstruct,a2
	jsr	(lcfound_close).l
	adda.w	#$366,a2
	jsr	(lcfound_close).l
	movea.l	#$180EC,a4
	adda.w	$180F0.l,a4
	jsr	(printz).l
	String	CC_Font1Pri,$B,$2
	moveq	#$13,d0
	move.w	#$5,d1
	tst.b	$4(a4)
	bmi.w	.next2
	addi.w	#$2,d1
	tst.b	$5(a4)
	bmi.w	.next2
	addi.w	#$1,d1
.next2	jsr	(Framer).l
	jsr	$25D8C.l
	movea.l	#tmstruct,a2
	move.w	$193AA.l,$17E98.l
	btst	#$7,$2(a4)
	beq.w	.next3
	adda.w	#$366,a2
	move.w	$193AC.l,$17E98.l
.next3	lea.l	.next9(pc),a1
	bclr	#$0,$17F7E.l
	beq.w	.next4
	lea.l	.next10(pc),a1
.next4	clr.w	d0
	move.b	$3(a4),d0
	addi.w	#$B6,d0
	cmpi.b	#$3,(a2,d0.w)
	bne.w	.next6
	movem.w	d1,-(sp)
	clr.w	d1
	move.b	$3(a4),d1
	cmp.w	$17E98.l,d1
	movem.w	(sp)+,d1
	blt.w	.next6
	adda.w	(a1),a1
	move.w	d0,-(sp)
	move.w	$2A(a2),d0
	cmp.w	(HomeTeam).l,d0
	bne.w	.next5
	move.w	#$0,d0
	jsr	(StartArenaAnim).l
.next5	move.w	(sp)+,d0
.next6	jsr	(printbig).l
	clr.w	d0
	move.b	$3(a4),d0
	move.w	d0,-(sp)
	move.w	#$C,(printx).l
	bsr.w	FormatPlayerName
	jsr	(print).l
	move.w	(sp)+,d0
	movem.w	d1,-(sp)
	clr.w	d1
	move.b	$3(a4),d1
	cmp.w	$17E98.l,d1
	movem.w	(sp)+,d1
	blt.w	.next7
	jsr	$2AA80.l
.next7	clr.w	d0
	move.b	$4(a4),d0
	bmi.w	.next8
	bclr	#$5,$17F72.l
	bne.w	.next8
	jsr	(printz).l
	String	CC_Font1Pri,$E,$6,'Assist by:',CC_Font1Pri,$C,$7
	move.w	d0,-(sp)
	bsr.w	FormatPlayerName
	jsr	(print).l
	move.w	(sp)+,d0
	jsr	$2AA6A.l
	clr.w	d0
	move.b	$5(a4),d0
	bmi.w	.next8
	jsr	(printz).l
	String	CC_Font1Pri,$C,$8
	move.w	d0,-(sp)
	bsr.w	FormatPlayerName
	jsr	(print).l
	move.w	(sp)+,d0
	jsr	$2AA6A.l
.next8	bclr	#$5,$17F72.l
	movem.l	(sp)+,d0-d2/a0-a4
	rts
.next9	dc.w	$000E,$BF0F,$0347,$4F41,$4C21,$BF0C,$0500,$0012
	dc.b	$BF,$0C,$03,'HAT TRICK!',$BF,$0C,$05
.next10	dc.w	$0010,$BF0D,$0350,$5020,$474F,$414C,$21BF,$0C05
	dc.b	$00,$12,$BF,$0C,$03,'HAT TRICK!',$BF
	dc.w	$0C05
	jsr	(printz).l
	String	CC_Font1,$B,$2
	moveq	#$13,d0
	moveq	#$8,d1
	move.l	#$7FF,d2
	jmp	(eraser).l
GetPlayerName						;but that is the same symbol as getplayername (SNASM symbols are
	
	
	
	movem.l	d0/a2,-(sp)
	movea.l	#tmstruct,a2
	move.w	$180EE.l,d0
	bpl.w	.0
	andi.w	#$FF,d0
	adda.w	#$366,a2
.0	bsr.w	GetPlayerNameBuild		;name for d0 of team a2
	movem.l	(sp)+,d0/a2
	rts
; Builds the name text in the message area.
GetPlayerNameBuild
	movem.l	d0-d3/a0/a2-a3,-(sp)
	bsr.w	SkipTextEntries
	move.l	a0,-(sp)
	movea.l	#mesarea,a3
	move.w	#$4,(a3)
	lea.l	$2(a3),a1
	adda.w	(a0),a0
	move.b	(a0),d0
	bsr.w	ConvertByteToDigits
	jsr	(PushNumberWidthString).l
	String	' '
	movea.l	(sp)+,a1
	jsr	(appstring).l
	movea.l	#mesarea,a1
	movem.l	(sp)+,d0-d3/a0/a2-a3
	rts
GetPlayerNumInitial
	movem.l	d0/a2,-(sp)
	movea.l	#tmstruct,a2
	move.w	$180EE.l,d0
	bpl.w	.next
	andi.w	#$FF,d0
	adda.w	#$366,a2
.next	bsr.w	FormatPlayerNumInitial
	movem.l	(sp)+,d0/a2
	rts
FormatPlayerNumInitial						;a1 = mesarea string "NN F. Last" for player d0 of team a2, built in
	
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	SkipTextEntries
	move.l	a0,-(sp)
	movea.l	#TextBuffer,a1
	adda.w	(a0),a0
	move.b	(a0),d0
	bsr.w	ConvertByteToDigits
	move.b	#$20,(a1)+
	movea.l	(sp)+,a0
	move.w	(a0)+,d0
	lea.l	-$2(a0,d0.w),a2
	move.b	(a0)+,(a1)+
	move.w	#$2E20,(a1)+
.skip	cmpi.b	#$20,(a0)+
	bne.w	.skip
.copy	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	bne.w	.copy
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
FormatPlayerName						;a1 = mesarea string "NN Last" for player d0 of team a2, built in
	
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	SkipTextEntries
	move.l	a0,-(sp)
	movea.l	#TextBuffer,a1
	adda.w	(a0),a0
	move.b	(a0),d0
	bsr.w	ConvertByteToDigits
	move.b	#$20,(a1)+
	movea.l	(sp)+,a0
	move.w	(a0)+,d0
	lea.l	-$2(a0,d0.w),a2
.skip	cmpi.b	#$20,(a0)+
	bne.w	.skip
.copy	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	bne.w	.copy
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
FormatPlayerNameLast						;FormatPlayerNameShort without the leading space ("Last", space padded).
	
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	SkipTextEntries
	movea.l	#TextBuffer,a1
	bra.w	FormatLastName
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	SkipTextEntries
	movea.l	#TextBuffer,a1
	move.b	#$20,(a1)+
FormatLastName						;Skip the first name, copy the last name, pad; branched to from
	
	move.w	(a0)+,d0
	lea.l	-$2(a0,d0.w),a2
.loop	cmpi.b	#$20,(a0)+
	bne.w	.loop
.loop2	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	beq.w	.pad
	tst.b	(a0)
	bne.w	.loop2
	bra.w	.pad
.loop3	move.b	#$20,(a1)+
.pad	cmpa.l	#$17F00,a1
	blt.w	.loop3
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
FinalizeTextBuffer						;mesarea length word = a1 - mesarea, with a 0 pad byte when odd. Returns
	
	move.l	a1,d0
	subi.l	#$17EF2,d0
	btst	#$0,d0
	beq.w	.even
	clr.b	(a1)+
	addi.w	#$1,d0
.even	movea.l	#mesarea,a1
	move.w	d0,(a1)
	rts
; Skips d0 entries of an offset-linked text list.
SkipTextEntries	movea.l	$1E(a2),a0
	adda.w	$0(a0),a0
	bra.w	.next
.loop	adda.w	(a0),a0
	adda.w	#$8,a0
.next	dbra	d0,.loop
	rts
ConvertByteToDigits						;converts decimal number in d0 to ascii: two ascii digits of bcd byte d0
	
	move.w	d0,-(sp)
	lsr.b	#$4,d0
	bne.w	.n0
	move.b	#$F0,d0
.n0	addi.b	#$30,d0
	move.b	d0,(a1)+
	move.w	(sp)+,d0
	andi.w	#$F,d0
	addi.b	#$30,d0
	move.b	d0,(a1)+
	rts
; Address error screen: prints the error and the registers
AddressErrorScreen	bclr.b	#$5,$FF800F.l
	jsr	$39258.l
	dc.b	$00,$12,$BD,$00,$00,$41,$64,$64,$72,$65,$73,$73,$20,$45,$72,$72	; .....Address Err
	dc.b	$6F,$72	; or
	move.l	$A(sp),d0
	move.l	$2(sp),d1
	bra.w	ErrorScreenPrint
	dc.b	$08,$B9,$00,$05,$00,$FF,$80,$0F,$4E,$B9,$00,$03,$92,$58,$00,$18	; ........N....X..
	dc.b	$BD,$00,$00,$49,$6C,$6C,$65,$67,$61,$6C,$20,$49,$6E,$73,$74,$72	; ...Illegal Instr
	dc.b	$75,$63,$74,$69,$6F,$6E,$20,$2F,$00,$02,$22,$00,$60,$00,$00,$2C	; uction /..".`..,
	dc.b	$08,$B9,$00,$05,$00,$FF,$80,$0F,$4E,$B9,$00,$03,$92,$58,$00,$16	; ........N....X..
	dc.b	$BD,$00,$00,$44,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A	; ...Division by z
	dc.b	$65,$72,$6F,$00,$20,$2F,$00,$02,$22,$00	; ero. /..".
; Error screen: prints a long as hex
ErrorScreenPrint	movea.l	#$17EF2,a0
	move.w	#$18,(a0)+
	move.b	#$BD,(a0)+
	move.b	#$0,(a0)+
	move.b	#$2,(a0)+
	move.l	d1,-(sp)
	bsr.w	PrintHexLong
	move.b	#$BD,(a0)+
	move.b	#$0,(a0)+
	move.b	#$4,(a0)+
	move.l	(sp)+,d0
	bsr.w	PrintHexLong
	movea.l	#$17EF2,a1
	jsr	$3926A.l
	movea.l	#$C00000,a0
.loop	btst.b	#$7,$FF800E.l
	bne.s	.loop
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop2	btst.b	#$6,$FF800E.l
	beq.s	.loop2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	bne.s	.loop3
	bclr.b	#$7,$FF800F.l
.loop4	btst.b	#$7,$FF800E.l
	bne.s	.loop4
	move.w	#$9206,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop5	btst.b	#$6,$FF800E.l
	beq.s	.loop5
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	bne.s	.loop6
	bclr.b	#$7,$FF800F.l
.loop7	btst.b	#$7,$FF800E.l
	bne.s	.loop7
	move.w	#$8F02,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop8	btst.b	#$6,$FF800E.l
	beq.s	.loop8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop9	btst.b	#$6,$FF800E.l
	bne.s	.loop9
	bclr.b	#$7,$FF800F.l
.loop10	btst.b	#$7,$FF800E.l
	bne.s	.loop10
	move.l	#$C0200000,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop11	btst.b	#$6,$FF800E.l
	beq.s	.loop11
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop12	btst.b	#$6,$FF800E.l
	bne.s	.loop12
	bclr.b	#$7,$FF800F.l
	movea.l	$47D18.l,a1
	adda.l	(a1),a1
	adda.w	#$20,a1
	moveq	#$7,d0
.loop13	btst.b	#$7,$FF800E.l
	bne.s	.loop13
	move.l	(a1)+,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop14	btst.b	#$6,$FF800E.l
	beq.s	.loop14
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop15	btst.b	#$6,$FF800E.l
	bne.s	.loop15
	bclr.b	#$7,$FF800F.l
	dbra	d0,.loop13
.next	bra.w	.next
; Prints d0 as 8 hex digits
PrintHexLong	moveq	#$7,d2
.loop	rol.l	#$4,d0
	move.w	d0,d1
	andi.w	#$F,d1
	addi.w	#$30,d1
	cmpi.w	#$39,d1
	ble.w	.next
	addi.w	#$7,d1
.next	move.b	d1,(a0)+
	dbra	d2,.loop
	rts