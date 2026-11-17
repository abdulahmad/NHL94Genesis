ReadLineData						;Read the $100 bytes at save RAM LineDataBase to databuffer; sflags bit 4
	
	
	moveq	#$0,d3
	addq.b	#$5,d0
	move.w	(a2,d3.w),-(a0)
	dc.w	$5A31,$3433		; addq.b #$5,$33(a1,d3.w)
	dc.w	$3334,$5A00		; move.w (a4,d5.l * 2),-(a1)
	dc.w	$3537,$3537,$3636,$383A,$3938,$5A65		; move.w ([$3636383A,sp],d3.w * 4,$39385A65),-(a2)
	dc.w	$4A4B		; dc.w $4A4B
	dc.w	$4B00		; dc.w $4B00
	addq.b	#$5,d0
	move.w	#$3D00,-(a5)
	dc.b	'Z<>??',$00,'Z',$00,'wuv',$00,'Z',$00,'@B'
	dc.b	'ABZ@CCEDZFONOMZL'
	dc.b	'PQP',$00,'ZRGHGIZITUS',$00
	dc.b	'Z',$00,'wuv',$00,'Z',$00,'VWVX',$00,'XY['
	dc.b	'Y',$5C,'Z',$5C,']^]',$00,'Z^_`acde'
	dc.b	'ghhgZijkk',$00,'Z',$00,'llm',$00
	dc.b	'Z',$00,'nop',$00,'Z',$00,'qsq',$00,'Ztwu'
	dc.b	'v',$00,'Z',$00,'TUS',$00,'Z',$00,'TUS',$00,'Z',$00
; Data that follows ReadLineData (strings, small tables)
ReadLineDataTexts	dc.b	'4@BIX',$5C,'ef'
	movem.l	d0-d1/a0,-(sp)
	move.l	#$100,d1
	move.l	#$E20,d0
	movea.l	#$18C26,a0
	jsr	$22452.l
	bclr	#$4,$17F6A.l
	move.w	#$FFFF,(lastsfx).l
	move.l	#$C45C,$17470.l
	movem.l	(sp)+,d0-d1/a0
	rts
	movem.l	d0-d1/a0,-(sp)
	move.l	#$100,d1
	move.l	#$E20,d0
	movea.l	#$18C26,a0
	jsr	$2246C.l
	bclr	#$4,$17F6A.l
	move.w	#$FFFF,(lastsfx).l
	move.l	#$C45C,$17470.l
	movem.l	(sp)+,d0-d1/a0
	rts
ClearWinRecords
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#ThreeStars,a0
	move.w	#$7,d7
