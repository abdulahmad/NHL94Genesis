	dcb.b	$1390,0
	dc.b	'HOCKEY.BIN',$00,$00,$01,$FF	; HOCKEY.BIN....
	dcb.b	$14,0
	dc.b	$FF,$FF	; ..
	dcb.b	$72,0
	dc.b	$4E,$F9,$00,$00,$D8,$5A	; N....Z
; Dispatches the command number in d0 (below $80 by a compare chain, the rest to the high handler).
SubCommandDispatch	bra.w	SubCommandDispatchLow
; Queue of pending sub-CPU commands: a word count, then one long argument per entry.
SubCommandQueue	dcb.b	$82,0
; Commands $00-$7F: compare chain from the command number in d0 to its handler; $80 and up go to SubCommandDispatchHigh.
SubCommandDispatchLow	cmpi.b	#$80,d0
	bcs.b	.next
	bra.w	SubCommandDispatchHigh
.next	tst.w	d0
	bne.b	.next2
	bra.w	SubCmdReset
.next2	subi.w	#$1,d0
	bne.b	.next3
	bra.w	.next11
.next3	subi.w	#$1,d0
	bne.b	.next4
	nop
	bra.w	SubCmdSetMasterVolume
.next4	subi.w	#$1,d0
	bne.b	.next5
	bra.w	SubCmdAllocVoice
.next5	subi.w	#$1,d0
	bne.b	.next6
	nop
.next6	subi.w	#$1,d0
	bne.b	.next7
	bra.w	SubCmdSetTablePtr
.next7	subi.w	#$1,d0
	bne.b	.next8
	bra.w	SubCmdRunList
.next8	subi.w	#$1,d0
	bne.b	.next9
	bra.w	SubCmdNop
.next9	subi.w	#$1,d0
	bne.b	.next10
	bra.w	SubCmdAdjustInstrWord
.next10	move.w	#$1,d0
	ori.b	#$1,ccr
	rts
.next11	movem.l	d0-d7/a0-a6,-(sp)
	lea.l	SubTickBusy(pc),a0
	cmpi.w	#$0,(a0)
	beq.b	.next12
	bra.b	.next14
.next12	move.w	#$FFFF,(a0)
	bsr.w	.next15
	move.w	$FF800C.l,d0
	sub.w	SubLastStopwatch(pc),d0
	andi.w	#$FFF,d0
	cmpi.w	#$20,d0
	bcs.b	.next13
	bsr.w	.next18
	lea.l	SubLastStopwatch(pc),a0
	move.w	$FF800C.l,d0
	move.w	d0,(a0)
.next13	lea.l	SubTickBusy(pc),a0
	move.w	#$0,(a0)
.next14	movem.l	(sp)+,d0-d7/a0-a6
	rts
.next15	movem.l	d0-d1/a0-a1,-(sp)
.loop	lea.l	SubCommandQueue(pc),a0
	cmpi.w	#$0,(a0)
	beq.b	.next17
	move.l	$2(a0),d0
	bsr.w	SubCommandDispatchHigh
	lea.l	SubCommandQueue(pc),a0
	move.w	(a0),d0
	move.w	#$FFFF,(a0)
	adda.l	#$2,a0
	movea.l	a0,a1
	adda.l	#$4,a1
	move.w	d0,d1
	subi.w	#$1,d1
	beq.b	.next16
	subi.w	#$1,d1
.loop2	move.l	(a1)+,(a0)+
	dbra	d1,.loop2
.next16	lea.l	SubCommandQueue(pc),a0
	subi.w	#$1,d0
	move.w	d0,(a0)
	bra.b	.loop
.next17	movem.l	(sp)+,d0-d1/a0-a1
	rts
.next18	movem.l	d1-d4/a0-a2,-(sp)
	lea.l	SubVoiceIndex(pc),a0
	move.w	#$0,(a0)
; Per-voice loop of the PCM tick: refreshes the level of each of the 8 voices (voice counter in SubVoiceIndex).
SubVoiceUpdateLoop	move.b	SubPcmOnOffShadow(pc),d0
	move.w	SubVoiceIndex(pc),d2
	btst	d2,d0
	bne.w	SubVoiceUpdateNext
	lsl.w	#$2,d2
	lea.l	$FF0021.l,a0
	cmpi.b	#$0,$2(a0,d2.w)
	bne.b	.next
	lea.l	SubPcmOnOffShadow(pc),a0
	move.w	SubVoiceIndex(pc),d0
	move.b	(a0),d2
	bset	d0,d2
	move.b	d2,(a0)
	move.b	d2,$FF0011.l
	bsr.w	DelayShort
	bra.w	SubVoiceUpdateNext
.next	move.w	SubVoiceIndex(pc),d2
	lea.l	SubVoiceRelease(pc),a0
	cmpi.b	#$FF,(a0,d2.w)
	beq.w	SubVoiceUpdateNext
	clr.w	d1
	move.b	(a0,d2.w),d1
	move.w	#$4,d0
	bsr.w	TableLookupWord
	bcs.w	SubVoiceUpdateNext
	lea.l	SubVoiceTimer(pc),a1
	move.w	SubVoiceIndex(pc),d0
	lsl.w	#$1,d0
	move.w	$FF800C.l,d1
	sub.w	SubLastStopwatch(pc),d1
	andi.w	#$FFF,d1
	lsr.w	#$5,d1
	add.w	(a1,d0.w),d1
	move.w	d1,(a1,d0.w)
	lea.l	SubVoiceDecay(pc),a2
	move.w	SubVoiceIndex(pc),d1
	clr.w	d2
	move.b	(a2,d1.w),d2
	addi.w	#$1,d2
	lsl.w	#$1,d2
	addi.w	#$3,d2
	clr.w	d3
	move.b	(a0,d2.w),d3
	cmp.w	(a1,d0.w),d3
	bcc.b	.next3
	move.w	(a1,d0.w),d2
	sub.w	d3,d2
	move.w	d2,(a1,d0.w)
	addi.b	#$1,(a2,d1.w)
	move.b	(a2,d1.w),d2
	cmp.b	$2(a0),d2
	bne.b	.next2
	lea.l	SubVoiceReleasing(pc),a1
	move.w	SubVoiceIndex(pc),d3
	btst	d3,(a1)
	beq.b	.next2
	move.b	$1(a0),(a2,d1.w)
	bra.b	.next3
