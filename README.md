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

## Prerequisites

- `algokit` on PATH
- Docker running
