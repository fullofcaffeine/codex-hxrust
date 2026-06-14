# Runtime-Neutral Async Contract

**Status:** implemented as HXCX-4.49 contract slice
**Bead:** `codex-hxrust-1ss`
**Scope:** live provider streams, app-server transport, cancellation, bounded queues, and TUI runtime work after deterministic raw stream reducer slices.

## Decision

Codexhx should not expose Tokio as the Haxe authoring model.

Tokio is the likely Rust backend for live provider streams, channels, cancellation tokens, timers, subprocess ownership, WebSockets, and app-server transport. But the Haxe code should depend on a small runtime-neutral async contract that can be implemented by:

- a deterministic fixture runner for tests;
- a haxe.rust metal/native Rust backend using Tokio;
- future non-Rust or alternate Rust runtimes without rewriting Codex-facing business logic.

## Upstream Pressure

Read-only upstream reference: `../codex`.

- `../codex/codex-rs/app-server-client/src/lib.rs:15` describes bounded async `mpsc` queues for overload behavior.
- `../codex/codex-rs/app-server-client/src/lib.rs:471` starts the in-process async client.
- `../codex/codex-rs/app-server-client/src/lib.rs:735` exposes async event consumption.
- `../codex/codex-rs/app-server-transport/src/transport/websocket.rs:37` imports Tokio networking/channel/task primitives and cancellation tokens.
- `../codex/codex-rs/app-server-transport/src/transport/websocket.rs:172` runs a websocket connection over async reader/writer streams.
- `../codex/codex-rs/tui/src/app.rs:192` uses Tokio select, mutexes, channels, and task handles for the interactive TUI runtime.
- `../codex/codex-rs/tui/src/app.rs:754` owns the async TUI run loop.

These are implementation facts, not Haxe API commitments. The Haxe surface must preserve the same concepts through typed tasks, streams, cancellation, and backpressure outcomes.

## Haxe Contract

The Haxe-facing contract lives under `codexhx.runtime.asyncruntime`:

- `AsyncTask<T>` exposes `poll(context)` and `cancel(reason)`.
- `AsyncStream<T>` exposes `pollNext(context)` and `cancel(reason)`.
- `AsyncPoll<T>` is the shared typed outcome envelope.
- `AsyncPollKind` is one of `pending`, `ready`, `failed`, `cancelled`, `closed`, or `backpressured`.
- `AsyncStreamItem<T>` carries a sequence number, delivery class, and typed value.
- `AsyncCancellationToken` records backend-neutral cancellation requests and reasons.
- `AsyncDeliveryKind` distinguishes lossless from best-effort stream items.

The Haxe-facing contract should model:

- pending, ready, failed, cancelled, and closed outcomes;
- cancellation tokens and cancellation reasons;
- bounded queue/backpressure behavior;
- lossless versus best-effort event delivery;
- deterministic fixture stepping;
- structured errors instead of panics or raw backend exceptions.

The deterministic proof backend is `DeterministicAsyncTask<T>` and `DeterministicAsyncStream<T>`. It does not spawn threads, sleep, open sockets, or call live providers. It gives later live slices a stable test backend for request/response, model stream, transport, and TUI event-loop code.

## Await Syntax

Haxe has no native `await`, and codexhx should not invent `@:await` as the core abstraction.

Macro sugar may be useful later:

```haxe
final event = @await stream.next();
```

That is acceptable only as optional syntax over the same typed task/stream contract. The runtime contract must remain usable without macro sugar, and it must not require Tokio-specific semantics in app code.

## Rust Backend

The Rust backend may map this contract to:

- Tokio tasks;
- `Stream`/`Future`-like poll behavior;
- bounded `mpsc` channels;
- cancellation tokens;
- timers and timeouts;
- native WebSocket/HTTP body streams.

That mapping belongs behind typed haxe.rust metal/native facades or generic haxe.rust runtime support. If codexhx exposes a compiler/runtime limitation while implementing this, reduce it to a generic haxe.rust issue and fixture in `../haxe.rust`; do not add Codex-specific lowering or runtime hooks.

Near-term live-provider/app-server work should split the code this way:

- portable Haxe owns DTOs, request/response envelopes, reducer state, fixture stepping, cancellation reasons, and error classification;
- metal/native haxe.rust owns Tokio runtime handles, socket/body streams, task spawning, timers, process handles, and channel internals;
- app code talks to the typed contract, not `tokio::task::JoinHandle`, `tokio::sync::mpsc`, `tokio_util::sync::CancellationToken`, or Rust `Future`/`Stream` objects directly.

## Current Roadmap Impact

HXCX-4.48 remains a deterministic reducer slice over selected upstream `stream_events_utils` and `ResponseEvent` behavior. It should not introduce live async ownership.

HXCX-4.49 owns the first runtime-neutral async contract design and deterministic fixture backend. Later live provider/runtime slices should depend on that contract before wiring Tokio-backed transports.

## Gate

Run:

```bash
bash harness/check-async-runtime-contract.sh
```

The gate runs Haxe interpreter validation, haxe.rust portable generation, generated `cargo check --locked`, generated `cargo test --locked`, and the generated binary.