.next2	addi.b	#$1,d2
	cmp.b	(a0),d2
	bcs.b	.next3
	lea.l	SubPcmOnOffShadow(pc),a0
	move.w	SubVoiceIndex(pc),d0
	move.b	(a0),d1
	bset	d0,d1
	move.b	d1,$FF0011.l
	move.b	d1,(a0)
	bsr.w	DelayShort
	bra.w	SubVoiceUpdateNext
.next3	lea.l	SubVoiceDecay(pc),a1
	move.w	SubVoiceIndex(pc),d0
	clr.w	d1
	move.b	(a1,d0.w),d1
	lsl.w	#$1,d1
	addi.w	#$3,d1
	move.b	$1(a0,d1.w),d0
	cmp.b	$3(a0,d1.w),d0
	bcs.b	.next4
	clr.w	d2
	move.b	$1(a0,d1.w),d2
	sub.b	$3(a0,d1.w),d2
	bra.b	SubVoiceCalcLevel
.next4	clr.w	d2
	move.b	$3(a0,d1.w),d2
	sub.b	$1(a0,d1.w),d2
; Computes the level of voice d1 from the envelope steps and writes it to the PCM chip.
SubVoiceCalcLevel	cmpi.b	#$0,d2
	bne.b	.next
	move.b	$1(a0,d1.w),d2
	bra.b	.next3
.next	lea.l	SubVoiceTimer(pc),a1
	move.w	SubVoiceIndex(pc),d0
	lsl.w	#$1,d0
	move.w	(a1,d0.w),d3
	lsl.w	#$8,d3
	clr.w	d4
	move.b	$2(a0,d1.w),d4
	divu.w	d4,d3
	move.b	$1(a0,d1.w),d0
	cmp.b	$3(a0,d1.w),d0
	bcs.b	.next2
	mulu.w	d2,d3
	lsr.w	#$8,d3
	clr.w	d2
	move.b	$1(a0,d1.w),d2
	sub.w	d3,d2
	bra.b	.next3
.next2	mulu.w	d2,d3
	lsr.w	#$8,d3
	clr.w	d2
	move.b	$1(a0,d1.w),d2
	add.w	d3,d2
.next3	lea.l	SubVoiceVelocity(pc),a1
	move.w	SubVoiceIndex(pc),d0
	clr.w	d3
	move.b	(a1,d0.w),d3
	lsl.w	#$1,d3
	mulu.w	d3,d2
	lsr.w	#$8,d2
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	bsr.w	DelayShort
	move.b	d2,$FF0001.l
	bsr.w	DelayShort
; Advances to the next of the 8 voices and loops back to SubVoiceUpdateLoop.
SubVoiceUpdateNext	lea.l	SubVoiceIndex(pc),a0
	addi.w	#$1,(a0)
	cmpi.w	#$8,(a0)
	beq.b	.next
	bra.w	SubVoiceUpdateLoop
.next	movem.l	(sp)+,d1-d4/a0-a2
	rts
; Second level for commands $80 and up, by range.
SubCommandDispatchHigh	cmpi.b	#$8F,d0
	bgt.b	.next
	bra.w	.next16
.next	cmpi.b	#$9F,d0
	bgt.b	.next2
	bra.w	.next8
.next2	cmpi.b	#$AF,d0
	bgt.b	.next3
	bra.b	.next7
.next3	cmpi.b	#$BF,d0
	bgt.b	.next4
	nop
.next4	cmpi.b	#$CF,d0
	bgt.b	.next5
	bra.w	.next21
.next5	cmpi.b	#$DF,d0
	bgt.b	.next6
	bra.b	.next7
.next6	cmpi.b	#$EF,d0
	bgt.b	.next7
	bra.w	.next22
.next7	move.w	#$1,d0
	ori.b	#$1,ccr
	rts
.next8	movem.l	d1-d2/a0-a1,-(sp)
	lea.l	SubMasterVolumes(pc),a0
	move.b	d0,d1
	andi.w	#$F,d1
	move.l	d0,d2
	swap	d2
	lsr.w	#$8,d2
	or.b	d2,d1
	move.w	d1,$260(a0)
	move.w	d0,d1
	lsr.w	#$8,d1
	move.w	d1,$262(a0)
	move.l	d0,d1
	swap	d1
	andi.w	#$FF,d1
	move.w	d1,$264(a0)
	move.w	SubCmdChannel(pc),d2
	lea.l	SubChanProgram(pc),a0
	clr.w	d1
	move.b	(a0,d2.w),d1
.loop	lea.l	SubCmdInstrKey(pc),a0
	move.w	d1,(a0)
	move.w	#$0,d0
	bsr.w	TableLookupWord
	bcs.w	.next15
	lea.l	SubCurInstrRecord(pc),a1
	move.l	a0,(a1)
	cmpi.b	#$7,(a0)
	bne.b	.next9
	move.w	SubCmdNote(pc),d0
	addi.w	#$1,d0
	clr.w	d1
	move.b	(a0,d0.w),d1
	bra.b	.loop
