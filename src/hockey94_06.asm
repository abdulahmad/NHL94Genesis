;	NHL 94 (retail) segment $169FA-$17A17
;	92 hockey.asm part 3, first half, as 93 hockey93_06.asm: setupice, setupice_highlight, setupIceRinkMap, setupEASNmap, the
;	94-only tile reloads (sub_16CC4 ... sub_16D0A), setupTeamBlocksMap, CopyTeamBlockMapData, defaultsprites, defaultsprites2,
;	SprSort, resetplstuff, clearTeamStats, setteams, InitTeamSructure, SetTeamColors, PeriodOver, IntermissionStart, GameOver,
;	ExitToOpening, Opening, Opening2, PlayoffScreen and its helpers, PlayoffScreenText, then the 94-only text player
;	(sub_17718, sub_17730, sub_179D2) that the screen at sub_FCC76 uses. EASportsScreen (attract94) follows at $17A18.
;	There is no 93 ScoutingReport (hockey93_07) here: the listing has no ScoutingReport label.
;	Transcribed from lst/nhl94.bin.lst lines 53022-54525. Global names are the IDA names, or the 93 name where IDA has an auto
;	name (IDA name in an ;IDA: comment). Local labels are the IDA local names (_x -> .x) or the IDA address (loc_16A88 -> .16A88).
;	IDA gaps written from the retail bytes: each DecompressGraphicsWithCallback is followed by its 8 byte remap table (IDA shows
;	only the second long, as or.l d4,-$3211(a3)); the PlayoffScreen printz / printz2 strings (IDA ori.b / andi.b / cmp.b, and
;	the 'Press [ or ] to page' text as code) and the instructions IDA hid in them are written out.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi;
;	fixopcodes.js patches the cmp encoding after assembly.
;	Bits: disflags 0 dfok, 1 df32c, 2 dfng; sflags 0 sfpz, 1 sfpj, 7 sfhor; gmode 1 gmdir.

setupice	;set all variables, send non purgeable graphics, build sprite frame lists for ice rink. Called from StartGame and StartPer.
	;Decompresses the tile sets with DoDMA_clearCallbackPointer / DecompressGraphicsWithCallback. 94 loads RevRinkTiles in a reverse angle replay
	;(word_FFC2F4 bit 4) and calls sub_FEA52
	movem.l	d0-d7/a0-a6,-(sp)
	bset	#1,(disflags).w	;df32c
	move.w	#$C000,(VmMap2).w
	move.w	#6,(Map2col1).w
	move.w	#$DC00,(VSPRITES).w
	move.w	#$E000,(VmMap1).w
	move.w	#6,(Map1col1).w
	move.w	#$F000,(VmMap3).w
	move.w	#5,(Map3col1).w
	move.w	#$FC00,(VSCRLPM).w
	moveq	#0,d0
	bsr.w	setvram
	bclr	#0,(sflags).w	;sfpz
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w	;dfng
	clr.w	(Hpos).w
	clr.w	(Vpos).w
	move.w	#$7D0,(Oldrow).w
	st	(zamx).w
	move.w	#$800,d0
	move.w	(VmMap1).w,d1
	move.w	#$7FF,d2
	bsr.w	DoFill
	clr.w	d4
	move.w	d4,(rinkvrcset).w
	movea.l	#Rinktiles,a2
	btst	#4,(word_FFC2F4).w	;94 only: reverse angle replay
	beq.w	.16A88	;branch if not
	movea.l	#RevRinkTiles,a2
.16A88
	bsr.w	DoDMA_clearCallbackPointer
	jsr	(sub_FEA52).l	;94 only
	move.w	d4,(word_FFB020).w	;93 EASNcset
	bsr.w	setupEASNmap
	move.w	d4,(word_FFB016).w	;energy bar chars
	movea.l	#unk_AB928,a2
	bsr.w	DoDMA_clearCallbackPointer
	move.w	d4,(word_FFB01A).w	;crowd chars
	movea.l	#unk_A4B5C,a2
	bsr.w	DoDMA_clearCallbackPointer
	move.w	d4,(word_FFD6AC).w
	addi.w	#$32,d4
	move.w	d4,(word_FFB024).w
	bsr.w	defaultsprites
	bsr.w	setupIceRinkMap
	bsr.w	AddFramer
	move.w	d4,(word_FFB012).w	;93 smallfontchars
	movea.l	#unk_AAC5A,a2
	bsr.w	DecompressGraphicsWithCallback
	dc.l	$43434567,$89ABCDEF	;remap table (IDA: or.l d4,-$3211(a3); IDA dropped the first long)
	move.w	d4,(word_FFB010).w	;93 BigFontChars
	movea.l	#unk_A9A18,a2
	bsr.w	DecompressGraphicsWithCallback
	dc.l	$71234567,$89ABCDEF	;remap table (IDA: or.l d4,-$3211(a3); IDA dropped the first long)
	bsr.w	setupTeamBlocksMap
	move.w	d4,(ExtraChars).w
	btst	#1,(gmode).w	;gmdir: flip pfgoal for the 12 players
	beq.w	.16B20
	movea.w	#(SortCords-M68K_RAM),a3
	moveq	#$B,d0
.16B12
	bchg	#7,$62(a3)
	adda.w	#$80,a3
	dbf	d0,.16B12
.16B20
	bsr.w	SetTeamColors
	move.w	#$FFFF,(word_FFBE78).w
	move.w	#$FFFF,(word_FFBE86).w
	clr.l	(padcont).w
	clr.l	(dword_FFBE7E).w
	clr.l	(dword_FFBE82).w
	st	(c1playernum).w
	st	(c2playernum).w
	movea.w	#(DMAList-M68K_RAM),a5
	movea.w	#(Satt-M68K_RAM),a6
	moveq	#1,d6
	movea.w	#(pads-M68K_RAM),a3
	clr.w	d0
	clr.w	d1
	bsr.w	addframe2	;pads1 addframe
	adda.w	#$1C,a3
	bsr.w	addframe2	;pads2 addframe
	adda.w	#$1C,a3
	bsr.w	addframe2	;pads3 addframe
	adda.w	#$1C,a3
	bsr.w	addframe2	;center ice logo addframe
	adda.w	#$1C,a3
	bsr.w	addframe2	;stick/gloves addframe?
	adda.w	#$1C,a3
	bsr.w	addframe2	;?? addframe
	move.l	a5,(DMAlistend).w
	bsr.w	DoDMAlist
	move.w	(sp)+,(disflags).w
	move.l	#VBlank,(vbint).w	;video94_1 (IDA loc_15D9A)
	bclr	#0,(disflags).w
	bclr	#2,(disflags).w
	move	#$2300,sr
	movem.l	(sp)+,d0-d7/a0-a6
	rts
