LF64_17	movem.l	d0-d7/a0-a3,-(sp)
	movea.l	#$BC000,a0
	move.w	d0,d4
	movea.w	d1,a1
	movea.w	d2,a2
	swap	d1
	swap	d2
	move.w	d1,d5
	move.w	d2,d6
	move.w	d3,d7
	move.w	d3,(a0)+
	move.w	#$8F01,(a0)+
.l283C	move.w	d4,d0
	move.w	d5,d1
	move.w	d6,d2
	move.w	#$8154,(a0)+
	move.w	#$9300,d3
	move.b	d0,d3
	move.w	d3,(a0)+
	move.w	#$9400,d3
	lsr.w	#$8,d0
	move.b	d0,d3
	move.w	d3,(a0)+
	move.w	#$9500,d3
	move.b	d2,d3
	move.w	d3,(a0)+
	move.w	#$9600,d3
	lsr.w	#$8,d2
	move.b	d2,d3
	move.w	d3,(a0)+
	move.w	#$97C0,(a0)+
	clr.l	d0
	move.w	d1,d0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	swap	d0
	ori.w	#$C0,d0
	move.l	d0,(a0)+
	add.w	a1,d5
	add.w	a2,d6
	dbra	d7,.l283C
	move.w	#$8,$DE(a6)
.l288C	tst.w	$DE(a6)
	bne.w	.l288C
	movem.l	(sp)+,d0-d7/a0-a3
	rts
LF64Sub4	movem.l	d0-d4,-(sp)
	move.w	#$50,$E0(a6)
	move.w	d0,d3
	swap	d0
	move.w	d1,d4
	swap	d1
.l28AC	move.w	d0,$E4(a6)
	move.w	d1,$E2(a6)
	move.w	#$6,$DE(a6)
.l28BA	tst.w	$DE(a6)
	bne.w	.l28BA
	add.w	d3,d0
	add.w	d4,d1
	dbra	d2,.l28AC
	movem.l	(sp)+,d0-d4
	rts
LF64_18	dc.b	$16,'Power play adva'	; .Power play adva
	dc.b	'ntage',$00,$1E,'Penalty k'	; ntage..Penalty k
	dc.b	'illing disadvant'	; illing disadvant
	dc.b	$61,$67,$65,$00,$15,'Home team a'	; age..Home team a
	dc.b	'dvantage',$00,$18,'Road t'	; dvantage..Road t
	dc.b	'eam disadvantage'	; eam disadvantage
	dc.b	$00,$14,'Number of forw'	; ..Number of forw
	dc.b	'ards',$00,$16,'Number of '	; ards..Number of 
	dc.b	'defensemen',$00	; defensemen.
LF64_19	dc.b	$0B,'Goalie # ',$00	; .Goalie # .
LF64_20	dc.b	$0B,'Player # ',$00,$00	; .Player # ..
LF64_21	movem.l	d0-d2,-(sp)
	moveq	#$1,d0
	moveq	#$0,d2
	abcd.b	d0,d1
	moveq	#$0,d1
	bra.w	.l2984
.l2982	abcd.b	d0,d1
.l2984	dbra	d7,.l2982
	move.l	d1,d7
	cmpi.w	#$9,d1
	bgt.w	.l29A0
	addi.b	#$30,d7
	ori.l	#$2000,d7
	bra.w	.l29B0
.l29A0	ror.b	#$4,d7
	lsl.w	#$4,d7
	lsr.b	#$4,d7
	addi.w	#$3030,d7
	ori.l	#$200000,d7
.l29B0	movem.l	(sp)+,d0-d2
	rts
LF64_22	movem.l	d0-d2,-(sp)
	moveq	#$1,d0
	moveq	#$0,d1
	moveq	#$0,d2
	bra.w	.l29CC
.l29C4	abcd.b	d0,d1
	bcc.w	.l29CC
	addq.w	#$1,d2
.l29CC	dbra	d7,.l29C4
	move.l	d1,d7
	tst.w	d2
	bne.w	.l2A02
	cmpi.w	#$9,d1
	bgt.w	.l29EE
	addi.b	#$30,d7
	ori.l	#$20202500,d7
	bra.w	.l2A18
.l29EE	ror.b	#$4,d7
	lsl.w	#$4,d7
	lsr.b	#$4,d7
	addi.w	#$3030,d7
	ori.l	#$20250000,d7
	bra.w	.l2A18
.l2A02	ror.b	#$4,d7
	lsl.w	#$4,d7
	lsr.b	#$4,d7
	lsl.l	#$8,d7
	move.b	d2,d7
	addi.l	#$303030,d7
	ori.l	#$25000000,d7
.l2A18	movem.l	(sp)+,d0-d2
	rts
LF64Sub5	movem.l	d0-d2/a0-a1,-(sp)
	lea.l	.l2A50(pc),a1
	moveq	#$0,d2
	clr.b	(a1)+
.l2A2A	move.l	d0,d1
	divu.w	#$A,d1
	swap	d1
	move.w	d1,d2
	addi.b	#$30,d1
	move.b	d1,(a1)+
	sub.l	d2,d0
	divu.w	#$A,d0
	bne.w	.l2A2A
.l2A44	move.b	-(a1),(a0)+
	bne.w	.l2A44
	movem.l	(sp)+,d0-d2/a0-a1
	rts
.l2A50	dcb.b	$50,0
LF64_23	movem.l	d0-d7/a1-a5,-(sp)
	moveq	#$0,d0
	movea.l	$1C(a6),a1
	movea.l	$48(a6),a2
	move.w	$7C(a6),d0
	cmpi.w	#$0,$18(a6)
	beq.w	.l2AC8
	movea.l	$20(a6),a1
	movea.l	$4C(a6),a2
	move.w	$7E(a6),d0
