; Start of a RAM-resident code image (bra over its header)
RamImageB	dc.b	$60,$00,$00,$8E	; `...
; Zero padding of image B
RamImageBPad	dcb.b	$8C,0
; Installs the image B DMA callbacks
DmaInstallB	lea.l	DmaCallbackB(pc),a0
	move.l	$4(sp),(a0)
	lea.l	.next(pc),a0
	move.l	$FFFFFD08.w,(a0)
	lea.l	DmaServiceB(pc),a0
	move.w	sr,d0
	ori.w	#$2700,sr
	move.l	a0,$FFFFFD08.w
	move.w	d0,sr
	jsr	MAINCODE(pc)
.loop	move.w	DmaBusyFlagB(pc),d0
	bne.b	.loop
	movea.l	DmaInstallB+$3C(pc),a0
	move.w	sr,d0
	ori.w	#$2700,sr
	move.l	a0,$FFFFFD08.w
	move.w	d0,sr
	rts
; 4 zero bytes after DmaInstallB (padding or space the program fills at run time).
.next	dc.b	$00,$00,$00,$00	; ....
; DMA callback pointer, image B
DmaCallbackB	dc.b	$00,$00,$00,$00	; ....
; Image B: VDP register setup
VdpInitB	movea.l	#$C00000,a0
	move.w	#$8F02,$4(a0)
	moveq	#$0,d0
	lsl.l	#$2,d0
	lsr.w	#$2,d0
	bset	#$E,d0
	swap	d0
	move.l	d0,$4(a0)
	moveq	#$0,d0
	move.l	#$3FFF,d1
.loop	move.l	d0,(a0)
	dbra	d1,.loop
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
	bsr.b	.next
	move.w	#$8238,$4(a0)
	move.w	#$857C,$4(a0)
	move.w	#$8D3F,$4(a0)
	rts
.next	move.w	#$8F02,$4(a0)
	moveq	#$0,d0
	lsl.l	#$2,d0
	lsr.w	#$2,d0
	bset	#$E,d0
	swap	d0
	move.l	d0,$4(a0)
	moveq	#$0,d1
	move.w	#$FF,d0
.loop2	move.l	d1,(a0)
	dbra	d0,.loop2
	lea.l	FontGlyphDataB(pc),a1
	move.w	#$2FF,d3
.loop3	move.b	(a1)+,d0
	moveq	#$7,d2
.loop4	lsl.l	#$4,d1
	add.b	d0,d0
	bcs.b	.next2
	ori.b	#$2,d1
	dbra	d2,.loop4
	bra.b	.next3
.next2	ori.b	#$1,d1
	dbra	d2,.loop4
.next3	move.l	d1,(a0)
	dbra	d3,.loop3
	rts
; Image B: DMA service routine
DmaServiceB	movem.l	d0-d7/a0-a5,-(sp)
	movea.l	#$A12000,a0
	bset.b	#$0,(a0)
	lea.l	DmaBusyFlagB(pc),a2
	tst.w	(a2)
	beq.w	.next3
	movea.l	#$C00000,a0
	lea.l	DmaRegBufB(pc),a1
	move.l	#$C0000000,$4(a0)
	move.w	DmaPhaseB(pc),d0
.loop	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	dbra	d0,.loop
	clr.w	(a2)
	move.l	DmaDestB(pc),d3
	lea.l	DmaListB(pc),a2
	move.l	DmaDestB+$4(pc),d2
	move.l	DmaLenB(pc),d7
	subq.w	#$1,d7
	move.l	DmaSrcB(pc),d6
	moveq	#$7,d0
	and.w	d6,d0
	bne.b	.next
	lsr.w	#$3,d6
	subq.w	#$1,d6
.loop2	move.w	d6,d5
	move.l	d3,d0
	add.l	d2,d3
	lsl.l	#$2,d0
	lsr.w	#$2,d0
	bset	#$E,d0
	swap	d0
	move.l	d0,$4(a0)
.loop3	move.l	(a2)+,(a0)
	move.l	(a2)+,(a0)
	move.l	(a2)+,(a0)
	move.l	(a2)+,(a0)
	dbra	d5,.loop3
	dbra	d7,.loop2
	bra.b	.next2
.next	subq.w	#$1,d6
.loop4	move.w	d6,d5
	move.l	d3,d0
	add.l	d2,d3
	lsl.l	#$2,d0
	lsr.w	#$2,d0
	bset	#$E,d0
	swap	d0
	move.l	d0,$4(a0)
.loop5	move.w	(a2)+,(a0)
	dbra	d5,.loop5
	dbra	d7,.loop4
.next2	lea.l	DmaModeB(pc),a2
	eori.w	#$1,(a2)
.next3	lea.l	RamImageBPad(pc),a0
	addq.l	#$1,(a0)
	move.l	DmaCallbackB(pc),d0
	beq.b	.next4
	movea.l	d0,a0
	jsr	(a0)
.next4	movem.l	(sp)+,d0-d7/a0-a5
	rte
; DMA busy flag, image B
DmaBusyFlagB	dc.b	$00,$00	; ..
; DMA mode word, image B
DmaModeB	dc.b	$00,$00	; ..
; DMA phase, image B
DmaPhaseB	dc.b	$00,$00,$00,$00	; ....
; DMA register buffer, image B
DmaRegBufB	dcb.b	$80,0
; DMA destination, image B
DmaDestB	dc.b	$00,$00,$E0,$00	; ....
; Table of 4 bytes after DmaDestB, 4 bytes: $00,$00,$00,$80 ...
.next	dc.b	$00,$00,$00,$80	; ....
; DMA source, image B
DmaSrcB	dc.b	$00,$00,$00,$00	; ....
; DMA length, image B
DmaLenB	dc.b	$00,$00,$00,$10	; ....
; DMA list and work area, image B
DmaListB	dcb.b	$5EC,0
; 1044 zero bytes after DmaListB (padding or space the program fills at run time).
.next	dcb.b	$414,0
; Second copy of DrawTextToPlane.
DrawTextToPlane_B	link	a6,#$0
	movem.l	d0-d7/a0-a5,-(sp)
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
.loop	move.b	(a1)+,d0
	beq.b	.next
	move.w	d0,(a0)
	bra.b	.loop
.next	movem.l	(sp)+,d0-d7/a0-a5
	unlk	a6
	movea.l	(sp)+,a0
	lea.l	$C(sp),sp
	jmp	(a0)
.loop2	move.w	DmaBusyFlagB(pc),d0
	bne.b	.loop2
	movea.l	#$C00000,a0
	move.l	#$E000,d0
	lsl.l	#$2,d0
	lsr.w	#$2,d0
	bset	#$E,d0
	swap	d0
	move.l	d0,$4(a0)
	moveq	#$0,d0
	move.w	#$3FF,d1
.loop3	move.l	d0,(a0)
	dbra	d1,.loop3
	lea.l	DmaModeB(pc),a0
	move.w	#$1,(a0)
	lea.l	DmaRegBufB(pc),a0
	move.l	#$EEE,(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	lea.l	DmaBusyFlagB(pc),a0
	move.w	#$1,(a0)
.loop4	move.w	(a0),d0
	bne.b	.loop4
	moveq	#$0,d0
	rts
; Second copy of DrawTextBuffer.
DrawTextBuffer_B	link	a6,#$0
; Waits for DMA idle, then starts a transfer
DmaWaitStartB	movem.l	d0-d7/a0-a5,-(sp)
	lea.l	DmaBusyFlagB(pc),a2
.loop	tst.w	(a2)
	bne.b	.loop
	movea.l	#$C00000,a0
	movea.l	$10(a6),a4
	lea.l	DmaDestB(pc),a1
	move.l	$C(a6),(a1)
; Parses a transfer header (magic SM)
SmHeaderParseB	movea.l	$14(a6),a1
	cmpi.w	#$534D,(a1)
	bne.w	DmaFinishB
	move.w	$8(a1),d6
	move.w	$A(a1),d7
	suba.l	a5,a5
	move.w	DmaModeB(pc),d1
	bne.b	DmaSetupFromHeaderB
	moveq	#$0,d0
	move.w	d6,d0
	mulu.w	d7,d0
; Advances the transfer pointers
DmaAdvancePtrsB	adda.l	d0,a5
	lsl.l	#$5,d0
	adda.l	d0,a4
; Sets up DMA from the header fields
DmaSetupFromHeaderB	move.w	$2(a1),d1
	andi.w	#$3,d1
	lea.l	DmaPhaseB(pc),a2
	move.w	d1,(a2)
	move.w	d1,d0
	lea.l	$C(a1),a1
	lea.l	DmaRegBufB(pc),a2
.loop	move.l	(a1)+,(a2)+
	clr.w	-$4(a2)
	move.l	(a1)+,(a2)+
	move.l	(a1)+,(a2)+
	move.l	(a1)+,(a2)+
	move.l	(a1)+,(a2)+
	move.l	(a1)+,(a2)+
	move.l	(a1)+,(a2)+
	move.l	(a1)+,(a2)+
	dbra	d0,.loop
	lea.l	DmaSrcB(pc),a3
	move.l	d6,(a3)
	lea.l	DmaLenB(pc),a3
	move.l	d7,(a3)
	lea.l	DmaListB(pc),a3
	move.l	d7,-(sp)
	move.l	$10(a6),d3
	lsr.l	#$5,d3
	add.w	a5,d3
	move.l	$8(a6),d0
	beq.b	.next
	bset	#$F,d3
.next	moveq	#$1,d2
	move.w	d7,d5
	bra.b	.next4
.loop2	move.w	d6,d4
	bra.b	.next3
.loop3	subq.w	#$1,d2
	bne.b	.next2
	move.l	(a1)+,d7
	moveq	#$11,d1
	ror.l	d1,d7
	moveq	#$10,d2
.next2	move.w	d7,d1
	rol.l	#$2,d7
	andi.w	#$6000,d1
	add.w	d3,d1
	addq.w	#$1,d3
	move.w	d1,(a3)+
.next3	dbra	d4,.loop3
.next4	dbra	d5,.loop2
	move.l	(sp)+,d7
	moveq	#$0,d2
	move.w	d6,d2
	mulu.w	d7,d2
	lsl.l	#$4,d2
	move.l	a4,d0
	bsr.b	VdpDmaSetup
	bra.b	DmaFinishB
	move.l	a4,d0
	lsl.l	#$2,d0
	lsr.w	#$2,d0
	bset	#$E,d0
	swap	d0
	move.l	d0,$4(a0)
	bra.b	.next6
.loop4	move.w	d6,d4
	bra.b	.next5
.loop5	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
	move.l	(a1)+,(a0)
.next5	dbra	d4,.loop5
.next6	dbra	d7,.loop4
; Finishes the transfer and restores registers
DmaFinishB	lea.l	DmaBusyFlagB(pc),a2
	move.w	#$1,(a2)
	movem.l	(sp)+,d0-d7/a0-a5
	unlk	a6
	movea.l	(sp)+,a0
	lea.l	$10(sp),sp
	jmp	(a0)
; Writes the VDP DMA length and source registers ($93-$97) for a transfer from a1, size d2.
VdpDmaSetup	move.l	a1,d1
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
	rts
; 1bpp font glyph data, image B
FontGlyphDataB	dcb.b	$8,0
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