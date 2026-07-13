---
change: CHG-0001-adopt-specsync-5-0-1-and-trust-1-0-0-governance-for-the-localnet-fledge-plugin
artifact: testing
---

# Testing

Local acceptance requires Bash syntax, all 13 protocol harness cases, manifest validation, strict SpecSync checks at threshold 0, four integrations, healthy Trust doctor, and a clean diff.

The protocol harness provides verification evidence for `REQ-localnet-001` across all six lifecycle and account commands.

Hosted acceptance requires the new `trust` job and existing protocol test job to pass while Pages remains independent.