.l2AC8	move.w	$80(a6),d2
	add.w	d2,d2
	move.w	(a2,d2.w),d1
	bpl.w	.l2AE6
	neg.w	d1
	cmpi.w	#$40,d1
	bne.w	.l2AE6
	moveq	#$0,d1
	clr.w	$80(a6)
.l2AE6	movea.l	$86(a6),a2
	add.l	d0,d0
	add.l	d0,d0
	movea.l	(a2,d0.l),a1
	move.w	(a1),d0
	movea.l	a1,a2
	adda.l	d0,a2
	bra.w	.l2B02
	dc.b	$30,$12,$45,$F2,$08,$08	; 0.E...
.l2B02	dc.b	$51,$C9,$FF,$F8,$30,$12,$41,$F2,$08,$00,$2D,$48,$00,$50,$57,$40	; Q...0.A...-H.PW@
	dc.b	$20,$4A,$54,$88,$22,$6E,$00,$8E,$12,$18,$67,$00,$00,$08,$12,$C1	;  JT."n....g.....
	dc.b	$51,$C8,$FF,$F6,$12,$BC,$00,$00,$20,$6E,$00,$8E,$10,$18,$0C,$00	; Q....... n......
	dc.b	$00,$20,$66,$00,$FF,$F8,$4B,$FA,$15,$1F,$2D,$4D,$00,$9A,$3D,$7C	; . f...K...-M..=|
	dc.b	$00,$02,$00,$A6,$4B,$FA,$14,$62,$2D,$4D,$00,$9E,$4B,$FA,$14,$34	; ....K..b-M..K..4
	dc.b	'&H"n',$00,$2C,$24,$6E,$00,$30,$0C,$6E,$00,$00,$00,$18	; &H"n.,$n.0.n....
	dc.b	$67,$00,$00,$0A,$22,$6E,$00,$3C,$24,$6E,$00,$40,$20,$09,$67,$00	; g..."n.<$n.@ .g.
	dc.b	$00,$A4,$70,$00,$74,$FE,$28,$49,$D9,$FC,$00,$00,$00,$05,$20,$4B	; ..p.t.(I...... K
	dc.b	$10,$18,$12,$1C,$00,$00,$00,$20,$00,$01,$00,$20,$B2,$00,$67,$00	; ....... ... ..g.
	dc.b	$FF,$F0,$0C,$2C,$00,$2C,$FF,$FF,$67,$00,$00,$28,$72,$00,$32,$11	; ...,.,..g..(r.2.
	dc.b	$43,$F1,$18,$00,$0C,$69,$65,$6C,$00,$04,$67,$00,$00,$3A,$0C,$69	; C....iel..g..:.i
	dc.b	$65,$6E,$00,$04,$66,$00,$FF,$E8,$32,$11,$43,$F1,$18,$00,$60,$00	; en..f...2.C...`.
	dc.b	$FF,$B6,$2D,$49,$00,$44,$30,$2E,$00,$5A,$D0,$40,$3D,$75,$00,$00	; ..-I.D0..Z.@=u..
	dc.b	$00,$58,$6A,$00,$00,$48,$3D,$7C,$00,$00,$00,$B0,$04,$6E,$00,$01	; .Xj..H=|.....n..
	dc.b	$00,$5A,$60,$00,$FF,$E2,$52,$42,$67,$00,$00,'*"JK',$FA	; .Z`...RBg..*"JK.
	dc.b	$14,$93,$2D,$4D,$00,$9A,$3D,$7C,$00,$05,$00,$A6,$4B,$FA,$13,$B8	; ..-M..=|....K...
	dc.b	$2D,$4D,$00,$9E,$4B,$FA,$13,$8A,$20,$09,$67,$00,$00,$08,$70,$00	; -M..K... .g...p.
	dc.b	$60,$00,$FF,$64,$2D,$7C,$00,$00,$00,$00,$00,$44,$20,$6E,$00,$8E	; `..d-|.....D n..
	dc.b	$4C,$DF,$3E,$FF,$4E,$75	; L.>.Nu
LF64_24	move.w	d0,$E0(a6)
	swap	d0
	move.w	d0,$E2(a6)
	move.l	$62(a6),$E4(a6)
	move.w	#$2,$DE(a6)
.l2C3E	tst.w	$DE(a6)
	bne.w	.l2C3E
	rts
	move.w	d0,$E0(a6)
	swap	d0
	move.w	d0,$E2(a6)
	move.l	#$7A1,$E4(a6)
	move.w	#$2,$DE(a6)
.l2C60	tst.w	$DE(a6)
	bne.w	.l2C60
	rts
LF64_25	move.w	(a1)+,d1
	subq.w	#$1,d1
	move.w	d1,d2
	move.w	(a1)+,d7
	subq.w	#$1,d7
.l2C74	moveq	#$0,d4
	move.w	d3,d4
	bsr.w	LF64_26
.l2C7C	btst.b	#$7,$FF800E.l
	bne.b	.l2C7C
	move.l	d4,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.l2C9C	btst.b	#$6,$FF800E.l
	beq.b	.l2C9C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l2CB6	btst.b	#$6,$FF800E.l
	bne.b	.l2CB6
	bclr.b	#$7,$FF800F.l
.l2CC8	move.w	(a1)+,d4
	btst	#$D,d4
	bne.w	.l2CDE
	tst.w	$B2(a6)
	beq.w	.l2CDE
	ori.w	#$6000,d4
.l2CDE	add.w	d5,d4
.l2CE0	btst.b	#$7,$FF800E.l
	bne.b	.l2CE0
	move.w	d4,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.l2D00	btst.b	#$6,$FF800E.l
	beq.b	.l2D00
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l2D1A	btst.b	#$6,$FF800E.l
	bne.b	.l2D1A
	bclr.b	#$7,$FF800F.l
	dbra	d2,.l2CC8
	add.w	d6,d3
	move.w	d1,d2
	dbra	d7,.l2C74
	rts
LF64_26	andi.l	#$FFFF,d4
	lsl.l	#$2,d4
	lsr.w	#$2,d4
	swap	d4
	addi.l	#$40000000,d4
	rts
LF64_27	addq.w	#$1,$EC(a6)
	rts
LF64_28	move.w	#$1,$102(a6)
	addi.l	#$1,$96(a6)
	cmpi.w	#$2,$DE(a6)
	beq.w	.l3272
	cmpi.w	#$1,$DE(a6)
	beq.w	.l32EA
	cmpi.w	#$3,$DE(a6)
	beq.w	.l3046
	cmpi.w	#$4,$DE(a6)
	beq.w	.l30A6
	cmpi.w	#$5,$DE(a6)
	beq.w	.l3100
	cmpi.w	#$6,$DE(a6)
	beq.w	.l31F8
	cmpi.w	#$7,$DE(a6)
	beq.w	.l2F90
	cmpi.w	#$8,$DE(a6)
	beq.w	.l2F36
	cmpi.w	#$9,$DE(a6)
	beq.w	.l2E7E
	cmpi.w	#$A,$DE(a6)
	beq.w	.l2DCA
	bra.w	.l3400
.l2DCA	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	move.w	$E2(a6),d0
	move.w	$E0(a6),d1
	addi.w	#$9200,d0
.l2DDE	btst.b	#$4,$FF800E.l
	bne.b	.l2DDE
	move.w	#$39,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.l2DFE	btst.b	#$3,$FF800E.l
	beq.b	.l2DFE
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l2E18	btst.b	#$3,$FF800E.l
	bne.b	.l2E18
	bclr.b	#$4,$FF800F.l
	addi.w	#$9100,d1
.l2E2E	btst.b	#$4,$FF800E.l
	bne.b	.l2E2E
	move.w	#$39,$FF8026.l
	move.w	d1,$FF8028.l
	bset.b	#$3,$FF800F.l
.l2E4E	btst.b	#$3,$FF800E.l
	beq.b	.l2E4E
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l2E68	btst.b	#$3,$FF800E.l
	bne.b	.l2E68
	bclr.b	#$4,$FF800F.l
	bra.w	.l33FC
.l2E7E	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	move.w	$E2(a6),d0
	andi.w	#$3FF,d0
.l2E8E	btst.b	#$4,$FF800E.l
	bne.b	.l2E8E
	move.w	#$30,$FF8026.l
	move.l	#$70000003,$FF8028.l
	bset.b	#$3,$FF800F.l
.l2EB2	btst.b	#$3,$FF800E.l
	beq.b	.l2EB2
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l2ECC	btst.b	#$3,$FF800E.l
	bne.b	.l2ECC
	bclr.b	#$4,$FF800F.l
.l2EDE	btst.b	#$4,$FF800E.l
	bne.b	.l2EDE
	move.w	#$31,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.l2EFE	btst.b	#$3,$FF800E.l
	beq.b	.l2EFE
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l2F18	btst.b	#$3,$FF800E.l
	bne.b	.l2F18
	bclr.b	#$4,$FF800F.l
	add.w	$E0(a6),d0
	move.w	d0,$E2(a6)
	bra.w	.l33FC
.l2F36	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	bsr.w	LF64_43
.l2F42	btst.b	#$4,$FF800E.l
	bne.b	.l2F42
	move.w	#$2C,$FF8026.l
	bset.b	#$3,$FF800F.l
.l2F5C	btst.b	#$3,$FF800E.l
	beq.b	.l2F5C
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l2F76	btst.b	#$3,$FF800E.l
	bne.b	.l2F76
	bclr.b	#$4,$FF800F.l
	bsr.w	LF64_42
	bra.w	.l33FC
.l2F90	movem.l	d0-d3/a0-a2,-(sp)
.l2F94	btst.b	#$4,$FF800E.l
	bne.b	.l2F94
	move.w	#$30,$FF8026.l
	move.l	#$40000010,$FF8028.l
	bset.b	#$3,$FF800F.l
.l2FB8	btst.b	#$3,$FF800E.l
	beq.b	.l2FB8
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l2FD2	btst.b	#$3,$FF800E.l
	bne.b	.l2FD2
	bclr.b	#$4,$FF800F.l
	clr.w	$DE(a6)
	move.w	$E2(a6),d0
	move.w	$E0(a6),d1
	add.w	d1,d0
.l2FF2	btst.b	#$4,$FF800E.l
	bne.b	.l2FF2
	move.w	#$31,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.l3012	btst.b	#$3,$FF800E.l
	beq.b	.l3012
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l302C	btst.b	#$3,$FF800E.l
	bne.b	.l302C
	bclr.b	#$4,$FF800F.l
	move.w	d0,$E2(a6)
	bra.w	.l33FC
.l3046	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	moveq	#$0,d0
	bsr.w	LF64_30
.l3054	btst.b	#$4,$FF800E.l
	bne.b	.l3054
	move.w	#$39,$FF8026.l
	move.w	#$9001,$FF8028.l
	bset.b	#$3,$FF800F.l
.l3076	btst.b	#$3,$FF800E.l
	beq.b	.l3076
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l3090	btst.b	#$3,$FF800E.l
	bne.b	.l3090
	bclr.b	#$4,$FF800F.l
	bra.w	.l33FC
.l30A6	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
.l30AE	btst.b	#$4,$FF800E.l
	bne.b	.l30AE
	move.w	#$39,$FF8026.l
	move.w	#$9003,$FF8028.l
	bset.b	#$3,$FF800F.l
.l30D0	btst.b	#$3,$FF800E.l
	beq.b	.l30D0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l30EA	btst.b	#$3,$FF800E.l
	bne.b	.l30EA
	bclr.b	#$4,$FF800F.l
	bra.w	.l33FC
.l3100	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
.l3108	btst.b	#$4,$FF800E.l
	bne.b	.l3108
	move.w	#$39,$FF8026.l
	move.w	$E2(a6),$FF8028.l
	bset.b	#$3,$FF800F.l
.l312A	btst.b	#$3,$FF800E.l
	beq.b	.l312A
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l3144	btst.b	#$3,$FF800E.l
	bne.b	.l3144
	bclr.b	#$4,$FF800F.l
.l3156	btst.b	#$4,$FF800E.l
	bne.b	.l3156
	move.w	#$30,$FF8026.l
	move.l	#$40000010,$FF8028.l
	bset.b	#$3,$FF800F.l
.l317A	btst.b	#$3,$FF800E.l
	beq.b	.l317A
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l3194	btst.b	#$3,$FF800E.l
	bne.b	.l3194
	bclr.b	#$4,$FF800F.l
.l31A6	btst.b	#$4,$FF800E.l
	bne.b	.l31A6
	move.w	#$31,$FF8026.l
	move.w	#$0,$FF8028.l
	bset.b	#$3,$FF800F.l
.l31C8	btst.b	#$3,$FF800E.l
	beq.b	.l31C8
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l31E2	btst.b	#$3,$FF800E.l
	bne.b	.l31E2
	bclr.b	#$4,$FF800F.l
	bra.w	.l33FC
.l31F8	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	moveq	#$0,d0
	move.w	$E0(a6),d0
	move.l	d0,$BBC88.l
	move.w	$E2(a6),d0
	move.l	d0,$BBC8C.l
	move.w	$E4(a6),d0
	move.l	d0,$BBC90.l
	bsr.w	LF64_43
.l3224	btst.b	#$4,$FF800E.l
	bne.b	.l3224
	move.w	#$3A,$FF8026.l
	bset.b	#$3,$FF800F.l
.l323E	btst.b	#$3,$FF800E.l
	beq.b	.l323E
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l3258	btst.b	#$3,$FF800E.l
	bne.b	.l3258
	bclr.b	#$4,$FF800F.l
	bsr.w	LF64_42
	bra.w	.l33FC
.l3272	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	moveq	#$0,d0
	move.w	$E0(a6),d0
	move.l	d0,$BBC88.l
	move.w	$E2(a6),d0
	move.l	d0,$BBC8C.l
	move.l	$E4(a6),$BBC90.l
	bsr.w	LF64_43
.l329C	btst.b	#$4,$FF800E.l
	bne.b	.l329C
	move.w	#$3B,$FF8026.l
	bset.b	#$3,$FF800F.l
.l32B6	btst.b	#$3,$FF800E.l
	beq.b	.l32B6
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l32D0	btst.b	#$3,$FF800E.l
	bne.b	.l32D0
	bclr.b	#$4,$FF800F.l
	bsr.w	LF64_42
	bra.w	.l33FC
.l32EA	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	move.w	$E0(a6),d0
	move.w	$E2(a6),d1
	movea.l	$E4(a6),a0
	cmpa.l	#$80000,a0
	bge.w	.l3326
	move.l	d0,d3
	movea.l	#$BC000,a2
	lsr.w	#$1,d3
	bcc.w	.l3318
	move.w	(a0)+,(a2)+
.l3318	subq.w	#$1,d3
.l331A	move.l	(a0)+,(a2)+
	dbra	d3,.l331A
	movea.l	#$BC000,a0
.l3326	lea.l	$C00004.l,a1
	move.l	(a0),$BBC96.l
	move.l	d1,$BBC9A.l
	adda.l	#$180002,a0
	move.w	#$8154,$BBC88.l
	move.w	#$8F02,$BBC8A.l
	move.w	#$9300,d2
	move.b	d0,d2
	move.w	d2,$BBC8C.l
	move.w	#$9400,d2
	lsr.w	#$8,d0
	move.b	d0,d2
	move.w	d2,$BBC8E.l
	move.l	a0,d0
	lsr.l	#$1,d0
	move.w	#$9500,d2
	move.b	d0,d2
	move.w	d2,$BBC90.l
	lsr.l	#$8,d0
	move.w	#$9600,d2
	move.b	d0,d2
	move.w	d2,$BBC92.l
	lsr.l	#$8,d0
	andi.b	#$7F,d0
	move.w	#$9700,d2
	move.b	d0,d2
	move.w	d2,$BBC94.l
	clr.l	d0
	move.w	d1,d0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	move.l	d0,d3
	ori.l	#$804000,d0
	move.l	d0,$BBC9E.l
	bsr.w	LF64_43
.l33B2	btst.b	#$4,$FF800E.l
	bne.b	.l33B2
	move.w	#$32,$FF8026.l
	bset.b	#$3,$FF800F.l
.l33CC	btst.b	#$3,$FF800E.l
	beq.b	.l33CC
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l33E6	btst.b	#$3,$FF800E.l
	bne.b	.l33E6
	bclr.b	#$4,$FF800F.l
	bsr.w	LF64_42
.l33FC	movem.l	(sp)+,d0-d3/a0-a2
.l3400	tst.w	$FA(a6)
	beq.w	LF64_29
LF64Sub6	movem.l	d0-d3/a0-a2,-(sp)
	move.w	$F6(a6),d0
	cmp.w	$F4(a6),d0
	bgt.w	.l3436
	cmpi.w	#$1,$F8(a6)
	beq.w	.l3424
	neg.w	d0
.l3424	add.w	$F2(a6),d0
	bsr.w	LF64_30
	addi.w	#$6,$F6(a6)
	bra.w	.l346E
.l3436	move.w	$F6(a6),d0
	subi.w	#$6,d0
	move.w	d0,$F6(a6)
	sub.w	$F4(a6),d0
	neg.w	d0
	add.w	$F6(a6),d0
	tst.w	$F8(a6)
	bne.w	.l3456
	neg.w	d0
.l3456	add.w	$F2(a6),d0
	bsr.w	LF64_30
	clr.w	$FA(a6)
	clr.w	$F6(a6)
	andi.w	#$3FF,d0
	move.w	d0,$F2(a6)
.l346E	movem.l	(sp)+,d0-d3/a0-a2
LF64_29	movem.l	d0-d5/a0-a1,-(sp)
	bsr.w	LF64_31
	movem.l	(sp)+,d0-d5/a0-a1
	rts
LF64_30	btst.b	#$4,$FF800E.l
	bne.b	LF64_30
	move.w	#$30,$FF8026.l
	move.l	#$70000003,$FF8028.l
	bset.b	#$3,$FF800F.l
.l34A4	btst.b	#$3,$FF800E.l
	beq.b	.l34A4
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l34BE	btst.b	#$3,$FF800E.l
	bne.b	.l34BE
	bclr.b	#$4,$FF800F.l
.l34D0	btst.b	#$4,$FF800E.l
	bne.b	.l34D0
	move.w	#$31,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.l34F0	btst.b	#$3,$FF800E.l
	beq.b	.l34F0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l350A	btst.b	#$3,$FF800E.l
	bne.b	.l350A
	bclr.b	#$4,$FF800F.l
.l351C	btst.b	#$4,$FF800E.l
	bne.b	.l351C
	move.w	#$31,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.l353C	btst.b	#$3,$FF800E.l
	beq.b	.l353C
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l3556	btst.b	#$3,$FF800E.l
	bne.b	.l3556
	bclr.b	#$4,$FF800F.l
	rts
LF64_31	tst.w	$EC(a6)
	bmi.w	.l3606
	cmpi.w	#$64,$EC(a6)
	beq.w	.l3608
	subq.w	#$1,$EC(a6)
	bmi.w	.l3606
	clr.l	d0
	move.w	$EC(a6),d0
	cmpi.w	#$18,d0
	bgt.w	.l3606
	divu.w	#$3,d0
	swap	d0
	asl.w	#$2,d0
	moveq	#$2,d3
	asl.w	d0,d3
	moveq	#$E,d5
	asl.w	d0,d5
	move.w	d5,d4
	not.w	d4
	move.l	d3,$BBC88.l
	move.l	d4,$BBC8C.l
	move.l	d5,$BBC90.l
	bsr.w	LF64_43
.l35BC	btst.b	#$4,$FF800E.l
	bne.b	.l35BC
	move.w	#$1D,$FF8026.l
	bset.b	#$3,$FF800F.l
.l35D6	btst.b	#$3,$FF800E.l
	beq.b	.l35D6
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l35F0	btst.b	#$3,$FF800E.l
	bne.b	.l35F0
	bclr.b	#$4,$FF800F.l
	bsr.w	LF64_42
.l3606	rts
.l3608	movea.l	#$BBCB0,a1
.l360E	btst.b	#$4,$FF800E.l
	bne.b	.l360E
	move.w	#$30,$FF8026.l
	move.l	#$C0000000,$FF8028.l
	bset.b	#$3,$FF800F.l
.l3632	btst.b	#$3,$FF800E.l
	beq.b	.l3632
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l364C	btst.b	#$3,$FF800E.l
	bne.b	.l364C
	bclr.b	#$4,$FF800F.l
	moveq	#$1F,d0
.l3660	btst.b	#$4,$FF800E.l
	bne.b	.l3660
	move.w	#$33,$FF8026.l
	move.l	(a1)+,$FF8028.l
	bset.b	#$3,$FF800F.l
.l3680	btst.b	#$3,$FF800E.l
	beq.b	.l3680
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l369A	btst.b	#$3,$FF800E.l
	bne.b	.l369A
	bclr.b	#$4,$FF800F.l
	dbra	d0,.l3660
	st.b	$EC(a6)
	rts
LF64_32	move.b	$C2(a6),d0
	bsr.w	LF64_34
	move.w	$C6(a6),d2
	move.w	d1,$C6(a6)
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
LF64_33	move.b	$C3(a6),d0
	bsr.w	LF64_34
	move.w	$C8(a6),d2
	move.w	d1,$C8(a6)
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
	move.b	$C4(a6),d0
	bsr.w	LF64_34
	move.w	$CA(a6),d2
	move.w	d1,$CA(a6)
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
	move.b	$C5(a6),d0
	bsr.w	LF64_34
	move.w	$CC(a6),d2
	move.w	d1,$CC(a6)
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
LF64_34	not.b	d0
	clr.w	d1
	move.b	d0,d1
	move.w	d1,-(sp)
	andi.w	#$F0,d0
	andi.w	#$F,d1
	lea.l	.l3734(pc),a0
	move.b	(a0,d1.w),d1
	or.w	d1,d0
	move.w	(sp)+,d1
	rts
.l3734	dc.b	$08,$00,$04,$08,$06,$07,$05,$08,$02,$01,$03,$08,$08,$08,$08,$08	; ................
LF64Sub7	movem.l	d1/a0,-(sp)
	tst.w	$BC(a6)
	beq.w	.l3772
	bsr.b	.l3788
	move.b	d0,$C2(a6)
	bsr.w	.l37DA
	move.b	d0,$C3(a6)
	bsr.w	.l382C
	move.b	d0,$C4(a6)
	bsr.w	.l387E
	move.b	d0,$C5(a6)
	bra.w	.l3782
.l3772	bsr.w	.l38DC
	move.b	d0,$C2(a6)
	bsr.w	.l38D4
	move.b	d0,$C3(a6)
.l3782	movem.l	(sp)+,d1/a0
	rts
.l3788	btst.b	#$4,$FF800E.l
	bne.b	.l3788
	move.b	#$C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.l37AA	btst.b	#$4,$FF800E.l
	beq.b	.l37AA
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l37C4	btst.b	#$3,$FF800E.l
	bne.b	.l37C4
	bclr.b	#$4,$FF800F.l
	bra.w	.l38CC
.l37DA	btst.b	#$4,$FF800E.l
	bne.b	.l37DA
	move.b	#$1C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.l37FC	btst.b	#$4,$FF800E.l
	beq.b	.l37FC
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l3816	btst.b	#$3,$FF800E.l
	bne.b	.l3816
	bclr.b	#$4,$FF800F.l
	bra.w	.l38CC
.l382C	btst.b	#$4,$FF800E.l
	bne.b	.l382C
	move.b	#$2C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.l384E	btst.b	#$4,$FF800E.l
	beq.b	.l384E
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l3868	btst.b	#$3,$FF800E.l
	bne.b	.l3868
	bclr.b	#$4,$FF800F.l
	bra.w	.l38CC
.l387E	btst.b	#$4,$FF800E.l
	bne.b	.l387E
	move.b	#$3C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.l38A0	btst.b	#$4,$FF800E.l
	beq.b	.l38A0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l38BA	btst.b	#$3,$FF800E.l
	bne.b	.l38BA
	bclr.b	#$4,$FF800F.l
.l38CC	movem.l	d1/a0,-(sp)
	bra.w	.l38E0
.l38D4	movem.l	d1/a0,-(sp)
	bra.w	.l3A1A
.l38DC	movem.l	d1/a0,-(sp)
.l38E0	moveq	#$0,d0
.l38E2	btst.b	#$4,$FF800E.l
	bne.b	.l38E2
	move.b	#$0,$FF8028.l
	move.w	#$36,$FF8026.l
	bset.b	#$3,$FF800F.l
.l3904	btst.b	#$3,$FF800E.l
	beq.b	.l3904
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l391E	btst.b	#$3,$FF800E.l
	bne.b	.l391E
	bclr.b	#$4,$FF800F.l
.l3930	btst.b	#$4,$FF800E.l
	bne.b	.l3930
	move.w	#$37,$FF8026.l
	bset.b	#$3,$FF800F.l
.l394A	btst.b	#$3,$FF800E.l
	beq.b	.l394A
	move.b	$FF8018.l,d0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l396A	btst.b	#$3,$FF800E.l
	bne.b	.l396A
	bclr.b	#$4,$FF800F.l
.l397C	btst.b	#$4,$FF800E.l
	bne.b	.l397C
	move.b	#$40,$FF8028.l
	move.w	#$36,$FF8026.l
	bset.b	#$3,$FF800F.l
.l399E	btst.b	#$3,$FF800E.l
	beq.b	.l399E
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l39B8	btst.b	#$3,$FF800E.l
	bne.b	.l39B8
	bclr.b	#$4,$FF800F.l
.l39CA	btst.b	#$4,$FF800E.l
	bne.b	.l39CA
	move.w	#$37,$FF8026.l
	bset.b	#$3,$FF800F.l
.l39E4	btst.b	#$3,$FF800E.l
	beq.b	.l39E4
	move.b	$FF8018.l,d1
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l3A04	btst.b	#$3,$FF800E.l
	bne.b	.l3A04
	bclr.b	#$4,$FF800F.l
	dc.w	$6000,$013C
.l3A1A	moveq	#$0,d0
.l3A1C	btst.b	#$4,$FF800E.l
	bne.b	.l3A1C
	move.b	#$0,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.l3A3E	btst.b	#$4,$FF800E.l
	beq.b	.l3A3E
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l3A58	btst.b	#$3,$FF800E.l
	bne.b	.l3A58
	bclr.b	#$4,$FF800F.l
.l3A6A	btst.b	#$4,$FF800E.l
	bne.b	.l3A6A
	move.w	#$38,$FF8026.l
	bset.b	#$3,$FF800F.l
.l3A84	btst.b	#$3,$FF800E.l
	beq.b	.l3A84
	move.b	$FF8018.l,d0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l3AA4	btst.b	#$3,$FF800E.l
	bne.b	.l3AA4
	bclr.b	#$4,$FF800F.l
.l3AB6	btst.b	#$4,$FF800E.l
	bne.b	.l3AB6
	move.b	#$40,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.l3AD8	btst.b	#$4,$FF800E.l
	beq.b	.l3AD8
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l3AF2	btst.b	#$3,$FF800E.l
	bne.b	.l3AF2
	bclr.b	#$4,$FF800F.l
.l3B04	btst.b	#$4,$FF800E.l
	bne.b	.l3B04
	move.w	#$38,$FF8026.l
	bset.b	#$3,$FF800F.l
.l3B1E	btst.b	#$3,$FF800E.l
	beq.b	.l3B1E
	move.b	$FF8018.l,d1
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.l3B3E	btst.b	#$3,$FF800E.l
	bne.b	.l3B3E
	bclr.b	#$4,$FF800F.l
	bra.w	.l3B54
.l3B54	asl.b	#$2,d0
	andi.b	#$C0,d0
	andi.b	#$3F,d1
	or.b	d1,d0
	not.b	d0
	not.b	d1
	andi.w	#$F,d1
	lea.l	.l3B7C(pc),a0
	andi.b	#$F0,d0
	or.b	(a0,d1.w),d0
	not.b	d0
	movem.l	(sp)+,d1/a0
	rts
.l3B7C	dc.b	$00,$01,$02,$01,$04,$05,$06,$06,$08,$09,$0A,$0A,$08,$09,$0A,$00	; ................
LF64_35	move.l	$6038.w,$D6(a6)
	lea.l	LF64_37(pc),a0
	move.l	a0,$6038.w
	rts
LF64_36	move.l	$D6(a6),$6038.w
	rts
LF64_37	btst.b	#$5,$FF800E.l
	beq.w	.l3C14
	bset.b	#$2,$FF800F.l
	pea.l	.l3BC2(pc)
	move.l	$D2(a6),-(sp)
	rts
.l3BC2	dc.b	$61,$00,$FB,$80,$08,$39,$00,$04,$00,$FF,$80,$0E,$66,$F6,$33,$FC	; a....9......f.3.
	dc.b	$00,$2F,$00,$FF,$80,$26,$08,$F9,$00,$03,$00,$FF,$80,$0F,$08,$39	; ./...&.........9
	dc.b	$00,$03,$00,$FF,$80,$0E,$67,$F6,$08,$F9,$00,$04,$00,$FF,$80,$0F	; ......g.........
	dc.b	$08,$B9,$00,$03,$00,$FF,$80,$0F,$08,$39,$00,$03,$00,$FF,$80,$0E	; .........9......
	dc.b	$66,$F6,$08,$B9,$00,$04,$00,$FF,$80,$0F,$08,$B9,$00,$02,$00,$FF	; f...............
	dc.b	$80,$0F	; ..
.l3C14	rts
LF64_38	movem.l	d0-d2/a0-a1/a5,-(sp)
	andi.l	#$FFFF,d0
	divu.w	#$28,d0
	move.w	d0,d2
	lsl.w	#$6,d2
	swap	d0
	add.w	d2,d0
	add.w	d0,d0
	moveq	#$0,d2
	move.w	#$B000,d2
	add.w	d0,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.l3C42	btst.b	#$7,$FF800E.l
	bne.b	.l3C42
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.l3C62	btst.b	#$6,$FF800E.l
	beq.b	.l3C62
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l3C7C	btst.b	#$6,$FF800E.l
	bne.b	.l3C7C
	bclr.b	#$7,$FF800F.l
	movea.l	$8E(a6),a5
	bsr.w	LF64_39
	movem.l	(sp)+,d0-d2/a0-a1/a5
	rts
LF64Sub8	movem.l	d0-d2/a0-a1/a5,-(sp)
	andi.l	#$FFFF,d0
	divu.w	#$28,d0
	move.w	d0,d2
	lsl.w	#$7,d2
	swap	d0
	add.w	d2,d0
	add.w	d0,d0
	moveq	#$0,d2
	move.w	$EE(a6),d2
	subi.w	#$2000,d2
	add.w	d0,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.l3CCC	btst.b	#$7,$FF800E.l
	bne.b	.l3CCC
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.l3CEC	btst.b	#$6,$FF800E.l
	beq.b	.l3CEC
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l3D06	btst.b	#$6,$FF800E.l
	bne.b	.l3D06
	bclr.b	#$7,$FF800F.l
	movea.l	$8E(a6),a5
	bsr.w	LF64_39
	movem.l	(sp)+,d0-d2/a0-a1/a5
	rts
LF64_39	move.w	#$7A0,d0
	bset	#$E,d0
.l3D2E	moveq	#$0,d2
	move.b	(a0)+,d2
	beq.w	.l3DB8
	cmpi.b	#$22,d2
	beq.w	.l3D52
	cmpi.b	#$5F,d2
	beq.w	.l3D52
	cmpi.b	#$24,d2
	beq.w	.l3D5A
	bra.w	.l3D5E
.l3D52	move.b	#$20,d2
	bra.w	.l3D5E
.l3D5A	move.b	#$22,d2
.l3D5E	move.b	d2,(a5)+
	subi.b	#$20,d2
	add.w	d0,d2
.l3D66	btst.b	#$7,$FF800E.l
	bne.b	.l3D66
	move.w	d2,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.l3D86	btst.b	#$6,$FF800E.l
	beq.b	.l3D86
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l3DA0	btst.b	#$6,$FF800E.l
	bne.b	.l3DA0
	bclr.b	#$7,$FF800F.l
	subq.w	#$1,d1
	bra.w	.l3D2E
.l3DB8	tst.w	d1
	blt.w	.l3E14
.l3DBE	btst.b	#$7,$FF800E.l
	bne.b	.l3DBE
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.l3DDE	btst.b	#$6,$FF800E.l
	beq.b	.l3DDE
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l3DF8	btst.b	#$6,$FF800E.l
	bne.b	.l3DF8
	bclr.b	#$7,$FF800F.l
	move.b	#$20,(a5)+
	dbra	d1,.l3DBE
	subq.l	#$1,a5
.l3E14	clr.b	(a5)+
	rts
LF64_40	movem.l	d0-d2/a4,-(sp)
	move.w	#$7A0,d0
	bset	#$E,d0
.l3E24	moveq	#$0,d2
	move.b	(a4)+,d2
	beq.w	.l3E8C
	cmpi.b	#$FF,d2
	beq.w	.l3E8C
	subi.b	#$20,d2
	add.w	d0,d2
.l3E3A	btst.b	#$7,$FF800E.l
	bne.b	.l3E3A
	move.w	d2,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.l3E5A	btst.b	#$6,$FF800E.l
	beq.b	.l3E5A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l3E74	btst.b	#$6,$FF800E.l
	bne.b	.l3E74
	bclr.b	#$7,$FF800F.l
	subq.b	#$1,d1
	bra.w	.l3E24
.l3E8C	subq.b	#$1,d1
	tst.b	d1
	bmi.w	.l3EE4
.l3E94	btst.b	#$7,$FF800E.l
	bne.b	.l3E94
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.l3EB4	btst.b	#$6,$FF800E.l
	beq.b	.l3EB4
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l3ECE	btst.b	#$6,$FF800E.l
	bne.b	.l3ECE
	bclr.b	#$7,$FF800F.l
	dbra	d1,.l3E94
.l3EE4	movem.l	(sp)+,d0-d2/a4
	rts
LF64_41	movem.l	d0/a0-a1,-(sp)
	movea.l	$8E(a6),a1
.l3EF2	move.b	(a0)+,(a1)+
	beq.w	.l3EFE
	dbra	d0,.l3EF2
	clr.b	(a1)
.l3EFE	movem.l	(sp)+,d0/a0-a1
	rts
LF64_42	btst.b	#$1,$FF8003.l
	beq.b	LF64_42
	rts
LF64_43	bset.b	#$0,$FF8003.l
.l3F18	btst.b	#$1,$FF8003.l
	bne.b	.l3F18
	rts
LF64_44	movem.l	d0-d7/a0-a2,-(sp)
	bclr.b	#$5,$FF800F.l
.l3F30	btst.b	#$7,$FF800E.l
	bne.b	.l3F30
	move.w	#$3D,$FF8020.l
	bset.b	#$6,$FF800F.l
.l3F4A	btst.b	#$6,$FF800E.l
	beq.b	.l3F4A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l3F64	btst.b	#$6,$FF800E.l
	bne.b	.l3F64
	bclr.b	#$7,$FF800F.l
	bset.b	#$5,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a2
	rts
	dc.b	$00,$00,$00,$01,$00,$02,$00,$05,$00,$06,$00,$07,$FF,$FF,$00,$00	; ................
	dc.b	$00,$01,$00,$02,$00,$03,$00,$04,$00,$05,$00,$08,$00,$09,$00,$0A	; ................
	dc.b	$00,$0B,$00,$0C,$FF,$FF,$07,$FF,$05,$03,$03,$03,$03,$04,$03,$03	; ................
	dc.b	$03,$03,$04,$00,$07,$FF,$05,$03,$03,$03,$03,$04,$03,$02,$04,$03	; ................
	dc.b	$03,$03,$05,$03,$03,$04	; ......
LF64_45	dc.b	'Players',$00,$20,$00	; Players. .
LF64_46	dc.b	'Goalies',$00,$20,$00	; Goalies. .
LF64_47	dc.b	$47,$70,$00,$47,$00,$41,$00,$50,$74,$73,$00,$2B,$2F,$2D,$00,$50	; Gp.G.A.Pts.+/-.P
	dc.b	$69,$6D,$00,$50,$50,$00,$53,$68,$00,$47,$77,$00,$47,$74,$00,$53	; im.PP.Sh.Gw.Gt.S
	dc.b	$00,'Pctg',$FF	; .Pctg.
LF64_48	dc.b	$47,$70,$00,'Mins',$00,$47,$61,$00,'Avg.',$00	; Gp.Mins.Ga.Avg..
	dc.b	$57,$00,$4C,$00,$54,$00,$53,$4F,$00,$45,$6E,$00,'Shts'	; W.L.T.SO.En.Shts
	dc.b	$00,$70,$47,$50,$00,'pMIN',$00,$70,$47,$41,$00,$70,$41	; .pGP.pMIN.pGA.pA
	dc.b	$56,$47,$00,$70,$57,$00,$70,$4C,$00,$70,$53,$4F,$00,$70,$45,$4E	; VG.pW.pL.pSO.pEN
	dc.b	$00,$70,$53,$41,$FF	; .pSA.
LF64_49	dc.b	'Regular',$00	; Regular.
LF64_50	dc.b	'Playoff',$00,'Season',$00,$43	; Playoff.Season.C
	dc.b	$6C,$75,$62,$00,$4C,$65,$61,$00,$47,$70,$00,$47,$00,$41,$00,$54	; lub.Lea.Gp.G.A.T
	dc.b	$70,$00,$50,$69,$6D,$00,$47,$70,$00,$47,$00,$41,$00,$54,$70,$00	; p.Pim.Gp.G.A.Tp.
	dc.b	$50,$69,$6D,$00,'Season',$00,'Club',$00	; Pim.Season.Club.
	dc.b	$4C,$65,$61,$00,$47,$70,$00,$57,$00,$4C,$00,$54,$00,$4D,$69,$6E	; Lea.Gp.W.L.T.Min
	dc.b	$73,$00,$47,$61,$00,$53,$6F,$00,$41,$76,$67,$00,$47,$70,$00,$57	; s.Ga.So.Avg.Gp.W
	dc.b	$00,$4C,$00,'Mins',$00,$47,$61,$00,$53,$6F,$00,$41,$76	; .L.Mins.Ga.So.Av
	dc.b	$67,$00,$00	; g..
LF64_51	incbin	..\Extracted\SegaCD\PLAYER\player_040C4.bin
LF64_52	incbin	..\Extracted\SegaCD\PLAYER\player_045C8.bin
.l6044	incbin	..\Extracted\SegaCD\PLAYER\player_06044.bin
LF64_53	incbin	..\Extracted\SegaCD\PLAYER\player_068E4.bin
LF64_54	incbin	..\Extracted\SegaCD\PLAYER\player_06DE8.bin
LF64_55	incbin	..\Extracted\SegaCD\PLAYER\player_07CF4.bin
LF64_56	incbin	..\Extracted\SegaCD\PLAYER\player_082A4.bin
	dcb.b	$8DC,0
