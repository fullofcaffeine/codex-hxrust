# HXCX-4.43 Raw Codex Provider Admission Boundary

This slice models the credential and provider-selection admission boundary before live model traffic. It is intentionally credential-free: fixtures prove classification, redaction, and denial behavior without reading real environment variables, auth files, or network endpoints.

Selected upstream references:

- `../codex/codex-rs/model-provider-info/src/lib.rs:85` defines `ModelProviderInfo`, including `env_key`, `requires_openai_auth`, AWS auth, command auth, and websocket capability metadata.
- `../codex/codex-rs/model-provider-info/src/lib.rs:150` rejects incompatible provider auth shapes such as AWS combined with `requires_openai_auth`.
- `../codex/codex-rs/model-provider-info/src/lib.rs:275` reads provider-specific API keys from the configured environment variable and errors when missing.
- `../codex/codex-rs/login/src/auth_env_telemetry.rs:31` buckets provider env-key telemetry as configured/present without leaking the configured key name or secret value.
- `../codex/codex-rs/model-provider/src/auth.rs:52` allows unauthenticated providers for local OSS/custom test providers.
- `../codex/codex-rs/model-provider/src/auth.rs:78` resolves provider env keys, experimental bearer tokens, first-party auth, or unauthenticated auth.
- `../codex/codex-rs/model-provider/src/provider.rs:170` builds the runtime provider from configured provider metadata.
- `../codex/codex-rs/model-provider/src/provider.rs:222` derives app-visible account state from provider auth requirements.
- `../codex/codex-rs/app-server/src/request_processors/account_processor.rs:748` reports auth status based on the active model provider.
- `../codex/codex-rs/cli/src/main.rs:1661` gates remote/live auth provider setup and rejects unsupported live API-key destinations.

The Haxe facade uses typed DTOs:

- `ProviderAdmissionProvider` mirrors selected provider metadata and auth-shape validation.
- `ProviderAdmissionModel` ties a model to its provider id.
- `ProviderAdmissionCredentialKind`, `ProviderAdmissionAccountKind`, and `ProviderAdmissionNetworkKind` avoid raw string control flow at the policy boundary.
- `ProviderAdmissionPolicy` admits or refuses fixture-only provider use, missing auth, provider-env auth, AWS auth, provider/model mismatch, and disabled live-network attempts.
- `ProviderAdmissionOutcome` exposes only buckets such as `present`, `configured`, or `none`; secret fixture probes must never appear in summaries.

The fixture `fixtures/hxrust/provider-admission.v1.json` covers no-credential local provider admission, missing OpenAI auth refusal, redacted API-key admission, redacted provider-env admission, provider/model mismatch, disabled live-network refusal, missing provider env key, AWS Bedrock account admission, and AWS auth-shape conflict.

Run:

```bash
bash harness/check-provider-admission.sh
```

This is provider admission evidence only. It does not perform live model requests, read real credentials, own refresh-token flows, implement model catalogs, run websockets/realtime, or claim production provider parity.
