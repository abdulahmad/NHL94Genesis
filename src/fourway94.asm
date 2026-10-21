;	New in 94: support for the EA 4 Way Play adaptor. It finds out whether the adaptor is plugged
;	in and reads the pads through it.

Detect4WayPlay						;detect the 4 way play adaptor (EA 4 Way Play) on port 2: FourWayPlay = 1
									;when found. Called from Begin
	move.w	#0,(IO_Z80RES).l		;stop the Z80 while the ports are poked
	move.b	#$40,(IO_CT1_CTRL+1).l	;port 1: TH as output
	move.b	#$43,(IO_CT2_CTRL+1).l	;port 2: TH, TR, TL as outputs
	nop								;settle
	move.b	#$7C,(IO_CT2_DATA+1).l	;port 2 out: select the adaptor ID
	nop								;settle
	move.b	#$7F,(IO_CT2_CTRL+1).l	;port 2: all lines as outputs
	nop								;settle
	move.b	#$7C,(IO_CT2_DATA+1).l	;select the adaptor ID again
	nop								;settle
	move.b	(IO_CT1_DATA+1).l,d0	;the adaptor answers with port 1 lines 0-1 low
	andi.b	#3,d0					;lines 0-1
	cmp.b	#0,d0					;both low?
	bne.s	.none					;lines high: no adaptor
	move.w	#1,(FourWayPlay).w		;4 way play on
	bra.s	.x						;adaptor found
.none								;no adaptor: port 2 back to a normal pad
	move.w	#0,(FourWayPlay).w		;4 way play off
	move.b	#$40,(IO_CT2_CTRL+1).l	;port 2: TH as output
.x									;let the Z80 run again
	move.w	#$100,(IO_Z80RES).l		;Z80 runs
	rts								;return
ReadJoySwapPad1						;unused: read 4 way play pad 1 (ReadJoy1 with the pad word swapped in)
	move.b	#0,(IO_CT2_DATA+1).l	;4 way play: select pad
	move.w	(pad4waysave1).w,(pad4wayword).w	;pad 1 state
	jsr	(ReadJoy1).l				;read it
	move.w	(pad4wayword).w,(pad4waysave1).w	;save the state
	rts								;return
ReadJoySwapPad2						;unused: the same for pad 2
	move.b	#$10,(IO_CT2_DATA+1).l	;4 way play: select pad
	move.w	(pad4waysave2).w,(pad4wayword).w	;pad 2 state
	jsr	(ReadJoy1).l				;read it
	move.w	(pad4wayword).w,(pad4waysave2).w	;save the state
	rts								;return
ReadJoySwapPad3						;unused: the same for pad 3
	move.b	#$20,(IO_CT2_DATA+1).l	;4 way play: select pad
	move.w	(pad4waysave3).w,(pad4wayword).w	;pad 3 state
	jsr	(ReadJoy1).l				;read it
	move.w	(pad4wayword).w,(pad4waysave3).w	;save the state
	rts								;return
ReadJoySwapPad4						;unused: the same for pad 4
	move.b	#$30,(IO_CT2_DATA+1).l	;4 way play: select pad
	move.w	(pad4waysave4).w,(pad4wayword).w	;pad 4 state
	jsr	(ReadJoy1).l				;read it
	move.w	(pad4wayword).w,(pad4waysave4).w	;save the state
	rts								;return
	rts								;unreferenced
Set4WayPlayerStub					;An empty Set4WayPlayer (just rts): forcepldata calls it with SCnum $F
									;when a goalie is pulled
	rts								;return
Set4WayPlayer						;unused: put player a3's number (SCnum) in the home or away nibble of
									;PadControlBits34 (unless PadControlBits is -1)
	cmpi.w	#$FFFF,(PadControlBits).w	;no pad control bits?
	beq.w	.x						;yes: done
	movem.l	d0-d2,-(sp)				;save
	move.w	#1,d0					;1 = home side code
	btst	#pfteam,pflags(a3)		;away?
	beq.w	.chkpad3				;no
	move.w	#2,d0					;2 = away
.chkpad3							;side code ready: is this side the pad 3 one?
	cmp.w	(cont3team).w,d0		;pad 3's side?
	beq.w	.pad3					;yes
	move.w	#$F,d1					;not pad 3: keep the low nibble, write the high
	move.w	#4,d0					;shift 4: the high nibble
	bra.w	.set					;set it
.pad3								;pad 3 side: keep the high nibble, write the low
	move.w	#$F0,d1					;keep the high nibble
	move.w	#0,d0					;no shift: the low nibble
.set								;clear the nibble and put the SCnum in it
	and.w	d1,(PadControlBits34).w	;clear the nibble
	move.w	SCnum(a3),d1			;player number
	asl.w	d0,d1					;into place
	or.w	d1,(PadControlBits34).w	;set it
	movem.l	(sp)+,d0-d2				;restore
.x									;exit (also the end of the code above)
	rts								;return
