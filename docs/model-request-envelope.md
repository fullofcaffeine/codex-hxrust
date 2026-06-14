# Model Request Envelope And Response Routing

**Bead:** HXCX-4.46 / `codex-hxrust-f01`  
**Scope:** raw upstream Codex first; no live network, no real credentials, no Cafex/Cafetera behavior.

## Upstream References

Read-only upstream reference: `../codex`.

- `../codex/codex-rs/core/src/client.rs:747` builds `ResponsesApiRequest` from prompt, tools, reasoning, service tier, stream flag, prompt cache key, and client metadata.
- `../codex/codex-rs/core/src/client.rs:784` always marks Responses requests as streamed.
- `../codex/codex-rs/core/src/client.rs:800` gates Responses-over-WebSocket by provider support and session fallback state.
- `../codex/codex-rs/core/src/client.rs:976` builds shared Responses options and headers.
- `../codex/codex-rs/core/src/client.rs:1225` streams over HTTP Responses API.
- `../codex/codex-rs/core/src/client.rs:1347` streams over Responses WebSocket.
- `../codex/codex-rs/core/src/client.rs:1608` chooses WebSocket first when available and falls back to HTTP.
- `../codex/codex-rs/core/src/tasks/regular.rs:39` starts regular turn execution before `run_turn`.
- `../codex/codex-rs/model-provider/src/provider.rs:91` defines provider capability and request-time auth/provider adaptation.
- `../codex/codex-rs/model-provider/src/amazon_bedrock/mod.rs:54` overrides Bedrock provider capabilities and runtime base-url/auth behavior.

## Local Boundary

`codexhx.runtime.model.request` composes HXCX-4.43 provider admission, HXCX-4.44 model catalog selection, and HXCX-4.45 turn model/tool planning before building a request envelope:

- `ModelRequestRouteIntent` distinguishes plan-only envelope construction from live HTTP or WebSocket route intent.
- `ModelRequestPromptEnvelope` carries selected prompt/request controls without model-visible prompt text.
- `ModelRequestEnvelopePolicy` refuses live routes in fixture mode before transport, refuses unsupported WebSocket routes, and refuses missing credential material for live routes.
- `ModelRequestEnvelope` records selected Responses request facts: model, provider, route, endpoint, stream flag, store flag, parallel-tool-call lowering, reasoning include behavior, text controls, service tier, prompt cache key, client metadata, compression, input count, and tool count.

The fixture `fixtures/hxrust/model-request-envelope.v1.json` covers OpenAI, Bedrock, and Responses Lite plan-only envelopes; WebSocket live-route refusal; inherited tool-planning refusal; no live traffic; and secret-free summaries.

## Non-Goals

This is not a live `ModelClientSession::stream` implementation, SSE parsing, WebSocket connection ownership, unauthorized retry handling, provider auth refresh, inference tracing persistence, realtime/audio transport, or interactive TUI ownership.

## Gate

Run:

```bash
bash harness/check-model-request-envelope.sh
```

The gate runs Haxe interpreter validation, haxe.rust portable generation, generated `cargo check --locked`, generated `cargo test --locked`, and the generated binary.
