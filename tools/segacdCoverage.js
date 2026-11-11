// Matched bytes per Sega CD disc file: the union of the ranges tools/verifySegacd.js compares.
// Run after a passing `npm run build:segacd` (tools/segacd_check.sh does both). Reads the compare
// calls straight from verifySegacd.js, so a new fragment counts as soon as its compare line is there.

const fs = require('fs');
const path = require('path');

const root = path.resolve(__dirname, '..');
const src = fs.readFileSync(path.join(root, 'tools', 'verifySegacd.js'), 'utf8');
const sizes = { 'MAIN.BIN': 60416, 'STARTER.BIN': 120248, 'HOCKEY.BIN': 184842, 'PLAYER.BIN': 44656, 'GRAPH2.BIN': 3051520, 'GTABLE.BIN': 2048 };
const code = ['MAIN.BIN', 'STARTER.BIN', 'HOCKEY.BIN', 'PLAYER.BIN'];

const ranges = {};
const num = (s) => Number(s.trim());
for (const m of src.matchAll(/^compare\('([^']+)',\s*'cdbin\/([^']+)',\s*([^)]+)\);/gm)) {
    (ranges[m[2]] = ranges[m[2]] || []).push([0, num(m[3])]);
}
for (const m of src.matchAll(/^compareAt\('([^']+)',\s*'cdbin\/([^']+)',\s*([^,]+),\s*([^)]+)\);/gm)) {
    const at = num(m[3]);
    (ranges[m[2]] = ranges[m[2]] || []).push([at, at + num(m[4])]);
}

function union(list) {
    const s = list.slice().sort((a, b) => a[0] - b[0]);
    const out = [];
    for (const r of s) {
        const last = out[out.length - 1];
        if (last && r[0] <= last[1]) last[1] = Math.max(last[1], r[1]);
        else out.push(r.slice());
    }
    return out;
}

const pct = (a, b) => (100 * a / b).toFixed(1).padStart(5) + '%';
let codeHave = 0, codeAll = 0;
console.log('file          size        matched          fragments');
for (const f of Object.keys(sizes)) {
    const u = union(ranges[f] || []);
    const have = u.reduce((n, r) => n + r[1] - r[0], 0);
    if (code.includes(f)) { codeHave += have; codeAll += sizes[f]; }
    console.log(`${f.padEnd(12)} ${String(sizes[f]).padStart(9)}  ${String(have).padStart(9)} ${pct(have, sizes[f])}  ${(ranges[f] || []).length}`);
}
console.log(`${'code files'.padEnd(12)} ${String(codeAll).padStart(9)}  ${String(codeHave).padStart(9)} ${pct(codeHave, codeAll)}`);
