# Gameplay loop performance

`main` is a faithful disassembly of the retail cartridge. A stock build matches `nhl94retail.bin`. Nothing here belongs on `main`: every change below emits different bytes and lives on a mod branch. Growing the ROM, short jumps, and the team checklist are `docs/EXPANDING_THE_ROM.md`.

The game already drops frames when a logic frame overruns one vblank. Physics is scaled by the missed count, so game-time stays roughly even and the picture gets choppy. The useful work is keeping that count at 1, or a stable 2, by cutting the two budgets that fill: 68000 time in `DoGameFrame` / `updateplayers`, and VBlank DMA in `DumpSprites`.

Stable 30 fps (two vblanks per logic frame on NTSC) is the first target. 60 fps only pays off after sprite-tile DMA is under control.

To see where a frame goes before changing anything, `patch/perf-stats` draws an overlay (`CPU`, `SL`/`MAX`, `FPS`, `SP`, `DM`, `LAG`). That branch is a meter, not these cuts. How to build it is `docs/BRANCHES.md`.

## How one frame runs

`Gameloop` in `hockey94.asm` calls `DoGameFrame`, then demo/pause. `DoGameFrame`:

1. Spins until `Vcount` has moved at least once (`d7` = elapsed vblanks since `OldVcount`).
2. `periodicevents` (penalties, crowd decay, arena anim, `updatesound`, clock, and the once-per-`jps` work: goalies, crowd excitement, late-game song, bench energy, injury, power play).
3. `updateplayers` (animation, input, assignment, motion, collision for all `Sortobjs`).
4. Delayed song, `setSlotBit`, `checkwindow`, `updatereplay`.
5. `setvideo`, which builds the sprite table and DMA list for the next vblank.

`VBlank` (set as `VBint` by `setupice`) is a second, tighter budget. When `dfok` is set it runs `DumpSprites`: `SetScroll2`, DMA of `Satt`, then every entry on `DMAList` (player tiles, rink rows, pad labels, ref). Then `cramfade`, the period clock, `Vcount++`, and `p_music_vblank`.

`setvideo` already pipelines one frame. It spins on `dfok` until vblank has taken the last list, builds the next `Satt` / `DMAList`, then sets `dfok`. The wait only burns time when the previous vblank has not finished yet.

`d7` is live for the whole logic frame. Crowd decay, animation frame time, impact fade, and the NTSC/PAL speed scale (`#$11` / `#$16`, then `mulu.w d7,d4` in `updateplayers`) all use it. A slower frame does not freeze the clock: `VBlank` still ticks `gameclock` every vblank unless `gmclock` or pause is set.

Horizontal scoreboard mode (`sfhor`) already skips most of `updateplayers` and rink scroll. Leave that early-out alone.

## What retail already does well

- Collision walks `OOlist` in Y from the moving object and stops past `collrad*2`. That is better than testing every pair.
- `checkcoll` is skipped when X and Y did not change.
- `addframe2` skips tile DMA when `frame` equals `oldframe`, and coalesces consecutive sprites of the same object that share tiles.
- `updatescroll` only queues map rows when the camera crosses an 8-pixel row. Horizontal scroll is just the Hscroll register.
- Crowd tiles stay in VRAM; `showcrowd` only clips sprites into `Satt`.
- `skateto` only does path work every 12 ticks. `findpc` (puck crossing lines) only runs every 5.
- `periodicevents` holds the once-per-`jps` jobs (goalie pull, bench energy, injury box) off the per-frame path.

## Highest impact

### 1. Batch DMA and stop the Z80 once

`DumpSprites` → `dodmalist` → `DoDMA` per list entry. `DoDMA` halts the Z80 (`IO_Z80BUS`), waits for the bus, programs the VDP, starts the transfer, then `WaitDMA` until status bit 1 clears, then releases the Z80. A pile-up with many new animation frames is dozens of transfers, each with its own halt/wait/restart.

On a mod branch:

- Halt the Z80 once around the whole list, not per entry.
- Merge adjacent ROM tile DMAs into fewer, larger transfers (same VRAM dest, contiguous source).
- Do not `WaitDMA` after every kick if the next transfer can be programmed while the previous one runs.

Keep the 64K source-boundary split already in `DoDMA` (the 68000-to-VDP DMA bug). Keep the RAM-source first-word rewrite (the other DMA bug workaround).

This is the main reason the game stutters when several skaters change frames at once.

### 2. Cache sprite tiles in VRAM

`addframe2` re-uploads a player's whole frame whenever the frame number changes, even if that pose was in that object's `VRchar` slot two steps ago. Crowd tiles are already resident; players are the problem.

