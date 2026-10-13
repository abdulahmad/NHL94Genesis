# MSU-MD music on the cartridge

`npm run build:msu` (or `MSU=1` with `build94.bat`) assembles a 2 MB cartridge ROM that plays Sega CD audio through the [MSU-MD](https://github.com/krikzz/msu-md) registers. `npm run build:retail` does not include that code. The retail ROM stays byte-identical to `lst/nhl94.bin`.

On Linux, with the retail ROM already extracted:

```
export NHL_PREBUILD_DONE=1 WINEDEBUG=-all
wine cmd /c "set rev=0&& set checksum=0&& set MSU=1&& build94.bat"
node tools/fixopcodes.js "output/nhl94 .lst" output/nhl94.bin
```

The ROM is `output/modified_nhl94.bin`. Checksum validation is off, the same as `build:dev`, so the expanded ROM boots. The header ROM end is `$1FFFFF`.

Boot can sit on a black screen for a few seconds while the driver looks for the Mega CD and reads the track list. The title screen asks for the CD song before it draws the pictures, so the seek runs during that work and the track is going when the image fades in. The FM arrangement still starts at the later song call, the same moment as the retail ROM, and that call does not restart a loop that is already playing. If the track list is still being read, the FM arrangement stays silent and the CD track starts when the list is done. The same track keeps playing into the main menu. If CD Music is still Off after the title has been up for a while, the cue's `FILE` lines do not match the bin filenames in that folder. Renaming the cue does not rename the files it points at.

The options screen has a **CD Music** line under Line Changes (scroll down; Shootout jumps there from Goalies). **On** plays the disc. **Off** is the cartridge FM. The choice is kept for the session. If the driver does not find a Mega CD, the line stays Off and FM plays.

## What plays

The hook is `play_sfx_or_music_track`. Sound effects stay on the FM driver. A song (`$30`–`$7A`) still runs its event stream, so the cartridge arrangement ends on its own, but while CD Music is On those events do not key the FM chip.

| Song | Where | Track | How |
| --- | --- | --- | --- |
| `$30`–`$77` | in-game organ, from `ChooseSong` | `id - $29` (7–78) | play once. Same numbers `cdrequest.asm` stores, and the same `MSCPLAY1` the disc uses |
| `$78` | title | 4 | loop. Asked for before the pictures are drawn, so the seek overlaps that work. Splash and main menu. VLC lists this recording as track 3 |
| `$79` | intermission / end of game | 5 | loop. VLC lists this recording as track 4 |
| `$7A` | scouting report | 3 | loop. The disc ignores `$7A`. Track 3 is the second music track; track 1 is data |

The opening faceoff and the goal song are in `$30`–`$77`. Leaving the pre-game screen pauses its song, and the period organ is requested before the rink is drawn, so that seek runs while the screen fades and the crowd bed does not play in the gap. The later song call still starts the FM arrangement and does not start the CD track again. The whistle (`Stop4Pen`) and the goal's `stop_current_song` do not pause them, and the FM arrangement ending does not start the crowd over them. Each of those songs plays for the USA redump length of its disc track, one second short, and the next `updatesound` then starts track 2, looped. Another song, or `p_turnoff` (pause and the other full silences), still takes the voice. Title, intermission, and scouting still loop, and `stop_current_song` still pauses those.

Track 2 is the crowd bed, the same track `cdtrack.asm` forces when the drive is no longer on a track at or above 7. `updatesound` still writes the PSG noise channel on every call, whether CD Music is On or Off. While an organ song owns the CD voice, the PSG crowd is the one underneath it. When the timed song ends, the game starts track 2 and the two crowds play together. The CD voice stays at volume 255, the top of the 0–255 range, for the song and for the bed. MSU-MD has one CD-DA voice, so a song replaces the bed.

Those lengths are the USA redump (serial T-50015, 79 tracks). The time is `sectors * 60 / 75` NTSC frames, minus 60 frames so the switch happens about one second before the next disc track. BlastEm does not let the cartridge read the CD position, which is why the earlier end-of-track flag never started the crowd. Counting frames does not need that position, and it does not ask the CD interrupt to start the next track. The same numbers are reliable for that disc and that 60 Hz clock. A different pressing, or a 50 Hz machine, runs long or short by however much its track lengths or frame rate differ. Looping tracks still use the driver's own end check. If the voice is free and track 2 is not already playing, `updatesound` starts it. That is also what happens after pause. The PSG crowd has been running the whole time.

`p_turnoff` pauses the CD voice, including a play-once track. The bed starts again from `updatesound` once play resumes and no song is running.

## Disc layout

The play argument is the cue track number, decimal, the same numbering as the Sega CD: track 1 is the data track and is never played. Point the MegaSD MSU cue at that disc (or a cue with the same track numbers). The driver binary is `src/msu/msu-drv.bin` from krikzz/msu-md, MIT, included in the ROM and called from `Begin`.
