;	MAIN.BIN $77B8-$EBFF (runtime $FF87B8-$FFFBFF).
;
;	After z80load.asm: the sound sequence engine (eight streams of MIDI-style events, timed note-offs,
;	the Z80 event queue, resource directories, bus access), its state and tables, then zeros to the end.
;	docs/segacd_main_shell.md.


X_FF94BC	equ	$FF94BC
X_FF953C	equ	$FF953C
X_FF95EA	equ	$FF95EA

	org	$FF87B8

TickSoundSequences
	movem.l	d0-d7/a0-a6,-(sp)
	lea	SoundEngineGuard(pc),a0
	cmpi.w	#$1234,(a0)
	bne.w	.LFF8A2A
	bsr.w	TickPendingNoteOffs
	bsr.w	ServiceZ80DataRequest
	lea	CurrentSoundStream(pc),a0
	move.w	#$0,(a0)
	lea	SequenceData(pc),a6
	lea	SequencePosition(pc),a5
	lea	SequenceDelay(pc),a4
	lea	SequenceTempo(pc),a3
	lea	SequenceFraction(pc),a2
	lea	SequenceRunState(pc),a1
.LFF87F0
	move.w	CurrentSoundStream(pc),d6
	lsl.w	#$1,d6
	move.w	d6,d7
	lsl.w	#$1,d7
	cmpi.l	#$FFFFFFFF,(a6,d7.w)
	beq.w	.LFF8A16
	tst.w	(a4,d6.w)
	beq.s	.LFF884E
	move.w	(a3,d6.w),d1
	add.w	(a2,d6.w),d1
	move.w	d1,d2
	andi.w	#$FF,d2
	lsr.w	#$8,d1
	add.w	(a1,d7.w),d1
	move.w	#$0,(a1,d7.w)
	cmp.w	(a4,d6.w),d1
	bge.s	.LFF883E
	move.w	(a4,d6.w),d3
	sub.w	d1,d3
	move.w	d3,(a4,d6.w)
	move.w	d2,(a2,d6.w)
	bra.w	.LFF8A16
.LFF883E
	sub.w	(a4,d6.w),d1
	lsl.w	#$8,d1
	or.w	d2,d1
	move.w	d1,(a2,d6.w)
	clr.w	(a4,d6.w)
.LFF884E
	movea.l	(a6,d7.w),a0
	move.l	(a5,d7.w),d5
.LFF8856
	tst.b	(a0,d5.l)
	bpl.s	.LFF8864
	addi.l	#$1,d5
	bra.s	.LFF8856
.LFF8864
	addi.l	#$1,d5
	tst.b	(a0,d5.l)
	bpl.s	.LFF887C
	move.b	(a0,d5.l),$2(a1,d7.w)
	addi.l	#$1,d5
.LFF887C
	move.b	$2(a1,d7.w),d0
	andi.b	#$F0,d0
	cmpi.b	#$90,d0
	bne.w	.LFF890C
	move.w	CurrentSoundStream(pc),d0
	lsl.w	#$8,d0
	lsl.w	#$4,d0
	move.b	$1(a0,d5.l),d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	move.b	$2(a1,d7.w),d0
	bsr.w	RouteSoundEvent
	tst.w	d0
	beq.s	.LFF88B6
	addi.w	#$1,(a1,d7.w)
	bra.w	.LFF8A16
.LFF88B6
	clr.l	d0
	move.b	$2(a0,d5.l),d0
	bpl.s	.LFF88CA
	andi.l	#$7F,d0
	lsl.l	#$7,d0
	or.b	$3(a0,d5.l),d0
.LFF88CA
	lsl.l	#$8,d0
	move.w	(a3,d6.w),d3
	divu.w	d3,d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	move.w	CurrentSoundStream(pc),d1
	lsl.w	#$4,d1
	move.b	$2(a1,d7.w),d0
	andi.b	#$F,d0
	or.b	d1,d0
	bsr.w	QueueTimedNoteOff
	addi.l	#$2,d5
.LFF88F4
	tst.b	(a0,d5.l)
	bpl.s	.LFF8902
	addi.l	#$1,d5
	bra.s	.LFF88F4
.LFF8902
	addi.l	#$1,d5
	bra.w	.LFF89F4
.LFF890C
	cmpi.b	#$B0,d0
	bne.s	.LFF897E
	cmpi.b	#$12,(a0,d5.l)
	bne.s	.LFF894C
	move.l	a0,-(sp)
	move.b	$1(a0,d5.l),d1
	move.w	CurrentSoundStream(pc),d0
	lsl.w	#$1,d0
	clr.w	d2
	move.b	$2(a1,d7.w),d2
	andi.b	#$F,d2
	lea	PcmChannelRouting(pc),a0
	move.w	(a0,d0.w),d3
	cmpi.b	#$0,d1
	bne.s	.LFF8942
	bclr	d2,d3
	bra.s	.LFF8944
.LFF8942
	bset	d2,d3
.LFF8944
	move.w	d3,(a0,d0.w)
	movea.l	(sp)+,a0
	bra.s	.LFF8976
.LFF894C
	move.w	CurrentSoundStream(pc),d0
	lsl.w	#$8,d0
	lsl.w	#$4,d0
	move.b	$1(a0,d5.l),d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	move.b	$2(a1,d7.w),d0
	bsr.w	RouteSoundEvent
	tst.w	d0
	beq.s	.LFF8976
	addi.w	#$1,(a1,d7.w)
	bra.w	.LFF8A16
.LFF8976
	addi.l	#$2,d5
	bra.s	.LFF89F4
.LFF897E
	cmpi.b	#$C0,d0
	bne.s	.LFF89B0
	move.w	CurrentSoundStream(pc),d0
	lsl.w	#$8,d0
	lsl.w	#$4,d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	move.b	$2(a1,d7.w),d0
	bsr.w	RouteSoundEvent
	tst.w	d0
	beq.s	.LFF89A8
	addi.w	#$1,(a1,d7.w)
	bra.s	.LFF8A16
.LFF89A8
	addi.l	#$1,d5
	bra.s	.LFF89F4
.LFF89B0
	cmpi.b	#$E0,d0
	bne.s	.LFF89E2
	move.w	CurrentSoundStream(pc),d0
	lsl.w	#$8,d0
	lsl.w	#$4,d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	move.b	$2(a1,d7.w),d0
	bsr.w	RouteSoundEvent
	tst.w	d0
	beq.s	.LFF89DA
	addi.w	#$1,(a1,d7.w)
	bra.s	.LFF8A16
.LFF89DA
	addi.l	#$1,d5
	bra.s	.LFF89F4
.LFF89E2
	cmpi.b	#$FF,$2(a1,d7.w)
	bne.s	.LFF89F4
	move.l	#$FFFFFFFF,(a6,d7.w)
	bra.s	.LFF8A16
