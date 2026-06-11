# PRD: Codex via `haxe.rust` / `hxrust`

**Status:** Draft / experiment plan  
**Date:** 2026-06-10  
**Working name:** `codex-hxrust`  
**Tracker:** Beads (`bd`)  
**Input snapshots inspected:**

- `codex-upstream`: upstream Codex snapshot, primarily `codex-rs/`
- `fullofcaffeine/cafetera`: Cafetera plus the Cafex Codex fork under `deps/codex/` and Codex module runtime trees
- `haxe.rust`: `reflaxe.rust`, the Haxe-to-Rust target

---

## 1. Executive summary

This project is an experiment to test whether a Codex-compatible runtime can be authored in Haxe and compiled to Rust through `haxe.rust` (`reflaxe.rust` / `hxrust`) with enough quality, predictability, and integration fidelity to eventually replace some or all of the Cafex fork used by Cafetera.

The attached upstream Codex snapshot is already a Rust workspace, not a JavaScript or TypeScript system that needs a conventional language port. The right framing is therefore:

> Build a Haxe-authored, Rust-emitted Codex-compatible implementation, starting with a narrow headless/runtime subset, and prove parity against upstream Codex plus Cafex-specific seams before considering replacement of the existing fork.

This PRD intentionally keeps the first phase small and evidence-driven. It does **not** declare `haxe.rust` production-ready for the whole Codex runtime up front. It creates a gated path where `haxe.rust` is stressed by a real production-shaped workload: protocol DTOs, event streams, session state, tool execution boundaries, Caf receipts, goal state, effort controls, wake/restart continuity, and generated Rust build/test hygiene.

The result should be one of three outcomes:

1. **Helper-only win:** `haxe.rust` is useful for Rust DTOs, codecs, validators, fixtures, and conformance harnesses, but not as a runtime replacement.
2. **Sidecar/headless win:** `haxe.rust` can produce a usable Codex-compatible headless runtime for selected workflows, but Cafex remains the production fork.
3. **Replacement candidate:** `haxe.rust` passes hard gates and becomes a credible candidate to replace selected Cafex fork slices, with a later plan for broader replacement.

---

## 2. Problem statement

Cafetera currently carries Cafex, a Codex fork with Caf-specific runtime behavior. This fork is valuable because it lets Cafetera prove native runtime facts, emit receipts, bridge Caf effort/mode controls, handle goals, and maintain wake/restart/session continuity. It also creates ongoing rebase and fork-maintenance pressure against upstream Codex.

The project wants to explore a different implementation path: author Codex-compatible behavior in Haxe and emit Rust via `haxe.rust`. The hypothesis is that a Haxe source of truth might eventually reduce fork maintenance, improve Caf-owned semantic clarity, and provide a hard production-readiness test for `haxe.rust`.

This is risky because Codex is a large Rust workspace with deep async, process, sandbox, terminal, protocol, model-streaming, state, and app-server behavior. Cafex also has fork-specific seams that are intentionally bound to Cafetera contracts. A naive file-by-file rewrite would almost certainly fail or create a second semantic authority.

The plan must therefore be contract-first, subset-first, fixture-driven, and reversible.

---

## 3. Source snapshot findings

### 3.1 Upstream Codex snapshot

The upstream snapshot contains a large Rust workspace under `codex-rs/`.

Observed workspace characteristics:

- `codex-rs/Cargo.toml` lists **118 workspace members**.
- Workspace package metadata uses Rust edition 2024 and Apache-2.0 licensing.
- High-centrality internal crates include:
  - `codex-protocol`
  - `codex-core`
  - `codex-config`
  - `codex-login`
  - `codex-app-server-protocol`
  - `codex-utils-absolute-path`
- Large/high-risk components include:
  - `core`: sessions, model interaction, tool orchestration, rollout/thread manager, config, sandbox policy, MCP (Model Context Protocol), skills, exec handling, and runtime policy.
  - `app-server`: app-server transport, JSON-RPC-style request processing, websocket/control-socket behavior, and protocol glue.
  - `tui`: terminal UI behavior, keyboard handling, rendering, snapshots, and interactive UX.
  - `protocol` / `app-server-protocol`: event, request, response, and schema surfaces.

Implication: this should not be treated as a single “port Codex” task. It must be decomposed into compatibility slices.

### 3.2 Cafex / Cafetera snapshot

