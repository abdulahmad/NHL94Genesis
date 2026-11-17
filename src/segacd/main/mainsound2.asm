; Ticks all sound slots
SndSlotsTickAll	movem.l	d0-d7/a0-a6,-(sp)
	lea.l	SndEnableFlag(pc),a0
	cmpi.w	#$1234,(a0)
	bne.w	.next21
	bsr.w	SndSlotsTick
	bsr.w	Z80StartStream
	lea.l	SndStateVars(pc),a0
	move.w	#$0,(a0)
	lea.l	SndBufA(pc),a6
	lea.l	SndBufB(pc),a5
	lea.l	SndBufC(pc),a4
	lea.l	SndBufD(pc),a3
	lea.l	SndBufE(pc),a2
	lea.l	SndBufF(pc),a1
.loop	move.w	SndStateVars(pc),d6
	lsl.w	#$1,d6
	move.w	d6,d7
	lsl.w	#$1,d7
	cmpi.l	#$FFFFFFFF,(a6,d7.w)
	beq.w	.next20
	tst.w	(a4,d6.w)
	beq.b	.next2
	move.w	(a3,d6.w),d1
	add.w	(a2,d6.w),d1
	move.w	d1,d2
	andi.w	#$FF,d2
	lsr.w	#$8,d1
	add.w	(a1,d7.w),d1
	move.w	#$0,(a1,d7.w)
	cmp.w	(a4,d6.w),d1
	bge.b	.next
	move.w	(a4,d6.w),d3
	sub.w	d1,d3
	move.w	d3,(a4,d6.w)
	move.w	d2,(a2,d6.w)
	bra.w	.next20
.next	sub.w	(a4,d6.w),d1
	lsl.w	#$8,d1
	or.w	d2,d1
	move.w	d1,(a2,d6.w)
	clr.w	(a4,d6.w)
.next2	movea.l	(a6,d7.w),a0
	move.l	(a5,d7.w),d5
.loop2	tst.b	(a0,d5.l)
	bpl.b	.next3
	opt	oaq-
	opt	osq-
	addi.l	#$1,d5
	opt	oaq+
	opt	osq+
	bra.b	.loop2
.next3	opt	oaq-
	opt	osq-
	addi.l	#$1,d5
	opt	oaq+
	opt	osq+
	tst.b	(a0,d5.l)
	bpl.b	.next4
	move.b	(a0,d5.l),$2(a1,d7.w)
	opt	oaq-
	opt	osq-
	addi.l	#$1,d5
	opt	oaq+
	opt	osq+
.next4	move.b	$2(a1,d7.w),d0
	andi.b	#$F0,d0
	cmpi.b	#$90,d0
	bne.w	.next8
	move.w	SndStateVars(pc),d0
	lsl.w	#$8,d0
	lsl.w	#$4,d0
	move.b	$1(a0,d5.l),d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	move.b	$2(a1,d7.w),d0
	bsr.w	Z80PlayIfLoaded
	tst.w	d0
	beq.b	.next5
	opt	oaq-
	opt	osq-
	addi.w	#$1,(a1,d7.w)
	opt	oaq+
	opt	osq+
	bra.w	.next20
.next5	clr.l	d0
	move.b	$2(a0,d5.l),d0
	bpl.b	.next6
	andi.l	#$7F,d0
	lsl.l	#$7,d0
	or.b	$3(a0,d5.l),d0
.next6	lsl.l	#$8,d0
	move.w	(a3,d6.w),d3
	divu.w	d3,d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	move.w	SndStateVars(pc),d1
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
.loop3	tst.b	(a0,d5.l)
	bpl.b	.next7
	opt	oaq-
	opt	osq-
	addi.l	#$1,d5
	opt	oaq+
	opt	osq+
	bra.b	.loop3
.next7	opt	oaq-
	opt	osq-
	addi.l	#$1,d5
	opt	oaq+
	opt	osq+
	bra.w	.next18
.next8	cmpi.b	#$B0,d0
	bne.b	.next13
	cmpi.b	#$12,(a0,d5.l)
	bne.b	.next11
	move.l	a0,-(sp)
	move.b	$1(a0,d5.l),d1
	move.w	SndStateVars(pc),d0
	lsl.w	#$1,d0
	clr.w	d2
	move.b	$2(a1,d7.w),d2
	andi.b	#$F,d2
	lea.l	SndMiscBuf(pc),a0
	move.w	(a0,d0.w),d3
	cmpi.b	#$0,d1
	bne.b	.next9
	bclr	d2,d3
	bra.b	.next10
