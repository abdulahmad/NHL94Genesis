	opt	oaq+
	opt	osq+
; STARTER.BIN PCM chip primitives, file $3FD0-$40F9, runtime $252D0-$253F9.
; Init, start channel 0, stop, read the play address, load one $1000-byte bank.


; Resets the PCM chip: all channels off, then the control register.
PcmInit	movea.l	#$FF0000,a0
	move.b	#$FF,$11(a0)
	moveq	#$14,d0
.next	dbra	d0,.next
	move.b	#$C0,$F(a0)
	moveq	#$14,d0
.next2	dbra	d0,.next2
	move.b	#$FF,$1(a0)
	moveq	#$14,d0
.next3	dbra	d0,.next3
	move.b	#$FF,$3(a0)
	moveq	#$14,d0
.next4	dbra	d0,.next4
	move.b	#$4,$7(a0)
	moveq	#$14,d0
.next5	dbra	d0,.next5
	clr.b	$5(a0)
	moveq	#$14,d0
.next6	dbra	d0,.next6
	clr.b	$B(a0)
	moveq	#$14,d0
.next7	dbra	d0,.next7
	clr.b	$9(a0)
	moveq	#$14,d0
.next8	dbra	d0,.next8
	clr.b	$D(a0)
	moveq	#$14,d0
.next9	dbra	d0,.next9
	move.w	#$88,d0
	move.b	d0,$F(a0)
	moveq	#$14,d0
.next10	dbra	d0,.next10
	move.b	#$FF,$2001(a0)
	move.b	#$FF,$2002(a0)
	rts
; Writes the PCM control register and enables channel 0.
PcmStartChannel0	movea.l	#$FF0000,a0
	move.b	#$80,$F(a0)
	moveq	#$14,d0
.next	dbra	d0,.next
	move.b	#$FE,$11(a0)
	rts
; Switches all PCM channels off.
PcmMuteAllChannels	movea.l	#$FF0000,a0
	move.b	#$FF,$11(a0)
	rts
; Reads the PCM chip status bytes after the settling delays.
PcmReadStatus	movea.l	#$FF0000,a0
	lea.l	$21(a0),a0
	moveq	#$14,d0
.next	dbra	d0,.next
	move.b	(a0),d1
	move.b	(a0),d1
	addq.w	#$2,a0
	moveq	#$14,d0
.next2	dbra	d0,.next2
	moveq	#$0,d0
	move.b	(a0),d0
	move.b	(a0),d0
	lsl.w	#$8,d0
	move.b	d1,d0
	rts
; Writes d0 (with bit 7) to the PCM control register.
PcmSetControl	movea.l	#$FF0000,a0
	move.l	$8(sp),d0
	ori.w	#$80,d0
	move.b	d0,$F(a0)
	moveq	#$14,d0
.next	dbra	d0,.next
	move.b	d0,$F(a0)
	moveq	#$14,d0
.next2	dbra	d0,.next2
	lea.l	$2001(a0),a0
	movea.l	$4(sp),a1
	move.w	#$1FF,d3
.loop	move.b	(a1)+,(a0)
	addq.w	#$2,a0
	move.b	(a1)+,(a0)
	addq.w	#$2,a0
	move.b	(a1)+,(a0)
	addq.w	#$2,a0
	move.b	(a1)+,(a0)
	addq.w	#$2,a0
	move.b	(a1)+,(a0)
	addq.w	#$2,a0
	move.b	(a1)+,(a0)
	addq.w	#$2,a0
	move.b	(a1)+,(a0)
	addq.w	#$2,a0
	move.b	(a1)+,(a0)
	addq.w	#$2,a0
	dbra	d3,.loop
	rts

	opt	oaq-
	opt	osq-
