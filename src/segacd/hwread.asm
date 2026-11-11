; MAIN.BIN hardware readers, $FF4B3C-$FF4C3B.
; One rts each. Argument is $A12022. Reply is $A12010.
; Includes move.w $C00008,$A12010 (HV counter). See docs/segacd_film.md.
; Each is a game shell command (ShellCommandTable, main/maintable.asm; docs/segacd_main_shell.md),
; except ReadVdpStatusCommand, which no table entry points at.

	org	$FF4B3C

WriteVdpControlByteCommand			;command $09
	move.b	$A12022.l,$C00004.l
	rts
WriteVdpControlWordCommand			;command $0A
	move.w	$A12022.l,$C00004.l
	rts
WriteVdpControlLongCommand			;command $0B
	move.l	$A12022.l,$C00004.l
	rts
WriteVdpDataByteCommand				;command $0C
	move.b	$A12022.l,$C00000.l
	rts
WriteVdpDataWordCommand				;command $0D
	move.w	$A12022.l,$C00000.l
	rts
WriteVdpDataLongCommand				;command $0E
	move.l	$A12022.l,$C00000.l
	rts
WritePad1DataCommand				;command $0F: pad 1 data port
	move.b	$A12022.l,$A10003.l
	rts
WritePad2DataCommand				;command $10: pad 2 data port
	move.b	$A12022.l,$A10005.l
	rts
WritePad1CtrlCommand				;command $11: pad 1 control port
	move.b	$A12022.l,$A10009.l
	rts
WritePad2CtrlCommand				;command $12: pad 2 control port
	move.b	$A12022.l,$A1000B.l
	rts
ReadPad1DataCommand					;command $13
	move.b	$A10003.l,$A12010.l
	rts
ReadPad2DataCommand					;command $14
	move.b	$A10005.l,$A12010.l
	rts
ReadVdpDataWordCommand				;command $15
	move.w	$C00000.l,$A12010.l
	rts
ReadVdpDataLongCommand				;command $16
	move.l	$C00000.l,$A12010.l
	rts
ReadVdpStatusCommand				;not in ShellCommandTable
	move.w	$C00004.l,$A12010.l
	rts
WriteZ80BusReqCommand				;command $1A
	move.w	$A12022.l,$A11100.l
	rts
ReadHvCounterCommand				;command $1B: the HV counter (the game's random seed)
	move.w	$C00008.l,$A12010.l
	rts
ReadHvCounterByteCommand			;command $1C
	move.b	$C00008.l,$A12010.l
	rts
ReadByteAtAddressCommand			;command $17
	movea.l	$A12022.l,a0
	move.b	(a0),$A12010.l
	rts
ReadWordAtAddressCommand			;command $18
	movea.l	$A12022.l,a0
	move.w	(a0),$A12010.l
	rts
ReadLongAtAddressCommand			;command $19
	movea.l	$A12022.l,a0
	move.l	(a0),$A12010.l
	rts
