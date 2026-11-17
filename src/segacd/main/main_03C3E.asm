	dc.b	$61,$00,$FD,$56,$26,$39,$00,$23,$BC,$88,$28,$39,$00,$23,$BC,$8C	; a..V&9.#..(9.#..
	dc.b	$2A,$39,$00,$23,$BC,$90,$22,$7C,$00,$23,$BC,$B0,$20,$7C,$00,$C0	; *9.#.."|.#.. |..
	dc.b	$00,$00,$42,$46,$34,$03,$30,$06,'H@0<',$00,$20,$21,$40	; ..BF4.0.H@0<. !@
	dc.b	$00,$04,$3E,$10,$30,$07,$C0,$45,$32,$19,$C2,$45,$B0,$41,$67,$00	; ..>.0..E2..E.Ag.
	dc.b	$00,$1E,$6D,$00,$00,$04,$44,$42,$D0,$42,$CE,$44,$8E,$40,$20,$3C	; ..m...DB.B.D.@ <
	dc.b	$00,$00,$C0,$00,$10,$06,'H@!@',$00,$04,$30,$87,$54,$46	; ......H@!@..0.TF
	dc.b	$0C,$46,$00,$80,$66,$00,$FF,$BE,$61,$00,$FC,$FA,$4E,$75,$61,$00	; .F..f...a...Nua.
	dc.b	$FC,$E8,$20,$39,$00,$23,$BC,$88,$22,$39,$00,$23,$BC,$8C,$24,$39	; .. 9.#.."9.#..$9
	dc.b	$00,$23,$BC,$90,$43,$F9,$00,$C0,$00,$04,$32,$BC,$81,$54,$32,$BC	; .#..C.....2..T2.
	dc.b	$8F,$01,$36,$3C,$93,$00,$16,$00,$32,$83,$36,$3C,$94,$00,$E0,$48	; ..6<....2.6<...H
	dc.b	$16,$00,$32,$83,$36,$3C,$95,$00,$16,$02,$32,$83,$36,$3C,$96,$00	; ..2.6<....2.6<..
	dc.b	$E0,$4A,$16,$02,$32,$83,$32,$BC,$97,$C0,$42,$80,$30,$01,$E5,$80	; .J..2.2...B.0...
	dc.b	$E4,$48,$48,$40,$00,$40,$00,$C0,$23,$C0,$00,$FF,$6C,$E8,$32,$B9	; .HH@.@..#...l.2.
	dc.b	$00,$FF,$6C,$E8,$32,$B9,$00,$FF,$6C,$EA,$3F,$39,$00,$C0,$00,$04	; ..l.2...l.?9....
	dc.b	$08,$2F,$00,$01,$00,$01,$54,$4F,$66,$00,$FF,$F0,$32,$BC,$81,$64	; ./....TOf...2..d
	dc.b	$32,$BC,$8F,$02,$61,$00,$FC,'nNua',$00,$FC,$5C,$43,$F9	; 2...a..nNua...C.
	dc.b	$00,$C0,$00,$04,$20,$7C,$00,$23,$C0,$00,$30,$18,$32,$98,$32,$98	; .... |.#..0.2.2.
	dc.b	$32,$98,$32,$98,$32,$98,$32,$98,$32,$98,$23,$D8,$00,$FF,$6C,$E8	; 2.2.2.2.2.#...l.
	dc.b	$32,$B9,$00,$FF,$6C,$E8,$32,$B9,$00,$FF,$6C,$EA,$3F,$39,$00,$C0	; 2...l.2...l.?9..
	dc.b	$00,$04,$08,$2F,$00,$01,$00,$01,$54,$4F,$66,$00,$FF,$F0,$32,$BC	; .../....TOf...2.
	dc.b	$81,$64,$51,$C8,$FF,$CA,$32,$BC,$8F,$02,$61,$00,$FC,$18,$4E,$75	; .dQ...2...a...Nu
	dc.b	$61,$00,$FC,$06,$20,$39,$00,$23,$BC,$88,$22,$39,$00,$23,$BC,$8C	; a... 9.#.."9.#..
	dc.b	$24,$39,$00,$23,$BC,$90,$22,$7C,$00,$C0,$00,$00,$02,$81,$00,$00	; $9.#.."|........
	dc.b	$FF,$FF,$E5,$81,$E4,$49,$00,$41,$40,$00,'HA#A',$00,$04	; .....I.A@.HA#A..
	dc.b	$36,$02,$48,$43,$36,$02,$E2,'HS@#',$C3,$00,$FF,$6C,$E8	; 6.HC6..HS@#...l.
	dc.b	$32,$B9,$00,$FF,$6C,$E8,$32,$B9,$00,$FF,$6C,$EA,$51,$C8,$FF,$EC	; 2...l.2...l.Q...
	dc.b	$61,$00,$FB,$C2,$4E,$75	; a...Nu
; Writes zeros over all 64 KB of VRAM.
ClearVram	move.l	#$40000000,$C00004.l
	move.w	#$3FFF,d0
	movea.l	#$C00000,a0
	clr.l	d1
.l3DFA	move.l	d1,(a0)
	dbra	d0,.l3DFA
	rts
	bsr.w	WaitDmnaClear
	lea.l	$C00000.l,a0
	lea.l	$23C002.l,a1
	move.w	$23C000.l,d0
.l3E18	move.w	(a1)+,(a0)
	dbra	d0,.l3E18
	bsr.w	GiveWordRamToSub
	rts
	move.w	$A12022.l,$A11200.l
	rts
	tst.w	$FF6CF8.l
	bne.w	.l3E58
	moveq	#$0,d1
	move.w	$A12022.l,d1
	move.l	d1,d0
	asl.w	#$1,d0
	lea.l	$FF4E76.l,a0
	adda.l	d0,a0
	move.w	(a0),d2
	move.w	#$4,d0
	bsr.w	Set1MFlag_6
.l3E58	rts
	move.w	sr,-(sp)
	move.w	#$2700,sr
	move.w	#$2,d0
	move.w	$A12022.l,d1
	move.w	#$100,d4
	bsr.w	Set1MFlag_6
	move.w	(sp)+,sr
	dc.w	$4E75
	dc.b	$00,$00,$00,$6B,$00,$6A,$00,$75,$00,$7C,$00,$73,$00,$74,$30,$3C	; ...k.j.u.|.s.t0<
	dc.b	$00,$01,$61,$00,$37,$D2,$4E,$75	; ..a.7.Nu
; Reads both pads into $FF4F84/$FF4F85 and updates the edge state.
PollControllers	movem.l	d1/a0,-(sp)
	bsr.w	.lFF3EB8
	move.b	d0,$FF4F84.l
	bsr.w	.lFF3EAC
	move.b	d0,$FF4F85.l
	movem.l	(sp)+,d1/a0
	rts
.lFF3EAC	movem.l	d1/a0,-(sp)
	lea.l	$A10005.l,a0
	dc.w	$600A
.lFF3EB8	movem.l	d1/a0,-(sp)
	lea.l	$A10003.l,a0
.lFF3EC2	moveq	#$0,d0
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
	lea.l	.lFF3F00(pc),a0
	andi.b	#$F0,d0
	or.b	(a0,d1.w),d0
	not.b	d0
	movem.l	(sp)+,d1/a0
	dc.w	$4E75