.next9	bset	d2,d3
.next10	move.w	d3,(a0,d0.w)
	movea.l	(sp)+,a0
	bra.b	.next12
.next11	move.w	SndStateVars(pc),d0
	lsl.w	#$8,d0
	lsl.w	#$4,d0
	move.b	$1(a0,d5.l),d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	move.b	$2(a1,d7.w),d0
	bsr.w	Z80PlayIfLoaded
	tst.w	d0
	beq.b	.next12
	opt	oaq-
	opt	osq-
	addi.w	#$1,(a1,d7.w)
	opt	oaq+
	opt	osq+
	bra.w	.next20
.next12	opt	oaq-
	opt	osq-
	addi.l	#$2,d5
	opt	oaq+
	opt	osq+
	bra.b	.next18
.next13	cmpi.b	#$C0,d0
	bne.b	.next15
	move.w	SndStateVars(pc),d0
	lsl.w	#$8,d0
	lsl.w	#$4,d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	move.b	$2(a1,d7.w),d0
	bsr.w	Z80PlayIfLoaded
	tst.w	d0
	beq.b	.next14
	opt	oaq-
	opt	osq-
	addi.w	#$1,(a1,d7.w)
	opt	oaq+
	opt	osq+
	bra.b	.next20
.next14	opt	oaq-
	opt	osq-
	addi.l	#$1,d5
	opt	oaq+
	opt	osq+
	bra.b	.next18
.next15	cmpi.b	#$E0,d0
	bne.b	.next17
	move.w	SndStateVars(pc),d0
	lsl.w	#$8,d0
	lsl.w	#$4,d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	move.b	$2(a1,d7.w),d0
	bsr.w	Z80PlayIfLoaded
	tst.w	d0
	beq.b	.next16
	opt	oaq-
	opt	osq-
	addi.w	#$1,(a1,d7.w)
	opt	oaq+
	opt	osq+
	bra.b	.next20
.next16	opt	oaq-
	opt	osq-
	addi.l	#$1,d5
	opt	oaq+
	opt	osq+
	bra.b	.next18
.next17	cmpi.b	#$FF,$2(a1,d7.w)
	bne.b	.next18
	move.l	#$FFFFFFFF,(a6,d7.w)
	bra.b	.next20
.next18	move.l	d5,(a5,d7.w)
	clr.w	d2
	move.b	(a0,d5.l),d2
	bpl.b	.next19
	andi.b	#$7F,d2
	lsl.w	#$7,d2
	or.b	$1(a0,d5.l),d2
.next19	move.w	d2,(a4,d6.w)
	tst.w	d2
	bne.b	.next20
	bra.w	.loop
.next20	lea.l	SndStateVars(pc),a0
	opt	oaq-
	opt	osq-
	addi.w	#$1,(a0)
	opt	oaq+
	opt	osq+
	cmpi.w	#$8,(a0)
	blt.w	.loop
	bsr.w	Z80LoadPending
.next21	andi.b	#$FE,ccr
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Stores the sound slot parameters
SndSlotsSave	movem.l	d1-d4/a0-a1,-(sp)
	lea.l	SndEnableFlag(pc),a0
	move.w	d1,$1C8(a0)
	move.w	d2,$1CA(a0)
	move.w	d3,$1CC(a0)
	move.w	d4,$1CE(a0)
	lea.l	SndBufA(pc),a1
	clr.w	d0
.loop	cmpi.l	#$FFFFFFFF,(a1)+
	beq.b	.next
	opt	oaq-
	opt	osq-
	addi.w	#$1,d0
	opt	oaq+
	opt	osq+
	cmpi.w	#$8,d0
	bne.b	.loop
	move.w	#$7,d0
	bra.b	.next2
.next	move.w	d0,$1C6(a0)
	move.w	#$3,d0
	bsr.w	SndFindSource
	bcs.b	.next2
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
	lea.l	SndEnableFlag(pc),a1
	move.w	#$0,$0(a1)
	move.w	$1C6(a1),d0
	lsl.w	#$2,d0
	move.l	a0,$2(a1,d0.w)
	move.l	d1,$22(a1,d0.w)
	lea.l	SndBufF(pc),a0
	move.l	#$0,(a0,d0.w)
	move.w	$1C6(a1),d0
	lsl.w	#$1,d0
	move.w	$1CE(a1),$62(a1,d0.w)
	move.w	#$0,$52(a1,d0.w)
	move.w	#$0,$72(a1,d0.w)
	move.w	$1C8(a1),$42(a1,d0.w)
	move.w	#$1234,$0(a1)
	clr.w	d0
	bra.b	.next3
