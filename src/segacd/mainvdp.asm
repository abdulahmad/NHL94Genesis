; MAIN.BIN $12C0-$183F (runtime $FF22C0-$FF283F). Emitted by tools/emit_m68k.py.
; VDP writes and word-RAM copies. Stops on the rts before the zero pad.

X_FF117E	equ	$FF117E
X_FF1418	equ	$FF1418
X_FF1172	equ	$FF1172
X_FF110A	equ	$FF110A
X_FF1130	equ	$FF1130
X_FF1F9E	equ	$FF1F9E
X_FF11A4	equ	$FF11A4
X_FF1F78	equ	$FF1F78
FillVram	equ	$FF20BE
X_FF177C	equ	$FF177C

	org	$FF22C0

	lea.l	$23A450.l,a1
	move.w	(a1),d2
	lea.l	$C00000.l,a0
	move.l	#$40020010,$4(a0)
	move.w	d2,(a0)
	rts
SubCmd13							;command $13 (CmdJumpTable): a word from $23A450 to VDP control
	move.w	$23A450.l,$C00004.l
	rts
SubCmd14							;command $14 (CmdJumpTable): VSRAM, VDP registers and the configured
									;tables cleared
	movea.l	#$C00000,a0
	move.l	#$40000010,$4(a0)
	move.l	#$0,(a0)
	move.w	#$8B00,$4(a0)
	move.w	#$921C,$4(a0)
	bclr.b	#$4,$23C6E8.l
	bsr.w	X_FF177C
	rts
SubCmd15							;command $15 (CmdJumpTable): two configured VRAM fills
	move.w	#$800,d0
	move.w	$FF2852.l,d1
	move.w	#$7FF,d2
	bsr.w	FillVram
	move.w	#$1000,d0
	move.w	$FF2856.l,d1
	move.w	#$7FF,d2
	bsr.w	FillVram
	rts
SubCmd16							;command $16 (CmdJumpTable): a word at $FF2A24 plus the next word, to
									;VSRAM address 2
	lea.l	$23A450.l,a1
	move.w	(a1)+,$FF2A24.l
	move.w	(a1)+,d0
	movea.l	#$C00000,a0
	move.l	#$40020010,$4(a0)
	add.w	$FF2A24.l,d0
	move.w	d0,(a0)
	rts
SubCmd19							;command $19 (CmdJumpTable): one word to VSRAM address 2
	move.w	$23A450.l,d0
	movea.l	#$C00000,a0
	move.l	#$40020010,$4(a0)
	move.w	d0,(a0)
	rts
SubCmd1A							;command $1A (CmdJumpTable): VDP registers, VSRAM and VRAM set up for the
									;film
	move.w	#$8164,$C00004.l
	move.w	#$8C00,$C00004.l
	move.w	#$8700,$C00004.l
	move.w	#$9001,$C00004.l
	move.w	#$8238,$C00004.l
	move.w	#$8407,$C00004.l
	move.w	#$8578,$C00004.l
	move.w	#$8D3D,$C00004.l
	move.w	#$831C,$C00004.l
	move.w	#$9100,$C00004.l
	move.w	#$9200,$C00004.l
	move.w	#$8F02,$C00004.l
	move.w	#$8B00,$C00004.l
	move.l	#$74000003,$C00004.l
	move.w	#$0,$C00000.l
	move.w	#$0,$C00000.l
	move.l	#$40000010,$C00004.l
	move.w	#$0,$C00000.l
	move.w	#$0,$C00000.l
	move.l	#$70000003,$C00004.l
	move.l	#$0,$C00000.l
	rts
SubCmd1B							;command $1B (CmdJumpTable): the film: handshake, the C code at $FF2E00,
									;the shell put back
	move.w	sr,-(sp)
	move.w	#$2700,sr
	bset.b	#$0,$A12014.l
