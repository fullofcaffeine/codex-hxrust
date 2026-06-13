# Protocol

Upstream Codex protocol and app-server DTO work starts here. Implemented app-server requests include `thread/start`, `thread/resume`, `thread/fork`, `thread/archive`, `thread/unarchive`, `thread/unsubscribe`, thread state/history mutations (`thread/increment_elicitation`, `thread/decrement_elicitation`, `thread/name/set`, `thread/goal/*`, `thread/metadata/update`, `thread/settings/update`, `thread/memoryMode/set`, `memory/reset`, `thread/compact/start`, `thread/shellCommand`, `thread/approveGuardianDeniedAction`, `thread/backgroundTerminals/clean`, `thread/rollback`, and `thread/inject_items`), turn continuation/review/history (`turn/steer`, `review/start`, `thread/turns/list`, and `thread/turns/items/list`), `thread/list`, `thread/loaded/list`, `turn/start`, `turn/interrupt`, `thread/read`, Windows sandbox setup/readiness, account login/read/logout/usage/rate-limit requests, feedback upload, standalone `command/exec` plus control requests, experimental host `process/spawn`, `process/writeStdin`, `process/kill`, and `process/resizePty`, `config/read`, `config/value/write`, `config/batchWrite`, `configRequirements/read`, `externalAgentConfig/detect`/`import`, app/skill/hook/plugin/marketplace requests, filesystem read/write/metadata/watch requests, model/capability/experimental-feature/permission-profile requests, and MCP OAuth/status/resource/tool requests. Implemented client-directed server requests include approval, tool input/call, MCP elicitation, ChatGPT auth-token refresh, and attestation generation surfaces from upstream `ServerRequest`.

First inputs:

- `../../../reference/fixture-sources.v1.json`
- `../../../../codex/codex-rs/app-server-protocol/schema/json`
- `../../../../codex/codex-rs/protocol/src`

Cafex DTOs do not live here unless they become upstream-compatible core concepts.

Implemented G2.1 ID/newtype slice:

- `SessionId` and `ThreadId` are UUID-string wrappers following upstream Codex's serde shape.
- `TurnId`, `ToolCallId`, `ModelId`, and `PathLikeId` are non-empty string wrappers for fields that upstream currently models as `String`.
- `RequestId` preserves JSON-RPC/MCP's string-or-integer scalar shape.
- `fromString(...)` returns `Null<T>` for invalid values without throwing or using broad `Dynamic`.

Run:

```bash
harness/check-protocol-ids.sh
```

Implemented G2.2 JSON boundary slice:

- `json/CodexJson.hx` parses through `haxe.Json.parseValue` and exposes typed field helpers.
- `json/SerdeBridge.hx` is the facade for haxe.rust's serde/hxrt JSON boundary.
- Unknown fields are ignored by default but reportable through `unknownFields(...)`.
- Error mapping is deterministic through `JsonError`.

Run:

```bash
harness/check-json-boundary.sh
```

Implemented G2.4 app-server protocol subset:

- Requests: `thread/start`, `thread/resume`, `thread/fork`, `thread/archive`, `thread/unarchive`, `thread/unsubscribe`, `thread/increment_elicitation`, `thread/decrement_elicitation`, `thread/name/set`, `thread/goal/set`, `thread/goal/get`, `thread/goal/clear`, `thread/metadata/update`, `thread/settings/update`, `thread/memoryMode/set`, `memory/reset`, `thread/compact/start`, `thread/shellCommand`, `thread/approveGuardianDeniedAction`, `thread/backgroundTerminals/clean`, `thread/rollback`, `thread/inject_items`, `thread/turns/list`, `thread/turns/items/list`, `thread/list`, `thread/search`, `thread/loaded/list`, `fuzzyFileSearch/sessionStart`, `fuzzyFileSearch/sessionUpdate`, `fuzzyFileSearch/sessionStop`, `turn/start`, `turn/steer`, `turn/interrupt`, `review/start`, `thread/read`, `windowsSandbox/setupStart`, `windowsSandbox/readiness`, `account/login/start`, `account/login/cancel`, `account/logout`, `account/read`, `account/rateLimits/read`, `account/usage/read`, `account/sendAddCreditsNudgeEmail`, `feedback/upload`, `command/exec`, `command/exec/write`, `command/exec/terminate`, `command/exec/resize`, `process/spawn`, `process/writeStdin`, `process/kill`, `process/resizePty`, `config/read`, `config/value/write`, `config/batchWrite`, `configRequirements/read`, `environment/add`, `collaborationMode/list`, `externalAgentConfig/detect`, `externalAgentConfig/import`, `app/list`, `skills/list`, `skills/extraRoots/set`, `skills/config/write`, `hooks/list`, `marketplace/add`, `marketplace/remove`, `marketplace/upgrade`, `plugin/list`, `plugin/installed`, `plugin/read`, `plugin/skill/read`, `plugin/install`, `plugin/uninstall`, `plugin/share/save`, `plugin/share/updateTargets`, `plugin/share/list`, `plugin/share/checkout`, `plugin/share/delete`, `fs/readFile`, `fs/writeFile`, `fs/createDirectory`, `fs/getMetadata`, `fs/readDirectory`, `fs/remove`, `fs/copy`, `fs/watch`, `fs/unwatch`, `model/list`, `modelProvider/capabilities/read`, `experimentalFeature/list`, `experimentalFeature/enablement/set`, `permissionProfile/list`, `mcpServer/oauth/login`, `config/mcpServer/reload`, `mcpServerStatus/list`, `mcpServer/resource/read`, and `mcpServer/tool/call`.
- Server requests: `item/commandExecution/requestApproval`, `item/fileChange/requestApproval`, `item/permissions/requestApproval`, `item/tool/requestUserInput`, `mcpServer/elicitation/request`, `item/tool/call`, `account/chatgptAuthTokens/refresh`, and `attestation/generate`.
- Responses: thread, turn, interrupt-empty, and transcript-bearing read payloads.
- Notifications: `thread/started`, `thread/status/changed`, `thread/archived`, `thread/unarchived`, `thread/closed`, `thread/name/updated`, `thread/goal/updated`, `thread/goal/cleared`, `thread/settings/updated`, `thread/tokenUsage/updated`, `thread/compacted`, `turn/started`, `turn/completed`, `turn/plan/updated`, `turn/moderationMetadata`, `item/started`, `item/agentMessage/delta`, `item/plan/delta`, `item/reasoning/summaryTextDelta`, `item/reasoning/summaryPartAdded`, `item/reasoning/textDelta`, `item/commandExecution/outputDelta`, `item/commandExecution/terminalInteraction`, `item/fileChange/outputDelta`, `item/fileChange/patchUpdated`, `item/mcpToolCall/progress`, `mcpServer/oauthLogin/completed`, `mcpServer/startupStatus/updated`, `account/updated`, `account/login/completed`, `account/rateLimits/updated`, `app/list/updated`, `remoteControl/status/changed`, `model/rerouted`, `model/verification`, `warning`, `guardianWarning`, `deprecationNotice`, `configWarning`, `fuzzyFileSearch/sessionUpdated`, `fuzzyFileSearch/sessionCompleted`, `thread/realtime/started`, `thread/realtime/itemAdded`, `thread/realtime/transcript/delta`, `thread/realtime/transcript/done`, `thread/realtime/outputAudio/delta`, `thread/realtime/sdp`, `thread/realtime/error`, `thread/realtime/closed`, `windows/worldWritableWarning`, `windowsSandbox/setupCompleted`, `externalAgentConfig/import/completed`, `fs/changed`, `item/completed`, `rawResponseItem/completed`, `serverRequest/resolved`, `command/exec/outputDelta`, `process/outputDelta`, `process/exited`, and `error`.
- Transcript item subset: text `userMessage`, `agentMessage`, and completed `plan` items.
- Errors: JSON-RPC error payloads and Codex `codexErrorInfo` turn-status behavior for the selected subset.
- Schema fingerprint emission is exposed through `app/AppProtocol.schemaFingerprintJson()`.

Run:

```bash
harness/check-app-protocol.sh
```
