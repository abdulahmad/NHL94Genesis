;patch/teamblock-vram: setup screen team banners. Data from tools/packTeamBitmaps.js (prebuild).
	include	..\output\obj\teambitmaps_packed.inc
	IF TBP_Count<>NumTeams
		inform	3,"teambitmaps_packed.inc needs one entry per team"
	ENDIF
	IF 2+2*TBP_Max>400
		inform	3,"TBP_Max too big for the setup banner slots"
	ENDIF
LoadTeamBitmapPlain	;DMA team d1's banner tiles (plain) to vram char d4. Registers kept
	movem.l	d0-d2/a0-a1,-(sp)
	movea.l	#TBP_Plain,a1
	bra.s	LoadTeamBitmapTiles
LoadTeamBitmapRemap	;Same, colours 1-2 <-> 3-4 (pre-remapped by the tool)
	movem.l	d0-d2/a0-a1,-(sp)
	movea.l	#TBP_Remap,a1
LoadTeamBitmapTiles
	move.w	d1,d2
	add.w	d2,d2
	movea.l	#TBP_Tiles,a0
	move.w	0(a0,d2.w),d0
	asl.w	#4,d0		;words
	add.w	d2,d2
	movea.l	0(a1,d2.w),a0
	move.w	d4,d1
	asl.w	#5,d1
	jsr	(DoDMApro).l
	movem.l	(sp)+,d0-d2/a0-a1
	rts
