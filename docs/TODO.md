# TODO

## Cleanup / 93G alignment (user, Oct 20 2026; to prioritize)

- initialsp becomes stack: done. ram94.asm is included after main94.asm and Stack is set with `=` in both, as in 92 and 93
- look into teamdata null/notiles -- how was it in 92: done, `NoTiles` is now 92/93 `null`
- RAM: src/ram94.asm is the 93G rs form; size the gaps (each name runs to the next one). Partly done: SortCords (puck fields as 93G equates), tmstruct / awtmstruct (tmsize), puckcross, gstruct. Still sized to the next name: Joy1Struct, sso, pads, TempBuffer, ThreeStars, picturebuf, PALflag (to Stack) and others with no 93G counterpart
- where did 93G stats report go? Answer: 92 penalty.asm and 93 stats93.asm `StatsReport` is in period94.asm (`StatsReport`, the Game Statistics screen), in the new-in-94 code near the end of the ROM
- move 93G replay to its own file?
- does input make sense, and if so, bring it to 93g?
- does assign make sense, and if so bring to 93g?
  - assign ends early, checks stuff goes into assign
- does video make sense, and if so bring to 93g?
- bring decompress and print to 94G: done, decompress94.asm and print94.asm (included at the end of video94 as 93G middle93 does)
- does collide make sense, and bring to 93G?
- does display make sense, and if so bring to 93G?
  - what differentiates video and display? hardware level?
- bring setup94 to 93G?
- attract94: done, it holds EASportsScreen only; the option screen helpers open data94. The routine before it (setup94 ScrollDisplayUp, scouting text) is not attract code
- is data.asm make sense, and if do bring to 93G
- equate SRAM functions
- ReadJoyData isn't matching from 94G to 93G

## Open (added 2026-10-21)
- [ ] Triage branches with open PRs: `feature/msu-md-music` (was `cursor/msu-md-music-64b6`, #10), `feature/season-mode`, `patch/teamblock-vram`, `patch/perf-stats`. See `docs/BRANCHES.md`.
- [ ] Module split, pending review of the improved 93G split.
- [ ] Comment pass: carry the 93G full comment pass here once 93G is done (awaiting go-ahead).
- [ ] Raw value: analyze `tst.w 2(a0)` in stats94 (different struct; not yet named).
- [x] Build auto-sizes the ROM (`tools/fixrom.js`).
- [x] README credits chaos, StaticEck, McMarkis and Drezz.
