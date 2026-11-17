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
RestoreBiosSub2	sub.b	$1(a0,d1.w),d2
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
RestoreBiosSub3	btst.b	#$0,$C(a0)
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
	bra.b	RestoreBios_13
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
	bra.b	RestoreBios_13
.next3	addi.w	#$1,d1
	cmpi.w	#$8,d1
	bne.b	.loop2
	movea.l	SubCurInstrRecord(pc),a0
	move.b	$1(a0),d0
	lea.l	SubVoiceAge(pc),a0
RestoreBiosSub4	clr.w	d1
RestoreBios_12	cmp.b	(a0)+,d0
RestoreBiosSub5	bhi.b	.next
	lea.l	SubVoiceIndex(pc),a0
	move.w	d1,(a0)
	clr.w	d0
	bra.b	RestoreBios_13
.next	addi.w	#$1,d1
	cmpi.w	#$8,d1
	bne.b	RestoreBios_12
	ori.b	#$1,ccr
RestoreBios_13	movem.l	(sp)+,d1-d2/a0
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
RestoreBiosSub8	move.w	sr,-(sp)
	move.w	d0,$EC90.l
	move.l	d1,$EC92.l
	move.l	d2,$EC96.l
	move.l	d3,$EC9A.l
	move.l	d4,$EC9E.l
	jsr	$E3BC.l
	jsr	$E3F8.l
	jsr	$E3EE.l
	jsr	$E416.l
	move.w	#$0,$BC6E8.l
	move.w	#$2000,sr
	bclr.b	#$2,$FFFF8024.w
	jsr	$E454.l
	bset.b	#$2,$FFFF8024.w
	jsr	$E440.l
	move.w	#$0,d0
	jsr	$C4BC.l
	move.l	#$400,-(sp)
	jsr	$10540.l
	jsr	$D8F8.l
	bclr.b	#$2,$FFFF8024.w
	moveq	#$1E,d0
	jsr	$E370.l
	move.w	#$2700,sr
	movea.l	$EC96.l,a0
	move.l	$10ACC.l,(a0)
	bsr.w	ClearCommRegs
	move.w	(sp)+,sr
	rts
	move.w	#$0,$BC6E8.l
	bsr.w	.next
	bsr.w	LoadBootImages
	bsr.w	NopReturn
	bsr.w	CdStopMusic
	move.l	#$400,-(sp)
	bsr.w	CdSetFader
	bsr.w	SendCmd5
	bsr.w	ScreenSetupA
	bsr.w	ScreenSetupB
	bsr.w	SendCmdE320Inline
	move.w	$EC90.l,-(sp)
	bsr.w	CdPlayTrackRepeat
	move.l	#$4000200,-(sp)
	bsr.w	CdSetFader
	bsr.w	.next
	bsr.w	ScreenSetupC
	bsr.w	ClearCmdBuffer
	rts
.next	movem.l	d0-d7/a0-a6,-(sp)
	bclr.b	#$2,$FFFF8024.w
	lea.l	$80000.l,a0
	move.l	a0,$10984.l
	lea.l	$10BD8.l,a1
	lea.l	$15246.l,a2
	bsr.w	.loop
	move.l	a0,$1094C.l
	lea.l	$15246.l,a1
	lea.l	$15942.l,a2
	bsr.w	.loop
	move.l	a0,$109D8.l
	lea.l	$15942.l,a1
	lea.l	$16C62.l,a2
	bsr.w	.loop
	move.l	a0,$109DC.l
	lea.l	$16C62.l,a1
	lea.l	$17402.l,a2
	bsr.w	.loop
	move.l	a0,$109E0.l
	lea.l	$17402.l,a1
	lea.l	$1756C.l,a2
	bsr.w	.loop
	move.l	a0,$10BD0.l
	bset.b	#$2,$FFFF8024.w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.loop	move.b	(a1)+,(a0)+
	cmpa.l	a2,a1
	blt.b	.loop
RestoreBios_51	rts
; Sends the load commands for the two boot images ($1756C, $DA24).
LoadBootImages	movem.l	d0-d7/a0-a6,-(sp)
	bclr.b	#$2,$FFFF8024.w
	move.w	#$2,d0
	moveq	#$2,d1
	bsr.w	SubCommandDispatch
	lea.l	$1756C.l,a0
	move.w	#$0,d1
	move.w	#$5,d0
	bsr.w	SubCommandDispatch
	lea.l	$DA24.l,a0
	move.w	#$6,d0
	bsr.w	SubCommandDispatch
	bset.b	#$2,$FFFF8024.w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.b	$00,$02,$00,$00,$FF,$FF	; ......
; Screen setup with inline palette words.
ScreenSetupA	movem.l	d0-d7/a0-a6,-(sp)
	andi.b	#$EF,$BC6E8.l
	bsr.w	SendCmd2Inline
	dc.b	$00,$00,$FC,$00,$E0,$00,$C0,$00,$B0,$00,$00,$06,$00,$20,$00,$00	; ............. ..
	dc.b	$0C,$CC	; ..
RestoreBiosSub9	bsr.w	SendCmd3
	moveq	#$1,d4
	move.w	d4,$10AF0.l
	movea.l	$109DC.l,a0
	lea.l	$8(a0),a2
	bsr.w	SendCmd4Args
	lea.l	$BA850.l,a1
	adda.l	(a0),a0
	moveq	#$1F,d0
