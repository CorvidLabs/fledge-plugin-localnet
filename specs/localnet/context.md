---
spec: localnet.spec.md
---

## Context

Extracted from corvid-agent's Algorand localnet management. Provides a standalone CLI for any fledge project that needs a local Algorand network.

## Related Modules

- fledge-plugin-algochat (uses localnet for on-chain messaging)
- fledge-plugin-memory (uses localnet for mutable/permanent memory tiers)

## Design Decisions

- Wraps algokit rather than reimplementing Docker management
- fund and accounts exec into the algod Docker container because goal is not typically installed on the host
- post_work_start hook checks for [localnet] in fledge.toml to avoid auto-starting for non-Algorand projects
