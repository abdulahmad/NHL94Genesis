;	Shared equates. These name hardware constants and game values
;	that every module uses.

PAL_MODE equ 0
; ----------------------------------
; ------------- game equates named like NHLPA93Genesis ram93.asm -------------
MaxSprites equ 64					;max sprites during game (64 because 32 col mode)

;joystick button equates (bit numbers)
ubut equ 0							;up
dbut equ 1							;down
lbut equ 2							;left
rbut equ 3							;right
bbut equ 4							;b button
cbut equ 5							;c button
abut equ 6							;a button
sbut equ 7							;start button
osflag equ 20000					;flag for off screen graphic ($4E20)

goalline equ 176					;distance from blue line to goalline
Blueline equ $58					;distance from center line to blueline
Sideline equ $88					;distance from center to side boards
replaystart equ $FFFF0000			;start of ram area for replay frames, also the start of RAM
replaysize equ 98					;bytes per replay frame (92G/93G name; 92G 84)
scsize equ 7						;2 to this power indicates ram needed for each sortobj
jps equ 24							;jiffys per second
jiffy equ $10000/jps
maxros equ 26						;roster slots per team in the team structure
ifcgl equ 0							;iflags: crossed goalline
ifdir equ 1							;iflags: 1=must cross top line
ifok equ 2							;iflags: icing
tmflcc equ 0						;tmflags: line change on
;flag bits added in 93 and shared by the later games (names and meanings from NHLPA93Genesis ram93.asm)
dffaceoff equ 4						;face off sprites on (92 tested sf2faceoff).
gmeog equ 6							;game over reached: the next face off goes to PeriodOver
gsfhl equ 1							;hilite requested
gsfso equ 2							;series over
gsftf equ 0							;teams are flipped
pf2inj equ 6						;player is injured (SPAfinjury animation, max speed 1/8).
pf2lcm equ 3						;line change mode. 92 bit 5
pf2npc equ 5						;no player collision. 92 bit 7
pf2pen equ 4						;player has caused a penalty. 92 bit 6
pf2unav equ 2						;player is unavailable (going to/from bench/penalty). 92 bit 4
sf3fo equ 4							;face off just ended (set by the drop): the next puck pickup wins it, with
									;a crowd cheer.
sf3icetime equ 6					;set once a second by updatepentime: each player on the ice adds 1 to its
									;time on ice.
sf3track equ 5						;the scroll window tracks an object.
tmflast equ 3						;next touch overwrites the last touch only.
tmflcm equ 1						;team is in line change mode (92 scanned the players for pf2lcm)
tmfoside equ 4						;team is offsides (92 flagged the player with pf3oside)
tmftimeout equ 2					;timeout used (the pause menu drops Timeout from then on). Same bit as
									;tmfmid and tmfslide
tmfmid equ tmftimeout				;nearest player always takes the in-between spot (assnearest)
tmfslide equ tmftimeout				;93 roster screen name slide; unused here (UpdateRosterPlayers is empty)
sf3fosong equ 7						;set for periods 1 and 2: play the face off tune once, at the first face
									;off past half the period
gmstars equ 7						;the Stars of the Game box was already shown
; ----------------------------------




; ------------- 93 structure and flag equates -------------
; Included by nhl94.asm. Names are the NHLPA93Genesis names; the value is 94's.

Sortobjs equ 16						;number of sorted graphics objects
SCstruct equ 1<<scsize				;ram for each sortobj (SortCords entry)
puckscnum equ 14					;puck is sort obj number 14

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
ffosize equ OldXpos					;field objects tied to icerink scrolling (pads), OldXpos bytes each (92G)
OldYpos equ $20
OldZpos equ $24
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
handed equ $76						;bit0 set is left handed
;player struct fields after handed's neighbours, not named in 93 (names from the 92/93/94 comments)
pflags3 equ $64						;player flags 3 (92: not used)
pf3oside equ 0						;offsides
pf3break equ 1						;on a breakaway
pf3gctrl equ 2						;goalie control
pf3onetimer equ 3					;doing a one-timer
pf3wall equ 4						;wall collision
pf3fall equ 5						;falling down
aggress equ $73						;aggression (Agr; goalie: glove left)
GGSleft equ aggress					;goalie glove save left (92 name; 92 put it on stickhand)
fighting equ $74					;fighting (Fgt; from the Chk/Hnd byte, always even)
checking equ $75					;checking (Chk)

