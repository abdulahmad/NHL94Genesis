;	HOCKEY.BIN $2391C-$2486B (runtime $3E91C-$3F86B): setup94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Part 1 of setup94 (ice setup, attract, menus). $2486C-$24C09 after it is src/segacd/scouttext.asm
;	and scouttok.asm.

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

null	equ	$1B008
TeamList	equ	$1B00C
GameSetUp	equ	$233CC
UserNameEntry	equ	$2702C
LoadHomeTeamGfx	equ	$2A9D0
DrawPlayoffSprite	equ	$2ACD2
StartGame	equ	$2B7F8
PlayoffStatsScreen	equ	$2DE18
DoDMA_nd2	equ	$379D6
DoFill	equ	$37AA2
setVram	equ	$37B5A
dobitmap	equ	$387E2
DecompressGraphicsWithRemap	equ	$38946
DecompressGraphicsPlain	equ	$38958
eraser	equ	$38C06
printsmallz	equ	$38D8C
printsmall	equ	$38D9E
printz	equ	$38F6E
print	equ	$38F80
AddSmallFont	equ	$393E8
AddFramer	equ	$393FA
AddTeamBlock	equ	$3940C
rtss2	equ	$3C000
AdvanceStringPtr	equ	$3CEC6
VBlank	equ	$3DAB8
addframe2	equ	$3E6E6
EncodePW	equ	$4065C
PlayoffScreen_setup	equ	$41ADE
SetSPA	equ	$363C0
forceblack	equ	$36D0A
cramfade	equ	$36DF6
ReadJoy1	equ	$374F0
ReadJoy2	equ	$3750E
X_38780	equ	$38780
vb2	equ	$3DB90
X_3DBF0	equ	$3DBF0
X_3FC0C	equ	$3FC0C
SPAglide	equ	$50C
SPFgloves	equ	$161
SPFgoal	equ	$195
SPFpad	equ	$186
SPFpuck	equ	$18A
SPFreplay	equ	$189

	org	$3E91C

;	Rink and team setup, the EA Sports attract screen, and the menu and playoff data. This file lays
;	down the ice, sets up the sprites and the teams, runs the flow between periods, and packs playoff
;	results into the password.


setupice							;set all variables, send non purgeable graphics, build sprite frame lists
									;for ice rink. Called from StartGame and StartPer.
									;Decompresses the tile sets with DecompressGraphicsPlain /
									;DecompressGraphicsWithRemap. Loads RevRinkTiles in a reverse angle
									;replay (sflags4 bit 4) and calls LoadHomeTeamGfx
	movem.l	d0-d7/a0-a6,-(sp)
	bset.b	#df32c,(disflags).l		;32 cell mode
	move.w	#$C000,(VmMAP2).l
	move.w	#6,(Map2col).l
	move.w	#$DC00,(VSPRITES).l
	move.w	#$E000,(VmMAP1).l
	move.w	#6,(Map1col).l			;map 1 width (same as 2 always)
	move.w	#$F000,(VmMAP3).l
	move.w	#5,(Map3col).l			;map 3 width (dependent on df32c mode)
	move.w	#$FC00,$18D30.l			;CD: the cartridge has (VSCRLPM).w
	moveq	#0,d0					;color to fade to
	bsr.w	setVram
	bclr.b	#sfpz,(sflags).l
	move.w	(disflags).l,-(sp)
	bset.b	#dfng,(disflags).l
	clr.w	(Hpos).l
	clr.w	(Vpos).l
	move.w	#$7D0,(Oldrow).l
	st.b	(Zamx).l
	move.w	#$800,d0				;$800 cells
	move.w	(VmMAP1).l,d1
	move.w	#$7FF,d2				;blank char
	bsr.w	DoFill
	clr.w	d4
	move.w	d4,(rinkvrcset).l		;1st vram char for rink map tiles
;CD: no cartridge twin
	movea.l	(RinktilelistPtr).l,a2
	addq.l	#$8,a2
	btst.b	#$4,(sflags4).l
	beq.w	.0
	movea.l	(RevRinkTilelistPtr).l,a2
	addq.l	#$8,a2
.0									;normal or reverse rink tiles chosen
	bsr.w	DecompressGraphicsPlain	;tiles to vram at d4, d4 advanced past them
	jsr	(LoadHomeTeamGfx).l
	move.w	d4,(EASNcset).l			;1st vram char for easn logo tiles
	bsr.w	setupEASportsMap
	move.w	d4,(energybarchars).l
;CD: no cartridge twin
	movea.l	(EnergyBarMapPtr).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	move.w	d4,(crowdvrcset).l
	movea.l	(CrowdSpritesPtr).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	move.w	d4,(arenaanimchars).l
	addi.w	#$32,d4
	move.w	d4,(spritechars).l		;sprite char start, reused by setupice_highlight
	bsr.w	defaultsprites
;CD: no cartridge twin
	move.w	d4,$18C1C.l
	bsr.w	setupIceRinkPal
	bsr.w	AddFramer				;frame tiles
	move.w	d4,(smallfontchars).l	;1st vram char for smallfont tiles
;CD: no cartridge twin
	movea.l	(SmallFontMapPtr).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsWithRemap
	dc.l	$43434567,$89ABCDEF		;remap table
	move.w	d4,(BigFontchars).l		;1st vram char for Bigfont tiles
;CD: no cartridge twin
	movea.l	(BigFontMapPtr).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsWithRemap
	dc.l	$71234567,$89ABCDEF		;remap table
	bsr.w	setupTeamBlocksMap		;team blocks for both teams
	move.w	d4,(ExtraChars).l		;char space for extra graphics
	btst.b	#gmdir,(gmode).l		;gmdir: flip pfgoal for the 12 players
	beq.w	.gok
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
	moveq	#$B,d0