setupice_highlight	;IDA: sub_16BAC (93 name). Rebuild the rink sprites after a highlight replay without reloading tiles, then fade in. Uses the
	;sprite char start saved by setupice in word_FFB024. Called from StartHL2 (penalty94_2)
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	forceblack
	bclr	#0,(sflags).w
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	clr.w	(Hpos).w
	clr.w	(Vpos).w
	move.w	#$7D0,(Oldrow).w
	st	(zamx).w
	move.w	(word_FFB024).w,d4
	bsr.w	defaultsprites
	bsr.w	setupIceRinkMap
	btst	#1,(gmode).w
	beq.w	.16C00
	movea.w	#(SortCords-M68K_RAM),a3
	moveq	#$B,d0
.16BF2
	bchg	#7,$62(a3)
	adda.w	#$80,a3
	dbf	d0,.16BF2
.16C00
	bsr.w	SetTeamColors
	move.w	#$FFFF,(word_FFBE78).w
	move.w	#$FFFF,(word_FFBE86).w
	clr.l	(padcont).w
	clr.l	(dword_FFBE7E).w
	clr.l	(dword_FFBE82).w
	st	(c1playernum).w
	st	(c2playernum).w
	bsr.w	setupEASNmap
	movea.w	#(DMAList-M68K_RAM),a5
	movea.w	#(Satt-M68K_RAM),a6
	moveq	#1,d6
	movea.w	#(pads-M68K_RAM),a3
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
	move.l	a5,(DMAlistend).w
	bsr.w	DoDMAlist
	move.w	#$1C,(palcount).w
	move.w	(sp)+,(disflags).w
	move.l	#VBlank,(vbint).w	;video94_1 (IDA loc_15D9A)
	bclr	#0,(disflags).w
	bclr	#2,(disflags).w
	move	#$2300,sr
	movem.l	(sp)+,d0-d7/a0-a6
	rts
setupIceRinkMap	;IDA: sub_16C96 (93 name). Copy the ice rink palettes (pal 0&1, 16 longs) to palfadenew. Called from setupice, setupice_highlight and the stats screens
	movea.l	#Rinktilelist,a0
	adda.l	(a0),a0
	moveq	#$F,d0
	movea.w	#(palfadenew-M68K_RAM),a1
.16CA4
	move.l	(a0)+,(a1)+
	dbf	d0,.16CA4
	rts
setupEASNmap	;IDA: sub_16CAC (93 name). Decompress the easn logo tiles (unk_B3538, 93 EASNmap+8) to vram at word_FFB020 (93 EASNcset). Called from setupice, setupice_highlight and hockey94_02
	move.w	(word_FFB020).w,d4
	movea.l	#unk_B3538,a2
	bsr.w	DecompressGraphicsWithCallback
	dc.l	$71234567,$89ABCDEF	;remap table (IDA: or.l d4,-$3211(a3); IDA dropped the first long)
	rts
sub_16CC4	;94 only. Reload the energy bar tiles (unk_AB928) at word_FFB016. Called from the replay code (hockey94_02) and sub_9CDC
	move.w	(word_FFB016).w,d4
	movea.l	#unk_AB928,a2
	bra.w	DoDMA_clearCallbackPointer
sub_16CD2	;94 only. Reload the crowd tiles (unk_A4B5C) at word_FFB01A. Called from the replay code and sub_9CDC
	move.w	(word_FFB01A).w,d4
	movea.l	#unk_A4B5C,a2
	bra.w	DoDMA_clearCallbackPointer
sub_16CE0	;94 only. Reload the horizontal ref tiles (unk_5CF6C, 93 RefMap2+8) at ExtraChars. Called from PauseMode
	move.w	(ExtraChars).w,d4
	movea.l	#unk_5CF6C,a2
	bra.w	DoDMA_clearCallbackPointer
sub_16CEE	;94 only. Reload the ref tiles (unk_5C410, 93 RefsMap+8) at ExtraChars. Called from the replay code (hockey94_02)
	move.w	(ExtraChars).w,d4
	movea.l	#unk_5C410,a2
	bra.w	DoDMA_clearCallbackPointer
sub_16CFC	;94 only. Reload the face off tiles (unk_A78B6, 93 FaceOffSprites+8) at word_FFB01C. Called from the replay code
	move.w	(word_FFB01C).w,d4
	movea.l	#unk_A78B6,a2
	bra.w	DoDMA_clearCallbackPointer
sub_16D0A	;94 only. Reload the unk_55BFE tiles at ExtraChars. Called from the replay code (hockey94_02)
	move.w	(ExtraChars).w,d4
	movea.l	#unk_55BFE,a2
	bra.w	DoDMA_clearCallbackPointer
setupTeamBlocksMap	;IDA: sub_16D18 (93 name). Load the TeamBlocks map tiles (unk_ABA14) at d4+$2C (93 $30) and copy the home and visitor team
	;blocks to vram at word_FFB022 and word_FFB022+$16. d4 = 1st vram char; return d4 = word_FFB022+$2C. Called from setupice
	move.w	d4,(word_FFB022).w
	addi.w	#$2C,d4
	movea.w	#(unk_FFC334-M68K_RAM),a1
	movea.l	#unk_ABA14,a0
	lea	8(a0),a2
	bsr.w	DoDMA_clearCallbackPointer
	adda.l	4(a0),a0
	move.l	a0,-(sp)
	move.w	(HomeTeam).w,d0
	move.w	(word_FFB022).w,d1
	asl.w	#5,d1
	bsr.w	CopyTeamBlockMapData
	movea.l	(sp)+,a0
	move.w	(VisTeam).w,d0
	move.w	(word_FFB022).w,d1
	addi.w	#$16,d1
	asl.w	#5,d1
	bsr.w	CopyTeamBlockMapData
	move.w	(word_FFB022).w,d4
	addi.w	#$2C,d4
	rts