.next2	ori.b	#$1,ccr
.next3	movem.l	(sp)+,d1-d4/a0-a1
	rts
; Finds a sound id in the table
SndFindId	movem.l	d1-d2/a0,-(sp)
	lea.l	SndIdTable(pc),a0
	clr.w	d0
.loop	cmp.w	(a0)+,d1
	beq.b	.next
	opt	oaq-
	opt	osq-
	addi.w	#$1,d0
	opt	oaq+
	opt	osq+
	cmpi.w	#$8,d0
	bne.b	.loop
	move.w	#$3,d0
	ori.b	#$1,ccr
	bra.b	.next2
.next	lea.l	SndEnableFlag(pc),a0
	move.w	d0,$1C6(a0)
	lsl.w	#$1,d0
	lea.l	SndIdTable(pc),a0
	move.w	#$FFFF,(a0,d0.w)
	lsl.w	#$1,d0
	lea.l	SndBufA(pc),a0
	move.l	#$FFFFFFFF,(a0,d0.w)
	lea.l	SndEnableFlag(pc),a0
	move.w	$1C6(a0),d0
	bsr.w	SndSlotFind
	clr.w	d0
.next2	movem.l	(sp)+,d1-d2/a0
	rts
; Uploads a block to Z80 RAM
Z80UploadBlock	movem.l	d1-d2/a0,-(sp)
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
	lea.l	SndEnableFlag(pc),a0
	move.w	#$0,$0(a0)
	bsr.w	Z80RequestBus
	clr.l	d0
	move.b	$A00024.l,d0
	lsl.w	#$8,d0
	move.b	$A00025.l,d0
	addi.l	#$A00000,d0
	movea.l	d0,a1
	move.w	#$1FF,d0
.loop	move.b	#$0,(a1)+
	dbra	d0,.loop
	clr.l	d0
	move.b	$A00026.l,d0
	lsl.w	#$8,d0
	move.b	$A00027.l,d0
	addi.l	#$A00000,d0
	movea.l	d0,a1
	move.w	#$1FF,d0
.loop2	move.b	#$0,(a1)+
	dbra	d0,.loop2
	bsr.w	Z80ReleaseBus
	move.w	#$1234,$0(a0)
	clr.w	d0
	movem.l	(sp)+,a0-a1
	rts
; Looks up d0 in the loaded-sound bitmap and starts it or queues a load.
Z80PlayIfLoaded	movem.l	d1-d3/a0,-(sp)
	lea.l	SndMiscBuf(pc),a0
	move.l	d0,d1
	swap	d1
	lsr.w	#$8,d1
	lsr.w	#$3,d1
	move.w	(a0,d1.w),d2
	move.w	d0,d3
	andi.w	#$F,d3
	btst	d3,d2
	bne.b	.next
	bsr.w	Z80QueueCommand
	bra.b	.next2
.next	bsr.w	.next3
.next2	movem.l	(sp)+,d1-d3/a0
	rts
.next3	movem.l	d1-d2/a0,-(sp)
	lea.l	SndEnableFlag(pc),a0
	move.w	#$0,(a0)
	lea.l	SndWorkBuf(pc),a0
	move.w	(a0),d2
	cmpi.w	#$20,d2
	bne.b	.next4
	lea.l	SndEnableFlag(pc),a0
	move.w	#$1234,(a0)
	move.w	#$FFFF,d0
	ori.b	#$1,ccr
	bra.b	.next5
.next4	move.w	d2,d1
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
	lea.l	SndEnableFlag(pc),a0
	move.w	#$1234,(a0)
	clr.w	d0
.next5	movem.l	(sp)+,d1-d2/a0
	rts
; Appends command d0 to the Z80 driver command queue.
Z80QueueCommand	movem.l	d1/a0,-(sp)
	lea.l	SndEnableFlag(pc),a0
	move.w	#$0,$0(a0)
