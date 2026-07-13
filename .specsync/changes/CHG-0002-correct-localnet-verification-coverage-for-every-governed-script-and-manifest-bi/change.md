---
id: CHG-0002-correct-localnet-verification-coverage-for-every-governed-script-and-manifest-bi
state: accepted
type: bug_fix
base_commit: d98aa85b315c1ea16a96680dc7f5397c85c2eedd
---

# Correct Localnet verification coverage for every governed script and manifest binding

## Intent

Correct Localnet verification coverage for every governed script and manifest binding

## Affected Canonical Specs

- None

## Acceptance Criteria

- The verification lane runs bash syntax checking independently for the command
- hook
- and test scripts; structural TOML validation binds the localnet command and post-work-start hook to their exact files; native tests and strict SpecSync 100% coverage pass

## No-spec Rationale

This correction strengthens repository verification configuration without changing Localnet plugin runtime behavior or its canonical contract.
