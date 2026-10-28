// Compare one segment (or all) of the full build with the same address range of the retail ROM.
// Usage: node tools/verifySegment.js <segment|--all> [<built.bin> <reference.bin> <listing>]
// A segment is a file that src/nhl94.asm includes. Its range comes from the full build listing: from the
// address of its include line to the address of the next include (the last one runs to the 1MB fill), so
// the ranges follow the code when it moves. Defaults: output/nhl94.bin, the retail ROM in the repo folder (tools/roms.js), output/obj/nhl94 .lst.
const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const [segment, builtArg, refArg, lstArg] = process.argv.slice(2);
if (!segment) {
  console.error('Usage: node tools/verifySegment.js <segment|--all> [<built.bin> <reference.bin> <listing>]');
  process.exit(1);
}
const builtPath = builtArg || path.join(ROOT, 'output', 'nhl94.bin');
const refPath = refArg || require('./roms').romPath('retail') || path.join(ROOT, 'nhl94retail.bin');
const lstPath = lstArg || path.join(ROOT, 'output', 'obj', 'nhl94 .lst');

// The segments, in include order: the .asm files src/nhl94.asm includes (named without their folder, e.g. sound\sound94.asm is sound94)
// before the 1 MB fill. Includes after the fill are mod code past the retail image (not in the retail ROM), so they are not segments.
function segmentNames() {
  let top = fs.readFileSync(path.join(ROOT, 'src', 'nhl94.asm'), 'latin1').split(/\r?\n/);
  // The list also stops at the IF MSU=1 block that holds the fill on this branch (msu94.asm is past the retail image).
  const fillAt = top.findIndex((l) => /^\s+dcb\.b\s+\$100000-\*/i.test(l) || /^\s+IF\s+MSU\b/i.test(l));
  if (fillAt >= 0) top = top.slice(0, fillAt);
  return top.map((l) => l.match(/^\s+include\s+(?:\w+\\)?(\w+)\.asm\b/i)).filter(Boolean).map((m) => m[1]);
}

// Start address of each top-level include (first listing line that includes the file), and the end of the last
// one (the dcb fill line after it).
function segmentRanges() {
  const names = segmentNames();
  const lst = fs.readFileSync(lstPath, 'latin1').split(/\r?\n/);
  const starts = {};
  let fill = null;
  let after = false;
  for (const line of lst) {
    const m = line.match(/^([0-9A-F]{8})\s+\tinclude\t(?:\w+\\)?(\w+)\.asm\b/i);
    if (m && names.includes(m[2]) && starts[m[2]] === undefined) {
      starts[m[2]] = parseInt(m[1], 16);
      after = m[2] === names[names.length - 1];
      continue;
    }
    const f = after && fill === null && line.match(/^([0-9A-F]{8})\s+\tdcb\.b\t\$100000-\*/i);
    if (f) fill = parseInt(f[1], 16);
  }
  const missing = names.filter((n) => starts[n] === undefined);
  if (missing.length) throw new Error(`no include line in ${lstPath} for ${missing.join(', ')}`);
  if (fill === null) throw new Error(`no fill line after ${names[names.length - 1]} in ${lstPath}`);
  return names.map((n, i) => ({ name: n, first: starts[n], end: i + 1 < names.length ? starts[names[i + 1]] : fill }));
}

let ranges;
try { ranges = segmentRanges(); } catch (e) { console.error(e.message); process.exit(1); }
const built = fs.readFileSync(builtPath);
const reference = fs.readFileSync(refPath);
const hex = (v) => v.toString(16).toUpperCase().padStart(6, '0');

const todo = segment === '--all' ? ranges : ranges.filter((r) => r.name === segment);
if (!todo.length) {
  console.error(`unknown segment '${segment}'. Known: ${ranges.map((r) => r.name).join(', ')}`);
  process.exit(1);
}
let failed = 0;
for (const { name, first, end } of todo) {
  const length = end - first;
  if (length === 0) { console.log(`MATCH: ${name} has no ROM bytes (equates only)`); continue; }
  const bad = [];
  for (let a = first; a < end; a++) if (built[a] !== reference[a]) bad.push(a);
  if (!bad.length) { console.log(`MATCH: ${name} confirmed ${length} bytes at 0x${hex(first)}-0x${hex(end - 1)}`); continue; }
  failed++;
  console.error(`MISMATCH: ${name}: ${bad.length} of ${length} bytes differ in 0x${hex(first)}-0x${hex(end - 1)}`);
  for (const a of bad.slice(0, 16)) {
    console.error(`  0x${hex(a)}: built ${(built[a] ?? 0).toString(16).padStart(2, '0')} retail ${reference[a].toString(16).padStart(2, '0')}`);
  }
}
process.exit(failed ? 1 : 0);
