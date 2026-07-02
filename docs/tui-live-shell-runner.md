# TUI Live Shell Runner

**Beads:** `TUI-LIVE-11` / `codex-hxrust-dww3`, `TUI-LIVE-48` / `codex-hxrust-5qfz`, `TUI-LIVE-61` / `codex-hxrust-9oi7`, `TUI-LIVE-62` / `codex-hxrust-dgl3`, `TUI-LIVE-63` / `codex-hxrust-s0fu`, `TUI-LIVE-64` / `codex-hxrust-q156`, `TUI-LIVE-65` / `codex-hxrust-o8lu`, `TUI-LIVE-81` / `codex-hxrust-xfyp`, `TUI-LIVE-82` / `codex-hxrust-u6ta`, `TUI-LIVE-83` / `codex-hxrust-73vh`, `TUI-LIVE-84` / `codex-hxrust-7mrb`, `TUI-LIVE-85` / `codex-hxrust-rce5`, `TUI-LIVE-86` / `codex-hxrust-f44b`, `TUI-LIVE-87` / `codex-hxrust-uuhi`, `TUI-LIVE-88` / `codex-hxrust-swjy`, `TUI-LIVE-89` / `codex-hxrust-wb6o`, `TUI-LIVE-90` / `codex-hxrust-ofn3`, `TUI-LIVE-91` / `codex-hxrust-28tx`

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

`TUI-LIVE-81` through `TUI-LIVE-91` move deterministic app-server scheduler triggers
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
transcript.

For the user-runnable generated binary, see
[tui-live-shell-demo.md](tui-live-shell-demo.md).
