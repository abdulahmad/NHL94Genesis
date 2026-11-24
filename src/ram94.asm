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
Vctrl	equ	Vdata+4					; video control port (Vdata+4)
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
VDPR_MODE1 equ $8000				; VDP register 0: mode set 1
VDPR_MODE2 equ $8100				; VDP register 1: mode set 2
VDPR_PLANEA equ $8200				;plane A name table address / $400
VDPR_WINDOW equ $8300				;window name table address / $400
VDPR_PLANEB equ $8400				;plane B name table address / $2000
VDPR_SPRITE equ $8500				;sprite table address / $200
VDPR_BGCOL equ $8700				;backdrop colour
VDPR_HINT equ $8A00					;h interrupt counter
VDPR_MODE3 equ $8B00				; VDP register 11: mode set 3 (scroll modes)
VDPR_MODE4 equ $8C00				; VDP register 12: mode set 4 (resolution, interlace)
VDPR_HSCROLL equ $8D00				;h scroll table address / $400
VDPR_AUTOINC equ $8F00				;auto increment (VmInc macro)
VDPR_PLANESIZE equ $9000			; VDP register 16: scroll plane size
VDPR_WINX equ $9100					;window h position
VDPR_WINY equ $9200					;window v position
VDPR_DMALENL equ $9300				; VDP register 19: DMA length, low byte
VDPR_DMALENH equ $9400				; VDP register 20: DMA length, high byte
VDPR_DMASRCL equ $9500				; VDP register 21: DMA source, low byte
VDPR_DMASRCM equ $9600				; VDP register 22: DMA source, middle byte
VDPR_DMASRCH equ $9700				; VDP register 23: DMA source, high byte and mode

;hardware
IO_CT1_CTRL equ $A10008				; controller 1 control port
IO_CT1_DATA equ $A10002				; controller 1 data port (Joy1 is its odd byte)
IO_CT2_CTRL equ $A1000A				; controller 2 control port
IO_CT2_DATA equ $A10004				; controller 2 data port
IO_Z80BUS equ $A11100				; Z80 bus request port ($100 requests the bus, 0 releases it)
IO_Z80RES equ $A11200				; Z80 reset port (0 holds the Z80 in reset, $100 releases it)
Z80_RAM equ $A00000					;Z80 RAM as seen from the 68000 (Z80_RAM+$8E is the PCM rate byte)
SaveRAM equ $200000					;battery save RAM (InitSaveRAM): $2000 bytes, the odd byte of each word.
									;93 had a serial backup RAM port here (BackupRAM_Port)
