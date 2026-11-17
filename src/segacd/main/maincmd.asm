DoDrawTextCommand	link	a6,#$FF00
	movem.l	d6-d7/a4,-(sp)
	lea.l	-$100(a6),a4
	clr.w	d6
	bra.b	.next2
.loop	cmpi.b	#$1,d7
	bne.b	.next
	move.w	d6,d0
	addq.w	#$1,d6
	clr.b	(a4,d0.w)
	bra.b	.next3
.next	move.w	d6,d0
	addq.w	#$1,d6
	move.b	d7,(a4,d0.w)
.next2	jsr	GetCommandFromSub(pc)
	move.b	d0,d7
	bne.b	.loop
.next3	move.l	a4,-(sp)
	jsr	aprint(pc)
	addq.w	#$4,sp
	movem.l	-$10C(a6),d6-d7/a4
	unlk	a6
	rts
	dc.b	$91,'DoDrawTextComma'	; .DoDrawTextComma
	dc.b	$6E,$64,$00,$00	; nd..
DoMoviePlayBack	link	a6,#$0
	movem.l	d5-d7/a4,-(sp)
	movea.l	#$200000,a4
	move.l	(a4),d5
	move.l	$4(a4),d6
	move.l	$8(a4),d7
	bra.b	.next
.loop	moveq	#$1,d0
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
.next	jsr	GetCommandFromSub(pc)
	cmpi.w	#$2,d0
	beq.b	.loop
	movem.l	-$10(a6),d5-d7/a4
	unlk	a6
	rts
	dc.b	$8F,'DoMoviePlayBack'	; .DoMoviePlayBack
	dc.b	$00,$00	; ..
MAINCODE	link	a6,#$0
	move.l	d7,-(sp)
	jsr	InitWorld(pc)
	pea.l	.next8(pc)
	jsr	aprint(pc)
	addq.w	#$4,sp
	bra.b	.next4
.loop	move.w	d7,d0
	subq.w	#$1,d0
	beq.b	.next
	subq.w	#$2,d0
	beq.b	.next2
	bra.b	.next3
.next	jsr	DoDrawTextCommand(pc)
	bra.b	.next4
.next2	jsr	DoMoviePlayBack(pc)
	bra.b	.next5
.next3	ext.l	d7
	move.l	d7,-(sp)
	pea.l	.next7(pc)
	jsr	aprint(pc)
	addq.w	#$8,sp
.next4	jsr	GetCommandFromSub(pc)
	move.w	d0,d7
	bne.b	.loop
.next5	pea.l	.next6(pc)
	jsr	aprint(pc)
	addq.w	#$4,sp
	move.l	-$4(a6),d7
	unlk	a6
	rts
	dc.b	$88,'MAINCODE',$00,$00,$38	; .MAINCODE..8
.next6	dc.b	'Main Done',$00	; Main Done.
.next7	dc.b	'Command: %d',$00	; Command: %d.
.next8	dc.b	'MAINCPU ready to'	; MAINCPU ready to
	dc.b	' handle commands'	;  handle commands
	dc.b	$00,$00	; ..
ReDraw	link	a6,#$0
	unlk	a6
	rts
	dc.b	$86,'ReDraw',$00,$00,$00	; .ReDraw...
drawprint	link	a6,#$0
	move.l	$8(a6),-(sp)
	lea.l	RamImageB(pc),a0
	move.l	$5C(a0),-(sp)
	lea.l	RamImageB(pc),a0
	move.l	$60(a0),-(sp)
	jsr	DrawTextToPlane_B(pc)
	lea.l	RamImageB(pc),a0
	addq.l	#$1,$60(a0)
	lea.l	RamImageB(pc),a0
	moveq	#$18,d0
	cmp.l	$60(a0),d0
	bgt.b	.next
	lea.l	RamImageB(pc),a0
	subi.l	#$14,$60(a0)
.next	jsr	ReDraw(pc)
	unlk	a6
	rts
	dc.b	$89,'drawprint',$00,$00	; .drawprint..
