; MAIN.BIN $12C0-$183F ($FF12C0-$FF183F). Emitted by tools/emit_m68k.py.
; VDP writes and word-RAM copies. Stops on the rts before the zero pad.



	lea.l	$23A450.l,a1
	move.w	(a1),d2
	lea.l	$C00000.l,a0
	move.l	#$40020010,$4(a0)
	move.w	d2,(a0)
	rts
	move.w	$23A450.l,$C00004.l
	rts
	movea.l	#$C00000,a0
	move.l	#$40000010,$4(a0)
	move.l	#$0,(a0)
	move.w	#$8B00,$4(a0)
	move.w	#$921C,$4(a0)
	bclr.b	#$4,$23C6E8.l
	bsr.w	ClearVdpPlanes
	rts
	move.w	#$800,d0
	move.w	$FF2852.l,d1
	move.w	#$7FF,d2
	bsr.w	VdpSetWriteAddrD1
	move.w	#$1000,d0
	move.w	$FF2856.l,d1
	move.w	#$7FF,d2
	bsr.w	VdpSetWriteAddrD1
	rts
	lea.l	$23A450.l,a1
	move.w	(a1)+,$FF2A24.l
	move.w	(a1)+,d0
	movea.l	#$C00000,a0
	move.l	#$40020010,$4(a0)
	add.w	$FF2A24.l,d0
	move.w	d0,(a0)
	rts
	move.w	$23A450.l,d0
	movea.l	#$C00000,a0
	move.l	#$40020010,$4(a0)
	move.w	d0,(a0)
	rts
	move.w	#$8164,$C00004.l
	move.w	#$8C00,$C00004.l
	move.w	#$8700,$C00004.l
	move.w	#$9001,$C00004.l
	move.w	#$8238,$C00004.l
	move.w	#$8407,$C00004.l
	move.w	#$8578,$C00004.l
	move.w	#$8D3D,$C00004.l
	move.w	#$831C,$C00004.l
	move.w	#$9100,$C00004.l
	move.w	#$9200,$C00004.l
	move.w	#$8F02,$C00004.l
	move.w	#$8B00,$C00004.l
	move.l	#$74000003,$C00004.l
	move.w	#$0,$C00000.l
	move.w	#$0,$C00000.l
	move.l	#$40000010,$C00004.l
	move.w	#$0,$C00000.l
	move.w	#$0,$C00000.l
	move.l	#$70000003,$C00004.l
	move.l	#$0,$C00000.l
	rts
	move.w	sr,-(sp)
	move.w	#$2700,sr
	bset.b	#$0,$A12014.l
.loop9	btst.b	#$1,$A12024.l
	beq.b	.loop9
	bsr.w	DispatchAfter
	bsr.w	GiveWordRAM
	bsr.w	DispatchTail
	move.w	(sp)+,sr
	move.w	#$8004,$C00004.l
	bsr.w	ClearMainComm
	lea.l	$FF2E00.l,a0
	move.l	#$FF283A,-(sp)
	jsr	(a0)
	addq.l	#$4,sp
	move.l	#$FF24E4,$FFFFFD08.w
	bsr.w	ClearMainComm
	bsr.w	SyncFlag7
	bsr.w	WaitModeBit2
	bsr.w	GiveWordRAM
	move.w	#$8164,$C00004.l
	addq.l	#$8,sp
	jmp	$FF103A.l
	movea.l	#$C00000,a0
	move.w	#$9100,$4(a0)
	move.w	#$9213,$4(a0)
	move.w	#$8B03,$4(a0)
	rts
	lea.l	$23A450.l,a0
	move.w	(a0),$FF2A24.l
	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	movea.l	#$C00000,a0
	move.l	#$40000010,$4(a0)
	move.w	$FF2A24.l,(a0)
	move.w	(sp)+,$23C6E8.l
	rts
	movem.l	d0-d7/a0-a6,-(sp)
	bset.b	#$0,$A12000.l
	btst.b	#$2,$A12024.l
	beq.w	.next10
	bsr.w	TakeWordRam
	btst.b	#$4,$23C6E8.l
	bne.w	.next9
	bsr.w	TickTimers
	btst.b	#$2,$23C6E8.l
	bne.w	.next6
	bclr.b	#$1,$23C6E8.l
	bne.w	.next7
	bclr.b	#$0,$23C6E8.l
	bne.w	.next8
	bra.w	.next9
.next6	bclr.b	#$0,$23C6E8.l
	bne.w	.next8
	bclr.b	#$1,$23C6E8.l
	beq.w	.next9
.next7	bsr.w	VramRestoreFromList
	bset.b	#$2,$23C6E8.l
	bra.w	.next9
.next8	bsr.w	.next11
	bsr.w	.next12
	bclr.b	#$2,$23C6E8.l
.next9	bsr.w	ReadPads
	bsr.w	ReleaseWordRam
.next10	movem.l	(sp)+,d0-d7/a0-a6
	rte
.next11	bclr.b	#$6,$23C6E8.l
	beq.w	RtsStub
	lea.l	$23C368.l,a0
	move.w	#$1C0,d0
	move.w	$FF284E.l,d1
	bra.w	CopyToVdp
.next12	bclr.b	#$5,$23C6E8.l
	beq.w	RtsStub
	lea.l	$23B1E8.l,a0
	move.w	#$8C0,d0
	move.w	$FF2862.l,d1
	asl.w	#$5,d1
	bra.w	CopyToVdp