.next9	bsr.w	FindKeyIndex
	bcc.b	.next10
	bra.w	.next15
.next10	move.w	SubVoiceIndex(pc),d0
	lea.l	SubVoiceChan(pc),a0
	move.b	SubCmdChannel+$1(pc),(a0,d0.w)
	lea.l	SubVoiceInstr(pc),a0
	move.b	SubCmdInstrKey+$1(pc),(a0,d0.w)
	lea.l	SubVoiceNote(pc),a0
	move.b	SubCmdNote+$1(pc),(a0,d0.w)
	lea.l	SubVoiceVelocity(pc),a0
	move.b	SubCmdNote+$3(pc),(a0,d0.w)
	lea.l	SubVoiceAge(pc),a0
	movea.l	SubCurInstrRecord(pc),a1
	move.b	$1(a1),(a0,d0.w)
	move.w	SubFoundVoiceParam(pc),d0
	btst	#$0,d0
	beq.b	.next11
	btst	#$1,d0
	beq.b	.next14
.next11	move.b	SubPcmOnOffShadow(pc),d0
	move.w	SubVoiceIndex(pc),d1
	bset	d1,d0
	move.b	d0,$FF0011.l
	bsr.w	DelayShort
	ori.b	#$C0,d1
	move.b	d1,$FF000F.l
	bsr.w	DelayShort
	movea.l	SubCurInstrRecord(pc),a0
	clr.w	d0
	move.b	$2(a0),d0
	lsl.w	#$1,d0
	lea.l	SubInstrTable(pc),a1
	move.w	(a1,d0.w),d1
	lsr.w	#$8,d1
	move.b	d1,$FF000D.l
	bsr.w	DelayShort
	move.b	$5(a0),d1
	lsl.w	#$8,d1
	move.b	$6(a0),d1
	cmpi.w	#$FFFF,d1
	bne.b	.next12
	clr.w	d1
	bra.b	.next13
.next12	add.w	(a1,d0.w),d1
.next13	move.b	d1,$FF0009.l
	bsr.w	DelayShort
	lsr.w	#$8,d1
	move.b	d1,$FF000B.l
	bsr.w	DelayShort
	bsr.w	.next24
	bsr.w	ScaleValueByTables
.next14	bsr.w	CalcLevelDelta
	lea.l	SubPcmOnOffShadow(pc),a0
	move.w	SubVoiceIndex(pc),d0
	move.b	(a0),d1
	bclr	d0,d1
	move.b	d1,$FF0011.l
	bsr.w	DelayShort
	move.b	d1,(a0)
.next15	movem.l	(sp)+,d1-d2/a0-a1
	rts
.next16	movem.l	d1-d3/a0-a2,-(sp)
	clr.w	d1
	move.b	d0,d1
	andi.b	#$F,d1
	move.l	d0,d2
	swap	d2
	lsr.w	#$8,d2
	or.b	d2,d1
	lea.l	SubCmdChannel(pc),a0
	move.w	d1,(a0)
	move.w	d0,d1
	lsr.w	#$8,d1
	lea.l	SubCmdNote(pc),a0
	move.w	d1,(a0)
	lea.l	SubChanProgram(pc),a0
	move.w	SubCmdChannel(pc),d0
	clr.w	d1
	move.b	(a0,d0.w),d1
.loop2	move.w	#$0,d0
	bsr.w	TableLookupWord
	bcs.w	.next20
	cmpi.b	#$7,(a0)
	bne.b	.next17
	move.w	SubCmdNote(pc),d0
	addi.w	#$1,d0
	clr.w	d1
	move.b	(a0,d0.w),d1
	bra.b	.loop2
.next17	move.b	$5(a0),d0
	lsl.w	#$8,d0
	move.b	$6(a0),d0
	cmpi.w	#$FFFF,d0
	beq.w	.next20
	move.b	SubPcmOnOffShadow(pc),d0
	clr.w	d1
	lea.l	SubVoiceChan(pc),a1
	lea.l	SubVoiceNote(pc),a2
	move.w	SubCmdChannel(pc),d2
	move.w	SubCmdNote(pc),d3
.loop3	btst	d1,d0
	bne.b	.next19
	cmp.b	(a1),d2
	bne.b	.next19
	cmp.b	(a2),d3
	bne.b	.next19
	cmpi.b	#$FF,$D(a0)
	beq.b	.next18
	lea.l	SubVoiceReleasing(pc),a1
	bclr.b	d1,(a1)
	lea.l	SubVoiceIndex(pc),a1
	move.w	d1,(a1)
	clr.w	d1
	move.b	$D(a0),d1
	move.w	#$4,d0
	bsr.w	TableLookupWord
	bcs.b	.next20
	lea.l	SubVoiceDecay(pc),a1
	move.w	SubVoiceIndex(pc),d0
	move.b	$2(a0),(a1,d0.w)
	lsl.w	#$1,d0
	lea.l	SubVoiceTimer(pc),a1
	move.w	#$0,(a1,d0.w)
	bra.b	.next20
.next18	lea.l	SubPcmOnOffShadow(pc),a0
	bset	d1,d0
	move.b	d0,(a0)
	move.b	d0,$FF0011.l
	bsr.w	DelayShort
	clr.w	d0
	bra.b	.next20
.next19	adda.l	#$1,a1
	adda.l	#$1,a2
	addi.w	#$1,d1
	cmpi.w	#$8,d1
	bne.b	.loop3
	move.w	#$FFFF,d0
	ori.b	#$1,ccr
.next20	movem.l	(sp)+,d1-d3/a0-a2
	rts
