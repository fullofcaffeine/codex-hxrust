# Live Transport Boundary

**Bead:** `HXCX-4.12` / `codex-hxrust-m4c`

## Scope

The current transport proof is intentionally fixture-backed and credential-free. `FixtureLiveTransport` exercises the typed runtime facade end to end without opening websockets, unix sockets, control sockets, or reading credentials.

## Pure Haxe Surface

- request/response correlation through `InMemoryAppServerClient`;
- lossless notification delivery and deterministic event draining;
- pending request cancellation as a JSON-RPC cancellation error event;
- graceful disconnect as a terminal disconnected event;
- post-disconnect refusal with `transport_closed`.

These are portable Haxe semantics and should remain usable by tests, replay tools, and in-process adapters.

## Native Boundary

Real remote transport should be a generic haxe.rust/Rust-native wrapper around established Rust crates and upstream-shaped contracts:

- websocket and unix/control-socket connection lifecycle;
- `initialize`/`initialized` handshake timing;
- auth-header policy for `wss://` and loopback `ws://`;
- ping/pong and close-frame handling;
- async request waiter cancellation and duplicate request-id rejection;
- transport failure to disconnected-event mapping.

The wrapper must not contain codexhx-specific compiler code. If haxe.rust cannot express a required async/channel/socket pattern cleanly, file product-neutral haxe.rust work with a minimal fixture.
