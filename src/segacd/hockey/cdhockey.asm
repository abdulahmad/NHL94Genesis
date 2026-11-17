	move.l	#$22018,$6038.w
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$2D,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	rts
; disc only: vertical interrupt entry; hands the frame to the sub CPU through the gate array flags, then runs the game vblank (VBint)
VBlankSubCpuHook	btst.b	#$5,$FF800E.l
	beq.w	.ex
	bset.b	#$2,$FF800F.l
	move.l	#$2203A,-(sp)
	move.l	$18D66.l,-(sp)
	rts
	jsr	$47DB2.l
.loop	btst.b	#$4,$FF800E.l
	bne.s	.loop
	move.w	#$2F,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop2	btst.b	#$3,$FF800E.l
	beq.s	.loop2
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop3	btst.b	#$3,$FF800E.l
	bne.s	.loop3
	bclr.b	#$4,$FF800F.l
	bclr.b	#$2,$FF800F.l
	addq.w	#$1,$17460.l
.ex	rts
	movea.l	#$C458,sp
	movea.l	#$1745C,a0
.loop4	clr.l	(a0)+
	cmpa.l	#$1AD9A,a0
	blt.w	.loop4
	move.w	#$C,d7
	jsr	$6044.w
	move.w	d0,$193BA.l
	tst.w	$193BA.l
	bne.b	.next2
	jsr	$2243E.l
	move.w	#$0,d0
	lea.l	$7E000.l,a0
	lea.l	$17EF2.l,a1
	jsr	$5F16.w
	bcs.b	.next
	move.w	#$3,d0
	lea.l	BackupRamName.l,a0
	lea.l	$193BC.l,a1
	jsr	$5F16.w
	bra.b	.next2
.next	move.w	#$FFFF,$193BA.l
.next2	move.l	#$19360,$19360.l
	clr.w	$1AD94.l
.loop5	btst.b	#$7,$FF800E.l
	bne.s	.loop5
	movem.l	a0,-(sp)
	lea.l	$C00004.l,a0
	move.l	a0,$FF8022.l
	move.w	#$18,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	beq.s	.loop6
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop7	btst.b	#$6,$FF800E.l
	bne.s	.loop7
	bclr.b	#$7,$FF800F.l
	movem.l	(sp)+,a0
	andi.w	#$1,d0
	move.w	d0,$18C20.l
	beq.w	.loop8
	bset.b	#$0,$1AD94.l
.loop8	btst.b	#$7,$FF800E.l
	bne.b	.loop8
	move.w	#$2B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop9	btst.b	#$6,$FF800E.l
	beq.s	.loop9
	move.w	$FF8010.l,$18BF8.l
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop10	btst.b	#$6,$FF800E.l
	bne.s	.loop10
	bclr.b	#$7,$FF800F.l
	move.w	#$FFFF,$17DD6.l
	jsr	$21FC8.l
	move.w	#$3,d7
	jsr	$6044.w
	jsr	$3FDE8.l
	jsr	$2A58C.l
	jsr	$40102.l
	move.w	$18C0A.l,$18C22.l
	move.w	$18BFA.l,$18C24.l
	jsr	$37460.l
	jmp	$3F2D6.l
.loop11	btst.b	#$7,$FF800E.l
	bne.s	.loop11
.loop12	btst.b	#$6,$FF800E.l
	beq.s	.loop12
	bset.b	#$6,$FF800F.l
	bset.b	#$7,$FF800F.l
.loop13	btst.b	#$6,$FF800E.l
	bne.s	.loop13
	bclr.b	#$6,$FF800F.l
	bclr.b	#$7,$FF800F.l
	rts
.loop14	bclr.b	#$2,$FF8003.l
	bne.s	.loop14
	rts
.loop15	btst	#$1,$FF8003.l
	beq.b	.loop15
	rts
.loop16	btst.b	#$7,$FF800E.l
	bne.b	.loop16
	move.w	#$7,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop17	btst.b	#$6,$FF800E.l
	beq.b	.loop17
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop18	btst.b	#$6,$FF800E.l
	bne.b	.loop18
	bclr.b	#$7,$FF800F.l
	jsr	$22268.l
	rts	
	bset	#$0,$FF8003.l
.loop19	btst	#$1,$FF8003.l
	bne.b	.loop19
	rts
	movem.l	d0-d1/a0-a1,-(sp)
.loop20	move.w	#$80,d0
	jsr	$5F22.w
	bcs.b	.loop20
	movem.l	(sp)+,d0-d1/a0-a1
	rts
FileLoadTable					;disc only: the file load list the loader (jsr $6044.w, d7 = 8) reads through a3: 13 word pairs
									;(count or flag, file number), then one record per file