A small per-object cache (`oldframe` plus “already in this object's `VRchar` slot”) or a tiny global pose cache for the common skate/check frames cuts vblank DMA a lot. Upload on a miss only.

The full sprite attribute table is DMA'd every displayed frame. With at most `MaxSprites` (64) entries that is small next to tile DMA; a dirty flag on `Satt` is not worth it until tiles are under control.

### 3. Cheapen player collision

`checkcoll` is the CPU hotspot. Per moved object it wall-tests the body, then the stick tip (`GetHot` plus a second `checkwallcoll`), walks `OOlist` in Y (`checkplcoll`), and for each nearby pair saves `d0-d7/a0-a3` (`checkcx`) before the circle test (`muls`) and maybe impact/check logic.

The Y-sorted sweep is fine for 12 skaters and a puck. What still hurts:

- Skip the stick wall test unless the player is near the boards or a net.
- Don't `movem` the world in `checkcx`; keep the live registers.
- On a corner hit, `checkwallcoll` calls `Sroot` and two `divs`. A squared-distance / clamp path avoids that except when the bounce normal is needed.
- Nets, puck shadow, and parked players still sit in the 16-object `SortCords` loop. Collision already bails if X/Y did not change; assignment and `loadTeamStruct` still run.

Do not replace the Y-sorted walk with a grid. Pair count is not the stall; register traffic and the extra stick/wall tests are.

### 4. Don't run full AI on every object every frame

Every one of the 16 sort objects, every frame, `updateplayers` does:

```
jsr (loadTeamStruct).l
jsr (a0)    ; assignment from asstab
```

Push the same throttle `skateto` already uses:

- Stagger CPU shot/pass/check searches (`chk4shot`, `chk4pass`, `check4check`) across players (player 0 on frame 0, player 1 on frame 1, and so on).
- Skip `loadTeamStruct` for the puck, the puck shadow, and the nets.
- Keep `findpc` on its 5-tick cadence; apply that pattern to offsides/icing helpers that do not need every logic frame.

### 5. Precompute the per-frame speed scale once

`updateplayers` does this for every object on the ice:

```
moveq   #$11,d4          ; NTSC; #$16 on PAL
mulu.w  d7,d4
...
muls.w  d4,d0
add.l   d0,(a3)          ; Xpos, then the same for Ypos
```

`d4` is the same for the whole frame. Compute it once in `DoGameFrame`. `mulu` is tens of cycles each time.

## Medium impact

**Replay packing every logic frame.** `updatereplay` bit-packs all 16 objects (`replaysize` bytes) every frame, including roster nibbles, puck Z, last SFX, pads, crowd frame, and gloves. Skip it while `sf2drec` is set (already partly there), or record every other logic frame.

**Four-way pad path.** Pads 3 and 4 swap `cont1team` / `cont2team`, hold timers, and `PadControlBits` in and out of pad 1/2 around `doinput`. A `doinput` that takes a pad index drops that stack.

**`cramfade` in gameplay vblank.** It runs every vblank unless `dfng`. During play `palcount` is usually negative and it exits early; keep that. While a fade is active it reads and writes CRAM per color, with `divu.w #3` to pick the component. A 64-word CRAM DMA from a pre-stepped buffer is cheaper and does not punch holes in active display.

**`updatesound` / `Crowd_Noise`.** PSG is rewritten every logic frame even when `asv` did not change. The crowd meter calls `Sroot` every `$14` ticks. Write PSG only on change; keep a squared threshold so the meter does not need a square root.

**Rink row DMA.** `updatescroll` only queues rows on an 8-pixel camera step (good), but each row uses `mulu.w (a0),d0` to find the map pointer. A row-pointer table removes that multiply on pans.

**`setSlotBit`, ice-time, impact fade.** Small. Ice time (`sf3icetime`) is already once per game-second. Leave it.

## Low impact (68000)

The gameplay files are full of `beq.w` / `bne.w` to nearby labels. On 68000, `Bcc.w` is 12 cycles not-taken versus 8 for `.s`. Hot loops in `updateplayers`, `checkcx`, `addframe2`, and the assignment routines shrink for free. Same idea: `moveq #0,dn` instead of `clr.w dn` where the whole register can die, and `jsr (x).w` / `bsr.s` where the target is in range (`loadTeamStruct` is a `.l` from the per-player loop).

Dropping the full `movem.l d0-d7/a0-a6` around `setvideo` / `VBlank` only helps if the caller does not need those registers. Check before cutting it.

These are easy to get wrong while saving little next to DMA and collision. Do them after the high-impact items, or as you touch a routine anyway. New code after the 1MB fill cannot `bsr.w` distant retail helpers; see the short-jump and branch notes in `docs/EXPANDING_THE_ROM.md`.

## What not to spend time on

- Rewriting Y-sorted collision into a spatial hash. Twelve skaters plus the puck is a small set.
- 60 fps as a goal before the tile cache. One vblank is eaten by tile DMA, music, and the Z80 halt even with faster AI.
- Crowd sprite building. `showcrowd` clips in software and does not DMA tiles.
- The horizontal scoreboard path. It already skips the expensive ice work.
- Sega CD crowd/sound. Cartridge `updatesound` writes PSG; the disc path is `docs/segacd_audio.md` and is not this loop.

## Suggested order on a mod branch

1. Z80 halt once per `DumpSprites`, merge tile DMAs.
2. VRAM pose cache so skate cycles do not re-upload every frame change.
3. Collision: skip stick-wall when far from the boards; stop saving all registers in `checkcx`.
4. Stagger CPU AI; skip assignment work on non-players.
5. Hoist the `d7` speed scale; short branches in the player loop as you pass them.

`npm run build:dev` is the build to iterate on (no retail compare, `CHECKSUM=0`). A changed ROM will not match `nhl94retail.bin` and must not be committed to `main`. Boot with `checksum=1` once the image is stable; a red screen means the boot checksum is wrong (`tools/fixrom.js` writes it). How to grow the ROM so the new code has somewhere to live is `docs/EXPANDING_THE_ROM.md`.
