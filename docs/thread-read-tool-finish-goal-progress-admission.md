# Thread/Read Tool-Finish Goal Progress Admission

**Bead:** `HXCX-4.37` / `codex-hxrust-lze`

## Upstream Scope

This slice models the selected raw Codex tool-finish admission path before active-goal progress accounting and budget-limit steering:

- `../codex/codex-rs/ext/goal/src/extension.rs:359` selects `GoalExtension::on_tool_finish`;
- `../codex/codex-rs/ext/goal/src/extension.rs:361` skips when `goal_runtime_handle` is unavailable;
- `../codex/codex-rs/ext/goal/src/extension.rs:364` requires `runtime.is_enabled()`;
- `../codex/codex-rs/ext/goal/src/extension.rs:365` gates through `tool_attempt_counts_for_goal_progress`;
- `../codex/codex-rs/ext/goal/src/extension.rs:366` excludes bare `update_goal`;
- `../codex/codex-rs/ext/goal/src/extension.rs:373` hands off to `account_active_goal_progress`;
- `../codex/codex-rs/ext/goal/src/extension.rs:375` uses `input.call_id` as the accounting event id;
- `../codex/codex-rs/ext/goal/src/extension.rs:376` uses `GoalAccountingMode::ActiveOnly`;
- `../codex/codex-rs/ext/goal/src/extension.rs:377` uses `BudgetLimitedGoalDisposition::KeepActive`;
- `../codex/codex-rs/ext/goal/src/extension.rs:381` handles `Ok(Some(progress))`, `Ok(None)`, and errors;
- `../codex/codex-rs/ext/goal/src/extension.rs:391` continues only for budget-limited progress;
- `../codex/codex-rs/ext/goal/src/extension.rs:483` defines which tool outcomes count.

## Local Boundary

- `ThreadReadToolCallOutcomeKind` keeps completed, failed, blocked, and aborted tool outcomes typed.
- `ThreadReadToolFinishGoalProgressAdmissionRequest` carries runtime state, turn/call ids, tool namespace/name, outcome flags, and an optional HXCX-4.31 active-goal accounting outcome.
- `ThreadReadToolFinishGoalProgressAdmissionPolicy` mirrors the selected upstream order: runtime guard, enabled guard, tool outcome admission, bare `update_goal` exclusion, active-goal accounting handoff, warning/no-progress/progress outcomes, and budget-limit boundary detection.
- `ThreadReadToolFinishGoalProgressAdmissionOutcome` records tool outcome classification, `update_goal` self-tool filtering, admission state, accounting mode/disposition/event id, accounting result, budget-limit handoff, warning evidence, and deterministic summaries.

## Fixture

`fixtures/hxrust/thread-read-tool-finish-goal-progress-admission.v1.json` covers:

- runtime-missing skip;
- disabled-runtime skip;
- completed success counting;
- completed with failure output still counting;
- failed with handler executed counting;
- failed before handler execution skipping;
- blocked skipping;
- aborted skipping;
- bare `update_goal` skipping;
- namespaced `update_goal` counting and warning on accounting error.

## Gate

```bash
bash harness/check-thread-read-tool-finish-goal-progress-admission.sh
```

The gate runs the Haxe interpreter, haxe.rust portable generation, generated Cargo check/test, and the generated binary.

## Non-Goals

This is tool-finish admission evidence only. It composes with the HXCX-4.31 active-goal accounting and HXCX-4.30 budget-limit steering boundaries, but does not own live tool execution, production state DB writes, event emitters, active-turn injection, model/provider behavior, or Cafex/Cafetera behavior.