.next21	movem.l	d1-d2/a0,-(sp)
	move.l	d0,d1
	swap	d1
	lsr.w	#$8,d1
	move.w	d0,d2
	andi.w	#$F,d2
	or.b	d1,d2
	lsr.w	#$8,d0
	lea.l	SubChanProgram(pc),a0
	move.b	d0,(a0,d2.w)
	clr.w	d0
	movem.l	(sp)+,d1-d2/a0
	rts
.next22	movem.l	d1-d2/a0,-(sp)
	move.l	d0,d1
	swap	d1
	lsr.w	#$8,d1
	move.w	d0,d2
	andi.w	#$F,d2
	or.b	d1,d2
	lsr.w	#$8,d0
	lea.l	SubChanPitchBend(pc),a0
	move.b	d0,(a0,d2.w)
	lea.l	SubVoiceIndex(pc),a0
	move.w	#$0,(a0)
.loop4	move.w	SubVoiceIndex(pc),d0
	move.b	SubPcmOnOffShadow(pc),d1
	btst	d0,d1
	beq.b	.next23
	lea.l	SubVoiceChan(pc),a0
	cmp.b	(a0,d0.w),d2
	bne.b	.next23
	bsr.w	CalcLevelDelta
.next23	lea.l	SubVoiceIndex(pc),a0
	addi.w	#$1,(a0)
	cmpi.w	#$8,(a0)
	bne.b	.loop4
	clr.w	d0
	movem.l	(sp)+,d1-d2/a0
	rts
.next24	movem.l	d1-d2/a0,-(sp)
	movea.l	SubCurInstrRecord(pc),a0
	clr.w	d1
	move.b	$D(a0),d1
	lea.l	SubVoiceRelease(pc),a0
	move.w	SubVoiceIndex(pc),d0
	move.b	d1,(a0,d0.w)
	cmpi.b	#$FF,d1
	beq.b	.next25
	move.w	#$4,d0
	bsr.w	TableLookupWord
	bcc.b	.next26
.next25	move.w	SubVoiceIndex(pc),d0
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	bsr.w	DelayShort
	lea.l	SubVoiceVelocity(pc),a0
	move.w	SubVoiceIndex(pc),d0
	move.b	(a0,d0.w),d1
	lsl.w	#$1,d1
	move.b	d1,$FF0001.l
	bsr.w	DelayShort
	clr.w	d0
	bra.b	.next27
.next26	clr.w	d0
	move.b	$4(a0),d0
	lea.l	SubVoiceVelocity(pc),a0
	move.w	SubVoiceIndex(pc),d1
	clr.w	d2
	move.b	(a0,d1.w),d2
	lsl.w	#$1,d2
	mulu.w	d2,d0
	lsr.w	#$8,d0
	move.w	SubVoiceIndex(pc),d1
	ori.b	#$C0,d1
	move.b	d1,$FF000F.l
	bsr.w	DelayShort
	move.b	d0,$FF0001.l
	bsr.w	DelayShort
	lea.l	SubVoiceDecay(pc),a0
	move.w	SubVoiceIndex(pc),d0
	move.b	#$0,(a0,d0.w)
	lea.l	SubVoiceReleasing(pc),a0
	bset.b	d0,(a0)
	lsl.w	#$1,d0
	lea.l	SubVoiceTimer(pc),a0
	move.w	#$0,(a0,d0.w)
	clr.w	d0
.next27	movem.l	(sp)+,d1-d2/a0
	rts
; Command 0: reset the sound driver (master volume $100, voice slots empty, channel tables to defaults).
SubCmdReset	movem.l	d0/a0-a1,-(sp)
	lea.l	SubMasterVolumes(pc),a0
	move.w	#$100,$0(a0)
	move.w	#$100,$2(a0)
	lea.l	SubTablePtrs(pc),a1
	move.w	#$1,d0
.loop	move.l	#$FFFFFFFF,(a1)+
	dbra	d0,.loop
	move.b	#$FF,$210(a0)
	lea.l	SubChanProgram(pc),a0
	move.w	#$7F,d0
.loop2	move.b	#$0,(a0)+
	dbra	d0,.loop2
	lea.l	SubChanModulation(pc),a0
	move.w	#$7F,d0
.loop3	move.b	#$0,(a0)+
	dbra	d0,.loop3
	lea.l	SubChanVolume(pc),a0
	move.w	#$7F,d0
.loop4	move.b	#$7F,(a0)+
	dbra	d0,.loop4
	lea.l	SubChanPan(pc),a0
	move.w	#$7F,d0
.loop5	move.b	#$40,(a0)+
	dbra	d0,.loop5
	lea.l	SubChanPitchBend(pc),a0
	move.w	#$7F,d0
.loop6	move.b	#$40,(a0)+
	dbra	d0,.loop6
	lea.l	SubVoiceTrim(pc),a0
	move.w	#$7,d0
.loop7	move.b	#$FF,(a0)+
	dbra	d0,.loop7
	lea.l	SubTickFlag(pc),a0
	move.b	#$FF,(a0)
	lea.l	SubCommandQueue(pc),a0
	move.w	#$0,(a0)
	move.b	#$80,$FF000F.l
	bsr.w	DelayShort
	lea.l	$FF2001.l,a0
	move.w	#$EB,d0
.loop8	move.b	#$80,(a0)
	adda.l	#$2,a0
	nop
	nop
	nop
	nop
	dbra	d0,.loop8
	move.w	#$F,d0
.loop9	move.b	#$FF,(a0)
	adda.l	#$2,a0
	nop
	nop
	nop
	nop
	dbra	d0,.loop9
	lea.l	SubTickBusy(pc),a0
	move.w	#$0,(a0)
	movem.l	(sp)+,d0/a0-a1
	rts