.loop								;flip each player's goal
	bchg.b	#pfgoal,pflags(a3)
	adda.w	#SCstruct,a3
	dbf	d0,.loop					;loop
.gok								;goals set for this period's direction
	bsr.w	setplayercolors
	move.w	#$FFFF,(PadControlBits).l	;no pad assignments
	move.w	#$FFFF,(PadControlBits34).l	;pads 3 and 4 off
	clr.l	(padcont).l
	clr.l	(padcont+4).l
	clr.l	(padcont+8).l
	st.b	(c1playernum).l			;no player for pad 1
	st.b	(c2playernum).l			;no player for pad 2
	movea.l	#$18D6A,a5				;dump pad sprites so numbers (CD: the cartridge has #(DMAList-M68K_RAM))
	movea.l	#(Satt-M68K_RAM),a6		;aren't written over later.
	moveq	#1,d6					;1 frame
	movea.l	#(pads-M68K_RAM),a3
	clr.w	d0
	clr.w	d1
	bsr.w	addframe2				;pads1 addframe
	adda.w	#ffosize,a3
	bsr.w	addframe2				;pads2 addframe
	adda.w	#ffosize,a3
	bsr.w	addframe2				;pads3 addframe
	adda.w	#ffosize,a3
	bsr.w	addframe2				;center ice logo addframe
	adda.w	#ffosize,a3
	bsr.w	addframe2				;stick/gloves addframe?
	adda.w	#ffosize,a3
	bsr.w	addframe2				;?? addframe
	move.l	a5,(DMAlistend).l		;end of the DMA list
	bsr.w	X_3DBF0					;CD: the cartridge has dodmalist
	move.w	(sp)+,(disflags).l		;(palcount is set in setupice_highlight only)
	move.l	#VBlank,(VBint).l
	bclr.b	#dfok,(disflags).l		;graphics not ready
	bclr.b	#dfng,(disflags).l
;CD: no cartridge twin
	bset.b	#$5,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
setupice_highlight					;Rebuild the rink sprites after a highlight replay without reloading
									;tiles, then fade in. Uses the sprite char start saved by setupice in
									;spritechars. Called from StartHL2
	movem.l	d0-d7/a0-a6,-(sp)
;CD: no cartridge twin
	jsr	(forceblack).l
	bclr.b	#sfpz,(sflags).l
	move.w	(disflags).l,-(sp)
	bset.b	#dfng,(disflags).l
	clr.w	(Hpos).l
	clr.w	(Vpos).l
	move.w	#$7D0,(Oldrow).l
	st.b	(Zamx).l
	move.w	(spritechars).l,d4		;sprite char start from setupice
	bsr.w	defaultsprites
	bsr.w	setupIceRinkPal
	btst.b	#gmdir,(gmode).l
	beq.w	.gok
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
	moveq	#$B,d0
.loop								;flip each player's goal
	bchg.b	#pfgoal,pflags(a3)
	adda.w	#SCstruct,a3
	dbf	d0,.loop
.gok								;goals set for this period's direction
	bsr.w	setplayercolors
	move.w	#$FFFF,(PadControlBits).l	;no pad assignments
	move.w	#$FFFF,(PadControlBits34).l	;no pad assignments for pads 3 and 4
	clr.l	(padcont).l				;clear the pad readings
	clr.l	(padcont+4).l
	clr.l	(padcont+8).l
	st.b	(c1playernum).l			;pad 1 controls no player
	st.b	(c2playernum).l			;pad 2 controls no player
	bsr.w	setupEASportsMap		;easn tiles at EASNcset again
	movea.l	#$18D6A,a5				;dump pad sprites (CD: the cartridge has #(DMAList-M68K_RAM))
	movea.l	#(Satt-M68K_RAM),a6		;sprite attribute table
	moveq	#1,d6					;link counter
	movea.l	#(pads-M68K_RAM),a3		;the 6 pad (scrolled) objects
	clr.w	d0
	clr.w	d1
	bsr.w	addframe2
	adda.w	#ffosize,a3
	bsr.w	addframe2
	adda.w	#ffosize,a3
	bsr.w	addframe2
	adda.w	#ffosize,a3
	bsr.w	addframe2
	adda.w	#ffosize,a3
	bsr.w	addframe2
	adda.w	#ffosize,a3
	bsr.w	addframe2
	move.l	a5,(DMAlistend).l		;end of the queued dma
	bsr.w	X_3DBF0					;CD: the cartridge has dodmalist
	move.w	#$1C,(palcount).l		;fade in new graphics now
	move.w	(sp)+,(disflags).l
	move.l	#VBlank,(VBint).l
	bclr.b	#dfok,(disflags).l
	bclr.b	#dfng,(disflags).l
;CD: no cartridge twin
	bset.b	#$5,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
setupIceRinkPal						;CD: placed where the disc branches to it
	movea.l	(RinktilelistPtr).l,a0
	adda.l	(a0),a0					;palette offset in the map header
	moveq	#$F,d0
	movea.l	#$BBCB0,a1				;CD: the cartridge has #(palfadenew-M68K_RAM)
.ipal								;copy the rink palettes
	move.l	(a0)+,(a1)+				;16 longs = palettes 0 and 1
	dbf	d0,.ipal
	rts
setupEASportsMap					;Decompress the easn logo tiles (EASportsMap+8) to vram at EASNcset.
									;Called
									;from setupice, setupice_highlight
	move.w	(EASNcset).l,d4
;CD: no cartridge twin
	movea.l	(EASportsMapPtr).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsWithRemap
	dc.l	$71234567,$89ABCDEF		;remap table
	rts
