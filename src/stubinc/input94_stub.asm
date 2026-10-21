;	Segment build for input94.asm: sets its origin and the outside routines and data it uses,
;	then includes input94.asm on its own for checking against the ROM.

	include	macros\genesis.mac		;String

; .region code
	org	$B0E8

; includes for stubs to replace removed code
	include	stubinc\ports.inc		;IO_* / VDP_* ports
	include	stubinc\equals.inc		;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside, read from lst/nhl94.bin: jsr / jmp (x).l and movea.l / move.l #x carry
; the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. (names for
; startpause3 / startpause4).
linelist = $191A6					;movea.l #x
Framer = $119B8						;bsr.w
GetHot = $106E0						;bsr.w
PSandSOpassdir = $FE71C				;jsr (x).l
printscores1 = $12C04				;bsr.w
ReadGoaliePulled = $FEFCC			;jsr (x).l
setpersonel = $15788				;jsr (x).l
SetSPA = $1073A						;bra.w
Setplass = $15A88					;jmp (x).l
assinsert = $10658					;bsr.w
assreplace = $10662					;jsr (x).l
box = $18A56						;jsr (x).l
checkob = $E62E						;bsr.w
chgplayer = $FF9A8					;jsr (x).l
dirtab = $10E64						;movea.l #x at $
runspeed = 200						;acc speed equate (checks94.asm), used by the pass divide
doplayeracc = $10750				;bne.w
eraser = $1197E						;bsr.w
getpde = $1575A						;jsr (x).l
goaliesave = $DBBA					;jsr (x).l
loadTeamStruct = $13040				;bsr.w
makepde = $15730					;jsr (x).l
print = $11BA4						;bsr.w
printz = $11B92						;bsr.w
puckvzadj = $F66EE					;jsr (x).l
randomd0 = $11086					;bsr.w
randomd0s = $1107A					;bsr.w
rtss8 = $A9D4						;beq.w
setpde = $1577A						;jsr (x).l
sfx = $11132						;bsr.w
Sroot = $110BE						;bsr.w
startpause1 = $7CBC					;bne.w
startpause2 = $7CCA					;bne.w
startpause3 = $7CDC					;beq.w.
startpause4 = $7CEA					;bra.w.
linebar = $12E66					;bsr.w
Fprintsmall = $13508				;bsr.w
OneTimerPass = $F6778				;jsr (x).l
OneTimerTarget = $F67E4				;jsr (x).l
PuckOnAttackHalf = $F6C44			;jsr (x).l
ShortenMsgTimer = $FE1AA			;jsr (x).l
CountButtonPress = $FEE60			;jsr (x).l
vtoa = $10676						;jsr (x).l

SPAlist = $5B1C						;#x

; frames94 equates (the segment does not include frames94.asm; it emits bytes)
SPAgdive	=	$2F4
SPAgglover	=	$146
SPAgglovel	=	$178
SPAgstackr	=	$250
SPAgstackl	=	$2A2
SPAgstickr	=	$1EC
SPAgstickl	=	$21E
SPAghighr	=	$148E
SPAghighl	=	$14C0
SPAgstick2r	=	$14F2
SPAgstick2l	=	$1544
SPAfaceoff	=	$FEA
SPAfaceoffr	=	$1014
SPAburst	=	$C5E
SPAhook	=	$1122
SPAHold	=	$C90
SPAgswing	=	$366
SPApassf	=	$718
SPApassb	=	$78A
SPAsweepchk	=	$B24
SPAshotf	=	$7FC
SPAshotb	=	$92E

; Main segment code
	include	input94.asm
