;	RAM map. Names the work RAM variables, the hardware ports and the offsets inside the game's structures.
;	Equates only: it adds nothing to the ROM.
;
;	Hardware ports, sprite sizes, controller ports and the stack, button bits, song and sound numbers, rink
;	distances, the replay buffer and sort object sizes come first (93 ram93.asm order), then the record
;	offsets.
;
;	Then the variables allocated with rs from varstart. The rs order sets the addresses and is fixed.

;video and sound ports
Asound	equ	$C00011					;PSG sound port
Vdata	equ	$C00000					;video ports. Control port offset from a0 = Vdata: move.w
									;#x,Vctrl-Vdata(a0) with a0 = Vdata
Vctrl	equ	Vdata+4
VRAM_W	equ	$40000000				;VDP command: VRAM write, address 0
CRAM_W	equ	$C0000000				;VDP command: CRAM write, address 0
VSRAM_W	equ	$40000010				;VDP command: VSRAM write, address 0
;sprite sizes
MaxSprites equ 64					;max sprites during game (64 because 32 col mode)

refwidth equ 7						;width of ref.map frames
refheight equ 8						;height of ref.map frames
PAL_MODE equ 0						;VDP status bit 0 = PAL (50 Hz)
;VDP register write words for the control port (register number in the high byte): move.w
;#VDPR_MODE2+$74,(Vctrl)
VDPR_MODE1 equ $8000
VDPR_MODE2 equ $8100
VDPR_PLANEA equ $8200				;plane A name table address / $400
VDPR_WINDOW equ $8300				;window name table address / $400
VDPR_PLANEB equ $8400				;plane B name table address / $2000
VDPR_SPRITE equ $8500				;sprite table address / $200
VDPR_BGCOL equ $8700				;backdrop colour
VDPR_HINT equ $8A00					;h interrupt counter
VDPR_MODE3 equ $8B00
VDPR_MODE4 equ $8C00
VDPR_HSCROLL equ $8D00				;h scroll table address / $400
VDPR_AUTOINC equ $8F00				;auto increment (VmInc macro)
VDPR_PLANESIZE equ $9000
VDPR_WINX equ $9100					;window h position
VDPR_WINY equ $9200					;window v position
VDPR_DMALENL equ $9300
VDPR_DMALENH equ $9400
VDPR_DMASRCL equ $9500
VDPR_DMASRCM equ $9600
VDPR_DMASRCH equ $9700

;hardware
IO_CT1_CTRL equ $A10008
IO_CT1_DATA equ $A10002
IO_CT2_CTRL equ $A1000A
IO_CT2_DATA equ $A10004
IO_Z80BUS equ $A11100
IO_Z80RES equ $A11200
Z80_RAM equ $A00000
Joy1 equ IO_CT1_DATA+1				;controller 1 data port (byte)
Joy2 equ IO_CT2_DATA+1				;controller 2 data port (byte)
Z80_YM2612 equ $A04000
SaveRAM equ $200000					;battery save RAM (InitSaveRAM): $2000 bytes, the odd byte of each word.
									;93 had a serial backup RAM port here (BackupRAM_Port)
Stack	=	$FFFFFFFE				;game stack (Begin, StartPer, Opening2)

;joystick button equates (bit numbers)
ubut equ 0							;up
dbut equ 1							;down
lbut equ 2							;left
rbut equ 3							;right
bbut equ 4							;b button
cbut equ 5							;c button
abut equ 6							;a button
sbut equ 7							;start button
HVcount	equ	$C00008					;horizontal / vertical counter
osflag equ 20000					;flag for off screen graphic ($4E20)

;song numbers (SngTitle, SngEOP, SngScouting are song numbers)
SngTitle equ $78
SngEOP equ $79
;Song slots (SongIndex, 93G names): ChooseSong takes byte SongIndex of the 6 song bytes of team HmTeam
SngGoal equ 3						;home goal tune
SngPeriodStart equ 0				;period start tune (StartPer)
SngLateGame equ 5					;late game tune, once in the 3rd period
SngPP equ 4							;home team ahead on players: power play tune (LeadSong)
SngPPAway equ 1						;away team ahead on players (LeadSong); 94 only
SngFaceoff equ 2					;face off tune, once per period; also the shootout song
SngScouting equ $7A
;game sound effect numbers (sfx / song argument). 95 maps them through SfxTable
SFXsiren equ $0
SFXbeep1 equ $1
SFXbeep2 equ $2
SFXwhistle equ $3
SFXhorn equ $4
SFXpass equ $10						;4 variants, +0-3
SFXshotbh equ $14					;+0-3
SFXshotfh equ $18					;+0-3
SFXshotwiff equ $5
SFXstdef equ $6
SFXpuckget equ $7
SFXpuckbody equ $24
SFXpuckwall1 equ $28				;+0-3
SFXpuckwall2 equ $29				;medium (92 SFXpuckwall2)
SFXpuckwall3 equ $2A				;soft (92 SFXpuckwall3)
SFXpuckwall4 equ $2B				;softest (new in 93)
SFXbglass equ $E
SFXpuckice equ $2C					;+0-3
SFXplayerwall equ $20
SFXplayerwall2 equ $21
SFXplayerwall3 equ $22
SFXplayerwall4 equ $23
SFXpuckpost equ $25
SFX26 equ $26
SFX27 equ $27
SFXcheck equ $1C					;+0-3
SFXhithigh equ $9
SFXhitlow equ $A
SFXcrowdcheer equ $B
SFXcrowdboo equ $C
SFXoooh equ $8
SFXoooh2 equ $D
SFXhomewin equ $F					;home team won
goalline equ 176					;distance from blue line to goalline

replaystart equ $FFFF0000			;start of ram area for replay frames, also the start of RAM
M68K_RAM equ replaystart
sramcleared equ $FFFF1FFE
varstart equ $FFFFB000				;start of variable space (end of replay; 93G)
replaysize equ 98					;bytes per replay frame (92G/93G name; 92G 84)
replaynum equ ((varstart-replaystart)/replaysize)-1	;number of frames for replay
replayend equ replaystart+(replaynum*replaysize)	;end of the replay frames (replaysize bytes each);
									;suba4, adda43 and the record step wrap here