.loop	bsr.w	Z80RequestBus
	lea.l	$A00030.l,a0
	tst.b	(a0)
	beq.b	.next
	bsr.w	Z80ReleaseBus
	move.w	#$64,d1
.loop2	opt	oaq-
	opt	osq-
	subi.w	#$1,d1
	opt	oaq+
	opt	osq+
	bne.b	.loop2
	bra.b	.loop
.next	adda.l	#$1,a0
	cmpi.b	#$18,(a0)
	blt.b	.next2
	move.w	#$FFFF,d0
	bra.b	.next3
.next2	clr.w	d1
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
; Instruction bytes inside Z80QueueCommand that the assembler would encode differently, kept as words (1 row).
	dc.w	$0601,$0001
	move.b	d1,(a0)
	move.w	#$0,d0
.next3	bsr.w	Z80ReleaseBus
	lea.l	SndEnableFlag(pc),a0
	move.w	#$1234,$0(a0)
	movem.l	(sp)+,d1/a0
	rts
; Loads the pending sound blocks into the Z80 driver.
Z80LoadPending	movem.l	d0-d1/a0-a1,-(sp)
	lea.l	SndWorkBuf(pc),a1
	cmpi.w	#$0,(a1)
	beq.b	.next3
	movea.l	SndPtrs(pc),a0
	bsr.w	PrgRamReadBegin
	bsr.w	PrgRamMapAddr
.loop	cmpi.w	#$FFFF,(a0)
	bne.b	.next2
	movea.l	SndPtrs(pc),a0
	bsr.w	PrgRamReadWait
	move.w	#$1F4,d0
.next	dbra	d0,.next
	movea.l	SndPtrs(pc),a0
	bsr.w	PrgRamReadBegin
	bsr.w	PrgRamMapAddr
	bra.b	.loop
.next2	move.w	(a1),d0
	move.w	(a0),d1
	add.w	d1,d0
	move.w	d0,(a0)+
	lsl.w	#$2,d1
	ext.l	d1
	adda.l	d1,a0
	move.w	(a1)+,d0
.loop2	move.l	(a1)+,(a0)+
	dbra	d0,.loop2
	lea.l	SndWorkBuf(pc),a1
	move.w	#$0,(a1)
	movea.l	SndPtrs(pc),a0
	bsr.w	PrgRamReadWait
.next3	movem.l	(sp)+,d0-d1/a0-a1
	rts
; Copies a sound block into Z80 RAM, checking the free space.
Z80LoadBlock	movem.l	d0-d2/a0-a1,-(sp)
	lea.l	SndEnableFlag(pc),a1
	move.w	#$0,(a1)
	bsr.w	Z80RequestBus
	move.b	$A00022.l,d2
	lsl.w	#$8,d2
	move.b	$A00023.l,d2
	add.w	d1,d2
	cmpi.w	#$1F00,d2
	bcs.b	.next
	move.w	#$4,d0
	ori.b	#$1,ccr
	bra.w	.next3
.next	lea.l	$A00100.l,a1
	move.w	#$40,d2
.loop	cmpi.b	#$FF,(a1)
	beq.b	.next2
	adda.l	#$4,a1
	opt	oaq-
	opt	osq-
	subi.w	#$1,d2
	opt	oaq+
	opt	osq+
	bne.b	.loop
	bsr.w	Z80ReleaseBus
	lea.l	SndEnableFlag(pc),a1
	move.w	#$1234,(a1)
	move.w	#$7,d0
	ori.b	#$1,ccr
	bra.w	.next3
.next2	move.b	d0,(a1)
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
.loop2	move.b	(a0)+,(a1,d2.w)
	opt	oaq-
	opt	osq-
	addi.w	#$1,d2
	opt	oaq+
	opt	osq+
	dbra	d1,.loop2
	move.b	d2,$A00023.l
	lsr.w	#$8,d2
	move.b	d2,$A00022.l
	bsr.w	Z80ReleaseBus
	lea.l	SndEnableFlag(pc),a1
	move.w	#$1234,(a1)
	clr.w	d0
.next3	movem.l	(sp)+,d0-d2/a0-a1
	rts
; Marks all 32 sound slots as empty.
SndSlotsReset	movem.l	d0-d1/a0-a1,-(sp)
	lea.l	SndEnableFlag(pc),a0
	move.w	#$0,$0(a0)
	move.w	#$0,$122(a0)
	lea.l	SndSlotTable(pc),a1
	move.w	#$1F,d1
	move.l	#$FFFFFFFF,d0
