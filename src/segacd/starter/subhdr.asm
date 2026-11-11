;	STARTER.BIN $90-$1541 (runtime $B090-$C541).
;
;	Zeros after subboot.asm (the stack top is $C41C), a file record (HOCKEY.BIN, $01FF), the words
;	startertail shares at $C42E-$C452, then the driver's two entries: StarterDriverEntry (the start-up) and
;	DispatchPcmCommandEntry (PCM commands). Names given here; docs/segacd_starter_driver.md.


DispatchPcmCommand	equ	$C542
RunStarterDriver	equ	$D85A

	org	$B090

	dcb.b	5008,0
	dc.b	'HOCKEY.BIN'
	dc.w	$0000,$01FF
	dcb.b	20,0
	dc.w	$FFFF
	dcb.b	114,0
StarterDriverEntry
	jmp	(RunStarterDriver).l
DispatchPcmCommandEntry
	bra.w	DispatchPcmCommand
	dcb.b	130,0
