#!/bin/bash
# verify_mod_league.sh — stock ROM parity plus save-layout checks for large leagues.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
echo "=== retail verify_all ==="
bash tools/verify_all.sh
echo "=== save layout (28 and 34 teams) ==="
node tools/checkSaveLayout.js 28 34
echo "MOD LEAGUE CHECKS OK (stock ROM MATCH; layout math printed above)"
