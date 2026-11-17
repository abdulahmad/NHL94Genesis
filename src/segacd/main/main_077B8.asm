LFF77B8	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$41FA,$0C5C
	cmpi.w	#$1234,(a0)
	dc.w	$6600,$0264
	dc.w	$6100,$06F2
	dc.w	$6100,$0762
	dc.w	$41FA,$0D6C
	move.w	#$0,(a0)
	dc.w	$4DFA,$0C42
	dc.w	$4BFA,$0C5E
	dc.w	$49FA,$0C8A
	dc.w	$47FA,$0C96
	dc.w	$45FA,$0CA2
	dc.w	$43FA,$0CAE
.l77F0	dc.w	$3C3A,$0D4C
	lsl.w	#$1,d6
	move.w	d6,d7
	lsl.w	#$1,d7
	cmpi.l	#$FFFFFFFF,(a6,d7.w)
	dc.w	$6700,$0212
	tst.w	(a4,d6.w)
	dc.w	$6742
	move.w	(a3,d6.w),d1
	add.w	(a2,d6.w),d1
	move.w	d1,d2
	andi.w	#$FF,d2
	lsr.w	#$8,d1
	add.w	(a1,d7.w),d1
	move.w	#$0,(a1,d7.w)
	cmp.w	(a4,d6.w),d1
	dc.w	$6C12
	move.w	(a4,d6.w),d3
	sub.w	d1,d3
	move.w	d3,(a4,d6.w)
	move.w	d2,(a2,d6.w)
	dc.w	$6000,$01DA
.l783E	sub.w	(a4,d6.w),d1
	lsl.w	#$8,d1
	or.w	d2,d1
	move.w	d1,(a2,d6.w)
	clr.w	(a4,d6.w)
.l784E	movea.l	(a6,d7.w),a0
	move.l	(a5,d7.w),d5
.l7856	tst.b	(a0,d5.l)
	dc.w	$6A08
	dc.w	$0685,$0000,$0001
	dc.w	$60F2
.l7864	dc.w	$0685,$0000,$0001
	tst.b	(a0,d5.l)
	dc.w	$6A0C
	move.b	(a0,d5.l),$2(a1,d7.w)
	dc.w	$0685,$0000,$0001
.l787C	move.b	$2(a1,d7.w),d0
	andi.b	#$F0,d0
	cmpi.b	#$90,d0
	dc.w	$6600,$0082
	dc.w	$303A,$0CB0
	lsl.w	#$8,d0
	lsl.w	#$4,d0
	move.b	$1(a0,d5.l),d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	move.b	$2(a1,d7.w),d0
	dc.w	$6100,$0356
	tst.w	d0
	dc.w	$670A
	dc.w	$0671,$0001,$7000
	dc.w	$6000,$0162
.l78B6	clr.l	d0
	move.b	$2(a0,d5.l),d0
	dc.w	$6A0C
	andi.l	#$7F,d0
	lsl.l	#$7,d0
	or.b	$3(a0,d5.l),d0
.l78CA	lsl.l	#$8,d0
	move.w	(a3,d6.w),d3
	divu.w	d3,d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	dc.w	$323A,$0C62
	lsl.w	#$4,d1
	move.b	$2(a1,d7.w),d0
	andi.b	#$F,d0
	or.b	d1,d0
	dc.w	$6100,$05AA
	dc.w	$0685,$0000,$0002
.l78F4	tst.b	(a0,d5.l)
	dc.w	$6A08
	dc.w	$0685,$0000,$0001
	dc.w	$60F2
.l7902	dc.w	$0685,$0000,$0001
	dc.w	$6000,$00EA
.l790C	cmpi.b	#$B0,d0
	dc.w	$666C
	cmpi.b	#$12,(a0,d5.l)
	dc.w	$6632
	move.l	a0,-(sp)
	move.b	$1(a0,d5.l),d1
	dc.w	$303A,$0C1C
	lsl.w	#$1,d0
	clr.w	d2
	move.b	$2(a1,d7.w),d2
	andi.b	#$F,d2
	dc.w	$41FA,$0C18
	move.w	(a0,d0.w),d3
	cmpi.b	#$0,d1
	dc.w	$6604
	bclr	d2,d3
	dc.w	$6002