ReloadEnergyBarTiles				;Reload the energy bar tiles (EnergyBarMap+8) at energybarchars. Called
									;from the replay code and ReloadRinkGraphics
	move.w	(energybarchars).l,d4
;CD: no cartridge twin
	movea.l	(EnergyBarMapPtr).l,a2
	addq.l	#$8,a2
	bra.w	DecompressGraphicsPlain
	move.w	(crowdvrcset).l,d4
	movea.l	(CrowdSpritesPtr).l,a2
	addq.l	#$8,a2
	bra.w	DecompressGraphicsPlain
	move.w	(ExtraChars).l,d4
	movea.l	(RefMap2Ptr).l,a2
	addq.l	#$8,a2
	bra.w	DecompressGraphicsPlain
	move.w	(ExtraChars).l,d4
	movea.l	(RefsMapPtr).l,a2
	addq.l	#$8,a2
	bra.w	DecompressGraphicsPlain
	move.w	(faceoffvrcset).l,d4
	movea.l	(FaceOffSpritesPtr).l,a2
	addq.l	#$8,a2
	bra.w	DecompressGraphicsPlain
ReloadFaceOffMap					;CD: entered here; the cartridge ReloadFaceOffMap starts at its first twin
									;line, $3ECFC
	move.w	(ExtraChars).l,d4
	movea.l	(FaceOffMapPtr).l,a2
	addq.l	#$8,a2
	bra.w	DecompressGraphicsPlain
setupTeamBlocksMap					;Load the TeamBlocks map tiles (Teamblocksmap) at d4+$2C and copy the home
									;and visitor team blocks to vram at basetileoffset and basetileoffset+$16.
									;d4 = 1st vram char; return d4 = basetileoffset+$2C. Called from setupice
	move.w	d4,(basetileoffset).l
	addi.w	#$2C,d4
	movea.l	#(TeamBlockMap-M68K_RAM),a1	;map word buffer for CopyTeamBlockMapData
;CD: no cartridge twin
	movea.l	(TeamblocksmapPtr).l,a0
	lea	jimtilecount(a0),a2
	bsr.w	DecompressGraphicsPlain	;all team block tiles to vram at d4
	adda.l	jimdata(a0),a0
	move.l	a0,-(sp)
	move.w	(HomeTeam).l,d0
	move.w	(basetileoffset).l,d1
	asl.w	#5,d1					;vram address of char
	bsr.w	CopyTeamBlockMapData	;home blocks at basetileoffset
	movea.l	(sp)+,a0
	move.w	(VisTeam).l,d0
	move.w	(basetileoffset).l,d1
	addi.w	#$16,d1					;22 chars ($16) after the home blocks
	asl.w	#5,d1					;vram address of char
	bsr.w	CopyTeamBlockMapData
	move.w	(basetileoffset).l,d4	;d4 = first char after both teams' blocks
	addi.w	#$2C,d4
	rts
CopyTeamBlockMapData				;Copy one team's 22 block chars from the loaded tile set to vram at d1 by
									;vram dma (DoDMA_nd2), and store their map words at (a1)+. a0 = map data,
									;d0 = team, d1 = vram address
	mulu.w	#$2C,d0
	lea	$4(a0,d0.w),a0
	move.w	#$15,d3
.row								;each row of the block
	moveq	#$20,d0					;32 bytes per char
	move.w	d1,-(sp)
	move.b	(a0),(a1)				;keep the map word flag bits
	andi.w	#$F800,(a1)
	lsr.w	#5,d1					;vram address back to char number
	ori.w	#$8000,d1				;priority
	or.w	d1,(a1)+
	move.w	(sp)+,d1
	move.w	(a0)+,d2
	andi.w	#$7FF,d2				;source char in the loaded tile set
	add.w	(basetileoffset).l,d2
	addi.w	#$2C,d2
	asl.w	#5,d2					;source vram address
	bsr.w	DoDMA_nd2				;vram to vram copy
	addi.w	#$20,d1
	dbf	d3,.row
	rts
defaultsprites						;allocate vram and assign char area for graphic structures. d4 = char area
									;for data. Sets up the sso (4) and ffo (7) objects from .listsso /
									;.listffo, then jumps to defaultsprites_0. Called from setupice and
									;setupice_highlight
	movea.l	#.listsso,a2
	movea.l	#(sso-M68K_RAM),a3
	moveq	#ssonum-1,d0
.ssotop								;each screen object
	move.w	#$FFFF,oldframe(a3)		;screen objects not locked to scroll of screen
	move.w	(a2)+,Xcord(a3)
	move.w	(a2)+,Ycord(a3)
	move.w	(a2)+,frame(a3)
	move.w	(a2)+,attribute(a3)
	move.w	d4,VRchar(a3)			;first char of this object
	add.w	(a2)+,d4
	adda.w	#ssosize,a3
	dbf	d0,.ssotop
	movea.l	#.listffo,a2
	movea.l	#$17D04,a3				;CD: the cartridge has #pads
	move.l	#ffonum-1,d0
.ffotop								;each scrolled object
	st.b	oldframe(a3)			;objects tied to screen scrolling (not players/net/puck)
	move.w	(a2)+,0(a3)				;Xpos
	move.w	(a2)+,Ypos(a3)
	move.w	(a2)+,Zpos(a3)
	move.w	(a2)+,frame(a3)
	move.w	(a2)+,attribute(a3)
	move.w	d4,VRchar(a3)
	add.w	(a2)+,d4
	adda.w	#ffosize,a3				;next pad object
	dbf	d0,.ffotop
	bra.w	defaultsprites_0
