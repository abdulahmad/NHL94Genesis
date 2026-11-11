#!/bin/bash
# segacd_player.sh: write the PLAYER.BIN fragments in src/segacd/player/ with tools/segacd_port.py.
# PLAYER.BIN is position-independent (linked at 0, pc-relative, variables through a6). These fill the
# gaps around the older hand fragments (playerpic, playercareer, playerpage: left as they are). Needs
# only cdbin/PLAYER.BIN. playerphotos.asm (the images and the variable area) is written by hand.
#
#   tools/segacd_player.sh
cd "$(dirname "$0")/.." || exit 1
mkdir -p output src/segacd/player
fail=0
# Names (CD-only, given here; the evidence is in docs/segacd_player.md). ReadJoy1-4, ReadJoy and ReadPads
# are the names of the matching HOCKEY.BIN routines.
INIT_LABELS=(
  --label PlayerOverlayEntry=0x0              # stack and a6, the three arguments, display, pages, exit through $6044 d7 = 4
  --label FetchTeamPhotoAndStatTables=0xCAA   # resources 6 + team for both teams; $12345678 means no data
  --label WaitDisplayFrames=0xEAA             # waits d0+1 frame callbacks ($102(a6))
  --label ClearVerticalScroll=0xEBC           # VSRAM write $40000010, then zero
  --label SetWindowPosition=0xF64             # VDP registers $12 (d0) and $11 (d1)
  --label ClearStatTextTileRectangle=0x1006   # tile $47A0, ten columns by eleven rows
  --label AnimateStatDisplayTransition=0x10D8 # text tiles up, sprites moved, scroll queued
  --label InitStatTextSprites=0x11DA          # eight-byte sprite entries, $B6(a6) columns by $B8(a6) rows
  --label MoveStatTextSpritesY=0x1262         # adds d0 to 80 sprite Y words, upload to VRAM $E800
  --label RenderTwoStatStringsToTiles=0x129C  # two strings at a4 into the text tile buffer
  --label UploadStatTextTiles=0x1336          # $1F80 bytes to $BC000, $FC0 words to VRAM $C000
  --label DrawSelectedTeamPageBackground=0x1376 # one of the team's three pictures: tiles, palette, map
  --label DrawPlayerNumberAndPosition=0x1B9C  # number digits and G / D / L / C
  --label DrawThreeRowTileBlock=0x1C8C        # three rows of tile words
)
CODE_LABELS=(
  --label CopyVramRows=0x281C                 # DMA command list at $BC000 ($97C0 copy mode), operation 8
  --label CopyVramRowsViaMainCommand=0x289A   # operation 6 (main command $3A), $50 at a time
  --label FormatTwoDigitNumber=0x2972         # abcd, packed ASCII digits
  --label FormatPercentage=0x29B6             # decimal digits and '%'
  --label FormatDecimalString=0x2A1E          # divide by ten, reverse into a0
  --label FindPlayerAndCareerRecord=0x2AA0    # roster entry, name, career record by name
  --label FillVram=0x2C28                     # operation 2 with the long at $62(a6)
  --label FillVramWithTextTile=0x2C48         # operation 2 with $000007A1
  --label DrawTileMap=0x2C6A                  # width, height, tile words at a1
  --label MakeVramWriteCommand=0x2D3A         # VRAM address d4 to a VDP control long
  --label IncrementPaletteTick=0x2D4E         # addq to $EC(a6); a temporary frame callback
  --label ServicePlayerDisplay=0x2D54         # the display queue ($DE(a6) operations 1-10), scroll, palette
  --label WriteHorizontalScroll=0x3480        # VRAM $F000 through main commands $30/$31
  --label StepPaletteFade=0x356A              # main command $1D
  --label WritePlayerPalette=0x3608           # CRAM 0, 32 longs through main command $33
  --label ReadJoy1=0x36B6
  --label ReadJoy2=0x36CE
  --label ReadJoy3=0x36E6
  --label ReadJoy4=0x36FE
  --label ReadJoy=0x3716                      # the same 16-byte direction table as HOCKEY's
  --label ReadPads=0x3744                     # two pads, or four with FourWayPlay ($BC(a6))
  --label InstallPlayerFrameCallback=0x3B8C   # saves the vector at $6038 in $D6(a6)
  --label RestorePlayerFrameCallback=0x3B9C
  --label PlayerFrameCallback=0x3BA4          # display service, pads, main command $2F
  --label PrintTextAtScreenCell=0x3C16        # 40-column cell to the plane at VRAM $B000
  --label PrintTextAtPageCell=0x3C9C          # 128-column page plane at $EE(a6)-$2000
  --label PrintPaddedText=0x3D26              # font tiles from $47A0, padded with spaces
  --label PrintStatColumnText=0x3E18
  --label CopyTextToBuffer=0x3EEA             # to $8E(a6), up to a zero byte
  --label WaitForSubWordRam=0x3F04            # $FF8003 bit 1
  --label GiveWordRamToMain=0x3F10            # sets RET, waits for DMNA clear
  --label SendMainCommand3D=0x3F24            # the command $3D handshake
)
# Every name, for the fragments that call another one (an equate where used).
ALLNAMES=()
for x in "${INIT_LABELS[@]}" "${CODE_LABELS[@]}"; do
  [ "$x" = --label ] && ALLNAMES+=(--cdname) || ALLNAMES+=("$x")
done
port() {  # name start end [options...]
  local n=$1 s=$2 e=$3
  shift 3
  python tools/segacd_port.py --disc cdbin/PLAYER.BIN --base 0x0 --plain --tags --cart-start 0 --cart-end 0 \
    --disc-start "$s" --disc-end "$e" --out "src/segacd/player/$n.asm" --register "${ALLNAMES[@]}" "$@" > "output/port_player_$n.log" 2>&1
  grep -q "^MATCH" "output/port_player_$n.log" || fail=1
  grep -E "^(MATCH|MISMATCH)|^src" "output/port_player_$n.log" | tr '\n' ' '; echo
}

port playerinit 0x0 0x1D54 "${INIT_LABELS[@]}" --note 'The start of PLAYER.BIN, the player information overlay HOCKEY.BIN runs with $6044 d7 = 5 (d0, d1 the\ntwo teams, d2 FourWayPlay): stack and a6 (base + $A594), the team resources, the photo and team stat pages,\ntext sprites and page transitions, up to playerpic.asm. Names given here; docs/segacd_player.md.'
port playercode 0x281C 0x3F84 "${CODE_LABELS[@]}" --note 'After playerpage.asm: the display, input and text helpers of the overlay: VRAM copies and fills, the\nqueued display work and palette fades through the main CPU, the career record search, number formatting,\nthe pad readers (HOCKEY names), the frame callback at $6038, text printing. docs/segacd_player.md.'
port playertext 0x3F84 0x40C6 --raw --raw-text --note 'The column tables and the headings of the stat pages (Players, Goalies, Gp, Mins, Regular,\nPlayoff ...); playerphotos.asm follows.'

exit $fail
