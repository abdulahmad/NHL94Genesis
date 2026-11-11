;	HOCKEY.BIN $7DDC-$7E37 (runtime $22DDC-$22E37): fourway94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	CD: Detect4WayPlay and the ReadJoySwapPad routines are gone (the sub CPU has no pad ports);
;	one rts, called by nothing, is left where they were. Set4WayPlayer is the cartridge code.

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

	org	$22DDC

ReadJoySwapPad4						;CD: its first lines have no twin; the rest of it starts here
	rts
Set4WayPlayerStub					;An empty Set4WayPlayer (just rts): forcepldata calls it with SCnum $F
									;when a goalie is pulled
	rts
Set4WayPlayer						;unused: put player a3's number (SCnum) in the home or away nibble of
									;PadControlBits34 (unless PadControlBits is -1)
	cmpi.w	#$FFFF,(PadControlBits).l	;no pad control bits?
	beq.w	.x
	movem.l	d0-d2,-(sp)
	move.w	#1,d0					;1 = home side code
	btst.b	#pfteam,pflags(a3)		;away?
	beq.w	.chkpad3
	move.w	#2,d0
.chkpad3							;side code ready: is this side the pad 3 one?
	cmp.w	(cont3team).l,d0		;pad 3's side?
	beq.w	.pad3
	move.w	#$F,d1					;not pad 3: keep the low nibble, write the high
	move.w	#4,d0					;shift 4: the high nibble
	bra.w	.set
.pad3								;pad 3 side: keep the high nibble, write the low
	move.w	#$F0,d1					;keep the high nibble
	move.w	#0,d0					;no shift: the low nibble
.set								;clear the nibble and put the SCnum in it
	and.w	d1,(PadControlBits34).l
	move.w	SCnum(a3),d1
	asl.w	d0,d1
	or.w	d1,(PadControlBits34).l
	movem.l	(sp)+,d0-d2
.x									;exit (also the end of the code above)
	rts