Sortobjs equ 16						;number of sorted graphics objects
scsize equ 7						;2 to this power indicates ram needed for each sortobj
SCstruct equ 1<<scsize				;ram for each sortobj (SortCords entry)

;record and field offsets (names shared with 93G; docs: NHLPA93Genesis docs/file-formats.md)
; .map.jim / .anim container header
jimpalette equ 0					;long: offset of the palette ($FFFFFFFF none)
jimdata equ 4						;long: offset of the map (.map.jim) or the frame table (.anim)
jimtilecount equ 8					;word: tile count (bit 15 packed); the tiles follow (jimtiles)
jimtiles equ $A						;header size: the tile data starts here
; .map.jim map section (at jimdata)
mapwidth equ 0						;word: width in tiles
mapheight equ 2						;word: height in tiles
mapwords equ 4						;the map words
; .anim sprite entry (8 bytes per sprite piece of a frame)
seX equ 0							;word: x, signed, from the frame origin
seY equ 2							;word: y, signed
seTile equ 4						;word: tile, from the set's first tile
seAttr equ 6						;word: priority, palette, vflip, hflip (bits 15-11), size code (low byte)
seSize equ 7						;byte: VDP size code (low byte of seAttr)
seLen equ 8
; VDP sprite attribute table entry (Satt, 8 bytes)
satY equ 0							;word: y + 128
satSize equ 2						;byte: size code
satLink equ 3						;byte: next sprite (0 ends the list)
satTile equ 4						;word: priority, palette, flips, tile
satX equ 6							;word: x + 128
satLen equ 8
; ScoreSum entry (6 bytes per goal)
sstime equ 0						;word: period / time of the goal
ssflags equ 2						;byte: 2 + skater difference (goal type); bit 7 = away team scored
ssscorer equ 3						;byte: scorer
ssassist1 equ 4						;byte: first assist ($FF none)
ssassist2 equ 5						;byte: second assist ($FF none)
sssize equ 6
; PenSum entry (4 bytes per penalty)
pstime equ 0						;word: period / time
pspen equ 2							;byte: penalty (Penaltylist offset); bit 7 = away team
psplayer equ 3						;byte: penalized player
pssize equ 4
; PenBuf entry (2 bytes per player in the box)
pbpen equ 0							;byte: penalty number (0 = free)
pbscnum equ 1						;byte: SCnum of the player
; puckcross entry (4 bytes; entry 0 top, entry 1 bottom)
pcx equ 0							;word: x coordinate
pcframes equ 2						;word: frames
pcsize equ 4
; fofdata2 / fofdata: big faceoff sprites (4 bytes each: home center, visiting center, then fofdata = the ref)
foframe equ 0						;word: frame
foattr equ 2						;word: attribute (bit 11 x flip)
fosize equ 4
; PlList: 6 wanted roster players, then their positions
plpos equ 6
; .pld player ratings: 8 bytes after each player's name String (92 setplayer field names; the
; teamdata94.asm legend letters in brackets; goalies use the low nibbles for saves)
pldnum equ 0						;byte: jersey number, 2 BCD digits (un) -> rostnum
pldweight equ 1						;high nibble weight, low nibble leg power legstr (wl)
pldlegspd equ 2						;high nibble speed legspd, low nibble offense aioff (so)
pldaidef equ 3						;high nibble defense aidef, low nibble shot power shotspd (dp)
pldcheck equ 4						;high nibble checking, bit 0 hand (1 = right in 94 data;
									;setplayer inverts it into handed), bits 1-3 fighting (ch)
pldstick equ 5						;high nibble stickhandling stickhand, low nibble shot accuracy (ga)
pldendur equ 6						;high nibble endurance, low nibble shoot / pass odds spodds (ey)
pldpass equ 7						;high nibble passing passacc, low nibble aggression aggress (tm)
pldsize equ 8
; Save RAM records, read and written through recordbuf. Each record is a value, its holder, the
; opponent team and the opponent user (recordbuf, ram94.asm).
; User record block (TeamRecBase + user * 16)
urgoals equ 0						;most goals in a game
urgoalsteam equ 1					;the user's team in that game
urgoalsopp equ 2					;opponent team
urgoalsoppuser equ 3				;opponent user
ursaves equ 4						;most saves in a game
ursavesteam equ 5
ursavesopp equ 6
ursavesoppuser equ 7
urwins equ 8						;word, high byte first: wins
urgames equ $A						;word, high byte first: games (stops at 9000)
urties equ $C						;word, high byte first: ties
; Crowd record block (CrowdRecBase + team * 16)
crgoals equ 0						;most goals by the team in a game
crgoalsuser equ 1					;the user playing the team
crgoalsopp equ 2					;opponent team
crgoalsoppuser equ 3				;opponent user
crsaves equ 4						;most saves by one of its goalies
crsavesuser equ 5
crsavesopp equ 6
crsavesoppuser equ 7
crpeak equ 8						;loudest crowd (home games)
crpeakuser equ 9
crpeakopp equ $A
crpeakoppuser equ $B
; Player record (4 bytes, PlayerRecordOffsets)
prbest equ 0						;best goals (saves for goalies) in a game
pruser equ 1						;the user playing his team
propp equ 2							;opponent team
proppuser equ 3						;opponent user
; Team block .sr bytes (at ScoutReport)
srodds equ 0						;scoring odds of simulated games: bits 4-6 offense row, 0-2 defense row
srpppk equ 1						;high nibble penalty kill deficit, low nibble power play bonus
srhomeaway equ 2					;high nibble home bonus, low nibble visitor bonus (negated)
srforwards equ 3					;high nibble: forward count (GetForwardCount); low nibble not read

; team numbers (TeamList order in teamdata): schedule, playoffseats and other team-indexed tables
ANH equ 0
BOS equ 1
BUF equ 2
CGY equ 3
CHI equ 4
DAL equ 5
DET equ 6
EDM equ 7
FLA equ 8
HFD equ 9
LA equ 10
MTL equ 11
NJ equ 12
NYI equ 13
NYR equ 14
OTW equ 15
PHI equ 16
PIT equ 17
QUE equ 18
SJ equ 19
STL equ 20
TB equ 21
TOR equ 22
VAN equ 23
WSH equ 24
WPG equ 25
ASE equ 26
ASW equ 27
; NumTeams includes the two all-star teams, which stay last (defined from TeamList in
; teamdata94.asm, included before this file). NumPlayoffTeams is the first all-star
; number: a new playoff team is inserted before ASE and both all-star numbers move up.
	IF NumTeams<>ASW+1
		inform	3,"TeamList needs one entry per team"
	ENDIF