;bit numbers in disflags
dfok equ 0							;graphics are ready for transfer
df32c equ 1							;32 column mode on
dfng equ 2							;don't int graphics
dfclock equ 3						;clock needs update
;bit numbers in gmode
gmclock equ 0						;game clock is stopped
gmdir equ 1							;0 = home team goes up
gmpen equ 2							;penalty has been called
gmpendel equ 3						;delayed penalty has been called
gmhl equ 4							;hilight mode
gmoffs equ 5						;offsides on
;bit numbers in sflags
sfpz equ 0							;pause mode
sfpj equ 1							;pause cont (0 for cont 1)
sfspdir equ 2						;set pass dir mode
sfssdir equ 3						;set shot dir mode
sfwrap equ 4						;replay has wrapped around
sfscrl equ 5						;replay scroll is manual cont
sfslock equ 6						;scroll lock to xc1/yc1
sfhor equ 7							;screen is in horizontal mode
;bit numbers in sflags2
sf2faceoff equ 0					;face off in progress
sf2refref equ 1						;ref needs refresh
sf2drec equ 2						;disable replay record
sf2replay equ 3						;replay in progress
sf2shot equ 4						;shot was taken
sf2pwrplay equ 5					;power play in progress
sf2pwrtm equ 6						;0 for team 1 in power play
sf2offsig equ 7						;offsides little ref on
;bit numbers in sflags3
sf3llcs equ 0						;lower line change sel.
sf3rmplay equ 1						;play mode on for replay
sf3alttree equ 2					;alt. tree
sf3sbut equ 3						;flag for start button

;team variables (tmstruct / AwShots = the home / away team struct)
tmshots equ $0						;shots stat
tmPwrGoals equ $2					;power play goals stat
tmPwrPlays equ $4					;power plays stat
tmPenalties equ $6					;penalties stat
tmPenmin equ $8						;penalty min. stat
tmATOP equ $A						;attack time of possesion stat
tmscore equ $C						;score
tmfowon equ $E						;face-offs won stat
tmchecks equ $10					;checks stat
tmpasses equ $12					;passes stat
tmpasscomp equ $14					;completed passes stat
tmline equ $16						;current line
tmtouch1 equ $18					;last touch (team/pnum word): the scorer
tmtouch2 equ $1A					;second last touch (first assist)
tmtouch3 equ $1C					;third last touch (second assist)
tmdata equ $1E						;team data address
tmsort equ $22						;address of first sort obj (word)
tmap equ $24						;active players on ice 4-6
tmgoalie equ $26					;goalie 1/2/none
tmteam equ $28						;team number (TeamList index) of this team struct
tmnear equ $2A						;long: nearest skater's distance^2 to the puck (assnearest)
tmlcchoice equ $2E					;line change box row chosen (0-2)
tmflags equ $30						;flags
tmpde equ $32						;energy level of each roster player
tmpdst equ $66						;-2=bench/-1=ice/0+=penalty box
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

;game structure variables (one per playoff matchup, gsstruct)
gst1 equ $0							;team 1
gst2 equ $2							;team 2
gspotwins equ $4					;play off top team (on tree) wins (for best of 7)
gspobwins equ $6					;play off bottom team (on tree) wins (for best of 7)
gsper equ $8						;period
gss1 equ $A							;team 1 score
gss2 equ $C							;team 2 score
gsflags equ $E						;flags
gssize equ $10

;replay camera struct (CameraPosStruct, 93 name): stands in for a sort object, Xpos / Ypos
;are its position (UpdateCameraPos). It is really 14 words: camtrack and camidle lie past the 11
;words 93 reserved for it and overlap replayactive (camtrack is the replayactive word)
camtrack equ $16					;SCnum of the object tracked in replay
camidle equ $18						;$FF while the replay d-pad is idle, cleared on scroll/track (never read)
;JIM graphics files
jimtiles equ $A						;header size: the tile data starts here
; ----------------------------------

