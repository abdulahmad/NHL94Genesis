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
| `STK` | Stack depth in words at the start of the loop. It is not the deepest point inside the frame. |

`LAG` is this frame only. `FPS` is the recent window. A frame can read `LAG:1` and `SL259/262` together: the loop used almost the whole frame and still finished before the next blank. `FPS44` on that same screen means other loops in the last 55 blanks did not.

## What the overlay costs

The overlay costs about 45 scanlines per frame on NTSC, roughly 17 to 19 percent of the frame (about 22,000 to 24,000 cycles at 7.67 MHz, near 3 ms). `CPU` and `SL` do not include it. The sample starts after the draw and ends before the text is formatted, so a frame that reads `SL215` really needs about 260 scanlines. That is why `LAG` and `FPS` can look worse than `CPU` suggests.

| Piece | Scanlines (approx.) |
| --- | --- |
| Counter reads, stack check, FPS bookkeeping | 2 |
| Formatting the text: about 27 digits, each a `divu.w` by 10, plus the CPU percent divide | 14 |
| Blanking four window rows (128 video-memory writes) | 6 |
| Writing the three text rows (84 writes) | 20 |

Each divide and each counter read is under a scanline, but there are about 30 divides a frame. The cycle counts are hand totals from 68000 instruction timings, not measured.

The draw (blank plus text, about 212 writes, 27 to 30 scanlines) runs with the "don't touch the video chip" flag (`dfng`) set. It only runs when `dfok` is clear, meaning no frame is queued, and `dfok` is not set again until the end of `setvideo`. A vertical blank that lands in the draw therefore has no sprite or tile transfer to skip. It skips only the palette fade for that blank. The clock, the frame counter and the music still run.

A blank can only land in the draw if the previous loop finished 230 or more scanlines after a blank, so a loop about two frames long. Then the chance is about 28 in 262, near 11 percent. A loop that makes every blank, or overruns by a little, starts its draw just after a blank and never overlaps the next one.
