# Expanding-the-ROM build hints (sibling Genesis repos)

These patches mirror [PR #??? on NHL94Genesis](../..) for repos the cloud agent cannot push to directly.

Apply from the root of each target repository:

```bash
git checkout -b cursor/expanding-rom-hints-80af
git am /path/to/NHL94Genesis/contrib/expanding-rom-hints/NHL95Genesis.patch
# repeat for NHL96Genesis, NHLPA93Genesis, NHL92Genesis
```

| Patch | Repository |
| --- | --- |
| `NHL95Genesis.patch` | Updates `docs/EXPANDING_THE_ROM.md`, `tools/assembleHints.js`, `tools/build.js` |
| `NHL96Genesis.patch` | Adds `docs/EXPANDING_THE_ROM.md`, `tools/assembleHints.js`, updates `tools/build.js` |
| `NHLPA93Genesis.patch` | Adds `docs/EXPANDING_THE_ROM.md`, `tools/assembleHints.js`, updates `tools/build.js` |
| `NHL92Genesis.patch` | Adds `docs/EXPANDING_THE_ROM.md`, `tools/assembleHints.js`, updates `tools/build.js` |

After merging to each repo’s `main`, every branch picks up the doc and build hint on merge/rebase.
