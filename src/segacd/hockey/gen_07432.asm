	move.w	#$F1F,d1
.loop	add.b	(a0)+,d0
	dbra	d1,.loop
	rts
	dc.w	$41F9,$0001,$93BC,$303C,$0F1F,$4281,$10C1,$51C8
	dc.w	$FFFC,$4E75
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	d0,a1
	adda.l	#$193BC,a1
	subq.l	#$1,d1
.loop2	move.b	(a1)+,(a0)+
	dbra	d1,.loop2
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
.loop3	move.b	(a0)+,(a1)+
	dbra	d1,.loop3
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
; Entry that clears sflags6 bit 6, then runs SPAlist_1.
SPAlistClearFlag6
	bclr	#$6,(sflags6).l
SPAlist_1	movem.l	d0-d1/a0-a1,-(sp)
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
; Entry that sets sflags6 bit 6, then runs SPAlist_1.
SPAlistSetFlag6
	bset	#$6,(sflags6).l
	bra.w	SPAlist_1
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
	jsr	$2246C.l
	bra.w	.next2
.next	jsr	$22452.l
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
	jsr	$2246C.l
	bra.w	.next2
.next	jsr	$22452.l
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
	jsr	$2246C.l
	bra.w	.next2
.next	jsr	$22452.l
.next2	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Data that follows NameLogIO (strings, small tables)
NameLogIOData	dc.w	$0000,$001A,$0034,$004E,$0068,$0082,$009C,$00B6
	dc.w	$00D0,$00EA,$0104,$011E,$0138,$0152,$016C,$0186
	dc.w	$01A0,$01BA,$01D4,$01EE,$0208,$0222,$023C,$0256
	dc.w	$0270,$028A,$02A4,$02BE,$02D8
puckvzadj						;set puckvz for a top shelf shot from the distance to the goal line ($108)
	
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	$17B94.l,d0
	bpl.w	.next
	neg.w	d0
.next	subi.w	#$108,d0
	bpl.w	.next2
	neg.w	d0
.next2	swap	d0
	andi.l	#$FFFF0000,d0
	move.w	$17BAA.l,d1
	beq.w	.next8
	bpl.w	.next3
	neg.w	d1
.next3	move.w	#$11,d2
	tst.w	$18C20.l
	beq.w	.next4
	move.w	#$16,d2
.next4	divu.w	d1,d0
	andi.l	#$FFFF,d0
	divu.w	d2,d0
	tst.w	d0
	bne.w	.next5
	move.w	#$1,d0
.next5	move.l	#$A0000,d1
	move.w	d0,d3
	mulu.w	d2,d0
	divu.w	d0,d1
	move.w	d2,d4
	add.w	d2,d2
	add.w	d4,d2
	mulu.w	d3,d2
	cmpi.l	#$7FFF,d2
	blt.w	.next6
	move.w	#$7FFF,d2
.next6	add.w	d2,d1
	tst.w	d1
	bpl.w	.next7
	move.w	#$7FFF,d1
.next7	move.w	d1,$17BAC.l
.next8	movem.l	(sp)+,d0-d7/a0-a6
	rts
OneTimerPass						;One-timer pass: puckvz = sqrt(12 * onetimerheight), then puckvx / puckvy
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$C,d0
	move.w	$1937A.l,d1
	mulu.w	d1,d0
	swap	d0
	andi.l	#$FFFF0000,d0
	jsr	(Sroot).l
	move.w	d0,$17BAC.l
	ext.l	d0
	move.w	#$3,d4
	divu.w	d4,d0
	clr.l	d1
	move.w	$19376.l,d1
	sub.w	$17B80.l,d1
	swap	d1
	tst.w	d0
	bne.w	.next
	move.w	#$1,d0
