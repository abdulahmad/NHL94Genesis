; MAIN.BIN $500-$CB7 (runtime $FF1500-$FF1CB7). Emitted by tools/emit_m68k.py.
; Rest of the DMA routine, then the older interface's display set-up and drawing commands (cells, pictures,
; text) and TextCodeTable. docs/segacd_main_shell.md "The older interface".

DecompressGraphicsPlain	equ	$FF1272
DecompressBytecode	equ	$FF210E
FillVram	equ	$FF20BE
FontMapPtr	equ	$FF2884
TextCodeSetAll	equ	$FF1CB8
TextCodeSetPlane	equ	$FF1CCC
TextCodeSetAttribute	equ	$FF1CE2
TextCodeSetX	equ	$FF1CF4
TextCodeSetY	equ	$FF1D04
TextCodeMoveX	equ	$FF1D14
TextCodeMoveY	equ	$FF1D24
TextCodeSetFont	equ	$FF1D34

	org	$FF1500

	bge.w	LFF1514
	ori.w	#$4000,d3
	swap	d3
	andi.w	#$3,d3
	move.l	d3,(a1)
	move.l	(a0),-$4(a1)
LFF1514	move.w	(sp)+,sr
	movem.l	(sp)+,d2-d3/a1
	rts
WaitForVdpDma						;until the VDP status DMA bit clears
	move.w	$C00004.l,d2
	btst	#$1,d2
	bne.b	WaitForVdpDma
	rts
SetUpDisplayCommand					;command $02: nine words: the H scroll, sprite, plane A, plane B and
									;window addresses, the plane width (log2 cells), the plane height (cells),
									;the H32 bit, one colour for the whole palette (uploaded by the V
									;interrupt); then the VDP registers
	lea.l	$23A450.l,a0
	move.w	(a0)+,$FF284E.l
	move.w	(a0)+,$FF2850.l
	move.w	(a0)+,$FF2852.l
	move.w	(a0)+,$FF2856.l
	move.w	(a0)+,$FF285A.l
	move.w	(a0)+,$FF2854.l
	move.w	(a0)+,$FF285E.l
	bclr.b	#$3,$23C6E8.l
	move.w	(a0)+,d0
	or.b	d0,$23C6E8.l
	move.w	(a0)+,d0
	movea.l	#$23A850,a0
	moveq	#$3F,d1
LFF1574	move.w	d0,(a0)+
	dbra	d1,LFF1574
	move.w	#$18,$23A8D0.l
	bsr.w	WaitForPaletteUpload
	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	move.w	#$8F02,$C00004.l
	movea.l	#$C00000,a0
	move.w	#$8C00,d0
	move.w	#$5,$FF285C.l
	btst.b	#$3,$23C6E8.l
	bne.w	LFF15C6
	move.w	#$6,$FF285C.l
	ori.w	#$81,d0
LFF15C6	move.w	d0,$4(a0)
	move.w	#$8004,$4(a0)
	move.w	#$8164,$4(a0)
	move.w	$FF2854.l,d0
	move.w	d0,$FF2858.l
	subq.w	#$5,d0
	cmpi.w	#$1,d0
	bls.w	LFF15EE
	moveq	#$3,d0
LFF15EE	cmpi.w	#$40,$FF285E.l
	bne.w	LFF15FE
	ori.w	#$10,d0
LFF15FE	cmpi.w	#$80,$FF285E.l
	bne.w	LFF160E
	ori.w	#$30,d0
LFF160E	ori.w	#$9000,d0
	move.w	d0,$4(a0)
	move.w	#$8200,d0
	move.b	$FF2852.l,d0
	lsr.b	#$2,d0
	andi.b	#$38,d0
	move.w	d0,$4(a0)
	move.w	#$8400,d0
	move.b	$FF2856.l,d0
	lsr.b	#$5,d0
	move.w	d0,$4(a0)
	move.w	#$8300,d0
	move.b	$FF285A.l,d0
	lsr.b	#$2,d0
	andi.b	#$3E,d0
	move.w	d0,$4(a0)
	move.w	#$8500,d0
	move.b	$FF2850.l,d0
	lsr.b	#$1,d0
	move.w	d0,$4(a0)
	move.w	#$8D00,d0
	move.b	$FF284E.l,d0
	lsr.b	#$2,d0
	move.w	d0,$4(a0)
	move.w	#$9100,$4(a0)
	move.w	#$9200,$4(a0)
	move.w	#$8700,$4(a0)
	move.w	#$8B00,$4(a0)
	move.l	#$40000010,$4(a0)
	move.l	#$0,(a0)
	move.w	(sp)+,$23C6E8.l
	rts