.lFF3F00	dc.b	$00,$01,$02,$01,$04,$05,$06,$06,$08,$09,$0A,$0A,$08,$09,$0A,$00	; ................
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
	dc.w	$4E75
	dc.b	$08,$00,$04,$08,$06,$07,$05,$08,$02,$01,$03,$08,$08,$08,$08,$08	; ................
	dcb.b	$C,0
DispatchTailSub13	movem.l	d0-d7/a0-a6,-(sp)
	btst.b	#$0,$A1200F.l
	beq.w	.l3FC0
	bclr.b	#$1,$A1200E.l
	bsr.w	PollControllers
	bsr.w	UpdatePad1
	move.w	d1,d5
	bsr.w	UpdatePad2
	or.w	d1,d5
	cmpi.b	#$80,d5
	bne.w	.l3FC0
	bset.b	#$1,$A1200E.l
.l3FC0	movem.l	(sp)+,d0-d7/a0-a6
	dc.w	$4E75
	dc.b	$4E,$73,$08,$F9,$00,$06,$00,$A1,$20,$0E,$08,$39,$00,$06,$00,$A1	; Ns...... ..9....
	dc.b	$20,$0F,$66,$F6,$08,$B9,$00,$06,$00,$A1,$20,$0E,$08,$B9,$00,$07	;  .f....... .....
	dc.b	$00,$A1,$20,$0E,$13,$FC,$00,$00,$00,$A1,$20,$0E,$61,$00,$18,$1A	; .. ....... .a...
	dc.b	$2F,$3C,$00,$FF,$4F,$88,$61,$00,$00,$42,$DF,$FC,$00,$00,$00,$04	; /<..O.a..B......
	dc.b	$60,$00,$F5,$A0,$4E,$75,$08,$F9,$00,$06,$00,$A1,$20,$0E,$08,$39	; `...Nu...... ..9
	dc.b	$00,$06,$00,$A1,$20,$0F,$66,$F6,$08,$B9,$00,$06,$00,$A1,$20,$0E	; .... .f....... .
	dc.b	$08,$B9,$00,$07,$00,$A1,$20,$0E,$13,$FC,$00,$00,$00,$A1,$20,$0E	; ...... ....... .
	dc.b	$61,$00,$BF,$CE,$60,$00,$F5,$6C,$4E,$75	; a...`..lNu
