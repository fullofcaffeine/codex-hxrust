# Upstream App-Server Parity Audit

**Date:** 2026-06-12
**Bead:** `HXCX-3.62` / `codex-hxrust-bxt`
**Baseline:** mainstream Codex app-server protocol at `../codex`, pinned by `reference/upstream-codex.pin.json` to `2704ecea9a1d52ece2429da4ed5775000b59164d`

## Purpose

This audit keeps the raw upstream Codex port ahead of Cafex adapter work. The local app protocol subset is intentionally fixture-backed and smaller than upstream, but the remaining gap must be explicit so `bd ready` continues to surface upstream/mainstream Codex work before Cafex bridges.

The audit compares:

- upstream client request definitions in `../codex/codex-rs/app-server-protocol/src/protocol/common.rs`
- upstream server request definitions in the same file
- upstream server notification definitions in the same file
- selected local methods in `src/codexhx/protocol/app/AppProtocol.hx`
- selected upstream schema files under `../codex/codex-rs/app-server-protocol/schema/json`

No Cafex or Cafetera source is part of this audit.

## Current Local Selection

The local app protocol subset currently admits 93 client request methods:

```text
account/login/cancel
account/login/start
account/logout
account/rateLimits/read
account/read
account/sendAddCreditsNudgeEmail
account/usage/read
app/list
command/exec
command/exec/resize
command/exec/terminate
command/exec/write
config/batchWrite
config/mcpServer/reload
config/read
config/value/write
configRequirements/read
experimentalFeature/enablement/set
experimentalFeature/list
externalAgentConfig/detect
externalAgentConfig/import
feedback/upload
fs/copy
fs/createDirectory
fs/getMetadata
fs/readDirectory
fs/readFile
fs/remove
fs/unwatch
fs/watch
fs/writeFile
hooks/list
marketplace/add
marketplace/remove
marketplace/upgrade
mcpServer/oauth/login
mcpServer/resource/read
mcpServer/tool/call
mcpServerStatus/list
memory/reset
model/list
modelProvider/capabilities/read
permissionProfile/list
plugin/installed
plugin/install
plugin/list
plugin/read
plugin/share/checkout
plugin/share/delete
plugin/share/list
plugin/share/save
plugin/share/updateTargets
plugin/skill/read
plugin/uninstall
process/kill
process/resizePty
process/spawn
process/writeStdin
review/start
skills/config/write
skills/extraRoots/set
skills/list
thread/approveGuardianDeniedAction
thread/archive
thread/backgroundTerminals/clean
thread/compact/start
thread/decrement_elicitation
thread/fork
thread/metadata/update
thread/goal/clear
thread/goal/get
thread/goal/set
thread/increment_elicitation
thread/inject_items
thread/list
thread/loaded/list
thread/memoryMode/set
thread/name/set
thread/read
thread/resume
thread/rollback
thread/settings/update
thread/shellCommand
thread/start
thread/turns/items/list
thread/turns/list
thread/unarchive
thread/unsubscribe
turn/interrupt
turn/start
turn/steer
windowsSandbox/readiness
windowsSandbox/setupStart
```

This covers the first credential-free headless/runtime path plus thread lifecycle/navigation, thread search, fuzzy search session requests, realtime client controls, remote-control request controls, auth, account, config, external-agent import, command/process, Windows sandbox, environment, and collaboration-mode request families that have already been admitted through fixture-backed Haxe and generated Rust gates.

The local subset also admits 8 upstream client-directed server request families:

```text
account/chatgptAuthTokens/refresh
attestation/generate
item/commandExecution/requestApproval
item/fileChange/requestApproval
item/permissions/requestApproval
item/tool/call
item/tool/requestUserInput
mcpServer/elicitation/request
```

The local subset also validates selected notifications needed by the current headless/app protocol fixtures, including thread/turn lifecycle basics, streaming item deltas, account/rate-limit updates, config warnings, app list updates, realtime output notifications, process output, filesystem change, and selected deprecated notification parity.

