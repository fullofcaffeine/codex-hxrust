# Config/Profile Lowering Subset

This is the first upstream-Codex-oriented DTO slice for the pure Haxe port. Cafex/Cafetera-specific fields are treated as unsupported diagnostics until the adapter layer is introduced.

## Supported Profile Fields

- `schema`: optional marker, defaulting to `codex-hxrust.config-profile.v1`
- `profileName`: required Codex profile identifier; ASCII letters, digits, `_`, and `-`
- `model`: required model id
- `modelProviderId`: optional provider id, defaulting to `openai`
- `reasoningEffort`: optional Codex reasoning effort, defaulting to `medium`
- `approvalPolicy`: required Codex wire value: `untrusted`, `on-failure`, `on-request`, `granular`, or `never`
- `sandboxMode`: required Codex wire value: `danger-full-access`, `read-only`, `external-sandbox`, or `workspace-write`
- `webSearchEnabled`: optional boolean, defaulting to `false`
- `imageGenerationEnabled`: optional boolean, defaulting to `false`
- `developerInstructions`: optional string, defaulting to empty
- `writableRoots`: optional string array, defaulting to empty

## Secrets

The parser records whether secret-like fields are present, but diagnostics must never echo raw values. The currently recognized top-level secret indicators are `apiKey`, `openaiApiKey`, `token`, and `secrets`.

## Unsupported Fields

Unknown top-level fields are listed in sorted order in `unsupportedFields`. They do not fail parsing in this subset because the headless mock runtime only needs a best-effort profile projection. Required upstream semantics still fail closed: invalid profile names, invalid approval policies, invalid sandbox modes, and missing required fields reject the profile.

## Fixture

The canonical HXCX-2.3 fixture is `fixtures/hxrust/config-profile-basic.v1.json`. It intentionally includes Cafex-oriented and unknown fields to verify that upstream-first DTO parsing preserves a clear adapter backlog without accepting those fields as implemented behavior.