DispatchTail_69	dc.b	$60,$00,$00,$8E	; `...
DispatchTail_70	dcb.b	$8C,0
DispatchTailSub14	lea.l	DispatchTail_71(pc),a0
	move.l	$4(sp),(a0)
	lea.l	.lFF410C(pc),a0
	move.l	$FFFFFD08.w,(a0)
	lea.l	DispatchTail_72(pc),a0
	move.w	sr,d0
	ori.w	#$2700,sr
	move.l	a0,$FFFFFD08.w
	move.w	d0,sr
	jsr	MAINCODE(pc)
.l40F4	dc.w	$303A,$019E
	bne.b	.l40F4
	dc.w	$207A,$0010
	move.w	sr,d0
	ori.w	#$2700,sr
	move.l	a0,$FFFFFD08.w
	move.w	d0,sr
	dc.w	$4E75
.lFF410C	dc.b	$00,$00,$00,$00	; ....
DispatchTail_71	dc.b	$00,$00,$00,$00	; ....
DispatchTailSub15	movea.l	#$C00000,a0
	move.w	#$8F02,$4(a0)
	moveq	#$0,d0
	lsl.l	#$2,d0
	lsr.w	#$2,d0
	bset	#$E,d0
	swap	d0
	move.l	d0,$4(a0)
	moveq	#$0,d0
	move.l	#$3FFF,d1
.l4138	move.l	d0,(a0)
	dbra	d1,.l4138
	moveq	#$0,d0
	move.l	#$C0000000,$4(a0)
	move.l	#$EEE,(a0)
	move.l	d0,(a0)
	move.l	d0,(a0)
	move.l	d0,(a0)
	move.l	d0,(a0)
	move.l	d0,(a0)
	move.l	d0,(a0)
	move.l	d0,(a0)
	move.w	#$9001,$4(a0)
	move.w	#$8B00,$4(a0)
	dc.w	$6114
	move.w	#$8238,$4(a0)
	move.w	#$857C,$4(a0)
	move.w	#$8D3F,$4(a0)
	rts
.lFF417E	move.w	#$8F02,$4(a0)
	moveq	#$0,d0
	lsl.l	#$2,d0
	lsr.w	#$2,d0
	bset	#$E,d0
	swap	d0
	move.l	d0,$4(a0)
	moveq	#$0,d1
	move.w	#$FF,d0
.l419A	move.l	d1,(a0)
	dbra	d0,.l419A
	lea.l	DispatchTail_85(pc),a1
	move.w	#$2FF,d3
.l41A8	move.b	(a1)+,d0
	moveq	#$7,d2
.l41AC	lsl.l	#$4,d1
	add.b	d0,d0
	dc.w	$650A
	ori.b	#$2,d1
	dbra	d2,.l41AC
	dc.w	$6008
.l41BC	ori.b	#$1,d1
	dbra	d2,.l41AC
.l41C4	move.l	d1,(a0)
	dbra	d3,.l41A8
	rts
DispatchTail_72	movem.l	d0-d7/a0-a5,-(sp)
	movea.l	#$A12000,a0
	bset.b	#$0,(a0)
	lea.l	DispatchTail_73(pc),a2
	tst.w	(a2)
	beq.w	.l427E
	movea.l	#$C00000,a0
	lea.l	DispatchTail_76(pc),a1
	move.l	#$C0000000,$4(a0)
	dc.w	$303A,$00A0
.l41FA	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	dbra	d0,.l41FA
	clr.w	(a2)
	dc.w	$263A,$010A
	lea.l	DispatchTail_80(pc),a2
	dc.w	$243A,$0106
	dc.w	$2E3A,$010A
	subq.w	#$1,d7
	dc.w	$2C3A,$0100
	moveq	#$7,d0
	and.w	d6,d0
	dc.w	$662A
	lsr.w	#$3,d6
	subq.w	#$1,d6
.l4230	move.w	d6,d5
	move.l	d3,d0
	add.l	d2,d3
	lsl.l	#$2,d0
	lsr.w	#$2,d0
	bset	#$E,d0
	swap	d0
	move.l	d0,$4(a0)
.l4244	move.l	(a2)+,(a0)
	move.l	(a2)+,(a0)
	move.l	(a2)+,(a0)
	move.l	(a2)+,(a0)
	dbra	d5,.l4244
	dbra	d7,.l4230
	dc.w	$6020
.l4256	subq.w	#$1,d6
.l4258	move.w	d6,d5
	move.l	d3,d0
	add.l	d2,d3
	lsl.l	#$2,d0
	lsr.w	#$2,d0
	bset	#$E,d0
	swap	d0
	move.l	d0,$4(a0)
.l426C	move.w	(a2)+,(a0)
	dbra	d5,.l426C
	dbra	d7,.l4258
.l4276	lea.l	DispatchTail_74(pc),a2
	eori.w	#$1,(a2)
.l427E	lea.l	DispatchTail_70(pc),a0
	addq.l	#$1,(a0)
	move.l	DispatchTail_71(pc),d0
	dc.w	$6704
	movea.l	d0,a0
	jsr	(a0)
.l428E	movem.l	(sp)+,d0-d7/a0-a5
	dc.w	$4E73
DispatchTail_73	dc.b	$00,$00	; ..
DispatchTail_74	dc.b	$00,$00	; ..
DispatchTail_75	dc.b	$00,$00,$00,$00	; ....
DispatchTail_76	dcb.b	$80,0
DispatchTail_77	dc.b	$00,$00,$E0,$00	; ....
.lFF4320	dc.b	$00,$00,$00,$80	; ....
DispatchTail_78	dc.b	$00,$00,$00,$00	; ....
DispatchTail_79	dc.b	$00,$00,$00,$10	; ....
DispatchTail_80	dcb.b	$5EC,0
.lFF4918	dcb.b	$414,0
; Second copy of DrawTextToPlane.
DrawTextToPlane_B	dc.w	$4E56,$0000
DispatchTailSub17	movem.l	d0-d7/a0-a5,-(sp)
	movea.l	#$C00000,a0
	movea.l	#$E000,a2
	move.l	$C(a6),d0
	add.l	d0,d0
	adda.l	d0,a2
	move.l	$8(a6),d0
	mulu.w	#$80,d0
	adda.l	d0,a2
	move.w	#$8F02,$4(a0)
	move.l	a2,d0
	lsl.l	#$2,d0
	lsr.w	#$2,d0
	bset	#$E,d0
	swap	d0
	move.l	d0,$4(a0)
	moveq	#$0,d0
	movea.l	$10(a6),a1
.l4D6E	move.b	(a1)+,d0
	dc.w	$6704
	move.w	d0,(a0)
	bra.b	.l4D6E
.l4D76	movem.l	(sp)+,d0-d7/a0-a5
	unlk	a6
	movea.l	(sp)+,a0
	lea.l	$C(sp),sp
	jmp	(a0)
.l4D84	move.w	DispatchTail_73(pc),d0
	bne.b	.l4D84
	movea.l	#$C00000,a0
	move.l	#$E000,d0
	lsl.l	#$2,d0
	lsr.w	#$2,d0
	bset	#$E,d0
	swap	d0
	move.l	d0,$4(a0)
	moveq	#$0,d0
	move.w	#$3FF,d1
.l4DAA	move.l	d0,(a0)
	dbra	d1,.l4DAA
	lea.l	DispatchTail_74(pc),a0
	move.w	#$1,(a0)
	lea.l	DispatchTail_76(pc),a0
	move.l	#$EEE,(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	lea.l	DispatchTail_73(pc),a0
	move.w	#$1,(a0)
.l4DD8	move.w	(a0),d0
	bne.b	.l4DD8
	moveq	#$0,d0
	rts
; Second copy of DrawTextBuffer.
DrawTextBuffer_B	dc.w	$4E56,$0000
DispatchTail_81	movem.l	d0-d7/a0-a5,-(sp)
	lea.l	DispatchTail_73(pc),a2
.l4DEC	tst.w	(a2)
	bne.b	.l4DEC
	movea.l	#$C00000,a0
	movea.l	$10(a6),a4
	lea.l	DispatchTail_77(pc),a1
	move.l	$C(a6),(a1)
DispatchTail_82	movea.l	$14(a6),a1
	cmpi.w	#$534D,(a1)
	bne.w	DispatchTail_84
	move.w	$8(a1),d6
	move.w	$A(a1),d7
	suba.l	a5,a5
	move.w	DispatchTail_74(pc),d1
	dc.w	$660C
	moveq	#$0,d0
	move.w	d6,d0
	mulu.w	d7,d0
DispatchTail_83	adda.l	d0,a5
	lsl.l	#$5,d0
	adda.l	d0,a4
.lFF4E2A	move.w	$2(a1),d1
	andi.w	#$3,d1
	lea.l	DispatchTail_75(pc),a2
	move.w	d1,(a2)
	move.w	d1,d0
	lea.l	$C(a1),a1
	lea.l	DispatchTail_76(pc),a2
.l4E42	move.l	(a1)+,(a2)+
	clr.w	-$4(a2)
	move.l	(a1)+,(a2)+
	move.l	(a1)+,(a2)+
	move.l	(a1)+,(a2)+
	move.l	(a1)+,(a2)+
	move.l	(a1)+,(a2)+
	move.l	(a1)+,(a2)+
	move.l	(a1)+,(a2)+
	dbra	d0,.l4E42
DispatchTailSub19	lea.l	DispatchTail_78(pc),a3
	move.l	d6,(a3)
	lea.l	DispatchTail_79(pc),a3
	move.l	d7,(a3)
	lea.l	DispatchTail_80(pc),a3
	move.l	d7,-(sp)
	move.l	$10(a6),d3
	lsr.l	#$5,d3
	add.w	a5,d3
	move.l	$8(a6),d0
	dc.w	$6704
	bset	#$F,d3
.l4E7E	moveq	#$1,d2
	move.w	d7,d5
	dc.w	$6022
DispatchTailSub20	move.w	d6,d4
	dc.w	$601A
.l4E88	subq.w	#$1,d2
	dc.w	$6608
	move.l	(a1)+,d7
	moveq	#$11,d1
	ror.l	d1,d7
	moveq	#$10,d2
.l4E94	move.w	d7,d1
	rol.l	#$2,d7
	andi.w	#$6000,d1
	add.w	d3,d1
	addq.w	#$1,d3
	move.w	d1,(a3)+
.l4EA2	dbra	d4,.l4E88
.lFF4EA6	dbra	d5,DispatchTailSub20
	move.l	(sp)+,d7
	moveq	#$0,d2
	move.w	d6,d2
	mulu.w	d7,d2
	lsl.l	#$4,d2
	move.l	a4,d0
	dc.w	$6146
	dc.w	$602E
	move.l	a4,d0
	lsl.l	#$2,d0
	lsr.w	#$2,d0
	bset	#$E,d0
	swap	d0
	move.l	d0,$4(a0)
	dc.w	$6018
.l4ECC	move.w	d6,d4
	dc.w	$6010
.l4ED0	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
.l4EE0	dbra	d4,.l4ED0
.l4EE4	dbra	d7,.l4ECC
DispatchTail_84	lea.l	DispatchTail_73(pc),a2
	move.w	#$1,(a2)
	movem.l	(sp)+,d0-d7/a0-a5
	unlk	a6
	movea.l	(sp)+,a0
	lea.l	$10(sp),sp
	jmp	(a0)
.lFF4EFE	move.l	a1,d1
	addq.w	#$2,d1
	lsr.l	#$1,d1
	move.w	#$8F02,$4(a0)
	move.w	#$8174,$4(a0)
	move.w	#$9300,d3
	move.b	d2,d3
	move.w	d3,$4(a0)
	lsr.w	#$8,d2
	move.w	#$9400,d3
	move.b	d2,d3
	move.w	d3,$4(a0)
	move.w	#$9500,d3
	move.b	d1,d3
	move.w	d3,$4(a0)
	lsr.l	#$8,d1
	move.w	#$9600,d3
	move.b	d1,d3
	move.w	d3,$4(a0)
	lsr.w	#$8,d1
	move.w	#$9700,d3
	move.b	d1,d3
	move.w	d3,$4(a0)
	lsl.l	#$2,d0
	lsr.w	#$2,d0
	swap	d0
	ori.l	#$40000080,d0
	move.l	d0,$4(a0)
	move.w	#$8164,$4(a0)
	andi.w	#$FF7F,d0
	move.l	d0,$4(a0)
	move.l	(a1),(a0)
	dc.w	$4E75
DispatchTail_85	dcb.b	$8,0
	dc.b	'    ',$00,$20,$00,$00,$50,$50,$00,$00,$00,$00,$00,$00	;     . ..PP......
	dc.b	$28,$78,$50,$F0,$A0,$00,$00,' pP ',$10,$50,$70,$20,$00	; (xP.... pP .Pp .
	dc.b	$50,$A0,$40,$30,$50,$A0,$00,$00,$60,$80,$40,$A8,$90,$68,$00,$00	; P.@0P...`.@..h..
	dc.b	$40,$40,$00,$00,$00,$00,$00,$00,' @@@@@ ',$00	; @@...... @@@@@ .
	dc.b	'@     @',$00,' pp ',$00,$00,$00,$00	; @     @. pp ....
	dc.b	$00,$20,$20,$F8,$20,$20,$00,$00,$00,$00,$00,$00,$00,$20,$20,$40	; .  .  .......  @
	dc.b	$00,$00,$00,$F0	; ....
	dcb.b	$9,0
	dc.b	$20,$00,$00,$10,$10,'  @@',$00,$00,$60,$90,$90,$90,$90	;  ....  @@..`....
	dc.b	$60,$00,$00,'`    p',$00,$00,$60,$90,$10,$20,$40	; `..`    p..`.. @
	dc.b	$F0,$00,$00,$60,$90,$20,$10,$90,$60,$00,$00,$10,$30,$50,$F0,$10	; ...`. ..`...0P..
	dc.b	$10,$00,$00,$F0,$80,$E0,$10,$90,$60,$00,$00,$20,$40,$E0,$90,$90	; ........`.. @...
	dc.b	$60,$00,$00,$F0,$90,'  @@',$00,$00,$60,$90,$60,$90,$90	; `....  @@..`.`..
	dc.b	$60,$00,$00,$60,$90,$90,$70,$20,$40,$00,$00,$00,$00,$20,$00,$00	; `..`..p @.... ..
	dc.b	$20,$00,$00,$00,$00,$20,$00,$00,$20,$20,$40,$00,$20,$40,$80,$40	;  .... ..  @. @.@
	dc.b	$20,$00,$00,$00,$00,$F0,$00,$F0,$00,$00,$00,$00,$40,$20,$10,$20	;  ...........@ . 
	dc.b	$40,$00,$00,$60,$90,$20,$40,$00,$40,$00,$00,$60,$90,$B0,$D0,$B0	; @..`. @.@..`....
	dc.b	$80,$60,$00,$60,$90,$90,$F0,$90,$90,$00,$00,$E0,'P`PP'	; .`.`........P`PP
	dc.b	$E0,$00,$00,$70,$90,$80,$80,$90,$60,$00,$00,$E0,'PPPP'	; ...p....`...PPPP
	dc.b	$E0,$00,$00,$F0,'@`@@',$F0,$00,$00,$F0,'@`@@'	; ....@`@@....@`@@
	dc.b	$E0,$00,$00,$60,$90,$80,$B0,$90,$60,$00,$00,$D8,$90,$F0,$90,$90	; ...`....`.......
	dc.b	$D8,$00,$00,'p    p',$00,$00,$38,$10,$10,$90,$90	; ...p    p..8....
	dc.b	$60,$00,$00,$90,$A0,$C0,$C0,$A0,$90,$00,$00,$E0,'@@@H'	; `...........@@@H
	dc.b	$F8,$00,$00,$88,$D8,$A8,$88,$88,$88,$00,$00,$90,$90,$D0,$B0,$90	; ................
	dc.b	$90,$00,$00,$60,$90,$90,$90,$90,$60,$00,$00,$E0,'PP`@'	; ...`....`...PP`@
	dc.b	$E0,$00,$00,$60,$90,$90,$90,$90,$60,$10,$00,$E0,'PP`P'	; ...`....`...PP`P
	dc.b	$C8,$00,$00,$70,$90,$60,$10,$90,$E0,$00,$00,$F8,$A8,$A8,$20,$20	; ...p.`........  
	dc.b	$70,$00,$00,$D8,$90,$90,$90,$90,$60,$00,$00,$D8,$88,$50,$50,$20	; p.......`....PP 
	dc.b	$20,$00,$00,$A8,$A8,$A8,$50,$50,$50,$00,$00,$D8,'P  P'	;  .....PPP...P  P
	dc.b	$D8,$00,$00,$D8,'P   p',$00,$00,$F0,$90,$20,$40,$90	; ....P   p.... @.
	dc.b	$F0,$00,$00,'`@@@@@@`@@  ',$10	; ...`@@@@@@`@@  .
	dc.b	$10,$00,$00,'`      ``',$90	; ...`      ``.
	dcb.b	$D,0
	dc.b	$F8,$40,$20	; .@ 
	dcb.b	$8,0
	dc.b	$E0,$50,$90,$70,$00,$00,$80,$80,$E0,$90,$90,$E0,$00,$00,$00,$00	; .P.p............
	dc.b	$70,$90,$80,$70,$00,$00,$30,$10,$70,$90,$90,$78,$00,$00,$00,$00	; p..p..0.p..x....
	dc.b	$60,$B0,$C0,$70,$00,$00,$30,$40,$F0,$40,$40,$F0,$00,$00,$00,$00	; `..p..0@.@@.....
	dc.b	$70,$90,$90,$70,$10,$60,$C0,$80,$E0,$90,$90,$D8,$00,$00,$20,$00	; p..p.`........ .
	dc.b	'`  p',$00,$00,$20,$00,$E0,'    ',$C0,$C0,$40	; `  p.. ..    ..@
	dc.b	$50,$60,$50,$D8,$00,$00,'`    p',$00,$00,$00,$00	; P`P...`    p....
	dc.b	$D0,$A8,$A8,$A8,$00,$00,$00,$00,$E0,$90,$90,$90,$00,$00,$00,$00	; ................
	dc.b	$60,$90,$90,$60,$00,$00,$00,$00,$E0,$90,$90,$E0,$80,$C0,$00,$00	; `..`............
	dc.b	$70,$90,$90,$70,$10,$38,$00,$00,$B0,$40,$40,$E0,$00,$00,$00,$00	; p..p.8...@@.....
	dc.b	$70,$C0,$30,$E0,$00,$00,$00,$40,$F0,$40,$40,$30,$00,$00,$00,$00	; p.0....@.@@0....
	dc.b	$90,$90,$90,$70,$00,$00,$00,$00,$D8,$50,$20,$20,$00,$00,$00,$00	; ...p.....P  ....
	dc.b	$A8,$A8,$50,$50,$00,$00,$00,$00,'P  P',$00,$00,$00,$00	; ..PP....P  P....
	dc.b	$D8,'PP  @',$00,$00,$F0,$20,$40,$F0,$00,$00,$20,$40	; .PP  @... @... @
	dc.b	$40,$80,$40,$40,$20,$00,'       ',$00,$40,$20	; @.@@ .       .@ 
	dc.b	$20,$10,$20,$20,$40,$00,$00,$00,$50,$A0	;  .  @...P.
	dcb.b	$C,0