.listsso							;start values of the screen objects
	dc.w	0						;xcord,ycord,frame,attribute,vram char size
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
.listffo							;start values of the scrolled objects
	dc.w	0						;xcord,ycord,zpos,frame,attribute,vram char size
	dc.w	0
	dc.w	$FFFF
	dc.w	SPFpad+2				;puck poss. star
	dc.w	0
	dc.w	7
	dc.w	0
	dc.w	0
	dc.w	$FFFF
	dc.w	SPFpad					;joypad 1 star
	dc.w	0
	dc.w	7
	dc.w	0
	dc.w	0
	dc.w	$FFFF
	dc.w	SPFpad+1				;joypad 2 star
	dc.w	0
	dc.w	7
	dc.w	0
	dc.w	0
	dc.w	$FFFF
	dc.w	SPFreplay				;replay cursor
	dc.w	$8000
	dc.w	7
	dc.w	0
	dc.w	0
	dc.w	$FFFF
	dc.w	$34C					;SPFPad3 frame (joypad 3 star)
	dc.w	0
	dc.w	7
	dc.w	0
	dc.w	0
	dc.w	$FFFF
	dc.w	$34D					;SPFPad4 frame (joypad 4 star)
	dc.w	0
	dc.w	7
	dc.w	0
	dc.w	0
	dc.w	$FFFF
	dc.w	SPFgloves
	dc.w	0
	dc.w	5
defaultsprites_0					;objects which are tied to screen scrolling and have velocity: the 16
									;SortCords objects from .list (players, puck, puck shadow, goal nets ...),
									;the OOlist and OOlistpos; then SprSort. Also called from setoptions
	clr.w	d6
	movea.l	#(OOlist-M68K_RAM),a1	;object order list
	lea	.list(pc),a2
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
	movea.l	#(OOlistpos-M68K_RAM),a4	;object order positions
.0									;loop
	moveq	#$1F,d0					;32 longs
;CD: no cartridge twin
	movea.l	a3,a0
.1									;clear the struct
	clr.l	(a0)+
	dbf	d0,.1
	move.w	d6,SCnum(a3)
	st.b	oldframe(a3)			;no frame sent yet
	st.b	pnum(a3)
	move.w	(a2)+,0(a3)				;Xpos
	move.w	(a2)+,Ypos(a3)
	move.w	(a2)+,Zpos(a3)
	move.w	(a2)+,frame(a3)
	move.w	(a2)+,attribute(a3)
	move.w	d4,VRchar(a3)			;first char of this object
	add.w	(a2)+,d4
	move.w	(a2)+,radiusx(a3)
	move.w	(a2)+,radiusy(a3)
;CD: no cartridge twin
	adda.w	#$1,a2
	move.b	(a2)+,$38(a3)
	adda.w	#$1,a2
	move.b	(a2)+,pflags(a3)
	adda.w	#SCstruct,a3
	asl.w	#1,d6					;seed = object number * 2
	move.b	d6,(a1)+				;OOlist seed
	lsr.w	#1,d6					;back to the object number
	move.w	d6,(a4)+				;OOlistpos
	addq.w	#1,d6					;next object
	cmpi.w	#$10,d6					;16 objects
	bne.w	.0
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
SprSort								;sort objects in struct SortObj and set corresponding tables for keeping
									;them sorted later (Ylist, OOlist, OOlistpos)
	movem.l	d0-d4/a0-a2,-(sp)
	movea.l	#$17CA0,a2				;object order positions (CD: the cartridge has #OOlistpos)
	movea.l	#$17C80,a1				;sort keys (CD: the cartridge has #Ylist)
	movea.l	#SortCords,a0
	move.w	#$F,d3					;Sortobjs -1
.loop0								;copy each object's Y (X on the horizontal rink)
	move.w	Ypos(a0),d4				;sort key = Ypos
	btst.b	#sfhor,(sflags).l		;horizontal rink?
	beq.w	.101					;no: keep Ypos
	move.w	0(a0),d4				;Xpos
.101								;sort key chosen for this rink
	move.w	d4,(a1)+
	adda.w	#SCstruct,a0
	dbf	d3,.loop0					;next object
	movea.l	#$17C80,a1				;sort keys (CD: the cartridge has #Ylist)
.loop								;loop
	clr.w	d4						;one bubble pass over OOlist; d4 = swapped flag
	movea.l	#$17CC0,a0				;CD: the cartridge has #OOlist
	move.w	#$E,d3					;Sortobjs-2
	clr.w	d0						;clear the high bytes
	clr.w	d1
.0									;compare each pair
	move.b	(a0)+,d0				;d0 = this entry (object * 2)
	move.b	(a0),d1					;d1 = next entry
	move.w	(a1,d0.w),d2			;this object's key
	cmp.w	(a1,d1.w),d2			;against the next one's
	ble.w	.1						;in order: next pair
	move.b	d0,(a0)					;swap the two entries
	move.b	d1,-1(a0)
	move.l	a0,d2					;d2 = position of the second entry
	subi.l	#$17CC0,d2				;CD: the cartridge has #OOlist
	move.w	d2,(a2,d0.w)			;store the new positions in OOlistpos
	subq.w	#1,d2
	move.w	d2,(a2,d1.w)
	st.b	d4						;flag for incomplete sort
.1									;next pair
	dbf	d3,.0						;next adjacent pair
	tst.w	d4						;any swap this pass?
	bne.w	.loop					;swapped something: another pass
	movem.l	(sp)+,d0-d4/a0-a2
	rts
resetplstuff						;reset team variables/and players on both teams. Called from puckfaceoff2,
									;puckpenshot and StartHL2
	movem.l	d0-d2/a0-a3,-(sp)
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	bsr.w	.top
	movea.l	#$186B2,a2				;CD: the cartridge has #(awtmstruct-M68K_RAM)
	bsr.w	.top
	movem.l	(sp)+,d0-d2/a0-a3
	rts
