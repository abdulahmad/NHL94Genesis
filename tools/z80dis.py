#!/usr/bin/env python3
"""Small Z80 disassembler (documented opcodes, DD/FD/CB/ED prefixes). Used for the Sega CD Z80 sound driver.

  python3 tools/z80dis.py FILE OFFSET LENGTH [ORG]"""
import sys
R = ['b', 'c', 'd', 'e', 'h', 'l', '(hl)', 'a']
RP = ['bc', 'de', 'hl', 'sp']; RP2 = ['bc', 'de', 'hl', 'af']
CC = ['nz', 'z', 'nc', 'c', 'po', 'pe', 'p', 'm']
ALU = ['add a,', 'adc a,', 'sub ', 'sbc a,', 'and ', 'xor ', 'or ', 'cp ']
ROT = ['rlc', 'rrc', 'rl', 'rr', 'sla', 'sra', 'sll', 'srl']


def dis(b, o, pc):
    """-> (length, text, target or None)"""
    def u8(k): return b[o + k]
    def s8(k): v = b[o + k]; return v - 256 if v > 127 else v
    def u16(k): return b[o + k] | (b[o + k + 1] << 8)
    op = b[o]
    idx = None
    n = 0
    if op in (0xDD, 0xFD):
        idx = 'ix' if op == 0xDD else 'iy'; n = 1; op = b[o + 1]
        if op in (0xDD, 0xFD, 0xED): return 1, 'db $%02X' % b[o], None
    def reg(r):
        if r == 6 and idx: return '(%s%+d)' % (idx, s8(n + 1))
        if idx and r in (4, 5): return idx + ('h' if r == 4 else 'l')
        return R[r]
    def rpn(p): return idx if (idx and p == 2) else RP[p]
    x, y, z = op >> 6, (op >> 3) & 7, op & 7; p, q = y >> 1, y & 1
    disp = 1 if (idx and (z == 6 or (x == 1 and y == 6) or (x == 2 and z == 6)) and x != 0 or (idx and x == 0 and z == 6 and y == 6) or (idx and x == 0 and z == 4 and y == 6) or (idx and x == 0 and z == 5 and y == 6)) else 0
    if op == 0xCB and idx:
        d = s8(2); c = b[o + 3]; x, y, z = c >> 6, (c >> 3) & 7, c & 7
        m = '(%s%+d)' % (idx, d)
        t = ('%s %s' % (ROT[y], m)) if x == 0 else ('%s %d,%s' % (['', 'bit', 'res', 'set'][x], y, m))
        return 4, t, None
    if op == 0xCB and not idx:
        c = b[o + 1]; x, y, z = c >> 6, (c >> 3) & 7, c & 7
        t = ('%s %s' % (ROT[y], R[z])) if x == 0 else ('%s %d,%s' % (['', 'bit', 'res', 'set'][x], y, R[z]))
        return 2, t, None
    if op == 0xED and not idx:
        c = b[o + 1]; x, y, z = c >> 6, (c >> 3) & 7, c & 7; p, q = y >> 1, y & 1
        if x == 1:
            if z == 0: return 2, 'in %s,(c)' % ('f' if y == 6 else R[y]), None
            if z == 1: return 2, 'out (c),%s' % ('0' if y == 6 else R[y]), None
            if z == 2: return 2, '%s hl,%s' % ('adc' if q else 'sbc', RP[p]), None
            if z == 3:
                a = u16(2)
                return 4, ('ld %s,($%04X)' % (RP[p], a)) if q else ('ld ($%04X),%s' % (a, RP[p])), None
            if z == 4: return 2, 'neg', None
            if z == 5: return 2, 'reti' if y == 1 else 'retn', None
            if z == 6: return 2, 'im %d' % [0, 0, 1, 2, 0, 0, 1, 2][y], None
            if z == 7: return 2, ['ld i,a', 'ld r,a', 'ld a,i', 'ld a,r', 'rrd', 'rld', 'nop', 'nop'][y], None
        if x == 2 and z <= 3 and y >= 4:
            return 2, ['ldi', 'cpi', 'ini', 'outi', 'ldd', 'cpd', 'ind', 'outd', 'ldir', 'cpir', 'inir', 'otir', 'lddr', 'cpdr', 'indr', 'otdr'][(y - 4) * 4 + z], None
        return 2, 'db $ED,$%02X' % c, None
    L = lambda k: n + 1 + disp + k   # offset after opcode + displacement
    if x == 1:
        if y == 6 and z == 6: return n + 1, 'halt', None
        if idx and (y == 6 or z == 6):
            return n + 2, 'ld %s,%s' % ((R[y] if z == 6 else reg(y)), (R[z] if y == 6 else reg(z))) if y == 6 or z == 6 else '', None
        return n + 1, 'ld %s,%s' % (reg(y), reg(z)), None
    if x == 2:
        l = n + 1 + (1 if (idx and z == 6) else 0)
        return l, '%s%s' % (ALU[y], reg(z)), None
    if x == 0:
        if z == 0:
            if y == 0: return n + 1, 'nop', None
            if y == 1: return n + 1, "ex af,af'", None
            d = s8(n + 1); t = pc + n + 2 + d
            if y == 2: return n + 2, 'djnz $%04X' % (t & 0xFFFF), t & 0xFFFF
            if y == 3: return n + 2, 'jr $%04X' % (t & 0xFFFF), t & 0xFFFF
            return n + 2, 'jr %s,$%04X' % (CC[y - 4], t & 0xFFFF), t & 0xFFFF
        if z == 1:
            if q == 0: return n + 3, 'ld %s,$%04X' % (rpn(p), u16(n + 1)), None
            return n + 1, 'add %s,%s' % (idx or 'hl', rpn(p)), None
        if z == 2:
            if idx is None or p == 2:
                if p == 0: return n + 1, 'ld (bc),a' if q == 0 else 'ld a,(bc)', None
                if p == 1: return n + 1, 'ld (de),a' if q == 0 else 'ld a,(de)', None
                a = u16(n + 1)
                if p == 2: return n + 3, ('ld ($%04X),%s' % (a, idx or 'hl')) if q == 0 else ('ld %s,($%04X)' % (idx or 'hl', a)), None
                return n + 3, ('ld ($%04X),a' % a) if q == 0 else ('ld a,($%04X)' % a), None
            if p == 0: return 1, 'ld (bc),a' if q == 0 else 'ld a,(bc)', None
            return 1, 'ld (de),a' if q == 0 else 'ld a,(de)', None
        if z == 3: return n + 1, ('inc %s' if q == 0 else 'dec %s') % rpn(p), None
        if z == 4: return n + 1 + (1 if idx and y == 6 else 0), 'inc %s' % reg(y), None
        if z == 5: return n + 1 + (1 if idx and y == 6 else 0), 'dec %s' % reg(y), None
        if z == 6:
            l = n + 2 + (1 if idx and y == 6 else 0)
            return l, 'ld %s,$%02X' % (reg(y), b[o + l - 1]), None
        if z == 7: return n + 1, ['rlca', 'rrca', 'rla', 'rra', 'daa', 'cpl', 'scf', 'ccf'][y], None
    if x == 3:
        if z == 0: return n + 1, 'ret %s' % CC[y], None
        if z == 1:
            if q == 0: return n + 1, 'pop %s' % (idx if idx and p == 2 else RP2[p]), None
            return n + 1, ['ret', 'exx', 'jp (%s)' % (idx or 'hl'), 'ld sp,%s' % (idx or 'hl')][p], None
        if z == 2: a = u16(n + 1); return n + 3, 'jp %s,$%04X' % (CC[y], a), a
        if z == 3:
            if y == 0: a = u16(n + 1); return n + 3, 'jp $%04X' % a, a
            if y == 2: return n + 2, 'out ($%02X),a' % b[o + n + 1], None
            if y == 3: return n + 2, 'in a,($%02X)' % b[o + n + 1], None
            if y == 4: return n + 1, 'ex (sp),%s' % (idx or 'hl'), None
            if y == 5: return n + 1, 'ex de,hl', None
            if y == 6: return n + 1, 'di', None
            if y == 7: return n + 1, 'ei', None
        if z == 4: a = u16(n + 1); return n + 3, 'call %s,$%04X' % (CC[y], a), a
        if z == 5:
            if q == 0: return n + 1, 'push %s' % (idx if idx and p == 2 else RP2[p]), None
            if p == 0: a = u16(n + 1); return n + 3, 'call $%04X' % a, a
        if z == 6: return n + 2, '%s$%02X' % (ALU[y], b[o + n + 1]), None
        if z == 7: return n + 1, 'rst $%02X' % (y * 8), None
    return 1, 'db $%02X' % b[o], None


if __name__ == '__main__':
    f, off, ln = sys.argv[1], int(sys.argv[2], 0), int(sys.argv[3], 0)
    org = int(sys.argv[4], 0) if len(sys.argv) > 4 else 0
    b = open(f, 'rb').read(); o = off
    while o < off + ln:
        l, t, _ = dis(b, o, org + o - off)
        print('%04X  %-12s %s' % (org + o - off, b[o:o + l].hex(), t)); o += l
