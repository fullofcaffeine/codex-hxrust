# Codex hxrust Port Plan

**Date:** 2026-06-10  
**Inputs:** `codex-hxrust-port-prd.md`, `codex-hxrust-beads-import-notes.md`, `codex-hxrust-beads-backlog.seed.jsonl`, local `../haxe.rust` checkout  
**Current haxe.rust checkout:** `../haxe.rust` on `main` at `ba76e4861b0b3a30e8f572cc2bd159e0e004973e` with `origin` set to `git@github.com:fullofcaffeine/reflaxe.rust.git`, plus the local CallStack workaround recorded in `reference/haxe-rust-local-patches.v1.json`

## Planning Stance

This is a contract-first compatibility experiment, not a file-by-file Codex rewrite.

Base the port on mainstream upstream Codex first. Upstream Codex is the product and protocol authority; Cafex is an adaptation target whose seams must be preserved or deliberately replaced after the upstream-compatible core is proven. The Cafex fork remains essential evidence, but it should not become the foundation that the Haxe port must chase structurally.

The first credible deliverable is a Haxe-authored, Rust-emitted, headless Codex-compatible slice that proves upstream DTO/protocol parity and deterministic one-turn runtime behavior. Cafex seam compatibility is designed in as a later adapter gate, with inventory and fixtures gathered early so the upstream-shaped core does not paint us into a corner. Full TUI replacement, full upstream workspace replacement, and broad sandbox reimplementation stay out of scope until the gated evidence says otherwise.

Source-of-truth order:

1. Upstream Codex `../codex` for core protocol, config, app-server DTOs, headless runtime semantics, and future upstream drift.
2. Cafex/Cafetera `../fullofcaffeine/deps/codex` plus Cafetera fixtures for receipts, goals, effort/mode/wake/restart compatibility.
3. haxe.rust `../haxe.rust` for generation/runtime constraints and implementation feasibility.

This means M2, M3, and M4 target upstream Codex shape first; M5 is the Cafex adapter/conformance layer. Cafex appears in G0 only as inventory and future oracle material. A Cafex behavior can move earlier only as passive fixture/codegen scaffolding, and only when it does not distort the upstream-compatible core.

The plan follows the PRD gates:

| Gate | Beads area | Outcome |
| --- | --- | --- |
| G0 | `HXCX-0` | Inventory, Cafex delta classification, parity matrix, kill criteria |
| G1 | `HXCX-1` | haxe.rust scaffold, portable/metal builds, locked Cargo checks |
| G2 | `HXCX-2` | Protocol/DTO/schema/fixture parity |
| G3 | `HXCX-3` | Credential-free one-turn headless runtime |
| G4 | `HXCX-4` | Native tool/state capability slice with fail-closed wrappers |
| G5 | `HXCX-5` | Cafex adapter: receipts, effort/wake, goals, restart/session continuity |
| G6 | `HXCX-6` | Replacement decision and rollout/rollback plan |
| G7 | `HXCX-7` | haxe.rust production capability report and upstreamable gaps |

## haxe.rust Usage Model

Use the local `../haxe.rust` repo as the compiler/runtime source during the experiment. Pin the exact commit in the scaffold once the project layout exists.

Profile policy:

- Use `portable` for DTOs, codecs, fixture transforms, schema fingerprints, config/profile data, and pure state transitions.
- Use `metal` for near-term runtime boundaries that need Rust-first async, process control, native paths, tool execution, sandbox policy wrappers, or production-shaped performance before the portable lowering is mature enough.
- Enable `rust_async` only in metal paths. Keep the supported entry shape: sync `main`, async helper returning `rust.async.Future<T>`, and `Async.blockOn(...)` at the boundary.
- Prefer `reflaxe.std.Option/Result` for portable code where useful; use explicit `rust.*` APIs only in native-lane/metal code.
- Keep app-level Haxe pure. Native Rust belongs in small wrapper modules bound with typed externs, `@:native`, `@:rustCargo`, and `@:rustExtraSrc`.
- Follow `docs/interop-boundary-policy.md` for wrapper ownership, raw Rust restrictions, and fail-closed security-sensitive host effects.

Performance direction:

- Metal is the practical Rust-native lane for early production-bound runtime/tool work, not the only performance destination.
- Portable output should converge toward metal-equivalent Rust performance wherever haxe.rust can prove Haxe semantics are preserved.
- Any codexhx slice that uses metal mainly because portable output is currently too slow or too awkward should produce a generic haxe.rust fixture/benchmark and a linked HXCX-7/haxe.rust Beads item.

Generated Rust policy:

- Generated Rust is never manually edited.
- Cargo output must be deterministic under `-D rust_output=...`.
- CI must run generated Rust through `cargo check --locked` and generated crate tests.
- Clippy/rustfmt can start as advisory but must be tracked before any replacement decision.

