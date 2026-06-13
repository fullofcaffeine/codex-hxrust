# Persistent State Boundary

**Bead:** `HXCX-4.13` / `codex-hxrust-md6`
**Date:** 2026-06-13
**Scope:** raw upstream Codex app-server/TUI persistence boundary.

## Purpose

Codexhx must port the full Codex product, including app-server runtime, tools, state, and TUI. This slice defines the persistence split before claiming production state parity.

The current implementation validates credential-free thread/session/rollout metadata in portable Haxe and records when native Rust persistence is required. It does not implement SQLite, file locking, rollout reconciliation, log flushing, or cross-process state effects.

## Upstream Anchors

Read-only reference checkout: `../codex`.

Selected anchors:

- `../codex/codex-rs/app-server-client/src/lib.rs:310` defines `InProcessClientStartArgs`, including `log_db: Option<LogDbLayer>` and `state_db: Option<StateDbHandle>`.
- `../codex/codex-rs/app-server/src/in_process.rs:120` carries the same process-wide DB handles into embedded app-server startup.
- `../codex/codex-rs/app-server/src/thread_state.rs:30` records pending resume metadata, history items, thread summaries, and optional thread-goal state DB handles.
- `../codex/codex-rs/protocol/src/protocol.rs:2359` defines `ResumedHistory { conversation_id, history, rollout_path }` and `InitialHistory::Resumed`.
- `../codex/codex-rs/rollout/src/state_db.rs:25` aliases `StateDbHandle` to the SQLite-backed state runtime and exposes `reconcile_rollout`.
- `../codex/codex-rs/thread-store/src/local/mod.rs:92` wires local thread stores to the optional state DB and `persist_thread`.
- `../codex/codex-rs/tui/src/lib.rs:300` passes state/log DB handles through embedded TUI app-server startup.

## Boundary Decision

Portable Haxe owns deterministic, side-effect-free metadata:

- typed thread/session IDs;
- rollout path shape and absolute-path guard;
- history item count and rollout item kind summaries;
- persisted item count sanity;
- include-history, archived, and goal-state intent flags;
- fixture-backed validation for resume/read decisions.

Native Rust owns production persistence effects:

- `StateDbHandle`;
- `LogDbLayer`;
- SQLite/sqlx runtime ownership;
- `reconcile_rollout`;
- `persist_thread`;
- file locking, atomicity, migrations, repair, and cross-process coordination.

Near-term codexhx code should use metal for these native persistence effects. Portable code may validate state and DTOs, but it must not pretend JSONL fixture evidence is a production SQLite replacement.

## Harness

Fixture: `../fixtures/hxrust/persistence-boundary.v1.json`

Gate:

```bash
harness/check-persistence-boundary.sh
```

The harness runs:

- Haxe interpreter validation;
- haxe.rust portable code generation;
- generated Cargo check/test/run.

The fixture covers:

- portable rollout metadata validation;
- explicit native SQLite/log boundary requirement;
- fail-closed refusal when portable fixture metadata claims native DB effects;
- absolute rollout-path validation.

## Next Work

The next persistence implementation slice should introduce a generic haxe.rust metal/native SQLite boundary or a narrower credential-free decision harness around one upstream operation such as `reconcile_rollout` metadata upsert. Any compiler limitation found while doing that belongs in `../haxe.rust` with product-neutral fixtures.
