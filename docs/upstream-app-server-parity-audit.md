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

The local app protocol subset currently admits 51 client request methods:

```text
account/login/cancel
account/login/start
account/logout
account/rateLimits/read
account/read
account/sendAddCreditsNudgeEmail
account/usage/read
command/exec
command/exec/resize
command/exec/terminate
command/exec/write
config/batchWrite
config/read
config/value/write
configRequirements/read
externalAgentConfig/detect
externalAgentConfig/import
feedback/upload
process/kill
process/resizePty
process/spawn
process/writeStdin
memory/reset
thread/approveGuardianDeniedAction
thread/start
thread/resume
thread/fork
thread/archive
thread/unarchive
thread/unsubscribe
thread/increment_elicitation
thread/decrement_elicitation
thread/name/set
thread/goal/set
thread/goal/get
thread/goal/clear
thread/metadata/update
thread/settings/update
thread/memoryMode/set
thread/compact/start
thread/shellCommand
thread/backgroundTerminals/clean
thread/rollback
thread/inject_items
thread/list
thread/loaded/list
thread/read
turn/interrupt
turn/start
windowsSandbox/readiness
windowsSandbox/setupStart
```

This covers the first credential-free headless/runtime path plus thread lifecycle/navigation, auth, account, config, external-agent import, command/process, and Windows sandbox request families that have already been admitted through fixture-backed Haxe and generated Rust gates.

The local subset also validates selected notifications needed by the current headless/app protocol fixtures, including thread/turn lifecycle basics, streaming item deltas, account/rate-limit updates, config warnings, app list updates, realtime output notifications, process output, filesystem change, and selected deprecated notification parity.

## Upstream Gap Summary

Upstream currently exposes 112 quoted client request wire methods in `client_request_definitions!`. After the local 51-method selection, 61 quoted request wires remain outside the local subset.

The remaining requests fall into these groups:

| Group | Missing methods | Priority |
| --- | --- | --- |
| Thread navigation and lifecycle | `thread/resume`, `thread/fork`, `thread/archive`, `thread/unarchive`, `thread/unsubscribe`, `thread/list`, `thread/loaded/list` | Admitted in HXCX-3.63 |
| Thread state and history mutation | `thread/increment_elicitation`, `thread/decrement_elicitation`, `thread/name/set`, `thread/goal/set`, `thread/goal/get`, `thread/goal/clear`, `thread/metadata/update`, `thread/settings/update`, `thread/memoryMode/set`, `thread/compact/start`, `thread/shellCommand`, `thread/approveGuardianDeniedAction`, `thread/backgroundTerminals/clean`, `thread/rollback`, `thread/inject_items`, `memory/reset` | Admitted in HXCX-3.64 |
| Turn and review continuation | `turn/steer`, `review/start`, `thread/turns/list`, `thread/turns/items/list` | High |
| Models and environment | `model/list`, `modelProvider/capabilities/read`, `environment/add`, `experimentalFeature/list`, `experimentalFeature/enablement/set`, `permissionProfile/list`, `collaborationMode/list`, `mock/experimentalMethod` | Medium |
| Apps, skills, hooks, marketplace, plugins | `app/list`, `skills/list`, `skills/extraRoots/set`, `skills/config/write`, `hooks/list`, `marketplace/add`, `marketplace/remove`, `marketplace/upgrade`, `plugin/list`, `plugin/installed`, `plugin/read`, `plugin/skill/read`, `plugin/install`, `plugin/uninstall`, `plugin/share/save`, `plugin/share/updateTargets`, `plugin/share/list`, `plugin/share/checkout`, `plugin/share/delete` | Medium |
| Filesystem remote surface | `fs/readFile`, `fs/writeFile`, `fs/createDirectory`, `fs/getMetadata`, `fs/readDirectory`, `fs/remove`, `fs/copy`, `fs/watch`, `fs/unwatch` | Medium |
| MCP and config reload | `mcpServer/oauth/login`, `config/mcpServer/reload`, `mcpServerStatus/list`, `mcpServer/resource/read`, `mcpServer/tool/call` | Medium |
| Remote control | `remoteControl/enable`, `remoteControl/disable`, `remoteControl/status/read`, `remoteControl/pairing/start`, `remoteControl/pairing/status`, `remoteControl/client/list`, `remoteControl/client/revoke` | Later |
| Realtime client controls | `thread/realtime/start`, `thread/realtime/appendAudio`, `thread/realtime/appendText`, `thread/realtime/stop`, `thread/realtime/listVoices` | Later |
| Fuzzy search requests | `fuzzyFileSearch/sessionStart`, `fuzzyFileSearch/sessionUpdate`, `fuzzyFileSearch/sessionStop` plus legacy `FuzzyFileSearch` | Later |
| Deprecated v1 client requests | `Initialize`, `GetConversationSummary`, `GitDiffToRemote`, `GetAuthStatus` | Explicitly deferred |

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

Upstream also defines client-directed server requests that are distinct from server notifications:

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

These are important for full app-server parity, but they should be admitted after the client-request navigation/thread state slice because they require bidirectional request/response fixture modeling.

## Schema Export Notes

Most modern v2 request families above have standalone schema files under `schema/json/v2`.

Known exceptions:

- `process/spawn`, `process/writeStdin`, `process/kill`, and `process/resizePty` are already selected from upstream Rust DTO/protocol mappings because standalone process request schema files are not exported.
- `thread/increment_elicitation`, `thread/decrement_elicitation`, `thread/settings/update`, `thread/memoryMode/set`, `memory/reset`, and `thread/backgroundTerminals/clean` are selected from upstream Rust DTO/protocol mappings because standalone request/response schema files are not exported in the pinned schema tree.
- `fuzzyFileSearch/sessionStart`, `fuzzyFileSearch/sessionUpdate`, and `fuzzyFileSearch/sessionStop` are Rust DTO/protocol mappings without standalone request/response schema files; their notifications are already tracked through top-level schema files.
- Deprecated v1 request surfaces should remain deferred until a deliberate compatibility slice selects them.

## Sequencing Decision

The next raw upstream slice should admit turn continuation and review/history navigation requests before plugin/MCP/fs/remote/Cafex surfaces:

```text
turn/steer
review/start
thread/turns/list
thread/turns/items/list
```

Rationale:

- these are mainstream Codex app-server methods, not Cafex adapters
- they extend the existing `thread/start`, `thread/read`, lifecycle/navigation, and state/history foundation
- they unlock turn continuation, review entry, and paged turn/item history fixtures
- they keep deprecated v1 APIs and Cafex bridge work out of the core until selected intentionally

## Follow-Up Bead Policy

Every new parity bead should:

- cite the upstream method names and schema/DTO source
- add fixture-backed Haxe validation plus generated Rust coverage
- update schema fingerprint selection, or document why the upstream DTO lacks a standalone schema file
- avoid Cafex adapter code unless the user explicitly asks for Cafex work
- keep Cafex bridge beads blocked until the selected upstream/core queue is exhausted or intentionally paused