.l7942	bset	d2,d3
.l7944	move.w	d3,(a0,d0.w)
	movea.l	(sp)+,a0
	dc.w	$602A
.l794C	dc.w	$303A,$0BF0
	lsl.w	#$8,d0
	lsl.w	#$4,d0
	move.b	$1(a0,d5.l),d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	move.b	$2(a1,d7.w),d0
	dc.w	$6100,$0296
	tst.w	d0
	dc.w	$670A
	dc.w	$0671,$0001,$7000
	dc.w	$6000,$00A2
.l7976	dc.w	$0685,$0000,$0002
	dc.w	$6076
.l797E	cmpi.b	#$C0,d0
	dc.w	$662C
	dc.w	$303A,$0BB8
	lsl.w	#$8,d0
	lsl.w	#$4,d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	move.b	$2(a1,d7.w),d0
	dc.w	$6100,$0262
	tst.w	d0
	dc.w	$6708
	dc.w	$0671,$0001,$7000
	dc.w	$606E
.l79A8	dc.w	$0685,$0000,$0001
	dc.w	$6044
.l79B0	cmpi.b	#$E0,d0
	dc.w	$662C
	dc.w	$303A,$0B86
	lsl.w	#$8,d0
	lsl.w	#$4,d0
	swap	d0
	move.b	(a0,d5.l),d0
	lsl.w	#$8,d0
	move.b	$2(a1,d7.w),d0
	dc.w	$6100,$0230
	tst.w	d0
	dc.w	$6708
	dc.w	$0671,$0001,$7000
	dc.w	$603C
.l79DA	dc.w	$0685,$0000,$0001
	dc.w	$6012
.l79E2	cmpi.b	#$FF,$2(a1,d7.w)
	dc.w	$660A
	move.l	#$FFFFFFFF,(a6,d7.w)
	dc.w	$6022
.l79F4	move.l	d5,(a5,d7.w)
	clr.w	d2
	move.b	(a0,d5.l),d2
	dc.w	$6A0A
	andi.b	#$7F,d2
	lsl.w	#$7,d2
	or.b	$1(a0,d5.l),d2
.l7A0A	move.w	d2,(a4,d6.w)
	tst.w	d2
	dc.w	$6604
	dc.w	$6000,$FDDC
.l7A16	dc.w	$41FA,$0B26
	dc.w	$0650,$0001
	cmpi.w	#$8,(a0)
	dc.w	$6D00,$FDCC
	dc.w	$6100,$02C8
.l7A2A	andi.b	#$FE,ccr
	movem.l	(sp)+,d0-d7/a0-a6
	rts
LFF7A34	movem.l	d1-d4/a0-a1,-(sp)
	dc.w	$41FA,$09E0
	move.w	d1,$1C8(a0)
	move.w	d2,$1CA(a0)
	move.w	d3,$1CC(a0)
	move.w	d4,$1CE(a0)
	dc.w	$43FA,$09CE
	clr.w	d0
.l7A52	cmpi.l	#$FFFFFFFF,(a1)+
	dc.w	$6710
	dc.w	$0640,$0001
	cmpi.w	#$8,d0
	dc.w	$66EE
	move.w	#$7,d0
	dc.w	$606A
.l7A6A	move.w	d0,$1C6(a0)
	move.w	#$3,d0
	dc.w	$6100,$0656
	dc.w	$655C
	clr.l	d1
	move.b	$1(a0),d1
	lsl.w	#$8,d1
	move.b	(a0),d1
	lsl.w	#$1,d1
	dc.w	$0641,$0002
	dc.w	$43FA,$0990
	move.w	#$0,$0(a1)
	move.w	$1C6(a1),d0
	lsl.w	#$2,d0
	move.l	a0,$2(a1,d0.w)
	move.l	d1,$22(a1,d0.w)
	dc.w	$41FA,$09FA
	move.l	#$0,(a0,d0.w)
	move.w	$1C6(a1),d0
	lsl.w	#$1,d0
	move.w	$1CE(a1),$62(a1,d0.w)
	move.w	#$0,$52(a1,d0.w)
	move.w	#$0,$72(a1,d0.w)
	move.w	$1C8(a1),$42(a1,d0.w)
	move.w	#$1234,$0(a1)
	clr.w	d0
	dc.w	$6004