NumPlayoffTeams equ ASE
RosterSlots equ 26
; Save RAM layout (retail addresses). Crowd records are NumTeams blocks of CrowdRecBytes at
; CrowdRecBase and must end before the records block; see docs/EXPANDING_THE_ROM.md.
CrowdRecBase equ $B60
CrowdRecBytes equ 16
CrowdRecEnd equ CrowdRecBase+NumTeams*CrowdRecBytes
TeamRecBase equ $D20
RecordsBytes equ $80
NameLogBase equ $DA0
NameLogBytes equ $80
LineDataBase equ $1EF6
	IF TeamRecBase<CrowdRecEnd
		inform	3,"The crowd records run into the records block (see docs/EXPANDING_THE_ROM.md)"
	ENDIF
	IF 32<NumPlayoffTeams
		inform	3,"The playoff draw only keeps 32 team bits"
	ENDIF

	RSSET	varstart				;variables from here on are allocated upwards with rs (93G)
VSCRLPM	rs.w	1
VSPRITES	rs.w	1
VmMAP1	rs.w	1
Map1col	rs.w	1
VmMAP2	rs.w	1
Map2col	rs.w	1
VmMAP3	rs.w	1
Map3col	rs.w	1
BigFontchars	rs.w	1
smallfontchars	rs.w	1
smallfont2chars	rs.w	1
energybarchars	rs.w	1
logochars equ energybarchars		;reused: logo / cup sprite tiles on the title and playoff screens
rinkvrcset	rs.w	1
crowdvrcset	rs.w	1				;94 keeps the crowd tiles 1st vram char here
faceoffvrcset	rs.w	1
framercset	rs.w	1
EASNcset	rs.w	1
basetileoffset	rs.w	1
spritechars	rs.w	1
ExtraChars	rs.w	1
printx	rs.w	1
printy	rs.w	1
printa	rs.w	1
printm	rs.w	1
printfontset	rs.w	1
strtext equ 2						;String: start of the text after its length word
;printsmall / printz2 (ControlCodeJumpTable, -byte): the code, then its argument bytes
CC_SetMap equ $FF					;-1: map
CC_SetAttribute equ $FE				;-2: palette/priority (printa)
CC_SetX equ $FD						;-3: printx
CC_SetY equ $FC						;-4: printy
CC_AddX equ $FB						;-5: add signed byte to printx
CC_AddY equ $FA						;-6: add signed byte to printy
CC_SetFont equ $F9					;-7: char set
CC_SetMapAndPosition equ $F8		;-8: attribute, map, x, y
;print / printz / printbig / printbigz / appendz control byte (NOT printsmall: there $FF..
;are the CC_Set* codes above).
;One byte with bit 7 set, read as -$ab: bits 0-1 font (= map 1-3), bit 2 h flip, bit 3 v
;flip, bits 4-5 palette, bit 6 priority; then x, y (printa = the bits << 9, printm = map).
;Names match 93G ram93.asm / 93S / 94S
CC_Font1 equ $FF					;-$01: map 1
CC_Font2 equ $FE					;-$02: map 2
CC_Font3 equ $FD					;-$03: map 3
CC_Font1Pal1 equ $EF				;-$11: map 1, palette 1
CC_Font1Pal2 equ $DF				;-$21: map 1, palette 2
CC_Font2Pal2 equ $DE				;-$22: map 2, palette 2
CC_Font1Pal3 equ $CF				;-$31: map 1, palette 3
CC_Font2Pal3 equ $CE				;-$32: map 2, palette 3
CC_Font3Pal3 equ $CD				;-$33: map 3, palette 3
CC_Font1Pri equ $BF					;-$41: map 1, priority
CC_Font2Pri equ $BE					;-$42: map 2, priority
CC_Font3Pri equ $BD					;-$43: map 3, priority
CC_Font2Pal2Pri equ $9E				;-$62: map 2, palette 2, priority
CC_Font1Pal3Pri equ $8F				;-$71: map 1, palette 3, priority
CC_Font2Pal3Pri equ $8E				;-$72: map 2, palette 3, priority
CC_Font3Pal3Pri equ $8D				;-$73: map 3, palette 3, priority
;Whole-String markers that list / page readers test (a String of just $FF / -1 is the word
;$FF00 at strtext, negative)
CC_ListEnd equ $FF					;String CC_ListEnd ends a menu item list (data94.asm)
CC_PageEnd equ -1					;String CC_PageEnd ends a credits page; two in a row end
									;the credits (teamdata94.asm)
