#!/usr/bin/env bash
set -euo pipefail

if [ -f "fledge.toml" ] && grep -q '^\[localnet\]' fledge.toml 2>/dev/null; then
  echo "Algorand project detected — starting localnet..."
  algokit localnet start 2>/dev/null || echo "Warning: could not auto-start localnet"
fi
