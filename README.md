# fledge-plugin-localnet

Algorand localnet lifecycle plugin for [fledge](https://github.com/CorvidLabs/fledge).

## Install

```bash
fledge plugins install CorvidLabs/fledge-plugin-localnet
```

## Commands

| Command | Description |
|---------|-------------|
| `fledge localnet start` | Start Algorand localnet |
| `fledge localnet stop` | Stop localnet |
| `fledge localnet reset` | Reset localnet to genesis |
| `fledge localnet status` | Show running state and ports |
| `fledge localnet fund <address>` | Dispense Algos from faucet |
| `fledge localnet accounts` | List accounts with balances |

## Data Persistence

Localnet state is managed by AlgoKit and Docker. Running `fledge localnet reset` wipes all chain data (accounts, transactions, ASAs). Reinstalling this plugin has no effect on localnet state.

## Security

- The `fund` command validates Algorand addresses (58-char base32) and amounts (positive integers) before execution.
- All values are single-quoted in shell commands to prevent injection.

## Exposing Localnet to Remote Agents (socat)

If a remote agent (e.g., corvid-agent in a sandbox) needs to reach this localnet, bridge the ports with socat on the host:

```bash
socat TCP-LISTEN:4001,fork,reuseaddr,bind=0.0.0.0 TCP:localhost:4001 &
socat TCP-LISTEN:8980,fork,reuseaddr,bind=0.0.0.0 TCP:localhost:8980 &
socat TCP-LISTEN:4002,fork,reuseaddr,bind=0.0.0.0 TCP:localhost:4002 &
```

The remote agent's algochat/memory plugins then connect via `ALGOD_URL`, `INDEXER_URL`, and `KMD_URL` env vars pointing to this host.

## Prerequisites

- `algokit` on PATH
- Docker running