.loop	move.l	(a0)+,(a1)+
	dbra	d0,.loop
	move.w	#$18,$BA8D0.l
	move.w	#$F0,d6
	move.w	#$A,$10B6C.l
	clr.w	$10B6E.l
	lea.l	$DB78.l,a3
.loop2	bsr.w	AnimTick
	bsr.w	WaitFrameTick
	bsr.w	ReadPadsCombined
	moveq	#$0,d1
	tst.w	d1
	dbne	d6,.loop2
	bsr.w	SendCmd2Inline
	dc.b	$00,$00,$FC,$00,$E0,$00,$C0,$00,$B0,$00,$00,$06,$00,$20,$00,$00	; ............. ..
	dc.b	$0C,$CC	; ..
RestoreBiosSub10	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Advances the screen animation script by one tick.
AnimTick	movem.l	d0-d6/a0-a2,-(sp)
	btst.b	#$1,$BC6E8.l
	bne.w	.next4
	cmpi.w	#$10,$10B6E.l
	bgt.w	.next4
	subq.w	#$1,$10B6C.l
	bpl.w	.next4
	move.w	(a3)+,$10B6C.l
	move.w	(a3)+,d0
	cmpi.w	#$0,d0
	bne.w	.next
	move.w	#$0,-(sp)
	move.l	#$0,-(sp)
	bsr.w	SetupSpriteFrame
	move.w	#$1,d0
	bsr.w	WaitCountdown
	move.w	#$0,-(sp)
	move.l	#$0,-(sp)
	bsr.w	SetupSpriteFrame
.next	tst.w	-$2(a3)
	bpl.w	.next2
	subq.w	#$4,a3
.next2	addq.w	#$1,$10B6E.l
	bsr.w	SpriteListReset
	movea.l	$109DC.l,a0
	move.w	$10B6E.l,d2
	move.w	$10AF0.l,d4
.loop	move.w	#$80,d0
	move.w	#$80,d1
	cmpi.w	#$3,d2
	blt.w	.next3
	move.w	#$88,d1
.next3	bsr.w	SpriteListAddObject
	subq.w	#$1,d2
	bne.b	.loop
	bsr.w	SpriteListFinish
	bsr.w	SpriteListToVram
	bset.b	#$1,$BC6E8.l
.next4	movem.l	(sp)+,d0-d6/a0-a2
	rts
	dc.b	$00,$1E,$00,$00,$00,$1E,$00,$01,$00,$1E,$00,$01,$00,$04,$00,$01	; ................
	dc.b	$00,$06,$FF,$FF	; ....
; Screen setup, second variant.
ScreenSetupB	andi.b	#$9C,$BC6E8.l
	bsr.w	SendCmd3
	move.w	#$1,d4
	move.w	d4,$10AF0.l
	bsr.w	SendStateWithInline
	dc.b	$00,$08,$F8,$00,$01,$00,$00,$00	; ........
RestoreBiosSub11	movea.l	$109D8.l,a2
	lea.l	(a2),a0
	lea.l	(a2),a1
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	moveq	#$F,d5
	bsr.w	SaveRegsToCommBuf
	movea.l	#$107D0,a0
	movea.l	#$107CC,a1
	movea.l	#$107CA,a2
	lea.l	$10AF0.l,a3
	movea.l	$109E0.l,a4
	bsr.w	QueueAnimCmd
	movea.l	#$10822,a0
	movea.l	#$1081E,a1
	movea.l	#$1081C,a2
	lea.l	$10AF0.l,a3
	movea.l	$109E0.l,a4
	bsr.w	QueueAnimCmd
	movea.l	#$10874,a0
	movea.l	#$10870,a1
	movea.l	#$1086E,a2
	lea.l	$10AF0.l,a3
	movea.l	$109E0.l,a4
	bsr.w	QueueAnimCmd
	movea.l	#$108C6,a0
	movea.l	#$108C2,a1
	movea.l	#$108C0,a2
	lea.l	$10AF0.l,a3
	movea.l	$109E0.l,a4
	bsr.w	QueueAnimCmd
	move.w	#$20,$BA8D0.l
	move.w	#$B4,d7
.loop	bsr.w	.next
	bsr.w	WaitFrameTick
	bsr.w	ReadPadsCombined
	tst.w	d1
	dbne	d7,.loop
	bsr.w	ClearCmdBuffer
	rts
.next	btst.b	#$1,$BC6E8.l
	bne.w	.ex
	bsr.w	SpriteListReset
	move.w	$10AF0.l,d4
	movea.l	#$107CA,a2
	movea.l	#$107D0,a3
	movea.l	#$107CC,a4
	movea.l	$109E0.l,a0
	bsr.w	AnimNextFrame
	move.w	$10AF0.l,d4
	movea.l	#$1081C,a2
	movea.l	#$10822,a3
	movea.l	#$1081E,a4
	movea.l	$109E0.l,a0
	bsr.w	AnimNextFrame
	move.w	$10AF0.l,d4
	movea.l	#$1086E,a2
	movea.l	#$10874,a3
	movea.l	#$10870,a4
	movea.l	$109E0.l,a0
	bsr.w	AnimNextFrame
	move.w	$10AF0.l,d4
	movea.l	#$108C0,a2
	movea.l	#$108C6,a3
	movea.l	#$108C2,a4
	movea.l	$109E0.l,a0
	bsr.w	AnimNextFrame
	bsr.w	SpriteListFinish
	bsr.w	SpriteListToVram
	bset.b	#$1,$BC6E8.l
