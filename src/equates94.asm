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
; constants that were defined among the variables in the old ram94.asm (they need no RAM address)
strtext equ 2						;String: start of the text after its length word
CC_SetMap equ $FF					;-1: map
CC_SetAttribute equ $FE				;-2: palette/priority (printa)
CC_SetX equ $FD						;-3: printx
CC_SetY equ $FC						;-4: printy
CC_AddX equ $FB						;-5: add signed byte to printx
CC_AddY equ $FA						;-6: add signed byte to printy
CC_SetFont equ $F9					;-7: char set
CC_SetMapAndPosition equ $F8		;-8: attribute, map, x, y
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
CC_ListEnd equ $FF					;String CC_ListEnd ends a menu item list (tables94.asm)
CC_PageEnd equ -1					;String CC_PageEnd ends a credits page; two in a row end
									;the credits (teamdata94.asm)
Xcord equ 0							;x and y words at the start of an sso object
Ycord equ 2							; y word of an sso object
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
puckscnum equ 14					;puck is sort obj number 14
Blueline equ $58					;distance from center line to blueline
Sideline equ $88					;distance from center to side boards
ffonum	equ	7						;objects tied to the rink scroll (93 had 5)
ffosize equ OldXpos					;field objects tied to icerink scrolling (pads), OldXpos bytes each (92G)
camtrack equ $16					;SCnum of the object tracked in replay
camidle equ $18						;$FF while the replay d-pad is idle, cleared on scroll/track (never read)
ssonum	equ	4						;screen objects not tied to the rink scroll (2 arrows + 2 scoreboard
									;logos)
ssosize	equ	$14						;bytes per sso object
dfok equ 0							;graphics are ready for transfer
df32c equ 1							;32 column mode on
dfng equ 2							;don't int graphics
dfclock equ 3						;clock needs update
dffaceoff equ 4						;face off sprites on (92 tested sf2faceoff).
ifcgl equ 0							;iflags: crossed goalline
ifdir equ 1							;iflags: 1=must cross top line
ifok equ 2							;iflags: icing
jps equ 24							;jiffys per second
jiffy equ $10000/jps				; one jiffy as a fraction of a second ($10000/jps)
gmclock equ 0						;game clock is stopped
gmdir equ 1							;0 = home team goes up
gmpen equ 2							;penalty has been called
gmpendel equ 3						;delayed penalty has been called
gmhl equ 4							;hilight mode
gmoffs equ 5						;offsides on
gmeog equ 6							;game over reached: the next face off goes to PeriodOver
gmstars equ 7						;the Stars of the Game box was already shown
sfpz equ 0							;pause mode
sfpj equ 1							;pause cont (0 for cont 1)
sfspdir equ 2						;set pass dir mode
sfssdir equ 3						;set shot dir mode
sfwrap equ 4						;replay has wrapped around
sfscrl equ 5						;replay scroll is manual cont
sfslock equ 6						;scroll lock to xc1/yc1
sfhor equ 7							;screen is in horizontal mode
sf2faceoff equ 0					;face off in progress
sf2refref equ 1						;ref needs refresh
sf2drec equ 2						;disable replay record
sf2replay equ 3						;replay in progress
sf2shot equ 4						;shot was taken
sf2pwrplay equ 5					;power play in progress
sf2pwrtm equ 6						;0 for team 1 in power play
sf2offsig equ 7						;offsides little ref on
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
MaxPen equ 32						;penalties kept in PenBuf
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
tmgoalie set $26					;goalie 1/2/none
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
