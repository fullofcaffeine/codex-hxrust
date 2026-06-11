# Parity Scorecard And Kill Criteria

**Date:** 2026-06-10  
**Bead:** `HXCX-0.4` / `codex-hxrust-r46.4`  
**Decision:** Advance the experiment only through explicit gates. Upstream Codex parity decides whether the Haxe core is viable; Cafex parity decides whether a later adapter can replace selected fork seams.

## Decision Outcomes

| Outcome | Meaning |
| --- | --- |
| Helper-only | Keep codex-hxrust as DTO/codegen/fixture tooling. No runtime replacement. |
| Sidecar/headless | Use codex-hxrust as a credential-free or controlled headless runtime for selected tests/workflows. |
| Cafex adapter candidate | Keep upstream-shaped Haxe core and replace selected Cafex seams through an adapter. |
| Broader replacement candidate | Consider replacing larger Codex/Cafex slices after security, licensing, runtime, and support risks are acceptable. |
| Stop | Do not continue the port except for archived learnings. |

## Gate Map

| Gate | Milestone | Primary question | Required decision |
| --- | --- | --- | --- |
| G0 | M0 inventory/oracle | Do we know what to build and how to judge it? | Continue to scaffold or stop |
| G1 | M1 scaffold/compiler | Can Haxe generate deterministic Rust in portable and metal profiles? | Continue to DTO parity or remain helper-only |
| G2 | M2 protocol/DTO | Can Haxe match upstream Codex protocol/schema contracts? | Continue to headless runtime or remain helper-only |
| G3 | M3 headless one-turn | Can Haxe run a credential-free one-turn Codex-compatible loop? | Continue to tool/state slices or stay sidecar-only |
| G4 | M4 tools/state/security | Can host effects be wrapped safely and deterministically? | Continue to Cafex adapter or stay headless-only |
| G5 | M5 Cafex adapter | Can selected Cafex seams pass fixture/contract parity on top of the upstream core? | Target selected adapter replacement or stop at sidecar |
| G6 | M6 replacement review | Is rollout/revert/support risk acceptable? | Choose helper/sidecar/adapter/replacement mode |
| G7 | M7 haxe.rust report | Are compiler gaps upstreamable and production-sustainable? | File upstream work, freeze, or stop |

G6 rollout mode criteria are detailed in `docs/migration-modes-rollout.md` and the checked fixture `reference/migration-modes.v1.json`. Upstream tests passing is necessary for broad replacement, but completion is mode-specific and requires no unclassified gaps for the selected mode.

G6 operator notes are detailed in `docs/operator-runbook.md` and the checked fixture `reference/operator-runbook.v1.json`. The current production default remains disabled until a decision record changes it.

G7 haxe.rust production-readiness evidence is summarized in `docs/haxe-rust-production-readiness.md` and checked by `reference/haxe-rust-production-readiness.v1.json`.

## Scorecard

Each area receives one of:

- `green`: gate passes with repeatable local/CI evidence
- `yellow`: acceptable for next milestone with named risk and follow-up bead
- `red`: hard block for next milestone
- `not-applicable`: explicitly outside the current milestone

### G0: Inventory And Oracle

| Area | Green requirement | Red / kill criterion |
| --- | --- | --- |
| Upstream baseline | Upstream Codex pin, high-value crates, and protocol fixture sources are recorded. | No stable upstream reference exists. |
| Cafex adapter inventory | Cafex deltas are classified and separated from upstream core work. | Cafex fork is treated as the base implementation target. |
| haxe.rust baseline | haxe.rust pin, profile model, and vendoring policy are recorded. | Compiler source or license cannot be identified. |
| Fixture inventory | Upstream and Cafex fixture sources have owners, stages, and harness format. | No fixture oracle exists for DTO/runtime claims. |
| Repo ownership | Reference/vendor/generated-output policy exists. | Whole source trees are copied without ownership/update policy. |

### G1: Scaffold And Compiler Gates

| Area | Green requirement | Red / kill criterion |
| --- | --- | --- |
| Portable build | Minimal portable Haxe app generates Rust and passes `cargo check --locked`. | Portable profile cannot generate/build a minimal crate. |
| Metal build | Minimal metal/native-boundary app generates Rust and passes `cargo check --locked`. | Metal profile cannot compile a minimal typed extern/native-boundary example. |
| Determinism | Regenerating without source changes yields no material generated diff, or differences are documented and stable. | Generated output is non-deterministic in a way CI cannot compare. |
| Doctor JSON | Doctor reports haxe.rust pin, Rust/Haxe versions, profile, fixture root, and dirty-state warnings. | Doctor cannot prove which compiler/runtime generated the artifact. |
| Raw Rust policy | Raw Rust use is banned outside narrow bridge modules. | App-level Haxe requires unchecked raw Rust for ordinary DTO/runtime behavior. |

### G2: Upstream Protocol And DTO Parity

| Area | Green requirement | Red / kill criterion |
| --- | --- | --- |
| Core IDs/newtypes | Request/thread/session IDs round-trip and reject invalid forms as selected upstream schemas require. | IDs are untyped strings throughout core code with no boundary validation. |
| JSON boundary | Unknown-field policy is explicit per DTO family and tested. | Unknown fields are silently dropped where upstream preserves/fails, or vice versa. |
| App-server subset | Initial M2 schema subset fingerprints match upstream fixtures. | Client/server request/notification envelopes cannot match upstream shape. |
| Config/profile subset | Selected config DTOs parse and emit stable diagnostics. | Config parsing requires ad hoc untracked `Dynamic` behavior. |
| Error payloads | Structured failures have stable codes/messages suitable for fixture comparison. | Failures are string-only or unstable across runs. |

