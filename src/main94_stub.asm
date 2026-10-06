;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	main94 segment stub. Retail $000000-$000309.
;	main94.asm includes macros\genesis.mac itself (it is the first file in hockey94.asm), so this stub does not.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	0

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names (Stack is $FFFFFFFE here; the reset vector uses InitialSP from main94.asm)

; External addresses outside $000000-$000309, read from lst/nhl94.bin.
; The vector longs carry the address itself; jsr (x).l carries it too; bra.w is the displacement word address + displacement.
AddError = $18BFC		;IDA: AdrErr. Vectors $08 (bus error) and $0C (address error)
Illinst = $18C22		;IDA: InvOpCode. Vector $10
ZeroDiv = $18C4C		;IDA: DivBy0. Vector $14
IRQ7 = $15E6C			;IDA: IRQ7 (an rte). Vectors $60-$70 and $7C
VBjsr = $76B2			;IDA: VBjsr. Vector $78 (hockey94_01)
ValidationRoutine = $FFAC0	;IDA: Calc_Checksum. jsr (x).l at $300 (checksum94)
Begin = $76B8			;IDA: Begin. bra.w at $306, displacement $73B0 at $308 (hockey94_01)

; Main segment code
	include	main94.asm