.top								;local subroutine
	bclr.b	#tmfoside,tmflags(a2)	;clear team offside bit
	moveq	#5,d2
;CD: no cartridge twin
	movea.l	$22(a2),a3
.loop								;each player of the team
	clr.b	pflags2(a3)
	tst.w	position(a3)
	bmi.w	.next
	move.w	#SPAglide,d1			;92 $346
;CD: no cartridge twin
	jsr	(SetSPA).l
	clr.w	impact(a3)
	clr.b	nopuck(a3)
	andi.b	#$C2,pflags(a3)			;2^pfteam + 2^pfgoal +2^pfna, pflags
.next								;next player
	adda.w	#SCstruct,a3
	dbf	d2,.loop					;next player
	rts
clearTeamStats						;clear both team structs (2 x tmsize) but keep each hot / cold table
									;(tmHotCold, saved to
									;homehotcoldsave / awayhotcoldsave and back) and tmstruct+tmgoalie /
									;awtmstruct+tmgoalie. Falls into setteams
	move.w	(tmstruct+tmgoalie).l,-(sp)	;keep the home goalie
	move.w	(awtmstruct+tmgoalie).l,-(sp)	;keep the away goalie
	movem.l	a1-a3,-(sp)
	move.w	#tmPerGoals-tmHotCold-1,d0	;hot / cold table bytes - 1
	movea.l	#awtmstruct+tmHotCold,a1	;Hot/Cold table Away Team
	movea.l	#tmstruct+tmHotCold,a0	;Hot/Cold table Home Team
	movea.l	#homehotcoldsave,a2
	movea.l	#awayhotcoldsave,a3
.loop								;keep both hot / cold tables
	move.b	(a0)+,(a2)+
	move.b	(a1)+,(a3)+
	dbf	d0,.loop					;next byte
	movem.l	(sp)+,a1-a3
	move.l	#tmsize-1,d0
	movea.l	#$1834C,a0				;CD: the cartridge has #(tmstruct-M68K_RAM)
.loop2								;clear the home struct
	clr.b	(a0)+
	dbf	d0,.loop2					;next byte
	movea.l	#$186B2,a0				;CD: the cartridge has #(awtmstruct-M68K_RAM)
	move.w	#tmsize-1,d0
.loop3								;clear the away struct
	clr.b	(a0)+
	dbf	d0,.loop3					;next byte
	movem.l	a1-a3,-(sp)
	move.w	#tmPerGoals-tmHotCold-1,d0	;hot / cold table bytes - 1
	movea.l	#awtmstruct+tmHotCold,a1
	movea.l	#tmstruct+tmHotCold,a0
	movea.l	#homehotcoldsave,a2
	movea.l	#awayhotcoldsave,a3
.loop4								;put the hot / cold tables back
	move.b	(a2)+,(a0)+
	move.b	(a3)+,(a1)+
	dbf	d0,.loop4					;next byte
	movem.l	(sp)+,a1-a3
	move.w	(sp)+,(awtmstruct+tmgoalie).l
	move.w	(sp)+,(tmstruct+tmgoalie).l
	st.b	(tmstruct+tmpdst+$34).l
	st.b	(awtmstruct+tmpdst+$34).l
setteams							;Use hometeam/visteam to set team structures (InitTeamStructure for each).
									;Falls in from clearTeamStats, also called from TeamIcons
	movem.l	d0/a0-a2,-(sp)
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	move.w	(HomeTeam).l,d0
;CD: no cartridge twin
	move.l	#SortCords,$22(a2)
	bsr.w	InitTeamStructure
	movea.l	#$186B2,a2				;CD: the cartridge has #(awtmstruct-M68K_RAM)
	move.w	(VisTeam).l,d0
;CD: no cartridge twin
	move.l	#$17780,$22(a2)
	bsr.w	InitTeamStructure
	movem.l	(sp)+,d0/a0-a2
	rts
InitTeamStructure					;Set up team struct a2 for team d0: store the team number (tmteam), the
									;team data address (tmdata), and copy 7 of the 8 line sets to tmlines.
									;OptLine Off / Auto: line 1 (the no-line-change line) and lines 3-8;
									;On: lines 2-8
	move.w	d0,tmteam(a2)
	movea.l	#TeamList,a0
	asl.w	#2,d0
	move.l	(a0,d0.w),tmdata(a2)
CopyTeamLines						;'Set Original lines' (line editor exit menu): copy the team data line
									;sets to tmlines
	tst.w	(OptLine).l				;line changes On (0)?
	beq.w	.0
	movea.l	tmdata(a2),a0
	adda.w	LineSets(a0),a0
	lea	tmlines(a2),a1
	move.l	(a0)+,(a1)+				;line 1: the no-line-change line
	move.l	(a0)+,(a1)+
;CD: no cartridge twin
	adda.w	#$8,a0
	move.w	#$B,d0					;lines 3-8
.loop								;copy the line data
	move.l	(a0)+,(a1)+
	dbf	d0,.loop					;next long
	rts
.0									;line changes On: lines 2-8
	moveq	#$D,d0					;14 longs
	movea.l	tmdata(a2),a0
	adda.w	LineSets(a0),a0
;CD: no cartridge twin
	adda.w	#$8,a0
	lea	tmlines(a2),a1
.copy								;copy the default lines
	move.l	(a0)+,(a1)+
	dbf	d0,.copy					;next long
	rts
setplayercolors						;Copy in correct color data for each team:.team for the home team, then
									;falls in for the visitors.
									;Called from setupice, setupice_highlight, StartHL2 and ReloadRinkGraphics
	clr.w	d1						;home: palette offset 0