CopyTeamBlockMapData	;IDA: sub_16D64 (93 name). Copy one team's 22 block chars (94; 93 24) from the loaded tile set to vram at d1 by vram dma
	;(DoDMA_nd2), and store their map words at (a1)+. a0 = map data, d0 = team, d1 = vram address
	mulu.w	#$2C,d0
	lea	4(a0,d0.w),a0
	move.w	#$15,d3
.16D70
	moveq	#$20,d0
	move.w	d1,-(sp)
	move.b	(a0),(a1)
	andi.w	#$F800,(a1)
	lsr.w	#5,d1
	ori.w	#$8000,d1
	or.w	d1,(a1)+
	move.w	(sp)+,d1
	move.w	(a0)+,d2
	andi.w	#$7FF,d2
	add.w	(word_FFB022).w,d2
	addi.w	#$2C,d2
	asl.w	#5,d2
	bsr.w	DoDMA_nd2
	addi.w	#$20,d1
	dbf	d3,.16D70
	rts
defaultsprites	;allocate vram and assign char area for graphic structures. d4 = char area for data. Sets up the sso (4) and ffo (7) objects from
	;.listsso / .listffo, then jumps to defaultsprites2. Called from setupice and setupice_highlight
	movea.l	#.listsso,a2
	movea.w	#(sso-M68K_RAM),a3
	moveq	#3,d0	;#ssonum-1 into d0
.ssotop
	move.w	#$FFFF,8(a3)	;screen objects not locked to scroll of screen
	move.w	(a2)+,(a3)
	move.w	(a2)+,2(a3)
	move.w	(a2)+,6(a3)
	move.w	(a2)+,4(a3)
	move.w	d4,$12(a3)
	add.w	(a2)+,d4
	adda.w	#$14,a3	;#ssosize
	dbf	d0,.ssotop
	movea.l	#.listffo,a2
	movea.l	#pads,a3	;ffo
	moveq	#6,d0	;#ffonum-1
.ffotop
	st	8(a3)	;objects tied to screen scrolling (not players/net/puck)
	move.w	(a2)+,(a3)
	move.w	(a2)+,$14(a3)
	move.w	(a2)+,$18(a3)
	move.w	(a2)+,6(a3)
	move.w	(a2)+,4(a3)
	move.w	d4,$12(a3)
	add.w	(a2)+,d4
	adda.w	#$1C,a3	;#ffosize
	dbf	d0,.ffotop
	bra.w	defaultsprites2
.listsso
	dc.w	0	;xcord,ycord,frame,attribute,vram char size
	dc.w	0
	dc.w	0
	dc.w	0
	dc.w	9
	dc.w	0
	dc.w	0
	dc.w	0
	dc.w	0
	dc.w	9
	dc.w	0
	dc.w	0
	dc.w	0
	dc.w	0
	dc.w	9
	dc.w	0
	dc.w	0
	dc.w	0
	dc.w	0
	dc.w	9
.listffo
	dc.w	0	;xcord,ycord,zpos,frame,attribute,vram char size
	dc.w	0
	dc.w	$FFFF
	dc.w	$188	;SPFpad+2 frame (puck poss. star)
	dc.w	0
	dc.w	7
	dc.w	0
	dc.w	0
	dc.w	$FFFF
	dc.w	$186	;SPFpad+0 frame (joypad 1 star)
	dc.w	0
	dc.w	7
	dc.w	0
	dc.w	0
	dc.w	$FFFF
	dc.w	$187	;SPFpad+1 frame (joypad 2 star)
	dc.w	0
	dc.w	7
	dc.w	0
	dc.w	0
	dc.w	$FFFF
	dc.w	$189	;SPFPad+3 frame (replay cursor)
	dc.w	$8000
	dc.w	7
	dc.w	0
	dc.w	0
	dc.w	$FFFF
	dc.w	$34C	;SPFPad3 frame (joypad 3 star)
	dc.w	0
	dc.w	7
	dc.w	0
	dc.w	0
	dc.w	$FFFF
	dc.w	$34D	;SPFPad4 frame (joypad 4 star)
	dc.w	0
	dc.w	7
	dc.w	0
	dc.w	0
	dc.w	$FFFF
	dc.w	$161	;SPFgloves frame
	dc.w	0
	dc.w	5
defaultsprites2	;objects which are tied to screen scrolling and have velocity: the 16 SortCords objects from .list (players, puck, puck shadow, goal
	;nets ...), the OOlist and OOlistpos; then SprSort. Also called from setoptions
	clr.w	d6
	movea.w	#(OOlist-M68K_RAM),a1
	lea	.list(pc),a2
	movea.w	#(SortCords-M68K_RAM),a3
	movea.w	#(OOlistpos-M68K_RAM),a4
.16E94
	moveq	#$1F,d0
	movea.w	a3,a0
.16E98
	clr.l	(a0)+
	dbf	d0,.16E98
	move.w	d6,$52(a3)
	st	8(a3)
	st	$66(a3)
	move.w	(a2)+,(a3)
	move.w	(a2)+,$14(a3)
	move.w	(a2)+,$18(a3)
	move.w	(a2)+,6(a3)
	move.w	(a2)+,4(a3)
	move.w	d4,$12(a3)
	add.w	(a2)+,d4
	move.w	(a2)+,$4A(a3)
	move.w	(a2)+,$4C(a3)
	addq.w	#1,a2
	move.b	(a2)+,$38(a3)
	addq.w	#1,a2
	move.b	(a2)+,$62(a3)
	adda.w	#$80,a3
	asl.w	#1,d6
	move.b	d6,(a1)+
	lsr.w	#1,d6
	move.w	d6,(a4)+
	addq.w	#1,d6
	cmp.w	#$10,d6
	bne.s	.16E94
	bra.w	SprSort
