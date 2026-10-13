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

The hook is `play_sfx_or_music_track`. Sound effects stay on the FM driver. A song (`$30`–`$7A`) still runs its event stream, so the cartridge arrangement ends on its own, but while CD Music is On those events do not key the FM chip.

| Song | Where | Track | How |
| --- | --- | --- | --- |
| `$30`–`$77` | in-game organ, from `ChooseSong` | `id - $29` (7–78) | play once. Same numbers `cdrequest.asm` stores, and the same `MSCPLAY1` the disc uses |
| `$78` | title | 4 | loop. Splash and main menu. VLC lists this recording as track 3 |
| `$79` | intermission / end of game | 5 | loop. VLC lists this recording as track 4 |
| `$7A` | scouting report | 3 | loop. The disc ignores `$7A`. Track 3 is the second music track; track 1 is data |

The opening faceoff and the goal song are in `$30`–`$77`. The whistle (`Stop4Pen`) and the goal's `stop_current_song` do not pause them, and the FM arrangement ending does not start the crowd over them. The recording plays until the driver pauses it, and the next `updatesound` then starts track 2, looped. Another song, or `p_turnoff` (pause and the other full silences), still takes the voice. Title, intermission, and scouting still loop, and `stop_current_song` still pauses those.

Track 2 is the crowd bed, the same track `cdtrack.asm` forces when the drive is no longer on a track at or above 7. `updatesound` still writes the PSG noise channel on every call, whether CD Music is On or Off. While an organ song owns the CD voice, the PSG crowd is the one underneath it. When the organ track is paused, the game starts track 2 and the two crowds play together. The CD voice stays at volume 255, the top of the 0–255 range, for the song and for the bed. MSU-MD has one CD-DA voice, so a song replaces the bed.

The MSU driver is enough for this. It is not the Sega CD BIOS, and it does not need to become one. Command `$11` already pauses when a track finishes, which is what `MSCPLAY1` does. The driver pauses about two seconds before the next disc track so the following organ recording does not leak out, writes 1 to `$FF8021` (the main CPU reads that as `$A12021`), and stops. It does not choose the next track. `updatesound` sees that 1, drops the song's hold, and sends a normal play-loop of track 2. That is the same handoff `cdtrack.asm` makes after the BIOS has paused. Starting the crowd from inside the CD interrupt is what wedged the sub CPU, so pause stopped working and the drive ran into the next organ track. Looping tracks still use the driver's own end check. If the voice is free and track 2 is not already playing, `updatesound` starts it. That is also what happens after pause. Accepting a new command clears the byte. The PSG crowd has been running the whole time. The two-second margin can clip the tail of a long organ track; the pause itself is the driver's own end-of-track pause.

`p_turnoff` pauses the CD voice, including a play-once track. The bed starts again from `updatesound` once play resumes and no song is running.

## Disc layout

The play argument is the cue track number, decimal, the same numbering as the Sega CD: track 1 is the data track and is never played. Point the MegaSD MSU cue at that disc (or a cue with the same track numbers). The driver binary is `src/msu/msu-drv.bin` from krikzz/msu-md, MIT, included in the ROM and called from `Begin`.
