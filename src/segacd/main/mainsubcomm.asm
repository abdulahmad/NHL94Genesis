; Loads two long stack arguments into d1/d0
LoadLongArgs	move.l	$4(sp),d1
	move.l	$8(sp),d0
; Jump thunk through a computed address (number string)
NumStrThunkA	lea.l	.next(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE		; jmp -$2(a0,a1.w): enters the code that follows
.next	dc.w	$6006		; bra.b $8
	dc.w	$4C41,$0801		; divs.l d1,d0
	dc.w	$4E75		; rts 
	dc.w	$4EBA,$0024		; jsr $2e(pc)
	dc.w	$2001		; move.l d1, d0
	dc.w	$4E75		; rts 
	dc.w	$222F,$0004		; move.l $4(a7), d1
	dc.w	$202F,$0008		; move.l $8(a7), d0
; Jump thunk through a computed address (number string)
NumStrThunkB	lea.l	.next(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE		; jmp -$2(a0,a1.w): enters the code that follows
.next	dc.w	$6008		; bra.b $a
	dc.w	$4C41,$0801		; divs.l d1,d0
	dc.w	$C340		; exg.l d1, d0
	dc.w	$4E75		; rts 
	dc.w	$4A80		; tst.l d0
	dc.w	$6B14		; bmi.b $22
	dc.w	$4A81		; tst.l d1
	dc.w	$6B06		; bmi.b $18
	dc.w	$4EBA,$0046		; jsr $5a(pc)
	dc.w	$4E75		; rts 
	dc.w	$4481		; neg.l d1
	dc.w	$4EBA,$003E		; jsr $5a(pc)
	dc.w	$4481		; neg.l d1
	dc.w	$4E75		; rts 
	dc.w	$4480		; neg.l d0
	dc.w	$4A81		; tst.l d1
	dc.w	$6B0A		; bmi.b $32
	dc.w	$4EBA,$0030		; jsr $5a(pc)
	dc.w	$4480		; neg.l d0
	dc.w	$4481		; neg.l d1
	dc.w	$4E75		; rts 
	dc.w	$4481		; neg.l d1
	dc.w	$4EBA,$0024		; jsr $5a(pc)
	dc.w	$4480		; neg.l d0
	dc.w	$4E75		; rts 
	dc.w	$222F,$0004		; move.l $4(a7), d1
	dc.w	$202F,$0008		; move.l $8(a7), d0
	dc.w	$41FA,$000A		; lea.l $50(pc), a0
	dc.w	$327C,$0002		; movea.w #$2, a1
	dc.w	$4EF0,$92FE		; jmp -$2(a0, a1.w)
	dc.w	$6008		; bra.b $5a
	dc.w	$4C41,$0001		; divu.l d1,d0
	dc.w	$C340		; exg.l d1, d0
	dc.w	$4E75		; rts 
	dc.w	$3F01		; move.w d1, -(a7)
	dc.w	$4841		; swap d1
	dc.w	$4A41		; tst.w d1
	dc.w	$661C		; bne.b $7e
	dc.w	$2200		; move.l d0, d1
	dc.w	$4241		; clr.w d1
	dc.w	$4841		; swap d1
	dc.w	$670A		; beq.b $74
	dc.w	$82D7		; divu.w (a7), d1
	dc.w	$4841		; swap d1
	dc.w	$4840		; swap d0
	dc.w	$3001		; move.w d1, d0
	dc.w	$4840		; swap d0
	dc.w	$80DF		; divu.w (a7)+, d0
	dc.w	$3200		; move.w d0, d1
	dc.w	$4240		; clr.w d0
	dc.w	$4840		; swap d0
	dc.w	$4E75		; rts 
	dc.w	$4841		; swap d1
	dc.w	$3E82		; move.w d2, (a7)
	dc.w	$2F03		; move.l d3, -(a7)
	dc.w	$3400		; move.w d0, d2
	dc.w	$2601		; move.l d1, d3
	dc.w	$7201		; moveq #$1, d1
	dc.w	$4240		; clr.w d0
	dc.w	$4840		; swap d0
	dc.w	$660C		; bne.b $9c
	dc.w	$4840		; swap d0
	dc.w	$3002		; move.w d2, d0
	dc.w	$7200		; moveq #$0, d1
	dc.w	$6016		; bra.b $ae
	dc.w	$D241		; add.w d1, d1
	dc.w	$6512		; bcs.b $ae
	dc.w	$D442		; add.w d2, d2
	dc.w	$D180		; addx.l d0, d0
	dc.w	$B083		; cmp.l d3, d0
	dc.w	$65F4		; bcs.b $98
	dc.w	$9083		; sub.l d3, d0
	dc.w	$D241		; add.w d1, d1
	dc.w	$08C1,$0000		; bset.b #$0, d1
	dc.w	$64EE		; bcc.b $9c
	dc.w	$261F		; move.l (a7)+, d3
	dc.w	$341F		; move.w (a7)+, d2
	dc.w	$4E75		; rts 
	dc.w	$0000,$0000		; ori.b #$0, d0
; Resets the stack and the sub-CPU communication words
SubCpuBootReset	movea.l	#$FFFC00,sp
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
	bra.w	WaitSubCpuReady
; Waits for the sub-CPU handshake bits
WaitSubCpuReady	btst.b	#$7,$A1200F.l
	bne.b	WaitSubCpuReady
	btst.b	#$6,$A1200F.l
	beq.b	WaitSubCpuReady
	bset.b	#$7,$A1200E.l
	move.w	$A12020.l,d0
	lsl.w	#$2,d0
	lea.l	$FF471C.l,a1
	movea.l	-$4(a1,d0.w),a0
	jsr	(a0)
	bset.b	#$6,$A1200E.l
.loop	btst.b	#$6,$A1200F.l
	bne.b	.loop
	bclr.b	#$6,$A1200E.l
	bclr.b	#$7,$A1200E.l
	bra.w	WaitSubCpuReady
; Handshakes with the sub CPU on $A1200E/F and reads the comm word $A12020.
ReadSubCommWord	btst.b	#$7,$A1200F.l
	bne.b	ReadSubCommWord
	btst.b	#$6,$A1200F.l
	beq.b	ReadSubCommWord
	bset.b	#$7,$A1200E.l
	move.w	$A12020.l,d0
	bset.b	#$6,$A1200E.l
.loop	btst.b	#$6,$A1200F.l
	bne.b	.loop
	bclr.b	#$6,$A1200E.l
	bclr.b	#$7,$A1200E.l
	rts
.loop2	btst.b	#$7,$A1200F.l
	bne.b	.loop2
	move.w	d0,$A12010.l
	bset.b	#$6,$A1200E.l
.loop3	btst.b	#$6,$A1200F.l
	beq.b	.loop3
	bset.b	#$7,$A1200E.l
	bclr.b	#$6,$A1200E.l
.loop4	btst.b	#$6,$A1200F.l
	bne.b	.loop4
	bclr.b	#$7,$A1200E.l
	rts
; Calls the handler selected by the sub-CPU command word
SubCommDispatch	movem.l	d0-d7/a0-a6,-(sp)
	lsl.w	#$2,d0
	lea.l	$FF471C.l,a1
	movea.l	-$4(a1,d0.w),a0
	jsr	(a0)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Data of SubCommDispatch (21 rows): table or constants used by it.
	dc.b	$00,$FF,$49,$6E,$00,$FF,$49,$DA,$00,$FF,$4A,$2E,$00,$FF,$4A,$56	; ..In..I...J...JV
	dc.b	$00,$FF,$4A,$78,$00,$FF,$4A,$82,$00,$FF,$4A,$8C,$00,$FF,$4A,$92	; ..Jx..J...J...J.
	dc.b	$00,$FF,$4B,$3C,$00,$FF,$4B,$48,$00,$FF,$4B,$54,$00,$FF,$4B,$60	; ..K<..KH..KT..K`
	dc.b	$00,$FF,$4B,$6C,$00,$FF,$4B,$78,$00,$FF,$4B,$84,$00,$FF,$4B,$90	; ..Kl..Kx..K...K.
	dc.b	$00,$FF,$4B,$9C,$00,$FF,$4B,$A8,$00,$FF,$4B,$B4,$00,$FF,$4B,$C0	; ..K...K...K...K.
	dc.b	$00,$FF,$4B,$CC,$00,$FF,$4B,$D8,$00,$FF,$4C,$14,$00,$FF,$4C,$22	; ..K...K...L...L"
	dc.b	$00,$FF,$4C,$30,$00,$FF,$4B,$F0,$00,$FF,$4B,$FC,$00,$FF,$4C,$08	; ..L0..K...K...L.
	dc.b	$00,$FF,$4C,$3E,$00,$FF,$4C,$AC,$00,$FF,$4D,$8E	; ..L>..L...M.
	dc.l	DmaWaitStartB,SmHeaderParseB,DmaAdvancePtrsB
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
; Acknowledges a sub-CPU command
SubCommAck	movem.l	d0-d1/a0-a1,-(sp)
	bset.b	#$5,$A1200E.l
	bset.b	#$0,$A12000.l
	move.w	#$1,$FF6CFA.l
	move.l	#$32,d0
.loop	btst.b	#$2,$A1200F.l
	bne.b	.loop3
	dbra	d0,.loop
	bclr.b	#$5,$A1200E.l
	move.l	#$19,d0
.loop2	btst.b	#$2,$A1200F.l
	bne.b	.loop3
	dbra	d0,.loop2
	bra.w	.next
.loop3	btst.b	#$4,$A1200F.l
	bne.b	.loop3
	btst.b	#$3,$A1200F.l
	beq.b	.loop3
	bset.b	#$4,$A1200E.l
	move.w	$A12026.l,d0
	lsl.w	#$2,d0
	lea.l	$FF471C.l,a1
	movea.l	-$4(a1,d0.w),a0
	jsr	(a0)
	bset.b	#$3,$A1200E.l
.loop4	btst.b	#$3,$A1200F.l
	bne.b	.loop4
	bclr.b	#$3,$A1200E.l
	bclr.b	#$4,$A1200E.l
	tst.w	$FF6CFA.l
	bne.w	.loop3
.next	bclr.b	#$5,$A1200E.l
	movem.l	(sp)+,d0-d1/a0-a1
	rte
; Two-phase flag handshake with the sub CPU.
SubCommHandshake	btst.b	#$7,$A1200F.l
	bne.b	SubCommHandshake
.loop	btst.b	#$6,$A1200F.l
	bne.b	.loop
	bset.b	#$6,$A1200E.l
.loop2	btst.b	#$6,$A1200F.l
	beq.b	.loop2
	bset.b	#$7,$A1200E.l
	bclr.b	#$6,$A1200E.l
.loop3	btst.b	#$6,$A1200F.l
	bne.b	.loop3
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
.loop	move.w	#$0,$C00000.l
	dbra	d0,.loop
	move.l	(sp)+,d0
	rts
; Spins while the word-RAM DMNA bit is set.
WaitDmnaClear	btst.b	#$1,$A12003.l
	bne.b	WaitDmnaClear
	rts
; Sets DMNA and waits until the sub CPU has taken word RAM.
GiveWordRamToSub	bset.b	#$1,$A12003.l
.loop	btst.b	#$0,$A12003.l
	bne.b	.loop
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
; Sub-CPU command: copy from word RAM
SubCmdVramCopy	movem.l	d0-d1/a0,-(sp)
	bsr.w	GiveWordRamToSub
	bsr.w	WaitDmnaClear
	bsr.w	ReadSubCommWord
	move.w	d0,d1
	bsr.w	ReadSubCommWord
	bsr.w	VdpSetVramWriteAddr
	lea.l	$200000.l,a0
.loop	move.w	(a0)+,$C00000.l
	dbra	d1,.loop
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
.loop	move.w	(a0)+,$C00000.l
	dbra	d1,.loop
	rts
	move.w	$A12022.l,d0
	move.w	#$0,$A12010.l
; Instruction bytes inside VdpSetCramWriteAddr that the assembler would encode differently, kept as words (1 row).
	dc.w	$0139,$00A1,$1100
	bne.w	.ex
	move.w	#$4,$A12010.l
.ex	rts
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
.loop2	move.w	$C00004.l,-(sp)
	btst.b	#$1,$1(sp)
	addq.w	#$2,sp
	bne.w	.loop2
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
