RestoreBiosSub41	movem.l	d0-d7/a0-a6,-(sp)
	btst.b	#$2,$FFFF8024.w
	beq.w	.l3AA0
	bsr.w	.l24DAC
	bsr.w	.l24DD0
.l3AA0	addq.w	#$1,$10AE0.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.l24DAC	btst.b	#$1,$10912.l
	beq.w	.l3AC6
	bsr.w	RestoreBios_72
	bset.b	#$0,$10912.l
	rts
.l3AC6	bclr.b	#$0,$10912.l
	rts
.l24DD0	btst.b	#$0,$10912.l
	beq.w	.l3AE0
	bsr.w	RestoreBios_71
.l3AE0	dc.w	$4E75
	dc.b	$4E,$75	; Nu
RestoreBios_80	movem.l	d0-d7/a0-a6,-(sp)
RestoreBiosSub42	movem.l	a1,-(sp)
	dc.w	$4EB9,$0000,$E320
	dc.b	$00,$00,$FC,$00,$E0,$00,$C0,$00,$B0,$00,$00,$06,$00,$20,$00,$08	; ............. ..
	dc.b	$00,$00	; ..
RestoreBiosSub43	movem.l	(sp)+,a1
	bsr.w	RestoreBios_68
	move.l	#$4000400,-(sp)
	jsr	$10540.l
	move.w	#$1,d0
	bsr.w	RestoreBios_61
	jsr	$1055C.l
	jsr	$EA76.l
	bsr.w	RestoreBios_84
	jsr	$EA0C.l
	move.l	$EC92.l,d1
	beq.w	RestoreBios_82
RestoreBiosSub44	movem.l	d1,-(sp)
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
RestoreBiosSub45	move.l	#$0,-(sp)
	move.l	#$0,-(sp)
	move.l	$EC9E.l,-(sp)
	move.l	$EC9A.l,-(sp)
	move.l	d1,-(sp)
	move.w	#$0,-(sp)
	jsr	$ECB4.l
	adda.w	#$26,sp
	tst.w	d0
	bmi.w	RestoreBios_83
RestoreBios_81	jsr	$E298.l
	btst	#$7,d1
RestoreBiosSub46	bne.w	.l3C04
	move.w	#$1,-(sp)
	jsr	$ECB4.l
	addq.l	#$2,sp
	tst.w	d0
	bge.b	RestoreBios_81
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
RestoreBios_82	movem.l	(sp)+,d0-d7/a0-a6
	rts
RestoreBios_83	bra.b	RestoreBios_83
RestoreBios_84	moveq	#$1A,d0
	jsr	$E370.l
	dc.w	$4E75
	dcb.b	$18,0
	dc.b	$01,$FF,'HOCKEY.SEG',$00,$00,$00,$00	; ..HOCKEY.SEG....
	dc.b	$00,$00	; ..
RestoreBios_85	dc.w	$6000,$00DE
RestoreBios_86	dc.b	$00,$00,$00,$00	; ....
RestoreBios_87	dc.b	$00,$01,$00,$00	; ....
RestoreBios_88	dc.b	$00,$06,$00,$00	; ....
RestoreBios_89	dc.b	$00,$00,$00,$00	; ....
RestoreBios_90	dc.b	$00,$00,$00,$00	; ....
RestoreBios_91	dcb.b	$8,0
RestoreBios_92	dcb.b	$14,0
RestoreBios_93	dc.b	$00,$00,$00,$00	; ....
RestoreBios_94	dcb.b	$A8,0
