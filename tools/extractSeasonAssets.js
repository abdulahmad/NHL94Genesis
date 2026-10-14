// Season-image graphics, copied out of the NHL 95 ROM. The retail prebuild does not run this.
// Looks for the ROM at NHL95_ROM, then next to this repo, then the local clone.
const fs = require('fs');
const path = require('path');

const root = path.join(__dirname, '..');
const outDir = path.join(root, 'Extracted', 'NHL94', 'Season');
const candidates = [
  process.env.NHL95_ROM,
  path.join(root, '..', 'NHL95Genesis', 'lst', 'nhl95.bin'),
  '/tmp/NHL95Genesis/lst/nhl95.bin',
].filter(Boolean);

const spans = [
  ['CreateFramerMap.map.jim', 0x14c148, 0x14c308],
  ['ControllerBgMap.map.jim', 0x164ac8, 0x165a36],
  ['CreateBgMap.map.jim', 0x1703fe, 0x172ccc],
  ['TradeBgMap.map.jim', 0x172ccc, 0x17409a],
  ['GMDecisionMap.map.jim', 0x180d54, 0x181078],
  ['FreeAgentMap2.map.jim', 0x181078, 0x181486],
  ['FreeAgentMap1.map.jim', 0x181486, 0x181b04],
  ['TradeAdvantageMap2.map.jim', 0x181b04, 0x18277c],
  ['TradeAdvantageMap1.map.jim', 0x18277c, 0x1834f4],
  ['NameEntryBgMap.map.jim', 0x1834f4, 0x1835d6],
];

const romPath = candidates.find((p) => fs.existsSync(p));
if (!romPath) {
  console.error('NHL 95 ROM not found. Set NHL95_ROM to lst/nhl95.bin');
  process.exit(1);
}
const rom = fs.readFileSync(romPath);
fs.mkdirSync(outDir, { recursive: true });
for (const [name, start, end] of spans) {
  fs.writeFileSync(path.join(outDir, name), rom.subarray(start, end));
}
console.log(`season assets ${spans.length} files from ${romPath}`);
