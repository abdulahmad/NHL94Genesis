; Sets the sub-CPU vector and sends gate array command $2D (wait for idle, start, wait for ack).
SubCmd2DSend
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
	move.l	(VBint).l,-(sp)
	rts
	jsr	(ReadJoyData).l
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
	move.w	d0,(ValidSRAM).l
	tst.w	(ValidSRAM).l
	bne.b	.next2
	jsr	(BackupRamClear).l
	move.w	#$0,d0
	lea.l	$7E000.l,a0
	lea.l	(mesarea).l,a1
	jsr	$5F16.w
	bcs.b	.next
	move.w	#$3,d0
	lea.l	BackupRamName.l,a0
	lea.l	$193BC.l,a1
	jsr	$5F16.w
	bra.b	.next2
.next	move.w	#$FFFF,(ValidSRAM).l
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
	move.w	d0,(PalMode).l
	beq.w	.loop8
	bset.b	#$0,$1AD94.l
.loop8	btst.b	#$7,$FF800E.l
	bne.b	.loop8
	move.w	#$2B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop9	btst.b	#$6,$FF800E.l
	beq.s	.loop9
	move.w	$FF8010.l,(FourWayPlay).l
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop10	btst.b	#$6,$FF800E.l
	bne.s	.loop10
	bclr.b	#$7,$FF800F.l
	move.w	#$FFFF,(PadControlBits34).l
	jsr	(SubCmd2DSend).l
	move.w	#$3,d7
	jsr	$6044.w
	jsr	(EASportsScreen).l
	jsr	(ReadLineDataBackupRead).l
	jsr	(DefaultMenus).l
	move.w	(OptLine).l,(TmpOptLine2).l
	move.w	(OptPlayMode).l,(TempOptPlayMode).l
	jsr	(orjoy).l
	jmp	(GameOverCallTail).l
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
; Waits until the sub-CPU acknowledges (gate array bit 1 of $FF8003 set)
WaitGateAck
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
	jsr	(WaitGateAck).l
	rts	
; Raises gate array request bit 0 of $FF8003 and waits for the acknowledge to clear.
RaiseGateRequest
	bset	#$0,$FF8003.l
.loop19	btst	#$1,$FF8003.l
	bne.b	.loop19
	rts
; Calls the CD BIOS function $80 until it succeeds.
CdBiosCall80Retry
	movem.l	d0-d1/a0-a1,-(sp)
.loop20	move.w	#$80,d0
	jsr	$5F22.w
	bcs.b	.loop20
	movem.l	(sp)+,d0-d1/a0-a1
	rts
FileLoadTable					;disc only: the file load list the loader (jsr $6044.w, d7 = 8) reads through a3: 13 word pairs
									;(count or flag, file number), then one record per file
; Table of 118 words after FileLoadTable, 236 bytes: $000D,$006C,$000E,$0060,$000E,$0061 ...
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
; Table of 27 words after FileLoadOrder, 54 bytes: $0002,$0000,$0002,$0001,$0002,$0002 ...
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
; Adds up the $F20 bytes of the backup RAM image at $193BC.
BackupRamChecksum
	lea.l	$193BC.l,a0
	moveq	#$0,d0

	move.w	#$F1F,d1
.loop	add.b	(a0)+,d0
	dbra	d1,.loop
	rts
; Clears the $F20-byte backup RAM image at $193BC.
BackupRamClear
	lea.l	$193BC.l,a0
	move.w	#$F1F,d0
	clr.l	d1
.loop2	move.b	d1,(a0)+
	dbra	d0,.loop2
	rts	
; Copies d1 bytes from the backup RAM image (offset d0) to a0.
BackupRamRead
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	d0,a1
	adda.l	#$193BC,a1
	subq.l	#$1,d1
.loop3	move.b	(a1)+,(a0)+
	dbra	d1,.loop3
	movem.l	(sp)+,d0-d1/a0-a1
	rts
; Copies the buffer to the backup RAM image and signals the sub-CPU.
BackupRamWrite
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
	tst.w	(ValidSRAM).l
	bmi.w	.next4
	jsr	(BackupRamChecksum).l
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
.next3	move.w	#$FFFF,(ValidSRAM).l
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
	jsr	(BackupRamWrite).l
	bra.w	.next2
.next	jsr	(BackupRamRead).l
.next2	movem.l	(sp)+,d0-d1/a0-a1
	rts
; Entry that sets sflags6 bit 6, then runs SPAlistDraw.
SPAlistSetFlag6
	bset	#$6,(sflags6).l
	bra.w	SPAlistDraw
ReadCrowdRecord						;Read the 16 byte crowd record block of team d1 from save RAM
	
	
	bclr	#$6,(sflags6).l
; Moves one 16 byte crowd record between RAM and backup RAM (flag 6 of sflags6 picks the direction)
CrowdRecordBackupIO	movem.l	d0-d1/a0-a1,-(sp)
	move.l	d1,d0
	asl.w	#$4,d0
	addi.l	#$B60,d0
	move.l	#$10,d1
	btst	#$6,(sflags6).l
	beq.w	.next
	jsr	(BackupRamWrite).l
	bra.w	.next2
.next	jsr	(BackupRamRead).l
.next2	movem.l	(sp)+,d0-d1/a0-a1
	rts
; Sets the flag and reads a crowd record (variant A).
ReadCrowdRecordASetFlag6
	bset	#$6,(sflags6).l
	bra.w	CrowdRecordBackupIO
; Clears the flag and reads a crowd record (variant B).
ReadCrowdRecordBClearFlag6
	bclr	#$6,(sflags6).l
; Moves one 16 byte team record between RAM and backup RAM (flag 6 of sflags6 picks the direction)
TeamRecordBackupIO	movem.l	d0-d1/a0-a1,-(sp)
	move.l	d1,d0
	asl.w	#$4,d0
	addi.l	#$D20,d0
	move.l	#$10,d1
	btst	#$6,(sflags6).l
	beq.w	.next
	jsr	(BackupRamWrite).l
	bra.w	.next2
.next	jsr	(BackupRamRead).l
.next2	movem.l	(sp)+,d0-d1/a0-a1
	rts
; Sets the flag and reads a crowd record (variant B).
ReadCrowdRecordBSetFlag6
	bset	#$6,(sflags6).l
	bra.w	TeamRecordBackupIO
; Sets the flag and runs NameLogIO (write); ReadNameLog clears it (read).
WriteNameLog
	bset	#$6,(sflags6).l
	bra.w	NameLogIO
ReadNameLog						;Read the user name log from save RAM at NameLogBase to namelog. Called
	
	bclr	#$6,(sflags6).l
NameLogIO						;A user record block: read or write (sflags6 bit 6)
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	#$80,d1
	move.l	#$DA0,d0
	movea.l	#namelog,a0
	btst	#$6,(sflags6).l
	beq.w	.read
	jsr	(BackupRamWrite).l
	bra.w	.x
.read	jsr	(BackupRamRead).l
.x	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Data that follows NameLogIO (strings, small tables)
NameLogIOData	dc.w	$0000,$001A,$0034,$004E,$0068,$0082,$009C,$00B6
	dc.w	$00D0,$00EA,$0104,$011E,$0138,$0152,$016C,$0186
	dc.w	$01A0,$01BA,$01D4,$01EE,$0208,$0222,$023C,$0256
	dc.w	$0270,$028A,$02A4,$02BE,$02D8