.next	divs.w	d0,d1
	move.w	d1,$17BA8.l
	clr.l	d1
	move.w	$19378.l,d1
	sub.w	$17B94.l,d1
	swap	d1
	divs.w	d0,d1
	move.w	d1,$17BAA.l
	movea.l	#$17B80,a3
	move.w	$17BAC.l,d0
	jsr	(puckflip).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
OneTimerTarget						;One-timer pass target for receiver a3: an offset by facing from
	
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#$2,(sflags6).l
	tst.w	$34(a3)
	bne.w	.next
	movea.l	#$22906,a0
	bra.w	.next3
.next	move.w	$14(a3),d0
	btst	#$7,$62(a3)
	bne.w	.next2
	neg.w	d0
.next2	bset	#$2,(sflags6).l
	movea.l	#$228C6,a0
	cmpi.w	#$58,d0
	blt.w	.next3
	movea.l	#$228E6,a0
	bclr	#$2,(sflags6).l
.next3	move.w	$54(a3),d0
	btst	#$7,$62(a3)
	bne.w	.next4
	addi.w	#$4,d0
	andi.w	#$7,d0
.next4	asl.w	#$2,d0
	move.w	(a0,d0.w),d1
	move.w	$2(a0,d0.w),d2
	cmpa.l	#$228E6,a0
	bne.w	.next7
	move.w	$14(a3),d0
	bpl.w	.next5
	neg.w	d0
.next5	cmpi.w	#$8A,d0
	blt.w	.next7
	move.w	$0(a3),d0
	bpl.w	.next6
	neg.w	d0
.next6	cmpi.w	#$37,d0
	bgt.w	.next7
	move.w	#$103,d2
.next7	btst	#$7,$62(a3)
	bne.w	.next8
	neg.w	d1
	neg.w	d2
.next8	move.w	#$A,d0
	jsr	(randomd0).l
	add.w	d0,d1
	move.w	#$A,d0
	jsr	(randomd0).l
	add.w	d0,d2
	move.w	d1,$19376.l
	tst.w	$34(a3)
	beq.w	.next10
	sub.w	$0(a3),d1
	bmi.w	.next9
	subi.w	#$3C,d1
	bpl.w	.next10
	neg.w	d1
	add.w	d1,$19376.l
	bra.w	.next10
.next9	addi.w	#$3C,d1
	bmi.w	.next10
	sub.w	d1,$19376.l
.next10	move.w	d2,$19378.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
assonetimer						;Assignment $23 (asstab), player a3 shooting a one-timer: take control of
	
	
	
	ori.w	#$C2,$74(a4,d0.w)
	dc.b	$00,$C2,$00,$74,$00,$C2,$00,$74,$00,$C2,$FF,$8C,$00,$C2,$FF,$8C	; ...t...t........
	dc.b	$00,$C2,$FF,$8C,$00,$C2,$FF,$8C,$00,$C2,$FF,$FB,$00,$AB,$FF,$FB	; ................
	dc.b	$00,$AB,$FF,$FB,$00,$AB,$FF,$FB,$00,$AB,$FF,$FB,$00,$AB,$FF,$FB	; ................
	dc.b	$00,$AB,$FF,$FB,$00,$AB,$FF,$FB,$00,$AB,$FF,$FB,$FF,$F7,$00,$32	; ...............2
	dc.b	$FF,$F7,$00,$32,$FF,$F7,$00,$32,$FF,$F7,$FF,$FB,$FF,$F7,$FF,$CE	; ...2...2........
	dc.b	$FF,$F7,$FF,$CE,$FF,$F7,$FF,$CE,$FF,$F7,$08,$AB,$00,$01,$00,$62	; ...............b
	dc.b	$67,$00,$01,$38,$08,$EB,$00,$03,$00,$64,$66,$00,$01,$2E,$08,$B9	; g..8.....df.....
	dc.b	$00,$00,$00,$01,$7E,$C6,$08,$B9,$00,$05,$00,$01,$7F,$7C,$42,$79	; ....~........|By
	dc.b	$00,$01,$7E,$C6,$42,$79,$00,$01,$7E,$BE,$50,$F9,$00,$01,$7E,$30	; ..~.By..~.P...~0
