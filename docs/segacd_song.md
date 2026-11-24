# Song and sfx

`HOCKEY.BIN` is entered at `$1B000` (`src/segacd/starter/subboot94cd.asm` jumps there). A `jsr` absolute in the game is file offset plus `$1B000`.

| Runtime | File | Cartridge | Disc |
| --- | --- | --- | --- |
| `$3710C` | `$1C10C` | `sfx` | `src/segacd/hockey/middle94cd.asm`. Posts the id to the main CPU |
| `$37174` | `$1C174` | not in the cartridge | `src/segacd/hockey/middle94cd.asm`. Command `$34` on flag bits 3 and 4 |
| `$371D2` | `$1C1D2` | `song` | `src/segacd/hockey/middle94cd.asm`. Turns `$30`–`$77` into a CD track |

All three end the way the cartridge `sfx` and `song` end: pop the saved register, copy the return address down over the word argument, and `rts`.

## song

`song` reads one word from the stack. `$30` through `$77` stores `1` at `$1745C` and stores `argument - $29` at `$1745E` (tracks `$07` through `$4E`). Any other word returns without writing either. `src/segacd/hockey/middle94cd.asm` is what later plays `$1745E`.

Five calls, all `jsr $371D2`:

| File | Argument | What happens |
| --- | --- | --- |
| `$D312` | immediate `$7A` | Scouting. `$7A` is `SngScouting`. It is above `$77`, so this call does not store a track |
| `$245D2` | immediate `$79` | End of game. `$79` is `fmtune_eop`. Same: no track is stored |
| `$10B24`, `$10CE6` | word at `$1A56A` | `$10B24` is `src/segacd/hockey/hockey94cd.asm`. After `song` returns it copies `$1745E` to `$19364`, `MSCPLAY1`s that word once, and sets `$1745C` to `$FFFF` |
| `$10BD6` | word at `$1AD70` | `song` only. No `MSCPLAY1` at this site |

`src/segacd/hockey/hockey94cd.asm` is the one place a call to `song` is followed immediately by the BIOS play. The track it plays is whatever was already in `$1745E` when the argument was outside `$30`–`$77`, or the track `song` just stored when the argument was inside that window.

## sfx

`src/segacd/hockey/middle94cd.asm` is the cartridge `sfx` with the FM call removed. A negative id returns. Otherwise the id is saved at `$17F64` (cartridge `lastsfx`) and written to `$FF8022`, and command `$26` is posted to `$FF8020` with the bit-6 handshake. Six sites call `$3710C`. One of them is the horn: file `$10E8E` pushes `$4` and calls it. That `$4` is cartridge `SFXhorn`.

The main CPU loop at `$FF3622` waits on bit 6, reads `$A12020`, and calls the handler at `$FF471C` indexed by that command. The table is zero in the file. The static handler list sits at `$FF371C`, 64 longs. Command `$26` is past the first command table at `$FF01BE`, which stops at `$1E`.

## Command $34

`src/segacd/hockey/middle94cd.asm` writes the stack word to `$FF8028` and posts `$34` to `$FF8026`, handshaking on flag bits 3 and 4 instead of bit 6. The main CPU loop at `$FF38AE` reads `$A12026` with those same bits and uses the same `$FF471C` handler table. No `jsr $37174` is in `HOCKEY.BIN`, `STARTER.BIN`, `MAIN.BIN`, or `PLAYER.BIN`.
