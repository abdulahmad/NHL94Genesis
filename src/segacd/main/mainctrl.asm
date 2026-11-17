; Writes zeros over all 64 KB of VRAM.
ClearVram	move.l	#$40000000,$C00004.l
	move.w	#$3FFF,d0
	movea.l	#$C00000,a0
	clr.l	d1
.loop	move.l	d1,(a0)
	dbra	d0,.loop
	rts
	bsr.w	WaitDmnaClear
	lea.l	$C00000.l,a0
	lea.l	$23C002.l,a1
	move.w	$23C000.l,d0
.loop2	move.w	(a1)+,(a0)
	dbra	d0,.loop2
	bsr.w	GiveWordRamToSub
	rts
	move.w	$A12022.l,$A11200.l
	rts
	tst.w	$FF6CF8.l
	bne.w	.ex
	moveq	#$0,d1
	move.w	$A12022.l,d1
	move.l	d1,d0
	asl.w	#$1,d0
	lea.l	$FF4E76.l,a0
	adda.l	d0,a0
	move.w	(a0),d2
	move.w	#$4,d0
	bsr.w	Z80CommandSwitch
.ex	rts
	move.w	sr,-(sp)
	move.w	#$2700,sr
	move.w	#$2,d0
	move.w	$A12022.l,d1
	move.w	#$100,d4
	bsr.w	Z80CommandSwitch
	move.w	(sp)+,sr
	rts
	dc.b	$00,$00,$00,$6B,$00,$6A,$00,$75,$00,$7C,$00,$73,$00,$74,$30,$3C	; ...k.j.u.|.s.t0<
	dc.b	$00,$01,$61,$00,$37,$D2,$4E,$75	; ..a.7.Nu
; Reads both pads into $FF4F84/$FF4F85 and updates the edge state.
PollControllers	movem.l	d1/a0,-(sp)
	bsr.w	.next2
	move.b	d0,$FF4F84.l
	bsr.w	.next
	move.b	d0,$FF4F85.l
	movem.l	(sp)+,d1/a0
	rts
.next	movem.l	d1/a0,-(sp)
	lea.l	$A10005.l,a0
	bra.b	.next3
.next2	movem.l	d1/a0,-(sp)
	lea.l	$A10003.l,a0
.next3	moveq	#$0,d0
	move.b	#$0,(a0)
	nop
	nop
	move.b	(a0),d0
	move.b	#$40,(a0)
	nop
	nop
	move.b	(a0),d1
	asl.b	#$2,d0
	andi.b	#$C0,d0
	andi.b	#$3F,d1
	or.b	d1,d0
	not.b	d0
	not.b	d1
	andi.w	#$F,d1
	lea.l	.next4(pc),a0
	andi.b	#$F0,d0
	or.b	(a0,d1.w),d0
	not.b	d0
	movem.l	(sp)+,d1/a0
	rts
.next4	dc.b	$00,$01,$02,$01,$04,$05,$06,$06,$08,$09,$0A,$0A,$08,$09,$0A,$00	; ................
; Decodes pad 1 and computes the newly pressed buttons.
UpdatePad1	move.b	$FF4F84.l,d0
	bsr.w	DecodePadBits
	move.w	$FF4F7C.l,d2
	move.w	d1,$FF4F7C.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
; Decodes pad 2 and computes the newly pressed buttons.
UpdatePad2	move.b	$FF4F85.l,d0
	bsr.w	DecodePadBits
	move.w	$FF4F7E.l,d2
	move.w	d1,$FF4F7E.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
; Inverts the raw pad byte and splits it into direction and button bits.
DecodePadBits	not.b	d0
	clr.w	d1
	move.b	d0,d1
	move.w	d1,-(sp)
	andi.w	#$F0,d0
	andi.w	#$F,d1
	lea.l	$FF4F6C.l,a0
	move.b	(a0,d1.w),d1
	or.w	d1,d0
	move.w	(sp)+,d1
	rts
	dc.b	$08,$00,$04,$08,$06,$07,$05,$08,$02,$01,$03,$08,$08,$08,$08,$08	; ................
	dcb.b	$C,0
; Polls the sub-CPU and controllers
SubCommPoll	movem.l	d0-d7/a0-a6,-(sp)
	btst.b	#$0,$A1200F.l
	beq.w	.next
	bclr.b	#$1,$A1200E.l
	bsr.w	PollControllers
	bsr.w	UpdatePad1
	move.w	d1,d5
	bsr.w	UpdatePad2
	or.w	d1,d5
	cmpi.b	#$80,d5
	bne.w	.next
	bset.b	#$1,$A1200E.l
.next	movem.l	(sp)+,d0-d7/a0-a6
	rts
	rte	
	bset.b	#$6,$A1200E.l
.loop	btst.b	#$6,$A1200F.l
	bne.b	.loop
	bclr.b	#$6,$A1200E.l
	bclr.b	#$7,$A1200E.l
	move.b	#$0,$A1200E.l
	dc.w	$6100,$181A
	move.l	#$FF4F88,-(sp)
	bsr.w	RamImageB
	adda.l	#$4,sp
	bra.w	SubCpuBootReset
	rts	
	bset.b	#$6,$A1200E.l
.loop2	btst.b	#$6,$A1200F.l
	bne.b	.loop2
	bclr.b	#$6,$A1200E.l
	bclr.b	#$7,$A1200E.l
	move.b	#$0,$A1200E.l
	bsr.w	RunSubCommand
	bra.w	SubCpuBootReset
	rts	