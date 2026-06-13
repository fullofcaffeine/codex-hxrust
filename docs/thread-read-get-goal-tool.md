# Thread/Read Get Goal Tool

**Bead:** `HXCX-4.39` / `codex-hxrust-0cy`

## Upstream Scope

This slice models the selected raw Codex `get_goal` executor path:

- `../codex/codex-rs/ext/goal/src/tool.rs:162` selects `GoalToolExecutor::handle_get`;
- `../codex/codex-rs/ext/goal/src/tool.rs:167` accepts function arguments before reading state;
- `../codex/codex-rs/ext/goal/src/tool.rs:168` reads `state_db.thread_goals().get_thread_goal(self.thread_id)`;
- `../codex/codex-rs/ext/goal/src/tool.rs:173` maps a stored goal through `protocol_goal_from_state`;
- `../codex/codex-rs/ext/goal/src/tool.rs:174` converts read failures to `FunctionCallError::RespondToModel`;
- `../codex/codex-rs/ext/goal/src/tool.rs:177` calls `goal_response` with `CompletionBudgetReport::Omit`;
- `../codex/codex-rs/ext/goal/src/tool.rs:409` serializes `GoalToolResponse`;
- `../codex/codex-rs/ext/goal/src/tool.rs:420` calculates remaining tokens as `max(token_budget - tokens_used, 0)`;
- `../codex/codex-rs/ext/goal/src/tool.rs:424` omits completion-budget reports unless requested by the caller;
- `../codex/codex-rs/ext/goal/src/spec.rs:13` defines the `get_goal` tool shape.

## Local Boundary

- `ThreadReadGetGoalToolRequest` carries the invocation arguments, thread id, selected state-read outcome, and optional stored goal.
- `ThreadReadGetGoalToolPolicy` mirrors the read-only upstream order: validate arguments, read state, map missing/found/error outcomes, and build a response with completion-budget reporting omitted.
- `ThreadReadGetGoalToolResponse` keeps `goal`, `remainingTokens`, and `completionBudgetReport` typed instead of string-only JSON.
- `ThreadReadGetGoalToolOutcome` records argument acceptance, read attempts, model-visible errors, remaining-token math, side-effect absence, and deterministic summaries.

## Fixture

`fixtures/hxrust/thread-read-get-goal-tool.v1.json` covers:

- empty arguments accepted with no current goal;
- active budgeted goal response with remaining tokens;
- completed goal response with completion-budget report omitted;
- state read error converted to a model-visible tool error.

## Gate

```bash
bash harness/check-thread-read-get-goal-tool.sh
```

The gate runs the Haxe interpreter, haxe.rust portable generation, generated Cargo check/test, and the generated binary.

## Non-Goals

This is read-only `get_goal` executor evidence. It does not create or update goals, mutate production state, emit analytics/events, own production SQLite/log state, create credentials, or model Cafex/Cafetera behavior.