NumStr	link	a6,#$FFF0
	movem.l	d6-d7/a3-a4,-(sp)
	movea.l	$10(a6),a3
	lea.l	-$10(a6),a4
	move.l	$8(a6),d6
	clr.w	d7
	move.w	d7,d0
	addq.w	#$1,d7
	clr.b	(a4,d0.w)
.loop	move.l	d6,d0
	moveq	#$A,d1
	jsr	NumStrThunkD(pc)
	moveq	#$30,d1
	add.b	d1,d0
	move.w	d7,d1
	addq.w	#$1,d7
	move.b	d0,(a4,d1.w)
	move.l	d6,d0
	moveq	#$A,d1
	jsr	NumStrThunkC(pc)
	move.l	d0,d6
	bne.b	.loop
	bra.b	.next
.loop2	subq.w	#$1,d7
	move.b	(a4,d7.w),(a3)+
.next	tst.w	d7
	bne.b	.loop2
	movem.l	-$20(a6),d6-d7/a3-a4
	unlk	a6
	rts
	dc.b	$86,'NumStr',$00,$00,$00	; .NumStr...
HexStr	link	a6,#$0
	movem.l	d3-d7/a4,-(sp)
	move.w	$E(a6),d4
	move.l	$8(a6),d5
	movea.l	$10(a6),a4
	ext.l	d4
	move.l	d4,d7
	subq.l	#$1,d7
	moveq	#$0,d3
	bra.b	.next3
.loop	moveq	#$F,d6
	and.l	d5,d6
	asr.l	#$4,d5
	moveq	#$9,d0
	cmp.l	d6,d0
	blt.b	.next
	move.b	d6,d0
	moveq	#$30,d1
	add.b	d1,d0
	move.b	d0,(a4,d7.l)
	bra.b	.next2
.next	move.b	d6,d0
	moveq	#-55,d1
	sub.b	d1,d0
	move.b	d0,(a4,d7.l)
.next2	move.l	d7,d0
	subq.l	#$1,d7
.next3	cmp.l	d7,d3
	ble.b	.loop
	clr.b	(a4,d4.w)
	movem.l	-$18(a6),d3-d7/a4
	unlk	a6
	rts
	dc.b	$86,'HexStr',$00,$00,$00	; .HexStr...
aprint	link	a6,#$FED8
	movem.l	d4-d7/a3-a4,-(sp)
	lea.l	-$128(a6),a4
	bra.w	.next11
.loop	cmpi.b	#$25,d6
	beq.b	.next
	move.b	d6,(a3)+
	bra.w	.next10
.next	moveq	#$8,d4
	movea.l	$8(a6),a0
	addq.l	#$1,$8(a6)
	move.b	(a0),d6
	move.b	d6,d0
	subi.b	#$2A,d0
	bne.b	.next2
	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.w	-$2(a0),d4
	move.l	$8(a6),d0
	addq.l	#$1,$8(a6)
	movea.l	d0,a0
	move.b	(a0),d6
.next2	move.b	d6,d0
	subi.b	#$25,d0
	beq.w	.next9
	subi.b	#$2E,d0
	beq.b	.next7
	subq.b	#$5,d0
	beq.b	.next5
	subi.b	#$C,d0
	beq.b	.next3
	subi.b	#$F,d0
	beq.b	.next7
	subq.b	#$5,d0
	beq.b	.next5
	bra.w	.next10
.next3	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),d5
	move.l	a4,-(sp)
	ext.l	d4
	move.l	d4,-(sp)
	move.l	d5,-(sp)
	jsr	NumStr(pc)
	clr.w	d7
	lea.l	$C(sp),sp
	bra.b	.next4
.loop2	move.b	(a4,d7.w),(a3)+
	move.w	d7,d0
	addq.w	#$1,d7
.next4	tst.b	(a4,d7.w)
	bne.b	.loop2
	bra.b	.next10
.next5	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),d5
	move.l	a4,-(sp)
	ext.l	d4
	move.l	d4,-(sp)
	move.l	d5,-(sp)
	jsr	HexStr(pc)
	clr.w	d7
	lea.l	$C(sp),sp
	bra.b	.next6
.loop3	move.b	(a4,d7.w),(a3)+
	move.w	d7,d0
	addq.w	#$1,d7
