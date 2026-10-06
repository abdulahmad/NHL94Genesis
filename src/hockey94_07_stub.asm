	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	hockey94_07 segment stub. Retail $0FCB9A-$0FD617.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$FCB9A

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $0FCB9A-$0FD617, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
AddSmallFont = $11F04		;jsr / jmp (x).l at $FCD08
AttribAdjust = $FEF7C		;bsr.w / Bcc.w at $FD376
CalcAttrib = $FA9F8		;bsr.w / Bcc.w at $FD36C
Create_HotCold_Table = $F70A2	;jsr / jmp (x).l at $FCCA6
DecompressGraphicsWithCallback = $1172C	;jsr / jmp (x).l at $FCCFA
DoDMA_clearCallbackPointer = $11738	;jsr / jmp (x).l at $FCE18
Framer = $119B8			;jsr / jmp (x).l at $FCDA8
PushNumberWidth = $11D3A		;jsr / jmp (x).l at $FCFCC
TeamList = $30E			;#x at $FCC62
appstring = $11D9E		;jsr / jmp (x).l at $FCC26
clearTeamStats = $17102		;jsr / jmp (x).l at $FCC98
clrCrowdRAM = $F9BE2		;jsr / jmp (x).l at $FCBAC
dobitmap = $1169A		;jsr / jmp (x).l at $FCD62
dword_19420 = $19420		;move.l (x).l operand at $FD310
dword_19582 = $19582		;move.l (x).l operand at $FD31E
eraser = $1197E			;jsr / jmp (x).l at $FD1E8
print2 = $11A48			;jsr / jmp (x).l at $FCFD2
printbigz = $11DE2		;jsr / jmp (x).l at $FCD68
printz = $11B92			;jsr / jmp (x).l at $FCD3E
printz2 = $11A36			;jsr / jmp (x).l at $FD206
setvram = $11594			;jsr / jmp (x).l at $FCCD6
song = $11156			;jsr / jmp (x).l at $FCC8A
sub_17718 = $17718		;jsr / jmp (x).l at $FCE5C
sub_17730 = $17730		;jsr / jmp (x).l at $FCF5A
sub_F71A2 = $F71A2		;jsr / jmp (x).l at $FCC7C
sub_F7318 = $F7318		;jsr / jmp (x).l at $FCE72
sub_F997A = $F997A		;jsr / jmp (x).l at $FCC08
sub_F998E = $F998E		;jsr / jmp (x).l at $FCBCA
sub_F9C68 = $F9C68		;jsr / jmp (x).l at $FCC76
sub_FA014 = $FA014		;bsr.w / Bcc.w at $FCC22
sub_FAE26 = $FAE26		;jsr / jmp (x).l at $FD0EE
sub_FD89A = $FD89A		;bsr.w / Bcc.w at $FD368
sub_FE172 = $FE172		;bsr.w / Bcc.w at $FCFC0
sub_FE98A = $FE98A		;bsr.w / Bcc.w at $FD170
unk_54E24 = $54E24		;#x at $FCD4A
unk_55B86 = $55B86		;#x at $FCD26
unk_A9A18 = $A9A18		;#x at $FCCF4
unk_AAC5A = $AAC5A		;#x at $FCD12
unk_B389C = $B389C		;#x at $FCDEE
unk_C63F8 = $C63F8		;#x at $FD150
unk_F5AFE = $F5AFE		;#x at $FCE0E
unk_F5D24 = $F5D24		;#x at $FCE1E
unk_F86F2 = $F86F2		;#x at $FD1F2
unk_FF462 = $FF462		;#x at $FD19A
vb2 = $15E4C			;#x at $FCC90
waitx = $11176			;jsr / jmp (x).l at $FCEC4

; Main segment code
	include	hockey94_07.asm
