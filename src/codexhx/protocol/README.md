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
- Notifications: `thread/started`, `thread/status/changed`, `turn/started`, `turn/completed`, `turn/plan/updated`, `item/started`, `item/agentMessage/delta`, `item/plan/delta`, `item/commandExecution/outputDelta`, `item/completed`, `rawResponseItem/completed`, `command/exec/outputDelta`, `process/outputDelta`, `process/exited`, and `error`.
- Transcript item subset: text `userMessage`, `agentMessage`, and completed `plan` items.
- Errors: JSON-RPC error payloads and Codex `codexErrorInfo` turn-status behavior for the selected subset.
- Schema fingerprint emission is exposed through `app/AppProtocol.schemaFingerprintJson()`.

Run:

```bash
harness/check-app-protocol.sh
```
