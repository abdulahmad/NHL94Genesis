	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	logic94_1 segment stub. Retail $00B0E8-$00C70F.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$B0E8

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $00B0E8-$00C70F, read from lst/nhl94.bin: jsr / jmp (x).l and movea.l / move.l #x carry
; the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names (hockey94_01 names for
; startpause3 / startpause4).
FaceOffsprites = $191A6		;movea.l #x at $B994
Framer = $119B8			;bsr.w at $B950
GetHot = $106E0			;bsr.w at $BED2
PSandSOpassdir = $FE71C		;jsr (x).l at $C63C
PrintScores1 = $12C04		;bsr.w at $BB5E
ReadGoaliePulled = $FEFCC	;jsr (x).l at $C41C
SetPersonel = $15788		;jsr (x).l at $BB30
SetSPA = $1073A			;bra.w at $B458
Setplass = $15A88		;jmp (x).l at $C6FA
assinsert = $10658		;bsr.w at $BECA
assreplace = $10662		;jsr (x).l at $B234
box = $18A56			;jsr (x).l at $B946
checkob = $E62E			;bsr.w at $B72E
chgplayer = $FF9A8		;jsr (x).l at $BFBC
dirtab = $10E64			;movea.l #x at $BB92
doplayeracc = $10750		;bne.w at $B626
eraser = $1197E			;bsr.w at $BB5A
getpde = $1575A			;jsr (x).l at $BB62
goaliesave = $DBBA		;jsr (x).l at $B5CC
loadTeamStruct = $13040		;bsr.w at $B904
makepde = $15730			;jsr (x).l at $C382
print = $11BA4			;bsr.w at $B98E
printz = $11B92			;bsr.w at $B9DE
puckvzadj = $F66EE		;jsr (x).l at $C532
randomd0 = $11086		;bsr.w at $BDAA
randomd0s = $1107A		;bsr.w at $C474
rtss8 = $A9D4			;beq.w at $BB12 (hockey94_02)
setpde = $1577A			;jsr (x).l at $BB74
sfx = $11132			;bsr.w at $BE1C
sroot = $110BE			;bsr.w at $B55E
startpause1 = $7CBC		;bne.w at $B178 (hockey94_01)
startpause2 = $7CCA		;bne.w at $B17C (hockey94_01)
startpause3 = $7CDC		;beq.w at $B18C. IDA loc_7CDC (hockey94_01)
startpause4 = $7CEA		;bra.w at $B190. IDA loc_7CEA (hockey94_01)
sub_12E66 = $12E66		;bsr.w at $B9A0
sub_13508 = $13508		;bsr.w at $B99A
sub_F6778 = $F6778		;jsr (x).l at $BCA4
sub_F67E4 = $F67E4		;jsr (x).l at $BC88
sub_F6C44 = $F6C44		;jsr (x).l at $B208
sub_FE1AA = $FE1AA		;jsr (x).l at $B152
sub_FEE60 = $FEE60		;jsr (x).l at $B760
unk_44120 = $44120		;move.l #x,(a1) at $B984
vtoa = $10676			;jsr (x).l at $B4EC

; Main segment code
	include	logic94_1.asm
