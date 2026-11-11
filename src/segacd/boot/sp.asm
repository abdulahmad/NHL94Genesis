;	BOOT.BIN $1000-$7FFF (runtime $6000-$CFFF).
;
;	The system program (sub CPU $6000, module MAIN SEGAOS): the header, the service dispatch at $6044
;	(function number in d7), the file table, then the Sierra C SDK code STARTER.BIN has too, and zeros.


TimerCountdown	equ	$8228
PcmServiceEnabled	equ	$822A
PcmEventSlotByte	equ	$982B
PcmEventNoteByte	equ	$982D
PcmEventVelocityByte	equ	$982F
PcmEventSoundByte	equ	$9831
GTableBuffer	equ	$9B58
PlayerCallerSp	equ	$A358
PlayerReturn	equ	$A35C
LoadPointer	equ	$A360
SavedReadHook	equ	$A364
ReadHookFlag	equ	$A368
FilmStopFlag	equ	$A36A
KeptWord	equ	$A36C
SavedTimerVector	equ	$A36E
StarterEntry	equ	$B000

	org	$6000

	dc.b	'MAIN SEGAOS'
	dc.b	$00
	ori.b	#$0,d1
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$20,d0
	ori.b	#$0,d0
	ori.b	#$1E,(a4)+
	dc.w	$000A
	ori.b	#$0,(a4)+
	btst.b	#$5,$FF800F.l
	beq.w	HookReturn
	jmp	(ReadFrameHook).l
	rts
	jmp	(SegaOSMain).l
SegaOSCall
	asl.w	#$2,d7
	addq.w	#$2,d7
	move.w	d7,$6050.l
	bra.w	SegaOSStack
SegaOSCallTable
	bra.w	OSReadSectors
	bra.w	OSLoadResource
	bra.w	OSSetLoadPointer
	bra.w	OSStartTimer
	bra.w	OSReturnFromPlayer
	bra.w	OSRunPlayer
	bra.w	OSGetLoadPointer
	bra.w	OSPlayFilm
	bra.w	OSInitMainSound
	bra.w	OSStopMainSoundHInt
	bra.w	OSStopFilm
	bra.w	OSSetKeptWord
	bra.w	OSGetKeptWord
	bra.w	OSStopTimer
	bra.w	OSGetPcmDriver
	bra.w	OSInitMainSoundDriver
	bra.w	OSCallPcmDriver
SegaOSStack
	dcb.b	400,0
SegaOSStackTop
	ori.b	#$0,d0
SegaOSMain
	lea	(SegaOSStackTop).l,sp
	move.l	#$633E,$6038.l
	jsr	(SyncWithMain).l
.L6240
	bclr.b	#$2,$FF8003.l
	bne.s	.L6240
	jsr	(WaitForSubWordRam).l
	move.b	$FF8004.l,d0
	andi.b	#$F8,d0
	ori.b	#$3,d0
	move.b	d0,$FF8004.l
	lea	(DriveInitParams).l,a0
	move.w	#$10,d0
	jsr	$5F22.l
	move.w	#$0,d1
	move.w	#$96,d0
	jsr	$5F22.l
	move.l	$6038.l,(SavedReadHook).l
	move.l	#$633E,$6038.l
	move.l	#$80000,-(sp)
	move.l	#$1E,-(sp)
	move.l	#$1E,-(sp)
	jsr	(ReadSectors).l
	adda.w	#$C,sp
	move.l	#$9B58,-(sp)
	move.l	#$1,-(sp)
	move.l	#$AA8,-(sp)
	jsr	(ReadSectors).l
	adda.w	#$C,sp
	move.l	(SavedReadHook).l,$6038.l
	move.w	#$89,d0
	jsr	$5F22.l
	move.w	#$8,d0
	jsr	$5F22.l
	jsr	(SyncWithMain).l
	jsr	(GiveWordRamToMain).l
	move.l	$6038.l,(SavedReadHook).l
	move.l	#$633E,$6038.l
	move.l	#$B000,-(sp)
	move.l	#$78,-(sp)
	move.l	#$E2,-(sp)
	jsr	(ReadSectors).l
	adda.w	#$C,sp
	move.l	(SavedReadHook).l,$6038.l
	jsr	(SyncWithMain).l
	jmp	(StarterEntry).l
ReadFrameHook
	move.w	#$FFFF,(ReadHookFlag).l
HookReturn
	rts
	dc.b	'HOCKEY.BIN'
	dc.w	$0000,$5241
	dc.w	$4D2E
	dc.w	$4249
	dc.w	$4E00
	dc.b	'MAIN.BIN'
	dc.w	$0000,$504C
	dc.b	'AYR.BIN'
	dc.b	$00
	dc.b	'START.BIN'
	dc.b	$00
OSReadSectors
	move.l	$6038.l,(SavedReadHook).l
	move.l	#$633E,$6038.l
	move.l	d0,-(sp)
	move.l	d1,-(sp)
	move.l	d2,-(sp)
	jsr	(ReadSectors).l
	adda.w	#$C,sp
	move.l	(SavedReadHook).l,$6038.l
	rts
	dc.w	$0000
OSLoadResource
	move.w	#$3,$63AA.l
	move.l	$6038.l,(SavedReadHook).l
	move.l	#$633E,$6038.l
.L63C8
	btst.b	#$7,$FF800E.l
	bne.s	.L63C8
	move.w	#$2E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L63E2
	btst.b	#$6,$FF800E.l
	beq.s	.L63E2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L63FC
	btst.b	#$6,$FF800E.l
	bne.s	.L63FC
	bclr.b	#$7,$FF800F.l
	move.l	d0,d6
.L6410
	andi.l	#$FFFF,d0
	add.w	d0,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	move.l	(LoadPointer).l,d1
	movea.l	d1,a0
	movea.l	d1,a2
	lea	(GTableBuffer).l,a1
	adda.l	d0,a1
	add.l	$2(a1),d1
	movea.l	d1,a3
	bclr	#$0,d1
	addq.l	#$2,d1
	move.l	d1,(LoadPointer).l
	move.l	$2(a1),d0
	move.l	d0,d1
	lsr.l	#$8,d0
	lsr.l	#$3,d0
	andi.l	#$7FF,d1
	beq.w	.L6458
	addq.l	#$1,d0
.L6458
	clr.l	d1
	move.w	(a1),d1
	addi.w	#$11E,d1
	move.l	a0,-(sp)
	move.l	d0,-(sp)
	move.l	d1,-(sp)
	jsr	(ReadSectors).l
	adda.w	#$C,sp
	subq.l	#$4,a3
	cmpi.l	#$12345678,(a3)
	beq.s	.L6490
	subi.w	#$1,$63AA.l
	beq.w	.L6490
	move.l	d6,d0
	move.l	a2,(LoadPointer).l
	bra.s	.L6410
.L6490
	movea.l	a2,a0
	bclr.b	#$5,$FF800F.l
	move.l	(SavedReadHook).l,$6038.l
.L64A4
	btst.b	#$7,$FF800E.l
	bne.s	.L64A4
	move.w	#$2D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L64BE
	btst.b	#$6,$FF800E.l
	beq.s	.L64BE
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L64D8
	btst.b	#$6,$FF800E.l
	bne.s	.L64D8
	bclr.b	#$7,$FF800F.l
	rts
OSSetLoadPointer
	move.l	a0,(LoadPointer).l
	rts
OSStartTimer
	jsr	(StartTimerInterrupt).l
	rts
OSReturnFromPlayer
	lea	(SegaOSStackTop).l,sp
.L6502
	btst.b	#$7,$FF800E.l
	bne.s	.L6502
	move.w	#$2E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L651C
	btst.b	#$6,$FF800E.l
	beq.s	.L651C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L6536
	btst.b	#$6,$FF800E.l
	bne.s	.L6536
	bclr.b	#$7,$FF800F.l
	move.l	$6038.l,(SavedReadHook).l
	move.l	#$633E,$6038.l
	move.l	#$1B000,-(sp)
	move.l	#$92,-(sp)
	move.l	#$4F,-(sp)
	jsr	(ReadSectors).l
	adda.w	#$C,sp
	bclr.b	#$5,$FF800F.l
	move.l	(SavedReadHook).l,$6038.l
.L658A
	btst.b	#$7,$FF800E.l
	bne.s	.L658A
	move.w	#$2D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L65A4
	btst.b	#$6,$FF800E.l
	beq.s	.L65A4
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L65BE
	btst.b	#$6,$FF800E.l
	bne.s	.L65BE
	bclr.b	#$7,$FF800F.l
	move.l	(PlayerReturn).l,d0
	beq.w	.L65E2
	movea.l	(PlayerCallerSp).l,sp
	rts
.L65E2
	btst.b	#$7,$FF800E.l
	bne.s	.L65E2
	move.w	#$28,$FF8020.l
	bset.b	#$6,$FF800F.l
.L65FC
	btst.b	#$6,$FF800E.l
	beq.s	.L65FC
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L6616
	btst.b	#$6,$FF800E.l
	bne.s	.L6616
	bclr.b	#$7,$FF800F.l
	jmp	$1B000.l
OSRunPlayer
	bsr.w	OSStopMainSoundHInt
	bclr.b	#$5,$FF800F.l
	move.l	(sp),(PlayerReturn).l
	move.l	sp,(PlayerCallerSp).l
	movem.l	d0-d2,-(sp)
.L664A
	btst.b	#$7,$FF800E.l
	bne.s	.L664A
	move.w	#$2E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L6664
	btst.b	#$6,$FF800E.l
	beq.s	.L6664
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L667E
	btst.b	#$6,$FF800E.l
	bne.s	.L667E
	bclr.b	#$7,$FF800F.l
	move.l	$6038.l,(SavedReadHook).l
	move.l	#$633E,$6038.l
	move.l	#$1B000,-(sp)
	move.l	#$16,-(sp)
	move.l	#$26000,(LoadPointer).l
	move.l	#$AA9,-(sp)
	jsr	(ReadSectors).l
	adda.w	#$C,sp
	movem.l	(sp)+,d0-d2
.L66CE
	btst.b	#$7,$FF800E.l
	bne.s	.L66CE
	move.w	#$2D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L66E8
	btst.b	#$6,$FF800E.l
	beq.s	.L66E8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L6702
	btst.b	#$6,$FF800E.l
	bne.s	.L6702
	bclr.b	#$7,$FF800F.l
	jmp	$1B000.l
OSGetLoadPointer
	movea.l	(LoadPointer).l,a0
	rts
OSGetPcmDriver
	movea.l	#$8260,a0
	rts
OSCallPcmDriver
	bsr.w	PcmDriverEntry
	rts
OSSetKeptWord
	move.w	d0,(KeptWord).l
	rts
OSGetKeptWord
	move.w	(KeptWord).l,d0
	rts
OSPlayFilm
	bclr.b	#$0,$FF800F.l
.L6748
	btst.b	#$7,$FF800E.l
	bne.s	.L6748
	move.w	#$25,$FF8020.l
	bset.b	#$6,$FF800F.l
.L6762
	btst.b	#$6,$FF800E.l
	beq.s	.L6762
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L677C
	btst.b	#$6,$FF800E.l
	bne.s	.L677C
	bclr.b	#$7,$FF800F.l
	move.w	#$0,(FilmStopFlag).l
	movea.l	#$FF8000,a5
	move.b	#$0,$FF800F.l
	cmpi.w	#$0,d0
	bne.s	.L67E6
	move.l	a0,-(sp)
	move.l	#$1,-(sp)
	move.l	#$0,-(sp)
	move.l	#$E000,-(sp)
	move.l	#$0,-(sp)
	move.l	#$0,-(sp)
	move.l	#$80000,d0
	sub.l	(LoadPointer).l,d0
	move.l	d0,-(sp)
	move.l	(LoadPointer).l,-(sp)
	move.l	d1,-(sp)
	move.w	#$0,-(sp)
	bra.s	.L6820
.L67E6
	move.l	a0,-(sp)
	move.l	#$0,-(sp)
	move.l	#$7000,-(sp)
	move.l	#$0,-(sp)
	move.l	#$0,-(sp)
	move.l	#$0,-(sp)
	move.l	#$80000,d0
	sub.l	(LoadPointer).l,d0
	move.l	d0,-(sp)
	move.l	(LoadPointer).l,-(sp)
	move.l	d1,-(sp)
	move.w	#$0,-(sp)
.L6820
	jsr	(FilmSwitch).l
	adda.w	#$26,sp
.L682A
	move.w	#$1,-(sp)
	jsr	(FilmSwitch).l
	addq.w	#$2,sp
	tst.w	(FilmStopFlag).l
	bne.s	.L684A
	bset.b	#$0,$FF800F.l
	tst.w	d0
	bge.s	.L682A
.L684A
	bclr.b	#$0,$FF800F.l
	move.w	#$2,-(sp)
	jsr	(FilmSwitch).l
	addq.w	#$2,sp
	move.w	#$0,$FF8020.l
	move.w	#$0,$FF8022.l
	move.w	#$0,$FF8024.l
	move.w	#$0,$FF8026.l
	move.w	#$0,$FF8028.l
	move.w	#$0,$FF802A.l
	move.w	#$0,$FF802C.l
	move.w	#$0,$FF802E.l
	move.b	#$0,$FF800F.l
	jsr	(SyncWithMain).l
.L68AC
	bclr.b	#$2,$FF8003.l
	bne.s	.L68AC
	jsr	(WaitForSubWordRam).l
	move.b	$FF8004.l,d0
	andi.b	#$F8,d0
	ori.b	#$3,d0
	move.b	d0,$FF8004.l
	rts
FilmSwitch
	bra.w	FilmSwitchBody
FilmFrameTicks
	ori.b	#$0,d0
FilmBuffer
	ori.b	#$0,d1
FilmBufferSize
	ori.b	#$0,d6
FilmReadCount
	ori.b	#$0,d0
FilmReadDest
	ori.b	#$0,d0
FilmReadSector
	ori.b	#$0,d0
	ori.b	#$0,d0
FilmDisplayArgs
	dcb.b	20,0
FilmCallback
	ori.b	#$0,d0
FilmReadError
	ori.b	#$0,d0
	ori.b	#$0,d0
FilmState
	dcb.b	160,0
FilmSwitchBody
	tst.w	$4(sp)
	bne.s	.L6A14
	link	a6,#$0
	movem.l	d1-d7/a0-a5,-(sp)
	lea	FilmBufferSize(pc),a0
	move.l	$12(a6),(a0)
	lea	FilmBuffer(pc),a0
	move.l	$E(a6),(a0)
	lea	FilmDisplayArgs(pc),a0
	move.l	$22(a6),(a0)+
	move.l	$1E(a6),(a0)+
	move.l	$1A(a6),(a0)+
	move.l	$16(a6),(a0)+
	move.l	$26(a6),(a0)+
	move.l	$2A(a6),(a0)+
	movea.l	#$FF8000,a5
	ori.w	#$4,$2(a5)
	jsr	InstallFilmHook(pc)
	jsr	InstallFilmReadHook(pc)
	move.l	$A(a6),-(sp)
	jsr	FilmOpen(pc)
	addq.w	#$4,sp
	movem.l	(sp)+,d1-d7/a0-a5
	unlk	a6
	tst.l	d0
	rts
.L6A14
	link	a6,#$0
	movem.l	d1-d7/a0-a5,-(sp)
	move.w	$8(a6),d0
	subq.w	#$1,d0
	bne.s	.L6A2A
	jsr	FilmTask(pc)
	bra.s	.L6A38
.L6A2A
	jsr	FilmClose(pc)
	jsr	RemoveFilmHook(pc)
	jsr	RemoveFilmReadHook(pc)
	moveq	#$0,d0
.L6A38
	movem.l	(sp)+,d1-d7/a0-a5
	unlk	a6
	tst.l	d0
	rts
	move.w	$0.w,d0
.L6A46
	addq.w	#$1,$0.w
	cmp.w	$0.w,d0
	beq.s	.L6A46
	move.w	d0,$0.w
	clr.l	$8.w
	clr.l	$C.w
	clr.l	$10.w
	clr.l	$14.w
	clr.l	$18.w
	clr.l	$1C.w
	clr.l	$20.w
	clr.l	$24.w
	move.l	#$208008,$80.w
	rts
SavedFilmHookJump
	ori.b	#$0,d0
