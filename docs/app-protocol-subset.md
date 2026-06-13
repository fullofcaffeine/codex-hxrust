# App Protocol Subset

**Date:** 2026-06-10  
**Bead:** `HXCX-2.4` / `codex-hxrust-qml.4`  
**Baseline:** mainstream Codex app-server protocol v2 from `../codex/codex-rs/app-server-protocol`

## Scope

This slice implements a fixture-backed pure Haxe validator/normalizer for the selected upstream Codex app-server protocol surface. Headless fixtures are the current deterministic proof path, not the final project scope.

Included client requests:

- `thread/start`
- `thread/resume`
- `thread/fork`
- `thread/archive`
- `thread/unarchive`
- `thread/unsubscribe`
- `thread/increment_elicitation`
- `thread/decrement_elicitation`
- `thread/name/set`
- `thread/goal/set`
- `thread/goal/get`
- `thread/goal/clear`
- `thread/metadata/update`
- `thread/settings/update`
- `thread/memoryMode/set`
- `memory/reset`
- `thread/compact/start`
- `thread/shellCommand`
- `thread/approveGuardianDeniedAction`
- `thread/backgroundTerminals/clean`
- `thread/rollback`
- `thread/inject_items`
- `thread/turns/list`
- `thread/turns/items/list`
- `turn/start`
- `turn/steer`
- `turn/interrupt`
- `review/start`
- `thread/list`
- `thread/search`
- `thread/loaded/list`
- `thread/read`
- `fuzzyFileSearch/sessionStart`
- `fuzzyFileSearch/sessionUpdate`
- `fuzzyFileSearch/sessionStop`
- `windowsSandbox/setupStart`
- `windowsSandbox/readiness`
- `account/login/start`
- `account/login/cancel`
- `account/logout`
- `account/read`
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
- `config/read`
- `externalAgentConfig/detect`
- `externalAgentConfig/import`
- `config/value/write`
- `config/batchWrite`
- `configRequirements/read`
- `environment/add`
- `collaborationMode/list`
- `app/list`
- `skills/list`
- `skills/extraRoots/set`
- `skills/config/write`
- `hooks/list`
- `marketplace/add`
- `marketplace/remove`
- `marketplace/upgrade`
- `plugin/list`
- `plugin/installed`
- `plugin/read`
- `plugin/skill/read`
- `plugin/install`
- `plugin/uninstall`
- `plugin/share/save`
- `plugin/share/updateTargets`
- `plugin/share/list`
- `plugin/share/checkout`
- `plugin/share/delete`
- `fs/readFile`
- `fs/writeFile`
- `fs/createDirectory`
- `fs/getMetadata`
- `fs/readDirectory`
- `fs/remove`
- `fs/copy`
- `fs/watch`
- `fs/unwatch`
- `model/list`
- `modelProvider/capabilities/read`
- `experimentalFeature/list`
- `experimentalFeature/enablement/set`
- `permissionProfile/list`
- `mcpServer/oauth/login`
- `config/mcpServer/reload`
- `mcpServerStatus/list`
- `mcpServer/resource/read`
- `mcpServer/tool/call`

Included client-directed server requests:

- `item/commandExecution/requestApproval`
- `item/fileChange/requestApproval`
- `item/permissions/requestApproval`
- `item/tool/requestUserInput`
- `mcpServer/elicitation/request`
- `item/tool/call`
- `account/chatgptAuthTokens/refresh`
- `attestation/generate`

Included server notifications:

- `thread/started`
- `thread/status/changed`
- `thread/archived`
- `thread/unarchived`
- `thread/closed`
- `thread/name/updated`
- `thread/goal/updated`
- `thread/goal/cleared`
- `thread/settings/updated`
- `thread/tokenUsage/updated`
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
- `ThreadResumeResponse`
- `ThreadForkResponse`
- `ThreadArchiveResponse`
- `ThreadUnarchiveResponse`
- `ThreadUnsubscribeResponse`
- `ThreadIncrementElicitationResponse`
- `ThreadDecrementElicitationResponse`
- `ThreadSetNameResponse`
- `ThreadGoalSetResponse`
- `ThreadGoalGetResponse`
- `ThreadGoalClearResponse`
- `ThreadMetadataUpdateResponse`
- `ThreadSettingsUpdateResponse`
- `ThreadMemoryModeSetResponse`
- `MemoryResetResponse`
- `ThreadCompactStartResponse`
- `ThreadShellCommandResponse`
- `ThreadApproveGuardianDeniedActionResponse`
- `ThreadBackgroundTerminalsCleanResponse`
- `ThreadRollbackResponse`
- `ThreadInjectItemsResponse`
- `ThreadTurnsListResponse`
- `ThreadTurnsItemsListResponse`
- `ThreadListResponse`
- `ThreadLoadedListResponse`
- `TurnStartResponse`
- `TurnSteerResponse`
- `TurnInterruptResponse`
- `ReviewStartResponse`
- `ThreadReadResponse`
- `WindowsSandboxSetupStartResponse`
- `WindowsSandboxReadinessResponse`
- `LoginAccountResponse`
- `CancelLoginAccountResponse`
- `LogoutAccountResponse`
- `GetAccountResponse`
- `GetAccountRateLimitsResponse`
- `GetAccountTokenUsageResponse`
- `SendAddCreditsNudgeEmailResponse`
- `FeedbackUploadResponse`
- `CommandExecResponse`
- `CommandExecWriteResponse`
- `CommandExecTerminateResponse`
- `CommandExecResizeResponse`
- `ConfigReadResponse`
- `ConfigWriteResponse`
- `ConfigRequirementsReadResponse`
- `ExternalAgentConfigDetectResponse`
- `ExternalAgentConfigImportResponse`
- `AppsListResponse`
- `SkillsListResponse`
- `SkillsExtraRootsSetResponse`
- `SkillsConfigWriteResponse`
- `HooksListResponse`
- `MarketplaceAddResponse`
- `MarketplaceRemoveResponse`
- `MarketplaceUpgradeResponse`
- `PluginListResponse`
- `PluginInstalledResponse`
- `PluginReadResponse`
- `PluginSkillReadResponse`
- `PluginInstallResponse`
- `PluginUninstallResponse`
- `PluginShareSaveResponse`
- `PluginShareUpdateTargetsResponse`
- `PluginShareListResponse`
- `PluginShareCheckoutResponse`
- `PluginShareDeleteResponse`
- `FsReadFileResponse`
- `FsWriteFileResponse`
- `FsCreateDirectoryResponse`
- `FsGetMetadataResponse`
- `FsReadDirectoryResponse`
- `FsRemoveResponse`
- `FsCopyResponse`
- `FsWatchResponse`
- `FsUnwatchResponse`
- `ModelListResponse`
- `ModelProviderCapabilitiesReadResponse`
- `ExperimentalFeatureListResponse`
- `ExperimentalFeatureEnablementSetResponse`
- `PermissionProfileListResponse`
- `McpServerOauthLoginResponse`
- `McpServerRefreshResponse`
- `ListMcpServerStatusResponse`
- `McpResourceReadResponse`
- `McpServerToolCallResponse`

The fixture also covers transcript-bearing turns with text `userMessage`, `agentMessage`, and completed `plan` items, thread resume/fork/archive/unarchive/unsubscribe/list/loaded-list lifecycle request responses, upstream thread state/history mutation request responses, turn steering, review start, paged turn and turn-item history responses, client-directed server request/response pairs for command approval, file-change approval, permission approval, tool user input, MCP elicitation, dynamic tool calls, ChatGPT auth-token refresh, and attestation generation, selected assistant text delta notifications, `turn/plan/updated` checklist notifications, experimental turn moderation metadata, deprecated context-compacted notifications, experimental plan delta notifications, reasoning summary part creation, summary text deltas, and reasoning content text deltas, item command execution deltas and terminal interactions, file-change output and patch update notifications, MCP tool-call progress, MCP OAuth login completion, MCP server startup status, account updates, account login start/cancel/completion, account logout/read/rate-limit/usage requests, add-credits nudge email requests, feedback upload requests, standalone command execution requests and control requests, host process spawn/control request responses, config read/value-write/batch-write and requirements read request responses, external agent config detect/import request responses, apps/skills/hooks/plugin/marketplace request responses, filesystem read/write/metadata/watch request responses, model/capability/experimental-feature/permission-profile request responses, MCP OAuth/status/resource/tool request responses, account rate-limit updates, app-list updates, remote-control status changes, model reroute and verification notifications, warning and guardian warning notifications, deprecation notice and config warning notifications, fuzzy file search session update and completion notifications, realtime startup/item/transcript/audio/SDP/error/closed notifications, Windows sandbox readiness/setup and warning notifications, external agent config import completion, filesystem change notifications, server request resolution, command/process output deltas, process exit notifications, and the raw response item completion notification for assistant `message` response items with `output_text` content.