.ex	rts
; Screen setup, third variant.
ScreenSetupC	andi.b	#$9C,$BC6E8.l
	bsr.w	SendCmd2Inline
	dc.b	$00,$00,$FC,$00,$E0,$00,$C0,$00,$B0,$00,$00,$06,$00,$20,$00,$00	; ............. ..
	dc.b	$0C,$CC	; ..
RestoreBiosSub12	bsr.w	SendCmd3
	bsr.w	SendCmdF
	move.w	$10BCE.l,$10B2A.l
	move.w	$10BCE.l,$10B2C.l
	moveq	#$1C,d0
	bsr.w	SendCmdD0
	clr.w	$10B22.l
	bsr.w	SendStateInline
	dc.b	$00,$06,$FF,$00,$00,$00	; ......
RestoreBiosSub13	move.l	#$80,d0
	moveq	#$20,d1
	move.l	#$7FF,d2
	jsr	$E4D6.l
	bsr.w	SendStateInline
	dc.b	$00,$06,$FE,$00,$00,$00	; ......
RestoreBiosSub14	move.l	#$80,d0
	moveq	#$20,d1
	move.l	#$7FF,d2
	jsr	$E4D6.l
	moveq	#$1C,d4
	bsr.w	SendStateInline
	dc.b	$00,$06,$FE,$00,$13,$00	; ......
RestoreBiosSub15	movea.l	$10984.l,a1
	adda.l	$4(a1),a1
	lea.l	$BC6EC.l,a2
	clr.w	d0
	moveq	#$13,d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	sub.w	d1,d3
	moveq	#$0,d5
	jsr	$E51C.l
	bsr.w	SendStateInline
	dc.b	$00,$06,$FD,$00,$00,$00	; ......
RestoreBiosSub16	movea.l	$10984.l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	moveq	#$F,d5
	jsr	$E51C.l
	move.w	d4,$10AFE.l
	movea.l	$1094C.l,a2
	addq.l	#$8,a2
	jsr	$E12A.l
	bsr.w	CopyAnimStateToCmd
	bsr.w	SendStateInline
	dc.b	$00,$06,$FF,$00,$00,$00	; ......
RestoreBiosSub17	lea.l	$25F0E.l,a1
	bsr.w	CalcScrollPhase
	addi.w	#$40,$10B22.l
	clr.w	$10B20.l
	clr.w	$10B24.l
	move.w	#$5,$10B28.l
	move.w	#$20,$BA8D0.l
	move.w	#$F0,d3
.loop	bsr.w	WaitFrameAndUpdate
	dbra	d3,.loop
	bsr.w	SendStateInline
	dc.b	$00,$06,$FF,$00,$00,$00	; ......
RestoreBiosSub18	lea.l	$25F36.l,a1
.loop	bsr.w	CalcScrollPhase
	adda.w	(a1),a1
	moveq	#$3F,d4
.loop2	bsr.w	WaitFrameAndUpdate
	bsr.w	WaitFrameAndUpdate
	addq.w	#$1,$10B22.l
	dbra	d4,.loop2
	moveq	#$78,d4
.loop3	bsr.w	WaitFrameAndUpdate
	dbra	d4,.loop3
	tst.w	$2(a1)
	bpl.b	.loop
	rts
; Derives the scroll phase from the counter at $10B22.
CalcScrollPhase	move.w	$10B22.l,d0
	asr.w	#$3,d0
	addi.w	#$1C,d0
	andi.w	#$1F,d0
	move.w	d0,$10B0C.l
	move.w	d0,-(sp)
	clr.w	$10B0A.l
	moveq	#$20,d0
	moveq	#$9,d1
	move.w	#$7FF,d2
	jsr	$E4D6.l
	move.w	(sp)+,$10B0C.l
.loop	move.w	(a1),d0
	asr.w	#$1,d0
	neg.w	d0
	addi.w	#$10,d0
	move.w	d0,$10B0A.l
	bsr.w	SendPadStateCmd
	addq.w	#$1,$10B0C.l
	andi.w	#$1F,$10B0C.l
	tst.w	$2(a1)
	bpl.b	.loop
	rts
; Waits for the next frame tick, then updates the screen state.
WaitFrameAndUpdate	movem.l	d0-d7/a0-a6,-(sp)
	move.w	$10AE0.l,d0
.loop	cmp.w	$10AE0.l,d0
	beq.b	.loop
	bsr.w	.next
	jsr	$E198.l
	btst	#$7,d1
	movem.l	(sp)+,d0-d7/a0-a6
	beq.w	.ex
	addq.l	#$4,sp
	rts
.next	lea.l	$BA450.l,a0
	move.w	$10B22.l,(a0)
	moveq	#$1D,d0
	bsr.w	SendCmdD0
	move.w	#$DF,d0
	lea.l	$BC368.l,a0
	moveq	#$7F,d1
	add.w	$10B20.l,d1
.loop2	clr.l	(a0)+
	cmpi.w	#$48,d0
	ble.w	.next2
	move.w	d1,-$2(a0)
.next2	dbra	d0,.loop2
	bset.b	#$0,$BC6E8.l
	bset.b	#$6,$BC6E8.l
	cmpi.w	#$B4,$10B20.l
	blt.w	.next3
	subq.w	#$1,$10B24.l
	bpl.w	.ex
	move.w	#$12C,d0
	jsr	$E488.l
	move.w	d0,$10B24.l
	andi.w	#$7,d0
	addq.w	#$4,d0
	move.w	d0,$10B28.l
	move.w	#$FEB4,$10B20.l
