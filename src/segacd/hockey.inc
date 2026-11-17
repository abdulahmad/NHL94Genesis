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

; --- cartridge routines that are in HOCKEY.BIN (address pairs from tools/segacd_relocs.py) ---
; song is $371D2 (cdrequest.asm) and sfx is $3710C (sfxcd.asm): labels there, not equates.

; --- scouting report (scouting.asm, scoutopen.asm) ---
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
printz		equ	$1DF6E
print		equ	$1DF80
DoDMA_nd2	equ	$379D6
ScoutCrowdRecord	equ	$281D4
PlayedByHome	equ	$2ADB2
PlayedByAway	equ	$2AE5A
GetTeamNickname	equ	$29164
GetTeamArena	equ	$291AA
NextHomeHotPlayer	equ	$23132
NextAwayHotPlayer	equ	$23168
NextHomeColdPlayer	equ	$2328E
NextAwayColdPlayer	equ	$232C4

; --- ScoutingReport (scoutopen.asm) ---
advframe	equ	$1A446			;advantage mark frame
VBint		equ	$18D66			;vblank interrupt vector
disflags	equ	$18D64
Map1col		equ	$18D36
Map2col		equ	$18D3A
homepicchars	equ	$19392
vispicchars	equ	$19394
BigFontchars	equ	$18D40
BigFontMap	equ	$47D38			;pointer to the big font graphics (a loaded file here)
vb2		equ	$3DB90
ReadNameLog	equ	$2262E
BuildHotColdLists	equ	$231A0
Create_HotCold_Table	equ	$2308E
clearTeamStats	equ	$3F11E
setVram		equ	$37B5A
DecompressGraphicsWithRemap	equ	$38946