; Per-player control update for the object in a3 (player number $52, flags $62)
PlayerControlUpdate	movem.l	d0-d7/a0-a6,-(sp)
	move.w	$52(a3),d0
	move.w	d0,$17EBC.l
	btst.b	#$3,$62(a3)
	bne.w	.next4
	tst.w	$1AD7A.l
	bmi.w	.next4
	beq.w	.next2
	cmpi.w	#$1,$1AD7C.l
	bne.w	.next
	move.w	$17FA8.l,-(sp)
	move.w	$17FA0.l,-(sp)
	move.w	$17FAC.l,$17FA8.l
	move.w	$17FA4.l,$17FA0.l
	jsr	$312DC.l
	move.w	$17FA0.l,$17FA4.l
	move.w	$17FA8.l,$17FAC.l
	move.w	(sp)+,$17FA0.l
	move.w	(sp)+,$17FA8.l
	bra.w	.next4
.next	jsr	$312DC.l
	bra.w	.next4
.next2	tst.w	$1AD7C.l
	bne.w	.next3
	move.w	$17FA6.l,-(sp)
	move.w	$17F9E.l,-(sp)
	move.w	$17FAA.l,$17FA6.l
	move.w	$17FA2.l,$17F9E.l
	jsr	$312B8.l
	move.w	$17F9E.l,$17FA2.l
	move.w	$17FA6.l,$17FAA.l
	move.w	(sp)+,$17F9E.l
	move.w	(sp)+,$17FA6.l
	bra.w	.next4
.next3	jsr	$312B8.l
	bra.w	.next4
.next4	move.w	d0,-(sp)
	bsr.w	PlayerPositionToScreen
	clr.w	$5A(a3)
	jsr	$363C0.l
	bset.b	#$5,$62(a3)
	bset.b	#$1,$63(a3)
	move.w	(sp)+,d0
	movem.l	(sp)+,d0-d7/a0-a6
	bra.w	.ex
	btst.b	#$0,$17EC6.l
	bne.w	.next9
	movem.w	d0-d1,-(sp)
	move.w	$17B80.l,d0
	sub.w	$0(a3),d0
	cmpi.w	#$3C,d0
	bgt.w	.next5
	cmpi.w	#$FFC4,d0
	bgt.w	.next6
.next5	move.w	$17BA8.l,d1
	eor.w	d1,d0
	bmi.w	.next6
.loop	movem.w	(sp)+,d0-d1
	bra.w	.next10
.next6	move.w	$17B94.l,d0
	sub.w	$14(a3),d0
	cmpi.w	#$3C,d0
	bgt.w	.next7
	cmpi.w	#$FFC4,d0
	bgt.w	.next8
.next7	move.w	$17BAA.l,d1
	eor.w	d1,d0
	bpl.w	.loop
.next8	movem.w	(sp)+,d0-d1
.next9	tst.w	$17BE0.l
	bmi.w	.next11
.next10	bclr.b	#$7,$17F7C.l
	bra.w	.next27
.next11	btst.b	#$0,$17F68.l
	bne.w	.next27
	movem.l	d0-d1,-(sp)
	cmpi.w	#$10,$5A(a3)
	bge.w	.next20
	btst.b	#$2,$17EC6.l
	bne.w	.next20
	move.w	$0(a3),d0
	move.w	$17B80.l,d1
	sub.w	d1,d0
	bpl.w	.next12
	neg.w	d0
.next12	move.w	$14(a3),d1
	move.w	$17B94.l,d2
	sub.w	d2,d1
	bpl.w	.next13
	neg.w	d1
.next13	move.w	$17BA8.l,d2
	beq.w	.next14
	cmp.w	d0,d1
	ble.w	.next15
.next14	move.w	$17BAA.l,d2
	move.w	d1,d0
