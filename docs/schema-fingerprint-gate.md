# Schema Fingerprint Gate

**Date:** 2026-06-10  
**Bead:** `HXCX-2.5` / `codex-hxrust-qml.5`  
**Baseline:** mainstream Codex app-server protocol schemas from `../codex/codex-rs/app-server-protocol/schema/json`

## Purpose

The app-protocol Haxe subset has a local validator and fixture harness, but upstream Codex remains the schema source of truth. This gate recomputes fingerprints for the selected upstream schema files and compares them with the accepted golden at `reference/app-protocol-schema-fingerprints.v1.json`.

The gate fails if:

- a selected schema file disappears
- a selected schema hash changes
- a selected schema gains or loses top-level properties, required fields, or definitions
- the combined subset fingerprint changes without explicit acceptance

## Selected Schemas

The first M2 subset covers:

- request params/responses for `thread/start`, `turn/start`, `turn/interrupt`, and `thread/read`
- notifications for `thread/started`, `thread/status/changed`, `thread/compacted`, `turn/started`, `turn/completed`, `turn/plan/updated`, `turn/moderationMetadata`, `item/started`, `item/agentMessage/delta`, `item/plan/delta`, `item/reasoning/summaryTextDelta`, `item/reasoning/summaryPartAdded`, `item/reasoning/textDelta`, `item/commandExecution/outputDelta`, `item/commandExecution/terminalInteraction`, `item/fileChange/outputDelta`, `item/fileChange/patchUpdated`, `item/mcpToolCall/progress`, `mcpServer/oauthLogin/completed`, `mcpServer/startupStatus/updated`, `account/updated`, `account/rateLimits/updated`, `app/list/updated`, `remoteControl/status/changed`, `model/rerouted`, `model/verification`, `warning`, `guardianWarning`, `deprecationNotice`, `configWarning`, `fuzzyFileSearch/sessionUpdated`, `fuzzyFileSearch/sessionCompleted`, `thread/realtime/started`, `thread/realtime/itemAdded`, `thread/realtime/transcript/delta`, `externalAgentConfig/import/completed`, `fs/changed`, `item/completed`, `rawResponseItem/completed`, `serverRequest/resolved`, `command/exec/outputDelta`, `process/outputDelta`, `process/exited`, and `error`
- `JSONRPCError`

`rawResponseItem/completed` is tracked through its standalone v2 schema file because upstream excludes that server notification from the combined JSON export.

`fuzzyFileSearch/sessionUpdated` and `fuzzyFileSearch/sessionCompleted` are tracked through the top-level schema files because upstream currently exports those session notifications outside the `v2/` directory.

The script records both per-schema hashes and field labels such as `property:threadId`, `required:threadId`, and `definition:TurnError`. If a hash changes without field-set drift, the diff reports `changedFields: ["schema-content"]`.

## Commands

Normal validation:

```bash
harness/check-schema-fingerprints.sh
```

Accept a reviewed upstream drift:

```bash
ACCEPT_SCHEMA_FINGERPRINT=1 harness/check-schema-fingerprints.sh
```

The script writes transient reports under `generated/reports/`:

- `app-protocol-schema-fingerprints.actual.v1.json`
- `app-protocol-schema-diff.v1.json`

Generated reports are not committed by default. The accepted golden under `reference/` is committed.

## Cafex Status

Cafex/Cafetera schema and DTO fixtures are recorded as deferred in the report because HXCX-2.5 is still upstream-core work. Cafex adapter fixture diffs begin in M5 after the upstream-shaped Haxe core exists.
