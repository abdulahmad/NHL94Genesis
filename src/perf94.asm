;	On-screen performance overlay (PERF=1). Included after the 1MB pad in nhl94.asm so
;	retail ROM addresses are unchanged (docs/EXPANDING_THE_ROM.md). Call from hooks with
;	jsr (Perf…).l only.

	IF PERF=0
	ELSE

perf_lag		equ	PALflag+2
perf_hv_start	equ	PALflag+4
perf_hv_end	equ	PALflag+6
perf_vb_start	equ	PALflag+8
perf_vb_end	equ	PALflag+10
perf_frame_sl	equ	PALflag+12
perf_max_sl	equ	PALflag+14
perf_vblank_sl	equ	PALflag+16
perf_max_vb_sl	equ	PALflag+18
perf_sprite_w	equ	PALflag+20
perf_dma_cnt	equ	PALflag+22
perf_stack_hw	equ	PALflag+24
perf_fps		equ	PALflag+26
perf_fps_acc	equ	PALflag+28
perf_fps_lastvc	equ	PALflag+30
perf_inited	equ	PALflag+32		;magic $9454 once line buffers are valid
perf_line1		equ	PALflag+34
perf_line2		equ	PALflag+68
perf_line3		equ	PALflag+102
perf_active	equ	PALflag+136		;nonzero only while the overlay is allowed to draw
perf_warmup	equ	PALflag+138		;frames to skip after PerfReset (faceoff fade)

PerfDeactivate
PerfReset
	clr.w	(perf_active).w
	clr.w	(perf_warmup).w
	move.w	#VDPR_WINX,(Vctrl).l		;window off (same as setVram)
	move.w	#VDPR_WINY,(Vctrl).l
	rts
PerfActivate
	move.w	#1,(perf_active).w
	rts

;	fixopcodes rewrites SNASM cmp #imm,Dn (0C40 and friends) to EA's CMP encoding.
;	It stops at the Hockey.snd incbin, and this file is included after that, so these
;	compares are not rewritten. Still use cmp.w Dn,Dn here, not cmpi.w #imm,Dn.

;	The rink scrolls on maps 1 and 2. print was painting the stat lines onto those
;	maps, so the cells showed up as garbage and moved with the camera. The lines go
;	on map 3, and the window is opened over the top 4 rows so they stay on screen.

;	Plain text in the line buffers (28 bytes). Drawn on the window plane, top rows only.
p1_cpu	equ	perf_line1+3
p1_sl	equ	perf_line1+10
p1_tot	equ	perf_line1+14
p1_max	equ	perf_line1+21
p2_fps	equ	perf_line2+3
p2_sp	equ	perf_line2+10
p2_dm	equ	perf_line2+18
p2_lag	equ	perf_line2+26
p3_vb	equ	perf_line3+2
p3_stk	equ	perf_line3+13

PerfTpl1	dc.b	'CPU000% SL000/262 MAX000    '
PerfTpl2	dc.b	'FPS00  SP:000w DM:00  LAG:0 '
PerfTpl3	dc.b	'VB000sl  STK:0000           '
	even

PerfOnFrame
	tst.w	(perf_active).w
	bne.s	.arm
	move.w	(perf_warmup).w,d0
	addq.w	#1,d0
	move.w	d0,(perf_warmup).w
	move.w	#90,d1				;~1.5s: faceoff fade is palcount $18, then forced to $FFFF
	cmp.w	d1,d0
	bcs.w	PerfExit
	move.w	#1,(perf_active).w
.arm	move.w	d7,-(sp)
	bsr.w	PerfMaybeDraw
	move.w	(sp)+,d7
	move.w	d7,(perf_lag).w
	move.w	(HVcount).l,(perf_hv_start).w
	move.l	sp,d0
	move.l	#$FFFFFFFE,d1			;Stack equ — movea.w #(Stack-M68K_RAM) sign-extends wrong
	sub.l	d0,d1
	lsr.l	#1,d1
	cmp.w	(perf_stack_hw).w,d1
	ble.s	.pfs
	move.w	d1,(perf_stack_hw).w
.pfs	addq.w	#1,(perf_fps_acc).w
	move.w	(Vcount).w,d0
	sub.w	(perf_fps_lastvc).w,d0
	move.w	#55,d1
	tst.w	(PalMode).w
	beq.s	.pf0
	move.w	#45,d1