Cafex is present in the Cafetera snapshot under `deps/codex/`, with Codex workspace package version `0.135.0`. Cafetera also includes Codex module runtime trees and many module-level contracts/tests.

Notable Cafex-specific runtime additions include:

- `core/src/caf_runtime.rs`
- `core/tests/suite/caf_runtime.rs`
- `tui/src/caf_effort_control.rs`
- `core/src/goals.rs`
- `core/src/context/goal_context.rs`
- `core/src/context/fragments.rs`
- goal-related tool handlers under `core/src/tools/handlers/`
- `core/src/tools/tool_search_entry.rs`
- `debug-client/*`
- `config/src/cloud_requirements.rs`
- `core-plugins/src/startup_remote_sync.rs`

Important Cafex seams found in the snapshot:

- **Session and turn receipts** using environment variables such as:
  - `CAF_CODEX_TURN_RECEIPT_PATH`
  - `CAF_CODEX_SESSION_RECEIPT_PATH`
  - `CAF_CODEX_SUCCESSOR_RUN_ID`
  - `CAF_CODEX_PREDECESSOR_SESSION`
- **Effort and wake bridges** using directories such as:
  - `CAF_CODEX_EFFORT_REQUESTS_DIR`
  - `CAF_CODEX_WAKE_REQUESTS_DIR`
  - `CAF_CODEX_EFFORT_RECEIPTS_DIR`
  - `CAF_CODEX_WAKE_RECEIPTS_DIR`
- **Goal runtime support**, including state, protocol, tool handlers, context fragments, prompt continuation behavior, and state-db bridges.
- **Fork seam governance**, with Cafetera docs distinguishing Caf semantic ownership from native Rust runtime witness behavior.

Implication: a replacement experiment must prove Cafex seam parity, not merely compile generated Rust.

### 3.3 Existing Cafetera direction around `haxe.rust`

The Cafetera snapshot already contains research/task history that treats `haxe.rust` as promising but not yet a replacement for Codex Rust. Prior notes point toward `haxe.rust` for helper-generated Rust surfaces such as DTOs, codecs, validators, fixtures, and enum/newtype mirrors, while keeping native runtime truth in direct Rust.

This PRD intentionally proposes a controlled experiment that goes beyond that prior helper-only stance, but it does not overturn it. The experiment must preserve the existing boundary until the replacement gates pass.

### 3.4 `haxe.rust` snapshot

The `haxe.rust` snapshot is a Haxe 4.3.7 to Rust target built on Reflaxe.

Observed capabilities and posture:

- Two practical profiles:
  - `portable`: default, safer for pure logic and broad Haxe compatibility.
  - `metal`: Rust-first profile for stricter/native interop and performance-sensitive/runtime work.
- Generated Cargo workflows are supported through `rust_output`, Cargo subcommands, locked builds, and `cargo hx`-style workflows.
- Production-readiness docs emphasize app-specific validation for file, process, network, TLS/HTTP, database, and thread behavior.
- Async support exists in a narrow, typed, `metal`-only form with `rust_async`, `Future<T>`, `@:rustAsync`, `@:rustAwait`, and explicit runtime boundaries.
- Interop guidance favors typed externs, `@:native`, `@:rustCargo`, and `@:rustExtraSrc`, while avoiding app-level raw Rust injection.
- The snapshot has a meaningful test corpus, including snapshot tests and semantic-diff tests, but the docs still emphasize that inventory/support does not equal blanket runtime parity on every host.

Implication: `haxe.rust` is credible enough for a serious experiment, but Codex’s async/process/sandbox/network surfaces must be treated as hard gates.

---

## 4. Product goals

### 4.1 Primary goals

1. **Prove or disprove `haxe.rust` for a production-shaped runtime.**
   - Codex is large enough and systems-heavy enough to be a meaningful test.
   - The outcome should produce actionable gaps for `haxe.rust`, not just a failed prototype.

2. **Build a Codex-compatible headless runtime slice.**
   - Start with protocol, config, event, model-stream, session, and tool boundary behavior.
   - Defer full TUI replacement until headless parity is strong.

3. **Model Cafex replacement as a gated migration, not a rewrite promise.**
   - Cafex replacement is a possible future result, not an assumption.
   - Every Cafex-supported seam must have a testable parity claim.

