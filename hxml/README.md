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
| `provider-admission.hxml` | Compile the HXCX-4.43 raw provider admission boundary harness through portable haxe.rust. |
| `model-catalog.hxml` | Compile the HXCX-4.44 raw model catalog and provider capabilities harness through portable haxe.rust. |
| `turn-model-plan.hxml` | Compile the HXCX-4.45 raw turn model selection and tool-capability planning harness through portable haxe.rust. |
| `model-request-envelope.hxml` | Compile the HXCX-4.46 raw model request envelope and response routing harness through portable haxe.rust. |
| `model-stream-route.hxml` | Compile the HXCX-4.47 raw model stream event and error routing harness through portable haxe.rust. |
| `model-stream-item-reducer.hxml` | Compile the HXCX-4.48/HXCX-4.50/HXCX-4.51/HXCX-4.52 raw stream item reducer, assistant output routing, tool-call input delta, and streamed argument diff event harness through portable haxe.rust. |
| `async-runtime-contract.hxml` | Compile the HXCX-4.49 runtime-neutral async task/stream/cancel/backpressure contract harness through portable haxe.rust. |
| `app-protocol.hxml` | Compile the G2.4 app-server protocol subset harness through portable haxe.rust. |
| `mock-model-stream.hxml` | Compile the HXCX-3.1/HXCX-3.6 mock model stream parser, fixture provider, one-turn state machine, cancellation, and transcript/state store harness through portable haxe.rust. |
| `headless-jsonl-adapter.hxml` | Compile the HXCX-3.4 command JSONL app-server/debug adapter harness through portable haxe.rust. |
| `runtime-app-client.hxml` | Compile the HXCX-4.7 runtime event bus and in-memory app-server client facade harness through portable haxe.rust. |
| `runtime-bootstrap.hxml` | Compile the HXCX-4.11 initialize/bootstrap runtime harness through portable haxe.rust. |
| `runtime-transport.hxml` | Compile the HXCX-4.12 fixture live-transport harness through portable haxe.rust. |
| `persistence-boundary.hxml` | Compile the HXCX-4.13 persistent app-server/TUI state boundary harness through portable haxe.rust. |
| `native-sqlite-persistence.hxml` | Compile the HXCX-4.14 native SQLite persistence pressure harness through metal haxe.rust. |
| `native-state-adapter.hxml` | Compile the HXCX-4.15 native SQLite state adapter reconcile/query pressure harness through metal haxe.rust. |
| `persisted-thread-read-view.hxml` | Compile the HXCX-4.16 persisted thread read-view harness through metal haxe.rust after native adapter setup. |
| `thread-read-turn-projection.hxml` | Compile the HXCX-4.17 raw thread/read turn projection harness through portable haxe.rust. |
| `thread-read-turns-page.hxml` | Compile the HXCX-4.18 raw thread/read turns page harness through portable haxe.rust. |
| `thread-read-active-turn-merge.hxml` | Compile the HXCX-4.19 raw active-turn merge/status normalization harness through portable haxe.rust. |
| `thread-read-turn-items-list.hxml` | Compile the HXCX-4.20 raw thread/turns/items unsupported-runtime harness through portable haxe.rust. |
| `thread-read-token-usage-owner.hxml` | Compile the HXCX-4.21 raw token-usage replay owner attribution harness through portable haxe.rust. |
| `thread-read-token-usage-replay.hxml` | Compile the HXCX-4.22 raw restored token-usage notification payload harness through portable haxe.rust. |
| `thread-read-token-usage-replay-delivery.hxml` | Compile the HXCX-4.23 raw restored token-usage delivery-policy harness through portable haxe.rust. |
| `thread-read-resume-goal-snapshot.hxml` | Compile the HXCX-4.24 raw resume-goal snapshot ordering harness through portable haxe.rust. |
| `thread-read-resume-idle-continuation.hxml` | Compile the HXCX-4.25 raw resume idle lifecycle continuation harness through portable haxe.rust. |
| `thread-read-goal-steering.hxml` | Compile the HXCX-4.26 raw goal steering item harness through portable haxe.rust. |
| `thread-read-try-start-turn-if-idle.hxml` | Compile the HXCX-4.27 raw try_start_turn_if_idle admission harness through portable haxe.rust. |
| `thread-read-goal-runtime-restore.hxml` | Compile the HXCX-4.28 raw goal runtime restore-after-resume harness through portable haxe.rust. |
| `thread-read-active-turn-goal-steering-injection.hxml` | Compile the HXCX-4.29 raw active-turn goal steering injection harness through portable haxe.rust. |
| `thread-read-budget-limit-goal-steering.hxml` | Compile the HXCX-4.30 raw budget-limit goal steering harness through portable haxe.rust. |
| `thread-read-active-goal-progress-accounting.hxml` | Compile the HXCX-4.31 raw active-goal progress accounting harness through portable haxe.rust. |
| `thread-read-idle-goal-progress-accounting.hxml` | Compile the HXCX-4.32 raw idle-goal progress accounting harness through portable haxe.rust. |
| `thread-read-turn-start-goal-accounting.hxml` | Compile the HXCX-4.33 raw turn-start goal accounting harness through portable haxe.rust. |
| `thread-read-turn-goal-finalization.hxml` | Compile the HXCX-4.34 raw turn-stop/abort goal finalization harness through portable haxe.rust. |
| `thread-read-turn-error-active-goal-stop.hxml` | Compile the HXCX-4.35 raw turn-error active-goal stop harness through portable haxe.rust. |
| `thread-read-goal-token-usage-record.hxml` | Compile the HXCX-4.36 raw goal token-usage contribution harness through portable haxe.rust. |
| `thread-read-tool-finish-goal-progress-admission.hxml` | Compile the HXCX-4.37 raw tool-finish goal-progress admission harness through portable haxe.rust. |
| `thread-read-goal-tool-contributor-visibility.hxml` | Compile the HXCX-4.38 raw goal tool contributor visibility harness through portable haxe.rust. |
| `thread-read-get-goal-tool.hxml` | Compile the HXCX-4.39 raw `get_goal` tool executor harness through portable haxe.rust. |
| `thread-read-create-goal-tool.hxml` | Compile the HXCX-4.40 raw `create_goal` tool executor harness through portable haxe.rust. |
| `thread-read-update-goal-tool.hxml` | Compile the HXCX-4.41 raw `update_goal` tool executor harness through portable haxe.rust. |
| `thread-read-goal-tool-dispatch.hxml` | Compile the HXCX-4.42 raw goal tool executor dispatch harness through portable haxe.rust. |
| `tui-smoke.hxml` | Compile the HXCX-TUI-0/HXCX-TUI-1/HXCX-TUI-2/HXCX-TUI-3/HXCX-TUI-4/HXCX-TUI-5/HXCX-TUI-6/HXCX-TUI-7/HXCX-TUI-8/HXCX-TUI-9/HXCX-TUI-10/HXCX-TUI-11/HXCX-TUI-12/HXCX-TUI-13/HXCX-TUI-14/HXCX-TUI-15/HXCX-TUI-16/HXCX-TUI-17 generated TUI smoke binary, headless app-loop shell, app-event queue facade, app-server event facade, server-request facade, request-resolution facade, active-thread request delivery facade, active-thread notification delivery facade, pending interactive replay-filter facade, thread snapshot turn-history replay facade, thread snapshot session/input replay facade, replayed server-request surface facade, replayed notification/history/feedback event surface facade, replay-buffer flush/reflow facade, resize draw scheduling facade, resize repaint/scrollback facade, inline viewport resize sync facade, and suspend/resume viewport facade through metal haxe.rust. |
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
