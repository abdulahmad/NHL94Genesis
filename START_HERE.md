# NHL 94 Genesis

Byte-matching SNASM68k source for the retail cartridge. A stock build matches `lst/nhl94.bin`.

Read `SEGMENT_AGENT.md` (the Current rules) and `docs/HANDOFF.md` before editing. `docs/EXPANDING_THE_ROM.md` covers growing the ROM and adding a team.

## Build

`npm run build:retail` (or `node tools/build.js retail`) runs the whole build and prints one line per step; `npm run build:dev` (`node tools/build.js dev`) builds with `CHECKSUM=0` and skips the verify. Linux needs wine and wine32 (`build.js` runs the assembler under wine); Windows runs it directly. Add `--verbose` for each step's full output.

```
[1/6] prebuild   check the retail ROM and extract graphics/sound assets into Extracted/
                 ROM OK, 474 assets extracted
[2/6] z80        asm80 builds the Z80 sound driver from src/sound/z80_snd_drv93.asm and checks it against the ROM bytes
                 MATCH 651 bytes (except the FM patch address at $278-$27C) == ROM $1AD90-$1B01A -> output/build/z80_snd_drv93.bin
[3/6] assemble   SNASM68k turns src/*.asm into a raw ROM image
                 0 errors, 0 warnings, 71412 lines in 0.17s (CHECKSUM=1) -> output/build/nhl94.raw.bin
[4/6] fixopcodes patch the instructions where SNASM picks a different encoding than EA's original assembler
                 473 opcodes fixed
[5/6] fixrom     pad to a valid ROM size, write the header end address and the checksum
                 size $00100000, header end $000FFFFF, checksum $8AB9F121
[6/6] verify     compare byte-for-byte with the retail ROM
                 MATCH output/nhl94.bin
```

### Build steps explained

1. **prebuild**: check the retail ROM and extract graphics/sound assets into `Extracted/`.
2. **z80**: asm80 (npm devDependency, pinned in `package.json`; `npm i` installs it) assembles the Z80 sound driver `src/sound/z80_snd_drv93.asm` (93's driver, same bytes) into `output/build/z80_snd_drv93.bin` and checks it byte-for-byte against the ROM bytes at `Z80_Program_Code`, which the prebuild extracts to `Extracted/NHL94/Sound/z80_snd_drv93.bin` only for this check. The FM patch address operands (Z80 `$278`-`$27C`) are skipped: `src/sound/sound94.asm` writes them from `fm_instrument_patches` and includes the assembled file around them.
3. **assemble**: SNASM68k turns `src/*.asm` into a raw ROM image.
4. **fixopcodes**: patch the instructions where SNASM picks a different encoding than EA's original assembler.
5. **fixrom**: pad to a valid ROM size, write the header end address and the checksum.
6. **verify**: compare byte-for-byte with the retail ROM.

A failing step prints `FAILED`, the relevant log lines (`output/build/Build_nhl94.log` for the assembler) and `BUILD FAILED at <step>`, and exits 1. `tools/verify_all.sh` builds the full ROM and every segment and prints `ALL MATCH`.

`checksum=1` runs ValidationRoutine at boot. The fixrom step writes the sum it compares against, so a changed ROM still boots with the check on. `checksum=0` skips the check. The checksum segment is left on the retail immediate so it still matches.

## Growing the ROM

`main` stays a faithful retail disassembly. `tools/fixrom.js` pads a larger image to 1.5MB, 2MB or 4MB, sets the header ROM end and fixes the checksum; `src/shortcalls.inc` stops the build if a short-called routine moves past $7FFF. Short jumps, save RAM past 2MB, bank switching and the team checklist are in `docs/EXPANDING_THE_ROM.md`.
