	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	hockey94_01 segment stub. Retail $0076B2-$007E35.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$76B2

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $0076B2-$007E35, read from lst/nhl94.bin: jsr / jmp (x).l and movea.l #x carry the
; address; bsr.w / Bcc.w is the displacement word address + displacement. IDA names (93 name in the comment).
AddPenalty2 = $11F62		;jmp (x).l at $7C38
AllSndOff = $1A264		;jsr (x).l at $76EE. 93 p_turnoff
ChkGoalies = $F6AA		;bsr.w at $79D0
ChooseSong = $FE556		;jsr (x).l at $7918
ClrHor = $12B40			;jsr (x).l at $7D8A
Create_HotCold_Table = $F70A2	;jsr (x).l at $77A4
EASportsScreen = $17A18		;jsr (x).l at $770C. attract94
HiScoreScreen = $FED70		;jsr (x).l at $771E. attract94
InitSaveRAM = $1A050		;jsr (x).l at $7712. sram94
InitScores = $131F4		;jsr (x).l at $77CC
KillCrowd = $169D0		;jsr (x).l at $76FA
LoadCrowdRec = $F6E8A		;jsr (x).l at $77D8
LoadDefMenuOptions = $17C72	;jsr (x).l at $7724. attract94
MusicVB = $1A50A			;jsr (x).l at $76F4. 93 p_music_vblank
Opening = $172F0			;jmp (x).l at $773C
PenaltyManager = $11FF2		;jsr (x).l at $799E
PrintScores1 = $12C04		;jsr (x).l at $7DAE
ReadJoy1 = $11340		;jsr (x).l at $7756
ReadJoy2 = $11358		;jsr (x).l at $7C7A
ReadJoy3 = $11370		;jsr (x).l at $7C90
ReadJoy4 = $11388		;jsr (x).l at $7CA2
SetHor = $12B94			;jsr (x).l at $7D80
Unk_ControlsSetRelated = $F6D5E	;jsr (x).l at $7700
Z80_LoadROM = $1ACC2		;jsr (x).l at $76E8. 93 p_initialZ80
cd0 = $18CFC			;movea.l #x at $7AE2. IDA _cd0 (hockey94_11)
assinsert = $10658		;jsr (x).l at $7B66
assreplace = $10662		;jsr (x).l at $78CA
checkwindow = $AFCA		;bsr.w at $7990
clearTeamStats = $17102		;jsr (x).l at $778C
clrPenBuf = $128A4		;jsr (x).l at $7C16. 93 ClearPenaltyBuffer
eraser = $1197E			;jmp (x).l at $7E08
forceblack = $10F32		;jsr (x).l at $7CF8
freezewindow = $AFB6		;bsr.w at $7B58
getpzjoy = $A41E			;bsr.w at $7D50
loc_17278 = $17278		;jmp (x).l at $77DE. 93 IntermissionStart
loc_172E4 = $172E4		;jmp (x).l at $7CB6. 93 ExitToOpening
loc_1871C = $1871C		;jmp (x).l at $79F2. 93 ShowInjuryBox
orjoy = $112BC			;jsr (x).l at $7736
printz2 = $11A36			;jsr (x).l at $7DF2
randomd0 = $11086		;jsr (x).l at $783C
rtss8 = $A9D4			;bne.w at $79BE (an rts)
setSlotBit = $F8BA0		;jsr (x).l at $798A
setupice = $169FA		;jsr (x).l at $77D2
setvideo = $15EC0		;jmp (x).l at $7998
sfx = $11132			;jsr (x).l at $7B52
showclock = $162FE		;jsr (x).l at $7D54
song = $11156			;jsr (x).l at $7922
sub_11318 = $11318		;jsr (x).l at $7D5A
sub_16CE0 = $16CE0		;jsr (x).l at $7D7A
sub_1A304 = $1A304		;jsr (x).l at $797A
sub_7E36 = $7E36			;bsr.w at $7D48. 93 InitMenuState, next segment
sub_7E88 = $7E88			;bsr.w at $7D60. 93 HandleMenuInput
sub_FE2C8 = $FE2C8		;jsr (x).l at $79A8
sub_FE660 = $FE660		;jsr (x).l at $7718
sub_FF88E = $FF88E		;jsr (x).l at $7C2E
unk_19664 = $19664		;movea.l #x at $7D2E. pause item list (94 only)
unk_19700 = $19700		;movea.l #x at $7D1A. pause item list (93 PauseText)
unk_1988C = $1988C		;movea.l #x at $7D42. pause item list (93 PauseText2)
updateplayers = $A9D6		;bsr.w at $7962
updatepwrplay = $12A7C		;jmp (x).l at $79E4
updatereplay = $A8CA		;bsr.w at $7994
updatesound = $16976		;jsr (x).l at $79AE
vcountwait = $80BA		;bsr.w at $7D4C. 93 MenuWaitVblank

; Main segment code
	include	hockey94_01.asm
