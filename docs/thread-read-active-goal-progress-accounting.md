# Thread/Read Active Goal Progress Accounting

**Bead:** `HXCX-4.31` / `codex-hxrust-bwh`
**Fixture:** `fixtures/hxrust/thread-read-active-goal-progress-accounting.v1.json`
**Gate:** `harness/check-thread-read-active-goal-progress-accounting.sh`

## Purpose

This slice models selected upstream active-goal progress accounting after a turn/tool event. It records the pure decision surface around progress snapshots, state DB accounting outcomes, status marking, budget-limited disposition, and `thread_goal_updated` emission.

## Upstream Anchors

- `../codex/codex-rs/ext/goal/src/runtime.rs:431`
- `../codex/codex-rs/ext/goal/src/runtime.rs:443`
- `../codex/codex-rs/ext/goal/src/runtime.rs:453`
- `../codex/codex-rs/ext/goal/src/runtime.rs:463`
- `../codex/codex-rs/ext/goal/src/runtime.rs:479`
- `../codex/codex-rs/ext/goal/src/runtime.rs:482`
- `../codex/codex-rs/ext/goal/src/accounting.rs:194`
- `../codex/codex-rs/ext/goal/src/accounting.rs:234`
- `../codex/codex-rs/ext/goal/src/accounting.rs:424`
- `../codex/codex-rs/state/src/runtime/goals.rs:23`
- `../codex/codex-rs/state/src/runtime/goals.rs:407`

## Boundary Shape

The Haxe facade lives in `codexhx.runtime.app.threadread`:

- `ThreadReadActiveGoalProgressAccountingRequest` carries the turn/event ids, selected progress snapshot fields, previous status, state DB outcome kind, updated goal, and budget-limited disposition.
- `ThreadReadGoalAccountingDbOutcomeKind` and `ThreadReadGoalAccountingDisposition` keep state outcomes and `KeepActive`/`ClearActive` behavior typed instead of stringly-typed at the policy boundary.
- `ThreadReadActiveGoalProgressAccountingPolicy` mirrors the selected upstream order: missing snapshot returns none, DB errors fail, unchanged state returns none, updated goals mark progress and emit `thread_goal_updated`.
- `ThreadReadActiveGoalProgressAccountingOutcome` records usage marking, wall-clock/token deltas, active-goal clearing, budget-limit report clearing, terminal metric evidence, event emission, and deterministic sequence summaries.

## Selected Behavior

- Missing `progress_snapshot(turn_id)` returns `None` without attempting state DB accounting.
- State DB errors fail with `state_accounting_failed` and do not mark local accounting or emit events.
- `GoalAccountingOutcome::Unchanged` returns `None` and does not call progress-accounted marking.
- `GoalAccountingOutcome::Updated` records token and wall-clock deltas, updates the turn accounting baseline, emits `thread_goal_updated`, and returns accounted progress.
- Active goals stay active regardless of budget-limited disposition.
- Budget-limited goals clear active accounting only with `BudgetLimitedGoalDisposition::ClearActive`; `KeepActive` preserves active accounting so later tool finishes can continue accounting.
- Non-budget terminal statuses are modeled by the shared clear-active rule even though the fixture focuses on the requested active and budget-limited cases.

## Non-Goals

- Owning the async progress-accounting permit, production state DB handles, metrics clients, analytics clients, or event emitter.
- Owning full token usage aggregation, wall-clock source timing, or live turn storage.
- Replacing the full upstream goal extension/tool lifecycle.
- Cafex or Cafetera adapter behavior.

## haxe.rust Pressure

No new haxe.rust limitation was exposed. The harness passes through the Haxe interpreter and portable haxe.rust-generated Rust with typed DTOs/enums and no raw Rust escapes.