InstallFilmHook
	lea	SavedFilmHookJump(pc),a0
	move.l	$5F36.w,(a0)
	lea	FilmHook(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F36.w
	move.w	(sp)+,sr
	rts
RemoveFilmHook
	movea.l	SavedFilmHookJump(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F36.w
	move.w	(sp)+,sr
	rts
FilmHook
	movem.l	d0/a0,-(sp)
	lea	FilmFrameTicks(pc),a0
	addq.l	#$1,(a0)
	move.l	FilmCallback(pc),d0
	beq.s	.L6AC2
	movea.l	d0,a0
	jsr	(a0)
.L6AC2
	movem.l	(sp)+,d0/a0
	rts
CopySmChunk
	link	a6,#$0
	movem.l	d0-d7/a0-a5,-(sp)
	movea.l	$8(a6),a0
	movea.l	$C(a6),a1
	cmpi.w	#$534D,(a1)
	bne.w	.L6BE2
	move.w	$8(a1),d0
	ext.l	d0
	move.w	$A(a1),d7
	ext.l	d7
	mulu.w	d0,d7
	move.l	d7,d6
	add.l	d6,d6
	addi.w	#$1F,d6
	lsr.w	#$5,d6
	lsl.w	#$2,d6
	move.w	#$C,d0
	move.w	$2(a1),d1
	andi.w	#$3,d1
	beq.s	.L6B0A
	add.w	d6,d0
.L6B0A
	addq.w	#$1,d1
	lsl.w	#$5,d1
	add.w	d1,d0
	lsr.w	#$2,d0
	subq.w	#$1,d0
.L6B14
	move.l	(a1)+,(a0)+
	dbf	d0,.L6B14
	move.l	(a1)+,d0
	movea.l	a1,a2
	adda.l	d0,a1
	move.l	(a1)+,d0
	movea.l	a1,a3
	adda.l	d0,a1
	movea.l	a1,a4
	adda.l	d6,a1
	moveq	#$1,d3
	subq.w	#$1,d7
.L6B2E
	subq.w	#$1,d3
	bne.s	.L6B36
	move.l	(a4)+,d5
	moveq	#$10,d3
.L6B36
	add.l	d5,d5
	bcs.s	.L6B62
	add.l	d5,d5
	bcs.s	.L6B4A
	lea	$20(a0),a0
	dbf	d7,.L6B2E
	bra.w	.L6BE2
.L6B4A
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	dbf	d7,.L6B2E
	bra.w	.L6BE2
.L6B62
	add.l	d5,d5
	bcs.s	.L6B96
	moveq	#$3,d4
.L6B68
	moveq	#$0,d0
	move.b	(a1)+,d0
	lsl.w	#$2,d0
	move.l	(a2,d0.w),d0
	moveq	#$0,d1
	move.b	(a1)+,d1
	lsl.w	#$2,d1
	move.l	(a2,d1.w),d1
	swap	d0
	swap	d1
	move.w	d0,(a0)+
	move.w	d1,(a0)+
	swap	d0
	swap	d1
	move.w	d0,(a0)+
	move.w	d1,(a0)+
	dbf	d4,.L6B68
	dbf	d7,.L6B2E
	bra.s	.L6BE2
.L6B96
	moveq	#$3,d4
.L6B98
	moveq	#$0,d0
	move.b	(a1)+,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d1
	move.b	d1,d2
	lsl.l	#$8,d1
	lsl.l	#$8,d2
	moveq	#$0,d0
	move.b	(a1)+,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d1
	move.b	d1,d2
	lsl.l	#$8,d1
	lsl.l	#$8,d2
	moveq	#$0,d0
	move.b	(a1)+,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d1
	move.b	d1,d2
	lsl.l	#$8,d2
	moveq	#$0,d0
	move.b	(a1)+,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	move.b	d0,d2
	lsr.w	#$8,d0
	move.b	d0,d1
	move.l	d1,(a0)+
	move.l	d2,(a0)+
	dbf	d4,.L6B98
	dbf	d7,.L6B2E
.L6BE2
	movem.l	(sp)+,d0-d7/a0-a5
	unlk	a6
	movea.l	(sp)+,a0
	addq.w	#$8,sp
	jmp	(a0)
InitFilmPcm
	movea.l	#$FF0000,a0
	move.b	#$FF,$11(a0)
	moveq	#$14,d0
.L6BFC
	dbf	d0,.L6BFC
	move.b	#$C0,$F(a0)
	moveq	#$14,d0
.L6C08
	dbf	d0,.L6C08
	move.b	#$FF,$1(a0)
	moveq	#$14,d0
.L6C14
	dbf	d0,.L6C14
	move.b	#$FF,$3(a0)
	moveq	#$14,d0
.L6C20
	dbf	d0,.L6C20
	move.b	#$4,$7(a0)
	moveq	#$14,d0
.L6C2C
	dbf	d0,.L6C2C
	clr.b	$5(a0)
	moveq	#$14,d0
.L6C36
	dbf	d0,.L6C36
	clr.b	$B(a0)
	moveq	#$14,d0
.L6C40
	dbf	d0,.L6C40
	clr.b	$9(a0)
	moveq	#$14,d0
.L6C4A
	dbf	d0,.L6C4A
	clr.b	$D(a0)
	moveq	#$14,d0
.L6C54
	dbf	d0,.L6C54
	move.w	#$88,d0
	move.b	d0,$F(a0)
	moveq	#$14,d0
.L6C62
	dbf	d0,.L6C62
	move.b	#$FF,$2001(a0)
	move.b	#$FF,$2002(a0)
	rts
StartFilmPcm
	movea.l	#$FF0000,a0
	move.b	#$80,$F(a0)
	moveq	#$14,d0
.L6C82
	dbf	d0,.L6C82
	move.b	#$FE,$11(a0)
	rts
StopFilmPcm
	movea.l	#$FF0000,a0
	move.b	#$FF,$11(a0)
	rts
ReadFilmPcmAddress
	movea.l	#$FF0000,a0
	lea	$21(a0),a0
	moveq	#$14,d0
.L6CA8
	dbf	d0,.L6CA8
	move.b	(a0),d1
	move.b	(a0),d1
	addq.w	#$2,a0
	moveq	#$14,d0
.L6CB4
	dbf	d0,.L6CB4
	moveq	#$0,d0
	move.b	(a0),d0
	move.b	(a0),d0
	lsl.w	#$8,d0
	move.b	d1,d0
	rts
LoadFilmPcmBank
	movea.l	#$FF0000,a0
	move.l	$8(sp),d0
	ori.w	#$80,d0
	move.b	d0,$F(a0)
	moveq	#$14,d0
.L6CD8
	dbf	d0,.L6CD8
	move.b	d0,$F(a0)
	moveq	#$14,d0
.L6CE2
	dbf	d0,.L6CE2
	lea	$2001(a0),a0
	movea.l	$4(sp),a1
	move.w	#$1FF,d3
.L6CF2
	move.b	(a1)+,(a0)
	addq.w	#$2,a0
	move.b	(a1)+,(a0)
	addq.w	#$2,a0
	move.b	(a1)+,(a0)
	addq.w	#$2,a0
	move.b	(a1)+,(a0)
	addq.w	#$2,a0
	move.b	(a1)+,(a0)
	addq.w	#$2,a0
	move.b	(a1)+,(a0)
	addq.w	#$2,a0
	move.b	(a1)+,(a0)
	addq.w	#$2,a0
	move.b	(a1)+,(a0)
	addq.w	#$2,a0
	dbf	d3,.L6CF2
	rts
SavedFilmReadJump
	ori.b	#$0,d0
InstallFilmReadHook
	lea	SavedFilmReadJump(pc),a0
	move.l	$5F90.w,(a0)
	lea	FilmReadInterrupt(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F90.w
	move.w	(sp)+,sr
	rts
RemoveFilmReadHook
	movea.l	SavedFilmReadJump(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F90.w
	move.w	(sp)+,sr
	rts
FilmSectorHeader
	ori.b	#$0,d0
FilmReadInterrupt
	movem.l	d0-d3/a0-a2/a5,-(sp)
	pea	.L6D5C(pc)
	move.w	sr,-(sp)
	movea.l	SavedFilmReadJump(pc),a2
	jmp	(a2)
.L6D5C
	movea.l	#$FF8000,a5
	move.l	FilmReadCount(pc),d3
	beq.w	.L6E3A
	bgt.s	.L6DE4
	andi.w	#$F8FF,$4(a5)
	ori.w	#$300,$4(a5)
	move.w	#$8B,d0
	jsr	$5F22.w
	bcs.w	.L6E3A
	move.l	FilmReadDest(pc),d0
	bne.s	.L6D94
	bsr.w	PeekSectDst
	tst.l	d0
	beq.w	.L6E40
.L6D94
	movea.l	d0,a0
	lea	FilmSectorHeader(pc),a1
	move.w	#$8C,d0
	jsr	$5F22.w
	bcs.w	.L6E3A
	move.w	#$8D,d0
	jsr	$5F22.w
	move.l	FilmSectorHeader(pc),d0
	andi.l	#$FFFFFF00,d0
	bsr.w	FilmMsfToLba
	move.l	FilmReadSector(pc),d1
	cmp.l	d0,d1
	bne.s	.L6E3A
	lea	FilmReadDest(pc),a1
	tst.l	(a1)
	beq.s	.L6DD4
	addi.l	#$800,(a1)
	bra.s	.L6DD8
.L6DD4
	bsr.w	GetSectDst
.L6DD8
	neg.l	d3
	subq.w	#$1,d3
	lea	FilmReadCount(pc),a1
	move.l	d3,(a1)
	bra.s	.L6E3A
.L6DE4
	movea.l	#$FF8000,a5
	andi.w	#$F8FF,$4(a5)
	ori.w	#$500,$4(a5)
	move.l	FilmReadDest(pc),d0
	bne.s	.L6E04
	bsr.w	GetSectDst
	tst.l	d0
	beq.s	.L6E40
.L6E04
	lsr.l	#$3,d0
	move.w	d0,$A(a5)
	move.w	#$8B,d0
	jsr	$5F22.w
	bcs.s	.L6E48
.L6E14
	btst.b	#$7,$4(a5)
	beq.s	.L6E14
	bcs.s	.L6E48
	move.w	#$8D,d0
	jsr	$5F22.w
	lea	FilmReadDest(pc),a1
	tst.l	(a1)
	beq.s	.L6E34
	addi.l	#$800,(a1)
.L6E34
	lea	FilmReadCount(pc),a1
	subq.l	#$1,(a1)
.L6E3A
	movem.l	(sp)+,d0-d3/a0-a2/a5
	rte
.L6E40
	lea	FilmReadCount(pc),a1
	clr.l	(a1)
	bra.s	.L6E3A
.L6E48
	lea	FilmReadError(pc),a1
	move.l	#$FFFFFFFF,(a1)
	bra.s	.L6E3A
StopFilmRead
	lea	FilmReadCount(pc),a1
	clr.l	(a1)
	move.w	#$8,d0
	jsr	$5F22.w
	rts
StartFilmRead
	link	a6,#$FFFC
	movem.l	d1-d7/a0-a5,-(sp)
	movea.l	#$FF8000,a5
	lea	FilmReadError(pc),a1
	clr.l	(a1)
	moveq	#$5,d4
	moveq	#-1,d5
	subq.l	#$1,d4
	beq.s	.L6EB6
	moveq	#$0,d0
	move.w	#$96,d0
	jsr	$5F22.w
	move.l	$8(a6),d3
	move.l	$C(a6),d2
	lea	$8(a6),a0
	move.w	#$17,d0
	jsr	$5F22.w
	lea	FilmReadDest(pc),a1
	move.l	$10(a6),(a1)
	lea	FilmReadCount(pc),a1
	neg.l	d2
	move.l	d2,(a1)
	lea	FilmReadSector(pc),a1
	move.l	d3,(a1)
	moveq	#$0,d5
.L6EB6
	move.l	d5,d0
	movem.l	(sp)+,d1-d7/a0-a5
	unlk	a6
	rts
FilmBcdToBinary
	move.l	d1,-(sp)
	move.b	d0,d1
	andi.w	#$FF,d1
	lsr.w	#$4,d1
	mulu.w	#$A,d1
	andi.w	#$F,d0
	add.w	d1,d0
	move.l	(sp)+,d1
	rts
FilmMsfToLba
	movem.l	d1-d2,-(sp)
	lsr.l	#$8,d0
	move.l	d0,d1
	jsr	FilmBcdToBinary(pc)
	move.b	d0,d2
	andi.l	#$FF,d2
	move.l	d1,d0
	lsr.l	#$8,d0
	move.l	d0,d1
	jsr	FilmBcdToBinary(pc)
	andi.l	#$FF,d0
	mulu.w	#$4B,d0
	add.l	d0,d2
	move.l	d1,d0
	lsr.l	#$8,d0
	jsr	FilmBcdToBinary(pc)
	andi.l	#$FF,d0
	mulu.w	#$1194,d0
	add.l	d0,d2
	subi.l	#$96,d2
	move.l	d2,d0
	movem.l	(sp)+,d1-d2
	rts
Wait
	link	a6,#$0
	movem.l	d6-d7,-(sp)
	move.l	$8(a6),d6
	jsr	GetTicks(pc)
	move.l	d0,d7
.L6F36
	jsr	GetTicks(pc)
	move.l	d7,d1
	add.l	d6,d1
	cmp.l	d0,d1
	bgt.s	.L6F36
	movem.l	-$8(a6),d6-d7
	unlk	a6
	rts
	dc.b	$84,'Wait',0,0,0
FilmOpen
	link	a6,#$FFFC
	movem.l	d3/d5-d7/a3-a4,-(sp)
	move.l	$8(a6),d5
	move.l	#$C0000,-$4(a6)
	lea	FilmSwitch(pc),a0
	lea	$40(a0),a4
	jsr	InitWorld(pc)
	move.l	d5,-(sp)
	pea	.L719A(pc)
	jsr	aprint(pc)
	moveq	#-1,d0
	move.l	d0,$40(a4)
	pea	$800.w
	jsr	mmalloc(pc)
	movea.l	d0,a3
	move.l	a3,d0
	lea	$C(sp),sp
	bne.s	.L6F9C
	moveq	#-1,d0
	bra.w	.L714C
.L6F9C
	move.l	a3,-(sp)
	moveq	#$1,d0
	move.l	d0,-(sp)
	move.l	d5,-(sp)
	jsr	StartFilmRead(pc)
	jsr	WaitIODone(pc)
	cmpi.l	#$46494C4D,(a3)
	lea	$C(sp),sp
	beq.s	.L6FCA
	move.l	d5,-(sp)
	pea	.L7188(pc)
	jsr	aprint(pc)
	moveq	#-1,d0
	addq.w	#$8,sp
	bra.w	.L714C
.L6FCA
	move.l	$4(a3),d7
	move.l	d7,d0
	dc.w	$D0BC,$0000,$07FF
	move.l	#$800,d1
	jsr	LongModulo(pc)
	move.l	d0,d6
	moveq	#$1,d0
	cmp.l	d6,d0
	bge.s	.L7032
	move.l	a3,-(sp)
	jsr	ffree(pc)
	move.l	d6,d1
	move.l	d1,d0
	mulu.w	#$800,d1
	swap	d0
	mulu.w	#$800,d0
	swap	d0
	clr.w	d0
	add.l	d0,d1
	move.l	d1,-(sp)
	jsr	mmalloc(pc)
	movea.l	d0,a3
	move.l	a3,d0
	addq.w	#$8,sp
	bne.s	.L7016
	moveq	#-1,d0
	bra.w	.L714C
.L7016
	move.l	d6,-(sp)
	pea	.L7178(pc)
	jsr	aprint(pc)
	move.l	a3,-(sp)
	move.l	d6,-(sp)
	move.l	d5,-(sp)
	jsr	StartFilmRead(pc)
	jsr	WaitIODone(pc)
	lea	$14(sp),sp
.L7032
	move.l	$4(a3),$8(a4)
	move.l	a3,d0
	moveq	#$10,d1
	add.l	d1,d0
	move.l	d0,$C(a4)
	movea.l	d0,a0
	move.l	$4(a0),d0
	add.l	$C(a4),d0
	move.l	d0,$10(a4)
	move.l	a3,$14(a4)
	pea	.L716C(pc)
	jsr	aprint(pc)
	move.l	d5,-(sp)
	pea	$18(a4)
	jsr	InitEngine(pc)
	tst.w	d0
	lea	$C(sp),sp
	beq.s	.L7074
	moveq	#-1,d0
	bra.w	.L714C
.L7074
	pea	$18(a4)
	jsr	EngineIdle(pc)
	pea	.L7162(pc)
	jsr	aprint(pc)
	moveq	#$0,d5
	move.l	d5,d6
	move.l	d6,d7
	addq.w	#$8,sp
	bra.s	.L70B4
.L708E
	movea.l	$10(a4),a0
	move.l	d7,d0
	asl.l	#$4,d0
	lea	$10(a0,d0.l),a3
	moveq	#-1,d0
	cmp.l	$8(a3),d0
	seq.b	d3
	neg.b	d3
	beq.s	.L70AC
	move.l	d5,d0
	addq.l	#$1,d5
	bra.s	.L70B0
.L70AC
	move.l	d6,d0
	addq.l	#$1,d6
.L70B0
	move.l	d7,d0
	addq.l	#$1,d7
.L70B4
	movea.l	$10(a4),a0
	cmp.l	$C(a0),d7
	blt.s	.L708E
	lea	FilmSwitch(pc),a0
	moveq	#$0,d0
	move.l	d0,$3C(a0)
	tst.l	d6
	bne.s	.L70D6
	lea	FilmSwitch(pc),a0
	moveq	#-1,d0
	move.l	d0,$3C(a0)
.L70D6
	tst.l	d5
	bne.s	.L70E4
	lea	FilmSwitch(pc),a0
	moveq	#$1,d0
	move.l	d0,$3C(a0)
.L70E4
	lea	FilmSwitch(pc),a0
	movea.l	-$4(a6),a1
	move.l	$20(a0),(a1)
	lea	FilmSwitch(pc),a0
	lea	FilmSwitch(pc),a1
	move.l	$28(a1),d0
	add.l	d0,d0
	add.l	$24(a0),d0
	lea	FilmSwitch(pc),a0
	move.l	$2C(a0),d1
	asl.l	#$7,d1
	add.l	d0,d1
	movea.l	-$4(a6),a0
	move.l	d1,$4(a0)
	lea	FilmSwitch(pc),a0
	movea.l	-$4(a6),a1
	move.l	$30(a0),$8(a1)
	jsr	SwapMeg(pc)
	moveq	#$3,d0
	move.l	d0,-(sp)
	jsr	SendCommandToMain(pc)
	moveq	#$0,d0
	move.l	d0,$40(a4)
	moveq	#$3C,d0
	move.l	d0,-(sp)
	jsr	Wait(pc)
	pea	$30(a4)
	jsr	AudioInit(pc)
	moveq	#$0,d0
	lea	$C(sp),sp
.L714C
	movem.l	-$1C(a6),d3/d5-d7/a3-a4
	unlk	a6
	rts
	dc.b	$88,'FilmOpen',0
	dc.w	$0048
.L7162
	dc.b	'Film Open'
	dc.b	$00
.L716C
	dc.b	'InitEngine'
	dc.w	$0000
.L7178
	dc.b	'HeaderSects: %d'
	dc.b	$00
.L7188
	dc.b	'Film at %d is bad'
	dc.b	$00
.L719A
	dc.b	'FilmOpening %d'
	dc.w	$0000
FilmTask
	link	a6,#$FFFC
	movem.l	d6-d7/a3-a4,-(sp)
	move.l	#$C0000,-$4(a6)
	lea	FilmSwitch(pc),a0
	lea	$40(a0),a4
	lea	FilmSwitch(pc),a0
	tst.l	$38(a0)
	beq.s	.L71D2
	moveq	#-2,d0
	bra.w	.L736C
.L71D2
	tst.l	$40(a4)
	bge.s	.L71DE
	moveq	#-1,d0
	bra.w	.L736C
.L71DE
	lea	FilmSwitch(pc),a0
	moveq	#$1,d0
	cmp.l	$3C(a0),d0
	bne.s	.L71F4
	pea	$30(a4)
	jsr	AudioSilence(pc)
	addq.w	#$4,sp
.L71F4
	pea	$30(a4)
	jsr	AudioIdle(pc)
	pea	$18(a4)
	jsr	EngineIdle(pc)
	movea.l	$10(a4),a0
	move.l	$40(a4),d0
	addq.l	#$1,$40(a4)
	asl.l	#$4,d0
	lea	$10(a0,d0.l),a3
	moveq	#-1,d0
	cmp.l	$8(a3),d0
	addq.w	#$8,sp
	bne.w	.L72C4
	bra.s	.L7236
.L7224
	pea	$18(a4)
	jsr	EngineIdle(pc)
	pea	$30(a4)
	jsr	AudioIdle(pc)
	addq.w	#$8,sp
.L7236
	move.l	$4(a3),-(sp)
	move.l	(a3),d0
	add.l	$8(a4),d0
	move.l	d0,-(sp)
	pea	$18(a4)
	jsr	GetData(pc)
	move.l	d0,d7
	lea	$C(sp),sp
	beq.s	.L7224
	moveq	#-1,d0
	cmp.l	d7,d0
	bne.s	.L725E
	moveq	#-2,d0
	bra.w	.L736C
.L725E
	move.l	$4(a3),-(sp)
	move.l	d7,-(sp)
	pea	$30(a4)
	jsr	AudioFeed(pc)
	lea	FilmSwitch(pc),a0
	moveq	#-1,d0
	cmp.l	$3C(a0),d0
	lea	$C(sp),sp
	bne.s	.L7296
	bra.s	.L7288
.L727E
	pea	$30(a4)
	jsr	AudioIdle(pc)
	addq.w	#$4,sp
.L7288
	pea	$30(a4)
	jsr	AudioBusy(pc)
	tst.w	d0
	addq.w	#$4,sp
	bne.s	.L727E
.L7296
	move.l	$4(a3),-(sp)
	move.l	(a3),d0
	add.l	$8(a4),d0
	move.l	d0,-(sp)
	pea	$18(a4)
	jsr	ReadData(pc)
	lea	$C(sp),sp
	bra.w	.L7354
.L72B2
	pea	$30(a4)
	jsr	AudioIdle(pc)
	pea	$18(a4)
	jsr	EngineIdle(pc)
	addq.w	#$8,sp
.L72C4
	move.l	$4(a3),-(sp)
	move.l	(a3),d0
	add.l	$8(a4),d0
	move.l	d0,-(sp)
	pea	$18(a4)
	jsr	GetData(pc)
	move.l	d0,d7
	lea	$C(sp),sp
	beq.s	.L72B2
	moveq	#-1,d0
	cmp.l	d7,d0
	bne.s	.L72EC
	moveq	#-2,d0
	bra.w	.L736C
.L72EC
	movea.l	d7,a0
	cmpi.w	#$534D,(a0)
	bne.s	.L733C
	move.l	#$7FFFFFFF,d6
	and.l	$8(a3),d6
	move.l	d7,-(sp)
	move.l	-$4(a6),-(sp)
	jsr	CopySmChunk(pc)
	bra.s	.L731C
.L730A
	pea	$30(a4)
	jsr	AudioIdle(pc)
	pea	$18(a4)
	jsr	EngineIdle(pc)
	addq.w	#$8,sp
.L731C
	pea	$258.w
	pea	$30(a4)
	jsr	AudioTime(pc)
	cmp.l	d0,d6
	addq.w	#$8,sp
	bgt.s	.L730A
	jsr	SwapMeg(pc)
	moveq	#$2,d0
	move.l	d0,-(sp)
	jsr	SendCommandToMain(pc)
	addq.w	#$4,sp
.L733C
	move.l	$4(a3),-(sp)
	move.l	(a3),d0
	add.l	$8(a4),d0
	move.l	d0,-(sp)
	pea	$18(a4)
	jsr	ReadData(pc)
	lea	$C(sp),sp
.L7354
	movea.l	$10(a4),a0
	move.l	$40(a4),d0
	cmp.l	$C(a0),d0
	bne.s	.L7368
	moveq	#-1,d0
	move.l	d0,$40(a4)
.L7368
	move.l	$40(a4),d0
.L736C
	movem.l	-$14(a6),d6-d7/a3-a4
	unlk	a6
	rts
	dc.b	$88,'FilmTask',0,0,0
FilmClose
	link	a6,#$0
	move.l	a4,-(sp)
	lea	FilmSwitch(pc),a0
	lea	$40(a0),a4
	pea	$30(a4)
	jsr	AudioStop(pc)
	jsr	StopFilmRead(pc)
	pea	$18(a4)
	jsr	DisposeEngine(pc)
	moveq	#-1,d0
	move.l	d0,$40(a4)
	move.l	$14(a4),-(sp)
	jsr	ffree(pc)
	moveq	#$3,d0
	move.l	d0,-(sp)
	jsr	SendCommandToMain(pc)
	moveq	#$0,d0
	movea.l	-$4(a6),a4
	unlk	a6
	rts
	dc.b	$89,'FilmClose',0,0
SwapMeg
	link	a6,#$0
.L73D4
	movea.l	#$FF8010,a0
	tst.w	$2(a0)
	bne.s	.L73D4
	eori.w	#$1,$FF8002.l
	unlk	a6
	rts
	dc.b	$87,'SwapMeg',0,0
DrawText
	link	a6,#$0
	movem.l	d7/a4,-(sp)
	movea.l	$8(a6),a4
	moveq	#$1,d0
	move.l	d0,-(sp)
	jsr	SendCommandToMain(pc)
	moveq	#$3C,d0
	move.l	d0,-(sp)
	jsr	SendCommandToMain(pc)
	addq.w	#$8,sp
	bra.s	.L7422
.L7416
	ext.w	d7
	ext.l	d7
	move.l	d7,-(sp)
	jsr	SendCommandToMain(pc)
	addq.w	#$4,sp
.L7422
	move.b	(a4)+,d7
	bne.s	.L7416
	moveq	#$3E,d0
	move.l	d0,-(sp)
	jsr	SendCommandToMain(pc)
	moveq	#$1,d0
	move.l	d0,-(sp)
	jsr	SendCommandToMain(pc)
	addq.w	#$8,sp
	movem.l	-$8(a6),d7/a4
	unlk	a6
	rts
	dc.b	$88,'DrawText',0,0,0
NumStr
	link	a6,#$FFF0
	movem.l	d6-d7/a3-a4,-(sp)
	movea.l	$10(a6),a3
	lea	-$10(a6),a4
	move.l	$8(a6),d6
	clr.w	d7
	move.w	d7,d0
	addq.w	#$1,d7
	clr.b	(a4,d0.w)
.L746C
	move.l	d6,d0
	moveq	#$A,d1
	jsr	LongDivide(pc)
	moveq	#$30,d1
	add.b	d1,d0
	move.w	d7,d1
	addq.w	#$1,d7
	move.b	d0,(a4,d1.w)
	move.l	d6,d0
	moveq	#$A,d1
	jsr	LongModulo(pc)
	move.l	d0,d6
	bne.s	.L746C
	bra.s	.L7494
.L748E
	subq.w	#$1,d7
	move.b	(a4,d7.w),(a3)+
.L7494
	tst.w	d7
	bne.s	.L748E
	movem.l	-$20(a6),d6-d7/a3-a4
	unlk	a6
	rts
	dc.b	$86,'NumStr',0,0,0
HexStr
	link	a6,#$0
	movem.l	d3-d7/a4,-(sp)
	move.w	$E(a6),d4
	move.l	$8(a6),d5
	movea.l	$10(a6),a4
	ext.l	d4
	move.l	d4,d7
	subq.l	#$1,d7
	moveq	#$0,d3
	bra.s	.L74F0
.L74CA
	moveq	#$F,d6
	and.l	d5,d6
	asr.l	#$4,d5
	moveq	#$9,d0
	cmp.l	d6,d0
	blt.s	.L74E2
	move.b	d6,d0
	moveq	#$30,d1
	add.b	d1,d0
	move.b	d0,(a4,d7.l)
	bra.s	.L74EC
.L74E2
	move.b	d6,d0
	moveq	#-55,d1
	sub.b	d1,d0
	move.b	d0,(a4,d7.l)
.L74EC
	move.l	d7,d0
	subq.l	#$1,d7
.L74F0
	cmp.l	d7,d3
	ble.s	.L74CA
	clr.b	(a4,d4.w)
	movem.l	-$18(a6),d3-d7/a4
	unlk	a6
	rts
	dc.b	$86,'HexStr',0,0,0
aprint
	link	a6,#$FED8
	movem.l	d4-d7/a3-a4,-(sp)
	lea	-$128(a6),a4
	lea	-$108(a6),a3
	lea	$8(a6),a0
	addq.w	#$4,a0
	move.l	a0,-$4(a6)
	bra.w	.L7612
.L752A
	cmpi.b	#$25,d6
	beq.s	.L7536
	move.b	d6,(a3)+
	bra.w	.L7612
.L7536
	moveq	#$8,d4
	movea.l	$8(a6),a0
	addq.l	#$1,$8(a6)
	move.b	(a0),d6
	move.b	d6,d0
	subi.b	#$2A,d0
	bne.s	.L7562
	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.w	-$2(a0),d4
	move.l	$8(a6),d0
	addq.l	#$1,$8(a6)
	movea.l	d0,a0
	move.b	(a0),d6
.L7562
	move.b	d6,d0
	subi.b	#$25,d0
	beq.w	.L7610
	subi.b	#$2E,d0
	beq.s	.L75EA
	subq.b	#$5,d0
	beq.s	.L75BA
	subi.b	#$C,d0
	beq.s	.L758A
	subi.b	#$F,d0
	beq.s	.L75EA
	subq.b	#$5,d0
	beq.s	.L75BA
	bra.w	.L7612
.L758A
	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),d5
	move.l	a4,-(sp)
	ext.l	d4
	move.l	d4,-(sp)
	move.l	d5,-(sp)
	jsr	NumStr(pc)
	clr.w	d7
	lea	$C(sp),sp
	bra.s	.L75B2
.L75AA
	move.b	(a4,d7.w),(a3)+
	move.w	d7,d0
	addq.w	#$1,d7
.L75B2
	tst.b	(a4,d7.w)
	bne.s	.L75AA
	bra.s	.L7612
.L75BA
	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),d5
	move.l	a4,-(sp)
	ext.l	d4
	move.l	d4,-(sp)
	move.l	d5,-(sp)
	jsr	HexStr(pc)
	clr.w	d7
	lea	$C(sp),sp
	bra.s	.L75E2
.L75DA
	move.b	(a4,d7.w),(a3)+
	move.w	d7,d0
	addq.w	#$1,d7
.L75E2
	tst.b	(a4,d7.w)
	bne.s	.L75DA
	bra.s	.L7612
.L75EA
	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),-$8(a6)
	bra.s	.L7606
.L75FA
	move.l	-$8(a6),d0
	addq.l	#$1,-$8(a6)
	movea.l	d0,a0
	move.b	(a0),(a3)+
.L7606
	movea.l	-$8(a6),a0
	tst.b	(a0)
	bne.s	.L75FA
	bra.s	.L7612
.L7610
	move.b	d6,(a3)+
.L7612
	move.l	$8(a6),d0
	addq.l	#$1,$8(a6)
	movea.l	d0,a0
	move.b	(a0),d6
	bne.w	.L752A
	clr.b	(a3)+
	pea	-$108(a6)
	jsr	DrawText(pc)
	addq.w	#$4,sp
	movem.l	-$140(a6),d4-d7/a3-a4
	unlk	a6
	rts
	dc.b	$86,'aprint',0,0,0
ffree
	link	a6,#$0
	movem.l	a3-a4,-(sp)
	movea.l	$8(a6),a3
	movea.l	a3,a4
	lea	-$10(a4),a4
	move.l	a3,d0
	beq.s	.L7666
	moveq	#$48,d0
	cmp.b	(a4),d0
	bne.s	.L7666
	moveq	#$42,d0
	cmp.b	$1(a4),d0
	beq.s	.L7674
.L7666
	move.l	a4,-(sp)
	pea	.L76F6(pc)
	jsr	aprint(pc)
	addq.w	#$8,sp
	bra.s	.L76C4
.L7674
	tst.w	$2(a4)
	bne.s	.L7688
	move.l	a4,-(sp)
	pea	.L76D6(pc)
	jsr	aprint(pc)
	addq.w	#$8,sp
	bra.s	.L76C4
.L7688
	tst.l	$4(a4)
	beq.s	.L76AA
	movea.l	$4(a4),a0
	tst.w	$2(a0)
	bne.s	.L76AA
	move.l	$8(a4),$8(a0)
	movea.l	$4(a4),a4
	movea.l	$8(a4),a0
	move.l	a4,$4(a0)
.L76AA
	movea.l	$8(a4),a0
	tst.w	$2(a0)
	bne.s	.L76C0
	movea.l	$8(a0),a0
	move.l	a0,$8(a4)
	move.l	a4,$4(a0)
.L76C0
	clr.w	$2(a4)
.L76C4
	movem.l	-$8(a6),a3-a4
	unlk	a6
	rts
	dc.b	$85,'ffree'
	dc.w	$0040
.L76D6
	dc.b	'Tried to ffree a free block: %x'
	dc.b	$00
.L76F6
	dc.b	'Tried to ffree a bad block: %x'
	dc.w	$0000
findSmallestBlock
	link	a6,#$0
	movem.l	d5-d7/a3-a4,-(sp)
	move.l	$8(a6),d5
	lea	FilmSwitch(pc),a0
	movea.l	$8(a0),a4
	moveq	#$0,d0
	movea.l	d0,a3
	move.l	#$7FFFFFFF,d6
	bra.s	.L7758
.L7736
	tst.w	$2(a4)
	bne.s	.L7754
	move.l	$8(a4),d0
	sub.l	a4,d0
	move.l	d0,d7
	moveq	#$10,d0
	sub.l	d0,d7
	cmp.l	d7,d5
	bge.s	.L7754
	cmp.l	d7,d6
	ble.s	.L7754
	move.l	d7,d6
	movea.l	a4,a3
.L7754
	movea.l	$8(a4),a4
.L7758
	move.l	a4,d0
	bne.s	.L7736
	move.l	a3,d0
	movem.l	-$14(a6),d5-d7/a3-a4
	unlk	a6
	rts
	dc.b	$91,'findSmallestBlock',0,0
MaxFree
	link	a6,#$0
	movem.l	d6-d7/a4,-(sp)
	lea	FilmSwitch(pc),a0
	movea.l	$8(a0),a4
	moveq	#-1,d6
	bra.s	.L77AC
.L7790
	tst.w	$2(a4)
	bne.s	.L77A8
	move.l	$8(a4),d0
	sub.l	a4,d0
	move.l	d0,d7
	moveq	#$10,d0
	sub.l	d0,d7
	cmp.l	d7,d6
	bge.s	.L77A8
	move.l	d7,d6
.L77A8
	movea.l	$8(a4),a4
.L77AC
	move.l	a4,d0
	bne.s	.L7790
	move.l	d6,d0
	movem.l	-$C(a6),d6-d7/a4
	unlk	a6
	rts
	dc.b	$87,'MaxFree',0,0
mmalloc
	link	a6,#$0
	movem.l	d6-d7/a3-a4,-(sp)
	move.l	$8(a6),d7
	move.l	d7,d0
	addq.l	#$7,d0
	moveq	#-8,d1
	and.l	d0,d1
	move.l	d1,d7
	move.l	d7,-(sp)
	jsr	findSmallestBlock(pc)
	movea.l	d0,a3
	move.l	a3,d0
	addq.w	#$4,sp
	bne.s	.L77EE
	moveq	#$0,d0
	bra.s	.L7844
.L77EE
	move.l	$8(a3),d0
	sub.l	a3,d0
	move.l	d0,d6
	moveq	#$10,d0
	sub.l	d0,d6
	move.l	d7,d1
	moveq	#$18,d2
	add.l	d2,d1
	cmp.l	d6,d1
	bge.s	.L7838
	move.l	a3,d0
	moveq	#$10,d1
	add.l	d1,d0
	movea.l	d0,a4
	adda.l	d7,a4
	move.b	#$48,(a4)
	move.b	#$42,$1(a4)
	clr.w	$2(a4)
	move.l	a3,$4(a4)
	move.l	$8(a3),$8(a4)
	moveq	#$0,d0
	move.l	d0,$C(a4)
	movea.l	$8(a4),a0
	move.l	a4,$4(a0)
	move.l	a4,$8(a3)
.L7838
	move.w	#$1,$2(a3)
	move.l	a3,d0
	moveq	#$10,d1
	add.l	d1,d0
.L7844
	movem.l	-$10(a6),d6-d7/a3-a4
	unlk	a6
	rts
	dc.b	$87,'mmalloc',0,0
InitHeap
	link	a6,#$0
	movem.l	a3-a4,-(sp)
	lea	FilmSwitch(pc),a0
	movea.l	$8(a0),a3
	lea	FilmSwitch(pc),a0
	lea	FilmSwitch(pc),a1
	move.l	$C(a1),d0
	add.l	$8(a0),d0
	movea.l	d0,a4
	lea	-$10(a4),a4
	move.b	#$48,(a3)
	move.b	#$42,$1(a3)
	clr.w	$2(a3)
	moveq	#$0,d0
	move.l	d0,$4(a3)
	move.l	a4,$8(a3)
	move.l	d0,$C(a3)
	move.b	#$48,(a4)
	move.b	#$45,$1(a4)
	move.w	#$2,$2(a4)
	move.l	a3,$4(a4)
	move.l	d0,$8(a4)
	move.l	d0,$C(a4)
	movem.l	-$8(a6),a3-a4
	unlk	a6
	rts
	dc.b	$88,'InitHeap',0,0,0
InitWorld
	link	a6,#$0
	move.l	d7,-(sp)
	clr.w	$FF8020.l
	pea	.L799A(pc)
	jsr	aprint(pc)
	lea	FilmSwitch(pc),a0
	moveq	#$F,d7
	and.l	$8(a0),d7
	tst.l	d7
	addq.w	#$4,sp
	beq.s	.L78FA
	pea	.L798E(pc)
	jsr	aprint(pc)
	addq.w	#$4,sp
.L78FA
	lea	FilmSwitch(pc),a0
	move.l	$8(a0),d0
	moveq	#$F,d1
	add.l	d1,d0
	moveq	#-16,d2
	and.l	d0,d2
	lea	FilmSwitch(pc),a0
	move.l	d2,$8(a0)
	lea	FilmSwitch(pc),a0
	move.l	$C(a0),d0
	sub.l	d7,d0
	moveq	#-16,d2
	and.l	d0,d2
	lea	FilmSwitch(pc),a0
	move.l	d2,$C(a0)
	lea	FilmSwitch(pc),a0
	move.l	$8(a0),-(sp)
	pea	.L797E(pc)
	jsr	aprint(pc)
	lea	FilmSwitch(pc),a0
	move.l	$C(a0),-(sp)
	pea	.L796E(pc)
	jsr	aprint(pc)
	lea	FilmSwitch(pc),a0
	tst.l	$C(a0)
	lea	$10(sp),sp
	beq.s	.L795A
	jsr	InitHeap(pc)
.L795A
	move.l	-$4(a6),d7
	unlk	a6
	rts
	dc.b	$89,'InitWorld'
	dc.w	$003C
.L796E
	dc.b	'Heap Size : %x'
	dc.w	$0000
.L797E
	dc.b	'Heap Start: %x'
	dc.w	$0000
.L798E
	dc.b	'Fixing Heap'
	dc.b	$00
.L799A
	dc.b	'SUBCPU is alive'
	dc.b	$00
GetTicks
	link	a6,#$0
	lea	FilmSwitch(pc),a0
	move.l	$4(a0),d0
	unlk	a6
	rts
	dc.b	$88,'GetTicks',0,0,0
WaitIODone
	link	a6,#$0
.L79CA
	lea	FilmSwitch(pc),a0
	tst.l	$10(a0)
	bne.s	.L79CA
	unlk	a6
	rts
	dc.b	$8A,'WaitIODone',0,0,0
SendCommandToMain
	link	a6,#$0
	movem.l	a3-a4,-(sp)
	movea.l	#$FF8010,a4
	movea.l	#$FF8020,a3
.L79FA
	tst.w	(a4)
	bne.s	.L79FA
	move.w	$A(a6),(a3)
.L7A02
	tst.w	(a4)
	beq.s	.L7A02
	clr.w	(a3)
	movem.l	-$8(a6),a3-a4
	unlk	a6
	rts
	dc.b	$91,'SendCommandToMain',0,0
CopyData
	link	a6,#$0
	movem.l	d4-d7,-(sp)
	move.l	$C(a6),d4
	move.l	$8(a6),d5
	move.l	$10(a6),d6
	move.l	d6,d0
	addq.l	#$3,d0
	asr.l	#$2,d0
	move.l	d0,d6
	moveq	#$0,d7
	bra.s	.L7A54
.L7A46
	movea.l	d5,a0
	addq.l	#$4,d5
	movea.l	d4,a1
	addq.l	#$4,d4
	move.l	(a0),(a1)
	move.l	d7,d0
	addq.l	#$1,d7
.L7A54
	cmp.l	d7,d6
	bgt.s	.L7A46
	movem.l	-$10(a6),d4-d7
	unlk	a6
	rts
	dc.b	$88,'CopyData',0,0,0
InitEngine
	link	a6,#$0
	movem.l	d7/a4,-(sp)
	movea.l	$8(a6),a4
	jsr	MaxFree(pc)
	move.l	d0,d7
	cmpi.l	#$14000,d7
	bge.s	.L7A8C
	moveq	#-1,d0
	bra.s	.L7AFE
.L7A8C
	cmpi.l	#$34000,d7
	ble.s	.L7A9A
	move.l	#$34000,d7
.L7A9A
	move.l	d7,d0
	dc.w	$90BC,$0000,$4000
	move.l	#$800,d1
	jsr	LongModulo(pc)
	move.l	d0,d1
	mulu.w	#$800,d0
	swap	d1
	mulu.w	#$800,d1
	swap	d1
	clr.w	d1
	add.l	d1,d0
	move.l	d0,$4(a4)
	dc.w	$D0BC,$0000,$4000
	move.l	d0,-(sp)
	jsr	mmalloc(pc)
	move.l	d0,(a4)
	addq.w	#$4,sp
	bne.s	.L7AD8
	moveq	#-1,d0
	bra.s	.L7AFE
.L7AD8
	moveq	#$0,d0
	move.l	d0,$8(a4)
	move.l	d0,$C(a4)
	move.l	$C(a6),$10(a4)
	move.l	d0,$14(a4)
	lea	FilmSwitch(pc),a0
	move.l	a4,$1C(a0)
	move.l	a4,-(sp)
	jsr	EngineIdle(pc)
	moveq	#$0,d0
	addq.w	#$4,sp
.L7AFE
	movem.l	-$8(a6),d7/a4
	unlk	a6
	rts
	dc.b	$8A,'InitEngine',0,0,0
DisposeEngine
	link	a6,#$0
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	tst.l	(a4)
	beq.s	.L7B2C
	move.l	(a4),-(sp)
	jsr	ffree(pc)
	addq.w	#$4,sp
.L7B2C
	movea.l	-$4(a6),a4
	unlk	a6
	rts
	dc.b	$8D,'DisposeEngine',0,0
GetSectDst
	link	a6,#$0
	movem.l	d7/a4,-(sp)
	lea	FilmSwitch(pc),a0
	movea.l	$1C(a0),a4
	moveq	#$0,d7
	move.l	$8(a4),d0
	sub.l	$C(a4),d0
	dc.w	$D0BC,$0000,$0800
	cmp.l	$4(a4),d0
	bge.s	.L7B86
	move.l	$8(a4),d0
	move.l	$4(a4),d1
	jsr	LongDivide(pc)
	move.l	d0,d7
	add.l	(a4),d7
	addq.l	#$1,$10(a4)
	addi.l	#$800,$8(a4)
.L7B86
	move.l	d7,d0
	movem.l	-$8(a6),d7/a4
	unlk	a6
	rts
	dc.b	$8A,'GetSectDst',0,0,0
PeekSectDst
	link	a6,#$0
	movem.l	d7/a4,-(sp)
	lea	FilmSwitch(pc),a0
	movea.l	$1C(a0),a4
	moveq	#$0,d7
	move.l	$8(a4),d0
	sub.l	$C(a4),d0
	dc.w	$D0BC,$0000,$0800
	cmp.l	$4(a4),d0
	bge.s	.L7BD6
	move.l	$8(a4),d0
	move.l	$4(a4),d1
	jsr	LongDivide(pc)
	move.l	d0,d7
	add.l	(a4),d7
.L7BD6
	move.l	d7,d0
	movem.l	-$8(a6),d7/a4
	unlk	a6
	rts
	dc.b	$8B,'PeekSectDst',0,0
EngineIdle
	link	a6,#$0
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	lea	FilmSwitch(pc),a0
	tst.l	$10(a0)
	bne.s	.L7C2E
	move.l	$8(a4),d0
	sub.l	$C(a4),d0
	move.l	$4(a4),d1
	sub.l	d0,d1
	cmpi.l	#$8000,d1
	blt.s	.L7C2E
	moveq	#$0,d0
	move.l	d0,-(sp)
	pea	$1000.w
	move.l	$10(a4),-(sp)
	jsr	StartFilmRead(pc)
	lea	$C(sp),sp
.L7C2E
	movea.l	-$4(a6),a4
	unlk	a6
	rts
	dc.b	$8A,'EngineIdle',0,0,0
GetData
	link	a6,#$0
	movem.l	d5-d7/a4,-(sp)
	move.l	$10(a6),d6
	move.l	$C(a6),d7
	movea.l	$8(a6),a4
	bra.s	.L7C72
.L7C5A
	move.l	a4,-(sp)
	jsr	EngineIdle(pc)
	lea	FilmSwitch(pc),a0
	moveq	#-1,d0
	cmp.l	$38(a0),d0
	addq.w	#$4,sp
	bne.s	.L7C72
	moveq	#-1,d0
	bra.s	.L7CAC
.L7C72
	move.l	d7,d0
	add.l	d6,d0
	cmp.l	$8(a4),d0
	bgt.s	.L7C5A
	move.l	d7,d0
	move.l	$4(a4),d1
	jsr	LongDivide(pc)
	move.l	d0,d5
	add.l	d6,d0
	move.l	d0,d7
	sub.l	$4(a4),d7
	tst.l	d7
	ble.s	.L7CA8
	move.l	d7,-(sp)
	move.l	$4(a4),d0
	add.l	(a4),d0
	move.l	d0,-(sp)
	move.l	(a4),-(sp)
	jsr	CopyData(pc)
	lea	$C(sp),sp
.L7CA8
	add.l	(a4),d5
	move.l	d5,d0
.L7CAC
	movem.l	-$10(a6),d5-d7/a4
	unlk	a6
	rts
	dc.b	$87,'GetData',0,0
ReadData
	link	a6,#$0
	move.l	$10(a6),d0
	add.l	$C(a6),d0
	movea.l	$8(a6),a0
	move.l	d0,$C(a0)
	unlk	a6
	rts
	dc.b	$88,'ReadData',0,0,0
AudioPlayPos
	link	a6,#$FFFC
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	moveq	#-1,d0
	cmp.l	(a4),d0
	bne.s	.L7CF8
	moveq	#$0,d0
	bra.s	.L7D18
.L7CF8
	jsr	ReadFilmPcmAddress(pc)
	moveq	#$C,d1
	asr.l	d1,d0
	move.l	d0,-$4(a6)
	move.l	(a4),d0
	moveq	#$8,d1
	jsr	LongDivide(pc)
	move.l	-$4(a6),d1
	cmp.l	d1,d0
	beq.s	.L7D16
	addq.l	#$1,(a4)
.L7D16
	move.l	(a4),d0
.L7D18
	movea.l	-$8(a6),a4
	unlk	a6
	rts
	dc.b	$8C,'AudioPlayPos',0,0,0
AudioInit
	link	a6,#$0
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	moveq	#-1,d0
	move.l	d0,(a4)
	moveq	#$0,d1
	move.l	d1,$4(a4)
	move.l	d1,$8(a4)
	move.l	d1,$C(a4)
	jsr	InitFilmPcm(pc)
	movea.l	-$4(a6),a4
	unlk	a6
	rts
	dc.b	$89,'AudioInit',0,0
AudioIdle
	link	a6,#$0
	movem.l	d7/a4,-(sp)
	movea.l	$8(a6),a4
	move.l	a4,-(sp)
	jsr	AudioPlayPos(pc)
	move.l	d0,d7
	tst.l	$C(a4)
	addq.w	#$4,sp
	beq.s	.L7DC2
	move.l	$4(a4),d0
	sub.l	d7,d0
	moveq	#$8,d1
	cmp.l	d0,d1
	ble.s	.L7DC2
	move.l	$4(a4),d0
	moveq	#$8,d1
	jsr	LongDivide(pc)
	move.l	d0,-(sp)
	move.l	$8(a4),-(sp)
	jsr	LoadFilmPcmBank(pc)
	addq.l	#$1,$4(a4)
	addi.l	#$1000,$8(a4)
	subi.l	#$1000,$C(a4)
	tst.l	$C(a4)
	addq.w	#$8,sp
	bge.s	.L7DC2
	moveq	#$0,d0
	move.l	d0,$C(a4)
.L7DC2
	movem.l	-$8(a6),d7/a4
	unlk	a6
	rts
	dc.b	$89,'AudioIdle',0,0
AudioFeed
	link	a6,#$0
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	move.l	a4,-(sp)
	jsr	AudioIdle(pc)
	move.l	$C(a6),$8(a4)
	move.l	$10(a6),$C(a4)
	move.l	a4,-(sp)
	jsr	AudioIdle(pc)
	moveq	#-1,d0
	cmp.l	(a4),d0
	addq.w	#$8,sp
	bne.s	.L7E22
	bra.s	.L7E0C
.L7E04
	move.l	a4,-(sp)
	jsr	AudioIdle(pc)
	addq.w	#$4,sp
.L7E0C
	tst.l	$C(a4)
	ble.s	.L7E1A
	moveq	#$8,d0
	cmp.l	$4(a4),d0
	bgt.s	.L7E04
.L7E1A
	jsr	StartFilmPcm(pc)
	moveq	#$0,d0
	move.l	d0,(a4)
.L7E22
	movea.l	-$4(a6),a4
	unlk	a6
	rts
	dc.b	$89,'AudioFeed',0,0
AudioSilence
	link	a6,#$0
	movem.l	d3/d7/a3-a4,-(sp)
	movea.l	$8(a6),a3
	moveq	#-1,d0
	cmp.l	(a3),d0
	bne.s	.L7E94
	pea	$1000.w
	jsr	mmalloc(pc)
	movea.l	d0,a4
	moveq	#$0,d7
	move.l	#$400,d3
	addq.w	#$4,sp
.L7E5C
	move.l	d7,d0
	asl.l	#$2,d0
	moveq	#$0,d1
	move.l	d1,(a4,d0.l)
	move.l	d7,d0
	addq.l	#$1,d7
	cmp.l	d7,d3
	bgt.s	.L7E5C
	moveq	#$0,d7
.L7E70
	move.l	d7,-(sp)
	move.l	a4,-(sp)
	jsr	LoadFilmPcmBank(pc)
	addq.w	#$8,sp
	move.l	d7,d0
	addq.l	#$1,d7
	moveq	#$8,d0
	cmp.l	d7,d0
	bgt.s	.L7E70
	move.l	a4,-(sp)
	jsr	ffree(pc)
	jsr	StartFilmPcm(pc)
	moveq	#$0,d0
	move.l	d0,(a3)
	addq.w	#$4,sp
.L7E94
	movem.l	-$10(a6),d3/d7/a3-a4
	unlk	a6
	rts
	dc.b	$8C,'AudioSilence',0,0,0
AudioStop
	link	a6,#$0
	jsr	StopFilmPcm(pc)
	unlk	a6
	rts
	dc.b	$89,'AudioStop',0,0
AudioTicks
	link	a6,#$FFFC
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	move.l	a4,-(sp)
	jsr	AudioPlayPos(pc)
	moveq	#$C,d0
	move.l	(a4),d1
	lsl.l	d0,d1
	move.l	d1,-$4(a6)
	jsr	ReadFilmPcmAddress(pc)
	move.l	#$FFF,d1
	and.l	d0,d1
	move.l	-$4(a6),d0
	or.l	d0,d1
	move.l	d1,d0
	movea.l	-$8(a6),a4
	unlk	a6
	rts
	dc.b	$8A,'AudioTicks',0,0,0
AudioTime
	link	a6,#$0
	move.l	$8(a6),-(sp)
	jsr	AudioTicks(pc)
	move.l	d0,d1
	move.l	$C(a6),d0
	jsr	LongMultiply(pc)
	dc.w	$D0BC,$0000,$1F40
	move.l	#$3E80,d1
	jsr	LongModulo(pc)
	unlk	a6
	rts
	dc.b	$89,'AudioTime',0,0
AudioBusy
	link	a6,#$0
	movea.l	$8(a6),a0
	move.w	$E(a0),d0
	unlk	a6
	rts
	dc.b	$89,'AudioBusy',0,0
	move.l	$4(sp),d0
	move.l	$8(sp),d1
LongMultiply
	move.l	d0,-(sp)
	mulu.w	d1,d0
	movea.l	d0,a0
	move.l	d1,d0
	mulu.w	(sp)+,d1
	clr.w	d0
	swap	d0
	beq.s	.L7F76
	mulu.w	(sp),d0
.L7F76
	addq.l	#$2,sp
	add.w	d1,d0
	swap	d0
	clr.w	d0
	add.l	a0,d0
	rts
	move.l	$4(sp),d1
	move.l	$8(sp),d0
LongModulo
	lea	.L7F96(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.L7F96
	bra.s	.L7F9E
	dc.w	$4C41
	dc.w	$0801
	rts
.L7F9E
	jsr	SignedDivide(pc)
	move.l	d1,d0
	rts
	move.l	$4(sp),d1
	move.l	$8(sp),d0
LongDivide
	lea	.L7FBA(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.L7FBA
	bra.s	SignedDivide
	dc.w	$4C41
	dc.w	$0801
	dc.w	$C340
	rts
SignedDivide
	tst.l	d0
	bmi.s	.L7FDC
	tst.l	d1
	bmi.s	.L7FD2
	jsr	.L8014(pc)
	rts
.L7FD2
	neg.l	d1
	jsr	.L8014(pc)
	neg.l	d1
	rts
.L7FDC
	neg.l	d0
	tst.l	d1
	bmi.s	.L7FEC
	jsr	.L8014(pc)
	neg.l	d0
	neg.l	d1
	rts
.L7FEC
	neg.l	d1
	jsr	.L8014(pc)
	neg.l	d0
	rts
	move.l	$4(sp),d1
	move.l	$8(sp),d0
	lea	.L800A(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.L800A
	bra.s	.L8014
	dc.w	$4C41
	dc.w	$0001,$C340
	rts
.L8014
	move.w	d1,-(sp)
	swap	d1
	tst.w	d1
	bne.s	.L8038
	move.l	d0,d1
	clr.w	d1
	swap	d1
	beq.s	.L802E
	divu.w	(sp),d1
	swap	d1
	swap	d0
	move.w	d1,d0
	swap	d0
.L802E
	divu.w	(sp)+,d0
	move.w	d0,d1
	clr.w	d0
	swap	d0
	rts
.L8038
	swap	d1
	move.w	d2,(sp)
	move.l	d3,-(sp)
	move.w	d0,d2
	move.l	d1,d3
	moveq	#$1,d1
	clr.w	d0
	swap	d0
	bne.s	.L8056
	swap	d0
	move.w	d2,d0
	moveq	#$0,d1
	bra.s	.L8068
.L8052
	add.w	d1,d1
	bcs.s	.L8068
.L8056
	add.w	d2,d2
	addx.l	d0,d0
	cmp.l	d3,d0
	bcs.s	.L8052
	sub.l	d3,d0
	add.w	d1,d1
	bset	#$0,d1
	bcc.s	.L8056
.L8068
	move.l	(sp)+,d3
	move.w	(sp)+,d2
	rts
	ori.b	#$0,d0
	rts
	movea.l	(a0),a0
	dc.w	$0000
OSStopFilm
	move.w	#$1,(FilmStopFlag).l
	bclr.b	#$0,$FF800F.l
	rts
OSInitMainSound
	lea	(PcmDriverEntry).l,a0
	move.l	a0,$FF8022.l
.L8096
	btst.b	#$7,$FF800E.l
	bne.s	.L8096
	move.w	#$29,$FF8020.l
	bset.b	#$6,$FF800F.l
.L80B0
	btst.b	#$6,$FF800E.l
	beq.s	.L80B0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L80CA
	btst.b	#$6,$FF800E.l
	bne.s	.L80CA
	bclr.b	#$7,$FF800F.l
	move.w	#$0,d0
	jsr	(PcmDriverEntry).l
	movea.l	a1,a0
	move.w	#$0,d1
	move.w	#$5,d0
	jsr	(PcmDriverEntry).l
	movea.l	a2,a0
	move.w	#$6,d0
	jsr	(PcmDriverEntry).l
	movea.l	a3,a0
	move.w	#$0,d1
	move.w	#$5,d0
	jsr	(PcmDriverEntry).l
	jsr	(StartTimerInterrupt).l
	move.w	#$1,(PcmServiceEnabled).l
	rts
OSInitMainSoundDriver
	lea	(PcmDriverEntry).l,a0
	move.l	a0,$FF8022.l
.L812E
	btst.b	#$7,$FF800E.l
	bne.s	.L812E
	move.w	#$40,$FF8020.l
	bset.b	#$6,$FF800F.l
.L8148
	btst.b	#$6,$FF800E.l
	beq.s	.L8148
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L8162
	btst.b	#$6,$FF800E.l
	bne.s	.L8162
	bclr.b	#$7,$FF800F.l
	move.w	#$0,d0
	jsr	(PcmDriverEntry).l
	jsr	(StartTimerInterrupt).l
	move.w	#$1,(PcmServiceEnabled).l
	rts
OSStopMainSoundHInt
	btst.b	#$7,$FF800E.l
	bne.s	OSStopMainSoundHInt
	move.w	#$2A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L81A8
	btst.b	#$6,$FF800E.l
	beq.s	.L81A8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L81C2
	btst.b	#$6,$FF800E.l
	bne.s	.L81C2
	bclr.b	#$7,$FF800F.l
	move.w	#$0,(PcmServiceEnabled).l
	rts
OSStopTimer
	movea.l	$6C.l,a0
	adda.l	#$2,a0
	move.l	(SavedTimerVector).l,(a0)
	rts
StartTimerInterrupt
	movea.l	$6C.l,a0
	adda.l	#$2,a0
	lea	(TimerInterrupt).l,a1
	move.l	(a0),(SavedTimerVector).l
	move.l	a1,(a0)
	move.w	#$84,d0
	move.w	d0,$FF8030.l
	move.w	$FF8032.l,d0
	ori.w	#$8,d0
	move.w	d0,$FF8032.l
	rts
	dc.w	$000F
	dc.w	$0000
TimerInterrupt
	move.l	d0,-(sp)
	move.w	#$84,$FF8030.l
	tst.w	(PcmServiceEnabled).l
	beq.s	.L8248
	move.w	#$1,d0
	jsr	(PcmDriverEntry).l
.L8248
	subi.w	#$1,(TimerCountdown).l
	bpl.w	.L825C
	move.w	#$F,(TimerCountdown).l
.L825C
	move.l	(sp)+,d0
	rte
PcmDriverEntry
	bra.w	DispatchPcmCommand
PcmCommandQueue
	dcb.b	130,0
DispatchPcmCommand
	cmpi.b	#$80,d0
	bcs.s	.L82F0
	bra.w	DispatchPackedPcmCommand
.L82F0
	tst.w	d0
	bne.s	.L82F8
	bra.w	InitPcmDriver
.L82F8
	subi.w	#$1,d0
	bne.s	.L8302
	bra.w	ServicePcmDriver
.L8302
	subi.w	#$1,d0
	bne.s	.L830E
	nop
	bra.w	ControlPcmSampleAllocation
.L830E
	subi.w	#$1,d0
	bne.s	.L8318
	bra.w	PlayPcmSample
.L8318
	subi.w	#$1,d0
	bne.s	.L8320
	nop
.L8320
	subi.w	#$1,d0
	bne.s	.L832A
	bra.w	SetPcmRecordDirectory
.L832A
	subi.w	#$1,d0
	bne.s	.L8334
	bra.w	LoadPcmRecordList
.L8334
	subi.w	#$1,d0
	bne.s	.L833E
	bra.w	PcmCommandNoOp
.L833E
	subi.w	#$1,d0
	bne.s	.L8348
	bra.w	SetPcmSoundLoopOffset
.L8348
	subi.w	#$1,d0
	bne.s	.L8352
	bra.w	PlayPcmStream
.L8352
	move.w	#$1,d0
	ori.b	#$1,ccr
	rts
ServicePcmDriver
	movem.l	d0-d7/a0-a6,-(sp)
	lea	PcmServiceBusy(pc),a0
	cmpi.w	#$0,(a0)
	beq.s	.L836C
	bra.s	.L83A4
.L836C
	move.w	#$FFFF,(a0)
	bsr.w	DrainPcmCommandQueue
	move.w	$FF800C.l,d0
	sub.w	PcmLastTimerTick(pc),d0
	andi.w	#$FFF,d0
	cmpi.w	#$20,d0
	bcs.s	.L839C
	bsr.w	UpdatePcmEnvelopes
	bsr.w	ServicePcmStream
	lea	PcmLastTimerTick(pc),a0
	move.w	$FF800C.l,d0
	move.w	d0,(a0)
.L839C
	lea	PcmServiceBusy(pc),a0
	move.w	#$0,(a0)
.L83A4
	movem.l	(sp)+,d0-d7/a0-a6
	rts
DrainPcmCommandQueue
	movem.l	d0-d1/a0-a1,-(sp)
.L83AE
	lea	PcmCommandQueue(pc),a0
	cmpi.w	#$0,(a0)
	beq.s	.L83F6
	move.l	$2(a0),d0
	bsr.w	DispatchPackedPcmCommand
	lea	PcmCommandQueue(pc),a0
	move.w	(a0),d0
	move.w	#$FFFF,(a0)
	adda.l	#$2,a0
	movea.l	a0,a1
	adda.l	#$4,a1
	move.w	d0,d1
	subi.w	#$1,d1
	beq.s	.L83EA
	subi.w	#$1,d1
.L83E4
	move.l	(a1)+,(a0)+
	dbf	d1,.L83E4
.L83EA
	lea	PcmCommandQueue(pc),a0
	subi.w	#$1,d0
	move.w	d0,(a0)
	bra.s	.L83AE
.L83F6
	movem.l	(sp)+,d0-d1/a0-a1
	rts
UpdatePcmEnvelopes
	movem.l	d1-d4/a0-a2,-(sp)
	lea	PcmCurrentChannel(pc),a0
	move.w	#$0,(a0)
.L8408
	move.b	PcmChannelOffMask(pc),d0
	move.w	PcmCurrentChannel(pc),d2
	btst	d2,d0
	bne.w	.L85A6
	lsl.w	#$2,d2
	lea	$FF0021.l,a0
	cmpi.b	#$0,$2(a0,d2.w)
	bne.s	.L8442
	lea	PcmChannelOffMask(pc),a0
	move.w	PcmCurrentChannel(pc),d0
	move.b	(a0),d2
	bset	d0,d2
	move.b	d2,(a0)
	move.b	d2,$FF0011.l
	bsr.w	PcmWriteDelay
	bra.w	.L85A6
.L8442
	move.w	PcmCurrentChannel(pc),d2
	lea	PcmChannelEnvelope(pc),a0
	cmpi.b	#$FF,(a0,d2.w)
	beq.w	.L85A6
	clr.w	d1
	move.b	(a0,d2.w),d1
	move.w	#$4,d0
	bsr.w	FindPcmRecord
	bcs.w	.L85A6
	lea	PcmChannelSegmentTime(pc),a1
	move.w	PcmCurrentChannel(pc),d0
	lsl.w	#$1,d0
	move.w	$FF800C.l,d1
	sub.w	PcmLastTimerTick(pc),d1
	andi.w	#$FFF,d1
	lsr.w	#$5,d1
	add.w	(a1,d0.w),d1
	move.w	d1,(a1,d0.w)
	lea	PcmChannelSegment(pc),a2
	move.w	PcmCurrentChannel(pc),d1
	clr.w	d2
	move.b	(a2,d1.w),d2
	addi.w	#$1,d2
	lsl.w	#$1,d2
	addi.w	#$3,d2
	clr.w	d3
	move.b	(a0,d2.w),d3
	cmp.w	(a1,d0.w),d3
	bcc.s	.L84FE
	move.w	(a1,d0.w),d2
	sub.w	d3,d2
	move.w	d2,(a1,d0.w)
	addi.b	#$1,(a2,d1.w)
	move.b	(a2,d1.w),d2
	cmp.b	$2(a0),d2
	bne.s	.L84DA
	lea	PcmEnvelopeHeld(pc),a1
	move.w	PcmCurrentChannel(pc),d3
	btst.b	d3,(a1)
	beq.s	.L84DA
	move.b	$1(a0),(a2,d1.w)
	bra.s	.L84FE
.L84DA
	addi.b	#$1,d2
	cmp.b	(a0),d2
	bcs.s	.L84FE
	lea	PcmChannelOffMask(pc),a0
	move.w	PcmCurrentChannel(pc),d0
	move.b	(a0),d1
	bset	d0,d1
	move.b	d1,$FF0011.l
	move.b	d1,(a0)
	bsr.w	PcmWriteDelay
	bra.w	.L85A6
.L84FE
	lea	PcmChannelSegment(pc),a1
	move.w	PcmCurrentChannel(pc),d0
	clr.w	d1
	move.b	(a1,d0.w),d1
	lsl.w	#$1,d1
	addi.w	#$3,d1
	move.b	$1(a0,d1.w),d0
	cmp.b	$3(a0,d1.w),d0
	bcs.s	.L8528
	clr.w	d2
	move.b	$1(a0,d1.w),d2
	sub.b	$3(a0,d1.w),d2
	bra.s	.L8532
.L8528
	clr.w	d2
	move.b	$3(a0,d1.w),d2
	sub.b	$1(a0,d1.w),d2
.L8532
	cmpi.b	#$0,d2
	bne.s	.L853E
	move.b	$1(a0,d1.w),d2
	bra.s	.L857A
.L853E
	lea	PcmChannelSegmentTime(pc),a1
	move.w	PcmCurrentChannel(pc),d0
	lsl.w	#$1,d0
	move.w	(a1,d0.w),d3
	lsl.w	#$8,d3
	clr.w	d4
	move.b	$2(a0,d1.w),d4
	divu.w	d4,d3
	move.b	$1(a0,d1.w),d0
	cmp.b	$3(a0,d1.w),d0
	bcs.s	.L856E
	mulu.w	d2,d3
	lsr.w	#$8,d3
	clr.w	d2
	move.b	$1(a0,d1.w),d2
	sub.w	d3,d2
	bra.s	.L857A
.L856E
	mulu.w	d2,d3
	lsr.w	#$8,d3
	clr.w	d2
	move.b	$1(a0,d1.w),d2
	add.w	d3,d2
.L857A
	lea	PcmChannelVelocity(pc),a1
	move.w	PcmCurrentChannel(pc),d0
	clr.w	d3
	move.b	(a1,d0.w),d3
	lsl.w	#$1,d3
	mulu.w	d3,d2
	lsr.w	#$8,d2
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	bsr.w	PcmWriteDelay
	move.b	d2,$FF0001.l
	bsr.w	PcmWriteDelay
.L85A6
	lea	PcmCurrentChannel(pc),a0
	addi.w	#$1,(a0)
	cmpi.w	#$8,(a0)
	beq.s	.L85B8
	bra.w	.L8408
.L85B8
	movem.l	(sp)+,d1-d4/a0-a2
	rts
ServicePcmStream
	movem.l	d0-d1/a0,-(sp)
	move.w	PcmStreamActive(pc),d0
	beq.w	.L86C6
	move.b	PcmChannelOffMask(pc),d0
	move.w	PcmStreamChannel(pc),d1
	btst	d1,d0
	beq.s	.L85E2
	lea	PcmStreamActive(pc),a0
	move.w	#$0,(a0)
	bra.w	.L86C6
.L85E2
	move.l	PcmStreamSource(pc),d0
	cmpi.l	#$FFFFFFFF,d0
	bne.s	.L8618
	move.w	PcmStreamChannel(pc),d0
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	move.b	#$0,$FF0009.l
	bsr.w	PcmWriteDelay
	move.b	#$0,$FF000B.l
	bsr.w	PcmWriteDelay
	bra.w	.L86C6
.L8618
	clr.l	d0
	move.w	PcmStreamChannel(pc),d0
	lsl.w	#$2,d0
	addi.l	#$FF0021,d0
	movea.l	d0,a0
	move.b	$2(a0),d0
	lsl.w	#$8,d0
	move.b	(a0),d0
	move.w	PcmStreamLastHalf(pc),d1
	bne.s	.L8680
	cmp.w	PcmStreamHalfA(pc),d0
	bcs.w	.L86C6
	move.w	PcmStreamHalfA(pc),d1
	add.w	PcmStreamHalfASize(pc),d1
	cmp.w	d1,d0
	bcc.s	.L86C6
	move.w	#$1,d0
	bsr.w	FillPcmStreamHalf
	move.w	PcmStreamChannel(pc),d0
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	bsr.w	PcmWriteDelay
	move.w	PcmStreamLoopB(pc),d0
	move.b	d0,$FF0009.l
	bsr.w	PcmWriteDelay
	lsr.w	#$8,d0
	move.b	d0,$FF000B.l
	bsr.w	PcmWriteDelay
	bra.s	.L86C6
.L8680
	cmp.w	PcmStreamHalfB(pc),d0
	bcs.s	.L86C6
	move.w	PcmStreamHalfB(pc),d1
	add.w	PcmStreamHalfBSize(pc),d1
	cmp.w	d1,d0
	bcc.s	.L86C6
	move.w	#$0,d0
	bsr.w	FillPcmStreamHalf
	move.w	PcmStreamChannel(pc),d0
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	bsr.w	PcmWriteDelay
	move.w	PcmStreamLoopA(pc),d0
	move.b	d0,$FF0009.l
	bsr.w	PcmWriteDelay
	lsr.w	#$8,d0
	move.b	d0,$FF000B.l
	bsr.w	PcmWriteDelay
.L86C6
	movem.l	(sp)+,d0-d1/a0
	rts
DispatchPackedPcmCommand
	cmpi.b	#$8F,d0
	bgt.s	.L86D6
	bra.w	StopPackedPcmSound
.L86D6
	cmpi.b	#$9F,d0
	bgt.s	.L86E0
	bra.w	PlayPackedPcmSound
.L86E0
	cmpi.b	#$AF,d0
	bgt.s	.L86E8
	bra.s	.L870C
.L86E8
	cmpi.b	#$BF,d0
	bgt.s	.L86F0
	nop
.L86F0
	cmpi.b	#$CF,d0
	bgt.s	.L86FA
	bra.w	SetPcmSoundMapping
.L86FA
	cmpi.b	#$DF,d0
	bgt.s	.L8702
	bra.s	.L870C
.L8702
	cmpi.b	#$EF,d0
	bgt.s	.L870C
	bra.w	SetPcmPitchControl
.L870C
	move.w	#$1,d0
	ori.b	#$1,ccr
	rts
PlayPackedPcmSound
	movem.l	d1-d2/a0-a1,-(sp)
	lea	PcmAllocPosition(pc),a0
	move.b	d0,d1
	andi.w	#$F,d1
	move.l	d0,d2
	swap	d2
	lsr.w	#$8,d2
	or.b	d2,d1
	move.w	d1,$268(a0)
	move.w	d0,d1
	lsr.w	#$8,d1
	move.w	d1,$26A(a0)
	move.l	d0,d1
	swap	d1
	andi.w	#$FF,d1
	move.w	d1,$26C(a0)
	move.w	PcmEventSlot(pc),d2
	lea	PcmSoundMapping(pc),a0
	clr.w	d1
	move.b	(a0,d2.w),d1
.L8752
	lea	PcmEventSound(pc),a0
	move.w	d1,(a0)
	move.w	#$0,d0
	bsr.w	FindPcmRecord
	bcs.w	.L8868
	lea	PcmEventRecord(pc),a1
	move.l	a0,(a1)
	cmpi.b	#$7,(a0)
	bne.s	.L8780
	move.w	PcmEventNote(pc),d0
	addi.w	#$2,d0
	clr.w	d1
	move.b	(a0,d0.w),d1
	bra.s	.L8752
.L8780
	bsr.w	SelectPcmChannel
	bcc.s	.L878A
	bra.w	.L8868
.L878A
	move.w	PcmCurrentChannel(pc),d0
	lea	PcmChannelSlot(pc),a0
	move.b	PcmEventSlotByte(pc),(a0,d0.w)
	lea	PcmChannelSound(pc),a0
	move.b	PcmEventSoundByte(pc),(a0,d0.w)
	lea	PcmChannelNote(pc),a0
	move.b	PcmEventNoteByte(pc),(a0,d0.w)
	lea	PcmChannelVelocity(pc),a0
	move.b	PcmEventVelocityByte(pc),(a0,d0.w)
	lea	PcmChannelPriority(pc),a0
	movea.l	PcmEventRecord(pc),a1
	move.b	$1(a1),(a0,d0.w)
	move.w	PcmReuseFlags(pc),d0
	btst	#$0,d0
	beq.s	.L87D4
	btst	#$1,d0
	beq.s	.L884C
.L87D4
	move.b	PcmChannelOffMask(pc),d0
	move.w	PcmCurrentChannel(pc),d1
	bset	d1,d0
	move.b	d0,$FF0011.l
	bsr.w	PcmWriteDelay
	ori.b	#$C0,d1
	move.b	d1,$FF000F.l
	bsr.w	PcmWriteDelay
	movea.l	PcmEventRecord(pc),a0
	clr.w	d0
	move.b	$2(a0),d0
	lsl.w	#$1,d0
	lea	PcmSampleAddress(pc),a1
	move.w	(a1,d0.w),d1
	lsr.w	#$8,d1
	move.b	d1,$FF000D.l
	bsr.w	PcmWriteDelay
	move.b	$5(a0),d1
	lsl.w	#$8,d1
	move.b	$6(a0),d1
	cmpi.w	#$FFFF,d1
	bne.s	.L882A
	clr.w	d1
	bra.s	.L882E
.L882A
	add.w	(a1,d0.w),d1
.L882E
	move.b	d1,$FF0009.l
	bsr.w	PcmWriteDelay
	lsr.w	#$8,d1
	move.b	d1,$FF000B.l
	bsr.w	PcmWriteDelay
	bsr.w	StartPcmEnvelope
	bsr.w	UpdatePcmPan
.L884C
	bsr.w	UpdatePcmFrequency
	lea	PcmChannelOffMask(pc),a0
	move.w	PcmCurrentChannel(pc),d0
	move.b	(a0),d1
	bclr	d0,d1
	move.b	d1,$FF0011.l
	bsr.w	PcmWriteDelay
	move.b	d1,(a0)
.L8868
	movem.l	(sp)+,d1-d2/a0-a1
	rts
StopPackedPcmSound
	movem.l	d1-d3/a0-a2,-(sp)
	clr.w	d1
	move.b	d0,d1
	andi.b	#$F,d1
	move.l	d0,d2
	swap	d2
	lsr.w	#$8,d2
	or.b	d2,d1
	lea	PcmEventSlot(pc),a0
	move.w	d1,(a0)
	move.w	d0,d1
	lsr.w	#$8,d1
	lea	PcmEventNote(pc),a0
	move.w	d1,(a0)
	lea	PcmSoundMapping(pc),a0
	move.w	PcmEventSlot(pc),d0
	clr.w	d1
	move.b	(a0,d0.w),d1
.L88A0
	move.w	#$0,d0
	bsr.w	FindPcmRecord
	bcs.w	.L896A
	cmpi.b	#$7,(a0)
	bne.s	.L88C2
	move.w	PcmEventNote(pc),d0
	addi.w	#$1,d0
	clr.w	d1
	move.b	(a0,d0.w),d1
	bra.s	.L88A0
.L88C2
	move.b	$5(a0),d0
	lsl.w	#$8,d0
	move.b	$6(a0),d0
	cmpi.w	#$FFFF,d0
	beq.w	.L896A
	move.b	PcmChannelOffMask(pc),d0
	clr.w	d1
	lea	PcmChannelSlot(pc),a1
	lea	PcmChannelNote(pc),a2
	move.w	PcmEventSlot(pc),d2
	move.w	PcmEventNote(pc),d3
.L88EA
	btst	d1,d0
	bne.s	.L894C
	cmp.b	(a1),d2
	bne.s	.L894C
	cmp.b	(a2),d3
	bne.s	.L894C
	cmpi.b	#$FF,$D(a0)
	beq.s	.L8936
	lea	PcmEnvelopeHeld(pc),a1
	bclr.b	d1,(a1)
	lea	PcmCurrentChannel(pc),a1
	move.w	d1,(a1)
	clr.w	d1
	move.b	$D(a0),d1
	move.w	#$4,d0
	bsr.w	FindPcmRecord
	bcs.s	.L896A
	lea	PcmChannelSegment(pc),a1
	move.w	PcmCurrentChannel(pc),d0
	move.b	$2(a0),(a1,d0.w)
	lsl.w	#$1,d0
	lea	PcmChannelSegmentTime(pc),a1
	move.w	#$0,(a1,d0.w)
	bra.s	.L896A
.L8936
	lea	PcmChannelOffMask(pc),a0
	bset	d1,d0
	move.b	d0,(a0)
	move.b	d0,$FF0011.l
	bsr.w	PcmWriteDelay
	clr.w	d0
	bra.s	.L896A
.L894C
	adda.l	#$1,a1
	adda.l	#$1,a2
	addi.w	#$1,d1
	cmpi.w	#$8,d1
	bne.s	.L88EA
	move.w	#$FFFF,d0
	ori.b	#$1,ccr
.L896A
	movem.l	(sp)+,d1-d3/a0-a2
	rts
SetPcmSoundMapping
	movem.l	d1-d2/a0,-(sp)
	move.l	d0,d1
	swap	d1
	lsr.w	#$8,d1
	move.w	d0,d2
	andi.w	#$F,d2
	or.b	d1,d2
	lsr.w	#$8,d0
	lea	PcmSoundMapping(pc),a0
	move.b	d0,(a0,d2.w)
	clr.w	d0
	movem.l	(sp)+,d1-d2/a0
	rts
SetPcmPitchControl
	movem.l	d1-d2/a0,-(sp)
	move.l	d0,d1
	swap	d1
	lsr.w	#$8,d1
	move.w	d0,d2
	andi.w	#$F,d2
	or.b	d1,d2
	lsr.w	#$8,d0
	lea	PcmPitchControl(pc),a0
	move.b	d0,(a0,d2.w)
	lea	PcmCurrentChannel(pc),a0
	move.w	#$0,(a0)
.L89B8
	move.w	PcmCurrentChannel(pc),d0
	move.b	PcmChannelOffMask(pc),d1
	btst	d0,d1
	beq.s	.L89D2
	lea	PcmChannelSlot(pc),a0
	cmp.b	(a0,d0.w),d2
	bne.s	.L89D2
	bsr.w	UpdatePcmFrequency
.L89D2
	lea	PcmCurrentChannel(pc),a0
	addi.w	#$1,(a0)
	cmpi.w	#$8,(a0)
	bne.s	.L89B8
	clr.w	d0
	movem.l	(sp)+,d1-d2/a0
	rts
StartPcmEnvelope
	movem.l	d1-d2/a0,-(sp)
	movea.l	PcmEventRecord(pc),a0
	clr.w	d1
	move.b	$D(a0),d1
	lea	PcmChannelEnvelope(pc),a0
	move.w	PcmCurrentChannel(pc),d0
	move.b	d1,(a0,d0.w)
	cmpi.b	#$FF,d1
	beq.s	.L8A12
	move.w	#$4,d0
	bsr.w	FindPcmRecord
	bcc.s	.L8A40
.L8A12
	move.w	PcmCurrentChannel(pc),d0
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	bsr.w	PcmWriteDelay
	lea	PcmChannelVelocity(pc),a0
	move.w	PcmCurrentChannel(pc),d0
	move.b	(a0,d0.w),d1
	lsl.w	#$1,d1
	move.b	d1,$FF0001.l
	bsr.w	PcmWriteDelay
	clr.w	d0
	bra.s	.L8A98
.L8A40
	clr.w	d0
	move.b	$4(a0),d0
	lea	PcmChannelVelocity(pc),a0
	move.w	PcmCurrentChannel(pc),d1
	clr.w	d2
	move.b	(a0,d1.w),d2
	lsl.w	#$1,d2
	mulu.w	d2,d0
	lsr.w	#$8,d0
	move.w	PcmCurrentChannel(pc),d1
	ori.b	#$C0,d1
	move.b	d1,$FF000F.l
	bsr.w	PcmWriteDelay
	move.b	d0,$FF0001.l
	bsr.w	PcmWriteDelay
	lea	PcmChannelSegment(pc),a0
	move.w	PcmCurrentChannel(pc),d0
	move.b	#$0,(a0,d0.w)
	lea	PcmEnvelopeHeld(pc),a0
	bset.b	d0,(a0)
	lsl.w	#$1,d0
	lea	PcmChannelSegmentTime(pc),a0
	move.w	#$0,(a0,d0.w)
	clr.w	d0
.L8A98
	movem.l	(sp)+,d1-d2/a0
	rts
InitPcmDriver
	movem.l	d0/a0-a1,-(sp)
	lea	PcmAllocPosition(pc),a0
	move.w	#$100,$0(a0)
	move.w	#$100,$2(a0)
	lea	PcmRecordDirectories(pc),a1
	move.w	#$3,d0
.L8ABA
	move.l	#$FFFFFFFF,(a1)+
	dbf	d0,.L8ABA
	move.b	#$FF,$218(a0)
	lea	PcmSoundMapping(pc),a0
	move.w	#$7F,d0
.L8AD2
	move.b	#$0,(a0)+
	dbf	d0,.L8AD2
	lea	PcmSlotModulation(pc),a0
	move.w	#$7F,d0
.L8AE2
	move.b	#$0,(a0)+
	dbf	d0,.L8AE2
	lea	PcmSlotLevel(pc),a0
	move.w	#$7F,d0
.L8AF2
	move.b	#$7F,(a0)+
	dbf	d0,.L8AF2
	lea	PcmSlotPan(pc),a0
	move.w	#$7F,d0
.L8B02
	move.b	#$40,(a0)+
	dbf	d0,.L8B02
	lea	PcmPitchControl(pc),a0
	move.w	#$7F,d0
.L8B12
	move.b	#$40,(a0)+
	dbf	d0,.L8B12
	lea	PcmGroupLevel(pc),a0
	move.w	#$7,d0
.L8B22
	move.b	#$FF,(a0)+
	dbf	d0,.L8B22
	lea	PcmAllocPosition(pc),a0
	move.b	#$80,$51B(a0)
	move.b	#$80,$51C(a0)
	move.b	#$80,$51D(a0)
	lea	PcmMasterLevel(pc),a0
	move.b	#$FF,(a0)
	lea	PcmCommandQueue(pc),a0
	move.w	#$0,(a0)
	move.b	#$80,$FF000F.l
	bsr.w	PcmWriteDelay
	lea	$FF2001.l,a0
	move.w	#$EB,d0
.L8B66
	move.b	#$80,(a0)
	adda.l	#$2,a0
	nop
	nop
	nop
	nop
	dbf	d0,.L8B66
	move.w	#$F,d0
.L8B80
	move.b	#$FF,(a0)
	adda.l	#$2,a0
	nop
	nop
	nop
	nop
	dbf	d0,.L8B80
	lea	PcmServiceBusy(pc),a0
	move.w	#$0,(a0)
	lea	PcmStreamActive(pc),a0
	move.w	#$0,(a0)
	movem.l	(sp)+,d0/a0-a1
	rts
PlayPcmSample
	movem.l	d1-d7/a0,-(sp)
	move.b	PcmChannelOffMask(pc),d0
	move.w	#$7,d5
.L8BB8
	btst	d5,d0
	bne.s	.L8BF8
	dbf	d5,.L8BB8
	lea	PcmChannelPriority(pc),a0
	move.w	#$FFFF,d5
	move.b	#$FF,d6
	clr.w	d0
.L8BCE
	cmp.b	(a0),d6
	bcs.s	.L8BD6
	move.w	d0,d5
	move.b	(a0),d6
.L8BD6
	adda.l	#$1,a0
	addi.w	#$1,d0
	cmpi.w	#$8,d0
	bne.s	.L8BCE
	cmpi.w	#$FFFF,d5
	bne.s	.L8BF8
	move.w	#$7,d0
	ori.b	#$1,ccr
	bra.w	.L8CDE
.L8BF8
	lea	PcmCurrentChannel(pc),a0
	move.w	d5,(a0)
	lea	PcmChannelOffMask(pc),a0
	move.b	(a0),d0
	bset	d5,d0
	move.b	d0,$FF0011.l
	bsr.w	PcmWriteDelay
	lea	PcmSampleAddress(pc),a0
	lsl.w	#$1,d1
	cmpi.w	#$FFFF,(a0,d1.w)
	bne.s	.L8C2A
	move.b	#$3,d0
	ori.b	#$1,ccr
	bra.w	.L8CDE
.L8C2A
	move.w	PcmCurrentChannel(pc),d0
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	move.w	(a0,d1.w),d0
	lsr.w	#$8,d0
	move.b	d0,$FF000D.l
	bsr.w	PcmWriteDelay
	move.b	#$0,$FF0009.l
	bsr.w	PcmWriteDelay
	move.b	#$0,$FF000B.l
	bsr.w	PcmWriteDelay
	move.b	d2,$FF0005.l
	bsr.w	PcmWriteDelay
	lsr.w	#$8,d2
	move.b	d2,$FF0007.l
	bsr.w	PcmWriteDelay
	move.b	d3,$FF0001.l
	bsr.w	PcmWriteDelay
	move.b	d4,$FF0003.l
	bsr.w	PcmWriteDelay
	lea	PcmChannelOffMask(pc),a0
	move.w	PcmCurrentChannel(pc),d0
	move.b	(a0),d1
	bclr	d0,d1
	move.b	d1,(a0)
	move.b	d1,$FF0011.l
	bsr.w	PcmWriteDelay
	lea	PcmChannelSlot(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea	PcmChannelSound(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea	PcmChannelNote(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea	PcmChannelVelocity(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea	PcmChannelPriority(pc),a0
	move.b	#$0,(a0,d0.w)
	lea	PcmChannelEnvelope(pc),a0
	move.b	#$FF,(a0,d0.w)
.L8CDE
	movem.l	(sp)+,d1-d7/a0
	rts
UpdatePcmFrequency
	movem.l	d1-d6/a0-a1,-(sp)
	movea.l	PcmEventRecord(pc),a0
	clr.w	d0
	clr.w	d1
	move.w	PcmCurrentChannel(pc),d2
	lea	PcmChannelNote(pc),a1
	move.b	(a1,d2.w),d3
	cmp.b	$3(a0),d3
	blt.s	.L8D0A
	sub.b	$3(a0),d3
	add.b	d3,d0
	bra.s	.L8D14
.L8D0A
	move.b	$3(a0),d3
	sub.b	(a1,d2.w),d3
	sub.b	d3,d0
.L8D14
	move.w	PcmEventSlot(pc),d2
	lea	PcmPitchControl(pc),a1
	clr.w	d3
	move.b	(a1,d2.w),d3
	cmpi.b	#$40,d3
	beq.s	.L8D64
	blt.s	.L8D46
	subi.b	#$40,d3
	lsl.w	#$2,d3
	clr.w	d4
	move.b	$7(a0),d4
	mulu.w	d4,d3
	add.b	d3,d1
	bcc.s	.L8D40
	addi.b	#$1,d0
.L8D40
	lsr.w	#$8,d3
	add.b	d3,d0
	bra.s	.L8D64
.L8D46
	move.b	#$40,d3
	sub.b	(a1,d2.w),d3
	lsl.w	#$2,d3
	clr.w	d4
	move.b	$8(a0),d4
	mulu.w	d4,d3
	sub.b	d3,d1
	bcc.s	.L8D60
	subi.b	#$1,d0
.L8D60
	lsr.w	#$8,d3
	sub.b	d3,d0
.L8D64
	clr.w	d2
	move.b	$A(a0),d2
	cmpi.b	#$FF,d2
	beq.s	.L8DD4
	move.w	PcmEventSlot(pc),d3
	lea	PcmSlotModulation(pc),a1
	clr.w	d4
	move.b	(a1,d3.w),d4
	beq.s	.L8DD4
	clr.w	d5
	move.b	$9(a0),d5
	beq.s	.L8DD4
	lea	PcmModulationLevels(pc),a1
	clr.w	d6
	move.b	(a1,d2.w),d6
	cmpi.b	#$80,d6
	beq.s	.L8DD4
	blt.s	.L8DB6
	subi.b	#$80,d6
	lsl.w	#$1,d6
	mulu.w	d5,d6
	lsl.w	#$1,d4
	mulu.w	d4,d6
	lsr.l	#$8,d6
	add.b	d6,d1
	bcc.s	.L8DB0
	addi.b	#$1,d0
.L8DB0
	lsr.w	#$8,d6
	add.b	d6,d0
	bra.s	.L8DD4
.L8DB6
	move.b	#$80,d6
	sub.b	(a1,d2.w),d6
	lsl.w	#$1,d6
	mulu.w	d5,d6
	lsl.w	#$1,d4
	mulu.w	d4,d6
	lsr.l	#$8,d6
	sub.b	d6,d1
	bcc.s	.L8DD0
	subi.b	#$1,d0
.L8DD0
	lsr.w	#$8,d6
	sub.b	d6,d0
.L8DD4
	clr.w	d2
	move.b	$4(a0),d2
	cmpi.b	#$0,d2
	beq.s	.L8E04
	btst	#$7,d2
	bne.s	.L8DF2
	lsl.b	#$1,d2
	add.b	d2,d1
	bcc.s	.L8E04
	addi.b	#$1,d0
	bra.s	.L8E04
.L8DF2
	eori.b	#$FF,d2
	addi.b	#$1,d2
	lsl.b	#$1,d2
	sub.b	d2,d1
	bcc.s	.L8E04
	subi.b	#$1,d0
.L8E04
	ext.w	d0
	lsl.w	#$1,d0
	lea	PcmPitchTable(pc),a1
	move.w	(a1,d0.w),d2
	move.w	$2(a1,d0.w),d3
	sub.w	d2,d3
	mulu.w	d1,d3
	lsr.w	#$8,d3
	add.w	d3,d2
	move.w	PcmCurrentChannel(pc),d0
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	bsr.w	PcmWriteDelay
	move.b	d2,$FF0005.l
	bsr.w	PcmWriteDelay
	lsr.w	#$8,d2
	move.b	d2,$FF0007.l
	bsr.w	PcmWriteDelay
	clr.w	d0
	movem.l	(sp)+,d1-d6/a0-a1
	rts
	ori.l	#$880090,d0
	ori.l	#$A200AB,(a0)+
	ori.l	#$C000CB,-$29(a5,d0.w)
	dc.w	$00E4
	dc.w	$00F2
	btst	d0,d0
	movep.w	$11F(sp),d0
	dc.w	$0130
	bchg	d0,d3
	bchg.b	d0,(a6)
	bchg.b	d0,$180(a2)
	bclr.b	d0,(a6)
	bclr.b	d0,$1C8(sp)
	bset.b	d0,-(a3)
	dc.w	$0200,$021E
	dc.w	$023F
	andi.w	#$285,-(a1)
	andi.l	#$2D402FF,$32D(a3)
	bchg.b	d1,(a5)+
	bclr.b	d1,(a0)
	bset	d1,d7
	dc.w	$0400,$043D
	dc.w	$047D
	dc.w	$04C2
	movep.w	$557(a2),d2
	bclr.b	d2,$5FE(a0)
	addi.w	#$6BA,(a1)+
	btst.b	d3,-(a1)
	dc.w	$078D
PcmPitchTable
	dc.w	$0800,$087A,$08FB,$0983,$0A14,$0AAE,$0B50,$0BFD
	dc.w	$0CB3,$0D74,$0E41,$0F1A,$1000,$10F4,$11F6,$1307
	dc.w	$1429,$1556,$16A1,$17F9,$1966,$1AE9,$1C82,$1E34
	dc.w	$2000,$21E7,$23EB,$260E,$2851,$2AB7,$2D41,$2FF2
	dc.w	$32CC,$35D1,$3904,$3C68,$4000,$43CE,$47D6,$4C1C
	dc.w	$50A3,$556E,$5A82,$5FE4,$6598,$6BA3,$7209,$78D1
	dc.w	$8000
UpdatePcmPan
	movem.l	d1-d3/a0,-(sp)
	move.w	PcmCurrentChannel(pc),d0
	lea	PcmChannelSlot(pc),a0
	clr.w	d3
	move.b	(a0,d0.w),d3
	lea	PcmSlotLevel(pc),a0
	clr.w	d2
	move.b	(a0,d3.w),d2
	lsl.w	#$1,d2
	lea	PcmSoundMapping(pc),a0
	clr.w	d1
	move.b	(a0,d3.w),d1
	move.w	#$0,d0
	bsr.w	FindPcmRecord
	bcs.w	.L8FC8
	clr.w	d1
	move.b	$B(a0),d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	move.w	d3,d0
	lsr.w	#$4,d0
	lea	PcmGroupLevel(pc),a0
	clr.w	d1
	move.b	(a0,d0.w),d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	clr.w	d1
	move.b	PcmMasterLevel(pc),d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	lea	PcmSlotPan(pc),a0
	clr.w	d1
	move.b	(a0,d3.w),d1
	cmpi.b	#$40,d1
	bne.s	.L8F82
	lsr.b	#$4,d2
	move.b	d2,d0
	lsl.b	#$4,d0
	or.b	d2,d0
	bra.s	.L8FAA
.L8F82
	bgt.s	.L8F96
	move.b	d2,d0
	lsr.b	#$4,d0
	lsl.w	#$2,d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	andi.b	#$F0,d2
	or.b	d2,d0
	bra.s	.L8FAA
.L8F96
	move.b	d2,d0
	andi.b	#$F0,d0
	subi.w	#$40,d1
	lsl.w	#$2,d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	lsr.b	#$4,d2
	or.b	d2,d0
.L8FAA
	move.w	PcmCurrentChannel(pc),d1
	ori.b	#$C0,d1
	move.b	d1,$FF000F.l
	bsr.w	PcmWriteDelay
	move.b	d0,$FF0003.l
	bsr.w	PcmWriteDelay
	clr.w	d0
.L8FC8
	movem.l	(sp)+,d1-d3/a0
	rts
SelectPcmChannel
	movem.l	d1-d2/a0,-(sp)
	lea	PcmReuseFlags(pc),a0
	move.w	#$0,(a0)
	movea.l	PcmEventRecord(pc),a0
	btst.b	#$0,$C(a0)
	beq.s	.L9020
	lea	PcmChannelSound(pc),a0
	move.w	PcmEventSound(pc),d0
	move.b	PcmChannelOffMask(pc),d1
	clr.w	d2
.L8FF4
	btst	d2,d1
	bne.s	.L9016
	cmp.b	(a0)+,d0
	bne.s	.L9016
	lea	PcmCurrentChannel(pc),a0
	move.w	d2,(a0)
	lea	PcmEventRecord(pc),a0
	clr.w	d0
	move.b	$C(a0),d0
	lea	PcmReuseFlags(pc),a0
	move.w	d0,(a0)
	clr.w	d0
	bra.s	.L9068
.L9016
	addi.w	#$1,d2
	cmpi.w	#$8,d2
	bne.s	.L8FF4
.L9020
	move.b	PcmChannelOffMask(pc),d0
	clr.w	d1
.L9026
	btst	d1,d0
	beq.s	.L9034
	lea	PcmCurrentChannel(pc),a0
	move.w	d1,(a0)
	clr.w	d0
	bra.s	.L9068
.L9034
	addi.w	#$1,d1
	cmpi.w	#$8,d1
	bne.s	.L9026
	movea.l	PcmEventRecord(pc),a0
	move.b	$1(a0),d0
	lea	PcmChannelPriority(pc),a0
	clr.w	d1
.L904C
	cmp.b	(a0)+,d0
	bhi.s	.L905A
	lea	PcmCurrentChannel(pc),a0
	move.w	d1,(a0)
	clr.w	d0
	bra.s	.L9068
.L905A
	addi.w	#$1,d1
	cmpi.w	#$8,d1
	bne.s	.L904C
	ori.b	#$1,ccr
.L9068
	movem.l	(sp)+,d1-d2/a0
	rts
FindPcmRecord
	movem.l	d1-d4/a1-a2,-(sp)
	lea	PcmRecordDirectories(pc),a1
	move.w	#$4,d2
.L907A
	cmpi.l	#$FFFFFFFF,(a1)
	beq.s	.L90C8
	movea.l	(a1),a2
	move.b	(a2)+,d3
	lsl.w	#$8,d3
	move.b	(a2)+,d3
	clr.l	d4
	move.w	d3,d4
	lsl.l	#$2,d4
	add.l	a2,d4
	movea.l	d4,a0
.L9094
	cmp.b	(a2),d0
	bne.s	.L90AE
	cmp.b	$1(a2),d1
	bne.s	.L90AE
	move.b	$2(a2),d0
	lsl.w	#$8,d0
	move.b	$3(a2),d0
	andi.b	#$FE,ccr
	bra.s	.L90DC
.L90AE
	clr.l	d4
	move.b	$2(a2),d4
	lsl.w	#$8,d4
	move.b	$3(a2),d4
	adda.l	d4,a0
	adda.l	#$4,a2
	subi.w	#$1,d3
	bne.s	.L9094
.L90C8
	adda.l	#$4,a1
	subi.w	#$1,d2
	bne.s	.L907A
	move.w	#$3,d0
	ori.b	#$1,ccr
.L90DC
	movem.l	(sp)+,d1-d4/a1-a2
	rts
ControlPcmSampleAllocation
	move.l	a0,-(sp)
	or.w	d1,d1
	bne.s	.L90F6
	lea	PcmAllocPosition(pc),a0
	move.w	#$100,$2(a0)
	clr.w	d0
	bra.s	.L914C
.L90F6
	cmpi.w	#$1,d1
	bne.s	.L910A
	lea	PcmAllocPosition(pc),a0
	move.w	$0(a0),$2(a0)
	clr.w	d0
	bra.s	.L914C
.L910A
	cmpi.w	#$2,d1
	bne.s	.L9144
	lea	PcmAllocPosition(pc),a0
	move.w	$2(a0),$0(a0)
	move.w	$2(a0),d0
	lea	PcmSampleAddress(pc),a0
	move.w	#$FF,d1
.L9126
	cmpi.w	#$FFFF,(a0)
	beq.s	.L9136
	cmp.w	(a0),d0
	bhi.w	.L9136
	move.w	#$FFFF,(a0)
.L9136
	adda.l	#$2,a0
	dbf	d1,.L9126
	clr.w	d0
	bra.s	.L914C
.L9144
	move.w	#$5,d0
	ori.b	#$1,ccr
.L914C
	clr.w	d0
	movea.l	(sp)+,a0
	rts
SetPcmRecordDirectory
	movem.l	d1/a1,-(sp)
	lsl.w	#$2,d1
	lea	PcmRecordDirectories(pc),a1
	move.l	a0,(a1,d1.w)
	movem.l	(sp)+,d1/a1
	rts
LoadPcmRecordList
	movem.l	d1/a0-a1,-(sp)
	movea.l	a0,a1
.L916C
	cmpi.w	#$FFFF,(a1)
	bne.s	.L9176
	clr.w	d0
	bra.s	.L91C2
.L9176
	move.w	(a1),d0
	move.w	$2(a1),d1
	bsr.w	FindPcmRecord
	bcs.s	.L91BE
	cmpi.w	#$2,(a1)
	bne.s	.L91B6
	bsr.w	CopyPcmWaveData
	bcs.s	.L91C2
	lea	PcmSampleAddress(pc),a0
	move.w	$2(a1),d0
	lsl.w	#$1,d0
	move.w	PcmAllocPosition(pc),d1
	move.w	d1,(a0,d0.w)
	add.w	PcmLastWaveLength(pc),d1
	or.b	d1,d1
	beq.s	.L91B0
	andi.w	#$FF00,d1
	addi.w	#$100,d1
.L91B0
	lea	PcmAllocPosition(pc),a0
	move.w	d1,(a0)
.L91B6
	adda.l	#$4,a1
	bra.s	.L916C
.L91BE
	ori.b	#$1,ccr
.L91C2
	movem.l	(sp)+,d1/a0-a1
	rts
CopyPcmWaveData
	movem.l	d1-d2/a0-a1,-(sp)
	lea	PcmLastWaveLength(pc),a1
	move.w	d0,(a1)
	move.w	PcmAllocPosition(pc),d1
	beq.s	.L91EC
	clr.w	d1
	sub.w	PcmAllocPosition(pc),d1
	cmp.w	d0,d1
	bhi.s	.L91EC
	move.w	#$4,d0
	ori.b	#$1,ccr
	bra.s	.L9242
.L91EC
	move.w	PcmAllocPosition(pc),d2
	lsr.w	#$8,d2
	lsr.w	#$4,d2
	ori.b	#$80,d2
	move.b	d2,$FF000F.l
	bsr.w	PcmWriteDelay
	move.w	PcmAllocPosition(pc),d1
	andi.l	#$FFF,d1
	lsl.l	#$1,d1
	addi.l	#$FF2001,d1
	movea.l	d1,a1
.L9216
	move.b	(a0)+,d1
	move.b	d1,(a1)
	adda.l	#$2,a1
	cmpa.l	#$FF4001,a1
	bne.s	.L923C
	addi.b	#$1,d2
	move.b	d2,$FF000F.l
	bsr.w	PcmWriteDelay
	movea.l	#$FF2001,a1
.L923C
	dbf	d0,.L9216
	clr.w	d0
.L9242
	movem.l	(sp)+,d1-d2/a0-a1
	rts
SetPcmSoundLoopOffset
	movem.l	d1-d3/a0,-(sp)
	movem.l	d2-d3,-(sp)
	move.w	#$0,d0
	bsr.w	FindPcmRecord
	movem.l	(sp)+,d2-d3
	bcs.s	.L928A
	cmpi.w	#$0,d3
	bne.s	.L9272
	move.b	d2,$6(a0)
	lsr.w	#$8,d2
	move.b	d2,$5(a0)
	clr.w	d0
	bra.s	.L928A
.L9272
	move.b	$5(a0),d0
	lsl.w	#$8,d0
	move.b	$6(a0),d0
	add.w	d2,d0
	move.b	d0,$6(a0)
	lsr.w	#$8,d0
	move.b	d0,$5(a0)
	clr.w	d0
.L928A
	movem.l	(sp)+,d1-d3/a0
	rts
PlayPcmStream
	movem.l	d1-d4/a0-a2,-(sp)
	move.w	sr,-(sp)
	move.w	#$2700,sr
	cmpa.l	#$FFFFFFFF,a0
	bne.s	.L92E2
	lea	PcmStreamActive(pc),a0
	cmpi.w	#$0,(a0)
	bne.s	.L92B2
	clr.w	d0
	bra.w	.L9496
.L92B2
	move.w	#$0,(a0)
	move.w	PcmStreamChannel(pc),d0
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	move.b	#$0,$FF0009.l
	bsr.w	PcmWriteDelay
	move.b	#$0,$FF000B.l
	bsr.w	PcmWriteDelay
	clr.w	d0
	bra.w	.L9496
.L92E2
	cmpa.l	#$0,a0
	bne.s	.L9304
	move.w	PcmStreamActive(pc),d0
	bne.s	.L92FE
	move.l	#$FFFFFFFF,d0
	andi.b	#$FE,ccr
	bra.w	.L9496
.L92FE
	clr.l	d0
	bra.w	.L9496
.L9304
	move.w	PcmStreamActive(pc),d0
	beq.s	.L9316
	move.w	#$7,d0
	ori.b	#$1,ccr
	bra.w	.L9496
.L9316
	lea	PcmStreamSource(pc),a1
	move.l	a0,(a1)+
	move.w	d1,(a1)+
	move.w	d2,(a1)+
	move.w	d3,(a1)+
	lea	PcmAllocPosition(pc),a0
	clr.w	d0
	sub.w	(a0),d0
	cmpi.w	#$800,d0
	bcc.s	.L9344
	cmpi.w	#$200,d0
	bcc.s	.L933E
	move.w	#$4,d0
	ori.b	#$1,ccr
.L933E
	clr.b	d0
	lsr.w	#$1,d0
	bra.s	.L9348
.L9344
	move.w	#$400,d0
.L9348
	lea	PcmStreamHalfA(pc),a1
	move.w	(a0),d1
	move.w	d1,(a1)+
	move.w	d0,(a1)+
	add.w	d0,d1
	move.w	d1,(a1)+
	move.w	d0,(a1)
	clr.w	d0
	bsr.w	FillPcmStreamHalf
	move.w	#$1,d0
	bsr.w	FillPcmStreamHalf
	move.b	PcmChannelOffMask(pc),d0
	move.w	#$7,d1
.L936E
	btst	d1,d0
	bne.s	.L93AE
	dbf	d1,.L936E
	lea	PcmChannelPriority(pc),a0
	move.w	#$FFFF,d1
	move.b	#$FF,d2
	clr.w	d0
.L9384
	cmp.b	(a0),d2
	bcs.s	.L938C
	move.w	d0,d1
	move.b	(a0),d2
.L938C
	adda.l	#$1,a0
	addi.w	#$1,d0
	cmpi.w	#$8,d0
	bne.s	.L9384
	cmpi.w	#$FFFF,d1
	bne.s	.L93AE
	move.w	#$7,d0
	ori.b	#$1,ccr
	bra.w	.L9496
.L93AE
	lea	PcmStreamChannel(pc),a0
	move.w	d1,(a0)
	lea	PcmChannelOffMask(pc),a0
	move.b	(a0),d0
	bset	d1,d0
	move.b	d0,$FF0011.l
	bsr.w	PcmWriteDelay
	move.w	PcmStreamChannel(pc),d0
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	move.w	PcmStreamHalfA(pc),d0
	lsr.w	#$8,d0
	move.b	d0,$FF000D.l
	bsr.w	PcmWriteDelay
	move.w	PcmStreamLoopB(pc),d0
	move.b	d0,$FF0009.l
	bsr.w	PcmWriteDelay
	lsr.w	#$8,d0
	move.b	d0,$FF000B.l
	bsr.w	PcmWriteDelay
	move.w	PcmStreamFrequency(pc),d0
	move.b	d0,$FF0005.l
	bsr.w	PcmWriteDelay
	lsr.w	#$8,d0
	move.b	d0,$FF0007.l
	bsr.w	PcmWriteDelay
	move.w	PcmStreamEnvelope(pc),d0
	move.b	d0,$FF0001.l
	bsr.w	PcmWriteDelay
	move.w	PcmStreamPan(pc),d0
	move.b	d0,$FF0003.l
	bsr.w	PcmWriteDelay
	lea	PcmChannelOffMask(pc),a0
	move.w	PcmStreamChannel(pc),d0
	move.b	(a0),d1
	bclr	d0,d1
	move.b	d1,(a0)
	move.b	d1,$FF0011.l
	bsr.w	PcmWriteDelay
	lea	PcmChannelSlot(pc),a0
	move.w	PcmStreamChannel(pc),d0
	move.b	#$FF,(a0,d0.w)
	lea	PcmChannelSound(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea	PcmChannelNote(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea	PcmChannelVelocity(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea	PcmChannelPriority(pc),a0
	move.b	#$0,(a0,d0.w)
	lea	PcmChannelEnvelope(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea	PcmStreamActive(pc),a0
	move.w	#$FFFF,(a0)
	clr.w	d0
.L9496
	move.w	(sp)+,sr
	movem.l	(sp)+,d1-d4/a0-a2
	rts
FillPcmStreamHalf
	movem.l	d0-d3/a0-a1,-(sp)
	move.l	PcmStreamSource(pc),d1
	cmpi.l	#$FFFFFFFF,d1
	bne.s	.L94B4
	clr.w	d0
	bra.w	.L959C
.L94B4
	cmpi.w	#$0,d0
	bne.s	.L94C4
	move.w	PcmStreamHalfA(pc),d2
	move.w	PcmStreamHalfASize(pc),d3
	bra.s	.L94CC
.L94C4
	move.w	PcmStreamHalfB(pc),d2
	move.w	PcmStreamHalfBSize(pc),d3
.L94CC
	move.w	d2,d1
	lsr.w	#$8,d2
	lsr.w	#$4,d2
	ori.b	#$80,d2
	move.b	d2,$FF000F.l
	bsr.w	PcmWriteDelay
	andi.l	#$FFF,d1
	lsl.l	#$1,d1
	addi.l	#$FF2001,d1
	movea.l	d1,a1
	movea.l	PcmStreamSource(pc),a0
	subi.w	#$1,d3
.L94F8
	move.b	(a0)+,d1
	move.b	d1,(a1)
	adda.l	#$2,a1
	cmpa.l	#$FF4001,a1
	bne.s	.L951E
	addi.b	#$1,d2
	move.b	d2,$FF000F.l
	bsr.w	PcmWriteDelay
	movea.l	#$FF2001,a1
.L951E
	cmpi.b	#$FF,d1
	beq.s	.L9576
	dbf	d3,.L94F8
	move.b	#$FF,(a1)
	lea	PcmStreamSource(pc),a1
	cmpi.w	#$0,d0
	bne.s	.L9556
	clr.l	d1
	move.w	PcmStreamHalfASize(pc),d1
	add.l	(a1),d1
	move.l	d1,(a1)
	lea	PcmStreamLoopB(pc),a1
	move.w	PcmStreamHalfB(pc),d1
	move.w	d1,(a1)
	lea	PcmStreamLastHalf(pc),a1
	move.w	#$0,(a1)
	clr.w	d0
	bra.s	.L959C
.L9556
	clr.l	d1
	move.w	PcmStreamHalfBSize(pc),d1
	add.l	(a1),d1
	move.l	d1,(a1)
	lea	PcmStreamLoopA(pc),a1
	move.w	PcmStreamHalfA(pc),d1
	move.w	d1,(a1)
	lea	PcmStreamLastHalf(pc),a1
	move.w	#$1,(a1)
	clr.w	d0
	bra.s	.L959C
.L9576
	lea	PcmStreamSource(pc),a1
	move.l	#$FFFFFFFF,(a1)
	cmpi.w	#$0,d0
	bne.s	.L9592
	lea	PcmStreamLoopB(pc),a1
	move.w	#$0,(a1)
	clr.w	d0
	bra.s	.L959C
.L9592
	lea	PcmStreamLoopA(pc),a1
	move.w	#$0,(a1)
	clr.w	d0
.L959C
	movem.l	(sp)+,d0-d3/a0-a1
	rts
WaitCdbiosReady
	move.w	#$80,d0
	jsr	$5F22.l
	bcs.s	WaitCdbiosReady
	rts
PcmCommandNoOp
	rts
PcmWriteDelay
	move.l	d0,-(sp)
	move.w	#$28,d0
.L95B8
	nop
	dbf	d0,.L95B8
	move.l	(sp)+,d0
	rts
PcmAllocPosition
	ori.b	#$0,d0
PcmSampleAddress
	dcb.b	512,0
PcmLastWaveLength
	dc.w	$0000
PcmRecordDirectories
	dcb.b	16,0
PcmServiceBusy
	dc.w	$0000
PcmChannelOffMask
	dc.w	$0000
PcmChannelSlot
	ori.b	#$0,d0
	ori.b	#$0,d0
PcmChannelSound
	ori.b	#$0,d0
	ori.b	#$0,d0
PcmChannelNote
	ori.b	#$0,d0
	ori.b	#$0,d0
PcmChannelVelocity
	ori.b	#$0,d0
	ori.b	#$0,d0
PcmChannelPriority
	ori.b	#$0,d0
	ori.b	#$0,d0
PcmChannelEnvelope
	ori.b	#$0,d0
	ori.b	#$0,d0
PcmChannelSegment
	ori.b	#$0,d0
	ori.b	#$0,d0
PcmChannelSegmentTime
	dcb.b	17,0
PcmEnvelopeHeld
	dc.b	$00
PcmLastTimerTick
	dc.w	$0000
PcmCurrentChannel
	dc.w	$0000
PcmEventSlot
	dc.w	$0000
PcmEventNote
	dc.w	$0000
PcmEventVelocity
	dc.w	$0000
PcmEventSound
	dc.w	$0000
PcmReuseFlags
	dc.w	$0000
PcmEventRecord
	ori.b	#$0,d0
PcmStreamActive
	dc.w	$0000
PcmStreamHalfA
	dc.w	$0000
PcmStreamHalfASize
	dc.w	$0000
PcmStreamHalfB
	dc.w	$0000
PcmStreamHalfBSize
	dc.w	$0000
PcmStreamLoopB
	dc.w	$0000
PcmStreamLoopA
	dc.w	$0000
PcmStreamLastHalf
	dc.w	$0000
PcmStreamChannel
	dc.w	$0000
PcmStreamSource
	ori.b	#$0,d0
PcmStreamFrequency
	dc.w	$0000
PcmStreamEnvelope
	dc.w	$0000
PcmStreamPan
	dc.w	$0000
PcmSoundMapping
	dcb.b	128,0
PcmSlotModulation
	dcb.b	128,0
PcmSlotLevel
	dcb.b	128,0
PcmSlotPan
	dcb.b	128,0
PcmPitchControl
	dcb.b	128,0
PcmGroupLevel
	ori.b	#$0,d0
	ori.b	#$0,d0
PcmMasterLevel
	dc.b	$00
PcmModulationLevels
	dc.b	$00
	dc.w	$0000
SyncWithMain
	btst.b	#$7,$FF800E.l
	bne.s	SyncWithMain
.L9AEA
	btst.b	#$6,$FF800E.l
	beq.s	.L9AEA
	bset.b	#$6,$FF800F.l
	bset.b	#$7,$FF800F.l
.L9B04
	btst.b	#$6,$FF800E.l
	bne.s	.L9B04
	bclr.b	#$6,$FF800F.l
	bclr.b	#$7,$FF800F.l
	rts
WaitForSubWordRam
	btst.b	#$1,$FF8003.l
	beq.s	WaitForSubWordRam
	rts
GiveWordRamToMain
	bset.b	#$0,$FF8003.l
.L9B34
	btst.b	#$1,$FF8003.l
	bne.s	.L9B34
	rts
WaitDriveReady
	movem.l	d0-d1/a0-a1,-(sp)
.L9B44
	move.w	#$80,d0
	jsr	$5F22.l
	bcs.s	.L9B44
	movem.l	(sp)+,d0-d1/a0-a1
	rts
DriveInitParams
	dc.w	$01FF
	dcb.b	2073,0
	dc.b	$01
BcdToBinary
	move.l	d1,-(sp)
	move.b	d0,d1
	andi.w	#$FF,d1
	lsr.w	#$4,d1
	mulu.w	#$A,d1
	andi.w	#$F,d0
	add.w	d1,d0
	move.l	(sp)+,d1
	rts
MsfToLba
	movem.l	d1-d2,-(sp)
	lsr.l	#$8,d0
	move.l	d0,d1
	jsr	(BcdToBinary).l
	move.b	d0,d2
	andi.l	#$FF,d2
	move.l	d1,d0
	lsr.l	#$8,d0
	move.l	d0,d1
	jsr	(BcdToBinary).l
	andi.l	#$FF,d0
	mulu.w	#$4B,d0
	add.l	d0,d2
	move.l	d1,d0
	lsr.l	#$8,d0
	jsr	(BcdToBinary).l
	andi.l	#$FF,d0
	mulu.w	#$1194,d0
	add.l	d0,d2
	subi.l	#$96,d2
	move.l	d2,d0
	movem.l	(sp)+,d1-d2
	rts
WaitReadFrame
	bset.b	#$5,$FF800F.l
	move.w	#$0,(ReadHookFlag).l
.LA3EC
	tst.w	(ReadHookFlag).l
	beq.w	.LA3EC
	rts
ReadSectors
	link	a6,#$FFFC
	movem.l	d1-d5/a0-a1/a5,-(sp)
	movea.l	#$FF8000,a5
	move.w	#$5,d4
	move.l	#$FFFFFFFF,d5
.LA410
	subq.l	#$1,d4
	beq.w	.LA4A2
	move.l	$8(a6),d3
	move.l	$C(a6),d2
	lea	$8(a6),a0
	move.w	#$20,d0
	jsr	$5F22.l
.LA42C
	jsr	(WaitReadFrame).l
.LA432
	move.w	#$8A,d0
	jsr	$5F22.l
	bcs.w	.LA42C
	andi.w	#$F8FF,$4(a5)
	ori.w	#$300,$4(a5)
	move.w	#$8B,d0
	jsr	$5F22.l
	bcs.w	.LA410
	movea.l	$10(a6),a0
	lea	-$4(a6),a1
	move.w	#$8C,d0
	jsr	$5F22.l
	bcs.w	.LA410
	move.w	#$8D,d0
	jsr	$5F22.l
	move.l	-$4(a6),d0
	andi.l	#$FFFFFF00,d0
	jsr	(MsfToLba).l
	cmp.l	d0,d3
	bne.w	.LA410
	move.l	a0,$10(a6)
	addq.l	#$1,d3
	subq.l	#$1,d2
	bne.w	.LA432
	move.l	#$0,d5
.LA4A2
	move.l	d5,d0
	movem.l	(sp)+,d1-d5/a0-a1/a5
	unlk	a6
	cmpi.l	#$FFFFFFFF,d0
	bne.s	.LA4DC
	lea	(DriveInitParams).l,a0
	move.w	#$10,d0
	jsr	$5F22.l
	bsr.w	WaitDriveReady
	move.w	#$0,d1
	move.w	#$96,d0
	jsr	$5F22.l
	bsr.w	WaitDriveReady
	bra.w	ReadSectors
.LA4DC
	rts
	dcb.b	2850,0
	dcb.b	8192,0