.l7AD4	ori.b	#$1,ccr
.l7AD8	movem.l	(sp)+,d1-d4/a0-a1
	rts
LFF7ADE	movem.l	d1-d2/a0,-(sp)
	dc.w	$41FA,$0978
	clr.w	d0
.l7AE8	cmp.w	(a0)+,d1
	dc.w	$6714
	dc.w	$0640,$0001
	cmpi.w	#$8,d0
	dc.w	$66F2
	move.w	#$3,d0
	ori.b	#$1,ccr
	dc.w	$6030
.l7B00	dc.w	$41FA,$0918
	move.w	d0,$1C6(a0)
	lsl.w	#$1,d0
	dc.w	$41FA,$0950
	move.w	#$FFFF,(a0,d0.w)
	lsl.w	#$1,d0
	dc.w	$41FA,$0904
	move.l	#$FFFFFFFF,(a0,d0.w)
	dc.w	$41FA,$08F6
	move.w	$1C6(a0),d0
	dc.w	$6100,$0326
	clr.w	d0
.l7B30	movem.l	(sp)+,d1-d2/a0
	rts
LFF7B36	movem.l	d1-d2/a0,-(sp)
	move.w	sr,-(sp)
	move.w	#$2700,sr
	dc.w	$6100,$07FC
	lea.l	$A00000.l,a0
	move.b	$A00028.l,d0
	lsl.w	#$8,d0
	move.b	$A00029.l,d0
	move.b	d1,$3(a0,d0.w)
	dc.w	$6100,$07F4
	move.w	(sp)+,sr
	move.l	#$0,d0
	move.b	#$7F,d0
	lsl.w	#$8,d0
	move.b	#$CF,d0
	dc.w	$6100,$0102
	move.l	#$7F0000,d0
	move.w	d2,d0
	lsl.w	#$8,d0
	move.b	#$9F,d0
	dc.w	$6100,$00F0
	clr.w	d0
	movem.l	(sp)+,d1-d2/a0
	rts
LFF7B90	movem.l	a0-a1,-(sp)
	dc.w	$41FA,$0884
	move.w	#$0,$0(a0)
	dc.w	$6100,$079E
	clr.l	d0
	move.b	$A00024.l,d0
	lsl.w	#$8,d0
	move.b	$A00025.l,d0
	addi.l	#$A00000,d0
	movea.l	d0,a1
	move.w	#$1FF,d0
.l7BBE	move.b	#$0,(a1)+
	dbra	d0,.l7BBE
	clr.l	d0
	move.b	$A00026.l,d0
	lsl.w	#$8,d0
	move.b	$A00027.l,d0
	addi.l	#$A00000,d0
	movea.l	d0,a1
	move.w	#$1FF,d0
.l7BE2	move.b	#$0,(a1)+
	dbra	d0,.l7BE2
	dc.w	$6100,$0766
	move.w	#$1234,$0(a0)
	clr.w	d0
	movem.l	(sp)+,a0-a1
	rts
LFF7BFC	movem.l	d1-d3/a0,-(sp)
	dc.w	$41FA,$0948
	move.l	d0,d1
	swap	d1
	lsr.w	#$8,d1
	lsr.w	#$3,d1
	move.w	(a0,d1.w),d2
	move.w	d0,d3
	andi.w	#$F,d3
	btst	d3,d2
	dc.w	$6606
	dc.w	$6100,$005A
	dc.w	$6004
.l7C20	dc.w	$6100,$0008
.l7C24	movem.l	(sp)+,d1-d3/a0
	rts
LFF7C2A	movem.l	d1-d2/a0,-(sp)
	dc.w	$41FA,$07EA
	move.w	#$0,(a0)
	dc.w	$41FA,$0926
	move.w	(a0),d2
	cmpi.w	#$20,d2
	dc.w	$6612
	dc.w	$41FA,$07D6
	move.w	#$1234,(a0)
	move.w	#$FFFF,d0
	ori.b	#$1,ccr
	dc.w	$601C
