# Model Stream Event And Error Routing

**Bead:** HXCX-4.47 / `codex-hxrust-nu5`  
**Scope:** raw upstream Codex first; no live network, no real credentials, no Cafex/Cafetera behavior.

## Upstream References

Read-only upstream reference: `../codex`.

- `../codex/codex-rs/core/src/client.rs:1772` defines the dropped-stream refusal reason.
- `../codex/codex-rs/core/src/client.rs:1774` maps a provider stream into Codex stream events.
- `../codex/codex-rs/core/src/client.rs:1793` maps individual Responses events.
- `../codex/codex-rs/core/src/client.rs:1819` captures the last upstream model request id for feedback.
- `../codex/codex-rs/core/src/client.rs:1837` records completed output items as added stream items.
- `../codex/codex-rs/core/src/client.rs:1851` records completion telemetry, trace, and last response metadata.
- `../codex/codex-rs/core/src/client.rs:1887` maps API errors and can override request id from response debug context.
- `../codex/codex-rs/core/src/client.rs:1927` treats stream close before `response.completed` as an error.
- `../codex/codex-rs/core/src/client_tests.rs:347` covers dropped response stream cancellation.
- `../codex/codex-rs/core/src/client_tests.rs:393` covers request/response feedback IDs.
- `../codex/codex-rs/core/src/client_tests.rs:428` covers backpressured drop cancellation.

## Local Boundary

`codexhx.runtime.model.stream` composes HXCX-4.43 provider admission, HXCX-4.44 catalog selection, HXCX-4.45 turn model/tool planning, and HXCX-4.46 request-envelope routing before mapping fixture stream events:

- `ModelStreamFixtureEventKind` is a typed event kind enum abstract for created, output item done, completed, provider error, stream closed, and consumer dropped events.
- `ModelStreamRouteRequest` keeps the upstream request id and the request envelope request separate, so feedback IDs do not blur with local fixture IDs.
- `ModelStreamRoutePolicy` maps terminal completion, provider error, stream-close failure, consumer-drop cancellation, and denied-envelope refusal without live transport.
- `ModelStreamRouteOutcome` reports last model request id, last model response id, output items added, total token count, terminal booleans, live-network provenance, and a secret-free summary.

The fixture `fixtures/hxrust/model-stream-route.v1.json` covers OpenAI completion with feedback IDs, provider error request-id override, Bedrock stream close before completion, Responses Lite consumer-drop cancellation, inherited no-live WebSocket refusal, no live traffic, and secret-free summaries.

## Non-Goals

This is not a live `ModelClientSession::stream` implementation, SSE parser, WebSocket connection owner, Tokio task owner, unauthorized retry handler, provider auth refresher, inference trace persistence layer, realtime/audio transport, or interactive TUI implementation.

## Gate

Run:

```bash
bash harness/check-model-stream-route.sh
```

The gate runs Haxe interpreter validation, haxe.rust portable generation, generated `cargo check --locked`, generated `cargo test --locked`, and the generated binary.
