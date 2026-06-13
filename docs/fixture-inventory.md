# Fixture Inventory

**Date:** 2026-06-10  
**Bead:** `HXCX-0.3` / `codex-hxrust-r46.3`  
**Decision:** Use upstream Codex fixtures as the primary parity oracle for M2-M4. Use Cafex/Cafetera fixtures as adapter oracles for M5 and as early inventory only.

## Harness Format

Selected harness input format:

- `reference/fixture-sources.v1.json` records fixture families, owners, paths, stage, and expected use.
- Upstream app-server schemas are consumed in-place from `../codex/codex-rs/app-server-protocol/schema/{json,typescript}` during G0/G1.
- Runtime event fixtures should be represented as JSONL or SSE-event JSON arrays once copied into `fixtures/upstream/`.
- Cafex adapter fixtures stay in-place until M5; copied snapshots must include source path, source commit, and schema id.

The first harness should accept this shape:

```json
{
  "schema": "codex-hxrust.fixture-run.v1",
  "id": "upstream.basic-one-turn",
  "source": "upstream-codex",
  "kind": "sse-sequence",
  "input": {
    "events": []
  },
  "expect": {
    "notifications": [],
    "state": {}
  }
}
```

This keeps one-turn runtime tests credential-free and makes later Cafex receipt fixtures just another harness kind.

## Upstream Codex Fixtures

Owner: upstream Codex / `../codex`, pinned by `reference/upstream-codex.pin.json`.

