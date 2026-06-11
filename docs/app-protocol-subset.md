# App Protocol Subset

**Date:** 2026-06-10  
**Bead:** `HXCX-2.4` / `codex-hxrust-qml.4`  
**Baseline:** mainstream Codex app-server protocol v2 from `../codex/codex-rs/app-server-protocol`

## Scope

This slice implements a fixture-backed pure Haxe validator/normalizer for the first headless Codex app-server protocol surface.

Included client requests:

- `thread/start`
- `turn/start`
- `turn/interrupt`
- `thread/read`

Included server notifications:

- `thread/started`
- `thread/status/changed`
- `turn/started`
- `turn/completed`
- `turn/plan/updated`
- `item/started`
- `item/agentMessage/delta`
- `item/plan/delta`
- `item/commandExecution/outputDelta`
- `item/commandExecution/terminalInteraction`
- `item/fileChange/outputDelta`
- `item/fileChange/patchUpdated`
- `item/mcpToolCall/progress`
- `mcpServer/oauthLogin/completed`
- `mcpServer/startupStatus/updated`
- `account/updated`
- `account/rateLimits/updated`
- `app/list/updated`
- `remoteControl/status/changed`
- `externalAgentConfig/import/completed`
- `fs/changed`
- `item/completed`
- `rawResponseItem/completed`
- `serverRequest/resolved`
- `command/exec/outputDelta`
- `process/outputDelta`
- `process/exited`
- `error`

Included response payloads:

- `ThreadStartResponse`
- `TurnStartResponse`
- `TurnInterruptResponse`
- `ThreadReadResponse`

The fixture also covers transcript-bearing turns with text `userMessage`, `agentMessage`, and completed `plan` items, selected assistant text delta notifications, `turn/plan/updated` checklist notifications, experimental plan delta notifications, item command execution deltas and terminal interactions, file-change output and patch update notifications, MCP tool-call progress, MCP OAuth login completion, MCP server startup status, account updates, account rate-limit updates, app-list updates, remote-control status changes, external agent config import completion, filesystem change notifications, server request resolution, command/process output deltas, process exit notifications, and the raw response item completion notification for assistant `message` response items with `output_text` content.

`item/plan/delta` is admitted as the upstream streaming payload shape. Completed `plan` items are validated through the shared `ThreadItem` shape; their `text` is authoritative and may not match the concatenation of streamed deltas.

`turn/plan/updated` is the upstream update-plan/checklist notification. Its `explanation` may be missing, `null`, or a string, and each plan step status must be `pending`, `inProgress`, or `completed`.

`command/exec/outputDelta` is connection-scoped output streaming for standalone `command/exec` requests. The selected subset validates `processId`, `stream` as `stdout` or `stderr`, `deltaBase64`, and `capReached`.

`process/outputDelta` is output streaming for `process/spawn` requests. The selected subset validates `processHandle`, `stream` as `stdout` or `stderr`, `deltaBase64`, and `capReached`.

`process/exited` is the final process completion notification for `process/spawn`. The selected subset validates `processHandle`, numeric `exitCode`, buffered `stdout`/`stderr`, and stdout/stderr cap flags.

`item/commandExecution/outputDelta` is turn-item scoped command output. The selected subset validates `threadId`, `turnId`, `itemId`, and text `delta`.

`item/commandExecution/terminalInteraction` records terminal stdin sent to a command execution item. The selected subset validates `threadId`, `turnId`, `itemId`, `processId`, and text `stdin`.

`item/fileChange/outputDelta` is a deprecated legacy notification for apply_patch textual output. Upstream no longer emits it, but the selected subset validates `threadId`, `turnId`, `itemId`, and text `delta` for schema parity.

`item/fileChange/patchUpdated` reports apply_patch file update changes. The selected subset validates `threadId`, `turnId`, `itemId`, `changes`, each change `path`, `diff`, and patch `kind` with `add`, `delete`, or `update` plus optional nullable `move_path`.

`serverRequest/resolved` reports that a thread-scoped server request has resolved. The selected subset validates `threadId` and `requestId`, accepting string or numeric request IDs.

`item/mcpToolCall/progress` reports progress text for an MCP tool call item. The selected subset validates `threadId`, `turnId`, `itemId`, and text `message`.

`mcpServer/oauthLogin/completed` reports MCP OAuth login results. The selected subset validates `name`, boolean `success`, and optional nullable text `error`.

`mcpServer/startupStatus/updated` reports MCP server startup state changes. The selected subset validates `name`, `status` as `starting`, `ready`, `failed`, or `cancelled`, plus optional nullable `threadId` and `error`.

`account/updated` reports account authentication and plan state. The selected subset accepts missing or null `authMode` and `planType`; string values must match the upstream auth and plan enums.

`account/rateLimits/updated` reports sparse rolling rate-limit updates. The selected subset validates the required `rateLimits` object plus optional nullable limit metadata, primary/secondary windows, credits, individual spend-control limits, plan type, and rate-limit-reached type.

`app/list/updated` reports app metadata list refreshes. The selected subset validates the upstream `data` array, required app `id` and `name`, optional/defaulted booleans, labels, plugin display names, branding, and selected nullable app metadata fields.

`remoteControl/status/changed` reports remote-control connection status and identity. The selected subset validates `installationId`, `serverName`, `status` as `disabled`, `connecting`, `connected`, or `errored`, and optional nullable `environmentId`.

`externalAgentConfig/import/completed` reports completion of an external agent config import. The current upstream schema is an empty object, so the selected subset validates object-shaped `params` with no required fields.

`fs/changed` reports filesystem watch updates for `fs/watch` subscribers. The selected subset validates `watchId` and `changedPaths` as a required string array.

## Error Policy

JSON-RPC errors are normalized with deterministic key ordering.

Codex turn errors follow upstream intent for selected `codexErrorInfo` variants:

- `threadRollbackFailed` does not affect turn status.
- `{ "activeTurnNotSteerable": ... }` does not affect turn status.
- all other selected/unknown error info values affect turn status.

## Fingerprint

`codexhx.protocol.app.AppProtocol.schemaFingerprintJson()` emits a deterministic subset fingerprint. The upstream schema golden is maintained at `reference/app-protocol-schema-fingerprints.v1.json` and checked by `harness/check-schema-fingerprints.sh`.

## Gate

Run from `.`:

```bash
harness/check-app-protocol.sh
```

The gate runs:

- Haxe interpreter harness
- haxe.rust generation through `hxml/app-protocol.hxml`
- generated `cargo check --locked`
- generated `cargo test --locked`
- generated binary execution
