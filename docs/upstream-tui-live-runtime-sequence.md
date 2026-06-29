# Upstream TUI And Live Runtime Sequence

**Bead:** `HXCX-4.1` / `codex-hxrust-6cs`
**Date:** 2026-06-12
**Scope:** mainstream upstream Codex first; Cafex/Cafetera adapters remain dependency-gated.

## Purpose

The app-server protocol subset is now broad enough to stop treating codexhx as a headless-only experiment. The full target is still whole Codex: app-server, runtime, tools, state, and the interactive TUI. This document sequences the next upstream/raw Codex work so the first live-runtime slices are deterministic, testable, and useful haxe.rust pressure tests without pulling Cafex fork behavior into the core.

## Upstream Inspection

Read-only upstream reference: `../codex`.

TUI shape inspected:

- `../codex/codex-rs/tui/src/lib.rs`
- `../codex/codex-rs/tui/src/main.rs`
- `../codex/codex-rs/tui/src/app.rs`
- `../codex/codex-rs/tui/src/app_event.rs`
- `../codex/codex-rs/tui/src/app_server_session.rs`
- `../codex/codex-rs/tui/src/chatwidget.rs`
- `../codex/codex-rs/tui/src/chatwidget/turn_runtime.rs`
- `../codex/codex-rs/tui/tests/all.rs`
- `../codex/codex-rs/tui/tests/test_backend.rs`
- `../codex/codex-rs/tui/tests/suite/vt100_history.rs`
- `../codex/codex-rs/tui/tests/suite/vt100_live_commit.rs`
- `../codex/codex-rs/tui/tests/suite/status_indicator.rs`
- `../codex/codex-rs/tui/tests/fixtures/oss-story.jsonl`

Runtime/app-server shape inspected:

- `../codex/codex-rs/app-server-client/src/lib.rs`
- `../codex/codex-rs/app-server/src/lib.rs`
- `../codex/codex-rs/app-server-transport/src/lib.rs`
- `../codex/codex-rs/app-server-transport/src/transport/*`
- `../codex/codex-rs/core/src/session/*`
- `../codex/codex-rs/core/tests/common/test_codex.rs`

Scale markers from the current upstream checkout:

- TUI source under `tui/src`: 387 files, about 173k lines.
- TUI tests under `tui/tests`: about 9k lines.
- The TUI is not one feature. It is a terminal app, app-server client, event-loop, input queue, renderer, history/transcript system, realtime surface, and stateful session router.

## Architectural Reading

Upstream TUI runtime is organized around these seams:

| Seam | Upstream anchor | codexhx implication |
| --- | --- | --- |
| TUI event bus | `AppEvent`, `AppEventSender`, `App::run` | Start with a typed Haxe event bus and deterministic dispatcher before full terminal ownership. |
| App-server facade | `AppServerSession`, `AppServerClient` | Build a Haxe facade over the already-admitted protocol methods; keep in-process and remote transport concerns separated. |
| Lossless event tiers | `server_notification_requires_delivery` in `app-server-client` | Transcript deltas and completion notifications need backpressure semantics. Best-effort events may be dropped with lag evidence. |
| Chat turn state | `ChatWidget`, `turn_runtime.rs`, `input_queue.rs` | Model turn lifecycle as pure state reducers first, then connect to live transport. |
| Rendering | `ratatui`, `crossterm`, `VT100Backend`, `insert_history_lines`, `RowBuilder` | Use VT100/string fixtures before interactive terminal mode. |
| Story/replay oracle | `tui/tests/fixtures/oss-story.jsonl` | Adapt story events into codexhx-owned fixtures and normalized outputs; do not depend on private Rust test internals. |
| Persistence | `codex_rollout`, `codex_state`, SQLite/log DB handles | JSONL remains fixture evidence only. Persistent app-server/TUI state parity requires a native SQLite/sqlx or equivalent boundary before replacement claims. |
| Credentialed model/runtime | `codex_model_provider`, realtime, websocket/WebRTC/audio | Keep credential-free mock/runtime tests first; credentialed and audio/network behavior are later metal/native-boundary slices. |

## Sequence

### HXCX-4.7: Runtime Event Bus And App-Server Client Facade

Implement the first Haxe-owned live-runtime shell:

- typed `CodexRuntimeEvent`/`CodexRuntimeCommand` envelopes;
- bounded queue semantics with lossless vs best-effort notification classification;
- deterministic lag markers for dropped best-effort events;
- request/response correlation and typed error categories;
- fixture-backed in-memory app-server client facade.

This slice should be portable for DTOs/state and metal only where async/channel runtime behavior requires Rust-native ownership.

### HXCX-4.8: TUI Story Replay Harness

Adapt upstream `oss-story.jsonl` into codexhx-owned replay fixtures:

- normalize timestamps, cwd, model names, process ids, and terminal-only noise;
- parse key events, app events, inserted history, and protocol events into typed Haxe records;
- run through Haxe interpreter and haxe.rust-generated Rust;
- compare event/state summaries, not upstream private Rust structs.

This gives us a public oracle for "TUI-like behavior" without yet owning an interactive terminal.

Status: HXCX-4.8 now owns the selected fixture `fixtures/upstream/oss-story-selected.v1.jsonl` and validates its normalized replay summary through `harness/check-tui-story-replay.sh`.

### HXCX-4.9: VT100 History And Render Commit Parity

Port the first terminal rendering invariant:

- `RowBuilder`-style live row accumulation;
- commit-ready history draining;
- word wrapping and Unicode width handling;
- ANSI sanitization contract for status/history text;
- deterministic VT100/string backend output.

Use upstream `vt100_history`, `vt100_live_commit`, and `status_indicator` as behavior oracles. Generated Rust must run the same fixture harness.

Status: HXCX-4.9 now owns the selected fixture `fixtures/upstream/vt100-render-selected.v1.json` and validates it through `harness/check-tui-render.sh`. This is string-backend parity, not full ratatui/crossterm ownership.

### HXCX-TUI-0: Minimal hxrust TUI Smoke Binary

Add the first generated executable boundary for the TUI track:

- typed Haxe entrypoint compiled through haxe.rust to a Cargo binary;
- neutral terminal facade with setup/render/poll/restore methods;
- headless fixture frame containing transcript, status, model, and input rows;
- deterministic cancel/quit key handling;
- generated binary stdout snapshot suitable for CI.

Status: HXCX-TUI-0 now owns `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. The binary uses metal haxe.rust because this is the path that will eventually host Rust-native terminal ownership. This remains a headless smoke proof, not full ratatui/crossterm ownership, live keyboard input, live app-server fanout, model traffic, or Cafex behavior. It reuses the existing generic haxe.rust issue `haxe.rust-3f0g` workaround by avoiding same-class `static final` string reads in the entrypoint.

### HXCX-TUI-1: Headless Raw Codex TUI Event-Loop Smoke Shell

Extend the generated smoke binary from a single frame into a minimal app-loop shell:

- typed event subset inspired by upstream `TuiEvent::{Draw, Resize, Key}` and selected app events;
- status/input updates as app-loop state transitions;
- explicit `AppEvent::Exit(ExitMode)`-style shutdown modes;
- deterministic render counts and event traces;
- cancel/quit handling without live terminal, network, model, or tool effects.

Status: HXCX-TUI-1 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/main.rs:38`, `../codex/codex-rs/tui/src/app.rs:754`, `../codex/codex-rs/tui/src/app.rs:1180`, `../codex/codex-rs/tui/src/tui.rs:499`, `../codex/codex-rs/tui/src/app_event.rs:239`, `../codex/codex-rs/tui/src/app_event.rs:642`, and `../codex/codex-rs/tui/src/app_event.rs:1057`. The loop request uses a nullable class-typed frame field to avoid the existing generic haxe.rust class-field default-constructor lowering issue already tracked in this repo; no Codex-specific compiler workaround was added.

### HXCX-TUI-2: Typed Raw Codex TUI App-Event Queue Facade

Add the first queued app-event facade to the generated smoke binary:

- typed `AppEventSender`-style queue with explicit enqueue logging;
- startup status, commit tick, and queued app exit events;
- deterministic app-event drain before terminal render/input steps;
- terminal key exit precedence over later queued app events;
- generated binary snapshot still runs headlessly without app-server, model, network, tool, or terminal takeover effects.

Status: HXCX-TUI-2 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/app_event_sender.rs:22`, `../codex/codex-rs/tui/src/app_event_sender.rs:28`, `../codex/codex-rs/tui/src/app_event_sender.rs:34`, `../codex/codex-rs/tui/src/app.rs:779`, `../codex/codex-rs/tui/src/app.rs:1181`, `../codex/codex-rs/tui/src/tui/event_stream.rs:132`, `../codex/codex-rs/tui/src/tui/event_stream.rs:236`, and the HXCX-TUI-1 `AppEvent` anchors. This is queue-ordering evidence only, not Tokio channel ownership, live app-server event handling, background task cleanup, or Cafex behavior.

### HXCX-TUI-3: Headless Raw Codex TUI App-Server Event Facade

Add a typed app-server event facade to the generated smoke binary:

- thread status notification updates the headless TUI status row;
- assistant delta appends a transcript row before the next draw;
- stream-close disables later app-server event mutation;
- disconnected transport records fatal-style rejection without live transport;
- ordering is deterministic relative to queued app events and draw/key events.

Status: HXCX-TUI-3 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/app.rs:1188`, `../codex/codex-rs/tui/src/app/app_server_events.rs:23`, `../codex/codex-rs/tui/src/app/app_server_events.rs:35`, `../codex/codex-rs/tui/src/app/app_server_events.rs:43`, `../codex/codex-rs/tui/src/app/app_server_events.rs:73`, `../codex/codex-rs/tui/src/app/app_server_event_targets.rs:7`, `../codex/codex-rs/tui/src/app/app_server_event_targets.rs:40`, `../codex/codex-rs/tui/src/app_server_session.rs:377`, and `../codex/codex-rs/app-server-client/src/lib.rs:112`. This is app-server event ordering evidence only, not JSON-RPC decoding, Tokio stream ownership, live request routing, active-thread queue fanout, server-request approval UI, or Cafex behavior.

### HXCX-TUI-4: Headless Raw Codex TUI Server-Request Facade

Extend the app-server facade with request routing evidence:

- typed command/file/permissions approval and tool-user-input request DTOs;
- pending request admission before target routing;
- primary versus side-thread target summaries;
- threadless request ignores;
- unsupported dynamic/attestation/legacy request rejection summaries;
- deterministic ordering relative to queued app events, draw, and key events.

Status: HXCX-TUI-4 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/app/app_server_events.rs:48`, `../codex/codex-rs/tui/src/app/app_server_events.rs:156`, `../codex/codex-rs/tui/src/app/app_server_events.rs:162`, `../codex/codex-rs/tui/src/app/app_server_events.rs:185`, `../codex/codex-rs/tui/src/app/app_server_event_targets.rs:7`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:56`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:72`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:116`, `../codex/codex-rs/tui/src/app_server_session.rs:1109`, `../codex/codex-rs/tui/src/app_server_session.rs:1117`, `../codex/codex-rs/tui/src/app.rs:574`, `../codex/codex-rs/tui/src/app.rs:1219`, and `../codex/codex-rs/tui/src/app_event.rs:198`. This is request-routing evidence only, not live JSON-RPC resolution, approval popup UI, actual command/file/tool execution, Tokio channel ownership, or Cafex behavior.

### HXCX-TUI-5: Headless Raw Codex TUI Server-Request Resolution Facade

Extend the server-request facade with pending request resolution evidence:

- command approval, file-change approval, permissions approval, and tool user-input answer resolution DTOs;
- pending request lookup by upstream-shaped keys, including tool input answer lookup by turn id;
- `ServerRequestResolved`-style dismissal by app-server request id;
- stale and unknown resolution refusal without terminating the headless loop;
- deterministic ordering relative to queued app events, draw, and key events.

Status: HXCX-TUI-5 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/app/app_server_requests.rs:160`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:169`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:186`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:201`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:220`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:261`, `../codex/codex-rs/tui/src/app/app_server_events.rs:66`, `../codex/codex-rs/tui/src/app/app_server_events.rs:71`, `../codex/codex-rs/tui/src/app_server_session.rs:1117`, `../codex/codex-rs/tui/src/app_command.rs:70`, `../codex/codex-rs/tui/src/app_command.rs:75`, `../codex/codex-rs/tui/src/app_command.rs:86`, and `../codex/codex-rs/tui/src/app_command.rs:90`. This is request-resolution intent evidence only, not live JSON-RPC response dispatch, approval popup UI ownership, command execution, filesystem mutation, model traffic, or Cafex behavior.

### HXCX-TUI-6: Headless Raw Codex TUI Active-Thread Request Delivery Facade

Extend the server-request facade with thread-buffer delivery evidence:

- primary-thread request delivery through an explicit active drain;
- side-thread request buffering while the primary thread is active;
- active-thread switch delivery for queued side-thread requests;
- stale and evicted queued request receipts;
- deterministic ordering relative to queued app events, draw, and key events.

Status: HXCX-TUI-6 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/app/app_server_events.rs:192`, `../codex/codex-rs/tui/src/app/app_server_events.rs:194`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1003`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1027`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1127`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1136`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1168`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1248`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1428`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1440`, `../codex/codex-rs/tui/src/app/thread_events.rs:19`, `../codex/codex-rs/tui/src/app/thread_events.rs:53`, `../codex/codex-rs/tui/src/app/thread_events.rs:135`, and `../codex/codex-rs/tui/src/chatwidget/protocol_requests.rs:9`. This is active-thread delivery intent evidence only, not Tokio channel ownership, snapshot replay ownership, approval popup UI ownership, live app-server transport, model traffic, tool execution, or Cafex behavior.

### HXCX-TUI-7: Headless Raw Codex TUI Active-Thread Notification Delivery Facade

Extend the active-thread delivery facade with thread notification buffering evidence:

- primary-thread notification delivery through an explicit active drain;
- side-thread notification buffering while another thread is active;
- active-thread switch replay/delivery for queued side-thread notifications;
- stale and evicted queued notification receipts;
- deterministic ordering relative to queued app events, draw, and key events.

Status: HXCX-TUI-7 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/app.rs:1188`, `../codex/codex-rs/tui/src/app/app_server_events.rs:120`, `../codex/codex-rs/tui/src/app_server_session.rs:377`, `../codex/codex-rs/tui/src/app_event.rs:198`, `../codex/codex-rs/tui/src/app/thread_routing.rs:860`, `../codex/codex-rs/tui/src/app/thread_routing.rs:900`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1127`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1132`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1160`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1428`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1435`, `../codex/codex-rs/tui/src/app/thread_events.rs:19`, `../codex/codex-rs/tui/src/app/thread_events.rs:53`, `../codex/codex-rs/tui/src/app/thread_events.rs:100`, `../codex/codex-rs/tui/src/app/replay_filter.rs:24`, and `../codex/codex-rs/tui/src/chatwidget/protocol.rs:4`. This is active-thread notification delivery intent evidence only, not Tokio channel ownership, snapshot replay ownership, live app-server transport, model traffic, tool execution, or Cafex behavior.

### HXCX-TUI-8: Headless Raw Codex TUI Pending Interactive Replay Filter Facade

Extend the active-thread buffer facade with snapshot replay filtering evidence:

- pending interactive requests survive thread snapshot replay;
- answered or resolved requests remain buffered but are skipped during replay;
- evicted requests are removed from both the queue and pending replay state;
- warning/config/guardian-style notices are suppressed when a snapshot contains pending interactive prompts;
- replay delivery attaches `ThreadSnapshot`-style intent without consuming the live active-thread queue.

Status: HXCX-TUI-8 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/app/pending_interactive_replay.rs:24`, `../codex/codex-rs/tui/src/app/pending_interactive_replay.rs:354`, `../codex/codex-rs/tui/src/app/thread_events.rs:108`, `../codex/codex-rs/tui/src/app/thread_events.rs:130`, `../codex/codex-rs/tui/src/app/thread_events.rs:148`, `../codex/codex-rs/tui/src/app/thread_events.rs:204`, `../codex/codex-rs/tui/src/app/thread_events.rs:212`, `../codex/codex-rs/tui/src/app/replay_filter.rs:9`, `../codex/codex-rs/tui/src/app/replay_filter.rs:24`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1308`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1315`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1331`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1334`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1461`, `../codex/codex-rs/tui/src/app_server_session.rs:377`, `../codex/codex-rs/tui/src/app_event.rs:593`, and `../codex/codex-rs/tui/src/chatwidget/protocol.rs:4`. This is pending interactive replay/filter intent evidence only, not Tokio channel ownership, live app-server transport, interactive approval UI ownership, model traffic, tool execution, or Cafex behavior.

### HXCX-TUI-9: Headless Raw Codex TUI Thread Snapshot Turn-History Replay Facade

Extend the snapshot replay facade with turn-history rendering evidence:

- snapshot turns replay before buffered snapshot events;
- turn order and item order inside each turn are preserved;
- replayed user, assistant, reasoning, and tool-like rows project into typed transcript state;
- terminal restored turns synthesize turn-complete replay receipts for completed, interrupted, and failed turns;
- turn replay composes with pending interactive replay filtering and notice suppression.

Status: HXCX-TUI-9 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/app/thread_routing.rs:1308`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1315`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1331`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1334`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1461`, `../codex/codex-rs/tui/src/app/thread_events.rs:212`, `../codex/codex-rs/tui/src/app/replay_filter.rs:9`, `../codex/codex-rs/tui/src/app/replay_filter.rs:24`, `../codex/codex-rs/tui/src/app_event.rs:593`, `../codex/codex-rs/tui/src/chatwidget/replay.rs:12`, `../codex/codex-rs/tui/src/chatwidget/replay.rs:30`, `../codex/codex-rs/tui/src/chatwidget/replay.rs:51`, `../codex/codex-rs/tui/src/chatwidget/replay.rs:67`, `../codex/codex-rs/tui/src/chatwidget/replay.rs:197`, `../codex/codex-rs/tui/src/chatwidget/protocol.rs:67`, `../codex/codex-rs/tui/src/chatwidget/tests/history_replay.rs:43`, `../codex/codex-rs/tui/src/chatwidget/tests/history_replay.rs:791`, `../codex/codex-rs/tui/src/chatwidget/tests/history_replay.rs:1050`, and `../codex/codex-rs/tui/src/chatwidget/tests/history_replay.rs:1064`. This is turn-history replay evidence only, not Tokio channel ownership, live app-server transport, interactive approval UI ownership, model traffic, tool execution, ratatui rendering, or Cafex behavior.

### HXCX-TUI-10: Headless Raw Codex TUI Thread Snapshot Session/Input Replay Facade

Extend the snapshot replay facade with the replay envelope around turn/event replay:

- replay buffer begin/end intent is emitted when resize reflow is enabled and the snapshot has turns or buffered events;
- session replay distinguishes normal, quiet, and side-conversation display paths;
- queue autosend suppression brackets input restoration and replay;
- restored input state updates composer text and task-running status;
- pending initial submit and resumed queued-input intent are emitted only after autosend suppression is lifted.

Status: HXCX-TUI-10 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/app/thread_routing.rs:1308`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1312`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1315`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1316`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1318`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1320`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1322`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1326`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1328`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1341`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1344`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1347`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1349`, `../codex/codex-rs/tui/src/app/thread_events.rs:212`, `../codex/codex-rs/tui/src/app/replay_filter.rs:9`, `../codex/codex-rs/tui/src/app/replay_filter.rs:24`, `../codex/codex-rs/tui/src/app_event.rs:593`, `../codex/codex-rs/tui/src/app/event_dispatch.rs:197`, `../codex/codex-rs/tui/src/app/event_dispatch.rs:223`, `../codex/codex-rs/tui/src/chatwidget/session_flow.rs:149`, `../codex/codex-rs/tui/src/chatwidget/session_flow.rs:159`, `../codex/codex-rs/tui/src/chatwidget/session_flow.rs:168`, `../codex/codex-rs/tui/src/chatwidget/input_restore.rs:330`, `../codex/codex-rs/tui/src/chatwidget/input_restore.rs:425`, and `../codex/codex-rs/tui/src/chatwidget/tests/history_replay.rs:791`. This is session/input replay-envelope evidence only, not Tokio channel ownership, live app-server transport, live input submission, model traffic, tool execution, ratatui rendering, or Cafex behavior.

### HXCX-TUI-11: Headless Raw Codex TUI Replayed Server-Request Surface Facade

Extend snapshot replay with typed server-request surface evidence:

- replayed command approval, file-change approval, permissions approval, MCP elicitation, and tool user-input requests map to distinct typed surface kinds;
- replayed unsupported app-server request variants suppress the live TUI stub path;
- pending buffered requests replay with `ThreadSnapshot` intent while resolved requests remain skipped;
- replayed request surfaces compose with quiet session/input replay, replay notice suppression, and queued app-event ordering.

Status: HXCX-TUI-11 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/app/thread_routing.rs:1333`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1461`, `../codex/codex-rs/tui/src/app/thread_events.rs:148`, `../codex/codex-rs/tui/src/app/thread_events.rs:212`, `../codex/codex-rs/tui/src/app/replay_filter.rs:9`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:82`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:91`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:96`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:101`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:109`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:119`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:260`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:305`, `../codex/codex-rs/tui/src/chatwidget/protocol_requests.rs:10`, `../codex/codex-rs/tui/src/chatwidget/protocol_requests.rs:14`, `../codex/codex-rs/tui/src/chatwidget/protocol_requests.rs:20`, `../codex/codex-rs/tui/src/chatwidget/protocol_requests.rs:23`, `../codex/codex-rs/tui/src/chatwidget/protocol_requests.rs:26`, `../codex/codex-rs/tui/src/chatwidget/protocol_requests.rs:29`, `../codex/codex-rs/tui/src/chatwidget/protocol_requests.rs:34`, `../codex/codex-rs/tui/src/chatwidget/tool_requests.rs:258`, `../codex/codex-rs/tui/src/chatwidget/tool_requests.rs:270`, `../codex/codex-rs/tui/src/chatwidget/tool_requests.rs:288`, and `../codex/codex-rs/tui/src/chatwidget/tests/history_replay.rs:791`. This is request-surface replay evidence only, not Tokio channel ownership, live app-server transport, approval popup ownership, model traffic, tool execution, ratatui rendering, or Cafex behavior.

### HXCX-TUI-12: Headless Raw Codex TUI Replayed Notification/History Event Surface Facade

Extend snapshot replay with typed notification/history/feedback event surface evidence:

- replayed `ThreadBufferedEvent::Notification`, `HistoryEntryResponse`, and `FeedbackSubmission` map to explicit Haxe variants;
- replayed notifications carry their `thread_snapshot` source tag and reuse existing typed notification DTOs;
- pending interactive replay suppresses notice-class notifications while preserving history/feedback event ordering;
- direct snapshot event replay composes after turn history, request surfaces, and pending buffered request/notice replay;
- active and side-thread replay ordering remains deterministic and terminal/headless only.

Status: HXCX-TUI-12 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/app/thread_routing.rs:1428`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1435`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1449`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1452`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1461`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1469`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1472`, `../codex/codex-rs/tui/src/app/thread_routing.rs:1066`, `../codex/codex-rs/tui/src/app/thread_events.rs:18`, `../codex/codex-rs/tui/src/app/thread_events.rs:22`, `../codex/codex-rs/tui/src/app/thread_events.rs:23`, `../codex/codex-rs/tui/src/app/thread_events.rs:57`, `../codex/codex-rs/tui/src/app/thread_events.rs:60`, `../codex/codex-rs/tui/src/app/thread_events.rs:212`, `../codex/codex-rs/tui/src/app/thread_events.rs:221`, `../codex/codex-rs/tui/src/app/replay_filter.rs:9`, `../codex/codex-rs/tui/src/app/replay_filter.rs:24`, `../codex/codex-rs/tui/src/chatwidget/protocol.rs:10`, `../codex/codex-rs/tui/src/chatwidget/protocol.rs:67`, `../codex/codex-rs/tui/src/chatwidget/replay.rs:12`, `../codex/codex-rs/tui/src/chatwidget/replay.rs:30`, `../codex/codex-rs/tui/src/app/background_requests.rs:469`, and `../codex/codex-rs/tui/src/chatwidget/tests/history_replay.rs:791`. This is replayed event-surface evidence only, not Tokio channel ownership, live app-server transport, approval popup ownership, feedback upload execution, model traffic, tool execution, ratatui rendering, or Cafex behavior.

### HXCX-TUI-13: Headless Raw Codex TUI Replay Buffer Flush/Reflow Facade

Extend snapshot replay with typed replay-buffer and reflow intent evidence:

- replay buffer mode distinguishes initial-history replay from thread-switch replay;
- replay buffer plan records terminal size, previous size, row cap, retained rows, and transcript-tail rendering intent;
- flush/reflow traces happen after turn/request/event replay and before buffer end, queued app events, and draw;
- resize-triggered reflow evidence records target width and height-change facts without taking over a live terminal;
- side/main thread replay ordering remains deterministic and credential-free.

Status: HXCX-TUI-13 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/app/event_dispatch.rs:194`, `../codex/codex-rs/tui/src/app/event_dispatch.rs:197`, `../codex/codex-rs/tui/src/app/event_dispatch.rs:207`, `../codex/codex-rs/tui/src/app/event_dispatch.rs:223`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:112`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:122`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:133`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:150`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:176`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:224`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:235`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:311`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:390`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:434`, `../codex/codex-rs/tui/src/chatwidget/replay.rs:14`, `../codex/codex-rs/tui/tests/suite/resize_reflow.rs:17`, `../codex/codex-rs/tui/tests/suite/resize_reflow.rs:190`, and `../codex/codex-rs/tui/tests/suite/resize_reflow.rs:323`. This is replay-buffer/reflow intent evidence only, not live terminal ownership, terminal clearing, ratatui rendering, live frame scheduling, model traffic, tool execution, or Cafex behavior.

### HXCX-TUI-14: Headless Raw Codex TUI Resize Draw Scheduling Facade

Extend the headless draw loop with typed resize-sensitive scheduling evidence:

- draw-size-change records terminal size, previous size, width initialization/change, and height-only rebuild facts;
- resize reflow scheduling records target width, debounce acceptance, pending-history clearing, and frame request intent;
- pending reflow before deadline re-arms a delayed draw instead of running immediately;
- due reflow defers while an overlay owns rendering, then runs and schedules a follow-up draw when the overlay is gone;
- app-event draining still precedes resize draw handling, and terminal restore remains deterministic.

Status: HXCX-TUI-14 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/app/resize_reflow.rs:313`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:319`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:324`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:331`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:333`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:335`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:367`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:374`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:380`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:390`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:404`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:407`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:419`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:428`, `../codex/codex-rs/tui/src/tui.rs:504`, `../codex/codex-rs/tui/src/tui.rs:789`, `../codex/codex-rs/tui/src/tui.rs:999`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:48`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:54`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:94`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:110`, and `../codex/codex-rs/tui/tests/suite/resize_reflow.rs:17`. This is resize draw scheduling evidence only, not live frame-requester ownership, Tokio task spawning, terminal clearing, ratatui rendering, model traffic, tool execution, or Cafex behavior.

### HXCX-TUI-15: Headless Raw Codex TUI Resize Repaint Scrollback Facade

Extend resize draw evidence into repaint/scrollback insertion intent:

- empty transcript reflow clears pending history lines and resets history emission state without clearing scrollback;
- source-backed reflow records transcript cell count, row cap, rendered rows, and wrap policy before insertion;
- inline repaint records scrollback-and-visible clear intent plus viewport/full repaint facts;
- alt-screen repaint records visible-only clear intent and can skip insertion when no rows are rendered;
- deferred history lines are cleared before source-backed rows are inserted and history insertion schedules a follow-up frame.

Status: HXCX-TUI-15 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/app/resize_reflow.rs:70`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:72`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:211`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:245`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:248`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:253`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:434`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:439`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:444`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:448`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:451`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:453`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:498`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:549`, `../codex/codex-rs/tui/src/tui.rs:773`, `../codex/codex-rs/tui/src/tui.rs:792`, `../codex/codex-rs/tui/src/tui.rs:809`, `../codex/codex-rs/tui/src/tui.rs:855`, `../codex/codex-rs/tui/src/tui.rs:1002`, and `../codex/codex-rs/tui/tests/suite/resize_reflow.rs:190`. This is repaint/scrollback intent evidence only, not live terminal clearing, terminal backend mutation, ratatui rendering, live frame scheduling, model traffic, tool execution, or Cafex behavior.

### HXCX-TUI-16: Headless Raw Codex TUI Inline Viewport Resize Sync Facade

Extend repaint evidence into inline viewport resize synchronization:

- viewport resize records previous area, next area, requested height, height shrink/grow, and bottom alignment;
- shrink overflow suppresses scroll-region movement so resize replay owns rebuilding scrollback;
- non-shrink overflow records scroll-region-up intent before viewport update;
- viewport updates record clear-after-position and full repaint invalidation intent;
- pending history flush records batch/row counts, wrap policy, and Zellij raw mode selection before draw.

Status: HXCX-TUI-16 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/tui.rs:792`, `../codex/codex-rs/tui/src/tui.rs:800`, `../codex/codex-rs/tui/src/tui.rs:809`, `../codex/codex-rs/tui/src/tui.rs:812`, `../codex/codex-rs/tui/src/tui.rs:819`, `../codex/codex-rs/tui/src/tui.rs:821`, `../codex/codex-rs/tui/src/tui.rs:825`, `../codex/codex-rs/tui/src/tui.rs:829`, `../codex/codex-rs/tui/src/tui.rs:831`, `../codex/codex-rs/tui/src/tui.rs:840`, `../codex/codex-rs/tui/src/tui.rs:850`, `../codex/codex-rs/tui/src/tui.rs:855`, `../codex/codex-rs/tui/src/tui.rs:1002`, `../codex/codex-rs/tui/src/tui.rs:1020`, `../codex/codex-rs/tui/src/tui.rs:1022`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:378`, and `../codex/codex-rs/tui/tests/suite/resize_reflow.rs:323`. This is inline viewport synchronization evidence only, not live terminal backend mutation, real scroll-region writes, terminal clearing, ratatui rendering, live frame scheduling, model traffic, tool execution, or Cafex behavior.

### HXCX-TUI-17: Headless Raw Codex TUI Suspend/Resume Viewport Facade

Extend inline viewport sync evidence into suspend/resume restoration:

- suspend captures realign-inline versus restore-alt intent and cached cursor row;
- alt-screen suspend records leave-alt-screen and alternate-scroll restore intent;
- resume preparation consumes pending action, updates saved alt viewport y from cursor when applicable, and applies prepared action before viewport resize sync;
- inline resume realigns the viewport from cursor position before resize sync;
- synchronized draw updates suspend cursor-y from active inline/alt viewport after viewport work.

Status: HXCX-TUI-17 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/tui/job_control.rs:27`, `../codex/codex-rs/tui/src/tui/job_control.rs:64`, `../codex/codex-rs/tui/src/tui/job_control.rs:73`, `../codex/codex-rs/tui/src/tui/job_control.rs:82`, `../codex/codex-rs/tui/src/tui/job_control.rs:94`, `../codex/codex-rs/tui/src/tui/job_control.rs:98`, `../codex/codex-rs/tui/src/tui/job_control.rs:102`, `../codex/codex-rs/tui/src/tui/job_control.rs:111`, `../codex/codex-rs/tui/src/tui/job_control.rs:123`, `../codex/codex-rs/tui/src/tui/job_control.rs:144`, `../codex/codex-rs/tui/src/tui/job_control.rs:155`, `../codex/codex-rs/tui/src/tui/job_control.rs:158`, `../codex/codex-rs/tui/src/tui/job_control.rs:161`, `../codex/codex-rs/tui/src/tui/job_control.rs:166`, `../codex/codex-rs/tui/src/tui.rs:1002`, `../codex/codex-rs/tui/src/tui.rs:1011`, `../codex/codex-rs/tui/src/tui.rs:1017`, `../codex/codex-rs/tui/src/tui.rs:1022`, `../codex/codex-rs/tui/src/tui.rs:1035`, `../codex/codex-rs/tui/src/tui.rs:1040`, and `../codex/codex-rs/tui/src/tui.rs:1046`. This is suspend/resume viewport evidence only, not live SIGTSTP delivery, terminal mode mutation, alternate-screen control, terminal backend mutation, ratatui rendering, model traffic, tool execution, or Cafex behavior.

### HXCX-TUI-18: Headless Raw Codex TUI Event-Stream Pause/Resume Facade

Extend suspend/resume evidence into the event-stream lifecycle around terminal handoff:

- event broker state records `Running`, `Paused`, and `Start` transitions;
- pause drops the underlying input source so external terminal programs can own stdin;
- resume wakes paused/pending streams and recreates the source on the next poll;
- draw events, lagged draw events, key, resize, paste, focus-gained, and focus-lost mapping intent is typed;
- restored-terminal flow records alt-screen leave/enter, terminal/stderr restoration, mode reset, and stale input flushing before event resume.

Status: HXCX-TUI-18 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/tui/event_stream.rs:47`, `../codex/codex-rs/tui/src/tui/event_stream.rs:57`, `../codex/codex-rs/tui/src/tui/event_stream.rs:63`, `../codex/codex-rs/tui/src/tui/event_stream.rs:89`, `../codex/codex-rs/tui/src/tui/event_stream.rs:98`, `../codex/codex-rs/tui/src/tui/event_stream.rs:108`, `../codex/codex-rs/tui/src/tui/event_stream.rs:132`, `../codex/codex-rs/tui/src/tui/event_stream.rs:173`, `../codex/codex-rs/tui/src/tui/event_stream.rs:224`, `../codex/codex-rs/tui/src/tui/event_stream.rs:236`, `../codex/codex-rs/tui/src/tui/event_stream.rs:268`, `../codex/codex-rs/tui/src/tui/event_stream.rs:459`, `../codex/codex-rs/tui/src/tui/event_stream.rs:470`, `../codex/codex-rs/tui/src/tui/event_stream.rs:484`, `../codex/codex-rs/tui/src/tui.rs:618`, `../codex/codex-rs/tui/src/tui.rs:623`, `../codex/codex-rs/tui/src/tui.rs:629`, `../codex/codex-rs/tui/src/tui.rs:639`, `../codex/codex-rs/tui/src/tui.rs:663`, and `../codex/codex-rs/tui/src/tui.rs:670`. This is event-stream lifecycle evidence only, not live crossterm EventStream ownership, Tokio stream execution, terminal mode mutation, alternate-screen control, ratatui rendering, model traffic, tool execution, or Cafex behavior.

### HXCX-TUI-19: Headless Raw Codex TUI Terminal Mode And Keyboard Enhancement Facade

Extend event-stream lifecycle evidence into terminal setup/restore policy:

- `set_modes` records virtual terminal processing, bracketed paste, raw mode, keyboard enhancement, and focus-change intent;
- `restore_common` records raw-mode restore policy, keyboard stack pop/reset policy, bracketed-paste/focus teardown, and cursor restoration;
- init records terminal checks, startup probe support, panic restore hook, and stale input flushing;
- keyboard decisions record env override, WSL/VS Code auto-disable, tmux CSI-U modifyOtherKeys enablement, and after-exit reset;
- terminal failure summaries remain typed and headless instead of mutating the real terminal.

Status: HXCX-TUI-19 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/tui.rs:173`, `../codex/codex-rs/tui/src/tui.rs:245`, `../codex/codex-rs/tui/src/tui.rs:280`, `../codex/codex-rs/tui/src/tui.rs:288`, `../codex/codex-rs/tui/src/tui.rs:302`, `../codex/codex-rs/tui/src/tui.rs:322`, `../codex/codex-rs/tui/src/tui.rs:361`, `../codex/codex-rs/tui/src/tui.rs:490`, `../codex/codex-rs/tui/src/tui/keyboard_modes.rs:18`, `../codex/codex-rs/tui/src/tui/keyboard_modes.rs:25`, `../codex/codex-rs/tui/src/tui/keyboard_modes.rs:40`, `../codex/codex-rs/tui/src/tui/keyboard_modes.rs:64`, `../codex/codex-rs/tui/src/tui/keyboard_modes.rs:121`, `../codex/codex-rs/tui/src/tui/keyboard_modes.rs:141`, `../codex/codex-rs/tui/src/tui/keyboard_modes.rs:159`, `../codex/codex-rs/tui/src/tui/keyboard_modes.rs:197`, `../codex/codex-rs/tui/src/tui/keyboard_modes.rs:205`, `../codex/codex-rs/tui/src/tui/keyboard_modes.rs:217`, `../codex/codex-rs/tui/src/tui/keyboard_modes.rs:239`, `../codex/codex-rs/tui/src/tui/keyboard_modes.rs:261`, `../codex/codex-rs/tui/src/tui/keyboard_modes.rs:311`, `../codex/codex-rs/tui/src/tui/keyboard_modes.rs:328`, `../codex/codex-rs/tui/src/tui/keyboard_modes.rs:342`, and `../codex/codex-rs/tui/src/tui/keyboard_modes.rs:373`. This is terminal mode and keyboard policy evidence only, not live raw-mode mutation, real ANSI writes, crossterm EventStream ownership, Tokio stream execution, ratatui rendering, model traffic, tool execution, or Cafex behavior.

### HXCX-TUI-20: Headless Raw Codex TUI Alternate-Screen Lifecycle Facade

Extend terminal-mode and keyboard policy evidence into alternate-screen lifecycle intent:

- `set_alt_screen_enabled` records the semantic switch that makes enter/leave no-ops when disabled;
- entering records inline viewport capture, full-screen viewport expansion, alternate-screen command, alternate-scroll command, and terminal clear intent;
- leaving records alternate-scroll disablement, alternate-screen leave intent, saved viewport take/restore, and inactive state;
- clear-for-viewport-change records whether the old viewport anchor or new viewport anchor would drive `clear_after_position`;
- failure summaries remain typed and secret-free instead of touching the live terminal.

Status: HXCX-TUI-20 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/tui.rs:521`, `../codex/codex-rs/tui/src/tui.rs:524`, `../codex/codex-rs/tui/src/tui.rs:533`, `../codex/codex-rs/tui/src/tui.rs:544`, `../codex/codex-rs/tui/src/tui.rs:548`, `../codex/codex-rs/tui/src/tui.rs:553`, `../codex/codex-rs/tui/src/tui.rs:578`, `../codex/codex-rs/tui/src/tui.rs:581`, `../codex/codex-rs/tui/src/tui.rs:587`, `../codex/codex-rs/tui/src/tui.rs:592`, `../codex/codex-rs/tui/src/tui.rs:614`, `../codex/codex-rs/tui/src/tui.rs:720`, `../codex/codex-rs/tui/src/tui.rs:723`, `../codex/codex-rs/tui/src/tui.rs:726`, `../codex/codex-rs/tui/src/tui.rs:728`, `../codex/codex-rs/tui/src/tui.rs:729`, `../codex/codex-rs/tui/src/tui.rs:730`, `../codex/codex-rs/tui/src/tui.rs:731`, `../codex/codex-rs/tui/src/tui.rs:737`, `../codex/codex-rs/tui/src/tui.rs:739`, `../codex/codex-rs/tui/src/tui.rs:743`, `../codex/codex-rs/tui/src/tui.rs:745`, `../codex/codex-rs/tui/src/tui.rs:749`, `../codex/codex-rs/tui/src/tui.rs:750`, `../codex/codex-rs/tui/src/tui.rs:751`, `../codex/codex-rs/tui/src/tui.rs:752`, `../codex/codex-rs/tui/src/tui.rs:754`, `../codex/codex-rs/tui/src/custom_terminal.rs:93`, `../codex/codex-rs/tui/src/custom_terminal.rs:217`, `../codex/codex-rs/tui/src/custom_terminal.rs:236`, `../codex/codex-rs/tui/src/custom_terminal.rs:301`, `../codex/codex-rs/tui/src/custom_terminal.rs:309`, `../codex/codex-rs/tui/src/custom_terminal.rs:312`, `../codex/codex-rs/tui/src/custom_terminal.rs:472`, and `../codex/codex-rs/tui/src/custom_terminal.rs:480`. This is alternate-screen lifecycle evidence only, not live alternate-screen mutation, real ANSI writes, crossterm EventStream ownership, Tokio stream execution, ratatui rendering, model traffic, tool execution, or Cafex behavior.

### HXCX-TUI-21: Headless Raw Codex TUI Draw/Update Composition Facade

Extend alternate-screen lifecycle evidence into the synchronized draw/update boundary:

- legacy draw records resume preparation, pending cursor-based viewport precomputation, virtual-terminal enablement, synchronized update ordering, viewport clear/set, pending history flush, suspend cursor update, and terminal draw;
- resize-reflow draw records that the pending viewport heuristic is skipped, then tracks resize-reflow viewport update, full repaint invalidation, pending history flush, suspend cursor update, and terminal draw;
- custom terminal draw records autoresize, render callback, diff update counts, cursor show/hide placement, buffer swapping, and backend flushing;
- frame scheduling remains an upstream actor/coalescing concern; this slice records draw/update facts but does not spawn Tokio tasks or own a live broadcast channel.

Status: HXCX-TUI-21 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/tui.rs:789`, `../codex/codex-rs/tui/src/tui.rs:840`, `../codex/codex-rs/tui/src/tui.rs:866`, `../codex/codex-rs/tui/src/tui.rs:878`, `../codex/codex-rs/tui/src/tui.rs:880`, `../codex/codex-rs/tui/src/tui.rs:884`, `../codex/codex-rs/tui/src/tui.rs:891`, `../codex/codex-rs/tui/src/tui.rs:896`, `../codex/codex-rs/tui/src/tui.rs:901`, `../codex/codex-rs/tui/src/tui.rs:911`, `../codex/codex-rs/tui/src/tui.rs:915`, `../codex/codex-rs/tui/src/tui.rs:921`, `../codex/codex-rs/tui/src/tui.rs:935`, `../codex/codex-rs/tui/src/tui.rs:1002`, `../codex/codex-rs/tui/src/tui.rs:1014`, `../codex/codex-rs/tui/src/tui.rs:1016`, `../codex/codex-rs/tui/src/tui.rs:1023`, `../codex/codex-rs/tui/src/tui.rs:1025`, `../codex/codex-rs/tui/src/tui.rs:1031`, `../codex/codex-rs/tui/src/tui.rs:1035`, `../codex/codex-rs/tui/src/tui.rs:1049`, `../codex/codex-rs/tui/src/tui.rs:1055`, `../codex/codex-rs/tui/src/tui.rs:1059`, `../codex/codex-rs/tui/src/tui.rs:1060`, `../codex/codex-rs/tui/src/tui.rs:1066`, `../codex/codex-rs/tui/src/tui.rs:1071`, `../codex/codex-rs/tui/src/custom_terminal.rs:152`, `../codex/codex-rs/tui/src/custom_terminal.rs:290`, `../codex/codex-rs/tui/src/custom_terminal.rs:291`, `../codex/codex-rs/tui/src/custom_terminal.rs:293`, `../codex/codex-rs/tui/src/custom_terminal.rs:296`, `../codex/codex-rs/tui/src/custom_terminal.rs:348`, `../codex/codex-rs/tui/src/custom_terminal.rs:393`, `../codex/codex-rs/tui/src/custom_terminal.rs:400`, `../codex/codex-rs/tui/src/custom_terminal.rs:402`, `../codex/codex-rs/tui/src/custom_terminal.rs:404`, `../codex/codex-rs/tui/src/custom_terminal.rs:413`, `../codex/codex-rs/tui/src/custom_terminal.rs:415`, `../codex/codex-rs/tui/src/custom_terminal.rs:424`, `../codex/codex-rs/tui/src/custom_terminal.rs:426`, `../codex/codex-rs/tui/src/custom_terminal.rs:576`, `../codex/codex-rs/tui/src/custom_terminal.rs:580`, `../codex/codex-rs/tui/src/custom_terminal.rs:606`, `../codex/codex-rs/tui/src/custom_terminal.rs:622`, `../codex/codex-rs/tui/src/custom_terminal.rs:641`, `../codex/codex-rs/tui/src/custom_terminal.rs:655`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:23`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:49`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:54`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:70`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:92`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:104`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:110`, and `../codex/codex-rs/tui/src/tui/frame_requester.rs:122`. This is draw/update composition evidence only, not live terminal backend mutation, real ANSI writes, Tokio frame scheduling, crossterm EventStream ownership, ratatui rendering, model traffic, tool execution, or Cafex behavior.

### HXCX-TUI-22: Headless Raw Codex TUI Frame Requester Scheduler Facade

Extend draw/update composition evidence into frame request scheduling:

- frame requester creation records the actor-style request handle plus scheduler task intent without spawning Tokio;
- immediate and delayed requests record representative upstream callers such as `ChatWidget::request_redraw`, resize reflow, status animation, and paste-burst follow-up ticks;
- scheduler evidence records deadline clamping to the 120 FPS minimum interval and coalescing multiple requests into the earliest deadline;
- draw broadcast evidence records emitted draw notifications, lagged draw mapping, and sender-drop shutdown/failure summaries.

Status: HXCX-TUI-22 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/tui/frame_requester.rs:23`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:39`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:42`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:49`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:54`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:70`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:92`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:96`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:104`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:106`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:110`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:111`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:118`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:121`, `../codex/codex-rs/tui/src/tui/frame_requester.rs:122`, `../codex/codex-rs/tui/src/tui/frame_rate_limiter.rs:12`, `../codex/codex-rs/tui/src/tui/frame_rate_limiter.rs:23`, `../codex/codex-rs/tui/src/tui/frame_rate_limiter.rs:27`, `../codex/codex-rs/tui/src/tui/frame_rate_limiter.rs:30`, `../codex/codex-rs/tui/src/tui/frame_rate_limiter.rs:34`, `../codex/codex-rs/tui/src/chatwidget.rs:1385`, `../codex/codex-rs/tui/src/chatwidget.rs:1386`, `../codex/codex-rs/tui/src/chatwidget/interaction.rs:333`, `../codex/codex-rs/tui/src/chatwidget/interaction.rs:338`, `../codex/codex-rs/tui/src/chatwidget/interaction.rs:343`, `../codex/codex-rs/tui/src/status_indicator_widget.rs:183`, `../codex/codex-rs/tui/src/status_indicator_widget.rs:247`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:275`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:286`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:333`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:335`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:404`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:428`, `../codex/codex-rs/tui/src/tui/event_stream.rs:224`, `../codex/codex-rs/tui/src/tui/event_stream.rs:227`, and `../codex/codex-rs/tui/src/tui/event_stream.rs:228`. This is frame scheduler evidence only, not live Tokio task spawning, broadcast channel ownership, real draw notification delivery, terminal backend mutation, ratatui rendering, model traffic, tool execution, or Cafex behavior.

### HXCX-TUI-23: Headless Raw Codex TUI Draw-Event Dispatch Facade

Extend frame scheduler evidence into draw and resize event admission:

- draw/resize dispatch records whether resize reflow owns pre-render work or the legacy path only refreshes status on size changes;
- resize reflow pre-render records pending-history clearing, due/rearmed reflow, and transcript rebuild facts before rendering;
- overlay routing records that transcript/static overlays consume draw/resize and render with full-height legacy `tui.draw`;
- main draw admission records backtrack rebuilds, pending notifications, paste-burst skip/requeue behavior, pre-draw ticks, render mode selection, and post-draw ambient pet, preview, external-editor, and follow-up frame side effects.

Status: HXCX-TUI-23 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/app.rs:1281`, `../codex/codex-rs/tui/src/app.rs:1282`, `../codex/codex-rs/tui/src/app.rs:1284`, `../codex/codex-rs/tui/src/app.rs:1291`, `../codex/codex-rs/tui/src/app.rs:1306`, `../codex/codex-rs/tui/src/app.rs:1307`, `../codex/codex-rs/tui/src/app.rs:1311`, `../codex/codex-rs/tui/src/app.rs:1314`, `../codex/codex-rs/tui/src/app.rs:1318`, `../codex/codex-rs/tui/src/app.rs:1320`, `../codex/codex-rs/tui/src/app.rs:1330`, `../codex/codex-rs/tui/src/app.rs:1337`, `../codex/codex-rs/tui/src/app.rs:1341`, `../codex/codex-rs/tui/src/app.rs:1346`, `../codex/codex-rs/tui/src/app.rs:1374`, `../codex/codex-rs/tui/src/app.rs:1377`, `../codex/codex-rs/tui/src/app.rs:1380`, `../codex/codex-rs/tui/src/app.rs:1381`, `../codex/codex-rs/tui/src/app.rs:1387`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:367`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:369`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:374`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:378`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:380`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:390`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:399`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:404`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:407`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:411`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:419`, `../codex/codex-rs/tui/src/app/resize_reflow.rs:428`, `../codex/codex-rs/tui/src/chatwidget/interaction.rs:333`, `../codex/codex-rs/tui/src/chatwidget/interaction.rs:338`, `../codex/codex-rs/tui/src/chatwidget/interaction.rs:343`, `../codex/codex-rs/tui/src/pager_overlay.rs:783`, `../codex/codex-rs/tui/src/pager_overlay.rs:794`, `../codex/codex-rs/tui/src/pager_overlay.rs:795`, `../codex/codex-rs/tui/src/pager_overlay.rs:888`, `../codex/codex-rs/tui/src/pager_overlay.rs:897`, `../codex/codex-rs/tui/src/pager_overlay.rs:898`, `../codex/codex-rs/tui/src/tui/event_stream.rs:224`, `../codex/codex-rs/tui/src/tui/event_stream.rs:227`, `../codex/codex-rs/tui/src/tui/event_stream.rs:228`, `../codex/codex-rs/tui/src/tui/event_stream.rs:247`, and `../codex/codex-rs/tui/src/tui/event_stream.rs:252`. This is draw-event dispatch evidence only, not live Tokio event-loop ownership, real terminal backend mutation, ratatui rendering, live pet image drawing, model traffic, tool execution, or Cafex behavior.

### HXCX-TUI-24: Headless Raw Codex TUI Overlay Routing Facade

Extend draw dispatch evidence into overlay ownership:

- model transcript and static overlay activation as alternate-screen ownership plus frame scheduling;
- preserve transcript overlay live-tail sync facts: terminal width, active-cell revision, stream-continuation spacing, optional animation tick, recompute decision, rendered tail lines, and pinned-to-bottom behavior;
- preserve committed transcript synchronization while an overlay is open: inserted cells, consolidated ranges, pinned scroll behavior, and follow-up frame requests;
- preserve overlay-owned draw/resize routing through `tui.draw(u16::MAX, ...)`, separate from the main chat-widget draw path;
- preserve pager key routing for scroll/page/close plus transcript backtrack preview entry without live keyboard input;
- preserve overlay done cleanup: leave alternate screen, flush deferred history lines, clear overlay/backtrack state, and schedule the restoring frame;
- keep the facade deterministic, typed, Haxe-authored, haxe.rust-compiled, and independent of live ratatui/crossterm mutation.

Status: HXCX-TUI-24 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/app.rs:1291`, `../codex/codex-rs/tui/src/app.rs:1292`, `../codex/codex-rs/tui/src/app_backtrack.rs:111`, `../codex/codex-rs/tui/src/app_backtrack.rs:151`, `../codex/codex-rs/tui/src/app_backtrack.rs:166`, `../codex/codex-rs/tui/src/app_backtrack.rs:267`, `../codex/codex-rs/tui/src/app_backtrack.rs:277`, `../codex/codex-rs/tui/src/app_backtrack.rs:413`, `../codex/codex-rs/tui/src/app_backtrack.rs:415`, `../codex/codex-rs/tui/src/app_backtrack.rs:422`, `../codex/codex-rs/tui/src/app_backtrack.rs:429`, `../codex/codex-rs/tui/src/app_backtrack.rs:433`, `../codex/codex-rs/tui/src/app_backtrack.rs:443`, `../codex/codex-rs/tui/src/app/event_dispatch.rs:202`, `../codex/codex-rs/tui/src/app/event_dispatch.rs:256`, `../codex/codex-rs/tui/src/app/event_dispatch.rs:264`, `../codex/codex-rs/tui/src/app/event_dispatch.rs:368`, `../codex/codex-rs/tui/src/app/event_dispatch.rs:374`, `../codex/codex-rs/tui/src/pager_overlay.rs:59`, `../codex/codex-rs/tui/src/pager_overlay.rs:77`, `../codex/codex-rs/tui/src/pager_overlay.rs:86`, `../codex/codex-rs/tui/src/pager_overlay.rs:465`, `../codex/codex-rs/tui/src/pager_overlay.rs:522`, `../codex/codex-rs/tui/src/pager_overlay.rs:566`, `../codex/codex-rs/tui/src/pager_overlay.rs:637`, `../codex/codex-rs/tui/src/pager_overlay.rs:681`, `../codex/codex-rs/tui/src/pager_overlay.rs:783`, `../codex/codex-rs/tui/src/pager_overlay.rs:794`, `../codex/codex-rs/tui/src/pager_overlay.rs:795`, `../codex/codex-rs/tui/src/pager_overlay.rs:888`, `../codex/codex-rs/tui/src/pager_overlay.rs:897`, and `../codex/codex-rs/tui/src/pager_overlay.rs:898`. This is overlay routing and ownership evidence only, not live alternate-screen mutation, live pager input loops, real ratatui rendering, model traffic, tool execution, or Cafex behavior.

### HXCX-TUI-25: Headless Raw Codex TUI Approval Overlay Lifecycle Facade

Extend pager overlay routing into approval modal lifecycle:

- model app-server approval request bookkeeping for command execution, file change, and permissions approvals;
- preserve unsupported legacy approval rejection paths as fail-closed request rejection evidence;
- preserve immediate approval modal creation, recent-typing delay, delayed prompt promotion, active-view enqueueing, status timer pause/resume, and frame scheduling;
- preserve approval key/list decision routing for accept, deny, cancel, session/prefix variants, permission grants, and stale resolved-request dismissal without emitting an abort;
- preserve app command emission and app-server resolution mapping as typed intent, without command/file/tool execution;
- preserve approval keymap conflict evidence, including fail-closed ambiguous approval bindings;
- keep the facade deterministic, typed, Haxe-authored, haxe.rust-compiled, and independent of live ratatui/crossterm mutation.

Status: HXCX-TUI-25 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/app/app_server_requests.rs:50`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:71`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:92`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:100`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:105`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:143`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:150`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:169`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:186`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:202`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:265`, `../codex/codex-rs/tui/src/app/app_server_events.rs:66`, `../codex/codex-rs/tui/src/app/app_server_events.rs:71`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:529`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:547`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:562`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1285`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1299`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1310`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1439`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1497`, `../codex/codex-rs/tui/src/bottom_pane/approval_overlay.rs:127`, `../codex/codex-rs/tui/src/bottom_pane/approval_overlay.rs:171`, `../codex/codex-rs/tui/src/bottom_pane/approval_overlay.rs:195`, `../codex/codex-rs/tui/src/bottom_pane/approval_overlay.rs:199`, `../codex/codex-rs/tui/src/bottom_pane/approval_overlay.rs:216`, `../codex/codex-rs/tui/src/bottom_pane/approval_overlay.rs:312`, `../codex/codex-rs/tui/src/bottom_pane/approval_overlay.rs:353`, `../codex/codex-rs/tui/src/bottom_pane/approval_overlay.rs:438`, `../codex/codex-rs/tui/src/bottom_pane/approval_overlay.rs:481`, `../codex/codex-rs/tui/src/bottom_pane/approval_overlay.rs:527`, `../codex/codex-rs/tui/src/bottom_pane/approval_overlay.rs:551`, `../codex/codex-rs/tui/src/bottom_pane/approval_overlay.rs:585`, `../codex/codex-rs/tui/src/bottom_pane/approval_overlay.rs:597`, `../codex/codex-rs/tui/src/bottom_pane/approval_overlay.rs:1029`, `../codex/codex-rs/tui/src/bottom_pane/approval_overlay.rs:1049`, `../codex/codex-rs/tui/src/bottom_pane/approval_overlay.rs:1083`, `../codex/codex-rs/tui/src/keymap.rs:1669`, and `../codex/codex-rs/tui/src/keymap.rs:1679`. This is approval lifecycle and request-resolution evidence only, not live approval rendering, live keyboard loops, command execution, filesystem mutation, model traffic, or Cafex behavior.

### HXCX-TUI-26: Headless Raw Codex TUI Request-User-Input Overlay Lifecycle Facade

Extend approval modal lifecycle evidence into request-user-input bottom-pane behavior:

- model app-server `ToolRequestUserInput` bookkeeping, FIFO request identity, and `UserInputAnswer` resolution routing;
- preserve immediate modal creation, active-overlay queueing, status timer pause/resume, composer disabling, and frame scheduling;
- preserve per-question option selection, notes focus, draft capture/restore, question navigation, paste/draft summaries, and secret-free answer counts;
- preserve unanswered confirmation behavior, freeform-only empty submission semantics, cancel/interrupt completion, and resolved-request dismissal;
- preserve unsupported/fail-closed summaries for headless-only cases without exposing answer text or secrets;
- keep the facade deterministic, typed, Haxe-authored, haxe.rust-compiled, and independent of live ratatui/crossterm mutation.

Status: HXCX-TUI-26 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:50`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:53`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:58`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:130`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:152`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:169`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:605`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:672`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:684`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:695`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:713`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:748`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:756`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:770`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:820`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:836`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:1010`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:1058`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:1298`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:1323`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:1346`, `../codex/codex-rs/tui/src/bottom_pane/request_user_input/mod.rs:1354`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1323`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1328`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1439`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1450`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1496`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:110`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:220`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:262`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:294`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:328`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:505`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:571`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:792`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:827`, and `../codex/codex-rs/tui/src/app/app_server_events.rs:69`. This is request-user-input lifecycle and request-resolution evidence only, not live request-user-input rendering, live keyboard loops, model/tool execution, terminal backend mutation, or Cafex behavior.

### HXCX-TUI-27: Headless Raw Codex TUI MCP Elicitation Overlay Lifecycle Facade

Extend request-user-input lifecycle evidence into MCP elicitation form behavior:

- model app-server `McpServerElicitationRequest` bookkeeping and `ResolveElicitation` response routing by server/request key;
- preserve form parsing for text, boolean, enum, message-only approval, approval-display params, and unsupported schema summaries;
- preserve modal creation, app-link tool-suggestion routing, active-overlay queueing, status timer pause/resume, composer disabling, and frame scheduling;
- preserve field navigation, selection, draft capture/restore, required-field validation, submit/cancel decisions, content object counts, and persist-meta summaries;
- preserve resolved-request dismissal for current and queued forms without exposing field answers, secrets, or credential-bearing URLs;
- keep the facade deterministic, typed, Haxe-authored, haxe.rust-compiled, and independent of live ratatui/crossterm mutation.

Status: HXCX-TUI-27 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:58`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:111`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:122`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:131`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:166`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:207`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:237`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:373`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:532`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:559`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:707`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:738`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:771`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:1047`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:1059`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:1068`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:1090`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:1157`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:1214`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:1513`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:1649`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:1683`, `../codex/codex-rs/tui/src/bottom_pane/mcp_server_elicitation.rs:1691`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1352`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1360`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1381`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1417`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1423`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1434`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1439`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1450`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1496`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:63`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:75`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:120`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:231`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:246`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:305`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:335`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:391`, `../codex/codex-rs/tui/src/app/app_server_requests.rs:602`, and `../codex/codex-rs/tui/src/app/app_server_requests.rs:758`. This is MCP elicitation lifecycle and request-resolution evidence only, not live MCP form rendering, live keyboard loops, browser/app-link opening, model/tool execution, terminal backend mutation, or Cafex behavior.

### HXCX-TUI-28: Headless Raw Codex TUI App-Link URL Elicitation Lifecycle Facade

Extend MCP form elicitation evidence into app-link URL elicitation:

- model URL elicitation admission for Codex app auth links and generic external-action links;
- preserve trusted URL validation: HTTPS, no userinfo, ChatGPT host allowlist for `codex_apps` auth links, and generic host acceptance for non-Codex app links;
- preserve AppLinkView activation, action selection, browser-open intent, confirmation screen transition, connector refresh, enable toggling, accept/decline/cancel resolution, and resolved-request dismissal;
- preserve app-server request-resolution identity by server/request id while recording only URL scheme and host, not full paths or tokens;
- keep the facade deterministic, typed, Haxe-authored, haxe.rust-compiled, and independent of browser opening, live ratatui/crossterm mutation, or Cafex behavior.

Status: HXCX-TUI-28 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:40`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:48`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:54`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:62`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:69`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:83`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:98`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:122`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:178`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:206`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:220`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:228`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:256`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:292`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:351`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:365`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:370`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:380`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:401`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:413`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:689`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:746`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:758`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:896`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:1201`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:1350`, `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs:1500`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1352`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1381`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1417`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1439`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1450`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1496`, and the HXCX-TUI-27 app-server request-resolution anchors. This is app-link URL elicitation lifecycle evidence only, not live browser opening, live app rendering, network calls, model/tool execution, terminal backend mutation, or Cafex behavior.

### HXCX-TUI-29: Headless Raw Codex TUI Hooks Browser Lifecycle Facade

Extend app-link bottom-pane evidence into the upstream hooks browser:

- model event-list activation, initial review-needed selection, event row counts, handler pane entry, handler selection/navigation, preview/detail summaries, and empty-handler rendering;
- preserve toggle behavior for trusted user/project hooks, no-op behavior for managed hooks and review-needed hooks, selected-hook trust, trust-all review-needed hooks, close/cancel handling, frame scheduling, and failure/warning summaries;
- preserve typed source/trust/page/action classification without executing hooks, mutating terminal backends, rendering ratatui widgets, or running live input loops;
- keep the facade deterministic, typed, Haxe-authored, haxe.rust-compiled, and independent of model/tool execution, live hook execution, and Cafex behavior.

Status: HXCX-TUI-29 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:44`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:49`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:79`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:102`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:135`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:142`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:149`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:166`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:180`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:207`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:219`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:240`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:258`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:280`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:329`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:432`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:471`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:499`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:562`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:563`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:610`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:615`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:620`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:698`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:707`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:730`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:745`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:760`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:764`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:775`, and `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:792`. Test anchors include `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:993`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:1019`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:1056`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:1075`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:1082`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:1166`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:1215`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:1244`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:1271`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:1288`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:1317`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:1351`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:1376`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:1405`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:1442`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:1466`, `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:1502`, and `../codex/codex-rs/tui/src/bottom_pane/hooks_browser_view.rs:1539`. This is hooks browser lifecycle evidence only, not live hook execution, live terminal backend mutation, ratatui rendering, live keyboard loops, model/tool execution, or Cafex behavior.

### HXCX-TUI-30: Headless Raw Codex TUI Slash-Command Popup Lifecycle Facade

Extend hooks browser bottom-pane evidence into the composer slash-command popup:

- model popup synchronization from composer text, command-list feature gating, alias hiding, service-tier insertion after `/model`, filter matching, row counts, selection movement, and render sizing summaries;
- preserve Tab/slash completion, Enter dispatch, service-tier dispatch, local slash history staging/recording, unavailable-command rejection while a task is running, hidden popup cases for `/ test` and unmatched prefixes, Esc dismissal, and the running-task interrupt suppression guard while a popup is active;
- keep slash popup evidence deterministic, typed, Haxe-authored, haxe.rust-compiled, and independent of command execution, live input loops, ratatui/crossterm mutation, model/tool calls, and Cafex behavior.

Status: HXCX-TUI-30 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/slash_command.rs:12`, `../codex/codex-rs/tui/src/slash_command.rs:80`, `../codex/codex-rs/tui/src/slash_command.rs:82`, `../codex/codex-rs/tui/src/slash_command.rs:154`, `../codex/codex-rs/tui/src/slash_command.rs:186`, `../codex/codex-rs/tui/src/slash_command.rs:253`, `../codex/codex-rs/tui/src/bottom_pane/slash_commands.rs:61`, `../codex/codex-rs/tui/src/bottom_pane/slash_commands.rs:72`, `../codex/codex-rs/tui/src/bottom_pane/slash_commands.rs:88`, `../codex/codex-rs/tui/src/bottom_pane/slash_commands.rs:124`, `../codex/codex-rs/tui/src/bottom_pane/slash_commands.rs:145`, `../codex/codex-rs/tui/src/bottom_pane/command_popup.rs:20`, `../codex/codex-rs/tui/src/bottom_pane/command_popup.rs:29`, `../codex/codex-rs/tui/src/bottom_pane/command_popup.rs:36`, `../codex/codex-rs/tui/src/bottom_pane/command_popup.rs:43`, `../codex/codex-rs/tui/src/bottom_pane/command_popup.rs:73`, `../codex/codex-rs/tui/src/bottom_pane/command_popup.rs:95`, `../codex/codex-rs/tui/src/bottom_pane/command_popup.rs:131`, `../codex/codex-rs/tui/src/bottom_pane/command_popup.rs:148`, `../codex/codex-rs/tui/src/bottom_pane/command_popup.rs:227`, `../codex/codex-rs/tui/src/bottom_pane/command_popup.rs:234`, `../codex/codex-rs/tui/src/bottom_pane/command_popup.rs:241`, `../codex/codex-rs/tui/src/bottom_pane/command_popup.rs:267`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/popup_state.rs:10`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/popup_state.rs:25`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/slash_input.rs:168`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/slash_input.rs:171`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/slash_input.rs:210`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/slash_input.rs:218`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/slash_input.rs:256`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/slash_input.rs:270`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/slash_input.rs:316`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/slash_input.rs:535`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:3483`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:3522`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:3578`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:3592`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:3611`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:3623`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:628`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:633`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:637`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:10568`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:10600`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:10646`, and `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:10671`. This is slash-command popup lifecycle evidence only, not live command execution, live terminal backend mutation, ratatui rendering, live keyboard loops, model/tool execution, or Cafex behavior.

### HXCX-TUI-31: Headless Raw Codex TUI File And Mention Popup Lifecycle Facade

Extend slash-command popup evidence into the upstream composer file-search and mention popup path:

- model `@` token detection, file-search query start/clear, file popup activation, result acceptance/stale-result refusal, max-row truncation, selection movement, file insertion, and Esc dismissal with dismissed-token storage;
- preserve slash-popup precedence when a command argument contains an editable `@token`;
- model mentions-v2 activation, mixed file/directory/skill/plugin/tool candidate summaries, search-mode switching, selected tool/mention insertion, binding storage, and dismissed mention tokens;
- keep the evidence deterministic, typed, Haxe-authored, haxe.rust-compiled, and independent of filesystem scanning, live terminal backend mutation, ratatui rendering, live input loops, model/tool execution, and Cafex behavior.

Status: HXCX-TUI-31 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/bottom_pane/file_search_popup.rs:17`, `../codex/codex-rs/tui/src/bottom_pane/file_search_popup.rs:31`, `../codex/codex-rs/tui/src/bottom_pane/file_search_popup.rs:37`, `../codex/codex-rs/tui/src/bottom_pane/file_search_popup.rs:49`, `../codex/codex-rs/tui/src/bottom_pane/file_search_popup.rs:65`, `../codex/codex-rs/tui/src/bottom_pane/file_search_popup.rs:73`, `../codex/codex-rs/tui/src/bottom_pane/file_search_popup.rs:81`, `../codex/codex-rs/tui/src/bottom_pane/file_search_popup.rs:88`, `../codex/codex-rs/tui/src/bottom_pane/file_search_popup.rs:94`, `../codex/codex-rs/tui/src/bottom_pane/file_search_popup.rs:108`, `../codex/codex-rs/tui/src/file_search.rs:4`, `../codex/codex-rs/tui/src/file_search.rs:16`, `../codex/codex-rs/tui/src/file_search.rs:53`, `../codex/codex-rs/tui/src/file_search.rs:62`, `../codex/codex-rs/tui/src/file_search.rs:83`, `../codex/codex-rs/tui/src/file_search.rs:109`, `../codex/codex-rs/tui/src/file_search.rs:120`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/popup_state.rs:10`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/popup_state.rs:25`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/popup_state.rs:29`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/popup_state.rs:31`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:1652`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:1785`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:1816`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:1958`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:1966`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:2027`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:2056`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:2382`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:3483`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:3522`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:3601`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:3631`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:3695`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:4123`, and `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:4150`. Mentions-v2 anchors include `../codex/codex-rs/tui/src/bottom_pane/mentions_v2/mod.rs:9`, `../codex/codex-rs/tui/src/bottom_pane/mentions_v2/candidate.rs:20`, `../codex/codex-rs/tui/src/bottom_pane/mentions_v2/filter.rs:63`, `../codex/codex-rs/tui/src/bottom_pane/mentions_v2/search_catalog.rs:40`, and `../codex/codex-rs/tui/src/bottom_pane/mentions_v2/search_mode.rs:27`. This is file/mention popup lifecycle evidence only, not live filesystem scanning, live terminal backend mutation, ratatui rendering, live keyboard loops, model/tool execution, or Cafex behavior.

### HXCX-TUI-32: Headless Raw Codex TUI Composer History Search Lifecycle Facade

Extend file/mention popup evidence into the upstream composer Ctrl+R history-search path:

- model opening reverse search without previewing the latest entry, snapshot/restore of the original draft, paste-burst flush before snapshot, popup/file-search suppression, and footer history-search mode;
- preserve query editing, `Found`/`Pending`/`AtBoundary`/`NotFound` result statuses, preview application, highlighted ranges, accept-on-Enter, and Esc/Ctrl+C cancellation;
- model persistent history lookup request/response intent without live log reads, plus remapped history-search keys without falling back to Ctrl+R;
- keep the evidence deterministic, typed, Haxe-authored, haxe.rust-compiled, and independent of live terminal backend mutation, ratatui rendering, live input loops, filesystem/log lookup execution, model/tool execution, and Cafex behavior.

Status: HXCX-TUI-32 extends `fixtures/hxrust/tui-smoke.v1.json`, `fixtures/hxrust/tui-smoke.snapshot.txt`, and `harness/check-tui-smoke.sh`. Upstream anchors are `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs:51`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs:70`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs:89`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs:104`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs:134`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs:233`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs:259`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs:294`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs:311`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs:350`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs:381`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs:445`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer_history.rs:148`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer_history.rs:162`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer_history.rs:343`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer_history.rs:412`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer_history.rs:515`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer_history.rs:593`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer_history.rs:623`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer_history.rs:648`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer_history.rs:714`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer_history.rs:754`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer_history.rs:815`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:804`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:847`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:1642`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:1646`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:3485`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:3508`, `../codex/codex-rs/tui/src/bottom_pane/mod.rs:693`, and `../codex/codex-rs/tui/src/bottom_pane/mod.rs:1960`. Test anchors include `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs:505`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs:541`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs:605`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs:721`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs:777`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs:805`, `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs:845`, and `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs:8493`. This is composer history-search lifecycle evidence only, not live persistent log reads, live terminal backend mutation, ratatui rendering, live keyboard loops, model/tool execution, or Cafex behavior.

### HXCX-4.10: Turn Runtime State Reducers

Lift the selected `ChatWidget` turn lifecycle into pure Haxe state:

- task start/complete;
- assistant text deltas and final message source rules;
- plan delta/final plan item relationship;
- queued follow-up/steer bookkeeping;
- terminal turn status after failure/cancel.

This should stay portable-first unless haxe.rust exposes a concrete performance/codegen reason to split out a metal reducer.

Status: HXCX-4.10 now owns `fixtures/upstream/turn-runtime-selected.v1.json` and validates the reducer through `harness/check-turn-runtime-reducer.sh`. This is pure reducer parity, not live terminal/app-server ownership. The slice exposed generic haxe.rust issue `haxe.rust-fzl` for reused non-copy local strings across conditional expression results; codexhx keeps only a semantic Haxe copy workaround while the compiler fix belongs upstream.

### HXCX-4.11: App-Server Bootstrap And Initialize Handshake

Admit `initialize` in the right place:

- client info and capabilities;
- opt-out notification methods;
- platform/codex-home response fields;
- remote vs in-process bootstrap mode;
- config warnings and startup account/model metadata.

This was intentionally not admitted as a normal request in HXCX-3.74 because it belongs to transport/bootstrap parity.

Status: HXCX-4.11 now owns `fixtures/hxrust/runtime-bootstrap.v1.json` and validates it through `harness/check-runtime-bootstrap.sh`. Remote mode emits the `initialize` request and `initialized` notification; in-process mode carries the same typed startup params without transport JSON. The generic app request parser still rejects `initialize`.

### HXCX-4.12: Live Transport Spike

Add a narrow transport proof:

- in-process-style fixture transport first;
- remote/websocket/control-socket boundary as a metal/native wrapper;
- graceful disconnect and request cancellation semantics;
- no real credentials required.

This slice should decide whether the next implementation step is more app-server runtime or terminal UI.

Status: HXCX-4.12 now owns `fixtures/hxrust/runtime-transport.v1.json` and validates it through `harness/check-runtime-transport.sh`. This is a credential-free fixture transport over the runtime facade, not real socket ownership. Remote websocket/control-socket behavior remains a generic metal/native wrapper boundary.

### HXCX-4.13: Persistent App-Server/TUI State Boundary

Define the persistence split before claiming production state parity:

- portable Haxe owns credential-free thread/session/rollout metadata validation;
- native Rust owns `StateDbHandle`, `LogDbLayer`, SQLite/sqlx runtime ownership, rollout reconciliation, live thread persistence, file locking, migrations, repair, and cross-process coordination;
- JSONL fixture evidence remains metadata proof only, not a production persistence substitute.

Status: HXCX-4.13 now owns `fixtures/hxrust/persistence-boundary.v1.json` and validates the boundary through `harness/check-persistence-boundary.sh`.

### HXCX-4.14: Native SQLite Persistence Pressure

Exercise the first real native persistence operation without claiming full production state parity:

- use a typed metal Haxe facade over `sys.db.Sqlite`/`rusqlite`;
- reconcile selected thread metadata into an in-memory SQLite table;
- keep mutation intent explicit and fail closed for invalid metadata;
- treat any haxe.rust compiler/runtime limitation as product-neutral haxe.rust work.

Status: HXCX-4.14 now owns `fixtures/hxrust/native-sqlite-persistence.v1.json` and validates the slice through `harness/check-native-sqlite-persistence.sh`. It exposed and upstreamed three generic haxe.rust std metal-clean fixes: `haxe.ds.List.iterator`, `sys.io.File`, and `sys.io.FileInput`/`FileOutput`.

### HXCX-4.15: Native SQLite State Adapter

Extend the native persistence pressure proof into the first selected adapter shape:

- use typed Haxe commands for reconcile and query operations;
- keep mutation intent explicit for writes and fail closed when disabled;
- query by thread id and optionally filter archived rows;
- keep invalid thread IDs and missing rows as typed outcomes;
- treat enum/class-payload codegen pressure as generic haxe.rust work.

Status: HXCX-4.15 now owns `fixtures/hxrust/native-state-adapter.v1.json` and validates the slice through `harness/check-native-state-adapter.sh`. It exposed and upstreamed generic haxe.rust issue `haxe.rust-x89k`: enum payload equality over `HxRef<T>` class handles now uses reference-identity `PartialEq`/`Eq` in haxe.rust `4772d6ea`.

### HXCX-4.16: Persisted Thread Read View

Project selected persisted thread metadata into an upstream-shaped read-view layer:

- feed typed read requests from the native state adapter report;
- validate `ThreadId` before lookup;
- distinguish metadata-only reads from include-turns history summaries;
- fail closed for missing, archived-filtered, and invalid requests;
- keep real rollout files, live `ThreadState`, and API-turn reconstruction out of scope.

Status: HXCX-4.16 now owns `fixtures/hxrust/persisted-thread-read-view.v1.json` and validates the slice through `harness/check-persisted-thread-read-view.sh`. No new haxe.rust limitation was exposed; the generated Rust gate passed with typed DTOs, nullable outcomes, adapter-report scanning, and zero raw Rust escapes.

### HXCX-4.17: Thread/Read Turn Projection

Project selected upstream rollout/history item summaries into typed turn summaries:

- explicit `turn_started`/`turn_complete` boundaries;
- legacy implicit turn grouping from user messages;
- user, assistant, command execution, and compaction item summaries;
- failed active-turn status from selected error items;
- deterministic malformed-item refusal.

Status: HXCX-4.17 now owns `fixtures/hxrust/thread-read-turn-projection.v1.json` and validates the slice through `harness/check-thread-read-turn-projection.sh`. No new haxe.rust limitation was exposed; the generated Rust gate passed with typed DTOs, enum abstracts, arrays, and zero raw Rust escapes. This is projection evidence only, not full rollout parsing, pagination, live `ThreadState` merge, or production state-file ownership.

### HXCX-4.18: Thread/Read Turns Page

Page selected reconstructed turns through upstream-shaped `thread/turns/list` rules:

- opaque cursor JSON with `turnId` and `includeAnchor`;
- upstream limit clamping and default page sizing;
- descending and ascending page direction;
- backwards cursor anchors for reverse paging;
- `notLoaded`, `summary`, and `full` item views;
- malformed and missing-anchor cursor refusal.

Status: HXCX-4.18 now owns `fixtures/hxrust/thread-read-turns-page.v1.json` and validates the slice through `harness/check-thread-read-turns-page.sh`. No new haxe.rust limitation was exposed; malformed cursor parsing is handled as a typed app boundary failure. This is `thread/turns/list` page evidence only, not `thread/turns/items/list` runtime support, full rollout storage, active-turn merge, or production state ownership.

### HXCX-4.19: Thread/Read Active-Turn Merge

Model the selected active-turn merge and status normalization behavior around reconstructed turns:

- `idle`/`notLoaded` loaded statuses become `active` when an in-progress live turn exists;
- stale reconstructed `inProgress` turns are interrupted when the resolved thread status is not active;
- active-turn snapshots replace matching history turns and append otherwise;
- missing active snapshots remain valid;
- invalid loaded status values fail closed.

Status: HXCX-4.19 now owns `fixtures/hxrust/thread-read-active-turn-merge.v1.json` and validates the slice through `harness/check-thread-read-active-turn-merge.sh`. No new haxe.rust limitation was exposed. This is pure state evidence only, not live `ThreadState` ownership, watch-manager integration, rollout storage, or production state ownership.

### HXCX-4.20: Thread/Turns Items List Unsupported Runtime Boundary

Record the selected `thread/turns/items/list` runtime contract before implementing item pagination:

- upstream protocol DTOs exist for params and response pages;
- the current app-server processor returns method-not-found with `thread/turns/items/list is not supported yet`;
- codexhx validates selected params first, then returns the same unsupported outcome for valid requests.

Status: HXCX-4.20 now owns `fixtures/hxrust/thread-read-turn-items-list-runtime.v1.json` and validates the boundary through `harness/check-thread-read-turn-items-list.sh`. No new haxe.rust limitation was exposed. This is unsupported-runtime evidence only, not item pagination, rollout storage, or production state ownership.

### HXCX-4.21: Token Usage Turn Owner Attribution

Model the selected restored token-usage attribution rules around reconstructed turns:

- explicit active-turn owner id from the rollout wins when it still appears in rebuilt turns;
- rebuilt turn position is the fallback when generated or implicit turn ids changed during reconstruction;
- missing rollout owner information falls back to the latest completed or failed turn, then the latest turn;
- empty reconstructed histories fail closed before an unusable owner id is emitted.

Status: HXCX-4.21 now owns `fixtures/hxrust/thread-read-token-usage-owner.v1.json` and validates the slice through `harness/check-thread-read-token-usage-owner.sh`. No new haxe.rust limitation was exposed. This is attribution evidence only, not token accounting, notification emission, rollout file parsing, or production state ownership.

### HXCX-4.22: Token Usage Replay Payload

Model the selected restored `thread/tokenUsage/updated` payload construction:

- valid thread id plus resolved owner turn creates a typed replay notification;
- total and last usage breakdowns preserve upstream camelCase token counter fields;
- nullable `modelContextWindow` is carried as a numeric value or JSON null;
- missing usage, unresolved owners, invalid thread ids, and negative counters fail closed.

Status: HXCX-4.22 now owns `fixtures/hxrust/thread-read-token-usage-replay.v1.json` and validates the slice through `harness/check-thread-read-token-usage-replay.sh`. No new haxe.rust limitation was exposed. This is payload construction evidence only, not live connection delivery, usage aggregation, rollout parsing, or production state ownership.

### HXCX-4.23: Token Usage Replay Delivery Policy

Model the selected restored usage delivery policy:

- include-turns responses may deliver restored token usage after the JSON-RPC response;
- exclude-turns cheap resume/fork paths skip restored usage replay;
- missing payloads skip notification delivery rather than emitting malformed usage;
- delivery is connection-scoped and never broadcast to other subscribers.

Status: HXCX-4.23 now owns `fixtures/hxrust/thread-read-token-usage-replay-delivery.v1.json` and validates the slice through `harness/check-thread-read-token-usage-replay-delivery.sh`. It exposed generic haxe.rust issue `haxe.rust-3f0g` for same-class `static final` String access path lowering; codexhx uses a helper-function workaround while the compiler fix belongs upstream. This is delivery-policy evidence only, not socket ownership, JSON-RPC transport, usage aggregation, rollout parsing, or production state ownership.

### HXCX-4.24: Resume Goal Snapshot Ordering

Model the selected goal snapshot ordering around resume after token-usage replay:

- `emit_resume_goal_snapshot_and_continue` waits until response and token-usage replay ordering are complete;
- `send_thread_goal_snapshot_notification` emits `thread/goal/updated` for stored goals and `thread/goal/cleared` for absent goals;
- loaded running-thread resume replays pending requests after the goal snapshot;
- active goals allow idle lifecycle continuation, while paused/terminal goals remain snapshot-only;
- fork keeps the token-usage replay path but has no resume-goal snapshot.

Status: HXCX-4.24 now owns `fixtures/hxrust/thread-read-resume-goal-snapshot.v1.json` and validates the slice through `harness/check-thread-read-resume-goal-snapshot.sh`. No new haxe.rust limitation was exposed. This is resume-goal ordering evidence only, not production state DB access, listener command ownership, extension execution, JSON-RPC transport, or Cafex behavior.

### HXCX-4.25: Resume Idle Lifecycle Continuation

Model the selected idle lifecycle continuation path after ordered resume goal snapshots:

- core `emit_thread_idle_lifecycle_if_idle` fires only when no active turn and no trigger-turn mailbox work exist;
- loaded running-thread resume replays pending requests before the idle hook;
- the goal extension sees the idle hook and calls `continue_if_idle`;
- active goals can request `try_start_turn_if_idle`, while paused, blocked, usage-limited, budget-limited, complete, and cleared goals are snapshot-only;
- unavailable thread manager/live thread and host rejection are deterministic continuation skips.

Status: HXCX-4.25 now owns `fixtures/hxrust/thread-read-resume-idle-continuation.v1.json` and validates the slice through `harness/check-thread-read-resume-idle-continuation.sh`. No new haxe.rust limitation was exposed. This is idle-continuation decision evidence only, not production task spawning, extension store ownership, live state DB access, JSON-RPC transport, or Cafex behavior.

### HXCX-4.26: Goal Continuation Steering Item

Model the selected contextual user fragment submitted by goal runtime:

- `continuation_steering_item` renders active-goal continuation context with escaped objective and budget fields;
- `objective_updated_steering_item` renders active objective-change context with the updated objective tag;
- emitted items use source `goal` and contextual user fragment shape;
- non-active, cleared, unchanged, and unsettled continuation states fail or skip deterministically;
- the slice composes with HXCX-4.25 so accepted and host-rejected continuation requests still have item evidence.

Status: HXCX-4.26 now owns `fixtures/hxrust/thread-read-goal-steering.v1.json` and validates the slice through `harness/check-thread-read-goal-steering.sh`. No new haxe.rust limitation was exposed. This is steering-item evidence only, not live turn start, active-turn injection, full template-engine ownership, JSON-RPC transport, or Cafex behavior.

### HXCX-4.27: Try Start Turn If Idle Admission

Model the selected host admission behavior behind goal continuation:

- empty input returns Ok without reserving a turn;
- pending trigger-turn mailbox and Plan mode reject before reservation;
- active regular turns and active Review turns reject as busy while preserving the original input;
- pending trigger-turn, Plan mode, and lost reservation rechecks clear reservations before rejecting;
- accepted automatic work injects the steering item as pending input and starts a regular task.

Status: HXCX-4.27 now owns `fixtures/hxrust/thread-read-try-start-turn-if-idle.v1.json` and validates the slice through `harness/check-thread-read-try-start-turn-if-idle.sh`. No new haxe.rust limitation was exposed. This is host-admission evidence only, not live `Session`, `InputQueue`, async task spawning, JSON-RPC transport, or Cafex behavior.

### HXCX-4.28: Goal Runtime Restore After Resume

Model the selected goal runtime restore path after thread resume:

- `GoalExtension::on_thread_resume` skips when the thread store has no runtime;
- disabled runtime returns Ok without reading stored goal state;
- active stored goals rehydrate idle accounting and record the resumed metric;
- missing or non-active stored goals clear active-goal accounting;
- state-read failure stays a restore error and preserves existing accounting.

Status: HXCX-4.28 now owns `fixtures/hxrust/thread-read-goal-runtime-restore.v1.json` and validates the slice through `harness/check-thread-read-goal-runtime-restore.sh`. No new haxe.rust limitation was exposed. This is restore-accounting evidence only, not live state DB ownership, metrics-client ownership, async scheduling, goal notifications, continuation turns, or Cafex behavior.

### HXCX-4.29: Active-Turn Goal Steering Injection

Model the selected goal steering injection path for a running turn:

- objective-updated steering composes with the HXCX-4.26 contextual-user-fragment builder;
- missing thread manager and missing live thread skip without injection;
- `CodexThread::inject_if_running` returns the original item unchanged when no active turn is running;
- active turns extend pending input with the unchanged steering item;
- unavailable steering items fail closed before host lookup.

Status: HXCX-4.29 now owns `fixtures/hxrust/thread-read-active-turn-goal-steering-injection.v1.json` and validates the slice through `harness/check-thread-read-active-turn-goal-steering-injection.sh`. No new haxe.rust limitation was exposed. This is active-turn injection evidence only, not live `ThreadManager`, `CodexThread`, `Session`, active-turn locks, async scheduling, or Cafex behavior.

### HXCX-4.30: Budget-Limit Goal Steering

Model the selected budget-limit steering path after tool-finish progress accounting:

- active-goal progress with `BudgetLimitedGoalDisposition::KeepActive` may return a budget-limited goal;
- non-budget and missing progress skip before steering;
- duplicate budget-limit reports skip through `mark_budget_limit_reported_if_new`;
- budget-limited progress emits a `budget_limit` contextual user fragment;
- active-turn unavailable behavior composes with HXCX-4.29 injection.

Status: HXCX-4.30 now owns `fixtures/hxrust/thread-read-budget-limit-goal-steering.v1.json` and validates the slice through `harness/check-thread-read-budget-limit-goal-steering.sh`. No new haxe.rust limitation was exposed. This is budget-limit steering evidence only, not live tool lifecycle ownership, token accounting storage, production state DB ownership, event emission, active-turn locks, async scheduling, or Cafex behavior.

### HXCX-4.31: Active Goal Progress Accounting

Model the selected upstream active-goal progress accounting path:

- `progress_snapshot(turn_id)` absence returns none before state DB accounting;
- `account_thread_goal_usage` updated, unchanged, and error outcomes are explicit;
- updated goals mark turn token usage and wall-clock deltas as accounted;
- `BudgetLimitedGoalDisposition::KeepActive` preserves budget-limited active accounting while `ClearActive` clears it;
- updated progress emits selected `thread_goal_updated` evidence.

Status: HXCX-4.31 now owns `fixtures/hxrust/thread-read-active-goal-progress-accounting.v1.json` and validates the slice through `harness/check-thread-read-active-goal-progress-accounting.sh`. No new haxe.rust limitation was exposed. This is accounting-state evidence only, not async permit ownership, production state DB ownership, metrics/analytics clients, event emitter ownership, live token aggregation, wall-clock sources, tool lifecycle ownership, or Cafex behavior.

### HXCX-4.32: Idle Goal Progress Accounting

Model the selected upstream idle-goal progress accounting path:

- `idle_progress_snapshot()` absence returns none before state DB accounting;
- `account_thread_goal_usage` uses `token_delta` 0 for idle progress;
- updated goals mark idle wall-clock progress and emit `thread_goal_updated` with no turn id;
- `GoalAccountingOutcome::Unchanged` resets the idle baseline and clears active-goal/budget-limit marker state;
- `BudgetLimitedGoalDisposition::KeepActive` preserves budget-limited active accounting while `ClearActive` clears it.

Status: HXCX-4.32 now owns `fixtures/hxrust/thread-read-idle-goal-progress-accounting.v1.json` and validates the slice through `harness/check-thread-read-idle-goal-progress-accounting.sh`. No new haxe.rust limitation was exposed. This is idle accounting-state evidence only, not async permit ownership, production state DB ownership, metrics/analytics clients, event emitter ownership, live wall-clock sources, idle lifecycle scheduling, continuation turn spawning, or Cafex behavior.

### HXCX-4.33: Turn-Start Goal Accounting

Model the selected upstream turn-start goal accounting setup path:

- runtime-missing and disabled-runtime guards skip before accounting setup;
- `GoalAccountingState::start_turn` records the current turn and token-accounting eligibility;
- Plan mode calls `clear_current_turn_goal` and returns before stored-goal lookup;
- active and budget-limited stored goals call `mark_turn_goal_active`;
- missing, non-active, and state-error lookup paths skip deterministically.

Status: HXCX-4.33 now owns `fixtures/hxrust/thread-read-turn-start-goal-accounting.v1.json` and validates the slice through `harness/check-thread-read-turn-start-goal-accounting.sh`. No new haxe.rust limitation was exposed. This is turn-start accounting setup evidence only, not full turn lifecycle ownership, token usage aggregation, turn stop/abort/error hooks, production state DB ownership, live turn start, steering injection, or Cafex behavior.

### HXCX-4.34: Turn Stop/Abort Goal Finalization

Model the selected upstream turn-stop and turn-abort goal finalization path:

- runtime-missing and disabled-runtime guards skip before active-goal progress accounting;
- turn stop uses `:turn-stop`; turn abort uses `:turn-abort`;
- both hooks call active-goal progress accounting with `ActiveOnly` and `BudgetLimitedGoalDisposition::ClearActive`;
- accounting errors warn and return before `finish_turn`;
- successful accounting, including no progress, calls `finish_turn`.

Status: HXCX-4.34 now owns `fixtures/hxrust/thread-read-turn-goal-finalization.v1.json` and validates the slice through `harness/check-thread-read-turn-goal-finalization.sh`. No new haxe.rust limitation was exposed. This is turn finalization evidence only, not turn error goal stopping, full active-goal accounting internals, token usage aggregation, production state DB ownership, metrics/analytics/event emitters, live turn start, steering injection, or Cafex behavior.

### HXCX-4.35: Turn-Error Active Goal Stop

Model the selected upstream turn-error active-goal stop path:

- `CodexErrorInfo::UsageLimitExceeded` maps to `ActiveGoalStopReason::UsageLimit`;
- other terminal turn errors map to `ActiveGoalStopReason::TurnError`;
- `stop_active_goal_for_turn` holds the goal-state permit through accounting and status update;
- non-current active turns no-op before progress accounting;
- active-goal progress accounting uses `ActiveOnly` and `BudgetLimitedGoalDisposition::ClearActive`;
- usage-limit stops can move budget-limited goals to `UsageLimited`, while generic turn errors move active goals to `Blocked`.

Status: HXCX-4.35 now owns `fixtures/hxrust/thread-read-turn-error-active-goal-stop.v1.json` and validates the slice through `harness/check-thread-read-turn-error-active-goal-stop.sh`. No new haxe.rust limitation was exposed. This is turn-error stop evidence only, not live async lock ownership, full active-goal accounting internals, token usage aggregation, production state DB ownership, metrics/analytics/event emitters, full error taxonomy, live turn start, steering injection, or Cafex behavior.

### HXCX-4.36: Goal Token Usage Contribution

Model the selected upstream token-usage contribution path:

- `TokenUsageContributor::on_token_usage` uses `turn_store.level_id()` as the accounting owner;
- runtime-missing and disabled-runtime guards skip before accounting mutation;
- `GoalAccountingState::record_token_usage` skips unknown turns;
- known turns update `current_token_usage` before token-accounting and delta guards;
- token-accounting-disabled turns return `None` after updating current usage;
- goal token delta is non-cached input plus output tokens;
- repeated token-usage notifications keep charging against `last_accounted_token_usage` until progress accounting marks the baseline accounted.

Status: HXCX-4.36 now owns `fixtures/hxrust/thread-read-goal-token-usage-record.v1.json` and validates the slice through `harness/check-thread-read-goal-token-usage-record.sh`. No new haxe.rust limitation was exposed. This is token-usage accounting-state evidence only, not live token aggregation, analytics emission, production state DB writes, active-goal progress persistence, metrics clients, model/provider behavior, or Cafex behavior.

### HXCX-4.37: Tool-Finish Goal Progress Admission

Model the selected upstream tool-finish admission path:

- runtime-missing and disabled-runtime guards skip before accounting;
- completed tool calls count regardless of the output success marker;
- failed tool calls count only when the handler executed;
- blocked, aborted, and pre-handler failed tool calls skip;
- bare `update_goal` is excluded while namespaced `update_goal` can count;
- admitted calls use `call_id` as the accounting event id with `ActiveOnly` and `BudgetLimitedGoalDisposition::KeepActive`;
- accounting errors warn, `Ok(None)` returns, and budget-limited progress hands off to the existing steering boundary.

Status: HXCX-4.37 now owns `fixtures/hxrust/thread-read-tool-finish-goal-progress-admission.v1.json` and validates the slice through `harness/check-thread-read-tool-finish-goal-progress-admission.sh`. No new haxe.rust limitation was exposed. This is tool-finish admission evidence only, not live tool execution, production state DB writes, event emitters, active-turn injection, model/provider behavior, or Cafex behavior.

### HXCX-4.38: Goal Tool Contributor Visibility

Model the selected upstream goal tool contribution path:

- missing runtime handles return no contributed tools;
- `runtime.tools_visible()` is `is_enabled() && tools_available_for_thread`;
- disabled runtimes and tools-unavailable threads return an empty vector;
- visible runtimes contribute `GoalToolExecutor::get`, `GoalToolExecutor::create`, and `GoalToolExecutor::update` in upstream order;
- descriptors retain the thread id plus state DB, accounting, analytics, event-emitter, and metrics boundaries.

Status: HXCX-4.38 now owns `fixtures/hxrust/thread-read-goal-tool-contributor-visibility.v1.json` and validates the slice through `harness/check-thread-read-goal-tool-contributor-visibility.sh`. No new haxe.rust limitation was exposed. This is goal tool registration visibility evidence only, not live tool execution, production state mutation, analytics/events emission, model/provider behavior, or Cafex behavior.

### HXCX-4.39: Get Goal Tool Executor

Model the selected upstream read-only `get_goal` executor path:

- function arguments are accepted before state access;
- `get_thread_goal(self.thread_id)` reads the current thread goal;
- missing goals return a structured null-goal response;
- found goals map through `protocol_goal_from_state`;
- remaining tokens use `max(token_budget - tokens_used, 0)`;
- `CompletionBudgetReport::Omit` suppresses completion-budget text even for completed goals;
- state read errors become `FunctionCallError::RespondToModel`.

Status: HXCX-4.39 now owns `fixtures/hxrust/thread-read-get-goal-tool.v1.json` and validates the slice through `harness/check-thread-read-get-goal-tool.sh`. No new haxe.rust limitation was exposed. This is read-only `get_goal` executor evidence only, not create/update tool execution, production state mutation, analytics/events emission, model/provider behavior, or Cafex behavior.

### HXCX-4.40: Create Goal Tool Executor

Model the selected upstream `create_goal` executor path:

- parse function arguments into objective and optional token budget;
- trim the objective before validation;
- reject empty objectives and non-positive token budgets before insert;
- insert an active goal or return an unfinished-goal/state-error model-visible failure;
- attempt empty-thread-preview fill and preserve warnings without failing the tool;
- mark the current turn goal active, record metrics/analytics, and emit the goal-updated event boundary;
- return `goal_response` with `CompletionBudgetReport::Omit`.

Status: HXCX-4.40 now owns `fixtures/hxrust/thread-read-create-goal-tool.v1.json` and validates the slice through `harness/check-thread-read-create-goal-tool.sh`. No new haxe.rust limitation was exposed. This is selected `create_goal` executor evidence only, not production SQLite/log state ownership, real async lock ownership, full analytics/event implementation, model/provider behavior, update_goal behavior, or Cafex behavior.

### HXCX-4.41: Update Goal Tool Executor

Model the selected upstream `update_goal` executor path:

- parse status arguments and accept only `complete` or `blocked`;
- account active-goal progress with `ActiveOrComplete` for complete and `ActiveOrStopped` for blocked;
- use the call id as accounting event id with `ClearActive` disposition;
- read previous status for terminal metrics before update;
- update only goal status, preserving no-goal/update-error model-visible failures;
- record terminal metrics and analytics status changes;
- clear current-turn goal and emit a goal-updated event using the call id;
- include completion-budget report only for complete responses with budget or elapsed-time evidence.

Status: HXCX-4.41 now owns `fixtures/hxrust/thread-read-update-goal-tool.v1.json` and validates the slice through `harness/check-thread-read-update-goal-tool.sh`. No new haxe.rust limitation was exposed. This is selected `update_goal` executor evidence only, not production SQLite/log state ownership, real async lock ownership, full analytics/event implementation, model/provider behavior, create_goal behavior, or Cafex behavior.

### HXCX-4.42: Goal Tool Executor Dispatch

Model the selected upstream `GoalToolExecutor` trio surface:

- constructors select `GoalToolKind::Get`, `Create`, or `Update`;
- `tool_name` and `spec` expose the matching `get_goal`, `create_goal`, or `update_goal` function tool;
- `handle` dispatches to the already-modeled get/create/update executor behavior;
- all three tools preserve the shared structured response fields;
- create/update success paths emit goal-updated events while get and error paths do not;
- complete responses include the completion-budget report when budget/time evidence exists, while blocked/get/create responses omit it.

Status: HXCX-4.42 now owns `fixtures/hxrust/thread-read-goal-tool-dispatch.v1.json` and validates the slice through `harness/check-thread-read-goal-tool-dispatch.sh`. No new haxe.rust limitation was exposed. This is selected executor dispatch evidence only, not production SQLite/log state ownership, real async lock ownership, full analytics/event implementation, model/provider behavior, full runtime wiring, or Cafex behavior.

### HXCX-4.43: Provider Admission Boundary

Model the selected upstream provider and credential admission boundary before live model traffic:

- carry `ModelProviderInfo` auth metadata into typed Haxe provider DTOs;
- validate AWS/command auth shape conflicts before constructing runtime providers;
- tie model metadata to its provider id and fail mismatches before a turn can start;
- allow no-credential fixture providers only when OpenAI/provider-env auth is not required;
- refuse missing OpenAI auth and missing provider env-key evidence;
- bucket/redact credential-present cases without exposing tokens or configured env-key names;
- refuse live-network attempts in the credential-free fixture gate.

Status: HXCX-4.43 now owns `fixtures/hxrust/provider-admission.v1.json` and validates the slice through `harness/check-provider-admission.sh`. No new haxe.rust limitation was exposed. This is selected provider admission evidence only, not live provider traffic, real auth storage, token refresh, model catalog ownership, websocket/realtime behavior, or Cafex behavior.

### HXCX-4.44: Model Catalog And Provider Capabilities

Model the selected upstream model catalog and provider capability boundary after provider admission:

- compose with provider admission before returning catalog results;
- represent selected `ModelInfo` and app-visible `ModelPreset` fields through typed Haxe DTOs;
- apply provider-scoped catalog filtering, auth-mode filtering, picker visibility, and default selection;
- preserve provider capability upper bounds for namespace tools, hosted image generation, and hosted web search;
- represent Bedrock as a static catalog with hosted web/image disabled and default service-tier behavior;
- refuse live `/models` refresh attempts in credential-free fixture gates.

Status: HXCX-4.44 now owns `fixtures/hxrust/model-catalog.v1.json` and validates the slice through `harness/check-model-catalog.sh`. It exposed generic haxe.rust issue `haxe.rust-fz20` for `Reflect.compare` lowering; codexhx uses direct typed comparison locally while the compiler fix belongs upstream. This is selected static catalog/capability evidence only, not live provider traffic, model cache/ETag ownership, websocket/realtime behavior, or Cafex behavior.

### HXCX-4.45: Turn Model Selection And Tool-Capability Planning

Model the selected upstream turn-context model selection and tool capability planning boundary:

- compose provider admission and model catalog selection before returning a plan;
- derive effective tool mode from selected model metadata plus feature fallback;
- gate hosted web search, standalone web run, hosted image generation, standalone image generation, namespace tools, code-mode nested tools, and deferred tool search;
- suppress hosted tools when Responses Lite or standalone namespace tools own the selected surface;
- refuse unsupported requested capabilities before live model/tool execution.

Status: HXCX-4.45 now owns `fixtures/hxrust/turn-model-plan.v1.json` and validates the slice through `harness/check-turn-model-plan.sh`. It exposed generic haxe.rust issue `haxe.rust-3oju` for optional primitive constructor default lowering; codexhx uses an explicit constructor argument while the compiler fix belongs upstream. This is selected deterministic planning evidence only, not live provider traffic, real tool execution, websocket/realtime behavior, or Cafex behavior.

### HXCX-4.46: Model Request Envelope And Response Routing

Model selected upstream `ModelClientSession::stream` request construction and route admission before live provider traffic:

- compose provider admission, model catalog selection, and turn tool planning;
- build typed Responses request envelope facts without carrying model-visible prompt text into summaries;
- preserve streamed request defaults, prompt cache key, client metadata, service-tier selection, text controls, reasoning include behavior, and Responses Lite parallel-tool-call suppression;
- refuse fixture-mode HTTP/WebSocket live routes before transport;
- refuse unsupported WebSocket route intent before connection setup.

Status: HXCX-4.46 now owns `fixtures/hxrust/model-request-envelope.v1.json` and validates the slice through `harness/check-model-request-envelope.sh`. No new haxe.rust limitation was exposed. This is selected request envelope/routing evidence only, not live HTTP/WebSocket transport, SSE stream mapping, unauthorized retry, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.47: Model Stream Event And Error Routing

Model selected upstream `map_response_stream` and `map_response_events` behavior after request-envelope admission, without live provider traffic:

- compose provider admission, model catalog selection, turn tool planning, and request-envelope routing before stream mapping;
- preserve upstream model request id and last model response id feedback fields;
- count completed output items and token totals on provider completion;
- route provider API errors, including request-id override from debug/error context;
- distinguish consumer-dropped cancellation from stream-close-before-completion failure;
- compose denied envelopes into stream refusals without attempting transport.

Status: HXCX-4.47 now owns `fixtures/hxrust/model-stream-route.v1.json` and validates the slice through `harness/check-model-stream-route.sh`. No new haxe.rust limitation was exposed. This is selected deterministic stream mapping evidence only, not live HTTP/WebSocket transport, SSE frame parsing, unauthorized retry, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.48: Stream Item Reducer And Assistant Output Routing

Reduce selected `stream_events_utils` and `ResponseEvent` handling into typed Haxe runtime items without live async ownership:

- map assistant output items, reasoning summaries/raw deltas, and text deltas into typed runtime events;
- classify function/custom tool calls separately from assistant text/reasoning items;
- compose with request-envelope and stream-route fixtures;
- remain deterministic and credential-free;
- avoid Tokio-bound Haxe APIs, `@:await` syntax, or live provider task ownership.

Status: HXCX-4.48 now owns `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is selected deterministic item reducer evidence only, not live HTTP/WebSocket transport, SSE frame parsing, tool execution, Tokio task ownership, unauthorized retry, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.49: Runtime-Neutral Async Stream Contract

Before live provider transport work, define the Haxe-facing async contract without binding app APIs directly to Tokio:

- model tasks, streams, poll/next outcomes, cancellation, and backpressure as typed Haxe abstractions;
- keep fixture runners deterministic and thread/network-free;
- map the same contract to Tokio only behind haxe.rust metal/native facades or generic haxe.rust runtime support;
- defer optional `@:await` or macro sugar until it lowers to the same backend-neutral contract.

Status: HXCX-4.49 now owns `fixtures/hxrust/async-runtime-contract.v1.json` and validates the slice through `harness/check-async-runtime-contract.sh`. The contract lives under `codexhx.runtime.asyncruntime` and is documented in `docs/async-runtime-contract.md`. This is backend-neutral contract evidence only, not live Tokio task ownership, HTTP/WebSocket transport, timers, tool execution, realtime/audio behavior, or Cafex behavior.

### HXCX-4.50: Stream Tool-Call Input Delta Routing

Continue the raw upstream stream reducer before live provider/TUI ownership:

- model active custom tool-call argument diff state from `session/turn.rs`;
- route accepted tool input deltas by active `callId`;
- record typed ignored outcomes when no custom diff consumer is active or the incoming `callId` mismatches;
- accumulate accepted custom tool input for final queued tool calls without executing them;
- keep function-call delta traffic fail-closed unless a future upstream reference proves a custom diff consumer is active for it.

Status: HXCX-4.50 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is selected deterministic argument-diff routing evidence only, not apply-patch hunk parsing, live HTTP/WebSocket transport, SSE frame parsing, tool execution, Tokio task ownership, unauthorized retry, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.51: Streamed Tool Argument Diff Consumer Events

Continue from call-id-routed input deltas into protocol-facing custom tool progress events:

- model the upstream `ToolArgumentDiffConsumer` surface without binding Haxe app APIs to Tokio;
- emit typed, deterministic `PatchApplyUpdated`-style events for apply-patch-shaped streamed custom tool input;
- flush pending/final diff updates when the tool call item completes;
- keep parser effects credential-free and deterministic until live tool execution is modeled separately;
- never execute tools or mutate the filesystem from this reducer path.

Status: HXCX-4.51 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is selected deterministic diff-consumer event evidence only, not full patch grammar verification, filesystem mutation, live HTTP/WebSocket transport, SSE frame parsing, tool execution, Tokio task ownership, unauthorized retry, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.52: Streamed Apply-Patch Grammar Parity

Replace fixture-scoped scanning with a stronger pure-Haxe streaming patch parser:

- model upstream add/delete/update/move/end-of-file hunks and update chunks with typed DTOs/enums;
- preserve complete-line streaming semantics and final-line/no-newline finish handling;
- fail malformed patch streams through reducer errors before any tool execution path;
- keep `PatchApplyUpdated` summaries protocol-shaped while leaving final workspace verification to later native/runtime work;
- never mutate the filesystem from this reducer path.

Status: HXCX-4.52 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic streaming parser and progress-event evidence only, not final patch verification against a workspace, filesystem mutation, live HTTP/WebSocket transport, SSE frame parsing, tool execution, Tokio task ownership, unauthorized retry, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.53: Apply-Patch Verification And Tool-Event Boundary

Model the upstream apply-patch verification and tool event boundary against fixture-only filesystem facts:

- keep the Haxe surface typed with verified patch intent, virtual file facts, begin/end events, and completed/failed/declined statuses;
- compose the request envelope, stream route, stream item reducer, streamed diff parser, and verification boundary in one fixture path;
- verify add/delete/update/move intent without live provider traffic, real filesystem mutation, or out-of-fixture tool execution;
- keep the boundary runtime-neutral and free of Tokio-bound Haxe APIs.

Status: HXCX-4.53 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic verification/tool-event evidence only, not native apply-patch process ownership, real workspace mutation, live HTTP/WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.54: Apply-Patch Fixture Application Result Boundary

Model the upstream apply-patch runtime result boundary against copied virtual workspace facts:

- keep completed, failed, and declined statuses typed and aligned with upstream `PatchApplyEndEvent`;
- carry stdout/stderr and before/after virtual workspace summaries without mutating the real filesystem;
- compose the request envelope, stream route, stream item reducer, streamed diff parser, verification boundary, and result boundary in one fixture path;
- keep shell/tool execution out of Haxe test fixtures and leave native process ownership to later runtime work.

Status: HXCX-4.54 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic virtual application-result evidence only, not native apply-patch process ownership, real workspace mutation, live HTTP/WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.55: Apply-Patch Approval And Sandbox Decision Boundary

Model the upstream apply-patch approval and sandbox decision boundary against deterministic fixture facts:

- derive approval keys from environment id and verified patch file paths;
- model approval requirement, permission preapproval, emitted approval requests, opaque review decisions, and permission request payload shape;
- model auto sandbox preference, escalation-on-failure, and sandbox retry intent without granting permissions or executing tools;
- keep the boundary runtime-neutral and credential-free.

Status: HXCX-4.55 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic approval/sandbox decision evidence only, not native approval UX, native apply-patch process ownership, real workspace mutation, live HTTP/WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.56: Apply-Patch Turn-Diff Tracker Boundary

Model the upstream apply-patch turn-diff tracker update boundary against deterministic fixture facts:

- distinguish known exact applied patch deltas, unknown deltas, exact empty deltas, and rejected/no-delta outcomes;
- model tracker update kinds for track, invalidate, and none;
- produce environment-scoped unified diff summaries when a visible turn diff would be emitted;
- keep the boundary fixture-only, with no real workspace reread or mutation.

Status: HXCX-4.56 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic turn-diff tracker evidence only, not native tracker persistence, real workspace rereads, native apply-patch process ownership, real workspace mutation, live HTTP/WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.57: File-Change And Turn-Diff Projection Boundary

Model the upstream file-change projection boundary before live TUI/app-server ownership:

- keep canonical `FileChangeItem` projection separate from optional legacy `PatchApplyBegin`/`PatchApplyEnd` projection;
- carry typed status, auto-approved begin facts, stdout/stderr visibility, and file-change summaries;
- model whether a `TurnDiffEvent` notification would be emitted from the tracker outcome;
- compose request envelope, stream route, stream item reducer, streamed diff parser, verification, application, approval/sandbox decision, tracker, and projection facts in one credential-free fixture path.

Status: HXCX-4.57 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic file-change and turn-diff projection evidence only, not native app-server fanout, interactive TUI rendering ownership, native apply-patch process ownership, real workspace mutation, live HTTP/WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.58: Apply-Patch Tool-Output Follow-Up Boundary

Model the upstream model-facing tool-output boundary after apply-patch projection:

- find the queued apply-patch tool call from the stream reducer output;
- project `CustomToolCallOutput` versus `FunctionCallOutput` response item shape;
- carry success status, post-tool-use response visibility, stdout/stderr visibility, and result text visibility;
- prove the model follow-up requirement without executing the tool, mutating the filesystem, or owning Tokio task runtime.

Status: HXCX-4.58 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic model-facing apply-patch tool-output and follow-up evidence only, not native tool future execution, native app-server fanout, interactive TUI rendering ownership, real workspace mutation, live HTTP/WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.59: Tool-Response Follow-Up Input Boundary

Model the upstream tool-response collection and next model input boundary after tool-output follow-up:

- drain the modeled in-flight tool result into a response input item without executing a native tool future;
- preserve custom/function tool output shape, call id, success/error result text, and response ordering;
- record that the response item is eligible for the next model request while keeping provider traffic disabled;
- compose request envelope, stream route, stream item reducer, streamed diff parser, verification, application, approval/sandbox decision, tracker, projection, and tool-output follow-up facts in one credential-free fixture path.

Status: HXCX-4.59 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic tool-response input admission and ordering evidence only, not native tool future execution, native app-server fanout, interactive TUI rendering ownership, real workspace mutation, live HTTP/WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.60: Follow-Up Sampling Continuation Boundary

Model the upstream post-sampling continuation branch after tool-response input admission:

- combine model follow-up and pending input into a single next-request decision;
- carry admitted response input items into the planned sampling input count;
- distinguish plain model continuation, model-plus-pending-input continuation, and token-limit compaction routing;
- preserve the upstream rule that token-limit compaction can defer pending-input drain when model/tool continuation must resume first.

Status: HXCX-4.60 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic follow-up sampling continuation evidence only, not live provider traffic, native tool future execution, native app-server fanout, interactive TUI rendering ownership, real workspace mutation, WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.61: Follow-Up Sampling Input Assembly Boundary

Model the upstream next prompt assembly branch after follow-up continuation:

- record drained pending input before request assembly when the continuation permits it;
- carry tool response outputs already recorded from in-flight tool drains;
- clone conversation history and apply `for_prompt` normalization for model modalities;
- preserve prompt item ordering across tool responses and pending user/response inputs without provider traffic.

Status: HXCX-4.61 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic next prompt input assembly evidence only, not live provider traffic, native tool future execution, native app-server fanout, interactive TUI rendering ownership, real workspace mutation, WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.62: Follow-Up Sampling Dispatch Boundary

Model the upstream follow-up dispatch branch after prompt input assembly:

- pass the assembled prompt through the turn-scoped `ModelClientSession`;
- carry window id, metadata-header presence, retry initialization, and child cancellation-token intent;
- preserve prompt item count and ordering facts from prompt assembly;
- prove the fixture disables provider traffic while still exercising the dispatch boundary shape.

Status: HXCX-4.62 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic follow-up sampling dispatch evidence only, not live provider traffic, native tool future execution, native app-server fanout, interactive TUI rendering ownership, real workspace mutation, WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.63: Stream Attempt Outcome Boundary

Model the upstream stream-attempt branch after follow-up dispatch:

- classify fixture stream-open success, retryable stream disconnects, unauthorized recovery, and terminal errors;
- carry retry counts and max-retry budget without sleeping or owning Tokio timers;
- prove context-window and usage-limit terminal routing facts;
- keep provider traffic disabled while preserving the shape of the stream attempt result.

Status: HXCX-4.63 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic stream-attempt outcome evidence only, not live provider traffic, native tool future execution, native app-server fanout, interactive TUI rendering ownership, real workspace mutation, WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.64: Stream Event Handoff Boundary

Model the upstream handoff after a stream attempt either retries before event consumption, terminates before event consumption, or enters the response-event loop:

- classify retry scheduling and unauthorized retry preparation before stream events are consumed;
- classify terminal attempt errors before stream events are consumed;
- classify stream-open success into completed end-turn versus completed follow-up;
- preserve `stream closed before response.completed` as a terminal event-loop error;
- carry in-flight tool drain, token-count deferral, and turn-diff deferral facts without owning Tokio futures;
- keep live provider traffic, auth refresh, real filesystem mutation, and Cafex behavior out of scope.

Status: HXCX-4.64 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic stream-event handoff evidence only, not live provider traffic, native tool future execution, native app-server fanout, interactive TUI rendering ownership, real workspace mutation, WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.65: In-Flight Tool Drain Boundary

Model the upstream post-stream in-flight tool drain before token-count and turn-diff emission:

- preserve ordered `ResponseInputItem` drain behavior;
- record successful and converted-failure tool responses into conversation history;
- classify fatal tool future failures separately from model-visible converted failures;
- carry memory-mode pollution facts for external-context response items;
- prove token-count and turn-diff emission happen after the drain completes;
- keep native future ownership, real tool execution, provider traffic, filesystem mutation, and Cafex behavior out of scope.

Status: HXCX-4.65 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic in-flight tool drain evidence only, not live provider traffic, native tool future execution, native app-server fanout, interactive TUI rendering ownership, real workspace mutation, WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.66: Post-Drain Token And Turn-Diff Emission Boundary

Model the upstream post-drain emission sequence before the sampling outcome is returned:

- project token-count emission only after the in-flight drain completes;
- check cancellation after token-count emission and before turn-diff emission;
- project turn-diff tracker reads and `TurnDiffEvent` emission only when a unified diff is available;
- preserve no-emission behavior when pending flags are absent;
- preserve sampling outcome return only when cancellation does not interrupt the post-drain path;
- keep native app-server fanout, real provider traffic, filesystem mutation, and Cafex behavior out of scope.

Status: HXCX-4.66 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic post-drain emission evidence only, not live provider traffic, native tool future execution, native app-server fanout, interactive TUI rendering ownership, real workspace mutation, WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.67: Sampling Result Turn-Loop Integration Boundary

Model the upstream integration of returned `SamplingRequestResult` into the outer turn loop:

- propagate returned `needs_follow_up` and `last_agent_message` facts;
- enable pending-input draining after successful sampling returns;
- combine model follow-up with pending input before deciding the next loop action;
- route token-limit-plus-follow-up through mid-turn auto-compaction;
- preserve terminal no-follow-up turn breaks and last-agent-message updates;
- bypass cancellation and error returns without treating them as successful sampling results;
- keep live provider traffic, native tool futures, app-server fanout, workspace mutation, and Cafex behavior out of scope.

Status: HXCX-4.67 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic sampling-result turn-loop integration evidence only, not live provider traffic, native tool future execution, native app-server fanout, interactive TUI rendering ownership, real workspace mutation, WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.68: Post-Sampling Pending Input Drain Boundary

Model the upstream pending-input drain immediately before the next prompt is assembled:

- preserve `can_drain_pending_input` gating after sampling-result integration;
- skip terminal, cancelled, errored, and model-priority auto-compact paths;
- drain active-turn pending input before mailbox response items;
- suppress mailbox delivery when the active turn no longer accepts it;
- record hook intent for pending user input versus pending response items;
- keep live queues, native futures, provider traffic, real tool execution, filesystem mutation, and Cafex behavior out of scope.

Status: HXCX-4.68 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic post-sampling pending-input drain evidence only, not live provider traffic, native input queue ownership, native hook execution, native tool future execution, native app-server fanout, interactive TUI rendering ownership, real workspace mutation, WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.69: Pending-Input Hook Recording Boundary

Model the upstream hook inspection and recording step for drained pending input:

- inspect each drained pending input item before prompt preparation;
- distinguish hook-continued input from hook-stopped input;
- record user input through the user-prompt path and response items through conversation recording;
- record additional contexts for both stopped and accepted pending input;
- preserve the break-before-prompt rule when input is blocked and no non-empty user input was accepted;
- keep live hook execution, provider traffic, native futures, real tool execution, filesystem mutation, and Cafex behavior out of scope.

Status: HXCX-4.69 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic pending-input hook recording evidence only, not live hook process execution, live provider traffic, native input queue ownership, native tool future execution, native app-server fanout, interactive TUI rendering ownership, real workspace mutation, WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.70: Prompt Preparation After Pending-Input Hooks Boundary

Model the upstream prompt preparation path after pending-input hooks:

- skip prompt preparation when hook recording breaks before prompt or upstream control flow already bypassed prompt assembly;
- clone conversation history for the model request prompt;
- apply `for_prompt` normalization against model input modalities, including image filtering when unsupported;
- read the current `thread_id:window_id` request window id;
- build turn metadata header presence facts for dispatch;
- prove dispatch preconditions without live provider traffic;
- keep live provider traffic, native futures, real tool execution, filesystem mutation, and Cafex behavior out of scope.

Status: HXCX-4.70 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic prompt-preparation evidence only, not live hook process execution, live provider traffic, native input queue ownership, native tool future execution, native app-server fanout, interactive TUI rendering ownership, real workspace mutation, WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.71: Terminal Stop-Hook Routing Boundary

Model the upstream terminal stop-hook path after the sampling loop decides no follow-up remains:

- preserve stop-hook eligibility from terminal sampling-result integration;
- distinguish root `Stop`, thread-spawned `SubagentStop`, and internal-subagent skip targets;
- project hook-started preview runs and hook-completed runs without executing hook processes;
- record a hook continuation prompt and continue the turn loop when a block has renderable fragments;
- emit the warning fallback when a stop hook blocks without a renderable prompt;
- break the turn for stop-requested outcomes and normal terminal completion;
- model legacy after-agent abort as an error-emitting terminal path;
- keep live hook execution, provider traffic, native futures, real tool execution, filesystem mutation, and Cafex behavior out of scope.

Status: HXCX-4.71 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic terminal stop-hook routing evidence only, not live hook process execution, live provider traffic, native input queue ownership, native tool future execution, native app-server fanout, interactive TUI rendering ownership, real workspace mutation, WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.72: Sampling Error Terminal Bypass Boundary

Model the upstream terminal sampling error paths that bypass stop-hook routing:

- break without emitting a new error event for `TurnAborted`, since cancellation is reported by the outer lifecycle;
- retry the sampling loop after invalid-image history sanitization when previous-turn images can be replaced;
- emit bad-request lifecycle, tracking, and `EventMsg::Error` when invalid-image retry is not possible;
- emit generic Codex error lifecycle, tracking, and error-event projection;
- preserve the previous last agent message across terminal error decisions;
- keep stop-hook execution, live provider traffic, native futures, real tool execution, filesystem mutation, and Cafex behavior out of scope.

Status: HXCX-4.72 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic sampling-error terminal bypass evidence only, not live hook process execution, live provider traffic, native input queue ownership, native tool future execution, native app-server fanout, interactive TUI rendering ownership, real workspace mutation, WebSocket transport, SSE frame parsing, Tokio task ownership, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.73: Turn Completion Lifecycle Boundary

Model the upstream outer task lifecycle that consumes terminal `run_turn` outcomes:

- emit turn start lifecycle before task execution and `TurnStarted` inside the regular turn path;
- flush rollout before terminal completion and warn on flush failure without blocking the terminal event;
- emit `TurnComplete` with the returned last agent message after normal completion, including prior terminal error events;
- suppress normal completion when the task cancellation token is already cancelled;
- emit abort lifecycle plus `TurnAborted` for active turn interruption and record interrupted-turn markers when eligible;
- clear the active turn and emit idle-thread lifecycle when no trigger mailbox work remains;
- keep live Tokio task ownership, live extension execution, rollout IO, provider traffic, real tool execution, filesystem mutation, and Cafex behavior out of scope.

Status: HXCX-4.73 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic turn lifecycle projection evidence only, not live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, native app-server fanout, interactive TUI rendering ownership, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.74: Terminal App-Server/TUI Turn Projection Boundary

Project the selected terminal turn lifecycle events into app-server and TUI state surfaces:

- raw `EventMsg::TurnComplete` and `EventMsg::TurnAborted` core agent status projection;
- app-server pending per-turn request abort and pending interrupt response intent;
- thread status active-state clearing for completed/interrupted turns;
- `TurnCompletedNotification` projection for completed, failed-after-error, and interrupted turn statuses;
- thread-history failed-status preservation after prior non-retry error;
- TUI completed/interrupted/failed notification handling;
- last-agent-message propagation to core/collab status while documenting that app-server turn-completed notifications call `on_task_complete(None, ...)`.

Status: HXCX-4.74 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic terminal app-server/TUI projection evidence only, not live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.75: Turn Replay/Reconstruction Projection Boundary

Model the selected restored-turn reconstruction behavior used by app-server thread history and TUI replay:

- rebuild turns from rollout items and finish any open turn at the end of reconstruction;
- exact active-turn completion closes the current turn;
- failed-after-error completion preserves failed turn status instead of overwriting it with completed;
- interrupted active turns are marked terminal and later finalized by reconstruction finish;
- late completion/abort events update the historical target without closing or interrupting the current active turn;
- unmatched terminal completions fall back to the active turn when one exists, otherwise no-op;
- TUI replay synthesizes `TurnCompletedNotification` with `Some(ReplayKind)` for completed/interrupted/failed restored turns.

Status: HXCX-4.75 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic replay/reconstruction projection evidence only, not live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.76: Pending Interactive Replay Routing Boundary

Model selected TUI/app thread-event routing around restored active turns and pending interactive prompts:

- restore active turn id from the latest in-progress turn when setting rebuilt turns;
- observe incoming interactive server requests and keep only unresolved prompts in thread snapshots;
- clear prompt queues on matching `TurnCompleted`, server-request resolution, outbound answer/approval commands, request eviction, thread close, and rollback;
- preserve active turn id when a replayed/nonmatching `TurnCompleted` targets a different turn;
- expose side-parent pending status as needs-input before approval when prompts remain;
- replay buffered notifications and requests with `Some(ReplayKind::ThreadSnapshot)`.

Status: HXCX-4.76 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic pending interactive replay routing evidence only, not live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.77: Thread Snapshot Replay Dispatch Boundary

Model selected TUI thread snapshot replay dispatch after pending interactive replay state is known:

- gate initial history and thread-switch replay buffers when terminal resize reflow is enabled and replay payloads exist;
- restore snapshot input state and suppress queue autosend before replaying snapshot turns;
- suppress warning/config/guardian notice notifications when a snapshot contains pending interactive requests;
- deliver buffered notifications and requests into `ChatWidget` with `Some(ReplayKind::ThreadSnapshot)`;
- preserve request filtering after pending-interactive prompts have already been answered or resolved.

Status: HXCX-4.77 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic replay-dispatch evidence only, not live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.78: Replayed Server Request Surface Boundary

Model selected ChatWidget request surfaces reached by thread snapshot replay:

- render command approval, file-change approval, MCP elicitation, permissions, and user-input request surfaces from replayed buffered requests;
- preserve pending-interactive snapshot filtering so answered prompts do not reappear;
- suppress unsupported request stub errors when replay-kind is attached;
- retain the live unsupported-stub contrast for non-replay requests;
- keep this as typed deterministic surface routing rather than live app-server request resolution.

Status: HXCX-4.78 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic replayed request surface evidence only, not live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.79: App-Server Request Resolution Boundary

Model selected `PendingAppServerRequests` request-resolution behavior after request surfaces exist:

- record pending command approval, file-change approval, permissions, per-turn user-input, and MCP elicitation requests;
- resolve outbound app commands into serialized app-server response intent without sending live responses;
- preserve per-turn FIFO user-input popping and MCP server/request-id matching;
- distinguish duplicate or missing request responses as deterministic no-ops;
- preserve notification-side request removal without inventing a serialized response.

Status: HXCX-4.79 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic pending-request state evidence only, not live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.80: App-Server Response Dispatch Boundary

Model selected response/reject dispatch intent after pending request resolution:

- dispatch resolved pending request responses through typed `resolve_server_request` intent;
- reject unsupported live server requests with JSON-RPC error payload intent;
- preserve serialization refusal and missing-session no-op behavior;
- record send-failure intent without opening live websocket/control-socket traffic;
- preserve successful response ordering and pending-replay state refresh intent.

Status: HXCX-4.80 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic response dispatch evidence only, not live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.81: App-Server Request Enqueue Routing Boundary

Model selected incoming server-request enqueue routing after recording/rejection:

- route primary-thread requests to the pending primary buffer before primary setup;
- route active primary-thread requests into the active thread queue and chatwidget delivery intent;
- route background-thread requests into per-thread queues with side-parent status refresh intent;
- preserve threadless request ignore behavior;
- skip enqueue after unsupported requests have already been rejected.

Status: HXCX-4.81 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic enqueue-routing evidence only, not live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.82: Queued Request Delivery Boundary

Model selected queued server-request delivery from thread buffers into replay-kind-aware chat widget request handlers:

- deliver active-thread queued requests only when pending request state still contains them;
- deliver background-buffered requests through the same request surface after replay/thread activation;
- keep primary pending events deferred until the primary thread has been established and drained;
- skip non-pending stale requests without re-opening UI prompts;
- attach `ReplayKind::ThreadSnapshot` for replay delivery and suppress live-only effects.

Status: HXCX-4.82 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic queued-request delivery evidence only, not live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.83: Thread Buffered Request Eviction And Filter Boundary

Model selected bounded thread-event buffer behavior around pending interactive replay:

- retain buffered requests when capacity is not exceeded;
- evict the oldest event after over-capacity pushes while preserving queue order;
- remove pending interactive replay state when the evicted event is a server request;
- keep pending replay state intact when a non-request event is evicted;
- filter thread snapshot replay so evicted or resolved requests do not reappear as actionable prompts.

Status: HXCX-4.83 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic buffer eviction/filter evidence only, not live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.84: Thread Event Session-Refresh Rebase Boundary

Model selected session-refresh rebase behavior for buffered thread events:

- retain buffered server requests while preserving pending replay filtering separately;
- retain hook started/completed notifications;
- retain MCP server status updates and feedback submissions;
- drop ordinary notifications and history entry responses;
- preserve resolved-request filtering across rebase so stale interactive prompts do not reappear.

Status: HXCX-4.84 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic session-refresh rebase evidence only, not live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.85: Thread Event Active-Turn Cache Boundary

Model selected active-turn cache lifecycle for `ThreadEventStore`:

- restore the latest in-progress turn id when turns are set from a snapshot;
- set the active turn id from `TurnStarted`;
- preserve the cached active id when a `TurnCompleted` notification names a different turn;
- clear the cached active id when matching completion, thread close, or explicit clear occurs;
- keep event ordering and no-live/no-real-tool proofs attached to the fixture.

Status: HXCX-4.85 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic active-turn cache evidence only, not live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.86: Thread Side-Parent Pending Status Boundary

Model selected side-parent pending status behavior for inactive parent threads:

- derive `NeedsInput` when any request-user-input prompt remains pending;
- derive `NeedsApproval` when approvals remain pending and no user-input prompt is pending;
- clear actionable status when no pending prompt remains;
- fall back to request-derived status when enqueueing an interactive request before the store exposes a pending status;
- remove pending status after server resolution, buffer eviction, or thread close.

Status: HXCX-4.86 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic side-parent pending status evidence only, not live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.87: Thread Side-Parent Terminal Status-Change Boundary

Model selected side-parent status changes driven by upstream server notifications:

- clear parent status when a new turn starts;
- set finished, interrupted, failed, and closed terminal parent statuses from `TurnCompleted` and `ThreadClosed`;
- clear only actionable statuses for `ItemStarted` and `ServerRequestResolved`;
- preserve terminal statuses when clear-actionable notifications arrive;
- give pending prompt status precedence over notification-derived status changes;
- ignore in-progress turn-completed notifications that upstream maps to no status change.

Status: HXCX-4.87 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic side-parent notification status-change evidence only, not live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.88: Side-Thread UI Sync Boundary

Model selected side-thread UI synchronization after side-parent status updates:

- clear side UI and restore default interrupted-turn notice behavior when no active thread or no side-thread state exists;
- build main-thread and parent-thread context labels with upstream status text;
- suppress interrupted-turn notices and block thread renaming while side conversations are active;
- avoid a UI resync when the parent status is unchanged;
- preserve status-clear labels without terminal/actionable status text.

Status: HXCX-4.88 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic side-thread UI sync evidence only, not live terminal rendering, live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.89: Side-Thread Discard Cleanup Boundary

Model selected side-thread return and discard cleanup behavior:

- block return-from-side while overlays, modals, popups, or non-empty composer state are active;
- avoid discarding when the target is already the current side thread or no side thread is visible;
- select active-turn versus startup interrupt intent before unsubscribe/local cleanup;
- keep the side thread visible when interrupt or unsubscribe cleanup fails;
- remove closed side threads through local state only, without server RPC intent.

Status: HXCX-4.89 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic side-thread discard cleanup evidence only, not live terminal rendering, live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.90: Side-Thread Fork/Start Boundary

Model selected side-thread fork and startup behavior:

- block `/side` before the main thread is ready or while another side thread is open;
- build an ephemeral fork config that inherits parent model, reasoning, service tier, permissions, and reviewer settings;
- append side-conversation developer guardrails and inject the hidden boundary prompt item;
- classify missing-start fork failures separately from generic fork failures;
- install side-thread snapshots without rendering forked parent transcript turns;
- clean up failed boundary injection, failed switch, and inactive-child starts while restoring the pending user message.

Status: HXCX-4.90 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic side-thread fork/start evidence only, not live terminal rendering, live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.91: Side-Thread Startup Event Routing Boundary

Model selected side-thread MCP startup notification routing after side-thread fork/start:

- refresh expected MCP startup servers when MCP status notifications arrive;
- buffer child-thread MCP startup notifications away from the visible primary thread;
- replay buffered child startup failures into the child transcript exactly once;
- ignore app-scoped MCP startup notifications for active-thread rendering;
- route active side-thread startup notifications through the active receiver and preserve side conversation context;
- configure replayed side-thread sessions with side conversation display mode;
- suppress misrouted child MCP startup notifications before mutating the visible chat widget.

Status: HXCX-4.91 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic side-thread startup event routing evidence only, not live terminal rendering, live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.92: Side-Thread Composer Handoff Boundary

Model selected side-thread inline user-message restoration and submission behavior after `/side` startup decisions:

- restore the inline side question to the composer when `/side` is blocked;
- restore after fork failures, prepare/inject failures, switch failures, and inactive-child cleanup;
- clear the side context label after fork failures while keeping block-path side UI sync behavior distinct;
- submit the message as a plain user turn after a successful side-thread switch;
- prove successful submission does not also restore a duplicate composer draft;
- preserve no-message no-op behavior.

Status: HXCX-4.92 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic side-thread composer handoff evidence only, not live terminal rendering, live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.93: Side-Thread Agent Navigation Cleanup Boundary

Model selected side-thread agent navigation and local-state cleanup behavior:

- preserve same-target and no-visible-side no-discard decisions;
- select the visible side thread as a discard target when switching back to its parent;
- interrupt side threads through startup or active-turn close intent before unsubscribe cleanup;
- remove thread event channels, side-thread state, and agent navigation entries after successful discard;
- keep local state and display an error when interrupt or unsubscribe cleanup fails;
- keep a failed-cleanup side thread visible after parent-switch cleanup failure;
- clear active side-thread state or refresh pending approvals according to whether the discarded thread was active;
- surface pending inactive requests after successful parent-switch cleanup;
- remove closed side-thread local state without server RPC.

Status: HXCX-4.93 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic side-thread agent navigation cleanup evidence only, not live terminal rendering, live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.94: Active Non-Primary Shutdown Target Boundary

Model selected active non-primary `thread/closed` failover behavior:

- ignore non-shutdown notifications;
- ignore primary-thread shutdown as a failover target;
- select `(active_thread_id, primary_thread_id)` when the active non-primary thread closes unexpectedly;
- suppress failover when the active thread matches the pending shutdown-exit marker;
- still fail over when the pending shutdown-exit marker belongs to another thread;
- preserve failover-before-pending-exit-clear ordering;
- distinguish side-thread local cleanup from non-side visible-side discard during failover;
- model info/error display intent without live terminal mutation.

Status: HXCX-4.94 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic active non-primary shutdown target evidence only, not live terminal rendering, live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.95: Clear-UI Header Render Boundary

Model selected raw Codex clear-UI header behavior:

- build header lines from model, reasoning effort, fast-status eligibility, cwd, version, and width;
- render a fresh header after clearing a long transcript without replaying stale startup notices or prior transcript text;
- route slash clear and Ctrl+L through the same clear-header path;
- show fast status for fast-capable model/service-tier combinations;
- clear pending history before visible-screen or scrollback clearing;
- distinguish alternate-screen visible clearing from non-alternate-screen scrollback clearing;
- anchor the viewport back to the top when needed;
- reset transcript/app UI state after clear;
- preserve event ordering while avoiding live terminal mutation.

Status: HXCX-4.95 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic clear-UI header rendering evidence only, not live terminal rendering, live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.96: Terminal Resize Reflow Boundary

Model selected raw Codex terminal resize/reflow behavior:

- render source transcript cells into reflow rows for a target history wrap width;
- insert blank separators between non-continuation history cells;
- retain only the newest rows when a resize reflow row cap is present;
- preserve all rows when row capping is disabled or the transcript is under the cap;
- reduce history wrap width when ambient pet columns are reserved;
- retain only the newest initial replay display rows under the row cap;
- use transcript-tail mode for thread-switch replay buffers when capped;
- disable thread-switch buffering when no row cap exists;
- preserve event ordering while avoiding live terminal mutation.

Status: HXCX-4.96 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic terminal resize reflow evidence only, not live terminal rendering, live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.97: Resize Reflow Scheduling Boundary

Model selected raw Codex draw-size-change resize scheduling behavior:

- initialize the first observed width without scheduling a rebuild;
- keep unchanged terminal sizes as no-op observations;
- schedule height-shrink transcript rebuilds without assigning a target width;
- schedule width-change rebuilds with the current terminal width as target;
- set pending reflow and 75ms debounce intent;
- request a delayed frame without owning the live frame requester;
- mark stream-time width resizes when stream-sensitive state is active;
- clear resize reflow state when the feature is disabled and width changes;
- refresh status-line intent when terminal size changes;
- compose after the terminal resize reflow boundary while preserving event ordering;
- avoid live terminal mutation, live frame scheduling, live app-server fanout, real filesystem mutation, and real tool execution.

Status: HXCX-4.97 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic resize reflow scheduling evidence only, not live terminal rendering, live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.98: Feedback Submission Routing Boundary

Model selected raw Codex feedback submission routing behavior:

- render feedback upload failures into current chat history when no origin thread exists;
- buffer completed feedback submissions into the origin thread event store when an origin thread exists;
- suppress immediate visible history insertion for inactive origin threads;
- preserve feedback submissions across session refresh and thread snapshots;
- render buffered feedback success cells when the origin thread snapshot is replayed;
- model active-origin delivery intent without owning live Tokio channels;
- keep feedback categories and history-cell kinds typed;
- preserve event ordering while avoiding live feedback upload, live app-server fanout, real network traffic, filesystem mutation, and real tool execution.

Status: HXCX-4.98 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic feedback submission routing evidence only, not live feedback upload, live app-server fanout, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.99: Active-Turn Error Classification Boundary

Model selected raw Codex active-turn TUI error classification behavior:

- extract structured active-turn-not-steerable server errors without marking the turn failed;
- route non-steerable review turns into rejected-steer/error-message intent;
- detect missing active-turn steer races and clear stale cached active-turn state;
- extract the actual server active-turn id from `turn/steer` expected/found mismatch messages;
- extract the actual server active-turn id from `turn/interrupt` expected/found mismatch messages;
- model retry-with-server-turn-id intent without owning live app-server calls;
- surface archived session guidance without leaking the rollout path;
- preserve event ordering while avoiding live steering, live interrupt, live app-server fanout, real network traffic, filesystem mutation, and real tool execution.

Status: HXCX-4.99 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. This slice exposed optional anonymous-field read lowering/runtime semantics as generic haxe.rust follow-up `haxe.rust-i8li`; codexhx now materializes that draft record through a typed default factory while the compiler/runtime fix is tracked upstream. This is deterministic active-turn error classification evidence only, not live app-server calls, live turn steering, live interrupt retry, interactive TUI ownership, live Tokio task ownership, live extension execution, rollout persistence, live hook process execution, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.100: Fresh Session Service-Tier Propagation Boundary

Model selected raw Codex fresh-session config behavior:

- clone the base TUI config for fresh session creation;
- overwrite only `service_tier` from `chat_widget.configured_service_tier()`;
- preserve `ServiceTier::Fast.request_value()` as `priority`;
- preserve the explicit standard-routing sentinel `default`;
- clear a stale base-config service tier when the chat widget has no configured service tier;
- preserve ordering facts while avoiding live app-server, model-catalog, network, filesystem, and tool execution.

Status: HXCX-4.100 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic fresh-session config evidence only, not live app-server calls, model-catalog default resolution, persisted config writes, interactive TUI ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.101: Duplicate Backtrack Selection Boundary

Model selected raw Codex duplicate-history backtrack behavior:

- count/select only `UserHistoryCell` entries after the latest `SessionInfoCell`;
- choose the edited latest-session duplicate target rather than the same text in an earlier session;
- carry edited prefill, text element count, local image facts, and remote image facts into the selection;
- compute rollback turn count from the latest-session user count and selected user index;
- preserve composer prefill, remote-image application, pending rollback, thread rollback submission, event ordering, and no-live/no-network/no-real-tool proofs.

Status: HXCX-4.101 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic duplicate-history backtrack selection evidence only, not live app-server calls, live rollback RPC handling, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.102: Remote-Image-Only Backtrack Rollback Boundary

Model selected raw Codex backtrack rollback behavior:

- accept a confirmed selection with empty prefill and only remote image URLs;
- apply remote image URLs before composer text restoration;
- call composer restoration with empty text because remote images are present, clearing stale draft text;
- compute one rollback turn from the selected user index and latest-session user count;
- preserve pending rollback, thread rollback submission, event ordering, and no-live/no-network/no-real-tool proofs.

Status: HXCX-4.102 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic backtrack rollback application evidence only, not live app-server calls, live rollback RPC handling, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.103: Cancelled-Turn Edit Rollback Boundary

Model selected raw Codex cancelled-turn edit behavior:

- restore cancelled prompt text and remote image URLs into the composer;
- when local transcript history has a user turn, route through backtrack rollback for the latest user index;
- when local transcript history has no user turn, record a pending rollback directly and submit a one-turn rollback;
- preserve one-turn rollback behavior for both upstream-tested paths;
- preserve event ordering and no-live/no-network/no-real-tool proofs.

Status: HXCX-4.103 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic cancelled-turn edit restoration evidence only, not live app-server calls, live rollback RPC handling, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.104: Data-Image Backtrack Resubmit Boundary

Model selected raw Codex data-image backtrack resubmit behavior:

- restore a backtrack selection with a `data:image/...` remote URL into composer state;
- pressing Enter after rollback submits the restored user turn;
- preserve the remote URL as a submitted `UserInput::Image` item before text;
- preserve rollback and user-turn submission facts, event ordering, and no-live/no-network/no-real-tool proofs.

Status: HXCX-4.104 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic data-image backtrack resubmit evidence only, not live app-server calls, live rollback RPC handling, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.105: Thread Snapshot Turn-History Replay Ordering Boundary

Model selected raw Codex thread snapshot turn-history replay behavior:

- apply the replayed thread session before replaying snapshot turns;
- replay turns in snapshot order and items in each turn's stored order;
- project replayed user messages and agent messages into transcript state;
- synthesize replayed terminal turn-complete notifications for completed turns;
- preserve queue-autosend suppression, event ordering, and no-live/no-network/no-real-tool proofs.

Status: HXCX-4.105 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic thread snapshot turn-history replay evidence only, not live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.106: Thread Snapshot Collab Metadata Replay Boundary

Model selected raw Codex chat widget replacement and replay behavior:

- reconstruct the chat widget before replaying a thread snapshot;
- reseed collab agent nickname and role metadata from agent navigation into the replacement widget;
- replay a buffered collab `Wait` tool-call item against the reseeded metadata;
- render the named wait item as `Robie [explorer]` instead of falling back to the raw receiver thread id;
- preserve replay-kind, no-live/no-network/no-real-tool, and secret-free summary proofs.

Status: HXCX-4.106 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic collab metadata replay evidence only, not live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.107: Refreshed Snapshot Session Persistence Boundary

Model selected raw Codex refreshed snapshot behavior:

- replace an existing snapshot session with the refreshed session state;
- replace empty snapshot/store turn lists with resumed turns;
- preserve refreshed cwd/session facts in both the mutable snapshot and thread event store snapshot;
- rebase buffered events after the session refresh;
- preserve active-turn restoration facts, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.107 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic refreshed snapshot persistence evidence only, not live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.108: Queued Rollback Overlay Sync Boundary

Model selected raw Codex queued rollback behavior:

- trim the last N user turns from transcript cells after the latest session boundary;
- replace an active transcript overlay's committed cells with the trimmed transcript;
- clear deferred history lines that could otherwise flush removed transcript content;
- clamp active backtrack preview selection to the remaining user-turn range;
- preserve agent copy-history truncation, render-pending, no-live/no-network/no-real-tool, and secret-free summary proofs.

Status: HXCX-4.108 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic queued rollback overlay sync evidence only, not live app-server calls, live rollback RPC handling, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.109: Rollback Response Active-Queue Flush Boundary

Model selected raw Codex rollback response behavior:

- apply the rollback response to the thread event store when a thread channel exists;
- drain queued active-thread receiver events when the response targets the active thread;
- restore the active receiver when it is not disconnected;
- discard stale queued notifications, such as config warnings, after rollback;
- preserve local rollback-event/backtrack-success intent, event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.109 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic rollback response active-queue flush evidence only, not live app-server calls, live rollback RPC handling, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.110: Fresh Session Previous-Conversation Shutdown Boundary

Model selected raw Codex fresh-session shutdown behavior:

- detect an existing chat-widget thread before starting a new session;
- clear the in-flight rollback guard before switching conversations;
- emit app-server `thread_unsubscribe` intent for the previous thread;
- abort and remove the previous thread event listener task;
- prove that new-session shutdown does not submit `Op::Shutdown`;
- preserve duplicate-shutdown suppression, event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.110 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic fresh-session previous-conversation shutdown evidence only, not live app-server calls, live `thread_unsubscribe` RPC handling, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.111: Interrupt Without Active Turn Startup Fallback Boundary

Model selected raw Codex interrupt-routing behavior:

- accept an `AppCommand::Interrupt` for a registered primary thread;
- detect that no active turn id is cached for the target thread;
- submit startup-interrupt intent instead of turn-interrupt intent;
- return `handled = true` after successful startup interrupt;
- skip active-turn mismatch retry handling because there was no active turn id;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.111 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic interrupt without active turn startup fallback evidence only, not live app-server calls, live `startup_interrupt` RPC handling, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.112: Override-Turn-Context Settings Update Boundary

Model selected raw Codex settings-update behavior:

- accept `AppCommand::OverrideTurnContext` for a registered thread;
- build thread/settings update intent with model, effort, service tier, approvals, active permission profile, collaboration mode, and personality;
- return `handled = true` for the command submission path;
- preserve the upstream ack-versus-notification split, where the update response does not mutate cached primary-session state;
- apply settings to cached state only after `thread/settings/updated`, preserving top-level model/effort for non-default collaboration mode while caching collaboration settings and other thread settings;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.112 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic override-turn-context settings update evidence only, not live app-server calls, live `thread/settings/update` RPC handling, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.113: Inactive Thread Settings Notification Cache Boundary

Model selected raw Codex inactive-thread notification behavior:

- accept `ServerNotification::ThreadSettingsUpdated` for an inactive thread that already has a cached thread channel;
- apply notification settings to that inactive cached session while leaving the active primary session isolated;
- preserve top-level model/effort for non-default collaboration mode while rebasing the cached collaboration settings to the notification model/effort;
- propagate model provider, approval policy, approvals reviewer, sandbox-derived permission profile, active permission profile, and personality facts;
- model the later chat-widget handoff that makes the inactive session's collaboration mode/current model/current effort/personality visible;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.113 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic inactive-thread settings notification cache evidence only, not live app-server calls, live WebSocket notification delivery, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.114: Clear-Only UI Reset Session-Preservation Boundary

Model selected raw Codex clear-only reset behavior:

- call `reset_app_ui_state_after_clear`, which delegates to transcript reset;
- clear overlay, transcript cells, deferred history lines, history-emitted state, transcript reflow, initial replay buffer, backtrack state, backtrack render-pending state, and skill warning memory;
- preserve the chat-widget session thread id;
- preserve composer draft text after the reset;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.114 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic clear-only UI reset session-preservation evidence only, not live terminal clearing, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.115: Clear-Only Skill Warning Rerender Boundary

Model selected raw Codex skill-warning reset behavior:

- render a newly active skill warning key on the first scan;
- suppress the same active warning key on a repeated scan;
- clear skill warning memory through the clear-only UI reset path;
- allow the same warning key to render again after reset;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.115 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic clear-only skill warning rerender evidence only, not live terminal clearing, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.116: Backtrack Esc Vim-Insert Guard Boundary

Model selected raw Codex keyboard-routing behavior:

- allow backtrack Esc when the composer is empty, side conversation is inactive, and normal backtrack mode is active;
- keep backtrack Esc available after enabling Vim mode while not in insert mode;
- give Vim insert-mode Esc precedence over backtrack Esc;
- avoid priming backtrack while Vim consumes insert-mode Esc;
- allow backtrack Esc again after Vim insert mode clears;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.116 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic backtrack Esc Vim-insert guard evidence only, not live keyboard input, live terminal clearing, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.117: Side-Conversation Backtrack Esc Vim Guard Boundary

Model selected raw Codex keyboard-routing behavior:

- reject side-conversation backtrack Esc when the composer is empty and normal backtrack mode is active;
- keep normal backtrack handling unavailable while the side conversation is active;
- give Vim insert-mode Esc precedence after Vim mode enters insert state;
- suppress both backtrack handling and side rejection while Vim insert Esc is active;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.117 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic side-conversation backtrack Esc Vim guard evidence only, not live keyboard input, live terminal clearing, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.118: Side-Backtrack Unavailable Message Boundary

Model selected raw Codex side-backtrack error behavior:

- reset primed backtrack state when side-backtrack rejection is invoked;
- preserve the upstream side-edit unavailable message;
- emit an `InsertHistoryCell` error intent through the chat-widget history path;
- preserve the width-80 rendered snapshot line and snapshot name;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.118 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic side-backtrack unavailable-message evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.119: Interrupt/Backtrack Keymap Boundary

Model selected raw Codex keymap behavior:

- preserve plain Esc as the default `chat.interrupt_turn` binding;
- preserve plain Esc as the fixed backtrack binding;
- allow the intentional `chat.interrupt_turn`/`fixed.backtrack` Esc overlap;
- accept remapping interrupt-turn to F12;
- accept unbinding interrupt-turn to an empty binding list;
- reject collisions with other fixed shortcuts such as paste-image Ctrl+V;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.119 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic interrupt/backtrack keymap evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.120: Interrupt/Question-Navigation Keymap Conflict Boundary

Model selected raw Codex app/list keymap shadow behavior:

- preserve the upstream `chat.interrupt_turn` action name;
- preserve the upstream `list.move_right` question-navigation action name;
- detect the F12 collision between `chat.interrupt_turn` and `list.move_right`;
- reject the collision as a keymap validation conflict;
- preserve the prior `chat.interrupt_turn`/`fixed.backtrack` Esc overlap as allowed;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.120 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic interrupt/question-navigation keymap evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.121: Pager/Transcript-Backtrack Keymap Conflict Boundary

Model selected raw Codex pager reserved-key behavior:

- preserve the upstream pager `close` action name;
- preserve the remapped pager Left binding;
- preserve the fixed `transcript_edit_previous` Left binding;
- reject the `close` versus `fixed.transcript_edit_previous` collision;
- preserve the prior `chat.interrupt_turn`/`fixed.backtrack` Esc overlap as allowed;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.121 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic pager/transcript-backtrack keymap evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.122/HXCX-4.123: Key Parser Function, Named-Key, And Minus-Alias Boundary

Model selected raw Codex key parser behavior:

- accept F1 and F24 function-key specs;
- reject out-of-range F25 and nonnumeric ff function-key specs;
- reject modifier-only ctrl specs;
- preserve named non-character keys including tab, backspace, Esc, delete, arrows, home/end, and page-up/page-down;
- preserve space/minus alias-to-character parsing;
- preserve Alt-minus, legacy Alt--, and literal minus parsing with typed modifier facts;
- keep the parser evidence deterministic and independent of live keyboard input;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.122/HXCX-4.123 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic key parser evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.124/HXCX-4.125: Keymap Unbind, Raw-Output, Editor Alias, And Default Tail Boundary

Model selected raw Codex runtime keymap behavior:

- preserve explicit empty-array unbinding for composer toggle-shortcuts;
- preserve the raw-output Alt-r default and F12 remap;
- preserve editor newline aliases for Ctrl-J, Ctrl-M, Enter, Shift-Enter, and Alt-Enter;
- preserve Alt-d delete-forward-word;
- preserve modified Backspace/Delete aliases for backward/forward deletion and word deletion;
- preserve Shift-? composer toggle-shortcuts and Ctrl-Shift-A approval fullscreen defaults;
- preserve primary-binding first/none behavior;
- preserve default conflict validation success;
- keep the keymap evidence deterministic and independent of live keyboard input;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.124/HXCX-4.125 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. HXCX-4.124 exposed generic haxe.rust issue `haxe.rust-yrs1`; codexhx uses nullable class-typed request fields until the compiler default-constructor lowering is fixed. This is deterministic keymap evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.126: Keymap Canonical Binding And Shadow Validation Boundary

Model selected raw Codex keymap validation behavior:

- preserve canonical Ctrl-Alt-Shift-A parsing and modifier bits;
- reject app/main-scope composer, editor, approval, and list shadow conflicts;
- preserve conflict scope and action names;
- keep the keymap evidence deterministic and independent of live keyboard input;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.126 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. It reuses nullable class-typed binding fields already tracked by generic haxe.rust issue `haxe.rust-yrs1`; no new compiler limitation was exposed. This is deterministic keymap evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.127: Keymap Binding Input, Dedupe, Fallback, And Defaults Boundary

Model selected raw Codex keymap binding-input behavior:

- preserve string-or-array binding validation and invalid `meta` modifier path reporting;
- preserve valid multi-binding counts for composer submit;
- preserve first-seen dedupe order for repeated bindings;
- preserve context fallback from global queue binding to composer queue binding;
- preserve invalid global open-transcript/open-external-editor path reporting;
- preserve default copy and reassignable main-surface action bindings;
- keep the keymap evidence deterministic and independent of live keyboard input;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.127 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic keymap evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.128: Keymap Default Pruning Boundary

Model selected raw Codex keymap default/pruning behavior:

- preserve the remaining reassignable main-surface defaults for queued-message editing, history search, and kill-line;
- preserve list move/page/jump defaults;
- preserve pruning of reasoning fallback aliases when editor/vim text-object bindings claim the fallback keys;
- preserve explicit reasoning/editor conflict action facts;
- preserve legacy list overlap pruning for page-up/page-down defaults;
- keep the keymap evidence deterministic and independent of live keyboard input;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.128 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic keymap evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.129: Keymap Overlap Conflict Boundary

Model selected raw Codex keymap overlap/conflict behavior:

- preserve explicit new-list bindings conflicting with configured legacy list bindings;
- preserve app and approval bindings pruning new list defaults when safe;
- preserve explicit new-list versus configured approval conflict facts;
- preserve configured legacy vim-normal bindings pruning new change/substitute defaults;
- preserve explicit new vim-normal versus legacy vim-normal conflict facts;
- keep the keymap evidence deterministic and independent of live keyboard input;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.129 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic keymap evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.130: Keymap Vim-Operator Text-Object Boundary

Model selected raw Codex vim-operator keymap text-object behavior:

- preserve configured legacy `vim_operator.motion_left` and `vim_operator.motion_right` bindings;
- preserve pruning of new inner/around text-object defaults when legacy motion keys claim those bindings;
- preserve explicit `motion_left` versus `select_inner_text_object` conflict facts;
- keep the keymap evidence deterministic and independent of live keyboard input;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.130 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic keymap evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.131: Keymap Vim-Normal Defaults Boundary

Model selected raw Codex vim-normal keymap default behavior:

- preserve `enter_insert` defaults for `i` plus Insert;
- preserve movement defaults for `h`/Left, `l`/Right, `k`/Up, and `j`/Down;
- keep the keymap evidence deterministic and independent of live keyboard input;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.131 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic keymap evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.132: Keymap Invalid Global Copy Path Boundary

Model selected raw Codex invalid global keymap copy binding behavior:

- preserve configured `global.copy` `meta-o` evidence;
- preserve fail-closed parse behavior for the invalid binding;
- preserve `tui.keymap.global.copy` error-path reporting;
- keep the keymap evidence deterministic and independent of live keyboard input;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.132 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic keymap evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.133: Keymap Editor Conflict Boundary

Model selected raw Codex editor keymap conflict behavior:

- preserve configured `editor.move_left` `ctrl-h` evidence;
- preserve configured `editor.move_right` `ctrl-h` evidence;
- preserve upstream `move_left` and `move_right` conflict action names;
- preserve fail-closed keymap validation conflict behavior;
- keep the keymap evidence deterministic and independent of live keyboard input;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.133 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic keymap evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.134: Keymap Pager Conflict Boundary

Model selected raw Codex pager keymap conflict behavior:

- preserve configured `pager.scroll_up` `ctrl-u` evidence;
- preserve configured `pager.scroll_down` `ctrl-u` evidence;
- preserve upstream `scroll_up` and `scroll_down` conflict action names;
- preserve fail-closed keymap validation conflict behavior;
- keep the keymap evidence deterministic and independent of live keyboard input;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.134 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic keymap evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.135: Keymap List Up/Down Conflict Boundary

Model selected raw Codex list keymap conflict behavior:

- preserve configured `list.move_up` `up` evidence;
- preserve configured `list.move_down` `up` evidence;
- preserve upstream `move_up` and `move_down` conflict action names;
- preserve fail-closed keymap validation conflict behavior;
- keep the keymap evidence deterministic and independent of live keyboard input;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.135 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic keymap evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.136: Keymap List Left/Right Conflict Boundary

Model the second selected raw Codex list keymap conflict in `rejects_conflicting_list_bindings`:

- preserve configured `list.move_left` `left` evidence;
- preserve configured `list.move_right` `left` evidence;
- preserve upstream `move_left` and `move_right` conflict action names;
- preserve fail-closed keymap validation conflict behavior;
- keep the keymap evidence deterministic and independent of live keyboard input;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.136 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic keymap evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.137: Keymap List Page/Jump Conflict Boundary

Model selected raw Codex list page/jump keymap conflict behavior:

- preserve configured `list.page_up` `home` evidence;
- preserve configured `list.jump_top` `home` evidence;
- preserve upstream `page_up` and `jump_top` conflict action names;
- preserve fail-closed keymap validation conflict behavior;
- keep the keymap evidence deterministic and independent of live keyboard input;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.137 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic keymap evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.138: Keymap Approval Approve/Decline Conflict Boundary

Model selected raw Codex approval keymap conflict behavior:

- preserve configured `approval.approve` `y` evidence;
- preserve configured `approval.decline` `y` evidence;
- preserve upstream `approve` and `decline` conflict action names;
- preserve fail-closed keymap validation conflict behavior;
- keep the keymap evidence deterministic and independent of live keyboard input;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.138 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic keymap evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.139: Keymap Approval Approve/Deny Conflict Boundary

Model the next selected raw Codex approval keymap conflict behavior:

- preserve configured `approval.approve` `y` evidence;
- preserve configured `approval.deny` `y` evidence;
- preserve upstream `approve` and `deny` conflict action names;
- preserve fail-closed keymap validation conflict behavior;
- keep the keymap evidence deterministic and independent of live keyboard input;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.139 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic keymap evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-4.140: Keymap Approval Overlay Accept Conflict Boundary

Model the next selected raw Codex approval overlay keymap conflict behavior:

- preserve configured `list.accept` `y` evidence;
- preserve default `approval.approve` conflict identity;
- preserve upstream `list.accept` and `approval.approve` conflict action names;
- preserve fail-closed keymap validation conflict behavior;
- keep the keymap evidence deterministic and independent of live keyboard input;
- preserve event ordering, no-live/no-network/no-real-tool proofs, and secret-free summaries.

Status: HXCX-4.140 extends `fixtures/hxrust/model-stream-item-reducer.v1.json` and validates the slice through `harness/check-model-stream-item-reducer.sh`. No new haxe.rust limitation was exposed. This is deterministic keymap evidence only, not live keyboard input, live terminal rendering, live app-server calls, interactive TUI overlay ownership, live Tokio task ownership, live provider traffic, native input queue ownership, native tool future execution, real workspace mutation, WebSocket transport, SSE frame parsing, unauthorized retry execution, auth refresh, inference trace persistence, realtime/audio behavior, or Cafex behavior.

### HXCX-TUI-33: Composer Paste And Attachment Lifecycle

Model selected raw Codex composer paste and attachment behavior:

- preserve explicit `handle_paste` routing for small pasted text, large-paste placeholders, image path detection, and paste-burst flushes in `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs`;
- preserve `LARGE_PASTE_CHAR_THRESHOLD` behavior: insert `[Pasted Content N chars]`, store the full payload in `pending_pastes`, and expand it during submission while keeping text element spans aligned;
- preserve paste-burst state facts from `../codex/codex-rs/tui/src/bottom_pane/paste_burst.rs`: first-char hold, begin buffering, newline capture while active, due flush, redraw request, and follow-up frame scheduling through `chatwidget/interaction.rs`;
- preserve local/remote image numbering from `chat_composer/attachment_state.rs`, including remote-image prefixes, relabeling local placeholders after remote image changes, selected remote deletion, and submission drain semantics;
- preserve draft/history restore surfaces: `snapshot_draft`, `restore_draft`, `apply_history_entry`, pending-paste retention when placeholders remain, and cursor restoration;
- preserve selected image insertion fallback when image-dimension probing fails, but keep the fixture no-live by rejecting actual filesystem probing;
- keep the evidence deterministic and independent of live terminal rendering, live input loops, model/tool execution, ratatui mutation, command execution, filesystem mutation, and Cafex behavior.

Status: HXCX-TUI-33 extends `fixtures/hxrust/tui-smoke.v1.json` and validates the slice through `harness/check-tui-smoke.sh`. No new haxe.rust limitation was exposed. This is deterministic composer lifecycle evidence only, not a full composer implementation or live terminal backend.

### HXCX-TUI-34: Composer Submission And Dispatch Lifecycle

Model selected raw Codex composer submission and dispatch behavior:

- preserve `InputResult` variants from `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs`: `Submitted`, `Queued`, `Command`, `ServiceTierCommand`, `CommandWithArgs`, and `None`;
- preserve `prepare_submission_text_with_options`: pending paste expansion, text element trimming, slash validation, input-too-large rejection, local image pruning, history recording, and pending-paste restoration on suppression;
- preserve `handle_submission_with_time`: queued startup/task submissions flush paste-burst state first, defer slash validation when queued slash prompts need app-level parsing, map shell prompts to `RunShell`, and keep Enter as newline while a non-slash paste burst is active;
- preserve bare slash command dispatch and inline slash command args dispatch, including staged local command history and rebased argument text elements;
- preserve ChatWidget input-result routing in `../codex/codex-rs/tui/src/chatwidget/input_flow.rs`: build `UserMessage`, drain local and remote attachments, submit immediately when allowed, queue while session/task state requires it, and refresh queue preview;
- preserve app-level submission behavior in `../codex/codex-rs/tui/src/chatwidget/input_submission.rs`: remote image items before local image items before text, blocked-image restoration when the model does not support images, shell escape handling, history recording, pending steer setup, and user-message display intent;
- preserve queue-drain dispatch for `Plain`, `ParseSlash`, and `RunShell` in `input_flow.rs`, but keep fixture evidence deterministic and no-live;
- keep the evidence independent of live terminal rendering, live input loops, model/tool execution, command execution, real shell dispatch, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-34 extends `fixtures/hxrust/tui-smoke.v1.json` and validates the slice through `harness/check-tui-smoke.sh`. No new haxe.rust limitation was exposed. This is deterministic composer submission evidence only, not a full live dispatch implementation.

### HXCX-TUI-35: Composer Editing And Key-Dispatch Lifecycle

Model selected raw Codex composer editing and key-dispatch behavior:

- preserve `handle_key_event_without_popup` ordering in `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs`: remote image selection first, selected-remote clearing before normal edits, shortcut-overlay handling, bash-mode Esc, Vim insert escape/operator handling, Vim normal `/` and `!` shortcuts, fixed queue keys, fixed submit keys, Ctrl-D empty handling, history navigation, and finally basic input;
- preserve `handle_input_basic_with_time`: ignore release events, flush due paste-burst state before new input, append Enter into active burst buffers, intercept plain chars for paste-burst detection, flush buffered bursts before modified/non-char input, sync bang shell mode, and reconcile deleted atomic elements;
- preserve queue-key semantics: queue when task running or queue-submissions is enabled, but do not hijack bang shell commands when queueing is not required;
- preserve submit-key semantics: submit normally, or queue when queue-submissions is enabled;
- preserve deleted-element reconciliation: pending large-paste placeholders and local image placeholders are pruned when their atomic text elements disappear;
- preserve deterministic no-live evidence for remote selection, Vim/bash mode transitions, history application, and shortcut overlay toggling;
- keep the evidence independent of live terminal rendering, live input loops, model/tool execution, command execution, real shell dispatch, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-35 extends `fixtures/hxrust/tui-smoke.v1.json` and validates the slice through `harness/check-tui-smoke.sh`. No new haxe.rust limitation was exposed. This is deterministic composer editing evidence only, not a full live input backend.

### HXCX-TUI-36: Composer Popup Synchronization Lifecycle

Model selected raw Codex composer popup synchronization behavior:

- preserve `sync_popups` ordering in `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs`: sync slash-command elements first, suppress all popups during history search, close popups when disabled, derive mentions-v2/file/mention tokens, suppress popups while browsing input history, gate command popup creation, then prefer mentions-v2, `$` mention, and legacy `@` file search in that order;
- preserve stale file-search clearing with `AppEvent::StartFileSearch(String::new())` when history search starts, history navigation owns the surface, command or mention popups supersede file search, or no token remains;
- preserve command popup gating: slash commands enabled, not bash mode, no file token, no mentions-v2 token, and no `$` mention token;
- preserve command popup dismissal when the cursor leaves the editable command-name token or an `@token` should own the surface;
- preserve legacy file-search popup behavior, including dismissed-file-token suppression, empty prompt behavior, query updates, and `current_file_query` tracking;
- preserve `$` mention popup behavior using the skill/plugin/app catalog and dismissed mention token suppression;
- preserve mentions-v2 behavior: editable `@` token with empty-token support, shared file-search query event, catalog built from skills/plugins, and dismissed mention token suppression;
- keep the evidence deterministic and independent of live terminal rendering, live file search, live input loops, model/tool execution, command execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-36 extends `fixtures/hxrust/tui-smoke.v1.json` and validates the slice through `harness/check-tui-smoke.sh`. No new haxe.rust limitation was exposed. This is deterministic popup synchronization evidence only, not a live file-search or popup UI implementation.

### HXCX-TUI-37: Composer Popup Key Handling Lifecycle

Model selected raw Codex active composer popup key behavior:

- preserve top-level `ChatComposer::handle_key_event` dispatch in `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs`: ignore disabled input/release events, route history search first, dispatch by `ActivePopup`, reset Vim mode after successful dispatch, then call `sync_popups`;
- preserve slash-command popup key handling in `../codex/codex-rs/tui/src/bottom_pane/chat_composer/slash_input.rs`: shortcut overlay ownership, Esc footer hint before dismissal, Up/Ctrl-P and Down/Ctrl-N selection movement, Tab completion or immediate command dispatch, `/` text completion, Enter command dispatch, and no-selection Enter fallback to no-popup handling;
- preserve file popup key handling in `chat_composer.rs`: shortcut overlay ownership, Esc dismissal with the current `@token` stored as `dismissed_file_token`, Up/Down selection movement, Enter/Tab selection acceptance, no-selection Enter fallback to no-popup handling, and selected path insertion;
- preserve selected image behavior without live filesystem probing: upstream calls `image::image_dimensions`, attaches confirmed images, and falls back to text path insertion on errors; fixtures record this as no-live evidence rather than probing real files;
- preserve legacy skill mention popup key handling: selection movement, Esc dismissal with `dismissed_mention_token`, Enter/Tab selected mention insertion, optional path binding, and normal-input fallback;
- preserve mentions-v2 popup key handling: editable-token-gated left/right search-mode switching, Esc dismissal token storage, Tab selection acceptance, Enter selection acceptance, no-selection Enter fallback to no-popup submit handling, file/tool insertion routes, and normal-input fallback;
- keep the evidence deterministic and independent of live terminal rendering, live file search, live image probing, live input loops, model/tool execution, command execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-37 extends `fixtures/hxrust/tui-smoke.v1.json` and validates the slice through `harness/check-tui-smoke.sh`. No new haxe.rust limitation was exposed. This is deterministic active-popup key lifecycle evidence only, not a full live popup UI or terminal input backend.

### HXCX-TUI-38: Composer Popup Layout And Render Lifecycle

Model selected raw Codex active composer popup layout/render behavior:

- preserve `ChatComposer::layout_areas_with_textarea_right_reserve` in `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs`: active popup kind selects `Constraint::Max(required_height)`, no popup uses footer height, and the composer/popup split remains below the input surface;
- preserve `ChatComposer::desired_height` popup contribution and `render_with_mask_and_textarea_right_reserve` render dispatch in `chat_composer.rs`: command, file, skill, and mentions-v2 all delegate to their own `render_ref` implementations;
- preserve command popup height and rows from `../codex/codex-rs/tui/src/bottom_pane/command_popup.rs`: filtered rows, hidden aliases, fixed command column width, wrapped descriptions, `MAX_POPUP_ROWS`, selection clamping, and scroll window visibility;
- preserve legacy file-search popup render facts from `file_search_popup.rs`: empty/loading row reservation, result truncation to `MAX_POPUP_ROWS`, selected match visibility, left inset, and no-live file search evidence;
- preserve skill mention popup render facts from `skill_popup.rs`: filtered mentions sorted by score/rank/name, `visible + 2` height for spacer/footer, single-line row rendering, selected row, scroll window, and standard hint line;
- preserve mentions-v2 popup render facts from `mentions_v2/popup.rs`, `mentions_v2/render.rs`, and `mentions_v2/footer.rs`: fixed `MAX_POPUP_ROWS + 2` height, file-search empty/loading message, selected row visibility, footer mode indicator, and left/right search-mode hint;
- keep the evidence deterministic and independent of live terminal rendering, ratatui buffer mutation, live file search, live input loops, model/tool execution, command execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-38 extends `fixtures/hxrust/tui-smoke.v1.json` and validates the slice through `harness/check-tui-smoke.sh`. No new haxe.rust limitation was exposed. This is deterministic popup layout/render evidence only, not a full ratatui terminal renderer.

### HXCX-TUI-39: Composer Footer Status Hint Render Lifecycle

Model selected raw Codex composer footer/status/hint behavior:

- preserve `FooterProps` and `FooterMode` from `../codex/codex-rs/tui/src/bottom_pane/footer.rs`, including `ComposerEmpty`, `ComposerHasDraft`, `HistorySearch`, `QuitShortcutReminder`, `ShortcutOverlay`, and `EscHint`;
- preserve upstream footer height semantics from `footer_height`: one-line passive/footer modes, the extra queued-prompt line while a draft exists and a task is running, and passive status-line layout overriding ordinary passive footer lines where applicable;
- preserve `ChatComposer::footer_props`, `footer_mode`, `footer_spacing`, and `status_line_text` in `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs`: history search wins, visible quit-shortcut reminders can override base empty/draft mode, expired quit hints fall back to the base mode, and non-empty footer content contributes spacing;
- preserve `render_with_mask_and_textarea_right_reserve` footer fallback behavior when `ActivePopup::None`: cycle hint, shortcut hint, queued-prompt hint, custom footer/status override, status hyperlink annotation, and ordinary footer-line rendering remain distinct traceable decisions;
- preserve quit shortcut hint lifecycle: `show_quit_shortcut_hint`, `clear_quit_shortcut_hint`, and `quit_shortcut_hint_visible` carry explicit visibility/expiry intent without needing wall-clock or terminal effects in fixtures;
- preserve shortcut overlay ownership and paste-burst suppression: `?` can show shortcut overlay from ordinary composer modes, activity resets the footer mode, and active paste bursts suppress the shortcuts hint path;
- preserve collaboration-mode indicator and passive status-line visibility as separate facts from footer mode selection;
- keep the evidence deterministic and independent of live terminal rendering, ratatui buffer mutation, live input loops, model/tool execution, command execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-39 extends `fixtures/hxrust/tui-smoke.v1.json` and validates the slice through `harness/check-tui-smoke.sh`. No new haxe.rust limitation was exposed. This is deterministic footer/status hint render evidence only, not a full ratatui footer renderer.

### HXCX-TUI-40: Composer Textarea Render Mask Highlight Lifecycle

Model selected raw Codex composer textarea render behavior:

- preserve `ChatComposer::layout_areas_with_textarea_right_reserve` in `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs`: the composer rectangle is inset by the live prompt prefix, the explicit textarea right reserve, footer/popup height, and remote-image rows plus separator before the textarea rect is rendered;
- preserve `desired_height_with_textarea_right_reserve`: total height is textarea wrapped height plus remote-image rows, optional separator, composer chrome, and either footer height or active popup height;
- preserve `render_with_mask_and_textarea_right_reserve` textarea dispatch: remote-image lines render above the textarea, the prompt changes for normal, bash, and disabled input states, masked rendering is selected when `mask_char` is present, otherwise normal rendering or styled-highlight rendering is selected;
- preserve generic `TextArea` render helpers in `../codex/codex-rs/tui/src/bottom_pane/textarea.rs`: stateful rendering clamps/effective-scrolls visible wrapped lines, `render_ref_masked` writes mask characters without revealing source text, and `render_ref_styled_with_highlights` overlays render-only highlights without mutating text, cursor, element metadata, or wrapping cache;
- preserve styled element and highlight precedence: element ranges render cyan first, then plugin/history render-only highlights overlay those spans, with history-search matches using reversed bold style;
- preserve placeholder behavior: empty enabled textarea shows the configured placeholder, disabled input shows the disabled placeholder, and the prompt is dimmed when input is disabled;
- preserve cursor visibility rules from `cursor_pos_with_textarea_right_reserve`: hidden when input is disabled or a remote image row is selected, history-search cursor can win, otherwise the textarea cursor uses the reserved layout rect and current textarea scroll state;
- keep the evidence deterministic and independent of live terminal rendering, ratatui buffer mutation, live input loops, model/tool execution, command execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-40 extends `fixtures/hxrust/tui-smoke.v1.json` and validates the slice through `harness/check-tui-smoke.sh`. No new haxe.rust limitation was exposed. This is deterministic textarea render/mask/highlight evidence only, not a full ratatui textarea renderer.

### HXCX-TUI-41: ChatWidget Composer Render Integration

Model selected raw Codex ChatWidget composer integration behavior:

- preserve `ChatWidget::as_renderable` in `../codex/codex-rs/tui/src/chatwidget/rendering.rs`: active cell, renderable active hook cell, and bottom pane are composed in order, and the bottom pane is inset below transcript content;
- preserve ambient right-reserve propagation: `ambient_pet_wrap_reserved_cols()` is applied to active transcript cells and to bottom-pane composer rendering so prompt/input/cursor layout does not collide with right-side ambient UI;
- preserve `BottomPaneComposerReserveRenderable` delegation in `chatwidget/rendering.rs`: `render_with_composer_right_reserve`, `desired_height_with_composer_right_reserve`, `cursor_pos_with_composer_right_reserve`, and `cursor_style_with_composer_right_reserve` stay the bottom-pane ownership boundary;
- preserve `TranscriptAreaRenderable` behavior in `chatwidget/rendering.rs`: active transcript cells get top/right insets, width saturation, bottom-aligned overflow scroll, and desired-height accounting that includes the top spacer;
- preserve `Renderable for ChatWidget`: render delegates through `as_renderable`, records `last_rendered_width`, and delegates desired height, cursor position, and cursor style to the same renderable tree;
- preserve `handle_composer_input_result` in `../codex/codex-rs/tui/src/chatwidget/input_flow.rs`: `Submitted`, `Queued`, `Command`, `ServiceTierCommand`, `CommandWithArgs`, and `None` route to distinct app-level effects;
- preserve immediate-submit versus queue routing: configured session and non-plan-streaming state can submit, shell-only running commands can force queueing, otherwise unconfigured/session-busy/task-running states queue and refresh pending-input preview;
- preserve `maybe_send_next_queued_input` behavior: autosend suppression and pending/running turns block drain, then queued `Plain`, `ParseSlash`, and `RunShell` actions submit at most the next admissible follow-up before preview refresh;
- preserve `pre_draw_tick` and `request_redraw` in `../codex/codex-rs/tui/src/chatwidget.rs`: bottom-pane pre-draw ticks, hook/ambient scheduling, plan/goal/title refreshes, and frame-requester scheduling remain ChatWidget-level handoffs;
- keep the evidence deterministic and independent of live terminal rendering, ratatui buffer mutation, live input loops, model/tool execution, command execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-41 extends `fixtures/hxrust/tui-smoke.v1.json` and validates the slice through `harness/check-tui-smoke.sh`. No new haxe.rust limitation was exposed. This is deterministic ChatWidget composer render integration evidence only, not a full live ChatWidget renderer or input dispatcher.

### HXCX-TUI-42: ChatWidget Active Stream Live-Tail Render

Model selected raw Codex ChatWidget active stream/live-tail behavior:

- preserve `../codex/codex-rs/tui/src/chatwidget/streaming.rs` ownership of assistant, plan, and reasoning deltas, including stream-tail cells, commit ticks, and interrupt deferral;
- preserve `on_agent_message_delta` and `handle_streaming_delta` routing into the agent `StreamController`, plus commit-animation and catch-up tick scheduling when queued lines are accepted;
- preserve `on_plan_delta` behavior: plan-mode gating, `plan_delta_buffer` accumulation, active exec flush before plan stream creation, `PlanStreamController` width/render-mode setup, commit-animation scheduling, active-tail sync, and redraw request;
- preserve `run_commit_tick_with_scope`: stream queues drain through adaptive chunking, committed cells hide the status indicator, visible history is inserted through the same active-cell/history boundary, and active cell revision changes are surfaced for overlay caches;
- preserve `flush_answer_stream_with_separator`: live table tails request required scrollback reflow with deferred history cells, plain tails use ordinary history insertion plus conditional consolidation, active tails are cleared before finalization, and commit animation stops when controllers are idle;
- preserve `on_plan_item_completed`: live plan table tails skip provisional stream history, source-backed proposed-plan cells are inserted from final/streamed plan text, consolidation is requested where needed, and status restoration remains deferred until stream queues are idle;
- preserve `current_stream_width`, `set_raw_output_mode`, and `on_terminal_resize` in `../codex/codex-rs/tui/src/chatwidget.rs`: stream and plan controllers receive wrapper-aware widths, raw/rich render mode changes are propagated to both controllers, active tails are resynced on resize, and first render-width observation schedules redraw;
- preserve transcript overlay live-tail helpers in `chatwidget.rs`: `active_cell_transcript_key` returns revision, stream-continuation, and animation tick; `active_cell_transcript_hyperlink_lines` joins active and hook cells with a separator only when both have visible lines;
- keep the evidence deterministic and independent of live terminal rendering, ratatui buffer mutation, live input loops, model/tool execution, command execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-42 extends `fixtures/hxrust/tui-smoke.v1.json` and validates the slice through `harness/check-tui-smoke.sh`. No new haxe.rust limitation was exposed. This is deterministic ChatWidget active stream/live-tail evidence only, not a full live stream renderer or terminal overlay.

### HXCX-TUI-43: ChatWidget Stream Status Restore And Error Surfaces

Model selected raw Codex ChatWidget stream status behavior:

- preserve `restore_reasoning_status_header` in `../codex/codex-rs/tui/src/chatwidget/streaming.rs`: extract the first bold reasoning header when available, set title kind to thinking, and otherwise restore the working header while a task is running;
- preserve `on_agent_reasoning_delta`: append reasoning text, let unified exec wait suppress status updates while still requesting redraw, and update the status header from the first bold reasoning header when present;
- preserve `on_reasoning_section_break` and `on_agent_reasoning_final`: move buffered reasoning into the full reasoning buffer, insert a history reasoning summary cell on final content, clear transient reasoning buffers, and request redraw;
- preserve `on_agent_message_item_completed` commentary/final restore behavior: pending steers can defer restoration, commentary completion marks pending status restore, and final answers run the same idle-gated restore path;
- preserve `maybe_restore_status_indicator_after_stream_idle`: restore only when pending, task-running, and all stream controllers are idle; ensure the bottom status indicator, restore the current status, and clear the pending flag;
- preserve `run_commit_tick_with_scope`: committed stream cells hide the status indicator, sync live tails, and try idle restoration once controllers drain;
- preserve `on_stream_error`: remember retry status header, ensure the status indicator, set the title kind to thinking, capitalize/preserve status details, and render bounded error detail lines;
- preserve `set_status` and `set_status_header` in `../codex/codex-rs/tui/src/chatwidget/status_controls.rs`: empty details are filtered, details are capitalized, status state and bottom-pane status stay synchronized, and title/status surfaces refresh when configured;
- preserve `run_state_status_text` in `../codex/codex-rs/tui/src/chatwidget/status_surfaces.rs`: startup maps to starting, idle maps to ready, and running states map working/waiting/thinking according to terminal-title status kind;
- keep the evidence deterministic and independent of live terminal rendering, ratatui buffer mutation, live input loops, model/tool execution, command execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-43 extends `fixtures/hxrust/tui-smoke.v1.json` with typed ChatWidget stream status restore/error fixtures and validates the slice through `harness/check-tui-smoke.sh`. No new haxe.rust limitation was exposed. This is deterministic ChatWidget stream status-surface evidence only, not a full live stream renderer, status widget, or terminal overlay.

### HXCX-TUI-44: ChatWidget Stream Interruption And Finish Lifecycle

Model selected raw Codex ChatWidget stream interruption and finish behavior:

- preserve `handle_streaming_delta` in `../codex/codex-rs/tui/src/chatwidget/streaming.rs`: initialize the agent stream controller on first delta, flush active exec/wait state before stream start, queue visible stream lines, start commit animation, run catch-up ticks, sync the active stream tail, and request redraw;
- preserve `defer_or_handle` in `streaming.rs`: when a stream controller exists, or any interrupt is already queued, push additional interruptive UI events into `InterruptManager` so FIFO order is deterministic;
- preserve `flush_interrupt_queue` in `streaming.rs`: temporarily take the manager, flush queued interrupt handlers into `ChatWidget`, and restore the manager after flush;
- preserve `handle_stream_finished` in `streaming.rs`: hide a pending task-complete status indicator, clear the pending flag, and flush interruptive UI events once non-exec stream content has landed;
- preserve `run_commit_tick_with_scope` in `streaming.rs`: committed stream cells hide the status row, sync active tails, restore status only after all controllers are idle, send `StopCommitAnimation`, and refresh runtime metrics while the turn is still running;
- preserve `on_task_complete` in `../codex/codex-rs/tui/src/chatwidget/turn_runtime.rs`: flush answer and plan streams, clear pending status restoration, finish the agent turn lifecycle, update task-running state and status surfaces, clear running command/wait state, and request redraw;
- preserve `finalize_turn` in `turn_runtime.rs`: clear preview-only active stream tails, fail any active cell, finish task state, reset adaptive chunking, clear stream controllers, clear pending status restoration, clear cancel-edit state, refresh status-line branches, and check pending rate-limit prompts;
- preserve ChatWidget state ownership in `../codex/codex-rs/tui/src/chatwidget.rs`: stream controllers, plan stream controller, interrupt manager, task-complete-pending flag, and request-redraw frame scheduling remain ChatWidget-owned boundaries;
- keep the evidence deterministic and independent of live terminal rendering, ratatui buffer mutation, live input loops, model/tool execution, command execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-44 extends `fixtures/hxrust/tui-smoke.v1.json` with typed ChatWidget stream lifecycle fixtures and validates the slice through `harness/check-tui-smoke.sh`. No new haxe.rust limitation was exposed. This is deterministic stream interruption/finish lifecycle evidence only, not a full live stream renderer, interrupt dispatcher, or terminal overlay.

### HXCX-TUI-45: ChatWidget Interrupt Key And Quit Shortcut Lifecycle

Model selected raw Codex ChatWidget interrupt/quit behavior:

- preserve `handle_key_event` in `../codex/codex-rs/tui/src/chatwidget/interaction.rs`: active bottom-pane views receive local key routing first, Ctrl-C reaches `on_ctrl_c`, Ctrl-D reaches `on_ctrl_d`, unrelated press events clear quit shortcut hints, and configured interrupt bindings can interrupt running tasks;
- preserve `on_ctrl_c` in `interaction.rs`: live realtime stop takes precedence, bottom-pane cancellation can consume the key, disabled double-press mode interrupts cancellable work or requests shutdown-first quit, and the latent double-press path arms/matches the quit shortcut before requesting shutdown-first exit;
- preserve `on_ctrl_d` in `interaction.rs`: Ctrl-D participates in quit only when the composer is empty and no modal/popup is active, with the same latent double-press matching behavior as Ctrl-C;
- preserve `arm_quit_shortcut` and `quit_shortcut_active_for` in `interaction.rs`: shortcut state is owned by `ChatWidget`, rendered by `BottomPane`, time-bounded by `QUIT_SHORTCUT_TIMEOUT`, and key-specific so Ctrl-C followed by Ctrl-D cannot accidentally quit;
- preserve pending-steer interrupt routing in `interaction.rs`: configured interrupt keys set `submit_pending_steers_after_interrupt`, submit `AppCommand::interrupt`, and roll the flag back if submission fails; review mode keeps separate steer-unavailable handling;
- preserve `request_quit_without_confirmation` in `../codex/codex-rs/tui/src/chatwidget.rs`: explicit quit paths and double-press shortcuts send `AppEvent::Exit(ExitMode::ShutdownFirst)` rather than submitting a model/tool command;
- preserve `prepare_local_op_submission` in `chatwidget.rs`: prompt-restoring interrupts arm cancel-edit, clear stream and plan stream queues, clear active stream tails, and request redraw while the agent turn is running;
- preserve `BottomPane::on_ctrl_c`, `show_quit_shortcut_hint`, `clear_quit_shortcut_hint`, and `set_interrupt_hint_visible` in `../codex/codex-rs/tui/src/bottom_pane/mod.rs`: local views/history search/composer clearing own local cancellation while process-level quit/interrupt decisions remain in `ChatWidget`;
- preserve shutdown-first app handling in `../codex/codex-rs/tui/src/app/event_dispatch.rs` and `../codex/codex-rs/tui/src/app.rs`: shutdown feedback disables input, pending shutdown thread tracking is set/cleared around current-thread shutdown, and the app exits with `UserRequested` without submitting an `Op::Shutdown`;
- keep the evidence deterministic and independent of live terminal rendering, ratatui buffer mutation, live input loops, model/tool execution, command execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-45 extends `fixtures/hxrust/tui-smoke.v1.json` with typed ChatWidget interrupt/quit shortcut fixtures and validates the slice through `harness/check-tui-smoke.sh`. No new haxe.rust limitation was exposed. This is deterministic interrupt/quit lifecycle evidence only, not a full live keyboard loop, shutdown transport, or terminal overlay.

### HXCX-TUI-46: ChatWidget Interrupted-Turn Notice And Prompt Restore

Model selected raw Codex ChatWidget interrupted-turn restoration behavior:

- preserve `InterruptedTurnNoticeMode`, `CancelEditState`, and `set_interrupted_turn_notice_mode` in `../codex/codex-rs/tui/src/chatwidget.rs`: interrupted-turn notice behavior is explicit state, not implicit renderer text;
- preserve `prepare_local_op_submission` in `chatwidget.rs`: prompt-restoring interrupts arm cancel-edit, clear stream and plan stream queues, clear the active stream tail, and request redraw while work is running;
- preserve `record_cancel_edit_candidate`, `record_visible_turn_activity`, `arm_cancel_edit`, `take_armed_cancel_edit_prompt`, and `clear_cancel_edit` in `../codex/codex-rs/tui/src/chatwidget/input_restore.rs`: cancel-edit restore only fires for interrupted turns whose prompt was eligible, armed, and not invalidated by visible turn activity;
- preserve `on_interrupted_turn` in `input_restore.rs`: interrupted turns finalize active turn state, clear `submit_pending_steers_after_interrupt`, insert the correct notice unless suppressed or cancelled-prompt restore applies, submit pending steers immediately when requested, otherwise restore pending/queued input to the composer, refresh pending-input preview, send `RestoreCancelledTurn` when needed, and request redraw;
- preserve `drain_pending_messages_for_restore` and `restore_user_message_to_composer` in `input_restore.rs`: rejected steers, pending steers, queued follow-ups, composer draft text, local/remote images, and mention bindings are rebased into a composer-ready user message without live model/tool execution;
- preserve `capture_thread_input_state` and `restore_thread_input_state` in `input_restore.rs`: replayed interrupted-turn snapshots can recover queued input deterministically before live input resumes;
- preserve `interrupted_turn_message` and `finalize_turn` in `../codex/codex-rs/tui/src/chatwidget/turn_runtime.rs`: default interrupts show the feedback-oriented interruption message, budget-limited stops show the budget message, and finalization clears active task/stream/status/cancel-edit state;
- preserve replay and cancellation anchors in `../codex/codex-rs/tui/src/app/tests.rs`: interrupted-turn replay restores queued input to composer without auto-submit, and cancelled-turn edit restores the prompt and rolls back the latest turn even for the first local prompt;
- keep the evidence deterministic and independent of live terminal rendering, ratatui buffer mutation, live input loops, model/tool execution, command execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-46 extends `fixtures/hxrust/tui-smoke.v1.json` with typed ChatWidget interrupted-turn notice, cancel-edit restore, queued input restore, pending-steer submission, and no-live evidence fixtures and validates the slice through `harness/check-tui-smoke.sh`. No new haxe.rust limitation was exposed. This is deterministic interrupted-turn restore evidence only, not a full live input loop, live renderer, transport, or terminal overlay.

### HXCX-TUI-47: Side-Conversation Start, Return, And Discard Lifecycle

Model selected raw Codex side-conversation behavior:

- preserve the side-conversation contract in `../codex/codex-rs/tui/src/app/side.rs`: side threads are ephemeral forks for lightweight exploration, inherited history is reference context only, and hidden side developer instructions/boundary prompt prevent the side assistant from continuing the main task by accident;
- preserve `SideParentStatus`, `SideParentStatusChange::for_notification`, and `SideParentStatus::for_request` in `app/side.rs`: parent request/completion/closed/interrupted/failed state is tracked while the side thread is visible and rendered as actionable/non-actionable parent status;
- preserve `sync_side_thread_ui` in `app/side.rs`: normal threads clear side labels, rename blocks, side-active state, and interrupted-turn notice suppression; side threads set the rename block, activate the side context label, suppress interrupted-turn notices, and include parent/main status plus `Ctrl+C to return`;
- preserve `maybe_return_from_side` in `app/side.rs`: side return is only eligible when no overlay is active, no ChatWidget modal/popup is active, the composer is empty, and an active side parent exists;
- preserve `select_agent_thread_and_discard_side`, `discard_side_thread`, `discard_thread_local_state`, `interrupt_side_thread`, and cleanup-failure recovery in `app/side.rs`: returning or navigating away interrupts active/startup side work, unsubscribes from the side thread, aborts listeners, removes event channels, removes side state and navigation state, refreshes approvals or clears the active thread, and keeps the side visible if cleanup fails;
- preserve `handle_start_side`, `side_start_block_message`, `side_start_error_message`, `side_fork_config`, `install_side_thread_snapshot`, and `restore_side_user_message` in `app/side.rs`: start blocks restore the user message to the composer, successful starts fork an ephemeral child with inherited model/effort/service tier plus side developer instructions, inject the hidden side boundary prompt, select the child thread, and submit the initial user message only after switching succeeds;
- preserve `AppEvent::StartSide`, `AppEvent::SelectAgentThread`, and `AppEvent::RestoreCancelledTurn` dispatch anchors in `../codex/codex-rs/tui/src/app/event_dispatch.rs`: side lifecycle remains app-owned and is not pushed into haxe.rust or a ChatWidget-only abstraction;
- preserve related ChatWidget anchors in `../codex/codex-rs/tui/src/chatwidget.rs` and `../codex/codex-rs/tui/src/chatwidget/input_restore.rs`: side activity toggles `InterruptedTurnNoticeMode::Suppress`, blocks rename, updates side context labels, and restores user messages to the composer through the same typed composer restoration path as interrupted input;
- keep the evidence deterministic and independent of live terminal rendering, ratatui buffer mutation, live input loops, model/tool execution, command execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-47 extends `fixtures/hxrust/tui-smoke.v1.json` with typed side-conversation start, parent-status suppression, return/discard, composer restore, and no-live evidence fixtures and validates the slice through `harness/check-tui-smoke.sh`. No new haxe.rust limitation was exposed. This is deterministic side-conversation lifecycle evidence only, not a full live fork transport, thread event listener, renderer, or terminal overlay.

### HXCX-TUI-48: Clear And Archive Lifecycle

Model selected raw Codex clear/archive behavior:

- preserve `AppEvent::ClearUi` and `AppEvent::ClearUiAndSubmitUserMessage` in `../codex/codex-rs/tui/src/app/event_dispatch.rs`: app-event clear paths clear terminal output, reset UI state, and start a fresh session with clear source while optionally submitting the initial user message;
- preserve Ctrl-L handling in `../codex/codex-rs/tui/src/app/input.rs`: clear-only keyboard reset clears terminal output, resets UI state, queues the clear header, and schedules a frame without starting a fresh thread;
- preserve `clear_terminal_ui`, `reset_app_ui_state_after_clear`, and clear-header queueing in `../codex/codex-rs/tui/src/app/history_ui.rs`: clear resets transcript/deferred history/overlay/backtrack/reflow/replay/skill-warning render state while preserving the active thread and composer text;
- preserve skill warning rerender behavior through `../codex/codex-rs/tui/src/app/thread_routing.rs`: warning suppression is cleared by UI reset so an active skill warning can render again after clear;
- preserve `AppEvent::ArchiveCurrentThread`, `archive_current_thread`, and shutdown-first exit handling in `../codex/codex-rs/tui/src/app/event_dispatch.rs`: archive refuses before a thread starts, refuses inside side conversations, requests archive for the current main thread, exits with user-requested intent on success, and records pending shutdown handoff;
- preserve slash-command and plan-implementation event emitters in `../codex/codex-rs/tui/src/chatwidget/slash_dispatch.rs` and `../codex/codex-rs/tui/src/chatwidget/plan_implementation.rs`: `/clear`, `/archive`, and plan implementation stay app-event driven;
- keep the evidence deterministic and independent of live terminal clearing, ratatui rendering, live input loops, app-server mutation, model/tool execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-48 extends `fixtures/hxrust/tui-smoke.v1.json` with typed clear UI reset/session preservation, skill-warning rerender, archive refusal/success/exit intent, shutdown feedback, and no-live evidence fixtures and validates the slice through `harness/check-tui-smoke.sh`. No new haxe.rust limitation was exposed. This is deterministic clear/archive lifecycle evidence only, not live terminal clearing, ratatui rendering, app-server mutation, thread persistence, or model traffic.

### HXCX-TUI-49: Resume And Fork Lifecycle

Model selected raw Codex resume/fork behavior:

- preserve `AppEvent::OpenResumePicker`, `AppEvent::ResumeSessionByIdOrName`, and `AppEvent::ForkCurrentSession` in `../codex/codex-rs/tui/src/app_event.rs` and `../codex/codex-rs/tui/src/app/event_dispatch.rs`: resume/fork stays app-owned and event-driven, not a ChatWidget-only abstraction;
- preserve slash-command dispatch anchors in `../codex/codex-rs/tui/src/chatwidget/slash_dispatch.rs`: `/resume` opens the picker, `/resume <id-or-name>` requests direct session lookup, and `/fork` requests a current-thread fork;
- preserve `run_resume_picker_from_existing_session_with_app_server`, `run_resume_picker_with_app_server`, and `run_fork_picker_with_app_server` in `../codex/codex-rs/tui/src/resume_picker.rs`: picker flows use app-server page loading, alt-screen ownership, show-all/include-non-interactive policy, and deterministic selection outcomes;
- preserve `lookup_session_target_with_app_server`, `resume_target_session`, app-server `thread/fork` intent, current-thread shutdown, chat-widget replacement, queued primary thread session, subagent backfill, notification/file-search refresh, and frame scheduling as typed lifecycle evidence;
- preserve `session_resume.rs` cwd/model resolution anchors without doing live rollout or filesystem reads in the smoke fixture;
- preserve forked-thread display anchors in `../codex/codex-rs/tui/src/chatwidget/session_flow.rs` and `../codex/codex-rs/tui/src/chatwidget/tests/history_replay.rs`: app-server-provided fork parent names win over stale local session-index state;
- keep the evidence deterministic and independent of live terminal takeover, ratatui rendering, live picker input, app-server mutation, rollout reads, filesystem mutation, model/tool execution, network transport, and Cafex behavior.

Status: HXCX-TUI-49 extends `fixtures/hxrust/tui-smoke.v1.json` with typed direct resume lookup/attach, picker-driven fork selection, current-session fork attach intent, missing-target refusal, and no-live/no-filesystem evidence fixtures and validates the slice through `harness/check-tui-smoke.sh`. No new haxe.rust limitation was exposed. This is deterministic resume/fork lifecycle evidence only, not live app-server mutation, live picker rendering, crossterm/ratatui ownership, persistent thread reads, or model traffic.

### HXCX-TUI-50: Terminal Capability Gate And Restore Order

Model the first raw Codex terminal ownership preflight before live crossterm takeover:

- preserve terminal capability gating from `../codex/codex-rs/tui/src/tui.rs`: stdin/stdout terminal checks, setup intent, input flush intent, panic-hook installation, and fail-closed unsupported-terminal evidence are explicit before any live terminal mutation;
- preserve keyboard enhancement decisions from `../codex/codex-rs/tui/src/tui/keyboard_modes.rs`: environment override, WSL/VS Code auto-disable, tmux/CSI-u facts, and reset-after-exit intent stay visible as typed trace data;
- preserve terminal probe scope from `../codex/codex-rs/tui/src/tui/terminal_probe.rs`: keyboard-support evidence is treated as a startup capability fact, not as an implicit renderer side effect;
- preserve stderr guard/restore intent from `../codex/codex-rs/tui/src/tui/terminal_stderr.rs` and restore-after-exit ordering from `tui.rs`: bracketed paste, focus-change, cursor style/show, raw mode, keyboard reporting, and stderr finish are restored even when setup refuses live ownership;
- keep the evidence deterministic and independent of live crossterm raw mode, ratatui rendering, alternate-screen takeover, live input loops, app-server mutation, model/tool execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-50 extends `fixtures/hxrust/tui-smoke.v1.json` with a terminal capability gate and restore-after-exit fixture and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic terminal preflight/restore evidence only, not live crossterm/ratatui terminal ownership.

### HXCX-TUI-51: Terminal Title Sanitization And Cache Lifecycle

Model selected raw Codex terminal-title behavior without writing OSC sequences:

- preserve the low-level title boundary in `../codex/codex-rs/tui/src/terminal_title.rs`: untrusted title text is sanitized before use, control characters and bidi/invisible formatting characters are stripped, whitespace runs collapse, and output is bounded by the configured title character cap;
- preserve title write policy from `terminal_title.rs`: stdout-not-a-terminal is treated as applied/no-op evidence, no-visible-content is distinct from clearing, and live OSC writes remain disabled in the smoke fixture;
- preserve ChatWidget cache behavior from `../codex/codex-rs/tui/src/chatwidget/status_surfaces.rs`: duplicate sanitized titles skip redundant writes, empty selections clear the managed title, and no-visible-content clears the title managed by Codex rather than restoring an unknown shell title;
- preserve invalid terminal-title config reporting as typed evidence without letting invalid items poison the upstream-shaped core or produce live terminal side effects;
- keep the evidence deterministic and independent of live OSC title writes, ratatui rendering, alternate-screen takeover, live input loops, app-server mutation, model/tool execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-51 extends `fixtures/hxrust/tui-smoke.v1.json` with typed terminal-title sanitize/cache/clear evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic title-boundary evidence only, not live terminal title ownership.

### HXCX-TUI-52: Desktop Notification Backend And Focus Gate

Model selected raw Codex desktop-notification behavior without posting live terminal notifications:

- preserve notification emission gating from `../codex/codex-rs/tui/src/tui.rs`: `NotificationCondition::Unfocused` suppresses notifications while focused and emits when unfocused, while `Always` emits regardless of focus state;
- preserve focus-state ownership from `../codex/codex-rs/tui/src/tui/event_stream.rs`: focus gained/lost events update the shared terminal-focused flag used by notification decisions;
- preserve backend selection from `../codex/codex-rs/tui/src/notifications/mod.rs`: explicit `osc9`/`bel` methods choose their matching backend, and `auto` chooses OSC 9 only for supported terminals with BEL fallback otherwise;
- preserve low-level ANSI formatting boundaries from `../codex/codex-rs/tui/src/notifications/osc9.rs` and `../codex/codex-rs/tui/src/notifications/bel.rs`: OSC 9 tmux DCS passthrough doubles ESC bytes inside the payload, and BEL emits without inspecting the message body;
- preserve ChatWidget notification handoff anchors from `../codex/codex-rs/tui/src/chatwidget/notifications.rs`: pending notifications are coalesced before `Tui::notify`, and failed backend notification attempts disable future notification backend use;
- keep the evidence deterministic and independent of live OSC/BEL writes, ratatui rendering, alternate-screen takeover, live input loops, app-server mutation, model/tool execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-52 extends `fixtures/hxrust/tui-smoke.v1.json` with typed desktop-notification backend/focus/escape evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic notification-boundary evidence only, not live terminal notification delivery.

### HXCX-TUI-53: Terminal Hyperlink OSC 8 Boundary

Model selected raw Codex terminal-hyperlink behavior without writing live OSC 8 bytes:

- preserve the semantic hyperlink boundary in `../codex/codex-rs/tui/src/terminal_hyperlinks.rs`: hyperlinks are carried separately from visible text so OSC 8 bytes do not affect layout, width, or wrapping decisions;
- preserve destination filtering from `web_destination`: only `http` and `https` URLs with a host receive OSC 8 decoration, and control characters are removed from destinations before terminal output is assembled;
- preserve URL discovery behavior from `web_links_in_text`: leading punctuation and unmatched trailing punctuation are excluded from hyperlink columns while balanced URL punctuation remains part of the destination;
- preserve OSC 8 decoration/stripping behavior from `osc8_hyperlink` and `strip_osc8`: visible text round-trips after hyperlink decoration and terminal-control bytes stay outside snapshot geometry;
- preserve prefix/remap behavior from `prefix_hyperlink_lines` and wrapped-line remapping: hyperlink column ranges move with display prefixes instead of being recomputed from decorated terminal bytes;
- keep the evidence deterministic and independent of live OSC 8 terminal output, ratatui buffer mutation, alternate-screen takeover, live input loops, app-server mutation, model/tool execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-53 extends `fixtures/hxrust/tui-smoke.v1.json` with typed terminal-hyperlink sanitize/discover/decorate/strip/remap evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic hyperlink-boundary evidence only, not live terminal hyperlink rendering.

### HXCX-TUI-54: Terminal Palette OSC 10/11 Probe

Model selected raw Codex terminal-palette probe behavior without sending live terminal queries:

- preserve OSC 10/11 parser behavior from `../codex/codex-rs/tui/src/tui/terminal_probe.rs`: foreground and background responses can be parsed from one buffer in either order, with BEL and ST terminators both accepted;
- preserve RGB/RGBA component parsing from `terminal_probe.rs`: two-digit components map directly, four-digit components divide by 257, and malformed, partial, or unterminated payloads are refused;
- preserve paired default-color semantics from `parse_default_colors`: foreground and background are only useful as a pair, so a missing or malformed side yields no default palette result;
- preserve startup/cache handoff from `../codex/codex-rs/tui/src/tui.rs` and `../codex/codex-rs/tui/src/terminal_palette.rs`: startup probe results populate the palette cache, unavailable results are recorded as attempted, and focus-triggered requery does not retry a cache that already attempted and failed;
- keep the evidence deterministic and independent of live OSC 10/11 writes, direct tty reads, crossterm color queries, ratatui rendering, alternate-screen takeover, live input loops, app-server mutation, model/tool execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-54 extends `fixtures/hxrust/tui-smoke.v1.json` with typed terminal-palette OSC parser/cache evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic palette-probe evidence only, not live terminal color querying.

### HXCX-TUI-55: Terminal Startup Probe Boundary

Model selected raw Codex startup terminal-probe behavior without owning live terminal input:

- preserve bounded startup probe scope from `../codex/codex-rs/tui/src/terminal_probe.rs`: cursor position, OSC 10/11 default colors, and keyboard enhancement support are queried under one caller-provided deadline before crossterm starts;
- preserve handle selection from `terminal_probe.rs`: duplicated stdio is preferred, `/dev/tty` is a fallback when stdio is redirected or unavailable, reader nonblocking flags are restored, and failures fall back instead of blocking startup;
- preserve batched response parsing from `update_startup_probe`: cursor position uses terminal one-based rows/columns mapped to zero-based positions, OSC foreground/background can arrive in either order, and keyboard support can be detected alongside terminal fallback responses;
- preserve incomplete/timeout semantics: missing cursor, missing paired default colors, or missing keyboard response remain optional probe facts, not startup failures;
- keep the evidence deterministic and independent of live terminal probe writes, direct tty reads, crossterm event queues, ratatui rendering, alternate-screen takeover, live input loops, app-server mutation, model/tool execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-55 extends `fixtures/hxrust/tui-smoke.v1.json` with typed terminal startup-probe parse/timeout/handle-source evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic startup-probe evidence only, not live terminal probing.

### HXCX-TUI-56: Clipboard Copy Routing Boundary

Model selected raw Codex clipboard-copy behavior without touching real clipboards or terminal output:

- preserve backend selection from `../codex/codex-rs/tui/src/clipboard_copy.rs`: SSH sessions use terminal-mediated copy, local sessions try native clipboard first, WSL sessions fall back to PowerShell after native failure, and terminal copy prefers tmux before OSC 52;
- preserve `ClipboardLease` ownership evidence from `clipboard_copy.rs`: Linux/native clipboard success may require a lease to keep clipboard contents alive, while OSC 52, tmux, and WSL paths do not;
- preserve tmux readiness checks from `tmux_clipboard_copy_ready`: `set-clipboard=off` and missing `Ms` capability refuse tmux native forwarding before falling back;
- preserve OSC 52 sequence constraints from `osc52_sequence`: payloads are base64 encoded, bounded by `OSC52_MAX_RAW_BYTES`, and tmux sessions wrap the OSC 52 sequence in DCS passthrough;
- keep the evidence deterministic and independent of live clipboard writes, `/dev/tty` or stdout writes, tmux/PowerShell process spawning, native GUI clipboard handles, ratatui rendering, app-server mutation, model/tool execution, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-56 extends `fixtures/hxrust/tui-smoke.v1.json` with typed clipboard route, tmux readiness, OSC 52 shaping, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic clipboard-boundary evidence only, not live clipboard ownership.

### HXCX-TUI-57: Clipboard Paste Image Intake Boundary

Model selected raw Codex clipboard-paste image behavior without touching real clipboards, processes, or filesystems:

- preserve image intake anchors from `../codex/codex-rs/tui/src/clipboard_paste.rs`: native paste prefers clipboard file-list image paths when available, otherwise encodes clipboard image bytes as PNG, maps `ClipboardUnavailable`, `NoImage`, `EncodeFailed`, and `IoError`, and reports `PNG`, `JPEG`, or generic `IMG` labels;
- preserve WSL fallback intent from `clipboard_paste.rs`: only WSL sessions with native clipboard unavailability or no-image errors try PowerShell/Pwsh fallback, and returned Windows temp paths are converted to WSL `/mnt/<drive>/...` paths before composer handoff;
- preserve composer handoff from `../codex/codex-rs/tui/src/bottom_pane/chat_composer/attachment_state.rs` and `chat_composer.rs`: accepted local images insert stable `[Image #N]` placeholders, numbering accounts for existing remote and local attachments, and local attachment counts advance only when a placeholder is inserted;
- preserve refusal evidence for no image, unsupported payloads, and oversized payloads without synthesizing live clipboard contents;
- keep the evidence deterministic and independent of live clipboard reads, arboard/native GUI handles, PowerShell/Pwsh process spawning, temp-file writes, image decoding, ratatui rendering, app-server mutation, model/tool execution, network transport, and Cafex behavior.

Status: HXCX-TUI-57 extends `fixtures/hxrust/tui-smoke.v1.json` with typed clipboard paste probes, image acceptance, WSL path conversion, refusal cases, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic image-intake evidence only, not live clipboard or filesystem ownership.

### HXCX-TUI-58: Composer Paste-Burst Handoff Boundary

Model selected raw Codex composer paste-burst behavior without owning live terminal input or filesystem/image probing:

- preserve `PasteBurst` timing and classification anchors from `../codex/codex-rs/tui/src/bottom_pane/paste_burst.rs`: ASCII first-char hold, fast-char buffering, Enter capture during an active burst, active idle flush, non-char flush/clear behavior, and the recommended follow-up tick delay;
- preserve `ChatComposer::handle_paste` handoff from `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs`: explicit paste normalizes text, small paste inserts directly, large paste stores pending payloads behind `[Pasted Content N chars]` placeholders, duplicate-size placeholders use `#2`, `#3`, and explicit paste clears transient burst state;
- preserve image-path handoff evidence from `handle_paste_image_path` and attachment state: image-like paths may become local `[Image #N]` attachments when dimensions are available, while headless smoke fixtures do not perform real image probing;
- preserve `ChatWidget::handle_paste_burst_tick` scheduling from `../codex/codex-rs/tui/src/chatwidget/interaction.rs`: a flushed burst requests immediate redraw, while still-active bursts schedule a delayed follow-up and skip redundant rendering;
- keep the evidence deterministic and independent of live terminal key streams, live clipboard reads, process spawning, image decoding, filesystem mutation/probing, ratatui rendering, app-server mutation, model/tool execution, network transport, and Cafex behavior.

Status: HXCX-TUI-58 extends `fixtures/hxrust/tui-smoke.v1.json` with typed paste-burst timing, small/large paste handoff, duplicate placeholder numbering, image placeholder handoff, follow-up scheduling, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic composer handoff evidence only, not live terminal/clipboard ownership.

### HXCX-TUI-59: ChatWidget Input Submission Item Assembly Boundary

Model selected raw Codex `ChatWidget` submission assembly behavior without live app/model dispatch:

- preserve `user_message_from_submission` anchors from `../codex/codex-rs/tui/src/chatwidget/input_submission.rs`: submitted drafts drain local images, remote image URLs, text elements, and mention bindings from the bottom pane into a `UserMessage`;
- preserve `submit_user_message_with_history_and_shell_escape_policy` item ordering: remote image `UserInput::Image` items are emitted before local image `UserInput::LocalImage`, then text, then skill/app/plugin mention-derived items;
- preserve shell escape behavior: `!cmd` diverts to a user shell command when shell escape is allowed, while empty shell commands show help instead of model submission;
- preserve fail-closed restoration behavior: empty submissions suppress before dispatch, image submissions restore the draft when the current model lacks image support, and unavailable/empty effective model names restore the composed message with mention bindings intact;
- preserve post-submit side effects as deterministic facts: user-turn construction, model name, optional collaboration mode/IDE context, history recording, pending steer/display/cancel-edit decisions, and queueing before session configuration;
- keep the evidence deterministic and independent of live app command dispatch, model/provider calls, shell execution, filesystem mutation, terminal rendering, app-server mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-59 extends `fixtures/hxrust/tui-smoke.v1.json` with typed `UserInput` item ordering, shell diversion, queue-before-session, blocked-image/model-unavailable restoration, empty suppression, and no-live dispatch evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic submission assembly evidence only, not live model/app dispatch.

### HXCX-TUI-60: ChatWidget Input Queue State Boundary

Model selected raw Codex `ChatWidget` input queue behavior without live app/model dispatch:

- preserve `InputQueueState` anchors from `../codex/codex-rs/tui/src/chatwidget/input_queue.rs`: queued user messages, queued-message history records, rejected steer queue/history records, pending steers, `user_turn_pending_start`, `submit_pending_steers_after_interrupt`, and `suppress_queue_autosend` stay as explicit state facts;
- preserve pending-input preview category separation from `input_queue.rs`: queued messages, pending steers, and rejected steers render into distinct preview buckets, with missing history records falling back to user-message text while pending steers use their committed history record and compare key;
- preserve follow-up detection: queued user messages and rejected steers both count as queued follow-up work;
- preserve clear/reset semantics: `clear()` drains queued messages/history, rejected steers/history, pending steers, `user_turn_pending_start`, and `submit_pending_steers_after_interrupt`, while autosend suppression is not cleared by that method;
- preserve queue-drain gates from `../codex/codex-rs/tui/src/chatwidget/input_flow.rs`: autosend suppression, pending/running turns, and bottom-pane task state can block draining; when modal/popup state clears and the queue is idle, at most one queued input is drained and the pending preview is refreshed;
- keep the evidence deterministic and independent of live app command dispatch, model/provider calls, shell execution, filesystem mutation, terminal rendering, app-server mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-60 extends `fixtures/hxrust/tui-smoke.v1.json` with typed queued/pending/rejected preview separation, missing-history fallback, follow-up detection, clear/reset flags, autosend suppression preservation, modal-cleared drain intent, pending/running drain gates, and no-live dispatch evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic input queue state evidence only, not live model/app dispatch.

### HXCX-TUI-61: ChatWidget Queue Restore Operation Boundary

Model selected raw Codex queue pop and composer-restore behavior without live app/model dispatch:

- preserve `pop_next_queued_user_message` anchors from `../codex/codex-rs/tui/src/chatwidget/input_restore.rs`: rejected steers drain before ordinary queued messages, all rejected steers merge into one queued follow-up, missing history records fall back to `UserMessageText`, and ordinary queued messages drain FIFO from the front;
- preserve `pop_latest_queued_user_message` and edit-queued-message anchors from `input_restore.rs` and `../codex/codex-rs/tui/src/chatwidget/interaction.rs`: ordinary queued messages restore LIFO from the back before rejected steers, history overrides replace the restored composer text, and the pending-input preview refreshes after edit restore;
- preserve `drain_pending_messages_for_restore` ordering from `input_restore.rs`: rejected steers, pending steers, queued follow-ups, and current composer draft merge in that order, with no outbound model/tool submission during interrupted-turn restore;
- preserve user-message shape helpers from `../codex/codex-rs/tui/src/chatwidget/user_messages.rs`: history overrides apply only when non-empty, preview/restore fall back to raw message text otherwise, text element byte ranges rebase during merge, and local image placeholders are remapped after remote-image labels so restored composer state matches attachment order;
- preserve `restore_user_message_to_composer` state handoff: restored text, local image paths, remote image URLs, text elements, mention bindings, and cursor-at-end intent survive the restore operation;
- keep the evidence deterministic and independent of live terminal input, ratatui rendering, app command dispatch, model/provider calls, shell execution, filesystem mutation, app-server mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-61 extends `fixtures/hxrust/tui-smoke.v1.json` with typed queue pop, history fallback/override, ordered merge, placeholder remap, text-element rebase, mention preservation, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic queue restore operation evidence only, not live model/app dispatch.

### HXCX-TUI-62: ChatWidget Thread Input State Restore Boundary

Model selected raw Codex thread-input snapshot behavior without live app/model dispatch:

- preserve `capture_thread_input_state` anchors from `../codex/codex-rs/tui/src/chatwidget/input_restore.rs`: composer text, local images, remote images, text elements, mention bindings, pending pastes, pending steers/history/compare keys, rejected steers/history, queued messages/history, `user_turn_pending_start`, collaboration mode, active collaboration mask, task-running, and agent-turn-running state are captured together;
- preserve `restore_thread_input_state(Some(..))`: collaboration mode and active mask are restored, model-dependent surfaces refresh, composer content and pending pastes are restored, missing pending/rejected/queued history records are resized to `UserMessageText`, missing pending-steer compare keys fall back to message/image counts, pending preview refreshes, and redraw is requested;
- preserve `restore_thread_input_state(None)`: running state is cleared, input queues are cleared, remote images and composer/pending-paste state reset, pending preview refreshes, and redraw is requested;
- preserve `TurnLifecycleState::restore_running` anchors from `../codex/codex-rs/tui/src/chatwidget/turn_lifecycle.rs`: agent-turn-running, goal-status start time, and sleep-inhibitor turn-running state stay synchronized during restore;
- preserve the upstream task-running nuance: restored `task_running` can keep the bottom pane working even when the agent-running flag alone would not, and status surfaces refresh when that fallback is applied;
- keep the evidence deterministic and independent of live terminal input, sleep-inhibitor OS handles, ratatui rendering, app command dispatch, model/provider calls, shell execution, filesystem mutation, app-server mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-62 extends `fixtures/hxrust/tui-smoke.v1.json` with typed thread-input capture, restore(Some), restore(None), collaboration-mode, queue-history, compare-key, task-running, sleep-inhibitor, pending-preview, redraw, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic thread input state evidence only, not live model/app dispatch.

### HXCX-TUI-63: ChatWidget MCP Startup Status Boundary

Model selected raw Codex MCP startup state handling without live app/model dispatch:

- preserve `update_mcp_startup_status` anchors from `../codex/codex-rs/tui/src/chatwidget/mcp_startup.rs`: active startup rounds record per-server `Starting`, `Ready`, `Failed`, and `Cancelled` states; duplicate failures with the same error suppress duplicate warnings; startup headers show single-server booting text or multi-server completed/total progress;
- preserve expected-server completion semantics: app-server-backed startup only completes automatically when every expected server has reported a non-starting state, then failed and cancelled server names are sorted into summary warnings;
- preserve `finish_mcp_startup_after_lag`: active partial rounds settle by treating missing or still-starting expected servers as cancelled, include runtime servers not present in the expected set, and switch to ignore-until-next-start mode after finishing;
- preserve stale-update protection: after a finish, updates buffer into a pending next round and do not reopen task-running status until the pending map is coherent enough to promote;
- preserve terminal-only next-round allowance: a lag finish while ignoring updates can allow a full non-starting pending round to promote, so terminal-provided ready/failure events still settle correctly;
- preserve status/task side effects: MCP startup contributes to bottom-pane task-running state, restores previous working/review status only when appropriate, attempts queued-input drain after finish, requests redraw for active state changes, and never performs live terminal/model/tool effects in the smoke fixture.

Status: HXCX-TUI-63 extends `fixtures/hxrust/tui-smoke.v1.json` with typed expected-server setup, status updates, warning dedupe, lag finish, stale update buffering, terminal-only pending-round promotion, finish summaries, task-running/status, queued-drain intent, redraw, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic MCP startup state evidence only, not live app-server transport or MCP process startup.

### HXCX-TUI-64: ChatWidget Status Surface Boundary

Model selected raw Codex status-line and terminal-title refresh behavior without live terminal rendering:

- preserve `StatusSurfaceSelections` anchors from `../codex/codex-rs/tui/src/chatwidget/status_surfaces.rs`: status-line and terminal-title configured item lists parse together, invalid item warnings are emitted once per thread, and branch/git-summary needs are derived from both surfaces before either one is refreshed;
- preserve shared-state sync: when configured surfaces no longer use git branch or git summary fields, cached branch/summary values and pending lookup flags reset; when they do use them, pending refreshes are requested only when the lookup is not already complete;
- preserve status-line refresh behavior: empty configured status-line selections disable and clear the line, rendered segments derive only from available selected values, and pull-request hyperlinks are attached only when the PR-number item is selected and a URL exists;
- preserve terminal-title refresh behavior: empty selections clear the managed title, duplicate sanitized titles skip redundant writes while preserving animation scheduling, and no-visible-content clears Codex-managed terminal title state;
- preserve `../codex/codex-rs/tui/src/chatwidget/status_controls.rs` setup paths: `set_status` refreshes status surfaces only when the terminal title config depends on run-state/status, status-line setup persists explicit item IDs, terminal-title preview snapshots original config, preview revert restores it, and setup commits the selected title items;
- keep the evidence deterministic and independent of live terminal writes, ratatui rendering, app-server mutation, filesystem/git probing, model/provider calls, network transport, and Cafex behavior.

Status: HXCX-TUI-64 extends `fixtures/hxrust/tui-smoke.v1.json` with typed status-surface selection, invalid-warning dedupe, branch/git-summary request/reset, line/hyperlink/title refresh, duplicate/empty/no-visible title handling, setup/preview/revert/commit, stale update ignoring, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic status-surface state evidence only, not live terminal title/status-line ownership.

### HXCX-TUI-65: ChatWidget Status State Boundary

Model selected raw Codex status indicator state without live widget rendering:

- preserve `StatusIndicatorState::working` and `StatusState::default` anchors from `../codex/codex-rs/tui/src/chatwidget/status_state.rs`: the initial status is `Working`, uses `STATUS_DETAILS_DEFAULT_MAX_LINES`, starts with an empty pending guardian-review set, and maps terminal-title status to `Working`;
- preserve `TerminalTitleStatusKind` as the compact title vocabulary: `Working`, `WaitingForBackgroundTerminal`, and default `Thinking` stay separate from the richer status-header text used by footer/status widgets;
- preserve `PendingGuardianReviewStatus::start_or_update`: repeated ids update in place, one pending review renders a single-review header/detail/max-line shape, parallel reviews aggregate count/detail lines, and more than three details emit an overflow row;
- preserve `PendingGuardianReviewStatus::finish` and `status_indicator_state`: removing a missing id reports no change, removing existing ids changes the aggregate, and an empty set returns no guardian-specific status;
- preserve `StatusState::remember_retry_status_header` and `take_retry_status_header`: the retry header snapshots the current status only while empty and can be consumed exactly once;
- keep the evidence deterministic and independent of live ratatui rendering, terminal writes, app-server mutation, model/provider calls, network transport, filesystem/git probing, and Cafex behavior.

Status: HXCX-TUI-65 extends `fixtures/hxrust/tui-smoke.v1.json` with typed status defaulting, status replacement, guardian review aggregation/update/finish, terminal-title status buckets, retry-header remember/take-once behavior, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic status-state evidence only, not live status-widget rendering.

### HXCX-TUI-66: ChatWidget Command Lifecycle Boundary

Model selected raw Codex command lifecycle bookkeeping without live process execution:

- preserve `../codex/codex-rs/tui/src/chatwidget/exec_state.rs` helpers: unified exec startup/interaction sources are recognized as unified sources, standard parsed tool calls are separated from unknown command shapes, unified wait streaks keep the first non-empty command display, and duplicate wait displays can be suppressed;
- preserve `track_unified_exec_process_begin`, `track_unified_exec_output_chunk`, `track_unified_exec_process_end`, and footer sync from `../codex/codex-rs/tui/src/chatwidget/command_lifecycle.rs`: process ids fall back to call ids, shell wrappers are reduced into command displays, recent output chunks keep only the last three non-empty lines, and the bottom-pane footer mirrors the active process list;
- preserve command start gating: unified exec startup tracks the process before display decisions, hidden status indicators are restored while a task is running, unknown unified exec commands keep status visible without materializing a standard tool-call cell, and duplicate unified wait interactions suppress repeated exec rows;
- preserve terminal interaction behavior: empty stdin means background polling and updates the waiting status plus wait streak, non-empty stdin flushes a matching wait streak into history and records the interaction, and post-task-complete interactions are suppressed;
- preserve command completion targets: active tracked calls complete their current exec cell, orphan completion while another active exec cell is running inserts standalone history, end-without-begin builds a new cell from the event payload, unified exec completion after task complete is suppressed, and user-shell completion can request queued-input drain;
- keep the evidence deterministic and independent of live shell/process spawning, terminal input, ratatui rendering, app-server mutation, model/provider calls, filesystem mutation, network transport, and Cafex behavior.

Status: HXCX-TUI-66 extends `fixtures/hxrust/tui-smoke.v1.json` with typed unified exec process tracking, recent-output trimming, start gating, wait streak updates, duplicate wait suppression, active/orphan/new completion targets, task-complete suppression, user-shell drain intent, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic command lifecycle state evidence only, not live command execution or full exec-cell rendering.

### HXCX-TUI-67: ChatWidget Tool Lifecycle Boundary

Model selected raw Codex non-command tool lifecycle bookkeeping without live tool execution:

- preserve `../codex/codex-rs/tui/src/chatwidget/tool_lifecycle.rs` patch/file-change behavior: patch begin records visible turn activity and adds an edited-files history cell, successful file-change completion only marks work activity, and failed completion adds a patch failure history cell;
- preserve view-image and image-generation surfaces: view-image flushes answer stream, records the image call, and requests redraw; image generation begin flushes answer stream and end records revised prompt/saved path history;
- preserve MCP tool call lifecycle: start flushes answer/active cells and installs an active MCP cell, completion maps success/error/missing-result into the cell result, matched active cells complete in place, unmatched completion creates a new active cell before flushing, optional extra cells are inserted, and work activity is recorded;
- preserve web search lifecycle: begin installs an active web-search cell, matched end updates/completes/flushes it, unmatched end adds a standalone history cell, and completed searches mark work activity;
- preserve collaborator tool/activity behavior: plain collab events flush answer stream and redraw, spawn-agent in-progress caches spawn summaries, non-in-progress spawn results remove cached summaries, and sub-agent activity delegates to collab event insertion when a history cell exists;
- preserve queued item dispatch: queued command/MCP starts and command/file-change/MCP completions route to the same immediate handlers already covered by command and tool lifecycle slices;
- keep the evidence deterministic and independent of live tool execution, filesystem mutation, image decoding, MCP/network calls, app-server mutation, model/provider calls, ratatui rendering, and Cafex behavior.

Status: HXCX-TUI-67 extends `fixtures/hxrust/tui-smoke.v1.json` with typed patch/file-change, view-image, image-generation, MCP tool, web-search, collaborator, sub-agent, queued-dispatch, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic tool lifecycle state evidence only, not live tool execution or full transcript cell rendering.

### HXCX-TUI-68: ChatWidget Hook Lifecycle Boundary

Model selected raw Codex hook lifecycle and hooks browser bookkeeping without live hook execution:

- preserve `../codex/codex-rs/tui/src/chatwidget/hook_lifecycle.rs` start behavior: visible turn activity is recorded, answer/completed hook output is flushed before display, an existing active hook cell receives the run in place, otherwise a new active hook cell is created, the active-cell revision is bumped, and redraw is requested;
- preserve hook completion paths: matched active runs complete in place, unmatched completions can be added to an existing active cell, no-active completions can create a completed hook cell, empty completed cells can be discarded, completed persistent output is flushed, idle active cells are finished, and redraw is requested;
- preserve completed-output and idle finishing behavior: completed persistent runs are taken into history, empty active hook cells are cleared, inserted history requests the final-message separator, and `should_flush` active cells are moved into history;
- preserve timer/visibility scheduling: due visibility advances can bump the active-cell revision and finish idle cells, visible running hooks schedule a short frame delay, and pending hook-cell deadlines schedule future frames;
- preserve `../codex/codex-rs/tui/src/chatwidget/hooks.rs` list behavior: hooks output sends a fetch request for the current cwd, stale loaded results are ignored, errors insert an error message, successful loads open the hooks browser entry, and opening the browser requests redraw;
- keep the evidence deterministic and independent of live hook execution, filesystem mutation, ratatui rendering, app-server mutation, model/provider calls, network transport, and Cafex behavior.

Status: HXCX-TUI-68 extends `fixtures/hxrust/tui-smoke.v1.json` with typed hook start/completion, completed-output flush, idle finish, visibility/timer scheduling, hooks list fetch/load/browser, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic hook lifecycle state evidence only, not live hook execution or full hook-cell rendering.

### HXCX-TUI-69: ChatWidget Input Submission Boundary

Model selected raw Codex input submission and turn lifecycle bookkeeping without live model, shell, or UI effects:

- preserve `../codex/codex-rs/tui/src/chatwidget/turn_lifecycle.rs`: start/finish/restore update agent-turn state, goal-status timing, and sleep-inhibitor state together; reset clears current turn and budget-limited ids; prevent-idle changes rebuild the inhibitor while preserving the active running state; budget-limited turn ids are consumed once;
- preserve `../codex/codex-rs/tui/src/chatwidget/input_flow.rs` queue decisions: submitted composer input is ignored when empty, queued before session configuration or while a turn is pending/running, queued while plan streaming, and submitted immediately only when the session is configured and not blocked by an active user-shell-only turn;
- preserve `../codex/codex-rs/tui/src/chatwidget/input_submission.rs` shell escape behavior: empty `!` commands insert shell-help history and continue queue drain, non-empty allowed shell commands submit a user-shell command plus history, and disallowed shell escapes become ordinary user-turn text;
- preserve blocked image submission handling: image-bearing input is refused when the active model lacks image support, the composed text/elements/local images/remote URLs/mention bindings are restored to the composer, a warning history cell is added, and redraw is requested;
- preserve user-turn assembly from `../codex/codex-rs/tui/src/chatwidget/user_messages.rs`: remote images, local images, text elements, skill mentions, plugin mentions, app mentions, dedupe, encoded history mentions, IDE context, service/collaboration metadata, pending steers, cancel-edit candidates, final-message separator clearing, and history display gating by active turn;
- keep the evidence deterministic and independent of live process spawning, filesystem mutation, ratatui rendering, app-server mutation, credentialed model/provider calls, network transport, and Cafex behavior.

Status: HXCX-TUI-69 extends `fixtures/hxrust/tui-smoke.v1.json` with typed turn lifecycle, composer submission, pre-session queueing, empty refusal, blocked-image restore, shell escape, user-input assembly, mention routing, submit-turn, pending-steer, history-render, queue-drain, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic input submission state evidence only, not live shell execution, model submission, or full composer rendering.

### HXCX-TUI-70: ChatWidget Turn Runtime Boundary

Model selected raw Codex task runtime bookkeeping without live model, shell, terminal, or notification effects:

- preserve `../codex/codex-rs/tui/src/chatwidget/turn_runtime.rs` task-running derivation: bottom-pane running state is derived from agent-turn and MCP-startup state, then plan-mode nudges and status surfaces are refreshed;
- preserve task start reset behavior: pending-start is cleared, turn lifecycle starts, transcript/adaptive chunking/plan streams/runtime metrics/session telemetry/reasoning/quit hints are reset, active hook cells are cleared, interrupt hint and terminal-title status switch to working, status header ownership is respected, ambient pet state changes, and redraw is requested;
- preserve runtime metrics handling: collected deltas merge into turn totals, websocket timing deltas add visible history, and final-message separators can include elapsed time plus accumulated runtime metrics;
- preserve task completion behavior: last-agent markdown is only recorded when no item-level copy source exists, notification text falls back through the item copy source, active answer/plan streams and unified exec wait streaks are finalized, final separator insertion is gated by work/runtime state, status-line branch/git summary refreshes are requested, running command state is cleared, pending previews refresh, queued follow-ups and active goals suppress completion notifications, plan implementation prompts are gated, and pending rate-limit prompts can be shown;
- preserve `../codex/codex-rs/tui/src/chatwidget/notifications.rs` and `warnings.rs`: notification allow-lists and priority replacement avoid lower-priority overwrites, pending notifications post display text once, fallback model metadata warnings dedupe by model slug, and warning/error/rate-limit paths finalize the turn before queuing follow-up input;
- keep the evidence deterministic and independent of live process spawning, filesystem mutation, ratatui rendering, app-server mutation, credentialed model/provider calls, network transport, OS desktop notifications, and Cafex behavior.

Status: HXCX-TUI-70 extends `fixtures/hxrust/tui-smoke.v1.json` with typed task-running, task-start, runtime-metrics, task-completion, cleanup, follow-up, plan-prompt, rate-limit-prompt, notification, warning, finalize/error, plan-update, interrupted-message, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic turn runtime state evidence only, not live model/provider submission, desktop notification delivery, or full runtime ownership.

### HXCX-TUI-71: ChatWidget Session Flow Boundary

Model selected raw Codex session configuration and thread-header behavior without live filesystem, network, model, or render effects:

- preserve `../codex/codex-rs/tui/src/chatwidget/session_flow.rs` session configuration reset behavior: copy history is reset, history metadata is installed, skills are cleared, network proxy and thread id are updated, queue submissions are cleared, review denials reset only on thread change, plan nudge and turn lifecycle reset, goal status is cleared, fork/current rollout/cwd/workspace roots are synced, and permission snapshots can fall back to replacement when constrained sync fails;
- preserve model/collaboration/service state sync: default model/reasoning effort update the collaboration mode, explicit collaboration mode sets the effective mode while missing collaboration mode initializes the mask, model display/status surfaces/service-tier/personality/plugins/goal commands and plugin mentions refresh;
- preserve display-mode behavior: normal sessions apply a session-info header, quiet/side sessions clear an active session header and bump the active-cell revision, copy-source flags reset, skills reload for cwd, connector prefetch is requested only when enabled, redraw respects suppression, and initial user-message submission is gated by suppression/elevated Windows sandbox setup;
- preserve fork and rename behavior: normal forked sessions emit a fork notice with or without parent title, matching thread-name updates insert rename confirmation, update the thread name, refresh status surfaces, request redraw, and attempt queued-input drain, while nonmatching updates are ignored;
- keep the evidence deterministic and independent of live filesystem mutation, connector/network prefetch, ratatui rendering, app-server mutation, credentialed model/provider calls, and Cafex behavior.

Status: HXCX-TUI-71 extends `fixtures/hxrust/tui-smoke.v1.json` with typed normal/quiet session configuration, header insert/removal, skills/connectors refresh, initial-message gates, fork notices, thread-name updates, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic session-flow state evidence only, not live app-server session ownership or full header rendering.

### HXCX-TUI-72: ChatWidget Replay Protocol Routing Boundary

Model selected raw Codex replay and server-notification routing without live app-server mutation, model calls, realtime transport, or terminal rendering:

- preserve `../codex/codex-rs/tui/src/chatwidget/replay.rs` turn replay behavior: in-progress turns clear stale non-retry error state and start task-running UI state, completed/interrupted/failed turns synthesize a replayed `TurnCompletedNotification`, and replay item routing marks item handling as replay-derived;
- preserve replay item routing from `replay.rs`: user messages seed replayed history/composer history, agent messages replay through completed assistant-message handling, reasoning replays summary deltas and optionally raw reasoning before finalization, command/file-change/MCP/web/image/review/context/collab/sub-agent items route through their ordinary ChatWidget handlers while remaining replay-scoped;
- preserve `../codex/codex-rs/tui/src/chatwidget/protocol.rs` server-notification guards: misrouted child-thread MCP status updates are rejected before shared state mutation, retry headers are restored for non-resume/non-retry notifications, `TurnStarted` sets the last turn id while suppressing task start only for `ResumeInitialMessages`, and live-only shutdown/realtime side effects are suppressed during replay;
- preserve `handle_turn_completed_notification` in `protocol.rs`: completed turns clear user-message dedupe and non-retry error state before task completion, interrupted turns map budget-limited ids to budget abort reasons, failed turns either consume matching stored non-retry errors or handle/finalize the turn, and replay completion is distinguishable from live completion;
- preserve replay error behavior from `protocol.rs` and `../codex/codex-rs/tui/src/chatwidget/tests/history_replay.rs`: replayed retryable stream errors do not set live retry status or render a stream-error cell, live retryable errors do, and non-retry errors record the turn/error pair before terminal handling;
- keep the evidence deterministic and independent of live terminal ownership, app-server mutation, ratatui rendering, credentialed model/provider calls, realtime/WebRTC transport, filesystem mutation, and Cafex behavior.

Status: HXCX-TUI-72 extends `fixtures/hxrust/tui-smoke.v1.json` with typed replay-turn, replay-item, server-notification, turn-completion, retryable/nonretryable error, live-only suppression, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic replay/protocol routing evidence only, not a full live app-server replay transport, renderer, or realtime backend.

### HXCX-TUI-73: ChatWidget Rate-Limit Prompt Boundary

Model selected raw Codex rate-limit warning, snapshot, prompt, and error-classification behavior without live account refreshes, model calls, or terminal rendering:

- preserve `../codex/codex-rs/tui/src/chatwidget/rate_limits.rs` duration labeling: approximate 5h/daily/weekly/monthly/annual windows get stable labels, unsupported windows fall back to generic primary or secondary usage labels, and cap-reached snapshots suppress threshold warning emission;
- preserve `RateLimitWarningState` thresholds from `rate_limits.rs` and `../codex/codex-rs/tui/src/chatwidget/tests/status_and_layout.rs`: 75/90/95 percent thresholds advance monotonically, emit only the highest newly crossed warning, and do not emit once a primary or secondary cap is reached;
- preserve snapshot state merging in `rate_limits.rs`: rolling updates can inherit credits and individual-limit metadata from full account snapshots, plan type is retained when later snapshots omit it, Codex limit reached types are stored for later error prompts, and non-Codex limit ids keep separate status entries;
- preserve rate-limit switch prompt gating: high Codex usage can move the prompt from idle to pending, task-running state defers showing, lower-cost model usage skips the nudge, hidden notices suppress it, and the prompt is shown once per session with the configured nudge model;
- preserve workspace-member prompt routing from `rate_limits.rs` and status/layout tests: member credits and member usage-limit states open the correct prompt and request a rate-limit refresh, usage-limit errors can remap stale member-credits state, owner-limit and missing-state cases do not open the owner nudge;
- preserve `app_server_rate_limit_error_kind` and `is_app_server_cyber_policy_error`: server-overloaded, usage-limit, generic 429, and cyber-policy errors stay distinguishable before higher-level turn-runtime handling;
- keep the evidence deterministic and independent of live account/network refreshes, ratatui rendering, credentialed model/provider calls, filesystem mutation, and Cafex behavior.

Status: HXCX-TUI-73 extends `fixtures/hxrust/tui-smoke.v1.json` with typed duration-label, warning-threshold, snapshot-preservation, switch-prompt, workspace-member-prompt, error-kind, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic rate-limit state evidence only, not live account transport or popup rendering ownership.

### HXCX-TUI-74: ChatWidget Windows Sandbox Prompt Boundary

Model selected raw Codex Windows sandbox prompt behavior without mutating OS sandbox state, opening a live terminal popup, or submitting model traffic:

- preserve `../codex/codex-rs/tui/src/chatwidget/windows_sandbox_prompts.rs` mode-admission and setup-required gates: configured requirements decide whether unelevated fallback is allowed, elevated mode with a config source and incomplete setup blocks startup progress, and completed setup clears the requirement;
- preserve enable-prompt behavior: legacy pre-NUX flow emits the legacy setup event, elevated NUX prompts show the Administrator setup action, optionally show the non-admin fallback, always offer quit, record telemetry, and reopen on cancel when a sandbox choice is required;
- preserve fallback-prompt behavior: failed elevated setup offers retry, optionally offers non-admin fallback, always offers quit, and reopens on cancel when the organization or current setup state still requires a choice;
- preserve startup prompt gating from `maybe_prompt_windows_sandbox_enable`: startup only opens the sandbox prompt when `show_now` is true and setup is required; otherwise startup proceeds without a modal;
- preserve `../codex/codex-rs/tui/src/chatwidget/tests/permissions.rs` initial-message deferral: configured initial prompts are held while required elevated setup is incomplete and submitted only after the selected mode no longer requires setup;
- preserve world-writable warning boundaries: non-Windows/no-warning paths are explicit no-ops, warning prompts can include sample paths and failed-scan copy, and remember actions are distinct from session-only acceptance;
- keep the evidence deterministic and independent of real Windows feature toggles, Administrator elevation, filesystem ACL scans, ratatui rendering, model/provider calls, and Cafex behavior.

Status: HXCX-TUI-74 extends `fixtures/hxrust/tui-smoke.v1.json` with typed mode-allowance, setup-required, enable-prompt, fallback-prompt, startup-gate, initial-message gate, world-writable warning, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic Windows sandbox prompt evidence only, not real OS sandbox setup or popup rendering ownership.

### HXCX-TUI-75: ChatWidget Permission Selection Boundary

Model selected raw Codex permission-selection behavior without opening live ratatui popups, mutating config files, or dispatching model traffic:

- preserve `../codex/codex-rs/tui/src/chatwidget/permission_popups.rs` normal approvals popup shape: built-in approval presets, optional Guardian auto-review row, disabled preset reasons, Windows read-only/degraded-sandbox label decisions, and the elevated sandbox hint;
- preserve `../codex/codex-rs/tui/src/chatwidget/permissions_menu.rs` explicit permission-profile mode: built-in workspace/full-access/read-only profiles, custom profile rows, current profile marking, and `PermissionProfileSelection` event identity;
- preserve permission selection side effects as typed intent: override turn context, update approval policy, update approvals reviewer, select named profile, and history-cell emission after actual selection rather than merely opening a popup;
- preserve full-access confirmation gating: warning-hidden bypass, confirmation popup opening, return-to-permissions routing, remember-dismissal intent, and delayed history emission until confirmed;
- preserve auto-review denial popup behavior: empty-denial info message, missing-thread refusal, searchable denial list, selected denial approval submission, and confirmation info insertion;
- keep the evidence deterministic and independent of live terminal rendering, config file mutation, command execution, filesystem mutation, model/provider calls, and Cafex behavior.

Status: HXCX-TUI-75 extends `fixtures/hxrust/tui-smoke.v1.json` with typed permission list, profile list, profile selection, full-access confirmation, auto-review denial, disabled preset, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic permission-selection state evidence only, not live popup rendering, config persistence, terminal ownership, or model traffic.

### HXCX-TUI-76: ChatWidget Model And Settings Popup Boundary

Model selected raw Codex model/settings popup behavior without live ratatui rendering, model/provider calls, or config-file mutation:

- preserve `../codex/codex-rs/tui/src/chatwidget/model_popups.rs` model picker behavior: session-configured gate, catalog-ready gate, quick auto preset partitioning, custom OpenAI base-url warning, current/default row marking, and the "All models" child-popup action;
- preserve all-models and reasoning popup behavior: single-effort auto-application, multi-effort row construction, high/extra-high warning text for current Codex models, current/default reasoning selection, and plan-mode redirection to the reasoning-scope prompt;
- preserve plan-mode reasoning scope side effects: plan-only versus all-modes selection, model/reasoning updates, plan-reasoning persistence, global model persistence, and the prompt notification;
- preserve `../codex/codex-rs/tui/src/chatwidget/service_tiers.rs` service-tier toggles: fast-mode keybinding gate, effective/configured tier distinction, override-turn-context event, persisted service-tier selection, and dependent surface refresh;
- preserve `../codex/codex-rs/tui/src/chatwidget/settings_popups.rs` settings-adjacent popups: personality support/error gates, personality persistence, realtime audio device rows and restart prompt, and experimental-feature popup filtering/saving intent;
- keep the evidence deterministic and independent of live terminal rendering, config writes, audio-device enumeration, network/model calls, and Cafex behavior.

Status: HXCX-TUI-76 extends `fixtures/hxrust/tui-smoke.v1.json` with typed model picker, all-models, reasoning, plan-scope, service-tier, personality, realtime-audio, experimental-feature, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic model/settings popup state evidence only, not live popup rendering, config persistence, audio-device ownership, provider transport, or model traffic.

### HXCX-TUI-77: ChatWidget Goal Menu And Status Boundary

Model selected raw Codex `/goal` menu and status behavior without live app-server mutation, ratatui rendering, or model traffic:

- preserve `../codex/codex-rs/tui/src/chatwidget/goal_menu.rs` goal summary rows: status labels, objective, elapsed time, token usage/budget, and the status-specific command hint for active, paused/blocked/usage-limited, budget-limited, and complete goals;
- preserve edit prompt status mapping: active stays active, paused/blocked/usage-limited retain status, and budget-limited/complete goals restart as active when edited;
- preserve resume-paused prompt behavior: default selected resume action emits `SetThreadGoalStatus(Active)`, while "Leave paused" dismisses without a status event;
- preserve `../codex/codex-rs/tui/src/chatwidget/goal_status.rs` compact indicators: active usage includes live active-turn elapsed time or token budget, stopped budget usage includes token budget when present, and complete usage prefers token totals for budgeted goals or elapsed time otherwise;
- preserve `../codex/codex-rs/tui/src/chatwidget/goal_validation.rs` objective length refusal for live, pasted, and queued sources, including live composer clearing and pending submission draining only for live input;
- preserve active-goal interrupt/clear state intent: Ctrl+C pauses an active goal turn, and thread goal clearing removes current goal status and refreshes the collaboration indicator;
- keep the evidence deterministic and independent of live app-server updates, terminal rendering, model/provider calls, and Cafex behavior.

Status: HXCX-TUI-77 extends `fixtures/hxrust/tui-smoke.v1.json` with typed goal summary, status indicator, edit prompt, resume prompt, validation, interrupt pause, clear, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic goal menu/status state evidence only, not live app-server mutation, renderer ownership, or model traffic.

### HXCX-TUI-78: ChatWidget Review Mode And Guardian Boundary

Model selected raw Codex review-mode and guardian-review behavior without live app-server mutation, ratatui rendering, or model traffic:

- preserve `../codex/codex-rs/tui/src/chatwidget/review_popups.rs` review popup routing: base-branch picker, uncommitted-changes review, commit picker, and custom-instructions prompt stay distinct, searchable child pickers defer parent dismissal until child acceptance, and empty custom prompts are ignored;
- preserve `../codex/codex-rs/tui/src/chatwidget/review.rs` review-mode lifecycle: entering review mode inserts the review banner, suppresses the live review prompt item, keeps assistant messages renderable, snapshots pre-review token state, and restores the prior context indicator on exit;
- preserve `../codex/codex-rs/tui/src/chatwidget/tests/review_mode.rs` queued-review behavior: pending steers are submitted while review is running, non-steerable messages are rejected into front-of-queue steers, existing queued user messages are preserved, rejected steers merge after review exit, and Esc shows a warning instead of interrupting while review steers are pending;
- preserve `../codex/codex-rs/tui/src/chatwidget/tests/guardian.rs` and `status_state.rs` guardian surfaces: in-progress approval reviews set a status header/details line, parallel reviews aggregate status, approved/denied/timed-out terminal outcomes insert history or warning surfaces, denials are stored for later approval, and remaining reviews stay visible after one terminal outcome;
- keep the evidence deterministic and independent of live app-server updates, terminal rendering, model/provider calls, command execution, filesystem mutation, and Cafex behavior.

Status: HXCX-TUI-78 extends `fixtures/hxrust/tui-smoke.v1.json` with typed review popup, picker, custom prompt, review enter/exit, steer queue, Esc warning, token restoration, guardian status/outcome, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic review-mode and guardian state evidence only, not live popup rendering, app-server mutation, command execution, renderer ownership, or model traffic.

### HXCX-TUI-79: ChatWidget Transcript And History-Cell Boundary

Model selected raw Codex transcript/history-cell behavior without live ratatui rendering, app-server mutation, command execution, or model traffic:

- preserve `../codex/codex-rs/tui/src/history_cell/mod.rs` `HistoryCell` contracts: rich display lines, raw copy-friendly lines, transcript overlay lines, hyperlink annotation, width-dependent height, transcript height, and active-cell revision invalidation stay explicit;
- preserve `../codex/codex-rs/tui/src/history_cell/messages.rs` user/assistant/reasoning behavior: user messages trim trailing blank lines, preserve styled text elements, summarize remote images, increment visible user turns, streamed assistant deltas consolidate into copyable markdown, and reasoning can be visible or transcript-only while still driving status headers;
- preserve `../codex/codex-rs/tui/src/history_cell/notices.rs` notice surfaces: info cells can carry hints, warnings are prefixed/dedupable through ChatWidget warning state, errors render as explicit history cells, and policy/deprecation notices remain distinct future extensions;
- preserve selected command/tool projection boundaries from `command_lifecycle.rs`, `tool_lifecycle.rs`, `exec.rs`, and `mcp.rs`: command output can group or emit orphan history, transcript rows can differ from display rows, completed tool calls may add image-output companion cells, and none of this slice executes a real command or tool;
- keep the evidence deterministic and independent of live terminal rendering, app-server updates, command/tool execution, filesystem mutation, model/provider calls, and Cafex behavior.

Status: HXCX-TUI-79 extends `fixtures/hxrust/tui-smoke.v1.json` with typed history-cell, user, assistant, reasoning, notice, tool, command, transcript-mode, copy-history, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic transcript/history state evidence only, not the full ratatui renderer, live transcript overlay, command runner, tool runtime, or app-server transport.

### HXCX-TUI-80: ChatWidget Transcript Overlay And Live-Tail Cache Boundary

Model selected raw Codex transcript overlay behavior without live alternate-screen ownership, ratatui rendering, app-server mutation, command execution, or model traffic:

- preserve `../codex/codex-rs/tui/src/app/input.rs` and `app_backtrack.rs` overlay ownership: `Ctrl+T` opens the transcript overlay from committed `transcript_cells`, enters alternate-screen intent, schedules a frame, and routes draw/resize through the overlay while `ChatWidget` remains the active-cell source of truth;
- preserve `../codex/codex-rs/tui/src/chatwidget.rs` `ActiveCellTranscriptKey`: the cached live tail invalidates on width, active-cell revision, stream-continuation state, or animation tick; missing keys drop the tail; and empty active-cell transcript lines produce no renderable tail;
- preserve `../codex/codex-rs/tui/src/pager_overlay.rs` live-tail and committed-cell behavior: identical keys are no-ops, recomputation preserves bottom-follow, non-continuation tails receive spacing after committed cells, semantic hyperlink metadata is preserved, inserted/replaced/consolidated committed cells keep an open overlay in sync, and highlight state is cleared when trimmed out;
- preserve transcript pager behavior: page height is based on rendered content, paging is continuous and round-trips, highlighted user cells scroll into view, close/close-transcript marks the overlay done, and raw/rich transcript mode toggles schedule reflow/redraw without changing source cells;
- keep the evidence deterministic and independent of live terminal rendering, app-server updates, command/tool execution, filesystem mutation, model/provider calls, and Cafex behavior.

Status: HXCX-TUI-80 extends `fixtures/hxrust/tui-smoke.v1.json` with typed transcript-overlay open, live-tail key/sync/drop, insert, replace, consolidate, highlight, paging, raw/rich mode, close, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic transcript overlay/cache evidence only, not the full ratatui renderer, real alternate-screen lifecycle, live app overlay event loop, command runner, tool runtime, or app-server transport.

### HXCX-TUI-81: ChatWidget Backtrack Overlay Boundary

Model selected raw Codex backtrack behavior without live alternate-screen ownership, ratatui rendering, app-server mutation, command execution, or model traffic:

- preserve `../codex/codex-rs/tui/src/app_backtrack.rs` state-machine contracts: the first eligible `Esc` primes backtrack with the current thread id, a subsequent `Esc` opens transcript preview, empty composers are required, and unavailable targets reset state while inserting the upstream info surface;
- preserve overlay preview navigation: transcript-overlay backtrack mode highlights the latest user message first, older/newer navigation clamps at the available user-message range, highlighted cell indexes are derived from post-session user cells, and selection preserves text elements plus local and remote images;
- preserve rollback intent and completion: confirming the overlay captures the selected user turn, closes the overlay, submits `thread_rollback(num_turns)`, stores pending rollback state, restores composer prefill and remote-image context, and ignores mismatched-thread completions;
- preserve transcript/copy-history cleanup: pending and non-pending rollback completions trim committed transcript cells, truncate copy history to the remaining user count, replace open overlay committed cells, clear deferred history rows, and mark render pending;
- preserve input guards from `app/input.rs` and upstream tests: side-conversation backtrack is rejected with an info message, Vim insert-mode `Esc` remains an editor escape instead of a backtrack trigger, clear-UI resets backtrack state, and the deterministic fixture never performs live render/model/app-server work.

Status: HXCX-TUI-81 extends `fixtures/hxrust/tui-smoke.v1.json` with typed backtrack prime/open/select/step/confirm/rollback, trim/sync, unavailable guard, reset, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic backtrack overlay state evidence only, not the full ratatui renderer, real alternate-screen lifecycle, live app overlay event loop, command runner, tool runtime, or app-server transport.

### HXCX-TUI-82: ChatWidget Raw-Output And Runtime Keymap Boundary

Model selected raw Codex keymap/runtime behavior without live keyboard input, live terminal mutation, ratatui rendering, app-server mutation, or model traffic:

- preserve `../codex/codex-rs/tui/src/keymap.rs` raw-output contracts: `global.toggle_raw_output` defaults to Alt-r, can be remapped to F12, and toggles ChatWidget raw-output state while scheduling redraw without requiring live terminal writes in this deterministic gate;
- preserve explicit unbind and alias behavior: empty arrays remove bindings rather than falling back to defaults, editor newline aliases stay grouped, Alt-d remains delete-forward-word, and modified Backspace/Delete aliases remain part of the editor surface;
- preserve main-surface assignment/conflict behavior: reassignable app actions such as `toggle_fast_mode` can take free bindings, but fail closed when colliding with existing main-surface bindings such as `clear_terminal`;
- preserve fixed-shortcut guard behavior: composer submit cannot claim fixed paste-image Ctrl-v, while fixed shortcut collisions can be made legal only after the original fixed action is explicitly unbound;
- preserve default pruning and binding-input behavior: legacy bindings prune selected defaults, string-or-array binding input deduplicates in first-seen order, fallback routes global queue behavior into composer scope, and invalid keymap paths remain explicit.

Status: HXCX-TUI-82 extends `fixtures/hxrust/tui-smoke.v1.json` with typed raw-output default/remap/toggle, explicit unbind, editor aliases, main-surface assignment/conflict, fixed-shortcut conflict/unbind-remap, default pruning, binding input, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic runtime keymap evidence only, not the full keyboard event loop, real terminal raw-output rendering, config-file loading, ratatui renderer, app-server transport, or model traffic.

### HXCX-TUI-83: ChatWidget Raw-Output Render-Mode Boundary

Model selected raw Codex raw-output rendering behavior without live terminal mutation, ratatui rendering, app-server mutation, command execution, or model traffic:

- preserve `../codex/codex-rs/tui/src/chatwidget.rs` raw-output ownership: `set_raw_output_mode` updates ChatWidget state and config, `set_raw_output_mode_and_notify` inserts the user-facing rich/raw notice, slash `/raw` command paths emit `RawOutputModeChanged`, and the status line shows `raw output` only when enabled;
- preserve `../codex/codex-rs/tui/src/history_cell/mod.rs` render-mode selection: rich mode uses display hyperlink lines, raw mode uses raw lines for clean terminal selection, and transcript lines remain a separate source for overlay/copy behavior;
- preserve command/tool history-cell visibility: command output keeps stdout/stderr visibility and grouping facts, tool output can have raw/display differences plus companion image cells, and raw-output rendering does not execute a command or tool;
- preserve active stream and resize propagation: raw/rich render mode is propagated to active stream/plan controllers, active tails are resynced, active revisions bump when render-affecting state changes, and redraw is requested;
- preserve copy/transcript separation: final assistant copy lines and transcript lines remain stable evidence surfaces even when display mode changes.

Status: HXCX-TUI-83 extends `fixtures/hxrust/tui-smoke.v1.json` with typed raw-output mode/notice/status, rich-versus-raw cell selection, active stream propagation, command/tool output visibility, copy/transcript preservation, resize sync, slash command, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic raw-output render-mode evidence only, not the full ratatui renderer, real terminal selection, live command/tool execution, config-file persistence, app-server transport, or model traffic.

### HXCX-TUI-84: ChatWidget Status-Surface Render Boundary

Model selected raw Codex status-surface rendering behavior without live terminal mutation, ratatui rendering, app-server mutation, command execution, or model traffic:

- preserve `../codex/codex-rs/tui/src/chatwidget/status_surfaces.rs` render-facing selection contracts: status-line and terminal-title item choices stay typed, status-line item counts and visible counts are explicit, model/branch/git-summary/raw-output indicators remain separately observable, and branch/git-summary refresh needs are not hidden inside untyped strings;
- preserve invalid-item warning behavior: unsupported status-surface items produce visible warnings once, repeated invalid inputs are deduped, and warning visibility remains separate from warning accounting;
- preserve terminal-title preview semantics: preview item lists can start without committing or reverting, and later live title setup remains a distinct boundary from deterministic preview evidence;
- preserve `../codex/codex-rs/tui/src/chatwidget/status_controls.rs` status refresh coupling: run-state/status header/details changes can produce rendered status text, bump render revisions, request redraw, and schedule a frame;
- preserve `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` status-line visibility pressure: this slice records visible status-line text and segments but does not claim full ratatui layout, spacing, or terminal rendering parity.

Status: HXCX-TUI-84 extends `fixtures/hxrust/tui-smoke.v1.json` with typed status-surface render selection, model/branch/git/raw indicators, warning dedupe/visibility, title preview, status refresh/redraw scheduling, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic status-surface render intent only, not the full ratatui renderer, real terminal title mutation, live git watcher, config-file persistence, app-server transport, or model traffic.

### HXCX-TUI-85: ChatWidget Slash-Command Raw/Status Boundary

Model selected raw Codex ChatWidget slash-command dispatch behavior without live terminal mutation, ratatui rendering, app-server mutation, command execution, or model traffic:

- preserve `../codex/codex-rs/tui/src/chatwidget/slash_dispatch.rs` command-dispatch ownership: `handle_slash_command_dispatch` records staged slash history after dispatch, queued and live sources share the app-level handler boundary, and command availability is checked before side effects;
- preserve `/raw` behavior from `slash_dispatch.rs` and `chatwidget.rs`: `Raw` supports inline args, toggles or sets raw-output mode, updates config, refreshes status surfaces, inserts the user-facing notice, and emits `AppEvent::RawOutputModeChanged`;
- preserve `/status` behavior from `slash_dispatch.rs` and `../codex/codex-rs/tui/src/status/card.rs`: the status command inserts a composite `/status` history output, may prefetch rate limits with a request id, and emits a rate-limit refresh app event only when the refresh path is active;
- preserve availability guards from `../codex/codex-rs/tui/src/slash_command.rs`: `/raw` and `/status` are available during tasks and in side conversations, while commands such as `/clear` fail while a task is running and commands such as `/goal` are rejected in side conversations;
- keep argument parsing deterministic: inline `/raw off` is modeled as a trimmed inline-arg command, while empty args can still fall back to bare command dispatch in later fixtures.

Status: HXCX-TUI-85 extends `fixtures/hxrust/tui-smoke.v1.json` with typed slash-command dispatch, `/raw` bare and inline-arg mode effects, `/status` card and rate-limit refresh intent, app-event emission, task/side availability guards, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic ChatWidget slash-command effect evidence only, not the full popup lifecycle, live command execution, full `/status` ratatui card rendering, config-file persistence, app-server transport, or model traffic.

### HXCX-TUI-86: ChatWidget Status-Card Output Boundary

Model selected raw Codex `/status` card output behavior without live terminal mutation, ratatui rendering, app-server mutation, command execution, or model traffic:

- preserve `../codex/codex-rs/tui/src/status/card.rs` card composition: the status output is a composite history cell rooted in the literal `/status` command row, then model/provider/account, directory, permissions, Agents.md summary, thread/session/fork/collaboration metadata, token usage, context window, and rate-limit rows;
- preserve model/provider detail rows: Responses-backed providers include reasoning effort and reasoning summary details, runtime provider display can differ from configured provider, and ChatGPT usage-link visibility depends on OpenAI-auth-backed providers;
- preserve permission/session rows from `card.rs`: permission labels summarize active approval/sandbox/workspace roots, thread names are omitted when empty, session and fork ids appear together, and collaboration mode is a normal status row;
- preserve token usage behavior: API-key style status output shows total, non-cached input, output, and context-window usage while ChatGPT subscriber hiding can be modeled in later cases;
- preserve `../codex/codex-rs/tui/src/status/rate_limits.rs` display-state contracts: available rows include window labels/resets and credit rows, stale rows add the correct warning, missing refreshing rows use the "refresh requested" message, unavailable rows show account unavailability, and `StatusHistoryHandle::finish_rate_limit_refresh` clears the refreshing state after a refresh.

Status: HXCX-TUI-86 extends `fixtures/hxrust/tui-smoke.v1.json` with typed status-card summary, model/provider/account, permissions, thread/session/collaboration, token/context, available/stale/missing/unavailable rate-limit, refresh-completion, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic `/status` card row evidence only, not full ratatui span rendering, terminal width wrapping, live rate-limit fetching, account auth, app-server transport, or model traffic.

### HXCX-TUI-87: ChatWidget Status-Card Render-Width Boundary

Model selected raw Codex `/status` card render-width behavior without live terminal mutation, ratatui rendering, app-server mutation, command execution, or model traffic:

- preserve `../codex/codex-rs/tui/src/status/card.rs` width calculation contracts: card display uses `width - 4` as inner width, derives value-column width from collected labels, truncates only after content width is known, and narrow terminals increase wrapped/continuation rows rather than dropping content;
- preserve remote connection wrapping: long app-server control addresses wrap under the `Remote` label using the value-column width and remain distinct from model/provider rows;
- preserve rate-limit continuation behavior: reset timestamps and monthly credit details continue onto dim continuation rows when they do not fit inline, rather than truncating actionable reset/detail text;
- preserve account/provider visibility gates: ChatGPT subscriber accounts hide token-usage rows while context-window rows can remain visible, OpenAI-auth-backed providers show the ChatGPT usage link, and Bedrock/native provider status cards do not show that usage-link row;
- keep render evidence deterministic and row-oriented; this slice records width/wrap/truncation facts, not ratatui spans, border glyph snapshots, or terminal pixel output.

Status: HXCX-TUI-87 extends `fixtures/hxrust/tui-smoke.v1.json` with typed status-card render-width, remote wrap, continuation, subscriber token hiding, usage-link provider gating, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic `/status` render-width evidence only, not full ratatui span rendering, terminal glyph snapshots, live rate-limit fetching, account auth, app-server transport, or model traffic.

### HXCX-TUI-88: ChatWidget Status-Card Rate-Limit Refresh Delivery Boundary

Model selected raw Codex `/status` rate-limit refresh delivery behavior without live account transport, app-server mutation, ratatui rendering, command execution, or model traffic:

- preserve `../codex/codex-rs/tui/src/chatwidget/slash_dispatch.rs` request-id behavior: ChatGPT-backed `/status` output inserts the card immediately, emits `RefreshRateLimits { origin: StatusCommand { request_id } }`, starts at request id `0`, increments the next id, and avoids transient refresh text in terminal history;
- preserve `../codex/codex-rs/tui/src/chatwidget/status_controls.rs` pending handle behavior: each refreshing card stores a `(request_id, StatusHistoryHandle)` pair, overlapping `/status` refreshes keep distinct handles, and matching completions update only the matching card;
- preserve `../codex/codex-rs/tui/src/status/card.rs` handle completion behavior: `StatusHistoryHandle::finish_rate_limit_refresh` recomposes current snapshots, replaces card-local rate-limit state, and clears `refreshing_rate_limits`;
- preserve app event dispatch routing from `../codex/codex-rs/tui/src/app/event_dispatch.rs`: successful status-command refreshes update cached snapshots then finish the matching status card, errors still finish the matching card, startup prefetch updates the cache and schedules a frame without a status-history handle, and stale/mismatched completions do not redraw or mutate unrelated cards;
- preserve provider gating from the upstream status-command tests: non-ChatGPT/native provider sessions still insert `/status` output but do not emit a rate-limit refresh app event.

Status: HXCX-TUI-88 extends `fixtures/hxrust/tui-smoke.v1.json` with typed status-card refresh request, overlapping refresh delivery, stale completion, cached snapshot, startup prefetch, non-refresh provider gate, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic `/status` refresh-delivery evidence only, not live account fetching, app-server transport, account auth, ratatui rendering, or model traffic.

### HXCX-TUI-89: ChatWidget Interrupted-Turn Retry Status And Prompt Restore Boundary

Extend the earlier HXCX-TUI-46 interrupted-turn coverage with selected retry-status and prompt-restore details from raw Codex, without live terminal mutation, app-server transport, model traffic, or ratatui rendering:

- preserve `../codex/codex-rs/tui/src/chatwidget/status_state.rs` retry-header behavior: retry errors remember the current status header only once, and `take_retry_status_header` clears it after restoration;
- preserve `../codex/codex-rs/tui/src/chatwidget/streaming.rs` and `protocol.rs` retry routing: live `will_retry` errors show a retry status indicator with details, replayed retry errors do not create history/status side effects, and the next non-retry live notification restores the remembered header;
- preserve `../codex/codex-rs/tui/src/chatwidget/input_restore.rs` prompt restore behavior around interruption: output-free cancel-edit interruption emits `RestoreCancelledTurn`, while interrupted queued messages restore into the composer instead of auto-submitting;
- preserve upstream composer tests from `../codex/codex-rs/tui/src/chatwidget/tests/composer_submission.rs`: restored queued messages keep FIFO order and are prepended before existing draft text.

Status: HXCX-TUI-89 extends `fixtures/hxrust/tui-smoke.v1.json` with typed retry-status header preservation/restoration, replay retry suppression, cancel-edit prompt restore, queued-message composer restore, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic ChatWidget retry/interruption restore evidence only, not live SSE recovery, app-server transport, full composer rendering, or model traffic.

### HXCX-TUI-90: Clear/Archive Archived-Session Guidance And Unarchive Command Boundary

Extend the earlier HXCX-TUI-48 clear/archive coverage with selected raw Codex archived-session and unarchive command behavior, without live terminal mutation, app-server transport, model traffic, or ratatui rendering:

- preserve `../codex/codex-rs/tui/src/app.rs` `session_start_error` and archived-session guidance behavior: resume/fork startup failures for archived sessions collapse the app-server error into the user-facing `codex unarchive <thread-id>` guidance instead of leaking rollout paths or nested RPC details;
- preserve `../codex/codex-rs/tui/src/session_archive_commands.rs`: `codex archive` and `codex unarchive` are thin app-server clients that resolve UUID or exact session name, scope lookup to active or archived sessions, call `thread/archive` or `thread/unarchive`, and return a deterministic success message;
- preserve `../codex/codex-rs/tui/src/app_server_session.rs` typed archive/unarchive request boundaries: both commands remain app-server RPC intents, not filesystem mutation or Codex-specific haxe.rust behavior;
- preserve the HXCX-TUI-48 TUI archive-success exit contract in `../codex/codex-rs/tui/src/app/event_dispatch.rs`: archiving the current main thread exits with user-requested intent and shutdown-first feedback while refusals stay non-exiting;
- keep the evidence deterministic and independent of live app-server mutation, rollout reads, filesystem mutation, model/tool execution, network transport, terminal takeover, and Cafex behavior.

Status: HXCX-TUI-90 extends `fixtures/hxrust/tui-smoke.v1.json` with typed archived-session resume/fork guidance, shared unarchive command RPC intent, archive-success session exit, shutdown feedback, and no-live evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic archive/unarchive boundary evidence only, not live session mutation, app-server transport, persistent rollout repair, or an interactive unarchive UI.

### HXCX-TUI-91: Session Archive Command Resolver Boundary

Extend HXCX-TUI-90 with selected raw Codex `codex archive` / `codex unarchive` command resolver behavior, without live app-server mutation, rollout reads, filesystem mutation, model traffic, or ratatui rendering:

- preserve `../codex/codex-rs/tui/src/session_archive_commands.rs` UUID handling: valid `ThreadId` targets resolve directly and skip name lookup;
- preserve exact-name lookup behavior: archive searches active sessions, unarchive searches archived sessions, lookup pages use `ThreadSortKey::UpdatedAt`, limit 100, non-interactive source kinds excluded, and the resolver keeps paging until an exact `thread.name` match or exhaustion;
- preserve not-found errors: missing names report `No active session found matching '<target>'.` or `No archived session found matching '<target>'.` based on action scope;
- preserve success-message shape: unnamed UUID targets render `Archived session <id>.`, named archive targets render `Archived session <name> (<id>).`, and unarchive prefers the name returned by `thread/unarchive` before the resolved lookup name;
- preserve `../codex/codex-rs/tui/src/app_server_session.rs` request intent boundaries: archive/unarchive remain typed app-server RPC requests and do not become direct filesystem mutation or haxe.rust-specific behavior;
- keep the evidence deterministic and independent of live app-server mutation, network transport, rollout/state DB access, terminal takeover, model/tool execution, filesystem mutation, and Cafex behavior.

Status: HXCX-TUI-91 extends `fixtures/hxrust/tui-smoke.v1.json` with typed UUID resolution, paged exact-name lookup, active-vs-archived scope selection, not-found failure, archive/unarchive success-message formatting, and no-live/no-filesystem evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic command resolver evidence only, not a live CLI command, app-server session mutation, or persistent archive repair flow.

### HXCX-TUI-92: Session Archive App-Server RPC Boundary

Extend HXCX-TUI-91 from command target resolution into the app-server RPC boundary used by raw Codex TUI archive/unarchive commands, without live app-server mutation, rollout reads, filesystem mutation, model traffic, or ratatui rendering:

- preserve `../codex/codex-rs/tui/src/app_server_session.rs` `thread_archive`: allocate the next request id, send `ClientRequest::ThreadArchive` with `ThreadArchiveParams { thread_id }`, accept an empty `ThreadArchiveResponse`, and wrap transport failures as `failed to archive session`;
- preserve `../codex/codex-rs/tui/src/app_server_session.rs` `thread_unarchive`: allocate the next request id, send `ClientRequest::ThreadUnarchive` with `ThreadUnarchiveParams { thread_id }`, return the `Thread` from `ThreadUnarchiveResponse`, and wrap transport failures as `failed to unarchive session`;
- preserve `../codex/codex-rs/app-server-protocol/src/protocol/common.rs` method names and serialization: `thread/archive` and `thread/unarchive` both serialize the `threadId` request identity and remain typed client requests;
- preserve `../codex/codex-rs/app-server-protocol/src/protocol/v2/thread.rs` response shapes: archive returns an empty object while unarchive returns `{ thread }`;
- preserve the HXCX-TUI-91 command-result name preference: the unarchive command may prefer the thread name returned by `thread/unarchive` over the earlier resolver name;
- keep invalid thread-id handling and transport-failure wrapping deterministic, with no live app-server session, network transport, filesystem mutation, or Cafex behavior.

Status: HXCX-TUI-92 extends `fixtures/hxrust/tui-smoke.v1.json` with typed archive/unarchive RPC request method/params, empty archive response, unarchive thread response, returned-name preference, invalid thread-id rejection, wrapped transport error evidence, and no-live/no-filesystem evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic app-server RPC boundary evidence only, not live JSON-RPC transport, session archive mutation, notification fanout, or persistent rollout movement.

### HXCX-TUI-93: App-Server Archive Notification Routing Boundary

Extend HXCX-TUI-92 from archive/unarchive RPC intent into selected raw Codex `thread/archived` and `thread/unarchived` server-notification routing, without live app-server mutation, rollout movement, filesystem access, model traffic, or ratatui rendering:

- preserve `../codex/codex-rs/app-server-protocol/src/protocol/common.rs` notification method names: `ThreadArchived` serializes as `thread/archived` and `ThreadUnarchived` serializes as `thread/unarchived`;
- preserve `../codex/codex-rs/app-server-protocol/src/protocol/v2/thread.rs` payload shape: both notifications carry `thread_id` and no extra rollout/session data;
- preserve `../codex/codex-rs/tui/src/app/app_server_event_targets.rs` targeting behavior: archived/unarchived notifications are thread-scoped by their payload thread id, route to the active thread immediately when active, and buffer or evict through the same inactive-thread queueing path as other thread notifications;
- preserve `../codex/codex-rs/tui/src/chatwidget/protocol.rs` ChatWidget suppression behavior: `ThreadArchived` and `ThreadUnarchived` are accepted by routing but do not directly render transcript rows or status text;
- keep missing-thread and no-live behavior deterministic, with no live JSON-RPC transport, app-server fanout, persistent session archive mutation, filesystem mutation, or Cafex behavior.

Status: HXCX-TUI-93 extends `fixtures/hxrust/tui-smoke.v1.json` with typed active archive notification routing, inactive unarchive notification buffering/eviction, missing-thread rejection, ChatWidget suppression trace evidence, and no-live/no-filesystem evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic notification routing evidence only, not live app-server notification fanout, persistent archive state movement, full thread-id validation, or interactive TUI rendering.

### HXCX-TUI-94: Session Archive Thread-List Filter Boundary

Extend HXCX-TUI-91/HXCX-TUI-92 from resolver-level lookup evidence into the raw Codex `thread/list` app-server request/response boundary used while resolving archive/unarchive command names, without live app-server transport, rollout reads, state DB repair, filesystem mutation, model traffic, or ratatui rendering:

- preserve `../codex/codex-rs/tui/src/session_archive_commands.rs` lookup request construction: session name resolution calls `thread/list` with limit 100, `ThreadSortKey::UpdatedAt`, `source_kinds` from `resume_source_kinds(false)`, `archived=false` for archive, `archived=true` for unarchive, `cwd=None`, `use_state_db_only=false`, and `search_term` equal to the requested session name;
- preserve pagination behavior from the same loop: the resolver keeps passing `next_cursor` into the next request until an exact `thread.name` match or an empty cursor terminates the search;
- preserve `../codex/codex-rs/app-server-protocol/src/protocol/common.rs` method identity: `ThreadList` serializes as `thread/list` and carries no single thread-id serialization key;
- preserve `../codex/codex-rs/app-server-protocol/src/protocol/v2/thread.rs` params/response shape: `ThreadListParams` owns optional cursor/limit/sort/source/archived/cwd/search fields plus `use_state_db_only`, and `ThreadListResponse` returns `data`, `next_cursor`, and `backwards_cursor`;
- preserve the archived-filter contract from upstream protocol docs: `archived=true` lists archived threads, while false or null lists non-archived threads;
- keep transport failure wrapping and no-live rejection deterministic, with no app-server mutation, filesystem mutation, state DB repair, persistent archive movement, or Cafex behavior.

Status: HXCX-TUI-94 extends `fixtures/hxrust/tui-smoke.v1.json` with typed `thread/list` request params, active-vs-archived filter evidence, source-kind gating through `include_non_interactive=false`, pagination and empty-result response cursors, wrapped list transport failure, and no-live/no-filesystem evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic app-server list-filter evidence only, not live JSON-RPC transport, state DB/rollout querying, resume picker rendering, or persistent session archive mutation.

### HXCX-TUI-95: Thread-List Row Projection Boundary

Extend HXCX-TUI-94 from `thread/list` request/response metadata into selected raw Codex row projection consumed by session archive and resume picker flows, without live app-server transport, state DB/rollout querying, filesystem mutation, model traffic, or ratatui rendering:

- preserve `../codex/codex-rs/app-server-protocol/src/protocol/v2/thread_data.rs` row shape: `Thread` rows carry id, optional path, preview, created/updated timestamps, cwd, source, optional git metadata, and optional name;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `row_from_app_server_thread`: invalid thread ids are skipped, preview text is trimmed, empty preview renders as `(no message yet)`, thread names override preview for display, timestamps are parsed from Unix seconds, and cwd/git branch are preserved for search/footer metadata;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `load_app_server_page`: response `data` rows are projected with `filter_map`, `next_cursor` remains an app-server page cursor, and `num_scanned_files` counts response rows before invalid rows are dropped;
- preserve `../codex/codex-rs/tui/src/session_archive_commands.rs` `session_target_from_app_server_thread`: archive command name resolution rejects invalid app-server thread ids and carries the returned optional session name;
- preserve active and archived-scope row evidence while keeping backwards cursor presence visible from `ThreadListResponse`;
- keep malformed row refusal deterministic, with no live JSON-RPC transport, persistent archive movement, state DB repair, filesystem mutation, or Cafex behavior.

Status: HXCX-TUI-95 extends `fixtures/hxrust/tui-smoke.v1.json` with typed `ThreadListResponse.data` row projection evidence, display-title fallback, source/cwd/path/git/timestamp summaries, invalid thread-id row rejection, active and archived filter consistency, backwards cursor evidence, and no-live/no-filesystem evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic row projection evidence only, not full picker rendering, transcript preview loading, state DB/rollout querying, or persistent session archive mutation.

### HXCX-TUI-96: Resume Picker App-Server Page Loading Boundary

Extend HXCX-TUI-95 from row projection into selected raw Codex resume picker page loading behavior, without live app-server transport, state DB/rollout querying, filesystem mutation, model traffic, or ratatui rendering:

- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `start_initial_load`: initial picker loads clear rows, pagination, seen-row state, and selection, allocate request/search tokens, mark loading pending, request a frame, and enqueue `PickerLoadRequest::Page` with cursor `None`, the active cwd filter, provider filter, sort key, and optional search token;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `load_app_server_page` and `thread_list_params`: app-server `thread/list` page loads pass cursor, cwd/provider filters, sort key, and include-non-interactive source-kind policy, while `num_scanned_files` counts all response rows before invalid rows are skipped;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `ingest_page`: accepted rows are deduped into the picker, next cursor and scan-cap state are updated, scanned row counts accumulate, filters are reapplied, and pending page-down completion is surfaced after the page arrives;
- preserve search continuation behavior: an active search keeps requesting additional pages while there are no filtered rows, a next cursor exists, the scan cap is not reached, and the search token still matches; it stops once a filtered row appears, no next cursor remains, or the scan cap is reached;
- preserve sort/filter restart behavior: sort toggles between `UpdatedAt` and `CreatedAt`, cwd/all filtering toggles restart from the first page, and both schedule fresh page loads rather than mutating an existing cursor in place;
- preserve stale background completion refusal by request token, with no live terminal, app-server, model, or filesystem effects.

Status: HXCX-TUI-96 extends `fixtures/hxrust/tui-smoke.v1.json` with typed resume picker page-request, page-ingest, search-continuation, sort-toggle, filter-toggle, stale-token refusal, invalid-row accounting, accepted-vs-scanned count, cursor propagation, and no-live/no-render evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic picker page-loading evidence only, not transcript preview loading, live app-server fanout, state DB/rollout querying, ratatui rendering, or persistent session mutation.

### HXCX-TUI-97: Resume Picker Transcript Preview Boundary

Extend HXCX-TUI-96 from page loading into selected raw Codex resume picker transcript preview behavior, without live app-server transport, state DB/rollout querying, filesystem mutation, model traffic, or ratatui rendering:

- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `PickerLoadRequest::Preview`: the picker loader routes preview requests by selected `ThreadId` separately from page and full transcript requests;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `toggle_selected_expansion`: Ctrl+E expands only the selected row with a valid thread id, collapses when the selected thread is already expanded, inserts a `TranscriptPreviewState::Loading` cache entry only on cache miss, sends one preview request for that miss, and schedules a frame;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `load_transcript_preview`: app-server preview loading calls `thread_read(thread_id, include_turns=true)`, projects user and assistant transcript items, parses assistant markdown relative to the thread cwd, drops empty lines, and keeps the last six preview lines;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `BackgroundEvent::Preview`: preview completion stores `Loaded(lines)` or `Failed` by thread id and schedules a frame. Unlike page loading, preview completion has no request-token stale check; selected and expanded row identity controls whether a cached preview is rendered;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `render_transcript_preview_lines`: loading, failed, empty, user, and assistant preview states render only for the selected expanded row, while unselected cached completions remain non-rendering cache state;
- keep no-live/no-render behavior deterministic, with no live JSON-RPC transport, full transcript overlay opening, state DB reads, filesystem mutation, or Cafex behavior.

Status: HXCX-TUI-97 extends `fixtures/hxrust/tui-smoke.v1.json` with typed resume picker preview toggle, cache miss/loading insertion, `thread/read includeTurns=true` request intent, loaded/failed preview completion, selected-row render gating, unselected cache non-rendering, and no-live/no-render evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic transcript preview evidence only, not full transcript overlay loading, live app-server fanout, state DB/rollout querying, ratatui rendering, or persistent session mutation.

### HXCX-TUI-98: Resume Picker Full Transcript Overlay Boundary

Extend HXCX-TUI-97 from inline preview into selected raw Codex resume picker full transcript overlay behavior, without live app-server transport, state DB/rollout querying, filesystem mutation, model traffic, or ratatui rendering:

- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `PickerLoadRequest::Transcript`: the picker loader routes full transcript requests by selected `ThreadId` separately from page and inline preview requests;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `open_selected_transcript`: Ctrl+T/Ctrl+Enter opens only the selected row with a valid thread id, inserts `SessionTranscriptState::Loading` on missing or failed cache entries, begins a pending transcript open, schedules a frame, and sends a transcript loader request only when a fresh load is required;
- preserve `../codex/codex-rs/tui/src/thread_transcript.rs` `load_session_transcript`: full transcript loading calls `thread_read(thread_id, include_turns=true)` and projects user, assistant markdown, plan, reasoning, and fallback transcript cells, including the empty-transcript fallback cell when no content survives projection;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `note_transcript_loading_frame_drawn` and `open_pending_transcript_if_ready`: even cached or immediately loaded transcript cells wait for one loading frame before opening `Overlay::new_transcript`, then clear pending state and schedule another frame;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `BackgroundEvent::Transcript`: successful completion stores loaded cells and opens only if the pending thread matches and the loading frame has been drawn; failed completion stores `Failed`, clears matching pending state, surfaces the upstream inline error, and schedules a frame;
- keep no-live/no-render behavior deterministic, with no live JSON-RPC transport, pager interaction, state DB reads, filesystem mutation, or Cafex behavior.

Status: HXCX-TUI-98 extends `fixtures/hxrust/tui-smoke.v1.json` with typed resume picker full transcript open, app-server `thread/read includeTurns=true` request intent, transcript-cell projection counts, pending-open lifecycle, loading-frame gate, cached transcript open behavior, successful overlay opening, failed completion/error evidence, and no-live/no-render evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic full transcript overlay evidence only, not live app-server fanout, pager key handling, state DB/rollout querying, ratatui rendering, or persistent session mutation.

### HXCX-TUI-99: Resume Picker Keyboard And Loading-State Boundary

Extend HXCX-TUI-98 from transcript overlay state into selected raw Codex resume picker keyboard and loading-state behavior, without live terminal ownership, app-server transport, state DB/rollout querying, filesystem mutation, model traffic, or ratatui rendering:

- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `handle_key`: Ctrl-C exits before remapped cancel handling, Esc starts fresh only when the query is empty, plain text belongs to search before list navigation, and modified list keymap bindings drive movement;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` page and jump navigation: PageDown/PageUp move by the visible row count, Home/End clamp to first/last filtered rows, movement calls `ensure_selected_visible`, and End/near-bottom movement can trigger `load_more_if_needed(LoadTrigger::Scroll)` when a cursor exists;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `clear_query_preserving_selection`: clearing a query restores the selected row by stable seen-key when that row still exists in the unfiltered list;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `handle_transcript_loading_key`: while a full transcript is pending, normal picker movement/input is consumed and only Ctrl-C returns an exit selection;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` overlay routing and `handle_overlay_event`: when a transcript overlay is open it receives events first, and closing it clears overlay state and schedules a frame before picker input resumes;
- preserve selected-row acceptance failure behavior: Enter on a row with no resolvable `ThreadId` attempts metadata resolution when a path exists, surfaces the upstream inline metadata error, and schedules a frame;
- keep no-live/no-render behavior deterministic, with no live key loop, terminal backend mutation, app-server requests beyond typed intent, filesystem mutation, or Cafex behavior.

Status: HXCX-TUI-99 extends `fixtures/hxrust/tui-smoke.v1.json` with typed resume picker page/jump movement, scroll visibility, load-more trigger, query clear with selection preservation, empty-query start-fresh intent, transcript-loading key consumption, Ctrl-C exit, overlay close, metadata failure, and no-live/no-render evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic keyboard/loading-state evidence only, not live crossterm input, pager key handling, live app-server fanout, state DB/rollout querying, ratatui rendering, or persistent session mutation.

### HXCX-TUI-100: Resume Picker Density Toolbar Persistence Boundary

Extend HXCX-TUI-99 from keyboard/loading behavior into selected raw Codex resume picker density, toolbar, and view-preference behavior, without live terminal ownership, app-server transport, state DB/rollout querying, model traffic, ratatui rendering, or real config mutation:

- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `toggle_density`: Ctrl-O and raw Ctrl-O toggle between comfortable and dense modes without typing into search, call `ensure_selected_visible`, attempt view persistence when configured, keep the toggled density on persistence failure, surface the upstream inline error, and schedule a frame;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `persist_density`: persistence uses `ConfigEditsBuilder::set_session_picker_view` under the configured Codex home and maps write failures into the picker inline error path;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `focus_next_toolbar_control` and `focus_previous_toolbar_control`: Tab and BackTab cycle between Filter and Sort focus and request a frame;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `change_focused_toolbar_value`: left/right keymap activation delegates to Sort or Filter, where Sort toggles between `UpdatedAt` and `CreatedAt`, Filter toggles Cwd/All only when a cwd filter exists, and both value changes restart initial page loading while preserving provider/filter context;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` toolbar rendering: wide toolbar renders discrete active/inactive Cwd/All and Updated/Created options, compact toolbar renders the current value, focused active values are highlighted, and missing cwd collapses Filter to All;
- keep no-live/no-render/no-filesystem behavior deterministic, with no real config writes, terminal backend mutation, app-server requests beyond typed reset intent, or Cafex behavior.

Status: HXCX-TUI-100 extends `fixtures/hxrust/tui-smoke.v1.json` with typed resume picker density toggle success/failure, query preservation, config persistence intent, inline error surfacing, toolbar focus cycling, Sort/Filter activation, toolbar render mode, provider/cwd filter preservation, and no-live/no-render/no-filesystem evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic density/toolbar/persistence evidence only, not live crossterm input, real config writes, live app-server fanout, state DB/rollout querying, ratatui rendering, or persistent session mutation.

### HXCX-TUI-101: Resume Picker Footer Progress Render Boundary

Extend HXCX-TUI-100 from density and toolbar behavior into selected raw Codex resume picker footer, progress, loading, and inline render-state behavior, without live terminal ownership, app-server transport, state DB/rollout querying, filesystem mutation, model traffic, or ratatui rendering:

- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `picker_footer_progress_label`: progress labels use selected position, known loaded total, an ellipsis while loading, scroll percent, compact fallbacks for narrow widths, and the frozen footer percent while a page load is pending;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `footer_hint_lines`, `hint_line_for_row`, and hint fitting: normal mode chooses wide/compact/key-only fallbacks by width, search mode changes the Esc label to clear-search intent, and transcript-loading mode replaces normal hints with loading/ctrl-c guidance;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` list render state: more-above and more-below indicators reserve rows, pending pagination changes the bottom label to loading-more, and in-list loading older sessions appears only when there is remaining space;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `render_empty_state_line`: empty states distinguish initial loading, search still scanning, search scan-cap exhaustion, search no-results, older-page loading, and no-sessions-yet;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` `render_transcript_loading_overlay`: pending transcript open renders the centered `Loading transcript…` overlay after the loading frame is noted;
- keep no-live/no-render behavior deterministic, with no live terminal backend mutation, real app-server pagination, filesystem mutation, or Cafex behavior.

Status: HXCX-TUI-101 extends `fixtures/hxrust/tui-smoke.v1.json` with typed resume picker footer progress labels, frozen loading percent, hint fit modes, more indicators, loading older line intent, empty/search/scan-cap render messages, transcript loading overlay text, and no-live/no-render evidence and validates the slice through `harness/check-tui-smoke.sh`. This is deterministic footer/progress/render-state evidence only, not live crossterm input, real ratatui snapshots, live app-server fanout, state DB/rollout querying, or persistent session mutation.

### HXCX-TUI-102: Resume Picker Live App-Server Terminal Integration Plan

Bridge the completed deterministic resume picker smoke boundaries into the first live upstream/raw Codex haxe->rust TUI implementation sequence:

- preserve the upstream split between `../codex/codex-rs/tui/src/resume_picker.rs` pure picker state and effectful loader/render/persistence surfaces: `PickerState`, `spawn_app_server_page_loader`, `load_app_server_page`, `load_transcript_preview`, `toggle_density`, and `persist_density`;
- preserve the app-server contract from `../codex/codex-rs/tui/src/app_server_session.rs`: `AppServerSession`, `thread_list`, and `thread_read`, including no-credential fixture-backed routes before credentialed provider traffic;
- preserve transcript overlay behavior from `../codex/codex-rs/tui/src/thread_transcript.rs` and `../codex/codex-rs/tui/src/pager_overlay.rs`: `load_session_transcript`, `thread_to_transcript_cells`, `Overlay::new_transcript`, and `TranscriptOverlay`;
- preserve terminal and frame scheduling ownership from `../codex/codex-rs/tui/src/tui.rs`, `../codex/codex-rs/tui/src/custom_terminal.rs`, and `../codex/codex-rs/tui/src/tui/frame_requester.rs`: crossterm terminal initialization, ratatui frame draws, restore guards, `FrameRequester`, and `FrameScheduler`;
- preserve config persistence from `../codex/codex-rs/core/src/config/edit.rs` `ConfigEditsBuilder::set_session_picker_view`, with temp-home gates before real user config mutation;
- keep haxe.rust pressure generic: async task/channel lowering, terminal/frame borrow lifetimes, RAII restore guards, trait-object/renderable support, low-clone collections, and native result/error boundaries must be fixed in `../haxe.rust` with product-neutral fixtures if they block production-quality output.

Status: HXCX-TUI-102 adds the detailed live integration plan in `docs/resume-picker-live-integration-plan.md` and leaves the Beads queue with upstream/raw implementation work before Cafex adapter work. This is planning and sequencing evidence only, not a live generated TUI binary yet.

### HXCX-TUI-103: Resume Picker Pure State Kernel

Start converting the deterministic resume picker smoke evidence into an upstream-shaped Haxe module before adding live host effects:

- preserve the pure state/effect split from `../codex/codex-rs/tui/src/resume_picker.rs` `PickerState`, page request handling, transcript preview/open lifecycle, density/toolbar decisions, footer progress, empty-state labels, and loading overlay state;
- map only the upstream-shaped smoke fixture boundary into `ResumePickerCommand`; after that boundary, use typed Haxe command/state/effect values rather than stringly dispatch;
- keep host effects as intents: page load, preview load, transcript load, density persistence, frame scheduling, load-more, start-fresh, transcript overlay open, and inline error surfacing;
- validate the kernel through both the Haxe interpreter and haxe.rust-generated Rust using the existing deterministic smoke fixture;
- keep the slice mainstream/raw Codex only, with no Cafex behavior and no live app-server, terminal, ratatui, config, state DB, model, or filesystem takeover.

Status: HXCX-TUI-103 adds `src/codexhx/runtime/tui/resume/`, `test/ResumePickerKernelHarness.hx`, `hxml/resume-picker-kernel.hxml`, and `harness/check-resume-picker-kernel.sh`. The new gate validates picker open, page request/ingest, stale page refusal, search continuation, sort/filter toggles, preview request/completion/render gating, transcript request/loading/completion/overlay opening, keyboard movement, query clearing, load-more intent, metadata failure, density persistence intent, toolbar focus/activation/render state, footer progress, hints, list render state, empty-state labels, loading overlay text, selection, failure surfacing, and no-live/no-render evidence through portable haxe.rust. This is pure state/effect-intent evidence only, not live app-server fanout, crossterm input, ratatui rendering, config mutation, state DB/rollout querying, or pager overlay ownership.

### HXCX-TUI-104: Resume Picker Runtime-Neutral Host Facade

Define the first host seam that can satisfy resume picker effect intents without exposing Rust runtime details to app-facing Haxe APIs:

- preserve `../codex/codex-rs/tui/src/app_server_session.rs` thread-list and thread-read boundaries as typed Haxe request/response contracts, not raw JSON strings or live transport handles;
- preserve `../codex/codex-rs/tui/src/resume_picker.rs` loader behavior as background request/event contracts for page, preview, transcript, and frame intents;
- preserve `../codex/codex-rs/tui/src/tui/frame_requester.rs` scheduling as a frame scheduler handle that reports deterministic request evidence before real Tokio scheduling exists;
- preserve terminal rendering and config persistence as host interfaces, leaving crossterm, ratatui frame lifetimes, temp-home config writes, and real user config mutation to later native/metal slices;
- reuse the runtime-neutral async contract for tasks, streams, poll/next outcomes, cancellation, lossless events, best-effort drops, and backpressure;
- keep the slice mainstream/raw Codex only, with no Cafex behavior and no Tokio, crossterm, ratatui, or Codex-specific haxe.rust compiler assumptions in app-facing Haxe.

Status: HXCX-TUI-104 adds `src/codexhx/runtime/tui/resume/host/`, `test/ResumePickerHostFacadeHarness.hx`, `hxml/resume-picker-host-facade.hxml`, and `harness/check-resume-picker-host-facade.sh`. The gate validates deterministic app-server thread source, background loader page/preview/transcript/frame events, lossless versus best-effort backpressure, cancellation, frame scheduling, terminal renderer snapshots, configured and unconfigured density persistence, and portable haxe.rust-generated Rust output. This is host-contract evidence only, not live JSON-RPC transport, crossterm input, ratatui rendering, config file mutation, state DB/rollout querying, or pager overlay ownership.

### HXCX-TUI-105: Resume Picker No-Credential App-Server Render Gate

Compose the pure picker state and runtime-neutral host facade into the first generated-Rust no-credential resume picker app-loop proof:

- load fixture-backed thread/list and thread/read responses through the same typed host facade used by future production app-server implementations;
- accept deterministic key events for selection movement, transcript open, and density toggle without exposing live crossterm details in app-facing Haxe;
- request frames and render through the terminal/test renderer after open, page load, key movement, transcript loading, transcript loaded, and density persistence;
- open the selected transcript overlay after `thread/read(include_turns=true)` completes and preserve selected thread evidence;
- persist the dense picker view into a temp Codex home, never the user's real config;
- keep the slice mainstream/raw Codex only, with no Cafex behavior and no model credentials, live JSON-RPC transport, real terminal takeover, state DB/rollout querying, or Codex-specific haxe.rust compiler assumptions.

Status: HXCX-TUI-105 adds `src/codexhx/validation/tui/resume/live/`, `src/codexhx/runtime/tui/resume/host/TempHomeConfigPersistence.hx`, `test/ResumePickerNoCredentialGateHarness.hx`, `hxml/resume-picker-no-credential-gate.hxml`, and `harness/check-resume-picker-no-credential-gate.sh`. The gate validates fixture-backed page load, transcript load, three deterministic key events, six frame requests, six renders, overlay opening, and temp-home `config.toml` density persistence through the Haxe interpreter and portable haxe.rust-generated Cargo `check`, `test`, and binary execution. This is the first combined no-credential generated-Rust resume picker gate, not live crossterm/ratatui ownership or production app-server transport.

### HXCX-TUI-106: Resume Picker VT100/Test-Backend Render Snapshot Gate

Replace counter-only rendering proof for the no-credential resume picker path with stable normalized screen snapshots:

- carry typed visible row data in `ResumePickerState` so render output is not stringly or fixture-hidden;
- render open, page-loaded, selection-moved, transcript-loading, transcript-loaded, and density-persisted states through the deterministic terminal renderer;
- assert visible rows, selected row marker, footer progress, loading overlay, transcript overlay, and temp-home density config evidence in a generated-Rust harness;
- keep the gate credential-free and non-destructive, with no live crossterm takeover, ratatui frame lifetime ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-106 adds `ResumePickerVisibleRow`, upgrades `DeterministicTerminalRenderer` from state-summary strings to normalized screen snapshots, extends the no-credential report with render snapshots, and adds `test/ResumePickerRenderSnapshotHarness.hx`, `hxml/resume-picker-render-snapshot.hxml`, and `harness/check-resume-picker-render-snapshot.sh`. The gate validates six stable snapshots through Haxe interpreter execution, portable haxe.rust generation, generated Cargo `check`, generated Cargo `test`, and generated binary execution. This is normalized test-backend render evidence only, not live crossterm/ratatui ownership.

### HXCX-TUI-107: Resume Picker Transcript Preview Render Snapshot Gate

Extend the normalized resume picker renderer from selected-row and transcript-overlay evidence into inline transcript preview evidence:

- drive `thread/read previewOnly=true` through the runtime-neutral host facade and deterministic background loader;
- render preview-loading and preview-loaded states for the expanded selected row;
- assert selected row, preview lines, footer progress, and host preview event evidence in a generated-Rust harness;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-107 extends `ResumePickerVisibleRow` with typed preview lines, teaches `DeterministicTerminalRenderer` to render indented preview lines, and adds `ResumePickerPreviewGate`, `ResumePickerPreviewReport`, `test/ResumePickerPreviewRenderHarness.hx`, `hxml/resume-picker-preview-render.hxml`, and `harness/check-resume-picker-preview-render.sh`. The gate validates fixture-backed page load plus preview `thread/read`, preview-loading snapshot, loaded preview-line snapshot, frame/render counts, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live terminal or ratatui ownership.

### HXCX-TUI-108: Resume Picker Pagination Load-More Render Snapshot Gate

Extend the normalized resume picker renderer from preview evidence into pagination/load-more evidence:

- drive first and second `thread/list` page loads through the runtime-neutral host facade and deterministic background loader;
- render loaded rows with next-cursor, `moreBelow`, and loading-older state before ingesting the second page;
- assert selected row, second-page rows, footer progress, frame/render counts, and host page-load event evidence in a generated-Rust harness;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-108 teaches `DeterministicTerminalRenderer` to include normalized pagination state when there is a next page or loading-older marker, and adds `ResumePickerPaginationGate`, `ResumePickerPaginationReport`, `test/ResumePickerPaginationRenderHarness.hx`, `hxml/resume-picker-pagination-render.hxml`, and `harness/check-resume-picker-pagination-render.sh`. The gate validates fixture-backed first-page load, next-cursor/more-below render evidence, loading-older render evidence, second-page ingest, final loaded rows, footer progress, frame/render counts, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live terminal or ratatui ownership.

### HXCX-TUI-109: Resume Picker Empty And Error Render Snapshot Gate

Extend the normalized resume picker renderer from pagination evidence into empty/loading/no-results and page-failure evidence:

- render initial loading, no-sessions, search no-results, and failed page-load states through the deterministic terminal renderer;
- drive the page failure through the runtime-neutral host facade so the visible inline error comes from the same typed failure path as future app-server work;
- assert empty labels, search query display, error code/message, footer state, frame/render counts, and host event evidence in a generated-Rust harness;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-109 teaches `DeterministicTerminalRenderer` to render typed empty-state and inline error lines, and adds `ResumePickerEmptyErrorGate`, `ResumePickerEmptyErrorReport`, `test/ResumePickerEmptyErrorRenderHarness.hx`, `hxml/resume-picker-empty-error-render.hxml`, and `harness/check-resume-picker-empty-error-render.sh`. The gate validates initial loading, no-sessions, search no-results, missing page fixture failure, visible error label, footer state, frame/render counts, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live terminal or ratatui ownership.

### HXCX-TUI-110: Resume Picker Transcript Overlay Detail Render Snapshot Gate

Extend the normalized resume picker renderer from overlay-open count evidence into visible transcript detail evidence:

- drive fixture-backed full `thread/read includeTurns=true` requests through the runtime-neutral host facade;
- render pending transcript loading, loaded transcript detail cells, and empty-transcript fallback cells through the deterministic terminal renderer;
- assert selected rows, overlay thread ids, transcript labels, footer state, frame/render counts, and host transcript event evidence in a generated-Rust harness;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime ownership, pager overlay ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-110 adds typed `ResumePickerState.transcriptCells`, teaches `DeterministicTerminalRenderer` to render normalized transcript cell lines when an overlay is open, and adds `TranscriptOverlayGate`, `TranscriptOverlayReport`, `test/ResumePickerTranscriptOverlayRenderHarness.hx`, `hxml/resume-picker-transcript-overlay-render.hxml`, and `harness/check-resume-picker-transcript-overlay-render.sh`. The gate validates pending loading overlay, loaded detail cells, empty-fallback cell rendering, footer state, frame/render counts, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live terminal, ratatui, or pager overlay ownership.

### HXCX-TUI-111: Resume Picker Toolbar Footer Width Render Snapshot Gate

Extend the normalized resume picker renderer from transcript detail evidence into toolbar and footer layout evidence:

- render Filter and Sort toolbar focus/value states, including wide and compact toolbar modes;
- render wide, compact, key-only, and loading footer/progress variants through the deterministic terminal renderer;
- assert toolbar labels, footer hint modes, width/fallback flags, progress text, and frame/render counts in a generated-Rust harness;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime/layout ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-111 teaches `DeterministicTerminalRenderer` to emit optional normalized toolbar-detail and footer-hints lines, and adds `ToolbarFooterGate`, `ToolbarFooterReport`, `test/ResumePickerToolbarFooterRenderHarness.hx`, `hxml/resume-picker-toolbar-footer-render.hxml`, and `harness/check-resume-picker-toolbar-footer-render.sh`. The gate validates filter/sort toolbar focus, wide/compact/key-only/loading footer variants, frame/render counts, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live terminal or ratatui layout ownership.

### HXCX-TUI-112: Resume Picker Keyboard Navigation Render Snapshot Gate

Extend the normalized resume picker renderer from toolbar/footer evidence into visible keyboard navigation evidence:

- render initial selection, down movement, page/end-style movement, search query display, and query-clear/start-fresh restoration through the deterministic terminal renderer;
- surface selected index, scroll top, viewport row count, more-above evidence, and page-down completion evidence in normalized render snapshots;
- assert visible selected rows, query text, footer state, frame counts, and render counts in a generated-Rust harness;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime/layout ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-112 teaches `DeterministicTerminalRenderer` to emit an optional normalized navigation line, and adds `KeyboardNavigationGate`, `KeyboardNavigationReport`, `test/ResumePickerKeyboardNavigationRenderHarness.hx`, `hxml/resume-picker-keyboard-navigation-render.hxml`, and `harness/check-resume-picker-keyboard-navigation-render.sh`. The gate validates selection movement, page/end-style scroll evidence, search query display, query-clear/start-fresh restoration, frame/render counts, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live terminal or ratatui input/layout ownership.

### HXCX-TUI-113: Resume Picker Density Persistence Render Snapshot Gate

Extend the normalized resume picker renderer from keyboard navigation evidence into density config persistence success and failure evidence:

- render temp Codex-home `config.toml` density persistence success through the existing config persistence facade;
- render persistence-unconfigured failure with inline error, config status, density, footer label, and frame/render count evidence;
- surface normalized config persistence status/path lines without claiming live user config mutation;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime/layout ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-113 adds normalized `ResumePickerState.configPersistenceStatus` and `configPersistencePath` render evidence, plus `DensityPersistenceGate`, `DensityPersistenceReport`, `test/ResumePickerDensityPersistenceRenderHarness.hx`, `hxml/resume-picker-density-persistence-render.hxml`, and `harness/check-resume-picker-density-persistence-render.sh`. The gate validates temp-home dense config write success, persistence-unconfigured failure, visible error/config/footer evidence, frame/render counts, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live user config mutation, terminal ownership, or ratatui input/layout ownership.

### HXCX-TUI-114: Resume Picker Loader Cancellation And Stale Event Render Snapshot Gate

Extend the normalized resume picker renderer from density persistence evidence into background-loader cancellation and stale event evidence:

- render accepted baseline page state through the runtime-neutral background loader and host event facade;
- render stale page, preview, and transcript host events as ignored without mutating loaded rows, selected row, preview state, transcript state, or overlay state;
- render loader cancellation evidence and preserve frame-safe recovery after ignored events;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime/layout ownership, Tokio task ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-114 adds normalized `ResumePickerState.loaderEventStatus` and `loaderEventDetail` render evidence, plus `LoaderCancellationGate`, `LoaderCancellationReport`, `test/ResumePickerLoaderCancellationRenderHarness.hx`, `hxml/resume-picker-loader-cancellation-render.hxml`, and `harness/check-resume-picker-loader-cancellation-render.sh`. The gate validates stale page/preview/transcript event refusal, stable baseline/final picker state, loader cancellation evidence, frame/render counts, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live app-server fanout, terminal ownership, Tokio task ownership, or ratatui input/layout ownership.

### HXCX-TUI-115: Resume Picker Host Backpressure Render Snapshot Gate

Extend the normalized resume picker renderer from loader cancellation evidence into bounded loader backpressure evidence:

- render best-effort frame drop evidence when a bounded loader stream is full;
- render lossless page request backpressure evidence with pending/skipped counts preserved;
- drain the queued event, retry the lossless request, and render recovered page state after the stream accepts it;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime/layout ownership, Tokio task ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-115 adds `HostBackpressureGate`, `HostBackpressureReport`, `test/ResumePickerHostBackpressureRenderHarness.hx`, `hxml/resume-picker-host-backpressure-render.hxml`, and `harness/check-resume-picker-host-backpressure-render.sh`. The gate validates best-effort frame drop, lossless page backpressure, skipped/pending counts, post-drain recovery, frame/render counts, warning-clean generated Rust, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live app-server fanout, terminal ownership, Tokio task ownership, or ratatui input/layout ownership.

### HXCX-TUI-116: Resume Picker Invalid Row Projection Render Snapshot Gate

Extend the normalized resume picker renderer from bounded loader backpressure evidence into app-server row projection evidence:

- render scanned, accepted, and invalid/skipped row counts after fixture-backed `thread/list` projection;
- render accepted rows only, including display title/preview fallbacks, timestamp evidence, and cwd metadata preservation;
- keep skipped invalid rows visible as count/status evidence without rendering invalid row data as selectable rows;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime/layout ownership, Tokio task ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-116 teaches `DeterministicTerminalRenderer` to include `invalid` row counts and `cwd` row metadata, and adds `InvalidRowProjectionGate`, `InvalidRowProjectionReport`, `test/ResumePickerInvalidRowProjectionRenderHarness.hx`, `hxml/resume-picker-invalid-row-projection-render.hxml`, and `harness/check-resume-picker-invalid-row-projection-render.sh`. The gate validates three accepted rows out of five scanned rows, two invalid/skipped rows, fallback display rows, timestamp/cwd metadata, loader status evidence, frame/render counts, warning-clean generated Rust, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live app-server fanout, terminal ownership, Tokio task ownership, or ratatui input/layout ownership.

### HXCX-TUI-117: Resume Picker Scan-Cap Render Snapshot Gate

Extend the normalized resume picker renderer from row projection evidence into reached-scan-cap pagination evidence:

- render reached-scan-cap pages with next-cursor, `moreBelow`, loading-older, and explicit `scanCap=true` evidence;
- render ordinary non-capped pages with `scanCap=false`, next-cursor policy, and footer/list recovery;
- keep the final recovered list visible with no remaining next cursor;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime/layout ownership, Tokio task ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-117 teaches `DeterministicTerminalRenderer` to include normalized `scanCap` and `nextPresent` page evidence, and adds `ResumePickerScanCapGate`, `ResumePickerScanCapReport`, `test/ResumePickerScanCapRenderHarness.hx`, `hxml/resume-picker-scan-cap-render.hxml`, and `harness/check-resume-picker-scan-cap-render.sh`. The gate validates capped-page rendering, capped-cursor loading state, non-capped cursor pagination, final list recovery, frame/render counts, warning-clean generated Rust, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live app-server fanout, terminal ownership, Tokio task ownership, or ratatui input/layout ownership.

### HXCX-TUI-118: Resume Picker Query Reload Render Snapshot Gate

Extend the normalized resume picker renderer from scan-cap pagination evidence into query/search reload evidence:

- render an initial page with ordinary cursor state before query changes;
- render query reset/loading state with the search text visible, rows/cursor cleared, and footer/status evidence;
- render fixture-backed query results and preserve request id, query, and cursor fields for the host `thread/list` call;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime/layout ownership, Tokio task ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-118 adds `ResumePickerQueryReloadGate`, `ResumePickerQueryReloadReport`, `test/ResumePickerQueryReloadRenderHarness.hx`, `hxml/resume-picker-query-reload-render.hxml`, and `harness/check-resume-picker-query-reload-render.sh`. The gate validates initial page rendering, query reset/loading rendering, preserved `thread/list` query/cursor fields, fixture-backed query result rendering, footer/recovery evidence, frame/render counts, warning-clean generated Rust, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live app-server fanout, terminal ownership, Tokio task ownership, or ratatui input/layout ownership.

### HXCX-TUI-119: Resume Picker Sort/Filter Reload Render Snapshot Gate

Extend the normalized resume picker renderer from query reload evidence into sort/filter reload evidence:

- render an initial queried page with `updated_at` plus `cwd` toolbar state and cursor evidence;
- render sort/filter reset state with `created_at` plus `all`, active query preservation, cleared cursor/list state, and footer/status evidence;
- render fixture-backed reloaded results while preserving request fields for sort, filter, query, cwd, show-all, and include-non-interactive policy;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime/layout ownership, Tokio task ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-119 adds `SortFilterReloadGate`, `SortFilterReloadReport`, `test/ResumePickerSortFilterReloadRenderHarness.hx`, `hxml/resume-picker-sort-filter-reload-render.hxml`, and `harness/check-resume-picker-sort-filter-reload-render.sh`. The gate validates initial queried page rendering, sort/filter reset/loading rendering, active query preservation, preserved `thread/list` sort/filter/cwd/show-all fields, fixture-backed reloaded result rendering, footer/recovery evidence, frame/render counts, warning-clean generated Rust, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live app-server fanout, terminal ownership, Tokio task ownership, or ratatui input/layout ownership.

### HXCX-TUI-120: Resume Picker Stale Reload Response Render Snapshot Gate

Extend the normalized resume picker renderer from sort/filter reload evidence into stale reload response refusal evidence:

- render an active query/sort result page as the state that must be preserved;
- feed older query and sort page responses through the host facade and render stale-refusal evidence instead of applying their rows/cursors;
- prove active query/sort/filter text, selected row, cursor, visible rows, and footer remain stable;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime/layout ownership, Tokio task ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-120 adds `StaleReloadResponseGate`, `StaleReloadResponseReport`, `test/ResumePickerStaleReloadResponseRenderHarness.hx`, `hxml/resume-picker-stale-reload-response-render.hxml`, and `harness/check-resume-picker-stale-reload-response-render.sh`. The gate validates active result rendering, stale query response refusal, stale sort response refusal, active row/selection/cursor/footer preservation, stale-refusal status rendering, frame/render counts, warning-clean generated Rust, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live app-server fanout, terminal ownership, Tokio task ownership, or ratatui input/layout ownership.

### HXCX-TUI-121: Resume Picker No-Results Reload Recovery Render Snapshot Gate

Extend the normalized resume picker renderer from stale-response refusal into current empty-result and recovery behavior:

- render an active result page before the query changes;
- apply a current empty query response and render no-results state, cleared rows, cleared selection, and footer/status evidence;
- apply a later current recovery response and render restored rows, selection, and recovery footer/status evidence;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime/layout ownership, Tokio task ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-121 adds `NoResultsRecoveryGate`, `NoResultsRecoveryReport`, `test/ResumePickerNoResultsReloadRecoveryRenderHarness.hx`, `hxml/resume-picker-no-results-reload-recovery-render.hxml`, and `harness/check-resume-picker-no-results-reload-recovery-render.sh`. The gate validates active result rendering, current no-results reload rendering, cleared row/selection/footer evidence, current recovery reload rendering, restored row/selection/footer evidence, frame/render counts, warning-clean generated Rust, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live app-server fanout, terminal ownership, Tokio task ownership, or ratatui input/layout ownership.

### HXCX-TUI-122: Resume Picker Reload Selection Preservation Render Snapshot Gate

Extend the normalized resume picker renderer from no-results recovery into current reload selection behavior:

- render an active selected row before reload;
- apply a current reload where that selected thread remains and render stable-thread selection preservation at the new index;
- apply a current reload where the selected thread is absent and render deterministic fallback selection evidence;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime/layout ownership, Tokio task ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-122 adds `SelectionPreservationGate`, `SelectionPreservationReport`, `test/ResumePickerReloadSelectionPreservationRenderHarness.hx`, `hxml/resume-picker-reload-selection-preservation-render.hxml`, and `harness/check-resume-picker-reload-selection-preservation-render.sh`. The gate validates active selected-row rendering, stable-thread selection preservation across reload, deterministic first-row fallback when the prior selection disappears, footer/status evidence, frame/render counts, warning-clean generated Rust, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live app-server fanout, terminal ownership, Tokio task ownership, or ratatui input/layout ownership.

### HXCX-TUI-123: Resume Picker Reload Scroll Preservation Render Snapshot Gate

Extend the normalized resume picker renderer from selection preservation into scroll-window reload behavior:

- render an active scrolled list with a selected row visible inside the scroll window;
- apply a current reload where the selected row remains visible and preserve `scrollTop`/top-row navigation evidence;
- apply a current reload where the result count shrinks and render deterministic scroll clamping plus footer/status evidence;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime/layout ownership, Tokio task ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-123 adds `ScrollPreservationGate`, `ScrollPreservationReport`, `test/ResumePickerReloadScrollPreservationRenderHarness.hx`, `hxml/resume-picker-reload-scroll-preservation-render.hxml`, and `harness/check-resume-picker-reload-scroll-preservation-render.sh`. The gate validates active scrolled-list rendering, current reload scroll/top-row preservation, current shrink reload scroll clamping, footer/status evidence, frame/render counts, warning-clean generated Rust, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live app-server fanout, terminal ownership, Tokio task ownership, or ratatui input/layout ownership.

### HXCX-TUI-124: Resume Picker Reload Preview Invalidation Render Snapshot Gate

Extend the normalized resume picker renderer from scroll preservation into preview cache behavior across reloads:

- render a selected row with loaded preview lines from a fixture-backed preview read;
- apply a current reload where the same selected thread remains selected and keep the preview attached;
- apply a current reload that selects a different thread and render stale preview invalidation plus expanded/pending transcript-preview cache clearing;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime/layout ownership, Tokio task ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-124 adds `PreviewInvalidationGate`, `PreviewInvalidationReport`, `test/ResumePickerReloadPreviewInvalidationRenderHarness.hx`, `hxml/resume-picker-reload-preview-invalidation-render.hxml`, and `harness/check-resume-picker-reload-preview-invalidation-render.sh`. The gate validates selected-row preview rendering, stable-thread preview preservation, selection-change preview invalidation, expanded/pending transcript-preview cache clearing summaries, footer/status evidence, frame/render counts, warning-clean generated Rust, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live app-server fanout, terminal ownership, Tokio task ownership, or ratatui input/layout ownership.

### HXCX-TUI-125: Resume Picker Reload Transcript Overlay Invalidation Render Snapshot Gate

Extend the normalized resume picker renderer from preview invalidation into transcript overlay cache behavior across reloads:

- render a selected row with loaded transcript overlay detail from a fixture-backed transcript read;
- apply a current reload where the same selected/pending thread remains valid and keep the overlay detail attached;
- apply a current reload that selects a different thread and render stale overlay invalidation plus pending transcript/cell clearing;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime/layout ownership, Tokio task ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-125 adds `TranscriptOverlayInvalidationGate`, `TranscriptOverlayInvalidationReport`, `test/ResumePickerReloadTranscriptOverlayInvalidationRenderHarness.hx`, `hxml/resume-picker-reload-transcript-overlay-invalidation-render.hxml`, and `harness/check-resume-picker-reload-transcript-overlay-invalidation-render.sh`. The gate validates selected-row transcript overlay rendering, stable-thread overlay preservation, selection-change overlay invalidation, pending transcript/cell clearing summaries, footer/status evidence, frame/render counts, warning-clean generated Rust, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live app-server fanout, terminal ownership, Tokio task ownership, or ratatui input/layout ownership.

### HXCX-TUI-126: Resume Picker Reload Failure Preservation Render Snapshot Gate

Extend the normalized resume picker renderer from overlay invalidation into current reload failure handling:

- render an active list with selected row, active query, and stable footer state;
- apply a current reload failure from the deterministic background loader and preserve the prior rows, selection, query, and scroll while surfacing loader/error/footer evidence;
- apply a later successful current reload and render recovery with cleared error state;
- keep the gate credential-free and test-backend only, with no live crossterm takeover, ratatui frame lifetime/layout ownership, Tokio task ownership, state DB mutation, model traffic, Cafex behavior, or Codex-specific haxe.rust compiler behavior.

Status: HXCX-TUI-126 adds `FailurePreservationGate`, `FailurePreservationReport`, `test/ResumePickerReloadFailurePreservationRenderHarness.hx`, `hxml/resume-picker-reload-failure-preservation-render.hxml`, and `harness/check-resume-picker-reload-failure-preservation-render.sh`. The gate validates prior row/selection/query preservation across a current reload failure, visible error/loader/footer state, later successful recovery, frame/render counts, warning-clean generated Rust, and generated Cargo `check`, `test`, and binary execution. This is still normalized test-backend evidence only, not live app-server fanout, terminal ownership, Tokio task ownership, or ratatui input/layout ownership.

### HXCX-TUI-127: Resume Picker Live App-Server Boundary Render Snapshot Gate

Extend the normalized resume picker renderer from deterministic reload failure handling into the typed app-server request boundary:

- route `thread/list` reload requests through the host facade and in-memory app-server source while recording request id, cursor, query, sort, filter, cwd, show-all, and include-non-interactive fields;
- prove bounded lossless loader backpressure accounting before the queued reload can surface;
- map a source/app-server failure into visible picker error state without dropping the prior rows/selection;
- render later recovery and keep the gate credential-free, model-free, state-DB-free, and Cafex-free.

Status: HXCX-TUI-127 adds request-field logging to `InMemoryThreadSource`, plus `AppServerBoundaryGate`, `AppServerBoundaryReport`, `test/ResumePickerLiveAppServerBoundaryRenderHarness.hx`, `hxml/resume-picker-live-app-server-boundary-render.hxml`, and `harness/check-resume-picker-live-app-server-boundary-render.sh`. The gate validates typed `thread/list` request id and params preservation, bounded lossless backpressure, app-server source failure mapping, visible normalized error/recovery rendering, no credential/model/state DB mutation, warning-clean generated Rust, and generated Cargo `check`, `test`, and binary execution. This is still deterministic typed-boundary evidence only, not live JSON-RPC transport, terminal ownership, Tokio task ownership, ratatui input/layout ownership, SQLite/state DB mutation, or Cafex behavior.

### HXCX-TUI-128: Resume Picker JSON-RPC Thread/List Transport Render Gate

Extend the typed app-server boundary into a fixture-backed JSON-RPC `thread/list` transport boundary:

- encode resume picker page requests into upstream-shaped `thread/list` method/params;
- preserve request ids, cursor/query/sort/filter/cwd/show-all/include-non-interactive evidence;
- decode deterministic JSON-RPC `thread/list` results into typed picker rows;
- map JSON-RPC error payloads into visible loader/error state while preserving existing rows;
- render recovery after a later successful JSON-RPC response;
- keep the gate credential-free, model-free, state-DB-free, and Cafex-free.

Status: HXCX-TUI-128 adds `JsonRpcThreadSource`, `JsonRpcThreadListTransportGate`, `JsonRpcThreadListTransportReport`, `test/ResumePickerJsonRpcThreadListTransportRenderHarness.hx`, `hxml/resume-picker-json-rpc-thread-list-transport-render.hxml`, and `harness/check-resume-picker-json-rpc-thread-list-transport-render.sh`. The gate validates preserved JSON-RPC method, params, and request id, deterministic result decoding, app-server error mapping, transport event summaries, visible normalized error/recovery rendering, no credential/model/state DB mutation, warning-clean generated Rust, and generated Cargo `check`, `test`, and binary execution. This is deterministic fixture transport evidence only, not live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, or Cafex behavior.

### HXCX-TUI-129: Resume Picker JSON-RPC Thread/Read Transport Render Gate

Extend the fixture-backed JSON-RPC transport boundary from `thread/list` into selected `thread/read` preview and transcript behavior:

- encode picker read requests into upstream-shaped `thread/read` method/params with `threadId` and `includeTurns` only;
- keep picker-local preview hints such as `previewOnly` and `maxPreviewLines` out of the JSON-RPC wire params;
- decode deterministic `ThreadReadResponse.thread.preview` into capped preview lines for inline picker rendering;
- decode deterministic included turns/items into typed transcript-cell render evidence for the overlay path;
- map JSON-RPC read errors into visible loader/error state while preserving existing preview/list state;
- keep the gate credential-free, model-free, state-DB-free, and Cafex-free.

Status: HXCX-TUI-129 adds JSON-RPC `thread/read` support to `JsonRpcThreadSource`, plus `JsonRpcThreadReadTransportGate`, `JsonRpcThreadReadTransportReport`, `test/ResumePickerJsonRpcThreadReadTransportRenderHarness.hx`, `hxml/resume-picker-json-rpc-thread-read-transport-render.hxml`, and `harness/check-resume-picker-json-rpc-thread-read-transport-render.sh`. The gate validates preserved upstream-shaped method, params, and request id, local preview truncation, deterministic transcript-cell decoding, app-server error mapping, transport event summaries, visible normalized preview/error/transcript rendering, no credential/model/state DB mutation, warning-clean generated Rust, and generated Cargo `check`, `test`, and binary execution. This is deterministic fixture transport evidence only, not live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, or Cafex behavior.

### HXCX-TUI-130: Resume Picker App-Server Stream/Fanout Render Gate

Move the fixture-backed JSON-RPC source closer to the upstream app-server client stream shape:

- enqueue `thread/list` and `thread/read` requests without immediate fixture completion;
- preserve upstream-shaped method, params, and request id while holding typed pending requests;
- resolve page and preview responses through correlated request ids while other reads remain pending;
- surface bounded lossless transport backpressure as a typed picker host failure;
- drain transport stream events and recover with a later JSON-RPC read error plus successful transcript response;
- keep the gate credential-free, model-free, state-DB-free, and Cafex-free.

Status: HXCX-TUI-130 adds two-phase fanout hooks to `JsonRpcThreadSource`, `StreamFanout`, `AppServerStreamFanoutGate`, `AppServerStreamFanoutReport`, `test/StreamFanoutRenderHarness.hx`, `hxml/resume-picker-app-server-stream-fanout-render.hxml`, and `harness/check-resume-picker-app-server-stream-fanout-render.sh`. The gate validates typed pending ownership, upstream JSON-RPC method/params/request-id preservation, correlated page/preview/transcript response routing, deterministic lossless backpressure routing, JSON-RPC read-error mapping, transport event summaries, visible normalized transcript recovery, no credential/model/state DB mutation, warning-clean generated Rust, and generated Cargo `check`, `test`, and binary execution. This is deterministic stream/fanout evidence only, not live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, or Cafex behavior.

### HXCX-TUI-131: Resume Picker App-Server Session Lifecycle Render Gate

Extend the stream/fanout proof into deterministic app-server session lifecycle behavior:

- tie `thread/list` and `thread/read` pending requests to a typed session lifecycle;
- cancel pending page/read requests before disconnect and reconcile pending counts;
- reject a late response that arrives after cancellation removed the request;
- refuse new requests on a disconnected session;
- recover through a fresh session that loads page and transcript state;
- keep the gate credential-free, model-free, state-DB-free, and Cafex-free.

Status: HXCX-TUI-131 adds session cancel/disconnect hooks to `JsonRpcThreadSource` and `StreamFanout`, plus `AppServerSessionLifecycleGate`, `AppServerSessionLifecycleReport`, `test/ResumePickerAppServerSessionLifecycleRenderHarness.hx`, `hxml/resume-picker-app-server-session-lifecycle-render.hxml`, and `harness/check-resume-picker-app-server-session-lifecycle-render.sh`. The gate validates upstream JSON-RPC method/params/request-id preservation, pending cancellation, deterministic late-response rejection, disconnect refusal, fresh-session page/transcript recovery, transport event summaries, visible normalized error/recovery rendering, no credential/model/state DB mutation, warning-clean generated Rust, and generated Cargo `check`, `test`, and binary execution. This is deterministic session-lifecycle evidence only, not live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, or Cafex behavior.

### HXCX-TUI-132 Resume Picker App-Server Event-Pump Boundary

Status: HXCX-TUI-132 adds `StreamEvent`, `EventPump`, `EventPumpDispatch`, `AppServerEventPumpBoundaryGate`, `AppServerEventPumpBoundaryReport`, `test/EventPumpBoundaryRenderHarness.hx`, `hxml/resume-picker-app-server-event-pump-boundary-render.hxml`, and `harness/check-resume-picker-app-server-event-pump-boundary-render.sh`. The gate validates typed queued app-server stream events, active session generation filtering, deterministic stale-event rejection, frame scheduling intent, disconnect propagation, fresh-session recovery, visible normalized render evidence, no credential/model/state DB mutation, warning-clean generated Rust, and generated Cargo `check`, `test`, and binary execution. This is deterministic event-pump boundary evidence only, not live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-133 Resume Picker App-Server Stream Pressure

Status: HXCX-TUI-133 adds lossless/best-effort pressure forwarding to `EventPump`, extends `StreamEvent` with typed progress and server-request event kinds, and adds `AppServerStreamPressureGate`, `AppServerStreamPressureReport`, `test/ResumePickerAppServerStreamPressureRenderHarness.hx`, `hxml/resume-picker-app-server-stream-pressure-render.hxml`, and `harness/check-resume-picker-app-server-stream-pressure-render.sh`. The gate validates upstream-shaped stream pressure behavior: best-effort frame/progress events are allowed to drop when the bounded consumer queue is full, dropped request-like events are rejected with consumer-queue-full evidence, the next lossless event first emits a lag marker, lossless read/page events are preserved, normalized render evidence recovers, and generated Rust runs through Cargo `check`, `test`, and binary execution without credentials, provider/model traffic, state DB mutation, or Cafex behavior. This is deterministic pressure-contract evidence only, not live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-134 Resume Picker App-Server Server-Request Delivery

Status: HXCX-TUI-134 adds a typed `ServerRequestDelivered` host event, `RequestResponseIntent`, `AppServerServerRequestDeliveryGate`, `AppServerServerRequestDeliveryReport`, `test/ResumePickerAppServerServerRequestDeliveryRenderHarness.hx`, `hxml/resume-picker-app-server-server-request-delivery-render.hxml`, and `harness/check-resume-picker-app-server-server-request-delivery-render.sh`. The gate validates the non-dropped request-like app-server stream path: an accepted server request is delivered to the TUI-facing host boundary without being recorded as a pressure rejection, deterministic refusal intent is recorded for the fixture-only interactive surface, normalized render evidence recovers through `thread/list`, and generated Rust runs through Cargo `check`, `test`, and binary execution without credentials, provider/model traffic, state DB mutation, or Cafex behavior. This is deterministic server-request delivery evidence only, not live JSON-RPC response dispatch, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-135 Resume Picker App-Server Response Dispatch Intent

Status: HXCX-TUI-135 adds `DeterministicRequestHandle`, typed app-server response dispatch command DTOs, `AppServerResponseDispatchIntentGate`, `AppServerResponseDispatchIntentReport`, `test/ResumePickerAppServerResponseDispatchIntentRenderHarness.hx`, `hxml/resume-picker-app-server-response-dispatch-intent-render.hxml`, and `harness/check-resume-picker-app-server-response-dispatch-intent-render.sh`. The gate validates the response side of the delivered request path: refused and resolved intents become typed reject/resolve commands, request ids and dispatch order are preserved, unsupported fixture refusal remains distinct from pressure-drop rejection, live transport is suppressed while dispatch intent is recorded, page recovery renders, and generated Rust runs through Cargo `check`, `test`, and binary execution without credentials, provider/model traffic, state DB mutation, or Cafex behavior. This is deterministic response dispatch intent evidence only, not live JSON-RPC response sending, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-136 Resume Picker App-Server Response Dispatch Failure/Noop

Status: HXCX-TUI-136 adds `DispatchFailureNoopGate`, `DispatchFailureNoopReport`, `test/ResumePickerAppServerResponseDispatchFailureNoopRenderHarness.hx`, `hxml/resume-picker-app-server-response-dispatch-failure-noop-render.hxml`, and `harness/check-resume-picker-app-server-response-dispatch-failure-noop-render.sh`. The gate validates the non-happy response dispatch branches exposed by the same typed request handle: missing app-server session produces a no-op command, malformed/missing intent and unknown intent produce serialization refusals, resolved intent without a response payload is refused before send intent, transport send failure is recorded as a typed command, request ids are preserved for delivered requests, pressure-drop rejection remains empty, live transport is suppressed, recovery renders through `thread/list`, and generated Rust runs through Cargo `check`, `test`, and binary execution without credentials, provider/model traffic, state DB mutation, or Cafex behavior. This is deterministic response dispatch failure/noop evidence only, not live JSON-RPC response sending, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-137 Resume Picker App-Server Response Transport Envelope

Status: HXCX-TUI-137 adds `DeterministicResponseTransport`, `ResponseTransportEnvelope`, `ResponseTransportEnvelopeKind`, `ResponseTransportEnvelopeGate`, `ResponseTransportEnvelopeReport`, `test/ResponseTransportEnvelopeRenderHarness.hx`, `hxml/resume-picker-app-server-response-transport-envelope-render.hxml`, and `harness/check-resume-picker-app-server-response-transport-envelope-render.sh`. The gate validates the deterministic transport envelope shape for typed response dispatch commands: resolve commands encode JSON-RPC result payloads, reject commands encode JSON-RPC error payloads, local serialization refusals stay local-only, send failures preserve the intended request id and error payload, request correlation keys remain stable, pressure-drop rejection remains empty, live transport is suppressed, recovery renders through `thread/list`, and generated Rust runs through Cargo `check`, `test`, and binary execution without credentials, provider/model traffic, state DB mutation, or Cafex behavior. This is deterministic response transport envelope evidence only, not live JSON-RPC response sending, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-138 Resume Picker App-Server Pending Request Registry

Status: HXCX-TUI-138 adds `DeterministicPendingRequestRegistry`, `PendingRequestRegistryEvent`, `PendingRequestRegistryEventKind`, `PendingRequestRegistryRecord`, `AppServerPendingRequestRegistryGate`, `AppServerPendingRequestRegistryReport`, `test/ResumePickerAppServerPendingRequestRegistryRenderHarness.hx`, `hxml/resume-picker-app-server-pending-request-registry-render.hxml`, and `harness/check-resume-picker-app-server-pending-request-registry-render.sh`. The gate validates the deterministic pending request registry lifecycle for delivered app-server requests: accepted request registration, duplicate request-id refusal, resolve removal, reject removal, late second-response refusal after removal, abandoned pending cleanup on disconnect, pressure-drop separation, live transport suppression, registry-empty final state, and recovery rendering through `thread/list`; generated Rust runs through Cargo `check`, `test`, and binary execution without credentials, provider/model traffic, state DB mutation, or Cafex behavior. This is deterministic request-id registry evidence only, not full typed upstream `PendingAppServerRequests` parity for exec/file/permissions/user-input/MCP keys, same-turn user-input FIFO, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-139 Resume Picker App-Server Typed Pending Request-Class Registry

Status: HXCX-TUI-139 adds `DeterministicTypedPendingRequestRegistry`, `PendingRequestClassKind`, `TypedPendingRequestEvent`, `TypedPendingRequestEventKind`, `TypedPendingRequestRecord`, `TypedPendingRequestRegistryGate`, `TypedPendingRequestRegistryReport`, `test/ResumePickerAppServerTypedPendingRequestRegistryRenderHarness.hx`, `hxml/resume-picker-app-server-typed-pending-request-registry-render.hxml`, and `harness/check-resume-picker-app-server-typed-pending-request-registry-render.sh`. The gate validates typed upstream pending request-class behavior for exec approval, file-change approval, permissions approval, tool user-input, and MCP elicitation requests: key-based duplicate refusal, same-turn user-input FIFO resolution, MCP server/request matching, unsupported dynamic-tool refusal, notification-side removal, stale replay skip after removal, pressure-drop separation, live transport suppression, registry-empty final state, and recovery rendering through `thread/list`; generated Rust runs through Cargo `check`, `test`, and binary execution without credentials, provider/model traffic, state DB mutation, or Cafex behavior. This is deterministic typed registry evidence only, not class-specific response payload serialization, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-140 Resume Picker App-Server Typed Response Payload Envelope

Status: HXCX-TUI-140 adds `EnvelopeBuilder`, `Envelope`, `EnvelopeKind`, `PayloadKind`, `PayloadEnvelopeGate`, `PayloadEnvelopeReport`, `test/ResumePickerAppServerTypedResponsePayloadEnvelopeRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-payload-envelope-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-payload-envelope-render.sh`. The gate validates class-specific deterministic payload/envelope construction for typed pending request classes: command execution approval and file-change approval decisions, permissions grants, tool request-user-input answers, MCP elicitation responses, unsupported request errors, missing-pending no-ops, request-id correlation, pressure-drop separation, live transport suppression, and recovery rendering through `thread/list`; generated Rust runs through Cargo `check`, `test`, and binary execution without credentials, provider/model traffic, state DB mutation, or Cafex behavior. This is deterministic typed response payload-envelope evidence only, not final live schema exhaustiveness, live JSON-RPC response sending, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-141 Resume Picker App-Server Typed Response Dispatch Ordering And Refresh

Status: HXCX-TUI-141 adds `Dispatcher`, `DispatchOutcome`, `DispatchOutcomeKind`, `DispatchOrderingRefreshGate`, `DispatchOrderingRefreshReport`, `test/ResumePickerAppServerTypedResponseDispatchOrderingRefreshRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-dispatch-ordering-refresh-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-dispatch-ordering-refresh-render.sh`. The gate validates deterministic dispatch ordering after typed payload envelopes: supported exec/file/permissions/user-input/MCP response envelopes preserve source order and schedule pending-replay plus side-parent status refresh intent, unsupported reject and missing-pending local no-op paths do not schedule refresh, a late duplicate response is refused, request correlation remains stable, live transport stays suppressed, pressure-drop rejection remains empty, and recovery renders through `thread/list`; generated Rust runs through Cargo `check`, `test`, and binary execution without credentials, provider/model traffic, state DB mutation, or Cafex behavior. This is deterministic typed response dispatch/refresh-intent evidence only, not live JSON-RPC response sending, real refresh application, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-142 Resume Picker App-Server Typed Response Refresh Application

Status: HXCX-TUI-142 adds `RefreshApplicator`, `RefreshApplication`, `RefreshApplicationKind`, `RefreshApplicationGate`, `RefreshApplicationReport`, `test/RefreshApplicationRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-refresh-application-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-refresh-application-render.sh`. The gate validates deterministic refresh application after typed response dispatch: supported exec/file/permissions/user-input/MCP responses update pending-replay, side-parent status, and active-thread status refresh counters in dispatch order; unsupported reject, missing-pending no-op, and late duplicate paths are ignored without refresh mutation; live transport stays suppressed, pressure-drop rejection remains empty, and recovery renders through `thread/list`; generated Rust runs through Cargo `check`, `test`, and binary execution without credentials, provider/model traffic, state DB mutation, or Cafex behavior. This is deterministic typed response refresh-application evidence only, not live JSON-RPC response sending, production refresh effects, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-143 Resume Picker App-Server Typed Response Refresh Replay Delivery

Status: HXCX-TUI-143 adds `RefreshReplayDeliveryPlanner`, `RefreshReplayDelivery`, `RefreshReplayDeliveryKind`, `RefreshReplayDeliveryGate`, `RefreshReplayDeliveryReport`, `test/RefreshReplayDeliveryRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-refresh-replay-delivery-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-refresh-replay-delivery-render.sh`. The gate validates deterministic replay-delivery intent after typed response refresh application: supported exec/file/permissions/user-input/MCP refresh records produce ordered pending-interactive replay, side-parent status, and active-thread status delivery intents with `thread_snapshot` replay-kind evidence; unsupported reject, missing-pending no-op, and late duplicate paths create skip audit entries but no delivery intents; live transport stays suppressed, pressure-drop rejection remains empty, and recovery renders through `thread/list`; generated Rust runs through Cargo `check`, `test`, and binary execution without credentials, provider/model traffic, state DB mutation, or Cafex behavior. This is deterministic replay-delivery intent evidence only, not live JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-144 Resume Picker App-Server Typed Response Replay Surface Update

Status: HXCX-TUI-144 adds `ReplaySurfaceUpdater`, `ReplaySurfaceUpdate`, `ReplaySurfaceUpdateKind`, `ReplaySurfaceUpdateGate`, `ReplaySurfaceUpdateReport`, `test/ReplaySurfaceUpdateRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-replay-surface-update-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-replay-surface-update-render.sh`. The gate validates deterministic TUI-facing surface updates after replay-delivery intent: supported exec/file/permissions/user-input/MCP deliveries update pending-interactive prompt, side-parent status, and active-thread status surfaces in delivery order; unsupported reject, missing-pending no-op, and late duplicate paths create skip audit entries but no surface updates; live transport stays suppressed, pressure-drop rejection remains empty, and recovery renders through `thread/list`; generated Rust runs through Cargo `check`, `test`, and binary execution without credentials, provider/model traffic, state DB mutation, or Cafex behavior. This is deterministic replay surface-update evidence only, not live JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-145 Resume Picker App-Server Typed Response Surface Recovery Confirmation

Status: HXCX-TUI-145 adds `SurfaceRecoveryConfirmer`, `SurfaceRecoveryConfirmation`, `SurfaceRecoveryConfirmationKind`, `SurfaceRecoveryConfirmationGate`, `SurfaceRecoveryConfirmationReport`, `test/SurfaceRecoveryConfirmationRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-surface-recovery-confirmation-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-surface-recovery-confirmation-render.sh`. The gate validates deterministic recovery confirmation after replay surface updates: the recovered page replaces transient pending-interactive prompt, side-parent status, and active-thread status surfaces; the selected recovered thread remains `thread-surface-a`; ignored no-surface paths remain absent from the final page surface; live transport stays suppressed, pressure-drop rejection remains empty, and generated Rust runs through Cargo `check`, `test`, and binary execution without credentials, provider/model traffic, state DB mutation, or Cafex behavior. This is deterministic surface recovery-confirmation evidence only, not live JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-146 Resume Picker App-Server Typed Response Recovery Follow-Up Action

Status: HXCX-TUI-146 adds `RecoveryFollowUpActionPlanner`, `RecoveryFollowUpAction`, `RecoveryFollowUpActionKind`, `RecoveryFollowUpActionGate`, `RecoveryFollowUpActionReport`, `test/RecoveryFollowUpActionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-follow-up-action-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-follow-up-action-render.sh`. The gate validates deterministic follow-up action intent after recovery confirmation: confirmed recovery produces restored-list status, one follow-up frame request, and recovered-selection readiness; stale pending-interactive prompt, side-parent status, and active-thread status actions remain absent; ignored no-surface paths remain absent; live transport stays suppressed, pressure-drop rejection remains empty, and generated Rust runs through Cargo `check`, `test`, and binary execution without credentials, provider/model traffic, state DB mutation, or Cafex behavior. This is deterministic recovery follow-up action evidence only, not live JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-147 Resume Picker App-Server Typed Response Recovery Idle-State Handoff

Status: HXCX-TUI-147 adds `RecoveryIdleStateHandoffPolicy`, `RecoveryIdleStateHandoff`, `RecoveryIdleStateHandoffKind`, `RecoveryIdleStateHandoffGate`, `RecoveryIdleStateHandoffReport`, `test/RecoveryIdleStateHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-idle-state-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-idle-state-handoff-render.sh`. The gate validates deterministic idle-state handoff after recovery follow-up action intent: restored status, follow-up frame, and recovered-selection actions are accepted; keyboard input and list navigation become ready for `thread-surface-a`; stale pending-interactive prompt, side-parent status, and active-thread status actions remain cleared; ignored no-surface paths remain absent; live transport stays suppressed, pressure-drop rejection remains empty, and generated Rust runs through Cargo `check`, `test`, and binary execution without credentials, provider/model traffic, state DB mutation, or Cafex behavior. This is deterministic recovery idle-state handoff evidence only, not live JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, terminal ownership, ratatui input/layout ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-148 Resume Picker App-Server Typed Response Recovery Keyboard Readiness

Status: HXCX-TUI-148 adds `RecoveryKeyboardReadinessPolicy`, `RecoveryKeyboardDecision`, `RecoveryKeyboardDecisionKind`, `RecoveryKeyboardIntentKind`, `RecoveryKeyboardReadinessGate`, `RecoveryKeyboardReadinessReport`, `test/ResumePickerAppServerTypedResponseRecoveryKeyboardReadinessRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-keyboard-readiness-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-keyboard-readiness-render.sh`. The gate validates deterministic keyboard-readiness admission after recovery idle-state handoff: down/up navigation intents are admitted, the recovered `thread-surface-a` selection stays stable until navigation, navigation can return to the recovered selection, stale pending-interactive prompt, side-parent status, and active-thread status actions remain inactive, ignored no-surface paths remain absent, live transport stays suppressed, pressure-drop rejection remains empty, and generated Rust runs through Cargo `check`, `test`, and binary execution without credentials, provider/model traffic, state DB mutation, or Cafex behavior. This is deterministic recovery keyboard readiness evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-149 Resume Picker App-Server Typed Response Recovery Keyboard Render State

Status: HXCX-TUI-149 adds `RecoveryKeyboardRenderState`, `RecoveryKeyboardRenderStateKind`, `RecoveryKeyboardStateProjector`, `RecoveryKeyboardStateGate`, `RecoveryKeyboardStateReport`, `test/RecoveryKeyboardRenderStateRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-keyboard-render-state-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-keyboard-render-state-render.sh`. The gate projects admitted recovery keyboard decisions into deterministic normalized `ResumePickerState` snapshots: the selected row marker moves to `thread-surface-b`, returns to recovered `thread-surface-a`, frame/render counts match the two projected states, stale pending-interactive prompt, side-parent status, and active-thread status actions remain inactive, ignored no-surface paths remain absent, live transport and live terminal ownership stay suppressed, pressure-drop rejection remains empty, and generated Rust runs through Cargo `check`, `test`, and binary execution without credentials, provider/model traffic, state DB mutation, or Cafex behavior. This is deterministic recovery keyboard render-state evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-150 Resume Picker App-Server Typed Response Recovery Render Snapshot Replay

Status: HXCX-TUI-150 adds `RecoveryRenderSnapshotReplay`, `RecoveryRenderSnapshotReplayKind`, `RecoveryRenderSnapshotReplayer`, `RecoveryRenderSnapshotReplayGate`, `RecoveryRenderSnapshotReplayReport`, `test/RecoveryRenderSnapshotReplayRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-render-snapshot-replay-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-render-snapshot-replay-render.sh`. The gate replays deterministic recovery keyboard render-state snapshots into a typed snapshot history: down replay stays at index 0 with the `thread-surface-b` selected marker and footer, up replay stays at index 1 with the restored `thread-surface-a` selected marker and footer, stale pending-interactive prompt, side-parent status, and active-thread status actions remain inactive, ignored no-surface paths remain absent, live transport and live terminal ownership stay suppressed, pressure-drop rejection remains empty, and generated Rust runs through Cargo `check`, `test`, and binary execution without credentials, provider/model traffic, state DB mutation, or Cafex behavior. This is deterministic recovery render snapshot replay evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-151 Resume Picker App-Server Typed Response Recovery Replay Completion Handoff

Status: HXCX-TUI-151 adds `RecoveryReplayCompletionHandoff`, `RecoveryReplayCompletionHandoffKind`, `RecoveryCompletionHandoffPolicy`, `RecoveryCompletionHandoffGate`, `RecoveryCompletionHandoffReport`, `test/RecoveryReplayCompletionHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-replay-completion-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-replay-completion-handoff-render.sh`. The gate turns replayed recovery snapshot history into a deterministic completion handoff: final selection is restored to `thread-surface-a`, the final footer remains stable, replay count and ordering are preserved, stale pending-interactive prompt, side-parent status, and active-thread status actions remain inactive, ignored no-surface paths remain absent, live transport and live terminal ownership stay suppressed, pressure-drop rejection remains empty, state DB stays untouched, and the next raw upstream slice is marked ready; generated Rust runs through Cargo `check`, `test`, and binary execution without credentials, provider/model traffic, state DB mutation, or Cafex behavior. This is deterministic recovery replay completion handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, or Cafex behavior.

### HXCX-TUI-152 Resume Picker App-Server Typed Response Recovery Post-Completion Input Admission

Status: HXCX-TUI-152 adds `CompletionInputAdmission`, `CompletionInputAdmissionKind`, `CompletionInputIntentKind`, `CompletionInputAdmissionPolicy`, `CompletionInputAdmissionGate`, `CompletionInputAdmissionReport`, `test/CompletionInputAdmissionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-input-admission-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-input-admission-render.sh`. The gate admits the first deterministic post-completion `confirm_recovered_selection` input only after completed recovered-selection handoff, preserves final `thread-surface-a` selection and stable final footer, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic post-completion input-admission evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-153 Resume Picker App-Server Typed Response Recovery Post-Completion Input Render Intent

Status: HXCX-TUI-153 adds `CompletionInputRenderIntent`, `CompletionInputRenderIntentKind`, `CompletionInputRenderIntentPlanner`, `CompletionInputRenderIntentGate`, `CompletionInputRenderIntentReport`, `test/CompletionInputRenderIntentRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-input-render-intent-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-input-render-intent-render.sh`. The gate projects admitted post-completion `confirm_recovered_selection` input into deterministic local-only render intent, preserves final `thread-surface-a` selection and stable final footer, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic post-completion render-intent evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-154 Resume Picker App-Server Typed Response Recovery Post-Completion Render Request Scheduling

Status: HXCX-TUI-154 adds `CompletionRenderRequestSchedule`, `CompletionRenderRequestScheduleKind`, `CompletionRenderRequestScheduler`, `CompletionRenderRequestGate`, `CompletionRenderRequestReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestSchedulingRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-render-request-scheduling-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-render-request-scheduling-render.sh`. The gate schedules exactly one deterministic local-only frame request from the post-completion render intent, preserves final `thread-surface-a` selection and stable final footer, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic post-completion render-request scheduling evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-155 Resume Picker App-Server Typed Response Recovery Post-Completion Scheduled Render Execution

Status: HXCX-TUI-155 adds `CompletionScheduledRenderExecution`, `CompletionScheduledRenderExecutionKind`, `CompletionScheduledRenderExecutor`, `CompletionScheduledRenderGate`, `CompletionScheduledRenderReport`, `test/CompletionScheduledRenderExecutionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-scheduled-render-execution-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-scheduled-render-execution-render.sh`. The gate executes the scheduled local-only render request exactly once through the deterministic renderer, proves the rendered snapshot matches the scheduled recovered snapshot, consumes the single scheduled request, preserves final `thread-surface-a` selection and stable final footer, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic post-completion scheduled-render execution evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-156 Resume Picker App-Server Typed Response Recovery Post-Completion Rendered-State Handoff

Status: HXCX-TUI-156 adds `CompletionRenderedStateHandoff`, `CompletionRenderedStateHandoffKind`, `CompletionStateHandoffPolicy`, `CompletionStateHandoffGate`, `CompletionStateHandoffReport`, `test/CompletionRenderedStateHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-rendered-state-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-rendered-state-handoff-render.sh`. The gate hands the executed scheduled render snapshot back to an idle/list-ready state, proves there is no leftover scheduled render request for the slice, preserves final `thread-surface-a` selection and stable final footer, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic post-completion rendered-state handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-157 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Keyboard Readiness

Status: HXCX-TUI-157 adds `PostRenderKeyboardReadiness`, `PostRenderKeyboardReadinessKind`, `PostRenderKeyboardReadinessPolicy`, `PostRenderKeyboardReadinessGate`, `PostRenderKeyboardReadinessReport`, `test/PostRenderKeyboardReadinessRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-keyboard-readiness-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-keyboard-readiness-render.sh`. The gate admits deterministic down/up keyboard navigation only after the rendered-state handoff is idle/list-ready, proves the recovered `thread-surface-a` selection is stable until navigation and restored after navigation, preserves the final footer, carries forward the no-leftover scheduled render request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic post-render keyboard-readiness evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-158 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Keyboard Render-State

Status: HXCX-TUI-158 adds `PostRenderKeyboardStateGate`, `PostRenderKeyboardStateReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderKeyboardRenderStateRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-keyboard-render-state-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-keyboard-render-state-render.sh`. The gate projects admitted down/up keyboard navigation after the rendered-state handoff into deterministic render-state summaries, proves the selected marker moves to `thread-surface-b` and restores to `thread-surface-a`, preserves the final footer and recovered selection, carries forward the no-leftover scheduled render request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic post-render keyboard render-state evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

During this slice, generated portable Rust exposed a generic non-Copy `HxString` reuse pressure point when a rejected-branch ternary fallback reused a previously moved local and then borrowed it for a preservation check. The local Haxe source avoids relying on Codex-specific compiler behavior; the follow-up belongs in haxe.rust as product-neutral lowering work.

### HXCX-TUI-159 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Keyboard Render Snapshot Replay

Status: HXCX-TUI-159 adds `PostRenderSnapshotReplayer`, `PostRenderSnapshotReplayGate`, `PostRenderSnapshotReplayReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderKeyboardRenderSnapshotReplayRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-keyboard-render-snapshot-replay-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-keyboard-render-snapshot-replay-render.sh`. The gate replays deterministic down/up keyboard snapshots after the rendered-state handoff, proves source-order preservation, selected marker preservation, footer summary preservation, selected marker movement to `thread-surface-b`, restored final selection to `thread-surface-a`, final footer preservation, no leftover scheduled render request, stale pending-interactive prompt, side-parent status, and active-thread status inactivity, ignored no-surface absence, live transport and live terminal suppression, no pressure-drop rejection, no state DB mutation, no model call, no filesystem mutation, no credentials, no provider/model traffic, and no Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic post-render snapshot replay evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-160 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay Completion Handoff

Status: HXCX-TUI-160 adds `PostRenderCompletionHandoffPolicy`, `PostRenderCompletionHandoffGate`, `PostRenderCompletionHandoffReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayCompletionHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-completion-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-completion-handoff-render.sh`. The gate hands ordered post-render keyboard snapshot replay history to the next deterministic TUI state, proves replay completion with restored final selection on `thread-surface-a`, stable final footer, replay count/order/selected-marker/footer evidence retention, no leftover scheduled render request, stale pending-interactive prompt, side-parent status, and active-thread status inactivity, ignored no-surface absence, live transport and live terminal suppression, no pressure-drop rejection, no state DB mutation, no model call, no filesystem mutation, no credentials, no provider/model traffic, and no Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic post-render replay completion handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-161 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Input Admission

Status: HXCX-TUI-161 adds `PostRenderInputAdmissionPolicy`, `PostRenderInputAdmissionGate`, `PostRenderInputAdmissionReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderInputAdmissionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-input-admission-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-input-admission-render.sh`. The gate admits the deterministic `confirm_recovered_selection` input only after post-render replay completion handoff readiness, preserves final `thread-surface-a` selection and stable footer, carries replay count/order/selected-marker/footer evidence, keeps no leftover scheduled render request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic post-render input-admission evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-162 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Input Render Intent

Status: HXCX-TUI-162 adds `PostRenderInputRenderIntentPlanner`, `PostRenderInputRenderIntentGate`, `PostRenderInputRenderIntentReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderInputRenderIntentRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-input-render-intent-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-input-render-intent-render.sh`. The gate projects admitted `confirm_recovered_selection` input after post-render replay completion into deterministic local-only render intent, preserves final `thread-surface-a` selection and stable footer, carries replay count/order/selected-marker/footer evidence, keeps no leftover scheduled render request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic post-render input render-intent evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-163 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Render Request Scheduling

Status: HXCX-TUI-163 adds `PostRenderRenderRequestScheduler`, `PostRenderRenderRequestGate`, `PostRenderRenderRequestReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderRenderRequestSchedulingRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-render-request-scheduling-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-render-request-scheduling-render.sh`. The gate schedules the post-render local-only render intent into exactly one deterministic frame request, preserves final `thread-surface-a` selection and stable footer, carries replay count/order/selected-marker/footer evidence, keeps the previously consumed scheduled render request evidence distinct from the new local request, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic post-render render-request scheduling evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-164 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Scheduled Render Execution

Status: HXCX-TUI-164 adds `PostRenderScheduledRenderExecutor`, `PostRenderScheduledRenderGate`, `PostRenderScheduledRenderReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderScheduledRenderExecutionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-scheduled-render-execution-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-scheduled-render-execution-render.sh`. The gate executes the scheduled post-render local-only render request exactly once through the deterministic renderer, proves the rendered snapshot matches the scheduled recovered snapshot, consumes the single scheduled request, preserves final `thread-surface-a` selection and stable footer, carries replay count/order/selected-marker/footer evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic post-render scheduled-render execution evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-165 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Rendered-State Handoff

Status: HXCX-TUI-165 adds `PostRenderRenderedStateHandoff`, `PostRenderStateHandoffPolicy`, `PostRenderStateHandoffGate`, `PostRenderStateHandoffReport`, `test/PostRenderRenderedStateHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-rendered-state-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-rendered-state-handoff-render.sh`. The gate hands the executed post-render scheduled snapshot back to idle/list readiness, proves the scheduled request is fully consumed, preserves final `thread-surface-a` selection and stable footer, carries replay count/order/selected-marker/footer evidence plus pre-execution render evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic post-render rendered-state handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-166 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Keyboard Readiness

Status: HXCX-TUI-166 adds `RecoveryReplayAwareKeyboardReadiness`, `ReplayAwareKeyboardReadinessPolicy`, `ReplayAwareKeyboardReadinessGate`, `ReplayAwareKeyboardReadinessReport`, `test/RecoveryReplayAwareKeyboardReadinessRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-keyboard-readiness-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-keyboard-readiness-render.sh`. The gate admits deterministic down/up keyboard navigation only after the replay-aware rendered-state handoff is idle/list-ready, proves recovered `thread-surface-a` selection and stable footer are preserved until navigation, proves navigation returns to recovered selection, carries replay count/order/selected-marker/footer evidence plus pre-execution render evidence, keeps the scheduled request fully consumed, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic post-render keyboard-readiness evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-167 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Keyboard Render-State

Status: HXCX-TUI-167 adds `ReplayAwareKeyboardStateGate`, `ReplayAwareKeyboardStateReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareKeyboardRenderStateRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-keyboard-render-state-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-keyboard-render-state-render.sh`. The gate projects admitted replay-aware down/up keyboard navigation into deterministic render-state summaries, proves selected marker movement to `thread-surface-b` and restoration to `thread-surface-a`, preserves final footer, carries replay count/order/selected-marker/footer evidence plus pre-execution render evidence, keeps the scheduled request fully consumed, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic post-render keyboard render-state evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-168 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Keyboard Render-Snapshot Replay

Status: HXCX-TUI-168 adds `ReplayAwareSnapshotReplayGate`, `ReplayAwareSnapshotReplayReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareKeyboardRenderSnapshotReplayRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-keyboard-render-snapshot-replay-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-keyboard-render-snapshot-replay-render.sh`. The gate replays the HXCX-TUI-167 down/up keyboard render snapshots in source order, proves selected marker movement to `thread-surface-b` and restoration to `thread-surface-a`, preserves final footer and selected-thread evidence, carries replay count/order/selected-marker/footer evidence plus pre-execution render evidence, keeps the scheduled request fully consumed, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic post-render keyboard snapshot replay evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-169 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Replay Completion Handoff

Status: HXCX-TUI-169 adds `ReplayAwareCompletionHandoffPolicy`, `ReplayAwareCompletionHandoffGate`, `ReplayAwareCompletionHandoffReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareReplayCompletionHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-replay-completion-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-replay-completion-handoff-render.sh`. The gate hands replay-aware keyboard render-snapshot replay into deterministic completion state, proves restored final selection/footer, preserves source readiness/render-state/snapshot replay counts, carries ordered selected-marker/footer evidence and pre-execution render evidence, keeps the scheduled request fully consumed, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware completion handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-170 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Input Admission

Status: HXCX-TUI-170 adds `ReplayAwareInputAdmissionPolicy`, `ReplayAwareInputAdmissionGate`, `ReplayAwareInputAdmissionReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareInputAdmissionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-input-admission-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-input-admission-render.sh`. The gate admits the next deterministic recovered-selection confirmation only after replay-aware completion handoff, proves restored final selection/footer, preserves source readiness/render-state/snapshot replay counts, carries ordered selected-marker/footer evidence and pre-execution render evidence, keeps the scheduled request fully consumed, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware post-completion input-admission evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-171 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Input Render-Intent

Status: HXCX-TUI-171 adds `ReplayAwareInputRenderIntentPlanner`, `ReplayAwareInputRenderIntentGate`, `ReplayAwareInputRenderIntentReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareInputRenderIntentRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-input-render-intent-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-input-render-intent-render.sh`. The gate projects replay-aware admitted recovered-selection input into deterministic local-only render intent, proves restored final selection/footer, preserves source readiness/render-state/snapshot replay counts, carries ordered selected-marker/footer evidence and pre-execution render evidence, keeps the scheduled request fully consumed, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware post-completion input render-intent evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-172 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Render Request Scheduling

Status: HXCX-TUI-172 adds `ReplayAwareRenderRequestScheduler`, `ReplayAwareRenderRequestGate`, `ReplayAwareRenderRequestReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderRequestSchedulingRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-render-request-scheduling-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-render-request-scheduling-render.sh`. The gate schedules exactly one deterministic frame request from replay-aware local-only render intent, proves restored final selection/footer, preserves source readiness/render-state/snapshot replay counts, carries ordered selected-marker/footer evidence and pre-execution render evidence, keeps prior scheduled request evidence consumed, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware render-request scheduling evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-173 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Scheduled Render Execution

Status: HXCX-TUI-173 adds `ReplayAwareScheduledRenderExecutor`, `ReplayAwareScheduledRenderGate`, `ReplayAwareScheduledRenderReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareScheduledRenderExecutionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-scheduled-render-execution-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-scheduled-render-execution-render.sh`. The gate executes exactly one deterministic scheduled render request from replay-aware local-only scheduling, proves the rendered snapshot matches the scheduled recovered snapshot, consumes the scheduled request, preserves restored final selection/footer, source readiness/render-state/snapshot replay counts, ordered selected-marker/footer evidence, and pre-execution render evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware scheduled-render execution evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-174 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Handoff

Status: HXCX-TUI-174 adds `ReplayStateHandoffPolicy`, `ReplayStateHandoffGate`, `ReplayStateHandoffReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-handoff-render.sh`. The gate hands the executed replay-aware scheduled render snapshot back to deterministic idle/list readiness, proves the scheduled request is fully consumed, preserves restored final selection/footer, source readiness/render-state/snapshot replay counts, ordered selected-marker/footer evidence, and pre-execution render evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-175 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Keyboard Readiness

Status: HXCX-TUI-175 adds `ReplayStateKeyboardReadinessPolicy`, `ReplayStateKeyboardReadinessGate`, `ReplayStateKeyboardReadinessReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateKeyboardReadinessRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-keyboard-readiness-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-keyboard-readiness-render.sh`. The gate admits deterministic down/up keyboard navigation only after the replay-aware rendered-state handoff is idle/list-ready, proves the recovered `thread-surface-a` selection is stable until navigation and restored after navigation, preserves restored final selection/footer, source readiness/render-state/snapshot replay counts, ordered selected-marker/footer evidence, pre-execution render evidence, and fully consumed scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state keyboard-readiness evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-176 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Keyboard Render-State

Status: HXCX-TUI-176 adds `ReplayStateKeyboardStateGate`, `ReplayStateKeyboardStateReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateKeyboardRenderStateRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-keyboard-render-state-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-keyboard-render-state-render.sh`. The gate projects admitted down/up navigation from the replay-aware rendered-state keyboard readiness gate into deterministic render-state summaries, proves selected marker movement to `thread-surface-b` and restoration to `thread-surface-a`, preserves restored final selection/footer, source readiness/render-state/snapshot replay counts, source input/render-intent evidence, pre-execution render evidence, and fully consumed scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state keyboard render-state evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-177 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Keyboard Render-Snapshot Replay

Status: HXCX-TUI-177 adds `ReplayStateSnapshotReplayGate`, `ReplayStateSnapshotReplayReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateKeyboardRenderSnapshotReplayRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-keyboard-render-snapshot-replay-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-keyboard-render-snapshot-replay-render.sh`. The gate replays deterministic down/up snapshots from the replay-aware rendered-state keyboard render-state gate, proves selected marker/footer preservation for `thread-surface-b` and restored `thread-surface-a`, preserves restored final selection/footer, source readiness/render-state/snapshot replay counts, source input/render-intent evidence, pre-execution render evidence, and fully consumed scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state keyboard render-snapshot replay evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-178 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Replay-Completion Handoff

Status: HXCX-TUI-178 adds `ReplayStateCompletionHandoffPolicy`, `ReplayStateCompletionHandoffGate`, `ReplayStateCompletionHandoffReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateReplayCompletionHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-replay-completion-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-replay-completion-handoff-render.sh`. The gate hands replay-aware rendered-state keyboard snapshot replay into deterministic completed-selection readiness, proves restored final selection/footer, preserves source readiness/render-state/snapshot replay counts, source input/render-intent evidence, pre-execution render evidence, and fully consumed scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state completion-handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-179 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Input Admission

Status: HXCX-TUI-179 adds `ReplayStateInputAdmissionPolicy`, `ReplayStateInputAdmissionGate`, `ReplayStateInputAdmissionReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateInputAdmissionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-input-admission-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-input-admission-render.sh`. The gate admits deterministic recovered-selection input only after replay-aware rendered-state completion handoff, proves restored final selection/footer, preserves source readiness/render-state/snapshot replay counts, source input/render-intent evidence, pre-execution render evidence, and fully consumed scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state input-admission evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-180 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Input Render-Intent

Status: HXCX-TUI-180 adds `ReplayStateInputRenderIntentPlanner`, `ReplayStateInputRenderIntentGate`, `ReplayStateInputRenderIntentReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateInputRenderIntentRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-input-render-intent-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-input-render-intent-render.sh`. The gate projects admitted recovered-selection input from the replay-aware rendered-state input-admission gate into deterministic local-only render intent, proves restored final selection/footer, preserves source readiness/render-state/snapshot replay counts, source input/render-intent and source handoff evidence, pre-execution render evidence, and fully consumed scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state input render-intent evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-181 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Render Request Scheduling

Status: HXCX-TUI-181 adds `ReplayStateRenderRequestScheduler`, `ReplayStateRenderRequestGate`, `ReplayStateRenderRequestReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateRenderRequestSchedulingRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-render-request-scheduling-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-render-request-scheduling-render.sh`. The gate schedules exactly one deterministic local-only frame request from the replay-aware rendered-state input render-intent gate, proves restored final selection/footer, preserves source readiness/render-state/snapshot replay counts, source input/render-intent and source handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state render-request scheduling evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-182 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Scheduled Render Execution

Status: HXCX-TUI-182 adds `ReplayStateScheduledRenderExecutor`, `ReplayStateScheduledRenderGate`, `ReplayStateScheduledRenderReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateScheduledRenderExecutionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-scheduled-render-execution-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-scheduled-render-execution-render.sh`. The gate executes the scheduled local-only frame request from the replay-aware rendered-state render-request scheduling gate, proves the rendered snapshot matches the scheduled recovered-selection frame, proves restored final selection/footer, preserves source readiness/render-state/snapshot replay counts, source input/render-intent and source handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state scheduled render execution evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-183 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Scheduled Execution Handoff

Status: HXCX-TUI-183 adds `ReplayStateExecutionHandoffPolicy`, `ReplayStateExecutionHandoffGate`, `ReplayStateExecutionHandoffReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateScheduledExecutionHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-scheduled-execution-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-scheduled-execution-handoff-render.sh`. The gate hands the executed rendered-state scheduled render snapshot back into deterministic idle/list readiness for the next input/render cycle, proves the executed recovered-selection snapshot is preserved, proves restored final selection/footer, preserves source readiness/render-state/snapshot replay counts, source input/render-intent and source handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state scheduled-execution handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-184 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Second-Cycle Keyboard Readiness

Status: HXCX-TUI-184 adds `SecondKeyboardReadinessPolicy`, `SecondKeyboardReadinessGate`, `SecondKeyboardReadinessReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSecondCycleKeyboardReadinessRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-keyboard-readiness-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-keyboard-readiness-render.sh`. The gate admits deterministic down/up keyboard readiness from the rendered-state scheduled-execution handoff gate for the next input/render cycle, proves the executed recovered-selection snapshot remains preserved, proves restored final selection/footer, preserves source readiness/render-state/snapshot replay counts, source input/render-intent and source handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state second-cycle keyboard readiness evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-185 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Second-Cycle Keyboard Render-State

Status: HXCX-TUI-185 adds `SecondKeyboardStateGate`, `SecondKeyboardStateReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSecondCycleKeyboardRenderStateRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-keyboard-render-state-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-keyboard-render-state-render.sh`. The gate projects admitted second-cycle down/up keyboard navigation from the rendered-state second-cycle keyboard readiness gate into deterministic render-state summaries, proves selected marker movement to `thread-surface-b` and restoration to `thread-surface-a`, preserves the executed recovered-selection snapshot, final selection/footer, source readiness/render-state/snapshot replay counts, source input/render-intent and source handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state second-cycle keyboard render-state evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-186 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Second-Cycle Keyboard Render-Snapshot Replay

Status: HXCX-TUI-186 adds `SecondSnapshotReplayGate`, `SecondSnapshotReplayReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSecondCycleKeyboardRenderSnapshotReplayRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-keyboard-render-snapshot-replay-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-keyboard-render-snapshot-replay-render.sh`. The gate replays deterministic down/up snapshots from the rendered-state second-cycle keyboard render-state gate, proves selected marker/footer preservation for `thread-surface-b` and restored `thread-surface-a`, preserves the executed recovered-selection snapshot, final selection/footer, source readiness/render-state/snapshot replay counts, source input/render-intent and source handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state second-cycle keyboard render-snapshot replay evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-187 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Second-Cycle Replay-Completion Handoff

Status: HXCX-TUI-187 adds `SecondCompletionHandoffPolicy`, `SecondCompletionHandoffGate`, `SecondCompletionHandoffReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSecondCycleReplayCompletionHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-replay-completion-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-replay-completion-handoff-render.sh`. The gate hands second-cycle rendered-state keyboard snapshot replay into deterministic completed-selection readiness, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and source handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state second-cycle completion-handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-188 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Second-Cycle Input Admission

Status: HXCX-TUI-188 adds `SecondInputAdmissionPolicy`, `SecondInputAdmissionGate`, `SecondInputAdmissionReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSecondCycleInputAdmissionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-input-admission-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-input-admission-render.sh`. The gate admits deterministic recovered-selection input after the rendered-state second-cycle replay-completion handoff, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and source handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state second-cycle input-admission evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-189 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Second-Cycle Input Render-Intent

Status: HXCX-TUI-189 adds `SecondInputRenderIntentPlanner`, `SecondInputRenderIntentGate`, `SecondInputRenderIntentReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSecondCycleInputRenderIntentRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-input-render-intent-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-input-render-intent-render.sh`. The gate projects admitted second-cycle recovered-selection input into deterministic local-only render intent, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and source handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state second-cycle input render-intent evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-190 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Second-Cycle Render Request Scheduling

Status: HXCX-TUI-190 adds `SecondRenderRequestScheduler`, `SecondRenderRequestGate`, `SecondRenderRequestReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSecondCycleRenderRequestSchedulingRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-render-request-scheduling-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-render-request-scheduling-render.sh`. The gate schedules exactly one deterministic local-only frame request from the rendered-state second-cycle input render-intent gate, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and source handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state second-cycle render-request scheduling evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-191 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Second-Cycle Scheduled Render Execution

Status: HXCX-TUI-191 adds `SecondScheduledRenderExecutor`, `SecondScheduledRenderGate`, `SecondScheduledRenderReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSecondCycleScheduledRenderExecutionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-scheduled-render-execution-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-scheduled-render-execution-render.sh`. The gate executes the scheduled local-only frame request from the rendered-state second-cycle render request scheduling gate, proves the rendered snapshot matches the scheduled recovered-selection frame, proves restored final selection/footer, preserves source readiness/render-state/snapshot replay counts, source input/render-intent and source handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state second-cycle scheduled render execution evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-192 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Second-Cycle Scheduled Execution Handoff

Status: HXCX-TUI-192 adds `SecondExecutionHandoffPolicy`, `SecondExecutionHandoffGate`, `SecondExecutionHandoffReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSecondCycleScheduledExecutionHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-scheduled-execution-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-second-cycle-scheduled-execution-handoff-render.sh`. The gate hands the executed second-cycle scheduled render snapshot back into deterministic idle/list readiness for the next input/render cycle, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and source handoff evidence, second-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state second-cycle scheduled execution handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-193 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Third-Cycle Keyboard Readiness

Status: HXCX-TUI-193 adds `ThirdKeyboardReadinessPolicy`, `ThirdKeyboardReadinessGate`, `ThirdKeyboardReadinessReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateThirdCycleKeyboardReadinessRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-third-cycle-keyboard-readiness-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-third-cycle-keyboard-readiness-render.sh`. The gate admits deterministic down/up navigation from the second-cycle scheduled-execution handoff gate, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent evidence, first/second-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state third-cycle keyboard readiness evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-194 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Third-Cycle Keyboard Render-State

Status: HXCX-TUI-194 adds `ThirdKeyboardStateGate`, `ThirdKeyboardStateReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateThirdCycleKeyboardRenderStateRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-third-cycle-keyboard-render-state-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-third-cycle-keyboard-render-state-render.sh`. The gate projects deterministic down/up navigation into third-cycle render-state summaries from the third-cycle keyboard readiness gate, proves selected marker movement and recovered selection restoration, preserves restored final selection/footer, executed recovered-selection snapshot evidence, source readiness/render-state/snapshot replay counts, source input/render-intent evidence, first/second-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state third-cycle keyboard render-state evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-195 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Third-Cycle Keyboard Render-Snapshot Replay

Status: HXCX-TUI-195 adds `ThirdSnapshotReplayGate`, `ThirdSnapshotReplayReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateThirdCycleKeyboardRenderSnapshotReplayRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-third-cycle-keyboard-render-snapshot-replay-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-third-cycle-keyboard-render-snapshot-replay-render.sh`. The gate replays ordered down/up snapshots from the third-cycle keyboard render-state gate, proves selected marker/footer preservation and recovered selection restoration, preserves restored final selection/footer, executed recovered-selection snapshot evidence, source readiness/render-state/snapshot replay counts, source input/render-intent evidence, first/second-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state third-cycle keyboard render-snapshot replay evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-196 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Third-Cycle Replay-Completion Handoff

Status: HXCX-TUI-196 adds `ThirdCompletionHandoffPolicy`, `ThirdCompletionHandoffGate`, `ThirdCompletionHandoffReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateThirdCycleReplayCompletionHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-third-cycle-replay-completion-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-third-cycle-replay-completion-handoff-render.sh`. The gate hands third-cycle rendered-state keyboard snapshot replay into deterministic completed-selection readiness, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent evidence, first/second-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state third-cycle completion-handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-197 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Third-Cycle Input Admission

Status: HXCX-TUI-197 adds `ThirdInputAdmissionPolicy`, `ThirdInputAdmissionGate`, `ThirdInputAdmissionReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateThirdCycleInputAdmissionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-third-cycle-input-admission-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-third-cycle-input-admission-render.sh`. The gate admits deterministic recovered-selection confirmation input after third-cycle completion handoff, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent evidence, first/second-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state third-cycle input-admission evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-198 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Third-Cycle Input Render-Intent

Status: HXCX-TUI-198 adds `ThirdInputRenderIntentPlanner`, `ThirdInputRenderIntentGate`, `ThirdInputRenderIntentReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateThirdCycleInputRenderIntentRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-third-cycle-input-render-intent-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-third-cycle-input-render-intent-render.sh`. The gate projects admitted third-cycle recovered-selection input into deterministic local-only render intent, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent evidence, first/second-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state third-cycle input render-intent evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-199 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Third-Cycle Render Request Scheduling

Status: HXCX-TUI-199 adds `ThirdRenderRequestScheduler`, `ThirdRenderRequestGate`, `ThirdRenderRequestReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateThirdCycleRenderRequestSchedulingRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-third-cycle-render-request-scheduling-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-third-cycle-render-request-scheduling-render.sh`. The gate schedules exactly one deterministic local-only frame request from the third-cycle input render-intent gate, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent evidence, first/second-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state third-cycle render-request scheduling evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-200 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Third-Cycle Scheduled Render Execution

Status: HXCX-TUI-200 adds `ThirdScheduledRenderExecutor`, `ThirdScheduledRenderGate`, `ThirdScheduledRenderReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateThirdCycleScheduledRenderExecutionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-third-cycle-scheduled-render-execution-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-third-cycle-scheduled-render-execution-render.sh`. The gate executes the scheduled third-cycle local-only frame request, proves the rendered recovered-selection snapshot matches the scheduled frame, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent evidence, first/second-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state third-cycle scheduled render execution evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-201 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Third-Cycle Scheduled Execution Handoff

Status: HXCX-TUI-201 adds `ThirdExecutionHandoffPolicy`, `ThirdExecutionHandoffGate`, `ThirdExecutionHandoffReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateThirdCycleScheduledExecutionHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-third-cycle-scheduled-execution-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-third-cycle-scheduled-execution-handoff-render.sh`. The gate hands the executed third-cycle scheduled render snapshot back into deterministic idle/list readiness for the next input/render cycle, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state third-cycle scheduled execution handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-202 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Fourth-Cycle Keyboard Readiness

Status: HXCX-TUI-202 adds `FourthKeyboardReadinessPolicy`, `FourthKeyboardReadinessGate`, `FourthKeyboardReadinessReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFourthCycleKeyboardReadinessRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fourth-cycle-keyboard-readiness-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fourth-cycle-keyboard-readiness-render.sh`. The gate admits the next deterministic keyboard readiness cycle from the third-cycle scheduled execution handoff, proves idle/list readiness for recovered-selection keyboard navigation, preserves restored final selection/footer, the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state fourth-cycle keyboard readiness evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-203 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Fourth-Cycle Keyboard Render-State

Status: HXCX-TUI-203 adds `FourthKeyboardStateGate`, `FourthKeyboardStateReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFourthCycleKeyboardRenderStateRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fourth-cycle-keyboard-render-state-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fourth-cycle-keyboard-render-state-render.sh`. The gate projects deterministic down/up navigation into fourth-cycle render-state summaries from the fourth-cycle keyboard readiness gate, proves selected marker movement and recovered selection restoration, preserves restored final selection/footer, executed recovered-selection snapshot evidence, source readiness/render-state/snapshot replay counts, source input/render-intent evidence, first/second/third-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state fourth-cycle keyboard render-state evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-204 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Fourth-Cycle Keyboard Render-Snapshot Replay

Status: HXCX-TUI-204 adds `FourthSnapshotReplayGate`, `FourthSnapshotReplayReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFourthCycleKeyboardRenderSnapshotReplayRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fourth-cycle-keyboard-render-snapshot-replay-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fourth-cycle-keyboard-render-snapshot-replay-render.sh`. The gate replays ordered down/up snapshots from the fourth-cycle keyboard render-state gate, proves selected marker/footer preservation and recovered selection restoration, preserves restored final selection/footer, executed recovered-selection snapshot evidence, source readiness/render-state/snapshot replay counts, source input/render-intent evidence, first/second/third-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state fourth-cycle keyboard render-snapshot replay evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-205 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Fourth-Cycle Replay-Completion Handoff

Status: HXCX-TUI-205 adds `FourthCompletionHandoffPolicy`, `FourthCompletionHandoffGate`, `FourthCompletionHandoffReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFourthCycleReplayCompletionHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fourth-cycle-replay-completion-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fourth-cycle-replay-completion-handoff-render.sh`. The gate hands completed fourth-cycle snapshot replay back to deterministic recovered-selection completion readiness, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state fourth-cycle replay-completion handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-206 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Fourth-Cycle Input Admission

Status: HXCX-TUI-206 adds `FourthInputAdmissionPolicy`, `FourthInputAdmissionGate`, `FourthInputAdmissionReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFourthCycleInputAdmissionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fourth-cycle-input-admission-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fourth-cycle-input-admission-render.sh`. The gate admits recovered-selection confirmation input after the fourth-cycle replay-completion handoff, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state fourth-cycle input admission evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-207 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Fourth-Cycle Input Render-Intent

Status: HXCX-TUI-207 adds `FourthInputRenderIntentPlanner`, `FourthInputRenderIntentGate`, `FourthInputRenderIntentReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFourthCycleInputRenderIntentRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fourth-cycle-input-render-intent-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fourth-cycle-input-render-intent-render.sh`. The gate projects admitted fourth-cycle recovered-selection input into deterministic local-only render intent, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state fourth-cycle input render-intent evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-208 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Fourth-Cycle Render Request Scheduling

Status: HXCX-TUI-208 adds `FourthRenderRequestScheduler`, `FourthRenderRequestGate`, `FourthRenderRequestReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFourthCycleRenderRequestSchedulingRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fourth-cycle-render-request-scheduling-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fourth-cycle-render-request-scheduling-render.sh`. The gate schedules exactly one deterministic local-only frame request from the fourth-cycle input render-intent gate, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state fourth-cycle render-request scheduling evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-209 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Fourth-Cycle Scheduled Render Execution

Status: HXCX-TUI-209 adds `FourthScheduledRenderExecutor`, `FourthScheduledRenderGate`, `FourthScheduledRenderReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFourthCycleScheduledRenderExecutionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fourth-cycle-scheduled-render-execution-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fourth-cycle-scheduled-render-execution-render.sh`. The gate executes the scheduled fourth-cycle local-only frame request, proves the rendered recovered-selection snapshot matches the scheduled frame, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state fourth-cycle scheduled render execution evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-210 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Fourth-Cycle Scheduled Execution Handoff

Status: HXCX-TUI-210 adds `FourthExecutionHandoffPolicy`, `FourthExecutionHandoffGate`, `FourthExecutionHandoffReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFourthCycleScheduledExecutionHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fourth-cycle-scheduled-execution-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fourth-cycle-scheduled-execution-handoff-render.sh`. The gate hands the executed fourth-cycle scheduled render snapshot back into deterministic idle/list readiness for the next input/render cycle, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state fourth-cycle scheduled execution handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-211 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Fifth-Cycle Keyboard Readiness

Status: HXCX-TUI-211 adds `FifthKeyboardReadinessPolicy`, `FifthKeyboardReadinessGate`, `FifthKeyboardReadinessReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFifthCycleKeyboardReadinessRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fifth-cycle-keyboard-readiness-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fifth-cycle-keyboard-readiness-render.sh`. The gate admits deterministic fifth-cycle keyboard readiness from the fourth-cycle scheduled execution handoff, proves recovered-selection keyboard navigation readiness, restored final selection/footer, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state fifth-cycle keyboard readiness evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-212 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Fifth-Cycle Keyboard Render-State

Status: HXCX-TUI-212 adds `FifthKeyboardStateGate`, `FifthKeyboardStateReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFifthCycleKeyboardRenderStateRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fifth-cycle-keyboard-render-state-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fifth-cycle-keyboard-render-state-render.sh`. The gate projects deterministic down/up fifth-cycle keyboard decisions into render-state summaries from fifth-cycle keyboard readiness, proves selected marker movement and recovered selection restoration, restored final selection/footer, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state fifth-cycle keyboard render-state evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-213 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Fifth-Cycle Keyboard Render-Snapshot Replay

Status: HXCX-TUI-213 adds `FifthSnapshotReplayGate`, `FifthSnapshotReplayReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFifthCycleKeyboardRenderSnapshotReplayRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fifth-cycle-keyboard-render-snapshot-replay-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fifth-cycle-keyboard-render-snapshot-replay-render.sh`. The gate replays ordered down/up fifth-cycle keyboard render snapshots from the fifth-cycle render-state gate, proves selected marker/footer preservation and recovered selection restoration, restored final selection/footer, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state fifth-cycle keyboard render-snapshot replay evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-214 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Fifth-Cycle Replay Completion Handoff

Status: HXCX-TUI-214 adds `FifthCompletionHandoffPolicy`, `FifthCompletionHandoffGate`, `FifthCompletionHandoffReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFifthCycleReplayCompletionHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fifth-cycle-replay-completion-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fifth-cycle-replay-completion-handoff-render.sh`. The gate hands completed fifth-cycle render-snapshot replay into deterministic completion readiness, proves completed recovered-selection readiness, restored final selection/footer, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state fifth-cycle replay completion handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-215 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Fifth-Cycle Input Admission

Status: HXCX-TUI-215 adds `FifthInputAdmissionPolicy`, `FifthInputAdmissionGate`, `FifthInputAdmissionReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFifthCycleInputAdmissionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fifth-cycle-input-admission-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fifth-cycle-input-admission-render.sh`. The gate admits recovered-selection confirmation input after the fifth-cycle replay-completion handoff, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state fifth-cycle input admission evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-216 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Fifth-Cycle Input Render-Intent

Status: HXCX-TUI-216 adds `FifthInputRenderIntentPlanner`, `FifthInputRenderIntentGate`, `FifthInputRenderIntentReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFifthCycleInputRenderIntentRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fifth-cycle-input-render-intent-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fifth-cycle-input-render-intent-render.sh`. The gate projects admitted recovered-selection confirmation into a deterministic local-only render intent after fifth-cycle input admission, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state fifth-cycle input render-intent evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-217 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Fifth-Cycle Render Request Scheduling

Status: HXCX-TUI-217 adds `FifthRenderRequestScheduler`, `FifthRenderRequestGate`, `FifthRenderRequestReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFifthCycleRenderRequestSchedulingRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fifth-cycle-render-request-scheduling-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fifth-cycle-render-request-scheduling-render.sh`. The gate schedules exactly one local-only frame request after fifth-cycle input render-intent, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state fifth-cycle render request scheduling evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-218 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Fifth-Cycle Scheduled Render Execution

Status: HXCX-TUI-218 adds `FifthScheduledRenderExecutor`, `FifthScheduledRenderGate`, `FifthScheduledRenderReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFifthCycleScheduledRenderExecutionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fifth-cycle-scheduled-render-execution-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fifth-cycle-scheduled-render-execution-render.sh`. The gate executes exactly one scheduled local-only frame request into a rendered recovered-selection snapshot after fifth-cycle render request scheduling, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state fifth-cycle scheduled render execution evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-219 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Fifth-Cycle Scheduled Execution Handoff

Status: HXCX-TUI-219 adds `FifthExecutionHandoffPolicy`, `FifthExecutionHandoffGate`, `FifthExecutionHandoffReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateFifthCycleScheduledExecutionHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fifth-cycle-scheduled-execution-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-fifth-cycle-scheduled-execution-handoff-render.sh`. The gate hands the executed fifth-cycle recovered-selection render snapshot into deterministic idle/list readiness for the next keyboard-readiness cycle, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state fifth-cycle scheduled execution handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-220 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Sixth-Cycle Keyboard Readiness

Status: HXCX-TUI-220 adds `SixthKeyboardReadinessPolicy`, `SixthKeyboardReadinessGate`, `SixthKeyboardReadinessReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSixthCycleKeyboardReadinessRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-sixth-cycle-keyboard-readiness-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-sixth-cycle-keyboard-readiness-render.sh`. The gate admits deterministic down/up sixth-cycle keyboard readiness from the fifth-cycle scheduled execution handoff, proves idle/list readiness, restored final selection/footer, executed recovered-selection snapshot preservation, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state sixth-cycle keyboard readiness evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-221 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Sixth-Cycle Keyboard Render-State

Status: HXCX-TUI-221 adds `SixthKeyboardStateGate`, `SixthKeyboardStateReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSixthCycleKeyboardRenderStateRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-sixth-cycle-keyboard-render-state-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-sixth-cycle-keyboard-render-state-render.sh`. The gate projects deterministic down/up sixth-cycle keyboard decisions into render-state summaries from sixth-cycle keyboard readiness, proves selected marker movement and recovered selection restoration, restored final selection/footer, executed recovered-selection snapshot preservation, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state sixth-cycle keyboard render-state evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-222 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Sixth-Cycle Keyboard Render-Snapshot Replay

Status: HXCX-TUI-222 adds `SixthSnapshotReplayGate`, `SixthSnapshotReplayReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSixthCycleKeyboardRenderSnapshotReplayRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-sixth-cycle-keyboard-render-snapshot-replay-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-sixth-cycle-keyboard-render-snapshot-replay-render.sh`. The gate replays ordered down/up snapshots from the sixth-cycle keyboard render-state gate, proves selected marker/footer preservation and recovered selection restoration, restored final selection/footer, executed recovered-selection snapshot preservation, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state sixth-cycle keyboard render-snapshot replay evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-223 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Sixth-Cycle Replay Completion Handoff

Status: HXCX-TUI-223 adds `SixthCompletionHandoffPolicy`, `SixthCompletionHandoffGate`, `SixthCompletionHandoffReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSixthCycleReplayCompletionHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-sixth-cycle-replay-completion-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-sixth-cycle-replay-completion-handoff-render.sh`. The gate hands completed sixth-cycle snapshot replay into deterministic recovered-selection completion readiness, proves selected marker/footer preservation and recovered selection restoration, restored final selection/footer, executed recovered-selection snapshot preservation, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state sixth-cycle replay-completion handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-224 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Sixth-Cycle Input Admission

Status: HXCX-TUI-224 adds `SixthInputAdmissionPolicy`, `SixthInputAdmissionGate`, `SixthInputAdmissionReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSixthCycleInputAdmissionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-sixth-cycle-input-admission-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-sixth-cycle-input-admission-render.sh`. The gate admits recovered-selection confirmation input after the sixth-cycle replay-completion handoff, proves restored final selection/footer, executed recovered-selection snapshot preservation, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state sixth-cycle input admission evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-225 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Sixth-Cycle Input Render-Intent

Status: HXCX-TUI-225 adds `SixthInputRenderIntentPlanner`, `SixthInputRenderIntentGate`, `SixthInputRenderIntentReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSixthCycleInputRenderIntentRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-sixth-cycle-input-render-intent-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-sixth-cycle-input-render-intent-render.sh`. The gate projects admitted recovered-selection confirmation into deterministic local-only render intent after the sixth-cycle input admission gate, proves restored final selection/footer, executed recovered-selection snapshot preservation, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state sixth-cycle input render-intent evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-226 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Sixth-Cycle Render Request Scheduling

Status: HXCX-TUI-226 adds `SixthRenderRequestScheduler`, `SixthRenderRequestGate`, `SixthRenderRequestReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSixthCycleRenderRequestSchedulingRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-sixth-cycle-render-request-scheduling-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-sixth-cycle-render-request-scheduling-render.sh`. The gate schedules exactly one local-only frame request after sixth-cycle input render-intent, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state sixth-cycle render request scheduling evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-227 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Sixth-Cycle Scheduled Render Execution

Status: HXCX-TUI-227 adds `SixthScheduledRenderExecutor`, `SixthScheduledRenderGate`, `SixthScheduledRenderReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSixthCycleScheduledRenderExecutionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-sixth-cycle-scheduled-render-execution-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-sixth-cycle-scheduled-render-execution-render.sh`. The gate executes exactly one scheduled local-only frame request into a rendered recovered-selection snapshot after sixth-cycle render request scheduling, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state sixth-cycle scheduled render execution evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-228 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Sixth-Cycle Scheduled Execution Handoff

Status: HXCX-TUI-228 adds `SixthExecutionHandoffPolicy`, `SixthExecutionHandoffGate`, `SixthExecutionHandoffReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSixthCycleScheduledExecutionHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-sixth-cycle-scheduled-execution-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-sixth-cycle-scheduled-execution-handoff-render.sh`. The gate hands the executed sixth-cycle recovered-selection render snapshot into deterministic idle/list readiness for the next keyboard-readiness cycle, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and fully consumed earlier scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. This is deterministic replay-aware rendered-state sixth-cycle scheduled execution handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-229 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Seventh-Cycle Keyboard Readiness

Status: HXCX-TUI-229 adds `SeventhKeyboardReadinessPolicy`, `SeventhKeyboardReadinessGate`, `SeventhKeyboardReadinessReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSeventhCycleKeyboardReadinessRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-seventh-cycle-keyboard-readiness-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-seventh-cycle-keyboard-readiness-render.sh`. The gate admits deterministic down/up seventh-cycle keyboard readiness from the sixth-cycle scheduled execution handoff, proves idle/list readiness, restored final selection/footer, executed recovered-selection snapshot preservation, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The seventh-cycle gate uses compact boundary diagnostics for the active readiness slice so deep replay chains do not repeatedly materialize the entire prior nested summary. This is deterministic replay-aware rendered-state seventh-cycle keyboard readiness evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-230 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Seventh-Cycle Keyboard Render-State

Status: HXCX-TUI-230 adds `SeventhKeyboardStateGate`, `SeventhKeyboardStateReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSeventhCycleKeyboardRenderStateRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-seventh-cycle-keyboard-render-state-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-seventh-cycle-keyboard-render-state-render.sh`. The gate projects deterministic down/up seventh-cycle keyboard decisions into render-state summaries from seventh-cycle keyboard readiness, proves selected marker movement and recovered selection restoration, restored final selection/footer, executed recovered-selection snapshot preservation, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The gate carries forward compact readiness diagnostics to keep deep replay-chain output bounded. This is deterministic replay-aware rendered-state seventh-cycle keyboard render-state evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-231 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Seventh-Cycle Keyboard Render-Snapshot Replay

Status: HXCX-TUI-231 adds `SeventhSnapshotReplayGate`, `SeventhSnapshotReplayReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSeventhCycleKeyboardRenderSnapshotReplayRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-seventh-cycle-keyboard-render-snapshot-replay-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-seventh-cycle-keyboard-render-snapshot-replay-render.sh`. The gate replays ordered down/up snapshots from the seventh-cycle keyboard render-state gate, proves selected marker/footer preservation and recovered selection restoration, restored final selection/footer, executed recovered-selection snapshot preservation, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The gate carries compact source diagnostics to keep deep replay-chain output bounded. This is deterministic replay-aware rendered-state seventh-cycle keyboard render-snapshot replay evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-232 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Seventh-Cycle Replay Completion Handoff

Status: HXCX-TUI-232 adds `SeventhCompletionHandoffPolicy`, `SeventhCompletionHandoffGate`, `SeventhCompletionHandoffReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSeventhCycleReplayCompletionHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-seventh-cycle-replay-completion-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-seventh-cycle-replay-completion-handoff-render.sh`. The gate hands completed seventh-cycle snapshot replay into deterministic recovered-selection completion readiness, proves selected marker/footer preservation and recovered selection restoration, restored final selection/footer, executed recovered-selection snapshot preservation, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The harness asserts bounded diagnostics for the deep replay chain. This is deterministic replay-aware rendered-state seventh-cycle completion-handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-233 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Seventh-Cycle Input Admission

Status: HXCX-TUI-233 adds `SeventhInputAdmissionPolicy`, `SeventhInputAdmissionGate`, `SeventhInputAdmissionReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSeventhCycleInputAdmissionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-seventh-cycle-input-admission-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-seventh-cycle-input-admission-render.sh`. The gate admits deterministic `confirm_recovered_selection` input after seventh-cycle replay completion handoff, proves restored final selection/footer, executed recovered-selection snapshot preservation, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The harness asserts bounded diagnostics for the deep replay chain. This is deterministic replay-aware rendered-state seventh-cycle input-admission evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-234 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Seventh-Cycle Input Render-Intent

Status: HXCX-TUI-234 adds `SeventhInputRenderIntentPlanner`, `SeventhInputRenderIntentGate`, `SeventhInputRenderIntentReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSeventhCycleInputRenderIntentRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-seventh-cycle-input-render-intent-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-seventh-cycle-input-render-intent-render.sh`. The gate projects admitted recovered-selection confirmation into deterministic local-only render intent after seventh-cycle input admission, proves restored final selection/footer, executed recovered-selection snapshot preservation, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The harness asserts bounded diagnostics for the deep replay chain. This is deterministic replay-aware rendered-state seventh-cycle input render-intent evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-235 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Seventh-Cycle Render Request Scheduling

Status: HXCX-TUI-235 adds `SeventhRenderRequestScheduler`, `SeventhRenderRequestGate`, `SeventhRenderRequestReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSeventhCycleRenderRequestSchedulingRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-seventh-cycle-render-request-scheduling-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-seventh-cycle-render-request-scheduling-render.sh`. The gate schedules exactly one local-only frame request after seventh-cycle input render-intent, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and consumed prior scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The harness asserts bounded diagnostics for the deep replay chain. This is deterministic replay-aware rendered-state seventh-cycle render request scheduling evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-236 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Seventh-Cycle Scheduled Render Execution

Status: HXCX-TUI-236 adds `SeventhScheduledRenderExecutor`, `SeventhScheduledRenderGate`, `SeventhScheduledRenderReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSeventhCycleScheduledRenderExecutionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-seventh-cycle-scheduled-render-execution-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-seventh-cycle-scheduled-render-execution-render.sh`. The gate executes exactly one scheduled local-only frame request into a rendered recovered-selection snapshot after seventh-cycle render request scheduling, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and consumed prior scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The harness asserts bounded diagnostics for the deep replay chain. This is deterministic replay-aware rendered-state seventh-cycle scheduled render execution evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-237 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Seventh-Cycle Scheduled Execution Handoff

Status: HXCX-TUI-237 adds `SeventhExecutionHandoffPolicy`, `SeventhExecutionHandoffGate`, `SeventhExecutionHandoffReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSeventhCycleScheduledExecutionHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-seventh-cycle-scheduled-execution-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-seventh-cycle-scheduled-execution-handoff-render.sh`. The gate hands the executed seventh-cycle recovered-selection render snapshot into deterministic idle/list readiness for the next keyboard-readiness cycle, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and consumed prior scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The harness asserts bounded diagnostics for the deep replay chain. This is deterministic replay-aware rendered-state seventh-cycle scheduled execution handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-238 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Eighth-Cycle Keyboard Readiness

Status: HXCX-TUI-238 adds `EighthKeyboardReadinessPolicy`, `EighthKeyboardReadinessGate`, `EighthKeyboardReadinessReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateEighthCycleKeyboardReadinessRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-eighth-cycle-keyboard-readiness-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-eighth-cycle-keyboard-readiness-render.sh`. The gate admits deterministic down/up eighth-cycle keyboard readiness from the seventh-cycle scheduled execution handoff, proves restored final selection/footer, preserves the executed recovered-selection snapshot, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and consumed prior scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The harness asserts bounded diagnostics for the deep replay chain. This is deterministic replay-aware rendered-state eighth-cycle keyboard readiness evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-239 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Eighth-Cycle Keyboard Render-State

Status: HXCX-TUI-239 adds `EighthKeyboardStateGate`, `EighthKeyboardStateReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateEighthCycleKeyboardRenderStateRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-eighth-cycle-keyboard-render-state-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-eighth-cycle-keyboard-render-state-render.sh`. The gate projects deterministic down/up eighth-cycle keyboard decisions into render-state summaries from eighth-cycle keyboard readiness, proves selected marker movement and recovered selection restoration, restored final selection/footer, executed recovered-selection snapshot preservation, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and consumed prior scheduled request evidence, keeps stale pending-interactive prompt, side-parent status, and active-thread status actions inactive, keeps ignored no-surface paths absent, suppresses live transport and live terminal ownership, avoids pressure-drop rejection, records no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The harness asserts bounded diagnostics for the deep replay chain. This is deterministic replay-aware rendered-state eighth-cycle keyboard render-state evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-240 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Eighth-Cycle Keyboard Render-Snapshot Replay

Status: HXCX-TUI-240 adds `EighthSnapshotReplayGate`, `EighthSnapshotReplayReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateEighthCycleKeyboardRenderSnapshotReplayRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-eighth-cycle-keyboard-render-snapshot-replay-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-eighth-cycle-keyboard-render-snapshot-replay-render.sh`. The gate replays ordered down/up snapshots from the eighth-cycle keyboard render-state gate, proves selected marker/footer preservation and recovered selection restoration, restored final selection/footer, executed recovered-selection snapshot preservation, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The harness asserts bounded diagnostics for the deep replay chain. This is deterministic replay-aware rendered-state eighth-cycle keyboard render-snapshot replay evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-241 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Eighth-Cycle Replay Completion Handoff

Status: HXCX-TUI-241 adds `EighthCompletionHandoffPolicy`, `EighthCompletionHandoffGate`, `EighthCompletionHandoffReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateEighthCycleReplayCompletionHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-eighth-cycle-replay-completion-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-eighth-cycle-replay-completion-handoff-render.sh`. The gate hands completed eighth-cycle snapshot replay into deterministic recovered-selection completion readiness, proves final footer stability and recovered selection restoration, restored final selection/footer, executed recovered-selection snapshot preservation, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The harness asserts bounded diagnostics for the deep replay chain. This is deterministic replay-aware rendered-state eighth-cycle completion-handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-242 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Eighth-Cycle Input Admission

Status: HXCX-TUI-242 adds `EighthInputAdmissionPolicy`, `EighthInputAdmissionGate`, `EighthInputAdmissionReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateEighthCycleInputAdmissionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-eighth-cycle-input-admission-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-eighth-cycle-input-admission-render.sh`. The gate admits recovered-selection confirmation after eighth-cycle replay completion handoff, proves restored final selection/footer, executed recovered-selection snapshot preservation, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The harness asserts bounded diagnostics for the deep replay chain. This is deterministic replay-aware rendered-state eighth-cycle input-admission evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-243 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Eighth-Cycle Input Render-Intent

Status: HXCX-TUI-243 adds `EighthInputRenderIntentPlanner`, `EighthInputRenderIntentGate`, `EighthInputRenderIntentReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateEighthCycleInputRenderIntentRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-eighth-cycle-input-render-intent-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-eighth-cycle-input-render-intent-render.sh`. The gate requests local-only render intent after eighth-cycle input admission, proves restored final selection/footer, executed recovered-selection snapshot preservation, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The harness asserts bounded diagnostics for the deep replay chain. This is deterministic replay-aware rendered-state eighth-cycle input render-intent evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-244 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Eighth-Cycle Render Request Scheduling

Status: HXCX-TUI-244 adds `EighthRenderRequestScheduler`, `EighthRenderRequestGate`, `EighthRenderRequestReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateEighthCycleRenderRequestSchedulingRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-eighth-cycle-render-request-scheduling-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-eighth-cycle-render-request-scheduling-render.sh`. The gate schedules exactly one local-only frame request after eighth-cycle input render-intent, proves restored final selection/footer, executed recovered-selection snapshot preservation, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The harness asserts bounded diagnostics for the deep replay chain. This is deterministic replay-aware rendered-state eighth-cycle render request scheduling evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-245 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Eighth-Cycle Scheduled Render Execution

Status: HXCX-TUI-245 adds `EighthScheduledRenderExecutor`, `EighthScheduledRenderGate`, `EighthScheduledRenderReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateEighthCycleScheduledRenderExecutionRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-eighth-cycle-scheduled-render-execution-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-eighth-cycle-scheduled-render-execution-render.sh`. The gate executes exactly one scheduled local-only frame request into a rendered recovered-selection snapshot after eighth-cycle render request scheduling, proves restored final selection/footer, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The harness asserts bounded diagnostics for the deep replay chain. This is deterministic replay-aware rendered-state eighth-cycle scheduled render execution evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-246 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Eighth-Cycle Scheduled Execution Handoff

Status: HXCX-TUI-246 adds `EighthExecutionHandoffPolicy`, `EighthExecutionHandoffGate`, `EighthExecutionHandoffReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateEighthCycleScheduledExecutionHandoffRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-eighth-cycle-scheduled-execution-handoff-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-eighth-cycle-scheduled-execution-handoff-render.sh`. The gate hands eighth-cycle scheduled render execution into deterministic idle/list readiness for the next keyboard-readiness slice, proves rendered recovered-selection snapshot preservation, restored final selection/footer, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The harness asserts bounded diagnostics for the deep replay chain. This is deterministic replay-aware rendered-state eighth-cycle scheduled execution handoff evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-247 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Ninth-Cycle Keyboard Readiness

Status: HXCX-TUI-247 adds `NinthKeyboardReadinessPolicy`, `NinthKeyboardReadinessGate`, `NinthKeyboardReadinessReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateNinthCycleKeyboardReadinessRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-ninth-cycle-keyboard-readiness-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-ninth-cycle-keyboard-readiness-render.sh`. The gate admits deterministic down/up ninth-cycle keyboard readiness from the eighth-cycle scheduled execution handoff, proves rendered recovered-selection snapshot preservation, restored final selection/footer, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and consumed prior scheduled request evidence, keeps stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The harness asserts bounded diagnostics for the deep replay chain. This is deterministic replay-aware rendered-state ninth-cycle keyboard readiness evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-248 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Ninth-Cycle Keyboard Render-State

Status: HXCX-TUI-248 adds `NinthKeyboardStateGate`, `NinthKeyboardStateReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateNinthCycleKeyboardRenderStateRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-ninth-cycle-keyboard-render-state-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-ninth-cycle-keyboard-render-state-render.sh`. The gate projects deterministic down/up ninth-cycle keyboard decisions into render-state summaries from ninth-cycle keyboard readiness, proves selected marker movement and recovered selection restoration, rendered recovered-selection snapshot preservation, restored final selection/footer, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, pre-execution render evidence, and consumed prior scheduled request evidence, keeps stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The harness asserts bounded diagnostics for the deep replay chain. This is deterministic replay-aware rendered-state ninth-cycle keyboard render-state evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-249 Resume Picker App-Server Typed Response Recovery Post-Completion Post-Render Replay-Aware Rendered-State Ninth-Cycle Keyboard Render-Snapshot Replay

Status: HXCX-TUI-249 adds `codexhx.validation.tui.resume.live.recovery.ninth.SnapshotReplayGate`, `codexhx.validation.tui.resume.live.recovery.ninth.SnapshotReplayReport`, `test/ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateNinthCycleKeyboardRenderSnapshotReplayRenderHarness.hx`, `hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-ninth-cycle-keyboard-render-snapshot-replay-render.hxml`, and `harness/check-resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-rendered-state-ninth-cycle-keyboard-render-snapshot-replay-render.sh`. The gate replays ordered down/up snapshots from the ninth-cycle keyboard render-state gate, proves selected marker/footer preservation and recovered selection restoration, rendered recovered-selection snapshot preservation, restored final selection/footer, source readiness/render-state/snapshot replay counts, source input/render-intent and first/second/third/fourth-cycle handoff evidence, consumed prior scheduled request evidence, stale actions inactive, ignored no-surface paths absent, live transport and live terminal suppression, no state DB mutation, model call, filesystem mutation, credentials, provider/model traffic, or Cafex behavior, and generated Rust runs through Cargo `check`, `test`, and binary execution. The harness asserts bounded diagnostics for the deep replay chain. This is deterministic replay-aware rendered-state ninth-cycle keyboard render-snapshot replay evidence only, not live crossterm input, ratatui rendering, JSON-RPC response sending, production replay delivery, approval/request-user-input UI ownership, live socket ownership, Tokio stream ownership, SQLite/state DB mutation, provider/model traffic, filesystem effects, or Cafex behavior.

### HXCX-TUI-250 Headless Raw Codex Desktop Thread Handoff History UI

Status: HXCX-TUI-250 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/app/history_ui.rs` desktop-thread handoff behavior. The fixture preserves the success history message `Opened this session in Codex Desktop.`, the failure message shape from `desktop_thread_open_error_message`, and the `codex://threads/<thread-id>` URL intent while rejecting live desktop/browser launch, app-server mutation, model traffic, filesystem mutation, terminal mutation, and Cafex behavior. This is deterministic history-message and launch-intent evidence only, not live OS desktop integration or browser/app process ownership.

### HXCX-TUI-251 Headless Raw Codex Browser URL History UI

Status: HXCX-TUI-251 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/app/history_ui.rs` generic browser URL handoff behavior. The fixture preserves `open_url_in_browser` success history text, failure history text, and URL intent while rejecting live browser launch, app-server mutation, model traffic, filesystem mutation, terminal mutation, and Cafex behavior. This is deterministic history-message and browser-launch intent evidence only, not live OS browser process ownership.

### HXCX-TUI-252 Headless Raw Codex Terminal Visualization Instructions

Status: HXCX-TUI-252 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/terminal_visualization_instructions.rs`. The fixture preserves feature-disabled passthrough, feature-enabled append to explicit control instructions, feature-enabled fallback to developer instructions, and feature-enabled generation from empty input using the upstream terminal ASCII-visual instruction text. This is deterministic instruction-merge evidence only, not live model submission, app-server mutation, filesystem mutation, terminal mutation, or Cafex behavior.

### HXCX-TUI-253 Headless Raw Codex Agent Status Feed Preview

Status: HXCX-TUI-253 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/app/agent_status_feed.rs` and `../codex/codex-rs/tui/src/app/agent_status_feed_tests.rs`. The fixture preserves the empty `/agent` status cell, bounded command/message activity preview, duplicate item suppression, reasoning-summary-only display that hides raw reasoning, whitespace collapse, and selected typed `activity_summary` variants. This is deterministic `/agent` preview evidence only, not live sub-agent runtime ownership, app-server mutation, model traffic, filesystem mutation, terminal mutation, or Cafex behavior.

### HXCX-TUI-254 Headless Raw Codex Agent Navigation State

Status: HXCX-TUI-254 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/app/agent_navigation.rs` and the picker naming helpers in `../codex/codex-rs/tui/src/multi_agents.rs`. The fixture preserves stable first-seen `/agent` picker order, next/previous wraparound navigation, active-agent labels for primary, nickname/role, and path-backed threads, non-primary detection, picker subtitle copy, remove/clear behavior, and closed-thread order preservation. This is deterministic pure navigation-state evidence only, not live app-server discovery, thread attach, terminal mutation, model traffic, filesystem mutation, or Cafex behavior.

### HXCX-TUI-255 Headless Raw Codex Loaded Subagent Thread Discovery

Status: HXCX-TUI-255 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/app/loaded_threads.rs`. The fixture preserves the pure spawn-tree walk from a primary thread through child and grandchild `ThreadSpawn` edges, deterministic string-sorted output, nickname/role/path metadata carry-through, and exclusion of primary, unrelated, invalid, and non-spawn thread records. This is deterministic loaded-thread discovery evidence only, not live app-server `thread/loaded/list` requests, model traffic, filesystem mutation, terminal mutation, or Cafex behavior.

### HXCX-TUI-256 Headless Raw Codex Goal Display Helpers

Status: HXCX-TUI-256 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/goal_display.rs`. The fixture preserves compact elapsed labels with negative-time clamping, status-label strings for every `ThreadGoalStatus`, rounded compact token usage in `goal_usage_summary`, optional time and budget sentence assembly, and no-live rejection evidence. This is deterministic goal display helper evidence only, not live ratatui rendering, app-server mutation, model traffic, filesystem mutation, terminal mutation, or Cafex behavior.

### HXCX-TUI-257 Headless Raw Codex Git Action Directives

Status: HXCX-TUI-257 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/git_action_directives.rs`. The fixture preserves visible-markdown stripping for `::git-*{...}` assistant directives, full directive identity and insertion-order dedupe for stage/commit/create-branch/push/create-pr rows, quoted attribute parsing, malformed required-attribute directive hiding, unclosed directive text preservation, `last_created_branch_cwd` selection, and code-comment fallback markdown with cwd-relative file locations. This is deterministic assistant-markdown parser evidence only, not live git mutation, filesystem mutation, GitHub/network calls, terminal mutation, model traffic, or Cafex behavior.

### HXCX-TUI-258 Headless Raw Codex Thread Transcript Cells

Status: HXCX-TUI-258 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/thread_transcript.rs`. The fixture preserves persisted `ThreadItem` projection into normalized user, assistant markdown, plan, reasoning, and plain fallback transcript cells; assistant markdown sanitization through `git_action_directives`; directive-only assistant message elision; hidden versus visible raw reasoning selection; selected fallback rows for hook prompts, command execution, file changes, MCP/dynamic tools, web search, images, review mode, and context compaction; and the empty-transcript fallback cell. This is deterministic transcript conversion evidence only, not live `thread_read`, ratatui history-cell rendering, terminal mutation, filesystem mutation, model traffic, or Caf/Cafex/Cafetera behavior.

### HXCX-TUI-259 Headless Raw Codex Line Truncation Helpers

Status: HXCX-TUI-259 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/line_truncation.rs`. The fixture preserves `line_width`-style span width accumulation, zero-width truncation to an empty line, full-span pass-through, zero-width span preservation when width remains, style-preserving partial-span truncation, a fixture wide-character boundary, ellipsis-on-overflow behavior, and ellipsis style selection from the last truncated span. This is deterministic line-helper evidence only, not live ratatui rendering, terminal mutation, filesystem mutation, or model traffic.

### HXCX-TUI-260 Headless Raw Codex Markdown Text Merge

Status: HXCX-TUI-260 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/markdown_text_merge.rs`. The fixture preserves `DecodedTextMerge`-style adjacent `Text` event coalescing, parser-decoded text concatenation without source reconstruction, first-start and last-end source range preservation, isolated text pass-through, non-text pass-through, and merge boundaries around non-text events. This is deterministic parsed-event adapter evidence only, not live terminal mutation, filesystem mutation, network traffic, or model traffic.

### HXCX-TUI-261 Headless Raw Codex Text Formatting Helpers

Status: HXCX-TUI-261 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/text_formatting.rs`. The fixture preserves empty and nonempty `capitalize_first`, compact JSON formatting for objects and arrays, invalid JSON passthrough, `truncate_text` thresholds for zero/short/ellipsis/exact cases, `format_and_truncate_tool_result` display sizing for JSON and plain text, selected center path truncation behavior, and proper English joining. This is deterministic text-helper evidence only, not live terminal mutation, filesystem mutation, network traffic, or model traffic.

### HXCX-TUI-262 Headless Raw Codex Live Wrap Row Builder

Status: HXCX-TUI-262 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/live_wrap.rs`. The fixture preserves `RowBuilder`-style fixed-width prefix wrapping, buffered partial display rows, newline-generated explicit breaks, explicit `end_line`, width reset rewrapping, commit-ready draining, and `take_prefix_by_width` behavior for ASCII plus a fixture wide character. This is deterministic row-builder evidence only, not live terminal mutation, filesystem mutation, network traffic, or model traffic.

### HXCX-TUI-263 Headless Raw Codex URL-Aware Wrapping

Status: HXCX-TUI-263 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/wrapping.rs`. The fixture preserves URL-like text detection for absolute/custom-scheme, wrapped, localhost, and invalid-path/port cases; span-concatenated line URL detection; mixed URL/non-URL token classification with decorative pipe and ordered-list markers ignored; adaptive wrapping that preserves long URL-like tokens, falls back to plain long-token chunking, and honors subsequent indentation; and representative trimmed range boundaries. This is deterministic wrapping evidence only, not live terminal mutation, filesystem mutation, network traffic, or model traffic.

### HXCX-TUI-264 Headless Raw Codex Scroll State

Status: HXCX-TUI-264 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/scroll_state.rs`. The fixture preserves optional selection reset, empty-list clearing, clamp-selection defaulting and out-of-range behavior, wrap-around up/down movement, page-up/page-down clamping, jump top/bottom, and `ensure_visible` scroll-window repair including zero visible-row and no-selection cases. This is deterministic list state evidence only, not live terminal mutation, ratatui rendering, filesystem mutation, network traffic, or model traffic.

### HXCX-TUI-265 Headless Raw Codex Selection Tabs

Status: HXCX-TUI-265 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/selection_tabs.rs`. The fixture preserves empty tab height, active tab bracket/accent intent, inactive tab dim intent, two-column tab gaps, width-driven wrapping, active-index changes, width clamping to at least one column, and render-area height truncation. This is deterministic tab layout evidence only, not live terminal mutation, ratatui buffer ownership, filesystem mutation, network traffic, or model traffic.

### HXCX-TUI-266 Headless Raw Codex Action-Required Title

Status: HXCX-TUI-266 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/action_required_title.rs`. The fixture preserves `build_action_required_title_text`-style prefix-only output, ordered item value composition, spinner omission, caller-supplied exclusion filtering, missing-value suppression, duplicate item preservation, and no-live rejection evidence. This is deterministic action-required title-string evidence only, not live terminal title mutation, ratatui ownership, filesystem mutation, network traffic, or model traffic.

### HXCX-TUI-267 Headless Raw Codex Popup Constants

Status: HXCX-TUI-267 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/popup_consts.rs`. The fixture preserves the shared `MAX_POPUP_ROWS` limit, standard Enter/Esc hint text, keymap-sourced primary accept/cancel bindings, accept-only hint text, cancel-only hint text, empty no-binding output, and no-live rejection evidence. This is deterministic popup constant and hint-string evidence only, not live terminal mutation, ratatui buffer ownership, filesystem mutation, network traffic, model traffic, or adapter-specific behavior.

### HXCX-TUI-268 Headless Raw Codex Status Line Style

Status: HXCX-TUI-268 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/status_line_style.rs`. The fixture preserves status-line segment order and separator insertion, fallback accent colors for model/path/branch/state/usage/limit/metadata/mode/thread/progress item families, theme resolver override before fallback, RGB softening math, dimmed non-theme styling, pull-request underline intent, empty-segment none output, and no-live rejection evidence. This is deterministic status-line text and style-intent evidence only, not live terminal mutation, ratatui buffer ownership, filesystem mutation, network traffic, model traffic, or adapter-specific behavior.

### HXCX-TUI-269 Headless Raw Codex Status Surface Preview

Status: HXCX-TUI-269 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/status_surface_preview.rs`. The fixture preserves representative default placeholders, live-value override of placeholders, placeholder updates preserving live values, placeholder suppression and missing `value_for`, status-line item filtering with order preservation, rate-limit preview copy names/descriptions for secondary usage, usage, 5h, daily, weekly, monthly, annual, fallback behavior, and no-live rejection evidence. This is deterministic preview-data evidence only, not live terminal mutation, ratatui buffer ownership, filesystem mutation, network traffic, model traffic, or adapter-specific behavior.

### HXCX-TUI-270 Headless Raw Codex Pending Input Preview

Status: HXCX-TUI-270 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/pending_input_preview.rs`. The fixture preserves empty and narrow-width suppression, queued follow-up section rows with default and remapped edit hints, pending steer/rejected steer/queued-message section order, default and remapped interrupt hints, multiline and width-wrapped three-row truncation with ellipsis, URL-like long-token no-ellipsis behavior, and no-live rejection evidence. This is deterministic pending-input preview row evidence only, not live terminal mutation, ratatui buffer ownership, filesystem mutation, network traffic, model traffic, or adapter-specific behavior.

### HXCX-TUI-271 Headless Raw Codex Pending Thread Approvals

Status: HXCX-TUI-271 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/pending_thread_approvals.rs`. The fixture preserves `set_threads` changed/unchanged and empty-state behavior, empty and narrow-width suppression, single and multiple inactive-thread approval rows, overflow after the third thread, stable wrapping indentation for long thread labels, the `/agent` switch hint, and no-live rejection evidence. This is deterministic pending-thread-approval row evidence only, not live terminal mutation, ratatui buffer ownership, filesystem mutation, network traffic, model traffic, or adapter-specific behavior.

### HXCX-TUI-272 Headless Raw Codex Prompt Args

Status: HXCX-TUI-272 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/prompt_args.rs`. The fixture preserves `parse_slash_name` rejection for missing slash and empty command names, name-only commands with empty rest, whitespace-trimmed rest text, byte `rest_offset` behavior, tab and newline whitespace splitting, Unicode command-name byte offsets, and no-live rejection evidence. This is deterministic prompt-argument parser evidence only, not live terminal mutation, ratatui buffer ownership, filesystem mutation, network traffic, model traffic, or adapter-specific behavior.

### HXCX-TUI-273 Headless Raw Codex Unified Exec Footer

Status: HXCX-TUI-273 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/unified_exec_footer.rs`. The fixture preserves `set_processes` changed/unchanged and empty-state behavior, absent summary text for no processes, singular and plural background-terminal summary grammar, narrow-width render suppression, stable two-space render prefix, width-driven truncation, and no-live rejection evidence. This is deterministic unified-exec footer summary evidence only, not live terminal mutation, ratatui buffer ownership, filesystem mutation, network traffic, model traffic, or adapter-specific behavior.

### HXCX-TUI-274 Headless Raw Codex File Search Popup

Status: HXCX-TUI-274 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/file_search_popup.rs`. The fixture preserves initial waiting state, idempotent query updates, empty-prompt reset, stale result rejection, matching-result acceptance, first-page truncation to `MAX_POPUP_ROWS`, required-height clamping, waiting versus no-match empty messages, move-up/down wrapping, selected path lookup, and no-live rejection evidence. This is deterministic file-search popup state evidence only, not live terminal mutation, ratatui buffer ownership, filesystem mutation, network traffic, model traffic, or adapter-specific behavior.

### HXCX-TUI-275 Headless Raw Codex Skill Popup

Status: HXCX-TUI-275 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/skill_popup.rs`. The fixture preserves empty-query sorting by `sort_rank` then display name, display-name and alternate-search-term filtering, display matches ordered before search-term-only matches, required-height clamping to `MAX_POPUP_ROWS + 2`, selected mention display/insert/path lookup, move-up/down wrapping, selection clamping after `set_mentions`, display-name truncation at 28 characters, description/category fallback row metadata, no-match selected-none behavior, and no-live rejection evidence. This is deterministic skill popup state evidence only, not live terminal mutation, ratatui buffer ownership, filesystem mutation, network traffic, model traffic, or adapter-specific behavior.

### HXCX-TUI-276 Headless Raw Codex Selection Popup Common

Status: HXCX-TUI-276 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/selection_popup_common.rs`. The fixture preserves menu-surface inset and vertical padding facts, `ColumnWidthMode::AutoVisible`, `AutoAllRows`, and `Fixed` description-column behavior, off-screen row influence on stable all-row columns, disabled row metadata, category tag carry-through, single-line overflow ellipsis, wrapped-height measurement, selected-row visibility under wrapped rows, explicit wrap-indent clamping for narrow widths, and no-live rejection evidence. This is deterministic shared popup layout evidence only, not live terminal mutation, ratatui buffer ownership, filesystem mutation, network traffic, model traffic, or adapter-specific behavior.

### HXCX-TUI-277 Headless Raw Codex List Selection View

Status: HXCX-TUI-277 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/list_selection_view.rs`. The fixture preserves `popup_content_width` shared inset math, `SideContentWidth::Fixed`, `Half`, disabled, and too-narrow side-by-side layout decisions, `SelectionRowDisplay` wrapped versus single-line intent, searchable filtering over normalized `search_value`, filtered-index-to-source-item mapping, enabled selection preservation across filters, disabled-row navigation skip behavior, disabled accept rejection, enabled accept and empty-filter cancellation outcomes, header/tab/footer/side-content height accounting where deterministic, and no-live rejection evidence. This is deterministic list-selection state/layout evidence only, not live terminal mutation, ratatui buffer ownership, filesystem or clipboard mutation, network traffic, model traffic, or adapter-specific behavior.

### HXCX-TUI-278 Headless Raw Codex Command Popup

Status: HXCX-TUI-278 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/command_popup.rs`, `../codex/codex-rs/tui/src/bottom_pane/slash_commands.rs`, and `../codex/codex-rs/tui/src/slash_command.rs`. The fixture preserves first-line slash composer parsing, first-token filter extraction, empty-filter alias hiding, debug/apps popup exclusion, exact-before-prefix matching, prefix presentation order, service-tier catalog insertion and selected ID carry-through, filter-change selection/scroll reset, alias visibility during prefix search, feature-gated plan command visibility, no-match cancellation, deterministic row/height summaries through the command popup surface, and no-live rejection evidence. This is deterministic command-popup state/layout evidence only, not live terminal mutation, ratatui buffer ownership, filesystem or clipboard mutation, network traffic, model traffic, command execution, or adapter-specific behavior.

### HXCX-TUI-279 Headless Raw Codex Multi-Select Picker

Status: HXCX-TUI-279 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/multi_select_picker.rs`. The fixture preserves deterministic search query trimming/filter ordering evidence, filtered-index to source-item mapping, selected index and scroll summaries, checkbox row state, section-break row representation, display-name truncation, toggle/change-callback preview evidence without app-event delivery, ordering-enabled reorder behavior, non-orderable reorder guard behavior, confirm selected IDs in current item order, cancel completion, required-height clamping with preview rows, and no-live rejection evidence. This is deterministic multi-select picker state/layout evidence only, not live terminal mutation, ratatui buffer ownership, filesystem or clipboard mutation, network traffic, model traffic, app-event delivery, or adapter-specific behavior.

### HXCX-TUI-280 Headless Raw Codex App Link View

Status: HXCX-TUI-280 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/app_link_view.rs`. The fixture preserves Codex Apps auth URL admission and metadata extraction, untrusted auth URL rejection, generic external URL admission and credential rejection, installed/enabled action labels, list movement clamping, enable/disable event intent, browser-open transition into confirmation, install confirmation refresh plus elicitation accept intent, enable-tool accept intent, matching app-server request dismissal, mismatch preservation, terminal-title action requirement, deterministic content/action height facts, and no-live rejection evidence. This is deterministic app-link view state/layout evidence only, not live terminal mutation, ratatui buffer ownership, real browser launch, app-server delivery, filesystem or clipboard mutation, network traffic, model traffic, or adapter-specific behavior.

### HXCX-TUI-281 Headless Raw Codex Custom Prompt View

Status: HXCX-TUI-281 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/custom_prompt_view.rs` and `../codex/codex-rs/tui/src/bottom_pane/custom_prompt_view_tests.rs`. The fixture preserves title/context/placeholder metadata, initial text cursor placement, trimmed nonempty Enter submission, whitespace-only Enter non-submission, modified Enter newline insertion, Esc cancellation, explicit paste acceptance and empty-paste rejection, paste-burst newline preservation for rapid char/tab/Enter sequences, delayed Enter submission, deterministic input/desired height facts, cursor availability bounds, popup hint evidence, and no-live rejection evidence. This is deterministic custom prompt state/layout evidence only, not live terminal mutation, ratatui buffer ownership, prompt callback side effects, app-server delivery, filesystem or clipboard mutation, network traffic, model traffic, or adapter-specific behavior.

### HXCX-TUI-282 Headless Raw Codex Paste Burst

Status: HXCX-TUI-282 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/paste_burst.rs`. The fixture preserves the pure PasteBurst state-machine thresholds and decisions: ASCII first-character hold and typed flush, fast ASCII `BeginBufferFromPending`, buffered paste flush, modified-input flush of pending state, retro-grab admission/rejection, newline suppression window after flush, direct Enter suppression and window extension, active append/newline behavior, clear-window versus explicit-paste clearing, no-hold burst detection, and no-live rejection evidence. This is deterministic state-machine evidence only, not live terminal mutation, real textarea mutation, ratatui buffer ownership, clipboard or filesystem mutation, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-283 Headless Raw Codex TextArea

Status: HXCX-TUI-283 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for `../codex/codex-rs/tui/src/bottom_pane/textarea.rs`. The fixture preserves full-buffer replacement with element clearing, element range clamping/sorting/skipping, insert/replace cursor shifts, UTF-8 cursor-boundary clamping, kill-buffer preservation across `set_text_*`, Vim insert/normal paste-burst admission, deterministic wrapped-line/desired-height and cursor-position scroll facts, and no-live rejection evidence. This is deterministic textarea state/layout evidence only, not live terminal mutation, ratatui buffer ownership, real clipboard mutation, filesystem mutation, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-284 Headless Raw Codex TextArea Editing

Status: HXCX-TUI-284 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream `../codex/codex-rs/tui/src/bottom_pane/textarea.rs` editing tests. The fixture preserves backward/forward delete edge behavior, atomic element deletion at the left edge, separator-aware backward and forward word deletion, kill-to-line-start/end behavior, linewise whole-line kill/yank and paste-below facts, characterwise yank restoration, multi-byte cursor left/right movement, logical vertical cursor movement, and Vim insert/normal movement/change-to-line-end facts. This is deterministic textarea editing state evidence only, not live keyboard input, terminal mutation, ratatui buffer ownership, real clipboard mutation, filesystem mutation, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-285 Headless Raw Codex TextArea Vim Text Objects

Status: HXCX-TUI-285 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream `../codex/codex-rs/tui/src/bottom_pane/textarea.rs` Vim operator and text-object tests. The fixture preserves `dw`, `ciw`, `yaw`, `diW`, word-end `daw`, final-word `ciW`, delimiter aliases including `cib` and `da]`, empty inner text-object change no-op facts, quote text-object escape and line-local behavior, cancellation and invalid-motion consumption facts, `e` and `de` word-end behavior, `$` line-end/delete behavior, and atomic-element word-end movement. This is deterministic Vim textarea state evidence only, not live keyboard input, terminal mutation, ratatui buffer ownership, real clipboard mutation, filesystem mutation, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-286 Headless Raw Codex TextArea Elements

Status: HXCX-TUI-286 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream `../codex/codex-rs/tui/src/bottom_pane/textarea.rs` text-element mutation and atomic-boundary APIs. Upstream anchors include `TextArea::insert_str_at`/`replace_range` cursor and element shifting at lines 348-360, `set_cursor` nearest-boundary clamping at lines 401-405, element payload/snapshot/id lookup and mutation APIs at lines 1349-1529, add/remove element range guards at lines 1545-1578, character/nearest/insertion boundary helpers at lines 1592-1641, range expansion at lines 1646-1664, element shifting at lines 1668-1694, and prev/next atomic boundaries at lines 1697-1738. The fixture preserves insert element/named element behavior, payload replacement, replace-by-id versus update-by-id metadata retention, named range lookup, add/remove range ordering and overlap rejection, cursor clamping out of element interiors, insertion snapping to element boundaries, replace-range expansion across intersecting elements, and no-live rejection evidence. This is deterministic textarea element-state evidence only, not live keyboard input, terminal mutation, ratatui buffer ownership, real clipboard mutation, filesystem mutation, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-287 Headless Raw Codex TextArea Invariants

Status: HXCX-TUI-287 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with deterministic invariant evidence for upstream `../codex/codex-rs/tui/src/bottom_pane/textarea.rs`. Upstream anchors include the focused edit/cursor tests at lines 2116-2219, atomic element word-deletion behavior at lines 2913-2945, and the randomized textarea operation/invariant loop at lines 3770-3898. The fixture preserves cursor-in-bounds and cursor-outside-element checks, ordered non-overlapping in-bounds element ranges, payload snapshot/range consistency, atomic previous/next movement safety, insertion/deletion/replacement/yank sequence invariants, wrapped-line and cursor-screen bounds, and no-live rejection evidence. This is deterministic headless invariant evidence only, not randomized ratatui property execution, live rendering, terminal mutation, real clipboard mutation, filesystem mutation, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-288 Headless Raw Codex Chat Composer TextArea Routing

Status: HXCX-TUI-288 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` routing between `ChatComposer` and `TextArea`. Upstream anchors include the composer key-routing contract at lines 14-17, paste-burst and IME/non-ASCII routing at lines 92-125 and 1697-1768, disabled-input handling at lines 127-130, Vim insert escape and reset behavior at lines 1037-1075, current-input restore/sync behavior at lines 1240-1255, `insert_str` TextArea delegation at lines 1626-1630, top-level disabled/release/history/popup/no-popup dispatch plus post-dispatch popup sync at lines 1632-1660, and popup synchronization ordering at lines 3483-3573. The fixture preserves disabled-input and key-release suppression, no-popup TextArea delegation, non-ASCII paste-burst delegation, active file-popup interception/dismissal, post-dispatch Vim reset evidence, submission-readiness preservation, popup sync intent, and no-live rejection evidence. This is deterministic ChatComposer/TextArea routing evidence only, not live keyboard input, terminal mutation, ratatui buffer ownership, real clipboard mutation, filesystem mutation, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-289 Headless Raw Codex Chat Composer Current Text Import

Status: HXCX-TUI-289 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` canonical text/import behavior. Upstream anchors include external editor import and pending-paste clearing at lines 951-985, full-buffer content replacement at lines 1200-1255, cursor projection/clamping at lines 1257-1289, current text-element range shifting at lines 1290-1309, imported text absorption of the bash `!` prefix at lines 1371-1388, `current_text` reconstruction at lines 1416-1422, history entry restore and end-of-line cursor placement at lines 1424-1448, submission text extraction/trim/pending expansion at lines 2630-2728, history navigation dispatch at lines 3120-3145, and focused tests around history restore and external edit/current text behavior at lines 9431-9552 and 10740-10937. The fixture preserves plain and bash canonical text extraction, bash prompt-prefix absorption without duplication, element range shifting across canonical/textarea boundaries, import leaving bash mode, cursor restore clamping, history recall end cursor behavior, submission trimming plus pending paste expansion, pending payload clearing, and no-live rejection evidence. This is deterministic ChatComposer text/import state evidence only, not live external editor launch, live keyboard input, terminal mutation, ratatui buffer ownership, real clipboard mutation, filesystem mutation, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-290 Headless Raw Codex Chat Composer External Edit Attachments

Status: HXCX-TUI-290 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` external edit attachment reconciliation. Upstream anchors include `apply_external_edit` pending-paste clearing, matching-placeholder retention, textarea element rebuild, remote-offset relabeling, and cursor-to-end placement at lines 951-1034; local image reset/relabel helpers at `../codex/codex-rs/tui/src/bottom_pane/chat_composer/attachment_state.rs:79-100` and `:225-249`; TextArea element payload inspection at `../codex/codex-rs/tui/src/bottom_pane/textarea.rs:1349`; and focused tests around external edit rebuild/drop/renumber/duplicate limiting plus remote-image numbering at lines 10740-11013. The fixture preserves pending paste clearing, retained local-image placeholders, missing attachment drops, kept-attachment placeholder renumbering, remote-image offset-aware renumbering, duplicate occurrence limiting to available attachments, atomic element payload rebuild evidence, cursor-to-end placement, and no-live rejection evidence. This is deterministic ChatComposer external-edit state evidence only, not live external editor launch, live file/image reads, terminal mutation, ratatui buffer ownership, clipboard mutation, filesystem mutation, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-291 Headless Raw Codex Chat Composer Image Submission

Status: HXCX-TUI-291 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` image submission and relabel behavior. Upstream anchors include `attach_image` at lines 1499-1502, submission text/image preparation at lines 2630-2728, selected remote image deletion/relabel routing near lines 3240-3265, local-image submission tests at lines 9359-9400 and 10032-10062, remote/local history restore and remote-only submission tests at lines 9431-9498, remote-offset local placeholder preservation and remote-only preparation tests at lines 10992-11060, and selected remote deletion relabel tests at lines 11082-11113. The fixture preserves local image placeholder numbering and submitted text elements, recent local image path carry-through, image-only local submission cleanup, remote-only empty-text submission with remote attachments present, remote-offset local placeholder preservation during submission, history restore for mixed remote/local images, selected remote deletion relabeling local placeholders, and no-live rejection evidence. This is deterministic ChatComposer image submission state evidence only, not live image reads, terminal mutation, ratatui buffer ownership, clipboard mutation, filesystem mutation, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-292 Headless Raw Codex Chat Composer Image Placeholder Editing

Status: HXCX-TUI-292 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` local image placeholder editing and deletion behavior. Upstream anchors include duplicate placeholder numbering and local attachment state at lines 10064-10090, placeholder backspace and atomic interior protection at lines 10092-10134, multibyte-adjacent backspace at lines 10136-10165, duplicate placeholder deletion/relabeling at lines 10167-10224, reordered placeholder deletion/relabeling at lines 10239-10291, adjacent text-element delete/relabel behavior at lines 10302-10333, attachment relabel helpers in `../codex/codex-rs/tui/src/bottom_pane/chat_composer/attachment_state.rs:225-249`, and TextArea element payload inspection at `../codex/codex-rs/tui/src/bottom_pane/textarea.rs:1349`. The fixture preserves duplicate placeholder numbering, backspace deletion of a single local image mapping, protection when the cursor is inside an atomic placeholder, multibyte text deletion adjacent to placeholders, delete/backspace relabeling for duplicate and reordered placeholders, local image pruning after normal textarea edits, element payload rebuild evidence, and no-live rejection evidence. This is deterministic ChatComposer placeholder editing state evidence only, not live image reads, terminal mutation, ratatui buffer ownership, clipboard mutation, filesystem mutation, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-293 Headless Raw Codex Chat Composer Image Path Paste Admission

Status: HXCX-TUI-293 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` image path paste admission. Upstream anchors include the `handle_paste` routing contract at lines 877-899, `image_paste_enabled` at lines 600-601 and 720-721, `handle_paste_image_path` normalization/dimension probing and attachment at lines 903-922, local image numbering in `../codex/codex-rs/tui/src/bottom_pane/chat_composer/attachment_state.rs:96-100`, pasted path normalization/format helpers in `../codex/codex-rs/tui/src/clipboard_paste.rs:251-364`, focused small-paste fallback tests at lines 7454-7482, the paste-filepath image attachment test at lines 10327-10347, and remote-offset numbering tests at lines 10992-11013. The fixture preserves admitted image path placeholder insertion plus trailing space, fallback text insertion for non-image and unreadable image-like paths, multibyte fallback stability, placeholder-adjacent image insertion, remote-image offset-aware local numbering, explicit redraw/paste-burst-clear/popup-sync facts, and no-live rejection evidence. This is deterministic ChatComposer paste admission state evidence only, not live image reads, terminal mutation, ratatui buffer ownership, clipboard mutation, filesystem mutation, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-294 Headless Raw Codex Chat Composer File Popup Image Selection

Status: HXCX-TUI-294 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` legacy file-popup selection behavior. Upstream anchors include file-popup dispatch at line 1652, `handle_key_event_with_file_popup` selection movement, Esc dismissal, no-selection fallback, selected image probing/attachment, and fallback path insertion at lines 1772-1878, `is_image_path` and the shared selected-file helper at lines 2073-2117, `insert_selected_path` active-token replacement and whitespace quoting at lines 2442-2482, local image numbering in `../codex/codex-rs/tui/src/bottom_pane/chat_composer/attachment_state.rs:96-100`, current `@token` boundary tests at lines 6504-6728, and large-paste element preservation during file completion at lines 8968-9023. The fixture preserves selected image replacement of the active file token, surrounding text preservation including upstream trailing-space behavior, multibyte-safe token boundary evidence, unreadable image fallback to inserted path text, quoted whitespace paths, large-paste element retention, remote-image offset-aware local numbering, popup clearing/redraw facts, and no-live rejection evidence. This is deterministic ChatComposer file-popup selection state evidence only, not live image reads, terminal mutation, ratatui buffer ownership, clipboard mutation, filesystem mutation, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-295 Headless Raw Codex Chat Composer Mentions-V2 File Image Selection

Status: HXCX-TUI-295 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` mentions-v2 file selection behavior. Upstream anchors include mentions-v2 popup dispatch and key handling at lines 1958-2065, `MentionV2Selection::File` routing at lines 2056-2058, shared selected-file image probing/fallback behavior at lines 2073-2117, mentions-v2 token detection at lines 2423-2428, active-token path replacement and whitespace quoting at lines 2442-2482, popup synchronization and file-search handoff at lines 3499-3545 and 3695-3724, selection shape definitions in `../codex/codex-rs/tui/src/bottom_pane/mentions_v2/candidate.rs:11-17`, and selected-row/file-match behavior in `../codex/codex-rs/tui/src/bottom_pane/mentions_v2/popup.rs:39-52`. The fixture preserves selected file candidates routed through `insert_selected_file_path`, admitted image placeholder insertion, unreadable image fallback to inserted path text, normal file insertion, empty-token selection behavior unique to mentions-v2, multibyte-safe token boundary evidence, remote-image offset-aware local numbering, popup clearing/redraw facts, and no-live rejection evidence. This is deterministic ChatComposer mentions-v2 file selection state evidence only, not live image reads, terminal mutation, ratatui buffer ownership, clipboard mutation, filesystem mutation, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-296 Headless Raw Codex Chat Composer Mentions-V2 Tool Mention Insertion

Status: HXCX-TUI-296 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` mentions-v2 tool, plugin, and skill selection behavior. Upstream anchors include selected mention-v2 tool routing at lines 1950 and 2059-2060, atomic mention insertion in `insert_selected_mention` at lines 2484-2528, mention token validation in `mention_token_from_insert_text` at lines 2530-2545, current mention binding projection at lines 2556-2606, candidate `Selection::Tool { insert_text, path }` shapes in `../codex/codex-rs/tui/src/bottom_pane/mentions_v2/candidate.rs:11-17`, and search-catalog skill/plugin candidates in `../codex/codex-rs/tui/src/bottom_pane/mentions_v2/search_catalog.rs:35-67`. The fixture preserves active-token replacement with trailing-space insertion, atomic textarea element creation, optional mention binding path capture for plugin and skill candidates, pathless tool insertion without binding creation, multibyte-safe cursor boundary evidence, retention of existing large-paste elements, empty-token mention-v2 selection behavior, popup clearing/redraw facts, and no-live rejection evidence. This is deterministic ChatComposer mentions-v2 tool insertion state evidence only, not live keyboard input, terminal mutation, ratatui buffer ownership, clipboard mutation, filesystem mutation, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-297 Headless Raw Codex Chat Composer Mention Binding Submission Capture

Status: HXCX-TUI-297 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` mention binding submission behavior. Upstream anchors include `take_mention_bindings` filtering and cleanup at lines 609-624, `set_text_content_with_mention_bindings` draft reset and rebinding at lines 1232-1252, `mention_bindings` and `take_recent_submission_mention_bindings` at lines 1480-1485, `current_mention_elements`, `snapshot_mention_bindings`, and `bind_mentions_from_snapshot` at lines 2550-2609, `prepare_submission_text_with_options` original binding snapshot, restoration-on-validation-failure, recent-submission capture, history recording, and pending cleanup at lines 2643-2728, and the focused upstream test `submit_captures_recent_mention_bindings_before_clearing_textarea` at lines 9397-9427. The fixture preserves current-element binding snapshot filtering, invalid/pathless binding exclusion, recent-submission capture before draft clearing, post-submit recent binding drain, empty draft binding cleanup, restored mention rebinding from snapshot, validation-failure restoration with pending state, and no-live rejection evidence. This is deterministic ChatComposer mention binding submission state evidence only, not live keyboard input, terminal mutation, ratatui buffer ownership, clipboard mutation, filesystem mutation, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-298 Headless Raw Codex Chat Composer Restored Bound Mentions

Status: HXCX-TUI-298 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` restored bound mention behavior. Upstream anchors include plaintext mention boundary matching in `find_next_mention_token_range` at lines 4021-4062, plugin mention highlight calculation and rendering at lines 2617-2628 and 4421 plus tests at lines 4904-5004, restored mention rebinding tests for matching sigils and both `@`/`$` forms at lines 6729-6828, email-substring and punctuation boundary rebinding tests at lines 6832-6909, arrow navigation across bound mentions at lines 6913-6954, and restored bound mention popup suppression/submission tests at lines 6958-7013. The fixture preserves rebinding of restored `@` and `$` tokens from snapshots, sigil-specific matching, dual-sigil binding order, email-substring exclusion, punctuation boundary acceptance, plugin accent metadata retention, arrow-key navigation without reopening popups, restored bound mention submission without popup interception, and no-live rejection evidence. This is deterministic ChatComposer restored bound mention state evidence only, not live keyboard input, terminal mutation, ratatui buffer ownership, clipboard mutation, filesystem mutation, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-299 Headless Raw Codex Mentions-V2 Catalog And Filter

Status: HXCX-TUI-299 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream mentions-v2 catalog and filtering behavior. Upstream anchors include candidate and selection shapes in `../codex/codex-rs/tui/src/bottom_pane/mentions_v2/candidate.rs`, skill/plugin catalog construction in `../codex/codex-rs/tui/src/bottom_pane/mentions_v2/search_catalog.rs`, mode acceptance and labels in `../codex/codex-rs/tui/src/bottom_pane/mentions_v2/search_mode.rs`, candidate/file-match filtering and sorting in `../codex/codex-rs/tui/src/bottom_pane/mentions_v2/filter.rs`, popup selected-row/file-search empty/loading/stale behavior in `../codex/codex-rs/tui/src/bottom_pane/mentions_v2/popup.rs`, and `ChatComposer::sync_mentions_v2_popup` handoff in `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` at lines 3695-3724. The fixture preserves skill/plugin candidate metadata, search-term counts, direct display-name versus search-term match evidence, deterministic ordering, all/tools/files mode filtering, file and directory file-match rows, stale file-search rejection, loading/no-match popup states, selected row metadata, and no-live rejection evidence. This is deterministic ChatComposer mentions-v2 catalog/filter state evidence only, not live filesystem scanning, terminal mutation, ratatui buffer ownership, clipboard mutation, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-300 Headless Raw Codex Mentions-V2 Render And Footer

Status: HXCX-TUI-300 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream mentions-v2 popup rendering and footer behavior. Upstream anchors include `Popup::calculate_required_height` and `render_ref` in `../codex/codex-rs/tui/src/bottom_pane/mentions_v2/popup.rs`, list/hint-area splitting, row visibility, selected-row styling, file-name/path projection, tags, truncation, and empty-message rendering in `../codex/codex-rs/tui/src/bottom_pane/mentions_v2/render.rs`, footer hint and active search-mode indicator rendering in `../codex/codex-rs/tui/src/bottom_pane/mentions_v2/footer.rs`, `SearchMode::label` in `../codex/codex-rs/tui/src/bottom_pane/mentions_v2/search_mode.rs`, and ChatComposer mentions-v2 popup dispatch around `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` lines 1958-2065 and 3695-3724. The fixture preserves `MAX_POPUP_ROWS + 2` height, two-column list inset, footer inset, scroll-adjusted selected row visibility, bold selected rows, dim secondary text, file basename/path split, tag projection, truncation evidence, loading/no-match empty rows, Enter/Esc/Left/Right footer hints, active mode labels for filesystem/tools modes, and no-live rejection evidence. This is deterministic ChatComposer mentions-v2 render/footer state evidence only, not live filesystem scanning, terminal mutation, ratatui buffer ownership, clipboard mutation, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-301 Headless Raw Codex Slash Command Dispatch

Status: HXCX-TUI-301 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream slash-command popup dispatch, queueing, and local recall behavior. Upstream anchors include slash command catalog/filter helpers in `../codex/codex-rs/tui/src/bottom_pane/slash_commands.rs`, command popup rows in `../codex/codex-rs/tui/src/bottom_pane/command_popup.rs`, slash parsing in `../codex/codex-rs/tui/src/bottom_pane/prompt_args.rs`, popup key handling, Tab/slash completion, queue fallback, inline-arg completion, command-element synchronization, and queued input action selection in `../codex/codex-rs/tui/src/bottom_pane/chat_composer/slash_input.rs`, and bare/inline dispatch, unavailable-command rejection, history staging/recording, and focused upstream regression tests in `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` around lines 2880-3010 and 8377-8668 plus the `/ test`, `/zzz`, and recall tests around lines 10568-10728. The fixture preserves Tab completion winning over running-task queueing, bare `/diff` dispatch, canonical popup-selected history recall, inline `/plan` arg dispatch and trimmed args, rich pending history metadata capture, slash-led running-task queueing as `parse_slash`, leading-space slash queueing as plain text, command element add/remove boundaries, hidden `/ test` and `/zzz` behavior from the existing popup slice, running-task unavailable command rejection, Esc dismissal without interrupting the task, and no-live rejection evidence. This is deterministic ChatComposer slash-command state evidence only, not live keyboard input, terminal mutation, ratatui buffer ownership, clipboard mutation, command execution, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-302 Headless Raw Codex Composer History Search

Status: HXCX-TUI-302 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream Ctrl-R composer history search behavior. Upstream anchors include history-search key detection, startup, query editing, cancellation, acceptance, result application, footer rendering, highlight ranges, and cursor placement in `../codex/codex-rs/tui/src/bottom_pane/chat_composer/history_search.rs` around lines 83-229, 233-390, and 445-481; focused upstream tests for open-without-preview, accept, boundaries, footer hints, highlights, Esc/Ctrl-C restore, paste flushing, and no-match behavior around lines 505-968; `HistorySearchDirection`, `HistorySearchResult`, pending lookup state, traversal restart/boundary behavior, persistent lookup requests, unique match caching, and persistent response tests in `../codex/codex-rs/tui/src/bottom_pane/chat_composer_history.rs` around lines 148-221, 507-580, 623-690, 714-769, and 1206-1340; `ChatComposer::on_history_entry_response`, key routing, footer-mode priority, footer-line rendering, and the remapped history-search test in `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` around lines 820-860, 1638-1648, 3439-3448, 4160-4200, and 8492-8518; and default footer history-search display in `../codex/codex-rs/tui/src/bottom_pane/footer.rs` around lines 172-174, 722-727, and 1222-1230. The fixture preserves Ctrl-R/F2 search-session creation without previewing latest history, original-draft snapshot/restore, pending-paste flush flags, file-query and popup suppression, remote-image selection clearing, query edits from idle/searching/no-match states, local `Found` preview and Enter accept, footer action text, case-insensitive highlight evidence, persistent lookup request and response facts, `Pending` and `AtBoundary` statuses, Ctrl-C and Esc cancellation, remapped-key fallback suppression, no-match restore while search remains open, and no-live lookup rejection evidence. This is deterministic ChatComposer history-search state evidence only, not live keyboard input, terminal mutation, ratatui buffer ownership, clipboard mutation, filesystem mutation, network traffic, model traffic, app-server delivery, persistent DB access, or adapter-specific behavior.

### HXCX-TUI-303 Headless Raw Codex Composer History Navigation

Status: HXCX-TUI-303 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream normal composer history navigation behavior. Upstream anchors include `ChatComposerHistory::should_handle_navigation`, `navigate_up`, `navigate_down`, `on_entry_response`, persistent cache insertion, stale log rejection, duplicate-local skipping, and `populate_history_at_index` in `../codex/codex-rs/tui/src/bottom_pane/chat_composer_history.rs` around lines 333-505 and 771-829, plus normal navigation tests around lines 1012-1079 and reset/cursor-boundary tests around lines 1461-1504. Composer anchors include `history_navigation_cursor`, `move_cursor_to_history_entry_end`, `apply_history_entry`, Up/Down routing, popup suppression while browsing history, image/attachment restore tests, cursor-at-end tests, Vim-normal navigation, remapped editor/Vim navigation, operator-pending suppression, and bang-command boundary tests in `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` around lines 1266-1274, 1357-1364, 1424-1448, 3111-3145, 3506-3514, and 9431-9815. The fixture preserves local Up/Down recall, clearing after newest history, attachment and pending-paste metadata restoration, cursor-boundary eligibility, last-history-text matching, persistent lookup request facts, stale response rejection, response/cache insertion, cached recall evidence, navigation reset, remapped editor/Vim fallback suppression, Vim-normal cursor placement, operator-pending suppression, popup-suppression coverage from the existing composer popup sync slice, and no-live input rejection evidence. This is deterministic ChatComposer history-navigation state evidence only, not live keyboard input, terminal mutation, ratatui buffer ownership, clipboard mutation, filesystem mutation, persistent DB access, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-304 Headless Raw Codex Composer Ctrl-C Clear And History Capture

Status: HXCX-TUI-304 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream composer-local Ctrl-C clearing and history capture. Upstream anchors include `ChatComposer::clear_for_ctrl_c` in `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` around lines 1391-1412 and focused tests for cleared draft recording, pending paste preservation, paste numbering reuse, local/remote image preservation, and restored placeholders around lines 5606-5668, 5700-5726, and 5912-5997. Bottom-pane anchors include `BottomPane::on_ctrl_c` and `clear_composer_for_ctrl_c` in `../codex/codex-rs/tui/src/bottom_pane/mod.rs` around lines 671-704 and 809-820 plus tests for modal/history-search consumption around lines 1939-1981. ChatWidget ownership is anchored by `ChatWidget::on_ctrl_c` in `../codex/codex-rs/tui/src/chatwidget/interaction.rs` around lines 352-410, where bottom-pane handling returns before process-level interrupt/quit handling. The fixture preserves empty composer no-op behavior, active history-search cancellation without clearing the draft or showing the quit hint, rich draft clearing with text elements, local and remote image metadata, mention bindings, pending paste capture, history navigation reset, app-history append intent, bottom-pane and ChatWidget key consumption, interrupt/quit suppression while the bottom pane handles the key, redraw facts, and no-live rejection evidence. This is deterministic composer Ctrl-C state evidence only, not live keyboard input, terminal mutation, ratatui buffer ownership, clipboard mutation, filesystem mutation, persistent DB access, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-305 Headless Raw Codex Composer Ctrl-D Quit Boundary

Status: HXCX-TUI-305 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream composer Ctrl-D quit-boundary behavior. Upstream anchors include Ctrl-D routing in `../codex/codex-rs/tui/src/chatwidget/interaction.rs` around lines 44-66 and `ChatWidget::on_ctrl_d` around lines 414-464, where Ctrl-D can request quit only when the composer is empty and no modal or popup is active, and where double-press shortcut ownership lives in ChatWidget. Composer anchors include `Ctrl-D` returning not-handled for an empty composer in `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` around lines 3100-3108, footer quit-shortcut key projection around lines 3400-3424, footer-mode selection around lines 3454-3468, and footer-mode snapshot coverage around lines 4708-4742. Bottom-pane anchors include `composer_is_empty` in `../codex/codex-rs/tui/src/bottom_pane/mod.rs` around lines 1228-1230 and `no_modal_or_popup_active` around lines 1271-1278. The fixture preserves empty-composer propagation from bottom-pane not-handled to ChatWidget shortcut arming, second-press quit request and shortcut clearing, non-empty composer suppression, modal/popup exclusion, history-search exclusion as an active popup/modal boundary, key-specific quit hint facts, redraw facts, and no-live rejection evidence. This is deterministic composer Ctrl-D state evidence only, not live keyboard input, terminal mutation, ratatui buffer ownership, clipboard mutation, filesystem mutation, persistent DB access, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-306 Headless Raw Codex Quit Shortcut Footer Reminder

Status: HXCX-TUI-306 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream quit shortcut footer reminder lifecycle behavior. Upstream anchors include `ChatWidget::handle_key_event`, `on_ctrl_c`, `on_ctrl_d`, `quit_shortcut_active_for`, and `arm_quit_shortcut` in `../codex/codex-rs/tui/src/chatwidget/interaction.rs` around lines 1-98 and 363-464, where unrelated press events clear the armed shortcut, Ctrl-C and Ctrl-D matching is key-specific, and ChatWidget owns shortcut expiry state. Bottom-pane anchors include `show_quit_shortcut_hint`, `clear_quit_shortcut_hint`, and `quit_shortcut_hint_visible` in `../codex/codex-rs/tui/src/bottom_pane/mod.rs` around lines 927-963, where rendering is delegated to the composer and expiry redraws are scheduled. Composer anchors include `ChatComposer::show_quit_shortcut_hint`, `clear_quit_shortcut_hint`, `quit_shortcut_hint_visible`, `footer_props`, `footer_mode`, footer-mode snapshots, and `base_footer_mode_tracks_empty_state_after_quit_hint_expires` in `../codex/codex-rs/tui/src/bottom_pane/chat_composer.rs` around lines 1575-1600, 3400-3469, 4685-4745, and 5580-5605. Footer anchors include `FooterProps::quit_shortcut_key`, `FooterMode::QuitShortcutReminder`, `reset_mode_after_activity`, `footer_from_props_lines`, `quit_shortcut_reminder_line`, and Ctrl-C reminder snapshots in `../codex/codex-rs/tui/src/bottom_pane/footer.rs` around lines 65-88, 170-226, 703-730, 877-879, and 1633-1666. The fixture preserves Ctrl-C and Ctrl-D reminder text, key-specific match/non-match facts, replacement of a visible reminder by a different shortcut key without accidental quit confirmation, unrelated activity clearing and redraw, expired reminder fallback to the empty/draft base footer mode, scheduled expiry redraw intent, and no-live/no-ratatui rejection evidence. This is deterministic footer reminder state evidence only, not live keyboard input, terminal mutation, ratatui buffer ownership, clipboard mutation, filesystem mutation, persistent DB access, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-307 Headless Raw Codex ChatWidget Quit Shortcut State

Status: HXCX-TUI-307 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for the upstream ChatWidget-owned quit shortcut state machine. Upstream anchors include early key routing and shortcut clearing in `../codex/codex-rs/tui/src/chatwidget/interaction.rs` around lines 1-98, where reasoning shortcuts, copy-last-response, and unrelated press events clear `quit_shortcut_expires_at` and `quit_shortcut_key`; `ChatWidget::on_ctrl_c` around lines 363-410, where the same active Ctrl-C shortcut requests shutdown-first quit or otherwise arms Ctrl-C; `ChatWidget::on_ctrl_d` around lines 414-443, where Ctrl-D only participates when the composer is empty and no modal/popup is active; `quit_shortcut_active_for` around lines 446-453, where matching is both key-specific and expiry-bounded; and `arm_quit_shortcut` around lines 455-464, where ChatWidget records the active key and delegates hint rendering to BottomPane. The fixture preserves typed shortcut transition kinds for arm, key-specific replace, match, unrelated-key clear, reasoning-shortcut clear, copy-shortcut clear, expiry rejection, and request-quit handoff; it also preserves active-key before/after labels, active flag transitions, match/expired/hint/clear/redraw facts, shutdown-first app-exit intent, and no-live/no-ratatui/no-model rejection evidence. This is deterministic ChatWidget shortcut state evidence only, not live keyboard input, terminal mutation, ratatui buffer ownership, clipboard mutation, filesystem mutation, persistent DB access, network traffic, model traffic, app-server delivery, or adapter-specific behavior.

### HXCX-TUI-308 Headless Raw Codex ChatWidget Ctrl-C Precedence

Status: HXCX-TUI-308 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream ChatWidget Ctrl-C precedence. Upstream anchors include Ctrl-C dispatch in `../codex/codex-rs/tui/src/chatwidget/interaction.rs` around lines 44-54 and `ChatWidget::on_ctrl_c` around lines 352-410, where live realtime stop wins before bottom-pane handling, bottom-pane handled cancellation returns before process-level interrupt/quit, disabled double-press either interrupts active work or requests shutdown-first quit, enabled double-press matches or arms the shortcut, and active work is interrupted only after the shortcut branch runs. Bottom-pane anchors include `BottomPane::on_ctrl_c` in `../codex/codex-rs/tui/src/bottom_pane/mod.rs` around lines 680-704 and focused modal/history-search tests around lines 1939-1981, where modal views and history search consume Ctrl-C locally without leaking process-level quit/interrupt ownership to ChatWidget. The fixture preserves typed Ctrl-C precedence kinds for realtime stop, modal handling, history-search handling, composer clear handling, disabled interrupt, disabled quit, enabled shortcut match, and enabled arm-and-interrupt; it also preserves realtime-stop suppression of bottom-pane handling, modal/history-search local ownership, hint show/clear facts, shortcut active transitions, active-goal pause and interrupt submission, shutdown-first handoff, redraw intent, and no-live/no-ratatui/no-model rejection evidence. This is deterministic Ctrl-C precedence evidence only, not live keyboard input, terminal mutation, ratatui buffer ownership, clipboard mutation, filesystem mutation, persistent DB access, network traffic, model traffic, app-server delivery, realtime audio transport, or adapter-specific behavior.

### HXCX-TUI-309 Headless Raw Codex ChatWidget Interrupt Key Routing

Status: HXCX-TUI-309 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for upstream configured interrupt-key routing outside Ctrl-C. Upstream anchors include `../codex/codex-rs/tui/src/chatwidget/interaction.rs` around lines 115-139, where the configured `chat_keymap.interrupt_turn` binding is checked only for task-running pending steer flows, review mode preserves steers and inserts a warning instead of interrupting, and successful pending-steer interrupts set `submit_pending_steers_after_interrupt` before submitting `AppCommand::interrupt()`. Additional anchors include `../codex/codex-rs/tui/src/chatwidget/input_queue.rs` around lines 21-44 and 52-60 for the queue-owned pending-steer flag, `../codex/codex-rs/tui/src/chatwidget/tests/composer_submission.rs` around lines 1023-1047 for remapped F12 interrupt binding behavior, and `../codex/codex-rs/tui/src/chatwidget/tests/review_mode.rs` around lines 288-308 and 828-852 for review suppression plus pending-steer submission after the interrupted turn arrives. The fixture preserves typed interrupt-key route kinds for ignored remapped Esc, matched pending-steer interrupt, review warning, no-pending passthrough, and queued-steer submission after interruption; it also records binding-match state, pending-steer preservation/drain facts, cancellable task gating, cancel-edit cleanup, redraw intent, and no-live/no-ratatui/no-model rejection evidence. This is deterministic key-routing state evidence only, not live keyboard input, terminal mutation, ratatui buffer ownership, clipboard mutation, filesystem mutation, persistent DB access, network traffic, model traffic, app-server delivery, realtime audio transport, or adapter-specific behavior.

### HXCX-TUI-310 Headless Raw Codex ChatWidget Pending-Steer Restore Merge

Status: HXCX-TUI-310 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for interrupted-turn pending-steer restore and submit-pending merge behavior. Upstream anchors include `../codex/codex-rs/tui/src/chatwidget/input_restore.rs` around lines 134-187, where `on_interrupted_turn` finalizes active work, clears `submit_pending_steers_after_interrupt`, selects the notice, submits pending steers immediately when requested, otherwise restores pending input to the composer, refreshes preview, optionally sends restore-cancelled-turn, and requests redraw; and around lines 189-282, where `drain_pending_messages_for_restore` merges rejected steers, pending steers, queued follow-ups, and the current composer draft in that order while rebasing image placeholders, text elements, and mention bindings before `restore_user_message_to_composer` writes the composer state. Focused upstream tests include `../codex/codex-rs/tui/src/chatwidget/tests/review_mode.rs` around lines 828-852 for submit-pending mode preserving the queued draft and current composer text, plus the broader restore/shape tests around lines 895-968 for pending steer mention binding and merge order restoration. The fixture preserves typed restore merge order values for rejected-pending-queued-composer restore and pending-only-submit drain, notice/reset facts, pending/queued/rejected counts, composer draft preservation, image/mention/text-element shape preservation, redraw intent, and no-live/no-ratatui/no-model rejection evidence. This is deterministic interrupted-restore state evidence only, not live keyboard input, terminal mutation, ratatui buffer ownership, clipboard mutation, filesystem mutation, persistent DB access, network traffic, model traffic, app-server delivery, realtime audio transport, or adapter-specific behavior.

### HXCX-TUI-311 Headless Raw Codex ChatWidget Thread Input State Restore

Status: HXCX-TUI-311 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for ChatWidget thread input state capture and restore modes. Upstream anchors include `../codex/codex-rs/tui/src/chatwidget/input_restore.rs` around lines 285-327 for `capture_thread_input_state`, where composer draft shape, pending/rejected/queued input, history records, compare keys, user-turn pending state, collaboration mode/mask, task-running, and agent-turn-running are captured together; and around lines 330-423 for `restore_thread_input_state`, where restore(Some) reinstates collaboration state, running state, composer/paste/image state, queues, missing history records, missing compare keys, pending preview, task status, and redraw, while restore(None) clears running state, queues, remote images, composer, pending pastes, preview, and redraw. Focused upstream tests include `../codex/codex-rs/tui/src/chatwidget/tests/composer_submission.rs` around lines 1050-1078 for sleep/task/agent restoration and clearing, and `../codex/codex-rs/tui/src/chatwidget/tests/review_mode.rs` around lines 361-405 for pending steer preservation without downgrading compare-key semantics. The fixture preserves typed thread-input-state modes for capture, restore_some, and restore_none; it records history resizing, compare-key fallback, pending-steer and queued-draft preservation, collaboration restoration, task/agent/sleep restoration, cleanup, surface refresh, preview refresh, redraw intent, and no-live/no-ratatui/no-model rejection evidence. This is deterministic thread-input state evidence only, not live keyboard input, terminal mutation, ratatui buffer ownership, clipboard mutation, filesystem mutation, persistent DB access, network traffic, model traffic, app-server delivery, realtime audio transport, or adapter-specific behavior.

### HXCX-TUI-312 Headless Raw Codex App Thread Input Handoff

Status: HXCX-TUI-312 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for app thread-routing handoff of ChatWidget input state. Upstream anchors include `../codex/codex-rs/tui/src/app/thread_routing.rs` around lines 51-80 for active thread activation and storing the active receiver/input state before route changes; around lines 1302-1328 for replayed thread snapshots restoring input state into the target thread; and focused app tests in `../codex/codex-rs/tui/src/app/tests.rs` around lines 519-540, 580-620, and 880-905 for stored receivers, queued input replay, and large input-state restoration. The fixture preserves typed app-thread input handoff modes for store_active, restore_snapshot, and missing_snapshot_fallback; it records no-current-thread no-op behavior, active receiver and input snapshot storage, side-thread and current-thread target distinction, pending input preservation, status/redraw refresh intent, and no-live/no-ratatui/no-model rejection evidence. This is deterministic app thread input handoff evidence only, not live Tokio channel ownership, live app-server delivery, terminal mutation, ratatui rendering, clipboard mutation, persistent DB access, network traffic, model traffic, tool execution, realtime transport, or adapter-specific behavior.

### HXCX-TUI-313 Headless Raw Codex Thread Snapshot Replay Boundary

Status: HXCX-TUI-313 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for the app-owned `replay_thread_snapshot` boundary. Upstream anchors include `../codex/codex-rs/tui/src/app/thread_routing.rs` around lines 1302-1347, where replay refreshes MCP startup expectation, conditionally brackets replay with history-buffer events, chooses side/quiet/normal session handlers, suppresses queue autosend around input restore plus turn/event replay, releases initial-submit suppression, optionally drains a restored queue, and refreshes the status line; and `../codex/codex-rs/tui/src/app/replay_filter.rs` around lines 8-31 for pending interactive request detection plus warning/guardian/config notice suppression. The fixture preserves typed replay routes for normal, quiet_pending_interactive, and side_thread; it records resize/history-buffer gating, pending interactive detection, notice suppression counts, session routing, queue autosend true/false bracketing, input restore, turn/event replay intent, initial-submit release, restored queue drain, status refresh, and no-live/no-ratatui/no-model rejection evidence. This is deterministic thread snapshot replay-boundary evidence only, not live Tokio channel ownership, live app-server delivery, terminal mutation, ratatui rendering, clipboard mutation, persistent DB access, network traffic, model traffic, tool execution, realtime transport, or adapter-specific behavior.

### HXCX-TUI-314 Headless Raw Codex Active Thread Event Dispatch

Status: HXCX-TUI-314 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for active-thread event dispatch. Upstream anchors include `../codex/codex-rs/tui/src/app/thread_routing.rs` around lines 1354-1380 for initial-session receiver gates, around lines 1400-1426 for rollback response cleanup of the active receiver, and around lines 1428-1454 for `handle_thread_event_now` notification, request, history-entry, feedback, and status-refresh dispatch. The fixture preserves typed active-thread event kinds for notification, request, history_entry_response, feedback_submission, and rollback_cleanup; it records collab receiver cache intent, TurnStarted and ThreadTokenUsageUpdated refresh triggers, pending request delivery versus stale skip, history-entry and feedback routing, active receiver drain/restore versus disconnected clear, and no-live/no-ratatui/no-model rejection evidence. This is deterministic active-thread dispatch evidence only, not live Tokio receiver ownership, live app-server delivery, terminal mutation, ratatui rendering, clipboard mutation, persistent DB access, network traffic, model traffic, tool execution, realtime transport, or adapter-specific behavior.

### HXCX-TUI-315 Headless Raw Codex Active Thread Shutdown Routing

Status: HXCX-TUI-315 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for active-thread shutdown routing. Upstream anchors include `../codex/codex-rs/tui/src/app/thread_routing.rs` around lines 1274-1301 for `active_non_primary_shutdown_target`, where only active non-primary `ThreadClosed` notifications without a matching pending shutdown-exit marker can fail over to primary; around lines 1400-1426 for active receiver cleanup during rollback; and around lines 1456-1518 for `handle_active_thread_event`, where unexpected non-primary closures fail over before pending shutdown-exit completion is cleared and ordinary event handling resumes. The fixture preserves typed shutdown routes for non_primary_failover, pending_exit_completion, primary_closed_no_failover, stale_shutdown_ignored, and non_shutdown_pass_through; it records primary/active/closed/pending thread ids, failover eligibility, side discard and primary selection, info/error message intent, pending shutdown marker clearing, ordinary event forwarding, receiver cleanup, app-exit intent, and no-live/no-ratatui/no-model rejection evidence. This is deterministic active-thread shutdown-routing evidence only, not live Tokio receiver ownership, live app-server delivery, terminal mutation, ratatui rendering, filesystem mutation, persistent DB access, network traffic, model traffic, tool execution, realtime transport, or adapter-specific behavior.

### HXCX-TUI-316 Headless Raw Codex Skills List Response Routing

Status: HXCX-TUI-316 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for app-owned skills-list response routing. Upstream anchors include `../codex/codex-rs/tui/src/app/thread_routing.rs` around lines 1386-1391 for `handle_skills_list_response`, where the app reads the ChatWidget cwd, extracts cwd-scoped skill errors, filters them through `SkillLoadWarningState::newly_active_errors`, emits warning history cells, and forwards the response into ChatWidget; `../codex/codex-rs/tui/src/app.rs` around lines 478-485 for `errors_for_cwd`; `../codex/codex-rs/tui/src/app/startup_prompts.rs` around lines 47-64 for warning event emission and around lines 433-510 for duplicate suppression, re-emission after clearing, changed-message handling, and render-once tests; `../codex/codex-rs/tui/src/chatwidget/protocol_requests.rs` around lines 50-52 for response forwarding; `../codex/codex-rs/tui/src/chatwidget.rs` around lines 1835-1838 for `on_list_skills`; and `../codex/codex-rs/tui/src/chatwidget/skills.rs` around lines 147-151 for cwd-filtered skill application to mentions. The fixture preserves typed skills-list routes for cwd_new_warnings, duplicate_suppressed, cwd_missing_no_errors, cleared_reemitted, and live_boundary_rejected; it records cwd, skill/error/warning counts, summary-plus-detail warning event counts, cwd scoping, newly-active filtering, duplicate suppression, clear-triggered re-emission, ChatWidget forwarding/application, and no-live/no-ratatui/no-model/no-filesystem rejection evidence. This is deterministic skills-list routing evidence only, not live filesystem reads, terminal mutation, ratatui rendering, persistent DB access, network traffic, model traffic, tool execution, realtime transport, or adapter-specific behavior.

### HXCX-TUI-317 Headless Raw Codex Initial Session Wait Routing

Status: HXCX-TUI-317 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for app-run initial-session wait routing. Upstream anchors include `../codex/codex-rs/tui/src/app/thread_routing.rs` around lines 1354-1384 for `should_wait_for_initial_session`, `should_handle_active_thread_events`, and `should_stop_waiting_for_initial_session`; `../codex/codex-rs/tui/src/app.rs` around lines 893-894 for startup wait configuration and around lines 1153-1234 for the run-loop select gate that suppresses active-thread receiver polling until a primary thread id exists; and `../codex/codex-rs/tui/src/app/tests/startup.rs` around lines 8-120 for fresh/exit wait selection, resume/fork no-wait selection, primary-thread stop behavior, and paused-goal prompt eligibility. The fixture preserves typed routes for configured fresh-session waiting, primary-thread-id stop and subsequent active-event dispatch, exit-session waiting without a receiver, resume-session no-wait plus paused-goal prompt eligibility, fork-session no-wait, queued active-event/redraw intent, and no-live/no-ratatui/no-model/no-filesystem rejection evidence. This is deterministic app-run startup gate evidence only, not live Tokio receiver ownership, live app-server delivery, terminal mutation, ratatui rendering, persistent DB access, network traffic, model traffic, tool execution, realtime transport, or adapter-specific behavior.

### HXCX-TUI-318 Headless Raw Codex Initial History Replay Buffer

Status: HXCX-TUI-318 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for initial history replay buffering during primary thread startup. Upstream anchors include `../codex/codex-rs/tui/src/app/thread_routing.rs` around lines 1110-1139 for `enqueue_primary_thread_session` emitting `BeginInitialHistoryReplayBuffer` and `EndInitialHistoryReplayBuffer` around non-empty turn replay; `../codex/codex-rs/tui/src/app/event_dispatch.rs` around lines 223-232 for dispatch into app replay-buffer handlers; `../codex/codex-rs/tui/src/app/resize_reflow.rs` around lines 117-165 for begin/finish semantics, overlay deferral, retained row flush, and transcript-tail fallback; and `../codex/codex-rs/tui/src/app/resize_reflow.rs` around lines 168-240 for insert behavior and bounded tail retention. The fixture preserves empty-turn no-buffer emission, non-empty resume begin/end emission, bounded tail retention with oldest-row drop, transcript-tail render fallback for thread-switch-style replay, overlay/deferred history behavior, final buffer clearing, and no-live/no-ratatui/no-model/no-filesystem rejection evidence. This is deterministic replay-buffer state evidence only, not live terminal scrollback mutation, ratatui rendering, Tokio channel ownership, persistent DB access, network traffic, model traffic, tool execution, realtime transport, or adapter-specific behavior.

### HXCX-TUI-319 Headless Raw Codex Agent Navigation Backfill

Status: HXCX-TUI-319 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for on-demand subagent backfill during `/agent` adjacent navigation. Upstream anchors include `../codex/codex-rs/tui/src/app/session_lifecycle.rs` around lines 637-693 for `backfill_loaded_subagent_threads`, where loaded thread ids are listed, read, filtered through the spawn-tree walk, and inserted into agent navigation metadata; `../codex/codex-rs/tui/src/app/session_lifecycle.rs` around lines 707-729 for `adjacent_thread_id_with_backfill`, where the local adjacent fast path wins before a one-attempt-per-primary loaded-thread backfill and retry; `../codex/codex-rs/tui/src/app/input.rs` around lines 110-133 for Alt-Left/Alt-Right routing through the backfill helper; and `../codex/codex-rs/tui/src/app/agent_navigation.rs` around lines 230-250 for stable adjacent-order selection. The fixture preserves no-primary refusal, backfill-on-miss, loaded subagent metadata/path insertion, adjacent fast-path behavior after backfill, last-subagent-backfill-attempt duplicate suppression, deterministic order preservation, and no-live/no-app-server/no-model/no-filesystem rejection evidence. This is deterministic navigation/backfill state evidence only, not live app-server `thread/loaded/list` or `thread/read` transport, Tokio channel ownership, terminal mutation, ratatui rendering, persistent DB access, network traffic, model traffic, tool execution, realtime transport, or adapter-specific behavior.

### HXCX-TUI-320 Headless Raw Codex App-Server Fork Notice Title Source

Status: HXCX-TUI-320 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for ChatWidget forked-thread history notice title selection. Upstream anchors include `../codex/codex-rs/tui/src/chatwidget/tests/history_replay.rs` around lines 650-786 for named fork notices, id-only fallback, app-server parent-title precedence, and ignoring stale local `session_index.jsonl` names; `../codex/codex-rs/tui/src/chatwidget.rs` around the forked-thread event/history insertion path; and the app-server thread-name update resume-hint test in `../codex/codex-rs/tui/src/chatwidget/tests/app_server.rs` around lines 1223-1244 as neighboring live-session history evidence. The fixture preserves typed fork notice title source values, effective title, local stale-title evidence, no-local-lookup facts, stale-local ignore facts, id-only fallback, notice insertion, and no-live/no-filesystem/no-network/no-ratatui/no-model rejection evidence. This is deterministic ChatWidget session-flow evidence only, not live app-server transport, local session-index filesystem lookup, terminal mutation, ratatui rendering, persistent DB access, network traffic, model traffic, tool execution, realtime transport, or adapter-specific behavior.

### HXCX-TUI-321 Headless Raw Codex App-Server Error History

Status: HXCX-TUI-321 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for ChatWidget app-server error history behavior. Upstream anchors include `../codex/codex-rs/tui/src/chatwidget/tests/app_server.rs` around `live_app_server_failed_turn_does_not_duplicate_error_history`, `live_app_server_failed_turn_consolidates_streamed_answer`, `live_app_server_stream_recovery_restores_previous_status_header`, `live_app_server_server_overloaded_error_renders_warning`, `live_app_server_cyber_policy_error_renders_dedicated_notice`, `app_server_safety_access_errors_render_dedicated_notice`, and `live_app_server_model_verification_renders_warning`; `../codex/codex-rs/tui/src/chatwidget/protocol.rs` for `ErrorNotification` and `TurnCompleted` handling; and `../codex/codex-rs/tui/src/chatwidget/turn_runtime.rs` for retryable and non-retry error classification. The fixture preserves failed-turn duplicate suppression, streamed answer consolidation before failure, retry status-header recovery, server-overloaded warning history, cyber/safety dedicated notices with fallback suppression, model-verification warning intent, and no-live/no-app-server/no-ratatui/no-model rejection evidence. This is deterministic ChatWidget app-server error-path evidence only, not live app-server transport, terminal mutation, ratatui rendering, persistent DB access, network traffic, model traffic, tool execution, realtime transport, or adapter-specific behavior.

### HXCX-TUI-322 Headless Raw Codex App-Server Thread Closed Exit

Status: HXCX-TUI-322 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for ChatWidget app-server lifecycle shutdown behavior. Upstream anchors include `../codex/codex-rs/tui/src/chatwidget/tests/app_server.rs` `live_app_server_thread_closed_requests_immediate_exit`, where a live `ThreadClosed` notification queues `AppEvent::Exit(ExitMode::Immediate)`; `../codex/codex-rs/tui/src/chatwidget/protocol.rs` for server-notification dispatch; and the replay-protocol suppression path already covered by HXCX-TUI-72 for replayed `ThreadClosed` notifications. The fixture preserves live thread-closed immediate-exit intent, replay suppression evidence, and no-live/no-app-server/no-ratatui/no-model rejection evidence. This is deterministic ChatWidget app-server lifecycle evidence only, not live app-server transport, terminal mutation, ratatui rendering, persistent DB access, network traffic, model traffic, tool execution, realtime transport, or adapter-specific behavior.

### HXCX-TUI-323 Headless Raw Codex Config Error History Wrapping

Status: HXCX-TUI-323 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for ChatWidget config error history wrapping. Upstream anchor is `../codex/codex-rs/tui/src/chatwidget/tests/config_errors_tests.rs` `chained_config_error_wraps_in_history_snapshot`, where `ChatWidget::add_error_message` inserts a long chained config/app-server failure into history and renders it at width 56. The fixture preserves one inserted history cell, width-bound wrapping, the outer `Failed to save default model` prefix, the inner `config/batchWrite` method fragment, the invalid-configuration detail, and no-live/no-app-server/no-ratatui/no-model rejection evidence. This is deterministic history-cell/wrapping evidence only, not live terminal mutation, ratatui rendering, app-server transport, config mutation, filesystem access, network traffic, model traffic, tool execution, realtime transport, or adapter-specific behavior.

### HXCX-TUI-324 Headless Raw Codex App-Server Warning Notifications

Status: HXCX-TUI-324 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for ChatWidget app-server warning notification history insertion. Upstream anchors are `../codex/codex-rs/tui/src/chatwidget/tests/app_server.rs` `live_app_server_warning_notification_renders_message`, `live_app_server_guardian_warning_notification_renders_message`, and `live_app_server_config_warning_prefixes_summary`, where ordinary warning, guardian warning, and config warning notifications each insert one warning history cell and preserve the rendered message or summary. The fixture preserves one warning history cell per notification kind, the skills-budget warning summary and guidance fragments, the guardian thread id and denial message, the config warning summary, and no-live/no-app-server/no-ratatui/no-model rejection evidence. This is deterministic warning-notification history evidence only, not live app-server transport, terminal mutation, ratatui rendering, config mutation, persistent DB access, network traffic, model traffic, tool execution, realtime transport, or adapter-specific behavior.

### HXCX-TUI-325 Headless Raw Codex App-Server Item History

Status: HXCX-TUI-325 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for ChatWidget app-server item history behavior. Upstream anchors are `../codex/codex-rs/tui/src/chatwidget/tests/app_server.rs` `live_app_server_file_change_item_started_preserves_changes` and `live_app_server_command_execution_strips_shell_wrapper`, where a started file-change item renders patch history containing `foo.txt` and a completed command execution renders one command history cell with the `/bin/zsh -lc` wrapper stripped from the displayed command. The fixture preserves file-change id/path/kind/status/summary facts, one file-change history cell, one completed command history cell, display-command stripping, exit/duration/output evidence, and no-live/no-tool/no-filesystem/no-ratatui/no-model rejection evidence. This is deterministic app-server item history evidence only, not live app-server transport, process execution, filesystem mutation, terminal mutation, ratatui rendering, persistent DB access, network traffic, model traffic, realtime transport, or adapter-specific behavior.

### HXCX-TUI-326 Headless Raw Codex Collab Agent Item History

Status: HXCX-TUI-326 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for ChatWidget app-server collab-agent tool-call history behavior. Upstream anchors are `../codex/codex-rs/tui/src/chatwidget/tests/app_server.rs` `live_app_server_collab_wait_items_render_history` and `live_app_server_collab_spawn_completed_renders_requested_model_and_effort`, where wait history uses cached receiver metadata such as `Robie [explorer]` and spawn completion preserves the requested prompt, model, and reasoning effort. The fixture preserves wait receiver thread ids, labels, statuses, messages, completed/running counts, spawn receiver id/status, requested prompt/model/reasoning-effort facts, history-cell counts, and no-live/no-tool/no-filesystem/no-ratatui/no-model rejection evidence. This is deterministic collab-agent item history evidence only, not live app-server transport, agent spawning, process execution, terminal mutation, ratatui rendering, persistent DB access, network traffic, model traffic, realtime transport, or adapter-specific behavior.

### HXCX-TUI-327 Headless Raw Codex App-Server Thread Name Updates

Status: HXCX-TUI-327 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for ChatWidget app-server `ThreadNameUpdated` handling. Upstream anchors are `../codex/codex-rs/tui/src/chatwidget/tests/app_server.rs` `live_app_server_invalid_thread_name_update_is_ignored` and `live_app_server_thread_name_update_shows_resume_hint`, plus `../codex/codex-rs/tui/src/chatwidget/snapshots/codex_tui__chatwidget__tests__thread_name_update_resume_hint.snap`. The fixture preserves invalid thread-id rejection, current thread id/name preservation, valid thread-name update state, the single resume-hint history cell, the rendered `codex resume` command/name/id evidence, and no-live/no-app-server/no-ratatui/no-model rejection evidence. This is deterministic ChatWidget app-server notification evidence only, not live app-server transport, terminal mutation, ratatui rendering, persistent DB access, network traffic, model traffic, realtime transport, or adapter-specific behavior.

### HXCX-TUI-328 Headless Raw Codex App-Server Safety Buffering

Status: HXCX-TUI-328 extends `fixtures/hxrust/tui-smoke.v1.json`, `test/TuiSmokeHarness.hx`, and `harness/check-tui-smoke.sh` with typed headless evidence for ChatWidget model safety-buffering notifications. Upstream anchors are `../codex/codex-rs/tui/src/chatwidget/tests/app_server.rs` `safety_buffering_offers_one_retry_with_app_wording`, `safety_buffering_stops_retrying_after_agent_message_starts`, `safety_buffering_without_retry_shows_short_app_message`, and `safety_buffering_ignores_hidden_stale_and_historical_updates`; `../codex/codex-rs/tui/src/chatwidget/safety_buffering.rs`; and the safety-buffering retry/no-retry snapshots. The fixture preserves active-turn and matching-turn gating, faster-model retry prompt wording, one-shot retry event facts, retry suppression after visible agent output, no-retry short status text, hidden/stale/historical update ignore behavior, hidden-update clearing of the prompt/status details, and no-live/no-app-server/no-ratatui/no-model rejection evidence. This is deterministic ChatWidget app-server notification evidence only, not live app-server transport, retry dispatch execution, terminal mutation, ratatui rendering, persistent DB access, network traffic, model traffic, realtime transport, or adapter-specific behavior.

### HXCX-4.143+: Credentialed Runtime, Realtime, And Interactive TUI

Only after the above are green:

- broader SQLite/log DB adapter implementation for persistent session/runtime state through generic metal/native Rust boundaries;
- credentialed provider integration and explicit no-credential test mode;
- realtime audio/WebRTC transport;
- full crossterm alternate-screen ownership;
- interactive input, popups, slash commands, status surfaces, and multi-agent affordances.

## haxe.rust Pressure Points

These are generic compiler/runtime pressure points. They must not become Codex-specific code in `../haxe.rust`.

| Pressure point | Why TUI/runtime needs it | Current stance |
| --- | --- | --- |
| Async/event-loop lowering | App-server clients, transport, cancellation, and bounded queues are async-heavy. | Define a runtime-neutral Haxe task/stream/cancel/backpressure contract first. Tokio is a Rust backend detail behind metal/native facades or generic haxe.rust runtime support; optional `@:await` sugar must lower to the same contract. File generic haxe.rust repros only when codexhx exposes a concrete compiler/runtime limitation. |
| Bounded channels/backpressure | Lossless transcript events must block; best-effort events can drop with lag markers. | Start with typed Haxe facades and metal/native wrappers where needed. |
| Ratatui/crossterm interop | Full TUI rendering depends on mature terminal crates. | haxe.rust already has ratatui demo evidence; codexhx should pressure-test richer VT100 and widget contracts generically. |
| Unicode width and ANSI spans | Upstream render tests cover CJK/emoji, word wrapping, and ANSI sanitization. | Keep pure text/layout reducers portable where possible; use crate wrappers for terminal-specific behavior. |
| Threading and shared state | TUI runtime uses channels, shared flags, mutexes, and background tasks. | haxe.rust has thread/concurrency evidence; codexhx should add app-level smoke gates for any specific pattern it adopts. |
| SQLite/persistence | Replacement claims require production persistence parity, not JSONL-only fixture state. | Use a typed metal boundary around native Rust DB crates; do not make portable state pretend to be production persistence. |
| Network/websocket/audio | Remote app-server and realtime require host/network/audio APIs. | Later metal/native-wrapper work, credential-free tests first. |
| Generated Rust quality | TUI/runtime debugging needs readable generated Rust and useful diagnostics. | Track concrete ugly or inefficient lowering as haxe.rust Beads with product-neutral fixtures. Existing `haxe.rust-oo3.73` is the benchmark-corpus anchor. |
| Non-copy local reuse | Reducers often route the same text payload into transcript, notification, and state fields. | HXCX-4.10 filed `haxe.rust-fzl`; until fixed, use explicit Haxe semantic copies rather than raw Rust or Codex-specific compiler hooks. |
| Static final access paths | Fixture and runtime harnesses often keep stable IDs as static constants. | HXCX-4.23 filed `haxe.rust-3f0g`; until fixed, use helper functions for constant values that generated Rust mispaths. |
| Nullable JSON enum helper matches | Fixture adapters commonly read optional JSON fields before converting into typed DTOs. | HXCX-TUI-103 exposed a portable generated-Rust mismatch around matching `Null<haxe.json.Value>` helper returns. Fixed upstream in haxe.rust `8b7b97b24f19577dda522e7d0cae33853a4ff44c` / `haxe.rust-qsoq` with the product-neutral `json_nullable_value_switch` snapshot; keep future compiler pressure generic and Codex-free. |
| Reused non-Copy string fallback lowering | Render-state reducers and policies often compute fallback values from an existing string local and then continue using that local for preservation checks. | HXCX-TUI-158 exposed a portable generated-Rust move/borrow mismatch for `HxString` reuse across a ternary fallback. Track as generic haxe.rust work with product-neutral fixtures; keep codexhx source clear and avoid Codex-specific compiler hooks. |

## Cafex Gate

Cafex/Cafetera adapter work stays behind upstream-shaped foundations:

- deterministic protocol and DTO parity: done for the selected app-server subset;
- runtime event bus/app-server client facade: done for selected fixture-backed behavior;
- TUI story/replay and selected VT100 rendering invariants: active;
- live transport/persistence boundaries: done for selected fixture/native-boundary behavior, not production ownership.

Therefore `codex-hxrust-mpd` and similar Cafex bridge tasks should remain P4/dependency-gated until at least HXCX-4.7 and HXCX-4.8 are intentionally selected or completed. Cafex live-status receipts are useful later, but they are not a substitute for upstream TUI/runtime ownership.

## Testing Rule

Use the existing policy in `docs/testing-strategy.md`:

- Haxe-authored tests compiled through haxe.rust are the primary proof.
- Upstream tests and fixtures are oracle evidence.
- Adapt public behavior into codexhx fixtures instead of depending on private upstream Rust test helpers.
- Differential tests become appropriate once a generated codexhx binary can run comparable public inputs.
