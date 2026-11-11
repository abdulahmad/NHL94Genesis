"""Reproduce the MAIN.BIN Z80 source with a recursive, standard-library decoder.

Run from any directory. No assembler or build artifacts are written here.
The image is MAIN.BIN file $5E0C-$765B, the $1850-byte block InitSoundCommand hands to z80load.asm, which
copies it to Z80 $0000: the vectors, the program from $0600, and the RAM the driver and the 68000 share.
"""
from pathlib import Path
from collections import deque

ROOT = Path(__file__).resolve().parents[1]
BASE = 0
IMAGE = (ROOT / 'cdbin/MAIN.BIN').read_bytes()[0x5e0c:0x765c]
END = BASE + len(IMAGE)
NAMES = {0x0: 'Z80_Reset', 0x1051: 'InterruptReturn', 0x600: 'Z80_Start', 0x62c: 'CommandLoop',
         0x62f: 'WaitCommand', 0x640: 'CommandJumpOffset',
         0x641: 'CommandJumps',
         0x87a: 'ClearCommandQueue', 0x88d: 'PopCommand',
         0x1053: 'ServiceTimers', 0x113e: 'WaitYmReady',
         0x4000: 'YM2612_ADDR1', 0x4001: 'YM2612_DATA1',
         0x4002: 'YM2612_ADDR2', 0x4003: 'YM2612_DATA2',
         0x6000: 'BANK_REGISTER', 0x7f11: 'PSG_DATA',
         0x30: 'CommandQueueLock', 0x31: 'CommandQueueCount',
         0x32: 'CommandByte0', 0x33: 'CommandByte1',
         0x34: 'CommandByte2', 0x35: 'CommandByte3',
         0x36: 'PendingCommands', 0x1ffe: 'Z80_STACK_TOP',
         0x8000: 'BANK_WINDOW', 0x1178: 'FmPitchTable',
         0x1238: 'ChannelBits', 0x1240: 'ChannelClearBits',
         0x1248: 'L1248', 0x12c8: 'L12C8',
         0xea3: 'TimerAValues', 0x112e: 'L112E',
         # the commands (MIDI status nibbles, as the 68000's sound engine sends them)
         0x661: 'NoteOff', 0x6d4: 'NoteOn', 0x740: 'ControlChange', 0x796: 'ProgramChange',
         0x7b2: 'PitchBend', 0x7d4: 'UnsupportedCommand', 0x7dd: 'KeyOffAllChannels',
         0x8bb: 'InitSlotTables', 0x8f8: 'InitResourceTable', 0x919: 'GetSlotSound',
         0x923: 'FindZ80Resource', 0x946: 'KeyOffChannel', 0x97e: 'SetChannelState',
         0xe1f: 'CheckDacChannel', 0xe35: 'StartDacSample',
         0x200: 'SlotSound', 0x280: 'SlotModulation', 0x300: 'SlotVolume', 0x400: 'SlotPitchBend',
         # the DAC sample stream (sound operation 4, docs/segacd_main_shell.md)
         0x92: 'DacRequest', 0x93: 'DacSampleId', 0xa2: 'DacNextBuffer',
         0x1448: 'DacBufferA', 0x1649: 'DacBufferB', 0x184a: 'DacStartMark'}
REFS = set(NAMES)


def label(a):
    REFS.add(a)
    return NAMES.get(a, f'L{a:04X}')