.next6	tst.b	(a4,d7.w)
	bne.b	.loop3
	bra.b	.next10
.next7	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),-$8(a6)
	bra.b	.next8
.loop4	move.l	-$8(a6),d0
	addq.l	#$1,-$8(a6)
	movea.l	d0,a0
	move.b	(a0),(a3)+
.next8	movea.l	-$8(a6),a0
	tst.b	(a0)
	bne.b	.loop4
	bra.b	.next10
.next9	move.b	d6,(a3)+
.next10	move.l	$8(a6),d0
	addq.l	#$1,$8(a6)
	movea.l	d0,a0
	move.b	(a0),d6
	bne.w	.loop
	clr.b	(a3)+
	pea.l	-$108(a6)
	jsr	drawprint(pc)
	addq.w	#$4,sp
.next11	movem.l	-$140(a6),d4-d7/a3-a4
	unlk	a6
	rts
	dc.b	$86,'aprint',$00,$00,$00	; .aprint...
InitWorld	link	a6,#$0
	movea.l	#$A12010,a0
	clr.w	(a0)
	movea.l	#$A12010,a0
	clr.w	$2(a0)
	lea.l	RamImageB(pc),a0
	moveq	#$4,d0
	move.l	d0,$5C(a0)
	lea.l	RamImageB(pc),a0
	move.l	d0,$60(a0)
	pea.l	.next3(pc)
	jsr	aprint(pc)
	lea.l	RamImageB(pc),a0
	move.l	$54(a0),-(sp)
	pea.l	.next2(pc)
	jsr	aprint(pc)
	lea.l	RamImageB(pc),a0
	move.l	$58(a0),-(sp)
	pea.l	.next(pc)
	jsr	aprint(pc)
	unlk	a6
	rts
	dc.b	$89,'InitWorld',$00,$32	; .InitWorld.2
.next	dc.b	'Heap Size : %x',$00,$00	; Heap Size : %x..
.next2	dc.b	'Heap Start: %x',$00,$00	; Heap Start: %x..
.next3	dc.b	'MAINCPU is alive'	; MAINCPU is alive
	dc.b	$00,$00	; ..
GetCommandFromSub	link	a6,#$0
	movem.l	d7/a3-a4,-(sp)
	movea.l	#$A12010,a3
	movea.l	#$A12020,a4
.loop	move.w	(a4),d7
	beq.b	.loop
	move.w	#$1,(a3)
.loop2	tst.w	(a4)
	bne.b	.loop2
	clr.w	(a3)
	move.w	d7,d0
	movem.l	-$C(a6),d7/a3-a4
	unlk	a6
	rts
	dc.b	$91,'GetCommandFromS'	; .GetCommandFromS
	dc.b	$75,$62,$00,$00	; ub..
Set1MFlag	link	a6,#$0
	movea.l	#$A12010,a0
	move.w	$A(a6),$2(a0)
	unlk	a6
	rts
	dc.b	$89,'Set1MFlag',$00,$00,$22,$2F,$00,$04	; .Set1MFlag.."/..
	dc.b	$20,$2F,$00,$08	;  /..
