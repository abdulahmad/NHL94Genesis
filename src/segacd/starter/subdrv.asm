;	STARTER.BIN $1542-$3A0B (runtime $C542-$EA0B).
;
;	The sub CPU driver module: the PCM sound driver (commands 0-8 and packed commands, records, eight
;	channels, envelopes), then the start-up sequence (screens, samples, two stages, film, credits), the
;	commands it sends to the main CPU, word RAM handover, frames, pads.
;
;	Names given here; docs/segacd_starter_driver.md. The parameter blocks of the inline senders and
;	PcmPitchTable are words. pcmclear.asm follows.


DispatchPcmCommandEntry	equ	$C4BC
RunStarterFilm	equ	$EAE4
X_C4C0	equ	$C4C0
X_D362	equ	$D362
X_D366	equ	$D366
X_D566	equ	$D566
X_D568	equ	$D568
X_D570	equ	$D570
X_D572	equ	$D572
X_D574	equ	$D574
X_D57C	equ	$D57C
X_D584	equ	$D584
X_D58C	equ	$D58C
X_D594	equ	$D594
X_D59C	equ	$D59C
X_D5A4	equ	$D5A4
X_D5AC	equ	$D5AC
X_D5BD	equ	$D5BD
X_D5BE	equ	$D5BE
X_D5C0	equ	$D5C0
X_D5C2	equ	$D5C2
X_D5C3	equ	$D5C3
X_D5C4	equ	$D5C4
X_D5C5	equ	$D5C5
X_D5C7	equ	$D5C7
X_D5C8	equ	$D5C8
X_D5C9	equ	$D5C9
X_D5CA	equ	$D5CA
X_D5CC	equ	$D5CC
X_D5D0	equ	$D5D0
X_D650	equ	$D650
X_D6D0	equ	$D6D0
X_D750	equ	$D750
X_D7D0	equ	$D7D0
X_D850	equ	$D850
X_D858	equ	$D858
X_D9E2	equ	$D9E2
X_DB78	equ	$DB78
X_DFAA	equ	$DFAA
X_E1E4	equ	$E1E4
X_1041A	equ	$1041A
X_104F6	equ	$104F6
X_10540	equ	$10540
X_1055C	equ	$1055C

	org	$C542

DispatchPcmCommand
	cmpi.b	#$80,d0
	bcs.s	.LC54C
	bra.w	DispatchPackedPcmCommand
.LC54C
	tst.w	d0
	bne.s	.LC554
	bra.w	InitPcmDriver
.LC554
	subi.w	#$1,d0
	bne.s	.LC55E
	bra.w	ServicePcmDriver
.LC55E
	subi.w	#$1,d0
	bne.s	.LC56A
	nop
	bra.w	ControlPcmSampleAllocation
.LC56A
	subi.w	#$1,d0
	bne.s	.LC574
	bra.w	PlayPcmSample
.LC574
	subi.w	#$1,d0
	bne.s	.LC57C
	nop
.LC57C
	subi.w	#$1,d0
	bne.s	.LC586
	bra.w	SetPcmRecordDirectory
.LC586
	subi.w	#$1,d0
	bne.s	.LC590
	bra.w	LoadPcmRecordList
.LC590
	subi.w	#$1,d0
	bne.s	.LC59A
	bra.w	PcmCommandNoOp
.LC59A
	subi.w	#$1,d0
	bne.s	.LC5A4
	bra.w	SetPcmSoundLoopOffset
.LC5A4
	move.w	#$1,d0
	ori.b	#$1,ccr
	rts
ServicePcmDriver
	movem.l	d0-d7/a0-a6,-(sp)
	lea	X_D570(pc),a0
	cmpi.w	#$0,(a0)
	beq.s	.LC5BE
	bra.s	.LC5F2
.LC5BE
	move.w	#$FFFF,(a0)
	bsr.w	DrainPcmCommandQueue
	move.w	$FF800C.l,d0
	sub.w	X_D5BE(pc),d0
	andi.w	#$FFF,d0
	cmpi.w	#$20,d0
	bcs.s	.LC5EA
	bsr.w	UpdatePcmEnvelopes
	lea	X_D5BE(pc),a0
	move.w	$FF800C.l,d0
	move.w	d0,(a0)
.LC5EA
	lea	X_D570(pc),a0
	move.w	#$0,(a0)
.LC5F2
	movem.l	(sp)+,d0-d7/a0-a6
	rts
DrainPcmCommandQueue
	movem.l	d0-d1/a0-a1,-(sp)
.LC5FC
	lea	X_C4C0(pc),a0
	cmpi.w	#$0,(a0)
	beq.s	.LC644
	move.l	$2(a0),d0
	bsr.w	DispatchPackedPcmCommand
	lea	X_C4C0(pc),a0
	move.w	(a0),d0
	move.w	#$FFFF,(a0)
	adda.l	#$2,a0
	movea.l	a0,a1
	adda.l	#$4,a1
	move.w	d0,d1
	subi.w	#$1,d1
	beq.s	.LC638
	subi.w	#$1,d1
.LC632
	move.l	(a1)+,(a0)+
	dbf	d1,.LC632
.LC638
	lea	X_C4C0(pc),a0
	subi.w	#$1,d0
	move.w	d0,(a0)
	bra.s	.LC5FC
.LC644
	movem.l	(sp)+,d0-d1/a0-a1
	rts
UpdatePcmEnvelopes
	movem.l	d1-d4/a0-a2,-(sp)
	lea	X_D5C0(pc),a0
	move.w	#$0,(a0)
.LC656
	move.b	X_D572(pc),d0
	move.w	X_D5C0(pc),d2
	btst	d2,d0
	bne.w	.LC7F4
	lsl.w	#$2,d2
	lea	$FF0021.l,a0
	cmpi.b	#$0,$2(a0,d2.w)
	bne.s	.LC690
	lea	X_D572(pc),a0
	move.w	X_D5C0(pc),d0
	move.b	(a0),d2
	bset	d0,d2
	move.b	d2,(a0)
	move.b	d2,$FF0011.l
	bsr.w	PcmWriteDelay
	bra.w	.LC7F4
.LC690
	move.w	X_D5C0(pc),d2
	lea	X_D59C(pc),a0
	cmpi.b	#$FF,(a0,d2.w)
	beq.w	.LC7F4
	clr.w	d1
	move.b	(a0,d2.w),d1
	move.w	#$4,d0
	bsr.w	FindPcmRecord
	bcs.w	.LC7F4
	lea	X_D5AC(pc),a1
	move.w	X_D5C0(pc),d0
	lsl.w	#$1,d0
	move.w	$FF800C.l,d1
	sub.w	X_D5BE(pc),d1
	andi.w	#$FFF,d1
	lsr.w	#$5,d1
	add.w	(a1,d0.w),d1
	move.w	d1,(a1,d0.w)
	lea	X_D5A4(pc),a2
	move.w	X_D5C0(pc),d1
	clr.w	d2
	move.b	(a2,d1.w),d2
	addi.w	#$1,d2
	lsl.w	#$1,d2
	addi.w	#$3,d2
	clr.w	d3
	move.b	(a0,d2.w),d3
	cmp.w	(a1,d0.w),d3
	bcc.s	.LC74C
	move.w	(a1,d0.w),d2
	sub.w	d3,d2
	move.w	d2,(a1,d0.w)
	addi.b	#$1,(a2,d1.w)
	move.b	(a2,d1.w),d2
	cmp.b	$2(a0),d2
	bne.s	.LC728
	lea	X_D5BD(pc),a1
	move.w	X_D5C0(pc),d3
	btst.b	d3,(a1)
	beq.s	.LC728
	move.b	$1(a0),(a2,d1.w)
	bra.s	.LC74C
.LC728
	addi.b	#$1,d2
	cmp.b	(a0),d2
	bcs.s	.LC74C
	lea	X_D572(pc),a0
	move.w	X_D5C0(pc),d0
	move.b	(a0),d1
	bset	d0,d1
	move.b	d1,$FF0011.l
	move.b	d1,(a0)
	bsr.w	PcmWriteDelay
	bra.w	.LC7F4
.LC74C
	lea	X_D5A4(pc),a1
	move.w	X_D5C0(pc),d0
	clr.w	d1
	move.b	(a1,d0.w),d1
	lsl.w	#$1,d1
	addi.w	#$3,d1
	move.b	$1(a0,d1.w),d0
	cmp.b	$3(a0,d1.w),d0
	bcs.s	.LC776
	clr.w	d2
	move.b	$1(a0,d1.w),d2
	sub.b	$3(a0,d1.w),d2
	bra.s	.LC780
.LC776
	clr.w	d2
	move.b	$3(a0,d1.w),d2
	sub.b	$1(a0,d1.w),d2
.LC780
	cmpi.b	#$0,d2
	bne.s	.LC78C
	move.b	$1(a0,d1.w),d2
	bra.s	.LC7C8
.LC78C
	lea	X_D5AC(pc),a1
	move.w	X_D5C0(pc),d0
	lsl.w	#$1,d0
	move.w	(a1,d0.w),d3
	lsl.w	#$8,d3
	clr.w	d4
	move.b	$2(a0,d1.w),d4
	divu.w	d4,d3
	move.b	$1(a0,d1.w),d0
	cmp.b	$3(a0,d1.w),d0
	bcs.s	.LC7BC
	mulu.w	d2,d3
	lsr.w	#$8,d3
	clr.w	d2
	move.b	$1(a0,d1.w),d2
	sub.w	d3,d2
	bra.s	.LC7C8
.LC7BC
	mulu.w	d2,d3
	lsr.w	#$8,d3
	clr.w	d2
	move.b	$1(a0,d1.w),d2
	add.w	d3,d2
.LC7C8
	lea	X_D58C(pc),a1
	move.w	X_D5C0(pc),d0
	clr.w	d3
	move.b	(a1,d0.w),d3
	lsl.w	#$1,d3
	mulu.w	d3,d2
	lsr.w	#$8,d2
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	bsr.w	PcmWriteDelay
	move.b	d2,$FF0001.l
	bsr.w	PcmWriteDelay
.LC7F4
	lea	X_D5C0(pc),a0
	addi.w	#$1,(a0)
	cmpi.w	#$8,(a0)
	beq.s	.LC806
	bra.w	.LC656