.list
	dc.w	$180	;xcord,ycord,zcord,frame,att,crsize,radx,rady,asslist,pflags
	;home team
	dc.w	$C0
	dc.w	0
	dc.w	1
	dc.w	0
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$80
	dc.w	$FF38
	dc.w	$FF9C
	dc.w	0
	dc.w	1
	dc.w	0
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$80
	dc.w	$FF38
	dc.w	$FFB0
	dc.w	0
	dc.w	1
	dc.w	0
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$80
	dc.w	$FF38
	dc.w	$FFC4
	dc.w	0
	dc.w	1
	dc.w	0
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$80
	dc.w	$FF38
	dc.w	$FFD8
	dc.w	0
	dc.w	1
	dc.w	0
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$80
	dc.w	$FF38
	dc.w	$FFEC
	dc.w	0
	dc.w	1
	dc.w	0
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$80
	dc.w	$C0	;visitor team
	dc.w	$C0
	dc.w	0
	dc.w	1
	dc.w	1
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$40
	dc.w	$FF38
	dc.w	$28
	dc.w	0
	dc.w	1
	dc.w	1
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$40
	dc.w	$FF38
	dc.w	$3C
	dc.w	0
	dc.w	1
	dc.w	1
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$40
	dc.w	$FF38
	dc.w	$50
	dc.w	0
	dc.w	1
	dc.w	1
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$40
	dc.w	$FF38
	dc.w	$64
	dc.w	0
	dc.w	1
	dc.w	1
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$40
	dc.w	$FF38
	dc.w	$78
	dc.w	0
	dc.w	1
	dc.w	1
	dc.w	$14
	dc.w	8
	dc.w	4
	dc.w	0
	dc.w	$40
	dc.w	0	;goal net
	dc.w	$10C
	dc.w	0
	dc.w	$195
	dc.w	0
	dc.w	$B
	dc.w	$14
	dc.w	6
	dc.w	0
	dc.w	0
	dc.w	0	;goal net 2
	dc.w	$FEF4
	dc.w	0
	dc.w	$196
	dc.w	0
	dc.w	$11
	dc.w	$14
	dc.w	6
	dc.w	0
	dc.w	0
	dc.w	0	;puck
	dc.w	0
	dc.w	0
	dc.w	$18B
	dc.w	0
	dc.w	1
	dc.w	5
	dc.w	5
	dc.w	$18
	dc.w	1
	dc.w	0	;puck shadow
	dc.w	0
	dc.w	0
	dc.w	$18A
	dc.w	0
	dc.w	$11
	dc.w	3
	dc.w	3
	dc.w	$19
	dc.w	4
SprSort	;sort objects in struct SortObj and set corresponding tables for keeping them sorted later (Ylist, OOlist, OOlistpos)
	movem.l	d0-d4/a0-a2,-(sp)
	movea.l	#OOlistpos,a2
	movea.l	#Ylist,a1
	movea.l	#SortCords,a0
	move.w	#$F,d3	;Sortobjs -1
.loop0
	move.w	$14(a0),d4
	btst	#7,(sflags).w
	beq.w	.101
	move.w	(a0),d4
.101
	move.w	d4,(a1)+
	adda.w	#$80,a0
	dbf	d3,.loop0
	movea.l	#Ylist,a1
.17068
	clr.w	d4
	movea.l	#OOlist,a0
	move.w	#$E,d3
	clr.w	d0
	clr.w	d1
.17078
	move.b	(a0)+,d0
	move.b	(a0),d1
	move.w	0(a1,d0.w),d2
	cmp.w	0(a1,d1.w),d2
	ble.w	.170A2
	move.b	d0,(a0)
	move.b	d1,-1(a0)
	move.l	a0,d2
	subi.l	#OOlist,d2
	move.w	d2,0(a2,d0.w)
	subq.w	#1,d2
	move.w	d2,0(a2,d1.w)
	st	d4
.170A2
	dbf	d3,.17078
	tst.w	d4
	bne.s	.17068
	movem.l	(sp)+,d0-d4/a0-a2
	rts
resetplstuff	;reset team variables/and players on both teams. Called from puckfaceoff2, puckpenshot and StartHL2
	movem.l	d0-d2/a0-a3,-(sp)
	movea.w	#(HmShots-M68K_RAM),a2
	bsr.w	.top
	movea.w	#(AwShots-M68K_RAM),a2
	bsr.w	.top
	movem.l	(sp)+,d0-d2/a0-a3
	rts
.top
	bclr	#4,$30(a2)	;clear team offside bit
	moveq	#5,d2
	movea.w	$22(a2),a3	;tmsort
.loop
	clr.b	$63(a3)	;pflags2
	tst.w	$34(a3)	;check for goalie
	bmi.w	.next
	move.w	#$50C,d1
	bsr.w	SetSPA
	clr.w	$32(a3)	;impact
	clr.b	$5E(a3)	;nopuck
	andi.b	#$C2,$62(a3)	;2^pfteam + 2^pfgoal +2^pfna, pflags
.next
	adda.w	#$80,a3	;SCstruct size
	dbf	d2,.loop
	rts
clearTeamStats	;clear both team structs (2 x tmsize) but keep the first $1A0 bytes of each hot / cold table (HmShots+$1A2 / AwShots+$1A2, saved to
	;$FFFFD6D2 / $FFFFD872 and back) and word_FFC6F4 / word_FFCA58. Falls into setteams
	move.w	(word_FFC6F4).w,-(sp)
	move.w	(word_FFCA58).w,-(sp)
	movem.l	a1-a3,-(sp)
	move.w	#$19F,d0
	movea.l	#AwShots+$1A2,a1	;Hot/Cold table Away Team
	movea.l	#HmShots+$1A2,a0	;Hot/Cold table Home Team
	movea.l	#$FFFFD6D2,a2
	movea.l	#$FFFFD872,a3
.1712A
	move.b	(a0)+,(a2)+
	move.b	(a1)+,(a3)+
	dbf	d0,.1712A
	movem.l	(sp)+,a1-a3
	move.l	#$363,d0
	movea.w	#(HmShots-M68K_RAM),a0
.17140
	clr.b	(a0)+
	dbf	d0,.17140
	movea.w	#(AwShots-M68K_RAM),a0
	move.w	#$363,d0
.1714E
	clr.b	(a0)+
	dbf	d0,.1714E
	movem.l	a1-a3,-(sp)
	move.w	#$19F,d0
	movea.l	#AwShots+$1A2,a1
	movea.l	#HmShots+$1A2,a0
	movea.l	#$FFFFD6D2,a2
	movea.l	#$FFFFD872,a3
.17174
	move.b	(a2)+,(a0)+
	move.b	(a3)+,(a1)+
	dbf	d0,.17174
	movem.l	(sp)+,a1-a3
	move.w	(sp)+,(word_FFCA58).w
	move.w	(sp)+,(word_FFC6F4).w
	st	(byte_FFC768).w
	st	(byte_FFCACC).w
