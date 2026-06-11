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
