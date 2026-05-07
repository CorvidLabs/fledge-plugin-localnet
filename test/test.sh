#!/usr/bin/env bash
# Self-contained protocol test harness for fledge-plugin-localnet.
#
# We drive the plugin binary directly with a fledge-v1 init message and
# canned exec responses, then assert on the protocol output. No real
# Docker/AlgoKit needed — the plugin's exec requests are answered by us.

set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BIN="$PLUGIN_DIR/bin/fledge-localnet"
PASS=0
FAIL=0

run_test() {
  local name="$1"
  local init_args="$2"
  local responses="$3"   # newline-separated JSON responses, one per exec the plugin will issue
  local expect_substr="$4"

  # The plugin emits NDJSON to stdout; we feed: init line, then each
  # response line (which the plugin reads after sending exec/confirm/load).
  # We capture stdout and grep for the expected substring.
  local input
  input=$(printf '{"type":"init","version":"fledge-v1","project":{"root":"/tmp/test","name":"t"},"plugin":{"dir":"%s","name":"fledge-plugin-localnet"},"command":"localnet","args":%s}\n%s\n' "$PLUGIN_DIR" "$init_args" "$responses")

  local output
  output=$(printf '%s' "$input" | "$BIN" 2>&1 || true)

  if printf '%s' "$output" | grep -qF -- "$expect_substr"; then
    printf '  ok %s\n' "$name"
    PASS=$((PASS + 1))
  else
    printf '  FAIL %s\n' "$name"
    printf '       expected substring: %s\n' "$expect_substr"
    printf '       got:\n'
    printf '%s\n' "$output" | sed 's/^/         /'
    FAIL=$((FAIL + 1))
  fi
}

# --- status: localnet running ---
run_test "status running" \
  '["status","--json"]' \
  '{"type":"response","id":"check-algokit","value":{"code":0,"stdout":"/usr/local/bin/algokit\n","stderr":""}}
{"type":"response","id":"docker-ps","value":{"code":0,"stdout":"algokit_sandbox_algod: Up\nalgokit_sandbox_indexer: Up\n","stderr":""}}' \
  'status\":\"running'

# --- status: localnet stopped ---
run_test "status stopped" \
  '["status","--json"]' \
  '{"type":"response","id":"check-algokit","value":{"code":0,"stdout":"/usr/local/bin/algokit\n","stderr":""}}
{"type":"response","id":"docker-ps","value":{"code":0,"stdout":"","stderr":""}}' \
  'status\":\"stopped'

# --- fund: rejects malformed Algorand address ---
run_test "fund rejects bad address" \
  '["fund","not-a-valid-address","--amount","1000000"]' \
  '' \
  'Invalid Algorand address'

# --- fund: rejects non-numeric amount ---
run_test "fund rejects bad amount" \
  '["fund","R3FSNPX7MWCX2HLDKA4MKW4CAXUDKC756AZVSBLYDK2S6OG7UFQ7RDUV6M","--amount","abc"]' \
  '' \
  'Invalid amount'

# --- accounts: bubbles up "not running" cleanly ---
run_test "accounts when localnet down" \
  '["accounts"]' \
  '{"type":"response","id":"check-algokit","value":{"code":0,"stdout":"/usr/local/bin/algokit","stderr":""}}
{"type":"response","id":"check-docker","value":{"code":0,"stdout":"ok","stderr":""}}
{"type":"response","id":"accounts","value":{"code":1,"stdout":"","stderr":"localnet not running"}}' \
  'Localnet is not running'

# --- help: produces something ---
run_test "help" \
  '["help"]' \
  '' \
  'localnet'

# --- fund: rejects --amount without value ---
run_test "fund rejects --amount without value" \
  '["fund","R3FSNPX7MWCX2HLDKA4MKW4CAXUDKC756AZVSBLYDK2S6OG7UFQ7RDUV6M","--amount"]' \
  '' \
  '--amount requires a value'

# --- fund: rejects zero amount ---
run_test "fund rejects zero amount" \
  '["fund","R3FSNPX7MWCX2HLDKA4MKW4CAXUDKC756AZVSBLYDK2S6OG7UFQ7RDUV6M","--amount","0"]' \
  '' \
  'must be greater than zero'

# --- fund: rejects amount exceeding uint64 ---
run_test "fund rejects uint64 overflow" \
  '["fund","R3FSNPX7MWCX2HLDKA4MKW4CAXUDKC756AZVSBLYDK2S6OG7UFQ7RDUV6M","--amount","99999999999999999999999"]' \
  '' \
  'exceeds uint64 max'

# --- protocol version validation ---
run_test_raw() {
  local name="$1"
  local raw_init="$2"
  local responses="$3"
  local expect_substr="$4"

  local input
  input=$(printf '%s\n%s\n' "$raw_init" "$responses")

  local output
  output=$(printf '%s' "$input" | "$BIN" 2>&1 || true)

  if printf '%s' "$output" | grep -qF -- "$expect_substr"; then
    printf '  ok %s\n' "$name"
    PASS=$((PASS + 1))
  else
    printf '  FAIL %s\n' "$name"
    printf '       expected substring: %s\n' "$expect_substr"
    printf '       got:\n'
    printf '%s\n' "$output" | sed 's/^/         /'
    FAIL=$((FAIL + 1))
  fi
}

run_test_raw "rejects wrong protocol version" \
  '{"type":"init","version":"fledge-v99","project":{"root":"/tmp/test","name":"t"},"plugin":{"dir":"'"$PLUGIN_DIR"'","name":"fledge-plugin-localnet"},"command":"localnet","args":["help"]}' \
  '' \
  'Unsupported protocol version'

# --- reset: --json support ---
run_test "reset --json" \
  '["reset","--json"]' \
  '{"type":"response","id":"check-algokit","value":{"code":0,"stdout":"/usr/local/bin/algokit","stderr":""}}
{"type":"response","id":"confirm-reset","value":"true"}
{"type":"response","id":"reset","value":{"code":0,"stdout":"","stderr":""}}' \
  'ok\":true,\"action\":\"reset'

# --- accounts: --json support ---
run_test "accounts --json" \
  '["accounts","--json"]' \
  '{"type":"response","id":"check-algokit","value":{"code":0,"stdout":"/usr/local/bin/algokit","stderr":""}}
{"type":"response","id":"check-docker","value":{"code":0,"stdout":"ok","stderr":""}}
{"type":"response","id":"accounts","value":{"code":0,"stdout":"[online]\tR3FSNPX7MWCX2HLDKA4MKW4CAXUDKC756AZVSBLYDK2S6OG7UFQ7RDUV6M\t4000000000000 microAlgos","stderr":""}}' \
  'accounts\":'

# --- unknown subcommand ---
run_test "unknown subcommand" \
  '["wat"]' \
  '' \
  'Unknown command'

# --- summary ---
printf '\n'
printf 'tests: %d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
