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

- request params/responses for `thread/start`, `thread/resume`, `thread/fork`, `thread/archive`, `thread/unarchive`, `thread/unsubscribe`, `thread/name/set`, `thread/goal/set`, `thread/goal/get`, `thread/goal/clear`, `thread/metadata/update`, `thread/compact/start`, `thread/shellCommand`, `thread/approveGuardianDeniedAction`, `thread/rollback`, `thread/inject_items`, `thread/list`, `thread/loaded/list`, `turn/start`, `turn/steer`, `turn/interrupt`, `review/start`, `thread/read`, `windowsSandbox/setupStart`, `windowsSandbox/readiness`, `account/login/start`, `account/login/cancel`, `account/logout`, `account/read`, `account/rateLimits/read`, `account/usage/read`, `account/sendAddCreditsNudgeEmail`, `feedback/upload`, `command/exec`, `command/exec/write`, `command/exec/terminate`, `command/exec/resize`, `config/read`, `config/value/write`, `config/batchWrite`, `configRequirements/read`, `externalAgentConfig/detect`, `externalAgentConfig/import`, apps/skills/hooks, marketplace/plugin/share, filesystem, model/capability/feature/profile, and MCP OAuth/status/resource/tool request families
- client-directed server request params/responses for `item/commandExecution/requestApproval`, `item/fileChange/requestApproval`, `item/permissions/requestApproval`, `item/tool/requestUserInput`, `mcpServer/elicitation/request`, `item/tool/call`, `account/chatgptAuthTokens/refresh`, and `attestation/generate`
- `process/spawn`, `process/writeStdin`, `process/kill`, and `process/resizePty` are tracked from upstream Rust DTO/protocol source because upstream currently does not emit standalone v2 request/response schema files for these experimental process methods; the fingerprint report records this as an explicit gap while process notification schemas remain selected
- `thread/increment_elicitation`, `thread/decrement_elicitation`, `thread/settings/update`, `thread/memoryMode/set`, `memory/reset`, and `thread/backgroundTerminals/clean` are tracked from upstream Rust DTO/protocol source because the pinned upstream schema export does not currently emit standalone v2 request/response schema files for these experimental thread state methods
- `thread/turns/list` and `thread/turns/items/list` are tracked from upstream Rust DTO/protocol source because the pinned upstream schema export does not currently emit standalone v2 request/response schema files for these experimental pagination methods
- notifications for `thread/started`, `thread/status/changed`, `thread/archived`, `thread/unarchived`, `thread/closed`, `thread/name/updated`, `thread/goal/updated`, `thread/goal/cleared`, `thread/settings/updated`, `thread/tokenUsage/updated`, `thread/compacted`, `turn/started`, `turn/completed`, `turn/plan/updated`, `turn/moderationMetadata`, `item/started`, `item/agentMessage/delta`, `item/plan/delta`, `item/reasoning/summaryTextDelta`, `item/reasoning/summaryPartAdded`, `item/reasoning/textDelta`, `item/commandExecution/outputDelta`, `item/commandExecution/terminalInteraction`, `item/fileChange/outputDelta`, `item/fileChange/patchUpdated`, `item/mcpToolCall/progress`, `mcpServer/oauthLogin/completed`, `mcpServer/startupStatus/updated`, `account/updated`, `account/login/completed`, `account/rateLimits/updated`, `app/list/updated`, `remoteControl/status/changed`, `model/rerouted`, `model/verification`, `warning`, `guardianWarning`, `deprecationNotice`, `configWarning`, `fuzzyFileSearch/sessionUpdated`, `fuzzyFileSearch/sessionCompleted`, `thread/realtime/started`, `thread/realtime/itemAdded`, `thread/realtime/transcript/delta`, `thread/realtime/transcript/done`, `thread/realtime/outputAudio/delta`, `thread/realtime/sdp`, `thread/realtime/error`, `thread/realtime/closed`, `windows/worldWritableWarning`, `windowsSandbox/setupCompleted`, `externalAgentConfig/import/completed`, `fs/changed`, `item/completed`, `rawResponseItem/completed`, `serverRequest/resolved`, `command/exec/outputDelta`, `process/outputDelta`, `process/exited`, and `error`
- `JSONRPCError`

`rawResponseItem/completed` is tracked through its standalone v2 schema file because upstream excludes that server notification from the combined JSON export.

`fuzzyFileSearch/sessionUpdated` and `fuzzyFileSearch/sessionCompleted` are tracked through the top-level schema files because upstream currently exports those session notifications outside the `v2/` directory. The paired fuzzy session request DTOs are selected from upstream Rust DTO/protocol source because standalone request/response schema files are not emitted for them. Legacy `fuzzyFileSearch` params/response schemas are also tracked through top-level schema files.

Deprecated v1 `getConversationSummary`, `gitDiffToRemote`, and `getAuthStatus` are tracked from upstream Rust DTO/protocol source because the pinned schema export does not emit standalone request/response schema files for those compatibility surfaces. `initialize` is tracked by HXCX-4.11 runtime bootstrap and remains outside the normal app protocol fingerprint.

Realtime notification schemas are tracked through standalone v2 schema files. The paired realtime client control request DTOs are selected from upstream Rust DTO/protocol source because standalone request/response schema files are not emitted for `thread/realtime/start`, `thread/realtime/appendAudio`, `thread/realtime/appendText`, `thread/realtime/stop`, or `thread/realtime/listVoices`.

Remote-control status notification schemas are tracked through standalone v2 schema files. The paired remote-control request/response DTOs are selected from upstream Rust DTO/protocol source because standalone request/response schema files are not emitted for `remoteControl/enable`, `remoteControl/disable`, `remoteControl/status/read`, `remoteControl/pairing/start`, `remoteControl/pairing/status`, `remoteControl/client/list`, or `remoteControl/client/revoke`.

`environment/add`, `collaborationMode/list`, and `thread/search` are selected from upstream Rust DTO/protocol source because the pinned export does not currently emit standalone v2 request/response schema files for those methods. `mock/experimentalMethod` remains outside the production subset because it is an upstream experimental test-only method.

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
