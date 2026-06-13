# Thread/Read Update Goal Tool

**Bead:** `HXCX-4.41` / `codex-hxrust-7z0`

## Upstream Scope

This slice models the selected raw Codex `update_goal` executor path:

- `../codex/codex-rs/ext/goal/src/tool.rs:221` selects `GoalToolExecutor::handle_update`;
- `../codex/codex-rs/ext/goal/src/tool.rs:225` parses `UpdateGoalArgs`;
- `../codex/codex-rs/ext/goal/src/tool.rs:226` accepts only `complete` and `blocked`;
- `../codex/codex-rs/ext/goal/src/tool.rs:236` accounts active goal progress before updating;
- `../codex/codex-rs/ext/goal/src/tool.rs:238` uses `ActiveOrComplete` for complete;
- `../codex/codex-rs/ext/goal/src/tool.rs:239` uses `ActiveOrStopped` for blocked;
- `../codex/codex-rs/ext/goal/src/tool.rs:246` uses `BudgetLimitedGoalDisposition::ClearActive`;
- `../codex/codex-rs/ext/goal/src/tool.rs:249` reads the previous status for metrics;
- `../codex/codex-rs/ext/goal/src/tool.rs:252` updates only the goal status;
- `../codex/codex-rs/ext/goal/src/tool.rs:265` converts update errors to model-visible tool errors;
- `../codex/codex-rs/ext/goal/src/tool.rs:268` rejects missing goals;
- `../codex/codex-rs/ext/goal/src/tool.rs:273` records terminal-status metrics;
- `../codex/codex-rs/ext/goal/src/tool.rs:275` records analytics status changes;
- `../codex/codex-rs/ext/goal/src/tool.rs:281` clears the current turn goal;
- `../codex/codex-rs/ext/goal/src/tool.rs:282` emits a goal-updated event using the call id;
- `../codex/codex-rs/ext/goal/src/tool.rs:283` includes completion-budget reports for complete and omits them for blocked;
- `../codex/codex-rs/ext/goal/src/tool.rs:491` defines the completion-budget report text rule;
- `../codex/codex-rs/ext/goal/src/spec.rs:60` defines the `update_goal` tool shape.

## Local Boundary

- `ThreadReadUpdateGoalToolRequest` carries the invocation ids, arguments, selected accounting outcome, metrics-status read outcome, update outcome, clear-current-turn result, and updated goal DTO.
- `ThreadReadUpdateGoalToolPolicy` mirrors the upstream order: parse, validate status, account progress, read previous status, update status, record metrics/analytics, clear current-turn goal, emit event, and return the structured response.
- `ThreadReadUpdateGoalToolResponse` keeps `goal`, `remainingTokens`, and optional `completionBudgetReport` typed.
- `ThreadReadUpdateGoalToolOutcome` records accounting mode/disposition/event id, metrics/update/error boundaries, clear-current-turn and event evidence, completion-report inclusion, and deterministic summaries.

## Fixture

`fixtures/hxrust/thread-read-update-goal-tool.v1.json` covers:

- invalid JSON rejection;
- unsupported status rejection;
- complete success with active progress accounting and completion-budget report;
- blocked success with no-snapshot accounting and no completion-budget report;
- complete success with no current turn and no completion-budget report;
- accounting error;
- metrics-status read error;
- update missing-goal rejection;
- update state error.

## Gate

```bash
bash harness/check-thread-read-update-goal-tool.sh
```

The gate runs the Haxe interpreter, haxe.rust portable generation, generated Cargo check/test, and the generated binary.

## Non-Goals

This is selected `update_goal` executor evidence. It does not own production SQLite/log state, real async locks, full analytics/event implementations, credentialed model/provider behavior, create_goal behavior, or Cafex/Cafetera behavior.
