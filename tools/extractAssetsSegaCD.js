// Extracts the HOCKEY.BIN assets that src/segacd/hockey.asm incbins into Extracted/SegaCD/HOCKEY/,
// the way extractAssets94.js does for the cartridge. The list is src/segacd/hockey/assets.json.
const fs = require('fs');
const path = require('path');
const root = path.join(__dirname, '..');
const disc = fs.readFileSync(path.join(root, 'cdbin', 'HOCKEY.BIN'));
const list = JSON.parse(fs.readFileSync(path.join(root, 'src', 'segacd', 'hockey', 'assets.json'), 'utf8'));
const dir = path.join(root, 'Extracted', 'SegaCD', 'HOCKEY');
fs.mkdirSync(dir, { recursive: true });
for (const [name, a] of Object.entries(list)) {
    fs.writeFileSync(path.join(dir, name), disc.subarray(a.start, a.start + a.size));
}
console.log(`extracted ${Object.keys(list).length} HOCKEY.BIN assets`);