fodropx	rs.w	1
fodropy	rs.w	1
recbpr	rs.l	1
VBint	rs.l	1
Vcount	rs.w	1
OldVcount	rs.w	1
repeatdelayframes	rs.w	1
asv	rs.w	1
lldisp	rs.w	1
periodendtime	rs.w	1
Xcord equ 0							;x and y words at the start of an sso object
Ycord equ 2
;the sort object structure (SCstruct bytes each)
Xpos equ $0
attribute equ $4					;frame attribute switch bits
frame equ $6						;alice frame number
oldframe equ $8						;last frame
VRoffs equ $A						;offsets to find each sprites start char. (max of 6 sprites / frame)
VRchar equ $12						;vram char for graphic
Ypos equ $14
Zpos equ $18
OldXpos equ $1C
OldYpos equ $20
OldZpos equ $24
rosxoff equ OldXpos					;game setup: player sprite x offset from Xpos (optsetup94)
Xvel equ $28
Yvel equ $2A
Zvel equ $2C
impactp equ $2E						;last player to cause impact
limpact equ $30						;last impact value
impact equ $32						;impact value
position equ $34					;player's position (0=goalie,1=l.def,2=r.def,3=l.wing,4=center,5=r.wing)
assnum equ $36						;index to current assignment
asslist equ $38						;list of assignments in order of execution
temp1 equ $40
temp2 equ $42
temp3 equ $44
temp4 equ $46
temp5 equ $48
radiusx equ $4A						;width of this graphic
radiusy equ $4C						;height of this graphic
Wallcos equ $4E						;cos of angle of last collision
Wallsin equ $50						;sin of angle of last collision
SCnum equ $52						;index number for this struct
facedir equ $54						;direction of facing
SPA equ $58							;animation (SPA offset)
SPAnum equ $5A						;index into animation
SPAcnt equ $5C						;count down to next frame of animation
SPAattr equ $10						;SPA table: attribute word after the 8 direction offsets (bit 0 = loop)
nopuck equ $5E						;no puck coll until zero
nopuckb equ $5F						;second count down (low byte of nopuck)
newpos equ $60						;requested next position of this player
newpnum equ $61						;requested next player (from roster) for this player
pflags equ $62
pfdoff equ 0						;bit0-deceleration off
pfna equ 1							;bit1-new assignment
pfnc equ 2							;bit2-no collision mode
pfjoycon equ 3						;is player joystick controlled
pfrev equ 4							;skating backwards
pfalock equ 5						;lock out until anim is done
pfteam equ 6						;0-home(sprite0-5)/1-visitors(sprite6-11)
pfgoal equ 7						;0=bottom, 1=top (to shoot at)
pflags2 equ $63
pf2fight equ 0						;player is fighting (93; 94 has no fights)
pf2aip equ 1						;animation in progress wait
pf2unav equ 2						;player is unavailable (going to/from bench/penalty). 92 bit 4
pf2lcm equ 3						;line change mode. 92 bit 5
pf2pen equ 4						;player has caused a penalty. 92 bit 6
pf2npc equ 5						;no player collision. 92 bit 7
pf2inj equ 6						;player is injured (SPAfinjury animation, max speed 1/8).
;player struct fields after handed's neighbours, not named in 93 (names from the 92/93/94 comments)
pflags3 equ $64						;player flags 3 (92: not used)
pf3oside equ 0						;offsides
pf3break equ 1						;on a breakaway
pf3gctrl equ 2						;goalie control
pf3onetimer equ 3					;doing a one-timer
pf3wall equ 4						;wall collision
pf3fall equ 5						;falling down
glitch equ $65						;counter to eliminate quick frame changes (de-glitch graphics)
pnum equ $66						;player's team location number 0-22
weight equ $67
legstr equ $68
legspd equ $69
aioff equ $6A
aidef equ $6B
shotspd equ $6C
shotacc equ $6D
passacc equ $6E
rostnum equ $6F
spodds equ $70
stickhand equ $71
endurance equ $72
aggress equ $73						;aggression (Agr; goalie: glove left)
GGSleft equ aggress					;goalie glove save left (92 name; 92 put it on stickhand)
fighting equ $74					;fighting (Fgt; from the Chk/Hnd byte, always even)
checking equ $75					;checking (Chk)
handed equ $76						;bit0 set is left handed
SortCords	rs.b	Sortobjs*SCstruct	;sort objects, SCstruct bytes each (93G); the puck is object puckscnum
puckscnum equ 14					;puck is sort obj number 14
puckx	equ	SortCords+(puckscnum*SCstruct)+Xpos	;puck x position in its sort object (93G)
puckvx	equ	SortCords+(puckscnum*SCstruct)+Xvel	;puck x velocity
pucky	equ	SortCords+(puckscnum*SCstruct)+Ypos	;puck y position
puckvy	equ	SortCords+(puckscnum*SCstruct)+Yvel	;puck y velocity
puckz	equ	SortCords+(puckscnum*SCstruct)+Zpos	;puck height above the ice
puckvz	equ	SortCords+(puckscnum*SCstruct)+Zvel	;puck z velocity
puckx_nopuck	equ	SortCords+(puckscnum*SCstruct)+nopuck	;puck object nopuck word
puckc	equ	SortCords+(puckscnum*SCstruct)+newpos	;puck carrier (93G: the newpos slot of the puck object)
puck_pflags2	equ	SortCords+(puckscnum*SCstruct)+pflags2	;puck object pflags2
GoalieStruct equ SortCords-SCstruct	;the sort object before SortCords: GoalieStruct+SCstruct is player 0
									;(shotdiradj scan)
Ylist	rs.w	16
OOlistpos	rs.w	16
OOlist	rs.w	8
Crowdframe	rs.w	1
Crowdlevel	rs.w	1
Crowdstep	rs.w	1
Crowdcnt	rs.w	1
CwdExciteLvl	rs.w	1
MaxCwdExciteLvl	rs.w	1
NumCwdExciteLvl	rs.w	1
SumCwdExciteLvl	rs.l	1
Zamx	rs.w	1
playoffspritex	rs.w	1
playoffspritey	rs.w	1
clampcounter	rs.w	1
logoslide equ clampcounter			;reused: title / playoff screen page time (credits wait)
DMAList	rs.w	560
DMAlistend	rs.l	1
Vpos	rs.w	1
Oldrow	rs.w	1
Hpos	rs.w	1
Hscroll	rs.w	1
Vscroll	rs.w	1
Blueline equ $58					;distance from center line to blueline
Sideline equ $88					;distance from center to side boards
wcradiusx	rs.w	1
wcradiusy	rs.w	1
palcount	rs.w	1
palfadenew	rs.w	64
fofdata2	rs.w	4
fofdata	rs.l	1
ffonum	equ	7						;objects tied to the rink scroll (93 had 5)
ffosize equ OldXpos					;field objects tied to icerink scrolling (pads), OldXpos bytes each (92G)
pads	rs.w	14
Joy1Struct	rs.w	28
CameraPosStruct	rs.w	11
;replay camera struct (CameraPosStruct, 93 name): stands in for a sort object, Xpos / Ypos
;are its position (UpdateCameraPos). It is really 14 words: camtrack and camidle lie past the 11
;words 93 reserved for it and overlap replayactive (camtrack is the replayactive word)
camtrack equ $16					;SCnum of the object tracked in replay
camidle equ $18						;$FF while the replay d-pad is idle, cleared on scroll/track (never read)
replayactive	rs.w	3
Joy3Struct	rs.w	14
Joy4Struct	rs.w	14
glovestruct	rs.w	14
PadControlBits	rs.w	1
padcont	rs.w	6
PadControlBits34	rs.w	1		;as PadControlBits, for pads 3 and 4 (4 way play)
ssonum	equ	4						;screen objects not tied to the rink scroll (2 arrows + 2 scoreboard
									;logos)