DoDrawTextCommand	dc.w	$4E56,$FF00
DoDrawTextCommandSub1	movem.l	d6-d7/a4,-(sp)
	lea.l	-$100(a6),a4
	clr.w	d6
	dc.w	$6018
.l527A	cmpi.b	#$1,d7
	dc.w	$660A
	move.w	d6,d0
	addq.w	#$1,d6
	clr.b	(a4,d0.w)
	dc.w	$6010
.l528A	move.w	d6,d0
	addq.w	#$1,d6
	move.b	d7,(a4,d0.w)
.l5292	jsr	GetCommandFromSub(pc)
	move.b	d0,d7
	bne.b	.l527A
.l529A	move.l	a4,-(sp)
	jsr	aprint(pc)
	addq.w	#$4,sp
	movem.l	-$10C(a6),d6-d7/a4
	unlk	a6
	dc.w	$4E75
	dc.b	$91,'DoDrawTextComma'	; .DoDrawTextComma
	dc.b	$6E,$64,$00,$00	; nd..
DoMoviePlayBack	dc.w	$4E56,$0000
DoMoviePlayBackSub1	movem.l	d5-d7/a4,-(sp)
	movea.l	#$200000,a4
	move.l	(a4),d5
	move.l	$4(a4),d6
	move.l	$8(a4),d7
	dc.w	$6022