.loop	move.l	d0,(a1)+
	dbra	d1,.loop
	move.w	#$1234,$0(a0)
	movem.l	(sp)+,d0-d1/a0-a1
	rts
; Looks for the sound slot whose id matches d0.
SndSlotFind	movem.l	d0-d2/a0-a1,-(sp)
	lea.l	SndEnableFlag(pc),a0
	move.w	#$0,$0(a0)
	lea.l	SndSlotTable(pc),a1
	move.w	$122(a0),d1
	clr.w	d2
.loop	cmpi.w	#$0,d1
	beq.b	.next2
	move.b	$3(a1),d2
	lsr.b	#$4,d2
	cmp.w	d0,d2
	bne.b	.next
	move.w	#$1,(a1)
.next	adda.l	#$4,a1
	opt	oaq-
	opt	osq-
	subi.w	#$1,d1
	opt	oaq+
	opt	osq+
	bra.b	.loop
.next2	move.w	#$1234,$0(a0)
	movem.l	(sp)+,d0-d2/a0-a1
	rts
; Stores d0 in the next free sound slot.
SndSlotAdd	movem.l	d0-d1/a0,-(sp)
	lea.l	SndEnableFlag(pc),a0
	move.w	$122(a0),d1
	lsl.w	#$2,d1
	lea.l	SndSlotTable(pc),a0
	move.l	d0,(a0,d1.w)
	lea.l	SndEnableFlag(pc),a0
	opt	oaq-
	opt	osq-
	addi.w	#$1,$122(a0)
	opt	oaq+
	opt	osq+
	movem.l	(sp)+,d0-d1/a0
	rts
; Counts down every active sound slot and starts the ones that reach zero.
SndSlotsTick	movem.l	d0-d1/a0-a2,-(sp)
	lea.l	SndEnableFlag(pc),a2
	cmpi.w	#$0,$122(a2)
	beq.b	.next3
	lea.l	SndSlotTable(pc),a0
.loop	cmpi.w	#$FFFF,(a0)
	beq.b	.next3
	opt	oaq-
	opt	osq-
	subi.w	#$1,(a0)
	opt	oaq+
	opt	osq+
	bne.b	.next2
	move.b	$3(a0),d0
	andi.b	#$F0,d0
	lsl.w	#$8,d0
	swap	d0
	move.w	$2(a0),d0
	andi.b	#$F,d0
	ori.b	#$80,d0
	bsr.w	Z80PlayIfLoaded
	tst.w	d0
	beq.b	.next
	opt	oaq-
	opt	osq-
	addi.w	#$1,(a0)
	opt	oaq+
	opt	osq+
	bra.b	.next2
.next	lea.l	SndSlotTable(pc),a1
	move.w	SndEnableFlag+$122(pc),d0
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
	bra.b	.loop
.next2	adda.w	#$4,a0
	bra.b	.loop
.next3	movem.l	(sp)+,d0-d1/a0-a2
	rts
; Starts a sound stream from the table at $A00072.
Z80StartStream	movem.l	d1-d2/a0,-(sp)
	bsr.w	Z80RequestBus
	tst.b	$A00072.l
	beq.w	.next8
	cmpi.b	#$1,$A00072.l
	bne.b	.next
	clr.w	d1
	move.b	$A00073.l,d1
	move.w	#$1,d0
	bsr.w	SndFindSource
	bcs.w	.next8
	cmpa.l	#$FFFFFFFF,a0
	beq.w	.next8
	lea.l	SndEnableFlag(pc),a1
	move.l	a0,$126(a1)
	move.l	a0,-(sp)
	bsr.w	PrgRamReadBegin
	bsr.w	PrgRamMapAddr
.loop	move.b	(a0),d0
	cmp.b	(a0),d0
	bne.b	.loop
	lsl.w	#$8,d0
	adda.l	#$1,a0
.loop2	move.b	(a0),d0
	cmp.b	(a0),d0
	bne.b	.loop2
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
	bra.w	.next5
.next	cmpi.b	#$2,$A00072.l
	bne.b	.next3
	movea.l	SndStateVars+$6(pc),a0
	cmpa.l	#$0,a0
	bne.b	.next2
	bsr.w	Z80ReleaseBus
	bsr.w	Z80ReadStatus
	bsr.w	Z80RequestBus
	bra.w	.next8