ssosize	equ	$14						;bytes per sso object
sso	rs.w	40
shotplayer	rs.w	1
lastplayer	rs.w	1
passdir	rs.w	1
passspeed	rs.w	1
passReceiverPlayerNum	rs.w	1	;SCnum of the intended receiver of the last pass, -1 = none (94 had
									;passplayer)
glovecords	rs.w	1
threat	rs.w	1
puckcross	rs.b	2*pcsize		;xcord / frames, top entry then bottom (93G rs.w 4)
puckcross2	equ	puckcross+pcframes	;top entry frames
puckcross4	equ	puckcross+pcsize	;bottom entry x
puckcross6	equ	puckcross+pcsize+pcframes	;bottom entry frames
lj1	rs.w	1
lj2	rs.w	1
lj3	rs.w	1
lj4	rs.w	1
PadRaw1	rs.b	1
PadRaw2	rs.b	1
PadRaw3	rs.b	1
PadRaw4	rs.b	1
pad4wayword	rs.l	1				;the pad word the unused ReadJoySwapPad1-4 swap a pad's saved word into
									;around ReadJoy1
pad4waysave1	rs.w	1			;ReadJoySwapPad1 saved pad word
pad4waysave2	rs.w	1			;ReadJoySwapPad2 saved pad word
pad4waysave3	rs.w	1			;ReadJoySwapPad3 saved pad word
pad4waysave4	rs.w	1			;ReadJoySwapPad4 saved pad word
bholdtimer	rs.w	1				;B button hold timers of pads 1 / 2 (one byte each); bholdtimer34 for pads
									;3 / 4
bholdtimer34	rs.w	1
padword3	rs.w	1
padword4	rs.w	1
padword1	rs.w	1				;a pad 1 word swapped with padword3 for 4 way play (updateplayers)
padword2	rs.w	1				;a pad 2 word swapped with padword4 for 4 way play (updateplayers)
TempWord1	rs.w	1				;a scratch word (hot / cold totals, record page, button direction ...)
TempWord2	rs.w	1				;a scratch word (hot / cold totals, attribute number, credits step ...)
TempRawSpd	rs.w	1
TempMaxSpd	rs.l	1
TempEnergySpd	rs.w	1
TempLegSpd	rs.w	1
TempBuffer	rs.w	20				;40 byte scratch buffer: String buffer (AppendNumber, names, "(played by
									;NAME)"), hot / cold player, sum byte pairs
scorergoalies	rs.w	1
recties	rs.w	1
reclosses	rs.w	1
recwins	rs.w	1
awayhotter	rs.w	1
setupfontchars	rs.w	1
awayhotidx	rs.w	1
homehotidx	rs.w	1
awaycoldidx	rs.w	1
homecoldidx	rs.w	1
awayhotplayer	rs.w	1			;the away team's hottest starter (BuildHotColdLists)
homehotplayer	rs.w	1			;the home team's hottest starter
awaycoldplayer	rs.w	1			;the away team's coldest starter
homecoldplayer	rs.w	1			;the home team's coldest starter
ChkBodyG	rs.w	1
ChkBodySqG	rs.l	1
NegChkBodyG	rs.w	1
onetimerplayer	rs.w	1
onetimerclock	rs.w	4
onetimerflags	rs.w	1
disflags	rs.w	1
dfok equ 0							;graphics are ready for transfer
df32c equ 1							;32 column mode on
dfng equ 2							;don't int graphics
dfclock equ 3						;clock needs update
dffaceoff equ 4						;face off sprites on (92 tested sf2faceoff).
ltplayer	rs.w	1
ltx	rs.w	1
lty	rs.w	1
iflags	rs.b	1
ifcgl equ 0							;iflags: crossed goalline
ifdir equ 1							;iflags: 1=must cross top line
ifok equ 2							;iflags: icing
icingPlayer	rs.b	5
jps equ 24							;jiffys per second
jiffy equ $10000/jps
clockram	rs.w	4
xc1	rs.w	1
yc1	rs.w	1
yleader	rs.w	1
fox	rs.w	1
foy	rs.w	1
fodir1	rs.w	1
fodir2	rs.w	1
deltax	rs.w	1
deltay	rs.w	1
collflag	rs.w	1
evalue	rs.w	1
mesarea	rs.w	1
TextBuffer	rs.w	49
PushWidthBuf	rs.w	4
PushNumberBuf	rs.w	1
redrawicons	rs.w	1
ltack	rs.w	1
lastsfx	rs.w	1
Satt	rs.w	360
Sattsize	rs.w	1
gmode	rs.w	1
gmclock equ 0						;game clock is stopped
gmdir equ 1							;0 = home team goes up
gmpen equ 2							;penalty has been called
gmpendel equ 3						;delayed penalty has been called
gmhl equ 4							;hilight mode
gmoffs equ 5						;offsides on
gmeog equ 6							;game over reached: the next face off goes to PeriodOver
gmstars equ 7						;the Stars of the Game box was already shown
sflags	rs.w	1
sfpz equ 0							;pause mode
sfpj equ 1							;pause cont (0 for cont 1)
sfspdir equ 2						;set pass dir mode
sfssdir equ 3						;set shot dir mode
sfwrap equ 4						;replay has wrapped around
sfscrl equ 5						;replay scroll is manual cont
sfslock equ 6						;scroll lock to xc1/yc1
sfhor equ 7							;screen is in horizontal mode
sflags2	rs.w	1
sf2faceoff equ 0					;face off in progress
sf2refref equ 1						;ref needs refresh
sf2drec equ 2						;disable replay record
sf2replay equ 3						;replay in progress
sf2shot equ 4						;shot was taken
sf2pwrplay equ 5					;power play in progress
sf2pwrtm equ 6						;0 for team 1 in power play
sf2offsig equ 7						;offsides little ref on
sflags3	rs.w	1
sf3llcs equ 0						;lower line change sel.
sf3rmplay equ 1						;play mode on for replay
sf3alttree equ 2					;alt. tree
sf3sbut equ 3						;flag for start button
sf3fo equ 4							;face off just ended (set by the drop): the next puck pickup wins it, with
									;a crowd cheer.