; Data of FileLoadTable (15 rows): table or constants used by it.
	dc.w	$000D,$006C,$000E,$0060,$000E,$0061,$000E,$0062
	dc.w	$000E,$0063,$000E,$0064,$000E,$0065,$000E,$0066
	dc.w	$000E,$0067,$000E,$006D,$000E,$006E,$000E,$006F
	dc.w	$000E,$006B,$000E,$0600,$0A60,$00FF,$FF02,$0202
	dc.w	$00FF,$00FF,$0600,$0754,$00FF,$FF02,$0202,$00FF
	dc.w	$00FF,$0600,$0254,$00FF,$FF02,$0202,$00FF,$00FF
	dc.w	$0600,$0154,$00FF,$FF02,$0202,$00FF,$00FF,$0600
	dc.w	$0654,$00FF,$FF02,$0202,$00FF,$00FF,$0600,$045A
	dc.w	$00FF,$FF02,$0202,$00FF,$00FF,$0600,$005A,$00FF
	dc.w	$FF02,$0202,$00FF,$00FF,$0600,$035A,$00FF,$FF02
	dc.w	$0202,$00FF,$00FF,$0600,$0554,$00FF,$FF02,$0202
	dc.w	$0096,$00FF,$0600,$085A,$00FF,$FF02,$0202,$00FF
	dc.w	$00FF,$0600,$095A,$00FF,$FF02,$0202,$00FF,$00FF
	dc.w	$0608,$0B54,$00FF,$FF02,$0202,$00FF,$00FF,$0600
	dc.w	$0C5A,$00FF,$FF02,$0202,$00FF,$00FF
FileLoadOrder					;disc only: the order the 13 files are loaded in (a2 of the same call): (2, n) word pairs, $FFFF ends
; Data of FileLoadOrder (4 rows): table or constants used by it.
	dc.w	$0002,$0000,$0002,$0001,$0002,$0002,$0002,$0003
	dc.w	$0002,$0004,$0002,$0005,$0002,$0006,$0002,$0007
	dc.w	$0002,$0008,$0002,$0009,$0002,$000A,$0002,$000B
	dc.w	$0002,$000C,$FFFF
BackupRamName					;disc only: the backup RAM file name (_CDBIOS backup call, d0 = 3), padded to 16 bytes
; Text of BackupRamName (1 row).
	dc.b	'NHLHOCKEY94',0,0,0,0,0
BackupRamNameSize				;disc only: the same name, then the word $003D: the file size in blocks
; Text of BackupRamNameSize (1 row).
	dc.b	'NHLHOCKEY94',0,0,$3D
	lea.l	$193BC.l,a0
	moveq	#$0,d0

	move.w	#$F1F,d1
.loop	add.b	(a0)+,d0
	dbra	d1,.loop
	rts
	lea.l	$193BC.l,a0
	move.w	#$F1F,d0
	clr.l	d1
.loop2	move.b	d1,(a0)+
	dbra	d0,.loop2
	rts	
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	d0,a1
	adda.l	#$193BC,a1
	subq.l	#$1,d1
.loop3	move.b	(a1)+,(a0)+
	dbra	d1,.loop3
	movem.l	(sp)+,d0-d1/a0-a1
	rts
	movem.l	d0-d1/a0-a1,-(sp)
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	beq.s	.next
	move.w	#$1,-(a6)
	bra.s	.next2
.next	move.w	#$0,-(a6)
.next2	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movea.l	d0,a1
	adda.l	#$193BC,a1
	subq.l	#$1,d1
.loop4	move.b	(a0)+,(a1)+
	dbra	d1,.loop4
	tst.w	$193BA.l
	bmi.w	.next4
	jsr	$2242A.l
	move.l	d0,$1A2DC.l
	move.w	#$0,d0
	lea.l	(ThreeStars).l,a0
	lea.l	(mesarea).l,a1
	jsr	$5F16.w
	bcs.w	.next3
	move.w	#$5,d0
	lea.l	BackupRamName.l,a0
	jsr	$5F16.w
	move.w	#$4,d0
	lea.l	BackupRamNameSize.l,a0
	lea.l	$193BC.l,a1
	jsr	$5F16.w
	bcc.w	.next4
.next3	move.w	#$FFFF,$193BA.l
.next4	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.next5
	bset	#$5,$FF800F.l
	bra.s	.next6
.next5	bclr	#$5,$FF800F.l
.next6	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movem.l	(sp)+,d0-d1/a0-a1
	rts
; Entry that clears sflags6 bit 6, then runs SPAlistDraw.
SPAlistClearFlag6
	bclr	#$6,(sflags6).l
SPAlistDraw	movem.l	d0-d1/a0-a1,-(sp)
	asl.l	#$2,d0
	addi.l	#$0,d0
	movea.l	#$2266E,a1
	add.w	d1,d1
	move.w	(a1,d1.w),d1
	asl.w	#$2,d1
	ext.l	d1
	add.l	d1,d0
	move.l	#$4,d1
	btst	#$6,(sflags6).l
	beq.w	.next
	jsr	$2246C.l
	bra.w	.next2
.next	jsr	$22452.l
.next2	movem.l	(sp)+,d0-d1/a0-a1
	rts
; Entry that sets sflags6 bit 6, then runs SPAlistDraw.
SPAlistSetFlag6
	bset	#$6,(sflags6).l
	bra.w	SPAlistDraw