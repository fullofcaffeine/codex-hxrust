# Operator Runbook

**Date:** 2026-06-11
**Bead:** `HXCX-6.4` / `codex-hxrust-ryo.4`
**Decision feed:** `HXCX-6.3`

## Purpose

This runbook explains how to run, disable, distribute, or roll back the codexhx experiment in Cafetera/Cafex workflows.

Machine-readable fixture:

`reference/operator-runbook.v1.json`

Validation gate:

```bash
cd experiments/codex-hxrust
harness/check-operator-runbook.sh
```

## Current Default

Production default is unchanged:

- `productionDefaultChanged`: `false`
- current supported mode: local experiment only
- Cafetera workflow routing: not enabled by default

No production default may change until `HXCX-6.3` or a later decision record selects a rollout mode and accepts the rollback, distribution, diagnostics, licensing, and support risks.

## Run The Experiment

Local smoke checks:

```bash
cd experiments/codex-hxrust
harness/check-doctor-json.sh
harness/check-headless-jsonl-adapter.sh
harness/check-cafetera-contract-subset.sh
harness/check-migration-modes.sh
```

Build/regenerate checks:

```bash
cd experiments/codex-hxrust
npx haxe hxml/portable.codegen.hxml
npx haxe hxml/metal.codegen.hxml
scripts/check-generated-cargo.sh
```

Use these commands as local proof only. They do not enable production routing.

## Disable

Current disable path:

1. Stop invoking codexhx harnesses or generated binaries from the caller workflow.
2. Remove any local experimental binary path from Cafetera wrapper configuration.
3. Route requests back to upstream Codex or the Cafex fork.

Reserved future control:

```bash
export CAF_CODEX_HXRUST_MODE=disabled
```

That variable is a planned wrapper contract only. It is not a production integration until a decision record accepts it.

## Rollback

For a local experiment integration commit:

```bash
git revert <codexhx-integration-commit>
git pull --rebase
bd sync
git push
```

For generated output cleanup:

```bash
rm -rf experiments/codex-hxrust/generated/portable
rm -rf experiments/codex-hxrust/generated/metal
```

For a haxe.rust pin rollback:

```bash
git revert <pin-update-commit>
experiments/codex-hxrust/scripts/audit-haxe-rust.sh
cd experiments/codex-hxrust
scripts/check-generated-cargo.sh
```

State policy:

- Do not migrate or delete production state in this experiment.
- Preserve sidecar/generated state for diagnostics before cleanup.
- If a live workflow is affected, route back to upstream Codex/Cafex before debugging codexhx.

## Distribution Shape

| Artifact | Path | Status |
| --- | --- | --- |
| Source and fixtures | `experiments/codex-hxrust` | Repo source only. |
| Pins and decision inputs | `reference` | Repo source only. |
| Generated Rust | `experiments/codex-hxrust/generated` | Build output, not committed. |
| haxe.rust compiler | `../haxe.rust` | External pinned checkout, not bundled. |

Before any binary or bundled release, complete the license/distribution review called out in `docs/haxe-rust-vendoring-policy.md`.

## Operator Diagnostics

| Check | Command | Purpose |
| --- | --- | --- |
| Doctor | `cd experiments/codex-hxrust && harness/check-doctor-json.sh` | Verify haxe.rust pin, profile, generated binary output shape, and local toolchain metadata. |
| Diagnostics redaction | `cd experiments/codex-hxrust && harness/check-diagnostics.sh` | Verify secret redaction and failure-report fixture IDs. |
| Friction comparison | `cd experiments/codex-hxrust && harness/check-friction-comparison.sh` | Verify replacement-review evidence still matches the local Cafex patch and seam ledgers. |
| Migration modes | `cd experiments/codex-hxrust && harness/check-migration-modes.sh` | Verify rollout mode criteria still forbid contract bypasses. |

Failure handoff:

1. Record failing command, git commit, haxe.rust pin, upstream Codex pin, Cafex pin, and rollout mode.
2. Attach redacted JSONL fixture output when available.
3. If failure affects live workflow ownership, route back to upstream Codex/Cafex before debugging codexhx.

## Guardrails

- No mode bypasses contracts.
- No Cafex behavior is routed through codexhx by default.
- No generated Rust is edited by hand or treated as source.
- No haxe.rust compiler changes are made codexhx-specific.
- No production default changes without a decision record.
