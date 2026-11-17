	dcb.b	$1390,0
	dc.b	'HOCKEY.BIN',$00,$00,$01,$FF	; HOCKEY.BIN....
	dcb.b	$14,0
	dc.b	$FF,$FF	; ..
	dcb.b	$72,0
	dc.b	$4E,$F9,$00,$00,$D8,$5A	; N....Z
RestoreBiosSub1	dc.w	$6000,$0084
RestoreBios_1	dcb.b	$82,0
.l22842	cmpi.b	#$80,d0
	dc.w	$6504
	dc.w	$6000,$02C2
.l154C	tst.w	d0
	dc.w	$6604
	dc.w	$6000,$068C
.l1554	subi.w	#$1,d0
	dc.w	$6604
	dc.w	$6000,$0052
.l155E	subi.w	#$1,d0
	dc.w	$6606
	nop
	dc.w	$6000,$0C2C
.l156A	subi.w	#$1,d0
	dc.w	$6604
	dc.w	$6000,$075C
.l1574	subi.w	#$1,d0
	dc.w	$6602
	nop
.l157C	subi.w	#$1,d0
	dc.w	$6604
	dc.w	$6000,$0C80
.l1586	subi.w	#$1,d0
	dc.w	$6604
	dc.w	$6000,$0C8A
.l1590	subi.w	#$1,d0
	dc.w	$6604
	dc.w	$6000,$0DB8
.l159A	subi.w	#$1,d0
	dc.w	$6604
	dc.w	$6000,$0D58
.l15A4	move.w	#$1,d0
	ori.b	#$1,ccr
	rts
.l228AE	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$41FA,$0FBC
	cmpi.w	#$0,(a0)
	dc.w	$6702
	dc.w	$6034
.l15BE	move.w	#$FFFF,(a0)
	dc.w	$6100,$0034
	move.w	$FF800C.l,d0
	dc.w	$907A,$0FF0
	andi.w	#$FFF,d0
	cmpi.w	#$20,d0
	dc.w	$6510
	dc.w	$6100,$006E
	dc.w	$41FA,$0FDE
	move.w	$FF800C.l,d0
	move.w	d0,(a0)
.l15EA	dc.w	$41FA,$0F84
	move.w	#$0,(a0)
.l15F2	movem.l	(sp)+,d0-d7/a0-a6
	rts
.l228F8	movem.l	d0-d1/a0-a1,-(sp)
.l15FC	lea.l	RestoreBios_1(pc),a0
	cmpi.w	#$0,(a0)
	dc.w	$673E
	move.l	$2(a0),d0
	dc.w	$6100,$0200
	lea.l	RestoreBios_1(pc),a0
	move.w	(a0),d0
	move.w	#$FFFF,(a0)
	adda.l	#$2,a0
	movea.l	a0,a1
	adda.l	#$4,a1
	move.w	d0,d1
	subi.w	#$1,d1
	dc.w	$670A
	subi.w	#$1,d1
.l1632	move.l	(a1)+,(a0)+
	dbra	d1,.l1632
.l1638	lea.l	RestoreBios_1(pc),a0
	subi.w	#$1,d0
	move.w	d0,(a0)
	bra.b	.l15FC
.l1644	movem.l	(sp)+,d0-d1/a0-a1
	rts
.l2294A	movem.l	d1-d4/a0-a2,-(sp)
	dc.w	$41FA,$0F70
	move.w	#$0,(a0)
RestoreBios_2	dc.w	$103A,$0F1A
	dc.w	$343A,$0F64
	btst	d2,d0
	dc.w	$6600,$0192
	lsl.w	#$2,d2
	lea.l	$FF0021.l,a0
	cmpi.b	#$0,$2(a0,d2.w)
	dc.w	$661C
	dc.w	$41FA,$0EFC
	dc.w	$303A,$0F46
	move.b	(a0),d2
	bset	d0,d2
	move.b	d2,(a0)
	move.b	d2,$FF0011.l
	dc.w	$6100,$0CC8
	dc.w	$6000,$0166
.l1690	dc.w	$343A,$0F2E
	dc.w	$41FA,$0F06
	cmpi.b	#$FF,(a0,d2.w)
	dc.w	$6700,$0154
	clr.w	d1
	move.b	(a0,d2.w),d1
	move.w	#$4,d0
	dc.w	$6100,$0A72
	dc.w	$6500,$0142
	dc.w	$43FA,$0EF6
	dc.w	$303A,$0F06
	lsl.w	#$1,d0
	move.w	$FF800C.l,d1
	dc.w	$927A,$0EF8
	andi.w	#$FFF,d1
	lsr.w	#$5,d1
	add.w	(a1,d0.w),d1
	move.w	d1,(a1,d0.w)
	dc.w	$45FA,$0ECC
	dc.w	$323A,$0EE4
	clr.w	d2
	move.b	(a2,d1.w),d2
	addi.w	#$1,d2
	lsl.w	#$1,d2
	addi.w	#$3,d2
	clr.w	d3
	move.b	(a0,d2.w),d3
	cmp.w	(a1,d0.w),d3
	dc.w	$6452
	move.w	(a1,d0.w),d2
	sub.w	d3,d2
	move.w	d2,(a1,d0.w)
	addi.b	#$1,(a2,d1.w)
	move.b	(a2,d1.w),d2
	cmp.b	$2(a0),d2
	dc.w	$6614
	dc.w	$43FA,$0EA7
	dc.w	$363A,$0EA6
	dc.w	$0711
	dc.w	$6708
	move.b	$1(a0),(a2,d1.w)
	dc.w	$6024
.l1728	addi.b	#$1,d2
	cmp.b	(a0),d2
	dc.w	$651C
	dc.w	$41FA,$0E40
	dc.w	$303A,$0E8A
	move.b	(a0),d1
	bset	d0,d1
	move.b	d1,$FF0011.l
	move.b	d1,(a0)
	dc.w	$6100,$0C0C
	dc.w	$6000,$00AA
.l174C	dc.w	$43FA,$0E56
	dc.w	$303A,$0E6E
	clr.w	d1
	move.b	(a1,d0.w),d1
	lsl.w	#$1,d1
	addi.w	#$3,d1
	move.b	$1(a0,d1.w),d0
	cmp.b	$3(a0,d1.w),d0
	dc.w	$650C
	clr.w	d2
	move.b	$1(a0,d1.w),d2
	sub.b	$3(a0,d1.w),d2
	dc.w	$600A
.l1776	clr.w	d2
	move.b	$3(a0,d1.w),d2
RestoreBiosSub2	sub.b	$1(a0,d1.w),d2
.l22A80	cmpi.b	#$0,d2
	dc.w	$6606
	move.b	$1(a0,d1.w),d2
	dc.w	$603C
.l178C	dc.w	$43FA,$0E1E
	dc.w	$303A,$0E2E
	lsl.w	#$1,d0
	move.w	(a1,d0.w),d3
	lsl.w	#$8,d3
	clr.w	d4
	move.b	$2(a0,d1.w),d4
	divu.w	d4,d3
	move.b	$1(a0,d1.w),d0
	cmp.b	$3(a0,d1.w),d0
	dc.w	$650E
	mulu.w	d2,d3
	lsr.w	#$8,d3
	clr.w	d2
	move.b	$1(a0,d1.w),d2
	sub.w	d3,d2
	dc.w	$600C