`thread/resume` and `thread/fork` reopen or fork existing upstream threads. The selected subset validates required `threadId`, selected nullable override fields, approval policy variants, approvals reviewer, sandbox mode, personality, and response metadata plus the shared `Thread` payload.

`thread/archive`, `thread/unarchive`, and `thread/unsubscribe` validate required `threadId` params. Archive returns an empty object, unarchive returns a `Thread`, and unsubscribe returns the upstream `notLoaded`/`notSubscribed`/`unsubscribed` status enum. Paired `thread/archived`, `thread/unarchived`, and `thread/closed` notifications validate `threadId`.

`thread/increment_elicitation` and `thread/decrement_elicitation` validate required `threadId` params and response `count`/`paused` state. Upstream exports these DTOs from Rust source without standalone v2 JSON schema files in the pinned schema tree, so the schema gate records them as explicit Rust-source-tracked gaps.

Thread state/history mutation requests now cover name, goal set/get/clear, metadata patching, settings update, memory mode, memory reset, compact start, shell command echo, guardian denied-action approval, background terminal cleanup, rollback, and raw history injection. Stable schema-backed surfaces are fingerprinted. Experimental Rust-source-only surfaces are validated from the upstream DTO contracts and recorded in the schema gap list.

Thread state notifications validate name changes, goal updates/clears, settings snapshots, and token-usage accounting. Goal payloads validate the upstream goal status enum and integer accounting fields. Settings snapshots validate approval policy, approvals reviewer, sandbox policy, active permission profile, collaboration mode, reasoning summary/effort, service tier, model/provider, and personality.

`turn/steer` validates the same text-only user input subset as `turn/start` plus required `expectedTurnId` and returns `turnId`. Optional Responses API client metadata is validated as a string map, and optional additional context remains an arbitrary object at this layer.

`review/start` validates upstream tagged review targets (`uncommittedChanges`, `baseBranch`, `commit`, and `custom`), optional `inline`/`detached` delivery, and a response containing the review `Turn` plus `reviewThreadId`.

`thread/turns/list` and `thread/turns/items/list` validate pagination params, upstream `asc`/`desc` sort direction, `notLoaded`/`summary`/`full` item view where applicable, and response pages using the shared `Turn` and selected `ThreadItem` validators. Upstream exports these DTOs from Rust source without standalone v2 JSON schema files in the pinned schema tree, so the schema gate records them as explicit Rust-source-tracked gaps.

Client-directed server requests use upstream's `ServerRequest`/`ServerResponse` shape, not normal JSON-RPC client responses: requests carry `{ id, method, params }`, and responses carry `{ id, method, response }`. The selected subset validates command/file/permission approval decisions, tool user-input questions and answers, MCP elicitation `form`/`url` modes and actions, dynamic tool call params and text/image output content items, ChatGPT auth-token refresh reason/response fields, and opaque attestation tokens.

`thread/list` and `thread/loaded/list` validate upstream pagination params, cursors, limits, sort/filter enums, and response arrays. `thread/list` returns `Thread` objects, while `thread/loaded/list` returns loaded thread id strings.

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

`account/read` reads the current account authentication state. The selected subset validates optional boolean `refreshToken`, required boolean `requiresOpenaiAuth`, and nullable account variants for `apiKey`, `chatgpt`, and `amazonBedrock`; the `chatgpt` variant requires `email` plus upstream `planType`. The fixture is credential-free and does not refresh real tokens.

`account/rateLimits/read` reads the current account rate-limit snapshot. Upstream models params as absent/undefined; the selected subset accepts missing, null, or empty object params and validates required `rateLimits` plus optional nullable `rateLimitsByLimitId` snapshots.

`account/usage/read` reads account token usage. Upstream models params as absent/undefined; the selected subset accepts missing, null, or empty object params and validates required `summary` nullable integer fields plus optional nullable `dailyUsageBuckets` with `startDate` and integer `tokens`.

