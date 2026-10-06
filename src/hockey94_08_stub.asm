	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	hockey94_08 segment stub. Retail $0F739E-$0F8B59.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$F739E

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $0F739E-$0F8B59, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
DecompressGraphicsWithCallback = $1172C	;jsr / jmp (x).l at $F81D6
DoDMA_clearCallbackPointer = $11738	;jsr / jmp (x).l at $F82CA
FigureJoy = $17E42		;jsr / jmp (x).l at $F75CC
Framer = $119B8			;jsr / jmp (x).l at $F7806
MakeTree = $17D80		;jsr / jmp (x).l at $F849C
NewPO = $17D16			;jsr / jmp (x).l at $F76C8
ProcessInputWithRepeat = $11318	;jsr / jmp (x).l at $F832C
ReadJoy1 = $11340		;jsr / jmp (x).l at $F8326
ReadJoy2 = $11358		;jsr / jmp (x).l at $F8356
ReadJoy3 = $11370		;jsr / jmp (x).l at $F837E
ReadJoy4 = $11388		;jsr / jmp (x).l at $F839E
TeamList = $30E			;movea.w #x operand at $F7C7C (teamdata94)
VBlank_SetOptions = $17C42	;#x at $F8168
appstring = $11D9E		;jsr / jmp (x).l at $F8A80
d0toascii = $18BDC		;jsr / jmp (x).l at $F8A72
defaultsprites2 = $16E82		;jsr / jmp (x).l at $F82E8
dobitmap = $1169A		;jsr / jmp (x).l at $F77EA
eraser = $1197E			;jsr / jmp (x).l at $F8228
loc_F92F0 = $F92F0		;IDA label; movea.l #(x+4) operand $F92F4 at $F8948 (the player picture table)
orjoy = $112BC			;jsr / jmp (x).l at $F81C0
print = $11BA4			;jsr / jmp (x).l at $F7BD2
print2 = $11A48			;jsr / jmp (x).l at $F80BC
printz = $11B92			;jsr / jmp (x).l at $F780C
randomd0 = $11086		;jsr / jmp (x).l at $F73E8
setvram = $11594			;jsr / jmp (x).l at $F81BA
sub_17AC8 = $17AC8		;jsr / jmp (x).l at $F844A
sub_17AF4 = $17AF4		;jsr / jmp (x).l at $F7B4E
sub_17CA0 = $17CA0		;jsr / jmp (x).l at $F76CE
sub_1803E = $1803E		;jsr / jmp (x).l at $F73AA
sub_F98C6 = $F98C6		;jsr / jmp (x).l at $F8AB0
sub_F9A64 = $F9A64		;jsr / jmp (x).l at $F8AEE
sub_F9AAC = $F9AAC		;jsr / jmp (x).l at $F8B2C
sub_F9C68 = $F9C68		;jsr / jmp (x).l at $F73C8
sub_FC47C = $FC47C		;jsr / jmp (x).l at $F8496
sub_FD73C = $FD73C		;jsr / jmp (x).l at $F73C2
sub_FE660 = $FE660		;jsr / jmp (x).l at $F739E
sub_FE98A = $FE98A		;bsr.w / Bcc.w at $F8982
unk_4B7A0 = $4B7A0		;#x at $F823A
unk_4DEEE = $4DEEE		;#x at $F826C
unk_AAC5A = $AAC5A		;#x at $F81E8
unk_AFE1A = $AFE1A		;#x at $F84D2
unk_BE272 = $BE272		;#x at $F8200
unk_BEFB8 = $BEFB8		;#x at $F77C2
unk_BF54A = $BF54A		;#x at $F81D0
unk_BF702 = $BF702		;#x at $F87A0
unk_BF70A = $BF70A		;#x at $F82C4
unk_C63F8 = $C63F8		;#x at $F8962
unk_FF462 = $FF462		;#x at $F8692

; Main segment code
	include	hockey94_08.asm
