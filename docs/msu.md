# MSU-MD music on the cartridge

`npm run build:msu` (or `MSU=1` with `build94.bat`) assembles a 2 MB cartridge ROM that plays Sega CD audio through the [MSU-MD](https://github.com/krikzz/msu-md) registers. `npm run build:retail` does not include that code. The retail ROM stays byte-identical to `lst/nhl94.bin`.

On Linux, with the retail ROM already extracted:

```
export NHL_PREBUILD_DONE=1 WINEDEBUG=-all
wine cmd /c "set rev=0&& set checksum=0&& set MSU=1&& build94.bat"
node tools/fixopcodes.js "output/nhl94 .lst" output/nhl94.bin
```

The ROM is `output/modified_nhl94.bin`. Checksum validation is off, the same as `build:dev`, so the expanded ROM boots. The header ROM end is `$1FFFFF`.

Boot can sit on a black screen for a few seconds while the driver looks for the Mega CD and reads the track list. The splash asks for its song before that read finishes. The FM arrangement stays silent, and the CD track starts when the list is done, still on the splash. The same track keeps playing into the main menu. If CD Music is still Off after the title has been up for a while, the cue's `FILE` lines do not match the bin filenames in that folder. Renaming the cue does not rename the files it points at.

The options screen has a **CD Music** line under Line Changes (scroll down; Shootout jumps there from Goalies). **On** plays the disc. **Off** is the cartridge FM. The choice is kept for the session. If the driver does not find a Mega CD, the line stays Off and FM plays.

## What plays

The hook is `play_sfx_or_music_track`. Sound effects stay on the FM driver. A song (`$30`–`$7A`) still runs its event stream, so it ends when the cartridge song ends, but while CD Music is On those events do not key the FM chip. The CD track loops until that stream ends or `stop_current_song` / `p_turnoff` runs.

| Song | Where | Track | How |
| --- | --- | --- | --- |
| `$30`–`$77` | in-game organ, from `ChooseSong` | `id - $29` (7–78) | loop until the FM stream ends. Same numbers `cdrequest.asm` stores |
| `$78` | title | 4 | loop. Splash and main menu. VLC lists this recording as track 3 |
| `$79` | intermission / end of game | 5 | loop. VLC lists this recording as track 4 |
| `$7A` | scouting report | 3 | loop. The disc ignores `$7A`. Track 3 is the second music track; track 1 is data |

Track 2 is the crowd bed from `cdtrack.asm` (the track it forces when the playing number is below 7). `updatesound` still writes the PSG noise channel, and it also loops track 2 whenever no song owns the CD voice. Both crowds are heard together during play. MSU-MD has one CD-DA voice, so a song replaces the bed until the song stream ends, and the PSG crowd keeps going under the song.

`p_turnoff` (pause, period start, silence) pauses the CD voice. The bed starts again from `updatesound` once play resumes and no song is running.

## Disc layout

The play argument is the cue track number, decimal, the same numbering as the Sega CD: track 1 is the data track and is never played. Point the MegaSD MSU cue at that disc (or a cue with the same track numbers). The driver binary is `src/msu/msu-drv.bin` from krikzz/msu-md, MIT, included in the ROM and called from `Begin`.
