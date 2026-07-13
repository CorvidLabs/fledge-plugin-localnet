---
change: CHG-0002-correct-localnet-verification-coverage-for-every-governed-script-and-manifest-bi
artifact: testing
---

# Testing

- Run `fledge lanes run verify`; the command script, hook, and test harness must each pass an independent
  `bash -n` invocation before native protocol tests and manifest validation.
- Exercise the manifest predicate against missing, duplicate, and miswired command/hook records; invalid forms
  must fail.
- Run strict SpecSync at the committed 100% file and LOC coverage threshold.
