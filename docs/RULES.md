# Rules (94G)

The rules for this repo's part of the alignment, then the learned rules. Read before every unit. Any tool adds a learned
rule in the same commit as the fix that confirmed it, newest last: `- YYYY-MM-DD <area>: <rule>. (<evidence>)`.

## Who decides what (all games)

| Category | Decided by |
|---|---|
| Name of a routine several games share | the earliest game that has it (92G is the root); a fix goes to the earliest repo first, then down the lineage |
| Name of a feature new in year N | that year's Genesis game (94G for 94S and 94PC, 95G for 95S and 95PC) |
| Name of a platform-only job | the earlier repo on that platform (93S for 94S, 94PC for 95PC), else what the code does |
| Same name, different job | the earlier meaning keeps the name |
| Top folder or file | the same-year Genesis file |
| RAM order | the merged order (92G, 93G, 94G, 93S, 94S, then 95G, 96G) |
| Data, assets, banks | the earlier repo on the same platform |
| Order inside a file | ROM order (the report re-sorts for display) |
| History | `docs/name_map.csv` only, never source comments |

## This repo

- Names: 92G is the root, then 93G. A 94 feature takes the name chosen here; 94S, 94PC, 95G and 95PC copy it.
- Files: this repo is the file-shape reference for 94S and 94PC. Do not re-split files without updating those repos and the report.
- On 2026-10-31 checks94, assign94 and input94 were folded into logic94; data94 and attract94 into setup94; the old video94 became middle94 and display94 became video94. Nothing should still use the old names.


## Naming, source style and what `main` is (moved from SEGMENT_AGENT.md, Oct 2026)

Naming lineage is 92G -> 93G -> 94G -> 95G, and the SNES ports sit beside their Genesis parents (93S from 92G/93G, 94S from 93S plus the 94G features).
- A routine, variable or table that matches its parent takes the parent's name. 92G is the naming root.
- Clash rule: if one name would mean two different things, the earliest game's meaning keeps the name and the later one gets a new name.
- Fix the earliest repo first, then propagate the change down the lineage (92 -> 93 -> 94 -> 95, and to the SNES repos).
- Team names: 93 uses the city names of its own data; 94 and 95 use NYI / NYR style abbreviations (team nicknames are not in the repo, see README).

Source style:
- No rename-history, provenance or origin-tag comments ("was X", "from 93G", "renamed"). That history lives in `docs/name_map.csv` only.
- No hardcoded ROM addresses in comments, and no hand-kept derived counts (sizes, numbers of entries, totals) that the code or the assembler can compute.
- Mark "new in 94" / "new in 95" only for major features, not for every changed routine.
- Local labels in 92 style: `.loop`, `.next`, `.done`, `.exit`, and plain numbers for trivial jumps.
- File headers are short plain-English stories of what the file does, modelled on `hockey93.asm`, `main93.asm` and `menu93.asm`.

Layout (SNES repos, 93S and 94S): `src/banks/` holds ordered bank files named by content (one `org`, then `incsrc` lines in ROM order),
`src/routines/<module>/<Routine>.asm` holds one routine per file, `src/data/<category>/` holds data. The folder is the module of the
routine's origin: 94G for 94 code, else 93G, else 92G; SNES-only code goes in a sensibly named SNES folder. Tools go in
`tools/`. The build runs a prebuild ROM check that names the path, file name, SHA-1 and size of the ROM it needs
(and extracts the assets automatically where the repo extracts them).

Work in small steps: every change is built and checked byte for byte against the reference ROM, committed on a short branch off
`main` and merged through one pull request (normal merge, no force push). Keep `docs/HANDOFF.md` current after each merge.

What main is:
- main is a faithful disassembly of the retail game. It keeps only good-practice changes that emit identical bytes: equates and labels instead of hardcoded values, assemble-time checks, and build tooling (the computed checksum and ROM size in `tools/fixrom.js`, `src/shortcalls.inc`, the CHECKSUM/REV flags).
- Mod-specific fixes (long calls instead of the retail short ones, save-RAM moves, mapper code) do not go on main. They are documented in `docs/EXPANDING_THE_ROM.md` or live on mod branches. Gameplay-loop speed is `docs/PERFORMANCE.md`.
- `NumTeams` / `NumPlayoffTeams` in `src/ram94.asm` and the per-team length checks stay; `null` (92 name) and `TeamList` replace the `#$30A` / `#$30E` loads.

## Learned

- 2026-11-04 contributing: CONTRIBUTING.md must not contradict History: lineage lives only in the name history file, never in source comments. (CONTRIBUTING rewrite vs RULES History row)
- 2026-11-04 name_map: a `from 92 Parent` split is not a rename row. `old,new` is this repo's previous name to its current name; recording Fprint→Fprintsmall made the pairing gate treat 93S/94S Fprint as a stale 94G name (lineage count rose). Delete the comment; do not invent a rename.
- 2026-11-05 names: CreditsList is 93G CreditsPages (String pages after Credits). 92G has only Credits. (owner)
- 2026-11-05 leftover split: high-ROM leftover files stay ROM-contiguous; split only at a global label into the next include. Do not move a routine into an earlier file (MATCH). `goalie94` / `title94` were named for one job but held the rest of high94_3. (Abdul: goalie94 looks like non-goalie, title94 like non-title)
- 2026-11-05 leftover recut: Abdul's cuts are period94 (EndShootout…ManualGoalieMenu), arena94 (RunArenaAnim…RandomSongs), shootoutpath94 (ReadLineData…ShootoutShootCheck), ui94 (UnpackPicture…PlayedByAway), helpers94 (SetSflags8Bit1…EndOneTimer), title94 (TitleScreen…CreditsScrollStep), logos94 (TeamLogoPalettes…HotColdIcon), chgplayer94 (chgplayer…j_setc2player). The leftover path slice cannot be named `shootout94`: that file is already the $FC320 shootout UI. (Abdul 2026-11-05)
- 2026-11-06 names: asstab slot $00 is `anull` (95PC debug "null" / `rtss2`). 92G left it unnamed; do not reuse `anothing` (92G `assnothing`). 93S/94S share `anull` for the same job. (Abdul)