## Repository And Vendoring Strategy

Start with a local path dependency/pin to `../haxe.rust` while the experiment is moving fast. Do not copy the whole compiler tree until the scaffold and ownership decision are complete.

The detailed repository layout decision lives in `docs/repository-layout.md`; the haxe.rust vendoring/update decision lives in `docs/haxe-rust-vendoring-policy.md`.

Recommended phases:

1. **Path pin phase:** record `../haxe.rust` remote, branch, commit, Haxe version, Rust toolchain, and Cargo lock behavior in the scaffold doctor output.
2. **Vendor decision phase:** decide between git submodule, subtree/vendor copy, or external pinned checkout after `HXCX-0.5` chooses repository ownership.
3. **Periodic upstream check phase:** add a repeatable `haxe.rust` upstream audit command that fetches `origin/main`, reports commits since the pinned SHA, runs the relevant haxe.rust validation subset, and opens/updates a bead when merge work is needed.
4. **Merge policy:** update the pin only after `codex-hxrust` G1/G2 gates remain green. Runtime-affecting haxe.rust changes must also rerun headless and Cafex seam fixtures once those gates exist.

The current audit/update commands live in `scripts/audit-haxe-rust.sh` and `scripts/update-haxe-rust-pin.sh`.

This keeps the experiment reproducible without freezing it away from upstream compiler fixes.

## Execution Plan

### M0: Inventory And Oracle

Primary beads:

- `HXCX-0.1` baseline topology
- `HXCX-0.2` Cafex runtime delta classification
- `HXCX-0.3` fixture inventory
- `HXCX-0.4` scorecard and kill criteria
- `HXCX-0.5` repo/module ownership
- `HXCX-0.6` haxe.rust vendoring and upstream update policy

Deliverables:

- Topology note covering upstream Codex, Cafex/Cafetera seams, and haxe.rust profile/build facts.
- Cafex delta ledger grouped into receipts, goals, effort, wake/restart, state, app-server, TUI, and unsupported surfaces.
- Fixture source inventory for upstream protocol, app-server protocol, Cafex receipts, Cafetera contracts, and new mock model streams.
- Parity scorecard with explicit kill criteria.
- Repository ownership decision and vendoring/update policy.

Exit criteria:

- `bd ready` surfaces only implementation work after G0 dependencies are satisfied.
- The first runtime slice is selected and unsupported surfaces are named.

### M1: Scaffold And Compiler Gates

Primary beads:

- `HXCX-1.1` scaffold
- `HXCX-1.2` portable/metal profiles
- `HXCX-1.3` generated Cargo CI gates
- `HXCX-1.4` typed extern/raw Rust policy
- `HXCX-1.5` doctor JSON binary
- `HXCX-1.6` haxe.rust pin/update tooling

Current flattened layout:

```text
README.md
hxml/
  portable.hxml
  metal.hxml
src/codexhx/
  Main.hx
  protocol/
  config/
  runtime/
  state/
  tools/
  adapters/
    cafex/
native/
  src/
fixtures/
  upstream/
  cafex/
  hxrust/
harness/
scripts/
generated/
```

Deliverables:

- Minimal Haxe app builds to Rust in both profiles.
- Doctor JSON includes haxe.rust commit, profile, enabled capabilities, Rust/Haxe versions, fixture root, and native wrapper registry.
- Generated crate passes locked check/test without credentials.
- Interop policy is committed and enforced by review/CI checks.

Exit criteria:

- G1 green in a clean local run.
- No real model calls, process mutation, or sandbox bypass exists.

### M2: Protocol And DTO Parity

Primary beads:

- `HXCX-2.1` IDs/newtypes
- `HXCX-2.2` typed JSON and serde bridge policy
- `HXCX-2.3` config/profile DTO subset
- `HXCX-2.4` event/request/response subset
- `HXCX-2.5` schema fingerprint and golden fixture diff

Implementation order:

1. Define typed IDs and path-like wrappers.
2. Define JSON boundary policy: reject, preserve, or ignore unknown fields per DTO family.
3. Implement selected Codex app-server/headless events and request/response envelopes.
4. Add golden fixture diff and schema fingerprint output.
5. Leave Cafex receipt, effort/wake, and goal DTOs as later adapter work unless a passive schema fixture is needed to unblock M5 planning.

Exit criteria:

- Selected fixtures round-trip exactly.
- Error payloads and unknown fields are deterministic.
- No broad `Dynamic` propagation beyond documented JSON boundary functions.

### M3: Headless One-Turn Runtime

Primary beads:

- `HXCX-3.1` mock stream parser
- `HXCX-3.2` provider interface and mock provider
- `HXCX-3.3` one-turn state machine
- `HXCX-3.4` JSONL/app-server adapter harness
- `HXCX-3.5` transcript/state store
- `HXCX-3.6` cancellation/interrupt

