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

### HXCX-4.23+: Credentialed Runtime, Realtime, And Interactive TUI

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
| Async/event-loop lowering | App-server clients, transport, cancellation, and bounded queues are async-heavy. | Use `metal` + `rust_async` for Rust-native async slices. File generic haxe.rust repros only when codexhx exposes a concrete compiler/runtime limitation. |
| Bounded channels/backpressure | Lossless transcript events must block; best-effort events can drop with lag markers. | Start with typed Haxe facades and metal/native wrappers where needed. |
| Ratatui/crossterm interop | Full TUI rendering depends on mature terminal crates. | haxe.rust already has ratatui demo evidence; codexhx should pressure-test richer VT100 and widget contracts generically. |
| Unicode width and ANSI spans | Upstream render tests cover CJK/emoji, word wrapping, and ANSI sanitization. | Keep pure text/layout reducers portable where possible; use crate wrappers for terminal-specific behavior. |
| Threading and shared state | TUI runtime uses channels, shared flags, mutexes, and background tasks. | haxe.rust has thread/concurrency evidence; codexhx should add app-level smoke gates for any specific pattern it adopts. |
| SQLite/persistence | Replacement claims require production persistence parity, not JSONL-only fixture state. | Use a typed metal boundary around native Rust DB crates; do not make portable state pretend to be production persistence. |
| Network/websocket/audio | Remote app-server and realtime require host/network/audio APIs. | Later metal/native-wrapper work, credential-free tests first. |
| Generated Rust quality | TUI/runtime debugging needs readable generated Rust and useful diagnostics. | Track concrete ugly or inefficient lowering as haxe.rust Beads with product-neutral fixtures. Existing `haxe.rust-oo3.73` is the benchmark-corpus anchor. |
| Non-copy local reuse | Reducers often route the same text payload into transcript, notification, and state fields. | HXCX-4.10 filed `haxe.rust-fzl`; until fixed, use explicit Haxe semantic copies rather than raw Rust or Codex-specific compiler hooks. |

## Cafex Gate

Cafex/Cafetera adapter work stays behind upstream-shaped foundations:

- deterministic protocol and DTO parity: done for the selected app-server subset;
- runtime event bus/app-server client facade: not yet done;
- TUI story/replay and selected VT100 rendering invariants: active;
- live transport/persistence boundaries: not yet done.

Therefore `codex-hxrust-mpd` and similar Cafex bridge tasks should remain P4/dependency-gated until at least HXCX-4.7 and HXCX-4.8 are intentionally selected or completed. Cafex live-status receipts are useful later, but they are not a substitute for upstream TUI/runtime ownership.

## Testing Rule

Use the existing policy in `docs/testing-strategy.md`:

- Haxe-authored tests compiled through haxe.rust are the primary proof.
- Upstream tests and fixtures are oracle evidence.
- Adapt public behavior into codexhx fixtures instead of depending on private upstream Rust test helpers.
- Differential tests become appropriate once a generated codexhx binary can run comparable public inputs.