sf3track equ 5						;the scroll window tracks an object.
sf3icetime equ 6					;set once a second by updatepentime: each player on the ice adds 1 to its
									;time on ice.
sf3fosong equ 7						;set for periods 1 and 2: play the face off tune once, at the first face
									;off past half the period
BA_PS_flags	rs.w	1
sflags4	rs.w	1					;94 flag word: reverse angle replay (bits 4, 6, 7), slot, penalty shot
									;goal ...
sflags5	rs.w	1					;94 flag word: crowd noise on (bit 7), menu handler keeps its screen (bit
									;1), setup scroll (bit 2) ...
sflags6	rs.w	1					;94 flag word: one-timer (bits 1, 2), slot (bit 5), save RAM write (bit
									;6), record value (bit 7) ...
gmode2	rs.w	1					;94 game mode word, beside gmode: shootout (bit 0), shootout skater has
									;the puck (bit 1), breakaway (bit 4) ...
sflags7	rs.w	1					;94 flag byte: arena faceoff animation (bit 0), injury (bit 5), crowd
									;meter broken (bit 6) ...
sflags8	rs.w	1					;94 flag byte: penalty shot / shootout and one-timer bits
DelayedPen	rs.l	1
crowdnoisedelay	rs.w	1
CwdChkCntr	rs.w	1
CwdChkCnt	rs.w	3
CurCrowdMeter	rs.w	1
CrowdRecord	rs.w	1
CrowdAvg	rs.w	1
CrowdPeak	rs.w	1
pausepad	rs.w	1
joypuckcarrier	rs.w	1
msgtimer	rs.w	1
passmodetimer	rs.w	1
savednewpnum	rs.w	1
c1playernum	rs.w	1
c2playernum	rs.w	1
c3playernum	rs.w	1
c4playernum	rs.w	1
cont1team	rs.w	1
cont2team	rs.w	1
cont3team	rs.w	1
cont4team	rs.w	1
HomeTeam	rs.w	1
VisTeam	rs.w	1
TeamBlockMap	rs.w	56			;Map word buffer for CopyTeamBlockMapData and PutTeamBlock
MaxPen equ 32						;penalties kept in PenBuf
PenBuf	rs.w	MaxPen+1
; Penalty numbers (word offsets into Penaltylist) for AddPenalty
PenEOP	equ	$2
PenEOG	equ	$4
PenOOP	equ	$6
PenGhold	equ	$8
PenWhistle	equ	$A
PenIcing	equ	$C
PenGoal	equ	$E
PenOffsides	equ	$10
PenRoughing2	equ	$12
PenNoText	equ	$14
PenCharging	equ	$16
PenSlashing	equ	$18
PenRoughing	equ	$1A
PenCrossChk	equ	$1C
PenHooking	equ	$1E
PenTripping	equ	$20
PenInterference	equ	$22
PenHolding	equ	$24
PenFighting	equ	$26
PenFighting2	equ	$28
PenInst	equ	$2A
PenDelay	equ	$2C
PenHookingPS	equ	$2E
PenTrippingPS	equ	$30
PenGhold2	equ	$32
PenInterferencePS	equ	$34
PenRoughingPS	equ	$36
PenChargingPS	equ	$38
PenCrossChkPS	equ	$3A
PenSlashingPS	equ	$3C
; Sprite object constants (92 names; the sso/ffo counts and size sit with sso and pads)
collrad	equ	8						;collision radius of an object (objects collide within collrad*2)
horoff	equ	197						;subtracted from the screen y in the horizontal rink view
PenCntDwn	rs.w	1
Penaltytimer	rs.w	1
PBnum	rs.w	1
InjCntDown	rs.w	1
penmsgtimer	rs.w	1
RefCnt	rs.w	1
RefStep	rs.w	1
RefPen	rs.w	1
RefRamMap	rs.w	refwidth*refheight
gsp	rs.w	1
gameclock	rs.l	1
PerTimeTotal	rs.w	1
ChkCnt	rs.w	1
TempPlOffset	rs.w	1
ScoreSumbytes	rs.w	1
ScoreSum	rs.w	180
PenSumLength	rs.w	1
PenSum	rs.w	120
;team variables (tmstruct / awtmstruct = the home / away team struct)
tmshots equ $0						;shots stat
tmPwrGoals equ $2					;power play goals stat
tmPwrPlays equ $4					;power plays stat
tmPenalties equ $6					;penalties stat
tmPenmin equ $8						;penalty min. stat
tmATOP equ $A						;attack time of possesion stat
tmdata equ $1E						;team data address
tmsort equ $22						;address of first sort obj (word)
tmscore equ $C						;score
tmline equ $16						;current line
tmap equ $24						;active players on ice 4-6
tmgoalie equ $26					;goalie 1/2/none
tmflags equ $30						;flags
tmflcc equ 0						;tmflags: line change on
tmflcm equ 1						;team is in line change mode (92 scanned the players for pf2lcm)
tmflast equ 3						;next touch overwrites the last touch only.
tmfoside equ 4						;team is offsides (92 flagged the player with pf3oside)
tmftimeout equ 2					;timeout used (the pause menu drops Timeout from then on). Same bit as
									;tmfmid and tmfslide
