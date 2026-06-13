# Turn Model Selection And Tool-Capability Planning

**Bead:** HXCX-4.45 / `codex-hxrust-ckn`  
**Scope:** raw upstream Codex first; no Cafex/Cafetera behavior.

## Upstream References

Read-only upstream reference: `../codex`.

- `../codex/codex-rs/core/src/session/turn_context.rs:55` defines selected `TurnContext` fields, including `model_info`, `tool_mode`, `provider`, and `available_models`.
- `../codex/codex-rs/core/src/session/turn_context.rs:172` resolves model info and tool mode for a selected model.
- `../codex/codex-rs/core/src/session/turn_context.rs:455` builds the turn context from provider, available models, tool mode, and service-tier inputs.
- `../codex/codex-rs/core/src/tools/spec_plan.rs:220` filters namespace tools by visibility.
- `../codex/codex-rs/core/src/tools/spec_plan.rs:251` gates hosted web and image tools.
- `../codex/codex-rs/core/src/tools/spec_plan.rs:331` gates image-generation runtime availability.
- `../codex/codex-rs/core/src/tools/spec_plan.rs:416` applies code-mode-only filtering.
- `../codex/codex-rs/core/src/tools/spec_plan.rs:892` applies reserved/visible tool filtering and standalone tool suppression.
- `../codex/codex-rs/core/src/tools/hosted_spec.rs:14` constructs hosted image-generation and web-search tool specs.
- `../codex/codex-rs/tools/src/tool_spec.rs:17` names selected tool-spec variants.

## Local Boundary

`codexhx.runtime.model.planning` composes the HXCX-4.43 provider admission boundary with the HXCX-4.44 model catalog boundary, then models selected deterministic turn planning facts:

- `TurnModelFeatureFlags` records code mode, code-mode-only, standalone web search, hosted image generation, image-gen extension, and deferred tool availability.
- `TurnExtensionToolState` records whether standalone web/image namespace tools are visible.
- `TurnModelToolCapabilityKind` names the requested capability without raw string checks downstream of the fixture parser.
- `TurnModelCapabilityPlan` reports hosted web search, standalone web run, hosted image generation, standalone image generation, namespace tools, code-mode nested tools, and tool search.
- `TurnModelPlanPolicy` derives effective tool mode from model catalog metadata first, then feature fallback, and refuses unsupported requested capabilities.

The fixture `fixtures/hxrust/turn-model-plan.v1.json` covers OpenAI, Bedrock, and local/no-credential providers; direct, code-mode, and code-mode-only tool modes; hosted web/image planning; standalone web/image suppression; unsupported tool capability refusal; catalog refusal composition; and secret-free summaries.

## Non-Goals

This is not live provider traffic, `/models` refresh ownership, real tool execution, realtime/websocket behavior, interactive terminal ownership, or Cafex/Cafetera adapter behavior.

## Gate

Run:

```bash
bash harness/check-turn-model-plan.sh
```

The gate runs Haxe interpreter validation, haxe.rust portable generation, generated `cargo check --locked`, generated `cargo test --locked`, and the generated binary.
