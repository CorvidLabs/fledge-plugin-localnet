#!/usr/bin/env bash
set -euo pipefail

if [ ! -f "fledge.toml" ] || ! grep -q '^\[localnet\]' fledge.toml 2>/dev/null; then
  exit 0
fi

if ! command -v algokit >/dev/null 2>&1; then
  echo "Skipping localnet auto-start: algokit not on PATH" >&2
  exit 0
fi

if ! docker info >/dev/null 2>&1; then
  echo "Skipping localnet auto-start: Docker not running" >&2
  exit 0
fi

echo "Algorand project detected — starting localnet..."
# Run with stderr visible so failures (e.g., port conflict, broken
# AlgoKit install) are diagnosable. Don't redirect to /dev/null — the
# previous behavior masked real errors behind a generic warning.
if ! algokit localnet start; then
  echo "Warning: 'algokit localnet start' exited non-zero — see output above" >&2
  exit 0
fi