setteams	;IDA: sub_17190 (93 name). Use hometeam/visteam to set team structures (InitTeamSructure for each). Falls in from clearTeamStats, also called from sub_17AF4 (attract94)
	movem.l	d0/a0-a2,-(sp)
	movea.w	#(HmShots-M68K_RAM),a2
	move.w	(HomeTeam).w,d0
	move.w	#$B04A,$22(a2)
	bsr.w	InitTeamSructure
	movea.w	#(AwShots-M68K_RAM),a2
	move.w	(VisTeam).w,d0
	move.w	#$B34A,$22(a2)
	bsr.w	InitTeamSructure
	movem.l	(sp)+,d0/a0-a2
	rts
InitTeamSructure	;IDA: sub_171BE (93 name). Set up team struct a2 for team d0: store the team number at $28, the team data address (TeamList)
	;at $1E (tmdata), and copy the line sets to $16A (94: two layouts by OptLine)
	move.w	d0,$28(a2)
	movea.w	#$30E,a0	;TeamList
	asl.w	#2,d0
	move.l	0(a0,d0.w),$1E(a2)
	tst.w	(OptLine).w
	beq.w	.171F4
	movea.l	$1E(a2),a0
	adda.w	6(a0),a0
	lea	$16A(a2),a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	addq.w	#8,a0
	move.w	#$B,d0
.171EC
	move.l	(a0)+,(a1)+
	dbf	d0,.171EC
	rts
.171F4
	moveq	#$D,d0
	movea.l	$1E(a2),a0
	adda.w	6(a0),a0
	addq.w	#8,a0
	lea	$16A(a2),a1
.17204
	move.l	(a0)+,(a1)+
	dbf	d0,.17204
	rts
SetTeamColors	;IDA name (93 setplayercolors). Copy in correct color data for each team: .team for the home team, then falls in for the visitors.
	;Called from setupice, setupice_highlight, StartHL2 and sub_9CDC
	clr.w	d1
	movea.w	#(HmShots-M68K_RAM),a0
	bsr.w	.team
	moveq	#$20,d1
	adda.w	#$364,a0
.team	;IDA: sub_1721C. a0 = team struct, d1 = palette offset ($20 for the visitors)
	movea.l	$1E(a0),a2
	adda.w	2(a2),a2
	adda.w	d1,a2
	movea.w	#(unk_FFBD68-M68K_RAM),a1
	adda.w	d1,a1
	moveq	#7,d0
.1722E
	move.l	(a2)+,(a1)+
	dbf	d0,.1722E
	rts
PeriodOver	;what to do if period over. Branched to from puckfaceoff (logic94_4) when the clock runs out. After period 3 a tied game goes to
	;overtime (gsp 3), else the game is over (gsp 4); after overtime only a tied playoff game plays on. Falls into IntermissionStart
	addq.w	#1,(gsp).w
	bchg	#1,(gmode).w
	cmpi.w	#3,(gsp).w
	blt.w	.17274
	beq.w	.17262
	move.w	#3,(gsp).w
	tst.w	(OptPlayMode).w
	bne.w	.17262
	move.w	#4,(gsp).w
.17262
	move.w	(HmGoals).w,d0
	sub.w	(AwGoals).w,d0
	beq.w	.17274
	move.w	#4,(gsp).w
.17274
	bsr.w	forceblack
IntermissionStart	;IDA: loc_17278 (93 name; 93 IDA _sp). PeriodOver tail: reset the clock, song $79, ticker scores, playoff stats at the end
	;(AddPOStats), Intermission, then StartPer or GameOver. Also jumped to from StartGame (hockey94_01)
	jsr	(ResetClock).w	;hockey94_01
	move.w	d0,-(sp)
	move.w	(vcount).w,d0
.17282
	cmp.w	(vcount).w,d0
	beq.s	.17282
	jsr	(AllSndOff).l
	move.w	d0,-(sp)
	move.w	(vcount).w,d0
.17294
	cmp.w	(vcount).w,d0
	beq.s	.17294
	move.w	(sp)+,d0
	move.w	#$79,-(sp)
	bsr.w	song
	bsr.w	UpdateScores
	cmpi.w	#4,(gsp).w
	bne.w	.172B6
	bsr.w	AddPOStats
.172B6
	bsr.w	Intermission
	cmpi.w	#4,(gsp).w
	beq.w	GameOver
	jmp	(StartPer).w	;hockey94_01
GameOver	;IDA name (92 name). sub_180FC (93: save the password), then in playoff mode sub_9428 (93: the playoff stats) and the playoff screen. Falls into ExitToOpening
	bsr.w	sub_180FC
	tst.w	(OptPlayMode).w
	beq.w	.172E0
	bclr	#1,(sflags).w
	jsr	(sub_9428).l
.172E0
	bsr.w	PlayoffScreen
ExitToOpening	;IDA: loc_172E4 (93 name). Song $78, then restart at Opening2. Also jumped to from demoread (hockey94_01) and sub_FC4C0
	move.w	#$78,-(sp)
	bsr.w	song
	bra.w	Opening2
Opening	;title screen (newTitleScreen), then into Opening2. Jumped to from Begin (hockey94_01)
	bsr.w	KillCrowd
	jsr	(newTitleScreen).l
Opening2	;reset the stack and clear the variables, then options (GameSetUp, sub_FBB88), playoff screen and (not in a shootout) sub_FCC76, then StartGame
	bsr.w	KillCrowd
	move	#$2700,sr
	movea.w	#(Stack-M68K_RAM),sp
	movea.w	#(VSCRLPM-M68K_RAM),a0
.1730A
	clr.l	(a0)+
	cmpa.w	#$D03E,a0	;clear from VSCRLPM to $FFFFD03E
	blt.s	.1730A
	jsr	(GameSetUp).l
	jsr	(sub_FBB88).l
	bsr.w	PlayoffScreen
	btst	#0,(word_FFC2FA).w
	bne.w	.17332
	jsr	(sub_FCC76).l
.17332
	jmp	(StartGame).w	;hockey94_01