sramcleared equ $FFFF1FFE			;checksum byte of the $2000-byte save copy in work RAM (ClearSRAM)
Joy1 equ IO_CT1_DATA+1				;controller 1 data port (byte)
Joy2 equ IO_CT2_DATA+1				;controller 2 data port (byte)
Z80_YM2612 equ $A04000				;YM2612 as seen from the Z80 bus (used by the Z80 driver only)
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
SngTitle equ $78					; title screen song
SngEOP equ $79						; plays at every period end and at the end of the game
;Song slots (SongIndex, 93G names): ChooseSong takes byte SongIndex of the 6 song bytes of team HmTeam
SngGoal equ 3						;home goal tune
SngPeriodStart equ 0				;period start tune (StartPer)
SngLateGame equ 5					;late game tune, once in the 3rd period
SngPP equ 4							;home team ahead on players: power play tune (LeadSong)
SngPPAway equ 1						;away team ahead on players (LeadSong); 94 only
SngFaceoff equ 2					;face off tune, once per period; also the shootout song
SngScouting equ $7A					; scouting report
;game sound effect numbers (sfx / song argument). 95 maps them through SfxTable
SFXsiren equ $0						; goal siren
SFXbeep1 equ $1						; short beep
SFXbeep2 equ $2						; short beep, also the last minute warning
SFXwhistle equ $3					; referee whistle
SFXhorn equ $4						; horn at the end of a period
SFXpass equ $10						;4 variants, +0-3
SFXshotbh equ $14					;+0-3
SFXshotfh equ $18					;+0-3
SFXshotwiff equ $5					; whiff, a miss on a slap shot
SFXstdef equ $6						; stick deflects the puck
SFXpuckget equ $7					; puck pickup, the puck hits the ice on the face off
SFXpuckbody equ $24					; puck hits a player
SFXpuckwall1 equ $28				;+0-3
SFXpuckwall2 equ $29				;medium (92 SFXpuckwall2)
SFXpuckwall3 equ $2A				;soft (92 SFXpuckwall3)
SFXpuckwall4 equ $2B				;softest (new in 93)
SFXbglass equ $E					; puck hits the glass over the wall
SFXpuckice equ $2C					;+0-3
SFXplayerwall equ $20				; player hits the boards
SFXplayerwall2 equ $21				; player hits the boards, quieter (never played; same patches as
SFXplayerwall3 equ $22				; quieter again (never played)
SFXplayerwall4 equ $23				; quietest (never played)
SFXpuckpost equ $25					; puck hits the goal post
SFX26 equ $26						; empty 4-byte stream, no sound (never played)
SFX27 equ $27						; same empty stream as SFX26 (never played)
SFXcheck equ $1C					;+0-3
SFXhithigh equ $9					; fight punch
SFXhitlow equ $A					; fight punch at a different rate
SFXcrowdcheer equ $B				; crowd cheer
SFXcrowdboo equ $C					; crowd boo
SFXoooh equ $8						; crowd oooh
SFXoooh2 equ $D						; second, lower crowd oooh: an injury, the visiting goalie making a save
SFXhomewin equ $F					;home team won
goalline equ 176					;distance from blue line to goalline

replaystart equ $FFFF0000			;start of ram area for replay frames, also the start of RAM
M68K_RAM equ replaystart			; start of the 68000 work RAM, the same as replaystart
RAMStart equ $FF0000				;start of work RAM, as a 24-bit address
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
seLen equ 8							; size of a scoring event entry in bytes
; VDP sprite attribute table entry (Satt, 8 bytes)
satY equ 0							;word: y + 128
satSize equ 2						;byte: size code
satLink equ 3						;byte: next sprite (0 ends the list)
satTile equ 4						;word: priority, palette, flips, tile
satX equ 6							;word: x + 128
satLen equ 8						; size of a scoring attempt entry in bytes
; ScoreSum entry (6 bytes per goal)
sstime equ 0						;word: period / time of the goal
ssflags equ 2						;byte: 2 + skater difference (goal type); bit 7 = away team scored
ssscorer equ 3						;byte: scorer
ssassist1 equ 4						;byte: first assist ($FF none)
ssassist2 equ 5						;byte: second assist ($FF none)
sssize equ 6						; size of a scoring summary entry in bytes
; PenSum entry (4 bytes per penalty)
pstime equ 0						;word: period / time
pspen equ 2							;byte: penalty (Penaltylist offset); bit 7 = away team
psplayer equ 3						;byte: penalized player
pssize equ 4						; size of a penalty summary entry in bytes
; PenBuf entry (2 bytes per player in the box)
pbpen equ 0							;byte: penalty number (0 = free)
pbscnum equ 1						;byte: SCnum of the player
; puckcross entry (4 bytes; entry 0 top, entry 1 bottom)
pcx equ 0							;word: x coordinate
pcframes equ 2						;word: frames
pcsize equ 4						; size of a puck cross entry in bytes
; fofdata2 / fofdata: big faceoff sprites (4 bytes each: home center, visiting center, then fofdata = the ref)
foframe equ 0						;word: frame
foattr equ 2						;word: attribute (bit 11 x flip)
fosize equ 4						; size of a faceoff sprite entry in bytes
; PlList: 6 wanted roster players, then their positions
plpos equ 6							; PlList: 6 wanted roster players, then their positions
; Penaltylist record (word $ttmm, then the name String; 92 format comment: tt slow down time in
; half seconds, mm penalty minutes)
penmins equ 1						;byte: penalty minutes
penname equ 2						;the penalty name String
; pad objects (pads)
padxoff equ 2						;word: label x offset (QueuePadLabel sets it, setffo adds it)
; DMAList entry: source long, then (93S names)
dmalen equ 4						;word: length in words
dmavram equ 6						;word: vram address
; LineIconPosTable entry: x, y, slot count - 1
lipy equ 2							;word: y
lipslots equ 4						;word: slot count - 1
; TeamStatTextTbl entry, after the label String: two team struct offsets
tsoff2 equ 2						;word: second offset ($FFFF none)
tssize equ 4						;bytes of the two offset words (the next label follows)
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
pldsize equ 8						; size of the player rating block in bytes
; Save RAM records, read and written through recordbuf. Each record is a value, its holder, the
; opponent team and the opponent user (recordbuf, ram94.asm).
; User record block (TeamRecBase + user * 16)
urgoals equ 0						;most goals in a game
urgoalsteam equ 1					;the user's team in that game
urgoalsopp equ 2					;opponent team
urgoalsoppuser equ 3				;opponent user
ursaves equ 4						;most saves in a game
ursavesteam equ 5					; most saves in a game: the user's team
ursavesopp equ 6					; most saves in a game: opponent team
ursavesoppuser equ 7				; most saves in a game: opponent user
urwins equ 8						;word, high byte first: wins
urgames equ $A						;word, high byte first: games (stops at 9000)
urties equ $C						;word, high byte first: ties
; Crowd record block (CrowdRecBase + team * 16)
crgoals equ 0						;most goals by the team in a game
crgoalsuser equ 1					;the user playing the team
crgoalsopp equ 2					;opponent team
crgoalsoppuser equ 3				;opponent user
crsaves equ 4						;most saves by one of its goalies
crsavesuser equ 5					; career record saves: user
crsavesopp equ 6					; career record saves: opponent team
crsavesoppuser equ 7				; career record saves: opponent user
crpeak equ 8						;loudest crowd (home games)
crpeakuser equ 9					; peak crowd record: user
crpeakopp equ $A					; peak crowd record: opponent team
crpeakoppuser equ $B				; peak crowd record: opponent user
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

; team numbers (TeamList order in teamdata): schedule, playoffseats and other team-indexed tables.
; 92/93 used the numbers; 94 names them because ANA and FLA shifted every later team's index.
ANH equ 0							; team number: Mighty Ducks of Anaheim
BOS equ 1							; team number: Boston
BUF equ 2							; team number: Buffalo
CGY equ 3							; team number: Calgary
CHI equ 4							; team number: Chicago
DAL equ 5							; team number: Dallas
DET equ 6							; team number: Detroit
EDM equ 7							; team number: Edmonton
FLA equ 8							; team number: Florida
HFD equ 9							; team number: Hartford
LA equ 10							; team number: Los Angeles
MTL equ 11							; team number: Montreal
NJ equ 12							; team number: New Jersey
NYI equ 13							; team number: NY Islanders
NYR equ 14							; team number: NY Rangers
OTW equ 15							; team number: Ottawa
PHI equ 16							; team number: Philadelphia
PIT equ 17							; team number: Pittsburgh
QUE equ 18							; team number: Quebec
SJ equ 19							; team number: San Jose
STL equ 20							; team number: St. Louis
TB equ 21							; team number: Tampa Bay
TOR equ 22							; team number: Toronto
VAN equ 23							; team number: Vancouver
WSH equ 24							; team number: Washington
WPG equ 25							; team number: Winnipeg
ASE equ 26							; team number: East all star team
ASW equ 27							; team number: West all star team
; NumTeams includes the two all-star teams, which stay last (defined from TeamList in
; teamdata94.asm, included before this file). NumPlayoffTeams is the first all-star
; number: a new playoff team is inserted before ASE and both all-star numbers move up.
	IF NumTeams<>ASW+1
		inform	3,"TeamList needs one entry per team"
	ENDIF
NumPlayoffTeams equ ASE				; number of playoff teams (the all star teams are not in it)
RosterSlots equ 26					; roster slots per team
; Save RAM layout (retail addresses). Crowd records are NumTeams blocks of CrowdRecBytes at
; CrowdRecBase and must end before the records block; see docs/EXPANDING_THE_ROM.md.
CrowdRecBase equ $B60				; offset of the crowd records in the records area
CrowdRecBytes equ 16				; bytes per team crowd record
CrowdRecEnd equ CrowdRecBase+NumTeams*CrowdRecBytes	; end of the crowd records
TeamRecBase equ $D20				; offset of the team records
RecordsBytes equ $80				; size of the records block in bytes
NameLogBase equ $DA0				; offset of the name log
NameLogBytes equ $80				; size of the name log in bytes
LineDataBase equ $1EF6				; offset of the saved line data
	IF TeamRecBase<CrowdRecEnd
		inform	3,"The crowd records run into the records block (see docs/EXPANDING_THE_ROM.md)"
	ENDIF
	IF 32<NumPlayoffTeams
		inform	3,"The playoff draw only keeps 32 team bits"
	ENDIF

	RSSET	varstart				;variables from here on are allocated upwards with rs (93G)
VSCRLPM	rs.w	1					; location in vram of scroll parameters
VSPRITES	rs.w	1				; location in vram of sprite attributes
VmMAP1	rs.w	1					; location in vram of playfield 1
Map1col	rs.w	1					; 2 to this power = width in char of playfield 1
VmMAP2	rs.w	1					; location in vram of playfield 2
Map2col	rs.w	1					; 2 to this power = width in char of playfield 2
VmMAP3	rs.w	1					; location in vram of playfield 3
Map3col	rs.w	1					; 2 to this power = width in char of playfield 3
BigFontchars	rs.w	1			; vram tiles for BigFont.map
smallfontchars	rs.w	1			; vram tiles for SmallFont.map
smallfont2chars	rs.w	1			; vram tiles for the 2nd small font set.
energybarchars	rs.w	1			; vram tiles for the energy bar
logochars equ energybarchars		;reused: logo / cup sprite tiles on the title and playoff screens
rinkvrcset	rs.w	1				; vram tiles for IceRink.map
crowdvrcset	rs.w	1				;94 keeps the crowd tiles 1st vram char here
faceoffvrcset	rs.w	1			; vram tiles for FaceOff graphics
framercset	rs.w	1				; vram tiles for framer.map
EASNcset	rs.w	1				; vram tiles for EASN.map
basetileoffset	rs.w	1			; vram char of the home team block tiles; the visitor block is at +$18
spritechars	rs.w	1				; vram tiles for the sprites.
ExtraChars	rs.w	1				; vram tiles for extra graphics
printx	rs.w	1					; x cordinate for printing
printy	rs.w	1					; y cordinate for printing
printa	rs.w	1					; attribute for print characters
printm	rs.w	1					; map to use (0 = map 1, 4 = map 2, 8 = map 3)
printfontset	rs.w	1			; printsmall char set (index*2 into smallfontchars).
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
CC_ListEnd equ $FF					;String CC_ListEnd ends a menu item list (tables94.asm)
CC_PageEnd equ -1					;String CC_PageEnd ends a credits page; two in a row end
									;the credits (teamdata94.asm)
fodropx	rs.w	1					; face off drop spot x/y
fodropy	rs.w	1					; face off drop spot y (see fodropx)
recbpr	rs.l	1					; replay record buffer pointer: the frame being recorded
VBint	rs.l	1					; address of vblank interupt code
Vcount	rs.w	1					; counter for vblank
OldVcount	rs.w	1				; Vcount at the last game frame: the frame loop waits d7 frames from it
repeatdelayframes	rs.w	1		; frames until the menu cursor repeats (first delay $F, then 4)
asv	rs.w	1						; analog sound volume (crowd noise)
lldisp	rs.w	1					; line level disp update counter
periodendtime	rs.w	1			; CheckLateGameSong trigger time.
Xcord equ 0							;x and y words at the start of an sso object
Ycord equ 2							; y word of an sso object
;the sort object structure (SCstruct bytes each)
Xpos equ $0							; x position (the first word of a sort object)
attribute equ $4					;frame attribute switch bits
frame equ $6						;alice frame number
oldframe equ $8						;last frame
VRoffs equ $A						;offsets to find each sprites start char. (max of 6 sprites / frame)
VRchar equ $12						;vram char for graphic
Ypos equ $14						; y position
Zpos equ $18						; height above the ice
OldXpos equ $1C						; x position before the last move
OldYpos equ $20						; y position before the last move
OldZpos equ $24						; height before the last move
rosxoff equ OldXpos					;game setup: player sprite x offset from Xpos (optsetup94)
Xvel equ $28						; x velocity
Yvel equ $2A						; y velocity
Zvel equ $2C						; z velocity (vertical)
impactp equ $2E						;last player to cause impact
limpact equ $30						;last impact value
impact equ $32						;impact value
position equ $34					;player's position (0=goalie,1=l.def,2=r.def,3=l.wing,4=center,5=r.wing)
assnum equ $36						;index to current assignment
asslist equ $38						;list of assignments in order of execution
temp1 equ $40						; scratch word; its meaning depends on the assignment (timers, targets)
temp2 equ $42						; scratch word (see temp1)
temp3 equ $44						; scratch word (see temp1)
temp4 equ $46						; scratch word (see temp1)
temp5 equ $48						; scratch word (see temp1)
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
pflags equ $62						; player flags
pfdoff equ 0						;bit0-deceleration off
pfna equ 1							;bit1-new assignment
pfnc equ 2							;bit2-no collision mode
pfjoycon equ 3						;is player joystick controlled
pfrev equ 4							;skating backwards
pfalock equ 5						;lock out until anim is done
pfteam equ 6						;0-home(sprite0-5)/1-visitors(sprite6-11)
pfgoal equ 7						;0=bottom, 1=top (to shoot at)
pflags2 equ $63						; player flags, second word
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
weight equ $67						; player weight (collision oomph and checking)
legstr equ $68						; leg strength (checking power)
legspd equ $69						; leg speed (skating speed)
aioff equ $6A						; offensive rating (CPU offense)
aidef equ $6B						; defensive rating (CPU defense)
shotspd equ $6C						; shot speed
shotacc equ $6D						; player rating: shot accuracy
passacc equ $6E						; pass accuracy
rostnum equ $6F						; roster number of the player
spodds equ $70						; player rating: shoot / pass odds
stickhand equ $71					; player rating: stickhandling
endurance equ $72					; player rating: endurance
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
Ylist	rs.w	16					; list of y cords for each sortobj
OOlistpos	rs.w	16				; objects pos in OOlist
OOlist	rs.w	8					; object order list for sort objs
Crowdframe	rs.w	1				; current crowd frame number
Crowdlevel	rs.w	1				; level of crowd excitement
Crowdstep	rs.w	1				; animation step for crowd
Crowdcnt	rs.w	1				; count down to next step.
CwdExciteLvl	rs.w	1			; crowd excitement level (starts at gamelevel*16, +$1E on an injury, +$28
MaxCwdExciteLvl	rs.w	1			; peak crowd level.
NumCwdExciteLvl	rs.w	1			; crowd level sample count.
SumCwdExciteLvl	rs.l	1			; crowd level running total.
Zamx	rs.w	1					; zamboni x cord
playoffspritex	rs.w	1			; logo sprite x (title / playoff screens).
playoffspritey	rs.w	1			; logo sprite y.
clampcounter	rs.w	1			; credits page wait counter (how long the first page stays)
logoslide equ clampcounter			;reused: title / playoff screen page time (credits wait)
DMAList	rs.w	560					; dma transfer list
DMAlistend	rs.l	1				; end of the DMA list: where the next entry is written
Vpos	rs.w	1					; ice rink vertical position
Oldrow	rs.w	1					; last row (used in vertical scrolling of the map data)
Hpos	rs.w	1					; ice rink horizontal position
Hscroll	rs.w	1					; horizontal scroll value
Vscroll	rs.w	1					; vertical scroll value
Blueline equ $58					;distance from center line to blueline
Sideline equ $88					;distance from center to side boards
wcradiusx	rs.w	1				; variables used in wall collisions
wcradiusy	rs.w	1				; wall collision radius y (see wcradiusx)
palcount	rs.w	1				; counter for fading in color palettes
palfadenew	rs.w	64				; palettes to fade into (+$20 the title palette, +$40 palettes 2-3)
fofdata2	rs.w	4				; faceoff sprite data, second set
fofdata	rs.l	1					; data for frame/att of big face off sprites
ffonum	equ	7						;objects tied to the rink scroll (93 had 5)
ffosize equ OldXpos					;field objects tied to icerink scrolling (pads), OldXpos bytes each (92G)
pads	rs.w	14					;face-off ice pad object (93 pads object 0). Not joypads
Joy1Struct	rs.w	28				;controller 1 and 2 arrow objects (93 pads+ffosize, two ffo)
Joy2Struct	equ	Joy1Struct+ffosize	;controller 2 arrow object (second half of Joy1Struct)
CameraPosStruct	rs.w	11			; scroll camera: tracked object, target and the lead on the scroll
;replay camera struct (CameraPosStruct, 93 name): stands in for a sort object, Xpos / Ypos
;are its position (UpdateCameraPos). It is really 14 words: camtrack and camidle lie past the 11
;words 93 reserved for it and overlap replayactive (camtrack is the replayactive word)
camtrack equ $16					;SCnum of the object tracked in replay
camidle equ $18						;$FF while the replay d-pad is idle, cleared on scroll/track (never read)
replayactive	rs.w	3			; set by ReplayMode.
Joy3Struct	rs.w	14				;controller 3 arrow object (4 Way Play; 93 had glovestruct here)
Joy4Struct	rs.w	14				;controller 4 arrow object (4 Way Play)
glovestruct	rs.w	14				; gloves object, pads+(4*ffosize).
PadControlBits	rs.w	1			; pad assignment bits ($FFFF = no assignments, set at game setup)
padcont	rs.w	6					; pad assignment data (4 words), cleared together with PadControlBits
PadControlBits34	rs.w	1		;as PadControlBits, for pads 3 and 4 (4 way play)
ssonum	equ	4						;screen objects not tied to the rink scroll (2 arrows + 2 scoreboard
									;logos)
ssosize	equ	$14						;bytes per sso object
sso	rs.w	40						; screen objects not tied to the rink scroll: 2 arrows for off screen
shotplayer	rs.w	1				; player who shot last
lastplayer	rs.w	1				; last player who touched puck
passdir	rs.w	1					; direction for pass/shot
passspeed	rs.w	1				; speed of pass/shot
passReceiverPlayerNum	rs.w	1	;SCnum of the intended receiver of the last pass, -1 = none (94 had
									;passplayer)
glovecords	rs.w	1				; cordinates of glove/sticks (fighting)
threat	rs.w	1					; direction of threat on puck handler
puckcross	rs.b	2*pcsize		;xcord / frames, top entry then bottom (93G rs.w 4)
puckcross2	equ	puckcross+pcframes	;top entry frames
puckcross4	equ	puckcross+pcsize	;bottom entry x
puckcross6	equ	puckcross+pcsize+pcframes	;bottom entry frames
lj1	rs.w	1						; used in joystick debounce
lj2	rs.w	1						; joystick debounce for pad 2 (see lj1)
lj3	rs.w	1						; controller 3 joystick state
lj4	rs.w	1						; controller 4 joystick state
PadRaw1	rs.b	1					; Rev B: controller 1 as read by ReadPads in the vblank (active low)
PadRaw2	rs.b	1					; Rev B: controller 2 (ReadJoy1/ReadJoy2 only translate these)
PadRaw3	rs.b	1					; controller 3 raw pad byte
PadRaw4	rs.b	1					; controller 4 raw pad byte
pad4wayword	rs.l	1				;the pad word the unused ReadJoySwapPad1-4 swap a pad's saved word into
									;around ReadJoy1
pad4waysave1	rs.w	1			;ReadJoySwapPad1 saved pad word
pad4waysave2	rs.w	1			;ReadJoySwapPad2 saved pad word
pad4waysave3	rs.w	1			;ReadJoySwapPad3 saved pad word
pad4waysave4	rs.w	1			;ReadJoySwapPad4 saved pad word
bholdtimer	rs.w	1				;B button hold timers of pads 1 / 2 (one byte each); bholdtimer34 for pads
									;3 / 4
bholdtimer34	rs.w	1			; B button hold timers, controllers 3 and 4
padword3	rs.w	1				; controller 3 pad word
padword4	rs.w	1				; controller 4 pad word
padword1	rs.w	1				;a pad 1 word swapped with padword3 for 4 way play (updateplayers)
padword2	rs.w	1				;a pad 2 word swapped with padword4 for 4 way play (updateplayers)
TempWord1	rs.w	1				;a scratch word (hot / cold totals, record page, button direction ...)
TempWord2	rs.w	1				;a scratch word (hot / cold totals, attribute number, credits step ...)
TempRawSpd	rs.w	1				; temporary: raw speed
TempMaxSpd	rs.l	1				; temporary: maximum speed
TempEnergySpd	rs.w	1			; temporary: speed after energy
TempLegSpd	rs.w	1				; temporary: leg speed
TempBuffer	rs.w	20				;40 byte scratch buffer: String buffer (AppendNumber, names, "(played by
									;NAME)"), hot / cold player, sum byte pairs
scorergoalies	rs.w	1			; first goalie slot of the scoring team (scorer check in setup)
recties	rs.w	1					; team record: ties
reclosses	rs.w	1				; team record: losses
recwins	rs.w	1					; team record: wins
awayhotter	rs.w	1				; away team hot player
setupfontchars	rs.w	1			; first font character of the setup screens
awayhotidx	rs.w	1				; away team hot player index
homehotidx	rs.w	1				; home team hot player index
awaycoldidx	rs.w	1				; away team cold player index
homecoldidx	rs.w	1				; home team cold player index
awayhotplayer	rs.w	1			;the away team's hottest starter (BuildHotColdLists)
homehotplayer	rs.w	1			;the home team's hottest starter
awaycoldplayer	rs.w	1			;the away team's coldest starter
homecoldplayer	rs.w	1			;the home team's coldest starter
ChkBodyG	rs.w	1				; body check strength of the goalie
ChkBodySqG	rs.l	1				; body check strength squared, goalie
NegChkBodyG	rs.w	1				; negated body check strength of the goalie
onetimerplayer	rs.w	1			; player taking a one timer
onetimerclock	rs.w	4			; one timer timing clocks
onetimerflags	rs.w	1			; one timer flags
disflags	rs.w	1				; display flags
dfok equ 0							;graphics are ready for transfer
df32c equ 1							;32 column mode on
dfng equ 2							;don't int graphics
dfclock equ 3						;clock needs update
dffaceoff equ 4						;face off sprites on (92 tested sf2faceoff).
ltplayer	rs.w	1				; last touch player
ltx	rs.w	1						; last touch x cord
lty	rs.w	1						; last touch y cord
iflags	rs.b	1					; icing
ifcgl equ 0							;iflags: crossed goalline
ifdir equ 1							;iflags: 1=must cross top line
ifok equ 2							;iflags: icing
icingPlayer	rs.b	5				; icing: the SCnum+1 of the last player to touch the puck (iflags+1), then
jps equ 24							;jiffys per second
jiffy equ $10000/jps				; one jiffy as a fraction of a second ($10000/jps)
clockram	rs.w	4				; ram for dma transfer of clock digits
xc1	rs.w	1						; scroll lock x cord
yc1	rs.w	1						; scroll lock y cord
yleader	rs.w	1					; lead distance on scrolling
fox	rs.w	1						; faceoff spot x/y
foy	rs.w	1						; face off spot y (see fox)
fodir1	rs.w	1					; pull directions for each player on face off
fodir2	rs.w	1					; pull direction for the visiting player on the face off (see fodir1)
deltax	rs.w	1					; used lots of places for x/y stuff
deltay	rs.w	1					; y difference, used in many places (see deltax)
collflag	rs.w	1				; collision has occured
evalue	rs.w	1					; elasticity value (parameter of collisions)
mesarea	rs.w	1					; temp area for mes chars
TextBuffer	rs.w	49				; to mesarea+100
PushWidthBuf	rs.w	4			; PushNumberWidth string: length word, then digits.
PushNumberBuf	rs.w	1			; PushNumber builds its string down from here.
redrawicons	rs.w	1				; DrawLineIcons: last icon group drawn ($FF = redraw).
ltack	rs.w	1					; last tackle sound.
lastsfx	rs.w	1					; last sound played
Satt	rs.w	360					; sprite attribute table (for dma transfer
Sattsize	rs.w	1				; size of transfer
gmode	rs.w	1					; game mode flag
gmclock equ 0						;game clock is stopped
gmdir equ 1							;0 = home team goes up
gmpen equ 2							;penalty has been called
gmpendel equ 3						;delayed penalty has been called
gmhl equ 4							;hilight mode
gmoffs equ 5						;offsides on
gmeog equ 6							;game over reached: the next face off goes to PeriodOver
gmstars equ 7						;the Stars of the Game box was already shown
sflags	rs.w	1					; game state flags
sfpz equ 0							;pause mode
sfpj equ 1							;pause cont (0 for cont 1)
sfspdir equ 2						;set pass dir mode
sfssdir equ 3						;set shot dir mode
sfwrap equ 4						;replay has wrapped around
sfscrl equ 5						;replay scroll is manual cont
sfslock equ 6						;scroll lock to xc1/yc1
sfhor equ 7							;screen is in horizontal mode
sflags2	rs.w	1					; game state flags, second word
sf2faceoff equ 0					;face off in progress
sf2refref equ 1						;ref needs refresh
sf2drec equ 2						;disable replay record
sf2replay equ 3						;replay in progress
sf2shot equ 4						;shot was taken
sf2pwrplay equ 5					;power play in progress
sf2pwrtm equ 6						;0 for team 1 in power play
sf2offsig equ 7						;offsides little ref on
sflags3	rs.w	1					; game state flags, third word
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
BA_PS_flags	rs.w	1				;breakaway / penalty shot / shootout flags (94)
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
DelayedPen	rs.l	1				;delayed penalty (94): bit 0 PP goal, bit 1 home, bit 2 away
crowdnoisedelay	rs.w	1			; frames until the next crowd noise
CwdChkCntr	rs.w	1				; Crowd meter frame counter
CwdChkCnt	rs.w	3				; Crowd meter update count
CurCrowdMeter	rs.w	1			; current crowd meter level
CrowdRecord	rs.w	1				; The crowd record threshold
CrowdAvg	rs.w	1				; Crowd noise off level
CrowdPeak	rs.w	1				; The crowd peak of the game
pausepad	rs.w	1				; pad that paused the game
joypuckcarrier	rs.w	1			; player with the puck controlled by the joypad
msgtimer	rs.w	1				; on screen message timer
passmodetimer	rs.w	1			; pass mode timer
savednewpnum	rs.w	1			; saved new player number
c1playernum	rs.w	1				; player in control or neg for none
c2playernum	rs.w	1				; player controlled by pad 2, negative = none (see c1playernum)
c3playernum	rs.w	1				; controller 3 player number
c4playernum	rs.w	1				; controller 4 player number
cont1team	rs.w	1				; cont1 team 0=none 1=team1 2=team2
cont2team	rs.w	1				; team of controller 2: 0 = none (see cont1team)
cont3team	rs.w	1				; team of controller 3
cont4team	rs.w	1				; team of controller 4
HomeTeam	rs.w	1				; number 0-24
VisTeam	rs.w	1					; visiting team number (0-24, see HomeTeam)
TeamBlockMap	rs.w	56			;Map word buffer for CopyTeamBlockMapData and PutTeamBlock
MaxPen equ 32						;penalties kept in PenBuf
PenBuf	rs.w	MaxPen+1			; upto x penalties saved
PenCntDwn	rs.w	1				; frames until the penalty or stoppage message ends (fights 60, an injury
Penaltytimer	rs.w	1			; counts down the second for the penalty clocks (jps frames)
PBnum	rs.w	1					; $HV00 h=home players in pb
InjCntDown	rs.w	1				; frames until the injury box is shown after an injury
penmsgtimer	rs.w	1				; penalty message timer
RefCnt	rs.w	1					; ref graphics control
RefStep	rs.w	1					; ref animation step: word offset into the ref frames, -1 = ref idle
RefPen	rs.w	1					; penalty number the ref is calling (4 = game over)
RefRamMap	rs.w	refwidth*refheight	; ref cam map words (refwidth x refheight)
gsp	rs.w	1						; game period
gameclock	rs.l	1				; game clock
PerTimeTotal	rs.w	1			; total time of the period
ChkCnt	rs.w	1					; check counter for the player check stat
TempPlOffset	rs.w	1			; roster offset of the player to print (bit 15 =
ScoreSumbytes	rs.w	1			; bytes used in ScoreSum (6 per goal)
ScoreSum	rs.w	180				; scoring summary: 6 bytes per goal (scorer, assists, time)
PenSumLength	rs.w	1			; bytes used in PenSum (4 per penalty).
PenSum	rs.w	120					; penalty summary log, 4 bytes per penalty.
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
statsbuffer	rs.w	104				; playoff team stat totals, summed from the stat bytes
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
gssize equ $10						; bytes per game structure
gstruct	rs.b	gssize*8			;8 game structures
gamenum	rs.w	1					; index for current game in game struct
postarts	rs.w	1				; 0-31 for which playoff tree to use as frame
bosgames	rs.w	1				; 0-6 game of series or 7 if not in best of seven
gamelevel	rs.w	1				; 0-3 for the depth into the play off tree
potreeteam	rs.w	1				; which team you are on the intial playoff tree
pojoy	rs.w	1					; playoff joystick indicator
WinBits	rs.w	1					; bits which indicat the continuing teams on the playoff tree
potree	rs.w	16					; team in the tree
PlList	rs.w	6					; list of players used differently
menuitem	rs.l	1				;menu state: selected item, then (+2) first item shown
menulist	rs.l	1				; menu item list.
menudraw	rs.l	1				; menu screen draw routine.
TickerNum	rs.w	1				; intermission ticker: index of the game being shown, negative = no more
PPBonus	rs.b	1					; check bonuses, cleared together by clr.l.
PKBonus	rs.b	1					; penalty kill bonus
ThirdPBonus	rs.b	1				; third period bonus
HmAwBonus	rs.b	1				; home / visitor bonus
remapTablePtr	rs.l	1			; remap table for DecompressGraphicsWithRemap; 0 = plain DMA
ThreeStars	rs.w	100				; three stars of the game data
starscores equ ThreeStars			;the 52 star score longs (CalcStarScores)
recordbuf equ ThreeStars			;the save RAM record staging buffer (shares ThreeStars)
decompbuffer equ ThreeStars			;DecompressBytecode 256 byte ring buffer (shares ThreeStars)
teamrecbuf	rs.w	28				;SRAM team record buffer: the 16 byte record of a team (ReadCrowdRecord),
									;byte 8 crowd record, byte 9 its name number
nibblebuffer	rs.w	6			; UnpackNibbles words, WeightedRandomSelect weights.
varend equ nibblebuffer+8			;end of the variables cleared by Opening2
homeuser	rs.w	1				; home team user controller
awayuser	rs.w	1				; away team user controller
FourWayPlay	rs.w	1				;EA 4 Way Play adaptor present (Detect4WayPlay). With the Opt* setup
									;flags, not the pad I/O (PadRaw / ReadPad4Way)
OptPlayMode	rs.w	1				; play mode
OptNOP	rs.w	1					; number of players
Opt1team	rs.w	1				; team 1
Opt2team	rs.w	1				; team 2
Optperlen	rs.w	1				; period length index.
OptGoalie	rs.w	1				; option: goalie
OptUserRec	rs.w	1				; option: user records
OptPen	rs.w	1					; penalties 1 for off
OptLine	rs.w	1					; line changes option
goaliemode1	rs.w	1				; goalie mode, home
goaliemode2	rs.w	1				; goalie mode, away
TmpOptUserRec	rs.w	1			; temporary option: user records
TmpOptPen	rs.w	1				; temporary option: penalties
TmpOptLine	rs.w	1				; temporary option: line changes
demoflag	rs.w	1				; demo flag
seed	rs.l	1					; seed for the random number generator
dmaram	rs.l	1					; dma ram area.
PalMode	rs.w	1					; Rev A only: VDP PAL bit (Begin). Set = 50 Hz: faster skating
music_tick_divider	rs.w	1		; Rev A only: p_music_vblank runs the track slots again every 6th frame
TmpOptLine2	rs.w	1				; temporary option: line changes, second
TempOptPlayMode	rs.w	1			; temporary option: play mode
databuffer	rs.w	9				; scratch data buffer
passbits	rs.w	5				;playoff password bits (94 had pwddatabuffer)
outputbuffer	rs.w	113			; work buffer, also the shot data kept between games
marker	rs.w	1					;last word of the $100 byte saved block (databuffer .. marker), as 93
tpassbits	rs.w	5				; temporary storage of passbits.
music_needs_z80_update	rs.w	1	; nonzero when the Z80 must be sent the channel changes
Z80_command_buffer	rs.b	5		; key off/on, volume, frequency and patch bits for the Z80 (5 bytes)
per_channel_attenuation_table	rs.b	7	; FM channel attenuation (7 bytes, 6 FM + the DAC)
per_channel_frequency_table	rs.w	7	; FM channel frequency values (7 words)
per_channel_patch_table	rs.w	4	; FM channel patch numbers (4 words)
fm_voice_usage_table	rs.w	256	; which track slot uses each FM voice (256 words)
fm_channel_structs	rs.w	20		; FM channel state (15 words)
pcm_channel_struct	rs.w	4		;PCM (DAC) channel struct, after the 5 FM structs (94 had
									;fm_channel_struct6)
fm_track_slots	rs.w	24			; track slots that play the sounds and songs (25 words)
BA_Team	rs.w	1					;breakaway / penalty shot / shootout: which team (with BA_PS_flags)
BA_Sktr_SCnum	rs.w	1			;SCnum of the breakaway / penalty-shot / shootout skater
BA_Goalie_SCnum	rs.w	1			;SCnum of that play's goalie
BA_Skater_Offset	rs.w	1		;that skater's team position offset
BA_Goalie_Offset	rs.w	1		;that goalie's team position offset
BA_Checker_Offset	rs.w	1		;the checker's team position offset (penalty shot)
pspenalty	rs.w	1				; penalty summary: penalty number
holdreset	rs.w	1				; hold reset countdown
onetimertargetx	rs.w	1			; one timer target x
onetimertargety	rs.w	1			; one timer target y
onetimerheight	rs.w	1			; one timer puck height
FallYPos	rs.w	1				; falling player y position
FallXPos	rs.w	1				; falling player x position
aholdtimer	rs.w	1				;A button hold timers of pads 1 / 2 (one byte each); aholdtimer34 for pads
									;3 / 4
aholdtimer34	rs.w	1			; A button hold timers, controllers 3 and 4
setupfirstline	rs.w	1			; setup screen: first line shown
setupprevline	rs.w	1			; setup screen: previous line
setupmenuchars	rs.w	1			; setup screen: menu character base
logoteam	rs.w	1				; team whose logo is shown
setuphome	rs.w	1				; setup screen: home team
setupvis	rs.w	1				; setup screen: visiting team
setupcardflags	rs.w	1			; setup screen: player card flags
homepicchars	rs.w	1			; home team picture characters
vispicchars	rs.w	1				; visiting team picture characters
cardroster	rs.w	1				; player card: roster
logobox1chars	rs.w	1			; logo box 1 characters
logobox2chars	rs.w	1			; logo box 2 characters
teambitmapchars	rs.w	1			; team bitmap characters
cardtimer	rs.w	1				; player card timer
featuredplayer	rs.w	1			; featured player
carddelay	rs.w	1				; player card delay
cardprintx	rs.w	1				; player card print x
cardprinty	rs.w	1				; player card print y
cardteamnum	rs.w	1				; player card team number
homegoalies	rs.w	1				; home team goalies
awaygoalies	rs.w	1				; away team goalies
homeplayers	rs.w	1				; Players of the home team (CountPlayers)
awayplayers	rs.w	1				; Players of the away team (CountPlayers)
cardlogochars1	rs.w	1			; card logo characters 1
cardlogochars2	rs.w	1			; card logo characters 2
shootoutclock	rs.w	1			; The shootout clock
shootoutjiffy	rs.w	1			; shootout frame counter
ValidSRAM	rs.w	1				; nonzero when the save RAM is valid
namelog	rs.w	64					;the user name log: $80 bytes from save RAM NameLogBase (NameLogIO),
									;12 bytes per name, namelogsel the entry
nameentrybuf	rs.w	7			; name entry buffer
namelength	rs.w	1				; length of the name being entered
namelogsel	rs.w	1				; selected name log entry
namelogarrows	rs.w	1			; Name entry: the name log row with the arrows
nameentryvis	rs.w	1			; name entry cursor visible
homecardidx	rs.w	1				; home player card index
awaycardidx	rs.w	1				; away player card index
cardindex	rs.w	1				; player card index
cardvis	rs.w	1					; player card visible
cardcount	rs.w	1				; player card count
homecardlist	rs.w	13			;the home player card order (BuildCardPlayerLists), read by GetCardPlayer
awaycardlist	rs.w	13			;the away player card order
cardplayer	rs.w	1				; player card player
nameframechars	rs.w	1			; Name entry frame chars (NameEntryFramer)
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
homeshootgoals	rs.w	1			; Shootout goals, home
awayshootgoals	rs.w	1			; Shootout goals, away
shootoutround	rs.w	1			; Shootout round
homeshooters	rs.w	6			;the home shootout shooter list (6 words, homeshootnum the index)
homeshootnum	rs.w	1			; The shooter index of the shootout
awayshooters	rs.w	6			;the away shootout shooter list (6 words)
shootoutteam	rs.l	1			; Shootout: 0 home shoots, 1 away
matchup	rs.w	1					; matchup screen: selection
scoutunused	rs.w	1				;cleared by ScoutingReport, never read
matchuphome	rs.w	1				; matchup screen: home team
matchupvis	rs.w	1				;the visitors player of the matchup; also the scroll limit of StatsReport
homerating	rs.w	1				; home team rating
visrating	rs.w	1				; visiting team rating
advframe	rs.w	1				; advantage meter frame
advcount	rs.w	1				; advantage meter count
matchuptimer	rs.w	1			; matchup screen timer
matchupslot	rs.w	1				; matchup screen slot
;DispAttribCtr to TestList are not in 93G order: 94 moved them, and the addresses here are 94's
DispAttribCtr	rs.w	1			; stats screens: attribute page / sort column
playoffscroll equ DispAttribCtr		;reused: playoff screen scroll position
scoutcolumn equ DispAttribCtr		;reused: scouting report column
titlescrollspeed equ DispAttribCtr	;reused: title screen attribute display counter
VertLineScrolling	rs.w	1		; scouting report: text line being drawn, -1 = none
PlayerScrollCtr	rs.w	1			; scouting report: scroll step per frame (RAM
SelectedPlayerIdx	rs.w	1		; scouting report: index into TestList (RAM shared with the stats screens)
ScoutingReportTimer	rs.w	1		;scouting report: frames elapsed, the text typing delay (94 had typedelay)
screentimer	rs.w	1				; frames left on a screen (ScoutingReport); last cursor row.
TestList	rs.w	122				; scouting report: list of the lines to show (also the line editor cursor
arenaanimchars	rs.w	1			; arena animation characters
arenaframe	rs.w	1				; arena animation frame
arenaframeidx	rs.w	1			; arena animation frame index
arenaframetime	rs.w	1			; arena animation frame time
arenaanim	rs.w	1				; arena animation
arenaframelist	rs.l	1			; arena animation frame list pointer
arenaspritelist	rs.l	1			; arena sprite list pointer
faceoffanim	rs.w	3				; faceoff animation state
cursoron	rs.w	1				; cursor visible
facelcwait	rs.w	1				; wait value, set to $FFFF by the logic
SongNum	rs.w	1					; current song number
HmTeam	rs.w	1					; home team
SongIndex	rs.w	1				; song index
OvrDivisor	rs.w	1				; overall rating divisor
OvrDividend	rs.w	1				; overall rating dividend
homehotcoldsave	rs.w	208			;clearTeamStats keeps the home hot / cold table (tmstruct+tmHotCold)
									;here
awayhotcoldsave	rs.w	208			;the same for the awtmstruct table
sopath	rs.w	1					; shootout path
sopathpoint	rs.w	1				; shootout path point
sopathx	rs.w	1					; shootout path x
sopathy	rs.w	1					; shootout path y
sopathdir	rs.w	1				; passdir at the end of the shootout path
sopathend	rs.w	1				; shootout path end
picturebuf	rs.w	577				;UnpackPicture output: tile count word, then the 4 bit tiles
									;(DrawMatchupBitmap, dobitmap read it)
picturebits	rs.l	1				;UnpackPicture: the 3 packed bytes of the row being unpacked
homepresses	rs.l	1				; home team button presses
homedirpresses	rs.l	1			; home team direction presses
awaypresses	rs.l	1				; away team button presses
awaydirpresses	rs.l	1			; away team direction presses
replayicontimer	rs.w	1			; replay icon timer
TmpPuckX	rs.l	1				; temporary puck x
lognametext	rs.w	9				;the unused TerminateLogName's GetLogName String text (length word at -2)
songdelay	rs.w	1				; frames until the delayed song starts
delayedsong	rs.w	1				; song waiting to start
shootoutdelay	rs.w	1			; Frames before the shootout ends
PuckZCntr	rs.w	1				; Frames the puck has hung at one height
waitxpad	rs.w	1				; pad used by the wait routine
TmpPuckZ	rs.w	1				; puckz last frame
inputjoy	rs.w	1				; joypad input
TmpJoyPuckCarrier	rs.w	1		; temporary joypad puck carrier
PlayerChked	rs.l	1				; player being checked
PlayerChking	rs.l	1			; player checking
hoticonchars	rs.w	1			; First vram char of the hot icon (ScoutingReport, HotIconMap)
coldiconchars	rs.w	1			; First vram char of the cold icon (ColdIconMap)
iconplayer	rs.w	1				; icon player
iconx	rs.w	1					; icon x position
scoutwait	rs.l	1				; scouting report wait
replaydelay	rs.w	1				; replay delay
PALflag	rs.w	4230				; nonzero on a PAL console
	rs.w	1						;the word at Stack
; ----------------------------------



