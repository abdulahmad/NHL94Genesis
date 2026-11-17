// Extracts the disc assets that the Sega CD sources incbin into Extracted/SegaCD/<FILE>/, the way
// extractAssets94.js does for the cartridge. Each disc file lists its assets in
// src/segacd/<dir>/assets.json ({name: {start, size}}).
const fs = require('fs');
const path = require('path');
const root = path.join(__dirname, '..');
const files = [['hockey', 'HOCKEY'], ['main', 'MAIN'], ['player', 'PLAYER'], ['starter', 'STARTER']];
for (const [src, bin] of files) {
    const listPath = path.join(root, 'src', 'segacd', src, 'assets.json');
    if (!fs.existsSync(listPath)) continue;
    const disc = fs.readFileSync(path.join(root, 'cdbin', bin + '.BIN'));
    const list = JSON.parse(fs.readFileSync(listPath, 'utf8'));
    const dir = path.join(root, 'Extracted', 'SegaCD', bin);
    fs.mkdirSync(dir, { recursive: true });
    for (const [name, a] of Object.entries(list)) {
        fs.writeFileSync(path.join(dir, name), disc.subarray(a.start, a.start + a.size));
    }
    console.log(`extracted ${Object.keys(list).length} ${bin}.BIN assets`);
}
