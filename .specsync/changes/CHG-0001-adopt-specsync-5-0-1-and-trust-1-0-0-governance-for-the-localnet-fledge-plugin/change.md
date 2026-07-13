---
id: CHG-0001-adopt-specsync-5-0-1-and-trust-1-0-0-governance-for-the-localnet-fledge-plugin
state: accepted
type: migration
base_commit: 671a53b03892751c92addff95d8cfd4212061a55
---

# Adopt SpecSync 5.0.1 and Trust 1.0.0 governance for the Localnet Fledge plugin

## Intent

Adopt SpecSync 5.0.1 and Trust 1.0.0 governance for the Localnet Fledge plugin

## Affected Canonical Specs

- `localnet`

## Acceptance Criteria

- SpecSync strict checks pass at explicit advisory threshold 0 for the extensionless primary executable.
- Existing requirements have deterministic IDs.
- All four integrations are installed.
- Trust doctor and verification pass.
- Bash syntax, 13 protocol tests, and manifest validation remain green.

## No-spec Rationale

Not applicable
