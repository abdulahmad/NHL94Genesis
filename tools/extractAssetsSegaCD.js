// GRAPH2.BIN is not assembled: its list (src/segacd/graph2/assets.json, tools/segcd_graph2_assets.py) names the pieces that are cartridge assets.
// Extracts the disc assets that the Sega CD sources incbin into Extracted/SegaCD/<FILE>/, the way
// extractAssets94.js does for the cartridge. Each disc file lists its assets in
// src/segacd/<dir>/assets.json ({name: {start, size}}).
const fs = require('fs');
const path = require('path');
const root = path.join(__dirname, '..');
const { teamNames, teamPalettes } = require('./segcdTeamNames');
const files = [['hockey', 'HOCKEY'], ['main', 'MAIN'], ['player', 'PLAYER'], ['starter', 'STARTER'], ['graph2', 'GRAPH2']];
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
    if (bin === 'HOCKEY') {
        // the licensed text of the team data (player names, team nicknames), for the names step of build.js --segacd
        const t = teamNames(disc);
        fs.writeFileSync(path.join(dir, 'PlayerNames.txt'), Buffer.concat(t.players.flatMap((b) => [b, Buffer.from('\n')])));
        fs.writeFileSync(path.join(dir, 'TeamNicknames.txt'), Buffer.concat(t.nicks.flatMap((b) => [b, Buffer.from('\n')])));
        // the team palettes, which teamdata94cd.asm incbins like the cartridge's Extracted/NHL94/Graphics/Pals files
        fs.mkdirSync(path.join(dir, 'Pals'), { recursive: true });
        for (const pal of teamPalettes(disc)) {
            fs.writeFileSync(path.join(dir, 'Pals', pal.abbr + 'h.pal'), pal.home);
            fs.writeFileSync(path.join(dir, 'Pals', pal.abbr + 'v.pal'), pal.visitor);
        }
    }
    console.log(`extracted ${Object.keys(list).length} ${bin}.BIN assets`);
}