## Upstream Gap Summary

Upstream v2 request parity is complete for production-selected methods; only the upstream test-only `mock/experimentalMethod` remains outside the local production subset. HXCX-3.74 adds the selected deprecated v1 compatibility methods as an explicitly separate legacy surface, while `initialize` is handled by HXCX-4.11 runtime bootstrap.

The remaining requests fall into these groups:

| Group | Missing methods | Priority |
| --- | --- | --- |
| Thread navigation and lifecycle | `thread/resume`, `thread/fork`, `thread/archive`, `thread/unarchive`, `thread/unsubscribe`, `thread/list`, `thread/loaded/list` | Admitted in HXCX-3.63 |
| Thread state and history mutation | `thread/increment_elicitation`, `thread/decrement_elicitation`, `thread/name/set`, `thread/goal/set`, `thread/goal/get`, `thread/goal/clear`, `thread/metadata/update`, `thread/settings/update`, `thread/memoryMode/set`, `thread/compact/start`, `thread/shellCommand`, `thread/approveGuardianDeniedAction`, `thread/backgroundTerminals/clean`, `thread/rollback`, `thread/inject_items`, `memory/reset` | Admitted in HXCX-3.64 |
| Turn and review continuation | `turn/steer`, `review/start`, `thread/turns/list`, `thread/turns/items/list` | Admitted in HXCX-3.65 |
| Models and environment | `environment/add`, `collaborationMode/list` | Admitted in HXCX-3.69 |
| Test-only experimental gate | `mock/experimentalMethod` | Unsupported production behavior |
| Apps, skills, hooks, marketplace, plugins | selected in HXCX-3.67 | Done |
| Filesystem remote surface | selected in HXCX-3.67 | Done |
| MCP and config reload | selected in HXCX-3.67 | Done |
| Remote control | `remoteControl/enable`, `remoteControl/disable`, `remoteControl/status/read`, `remoteControl/pairing/start`, `remoteControl/pairing/status`, `remoteControl/client/list`, `remoteControl/client/revoke` | Admitted in HXCX-3.73 |
| Realtime client controls | `thread/realtime/start`, `thread/realtime/appendAudio`, `thread/realtime/appendText`, `thread/realtime/stop`, `thread/realtime/listVoices` | Admitted in HXCX-3.72 |
| Thread search | `thread/search` | Admitted in HXCX-3.70 |
| Fuzzy search requests | `fuzzyFileSearch/sessionStart`, `fuzzyFileSearch/sessionUpdate`, `fuzzyFileSearch/sessionStop` | Admitted in HXCX-3.71 |
| Deprecated v1 client requests | `GetConversationSummary`, `GitDiffToRemote`, `GetAuthStatus`, legacy `fuzzyFileSearch`; `Initialize` deferred to app-server transport/bootstrap parity | Admitted in HXCX-3.74 as an isolated compatibility slice |

## Notification Gaps

Upstream currently exposes notification wires that the local subset does not yet admit:

```text
hook/completed
hook/started
item/autoApprovalReview/completed
item/autoApprovalReview/started
skills/changed
turn/diff/updated
```

These should be paired with the related request family when practical. For example, `thread/archive` and `thread/unarchive` should travel with `thread/archived` and `thread/unarchived`; thread goal requests should travel with goal notifications; hook/plugin/config slices should travel with skills/hook change notifications.

## Server Request Gaps

Upstream also defines client-directed server requests that are distinct from server notifications. These were admitted in HXCX-3.66:

```text
account/chatgptAuthTokens/refresh
attestation/generate
item/commandExecution/requestApproval
item/fileChange/requestApproval
item/permissions/requestApproval
item/tool/call
item/tool/requestUserInput
mcpServer/elicitation/request
```

These are important for full app-server parity and now have bidirectional request/response fixture modeling.