.next3	move.w	$10B28.l,d0
	add.w	d0,$10B20.l
.ex	rts
; Waits until the frame counter at $10AE0 changes.
WaitFrameTick	move.w	d0,-(sp)
	move.w	$10AE2.l,d0
.loop	cmp.w	$10AE0.l,d0
	beq.b	.loop
	move.w	$10AE0.l,$10AE2.l
	move.w	(sp)+,d0
	rts
; Points the sprite list registers at $BA8D2/$BAF16 and restarts the count.
SpriteListReset	movea.l	#$BA8D2,a5
	movea.l	#$BAF16,a6
	moveq	#$1,d6
	rts
; Adds the sprites of one object to the list (max $50).
SpriteListAddObject	cmpi.w	#$50,d6
	bgt.w	RestoreBios_51
	movem.l	d0-d5/a0,-(sp)
	adda.l	$4(a0),a0
	move.w	d2,d5
	andi.w	#$7FF,d2
	add.w	d2,d2
	move.w	(a0,d2.w),d3
	sub.w	-$2(a0,d2.w),d3
	lsr.w	#$3,d3
	subq.w	#$1,d3
	adda.w	-$2(a0,d2.w),a0
.loop	move.w	$2(a0),(a6)
	add.w	d1,(a6)+
	move.b	$7(a0),(a6)+
	move.b	d6,(a6)+
	move.w	$6(a0),d2
	eor.w	d5,d2
	andi.w	#$F800,d2
	add.w	$4(a0),d2
	add.w	d4,d2
	move.w	d2,(a6)+
	move.w	(a0),(a6)
	add.w	d0,(a6)+
	addq.w	#$1,d6
	cmpi.w	#$51,d6
	beq.w	.next
	addq.l	#$8,a0
	dbra	d3,.loop
.next	movem.l	(sp)+,d0-d5/a0
	rts
; Terminates the sprite list.
SpriteListFinish	moveq	#-1,d0
	add.w	d6,d0
	bne.w	.next
	moveq	#$1,d0
	clr.l	(a6)+
	clr.l	(a6)+
.next	cmpi.w	#$50,d0
	ble.w	.next2
	moveq	#$50,d0
.next2	asl.w	#$3,d0
	lea.l	$BAF16.l,a6
	clr.b	-$5(a6,d0.w)
	lsr.w	#$1,d0
	move.w	d0,$BB1E6.l
	move.l	a5,$BAF12.l
	rts
; Copies the sprite data to the buffer at $BC6F0.
SpriteListToVram	movea.l	#$BC6F0,a0
	lea.l	$BA8D2.l,a1
	move.l	#$80000,d1
.loop	cmpa.l	$BAF12.l,a1
	beq.w	.next2
	move.l	(a1),d0
	cmp.l	d1,d0
	bgt.w	.next
	movea.l	d0,a2
	move.w	$4(a1),d0
	subq.w	#$1,d0
	move.l	a0,(a1)
.loop2	move.w	(a2)+,(a0)+
	cmpa.l	#$C0000,a0
	bge.w	.next3
	dbra	d0,.loop2
.next	addq.l	#$8,a1
	bra.b	.loop
.next2	move.l	a0,$10AC8.l
	rts
.next3	bra.b	.next3
; Steps an animation script to its next frame or loop point.
AnimNextFrame	movea.l	(a4),a1
	move.w	$2(a1),d2
	subq.w	#$1,(a2)
	bpl.w	.next4
	addq.l	#$4,a1
	move.w	(a1),d0
	bpl.w	.next3
	move.w	$2(a1),d0
	beq.w	.next
	bmi.w	.next2
.next	move.l	a3,(a4)
	addq.l	#$4,(a4)
	movea.l	(a4),a1
	move.w	(a1),d0
	bra.w	.next3
.next2	subq.l	#$4,a1
	move.w	(a1),d0
.next3	move.w	d0,(a2)
	move.w	$2(a1),d2
	move.l	a1,(a4)
.next4	tst.w	d2
	bmi.w	RestoreBios_65
	move.w	(a3)+,d0
RestoreBiosSub20	move.w	(a3),d1
	bsr.w	SpriteListAddObject
RestoreBios_65	rts
; Stores the animation state and sends command 4.
QueueAnimCmd	move.w	d4,(a3)
	move.l	a0,(a1)
	addq.l	#$4,(a1)
	move.w	$4(a0),(a2)
	movea.l	a4,a0
	lea.l	$8(a0),a2
	bsr.w	SendCmd4Args
	rts
; Stores -d0 in the frame counter and waits until it counts up past zero.
WaitCountdown	neg.w	d0
	move.w	d0,$10AE0.l
.loop	tst.w	$10AE0.l
	bmi.b	.loop
	rts
; Puts d4/a2 in the command buffer and sends command 4.
SendCmd4Args	movem.l	d0-d1/a0,-(sp)
	lea.l	$BA450.l,a0
	move.l	d4,(a0)+
	move.l	a2,(a0)
	moveq	#$4,d0
	bsr.w	SendCmdD0
	lea.l	$BA450.l,a0
	move.l	(a0),d4
	movem.l	(sp)+,d0-d1/a0
	rts
; Clears the 32-long command buffer at $BA850.
ClearCmdBuffer	movem.l	d0/a0,-(sp)
	lea.l	$BA850.l,a0
	moveq	#$1F,d0