.l22ABC	dc.b	$C6,$C2,$E0,$4B,$42,$42,$14,$30,$10,$01,$D4,$43	; ...KBB.0...C
.l22AC8	dc.b	$43,$FA,$0D,$C2,$30,$3A,$0D,$F2,$42,$43,$16,$31,$00,$00,$E3,$4B	; C...0:..BC.1...K
	dc.b	$C4,$C3,$E0,$4A,$00,$00,$00,$C0,$13,$C0,$00,$FF,$00,$0F,$61,$00	; ...J..........a.
	dc.b	$0B,$6A,$13,$C2,$00,$FF,$00,$01,$61,$00,$0B,$60	; .j......a..`
.l22AF4	dc.w	$41FA,$0DCA
	addi.w	#$1,(a0)
	cmpi.w	#$8,(a0)
	dc.w	$6704
	bra.w	RestoreBios_2
.l1806	movem.l	(sp)+,d1-d4/a0-a2
	rts
.l22B0C	cmpi.b	#$8F,d0
	dc.w	$6E04
	dc.w	$6000,$019A
.l1816	cmpi.b	#$9F,d0
	dc.w	$6E04
	dc.w	$6000,$0038
.l1820	cmpi.b	#$AF,d0
	dc.w	$6E02
	dc.w	$6024
.l1828	cmpi.b	#$BF,d0
	dc.w	$6E02
	nop
.l1830	cmpi.b	#$CF,d0
	dc.w	$6E04
	dc.w	$6000,$0278
.l183A	cmpi.b	#$DF,d0
	dc.w	$6E02
	dc.w	$600A
.l1842	cmpi.b	#$EF,d0
	dc.w	$6E04
	dc.w	$6000,$028A
.l184C	move.w	#$1,d0
	ori.b	#$1,ccr
	rts
.l22B56	movem.l	d1-d2/a0-a1,-(sp)
	dc.w	$41FA,$0B06
	move.b	d0,d1
	andi.w	#$F,d1
	move.l	d0,d2
	swap	d2
	lsr.w	#$8,d2
	or.b	d2,d1
	move.w	d1,$260(a0)
	move.w	d0,d1
	lsr.w	#$8,d1
	move.w	d1,$262(a0)
	move.l	d0,d1
	swap	d1
	andi.w	#$FF,d1
	move.w	d1,$264(a0)
	dc.w	$343A,$0D3C
	dc.w	$41FA,$0D46
	clr.w	d1
	move.b	(a0,d2.w),d1
.l1892	dc.w	$41FA,$0D34
	move.w	d1,(a0)
	move.w	#$0,d0
	dc.w	$6100,$0882
	dc.w	$6500,$0106
	dc.w	$43FA,$0D26
	move.l	a0,(a1)
	cmpi.b	#$7,(a0)
	dc.w	$6610
	dc.w	$303A,$0D12
	addi.w	#$1,d0
	clr.w	d1
	move.b	(a0,d0.w),d1
	bra.b	.l1892
.l18C0	dc.w	$6100,$07BE
	dc.w	$6404
	dc.w	$6000,$00E0
.l18CA	dc.w	$303A,$0CF4
	dc.w	$41FA,$0CA4
	dc.w	$11BA,$0CEF,$0000
	dc.w	$41FA,$0CA2
	dc.w	$11BA,$0CEB,$0000
	dc.w	$41FA,$0CA0
	dc.w	$11BA,$0CDD,$0000
	dc.w	$41FA,$0C9E
	dc.w	$11BA,$0CD5,$0000
	dc.w	$41FA,$0C9C
	dc.w	$227A,$0CD0
	move.b	$1(a1),(a0,d0.w)
	dc.w	$303A,$0CC4
	btst	#$0,d0
	dc.w	$6706
	btst	#$1,d0
	dc.w	$6778
.l1914	dc.w	$103A,$0C5C
	dc.w	$323A,$0CA6
	bset	d1,d0
	move.b	d0,$FF0011.l
	dc.w	$6100,$0A2C
	ori.b	#$C0,d1
	move.b	d1,$FF000F.l
	dc.w	$6100,$0A1E
	dc.w	$207A,$0C94
	clr.w	d0
	move.b	$2(a0),d0
	lsl.w	#$1,d0
	dc.w	$43FA,$0A22
	move.w	(a1,d0.w),d1
	lsr.w	#$8,d1
	move.b	d1,$FF000D.l
	dc.w	$6100,$09FE
	move.b	$5(a0),d1
	lsl.w	#$8,d1
	move.b	$6(a0),d1
	cmpi.w	#$FFFF,d1
	dc.w	$6604
	clr.w	d1
	dc.w	$6004
.l196A	add.w	(a1,d0.w),d1
.l196E	move.b	d1,$FF0009.l
	dc.w	$6100,$09DC
	lsr.w	#$8,d1
	move.b	d1,$FF000B.l
	dc.w	$6100,$09D0
	dc.w	$6100,$01A2
	dc.w	$6100,$0636
.l198C	dc.w	$6100,$0478
	dc.w	$41FA,$0BE0
	dc.w	$303A,$0C2A
	move.b	(a0),d1
	bclr	d0,d1
	move.b	d1,$FF0011.l
	dc.w	$6100,$09AE
	move.b	d1,(a0)
.l19A8	movem.l	(sp)+,d1-d2/a0-a1
	rts
.l22CAE	movem.l	d1-d3/a0-a2,-(sp)
	clr.w	d1
	move.b	d0,d1
	andi.b	#$F,d1
	move.l	d0,d2
	swap	d2
	lsr.w	#$8,d2
	or.b	d2,d1
	dc.w	$41FA,$0BFE
	move.w	d1,(a0)
	move.w	d0,d1
	lsr.w	#$8,d1
	dc.w	$41FA,$0BF6
	move.w	d1,(a0)
	dc.w	$41FA,$0BFC
	dc.w	$303A,$0BEA
	clr.w	d1
	move.b	(a0,d0.w),d1
.l19E0	move.w	#$0,d0
	dc.w	$6100,$073A
	dc.w	$6500,$00C0
	cmpi.b	#$7,(a0)
	dc.w	$6610
	dc.w	$303A,$0BD0
	addi.w	#$1,d0
	clr.w	d1
	move.b	(a0,d0.w),d1
	bra.b	.l19E0
.l1A02	move.b	$5(a0),d0
	lsl.w	#$8,d0
	move.b	$6(a0),d0
	cmpi.w	#$FFFF,d0
	dc.w	$6700,$0098
	dc.w	$103A,$0B5C
	clr.w	d1
	dc.w	$43FA,$0B58
	dc.w	$45FA,$0B64
	dc.w	$343A,$0B9E
	dc.w	$363A,$0B9C
.l1A2A	btst	d1,d0
	dc.w	$665E
	cmp.b	(a1),d2
	dc.w	$665A
	cmp.b	(a2),d3
	dc.w	$6656
	cmpi.b	#$FF,$D(a0)
	dc.w	$6738
	dc.w	$43FA,$0B7D
	bclr.b	d1,(a1)
	dc.w	$43FA,$0B7A
	move.w	d1,(a1)
	clr.w	d1
	move.b	$D(a0),d1
	move.w	#$4,d0
	dc.w	$6100,$06CA
	dc.w	$6550
	dc.w	$43FA,$0B48
	dc.w	$303A,$0B60
	move.b	$2(a0),(a1,d0.w)
	lsl.w	#$1,d0
	dc.w	$43FA,$0B40
	move.w	#$0,(a1,d0.w)
	dc.w	$6034
.l1A76	dc.w	$41FA,$0AFA
	bset	d1,d0
	move.b	d0,(a0)
	move.b	d0,$FF0011.l
	dc.w	$6100,$08CC
	clr.w	d0
	dc.w	$601E
.l1A8C	adda.l	#$1,a1
	adda.l	#$1,a2
	addi.w	#$1,d1
	cmpi.w	#$8,d1
	bne.b	.l1A2A
	move.w	#$FFFF,d0
	ori.b	#$1,ccr
.l1AAA	movem.l	(sp)+,d1-d3/a0-a2
	rts
.l22DB0	movem.l	d1-d2/a0,-(sp)
	move.l	d0,d1
	swap	d1
	lsr.w	#$8,d1
	move.w	d0,d2
	andi.w	#$F,d2
	or.b	d1,d2
	lsr.w	#$8,d0
	dc.w	$41FA,$0B0A
	move.b	d0,(a0,d2.w)
	clr.w	d0
	movem.l	(sp)+,d1-d2/a0
	rts
.l22DD4	movem.l	d1-d2/a0,-(sp)
	move.l	d0,d1
	swap	d1
	lsr.w	#$8,d1
	move.w	d0,d2
	andi.w	#$F,d2
	or.b	d1,d2
	lsr.w	#$8,d0
	dc.w	$41FA,$0CE6
	move.b	d0,(a0,d2.w)
	dc.w	$41FA,$0ACE
	move.w	#$0,(a0)
.l1AF8	dc.w	$303A,$0AC6
	dc.w	$123A,$0A74
	btst	d0,d1
	dc.w	$670E
	dc.w	$41FA,$0A6E
	cmp.b	(a0,d0.w),d2
	dc.w	$6604
	dc.w	$6100,$02F6
.l1B12	dc.w	$41FA,$0AAC
	addi.w	#$1,(a0)
	cmpi.w	#$8,(a0)
	bne.b	.l1AF8
	clr.w	d0
	movem.l	(sp)+,d1-d2/a0
	dc.w	$4E75
.l22E28	dc.b	$48,$E7,$60,$80,$20,$7A,$0A,$9E,$42,$41,$12,$28,$00,$0D,$41,$FA	; H.`. z..BA.(..A.
	dc.b	$0A,$64,$30,$3A,$0A,$84,$11,$81,$00,$00,$0C,$01,$00,$FF,$67,$0A	; .d0:..........g.
	dc.b	$30,$3C,$00,$04,$61,$00,$05,$D2,'d.0:',$0A,$6C,$00,$00	; 0<..a...d.0:.l..
	dc.b	$00,$C0,$13,$C0,$00,$FF,$00,$0F,$61,$00,$07,$F0,$41,$FA,$0A,$26	; ........a...A..&
	dc.b	$30,$3A,$0A,$56,$12,$30,$00,$00,$E3,$49,$13,$C1,$00,$FF,$00,$01	; 0:.V.0...I......
	dc.b	$61,$00,$07,$D8,'B@`XB@',$10,$28,$00,$04,$41,$FA	; a...B@`XB@.(..A.
	dc.b	$0A,$04,$32,$3A,$0A,$34,$42,$42,$14,$30,$10,$00,$E3,$4A,$C0,$C2	; ..2:.4BB.0...J..
	dc.b	$E0,$48,$32,$3A,$0A,$24,$00,$01,$00,$C0,$13,$C1,$00,$FF,$00,$0F	; .H2:.$..........
	dc.b	$61,$00,$07,$A8,$13,$C0,$00,$FF,$00,$01,$61,$00,$07,$9E,$41,$FA	; a.........a...A.
	dc.b	$09,$EC,$30,$3A,$0A,$04,$11,$BC,$00,$00,$00,$00	; ..0:........
RestoreBiosSub3	dc.w	$41FA,$09F7
	bset.b	d0,(a0)
	lsl.w	#$1,d0
	dc.w	$41FA,$09DE
	move.w	#$0,(a0,d0.w)
	clr.w	d0
	movem.l	(sp)+,d1-d2/a0
	rts
.l22EDE	movem.l	d0/a0-a1,-(sp)
	dc.w	$41FA,$077E
	move.w	#$100,$0(a0)
	move.w	#$100,$2(a0)
	dc.w	$43FA,$0974
	move.w	#$1,d0
.l1BFA	move.l	#$FFFFFFFF,(a1)+
	dbra	d0,.l1BFA
	move.b	#$FF,$210(a0)
	dc.w	$41FA,$09C4
	move.w	#$7F,d0
.l1C12	move.b	#$0,(a0)+
	dbra	d0,.l1C12
	dc.w	$41FA,$0A34
	move.w	#$7F,d0
.l1C22	move.b	#$0,(a0)+
	dbra	d0,.l1C22
	dc.w	$41FA,$0AA4
	move.w	#$7F,d0
.l1C32	move.b	#$7F,(a0)+
	dbra	d0,.l1C32
	dc.w	$41FA,$0B14
	move.w	#$7F,d0
.l1C42	move.b	#$40,(a0)+
	dbra	d0,.l1C42
	dc.w	$41FA,$0B84
	move.w	#$7F,d0
.l1C52	move.b	#$40,(a0)+
	dbra	d0,.l1C52
	dc.w	$41FA,$0BF4
	move.w	#$7,d0
.l1C62	move.b	#$FF,(a0)+
	dbra	d0,.l1C62
	dc.w	$41FA,$0BEC
	move.b	#$FF,(a0)
	lea.l	RestoreBios_1(pc),a0
	move.w	#$0,(a0)
	move.b	#$80,$FF000F.l
	dc.w	$6100,$06CE
	lea.l	$FF2001.l,a0
	move.w	#$EB,d0
.l1C90	move.b	#$80,(a0)
	adda.l	#$2,a0
	nop
	nop
	nop
	nop
	dbra	d0,.l1C90
	move.w	#$F,d0
.l1CAA	move.b	#$FF,(a0)
	adda.l	#$2,a0
	nop
	nop
	nop
	nop
	dbra	d0,.l1CAA
	dc.w	$41FA,$08AE
	move.w	#$0,(a0)
	movem.l	(sp)+,d0/a0-a1
	rts
.l22FCE	movem.l	d1-d7/a0,-(sp)
	dc.w	$103A,$089E
	move.w	#$7,d5
.l1CDA	btst	d5,d0
	dc.w	$663C
	dbra	d5,.l1CDA
	dc.w	$41FA,$08B0
	move.w	#$FFFF,d5
	move.b	#$FF,d6
	clr.w	d0
.l1CF0	cmp.b	(a0),d6
	dc.w	$6504
	move.w	d0,d5
	move.b	(a0),d6
.l1CF8	adda.l	#$1,a0
	addi.w	#$1,d0
	cmpi.w	#$8,d0
	bne.b	.l1CF0
	cmpi.w	#$FFFF,d5
	dc.w	$660C
	move.w	#$7,d0
	ori.b	#$1,ccr
	dc.w	$6000,$00E8
.l1D1A	dc.w	$41FA,$08A4
	move.w	d5,(a0)
	dc.w	$41FA,$0850
	move.b	(a0),d0
	bset	d5,d0
	move.b	d0,$FF0011.l
	dc.w	$6100,$0622
	dc.w	$41FA,$0632
	lsl.w	#$1,d1
	cmpi.w	#$FFFF,(a0,d1.w)
	dc.w	$660C
	move.b	#$3,d0
	ori.b	#$1,ccr
	dc.w	$6000,$00B6
.l2304C	dc.b	$30,$3A,$08,$72,$00,$00,$00,$C0,$13,$C0,$00,$FF,$00,$0F,$30,$30	; 0:.r..........00
	dc.b	$10,$00,$E0,$48,$13,$C0,$00,$FF,$00,$0D,$61,$00,$05,$EA,$13,$FC	; ...H......a.....
	dc.b	$00,$00,$00,$FF,$00,$09,$61,$00,$05,$DE,$13,$FC,$00,$00,$00,$FF	; ......a.........
	dc.b	$00,$0B,$61,$00,$05,$D2,$13,$C2,$00,$FF,$00,$05,$61,$00,$05,$C8	; ..a.........a...
	dc.b	$E0,$4A,$13,$C2,$00,$FF,$00,$07,$61,$00,$05,$BC,$13,$C3,$00,$FF	; .J......a.......
	dc.b	$00,$01,$61,$00,$05,$B2,$13,$C4,$00,$FF,$00,$03,$61,$00,$05,$A8	; ..a.........a...
	dc.b	$41,$FA,$07,$C4,$30,$3A,$08,$0E,$12,$10,$01,$81,$10,$81,$13,$C1	; A...0:..........
	dc.b	$00,$FF,$00,$11,$61,$00,$05,$90,$41,$FA,$07,$AE,$11,$BC,$00,$FF	; ....a...A.......
	dc.b	$00,$00,$41,$FA,$07,$AC,$11,$BC,$00,$FF,$00,$00,$41,$FA,$07,$AA	; ..A.........A...
	dc.b	$11,$BC,$00,$FF,$00,$00,$41,$FA,$07,$A8,$11,$BC,$00,$FF,$00,$00	; ......A.........
	dc.b	$41,$FA,$07,$A6,$11,$BC,$00,$00,$00,$00,$41,$FA,$07,$A4,$11,$BC	; A.........A.....
	dc.b	$00,$FF,$00,$00	; ....
.l23100	movem.l	(sp)+,d1-d7/a0
	dc.w	$4E75
.l23106	dc.b	$48,$E7,$7E,$C0,$20,$7A,$07,$C0,'B@BA4:',$07,$AC	; H.~. z..B@BA4:..
	dc.b	$43,$FA,$07,$6C,$16,$31,$20,$00,$B6,$28	; C..l.1 ..(
RestoreBiosSub4	dc.w	$0003,$6D08
	sub.b	$3(a0),d3
	add.b	d3,d0
	dc.w	$600A
	dc.b	$16,$28,$00,$03,$96,$31,$20,$00,$90,$03	; .(...1 ...
.l23136	dc.w	$343A,$078A
	dc.w	$43FA,$0994
	clr.w	d3
	move.b	(a1,d2.w),d3
	cmpi.b	#$40,d3
	dc.w	$673C
	dc.w	$6D1C
	subi.b	#$40,d3
	lsl.w	#$2,d3
	clr.w	d4
	move.b	$7(a0),d4
	mulu.w	d4,d3
	add.b	d3,d1
	dc.w	$6404
	addi.b	#$1,d0
.l1E62	lsr.w	#$8,d3
	add.b	d3,d0
	dc.w	$601E
.l1E68	move.b	#$40,d3
	sub.b	(a1,d2.w),d3
	lsl.w	#$2,d3
	clr.w	d4
	move.b	$8(a0),d4
	mulu.w	d4,d3
	sub.b	d3,d1
	dc.w	$6404
	subi.b	#$1,d0
.l1E82	lsr.w	#$8,d3
	sub.b	d3,d0
.l1E86	clr.w	d2
	move.b	$4(a0),d2
	cmpi.b	#$0,d2
	dc.w	$6724
	btst	#$7,d2
	dc.w	$660C
	lsl.b	#$1,d2
	add.b	d2,d1
	dc.w	$6418
	addi.b	#$1,d0
	dc.w	$6012
.l231A4	dc.b	$0A,$02,$00,$FF,$06,$02,$00,$01,$E3,$0A,$92,$02,$64,$04,$04,$00	; ............d...
	dc.b	$00,$01	; ..
.l231B6	dc.b	$48,$80,$E3,$48,$43,$FA,$00,$A2,$34,$31,$00,$00,$36,$31,$00,$02	; H..HC...41..61..
	dc.b	$96,$42,$C6,$C1,$E0,$4B,$D4,$43,$30,$3A,$06,$F0,$00,$00,$00,$C0	; .B...K.C0:......
	dc.b	$13,$C0,$00,$FF,$00,$0F,$61,$00,$04,$74,$13,$C2,$00,$FF,$00,$05	; ......a..t......
	dc.b	$61,$00,$04,$6A,$E0,$4A,$13,$C2,$00,$FF,$00,$07,$61,$00,$04,$5E	; a..j.J......a..^
	dc.b	$42,$40,$4C,$DF,$03,$7E,$4E,$75,$00,$80,$00,$88,$00,$90,$00,$98	; B@L..~Nu........
	dc.b	$00,$A2,$00,$AB,$00,$B5,$00,$C0,$00,$CB,$00,$D7,$00,$E4,$00,$F2	; ................
	dc.b	$01,$00,$01,$0F,$01,$1F,$01,$30,$01,$43,$01,$56,$01,$6A,$01,$80	; .......0.C.V.j..
	dc.b	$01,$96,$01,$AF,$01,$C8,$01,$E3,$02,$00,$02,$1E,$02,$3F,$02,$61	; .............?.a
	dc.b	$02,$85,$02,$AB,$02,$D4,$02,$FF,$03,$2D,$03,$5D,$03,$90,$03,$C7	; .........-.]....
	dc.b	$04,$00,$04,$3D,$04,$7D,$04,$C2,$05,$0A,$05,$57,$05,$A8,$05,$FE	; ...=.}.....W....
	dc.b	$06,$59,$06,$BA,$07,$21,$07,$8D,$08,$00,$08,$7A,$08,$FB,$09,$83	; .Y...!.....z....
	dc.b	$0A,$14,$0A,$AE,$0B,$50,$0B,$FD,$0C,$B3,$0D,$74,$0E,$41,$0F,$1A	; .....P.....t.A..
	dc.b	$10,$00,$10,$F4,$11,$F6,$13,$07,$14,$29,$15,$56,$16,$A1,$17,$F9	; .........).V....
	dc.b	$19,$66,$1A,$E9,$1C,$82,$1E,$34,$20,$00,$21,$E7,$23,$EB,$26,$0E	; .f.....4 .!.#.&.
	dc.b	$28,$51,$2A,$B7,$2D,$41,$2F,$F2,$32,$CC,$35,$D1,$39,$04,$3C,$68	; (Q*.-A/.2.5.9.<h
	dc.b	$40,$00,$43,$CE,$47,$D6,$4C,$1C,$50,$A3,$55,$6E,$5A,$82,$5F,$E4	; @.C.G.L.P.UnZ._.
	dc.b	$65,$98,$6B,$A3,$72,$09,$78,$D1,$80,$00	; e.k.r.x...
.l232C0	movem.l	d1-d3/a0,-(sp)
	dc.w	$303A,$05FA
	dc.w	$41FA,$05AA
	clr.w	d3
	move.b	(a0,d0.w),d3
	dc.w	$41FA,$06FC
	clr.w	d2
	move.b	(a0,d3.w),d2
	lsl.w	#$1,d2
	dc.w	$41FA,$05F0
	clr.w	d1
	move.b	(a0,d3.w),d1
	move.w	#$0,d0
	dc.w	$6100,$0132
	dc.w	$6500,$0088
	clr.w	d1
	move.b	$B(a0),d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	move.w	d3,d0
	lsr.w	#$4,d0
	dc.w	$41FA,$084C
	clr.w	d1
	move.b	(a0,d0.w),d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	clr.w	d1
	dc.w	$123A,$0844
	mulu.w	d1,d2
	lsr.w	#$8,d2
	dc.w	$41FA,$0734
	clr.w	d1
	move.b	(a0,d3.w),d1
	cmpi.b	#$40,d1
	dc.w	$660A
	lsr.b	#$4,d2
	move.b	d2,d0
	lsl.b	#$4,d0
	or.b	d2,d0
	dc.w	$6028
.l2034	dc.w	$6E12
	move.b	d2,d0
	lsr.b	#$4,d0
	lsl.w	#$2,d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	andi.b	#$F0,d2
	or.b	d2,d0
	dc.w	$6014
.l2048	move.b	d2,d0
	andi.b	#$F0,d0
	subi.w	#$40,d1
	lsl.w	#$2,d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	lsr.b	#$4,d2
	or.b	d2,d0
.l205C	dc.w	$323A,$0562
	ori.b	#$C0,d1
	move.b	d1,$FF000F.l
	dc.w	$6100,$02E6
	move.b	d0,$FF0003.l
	dc.w	$6100,$02DC
	clr.w	d0
.l207A	movem.l	(sp)+,d1-d3/a0
	rts
.l23380	movem.l	d1-d2/a0,-(sp)
	dc.w	$41FA,$0544
	move.w	#$0,(a0)
	dc.w	$207A,$053E
RestoreBiosSub5	btst.b	#$0,$C(a0)
	dc.w	$673A
	dc.w	$41FA,$04E2
	dc.w	$303A,$052A
	dc.w	$123A,$04D0
	clr.w	d2
.l20A6	btst	d2,d1
	dc.w	$661E
	cmp.b	(a0)+,d0
	dc.w	$661A
	dc.w	$41FA,$0510
	move.w	d2,(a0)
	dc.w	$41FA,$0516
	clr.w	d0
	move.b	$C(a0),d0
	dc.w	$41FA,$050A
	move.w	d0,(a0)
	clr.w	d0
	dc.w	$6052
.l20C8	addi.w	#$1,d2
	cmpi.w	#$8,d2
	bne.b	.l20A6
.l20D2	dc.w	$103A,$049E
	clr.w	d1
.l20D8	btst	d1,d0
	dc.w	$670A
	dc.w	$41FA,$04E2
	move.w	d1,(a0)
	clr.w	d0
	dc.w	$6034
.l20E6	addi.w	#$1,d1
	cmpi.w	#$8,d1
	bne.b	.l20D8
	dc.w	$207A,$04DA
	move.b	$1(a0),d0
	dc.w	$41FA,$049A
RestoreBiosSub6	clr.w	d1
RestoreBios_3	cmp.b	(a0)+,d0
RestoreBiosSub7	dc.w	$620A
	dc.w	$41FA,$04BC
	move.w	d1,(a0)
	clr.w	d0
	dc.w	$600E
.l210C	addi.w	#$1,d1
	cmpi.w	#$8,d1
	bne.b	RestoreBios_3
	ori.b	#$1,ccr
.l2341A	movem.l	(sp)+,d1-d2/a0
	rts
RestoreBios_4	movem.l	d1-d4/a1-a2,-(sp)
	dc.w	$43FA,$0442
	move.w	#$2,d2
	cmpi.l	#$FFFFFFFF,(a1)
	dc.w	$6746
	movea.l	(a1),a2
	move.b	(a2)+,d3
	lsl.w	#$8,d3
	move.b	(a2)+,d3
	clr.l	d4
	move.w	d3,d4
	lsl.l	#$2,d4
	add.l	a2,d4
	movea.l	d4,a0
	cmp.b	(a2),d0
	dc.w	$6616
	cmp.b	$1(a2),d1
	dc.w	$6610
	move.b	$2(a2),d0
	lsl.w	#$8,d0
	move.b	$3(a2),d0
	andi.b	#$FE,ccr
	dc.w	$602E
.l23460	dc.b	$42,$84,$18,$2A,$00,$02,$E1,$4C,$18,$2A,$00,$03,$D1,$C4,$D5,$FC	; B..*...L.*......
	dc.b	$00,$00,$00,$04,$04,$43,$00,$01,$66,$CC	; .....C..f.
.l2347A	dc.b	$D3,$FC,$00,$00,$00,$04,$04,$42,$00,$01,$66,$A6,$30,$3C,$00,$03	; .......B..f.0<..
	dc.b	$00,$3C,$00,$01	; .<..
.l2348E	dc.b	$4C,$DF	; L.
RestoreBiosSub8	dc.w	$061E,$4E75
.l23494	move.l	a0,-(sp)
	or.w	d1,d1
	dc.w	$660E
	dc.w	$41FA,$01C6
	move.w	#$100,$2(a0)
	clr.w	d0
	dc.w	$6056
.l21A8	cmpi.w	#$1,d1
	dc.w	$660E
	dc.w	$41FA,$01B2
	move.w	$0(a0),$2(a0)
	clr.w	d0
	dc.w	$6042
.l21BC	cmpi.w	#$2,d1
	dc.w	$6634
	dc.w	$41FA,$019E
	move.w	$2(a0),$0(a0)
	move.w	$2(a0),d0
	dc.w	$41FA,$0194
	move.w	#$FF,d1
.l21D8	cmpi.w	#$FFFF,(a0)
	dc.w	$670A
	cmp.w	(a0),d0
	dc.w	$6200,$0006
	move.w	#$FFFF,(a0)
.l21E8	adda.l	#$2,a0
	dbra	d1,.l21D8
	clr.w	d0
	dc.w	$6008
.l21F6	move.w	#$5,d0
	ori.b	#$1,ccr
.l21FE	clr.w	d0
	movea.l	(sp)+,a0
	rts
.l23504	movem.l	d1/a1,-(sp)
	lsl.w	#$2,d1
	dc.w	$43FA,$035C
	move.l	a0,(a1,d1.w)
	movem.l	(sp)+,d1/a1
	rts
.l23518	movem.l	d1/a0-a1,-(sp)
	movea.l	a0,a1
.l221E	cmpi.w	#$FFFF,(a1)
	dc.w	$6604
	clr.w	d0
	dc.w	$604C
.l2228	move.w	(a1),d0
	move.w	$2(a1),d1
	bsr.w	RestoreBios_4
	dc.w	$653C
	cmpi.w	#$2,(a1)
	dc.w	$662E
	dc.w	$6100,$003E
	dc.w	$6534
	dc.w	$41FA,$0124
	move.w	$2(a1),d0
	lsl.w	#$1,d0
	dc.w	$323A,$0116
	move.w	d1,(a0,d0.w)
	dc.w	$D27A,$0312
	or.b	d1,d1
	dc.w	$6708
	andi.w	#$FF00,d1
	addi.w	#$100,d1
.l2262	dc.w	$41FA,$00FE
	move.w	d1,(a0)
.l2268	adda.l	#$4,a1
	bra.b	.l221E
.l2270	ori.b	#$1,ccr
.l2274	movem.l	(sp)+,d1/a0-a1
	rts
.l2357A	movem.l	d1-d2/a0-a1,-(sp)
	dc.w	$43FA,$02E6
	move.w	d0,(a1)
	dc.w	$323A,$00DC
	dc.w	$6714
	clr.w	d1
	dc.w	$927A,$00D4
RestoreBiosSub9	cmp.w	d0,d1
	dc.w	$620A
	move.w	#$4,d0
	ori.b	#$1,ccr
	dc.w	$6056
.l2359E	dc.w	$343A,$00C2
	lsr.w	#$8,d2
	lsr.w	#$4,d2
	ori.b	#$80,d2
	move.b	d2,$FF000F.l
	dc.w	$6100,$00A0
	dc.w	$323A,$00AC
	andi.l	#$FFF,d1
	lsl.l	#$1,d1
	addi.l	#$FF2001,d1
	movea.l	d1,a1
.l22C8	move.b	(a0)+,d1
	move.b	d1,(a1)
	adda.l	#$2,a1
	cmpa.l	#$FF4001,a1
	dc.w	$6614
	addi.b	#$1,d2
	move.b	d2,$FF000F.l
	dc.w	$6100,$006C
	movea.l	#$FF2001,a1
.l22EE	dbra	d0,.l22C8
	clr.w	d0
.l22F4	movem.l	(sp)+,d1-d2/a0-a1
	rts
.l235FA	movem.l	d1-d3/a0,-(sp)
RestoreBiosSub10	movem.l	d2-d3,-(sp)
	move.w	#$0,d0
	bsr.w	RestoreBios_4
	movem.l	(sp)+,d2-d3
	dc.w	$652C
	cmpi.w	#$0,d3
	dc.w	$660E
	move.b	d2,$6(a0)
	lsr.w	#$8,d2
	move.b	d2,$5(a0)
	clr.w	d0
	dc.w	$6018
.l2324	move.b	$5(a0),d0
	lsl.w	#$8,d0
	move.b	$6(a0),d0
	add.w	d2,d0
	move.b	d0,$6(a0)
	lsr.w	#$8,d0
	move.b	d0,$5(a0)
	clr.w	d0
.l233C	movem.l	(sp)+,d1-d3/a0
	rts
.l2342	move.w	#$80,d0
	jsr	$5F22.l
	bcs.b	.l2342
	rts
.l23650	rts
.l23652	move.l	d0,-(sp)
	move.w	#$28,d0
.l2358	nop
	dbra	d0,.l2358
	move.l	(sp)+,d0
	dc.w	$4E75
.l23662	dc.b	$00,$00,$00,$00	; ....
.l23666	dcb.b	$200,0
.l23866	dc.b	$00,$00	; ..
.l23868	dcb.b	$8,0
.l23870	dc.b	$00,$00	; ..
.l23872	dc.b	$00,$00	; ..
.l23874	dcb.b	$8,0
.l2387C	dcb.b	$8,0
.l23884	dcb.b	$8,0
.l2388C	dcb.b	$8,0
.l23894	dcb.b	$8,0
.l2389C	dcb.b	$8,0
.l238A4	dcb.b	$8,0
.l238AC	dcb.b	$11,0
.l238BD	dc.b	$00	; .
.l238BE	dc.b	$00,$00	; ..
.l238C0	dc.b	$00,$00	; ..
.l238C2	dc.b	$00	; .
.l238C3	dc.b	$00	; .
.l238C4	dc.b	$00	; .
.l238C5	dc.b	$00,$00	; ..
.l238C7	dc.b	$00	; .
.l238C8	dc.b	$00	; .
.l238C9	dc.b	$00	; .
.l238CA	dc.b	$00,$00	; ..
.l238CC	dc.b	$00,$00,$00,$00	; ....
.l238D0	dcb.b	$80,0
.l23950	dcb.b	$80,0
.l239D0	dcb.b	$80,0
.l23A50	dcb.b	$80,0
.l23AD0	dcb.b	$80,0
.l23B50	dcb.b	$8,0
.l23B58	dc.b	$00,$00	; ..
RestoreBiosSub11	move.w	sr,-(sp)
	move.w	d0,$EC90.l
	move.l	d1,$EC92.l
	move.l	d2,$EC96.l
	move.l	d3,$EC9A.l
	move.l	d4,$EC9E.l
	jsr	$E3BC.l
	jsr	$E3F8.l
	jsr	$E3EE.l
	jsr	$E416.l
	move.w	#$0,$BC6E8.l
	move.w	#$2000,sr
	bclr.b	#$2,$FFFF8024.w
	jsr	$E454.l
	bset.b	#$2,$FFFF8024.w
	jsr	$E440.l
	move.w	#$0,d0
	jsr	$C4BC.l
	move.l	#$400,-(sp)
	jsr	$10540.l
	jsr	$D8F8.l
	bclr.b	#$2,$FFFF8024.w
	moveq	#$1E,d0
	jsr	$E370.l
	move.w	#$2700,sr
	movea.l	$EC96.l,a0
	move.l	$10ACC.l,(a0)
	dc.w	$6100,$0ACA
	move.w	(sp)+,sr
	rts
	move.w	#$0,$BC6E8.l
	dc.w	$6100,$004A
	dc.w	$6100,$00DE
	dc.w	$6100,$0B48
	dc.w	$6100,$2C4E
	move.l	#$400,-(sp)
	dc.w	$6100,$2C28
	dc.w	$6100,$0FC6
	dc.w	$6100,$010A
	dc.w	$6100,$0268
	dc.w	$6100,$11BC
	move.w	$EC90.l,-(sp)
	dc.w	$6100,$2BC4
	move.l	#$4000200,-(sp)
	dc.w	$6100,$2C04
	dc.w	$6100,$000C
	dc.w	$6100,$03DE
	dc.w	$6100,$0804
	rts
.l23C4C	movem.l	d0-d7/a0-a6,-(sp)
	bclr.b	#$2,$FFFF8024.w
	lea.l	$80000.l,a0
	move.l	a0,$10984.l
	lea.l	$10BD8.l,a1
	lea.l	$15246.l,a2
	dc.w	$6100,$006C
	move.l	a0,$1094C.l
	lea.l	$15246.l,a1
	lea.l	$15942.l,a2
	dc.w	$6100,$0056
	move.l	a0,$109D8.l
	lea.l	$15942.l,a1
	lea.l	$16C62.l,a2
	dc.w	$6100,$0040
	move.l	a0,$109DC.l
	lea.l	$16C62.l,a1
	lea.l	$17402.l,a2
	dc.w	$6100,$002A
	move.l	a0,$109E0.l
	lea.l	$17402.l,a1
	lea.l	$1756C.l,a2
	dc.w	$6100,$0014
	move.l	a0,$10BD0.l
	bset.b	#$2,$FFFF8024.w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.l23CDC	move.b	(a1)+,(a0)+
	cmpa.l	a2,a1
	blt.b	.l23CDC
RestoreBios_5	rts
.l23CE4	movem.l	d0-d7/a0-a6,-(sp)
	bclr.b	#$2,$FFFF8024.w
	move.w	#$2,d0
	moveq	#$2,d1
	bsr.w	RestoreBiosSub1
	lea.l	$1756C.l,a0
	move.w	#$0,d1
	move.w	#$5,d0
	bsr.w	RestoreBiosSub1
	lea.l	$DA24.l,a0
	move.w	#$6,d0
	bsr.w	RestoreBiosSub1
	bset.b	#$2,$FFFF8024.w
	movem.l	(sp)+,d0-d7/a0-a6
	dc.w	$4E75
	dc.b	$00,$02,$00,$00,$FF,$FF	; ......
.l23D2A	dc.b	$48,$E7,$FF,$FE,$02,$39,$00,$EF,$00,$0B,$C6,$E8,$61,$00,$08,$E8	; H....9......a...
	dc.b	$00,$00,$FC,$00,$E0,$00,$C0,$00,$B0,$00,$00,$06,$00,$20,$00,$00	; ............. ..
	dc.b	$0C,$CC,$61,$00,$08,$C2,$78,$01,$33,$C4,$00,$01,$0A,$F0,$20,$79	; ..a...x.3..... y
	dc.b	$00,$01,$09,$DC,$45,$E8,$00,$08,$61,$00,$06,$C6,$43,$F9,$00,$0B	; ....E...a...C...
	dc.b	$A8,$50,$D1,$D0,$70,$1F,$22,$D8,$51,$C8,$FF,$FC,$33,$FC,$00,$18	; .P..p.".Q...3...
	dc.b	$00,$0B,$A8,$D0,$3C,$3C,$00,$F0,$33,$FC,$00,$0A,$00,$01,$0B,$6C	; ....<<..3......l
	dc.b	$42,$79,$00,$01,$0B,$6E,$47,$F9,$00,$00,$DB,$78,$61,$00,$00,$2E	; By...nG....xa...
	dc.b	$61,$00,$05,$10,$61,$00,$06,$F8,$72,$00,$4A,$41,$56,$CE,$FF,$EE	; a...a...r.JAV...
	dc.b	$61,$00,$08,$74,$00,$00,$FC,$00,$E0,$00,$C0,$00,$B0,$00,$00,$06	; a..t............
	dc.b	$00,$20,$00,$00,$0C,$CC,$4C,$DF,$7F,$FF,$4E,$75	; . ....L...Nu
RestoreBiosSub12	movem.l	d0-d6/a0-a2,-(sp)
	btst.b	#$1,$BC6E8.l
	dc.w	$6600,$009E
	cmpi.w	#$10,$10B6E.l
	dc.w	$6E00,$0092
	subq.w	#$1,$10B6C.l
	dc.w	$6A00,$0088
	move.w	(a3)+,$10B6C.l
	move.w	(a3)+,d0
	cmpi.w	#$0,d0
	dc.w	$6600,$0026
	move.w	#$0,-(sp)
	move.l	#$0,-(sp)
	dc.w	$6100,$2912
	move.w	#$1,d0
	dc.w	$6100,$0608
	move.w	#$0,-(sp)
	move.l	#$0,-(sp)
	dc.w	$6100,$28FC
.l2B20	tst.w	-$2(a3)
	dc.w	$6A00,$0004
	subq.w	#$4,a3
.l2B2A	addq.w	#$1,$10B6E.l
	dc.w	$6100,$0498
	movea.l	$109DC.l,a0
	move.w	$10B6E.l,d2
	move.w	$10AF0.l,d4
.l2B46	move.w	#$80,d0
	move.w	#$80,d1
	cmpi.w	#$3,d2
	dc.w	$6D00,$0006
	move.w	#$88,d1
.l2B5A	dc.w	$6100,$047E
	subq.w	#$1,d2
	bne.b	.l2B46
	dc.w	$6100,$04D6
	dc.w	$6100,$0506
	bset.b	#$1,$BC6E8.l
.l2B72	movem.l	(sp)+,d0-d6/a0-a2
	dc.w	$4E75
	dc.b	$00,$1E,$00,$00,$00,$1E,$00,$01,$00,$1E,$00,$01,$00,$04,$00,$01	; ................
	dc.b	$00,$06,$FF,$FF	; ....
.l23E8C	dc.b	$02,$39,$00,$9C,$00,$0B,$C6,$E8,$61,$00,$07,$7A,$38,$3C,$00,$01	; .9......a..z8<..
	dc.b	$33,$C4,$00,$01,$0A,$F0,$61,$00,$0A,$B4,$00,$08,$F8,$00,$01,$00	; 3.....a.........
	dc.b	$00,$00,$24,$79,$00,$01,$09,$D8,$41,$D2,$43,$D2,$D1,$DA,$D3,$DA	; ..$y....A.C.....
	dc.b	'B@BA4',$11,$36,$29,$00,$02,$7A,$0F,$61,$00,$09,$52	; B@BA4.6)..z.a..R
	dc.b	$20,$7C,$00,$01,$07,$D0,$22,$7C,$00,$01,$07,$CC,$24,$7C,$00,$01	;  |...."|....$|..
	dc.b	$07,$CA,$47,$F9,$00,$01,$0A,$F0,$28,$79,$00,$01,$09,$E0,$61,$00	; ..G.....(y....a.
	dc.b	$05,$16,$20,$7C,$00,$01,$08,$22,$22,$7C,$00,$01,$08,$1E,$24,$7C	; .. |...""|....$|
	dc.b	$00,$01,$08,$1C,$47,$F9,$00,$01,$0A,$F0,$28,$79,$00,$01,$09,$E0	; ....G.....(y....
	dc.b	$61,$00,$04,$F4,$20,$7C,$00,$01,$08,$74,$22,$7C,$00,$01,$08,$70	; a... |...t"|...p
	dc.b	$24,$7C,$00,$01,$08,$6E,$47,$F9,$00,$01,$0A,$F0,$28,$79,$00,$01	; $|...nG.....(y..
	dc.b	$09,$E0,$61,$00,$04,$D2,$20,$7C,$00,$01,$08,$C6,$22,$7C,$00,$01	; ..a... |...."|..
	dc.b	$08,$C2,$24,$7C,$00,$01,$08,$C0,$47,$F9,$00,$01,$0A,$F0,$28,$79	; ..$|....G.....(y
	dc.b	$00,$01,$09,$E0,$61,$00,$04,$B0,$33,$FC,$00,$20,$00,$0B,$A8,$D0	; ....a...3.. ....
	dc.b	$3E,$3C,$00,$B4,$61,$00,$00,$16,$61,$00,$03,$46,$61,$00,$05,$2E	; ><..a...a..Fa...
	dc.b	$4A,$41,$56,$CF,$FF,$F0,$61,$00,$04,$D8,$4E,$75,$08,$39,$00,$01	; JAV...a...Nu.9..
	dc.b	$00,$0B,$C6,$E8,$66,$00,$00,$9E,$61,$00,$03,$44,$38,$39,$00,$01	; ....f...a..D89..
	dc.b	$0A,$F0,$24,$7C,$00,$01,$07,$CA,$26,$7C,$00,$01,$07,$D0,$28,$7C	; ..$|....&|....(|
	dc.b	$00,$01,$07,$CC,$20,$79,$00,$01,$09,$E0,$61,$00,$04,$12,$38,$39	; .... y....a...89
	dc.b	$00,$01,$0A,$F0,$24,$7C,$00,$01,$08,$1C,$26,$7C,$00,$01,$08,$22	; ....$|....&|..."
	dc.b	$28,$7C,$00,$01,$08,$1E,$20,$79,$00,$01,$09,$E0,$61,$00,$03,$F0	; (|.... y....a...
	dc.b	$38,$39,$00,$01,$0A,$F0,$24,$7C,$00,$01,$08,$6E,$26,$7C,$00,$01	; 89....$|...n&|..
	dc.b	$08,$74,$28,$7C,$00,$01,$08,$70,$20,$79,$00,$01,$09,$E0,$61,$00	; .t(|...p y....a.
	dc.b	$03,$CE,$38,$39,$00,$01,$0A,$F0,$24,$7C,$00,$01,$08,$C0,$26,$7C	; ..89....$|....&|
	dc.b	$00,$01,$08,$C6,$28,$7C,$00,$01,$08,$C2,$20,$79,$00,$01,$09,$E0	; ....(|.... y....
	dc.b	$61,$00,$03,$AC,$61,$00,$03,$28,$61,$00,$03,$58,$08,$F9,$00,$01	; a...a..(a..X....
	dc.b	$00,$0B,$C6,$E8,$4E,$75	; ....Nu
.l24022	dc.b	$02,$39,$00,$9C,$00,$0B,$C6,$E8,$61,$00,$05,$F4,$00,$00,$FC,$00	; .9......a.......
	dc.b	$E0,$00,$C0,$00,$B0,$00,$00,$06,$00,$20,$00,$00,$0C,$CC,$61,$00	; ......... ....a.
	dc.b	$05,$CE,$61,$00,$0A,$9A,$33,$F9,$00,$01,$0B,$CE,$00,$01,$0B,$2A	; ..a...3........*
	dc.b	$33,$F9,$00,$01,$0B,$CE,$00,$01,$0B,$2C,$70,$1C,$61,$00,$06,$10	; 3........,p.a...
	dc.b	$42,$79,$00,$01,$0B,$22,$61,$00,$08,$12,$00,$06,$FF,$00,$00,$00	; By..."a.........
	dc.b	$20,$3C,$00,$00,$00,$80,'r $<',$00,$00,$07,$FF,$4E,$B9	;  <....r $<....N.
	dc.b	$00,$00,$E4,$D6,$61,$00,$07,$F4,$00,$06,$FE,$00,$00,$00,$20,$3C	; ....a......... <
	dc.b	$00,$00,$00,$80,'r $<',$00,$00,$07,$FF,$4E,$B9,$00,$00	; ....r $<....N...
	dc.b	$E4,$D6,$78,$1C,$61,$00,$07,$D4,$00,$06,$FE,$00,$13,$00,$22,$79	; ..x.a........."y
	dc.b	$00,$01,$09,$84,$D3,$E9,$00,$04,$45,$F9,$00,$0B,$C6,$EC,$42,$40	; ........E.....B@
	dc.b	$72,$13,$34,$11,$36,$29,$00,$02,$96,$41,$7A,$00,$4E,$B9,$00,$00	; r.4.6)...Az.N...
	dc.b	$E5,$1C,$61,$00,$07,$A6,$00,$06,$FD,$00,$00,$00,$20,$79,$00,$01	; ..a......... y..
	dc.b	$09,$84,'"H$H',$D1,$DA,$D3,$DA,'B@BA4',$11	; .."H$H....B@BA4.
	dc.b	$36,$29,$00,$02,$7A,$0F,$4E,$B9,$00,$00,$E5,$1C,$33,$C4,$00,$01	; 6)..z.N.....3...
	dc.b	$0A,$FE,$24,$79,$00,$01,$09,$4C,$50,$8A,$4E,$B9,$00,$00,$E1,$2A	; ..$y...LP.N....*
	dc.b	$61,$00,$08,$E8,$61,$00,$07,$64,$00,$06,$FF,$00,$00,$00,$43,$F9	; a...a..d......C.
	dc.b	$00,$02,$5F,$0E,$61,$00,$00,$6E,$06,$79,$00,$40,$00,$01,$0B,$22	; .._.a..n.y.@..."
	dc.b	$42,$79,$00,$01,$0B,$20,$42,$79,$00,$01,$0B,$24,$33,$FC,$00,$05	; By... By...$3...
	dc.b	$00,$01,$0B,$28,$33,$FC,$00,$20,$00,$0B,$A8,$D0,$36,$3C,$00,$F0	; ...(3.. ....6<..
	dc.b	$61,$00,$00,$9E,$51,$CB,$FF,$FA,$61,$00,$07,$20,$00,$06,$FF,$00	; a...Q...a.. ....
	dc.b	$00,$00,$43,$F9,$00,$02,$5F,$36,$61,$00,$00,$2A,$D2,$D1,$78,$3F	; ..C..._6a..*..x?
	dc.b	$61,$00,$00,$7E,$61,$00,$00,$7A,$52,$79,$00,$01,$0B,$22,$51,$CC	; a..~a..zRy..."Q.
	dc.b	$FF,$F0,$78,$78,$61,$00,$00,$6A,$51,$CC,$FF,$FA,$4A,$69,$00,$02	; ..xxa..jQ...Ji..
	dc.b	$6A,$D6,'Nu09',$00,$01,$0B,$22,$E6,$40,$06,$40,$00,$1C	; j.Nu09...".@.@..
	dc.b	$02,$40,$00,$1F,$33,$C0,$00,$01,$0B,$0C,$3F,$00,$42,$79,$00,$01	; .@..3.....?.By..
	dc.b	$0B,$0A,$70,$20,$72,$09,$34,$3C,$07,$FF,$4E,$B9,$00,$00,$E4,$D6	; ..p r.4<..N.....
	dc.b	$33,$DF,$00,$01,$0B,$0C,$30,$11,$E2,$40,$44,$40,$06,$40,$00,$10	; 3.....0..@D@.@..
	dc.b	$33,$C0,$00,$01,$0B,$0A,$61,$00,$0A,$1C,$52,$79,$00,$01,$0B,$0C	; 3.....a...Ry....
	dc.b	$02,$79,$00,$1F,$00,$01,$0B,$0C,$4A,$69,$00,$02,$6A,$D8,$4E,$75	; .y......Ji..j.Nu
RestoreBiosSub13	movem.l	d0-d7/a0-a6,-(sp)
	move.w	$10AE0.l,d0
.l2EFC	cmp.w	$10AE0.l,d0
	beq.b	.l2EFC
	dc.w	$6100,$0018
	jsr	$E198.l
	btst	#$7,d1
	movem.l	(sp)+,d0-d7/a0-a6
	dc.w	$6700,$0092
	addq.l	#$4,sp
	dc.w	$4E75
.l2421E	dc.b	$41,$F9,$00,$0B,$A4,$50,$30,$B9,$00,$01,$0B,$22,$70,$1D,$61,$00	; A....P0...."p.a.
	dc.b	$04,$42,$30,$3C,$00,$DF,$41,$F9,$00,$0B,$C3,$68,$72,$7F,$D2,$79	; .B0<..A....hr..y
	dc.b	$00,$01	; ..
RestoreBiosSub14	dc.w	$0B20
.l2F42	clr.l	(a0)+
	cmpi.w	#$48,d0
	dc.w	$6F00,$0006
	move.w	d1,-$2(a0)
.l2F50	dbra	d0,.l2F42
	bset.b	#$0,$BC6E8.l
	bset.b	#$6,$BC6E8.l
	cmpi.w	#$B4,$10B20.l
	dc.w	$6D00,$0030
	subq.w	#$1,$10B24.l
	dc.w	$6A00,$0032
	move.w	#$12C,d0
	jsr	$E488.l
	move.w	d0,$10B24.l
	andi.w	#$7,d0
	addq.w	#$4,d0
	move.w	d0,$10B28.l
	move.w	#$FEB4,$10B20.l
.l2F9E	move.w	$10B28.l,d0
	add.w	d0,$10B20.l
.l242AA	rts
	move.w	d0,-(sp)
	move.w	$10AE2.l,d0
.l2FB4	cmp.w	$10AE0.l,d0
	beq.b	.l2FB4
	move.w	$10AE0.l,$10AE2.l
	move.w	(sp)+,d0
	rts
.l242CA	movea.l	#$BA8D2,a5
	movea.l	#$BAF16,a6
	moveq	#$1,d6
	rts
RestoreBios_6	cmpi.w	#$50,d6
	bgt.w	RestoreBios_5
RestoreBiosSub15	movem.l	d0-d5/a0,-(sp)
	adda.l	$4(a0),a0
	move.w	d2,d5
	andi.w	#$7FF,d2
	add.w	d2,d2
	move.w	(a0,d2.w),d3
	sub.w	-$2(a0,d2.w),d3
	lsr.w	#$3,d3
	subq.w	#$1,d3
	adda.w	-$2(a0,d2.w),a0
.l3002	move.w	$2(a0),(a6)
	add.w	d1,(a6)+
	move.b	$7(a0),(a6)+
	move.b	d6,(a6)+
	move.w	$6(a0),d2
	eor.w	d5,d2
	andi.w	#$F800,d2
	add.w	$4(a0),d2
	add.w	d4,d2
	move.w	d2,(a6)+
	move.w	(a0),(a6)
	add.w	d0,(a6)+
	addq.w	#$1,d6
	cmpi.w	#$51,d6
	dc.w	$6700,$0008
	addq.l	#$8,a0
	dbra	d3,.l3002
.l3034	movem.l	(sp)+,d0-d5/a0
	rts
.l2433A	moveq	#-1,d0
	add.w	d6,d0
	dc.w	$6600,$0008
	moveq	#$1,d0
	clr.l	(a6)+
	clr.l	(a6)+
.l3048	cmpi.w	#$50,d0
	dc.w	$6F00,$0004
	moveq	#$50,d0
.l3052	asl.w	#$3,d0
	lea.l	$BAF16.l,a6
	clr.b	-$5(a6,d0.w)
	lsr.w	#$1,d0
	move.w	d0,$BB1E6.l
	move.l	a5,$BAF12.l
	rts
.l2436E	movea.l	#$BC6F0,a0
	lea.l	$BA8D2.l,a1
	move.l	#$80000,d1
.l3080	cmpa.l	$BAF12.l,a1
	dc.w	$6700,$0028
	move.l	(a1),d0
	cmp.l	d1,d0
	dc.w	$6E00,$001C
	movea.l	d0,a2
	move.w	$4(a1),d0
	subq.w	#$1,d0
	move.l	a0,(a1)
.l309C	move.w	(a2)+,(a0)+
	cmpa.l	#$C0000,a0
	dc.w	$6C00,$0012
	dbra	d0,.l309C
.l30AC	addq.l	#$8,a1
	bra.b	.l3080
.l30B0	move.l	a0,$10AC8.l
	rts
.l30B8	bra.b	.l30B8
	movea.l	(a4),a1
	move.w	$2(a1),d2
	subq.w	#$1,(a2)
	dc.w	$6A00,$002E
	addq.l	#$4,a1
	move.w	(a1),d0
	dc.w	$6A00,$001E
	move.w	$2(a1),d0
	dc.w	$6700,$0006
	dc.w	$6B00,$000E
.l30DA	move.l	a3,(a4)
	addq.l	#$4,(a4)
	movea.l	(a4),a1
	move.w	(a1),d0
	dc.w	$6000,$0006
.l30E6	subq.l	#$4,a1
	move.w	(a1),d0
.l30EA	move.w	d0,(a2)
	move.w	$2(a1),d2
	move.l	a1,(a4)
.l30F2	tst.w	d2
	dc.w	$6B00,$000A
	move.w	(a3)+,d0
RestoreBiosSub16	move.w	(a3),d1
	bsr.w	RestoreBios_6
.l24400	rts
	move.w	d4,(a3)
	move.l	a0,(a1)
	addq.l	#$4,(a1)
	move.w	$4(a0),(a2)
	movea.l	a4,a0
	lea.l	$8(a0),a2
	dc.w	$6100,$0016
	rts
.l24418	neg.w	d0
	move.w	d0,$10AE0.l
.l3120	tst.w	$10AE0.l
	bmi.b	.l3120
	rts
.l2442A	movem.l	d0-d1/a0,-(sp)
	lea.l	$BA450.l,a0
	move.l	d4,(a0)+
	move.l	a2,(a0)
	moveq	#$4,d0
	dc.w	$6100,$0234
	lea.l	$BA450.l,a0
	move.l	(a0),d4
	movem.l	(sp)+,d0-d1/a0
	dc.w	$4E75
.l2444C	dc.b	$48,$E7,$80,$80,$41,$F9,$00,$0B	; H...A...
RestoreBiosSub17	dc.w	$A850
	moveq	#$1F,d0
.l3158	move.l	(a0),-(sp)
	clr.l	(a0)+
	dbra	d0,.l3158
	move.w	#$18,$BA8D0.l
	dc.w	$6100,$0010
	moveq	#$1F,d0
.l316E	move.l	(sp)+,-(a0)
	dbra	d0,.l316E
	movem.l	(sp)+,d0/a0
	rts
.l2447A	move.w	$BC6E8.l,-(sp)
	bclr.b	#$4,$BC6E8.l
.l3188	tst.w	$BA8D0.l
	bpl.b	.l3188
	move.w	(sp)+,$BC6E8.l
	dc.w	$4E75
	dc.b	$48,$E7,$B8,$00,$42,$67,$78,$03,$61,$00,$00,$A8,$61,$00,$00,$6C	; H...Bgx.a...a..l
	dc.b	$83,$57,$51,$CC,$FF,$F4,$32,$1F,$4C,$DF	; .WQ...2.L.
RestoreBiosSub18	dc.w	$001D,$4E75
	tst.w	d3
	dc.w	$6700,$002A
	tst.w	d2
	dc.w	$6600,$001C
	subq.b	#$1,$10B1C.l
	dc.w	$6A00,$001A
	move.b	#$4,$10B1C.l
	move.w	d3,d1
	andi.w	#$F,d1
	rts
.l31DC	move.b	#$F,$10B1C.l
RestoreBios_7	rts
	tst.w	d3
	beq.b	RestoreBios_7
	tst.w	d2
	dc.w	$6600,$001A
	subq.b	#$1,$10B1D.l
	bpl.b	RestoreBios_7
	move.b	#$4,$10B1D.l
	move.w	d3,d1
	andi.w	#$F,d1
	rts
.l3208	move.b	#$F,$10B1D.l
	dc.w	$4E75
	dc.b	$4A,$43,$67,$CE	; JCg.
RestoreBiosSub19	movem.l	a0,-(sp)
	lea.l	$10B1C.l,a0
	tst.w	d2
	dc.w	$6600,$001A
	subq.b	#$1,(a0,d4.w)
	dc.w	$6A00,$0018
	move.b	#$4,(a0,d4.w)
	move.w	d3,d1
	andi.w	#$F,d1
	dc.w	$6000,$0008
.l323E	move.b	#$F,(a0,d4.w)
.l3244	movem.l	(sp)+,a0
	dc.w	$4E75
	dc.b	$30,$38,$80,$1C,$13,$C0,$00,$01,$0B,$15,$E0,$48,$13,$C0,$00,$01	; 08.........H....
	dc.b	$0B,$14,$30,$38,$80,$1E,$13,$C0,$00,$01,$0B,$17,$E0,$48,$13,$C0	; ..08.........H..
	dc.b	$00,$01,$0B,$16,$70,$00	; ....p.
RestoreBiosSub20	movem.l	a0,-(sp)
	lea.l	$10B14.l,a0
	move.b	(a0,d4.w),d0
	dc.w	$6100,$005E
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
	dc.w	$6100,$0038
	move.b	$10B18.l,d2
	move.b	d1,$10B18.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
	move.w	$FFFF801C.w,d0
	move.b	d0,$10B15.l
	dc.w	$6100,$0016
	move.b	$10B19.l,d2
	move.b	d1,$10B19.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
.l245DE	clr.w	d1
	move.b	d0,d1
RestoreBiosSub21	movem.l	d1/a0,-(sp)
	andi.w	#$F0,d0
	andi.w	#$F,d1
	lea.l	$E300.l,a0
	move.b	(a0,d1.w),d1
	or.w	d1,d0
	movem.l	(sp)+,d1/a0
	dc.w	$4E75
	dc.b	$08,$00,$04,$08,$06,$07,$05,$08,$02,$01,$03,$08,$08,$08,$08,$08	; ................
RestoreBiosSub22	movem.l	d0,-(sp)
	moveq	#$3,d0
	dc.w	$6100,$0058
	movem.l	(sp)+,d0
	rts
	movea.l	(sp),a0
	lea.l	$BA450.l,a1
	moveq	#$8,d0
.l332A	move.w	(a0)+,(a1)+
	dbra	d0,.l332A
	move.l	a0,(sp)
	moveq	#$2,d0
	dc.w	$6000,$003A
RestoreBiosSub23	movem.l	d0/d2-d3/a1,-(sp)
	lea.l	$BA450.l,a1
	move.w	d0,(a1)+
	move.w	d1,(a1)+
	move.l	a0,(a1)
	moveq	#$0,d0
	dc.w	$6100,$0024
	movem.l	(sp)+,d0/d2-d3/a1
	rts
RestoreBiosSub24	movem.l	d0/d2-d3/a1,-(sp)
	lea.l	$BA450.l,a1
	move.w	d0,(a1)+
	move.w	d1,(a1)+
	move.l	a0,(a1)
	moveq	#$1,d0
	dc.w	$6100,$0008
	movem.l	(sp)+,d0/d2-d3/a1
	rts
RestoreBios_8	move.w	d0,$FFFF8020.w
	bset.b	#$6,$FFFF800F.w
.l337A	btst.b	#$6,$FFFF800E.w
	beq.b	.l337A
	bclr.b	#$6,$FFFF800F.w
	move.w	#$0,$FFFF8020.w
	bclr.b	#$1,$FFFF8024.w
	dc.w	$6100,$0490
	dc.w	$6100,$0096
	dc.w	$6100,$04A6
.l33A0	btst.b	#$0,$FFFF8014.w
	beq.b	.l33A0
	bset.b	#$1,$FFFF8024.w
	dc.w	$6100,$04B2
	dc.w	$6100,$0062
	dc.w	$6100,$04C8
	rts
.l246BC	move.w	#$0,$FFFF8020.w
	move.w	#$0,$FFFF8022.w
	move.w	#$0,$FFFF8024.w
	move.w	#$0,$FFFF8026.w
	move.w	#$0,$FFFF8028.w
	move.w	#$0,$FFFF802A.w
	move.w	#$0,$FFFF802C.w
	move.w	#$0,$FFFF802E.w
	rts
.l33EE	bclr.b	#$2,$FFFF8003.w
	bne.b	.l33EE
	rts
.l33F8	btst.b	#$7,$FFFF800E.w
	beq.b	.l33F8
	bset.b	#$7,$FFFF800F.w
.l3406	btst.b	#$7,$FFFF800E.w
	bne.b	.l3406
	bclr.b	#$7,$FFFF800F.w
	rts
RestoreBios_9	btst.b	#$1,$FFFF8003.w
	beq.b	RestoreBios_9
	btst.b	#$0,$FFFF8003.w
	bne.b	RestoreBios_9
	bset.b	#$1,$10912.l
	rts
RestoreBios_10	bset.b	#$0,$FFFF8003.w
	bclr.b	#$1,$10912.l
	rts
	lea.l	$10ADA.l,a0
.l3446	clr.b	(a0)+
	cmpa.l	#$10BD8,a0
	blt.b	.l3446
	rts
.l24752	dc.w	$4E75
	dc.b	$4E,$B9,$00,$00,$E3,$F8	; N.....
RestoreBiosSub25	movem.l	a0-a1,-(sp)
	movea.l	$EC96.l,a0
	move.l	(a0),$10ACC.l
	move.l	#$EA8A,(a0)
	bset.b	#$2,$FFFF8033.w
	movem.l	(sp)+,a0-a1
	rts
	move.w	d0,-(sp)
	add.w	d0,d0
	dc.w	$6100,$0006
	sub.w	(sp)+,d0
	rts
.l24788	movem.l	d0-d2,-(sp)
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
RestoreBiosSub26	movem.l	d0/a0,-(sp)
	moveq	#$6,d0
	bsr.w	RestoreBios_8
	movem.l	(sp)+,d0/a0
	rts
RestoreBiosSub27	movem.l	d0-d3/a0,-(sp)
	lea.l	$BA450.l,a0
	move.w	d0,(a0)+
	move.w	d1,(a0)+
	move.w	d2,(a0)+
	move.w	$10B0A.l,(a0)+
	move.w	$10B0C.l,(a0)+
	move.w	$10B10.l,(a0)+
	moveq	#$7,d0
	bsr.w	RestoreBios_8
	lea.l	$BA450.l,a0
	move.w	(a0)+,$10B0A.l
	move.w	(a0)+,$10B0C.l
	move.w	(a0)+,$10B10.l
	movem.l	(sp)+,d0-d3/a0
	dc.w	$4E75
	dc.b	$48,$E7,$F6,$F2,$4D,$F9,$00,$0B,$A4,$50,$2C,$C8,$2C,$C9,$2C,$CA	; H...M....P,.,.,.
	dc.b	$2C,$C0,$2C,$C1,$2C,$C2,$2C,$C3,$2C,$C4,$2C,$C5,$3C,$F9,$00,$01	; ,.,.,.,.,.,.<...
	dc.b	$0B,$0E,$3C,$F9	; ..<.
RestoreBiosSub28	dc.w	$0001,$0B0A
	move.w	$10B0C.l,(a6)+
	move.w	$10B10.l,(a6)+
	moveq	#$8,d0
	bsr.w	RestoreBios_8
	lea.l	$BA450.l,a6
	move.w	(a6)+,d4
	move.w	(a6)+,$10B0E.l
	move.w	(a6)+,$10B0A.l
	move.w	(a6)+,$10B0C.l
	move.w	(a6)+,$10B10.l
	movem.l	(sp)+,d0-d3/d5-d6/a0-a3/a6
	rts
RestoreBiosSub29	movem.l	d0/a1-a2,-(sp)
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
.l35AE	move.w	(a1)+,(a2)+
	dbra	d0,.l35AE
	move.l	a1,$C(sp)
	moveq	#$B,d0
	bsr.w	RestoreBios_8
	lea.l	$BA450.l,a1
	move.w	(a1)+,$10B0E.l
	move.w	(a1)+,$10B10.l
	move.w	(a1)+,$10B0A.l
	move.w	(a1),$10B0C.l
	movem.l	(sp)+,d0/a1-a2
	rts
RestoreBiosSub30	movem.l	d0-d3/a0/a2-a3,-(sp)
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
.l3622	move.w	(a1)+,(a2)+
	dbra	d0,.l3622
	moveq	#$C,d0
	bsr.w	RestoreBios_8
	lea.l	$BA450.l,a2
	move.w	(a2)+,$10B0E.l
	move.w	(a2)+,$10B0A.l
	move.w	(a2)+,$10B0C.l
	move.w	(a2)+,$10B12.l
	move.w	(a2),$10B10.l
	movem.l	(sp)+,d0-d3/a0/a2-a3
	rts
RestoreBiosSub31	movem.l	d0/a1-a2,-(sp)
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
.l369C	move.w	(a1)+,(a2)+
	dbra	d0,.l369C
	moveq	#$D,d0
	bsr.w	RestoreBios_8
	move.l	a1,$C(sp)
	lea.l	$BA450.l,a1
	move.w	(a1)+,$10B0E.l
	move.w	(a1)+,$10B0A.l
	move.w	(a1)+,$10B0C.l
	move.w	(a1)+,$10B12.l
	move.w	(a1),$10B10.l
	movem.l	(sp)+,d0/a1-a2
	rts
RestoreBiosSub32	movem.l	d1-d4,-(sp)
	clr.w	d4
	moveq	#$2,d3
	moveq	#$E,d2
.l36E0	move.w	d0,d1
	and.w	d2,d1
	dc.w	$6700,$0008
	add.w	d2,d1
	and.w	d2,d1
	or.w	d1,d4
.l36EE	asl.w	#$4,d2
	dbra	d3,.l36E0
	move.w	d4,d0
	movem.l	(sp)+,d1-d4
	rts
RestoreBiosSub33	movem.l	d0/a0-a1,-(sp)
	lea.l	$BA450.l,a0
	lea.l	$10AE4.l,a1
.l370C	move.w	(a1)+,(a0)+
	cmpa.l	#$10B08,a1
	blt.b	.l370C
	moveq	#$E,d0
	bsr.w	RestoreBios_8
	movem.l	(sp)+,d0/a0-a1
	rts
RestoreBiosSub34	movem.l	a1,-(sp)
	movem.l	$4(sp),a1
	dc.w	$6100,$000E
	movem.l	a1,$4(sp)
	movem.l	(sp)+,a1
	rts
.l24A3C	movem.l	d0/a0,-(sp)
	lea.l	$2(a3),a0
	move.w	(a3),d0
	subq.w	#$3,d0
	dc.w	$6B00,$000A
.l374C	addq.l	#$1,a0
	tst.b	(a0)
	dbeq	d0,.l374C
.l3754	move.w	(a1)+,d0
	subq.w	#$3,d0
	dc.w	$6B00,$0020
.l375C	move.b	(a1)+,(a0)+
	dc.w	$6600,$0004
	subq.l	#$1,a0
.l3764	dbra	d0,.l375C
	move.l	a0,d0
	btst	#$0,d0
	dc.w	$6700,$0006
	clr.b	(a0)+
	addq.l	#$1,d0
.l3776	sub.l	a3,d0
	move.w	d0,(a3)
.l377A	movem.l	(sp)+,d0/a0
	rts
RestoreBiosSub35	movem.l	d1-d2/a0-a1,-(sp)
	clr.w	d0
	clr.w	d1
	move.w	(a1)+,d2
	subq.w	#$2,d2
	dc.w	$6000,$001A
.l3790	move.b	(a1)+,d1
	dc.w	$6700,$0014
	dc.w	$6A00,$000C
	subq.w	#$2,d2
	addq.l	#$2,a1
	clr.w	d0
	dc.w	$6000,$0006
.l37A4	dc.w	$6100,$000C
.l37A8	dbra	d2,.l3790
	movem.l	(sp)+,d1-d2/a0-a1
	rts
.l24AB2	ext.w	d1
	beq.w	RestoreBios_7
	cmpi.w	#$61,d1
	dc.w	$6D00,$000E
	cmpi.w	#$7A,d1
	dc.w	$6E00,$0006
	addi.w	#$FFE0,d1
.l37CC	addq.w	#$1,d0
	movea.l	#$10570,a0
	tst.b	-$20(a0,d1.w)
	bmi.w	RestoreBios_7
	addq.w	#$1,d0
	rts
RestoreBiosSub36	movem.l	d0,-(sp)
	moveq	#$F,d0
	bsr.w	RestoreBios_8
	move.w	$BA450.l,$10BCE.l
	movem.l	(sp)+,d0
	rts
RestoreBiosSub37	movem.l	d0-d1/a0-a1,-(sp)
	lea.l	$BA450.l,a0
	move.l	d4,(a0)+
	move.l	a2,(a0)+
	movea.l	$10(sp),a1
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	moveq	#$10,d0
	bsr.w	RestoreBios_8
	lea.l	$BA450.l,a0
	move.l	(a0),d4
	movem.l	(sp)+,d0-d1/a0-a1
	addq.l	#$8,(sp)
	rts
.l24B26	btst.b	#$0,$FFFF8018.w
	beq.b	.l24B26
	bset.b	#$0,$FFFF8028.w
.l3834	btst.b	#$0,$FFFF8018.w
	bne.b	.l3834
	bclr.b	#$0,$FFFF8028.w
	rts
.l24B44	btst.b	#$1,$FFFF8018.w
	beq.b	.l24B44
	bset.b	#$1,$FFFF8028.w
.l3852	btst.b	#$1,$FFFF8018.w
	bne.b	.l3852
	bclr.b	#$1,$FFFF8028.w
	rts
.l24B62	btst.b	#$2,$FFFF8018.w
	beq.b	.l24B62
	bset.b	#$2,$FFFF8028.w
.l3870	btst.b	#$2,$FFFF8018.w
	bne.b	.l3870
	bclr.b	#$2,$FFFF8028.w
	rts
.l24B80	btst.b	#$3,$FFFF8018.w
	beq.b	.l24B80
	bset.b	#$3,$FFFF8028.w
.l388E	btst.b	#$3,$FFFF8018.w
	bne.b	.l388E
	bclr.b	#$3,$FFFF8028.w
	rts
RestoreBiosSub38	movem.l	d0/a0-a1,-(sp)
	lea.l	$BA450.l,a0
	movea.l	$C(sp),a1
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	a1,$C(sp)
	moveq	#$12,d0
	bsr.w	RestoreBios_8
	movem.l	(sp)+,d0/a0-a1
	rts
RestoreBiosSub39	movem.l	d0/a0-a1,-(sp)
	lea.l	$BA450.l,a0
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	moveq	#$12,d0
	bsr.w	RestoreBios_8
	movem.l	(sp)+,d0/a0-a1
	rts
.l24BE2	lea.l	$BA450.l,a0
	move.l	$1094C.l,(a0)+
	moveq	#$5,d0
	bsr.w	RestoreBios_8
	rts
RestoreBiosSub40	movem.l	d0-d3/a0/a2/a6,-(sp)
	lea.l	$BA450.l,a2
	move.w	$10B0E.l,(a2)+
	move.w	$10B10.l,(a2)+
	move.w	$10B0A.l,(a2)+
	move.w	$10B0C.l,(a2)+
	move.w	$10AFE.l,(a2)+
	move.w	(a1),d0
	lsr.w	#$1,d0
	subq.w	#$1,d0
.l3924	move.w	(a1)+,(a2)+
	dbra	d0,.l3924
	movea.l	a1,a6
	moveq	#$B,d0
	bsr.w	RestoreBios_8
	lea.l	$BA450.l,a1
	move.w	(a1)+,$10B0E.l
	move.w	(a1)+,$10B10.l
	move.w	(a1)+,$10B0A.l
	move.w	(a1),$10B0C.l
	movea.l	a6,a1
	movem.l	(sp)+,d0-d3/a0/a2/a6
	rts
RestoreBiosSub41	movem.l	a0,-(sp)
	lea.l	$BA450.l,a0
	move.w	d0,(a0)
	moveq	#$13,d0
	bsr.w	RestoreBios_8
	movem.l	(sp)+,a0
	rts
	dc.w	$6100,$0006
	bra.w	RestoreBiosSub30
.l24C78	dc.w	$6000,$0004
.l397C	adda.w	(a1),a1
.l397E	dbra	d0,.l397C
	rts
RestoreBiosSub42	movem.l	d0,-(sp)
	moveq	#$14,d0
	bsr.w	RestoreBios_8
	movem.l	(sp)+,d0
	rts
RestoreBiosSub43	movem.l	d0,-(sp)
	moveq	#$15,d0
	bsr.w	RestoreBios_8
	movem.l	(sp)+,d0
	rts
RestoreBiosSub44	movem.l	d0/a0,-(sp)
	lea.l	$BA450.l,a0
	move.w	$10B22.l,(a0)+
	move.w	d0,(a0)+
	moveq	#$16,d0
	bsr.w	RestoreBios_8
	movem.l	(sp)+,d0/a0
	rts
RestoreBiosSub45	movem.l	d0/a0,-(sp)
	move.w	d0,$BA450.l
	moveq	#$19,d0
	bsr.w	RestoreBios_8
	movem.l	(sp)+,d0/a0
	rts
	move.l	d0,-(sp)
	moveq	#$17,d0
	bsr.w	RestoreBios_8
	move.l	(sp)+,d0
	rts
RestoreBiosSub46	movem.l	d0-d2/a0,-(sp)
	lea.l	$BA450.l,a0
RestoreBiosSub47	move.w	d0,(a0)+
	move.w	d1,(a0)+
	move.w	d2,(a0)+
	moveq	#$18,d0
	bsr.w	RestoreBios_8
	movem.l	(sp)+,d0-d2/a0
	rts
.l3A00	bset.b	#$2,$FF8003.l
	bne.b	.l3A00
	dc.w	$4E75