def decode(pc):
    start = pc
    refs = []
    targets = []
    stop = False
    def byte():
        nonlocal pc
        v = IMAGE[pc - BASE]
        pc += 1
        return v
    def word():
        return byte() | byte() << 8
    def addr(v):
        refs.append(v)
        return label(v)
    def imm():
        return f'${byte():02X}'
    def relative():
        v = byte()
        v = pc + (v if v < 128 else v - 256)
        targets.append(v)
        return addr(v)
    def absolute():
        v = word()
        targets.append(v)
        return addr(v)
    op = byte()
    idx = None
    if op in (0xdd, 0xfd):
        idx = 'ix' if op == 0xdd else 'iy'
        op = byte()
    rr = ['bc', 'de', idx or 'hl', 'sp']
    cc = ['nz', 'z', 'nc', 'c', 'po', 'pe', 'p', 'm']
    regs = ['b', 'c', 'd', 'e', 'h', 'l', '(hl)', 'a']
    displacement = None
    def reg(n):
        nonlocal displacement
        if idx and n == 6:
            if displacement is None:
                displacement = byte()
            d = displacement if displacement < 128 else displacement - 256
            return f'({idx}{d:+d})'
        # H/L stay unprefixed in indexed memory transfers.
        if idx and n in (4, 5) and op not in (0x66, 0x6e, 0x74, 0x75):
            return idx + ('h' if n == 4 else 'l')
        return regs[n]
    def alu(n, r):
        return ['add a,', 'adc a,', 'sub ', 'sbc a,',
                'and ', 'xor ', 'or ', 'cp '][n] + r
    x, y, z = op >> 6, (op >> 3) & 7, op & 7
    p, q = y >> 1, y & 1
    if op == 0xcb:
        if idx:
            displacement = byte()
        cb = byte()
        cx, cy, cz = cb >> 6, (cb >> 3) & 7, cb & 7
        r = reg(6 if idx else cz)
        if cx == 0:
            s = ['rlc', 'rrc', 'rl', 'rr', 'sla', 'sra', 'sll', 'srl'][cy] + ' ' + r
        else:
            s = ['?', 'bit', 'res', 'set'][cx] + f' {cy},' + r
        if idx and cz != 6:
            raise ValueError('undocumented indexed CB')
    elif op == 0xed:
        ed = byte()
        ey, ez = (ed >> 3) & 7, ed & 7
        ep, eq = ey >> 1, ey & 1
        if 0x40 <= ed <= 0x7f:
            if ez == 0: s = 'in ' + regs[ey] + ',(c)'
            elif ez == 1: s = 'out (c),' + regs[ey]
            elif ez == 2: s = ('adc' if eq else 'sbc') + ' hl,' + ['bc','de','hl','sp'][ep]
            elif ez == 3:
                a = '(' + addr(word()) + ')'
                r = ['bc','de','hl','sp'][ep]
                s = 'ld ' + (r + ',' + a if eq else a + ',' + r)
            elif ez == 4: s = 'neg'
            elif ez == 5:
                s = 'reti' if ed == 0x4d else 'retn'
                stop = True
            elif ez == 6: s = 'im ' + str([0,0,1,2,0,0,1,2][ey])
            else: s = ['ld i,a','ld r,a','ld a,i','ld a,r','rrd','rld'][ey]
        else:
            s = {0xa0:'ldi',0xa1:'cpi',0xa2:'ini',0xa3:'outi',
                 0xa8:'ldd',0xa9:'cpd',0xaa:'ind',0xab:'outd',
                 0xb0:'ldir',0xb1:'cpir',0xb2:'inir',0xb3:'otir',
                 0xb8:'lddr',0xb9:'cpdr',0xba:'indr',0xbb:'otdr'}[ed]
    elif x == 0:
        if z == 0:
            if y < 2: s = ['nop', 'ex af,af\''][y]
            elif y == 2: s = 'djnz ' + relative()
            elif y == 3:
                s = 'jr ' + relative()
                stop = True
            else: s = 'jr ' + cc[y-4] + ',' + relative()
        elif z == 1:
            s = ('add ' + rr[2] + ',' + rr[p]) if q else ('ld ' + rr[p] + ',' + addr(word()))
        elif z == 2:
            r = 'a' if p != 2 else rr[2]
            a = '(' + (['bc', 'de'][p] if p < 2 else addr(word())) + ')'
            s = 'ld ' + (r + ',' + a if q else a + ',' + r)
        elif z == 3: s = ('dec ' if q else 'inc ') + rr[p]
        elif z == 4: s = 'inc ' + reg(y)
        elif z == 5: s = 'dec ' + reg(y)
        elif z == 6:
            r = reg(y)
            s = 'ld ' + r + ',' + imm()
        else: s = ['rlca','rrca','rla','rra','daa','cpl','scf','ccf'][y]
    elif x == 1:
        s = 'halt' if op == 0x76 else 'ld ' + reg(y) + ',' + reg(z)
    elif x == 2: s = alu(y, reg(z))
    elif z == 0: s = 'ret ' + cc[y]
    elif z == 1:
        if not q: s = 'pop ' + (rr + ['af'])[p if p != 3 else 4]
        elif p == 0:
            s, stop = 'ret', True
        elif p == 1: s = 'exx'
        elif p == 2: s, stop = 'jp (' + rr[2] + ')', True
        else: s = 'ld sp,' + rr[2]
    elif z == 2: s = 'jp ' + cc[y] + ',' + absolute()
    elif z == 3:
        if y == 0: s, stop = 'jp ' + absolute(), True
        elif y == 2: s = 'out (' + imm() + '),a'
        elif y == 3: s = 'in a,(' + imm() + ')'
        else: s = {4:'ex (sp),' + rr[2],5:'ex de,hl',6:'di',7:'ei'}[y]
    elif z == 4: s = 'call ' + cc[y] + ',' + absolute()
    elif z == 5:
        if not q: s = 'push ' + (rr + ['af'])[p if p != 3 else 4]
        else: s = 'call ' + absolute()
    elif z == 6: s = alu(y, imm())
    else:
        targets.append(y * 8)
        s = 'rst ' + f'${y * 8:02X}'
    return pc - start, s, targets, stop, refs


