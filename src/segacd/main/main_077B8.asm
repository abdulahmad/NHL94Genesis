Set1MFlag_8	movem.l	d0-d7/a0-a6,-(sp)
	lea.l	Set1MFlag_31(pc),a0
	cmpi.w	#$1234,(a0)
	bne.w	.l7A2A
	bsr.w	Set1MFlag_19
	bsr.w	Z80StartStream
	lea.l	Set1MFlag_40(pc),a0
	move.w	#$0,(a0)
	lea.l	Set1MFlag_32(pc),a6
	lea.l	Set1MFlag_33(pc),a5
	lea.l	Set1MFlag_35(pc),a4
	lea.l	Set1MFlag_36(pc),a3
	lea.l	Set1MFlag_37(pc),a2
	lea.l	Set1MFlag_38(pc),a1
.l77F0	dc.w	$3C3A,$0D4C
	lsl.w	#$1,d6
	move.w	d6,d7
	lsl.w	#$1,d7
	cmpi.l	#$FFFFFFFF,(a6,d7.w)
	beq.w	.l7A16
	tst.w	(a4,d6.w)
	beq.b	.l784E
	move.w	(a3,d6.w),d1
	add.w	(a2,d6.w),d1
	move.w	d1,d2
	andi.w	#$FF,d2
	lsr.w	#$8,d1
	add.w	(a1,d7.w),d1
	move.w	#$0,(a1,d7.w)
	cmp.w	(a4,d6.w),d1
	bge.b	.l783E
	move.w	(a4,d6.w),d3
	sub.w	d1,d3
	move.w	d3,(a4,d6.w)
	move.w	d2,(a2,d6.w)
	bra.w	.l7A16
.l783E	sub.w	(a4,d6.w),d1
	lsl.w	#$8,d1
	or.w	d2,d1
	move.w	d1,(a2,d6.w)
	clr.w	(a4,d6.w)
.l784E	movea.l	(a6,d7.w),a0
	move.l	(a5,d7.w),d5
.l7856	tst.b	(a0,d5.l)
	bpl.b	.l7864
	opt	oaq-
	opt	osq-
	addi.l	#$1,d5
	opt	oaq+
	opt	osq+
	bra.b	.l7856
.l7864	opt	oaq-
	opt	osq-
	addi.l	#$1,d5
	opt	oaq+
	opt	osq+
	tst.b	(a0,d5.l)
	bpl.b	.l787C
	move.b	(a0,d5.l),$2(a1,d7.w)
	opt	oaq-
	opt	osq-
	addi.l	#$1,d5
	opt	oaq+
	opt	osq+
.l787C	move.b	$2(a1,d7.w),d0
	andi.b	#$F0,d0
	cmpi.b	#$90,d0
	bne.w	.l790C
	dc.w	$303A,$0CB0
	lsl.w	#$8,d0
	lsl.w	#$4,d0
	move.b	$1(a0,d5.l),d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	move.b	$2(a1,d7.w),d0
	bsr.w	Z80PlayIfLoaded
	tst.w	d0
	beq.b	.l78B6
	opt	oaq-
	opt	osq-
	addi.w	#$1,(a1,d7.w)
	opt	oaq+
	opt	osq+
	bra.w	.l7A16
.l78B6	clr.l	d0
	move.b	$2(a0,d5.l),d0
	bpl.b	.l78CA
	andi.l	#$7F,d0
	lsl.l	#$7,d0
	or.b	$3(a0,d5.l),d0
.l78CA	lsl.l	#$8,d0
	move.w	(a3,d6.w),d3
	divu.w	d3,d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	dc.w	$323A,$0C62
	lsl.w	#$4,d1
	move.b	$2(a1,d7.w),d0
	andi.b	#$F,d0
	or.b	d1,d0
	bsr.w	SndSlotAdd
	opt	oaq-
	opt	osq-
	addi.l	#$2,d5
	opt	oaq+
	opt	osq+
.l78F4	tst.b	(a0,d5.l)
	bpl.b	.l7902
	opt	oaq-
	opt	osq-
	addi.l	#$1,d5
	opt	oaq+
	opt	osq+
	bra.b	.l78F4
.l7902	opt	oaq-
	opt	osq-
	addi.l	#$1,d5
	opt	oaq+
	opt	osq+
	bra.w	.l79F4
.l790C	cmpi.b	#$B0,d0
	bne.b	.l797E
	cmpi.b	#$12,(a0,d5.l)
	bne.b	.l794C
	move.l	a0,-(sp)
	move.b	$1(a0,d5.l),d1
	dc.w	$303A,$0C1C
	lsl.w	#$1,d0
	clr.w	d2
	move.b	$2(a1,d7.w),d2
	andi.b	#$F,d2
	lea.l	Set1MFlag_41(pc),a0
	move.w	(a0,d0.w),d3
	cmpi.b	#$0,d1
	bne.b	.l7942
	bclr	d2,d3
	bra.b	.l7944