.loop	move.l	(a0),-(sp)
	clr.l	(a0)+
	dbra	d0,.loop
	move.w	#$18,$BA8D0.l
	bsr.w	.next
	moveq	#$1F,d0
.loop2	move.l	(sp)+,-(a0)
	dbra	d0,.loop2
	movem.l	(sp)+,d0/a0
	rts
.next	move.w	$BC6E8.l,-(sp)
	bclr.b	#$4,$BC6E8.l
.loop3	tst.w	$BA8D0.l
	bpl.b	.loop3
	move.w	(sp)+,$BC6E8.l
	rts
; Reads the pads four times and ORs the results.
ReadPadsCombined	movem.l	d0/d2-d4,-(sp)
	clr.w	-(sp)
	moveq	#$3,d4
.loop	bsr.w	ReadCommRegs
	bsr.w	PadAutoRepeat
	or.w	d1,(sp)
	dbra	d4,.loop
	move.w	(sp)+,d1
	movem.l	(sp)+,d0/d2-d4
	rts
	tst.w	d3
	beq.w	RestoreBios_71
	tst.w	d2
	bne.w	.next
	subq.b	#$1,$10B1C.l
	bpl.w	RestoreBios_71
	move.b	#$4,$10B1C.l
	move.w	d3,d1
	andi.w	#$F,d1
	rts
.next	move.b	#$F,$10B1C.l
RestoreBios_71	rts
	tst.w	d3
	beq.b	RestoreBios_71
	tst.w	d2
	bne.w	.next
	subq.b	#$1,$10B1D.l
	bpl.b	RestoreBios_71
	move.b	#$4,$10B1D.l
	move.w	d3,d1
	andi.w	#$F,d1
	rts
.next	move.b	#$F,$10B1D.l
	rts
; Auto-repeat counter for held pad directions.
PadAutoRepeat	tst.w	d3
	beq.b	RestoreBios_71
	movem.l	a0,-(sp)
	lea.l	$10B1C.l,a0
	tst.w	d2
	bne.w	.next
	subq.b	#$1,(a0,d4.w)
	bpl.w	.next2
	move.b	#$4,(a0,d4.w)
	move.w	d3,d1
	andi.w	#$F,d1
	bra.w	.next2
.next	move.b	#$F,(a0,d4.w)
.next2	movem.l	(sp)+,a0
	rts
; Copies the main-CPU comm registers $801C-$801E into the pad/status bytes at $10B14.
ReadCommRegs	move.w	$FFFF801C.w,d0
	move.b	d0,$10B15.l
	lsr.w	#$8,d0
	move.b	d0,$10B14.l
	move.w	$FFFF801E.w,d0
	move.b	d0,$10B17.l
	lsr.w	#$8,d0
	move.b	d0,$10B16.l
	moveq	#$0,d0
	movem.l	a0,-(sp)
	lea.l	$10B14.l,a0
	move.b	(a0,d4.w),d0
	bsr.w	.next
	moveq	#$0,d2
	move.b	$4(a0,d4.w),d2
	move.b	d1,$4(a0,d4.w)
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	movem.l	(sp)+,a0
	rts
	move.w	$FFFF801C.w,d0
	lsr.w	#$8,d0
	move.b	d0,$10B14.l
	bsr.w	.next
	move.b	$10B18.l,d2
	move.b	d1,$10B18.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
	move.w	$FFFF801C.w,d0
	move.b	d0,$10B15.l
	bsr.w	.next
	move.b	$10B19.l,d2
	move.b	d1,$10B19.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
.next	clr.w	d1
	move.b	d0,d1
	movem.l	d1/a0,-(sp)
	andi.w	#$F0,d0
	andi.w	#$F,d1
	lea.l	$E300.l,a0
	move.b	(a0,d1.w),d1
	or.w	d1,d0
	movem.l	(sp)+,d1/a0
	rts
	dc.b	$08,$00,$04,$08,$06,$07,$05,$08,$02,$01,$03,$08,$08,$08,$08,$08	; ................
; Sends command 3 to the main CPU.
SendCmd3	movem.l	d0,-(sp)
	moveq	#$3,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0
	rts
; Sends command 2 with the nine inline words after the call.
SendCmd2Inline	movea.l	(sp),a0
	lea.l	$BA450.l,a1
	moveq	#$8,d0
.loop	move.w	(a0)+,(a1)+
	dbra	d0,.loop
	move.l	a0,(sp)
	moveq	#$2,d0
	bra.w	SendCmdD0
RestoreBiosSub24	movem.l	d0/d2-d3/a1,-(sp)
	lea.l	$BA450.l,a1
	move.w	d0,(a1)+
	move.w	d1,(a1)+
	move.l	a0,(a1)
	moveq	#$0,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0/d2-d3/a1
	rts
RestoreBiosSub25	movem.l	d0/d2-d3/a1,-(sp)
	lea.l	$BA450.l,a1
	move.w	d0,(a1)+
	move.w	d1,(a1)+
	move.l	a0,(a1)
	moveq	#$1,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0/d2-d3/a1
	rts
; Sends the command in d0 through the gate-array comm registers and waits for the acknowledge.
SendCmdD0	move.w	d0,$FFFF8020.w
	bset.b	#$6,$FFFF800F.w
.loop	btst.b	#$6,$FFFF800E.w
	beq.b	.loop
	bclr.b	#$6,$FFFF800F.w
	move.w	#$0,$FFFF8020.w
	bclr.b	#$1,$FFFF8024.w
	bsr.w	CommHandshake0
	bsr.w	ReleaseWordRam
	bsr.w	CommHandshake1
