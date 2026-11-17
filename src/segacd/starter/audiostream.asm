	opt	oaq+
	opt	osq+
; STARTER.BIN audio stream API. Runtime $2638C-$26603 (file $508C-$5303).
; Nine Sierra C functions. The name sits after each rts.
; Assemble with /o oz-.



; C function AudioPlayPos (Sierra C name tag follows it).
AudioPlayPos
	link	a6,#$FFFC
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	moveq	#-1,d0
	cmp.l	(a4),d0
	bne.b	.l263A0
	moveq	#$0,d0
	bra.b	.l263C0
.l263A0	jsr	RestoreBios_110(pc)
	moveq	#$C,d1
	asr.l	d1,d0
	move.l	d0,-$4(a6)
	move.l	(a4),d0
	moveq	#$8,d1
	jsr	GetData_16(pc)
	move.l	-$4(a6),d1
	cmp.l	d1,d0
	beq.b	.l263BE
	addq.l	#$1,(a4)
.l263BE	move.l	(a4),d0
.l263C0	movea.l	-$8(a6),a4
	unlk	a6
	rts
; AudioPlayPos
	dc.b	$8C,'AudioPlayPos',$00,$00,$00	; .AudioPlayPos...
; C function AudioInit (Sierra C name tag follows it).
AudioInit
	link	a6,#$0
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	moveq	#-1,d0
	move.l	d0,(a4)
	moveq	#$0,d1
	move.l	d1,$4(a4)
	move.l	d1,$8(a4)
	move.l	d1,$C(a4)
	jsr	PcmInit(pc)
	movea.l	-$4(a6),a4
	unlk	a6
	rts
; AudioInit
	dc.b	$89,'AudioInit',$00,$00	; .AudioInit..
; C function AudioIdle (Sierra C name tag follows it).
AudioIdle
	link	a6,#$0
	movem.l	d7/a4,-(sp)
	movea.l	$8(a6),a4
	move.l	a4,-(sp)
	jsr	AudioPlayPos(pc)
	move.l	d0,d7
	tst.l	$C(a4)
	addq.w	#$4,sp
	beq.b	.l2646A
	move.l	$4(a4),d0
	sub.l	d7,d0
	moveq	#$8,d1
	cmp.l	d0,d1
	ble.b	.l2646A
	move.l	$4(a4),d0
	moveq	#$8,d1
	jsr	GetData_16(pc)
	move.l	d0,-(sp)
	move.l	$8(a4),-(sp)
	jsr	PcmSetControl(pc)
	addq.l	#$1,$4(a4)
	addi.l	#$1000,$8(a4)
	subi.l	#$1000,$C(a4)
	tst.l	$C(a4)
	addq.w	#$8,sp
	bge.b	.l2646A
	moveq	#$0,d0
	move.l	d0,$C(a4)
.l2646A	movem.l	-$8(a6),d7/a4
	unlk	a6
	rts
; AudioIdle
	dc.b	$89,'AudioIdle',$00,$00	; .AudioIdle..
; C function AudioFeed (Sierra C name tag follows it).
AudioFeed
	link	a6,#$0
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	move.l	a4,-(sp)
	jsr	AudioIdle(pc)
	move.l	$C(a6),$8(a4)
	move.l	$10(a6),$C(a4)
	move.l	a4,-(sp)
	jsr	AudioIdle(pc)
	moveq	#-1,d0
	cmp.l	(a4),d0
	addq.w	#$8,sp
	bne.b	GetData_8
	bra.b	GetData_7
GetData_6	move.l	a4,-(sp)
	jsr	AudioIdle(pc)
	addq.w	#$4,sp
GetData_7	tst.l	$C(a4)
	ble.b	.l264C2
	moveq	#$8,d0
	cmp.l	$4(a4),d0
	bgt.b	GetData_6
.l264C2	jsr	PcmStartChannel0(pc)
	moveq	#$0,d0
	move.l	d0,(a4)
GetData_8	movea.l	-$4(a6),a4
	unlk	a6
	rts
; AudioFeed
	dc.b	$89,'AudioFeed',$00,$00	; .AudioFeed..
; C function AudioSilence (Sierra C name tag follows it).
AudioSilence
	link	a6,#$0
	movem.l	d3/d7/a3-a4,-(sp)
	movea.l	$8(a6),a3
	moveq	#-1,d0
	cmp.l	(a3),d0
	bne.b	.l2653C
	pea.l	$1000.w
	jsr	mmalloc(pc)
	movea.l	d0,a4
	moveq	#$0,d7
	move.l	#$400,d3
	addq.w	#$4,sp
.l26504	move.l	d7,d0
	asl.l	#$2,d0
	moveq	#$0,d1
	move.l	d1,(a4,d0.l)
	move.l	d7,d0
	addq.l	#$1,d7
	cmp.l	d7,d3
	bgt.b	.l26504
	moveq	#$0,d7
.l26518	move.l	d7,-(sp)
	move.l	a4,-(sp)
	jsr	PcmSetControl(pc)
	addq.w	#$8,sp
	move.l	d7,d0
	addq.l	#$1,d7
	moveq	#$8,d0
	cmp.l	d7,d0
	bgt.b	.l26518
	move.l	a4,-(sp)
	jsr	ffree(pc)
	jsr	PcmStartChannel0(pc)
	moveq	#$0,d0
	move.l	d0,(a3)
	addq.w	#$4,sp
.l2653C	movem.l	-$10(a6),d3/d7/a3-a4
	unlk	a6
	rts
; AudioSilence
	dc.b	$8C,'AudioSilence',$00,$00,$00	; .AudioSilence...
; C function AudioStop (Sierra C name tag follows it).
AudioStop
	link	a6,#$0
	jsr	PcmMuteAllChannels(pc)
	unlk	a6
	rts
; AudioStop
	dc.b	$89,'AudioStop',$00,$00	; .AudioStop..
; C function AudioTicks (Sierra C name tag follows it).
AudioTicks
	link	a6,#$FFFC
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	move.l	a4,-(sp)
	jsr	AudioPlayPos(pc)
	moveq	#$C,d0
	move.l	(a4),d1
	lsl.l	d0,d1
	move.l	d1,-$4(a6)
	jsr	RestoreBios_110(pc)
	move.l	#$FFF,d1
	and.l	d0,d1
	move.l	-$4(a6),d0
	or.l	d0,d1
	move.l	d1,d0
	movea.l	-$8(a6),a4
	unlk	a6
	rts
; AudioTicks
	dc.b	$8A,'AudioTicks',$00,$00,$00	; .AudioTicks...
; C function AudioTime (Sierra C name tag follows it).
AudioTime
	link	a6,#$0
	move.l	$8(a6),-(sp)
	jsr	AudioTicks(pc)
	move.l	d0,d1
	move.l	$C(a6),d0
	jsr	GetData_14(pc)
	; SNASM rewrites add.l #imm,dn into addi.l. The disc is D0BC.
	dc.w	$D0BC
	dc.l	$00001F40
	move.l	#$3E80,d1
	jsr	GetData_15(pc)
	unlk	a6
	rts
; AudioTime
	dc.b	$89,'AudioTime',$00,$00	; .AudioTime..
; C function AudioBusy (Sierra C name tag follows it).
AudioBusy
	link	a6,#$0
	movea.l	$8(a6),a0
	move.w	$E(a0),d0
	unlk	a6
	rts
; AudioBusy
	dc.b	$89,'AudioBusy',$00,$00	; .AudioBusy..

	opt	oaq-
	opt	osq-
