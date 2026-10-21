;	Segment build for assign94.asm: sets its origin and the outside routines and data it uses,
;	then includes assign94.asm on its own for checking against the ROM.

	include	macros\genesis.mac		;String

; .region code
	org	$C67A

; includes for stubs to replace removed code
	include	stubinc\ports.inc		;IO_* / VDP_* ports
	include	stubinc\equals.inc		;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement.
EvadePC = $E594						;lea (x,pc)
ReadGoaliePulled = $FEFCC			;jsr / jmp (x).l
SetSPA = $1073A						;bsr.w / Bcc.w
Setplass = $15A88					;jsr / jmp (x).l
SprSort = $1702E					;jsr / jmp (x).l
assexit = $10646					;bsr.w / Bcc.w
assreplace = $10662					;bsr.w / Bcc.w
changeplayer = $BFBC				;bsr.w / Bcc.w.
check4check = $EACE					;bsr.w / Bcc.w at $
chkpk = $E264						;bsr.w / Bcc.w
doplayeracc = $10750				;bsr.w / Bcc.w
playeracc = $10BC2					;bsr.w / Bcc.w
randomd0 = $11086					;bsr.w / Bcc.w
rtss2 = $15464						;#x, the rts
rtss3 = $C678						;bsr.w / Bcc.w, (setpads rts)
setpads = $C656						;bsr.w / Bcc.w.
setplayer = $15AA4					;jsr / jmp (x).l
skateto = $103C8					;bsr.w / Bcc.w
vtoa = $10676						;bsr.w / Bcc.w

; frames94 equates (the segment does not include frames94.asm; it emits bytes)
SPAglide	=	$50C
SPAgready	=	$2
SPAwallleft	=	$FAC
SPAwallright	=	$F6E
SPAfaceoff	=	$FEA
SPAfaceoffr	=	$1014
SPAstanley	=	$109E
SPAcelebrate	=	$E8A
SPApump	=	$EFC

; Main segment code
	include	assign94.asm