.loop2	btst.b	#$0,$FFFF8014.w
	beq.b	.loop2
	bset.b	#$1,$FFFF8024.w
	bsr.w	CommHandshake2
	bsr.w	TakeWordRam
	bsr.w	CommHandshake3
	rts
; Clears the sub-CPU communication registers $8020-$802C.
ClearCommRegs	move.w	#$0,$FFFF8020.w
	move.w	#$0,$FFFF8022.w
	move.w	#$0,$FFFF8024.w
	move.w	#$0,$FFFF8026.w
	move.w	#$0,$FFFF8028.w
	move.w	#$0,$FFFF802A.w
	move.w	#$0,$FFFF802C.w
	move.w	#$0,$FFFF802E.w
	rts
.loop	bclr.b	#$2,$FFFF8003.w
	bne.b	.loop
	rts
.loop2	btst.b	#$7,$FFFF800E.w
	beq.b	.loop2
	bset.b	#$7,$FFFF800F.w
.loop3	btst.b	#$7,$FFFF800E.w
	bne.b	.loop3
	bclr.b	#$7,$FFFF800F.w
	rts
; Waits until word RAM is granted to the sub CPU and notes it.
TakeWordRam	btst.b	#$1,$FFFF8003.w
	beq.b	TakeWordRam
	btst.b	#$0,$FFFF8003.w
	bne.b	TakeWordRam
	bset.b	#$1,$10912.l
	rts
; Returns word RAM to the main CPU.
ReleaseWordRam	bset.b	#$0,$FFFF8003.w
	bclr.b	#$1,$10912.l
	rts
	lea.l	$10ADA.l,a0
.loop	clr.b	(a0)+
	cmpa.l	#$10BD8,a0
	blt.b	.loop
	rts
; Empty routine.
NopReturn	rts
	dc.b	$4E,$B9,$00,$00,$E3,$F8	; N.....
RestoreBiosSub26	movem.l	a0-a1,-(sp)
	movea.l	$EC96.l,a0
	move.l	(a0),$10ACC.l
	move.l	#$EA8A,(a0)
	bset.b	#$2,$FFFF8033.w
	movem.l	(sp)+,a0-a1
	rts
	move.w	d0,-(sp)
	add.w	d0,d0
	bsr.w	.next
	sub.w	(sp)+,d0
	rts
.next	movem.l	d0-d2,-(sp)
	move.w	$10B2C.l,d0
	move.w	d0,d1
	move.w	$10B2A.l,d2
	mulu.w	#$E62D,d0
	mulu.w	#$BB40,d1
	mulu.w	#$E62D,d2
	add.w	d2,d1
	swap	d0
	add.w	d1,d0
	swap	d0
	addq.l	#$1,d0
	move.l	d0,$10B2A.l
	asr.l	#$8,d0
	mulu.w	$2(sp),d0
	swap	d0
	addq.l	#$4,sp
	movem.l	(sp)+,d1-d2
	rts
RestoreBiosSub27	movem.l	d0/a0,-(sp)
	moveq	#$6,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0/a0
	rts
RestoreBiosSub28	movem.l	d0-d3/a0,-(sp)
	lea.l	$BA450.l,a0
	move.w	d0,(a0)+
	move.w	d1,(a0)+
	move.w	d2,(a0)+
	move.w	$10B0A.l,(a0)+
	move.w	$10B0C.l,(a0)+
	move.w	$10B10.l,(a0)+
	moveq	#$7,d0
	bsr.w	SendCmdD0
	lea.l	$BA450.l,a0
	move.w	(a0)+,$10B0A.l
	move.w	(a0)+,$10B0C.l
	move.w	(a0)+,$10B10.l
	movem.l	(sp)+,d0-d3/a0
	rts
; Stores the registers and pad values in the command buffer.
SaveRegsToCommBuf	movem.l	d0-d3/d5-d6/a0-a3/a6,-(sp)
	lea.l	$BA450.l,a6
	move.l	a0,(a6)+
	move.l	a1,(a6)+
	move.l	a2,(a6)+
	move.l	d0,(a6)+
	move.l	d1,(a6)+
	move.l	d2,(a6)+
	move.l	d3,(a6)+
	move.l	d4,(a6)+
	move.l	d5,(a6)+
	move.w	$10B0E.l,(a6)+
	move.w	$10B0A.l,(a6)+
	move.w	$10B0C.l,(a6)+
	move.w	$10B10.l,(a6)+
	moveq	#$8,d0
	bsr.w	SendCmdD0
	lea.l	$BA450.l,a6
	move.w	(a6)+,d4
	move.w	(a6)+,$10B0E.l
	move.w	(a6)+,$10B0A.l
	move.w	(a6)+,$10B0C.l
	move.w	(a6)+,$10B10.l
	movem.l	(sp)+,d0-d3/d5-d6/a0-a3/a6
	rts
; Sends the pad state plus a length-prefixed inline block (command $B).
SendStateInline	movem.l	d0/a1-a2,-(sp)
	movea.l	$C(sp),a1
	lea.l	$BA450.l,a2
	move.w	$10B0E.l,(a2)+
	move.w	$10B10.l,(a2)+
	move.w	$10B0A.l,(a2)+
	move.w	$10B0C.l,(a2)+
	move.w	$10AFE.l,(a2)+
	move.w	(a1),d0
	lsr.w	#$1,d0
	subq.w	#$1,d0