LFF2438	btst.b	#$1,$A12024.l
	beq.b	LFF2438
	bsr.w	X_FF1F78
	bsr.w	X_FF11A4
	bsr.w	X_FF1F9E
	move.w	(sp)+,sr
	move.w	#$8004,$C00004.l
	bsr.w	X_FF1130
	lea.l	$FF2E00.l,a0
	move.l	#$FF283A,-(sp)
	jsr	(a0)
	addq.l	#$4,sp
	move.l	#$FF24E4,$FFFFFD08.w
	bsr.w	X_FF1130
	bsr.w	X_FF110A
	bsr.w	X_FF1172
	bsr.w	X_FF11A4
	move.w	#$8164,$C00004.l
	addq.l	#$8,sp
	jmp	$FF103A.l
SubCmd1C							;command $1C (CmdJumpTable): VDP registers $9100, $9213, $8B03
	movea.l	#$C00000,a0
	move.w	#$9100,$4(a0)
	move.w	#$9213,$4(a0)
	move.w	#$8B03,$4(a0)
	rts
SubCmd1D							;command $1D (CmdJumpTable): a word at $FF2A24, to VSRAM address 0 (the
									;credits scroll)
	lea.l	$23A450.l,a0
	move.w	(a0),$FF2A24.l
	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	movea.l	#$C00000,a0
	move.l	#$40000010,$4(a0)
	move.w	$FF2A24.l,(a0)
	move.w	(sp)+,$23C6E8.l
	rts
	movem.l	d0-d7/a0-a6,-(sp)
	bset.b	#$0,$A12000.l
	btst.b	#$2,$A12024.l
	beq.w	LFF2578
	bsr.w	LFF279A
	btst.b	#$4,$23C6E8.l
	bne.w	LFF2570
	bsr.w	LFF269A
	btst.b	#$2,$23C6E8.l
	bne.w	LFF2538
	bclr.b	#$1,$23C6E8.l
	bne.w	LFF2550
	bclr.b	#$0,$23C6E8.l
	bne.w	LFF2560
	bra.w	LFF2570
LFF2538	bclr.b	#$0,$23C6E8.l
	bne.w	LFF2560
	bclr.b	#$1,$23C6E8.l
	beq.w	LFF2570
LFF2550	bsr.w	LFF27D0
	bset.b	#$2,$23C6E8.l
	bra.w	LFF2570
LFF2560	bsr.w	LFF257E
	bsr.w	LFF259E
	bclr.b	#$2,$23C6E8.l
LFF2570	bsr.w	LFF25C0
	bsr.w	LFF27BE
LFF2578	movem.l	(sp)+,d0-d7/a0-a6
	rte
LFF257E	bclr.b	#$6,$23C6E8.l
	beq.w	LFF2698
	lea.l	$23C368.l,a0
	move.w	#$1C0,d0
	move.w	$FF284E.l,d1
	bra.w	X_FF1418
LFF259E	bclr.b	#$5,$23C6E8.l
	beq.w	LFF2698
	lea.l	$23B1E8.l,a0
	move.w	#$8C0,d0
	move.w	$FF2862.l,d1
	asl.w	#$5,d1
	bra.w	X_FF1418
LFF25C0	btst.b	#$3,$A12024.l
	bne.w	LFF2602
	lea.l	$A10003.l,a0
	bsr.w	LFF267A
	move.b	d0,$FF284A.l
	lea.l	$A10005.l,a0
	bsr.w	LFF267A
	move.b	d0,$FF284B.l
	move.b	$FF284A.l,d0
	lsl.w	#$8,d0
	move.b	$FF284B.l,d0
	move.w	d0,$A1201C.l
	rts
LFF2602	lea.l	$A10003.l,a0
	move.b	#$C,$A10005.l
	bsr.w	LFF267A
	move.b	d0,$FF284A.l
	move.b	#$1C,$A10005.l
	bsr.w	LFF267A
	move.b	d0,$FF284B.l
	move.b	#$2C,$A10005.l
	bsr.w	LFF267A
	move.b	d0,$FF284C.l
	move.b	#$3C,$A10005.l
	bsr.w	LFF267A
	move.b	d0,$FF284D.l
	move.b	$FF284A.l,d0
	lsl.w	#$8,d0
	move.b	$FF284B.l,d0
	move.w	d0,$A1201C.l
	move.b	$FF284C.l,d0
	lsl.w	#$8,d0
	move.b	$FF284D.l,d0
	move.w	d0,$A1201E.l
	rts
