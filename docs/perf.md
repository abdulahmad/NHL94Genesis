# On-screen performance overlay

`npm run build:perf` builds `output/nhl94-perf.bin`. It is a mod ROM. `npm run build:retail` does not include this code, and a retail build still matches the cartridge.

The overlay is `src/perf94.asm`, included after the 1 MB fill in `src/nhl94.asm`, so the retail addresses below `$100000` stay put. Calls from the game into that code are `jsr (label).l`. Checksum validation is off, the same as `build:dev`, so the larger image boots.

The first 90 game frames of each period draw nothing. That covers the faceoff fade. After that, three lines sit on the window plane (map 3) across the top four rows. The rink maps are not written. Pause, the intermission, and the return to the title turn the window back off.

## What the lines mean

The sample is the main loop in `DoGameFrame`: from `PerfOnFrame` to `PerfAfterVideo`, which is after `setvideo`. The vertical blank is not part of the scanline count.

| Field | Meaning |
| --- | --- |
| `CPU` | Scanlines used by that loop, times 100, divided by the frame length. 262 on NTSC, 312 on PAL. |
| `SL` | Scanlines it took to process the frame divided by number of scanlines. |
| `MAX` | The largest `SL` since the period started. It does not reset. |
| `FPS` | Game loops that finished during the last 55 vertical blanks (45 on PAL). 55 is one loop per blank, about 60 fps. |
| `SP` | Sprite list size in words. A sprite is 4 words, and the hardware limit is 80 sprites. Sprite hardware limit in words would be 80 * 4 = 320. |
| `DM` | DMA transfers queued for this frame. |
| `LAG` | Vertical blanks between the start of the previous loop and the start of this one. 1 means this loop caught the next blank. 2 or more means a blank was skipped. |
| `VB` | Reserved for how long the vertical blank itself ran. Nothing samples it, so it stays 0. |
| `STK` | Stack depth in words at the start of the loop. It is not the deepest point inside the frame. |

`LAG` is this frame only. `FPS` is the recent window. A frame can read `LAG:1` and `SL259/262` together: the loop used almost the whole frame and still finished before the next blank. `FPS44` on that same screen means other loops in the last 55 blanks did not.

## What the overlay costs

The divides and the counter reads are under a scanline. Drawing the three lines is not. Each frame blanks four window rows and writes the text, on the order of 200 video-memory writes, while the "don't touch the video chip" flag is set. If a vertical blank lands in that draw, that blank skips the sprite and tile transfer.

The scanline sample starts after the draw, so `CPU` and `SL` do not include the overlay. The numbers are a bit worse than the retail game, and they are not the retail game's own cost.