.LFF89F4
	move.l	d5,(a5,d7.w)
	clr.w	d2
	move.b	(a0,d5.l),d2
	bpl.s	.LFF8A0A
	andi.b	#$7F,d2
	lsl.w	#$7,d2
	or.b	$1(a0,d5.l),d2
.LFF8A0A
	move.w	d2,(a4,d6.w)
	tst.w	d2
	bne.s	.LFF8A16
	bra.w	.LFF87F0
.LFF8A16
	lea	CurrentSoundStream(pc),a0
	addi.w	#$1,(a0)
	cmpi.w	#$8,(a0)
	blt.w	.LFF87F0
	bsr.w	FlushDeferredSoundEvents
.LFF8A2A
	andi.b	#$FE,ccr
	movem.l	(sp)+,d0-d7/a0-a6
	rts
StartSoundSequence
	movem.l	d1-d4/a0-a1,-(sp)
	lea	SoundEngineGuard(pc),a0
	move.w	d1,$1C8(a0)
	move.w	d2,$1CA(a0)
	move.w	d3,$1CC(a0)
	move.w	d4,$1CE(a0)
	lea	SequenceData(pc),a1
	clr.w	d0
.LFF8A52
	cmpi.l	#$FFFFFFFF,(a1)+
	beq.s	.LFF8A6A
	addi.w	#$1,d0
	cmpi.w	#$8,d0
	bne.s	.LFF8A52
	move.w	#$7,d0
	bra.s	.LFF8AD4
.LFF8A6A
	move.w	d0,$1C6(a0)
	move.w	#$3,d0
	bsr.w	FindSoundResource
	bcs.s	.LFF8AD4
	clr.l	d1
	move.b	$1(a0),d1
	lsl.w	#$8,d1
	move.b	(a0),d1
	lsl.w	#$1,d1
	addi.w	#$2,d1
	lea	SoundEngineGuard(pc),a1
	move.w	#$0,$0(a1)
	move.w	$1C6(a1),d0
	lsl.w	#$2,d0
	move.l	a0,$2(a1,d0.w)
	move.l	d1,$22(a1,d0.w)
	lea	SequenceRunState(pc),a0
	move.l	#$0,(a0,d0.w)
	move.w	$1C6(a1),d0
	lsl.w	#$1,d0
	move.w	$1CE(a1),$62(a1,d0.w)
	move.w	#$0,$52(a1,d0.w)
	move.w	#$0,$72(a1,d0.w)
	move.w	$1C8(a1),$42(a1,d0.w)
	move.w	#$1234,$0(a1)
	clr.w	d0
	bra.s	.LFF8AD8
.LFF8AD4
	ori.b	#$1,ccr
.LFF8AD8
	movem.l	(sp)+,d1-d4/a0-a1
	rts
StopSoundSequence
	movem.l	d1-d2/a0,-(sp)
	lea	SequenceId(pc),a0
	clr.w	d0
.LFF8AE8
	cmp.w	(a0)+,d1
	beq.s	.LFF8B00
	addi.w	#$1,d0
	cmpi.w	#$8,d0
	bne.s	.LFF8AE8
	move.w	#$3,d0
	ori.b	#$1,ccr
	bra.s	.LFF8B30
.LFF8B00
	lea	SoundEngineGuard(pc),a0
	move.w	d0,$1C6(a0)
	lsl.w	#$1,d0
	lea	SequenceId(pc),a0
	move.w	#$FFFF,(a0,d0.w)
	lsl.w	#$1,d0
	lea	SequenceData(pc),a0
	move.l	#$FFFFFFFF,(a0,d0.w)
	lea	SoundEngineGuard(pc),a0
	move.w	$1C6(a0),d0
	bsr.w	ExpireSequenceNoteOffs
	clr.w	d0
.LFF8B30
	movem.l	(sp)+,d1-d2/a0
	rts
PlayZ80Channel16Note
	movem.l	d1-d2/a0,-(sp)
	move.w	sr,-(sp)
	move.w	#$2700,sr
	bsr.w	AcquireSoundZ80Bus
	lea	$A00000.l,a0
	move.b	$A00028.l,d0
	lsl.w	#$8,d0
	move.b	$A00029.l,d0
	move.b	d1,$3(a0,d0.w)
	bsr.w	ReleaseSoundZ80Bus
	move.w	(sp)+,sr
	move.l	#$0,d0
	move.b	#$7F,d0
	lsl.w	#$8,d0
	move.b	#$CF,d0
	bsr.w	QueueZ80SoundEvent
	move.l	#$7F0000,d0
	move.w	d2,d0
	lsl.w	#$8,d0
	move.b	#$9F,d0
	bsr.w	QueueZ80SoundEvent
	clr.w	d0
	movem.l	(sp)+,d1-d2/a0
	rts
ClearZ80SoundBuffers
	movem.l	a0-a1,-(sp)
	lea	SoundEngineGuard(pc),a0
	move.w	#$0,$0(a0)
	bsr.w	AcquireSoundZ80Bus
	clr.l	d0
	move.b	$A00024.l,d0
	lsl.w	#$8,d0
	move.b	$A00025.l,d0
	addi.l	#$A00000,d0
	movea.l	d0,a1
	move.w	#$1FF,d0
.LFF8BBE
	move.b	#$0,(a1)+
	dbf	d0,.LFF8BBE
	clr.l	d0
	move.b	$A00026.l,d0
	lsl.w	#$8,d0
	move.b	$A00027.l,d0
	addi.l	#$A00000,d0
	movea.l	d0,a1
	move.w	#$1FF,d0
.LFF8BE2
	move.b	#$0,(a1)+
	dbf	d0,.LFF8BE2
	bsr.w	ReleaseSoundZ80Bus
	move.w	#$1234,$0(a0)
	clr.w	d0
	movem.l	(sp)+,a0-a1
	rts
RouteSoundEvent
	movem.l	d1-d3/a0,-(sp)
	lea	PcmChannelRouting(pc),a0
	move.l	d0,d1
	swap	d1
	lsr.w	#$8,d1
	lsr.w	#$3,d1
	move.w	(a0,d1.w),d2
	move.w	d0,d3
	andi.w	#$F,d3
	btst	d3,d2
	bne.s	.LFF8C20
	bsr.w	QueueZ80SoundEvent
	bra.s	.LFF8C24
.LFF8C20
	bsr.w	QueueDeferredSoundEvent
.LFF8C24
	movem.l	(sp)+,d1-d3/a0
	rts
QueueDeferredSoundEvent
	movem.l	d1-d2/a0,-(sp)
	lea	SoundEngineGuard(pc),a0
	move.w	#$0,(a0)
	lea	DeferredSoundEvents(pc),a0
	move.w	(a0),d2
	cmpi.w	#$20,d2
	bne.s	.LFF8C54
	lea	SoundEngineGuard(pc),a0
	move.w	#$1234,(a0)
	move.w	#$FFFF,d0
	ori.b	#$1,ccr
	bra.s	.LFF8C70
