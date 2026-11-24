# TODO

Open items only. Branch triage (season mode, MSU-MD, perf stats, team-block VRAM) is in [BRANCHES.md](BRANCHES.md).

## 93G alignment questions (user, Oct 20 2026; to prioritize)

- RAM: `src/ram94.asm` is the 93G rs form; size the gaps (each name runs to the next one). Still sized to the next name: Joy1Struct, sso, pads, TempBuffer, ThreeStars, picturebuf, PALflag (to Stack) and others with no 93G counterpart.
- move 93G replay to its own file?
- does input make sense, and if so, bring it to 93g?
- does assign make sense, and if so bring to 93g?
  - assign ends early, checks stuff goes into assign
- does video make sense, and if so bring to 93g?
- does collide make sense, and bring to 93G?
- does display make sense, and if so bring to 93G?
  - what differentiates video and display? hardware level?
- bring setup94 to 93G?
- is data.asm make sense, and if do bring to 93G
- equate SRAM functions
- ReadJoyData isn't matching from 94G to 93G

## Open

- [ ] Module split, pending review of the improved 93G split.
- [ ] Comment pass: carry the 93G full comment pass here once 93G is done (awaiting go-ahead).
- [ ] Raw value: analyze `tst.w 2(a0)` in stats94 (different struct; not yet named).
