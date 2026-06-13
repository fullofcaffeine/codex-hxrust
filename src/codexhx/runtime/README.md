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

## TUI Story Replay

`codexhx.runtime.tui.TuiStoryReplayParser` is the HXCX-4.8 story oracle slice. It parses the codexhx-owned selected fixture `fixtures/upstream/oss-story-selected.v1.jsonl`, derived from upstream raw Codex `../codex/codex-rs/tui/tests/fixtures/oss-story.jsonl`, into typed replay records:

- `TuiStoryDirection` and `TuiStoryKind` classify meta, app-event, key-event, codex-event, insert-history, and operation records.
- `TuiStoryKeyEvent` extracts code/modifier/press kind from upstream crossterm debug strings and accumulates typed user input.
- `CodexStoryMessageType` covers the selected upstream Codex event subset: session configured, task started, reasoning delta, assistant delta, task complete, and shutdown complete.
- `TuiStoryReplaySummary` normalizes volatile timestamp, cwd, model, session id, and event id noise into a stable replay fingerprint.

This is replay evidence, not terminal rendering ownership. HXCX-4.9 owns VT100/history/render invariants next.
