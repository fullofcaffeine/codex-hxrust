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

### HXCX-4.10: Turn Runtime State Reducers

Lift the selected `ChatWidget` turn lifecycle into pure Haxe state:

- task start/complete;
- assistant text deltas and final message source rules;
- plan delta/final plan item relationship;
- queued follow-up/steer bookkeeping;
- terminal turn status after failure/cancel.

This should stay portable-first unless haxe.rust exposes a concrete performance/codegen reason to split out a metal reducer.

### HXCX-4.11: App-Server Bootstrap And Initialize Handshake

Admit `initialize` in the right place:

- client info and capabilities;
- opt-out notification methods;
- platform/codex-home response fields;
- remote vs in-process bootstrap mode;
- config warnings and startup account/model metadata.

This was intentionally not admitted as a normal request in HXCX-3.74 because it belongs to transport/bootstrap parity.

### HXCX-4.12: Live Transport Spike

Add a narrow transport proof:

- in-process-style fixture transport first;
- remote/websocket/control-socket boundary as a metal/native wrapper;
- graceful disconnect and request cancellation semantics;
- no real credentials required.

This slice should decide whether the next implementation step is more app-server runtime or terminal UI.

### HXCX-4.13+: Persistence, Credentialed Runtime, Realtime, And Interactive TUI

Only after the above are green:

- SQLite/log DB adapter parity for persistent session/runtime state;
- credentialed provider integration and explicit no-credential test mode;
- realtime audio/WebRTC transport;
- full crossterm alternate-screen ownership;
- interactive input, popups, slash commands, status surfaces, and multi-agent affordances.

## haxe.rust Pressure Points

These are generic compiler/runtime pressure points. They must not become Codex-specific code in `../haxe.rust`.

| Pressure point | Why TUI/runtime needs it | Current stance |
| --- | --- | --- |
| Async/event-loop lowering | App-server clients, transport, cancellation, and bounded queues are async-heavy. | Use `metal` + `rust_async` for Rust-native async slices. File generic haxe.rust repros only when codexhx exposes a concrete compiler/runtime limitation. |
| Bounded channels/backpressure | Lossless transcript events must block; best-effort events can drop with lag markers. | Start with typed Haxe facades and metal/native wrappers where needed. |
| Ratatui/crossterm interop | Full TUI rendering depends on mature terminal crates. | haxe.rust already has ratatui demo evidence; codexhx should pressure-test richer VT100 and widget contracts generically. |
| Unicode width and ANSI spans | Upstream render tests cover CJK/emoji, word wrapping, and ANSI sanitization. | Keep pure text/layout reducers portable where possible; use crate wrappers for terminal-specific behavior. |
| Threading and shared state | TUI runtime uses channels, shared flags, mutexes, and background tasks. | haxe.rust has thread/concurrency evidence; codexhx should add app-level smoke gates for any specific pattern it adopts. |
| SQLite/persistence | Replacement claims require production persistence parity, not JSONL-only fixture state. | Use a typed metal boundary around native Rust DB crates; do not make portable state pretend to be production persistence. |
| Network/websocket/audio | Remote app-server and realtime require host/network/audio APIs. | Later metal/native-wrapper work, credential-free tests first. |
| Generated Rust quality | TUI/runtime debugging needs readable generated Rust and useful diagnostics. | Track concrete ugly or inefficient lowering as haxe.rust Beads with product-neutral fixtures. Existing `haxe.rust-oo3.73` is the benchmark-corpus anchor. |

## Cafex Gate

Cafex/Cafetera adapter work stays behind upstream-shaped foundations:

- deterministic protocol and DTO parity: done for the selected app-server subset;
- runtime event bus/app-server client facade: not yet done;
- TUI story/replay: selected fixture active; VT100 rendering parity: not yet done;
- live transport/persistence boundaries: not yet done.

Therefore `codex-hxrust-mpd` and similar Cafex bridge tasks should remain P4/dependency-gated until at least HXCX-4.7 and HXCX-4.8 are intentionally selected or completed. Cafex live-status receipts are useful later, but they are not a substitute for upstream TUI/runtime ownership.

## Testing Rule

Use the existing policy in `docs/testing-strategy.md`:

- Haxe-authored tests compiled through haxe.rust are the primary proof.
- Upstream tests and fixtures are oracle evidence.
- Adapt public behavior into codexhx fixtures instead of depending on private upstream Rust test helpers.
- Differential tests become appropriate once a generated codexhx binary can run comparable public inputs.