.l7942	bset	d2,d3
.l7944	move.w	d3,(a0,d0.w)
	movea.l	(sp)+,a0
	bra.b	.l7976
.l794C	dc.w	$303A,$0BF0
	lsl.w	#$8,d0
	lsl.w	#$4,d0
	move.b	$1(a0,d5.l),d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	move.b	$2(a1,d7.w),d0
	bsr.w	Z80PlayIfLoaded
	tst.w	d0
	beq.b	.l7976
	opt	oaq-
	opt	osq-
	addi.w	#$1,(a1,d7.w)
	opt	oaq+
	opt	osq+
	bra.w	.l7A16
.l7976	opt	oaq-
	opt	osq-
	addi.l	#$2,d5
	opt	oaq+
	opt	osq+
	bra.b	.l79F4
.l797E	cmpi.b	#$C0,d0
	bne.b	.l79B0
	dc.w	$303A,$0BB8
	lsl.w	#$8,d0
	lsl.w	#$4,d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	move.b	$2(a1,d7.w),d0
	bsr.w	Z80PlayIfLoaded
	tst.w	d0
	beq.b	.l79A8
	opt	oaq-
	opt	osq-
	addi.w	#$1,(a1,d7.w)
	opt	oaq+
	opt	osq+
	bra.b	.l7A16
.l79A8	opt	oaq-
	opt	osq-
	addi.l	#$1,d5
	opt	oaq+
	opt	osq+
	bra.b	.l79F4
.l79B0	cmpi.b	#$E0,d0
	bne.b	.l79E2
	dc.w	$303A,$0B86
	lsl.w	#$8,d0
	lsl.w	#$4,d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	move.b	$2(a1,d7.w),d0
	bsr.w	Z80PlayIfLoaded
	tst.w	d0
	beq.b	.l79DA
	opt	oaq-
	opt	osq-
	addi.w	#$1,(a1,d7.w)
	opt	oaq+
	opt	osq+
	bra.b	.l7A16
.l79DA	opt	oaq-
	opt	osq-
	addi.l	#$1,d5
	opt	oaq+
	opt	osq+
	bra.b	.l79F4
.l79E2	cmpi.b	#$FF,$2(a1,d7.w)
	bne.b	.l79F4
	move.l	#$FFFFFFFF,(a6,d7.w)
	bra.b	.l7A16
.l79F4	move.l	d5,(a5,d7.w)
	clr.w	d2
	move.b	(a0,d5.l),d2
	bpl.b	.l7A0A
	andi.b	#$7F,d2
	lsl.w	#$7,d2
	or.b	$1(a0,d5.l),d2
.l7A0A	move.w	d2,(a4,d6.w)
	tst.w	d2
	bne.b	.l7A16
	bra.w	.l77F0
.l7A16	lea.l	Set1MFlag_40(pc),a0
	opt	oaq-
	opt	osq-
	addi.w	#$1,(a0)
	opt	oaq+
	opt	osq+
	cmpi.w	#$8,(a0)
	blt.w	.l77F0
	bsr.w	Z80LoadPending
.l7A2A	andi.b	#$FE,ccr
	movem.l	(sp)+,d0-d7/a0-a6
	rts
Set1MFlag_9	movem.l	d1-d4/a0-a1,-(sp)
	lea.l	Set1MFlag_31(pc),a0
	move.w	d1,$1C8(a0)
	move.w	d2,$1CA(a0)
	move.w	d3,$1CC(a0)
	move.w	d4,$1CE(a0)
	lea.l	Set1MFlag_32(pc),a1
	clr.w	d0
.l7A52	cmpi.l	#$FFFFFFFF,(a1)+
	beq.b	.l7A6A
	opt	oaq-
	opt	osq-
	addi.w	#$1,d0
	opt	oaq+
	opt	osq+
	cmpi.w	#$8,d0
	bne.b	.l7A52
	move.w	#$7,d0
	bra.b	.l7AD4
.l7A6A	move.w	d0,$1C6(a0)
	move.w	#$3,d0
	bsr.w	SndFindSource
	bcs.b	.l7AD4
	clr.l	d1
	move.b	$1(a0),d1
	lsl.w	#$8,d1
	move.b	(a0),d1
	lsl.w	#$1,d1
	opt	oaq-
	opt	osq-
	addi.w	#$2,d1
	opt	oaq+
	opt	osq+
	lea.l	Set1MFlag_31(pc),a1
	move.w	#$0,$0(a1)
	move.w	$1C6(a1),d0
	lsl.w	#$2,d0
	move.l	a0,$2(a1,d0.w)
	move.l	d1,$22(a1,d0.w)
	lea.l	Set1MFlag_38(pc),a0
	move.l	#$0,(a0,d0.w)
	move.w	$1C6(a1),d0
	lsl.w	#$1,d0
	move.w	$1CE(a1),$62(a1,d0.w)
	move.w	#$0,$52(a1,d0.w)
	move.w	#$0,$72(a1,d0.w)
	move.w	$1C8(a1),$42(a1,d0.w)
	move.w	#$1234,$0(a1)
	clr.w	d0
	bra.b	.l7AD8
