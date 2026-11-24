#!/usr/bin/env python3
"""Write src/segacd/hockey/teamdata94cd.asm: the HOCKEY.BIN team data ($0-$5431) in the cartridge's teamdata94.asm form.

  python3 tools/segcd_teamdata.py

Records, palettes, scouting ratings, line sets, players, strings: same layout, macros, legends and comment columns as
the cartridge file; the palettes are incbin files (Extracted/SegaCD/HOCKEY/Pals, written by extractAssetsSegaCD.js) and
playoffseats uses the team number names, as on the cartridge.
Player names and team nicknames are placeholders (P001..., N01...), like the cartridge: the real ones are licensed
and the build (names step) puts them back from Extracted/SegaCD/HOCKEY/PlayerNames.txt / TeamNicknames.txt,
which tools/extractAssetsSegaCD.js reads from the disc."""
import struct, re, sys, os
root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'); os.chdir(root)
d = open('cdbin/HOCKEY.BIN', 'rb').read()
cart = open('src/teamdata94.asm', encoding='latin1').read().split('\n')
# team labels / abbreviations / numbers in file order, and the TeamList block, from the cartridge file
recs = []
for l in cart:
    m = re.match(r'^(\w+)\s+;team record: (.*) \((\w+)\), team (\d+)', l)
    if m: recs.append((m.group(1), m.group(2), m.group(3), int(m.group(4))))
ptrs = [struct.unpack('>I', d[i:i + 4])[0] - 0x1B000 for i in range(0x0C, 0x7C, 4)]
byteam = {rn: ptrs[rn] for _, _, _, rn in recs}
order = sorted(recs, key=lambda r: byteam[r[3]])
assert [r[0] for r in order][:3] == ['AllStarsEast', 'AllStarsWest', 'Boston'], order[:3]

def text(b):
    out = []; cur = ''
    for c in b:
        if 32 <= c < 127 and c != 39:
            cur += chr(c)
        elif c == 39:
            cur += "''"
        else:
            if cur: out.append("'" + cur + "'"); cur = ''
            out.append('$%02X' % c)
    if cur: out.append("'" + cur + "'")
    return ','.join(out) if out else "''"

def string_at(p):
    ln = struct.unpack('>H', d[p:p + 2])[0]
    b = d[p + 2:p + ln]
    if len(b) and b[-1] == 0 and (len(b) % 2 == 1 or True) and ((ln - 2) % 2 == 0): 
        # String macro pads an odd text to even: ln - 2 is even; a trailing 0 is the pad when the text is odd
        pass
    return ln, b

def string_text(p):
    ln = struct.unpack('>H', d[p:p + 2])[0]
    b = d[p + 2:p + ln]
    # the macro pads to an even total: text length n, ln = 2 + n + (n & 1)
    if len(b) and b[-1] == 0 and len(b) % 2 == 0 and len(b) > 1 and b[-2] != 0: b = b[:-1] if (len(b) - 1) % 2 == 1 else b
    return ln, b