.LC806
	movem.l	(sp)+,d1-d4/a0-a2
	rts
DispatchPackedPcmCommand
	cmpi.b	#$8F,d0
	bgt.s	.LC816
	bra.w	StopPackedPcmSound
.LC816
	cmpi.b	#$9F,d0
	bgt.s	.LC820
	bra.w	PlayPackedPcmSound
.LC820
	cmpi.b	#$AF,d0
	bgt.s	.LC828
	bra.s	.LC84C
.LC828
	cmpi.b	#$BF,d0
	bgt.s	.LC830
	nop
.LC830
	cmpi.b	#$CF,d0
	bgt.s	.LC83A
	bra.w	SetPcmSoundMapping
.LC83A
	cmpi.b	#$DF,d0
	bgt.s	.LC842
	bra.s	.LC84C
.LC842
	cmpi.b	#$EF,d0
	bgt.s	.LC84C
	bra.w	SetPcmPitchControl
.LC84C
	move.w	#$1,d0
	ori.b	#$1,ccr
	rts
PlayPackedPcmSound
	movem.l	d1-d2/a0-a1,-(sp)
	lea	X_D362(pc),a0
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
	move.w	X_D5C2(pc),d2
	lea	X_D5D0(pc),a0
	clr.w	d1
	move.b	(a0,d2.w),d1
.LC892
	lea	X_D5C8(pc),a0
	move.w	d1,(a0)
	move.w	#$0,d0
	bsr.w	FindPcmRecord
	bcs.w	.LC9A8
	lea	X_D5CC(pc),a1
	move.l	a0,(a1)
	cmpi.b	#$7,(a0)
	bne.s	.LC8C0
	move.w	X_D5C4(pc),d0
	addi.w	#$1,d0
	clr.w	d1
	move.b	(a0,d0.w),d1
	bra.s	.LC892
.LC8C0
	bsr.w	SelectPcmChannel
	bcc.s	.LC8CA
	bra.w	.LC9A8
.LC8CA
	move.w	X_D5C0(pc),d0
	lea	X_D574(pc),a0
	move.b	X_D5C3(pc),(a0,d0.w)
	lea	X_D57C(pc),a0
	move.b	X_D5C9(pc),(a0,d0.w)
	lea	X_D584(pc),a0
	move.b	X_D5C5(pc),(a0,d0.w)
	lea	X_D58C(pc),a0
	move.b	X_D5C7(pc),(a0,d0.w)
	lea	X_D594(pc),a0
	movea.l	X_D5CC(pc),a1
	move.b	$1(a1),(a0,d0.w)
	move.w	X_D5CA(pc),d0
	btst	#$0,d0
	beq.s	.LC914
	btst	#$1,d0
	beq.s	.LC98C
.LC914
	move.b	X_D572(pc),d0
	move.w	X_D5C0(pc),d1
	bset	d1,d0
	move.b	d0,$FF0011.l
	bsr.w	PcmWriteDelay
	ori.b	#$C0,d1
	move.b	d1,$FF000F.l
	bsr.w	PcmWriteDelay
	movea.l	X_D5CC(pc),a0
	clr.w	d0
	move.b	$2(a0),d0
	lsl.w	#$1,d0
	lea	X_D366(pc),a1
	move.w	(a1,d0.w),d1
	lsr.w	#$8,d1
	move.b	d1,$FF000D.l
	bsr.w	PcmWriteDelay
	move.b	$5(a0),d1
	lsl.w	#$8,d1
	move.b	$6(a0),d1
	cmpi.w	#$FFFF,d1
	bne.s	.LC96A
	clr.w	d1
	bra.s	.LC96E
.LC96A
	add.w	(a1,d0.w),d1
.LC96E
	move.b	d1,$FF0009.l
	bsr.w	PcmWriteDelay
	lsr.w	#$8,d1
	move.b	d1,$FF000B.l
	bsr.w	PcmWriteDelay
	bsr.w	StartPcmEnvelope
	bsr.w	UpdatePcmPan
.LC98C
	bsr.w	UpdatePcmFrequency
	lea	X_D572(pc),a0
	move.w	X_D5C0(pc),d0
	move.b	(a0),d1
	bclr	d0,d1
	move.b	d1,$FF0011.l
	bsr.w	PcmWriteDelay
	move.b	d1,(a0)
.LC9A8
	movem.l	(sp)+,d1-d2/a0-a1
	rts
StopPackedPcmSound
	movem.l	d1-d3/a0-a2,-(sp)
	clr.w	d1
	move.b	d0,d1
	andi.b	#$F,d1
	move.l	d0,d2
	swap	d2
	lsr.w	#$8,d2
	or.b	d2,d1
	lea	X_D5C2(pc),a0
	move.w	d1,(a0)
	move.w	d0,d1
	lsr.w	#$8,d1
	lea	X_D5C4(pc),a0
	move.w	d1,(a0)
	lea	X_D5D0(pc),a0
	move.w	X_D5C2(pc),d0
	clr.w	d1
	move.b	(a0,d0.w),d1
.LC9E0
	move.w	#$0,d0
	bsr.w	FindPcmRecord
	bcs.w	.LCAAA
	cmpi.b	#$7,(a0)
	bne.s	.LCA02
	move.w	X_D5C4(pc),d0
	addi.w	#$1,d0
	clr.w	d1
	move.b	(a0,d0.w),d1
	bra.s	.LC9E0
.LCA02
	move.b	$5(a0),d0
	lsl.w	#$8,d0
	move.b	$6(a0),d0
	cmpi.w	#$FFFF,d0
	beq.w	.LCAAA
	move.b	X_D572(pc),d0
	clr.w	d1
	lea	X_D574(pc),a1
	lea	X_D584(pc),a2
	move.w	X_D5C2(pc),d2
	move.w	X_D5C4(pc),d3
.LCA2A
	btst	d1,d0
	bne.s	.LCA8C
	cmp.b	(a1),d2
	bne.s	.LCA8C
	cmp.b	(a2),d3
	bne.s	.LCA8C
	cmpi.b	#$FF,$D(a0)
	beq.s	.LCA76
	lea	X_D5BD(pc),a1
	bclr.b	d1,(a1)
	lea	X_D5C0(pc),a1
	move.w	d1,(a1)
	clr.w	d1
	move.b	$D(a0),d1
	move.w	#$4,d0
	bsr.w	FindPcmRecord
	bcs.s	.LCAAA
	lea	X_D5A4(pc),a1
	move.w	X_D5C0(pc),d0
	move.b	$2(a0),(a1,d0.w)
	lsl.w	#$1,d0
	lea	X_D5AC(pc),a1
	move.w	#$0,(a1,d0.w)
	bra.s	.LCAAA
.LCA76
	lea	X_D572(pc),a0
	bset	d1,d0
	move.b	d0,(a0)
	move.b	d0,$FF0011.l
	bsr.w	PcmWriteDelay
	clr.w	d0
	bra.s	.LCAAA
.LCA8C
	adda.l	#$1,a1
	adda.l	#$1,a2
	addi.w	#$1,d1
	cmpi.w	#$8,d1
	bne.s	.LCA2A
	move.w	#$FFFF,d0
	ori.b	#$1,ccr
.LCAAA
	movem.l	(sp)+,d1-d3/a0-a2
	rts
SetPcmSoundMapping
	movem.l	d1-d2/a0,-(sp)
	move.l	d0,d1
	swap	d1
	lsr.w	#$8,d1
	move.w	d0,d2
	andi.w	#$F,d2
	or.b	d1,d2
	lsr.w	#$8,d0
	lea	X_D5D0(pc),a0
	move.b	d0,(a0,d2.w)
	clr.w	d0
	movem.l	(sp)+,d1-d2/a0
	rts
SetPcmPitchControl
	movem.l	d1-d2/a0,-(sp)
	move.l	d0,d1
	swap	d1
	lsr.w	#$8,d1
	move.w	d0,d2
	andi.w	#$F,d2
	or.b	d1,d2
	lsr.w	#$8,d0
	lea	X_D7D0(pc),a0
	move.b	d0,(a0,d2.w)
	lea	X_D5C0(pc),a0
	move.w	#$0,(a0)
.LCAF8
	move.w	X_D5C0(pc),d0
	move.b	X_D572(pc),d1
	btst	d0,d1
	beq.s	.LCB12
	lea	X_D574(pc),a0
	cmp.b	(a0,d0.w),d2
	bne.s	.LCB12
	bsr.w	UpdatePcmFrequency
.LCB12
	lea	X_D5C0(pc),a0
	addi.w	#$1,(a0)
	cmpi.w	#$8,(a0)
	bne.s	.LCAF8
	clr.w	d0
	movem.l	(sp)+,d1-d2/a0
	rts
StartPcmEnvelope
	movem.l	d1-d2/a0,-(sp)
	movea.l	X_D5CC(pc),a0
	clr.w	d1
	move.b	$D(a0),d1
	lea	X_D59C(pc),a0
	move.w	X_D5C0(pc),d0
	move.b	d1,(a0,d0.w)
	cmpi.b	#$FF,d1
	beq.s	.LCB52
	move.w	#$4,d0
	bsr.w	FindPcmRecord
	bcc.s	.LCB80
.LCB52
	move.w	X_D5C0(pc),d0
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	bsr.w	PcmWriteDelay
	lea	X_D58C(pc),a0
	move.w	X_D5C0(pc),d0
	move.b	(a0,d0.w),d1
	lsl.w	#$1,d1
	move.b	d1,$FF0001.l
	bsr.w	PcmWriteDelay
	clr.w	d0
	bra.s	.LCBD8
.LCB80
	clr.w	d0
	move.b	$4(a0),d0
	lea	X_D58C(pc),a0
	move.w	X_D5C0(pc),d1
	clr.w	d2
	move.b	(a0,d1.w),d2
	lsl.w	#$1,d2
	mulu.w	d2,d0
	lsr.w	#$8,d0
	move.w	X_D5C0(pc),d1
	ori.b	#$C0,d1
	move.b	d1,$FF000F.l
	bsr.w	PcmWriteDelay
	move.b	d0,$FF0001.l
	bsr.w	PcmWriteDelay
	lea	X_D5A4(pc),a0
	move.w	X_D5C0(pc),d0
	move.b	#$0,(a0,d0.w)
	lea	X_D5BD(pc),a0
	bset.b	d0,(a0)
	lsl.w	#$1,d0
	lea	X_D5AC(pc),a0
	move.w	#$0,(a0,d0.w)
	clr.w	d0