.l7AD4	ori.b	#$1,ccr
.l7AD8	movem.l	(sp)+,d1-d4/a0-a1
	rts
Set1MFlag_10	movem.l	d1-d2/a0,-(sp)
	lea.l	Set1MFlag_34(pc),a0
	clr.w	d0
.l7AE8	cmp.w	(a0)+,d1
	beq.b	.l7B00
	opt	oaq-
	opt	osq-
	addi.w	#$1,d0
	opt	oaq+
	opt	osq+
	cmpi.w	#$8,d0
	bne.b	.l7AE8
	move.w	#$3,d0
	ori.b	#$1,ccr
	bra.b	.l7B30
.l7B00	lea.l	Set1MFlag_31(pc),a0
	move.w	d0,$1C6(a0)
	lsl.w	#$1,d0
	lea.l	Set1MFlag_34(pc),a0
	move.w	#$FFFF,(a0,d0.w)
	lsl.w	#$1,d0
	lea.l	Set1MFlag_32(pc),a0
	move.l	#$FFFFFFFF,(a0,d0.w)
	lea.l	Set1MFlag_31(pc),a0
	move.w	$1C6(a0),d0
	bsr.w	SndSlotFind
	clr.w	d0
.l7B30	movem.l	(sp)+,d1-d2/a0
	rts
Set1MFlag_11	movem.l	d1-d2/a0,-(sp)
	move.w	sr,-(sp)
	move.w	#$2700,sr
	bsr.w	Z80RequestBus
	lea.l	$A00000.l,a0
	move.b	$A00028.l,d0
	lsl.w	#$8,d0
	move.b	$A00029.l,d0
	move.b	d1,$3(a0,d0.w)
	bsr.w	Z80ReleaseBus
	move.w	(sp)+,sr
	move.l	#$0,d0
	move.b	#$7F,d0
	lsl.w	#$8,d0
	move.b	#$CF,d0
	bsr.w	Z80QueueCommand
	move.l	#$7F0000,d0
	move.w	d2,d0
	lsl.w	#$8,d0
	move.b	#$9F,d0
	bsr.w	Z80QueueCommand
	clr.w	d0
	movem.l	(sp)+,d1-d2/a0
	rts
; Reads the Z80 driver status byte at $A00024.
Z80ReadStatus	movem.l	a0-a1,-(sp)
	lea.l	Set1MFlag_31(pc),a0
	move.w	#$0,$0(a0)
	bsr.w	Z80RequestBus
	clr.l	d0
	move.b	$A00024.l,d0
	lsl.w	#$8,d0
	move.b	$A00025.l,d0
	addi.l	#$A00000,d0
	movea.l	d0,a1
	move.w	#$1FF,d0
.l7BBE	move.b	#$0,(a1)+
	dbra	d0,.l7BBE
	clr.l	d0
	move.b	$A00026.l,d0
	lsl.w	#$8,d0
	move.b	$A00027.l,d0
	addi.l	#$A00000,d0
	movea.l	d0,a1
	move.w	#$1FF,d0
.l7BE2	move.b	#$0,(a1)+
	dbra	d0,.l7BE2
	bsr.w	Z80ReleaseBus
	move.w	#$1234,$0(a0)
	clr.w	d0
	movem.l	(sp)+,a0-a1
	rts
; Looks up d0 in the loaded-sound bitmap and starts it or queues a load.
Z80PlayIfLoaded	movem.l	d1-d3/a0,-(sp)
	lea.l	Set1MFlag_41(pc),a0
	move.l	d0,d1
	swap	d1
	lsr.w	#$8,d1
	lsr.w	#$3,d1
	move.w	(a0,d1.w),d2
	move.w	d0,d3
	andi.w	#$F,d3
	btst	d3,d2
	bne.b	.l7C20
	bsr.w	Z80QueueCommand
	bra.b	.l7C24
.l7C20	bsr.w	.lFF7C2A
.l7C24	movem.l	(sp)+,d1-d3/a0
	rts
.lFF7C2A	movem.l	d1-d2/a0,-(sp)
	lea.l	Set1MFlag_31(pc),a0
	move.w	#$0,(a0)
	lea.l	Set1MFlag_43(pc),a0
	move.w	(a0),d2
	cmpi.w	#$20,d2
	bne.b	.l7C54
	lea.l	Set1MFlag_31(pc),a0
	move.w	#$1234,(a0)
	move.w	#$FFFF,d0
	ori.b	#$1,ccr
	bra.b	.l7C70
.l7C54	move.w	d2,d1
	lsl.w	#$2,d1
	opt	oaq-
	opt	osq-
	addi.w	#$2,d1
	opt	oaq+
	opt	osq+
	move.l	d0,(a0,d1.w)
	opt	oaq-
	opt	osq-
	addi.w	#$1,d2
	opt	oaq+
	opt	osq+
	move.w	d2,(a0)
	lea.l	Set1MFlag_31(pc),a0
	move.w	#$1234,(a0)
	clr.w	d0
