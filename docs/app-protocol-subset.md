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
- `windowsSandbox/setupStart`
- `windowsSandbox/readiness`
- `account/login/start`
- `account/login/cancel`
- `account/logout`
- `account/rateLimits/read`
- `account/usage/read`
- `account/sendAddCreditsNudgeEmail`
- `feedback/upload`
- `command/exec`
- `command/exec/write`
- `command/exec/terminate`
- `command/exec/resize`
- `process/spawn`
- `process/writeStdin`
- `process/kill`
- `process/resizePty`

Included server notifications:

- `thread/started`
- `thread/status/changed`
- `thread/compacted`
- `turn/started`
- `turn/completed`
- `turn/plan/updated`
- `turn/moderationMetadata`
- `item/started`
- `item/agentMessage/delta`
- `item/plan/delta`
- `item/reasoning/summaryTextDelta`
- `item/reasoning/summaryPartAdded`
- `item/reasoning/textDelta`
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
- `model/rerouted`
- `model/verification`
- `warning`
- `guardianWarning`
- `deprecationNotice`
- `configWarning`
- `fuzzyFileSearch/sessionUpdated`
- `fuzzyFileSearch/sessionCompleted`
- `thread/realtime/started`
- `thread/realtime/itemAdded`
- `thread/realtime/transcript/delta`
- `thread/realtime/transcript/done`
- `thread/realtime/outputAudio/delta`
- `thread/realtime/sdp`
- `thread/realtime/error`
- `thread/realtime/closed`
- `windows/worldWritableWarning`
- `windowsSandbox/setupCompleted`
- `account/login/completed`
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
- `WindowsSandboxSetupStartResponse`
- `WindowsSandboxReadinessResponse`
- `LoginAccountResponse`
- `CancelLoginAccountResponse`
- `LogoutAccountResponse`
- `GetAccountRateLimitsResponse`
- `GetAccountTokenUsageResponse`
- `SendAddCreditsNudgeEmailResponse`
- `FeedbackUploadResponse`
- `CommandExecResponse`
- `CommandExecWriteResponse`
- `CommandExecTerminateResponse`
- `CommandExecResizeResponse`

The fixture also covers transcript-bearing turns with text `userMessage`, `agentMessage`, and completed `plan` items, selected assistant text delta notifications, `turn/plan/updated` checklist notifications, experimental turn moderation metadata, deprecated context-compacted notifications, experimental plan delta notifications, reasoning summary part creation, summary text deltas, and reasoning content text deltas, item command execution deltas and terminal interactions, file-change output and patch update notifications, MCP tool-call progress, MCP OAuth login completion, MCP server startup status, account updates, account login start/cancel/completion, account logout/read requests, add-credits nudge email requests, feedback upload requests, standalone command execution requests and control requests, host process spawn and control requests, account rate-limit updates, app-list updates, remote-control status changes, model reroute and verification notifications, warning and guardian warning notifications, deprecation notice and config warning notifications, fuzzy file search session update and completion notifications, realtime startup/item/transcript/audio/SDP/error/closed notifications, Windows sandbox readiness/setup and warning notifications, external agent config import completion, filesystem change notifications, server request resolution, command/process output deltas, process exit notifications, and the raw response item completion notification for assistant `message` response items with `output_text` content.

`item/plan/delta` is admitted as the upstream streaming payload shape. Completed `plan` items are validated through the shared `ThreadItem` shape; their `text` is authoritative and may not match the concatenation of streamed deltas.

`item/reasoning/summaryTextDelta` streams text for a reasoning summary part. The selected subset validates `threadId`, `turnId`, `itemId`, integer `summaryIndex`, and text `delta`.

`item/reasoning/summaryPartAdded` announces a new reasoning summary part. The selected subset validates `threadId`, `turnId`, `itemId`, and integer `summaryIndex`.