.next2	clr.l	d0
	move.b	$A00024.l,d0
	lsl.w	#$8,d0
	move.b	$A00025.l,d0
	addi.l	#$A00000,d0
	movea.l	d0,a1
	bra.b	.next5
.next3	cmpi.b	#$3,$A00072.l
	bne.w	.next8
	movea.l	SndStateVars+$6(pc),a0
	cmpa.l	#$0,a0
	bne.b	.next4
	bsr.w	Z80ReleaseBus
	bsr.w	Z80ReadStatus
	bsr.w	Z80RequestBus
	bra.w	.next8
.next4	clr.l	d0
	move.b	$A00026.l,d0
	lsl.w	#$8,d0
	move.b	$A00027.l,d0
	addi.l	#$A00000,d0
	movea.l	d0,a1
.next5	move.l	a0,-(sp)
	bsr.w	PrgRamReadBegin
	bsr.w	PrgRamMapAddr
	move.w	#$1FF,d1
.loop3	move.b	(a0)+,(a1)+
	beq.b	.next6
	dbra	d1,.loop3
	lea.l	SndEnableFlag(pc),a1
	move.l	$12A(a1),d0
	addi.l	#$200,d0
	move.l	d0,$12A(a1)
	movea.l	(sp)+,a0
	bsr.w	PrgRamReadWait
	bra.b	.next8
.next6	suba.l	#$1,a1
	movea.l	(sp)+,a0
	bsr.w	PrgRamReadWait
	clr.l	d0
	move.w	SndStateVars+$A(pc),d0
	cmpi.w	#$FFFF,d0
	beq.b	.next7
	move.b	#$FF,(a1)
	lea.l	SndEnableFlag(pc),a1
	movea.l	$126(a1),a0
	adda.l	#$2,a0
	adda.l	d0,a0
	move.l	a0,$12A(a1)
	bra.b	.next8
.next7	lea.l	SndEnableFlag(pc),a1
	move.l	#$0,$12A(a1)
.next8	move.b	#$0,$A00072.l
	bsr.w	Z80ReleaseBus
	movem.l	(sp)+,d1-d2/a0
	rts
; Finds the sound source for the request in d0/d1 in the list at 4 sources.
SndFindSource	movem.l	d1-d4/a1-a2,-(sp)
	lea.l	SndSourceTable(pc),a1
	move.w	#$4,d2
.loop	cmpi.l	#$FFFFFFFF,(a1)
	beq.w	.next
	movea.l	(a1),a0
	movea.l	a0,a2
	move.l	a0,-(sp)
	bsr.w	PrgRamReadBegin
	bsr.w	PrgRamMapAddr
	clr.l	d3
.loop2	move.b	(a0),d3
	cmp.b	(a0),d3
	bne.b	.loop2
	adda.l	#$1,a0
	lsl.w	#$8,d3
.loop3	move.b	(a0),d3
	cmp.b	(a0),d3
	bne.b	.loop3
	adda.l	#$1,a0
	move.l	d3,d4
	lsl.w	#$2,d4
	adda.l	d4,a2
	adda.l	#$2,a2
.loop4	move.b	(a0),d4
	cmp.b	(a0),d4
	bne.b	.loop4
	cmp.b	d4,d0
	bne.b	.loop8
.loop5	move.b	$1(a0),d4
	cmp.b	$1(a0),d4
	bne.b	.loop5
	cmp.b	d4,d1
	bne.b	.loop8
	clr.w	d0
.loop6	move.b	$2(a0),d0
	cmp.b	$2(a0),d0
	bne.b	.loop6
	lsl.w	#$8,d0
.loop7	move.b	$3(a0),d0
	cmp.b	$3(a0),d0
	bne.b	.loop7
	movea.l	(sp)+,a0
	bsr.w	PrgRamReadWait
	movea.l	a2,a0
	andi.b	#$FE,ccr
	bra.b	.next2
.loop8	clr.l	d4
	move.b	$2(a0),d4
	cmp.b	$2(a0),d4
	bne.b	.loop8
	lsl.w	#$8,d4
.loop9	move.b	$3(a0),d4
	cmp.b	$3(a0),d4
	bne.b	.loop9
	adda.l	d4,a2
	adda.l	#$4,a0
	opt	oaq-
	opt	osq-
	subi.w	#$1,d3
	opt	oaq+
	opt	osq+
	bne.b	.loop4
	movea.l	(sp)+,a0
	bsr.w	PrgRamReadWait
