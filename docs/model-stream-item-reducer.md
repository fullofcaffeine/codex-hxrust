# Stream Item Reducer And Assistant Output Routing

**Bead:** HXCX-4.48 / `codex-hxrust-19q`; HXCX-4.50 / `codex-hxrust-9rq`
**Scope:** raw upstream Codex first; no live network, no real credentials, no live async ownership, no Cafex/Cafetera behavior.

## Upstream References

Read-only upstream reference: `../codex`.

- `../codex/codex-rs/core/src/stream_events_utils.rs:405` handles completed output items.
- `../codex/codex-rs/core/src/stream_events_utils.rs:413` classifies model-emitted tool calls through `ToolRouter`.
- `../codex/codex-rs/core/src/stream_events_utils.rs:445` converts non-tool messages/reasoning into completed turn items.
- `../codex/codex-rs/core/src/stream_events_utils.rs:517` handles non-tool response items.
- `../codex/codex-rs/core/src/stream_events_utils.rs:555` finalizes assistant messages and strips hidden assistant markup.
- `../codex/codex-rs/core/src/session/turn.rs:1951` handles `OutputItemAdded` active-item setup and streamed item starts.
- `../codex/codex-rs/core/src/session/turn.rs:2062` handles terminal `Completed` outcomes and follow-up decisions.
- `../codex/codex-rs/core/src/session/turn.rs:2086` routes assistant output text deltas.
- `../codex/codex-rs/core/src/session/turn.rs:2118` routes `ToolCallInputDelta` by active custom tool `call_id` and ignores mismatches.
- `../codex/codex-rs/core/src/session/turn.rs:2136` routes reasoning summary deltas.
- `../codex/codex-rs/core/src/session/turn.rs:2172` routes raw reasoning content deltas.
- `../codex/codex-rs/core/src/tools/registry.rs:150` defines the runtime-neutral `ToolArgumentDiffConsumer` contract.
- `../codex/codex-rs/core/src/tools/handlers/apply_patch.rs:78` consumes streamed apply-patch argument diffs into protocol events.
- `../codex/codex-rs/core/tests/suite/apply_patch_cli.rs:1187` covers `response.custom_tool_call_input.delta` apply-patch streaming.
- `../codex/codex-rs/core/tests/suite/items.rs:1088` covers reasoning summary delta item metadata.
- `../codex/codex-rs/core/tests/suite/items.rs:1138` covers raw reasoning delta behavior.
- `../codex/codex-rs/core/tests/common/responses.rs:703` defines output text delta fixtures.
- `../codex/codex-rs/core/tests/common/responses.rs:710` defines reasoning item fixtures.
- `../codex/codex-rs/core/tests/common/responses.rs:815` defines function-call output-item fixtures.
- `../codex/codex-rs/core/tests/common/responses.rs:857` defines custom-tool-call output-item fixtures.

## Local Boundary

`codexhx.runtime.model.streamitem` composes HXCX-4.43 provider admission, HXCX-4.44 catalog selection, HXCX-4.45 turn model/tool planning, HXCX-4.46 request envelopes, and HXCX-4.47 stream routes before reducing selected item events:

- `ModelStreamOutputItemKind` is a typed item kind enum abstract for assistant message, reasoning, function/custom tool call, web search, image generation, tool output, and unknown items.
- `ModelStreamItemEventKind` represents selected `ResponseEvent` item-added, item-done, output text delta, tool-call input delta, reasoning summary delta, reasoning raw-content delta, and completion events.
- `ModelStreamRuntimeEventKind` captures the runtime-facing item started/completed, assistant delta, reasoning delta, raw reasoning delta, tool-call input delta, ignored tool-call input delta, tool-call queued, stream completed, route denied, and reducer error outcomes.
- `ModelStreamActiveToolCall`, `ModelStreamToolInputDelta`, and `ModelStreamToolInputDeltaStatus` keep active custom tool-call state, accepted diffs, no-active-consumer ignores, and call-id mismatch ignores typed instead of stringly.
- `ModelStreamItemReducerPolicy` maintains active item/tool metadata, emits deltas against that item or call id, strips selected hidden assistant markup at completion, accumulates accepted custom tool input when the completed item omits it, and queues tool calls for follow-up without executing them.

The fixture `fixtures/hxrust/model-stream-item-reducer.v1.json` covers OpenAI assistant text deltas and completion, OpenAI reasoning summary/raw deltas, OpenAI custom tool input delta routing and mismatch ignores, Bedrock function delta ignored without a custom diff consumer, Bedrock function tool call follow-up routing, Responses Lite custom tool-call input accumulation, inherited local envelope refusal, no live traffic, no tool execution, and secret-free summaries.

## Non-Goals

This is not live SSE parsing, WebSocket ownership, Tokio task ownership, tool execution, apply-patch hunk parsing, plan-mode proposed-plan item extraction, provider auth refresh, unauthorized retry handling, inference trace persistence, realtime/audio transport, or interactive TUI implementation.

## Gate

Run:

```bash
bash harness/check-model-stream-item-reducer.sh
```

The gate runs Haxe interpreter validation, haxe.rust portable generation, generated `cargo check --locked`, generated `cargo test --locked`, and the generated binary.