SetVramWriteAddress					;d0 a VRAM address: the VDP write command; a0 the data port
	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
	move.l	d0,$4(a0)
	rts
SetVramWriteToCursor				;the cell at x ($FF2DB2), y ($FF2DB4) of the plane $FF2DB8 picks (0 A, 4
									;B, 8 window: the address and width pairs at $FF2852)
	movem.l	d0-d2,-(sp)
	move.w	$FF2DB2.l,d0
	move.w	$FF2DB4.l,d1
	lea.l	$FF2852.l,a0
	adda.w	$FF2DB8.l,a0
	move.w	$2(a0),d2
	asl.w	d2,d1
	add.w	d1,d0
	add.w	d0,d0
	add.w	(a0),d0
	bsr.w	SetVramWriteAddress
	movem.l	(sp)+,d0-d2
	rts
FillCellRectangle					;d0 cells by d1 rows of the cell word d2 from the cursor; y wraps at the
									;plane height
	movem.l	d0-d3/a0,-(sp)
	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	moveq	#-1,d3
	add.w	$FF285E.l,d3
	movem.w	d0-d1,-(sp)
LFF1706	bsr.w	SetVramWriteToCursor
	move.w	(sp),d0
	subq.w	#$1,d0
LFF170E	move.w	d2,(a0)
	dbra	d0,LFF170E
	addq.w	#$1,$FF2DB4.l
	and.w	d3,$FF2DB4.l
	subq.w	#$1,$2(sp)
	bne.b	LFF1706
	addq.l	#$4,sp
	move.w	(sp)+,$23C6E8.l
	movem.l	(sp)+,d0-d3/a0
	rts
WaitForPaletteUpload				;until the V interrupt marks $23A8D0 done (negative)
	move.w	sr,-(sp)
	move.w	$23C6E8.l,-(sp)
	bclr.b	#$4,$23C6E8.l
	move.w	#$2500,sr
LFF1748	tst.w	$23A8D0.l
	bpl.b	LFF1748
	move.w	(sp)+,$23C6E8.l
	move.w	(sp)+,sr
	rts
ResetTileRemapCommand				;command $06: clear TileRemap ($FF2A1A, $398 bytes), next index ($FF2A18)
									;1
	movem.l	d0/a0,-(sp)
	lea.l	$FF2A1A.l,a0
	move.w	#$1CB,d0
LFF1768	clr.w	(a0)+
	dbra	d0,LFF1768
	move.b	#$1,$FF2A18.l
	movem.l	(sp)+,d0/a0
	rts
ClearHScrollAndSpritesCommand		;command $17: clear the H scroll table and the first sprite
	bset.b	#$4,$23C6E8.l
	andi.b	#$9C,$23C6E8.l
	move.w	$FF284E.l,d0
	bsr.w	SetVramWriteAddress
	moveq	#$0,d1
	move.w	#$DF,d0
LFF179C	move.l	d1,(a0)
	dbra	d0,LFF179C
	move.w	$FF2850.l,d0
	bsr.w	SetVramWriteAddress
	moveq	#$0,d0
	move.l	d0,(a0)
	move.l	d0,(a0)
	bclr.b	#$4,$23C6E8.l
	rts
FillCellsCommand					;command $07: width, height, a cell word, x, y, plane: FillCellRectangle;
									;x, y (moved down) and plane back
	lea.l	$23A450.l,a0
	move.w	(a0)+,d0
	move.w	(a0)+,d1
	move.w	(a0)+,d2
	move.w	(a0)+,$FF2DB2.l
	move.w	(a0)+,$FF2DB4.l
	move.w	(a0)+,$FF2DB8.l
	bsr.w	FillCellRectangle
	lea.l	$23A450.l,a0
	move.w	$FF2DB2.l,(a0)+
	move.w	$FF2DB4.l,(a0)+
	move.w	$FF2DB8.l,(a0)+
	rts
FillVramCommand						;command $18: FillVram, d0 bytes, d1 address, d2 word from $23A450
	lea.l	$23A450.l,a0
	move.w	(a0)+,d0
	move.w	(a0)+,d1
	move.w	(a0)+,d2
	bsr.w	FillVram
	rts
