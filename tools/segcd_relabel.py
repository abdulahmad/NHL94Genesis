import re,glob,difflib,sys
apply=len(sys.argv)>1
def routines(files):
    R={}
    for f in files:
        cur=None
        for l in open(f,encoding='latin-1'): pass
    return R
def scan(f):
    """yield (routine, [(op,label_or_None)], lines range)"""
    L=open(f,encoding='latin-1').read().split('\n'); out=[];cur=None
    for i,l in enumerate(L):
        raw=l.split(';')[0].rstrip()
        m=re.match(r'^([A-Za-z_]\w*)',raw) if raw and raw[0] not in ' \t' else None
        lab=None;rest=raw
        if m: cur=m.group(1); out.append([cur,[],i]); rest=raw[len(cur):]
        else:
            m2=re.match(r'^(\.\w+)',raw)
            if m2: lab=m2.group(1); rest=raw[len(lab):]
        if cur is None: continue
        p=rest.split()
        if not p:
            if lab: out[-1][1].append(('',lab))
            continue
        op=p[0].lower()
        if op in('include','incbin','equ','org','even','section'): continue
        out[-1][1].append((op,lab))
    return L,out
cart={}
for f in glob.glob('src/*94.asm'):
    for r,items,i in scan(f)[1]: cart.setdefault(r,items)
tot=0;changed=0
for f in sorted(glob.glob('src/segacd/hockey/*.asm')):
    L,rs=scan(f); maps={}
    for r,items,i in rs:
        if r not in cart: continue
        ci=cart[r]
        # drop pure label-only entries by merging label onto next op
        def norm(it):
            res=[];pend=None
            for op,lab in it:
                if op=='' : pend=lab; continue
                res.append((op,lab or pend)); pend=None
            return res
        a=norm(ci); b=norm(items)
        sm=difflib.SequenceMatcher(None,[x[0] for x in a],[x[0] for x in b],autojunk=False)
        mp={}
        for tag,i1,i2,j1,j2 in sm.get_opcodes():
            if tag=='equal':
                for k in range(i2-i1):
                    cl=a[i1+k][1]; dl=b[j1+k][1]
                    if cl and dl and cl!=dl: mp[dl]=cl
        # only labels with all-disc-labels covered, avoid duplicates
        tgt=list(mp.values())
        if len(set(tgt))!=len(tgt): 
            seen={};
            for k,v in list(mp.items()):
                if v in seen: del mp[k]
                else: seen[v]=k
        # collision with unmapped disc labels
        dl_all={x[1] for x in items if x[1]}
        ch=True
        while ch:
            ch=False
            for k,v in list(mp.items()):
                if v in dl_all and v not in mp:
                    del mp[k]; ch=True
        if mp: maps[(i,)] = (r,mp,[x for x in rs if x[2]>i][:1])
    # apply by scope
    starts=[x[2] for x in rs]+[len(L)]
    for (i,),(r,mp,_) in maps.items():
        end=starts[starts.index(i)+1]
        tot+=len(mp)
        if apply:
            pat=re.compile(r'(?<![\w.])('+'|'.join(re.escape(k) for k in mp)+r')(?!\w)')
            for n in range(i,end):
                code,sep,cm=L[n].partition(';')
                L[n]=pat.sub(lambda m:mp[m.group(1)],code)+sep+cm
    if apply and maps: open(f,'w',encoding='latin-1').write('\n'.join(L))
print('renames',tot)