.l52DA	moveq	#$1,d0
	move.l	d0,-(sp)
	jsr	Set1MFlag(pc)
	move.l	#$200000,-(sp)
	move.l	d5,-(sp)
	move.l	d6,-(sp)
	move.l	d7,-(sp)
	jsr	DrawTextBuffer_B(pc)
	moveq	#$0,d0
	move.l	d0,-(sp)
	jsr	Set1MFlag(pc)
	addq.w	#$8,sp
.l52FC	jsr	GetCommandFromSub(pc)
	cmpi.w	#$2,d0
	beq.b	.l52DA
	movem.l	-$10(a6),d5-d7/a4
	unlk	a6
	dc.w	$4E75
	dc.b	$8F,'DoMoviePlayBack'	; .DoMoviePlayBack
	dc.b	$00,$00	; ..
MAINCODE	dc.w	$4E56,$0000
	move.l	d7,-(sp)
	jsr	InitWorld(pc)
	pea.l	.lFF539A(pc)
	jsr	aprint(pc)
	addq.w	#$4,sp
	dc.w	$6026
.l5338	move.w	d7,d0
	subq.w	#$1,d0
	dc.w	$6706
	subq.w	#$2,d0
	dc.w	$6708
	dc.w	$600C
.l5344	jsr	DoDrawTextCommand(pc)
	dc.w	$6014
.l534A	jsr	DoMoviePlayBack(pc)
	dc.w	$6016
.l5350	ext.l	d7
	move.l	d7,-(sp)
	pea.l	.lFF538E(pc)
	jsr	aprint(pc)
	addq.w	#$8,sp
.l535E	jsr	GetCommandFromSub(pc)
	move.w	d0,d7
	bne.b	.l5338
.l5366	pea.l	.lFF5384(pc)
	jsr	aprint(pc)
	addq.w	#$4,sp
	move.l	-$4(a6),d7
	unlk	a6
	dc.w	$4E75
	dc.b	$88,'MAINCODE',$00,$00,$38	; .MAINCODE..8
.lFF5384	dc.b	'Main Done',$00	; Main Done.
.lFF538E	dc.b	'Command: %d',$00	; Command: %d.
.lFF539A	dc.b	'MAINCPU ready to'	; MAINCPU ready to
	dc.b	' handle commands'	;  handle commands
	dc.b	$00,$00	; ..
ReDraw	dc.w	$4E56,$0000
	unlk	a6
	dc.w	$4E75
	dc.b	$86,'ReDraw',$00,$00,$00	; .ReDraw...
drawprint	dc.w	$4E56,$0000
	move.l	$8(a6),-(sp)
	lea.l	DispatchTail_69(pc),a0
	move.l	$5C(a0),-(sp)
	lea.l	DispatchTail_69(pc),a0
	move.l	$60(a0),-(sp)
	jsr	DrawTextToPlane_B(pc)
	lea.l	DispatchTail_69(pc),a0
	addq.l	#$1,$60(a0)
	lea.l	DispatchTail_69(pc),a0
	moveq	#$18,d0
	cmp.l	$60(a0),d0
	dc.w	$6E0C
	lea.l	DispatchTail_69(pc),a0
	subi.l	#$14,$60(a0)
.l540A	jsr	ReDraw(pc)
	unlk	a6
	dc.w	$4E75
	dc.b	$89,'drawprint',$00,$00	; .drawprint..
NumStr	dc.w	$4E56,$FFF0
NumStrSub1	movem.l	d6-d7/a3-a4,-(sp)
	movea.l	$10(a6),a3
	lea.l	-$10(a6),a4
	move.l	$8(a6),d6
	clr.w	d7
	move.w	d7,d0
	addq.w	#$1,d7
	clr.b	(a4,d0.w)
.l543C	move.l	d6,d0
	moveq	#$A,d1
	jsr	LongModU_B(pc)
	moveq	#$30,d1
	add.b	d1,d0
	move.w	d7,d1
	addq.w	#$1,d7
	move.b	d0,(a4,d1.w)
	move.l	d6,d0
	moveq	#$A,d1
	jsr	LongDivU_B(pc)
	move.l	d0,d6
	bne.b	.l543C
	dc.w	$6006
.l545E	subq.w	#$1,d7
	move.b	(a4,d7.w),(a3)+
.l5464	tst.w	d7
	bne.b	.l545E
	movem.l	-$20(a6),d6-d7/a3-a4
	unlk	a6
	dc.w	$4E75
	dc.b	$86,'NumStr',$00,$00,$00	; .NumStr...
HexStr	dc.w	$4E56,$0000
HexStrSub1	movem.l	d3-d7/a4,-(sp)
	move.w	$E(a6),d4
	move.l	$8(a6),d5
	movea.l	$10(a6),a4
	ext.l	d4
	move.l	d4,d7
	subq.l	#$1,d7
	moveq	#$0,d3
	dc.w	$6026
.l549A	moveq	#$F,d6
	and.l	d5,d6
	asr.l	#$4,d5
	moveq	#$9,d0
	cmp.l	d6,d0
	dc.w	$6D0C
	move.b	d6,d0
	moveq	#$30,d1
	add.b	d1,d0
	move.b	d0,(a4,d7.l)
	dc.w	$600A
.l54B2	move.b	d6,d0
	moveq	#-55,d1
	sub.b	d1,d0
	move.b	d0,(a4,d7.l)
.l54BC	move.l	d7,d0
	subq.l	#$1,d7
