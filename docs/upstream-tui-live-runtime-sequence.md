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

### HXCX-4.114+: Credentialed Runtime, Realtime, And Interactive TUI

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