4. **Preserve Caf semantic ownership.**
   - Haxe/Rust-generated code may implement projections and witnesses.
   - Existing Cafetera contracts remain the semantic source of truth.

5. **Use Beads as the task graph.**
   - Break the experiment into epics, gated tasks, dependencies, and acceptance criteria.
   - Keep task data portable enough to later convert into Caf Brew if desired.

### 4.2 Secondary goals

- Reduce future fork-rebase pressure if the experiment succeeds.
- Produce reusable protocol/DTO/codegen infrastructure even if runtime replacement fails.
- Produce a clear `haxe.rust` production-capability report grounded in real systems code.
- Create a harness that can compare upstream Codex, Cafex, and `codex-hxrust` behavior.

---

## 5. Non-goals

The following are explicitly out of scope for the first replacement experiment:

- Replacing the full Codex TUI.
- Replacing the full upstream Codex Rust workspace.
- Replacing all sandbox implementations from Haxe-generated Rust.
- Owning Caf semantics inside generated Rust.
- Making `haxe.rust` a hard Caf core dependency before gates pass.
- Forking Beads or building a new task tracker.
- Shipping generated Rust to production without licensing, security, and operational review.
- Using broad app-level raw Rust injection as an escape hatch. Typed wrappers are allowed; uncontrolled raw injection is a failure signal.

---

## 6. Users and stakeholders

### 6.1 Primary users

- Cafetera maintainers who currently carry and rebase Cafex.
- Codex/Cafex runtime developers who need native behavior, receipts, and testable seams.
- `haxe.rust` maintainers who need production-shaped validation data.
- Agent operators who need reliable Codex-compatible execution.

### 6.2 Secondary users

- Contributors working on Caf module contracts.
- Developers debugging Codex runtime behavior.
- Future migration tooling authors if the experiment later converts Beads tasks into Caf Brew units.

---

## 7. Core hypothesis

`haxe.rust` can become production-useful for Codex-shaped systems if the implementation is split as follows:

| Area | Expected implementation strategy | Initial confidence |
| --- | --- | --- |
| Protocol DTOs and fixtures | Haxe portable profile, typed JSON, generated Rust codecs | High |
| Pure state transitions | Haxe portable profile | High |
| Config lowering and validation | Haxe portable/metal mix | Medium-high |
| Model stream parsing | Haxe metal plus typed async/native wrapper | Medium |
| Session/turn loop | Haxe metal plus explicit async boundary | Medium |
| File/process wrappers | Haxe metal plus native Rust wrappers | Medium |
| Sandbox enforcement | Native Rust wrapper first; generated code calls fail-closed interface | Low-medium |
| TUI | Out of first scope | Low |
| Full upstream workspace replacement | Out of first scope | Low |
| Cafex receipts/goals/effort/wake seams | Contract-first Haxe implementation plus generated Rust binary | Medium |

The project should fail early if `haxe.rust` cannot express the event/session/tool-control shape without excessive handwritten Rust.

---

## 8. Product scope

### 8.1 Phase A: compatibility harness and inventory

Create an executable parity harness that can compare three implementations:

1. upstream Codex snapshot
2. Cafex fork snapshot
3. `codex-hxrust` generated Rust prototype

The harness should compare:

- protocol JSON fixtures
- app-server/debug-client request/response fixtures
- model stream events
- session/turn lifecycle events
- tool call decisions
- receipt output files
- goal state transitions
- effort/wake control receipt behavior
- exit codes and diagnostic output

Deliverables:

- parity matrix
- fixture inventory
- unsupported-surface list
- kill criteria document
- Beads epics/tasks loaded or ready to load

### 8.2 Phase B: `haxe.rust` scaffold

Create an experiment module/repo skeleton that builds a minimal generated Rust binary.

Suggested layout:

```text
hxml/
  portable.hxml
  metal.hxml
src/
  codexhx/
    Main.hx
    protocol/
    config/
    runtime/
    state/
    tools/
    adapters/
      cafex/
native/
  src/
fixtures/
  upstream/
  cafex/
  hxrust/
harness/
scripts/
generated/
  .gitignore
```

Rules:

- Haxe source is the source of truth.
- Generated Rust is not manually edited.
- Handwritten Rust is allowed only in `native/` wrappers with documented ownership and tests.
- Every native wrapper must have a typed Haxe extern and a fixture-backed test.
- The scaffold must support both `portable` and `metal` builds.

