	include	segacd\hockey.inc

SngScouting	equ	$7A				;song number, the cartridge ram94.asm value
song		equ	$371D2				;cdrequest.asm

	org	$D2B6

ScoutingReport						;pregame MATCHUPS screen
	move.l	sp,$47D00.l				;disc: save the stack
	movea.l	#$1745C,sp				;disc: private stack
	movea.l	$47DA4.l,a0
	movea.l	#$C458,a1
	move.w	#$DAC,d0
.copy	move.l	(a0)+,(a1)+			;disc: relocate the loaded block down to $C458
	dbra	d0,.copy
	move.l	$47DA4.l,d1
	subi.l	#$C458,d1
	sub.l	d1,$47DA4.l
	sub.l	d1,$47D3C.l
	sub.l	d1,$47D98.l
	sub.l	d1,$47D9C.l
	jsr	(ReadNameLog).l			;read the SRAM name list
	jsr	(BuildHotColdLists).l	;hot / cold players for the text
	clr.w	(advframe).l			;advantage mark frame
	move.w	#SngScouting,-(sp)		;song $7A
	jsr	(song).l
	move.l	#vb2,(VBint).l
	jsr	(clearTeamStats).l		;clear the game stats
	move.l	a0,-(sp)
	movea.l	#tmstruct,a0
	jsr	(Create_HotCold_Table).l	;new random hot / cold tables (end of the team structs)
	movea.l	#awtmstruct,a0
	jsr	(Create_HotCold_Table).l
	movea.l	(sp)+,a0
	jsr	(BuildHotColdLists).l	;again with the new tables
	bclr.b	#1,(disflags).l			;df32c: 40 cell mode
	move.w	#6,(Map1col).l
	move.w	#6,(Map2col).l
	move.w	#0,d0					;fade to color
	jsr	(setVram).l
	move.w	#2,d4					;vram chars from 2
	move.w	d4,(homepicchars).l		;home picture chars (6 x 6)
	addi.w	#$24,d4
	move.w	d4,(vispicchars).l
	addi.w	#$24,d4
	move.w	d4,(BigFontchars).l
	movea.l	(BigFontMap).l,a2
	addq.l	#8,a2					;BigFontMap+8
	jsr	(DecompressGraphicsWithRemap).l
