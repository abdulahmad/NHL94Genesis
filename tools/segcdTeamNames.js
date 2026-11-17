// Reads the licensed text out of the Sega CD HOCKEY.BIN team data: the player names and the team nicknames, in the
// order of src/segacd/hockey/teamdata.asm (records sorted by address). Used by extractAssetsSegaCD.js (writes
// Extracted/SegaCD/HOCKEY/PlayerNames.txt and TeamNicknames.txt) and by the names step of build.js --segacd.
const NUM_TEAMS = 28;
function teamNames(disc) {
    const ptrs = [];
    for (let i = 0; i < NUM_TEAMS; i++) ptrs.push(disc.readUInt32BE(0x0C + 4 * i) - 0x1B000);
    const players = [], nicks = [];
    const str = (p) => { const ln = disc.readUInt16BE(p); let b = disc.subarray(p + 2, p + ln); if (b.length && b[b.length - 1] === 0) b = b.subarray(0, b.length - 1); return [ln, b]; };
    for (const p of [...ptrs].sort((a, b) => a - b)) {
        const num = ptrs.indexOf(p);
        let q = p + disc.readUInt16BE(p);
        for (;;) {
            const ln = disc[q + 1];
            if (disc[q] === 0 && ln === 2) break;
            let nm = disc.subarray(q + 2, q + ln);
            if (nm.length && nm[nm.length - 1] === 0) nm = nm.subarray(0, nm.length - 1);
            players.push(Buffer.from(nm));
            q += ln + 8;
        }
        q = p + disc.readUInt16BE(p + 4);
        let [ln] = str(q); q += ln;          // city
        [ln] = str(q); q += ln;              // abbreviation
        const [, nick] = str(q);             // nickname
        if (num < 26) nicks.push(Buffer.from(nick));
    }
    return { players, nicks };
}
module.exports = { teamNames };
