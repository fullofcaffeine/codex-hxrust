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
