#!/bin/bash
# segacd_check.sh: build the Sega CD fragments, compare them with cdbin/, and print the matched
# bytes per disc file. Coverage is printed only when every fragment matches.
cd "$(dirname "$0")/.."
node tools/build.js --segacd || exit 1
node tools/segacdCoverage.js
