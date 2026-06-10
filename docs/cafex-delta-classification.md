# Cafex Delta Classification

**Date:** 2026-06-10  
**Bead:** `HXCX-0.2` / `codex-hxrust-r46.2`  
**Purpose:** Classify Cafex-only and Cafex-modified runtime behavior into replacement slices for a pure Haxe Codex port using haxe.rust.

## Base Decision

Build the Haxe port from mainstream upstream Codex first, then adapt Cafex as a compatibility layer. Upstream Codex is the core product/protocol baseline; Cafex contributes required extension seams and contract fixtures. This keeps the Haxe runtime from inheriting fork-only structure too early while still making Cafex compatibility a first-class later gate.

Practical consequences:

1. Upstream protocol/config/app-server/headless runtime DTOs are implemented before Cafex extensions.
2. Cafex schemas live under an explicit adapter namespace/module, not interleaved as the default Codex model.
3. Any Cafex behavior marked `headless candidate` must prove it can sit on top of the upstream-shaped core.
4. Any Cafex behavior that requires TUI queue ownership, process restart, sandbox enforcement, or external Caf/Brew authority stays behind a wrapper or remains deferred.
5. During M0, Cafex work is inventory only. Implementation begins in M5 after upstream DTO, headless runtime, and native boundary gates exist.

## Source Ledgers

Primary local sources:

- `docs/baseline-topology.md`
- `../fullofcaffeine/deps/codex/codex-rs/core/src/caf_runtime.rs`
- `../fullofcaffeine/deps/codex/codex-rs/core/src/goals.rs`
- `../fullofcaffeine/deps/codex/codex-rs/tui/src/caf_effort_control.rs`
- `../fullofcaffeine/tools/cafetera/modules/codex/docs/ref/cafex-fork-seam-ledger-v1.md`
- `../fullofcaffeine/tools/cafetera/modules/codex/tests/fixtures/cafex-fork-seam-ledger.v1.json`
- `../fullofcaffeine/tools/cafetera/modules/codex/tests/fixtures/cafex-runtime-dto-conformance.v1.json`
- `../fullofcaffeine/tools/cafetera/modules/codex/runtime/patches/0001-cafex-runtime-0.135.patch`

The local Cafetera seam ledger is tied to Brew task `f12e-cafexcc4e6`. The Beads backlog acceptance criterion mentions `f12e-class32f27`, but that task id was not found in this workspace or in the local Cafetera Codex module refs. For this experiment, `f12e-class32f27` is superseded by `HXCX-0.2`, with `f12e-cafexcc4e6` retained as the concrete external seam-ledger reference.

## Slice Definitions

| Slice | Meaning | Default haxe.rust profile |
| --- | --- | --- |
| `helper-only` | DTOs, codecs, schema constants, fixture transforms, reports, and static validation helpers. No live Codex runtime authority. | `portable` |
| `headless candidate` | Runtime behavior that can be expressed as deterministic state transitions, filesystem DTO IO, or non-TUI orchestration before live process integration. | `portable`, with selective `@:haxeMetal` checks only if needed |
| `native-wrapper candidate` | Behavior that needs live process, TUI/event-loop, terminal, OS process, sandbox, SQLite, network, or external command authority. Haxe owns contracts; a narrow native boundary owns the host effect. | `metal` island or typed extern wrapper |
| `out-of-scope` | Not part of the upstream-first core or first Cafex adapter pass. Keep as fixture evidence or defer until a later runtime/UI phase. | none |

## Classification Table