### 8.3 Phase C: protocol and DTO parity

Implement the smallest useful Codex/Cafex protocol subset:

- IDs and newtypes:
  - session IDs
  - conversation/thread IDs
  - turn IDs
  - tool call IDs
  - model IDs
  - path wrappers
- event envelopes:
  - session started/ready
  - user input submitted
  - assistant message delta/final
  - tool call started/finished
  - error
  - turn completed/cancelled
- request/response surfaces for headless operation:
  - start session
  - submit input
  - interrupt/cancel
  - get status
  - get transcript
- Cafex-specific DTOs:
  - session receipt
  - turn receipt
  - effort apply request/receipt
  - wake request/receipt
  - goal status/update payloads

Acceptance target:

- 100% JSON fixture round-trip parity for the selected subset.
- Stable schema fingerprinting so changes are intentional.
- No `Dynamic`-heavy untyped payloads except at explicitly marked JSON boundary functions.

### 8.4 Phase D: headless runtime slice

Implement a minimal non-TUI runtime capable of:

1. loading a config/profile fixture
2. starting a session
3. accepting a user prompt
4. consuming a mock model stream
5. emitting Codex-compatible events
6. optionally executing a mocked or dry-run tool call
7. writing a transcript/state artifact
8. exiting with deterministic status

The first model provider must be a mock provider. Real network/model integration comes after event-loop parity.

Acceptance target:

- One-turn mock run produces an expected event sequence.
- Cancellation/interrupt can stop a turn and produce a deterministic terminal event.
- Generated binary can run in CI without credentials.

### 8.5 Phase E: native tool and state capability slices

Add selected native capabilities behind fail-closed wrappers:

- apply-patch compatibility slice
- process execution wrapper
- sandbox/approval decision boundary
- JSONL state store
- optional SQLite/sqlx-backed state spike
- MCP/tool registry skeleton
- diagnostics/doctor output

Acceptance target:

- Process execution cannot bypass approval/sandbox interfaces.
- Sandbox wrapper fails closed when unsupported.
- Tool decisions are fixture-comparable to upstream/Cafex for selected cases.
- State artifacts can be inspected by the parity harness.

### 8.6 Phase F: Cafex seam compatibility

Implement Cafex-specific runtime behavior only after the headless runtime and DTO parity are stable.

Seams to support first:

1. session receipt writer
2. turn receipt writer
3. effort/mode bridge
4. wake request/receipt bridge
5. minimal goal DTO/state/tool flow
6. restart/session-continuity metadata
7. fork seam ledger mapping

Acceptance target:

- Cafetera Codex module contract tests can target the `codex-hxrust` binary or adapter.
- For every supported Cafex delta, there is:
  - an owner
  - a fixture
  - a parity test
  - a seam-ledger entry
  - a known unsupported behavior list if partial

### 8.7 Phase G: replacement evaluation

Only after the above gates pass, evaluate whether `codex-hxrust` can replace any Cafex fork slice.

Replacement modes:

| Mode | Description | Production stance |
| --- | --- | --- |
| A | Helper/conformance only | Safe baseline |
| B | Sidecar/headless runtime for selected tests/workflows | Experimental |
| C | Replace specific Cafex fork slices behind adapter | Candidate |
| D | Broader Cafex replacement | Future decision only |

The replacement review must compare:

- runtime behavior
- test coverage
- generated Rust quality
- rebase pressure reduction
- operational risk
- security posture
- licensing posture
- maintenance burden
- developer ergonomics

---

## 9. Functional requirements

### 9.1 Build and toolchain

- The experiment must build using pinned Haxe, `haxe.rust`, Rust, and Cargo toolchain versions.
- Generated Rust must pass `cargo check --locked`.
- Generated Rust should pass `cargo test --locked` for its own crate tests.
- `cargo clippy` should be used as a quality signal; failures may be triaged early but must be tracked.
- Build output must include a machine-readable version/doctor report.
- CI must run without model credentials for the mock path.

### 9.2 Protocol and schema behavior

- Selected protocol DTOs must round-trip JSON fixtures.
- Unknown fields behavior must be explicitly defined:
  - reject
  - preserve
  - ignore
- Error payloads must preserve enough detail for debugging without leaking secrets.
- Schema fingerprints must be generated for selected DTO sets.

### 9.3 Runtime behavior