| Family | Path | Count / shape | Stage | Use |
| --- | --- | --- | --- | --- |
| App-server JSON schemas | `../codex/codex-rs/app-server-protocol/schema/json` | 258 JSON files | M2 primary | Schema fingerprints, DTO shape parity, unknown-field policy |
| App-server TypeScript schemas | `../codex/codex-rs/app-server-protocol/schema/typescript` | 557 TS files | M2 secondary | Cross-check exported names and client-facing protocol shape |
| App-server fixture generator | `../codex/codex-rs/app-server-protocol/src/schema_fixtures.rs` | generator source | M2 primary | Regenerate/compare schema fixture trees |
| App-server fixture tests | `../codex/codex-rs/app-server-protocol/tests/schema_fixtures.rs` | test contract | M2 primary | Defines expected fixture diff semantics |
| Protocol source types | `../codex/codex-rs/protocol/src` | Rust source | M2 primary | Core IDs, config types, openai model DTOs |
| Core SSE/mock response harness | `../codex/codex-rs/core/tests/common/responses.rs`; local fixture `fixtures/upstream/mock-model-basic-one-turn.sse` | Rust test helpers plus credential-free SSE fixture | M3 active | Event names, mock stream structure, request-body invariants |
| Core test harness | `../codex/codex-rs/core/tests/common/test_codex.rs` | Rust test helpers | M3 secondary | Session setup and headless runtime expectations |
| Core snapshot files | `../codex/codex-rs/core/tests/suite/snapshots` | 36 `.snap` files | M3 secondary | Context compaction, pending input, model-visible layout, realtime request shapes |
| TUI story fixture | `../codex/codex-rs/tui/tests/fixtures/oss-story.jsonl`; local selected fixture `fixtures/upstream/oss-story-selected.v1.jsonl` | 1 upstream JSONL file; 1 selected codexhx replay fixture | HXCX-4.8 active | Full-Codex/TUI replay evidence after the runtime event-bus/app-server facade slice |
| TUI render fixtures | `../codex/codex-rs/tui/tests/suite/vt100_history.rs`, `vt100_live_commit.rs`, `status_indicator.rs`; local fixture `fixtures/upstream/vt100-render-selected.v1.json` | Upstream Rust tests plus selected JSON fixture | HXCX-4.9 active | History insertion, live-row commit, ANSI stripping, Unicode width, and word wrapping before interactive terminal ownership |
| Turn runtime reducer fixtures | `../codex/codex-rs/tui/src/chatwidget/turn_runtime.rs`; local fixture `fixtures/upstream/turn-runtime-selected.v1.json` | Selected JSON scenario fixture | HXCX-4.10 active | Task lifecycle, assistant final source rules, plan final/replay flags, queued follow-up/steer bookkeeping, and failure/cancel terminal states |
| Tool JSON schema policy fixtures | `../codex/codex-rs/tools/tests/fixtures/json_schema_policy` | 6 JSON files | M4 secondary | Tool schema filtering/truncation policy examples |
| Config schema | `../codex/codex-rs/core/config.schema.json` plus `core/src/config/schema.rs` | JSON schema plus generator/source | M2/M4 secondary | Config DTO subset and doctor/config validation |
| Runtime app-client facade | `fixtures/hxrust/runtime-app-client.v1.json` | Local upstream-shaped request/notification fixture | HXCX-4.7 | Request correlation, lossless/best-effort event classification, lag/backpressure semantics |
| Runtime bootstrap | `../codex/codex-rs/app-server-protocol/src/protocol/v1.rs`, `../codex/codex-rs/app-server-client/src/{lib.rs,remote.rs}`; local fixture `fixtures/hxrust/runtime-bootstrap.v1.json` | Selected initialize/bootstrap fixture | HXCX-4.11 active | Client info/capabilities, opt-out notification methods, remote vs in-process mode, platform/codex-home response fields, startup account/model/config warnings |
| Fixture live transport | `../codex/codex-rs/app-server-client/src/remote.rs`, `../codex/codex-rs/app-server-transport/src/transport/websocket.rs`; local fixture `fixtures/hxrust/runtime-transport.v1.json` | Selected transport scenario fixture | HXCX-4.12 active | Runtime-facade request/response flow, notification delivery, request cancellation, graceful disconnect, post-disconnect refusal |
| Persistent app-server/TUI state boundary | `../codex/codex-rs/app-server-client/src/lib.rs`, `../codex/codex-rs/app-server/src/thread_state.rs`, `../codex/codex-rs/rollout/src/state_db.rs`, `../codex/codex-rs/thread-store/src/local/mod.rs`; local fixture `fixtures/hxrust/persistence-boundary.v1.json` | Selected metadata/native-boundary decision fixture | HXCX-4.13 active | Portable thread/session/rollout metadata validation, explicit native SQLite/log boundary requirements, fail-closed fixture-vs-production persistence claims |
| Native SQLite persistence pressure | `../codex/codex-rs/rollout/src/state_db.rs`, `../codex/codex-rs/thread-store/src/local/mod.rs`, `../codex/codex-rs/app-server-client/src/lib.rs`, `../codex/codex-rs/app-server/src/in_process.rs`; local fixture `fixtures/hxrust/native-sqlite-persistence.v1.json` | Selected SQLite metadata upsert/readback fixture | HXCX-4.14 active | Metal haxe.rust `sys.db.Sqlite` pressure, mutation-intent gating, invalid metadata refusal, and deterministic row summaries |
| Native SQLite state adapter | `../codex/codex-rs/rollout/src/state_db.rs:350`, `../codex/codex-rs/rollout/src/state_db.rs:441`, `../codex/codex-rs/rollout/src/state_db.rs:474`, `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:2052`; local fixture `fixtures/hxrust/native-state-adapter.v1.json` | Selected SQLite reconcile/query/update/filter fixture | HXCX-4.15 active | Metal haxe.rust `sys.db.Sqlite` adapter pressure, typed command enum, mutation-intent gating, archived-state query filtering, invalid query refusal, and deterministic adapter report summaries |
| Persisted thread read view | `../codex/codex-rs/app-server-protocol/src/protocol/v2/thread.rs:1160`, `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:2035`, `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:2052`, `../codex/codex-rs/thread-store/src/local/read_thread.rs:29`; local fixture `fixtures/hxrust/persisted-thread-read-view.v1.json` | Selected persisted metadata read-view fixture | HXCX-4.16 active | Native adapter-fed read view, typed `ThreadId` requests, include-turns history summaries, include-archived filtering, missing/invalid failures, and deterministic read report summaries |
| Thread/read turn projection | `../codex/codex-rs/app-server-protocol/src/protocol/thread_history.rs:74`, `../codex/codex-rs/app-server-protocol/src/protocol/thread_history.rs:78`, `../codex/codex-rs/app-server-protocol/src/protocol/thread_history.rs:229`, `../codex/codex-rs/app-server-protocol/src/protocol/thread_history.rs:942`, `../codex/codex-rs/app-server/src/request_processors/thread_lifecycle.rs:741`, `../codex/codex-rs/app-server/tests/suite/v2/thread_read.rs:138`; local fixture `fixtures/hxrust/thread-read-turn-projection.v1.json` | Selected rollout item turn-summary projection fixture | HXCX-4.17 active | Explicit/implicit turn grouping, user/assistant/command/compaction summaries, failed active turns, malformed item refusal, and deterministic report summaries |

