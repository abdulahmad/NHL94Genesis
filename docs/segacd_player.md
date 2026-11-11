# PLAYER.BIN: the player information overlay

`PLAYER.BIN` is the player photo and career page, the team stat pages (Players, Goalies) and a third page that plays a team sequence through `$6044` with d7 = 7. It also does its own page navigation, pad reading, text drawing and palette fades. `docs/segacd_stats.md` describes the photo picker, the career rows and the team stat page (the older fragments `playerpic.asm`, `playercareer.asm`, `playerpage.asm`). The names here are given here (none comes from the disc); `tools/segacd_player.sh` holds them with a one-line reason each.

Addresses are PLAYER.BIN file offsets: the file is linked at 0 and runs wherever it is loaded (pc-relative code). Its start-up puts the stack at base + `$AE6E` and a6 at base + `$A594`, the zero-filled variable area in `playerphotos.asm`; an offset on a6 is a variable, not a code address.

## Entry and exit

HOCKEY.BIN runs it from `RunPlayerOverlay` (cards94.asm, runtime `$25E56`): it stops the main CPU's sound H interrupt (`$6044` with d7 = 9), saves the display state into `$AFF60` on, then calls `$6044` with d7 = 5 (OSRunPlayer, `docs/segacd_boot.md`) and

| Register | From | Meaning |
| --- | --- | --- |
| d0.w | `Opt1team` | first team |
| d1.w | `Opt2team` | second team |
| d2.w | `FourWayPlay` | zero: two pads; not zero: four pads |

PlayerOverlayEntry (`$0000`) keeps them at `$7C`, `$7E` and `$BC` on a6. On the way out PLAYER puts the display state back, restores the vector at `$6038` and calls `$6044` with d7 = 4 (file `$CA6`; no `rts` follows). Back in HOCKEY, RunPlayerOverlay calls LoadGameGfx to load the game graphics again. The services are in the disc's system program (`docs/segacd_boot.md`): OSRunPlayer reads PLAYER.BIN (22 sectors from LBA 2729) to `$1B000`, over HOCKEY.BIN, keeps the caller's stack and jumps to it; OSReturnFromPlayer (d7 = 4) reads HOCKEY.BIN back to `$1B000` and returns to RunPlayerOverlay.

## Resources

FetchTeamPhotoAndStatTables (`$0CAA`) loads GRAPH2 resource 6 + team for both teams (each team's photos, `docs/segacd.md` "GRAPH2.BIN and GTABLE.BIN") and fixes up their pointers; a pointer `$12345678` (the archive's end mark) means no data. The start-up also loads resources 68 + team (three pictures per team: `$00`-`$08` and `$0C`-`$14` on a6), 64 (93 tiles, `$70`) and 34 (a table of 28 team pointers, `$86`).

## Routines

