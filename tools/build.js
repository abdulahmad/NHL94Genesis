#!/usr/bin/env node
// build.js: the whole NHL 94 build, one line per step, on Windows and Linux (wine).
//   node tools/build.js [retail|dev] [--verbose]       full ROM -> output/nhl94.bin (nhl94-dev.bin)
//   node tools/build.js --seg <name|--all> [--verbose] full ROM, then compare one segment (a file src/nhl94.asm
//                                                      includes) or all of them with the same range of nhl94retail.bin
//   node tools/build.js --segacd [--verbose]           Sega CD fragments, compared with cdbin/
// --no-color (or NO_COLOR) turns the colors off; they are also off when the output is not a terminal.
// retail: CHECKSUM=1 and verified against nhl94retail.bin. dev: CHECKSUM=0, not verified.
// The checksum environment variable (set checksum=0 on Windows, checksum=0 node ... on Linux) overrides the default.
const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

const ROOT = path.join(__dirname, '..');
const OUT = path.join(ROOT, 'output');
const { ROMS, findRom } = require('./roms');
const WIN = process.platform === 'win32';

const args = process.argv.slice(2);
const verbose = args.includes('--verbose');
// ANSI colors: off when stdout is not a terminal, NO_COLOR is set, or --no-color. Windows 10+ cmd and
// PowerShell take ANSI codes from Node directly.
const color = process.stdout.isTTY && !('NO_COLOR' in process.env) && !args.includes('--no-color');
const sgr = (code) => (t) => (color ? `\x1b[${code}m${t}\x1b[0m` : String(t));
const c = { dim: sgr('2'), cyan: sgr('36'), green: sgr('32'), yellow: sgr('33'), red: sgr('31'), bold: sgr('1') };
// Values (numbers, $hex, output paths) bold; OK / MATCH green; warnings yellow.
const paint = (t) => t
    .replace(/(output\/\S+|\$[0-9A-F]+|\b\d+(?:\.\d+)?s?\b)/g, (m) => c.bold(m))
    .replace(/\b(MATCH|OK)\b/g, (m) => c.green(m))
    .replace(/\b([1-9]\d*)(\x1b\[0m)? (warnings|skipped)/g, (m) => c.yellow(m))
    .replace(/not verified \([^)]*\)/, (m) => c.yellow(m));
const segIdx = args.indexOf('--seg');
const seg = segIdx >= 0 ? args[segIdx + 1] : null;
const mode = args.find((a) => a === 'retail' || a === 'dev') || 'retail';
const env = (k) => process.env[k] ?? process.env[k.toUpperCase()] ?? process.env[k.toLowerCase()];
const checksum = env('checksum') !== undefined ? (env('checksum') === '0' ? 0 : 1) : (mode === 'dev' && !seg ? 0 : 1);

let steps = 7;
let n = 0;
// Each step is two lines: "[n/6] <step>  <description>", then the result under the description.
// In a colour terminal the step line shows a spinner and a yellow step name while it runs, and is
// redrawn with a green check or a red cross when it ends (cut to the terminal width so it never
// wraps). Otherwise both lines are printed once, after the step.
const ABOUT = {
    names: 'put the real player names and team nicknames (extracted from the ROM) into a copy of src/teamdata94.asm',
    prebuild: 'check the retail ROM and extract graphics/sound assets into Extracted/',
    z80: 'asm80 builds the Z80 sound driver from src/sound/z80_snd_drv93.asm and checks it against the ROM bytes',
    assemble: 'SNASM68k turns src/*.asm into a raw ROM image',
    fixopcodes: "patch the instructions where SNASM picks a different encoding than EA's original assembler",
    fixrom: 'pad to a valid ROM size, write the header end address and the checksum',
    verify: 'compare byte-for-byte with the retail ROM',
    output: 'delete built ROMs and intermediates in output/',
    Extracted: 'delete extracted graphics/sound assets (rebuilt by the next build)',
};
const live = color;
// Braille spinner and check marks need a UTF-8 terminal; old Windows consoles get ASCII.
const utf8 = WIN ? Boolean(process.env.WT_SESSION || process.env.TERM_PROGRAM || process.env.ConEmuANSI)
    : /utf-?8/i.test(process.env.LC_ALL || process.env.LC_CTYPE || process.env.LANG || '');