| Delta | Owner / seam | Category | Primary evidence | Slice | Porting rationale |
| --- | --- | --- | --- | --- | --- |
| Active-lane capability advertisement | `@cafetera/codex`; `caf-runtime-active-lane-capabilities` | receipts / runtime capability | `caf_runtime.rs`; `cafetera.codex.active-lane.v1`; `cafetera.codex.native-live-status.v1`; `CAF_CODEX_ACTIVE_LANE_PATH`; `CAF_CODEX_PID` | `headless candidate` | The file format, capability lists, pid proof policy, and fail-closed missing-env behavior can be ported as pure DTO/state first. Live ownership proof remains a later host integration concern. |
| Session receipt | `@cafetera/codex`; restart/session continuity | receipts / continuity | `caf-client-session.v1`; `CAF_CODEX_SESSION_RECEIPT_PATH`; `CAF_CODEX_RUN_ID`; `CAF_CODEX_SUCCESSOR_RUN_ID`; `CAF_CODEX_PREDECESSOR_SESSION` | `headless candidate` | Deterministic pretty-JSON receipt writing and idempotency are suitable for early Haxe parity tests. |
| Turn receipt | `@cafetera/codex`; restart/session continuity | receipts / turn accounting | `caf-client-turn.v1`; `CAF_CODEX_TURN_RECEIPT_PATH`; native live status embedding | `headless candidate` | Can be implemented once a minimal headless turn context exists. Model execution is not required to validate receipt shape. |
| Native live status DTO | `@cafetera/codex`; active lane and runtime DTO conformance | status / proof DTO | `cafetera.codex.native-live-status.v1`; DTO conformance fixture; current model/reasoning/mode fields | `helper-only` first, then `headless candidate` | Start with schema constants and fixture decode/encode. Promote to headless once collaboration-mode state exists in Haxe. |
| Effort apply bridge | `@cafetera/codex`; `effort-mode-runtime-bridge` | effort / model state | `cafetera.codex.effort-apply-request.v1`; `cafetera.codex.effort-apply.v1`; `CAF_CODEX_EFFORT_REQUESTS_DIR`; `CAF_CODEX_EFFORT_RECEIPTS_DIR` | `headless candidate` | Directory scan, validation, request dedupe, lifecycle receipt, and next-turn state update can be modeled headlessly. Live AppEvent delivery is a later wrapper detail. |
| Collaboration-mode apply bridge | `@cafetera/codex`; `effort-mode-runtime-bridge` | mode / collaboration state | `cafetera.codex.mode-apply-request.v1`; `cafetera.codex.mode-apply.v1`; collaboration mode presets | `headless candidate` | Mode token parsing, mask selection, lifecycle receipt, and required planning mode checks are pure enough for the first state-machine slice. |
| Apply lifecycle envelope | `@cafetera/codex`; effort/mode/wake/restart/request receipts | receipt lifecycle | `cafetera.codex.apply-lifecycle.v1`; queued/applied/observed state fields | `helper-only` | Implement as shared DTO builder and test fixture oracle before attaching it to runtime queues. |
| Wake bridge | `@cafetera/codex`; `restart-wake-session-continuity` | wake / queued continuation | `caf-client-wake-request.v1`; `caf-client-wake-receipt.v1`; `CAF_CODEX_WAKE_REQUESTS_DIR`; `CAF_CODEX_WAKE_RECEIPTS_DIR`; `SubmitWakeContinuation` | `native-wrapper candidate` | Request/receipt parsing can be helper-only, but live semantics depend on TUI input queues, turn state, and bridge continuation delivery. |
| Oracle delegate wake suppression | `@cafetera/codex`; wake bridge | wake / stale external wait suppression | wake request `goalResumeAuthority`; wait artifact refs; stale/missing temp checks | `native-wrapper candidate` | The policy can be fixture-backed in Haxe, but true authority depends on external wait artifacts and current lane state. |
| Restart apply bridge | `@cafetera/codex`; `restart-wake-session-continuity` | restart / process lifecycle | `cafetera.codex.restart-apply-request.v1`; `cafetera.codex.restart-apply.v1`; `cafetera.codex.runtime-restart-action.v1`; pending restart sidecar | `native-wrapper candidate` | Haxe can own request validation and receipt shape, but post-shutdown exec, inherited env, pid handoff, and terminal ownership must remain a narrow native boundary. |
| Pending input snapshot | `@cafetera/codex`; restart/wake/session continuity | restart / queued input state | `cafetera.codex.pending-input.v1`; `CAF_CODEX_PENDING_INPUT_SNAPSHOT_PATH`; input queue snapshot tests | `headless candidate` | Snapshot shape and ordering can be pure Haxe. Extracting live TUI queues is native-wrapper work later. |
| Queue reconcile bridge | `@cafetera/codex`; `queue-reconcile-runtime-bridge` | queue / plan checkpoint state | `cafetera.codex.queue-reconcile-request.v1`; `cafetera.codex.queue-reconcile-receipt.v1`; `reconcile_caf_plan_checkpoint_queues` | `native-wrapper candidate` | DTOs are helper-only, but actual queue mutation interacts with the running chat widget and must be wrapped until the Haxe runtime owns queues. |
| Goal apply bridge | `@cafetera/codex plus cafetera.ralph`; `goal-apply-runtime-bridge` | goals / external closure | `cafetera.codex.goal-apply-request.v1`; `cafetera.codex.goal-apply.v1`; `cafetera.ralph.codex-goal-bridge.v1` | `headless candidate` | The first port can model request validation, status transitions, and receipt generation without the TUI menu. Live app-server/store hooks are later wrapper work. |
| Goal runtime accounting | `@cafetera/codex plus cafetera.ralph` | goals / persistent state / app-server | `core/src/goals.rs`; `state/src/runtime/goals.rs`; `goals_1.sqlite`; `thread/goal/*` methods and notifications | `headless candidate` | The semantic state machine should be Haxe-owned. SQLite and app-server transport can be deferred behind adapters. |
| Ralph external-gate goal continuation | `@cafetera/codex plus cafetera.ralph` | goals / continuation authority | startup auto-resume checks; external gate objective text markers; target closure digest fields | `headless candidate` with later `native-wrapper candidate` | Text/policy classification can be pure. Startup resume and live continuation dispatch need host integration. |
| Plan checkpoint continuation guard | `@cafetera/codex plus cafetera.brew`; `plan-checkpoint-continuation-guard` | TUI / plan checkpoint / queue | `caf_plan_checkpoint.rs`; `cafetera.brew.plan-checkpoint-status.v1`; `cafetera.codex.plan-checkpoint-accept-execution.v1` | `out-of-scope` until later adapter/UI work | Keep DTO fixtures and kill criteria, but do not port full visible-plan/TUI continuation behavior until the Haxe runtime has queue ownership. |
| Native current-turn plan proof | `@cafetera/codex plus cafetera.brew`; plan checkpoint guard | proof / runtime status | `cafetera.codex.native-current-turn-plan-proof.v1`; model/effort/mode/run/continuity fields | `helper-only` first, then `headless candidate` | Encode/decode and fixture comparison are immediate. Actual proof emission depends on current-turn state. |
| Planning runtime gate | `@cafetera/codex plus cafetera.brew`; plan checkpoint guard | proof / guard receipt | `cafetera.codex.planning-runtime-gate.v1`; required vs observed model/effort/mode | `helper-only` first | Useful as a fixture oracle and future guard; not needed to run a headless turn. |
| Plan checkpoint auto-continue receipts | `@cafetera/codex plus cafetera.brew`; plan checkpoint guard | plan checkpoint / sidecar receipts | `cafetera.codex.plan-checkpoint-auto-continue.v1`; `cafetera.codex.plan-checkpoint-accept-execution.v1` | `out-of-scope` until later adapter/UI work | Depends on visible plan capture and external Brew command authority. Preserve DTOs only. |
| Jail session projection | `@cafetera/codex`; sandbox/security seam | sandbox / mutating tool policy | `CAF_CODEX_JAIL_ENFORCEMENT`; `CAF_CODEX_JAIL_SESSION_PROJECTION_JSON`; `cafetera.codex.jail-session-projection.v1` | `native-wrapper candidate` | Security gates must fail closed. Haxe can decode projection DTOs, but mutating tool dispatch and sandbox enforcement need a native host boundary. |
| Module manifest strict decode | `@cafetera/codex`; module manifest seam | manifest / config | `cafetera.module.manifest.v1`; strict schema decode | `helper-only` | Pure DTO validation with good fixture coverage; a good early proof of portable haxe.rust suitability. |
| Live status refresh bridge | `@cafetera/codex`; active lane/status seam | status / request receipt | `cafetera.codex.live-status-refresh-request.v1`; `cafetera.codex.live-status-refresh.v1` | `headless candidate` | Refresh request handling is small and can be modeled as a state-to-receipt transform before live UI integration. |
| Agent control and Ralph control DTOs | `@cafetera/codex plus cafetera.ralph` | external control | `cafetera.agent.control-action.v1`; `cafetera.agent.control-receipt.v1`; `cafetera.ralph.control-decision.v1` | `helper-only` | Keep constants and codecs for later compatibility; no runtime authority in the upstream-first core. |
| Debug client workspace member | `@cafetera/codex` | debug tooling / app-server | Cafex-only `debug-client` workspace member | `out-of-scope` first | Useful later for app-server parity testing, but not required for the first Haxe core/protocol runtime. |
| Cloud requirements workspace member | `@cafetera/codex` | config / cloud preflight | Cafex-only `cloud-requirements` workspace member; `config/src/cloud_requirements.rs` | `helper-only` | Treat as config DTO/policy data when config parity starts. It should not drive the initial runtime replacement. |
| Reasoning override slash commands | `@cafetera/codex` | TUI command affordance | `/reasoning` Caf command strings; `CAF_CODEX_CAF_BIN` | `out-of-scope` first | TUI slash-command affordances are not part of the headless runtime. Later replacement should call typed Haxe/Caf interfaces, not shell-string logic. |
| TUI goal/status/menu affordances | `@cafetera/codex plus cafetera.ralph` | TUI | `goal_status.rs`; `goal_menu.rs`; goal editor/status display | `out-of-scope` first | Preserve underlying goal state semantics, but defer interactive rendering and menus. |
| Fork lineage and upstream sync | `@cafetera/codex`; `fork-lineage-upstream-sync` | governance / migration | `caf-fork-lineage.v1`; `caf-fork-sync-receipt.v1`; runtime sync receipts | `helper-only` | This belongs in repository governance and reporting. It should inform vendoring/upstream sync tasks rather than runtime logic. |

