// Compare the transcribed Sega CD fragments to the disc files.
// The disc files are not in the repo. Put them in cdbin/ :
//   cdbin/MAIN.BIN  cdbin/STARTER.BIN  cdbin/HOCKEY.BIN
//   cdbin/PLAYER.BIN  cdbin/GRAPH2.BIN  cdbin/GTABLE.BIN
// and, for src/segacd/boot/, cdbin/BOOT.BIN (the boot area: tools/segacd_bootarea.py; skipped when missing).

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
  if (discRel === 'cdbin/BOOT.BIN' && !fs.existsSync(path.join(root, discRel))) {
    console.log(builtRel + ' skipped (no cdbin/BOOT.BIN: tools/segacd_bootarea.py copies it from a disc image)');
    return;
  }
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
compareAt('output/segacd/scoutopen.bin', 'cdbin/HOCKEY.BIN', 0xD2B6, 0xE2);
compareAt('output/segacd/scouttext.bin', 'cdbin/HOCKEY.BIN', 0x2486C, 0x21E);
compareAt('output/segacd/scouttok.bin', 'cdbin/HOCKEY.BIN', 0x24A8A, 0x180);
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
compareAt('output/segacd/hockey/onetimer94.bin', 'cdbin/HOCKEY.BIN', 0x76A8, 0x734);
compareAt('output/segacd/hockey/fourway94.bin', 'cdbin/HOCKEY.BIN', 0x7DDC, 0x5C);
compareAt('output/segacd/hockey/crowd94.bin', 'cdbin/HOCKEY.BIN', 0x7E38, 0x594);
compareAt('output/segacd/hockey/optsetup94.bin', 'cdbin/HOCKEY.BIN', 0x83CC, 0x1792);
compareAt('output/segacd/hockey/cards94.bin', 'cdbin/HOCKEY.BIN', 0x9B5E, 0x17EA);
compareAt('output/segacd/hockey/records94.bin', 'cdbin/HOCKEY.BIN', 0xB348, 0x1518);
compareAt('output/segacd/hockey/shootout94.bin', 'cdbin/HOCKEY.BIN', 0xC860, 0x974);
compareAt('output/segacd/hockey/period94.bin', 'cdbin/HOCKEY.BIN', 0xE1CE, 0xFDC);
compareAt('output/segacd/hockey/arena94.bin', 'cdbin/HOCKEY.BIN', 0xF1AA, 0x3E2);
compareAt('output/segacd/hockey/shootoutpath94.bin', 'cdbin/HOCKEY.BIN', 0xF58C, 0x376);
compareAt('output/segacd/hockey/ui94.bin', 'cdbin/HOCKEY.BIN', 0xF902, 0x566);
compareAt('output/segacd/hockey/helpers94.bin', 'cdbin/HOCKEY.BIN', 0xFE68, 0xEE);
compareAt('output/segacd/hockey/logos94.bin', 'cdbin/HOCKEY.BIN', 0xFF56, 0x58C);
compareAt('output/segacd/hockey/chgplayer94.bin', 'cdbin/HOCKEY.BIN', 0x104E2, 0x132);
compareAt('output/segacd/hockey/menu94.bin', 'cdbin/HOCKEY.BIN', 0x112F8, 0x368);
compareAt('output/segacd/hockey/stats94.bin', 'cdbin/HOCKEY.BIN', 0x11660, 0x27A4);
compareAt('output/segacd/hockey/replay94.bin', 'cdbin/HOCKEY.BIN', 0x13E04, 0xB86);
compareAt('output/segacd/hockey/logic94.bin', 'cdbin/HOCKEY.BIN', 0x1498A, 0x7228);
compareAt('output/segacd/hockey/scout94.bin', 'cdbin/HOCKEY.BIN', 0xD1D4, 0xE2);
compareAt('output/segacd/hockey/scout94_2.bin', 'cdbin/HOCKEY.BIN', 0xD398, 0xE36);
compareAt('output/segacd/hockey/hockey94.bin', 'cdbin/HOCKEY.BIN', 0x10614, 0x50A);
compareAt('output/segacd/hockey/hockey94_2.bin', 'cdbin/HOCKEY.BIN', 0x10B58, 0x1D0);
compareAt('output/segacd/hockey/hockey94_3.bin', 'cdbin/HOCKEY.BIN', 0x10E66, 0x492);
compareAt('output/segacd/hockey/middle94.bin', 'cdbin/HOCKEY.BIN', 0x1BBB2, 0x55A);
compareAt('output/segacd/hockey/middle94_2.bin', 'cdbin/HOCKEY.BIN', 0x1C2D0, 0x1676);
compareAt('output/segacd/hockey/decompress94.bin', 'cdbin/HOCKEY.BIN', 0x1D946, 0x28E);
compareAt('output/segacd/hockey/print94.bin', 'cdbin/HOCKEY.BIN', 0x1DBD4, 0x846);
compareAt('output/segacd/hockey/penalty94.bin', 'cdbin/HOCKEY.BIN', 0x1E41A, 0xCE0);
compareAt('output/segacd/hockey/collide94.bin', 'cdbin/HOCKEY.BIN', 0x1F0FA, 0x21D6);
compareAt('output/segacd/hockey/penalty94_2.bin', 'cdbin/HOCKEY.BIN', 0x212D0, 0x1156);
compareAt('output/segacd/hockey/collide94_2.bin', 'cdbin/HOCKEY.BIN', 0x22426, 0x692);
compareAt('output/segacd/hockey/video94.bin', 'cdbin/HOCKEY.BIN', 0x22AB8, 0xE16);
compareAt('output/segacd/hockey/setup94.bin', 'cdbin/HOCKEY.BIN', 0x2391C, 0xF50);
compareAt('output/segacd/hockey/setup94_2.bin', 'cdbin/HOCKEY.BIN', 0x24C0A, 0x8);
compareAt('output/segacd/hockey/setup94_3.bin', 'cdbin/HOCKEY.BIN', 0x24DE8, 0x1764);
compareAt('output/segacd/hockey/tables94.bin', 'cdbin/HOCKEY.BIN', 0x265CC, 0x12D4);
compareAt('output/segacd/hockey/graphics94.bin', 'cdbin/HOCKEY.BIN', 0x278A0, 0x11DE);
compareAt('output/segacd/hockey/frames94.bin', 'cdbin/HOCKEY.BIN', 0x5432, 0x1B96);
compareAt('output/segacd/hockey/sram94.bin', 'cdbin/HOCKEY.BIN', 0x6FC8, 0x56C);
compareAt('output/segacd/hockey/cards94_2.bin', 'cdbin/HOCKEY.BIN', 0x7534, 0x174);
compareAt('output/segacd/hockey/graphics94_2.bin', 'cdbin/HOCKEY.BIN', 0x28A7E, 0x427E);
compareAt('output/segacd/hockey/cdgfxptrs.bin', 'cdbin/HOCKEY.BIN', 0x2CCFC, 0xB0);
compareAt('output/segacd/hockey/cdpads.bin', 'cdbin/HOCKEY.BIN', 0x2CDAC, 0x45E);
compareAt('output/segacd/hockey/teamdata94.bin', 'cdbin/HOCKEY.BIN', 0x0, 0x5432);
compareAt('output/segacd/starter/subtext.bin', 'cdbin/STARTER.BIN', 0x4788, 0x272);
compareAt('output/segacd/starter/heapalloc.bin', 'cdbin/STARTER.BIN', 0x49FA, 0x28A);
compareAt('output/segacd/starter/subinit.bin', 'cdbin/STARTER.BIN', 0x4C84, 0x11A);
compareAt('output/segacd/starter/copydata.bin', 'cdbin/STARTER.BIN', 0x4DDE, 0x48);
compareAt('output/segacd/starter/engine.bin', 'cdbin/STARTER.BIN', 0x4ECE, 0xDA);
compareAt('output/segacd/starter/readdata.bin', 'cdbin/STARTER.BIN', 0x5068, 0x24);
compareAt('output/segacd/starter/subirq.bin', 'cdbin/STARTER.BIN', 0x40FA, 0x23C);
compareAt('output/segacd/starter/crt.bin', 'cdbin/STARTER.BIN', 0x5304, 0x1F2);
compareAt('output/segacd/starter/subhdr.bin', 'cdbin/STARTER.BIN', 0x90, 0x14B2);
compareAt('output/segacd/starter/subdrv.bin', 'cdbin/STARTER.BIN', 0x1542, 0x24CA);
compareAt('output/segacd/starter/subdrv_2.bin', 'cdbin/STARTER.BIN', 0x3A8A, 0x30A);
compareAt('output/segacd/main/maindisp_2.bin', 'cdbin/MAIN.BIN', 0x40D0, 0xE9A);
compareAt('output/segacd/main/mainfont_2.bin', 'cdbin/MAIN.BIN', 0x4F6A, 0x300);
compareAt('output/segacd/main/maintext_2.bin', 'cdbin/MAIN.BIN', 0x526A, 0x48E);
compareAt('output/segacd/main/maincrt.bin', 'cdbin/MAIN.BIN', 0x34B8, 0xF0);
compareAt('output/segacd/main/mainstart.bin', 'cdbin/MAIN.BIN', 0x35A8, 0x174);
compareAt('output/segacd/main/maintable.bin', 'cdbin/MAIN.BIN', 0x371C, 0x100);
compareAt('output/segacd/main/mainwram.bin', 'cdbin/MAIN.BIN', 0x3C3E, 0x492);
compareAt('output/segacd/main/mainmod.bin', 'cdbin/MAIN.BIN', 0x77B8, 0x7448);
compareAt('output/segacd/main/maincrt_2.bin', 'cdbin/MAIN.BIN', 0x56F8, 0xF0);
compareAt('output/segacd/main/mainvdpinit.bin', 'cdbin/MAIN.BIN', 0x57E8, 0x624);
compareAt('output/segacd/main/mainz80.bin', 'cdbin/MAIN.BIN', 0x5E0C, 0x1850);
compareAt('output/segacd/main/maincmd.bin', 'cdbin/MAIN.BIN', 0x765C, 0x6C);
compareAt('output/segacd/player/playerinit.bin', 'cdbin/PLAYER.BIN', 0x0, 0x1D54);
compareAt('output/segacd/player/playercode.bin', 'cdbin/PLAYER.BIN', 0x281C, 0x1768);
compareAt('output/segacd/player/playertext.bin', 'cdbin/PLAYER.BIN', 0x3F84, 0x142);
compareAt('output/segacd/player/playerphotos.bin', 'cdbin/PLAYER.BIN', 0x40C6, 0x6DAA);
compareAt('output/segacd/starter/filmopen_tag.bin', 'cdbin/STARTER.BIN', 0x4538, 0x54);
compareAt('output/segacd/starter/filmtask_tag.bin', 'cdbin/STARTER.BIN', 0x472E, 0xC);
compareAt('output/segacd/starter/filmclose_tag.bin', 'cdbin/STARTER.BIN', 0x477C, 0xC);
compareAt('output/segacd/starter/filmcmd_tag.bin', 'cdbin/STARTER.BIN', 0x4DCA, 0x14);
compareAt('output/segacd/starter/filmbuf_tag.bin', 'cdbin/STARTER.BIN', 0x4EC0, 0xE);
compareAt('output/segacd/starter/startertext.bin', 'cdbin/STARTER.BIN', 0x556E, 0x66A);
compareAt('output/segacd/starter/startergfx.bin', 'cdbin/STARTER.BIN', 0x5BD8, 0x15336);
compareAt('output/segacd/starter/startertail.bin', 'cdbin/STARTER.BIN', 0x1AF0E, 0x26AA);
compareAt('output/segacd/data/gtable.bin', 'cdbin/GTABLE.BIN', 0x0, 0x800);
compareAt('output/segacd/data/graph2.bin', 'cdbin/GRAPH2.BIN', 0x0, 0x2E9000);
compareAt('output/segacd/main/mainstart_2.bin', 'cdbin/MAIN.BIN', 0x381C, 0x320);
compareAt('output/segacd/boot/header.bin', 'cdbin/BOOT.BIN', 0x0, 0x200);
compareAt('output/segacd/boot/security.bin', 'cdbin/BOOT.BIN', 0x200, 0x584);
compareAt('output/segacd/boot/ip.bin', 'cdbin/BOOT.BIN', 0x784, 0x87C);
compareAt('output/segacd/boot/sp.bin', 'cdbin/BOOT.BIN', 0x1000, 0x7000);