PlayoffScreen	;bring up playoff screen if in playoff mode. Called from GameOver and Opening2. Runs its own vblank (PlayoffScreenDataTable) and
	;scrolls the tree a page ($70 pixels) at a time. Returns when start is pressed (PlayoffScreenExit)
	tst.w	(OptPlayMode).w
	beq.w	rtss2
	move.l	#PlayoffScreenDataTable,(vbint).l
	bclr	#1,(disflags).w
	move.w	#0,(VSCRLPM).w
	move.w	#$BC00,(VSPRITES).w
	move.w	#$B000,(VmMap3).w
	move.w	#6,(Map3col1).w
	move.w	#$C000,(VmMap2).w
	move.w	#7,(Map2col1).w
	move.w	#$E000,(VmMap1).w
	move.w	#7,(Map1col1).w
	move.w	#0,d0
	bsr.w	setvram
	bsr.w	printz
	String	$FF,0,0
	move.l	#$80,d0		;IDA hid this in the string (ori.b x3)
	moveq	#$1C,d1
	move.w	#$7FF,d2
	bsr.w	eraser
	bsr.w	printz
	String	$FD,0,0
	moveq	#$28,d0		;IDA hid this in the string (ori.b x2)
	moveq	#2,d1
	move.w	#$7FF,d2
	bsr.w	eraser
	bsr.w	AddTeamBlock
	bsr.w	AddSmallFont
	movea.l	#unk_B3648,a2
	move.w	d4,(ExtraChars).w
	bsr.w	DoDMA_clearCallbackPointer
	bsr.w	printz
	String	$CE,0,0
	movea.l	#unk_54E24,a0	;IDA hid this in the string (ori.b x3)
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#3,d5
	bsr.w	dobitmap
	movea.l	#unk_F3098,a1
	lea	8(a1),a2
	adda.l	(a1),a1
	moveq	#7,d0
	movea.w	#(unk_FFBD68-M68K_RAM),a0
.17406
	move.l	-$40(a0),$20(a0)
	move.l	(a1)+,-$40(a0)
	move.l	-$20(a0),(a0)+
	dbf	d0,.17406
	move.w	d4,(word_FFB016).w
	bsr.w	DoDMA_clearCallbackPointer
	move.w	#$104,(word_FFB8B2).w
	move.w	#$A0,(word_FFB8B0).w
	movea.l	#VDP_CTRL,a0
	move.w	#$9202,(a0)
	movea.w	#(unk_FFCEF4-M68K_RAM),a1
	movea.l	#unk_1928E,a0	;playoff tree layout by gamelevel
	move.w	(gamelevel).w,d0
	asl.w	#1,d0
	adda.w	0(a0,d0.w),a0
	clr.w	d4
	move.b	(a0)+,d4
.1744E
	bsr.w	printz
	String	$FF,0,0
	move.b	(a0)+,(printx+1).w	;IDA hid these three in the string (ori.b x2, cmp.b x2)
	move.b	(a0)+,(printy+1).w
	clr.w	d1
	move.b	(a1)+,d1
	add.w	d1,d1
	bsr.w	DrawTeamBlocks
	dbf	d4,.1744E
	clr.w	d4
	move.b	(a0)+,d4
.17472
	bsr.w	printz
	String	$FF,0,2
	move.b	(a0)+,(printx+1).w	;IDA hid these two in the string (ori.b / andi.b / cmp.b)
	clr.w	d0
	move.b	(a0)+,d0
	bsr.w	DrawPlayoffBracket
	dbf	d4,.17472
	bsr.w	printz
	String	$EF,0,0
	cmpi.w	#7,(bosgames).w	;IDA hid this in the string (ori.b x3). Best of 7
	beq.w	.174C0
	clr.w	d4
	move.b	(a0)+,d4
	bmi.w	.174C0
	movea.w	#(gsstruct-M68K_RAM),a2
.174AC
	move.b	(a0)+,(printx+1).w
	move.b	(a0)+,(printy+1).w
	bsr.w	FormatScore
	adda.w	#$10,a2
	dbf	d4,.174AC
.174C0
	bsr.w	printz2
	String	$F8,1,1,$41,$1A	;IDA: ori.b / bchg / move.b
	lea	PlayoffScreenText(pc),a1
	move.w	(gamelevel).w,d0
	bsr.w	Adda1Offset
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	bsr.w	print2
	tst.w	(gamelevel).w
	beq.w	.1750A		;IDA: loc_17508+2
	bsr.w	printz
	String	$CD,$A,1,'Press [ or ] to page',0	;IDA decoded the text as code
.1750A
	move.w	#$18,(palcount).w	;IDA hid this after the string (bcs.w / ori.b)
	move.w	#$79,-(sp)
	bsr.w	song
	clr.w	d0
	clr.w	d4
	move.w	#$FFFF,(PlayerScrollCtr).w
	move.w	#1,(DispAttribCtr).w
	bsr.w	UpdatePlayoffScroll
.1752C
	bsr.w	PlayoffScreen_waitvsync
	movea.l	#rtss2,a0
	jsr	(sub_FED2A).l	;94 only
	bsr.w	HandlePlayoffInput
	bra.s	.1752C
HandlePlayoffInput	;IDA: sub_17542 (93 name). Read both pads: start leaves PlayoffScreen (PlayoffScreenExit), right/left set the scroll step, then falls into UpdatePlayoffScroll
	bsr.w	ReadJoy1
	move.w	d3,-(sp)
	bsr.w	ReadJoy2
	or.w	(sp)+,d3
	btst	#7,d3
	bne.w	PlayoffScreenExit
	btst	#3,d3
	beq.w	.17564
	move.w	#$FFFE,(PlayerScrollCtr).w
.17564
	btst	#2,d3
	beq.w	UpdatePlayoffScroll
	move.w	#2,(PlayerScrollCtr).w
UpdatePlayoffScroll	;IDA: sub_17572 (93 name). Move the tree one step (PlayerScrollCtr) and stop on a page boundary ($70). The position is
	;DispAttribCtr; word_FFB8AE is the sprite x offset while it is on screen
	move.w	(PlayerScrollCtr).w,d0
	beq.w	rtss2
	add.w	(DispAttribCtr).w,d0
	move.w	(gamelevel).w,d1
	cmp.w	#3,d1
	bls.w	.1758C
	moveq	#3,d1
.1758C
	mulu.w	#$70,d1
	cmp.w	d1,d0
	bgt.w	rtss2
	neg.w	d1
	cmp.w	d1,d0
	blt.w	rtss2
	move.w	d0,(DispAttribCtr).w
	clr.w	(word_FFB8AE).w
	move.w	d0,d1
	addi.w	#$100,d1
	cmp.w	#$40,d1
	blt.w	.175C0
	cmp.w	#$200,d1
	bgt.w	.175C0
	move.w	d1,(word_FFB8AE).w
