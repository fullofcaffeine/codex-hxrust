# Apply-Patch Dry-Run Wrapper

**Date:** 2026-06-10
**Bead:** `HXCX-4.1` / `codex-hxrust-hpu.1`

## Boundary

`codexhx.tools.patch.ApplyPatchDryRun` is a portable Haxe syntax and safety wrapper for the apply-patch envelope used by this project.

It does not read or write the filesystem. It only:

- validates the `*** Begin Patch` / `*** End Patch` envelope
- validates add, delete, update, and move/update hunk headers
- rejects absolute, parent-traversal, empty, dot, and backslash paths
- counts additions, deletions, and context lines
- returns deterministic JSON for success and failure cases

Mutation is disabled by default. If a caller requests mutation through this wrapper, the result is a deterministic `mutation_disabled` failure before parsing.

## Supported Dry-Run Grammar

Supported hunk headers:

- `*** Add File: <relative-path>`
- `*** Delete File: <relative-path>`
- `*** Update File: <relative-path>`
- optional `*** Move to: <relative-path>` immediately after an update header

Add hunks may contain only `+` lines. Delete hunks may not contain body lines. Update hunks may contain `@@`, `+`, `-`, context-space lines, and `*** End of File`.

## Gate

Run from `.`:

```bash
harness/check-apply-patch-dry-run.sh
```

The gate runs:

- Haxe interpreter harness
- haxe.rust generation through `hxml/apply-patch-dry-run.hxml`
- generated `cargo check --locked`
- generated `cargo test --locked`
- generated binary execution
- fixture comparison with `fixtures/hxrust/apply-patch-dry-run-output.v1.jsonl`
