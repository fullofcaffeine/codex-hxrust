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

Unsupported commands fail closed with `unsupported_command`. The adapter remains credential-free and fixture-backed; it is not a live app-server transport, and it should stay a thin protocol adapter over the pure runtime state machine.