.l7C54	move.w	d2,d1
	lsl.w	#$2,d1
	dc.w	$0641,$0002
	move.l	d0,(a0,d1.w)
	dc.w	$0642,$0001
	move.w	d2,(a0)
	dc.w	$41FA,$07B2
	move.w	#$1234,(a0)
	clr.w	d0
.l7C70	movem.l	(sp)+,d1-d2/a0
	rts
LFF7C76	movem.l	d1/a0,-(sp)
	dc.w	$41FA,$079E
	move.w	#$0,$0(a0)
.l7C84	dc.w	$6100,$06B8
	lea.l	$A00030.l,a0
	tst.b	(a0)
	dc.w	$6710
	dc.w	$6100,$06BE
	move.w	#$64,d1
.l7C9A	dc.w	$0441,$0001
	dc.w	$66FA
	dc.w	$60E2
.l7CA2	adda.l	#$1,a0
	cmpi.b	#$18,(a0)
	dc.w	$6D06
	move.w	#$FFFF,d0
	dc.w	$6028
.l7CB4	clr.w	d1
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
	dc.w	$0601,$0001
	move.b	d1,(a0)
	move.w	#$0,d0
.l7CDC	dc.w	$6100,$0674
	dc.w	$41FA,$0738
	move.w	#$1234,$0(a0)
	movem.l	(sp)+,d1/a0
	rts
LFF7CF0	movem.l	d0-d1/a0-a1,-(sp)
	dc.w	$43FA,$0868
	cmpi.w	#$0,(a1)
	dc.w	$6756
	dc.w	$207A,$085A
	dc.w	$6100,$0658
	dc.w	$6100,$06F4
.l7D0A	cmpi.w	#$FFFF,(a0)
	dc.w	$661E
	dc.w	$207A,$0848
	dc.w	$6100,$069A
	move.w	#$1F4,d0
.l7D1C	dbra	d0,.l7D1C
	dc.w	$207A,$0838
	dc.w	$6100,$0636
	dc.w	$6100,$06D2
	bra.b	.l7D0A
.l7D2E	move.w	(a1),d0
	move.w	(a0),d1
	add.w	d1,d0
	move.w	d0,(a0)+
	lsl.w	#$2,d1
	ext.l	d1
	adda.l	d1,a0
	move.w	(a1)+,d0
.l7D3E	move.l	(a1)+,(a0)+
	dbra	d0,.l7D3E
	dc.w	$43FA,$0818
	move.w	#$0,(a1)
	dc.w	$207A,$080C
	dc.w	$6100,$065E
.l7D54	movem.l	(sp)+,d0-d1/a0-a1
	rts
Sub_FF7D5A	movem.l	d0-d2/a0-a1,-(sp)
	dc.w	$43FA,$06BA
	move.w	#$0,(a1)
	dc.w	$6100,$05D6
	move.b	$A00022.l,d2
	lsl.w	#$8,d2
	move.b	$A00023.l,d2
	add.w	d1,d2
	cmpi.w	#$1F00,d2
	dc.w	$650C
	move.w	#$4,d0
	ori.b	#$1,ccr
	dc.w	$6000,$008E
.l7D8C	lea.l	$A00100.l,a1
	move.w	#$40,d2
.l7D96	cmpi.b	#$FF,(a1)
	dc.w	$6724
	adda.l	#$4,a1
	dc.w	$0442,$0001
	dc.w	$66EE
	dc.w	$6100,$05A8
	dc.w	$43FA,$066C
	move.w	#$1234,(a1)
	move.w	#$7,d0
	ori.b	#$1,ccr
	dc.w	$6000,$005A
.l7DC0	move.b	d0,(a1)
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
.l7DF0	move.b	(a0)+,(a1,d2.w)
	dc.w	$0642,$0001
	dc.w	$51C9,$FFF6
	move.b	d2,$A00023.l
	lsr.w	#$8,d2
	move.b	d2,$A00022.l
	dc.w	$6100,$0546
	dc.w	$43FA,$060A
	move.w	#$1234,(a1)
	clr.w	d0
.l7E18	movem.l	(sp)+,d0-d2/a0-a1
	rts
