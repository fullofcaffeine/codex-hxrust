# Runtime-Neutral Async Contract

**Status:** planned by HXCX-4.49  
**Scope:** live provider, app-server, transport, cancellation, and TUI runtime work after deterministic raw stream reducer slices.

## Decision

Codexhx should not expose Tokio as the Haxe authoring model.

Tokio is the likely Rust backend for live provider streams, channels, cancellation tokens, timers, subprocess ownership, WebSockets, and app-server transport. But the Haxe code should depend on a small runtime-neutral async contract that can be implemented by:

- a deterministic fixture runner for tests;
- a haxe.rust metal/native Rust backend using Tokio;
- future non-Rust or alternate Rust runtimes without rewriting Codex-facing business logic.

## Authoring Shape

The exact API will be defined by HXCX-4.49, but the intended shape is explicit and typed:

```haxe
interface AsyncTask<T> {
	function poll(context:AsyncContext):AsyncPoll<T>;
	function cancel():Void;
}

interface AsyncStream<T> {
	function pollNext(context:AsyncContext):AsyncPoll<AsyncStreamItem<T>>;
	function cancel():Void;
}
```

The Haxe-facing contract should model:

- pending, ready, failed, cancelled, and closed outcomes;
- cancellation tokens and cancellation reasons;
- bounded queue/backpressure behavior;
- lossless versus best-effort event delivery;
- deterministic fixture stepping;
- structured errors instead of panics or raw backend exceptions.

## Await Syntax

Haxe has no native `await`, and codexhx should not invent `@:await` as the core abstraction.

Macro sugar may be useful later:

```haxe
final event = @await stream.next();
```

That is acceptable only as optional syntax over the same typed task/stream contract. The runtime contract must remain usable without macro sugar, and it must not require Tokio-specific semantics in app code.

## Rust Backend

The Rust backend may map the contract to:

- Tokio tasks;
- `Stream`/`Future`-like poll behavior;
- bounded `mpsc` channels;
- cancellation tokens;
- timers and timeouts;
- native WebSocket/HTTP body streams.

That mapping belongs behind typed haxe.rust metal/native facades or generic haxe.rust runtime support. If codexhx exposes a compiler/runtime limitation while implementing this, reduce it to a generic haxe.rust issue and fixture in `../haxe.rust`; do not add Codex-specific lowering or runtime hooks.

## Current Roadmap Impact

HXCX-4.48 remains a deterministic reducer slice over selected upstream `stream_events_utils` and `ResponseEvent` behavior. It should not introduce live async ownership.

HXCX-4.49 owns the first runtime-neutral async contract design. Later live provider/runtime slices should depend on that contract before wiring Tokio-backed transports.