DrawRemappedMap						;as DrawPicture without palette or tiles, each cell TileRemap index - 1 +
									;d4: TileRemap ($FF2A1A) numbers the tiles in the order they are met
	move.w	$FF2DB4.l,-(sp)
	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	movem.l	d0-d3/d5-d6/a0-a3,-(sp)
	move.w	d1,d6
	lea.l	$FF2A1A.l,a3
	move.w	$FF2DB6.l,d5
	andi.w	#$F800,d5
	move.w	$E(sp),d2
	subq.w	#$1,d2
LFF183A	bsr.w	SetVramWriteToCursor
	move.w	d6,d0
	mulu.w	(a1),d0
	add.w	$2(sp),d0
	asl.w	#$1,d0
	move.w	$A(sp),d1
	subq.w	#$1,d1
LFF184E	move.w	$4(a1,d0.w),d3
	move.w	d3,-(sp)
	andi.w	#$7FF,d3
	tst.b	(a3,d3.w)
	bne.w	LFF186E
	move.b	$FF2A18.l,(a3,d3.w)
	addq.b	#$1,$FF2A18.l
LFF186E	move.b	(a3,d3.w),d3
	andi.w	#$FF,d3
	subq.w	#$1,d3
	add.w	d4,d3
	andi.w	#$F800,(sp)
	or.w	(sp)+,d3
	eor.w	d5,d3
	move.w	d3,(a0)
	addq.w	#$2,d0
	dbra	d1,LFF184E
	addq.w	#$1,$FF2DB4.l
	addq.w	#$1,d6
	dbra	d2,LFF183A
	movem.l	(sp)+,d0-d3/d5-d6/a0-a3
	move.w	(sp)+,$23C6E8.l
	move.w	(sp)+,$FF2DB4.l
	rts
LoadRemappedTiles					;a0 packed tiles: only those TileRemap marks, each to character d4 + index
									;- 1
	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	moveq	#$1,d1
	lea.l	$FF2A1A.l,a3
	bsr.w	DecompressBytecode
	clr.w	d1
	move.b	$FF2A18.l,d1
	add.w	d1,d4
	move.w	(sp)+,$23C6E8.l
	rts
DrawPicture							;the palette lines of mask d5 from a0 into the palette buffer $23A850; d3
									;rows of d2 cells of the map at a1 from column d0, row d1, + d4, the
									;attribute; the tiles a2 at d4
	move.w	$FF2DB4.l,-(sp)
	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	movem.l	d0-d3/d5-d6/a0-a3,-(sp)
	move.w	d1,d6
	lea.l	$23A850.l,a3
	bra.w	LFF190A
LFF18F8	move.b	(a0,d0.w),(a3,d0.w)
	dbra	d0,LFF18F8
LFF1902	adda.w	#$20,a0
	adda.w	#$20,a3
LFF190A	moveq	#$1F,d0
	lsr.w	#$1,d5
	bcs.b	LFF18F8
	bne.b	LFF1902
	move.w	$FF2DB6.l,d5
	andi.w	#$F800,d5
	move.w	$E(sp),d2
	subq.w	#$1,d2
LFF1922	bsr.w	SetVramWriteToCursor
	move.w	d6,d0
	mulu.w	(a1),d0
	add.w	$2(sp),d0
	asl.w	#$1,d0
	move.w	$A(sp),d1
	subq.w	#$1,d1
LFF1936	move.w	$4(a1,d0.w),d3
	add.w	d4,d3
	eor.w	d5,d3
	move.w	d3,(a0)
	addq.w	#$2,d0
	dbra	d1,LFF1936
	addq.w	#$1,$FF2DB4.l
	addq.w	#$1,d6
	dbra	d2,LFF1922
	bsr.w	DecompressGraphicsPlain
	movem.l	(sp)+,d0-d3/d5-d6/a0-a3
	move.w	(sp)+,$23C6E8.l
	move.w	(sp)+,$FF2DB4.l
	rts
DrawPictureCommand					;command $08: a .map.jim picture: a0 palette, a1 map, a2 tiles (sub CPU
									;word RAM pointers, + $180000), d0-d5, attribute, x, y, plane:
									;DrawPicture; d4 and the state back
	lea.l	$23A450.l,a5
	movea.l	(a5)+,a0
	movea.l	(a5)+,a1
	movea.l	(a5)+,a2
	move.l	(a5)+,d0
	move.l	(a5)+,d1
	move.l	(a5)+,d2
	move.l	(a5)+,d3
	move.l	(a5)+,d4
	move.l	(a5)+,d5
	adda.l	#$180000,a0
	adda.l	#$180000,a1
	adda.l	#$180000,a2
	move.w	(a5)+,$FF2DB6.l
	move.w	(a5)+,$FF2DB2.l
	move.w	(a5)+,$FF2DB4.l
	move.w	(a5)+,$FF2DB8.l
	bsr.w	DrawPicture
	lea.l	$23A450.l,a5
	move.w	d4,(a5)+
	move.w	$FF2DB6.l,(a5)+
	move.w	$FF2DB2.l,(a5)+
	move.w	$FF2DB4.l,(a5)+
	move.w	$FF2DB8.l,(a5)+
	rts
