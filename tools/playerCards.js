// playerCards.js: which player has which player card picture, read from the source (no ROM needed).
// playerCards() -> one entry per Player row of src/teamdata94.asm, in file order (the order of the ids P001 ...):
//   { team: 'BOS', slot: 17, card: 'Card002' or null }
// A team's FeaturedPictures list (src/cards94.asm) pairs a picture (CardNNN, or a generic NoPic one) with a roster index; the roster
// index is the position of the Player row inside its team record. All-Star players share the card of their club player.
const fs = require('fs');
const path = require('path');
const read = (f) => fs.readFileSync(path.join(__dirname, '..', 'src', f), 'latin1').split(/\r?\n/);

function playerCards() {
    const abbr = {};                                          // team record label -> abbreviation, from the TeamList comments
    for (const l of read('teamdata94.asm')) {
        const m = /^\s*dc\.l\s+(\w+)\s*;\d+ (\w+)/.exec(l);
        if (m) abbr[m[1]] = m[2];
    }
    const rows = [];
    let team = null, slot = 0;
    for (const l of read('teamdata94.asm')) {
        const m = /^(\w+)/.exec(l);
        if (m && abbr[m[1]]) { team = abbr[m[1]]; slot = 0; continue; }
        if (/^\s*Player\s/.test(l)) rows.push({ team, slot: slot++, card: null });
    }
    const pics = {};                                          // abbreviation -> { roster index: card }
    let list = null, pic = null;
    for (const l of read('cards94.asm')) {
        const h = /^\.(\w+)\s+;\w+ featured pictures/.exec(l);
        if (h) { list = pics[h[1]] = {}; pic = null; continue; }
        if (!list) continue;
        const p = /^\s*dc\.l\s+(\w+)/.exec(l);
        if (p) { pic = p[1]; continue; }
        const w = /^\s*dc\.w\s+(\d+)/.exec(l);
        if (w && pic) { if (/^Card\d+$/.test(pic)) list[Number(w[1])] = pic; pic = null; }
    }
    for (const r of rows) r.card = (pics[r.team] || {})[r.slot] || null;
    return rows;
}
module.exports = { playerCards };
