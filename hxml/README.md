# HXML Profiles

Profile policy for the scaffold:

| File | Purpose |
| --- | --- |
| `portable.codegen.hxml` | Generate portable Rust only with `-D rust_no_build`. |
| `portable.hxml` | Generate portable Rust and run `cargo check`. |
| `metal.codegen.hxml` | Generate metal Rust only with `-D rust_no_build`. |
| `metal.hxml` | Generate metal Rust and run `cargo check`. |
| `diagnostics.hxml` | Compile the HXCX-4.6 diagnostics redaction and failure-report harness through portable haxe.rust. |
| `protocol-ids.hxml` | Compile the G2.1 protocol ID harness through portable haxe.rust. |
| `json-boundary.hxml` | Compile the G2.2 JSON boundary harness through portable haxe.rust. |
| `config-profile.hxml` | Compile the G2.3 config/profile DTO harness through portable haxe.rust. |
| `app-protocol.hxml` | Compile the G2.4 app-server protocol subset harness through portable haxe.rust. |
| `mock-model-stream.hxml` | Compile the HXCX-3.1/HXCX-3.6 mock model stream parser, fixture provider, one-turn state machine, cancellation, and transcript/state store harness through portable haxe.rust. |
| `headless-jsonl-adapter.hxml` | Compile the HXCX-3.4 command JSONL app-server/debug adapter harness through portable haxe.rust. |
| `runtime-app-client.hxml` | Compile the HXCX-4.7 runtime event bus and in-memory app-server client facade harness through portable haxe.rust. |
| `runtime-bootstrap.hxml` | Compile the HXCX-4.11 initialize/bootstrap runtime harness through portable haxe.rust. |
| `runtime-transport.hxml` | Compile the HXCX-4.12 fixture live-transport harness through portable haxe.rust. |
| `tui-story-replay.hxml` | Compile the HXCX-4.8 upstream TUI story replay parser and summary harness through portable haxe.rust. |
| `tui-render.hxml` | Compile the HXCX-4.9 VT100/history/render invariant harness through portable haxe.rust. |
| `turn-runtime-reducer.hxml` | Compile the HXCX-4.10 upstream turn-runtime reducer harness through portable haxe.rust. |
| `apply-patch-dry-run.hxml` | Compile the HXCX-4.1 apply-patch dry-run wrapper harness through portable haxe.rust. |
| `process-exec.hxml` | Compile the HXCX-4.2 exact-approval process exec wrapper harness through portable haxe.rust. |
| `sandbox-gate.hxml` | Compile the HXCX-4.3 fail-closed sandbox permission gate harness through portable haxe.rust. |
| `caf-receipts.hxml` | Compile the HXCX-5.1 Caf session/turn receipt adapter harness through portable haxe.rust. |
| `caf-bridge.hxml` | Compile the HXCX-5.2/HXCX-8.1 Caf effort/wake/goal bridge harness through portable haxe.rust. |
| `caf-active-lane.hxml` | Compile the HXCX-8.2 Caf active-lane capability writer harness through portable haxe.rust. |
| `caf-continuity.hxml` | Compile the HXCX-5.4 Caf successor/predecessor continuity metadata harness through portable haxe.rust. |
| `goals.hxml` | Compile the HXCX-5.3 goal DTO/state/tool harness through portable haxe.rust. |

`rust_output` paths are deterministic:

- `generated/portable`
- `generated/metal`

The profile hxmls intentionally use haxe.rust's `cargo check` first so the generated crates can establish their initial lockfiles and dependency shape.

Locked validation is owned by `../scripts/check-generated-cargo.sh`, which runs:

- `cargo check --locked`
- `cargo test --locked`

for both generated crates.
