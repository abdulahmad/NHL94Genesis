;	Segment build for hockey94.asm: sets its origin and the outside routines and data it uses,
;	then includes hockey94.asm on its own for checking against the ROM.

	include	macros\genesis.mac		;String

; .region code
	org	$76B2

; includes for stubs to replace removed code
	include	stubinc\ports.inc		;IO_* / VDP_* ports
	include	stubinc\equals.inc		;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside, read from lst/nhl94.bin: jsr / jmp (x).l and movea.l #x carry the
; address; bsr.w / Bcc.w is the displacement word address + displacement.
AddPenalty2 = $11F62				;jmp (x).l
p_turnoff = $1A264					;jsr (x).l.
ChkGoalies = $F6AA					;bsr.w
ChooseSong = $FE556					;jsr (x).l
ClrHor = $12B40						;jsr (x).l
Create_HotCold_Table = $F70A2		;jsr (x).l
EASportsScreen = $17A18				;jsr (x).l.
HiScoreScreen = $FED70				;jsr (x).l.
InitSaveRAM = $1A050				;jsr (x).l.
InitScores = $131F4					;jsr (x).l
KillCrowd = $169D0					;jsr (x).l
LoadCrowdRec = $F6E8A				;jsr (x).l
DefaultMenus = $17C72				;jsr (x).l.
p_music_vblank = $1A50A				;jsr (x).l.
Opening = $172F0					;jmp (x).l
PenaltyManager = $11FF2				;jsr (x).l
printscores1 = $12C04				;jsr (x).l
ReadJoy1 = $11340					;jsr (x).l
ReadJoy2 = $11358					;jsr (x).l
ReadJoy3 = $11370					;jsr (x).l
ReadJoy4 = $11388					;jsr (x).l
SetHor = $12B94						;jsr (x).l
Detect4WayPlay = $F6D5E				;jsr (x).l
p_initialZ80 = $1ACC2				;jsr (x).l.
cd0 = $18CFC						;movea.l #x.
assinsert = $10658					;jsr (x).l
assreplace = $10662					;jsr (x).l
checkwindow = $AFCA					;bsr.w
clearTeamStats = $17102				;jsr (x).l
ClearPenaltyBuffer = $128A4			;jsr (x).l.
eraser = $1197E						;jmp (x).l
forceblack = $10F32					;jsr (x).l
freezewindow = $AFB6				;bsr.w
getpzjoy = $A41E					;bsr.w
IntermissionStart = $17278			;jmp (x).l.
ExitToOpening = $172E4				;jmp (x).l.
ShowInjuryBox = $1871C				;jmp (x).l.
orjoy = $112BC						;jsr (x).l
printsmallz = $11A36				;jsr (x).l
randomd0 = $11086					;jsr (x).l
rtss8 = $A9D4						;bne.w (an rts)
setSlotBit = $F8BA0					;jsr (x).l
setupice = $169FA					;jsr (x).l
setvideo = $15EC0					;jmp (x).l
sfx = $11132						;jsr (x).l
showclock = $162FE					;jsr (x).l
song = $11156						;jsr (x).l
ProcessInputWithRepeat = $11318		;jsr (x).l
ReloadRefHorTiles = $16CE0			;jsr (x).l
stop_current_song = $1A304			;jsr (x).l
InitMenuState = $7E36				;bsr.w, next segment
HandleMenuInput = $7E88				;bsr.w.
RunArenaAnim = $FE2C8				;jsr (x).l
ReadLineData = $FE660				;jsr (x).l
ClearPenalties = $FF88E				;jsr (x).l
PauseMenuItems = $19664				;movea.l #x, pause item list
PauseText = $19700					;movea.l #x, pause item list
PauseText2 = $1988C					;movea.l #x, pause item list
updateplayers = $A9D6				;bsr.w
updatepwrplay = $12A7C				;jmp (x).l
updatereplay = $A8CA				;bsr.w
updatesound = $16976				;jsr (x).l
vcountwait = $80BA					;bsr.w.

; Main segment code
	include	hockey94.asm