Golden command target:

```bash
codex-hxrust run-fixture fixtures/basic_one_turn.json
```

Expected behavior:

- Emit doctor/version data.
- Load fixture config.
- Start a session and turn.
- Consume a mock model stream.
- Emit ordered Codex-compatible events.
- Write transcript/state artifacts.
- Honor cancellation at safe checkpoints.
- Exit 0 for the happy path and deterministic non-zero codes for structured failures.

Exit criteria:

- One-turn mock event sequence matches golden output.
- CI path needs no model credentials and performs no real mutation.

### M4: Native Tool And State Slices

Primary beads:

- `HXCX-4.1` apply-patch dry-run
- `HXCX-4.2` process exec wrapper and approval model
- `HXCX-4.3` sandbox permission gate wrapper
- `HXCX-4.4` JSONL vs SQLite state spike
- `HXCX-4.5` MCP/tool registry skeleton
- `HXCX-4.6` diagnostics

Rules:

- Process execution is denied by default.
- Sandbox decisions are explicit and fail closed on unsupported platforms.
- Apply-patch starts dry-run only. Real mutation requires a later gate.
- Tool output, truncation, exit codes, and diagnostics are fixture-comparable.

Exit criteria:

- G4 security-sensitive checks pass.
- Unsupported behavior returns explicit structured errors.

### M5: Cafex Adapter And Seam Compatibility

Primary beads:

- `HXCX-5.1` session/turn receipts
- `HXCX-5.2` effort/wake bridge
- `HXCX-5.3` minimal goals flow
- `HXCX-5.4` restart/session continuity
- `HXCX-5.5` Cafetera contract subset
- `HXCX-5.6` seam ledger mapping

Scope:

- Implement Cafex as an adapter over the upstream-shaped Haxe Codex core.
- Preserve Cafex schema and receipt compatibility where selected by the G0 scorecard.
- Keep Cafex-only runtime authority out of the core modules unless it has an upstream analogue.
- Use wrappers for live TUI queues, restart/process handoff, sandbox/jail enforcement, and external Caf/Brew commands.

Seams to prove:

- `CAF_CODEX_TURN_RECEIPT_PATH`
- `CAF_CODEX_SESSION_RECEIPT_PATH`
- `CAF_CODEX_SUCCESSOR_RUN_ID`
- `CAF_CODEX_PREDECESSOR_SESSION`
- `CAF_CODEX_EFFORT_REQUESTS_DIR`
- `CAF_CODEX_WAKE_REQUESTS_DIR`
- `CAF_CODEX_EFFORT_RECEIPTS_DIR`
- `CAF_CODEX_WAKE_RECEIPTS_DIR`

Exit criteria:

- Receipt fixtures match Cafex schema expectations.
- Effort/wake and restart metadata behavior is deterministic.
- Minimal goal DTO/state/tool flow passes selected Cafetera contract fixtures.
- Every supported and unsupported Cafex delta has a seam ledger row.

### M6: Replacement Review

Primary beads:

- `HXCX-6.1` Cafex patch-stack/rebase comparison
- `HXCX-6.2` migration modes and adapter rollout
- `HXCX-6.3` go/no-go review
- `HXCX-6.4` rollback/distribution/operator notes

Decision modes:

- Mode A: helper/conformance only
- Mode B: sidecar/headless runtime for selected tests/workflows
- Mode C: selected Cafex slice replacement behind adapter
- Mode D: broader Cafex replacement candidate

Exit criteria:

- Security, licensing, generated Rust quality, operations, and maintenance burden have evidence.
- Rollback path exists.
- Decision record chooses a mode.

### M7: haxe.rust Production Capability Report

Primary beads:

- `HXCX-7.1` gap collection
- `HXCX-7.2` upstreamable fixtures/issues
- `HXCX-7.3` production-readiness report
- `HXCX-7.4` post-experiment decision record

Deliverables:

- Compiler/runtime/interop gap report with reproductions.
- Quantified raw Rust escape pressure.
- Upstreamable minimal fixtures for haxe.rust where possible.
- Final scorecard for helper-only, sidecar/headless, slice replacement, or broader candidate.

## Immediate Next Work

Start with:

1. Claim `HXCX-0.1` and write the baseline topology note.
2. Claim `HXCX-0.2` and classify Cafex deltas into support slices.
3. Claim `HXCX-0.3` and inventory available fixtures.
4. Claim `HXCX-0.6` and decide path pin vs vendor/submodule/subtree mechanics for `../haxe.rust`.

Do not scaffold the runtime until `HXCX-0.4` and `HXCX-0.5` have made the slice and repository ownership explicit.