- The runtime must support a deterministic one-turn mock conversation.
- The runtime must emit ordered events suitable for comparison.
- The runtime must support cancellation/interrupt at safe checkpoints.
- The runtime must write inspectable state/transcript artifacts.
- The runtime must expose a headless command or app-server-compatible adapter path.

### 9.4 Tool behavior

- Tool execution must be represented as an explicit state transition.
- Process execution must be blocked unless approval/sandbox policy permits it.
- Unsupported sandbox behavior must fail closed.
- Apply-patch behavior must be fixture-tested before real file mutation is allowed.
- Tool output truncation and error mapping must be deterministic.

### 9.5 Cafex behavior

- The runtime must write Caf-compatible session and turn receipts when configured.
- The runtime must not write receipts when configuration/env vars are absent, unless explicitly requested by a test mode.
- Effort/mode bridge behavior must be deterministic and receipt-backed.
- Wake/restart continuity must be represented as explicit metadata, not inferred from side effects alone.
- Goal behavior must be implemented as a contract-backed subset first.

### 9.6 Beads task management

- The experiment must be represented as Beads epics and child tasks.
- Every task must include acceptance criteria.
- Dependencies must be explicit so `bd ready` surfaces safe next work.
- Task IDs generated by Beads are not assumed in source docs; stable planning keys such as `HXCX-2.4` are used until imported.
- The Beads backlog may later be converted into Caf Brew, but Beads remains the experiment tracker.

---

## 10. Non-functional requirements

### 10.1 Security

- Generated runtime must not weaken Codex/Cafex sandbox and approval guarantees.
- Unsupported security-sensitive features fail closed.
- Secrets must not be serialized into fixtures, receipts, transcripts, or diagnostics.
- Native wrappers must be small and reviewed.
- Model/provider integration must use explicit credential boundaries.

### 10.2 Reliability

- Fixture tests must be deterministic.
- The mock model path must avoid network flake.
- Runtime state files must be written atomically where possible.
- Crashes must produce actionable diagnostics.
- Receipts must be idempotent or detect duplicate writes.

### 10.3 Maintainability

- Generated Rust is not manually patched.
- Every handwritten Rust wrapper needs an owner and typed extern.
- Every supported upstream/Cafex behavior needs a fixture or test.
- Unsupported behavior is documented in the parity matrix.
- Haxe code should avoid unnecessary abstraction and mirror domain boundaries plainly.

### 10.4 Performance

Early performance targets are sanity checks, not optimization goals:

- generated binary starts within an acceptable local CLI range
- one-turn mock run completes without excessive overhead
- JSON encode/decode is not obviously pathological
- transcript/state writes are linear in fixture size
- native wrapper overhead is measured for hot paths before replacement decisions

### 10.5 Portability

- Linux and macOS are required for initial viability.
- Windows support is a compile/test target after Linux/macOS are stable.
- Platform-specific sandbox/process behavior must be isolated behind wrappers.

### 10.6 Licensing and distribution

- Upstream Codex is Apache-2.0 in the inspected snapshot.
- The inspected `haxe.rust` package metadata declares GPL-3.0.
- Before any production distribution decision, review:
  - compiler/tool license implications
  - generated code license implications
  - runtime library linkage implications
  - compatibility with Cafetera and Codex distribution goals

This PRD is not legal advice. Licensing is a hard gate before production use.

---

## 11. Architecture

### 11.1 High-level architecture

```text
                       ┌────────────────────────────┐
                       │ Cafetera Codex module       │
                       │ contracts / fixtures / CLI  │
                       └─────────────┬──────────────┘
                                     │
                                     │ contract tests
                                     ▼
┌────────────────────────────────────────────────────────────────┐
│ codex-hxrust generated binary / adapter                         │
│                                                                │
│  Haxe source of truth                                           │
│  ┌─────────────┐ ┌─────────────┐ ┌──────────────┐              │
│  │ protocol    │ │ config      │ │ caf seams    │              │
│  │ DTO/codecs  │ │ lowering    │ │ receipts     │              │
│  └──────┬──────┘ └──────┬──────┘ └──────┬───────┘              │
│         │               │               │                      │
│  ┌──────▼───────────────▼───────────────▼──────┐               │
│  │ headless session / turn runtime              │               │
│  └──────┬───────────────┬───────────────┬──────┘               │
│         │               │               │                      │
│  ┌──────▼──────┐ ┌──────▼──────┐ ┌──────▼──────┐               │
│  │ model mock/ │ │ tool state  │ │ transcript  │               │
│  │ provider    │ │ machine     │ │ state store │               │
│  └──────┬──────┘ └──────┬──────┘ └─────────────┘               │
│         │               │                                      │
│  ┌──────▼───────────────▼────────────────────────┐             │
│  │ typed native Rust wrappers                     │             │
│  │ tokio / process / sandbox / serde / sqlite     │             │
│  └────────────────────────────────────────────────┘             │
└────────────────────────────────────────────────────────────────┘
                                     ▲
                                     │ parity comparison
                                     │
                       ┌─────────────┴──────────────┐
                       │ upstream Codex + Cafex      │
                       │ fixtures and oracle runs     │
                       └────────────────────────────┘
```

