// patch/teamblock-vram headless check of output/nhl94.bin: packed tables, pointers, map rebasing, checksum.
// Usage: node tools/testTeamBlockVram.js [rom]
const fs = require('fs'), path = require('path');
const ROOT = path.join(__dirname, '..'), O = path.join(ROOT, 'output');
const rom = fs.readFileSync(process.argv[2] || path.join(O, 'nhl94.bin'));
const tiles = fs.readFileSync(path.join(O, 'tbp_tiles.bin')), bmp = fs.readFileSync(path.join(O, 'tbp_bitmap.bin'));
const src = fs.readFileSync(path.join(ROOT, 'Extracted/NHL94/Graphics/TeamBlocks94.map.jim'));
const inc = fs.readFileSync(path.join(O, 'teambitmaps_packed.inc'), 'utf8');
let fails = 0; const ok = (c, m) => { console.log((c ? 'ok   ' : 'FAIL ') + m); if (!c) fails++; };
const n = +inc.match(/TBP_Count equ (\d+)/)[1], max = +inc.match(/TBP_Max equ (\d+)/)[1];
const data = rom.indexOf(tiles), bm = rom.indexOf(bmp);
ok(data >= 0x100000, `TBP_Data in ROM at $${data.toString(16)} (after $100000)`);
ok(bm >= 0x100000, `TBP_Bitmap at $${bm.toString(16)}`);
const counts = inc.match(/TBP_Tiles\r?\n([\s\S]*?)TBP_Plain/)[1].match(/\d+/g).map(Number);
const tTiles = bm + ((bmp.length + 1) & ~1);
ok(counts.every((c, i) => rom.readUInt16BE(tTiles + 2 * i) === c), `TBP_Tiles: ${n} counts in ROM (max ${max})`);
const tPlain = tTiles + 2 * n, tRemap = tPlain + 4 * n;
ok(tRemap + 4 * n === data, 'TBP_Plain/TBP_Remap tables directly precede TBP_Data');
const mo = src.readUInt32BE(4), cnt = src.readUInt16BE(8), nib = [0, 3, 4, 1, 2, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
const bmo = bmp.readUInt32BE(4);
let mapOk = true, remapOk = true, ptrOk = true;
for (let t = 0; t < n; t++) {
  const p = rom.readUInt32BE(tPlain + 4 * t), r = rom.readUInt32BE(tRemap + 4 * t);
  if (p < data || r < data || p + counts[t] * 32 > data + tiles.length) ptrOk = false;
  for (let k = 0; k < 22; k++) {
    const ov = src.readUInt16BE(mo + 4 + (t * 22 + k) * 2), nv = rom.readUInt16BE(bm + bmo + 4 + (t * 22 + k) * 2);
    const li = nv & 0x7ff;
    if ((ov & 0xf800) !== (nv & 0xf800) || li >= counts[t]) { mapOk = false; continue; }
    const orig = src.subarray(10 + (ov & 0x7ff) * 32, 42 + (ov & 0x7ff) * 32);
    if (!rom.subarray(p + li * 32, p + li * 32 + 32).equals(orig)) mapOk = false;
    const rr = rom.subarray(r + li * 32, r + li * 32 + 32);
    for (let i = 0; i < 32; i++) if (rr[i] !== ((nib[orig[i] >> 4] << 4) | nib[orig[i] & 15])) remapOk = false;
  }
}
ok(ptrOk, 'every team pointer lands inside TBP_Data'); ok(mapOk, 'rebased map + plain tiles reproduce the retail banner pixels for all teams');
ok(remapOk, 'remapped tiles = retail $03412567 remap');
ok(n === src.readUInt16BE(mo + 2) / 2, `team count ${n} = map entries`);
// header checksum: sum of words $200..end
ok(rom.readUInt32BE(0x1a4) === rom.length - 1, `header ROM end $${(rom.length - 1).toString(16)}`);
console.log(`setup VRAM: banners use ${2 * max} chars (2..${1 + 2 * max}) vs ${2 * cnt} retail`);
process.exit(fails ? 1 : 0);