.175C0
	ext.l	d0
	divs.w	#$70,d0
	swap	d0
	tst.w	d0
	bne.w	rtss2
	clr.w	(PlayerScrollCtr).w
	rts
PlayoffScreenExit	;IDA: loc_175D4 (93 name). Drop HandlePlayoffInput's return address and return from PlayoffScreen
	addq.w	#4,sp
	rts
PlayoffScreen_waitvsync	;IDA: sub_175D8 (93 name). Each time palcount runs out, eor the color word at word_FFBD6A with $EE and restart palcount at $18; then wait for the next vblank
	tst.w	(palcount).w
	bpl.w	.175EC
	eori.w	#$EE,(word_FFBD6A).w
	move.w	#$18,(palcount).w
.175EC
	move.w	(vcount).w,d0
	cmp.w	(oldvcount).w,d0
	beq.s	.175EC
	move.w	d0,(oldvcount).w
	rts
FormatScore	;IDA: sub_175FC (93 name). Print best of 7 wins "t-b" for game struct a2 at printx/printy
	movea.w	#(mesarea-M68K_RAM),a1
	move.w	#6,(a1)+
	move.w	4(a2),d0
	addi.w	#$30,d0
	move.b	d0,(a1)+
	move.b	#$2D,(a1)+
	move.w	6(a2),d0
	addi.w	#$30,d0
	move.b	d0,(a1)+
	clr.b	(a1)+
	movea.w	#(mesarea-M68K_RAM),a1
	bra.w	print
DrawPlayoffBracket	;IDA: sub_17626 (93 name). Draw tree arrow d0 from the arrows map (unk_B3640) at printx/printy
	movem.l	d0-d7/a0-a3,-(sp)
	movea.l	#unk_B3640,a0
	movea.l	a0,a1
	adda.l	(a0),a0
	adda.l	4(a1),a1
	movea.w	#$30A,a2
	clr.w	d1
	moveq	#2,d2
	moveq	#$17,d3
	move.w	(ExtraChars).w,d4
	moveq	#0,d5
	bsr.w	dobitmap
	movem.l	(sp)+,d0-d7/a0-a3
	rts
DrawTeamBlocks	;IDA: sub_17652 (93 name). Draw team block d1 (team*2) from the TeamBlocks map (unk_ABA14) at printx/printy; the user's team
	;(potreeteam entry of unk_FFCEF4) is highlighted (printa $6000)
	movem.l	d0-d7/a0-a3,-(sp)
	movea.w	#(unk_FFCEF4-M68K_RAM),a0
	move.w	(potreeteam).w,d0
	move.b	0(a0,d0.w),d0
	add.b	d0,d0
	cmp.b	d0,d1
	bne.w	.17670
	move.w	#$6000,(printa).w
.17670
	movea.l	#unk_ABA14,a1
	adda.l	4(a1),a1
	movea.w	#$30A,a2
	clr.w	d0
	move.w	(a1),d2
	moveq	#2,d3
	moveq	#2,d4
	moveq	#0,d5
	bsr.w	dobitmap
	movem.l	(sp)+,d0-d7/a0-a3
	rts
PlayoffScreenDataTable	;IDA: loc_17692 (93 name; 93 IDA left it undecoded). The PlayoffScreen vblank handler (vbint): dma the sprite table, write
	;$FEA0+DispAttribCtr to the hscroll, cramfade. Always vcount+1, MusicVB, rte
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#2,(disflags).w
	bne.w	.176CE
	movea.w	#(Satt-M68K_RAM),a0
	move.w	(word_FFC2E8).w,d0
	beq.w	.176CA
	clr.w	(word_FFC2E8).w
	move.w	(VSPRITES).w,d1
	bsr.w	DoDMA
	move.w	(VSCRLPM).w,d0
	bsr.w	Vmaddr
	move.w	#$FEA0,d0
	add.w	(DispAttribCtr).w,d0
	move.w	d0,(a0)
.176CA
	bsr.w	cramfade
.176CE
	addq.w	#1,(vcount).w
	jsr	(MusicVB).l
	movem.l	(sp)+,d0-d7/a0-a6
	rte
PlayoffScreenText	;IDA: unk_176DE (93 name). Round titles by gamelevel, printed with print2
	String	'Playoffs'
	String	'Quarterfinals'
	String	'Semifinals'
	String	'Finals'
	String	'Champions'
sub_17718	;94 only. Start the text player sub_17730: VertLineScrolling = -1, PlayerScrollCtr = -1, clear word_FFD5B2 / word_FFD5B4; return a0 = word_FFD5B8. Called from sub_FCC76
	move.w	#$FFFF,(VertLineScrolling).w
	st	(PlayerScrollCtr).w
	clr.w	(word_FFD5B2).w
	clr.w	(word_FFD5B4).w
	movea.w	#(word_FFD5B8-M68K_RAM),a0
	rts
