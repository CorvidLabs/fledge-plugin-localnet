---
spec: localnet.spec.md
---

## User Stories

- As a developer, I want to start/stop Algorand localnet with a single command
- As a developer, I want to fund test accounts without remembering goal syntax
- As an AI agent, I want to check localnet status before sending transactions

## Acceptance Criteria

- All 6 commands work via fledge-v1 protocol
- post_work_start hook auto-starts localnet for Algorand projects
- Clear error messages when prerequisites are missing

## Constraints

- Wraps algokit/goal, does not reimplement
- Shell script, no compile step

## Out of Scope

- TestNet/MainNet management
- Smart contract deployment