### 11.2 Component mapping

| Codex/Cafex area | `codex-hxrust` component | Implementation profile | Notes |
| --- | --- | --- | --- |
| `codex-protocol` selected events | `codexhx.protocol` | portable | DTOs, fixtures, schema fingerprints |
| `app-server-protocol` selected requests | `codexhx.protocol.appserver` | portable | Headless adapter first |
| Config/profile lowering | `codexhx.config` | portable/metal | Start with JSON/TOML fixture subset |
| Model stream parser | `codexhx.runtime.model` | metal | Mock first; real provider later |
| Session/turn state machine | `codexhx.runtime.session` | metal | Deterministic event loop |
| Transcript/state store | `codexhx.state` | portable/metal | JSONL first, SQLite spike later |
| Apply-patch | `codexhx.tools.patch` | metal + native wrapper | Fixture-first, dry-run before mutation |
| Process exec | `codexhx.tools.exec` | metal + native wrapper | Fail closed on unsupported policy |
| Sandbox | `codexhx.tools.sandbox` | native wrapper | Do not rewrite sandbox first |
| Caf receipts | `codexhx.caf.receipts` | portable/metal | Env-driven, fixture-tested |
| Caf effort/wake | `codexhx.caf.effort` | metal | Directory bridge and receipts |
| Caf goals | `codexhx.caf.goals` | portable/metal | Minimal goal DTO/state/tool subset |
| TUI | none initially | out of scope | Revisit after headless parity |

### 11.3 Interop policy

Allowed:

- typed Haxe externs for native Rust APIs
- `@:native` mappings
- `@:rustCargo` for dependencies
- `@:rustExtraSrc` for small wrapper modules
- generated Rust checked into CI artifacts, not edited by hand

Discouraged and tracked as risk:

- raw Rust fragments in app-level Haxe code
- large native wrappers that recreate the runtime in Rust
- untyped `Dynamic` propagation beyond JSON boundary functions
- wrapper APIs that hide security decisions

Disallowed for replacement gates:

- bypassing approval/sandbox policy
- secret-bearing fixture outputs
- generated code patching after compile
- silent schema drift

---

## 12. Test and validation plan

### 12.1 Test layers

| Layer | Purpose | Required before next gate |
| --- | --- | --- |
| Haxe unit tests | Pure logic and DTO behavior | Yes |
| `haxe.rust` snapshot/semantic-diff suite | Compiler/runtime confidence | Yes |
| Generated Cargo tests | Rust crate sanity | Yes |
| Fixture round-trip tests | JSON/protocol parity | Yes |
| Oracle comparison tests | Upstream/Cafex behavioral parity | Yes |
| Cafetera contract tests | Cafex seam parity | Before replacement consideration |
| Security/sandbox tests | No policy regression | Before real tool execution |
| Performance smoke tests | Detect pathological generated output | Before broader runtime scope |

### 12.2 Fixture sources

Initial fixture sources:

- upstream `codex-rs/protocol`
- upstream `codex-rs/app-server-protocol`
- upstream/app-server tests and schema fixtures
- Cafex receipt tests
- Cafetera Codex module contract tests
- Cafex goal/effort/wake/restart fixtures
- new `codex-hxrust` mock model stream fixtures

### 12.3 Cafetera contract tests to prioritize

From the Cafetera snapshot, these test families are likely high priority:

- Cafex boundary contract
- Cafex fork seam ledger contract
- Cafex runtime DTO conformance contract
- goal apply contract
- native goal bridge contract
- module effort apply contract
- upstream sync/fork lineage contract
- compose runtime contracts
- restart/wake/status/doctor/build-config contracts
- snapshot diff hygiene contracts

### 12.4 Golden path demo

The first end-to-end demo should avoid credentials and real mutation:

```text
codex-hxrust run-fixture fixtures/basic_one_turn.json
```

Expected behavior:

1. prints a deterministic doctor/version block
2. loads config fixture
3. writes optional Caf session receipt when env var is present
4. starts a mock session
5. consumes a mock model stream
6. emits assistant response events
7. optionally plans a dry-run tool call
8. writes optional Caf turn receipt when env var is present
9. writes transcript JSONL
10. exits 0

---

## 13. Success metrics and gates

### 13.1 Gate G0: inventory complete

Pass criteria:

- upstream/Cafex topology documented
- Cafex deltas classified by replacement relevance
- selected protocol subset listed
- unsupported surfaces listed
- Beads epics/tasks loaded or import-ready

### 13.2 Gate G1: `haxe.rust` toolchain green

Pass criteria:

- pinned toolchain documented
- `haxe.rust` local validation command green
- minimal generated binary builds
- portable and metal profiles both exercised
- generated Cargo crate passes `cargo check --locked`

### 13.3 Gate G2: protocol parity

Pass criteria:

- selected DTOs round-trip fixtures
- schema fingerprints generated
- unknown-field policy documented
- no unreviewed `Dynamic` propagation

### 13.4 Gate G3: one-turn headless runtime

Pass criteria:

- mock model stream consumed
- session/turn event sequence fixture matches expectation
- transcript/state artifact written
- cancellation/interrupt path covered
- no real credentials required

### 13.5 Gate G4: native tool boundary

Pass criteria:

- dry-run apply-patch fixture passes
- process execution wrapper enforces approval decision
- unsupported sandbox path fails closed
- tool output/error mapping deterministic

### 13.6 Gate G5: Cafex seam parity

Pass criteria:

- session/turn receipts match expected schemas
- effort/wake bridge fixture tests pass
- minimal goal lifecycle works
- Cafetera contract subset can target `codex-hxrust`
- seam ledger maps every supported Cafex delta

### 13.7 Gate G6: replacement review

Pass criteria:

- comparison report against Cafex exists
- operational/security/licensing review exists
- generated Rust quality report exists
- maintenance/rebase impact estimated from evidence
- rollback plan exists
- decision record selects Mode A, B, C, or D

---

## 14. Kill criteria

Stop or narrow the experiment if any of these becomes true:

- The implementation requires large handwritten Rust modules outside typed wrappers.
- Async/runtime behavior cannot be expressed without fragile codegen escapes.
- Generated Rust cannot pass stable locked builds for the selected subset.
- JSON/protocol parity cannot be maintained without untyped payload sprawl.
- Security-sensitive behavior must be weakened to make progress.
- Caf semantic ownership drifts into generated runtime code.
- Licensing review blocks intended distribution.
- Maintenance burden exceeds the existing Cafex fork burden for the same capability slice.
- Two consecutive milestone reviews fail to produce a smaller viable slice.

A kill decision should still preserve useful outputs: DTO generators, fixtures, conformance harnesses, and `haxe.rust` gap reports.

---

## 15. Milestone plan

Milestones are gate-based, not calendar-based.

### M0: decision and inventory

Outputs:

- final scope for first runtime slice
- Cafex delta classification
- parity matrix v0
- Beads backlog import
- licensing/toolchain review issue opened

Exit gate: G0.

### M1: scaffold and compiler gates

Outputs:

- experiment module/repo skeleton
- portable and metal build configs
- minimal generated binary
- generated Cargo CI
- wrapper/interop policy

Exit gate: G1.

### M2: protocol and DTO parity

Outputs:

- selected DTOs
- JSON round-trip tests
- schema fingerprints
- app-server/debug-client fixture subset
- Caf receipt DTO subset

Exit gate: G2.

### M3: headless one-turn runtime

Outputs:

- mock model provider
- session/turn state machine
- transcript store
- deterministic event comparison
- interrupt/cancel fixture

Exit gate: G3.

### M4: tool/state capability slice

Outputs:

- dry-run apply-patch wrapper
- process execution policy wrapper
- sandbox fail-closed wrapper
- JSONL state store
- diagnostics/doctor output

