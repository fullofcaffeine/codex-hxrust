# Thread/Read Idle Goal Progress Accounting

**Bead:** `HXCX-4.32` / `codex-hxrust-6xf`
**Fixture:** `fixtures/hxrust/thread-read-idle-goal-progress-accounting.v1.json`
**Gate:** `harness/check-thread-read-idle-goal-progress-accounting.sh`

## Purpose

This slice models selected upstream idle-goal progress accounting when there is no active turn. It records the pure decision surface around idle progress snapshots, zero-token state DB accounting, status marking, budget-limited disposition, and `thread_goal_updated` emission with no turn id.

## Upstream Anchors

- `../codex/codex-rs/ext/goal/src/runtime.rs:494`
- `../codex/codex-rs/ext/goal/src/runtime.rs:505`
- `../codex/codex-rs/ext/goal/src/runtime.rs:515`
- `../codex/codex-rs/ext/goal/src/runtime.rs:518`
- `../codex/codex-rs/ext/goal/src/runtime.rs:525`
- `../codex/codex-rs/ext/goal/src/runtime.rs:538`
- `../codex/codex-rs/ext/goal/src/runtime.rs:544`
- `../codex/codex-rs/ext/goal/src/runtime.rs:551`
- `../codex/codex-rs/ext/goal/src/accounting.rs:221`
- `../codex/codex-rs/ext/goal/src/accounting.rs:266`
- `../codex/codex-rs/ext/goal/src/accounting.rs:283`
- `../codex/codex-rs/ext/goal/src/accounting.rs:424`
- `../codex/codex-rs/state/src/runtime/goals.rs:23`
- `../codex/codex-rs/state/src/runtime/goals.rs:407`

## Boundary Shape

The Haxe facade lives in `codexhx.runtime.app.threadread`:

- `ThreadReadIdleGoalProgressAccountingRequest` carries the event id, selected idle snapshot fields, previous status, state DB outcome kind, updated goal, and budget-limited disposition.
- `ThreadReadIdleGoalProgressAccountingPolicy` mirrors the selected upstream order: missing idle snapshot returns none, DB errors fail, unchanged state resets idle baseline and clears active goal, updated goals mark idle progress and emit `thread_goal_updated` without a turn id.
- `ThreadReadIdleGoalProgressAccountingOutcome` records wall-clock deltas, zero token delta, active-goal clearing, idle-baseline reset, budget-limit report clearing, terminal metric evidence, no-turn event emission, and deterministic sequence summaries.

## Selected Behavior

- Missing `idle_progress_snapshot()` returns `None` without attempting state DB accounting.
- State DB accounting uses `token_delta` 0 for idle progress.
- State DB errors fail with `state_accounting_failed` and do not mark local accounting or emit events.
- `GoalAccountingOutcome::Unchanged` resets the idle baseline, clears the active goal, clears the budget-limit report marker, and returns `None`.
- `GoalAccountingOutcome::Updated` records wall-clock progress, emits `thread_goal_updated(event_id, None, goal)`, and returns accounted progress.
- Active goals stay active regardless of budget-limited disposition.
- Budget-limited goals clear active accounting only with `BudgetLimitedGoalDisposition::ClearActive`; `KeepActive` preserves active accounting.

## Non-Goals

- Owning the async progress-accounting permit, production state DB handles, metrics clients, analytics clients, or event emitter.
- Owning full wall-clock source timing, idle lifecycle scheduling, or continuation turn spawning.
- Replacing the full upstream goal extension lifecycle.
- Cafex or Cafetera adapter behavior.

## haxe.rust Pressure

No new haxe.rust limitation was exposed. The harness passes through the Haxe interpreter and portable haxe.rust-generated Rust with typed DTOs/enums and no raw Rust escapes.
