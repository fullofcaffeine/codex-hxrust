# Migration Modes And Adapter Rollout

**Date:** 2026-06-11
**Bead:** `HXCX-6.2` / `codex-hxrust-ryo.2`
**Decision feed:** `HXCX-6.3`

## Purpose

This document defines how codexhx can move from helper tooling to possible replacement work without turning a green test run into an overbroad production claim.

Machine-readable fixture:

`reference/migration-modes.v1.json`

Validation gate:

```bash
harness/check-migration-modes.sh
```

## Completion Rule

Completeness is mode-specific.

All upstream tests passing is necessary for a broad replacement claim, but it is not sufficient. A mode is complete only when every claimed surface has fixture or test evidence, every skipped upstream test is classified, every Cafex seam is supported/native/out-of-scope by decision, and rollback is documented.

Short form:

> Upstream tests passing proves compatibility pressure. Completion requires a zero-unclassified-gap ledger for the selected rollout mode.

## Modes

| Mode | Claim | Best current fit |
| --- | --- | --- |
| Helper-only | DTOs, codecs, schema fingerprints, fixture transforms, reports, and haxe.rust pressure tests. No runtime replacement. | Safe default for protocol/schema/reporting work. |
| Sidecar/headless | Selected credential-free or controlled headless flows run beside upstream Codex. | Good target for app-server/debug JSONL and one-turn runtime slices. |
| Selected adapter-slice replacement | Named Cafex adapter slices move to codexhx while upstream Codex/Cafex still owns the rest. | Plausible for fixture-backed receipts, continuity, effort/wake request receipts, and minimal goal lifecycle after decision review. |
| Broader replacement candidate | Larger Codex/Cafex runtime surfaces can be replaced for an explicitly bounded distribution. | Not supported by current evidence. |

## Helper-Only

Entry criteria:

- G1 compiler scaffold and doctor gates pass for portable and metal profiles.
- Used upstream/Cafex schemas have fixture or fingerprint evidence.
- No runtime, process, sandbox, model, or TUI authority is exposed.

Exit criteria:

- Helper outputs are reproducible from pinned upstream or Cafex sources.
- Runtime surfaces are documented as not applicable.
- Generated Rust remains disposable and is not presented as a runtime artifact.

Rollback:

- Remove helper commands from the calling workflow or revert the helper package/pin.
- Keep upstream Codex/Cafex runtime unchanged.
- Delete generated outputs; do not migrate persistent state.

Impact:

- Operators see no production runtime behavior changes.
- Developers maintain Haxe fixtures, reports, and haxe.rust pins.

Contracts:

- Schema fingerprints must match the pinned source or be accepted in a decision record.
- Fixture transforms must be deterministic and credential-free.

## Sidecar/Headless

Entry criteria:

- Helper-only completion gate is green.
- G2 upstream protocol/DTO subset and G3 headless one-turn gates pass.
- Native tool/state gates used by the sidecar fail closed by default.
- Unsupported commands return structured errors.

Exit criteria:

- Selected headless workflows pass fixture parity in Haxe and generated Cargo gates.
- State and transcript artifacts are normalized and replayable.
- The sidecar can be disabled without changing upstream Codex runtime behavior.

Rollback:

- Disable the sidecar integration flag or remove the sidecar binary from the caller path.
- Route traffic back to upstream Codex/Cafex.
- Preserve sidecar state for diagnostics, then delete it after handoff if no migration is required.

Impact:

- Operators get a separate process or command surface with structured diagnostics.
- Developers maintain protocol adapters, runtime fixtures, state normalization, and generated Cargo gates.

Contracts:

- App-server/debug JSONL protocol shape must match selected upstream contracts.
- Tool, sandbox, process, and state wrappers must fail closed before mutation is enabled.

## Selected Adapter-Slice Replacement

Entry criteria:

- Sidecar/headless completion gate is green for the slice dependencies.
- G5 Cafex contract subset passes for every selected slice.
- The seam ledger marks every selected row supported and every unselected row unsupported, native, or out of scope.
- The HXCX-6.1 friction comparison shows positive maintenance value for the selected slice.

Exit criteria:

- Each selected slice has contract fixtures, rollback commands, diagnostics, and owner sign-off.
- No selected slice depends on unsupported live TUI, restart, queue, sandbox, or credentialed-provider paths unless they are typed native boundaries.
- Cafex fork behavior can be restored without data loss.

Rollback:

- Flip selected slice routing back to the Cafex fork implementation.
- Retain generated receipts/state snapshots for comparison.
- Keep Cafex fork patch support until a replacement-review record accepts the slice.

Impact:

- Operators may run mixed ownership: codexhx for selected adapter files/receipts, Cafex fork for live runtime.
- Developers maintain adapter boundaries and Cafetera contract fixtures per selected slice.

Contracts:

- Cafex request/receipt schemas and newline/pretty JSON conventions must remain exact.
- Unknown schemas and unsupported live operations must fail closed.
- Adapter code must not leak Cafex-only behavior into upstream-shaped core modules.

## Broader Replacement Candidate

Entry criteria:

- Selected adapter-slice completion gate is green for all replacement dependencies.
- All upstream tests for the claimed surface pass, are ported with equivalent assertions, or have accepted not-applicable records.
- All Cafex seam-ledger rows are supported, explicitly native, or accepted as out of scope in a decision record.
- Security, licensing, distribution, rollback, haxe.rust production-readiness, and support-cost reviews are complete.

Exit criteria:

- No unclassified upstream test gaps remain for the claimed surface.
- No unclassified Cafex seam gaps remain for the claimed surface.
- Operators can disable or roll back the replacement without orphaned state or unclear ownership.
- haxe.rust updates are pinned, reproducible, and upstreamable.

Rollback:

- Pin and retain the last known-good upstream Codex/Cafex runtime for immediate restoration.
- Keep state migration reversible or run in shadow mode until reverse migration is proven.
- Disable codexhx routing globally before attempting partial repair.

Impact:

- Operators depend on codexhx for runtime behavior inside the claimed surface.
- Developers maintain broad parity against upstream Codex and Cafex plus haxe.rust production gates.

Contracts:

- Upstream protocol, app-server, config, runtime, tools, state, and security contracts must be green for the claimed surface.
- Cafex/Cafetera contracts must be green or explicitly native/adapted.
- No contract may be skipped by routing around codexhx without a decision record.

## Rollout Order

1. Keep helper-only as the safe default for schema, DTO, fixture, and reporting work.
2. Promote only credential-free headless flows to sidecar/headless after protocol and runtime gates pass.
3. Promote only named Cafex slices after their seam-ledger rows and contract subset pass.
4. Consider broader replacement only after upstream tests, Cafex seams, security/licensing, haxe.rust production readiness, and rollback drills all have evidence.

No mode bypasses contracts. If a contract cannot be implemented yet, the mode must either fail closed, route to an explicit native owner, or record the unsupported surface before HXCX-6.3.

Operator commands, distribution shape, diagnostics, and rollback details live in `docs/operator-runbook.md` and the checked fixture `reference/operator-runbook.v1.json`.