;CD: no cartridge twin
	cmpi.w	#$13,(VisTeam).l
	beq.w	.L3F26A
	cmpi.w	#$13,(HomeTeam).l
	beq.w	.L3F26A
	bra.w	.L3F272
.L3F26A
	move.w	#$860,$BBCDC.l
.L3F272
	movea.l	#$1834C,a0				;CD: the cartridge has #(tmstruct-M68K_RAM)
	bsr.w	.team
	moveq	#$20,d1					;visitors: palette offset $20
	adda.w	#tmsize,a0
.team								;a0 = team struct, d1 = palette offset ($20 for the visitors)
	movea.l	tmdata(a0),a2			;a0 = team struct, d1 = palette offset (0 home, $20 visitors)
	adda.w	Palettedata(a2),a2
	adda.w	d1,a2					;this team's palettes
	movea.l	#$BBCF0,a1				;palettes 2 and 3 (CD: the cartridge has #(palfadenew+$40-M68K_RAM))
	adda.w	d1,a1
	moveq	#7,d0
.loop								;copy 8 longs of palette
	move.l	(a2)+,(a1)+
	dbf	d0,.loop
	rts
GameOver							;EncodePW (save the password), then in playoff mode PlayoffStatsScreen
									;(the playoff stats) and the playoff screen. Falls into ExitToOpening
	bsr.w	EncodePW
	tst.w	(OptPlayMode).l			;playoff mode?
	beq.w	.po						;regular season
	bclr.b	#sfpj,(sflags).l
	jsr	(PlayoffStatsScreen).l
.po									;playoff tree next
	bsr.w	PlayoffScreen
;CD: no cartridge twin
	tst.w	$191CE.l
	bne.s	.L3F2D2
	move.w	#$1,$3FC0A.l
	bsr.w	X_3FC0C
.L3F2D2
	bra.w	.L3F2DC
	jsr	$48208.l
.L3F2DC
	jsr	$48208.l
	bclr.b	#$5,$FF800F.l
Opening2							;CD: its first lines have no twin; the rest of it starts here
	movea.l	#(Stack-M68K_RAM),sp
	movea.l	#(VSCRLPM-M68K_RAM),a0	;varstart
.0									;loop
	clr.l	(a0)+
	cmpa.l	#(varend-M68K_RAM),a0	;clear from VSCRLPM up to it
	blt.w	.0
;CD: no cartridge twin
	move.l	#vb2,(VBint).l
	bset.b	#$5,$FF800F.l
	jsr	(GameSetUp).l
	jsr	(UserNameEntry).l
Opening3	bsr.w	PlayoffScreen	;playoff tree (returns at once outside playoff mode)
	btst.b	#0,(gmode2).l			;shootout?
	bne.w	.1
	jsr	$282B6.l					;skipped in shootouts, so no global label here (.1 below is local to (CD:
									;the cartridge has (ScoutingReport).l) Opening3)
.1									;start the game
	jmp	(StartGame).l
PlayoffScreen						;bring up playoff screen if in playoff mode. Called from GameOver and
									;Opening2. Runs its own vblank and
									;scrolls the tree a page ($70 pixels) at a time. Returns when start is
									;pressed (PlayoffScreen_exit)
	tst.w	$191CE.l				;CD: the cartridge has (OptPlayMode).w
;CD: no cartridge twin
	bne.s	.L3F350
	move.w	#$0,$3FC0A.l
	bsr.w	X_3FC0C
.L3F350
	bclr.b	#$5,$FF800F.l
	tst.w	(OptPlayMode).l
	beq.w	rtss2
	move.l	#VBlank_Playoff,(VBint).l
	bset.b	#$5,$FF800F.l
	bclr.b	#df32c,(disflags).l		;32 cell mode off
	move.w	#0,$18D30.l				;CD: the cartridge has (VSCRLPM).w
	move.w	#$BC00,(VSPRITES).l
	move.w	#$B000,(VmMAP3).l
	move.w	#6,(Map3col).l
	move.w	#$C000,(VmMAP2).l
	move.w	#7,(Map2col).l
	move.w	#$E000,(VmMAP1).l
	move.w	#7,(Map1col).l			;128 col mode
	move.w	#0,d0					;fade to color
	bsr.w	setVram
	bsr.w	printz					;map 1 at 0,0
	String	CC_Font1,0,0
	move.l	#$80,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2				;blank char
	bsr.w	eraser
	bsr.w	printz					;map 3 at 0,0
	String	CC_Font3,0,0
	moveq	#$28,d0
	moveq	#2,d1
	move.w	#$7FF,d2				;blank char
	bsr.w	eraser
	bsr.w	AddTeamBlock
	bsr.w	AddSmallFont
;CD: no cartridge twin
	movea.l	(ArrowsmapPtr).l,a2
	addq.l	#$8,a2
	move.w	d4,(ExtraChars).l		;arrow tiles start here
	bsr.w	DecompressGraphicsPlain	;arrow tiles at ExtraChars
	bsr.w	printz					;map 2 (palette 3) at 0,0
	String	CC_Font2Pal3,0,0
;CD: no cartridge twin
	movea.l	(EASportsBGMapPtr).l,a0
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2
	adda.l	(a2)+,a0				;a0 = map data
	adda.l	(a2)+,a1				;a1 = map size
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2					;width and height from the map header
	move.w	mapheight(a1),d3
	moveq	#3,d5
	bsr.w	dobitmap
;CD: no cartridge twin
	movea.l	(StanleyCupSpritePtr).l,a1
	lea	jimtilecount(a1),a2
	adda.l	(a1),a1
	moveq	#7,d0					;8 longs
	movea.l	#$BBCF0,a0				;CD: the cartridge has #(palfadenew+$40-M68K_RAM)