.LFF8C54
	move.w	d2,d1
	lsl.w	#$2,d1
	addi.w	#$2,d1
	move.l	d0,(a0,d1.w)
	addi.w	#$1,d2
	move.w	d2,(a0)
	lea	SoundEngineGuard(pc),a0
	move.w	#$1234,(a0)
	clr.w	d0
.LFF8C70
	movem.l	(sp)+,d1-d2/a0
	rts
QueueZ80SoundEvent
	movem.l	d1/a0,-(sp)
	lea	SoundEngineGuard(pc),a0
	move.w	#$0,$0(a0)
.LFF8C84
	bsr.w	AcquireSoundZ80Bus
	lea	$A00030.l,a0
	tst.b	(a0)
	beq.s	.LFF8CA2
	bsr.w	ReleaseSoundZ80Bus
	move.w	#$64,d1
.LFF8C9A
	subi.w	#$1,d1
	bne.s	.LFF8C9A
	bra.s	.LFF8C84
.LFF8CA2
	adda.l	#$1,a0
	cmpi.b	#$18,(a0)
	blt.s	.LFF8CB4
	move.w	#$FFFF,d0
	bra.s	.LFF8CDC
.LFF8CB4
	clr.w	d1
	move.b	(a0),d1
	lsl.w	#$2,d1
	move.b	d0,$1(a0,d1.w)
	ror.w	#$8,d0
	move.b	d0,$2(a0,d1.w)
	swap	d0
	move.b	d0,$3(a0,d1.w)
	ror.w	#$8,d0
	move.b	d0,$4(a0,d1.w)
	move.b	(a0),d1
	addi.b	#$1,d1
	move.b	d1,(a0)
	move.w	#$0,d0
.LFF8CDC
	bsr.w	ReleaseSoundZ80Bus
	lea	SoundEngineGuard(pc),a0
	move.w	#$1234,$0(a0)
	movem.l	(sp)+,d1/a0
	rts
FlushDeferredSoundEvents
	movem.l	d0-d1/a0-a1,-(sp)
	lea	DeferredSoundEvents(pc),a1
	cmpi.w	#$0,(a1)
	beq.s	.LFF8D54
	movea.l	PcmQueuePointer(pc),a0
	bsr.w	AcquireSoundSubProgramRam
	bsr.w	MapSoundSubProgramPointer
.LFF8D0A
	cmpi.w	#$FFFF,(a0)
	bne.s	.LFF8D2E
	movea.l	PcmQueuePointer(pc),a0
	bsr.w	ReleaseSoundSubProgramRam
	move.w	#$1F4,d0
.LFF8D1C
	dbf	d0,.LFF8D1C
	movea.l	PcmQueuePointer(pc),a0
	bsr.w	AcquireSoundSubProgramRam
	bsr.w	MapSoundSubProgramPointer
	bra.s	.LFF8D0A
.LFF8D2E
	move.w	(a1),d0
	move.w	(a0),d1
	add.w	d1,d0
	move.w	d0,(a0)+
	lsl.w	#$2,d1
	ext.l	d1
	adda.l	d1,a0
	move.w	(a1)+,d0
.LFF8D3E
	move.l	(a1)+,(a0)+
	dbf	d0,.LFF8D3E
	lea	DeferredSoundEvents(pc),a1
	move.w	#$0,(a1)
	movea.l	PcmQueuePointer(pc),a0
	bsr.w	ReleaseSoundSubProgramRam
.LFF8D54
	movem.l	(sp)+,d0-d1/a0-a1
	rts
UploadZ80SoundResource
	movem.l	d0-d2/a0-a1,-(sp)
	lea	SoundEngineGuard(pc),a1
	move.w	#$0,(a1)
	bsr.w	AcquireSoundZ80Bus
	move.b	$A00022.l,d2
	lsl.w	#$8,d2
	move.b	$A00023.l,d2
	add.w	d1,d2
	cmpi.w	#$1F00,d2
	bcs.s	.LFF8D8C
	move.w	#$4,d0
	ori.b	#$1,ccr
	bra.w	.LFF8E18
.LFF8D8C
	lea	$A00100.l,a1
	move.w	#$40,d2
.LFF8D96
	cmpi.b	#$FF,(a1)
	beq.s	.LFF8DC0
	adda.l	#$4,a1
	subi.w	#$1,d2
	bne.s	.LFF8D96
	bsr.w	ReleaseSoundZ80Bus
	lea	SoundEngineGuard(pc),a1
	move.w	#$1234,(a1)
	move.w	#$7,d0
	ori.b	#$1,ccr
	bra.w	.LFF8E18
.LFF8DC0
	move.b	d0,(a1)
	move.b	d1,$1(a1)
	move.b	$A00022.l,d2
	move.b	d2,$2(a1)
	move.b	$A00023.l,d2
	move.b	d2,$3(a1)
	lea	$A00000.l,a1
	clr.l	d2
	move.b	$A00022.l,d2
	lsl.w	#$8,d2
	move.b	$A00023.l,d2
.LFF8DF0
	move.b	(a0)+,(a1,d2.w)
	addi.w	#$1,d2
	dbf	d1,.LFF8DF0
	move.b	d2,$A00023.l
	lsr.w	#$8,d2
	move.b	d2,$A00022.l
	bsr.w	ReleaseSoundZ80Bus
	lea	SoundEngineGuard(pc),a1
	move.w	#$1234,(a1)
	clr.w	d0
.LFF8E18
	movem.l	(sp)+,d0-d2/a0-a1
	rts
ClearPendingNoteOffs
	movem.l	d0-d1/a0-a1,-(sp)
	lea	SoundEngineGuard(pc),a0
	move.w	#$0,$0(a0)
	move.w	#$0,$122(a0)
	lea	X_FF94BC(pc),a1
	move.w	#$1F,d1
	move.l	#$FFFFFFFF,d0
.LFF8E40
	move.l	d0,(a1)+
	dbf	d1,.LFF8E40
	move.w	#$1234,$0(a0)
	movem.l	(sp)+,d0-d1/a0-a1
	rts
ExpireSequenceNoteOffs
	movem.l	d0-d2/a0-a1,-(sp)
	lea	SoundEngineGuard(pc),a0
	move.w	#$0,$0(a0)
	lea	X_FF94BC(pc),a1
	move.w	$122(a0),d1
	clr.w	d2
.LFF8E6A
	cmpi.w	#$0,d1
	beq.s	.LFF8E8A
	move.b	$3(a1),d2
	lsr.b	#$4,d2
	cmp.w	d0,d2
	bne.s	.LFF8E7E
	move.w	#$1,(a1)
.LFF8E7E
	adda.l	#$4,a1
	subi.w	#$1,d1
	bra.s	.LFF8E6A
.LFF8E8A
	move.w	#$1234,$0(a0)
	movem.l	(sp)+,d0-d2/a0-a1
	rts