`account/sendAddCreditsNudgeEmail` asks the app server to send an add-credits nudge email. The selected subset validates required request `creditType` as `credits` or `usage_limit`, and response `status` as `sent` or `cooldown_active`.

`feedback/upload` uploads user feedback. The selected subset validates required string `classification`, optional nullable `reason` and `threadId`, optional boolean `includeLogs`, optional nullable string-array `extraLogFiles`, optional nullable string map `tags`, and response `threadId`.

`command/exec` runs a standalone argv-vector command under the server sandbox. The selected subset validates non-empty string `command`, optional nullable `processId`, `cwd`, and `permissionProfile`, optional boolean execution flags, nullable integer `outputBytesCap`/`timeoutMs`, nullable env maps with string/null values, nullable terminal size, sandbox policy variants, and response `exitCode`, `stdout`, and `stderr`. It also validates documented request invariants for process IDs required by TTY/streaming modes, incompatible output-cap and timeout settings, terminal size requiring TTY, and `sandboxPolicy`/`permissionProfile` exclusivity. The fixture is protocol-only and does not execute a real shell command.

`command/exec/write`, `command/exec/terminate`, and `command/exec/resize` control a running standalone command process. The selected subset validates required string `processId`, optional nullable write `deltaBase64`, optional boolean `closeStdin`, resize terminal size rows/cols, and the empty object success responses. The fixture is protocol-only and does not write stdin, terminate, or resize a real process.

`process/spawn` starts an experimental host process outside the Codex sandbox. The selected subset validates non-empty string `command`, required `processHandle` and `cwd`, optional boolean stream/TTY flags, nullable `outputBytesCap` and `timeoutMs` double-option fields, nullable env maps with string/null values, optional terminal size rows/cols, and the empty object success response. The fixture is protocol-only and does not spawn a real process. Upstream currently does not emit standalone `v2/ProcessSpawnParams.json` or `v2/ProcessSpawnResponse.json`; this request is tracked from the upstream Rust DTO and protocol mapping while process notification schemas remain fingerprinted.

`process/writeStdin`, `process/kill`, and `process/resizePty` control an experimental host process. The selected subset validates required string `processHandle`, optional nullable write `deltaBase64`, optional boolean `closeStdin`, resize terminal size rows/cols, and empty object success responses. The fixture is protocol-only and does not write stdin, kill, or resize a real process. Upstream currently does not emit standalone v2 request/response schema files for these experimental process control DTOs; they are tracked from upstream Rust DTOs and protocol mappings while process notification schemas remain fingerprinted.

`config/read` reads the effective upstream configuration. The selected subset validates optional boolean `includeLayers`, optional nullable `cwd`, required response `config` and `origins`, optional nullable `layers`, typed config scalar/enum fields, selected nested tool/sandbox/app/analytics config objects, and config layer source variants. The fixture is protocol-only and does not read or mutate real user configuration.

`config/value/write` writes one upstream configuration value. The selected subset validates required string `keyPath`, required `mergeStrategy` as `replace` or `upsert`, required arbitrary JSON `value`, optional nullable `filePath` and `expectedVersion`, and the shared `ConfigWriteResponse` fields `status`, `version`, `filePath`, and optional nullable `overriddenMetadata`. The fixture is protocol-only and does not write real configuration files.

`config/batchWrite` writes multiple upstream configuration edits. The selected subset validates required `edits`, each edit's string `keyPath`, `mergeStrategy`, and arbitrary JSON `value`, optional nullable `filePath` and `expectedVersion`, optional boolean `reloadUserConfig`, and the shared `ConfigWriteResponse` shape. The fixture is protocol-only and does not write or hot-reload real configuration files.

`configRequirements/read` reads managed configuration requirements. Upstream models request params as absent/undefined; the selected subset accepts missing, null, or empty object params. The response validates nullable `requirements` plus selected schema-exported requirement fields: approval policy variants, sandbox/web-search/Windows sandbox enum arrays, boolean maps for permission profiles and feature requirements, nullable booleans, `computerUse`, default permissions, and residency. The fixture is protocol-only and does not read real managed requirements.