; Command 3: pick a free PCM voice (else the one with the smallest age); voice in d0, carry set if none.
SubCmdAllocVoice	movem.l	d1-d7/a0,-(sp)
	move.b	SubPcmOnOffShadow(pc),d0
	move.w	#$7,d5
.loop	btst	d5,d0
	bne.b	.next2
	dbra	d5,.loop
	lea.l	SubVoiceAge(pc),a0
	move.w	#$FFFF,d5
	move.b	#$FF,d6
	clr.w	d0
.loop2	cmp.b	(a0),d6
	bcs.b	.next
	move.w	d0,d5
	move.b	(a0),d6
.next	adda.l	#$1,a0
	addi.w	#$1,d0
	cmpi.w	#$8,d0
	bne.b	.loop2
	cmpi.w	#$FFFF,d5
	bne.b	.next2
	move.w	#$7,d0
	ori.b	#$1,ccr
	bra.w	.next4
.next2	lea.l	SubVoiceIndex(pc),a0
	move.w	d5,(a0)
	lea.l	SubPcmOnOffShadow(pc),a0
	move.b	(a0),d0
	bset	d5,d0
	move.b	d0,$FF0011.l
	bsr.w	DelayShort
	lea.l	SubInstrTable(pc),a0
	lsl.w	#$1,d1
	cmpi.w	#$FFFF,(a0,d1.w)
	bne.b	.next3
	move.b	#$3,d0
	ori.b	#$1,ccr
	bra.w	.next4
