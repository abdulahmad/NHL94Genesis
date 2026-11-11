#!/bin/bash
# segacd_hockey.sh: write the HOCKEY.BIN fragments in src/segacd/hockey/ from the cartridge source with
# tools/segacd_port.py, in disc order, starting from an empty hockey.inc (the RAM map is rebuilt as it goes).
# This file is the record of each segment's disc range, the names checked by hand, and the header note.
#
#   tools/segacd_hockey.sh [listing] [last-segment]
#
# listing: the cartridge build listing (default output/obj/nhl94 .lst; run npm run build:retail first,
# and keep a copy: npm run build:segacd empties output/obj/). Needs the retail ROM in the repo folder
# and cdbin/HOCKEY.BIN. Then run npm run build:segacd (or tools/segacd_check.sh).
cd "$(dirname "$0")/.." || exit 1
LST=${1:-"output/obj/nhl94 .lst"}
STOP=$2
[ -f "$LST" ] || { echo "no cartridge listing at '$LST' (npm run build:retail)"; exit 1; }
rm -f src/segacd/hockey/hockey.inc
fail=0
# Disc addresses and values checked by hand (each with the line that shows it):
KNOWN=(
  --name seed=0x18C18          # optsetup94 SetupDemo: the command $1B word goes where the cartridge stores HVcount
  --name TeamList=0x1B00C      # file $C: the 28 team record pointers
  --name tmgoals=0xB6          # cards94 UpdatePlayerRecords: addi.w #$B6,d0 for addi.w #tmgoals,d0
  --name tmpshots=0xEA         # cards94 UpdatePlayerRecords: addi.w #$EA,d0 for addi.w #tmpshots,d0
  --name LineDataBase=0xE20    # shootoutpath94 ReadLineData / WriteLineData: move.l #$E20,d0 for #LineDataBase
)
# Graphics pointer table entries (cdgfxptrs.asm), named after the cartridge label of the graphic each holds
# (the GRAPH2 pack pieces, tools/segacd_graph2.py) and the replaced lines:
CDNAMES=(
  --cdname ScoutingReportTextPtr=0x47CFC
  --cdname GameSetUpMapPtr=0x47D00
  --cdname GameSetUpMap2Ptr=0x47D04
  --cdname EASportsBGMapPtr=0x47D0C
  --cdname FramerMapPtr=0x47D10
  --cdname FaceOffMapPtr=0x47D14
  --cdname RinktilelistPtr=0x47D18
  --cdname RefsMapPtr=0x47D1C
  --cdname RefMap2Ptr=0x47D20
  --cdname HotListPtr=0x47D28
  --cdname CrowdSpritesPtr=0x47D2C
  --cdname FaceOffSpritesPtr=0x47D30
  --cdname ZamSpritesPtr=0x47D34
  --cdname BigFontMapPtr=0x47D38
  --cdname SmallFontMapPtr=0x47D3C
  --cdname EnergyBarMapPtr=0x47D40
  --cdname TeamblocksmapPtr=0x47D44
  --cdname TeamBitmapsPtr=0x47D48
  --cdname EASportsMapPtr=0x47D4C
  --cdname ArrowsmapPtr=0x47D50
  --cdname RonBarrMapPtr=0x47D54
  --cdname ScoresMapPtr=0x47D58
  --cdname RevRinkTilelistPtr=0x47D64
  --cdname ReplayMapPtr=0x47D68
  --cdname IceRinkHorMapPtr=0x47D6C
  --cdname PrintFont2MapPtr=0x47D70
  --cdname SetupMenuMapPtr=0x47D74
  --cdname SetupFramerMapPtr=0x47D78
  --cdname LogoBoxMapPtr=0x47D7C
  --cdname NHLLogoMapPtr=0x47D80
  --cdname NHLPALogoMapPtr=0x47D84
  --cdname FeaturedPicturesPtr=0x47D88
  --cdname TeamLogoBitmapsPtr=0x47D8C
  --cdname HomeTeamGfxPtr=0x47D90
  --cdname StanleyCupSpritePtr=0x47D94
  --cdname HotMapPtr=0x47D98
  --cdname ColdMapPtr=0x47D9C
  --cdname ScoutingSpeechClipsPtr=0x47DA4 # GRAPH2 resource 0 piece 3, the scouting speech clips (docs/segacd_announce.md)
)
# --entry: a cartridge routine the CD put new lines in front of. Its callers in other fragments enter at the
# new first line, so the name goes there (checked by hand: the new lines fall through into the routine):
#   StartGame        $2B7F8  BIOS $5F22 (d0 = 2) and bclr #5,$FF800F before st.b arenaanim (setup94 calls it)
#   CountButtonPress $2AD3A  movem.l d1/a0,-(sp) (logic94)        LeadSong  $2B2D6  movem.l d0/a0-a3,-(sp) (logic94)
#   remap            $36C14  saves sub flag bit 5 on the a6 stack and clears it (decompress94)
#   dobitmap         $387E2  the same (cards94, logic94, logos94, optsetup94 ...)
#   AddFramer        $393FA  movea.l FramerMapPtr,a2 / addq.l #8,a2: the pointer load for the ROM label (setup94, stats94)
#   ReloadFaceOffMap $3ECEE  move.w, movea.l FaceOffMapPtr,a2, addq.l #8 (replay94)
#   box              $410EC  the jsr in front of box's inline data (logic94)
port() {  # name[:part] start end [options...]   name:2 writes src/segacd/hockey/name_2.asm
  # A 94G file whose disc range holds one of the older hand fragments (src/segacd/*.asm, left as they are)
  # is written in parts around it: name, name_2, name_3 ... each its own fragment.
  local n=${1%%:*} part= s=$2 e=$3
  [ "$n" != "$1" ] && part="_${1##*:}"
  shift 3
  local src=(--file "$n.asm")
  [ "${n#cd}" != "$n" ] && src=(--cart-start 0 --cart-end 0)   # cd*: CD-only code, no cartridge file
  python tools/segacd_port.py --lst "$LST" "${src[@]}" --disc-start "$s" --disc-end "$e" \
    --out "src/segacd/hockey/$n$part.asm" --register "${KNOWN[@]}" "${CDNAMES[@]}" "$@" > "output/port_$n$part.log" 2>&1
  grep -q "^MATCH" "output/port_$n$part.log" || fail=1
  grep -E "^(MATCH|MISMATCH)|^src" "output/port_$n$part.log" | tr '\n' ' '; echo
  if [ "$n$part" = "$STOP" ]; then exit $fail; fi
}
mkdir -p output