QueueTimedNoteOff
	movem.l	d0-d1/a0,-(sp)
	lea	SoundEngineGuard(pc),a0
	move.w	$122(a0),d1
	lsl.w	#$2,d1
	lea	X_FF94BC(pc),a0
	move.l	d0,(a0,d1.w)
	lea	SoundEngineGuard(pc),a0
	addi.w	#$1,$122(a0)
	movem.l	(sp)+,d0-d1/a0
	rts
TickPendingNoteOffs
	movem.l	d0-d1/a0-a2,-(sp)
	lea	SoundEngineGuard(pc),a2
	cmpi.w	#$0,$122(a2)
	beq.s	.LFF8F2A
	lea	X_FF94BC(pc),a0
.LFF8ED0
	cmpi.w	#$FFFF,(a0)
	beq.s	.LFF8F2A
	subi.w	#$1,(a0)
	bne.s	.LFF8F24
	move.b	$3(a0),d0
	andi.b	#$F0,d0
	lsl.w	#$8,d0
	swap	d0
	move.w	$2(a0),d0
	andi.b	#$F,d0
	ori.b	#$80,d0
	bsr.w	RouteSoundEvent
	tst.w	d0
	beq.s	.LFF8F02
	addi.w	#$1,(a0)
	bra.s	.LFF8F24
.LFF8F02
	lea	X_FF94BC(pc),a1
	move.w	X_FF953C(pc),d0
	subi.w	#$1,d0
	lsl.w	#$2,d0
	move.l	(a1,d0.w),(a0)
	move.l	#$FFFFFFFF,(a1,d0.w)
	subi.w	#$1,$122(a2)
	bra.s	.LFF8ED0
.LFF8F24
	adda.w	#$4,a0
	bra.s	.LFF8ED0
.LFF8F2A
	movem.l	(sp)+,d0-d1/a0-a2
	rts
ServiceZ80DataRequest
	movem.l	d1-d2/a0,-(sp)
	bsr.w	AcquireSoundZ80Bus
	tst.b	$A00072.l
	beq.w	.LFF90B8
	cmpi.b	#$1,$A00072.l
	bne.s	.LFF8FCA
	clr.w	d1
	move.b	$A00073.l,d1
	move.w	#$1,d0
	bsr.w	FindSoundResource
	bcs.w	.LFF90B8
	cmpa.l	#$FFFFFFFF,a0
	beq.w	.LFF90B8
	lea	SoundEngineGuard(pc),a1
	move.l	a0,$126(a1)
	move.l	a0,-(sp)
	bsr.w	AcquireSoundSubProgramRam
	bsr.w	MapSoundSubProgramPointer
.LFF8F7C
	move.b	(a0),d0
	cmp.b	(a0),d0
	bne.s	.LFF8F7C
	lsl.w	#$8,d0
	adda.l	#$1,a0
.LFF8F8A
	move.b	(a0),d0
	cmp.b	(a0),d0
	bne.s	.LFF8F8A
	move.w	d0,$12E(a1)
	adda.l	#$1,a0
	movea.l	(sp)+,a0
	bsr.w	ReleaseSoundSubProgramRam
	movea.l	$126(a1),a0
	adda.l	#$2,a0
	move.l	a0,$12A(a1)
	clr.l	d0
	move.b	$A00024.l,d0
	lsl.w	#$8,d0
	move.b	$A00025.l,d0
	addi.l	#$A00000,d0
	movea.l	d0,a1
	bra.w	.LFF904A
.LFF8FCA
	cmpi.b	#$2,$A00072.l
	bne.s	.LFF900A
	movea.l	DacSamplePosition(pc),a0
	cmpa.l	#$0,a0
	bne.s	.LFF8FF0
	bsr.w	ReleaseSoundZ80Bus
	bsr.w	ClearZ80SoundBuffers
	bsr.w	AcquireSoundZ80Bus
	bra.w	.LFF90B8
.LFF8FF0
	clr.l	d0
	move.b	$A00024.l,d0
	lsl.w	#$8,d0
	move.b	$A00025.l,d0
	addi.l	#$A00000,d0
	movea.l	d0,a1
	bra.s	.LFF904A
.LFF900A
	cmpi.b	#$3,$A00072.l
	bne.w	.LFF90B8
	movea.l	DacSamplePosition(pc),a0
	cmpa.l	#$0,a0
	bne.s	.LFF9032
	bsr.w	ReleaseSoundZ80Bus
	bsr.w	ClearZ80SoundBuffers
	bsr.w	AcquireSoundZ80Bus
	bra.w	.LFF90B8
.LFF9032
	clr.l	d0
	move.b	$A00026.l,d0
	lsl.w	#$8,d0
	move.b	$A00027.l,d0
	addi.l	#$A00000,d0
	movea.l	d0,a1
.LFF904A
	move.l	a0,-(sp)
	bsr.w	AcquireSoundSubProgramRam
	bsr.w	MapSoundSubProgramPointer
	move.w	#$1FF,d1
.LFF9058
	move.b	(a0)+,(a1)+
	beq.s	.LFF907A
	dbf	d1,.LFF9058
	lea	SoundEngineGuard(pc),a1
	move.l	$12A(a1),d0
	addi.l	#$200,d0
	move.l	d0,$12A(a1)
	movea.l	(sp)+,a0
	bsr.w	ReleaseSoundSubProgramRam
	bra.s	.LFF90B8
.LFF907A
	suba.l	#$1,a1
	movea.l	(sp)+,a0
	bsr.w	ReleaseSoundSubProgramRam
	clr.l	d0
	move.w	DacSampleLoop(pc),d0
	cmpi.w	#$FFFF,d0
	beq.s	.LFF90AC
	move.b	#$FF,(a1)
	lea	SoundEngineGuard(pc),a1
	movea.l	$126(a1),a0
	adda.l	#$2,a0
	adda.l	d0,a0
	move.l	a0,$12A(a1)
	bra.s	.LFF90B8
.LFF90AC
	lea	SoundEngineGuard(pc),a1
	move.l	#$0,$12A(a1)
.LFF90B8
	move.b	#$0,$A00072.l
	bsr.w	ReleaseSoundZ80Bus
	movem.l	(sp)+,d1-d2/a0
	rts
FindSoundResource
	movem.l	d1-d4/a1-a2,-(sp)
	lea	SoundResourceBanks(pc),a1
	move.w	#$4,d2
.LFF90D6
	cmpi.l	#$FFFFFFFF,(a1)
	beq.w	.LFF9180
	movea.l	(a1),a0
	movea.l	a0,a2
	move.l	a0,-(sp)
	bsr.w	AcquireSoundSubProgramRam
	bsr.w	MapSoundSubProgramPointer
	clr.l	d3
.LFF90F0
	move.b	(a0),d3
	cmp.b	(a0),d3
	bne.s	.LFF90F0
	adda.l	#$1,a0
	lsl.w	#$8,d3