tmfmid equ tmftimeout				;nearest player always takes the in-between spot (assnearest)
tmfslide equ tmftimeout				;93 roster screen name slide; unused here (UpdateRosterPlayers is empty)
tmfowon equ $E						;face-offs won stat
tmchecks equ $10					;checks stat
tmpasses equ $12					;passes stat
tmpasscomp equ $14					;completed passes stat
tmtouch1 equ $18					;last touch (team/pnum word): the scorer
tmtouch2 equ $1A					;second last touch (first assist)
tmtouch3 equ $1C					;third last touch (second assist)
tmteam equ $28						;team number (TeamList index) of this team struct
tmnear equ $2A						;long: nearest skater's distance^2 to the puck (assnearest)
tmlcchoice equ $2E					;line change box row chosen (0-2)
tmpde equ $32						;energy level of each roster player
maxros equ 26						;roster slots per team in the team structure
tmpdst equ tmpde+(2*maxros)			;-2=bench/-1=ice/0+=penalty box
tmboxlist equ tmpdst+(2*maxros)		;penalty box list of roster players (bytes, negative ends)
tmgoals equ $B4						;goals per roster player (goalies: goals against), bytes
tmassists equ tmgoals+maxros		;assists per roster player (bytes)
tmpshots equ tmgoals+(2*maxros)		;shots per roster player (goalies: shots against), bytes
pchecks equ $11C					;checks per roster player (bytes)
tmpice equ $136						;frames on ice per roster player (words)
tmlines equ $16A					;line sets copied from the team data (LineSets), 7 lines x 8 bytes
tmHotCold equ $1A2					;hot / cold table: 16 bytes per roster player (26 x 16 bytes), each
									;random -9 ... 8 (Create_HotCold_Table, AttributeCalc). New in 94.
									;94S keeps one HotColdTable for both teams: 52 players x 12 bytes,
									;-12 ... 12
tmPerGoals equ $342					;goals by period (word per period, 4 with overtime). New in 94
tmPerShots equ $34A					;shots by period (word per period, 4 with overtime). New in 94
tmPwrPlayTime equ $352				;power play time in seconds (updatePPTeamTime). New in 94
tmPPShots equ $354					;power play shots (penalty94). New in 94
tmSHGoals equ $356					;shorthanded goals (Goal). New in 94
tmBreakaways equ $358				;breakaways. New in 94
tmBreakawayGoals equ $35A			;breakaway goals (Goal). New in 94
tmOneTimers equ $35C				;one-timer attempts. New in 94
tmOneTimerGoals equ $35E			;one-timer goals (Goal, sflags8 bit 7). New in 94
tmPenShots equ $360					;penalty shots. New in 94
tmPenShotGoals equ $362				;penalty shot goals (Goal, sflags4 bit 5; not in a shootout). New in 94
tmsize equ $364						;93 $1A2: 94 adds tmHotCold and the stats from tmPerGoals
tmstruct	rs.b	tmsize			;home team struct (93G)
HmGoals	equ	tmstruct+tmscore		;home score
HomeTeamRosterPtr	equ	tmstruct+tmdata	;home team data address
awtmstruct	rs.b	tmsize			;away team struct (first field tmshots)
AwGoals	equ	awtmstruct+tmscore		;away score
AwayTeamRosterPtr	equ	awtmstruct+tmdata	;away team data address
statsbuffer	rs.w	104
;game structure variables (one per playoff matchup)
gst1 equ $0							;team 1
gst2 equ $2							;team 2
gspotwins equ $4					;play off top team (on tree) wins (for best of 7)
gspobwins equ $6					;play off bottom team (on tree) wins (for best of 7)
gsper equ $8						;period
gss1 equ $A							;team 1 score
gss2 equ $C							;team 2 score
gsflags equ $E						;flags
gsftf equ 0							;teams are flipped
gsfhl equ 1							;hilite requested
gsfso equ 2							;series over
gssize equ $10
gstruct	rs.b	gssize*8			;8 game structures
gamenum	rs.w	1
postarts	rs.w	1
bosgames	rs.w	1
gamelevel	rs.w	1
potreeteam	rs.w	1
pojoy	rs.w	1
WinBits	rs.w	1
potree	rs.w	16
PlList	rs.w	6
menuitem	rs.l	1				;menu state: selected item, then (+2) first item shown
menulist	rs.l	1
menudraw	rs.l	1
TickerNum	rs.w	1
PPBonus	rs.b	1
PKBonus	rs.b	1
ThirdPBonus	rs.b	1
HmAwBonus	rs.b	1
remapTablePtr	rs.l	1
ThreeStars	rs.w	100
starscores equ ThreeStars			;the 52 star score longs (CalcStarScores)
recordbuf equ ThreeStars			;the save RAM record staging buffer (shares ThreeStars)
decompbuffer equ ThreeStars			;DecompressBytecode 256 byte ring buffer (shares ThreeStars)
teamrecbuf	rs.w	28				;SRAM team record buffer: the 16 byte record of a team (ReadCrowdRecord),
									;byte 8 crowd record, byte 9 its name number
nibblebuffer	rs.w	6
varend equ nibblebuffer+8			;end of the variables cleared by Opening2
homeuser	rs.w	1
awayuser	rs.w	1
FourWayPlay	rs.w	1
OptPlayMode	rs.w	1
OptNOP	rs.w	1
Opt1team	rs.w	1
Opt2team	rs.w	1
Optperlen	rs.w	1
OptGoalie	rs.w	1
OptUserRec	rs.w	1
OptPen	rs.w	1
OptLine	rs.w	1
goaliemode1	rs.w	1
goaliemode2	rs.w	1
TmpOptUserRec	rs.w	1
TmpOptPen	rs.w	1
TmpOptLine	rs.w	1
demoflag	rs.w	1
seed	rs.l	1
dmaram	rs.l	1
PalMode	rs.w	1
music_tick_divider	rs.w	1
TmpOptLine2	rs.w	1
TempOptPlayMode	rs.w	1
databuffer	rs.w	9
passbits	rs.w	5				;playoff password bits (94 had pwddatabuffer)
outputbuffer	rs.w	113
marker	rs.w	1					;last word of the $100 byte saved block (databuffer .. marker), as 93
tpassbits	rs.w	5
music_needs_z80_update	rs.w	1
Z80_command_buffer	rs.b	5
per_channel_attenuation_table	rs.b	7
per_channel_frequency_table	rs.w	7
per_channel_patch_table	rs.w	4
fm_voice_usage_table	rs.w	256
fm_channel_structs	rs.w	20
pcm_channel_struct	rs.w	4		;PCM (DAC) channel struct, after the 5 FM structs (94 had
									;fm_channel_struct6)
fm_track_slots	rs.w	24
BA_Team	rs.w	1
BA_Sktr_SCnum	rs.w	1
BA_Goalie_SCnum	rs.w	1
BA_Skater_Offset	rs.w	1
BA_Goalie_Offset	rs.w	1
BA_Checker_Offset	rs.w	1
pspenalty	rs.w	1
holdreset	rs.w	1
onetimertargetx	rs.w	1
onetimertargety	rs.w	1
onetimerheight	rs.w	1
FallYPos	rs.w	1
FallXPos	rs.w	1
aholdtimer	rs.w	1				;A button hold timers of pads 1 / 2 (one byte each); aholdtimer34 for pads
									;3 / 4
