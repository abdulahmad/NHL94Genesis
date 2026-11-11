# NHL 94 Sega CD: sub CPU memory map

`HOCKEY.BIN` runs at `$1B000` in sub CPU program RAM. A HOCKEY.BIN file offset plus `$1B000` is its runtime address. The file is `$2D20A` bytes, so it spans `$1B000`-`$48209`. The `$37xxx`-`$39xxx` call targets are therefore HOCKEY.BIN itself (file `$1C000`-`$1EFFF`): `middle94`, `decompress94` and `print94` code. There is no second image and no copy loop.

## Evidence

| What | Shows |
| --- | --- |
| `STARTER.BIN` boot (`src/segacd/subboot.asm`) | passes `$1B000` to the BIOS at `$6044`, then `jmp $1B000` |
| HOCKEY.BIN file `$0` | `jmp $22096`: file `$7096`, the game start |
| HOCKEY.BIN file `$7096` | `movea.l #$C458,sp`, then clears `$1745C`-`$1AD99` (the game variables) |
| HOCKEY.BIN file `$C`-`$7B` | 28 team record pointers (`$1FD8C` Anaheim first, `$1B07C` All Stars East = file `$7C`): the cartridge `TeamList` with `$1B000` added |
| `printsmall` | called at `$38D9E`; file `$1DD9E` has the cartridge `printsmall` (`$11A48`) opening: save `disflags`, set bit 2, `movem.l d0-d3/a0/a2-a3,-(sp)` |
| crowd frame table | `updatecrowdf` loads `#$4154C`; the table is at file `$2654C` (`src/segacd/crowdtable.asm`) |
| every HOCKEY.BIN fragment in `src/segacd/hockey/` | assembled at `org $1B000+offset`; absolute operands then match the disc |

## Map

| Runtime | What |
| --- | --- |
| `$0000`-`$5FFF` | sub CPU BIOS (HOCKEY.BIN calls `$5F22` directly) |
| `$6000`-`$A4DD` | the disc's system program (`src/segacd/boot/sp.asm`, `docs/segacd_boot.md`): SegaOSCall at `$6044` (service number in `d7`), the services, a PCM driver, the SDK film player |
| `$B090` | the boot keeps the BIOS vector from `$6038` here |
| up to `$C458` | stack (grows down from `$C458`) |
| `$C000`-`$ED93` | the sub CPU driver module from STARTER.BIN (file `$1000`-`$3D93`, runtime = file + `$B000`) |
| `$1745C`-`$1AD99` | game variables. The cartridge's `$FFxxxx` RAM names live here; `src/segacd/hockey/hockey.inc` lists each one found so far |
| `$1B000`-`$48209` | `HOCKEY.BIN`. File `$2CD00`-`$2CDAB` (`$47D00`-`$47DAB`) is zeros on the disc: a table of graphics pointers filled at run time, read where the cartridge used ROM labels (`movea.l $47D74,a0` for `movea.l #SetupMenuMap,a0`) |
| `$FF8000`-`$FF80xx` | gate array: `$FF800E` main CPU flag, `$FF800F` sub CPU flag, `$FF8010` main-to-sub words, `$FF8020` sub-to-main command words |

The RAM is not the cartridge layout moved by a constant: `printx` (`$FFB028`) is `$18D58` but `disflags` (`$FFBF78`) is `$18D64`. Each name is placed from a disc operand, never by offset.

The team struct is one word longer than the cartridge's. Every offset from `tmap` on is two more (`tmap` `$26`, `tmgoalie` `$28`, `tmteam` `$2A`, `tmgoals` `$B6`, `tmpshots` `$EA`, `tmHotCold` `$1A4`, `tmPerGoals` `$344`, the game-statistics rows in `period94`, `tmsize` `$366`); `tmdata` (`$1E`) and everything below it are unchanged. The extra word is therefore between `$1E` and `$24`, where the cartridge has `tmsort`, a word holding a RAM address (`$FFxxxx` in short form). On the sub CPU the RAM is above `$FFFF`, so `tmsort` is a long there: every cartridge `movea.w tmsort(aN),aM` (collide94, logic94) is `movea.l $22(aN),aM` on the disc (13 sites, CD lines of collide94, collide94_2 and logic94). `hockey.inc` notes every struct offset whose disc value differs.

## Open

On the main CPU, `MAIN.BIN` runs at `$FF1000`-`$FFFBFF` (file + `$FF1000`; `docs/segacd_main_shell.md`): its `$EC00` bytes end exactly at `$FFFC00`, the stack top MainShellEntry sets, and the file ends in zeros.

`STARTER.BIN` runs at `$B000`-`$285B7` (file + `$B000`; `docs/segacd.md`). Its tail code jumps back to the boot at `$B00E`, which loads HOCKEY.BIN at `$1B000` with BIOS function 0, over STARTER's top part (file `$10000` on), and jumps to it. The driver module (`$C000`-`$ED93`) and the C part below `$1B000` stay. What the driver module does for each BIOS function (`$6044`, d7) is not traced.