.LFF90FE
	move.b	(a0),d3
	cmp.b	(a0),d3
	bne.s	.LFF90FE
	adda.l	#$1,a0
	move.l	d3,d4
	lsl.w	#$2,d4
	adda.l	d4,a2
	adda.l	#$2,a2
.LFF9116
	move.b	(a0),d4
	cmp.b	(a0),d4
	bne.s	.LFF9116
	cmp.b	d4,d0
	bne.s	.LFF9154
.LFF9120
	move.b	$1(a0),d4
	cmp.b	$1(a0),d4
	bne.s	.LFF9120
	cmp.b	d4,d1
	bne.s	.LFF9154
	clr.w	d0
.LFF9130
	move.b	$2(a0),d0
	cmp.b	$2(a0),d0
	bne.s	.LFF9130
	lsl.w	#$8,d0
.LFF913C
	move.b	$3(a0),d0
	cmp.b	$3(a0),d0
	bne.s	.LFF913C
	movea.l	(sp)+,a0
	bsr.w	ReleaseSoundSubProgramRam
	movea.l	a2,a0
	andi.b	#$FE,ccr
	bra.s	.LFF9196
.LFF9154
	clr.l	d4
	move.b	$2(a0),d4
	cmp.b	$2(a0),d4
	bne.s	.LFF9154
	lsl.w	#$8,d4
.LFF9162
	move.b	$3(a0),d4
	cmp.b	$3(a0),d4
	bne.s	.LFF9162
	adda.l	d4,a2
	adda.l	#$4,a0
	subi.w	#$1,d3
	bne.s	.LFF9116
	movea.l	(sp)+,a0
	bsr.w	ReleaseSoundSubProgramRam
.LFF9180
	adda.l	#$4,a1
	subi.w	#$1,d2
	bne.w	.LFF90D6
	move.w	#$3,d0
	ori.b	#$1,ccr
.LFF9196
	movem.l	(sp)+,d1-d4/a1-a2
	rts
RegisterSoundResourceBank
	movem.l	d1/a1,-(sp)
	lsl.w	#$2,d1
	lea	SoundResourceBanks(pc),a1
	move.l	a0,(a1,d1.w)
	movem.l	(sp)+,d1/a1
	rts
LoadZ80SoundResources
	movem.l	d1/a0-a1,-(sp)
	movea.l	a0,a1
.LFF91B6
	cmpi.w	#$FFFF,(a1)
	bne.s	.LFF91C0
	clr.w	d0
	bra.s	.LFF91F4
.LFF91C0
	move.w	(a1),d0
	move.w	$2(a1),d1
	bsr.w	FindSoundResource
	bcs.s	.LFF91F0
	cmpi.w	#$0,(a1)
	bne.s	.LFF91E8
	cmpi.b	#$6,(a0)
	bcc.s	.LFF91E8
	move.w	d0,d1
	move.w	$2(a1),d0
	bsr.w	UploadZ80SoundResource
	bcs.s	.LFF91F0
	bra.w	.LFF91E8
.LFF91E8
	adda.l	#$4,a1
	bra.s	.LFF91B6
.LFF91F0
	ori.b	#$1,ccr
.LFF91F4
	movem.l	(sp)+,d1/a0-a1
	rts
RemoveZ80SoundResources
	movem.l	d1-d3/a0-a2,-(sp)
	lea	SoundEngineGuard(pc),a1
	move.w	#$0,(a1)
	bsr.w	AcquireSoundZ80Bus
.LFF920A
	cmpi.w	#$FFFF,(a0)
	beq.w	.LFF92E4
	cmpi.w	#$6,(a0)
	bcc.w	.LFF92DA
	lea	$A00100.l,a1
	move.w	$2(a0),d0
	move.w	#$3F,d1
.LFF9228
	cmp.b	(a1),d0
	beq.s	.LFF923A
	adda.l	#$4,a1
	dbf	d1,.LFF9228
	bra.w	.LFF92DA
.LFF923A
	clr.w	d0
	move.b	$1(a1),d0
	clr.w	d1
	move.b	$2(a1),d1
	lsl.w	#$8,d1
	move.b	$3(a1),d1
	move.w	d1,d2
	add.w	d0,d2
	lea	$A00000.l,a2
.LFF9256
	cmpi.w	#$1F00,d2
	beq.s	.LFF926C
	move.b	(a2,d2.w),(a2,d1.w)
	addi.w	#$1,d2
	addi.w	#$1,d1
	bra.s	.LFF9256
.LFF926C
	clr.w	d1
	move.b	$2(a1),d1
	lsl.w	#$8,d1
	move.b	$3(a1),d1
	move.b	#$FF,(a1)
	move.b	#$FF,$1(a1)
	move.b	#$FF,$2(a1)
	move.b	#$FF,$3(a1)
	lea	$A00100.l,a1
	move.w	#$3F,d2
.LFF9298
	cmpi.b	#$FF,(a1)
	bne.w	.LFF92BC
	clr.w	d3
	move.b	$2(a1),d3
	lsl.w	#$8,d3
	move.b	$3(a1),d3
	cmp.w	d1,d3
	bcc.s	.LFF92BC
	sub.w	d0,d3
	move.b	d3,$3(a1)
	lsr.w	#$8,d3
	move.b	d3,$2(a1)
.LFF92BC
	dbf	d2,.LFF9298
	lea	$A00022.l,a1
	clr.w	d1
	move.b	(a1),d1
	lsl.w	#$8,d1
	move.b	$1(a1),d1
	sub.w	d0,d1
	move.b	d1,$1(a1)
	lsr.w	#$8,d1
	move.b	d1,(a1)
.LFF92DA
	adda.l	#$4,a0
	bra.w	.LFF920A
.LFF92E4
	bsr.w	ReleaseSoundZ80Bus
	lea	SoundEngineGuard(pc),a1
	move.w	#$1234,(a1)
	clr.w	d0
	movem.l	(sp)+,d1-d3/a0-a2
	rts
ClearZ80SoundResourceDirectory
	movem.l	a0-a1,-(sp)
	lea	SoundEngineGuard(pc),a0
	move.w	#$0,(a0)
	bsr.w	AcquireSoundZ80Bus
	lea	$A00100.l,a0
	move.w	#$FF,d0
.LFF9312
	move.b	#$FF,(a0)+
	dbf	d0,.LFF9312
	lea	$A00020.l,a0
	lea	$A00022.l,a1
	move.b	(a0)+,(a1)+
	move.b	(a0),(a1)
	bsr.w	ReleaseSoundZ80Bus
	lea	SoundEngineGuard(pc),a0
	move.w	#$1234,(a0)
	clr.w	d0
	movem.l	(sp)+,a0-a1
	rts
AcquireSoundZ80Bus
	move.w	#$100,$A11100.l
.LFF9346
	btst.b	#$8,$A11100.l
	bne.s	.LFF9346
	rts
ReleaseSoundZ80Bus
	move.w	#$0,$A11100.l
	rts
