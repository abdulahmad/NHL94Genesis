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
tmgoalie	set	$28			;goalie 1/2/none: $28 on the disc, $26 on the cartridge
pldsize		equ	8

; routines of the cartridge that HOCKEY.BIN calls at these addresses

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
picturebuf	equ	$1A8C0
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
CC_Font1Pal3	equ	$CF
CC_Font2Pal3	equ	$CE
CC_Font3Pal3	equ	$CD
CC_Font1Pri	equ	$BF
CC_Font2Pri	equ	$BE
CC_Font3Pri	equ	$BD
CC_Font2Pal2Pri	equ	$9E
CC_Font1Pal3Pri	equ	$8F
CC_Font2Pal3Pri	equ	$8E
CC_Font3Pal3Pri	equ	$8D

; --- variables named from the cartridge twin of each routine (tools/segcd_ramnames.py) ---
replayend	equ	$173B0			;end of the replay frames (replaysize bytes each);
fodropx	equ	$1746C			;face off drop spot x/y
fodropy	equ	$1746E			;face off drop spot y (see fodropx)
recbpr	equ	$17470			;replay record buffer pointer: the frame being recorded
OldVcount	equ	$17476			;Vcount at the last game frame: the frame loop waits d7 frames from it
repeatdelayframes	equ	$17478			;frames until the menu cursor repeats (first delay $F, then 4)
lldisp	equ	$1747C			;line level disp update counter
periodendtime	equ	$1747E			;CheckLateGameSong trigger time.
SortCords	equ	$17480			;sort objects, SCstruct bytes each (93G); the puck is object puckscnum
puckx	equ	$17B80			;puck x position in its sort object (93G)
pucky	equ	$17B94			;puck y position
puckz	equ	$17B98			;puck height above the ice
puckvx	equ	$17BA8			;puck x velocity
puckvy	equ	$17BAA			;puck y velocity
puckvz	equ	$17BAC			;puck z velocity
puckc	equ	$17BE0			;puck carrier (93G: the newpos slot of the puck object)
Ylist	equ	$17C80			;list of y cords for each sortobj
OOlist	equ	$17CC0			;object order list for sort objs
CwdExciteLvl	equ	$17CD8			;crowd excitement level (starts at gamelevel*16, +$1E on an injury, +$28
MaxCwdExciteLvl	equ	$17CDA			;peak crowd level.
Zamx	equ	$17CE2			;zamboni x cord
playoffspritex	equ	$17CE4			;logo sprite x (title / playoff screens).
Vpos	equ	$17CEA			;ice rink vertical position
Oldrow	equ	$17CEC			;last row (used in vertical scrolling of the map data)
Hpos	equ	$17CEE			;ice rink horizontal position
Hscroll	equ	$17CF0			;horizontal scroll value
Vscroll	equ	$17CF2			;vertical scroll value
wcradiusx	equ	$17CF4			;variables used in wall collisions
wcradiusy	equ	$17CF6			;wall collision radius y (see wcradiusx)
PadControlBits	equ	$17DC8			;pad assignment bits ($FFFF = no assignments, set at game setup)
padcont	equ	$17DCA			;pad assignment data (4 words), cleared together with PadControlBits
PadControlBits34	equ	$17DD6			;as PadControlBits, for pads 3 and 4 (4 way play)
shotplayer	equ	$17E28			;player who shot last
lastplayer	equ	$17E2A			;last player who touched puck
passdir	equ	$17E2C			;direction for pass/shot
passspeed	equ	$17E2E			;speed of pass/shot
passReceiverPlayerNum	equ	$17E30			;SCnum of the intended receiver of the last pass, -1 = none (94 had
glovecords	equ	$17E32			;cordinates of glove/sticks (fighting)
lj1	equ	$17E3E			;used in joystick debounce
lj2	equ	$17E40			;joystick debounce for pad 2 (see lj1)
lj3	equ	$17E42			;controller 3 joystick state
lj4	equ	$17E44			;controller 4 joystick state
bholdtimer	equ	$17E56			;B button hold timers of pads 1 / 2 (one byte each); bholdtimer34 for pads
bholdtimer34	equ	$17E58			;B button hold timers, controllers 3 and 4
padword3	equ	$17E5A			;controller 3 pad word
padword4	equ	$17E5C			;controller 4 pad word
padword1	equ	$17E5E			;a pad 1 word swapped with padword3 for 4 way play (updateplayers)
padword2	equ	$17E60			;a pad 2 word swapped with padword4 for 4 way play (updateplayers)
TempWord1	equ	$17E62			;a scratch word (hot / cold totals, record page, button direction ...)
TempMaxSpd	equ	$17E68			;temporary: maximum speed
TempEnergySpd	equ	$17E6C			;temporary: speed after energy
awayhotidx	equ	$17EA4			;away team hot player index
homehotidx	equ	$17EA6			;home team hot player index
awaycoldidx	equ	$17EA8			;away team cold player index
homecoldidx	equ	$17EAA			;home team cold player index
awayhotplayer	equ	$17EAC			;the away team's hottest starter (BuildHotColdLists)
homehotplayer	equ	$17EAE			;the home team's hottest starter
awaycoldplayer	equ	$17EB0			;the away team's coldest starter
homecoldplayer	equ	$17EB2			;the home team's coldest starter
onetimerplayer	equ	$17EBC			;player taking a one timer
onetimerflags	equ	$17EC6			;one timer flags
ltplayer	equ	$17EC8			;last touch player
ltx	equ	$17ECA			;last touch x cord
lty	equ	$17ECC			;last touch y cord
iflags	equ	$17ECE			;icing
icingPlayer	equ	$17ECF			;icing: the SCnum+1 of the last player to touch the puck (iflags+1), then
xc1	equ	$17EDC			;scroll lock x cord
yc1	equ	$17EDE			;scroll lock y cord
yleader	equ	$17EE0			;lead distance on scrolling
fox	equ	$17EE2			;faceoff spot x/y
foy	equ	$17EE4			;face off spot y (see fox)
deltax	equ	$17EEA			;used lots of places for x/y stuff
deltay	equ	$17EEC			;y difference, used in many places (see deltax)
collflag	equ	$17EEE			;collision has occured
evalue	equ	$17EF0			;elasticity value (parameter of collisions)
redrawicons	equ	$17F60			;DrawLineIcons: last icon group drawn ($FF = redraw).
ltack	equ	$17F62			;last tackle sound.
Sattsize	equ	$17F66			;size of transfer
gmode	equ	$17F68			;game mode flag
sflags	equ	$17F6A			;game state flags
sflags2	equ	$17F6C			;game state flags, second word
sflags3	equ	$17F6E			;game state flags, third word
BA_PS_flags	equ	$17F70			;breakaway / penalty shot / shootout flags (94)
sflags5	equ	$17F74			;94 flag word: crowd noise on (bit 7), menu handler keeps its screen (bit
gmode2	equ	$17F78			;94 game mode word, beside gmode: shootout (bit 0), shootout skater has
sflags7	equ	$17F7A			;94 flag byte: arena faceoff animation (bit 0), injury (bit 5), crowd
sflags8	equ	$17F7C			;94 flag byte: penalty shot / shootout and one-timer bits
DelayedPen	equ	$17F7E			;delayed penalty (94): bit 0 PP goal, bit 1 home, bit 2 away
crowdnoisedelay	equ	$17F82			;frames until the next crowd noise
CwdChkCntr	equ	$17F84			;Crowd meter frame counter
CurCrowdMeter	equ	$17F8C			;current crowd meter level
CrowdRecord	equ	$17F8E			;The crowd record threshold
CrowdAvg	equ	$17F90			;Crowd noise off level
CrowdPeak	equ	$17F92			;The crowd peak of the game
pausepad	equ	$17F94			;pad that paused the game
joypuckcarrier	equ	$17F96			;player with the puck controlled by the joypad
msgtimer	equ	$17F98			;on screen message timer
passmodetimer	equ	$17F9A			;pass mode timer
savednewpnum	equ	$17F9C			;saved new player number
c1playernum	equ	$17F9E			;player in control or neg for none
c2playernum	equ	$17FA0			;player controlled by pad 2, negative = none (see c1playernum)
c3playernum	equ	$17FA2			;controller 3 player number
c4playernum	equ	$17FA4			;controller 4 player number
cont1team	equ	$17FA6			;cont1 team 0=none 1=team1 2=team2
cont2team	equ	$17FA8			;team of controller 2: 0 = none (see cont1team)
cont3team	equ	$17FAA			;team of controller 3
cont4team	equ	$17FAC			;team of controller 4
PenCntDwn	equ	$18064			;frames until the penalty or stoppage message ends (fights 60, an injury
Penaltytimer	equ	$18066			;counts down the second for the penalty clocks (jps frames)
PBnum	equ	$18068			;$HV00 h=home players in pb
penmsgtimer	equ	$1806C			;penalty message timer
RefCnt	equ	$1806E			;ref graphics control
RefStep	equ	$18070			;ref animation step: word offset into the ref frames, -1 = ref idle
RefPen	equ	$18072			;penalty number the ref is calling (4 = game over)
gsp	equ	$180E4			;game period
gameclock	equ	$180E6			;game clock
PerTimeTotal	equ	$180EA			;total time of the period
TempPlOffset	equ	$180EE			;roster offset of the player to print (bit 15 =
ScoreSumbytes	equ	$180F0			;bytes used in ScoreSum (6 per goal)
PenSumLength	equ	$1825A			;bytes used in PenSum (4 per penalty).
HmGoals	equ	$18358			;home score
AwGoals	equ	$186BE			;away score
gamenum	equ	$18A98			;index for current game in game struct
postarts	equ	$18A9A			;0-31 for which playoff tree to use as frame
bosgames	equ	$18A9C			;0-6 game of series or 7 if not in best of seven
gamelevel	equ	$18A9E			;0-3 for the depth into the play off tree
potreeteam	equ	$18AA0			;which team you are on the intial playoff tree
pojoy	equ	$18AA2			;playoff joystick indicator
WinBits	equ	$18AA4			;bits which indicat the continuing teams on the playoff tree
menuitem	equ	$18AD2			;menu state: selected item, then (+2) first item shown
menulist	equ	$18AD6			;menu item list.
menudraw	equ	$18ADA			;menu screen draw routine.
TickerNum	equ	$18ADE			;intermission ticker: index of the game being shown, negative = no more
remapTablePtr	equ	$18AE4			;remap table for DecompressGraphicsWithRemap; 0 = plain DMA
nibblebuffer	equ	$18BE8			;UnpackNibbles words, WeightedRandomSelect weights.
homeuser	equ	$18BF4			;home team user controller
awayuser	equ	$18BF6			;away team user controller
FourWayPlay	equ	$18BF8			;EA 4 Way Play adaptor present (Detect4WayPlay). With the Opt* setup
OptPlayMode	equ	$18BFA			;play mode
Opt1team	equ	$18BFE			;team 1
Opt2team	equ	$18C00			;team 2
OptGoalie	equ	$18C04			;option: goalie
OptUserRec	equ	$18C06			;option: user records
OptPen	equ	$18C08			;penalties 1 for off
OptLine	equ	$18C0A			;line changes option
goaliemode1	equ	$18C0C			;goalie mode, home
goaliemode2	equ	$18C0E			;goalie mode, away
TmpOptUserRec	equ	$18C10			;temporary option: user records
TmpOptPen	equ	$18C12			;temporary option: penalties
TmpOptLine	equ	$18C14			;temporary option: line changes
demoflag	equ	$18C16			;demo flag
seed	equ	$18C18			;seed for the random number generator
PalMode	equ	$18C20			;Rev A only: VDP PAL bit (Begin). Set = 50 Hz: faster skating
TempOptPlayMode	equ	$18C24			;temporary option: play mode
VSCRLPM	equ	$18D30			;location in vram of scroll parameters
VSPRITES	equ	$18D32			;location in vram of sprite attributes
VmMAP2	equ	$18D38			;location in vram of playfield 2
smallfontchars	equ	$18D42			;vram tiles for SmallFont.map
rinkvrcset	equ	$18D48			;vram tiles for IceRink.map
basetileoffset	equ	$18D52			;vram char of the home team block tiles; the visitor block is at +$18
ExtraChars	equ	$18D56			;vram tiles for extra graphics
printm	equ	$18D5E			;map to use (0 = map 1, 4 = map 2, 8 = map 3)
DMAList	equ	$18D6A			;dma transfer list
DMAlistend	equ	$191CA			;end of the DMA list: where the next entry is written
BA_Team	equ	$19366			;breakaway / penalty shot / shootout: which team (with BA_PS_flags)
BA_Sktr_SCnum	equ	$19368			;SCnum of the breakaway / penalty-shot / shootout skater
BA_Goalie_SCnum	equ	$1936A			;SCnum of that play's goalie
BA_Skater_Offset	equ	$1936C			;that skater's team position offset
holdreset	equ	$19374			;hold reset countdown
onetimertargetx	equ	$19376			;one timer target x
onetimertargety	equ	$19378			;one timer target y
onetimerheight	equ	$1937A			;one timer puck height
FallXPos	equ	$1937E			;falling player x position
aholdtimer	equ	$19380			;A button hold timers of pads 1 / 2 (one byte each); aholdtimer34 for pads
aholdtimer34	equ	$19382			;A button hold timers, controllers 3 and 4
setupfirstline	equ	$19384			;setup screen: first line shown
setupprevline	equ	$19386			;setup screen: previous line
logoteam	equ	$1938A			;team whose logo is shown
setuphome	equ	$1938C			;setup screen: home team
setupvis	equ	$1938E			;setup screen: visiting team
setupcardflags	equ	$19390			;setup screen: player card flags
cardroster	equ	$19396			;player card: roster
cardtimer	equ	$1939E			;player card timer
featuredplayer	equ	$193A0			;featured player
carddelay	equ	$193A2			;player card delay
cardprintx	equ	$193A4			;player card print x
cardprinty	equ	$193A6			;player card print y
cardteamnum	equ	$193A8			;player card team number
shootoutclock	equ	$193B6			;The shootout clock
ValidSRAM	equ	$193BA			;nonzero when the save RAM is valid
namelog	equ	$1A2FC			;the user name log: $80 bytes from save RAM NameLogBase (NameLogIO),
nameentrybuf	equ	$1A37C			;name entry buffer
namelength	equ	$1A38A			;length of the name being entered
namelogsel	equ	$1A38C			;selected name log entry
nameentryvis	equ	$1A390			;name entry cursor visible
winpcts	equ	$1A3EC			;the win % byte of each of the 8 records (CalcWinPercents)
winties	equ	$1A3F4			;the ties word of each record (record bytes $C-$D)
wingames	equ	$1A404			;the games word of each record (record bytes $A-$B)
homeshootgoals	equ	$1A416			;Shootout goals, home
awayshootgoals	equ	$1A418			;Shootout goals, away
shootoutround	equ	$1A41A			;Shootout round
homeshooters	equ	$1A41C			;the home shootout shooter list (6 words, homeshootnum the index)
homeshootnum	equ	$1A428			;The shooter index of the shootout
awayshooters	equ	$1A42A			;the away shootout shooter list (6 words)
shootoutteam	equ	$1A436			;Shootout: 0 home shoots, 1 away
arenaanimchars	equ	$1A54E			;arena animation characters
arenaframe	equ	$1A550			;arena animation frame
arenaframeidx	equ	$1A552			;arena animation frame index
arenaframetime	equ	$1A554			;arena animation frame time
arenaanim	equ	$1A556			;arena animation
arenaframelist	equ	$1A558			;arena animation frame list pointer
arenaspritelist	equ	$1A55C			;arena sprite list pointer
cursoron	equ	$1A566			;cursor visible
SongNum	equ	$1A56A			;current song number
HmTeam	equ	$1A56C			;home team
SongIndex	equ	$1A56E			;song index
OvrDivisor	equ	$1A570			;overall rating divisor
OvrDividend	equ	$1A572			;overall rating dividend
homehotcoldsave	equ	$1A574			;clearTeamStats keeps the home hot / cold table (tmstruct+tmHotCold)
awayhotcoldsave	equ	$1A714			;the same for the awtmstruct table
sopath	equ	$1A8B4			;shootout path
sopathpoint	equ	$1A8B6			;shootout path point
sopathx	equ	$1A8B8			;shootout path x
sopathdir	equ	$1A8BC			;passdir at the end of the shootout path
PuckZCntr	equ	$1AD74			;Frames the puck has hung at one height
TmpPuckZ	equ	$1AD78			;puckz last frame
inputjoy	equ	$1AD7A			;joypad input
TmpJoyPuckCarrier	equ	$1AD7C			;temporary joypad puck carrier
PlayerChked	equ	$1AD7E			;player being checked
PlayerChking	equ	$1AD82			;player checking
iconplayer	equ	$1AD8A			;icon player
iconx	equ	$1AD8C			;icon x position
replaydelay	equ	$1AD92			;replay delay

; --- variables named from the cartridge twin of each routine (tools/segcd_ramnames.py) ---
puck_pflags2	equ	$17BE3			;puck object pflags2
OOlistpos	equ	$17CA0			;objects pos in OOlist
SumCwdExciteLvl	equ	$17CDE			;crowd level running total.
playoffspritey	equ	$17CE6			;logo sprite y.
fofdata2	equ	$17CF8			;faceoff sprite data, second set
fofdata	equ	$17D00			;data for frame/att of big face off sprites
threat	equ	$17E34			;direction of threat on puck handler
PadRaw1	equ	$17E46			;Rev B: controller 1 as read by ReadPads in the vblank (active low)
PadRaw2	equ	$17E47			;Rev B: controller 2 (ReadJoy1/ReadJoy2 only translate these)
PadRaw3	equ	$17E48			;controller 3 raw pad byte
PadRaw4	equ	$17E49			;controller 4 raw pad byte
TempWord2	equ	$17E64			;a scratch word (hot / cold totals, attribute number, credits step ...)
TempRawSpd	equ	$17E66			;temporary: raw speed
setupfontchars	equ	$17EA2			;first font character of the setup screens
fodir1	equ	$17EE6			;pull directions for each player on face off
fodir2	equ	$17EE8			;pull direction for the visiting player on the face off (see fodir1)
Teamblocksmap	equ	$17FB2			;
PenBuf	equ	$18022			;upto x penalties saved
Optperlen	equ	$18C02			;period length index.
TmpOptLine2	equ	$18C22			;temporary option: line changes, second
passbits	equ	$18C38			;playoff password bits (94 had pwddatabuffer)
VmMAP3	equ	$18D3C			;location in vram of playfield 3
Map3col	equ	$18D3E			;2 to this power = width in char of playfield 3
crowdvrcset	equ	$18D4A			;94 keeps the crowd tiles 1st vram char here
faceoffvrcset	equ	$18D4C			;vram tiles for FaceOff graphics
EASNcset	equ	$18D50			;vram tiles for EASN.map
spritechars	equ	$18D54			;vram tiles for the sprites.
BA_Goalie_Offset	equ	$1936E			;that goalie's team position offset
BA_Checker_Offset	equ	$19370			;the checker's team position offset (penalty shot)
pspenalty	equ	$19372			;penalty summary: penalty number
FallYPos	equ	$1937C			;falling player y position
setupmenuchars	equ	$19388			;setup screen: menu character base
teambitmapchars	equ	$1939C			;team bitmap characters
namelogarrows	equ	$1A38E			;Name entry: the name log row with the arrows
recsort1	equ	$1A3D4			;Record Holders row order sorted on record byte 0 (ReadTeamRecords), read
recsort2	equ	$1A3DC			;Record Holders row order sorted on record byte 4 (ReadTeamRecords,
winsort	equ	$1A3E4			;Record Holders win row order (CalcWinPercents), read by PrintWinRecords
faceoffanim	equ	$1A560			;faceoff animation state
facelcwait	equ	$1A568			;wait value, set to $FFFF by the logic
sopathy	equ	$1A8BA			;shootout path y
sopathend	equ	$1A8BE			;shootout path end
picturebits	equ	$1AD42			;UnpackPicture: the 3 packed bytes of the row being unpacked
lognametext	equ	$1AD5C			;the unused TerminateLogName's GetLogName String text (length word at -2)
songdelay	equ	$1AD6E			;frames until the delayed song starts
delayedsong	equ	$1AD70			;song waiting to start
shootoutdelay	equ	$1AD72			;Frames before the shootout ends

; --- variables named from the cartridge twin of each routine (tools/segcd_ramnames.py) ---
NumCwdExciteLvl	equ	$17CDC			;crowd level sample count.
pads	equ	$17D04			;face-off ice pad object (93 pads object 0). Not joypads
Joy1Struct	equ	$17D20			;controller 1 and 2 arrow objects (93 pads+ffosize, two ffo)
CameraPosStruct	equ	$17D58			;scroll camera: tracked object, target and the lead on the scroll
replayactive	equ	$17D6E			;set by ReplayMode.
Joy3Struct	equ	$17D74			;controller 3 arrow object (4 Way Play; 93 had glovestruct here)
Joy4Struct	equ	$17D90			;controller 4 arrow object (4 Way Play)
glovestruct	equ	$17DAC			;gloves object, pads+(4*ffosize).
sso	equ	$17DD8			;screen objects not tied to the rink scroll: 2 arrows for off screen
puckcross	equ	$17E36			;xcord / frames, top entry then bottom (93G rs.w 4)
TempLegSpd	equ	$17E6E			;temporary: leg speed
scorergoalies	equ	$17E98			;first goalie slot of the scoring team (scorer check in setup)
recties	equ	$17E9A			;team record: ties
reclosses	equ	$17E9C			;team record: losses
recwins	equ	$17E9E			;team record: wins
ChkBodyG	equ	$17EB4			;body check strength of the goalie
ChkBodySqG	equ	$17EB6			;body check strength squared, goalie
NegChkBodyG	equ	$17EBA			;negated body check strength of the goalie
onetimerclock	equ	$17EBE			;one timer timing clocks
clockram	equ	$17ED4			;ram for dma transfer of clock digits
PushWidthBuf	equ	$17F56			;PushNumberWidth string: length word, then digits.
PushNumberBuf	equ	$17F5E			;PushNumber builds its string down from here.
sflags4	equ	$17F72			;94 flag word: reverse angle replay (bits 4, 6, 7), slot, penalty shot
CwdChkCnt	equ	$17F86			;Crowd meter update count
InjCntDown	equ	$1806A			;frames until the injury box is shown after an injury
RefRamMap	equ	$18074			;ref cam map words (refwidth x refheight)
ChkCnt	equ	$180EC			;check counter for the player check stat
ScoreSum	equ	$180F2			;scoring summary: 6 bytes per goal (scorer, assists, time)
PenSum	equ	$1825C			;penalty summary log, 4 bytes per penalty.
potree	equ	$18AA6			;team in the tree
PlList	equ	$18AC6			;list of players used differently
PPBonus	equ	$18AE0			;check bonuses, cleared together by clr.l.
PKBonus	equ	$18AE1			;penalty kill bonus
ThirdPBonus	equ	$18AE2			;third period bonus
HmAwBonus	equ	$18AE3			;home / visitor bonus
dmaram	equ	$18C1C			;dma ram area.
databuffer	equ	$18C26			;scratch data buffer
energybarchars	equ	$18D46			;vram tiles for the energy bar
logobox1chars	equ	$19398			;logo box 1 characters
logobox2chars	equ	$1939A			;logo box 2 characters
homegoalies	equ	$193AA			;home team goalies
awaygoalies	equ	$193AC			;away team goalies
homeplayers	equ	$193AE			;Players of the home team (CountPlayers)
awayplayers	equ	$193B0			;Players of the away team (CountPlayers)
shootoutjiffy	equ	$193B8			;shootout frame counter
nameframechars	equ	$1A3D2			;Name entry frame chars (NameEntryFramer)
shootoutstate	equ	$1A414			;first of the 19 words ClearGameStats clears (shootout
homepresses	equ	$1AD46			;home team button presses
homedirpresses	equ	$1AD4A			;home team direction presses
awaypresses	equ	$1AD4E			;away team button presses
awaydirpresses	equ	$1AD52			;away team direction presses
replayicontimer	equ	$1AD56			;replay icon timer
TmpPuckX	equ	$1AD58			;temporary puck x
DiscDmaListPtr	equ	$19360			;pointer to the end of the disc dma/command word list; entries are pushed with -(a6), see DoDMAProQueue
CdCommandArg	equ	$19364			;word argument buffer passed in a0 to the sub CPU call $5F22
MenuScrollTop	equ	$18AD4			;first visible row of a scrolling menu (menuitem - 3 when the selection moves past the bottom row)
PlayerSwitchDelay	equ	$17E57			;frames before the controlled player may switch again, set to $11 when a switch happens
gstruct	equ	$18A18			;game struct array, one entry per game number (cartridge gstruct)