`item/reasoning/textDelta` streams text for a reasoning content part. The selected subset validates `threadId`, `turnId`, `itemId`, integer `contentIndex`, and text `delta`.

`thread/compacted` is a deprecated context-compaction notification. Upstream recommends using the `ContextCompaction` item type instead; the selected subset keeps protocol parity by validating `threadId` and `turnId`.

`turn/plan/updated` is the upstream update-plan/checklist notification. Its `explanation` may be missing, `null`, or a string, and each plan step status must be `pending`, `inProgress`, or `completed`.

`turn/moderationMetadata` is experimental upstream turn moderation metadata. The selected subset validates `threadId`, `turnId`, and required `metadata` while preserving `metadata` as an arbitrary JSON value.

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

`model/rerouted` reports model reroute decisions. The selected subset validates `threadId`, `turnId`, `fromModel`, `toModel`, and `reason` as the upstream `ModelRerouteReason` enum.

`model/verification` reports model verification metadata. The selected subset validates `threadId`, `turnId`, and `verifications` as an array of upstream `ModelVerification` enum values.

`warning` reports concise user-facing warnings. The selected subset validates required text `message` plus optional nullable `threadId`.

`guardianWarning` reports concise thread-scoped guardian warnings. The selected subset validates required text `message` and required text `threadId`.

`deprecationNotice` reports general deprecation notices. The selected subset validates required text `summary` plus optional nullable `details`.

`configWarning` reports config-file warnings. The selected subset validates required text `summary`, optional nullable `details` and `path`, and optional nullable `range` with `start` and `end` text positions containing unsigned integer `line` and `column`.

`fuzzyFileSearch/sessionUpdated` reports fuzzy file search session results. The selected subset validates required `sessionId`, `query`, and `files`, each file result's required `file_name`, `match_type`, `path`, `root`, unsigned `score`, and optional nullable unsigned `indices`.

`fuzzyFileSearch/sessionCompleted` reports fuzzy file search session completion. The selected subset validates required text `sessionId`.

`thread/realtime/started` is experimental upstream realtime startup acceptance. The selected subset validates required `threadId`, `version` as `v1` or `v2`, and optional nullable `realtimeSessionId`.

`thread/realtime/itemAdded` is experimental upstream raw realtime item emission. The selected subset validates required `threadId` and required arbitrary JSON `item`.

`thread/realtime/transcript/delta` is experimental upstream realtime transcript streaming. The selected subset validates required text `threadId`, `role`, and `delta`.

`thread/realtime/transcript/done` is experimental upstream realtime transcript completion. The selected subset validates required text `threadId`, `role`, and final `text`.

`thread/realtime/outputAudio/delta` is experimental upstream realtime audio output streaming. The selected subset validates required text `threadId`, required `audio.data`, optional nullable `audio.itemId`, unsigned integer `audio.numChannels` and `audio.sampleRate`, and optional nullable unsigned integer `audio.samplesPerChannel`.

`thread/realtime/sdp` is experimental upstream WebRTC session description emission. The selected subset validates required text `threadId` and `sdp`.

`thread/realtime/error` is experimental upstream realtime transport error reporting. The selected subset validates required text `threadId` and `message`.

`thread/realtime/closed` is experimental upstream realtime transport closure reporting. The selected subset validates required text `threadId` plus optional nullable `reason`.

`windowsSandbox/setupStart` starts Windows sandbox setup. The selected subset validates `mode` as `elevated` or `unelevated`, optional nullable text `cwd`, and response boolean `started`.

`windowsSandbox/readiness` reports Windows sandbox readiness. Upstream models params as absent/undefined; the selected subset accepts missing, null, or empty object params and validates response `status` as `ready`, `notConfigured`, or `updateRequired`.

`windows/worldWritableWarning` reports world-writable Windows directories that cannot be sandbox-protected. The selected subset validates string-array `samplePaths`, unsigned integer `extraCount`, and boolean `failedScan`.