.l54C0	cmp.l	d7,d3
	ble.b	.l549A
	clr.b	(a4,d4.w)
	movem.l	-$18(a6),d3-d7/a4
	unlk	a6
	dc.w	$4E75
	dc.b	$86,'HexStr',$00,$00,$00	; .HexStr...
aprint	dc.w	$4E56,$FED8
aprintSub1	movem.l	d4-d7/a3-a4,-(sp)
	lea.l	-$128(a6),a4
	bra.w	.l55F0
.l54EC	cmpi.b	#$25,d6
	dc.w	$6706
	move.b	d6,(a3)+
	bra.w	.l55D4
.l54F8	moveq	#$8,d4
	movea.l	$8(a6),a0
	addq.l	#$1,$8(a6)
	move.b	(a0),d6
	move.b	d6,d0
	subi.b	#$2A,d0
	dc.w	$6618
	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.w	-$2(a0),d4
	move.l	$8(a6),d0
	addq.l	#$1,$8(a6)
	movea.l	d0,a0
	move.b	(a0),d6
.l5524	move.b	d6,d0
	subi.b	#$25,d0
	beq.w	.l55D2
	subi.b	#$2E,d0
	dc.w	$6778
	subq.b	#$5,d0
	dc.w	$6744
	subi.b	#$C,d0
	dc.w	$670E
	subi.b	#$F,d0
	dc.w	$6768
	subq.b	#$5,d0
	dc.w	$6734
	bra.w	.l55D4
.l554C	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),d5
	move.l	a4,-(sp)
	ext.l	d4
	move.l	d4,-(sp)
	move.l	d5,-(sp)
	jsr	NumStr(pc)
	clr.w	d7
	lea.l	$C(sp),sp
	dc.w	$6008
.l556C	move.b	(a4,d7.w),(a3)+
	move.w	d7,d0
	addq.w	#$1,d7
.l5574	tst.b	(a4,d7.w)
	bne.b	.l556C
	dc.w	$6058
.l557C	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),d5
	move.l	a4,-(sp)
	ext.l	d4
	move.l	d4,-(sp)
	move.l	d5,-(sp)
	jsr	HexStr(pc)
	clr.w	d7
	lea.l	$C(sp),sp
	dc.w	$6008
.l559C	move.b	(a4,d7.w),(a3)+
	move.w	d7,d0
	addq.w	#$1,d7
.l55A4	tst.b	(a4,d7.w)
	bne.b	.l559C
	dc.w	$6028
.l55AC	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),-$8(a6)
	dc.w	$600C
.l55BC	move.l	-$8(a6),d0
	addq.l	#$1,-$8(a6)
	movea.l	d0,a0
	move.b	(a0),(a3)+
.l55C8	movea.l	-$8(a6),a0
	tst.b	(a0)
	bne.b	.l55BC
	dc.w	$6002
.l55D2	move.b	d6,(a3)+
.l55D4	move.l	$8(a6),d0
	addq.l	#$1,$8(a6)
	movea.l	d0,a0
	move.b	(a0),d6
	bne.w	.l54EC
	clr.b	(a3)+
	pea.l	-$108(a6)
	jsr	drawprint(pc)
	addq.w	#$4,sp
.l55F0	movem.l	-$140(a6),d4-d7/a3-a4
	unlk	a6
	dc.w	$4E75
	dc.b	$86,'aprint',$00,$00,$00	; .aprint...
InitWorld	dc.w	$4E56,$0000
	movea.l	#$A12010,a0
	clr.w	(a0)
	movea.l	#$A12010,a0
	clr.w	$2(a0)
	lea.l	DispatchTail_69(pc),a0
	moveq	#$4,d0
	move.l	d0,$5C(a0)
	lea.l	DispatchTail_69(pc),a0
	move.l	d0,$60(a0)
	pea.l	.lFF5684(pc)
	jsr	aprint(pc)
	lea.l	DispatchTail_69(pc),a0
	move.l	$54(a0),-(sp)
	pea.l	.lFF5674(pc)
	jsr	aprint(pc)
	lea.l	DispatchTail_69(pc),a0
	move.l	$58(a0),-(sp)
	pea.l	.lFF5664(pc)
	jsr	aprint(pc)
	unlk	a6
	dc.w	$4E75
	dc.b	$89,'InitWorld',$00,$32	; .InitWorld.2
.lFF5664	dc.b	'Heap Size : %x',$00,$00	; Heap Size : %x..
.lFF5674	dc.b	'Heap Start: %x',$00,$00	; Heap Start: %x..
.lFF5684	dc.b	'MAINCPU is alive'	; MAINCPU is alive
	dc.b	$00,$00	; ..
GetCommandFromSub	dc.w	$4E56,$0000
GetCommandFromSubSub1	movem.l	d7/a3-a4,-(sp)
	movea.l	#$A12010,a3
	movea.l	#$A12020,a4
.l56AA	move.w	(a4),d7
	beq.b	.l56AA
	move.w	#$1,(a3)
.l56B2	tst.w	(a4)
	bne.b	.l56B2
	clr.w	(a3)
	move.w	d7,d0
	movem.l	-$C(a6),d7/a3-a4
	unlk	a6
	dc.w	$4E75
	dc.b	$91,'GetCommandFromS'	; .GetCommandFromS
	dc.b	$75,$62,$00,$00	; ub..
Set1MFlag	dc.w	$4E56,$0000
	movea.l	#$A12010,a0
	move.w	$A(a6),$2(a0)
	unlk	a6
	dc.w	$4E75
	dc.b	$89,'Set1MFlag',$00,$00,$22,$2F,$00,$04	; .Set1MFlag.."/..
	dc.b	$20,$2F,$00,$08	;  /..