Exit gate: G4.

### M5: Cafex seam compatibility

Outputs:

- Caf session/turn receipts
- effort/wake bridge
- minimal goals flow
- restart/session-continuity metadata
- Cafetera contract subset green or gap-classified

Exit gate: G5.

### M6: replacement evaluation

Outputs:

- replacement comparison report
- security/licensing review
- generated Rust quality report
- migration/rollback plan
- decision record

Exit gate: G6.

### M7: `haxe.rust` production capability report

Outputs:

- upstreamable `haxe.rust` issues/fixtures
- runtime capability scorecard
- recommended future stance:
  - helper-only
  - sidecar/headless
  - slice replacement
  - broader candidate

---

## 16. Beads task model

Use stable planning keys in this PRD and the seed file. Beads will assign real IDs during import.

Recommended import style:

1. create epics first
2. create child tasks with `--parent`
3. add dependencies after all tasks exist
4. use `bd ready` to select unblocked tasks
5. claim work with `bd update --claim`
6. close only when acceptance criteria are met

The companion file `codex-hxrust-beads-backlog.seed.jsonl` contains epics and tasks with:

- stable key
- title
- type
- priority
- labels
- parent planning key
- dependency planning keys
- description
- acceptance criteria
- source references

### 16.1 Epic map

| Epic | Purpose |
| --- | --- |
| `HXCX-0` | Inventory, oracle, parity matrix, and decision boundaries |
| `HXCX-1` | `haxe.rust` scaffold, builds, CI, and interop policy |
| `HXCX-2` | Protocol, DTO, schema, and fixture parity |
| `HXCX-3` | Headless one-turn Codex runtime |
| `HXCX-4` | Native tool/state capability slices |
| `HXCX-5` | Cafex seam compatibility |
| `HXCX-6` | Replacement gate and migration plan |
| `HXCX-7` | `haxe.rust` production capability report |

---

## 17. Open questions

1. **Repository ownership:** resolved by `docs/repository-layout.md`; this separate `codex-hxrust` repo owns the port, with root-level Haxe package directories and sibling reference checkouts.
2. **Replacement target:** is the first target `deps/codex`, the compose runtime copy, a sidecar binary, or a Cafetera module adapter?
3. **Schema source of truth:** should Haxe DTOs be generated from Codex Rust schema fixtures, or manually mirrored with fixture checks?
4. **State backend:** JSONL first is simpler; SQLite/sqlx parity may be required for replacement.
5. **Auth/model integration:** should real provider auth be supported before or after tool execution?
6. **TUI strategy:** should TUI remain out of scope until headless and app-server parity are proven?
7. **Licensing:** what are the distribution implications of the inspected GPL-3.0 `haxe.rust` package metadata and runtime linkage?
8. **Brew conversion:** what metadata should Beads tasks carry now to make a later Caf Brew conversion easy?

---

## 18. Recommended immediate next steps

1. Import the Beads backlog seed as epics/tasks.
2. Close or update existing Cafetera research issue history with a pointer to this gated experiment.
3. Start `HXCX-0.1` and `HXCX-0.2`: baseline topology and Cafex delta classification.
4. Create the minimal scaffold only after the parity scorecard exists.
5. Keep the first executable demo credential-free and mutation-free.

---

## 19. Decision record template

Each milestone review should create or update a decision record:

```text
Decision:
Date:
Milestone:
Gate:
Result: pass / fail / narrow / pause
Evidence:
Unsupported surfaces:
Security notes:
Licensing notes:
Generated Rust quality notes:
haxe.rust gaps:
Cafex parity notes:
Next mode: helper-only / sidecar / slice replacement / broader candidate
Rollback:
```

---

## 20. Final stance

This is a worthwhile experiment, but only if it is framed as a compatibility and production-capability proof rather than a rewrite declaration.

The strongest near-term value is likely:

1. protocol/DTO parity tooling,
2. generated Rust validators/codecs,
3. Cafex seam conformance fixtures,
4. a headless mock runtime,
5. and a concrete `haxe.rust` gap report.

A future Cafex replacement should require hard evidence from the gates above, especially around async runtime behavior, process/sandbox safety, Caf receipt fidelity, goal/effort/wake parity, generated Rust quality, licensing, and actual reduction in fork maintenance pressure.