.l7C70	movem.l	(sp)+,d1-d2/a0
	rts
; Appends command d0 to the Z80 driver command queue.
Z80QueueCommand	movem.l	d1/a0,-(sp)
	lea.l	Set1MFlag_31(pc),a0
	move.w	#$0,$0(a0)
.l7C84	bsr.w	Z80RequestBus
	lea.l	$A00030.l,a0
	tst.b	(a0)
	beq.b	.l7CA2
	bsr.w	Z80ReleaseBus
	move.w	#$64,d1
.l7C9A	opt	oaq-
	opt	osq-
	subi.w	#$1,d1
	opt	oaq+
	opt	osq+
	bne.b	.l7C9A
	bra.b	.l7C84
.l7CA2	adda.l	#$1,a0
	cmpi.b	#$18,(a0)
	blt.b	.l7CB4
	move.w	#$FFFF,d0
	bra.b	.l7CDC
.l7CB4	clr.w	d1
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
	dc.w	$0601,$0001
	move.b	d1,(a0)
	move.w	#$0,d0
.l7CDC	bsr.w	Z80ReleaseBus
	lea.l	Set1MFlag_31(pc),a0
	move.w	#$1234,$0(a0)
	movem.l	(sp)+,d1/a0
	rts
; Loads the pending sound blocks into the Z80 driver.
Z80LoadPending	movem.l	d0-d1/a0-a1,-(sp)
	lea.l	Set1MFlag_43(pc),a1
	cmpi.w	#$0,(a1)
	beq.b	.l7D54
	dc.w	$207A,$085A
	bsr.w	PrgRamReadBegin
	bsr.w	PrgRamMapAddr
.l7D0A	cmpi.w	#$FFFF,(a0)
	bne.b	.l7D2E
	dc.w	$207A,$0848
	bsr.w	PrgRamReadWait
	move.w	#$1F4,d0
.l7D1C	dbra	d0,.l7D1C
	dc.w	$207A,$0838
	bsr.w	PrgRamReadBegin
	bsr.w	PrgRamMapAddr
	bra.b	.l7D0A
.l7D2E	move.w	(a1),d0
	move.w	(a0),d1
	add.w	d1,d0
	move.w	d0,(a0)+
	lsl.w	#$2,d1
	ext.l	d1
	adda.l	d1,a0
	move.w	(a1)+,d0
.l7D3E	move.l	(a1)+,(a0)+
	dbra	d0,.l7D3E
	lea.l	Set1MFlag_43(pc),a1
	move.w	#$0,(a1)
	dc.w	$207A,$080C
	bsr.w	PrgRamReadWait
.l7D54	movem.l	(sp)+,d0-d1/a0-a1
	rts
; Copies a sound block into Z80 RAM, checking the free space.
Z80LoadBlock	movem.l	d0-d2/a0-a1,-(sp)
	lea.l	Set1MFlag_31(pc),a1
	move.w	#$0,(a1)
	bsr.w	Z80RequestBus
	move.b	$A00022.l,d2
	lsl.w	#$8,d2
	move.b	$A00023.l,d2
	add.w	d1,d2
	cmpi.w	#$1F00,d2
	bcs.b	.l7D8C
	move.w	#$4,d0
	ori.b	#$1,ccr
	bra.w	.l7E18
.l7D8C	lea.l	$A00100.l,a1
	move.w	#$40,d2
.l7D96	cmpi.b	#$FF,(a1)
	beq.b	.l7DC0
	adda.l	#$4,a1
	opt	oaq-
	opt	osq-
	subi.w	#$1,d2
	opt	oaq+
	opt	osq+
	bne.b	.l7D96
	bsr.w	Z80ReleaseBus
	lea.l	Set1MFlag_31(pc),a1
	move.w	#$1234,(a1)
	move.w	#$7,d0
	ori.b	#$1,ccr
	bra.w	.l7E18
.l7DC0	move.b	d0,(a1)
	move.b	d1,$1(a1)
	move.b	$A00022.l,d2
	move.b	d2,$2(a1)
	move.b	$A00023.l,d2
	move.b	d2,$3(a1)
	lea.l	$A00000.l,a1
	clr.l	d2
	move.b	$A00022.l,d2
	lsl.w	#$8,d2
	move.b	$A00023.l,d2
.l7DF0	move.b	(a0)+,(a1,d2.w)
	opt	oaq-
	opt	osq-
	addi.w	#$1,d2
	opt	oaq+
	opt	osq+
	dbra	d1,.l7DF0
	move.b	d2,$A00023.l
	lsr.w	#$8,d2
	move.b	d2,$A00022.l
	bsr.w	Z80ReleaseBus
	lea.l	Set1MFlag_31(pc),a1
	move.w	#$1234,(a1)
	clr.w	d0
.l7E18	movem.l	(sp)+,d0-d2/a0-a1
	rts