LoadRemappedTilesCommand			;command $09: a0 packed tiles, d4 the first character: LoadRemappedTiles;
									;d4 back
	lea.l	$23A450.l,a5
	movea.l	(a5)+,a0
	adda.l	#$180000,a0
	move.w	(a5),d4
	bsr.w	LoadRemappedTiles
	move.w	d4,$23A450.l
	rts
DrawRemappedMapCommand				;command $0A: as $08 (only a1, the map, is used): DrawRemappedMap
	lea.l	$23A450.l,a5
	movea.l	(a5)+,a0
	movea.l	(a5)+,a1
	movea.l	(a5)+,a2
	adda.l	#$180000,a0
	adda.l	#$180000,a1
	adda.l	#$180000,a2
	move.l	(a5)+,d0
	move.l	(a5)+,d1
	move.l	(a5)+,d2
	move.l	(a5)+,d3
	move.l	(a5)+,d4
	move.l	(a5)+,d5
	move.w	(a5)+,$FF2DB6.l
	move.w	(a5)+,$FF2DB2.l
	move.w	(a5)+,$FF2DB4.l
	move.w	(a5),$FF2DB8.l
	bsr.w	DrawRemappedMap
	move.w	d4,$23A450.l
	rts
DrawText							;a1 a length word and bytes: a character, its cell from the font map
									;(FontMapPtr) + $FF287A; $40 the cell $7FF; 0 nothing; -n attribute and
									;plane from n, then x and y bytes
	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	SetVramWriteToCursor
	move.w	$FF2DB6.l,d2
	move.w	(a1)+,d3
	subq.w	#$2,d3
	bra.w	LFF1AD8
LFF1A5E	move.b	(a1)+,d0
	beq.w	LFF1AD8
	ext.w	d0
	bpl.w	LFF1AA8
	neg.w	d0
	move.w	d0,d2
	asl.w	#$8,d2
	asl.w	#$1,d2
	andi.w	#$F800,d2
	move.w	d2,$FF2DB6.l
	andi.w	#$3,d0
	asl.w	#$2,d0
	subq.w	#$4,d0
	move.w	d0,$FF2DB8.l
	move.b	(a1)+,d0
	ext.w	d0
	move.w	d0,$FF2DB2.l
	move.b	(a1)+,d1
	ext.w	d1
	move.w	d1,$FF2DB4.l
	bsr.w	SetVramWriteToCursor
	subq.w	#$2,d3
	bra.w	LFF1AD8
LFF1AA8	cmpi.b	#$40,d0
	bne.w	LFF1AB8
	move.w	#$7FF,d0
	bra.w	LFF1ACE
LFF1AB8	asl.w	#$1,d0
	movea.l	(FontMapPtr).l,a2
	adda.l	$4(a2),a2
	move.w	$4(a2,d0.w),d0
	add.w	$FF287A.l,d0
LFF1ACE	add.w	d2,d0
	move.w	d0,(a0)
	addq.w	#$1,$FF2DB2.l
LFF1AD8	dbra	d3,LFF1A5E
	movem.l	(sp)+,d0-d3/a0/a2
	move.w	(sp)+,$23C6E8.l
	rts
DrawTextInline						;DrawText with the string after the call
	move.l	a1,-(sp)
	movea.l	$4(sp),a1
	bsr.w	DrawText
	move.l	a1,$4(sp)
	movea.l	(sp)+,a1
	rts
DrawTextCommand						;command $0B: attribute, plane, x, y, font base, a string: DrawText; the
									;state back
	lea.l	$23A450.l,a1
	move.w	(a1)+,$FF2DB6.l
	move.w	(a1)+,$FF2DB8.l
	move.w	(a1)+,$FF2DB2.l
	move.w	(a1)+,$FF2DB4.l
	move.w	(a1)+,$FF287A.l
	bsr.w	DrawText
	lea.l	$23A450.l,a1
	move.w	$FF2DB6.l,(a1)+
	move.w	$FF2DB8.l,(a1)+
	move.w	$FF2DB2.l,(a1)+
	move.w	$FF2DB4.l,(a1)
	rts
