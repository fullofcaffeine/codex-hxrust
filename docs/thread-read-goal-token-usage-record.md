# Thread/Read Goal Token Usage Record

**Bead:** `HXCX-4.36` / `codex-hxrust-63x`

## Upstream Scope

This slice models the selected raw Codex token-usage contribution path for goal accounting:

- `../codex/codex-rs/ext/goal/src/extension.rs:330` selects `TokenUsageContributor::on_token_usage`;
- `../codex/codex-rs/ext/goal/src/extension.rs:338` skips when `goal_runtime_handle` is unavailable;
- `../codex/codex-rs/ext/goal/src/extension.rs:341` skips when the runtime is disabled;
- `../codex/codex-rs/ext/goal/src/extension.rs:347` passes `turn_store.level_id()` and `token_usage.total_token_usage` into `GoalAccountingState::record_token_usage`;
- `../codex/codex-rs/ext/goal/src/accounting.rs:111` owns `record_token_usage`;
- `../codex/codex-rs/ext/goal/src/accounting.rs:118` skips unknown turns;
- `../codex/codex-rs/ext/goal/src/accounting.rs:119` updates `current_token_usage` before later skip checks;
- `../codex/codex-rs/ext/goal/src/accounting.rs:120` skips turns with token accounting disabled;
- `../codex/codex-rs/ext/goal/src/accounting.rs:124` computes the goal-charge delta since `last_accounted_token_usage`;
- `../codex/codex-rs/ext/goal/src/accounting.rs:128` returns `RecordedTokenDelta`;
- `../codex/codex-rs/ext/goal/src/accounting.rs:328` charges non-cached input plus output tokens.

## Local Boundary

- `ThreadReadGoalTokenUsageRecordRequest` carries runtime state, `turn_store.level_id`, current-turn evidence, known-turn/token-accounting flags, previous current usage, last-accounted baseline, total usage, and other unflushed token delta.
- `ThreadReadGoalTokenUsageRecordPolicy` mirrors the selected upstream order: runtime guard, disabled-runtime guard, unknown-turn guard, current-usage update, token-accounting guard, non-positive goal-delta guard, and `RecordedTokenDelta` construction.
- `ThreadReadGoalTokenUsageRecordOutcome` records whether the current usage was updated, whether a delta was recorded, exact turn/thread unflushed deltas, goal-charge delta, and evidence that reasoning/total tokens are not directly charged for goal progress.

## Fixture

`fixtures/hxrust/thread-read-goal-token-usage-record.v1.json` covers:

- runtime-missing skip;
- disabled-runtime skip;
- token-accounting disabled skip that still updates current usage;
- unknown-turn skip before current usage update;
- successful current-turn record with the upstream 28-token delta;
- repeated/larger total usage update that keeps the last-accounted baseline;
- zero goal-charge delta that still updates current usage.

## Gate

```bash
bash harness/check-thread-read-goal-token-usage-record.sh
```

The gate runs the Haxe interpreter, haxe.rust portable generation, generated Cargo check/test, and the generated binary.

## Non-Goals

This is token-usage accounting-state evidence only. It does not own live token aggregation, analytics emission, production state DB writes, active-goal progress persistence, metrics clients, model/provider behavior, or Cafex/Cafetera behavior.