; Marks all 32 sound slots as empty.
SndSlotsReset	movem.l	d0-d1/a0-a1,-(sp)
	lea.l	Set1MFlag_31(pc),a0
	move.w	#$0,$0(a0)
	move.w	#$0,$122(a0)
	lea.l	Set1MFlag_39(pc),a1
	move.w	#$1F,d1
	move.l	#$FFFFFFFF,d0
.l7E40	move.l	d0,(a1)+
	dbra	d1,.l7E40
	move.w	#$1234,$0(a0)
	movem.l	(sp)+,d0-d1/a0-a1
	rts
; Looks for the sound slot whose id matches d0.
SndSlotFind	movem.l	d0-d2/a0-a1,-(sp)
	lea.l	Set1MFlag_31(pc),a0
	move.w	#$0,$0(a0)
	lea.l	Set1MFlag_39(pc),a1
	move.w	$122(a0),d1
	clr.w	d2
.l7E6A	cmpi.w	#$0,d1
	beq.b	.l7E8A
	move.b	$3(a1),d2
	lsr.b	#$4,d2
	cmp.w	d0,d2
	bne.b	.l7E7E
	move.w	#$1,(a1)
.l7E7E	adda.l	#$4,a1
	opt	oaq-
	opt	osq-
	subi.w	#$1,d1
	opt	oaq+
	opt	osq+
	bra.b	.l7E6A
.l7E8A	move.w	#$1234,$0(a0)
	movem.l	(sp)+,d0-d2/a0-a1
	rts
; Stores d0 in the next free sound slot.
SndSlotAdd	movem.l	d0-d1/a0,-(sp)
	lea.l	Set1MFlag_31(pc),a0
	move.w	$122(a0),d1
	lsl.w	#$2,d1
	lea.l	Set1MFlag_39(pc),a0
	move.l	d0,(a0,d1.w)
	lea.l	Set1MFlag_31(pc),a0
	opt	oaq-
	opt	osq-
	addi.w	#$1,$122(a0)
	opt	oaq+
	opt	osq+
	movem.l	(sp)+,d0-d1/a0
	rts
Set1MFlag_19	movem.l	d0-d1/a0-a2,-(sp)
	lea.l	Set1MFlag_31(pc),a2
	cmpi.w	#$0,$122(a2)
	beq.b	.l7F2A
	lea.l	Set1MFlag_39(pc),a0
.l7ED0	cmpi.w	#$FFFF,(a0)
	beq.b	.l7F2A
	opt	oaq-
	opt	osq-
	subi.w	#$1,(a0)
	opt	oaq+
	opt	osq+
	bne.b	.l7F24
	move.b	$3(a0),d0
	andi.b	#$F0,d0
	lsl.w	#$8,d0
	swap	d0
	move.w	$2(a0),d0
	andi.b	#$F,d0
	ori.b	#$80,d0
	bsr.w	Z80PlayIfLoaded
	tst.w	d0
	beq.b	.l7F02
	opt	oaq-
	opt	osq-
	addi.w	#$1,(a0)
	opt	oaq+
	opt	osq+
	bra.b	.l7F24
.l7F02	lea.l	Set1MFlag_39(pc),a1
	dc.w	$303A,$0634
	opt	oaq-
	opt	osq-
	subi.w	#$1,d0
	opt	oaq+
	opt	osq+
	lsl.w	#$2,d0
	move.l	(a1,d0.w),(a0)
	move.l	#$FFFFFFFF,(a1,d0.w)
	opt	oaq-
	opt	osq-
	subi.w	#$1,$122(a2)
	opt	oaq+
	opt	osq+
	bra.b	.l7ED0
.l7F24	adda.w	#$4,a0
	bra.b	.l7ED0
.l7F2A	movem.l	(sp)+,d0-d1/a0-a2
	rts
; Starts a sound stream from the table at $A00072.
Z80StartStream	movem.l	d1-d2/a0,-(sp)
	bsr.w	Z80RequestBus
	tst.b	$A00072.l
	beq.w	.l80B8
	cmpi.b	#$1,$A00072.l
	bne.b	.l7FCA
	clr.w	d1
	move.b	$A00073.l,d1
	move.w	#$1,d0
	bsr.w	SndFindSource
	bcs.w	.l80B8
	cmpa.l	#$FFFFFFFF,a0
	beq.w	.l80B8
	lea.l	Set1MFlag_31(pc),a1
	move.l	a0,$126(a1)
	move.l	a0,-(sp)
	bsr.w	PrgRamReadBegin
	bsr.w	PrgRamMapAddr
.l7F7C	move.b	(a0),d0
	cmp.b	(a0),d0
	bne.b	.l7F7C
	lsl.w	#$8,d0
	adda.l	#$1,a0