.next15	swap	d0
	andi.l	#$FFFF0000,d0
	tst.w	d2
	bpl.w	.next16
	neg.w	d2
.next16	move.w	#$11,d1
	tst.w	$18C20.l
	beq.w	.next17
	move.w	#$16,d1
.next17	tst.w	d2
	bne.w	.next18
	move.w	#$1,d2
.next18	divu.w	d2,d0
	andi.l	#$FFFF,d0
	divu.w	d1,d0
	move.w	$5A(a3),d2
	lsr.w	#$2,d2
	subi.w	#$6,d2
	neg.w	d2
	asl.w	#$2,d2
	cmp.w	d2,d0
	bgt.w	.next19
	neg.w	$5A(a3)
	addi.w	#$18,$5A(a3)
	bra.w	.next23
.next19	add.w	d7,$17EBE.l
	bra.w	.next21
.next20	bset.b	#$2,$17EC6.l
	btst.b	#$1,$17EC6.l
	bne.w	.next21
	cmpi.w	#$18,$5A(a3)
	bne.w	.next21
	addi.w	#$30,$5C(a3)
	bset.b	#$1,$17EC6.l
.next21	btst.b	#$1,$17EC6.l
	beq.w	.next22
	cmpi.w	#$18,$5A(a3)
	ble.w	.next22
	btst.b	#$0,$17EC6.l
	bne.w	.next22
	movem.l	(sp)+,d0-d1
	bra.w	.next27
.next22	btst.b	#$0,$17EC6.l
	beq.w	.next23
	cmpi.w	#$18,$5A(a3)
	bne.w	.next23
	cmpi.w	#$1,$5C(a3)
	ble.w	.next23
	move.w	#$1,$5C(a3)
.next23	btst.b	#$1,$63(a3)
	bne.w	.next24
	movem.l	(sp)+,d0-d1
	bra.w	.next26
.next24	move.w	$5A(a3),d0
	movem.l	(sp)+,d0-d1
	btst.b	#$0,$17EC6.l
	beq.w	.next25
	bclr.b	#$5,$62(a3)
	bra.w	.next26
.next25	nop
.next26	btst.b	#$1,$63(a3)
	bne.w	.ex
.next27	jsr	$2AF00.l
.ex	rts
; Turns the position of the object in a3 into screen coordinates and draws its marker
PlayerPositionToScreen	move.w	#$7FC,d1
	movem.w	d0-d1,-(sp)
	move.w	$0(a3),d0
	neg.w	d0
	move.w	#$108,d1
	btst.b	#$7,$62(a3)
	bne.w	.next
	neg.w	d1
.next	sub.w	$14(a3),d1
	jsr	$362F8.l
	jsr	$22D9E.l
	movem.w	(sp)+,d0-d1
	beq.w	.ex
	move.w	#$92E,d1
.ex	rts
PuckOnAttackHalf						;d0 = 1 when the puck is on the half of the goal player a3 shoots at, else
	
	movem.w	d0-d1,-(sp)
	move.w	$17B94.l,d0
	btst	#$7,$62(a3)
	bne.w	.next
	neg.w	d0
.next	tst.w	d0
	bpl.w	.next3
	bra.w	.next2
	dc.w	$3039,$0001,$7E2C,$0640,$0004,$0240,$0007,$322B
	dc.w	$0054,$B240,$6000,$0044,$6700,$0040,$0641,$0001
	dc.w	$0241,$0007,$B240,$6700,$0032,$0641,$0001,$0241
	dc.w	$0007,$B240,$6700,$0024,$0441,$0003,$0241,$0007
	dc.w	$B240,$6700,$0016,$0441,$0001,$0241,$0007,$6700
	dc.w	$000A
.next2
	move.w	#$0,d0
	bra.w	.next4
.next3
	move.w	#$1,d0
.next4	movem.w	(sp)+,d0-d1
	rts
