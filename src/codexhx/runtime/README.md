# Runtime

Credential-free upstream-shaped headless runtime work starts here after DTO parity.

No real model calls, process mutation, or sandbox bypass belongs in this package.

## Model Client Boundary

`codexhx.runtime.model.ModelClient` is the provider boundary for headless model streaming:

- `startStream(request)` returns a `ModelStreamStartOutcome` with a provider-owned `ModelStreamHandle` and raw SSE stream text.
- `cancelStream(handle)` returns a deterministic `ModelStreamCancelOutcome`; cancellation is explicit and idempotency is provider-defined.
- `MockModelProvider` is fixture-backed and credential-free. It reads `fixtures/upstream/mock-model-basic-one-turn.sse`, emits a deterministic `mock-stream-N` handle, and tracks active stream ids only for cancel behavior.

Current async decision: keep this boundary synchronous for HXCX-3.2. The mock provider has no network IO, and the next one-turn state-machine slice benefits from deterministic start/cancel calls. A real provider must keep the same semantic boundary but can be backed later by haxe.rust async once the runtime needs live transport.

Future real-provider requirements:

- Stream start must accept explicit auth/config inputs from a higher layer; no environment reads inside DTO parsing or fixture harnesses.
- Streaming transport must surface ordered SSE chunks and deterministic parse errors without hiding provider failures.
- Cancellation must close the underlying request when possible and return a stable result when the stream already ended.
- Retry, rate-limit, and auth failures must map to typed outcomes before state-machine integration.
- Real network harnesses must stay separate from credential-free fixture gates.

## One-Turn Session State

`codexhx.runtime.session.OneTurnSessionRunner` is the HXCX-3.3 state-machine slice. It starts a model stream through `ModelClient`, parses the raw SSE stream, preserves ordered model events, and returns a deterministic terminal state:

- `completed` when a `response_completed` event is observed and no failure event is present.
- `failed` when provider start or parser errors occur, or when a model `response_failed` event is observed.
- `incomplete` when the stream parses but has no terminal model event.
- `cancelled` when `OneTurnInterruptPolicy` requests cancellation at a safe checkpoint.

Provider and parser failures are returned as `OneTurnSessionOutcome.failure(...)` with a single structured `session_error` event. Later transcript/state-store work should consume this outcome instead of adding another error channel.

## Cancellation

HXCX-3.6 cancellation is modeled by `OneTurnInterruptPolicy`.

Current safe checkpoints are:

- before provider start, which returns a `cancelled` outcome with no stream id and no provider process/path to clean up;
- after N parsed model events, which calls `ModelClient.cancelStream(handle)`, appends a terminal `session_cancelled` event, and returns partial assistant text.

Partial transcripts are intentional: events observed before the checkpoint are preserved in order, then `session_cancelled` terminates the transcript. Request prompts and credentials still do not enter transcript/state artifacts. In mock mode there is no native child process; the provider tracks only active stream ids, and the cancellation harness asserts that the cancelled stream id is no longer active.

## Headless JSONL Adapter

`codexhx.runtime.app.HeadlessJsonlAdapter` is the HXCX-3.4 app-server/debug-client comparison boundary. It consumes one JSON command per line and emits deterministic JSONL responses/events for the supported headless subset:

- `start` initializes the fixed mock thread/session and returns idle status.
- `submit` runs the one-turn mock runtime and records the latest turn outcome.
- `status` reports the current terminal/runtime status.
- `transcript` emits one `transcript_event` line per runtime event, followed by a summary response.

HXCX-3.5 extends the same boundary with upstream app-server JSON-RPC method envelopes:

- `thread/start` initializes the fixed mock thread/session and returns the selected `ThreadStartResponse` subset.
- `turn/start` accepts text-only `UserInput` entries, runs the credential-free one-turn runtime, and returns the selected `TurnStartResponse` subset.
- `thread/read` returns the selected `ThreadReadResponse` subset and includes turns only when `includeTurns` is true.
- `turn/interrupt` validates `threadId` and `turnId`; because this harness is synchronous, completed, idle, and not-started turns fail closed instead of claiming live cancellation.

Failed mock turns emit the selected upstream `error` server notification with `threadId`, `turnId`, `willRetry`, and `TurnError`, then record the terminal turn status as `failed` for `thread/read`.