.pal								;copy 8 longs of palette
	move.l	-$40(a0),$20(a0)		;pal 0 -> pal 3
	move.l	(a1)+,-$40(a0)			;Titlemap2 palette -> pal 0
	move.l	-$20(a0),(a0)+			;pal 1 -> pal 2
	dbf	d0,.pal
;CD: no cartridge twin
	move.w	#$860,$BBCDC.l
	move.w	#$860,$BBCFC.l
	move.w	d4,(logochars).l		;playoff sprite tiles start here
	bsr.w	DecompressGraphicsPlain	;playoff sprite tiles to vram
	move.w	#$104,(logoslide).l		;RAM reused by this screen
	move.w	#$A0,(playoffspritey).l
	movea.l	#Vctrl,a0				;vdp control port
;CD: no cartridge twin
.L3F48C
	btst.b	#$7,$FF800E.l
	bne.s	.L3F48C
	move.w	#$9202,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3F4AE
	btst.b	#$6,$FF800E.l
	beq.s	.L3F4AE
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3F4C8
	btst.b	#$6,$FF800E.l
	bne.s	.L3F4C8
	bclr.b	#$7,$FF800F.l
	movea.l	#(potree-M68K_RAM),a1	;teams in the tree
	movea.l	#PlayoffScreen_setup,a0	;playoff tree layout by gamelevel
	move.w	(gamelevel).l,d0
	asl.w	#1,d0
	adda.w	(a0,d0.w),a0			;this level's layout
	clr.w	d4						;clear the high byte
	move.b	(a0)+,d4
.top								;each team block
	bsr.w	printz
	String	CC_Font1,0,0
	move.b	(a0)+,(printx+1).l
	move.b	(a0)+,(printy+1).l
	clr.w	d1
	move.b	(a1)+,d1				;team from potree
	add.w	d1,d1
	bsr.w	PlayoffScreen_doteam	;draw both team blocks
	dbf	d4,.top
	clr.w	d4						;clear the high byte
	move.b	(a0)+,d4
.top2								;each arrow
	bsr.w	printz
	String	CC_Font1,0,2
	move.b	(a0)+,(printx+1).l
	clr.w	d0
	move.b	(a0)+,d0
	bsr.w	PlayoffScreen_doarrow	;draw the bracket lines
	dbf	d4,.top2
	bsr.w	printz					;map 1 (palette 1)
	String	CC_Font1Pal1,0,0
	cmpi.w	#7,(bosgames).l			;best of 7
	beq.w	.noscr
	clr.w	d4						;clear the high byte
	move.b	(a0)+,d4
	bmi.w	.noscr
	movea.l	#(gstruct-M68K_RAM),a2	;playoff series structs
.top3								;each series score
	move.b	(a0)+,(printx+1).l		;per series score: x, y from the tree table
	move.b	(a0)+,(printy+1).l
	bsr.w	PlayoffScreen_doscores
	adda.w	#$10,a2					;next series
	dbf	d4,.top3					;next score
.noscr								;scores done
	bsr.w	printsmallz
	String	CC_SetMapAndPosition,1,1,$41,$1A
	lea	PlayoffScreenText(pc),a1	;round titles
	move.w	(gamelevel).l,d0
	bsr.w	AdvanceStringPtr		;a1 = string d0
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).l
	bsr.w	printsmall
	tst.w	(gamelevel).l			;first round?
	beq.w	.nopage					;one page only
	bsr.w	printz					;map 3 (palette 3)
	String	CC_Font3Pal3,$A,1,'Press [ or ] to page',0	;the text as code
.nopage								;gamelevel = 0
	move.w	#$18,(palcount).l		;after the string
	move.w	#SngEOP,-(sp)			;end of period song
;CD: no cartridge twin
	jsr	$371D2.l
	clr.w	d0						;fade to color 0
	clr.w	d4
	move.w	#$FFFF,(PlayerScrollCtr).l	;scroll step (RAM shared with the stats screens)
	move.w	#1,(playoffscroll).l	;scroll position
	bsr.w	PlayoffScreen_scrup
.input								;loop
	bsr.w	waitxc1
	movea.l	#rtss2,a0
	jsr	(DrawPlayoffSprite).l		;draw the playoff sprite
	bsr.w	PlayoffScreen_jin		;page / exit input
	bra.w	.input
;CD: no cartridge twin
PlayoffScreen_jin					;CD: placed where the disc branches to it
	jsr	(ReadJoy1).l
	move.w	d3,-(sp)
	jsr	(ReadJoy2).l
	or.w	(sp)+,d3				;either pad
	btst	#7,d3					;start?
	bne.w	PlayoffScreen_exit		;yes: leave the screen
	btst	#3,d3					;right?
	beq.w	.nr
	move.w	#$FFFE,(PlayerScrollCtr).l
.nr									;right handled
	btst	#2,d3					;left?
	beq.w	PlayoffScreen_scrup
	move.w	#2,(PlayerScrollCtr).l
PlayoffScreen_scrup					;Move the tree one step (PlayerScrollCtr) and stop on a page boundary
									;($70). The position is
									;DispAttribCtr; playoffspritex is the sprite x offset while it is on
									;screen
	move.w	(PlayerScrollCtr).l,d0
	beq.w	rtss2
	add.w	(playoffscroll).l,d0	;new position
	move.w	(gamelevel).l,d1		;page limit = gamelevel
	cmpi.w	#3,d1					;more than 3?
	bls.w	.lim
	moveq	#3,d1					;at most 3 pages each way
