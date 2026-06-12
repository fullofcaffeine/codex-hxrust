# Protocol

Upstream Codex protocol and app-server DTO work starts here.

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

- Requests: `thread/start`, `turn/start`, `turn/interrupt`, and `thread/read`.
- Responses: thread, turn, interrupt-empty, and transcript-bearing read payloads.
- Notifications: `thread/started`, `thread/status/changed`, `thread/compacted`, `turn/started`, `turn/completed`, `turn/plan/updated`, `turn/moderationMetadata`, `item/started`, `item/agentMessage/delta`, `item/plan/delta`, `item/reasoning/summaryTextDelta`, `item/reasoning/summaryPartAdded`, `item/reasoning/textDelta`, `item/commandExecution/outputDelta`, `item/commandExecution/terminalInteraction`, `item/fileChange/outputDelta`, `item/fileChange/patchUpdated`, `item/mcpToolCall/progress`, `mcpServer/oauthLogin/completed`, `mcpServer/startupStatus/updated`, `account/updated`, `account/rateLimits/updated`, `app/list/updated`, `remoteControl/status/changed`, `model/rerouted`, `model/verification`, `warning`, `guardianWarning`, `deprecationNotice`, `configWarning`, `fuzzyFileSearch/sessionUpdated`, `fuzzyFileSearch/sessionCompleted`, `thread/realtime/started`, `thread/realtime/itemAdded`, `thread/realtime/transcript/delta`, `thread/realtime/transcript/done`, `thread/realtime/outputAudio/delta`, `thread/realtime/sdp`, `externalAgentConfig/import/completed`, `fs/changed`, `item/completed`, `rawResponseItem/completed`, `serverRequest/resolved`, `command/exec/outputDelta`, `process/outputDelta`, `process/exited`, and `error`.
- Transcript item subset: text `userMessage`, `agentMessage`, and completed `plan` items.
- Errors: JSON-RPC error payloads and Codex `codexErrorInfo` turn-status behavior for the selected subset.
- Schema fingerprint emission is exposed through `app/AppProtocol.schemaFingerprintJson()`.

Run:

```bash
harness/check-app-protocol.sh
```