.loop	move.w	(a1)+,(a2)+
	dbra	d0,.loop
	move.l	a1,$C(sp)
	moveq	#$B,d0
	bsr.w	SendCmdD0
	lea.l	$BA450.l,a1
	move.w	(a1)+,$10B0E.l
	move.w	(a1)+,$10B10.l
	move.w	(a1)+,$10B0A.l
	move.w	(a1),$10B0C.l
	movem.l	(sp)+,d0/a1-a2
	rts
RestoreBiosSub29	movem.l	d0-d3/a0/a2-a3,-(sp)
	lea.l	$BA450.l,a2
	move.w	$10B0E.l,(a2)+
	move.w	$10B0A.l,(a2)+
	move.w	$10B0C.l,(a2)+
	move.w	$10B12.l,(a2)+
	move.w	$10B10.l,(a2)+
	move.w	$10AFE.l,(a2)+
	move.w	$10B00.l,(a2)+
	move.w	$10B02.l,(a2)+
	move.w	(a1),d0
	lsr.w	#$1,d0
	subq.w	#$1,d0
.loop	move.w	(a1)+,(a2)+
	dbra	d0,.loop
	moveq	#$C,d0
	bsr.w	SendCmdD0
	lea.l	$BA450.l,a2
	move.w	(a2)+,$10B0E.l
	move.w	(a2)+,$10B0A.l
	move.w	(a2)+,$10B0C.l
	move.w	(a2)+,$10B12.l
	move.w	(a2),$10B10.l
	movem.l	(sp)+,d0-d3/a0/a2-a3
	rts
; Sends the pad state plus a length-prefixed inline block.
SendStateWithInline	movem.l	d0/a1-a2,-(sp)
	movea.l	$C(sp),a1
	lea.l	$BA450.l,a2
	move.w	$10B0E.l,(a2)+
	move.w	$10B0A.l,(a2)+
	move.w	$10B0C.l,(a2)+
	move.w	$10B12.l,(a2)+
	move.w	$10B10.l,(a2)+
	move.w	$10AFE.l,(a2)+
	move.w	$10B00.l,(a2)+
	move.w	$10B02.l,(a2)+
	move.w	(a1),d0
	lsr.w	#$1,d0
	subq.w	#$1,d0
.loop	move.w	(a1)+,(a2)+
	dbra	d0,.loop
	moveq	#$D,d0
	bsr.w	SendCmdD0
	move.l	a1,$C(sp)
	lea.l	$BA450.l,a1
	move.w	(a1)+,$10B0E.l
	move.w	(a1)+,$10B0A.l
	move.w	(a1)+,$10B0C.l
	move.w	(a1)+,$10B12.l
	move.w	(a1),$10B10.l
	movem.l	(sp)+,d0/a1-a2
	rts
RestoreBiosSub30	movem.l	d1-d4,-(sp)
	clr.w	d4
	moveq	#$2,d3
	moveq	#$E,d2
.loop	move.w	d0,d1
	and.w	d2,d1
	beq.w	.next
	add.w	d2,d1
	and.w	d2,d1
	or.w	d1,d4
.next	asl.w	#$4,d2
	dbra	d3,.loop
	move.w	d4,d0
	movem.l	(sp)+,d1-d4
	rts
; Copies the animation state words into the command buffer.
CopyAnimStateToCmd	movem.l	d0/a0-a1,-(sp)
	lea.l	$BA450.l,a0
	lea.l	$10AE4.l,a1
.loop	move.w	(a1)+,(a0)+
	cmpa.l	#$10B08,a1
	blt.b	.loop
	moveq	#$E,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0/a0-a1
	rts
RestoreBiosSub31	movem.l	a1,-(sp)
	movem.l	$4(sp),a1
	bsr.w	.next
	movem.l	a1,$4(sp)
	movem.l	(sp)+,a1
	rts
.next	movem.l	d0/a0,-(sp)
	lea.l	$2(a3),a0
	move.w	(a3),d0
	subq.w	#$3,d0
	bmi.w	.next2
.loop	addq.l	#$1,a0
	tst.b	(a0)
	dbeq	d0,.loop
.next2	move.w	(a1)+,d0
	subq.w	#$3,d0
	bmi.w	.next5
.loop2	move.b	(a1)+,(a0)+
	bne.w	.next3
	subq.l	#$1,a0
.next3	dbra	d0,.loop2
	move.l	a0,d0
	btst	#$0,d0
	beq.w	.next4
	clr.b	(a0)+
	addq.l	#$1,d0
.next4	sub.l	a3,d0
	move.w	d0,(a3)
.next5	movem.l	(sp)+,d0/a0
	rts
RestoreBiosSub32	movem.l	d1-d2/a0-a1,-(sp)
	clr.w	d0
	clr.w	d1
	move.w	(a1)+,d2
	subq.w	#$2,d2
	bra.w	.next2
.loop	move.b	(a1)+,d1
	beq.w	.next2
	bpl.w	.next
	subq.w	#$2,d2
	addq.l	#$2,a1
	clr.w	d0
	bra.w	.next2
.next	bsr.w	.next3
.next2	dbra	d2,.loop
	movem.l	(sp)+,d1-d2/a0-a1
	rts
.next3	ext.w	d1
	beq.w	RestoreBios_71
	cmpi.w	#$61,d1
	blt.w	.next4
	cmpi.w	#$7A,d1
	bgt.w	.next4
	addi.w	#$FFE0,d1