; Jump thunk through a computed address (number string)
NumStrThunkC	lea.l	.next(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.next	dc.b	$60,$06,$4C,$41,$08,$01,$4E,$75,$4E,$BA,$00,$24,$20,$01,$4E,$75	; `.LA..NuN..$ .Nu
	dc.b	$22,$2F,$00,$04,$20,$2F,$00,$08	; "/.. /..
; Jump thunk through a computed address (number string)
NumStrThunkD	lea.l	.next(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.next	dc.b	$60,$08,$4C,$41,$08,$01,$C3,'@NuJ',$80,$6B,$14,$4A,$81	; `.LA...@NuJ.k.J.
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
; Sets up VDP and the sub-CPU address for DMA
VdpDmaBoot	lea.l	$FF481C.l,a0
	move.w	#$FFFF,$70.l
	move.w	a0,$A12006.l
	move.w	#$8A00,$C00004.l
	move.w	#$8014,$C00004.l
	rts
	move.w	#$8004,$C00004.l
	rts
	bset.b	#$6,$A1200E.l
.loop	btst.b	#$6,$A1200F.l
	bne.b	.loop
	bclr.b	#$6,$A1200E.l
	bclr.b	#$7,$A1200E.l
	jsr	$FF4918.l
	movea.l	#$FFFC00,sp
	bra.w	WaitSubCpuReady
	move.w	#$0,d0
	lea.l	$FF6E0C.l,a0
	move.w	#$184F,d1
	movea.l	$A12022.l,a1
	bsr.w	Z80CommandSwitch
	lea.l	$FF963C.l,a0
	move.w	#$0,d1
	move.w	#$6,d0
	bsr.w	Z80CommandSwitch
	lea.l	$FFA0C6.l,a0
	move.w	#$7,d0
	bsr.w	Z80CommandSwitch
	jsr	$FF67E8.l
	rts
	move.w	#$0,d0
	lea.l	$FF6E0C.l,a0
	move.w	#$184F,d1
	movea.l	$A12022.l,a1
	bsr.w	Z80CommandSwitch
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
	bne.b	.next
	move.w	#$1,$A12010.l
	bra.b	.next2
.next	move.w	#$0,$A12010.l
	move.b	#$40,$A1000B.l
.next2	move.w	#$100,$A11200.l
	rts
; Stores the address $FF485E in the vector at $FFFD08.
SetTextVector	lea.l	$FF485E.l,a0
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
	bsr.w	Z80CommandSwitch
	move.w	(sp)+,sr
	rts
	move.b	$A12028.l,$A10003.l
	rts
	move.b	$A12028.l,$A10005.l
	rts
	move.b	$A10003.l,$A12018.l
	rts
	move.b	$A10005.l,$A12018.l
	rts
	move.w	$A12028.l,$C00004.l
	rts
	move.w	sr,-(sp)
	move.w	#$2700,sr
	movea.l	#$C00000,a0
	move.l	#$20,$C00004.l
	move.l	#$3F,d0
	lea.l	$FF6D04.l,a1
.loop	move.w	(a0),(a1)+
	dbra	d0,.loop
	move.w	(sp)+,sr
	rts
; Sets the flag at $FF6D84 to 1 if it is clear.
SetFlagOnce	tst.w	$FF6D84.l
	bne.w	.next
	move.w	#$1,$FF6D84.l
	rts
.next	movem.l	d0-d7/a0-a2,-(sp)
	st.b	$FF6D8A.l
	bsr.w	.next2
	lea.l	VdpShadowBuffers(pc),a0
	moveq	#$3F,d1
.loop	move.w	#$0,(a0)+
	dbra	d1,.loop
	move.w	#$18,$FF6D8A.l
.loop2	tst.w	$FF6D8A.l
	bpl.w	.loop2
	bsr.w	ClearVram
	bsr.w	.next3
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
	lea.l	VdpShadowBuffers(pc),a1
	moveq	#$1F,d0
.loop3	move.l	(a0)+,(a1)+
	dbra	d0,.loop3
	move.w	(a0)+,d1
	move.w	(a0)+,d2
	movea.l	a0,a2
	subq.w	#$1,d1
	subq.w	#$1,d2
	move.w	d1,d3
	move.w	#$80,d7
	moveq	#$0,d4
	move.w	#$C000,d4
.loop4	move.l	d4,d0
	bsr.w	VdpSetWriteAddrD0
.loop5	move.w	(a2)+,d6
	add.w	d5,d6
	move.w	d6,(a0)
	dbra	d1,.loop5
	move.w	d3,d1
	add.w	d7,d4
	dbra	d2,.loop4
	move.w	#$18,$FF6D8A.l
.loop6	tst.w	$FF6D8A.l
	bpl.w	.loop6
	bsr.w	SetTextVector
	movem.l	(sp)+,d0-d7/a0-a2
	rts
.next2	lea.l	VdpRefreshHandler(pc),a0
	move.l	a0,$FFFD08.l
	rts
.next3	movea.l	#$C00000,a1
	move.l	#$27,d0
	move.l	#$40000010,$4(a1)
.loop7	move.w	#$0,(a1)
	dbra	d0,.loop7
	rts
; Second copy of VdpSetWriteAddr (sets the VRAM write command from d0).
VdpSetWriteAddrD0	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
	move.l	d0,$4(a0)
	rts
; Interrupt-time VDP refresh
VdpRefreshHandler	movem.l	d0-d7/a0-a4,-(sp)
	tst.w	$FF6D8A.l
	bmi.w	.loop2
	cmpi.w	#$64,$FF6D8A.l
	beq.w	.next3
	subq.w	#$1,$FF6D8A.l
	bmi.w	.loop2
	clr.l	d0
	move.w	$FF6D8A.l,d0
	cmpi.w	#$18,d0
	bgt.w	.loop2
	divu.w	#$3,d0
	swap	d0
	asl.w	#$2,d0
	moveq	#$2,d3
	asl.w	d0,d3
	moveq	#$E,d5
	asl.w	d0,d5
	move.w	d5,d4
	not.w	d4
	lea.l	VdpShadowBuffers(pc),a1
	movea.l	#$C00000,a0
	clr.w	d6
.loop	move.w	d3,d2
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
	beq.w	.next2
	blt.w	.next
	neg.w	d2
.next	add.w	d2,d0
	and.w	d4,d7
	or.w	d0,d7
	move.l	#$C000,d0
	move.b	d6,d0
	swap	d0
	move.l	d0,$4(a0)
	move.w	d7,(a0)
.next2	addq.w	#$2,d6
	cmpi.w	#$80,d6
	bne.w	.loop
.loop2	movem.l	(sp)+,d0-d7/a0-a4
	rte
.next3	lea.l	$FF6D8C.l,a1
	movea.l	#$C00000,a0
	move.l	#$C0000000,$4(a0)
	moveq	#$1F,d0
.loop3	move.l	(a1)+,(a0)
	dbra	d0,.loop3
	st.b	$FF6D8A.l
	bra.w	.loop2
; Initialises the VDP registers
VdpInitRegs	movem.l	d2-d7/a1-a2,-(sp)
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
	ble.w	.next
	bra.w	.next2
.next	moveq	#$1,d7
	move.w	d1,d6
	move.l	(a0),d5
	adda.l	#$2,a0
.next2	move.l	a0,d0
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
.loop	move.w	$C00004.l,-(sp)
	btst.b	#$1,$1(sp)
	addq.w	#$2,sp
	bne.w	.loop
	move.w	#$8164,$C00004.l
	tst.w	d7
	beq.w	.next3
	moveq	#$0,d0
	move.w	d6,d0
	bsr.w	VdpSetWriteAddrD0
	move.l	d5,(a0)
.next3	movem.l	(sp)+,d2-d7/a1-a2
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
	bsr.w	SetFlagOnce
	lea.l	RunSubCommand(pc),a1
	movea.l	#$205BC8,a0
	move.l	#$C5A,d0
.loop2	move.l	(a0)+,(a1)+
	dbra	d0,.loop2
	move.l	#$FF1006,$FF6D86.l
	bsr.w	GiveWordRamToSub
	clr.w	$FF6D84.l
	rts
	dcb.b	$E,0
	dc.b	$FF,$FF	; ..
	dcb.b	$94,0
; VDP shadow register and list buffers
VdpShadowBuffers	dcb.b	$80,0
	dc.b	$C3,$00,$06,$00,$C3,$51,$10,$00,$C3,$51,$10,$00,$C3,$51,$10,$00	; .....Q...Q...Q..
	dc.b	$C3,$51,$10,$00,$C3,$51,$10,$00,$C3,$51,$10,$00,$C3,$51,$10,$00	; .Q...Q...Q...Q..
	dc.b	$18,$4F,$18,$4F,$14,$48,$16,$49,$18,$4B	; .O.O.H.I.K
	dcb.b	$5D6,0
	incbin	..\Extracted\SegaCD\MAIN\main_0640C.bin
.next	incbin	..\Extracted\SegaCD\MAIN\main_067E8.bin
.next2	incbin	..\Extracted\SegaCD\MAIN\main_06BD0.bin
	dcb.b	$301,0
	dc.b	$FF	; .
	dcb.b	$200,0
	dc.b	$FF,$FE,$03,$00,$C0,$00,$00	; .......