`externalAgentConfig/detect` detects external agent configuration that can be migrated into Codex. The selected subset validates optional boolean `includeHome`, optional nullable string-array `cwds`, required response `items`, migration `itemType` enum values, optional nullable `cwd`, optional nullable `details`, and typed command, hook, MCP server, plugin, session, and subagent detail arrays. The fixture is protocol-only and does not scan the home directory or workspaces.

`externalAgentConfig/import` imports selected external agent configuration into Codex. The selected subset validates required `migrationItems` using the same migration item/detail shape as `externalAgentConfig/detect` and validates the empty object success response. The fixture is protocol-only and does not import or write real configuration.

`environment/add` and `collaborationMode/list` admit the upstream experimental environment and collaboration-mode request families. The selected subset validates non-empty `environmentId` and `execServerUrl`, empty environment-add success responses, empty collaboration-mode list params, collaboration-mode `data` containers, non-empty mask names, nullable `mode`/`model`/`reasoning_effort`, `mode` enum values, and non-empty `reasoning_effort` when present. It does not open remote execution transports or mutate live environment registries in the fixture path.

`app/list`, `skills/list`, `skills/extraRoots/set`, `skills/config/write`, and `hooks/list` admit the upstream app, skill, and hook request families. The selected subset validates pagination where present, workspace/root arrays, boolean reload/config flags, empty success responses, and list `data` containers. Nested app metadata reuses the same `AppInfo` validator as `app/list/updated`; skill and hook entries remain object-shaped at this layer.

`marketplace/*`, `plugin/*`, and `plugin/share/*` admit upstream plugin and marketplace management request families. The selected subset validates required marketplace/plugin identifiers, optional nullable marketplace paths/names, share target arrays, install/uninstall empty responses, plugin read object containers, auth-policy presence, and share checkout/save/update/list/delete response containers. Deep plugin DTO fields are intentionally deferred to focused nested DTO beads.

`fs/readFile`, `fs/writeFile`, `fs/createDirectory`, `fs/getMetadata`, `fs/readDirectory`, `fs/remove`, `fs/copy`, `fs/watch`, and `fs/unwatch` admit the upstream filesystem request family as protocol fixtures only. The selected subset validates path/watch ids, base64 data fields, optional recursive/force booleans, metadata booleans/timestamps, directory entry object arrays, watch path responses, and empty mutation success responses. It does not mutate the real filesystem.

`model/list`, `modelProvider/capabilities/read`, `experimentalFeature/list`, `experimentalFeature/enablement/set`, and `permissionProfile/list` admit upstream model/capability/feature/profile request families. The selected subset validates pagination, nullable context fields, capability booleans, boolean enablement maps, and object-list response containers.

`mcpServer/oauth/login`, `config/mcpServer/reload`, `mcpServerStatus/list`, `mcpServer/resource/read`, and `mcpServer/tool/call` admit upstream MCP request families at the app-server protocol boundary. The selected subset validates server/tool/resource identifiers, optional scopes/timeouts/detail/thread ids, OAuth authorization URL responses, empty reload responses, status pages, resource content arrays, and tool-call content/meta/error containers. Real MCP transport and execution remain separate tool/runtime work.

`thread/search` admits the upstream experimental thread search request family. The selected subset validates required non-empty `searchTerm`, optional pagination, sort, source-kind, and archived filters, result `data` containers, embedded thread objects, string snippets, and nullable cursors. The fixture path does not scan local rollout storage.

`fuzzyFileSearch/sessionStart`, `fuzzyFileSearch/sessionUpdate`, and `fuzzyFileSearch/sessionStop` admit the upstream experimental fuzzy search session request family. Notifications were already selected; this slice validates start `sessionId` and `roots`, update `sessionId` and `query`, stop `sessionId`, empty success responses, and malformed request cases. The fixture path does not start a real filesystem indexer.

Realtime client controls, remote-control request controls, and deprecated v1 compatibility are selected and sequenced by HXCX-3.68 in [remaining-app-server-surfaces.md](remaining-app-server-surfaces.md), but not yet implemented in this protocol subset. `mock/experimentalMethod` is an upstream test-only experimental gate and is unsupported for production behavior. Follow-up Beads keep the remaining upstream compatibility and full TUI/live-runtime sequencing separate from Cafex adapter work.

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
