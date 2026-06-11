# Cafex Adapter

Cafex/Cafetera compatibility lives here after the upstream-shaped Haxe core exists.

This package should adapt to core Codex types rather than making fork-only behavior the default core model.

## Receipts

`CafReceiptWriter` implements the HXCX-5.1 Caf session/turn receipt slice from `../fullofcaffeine/deps/codex/codex-rs/core/src/caf_runtime.rs`.

Env-owned inputs are represented by `CafReceiptEnv`:

- `CAF_CODEX_SESSION_RECEIPT_PATH`
- `CAF_CODEX_TURN_RECEIPT_PATH`
- `CAF_CODEX_SUCCESSOR_RUN_ID`
- `CAF_CODEX_PREDECESSOR_SESSION`

Receipt writes are no-ops unless the relevant receipt path and successor run id are present. Session receipts use schema `caf-client-session.v1` and state `session_ready`; turn receipts use schema `caf-client-turn.v1` and state `turn_started`.

Continuity mapping follows Cafex/native Codex:

- `resume` -> `resume_same_conversation`, `continuityLoaded: true`
- `startup`, `clear`, `compact` -> `fresh_unlinked`, `continuityLoaded: false`

Duplicate writes overwrite the target path, matching the current `caf_runtime.rs` `fs::write` behavior. The Haxe writer keeps `writtenAt` caller-supplied so fixture tests stay deterministic; a live runtime adapter should pass the observed UTC timestamp.

Known haxe.rust gaps discovered during this slice and worked around locally:

- `haxe.rust-lj8`: `haxe.io.Path.directory` lowering.
- `haxe.rust-7s4`: `String.lastIndexOf` lowering.

## Continuity Metadata

`CafContinuityEnv` implements the HXCX-5.4 successor/predecessor metadata parser.

Inputs mirror the Cafex/native env names:

- `CAF_CODEX_SESSION_RECEIPT_PATH`
- `CAF_CODEX_TURN_RECEIPT_PATH`
- `CAF_CODEX_SUCCESSOR_RUN_ID`
- `CAF_CODEX_PREDECESSOR_SESSION`

The parser trims values, requires an explicit successor run id, rejects path-like/control-character metadata, and derives continuity only from explicit predecessor metadata:

- predecessor present -> `resume_same_conversation`, `continuityLoaded: true`, receipt source `resume`
- predecessor absent -> `fresh_unlinked`, `continuityLoaded: false`, receipt source `startup`

This keeps restart proof honest: receipt metadata is not inferred from process liveness, file paths, or side effects.

## Effort And Wake Bridge

`CafBridgeProcessor` implements the HXCX-5.2/HXCX-8.1 directory bridge subset from Cafex native Codex request and receipt lanes.

The bridge is adapter-local. It consumes Cafex request files from a request directory and writes deterministic receipt files to a receipt directory; it does not add Cafex-specific behavior to upstream-shaped core Codex modules.

Supported request schemas:

- `cafetera.codex.effort-apply-request.v1` writes `cafetera.codex.effort-apply.v1`.
- `caf-client-wake-request.v1` writes `caf-client-wake-receipt.v1` with `status: consumed`.
- `cafetera.codex.mode-apply-request.v1` writes `cafetera.codex.mode-apply.v1` with `status: refused` and `refusalReason: unsupported_mode_apply`.
- `cafetera.codex.goal-apply-request.v1` writes `cafetera.codex.goal-apply.v1`, validates Brew completion authority, applies accepted objective requests through `ThreadGoalStore`, records clear-boundary receipts, and refuses invalid requests with a typed reason.

Effort requests currently accept `medium`, `high`, and the `xhigh` alias family used by Cafex native Codex. Missing model/effort and invalid effort values write refused receipts. Unknown schemas are skipped, and existing receipt paths are skipped so repeated scans are idempotent.

`processOnceFromEnv` follows the native env fallback shape:

- Requests: `CAF_CODEX_EFFORT_REQUESTS_DIR`, then `CAF_CODEX_WAKE_REQUESTS_DIR`, then `CAF_CODEX_GOAL_REQUESTS_DIR`.
- Receipts: `CAF_CODEX_EFFORT_RECEIPTS_DIR`, then `CAF_CODEX_WAKE_RECEIPTS_DIR`, then `CAF_CODEX_GOAL_RECEIPTS_DIR`.

The live native TUI applies effort/goal changes by sending app events and persisting native runtime state. This Haxe slice records the receipt and in-memory goal-store contract only; wiring live app-server/TUI persistence into the eventual runtime adapter remains a later Cafex milestone.

## Contract Subset Report

`CafeteraContractSubsetReport` implements the HXCX-5.5 selected Cafetera Codex module contract report.

The report covers only the fixture-backed receipts, bridge, goal, and continuity harnesses that currently compile and run through hxrust. Unsupported live-production surfaces are classified separately:

- `unsupported_full_cafetera_cli`
- `unsupported_live_tui_runtime`
- `unsupported_native_restart_cutover`
- `unsupported_mode_apply_runtime`
- `unsupported_live_model_runtime`

The report always keeps `productionReplacement: false`, `replacementClaim: none`, and scope `fixture-backed hxrust subset only`.
