# Thread/Read Token Usage Replay Delivery

**Bead:** `HXCX-4.23` / `codex-hxrust-ffo`
**Fixture:** `fixtures/hxrust/thread-read-token-usage-replay-delivery.v1.json`
**Gate:** `harness/check-thread-read-token-usage-replay-delivery.sh`

## Purpose

This slice models the selected upstream policy that decides whether a restored `thread/tokenUsage/updated` payload should be delivered after `thread/resume`, `thread/fork`, or loaded-thread resume.

The Haxe boundary starts after payload construction: it accepts an include-turns policy, a response-order marker, a requesting connection id, and an optional replay payload outcome. It returns a deterministic delivery, skip, or refusal outcome.

## Upstream Anchors

- `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:2636`
- `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:2679`
- `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:3393`
- `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:3395`
- `../codex/codex-rs/app-server/src/request_processors/thread_lifecycle.rs:578`
- `../codex/codex-rs/app-server/src/request_processors/thread_lifecycle.rs:668`
- `../codex/codex-rs/app-server/src/request_processors/token_usage_replay.rs:36`
- `../codex/codex-rs/app-server/src/outgoing_message.rs:558`
- `../codex/codex-rs/app-server/tests/suite/v2/thread_resume.rs:1567`
- `../codex/codex-rs/app-server/tests/suite/v2/thread_fork.rs:402`

## Boundary Shape

The Haxe facade lives in `codexhx.runtime.app.threadread`:

- `ThreadReadTokenUsageReplayDeliveryOperation` distinguishes resume, fork, and loaded resume policy rows.
- `ThreadReadTokenUsageReplayDeliveryRequest` carries include-turns, response-ready, connection id, and payload outcome inputs.
- `ThreadReadTokenUsageReplayDeliveryPolicy` applies the selected ordering, skip, and recipient rules.
- `ThreadReadTokenUsageReplayDeliveryOutcome` records response-before-notification ordering and connection-scoped recipient summaries.

## Selected Behavior

- `includeTurns=true` with a ready payload delivers after the response.
- `excludeTurns=true` skips replay without trying to deliver a payload.
- Missing usage or otherwise missing payload skips replay after the response.
- Delivery is connection-scoped: exactly one targeted connection and no broadcast.
- A delivery attempt before the response or without a requesting connection id fails closed.

## Non-Goals

- Opening sockets or writing JSON-RPC envelopes.
- Rebuilding turns or computing owner attribution.
- Constructing token-usage payload fields.
- Broadcasting historical usage to other subscribers.
- Cafex or Cafetera adapter behavior.

## haxe.rust Pressure

This slice exposed generic haxe.rust issue `haxe.rust-3f0g`: a same-class `static final` String read in the harness lowered to a missing crate-root static getter path. The local harness uses a helper function as a semantic Haxe workaround while the compiler fix belongs upstream. The final harness passes under the Haxe interpreter and portable haxe.rust-generated Rust with no raw Rust escapes.