.next4	addq.w	#$1,d0
	movea.l	#$10570,a0
	tst.b	-$20(a0,d1.w)
	bmi.w	RestoreBios_71
	addq.w	#$1,d0
	rts
; Sends command $F and keeps the reply word.
SendCmdF	movem.l	d0,-(sp)
	moveq	#$F,d0
	bsr.w	SendCmdD0
	move.w	$BA450.l,$10BCE.l
	movem.l	(sp)+,d0
	rts
RestoreBiosSub33	movem.l	d0-d1/a0-a1,-(sp)
	lea.l	$BA450.l,a0
	move.l	d4,(a0)+
	move.l	a2,(a0)+
	movea.l	$10(sp),a1
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	moveq	#$10,d0
	bsr.w	SendCmdD0
	lea.l	$BA450.l,a0
	move.l	(a0),d4
	movem.l	(sp)+,d0-d1/a0-a1
	addq.l	#$8,(sp)
	rts
; Sets and clears handshake flag 0 in $8028 after the main CPU answers on $8018.
CommHandshake0	btst.b	#$0,$FFFF8018.w
	beq.b	CommHandshake0
	bset.b	#$0,$FFFF8028.w
.loop	btst.b	#$0,$FFFF8018.w
	bne.b	.loop
	bclr.b	#$0,$FFFF8028.w
	rts
; Handshake flag 1.
CommHandshake1	btst.b	#$1,$FFFF8018.w
	beq.b	CommHandshake1
	bset.b	#$1,$FFFF8028.w
.loop	btst.b	#$1,$FFFF8018.w
	bne.b	.loop
	bclr.b	#$1,$FFFF8028.w
	rts
; Handshake flag 2.
CommHandshake2	btst.b	#$2,$FFFF8018.w
	beq.b	CommHandshake2
	bset.b	#$2,$FFFF8028.w
.loop	btst.b	#$2,$FFFF8018.w
	bne.b	.loop
	bclr.b	#$2,$FFFF8028.w
	rts
; Handshake flag 3.
CommHandshake3	btst.b	#$3,$FFFF8018.w
	beq.b	CommHandshake3
	bset.b	#$3,$FFFF8028.w
.loop	btst.b	#$3,$FFFF8018.w
	bne.b	.loop
	bclr.b	#$3,$FFFF8028.w
	rts
RestoreBiosSub34	movem.l	d0/a0-a1,-(sp)
	lea.l	$BA450.l,a0
	movea.l	$C(sp),a1
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	a1,$C(sp)
	moveq	#$12,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0/a0-a1
	rts
RestoreBiosSub35	movem.l	d0/a0-a1,-(sp)
	lea.l	$BA450.l,a0
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	moveq	#$12,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0/a0-a1
	rts
; Sends command 5 with the value from $1094C.
SendCmd5	lea.l	$BA450.l,a0
	move.l	$1094C.l,(a0)+
	moveq	#$5,d0
	bsr.w	SendCmdD0
	rts
; Sends the pad state registers in the command buffer.
SendPadStateCmd	movem.l	d0-d3/a0/a2/a6,-(sp)
	lea.l	$BA450.l,a2
	move.w	$10B0E.l,(a2)+
	move.w	$10B10.l,(a2)+
	move.w	$10B0A.l,(a2)+
	move.w	$10B0C.l,(a2)+
	move.w	$10AFE.l,(a2)+
	move.w	(a1),d0
	lsr.w	#$1,d0
	subq.w	#$1,d0
.loop	move.w	(a1)+,(a2)+
	dbra	d0,.loop
	movea.l	a1,a6
	moveq	#$B,d0
	bsr.w	SendCmdD0
	lea.l	$BA450.l,a1
	move.w	(a1)+,$10B0E.l
	move.w	(a1)+,$10B10.l
	move.w	(a1)+,$10B0A.l
	move.w	(a1),$10B0C.l
	movea.l	a6,a1
	movem.l	(sp)+,d0-d3/a0/a2/a6
	rts
RestoreBiosSub36	movem.l	a0,-(sp)
	lea.l	$BA450.l,a0
	move.w	d0,(a0)
	moveq	#$13,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,a0
	rts
	bsr.w	.next
	bra.w	RestoreBiosSub29
.next	bra.w	.next2
.loop	adda.w	(a1),a1
.next2	dbra	d0,.loop
	rts
RestoreBiosSub37	movem.l	d0,-(sp)
	moveq	#$14,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0
	rts
RestoreBiosSub38	movem.l	d0,-(sp)
	moveq	#$15,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0
	rts
RestoreBiosSub39	movem.l	d0/a0,-(sp)
	lea.l	$BA450.l,a0
	move.w	$10B22.l,(a0)+
	move.w	d0,(a0)+
	moveq	#$16,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0/a0
	rts
RestoreBiosSub40	movem.l	d0/a0,-(sp)
	move.w	d0,$BA450.l
	moveq	#$19,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0/a0
	rts
	move.l	d0,-(sp)
	moveq	#$17,d0
	bsr.w	SendCmdD0
	move.l	(sp)+,d0
	rts
RestoreBiosSub41	movem.l	d0-d2/a0,-(sp)
	lea.l	$BA450.l,a0
RestoreBiosSub42	move.w	d0,(a0)+
	move.w	d1,(a0)+
	move.w	d2,(a0)+
	moveq	#$18,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0-d2/a0
	rts
.loop	bset.b	#$2,$FF8003.l
	bne.b	.loop
	rts