const SPIN = utf8 ? ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'] : ['|', '/', '-', '\\'];
const OK = utf8 ? '✅' : 'OK';
const BAD = utf8 ? '❌' : 'X';
const MARK = 2;                                                      // columns of the mark: the emoji are two wide
const wide = (m) => /\p{Extended_Pictographic}/u.test(m) ? 1 : 0;   // extra columns beyond .length
const padMark = (m) => m + ' '.repeat(Math.max(0, MARK - m.length - wide(m)));
const INDENT = ' '.repeat(`[0/0] ${live ? ' '.repeat(MARK + 1) : ''}${''.padEnd(10)} `.length);
let current = null;
let dirty = false;
let timer = null;
let frame = 0;
function header(name, paintName, mark) {
    const head = `[${n}/${steps}] ${live ? `${padMark(mark)} ` : ''}${name.padEnd(10)} `;
    let desc = ABOUT[name] || '';
    const width = live ? (process.stdout.columns || 80) - 1 : Infinity;
    if (head.length + wide(mark) + desc.length > width) desc = desc.slice(0, Math.max(0, width - head.length - wide(mark) - 1)) + (width > head.length ? '…'.slice(0, utf8 ? 1 : 0) : '');
    const markPart = live ? `${paintName(padMark(mark))} ` : '';
    return `${c.cyan(`[${n}/${steps}]`)} ${markPart}${paintName(name.padEnd(10))} ${c.dim(desc)}`;
}
const draw = (text) => process.stdout.write(`\r\x1b[2K${text}`);
function stopSpin() { if (timer) { clearInterval(timer); timer = null; } }
function begin(name) {
    n++;
    current = name;
    dirty = false;
    if (!live) return;
    frame = 0;
    draw(header(name, c.yellow, SPIN[0]));
    timer = setInterval(() => { frame = (frame + 1) % SPIN.length; draw(header(name, c.yellow, SPIN[frame])); }, 80);
}
function finish(name, paintName, mark) {
    if (current !== name) begin(name);
    stopSpin();
    if (!live) console.log(header(name, (t) => t, ''));
    else if (!dirty) draw(`${header(name, paintName, mark)}\n`);
    else console.log(header(name, paintName, mark));
    current = null;
}
// Output is wrapped to the terminal width (a TTY only), each continuation line indented under its text, so long messages stay aligned.
// Colors (ANSI codes) do not count toward the width.
const visible = (s) => s.replace(/\x1b\[[0-9;]*m/g, '');
function wrap(text) {
    const width = process.stdout.columns ? process.stdout.columns - 1 : Infinity;
    const out = [];
    for (const raw of String(text).replace(/\s+$/, '').split(/\r?\n/)) {
        const lead = /^\s*/.exec(raw)[0];
        const room = Math.max(20, width - INDENT.length - lead.length - 2);
        if (visible(raw).length - lead.length <= room + 2) { out.push(raw); continue; }
        let line = lead;
        for (let word of raw.slice(lead.length).split(' ')) {
            while (visible(word).length > room && !word.includes('\x1b')) {   // an unbreakable token (a long path)
                if (line.trim()) { out.push(line); line = lead + '  '; }
                out.push(line + word.slice(0, room)); word = word.slice(room); line = lead + '  ';
            }
            if (line.trim() && visible(line).length + 1 + visible(word).length > room + lead.length + 2) { out.push(line); line = lead + '  '; }
            line += (line.trim() ? ' ' : '') + word;
        }
        out.push(line);
    }
    return out;
}
const step = (name, text) => { finish(name, c.green, OK); console.log(wrap(text).map((l) => INDENT + paint(l)).join('\n')); };
function detail(text) {
    if (!verbose || !text.trim()) return;
    if (live && current && !dirty) { stopSpin(); process.stdout.write('\n'); }
    dirty = true;
    console.log(wrap(text).map((l) => INDENT + l).join('\n'));
}
function fail(name, text, log, label = 'FAILED') {
    finish(name, c.red, BAD);
    console.log(wrap(`${label}: ${text}`).map((l, i) => INDENT + (i ? l : l.replace(label, c.red(label)))).join('\n'));
    if (log) console.log(wrap(log).map((l) => INDENT + l).join('\n'));
    console.log(c.red(`BUILD FAILED at ${name}`));
    process.exit(1);
}
// Child processes run async (spawn) so the spinner keeps turning while the assembler works.
function run(cmd, argv, opts = {}) {
    return new Promise((resolve) => {
        const chunks = [];
        let p;
        try { p = spawn(cmd, argv, { cwd: ROOT, ...opts }); } catch (e) { resolve({ status: -1, out: String(e) }); return; }
        p.stdout.on('data', (d) => chunks.push(d));
        p.stderr.on('data', (d) => chunks.push(d));
        p.on('error', (e) => resolve({ status: -1, out: Buffer.concat(chunks).toString('latin1') + String(e) }));
        p.on('close', (code) => resolve({ status: code, out: Buffer.concat(chunks).toString('latin1') }));
    });
}
// The child tools get the color / emoji choice of this terminal (prebuild.js colors its ROM message with it).
const node = async (script, argv) => {
    const r = await run(process.execPath, [path.join(__dirname, script), ...argv], { env: { ...process.env, ...(color ? { NHL_COLOR: '1' } : {}), NHL_EMOJI: utf8 ? '1' : '0' } });
    r.out = Buffer.from(r.out, 'latin1').toString('utf8');                 // run() reads output as latin1 (the assembler's); these tools write UTF-8
    return r;
};

// The generated file gets each player's id (the number of his placeholder, P001) as a comment at the end of his row.
const idNote = (rest, ph) => rest + (rest.includes(';') ? ' ' : '\t;') + ph.slice(0, 4);
const rel = (p) => path.relative(ROOT, p).split(path.sep).join('/');

(async () => {
    if (args.includes('--clean')) {
        steps = 2;
        const walk = (d) => fs.readdirSync(d, { withFileTypes: true }).reduce((a, e) => {
            const f = path.join(d, e.name);
            if (e.isDirectory()) { const r = walk(f); return [a[0] + r[0], a[1] + r[1]]; }
            return [a[0] + 1, a[1] + fs.statSync(f).size];
        }, [0, 0]);
        for (const dir of ['output', 'Extracted']) {
            begin(dir);
            const full = path.join(ROOT, dir);
            if (!fs.existsSync(full)) { step(dir, 'already clean'); continue; }
            const [files, bytes] = walk(full);
            try { fs.rmSync(full, { recursive: true, force: true }); } catch (e) { fail(dir, e.message); }
            step(dir, `removed ${files} files, ${(bytes / 1048576).toFixed(1)} MB`);
        }
        console.log(c.green('CLEAN'));
        return;
    }
// --segacd: the transcribed Sega CD fragments (src/segacd/, options per fragment in tools/segacd.json),
// compared with the disc files in cdbin/ by tools/verifySegacd.js. Does not touch the cartridge build.
if (args.includes('--segacd')) {
    steps = 2;
    ABOUT.assemble = 'SNASM68k assembles each src/segacd/*.asm fragment with its own options';
    ABOUT.verify = 'compare each fragment with its bytes on the disc (cdbin/)';
    const frags = require('./segacd.json');
    const BUILD = path.join(OUT, 'build');
    const CD = path.join(OUT, 'segacd');
    fs.mkdirSync(BUILD, { recursive: true });
    fs.mkdirSync(CD, { recursive: true });
    const exe = path.join(ROOT, 'assembler', 'Assembler.exe');
    begin('assemble');
    const t0 = Date.now();
    for (const f of frags) {
        const out = path.join(CD, `${f.name}.bin`);
        fs.rmSync(out, { force: true });
        const a = ['/p', '/m', '/g', ...f.options, `segacd\\${f.name}.asm,..\\output\\segacd\\${f.name}.bin,..\\output\\build\\${f.name},..\\output\\build\\${f.name}`];
        const r = await (WIN ? run(exe, a, { cwd: path.join(ROOT, 'src') })
            : run('wine', [exe, ...a], { cwd: path.join(ROOT, 'src'), env: { ...process.env, WINEDEBUG: '-all' } }));
        const logPath = path.join(BUILD, `Build_${f.name}.log`);
        fs.writeFileSync(logPath, r.out, 'latin1');
        const sum = r.out.match(/(\d+) error\(s\) from/);
        if (!sum || Number(sum[1]) > 0 || !fs.existsSync(out)) {
            const lines = r.out.split(/\r\n|\n|\r/);
            fail('assemble', `${f.name} (see ${rel(logPath)})`, lines.filter((l) => /\.(asm|inc|mac)\(\d+|error|not recognised|undefined/i.test(l) && !/error\(s\) from/.test(l)).slice(0, 40).join('\n') || lines.slice(-20).join('\n'));
        }
        detail(`${f.name}: ${sum[0]} -> ${rel(out)}`);
    }
    step('assemble', `${frags.length} fragments, 0 errors in ${((Date.now() - t0) / 1000).toFixed(1)}s -> output/segacd/`);
    begin('verify');
    const r = await node('verifySegacd.js', []);
    const matches = (r.out.match(/ MATCH /g) || []).length;
    if (r.status !== 0) {
        fail('verify', r.out.trim().split(/\r?\n/).pop(), verbose ? r.out : '', /missing .*cdbin/.test(r.out) ? 'FAILED' : 'MISMATCH');
    }
    step('verify', `MATCH ${matches} fragments against cdbin/`);
    detail(r.out);
    process.exit(0);
}

if (segIdx >= 0 && !seg) {
    console.error('--seg needs a segment name or --all');
    process.exit(1);
}
// A segment build is the full build; the verify step then compares the segment's address range only.
const name = 'nhl94';
// Intermediate files go in output/build/: the raw assembler image, its listing and the log.
// The one result is output/<final>: nhl94.bin (retail or a segment check) or nhl94-dev.bin.
const BUILD = path.join(OUT, 'build');
const bin = path.join(BUILD, `${name}.raw.bin`);
const lst = path.join(BUILD, `${name} .lst`);
const fixed = path.join(BUILD, `modified_${name}.raw.bin`);
const logPath = path.join(BUILD, `Build_${name}.log`);
const final = `nhl94${mode === 'dev' && !seg ? '-dev' : ''}.bin`;
const mod = path.join(OUT, final);

// 1. prebuild: ROM check and Extracted/ assets.
{
    begin('prebuild');
    const r = await node('prebuild.js', ['retail']);
    if (r.status !== 0) fail('prebuild', 'ROM or asset extraction', r.out);
    let count = '?';
    try { count = JSON.parse(fs.readFileSync(path.join(ROOT, 'Extracted', '.extract-complete.json'), 'utf8')).files.length; } catch (e) { /* keep ? */ }
    step('prebuild', `ROM OK, ${count} assets extracted`);
    detail(r.out);
}

// 2. z80: asm80 (npm devDependency) assembles src/sound/z80_snd_drv93.asm into output/build/z80_snd_drv93.bin, which
// sound94.asm includes. It must equal the bytes extracted from the ROM (Extracted/NHL94/Sound/z80_snd_drv93.bin)
// except Z80 $278-$27C, the FM patch address operands that sound94.asm writes from fm_instrument_patches.
{
    begin('z80');
    fs.mkdirSync(BUILD, { recursive: true });
    const src = path.join(ROOT, 'src', 'sound', 'z80_snd_drv93.asm');
    const out = path.join(BUILD, 'z80_snd_drv93.bin');
    let asm80;
    try { asm80 = require.resolve('asm80/asm80.js'); } catch (e) { fail('z80', 'asm80 is not installed, run npm i'); }
    fs.rmSync(out, { force: true });
    // asm80 writes the output (and its .lst) relative to the source folder.
    const r = await run(process.execPath, [asm80, '-m', 'Z80', '-t', 'bin', '-o', path.relative(path.dirname(src), out), path.relative(ROOT, src)]);
    const zlog = path.join(BUILD, 'Build_z80_snd_drv93.log');
    fs.writeFileSync(zlog, r.out, 'latin1');
    if (r.status !== 0 || !fs.existsSync(out) || /ERROR/.test(r.out)) fail('z80', `asm80 failed, see ${rel(zlog)}`, r.out.split(/\r?\n/).slice(-12).join('\n'));
    detail(r.out);
    const built = fs.readFileSync(out);
    const ref = fs.readFileSync(path.join(ROOT, 'Extracted', 'NHL94', 'Sound', 'z80_snd_drv93.bin'));
    let i = 0;
    while (i < built.length && i < ref.length && (built[i] === ref[i] || (i >= 0x278 && i < 0x27D))) i++;
    if (built.length !== ref.length || i < built.length) fail('z80', `${rel(out)} (${built.length} bytes) differs from the ROM bytes (${ref.length} bytes) at Z80 $${i.toString(16).toUpperCase()}`, null, 'MISMATCH');
    step('z80', `MATCH ${built.length} bytes (except the FM patch address at $278-$27C) == ROM $1AD90-$1B01A -> ${rel(out)}`);
}

// 3. names: src/teamdata94.asm holds placeholders instead of the licensed names (the NHLPA player names
// and the NHL team nicknames). The extractor writes the real ones from the ROM to Extracted/PlayerNames.txt and
// Extracted/TeamNicknames.txt (one per line, in source order); this copies the file to output/build/ with each
// placeholder replaced, and nhl94.asm includes the copy. A name must have the length of its placeholder (the Player macro
// writes the row length). Player rows are replaced in order; a nickname placeholder is 'N' + its two-digit number in
// TeamNicknames.txt, padded with '_'.
{
    begin('names');
    const read = (f) => { const l = fs.readFileSync(path.join(ROOT, 'Extracted', f), 'latin1').split('\n'); if (l[l.length - 1] === '') l.pop(); return l; };
    const players = read('PlayerNames.txt'), nicks = read('TeamNicknames.txt');
    let p = 0;
    const used = new Set();
    const nickRe = /'(N(\d\d)_*)'/g;
    const put = (name, text) => {
        const src = path.join(ROOT, 'src', name);
        const out = fs.readFileSync(src, 'latin1')
            .replace(/^([ \t]*Player[ \t]+')((?:[^']|'')*)(')([^\r\n]*)/gm, (m, a, ph, z, rest) => {
                const real = players[p++];
                if (real === undefined) fail('names', `${rel(src)} has more Player rows than PlayerNames.txt has names (${players.length})`);
                const want = ph.replace(/''/g, "'").length;
                if (real.length !== want) fail('names', `Player row ${p}: the name '${real}' has ${real.length} characters, its placeholder '${ph}' has ${want}`);
                return a + real.replace(/'/g, "''") + z + idNote(rest, ph);
            })
            .replace(nickRe, (m, ph, id) => {
                const real = nicks[Number(id) - 1];
                if (real === undefined) fail('names', `${rel(src)}: nickname placeholder '${ph}' has no entry in TeamNicknames.txt (${nicks.length})`);
                if (real.length !== ph.length) fail('names', `nickname ${id}: '${real}' has ${real.length} characters, its placeholder '${ph}' has ${ph.length}`);
                used.add(id);
                return "'" + real.replace(/'/g, "''") + "'";
            });
        fs.writeFileSync(path.join(BUILD, name), out, 'latin1');
    };
    fs.mkdirSync(BUILD, { recursive: true });
    put('teamdata94.asm');
    if (p !== players.length) fail('names', `PlayerNames.txt has ${players.length} names, src/teamdata94.asm has ${p} Player rows`);
    step('names', `${p} player names, ${nicks.length} team nicknames -> ${rel(path.join(BUILD, 'teamdata94.asm'))}`);
}

// 4. assemble: SNASM68k, directly on Windows, under wine elsewhere. Its console output is the log.
{
    begin('assemble');
    fs.mkdirSync(BUILD, { recursive: true });
    for (const f of [bin, fixed, mod]) fs.rmSync(f, { force: true });
    const src = 'nhl94.asm';
    const o = `..\\output\\build\\${name}`;
    const asmArgs = ['/p', '/m', '/g', '/o', 'd-', '/o', 's-', '/o', 'r+', '/o', 'l+', '/o', 'l.', '/o', 'ow+', '/o', 'op-',
        '/o', 'os+', '/o', 'oz+', '/o', 'omq-', '/o', 'oaq+', '/o', 'osq+',
        '/e', `CHECKSUM=${checksum}`, `${src},${o}.raw.bin,${o},${o}`];
    const exe = path.join(ROOT, 'assembler', 'Assembler.exe');
    const r = await (WIN ? run(exe, asmArgs, { cwd: path.join(ROOT, 'src') })
        : run('wine', [exe, ...asmArgs], { cwd: path.join(ROOT, 'src'), env: { ...process.env, WINEDEBUG: '-all' } }));
    fs.writeFileSync(logPath, r.out, 'latin1');
    const lines = r.out.split(/\r\n|\n|\r/);
    const sum = r.out.match(/(\d+) error\(s\) from (\d+) lines in ([\d.]+) seconds/);
    const warnings = lines.filter((l) => /warning/i.test(l)).length;
    const short = lines.filter((l) => /SHORTCALL /.test(l));
    if (short.length) {
        fail('assemble', 'a routine called with a short jsr/jmp (x).w moved past $7FFF',
            short.join('\n') + '\nPut the added data after menu94 (or after the 1MB pad), or change those calls to .l.\nSee docs/EXPANDING_THE_ROM.md.');
    }
    if (!sum) fail('assemble', `no assembler summary in ${rel(logPath)} (exit ${r.status})`, lines.slice(-20).join('\n'));
    const errors = Number(sum[1]);
    if (errors > 0 || !fs.existsSync(bin)) {
        const bad = lines.filter((l) => /\.(asm|inc|mac)\(\d+|error|fatal|not recognised|undefined/i.test(l) && !/error\(s\) from/.test(l)).slice(0, 40);
        fail('assemble', `${errors} error(s), see ${rel(logPath)}`, bad.join('\n'));
    }
    step('assemble', `${errors} errors, ${warnings} warnings, ${sum[2]} lines in ${sum[3]}s (CHECKSUM=${checksum}) -> ${rel(bin)}`);
    detail(r.out);
}

// 5. fixopcodes: rewrite the EA cmp / exg encodings SNASM picks differently; the result becomes output/<final>.
{
    begin('fixopcodes');
    const r = await node('fixopcodes.js', [lst, bin]);
    const m = r.out.match(/Modified (\d+) instructions/);
    if (r.status !== 0 || !m || !fs.existsSync(fixed)) fail('fixopcodes', 'did not write the fixed binary', r.out);
    fs.renameSync(fixed, mod);
    const skipped = (r.out.match(/Skipping/g) || []).length;
    step('fixopcodes', `${m[1]} opcodes fixed${skipped ? `, ${skipped} skipped` : ''}`);
    detail(r.out);
}

// 6. fixrom: pad to the cartridge size, header ROM end, boot checksum.
{
    begin('fixrom');
    const r = await node('fixrom.js', [lst, mod]);
    const m = r.out.match(/size (\w+) \(end (\w+)\), checksum (\w+) -> (\w+)/);
    if (r.status !== 0 || !m) fail('fixrom', 'size or checksum', r.out);
    step('fixrom', `size $${m[1].toUpperCase()}, header end $${m[2].toUpperCase()}, checksum $${m[4].toUpperCase()}${m[3] !== m[4] ? ` (was $${m[3].toUpperCase()})` : ''}`);
    detail(r.out);
}

// 7. verify against the retail ROM.
if (!seg && mode === 'dev') {
    step('verify', `${rel(mod)} not verified (dev build)`);
} else {
    begin('verify');
    const REF = findRom(ROMS.retail).path;
    const r = await (seg ? node('verifySegment.js', [seg, mod, REF, lst]) : node('verifyRom.js', [mod, REF]));
    const first = r.out.split(/\r?\n/).find((l) => l.trim()) || '';
    if (r.status !== 0 || !/^MATCH/.test(first)) {
        fail('verify', rel(mod), r.out, 'MISMATCH');
    }
    step('verify', `MATCH ${rel(mod)}${seg ? ` (${first.replace(/^MATCH:?\s*/, '')})` : ''}`);
    detail(r.out);
}
})();