aholdtimer34	rs.w	1
setupfirstline	rs.w	1
setupprevline	rs.w	1
setupmenuchars	rs.w	1
logoteam	rs.w	1
setuphome	rs.w	1
setupvis	rs.w	1
setupcardflags	rs.w	1
homepicchars	rs.w	1
vispicchars	rs.w	1
cardroster	rs.w	1
logobox1chars	rs.w	1
logobox2chars	rs.w	1
teambitmapchars	rs.w	1
cardtimer	rs.w	1
featuredplayer	rs.w	1
carddelay	rs.w	1
cardprintx	rs.w	1
cardprinty	rs.w	1
cardteamnum	rs.w	1
homegoalies	rs.w	1
awaygoalies	rs.w	1
homeplayers	rs.w	1
awayplayers	rs.w	1
cardlogochars1	rs.w	1
cardlogochars2	rs.w	1
shootoutclock	rs.w	1
shootoutjiffy	rs.w	1
ValidSRAM	rs.w	1
namelog	rs.w	64					;the user name log: $80 bytes from save RAM NameLogBase (NameLogIO),
									;12 bytes per name, namelogsel the entry
nameentrybuf	rs.w	7
namelength	rs.w	1
namelogsel	rs.w	1
namelogarrows	rs.w	1
nameentryvis	rs.w	1
homecardidx	rs.w	1
awaycardidx	rs.w	1
cardindex	rs.w	1
cardvis	rs.w	1
cardcount	rs.w	1
homecardlist	rs.w	13			;the home player card order (BuildCardPlayerLists), read by GetCardPlayer
awaycardlist	rs.w	13			;the away player card order
cardplayer	rs.w	1
nameframechars	rs.w	1
recsort1	rs.w	4				;Record Holders row order sorted on record byte 0 (ReadTeamRecords), read
									;by PrintPlayerRecords
recsort2	rs.w	4				;Record Holders row order sorted on record byte 4 (ReadTeamRecords,
									;sflags6 bit 6)
winsort	rs.w	4					;Record Holders win row order (CalcWinPercents), read by PrintWinRecords
winpcts	rs.w	4					;the win % byte of each of the 8 records (CalcWinPercents)
winties	rs.w	8					;the ties word of each record (record bytes $C-$D)
wingames	rs.w	8				;the games word of each record (record bytes $A-$B)
shootoutstate	rs.w	1			;first of the 19 words ClearGameStats clears (shootout
									;goals, shootoutround, shooter lists ...)
homeshootgoals	rs.w	1
awayshootgoals	rs.w	1
shootoutround	rs.w	1
homeshooters	rs.w	6			;the home shootout shooter list (6 words, homeshootnum the index)
homeshootnum	rs.w	1
awayshooters	rs.w	6			;the away shootout shooter list (6 words)
shootoutteam	rs.l	1
matchup	rs.w	1
scoutunused	rs.w	1				;cleared by ScoutingReport, never read
matchuphome	rs.w	1
matchupvis	rs.w	1				;the visitors player of the matchup; also the scroll limit of StatsReport
homerating	rs.w	1
visrating	rs.w	1
advframe	rs.w	1
advcount	rs.w	1
matchuptimer	rs.w	1
matchupslot	rs.w	1
;DispAttribCtr to TestList are not in 93G order: 94 moved them, and the addresses here are 94's
DispAttribCtr	rs.w	1
playoffscroll equ DispAttribCtr		;reused: playoff screen scroll position
scoutcolumn equ DispAttribCtr		;reused: scouting report column
titlescrollspeed equ DispAttribCtr	;reused: title screen attribute display counter
VertLineScrolling	rs.w	1
PlayerScrollCtr	rs.w	1
SelectedPlayerIdx	rs.w	1
ScoutingReportTimer	rs.w	1		;scouting report: frames elapsed, the text typing delay (94 had typedelay)
screentimer	rs.w	1
TestList	rs.w	122
arenaanimchars	rs.w	1
arenaframe	rs.w	1
arenaframeidx	rs.w	1
arenaframetime	rs.w	1
arenaanim	rs.w	1
arenaframelist	rs.l	1
arenaspritelist	rs.l	1
faceoffanim	rs.w	3
cursoron	rs.w	1
facelcwait	rs.w	1
SongNum	rs.w	1
HmTeam	rs.w	1
SongIndex	rs.w	1
OvrDivisor	rs.w	1
OvrDividend	rs.w	1
homehotcoldsave	rs.w	208			;clearTeamStats keeps the home hot / cold table (tmstruct+tmHotCold)
									;here
awayhotcoldsave	rs.w	208			;the same for the awtmstruct table
sopath	rs.w	1
sopathpoint	rs.w	1
sopathx	rs.w	1
sopathy	rs.w	1
sopathdir	rs.w	1
sopathend	rs.w	1
picturebuf	rs.w	577				;UnpackPicture output: tile count word, then the 4 bit tiles
									;(DrawMatchupBitmap, dobitmap read it)
picturebits	rs.l	1				;UnpackPicture: the 3 packed bytes of the row being unpacked
homepresses	rs.l	1
homedirpresses	rs.l	1
awaypresses	rs.l	1
awaydirpresses	rs.l	1
replayicontimer	rs.w	1
TmpPuckX	rs.l	1
lognametext	rs.w	9				;the unused TerminateLogName's GetLogName String text (length word at -2)
songdelay	rs.w	1
delayedsong	rs.w	1
shootoutdelay	rs.w	1
PuckZCntr	rs.w	1
waitxpad	rs.w	1
TmpPuckZ	rs.w	1
inputjoy	rs.w	1
TmpJoyPuckCarrier	rs.w	1
PlayerChked	rs.l	1
PlayerChking	rs.l	1
hoticonchars	rs.w	1
coldiconchars	rs.w	1
iconplayer	rs.w	1
iconx	rs.w	1
scoutwait	rs.l	1
replaydelay	rs.w	1
PALflag	rs.w	4230
	rs.w	1						;the word at Stack
; ----------------------------------