.loop	clr.b	$8(a0)
	clr.b	$9(a0)
	clr.b	$A(a0)
	clr.b	$B(a0)
	adda.w	#$10,a0
	dbra	d7,.loop
	move.l	#$D20,d0
	move.l	#$80,d1
	movea.l	#ThreeStars,a0
	jsr	$2246C.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PSandSOpassdir						;Penalty shot / shootout: passdir = sopathdir (the end of the skate path,
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	$1A8BC.l,d0
	btst	#$7,$62(a3)
	bne.w	.next
	movea.l	#$2A674,a0
	add.w	d0,d0
	move.w	(a0,d0.w),d0
.next	move.w	d0,$17E2C.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Data that follows PSandSOpassdir (strings, small tables)
PSandSOpassdirData	dc.w	$0000,$0007,$0006,$0005,$0004,$0003,$0002,$0001
	dc.w	$0008
StartShootoutPath						;Shootout: pick one of the 7 skate paths (ShootoutPaths) at random
	
	
	movem.l	d0-d7/a0-a6,-(sp)
.loop	move.w	#$7,d0
	jsr	(randomd0).l
	cmpi.w	#$6,d0
	bgt.w	.loop
	move.w	d0,$1A8B4.l
	bclr	#$3,$17F7A.l
	move.w	#$FFFF,$1A8B6.l
	clr.w	$1A8B8.l
	bsr.w	NextPathPoint
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Data that follows StartShootoutPath (strings, small tables)
StartShootoutPathData	dc.w	$0002,$A6DE,$0002,$A6EA,$0002,$A6FA,$0002,$A706
	dc.w	$0002,$A712,$0002,$A71E,$0002,$A72A,$0010,$00E2
	dc.w	$0010,$00D0,$8020,$0005,$FFC9,$00A0,$FFFF,$00C8
	dc.w	$FFE0,$00D0,$8020,$0005,$FFB0,$0040,$001A,$00BC
	dc.w	$8020,$0005,$FFCE,$0058,$0014,$00D0,$802C,$0005
	dc.w	$FFCE,$0008,$0020,$00D0,$8028,$0006,$001C,$00F4
	dc.w	$0008,$00E0,$8020,$0006,$FFE6,$00F8,$0000,$00E0
	dc.w	$8020,$0002
NextPathPoint
	movem.l	d0-d7/a0-a6,-(sp)
	cmpi.b	#$80,$1A8B8.l
	beq.w	.next2
	addi.w	#$1,$1A8B6.l
	move.w	$1A8B6.l,d0
	asl.w	#$2,d0
	movea.l	#$2A6C2,a0
	move.w	$1A8B4.l,d1
	asl.w	#$2,d1
	movea.l	(a0,d1.w),a0
	move.w	(a0,d0.w),$1A8B8.l
	btst	#$0,$76(a3)
	beq.w	.next
	neg.w	$1A8B8.l
.next	move.w	$2(a0,d0.w),$1A8BA.l
	cmpi.b	#$80,$4(a0,d0.w)
	bne.w	.next2
	bset	#$3,$17F7A.l
	clr.w	$1A8BE.l
	move.b	$5(a0,d0.w),$1A8BF.l
	move.w	$6(a0,d0.w),$1A8BC.l
.next2	movem.l	(sp)+,d0-d7/a0-a6
	rts
	movem.l	d2-d7/a0-a6,-(sp)
	cmpi.b	#$80,$1A8B8.l
	beq.w	.next11
	move.w	$1A8B8.l,d0
	move.w	$1A8BA.l,d1
	btst	#$7,$62(a3)
	bne.w	.next3
	neg.w	d0
	neg.w	d1
.next3	sub.w	$0(a3),d0
	bpl.w	.next4
	neg.w	d0
.next4	tst.w	$28(a3)
	bne.w	.next5
	tst.w	$2A(a3)
	bne.w	.next5
	cmpi.w	#$12,d0
	ble.w	.next6
.next5	cmpi.w	#$A,d0
	bgt.w	.next10
.next6	sub.w	$14(a3),d1
	bpl.w	.next7
	neg.w	d1
.next7	tst.w	$28(a3)
	bne.w	.next8
	tst.w	$2A(a3)
	bne.w	.next8
	cmpi.w	#$12,d1
	ble.w	.next9
.next8	cmpi.w	#$A,d1
	bgt.w	.next10
.next9	bsr.w	NextPathPoint
.next10	move.w	$1A8B8.l,d0
	move.w	$1A8BA.l,d1
.next11	movem.l	(sp)+,d2-d7/a0-a6
	rts
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#$1,$17F78.l
	beq.w	.next17
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	bne.w	.next17
	cmpi.w	#$3,$193B6.l
	ble.w	.next16
	cmpi.b	#$80,$1A8B8.l
	beq.w	.next16
	btst	#$3,$17F7A.l
	bne.w	.next12
	tst.w	$17BA8.l
	bne.w	.next17
	tst.w	$17BAA.l
	bne.w	.next17
	cmpi.w	#$F,$193B6.l
	blt.w	.next16
	bra.w	.next17
.next12	move.w	$1A8B8.l,d0
	move.w	$1A8BA.l,d1
	btst	#$7,$62(a3)
	bne.w	.next13
	neg.w	d0
	neg.w	d1
.next13	sub.w	$0(a3),d0
	bpl.w	.next14
	neg.w	d0
.next14	sub.w	$14(a3),d1
	bpl.w	.next15
	neg.w	d1
.next15	cmp.w	$1A8BE.l,d0
	bgt.w	.next17
	cmp.w	$1A8BE.l,d1
	bgt.w	.next17
.next16	clr.w	d0
	bra.w	.next18
.next17	move.w	#$1,d0
.next18	movem.l	(sp)+,d0-d7/a0-a6
	rts