.l7F8A	move.b	(a0),d0
	cmp.b	(a0),d0
	bne.b	.l7F8A
	move.w	d0,$12E(a1)
	adda.l	#$1,a0
	movea.l	(sp)+,a0
	bsr.w	PrgRamReadWait
	movea.l	$126(a1),a0
	adda.l	#$2,a0
	move.l	a0,$12A(a1)
	clr.l	d0
	move.b	$A00024.l,d0
	lsl.w	#$8,d0
	move.b	$A00025.l,d0
	addi.l	#$A00000,d0
	movea.l	d0,a1
	bra.w	.l804A
.l7FCA	cmpi.b	#$2,$A00072.l
	bne.b	.l800A
	dc.w	$207A,$056E
	cmpa.l	#$0,a0
	bne.b	.l7FF0
	bsr.w	Z80ReleaseBus
	bsr.w	Z80ReadStatus
	bsr.w	Z80RequestBus
	bra.w	.l80B8
.l7FF0	clr.l	d0
	move.b	$A00024.l,d0
	lsl.w	#$8,d0
	move.b	$A00025.l,d0
	addi.l	#$A00000,d0
	movea.l	d0,a1
	bra.b	.l804A
.l800A	cmpi.b	#$3,$A00072.l
	bne.w	.l80B8
	dc.w	$207A,$052C
	cmpa.l	#$0,a0
	bne.b	.l8032
	bsr.w	Z80ReleaseBus
	bsr.w	Z80ReadStatus
	bsr.w	Z80RequestBus
	bra.w	.l80B8
.l8032	clr.l	d0
	move.b	$A00026.l,d0
	lsl.w	#$8,d0
	move.b	$A00027.l,d0
	addi.l	#$A00000,d0
	movea.l	d0,a1
.l804A	move.l	a0,-(sp)
	bsr.w	PrgRamReadBegin
	bsr.w	PrgRamMapAddr
	move.w	#$1FF,d1
.l8058	move.b	(a0)+,(a1)+
	beq.b	.l807A
	dbra	d1,.l8058
	lea.l	Set1MFlag_31(pc),a1
	move.l	$12A(a1),d0
	addi.l	#$200,d0
	move.l	d0,$12A(a1)
	movea.l	(sp)+,a0
	bsr.w	PrgRamReadWait
	bra.b	.l80B8
.l807A	suba.l	#$1,a1
	movea.l	(sp)+,a0
	bsr.w	PrgRamReadWait
	clr.l	d0
	dc.w	$303A,$04BE
	cmpi.w	#$FFFF,d0
	beq.b	.l80AC
	move.b	#$FF,(a1)
	lea.l	Set1MFlag_31(pc),a1
	movea.l	$126(a1),a0
	adda.l	#$2,a0
	adda.l	d0,a0
	move.l	a0,$12A(a1)
	bra.b	.l80B8
.l80AC	lea.l	Set1MFlag_31(pc),a1
	move.l	#$0,$12A(a1)
.l80B8	move.b	#$0,$A00072.l
	bsr.w	Z80ReleaseBus
	movem.l	(sp)+,d1-d2/a0
	rts
; Finds the sound source for the request in d0/d1 in the list at 4 sources.
SndFindSource	movem.l	d1-d4/a1-a2,-(sp)
	lea.l	Set1MFlag_45(pc),a1
	move.w	#$4,d2
.l80D6	cmpi.l	#$FFFFFFFF,(a1)
	beq.w	.l8180
	movea.l	(a1),a0
	movea.l	a0,a2
	move.l	a0,-(sp)
	bsr.w	PrgRamReadBegin
	bsr.w	PrgRamMapAddr
	clr.l	d3
.l80F0	move.b	(a0),d3
	cmp.b	(a0),d3
	bne.b	.l80F0
	adda.l	#$1,a0
	lsl.w	#$8,d3
.l80FE	move.b	(a0),d3
	cmp.b	(a0),d3
	bne.b	.l80FE
	adda.l	#$1,a0
	move.l	d3,d4
	lsl.w	#$2,d4
	adda.l	d4,a2
	adda.l	#$2,a2
.l8116	move.b	(a0),d4
	cmp.b	(a0),d4
	bne.b	.l8116
	cmp.b	d4,d0
	bne.b	.l8154
.l8120	move.b	$1(a0),d4
	cmp.b	$1(a0),d4
	bne.b	.l8120
	cmp.b	d4,d1
	bne.b	.l8154
	clr.w	d0
.l8130	move.b	$2(a0),d0
	cmp.b	$2(a0),d0
	bne.b	.l8130
	lsl.w	#$8,d0
.l813C	move.b	$3(a0),d0
	cmp.b	$3(a0),d0
	bne.b	.l813C
	movea.l	(sp)+,a0
	bsr.w	PrgRamReadWait
	movea.l	a2,a0
	andi.b	#$FE,ccr
	bra.b	.l8196
.l8154	clr.l	d4
	move.b	$2(a0),d4
	cmp.b	$2(a0),d4
	bne.b	.l8154
	lsl.w	#$8,d4
