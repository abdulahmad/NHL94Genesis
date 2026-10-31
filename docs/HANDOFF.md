# HANDOFF: NHL94 Genesis

## Status (2026-10-20)

- Everything is merged and `tools/verify_all.sh -q` prints ALL MATCH.
- `SngScout` is now `SngScouting` (as in 93G; recorded in `docs/name_map.csv`). Fifty trailing comments came over from identical NHLPA93Genesis code.
- This repo is the layout reference for NHL94SNES: its `src/routines` folders mirror the files here. NHL94SNES is the repo with open work (the comment pass); see its `docs/HANDOFF.md`.
- NHL9XStudio lists this game's pictures in the 93 group order and names the shared songs `SngTitle`, `SngEOP`, `SngScouting`.


## Purpose
A byte-matching 68000 SNASM disassembly of the retail cartridge that reads like clean original source: accurate names that follow the NHL92 Genesis (EA original) lineage, and comments without disassembler or porting artifacts. Every build must still MATCH `nhl94retail.bin`. `main` keeps only changes that emit identical bytes (Current rules in SEGMENT_AGENT.md).

## Build
`npm run build:retail` (or `node tools/build.js retail`) on Windows, or on Linux with wine (`apt install wine wine32`, i386 enabled). It prints one line per step: prebuild, assemble, fixopcodes, fixrom, verify. `npm run build:dev` builds with CHECKSUM=0 and skips the verify. One segment: `npm run seg -- <name>` (orgs in `tools/segments.json`). `--verbose` shows each step's full output. `tools/verify_all.sh` extracts fresh and checks the full ROM and every segment; it must end in `ALL MATCH` before every commit.

## Naming lineage
- 92G (abdulahmad/NHL92Genesis, EA source) is the root. 93 -> 92; 94 -> 93 -> 92; 95 -> 94 -> 93 -> 92.
- Use the earliest game's name for the same routine/variable. 92 names are kept as-is, typos included.
- A name not from 92 that is inaccurate (checked against the routine body / usage) gets fixed, and the fix is propagated
  forward: 93 -> 94 -> 95, and to abdulahmad/NHLPA93SNES for 93 names that exist there.
- Clash rule: never reuse a name already used for a different item; pick a descriptive name instead.
- Teams: 93 (unlicensed) uses city names only; 94/95 use NYI/NYR style abbreviations (team nicknames are not in the repo).

## Comment rules
No other games' names or "X name" notes, no source-file/segment names, no IDA references (IDA, loc_, sub_, unk_),
no "(was: X)" history, no hardcoded ROM addresses (keep VRAM/RAM values, include address maps, RAM equate address
comments), no "only in 9x" tags ("New in 94/95:" allowed in file/section headers). Keep real explanations and
value-difference notes like "(94 $58)" / "92 used bit 6". Every routine has a header comment. Concise.

## Records
- docs/name_map.csv: every rename (old -> new, source/reason). History lives here, not in comments.

## Conventions
Small commits per module; builds MATCH before every push; `git pull --rebase origin main` then push to main.
No force-push, no PRs, never commit ROMs, Extracted/ or output/.

## Local label style
Follow 92G (EA source): ~31% of its locals are number-only (.0, .1 ...), the rest short lowercase words
(.loop, .next, .top, .done, .ex/.exit, .ok, .wait, .skip, plus abbreviations like .nna, .nodec, .sr).
- Give a word where the branch has a clear meaning (loop top, next item, skip/no-X case, exit, wait).
- Keep plain numbers for trivial jumps and for locals inherited from a matching parent routine.
- A routine that matches a parent routine (92 or 93) uses the parent's local names.
- Data tables indexed by number (frames, team data) stay numeric, as in 92.
- Renames are scope-aware (routine scope, code part only, never comments); diff-review every commit.
  Tools on the box: /workspace/tools_ll/ll.py (rename/list), prop.py (copy parent local names).

## Current state
- Every segment and the full ROM MATCH. The comment review, the name pass, the local label pass and the file header rewrites are done for 94G (renames are in docs/name_map.csv).
- Oct 14 cleanup: main is a faithful retail disassembly again (SRAMTOGGLE, absjsr/absjmp and LONGBRA removed; plain 1MB fill). Kept: NumTeams equates and table checks, the null/TeamList labels, CHECKSUM/REV, `tools/fixrom.js` (size, header ROM end, checksum) and `src/shortcalls.inc`. Mod fixes and the team checklist: docs/EXPANDING_THE_ROM.md.
- Left numeric on purpose (no safe name): logic94 `cmp.w #$180,d4` / `move.w #$180,d4` (speed clamp) and `cmp.w #-50,d1`; video94 showcrowd and showzam constants and the pad arrow frames `#$346` / `#$349`; setup94 `.listffo` `$34C` / `$34D`; replay94 `cmp.w #$34E`.
- Next: the same local label pass for 95G.