.lim								;page limit set
	mulu.w	#$70,d1					;$70 pixels a page
	cmp.w	d1,d0					;past the right limit?
	bgt.w	rtss2
	neg.w	d1
	cmp.w	d1,d0					;past it?
	blt.w	rtss2
	move.w	d0,(playoffscroll).l	;store the new position
	clr.w	(playoffspritex).l		;sprite x off screen
	move.w	d0,d1					;sprite x = position + $100
	addi.w	#$100,d1
	cmpi.w	#$40,d1
	blt.w	.nox					;playoffspritex = position+$100 only inside $40-$200, else 0
	cmpi.w	#$200,d1				;past $200?
	bgt.w	.nox
	move.w	d1,(playoffspritex).l
.nox								;sprite X set
	ext.l	d0						;is the new position on a page boundary?
	divs.w	#$70,d0
	swap	d0
	tst.w	d0
	bne.w	rtss2					;not on a boundary: keep scrolling
	clr.w	(PlayerScrollCtr).l
	rts
;CD: no cartridge twin
PlayoffScreen_exit					;CD: placed where the disc branches to it
	adda.w	#$4,sp
	rts								;return from PlayoffScreen
waitxc1								;Each time palcount runs out, eor the color
									;word at palfadenew+$42 with $EE and restart palcount at $18; then wait
									;for the next vblank
	tst.w	(palcount).l
	bpl.w	.wait					;palcount still counting
	eori.w	#$EE,(palfadenew+$42).l	;blink the color
	move.w	#$18,(palcount).l		;restart the count
.wait								;wait for the next vblank
	move.w	(Vcount).l,d0			;wait until the vblank handler bumps Vcount
	cmp.w	(OldVcount).l,d0
	beq.w	.wait
	move.w	d0,(OldVcount).l
	rts
PlayoffScreen_doscores				;Print best of 7 wins "t-b" for game struct a2 at printx/printy
	movea.l	#$17EF2,a1				;CD: the cartridge has #(mesarea-M68K_RAM)
	move.w	#6,(a1)+
	move.w	gspotwins(a2),d0
	addi.w	#$30,d0
	move.b	d0,(a1)+
	move.b	#$2D,(a1)+
	move.w	gspobwins(a2),d0
	addi.w	#$30,d0
	move.b	d0,(a1)+
	clr.b	(a1)+
	movea.l	#$17EF2,a1				;CD: the cartridge has #(mesarea-M68K_RAM)
	bra.w	print
PlayoffScreen_doarrow				;Draw tree arrow d0 from the arrows map (Arrowsmap) at printx/printy
	movem.l	d0-d7/a0-a3,-(sp)
;CD: no cartridge twin
	movea.l	(ArrowsmapPtr).l,a0
	movea.l	a0,a1					;a1 = map header
	adda.l	(a0),a0					;a0 = arrow frames
	adda.l	jimdata(a1),a1			;a1 = map data
	movea.l	#null,a2
	clr.w	d1
	moveq	#2,d2
	moveq	#$17,d3
	move.w	(ExtraChars).l,d4
	moveq	#0,d5
	bsr.w	dobitmap
	movem.l	(sp)+,d0-d7/a0-a3
	rts
PlayoffScreen_doteam				;Draw team block d1 (team*2) from the TeamBlocks map (Teamblocksmap) at
									;printx/printy; the user's team (potreeteam entry of potree) is
									;highlighted (printa $6000)
	movem.l	d0-d7/a0-a3,-(sp)
	movea.l	#(potree-M68K_RAM),a0	;teams in the tree
	move.w	(potreeteam).l,d0		;the user's team entry
	move.b	(a0,d0.w),d0
	add.b	d0,d0
	cmp.b	d0,d1					;this block?
	bne.w	.nohi
	move.w	#$6000,(printa).l
;CD: no cartridge twin
.nohi								;CD: placed where the disc branches to it
	movea.l	(TeamblocksmapPtr).l,a1
	adda.l	jimdata(a1),a1
	movea.l	#null,a2
	clr.w	d0
	move.w	(a1),d2
	moveq	#2,d3
	moveq	#2,d4
	moveq	#0,d5
	bsr.w	dobitmap
	movem.l	(sp)+,d0-d7/a0-a3
	rts
VBlank_Playoff						;the PlayoffScreen vblank handler (VBint): dma the sprite table, write
									;$FEA0+DispAttribCtr to the hscroll, cramfade. Always Vcount+1,
									;p_music_vblank, rte
	movem.l	d0-d7/a0-a6,-(sp)
	btst.b	#dfng,(disflags).l		;graphics not allowed?
	bne.w	.nograph
	movea.l	#(Satt-M68K_RAM),a0		;sprite attribute table
	move.w	(Sattsize).l,d0			;size of the table
	beq.w	.nosat
	clr.w	(Sattsize).l
	move.w	(VSPRITES).l,d1			;to the sprites address
;CD: no cartridge twin
	jsr	$378D2.l
	move.w	$18D30.l,d0				;CD: the cartridge has (VSCRLPM).w
	bsr.w	X_38780					;set the vram address (CD: the cartridge has Vmaddr)
	move.w	#$FEA0,d0				;hscroll = $FEA0 + position
	add.w	(playoffscroll).l,d0
;CD: no cartridge twin
.L3F7D4
	btst.b	#$4,$FF800E.l
	bne.s	.L3F7D4
	move.w	#$31,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.L3F7F4
	btst.b	#$3,$FF800E.l
	beq.s	.L3F7F4
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3F80E
	btst.b	#$3,$FF800E.l
	bne.s	.L3F80E
	bclr.b	#$4,$FF800F.l
.nosat								;CD: placed where the disc branches to it
	jsr	(cramfade).l
.nograph							;CD: placed where the disc branches to it
	addq.w	#$1,(Vcount).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PlayoffScreenText					;Round titles by gamelevel, printed with printsmall
	String	'Playoffs'
	String	'Quarterfinals'
	String	'Semifinals'
	String	'Finals'
	String	'Champions'