## Later Cafex Adapter Slice

The first Cafex adapter slice, after the upstream-shaped Haxe core exists, should support these surfaces:

1. Schema constants and codecs for active lane, native live status, apply lifecycle, effort/mode/goal/wake/restart/queue receipts, module manifest, and jail projection.
2. Fixture decode/encode parity against `cafex-runtime-dto-conformance.v1.json` and seam-ledger JSON.
3. Headless adapter behavior for active-lane, session receipt, turn receipt, effort apply, mode apply, minimal goal apply, pending-input snapshot, and live-status refresh state transitions.
4. Shared receipt lifecycle helpers that guarantee pretty JSON plus trailing newline where Cafex depends on that shape.
5. Fail-closed unknown schema behavior and additive unknown-field compatibility where the DTO conformance fixture requires it.

## Explicitly Deferred

These are not commitments for the upstream-first M2-M4 core, and remain deferred until the Cafex adapter gate or later:

- Full Ratatui/TUI rendering and interactive menus.
- Live chat-widget queue mutation and bridge continuation dispatch.
- Actual runtime restart exec or terminal foreground ownership.
- Sandbox/jail enforcement beyond DTO decode and fail-closed policy modeling.
- Full app-server transport, app-server notifications, and SQLite-backed goal persistence.
- Provider network/model streaming, MCP transport, apply-patch execution, and OS sandboxing.
- Brew plan-checkpoint auto-accept execution and visible-plan UI workflow.

## Porting Order Implications

1. Implement upstream Codex DTO/codecs first in portable Haxe and run upstream fixture oracles.
2. Build the upstream-shaped headless one-turn runtime before Cafex behavior is active.
3. Add Cafex helper-only schemas and fixtures as passive adapter preparation.
4. Promote deterministic Cafex receipt/state behaviors into adapter modules only after the upstream core has semantic tests.
5. Define native-wrapper interfaces only after a headless semantic test exists.
6. Keep native wrappers narrow, typed, and fail-closed; Haxe should own schema constants, policy decisions, and expected receipt shape.
7. Treat TUI and restart behaviors as later integration layers, not blockers for the upstream-first Haxe port.
