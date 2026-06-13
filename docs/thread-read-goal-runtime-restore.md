# Thread/Read Goal Runtime Restore

**Bead:** `HXCX-4.28` / `codex-hxrust-91o`
**Fixture:** `fixtures/hxrust/thread-read-goal-runtime-restore.v1.json`
**Gate:** `harness/check-thread-read-goal-runtime-restore.sh`

## Purpose

This slice models selected upstream goal runtime restoration after thread resume. The output is a typed restore decision: skip when the extension has no runtime, no-op when the runtime is disabled, rehydrate idle accounting and record the resumed metric for an active stored goal, clear active accounting for missing or non-active goals, or preserve accounting on state-read failure.

## Upstream Anchors

- `../codex/codex-rs/ext/goal/src/extension.rs:139`
- `../codex/codex-rs/ext/goal/src/extension.rs:145`
- `../codex/codex-rs/ext/goal/src/runtime.rs:335`
- `../codex/codex-rs/ext/goal/src/runtime.rs:336`
- `../codex/codex-rs/ext/goal/src/runtime.rs:342`
- `../codex/codex-rs/ext/goal/src/runtime.rs:349`
- `../codex/codex-rs/ext/goal/src/runtime.rs:352`
- `../codex/codex-rs/ext/goal/src/runtime.rs:354`
- `../codex/codex-rs/ext/goal/src/metrics.rs:28`
- `../codex/codex-rs/ext/goal/tests/goal_extension_backend.rs:1007`
- `../codex/codex-rs/ext/goal/tests/goal_extension_backend.rs:1265`

## Boundary Shape

The Haxe facade lives in `codexhx.runtime.app.threadread`:

- `ThreadReadGoalRuntimeRestoreRequest` carries runtime availability, enabled state, state-read outcome, stored goal, stored goal id, and previous active-accounting id.
- `ThreadReadGoalRuntimeRestorePolicy` mirrors the selected upstream order: runtime lookup, enabled guard, state DB read, active-goal restore, missing/non-active clear.
- `ThreadReadGoalRuntimeRestoreOutcome` records restored/cleared/no-op/failure state, state-read attempts, resumed metric recording, idle accounting state, active-goal id after restore, and deterministic sequence summaries.

## Selected Behavior

- Missing runtime skips restore without reading state.
- Disabled runtime returns Ok without reading state.
- Stored active goals call the equivalent of `mark_idle_goal_active(goal_id)` and record the resumed metric.
- Stored missing, paused, complete, or otherwise non-active goals clear active accounting.
- State-read failure is a restore failure and preserves the previous active accounting id.

## Non-Goals

- Owning live extension stores, state DB handles, metrics clients, or async scheduling.
- Accounting elapsed wall-clock time after restore; upstream does that in later active-goal progress paths.
- Emitting goal notifications or starting continuation turns.
- Cafex or Cafetera adapter behavior.

## haxe.rust Pressure

No new haxe.rust limitation was exposed. The harness passes through the Haxe interpreter and portable haxe.rust-generated Rust with no raw Rust escapes.
