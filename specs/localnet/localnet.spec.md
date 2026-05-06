---
module: localnet
version: 1
status: active
files:
  - bin/fledge-localnet
  - hooks/post-work-start.sh

db_tables: []
depends_on: []
---

# Localnet

## Purpose

Algorand localnet lifecycle management for fledge projects. Wraps `algokit localnet` and `goal` CLI tools to provide start/stop/reset/status/fund/accounts commands via the fledge-v1 protocol. Includes a `post_work_start` lifecycle hook to auto-start localnet for Algorand projects.

## Public API

### Commands

| Command | Args | Description |
|---------|------|-------------|
| `start` | | Start localnet via `algokit localnet start` |
| `stop` | | Stop localnet via `algokit localnet stop` |
| `reset` | | Reset localnet to genesis via `algokit localnet reset` |
| `status` | | Show running state, ports, network ID |
| `fund` | `<address> [--amount <microalgos>]` | Dispense Algos. Default: 10000000 (10 ALGO) |
| `accounts` | | List localnet accounts with balances |

### Lifecycle Hooks

| Hook | Trigger | Behavior |
|------|---------|----------|
| `post_work_start` | After `fledge work start` | Auto-start localnet if `fledge.toml` has `[localnet]` section |

## Invariants

1. All CLI tool invocations go through the fledge-v1 `exec` capability.
2. `fund` defaults to 10,000,000 microAlgos (10 ALGO) if no amount specified.
3. `status` reports Docker container state, not just algokit's opinion.
4. `reset` warns the user before destroying localnet state.
5. The `post_work_start` hook is a no-op if `fledge.toml` lacks a `[localnet]` section.
6. `fund` and `accounts` exec into the algod Docker container to run `goal`.

## Behavioral Examples

```
$ fledge localnet start
  Starting Algorand localnet...
  Localnet started. algod: localhost:4001, KMD: localhost:4002, indexer: localhost:8980

$ fledge localnet status
  Status: running
  algod:   localhost:4001
  KMD:     localhost:4002
  Indexer: localhost:8980

$ fledge localnet fund ABC123...XYZ
  Funded ABC123...XYZ with 10.000000 ALGO

$ fledge localnet accounts
  Address                                          Balance
  FAUCET...ABC                                     1000000.000000 ALGO

$ fledge localnet stop
  Localnet stopped.

$ fledge localnet reset
  Are you sure? This will destroy all localnet state. (y/n)
  Localnet reset to genesis.
```

## Error Cases

| Error | When | Behavior |
|-------|------|----------|
| `algokit not found` | `algokit` not on PATH | Log error with install instructions, exit 1 |
| `Docker not running` | Docker daemon not available | Log error, exit 1 |
| `Localnet not running` | `fund`/`accounts` when stopped | Log error with start hint, exit 1 |
| `Invalid address` | `fund` with malformed address | Log error, exit 1 |
| `Insufficient faucet balance` | Faucet depleted | Log error, suggest reset, exit 1 |

## Dependencies

- `algokit` CLI (external, must be on PATH)
- Docker (external, must be running)
- `goal` CLI (inside algod Docker container)
- fledge-v1 protocol (exec, metadata capabilities)

## Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1 | 2026-05-06 | Initial spec |
