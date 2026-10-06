	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	hockey94_03 segment stub. Retail $0138AC-$014549.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$138AC

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $0138AC-$014549, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
AddPenalty = $11F2C		;bsr.w / Bcc.w at $13CC0. penalty94_1
AddPenalty2 = $11F62		;bsr.w / Bcc.w at $1447A. penalty94_1
GetHot = $106E0			;bsr.w / Bcc.w at $138FC. logic94_5
PenShotChk = $1211A		;jsr / jmp (x).l at $13DDA. penalty94_1
SetSPA = $1073A			;bsr.w / Bcc.w at $13D50. logic94_5
Stop4Pen = $124A6		;bsr.w / Bcc.w at $14490. penalty94_1
checkfight = $1454A		;bsr.w / Bcc.w at $13B1E. hockey94_04 (an rts)
checkwallcoll2 = $1454C		;bsr.w / Bcc.w at $138DC. hockey94_04
chkFgtBit1 = $FECA2		;jsr / jmp (x).l at $14530
getFgtbyte = $FEC98		;jsr / jmp (x).l at $144FE
randomd0 = $11086		;bsr.w / Bcc.w at $13BB6. middle94_1
rtss2 = $15464			;bsr.w / Bcc.w at $13BEC. an rts
sfx = $11132			;bsr.w / Bcc.w at $13BCE. middle94_1
song = $11156			;bsr.w / Bcc.w at $144A6. middle94_1
sub_FE510 = $FE510		;jsr / jmp (x).l at $142D6
vtoa = $10676			;bsr.w / Bcc.w at $13D22. logic94_5
wallcollduringcheck = $F8B5A	;jsr / jmp (x).l at $13D7E

; Main segment code
	include	hockey94_03.asm
