# fledge-plugin-localnet

Algorand localnet lifecycle plugin for [fledge](https://github.com/CorvidLabs/fledge). Start, stop, reset, and manage a local Algorand network for development.

## Install

```bash
fledge plugins install CorvidLabs/fledge-plugin-localnet
```

## Commands

### `fledge localnet start`

Start the Algorand localnet via AlgoKit and Docker.

```
$ fledge localnet start
Starting localnet...
Localnet is running.
```

### `fledge localnet stop`

Stop the running localnet. Chain state is preserved for next start.

### `fledge localnet reset`

Reset localnet to genesis. **Warning:** This wipes all chain data — accounts, transactions, ASAs.

### `fledge localnet status`

Show whether localnet is running and which ports are active.

```
$ fledge localnet status
Localnet: running
  algod:   http://localhost:4001
  indexer: http://localhost:8980
  KMD:     http://localhost:4002
```

### `fledge localnet fund <address> [--amount <microalgos>]`

Dispense Algos from the localnet faucet to an address. Default amount: 10,000,000 microAlgos (10 ALGO).

```
$ fledge localnet fund PZZCVTTZN4VUV6PPGKZ73GKYNXDHPZAYHN6BETWZPD4JSLB7WHMGZLQGRE
Funded PZZCVTTZ... with 10 ALGO

$ fledge localnet fund PZZCVTTZN4VUV6PPGKZ73GKYNXDHPZAYHN6BETWZPD4JSLB7WHMGZLQGRE --amount 5000000
Funded PZZCVTTZ... with 5 ALGO
```

### `fledge localnet accounts`

List all localnet accounts with their balances.

## Exposing Localnet to Remote Agents (socat)

If a remote agent (e.g., corvid-agent in a sandbox) needs to reach this localnet, bridge the ports with socat on the host:

```bash
socat TCP-LISTEN:4001,fork,reuseaddr,bind=0.0.0.0 TCP:localhost:4001 &
socat TCP-LISTEN:8980,fork,reuseaddr,bind=0.0.0.0 TCP:localhost:8980 &
socat TCP-LISTEN:4002,fork,reuseaddr,bind=0.0.0.0 TCP:localhost:4002 &
```

The remote agent's algochat/memory plugins then connect via `ALGOD_URL`, `INDEXER_URL`, and `KMD_URL` env vars pointing to this host.

## Data Persistence

Localnet state is managed by AlgoKit and Docker. Running `fledge localnet reset` wipes all chain data (accounts, transactions, ASAs). Reinstalling this plugin has no effect on localnet state.

## Security

- The `fund` command validates Algorand addresses (58-char base32) and amounts (positive integers) before execution.
- All values are single-quoted in shell commands to prevent injection.

## Prerequisites

- [AlgoKit](https://github.com/algorandfoundation/algokit-cli) on PATH
- Docker running
- `jq` and `bc` on PATH

## License

MIT