LFF7E1E	movem.l	d0-d1/a0-a1,-(sp)
	dc.w	$41FA,$05F6
	move.w	#$0,$0(a0)
	move.w	#$0,$122(a0)
	dc.w	$43FA,$0688
	move.w	#$1F,d1
	move.l	#$FFFFFFFF,d0
.l7E40	move.l	d0,(a1)+
	dbra	d1,.l7E40
	move.w	#$1234,$0(a0)
	movem.l	(sp)+,d0-d1/a0-a1
	rts
LFF7E52	movem.l	d0-d2/a0-a1,-(sp)
	dc.w	$41FA,$05C2
	move.w	#$0,$0(a0)
	dc.w	$43FA,$065A
	move.w	$122(a0),d1
	clr.w	d2
.l7E6A	cmpi.w	#$0,d1
	dc.w	$671A
	move.b	$3(a1),d2
	lsr.b	#$4,d2
	cmp.w	d0,d2
	dc.w	$6604
	move.w	#$1,(a1)
.l7E7E	adda.l	#$4,a1
	dc.w	$0441,$0001
	dc.w	$60E0
.l7E8A	move.w	#$1234,$0(a0)
	movem.l	(sp)+,d0-d2/a0-a1
	rts
LFF7E96	movem.l	d0-d1/a0,-(sp)
	dc.w	$41FA,$057E
	move.w	$122(a0),d1
	lsl.w	#$2,d1
	dc.w	$41FA,$0616
	move.l	d0,(a0,d1.w)
	dc.w	$41FA,$056C
	dc.w	$0668,$0001,$0122
	movem.l	(sp)+,d0-d1/a0
	dc.w	$4E75
