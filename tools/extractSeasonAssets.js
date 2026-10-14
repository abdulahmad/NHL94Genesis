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
  ['GamesTodayLogoMap.map.jim', 0x165a36, 0x167524],
  ['GamesTodayMap1.map.jim', 0x167524, 0x16767e],
  ['GamesTodayMap2.map.jim', 0x16767e, 0x16781e],
  ['GamesTodayMap3.map.jim', 0x16781e, 0x167a44],
  ['CalendarBgMap.map.jim', 0x167a44, 0x168e72],
  ['CalOpponentMap.map.jim', 0x168e72, 0x1696dc],
  ['CalDayMap.map.jim', 0x1696dc, 0x169ce6],
  ['CalMonthMap.map.jim', 0x169ce6, 0x16a814],
  ['CalCheckMap.map.jim', 0x16a814, 0x16a8bc],
  ['CalResultMap.map.jim', 0x16a8bc, 0x16cc82],
  ['PlayerStatsBgMap.map.jim', 0x16b50a, 0x16c438],
  ['PlayerStatsTitleMap.map.jim', 0x16c438, 0x16c776],
  ['CreateBgMap.map.jim', 0x1703fe, 0x172ccc],
  ['TradeBgMap.map.jim', 0x172ccc, 0x17409a],
  ['GMDecisionMap.map.jim', 0x180d54, 0x181078],
  ['FreeAgentMap2.map.jim', 0x181078, 0x181486],
  ['FreeAgentMap1.map.jim', 0x181486, 0x181b04],
  ['TradeAdvantageMap2.map.jim', 0x181b04, 0x18277c],
  ['TradeAdvantageMap1.map.jim', 0x18277c, 0x1834f4],
  ['NameEntryBgMap.map.jim', 0x1834f4, 0x1835d6],
  ['ControllerTitleMap.map.jim', 0x16aa7c, 0x16ad5a],
  ['PadCursorMap.map.jim', 0x16ad5a, 0x16b0b2],
  ['PadIconMap1.map.jim', 0x16b0b2, 0x16b1c8],
  ['PadIconMap2.map.jim', 0x16b1c8, 0x16b2de],
  ['PadIconMap3.map.jim', 0x16b2de, 0x16b3f4],
  ['PadIconMap4.map.jim', 0x16b3f4, 0x16b50a],
];

const romPath = candidates.find((p) => fs.existsSync(p));
if (!romPath) {
  console.error('NHL 95 ROM not found. Set NHL95_ROM to lst/nhl95.bin');
  process.exit(1);
}
const rom = fs.readFileSync(romPath);
fs.mkdirSync(outDir, { recursive: true });
for (const [name, start, end] of spans) {
  const data = rom.subarray(start, end);
  fs.writeFileSync(path.join(outDir, name), data);
  const lower = name.toLowerCase();
  if (lower !== name) {
    fs.writeFileSync(path.join(outDir, lower), data);
  }
}
console.log(`season assets ${spans.length} files from ${romPath}`);
