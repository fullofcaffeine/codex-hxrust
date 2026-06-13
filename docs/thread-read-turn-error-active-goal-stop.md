# Thread/Read Turn-Error Active Goal Stop

**Bead:** `HXCX-4.35` / `codex-hxrust-7up`

## Upstream Scope

This slice models the selected raw Codex goal-extension path for terminal turn errors:

- `../codex/codex-rs/ext/goal/src/extension.rs:299` selects `GoalExtension::on_turn_error`;
- `../codex/codex-rs/ext/goal/src/extension.rs:305` maps `CodexErrorInfo::UsageLimitExceeded` to `ActiveGoalStopReason::UsageLimit`;
- `../codex/codex-rs/ext/goal/src/extension.rs:311` maps all other terminal errors to `ActiveGoalStopReason::TurnError`;
- `../codex/codex-rs/ext/goal/src/runtime.rs:244` owns `GoalRuntime::stop_active_goal_for_turn`;
- `../codex/codex-rs/ext/goal/src/runtime.rs:253` holds the goal-state permit through accounting and status update;
- `../codex/codex-rs/ext/goal/src/runtime.rs:256` skips when the turn is not the current active goal;
- `../codex/codex-rs/ext/goal/src/runtime.rs:272` accounts active-goal progress with `ActiveOnly` and `ClearActive`;
- `../codex/codex-rs/ext/goal/src/runtime.rs:280` handles missing stored goals by clearing active-goal accounting state;
- `../codex/codex-rs/ext/goal/src/runtime.rs:291` allows active goals and budget-limited goals stopped for usage limits;
- `../codex/codex-rs/ext/goal/src/runtime.rs:303` updates the stored goal status;
- `../codex/codex-rs/ext/goal/src/runtime.rs:327` emits the final `thread_goal_updated` event.

## Local Boundary

- `ThreadReadTurnErrorKind` keeps usage-limit errors distinct from other terminal turn errors.
- `ThreadReadActiveGoalStopReason` mirrors upstream `UsageLimit` versus `TurnError`.
- `ThreadReadTurnErrorActiveGoalStopRequest` carries runtime state, turn id, permit/current-turn guard evidence, nested active-goal accounting outcome, and selected stored-goal lookup state.
- `ThreadReadTurnErrorActiveGoalStopPolicy` mirrors the selected upstream order: runtime guard, disabled-runtime no-op, permit acquisition, current-active-goal guard, `:usage-limit-progress` or `:turn-error-progress` accounting, stored-goal lookup, stop eligibility, final status update, active-goal clear, and event emission.
- `ThreadReadTurnErrorActiveGoalStopOutcome` records stop reason, target status, progress/status event ids, accounting result, lookup result, status transition, active-goal clearing, terminal metric evidence, warning evidence, and deterministic summaries.

## Fixture

`fixtures/hxrust/thread-read-turn-error-active-goal-stop.v1.json` covers:

- usage-limit error stopping a budget-limited goal as `usageLimited`;
- generic terminal error blocking an active goal;
- runtime-missing skip;
- disabled-runtime skip;
- non-current active-goal no-op;
- goal-state permit failure warning;
- accounting failure warning;
- missing stored goal after accounting clearing active-goal state.

The fixture composes with the HXCX-4.31 active-goal accounting policy instead of restating accounting internals.

## Gate

```bash
bash harness/check-thread-read-turn-error-active-goal-stop.sh
```

The gate runs the Haxe interpreter, haxe.rust portable generation, generated Cargo check/test, and the generated binary.

## Non-Goals

This is turn-error stop-path evidence only. It does not own live async locks, production state DB handles, metrics/analytics clients, event emitters, live token aggregation, full error taxonomy, tool lifecycle callbacks, or Cafex/Cafetera behavior.