- Start-up and pages: PlayerOverlayEntry, FetchTeamPhotoAndStatTables, WaitDisplayFrames (`$0EAA`, waits d0+1 frames), ClearVerticalScroll (`$0EBC`), SetWindowPosition (`$0F64`, VDP registers `$12`/`$11`), ClearStatTextTileRectangle (`$1006`), AnimateStatDisplayTransition (`$10D8`).
- Stat text as sprites: InitStatTextSprites (`$11DA`), MoveStatTextSpritesY (`$1262`), RenderTwoStatStringsToTiles (`$129C`, font glyphs into the tile buffer), UploadStatTextTiles (`$1336`, `$1F80` bytes to VRAM `$C000`).
- Pictures: DrawSelectedTeamPageBackground (`$1376`, one of the team's three pictures), DrawPlayerNumberAndPosition (`$1B9C`, the number digits and G / D / L / C), DrawThreeRowTileBlock (`$1C8C`).
- VRAM: CopyVramRows (`$281C`, a DMA command list at `$BC000`), CopyVramRowsViaMainCommand (`$289A`, main command `$3A`), FillVram (`$2C28`), FillVramWithTextTile (`$2C48`), DrawTileMap (`$2C6A`), MakeVramWriteCommand (`$2D3A`).
- Numbers and records: FormatTwoDigitNumber (`$2972`), FormatPercentage (`$29B6`), FormatDecimalString (`$2A1E`), FindPlayerAndCareerRecord (`$2AA0`, the roster entry and its career record, found by name).
- Display service: ServicePlayerDisplay (`$2D54`, the queued operation in `$DE(a6)`, scrolling, palette fades), WriteHorizontalScroll (`$3480`), StepPaletteFade (`$356A`, main command `$1D`), WritePlayerPalette (`$3608`, main command `$33`), IncrementPaletteTick (`$2D4E`, a temporary frame callback).
- Pads: ReadJoy1-ReadJoy4, ReadJoy and ReadPads (`$36B6`-`$3744`), the same code as the HOCKEY.BIN routines of those names.
- Frame callback: InstallPlayerFrameCallback / RestorePlayerFrameCallback (`$3B8C`, `$3B9C`, the vector at `$6038`), PlayerFrameCallback (`$3BA4`: the display service, the pads, main command `$2F`).
- Text: PrintTextAtScreenCell (`$3C16`), PrintTextAtPageCell (`$3C9C`), PrintPaddedText (`$3D26`, font tiles from `$47A0`), PrintStatColumnText (`$3E18`), CopyTextToBuffer (`$3EEA`).
- Word RAM: WaitForSubWordRam (`$3F04`), GiveWordRamToMain (`$3F10`); SendMainCommand3D (`$3F24`).

## The display queue

ServicePlayerDisplay runs the operation in `$DE(a6)` (zero: idle) on the next frame:

| Value | Operation |
| --- | --- |
| 1 | memory to VRAM, main command `$32` |
| 2 | fill VRAM, main command `$3B` |
| 3 | reset the horizontal scroll, VDP register `$9001` |
| 4 | VDP register `$9003` |
| 5 | a VDP register value and vertical scroll data |
| 6 | VRAM copy, main command `$3A` |
| 7 | vertical scroll data, then step it |
| 8 | the command list at `$BC000`, main command `$2C` |
| 9 | horizontal scroll data, then step it |
| 10 | window position registers |

Commands go to the game shell's table (`docs/segacd_main_shell.md`): foreground through `$FF8020`/`$FF8022` with flag bits 6/7, and from the frame callback through `$FF8026`/`$FF8028` with flag bits 3/4.

## Variables (a6)

| Offset | Use |
| --- | --- |
| `$00`-`$14` | the three page pictures of the first and the second team |
| `$18.w` | which team: zero first, not zero second |
| `$1C`/`$20` | the two teams' photo tables |
| `$24`-`$40` | skater and goalie stat lists and career lists, first then second team |
| `$44` | the career record found (zero: none) |
| `$48`/`$4C` | photo-to-roster index tables |
| `$50` | the selected player's attributes |
| `$70` | resource 64 (the font tiles) |
| `$7C`/`$7E`/`$BC` | the entry arguments |
| `$80.w` | the selected player |
| `$86` | resource 34, the 28 team pointers |
| `$8A` | the stat text tile buffer (`$1F80` bytes) |
| `$96` | frame counter |
| `$C2`-`$CC` | raw pad bytes and previous states |
| `$D2`/`$D6` | the active display callback, the saved `$6038` vector |
| `$DE`-`$E4` | the queued display operation and its parameters |
| `$EC`-`$FA` | palette countdown, page plane addresses, scroll state |
| `$102` | frame tick flag (WaitDisplayFrames) |

## Not worked out

`$0DEC` shows a picture held in the file and waits for a pad or 600 frames; `$14D2` steps through a team's list at `$7CF4` and calls `$6044` with d7 = 7 (OSPlayFilm, `docs/segacd_boot.md` "Films") with d0 = 1 (frame tiles at VRAM `$7000`, the window's cells at VRAM 0) and an `rts` as the callback. `$7CF4` holds 28 lists of 13 longs, one per team (`$34` * team): the start sectors of up to 12 of the team's films (`GOAL`, `HIT`, `THNDR`, `STNLY` `.SEG` files), then -1.
