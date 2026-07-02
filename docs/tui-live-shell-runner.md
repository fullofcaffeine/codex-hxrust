# TUI Live Shell Runner

**Beads:** `TUI-LIVE-11` / `codex-hxrust-dww3`, `TUI-LIVE-48` / `codex-hxrust-5qfz`, `TUI-LIVE-61` / `codex-hxrust-9oi7`, `TUI-LIVE-62` / `codex-hxrust-dgl3`, `TUI-LIVE-63` / `codex-hxrust-s0fu`, `TUI-LIVE-64` / `codex-hxrust-q156`, `TUI-LIVE-65` / `codex-hxrust-o8lu`, `TUI-LIVE-81` / `codex-hxrust-xfyp`, `TUI-LIVE-82` / `codex-hxrust-u6ta`, `TUI-LIVE-83` / `codex-hxrust-73vh`, `TUI-LIVE-84` / `codex-hxrust-7mrb`, `TUI-LIVE-85` / `codex-hxrust-rce5`, `TUI-LIVE-86` / `codex-hxrust-f44b`, `TUI-LIVE-87` / `codex-hxrust-uuhi`, `TUI-LIVE-88` / `codex-hxrust-swjy`, `TUI-LIVE-89` / `codex-hxrust-wb6o`, `TUI-LIVE-90` / `codex-hxrust-ofn3`, `TUI-LIVE-91` / `codex-hxrust-28tx`, `TUI-LIVE-92` / `codex-hxrust-t7qt`, `TUI-LIVE-93` / `codex-hxrust-mohy`, `TUI-LIVE-94` / `codex-hxrust-7u0m`, `TUI-LIVE-95` / `codex-hxrust-0o47`

This slice adds the first runnable minimal TUI shell loop. It composes the
production terminal backend, redraw scheduler, ChatWidget shell state, fake
app-server facade, app-server event pump, and typed terminal input mapper into
one bounded runner.

The runner is still credential-free. It does not open a JSON-RPC socket, call a
model, use SQLite/log state, or render the full upstream ratatui widget tree.
It proves the generated Haxe/Rust path can set up a terminal backend, attach a
fake session, draw the first frame, poll typed terminal events, submit prompt
text through the fake app-server path, route semantic agent previous/next input,
handle resize/draw/tick events, request exit for Esc/Ctrl-C/empty-composer `q`,
and restore the terminal.

Validation:

```bash
bash harness/check-tui-live-shell-runner.sh
```

The harness runs through the Haxe interpreter and haxe.rust-generated metal
Cargo check/test/run. Headless events provide deterministic CI coverage while
`LiveTerminalBackend` keeps the same no-TTY-safe generated Rust boundary used by
the earlier live-terminal restore gate.

`TUI-LIVE-48` lets `TuiLiveShellRunRequest` select a concrete JSON-RPC prompt
transport without manually constructing a facade. The default request still uses
the credential-free fake transport, while `withJsonRpcPromptTransport` and
`withLineConnectedPromptTransport` route live-shell prompt submission through
the connector-backed JSONL line pipeline. The runner harness proves both the
direct builder path and a diagnostic path that keeps the
`DryRunTuiAppServerJsonRpcLineConnectedTransport` handle available for typed
attempt/close reports.

`TUI-LIVE-61` makes prompt-transport shutdown part of the runner contract.
`TuiPromptTransport.shutdown()` and the JSON-RPC transport shutdown hook return
a typed `TuiPromptTransportShutdownReport`, and `TuiLiveShellRunner` records it
before terminal restore on normal, setup-failure, and error exits. Persistent
stdio shutdown delegates to the underlying line close report so runner/demo
outcomes can prove aggregate outbound/inbound JSONL counts.

`TUI-LIVE-62` tracks active turn identity through the prompt path. The fake
app-server facade records the accepted `turn/start` response, exposes active,
last-started, and last-completed turn IDs, and clears the active turn when the
projected completion/ready event drains. The runner outcome records those facts
so the generated demo can report completed turn evidence before the later
`turn/interrupt` request path exists.

`TUI-LIVE-63` adds the first typed interrupt route. During key handling,
`TuiLiveShellRunner` sends Ctrl-C to `FakeTuiAppServerFacade.interruptActiveTurn`
when an active turn exists; idle Ctrl-C still follows the previous shell-exit
path. `TuiLiveShellRunOutcome` now records last-interrupted turn ID,
interrupted-turn count, and the last interrupt code alongside active/completed
turn evidence. This is app-server request/effect plumbing, not real async
process cancellation yet.

`TUI-LIVE-64` keeps the runner-facing interrupt contract unchanged while routing
the persistent stdio JSONL transport through the same typed interrupt outcome.
Harnesses prove accepted persistent interrupts can clear active-turn state, and
malformed/error interrupt responses fail closed before reaching runner state.

`TUI-LIVE-65` adds an opt-in submitted-turn prompt path for persistent stdio.
The runner harness now proves a `turn/start` response with scoped
`turn/started` evidence can leave `activeTurn` populated, the following Ctrl-C
uses the persistent `turn/interrupt` envelope, and the accepted interrupt clears
the turn without exiting the shell or incrementing completed-turn count.