.next	adda.l	#$4,a1
	opt	oaq-
	opt	osq-
	subi.w	#$1,d2
	opt	oaq+
	opt	osq+
	bne.w	.loop
	move.w	#$3,d0
	ori.b	#$1,ccr
.next2	movem.l	(sp)+,d1-d4/a1-a2
	rts
; Stores a sound source pointer by index
SndSetSource	movem.l	d1/a1,-(sp)
	lsl.w	#$2,d1
	lea.l	SndSourceTable(pc),a1
	move.l	a0,(a1,d1.w)
	movem.l	(sp)+,d1/a1
	rts
; Scans a sound list to its $FFFF end
SndScanToEnd	movem.l	d1/a0-a1,-(sp)
	movea.l	a0,a1
.loop	cmpi.w	#$FFFF,(a1)
	bne.b	.next
	clr.w	d0
	bra.b	.next4
.next	move.w	(a1),d0
	move.w	$2(a1),d1
	bsr.w	SndFindSource
	bcs.b	.next3
	cmpi.w	#$0,(a1)
	bne.b	.next2
	cmpi.b	#$6,(a0)
	bcc.b	.next2
	move.w	d0,d1
	move.w	$2(a1),d0
	bsr.w	Z80LoadBlock
	bcs.b	.next3
	bra.w	.next2
.next2	adda.l	#$4,a1
	bra.b	.loop
.next3	ori.b	#$1,ccr
.next4	movem.l	(sp)+,d1/a0-a1
	rts
; Loads a sound bank to the Z80
Z80LoadBank	movem.l	d1-d3/a0-a2,-(sp)
	lea.l	SndEnableFlag(pc),a1
	move.w	#$0,(a1)
	bsr.w	Z80RequestBus
.loop	cmpi.w	#$FFFF,(a0)
	beq.w	.next5
	cmpi.w	#$6,(a0)
	bcc.w	.next4
	lea.l	$A00100.l,a1
	move.w	$2(a0),d0
	move.w	#$3F,d1
.loop2	cmp.b	(a1),d0
	beq.b	.next
	adda.l	#$4,a1
	dbra	d1,.loop2
	bra.w	.next4
.next	clr.w	d0
	move.b	$1(a1),d0
	clr.w	d1
	move.b	$2(a1),d1
	lsl.w	#$8,d1
	move.b	$3(a1),d1
	move.w	d1,d2
	add.w	d0,d2
	lea.l	$A00000.l,a2
.loop3	cmpi.w	#$1F00,d2
	beq.b	.next2
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
	bra.b	.loop3
.next2	clr.w	d1
	move.b	$2(a1),d1
	lsl.w	#$8,d1
	move.b	$3(a1),d1
	move.b	#$FF,(a1)
	move.b	#$FF,$1(a1)
	move.b	#$FF,$2(a1)
	move.b	#$FF,$3(a1)
	lea.l	$A00100.l,a1
	move.w	#$3F,d2
.loop4	cmpi.b	#$FF,(a1)
	bne.w	.next3
	clr.w	d3
	move.b	$2(a1),d3
	lsl.w	#$8,d3
	move.b	$3(a1),d3
	cmp.w	d1,d3
	bcc.b	.next3
	sub.w	d0,d3
	move.b	d3,$3(a1)
	lsr.w	#$8,d3
	move.b	d3,$2(a1)
.next3	dbra	d2,.loop4
	lea.l	$A00022.l,a1
	clr.w	d1
	move.b	(a1),d1
	lsl.w	#$8,d1
	move.b	$1(a1),d1
	sub.w	d0,d1
	move.b	d1,$1(a1)
	lsr.w	#$8,d1
	move.b	d1,(a1)
.next4	adda.l	#$4,a0
	bra.w	.loop
.next5	bsr.w	Z80ReleaseBus
	lea.l	SndEnableFlag(pc),a1
	move.w	#$1234,(a1)
	clr.w	d0
	movem.l	(sp)+,d1-d3/a0-a2
	rts
; Loads the small Z80 driver block
Z80LoadSmall	movem.l	a0-a1,-(sp)
	lea.l	SndEnableFlag(pc),a0
	move.w	#$0,(a0)
	bsr.w	Z80RequestBus
	lea.l	$A00100.l,a0
	move.w	#$FF,d0