## Schema Export Notes

Most modern v2 request families above have standalone schema files under `schema/json/v2`.

Known exceptions:

- `process/spawn`, `process/writeStdin`, `process/kill`, and `process/resizePty` are already selected from upstream Rust DTO/protocol mappings because standalone process request schema files are not exported.
- `thread/increment_elicitation`, `thread/decrement_elicitation`, `thread/settings/update`, `thread/memoryMode/set`, `memory/reset`, and `thread/backgroundTerminals/clean` are selected from upstream Rust DTO/protocol mappings because standalone request/response schema files are not exported in the pinned schema tree.
- `thread/turns/list` and `thread/turns/items/list` are selected from upstream Rust DTO/protocol mappings because standalone request/response schema files are not exported in the pinned schema tree.
- `fuzzyFileSearch/sessionStart`, `fuzzyFileSearch/sessionUpdate`, and `fuzzyFileSearch/sessionStop` are selected Rust DTO/protocol mappings without standalone request/response schema files; their notifications are already tracked through top-level schema files.
- `environment/add`, `collaborationMode/list`, and `thread/search` are selected from upstream Rust DTO/protocol mappings because standalone request/response schema files are not exported in the pinned schema tree.
- `thread/realtime/start`, `thread/realtime/appendAudio`, `thread/realtime/appendText`, `thread/realtime/stop`, and `thread/realtime/listVoices` are selected Rust DTO/protocol mappings without standalone request/response schema files; their notifications are already tracked through v2 notification schema files.
- `remoteControl/enable`, `remoteControl/disable`, `remoteControl/status/read`, `remoteControl/pairing/start`, `remoteControl/pairing/status`, `remoteControl/client/list`, and `remoteControl/client/revoke` are selected Rust DTO/protocol mappings without standalone request/response schema files; their status notification schema is already tracked through a v2 notification schema file.
- Client-directed server request schemas are emitted as top-level schema files under `schema/json/` rather than `schema/json/v2`; the selected command/file/permission approval, tool user input, MCP elicitation, dynamic tool call, ChatGPT auth refresh, and attestation schemas are fingerprinted from that location.
- Deprecated v1 `getConversationSummary`, `gitDiffToRemote`, and `getAuthStatus` are selected Rust DTO/protocol mappings without standalone request/response schema files. Legacy `fuzzyFileSearch` params/response schemas are tracked through top-level schema files. `initialize` is handled by HXCX-4.11 runtime bootstrap and remains outside the normal app protocol subset.

## Sequencing Decision

The app/plugin/filesystem/MCP/model client request families have moved into the selected subset under HXCX-3.67, environment/collaboration protocol gates moved in under HXCX-3.69, thread search moved in under HXCX-3.70, fuzzy session requests moved in under HXCX-3.71, realtime client controls moved in under HXCX-3.72, remote-control request controls moved in under HXCX-3.73, and selected deprecated-v1 compatibility moved in under HXCX-3.74. `codex-hxrust-6cs` now sequences upstream TUI and live-runtime parity for the full Codex target, including terminal UI work; see [upstream-tui-live-runtime-sequence.md](upstream-tui-live-runtime-sequence.md).

Rationale:

- these are mainstream Codex app-server methods, not Cafex adapters
- the client-directed server-request approval surface is now admitted
- the next missing surfaces unlock app, plugin, file, model, and MCP flows used by real Codex clients
- they keep deprecated v1 APIs and Cafex bridge work out of the core until selected intentionally

## Follow-Up Bead Policy

Every new parity bead should:

- cite the upstream method names and schema/DTO source
- add fixture-backed Haxe validation plus generated Rust coverage
- update schema fingerprint selection, or document why the upstream DTO lacks a standalone schema file
- avoid Cafex adapter code unless the user explicitly asks for Cafex work
- keep Cafex bridge beads blocked until the selected upstream/core queue is exhausted or intentionally paused
