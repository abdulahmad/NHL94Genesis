; RAM map of HOCKEY.BIN (names the work RAM variables and the addresses the disc code uses). Equates only: it adds
; nothing to the disc image. HOCKEY.BIN is entered at $1B000 and its work RAM is the cartridge's, moved by a different
; amount for each block of variables, so each name carries its own disc address. The variables follow the order and use
; the names and comments of ram94.asm (the cartridge); variables only the disc has come after them.

LOAD		equ	$1B000			;HOCKEY.BIN runtime address = file offset + LOAD. A bsr or bra to a name
						;below is written name-LOAD (orgs are file offsets, operands runtime)

; --- variables the cartridge has, in ram94.asm order ---
VSCRLPM	equ	$18D30			;location in vram of scroll parameters
VSPRITES	equ	$18D32			;location in vram of sprite attributes
VmMAP1	equ	$18D34			;location in vram of playfield 1
Map1col	equ	$18D36			;2 to this power = width in char of playfield 1
VmMAP2	equ	$18D38			;location in vram of playfield 2
Map2col	equ	$18D3A			;2 to this power = width in char of playfield 2
VmMAP3	equ	$18D3C			;location in vram of playfield 3
Map3col	equ	$18D3E			;2 to this power = width in char of playfield 3
BigFontchars	equ	$18D40			;vram tiles for BigFont.map
smallfontchars	equ	$18D42			;vram tiles for SmallFont.map
smallfont2chars	equ	$18D44			;vram tiles for the 2nd small font set.
energybarchars	equ	$18D46			;vram tiles for the energy bar
rinkvrcset	equ	$18D48			;vram tiles for IceRink.map
crowdvrcset	equ	$18D4A			;94 keeps the crowd tiles 1st vram char here
faceoffvrcset	equ	$18D4C			;vram tiles for FaceOff graphics
framercset	equ	$18D4E			;vram tiles for framer.map
EASNcset	equ	$18D50			;vram tiles for EASN.map
basetileoffset	equ	$18D52			;vram char of the home team block tiles; the visitor block is at +$18
spritechars	equ	$18D54			;vram tiles for the sprites.
ExtraChars	equ	$18D56			;vram tiles for extra graphics
printx	equ	$18D58			;x cordinate for printing
printy	equ	$18D5A			;y cordinate for printing
printa	equ	$18D5C			;attribute for print characters
printm	equ	$18D5E			;map to use (0 = map 1, 4 = map 2, 8 = map 3)
printfontset	equ	$18D60			;printsmall char set (index*2 into smallfontchars).
fodropx	equ	$1746C			;face off drop spot x/y
fodropy	equ	$1746E			;face off drop spot y (see fodropx)
recbpr	equ	$17470			;replay record buffer pointer: the frame being recorded
VBint	equ	$18D66			;address of vblank interupt code
Vcount	equ	$17474			;counter for vblank (the disc vblank routines add 1 to it, DoGameFrame reads it)
OldVcount	equ	$17476			;Vcount at the last game frame: the frame loop waits d7 frames from it
repeatdelayframes	equ	$17478			;frames until the menu cursor repeats (first delay $F, then 4)
asv	equ	$1747A			;analog sound volume (crowd noise)
lldisp	equ	$1747C			;line level disp update counter
periodendtime	equ	$1747E			;CheckLateGameSong trigger time.
SortCords	equ	$17480			;sort objects, SCstruct bytes each (93G); the puck is object puckscnum
Ylist	equ	$17C80			;list of y cords for each sortobj
OOlistpos	equ	$17CA0			;objects pos in OOlist
OOlist	equ	$17CC0			;object order list for sort objs
Crowdframe	equ	$17CD0			;current crowd frame number
Crowdlevel	equ	$17CD2			;level of crowd excitement
Crowdstep	equ	$17CD4			;animation step for crowd
Crowdcnt	equ	$17CD6			;count down to next step.
CwdExciteLvl	equ	$17CD8			;crowd excitement level (starts at gamelevel*16, +$1E on an injury, +$28
MaxCwdExciteLvl	equ	$17CDA			;peak crowd level.
NumCwdExciteLvl	equ	$17CDC			;crowd level sample count.
SumCwdExciteLvl	equ	$17CDE			;crowd level running total.
Zamx	equ	$17CE2			;zamboni x cord
playoffspritex	equ	$17CE4			;logo sprite x (title / playoff screens).
playoffspritey	equ	$17CE6			;logo sprite y.
clampcounter	equ	$17CE8			;credits page wait counter (how long the first page stays)
DMAList	equ	$18D6A			;dma transfer list
DMAlistend	equ	$191CA			;end of the DMA list: where the next entry is written
Vpos	equ	$17CEA			;ice rink vertical position
Oldrow	equ	$17CEC			;last row (used in vertical scrolling of the map data)
Hpos	equ	$17CEE			;ice rink horizontal position
Hscroll	equ	$17CF0			;horizontal scroll value
Vscroll	equ	$17CF2			;vertical scroll value
wcradiusx	equ	$17CF4			;variables used in wall collisions
wcradiusy	equ	$17CF6			;wall collision radius y (see wcradiusx)
palcount	equ	$18D62			;counter for fading in color palettes
fofdata2	equ	$17CF8			;faceoff sprite data, second set
fofdata	equ	$17D00			;data for frame/att of big face off sprites
pads	equ	$17D04			;face-off ice pad object (93 pads object 0). Not joypads
Joy1Struct	equ	$17D20			;controller 1 and 2 arrow objects (93 pads+ffosize, two ffo)
CameraPosStruct	equ	$17D58			;scroll camera: tracked object, target and the lead on the scroll
replayactive	equ	$17D6E			;set by ReplayMode.
Joy3Struct	equ	$17D74			;controller 3 arrow object (4 Way Play; 93 had glovestruct here)
Joy4Struct	equ	$17D90			;controller 4 arrow object (4 Way Play)
glovestruct	equ	$17DAC			;gloves object, pads+(4*ffosize).
PadControlBits	equ	$17DC8			;pad assignment bits ($FFFF = no assignments, set at game setup)
padcont	equ	$17DCA			;pad assignment data (4 words), cleared together with PadControlBits
PadControlBits34	equ	$17DD6			;as PadControlBits, for pads 3 and 4 (4 way play)
sso	equ	$17DD8			;screen objects not tied to the rink scroll: 2 arrows for off screen
shotplayer	equ	$17E28			;player who shot last
lastplayer	equ	$17E2A			;last player who touched puck
passdir	equ	$17E2C			;direction for pass/shot
passspeed	equ	$17E2E			;speed of pass/shot
passReceiverPlayerNum	equ	$17E30			;SCnum of the intended receiver of the last pass, -1 = none (94 had
glovecords	equ	$17E32			;cordinates of glove/sticks (fighting)
puckcross2	equ	$17E38			;puckcross top entry frames
puckcross6	equ	$17E3C			;puckcross bottom entry frames
threat	equ	$17E34			;direction of threat on puck handler
puckcross	equ	$17E36			;xcord / frames, top entry then bottom (93G rs.w 4)
lj1	equ	$17E3E			;used in joystick debounce
lj2	equ	$17E40			;joystick debounce for pad 2 (see lj1)
lj3	equ	$17E42			;controller 3 joystick state
lj4	equ	$17E44			;controller 4 joystick state
PadRaw1	equ	$17E46			;Rev B: controller 1 as read by ReadPads in the vblank (active low)
PadRaw2	equ	$17E47			;Rev B: controller 2 (ReadJoy1/ReadJoy2 only translate these)
PadRaw3	equ	$17E48			;controller 3 raw pad byte
PadRaw4	equ	$17E49			;controller 4 raw pad byte
bholdtimer	equ	$17E56			;B button hold timers of pads 1 / 2 (one byte each); bholdtimer34 for pads
bholdtimer34	equ	$17E58			;B button hold timers, controllers 3 and 4
padword3	equ	$17E5A			;controller 3 pad word
padword4	equ	$17E5C			;controller 4 pad word
padword1	equ	$17E5E			;a pad 1 word swapped with padword3 for 4 way play (updateplayers)
padword2	equ	$17E60			;a pad 2 word swapped with padword4 for 4 way play (updateplayers)
TempWord1	equ	$17E62			;a scratch word (hot / cold totals, record page, button direction ...)
TempWord2	equ	$17E64			;a scratch word (hot / cold totals, attribute number, credits step ...)
TempRawSpd	equ	$17E66			;temporary: raw speed
TempMaxSpd	equ	$17E68			;temporary: maximum speed
TempEnergySpd	equ	$17E6C			;temporary: speed after energy
TempLegSpd	equ	$17E6E			;temporary: leg speed
TempBuffer	equ	$17E70			;40 byte scratch buffer: String buffer (AppendNumber, names, "(played by
scorergoalies	equ	$17E98			;first goalie slot of the scoring team (scorer check in setup)
recties	equ	$17E9A			;team record: ties
reclosses	equ	$17E9C			;team record: losses
recwins	equ	$17E9E			;team record: wins
awayhotter	equ	$17EA0			;away team hot player
setupfontchars	equ	$17EA2			;first font character of the setup screens
awayhotidx	equ	$17EA4			;away team hot player index
homehotidx	equ	$17EA6			;home team hot player index
awaycoldidx	equ	$17EA8			;away team cold player index
homecoldidx	equ	$17EAA			;home team cold player index
awayhotplayer	equ	$17EAC			;the away team's hottest starter (BuildHotColdLists)
homehotplayer	equ	$17EAE			;the home team's hottest starter
awaycoldplayer	equ	$17EB0			;the away team's coldest starter
homecoldplayer	equ	$17EB2			;the home team's coldest starter
ChkBodyG	equ	$17EB4			;body check strength of the goalie
ChkBodySqG	equ	$17EB6			;body check strength squared, goalie
NegChkBodyG	equ	$17EBA			;negated body check strength of the goalie
onetimerplayer	equ	$17EBC			;player taking a one timer
onetimerclock	equ	$17EBE			;one timer timing clocks
onetimerflags	equ	$17EC6			;one timer flags
disflags	equ	$18D64			;display flags
ltplayer	equ	$17EC8			;last touch player
ltx	equ	$17ECA			;last touch x cord
lty	equ	$17ECC			;last touch y cord
iflags	equ	$17ECE			;icing
icingPlayer	equ	$17ECF			;icing: the SCnum+1 of the last player to touch the puck (iflags+1), then
clockram	equ	$17ED4			;ram for dma transfer of clock digits
xc1	equ	$17EDC			;scroll lock x cord
yc1	equ	$17EDE			;scroll lock y cord
yleader	equ	$17EE0			;lead distance on scrolling
fox	equ	$17EE2			;faceoff spot x/y
foy	equ	$17EE4			;face off spot y (see fox)
fodir1	equ	$17EE6			;pull directions for each player on face off
fodir2	equ	$17EE8			;pull direction for the visiting player on the face off (see fodir1)
deltax	equ	$17EEA			;used lots of places for x/y stuff
deltay	equ	$17EEC			;y difference, used in many places (see deltax)
collflag	equ	$17EEE			;collision has occured
evalue	equ	$17EF0			;elasticity value (parameter of collisions)
mesarea	equ	$17EF2			;temp area for mes chars
TextBuffer	equ	$17EF4			;to mesarea+100
PushWidthBuf	equ	$17F56			;PushNumberWidth string: length word, then digits.
PushNumberBuf	equ	$17F5E			;PushNumber builds its string down from here.
redrawicons	equ	$17F60			;DrawLineIcons: last icon group drawn ($FF = redraw).
ltack	equ	$17F62			;last tackle sound.
lastsfx	equ	$17F64			;last sound played
Sattsize	equ	$17F66			;size of transfer
gmode	equ	$17F68			;game mode flag
sflags	equ	$17F6A			;game state flags
sflags2	equ	$17F6C			;game state flags, second word
sflags3	equ	$17F6E			;game state flags, third word
BA_PS_flags	equ	$17F70			;breakaway / penalty shot / shootout flags (94)
sflags4	equ	$17F72			;94 flag word: reverse angle replay (bits 4, 6, 7), slot, penalty shot
sflags5	equ	$17F74			;94 flag word: crowd noise on (bit 7), menu handler keeps its screen (bit
sflags6	equ	$17F76			;94 flag word: one-timer (bits 1, 2), slot (bit 5), save RAM write (bit
gmode2	equ	$17F78			;94 game mode word, beside gmode: shootout (bit 0), shootout skater has
sflags7	equ	$17F7A			;94 flag byte: arena faceoff animation (bit 0), injury (bit 5), crowd
sflags8	equ	$17F7C			;94 flag byte: penalty shot / shootout and one-timer bits
DelayedPen	equ	$17F7E			;delayed penalty (94): bit 0 PP goal, bit 1 home, bit 2 away
crowdnoisedelay	equ	$17F82			;frames until the next crowd noise
CwdChkCntr	equ	$17F84			;Crowd meter frame counter
CwdChkCnt	equ	$17F86			;Crowd meter update count
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
HomeTeam	equ	$17FAE			;number 0-24
VisTeam	equ	$17FB0			;visiting team number (0-24, see HomeTeam)
PenBuf	equ	$18022			;upto x penalties saved
PenCntDwn	equ	$18064			;frames until the penalty or stoppage message ends (fights 60, an injury
Penaltytimer	equ	$18066			;counts down the second for the penalty clocks (jps frames)
PBnum	equ	$18068			;$HV00 h=home players in pb
InjCntDown	equ	$1806A			;frames until the injury box is shown after an injury
penmsgtimer	equ	$1806C			;penalty message timer
RefCnt	equ	$1806E			;ref graphics control
RefStep	equ	$18070			;ref animation step: word offset into the ref frames, -1 = ref idle
RefPen	equ	$18072			;penalty number the ref is calling (4 = game over)
RefRamMap	equ	$18074			;ref cam map words (refwidth x refheight)
gsp	equ	$180E4			;game period
gameclock	equ	$180E6			;game clock
PerTimeTotal	equ	$180EA			;total time of the period
ChkCnt	equ	$180EC			;check counter for the player check stat
TempPlOffset	equ	$180EE			;roster offset of the player to print (bit 15 =
ScoreSumbytes	equ	$180F0			;bytes used in ScoreSum (6 per goal)
ScoreSum	equ	$180F2			;scoring summary: 6 bytes per goal (scorer, assists, time)
PenSumLength	equ	$1825A			;bytes used in PenSum (4 per penalty).
PenSum	equ	$1825C			;penalty summary log, 4 bytes per penalty.
tmstruct	equ	$1834C			;home team struct (93G)
awtmstruct	equ	$186B2			;away team struct (first field tmshots)
gstruct	equ	$18A18			;8 game structures
gamenum	equ	$18A98			;index for current game in game struct
postarts	equ	$18A9A			;0-31 for which playoff tree to use as frame
bosgames	equ	$18A9C			;0-6 game of series or 7 if not in best of seven
gamelevel	equ	$18A9E			;0-3 for the depth into the play off tree
potreeteam	equ	$18AA0			;which team you are on the intial playoff tree
pojoy	equ	$18AA2			;playoff joystick indicator
WinBits	equ	$18AA4			;bits which indicat the continuing teams on the playoff tree
potree	equ	$18AA6			;team in the tree
PlList	equ	$18AC6			;list of players used differently
menuitem	equ	$18AD2			;menu state: selected item, then (+2) first item shown
menulist	equ	$18AD6			;menu item list.
menudraw	equ	$18ADA			;menu screen draw routine.
TickerNum	equ	$18ADE			;intermission ticker: index of the game being shown, negative = no more
PPBonus	equ	$18AE0			;check bonuses, cleared together by clr.l.
PKBonus	equ	$18AE1			;penalty kill bonus
ThirdPBonus	equ	$18AE2			;third period bonus
HmAwBonus	equ	$18AE3			;home / visitor bonus
remapTablePtr	equ	$18AE4			;remap table for DecompressGraphicsWithRemap; 0 = plain DMA
nibblebuffer	equ	$18BE8			;UnpackNibbles words, WeightedRandomSelect weights.
homeuser	equ	$18BF4			;home team user controller
awayuser	equ	$18BF6			;away team user controller
FourWayPlay	equ	$18BF8			;EA 4 Way Play adaptor present (Detect4WayPlay). With the Opt* setup
OptPlayMode	equ	$18BFA			;play mode
OptNOP	equ	$18BFC			;number of players
Opt1team	equ	$18BFE			;team 1
Opt2team	equ	$18C00			;team 2
Optperlen	equ	$18C02			;period length index.
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
dmaram	equ	$18C1C			;dma ram area.
PalMode	equ	$18C20			;Rev A only: VDP PAL bit (Begin). Set = 50 Hz: faster skating
TmpOptLine2	equ	$18C22			;temporary option: line changes, second
TempOptPlayMode	equ	$18C24			;temporary option: play mode
databuffer	equ	$18C26			;scratch data buffer
passbits	equ	$18C38			;playoff password bits (94 had pwddatabuffer)
BA_Team	equ	$19366			;breakaway / penalty shot / shootout: which team (with BA_PS_flags)
BackupRamImage	equ	$193BC			;disc only: the $F20-byte backup RAM image
BA_Sktr_SCnum	equ	$19368			;SCnum of the breakaway / penalty-shot / shootout skater
BA_Goalie_SCnum	equ	$1936A			;SCnum of that play's goalie
BA_Skater_Offset	equ	$1936C			;that skater's team position offset
BA_Goalie_Offset	equ	$1936E			;that goalie's team position offset
BA_Checker_Offset	equ	$19370			;the checker's team position offset (penalty shot)
pspenalty	equ	$19372			;penalty summary: penalty number
holdreset	equ	$19374			;hold reset countdown
onetimertargetx	equ	$19376			;one timer target x
onetimertargety	equ	$19378			;one timer target y
onetimerheight	equ	$1937A			;one timer puck height
FallYPos	equ	$1937C			;falling player y position
FallXPos	equ	$1937E			;falling player x position
aholdtimer	equ	$19380			;A button hold timers of pads 1 / 2 (one byte each); aholdtimer34 for pads
aholdtimer34	equ	$19382			;A button hold timers, controllers 3 and 4
setupfirstline	equ	$19384			;setup screen: first line shown
setupprevline	equ	$19386			;setup screen: previous line
setupmenuchars	equ	$19388			;setup screen: menu character base
logoteam	equ	$1938A			;team whose logo is shown
setuphome	equ	$1938C			;setup screen: home team
setupvis	equ	$1938E			;setup screen: visiting team
setupcardflags	equ	$19390			;setup screen: player card flags
homepicchars	equ	$19392			;home team picture characters
vispicchars	equ	$19394			;visiting team picture characters
cardroster	equ	$19396			;player card: roster
logobox1chars	equ	$19398			;logo box 1 characters
logobox2chars	equ	$1939A			;logo box 2 characters
teambitmapchars	equ	$1939C			;team bitmap characters
cardtimer	equ	$1939E			;player card timer
featuredplayer	equ	$193A0			;featured player
carddelay	equ	$193A2			;player card delay
cardprintx	equ	$193A4			;player card print x
cardprinty	equ	$193A6			;player card print y
cardteamnum	equ	$193A8			;player card team number
homegoalies	equ	$193AA			;home team goalies
awaygoalies	equ	$193AC			;away team goalies
homeplayers	equ	$193AE			;Players of the home team (CountPlayers)
awayplayers	equ	$193B0			;Players of the away team (CountPlayers)
shootoutclock	equ	$193B6			;The shootout clock
shootoutjiffy	equ	$193B8			;shootout frame counter
ValidSRAM	equ	$193BA			;nonzero when the save RAM is valid
namelog	equ	$1A2FC			;the user name log: $80 bytes from save RAM NameLogBase (NameLogIO),
nameentrybuf	equ	$1A37C			;name entry buffer
namelength	equ	$1A38A			;length of the name being entered
namelogsel	equ	$1A38C			;selected name log entry
namelogarrows	equ	$1A38E			;Name entry: the name log row with the arrows
nameentryvis	equ	$1A390			;name entry cursor visible
nameframechars	equ	$1A3D2			;Name entry frame chars (NameEntryFramer)
recsort1	equ	$1A3D4			;Record Holders row order sorted on record byte 0 (ReadTeamRecords), read
recsort2	equ	$1A3DC			;Record Holders row order sorted on record byte 4 (ReadTeamRecords,
winsort	equ	$1A3E4			;Record Holders win row order (CalcWinPercents), read by PrintWinRecords
winpcts	equ	$1A3EC			;the win % byte of each of the 8 records (CalcWinPercents)
winties	equ	$1A3F4			;the ties word of each record (record bytes $C-$D)
wingames	equ	$1A404			;the games word of each record (record bytes $A-$B)
shootoutstate	equ	$1A414			;first of the 19 words ClearGameStats clears (shootout
homeshootgoals	equ	$1A416			;Shootout goals, home
awayshootgoals	equ	$1A418			;Shootout goals, away
shootoutround	equ	$1A41A			;Shootout round
homeshooters	equ	$1A41C			;the home shootout shooter list (6 words, homeshootnum the index)
homeshootnum	equ	$1A428			;The shooter index of the shootout
awayshooters	equ	$1A42A			;the away shootout shooter list (6 words)
shootoutteam	equ	$1A436			;Shootout: 0 home shoots, 1 away
matchup	equ	$1A43A			;matchup screen: selection
scoutunused	equ	$1A43C			;cleared by ScoutingReport, never read
matchuphome	equ	$1A43E			;matchup screen: home team
matchupvis	equ	$1A440			;the visitors player of the matchup; also the scroll limit of StatsReport
homerating	equ	$1A442			;home team rating
visrating	equ	$1A444			;visiting team rating
advframe	equ	$1A446			;advantage meter frame
advcount	equ	$1A448			;advantage meter count
matchuptimer	equ	$1A44A			;matchup screen timer
matchupslot	equ	$1A44C			;matchup screen slot
VertLineScrolling	equ	$1A450			;scouting report: text line being drawn, -1 = none
PlayerScrollCtr	equ	$1A452			;scouting report: scroll step per frame (RAM
SelectedPlayerIdx	equ	$1A454			;scouting report: index into TestList (RAM shared with the stats screens)
ScoutingReportTimer	equ	$1A456			;scouting report: frames elapsed, the text typing delay (94 had typedelay)
screentimer	equ	$1A458			;frames left on a screen (ScoutingReport); last cursor row.
TestList	equ	$1A45A			;scouting report: list of the lines to show (also the line editor cursor
arenaanimchars	equ	$1A54E			;arena animation characters
arenaframe	equ	$1A550			;arena animation frame
arenaframeidx	equ	$1A552			;arena animation frame index
arenaframetime	equ	$1A554			;arena animation frame time
arenaanim	equ	$1A556			;arena animation
arenaframelist	equ	$1A558			;arena animation frame list pointer
arenaspritelist	equ	$1A55C			;arena sprite list pointer
faceoffanim	equ	$1A560			;faceoff animation state
cursoron	equ	$1A566			;cursor visible
facelcwait	equ	$1A568			;wait value, set to $FFFF by the logic
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
sopathy	equ	$1A8BA			;shootout path y
sopathdir	equ	$1A8BC			;passdir at the end of the shootout path
sopathend	equ	$1A8BE			;shootout path end
picturebuf	equ	$1A8C0			;UnpackPicture output: tile count word, then the 4 bit tiles
picturebits	equ	$1AD42			;UnpackPicture: the 3 packed bytes of the row being unpacked
homepresses	equ	$1AD46			;home team button presses
homedirpresses	equ	$1AD4A			;home team direction presses
awaypresses	equ	$1AD4E			;away team button presses
awaydirpresses	equ	$1AD52			;away team direction presses
replayicontimer	equ	$1AD56			;replay icon timer
TmpPuckX	equ	$1AD58			;temporary puck x
lognametext	equ	$1AD5C			;the unused TerminateLogName's GetLogName String text (length word at -2)
songdelay	equ	$1AD6E			;frames until the delayed song starts
delayedsong	equ	$1AD70			;song waiting to start
shootoutdelay	equ	$1AD72			;Frames before the shootout ends
PuckZCntr	equ	$1AD74			;Frames the puck has hung at one height
waitxpad	equ	$1AD76			;pad used by the wait routine
TmpPuckZ	equ	$1AD78			;puckz last frame
inputjoy	equ	$1AD7A			;joypad input
TmpJoyPuckCarrier	equ	$1AD7C			;temporary joypad puck carrier
PlayerChked	equ	$1AD7E			;player being checked
PlayerChking	equ	$1AD82			;player checking
hoticonchars	equ	$1AD86			;First vram char of the hot icon (ScoutingReport, HotIconMap)
coldiconchars	equ	$1AD88			;First vram char of the cold icon (ColdIconMap)
iconplayer	equ	$1AD8A			;icon player
iconx	equ	$1AD8C			;icon x position
scoutwait	equ	$1AD8E			;scouting report wait
replaydelay	equ	$1AD92			;replay delay
outputbuffer	equ	$18C42			;work buffer, also the shot data kept between games
tpassbits	equ	$18D26			;temporary storage of passbits
PALflag	equ	$1AD94			;nonzero on a PAL console

; --- variables only the disc has, by address ---
replayend	equ	$173B0			;end of the replay frames (replaysize bytes each)
varstart	equ	$1745C			;start of variable space: Opening2 clears from here to varend, the boot code to BootClearEnd
CdSongPending	equ	$1745C			;disc only: song sets 1 when a CD track is wanted; SongCdCheck starts it and sets 0; set to -1 after the game start-up song is sent
CdSongTrack	equ	$1745E			;disc only: CD track for the song (song number - $29, or 2), passed to the CD player in CdCommandArg
SubVblankCount	equ	$17460			;disc only: VBlankSubCpuHook adds 1 each vblank it serves; cleared when the game starts its song
scoutparaoff	equ	$17462			;disc only: byte offset of the next paragraph, replaces the cartridge's line skip
ScoutLastPara	equ	$17466			;disc only: set when the last paragraph ($21) is reached
AltTeamGfxFlag	equ	$17468			;disc only: 1 while the scoreboard calls ClrHor; makes LoadHomeTeamGfx use the graphics at $47DA8 instead of $47D90
CdBiosParam	equ	$1746A			;disc only: parameter passed in a0 to CD BIOS call $10 (logos94cd)
puckx	equ	$17B80			;puck x position in its sort object (93G)
pucky	equ	$17B94			;puck y position
puckz	equ	$17B98			;puck height above the ice
puckvx	equ	$17BA8			;puck x velocity
puckvy	equ	$17BAA			;puck y velocity
puckvz	equ	$17BAC			;puck z velocity
puckx_nopuck	equ	$17BDE			;puck object nopuck word
puckc	equ	$17BE0			;puck carrier (93G: the newpos slot of the puck object)
puck_pflags2	equ	$17BE3			;puck object pflags2
PlayerSwitchDelay	equ	$17E57			;frames before the controlled player may switch again, set to $11 when a switch happens
Teamblocksmap	equ	$17FB2
HmGoals	equ	$18358			;home score
HomeTeamRosterPtr	equ	$1836A			;tmstruct+tmdata
AwGoals	equ	$186BE			;away score
AwayTeamRosterPtr	equ	$186D0			;awtmstruct+tmdata
MenuScrollTop	equ	$18AD4			;first visible row of a scrolling menu (menuitem - 3 when the selection moves past the bottom row)
LogoDataLoaded	equ	$191CE			;disc only: set after the pointer table and logo bitmaps are loaded and relocated, cleared before the scouting report text is loaded; GameOverCheckScroll tests it
DiscDmaListPtr	equ	$19360			;pointer to the end of the disc dma/command word list; entries are pushed with -(a6), see DoDMAProQueue
CdCommandArg	equ	$19364			;word argument buffer passed in a0 to the sub CPU call $5F22
scoutcolumn	equ	$1A44E			;cartridge $D5AC (DispAttribCtr)
DMAlistendCopy	equ	$1AD96			;disc only: DumpSprites stores the DMA list end here as well as in DMAlistend (not read in HOCKEY.BIN)
BootClearEnd	equ	$1AD9A			;disc only: end of the RAM the boot code clears from varstart
LOAD	equ	$1B000			;HOCKEY.BIN runtime address = file offset + LOAD. A bsr or bra to a name

GateRequestBlock	equ	$BBC88			;disc only: words the main CPU reads for a request raised with RaiseGateRequest (for a VDP DMA: register words $8154/$8F02, length $93/$94, source $95-$97, then the VDP command long at +$16)
; --- other names the disc code uses: structure offsets, cartridge routines and data at their cartridge addresses, disc files ---
ScoutingReportText	equ	$47CFC		;pointer to the loaded Ron Barr script (the cartridge has it inline)
tmdata		equ	$1E			;team data address, as the cartridge
tmgoalie	equ	$28			;goalie 1/2/none: $28 on the disc, $26 on the cartridge
pldsize		equ	8
tmboxlist	equ	$9C			;penalty box list of roster players (bytes, negative ends): tmpdst + 2 * 26 roster slots
BigFontMap	equ	$47D38			;pointer to the big font graphics (a loaded file here)
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
palfadenew	equ	$BBCB0			;palettes to fade into (+$20 the title palette, +$40 palettes 2-3)
Satt	equ	$BBD30			;sprite attribute table (for dma transfer)
teamrecbuf	equ	$BC0C8			;SRAM team record buffer
ThreeStars	equ	$BC000
TeamLogoBitmaps	equ	$47D8C			;pointer, a loaded file here
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
CC_SetAttribute	equ	$FE			;palette/priority (printa)
CC_ListEnd	equ	$FF			;ends a menu item list
CC_Font2Pal2Pri	equ	$9E
CC_Font1Pal3Pri	equ	$8F
CC_Font2Pal3Pri	equ	$8E
CC_Font3Pal3Pri	equ	$8D

; --- constants of the cartridge that the disc code uses, with the disc's values (the disc team struct differs: tmgoalie is $28) ---
dfok	equ	$0			;graphics are ready for transfer
sfpz	equ	$0			;pause mode
sf3llcs	equ	$0			;lower line change sel.
gmclock	equ	$0			;game clock is stopped
pf3oside	equ	$0			;offsides
pfdoff	equ	$0			;bit0-deceleration off
pf2fight	equ	$0			;player is fighting (93; 94 has no fights)
sf2faceoff	equ	$0			;face off in progress
tmflcc	equ	$0			;tmflags: line change on
tmflcm	equ	$1			;tmflags: team is in line change mode
ifcgl	equ	$0			;iflags: crossed goalline
ubut	equ	$0			;up
gsftf	equ	$0			;teams are flipped
sf2refref	equ	$1			;ref needs refresh
sfpj	equ	$1			;pause cont (0 for cont 1)
pf3break	equ	$1			;on a breakaway
gmdir	equ	$1			;0 = home team goes up
pfna	equ	$1			;bit1-new assignment
ifdir	equ	$1			;iflags: 1=must cross top line
dbut	equ	$1			;down
gsfhl	equ	$1			;hilite requested
df32c	equ	$1			;32 column mode on
pbscnum	equ	$1			;byte: SCnum of the player
dfng	equ	$2			;don't int graphics
seY	equ	$2			;word: y, signed
foattr	equ	$2			;word: attribute (bit 11 x flip)
satSize	equ	$2			;byte: size code
sf2drec	equ	$2			;disable replay record
sfspdir	equ	$2			;set pass dir mode
pf2unav	equ	$2			;player is unavailable (going to/from bench/penalty). 92 bit 4
pfnc	equ	$2			;bit2-no collision mode
pf3gctrl	equ	$2			;goalie control
SngFaceoff	equ	$2			;face off tune, once per period; also the shootout song
pldlegspd	equ	$2			;high nibble speed legspd, low nibble offense aioff (so)
ifok	equ	$2			;iflags: icing
pcframes	equ	$2			;word: frames
mapheight	equ	$2			;word: height in tiles
gsfso	equ	$2			;series over
gst2	equ	$2			;team 2
ssflags	equ	$2			;byte: 2 + skater difference (goal type); bit 7 = away team scored
pspen	equ	$2			;byte: penalty (Penaltylist offset); bit 7 = away team
strtext	equ	$2			;String: start of the text after its length word
sf3alttree	equ	$2			;alt. tree
gmpen	equ	$2			;penalty has been called
satLink	equ	$3			;byte: next sprite (0 ends the list)
sf2replay	equ	$3			;replay in progress
pf3onetimer	equ	$3			;doing a one-timer
dfclock	equ	$3			;clock needs update
pf2lcm	equ	$3			;line change mode. 92 bit 5
pfjoycon	equ	$3			;is player joystick controlled
sfssdir	equ	$3			;set shot dir mode
gmpendel	equ	$3			;delayed penalty has been called
pldaidef	equ	$3			;high nibble defense aidef, low nibble shot power shotspd (dp)
tmflast	equ	$3			;next touch overwrites the last touch only.
ssscorer	equ	$3			;byte: scorer
srforwards	equ	$3			;high nibble: forward count (GetForwardCount); low nibble not read
sf3sbut	equ	$3			;flag for start button
jimdata	equ	$4			;long: offset of the map (.map.jim) or the frame table (.anim)
dffaceoff	equ	$4			;face off sprites on (92 tested sf2faceoff).
seTile	equ	$4			;word: tile, from the set's first tile
satTile	equ	$4			;word: priority, palette, flips, tile
attribute	equ	$4			;frame attribute switch bits
mapwords	equ	$4			;the map words
pf3wall	equ	$4			;wall collision
sfwrap	equ	$4			;replay has wrapped around
gmhl	equ	$4			;hilight mode
ursaves	equ	$4			;most saves in a game
sf2shot	equ	$4			;shot was taken
pf2pen	equ	$4			;player has caused a penalty. 92 bit 6
sf3fo	equ	$4			;face off just ended (set by the drop): the next puck pickup wins it, with
tmfoside	equ	$4			;team is offsides (92 flagged the player with pf3oside)
gspotwins	equ	$4			;play off top team (on tree) wins (for best of 7)
pfalock	equ	$5			;lock out until anim is done
pf3fall	equ	$5			;falling down
cbut	equ	$5			;c button
pf2npc	equ	$5			;no player collision. 92 bit 7
sf2pwrplay	equ	$5			;power play in progress
gmoffs	equ	$5			;offsides on
pldstick	equ	$5			;high nibble stickhandling stickhand, low nibble shot accuracy (ga)
satX	equ	$6			;word: x + 128
seAttr	equ	$6			;word: priority, palette, vflip, hflip (bits 15-11), size code (low byte)
frame	equ	$6			;alice frame number
pfteam	equ	$6			;0-home(sprite0-5)/1-visitors(sprite6-11)
sf3icetime	equ	$6			;set once a second by updatepentime: each player on the ice adds 1 to its
sfslock	equ	$6			;scroll lock to xc1/yc1
sf2pwrtm	equ	$6			;0 for team 1 in power play
plpos	equ	$6			;PlList: 6 wanted roster players, then their positions
gspobwins	equ	$6			;play off bottom team (on tree) wins (for best of 7)
sfhor	equ	$7			;screen is in horizontal mode
seSize	equ	$7			;byte: VDP size code (low byte of seAttr)
pfgoal	equ	$7			;0=bottom, 1=top (to shoot at)
sbut	equ	$7			;start button
scsize	equ	$7			;2 to this power indicates ram needed for each sortobj
sf2offsig	equ	$7			;offsides little ref on
oldframe	equ	$8			;last frame
crpeak	equ	$8			;loudest crowd (home games)
urwins	equ	$8			;word, high byte first: wins
gsper	equ	$8			;period
crpeakuser	equ	$9			;peak crowd record: user
VRoffs	equ	$A			;offsets to find each sprites start char. (max of 6 sprites / frame)
urgames	equ	$A			;word, high byte first: games (stops at 9000)
gss1	equ	$A			;team 1 score
tmscore	equ	$C			;score
gss2	equ	$C			;team 2 score
puckscnum	equ	$E			;puck is sort obj number 14
gsflags	equ	$E			;flags
gssize	equ	$10			;bytes per game structure
VRchar	equ	$12			;vram char for graphic
Ypos	equ	$14			;y position
tmline	equ	$16			;current line
Zpos	equ	$18			;height above the ice
tmtouch1	equ	$18			;last touch (team/pnum word): the scorer
jps	equ	$18			;jiffys per second
tmtouch2	equ	$1A			;second last touch (first assist)
RosterSlots	equ	$1A			;roster slots per team
ffosize	equ	$1C			;field objects tied to icerink scrolling (pads), OldXpos bytes each (92G)
tmtouch3	equ	$1C			;third last touch (second assist)
OldXpos	equ	$1C			;x position before the last move
OldYpos	equ	$20			;y position before the last move
tmsort	equ	$22			;team struct: first sort object of the team (a long on the disc, a word on the cartridge)
tmap	equ	$26			;active players on ice 4-6
Xvel	equ	$28			;x velocity
Yvel	equ	$2A			;y velocity
tmteam	equ	$2A			;team number (TeamList index) of this team struct
Zvel	equ	$2C			;z velocity (vertical)
tmnear	equ	$2C			;long: nearest skater's distance^2 to the puck (assnearest)
impactp	equ	$2E			;last player to cause impact
tmflags	equ	$32			;flags
impact	equ	$32			;impact value
position	equ	$34			;player's position (0=goalie,1=l.def,2=r.def,3=l.wing,4=center,5=r.wing)
tmpde	equ	$34			;energy level of each roster player
assnum	equ	$36			;index to current assignment
asslist	equ	$38			;list of assignments in order of execution
temp1	equ	$40			;scratch word; its meaning depends on the assignment (timers, targets)
temp2	equ	$42			;scratch word (see temp1)
temp3	equ	$44			;scratch word (see temp1)
temp4	equ	$46			;scratch word (see temp1)
temp5	equ	$48			;scratch word (see temp1)
Wallcos	equ	$4E			;cos of angle of last collision
Wallsin	equ	$50			;sin of angle of last collision
SCnum	equ	$52			;index number for this struct
facedir	equ	$54			;direction of facing
SPA	equ	$58			;animation (SPA offset)
SPAnum	equ	$5A			;index into animation
SPAcnt	equ	$5C			;count down to next frame of animation
nopuck	equ	$5E			;no puck coll until zero
nopuckb	equ	$5F			;second count down (low byte of nopuck)
newpos	equ	$60			;requested next position of this player
newpnum	equ	$61			;requested next player (from roster) for this player
replaysize	equ	$62			;bytes per replay frame (92G/93G name; 92G 84)
pflags	equ	$62			;player flags (pf bits)
pflags3	equ	$64			;player flags 3 (92: not used)
glitch	equ	$65			;counter to eliminate quick frame changes (de-glitch graphics)
pnum	equ	$66			;player's team location number 0-22
weight	equ	$67			;player weight (collision oomph and checking)
tmpdst	equ	$68			;-2=bench/-1=ice/0+=penalty box
legstr	equ	$68			;leg strength (checking power)
aidef	equ	$6B			;defensive rating (CPU defense)
shotspd	equ	$6C			;shot speed
shotacc	equ	$6D			;player rating: shot accuracy
passacc	equ	$6E			;pass accuracy
rostnum	equ	$6F			;roster number of the player
stickhand	equ	$71			;player rating: stickhandling
endurance	equ	$72			;player rating: endurance
fighting	equ	$74			;fighting (Fgt; from the Chk/Hnd byte, always even)
handed	equ	$76			;bit0 set is left handed
SCstruct	equ	$80			;bytes per sort object
Sideline	equ	$88			;distance from center to side boards
tmgoals	equ	$B6			;goals per roster player (goalies: goals against), bytes
horoff	equ	$C5
tmpshots	equ	$EA			;shots per roster player (goalies: shots against), bytes
tmpice	equ	$138			;frames on ice per roster player (words)
tmHotCold	equ	$1A4			;hot / cold table: 16 bytes per roster player (26 x 16 bytes), each
tmsize	equ	$366			;93 $1A2: 94 adds tmHotCold and the stats from tmPerGoals
TeamRecBase	equ	$D20			;offset of the team records
M68K_RAM	equ	$C45C			;start of the 68000 work RAM, the same as replaystart
; --- names the cartridge defines from other names ---
GoalieStruct	equ	SortCords-SCstruct	;the sort object before SortCords: GoalieStruct+SCstruct is player 0
logoslide	equ	clampcounter		;reused: title / playoff screen page time (credits wait)
varend	equ	nibblebuffer+8		;end of the variables cleared by Opening2
starscores	equ	ThreeStars		;the 52 star score longs (CalcStarScores)
recordbuf	equ	ThreeStars		;record read buffer (ReadCrowdRecord)
rosxoff	equ	OldXpos			;game setup: player sprite x offset from Xpos (optsetup94)
BackupRamSum	equ	BackupRamImage+$F20	;disc only: BackupRamChecksum of the image, the long after it