.l8162	move.b	$3(a0),d4
	cmp.b	$3(a0),d4
	bne.b	.l8162
	adda.l	d4,a2
	adda.l	#$4,a0
	opt	oaq-
	opt	osq-
	subi.w	#$1,d3
	opt	oaq+
	opt	osq+
	bne.b	.l8116
	movea.l	(sp)+,a0
	bsr.w	PrgRamReadWait
.l8180	adda.l	#$4,a1
	opt	oaq-
	opt	osq-
	subi.w	#$1,d2
	opt	oaq+
	opt	osq+
	bne.w	.l80D6
	move.w	#$3,d0
	ori.b	#$1,ccr
.l8196	movem.l	(sp)+,d1-d4/a1-a2
	rts
Set1MFlag_22	movem.l	d1/a1,-(sp)
	lsl.w	#$2,d1
	lea.l	Set1MFlag_45(pc),a1
	move.l	a0,(a1,d1.w)
	movem.l	(sp)+,d1/a1
	rts
Set1MFlag_23	movem.l	d1/a0-a1,-(sp)
	movea.l	a0,a1
.l81B6	cmpi.w	#$FFFF,(a1)
	bne.b	.l81C0
	clr.w	d0
	bra.b	.l81F4
.l81C0	move.w	(a1),d0
	move.w	$2(a1),d1
	bsr.w	SndFindSource
	bcs.b	.l81F0
	cmpi.w	#$0,(a1)
	bne.b	.l81E8
	cmpi.b	#$6,(a0)
	bcc.b	.l81E8
	move.w	d0,d1
	move.w	$2(a1),d0
	bsr.w	Z80LoadBlock
	bcs.b	.l81F0
	bra.w	.l81E8
.l81E8	adda.l	#$4,a1
	bra.b	.l81B6
.l81F0	ori.b	#$1,ccr
.l81F4	movem.l	(sp)+,d1/a0-a1
	rts
Set1MFlag_24	movem.l	d1-d3/a0-a2,-(sp)
	lea.l	Set1MFlag_31(pc),a1
	move.w	#$0,(a1)
	bsr.w	Z80RequestBus
.l820A	cmpi.w	#$FFFF,(a0)
	beq.w	.l82E4
	cmpi.w	#$6,(a0)
	bcc.w	.l82DA
	lea.l	$A00100.l,a1
	move.w	$2(a0),d0
	move.w	#$3F,d1
.l8228	cmp.b	(a1),d0
	beq.b	.l823A
	adda.l	#$4,a1
	dbra	d1,.l8228
	bra.w	.l82DA
.l823A	clr.w	d0
	move.b	$1(a1),d0
	clr.w	d1
	move.b	$2(a1),d1
	lsl.w	#$8,d1
	move.b	$3(a1),d1
	move.w	d1,d2
	add.w	d0,d2
	lea.l	$A00000.l,a2
.l8256	cmpi.w	#$1F00,d2
	beq.b	.l826C
	move.b	(a2,d2.w),(a2,d1.w)
	opt	oaq-
	opt	osq-
	addi.w	#$1,d2
	opt	oaq+
	opt	osq+
	opt	oaq-
	opt	osq-
	addi.w	#$1,d1
	opt	oaq+
	opt	osq+
	bra.b	.l8256
.l826C	clr.w	d1
	move.b	$2(a1),d1
	lsl.w	#$8,d1
	move.b	$3(a1),d1
	move.b	#$FF,(a1)
	move.b	#$FF,$1(a1)
	move.b	#$FF,$2(a1)
	move.b	#$FF,$3(a1)
	lea.l	$A00100.l,a1
	move.w	#$3F,d2
.l8298	cmpi.b	#$FF,(a1)
	bne.w	.l82BC
	clr.w	d3
	move.b	$2(a1),d3
	lsl.w	#$8,d3
	move.b	$3(a1),d3
	cmp.w	d1,d3
	bcc.b	.l82BC
	sub.w	d0,d3
	move.b	d3,$3(a1)
	lsr.w	#$8,d3
	move.b	d3,$2(a1)
.l82BC	dbra	d2,.l8298
	lea.l	$A00022.l,a1
	clr.w	d1
	move.b	(a1),d1
	lsl.w	#$8,d1
	move.b	$1(a1),d1
	sub.w	d0,d1
	move.b	d1,$1(a1)
	lsr.w	#$8,d1
	move.b	d1,(a1)
.l82DA	adda.l	#$4,a0
	bra.w	.l820A
.l82E4	bsr.w	Z80ReleaseBus
	lea.l	Set1MFlag_31(pc),a1
	move.w	#$1234,(a1)
	clr.w	d0
	movem.l	(sp)+,d1-d3/a0-a2
	rts
Set1MFlag_25	movem.l	a0-a1,-(sp)
	lea.l	Set1MFlag_31(pc),a0
	move.w	#$0,(a0)
	bsr.w	Z80RequestBus
	lea.l	$A00100.l,a0
	move.w	#$FF,d0