sub_17730	;94 only. Text player for the screen at sub_FCC76: prints the unk_4B5C0 script word by word with a typing delay (word_FFD5B4, longer
	;after , and .). $D ends a line; special characters ( _ + $ { } [ ] < > | \ @ # % = * ^ ; ) insert team data through the $FCxxx-$FExxx
	;routines (sub_FD5AE / sub_FD5F4 for HmShots / AwShots). Line breaks scroll the text box (sub_179D2). Called from sub_FCC76
	cmpi.w	#$1000,(word_FFD5B4).w
	bgt.w	rtss2
	tst.w	(asv).w
	bmi.w	.1774A
	subq.w	#1,(word_FFD5B4).w
	bpl.w	rtss2
.1774A
	movea.l	#unk_4B5C0,a1
	move.w	(PlayerScrollCtr).w,d0
	bpl.w	.17796
	clr.w	(DispAttribCtr).w
	move.w	(word_FFD5B2).w,d0
	addq.w	#2,(word_FFD5B2).w
	movea.w	#(word_FFD5B8-M68K_RAM),a0
	move.w	0(a0,d0.w),d0
	bpl.w	.1777E
	move.w	#$7FFF,(word_FFD5B4).w
	move.w	#$1E0,(word_FFD5B6).w
	rts
.1777E
	bsr.w	sub_179D2
	movea.l	a1,a2
	bra.w	.1778E
.17788
	cmpi.b	#$D,(a2)+
	bne.s	.17788
.1778E
	dbf	d0,.17788
	suba.l	a1,a2
	move.w	a2,d0
.17796
	lea	0(a1,d0.w),a2
	move.w	#$A,(word_FFD5B4).w
	move.w	(DispAttribCtr).w,d0
	cmpi.b	#$5F,(a2)
	beq.w	.179B0
	cmpi.b	#$2B,(a2)
	beq.w	.1799C
	cmpi.b	#$24,(a2)
	beq.w	.17956
	cmpi.b	#$7B,(a2)
	beq.w	.179B0
	cmpi.b	#$7D,(a2)
	beq.w	.179A8
	cmpi.b	#$5B,(a2)
	beq.w	.1797E
	cmpi.b	#$5D,(a2)
	beq.w	.17976
	cmpi.b	#$3C,(a2)
	beq.w	.1792E
	cmpi.b	#$3E,(a2)
	beq.w	.17938
	cmpi.b	#$7C,(a2)
	beq.w	.17942
	cmpi.b	#$5C,(a2)
	beq.w	.1794C
	cmpi.b	#$40,(a2)
	beq.w	.178C0
	cmpi.b	#$23,(a2)
	beq.w	.178CA
	cmpi.b	#$25,(a2)
	beq.w	.178D4
	cmpi.b	#$3D,(a2)
	beq.w	.178DE
	cmpi.b	#$2A,(a2)
	beq.w	.178F2
	cmpi.b	#$5E,(a2)
	beq.w	.17906
	cmpi.b	#$3B,(a2)
	beq.w	.1791A
	st	(PlayerScrollCtr).w
	movea.w	#(word_FFBFA6-M68K_RAM),a0
	clr.w	d1
.1783E
	cmpi.b	#$D,(a2)
	beq.w	.17876
	addq.w	#1,d0
.17848
	move.b	(a2),(a0)+
	addq.w	#1,d1
	cmpi.b	#$2C,(a2)
	beq.w	.1785C
	cmpi.b	#$2E,(a2)
	bne.w	.17862
.1785C
	addi.w	#$28,(word_FFD5B4).w
.17862
	cmpi.b	#$20,(a2)+
	bne.s	.1783E
	cmpi.b	#$20,(a2)
	beq.s	.17848
	subq.w	#1,d0
	suba.w	a1,a2
	move.w	a2,(PlayerScrollCtr).w
.17876
	move.w	d1,(mesarea).w
	addq.w	#2,(mesarea).w
	btst	#0,d1
	beq.w	.1788C
	clr.b	(a0)
	addq.w	#1,(mesarea).w
.1788C
	movea.w	#(mesarea-M68K_RAM),a1
.17890
	cmp.w	#$1D,d0
	ble.w	.1789C
	bsr.w	sub_179D2
.1789C
	bsr.w	printz
	String	$FF,9,4
	move.w	(DispAttribCtr).w,d0
	add.w	d0,(printx).w
	move.w	(VertLineScrolling).w,d0
	add.w	d0,(printy).w
	bsr.w	print
	add.w	d1,(DispAttribCtr).w
	rts
.178C0
	jsr	(sub_FCB9A).l
	bra.w	.179B8
.178CA
	jsr	(sub_FEEC8).l
	bra.w	.179B8
.178D4
	jsr	(sub_FEF5A).l
	bra.w	.179B8
.178DE
	move.l	a2,-(sp)
	movea.l	#HmShots,a2
	jsr	(sub_FD5AE).l
	movea.l	(sp)+,a2
	bra.w	.179B8
.178F2
	move.l	a2,-(sp)
	movea.l	#AwShots,a2
	jsr	(sub_FD5AE).l
	movea.l	(sp)+,a2
	bra.w	.179B8
.17906
	move.l	a2,-(sp)
	movea.l	#HmShots,a2
	jsr	(sub_FD5F4).l
	movea.l	(sp)+,a2
	bra.w	.179B8
.1791A
	move.l	a2,-(sp)
	movea.l	#AwShots,a2
	jsr	(sub_FD5F4).l
	movea.l	(sp)+,a2
	bra.w	.179B8
.1792E
	jsr	(sub_F7144).l
	bra.w	.17986
.17938
	jsr	(sub_F7172).l
	bra.w	.17986
.17942
	jsr	(sub_F727C).l
	bra.w	.17986
.1794C
	jsr	(sub_F72AA).l
	bra.w	.17986
.17956
	movea.l	#HmShots,a1
	tst.w	(word_FFBF50).w
	beq.w	.1796A
	movea.l	#AwShots,a1
.1796A
	movea.l	$1E(a1),a1
	adda.w	4(a1),a1
	bra.w	.179B8
.17976
	movea.w	#(AwShots-M68K_RAM),a1
	bra.w	.17982
.1797E
	movea.w	#(HmShots-M68K_RAM),a1
.17982
	move.w	$26(a1),d1
.17986
	movea.l	$1E(a1),a1
	adda.w	(a1),a1
	bra.w	.17994
.17990
	adda.w	(a1),a1
	addq.w	#8,a1
.17994
	dbf	d1,.17990
	bra.w	.179B8
.1799C
	movea.l	(dword_FFCA50).w,a1
	adda.w	4(a1),a1
	bra.w	.179B8
.179A8
	movea.l	(dword_FFCA50).w,a1
	bra.w	.179B4
.179B0
	movea.l	(dword_FFC6EC).w,a1
.179B4
	adda.w	4(a1),a1
.179B8
	addq.w	#1,(PlayerScrollCtr).w
	add.w	(a1),d0
	subq.w	#1,d0
	move.w	(a1),d1
	subq.w	#2,d1
	tst.b	1(a1,d1.w)
	bne.w	.17890
	subq.w	#1,d1
	bra.w	.17890
sub_179D2	;94 only. Next text line for sub_17730: VertLineScrolling + 1; at 7 lines, scroll the 8 rows up by vram dma (DoDMA_nd2)
	clr.w	(DispAttribCtr).w
	addq.w	#1,(VertLineScrolling).w
	cmpi.w	#7,(VertLineScrolling).l
	blt.w	rtss2
	subq.w	#1,(VertLineScrolling).w
	movem.l	d0-d3,-(sp)
	move.l	#7,d3
	move.w	(VmMap1).w,d1
	addi.w	#$212,d1
.179FC
	move.l	#$3A,d0
	move.w	d1,d2
	addi.w	#$80,d2
	bsr.w	DoDMA_nd2
	move.w	d2,d1
	dbf	d3,.179FC
	movem.l	(sp)+,d0-d3
	rts