.pf0	cmp.w	d1,d0
	blt.w	PerfExit
	move.w	(perf_fps_acc).w,(perf_fps).w
	clr.w	(perf_fps_acc).w
	move.w	(Vcount).w,(perf_fps_lastvc).w
	rts

PerfAfterVideo
	tst.w	(perf_active).w
	beq.w	PerfExit
	btst	#sfpz,(sflags).w
	bne.w	PerfExit
	move.w	(HVcount).l,(perf_hv_end).w
	bsr.w	PerfCalcMainSl
	move.w	(Sattsize).w,(perf_sprite_w).w
	movea.w	#(DMAList-M68K_RAM),a0
	move.l	(DMAlistend).w,d0
	sub.l	a0,d0
	lsr.l	#3,d0
	move.w	d0,(perf_dma_cnt).w
	bsr.w	PerfEnsureInit
	bsr.w	PerfFormatLines
	rts

PerfMaybeDraw
	tst.w	(perf_active).w
	beq.w	PerfExit
	btst	#dfok,(disflags).w		;frame already queued: vblank owns the VDP
	bne.w	PerfExit
	bsr.w	PerfEnsureInit
	bsr.w	PerfDrawLines
	rts

PerfVBlankStartIfActive
	tst.w	(perf_active).w
	beq.w	PerfExit
PerfVBlankStart
	move.w	(HVcount).l,(perf_vb_start).w
	rts
PerfVBlankEndIfActive
	tst.w	(perf_active).w
	beq.w	PerfExit
PerfVBlankEnd
	move.w	(HVcount).l,(perf_vb_end).w
	move.w	(perf_vb_start).w,d0
	move.w	(perf_vb_end).w,d1
	bsr.w	PerfVScanDelta
	move.w	d0,(perf_vblank_sl).w
	cmp.w	(perf_max_vb_sl).w,d0
	ble.w	PerfExit
	move.w	d0,(perf_max_vb_sl).w
	rts

PerfCalcMainSl
	move.w	(perf_hv_start).w,d0
	move.w	(perf_hv_end).w,d1
	bsr.w	PerfVScanDelta
	move.w	d0,(perf_frame_sl).w
	cmp.w	(perf_max_sl).w,d0
	ble.w	PerfExit
	move.w	d0,(perf_max_sl).w
	rts

PerfVScanDelta
	move.w	d0,d2
	move.w	d1,d3
	lsr.w	#8,d2
	lsr.w	#8,d3
	andi.w	#$FF,d2
	andi.w	#$FF,d3
	move.w	d3,d0
	sub.w	d2,d0
	bpl.w	PerfExit
	move.w	#262,d1
	tst.w	(PalMode).w
	beq.w	.pvs0
	move.w	#312,d1
.pvs0	sub.w	d2,d1
	add.w	d3,d1
	move.w	d1,d0
	rts

PerfEnsureInit
	move.w	(perf_inited).w,d0
	move.w	#$9454,d1
	cmp.w	d1,d0
	beq.w	PerfExit
	move.w	d1,(perf_inited).w
	move.w	(Vcount).w,(perf_fps_lastvc).w
	lea	(perf_line1).w,a0
	lea	PerfTpl1(pc),a1
	bsr.w	PerfLoadLine
	lea	(perf_line2).w,a0
	lea	PerfTpl2(pc),a1
	bsr.w	PerfLoadLine
	lea	(perf_line3).w,a0
	lea	PerfTpl3(pc),a1
	bsr.w	PerfLoadLine
	rts

PerfLoadLine
	moveq	#27,d0
.ld	move.b	(a1)+,(a0)+
	dbf	d0,.ld
	rts

PerfFormatLines
	movem.l	d0-d4/a0,-(sp)
	move.w	(perf_frame_sl).w,d0
	move.w	#262,d4
	tst.w	(PalMode).w
	beq.s	.pf1
	move.w	#312,d4
