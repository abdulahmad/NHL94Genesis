RestoreBiosSub48	movem.l	d0-d7/a0-a6,-(sp)
	btst.b	#$2,$FFFF8024.w
	dc.w	$6700,$000A
	dc.w	$6100,$0012
	dc.w	$6100,$0032
.l3AA0	addq.w	#$1,$10AE0.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.l24DAC	btst.b	#$1,$10912.l
	dc.w	$6700,$0010
	bsr.w	RestoreBios_10
	bset.b	#$0,$10912.l
	rts
.l3AC6	bclr.b	#$0,$10912.l
	rts
.l24DD0	btst.b	#$0,$10912.l
	dc.w	$6700,$0006
	bsr.w	RestoreBios_9
.l3AE0	dc.w	$4E75
	dc.b	$4E,$75	; Nu
.l24DE4	dc.b	$48,$E7,$FF,$FE,$48,$E7,$00,$40,$4E,$B9,$00,$00,$E3,$20,$00,$00	; H...H..@N.... ..
	dc.b	$FC,$00,$E0,$00,$C0,$00,$B0,$00,$00,$06,$00,$20,$00,$08,$00,$00	; ........... ....
	dc.b	$4C,$DF,$02,$00,$61,$00,$F8,$06,$2F,$3C,$04,$00,$04,$00,$4E,$B9	; L...a.../<....N.
	dc.b	$00,$01,$05,$40,$30,$3C,$00,$01,$61,$00,$F5,$FA,$4E,$B9,$00,$01	; ...@0<..a...N...
	dc.b	$05,$5C,$4E,$B9,$00,$00,$EA,$76,$61,$00,$01,$52,$4E,$B9,$00,$00	; ..N....va..RN...
	dc.b	$EA,$0C,$22,$39,$00,$00,$EC,$92,$67,$00,$01,$3A	; .."9....g..:
RestoreBiosSub49	movem.l	d1,-(sp)
	move.w	$FFFF8004.w,$EC8E.l
	lea.l	$ECA2.l,a0
	move.w	#$10,d0
	jsr	$5F22.w
	move.w	#$0,d1
	move.w	#$96,d0
	jsr	$5F22.w
	jsr	$EA76.l
	bclr.b	#$2,$FFFF8024.w
	move.l	$602C.w,$ECB0.l
	moveq	#$1B,d0
	jsr	$E370.l
	jsr	$E3BC.l
	movem.l	(sp)+,d1
	movea.l	#$FF8000,a5
	move.w	#$0,$BC6E8.l
	jsr	$EA00.l
	move.l	#$EAE2,-(sp)
	move.l	#$0,-(sp)
	move.l	#$0,-(sp)
	move.l	#$E000,-(sp)
RestoreBiosSub50	move.l	#$0,-(sp)
	move.l	#$0,-(sp)
	move.l	$EC9E.l,-(sp)
	move.l	$EC9A.l,-(sp)
	move.l	d1,-(sp)
	move.w	#$0,-(sp)
	jsr	$ECB4.l
	adda.w	#$26,sp
	tst.w	d0
	dc.w	$6B00,$009A
RestoreBios_11	jsr	$E298.l
	btst	#$7,d1
RestoreBiosSub51	dc.w	$6600,$0012
	move.w	#$1,-(sp)
	jsr	$ECB4.l
	addq.l	#$2,sp
	tst.w	d0
	bge.b	RestoreBios_11
.l3C04	move.w	#$2,-(sp)
	jsr	$ECB4.l
	addq.l	#$2,sp
	jsr	$E3BC.l
	jsr	$E3F8.l
	jsr	$E3EE.l
	jsr	$E416.l
	lea.l	$ECA2.l,a0
	move.w	#$10,d0
	jsr	$5F22.w
	move.w	$EC8E.l,d1
	andi.b	#$F8,d1
	ori.b	#$3,d1
	move.w	#$96,d0
	jsr	$5F22.w
	jsr	$EA76.l
	move.w	#$0,$BC6E8.l
	move.l	#$0,$BC6EC.l
	move.l	$ECB0.l,$602C.w
	bset.b	#$2,$FFFF8024.w
	bset.b	#$2,$FFFF8033.w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.l24F7E	bra.b	.l24F7E
	moveq	#$1A,d0
	jsr	$E370.l
	dc.w	$4E75
	dcb.b	$18,0
	dc.b	$01,$FF,'HOCKEY.SEG',$00,$00,$00,$00	; ..HOCKEY.SEG....
	dc.b	$00,$00	; ..
RestoreBios_12	dc.w	$6000,$00DE
RestoreBios_13	dc.b	$00,$00,$00,$00	; ....
RestoreBios_14	dc.b	$00,$01,$00,$00	; ....
RestoreBios_15	dc.b	$00,$06,$00,$00	; ....
RestoreBios_16	dc.b	$00,$00,$00,$00	; ....
RestoreBios_17	dc.b	$00,$00,$00,$00	; ....
RestoreBios_18	dcb.b	$8,0
RestoreBios_19	dcb.b	$14,0
RestoreBios_20	dc.b	$00,$00,$00,$00	; ....
RestoreBios_21	dcb.b	$A8,0
