DispatchTailSub1	move.l	$4(sp),d1
	move.l	$8(sp),d0
DispatchTail_62	lea.l	.lFF34CC(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.lFF34CC	dc.b	$60,$06,$4C,$41,$08,$01,$4E,$75,$4E,$BA,$00,$24,$20,$01,$4E,$75	; `.LA..NuN..$ .Nu
	dc.b	$22,$2F,$00,$04,$20,$2F,$00,$08	; "/.. /..
DispatchTail_63	lea.l	.lFF34F0(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.lFF34F0	dc.b	$60,$08,$4C,$41,$08,$01,$C3,'@NuJ',$80,$6B,$14,$4A,$81	; `.LA...@NuJ.k.J.
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
DispatchTailSub2	movea.l	#$FFFC00,sp
	move.w	#$0,$A12010.l
	move.w	#$0,$A12012.l
	move.w	#$0,$A12014.l
	move.w	#$0,$A12016.l
	move.w	#$0,$A12018.l
	move.w	#$0,$A1201A.l
	move.w	#$0,$A1201C.l
	move.w	#$0,$A1201E.l
	move.b	#$0,$A1200E.l
	move.w	#$0,$FF6CEE.l
	bsr.w	SubCommHandshake
	bsr.w	WaitWordRamMode2M
	bsr.w	GiveWordRamToSub
	move.l	#$0,$FF6D00.l
	move.l	#$0,$FF6CFC.l
	bra.w	DispatchTail_64
DispatchTail_64	btst.b	#$7,$A1200F.l
	bne.b	DispatchTail_64
	btst.b	#$6,$A1200F.l
	beq.b	DispatchTail_64
	bset.b	#$7,$A1200E.l
	move.w	$A12020.l,d0
	lsl.w	#$2,d0
	lea.l	$FF471C.l,a1
	movea.l	-$4(a1,d0.w),a0
	jsr	(a0)
	bset.b	#$6,$A1200E.l
.l365A	btst.b	#$6,$A1200F.l
	bne.b	.l365A
	bclr.b	#$6,$A1200E.l
	bclr.b	#$7,$A1200E.l
	bra.w	DispatchTail_64
; Handshakes with the sub CPU on $A1200E/F and reads the comm word $A12020.
ReadSubCommWord	btst.b	#$7,$A1200F.l
	bne.b	ReadSubCommWord
	btst.b	#$6,$A1200F.l
	beq.b	ReadSubCommWord
	bset.b	#$7,$A1200E.l
	move.w	$A12020.l,d0
	bset.b	#$6,$A1200E.l
.l36A2	btst.b	#$6,$A1200F.l
	bne.b	.l36A2
	bclr.b	#$6,$A1200E.l
	bclr.b	#$7,$A1200E.l
	rts
.l36BE	btst.b	#$7,$A1200F.l
	bne.b	.l36BE
	move.w	d0,$A12010.l
	bset.b	#$6,$A1200E.l
.l36D6	btst.b	#$6,$A1200F.l
	beq.b	.l36D6
	bset.b	#$7,$A1200E.l
	bclr.b	#$6,$A1200E.l
.l36F0	btst.b	#$6,$A1200F.l
	bne.b	.l36F0
	bclr.b	#$7,$A1200E.l
	rts
DispatchTailSub4	movem.l	d0-d7/a0-a6,-(sp)
	lsl.w	#$2,d0
	lea.l	$FF471C.l,a1
	movea.l	-$4(a1,d0.w),a0
	jsr	(a0)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.b	$00,$FF,$49,$6E,$00,$FF,$49,$DA,$00,$FF,$4A,$2E,$00,$FF,$4A,$56	; ..In..I...J...JV
	dc.b	$00,$FF,$4A,$78,$00,$FF,$4A,$82,$00,$FF,$4A,$8C,$00,$FF,$4A,$92	; ..Jx..J...J...J.
	dc.b	$00,$FF,$4B,$3C,$00,$FF,$4B,$48,$00,$FF,$4B,$54,$00,$FF,$4B,$60	; ..K<..KH..KT..K`
	dc.b	$00,$FF,$4B,$6C,$00,$FF,$4B,$78,$00,$FF,$4B,$84,$00,$FF,$4B,$90	; ..Kl..Kx..K...K.
	dc.b	$00,$FF,$4B,$9C,$00,$FF,$4B,$A8,$00,$FF,$4B,$B4,$00,$FF,$4B,$C0	; ..K...K...K...K.
	dc.b	$00,$FF,$4B,$CC,$00,$FF,$4B,$D8,$00,$FF,$4C,$14,$00,$FF,$4C,$22	; ..K...K...L...L"
	dc.b	$00,$FF,$4C,$30,$00,$FF,$4B,$F0,$00,$FF,$4B,$FC,$00,$FF,$4C,$08	; ..L0..K...K...L.
	dc.b	$00,$FF,$4C,$3E,$00,$FF,$4C,$AC,$00,$FF,$4D,$8E	; ..L>..L...M.
	dc.l	DispatchTail_81,DispatchTail_82,DispatchTail_83
	dc.b	$00,$FF,$4E,$30,$00,$FF,$4E,$84,$00,$FF,$4F,$C8,$00,$FF,$4E,$5A	; ..N0..N...O...NZ
	dc.b	$00,$FF,$67,$E8,$00,$FF,$68,$18,$00,$FF,$68,$4A,$00,$FF,$68,$0E	; ..g...h...hJ..h.
	dc.b	$00,$FF,$68,$AA,$00,$FF,$4D,$38,$00,$FF,$69,$16,$00,$FF,$69,$24	; ..h...M8..i...i$
	dc.b	$00,$FF,$69,$32,$00,$FF,$69,$3C,$00,$FF,$69,$48,$00,$FF,$4A,$92	; ..i2..i<..iH..J.
	dc.b	$00,$FF,$69,$54,$00,$FF,$69,$60,$00,$FF,$69,$88,$00,$FF,$69,$7C	; ..iT..i`..i...i|
	dc.b	$00,$FF,$69,$94,$00,$FF,$69,$A0,$00,$FF,$69,$AC,$00,$FF,$4C,$AC	; ..i...i...i...L.
	dc.b	$00,$FF,$4D,$8E,$00,$FF,$69,$B8,$00,$FF,$69,$E4,$00,$FF,$50,$0C	; ..M...i...i...P.
	dc.b	$00,$FF,$6C,$86,$00,$FF,$68,$8A,$3F,$00,$10,$39,$00,$C0,$00,$08	; ..l...h.?..9....
	dc.b	$0C,$00,$00,$64,$64,$0A,$33,$FC,$00,$00,$00,$FF,$6C,$F8,$60,$08	; ...dd.3.....l.`.
	dc.b	$4A,$79,$00,$FF,$6C,$F8,$67,$04,$30,$1F,$4E,$73,$33,$FC,$00,$01	; Jy..l.g.0.Ns3...
	dc.b	$00,$FF,$6C,$F8,$30,$3C,$00,$01,$61,$00,$3E,$0E,$30,$1F,$4E,$73	; ..l.0<..a.>.0.Ns
	dc.b	$08,$F9,$00,$00,$00,$A1,$20,$00,$4E,$73	; ...... .Ns
DispatchTailSub5	movem.l	d0-d1/a0-a1,-(sp)
	bset.b	#$5,$A1200E.l
	bset.b	#$0,$A12000.l
	move.w	#$1,$FF6CFA.l
	move.l	#$32,d0
.l3880	btst.b	#$2,$A1200F.l
	bne.b	.l38AE
	dbra	d0,.l3880
	bclr.b	#$5,$A1200E.l
	move.l	#$19,d0
.l389C	btst.b	#$2,$A1200F.l
	bne.b	.l38AE
	dbra	d0,.l389C
	bra.w	.l390A
.l38AE	btst.b	#$4,$A1200F.l
	bne.b	.l38AE
	btst.b	#$3,$A1200F.l
	beq.b	.l38AE
	bset.b	#$4,$A1200E.l
	move.w	$A12026.l,d0
	lsl.w	#$2,d0
	lea.l	$FF471C.l,a1
	movea.l	-$4(a1,d0.w),a0
	jsr	(a0)
	bset.b	#$3,$A1200E.l
.l38E6	btst.b	#$3,$A1200F.l
	bne.b	.l38E6
	bclr.b	#$3,$A1200E.l
	bclr.b	#$4,$A1200E.l
	tst.w	$FF6CFA.l
	bne.w	.l38AE
.l390A	bclr.b	#$5,$A1200E.l
	movem.l	(sp)+,d0-d1/a0-a1
	rte
; Two-phase flag handshake with the sub CPU.
SubCommHandshake	btst.b	#$7,$A1200F.l
	bne.b	SubCommHandshake
.l3922	btst.b	#$6,$A1200F.l
	bne.b	.l3922
	bset.b	#$6,$A1200E.l
.l3934	btst.b	#$6,$A1200F.l
	beq.b	.l3934
	bset.b	#$7,$A1200E.l
	bclr.b	#$6,$A1200E.l
.l394E	btst.b	#$6,$A1200F.l
	bne.b	.l394E
	bclr.b	#$7,$A1200E.l
	rts
; Spins while the word-RAM mode bit is 1M.
WaitWordRamMode2M	btst.b	#$2,$A12003.l
	bne.b	WaitWordRamMode2M
	rts
	move.l	d0,-(sp)
	move.w	#$4000,$C00004.l
	move.w	#$0,$C00004.l
	move.l	#$8000,d0
.l3986	move.w	#$0,$C00000.l
	dbra	d0,.l3986
	move.l	(sp)+,d0
	rts
; Spins while the word-RAM DMNA bit is set.
WaitDmnaClear	btst.b	#$1,$A12003.l
	bne.b	WaitDmnaClear
	rts
; Sets DMNA and waits until the sub CPU has taken word RAM.
GiveWordRamToSub	bset.b	#$1,$A12003.l
.l39AA	btst.b	#$0,$A12003.l
	bne.b	.l39AA
	rts
; Sets the VDP command for a VRAM write at d0.
VdpSetVramWriteAddr	movem.w	d0,-(sp)
	andi.w	#$3FFF,d0
	ori.w	#$4000,d0
	move.w	d0,$C00004.l
	movem.w	(sp)+,d0
	rol.w	#$2,d0
	andi.w	#$3,d0
	move.w	d0,$C00004.l
	rts
DispatchTailSub8	movem.l	d0-d1/a0,-(sp)
	bsr.w	GiveWordRamToSub
	bsr.w	WaitDmnaClear
	bsr.w	ReadSubCommWord
	move.w	d0,d1
	bsr.w	ReadSubCommWord
	bsr.w	VdpSetVramWriteAddr
	lea.l	$200000.l,a0
.l39FA	move.w	(a0)+,$C00000.l
	dbra	d1,.l39FA
	movem.l	(sp)+,d0-d1/a0
	rts
; Sets the VDP command for a CRAM write at d0.
VdpSetCramWriteAddr	movem.w	d0,-(sp)
	andi.w	#$3FFF,d0
	ori.w	#$C000,d0
	move.w	d0,$C00004.l
	movem.w	(sp)+,d0
	rol.w	#$2,d0
	andi.w	#$3,d0
	move.w	d0,$C00004.l
	rts
	bsr.w	GiveWordRamToSub
	bsr.w	WaitDmnaClear
	bsr.w	ReadSubCommWord
	move.w	d0,d1
	bsr.w	ReadSubCommWord
	bsr.w	VdpSetCramWriteAddr
	lea.l	$200000.l,a0
.l3A4A	move.w	(a0)+,$C00000.l
	dbra	d1,.l3A4A
	rts
	move.w	$A12022.l,d0
	move.w	#$0,$A12010.l
	dc.w	$0139,$00A1,$1100
	bne.w	.l3A76
	move.w	#$4,$A12010.l
.l3A76	rts
	movea.l	$A12022.l,a0
	clr.b	(a0)
	rts
	movea.l	$A12022.l,a0
	clr.w	(a0)
	rts
	bsr.w	GiveWordRamToSub
	rts
	bsr.w	WaitDmnaClear
	move.w	$23BC88.l,$C00004.l
	move.w	$23BC8A.l,$C00004.l
	move.w	$23BC8C.l,$C00004.l
	move.w	$23BC8E.l,$C00004.l
	move.w	$23BC90.l,$C00004.l
	move.w	$23BC92.l,$C00004.l
	move.w	$23BC94.l,$C00004.l
	lea.l	$C00004.l,a1
	move.l	$23BC9E.l,$FF6CE8.l
	move.w	$FF6CEA.l,(a1)
	move.w	$FF6CE8.l,(a1)
.l3AF8	move.w	$C00004.l,-(sp)
	btst.b	#$1,$1(sp)
	addq.w	#$2,sp
	bne.w	.l3AF8
	move.w	#$8164,$C00004.l
	lea.l	$C00000.l,a1
	move.l	$23BC9A.l,d4
	asl.l	#$2,d4
	lsr.w	#$2,d4
	ori.w	#$4000,d4
	swap	d4
	andi.w	#$3,d4
	move.l	d4,$4(a1)
	move.l	$23BC96.l,(a1)
	bsr.w	GiveWordRamToSub
	rts