;text control codes in Strings
;print / printz / printbig / printbigz: a negative byte -(TXPRI+TXPALn+TXVF+TXHF+TXMAPn), then x, y (printa =
;the bits << 9, printm = map)
TXMAP1 equ 1						;plane map 1
TXMAP2 equ 2
TXMAP3 equ 3
TXHF equ 4							;h flip
TXVF equ 8							;v flip
TXPAL1 equ $10						;palette 1
TXPAL2 equ $20
TXPAL3 equ $30
TXPRI equ $40						;high priority
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

;game sound effect numbers (sfx / song argument). 95 maps them through SfxTable
SFXsiren equ $0
SFXbeep1 equ $1
SFXbeep2 equ $2
SFXwhistle equ $3
SFXhorn equ $4
SFXshotwiff equ $5
SFXstdef equ $6
SFXpuckget equ $7
SFXoooh equ $8
SFXhithigh equ $9
SFXhitlow equ $A
SFXcrowdcheer equ $B
SFXcrowdboo equ $C
SFXoooh2 equ $D
SFXbglass equ $E
SFXhomewin equ $F					;home team won
SFXpass equ $10						;4 variants, +0-3
SFXshotbh equ $14					;+0-3
SFXshotfh equ $18					;+0-3
SFXcheck equ $1C					;+0-3
SFXplayerwall equ $20
SFXplayerwall2 equ $21
SFXplayerwall3 equ $22
SFXplayerwall4 equ $23
SFXpuckbody equ $24
SFXpuckpost equ $25
SFX26 equ $26
SFX27 equ $27
SFXpuckwall1 equ $28				;+0-3
SFXpuckwall2 equ $29				;medium (92 SFXpuckwall2)
SFXpuckwall3 equ $2A				;soft (92 SFXpuckwall3)
SFXpuckwall4 equ $2B				;softest (new in 93)
SFXpuckice equ $2C					;+0-3
;song numbers
SngTitle equ $78
SngEOP equ $79
SngScouting equ $7A


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
; NumTeams includes the two all-star teams, which stay last. NumPlayoffTeams is the first
; all-star number: a new playoff team is inserted before ASE and both all-star numbers move up.
NumTeams equ ASW+1
NumPlayoffTeams equ ASE
Playerdata equ 0					;team block offset words (teamdata94): players
Palettedata equ 2					;home and visitor palettes
Teamname equ 4						;city, abbreviation, nickname and arena strings
LineSets equ 6						;line sets (92 8)
ScoutReport equ 8					;scouting report bytes, .sr (92 6)
GoalieOdds equ 10					;starting goalie weights, .godds (new in 94)
; Roster slots per team (skaters in card lists, three-stars tables, etc.), not the league count.
RosterSlots equ 26
PlayoffRows equ 32
PlayoffRowTeams equ 16
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
; Record and field offsets (docs: NHLPA93Genesis docs/file-formats.md for the containers and sprite entries)
; .map.jim / .anim container header
jimpalette equ 0					;long: offset of the palette ($FFFFFFFF none)
jimdata equ 4						;long: offset of the map (.map.jim) or the frame table (.anim)
jimtilecount equ 8					;word: tile count (bit 15 packed); the tiles follow (jimtiles)
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
; .pld player ratings: 8 bytes after each player's name String (92 setplayer field names; the
; teamdata94.asm legend letters in brackets; goalies use the low nibbles for saves)
pldnum equ 0						;byte: jersey number, 2 BCD digits (un) -> rostnum
pldweight equ 1						;high nibble weight, low nibble leg power legstr (wl)
pldlegspd equ 2						;high nibble speed legspd, low nibble offense aioff (so)
pldaidef equ 3						;high nibble defense aidef, low nibble shot power shotspd (dp)
pldcheck equ 4						;high nibble checking, bit 0 handed, bits 1-3 fighting (ch)
pldstick equ 5						;high nibble stickhandling stickhand, low nibble shot accuracy (ga)
pldendur equ 6						;high nibble endurance, low nibble shoot / pass odds spodds (ey)
pldpass equ 7						;high nibble passing passacc, low nibble aggression aggress (tm)
pldsize equ 8
; fofdata2 / fofdata: big faceoff sprites (4 bytes each: home center, visiting center, then fofdata = the ref)
foframe equ 0						;word: frame
foattr equ 2						;word: attribute (bit 11 x flip)
fosize equ 4
; PlList: 6 wanted roster players, then their positions
plpos equ 6
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