LFF7EBC	dc.b	$48,$E7,$C0,$E0,$45,$FA,$05,$58,$0C,$6A,$00,$00,$01,$22,$67,$5E	; H...E..X.j..."g^
	dc.b	$41,$FA,$05,$EE,$0C,$50,$FF,$FF,$67,$54,$04,$50,$00,$01,$66,$48	; A....P..gT.P..fH
	dc.b	$10,$28,$00,$03,$02,$00,$00,$F0,$E1,$48,$48,$40,$30,$28,$00,$02	; .(.......HH@0(..
	dc.b	$02,$00,$00,$0F,$00,$00,$00,$80,$61,$00,$FD,$06,$4A,$40,$67,$06	; ........a...J@g.
	dc.b	$06,$50,$00,$01,$60,$22,$43,$FA,$05,$B8,$30,$3A,$06,$34,$04,$40	; .P..`"C...0:.4.@
	dc.b	$00,$01,$E5,$48,$20,$B1,$00,$00,$23,$BC,$FF,$FF,$FF,$FF,$00,$00	; ...H ...#.......
	dc.b	$04,$6A,$00,$01,$01,$22,$60,$AC,$D0,$FC,$00,$04,$60,$A6,$4C,$DF	; .j..."`.....`.L.
	dc.b	$07,$03,$4E,$75	; ..Nu
LFF7F30	movem.l	d1-d2/a0,-(sp)
	dc.w	$6100,$0408
	tst.b	$A00072.l
	dc.w	$6700,$0178
	cmpi.b	#$1,$A00072.l
	dc.w	$667E
	clr.w	d1
	move.b	$A00073.l,d1
	move.w	#$1,d0
	dc.w	$6100,$0170
	dc.w	$6500,$015A
	cmpa.l	#$FFFFFFFF,a0
	dc.w	$6700,$0150
	dc.w	$43FA,$04AE
	move.l	a0,$126(a1)
	move.l	a0,-(sp)
	dc.w	$6100,$03E6
	dc.w	$6100,$0482
.l7F7C	move.b	(a0),d0
	cmp.b	(a0),d0
	bne.b	.l7F7C
	lsl.w	#$8,d0
	adda.l	#$1,a0
.l7F8A	move.b	(a0),d0
	cmp.b	(a0),d0
	bne.b	.l7F8A
	move.w	d0,$12E(a1)
	adda.l	#$1,a0
	movea.l	(sp)+,a0
	dc.w	$6100,$0412
	movea.l	$126(a1),a0
	adda.l	#$2,a0
	move.l	a0,$12A(a1)
	clr.l	d0
	move.b	$A00024.l,d0
	lsl.w	#$8,d0
	move.b	$A00025.l,d0
	addi.l	#$A00000,d0
	movea.l	d0,a1
	dc.w	$6000,$0082
.l7FCA	cmpi.b	#$2,$A00072.l
	dc.w	$6636
	dc.w	$207A,$056E
	cmpa.l	#$0,a0
	dc.w	$6610
	dc.w	$6100,$0370
	dc.w	$6100,$FBAA
	dc.w	$6100,$0354
	dc.w	$6000,$00CA
.l7FF0	clr.l	d0
	move.b	$A00024.l,d0
	lsl.w	#$8,d0
	move.b	$A00025.l,d0
	addi.l	#$A00000,d0
	movea.l	d0,a1
	dc.w	$6040
.l800A	cmpi.b	#$3,$A00072.l
	dc.w	$6600,$00A4
	dc.w	$207A,$052C
	cmpa.l	#$0,a0
	dc.w	$6610
	dc.w	$6100,$032E
	dc.w	$6100,$FB68
	dc.w	$6100,$0312
	dc.w	$6000,$0088
.l8032	clr.l	d0
	move.b	$A00026.l,d0
	lsl.w	#$8,d0
	move.b	$A00027.l,d0
	addi.l	#$A00000,d0
	movea.l	d0,a1
.l804A	move.l	a0,-(sp)
	dc.w	$6100,$030E
	dc.w	$6100,$03AA
	move.w	#$1FF,d1
.l8058	move.b	(a0)+,(a1)+
	dc.w	$671E
	dbra	d1,.l8058
	dc.w	$43FA,$03B8
	move.l	$12A(a1),d0
	addi.l	#$200,d0
	move.l	d0,$12A(a1)
	movea.l	(sp)+,a0
	dc.w	$6100,$033A
	dc.w	$603E
.l807A	suba.l	#$1,a1
	movea.l	(sp)+,a0
	dc.w	$6100,$032C
	clr.l	d0
	dc.w	$303A,$04BE
	cmpi.w	#$FFFF,d0
	dc.w	$671A
	move.b	#$FF,(a1)
	dc.w	$43FA,$0382
	movea.l	$126(a1),a0
	adda.l	#$2,a0
	adda.l	d0,a0
	move.l	a0,$12A(a1)
	dc.w	$600C
.l80AC	dc.w	$43FA,$036C
	move.l	#$0,$12A(a1)
.l80B8	move.b	#$0,$A00072.l
	dc.w	$6100,$0290
	movem.l	(sp)+,d1-d2/a0
	rts
LFF80CA	movem.l	d1-d4/a1-a2,-(sp)
	dc.w	$43FA,$051C
	move.w	#$4,d2
.l80D6	cmpi.l	#$FFFFFFFF,(a1)
	dc.w	$6700,$00A2
	movea.l	(a1),a0
	movea.l	a0,a2
	move.l	a0,-(sp)
	dc.w	$6100,$0274
	dc.w	$6100,$0310
	clr.l	d3
.l80F0	move.b	(a0),d3
	cmp.b	(a0),d3
	bne.b	.l80F0
	adda.l	#$1,a0
	lsl.w	#$8,d3
.l80FE	move.b	(a0),d3
	cmp.b	(a0),d3
	bne.b	.l80FE
	adda.l	#$1,a0
	move.l	d3,d4
	lsl.w	#$2,d4
	adda.l	d4,a2
	adda.l	#$2,a2
.l8116	move.b	(a0),d4
	cmp.b	(a0),d4
	bne.b	.l8116
	cmp.b	d4,d0
	dc.w	$6634
.l8120	move.b	$1(a0),d4
	cmp.b	$1(a0),d4
	bne.b	.l8120
	cmp.b	d4,d1
	dc.w	$6626
	clr.w	d0
.l8130	move.b	$2(a0),d0
	cmp.b	$2(a0),d0
	bne.b	.l8130
	lsl.w	#$8,d0
.l813C	move.b	$3(a0),d0
	cmp.b	$3(a0),d0
	bne.b	.l813C
	movea.l	(sp)+,a0
	dc.w	$6100,$0266
	movea.l	a2,a0
	andi.b	#$FE,ccr
	dc.w	$6042
.l8154	clr.l	d4
	move.b	$2(a0),d4
	cmp.b	$2(a0),d4
	bne.b	.l8154
	lsl.w	#$8,d4
.l8162	move.b	$3(a0),d4
	cmp.b	$3(a0),d4
	bne.b	.l8162
	adda.l	d4,a2
	adda.l	#$4,a0
	dc.w	$0443,$0001
	dc.w	$669C
	movea.l	(sp)+,a0
	dc.w	$6100,$0232
.l8180	adda.l	#$4,a1
	dc.w	$0442,$0001
	dc.w	$6600,$FF4A
	move.w	#$3,d0
	ori.b	#$1,ccr
.l8196	movem.l	(sp)+,d1-d4/a1-a2
	rts
LFF819C	movem.l	d1/a1,-(sp)
	lsl.w	#$2,d1
	dc.w	$43FA,$0448
	move.l	a0,(a1,d1.w)
	movem.l	(sp)+,d1/a1
	rts
LFF81B0	movem.l	d1/a0-a1,-(sp)
	movea.l	a0,a1
.l81B6	cmpi.w	#$FFFF,(a1)
	dc.w	$6604
	clr.w	d0
	dc.w	$6034
.l81C0	move.w	(a1),d0
	move.w	$2(a1),d1
	dc.w	$6100,$FF02
	dc.w	$6524
	cmpi.w	#$0,(a1)
	dc.w	$6616
	cmpi.b	#$6,(a0)
	dc.w	$6410
	move.w	d0,d1
	move.w	$2(a1),d0
	dc.w	$6100,$FB7A
	dc.w	$650C
	dc.w	$6000,$0002
.l81E8	adda.l	#$4,a1
	bra.b	.l81B6
.l81F0	ori.b	#$1,ccr
.l81F4	movem.l	(sp)+,d1/a0-a1
	rts
LFF81FA	movem.l	d1-d3/a0-a2,-(sp)
	dc.w	$43FA,$021A
	move.w	#$0,(a1)
	dc.w	$6100,$0136
.l820A	cmpi.w	#$FFFF,(a0)
	dc.w	$6700,$00D4
	cmpi.w	#$6,(a0)
	dc.w	$6400,$00C2
	lea.l	$A00100.l,a1
	move.w	$2(a0),d0
	move.w	#$3F,d1
.l8228	cmp.b	(a1),d0
	dc.w	$670E
	adda.l	#$4,a1
	dbra	d1,.l8228
	dc.w	$6000,$00A2
.l823A	clr.w	d0
	move.b	$1(a1),d0
	clr.w	d1
	move.b	$2(a1),d1
	lsl.w	#$8,d1
	move.b	$3(a1),d1
	move.w	d1,d2
	add.w	d0,d2
	lea.l	$A00000.l,a2
.l8256	cmpi.w	#$1F00,d2
	dc.w	$6710
	move.b	(a2,d2.w),(a2,d1.w)
	dc.w	$0642,$0001
	dc.w	$0641,$0001
	dc.w	$60EA
.l826C	clr.w	d1
	move.b	$2(a1),d1
	lsl.w	#$8,d1
	move.b	$3(a1),d1
	move.b	#$FF,(a1)
	move.b	#$FF,$1(a1)
	move.b	#$FF,$2(a1)
	move.b	#$FF,$3(a1)
	lea.l	$A00100.l,a1
	move.w	#$3F,d2
.l8298	cmpi.b	#$FF,(a1)
	dc.w	$6600,$001E
	clr.w	d3
	move.b	$2(a1),d3
	lsl.w	#$8,d3
	move.b	$3(a1),d3
	cmp.w	d1,d3
	dc.w	$640C
	sub.w	d0,d3
	move.b	d3,$3(a1)
	lsr.w	#$8,d3
	move.b	d3,$2(a1)
.l82BC	dbra	d2,.l8298
	lea.l	$A00022.l,a1
	clr.w	d1
	move.b	(a1),d1
	lsl.w	#$8,d1
	move.b	$1(a1),d1
	sub.w	d0,d1
	move.b	d1,$1(a1)
	lsr.w	#$8,d1
	move.b	d1,(a1)
.l82DA	adda.l	#$4,a0
	dc.w	$6000,$FF28
.l82E4	dc.w	$6100,$006C
	dc.w	$43FA,$0130
	move.w	#$1234,(a1)
	clr.w	d0
	movem.l	(sp)+,d1-d3/a0-a2
	rts
LFF82F8	movem.l	a0-a1,-(sp)
	dc.w	$41FA,$011C
	move.w	#$0,(a0)
	dc.w	$6100,$0038
	lea.l	$A00100.l,a0
	move.w	#$FF,d0
.l8312	move.b	#$FF,(a0)+
	dbra	d0,.l8312
	lea.l	$A00020.l,a0
	lea.l	$A00022.l,a1
	move.b	(a0)+,(a1)+
	move.b	(a0),(a1)
	dc.w	$6100,$0026
	dc.w	$41FA,$00EA
	move.w	#$1234,(a0)
	clr.w	d0
	movem.l	(sp)+,a0-a1
	rts
LFF833E	move.w	#$100,$A11100.l
.l8346	btst.b	#$8,$A11100.l
	bne.b	.l8346
	rts
LFF8352	move.w	#$0,$A11100.l
	rts
LFF835C	movem.l	d0-d1/a1,-(sp)
	cmpa.l	#$80000,a0
	dc.w	$6400,$0042
	move.b	#$3,$A12001.l
.l8372	move.w	$A12000.l,d0
	btst	#$1,d0
	beq.b	.l8372
	move.l	a0,d0
	swap	d0
	andi.w	#$6,d0
	lsl.w	#$5,d0
	dc.w	$43FA,$0260
	move.w	$A12002.l,d1
	move.w	d1,(a1)
	btst	#$2,d1
	dc.w	$6704
	bset	#$1,d0
.l839E	andi.w	#$FF00,d1
	or.w	d0,d1
	move.w	d1,$A12002.l
.l83AA	movem.l	(sp)+,d0-d1/a1
	rts
LFF83B0	move.l	d0,-(sp)
	cmpa.l	#$80000,a0
	dc.w	$643E
	dc.w	$303A,$022E
	btst	#$2,d0
	dc.w	$670A
	andi.w	#$FFC0,d0
	bset	#$1,d0
	dc.w	$6004
.l83CE	andi.w	#$FFC0,d0
.l83D2	move.w	d0,$A12002.l
	move.w	#$1,$A12000.l
.l83E0	move.w	$A12000.l,d0
	btst	#$1,d0
	bne.b	.l83E0
	move.w	$A12000.l,d0
	btst	#$1,d0
	bne.b	.l83E0
.l83F8	move.l	(sp)+,d0
	rts
LFF83FC	move.l	d0,-(sp)
	cmpa.l	#$80000,a0
	dc.w	$6410
	move.l	a0,d0
	andi.l	#$1FFFF,d0
	ori.l	#$20000,d0
	movea.l	d0,a0
.l8416	move.l	(sp)+,d0
	rts
LFF841A	dc.b	$00,$00	; ..
LFF841C	dcb.b	$20,0
LFF843C	dcb.b	$20,0
LFF845C	dcb.b	$10,0
LFF846C	dcb.b	$10,0
LFF847C	dcb.b	$10,0
LFF848C	dcb.b	$10,0
LFF849C	dcb.b	$20,0
LFF84BC	dcb.b	$82,0
LFF853E	dc.b	$00,$00,$00,$00,$00,$00	; ......
LFF8544	dc.b	$00,$00,$00,$00	; ....
LFF8548	dc.b	$00,$00	; ..
LFF854A	dcb.b	$10,0
LFF855A	dc.b	$00,$00,$00,$00	; ....
LFF855E	dcb.b	$8C,0
LFF85EA	dc.b	$00,$00	; ..
LFF85EC	dcb.b	$51,0
	incbin	..\Extracted\SegaCD\MAIN\main_0863D.bin
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