def generate():
    code = {}
    occupied = {}
    # Include padding NOPs in the command vectors. The isolated RET/RETI and
    # two uncalled routines have unambiguous instruction boundaries as well.
    # The reset and restart vectors ($0000-$001F: jp Z80_Start, then jp InterruptReturn, a NOP after each)
    # and the command vectors are four-byte JP / NOP entries.
    queue = deque([0x0, 0x600, 0x97d, 0xf93, 0x1051, 0x10cd] +
                  list(range(0x0, 0x20)) + list(range(0x641, 0x661)))
    # Only vector starts and their NOPs are entries, not JP operand bytes.
    queue = deque(a for a in queue if not (0x641 <= a < 0x661 or a < 0x20) or
                  (a - (0x641 if a >= 0x641 else 0)) % 4 in (0, 3))
    for entry in queue:
        label(entry)
    while queue:
        pc = queue.popleft()
        while BASE <= pc < END and pc not in code:
            if pc in occupied:
                raise ValueError(f'target inside instruction: {pc:04X}')
            n, s, targets, stop, refs = decode(pc)
            if any(a in occupied for a in range(pc, pc+n)):
                raise ValueError(f'overlap: {pc:04X}')
            code[pc] = (n, s)
            for a in range(pc, pc+n): occupied[a] = pc
            queue.extend(targets)
            if stop or pc == 0x1f: break      # $001F: the last vector's NOP; data follows
            pc += n
    # Recognize address construction: add low / ld l / ld h, or add low /
    # ld l(c) / ld a,high / adc carry / ld h(b). Keep the actual instructions.
    for pc in sorted(code):
        n, s = code[pc]
        if not s.startswith('add a,$'):
            continue
        lo = int(s[-2:], 16)
        a = pc+n
        if a not in code or code[a][1] not in ('ld l,a', 'ld c,a'):
            continue
        reglo = code[a][1][3]
        a += code[a][0]
        if a not in code:
            continue
        hi_n, hi_s = code[a]
        high_reg = 'h' if reglo == 'l' else 'b'
        if hi_s.startswith(f'ld {high_reg},$'):
            hi = int(hi_s[-2:], 16)
        elif hi_s.startswith('ld a,$'):
            hi = int(hi_s[-2:], 16)
            nxt = a+hi_n
            if (nxt not in code or code[nxt][1] != 'adc a,$00' or
                    code.get(nxt+2, (0,''))[1] != f'ld {high_reg},a'):
                continue
        else:
            continue
        if hi*256+lo < 0x92:
            continue
        name = label(hi*256+lo)
        code[pc] = (n, f'add a,{name} & $FF')
        code[a] = (hi_n, hi_s[:-3] + f'floor({name}/256)')
    lines = [
        '; =============================================================================',
        "; NHL Hockey 94 Sega CD - MAIN.BIN Z80 sound program",
        '; =============================================================================',
        '; MAIN.BIN file $5E0C-$765B ($1850 bytes): the block InitSoundCommand (game shell',
        '; commands $29 and $40) passes to z80load.asm, which copies it to Z80 RAM $0000.',
        '; It is not the cartridge Z80 driver. $0000 jumps to Z80_Start at $0600; the',
        '; restart vectors jump to InterruptReturn (reti); the RAM below $0600 and after',
        '; the program is zero on the disc. The 68000 writes commands into the queue at',
        '; $0030. CommandJumpOffset is the operand of a JR that the code rewrites to pick',
        '; an entry of CommandJumps. No caller of $10CD was found. There is no JP (HL) /',
        '; JP (IX) dispatch. Written by tools/segacd_z80dis.py from cdbin/MAIN.BIN;',
        '; tables are db/dw, zero runs ds.',
        "; The DAC sample request is DacRequest / DacSampleId ($0092 / $0093); the 68000's",
        '; ServiceZ80DataRequest polls $0072 / $0073 instead (inside the queue here), so no',
        '; request is answered: docs/segacd_main_shell.md, sound operation 4.',
        '; =============================================================================', '',
        '        .binfrom 0', f'        .binto ${END - 1:04X}', '']
    # Every address operand gets a symbol, including constants loaded into pairs.
    for a in sorted(REFS):
        if not BASE <= a < END or (a in occupied and occupied[a] != a):
            lines.append(f'{NAMES.get(a, f"L{a:04X}"):<24} EQU ${a:04X}')
    lines += ['', '        org 0', '']
    comments = {
        0x600: 'Disable interrupts and initialize the driver.',
        0x62c: 'Poll the command queue while servicing YM timers.',
        0x641: 'Eight command vectors, four bytes each.',
        0x7fe: 'Write the two terminated YM register/value lists.',
        0x87a: 'Clear the shared command queue.',
        0x88d: 'Remove the first command and shift the remaining four-byte records.',
        0x661: 'MIDI-style commands from the queue, by status nibble: $8x note off, $9x note on,\n'
               '; $Bx controller (1 and 7), $Cx program, $Ex pitch bend; the slot is the low nibble + byte 3.',
        0x6d4: 'Note on: the slot\'s sound record by kind: 0 an FM instrument, 3 a DAC sample on FM\n'
               '; channel 6 (StartDacSample), 7 a key map (byte 2 + note is the sound).',
        0x7d4: 'Any other status: drop it and key off every FM channel.',
        0x8f8: 'Initialize the four-byte record table at $0100 (id, size, address high, low): entry 0 is\n'
               '; record $7F, the 4 bytes at $184B (kind 3, priority 0, pan $C0, sample id), the DAC\n'
               '; sample sound operation 4 plays; the rest $FF (free).',
        0xe35: 'Start a DAC sample: channel 6 to DAC mode, its pan, DacSampleId from the record\n'
               '; byte 3, DacRequest 1 for the 68000, timer A from the note (the sample rate), and the\n'
               '; stream pointer (BC\') at DacStartMark, which waits for the first buffer.',
        0xea3: 'YM timer A register pairs ($24, $25).',
        0xf93: 'Called by the isolated timer B routine at $10CD.',
        0x1053: 'Poll YM timer A and write DAC sample bytes: 0 ends the sample, $FF ends a buffer (on\n'
                '; to the other once the 68000 has filled it: DacRequest 2 or 3), $FE waits at the start.',
        0x10cd: 'No resolved caller in this image; polls YM timer B.',
        0x113e: 'Wait for the YM2612 busy flag to clear.',
        0x1178: 'FM block/frequency words.',
    }
    pc = BASE
    while pc < END:
        if pc in comments:
            lines += ['', '; ' + comments[pc]]
        if pc in REFS and (pc not in occupied or occupied[pc] == pc):
            if pc in code: lines.append('')
            lines.append(label(pc) + ':')
        if pc in code:
            n, s = code[pc]
            lines.append('        ' + s)
            pc += n
        else:
            words = 0x1178 <= pc < 0x1238
            zero = pc
            while zero < END and IMAGE[zero - BASE] == 0 and zero not in code and \
                    (zero == pc or zero not in REFS):
                zero += 1
            if zero - pc >= 16 and not words:
                lines.append(f'        ds {zero - pc}')
                pc = zero
                continue
            step = 2 if words else 1
            end = pc + step
            while end < min(pc + 16, END) and end not in code and end not in REFS:
                end += step
            if words:
                vals = [IMAGE[i-BASE] | IMAGE[i-BASE+1] << 8 for i in range(pc,end,2)]
                lines.append('        dw ' + ','.join(f'${v:04X}' for v in vals))
            else:
                lines.append('        db ' + ','.join(f'${v:02X}' for v in IMAGE[pc-BASE:end-BASE]))
            pc = end
    lines += ['']
    (ROOT / 'src/segacd/main/mainz80.z80').write_text('\n'.join(lines), encoding='ascii')
    count = sum(n for n, s in code.values())
    print(f'{len(code)} instructions, {count} code bytes, {len(IMAGE)-count} data bytes')
    for pc, (n, s) in code.items():
        if s.startswith('jp ('): print(f'indirect jump ${pc:04X}: {s}')


if __name__ == '__main__':
    generate()