`TUI-LIVE-81` through `TUI-LIVE-95` move deterministic app-server scheduler triggers
into the runner. `TuiLiveShellRunRequest` can carry queued
`TuiAppServerPumpEvent` and `TuiAppServerReadinessEvent` values; the runner
routes them through `TuiAppServerEventPump.handlePumpEvent()` and
`handleReadinessEvent()` while `TuiLiveShellRunOutcome` records structured
pump, backpressure, readiness, and late-JSONL drain evidence. This proves
runner-owned pump/readiness routing for submitted-turn JSONL, including a
bounded readiness-triggered backpressure pass followed by explicit
`DrainQueuedEvents` recovery and a no-data readiness retry that preserves the
active submitted turn until the later drain completes, plus duplicate
post-completion readiness coalescing through `NoPendingSubmittedTurn` and a
max-batch readiness stop that applies the assistant prefix while keeping the
submitted turn active and the completion line unread, plus prefix-applied
wrong-turn rejection that preserves the assistant row and keeps completion
counts unchanged, plus line-read rejection evidence that preserves the active
turn and leaves unread assistant/completion lines out of the transcript,
plus unsupported-notification rejection that reads a late JSONL line but keeps
submitted-turn transcript and completion state unchanged, without real async
socket readiness, provider streaming, model calls, tools, or persistence.
`TUI-LIVE-90` also lets readiness classify late JSONL for the last interrupted
turn, so stale interrupted assistant deltas can be rejected after Ctrl-C while
preserving the interrupted-turn state. `TUI-LIVE-91` extends that same
interrupted-turn classification to stale `turn/completed` notifications, so a
late completion after Ctrl-C records `BatchRejected` /
`stale_interrupted_turn_completion` without mutating completion state or the
transcript. `TUI-LIVE-92` proves unknown-method decode rejection through the
same readiness route: a no-data readiness event keeps the submitted turn active,
and the later late-JSONL read records `BatchRejected` / `unknown_inbound_method`
without mutating completion state or the transcript. `TUI-LIVE-93` extends that
decode-boundary evidence to malformed JSONL, recording `BatchRejected` /
`invalid_json_line` while preserving the active submitted turn and transcript.
`TUI-LIVE-94` proves syntactically valid but schema-invalid JSONL follows the
same route, recording `BatchRejected` / `missing_field` while preserving the
active submitted turn and transcript. `TUI-LIVE-95` proves the same rejection
can happen after a valid assistant prefix has already been applied, preserving
that assistant row while keeping the submitted turn active and completion count
unchanged. `TUI-LIVE-96` proves the prefix-preservation path also handles a
later decode-invalid notification, recording `BatchRejected` /
`unknown_inbound_method` while keeping the active turn and assistant prefix.
`TUI-LIVE-97` proves the same prefix-preservation path for malformed JSONL,
recording `BatchRejected` / `invalid_json_line` while preserving the active
turn and assistant prefix. `TUI-LIVE-98` proves the same prefix-preservation
path for unsupported stream notifications, recording `BatchRejected` /
`unsupported_stream_notification` while preserving the active turn and assistant
prefix. `TUI-LIVE-99` proves the same prefix-preservation path when a later
late-JSONL read fails, recording `LineReadRejected` /
`runner_late_jsonl_read_failed` while preserving the active turn and assistant
prefix. `TUI-LIVE-100` proves a prefix can be applied before Ctrl-C interrupts
the submitted turn, then a later readiness drain rejects a stale assistant delta
with `BatchRejected` / `stale_interrupted_turn_delivery` while preserving the
applied prefix and interrupted-turn state. `TUI-LIVE-101` proves the
completion-side companion path, rejecting stale `turn/completed` with
`BatchRejected` / `stale_interrupted_turn_completion` while preserving the
applied prefix and interrupted-turn state. `TUI-LIVE-102` exposes structured
applied-prefix evidence from readiness drains through the runner outcome,
including applied notification count, assistant delta count, completion count,
latest thread/turn IDs, and applied delta text. `TUI-LIVE-103` proves the same
structured prefix evidence survives prefix-then-line-read readiness rejection
with `LineReadRejected` / `runner_late_jsonl_read_failed`. `TUI-LIVE-104`
proves the unsupported-notification companion path, preserving the structured
prefix evidence when a later stream notification rejects with `BatchRejected` /
`unsupported_stream_notification`. `TUI-LIVE-105` extends that structured
prefix evidence to prefix-then-malformed-JSON readiness rejection with
`BatchRejected` / `invalid_json_line`. `TUI-LIVE-106` extends that structured
prefix evidence to prefix-then-decode-rejected readiness rejection with
`BatchRejected` / `unknown_inbound_method`. `TUI-LIVE-107` extends that
structured prefix evidence to prefix-then-schema-rejected readiness rejection
with `BatchRejected` / `missing_field`. `TUI-LIVE-108` adds
`TuiLiveShellReadinessSource` so the runner can poll a typed readiness source
for submitted-turn readiness events while preserving the existing explicit
queued readiness path. `TUI-LIVE-109` proves the source-fed readiness path also
records bounded readiness backpressure and recovers through the existing
`DrainQueuedEvents` pump-event route. `TUI-LIVE-110` proves repeated source-fed
readiness events preserve the active submitted turn after no-data, then complete
on the later source event. `TUI-LIVE-111` proves a later source-fed duplicate
readiness event records `NoPendingSubmittedTurn` without reading extra late
JSONL or mutating transcript/completion state. `TUI-LIVE-112` proves
source-fed readiness can stop at the configured max-batch limit, retain the
active submitted turn, leave completion unread, and preserve structured
assistant-prefix evidence. `TUI-LIVE-113` proves source-fed readiness can apply
an assistant prefix, reject a later wrong-turn completion, retain the active
submitted turn, and preserve the same structured prefix evidence.
`TUI-LIVE-114` proves source-fed readiness can surface line-read rejection
evidence without applying late JSONL or mutating completion state.
`TUI-LIVE-115` proves source-fed readiness can surface unsupported-notification
rejection evidence while retaining the active submitted turn.
`TUI-LIVE-116` proves source-fed readiness can surface unknown-method decode
rejection evidence after a no-data readiness pass.

For the user-runnable generated binary, see
[tui-live-shell-demo.md](tui-live-shell-demo.md).