`windowsSandbox/setupCompleted` reports Windows sandbox setup completion. The selected subset validates `mode`, boolean `success`, and optional nullable text `error`.

`account/login/start` starts account login. The selected subset validates all upstream tagged variants: `apiKey` with required `apiKey`, `chatgpt` with optional boolean `codexStreamlinedLogin`, `chatgptDeviceCode`, and `chatgptAuthTokens` with required token/account strings plus optional nullable plan text. The fixture uses the credential-free `chatgptDeviceCode` variant.

`account/login/cancel` cancels a pending account login. The selected subset validates request `loginId` and response `status` as `canceled` or `notFound`.

`account/login/completed` reports completion of an account login. The selected subset validates required boolean `success` plus optional nullable `loginId` and `error`.

`account/logout` logs out the active account. Upstream models params as absent/undefined; the selected subset accepts missing, null, or empty object params and validates the empty object response shape.

`account/rateLimits/read` reads the current account rate-limit snapshot. Upstream models params as absent/undefined; the selected subset accepts missing, null, or empty object params and validates required `rateLimits` plus optional nullable `rateLimitsByLimitId` snapshots.

`account/usage/read` reads account token usage. Upstream models params as absent/undefined; the selected subset accepts missing, null, or empty object params and validates required `summary` nullable integer fields plus optional nullable `dailyUsageBuckets` with `startDate` and integer `tokens`.

`account/sendAddCreditsNudgeEmail` asks the app server to send an add-credits nudge email. The selected subset validates required request `creditType` as `credits` or `usage_limit`, and response `status` as `sent` or `cooldown_active`.

`feedback/upload` uploads user feedback. The selected subset validates required string `classification`, optional nullable `reason` and `threadId`, optional boolean `includeLogs`, optional nullable string-array `extraLogFiles`, optional nullable string map `tags`, and response `threadId`.

`command/exec` runs a standalone argv-vector command under the server sandbox. The selected subset validates non-empty string `command`, optional nullable `processId`, `cwd`, and `permissionProfile`, optional boolean execution flags, nullable integer `outputBytesCap`/`timeoutMs`, nullable env maps with string/null values, nullable terminal size, sandbox policy variants, and response `exitCode`, `stdout`, and `stderr`. It also validates documented request invariants for process IDs required by TTY/streaming modes, incompatible output-cap and timeout settings, terminal size requiring TTY, and `sandboxPolicy`/`permissionProfile` exclusivity. The fixture is protocol-only and does not execute a real shell command.

`command/exec/write`, `command/exec/terminate`, and `command/exec/resize` control a running standalone command process. The selected subset validates required string `processId`, optional nullable write `deltaBase64`, optional boolean `closeStdin`, resize terminal size rows/cols, and the empty object success responses. The fixture is protocol-only and does not write stdin, terminate, or resize a real process.

`process/spawn` starts an experimental host process outside the Codex sandbox. The selected subset validates non-empty string `command`, required `processHandle` and `cwd`, optional boolean stream/TTY flags, nullable `outputBytesCap` and `timeoutMs` double-option fields, nullable env maps with string/null values, optional terminal size rows/cols, and the empty object success response. The fixture is protocol-only and does not spawn a real process. Upstream currently does not emit standalone `v2/ProcessSpawnParams.json` or `v2/ProcessSpawnResponse.json`; this request is tracked from the upstream Rust DTO and protocol mapping while process notification schemas remain fingerprinted.

`process/writeStdin`, `process/kill`, and `process/resizePty` control an experimental host process. The selected subset validates required string `processHandle`, optional nullable write `deltaBase64`, optional boolean `closeStdin`, resize terminal size rows/cols, and empty object success responses. The fixture is protocol-only and does not write stdin, kill, or resize a real process. Upstream currently does not emit standalone v2 request/response schema files for these experimental process control DTOs; they are tracked from upstream Rust DTOs and protocol mappings while process notification schemas remain fingerprinted.

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