.pf1	mulu.w	#100,d0				;scanlines * 100 / frame length
	divu.w	d4,d0
	moveq	#3,d1
	movea.l	#p1_cpu,a0
	bsr.w	PerfPutDec
	move.w	(perf_frame_sl).w,d0
	movea.l	#p1_sl,a0
	bsr.w	PerfPutDec
	move.w	d4,d0
	movea.l	#p1_tot,a0
	bsr.w	PerfPutDec
	move.w	(perf_max_sl).w,d0
	movea.l	#p1_max,a0
	bsr.w	PerfPutDec
	move.w	(perf_fps).w,d0
	moveq	#2,d1
	movea.l	#p2_fps,a0
	bsr.w	PerfPutDec
	move.w	(perf_sprite_w).w,d0
	moveq	#3,d1
	movea.l	#p2_sp,a0
	bsr.w	PerfPutDec
	move.w	(perf_dma_cnt).w,d0
	moveq	#2,d1
	movea.l	#p2_dm,a0
	bsr.w	PerfPutDec
	move.w	(perf_lag).w,d0
	moveq	#1,d1
	movea.l	#p2_lag,a0
	bsr.w	PerfPutDec
	move.w	(perf_vblank_sl).w,d0
	moveq	#3,d1
	movea.l	#p3_vb,a0
	bsr.w	PerfPutDec
	move.w	(perf_stack_hw).w,d0
	moveq	#4,d1
	movea.l	#p3_stk,a0
	bsr.w	PerfPutDec
	movem.l	(sp)+,d0-d4/a0
	rts

PerfPutDec
;	a0 = left of field, d0 = value, d1 = width (writes right-aligned)
	movem.l	d0-d3/a0,-(sp)
	move.w	d1,d3
	add.w	d1,a0
	subq.w	#1,d3
	andi.l	#$FFFF,d0			;divu.w uses the full long; a dirty high word overflows
.pd0	divu.w	#$A,d0				;low = quotient, high = remainder
	swap	d0
	move.w	d0,d2
	clr.w	d0
	swap	d0				;quotient, high word clear
	addi.w	#$30,d2
	move.b	d2,-(a0)
	dbf	d3,.pd0
	movem.l	(sp)+,d0-d3/a0
	rts

PerfDrawLines
	bset	#dfng,(disflags).w
	move.w	#VDPR_WINX,(Vctrl).l
	move.w	#VDPR_WINY+4,(Vctrl).l		;top 4 rows are the window, not the rink
	moveq	#0,d1
	bsr.w	PerfBlankRow
	moveq	#1,d1
	bsr.w	PerfBlankRow
	moveq	#2,d1
	bsr.w	PerfBlankRow
	moveq	#3,d1
	bsr.w	PerfBlankRow
	moveq	#0,d1
	lea	(perf_line1).w,a1
	bsr.w	PerfDrawRow
	moveq	#1,d1
	lea	(perf_line2).w,a1
	bsr.w	PerfDrawRow
	moveq	#2,d1
	lea	(perf_line3).w,a1
	bsr.w	PerfDrawRow
	bclr	#dfng,(disflags).w
	rts

PerfBlankRow							;d1 = window row. Fill 32 cells with the blank tile
	bsr.w	PerfRowAddr
	moveq	#31,d0
	move.w	#$7FF,d3
.pb	move.w	d3,(a0)
	dbf	d0,.pb
	rts

PerfDrawRow							;a1 = 28 chars, d1 = window row
	bsr.w	PerfRowAddr
	moveq	#27,d4
.pc	moveq	#0,d0
	move.b	(a1)+,d0
	cmp.b	#$20,d0
	bls.s	.blk
	asl.w	#1,d0
	movea.l	#SmallFontMap,a2
	adda.l	jimdata(a2),a2
	move.w	mapwords(a2,d0.w),d0
	add.w	(smallfontchars).w,d0
	ori.w	#$8000,d0
	bra.s	.wr
.blk	move.w	#$7FF,d0
.wr	move.w	d0,(a0)
	dbf	d4,.pc
	rts

PerfRowAddr							;d1 = row → a0 = Vdata, VRAM write at that window row
	move.w	(VmMAP3).w,d0
	move.w	d1,d3
	asl.w	#5,d3					;map 3 is 32 cells wide
	asl.w	#1,d3
	add.w	d3,d0
	jsr	(Vmaddr).l
	rts

PerfExit
	rts

	ENDIF
