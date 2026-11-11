; MAIN.BIN Z80 loader, $FF86C8-$FF87B7 (sound operation 0).
; Keeps a1 + 4 (the sub CPU PCM driver's queue) in PcmQueuePointer, accepts a block whose first bytes
; are $C3,$00, copies it to $A00000, and resets the sequence engine (mainmod.asm): no banks, no streams,
; every channel to the Z80 (PcmChannelRouting 0). See docs/segacd_film.md and docs/segacd_main_shell.md.

DeferredSoundEvents	equ	$FF955E
PcmChannelRouting	equ	$FF954A
ClearPendingNoteOffs	equ	$FF8E1E
SequenceId	equ	$FF945C
SequencePosition	equ	$FF943C
SequenceData	equ	$FF941C
SoundResourceBanks	equ	$FF95EC
ReleaseSoundSubProgramRam	equ	$FF93B0
MapSoundSubProgramPointer	equ	$FF93FC
AcquireSoundSubProgramRam	equ	$FF935C
PcmQueuePointer	equ	$FF955A

	org	$FF86C8

LoadZ80SoundProgram
	movem.l	d1/a0-a2,-(sp)
	move.w	sr,-(sp)
	move.w	#$2700,sr
	lea.l	PcmQueuePointer(pc),a2
	adda.l	#$4,a1
	move.l	a1,(a2)
	move.w	#$100,$A11100.l
	move.w	#$100,$A11200.l
	cmpi.b	#$C3,(a0)
	bne.b	LFF871A
	cmpi.b	#$0,$1(a0)
	bne.b	LFF871A
	move.l	a0,-(sp)
	bsr.w	AcquireSoundSubProgramRam
	bsr.w	MapSoundSubProgramPointer
	lea.l	$A00000.l,a1
LFF870C	move.b	(a0)+,(a1)+
	dbra	d1,LFF870C
	movea.l	(sp)+,a0
	bsr.w	ReleaseSoundSubProgramRam
	bra.b	LFF8722
LFF871A	move.w	#$6,d0
	bra.w	LFF87AC
LFF8722	move.w	#$0,$A11200.l
	move.w	#$0,$A11100.l
	move.w	#$1F4,d0
LFF8736	dbra	d0,LFF8736
	move.w	#$100,$A11200.l
	lea.l	SoundResourceBanks(pc),a0
	move.w	#$4,d0
LFF874A	move.l	#$FFFFFFFF,(a0)+
	dbra	d0,LFF874A
	lea.l	SequenceData(pc),a0
	move.w	#$7,d0
LFF875C	move.l	#$FFFFFFFF,(a0)+
	dbra	d0,LFF875C
	lea.l	SequencePosition(pc),a0
	move.w	#$7,d0
LFF876E	move.l	#$0,(a0)+
	dbra	d0,LFF876E
	lea.l	SequenceId(pc),a0
	move.w	#$7,d0
LFF8780	move.w	#$FFFF,(a0)+
	dbra	d0,LFF8780
	bsr.w	ClearPendingNoteOffs
	lea.l	PcmChannelRouting(pc),a0
	move.w	#$7,d0
LFF8794	move.w	#$0,(a0)+
	dbra	d0,LFF8794
	lea.l	DeferredSoundEvents(pc),a0
	move.w	#$0,(a0)
	andi.b	#$FE,ccr
	clr.w	d0
	bra.b	LFF87B0
LFF87AC	ori.b	#$1,ccr
LFF87B0	move.w	(sp)+,sr
	movem.l	(sp)+,d1/a0-a2
	rts
