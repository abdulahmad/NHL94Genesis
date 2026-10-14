#!/usr/bin/env node
// checkSaveLayout.js — retail save band math from equals.inc rules (no assembler).
// Usage: node tools/checkSaveLayout.js [--season] [numTeams ...]
// Default teams: 28 and 34. Exits 1 on retail-band failures; with --season also fails season header overlap.

const args = process.argv.slice(2);
const seasonMode = args.includes('--season');
const tests = args.filter((a) => a !== '--season').map((n) => parseInt(n, 10)).filter((n) => n > 0);
const teamCounts = tests.length ? tests : [28, 34];

const CrowdRecBase = 0xb60;
const CrowdRecBytes = 16;
const LineDataBase = 0x1ef6;
const SaveMirrorRetail = 0x2000;
const SRSeasonHeader = 0xe22;

function retailLayout(numTeams) {
  const crowdRecEnd = CrowdRecBase + numTeams * CrowdRecBytes;
  const teamRecBase = crowdRecEnd < 0xd21 ? 0xd20 : crowdRecEnd;
  const recordsEnd = teamRecBase + 0x80;
  const nameLogBase = recordsEnd < 0xda1 ? 0xda0 : recordsEnd;
  const nameLogEnd = nameLogBase + 0x80;
  return { numTeams, crowdRecEnd, teamRecBase, nameLogEnd };
}

let fail = 0;
for (const n of teamCounts) {
  const L = retailLayout(n);
  const playoffTeams = n - 2; // two all-stars last
  const issues = [];
  if (L.nameLogEnd > LineDataBase) {
    issues.push(`name log end $${L.nameLogEnd.toString(16)} past line data $${LineDataBase.toString(16)}`);
  }
  if (L.nameLogEnd > SaveMirrorRetail) {
    issues.push(`name log end past retail mirror $${SaveMirrorRetail.toString(16)}`);
  }
  if (seasonMode && L.nameLogEnd > SRSeasonHeader) {
    issues.push(`name log end $${L.nameLogEnd.toString(16)} overlaps season header $${SRSeasonHeader.toString(16)} (season build)`);
  } else if (!seasonMode && L.nameLogEnd > SRSeasonHeader) {
    console.log(
      `  note: name log would overlap season header $${SRSeasonHeader.toString(16)} if SEASON=1 (ok for exhibition-only mods)`,
    );
  }
  if (playoffTeams > 32) {
    issues.push(`playoff teams ${playoffTeams} > 32 (playoff draw limit)`);
  }
  const tag = issues.length ? 'FAIL' : 'ok';
  console.log(
    `N=${n} playoff=${playoffTeams} NameLogEnd=$${L.nameLogEnd.toString(16)} TeamRecBase=$${L.teamRecBase.toString(16)} ${tag}`,
  );
  for (const i of issues) console.log(`  - ${i}`);
  if (issues.length) fail = 1;
}
process.exit(fail);