AcquireSoundSubProgramRam
	movem.l	d0-d1/a1,-(sp)
	cmpa.l	#$80000,a0
	bcc.w	.LFF93AA
	move.b	#$3,$A12001.l
.LFF9372
	move.w	$A12000.l,d0
	btst	#$1,d0
	beq.s	.LFF9372
	move.l	a0,d0
	swap	d0
	andi.w	#$6,d0
	lsl.w	#$5,d0
	lea	X_FF95EA(pc),a1
	move.w	$A12002.l,d1
	move.w	d1,(a1)
	btst	#$2,d1
	beq.s	.LFF939E
	bset	#$1,d0
.LFF939E
	andi.w	#$FF00,d1
	or.w	d0,d1
	move.w	d1,$A12002.l
.LFF93AA
	movem.l	(sp)+,d0-d1/a1
	rts
ReleaseSoundSubProgramRam
	move.l	d0,-(sp)
	cmpa.l	#$80000,a0
	bcc.s	.LFF93F8
	move.w	X_FF95EA(pc),d0
	btst	#$2,d0
	beq.s	.LFF93CE
	andi.w	#$FFC0,d0
	bset	#$1,d0
	bra.s	.LFF93D2
.LFF93CE
	andi.w	#$FFC0,d0
.LFF93D2
	move.w	d0,$A12002.l
	move.w	#$1,$A12000.l
.LFF93E0
	move.w	$A12000.l,d0
	btst	#$1,d0
	bne.s	.LFF93E0
	move.w	$A12000.l,d0
	btst	#$1,d0
	bne.s	.LFF93E0
.LFF93F8
	move.l	(sp)+,d0
	rts
MapSoundSubProgramPointer
	move.l	d0,-(sp)
	cmpa.l	#$80000,a0
	bcc.s	.LFF9416
	move.l	a0,d0
	andi.l	#$1FFFF,d0
	ori.l	#$20000,d0
	movea.l	d0,a0
.LFF9416
	move.l	(sp)+,d0
	rts
SoundEngineGuard
	dc.w	$0000
SequenceData
	dcb.b	32,0
SequencePosition
	dcb.b	32,0
SequenceId
	dcb.b	16,0
SequenceDelay
	dcb.b	16,0
SequenceTempo
	dcb.b	16,0
SequenceFraction
	dcb.b	16,0
SequenceRunState
	dcb.b	32,0
	dcb.b	130,0
CurrentSoundStream
	dc.w	$0000
DacSampleRecord
	ori.b	#$0,d0
DacSamplePosition
	ori.b	#$0,d0
DacSampleLoop
	dc.w	$0000
PcmChannelRouting
	dcb.b	16,0
PcmQueuePointer
	ori.b	#$0,d0
DeferredSoundEvents
	dcb.b	140,0
	dc.w	$0000
SoundResourceBanks
	dcb.b	80,0