onetimershot						;Do the one-timer shot (doshot), credit the last two passers as the
	
	
	
	move.w	#$4,$17E2C.l
	jsr	(doshot).l
	movem.l	d0/a0,-(sp)
	movea.l	#tmstruct,a0
	btst	#$6,$62(a3)
	beq.w	.next
	lea.l	$366(a0),a0
.next	clr.w	d0
	move.b	$66(a3),d0
	move.w	$1A(a0),$1C(a0)
	move.w	$18(a0),$1A(a0)
	move.w	d0,$18(a0)
	bset	#$7,$17F7C.l
	addi.w	#$96,(Crowdlevel).l
	addi.w	#$A,$17CD8.l
	addi.w	#$1,$35E(a0)
	movem.l	(sp)+,d0/a0
	bset	#$0,$17EC6.l
	bset	#$1,$63(a3)
	bset	#$1,(sflags6).l
	rts
CheckOneTimerFacing						;called from setonetimeranim. it does nothing, d0 and d1 are restored at
	
	movem.w	d0-d1,-(sp)
	neg.w	d0
	addi.w	#$8,d0
	andi.w	#$7,d0
	move.w	$54(a3),d1
	add.w	d0,d1
	andi.w	#$7,d1
	cmpi.w	#$4,d1
	bgt.w	.next
	move.w	$4(a3),d0
	eori.w	#$FFFF,d0
	andi.w	#$800,d0
	bra.w	.next2
.next	move.w	$4(a3),d0
	andi.w	#$800,d0
.next2	movem.w	(sp)+,d0-d1
	rts
	rts
	rts
Set4WayPlayer						;unused: put player a3's number (SCnum) in the home or away nibble of
									;PadControlBits34 (unless PadControlBits is -1)
	cmpi.w	#$FFFF,$17DC8.l
	beq.w	.ex
	movem.l	d0-d2,-(sp)
	move.w	#$1,d0		;1 = home side code
	btst	#$6,$62(a3)		;away?
	beq.w	.next
	move.w	#$2,d0
.next	cmp.w	$17FAA.l,d0
	beq.w	.next2
	move.w	#$F,d1		;not pad 3: keep the low nibble, write the high
	move.w	#$4,d0		;shift 4: the high nibble
	bra.w	.next3
.next2	move.w	#$F0,d1		;keep the high nibble
	move.w	#$0,d0		;no shift: the low nibble
.next3	and.w	d1,$17DD6.l
	move.w	$52(a3),d1
	asl.w	d0,d1
	or.w	d1,$17DD6.l
	movem.l	(sp)+,d0-d2
