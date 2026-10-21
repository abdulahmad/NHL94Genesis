;	Segment build for replay94.asm: sets its origin and the outside routines and data it uses,
;	then includes replay94.asm on its own for checking against the ROM.

	include	macros\genesis.mac		;String

; .region code
	org	$9FD0

; includes for stubs to replace removed code
	include	stubinc\ports.inc		;IO_* / VDP_* ports
	include	stubinc\equals.inc		;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside, read from lst/nhl94.bin: jsr / jmp (x).l and movea.l #x carry the
; address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement.
ClrHor = $12B40						;jsr (x).l
DoFill = $11544						;bsr.w
ReadJoy1 = $11340					;bra.w
ReadJoy2 = $11358					;bne.w
ReadJoy3 = $11370					;beq.w
ReadJoy4 = $11388					;bra.w
RevRinkTilelist = $B5180			;movea.l #x
Rinktilelist = $5605A				;movea.l #x
SPAlist = $5B1C						;movea.l #x.
SetHor = $12B94						;jsr (x).l
SprSort = $1702E					;jsr (x).l
asstab = $18D7C						;movea.l #x
checkcoll = $138AC					;jsr (x).l
dobitmap = $1169A					;bra.w
doinput = $B0E8						;bsr.w, the next byte
eraser = $1197E						;jmp (x).l
forceblack = $10F32					;bsr.w
forceblack2 = $10F5C				;bsr.w
loadTeamStruct = $13040				;jsr (x).l
printz = $11B92						;bsr.w
revframetbl = $F600E				;movea.l #x
SetSflags8Bit1 = $FEF66				;jsr (x).l
setvideo = $15EC0					;jsr (x).l
sfx = $11132						;bsr.w
DecompressGraphicsPlain = $11738	;jsr (x).l
setupEASNmap = $16CAC				;jsr (x).l
ReloadEnergyBarTiles = $16CC4		;jsr (x).l
ReloadCrowdTiles = $16CD2			;jsr (x).l
ReloadRefTiles = $16CEE				;jsr (x).l
ReloadFaceOffTiles = $16CFC			;jsr (x).l
ReloadFaceOffMap = $16D0A			;jsr (x).l
ReloadRinkGraphics = $9CDC			;jsr (x).l
setpads = $C656						;bsr.w
PlaceBoardFall = $FEB54				;jsr (x).l
ReplayMap = $BB4EE					;movea.l #x
vcountwait = $80BA					;jsr (x).l.
vtoa = $10676						;jsr (x).l

; frames94 equates (the segment does not include frames94.asm; it emits bytes)
SPFpuck	=	394
SPFbglass	=	653
SPFfight	=	354
SPFPen	=	377
SPAbenchcheckl	=	$193E
SPAbenchcheckr	=	$1A00
SPAboardleft	=	$18CC
SPAboardright	=	$17E8
SPAboardfront	=	$1776
SPAboardback	=	$185A
SPAinjuryfall	=	$145C
SPAinjury1	=	$1AF4

NoTiles = $30A

; Main segment code
	include	replay94.asm