; Second copy of LongDivU.
LongDivU_B	lea.l	.lFF570C(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.lFF570C	dc.b	$60,$06,$4C,$41,$08,$01,$4E,$75,$4E,$BA,$00,$24,$20,$01,$4E,$75	; `.LA..NuN..$ .Nu
	dc.b	$22,$2F,$00,$04,$20,$2F,$00,$08	; "/.. /..
; Second copy of LongModU.
LongModU_B	lea.l	.lFF5730(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.lFF5730	dc.b	$60,$08,$4C,$41,$08,$01,$C3,'@NuJ',$80,$6B,$14,$4A,$81	; `.LA...@NuJ.k.J.
	dc.b	$6B,$06,$4E,$BA,$00,'FNuD',$81,$4E,$BA,$00,$3E,$44,$81	; k.N..FNuD.N..>D.
	dc.b	$4E,$75,$44,$80,$4A,$81,$6B,$0A,$4E,$BA,$00,$30,$44,$80,$44,$81	; NuD.J.k.N..0D.D.
	dc.b	$4E,$75,$44,$81,$4E,$BA,$00,$24,$44,$80,'Nu"/',$00,$04	; NuD.N..$D.Nu"/..
	dc.b	$20,$2F,$00,$08,$41,$FA,$00,$0A,$32,$7C,$00,$02,$4E,$F0,$92,$FE	;  /..A...2|..N...
	dc.b	$60,$08,$4C,$41,$00,$01,$C3,'@Nu?',$01,'HAJA'	; `.LA...@Nu?.HAJA
	dc.b	$66,$1C,$22,$00,'BAHAg',$0A,$82,$D7,'HAH@'	; f.".BAHAg...HAH@
	dc.b	$30,$01,$48,$40,$80,$DF,$32,$00,'B@H@NuHA'	; 0.H@..2.B@H@NuHA
	dc.b	$3E,$82,$2F,$03,$34,$00,$26,$01,$72,$01,'B@H@f',$0C	; >./.4.&.r.B@H@f.
	dc.b	$48,$40,$30,$02,$72,$00,$60,$16,$D2,$41,$65,$12,$D4,$42,$D1,$80	; H@0.r.`..Ae..B..
	dc.b	$B0,$83,$65,$F4,$90,$83,$D2,$41,$08,$C1,$00,$00,$64,$EE,$26,$1F	; ..e....A....d.&.
	dc.b	$34,$1F,$4E,$75,$00,$00,$00,$00	; 4.Nu....
Set1MFlagSub1	lea.l	$FF481C.l,a0
	move.w	#$FFFF,$70.l
	move.w	a0,$A12006.l
	move.w	#$8A00,$C00004.l
	move.w	#$8014,$C00004.l
	rts
	move.w	#$8004,$C00004.l
	rts
	bset.b	#$6,$A1200E.l
.l5820	btst.b	#$6,$A1200F.l
	bne.b	.l5820
	bclr.b	#$6,$A1200E.l
	bclr.b	#$7,$A1200E.l
	jsr	$FF4918.l
	movea.l	#$FFFC00,sp
	bra.w	DispatchTail_64
	move.w	#$0,d0
	lea.l	$FF6E0C.l,a0
	move.w	#$184F,d1
	movea.l	$A12022.l,a1
	bsr.w	Set1MFlag_6
	lea.l	$FF963C.l,a0
	move.w	#$0,d1
	move.w	#$6,d0
	bsr.w	Set1MFlag_6
	lea.l	$FFA0C6.l,a0
	move.w	#$7,d0
	bsr.w	Set1MFlag_6
	jsr	$FF67E8.l
	rts
	move.w	#$0,d0
	lea.l	$FF6E0C.l,a0
	move.w	#$184F,d1
	movea.l	$A12022.l,a1
	bsr.w	Set1MFlag_6
	jsr	$FF67E8.l
	rts
	move.w	#$0,$A11200.l
	move.b	#$40,$A10009.l
	move.b	#$43,$A1000B.l
	nop
	move.b	#$7C,$A10005.l
	nop
	move.b	#$7F,$A1000B.l
	nop
	move.b	#$7C,$A10005.l
	nop
	move.b	$A10003.l,d0
	andi.b	#$3,d0
	cmpi.b	#$0,d0
	dc.w	$660A
	move.w	#$1,$A12010.l
	dc.w	$6010
.l58FC	move.w	#$0,$A12010.l
	move.b	#$40,$A1000B.l
.l590C	move.w	#$100,$A11200.l
	rts
Set1MFlagSub2	lea.l	$FF485E.l,a0
	move.l	a0,$FFFD08.l
	rts
	lea.l	$FF4854.l,a0
	move.l	a0,$FFFD08.l
	rts
	move.w	#$0,$FF6CFA.l
	rts
	move.l	$A12028.l,$C00004.l
	rts
	move.w	$A12028.l,$C00000.l
	rts
	move.l	$A12028.l,$C00000.l
	rts
	move.w	sr,-(sp)
	move.w	#$2700,sr
	move.w	#$2,d0
	move.w	$A12028.l,d1
	move.w	#$100,d4
	bsr.w	Set1MFlag_6
	move.w	(sp)+,sr
	dc.w	$4E75
	dc.b	$13,$F9,$00,$A1,$20,$28,$00,$A1,$00,$03,$4E,$75,$13,$F9,$00,$A1	; .... (....Nu....
	dc.b	$20,$28,$00,$A1,$00,$05,$4E,$75,$13,$F9,$00,$A1,$00,$03,$00,$A1	;  (....Nu........
	dc.b	$20,$18,$4E,$75,$13,$F9,$00,$A1,$00,$05,$00,$A1,$20,$18,$4E,$75	;  .Nu........ .Nu
	dc.b	$33,$F9,$00,$A1,$20,$28,$00,$C0,$00,$04,$4E,$75,$40,$E7,$46,$FC	; 3... (....Nu@.F.
	dc.b	$27,$00,$20,$7C,$00,$C0,$00,$00,$23,$FC,$00,$00,$00,$20,$00,$C0	; .. |....#.... ..
	dc.b	$00,$04,$20,$3C,$00,$00,$00,$3F,$43,$F9,$00,$FF,$6D,$04,$32,$D0	; .. <...?C...m.2.
	dc.b	$51,$C8,$FF,$FC,$46,$DF,$4E,$75	; Q...F.Nu
Set1MFlagSub3	tst.w	$FF6D84.l
	bne.w	.lFF59F8
	move.w	#$1,$FF6D84.l
	rts
.lFF59F8	movem.l	d0-d7/a0-a2,-(sp)
	st.b	$FF6D8A.l
	bsr.w	.lFF5AC8
	lea.l	Set1MFlag_5(pc),a0
	moveq	#$3F,d1
.l5A0C	move.w	#$0,(a0)+
	dbra	d1,.l5A0C
	move.w	#$18,$FF6D8A.l
.l5A1C	tst.w	$FF6D8A.l
	bpl.w	.l5A1C
	bsr.w	ClearVram
	bsr.w	.lFF5AD4
	movea.l	#$C00000,a0
	move.w	#$8C81,$4(a0)
	move.w	#$9001,$4(a0)
	move.w	#$8230,$4(a0)
	move.w	#$8406,$4(a0)
	movea.l	$FF6D86.l,a1
	move.w	$2(a1),d0
	lsl.w	#$4,d0
	move.w	d0,d2
	move.w	#$20,d1
	move.w	d1,d5
	lsr.w	#$5,d5
	lea.l	$4(a1),a0
	jsr	$FF6BD0.l
	add.w	d2,d2
	lea.l	$4(a1,d2.w),a0
	lea.l	Set1MFlag_5(pc),a1
	moveq	#$1F,d0
.l5A78	move.l	(a0)+,(a1)+
	dbra	d0,.l5A78
	move.w	(a0)+,d1
	move.w	(a0)+,d2
	movea.l	a0,a2
	subq.w	#$1,d1
	subq.w	#$1,d2
	move.w	d1,d3
	move.w	#$80,d7
	moveq	#$0,d4
	move.w	#$C000,d4
.l5A94	move.l	d4,d0
	bsr.w	Set1MFlag_3
.l5A9A	move.w	(a2)+,d6
	add.w	d5,d6
	move.w	d6,(a0)
	dbra	d1,.l5A9A
	move.w	d3,d1
	add.w	d7,d4
	dbra	d2,.l5A94
	move.w	#$18,$FF6D8A.l
.l5AB4	tst.w	$FF6D8A.l
	bpl.w	.l5AB4
	bsr.w	Set1MFlagSub2
	movem.l	(sp)+,d0-d7/a0-a2
	rts
.lFF5AC8	lea.l	Set1MFlag_4(pc),a0
	move.l	a0,$FFFD08.l
	rts
.lFF5AD4	movea.l	#$C00000,a1
	move.l	#$27,d0
	move.l	#$40000010,$4(a1)
.l5AE8	move.w	#$0,(a1)
	dbra	d0,.l5AE8
	rts
Set1MFlag_3	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
	move.l	d0,$4(a0)
	rts
Set1MFlag_4	movem.l	d0-d7/a0-a4,-(sp)
	tst.w	$FF6D8A.l
	bmi.w	.l5BA4
	cmpi.w	#$64,$FF6D8A.l
	beq.w	.l5BAA
	subq.w	#$1,$FF6D8A.l
	bmi.w	.l5BA4
	clr.l	d0
	move.w	$FF6D8A.l,d0
	cmpi.w	#$18,d0
	bgt.w	.l5BA4
	divu.w	#$3,d0
	swap	d0
	asl.w	#$2,d0
	moveq	#$2,d3
	asl.w	d0,d3
	moveq	#$E,d5
	asl.w	d0,d5
	move.w	d5,d4
	not.w	d4
	lea.l	Set1MFlag_5(pc),a1
	movea.l	#$C00000,a0
	clr.w	d6
.l5B60	move.w	d3,d2
	move.w	d6,d0
	swap	d0
	move.w	#$20,d0
	move.l	d0,$4(a0)
	move.w	(a0),d7
	move.w	d7,d0
	and.w	d5,d0
	move.w	(a1)+,d1
	and.w	d5,d1
	cmp.w	d1,d0
	beq.w	.l5B9A
	blt.w	.l5B84
	neg.w	d2
.l5B84	add.w	d2,d0
	and.w	d4,d7
	or.w	d0,d7
	move.l	#$C000,d0
	move.b	d6,d0
	swap	d0
	move.l	d0,$4(a0)
	move.w	d7,(a0)
.l5B9A	addq.w	#$2,d6
	cmpi.w	#$80,d6
	bne.w	.l5B60
.l5BA4	movem.l	(sp)+,d0-d7/a0-a4
	rte
.l5BAA	lea.l	$FF6D8C.l,a1
	movea.l	#$C00000,a0
	move.l	#$C0000000,$4(a0)
	moveq	#$1F,d0
.l5BC0	move.l	(a1)+,(a0)
	dbra	d0,.l5BC0
	st.b	$FF6D8A.l
	bra.w	.l5BA4
Set1MFlagSub4	movem.l	d2-d7/a1-a2,-(sp)
	moveq	#$0,d7
	lea.l	$C00004.l,a1
	move.w	#$8154,(a1)
	move.w	#$8F02,(a1)
	move.w	#$9300,d2
	move.b	d0,d2
	move.w	d2,(a1)
	move.w	#$9400,d2
	lsr.w	#$8,d0
	move.b	d0,d2
	move.w	d2,(a1)
	cmpa.l	#$240000,a0
	ble.w	.l5C04
	bra.w	.l5C10
.l5C04	moveq	#$1,d7
	move.w	d1,d6
	move.l	(a0),d5
	adda.l	#$2,a0
.l5C10	move.l	a0,d0
	lsr.l	#$1,d0
	move.w	#$9500,d2
	move.b	d0,d2
	move.w	d2,(a1)
	lsr.l	#$8,d0
	move.w	#$9600,d2
	move.b	d0,d2
	move.w	d2,(a1)
	lsr.l	#$8,d0
	andi.b	#$7F,d0
	move.w	#$9700,d2
	move.b	d0,d2
	move.w	d2,(a1)
	clr.l	d0
	move.w	d1,d0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	move.l	d0,d3
	ori.l	#$804000,d0
	move.l	d0,$FF6CE8.l
	move.w	$FF6CEA.l,(a1)
	move.w	$FF6CE8.l,(a1)
.l5C56	move.w	$C00004.l,-(sp)
	btst.b	#$1,$1(sp)
	addq.w	#$2,sp
	bne.w	.l5C56
	move.w	#$8164,$C00004.l
	tst.w	d7
	beq.w	.l5C80
	moveq	#$0,d0
	move.w	d6,d0
	bsr.w	Set1MFlag_3
	move.l	d5,(a0)
.l5C80	movem.l	(sp)+,d2-d7/a1-a2
	rts
	bsr.w	WaitDmnaClear
	movea.l	#$C00004,a0
	move.w	#$8B00,(a0)
	move.w	#$9100,(a0)
	move.w	#$9200,(a0)
	move.w	#$8578,(a0)
	move.w	#$8D3D,(a0)
	movea.l	#$200000,a0
	move.l	a0,$FF6D86.l
	move.w	#$1,$FF6D84.l
	bsr.w	Set1MFlagSub3
	lea.l	RunSubCommand(pc),a1
	movea.l	#$205BC8,a0
	move.l	#$C5A,d0
.l5CCC	move.l	(a0)+,(a1)+
	dbra	d0,.l5CCC
	move.l	#$FF1006,$FF6D86.l
	bsr.w	GiveWordRamToSub
	clr.w	$FF6D84.l
	dc.w	$4E75
	dcb.b	$E,0
	dc.b	$FF,$FF	; ..
	dcb.b	$94,0
Set1MFlag_5	dcb.b	$80,0
	dc.b	$C3,$00,$06,$00,$C3,$51,$10,$00,$C3,$51,$10,$00,$C3,$51,$10,$00	; .....Q...Q...Q..
	dc.b	$C3,$51,$10,$00,$C3,$51,$10,$00,$C3,$51,$10,$00,$C3,$51,$10,$00	; .Q...Q...Q...Q..
	dc.b	$18,$4F,$18,$4F,$14,$48,$16,$49,$18,$4B	; .O.O.H.I.K
	dcb.b	$5D6,0
	incbin	..\Extracted\SegaCD\MAIN\main_0640C.bin
.lFF67E8	incbin	..\Extracted\SegaCD\MAIN\main_067E8.bin
.lFF6BD0	incbin	..\Extracted\SegaCD\MAIN\main_06BD0.bin
	dcb.b	$301,0
	dc.b	$FF	; .
	dcb.b	$200,0
	dc.b	$FF,$FE,$03,$00,$C0,$00,$00	; .......
Set1MFlag_6	tst.w	d0
	dc.w	$6604
	bra.w	Set1MFlag_7
.l7664	dc.w	$0440,$0001
	dc.w	$6604
	bra.w	Set1MFlag_8
.l766E	dc.w	$0440,$0001
	dc.w	$6604
	bra.w	Set1MFlag_9
.l7678	dc.w	$0440,$0001
	dc.w	$6604
	bra.w	Set1MFlag_10
.l7682	dc.w	$0440,$0001
	dc.w	$6604
	bra.w	Set1MFlag_11
.l768C	dc.w	$0440,$0001
	dc.w	$6604
	bra.w	Z80ReadStatus
.l7696	dc.w	$0440,$0001
	dc.w	$6604
	bra.w	Set1MFlag_22
.l76A0	dc.w	$0440,$0001
	dc.w	$6604
	bra.w	Set1MFlag_23
.l76AA	dc.w	$0440,$0001
	dc.w	$6604
	bra.w	Set1MFlag_24
.l76B4	dc.w	$0440,$0001
	dc.w	$6604
	bra.w	Set1MFlag_25
.l76BE	move.w	#$1,d0
	ori.b	#$1,ccr
	dc.w	$4E75