DrawCodedText						;a1 a length word and bytes: a character (DrawCodedCharacter), or -n text
									;code n (TextCodeTable)
	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	movem.l	d0-d3/a0/a2-a3,-(sp)
	lea.l	$FF287A.l,a3
	bsr.w	SetVramWriteToCursor
	move.w	$FF2DB6.l,d2
	move.w	(a1)+,d3
	subq.w	#$2,d3
	bra.w	LFF1B8C
LFF1B6C	move.b	(a1)+,d0
	ext.w	d0
	bgt.w	LFF1B88
	neg.w	d0
	asl.w	#$2,d0
	movea.l	#TextCodeTable,a2
	movea.l	(a2,d0.w),a2
	jsr	(a2)
	bra.w	LFF1B8C
LFF1B88	bsr.w	DrawCodedCharacter
LFF1B8C	dbra	d3,LFF1B6C
	movem.l	(sp)+,d0-d3/a0/a2-a3
	move.w	(sp)+,$23C6E8.l
	rts
DrawCodedCharacter					;font $FF2DBA (4: DrawBigCharacter, else a base at $FF287A + it); $40 the
									;cell $7FF, '^' a cell skipped
	move.w	$FF2DBA.l,d1
	cmpi.w	#$4,d1
	beq.w	DrawBigCharacter
	cmpi.b	#$40,d0
	bne.w	LFF1BBA
	move.w	#$7FF,d0
	bra.w	LFF1BD6
LFF1BBA	cmpi.b	#$5E,d0
	beq.w	LFF1BE2
	asl.w	#$1,d0
	movea.l	(FontMapPtr).l,a2
	adda.l	$4(a2),a2
	move.w	$4(a2,d0.w),d0
	add.w	(a3,d1.w),d0
LFF1BD6	add.w	d2,d0
	move.w	d0,(a0)
	addq.w	#$1,$FF2DB2.l
	rts
LFF1BE2	addq.w	#$1,$FF2DB2.l
	bra.w	SetVramWriteToCursor
DrawBigCharacter					;two cells high, one or two wide (width bytes at $FF2DBC), from the font
									;at $FF2888; nothing in MAIN.BIN writes either
	cmpi.b	#$61,d0
	blt.w	LFF1C00
	cmpi.b	#$7A,d0
	bgt.w	LFF1C00
	addi.w	#$FFE0,d0
LFF1C00	movem.l	d4-d7/a0,-(sp)
	subi.w	#$20,d0
	lea.l	$FF2DBC.l,a0
	moveq	#$1,d4
	move.b	(a0,d0.w),d5
	ext.w	d5
	bpl.w	LFF1C1E
	neg.w	d5
	clr.w	d4
LFF1C1E	add.w	d5,d5
	movea.l	$FF2888.l,a0
	adda.l	$4(a0),a0
LFF1C2A	bsr.w	WriteBigCharacterCell
	move.w	(a0),d7
	add.w	d7,d7
	add.w	d7,d5
	addq.w	#$1,$FF2DB4.l
	bsr.w	WriteBigCharacterCell
	sub.w	d7,d5
	subq.w	#$1,$FF2DB4.l
	addq.w	#$1,$FF2DB2.l
	addq.w	#$2,d5
	dbra	d4,LFF1C2A
	movem.l	(sp)+,d4-d7/a0
	rts
WriteBigCharacterCell
	movem.l	d1/a0,-(sp)
	move.w	(a3,d1.w),d6
	add.w	$4(a0,d5.w),d6
	add.w	d2,d6
	move.w	$FF2DB4.l,d0
	lea.l	$FF2852.l,a0
	adda.w	$FF2DB8.l,a0
	move.w	$2(a0),d1
	asl.w	d1,d0
	add.w	$FF2DB2.l,d0
	add.w	d0,d0
	add.w	(a0),d0
	bsr.w	SetVramWriteAddress
	move.w	d6,(a0)
	movem.l	(sp)+,d1/a0
	rts
TextCodeTable						;code 0 nothing (an rts in mainvdp), 1 plane, 2 attribute, 3 x, 4 y, 5 x
									;+=, 6 y +=, 7 font, 8 all
	dc.l	$FF2698
	dc.l	TextCodeSetPlane
	dc.l	TextCodeSetAttribute
	dc.l	TextCodeSetX
	dc.l	TextCodeSetY
	dc.l	TextCodeMoveX
	dc.l	TextCodeMoveY
	dc.l	TextCodeSetFont
	dc.l	TextCodeSetAll
