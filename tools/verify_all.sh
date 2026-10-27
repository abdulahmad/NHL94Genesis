#!/bin/bash
# verify_all.sh: full ROM + all segment ranges under wine. Usage: tools/verify_all.sh [-q|--quiet]
# -q: print only failures and the final ALL MATCH / VERIFY FAILED line.
export WINEDEBUG=-all
cd "$(dirname "$0")/.."
quiet=0; case "$1" in -q|--quiet) quiet=1;; esac
# Fresh extract, the full ROM (tools/build.js), then every segment (each file src/nhl94.asm includes) compared
# with the same address range of nhl94retail.bin (tools/verifySegment.js; ranges from the build listing).
rm -rf Extracted; node tools/prebuild.js retail >/tmp/x94.log 2>&1 || { echo "PREBUILD FAIL"; cat /tmp/x94.log; exit 1; }
fail=0
node tools/build.js retail >/tmp/top.log
[ $quiet = 1 ] || cat /tmp/top.log
grep -qE '^ +MATCH ' /tmp/top.log || { fail=1; [ $quiet = 1 ] && cat /tmp/top.log; }
if [ -f "output/build/nhl94 .lst" ] && [ -f output/nhl94.bin ]; then
  if r=$(node tools/verifySegment.js --all 2>&1); then
    [ $quiet = 1 ] || echo "$r" | sed 's/^MATCH: //'
  else
    echo "$r" | grep -v '^MATCH'; fail=1
  fi
else
  echo "segments: no full build output"; fail=1
fi
if [ "$fail" = 1 ]; then
  echo "VERIFY FAILED"
  exit 1
fi
echo "ALL MATCH"
exit 0
