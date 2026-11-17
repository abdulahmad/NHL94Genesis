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
; Data of LoadBootImages (1 row): table or constants used by it.
	dc.b	$00,$02,$00,$00,$FF,$FF	; ......
; Screen setup with inline palette words.
ScreenSetupA	movem.l	d0-d7/a0-a6,-(sp)
	andi.b	#$EF,$BC6E8.l
	bsr.w	SendCmd2Inline
; Inline data read by SendCmd2Inline from the return address (2 rows).
	dc.b	$00,$00,$FC,$00,$E0,$00,$C0,$00,$B0,$00,$00,$06,$00,$20,$00,$00	; ............. ..
	dc.b	$0C,$CC	; ..
	bsr.w	SendCmd3
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
; Inline data read by SendCmd2Inline from the return address (2 rows).
	dc.b	$00,$00,$FC,$00,$E0,$00,$C0,$00,$B0,$00,$00,$06,$00,$20,$00,$00	; ............. ..
	dc.b	$0C,$CC	; ..
	movem.l	(sp)+,d0-d7/a0-a6
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
; Data of AnimTick (2 rows): table or constants used by it.
	dc.b	$00,$1E,$00,$00,$00,$1E,$00,$01,$00,$1E,$00,$01,$00,$04,$00,$01	; ................
	dc.b	$00,$06,$FF,$FF	; ....
; Screen setup, second variant.
ScreenSetupB	andi.b	#$9C,$BC6E8.l
	bsr.w	SendCmd3
	move.w	#$1,d4
	move.w	d4,$10AF0.l
	bsr.w	SendStateWithInline
; Inline data read by SendStateWithInline from the return address (1 row).
	dc.b	$00,$08,$F8,$00,$01,$00,$00,$00	; ........
	movea.l	$109D8.l,a2
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
; Inline data read by SendCmd2Inline from the return address (2 rows).
	dc.b	$00,$00,$FC,$00,$E0,$00,$C0,$00,$B0,$00,$00,$06,$00,$20,$00,$00	; ............. ..
	dc.b	$0C,$CC	; ..
	bsr.w	SendCmd3
	bsr.w	SendCmdF
	move.w	$10BCE.l,$10B2A.l
	move.w	$10BCE.l,$10B2C.l
	moveq	#$1C,d0
	bsr.w	SendCmdD0
	clr.w	$10B22.l
	bsr.w	SendStateInline
; Inline data read by SendStateInline from the return address (1 row).
	dc.b	$00,$06,$FF,$00,$00,$00	; ......
	move.l	#$80,d0
	moveq	#$20,d1
	move.l	#$7FF,d2
	jsr	$E4D6.l
	bsr.w	SendStateInline
; Inline data read by SendStateInline from the return address (1 row).
	dc.b	$00,$06,$FE,$00,$00,$00	; ......
	move.l	#$80,d0
	moveq	#$20,d1
	move.l	#$7FF,d2
	jsr	$E4D6.l
	moveq	#$1C,d4
	bsr.w	SendStateInline
; Inline data read by SendStateInline from the return address (1 row).
	dc.b	$00,$06,$FE,$00,$13,$00	; ......
	movea.l	$10984.l,a1
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
; Inline data read by SendStateInline from the return address (1 row).
	dc.b	$00,$06,$FD,$00,$00,$00	; ......
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
	jsr	$E51C.l
	move.w	d4,$10AFE.l
	movea.l	$1094C.l,a2
	addq.l	#$8,a2
	jsr	$E12A.l
	bsr.w	CopyAnimStateToCmd
	bsr.w	SendStateInline
; Inline data read by SendStateInline from the return address (1 row).
	dc.b	$00,$06,$FF,$00,$00,$00	; ......
	lea.l	$25F0E.l,a1
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
; Inline data read by SendStateInline from the return address (1 row).
	dc.b	$00,$06,$FF,$00,$00,$00	; ......
	lea.l	$25F36.l,a1
.loop2	bsr.w	CalcScrollPhase
	adda.w	(a1),a1
	moveq	#$3F,d4
.loop3	bsr.w	WaitFrameAndUpdate
	bsr.w	WaitFrameAndUpdate
	addq.w	#$1,$10B22.l
	dbra	d4,.loop3
	moveq	#$78,d4
.loop4	bsr.w	WaitFrameAndUpdate
	dbra	d4,.loop4
	tst.w	$2(a1)
	bpl.b	.loop2
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