.l8312	move.b	#$FF,(a0)+
	dbra	d0,.l8312
	lea.l	$A00020.l,a0
	lea.l	$A00022.l,a1
	move.b	(a0)+,(a1)+
	move.b	(a0),(a1)
	bsr.w	Z80ReleaseBus
	lea.l	Set1MFlag_31(pc),a0
	move.w	#$1234,(a0)
	clr.w	d0
	movem.l	(sp)+,a0-a1
	rts
; Requests the Z80 bus and waits for it.
Z80RequestBus	move.w	#$100,$A11100.l
.l8346	btst.b	#$8,$A11100.l
	bne.b	.l8346
	rts
; Gives the Z80 bus back.
Z80ReleaseBus	move.w	#$0,$A11100.l
	rts
; Prepares reading from sub-CPU PRG RAM when the address is at or above $80000.
PrgRamReadBegin	movem.l	d0-d1/a1,-(sp)
	cmpa.l	#$80000,a0
	bcc.w	.l83AA
	move.b	#$3,$A12001.l
.l8372	move.w	$A12000.l,d0
	btst	#$1,d0
	beq.b	.l8372
	move.l	a0,d0
	swap	d0
	andi.w	#$6,d0
	lsl.w	#$5,d0
	lea.l	Set1MFlag_44(pc),a1
	move.w	$A12002.l,d1
	move.w	d1,(a1)
	btst	#$2,d1
	beq.b	.l839E
	bset	#$1,d0
.l839E	andi.w	#$FF00,d1
	or.w	d0,d1
	move.w	d1,$A12002.l
.l83AA	movem.l	(sp)+,d0-d1/a1
	rts
; Waits until the PRG-RAM read window is ready.
PrgRamReadWait	move.l	d0,-(sp)
	cmpa.l	#$80000,a0
	bcc.b	.l83F8
	dc.w	$303A,$022E
	btst	#$2,d0
	beq.b	.l83CE
	andi.w	#$FFC0,d0
	bset	#$1,d0
	bra.b	.l83D2
.l83CE	andi.w	#$FFC0,d0
.l83D2	move.w	d0,$A12002.l
	move.w	#$1,$A12000.l
.l83E0	move.w	$A12000.l,d0
	btst	#$1,d0
	bne.b	.l83E0
	move.w	$A12000.l,d0
	btst	#$1,d0
	bne.b	.l83E0
.l83F8	move.l	(sp)+,d0
	rts
; Maps a0 into the PRG-RAM window address.
PrgRamMapAddr	move.l	d0,-(sp)
	cmpa.l	#$80000,a0
	bcc.b	.l8416
	move.l	a0,d0
	andi.l	#$1FFFF,d0
	ori.l	#$20000,d0
	movea.l	d0,a0
.l8416	move.l	(sp)+,d0
	rts
Set1MFlag_31	dc.b	$00,$00	; ..
Set1MFlag_32	dcb.b	$20,0
Set1MFlag_33	dcb.b	$20,0
Set1MFlag_34	dcb.b	$10,0
Set1MFlag_35	dcb.b	$10,0
Set1MFlag_36	dcb.b	$10,0
Set1MFlag_37	dcb.b	$10,0
Set1MFlag_38	dcb.b	$20,0
Set1MFlag_39	dcb.b	$80,0
.lFF853C	dc.b	$00,$00	; ..
Set1MFlag_40	dc.b	$00,$00,$00,$00,$00,$00	; ......
.lFF8544	dc.b	$00,$00,$00,$00	; ....
.lFF8548	dc.b	$00,$00	; ..
Set1MFlag_41	dcb.b	$10,0
Set1MFlag_42	dc.b	$00,$00,$00,$00	; ....
Set1MFlag_43	dcb.b	$8C,0
Set1MFlag_44	dc.b	$00,$00	; ..
Set1MFlag_45	dcb.b	$51,0
	incbin	..\Extracted\SegaCD\MAIN\main_0863D.bin
	dcb.b	$9,0
	dc.b	$01,$00,$00,$00,$02,$00,$00,$00,$03,$00,$00,$00,$04,$00,$00,$00	; ................
	dc.b	$05,$00,$00,$00,$06,$00,$00,$00,$07,$00,$00,$00,$08,$00,$00,$00	; ................
	dc.b	$09,$00,$00,$00,$0A,$00,$00,$00,$0B,$00,$00,$00,$0C,$00,$00,$00	; ................
	dc.b	$0D,$00,$00,$00,$0E,$00,$00,$00,$0F,$00,$00,$00,$10,$00,$00,$00	; ................
	dc.b	$11,$00,$00,$00,$12,$00,$00,$00,$13,$00,$00,$00,$14,$00,$00,$00	; ................
	dc.b	$15,$00,$00,$00,$16,$00,$00,$00,$17,$00,$00,$00,$18,$00,$00,$00	; ................
	dc.b	$19,$00,$00,$00,$1A,$00,$00,$00,$1B,$00,$00,$00,$1C,$00,$00,$00	; ................
	dc.b	$1D,$00,$00,$00,$1F,$FF,$FF	; .......
	dcb.b	$5ABC,0