.loop	move.b	#$FF,(a0)+
	dbra	d0,.loop
	lea.l	$A00020.l,a0
	lea.l	$A00022.l,a1
	move.b	(a0)+,(a1)+
	move.b	(a0),(a1)
	bsr.w	Z80ReleaseBus
	lea.l	SndEnableFlag(pc),a0
	move.w	#$1234,(a0)
	clr.w	d0
	movem.l	(sp)+,a0-a1
	rts
; Requests the Z80 bus and waits for it.
Z80RequestBus	move.w	#$100,$A11100.l
.loop	btst.b	#$8,$A11100.l
	bne.b	.loop
	rts
; Gives the Z80 bus back.
Z80ReleaseBus	move.w	#$0,$A11100.l
	rts
; Prepares reading from sub-CPU PRG RAM when the address is at or above $80000.
PrgRamReadBegin	movem.l	d0-d1/a1,-(sp)
	cmpa.l	#$80000,a0
	bcc.w	.next2
	move.b	#$3,$A12001.l
.loop	move.w	$A12000.l,d0
	btst	#$1,d0
	beq.b	.loop
	move.l	a0,d0
	swap	d0
	andi.w	#$6,d0
	lsl.w	#$5,d0
	lea.l	PrgRamReadState(pc),a1
	move.w	$A12002.l,d1
	move.w	d1,(a1)
	btst	#$2,d1
	beq.b	.next
	bset	#$1,d0
.next	andi.w	#$FF00,d1
	or.w	d0,d1
	move.w	d1,$A12002.l
.next2	movem.l	(sp)+,d0-d1/a1
	rts
; Waits until the PRG-RAM read window is ready.
PrgRamReadWait	move.l	d0,-(sp)
	cmpa.l	#$80000,a0
	bcc.b	.next3
	move.w	PrgRamReadState(pc),d0
	btst	#$2,d0
	beq.b	.next
	andi.w	#$FFC0,d0
	bset	#$1,d0
	bra.b	.next2
.next	andi.w	#$FFC0,d0
.next2	move.w	d0,$A12002.l
	move.w	#$1,$A12000.l
.loop	move.w	$A12000.l,d0
	btst	#$1,d0
	bne.b	.loop
	move.w	$A12000.l,d0
	btst	#$1,d0
	bne.b	.loop
.next3	move.l	(sp)+,d0
	rts
; Maps a0 into the PRG-RAM window address.
PrgRamMapAddr	move.l	d0,-(sp)
	cmpa.l	#$80000,a0
	bcc.b	.next
	move.l	a0,d0
	andi.l	#$1FFFF,d0
	ori.l	#$20000,d0
	movea.l	d0,a0
.next	move.l	(sp)+,d0
	rts
; Sound engine enable word
SndEnableFlag	dc.b	$00,$00	; ..
; Sound work buffer A
SndBufA	dcb.b	$20,0
; Sound work buffer B
SndBufB	dcb.b	$20,0
; Sound id table
SndIdTable	dcb.b	$10,0
; Sound work buffer C
SndBufC	dcb.b	$10,0
; Sound work buffer D
SndBufD	dcb.b	$10,0
; Sound work buffer E
SndBufE	dcb.b	$10,0
; Sound work buffer F
SndBufF	dcb.b	$20,0
; Sound slot table
SndSlotTable	dcb.b	$80,0
; Data of SndSlotTable (1 row): table or constants used by it.
.next	dc.b	$00,$00	; ..
; Sound engine state variables
SndStateVars	dc.b	$00,$00,$00,$00,$00,$00	; ......
; Data of SndStateVars (1 row): table or constants used by it.
.next	dc.b	$00,$00,$00,$00	; ....
; Data of SndStateVars (1 row): table or constants used by it.
.next2	dc.b	$00,$00	; ..
; Sound miscellaneous buffer
SndMiscBuf	dcb.b	$10,0
; Sound pointers
SndPtrs	dc.b	$00,$00,$00,$00	; ....
; Sound work area
SndWorkBuf	dcb.b	$8C,0
; Program RAM read state
PrgRamReadState	dc.b	$00,$00	; ..
; Sound source pointer table and following data
SndSourceTable	dcb.b	$51,0
	incbin	..\Extracted\SegaCD\MAIN\main_0863D.bin
; Data of SndSourceTable (10 rows): table or constants used by it.
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