.next3	move.w	SubVoiceIndex(pc),d0
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	move.w	(a0,d1.w),d0
	lsr.w	#$8,d0
	move.b	d0,$FF000D.l
	bsr.w	DelayShort
	move.b	#$0,$FF0009.l
	bsr.w	DelayShort
	move.b	#$0,$FF000B.l
	bsr.w	DelayShort
	move.b	d2,$FF0005.l
	bsr.w	DelayShort
	lsr.w	#$8,d2
	move.b	d2,$FF0007.l
	bsr.w	DelayShort
	move.b	d3,$FF0001.l
	bsr.w	DelayShort
	move.b	d4,$FF0003.l
	bsr.w	DelayShort
	lea.l	SubPcmOnOffShadow(pc),a0
	move.w	SubVoiceIndex(pc),d0
	move.b	(a0),d1
	bclr	d0,d1
	move.b	d1,(a0)
	move.b	d1,$FF0011.l
	bsr.w	DelayShort
	lea.l	SubVoiceChan(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea.l	SubVoiceInstr(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea.l	SubVoiceNote(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea.l	SubVoiceVelocity(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea.l	SubVoiceAge(pc),a0
	move.b	#$0,(a0,d0.w)
	lea.l	SubVoiceRelease(pc),a0
	move.b	#$FF,(a0,d0.w)
.next4	movem.l	(sp)+,d1-d7/a0
	rts
; Sums signed differences between table values and the record at a0.
CalcLevelDelta	movem.l	d1-d6/a0-a1,-(sp)
	movea.l	SubCurInstrRecord(pc),a0
	clr.w	d0
	clr.w	d1
	move.w	SubVoiceIndex(pc),d2
	lea.l	SubVoiceNote(pc),a1
	move.b	(a1,d2.w),d3
	cmp.b	$3(a0),d3
	blt.b	.next
	sub.b	$3(a0),d3
	add.b	d3,d0
	bra.b	.next2
.next	move.b	$3(a0),d3
	sub.b	(a1,d2.w),d3
	sub.b	d3,d0
.next2	move.w	SubCmdChannel(pc),d2
	lea.l	SubChanPitchBend(pc),a1
	clr.w	d3
	move.b	(a1,d2.w),d3
	cmpi.b	#$40,d3
	beq.b	.next6
	blt.b	.next4
	subi.b	#$40,d3
	lsl.w	#$2,d3
	clr.w	d4
	move.b	$7(a0),d4
	mulu.w	d4,d3
	add.b	d3,d1
	bcc.b	.next3
	addi.b	#$1,d0
.next3	lsr.w	#$8,d3
	add.b	d3,d0
	bra.b	.next6
.next4	move.b	#$40,d3
	sub.b	(a1,d2.w),d3
	lsl.w	#$2,d3
	clr.w	d4
	move.b	$8(a0),d4
	mulu.w	d4,d3
	sub.b	d3,d1
	bcc.b	.next5
	subi.b	#$1,d0
.next5	lsr.w	#$8,d3
	sub.b	d3,d0
.next6	clr.w	d2
	move.b	$4(a0),d2
	cmpi.b	#$0,d2
	beq.b	.next8
	btst	#$7,d2
	bne.b	.next7
	lsl.b	#$1,d2
	add.b	d2,d1
	bcc.b	.next8
	addi.b	#$1,d0
	bra.b	.next8
.next7	eori.b	#$FF,d2
	addi.b	#$1,d2
	lsl.b	#$1,d2
	sub.b	d2,d1
	bcc.b	.next8
	subi.b	#$1,d0
.next8	ext.w	d0
	lsl.w	#$1,d0
	lea.l	.next9(pc),a1
	move.w	(a1,d0.w),d2
	move.w	$2(a1,d0.w),d3
	sub.w	d2,d3
	mulu.w	d1,d3
	lsr.w	#$8,d3
	add.w	d3,d2
	move.w	SubVoiceIndex(pc),d0
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	bsr.w	DelayShort
	move.b	d2,$FF0005.l
	bsr.w	DelayShort
	lsr.w	#$8,d2
	move.b	d2,$FF0007.l
	bsr.w	DelayShort
	clr.w	d0
	movem.l	(sp)+,d1-d6/a0-a1
	rts
	dc.b	$00,$80,$00,$88,$00,$90,$00,$98,$00,$A2,$00,$AB,$00,$B5,$00,$C0	; ................
	dc.b	$00,$CB,$00,$D7,$00,$E4,$00,$F2,$01,$00,$01,$0F,$01,$1F,$01,$30	; ...............0
	dc.b	$01,$43,$01,$56,$01,$6A,$01,$80,$01,$96,$01,$AF,$01,$C8,$01,$E3	; .C.V.j..........
	dc.b	$02,$00,$02,$1E,$02,$3F,$02,$61,$02,$85,$02,$AB,$02,$D4,$02,$FF	; .....?.a........
	dc.b	$03,$2D,$03,$5D,$03,$90,$03,$C7,$04,$00,$04,$3D,$04,$7D,$04,$C2	; .-.].......=.}..
	dc.b	$05,$0A,$05,$57,$05,$A8,$05,$FE,$06,$59,$06,$BA,$07,$21,$07,$8D	; ...W.....Y...!..
.next9	dc.b	$08,$00,$08,$7A,$08,$FB,$09,$83,$0A,$14,$0A,$AE,$0B,$50,$0B,$FD	; ...z.........P..
	dc.b	$0C,$B3,$0D,$74,$0E,$41,$0F,$1A,$10,$00,$10,$F4,$11,$F6,$13,$07	; ...t.A..........
	dc.b	$14,$29,$15,$56,$16,$A1,$17,$F9,$19,$66,$1A,$E9,$1C,$82,$1E,$34	; .).V.....f.....4
	dc.b	$20,$00,$21,$E7,$23,$EB,$26,$0E,$28,$51,$2A,$B7,$2D,$41,$2F,$F2	;  .!.#.&.(Q*.-A/.
	dc.b	$32,$CC,$35,$D1,$39,$04,$3C,$68,$40,$00,$43,$CE,$47,$D6,$4C,$1C	; 2.5.9.<h@.C.G.L.
	dc.b	$50,$A3,$55,$6E,$5A,$82,$5F,$E4,$65,$98,$6B,$A3,$72,$09,$78,$D1	; P.UnZ._.e.k.r.x.
	dc.b	$80,$00	; ..
; Scales a value through three byte tables and a lookup.
ScaleValueByTables	movem.l	d1-d3/a0,-(sp)
	move.w	SubVoiceIndex(pc),d0
	lea.l	SubVoiceChan(pc),a0
	clr.w	d3
	move.b	(a0,d0.w),d3
	lea.l	SubChanVolume(pc),a0
	clr.w	d2
	move.b	(a0,d3.w),d2
	lsl.w	#$1,d2
	lea.l	SubChanProgram(pc),a0
	clr.w	d1
	move.b	(a0,d3.w),d1
	move.w	#$0,d0
	bsr.w	TableLookupWord
	bcs.w	.next4
	clr.w	d1
	move.b	$B(a0),d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	move.w	d3,d0
	lsr.w	#$4,d0
	lea.l	SubVoiceTrim(pc),a0
	clr.w	d1
	move.b	(a0,d0.w),d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	clr.w	d1
	move.b	SubTickFlag(pc),d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	lea.l	SubChanPan(pc),a0
	clr.w	d1
	move.b	(a0,d3.w),d1
	cmpi.b	#$40,d1
	bne.b	.next
	lsr.b	#$4,d2
	move.b	d2,d0
	lsl.b	#$4,d0
	or.b	d2,d0
	bra.b	.next3
.next	bgt.b	.next2
	move.b	d2,d0
	lsr.b	#$4,d0
	lsl.w	#$2,d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	andi.b	#$F0,d2
	or.b	d2,d0
	bra.b	.next3
.next2	move.b	d2,d0
	andi.b	#$F0,d0
	subi.w	#$40,d1
	lsl.w	#$2,d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	lsr.b	#$4,d2
	or.b	d2,d0
.next3	move.w	SubVoiceIndex(pc),d1
	ori.b	#$C0,d1
	move.b	d1,$FF000F.l
	bsr.w	DelayShort
	move.b	d0,$FF0003.l
	bsr.w	DelayShort
	clr.w	d0
.next4	movem.l	(sp)+,d1-d3/a0
	rts
; Finds the index of the key byte d0 in the 8-entry table and stores it.
FindKeyIndex	movem.l	d1-d2/a0,-(sp)
	lea.l	SubFoundVoiceParam(pc),a0
	move.w	#$0,(a0)
	movea.l	SubCurInstrRecord(pc),a0
	btst.b	#$0,$C(a0)
	beq.b	.next2
	lea.l	SubVoiceInstr(pc),a0
	move.w	SubCmdInstrKey(pc),d0
	move.b	SubPcmOnOffShadow(pc),d1
	clr.w	d2
.loop	btst	d2,d1
	bne.b	.next
	cmp.b	(a0)+,d0
	bne.b	.next
	lea.l	SubVoiceIndex(pc),a0
	move.w	d2,(a0)
	lea.l	SubCurInstrRecord(pc),a0
	clr.w	d0
	move.b	$C(a0),d0
	lea.l	SubFoundVoiceParam(pc),a0
	move.w	d0,(a0)
	clr.w	d0
	bra.b	.next5
.next	addi.w	#$1,d2
	cmpi.w	#$8,d2
	bne.b	.loop
.next2	move.b	SubPcmOnOffShadow(pc),d0
	clr.w	d1
.loop2	btst	d1,d0
	beq.b	.next3
	lea.l	SubVoiceIndex(pc),a0
	move.w	d1,(a0)
	clr.w	d0
	bra.b	.next5
.next3	addi.w	#$1,d1
	cmpi.w	#$8,d1
	bne.b	.loop2
	movea.l	SubCurInstrRecord(pc),a0
	move.b	$1(a0),d0
	lea.l	SubVoiceAge(pc),a0
	clr.w	d1
.loop3	cmp.b	(a0)+,d0
	bhi.b	.next4
	lea.l	SubVoiceIndex(pc),a0
	move.w	d1,(a0)
	clr.w	d0
	bra.b	.next5
.next4	addi.w	#$1,d1
	cmpi.w	#$8,d1
	bne.b	.loop3
	ori.b	#$1,ccr
.next5	movem.l	(sp)+,d1-d2/a0
	rts
; Looks up the pair (d0,d1) in the table list and returns the word, carry set if absent.
TableLookupWord	movem.l	d1-d4/a1-a2,-(sp)
	lea.l	SubTablePtrs(pc),a1
	move.w	#$2,d2
.loop	cmpi.l	#$FFFFFFFF,(a1)
	beq.b	.next2
	movea.l	(a1),a2
	move.b	(a2)+,d3
	lsl.w	#$8,d3
	move.b	(a2)+,d3
	clr.l	d4
	move.w	d3,d4
	lsl.l	#$2,d4
	add.l	a2,d4
	movea.l	d4,a0
.loop2	cmp.b	(a2),d0
	bne.b	.next
	cmp.b	$1(a2),d1
	bne.b	.next
	move.b	$2(a2),d0
	lsl.w	#$8,d0
	move.b	$3(a2),d0
	andi.b	#$FE,ccr
	bra.b	.next3
.next	clr.l	d4
	move.b	$2(a2),d4
	lsl.w	#$8,d4
	move.b	$3(a2),d4
	adda.l	d4,a0
	adda.l	#$4,a2
	subi.w	#$1,d3
	bne.b	.loop2
.next2	adda.l	#$4,a1
	subi.w	#$1,d2
	bne.b	.loop
	move.w	#$3,d0
	ori.b	#$1,ccr
.next3	movem.l	(sp)+,d1-d4/a1-a2
	rts
; Command 2: d1 selects how the left/right master volume words are set.
SubCmdSetMasterVolume	move.l	a0,-(sp)
	or.w	d1,d1
	bne.b	.next
	lea.l	SubMasterVolumes(pc),a0
	move.w	#$100,$2(a0)
	clr.w	d0
	bra.b	.next5
.next	cmpi.w	#$1,d1
	bne.b	.next2
	lea.l	SubMasterVolumes(pc),a0
	move.w	$0(a0),$2(a0)
	clr.w	d0
	bra.b	.next5
.next2	cmpi.w	#$2,d1
	bne.b	.next4
	lea.l	SubMasterVolumes(pc),a0
	move.w	$2(a0),$0(a0)
	move.w	$2(a0),d0
	lea.l	SubInstrTable(pc),a0
	move.w	#$FF,d1
.loop	cmpi.w	#$FFFF,(a0)
	beq.b	.next3
	cmp.w	(a0),d0
	bhi.w	.next3
	move.w	#$FFFF,(a0)
.next3	adda.l	#$2,a0
	dbra	d1,.loop
	clr.w	d0
	bra.b	.next5
.next4	move.w	#$5,d0
	ori.b	#$1,ccr
.next5	clr.w	d0
	movea.l	(sp)+,a0
	rts
; Command 4: store the pointer in a0 in slot d1 of SubTablePtrs.
SubCmdSetTablePtr	movem.l	d1/a1,-(sp)
	lsl.w	#$2,d1
	lea.l	SubTablePtrs(pc),a1
	move.l	a0,(a1,d1.w)
	movem.l	(sp)+,d1/a1
	rts
; Command 5: walk a list of (key, value) word pairs ending in $FFFF and apply each through TableLookupWord.
SubCmdRunList	movem.l	d1/a0-a1,-(sp)
	movea.l	a0,a1
.loop	cmpi.w	#$FFFF,(a1)
	bne.b	.next
	clr.w	d0
	bra.b	.next5
.next	move.w	(a1),d0
	move.w	$2(a1),d1
	bsr.w	TableLookupWord
	bcs.b	.next4
	cmpi.w	#$2,(a1)
	bne.b	.next3
	bsr.w	.next6
	bcs.b	.next5
	lea.l	SubInstrTable(pc),a0
	move.w	$2(a1),d0
	lsl.w	#$1,d0
	move.w	SubMasterVolumes(pc),d1
	move.w	d1,(a0,d0.w)
	add.w	SubListCount(pc),d1
	or.b	d1,d1
	beq.b	.next2
	andi.w	#$FF00,d1
	addi.w	#$100,d1
.next2	lea.l	SubMasterVolumes(pc),a0
	move.w	d1,(a0)
.next3	adda.l	#$4,a1
	bra.b	.loop
.next4	ori.b	#$1,ccr
.next5	movem.l	(sp)+,d1/a0-a1
	rts
.next6	movem.l	d1-d2/a0-a1,-(sp)
	lea.l	SubListCount(pc),a1
	move.w	d0,(a1)
	move.w	SubMasterVolumes(pc),d1
	beq.b	SubCmdLoadWaveCopy
	clr.w	d1
	sub.w	SubMasterVolumes(pc),d1
; Command 6: load a sample into PCM wave RAM; carry set with d0 = 4 if it does not fit.
SubCmdLoadWave	cmp.w	d0,d1
	bhi.b	SubCmdLoadWaveCopy
	move.w	#$4,d0
	ori.b	#$1,ccr
	dc.w	$6056
; Copies the sample at a0 into PCM wave RAM, switching banks through the control register.
SubCmdLoadWaveCopy	dc.w	$343A,$00C2
	lsr.w	#$8,d2
	lsr.w	#$4,d2
	ori.b	#$80,d2
	move.b	d2,$FF000F.l
	bsr.w	DelayShort
	move.w	SubMasterVolumes(pc),d1
	andi.l	#$FFF,d1
	lsl.l	#$1,d1
	addi.l	#$FF2001,d1
	movea.l	d1,a1
.loop	move.b	(a0)+,d1
	move.b	d1,(a1)
	adda.l	#$2,a1
	cmpa.l	#$FF4001,a1
	bne.b	.next
	addi.b	#$1,d2
	move.b	d2,$FF000F.l
	bsr.w	DelayShort
	movea.l	#$FF2001,a1
.next	dbra	d0,.loop
	clr.w	d0
.next2	movem.l	(sp)+,d1-d2/a0-a1
	rts
; Command 9: set or add d2 to the 16-bit pointer at offsets 5/6 of the instrument record found by key d1.
SubCmdAdjustInstrWord	movem.l	d1-d3/a0,-(sp)
	movem.l	d2-d3,-(sp)
	move.w	#$0,d0
	bsr.w	TableLookupWord
	movem.l	(sp)+,d2-d3
	bcs.b	.next2
	cmpi.w	#$0,d3
	bne.b	.next
	move.b	d2,$6(a0)
	lsr.w	#$8,d2
	move.b	d2,$5(a0)
	clr.w	d0
	bra.b	.next2
.next	move.b	$5(a0),d0
	lsl.w	#$8,d0
	move.b	$6(a0),d0
	add.w	d2,d0
	move.b	d0,$6(a0)
	lsr.w	#$8,d0
	move.b	d0,$5(a0)
	clr.w	d0
.next2	movem.l	(sp)+,d1-d3/a0
	rts
.loop	move.w	#$80,d0
	jsr	$5F22.l
	bcs.b	.loop
	rts
; Command 7: does nothing.
SubCmdNop	rts
; Busy-wait of about 40 loop passes (hardware settling delay).
DelayShort	move.l	d0,-(sp)
	move.w	#$28,d0
.loop	nop
	dbra	d0,.loop
	move.l	(sp)+,d0
	rts
; Master volume words (left, right), $100 after a reset.
SubMasterVolumes	dc.b	$00,$00,$00,$00	; ....
; $100 word entries keyed by instrument number; $FFFF marks an unused entry.
SubInstrTable	dcb.b	$200,0
; Entry count of the list SubCmdRunList is walking.
SubListCount	dc.b	$00,$00	; ..
; Two table pointers set by SubCmdSetTablePtr ($FFFFFFFF = not set).
SubTablePtrs	dcb.b	$8,0
; Re-entry guard of the PCM tick.
SubTickBusy	dc.b	$00,$00	; ..
; Shadow of the PCM chip on/off register ($FF0011); a set bit keeps the voice silent.
SubPcmOnOffShadow	dc.b	$00,$00	; ..
; MIDI channel of each of the 8 voices.
SubVoiceChan	dcb.b	$8,0
; Instrument index of each voice.
SubVoiceInstr	dcb.b	$8,0
; Note number of each voice.
SubVoiceNote	dcb.b	$8,0
; Velocity (level) of each voice.
SubVoiceVelocity	dcb.b	$8,0
; Allocation order of each voice; the smallest value is stolen first.
SubVoiceAge	dcb.b	$8,0
; Release instrument key of each voice ($FF = none).
SubVoiceRelease	dcb.b	$8,0
; Decay step of each voice.
SubVoiceDecay	dcb.b	$8,0
; One word timer per voice.
SubVoiceTimer	dcb.b	$11,0
; Bit mask of the voices in their release phase.
SubVoiceReleasing	dc.b	$00	; .
; Stopwatch value ($FF800C) at the last tick.
SubLastStopwatch	dc.b	$00,$00	; ..
; Voice counter shared by the voice loops.
SubVoiceIndex	dc.b	$00,$00	; ..
; MIDI channel of the command being handled.
SubCmdChannel	dc.b	$00	; .
.next	dc.b	$00	; .
; Note number of the command being handled.
SubCmdNote	dc.b	$00	; .
.next	dc.b	$00,$00	; ..
.next2	dc.b	$00	; .
; Instrument key being looked up for the current command.
SubCmdInstrKey	dc.b	$00	; .
.next	dc.b	$00	; .
; Parameter stored by FindKeyIndex next to the voice it found.
SubFoundVoiceParam	dc.b	$00,$00	; ..
; Pointer to the instrument record found for the current command.
SubCurInstrRecord	dc.b	$00,$00,$00,$00	; ....
; Program number of each of the 16 MIDI channels.
SubChanProgram	dcb.b	$80,0
; Modulation setting of each MIDI channel, 0 after a reset.
SubChanModulation	dcb.b	$80,0
; Volume of each MIDI channel ($7F after a reset).
SubChanVolume	dcb.b	$80,0
; Pan of each MIDI channel ($40 = centre after a reset).
SubChanPan	dcb.b	$80,0
; Pitch bend of each MIDI channel ($40 = centre after a reset).
SubChanPitchBend	dcb.b	$80,0
; Per-voice level trim, $FF after a reset.
SubVoiceTrim	dcb.b	$8,0
; Flag set to $FF by the reset.
SubTickFlag	dc.b	$00,$00	; ..