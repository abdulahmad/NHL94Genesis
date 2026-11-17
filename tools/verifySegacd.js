// Compare the transcribed Sega CD fragments to the disc files.
// The disc files are not in the repo. Put them in cdbin/ :
//   cdbin/MAIN.BIN  cdbin/STARTER.BIN  cdbin/HOCKEY.BIN
//   cdbin/PLAYER.BIN  cdbin/GRAPH2.BIN  cdbin/GTABLE.BIN

const fs = require('fs');
const path = require('path');

const root = path.resolve(__dirname, '..');

function read(rel) {
  const p = path.join(root, rel);
  if (!fs.existsSync(p)) {
    console.error('missing ' + p);
    process.exit(1);
  }
  return fs.readFileSync(p);
}

function compare(builtRel, discRel, length) {
  const built = read(builtRel);
  const disc = read(discRel);
  const n = Math.min(length, built.length, disc.length);
  let bad = 0;
  let first = -1;
  for (let i = 0; i < n; i++) {
    if (built[i] !== disc[i]) {
      if (first < 0) first = i;
      bad++;
    }
  }
  if (built.length < length) {
    console.error(builtRel + ' is ' + built.length + ' bytes, wanted ' + length);
    process.exit(1);
  }
  if (bad) {
    console.error(path.basename(discRel) + ' MISMATCH  first $' + first.toString(16) + '  ' + bad + ' of ' + n);
    console.error('  built ' + built[first].toString(16) + '  disc ' + disc[first].toString(16));
    process.exit(1);
  }
  console.log(path.basename(discRel) + ' MATCH  ' + n + ' bytes');
}

function compareAt(builtRel, discRel, discOff, length) {
  const built = read(builtRel);
  const disc = read(discRel);
  const n = length;
  if (built.length < n) {
    console.error(builtRel + ' is ' + built.length + ' bytes, wanted ' + n);
    process.exit(1);
  }
  let bad = 0;
  let first = -1;
  for (let i = 0; i < n; i++) {
    if (built[i] !== disc[discOff + i]) {
      if (first < 0) first = i;
      bad++;
    }
  }
  const name = path.basename(discRel) + ' +$' + discOff.toString(16);
  if (bad) {
    console.error(name + ' MISMATCH  first +$' + first.toString(16) + '  ' + bad + ' of ' + n);
    console.error('  built ' + built[first].toString(16) + '  disc ' + disc[discOff + first].toString(16));
    process.exit(1);
  }
  console.log(name + ' MATCH  ' + n + ' bytes');
}

compareAt('output/segacd/main.bin', 'cdbin/MAIN.BIN', 0x0, 0xEC00);
compare('output/segacd/subboot.bin', 'cdbin/STARTER.BIN', 0x90);
compareAt('output/segacd/subheap.bin', 'cdbin/STARTER.BIN', 0x4FA8, 0xC0);
compareAt('output/segacd/pcmclear.bin', 'cdbin/STARTER.BIN', 0x3A0C, 0x6A);
compareAt('output/segacd/cdcwait.bin', 'cdbin/STARTER.BIN', 0x3A76, 0x14);
compareAt('output/segacd/pcmchip.bin', 'cdbin/STARTER.BIN', 0x3FD0, 0x12A);
compareAt('output/segacd/audiostream.bin', 'cdbin/STARTER.BIN', 0x508C, 0x278);
compareAt('output/segacd/cdfade.bin', 'cdbin/STARTER.BIN', 0x54F6, 0x78);
compareAt('output/segacd/filmrun.bin', 'cdbin/STARTER.BIN', 0x3D94, 0x116);
compareAt('output/segacd/filmcmd.bin', 'cdbin/STARTER.BIN', 0x4D9E, 0x2C);
compareAt('output/segacd/filmbuf.bin', 'cdbin/STARTER.BIN', 0x4E26, 0x9A);
compareAt('output/segacd/hockey.bin', 'cdbin/HOCKEY.BIN', 0x0, 0x2D20A);
compareAt('output/segacd/player.bin', 'cdbin/PLAYER.BIN', 0x0, 0xAE70);
compareAt('output/segacd/filmopen.bin', 'cdbin/STARTER.BIN', 0x4336, 0x202);
compareAt('output/segacd/filmsm.bin', 'cdbin/STARTER.BIN', 0x3EAA, 0x126);
compareAt('output/segacd/filmtask.bin', 'cdbin/STARTER.BIN', 0x458C, 0x1A2);
compareAt('output/segacd/filmclose.bin', 'cdbin/STARTER.BIN', 0x473A, 0x42);
