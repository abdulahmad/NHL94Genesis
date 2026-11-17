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
	movea.l	#$1A2FC,a0
	btst	#$6,(sflags6).l
	beq.w	.next
	jsr	(BackupRamWrite).l
	bra.w	.next2
.next	jsr	(BackupRamRead).l
.next2	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Data that follows NameLogIO (strings, small tables)
NameLogIOData	dc.w	$0000,$001A,$0034,$004E,$0068,$0082,$009C,$00B6
	dc.w	$00D0,$00EA,$0104,$011E,$0138,$0152,$016C,$0186
	dc.w	$01A0,$01BA,$01D4,$01EE,$0208,$0222,$023C,$0256
	dc.w	$0270,$028A,$02A4,$02BE,$02D8