Initial upstream M2 subset:

1. `ClientRequest.json`
2. `ClientNotification.json`
3. `ServerRequest.json`
4. `ServerNotification.json`
5. `RequestId.json`
6. `v2/ThreadStartParams.json`
7. `v2/ThreadStartResponse.json`
8. `v2/TurnStartParams.json`
9. `v2/TurnStartResponse.json`
10. `v2/TurnStartedNotification.json`
11. `v2/TurnCompletedNotification.json`
12. `v2/ErrorNotification.json`

These are enough to start protocol IDs/newtypes, JSON-RPC envelope handling, thread/turn DTOs, and one-turn event ordering without pulling in every app-server surface.

Initial upstream M3 subset:

1. Use `core/tests/common/responses.rs` as the source for SSE event constructors and request-body invariants.
2. Create new, small JSON/SSE fixtures instead of copying all Rust tests. The first accepted M3 fixture is `mock-model-basic-one-turn.sse`, with normalized event golden `mock-model-basic-one-turn.events.golden.json`.
3. Treat core snapshots as comparison inspiration, not hard-blocking parity until the Haxe runtime can emit equivalent artifacts.

## Cafex / Cafetera Fixtures

Owner: Cafetera Codex module / `../fullofcaffeine/tools/cafetera/modules/codex`, with Cafex runtime source pinned by `reference/cafex-codex.pin.json`.

| Family | Path | Count / shape | Stage | Use |
| --- | --- | --- | --- | --- |
| Cafex contract tests | `../fullofcaffeine/tools/cafetera/modules/codex/tests/contract` | 93 `.mjs` files | M5 primary | Adapter acceptance contracts, especially receipts/restart/effort/wake/goals |
| Fork seam ledger | `../fullofcaffeine/tools/cafetera/modules/codex/tests/fixtures/cafex-fork-seam-ledger.v1.json` | schema `cafetera.codex.cafex-fork-seam-ledger.v1`, task `f12e-cafexcc4e6` | M5 primary | Supported/unsupported Cafex seam ledger |
| Hxrust Cafex seam ledger | `fixtures/cafex/cafex-hxrust-seam-ledger.v1.json` | schema `codex-hxrust.cafex-hxrust-seam-ledger.v1`, bead `HXCX-5.6` | M5 primary | Maps Cafex fork seams to hxrust implementation, fixtures, patch classes, and replacement status |
| Hxrust Cafex friction comparison | `fixtures/cafex/cafex-hxrust-friction-comparison.v1.json` | schema `codex-hxrust.cafex-hxrust-friction-comparison.v1`, bead `HXCX-6.1` | M6 primary | Counts Cafex patch-stack surface versus hxrust wrapper/fixture/gate burden and feeds the replacement decision record |
| Apply-patch dry-run | `fixtures/hxrust/apply-patch-dry-run-output.v1.jsonl` | schema `codex-hxrust.apply-patch-dry-run.v1`, bead `HXCX-4.1` | M4 primary | Validates dry-run operation counting, mutation-disabled default, and deterministic wrapper errors |
| Process exec wrapper | `fixtures/hxrust/process-exec-output.v1.jsonl` | schema `codex-hxrust.process-exec.v1`, bead `HXCX-4.2` | M4 primary | Validates denied-by-default execution, exact approval, sandbox marker proof, stdout/stderr truncation, and exit-code mapping |
| Sandbox permission gate | `fixtures/hxrust/sandbox-gate-output.v1.jsonl` | schema `codex-hxrust.sandbox-gate-decision.v1`, bead `HXCX-4.3` | M4 primary | Validates fail-closed unsupported platforms, sandbox policy decisions, absent bypass path, and security denials |
| Diagnostics redaction | `fixtures/hxrust/diagnostics-output.v1.jsonl` | schemas `codex-hxrust.diagnostic-log.v1`, `codex-hxrust.failure-report.v1`, bead `HXCX-4.6` | M4 primary | Validates configured secret redaction and fixture IDs in failure reports |
| Runtime DTO conformance | `../fullofcaffeine/tools/cafetera/modules/codex/tests/fixtures/cafex-runtime-dto-conformance.v1.json` | schema `cafetera.codex.runtime-dto-conformance-fixture.v1` | M5 primary | DTO compatibility, unknown-field/additive behavior, fail-closed unsupported schemas |
| Boundary fixture gate | `../fullofcaffeine/tools/cafetera/modules/codex/tests/fixtures/cafex-boundary-rust-fixture-gate.v1.json` | schema `cafetera.codex.cafex-boundary-rust-fixture-gate.v1`, task `f12e-cafexe37c5` | M5 secondary | Native boundary evidence and rust-role policy |
| App wrapper control surface | `../fullofcaffeine/tools/cafetera/modules/codex/tests/fixtures/codex-app-wrapper-control-surface.v1.json` | schema `cafetera.codex.app-wrapper-control-surface-profile.fixture.v1`, task `f12e-codexf6ec7` | M5 secondary | Wrapper capability expectations |
| App wrapper route probe | `../fullofcaffeine/tools/cafetera/modules/codex/tests/fixtures/codex-app-wrapper-route-probe.v1.json` | schema `cafetera.codex.app-wrapper-route-probe.v1` | M5 secondary | Route/capability probe expectations |
| Portable agent client settings | `../fullofcaffeine/tools/cafetera/modules/codex/tests/fixtures/portable-agent-client-settings.v1.json` | schema `cafetera.agent-client.settings.fixture.v1`, task `f12e-porta80836` | later | Portable settings/lowering policy |
| Cafex runtime patch evidence | `../fullofcaffeine/tools/cafetera/modules/codex/runtime/patches/0001-cafex-runtime-0.135.patch` | patch file | M5 evidence | Schema/env/behavior discovery, not a fixture to execute |

