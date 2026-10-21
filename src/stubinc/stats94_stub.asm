;	Segment build for stats94.asm: sets its origin and the outside routines and data it uses,
;	then includes stats94.asm on its own for checking against the ROM.

	include	macros\genesis.mac		;String

; .region code
	org	$80D4

; includes for stubs to replace removed code
	include	stubinc\ports.inc		;IO_* / VDP_* ports
	include	stubinc\equals.inc		;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement.
AddFramer = $11F12					;jsr / jmp (x).l
AddSmallFont = $11F04				;jsr / jmp (x).l
AdvanceStringPtr = $13510			;jsr / jmp (x).l
AttribAdjust = $FEF7C				;jsr / jmp (x).l
LineEditorMenuText = $19F88			;#x
CalcAttrib = $FA9F8					;jsr / jmp (x).l
DecompressGraphicsWithCallback = $1172C	;bsr.w / Bcc.w
DecompressGraphicsPlain = $11738	;bsr.w / Bcc.w
LineEditorMenuNoLoad = $19FF8		;#x
linelist = $191A6					;#x
FormatAndPrintTime = $11C72			;jsr / jmp (x).l
FormatPlayerName = $18B26			;jsr / jmp (x).l
FormatPlayerNameShort = $18B6E		;jsr / jmp (x).l
FormatPlayerNumInitial = $18AE8		;jsr / jmp (x).l
Framer = $119B8						;jsr / jmp (x).l
GAttribColumns = $1955A				;#x
GetShifter = $1828A					;jsr / jmp (x).l
HandleMenuInput = $7E88				;bsr.w / Bcc.w
InitMenuState = $7E36				;bsr.w / Bcc.w
PAttribColumns = $193F8				;#x
PauseText2 = $1988C					;#x
Penaltylist = $18E0C				;#x
PerLabels = $191E4					;#x
PlayerPositionText = $191D0			;#x
Fprintsmall = $13508				;jsr / jmp (x).l
PutTeamBlock = $8078				;bsr.w / Bcc.w
ProcessInputWithRepeat = $11318		;jsr / jmp (x).l
PushNumber = $11D06					;jsr / jmp (x).l
PushNumberWidth = $11D3A			;jsr / jmp (x).l
PushTime = $11CA2					;jsr / jmp (x).l
ReadTeamStats = $1833A				;jsr / jmp (x).l
RevRinkTiles = $B5188				;#x
Rinktiles = $56062					;#x
setpersonel = $15788				;jsr / jmp (x).l
setplayercolors = $1720C			;jsr / jmp (x).l
Vmaddr = $11680						;bsr.w / Bcc.w
ReadCrowdRecord = $F9BE2			;jsr / jmp (x).l
dobitmap = $1169A					;jsr / jmp (x).l
eraser = $1197E						;jsr / jmp (x).l
forceblack = $10F32					;bsr.w / Bcc.w
getname = $18A90					;jsr / jmp (x).l
getpzjoy = $A41E					;bsr.w / Bcc.w
nodiag = $112F0						;jsr / jmp (x).l
print = $11BA4						;jsr / jmp (x).l
printsmall = $11A48					;jsr / jmp (x).l
printbigz = $11DE2					;jsr / jmp (x).l
printz = $11B92						;jsr / jmp (x).l
printsmallz = $11A36				;jsr / jmp (x).l
rtss2 = $15464						;#x
rtss8 = $A9D4						;bsr.w / Bcc.w
setupEASNmap = $16CAC				;jsr / jmp (x).l
setupIceRinkPal = $16C96			;jsr / jmp (x).l
Sroot = $110BE						;bsr.w / Bcc.w
RestoreTeamEnergy = $13098			;jsr / jmp (x).l
ReloadEnergyBarTiles = $16CC4		;jsr / jmp (x).l
ReloadCrowdTiles = $16CD2			;jsr / jmp (x).l
WriteLineData = $FE696				;jsr / jmp (x).l
LoadHomeTeamGfx = $FEA52			;jsr / jmp (x).l
GetLeagueCrowdRecord = $FEC5E		;jsr / jmp (x).l
ScoutMap = $54E24					;#x
FramerMap = $55B7E					;#x
SmallFontMap = $AAC52				;#x
ScoresMap = $B3E74					;#x
vcountwait = $80BA					;bsr.w / Bcc.w
waitx = $11176						;bsr.w / Bcc.w

NoTiles = $30A
TeamList = $30E
GoalieOdds = 10						;team block offset word (teamdata94)

; Main segment code
	include	stats94.asm
