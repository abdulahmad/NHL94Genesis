;	BOOT.BIN $784-$FFF (runtime $FF0584-$FF0DFF).
;
;	The initial program after Sega's security block (security.asm): it sets the interrupt level and the
;	V / H interrupt vectors, waits for the sub CPU, takes word RAM, copies MAIN.BIN ($EC02 bytes, which the
;	system program put in word RAM) to $FF1000 and jumps to it. Then zeros to the system program.


	org	$FF0584

IPMain
	move.b	#$0,$A1200E.l
	jsr	(SyncMainShellStartup).l
	move.w	#$7,d0
	jsr	(SetInterruptLevel).l
	lea	(AcknowledgeMainVBlank).l,a0
	move.l	a0,$FFFD08.l
	move.w	#$0,d0
	jsr	(SetInterruptLevel).l
	lea	(IPHBlank).l,a0
	move.w	#$FFFF,$70.l
	move.w	a0,$A12006.l
.LFF05C6
	btst.b	#$2,$A12003.l
	bne.s	.LFF05C6
	jsr	(GiveSubWordRamAndWait).l
	jsr	(SyncMainShellStartup).l
	jsr	(WaitMainWordRam).l
	lea	$200000.l,a0
	lea	$FF1000.l,a1
	move.l	#$7600,d0
.LFF05F4
	move.w	(a0)+,(a1)+
	dbf	d0,.LFF05F4
	jsr	(SyncMainShellStartup).l
	jmp	$FF1000.l
WaitMainWordRam
	btst.b	#$1,$A12003.l
	bne.s	WaitMainWordRam
	rts
GiveSubWordRamAndWait
	bset.b	#$1,$A12003.l
.LFF061A
	btst.b	#$0,$A12003.l
	bne.s	.LFF061A
	rts
AcknowledgeMainVBlank
	bset.b	#$0,$A12000.l
	rte
IPHBlank
	rte
SyncMainShellStartup
	btst.b	#$7,$A1200F.l
	bne.s	SyncMainShellStartup
.LFF063C
	btst.b	#$6,$A1200F.l
	bne.s	.LFF063C
	bset.b	#$6,$A1200E.l
.LFF064E
	btst.b	#$6,$A1200F.l
	beq.s	.LFF064E
	bset.b	#$7,$A1200E.l
	bclr.b	#$6,$A1200E.l
.LFF0668
	btst.b	#$6,$A1200F.l
	bne.s	.LFF0668
	bclr.b	#$7,$A1200E.l
	rts
SetInterruptLevel
	movem.l	d0-d1,-(sp)
	asl.w	#$8,d0
	andi.w	#$700,d0
	move.w	sr,d1
	andi.w	#$F8FF,d1
	or.w	d0,d1
	move.w	d1,sr
	movem.l	(sp)+,d0-d1
	rts
	dcb.b	1898,0