lines = []
A = lines.append
def width(s):
    w = 0
    for ch in s: w = (w // 4 + 1) * 4 if ch == '\t' else w + 1
    return w
def C(code, com=None, col=36):
    """code, then the comment at column col (tabs of 4) like the cartridge file, or one tab past a longer code."""
    if com is None: return code
    tabs = ''
    while width(code + tabs) < col: tabs += '\t'
    return code + (tabs or '\t') + com
def cartblock(first, last):
    """the cartridge file's lines from the one starting with first to the one starting with last, inclusive"""
    i = next(n for n, l in enumerate(cart) if l.startswith(first))
    j = next(n for n in range(i, len(cart)) if cart[n].startswith(last))
    return cart[i:j + 1]
A(";\t*** ANONYMIZED: the player names and team nicknames in this file are placeholders. ***")
A(";\tPlayers are P001 ... P653, nicknames N01 ... N26. The real ones are NHLPA / NHL licensed data and are not")
A(";\tstored in this repository.")
A(";")
A(";\tEach Player row and each nickname String holds a placeholder of the same length as the real text (the")
A(";\tPlayer macro writes the row length, so it must not change); the ratings after a name are unchanged.")
A(";")
A(";\tThis file is not included directly: tools/build.js (the 'names' step of --segacd) copies it to")
A(";\toutput/obj/hockey_teamdata.asm with the real names put back (from Extracted/SegaCD/HOCKEY/PlayerNames.txt and")
A(";\tTeamNicknames.txt, which tools/extractAssetsSegaCD.js reads from the disc), and hockey.asm includes that copy.")
A(";\tThe team palettes are incbin files too, like the cartridge's: the extractor writes them from the disc to")
A(";\tExtracted/SegaCD/HOCKEY/Pals/<abbreviation>h.pal (home) and <abbreviation>v.pal (visitor).")
A(";")
A(";\tSame layout as the cartridge's teamdata94.asm (tools/segcd_teamdata.py writes it in that file's form): TeamList")
A(";\tpoints to one record per team, the All-Star teams included. A record holds six word offsets from .0")
A(";\t(Playerdata, Palettedata, Teamname, LineSets, ScoutReport, GoalieOdds), then the palettes, scouting ratings,")
A(";\tgoalie weights, line sets (8 lines of 8 bytes), the players and the city, abbreviation, nickname and arena")
A(";\tstrings. Disc differences: the all-star teams have a nickname ('Eastern division', ...) and the arenas differ.")
A(";\tThe records come in the order of the cartridge file (All Stars East and West first, Winnipeg before")
A(";\tWashington, Florida and Anaheim last).")
A("")
A(C("\tdc.w\t$4EF9,$0002,$2096", ";jmp $22096: HOCKEY.BIN entry (HockeyEntry)"))
A(C("\tdc.w\t$01FF", ";the cartridge has no such word"))
A(C("null", ";a zero long, the tile pointer when there is nothing to draw"))
A(C("", ";(no tiles). Not part of TeamList"))
A("\tdc.l\t0")
A("")
A(C("TeamList", ";List Pointer Table Start. Team number = index (ANH 0 ... WPG 25, ASE 26,"))
A(C("", ";ASW 27)"))
for lab, city, ab, num in sorted(recs, key=lambda r: r[3]):
    A(C("\tdc.l\t%s" % lab, ";%d %s" % (num, ab)))
A("")
A("NumofTeams\t=\t(*-TeamList)/4\t\t;number of teams in TeamList")
A("Playerdata\t=\t0\t\t\t\t\t;record offset of the word offset to the player data (.pld)")
A("Palettedata\t=\t2\t\t\t\t\t;record offset of the word offset to the palettes (.pad)")
A("Teamname\t=\t4\t\t\t\t\t;record offset of the word offset to the team name (.tn)")
A("LineSets\t=\t6\t\t\t\t\t;record offset of the word offset to the line sets (.ls)")
A("ScoutReport\t=\t8\t\t\t\t\t;record offset of the word offset to the scouting report ratings (.sr)")
A("GoalieOdds\t=\t10\t\t\t\t\t;record offset of the word offset to the starting goalie weights (.godds)")
A("")
lsnames = ['NLC (no line changes)', 'Sc1', 'Sc2', 'Chk', 'PP1', 'PP2', 'PK1', 'PK2']
srlegend = cartblock(';q - scoring odds', ';------------------------')
srlegend = [';------------------------'] + srlegend
pldlegend = cartblock(';u - uniform', ';------------------------')
pldlegend = [';------------------------'] + pldlegend
pn = 0; nicks = []; players = []
for k_rec, (lab, city, ab, num) in enumerate(order):
    p = byteam[num]
    offs = struct.unpack('>6H', d[p:p + 12])
    pld, pad, tn, ls, sr, go = offs
    A(C(lab, ";team record: %s (%s), team %d" % (city, ab, num)))
    A(C(".0", "; record base: six word offsets (Playerdata ... GoalieOdds) from here"))
    for nm, n2 in zip(['Playerdata', 'Palettedata', 'Teamname', 'LineSets', 'ScoutReport', 'GoalieOdds'], ['.pld', '.pad', '.tn', '.ls', '.sr', '.godds']):
        A(C("\tdc.w\t%s-.0" % n2, "; %s" % nm))
    A(C(".pad", "; team palettes (home and visitor)"))
    A("\tincbin\t..\\Extracted\\SegaCD\\HOCKEY\\Pals\\%sh.pal\t; home colors" % ab)
    A("\tincbin\t..\\Extracted\\SegaCD\\HOCKEY\\Pals\\%sv.pal\t; visitor colors" % ab)
    if k_rec == 0: lines.extend(srlegend)
    A(C(".sr", "; scouting report ratings"))
    A(";\t\t\tqreb,hvfx")
    A("\tdc.w\t$%04X,$%04X" % struct.unpack('>2H', d[p + sr:p + sr + 4]))
    A(C(".godds", "; starting goalie weights, 4 nibbles (PickStartingGoalie)"))
    A("\tdc.b\t%d,%d" % (d[p + go], d[p + go + 1]))
    A(C(".ls", "; line sets: 8 lines of 8 roster numbers, by position"))
    A(";\t\t\t-G,LD,RD,LW,-C,RW,XA,00")
    for i in range(8):
        r = d[p + ls + 8 * i:p + ls + 8 * i + 8]
        A(C("\tdc.b\t" + ",".join('%02d' % x for x in r), ";line %d %s" % (i + 1, lsnames[i]), 32))
    if k_rec == 0: lines.extend(pldlegend)
    A(C(".pld", ";player data: one player per row, ended by an empty String"))
    A(";\t\t\t\t\t\t\t\t\tunwl,sodp,chga,eytm")
    q = p + pld
    while True:
        ln = d[q + 1]
        if d[q] == 0 and ln == 2: break
        assert d[q] == 0, (lab, hex(q))
        nm = d[q + 2:q + ln]
        if nm and nm[-1] == 0: nm = nm[:-1]
        pn += 1
        ph = ('P%03d' % pn).ljust(len(nm), '_')
        assert len(ph) == len(nm), (lab, nm)
        players.append(nm)
        w = struct.unpack('>4H', d[q + ln:q + ln + 8])
        A(C("\tPlayer\t'%s'," % ph, ','.join('%04X' % x for x in w), 32))
        q += ln + 8
    assert d[q + 1] == 2
    A(C("\tdc.b\t0,2", ";end of player data: empty String"))
    q = p + tn
    A(C(".tn", "; team name: city string (Teamname)"))
    ln, b = string_text(q); A("\tString\t" + text(b)); q += ln
    A(C(".ta", "; team abbreviation string"))
    ln, b = string_text(q); A("\tString\t" + text(b)); assert text(b) == "'%s'" % ab, (lab, b); q += ln
    A(C(".tm", "; team nickname string"))
    ln, b = string_text(q)
    if num >= 26:
        A("\tString\t" + text(b) if b else C("\tdc.w\t2", ";empty String"))
    else:
        nicks.append(b); ph = ('N%02d' % len(nicks)).ljust(len(b), '_')
        A("\tString\t'%s'" % ph)
    q += ln
    A(C(".ar", "; arena string"))
    ln, b = string_text(q); A("\tString\t" + text(b)); q += ln
    A("")
    # the record must end where the next begins

# ---- tail: playoffseats (32 rows of 16 team numbers) and the credits strings, up to $5432 ----
abbr = [r[2] for r in sorted(recs, key=lambda r: r[3])]
A(C("PlayoffRows equ 32", ";playoffseats rows (NewPO picks one at random)"))
A(C("PlayoffRowTeams equ 16", ";teams per playoffseats row"))
A(C("playoffseats", ";32 rows of 16 team numbers (PlayoffRows by"))
A(C("", ";PlayoffRowTeams). Not one entry per team."))
A(C("", ";NewPO picks a row at random, then finds the chosen team in that row."))
A(C("", ";All-star teams are not seeded."))
for i in range(32):
    r = d[0x4FDA + 16 * i:0x4FDA + 16 * i + 16]
    A("\tdc.b\t" + ", ".join(",".join(abbr[x] for x in r[g:g + 4]) for g in range(0, 16, 4)))
    if i % 8 == 7 and i < 31: A("")
A(C("PlayoffSeatsEnd", ";end of playoffseats (size check below)"))
A("\tIF (PlayoffSeatsEnd-playoffseats)<>(PlayoffRows*PlayoffRowTeams)")
A('\t\tinform\t3,"playoffseats must be 32 rows of 16 teams"')
A("\tENDIF")
A("")
A(C("CC_PageEnd equ -1", ";String CC_PageEnd ends a credits page; two in a row end"))
A(C("", ";the credits"))
A("")
A(C("Credits", ";title screen scroller: the copyright lines, then more pages"))
q = 0x51DA
while q < 0x5432:
    ln = struct.unpack('>H', d[q:q + 2])[0]
    b = d[q + 2:q + ln]
    if ln == 2:
        A("\tdc.w\t2")
    else:
        if b[-1] == 0 and len(b) % 2 == 0 and len(b) > 1: b = b[:-1]
        if b == b'\xff': A("\tString\tCC_PageEnd"); A("")
        else: A("\tString\t" + text(b))
    q += ln
assert q == 0x5432, hex(q)

open('src/segacd/hockey/teamdata94cd.asm', 'w', encoding='latin1').write('\n'.join(lines) + '\n')
os.makedirs('Extracted/SegaCD/HOCKEY', exist_ok=True)
open('Extracted/SegaCD/HOCKEY/PlayerNames.txt', 'wb').write(b'\n'.join(players) + b'\n')
open('Extracted/SegaCD/HOCKEY/TeamNicknames.txt', 'wb').write(b'\n'.join(nicks) + b'\n')
print('players', len(players), 'nicknames', len(nicks), 'lines', len(lines))
