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
	beq.w	PadRepeatReturn
	tst.w	d2
	bne.w	.next
	subq.b	#$1,$10B1C.l
	bpl.w	PadRepeatReturn
	move.b	#$4,$10B1C.l
	move.w	d3,d1
	andi.w	#$F,d1
	rts
.next	move.b	#$F,$10B1C.l
; Return and test block of the pad auto-repeat routine
PadRepeatReturn	rts
	tst.w	d3
	beq.b	PadRepeatReturn
	tst.w	d2
	bne.w	.next
	subq.b	#$1,$10B1D.l
	bpl.b	PadRepeatReturn
	move.b	#$4,$10B1D.l
	move.w	d3,d1
	andi.w	#$F,d1
	rts
.next	move.b	#$F,$10B1D.l
	rts
; Auto-repeat counter for held pad directions.
PadAutoRepeat	tst.w	d3
	beq.b	PadRepeatReturn
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
; Command with d0, d1, a0 in the command buffer
SendCmdBlockA	movem.l	d0/d2-d3/a1,-(sp)
	lea.l	$BA450.l,a1
	move.w	d0,(a1)+
	move.w	d1,(a1)+
	move.l	a0,(a1)
	moveq	#$0,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0/d2-d3/a1
	rts
; Command with d0, d1, a0 in the command buffer (second form)
SendCmdBlockB	movem.l	d0/d2-d3/a1,-(sp)
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
; Patches a BIOS vector and raises a flag
HookBiosVector	movem.l	a0-a1,-(sp)
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
; Sends command 6
SendCmd6	movem.l	d0/a0,-(sp)
	moveq	#$6,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0/a0
	rts
; Command with several word arguments
SendCmdWords	movem.l	d0-d3/a0,-(sp)
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
; Command carrying the saved state words
SendCmdState	movem.l	d0-d3/a0/a2-a3,-(sp)
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
; Command sent in a loop over d0
SendCmdLoop	movem.l	d1-d4,-(sp)
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
; Command with arguments taken from a1
SendCmdFromA1	movem.l	a1,-(sp)
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
; Command with a list pointed to by a1
SendCmdListA1	movem.l	d1-d2/a0-a1,-(sp)
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
	beq.w	PadRepeatReturn
	cmpi.w	#$61,d1
	blt.w	.next4
	cmpi.w	#$7A,d1
	bgt.w	.next4
	addi.w	#$FFE0,d1
.next4	addq.w	#$1,d0
	movea.l	#$10570,a0
	tst.b	-$20(a0,d1.w)
	bmi.w	PadRepeatReturn
	addq.w	#$1,d0
	rts
; Sends command $F and keeps the reply word.
SendCmdF	movem.l	d0,-(sp)
	moveq	#$F,d0
	bsr.w	SendCmdD0
	move.w	$BA450.l,$10BCE.l
	movem.l	(sp)+,d0
	rts
; Command with long arguments d4/a2
SendCmdLongs	movem.l	d0-d1/a0-a1,-(sp)
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
; Command copying 8 bytes from a1
SendCmdCopy8	movem.l	d0/a0-a1,-(sp)
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
; Command copying 12 bytes from a1
SendCmdCopy12	movem.l	d0/a0-a1,-(sp)
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
; Sends command $13
SendCmd13	movem.l	a0,-(sp)
	lea.l	$BA450.l,a0
	move.w	d0,(a0)
	moveq	#$13,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,a0
	rts
	bsr.w	.next
	bra.w	SendCmdState
.next	bra.w	.next2
.loop	adda.w	(a1),a1
.next2	dbra	d0,.loop
	rts
; Sends command $14
SendCmd14	movem.l	d0,-(sp)
	moveq	#$14,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0
	rts
; Sends command $15
SendCmd15	movem.l	d0,-(sp)
	moveq	#$15,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0
	rts
; Sends command $16
SendCmd16	movem.l	d0/a0,-(sp)
	lea.l	$BA450.l,a0
	move.w	$10B22.l,(a0)+
	move.w	d0,(a0)+
	moveq	#$16,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0/a0
	rts
; Sends command $19
SendCmd19	movem.l	d0/a0,-(sp)
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
; Command with three word arguments
SendCmdWords3	movem.l	d0-d2/a0,-(sp)
	lea.l	$BA450.l,a0
	move.w	d0,(a0)+
	move.w	d1,(a0)+
	move.w	d2,(a0)+
	moveq	#$18,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0-d2/a0
	rts
.loop	bset.b	#$2,$FF8003.l
	bne.b	.loop
	rts