LFF267A	move.b	#$0,(a0)
	nop
	nop
	move.b	(a0),d0
	move.b	#$40,(a0)
	asl.b	#$2,d0
	andi.b	#$C0,d0
	move.b	(a0),d1
	andi.b	#$3F,d1
	or.b	d1,d0
	not.b	d0
LFF2698	rts
LFF269A	btst.b	#$4,$23C6E8.l
	bne.b	LFF2698
	tst.w	$23A8D0.l
	bmi.b	LFF2698
	cmpi.w	#$64,$23A8D0.l
	beq.w	LFF275A
	subq.w	#$1,$23A8D0.l
	bmi.b	LFF2698
	clr.l	d0
	move.w	$23A8D0.l,d0
	cmpi.w	#$18,d0
	bgt.b	LFF2698
	divu.w	#$3,d0
	swap	d0
	asl.w	#$2,d0
	moveq	#$2,d3
	asl.w	d0,d3
	moveq	#$E,d5
	asl.w	d0,d5
	move.w	d5,d4
	not.w	d4
	movea.l	#$23A850,a1
	movea.l	#$C00000,a0
	clr.w	d6
LFF26F0	move.w	d3,d2
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
	beq.w	LFF272A
	blt.w	LFF2714
	neg.w	d2
LFF2714	add.w	d2,d0
	and.w	d4,d7
	or.w	d0,d7
	move.l	#$C000,d0
	move.b	d6,d0
	swap	d0
	move.l	d0,$4(a0)
	move.w	d7,(a0)
LFF272A	addq.w	#$2,d6
	cmpi.w	#$80,d6
	bne.b	LFF26F0
	rts
	movem.l	d1-d4,-(sp)
	clr.w	d4
	moveq	#$2,d3
	moveq	#$E,d2
LFF273E	move.w	d0,d1
	and.w	d2,d1
	beq.w	LFF274C
	add.w	d2,d1
	and.w	d2,d1
	or.w	d1,d4
LFF274C	asl.w	#$4,d2
	dbra	d3,LFF273E
	move.w	d4,d0
	movem.l	(sp)+,d1-d4
	rts
LFF275A	movem.l	d0/a0-a1,-(sp)
	move.w	$23C6E8.l,-(sp)
	bset.b	#$4,$23C6E8.l
	movea.l	#$23A850,a1
	movea.l	#$C00000,a0
	move.l	#$C0000000,$4(a0)
	moveq	#$1F,d0
LFF2782	move.l	(a1)+,(a0)
	dbra	d0,LFF2782
	st.b	$23A8D0.l
	move.w	(sp)+,$23C6E8.l
	movem.l	(sp)+,d0/a0-a1
	rts
LFF279A	btst.b	#$1,$FF2A16.l
	beq.w	LFF27B4
	bsr.w	X_FF117E
	bset.b	#$0,$FF2A16.l
	rts
LFF27B4	bclr.b	#$0,$FF2A16.l
	rts
LFF27BE	btst.b	#$0,$FF2A16.l
	beq.w	LFF27CE
	bsr.w	X_FF11A4
LFF27CE	rts
LFF27D0	lea.l	$23AF16.l,a0
	move.w	$23B1E6.l,d0
	move.w	$FF2850.l,d1
	bsr.w	X_FF1418
	movea.l	$23AF12.l,a6
	adda.l	#$180000,a6
	btst.b	#$0,$23C6EA.l
	beq.w	LFF2830
	lea.l	$23A8D2.l,a5
	cmpa.l	a5,a6
	beq.w	LFF2698
LFF280A	movea.l	(a5)+,a0
	move.w	(a5)+,d0
	move.w	(a5)+,d1
	adda.l	#$180000,a0
	bsr.w	X_FF1418
	cmpa.l	a6,a5
	bcs.b	LFF280A
	rts
LFF2820	move.w	-(a6),d1
	move.w	-(a6),d0
	movea.l	-(a6),a0
	adda.l	#$180000,a0
	bsr.w	X_FF1418
LFF2830	cmpa.l	#$23A8D2,a6
	bne.b	LFF2820
	rts
	bsr.w	LFF25C0
	rts