Initial Cafex M5 subset:

1. `cafex-runtime-dto-conformance.v1.json`
2. `cafex-fork-seam-ledger.v1.json`
3. Contract tests:
   - `cli_codex_cafex_fork_seam_ledger_contract.mjs`
   - `cli_codex_cafex_runtime_dto_conformance_contract.mjs`
   - `cli_codex_module_effort_apply_contract.mjs`
   - `cli_codex_module_mode_apply_contract.mjs`
   - `cli_codex_module_queue_reconcile_contract.mjs`
   - `cli_codex_goal_apply_contract.mjs`
   - `cli_codex_module_restart_payload_contract.mjs`
   - `cli_codex_wake_same_process_contract.mjs`

Do not run these against the Haxe runtime until the upstream-shaped core and adapter boundary exist.

## Unsupported Or Missing Fixtures

Track these gaps before claiming parity:

| Gap | Status | Follow-up |
| --- | --- | --- |
| No standalone upstream one-turn JSON fixture | Resolved for M3 seed | `mock-model-basic-one-turn.sse` covers created, text delta, assistant message done, and completed events using upstream SSE event names |
| No upstream Haxe DTO golden files | Covered for first app-protocol subset | `reference/app-protocol-schema-fingerprints.v1.json` and `harness/check-schema-fingerprints.sh`; expand beyond the first M2 subset as DTO coverage grows |
| Local fixture tree | Active | Keep copied fixture subsets under `fixtures/{upstream,cafex,hxrust}/` and record provenance under `reference/` |
| Cafex fixtures are adapter-only | Intentional | Keep them inactive until M5 |
| Full TUI fixtures | Selected story replay and render invariants active | HXCX-4.8 adapts `oss-story.jsonl`; HXCX-4.9 adapts VT100/history/render invariants before interactive terminal ownership |
| Live model/provider traffic | Unsupported | Use mock SSE/JSONL only |
| Real process/sandbox mutation fixtures | Unsupported until M4 | Start with dry-run/denied-by-default wrappers |
| App-server full 815-file schema tree | Too broad for first DTO pass | Use initial M2 subset, then expand by scorecard |

## Copy Rules

When a fixture moves from reference to local copy:

1. Copy only the smallest useful fixture, not whole source directories.
2. Put it under `fixtures/{upstream,cafex,hxrust}/`.
3. Add manifest metadata: source pin name, source path, source commit, copy date, schema id if any, owner, stage, and oracle purpose.
4. Keep generated fixtures reproducible from source whenever possible.
5. Do not edit copied upstream fixtures by hand; create Haxe-specific expected-output fixtures separately.

## Next Consumers

This inventory unblocks:

- `HXCX-0.4` parity scorecard and hard kill criteria
- `HXCX-2.1` core protocol IDs and newtypes
- `HXCX-2.2` typed JSON boundary policy
- `HXCX-3.1` mock stream parser
- `HXCX-5.5` Cafetera contract subset
- `HXCX-8.2` Caf active-lane capability advertisement fixtures
