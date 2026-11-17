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

compare('output/segacd/maincd.bin', 'cdbin/MAIN.BIN', 0x272);
compareAt('output/segacd/maindma.bin', 'cdbin/MAIN.BIN', 0x272, 0x28E);
compareAt('output/segacd/maincont.bin', 'cdbin/MAIN.BIN', 0x500, 0x7B8);
compareAt('output/segacd/mainblit.bin', 'cdbin/MAIN.BIN', 0xCB8, 0x608);
compareAt('output/segacd/mainvdp.bin', 'cdbin/MAIN.BIN', 0x12C0, 0x580);
compareAt('output/segacd/mainpad.bin', 'cdbin/MAIN.BIN', 0x1840, 0x650);
compareAt('output/segacd/maindisp.bin', 'cdbin/MAIN.BIN', 0x1E90, 0xE9A);
compareAt('output/segacd/mainfont.bin', 'cdbin/MAIN.BIN', 0x2D2A, 0x300);
compareAt('output/segacd/maintext.bin', 'cdbin/MAIN.BIN', 0x302A, 0x48E);
compare('output/segacd/subboot.bin', 'cdbin/STARTER.BIN', 0x90);
compareAt('output/segacd/subheap.bin', 'cdbin/STARTER.BIN', 0x4FA8, 0xC0);
compareAt('output/segacd/pcmclear.bin', 'cdbin/STARTER.BIN', 0x3A0C, 0x6A);
compareAt('output/segacd/cdcwait.bin', 'cdbin/STARTER.BIN', 0x3A76, 0x14);
compareAt('output/segacd/pcmchip.bin', 'cdbin/STARTER.BIN', 0x3FD0, 0x12A);
compareAt('output/segacd/audiostream.bin', 'cdbin/STARTER.BIN', 0x508C, 0x278);
compareAt('output/segacd/cdfade.bin', 'cdbin/STARTER.BIN', 0x54F6, 0x78);
compareAt('output/segacd/cdrequest.bin', 'cdbin/HOCKEY.BIN', 0x1C1D2, 0x34);
compareAt('output/segacd/sfxcd.bin', 'cdbin/HOCKEY.BIN', 0x1C10C, 0x68);
compareAt('output/segacd/gate34.bin', 'cdbin/HOCKEY.BIN', 0x1C174, 0x5E);
compareAt('output/segacd/songplay.bin', 'cdbin/HOCKEY.BIN', 0x10B1E, 0x3A);
compareAt('output/segacd/filmrun.bin', 'cdbin/STARTER.BIN', 0x3D94, 0x116);
compareAt('output/segacd/filmcmd.bin', 'cdbin/STARTER.BIN', 0x4D9E, 0x2C);
compareAt('output/segacd/filmbuf.bin', 'cdbin/STARTER.BIN', 0x4E26, 0x9A);
compareAt('output/segacd/cdtrack.bin', 'cdbin/HOCKEY.BIN', 0x1C206, 0xCA);
compareAt('output/segacd/cdcrowd.bin', 'cdbin/HOCKEY.BIN', 0x238CE, 0x4E);
compareAt('output/segacd/cdstart.bin', 'cdbin/HOCKEY.BIN', 0x24D66, 0x82);
compareAt('output/segacd/hk_data_0.bin', 'cdbin/HOCKEY.BIN', 0x0, 0x1000);
compareAt('output/segacd/hk_data_1000.bin', 'cdbin/HOCKEY.BIN', 0x1000, 0x1000);
compareAt('output/segacd/hk_data_2000.bin', 'cdbin/HOCKEY.BIN', 0x2000, 0x1000);
compareAt('output/segacd/hk_data_3000.bin', 'cdbin/HOCKEY.BIN', 0x3000, 0x1000);
compareAt('output/segacd/hk_data_4000.bin', 'cdbin/HOCKEY.BIN', 0x4000, 0x1000);
compareAt('output/segacd/hk_data_5000.bin', 'cdbin/HOCKEY.BIN', 0x5000, 0x1000);
compareAt('output/segacd/hk_data_6000.bin', 'cdbin/HOCKEY.BIN', 0x6000, 0x1000);
compareAt('output/segacd/hk_onetimer94_1.bin', 'cdbin/HOCKEY.BIN', 0x7000, 0xFBE);
compareAt('output/segacd/hk_crowd94_1.bin', 'cdbin/HOCKEY.BIN', 0x7FBE, 0xE62);
compareAt('output/segacd/hk_optsetup94_1.bin', 'cdbin/HOCKEY.BIN', 0x8E20, 0xDFE);
compareAt('output/segacd/hk_cards94_1.bin', 'cdbin/HOCKEY.BIN', 0x9C1E, 0xE2C);
compareAt('output/segacd/hk_cards94_2.bin', 'cdbin/HOCKEY.BIN', 0xAA4A, 0x1000);
compareAt('output/segacd/hk_records94_1.bin', 'cdbin/HOCKEY.BIN', 0xBA4A, 0xFE6);
compareAt('output/segacd/hk_shootout94_1.bin', 'cdbin/HOCKEY.BIN', 0xCA30, 0x7A4);
compareAt('output/segacd/hk_period94_1.bin', 'cdbin/HOCKEY.BIN', 0xE1CE, 0xFDC);
compareAt('output/segacd/hk_ui94_1.bin', 'cdbin/HOCKEY.BIN', 0xF1AA, 0xD56);
compareAt('output/segacd/hk_hockey94_1.bin', 'cdbin/HOCKEY.BIN', 0xFF00, 0xC1E);
compareAt('output/segacd/hk_hockey94_2.bin', 'cdbin/HOCKEY.BIN', 0x10B58, 0x1D0);
compareAt('output/segacd/hk_stats94_1.bin', 'cdbin/HOCKEY.BIN', 0x10E66, 0x1000);
compareAt('output/segacd/hk_stats94_2.bin', 'cdbin/HOCKEY.BIN', 0x11E66, 0xFEC);
compareAt('output/segacd/hk_stats94_3.bin', 'cdbin/HOCKEY.BIN', 0x12E52, 0xF4E);
compareAt('output/segacd/hk_replay94_1.bin', 'cdbin/HOCKEY.BIN', 0x13DA0, 0xADC);
compareAt('output/segacd/hk_logic94_1.bin', 'cdbin/HOCKEY.BIN', 0x1487C, 0xF48);
compareAt('output/segacd/hk_logic94_2.bin', 'cdbin/HOCKEY.BIN', 0x157C4, 0xFF4);
compareAt('output/segacd/hk_logic94_3.bin', 'cdbin/HOCKEY.BIN', 0x167B8, 0x82E);
compareAt('output/segacd/hk_logic94_4.bin', 'cdbin/HOCKEY.BIN', 0x16FE6, 0x1000);
compareAt('output/segacd/hk_logic94_5.bin', 'cdbin/HOCKEY.BIN', 0x17FE6, 0xE16);
compareAt('output/segacd/hk_logic94_6.bin', 'cdbin/HOCKEY.BIN', 0x18DFC, 0xEC8);
compareAt('output/segacd/hk_logic94_7.bin', 'cdbin/HOCKEY.BIN', 0x19CC4, 0xFC8);
compareAt('output/segacd/hk_logic94_8.bin', 'cdbin/HOCKEY.BIN', 0x1AC8C, 0xF56);
compareAt('output/segacd/hk_middle94_1.bin', 'cdbin/HOCKEY.BIN', 0x1BBE2, 0x52A);
compareAt('output/segacd/hk_middle94_2.bin', 'cdbin/HOCKEY.BIN', 0x1C2D0, 0x1000);
compareAt('output/segacd/hk_decompress94_1.bin', 'cdbin/HOCKEY.BIN', 0x1D2D0, 0xF9A);
compareAt('output/segacd/hk_penalty94_1.bin', 'cdbin/HOCKEY.BIN', 0x1E26A, 0xFA8);
compareAt('output/segacd/hk_collide94_1.bin', 'cdbin/HOCKEY.BIN', 0x1F212, 0xD2E);
compareAt('output/segacd/hk_collide94_2.bin', 'cdbin/HOCKEY.BIN', 0x1FF40, 0xEA8);
compareAt('output/segacd/hk_penalty94_2.bin', 'cdbin/HOCKEY.BIN', 0x20DE8, 0xF56);
compareAt('output/segacd/hk_collide94_3.bin', 'cdbin/HOCKEY.BIN', 0x21D3E, 0xE72);
compareAt('output/segacd/hk_video94_1.bin', 'cdbin/HOCKEY.BIN', 0x22BB0, 0xD1E);
compareAt('output/segacd/hk_setup94_1.bin', 'cdbin/HOCKEY.BIN', 0x2391C, 0xF50);
compareAt('output/segacd/hk_data_24C0A.bin', 'cdbin/HOCKEY.BIN', 0x24C0A, 0x8);
compareAt('output/segacd/hk_setup94_2.bin', 'cdbin/HOCKEY.BIN', 0x24DE8, 0xEC4);
compareAt('output/segacd/hk_setup94_3.bin', 'cdbin/HOCKEY.BIN', 0x25CAC, 0x8A0);
compareAt('output/segacd/hk_data_265CC.bin', 'cdbin/HOCKEY.BIN', 0x265CC, 0x1000);
compareAt('output/segacd/hk_data_275CC.bin', 'cdbin/HOCKEY.BIN', 0x275CC, 0x1000);
compareAt('output/segacd/hk_data_285CC.bin', 'cdbin/HOCKEY.BIN', 0x285CC, 0x1000);
compareAt('output/segacd/hk_data_295CC.bin', 'cdbin/HOCKEY.BIN', 0x295CC, 0x1000);
compareAt('output/segacd/hk_data_2A5CC.bin', 'cdbin/HOCKEY.BIN', 0x2A5CC, 0x1000);
compareAt('output/segacd/hk_data_2B5CC.bin', 'cdbin/HOCKEY.BIN', 0x2B5CC, 0x1000);
compareAt('output/segacd/hk_data_2C5CC.bin', 'cdbin/HOCKEY.BIN', 0x2C5CC, 0xC3E);
compareAt('output/segacd/scout94.bin', 'cdbin/HOCKEY.BIN', 0xD1D4, 0xFFA);
compareAt('output/segacd/scouting.bin', 'cdbin/HOCKEY.BIN', 0x2486C, 0x39E);
compareAt('output/segacd/playerpic.bin', 'cdbin/PLAYER.BIN', 0x1D54, 0x2BC);
compareAt('output/segacd/playercareer.bin', 'cdbin/PLAYER.BIN', 0x2010, 0x3C0);
compareAt('output/segacd/playerpage.bin', 'cdbin/PLAYER.BIN', 0x23D0, 0x44C);
compareAt('output/segacd/crowdanim.bin', 'cdbin/HOCKEY.BIN', 0x10D28, 0x13E);
compareAt('output/segacd/crowdtable.bin', 'cdbin/HOCKEY.BIN', 0x2654C, 0x80);
compareAt('output/segacd/filmopen.bin', 'cdbin/STARTER.BIN', 0x4336, 0x202);
compareAt('output/segacd/filmsm.bin', 'cdbin/STARTER.BIN', 0x3EAA, 0x126);
compareAt('output/segacd/scoutload.bin', 'cdbin/HOCKEY.BIN', 0x24C12, 0x154);
compareAt('output/segacd/filmtask.bin', 'cdbin/STARTER.BIN', 0x458C, 0x1A2);
compareAt('output/segacd/filmclose.bin', 'cdbin/STARTER.BIN', 0x473A, 0x42);
compareAt('output/segacd/z80load.bin', 'cdbin/MAIN.BIN', 0x76C8, 0xF0);
compareAt('output/segacd/hwread.bin', 'cdbin/MAIN.BIN', 0x3B3C, 0x102);
