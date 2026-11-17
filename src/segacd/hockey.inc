; HOCKEY.BIN names shared by the disc fragments, in the 94 Genesis spelling.
; HOCKEY.BIN is entered at $1B000 and its work RAM is the cartridge's, moved by a
; different amount for each block of variables, so each name below carries its own
; disc address. The cartridge address is in the comment (docs/segacd-handoff/name_map.csv).
; Nothing here changes an encoding: every use is a long absolute address.

; --- variables (name = 94G ram94.asm name) ---
Crowdframe	equ	$17CD0			;cartridge $B89A, frame byte is the high byte of the word
Crowdlevel	equ	$17CD2			;cartridge $B89C
Crowdstep	equ	$17CD4			;cartridge $B89E
Crowdcnt	equ	$17CD6			;cartridge $B8A0
asv		equ	$1747A			;cartridge $B044
lastsfx		equ	$17F64			;cartridge $C016
VertLineScrolling	equ	$1A450		;cartridge $D5AE
PlayerScrollCtr	equ	$1A452			;cartridge $D5B0
SelectedPlayerIdx	equ	$1A454		;cartridge $D5B2
ScoutingReportTimer	equ	$1A456		;cartridge $D5B4
scoutcolumn	equ	$1A44E			;cartridge $D5AC (DispAttribCtr)
TestList	equ	$1A45A			;cartridge $D5B8
tmstruct	equ	$1834C			;cartridge $C6CE
awtmstruct	equ	$186B2			;cartridge $CA32

LOAD		equ	$1B000			;HOCKEY.BIN runtime address = file offset + LOAD. A bsr or bra to a name
						;below is written name-LOAD (orgs are file offsets, operands runtime)

; --- cartridge routines that are in HOCKEY.BIN (address pairs from tools/segacd_relocs.py) ---
; song is $371D2 (cdrequest.asm) and sfx is $3710C (sfxcd.asm): labels there, not equates.

; --- scouting report (scouting.asm, scout94.asm) ---
ScoutingReportText	equ	$47CFC		;pointer to the loaded Ron Barr script (the cartridge has it inline)
scoutparaoff	equ	$17462			;disc only: byte offset of the next paragraph, replaces the cartridge's line skip
mesarea		equ	$17EF2			;counted string (length word, then bytes)
TextBuffer	equ	$17EF4			;mesarea + 2
VmMAP1		equ	$18D34			;cartridge $B004
screentimer	equ	$1A458			;frames until the screen is left
awayhotter	equ	$17EA0
printx		equ	$18D58			;cartridge $B028
printy		equ	$18D5A			;cartridge $B02A
HomeTeamRosterPtr	equ	$1836A		;tmstruct+tmdata
AwayTeamRosterPtr	equ	$186D0		;awtmstruct+tmdata
tmdata		equ	$1E			;team data address, as the cartridge
Teamname	equ	4			;record offset of the word offset to the team name
tmgoalie	equ	$28			;goalie 1/2/none: $28 on the disc, $26 on the cartridge
pldsize		equ	8

; routines of the cartridge that HOCKEY.BIN calls at these addresses
rtss2		equ	$21000			;a bare rts

; --- ScoutingReport (scout94.asm) ---
advframe	equ	$1A446			;advantage mark frame
VBint		equ	$18D66			;vblank interrupt vector
disflags	equ	$18D64
Map1col		equ	$18D36
Map2col		equ	$18D3A
homepicchars	equ	$19392
vispicchars	equ	$19394
BigFontchars	equ	$18D40
BigFontMap	equ	$47D38			;pointer to the big font graphics (a loaded file here)

; --- the matchup screen (scout94.asm); variables share the delta $CEA2 with the scouting text ---
matchup		equ	$1A43A			;cartridge $D598
scoutunused	equ	$1A43C
matchuphome	equ	$1A43E
matchupvis	equ	$1A440
advcount	equ	$1A448
matchuptimer	equ	$1A44A
scoutwait	equ	$1AD8E
hoticonchars	equ	$1AD86
coldiconchars	equ	$1AD88
smallfont2chars	equ	$18D44
framercset	equ	$18D4E
printfontset	equ	$18D60
palcount	equ	$18D62
HomeTeam	equ	$17FAE
VisTeam		equ	$17FB0
OptNOP		equ	$18BFC
waitxpad	equ	$1AD76

; --- loaded scouting files and the disc-only speech state (scoutload.asm fills the pointers) ---
ScoutSavedSP	equ	$47D00			;disc only: the caller's stack
ScoutSpeechTable	equ	$47DA4		;disc only: 8 byte entries by paragraph, {CD position, length} of the speech clip
FramerMap	equ	$47D10
EASportsBGMap	equ	$47D0C
SmallFontMap	equ	$47D3C
HotMap		equ	$47D98
ColdMap		equ	$47D9C
RonBarrMap	equ	$47D54
ScoutCDArg	equ	$47D60			;disc only: argument block for _CDBIOS function $18
SDKCall		equ	$6044			;disc only: SDK entry, function number in d7
_CDBIOS		equ	$5F22			;disc only: Sega CD BIOS entry
ScoutLastPara	equ	$17466			;disc only: set when the last paragraph ($21) is reached

; --- scout94.asm ---
matchupslot	equ	$1A44C
homerating	equ	$1A442
visrating	equ	$1A444
printa		equ	$18D5C
teamrecbuf	equ	$BC0C8			;SRAM team record buffer
TempBuffer	equ	$17E70
sflags6		equ	$17F76
ThreeStars	equ	$BC000
TeamList	equ	$1B00C
PAttribOverallMask	equ	$41C70
GAttribOverallMask	equ	$41DD2
PicturePalette	equ	$428A0
picturebuf	equ	$1A8C0
TeamLogoPalettes	equ	$2AF56
TeamLogoBitmaps	equ	$47D8C			;pointer, a loaded file here
ScoutSubStatus	equ	$17474			;disc only: word the sub CPU sets when the speech clip is done

; print control codes (cartridge ram94.asm)
CC_SetFont	equ	$F9
CC_SetMapAndPosition	equ	$F8
CC_Font1	equ	$FF
CC_Font2	equ	$FE
CC_Font3	equ	$FD
CC_Font1Pal1	equ	$EF
CC_Font1Pal2	equ	$DF
CC_Font2Pal2	equ	$DE
