;	Segment build for title94.asm: sets its origin and the outside routines and data it uses,
;	then includes title94.asm on its own for checking against the ROM.

	include	macros\genesis.mac		;String

; .region code
	org	$FE556

; includes for stubs to replace removed code
	include	stubinc\ports.inc		;IO_* / VDP_* ports
	include	stubinc\equals.inc		;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement.
DecompressGraphicsWithCallback = $1172C	;jsr / jmp (x).l
DoDMA = $113E4						;jsr / jmp (x).l
DecompressGraphicsPlain = $11738	;jsr / jmp (x).l
HiScoreImg = $F5338					;#x
MakeSRAMChecksum = $1A206			;jsr / jmp (x).l
p_music_vblank = $1A50A				;jsr / jmp (x).l
NHLShieldImg = $52DAA				;#x
PAlogoImg = $5338C					;#x
PushNumberWidth = $11D3A			;jsr / jmp (x).l
ReadSRAM = $1A244					;jsr / jmp (x).l
SetSPA = $1073A						;jsr / jmp (x).l
SetSframe = $16178					;jsr / jmp (x).l
Setplass = $15A88					;jsr / jmp (x).l
Sweepcheck = $C0AE					;jsr / jmp (x).l
TitleImg = $5394E					;#x
TitleScreenImg = $4E45C				;#x
WriteSRAM = $1A1E4					;jsr / jmp (x).l
appendz = $11D96					;jsr / jmp (x).l
appstring = $11D9E					;jsr / jmp (x).l
assexit = $10646					;jsr / jmp (x).l
ReadCrowdRecord = $F9BE2			;jsr / jmp (x).l
cramfade = $10FB6					;jsr / jmp (x).l
dobitmap = $1169A					;jsr / jmp (x).l
eraser = $1197E						;jsr / jmp (x).l
forceblack = $10F32					;jsr / jmp (x).l
setVram_0 = $115AA					;jsr / jmp (x).l
orjoy = $112BC						;jsr / jmp (x).l
print = $11BA4						;jsr / jmp (x).l
printz = $11B92						;jsr / jmp (x).l
randomd0 = $11086					;jsr / jmp (x).l
setc1player = $C0BC					;jsr / jmp (x).l
setc2player = $C0DA					;jsr / jmp (x).l
setVram = $11594					;jsr / jmp (x).l
song = $11156						;jsr / jmp (x).l
CopyString = $F997A					;bsr.w / Bcc.w
GetLogName = $FB992					;bsr.w / Bcc.w
SmallFontMap = $AAC52				;#x
PlayoffSprite = $F3098				;#x
HotIconMap = $F5AF6					;#x
ColdIconMap = $F5D1C				;#x
vb2 = $15E4C						;#x
waitx = $11176						;jsr / jmp (x).l

Credits = $5776						;#x
CreditsList = $57B8					;#x
ArenaGfxBank = $E9ED6				;dc.l x+n in ArenaAnims and TeamGfxList
PlayoffSprite = $F3098				;#x+$12E0

; frames94 equates (the segment does not include frames94.asm; it emits bytes)
SPAbenchcheckl	=	$193E
SPAbenchcheckr	=	$1A00
SPAboardleft	=	$18CC
SPAboardright	=	$17E8
SPAboardfront	=	$1776
SPAboardback	=	$185A
SPAglide	=	$50C

NoTiles = $30A

; Main segment code
	include	title94.asm