; Reads both control pads (or the CD-side pad state) into $FF284A/$FF284B.
ReadPads	btst.b	#$3,$A12024.l
	bne.w	.next
	lea.l	$A10003.l,a0
	bsr.w	.next2
	move.b	d0,$FF284A.l
	lea.l	$A10005.l,a0
	bsr.w	.next2
	move.b	d0,$FF284B.l
	move.b	$FF284A.l,d0
	lsl.w	#$8,d0
	move.b	$FF284B.l,d0
	move.w	d0,$A1201C.l
	rts
.next	lea.l	$A10003.l,a0
	move.b	#$C,$A10005.l
	bsr.w	.next2
	move.b	d0,$FF284A.l
	move.b	#$1C,$A10005.l
	bsr.w	.next2
	move.b	d0,$FF284B.l
	move.b	#$2C,$A10005.l
	bsr.w	.next2
	move.b	d0,$FF284C.l
	move.b	#$3C,$A10005.l
	bsr.w	.next2
	move.b	d0,$FF284D.l
	move.b	$FF284A.l,d0
	lsl.w	#$8,d0
	move.b	$FF284B.l,d0
	move.w	d0,$A1201C.l
	move.b	$FF284C.l,d0
	lsl.w	#$8,d0
	move.b	$FF284D.l,d0
	move.w	d0,$A1201E.l
	rts
.next2	move.b	#$0,(a0)
	nop
	nop
	move.b	(a0),d0
	move.b	#$40,(a0)
	asl.b	#$2,d0
	andi.b	#$C0,d0
	move.b	(a0),d1
	andi.b	#$3F,d1
	or.b	d1,d0
	not.b	d0
; Bare rts target
RtsStub	rts
; Vblank timer countdown at $23A8D0.
TickTimers	btst.b	#$4,$23C6E8.l
	bne.b	RtsStub
	tst.w	$23A8D0.l
	bmi.b	RtsStub
	cmpi.w	#$64,$23A8D0.l
	beq.w	.next4
	subq.w	#$1,$23A8D0.l
	bmi.b	RtsStub
	clr.l	d0
	move.w	$23A8D0.l,d0
	cmpi.w	#$18,d0
	bgt.b	RtsStub
	divu.w	#$3,d0
	swap	d0
	asl.w	#$2,d0
	moveq	#$2,d3
	asl.w	d0,d3
	moveq	#$E,d5
	asl.w	d0,d5
	move.w	d5,d4
	not.w	d4
	movea.l	#$23A850,a1
	movea.l	#$C00000,a0
	clr.w	d6
.loop	move.w	d3,d2
	move.w	d6,d0
	swap	d0
	move.w	#$20,d0
	move.l	d0,$4(a0)
	move.w	(a0),d7
	move.w	d7,d0
	and.w	d5,d0
	move.w	(a1)+,d1
	and.w	d5,d1
	cmp.w	d1,d0
	beq.w	.next2
	blt.w	.next
	neg.w	d2
.next	add.w	d2,d0
	and.w	d4,d7
	or.w	d0,d7
	move.l	#$C000,d0
	move.b	d6,d0
	swap	d0
	move.l	d0,$4(a0)
	move.w	d7,(a0)
.next2	addq.w	#$2,d6
	cmpi.w	#$80,d6
	bne.b	.loop
	rts
	movem.l	d1-d4,-(sp)
	clr.w	d4
	moveq	#$2,d3
	moveq	#$E,d2
.loop2	move.w	d0,d1
	and.w	d2,d1
	beq.w	.next3
	add.w	d2,d1
	and.w	d2,d1
	or.w	d1,d4
.next3	asl.w	#$4,d2
	dbra	d3,.loop2
	move.w	d4,d0
	movem.l	(sp)+,d1-d4
	rts
.next4	movem.l	d0/a0-a1,-(sp)
	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	movea.l	#$23A850,a1
	movea.l	#$C00000,a0
	move.l	#$C0000000,$4(a0)
	moveq	#$1F,d0
.loop3	move.l	(a1)+,(a0)
	dbra	d0,.loop3
	st.b	$23A8D0.l
	move.w	(sp)+,$23C6E8.l
	movem.l	(sp)+,d0/a0-a1
	rts
; Waits for and takes word RAM for the main CPU.
TakeWordRam	btst.b	#$1,$FF2A16.l
	beq.w	.next
	bsr.w	WaitWordRAM
	bset.b	#$0,$FF2A16.l
	rts
.next	bclr.b	#$0,$FF2A16.l
	rts
; Gives word RAM back to the sub CPU if it was taken.
ReleaseWordRam	btst.b	#$0,$FF2A16.l
	beq.w	.ex
	bsr.w	GiveWordRAM
.ex	rts
; Copies each saved region from the list at $23A8D2 back to the VDP, then the base region.
VramRestoreFromList	lea.l	$23AF16.l,a0
	move.w	$23B1E6.l,d0
	move.w	$FF2850.l,d1
	bsr.w	CopyToVdp
	movea.l	$23AF12.l,a6
	adda.l	#$180000,a6
	btst.b	#$0,$23C6EA.l
	beq.w	.next
	lea.l	$23A8D2.l,a5
	cmpa.l	a5,a6
	beq.w	RtsStub
.loop	movea.l	(a5)+,a0
	move.w	(a5)+,d0
	move.w	(a5)+,d1
	adda.l	#$180000,a0
	bsr.w	CopyToVdp
	cmpa.l	a6,a5
	bcs.b	.loop
	rts
.loop2	move.w	-(a6),d1
	move.w	-(a6),d0
	movea.l	-(a6),a0
	adda.l	#$180000,a0
	bsr.w	CopyToVdp
.next	cmpa.l	#$23A8D2,a6
	bne.b	.loop2
	rts
	bsr.w	ReadPads
	rts

