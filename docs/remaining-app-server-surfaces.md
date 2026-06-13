# Remaining App-Server Surface Decision

This records the HXCX-3.68 decision for upstream/raw Codex app-server compatibility after the app/plugin/filesystem/MCP/model families were admitted.

The guiding rule is unchanged: raw upstream Codex comes first, Cafex/Cafetera adapters come later. These surfaces are protocol/runtime/TUI foundations for the mainstream Codex port, not Cafex bridge work.

## Decision Table

| Surface | Upstream methods | Decision | Follow-up |
| --- | --- | --- | --- |
| Small experimental protocol gates | `environment/add`, `collaborationMode/list` | Admitted in HXCX-3.69. These are first-class upstream protocol variants and support remote execution environment selection plus collaboration-mode UI state. The local subset uses Rust DTO/protocol source because standalone JSON files are absent. | `codex-hxrust-49i` |
| Thread search | `thread/search` | Admitted in HXCX-3.70. This is mainstream app navigation/search parity and should precede TUI/live-runtime sequencing. | `codex-hxrust-hrq` |
| Fuzzy search session API | `fuzzyFileSearch/sessionStart`, `fuzzyFileSearch/sessionUpdate`, `fuzzyFileSearch/sessionStop` | Admitted in HXCX-3.71. Notifications were already admitted; request/response parity now travels with them before TUI search work. The local subset uses Rust DTO/protocol source because standalone request schemas are not exported. | `codex-hxrust-a4r` |
| Realtime client controls | `thread/realtime/start`, `thread/realtime/appendAudio`, `thread/realtime/appendText`, `thread/realtime/stop`, `thread/realtime/listVoices` | Select, but after search/fuzzy. These are required for full TUI voice/realtime parity. Start with protocol fixtures and deterministic runtime fakes before live audio/network behavior. | New implementation bead |
| Remote control | `remoteControl/enable`, `remoteControl/disable`, `remoteControl/status/read`, `remoteControl/pairing/start`, `remoteControl/pairing/status`, `remoteControl/client/list`, `remoteControl/client/revoke` | Select after realtime protocol controls. This is app-server/daemon functionality with account/network behavior, so the first slice should be protocol fixtures plus deterministic status/pairing/client DTO validation. | New implementation bead |
| Deprecated v1 compatibility | `getConversationSummary`, `gitDiffToRemote`, `getAuthStatus`, legacy `fuzzyFileSearch` | Select as an isolated compatibility slice only. It must not shape the modern v2 Haxe API. Keep fixtures explicit and mark deprecated in docs/tests. | New implementation bead |
| Initial v1 handshake | `initialize` plus `InitializeParams`/`InitializeResponse` | Defer to app-server transport/bootstrap parity. This is protocol-session setup rather than a normal v2 app method and should be handled with the eventual app-server/TUI process harness. | Covered by TUI/live-runtime sequencing |
| Test-only experimental gate | `mock/experimentalMethod` | Unsupported for production behavior. Keep as an upstream capability-gating reference only; do not add it to the runtime or product protocol subset unless a dedicated test-harness-only bead asks for it. | No implementation bead |

## Upstream Anchors

The relevant upstream declarations are in `../codex/codex-rs/app-server-protocol/src/protocol/common.rs`:

- `ThreadSearch => "thread/search"`
- `ThreadRealtimeStart`, `ThreadRealtimeAppendAudio`, `ThreadRealtimeAppendText`, `ThreadRealtimeStop`, and `ThreadRealtimeListVoices`
- `RemoteControlEnable`, `RemoteControlDisable`, `RemoteControlStatusRead`, `RemoteControlPairingStart`, `RemoteControlPairingStatus`, `RemoteControlClientsList`, and `RemoteControlClientsRevoke`
- `CollaborationModeList => "collaborationMode/list"`
- `EnvironmentAdd => "environment/add"`
- legacy `GetConversationSummary`, `GitDiffToRemote`, `GetAuthStatus`, `FuzzyFileSearch`
- `FuzzyFileSearchSessionStart`, `FuzzyFileSearchSessionUpdate`, and `FuzzyFileSearchSessionStop`
- `MockExperimentalMethod => "mock/experimentalMethod"` as a test-only method-level experimental gate

The upstream app-server README documents the expected behavior for these request families. The TUI uses realtime controls in `../codex/codex-rs/tui/src/app_server_session.rs` and `../codex/codex-rs/tui/src/chatwidget/realtime.rs`, so realtime request parity must land before meaningful TUI voice parity.

## Schema And Fixture Policy

Standalone JSON schema exports are incomplete for this remaining set:

- `thread/search` and several response/result DTOs are present in bundled schema/TypeScript output rather than standalone request/response JSON files.
- `environment/add`, `collaborationMode/list`, realtime request controls, remote-control request controls, and fuzzy session request controls are first-class Rust protocol variants, but not all of their request/response DTOs appear as standalone `schema/json/v2/*.json` files.
- Fuzzy session notifications and realtime notifications already have selected notification schema coverage.
- Deprecated v1 methods have top-level legacy schema exports and must stay outside the modern v2 API shape.

Each selected implementation bead should therefore:

- add request and response fixture pairs to `fixtures/hxrust/app-protocol-roundtrip.v1.json`
- extend Haxe validation in `src/codexhx/protocol/app/AppProtocol.hx`
- update `AppProtocolHarness` counts and negative cases
- update docs and schema fingerprint selection where standalone or bundled schemas are available
- run Haxe interpreter plus generated Rust gates
- avoid Cafex adapter code

## Sequencing

The intended implementation order is:

1. `environment/add` and `collaborationMode/list` - admitted in HXCX-3.69
2. `thread/search` - admitted in HXCX-3.70
3. fuzzy search session requests - admitted in HXCX-3.71
4. realtime client controls
5. remote-control request controls
6. deprecated v1 compatibility
7. TUI/live-runtime sequencing

This lets the full Codex port keep advancing from deterministic protocol parity toward app-server runtime and TUI behavior without letting legacy or Cafex-specific work distort the core Haxe API.
