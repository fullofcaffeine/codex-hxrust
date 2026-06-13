# HXCX-4.44 Raw Codex Model Catalog And Provider Capabilities Boundary

This slice models deterministic model catalog selection after provider admission. It stays credential-free: fixtures prove static catalog filtering, provider capability upper bounds, model visibility, auth-mode filtering, and live-refresh refusal without calling `/models`, reading real credentials, or depending on Cafex.

Selected upstream references:

- `../codex/codex-rs/model-provider/src/provider.rs:21` defines provider-owned capability upper bounds: namespace tools, image generation, and web search.
- `../codex/codex-rs/model-provider/src/provider.rs:95` gives configured OpenAI-compatible providers the default capability set.
- `../codex/codex-rs/model-provider/src/provider.rs:261` chooses a static model manager when a config catalog is present and an OpenAI-backed manager otherwise.
- `../codex/codex-rs/model-provider/src/amazon_bedrock/mod.rs:59` disables Bedrock image generation and web search while preserving namespace tools.
- `../codex/codex-rs/model-provider/src/amazon_bedrock/mod.rs:108` always uses a static Bedrock model manager.
- `../codex/codex-rs/model-provider/src/amazon_bedrock/catalog.rs:11` builds the selected static Bedrock catalog.
- `../codex/codex-rs/model-provider/src/amazon_bedrock/catalog.rs:28` strips non-default service tier metadata for Bedrock models.
- `../codex/codex-rs/models-manager/src/manager.rs:76` defines the model manager boundary.
- `../codex/codex-rs/models-manager/src/manager.rs:108` sorts models, filters by auth mode, and marks picker defaults.
- `../codex/codex-rs/app-server/src/models.rs:12` applies the app-server `include_hidden` model list filter.
- `../codex/codex-rs/protocol/src/openai_models.rs:196` defines app-visible `ModelPreset`.
- `../codex/codex-rs/protocol/src/openai_models.rs:348` defines selected `ModelInfo` catalog metadata.
- `../codex/codex-rs/protocol/src/openai_models.rs:611` filters presets by ChatGPT/backend versus API-supported auth mode.

The Haxe facade uses typed DTOs:

- `ModelCatalogEntry` carries selected `ModelInfo` fields: slug, provider id, priority, visibility, API support, context windows, search/image/tool metadata, modalities, and tiers.
- `ModelCatalogVisibility`, `ModelCatalogRefreshStrategy`, `ModelCatalogToolMode`, and `ModelCatalogWebSearchToolType` avoid raw string control flow at the policy boundary.
- `ModelProviderCapabilities` mirrors the selected provider capability upper bound and applies the Bedrock override.
- `ModelCatalogPolicy` composes with `ProviderAdmissionPolicy` before any catalog result is admitted.
- `ModelCatalogOutcome` reports counts, selected/default model ids, capability summaries, and denial codes without exposing credential probes.

The fixture `fixtures/hxrust/model-catalog.v1.json` covers OpenAI static catalog selection, API-key-mode filtering of ChatGPT-only models, hidden model refusal, Bedrock hosted-tool capability suppression, local no-credential catalog admission, unsupported model refusal, disabled live model refresh, and provider admission failure composition.

Run:

```bash
bash harness/check-model-catalog.sh
```

This is catalog/capability evidence only. It does not perform live `/models` requests, persist model caches, refresh ETags, own websocket/realtime behavior, execute provider calls, or model Cafex/Cafetera behavior.
