; STARTER.BIN PCM chip primitives, file $3FD0-$40F9, runtime $EFD0-$F0F9.
; Init, start channel 0, stop, read the play address, load one $1000-byte bank.

	org	$EFD0

InitFilmPcm							;channel 0 for the film audio: muted, then envelope, pan, FD $0400, one
									;$FF sample
	movea.l	#$FF0000,a0
	move.b	#$FF,$11(a0)
	moveq	#$14,d0
LEFDE	dbra	d0,LEFDE
	move.b	#$C0,$F(a0)
	moveq	#$14,d0
LEFEA	dbra	d0,LEFEA
	move.b	#$FF,$1(a0)
	moveq	#$14,d0
LEFF6	dbra	d0,LEFF6
	move.b	#$FF,$3(a0)
	moveq	#$14,d0
LF002	dbra	d0,LF002
	move.b	#$4,$7(a0)
	moveq	#$14,d0
LF00E	dbra	d0,LF00E
	clr.b	$5(a0)
	moveq	#$14,d0
LF018	dbra	d0,LF018
	clr.b	$B(a0)
	moveq	#$14,d0
LF022	dbra	d0,LF022
	clr.b	$9(a0)
	moveq	#$14,d0
LF02C	dbra	d0,LF02C
	clr.b	$D(a0)
	moveq	#$14,d0
LF036	dbra	d0,LF036
	move.w	#$88,d0
	move.b	d0,$F(a0)
	moveq	#$14,d0
LF044	dbra	d0,LF044
	move.b	#$FF,$2001(a0)
	move.b	#$FF,$2002(a0)
	rts
StartFilmPcm						;channel 0 on
	movea.l	#$FF0000,a0
	move.b	#$80,$F(a0)
	moveq	#$14,d0
LF064	dbra	d0,LF064
	move.b	#$FE,$11(a0)
	rts
StopFilmPcm							;every channel off
	movea.l	#$FF0000,a0
	move.b	#$FF,$11(a0)
	rts
ReadFilmPcmAddress					;channel 0's play address into d0
	movea.l	#$FF0000,a0
	lea.l	$21(a0),a0
	moveq	#$14,d0
LF08A	dbra	d0,LF08A
	move.b	(a0),d1
	move.b	(a0),d1
	addq.w	#$2,a0
	moveq	#$14,d0
LF096	dbra	d0,LF096
	moveq	#$0,d0
	move.b	(a0),d0
	move.b	(a0),d0
	lsl.w	#$8,d0
	move.b	d1,d0
	rts
LoadFilmPcmBank						;$1000 bytes from 4(sp) into wave RAM bank 8(sp)
	movea.l	#$FF0000,a0
	move.l	$8(sp),d0
	ori.w	#$80,d0
	move.b	d0,$F(a0)
	moveq	#$14,d0
LF0BA	dbra	d0,LF0BA
	move.b	d0,$F(a0)
	moveq	#$14,d0
LF0C4	dbra	d0,LF0C4
	lea.l	$2001(a0),a0
	movea.l	$4(sp),a1
	move.w	#$1FF,d3
LF0D4	move.b	(a1)+,(a0)
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
	dbra	d3,LF0D4
	rts
