# Thread/Read Budget-Limit Goal Steering

**Bead:** `HXCX-4.30` / `codex-hxrust-bkf`
**Fixture:** `fixtures/hxrust/thread-read-budget-limit-goal-steering.v1.json`
**Gate:** `harness/check-thread-read-budget-limit-goal-steering.sh`

## Purpose

This slice models selected upstream budget-limit steering after active-goal progress accounting on tool finish. The output records whether budget-limit steering was emitted and injected, skipped before steering, skipped by active-turn injection, or failed during progress accounting.

## Upstream Anchors

- `../codex/codex-rs/ext/goal/src/extension.rs:359`
- `../codex/codex-rs/ext/goal/src/extension.rs:373`
- `../codex/codex-rs/ext/goal/src/extension.rs:377`
- `../codex/codex-rs/ext/goal/src/extension.rs:391`
- `../codex/codex-rs/ext/goal/src/extension.rs:396`
- `../codex/codex-rs/ext/goal/src/extension.rs:400`
- `../codex/codex-rs/ext/goal/src/runtime.rs:431`
- `../codex/codex-rs/ext/goal/src/runtime.rs:465`
- `../codex/codex-rs/ext/goal/src/accounting.rs:55`
- `../codex/codex-rs/ext/goal/src/accounting.rs:290`
- `../codex/codex-rs/ext/goal/src/steering.rs:37`
- `../codex/codex-rs/ext/goal/tests/goal_extension_backend.rs:434`

## Boundary Shape

The Haxe facade lives in `codexhx.runtime.app.threadread`:

- `ThreadReadBudgetLimitGoalSteeringRequest` carries active progress availability, the accounted goal, goal id, duplicate-report state, and HXCX-4.29 host injection availability.
- `ThreadReadBudgetLimitGoalSteeringPolicy` mirrors the selected upstream order: progress accounting, budget-limited status check, duplicate report check, budget-limit steering item build, active-turn injection.
- `ThreadReadBudgetLimitGoalSteeringOutcome` records progress accounting, budget-limited status, duplicate/report mark state, steering emission, injection attempt, nested injection code, item summary, and deterministic sequence summaries.

## Selected Behavior

- Budget-limited progress emits a `budget_limit` goal contextual fragment and attempts active-turn injection.
- Non-budget-limited progress skips before steering.
- Duplicate budget-limit reports skip before steering.
- Missing active progress skips before steering.
- Progress-accounting failure fails closed.
- No active turn delegates to HXCX-4.29 injection behavior and returns the item unchanged.

## Non-Goals

- Owning live tool lifecycle callbacks, token accounting storage, state DB handles, or event emitters.
- Replacing the full upstream active-goal accounting algorithm.
- Owning live `ThreadManager`, `CodexThread`, `Session`, `InputQueue`, or active-turn locks.
- Cafex or Cafetera adapter behavior.

## haxe.rust Pressure

No new haxe.rust limitation was exposed. The harness passes through the Haxe interpreter and portable haxe.rust-generated Rust with no raw Rust escapes.