.LCBD8
	movem.l	(sp)+,d1-d2/a0
	rts
InitPcmDriver
	movem.l	d0/a0-a1,-(sp)
	lea	X_D362(pc),a0
	move.w	#$100,$0(a0)
	move.w	#$100,$2(a0)
	lea	X_D568(pc),a1
	move.w	#$1,d0
.LCBFA
	move.l	#$FFFFFFFF,(a1)+
	dbf	d0,.LCBFA
	move.b	#$FF,$210(a0)
	lea	X_D5D0(pc),a0
	move.w	#$7F,d0
.LCC12
	move.b	#$0,(a0)+
	dbf	d0,.LCC12
	lea	X_D650(pc),a0
	move.w	#$7F,d0
.LCC22
	move.b	#$0,(a0)+
	dbf	d0,.LCC22
	lea	X_D6D0(pc),a0
	move.w	#$7F,d0
.LCC32
	move.b	#$7F,(a0)+
	dbf	d0,.LCC32
	lea	X_D750(pc),a0
	move.w	#$7F,d0
.LCC42
	move.b	#$40,(a0)+
	dbf	d0,.LCC42
	lea	X_D7D0(pc),a0
	move.w	#$7F,d0
.LCC52
	move.b	#$40,(a0)+
	dbf	d0,.LCC52
	lea	X_D850(pc),a0
	move.w	#$7,d0
.LCC62
	move.b	#$FF,(a0)+
	dbf	d0,.LCC62
	lea	X_D858(pc),a0
	move.b	#$FF,(a0)
	lea	X_C4C0(pc),a0
	move.w	#$0,(a0)
	move.b	#$80,$FF000F.l
	bsr.w	PcmWriteDelay
	lea	$FF2001.l,a0
	move.w	#$EB,d0
.LCC90
	move.b	#$80,(a0)
	adda.l	#$2,a0
	nop
	nop
	nop
	nop
	dbf	d0,.LCC90
	move.w	#$F,d0
.LCCAA
	move.b	#$FF,(a0)
	adda.l	#$2,a0
	nop
	nop
	nop
	nop
	dbf	d0,.LCCAA
	lea	X_D570(pc),a0
	move.w	#$0,(a0)
	movem.l	(sp)+,d0/a0-a1
	rts
PlayPcmSample
	movem.l	d1-d7/a0,-(sp)
	move.b	X_D572(pc),d0
	move.w	#$7,d5
.LCCDA
	btst	d5,d0
	bne.s	.LCD1A
	dbf	d5,.LCCDA
	lea	X_D594(pc),a0
	move.w	#$FFFF,d5
	move.b	#$FF,d6
	clr.w	d0
.LCCF0
	cmp.b	(a0),d6
	bcs.s	.LCCF8
	move.w	d0,d5
	move.b	(a0),d6
.LCCF8
	adda.l	#$1,a0
	addi.w	#$1,d0
	cmpi.w	#$8,d0
	bne.s	.LCCF0
	cmpi.w	#$FFFF,d5
	bne.s	.LCD1A
	move.w	#$7,d0
	ori.b	#$1,ccr
	bra.w	.LCE00
.LCD1A
	lea	X_D5C0(pc),a0
	move.w	d5,(a0)
	lea	X_D572(pc),a0
	move.b	(a0),d0
	bset	d5,d0
	move.b	d0,$FF0011.l
	bsr.w	PcmWriteDelay
	lea	X_D366(pc),a0
	lsl.w	#$1,d1
	cmpi.w	#$FFFF,(a0,d1.w)
	bne.s	.LCD4C
	move.b	#$3,d0
	ori.b	#$1,ccr
	bra.w	.LCE00
