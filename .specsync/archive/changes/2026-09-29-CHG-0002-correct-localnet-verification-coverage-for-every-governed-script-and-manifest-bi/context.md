---
change: CHG-0002-correct-localnet-verification-coverage-for-every-governed-script-and-manifest-bi
artifact: context
---

# Context

The rollout verification lane passed three file paths to one `bash -n` invocation. Bash parses only the first
path as the script and treats later operands as positional parameters, so syntax damage in the post-work-start hook
or test harness could pass the required lane. The adjacent manifest check also matched independent strings without
proving that one coherent `localnet` command and hook record referenced the governed files.

This correction runs one syntax check per script and parses `plugin.toml` structurally. The manifest assertion
requires the fledge-v1 protocol, exactly one `localnet` command bound to `bin/fledge-localnet`, and the
`post_work_start` hook bound to `hooks/post-work-start.sh`.
