# Process Exec Wrapper

**Date:** 2026-06-10
**Bead:** `HXCX-4.2` / `codex-hxrust-hpu.2`

## Boundary

`codexhx.tools.process.ProcessExecRunner` is the first process execution wrapper for the Haxe Codex experiment.

It uses `sys.io.Process` only after an explicit `ProcessExecPolicy` approval matches the exact command and argument list. Missing policy, empty allowlist, or non-matching command returns `command_denied` before a process is constructed.

The wrapper returns deterministic JSON:

- `executed: false` for denied and invalid requests
- `executed: true` only after a child process is spawned
- `exitStatus: success` for exit code `0`
- `exitStatus: nonzero` plus `process_exit_nonzero` for non-zero exit codes
- normalized stdout/stderr text with deterministic truncation metadata

The first gate intentionally does not expose environment mutation, shell-string construction, working directory selection, detached execution, stdin streaming, timeouts, or sandbox overrides.

## Approval Model

Approval is exact-match only:

- command string must match
- argument count must match
- every argument must match in order

The test harness uses generated scripts under `generated/process-exec-sandbox`. The denied script would create `denied.marker` if it ran; the harness asserts the marker is absent. The approved script creates `approved.marker`, proving execution happened only after explicit approval.

## Gate

Run from `.`:

```bash
harness/check-process-exec.sh
```

The gate runs:

- Haxe interpreter harness
- haxe.rust generation through `hxml/process-exec.hxml`
- generated `cargo check --locked`
- generated `cargo test --locked`
- generated binary execution
- fixture comparison with `fixtures/hxrust/process-exec-output.v1.jsonl`
