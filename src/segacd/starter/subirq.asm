;	STARTER.BIN $40FA-$4335 (runtime $F0FA-$F335).
;
;	After pcmchip.asm: a long that keeps the BIOS vector at $5F90 (the first line, decoded as an
;	ori.b #0), code that hooks that vector with its own handler and puts it back, then the C function Wait.


FilmReadCount	equ	$ECC4
FilmReadDest	equ	$ECC8
FilmReadSector	equ	$ECCC
FilmReadError	equ	$ECEC
GetTicks	equ	$FD62
GetSectDst	equ	$FEFC
PeekSectDst	equ	$FF58

	org	$F0FA

SavedFilmReadJump
	ori.b	#$0,d0
InstallFilmReadHook
	lea	SavedFilmReadJump(pc),a0
	move.l	$5F90.w,(a0)
	lea	FilmReadInterrupt(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F90.w
	move.w	(sp)+,sr
	rts
RemoveFilmReadHook
	movea.l	SavedFilmReadJump(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F90.w
	move.w	(sp)+,sr
	rts
FilmSectorHeader
	ori.b	#$0,d0
FilmReadInterrupt
	movem.l	d0-d3/a0-a2/a5,-(sp)
	pea	.LF13E(pc)
	move.w	sr,-(sp)
	movea.l	SavedFilmReadJump(pc),a2
	jmp	(a2)
.LF13E
	movea.l	#$FF8000,a5
	move.l	FilmReadCount(pc),d3
	beq.w	.LF21C
	bgt.s	.LF1C6
	andi.w	#$F8FF,$4(a5)
	ori.w	#$300,$4(a5)
	move.w	#$8B,d0
	jsr	$5F22.w
	bcs.w	.LF21C
	move.l	FilmReadDest(pc),d0
	bne.s	.LF176
	bsr.w	PeekSectDst
	tst.l	d0
	beq.w	.LF222
.LF176
	movea.l	d0,a0
	lea	FilmSectorHeader(pc),a1
	move.w	#$8C,d0
	jsr	$5F22.w
	bcs.w	.LF21C
	move.w	#$8D,d0
	jsr	$5F22.w
	move.l	FilmSectorHeader(pc),d0
	andi.l	#$FFFFFF00,d0
	bsr.w	FilmMsfToLba
	move.l	FilmReadSector(pc),d1
	cmp.l	d0,d1
	bne.s	.LF21C
	lea	FilmReadDest(pc),a1
	tst.l	(a1)
	beq.s	.LF1B6
	addi.l	#$800,(a1)
	bra.s	.LF1BA
.LF1B6
	bsr.w	GetSectDst
.LF1BA
	neg.l	d3
	subq.w	#$1,d3
	lea	FilmReadCount(pc),a1
	move.l	d3,(a1)
	bra.s	.LF21C
.LF1C6
	movea.l	#$FF8000,a5
	andi.w	#$F8FF,$4(a5)
	ori.w	#$500,$4(a5)
	move.l	FilmReadDest(pc),d0
	bne.s	.LF1E6
	bsr.w	GetSectDst
	tst.l	d0
	beq.s	.LF222
.LF1E6
	lsr.l	#$3,d0
	move.w	d0,$A(a5)
	move.w	#$8B,d0
	jsr	$5F22.w
	bcs.s	.LF22A
.LF1F6
	btst.b	#$7,$4(a5)
	beq.s	.LF1F6
	bcs.s	.LF22A
	move.w	#$8D,d0
	jsr	$5F22.w
	lea	FilmReadDest(pc),a1
	tst.l	(a1)
	beq.s	.LF216
	addi.l	#$800,(a1)
.LF216
	lea	FilmReadCount(pc),a1
	subq.l	#$1,(a1)
.LF21C
	movem.l	(sp)+,d0-d3/a0-a2/a5
	rte
.LF222
	lea	FilmReadCount(pc),a1
	clr.l	(a1)
	bra.s	.LF21C
.LF22A
	lea	FilmReadError(pc),a1
	move.l	#$FFFFFFFF,(a1)
	bra.s	.LF21C
StopFilmRead
	lea	FilmReadCount(pc),a1
	clr.l	(a1)
	move.w	#$8,d0
	jsr	$5F22.w
	rts
StartFilmRead
	link	a6,#$FFFC
	movem.l	d1-d7/a0-a5,-(sp)
	movea.l	#$FF8000,a5
	lea	FilmReadError(pc),a1
	clr.l	(a1)
	moveq	#$5,d4
	moveq	#-1,d5
	subq.l	#$1,d4
	beq.s	.LF298
	moveq	#$0,d0
	move.w	#$96,d0
	jsr	$5F22.w
	move.l	$8(a6),d3
	move.l	$C(a6),d2
	lea	$8(a6),a0
	move.w	#$17,d0
	jsr	$5F22.w
	lea	FilmReadDest(pc),a1
	move.l	$10(a6),(a1)
	lea	FilmReadCount(pc),a1
	neg.l	d2
	move.l	d2,(a1)
	lea	FilmReadSector(pc),a1
	move.l	d3,(a1)
	moveq	#$0,d5
.LF298
	move.l	d5,d0
	movem.l	(sp)+,d1-d7/a0-a5
	unlk	a6
	rts
FilmBcdToBinary
	move.l	d1,-(sp)
	move.b	d0,d1
	andi.w	#$FF,d1
	lsr.w	#$4,d1
	mulu.w	#$A,d1
	andi.w	#$F,d0
	add.w	d1,d0
	move.l	(sp)+,d1
	rts
FilmMsfToLba
	movem.l	d1-d2,-(sp)
	lsr.l	#$8,d0
	move.l	d0,d1
	jsr	FilmBcdToBinary(pc)
	move.b	d0,d2
	andi.l	#$FF,d2
	move.l	d1,d0
	lsr.l	#$8,d0
	move.l	d0,d1
	jsr	FilmBcdToBinary(pc)
	andi.l	#$FF,d0
	mulu.w	#$4B,d0
	add.l	d0,d2
	move.l	d1,d0
	lsr.l	#$8,d0
	jsr	FilmBcdToBinary(pc)
	andi.l	#$FF,d0
	mulu.w	#$1194,d0
	add.l	d0,d2
	subi.l	#$96,d2
	move.l	d2,d0
	movem.l	(sp)+,d1-d2
	rts
Wait
	link	a6,#$0
	movem.l	d6-d7,-(sp)
	move.l	$8(a6),d6
	jsr	GetTicks(pc)
	move.l	d0,d7
.LF318
	jsr	GetTicks(pc)
	move.l	d7,d1
	add.l	d6,d1
	cmp.l	d0,d1
	bgt.s	.LF318
	movem.l	-$8(a6),d6-d7
	unlk	a6
	rts
	dc.b	$84,'Wait',0,0,0