.ex	rts
LoadCrowdRec						;CrowdRecord = the arena record of HomeTeam from save RAM (ReadCrowdRecord
	
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(HomeTeam).l,d1
	ext.l	d1
	movea.l	#ThreeStars,a0
	jsr	(ReadCrowdRecord).l
	move.b	$8(a0),d0
	beq.w	.none
	andi.w	#$FF,d0
	bra.w	.next
.none	move.w	#$50,d0
.next	move.w	d0,$17F8E.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
Crowd_Noise						;The crowd meter each frame: crowd noise on / off (sflags5 bit 7) from
	
	
	
	btst	#$7,$17F6A.l
	bne.w	.ex2
	btst	#$0,$17F78.l
	bne.w	.ex2
	btst	#$0,$17F6E.l
	bne.w	.ex
	btst	#$7,$17F74.l
	bne.w	.next2
	tst.w	$17F82.l
	beq.w	.next
	subi.w	#$1,$17F82.l
	bpl.w	.ex2
	clr.w	$17F82.l
.ex	rts
.next	move.w	$17F8E.l,d0
	move.w	d0,$17F90.l
	subi.w	#$B,$17F90.l
	subi.w	#$49,d0
	muls.w	d0,d0
	asr.l	#$2,d0
	addi.w	#$6,d0
	cmp.w	$17CD8.l,d0
	bgt.w	.ex2
	bset	#$7,$17F74.l
	rts
.next2	move.w	$17F90.l,d0
	subi.w	#$41,d0
	muls.w	d0,d0
	asr.l	#$2,d0
	cmp.w	$17CD8.l,d0
	blt.w	.next3
	bclr	#$7,$17F74.l
.next3	sub.w	d7,$17F84.l
	bpl.w	.ex2
	move.w	#$14,$17F84.l
	addi.w	#$1,$17F86.l
	move.w	$17CD8.l,d0
	ext.l	d0
	asl.w	#$2,d0
	jsr	(Sroot).l
	addi.w	#$41,d0
	move.w	d0,$17F8C.l
	cmp.w	$17F92.l,d0
	ble.w	.next4
	move.w	d0,$17F92.l
.next4	move.w	$17F8C.l,d0
	cmp.w	$17F8E.l,d0
	blt.w	.stack
	bra.w	.stack
.stack	movem.l	d0-d7/a0-a6,-(sp)
	movem.l	(sp)+,d0-d7/a0-a6
.ex2	rts
stopna2						;Slow Xvel and Yvel of a3 toward 0 by $7D0. Called from goalieacc
	tst.w	$28(a3)
	bpl.w	.xp
	addi.w	#$7D0,$28(a3)
	bmi.w	.y
	clr.w	$28(a3)
.xp	subi.w	#$7D0,$28(a3)
	bpl.w	.y
	clr.w	$28(a3)
.y	tst.w	$2A(a3)
	bpl.w	.yp
	addi.w	#$7D0,$2A(a3)
	bmi.w	.ex
	clr.w	$2A(a3)
.yp	subi.w	#$7D0,$2A(a3)
	bpl.w	.ex
	clr.w	$2A(a3)
.ex	rts
checkcornercoll						;210 = blue line to the end of the rink, corner radius 64. Corner circles
	
	
	bclr	#$4,$64(a3)
	move.w	#$88,d4
	sub.w	$17CF4.l,d4
	move.w	#$12A,d5
	sub.w	$17CF6.l,d5
	movem.w	d2-d5,-(sp)
	neg.w	d4
	neg.w	d5
	addi.w	#$40,d4
	addi.w	#$40,d5
	cmp.w	d5,d3
	bgt.w	.ctc
	cmp.w	d4,d2
	blt.w	.circle
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.circle
	bra.w	.exit
.ctc	neg.w	d5
	cmp.w	d5,d3
	blt.w	.exit
	cmp.w	d4,d2
	blt.w	.circle
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.circle
	bra.w	.exit
.circle	sub.w	d4,d2
	sub.w	d5,d3
	move.w	d3,d0
	move.w	d2,d1
	neg.w	d1
	muls.w	d3,d3
	muls.w	d2,d2
	add.l	d2,d3
	cmpi.l	#$42,d3
	bls.w	.exit
	exg.l	d0,d3
	jsr	(Sroot).l
	exg.l	d0,d3
	ext.l	d0
	asl.l	#$8,d0
	divs.w	d3,d0
	ext.l	d1
	asl.l	#$8,d1
	divs.w	d3,d1
	bsr.w	.next
.exit	movem.w	(sp)+,d2-d5
	move.w	$4E(a3),d0
	or.w	$50(a3),d0
	bne.w	.rtss3
	move.w	#$100,d0
	clr.w	d1
	cmp.w	d5,d3
	bge.w	.next
	neg.w	d5
	neg.w	d0
	cmp.w	d5,d3
	ble.w	.next
	exg.l	d0,d1
	cmp.w	d4,d2
	bge.w	.next
	neg.w	d4
	neg.w	d1
	cmp.w	d4,d2
	ble.w	.next
.rtss3	rts
.next	jmp	$3B6A2.l
Create_HotCold_Table						;Fill the hot / cold table (tmHotCold) of team struct a0: 16 bytes for
	
	
	movem.l	d0-d7,-(sp)
	move.w	#$19F,d1
HotColdLoop						;The Create_HotCold_Table loop
	move.w	#$9,d0
	jsr	(randomd0s).l
	move.l	a0,-(sp)
	adda.l	#$1A4,a0
	move.b	d0,(a0,d1.w)
	movea.l	(sp)+,a0
	dbra	d1,HotColdLoop
	movem.l	(sp)+,d0-d7
	rts
Clamp0to100						;unused: clamp d3 to 0 ... 100
	tst.w	d3
	bpl.w	.chkmax
	clr.w	d3
	rts
.chkmax	cmpi.w	#$64,d3
	ble.w	.x
	move.w	#$64,d3
.x	rts
AttributeCalc						;Attribute d3 of player a3 * 5 plus his hot / cold value / 3, limited to 0
	
	movem.l	d0-d2/a1,-(sp)
	move.w	$17E64.l,d1
	movea.l	#tmstruct,a1
	btst	#$6,$62(a3)
	beq.w	.attribmath
	adda.l	#$366,a1
.attribmath	clr.w	d1
	move.b	$66(a3),d1
	asl.w	#$4,d1
	adda.l	#$1A4,a1
	move.b	(a1,d1.w),d1
	ext.w	d1
	ext.l	d1
	divs.w	#$3,d1
	move.w	d3,-(sp)
	asl.w	#$2,d3
	add.w	(sp)+,d3
	add.w	d1,d3
	bmi.w	.LowerLimit
	cmpi.w	#$1E,d3
	blt.w	.MaskAttribMathResult
	move.w	#$1E,d3
	bra.w	.MaskAttribMathResult
.LowerLimit	clr.w	d3
.MaskAttribMathResult	andi.w	#$FF,d3
	movem.l	(sp)+,d0-d2/a1
	rts
NextHomeHotPlayer						;d1 = the next home hot player (homehotidx index into the list at
	
	
	movem.l	d0/a0,-(sp)
	movea.l	#$17EAE,a0
	move.w	$17EA6.l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#$0,$17EA6.l
	bge.w	.x
	addi.w	#$1,$17EA6.l
.x	movem.l	(sp)+,d0/a0
	movea.l	#tmstruct,a1
	rts
NextAwayHotPlayer						;The same for the away team (awayhotplayer, awayhotidx), a1 = awtmstruct.
	
	movem.l	d0/a0,-(sp)
	movea.l	#$17EAC,a0
	move.w	$17EA4.l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#$0,$17EA4.l
	bge.w	.x
	addi.w	#$1,$17EA4.l
.x	movem.l	(sp)+,d0/a0
	movea.l	#awtmstruct,a1
	rts
	rts
BuildHotColdLists						;Build the hot / cold player lists of both teams (SortHotColdStarters,
	
	clr.w	$17EA4.l
	clr.w	$17EA6.l
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a0
	bsr.w	SortHotColdStarters
	movea.l	#$17EAE,a0
	bsr.w	CopyHottestPlayer
	movea.l	#$17EB2,a0
	bsr.w	CopyColdestPlayer
	movea.l	#awtmstruct,a0
	bsr.w	SortHotColdStarters
	movea.l	#$17EAC,a0
	bsr.w	CopyHottestPlayer
	movea.l	#$17EB0,a0
	bsr.w	CopyColdestPlayer
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SortHotColdStarters						;Sum the hot / cold values of the 6 starters of team a0 into TempBuffer
	
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	a0,a2
	adda.l	#$1A4,a2
	movea.l	$1E(a0),a0
	adda.w	$6(a0),a0
	movea.l	#TempBuffer,a1
	move.w	#$5,d0
.player	move.b	(a0)+,d1
	subi.b	#$1,d1
	move.b	d1,(a1)+
	ext.w	d1
	asl.w	#$4,d1
	clr.b	(a1)
	addi.w	#$3,d1
	move.w	#$3,d7
.attrib	clr.w	d2
	move.b	(a2,d1.w),d2
	cmpi.b	#$9,d7
	beq.w	.nextattr
	cmpi.b	#$D,d7
	beq.w	.nextattr
	add.b	d2,(a1)
.nextattr	addi.w	#$1,d1
	addi.w	#$1,d7
	cmpi.b	#$10,d7
	bne.w	.attrib
	tst.b	(a1)+
	dbra	d0,.player
.sort	movea.l	#TempBuffer,a1
	clr.w	d1
	move.w	#$4,d0
.cmp	move.b	$3(a1),d6
	cmp.b	$1(a1),d6
	ble.w	.next
	st.b	d1
	move.w	$2(a1),d2
	move.w	$0(a1),$2(a1)
	move.w	d2,$0(a1)
.next	tst.w	(a1)+
	dbra	d0,.cmp
	tst.w	d1
	bne.w	.sort
	movem.l	(sp)+,d0-d7/a0-a6
	rts
NextHomeColdPlayer						;d1 = the next home cold player (homecoldidx, homecoldplayer), a1 =
	
	movem.l	d0/a0,-(sp)
	movea.l	#$17EB2,a0
	move.w	$17EAA.l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#$0,$17EAA.l
	bge.w	.x
	addi.w	#$1,$17EAA.l
.x	movem.l	(sp)+,d0/a0
	movea.l	#tmstruct,a1
	rts
NextAwayColdPlayer						;The same for the away team (awaycoldidx, awaycoldplayer), a1 =
	
	
	movem.l	d0/a0,-(sp)
	movea.l	#$17EB0,a0
	move.w	$17EA8.l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#$0,$17EA8.l
	bge.w	.x
	addi.w	#$1,$17EA8.l
.x	movem.l	(sp)+,d0/a0
	movea.l	#awtmstruct,a1
	rts
	rts
CopyHottestPlayer						;Copy the hottest player of TempBuffer to the list at a0
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	#TempBuffer,a1
	move.w	#$0,d0
.copy	clr.b	(a0)+
	move.b	(a1),d1
	move.b	d1,(a0)+
	tst.w	(a1)+
	dbra	d0,.copy
	movem.l	(sp)+,d0-d1/a0-a1
	rts
CopyColdestPlayer						;Copy the coldest player (TempBuffer+10) to the list at a0
	movem.l	d0/a0-a1,-(sp)
	movea.l	#$17E7A,a1
	move.w	#$0,d0
.copy	clr.b	(a0)+
	move.b	(a1),(a0)+
	tst.w	-(a1)
	dbra	d0,.copy
	movem.l	(sp)+,d0/a0-a1
	rts
	movem.l	d1-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a0
	bsr.w	GetHotColdTotal
	move.w	d1,$17E62.l
	movea.l	#awtmstruct,a0
	bsr.w	GetHotColdTotal
	move.w	d1,$17E64.l
	move.w	$17E62.l,d1
	move.w	$17E64.l,d2
	sub.w	d1,d2
	move.w	#$0,(awayhotter).l
	tst.w	d2
	bmi.w	.next
	move.w	#$1,(awayhotter).l
.next	tst.w	d2
	bpl.w	.next2
	neg.w	d2
.next2	move.w	#$FFFF,d0
	cmpi.w	#$5E,d2
	blt.w	.next3
	move.w	#$22,d0
	cmpi.w	#$BD,d2
	blt.w	.next3
	move.w	#$23,d0
.next3	movem.l	(sp)+,d1-d7/a0-a6
	rts
GetHotColdTotal						;d1 = the hot / cold total of the starters of
	
	bsr.w	SortHotColdStarters
	move.w	#$6,d0
	movea.l	#TempBuffer,a0
	clr.w	d1
.sum	move.b	$1(a0),d2
	ext.w	d2
	add.w	d2,d1
	tst.w	(a0)+
	dbra	d0,.sum
	rts