Successful mock turns emit selected assistant text deltas as upstream `item/agentMessage/delta` notifications between agent item start and completion. They also emit the selected upstream `rawResponseItem/completed` notification for the assistant raw response message before the completed app item. The completed turn and `thread/read` response still use the full deterministic agent message item.

Unsupported commands fail closed with `unsupported_command`. The adapter remains credential-free and fixture-backed; it is not a live app-server transport, and it should stay a thin protocol adapter over the pure runtime state machine.

## Runtime App-Server Client Facade

`codexhx.runtime.app.InMemoryAppServerClient` is the HXCX-4.7 upstream TUI/live-runtime foundation. It is not a transport yet; it is a typed, deterministic shell modeled after upstream `AppServerClient` behavior:

- `CodexRuntimeCommand` represents app request, response completion, and response failure commands.
- `CodexRuntimeEvent` represents server notifications, client responses/errors, lag markers, and disconnects.
- `CodexRuntimeNotificationDelivery` mirrors upstream `server_notification_requires_delivery`: assistant/plan/reasoning deltas and item/turn/settings completions are lossless; status/progress/output updates are best-effort.
- `CodexRuntimeEventQueue` is bounded and deterministic. Best-effort overload records skipped-event lag evidence. Lossless/control events fail with explicit backpressure when no consumer capacity exists, rather than silently corrupting transcript state.
- Request correlation is explicit: duplicate, unknown, method-mismatched, invalid request, invalid response, and invalid error JSON paths produce typed `RuntimeClientOutcome` codes.

The fixture `fixtures/hxrust/runtime-app-client.v1.json` and `harness/check-runtime-app-client.sh` prove the facade through both Haxe interpreter and haxe.rust-generated Rust. The slice intentionally stays portable; later live transport work can place metal/native async wrappers around this semantic core.

HXCX-4.7 also exposed generic haxe.rust issue `haxe.rust-362`: nullable `Array<Class>.shift()` return lowering mismatched Rust `Option` and non-null class reference signatures. The local runtime queue now uses a typed read outcome plus indexed removal; the compiler issue is tracked upstream as product-neutral work, not a Codex-specific workaround.

## Runtime Bootstrap

`codexhx.runtime.app.bootstrap` is the HXCX-4.11 app-server initialize/bootstrap slice. It models upstream v1 `initialize` as session setup, not as a post-bootstrap app request:

- `BootstrapClientInfo`, `BootstrapCapabilities`, and `BootstrapInitializeParams` build initialize params with client name/title/version, experimental API, attestation request, and exact opt-out notification method names.
- `BootstrapInitializeResponse` covers upstream response fields: `userAgent`, absolute `codexHome`, `platformFamily`, and `platformOs`.
- `BootstrapStartupMetadata` records startup account/model/config-warning metadata beside the handshake instead of pretending it is part of `InitializeResponse`.
- `CodexBootstrapSession` distinguishes `remote` from `in_process`: remote mode emits the JSON-RPC `initialize` request and follow-up `initialized` notification; in-process mode keeps the same typed params/metadata without transport JSON.

The fixture `fixtures/hxrust/runtime-bootstrap.v1.json` and `harness/check-runtime-bootstrap.sh` prove the boundary through both Haxe interpreter and haxe.rust-generated Rust. The harness also asserts that `initialize` remains rejected by the generic `AppProtocol` request parser.

## Fixture Live Transport

`codexhx.runtime.app.transport.FixtureLiveTransport` is the HXCX-4.12 credential-free transport proof over `InMemoryAppServerClient`:

- request, response, notification, and event-drain flows exercise the same typed runtime facade used by earlier app-client slices;
- `cancelRequest` removes a pending request and emits a control error event with JSON-RPC cancellation code `-32800`;
- `disconnect` emits the same disconnected event kind as the upstream remote client and makes later sends fail with `transport_closed`;
- no websocket, unix socket, auth token, environment credential, or OS control socket is opened in this package.

The fixture `fixtures/hxrust/runtime-transport.v1.json` and `harness/check-runtime-transport.sh` prove request/response notification flow, pending request cancellation, graceful disconnect, and post-disconnect refusal through both Haxe interpreter and haxe.rust-generated Rust. Real remote websocket/control-socket ownership remains a later generic metal/native wrapper, documented in `docs/live-transport-boundary.md`.

## Persistent App-Server/TUI State Boundary

`codexhx.runtime.app.persistence` is the HXCX-4.13 persistence split for upstream app-server/TUI state:

- portable Haxe validates typed thread/session IDs, absolute rollout paths, history item counts, persisted item counts, rollout item kind summaries, and state-intent flags;
- native Rust owns production effects such as `StateDbHandle`, `LogDbLayer`, SQLite/sqlx runtime ownership, `reconcile_rollout`, `persist_thread`, file locking, migrations, repair, and cross-process coordination;
- fixture JSONL metadata is evidence for deterministic validation only, not a replacement claim for upstream persistent state.

The fixture `fixtures/hxrust/persistence-boundary.v1.json` and `harness/check-persistence-boundary.sh` prove the boundary through both Haxe interpreter and haxe.rust-generated Rust. The full boundary decision is documented in `docs/persistent-state-boundary.md`.

`codexhx.native.state.StateSqliteBridge` is the HXCX-4.14 first native SQLite pressure slice:

- metal haxe.rust owns an in-memory SQLite upsert/readback for selected thread metadata;
- portable/interpreter mode keeps a deterministic in-memory simulation because local Haxe `sys.db.Sqlite` is unsupported;
- mutation intent and invalid metadata fail closed before native writes.

The fixture `fixtures/hxrust/native-sqlite-persistence.v1.json` and `harness/check-native-sqlite-persistence.sh` prove the slice through both paths. This is still a narrow pressure proof, not full `StateDbHandle` or `LogDbLayer` parity.

HXCX-4.15 extends the same bridge with `runInMemory(commands)` and a typed `StateSqliteAdapterReport`:

- `StateSqliteCommand` carries reconcile and query requests without raw Rust escapes.
- `StateSqliteQueryRequest` validates `ThreadId` and supports optional archived-state filtering.
- adapter outcomes preserve operation, code, backend, row count, and optional row summary for fixture assertions.

The fixture `fixtures/hxrust/native-state-adapter.v1.json` and `harness/check-native-state-adapter.sh` prove insert, update, query, missing-row, mutation-disabled, and invalid-query behavior through both interpreter simulation and metal generated Rust. The slice is documented in `docs/native-state-adapter.md`.

## Persisted Thread Read View

`codexhx.runtime.app.persistence.PersistedThreadReadViewBuilder` is the HXCX-4.16 adapter-fed read-view slice:

- `PersistedThreadReadRequest` validates typed thread IDs and carries internal include-turns/include-archived read flags.
- `PersistedThreadReadView` projects selected persisted metadata into typed thread/session/path/status fields.
- `PersistedThreadHistorySummary` reports metadata-only versus history-included counts without reading real rollout files.
- missing threads, active-only archived reads, invalid IDs, and malformed rows fail as typed outcomes.

The fixture `fixtures/hxrust/persisted-thread-read-view.v1.json` and `harness/check-persisted-thread-read-view.sh` prove the slice through interpreter simulation, native adapter setup, and metal generated Rust. This is not full app-server `thread/read` parity; live `ThreadState`, rollout item rebuilding, and production state-file ownership remain later slices. The boundary is documented in `docs/persisted-thread-read-view.md`.

## Thread/Read Turn Projection

`codexhx.runtime.app.threadread.ThreadReadTurnProjection` is the HXCX-4.17 raw upstream thread/read projection slice:

- `RolloutSummaryItemKind`, `ThreadReadTurnStatus`, and `ThreadReadTurnItemKind` keep selected rollout and projected turn state typed.
- explicit `turn_started`/`turn_complete` boundaries project named turns;
- legacy histories without explicit boundaries group user messages and following agent/tool items into deterministic implicit `rollout-N` turns;
- user, assistant, command execution, and compaction summaries are preserved as typed projected items;
- malformed item kinds, missing turn IDs, and missing renderable text fail closed through typed outcomes.

The fixture `fixtures/hxrust/thread-read-turn-projection.v1.json` and `harness/check-thread-read-turn-projection.sh` prove the slice through the Haxe interpreter and portable haxe.rust-generated Rust. This is not full rollout parsing, pagination, live `ThreadState` merge, or production state-file ownership. The boundary is documented in `docs/thread-read-turn-projection.md`.

## Thread/Read Turns Page

`codexhx.runtime.app.threadread.ThreadReadTurnsPager` is the HXCX-4.18 raw upstream `thread/turns/list` pagination slice:

- `ThreadReadTurnsPageRequest` uses typed `ThreadId`, cursor, limit, sort direction, and item-view values.
- `ThreadReadTurnsCursor` encodes and decodes upstream-shaped opaque cursor JSON with `turnId` and `includeAnchor`.
- desc and asc paging both preserve upstream anchor inclusion rules.
- `notLoaded`, `summary`, and `full` item views project selected turn summaries before pagination results are returned.
- malformed cursor JSON and missing cursor anchors fail closed through typed outcomes.

The fixture `fixtures/hxrust/thread-read-turns-page.v1.json` and `harness/check-thread-read-turns-page.sh` prove the slice through the Haxe interpreter and portable haxe.rust-generated Rust. This is not `thread/turns/items/list` runtime support, full `Turn` reconstruction, live active-turn merge, rollout file reads, or production state ownership. The boundary is documented in `docs/thread-read-turns-page.md`.

## Thread/Read Active-Turn Merge

`codexhx.runtime.app.threadread.ThreadReadActiveTurnMerger` is the HXCX-4.19 raw upstream active-turn merge/status normalization slice:

- `ThreadReadThreadStatus` models the selected `notLoaded`, `idle`, `systemError`, and `active` thread statuses.
- live in-progress turns can promote `idle`/`notLoaded` status to `active`, matching upstream listener timing semantics.
- stale reconstructed `inProgress` turns become `interrupted` when the resolved thread status is not active.
- a live active-turn snapshot replaces any history turn with the same ID and is appended as the newest turn.
- missing active snapshots and invalid loaded status values produce deterministic outcomes.

The fixture `fixtures/hxrust/thread-read-active-turn-merge.v1.json` and `harness/check-thread-read-active-turn-merge.sh` prove the slice through the Haxe interpreter and portable haxe.rust-generated Rust. This is not live `ThreadState` ownership, watch-manager integration, rollout storage, or production state ownership. The boundary is documented in `docs/thread-read-active-turn-merge.md`.

## Thread/Turns Items List Runtime Boundary

`codexhx.runtime.app.threadread.ThreadReadTurnItemsListRuntime` is the HXCX-4.20 raw upstream `thread/turns/items/list` runtime boundary:

- `ThreadReadTurnItemsListRequest` uses typed `ThreadId`, `TurnId`, cursor, limit, and sort direction.
- valid params return the upstream-shaped unsupported method outcome: `thread/turns/items/list is not supported yet`.
- invalid thread IDs, empty turn IDs, malformed cursors, malformed limits, and invalid sort directions fail before the unsupported runtime boundary.

The fixture `fixtures/hxrust/thread-read-turn-items-list-runtime.v1.json` and `harness/check-thread-read-turn-items-list.sh` prove the boundary through the Haxe interpreter and portable haxe.rust-generated Rust. This does not implement item pagination or full `ThreadItem` page reconstruction; it records the current upstream runtime contract. The boundary is documented in `docs/thread-read-turn-items-list-runtime.md`.

## Thread/Read Token Usage Owner

`codexhx.runtime.app.threadread.ThreadReadTokenUsageOwnerResolver` is the HXCX-4.21 raw upstream token-usage replay owner slice:

- `ThreadReadTokenUsageTurnOwnerHint` captures the rollout active-turn snapshot id and optional rebuilt position before a token-count record.
- explicit owner ids win when they still appear in reconstructed turns.
- rebuilt position selects the corresponding turn when generated/implicit ids changed during reconstruction.
- missing rollout owner information falls back to the latest completed or failed turn, then the latest turn.
- empty reconstructed histories fail closed before emitting an unusable owner id.

The fixture `fixtures/hxrust/thread-read-token-usage-owner.v1.json` and `harness/check-thread-read-token-usage-owner.sh` prove the boundary through the Haxe interpreter and portable haxe.rust-generated Rust. This does not implement token accounting, usage aggregation, notification emission, rollout file parsing, or production state ownership. The boundary is documented in `docs/thread-read-token-usage-owner.md`.

## Thread/Read Token Usage Replay Payload

`codexhx.runtime.app.threadread.ThreadReadTokenUsageReplayBuilder` is the HXCX-4.22 raw upstream restored usage payload slice:

- `ThreadReadTokenUsageBreakdown` and `ThreadReadTokenUsageInfo` preserve upstream `ThreadTokenUsage` and `TokenUsageBreakdown` field names and nullability.
- `ThreadReadTokenUsageReplayNotification` represents `thread/tokenUsage/updated` with thread id, owner turn id, and token usage.
- missing token usage, unresolved owner turns, invalid thread IDs, and negative counters fail before notification construction.
- emitted notifications expose deterministic summaries and JSON-shaped payload text for fixture checks.

The fixture `fixtures/hxrust/thread-read-token-usage-replay.v1.json` and `harness/check-thread-read-token-usage-replay.sh` prove the boundary through the Haxe interpreter and portable haxe.rust-generated Rust. This does not fetch usage from a live `CodexThread`, emit over JSON-RPC, aggregate accounting state, parse rollout files, or own production state. The boundary is documented in `docs/thread-read-token-usage-replay.md`.

## TUI Story Replay

`codexhx.runtime.tui.TuiStoryReplayParser` is the HXCX-4.8 story oracle slice. It parses the codexhx-owned selected fixture `fixtures/upstream/oss-story-selected.v1.jsonl`, derived from upstream raw Codex `../codex/codex-rs/tui/tests/fixtures/oss-story.jsonl`, into typed replay records:

- `TuiStoryDirection` and `TuiStoryKind` classify meta, app-event, key-event, codex-event, insert-history, and operation records.
- `TuiStoryKeyEvent` extracts code/modifier/press kind from upstream crossterm debug strings and accumulates typed user input.
- `CodexStoryMessageType` covers the selected upstream Codex event subset: session configured, task started, reasoning delta, assistant delta, task complete, and shutdown complete.
- `TuiStoryReplaySummary` normalizes volatile timestamp, cwd, model, session id, and event id noise into a stable replay fingerprint.

This is replay evidence, not terminal rendering ownership. HXCX-4.9 owns VT100/history/render invariants, and HXCX-4.10 owns turn runtime reducer invariants.

## TUI Render Invariants

`codexhx.runtime.tui.render` is the HXCX-4.9 deterministic render slice. It adapts selected upstream invariants from `vt100_history`, `vt100_live_commit`, and `status_indicator` into pure Haxe state:

- `TuiAnsiSanitizer` strips ANSI escape sequences before text reaches the string backend.
- `TuiGlyphScanner` assigns selected display widths for the upstream emoji/CJK fixture and keeps the logic portable.
- `TuiRowBuilder` wraps words without splitting them when the word fits, hard-wraps long tokens only when required, and drains commit-ready live rows.
- `TuiHistoryBuffer` models deterministic history insertion and cursor restoration for the selected string backend.

The fixture `fixtures/upstream/vt100-render-selected.v1.json` and `harness/check-tui-render.sh` prove these invariants through both Haxe interpreter and haxe.rust-generated Rust. This still does not claim full ratatui/crossterm ownership; those crates remain a later metal/native boundary for the interactive TUI.

## Turn Runtime Reducers

`codexhx.runtime.tui.turn` is the HXCX-4.10 pure-state turn runtime slice. It lifts selected upstream `ChatWidget`/`turn_runtime.rs` lifecycle behavior into typed Haxe reducers:

- `TurnRuntimeAction` represents task start/complete/fail/cancel, assistant deltas/final items, plan deltas/final plans, queued follow-ups, and queued steers.
- `TurnRuntimeState` records running/terminal status, assistant final source, notification text, plan consolidation, queued follow-up/steer bookkeeping, and terminal failure/cancel messages.
- `TurnRuntimeReducer` preserves the upstream distinction between item-level copy source and completion notification text: item-level final markdown remains the copied transcript source, while a non-empty completion message may still be used for notification text.
- Live completions clear the plan prompt flag; replayed completions keep it so a later live completion can prompt once.
- Completion starts at most one queued follow-up and suppresses the completion notification when it does. Active goal continuations also suppress completion notification.

The fixture `fixtures/upstream/turn-runtime-selected.v1.json` and `harness/check-turn-runtime-reducer.sh` prove the reducer through both Haxe interpreter and haxe.rust-generated Rust. This is still not live terminal or app-server ownership; it is the deterministic state core that later transport and TUI surfaces can consume.

HXCX-4.10 also exposed generic haxe.rust issue `haxe.rust-fzl`: reusing a non-copy local `String` as multiple conditional expression results can generate Rust move-after-move errors. The reducer uses explicit Haxe string slices as semantic copies while the compiler issue is tracked upstream as product-neutral clone-insertion work.