SoundBank
	dc.w	$004F,$0326,$0004,$0327,$0004,$0304,$0064,$0303
	dc.w	$0010,$0301,$0010,$0302,$0010,$030C,$0010,$030E
	dc.w	$0018,$031C,$0018,$031D,$0018,$031E,$0018,$031F
	dc.w	$001C,$030B,$0012,$030F,$002D,$030D,$0010,$0310
	dc.w	$0010,$0311,$0010,$0312,$0010,$0313,$0010,$0320
	dc.w	$001C,$0321,$001C,$0322,$001C,$0323,$001C,$0324
	dc.w	$001C,$0307,$001C,$032C,$0010,$032D,$0010,$032E
	dc.w	$0010,$032F,$0010,$0308,$001E,$0325,$0010,$0328
	dc.w	$0010,$0329,$0010,$032A,$0010,$032B,$0010,$0309
	dc.w	$0010,$030A,$0010,$0314,$0010,$0315,$0010,$0316
	dc.w	$0010,$0317,$0010,$0318,$0010,$0319,$0010,$031A
	dc.w	$0010,$031B,$0010,$0300,$0117,$0306,$001C,$0305
	dc.w	$0010,$0000,$0024,$0001,$0024,$0002,$0024,$0003
	dc.w	$0024,$0004,$0024,$0005,$0024,$0006,$0024,$0007
	dc.w	$0024,$0008,$0024,$0009,$0024,$000A,$0024,$000B
	dc.w	$0024,$000C,$0024,$000D,$0024,$000E,$0024,$000F
	dc.w	$0024,$0010,$0024,$0011,$0024,$0012,$0024,$0013
	dc.w	$0024,$0014,$0024,$0015,$0024,$0016,$0024,$0017
	dc.w	$0024,$0018,$0024,$0019,$0024,$001A,$0024,$001B
	dc.w	$0024,$001C,$0024,$001D,$0024,$001F,$0024,$0000
	dc.w	$00FF,$0000,$00FF,$0000,$00B0,$1200,$00C0,$1A00
	dc.w	$B112,$0000,$C11A,$0090,$3E7F,$6E00,$E06C,$0091
	dc.w	$3E7F,$6E00,$E165,$00E0,$6700,$E160,$01E0,$6300
	dc.w	$E15C,$01E0,$5E00,$E157,$01E0,$5A00,$E153,$00E0
	dc.w	$5600,$E14F,$01E0,$5100,$E14A,$01E0,$4D00,$E146
	dc.w	$00E0,$4800,$E141,$01E0,$4400,$E13D,$01E0,$4000
	dc.w	$E139,$68E0,$4000,$E140,$00FF,$0000,$00B0,$1201
	dc.w	$00C0,$6F00,$903C,$7F1E,$1EFF,$0000,$00B0,$1200
	dc.w	$00C0,$1D00,$9048,$7F14,$14FF,$0000,$00B0,$1200
	dc.w	$00C0,$1D00,$904A,$7F14,$14FF,$0000,$00B0,$1201
	dc.w	$00C0,$6B00,$903A,$605A,$5AFF,$0000,$00B0,$1201
	dc.w	$00C0,$6E00,$905B,$7F1E,$1EC0,$6C00,$9048,$7F50
	dc.w	$50FF,$0000,$00B0,$1201,$00C0,$6700,$903C,$7F04
	dc.w	$04C0,$6500,$904A,$7F28,$28FF,$0000,$00B0,$1201
	dc.w	$00C0,$6700,$9032,$7F0A,$0AC0,$6400,$9042,$7F28
	dc.w	$28FF,$0000,$00B0,$1201,$00C0,$6700,$9037,$5F04
	dc.w	$04C0,$6500,$9046,$5F32,$32FF,$0000,$00B0,$1201
	dc.w	$00C0,$6700,$902D,$4006,$063C,$4003,$03C0,$6400
	dc.w	$903C,$5F1E,$1EFF,$0000,$00B0,$1201,$00C0,$6D00
	dc.w	$9043,$7F81,$7081,$70FF,$0000,$00B0,$1201,$00C0
	dc.w	$6D00,$9045,$5A81,$3478,$4250,$8134,$8116,$4346
	dc.w	$8120,$7844,$3C81,$0C5A,$4232,$815C,$8134,$4328
	dc.w	$8148,$8148,$FF00,$0000,$B012,$0100,$C06C,$0090
	dc.w	$467F,$6464,$FF00,$0000,$B012,$0100,$C061,$0090
	dc.w	$467F,$1919,$FF00,$0000,$B012,$0100,$C061,$0090
	dc.w	$455F,$1919,$FF00,$0000,$B012,$0100,$C061,$0090
	dc.w	$4450,$1919,$FF00,$0000,$B012,$0100,$C061,$0090
	dc.w	$4432,$1919,$FF00,$0000,$B012,$0100,$C066,$0090
	dc.w	$437F,$2000,$B112,$0100,$C118,$0091,$1450,$0220
	dc.w	$FF00,$0000,$B012,$0100,$C066,$0090,$4369,$2000
	dc.w	$B112,$0100,$C118,$0091,$1446,$0220,$FF00,$0000
	dc.w	$B012,$0100,$C066,$0090,$4250,$2000,$B112,$0100
	dc.w	$C118,$0091,$143C,$0220,$FF00,$0000,$B012,$0100
	dc.w	$C066,$0090,$423C,$2000,$B112,$0100,$C118,$0091
	dc.w	$1432,$0220,$FF00,$0000,$B012,$0000,$C019,$0090
	dc.w	$1C28,$1400,$B112,$0000,$C11B,$0091,$0828,$1414
	dc.w	$FF00,$0000,$B012,$0100,$C060,$0090,$4A7F,$0A00
	dc.w	$B112,$0100,$C117,$0091,$1440,$020A,$FF00,$0000
	dc.w	$B012,$0000,$C017,$0090,$147F,$0202,$FF00,$0000
	dc.w	$B012,$0000,$C017,$0090,$125F,$0202,$FF00,$0000
	dc.w	$B012,$0000,$C017,$0090,$0E50,$0202,$FF00,$0000
	dc.w	$B012,$0000,$C017,$0090,$0A32,$0202,$FF00,$0000
	dc.w	$B012,$0000,$C016,$0090,$3C78,$0606,$B012,$0100
	dc.w	$C06C,$0090,$467F,$8112,$8112,$FF00,$0000,$B012
	dc.w	$0000,$C016,$0090,$3C7F,$0606,$FF00,$0000,$B012
	dc.w	$0000,$C018,$0090,$197F,$0404,$FF00,$0000,$B012
	dc.w	$0000,$C018,$0090,$195F,$0303,$FF00,$0000,$B012
	dc.w	$0000,$C018,$0090,$1950,$0202,$FF00,$0000,$B012
	dc.w	$0000,$C018,$0090,$1932,$0101,$FF00,$0000,$B012
	dc.w	$0100,$C067,$0090,$3C7F,$1E1E,$FF00,$0000,$B012
	dc.w	$0100,$C067,$0090,$417F,$1E1E,$FF00,$0000,$B012
	dc.w	$0100,$C062,$0090,$4A7F,$1919,$FF00,$0000,$B012
	dc.w	$0100,$C062,$0090,$495F,$1919,$FF00,$0000,$B012
	dc.w	$0100,$C062,$0090,$4850,$1919,$FF00,$0000,$B012
	dc.w	$0100,$C062,$0090,$4832,$1919,$FF00,$0000,$B012
	dc.w	$0100,$C063,$0090,$4A7F,$1E1E,$FF00,$0000,$B012
	dc.w	$0100,$C063,$0090,$495F,$1E1E,$FF00,$0000,$B012
	dc.w	$0100,$C063,$0090,$4850,$1E1E,$FF00,$0000,$B012
	dc.w	$0100,$C063,$0090,$4832,$1E1E,$FF01,$0000,$0000
	dc.w	$B012,$0000,$C01F,$00E0,$2800,$9049,$7182,$3C03
	dc.w	$E02A,$022B,$022D,$022E,$022F,$0231,$0232,$0234
	dc.w	$0235,$0237,$0238,$023A,$023B,$023C,$023E,$023F
	dc.w	$0241,$0242,$0244,$0245,$0247,$0248,$0249,$024B
	dc.w	$024C,$024E,$024F,$0251,$0252,$0253,$0255,$0256
	dc.w	$0258,$0259,$025B,$025C,$025E,$025F,$0260,$0262
	dc.w	$0263,$0265,$0366,$0268,$0269,$026B,$026C,$026D
	dc.w	$026F,$0270,$0272,$0273,$0275,$0276,$0278,$0279
	dc.w	$027A,$027C,$027D,$027F,$017E,$037C,$037B,$0379
	dc.w	$0378,$0376,$0375,$0374,$0472,$0371,$036F,$036E
	dc.w	$036D,$036B,$036A,$0368,$0367,$0366,$0464,$0363
	dc.w	$0361,$0360,$035F,$035D,$035C,$035A,$0359,$0358
	dc.w	$0456,$0355,$0353,$0352,$0350,$034F,$034E,$034C
	dc.w	$034B,$0349,$0448,$0347,$0345,$0344,$0342,$0341
	dc.w	$0340,$033E,$033D,$033B,$033A,$0439,$0337,$0336
	dc.w	$0334,$0333,$0332,$0330,$032F,$032D,$032C,$042A
	dc.w	$0329,$0328,$0326,$0325,$0323,$0322,$0321,$0340
	dc.w	$00FF,$0000,$00B0,$1200,$00C0,$1900,$901C,$3214
	dc.w	$00B1,$1200,$00C1,$1B00,$9108,$3214,$14FF,$0000
	dc.w	$00B0,$1200,$00C0,$1C00,$903C,$7F14,$14FF,$0000
	dc.w	$3D37,$3731,$1720,$2000,$1F1F,$1F1F,$1B12,$0D0C
	dc.w	$0000,$0000,$F5F4,$F5F6,$02C0,$00F0,$0007,$0702
	dc.w	$0000,$0000,$1501,$5531,$2E18,$2600,$D313,$D3D3
	dc.w	$0202,$0202,$0101,$0101,$3434,$3434,$3AC0,$00F0
	dc.w	$0004,$0402,$0000,$0000,$3C37,$0161,$2C30,$0707
	dc.w	$5F5F,$5F5F,$0C08,$0505,$1212,$0012,$F5F6,$F5F6
	dc.w	$3CD0,$00F0,$0001,$0102,$0000,$0000,$6F31,$3131
	dc.w	$4019,$0000,$1F5F,$1F5F,$0E0F,$1212,$0F05,$0606
	dc.w	$6E1B,$1818,$34C0,$00F0,$0001,$0102,$0000,$0000
	dc.w	$0161,$0132,$1A00,$0000,$1A1C,$1F0E,$0C0B,$0B0B
	dc.w	$0701,$0000,$0507,$0508,$3DC0,$00F0,$0002,$0202
	dc.w	$0000,$0000,$3030,$3030,$1513,$1800,$1F1F,$1F1F
	dc.w	$061F,$1F1F,$0000,$0000,$FF0F,$0F0F,$30D0,$00F0
	dc.w	$0002,$0202,$0000,$0000,$3131,$3431,$211D,$2A00
	dc.w	$100E,$1010,$1F1F,$1F1F,$0000,$0000,$0907,$0909
	dc.w	$3BC0,$00F0,$0002,$0202,$0000,$0000,$5E10,$4A33
	dc.w	$160B,$2600,$9E1E,$9D9E,$1C1B,$011C,$0501,$0105
	dc.w	$3929,$FC39,$1BC0,$00F0,$0002,$0202,$0000,$0000
	dc.w	$4216,$3434,$1823,$1D09,$5F5D,$5D4A,$0B1F,$1F1F
	dc.w	$0000,$0000,$2504,$0506,$3AE2,$00F0,$0002,$0202
	dc.w	$0000,$0000,$3161,$3161,$1D1B,$0808,$0D0E,$100F
	dc.w	$1F1F,$1F1F,$0B00,$0000,$0708,$0908,$3DC0,$00F0
	dc.w	$0002,$0202,$0000,$0000,$6331,$3131,$1A1A,$1B00
	dc.w	$101A,$131B,$0F1F,$1F1F,$0000,$0000,$3000,$0107
	dc.w	$38F1,$00F0,$0007,$0702,$0000,$0000,$0262,$0231
	dc.w	$1C03,$0000,$131C,$120E,$030B,$0B0B,$0701,$0000
	dc.w	$0507,$0608,$3DC0,$00F0,$0002,$0202,$0000,$0000
	dc.w	$3060,$0030,$2427,$1200,$1F5F,$5F5F,$0D09,$0A08
	dc.w	$1900,$0F00,$B8F8,$48F8,$33D0,$00F0,$0002,$0202
	dc.w	$0000,$0000,$3D30,$3130,$2A18,$1800,$9F1F,$1F1F
	dc.w	$0E09,$0D09,$0000,$0000,$DFD7,$DFD8,$3BC0,$00F0
	dc.w	$0002,$0202,$0000,$0000,$3040,$5110,$1000,$0000
	dc.w	$1F0C,$1A18,$0A0C,$0707,$0E08,$160F,$A70F,$FCFA
	dc.w	$35D3,$00F0,$0004,$0402,$0000,$0000,$3130,$3031
	dc.w	$1A17,$1D00,$1F1F,$0F1F,$0810,$041F,$0000,$0000
	dc.w	$5804,$5A0C,$39C0,$00F0,$0002,$0202,$0000,$0000
	dc.w	$6F05,$6701,$0000,$0000,$1F1F,$1F1C,$8000,$000F
	dc.w	$0000,$0010,$0D0D,$0D0F,$38C6,$00F0,$0004,$0402
	dc.w	$0000,$0000,$3D30,$3431,$0000,$0000,$1F1F,$1F1F
	dc.w	$1B12,$1515,$0000,$0000,$F5F4,$FFEF,$04C0,$00F0
	dc.w	$0007,$0702,$0000,$0000,$3030,$3030,$282C,$1400
	dc.w	$1D1F,$1F1F,$1219,$0F19,$000C,$120C,$F304,$3304
	dc.w	$3AC0,$00F0,$0007,$0702,$0000,$0000,$3839,$3F3F
	dc.w	$0113,$2A00,$1F1F,$1F1F,$130D,$1F1F,$0600,$000F
	dc.w	$9547,$0607,$3AD3,$00F0,$0005,$0502,$0000,$0000
	dc.w	$3333,$3133,$1000,$0000,$1F98,$9B9F,$1910,$120F
	dc.w	$1919,$1012,$E9D8,$ECFF,$35C0,$00F0,$0000,$0002
	dc.w	$0000,$0000,$6000,$0764,$0016,$0800,$171F,$1912
	dc.w	$1602,$121F,$0403,$060F,$540A,$6A08,$29C0,$00F0
	dc.w	$0002,$0202,$0000,$0000,$3730,$3638,$001F,$4A00
	dc.w	$1F1A,$1F1F,$170E,$0910,$000C,$0017,$F3F4,$84FB
	dc.w	$3AC0,$00F0,$E805,$0502,$0000,$0000,$3D30,$3431
	dc.w	$0000,$0000,$1F1F,$1F1F,$1B12,$1515,$0000,$0000
	dc.w	$FFFF,$FFEF,$04C0,$00F0,$0007,$0702,$0000,$0000
	dc.w	$3F30,$3538,$0C14,$0000,$1F14,$001F,$1A0A,$000A
	dc.w	$000C,$0008,$FF34,$04F7,$3AC0,$00F0,$E805,$0502
	dc.w	$0000,$0000,$6F05,$6701,$0000,$0000,$1F1F,$1F1C
	dc.w	$8000,$000F,$0000,$0010,$0F0F,$0F0F,$38C6,$00F0
	dc.w	$0004,$0402,$0000,$0000,$6251,$0131,$3419,$2000
	dc.w	$140E,$0E11,$090A,$001F,$0000,$0000,$F006,$0006
	dc.w	$38F1,$00F0,$0002,$0202,$0000,$0000,$6F02,$6F00
	dc.w	$2B02,$2700,$1E1C,$1C1D,$9B12,$1B17,$130E,$0E0F
	dc.w	$0937,$5609,$3AC6,$00F0,$0004,$0402,$0000,$0000
	dc.w	$6F05,$6701,$0000,$0000,$1F1F,$1F0C,$8000,$000F
	dc.w	$0000,$001F,$0000,$000B,$38C6,$00F0,$0004,$0402
	dc.w	$0000,$0000,$0262,$0131,$631D,$6300,$0D1F,$0F16
	dc.w	$0B06,$020C,$0900,$0410,$4707,$280B,$38C0,$00F0
	dc.w	$0002,$0202,$0000,$0000,$6151,$0131,$1663,$6300
	dc.w	$090E,$0B07,$040A,$0006,$0000,$0000,$6707,$0907
	dc.w	$3AF1,$00F0,$E80C,$0C02,$0000
Z80SoundResourceList
	dc.w	$0000,$0000,$0000,$0001,$0000,$0002,$0000,$0003
	dc.w	$0000,$0004,$0000,$0005,$0000,$0006,$0000,$0007
	dc.w	$0000,$0008,$0000,$0009,$0000,$000A,$0000,$000B
	dc.w	$0000,$000C,$0000,$000D,$0000,$000E,$0000,$000F
	dc.w	$0000,$0010,$0000,$0011,$0000,$0012,$0000,$0013
	dc.w	$0000,$0014,$0000,$0015,$0000,$0016,$0000,$0017
	dc.w	$0000,$0018,$0000,$0019,$0000,$001A,$0000,$001B
	dc.w	$0000,$001C,$0000,$001D,$0000,$001F,$FFFF
	dcb.b	23228,0