.LCD4C
	move.w	X_D5C0(pc),d0
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	move.w	(a0,d1.w),d0
	lsr.w	#$8,d0
	move.b	d0,$FF000D.l
	bsr.w	PcmWriteDelay
	move.b	#$0,$FF0009.l
	bsr.w	PcmWriteDelay
	move.b	#$0,$FF000B.l
	bsr.w	PcmWriteDelay
	move.b	d2,$FF0005.l
	bsr.w	PcmWriteDelay
	lsr.w	#$8,d2
	move.b	d2,$FF0007.l
	bsr.w	PcmWriteDelay
	move.b	d3,$FF0001.l
	bsr.w	PcmWriteDelay
	move.b	d4,$FF0003.l
	bsr.w	PcmWriteDelay
	lea	X_D572(pc),a0
	move.w	X_D5C0(pc),d0
	move.b	(a0),d1
	bclr	d0,d1
	move.b	d1,(a0)
	move.b	d1,$FF0011.l
	bsr.w	PcmWriteDelay
	lea	X_D574(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea	X_D57C(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea	X_D584(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea	X_D58C(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea	X_D594(pc),a0
	move.b	#$0,(a0,d0.w)
	lea	X_D59C(pc),a0
	move.b	#$FF,(a0,d0.w)
.LCE00
	movem.l	(sp)+,d1-d7/a0
	rts
UpdatePcmFrequency
	movem.l	d1-d6/a0-a1,-(sp)
	movea.l	X_D5CC(pc),a0
	clr.w	d0
	clr.w	d1
	move.w	X_D5C0(pc),d2
	lea	X_D584(pc),a1
	move.b	(a1,d2.w),d3
	cmp.b	$3(a0),d3
	blt.s	.LCE2C
	sub.b	$3(a0),d3
	add.b	d3,d0
	bra.s	.LCE36
.LCE2C
	move.b	$3(a0),d3
	sub.b	(a1,d2.w),d3
	sub.b	d3,d0
.LCE36
	move.w	X_D5C2(pc),d2
	lea	X_D7D0(pc),a1
	clr.w	d3
	move.b	(a1,d2.w),d3
	cmpi.b	#$40,d3
	beq.s	.LCE86
	blt.s	.LCE68
	subi.b	#$40,d3
	lsl.w	#$2,d3
	clr.w	d4
	move.b	$7(a0),d4
	mulu.w	d4,d3
	add.b	d3,d1
	bcc.s	.LCE62
	addi.b	#$1,d0
.LCE62
	lsr.w	#$8,d3
	add.b	d3,d0
	bra.s	.LCE86
.LCE68
	move.b	#$40,d3
	sub.b	(a1,d2.w),d3
	lsl.w	#$2,d3
	clr.w	d4
	move.b	$8(a0),d4
	mulu.w	d4,d3
	sub.b	d3,d1
	bcc.s	.LCE82
	subi.b	#$1,d0
.LCE82
	lsr.w	#$8,d3
	sub.b	d3,d0
.LCE86
	clr.w	d2
	move.b	$4(a0),d2
	cmpi.b	#$0,d2
	beq.s	.LCEB6
	btst	#$7,d2
	bne.s	.LCEA4
	lsl.b	#$1,d2
	add.b	d2,d1
	bcc.s	.LCEB6
	addi.b	#$1,d0
	bra.s	.LCEB6
.LCEA4
	eori.b	#$FF,d2
	addi.b	#$1,d2
	lsl.b	#$1,d2
	sub.b	d2,d1
	bcc.s	.LCEB6
	subi.b	#$1,d0
.LCEB6
	ext.w	d0
	lsl.w	#$1,d0
	lea	PcmPitchTable(pc),a1
	move.w	(a1,d0.w),d2
	move.w	$2(a1,d0.w),d3
	sub.w	d2,d3
	mulu.w	d1,d3
	lsr.w	#$8,d3
	add.w	d3,d2
	move.w	X_D5C0(pc),d0
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	bsr.w	PcmWriteDelay
	move.b	d2,$FF0005.l
	bsr.w	PcmWriteDelay
	lsr.w	#$8,d2
	move.b	d2,$FF0007.l
	bsr.w	PcmWriteDelay
	clr.w	d0
	movem.l	(sp)+,d1-d6/a0-a1
	rts
	ori.l	#$880090,d0
	ori.l	#$A200AB,(a0)+
	ori.l	#$C000CB,-$29(a5,d0.w)
	dc.w	$00E4
	dc.w	$00F2
	btst	d0,d0
	movep.w	$11F(sp),d0
	dc.w	$0130
	bchg	d0,d3
	bchg.b	d0,(a6)
	bchg.b	d0,$180(a2)
	bclr.b	d0,(a6)
	bclr.b	d0,$1C8(sp)
	bset.b	d0,-(a3)
	dc.w	$0200,$021E
	dc.w	$023F
	andi.w	#$285,-(a1)
	andi.l	#$2D402FF,$32D(a3)
	bchg.b	d1,(a5)+
	bclr.b	d1,(a0)
	bset	d1,d7
	dc.w	$0400,$043D
	dc.w	$047D
	dc.w	$04C2
	movep.w	$557(a2),d2
	bclr.b	d2,$5FE(a0)
	addi.w	#$6BA,(a1)+
	btst.b	d3,-(a1)
	dc.w	$078D
PcmPitchTable
	dc.w	$0800,$087A,$08FB,$0983,$0A14,$0AAE,$0B50,$0BFD
	dc.w	$0CB3,$0D74,$0E41,$0F1A,$1000,$10F4,$11F6,$1307
	dc.w	$1429,$1556,$16A1,$17F9,$1966,$1AE9,$1C82,$1E34
	dc.w	$2000,$21E7,$23EB,$260E,$2851,$2AB7,$2D41,$2FF2
	dc.w	$32CC,$35D1,$3904,$3C68,$4000,$43CE,$47D6,$4C1C
	dc.w	$50A3,$556E,$5A82,$5FE4,$6598,$6BA3,$7209,$78D1
	dc.w	$8000
UpdatePcmPan
	movem.l	d1-d3/a0,-(sp)
	move.w	X_D5C0(pc),d0
	lea	X_D574(pc),a0
	clr.w	d3
	move.b	(a0,d0.w),d3
	lea	X_D6D0(pc),a0
	clr.w	d2
	move.b	(a0,d3.w),d2
	lsl.w	#$1,d2
	lea	X_D5D0(pc),a0
	clr.w	d1
	move.b	(a0,d3.w),d1
	move.w	#$0,d0
	bsr.w	FindPcmRecord
	bcs.w	.LD07A
	clr.w	d1
	move.b	$B(a0),d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	move.w	d3,d0
	lsr.w	#$4,d0
	lea	X_D850(pc),a0
	clr.w	d1
	move.b	(a0,d0.w),d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	clr.w	d1
	move.b	X_D858(pc),d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	lea	X_D750(pc),a0
	clr.w	d1
	move.b	(a0,d3.w),d1
	cmpi.b	#$40,d1
	bne.s	.LD034
	lsr.b	#$4,d2
	move.b	d2,d0
	lsl.b	#$4,d0
	or.b	d2,d0
	bra.s	.LD05C
.LD034
	bgt.s	.LD048
	move.b	d2,d0
	lsr.b	#$4,d0
	lsl.w	#$2,d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	andi.b	#$F0,d2
	or.b	d2,d0
	bra.s	.LD05C
.LD048
	move.b	d2,d0
	andi.b	#$F0,d0
	subi.w	#$40,d1
	lsl.w	#$2,d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	lsr.b	#$4,d2
	or.b	d2,d0
.LD05C
	move.w	X_D5C0(pc),d1
	ori.b	#$C0,d1
	move.b	d1,$FF000F.l
	bsr.w	PcmWriteDelay
	move.b	d0,$FF0003.l
	bsr.w	PcmWriteDelay
	clr.w	d0
.LD07A
	movem.l	(sp)+,d1-d3/a0
	rts
SelectPcmChannel
	movem.l	d1-d2/a0,-(sp)
	lea	X_D5CA(pc),a0
	move.w	#$0,(a0)
	movea.l	X_D5CC(pc),a0
	btst.b	#$0,$C(a0)
	beq.s	.LD0D2
	lea	X_D57C(pc),a0
	move.w	X_D5C8(pc),d0
	move.b	X_D572(pc),d1
	clr.w	d2
.LD0A6
	btst	d2,d1
	bne.s	.LD0C8
	cmp.b	(a0)+,d0
	bne.s	.LD0C8
	lea	X_D5C0(pc),a0
	move.w	d2,(a0)
	lea	X_D5CC(pc),a0
	clr.w	d0
	move.b	$C(a0),d0
	lea	X_D5CA(pc),a0
	move.w	d0,(a0)
	clr.w	d0
	bra.s	.LD11A
.LD0C8
	addi.w	#$1,d2
	cmpi.w	#$8,d2
	bne.s	.LD0A6
.LD0D2
	move.b	X_D572(pc),d0
	clr.w	d1
.LD0D8
	btst	d1,d0
	beq.s	.LD0E6
	lea	X_D5C0(pc),a0
	move.w	d1,(a0)
	clr.w	d0
	bra.s	.LD11A
.LD0E6
	addi.w	#$1,d1
	cmpi.w	#$8,d1
	bne.s	.LD0D8
	movea.l	X_D5CC(pc),a0
	move.b	$1(a0),d0
	lea	X_D594(pc),a0
	clr.w	d1
.LD0FE
	cmp.b	(a0)+,d0
	bhi.s	.LD10C
	lea	X_D5C0(pc),a0
	move.w	d1,(a0)
	clr.w	d0
	bra.s	.LD11A
.LD10C
	addi.w	#$1,d1
	cmpi.w	#$8,d1
	bne.s	.LD0FE
	ori.b	#$1,ccr
.LD11A
	movem.l	(sp)+,d1-d2/a0
	rts
FindPcmRecord
	movem.l	d1-d4/a1-a2,-(sp)
	lea	X_D568(pc),a1
	move.w	#$2,d2
.LD12C
	cmpi.l	#$FFFFFFFF,(a1)
	beq.s	.LD17A
	movea.l	(a1),a2
	move.b	(a2)+,d3
	lsl.w	#$8,d3
	move.b	(a2)+,d3
	clr.l	d4
	move.w	d3,d4
	lsl.l	#$2,d4
	add.l	a2,d4
	movea.l	d4,a0
.LD146
	cmp.b	(a2),d0
	bne.s	.LD160
	cmp.b	$1(a2),d1
	bne.s	.LD160
	move.b	$2(a2),d0
	lsl.w	#$8,d0
	move.b	$3(a2),d0
	andi.b	#$FE,ccr
	bra.s	.LD18E
.LD160
	clr.l	d4
	move.b	$2(a2),d4
	lsl.w	#$8,d4
	move.b	$3(a2),d4
	adda.l	d4,a0
	adda.l	#$4,a2
	subi.w	#$1,d3
	bne.s	.LD146
.LD17A
	adda.l	#$4,a1
	subi.w	#$1,d2
	bne.s	.LD12C
	move.w	#$3,d0
	ori.b	#$1,ccr
.LD18E
	movem.l	(sp)+,d1-d4/a1-a2
	rts
ControlPcmSampleAllocation
	move.l	a0,-(sp)
	or.w	d1,d1
	bne.s	.LD1A8
	lea	X_D362(pc),a0
	move.w	#$100,$2(a0)
	clr.w	d0
	bra.s	.LD1FE
.LD1A8
	cmpi.w	#$1,d1
	bne.s	.LD1BC
	lea	X_D362(pc),a0
	move.w	$0(a0),$2(a0)
	clr.w	d0
	bra.s	.LD1FE
.LD1BC
	cmpi.w	#$2,d1
	bne.s	.LD1F6
	lea	X_D362(pc),a0
	move.w	$2(a0),$0(a0)
	move.w	$2(a0),d0
	lea	X_D366(pc),a0
	move.w	#$FF,d1
.LD1D8
	cmpi.w	#$FFFF,(a0)
	beq.s	.LD1E8
	cmp.w	(a0),d0
	bhi.w	.LD1E8
	move.w	#$FFFF,(a0)
.LD1E8
	adda.l	#$2,a0
	dbf	d1,.LD1D8
	clr.w	d0
	bra.s	.LD1FE
.LD1F6
	move.w	#$5,d0
	ori.b	#$1,ccr
.LD1FE
	clr.w	d0
	movea.l	(sp)+,a0
	rts
SetPcmRecordDirectory
	movem.l	d1/a1,-(sp)
	lsl.w	#$2,d1
	lea	X_D568(pc),a1
	move.l	a0,(a1,d1.w)
	movem.l	(sp)+,d1/a1
	rts
LoadPcmRecordList
	movem.l	d1/a0-a1,-(sp)
	movea.l	a0,a1
.LD21E
	cmpi.w	#$FFFF,(a1)
	bne.s	.LD228
	clr.w	d0
	bra.s	.LD274
.LD228
	move.w	(a1),d0
	move.w	$2(a1),d1
	bsr.w	FindPcmRecord
	bcs.s	.LD270
	cmpi.w	#$2,(a1)
	bne.s	.LD268
	bsr.w	CopyPcmWaveData
	bcs.s	.LD274
	lea	X_D366(pc),a0
	move.w	$2(a1),d0
	lsl.w	#$1,d0
	move.w	X_D362(pc),d1
	move.w	d1,(a0,d0.w)
	add.w	X_D566(pc),d1
	or.b	d1,d1
	beq.s	.LD262
	andi.w	#$FF00,d1
	addi.w	#$100,d1
.LD262
	lea	X_D362(pc),a0
	move.w	d1,(a0)
.LD268
	adda.l	#$4,a1
	bra.s	.LD21E
.LD270
	ori.b	#$1,ccr
.LD274
	movem.l	(sp)+,d1/a0-a1
	rts
CopyPcmWaveData
	movem.l	d1-d2/a0-a1,-(sp)
	lea	X_D566(pc),a1
	move.w	d0,(a1)
	move.w	X_D362(pc),d1
	beq.s	.LD29E
	clr.w	d1
	sub.w	X_D362(pc),d1
	cmp.w	d0,d1
	bhi.s	.LD29E
	move.w	#$4,d0
	ori.b	#$1,ccr
	bra.s	.LD2F4
.LD29E
	move.w	X_D362(pc),d2
	lsr.w	#$8,d2
	lsr.w	#$4,d2
	ori.b	#$80,d2
	move.b	d2,$FF000F.l
	bsr.w	PcmWriteDelay
	move.w	X_D362(pc),d1
	andi.l	#$FFF,d1
	lsl.l	#$1,d1
	addi.l	#$FF2001,d1
	movea.l	d1,a1
.LD2C8
	move.b	(a0)+,d1
	move.b	d1,(a1)
	adda.l	#$2,a1
	cmpa.l	#$FF4001,a1
	bne.s	.LD2EE
	addi.b	#$1,d2
	move.b	d2,$FF000F.l
	bsr.w	PcmWriteDelay
	movea.l	#$FF2001,a1
.LD2EE
	dbf	d0,.LD2C8
	clr.w	d0
.LD2F4
	movem.l	(sp)+,d1-d2/a0-a1
	rts
SetPcmSoundLoopOffset
	movem.l	d1-d3/a0,-(sp)
	movem.l	d2-d3,-(sp)
	move.w	#$0,d0
	bsr.w	FindPcmRecord
	movem.l	(sp)+,d2-d3
	bcs.s	.LD33C
	cmpi.w	#$0,d3
	bne.s	.LD324
	move.b	d2,$6(a0)
	lsr.w	#$8,d2
	move.b	d2,$5(a0)
	clr.w	d0
	bra.s	.LD33C
.LD324
	move.b	$5(a0),d0
	lsl.w	#$8,d0
	move.b	$6(a0),d0
	add.w	d2,d0
	move.b	d0,$6(a0)
	lsr.w	#$8,d0
	move.b	d0,$5(a0)
	clr.w	d0
.LD33C
	movem.l	(sp)+,d1-d3/a0
	rts
WaitCdbiosReady
	move.w	#$80,d0
	jsr	$5F22.l
	bcs.s	WaitCdbiosReady
	rts
PcmCommandNoOp
	rts
PcmWriteDelay
	move.l	d0,-(sp)
	move.w	#$28,d0
.LD358
	nop
	dbf	d0,.LD358
	move.l	(sp)+,d0
	rts
	ori.b	#$0,d0
	dcb.b	512,0
	dc.w	$0000
	ori.b	#$0,d0
	ori.b	#$0,d0
	dc.w	$0000
	dc.w	$0000
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
	dcb.b	18,0
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	ori.b	#$0,d0
	dc.w	$0000
	dc.w	$0000
	ori.b	#$0,d0
	dcb.b	128,0
	dcb.b	128,0
	dcb.b	128,0
	dcb.b	128,0
	dcb.b	128,0
	ori.b	#$0,d0
	ori.b	#$0,d0
	dc.w	$0000
RunStarterDriver
	move.w	sr,-(sp)
	move.w	d0,$EC90.l
	move.l	d1,$EC92.l
	move.l	d2,$EC96.l
	move.l	d3,$EC9A.l
	move.l	d4,$EC9E.l
	jsr	(ClearSubCommWords).l
	jsr	(SyncMainFlag7).l
	jsr	(EnterTwoMegWordRamMode).l
	jsr	(WaitForSubWordRam).l
	move.w	#$0,$BC6E8.l
	move.w	#$2000,sr
	bclr.b	#$2,$FFFF8024.w
	jsr	(InstallDriverFrameCallback).l
	bset.b	#$2,$FFFF8024.w
	jsr	(ClearStarterWorkState).l
	move.w	#$0,d0
	jsr	(DispatchPcmCommandEntry).l
	move.l	#$400,-(sp)
	jsr	$10540.l
	jsr	(RunStarterSequence).l
	bclr.b	#$2,$FFFF8024.w
	moveq	#$1E,d0
	jsr	(SendMainCommand).l
	move.w	#$2700,sr
	movea.l	$EC96.l,a0
	move.l	$10ACC.l,(a0)
	bsr.w	ClearSubCommWords
	move.w	(sp)+,sr
	rts
RunStarterSequence
	move.w	#$0,$BC6E8.l
	bsr.w	CopyScreensToWordRam
	bsr.w	LoadStarterPcmSamples
	bsr.w	StarterSequenceNoOp
	bsr.w	X_1055C
	move.l	#$400,-(sp)
	bsr.w	X_10540
	bsr.w	SendMainFontMap
	bsr.w	AnimateEASportsLogo
	bsr.w	ShowHighScoreScreen
	bsr.w	RunStarterFilm
	move.w	$EC90.l,-(sp)
	bsr.w	X_104F6
	move.l	#$4000200,-(sp)
	bsr.w	X_10540
	bsr.w	CopyScreensToWordRam
	bsr.w	RunCredits
	bsr.w	ClearStarterPaletteAndWait
	rts
CopyScreensToWordRam
	movem.l	d0-d7/a0-a6,-(sp)
	bclr.b	#$2,$FFFF8024.w
	lea	$80000.l,a0
	move.l	a0,$10984.l
	lea	$10BD8.l,a1
	lea	$15246.l,a2
	bsr.w	CopyBytesToEnd
	move.l	a0,$1094C.l
	lea	$15246.l,a1
	lea	$15942.l,a2
	bsr.w	CopyBytesToEnd
	move.l	a0,$109D8.l
	lea	$15942.l,a1
	lea	$16C62.l,a2
	bsr.w	CopyBytesToEnd
	move.l	a0,$109DC.l
	lea	$16C62.l,a1
	lea	$17402.l,a2
	bsr.w	CopyBytesToEnd
	move.l	a0,$109E0.l
	lea	$17402.l,a1
	lea	$1756C.l,a2
	bsr.w	CopyBytesToEnd
	move.l	a0,$10BD0.l
	bset.b	#$2,$FFFF8024.w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
CopyBytesToEnd
	move.b	(a1)+,(a0)+
	cmpa.l	a2,a1
	blt.s	CopyBytesToEnd
	rts
LoadStarterPcmSamples
	movem.l	d0-d7/a0-a6,-(sp)
	bclr.b	#$2,$FFFF8024.w
	move.w	#$2,d0
	moveq	#$2,d1
	bsr.w	DispatchPcmCommandEntry
	lea	$1756C.l,a0
	move.w	#$0,d1
	move.w	#$5,d0
	bsr.w	DispatchPcmCommandEntry
	lea	(.LDA24).l,a0
	move.w	#$6,d0
	bsr.w	DispatchPcmCommandEntry
	bset.b	#$2,$FFFF8024.w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.LDA24
	ori.b	#$0,d2
	dc.w	$FFFF
AnimateEASportsLogo
	movem.l	d0-d7/a0-a6,-(sp)
	andi.b	#$EF,$BC6E8.l
	bsr.w	SendMainCommand02Inline
	dc.w	$0000,$FC00,$E000,$C000,$B000,$0006,$0020,$0000
	dc.w	$0CCC
	bsr.w	SendMainCommand03
	moveq	#$1,d4
	move.w	d4,$10AF0.l
	movea.l	$109DC.l,a0
	lea	$8(a0),a2
	bsr.w	SendMainLoadTiles
	lea	$BA850.l,a1
	adda.l	(a0),a0
	moveq	#$1F,d0
.LDA70
	move.l	(a0)+,(a1)+
	dbf	d0,.LDA70
	move.w	#$18,$BA8D0.l
	move.w	#$F0,d6
	move.w	#$A,$10B6C.l
	clr.w	$10B6E.l
	lea	(X_DB78).l,a3
.LDA96
	bsr.w	AnimateEASportsLogoStep
	bsr.w	WaitNextDriverFrame
	bsr.w	ReadStarterPads
	moveq	#$0,d1
	tst.w	d1
	dbne	d6,.LDA96
	bsr.w	SendMainCommand02Inline
	dc.w	$0000,$FC00,$E000,$C000,$B000,$0006,$0020,$0000
	dc.w	$0CCC
	movem.l	(sp)+,d0-d7/a0-a6
	rts
AnimateEASportsLogoStep
	movem.l	d0-d6/a0-a2,-(sp)
	btst.b	#$1,$BC6E8.l
	bne.w	.LDB72
	cmpi.w	#$10,$10B6E.l
	bgt.w	.LDB72
	subq.w	#$1,$10B6C.l
	bpl.w	.LDB72
	move.w	(a3)+,$10B6C.l
	move.w	(a3)+,d0
	cmpi.w	#$0,d0
	bne.w	.LDB20
	move.w	#$0,-(sp)
	move.l	#$0,-(sp)
	bsr.w	X_1041A
	move.w	#$1,d0
	bsr.w	WaitDriverFrames
	move.w	#$0,-(sp)
	move.l	#$0,-(sp)
	bsr.w	X_1041A
.LDB20
	tst.w	-$2(a3)
	bpl.w	.LDB2A
	subq.w	#$4,a3
.LDB2A
	addq.w	#$1,$10B6E.l
	bsr.w	BeginStarterSpriteList
	movea.l	$109DC.l,a0
	move.w	$10B6E.l,d2
	move.w	$10AF0.l,d4
.LDB46
	move.w	#$80,d0
	move.w	#$80,d1
	cmpi.w	#$3,d2
	blt.w	.LDB5A
	move.w	#$88,d1
.LDB5A
	bsr.w	AppendStarterSprites
	subq.w	#$1,d2
	bne.s	.LDB46
	bsr.w	FinishStarterSpriteList
	bsr.w	CopyStarterSpriteData
	bset.b	#$1,$BC6E8.l
.LDB72
	movem.l	(sp)+,d0-d6/a0-a2
	rts
	ori.b	#$0,(a6)+
	ori.b	#$1,(a6)+
	ori.b	#$1,(a6)+
	ori.b	#$1,d4
	dc.w	$0006,$FFFF
ShowHighScoreScreen
	andi.b	#$9C,$BC6E8.l
	bsr.w	SendMainCommand03
	move.w	#$1,d4
	move.w	d4,$10AF0.l
	bsr.w	SendMainCommand0DInline
	dc.w	$0008,$F800,$0100,$0000
	movea.l	$109D8.l,a2
	lea	(a2),a0
	lea	(a2),a1
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	moveq	#$F,d5
	bsr.w	SendMainCommand08
	movea.l	#$107D0,a0
	movea.l	#$107CC,a1
	movea.l	#$107CA,a2
	lea	$10AF0.l,a3
	movea.l	$109E0.l,a4
	bsr.w	InitStarterAnimation
	movea.l	#$10822,a0
	movea.l	#$1081E,a1
	movea.l	#$1081C,a2
	lea	$10AF0.l,a3
	movea.l	$109E0.l,a4
	bsr.w	InitStarterAnimation
	movea.l	#$10874,a0
	movea.l	#$10870,a1
	movea.l	#$1086E,a2
	lea	$10AF0.l,a3
	movea.l	$109E0.l,a4
	bsr.w	InitStarterAnimation
	movea.l	#$108C6,a0
	movea.l	#$108C2,a1
	movea.l	#$108C0,a2
	lea	$10AF0.l,a3
	movea.l	$109E0.l,a4
	bsr.w	InitStarterAnimation
	move.w	#$20,$BA8D0.l
	move.w	#$B4,d7
.LDC60
	bsr.w	ShowHighScoreScreenStep
	bsr.w	WaitNextDriverFrame
	bsr.w	ReadStarterPads
	tst.w	d1
	dbne	d7,.LDC60
	bsr.w	ClearStarterPaletteAndWait
	rts
ShowHighScoreScreenStep
	btst.b	#$1,$BC6E8.l
	bne.w	.LDD20
	bsr.w	BeginStarterSpriteList
	move.w	$10AF0.l,d4
	movea.l	#$107CA,a2
	movea.l	#$107D0,a3
	movea.l	#$107CC,a4
	movea.l	$109E0.l,a0
	bsr.w	StepStarterAnimation
	move.w	$10AF0.l,d4
	movea.l	#$1081C,a2
	movea.l	#$10822,a3
	movea.l	#$1081E,a4
	movea.l	$109E0.l,a0
	bsr.w	StepStarterAnimation
	move.w	$10AF0.l,d4
	movea.l	#$1086E,a2
	movea.l	#$10874,a3
	movea.l	#$10870,a4
	movea.l	$109E0.l,a0
	bsr.w	StepStarterAnimation
	move.w	$10AF0.l,d4
	movea.l	#$108C0,a2
	movea.l	#$108C6,a3
	movea.l	#$108C2,a4
	movea.l	$109E0.l,a0
	bsr.w	StepStarterAnimation
	bsr.w	FinishStarterSpriteList
	bsr.w	CopyStarterSpriteData
	bset.b	#$1,$BC6E8.l
.LDD20
	rts
RunCredits
	andi.b	#$9C,$BC6E8.l
	bsr.w	SendMainCommand02Inline
	dc.w	$0000,$FC00,$E000,$C000,$B000,$0006,$0020,$0000
	dc.w	$0CCC
	bsr.w	SendMainCommand03
	bsr.w	ReadMainHvCounter
	move.w	$10BCE.l,$10B2A.l
	move.w	$10BCE.l,$10B2C.l
	moveq	#$1C,d0
	bsr.w	SendMainCommand
	clr.w	$10B22.l
	bsr.w	SendMainCommand0BInline
	dc.w	$0006,$FF00,$0000
	move.l	#$80,d0
	moveq	#$20,d1
	move.l	#$7FF,d2
	jsr	(SendMainCommand07).l
	bsr.w	SendMainCommand0BInline
	dc.w	$0006,$FE00,$0000
	move.l	#$80,d0
	moveq	#$20,d1
	move.l	#$7FF,d2
	jsr	(SendMainCommand07).l
	moveq	#$1C,d4
	bsr.w	SendMainCommand0BInline
	dc.w	$0006,$FE00,$1300
	movea.l	$10984.l,a1
	adda.l	$4(a1),a1
	lea	$BC6EC.l,a2
	clr.w	d0
	moveq	#$13,d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	sub.w	d1,d3
	moveq	#$0,d5
	jsr	(SendMainCommand08).l
	bsr.w	SendMainCommand0BInline
	dc.w	$0006,$FD00,$0000
	movea.l	$10984.l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	moveq	#$F,d5
	jsr	(SendMainCommand08).l
	move.w	d4,$10AFE.l
	movea.l	$1094C.l,a2
	addq.l	#$8,a2
	jsr	(SendMainLoadTiles).l
	bsr.w	SendMainCommand0E
	bsr.w	SendMainCommand0BInline
	dc.w	$0006,$FF00,$0000
	lea	$25F0E.l,a1
	bsr.w	DrawCreditsLines
	addi.w	#$40,$10B22.l
	clr.w	$10B20.l
	clr.w	$10B24.l
	move.w	#$5,$10B28.l
	move.w	#$20,$BA8D0.l
	move.w	#$F0,d3
.LDE52
	bsr.w	WaitCreditsFrame
	dbf	d3,.LDE52
	bsr.w	SendMainCommand0BInline
	dc.w	$0006,$FF00,$0000
	lea	$25F36.l,a1
.LDE6A
	bsr.w	DrawCreditsLines
	adda.w	(a1),a1
	moveq	#$3F,d4
.LDE72
	bsr.w	WaitCreditsFrame
	bsr.w	WaitCreditsFrame
	addq.w	#$1,$10B22.l
	dbf	d4,.LDE72
	moveq	#$78,d4
.LDE86
	bsr.w	WaitCreditsFrame
	dbf	d4,.LDE86
	tst.w	$2(a1)
	bpl.s	.LDE6A
	rts
DrawCreditsLines
	move.w	$10B22.l,d0
	asr.w	#$3,d0
	addi.w	#$1C,d0
	andi.w	#$1F,d0
	move.w	d0,$10B0C.l
	move.w	d0,-(sp)
	clr.w	$10B0A.l
	moveq	#$20,d0
	moveq	#$9,d1
	move.w	#$7FF,d2
	jsr	(SendMainCommand07).l
	move.w	(sp)+,$10B0C.l
.LDEC8
	move.w	(a1),d0
	asr.w	#$1,d0
	neg.w	d0
	addi.w	#$10,d0
	move.w	d0,$10B0A.l
	bsr.w	SendMainCommand0B
	addq.w	#$1,$10B0C.l
	andi.w	#$1F,$10B0C.l
	tst.w	$2(a1)
	bpl.s	.LDEC8
	rts
WaitCreditsFrame
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	$10AE0.l,d0
.LDEFC
	cmp.w	$10AE0.l,d0
	beq.s	.LDEFC
	bsr.w	UpdateCreditsScroll
	jsr	(ReadStarterPads).l
	btst	#$7,d1
	movem.l	(sp)+,d0-d7/a0-a6
	beq.w	X_DFAA
	addq.l	#$4,sp
	rts
UpdateCreditsScroll
	lea	$BA450.l,a0
	move.w	$10B22.l,(a0)
	moveq	#$1D,d0
	bsr.w	SendMainCommand
	move.w	#$DF,d0
	lea	$BC368.l,a0
	moveq	#$7F,d1
	add.w	$10B20.l,d1
.LDF42
	clr.l	(a0)+
	cmpi.w	#$48,d0
	ble.w	.LDF50
	move.w	d1,-$2(a0)
.LDF50
	dbf	d0,.LDF42
	bset.b	#$0,$BC6E8.l
	bset.b	#$6,$BC6E8.l
	cmpi.w	#$B4,$10B20.l
	blt.w	.LDF9E
	subq.w	#$1,$10B24.l
	bpl.w	.LDFAA
	move.w	#$12C,d0
	jsr	(StarterRandomRange).l
	move.w	d0,$10B24.l
	andi.w	#$7,d0
	addq.w	#$4,d0
	move.w	d0,$10B28.l
	move.w	#$FEB4,$10B20.l
.LDF9E
	move.w	$10B28.l,d0
	add.w	d0,$10B20.l
.LDFAA
	rts
WaitNextDriverFrame
	move.w	d0,-(sp)
	move.w	$10AE2.l,d0
.LDFB4
	cmp.w	$10AE0.l,d0
	beq.s	.LDFB4
	move.w	$10AE0.l,$10AE2.l
	move.w	(sp)+,d0
	rts
BeginStarterSpriteList
	movea.l	#$BA8D2,a5
	movea.l	#$BAF16,a6
	moveq	#$1,d6
	rts
AppendStarterSprites
	cmpi.w	#$50,d6
	bgt.w	X_D9E2
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
.LE002
	move.w	$2(a0),(a6)
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
	beq.w	.LE034
	addq.l	#$8,a0
	dbf	d3,.LE002
.LE034
	movem.l	(sp)+,d0-d5/a0
	rts
FinishStarterSpriteList
	moveq	#-1,d0
	add.w	d6,d0
	bne.w	.LE048
	moveq	#$1,d0
	clr.l	(a6)+
	clr.l	(a6)+
.LE048
	cmpi.w	#$50,d0
	ble.w	.LE052
	moveq	#$50,d0
.LE052
	asl.w	#$3,d0
	lea	$BAF16.l,a6
	clr.b	-$5(a6,d0.w)
	lsr.w	#$1,d0
	move.w	d0,$BB1E6.l
	move.l	a5,$BAF12.l
	rts
CopyStarterSpriteData
	movea.l	#$BC6F0,a0
	lea	$BA8D2.l,a1
	move.l	#$80000,d1
.LE080
	cmpa.l	$BAF12.l,a1
	beq.w	.LE0B0
	move.l	(a1),d0
	cmp.l	d1,d0
	bgt.w	.LE0AC
	movea.l	d0,a2
	move.w	$4(a1),d0
	subq.w	#$1,d0
	move.l	a0,(a1)
.LE09C
	move.w	(a2)+,(a0)+
	cmpa.l	#$C0000,a0
	bge.w	.LE0B8
	dbf	d0,.LE09C
.LE0AC
	addq.l	#$8,a1
	bra.s	.LE080
.LE0B0
	move.l	a0,$10AC8.l
	rts
.LE0B8
	bra.s	.LE0B8
StepStarterAnimation
	movea.l	(a4),a1
	move.w	$2(a1),d2
	subq.w	#$1,(a2)
	bpl.w	.LE0F2
	addq.l	#$4,a1
	move.w	(a1),d0
	bpl.w	.LE0EA
	move.w	$2(a1),d0
	beq.w	.LE0DA
	bmi.w	.LE0E6
.LE0DA
	move.l	a3,(a4)
	addq.l	#$4,(a4)
	movea.l	(a4),a1
	move.w	(a1),d0
	bra.w	.LE0EA
.LE0E6
	subq.l	#$4,a1
	move.w	(a1),d0
.LE0EA
	move.w	d0,(a2)
	move.w	$2(a1),d2
	move.l	a1,(a4)
.LE0F2
	tst.w	d2
	bmi.w	.LE100
	move.w	(a3)+,d0
	move.w	(a3),d1
	bsr.w	AppendStarterSprites
.LE100
	rts
InitStarterAnimation
	move.w	d4,(a3)
	move.l	a0,(a1)
	addq.l	#$4,(a1)
	move.w	$4(a0),(a2)
	movea.l	a4,a0
	lea	$8(a0),a2
	bsr.w	SendMainLoadTiles
	rts
WaitDriverFrames
	neg.w	d0
	move.w	d0,$10AE0.l
.LE120
	tst.w	$10AE0.l
	bmi.s	.LE120
	rts
SendMainLoadTiles
	movem.l	d0-d1/a0,-(sp)
	lea	$BA450.l,a0
	move.l	d4,(a0)+
	move.l	a2,(a0)
	moveq	#$4,d0
	bsr.w	SendMainCommand
	lea	$BA450.l,a0
	move.l	(a0),d4
	movem.l	(sp)+,d0-d1/a0
	rts
ClearStarterPaletteAndWait
	movem.l	d0/a0,-(sp)
	lea	$BA850.l,a0
	moveq	#$1F,d0
.LE158
	move.l	(a0),-(sp)
	clr.l	(a0)+
	dbf	d0,.LE158
	move.w	#$18,$BA8D0.l
	bsr.w	WaitStarterTransfer
	moveq	#$1F,d0
.LE16E
	move.l	(sp)+,-(a0)
	dbf	d0,.LE16E
	movem.l	(sp)+,d0/a0
	rts
WaitStarterTransfer
	move.w	$BC6E8.l,-(sp)
	bclr.b	#$4,$BC6E8.l
.LE188
	tst.w	$BA8D0.l
	bpl.s	.LE188
	move.w	(sp)+,$BC6E8.l
	rts
ReadStarterPads
	movem.l	d0/d2-d4,-(sp)
	clr.w	-(sp)
	moveq	#$3,d4
.LE1A0
	bsr.w	ReadStarterPad
	bsr.w	RepeatStarterPad
	or.w	d1,(sp)
	dbf	d4,.LE1A0
	move.w	(sp)+,d1
	movem.l	(sp)+,d0/d2-d4
	rts
RepeatStarterPad1
	tst.w	d3
	beq.w	.LE1E4
	tst.w	d2
	bne.w	.LE1DC
	subq.b	#$1,$10B1C.l
	bpl.w	.LE1E4
	move.b	#$4,$10B1C.l
	move.w	d3,d1
	andi.w	#$F,d1
	rts
.LE1DC
	move.b	#$F,$10B1C.l
.LE1E4
	rts
RepeatStarterPad2
	tst.w	d3
	beq.s	X_E1E4
	tst.w	d2
	bne.w	.LE208
	subq.b	#$1,$10B1D.l
	bpl.s	X_E1E4
	move.b	#$4,$10B1D.l
	move.w	d3,d1
	andi.w	#$F,d1
	rts
.LE208
	move.b	#$F,$10B1D.l
	rts
RepeatStarterPad
	tst.w	d3
	beq.s	X_E1E4
	movem.l	a0,-(sp)
	lea	$10B1C.l,a0
	tst.w	d2
	bne.w	.LE23E
	subq.b	#$1,(a0,d4.w)
	bpl.w	.LE244
	move.b	#$4,(a0,d4.w)
	move.w	d3,d1
	andi.w	#$F,d1
	bra.w	.LE244
.LE23E
	move.b	#$F,(a0,d4.w)
.LE244
	movem.l	(sp)+,a0
	rts
ReadStarterPad
	move.w	$FFFF801C.w,d0
	move.b	d0,$10B15.l
	lsr.w	#$8,d0
	move.b	d0,$10B14.l
	move.w	$FFFF801E.w,d0
	move.b	d0,$10B17.l
	lsr.w	#$8,d0
	move.b	d0,$10B16.l
	moveq	#$0,d0
	movem.l	a0,-(sp)
	lea	$10B14.l,a0
	move.b	(a0,d4.w),d0
	bsr.w	DecodeStarterPadDirection
	moveq	#$0,d2
	move.b	$4(a0,d4.w),d2
	move.b	d1,$4(a0,d4.w)
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	movem.l	(sp)+,a0
	rts
ReadStarterPad1
	move.w	$FFFF801C.w,d0
	lsr.w	#$8,d0
	move.b	d0,$10B14.l
	bsr.w	DecodeStarterPadDirection
	move.b	$10B18.l,d2
	move.b	d1,$10B18.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadStarterPad2
	move.w	$FFFF801C.w,d0
	move.b	d0,$10B15.l
	bsr.w	DecodeStarterPadDirection
	move.b	$10B19.l,d2
	move.b	d1,$10B19.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
DecodeStarterPadDirection
	clr.w	d1
	move.b	d0,d1
	movem.l	d1/a0,-(sp)
	andi.w	#$F0,d0
	andi.w	#$F,d1
	lea	(.LE300).l,a0
	move.b	(a0,d1.w),d1
	or.w	d1,d0
	movem.l	(sp)+,d1/a0
	rts
.LE300
	dc.w	$0800
	dc.w	$0408
	dc.w	$0607,$0508
	dc.w	$0201,$0308
	dc.w	$0808
	dc.w	$0808
SendMainCommand03
	movem.l	d0,-(sp)
	moveq	#$3,d0
	bsr.w	SendMainCommand
	movem.l	(sp)+,d0
	rts
SendMainCommand02Inline
	movea.l	(sp),a0
	lea	$BA450.l,a1
	moveq	#$8,d0
.LE32A
	move.w	(a0)+,(a1)+
	dbf	d0,.LE32A
	move.l	a0,(sp)
	moveq	#$2,d0
	bra.w	SendMainCommand
SendMainCommand00
	movem.l	d0/d2-d3/a1,-(sp)
	lea	$BA450.l,a1
	move.w	d0,(a1)+
	move.w	d1,(a1)+
	move.l	a0,(a1)
	moveq	#$0,d0
	bsr.w	SendMainCommand
	movem.l	(sp)+,d0/d2-d3/a1
	rts
SendMainCommand01
	movem.l	d0/d2-d3/a1,-(sp)
	lea	$BA450.l,a1
	move.w	d0,(a1)+
	move.w	d1,(a1)+
	move.l	a0,(a1)
	moveq	#$1,d0
	bsr.w	SendMainCommand
	movem.l	(sp)+,d0/d2-d3/a1
	rts
SendMainCommand
	move.w	d0,$FFFF8020.w
	bset.b	#$6,$FFFF800F.w
.LE37A
	btst.b	#$6,$FFFF800E.w
	beq.s	.LE37A
	bclr.b	#$6,$FFFF800F.w
	move.w	#$0,$FFFF8020.w
	bclr.b	#$1,$FFFF8024.w
	bsr.w	SyncMainWordRamPhase0
	bsr.w	GiveWordRamToMain
	bsr.w	SyncMainWordRamPhase1
.LE3A0
	btst.b	#$0,$FFFF8014.w
	beq.s	.LE3A0
	bset.b	#$1,$FFFF8024.w
	bsr.w	SyncMainWordRamPhase2
	bsr.w	WaitForSubWordRam
	bsr.w	SyncMainWordRamPhase3
	rts
ClearSubCommWords
	move.w	#$0,$FFFF8020.w
	move.w	#$0,$FFFF8022.w
	move.w	#$0,$FFFF8024.w
	move.w	#$0,$FFFF8026.w
	move.w	#$0,$FFFF8028.w
	move.w	#$0,$FFFF802A.w
	move.w	#$0,$FFFF802C.w
	move.w	#$0,$FFFF802E.w
	rts
EnterTwoMegWordRamMode
	bclr.b	#$2,$FFFF8003.w
	bne.s	EnterTwoMegWordRamMode
	rts
SyncMainFlag7
	btst.b	#$7,$FFFF800E.w
	beq.s	SyncMainFlag7
	bset.b	#$7,$FFFF800F.w
.LE406
	btst.b	#$7,$FFFF800E.w
	bne.s	.LE406
	bclr.b	#$7,$FFFF800F.w
	rts
WaitForSubWordRam
	btst.b	#$1,$FFFF8003.w
	beq.s	WaitForSubWordRam
	btst.b	#$0,$FFFF8003.w
	bne.s	WaitForSubWordRam
	bset.b	#$1,$10912.l
	rts
GiveWordRamToMain
	bset.b	#$0,$FFFF8003.w
	bclr.b	#$1,$10912.l
	rts
ClearStarterWorkState
	lea	$10ADA.l,a0
.LE446
	clr.b	(a0)+
	cmpa.l	#$10BD8,a0
	blt.s	.LE446
	rts
StarterSequenceNoOp
	rts
InstallDriverFrameCallback
	jsr	(SyncMainFlag7).l
	movem.l	a0-a1,-(sp)
	movea.l	$EC96.l,a0
	move.l	(a0),$10ACC.l
	move.l	#$EA8A,(a0)
	bset.b	#$2,$FFFF8033.w
	movem.l	(sp)+,a0-a1
	rts
StarterRandomSigned
	move.w	d0,-(sp)
	add.w	d0,d0
	bsr.w	StarterRandomRange
	sub.w	(sp)+,d0
	rts
StarterRandomRange
	movem.l	d0-d2,-(sp)
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
SendMainCommand06
	movem.l	d0/a0,-(sp)
	moveq	#$6,d0
	bsr.w	SendMainCommand
	movem.l	(sp)+,d0/a0
	rts
SendMainCommand07
	movem.l	d0-d3/a0,-(sp)
	lea	$BA450.l,a0
	move.w	d0,(a0)+
	move.w	d1,(a0)+
	move.w	d2,(a0)+
	move.w	$10B0A.l,(a0)+
	move.w	$10B0C.l,(a0)+
	move.w	$10B10.l,(a0)+
	moveq	#$7,d0
	bsr.w	SendMainCommand
	lea	$BA450.l,a0
	move.w	(a0)+,$10B0A.l
	move.w	(a0)+,$10B0C.l
	move.w	(a0)+,$10B10.l
	movem.l	(sp)+,d0-d3/a0
	rts
SendMainCommand08
	movem.l	d0-d3/d5-d6/a0-a3/a6,-(sp)
	lea	$BA450.l,a6
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
	bsr.w	SendMainCommand
	lea	$BA450.l,a6
	move.w	(a6)+,d4
	move.w	(a6)+,$10B0E.l
	move.w	(a6)+,$10B0A.l
	move.w	(a6)+,$10B0C.l
	move.w	(a6)+,$10B10.l
	movem.l	(sp)+,d0-d3/d5-d6/a0-a3/a6
	rts
SendMainCommand0BInline
	movem.l	d0/a1-a2,-(sp)
	movea.l	$C(sp),a1
	lea	$BA450.l,a2
	move.w	$10B0E.l,(a2)+
	move.w	$10B10.l,(a2)+
	move.w	$10B0A.l,(a2)+
	move.w	$10B0C.l,(a2)+
	move.w	$10AFE.l,(a2)+
	move.w	(a1),d0
	lsr.w	#$1,d0
	subq.w	#$1,d0
.LE5AE
	move.w	(a1)+,(a2)+
	dbf	d0,.LE5AE
	move.l	a1,$C(sp)
	moveq	#$B,d0
	bsr.w	SendMainCommand
	lea	$BA450.l,a1
	move.w	(a1)+,$10B0E.l
	move.w	(a1)+,$10B10.l
	move.w	(a1)+,$10B0A.l
	move.w	(a1),$10B0C.l
	movem.l	(sp)+,d0/a1-a2
	rts
SendMainCommand0C
	movem.l	d0-d3/a0/a2-a3,-(sp)
	lea	$BA450.l,a2
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
.LE622
	move.w	(a1)+,(a2)+
	dbf	d0,.LE622
	moveq	#$C,d0
	bsr.w	SendMainCommand
	lea	$BA450.l,a2
	move.w	(a2)+,$10B0E.l
	move.w	(a2)+,$10B0A.l
	move.w	(a2)+,$10B0C.l
	move.w	(a2)+,$10B12.l
	move.w	(a2),$10B10.l
	movem.l	(sp)+,d0-d3/a0/a2-a3
	rts
SendMainCommand0DInline
	movem.l	d0/a1-a2,-(sp)
	movea.l	$C(sp),a1
	lea	$BA450.l,a2
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
.LE69C
	move.w	(a1)+,(a2)+
	dbf	d0,.LE69C
	moveq	#$D,d0
	bsr.w	SendMainCommand
	move.l	a1,$C(sp)
	lea	$BA450.l,a1
	move.w	(a1)+,$10B0E.l
	move.w	(a1)+,$10B0A.l
	move.w	(a1)+,$10B0C.l
	move.w	(a1)+,$10B12.l
	move.w	(a1),$10B10.l
	movem.l	(sp)+,d0/a1-a2
	rts
DoubleStarterColorComponents
	movem.l	d1-d4,-(sp)
	clr.w	d4
	moveq	#$2,d3
	moveq	#$E,d2
.LE6E0
	move.w	d0,d1
	and.w	d2,d1
	beq.w	.LE6EE
	add.w	d2,d1
	and.w	d2,d1
	or.w	d1,d4
.LE6EE
	asl.w	#$4,d2
	dbf	d3,.LE6E0
	move.w	d4,d0
	movem.l	(sp)+,d1-d4
	rts
SendMainCommand0E
	movem.l	d0/a0-a1,-(sp)
	lea	$BA450.l,a0
	lea	$10AE4.l,a1
.LE70C
	move.w	(a1)+,(a0)+
	cmpa.l	#$10B08,a1
	blt.s	.LE70C
	moveq	#$E,d0
	bsr.w	SendMainCommand
	movem.l	(sp)+,d0/a0-a1
	rts
AppendStarterTextInline
	movem.l	a1,-(sp)
	movem.l	$4(sp),a1
	bsr.w	AppendStarterText
	movem.l	a1,$4(sp)
	movem.l	(sp)+,a1
	rts
AppendStarterText
	movem.l	d0/a0,-(sp)
	lea	$2(a3),a0
	move.w	(a3),d0
	subq.w	#$3,d0
	bmi.w	.LE754
.LE74C
	addq.l	#$1,a0
	tst.b	(a0)
	dbeq	d0,.LE74C
.LE754
	move.w	(a1)+,d0
	subq.w	#$3,d0
	bmi.w	.LE77A
.LE75C
	move.b	(a1)+,(a0)+
	bne.w	.LE764
	subq.l	#$1,a0
.LE764
	dbf	d0,.LE75C
	move.l	a0,d0
	btst	#$0,d0
	beq.w	.LE776
	clr.b	(a0)+
	addq.l	#$1,d0
.LE776
	sub.l	a3,d0
	move.w	d0,(a3)
.LE77A
	movem.l	(sp)+,d0/a0
	rts
MeasureStarterText
	movem.l	d1-d2/a0-a1,-(sp)
	clr.w	d0
	clr.w	d1
	move.w	(a1)+,d2
	subq.w	#$2,d2
	bra.w	.LE7A8
.LE790
	move.b	(a1)+,d1
	beq.w	.LE7A8
	bpl.w	.LE7A4
	subq.w	#$2,d2
	addq.l	#$2,a1
	clr.w	d0
	bra.w	.LE7A8
.LE7A4
	bsr.w	MeasureStarterCharacter
.LE7A8
	dbf	d2,.LE790
	movem.l	(sp)+,d1-d2/a0-a1
	rts
MeasureStarterCharacter
	ext.w	d1
	beq.w	X_E1E4
	cmpi.w	#$61,d1
	blt.w	.LE7CC
	cmpi.w	#$7A,d1
	bgt.w	.LE7CC
	addi.w	#$FFE0,d1
.LE7CC
	addq.w	#$1,d0
	movea.l	#$10570,a0
	tst.b	-$20(a0,d1.w)
	bmi.w	X_E1E4
	addq.w	#$1,d0
	rts
ReadMainHvCounter
	movem.l	d0,-(sp)
	moveq	#$F,d0
	bsr.w	SendMainCommand
	move.w	$BA450.l,$10BCE.l
	movem.l	(sp)+,d0
	rts
SendMainCommand10Inline
	movem.l	d0-d1/a0-a1,-(sp)
	lea	$BA450.l,a0
	move.l	d4,(a0)+
	move.l	a2,(a0)+
	movea.l	$10(sp),a1
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	moveq	#$10,d0
	bsr.w	SendMainCommand
	lea	$BA450.l,a0
	move.l	(a0),d4
	movem.l	(sp)+,d0-d1/a0-a1
	addq.l	#$8,(sp)
	rts
SyncMainWordRamPhase0
	btst.b	#$0,$FFFF8018.w
	beq.s	SyncMainWordRamPhase0
	bset.b	#$0,$FFFF8028.w
.LE834
	btst.b	#$0,$FFFF8018.w
	bne.s	.LE834
	bclr.b	#$0,$FFFF8028.w
	rts
SyncMainWordRamPhase1
	btst.b	#$1,$FFFF8018.w
	beq.s	SyncMainWordRamPhase1
	bset.b	#$1,$FFFF8028.w
.LE852
	btst.b	#$1,$FFFF8018.w
	bne.s	.LE852
	bclr.b	#$1,$FFFF8028.w
	rts
SyncMainWordRamPhase2
	btst.b	#$2,$FFFF8018.w
	beq.s	SyncMainWordRamPhase2
	bset.b	#$2,$FFFF8028.w
.LE870
	btst.b	#$2,$FFFF8018.w
	bne.s	.LE870
	bclr.b	#$2,$FFFF8028.w
	rts
SyncMainWordRamPhase3
	btst.b	#$3,$FFFF8018.w
	beq.s	SyncMainWordRamPhase3
	bset.b	#$3,$FFFF8028.w
.LE88E
	btst.b	#$3,$FFFF8018.w
	bne.s	.LE88E
	bclr.b	#$3,$FFFF8028.w
	rts
SendMainCommand12Inline
	movem.l	d0/a0-a1,-(sp)
	lea	$BA450.l,a0
	movea.l	$C(sp),a1
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	a1,$C(sp)
	moveq	#$12,d0
	bsr.w	SendMainCommand
	movem.l	(sp)+,d0/a0-a1
	rts
SendMainCommand12
	movem.l	d0/a0-a1,-(sp)
	lea	$BA450.l,a0
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	moveq	#$12,d0
	bsr.w	SendMainCommand
	movem.l	(sp)+,d0/a0-a1
	rts
SendMainFontMap
	lea	$BA450.l,a0
	move.l	$1094C.l,(a0)+
	moveq	#$5,d0
	bsr.w	SendMainCommand
	rts
SendMainCommand0B
	movem.l	d0-d3/a0/a2/a6,-(sp)
	lea	$BA450.l,a2
	move.w	$10B0E.l,(a2)+
	move.w	$10B10.l,(a2)+
	move.w	$10B0A.l,(a2)+
	move.w	$10B0C.l,(a2)+
	move.w	$10AFE.l,(a2)+
	move.w	(a1),d0
	lsr.w	#$1,d0
	subq.w	#$1,d0
.LE924
	move.w	(a1)+,(a2)+
	dbf	d0,.LE924
	movea.l	a1,a6
	moveq	#$B,d0
	bsr.w	SendMainCommand
	lea	$BA450.l,a1
	move.w	(a1)+,$10B0E.l
	move.w	(a1)+,$10B10.l
	move.w	(a1)+,$10B0A.l
	move.w	(a1),$10B0C.l
	movea.l	a6,a1
	movem.l	(sp)+,d0-d3/a0/a2/a6
	rts
WriteMainVdpControl
	movem.l	a0,-(sp)
	lea	$BA450.l,a0
	move.w	d0,(a0)
	moveq	#$13,d0
	bsr.w	SendMainCommand
	movem.l	(sp)+,a0
	rts
SendIndexedMainCommand0C
	bsr.w	SkipStarterRecords
	bra.w	SendMainCommand0C
SkipStarterRecords
	bra.w	.LE97E
.LE97C
	adda.w	(a1),a1
.LE97E
	dbf	d0,.LE97C
	rts
SendMainCommand14
	movem.l	d0,-(sp)
	moveq	#$14,d0
	bsr.w	SendMainCommand
	movem.l	(sp)+,d0
	rts
SendMainCommand15
	movem.l	d0,-(sp)
	moveq	#$15,d0
	bsr.w	SendMainCommand
	movem.l	(sp)+,d0
	rts
SendMainCommand16
	movem.l	d0/a0,-(sp)
	lea	$BA450.l,a0
	move.w	$10B22.l,(a0)+
	move.w	d0,(a0)+
	moveq	#$16,d0
	bsr.w	SendMainCommand
	movem.l	(sp)+,d0/a0
	rts
SendMainCommand19
	movem.l	d0/a0,-(sp)
	move.w	d0,$BA450.l
	moveq	#$19,d0
	bsr.w	SendMainCommand
	movem.l	(sp)+,d0/a0
	rts
SendMainCommand17
	move.l	d0,-(sp)
	moveq	#$17,d0
	bsr.w	SendMainCommand
	move.l	(sp)+,d0
	rts
SendMainCommand18
	movem.l	d0-d2/a0,-(sp)
	lea	$BA450.l,a0
	move.w	d0,(a0)+
	move.w	d1,(a0)+
	move.w	d2,(a0)+
	moveq	#$18,d0
	bsr.w	SendMainCommand
	movem.l	(sp)+,d0-d2/a0
	rts
EnterOneMegWordRamMode
	bset.b	#$2,$FF8003.l
	bne.s	EnterOneMegWordRamMode
	rts