port teamdata94 0x0 0x5432 --no-text --name Begin=0x22096 --note 'The file header (jmp to Begin, a word, null, TeamList) and the team data. The player names and team\nnicknames are licensed: those lines are incbin from the disc file, with the line (text masked, ratings\nand the P id kept) as the comment; every block with no cartridge twin is read from the disc file too.\nThe record structure, palettes, lines and ratings are the cartridge source. TeamList keeps the cartridge\norder (team number = index); the records are laid out in another order, Florida and Anaheim last.'
port frames94 0x5432 0x6FC8 --note 'The sprite animation tables, the cartridge data unchanged (the cartridge has them at $5B1C).'
port sram94 0x6FC8 0x7534 --also hockey94.asm --data 0x222EA-0x2240C --label GamePcmSounds=0x222EA --label GamePcmSampleList=0x223D6 --note 'CD start-up and save data. The file opens with new code (the BIOS vector at $6038, a handshake with\nthe main CPU), then Begin, the game start that the jmp at file $0 enters (stack at $C458, clears\n$1745C-$1AD99), then ValidateSRAM / ClearSRAM reworked for the backup RAM through the BIOS ($6044).'
port cards94:2 0x7534 0x76A8 --note 'Part 2 of cards94: the save RAM readers (ReadPlayerRecord ... NameLogIO, PlayerRecordOffsets).\nOn the disc they sit here, next to sram94, not in cards94 (part 1 at $9B5E). The cartridge code.'
port onetimer94 0x76A8 0x7DDC --note 'Same code as the cartridge. The disc team struct is one word longer: tmOneTimers and tmsize\nare two bytes further on (hockey.inc).'
port fourway94 0x7DDC 0x7E38 --note 'CD: Detect4WayPlay and the ReadJoySwapPad routines are gone (the sub CPU has no pad ports);\none rts, called by nothing, is left where they were. Set4WayPlayer is the cartridge code.'
port crowd94 0x7E38 0x83CC --note 'Same code as the cartridge, with one change in checkcornercoll: the corner-circle test compares\nthe squared distance with $42 where the cartridge has $1000 (the radius $40 squared).'
port optsetup94 0x83CC 0x9B5E --note 'The option logic and strings are the cartridge'"'"'s. CD: the graphics are not ROM labels any more:\neach movea.l #map / lea of a tile set became a load from a pointer table at $47D00-$47D8C\n(file $2CD00, zeros on the disc, filled at run time), and the beam-counter seed is command $1B\nto the main CPU (the word comes back in $FF8010). The New York full names are read from the disc file.'
port cards94 0x9B5E 0xB348 --label RunPlayerOverlay=0x25E56 --note 'The record bookkeeping (GetRecordValue, UpdateRecords ...) and CalcAttrib are the cartridge code.\nCD: the save RAM readers (ReadPlayerRecord ... NameLogIO) moved next to sram94 (file $7534);\nFeaturedPictures and the player card screen (PlayerCards ... BuildCardPlayerList) are gone;\nTeamPalettes stay (read from the disc file); pictures come through FeaturedPicturesPtr ($47D88);\nMenuWaitVblank became the BIOS call at $6044.'
port records94 0xB348 0xC860 --note 'Name entry and the Record Holders screen are the cartridge code. CD: the graphics come through\nthe pointer table ($47D0C ...), the screen setup sets / clears bit 5 of $FF800F (the sub CPU flag)\nwhere the cartridge masks interrupts, and the goal and save record titles differ slightly.'
port shootout94 0xC860 0xD1D4 --note 'The shootout logic is the cartridge code. CD: the shooter list is kept in word RAM at $BBD30,\nand the logo comes through the graphics pointer table ($47D0C).'
port scout94 0xD1D4 0xD2B6 --note 'Part 1 of scout94 (part 2 is scout94_2.asm; $D2B6-$D397 between them is src/segacd/scoutopen.asm).\nThe matchup screen is the cartridge code.'
port scout94:2 0xD398 0xE1CE --note 'Part 2 of scout94 ($D2B6-$D397 before it is src/segacd/scoutopen.asm, the scouting screen open).\nCD: the scouting report screen is largely new (the CD reads the report aloud; docs/segacd_announce.md);\nwaitx became the BIOS call at $6044.'
port period94 0xE1CE 0xF1AA --note 'Period stats, game statistics and Manual Goalie are the cartridge code. CD: the team logos come\nthrough the graphics pointer table ($47D8C) and BIOS calls ($6044 with d7 = 2), and a stat line\nis sent to the main CPU with command $B; the first lines of PrintStatValue have no twin.'
port arena94 0xF1AA 0xF58C --note 'The arena / faceoff animations are the cartridge code; NHLPALogoMap is in HOCKEY.BIN.'
port shootoutpath94 0xF58C 0xF902 --note 'Saved lines and the shootout skate paths are the cartridge code. The saved lines sit at $E20\nin the backup RAM image (LineDataBase; the cartridge save RAM has them at $1EF6).'
port ui94 0xF902 0xFE68 --entry CountButtonPress=0x2AD3A --note 'Most of it is the cartridge code. CD: PlayedByText and the playoff sprites use the graphics\npointer table ($47D90-$47DA8) and word RAM ($BBD30); the first lines of DrawPlayoffSprite and\nCountButtonPress have no twin.'
port helpers94 0xFE68 0xFF56 --note 'Same code as the cartridge. (title94, the title screen and credits, is not on the disc: the\nCD has its own title, and logos94 follows straight on.)'
port logos94 0xFF56 0x104E2 --entry LeadSong=0x2B2D6 --note 'TeamLogoPalettes, the lead song and ClearPenalties are the cartridge'"'"'s. CD: a few palette\nwords differ, and the hot / cold icons come through the graphics pointer table ($47D98, $47D9C).'
port chgplayer94 0x104E2 0x10614 --note 'chgplayer and its far thunks are the cartridge code, with a few lines changed (CD blocks).'
port hockey94 0x10614 0x10B1E --entry StartGame=0x2B7F8 --label LoadGameGfx=0x2B614 --note 'Part 1 of hockey94 (parts 2 and 3 are hockey94_2.asm and hockey94_3.asm). StartGame, the period\nstart and the clock are the cartridge code. CD: VBjsr and Begin (the cold start) are not here (Begin is\nin sram94.asm, file $7096). LoadGameGfx (CD-only, called from StartGame and cards94) loads the game\ngraphics file through the BIOS and fills the graphics pointer table (cdgfxptrs.asm). BIOS calls ($5F22,\n$6044) and the sub CPU flag ($FF800F bit 5) replace the interrupt masking around screen setups.'
port hockey94:2 0x10B58 0x10D28 --note 'Part 2 of hockey94 ($10B1E-$10B57 before it is src/segacd/songplay.asm). CD: ChkGoalies is no\nlonger called between periods, so the comments of the calls after it are one line off.'
port hockey94:3 0x10E66 0x112F8 --note 'Part 3 of hockey94 ($10D28-$10E65 before it is src/segacd/crowdanim.asm, the cartridge updatecrowdf).'
port menu94 0x112F8 0x11660 --note 'The menu core is the cartridge code; CD: a few lines wait on the main CPU flag ($FF800E).'
port stats94 0x11660 0x13E04 --note 'Scores, line editor, roster and the stat screens are the cartridge code. CD: their graphics come\nthrough the pointer table ($47D0C ...) and some screen writes are commands to the main CPU\n($FF8022 / $FF8020); PrintGameInfo, DrawStatsRow, PrintCrowdMeter and ExitStatsScreen start\nwith new lines (their names are placed where the disc calls them).'
port replay94 0x13E04 0x1498A --note 'The replay is the cartridge code; CD: its graphics come through the pointer table ($47D18,\n$47D64, $47D68).'
port logic94 0x1498A 0x1BBB2 --note 'Player update, input and the assignments are the cartridge code. CD: the team struct offsets\nfrom tmap on are a word further on; several early exits branch to a nearer rts than the\ncartridge'"'"'s shared rtss2 (left as X_ equates, noted); the pad reads and a few other lines are new.'
port middle94 0x1BBB2 0x1C10C --entry remap=0x36C14 --note 'Part 1 of middle94 (part 2 is middle94_2.asm; $1C10C-$1C2CF between them is src/segacd/sfxcd.asm,\ngate34.asm, cdrequest.asm and cdtrack.asm).'
port middle94:2 0x1C2D0 0x1D946 --entry dobitmap=0x387E2 --note 'Part 2 of middle94. CD: the sound driver calls and most of the VDP helpers here are new\n(CD audio and commands to the main CPU instead of the Z80 and VDP ports).'
port decompress94 0x1D946 0x1DBD4 --note 'The graphics decompressor, the cartridge code.'
port print94 0x1DBD4 0x1E41A --entry AddFramer=0x393FA --note 'The print routines. CD: writes to the VDP became commands to the main CPU (e.g. eraser sends\ncommand $D with the fill word in $FF8022).'
port penalty94 0x1E41A 0x1F0FA --note 'Part 1 of penalty94. On the disc penalty94 and collide94 are interleaved: penalty94 up to\nupdatepwrplay, collide94 up to setpersonel, then the rest of each (penalty94_2.asm, collide94_2.asm).'
port collide94 0x1F0FA 0x212D0 --note 'Part 1 of collide94 (see penalty94.asm for the interleaving).'
port penalty94:2 0x212D0 0x22426 --note 'Part 2 of penalty94, from updatepwrplay (see penalty94.asm).'
port collide94:2 0x22426 0x22AB8 --note 'Part 2 of collide94, from setpersonel (see penalty94.asm).'
port video94 0x22AB8 0x238CE --note 'The vblank, clock and rink scroll code (part 1; $238CE-$2391B after it is src/segacd/cdcrowd.asm).\nCD: VBlank is called as a subroutine (rts, not rte) and the music vblank call is gone; screen\nwrites go to the main CPU.'
port setup94 0x2391C 0x2486C --entry ReloadFaceOffMap=0x3ECEE --note 'Part 1 of setup94 (ice setup, attract, menus). $2486C-$24C09 after it is src/segacd/scouttext.asm\nand scouttok.asm.'
port setup94:2 0x24C0A 0x24C12 --note 'Part 2 of setup94: the 8 bytes between scouttok.asm and scoutload.asm (a zero word, then the\njsr $37598 that opens the scouting file load).'
port setup94:3 0x24DE8 0x2654C --entry box=0x410EC --note 'Part 3 of setup94, after src/segacd/scoutload.asm and cdstart.asm ($24C12-$24DE7): menus and\nthe playoff data. $2654C-$265CB after it is src/segacd/crowdtable.asm (the start of tables94).'
port tables94 0x265CC 0x278A0 --note 'tables94 after the crowd frame table (src/segacd/crowdtable.asm): asstab, penalties, the\nplayoff tree and the menu lists, the cartridge tables with disc addresses.'
port graphics94 0x278A0 0x28A7E --note 'Part 1 of graphics94: the player picture palette and the four no-picture cards cards94 draws,\nread from the disc file. The rest of the file (from $28A7E: arena sprites, the graphics pointer\ntable at $2CD00, code at $2CDAE) is not done yet.'
# Written by hand, not by this script (data, and a table of zeros): graphics94_2.asm ($28A7E, the arena
# graphics read from the disc file) and cdgfxptrs.asm ($2CCFC, the graphics pointer table).
port cdpads 0x2CDAC 0x2D20A --label ReadPads=0x47DB2 --note 'CD-only: the pad reader. ReadPads fills PadRaw1-PadRaw4 (the bytes ReadJoy1 ... ReadJoy4 read) by\nasking the main CPU for each pad: commands $35-$38 in $FF8026 with the port in $FF8028; all four pads\nwhen FourWayPlay. sram94 calls it. The cartridge reads its pads itself. Three rts stubs come first.'

exit $fail