### G3: Headless One-Turn Runtime

| Area | Green requirement | Red / kill criterion |
| --- | --- | --- |
| Mock provider | Credential-free mock SSE/JSONL stream drives a one-turn session. | Runtime requires real provider credentials for basic tests. |
| Event order | Start, item/message deltas, completion, and errors match selected upstream event order. | Event ordering cannot be made deterministic. |
| State transition | Session/turn state is reproducible from fixture input. | Basic turn state depends on wall-clock, host process, or untracked globals without redaction. |
| Cancellation | Cancellation/interrupt has safe checkpoints and deterministic terminal state. | Cancellation leaves partial state without recoverable error evidence. |
| Transcript artifacts | Transcript/state output is fixture-comparable. | Output paths or contents are host-specific without normalization. |

### G4: Native Tool And State Capability

| Area | Green requirement | Red / kill criterion |
| --- | --- | --- |
| Process wrapper | Exec is denied by default and requires explicit approval config. | Any fixture can run arbitrary commands by default. |
| Apply-patch wrapper | Dry-run apply-patch works before mutation is allowed. | Mutation is required before dry-run parity exists. |
| Sandbox gate | Unsupported sandbox platforms fail closed with structured errors. | Unsupported platform silently runs without sandbox policy. |
| State backend | JSONL/plain files have clear experiment ownership; SQLite/sqlx or equivalent production persistence is a replacement gate for persistent state parity. | State cannot be inspected, replayed, safely reset, or bounded away from production migration. |
| Diagnostics | Tool output truncation, exit codes, and errors are fixture-comparable. | Tool results differ across runs without documented normalization. |

### G5: Cafex Adapter Compatibility

| Area | Green requirement | Red / kill criterion |
| --- | --- | --- |
| Adapter boundary | Cafex code lives under explicit adapter modules over upstream-shaped core. | Cafex fork-only behavior leaks into core protocol/runtime modules. |
| Receipts | Selected session/turn/active-lane receipts match fixture schemas and newline/pretty JSON conventions. | Receipt shape cannot match Cafex contracts without corrupting upstream core. |
| Effort/mode | Request validation, lifecycle receipt, and next-turn state changes pass selected contracts. | Effort/mode updates require live TUI ownership before headless adapter proof exists. |
| Goals | Minimal goal apply DTO/state semantics pass selected contracts. | Goal behavior cannot be separated from TUI/app-server persistence. |
| Wake/restart | DTOs and receipt validation pass; live process behavior remains wrapped/fail-closed. | Restart/wake requires unsafe process takeover before wrapper policy exists. |
| Seam ledger | Every supported/unsupported Cafex delta maps to a row. | Unsupported seam is silently omitted. |

### G6: Replacement Review

| Area | Green requirement | Red / kill criterion |
| --- | --- | --- |
| Rollout mode | Helper/sidecar/adapter/replacement mode is chosen with evidence. | No bounded deployment mode exists. |
| Rollback | Revert path and operator notes are documented. | A failed rollout cannot restore Rust Codex/Cafex behavior. |
| Drift policy | Upstream Codex and haxe.rust update paths are repeatable. | Pin updates are manual and unreviewable. |
| Support cost | Known unsupported surfaces have issue links and user-facing diagnostics. | Users can enter unsupported flows without clear errors. |

### G7: haxe.rust Production Capability

| Area | Green requirement | Red / kill criterion |
| --- | --- | --- |
| Compiler gaps | haxe.rust gaps are isolated with minimal repros and upstreamable issues. | Port requires private, untracked compiler hacks. |
| Generated quality | Generated Rust is readable enough for diagnostics and passes locked checks. | Generated Rust is too unstable or opaque to debug. |
| Licensing | Distribution model is reviewed for haxe.rust GPL-3.0 and Codex Apache-2.0 interaction. | License obligations are unresolved for any planned distribution. |
| Maintenance | Update cadence, ownership, and CI coverage are realistic. | Keeping the port current requires continuous manual rewrite. |

## Hard Kill Criteria

Stop or downgrade to helper-only if any of these remain true after a reasonable spike:

1. haxe.rust cannot generate/build a minimal portable and metal scaffold under the local toolchain.
2. Generated Rust output is non-deterministic enough that CI cannot compare or validate it.
3. Upstream app-server request/notification envelopes cannot be represented without pervasive `Dynamic` or raw Rust.
4. A credential-free one-turn headless fixture cannot run without real model credentials.
5. Process execution, sandboxing, or mutation cannot be made fail-closed by default.
6. Cafex adapter behavior requires fork-only semantics in the upstream core before M5.
7. Licensing review blocks the intended distribution mode.
8. haxe.rust changes needed for the port cannot be upstreamed, pinned, or carried safely.
9. The Haxe port cannot produce structured errors for unsupported surfaces.
10. Maintaining parity with upstream Codex requires copying whole source trees instead of using pins, manifests, and focused fixtures.

## Decision Record Requirement

At the end of each gate, add a decision record using `docs/templates/gate-decision-record.md`.

Required fields:

- gate and milestone
- evidence artifacts
- scorecard status by area
- selected outcome
- risks accepted
- kill criteria considered
- follow-up beads
- approver/owner

No gate should be marked green without at least one committed artifact or repeatable command.

The G6 replacement decision is recorded in `docs/decision-records/g6-replacement-go-no-go.md` and checked by `reference/replacement-go-no-go.v1.json`.

The HXCX-4.4 state backend decision is recorded in `docs/state-backend-spike.md` and checked by `reference/state-backend-spike.v1.json`.

The HXCX-7 archive decision is recorded in `docs/decision-records/hxcx-7-post-experiment-archive.md` and checked by `reference/post-experiment-archive.v1.json`.
