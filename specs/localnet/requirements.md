---
spec: localnet.spec.md
---

## User Stories

- As a developer, I want to start/stop Algorand localnet with a single command
- As a developer, I want to fund test accounts without remembering goal syntax
- As an AI agent, I want to check localnet status before sending transactions

## Acceptance Criteria

### REQ-localnet-001

All six lifecycle and account commands work through the fledge-v1 protocol.

### REQ-localnet-002

The post_work_start hook auto-starts localnet only for projects that declare a localnet configuration.

### REQ-localnet-003

Missing prerequisites and invalid addresses or amounts produce clear errors without a false success.

## Constraints

- Wraps algokit/goal, does not reimplement
- Shell script, no compile step

## Out of Scope

- TestNet/MainNet management
- Smart contract deployment
