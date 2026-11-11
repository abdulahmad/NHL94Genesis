# Scouting report and the announcer

The scouting screen is still the cartridge matchup page. It draws the Ron Barr picture, types a script, and pages the six position matchups. The script text and the song number are on the disc. The body of `song` is not.

## Song $7A

`scoutopen.asm` (`HOCKEY.BIN` `$D2B6`) is the start of `ScoutingReport`. It saves the old stack at `$47D00` and points `a7` at `$1745C` (the same word the CD track selector uses as its change flag). It relocates four pointers that were built against a base of `$C458`, calls `$2262E` and `$231A0`, clears the matchup at `$1A446`, then:

```
move.w  #$7A,-(sp)
jsr     $371D2.l
```

`$7A` is the cartridge `SngScouting`. On the cartridge that id is the FM stream `fmtune_scouting` in `sound94.asm`, the last entry of `SoundStreamTable`. `$371D2` is `song`. The cartridge `song` saves every register, reads the word at `64(sp)`, and calls `play_sfx_or_music_track`.

`HOCKEY.BIN` is entered at `$1B000`, so `$371D2` is file `$1C1D2`, `cdrequest.asm`. It is the disc's `song`. `$79` and `$7A` are above its `$30`–`$77` window, so those two calls do not store a CD track. The same address is called from five sites:

| Call | Argument |
| --- | --- |
| `$D312` | immediate `$7A` (scouting) |
| `$245D2` | immediate `$79` (cartridge song `$79` is `fmtune_eop`) |
| `$10B24`, `$10CE6` | the word at `$1A56A` |
| `$10BD6` | the word at `$1AD70` |

`cdrequest` (`$1C1D2`) only stores a track when its argument is `$30` through `$77`. `$79` and `$7A` are above that window, so the track selector will not turn the scouting song into a CD track. The two calls that then `MSCPLAY1` the word at `$1745E` are the `$1A56A` sites, after `song` returns.

No sub CPU file writes the Z80 bus, the YM2612, or the PSG. `MAIN.BIN` still has the Z80 loader at `$FF76C8`: it stops the Z80, accepts a block whose first byte is `$C3`, copies it to `$A00000`, and resets eight sound slots to `$FFFFFFFF`. That is the cartridge sample path, moved to the main CPU. `MAIN.BIN` does not contain the immediate `$7A` as a song check, and it does not contain `song`'s prologue.

## The script

`GRAPH2.BIN` begins with 23 long offsets. The first chunk is `$5C` through `$F016` (61,370 bytes) and it is the script. It opens:

```
Welcome to a sold out ^, home of the =.
Hi, I'm Ron Barr for EA Sports.
And in goal tonight, [ for { and ] for }.
```

The later chunks are picture and tile blocks, not PCM. The credit line `Announcer:` / `Ron Barr` is in `STARTER.BIN` at file `$1B032`, in the credits text, next to `Player Ratings:` and `Player Card Photos:`.

`scouttext.asm` (`$2486C`) is `InitScoutingDisplay` plus the word typer (`UpdateScoutingDisplay`).

| Disc | Cartridge role |
| --- | --- |
| `$1A450` | line scroll, set to `$FFFF` |
| `$1A452` | script cursor, set to `$FF00` |
| `$1A454` | paragraph index |
| `$1A456` | type delay. `$0A` per word, plus `$28` on comma or period, plus `$14` on a run of spaces. `$1000` or more pauses the typer. `$7FFF` means the script ended |
| `$1A458` | screen timer, set to `$1E0` when the script ends |
| `$1A45A` | paragraph list. A negative word ends it |
| `$47CFC` | base of the loaded script |
| `$17462` | byte offset into that script |
| `$17EF2` | the word just typed, as a counted string |

A `!` (`$21`) skips three bytes. In the GRAPH2 script those three bytes are the `!` and the CR/LF after a wrapped line, so the sentence continues. The other special bytes are handled in `scouttok.asm`:

| Byte | Call | What the cartridge routine returns |
| --- | --- | --- |
| `@` `$40` | `$281D4` | crowd record |
| `#` `$23` | `$2ADB2` | "played by" the home name |
| `%` `$25` | `$2AE5A` | "played by" the away name |
| `=` `$3D` | `$29164` with `$1834C` | home nickname |
| `*` `$2A` | `$29164` with `$186B2` | away nickname |
| `^` `$5E` | `$291AA` with `$1834C` | home arena |
| `;` `$3B` | `$291AA` with `$186B2` | away arena |
| `<` `>` `\|` `\` | `$23132`, `$23168`, `$2328E`, `$232C4` | hot and cold players |
| `$` `[` `]` `{` `}` `_` `+` | walks a team or player record | the name that follows |

The typer then calls `printz` (`$1DF6E`) with the inline string whose length word is `$0006`: flag `$FF` (`CC_Font1`), x `9`, y `4`. It adds the attribute counter `$1A44E` to print x and the line scroll to print y, calls `print` (`$1DF80`), and adds the word length to the attribute counter.

`ScrollDisplayUp` is the tail of `scouttok.asm`. At seven lines it calls `$379D6` eight times to scroll the text window. Nothing in the typer, the token handlers, or the scroll calls `_CDBIOS` or the PCM stream.

`scoutload.asm` (`$24C12`) is the loader just after that scroll. It stops where `cdstart.asm` begins (`$24D66`). It tests `$3FC0A` and, when it is set, calls `$376F2`. It then calls the SDK entry `$6044` with `d7 = $D`, then with `d7 = 1` and `d0 = 0`, then with `d7 = 3`. It adds the returned pointer to a run of longs. Those longs become `$47CFC` (the script base) and the picture and font pointers the screen uses (`$47D54` is the Ron Barr picture the open path draws). The words it relocates are the directory of the file the SDK returns for id 0.

## The speech

The CD reads the script aloud: the main loop of ScoutingReport (`scout94_2.asm`) plays one clip of Ron Barr's voice for each paragraph it types. `.L289EC` turns the paragraph number into the paragraph's byte offset in the script and its line number (lines that end in `!` continue a paragraph, and count). Paragraph `$1A` becomes `$EA` + HomeTeam; when the home team is an all-star team (`$1A`, `$1B`) it becomes `$104`, or `$105` when the visitors are one too.

The line number picks an entry in ScoutingSpeechClips (resource 0 piece 3, `ScoutingSpeechClipsPtr` at `$47DA4`; `scoutopen.asm` copies it to `$C458` and points the entry there). It has 1,120 entries of two longs, a start sector and a sector count, and they are the disc's speech files:

| Entries | File |
| --- | --- |
| 198 | entry n is `RON` n+1 `.PCM` (`RON0034.PCM` for entry 33, the "Hit the start button" paragraph `$21`) |
| 893 | `RON0028.PCM`, for lines with no recording of their own |
| from 1,092 | the team names, `ANAHEIM.PCM` ... |

For each paragraph, service 6 gives LoadPointer, service 0 reads the clip there, and service `$10` sends the system program's PCM driver command 9 (PlayPcmStream, `docs/segacd_boot.md`) with a0 = the clip, d1 = `$400` (`$380` for lines `$5A`, `$97`, `$392`, `$3F1` and `$405`), d2 = `$FF` and d3 = `$FFFF`. While it plays, BIOS function `$18` is called with a0 at `$47D60`, which holds the next paragraph's start sector minus 2 (a seek ahead). When the typer has finished a paragraph (the script cursor back at `$FF00`), the loop goes back and asks command 9 (a0 = 0) until the clip has ended (the driver turns the stream off at its end byte), stops the stream (a0 = -1), and starts the next paragraph and its clip, so the voice and the text keep together. When bit 1 of `$1AD77` is set the clip is not played and each pass of the loop stops the stream; leaving the screen stops it too.

## What is not this screen

`FilmOpen` / `FilmTask` / `FilmClose` in `STARTER.BIN` (runtime `$25636`, `$2588C`, `$25A3A`) are the movie player. `FilmTask` calls the `SM` copier when a chunk's first word is `$534D`. That copier does not touch the PCM chip. The scouting typer does not branch to those routines. Digitized movie audio and the scouting script are different callers of different code. `docs/segacd_film.md`.
