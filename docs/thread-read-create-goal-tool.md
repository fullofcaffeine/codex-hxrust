# Thread/Read Create Goal Tool

**Bead:** `HXCX-4.40` / `codex-hxrust-qbs`

## Upstream Scope

This slice models the selected raw Codex `create_goal` executor path:

- `../codex/codex-rs/ext/goal/src/tool.rs:180` selects `GoalToolExecutor::handle_create`;
- `../codex/codex-rs/ext/goal/src/tool.rs:184` parses function arguments into `CreateGoalRequest`;
- `../codex/codex-rs/ext/goal/src/tool.rs:185` trims the objective before validation;
- `../codex/codex-rs/protocol/src/protocol.rs:3675` validates non-empty objectives with a 4000-character cap;
- `../codex/codex-rs/ext/goal/src/tool.rs:188` validates positive optional token budgets;
- `../codex/codex-rs/ext/goal/src/tool.rs:190` inserts an active thread goal;
- `../codex/codex-rs/ext/goal/src/tool.rs:200` converts insert errors to `FunctionCallError::RespondToModel`;
- `../codex/codex-rs/ext/goal/src/tool.rs:201` rejects unfinished-goal conflicts;
- `../codex/codex-rs/ext/goal/src/tool.rs:207` attempts preview fill and logs warnings without failing the tool;
- `../codex/codex-rs/ext/goal/src/tool.rs:208` marks the current turn goal active;
- `../codex/codex-rs/ext/goal/src/tool.rs:211` records metrics and analytics;
- `../codex/codex-rs/ext/goal/src/tool.rs:217` emits the goal-updated event from the tool call;
- `../codex/codex-rs/ext/goal/src/tool.rs:218` returns `goal_response` with `CompletionBudgetReport::Omit`;
- `../codex/codex-rs/ext/goal/src/spec.rs:25` defines the `create_goal` tool shape.

## Local Boundary

- `ThreadReadCreateGoalToolRequest` carries the invocation arguments, thread/turn ids, simulated insert outcome, preview outcome, and inserted goal DTO.
- `ThreadReadCreateGoalToolPolicy` mirrors the upstream order: parse arguments, trim/validate objective, validate token budget, insert active goal, preserve unfinished/error failures, attempt preview fill, mark accounting state, record metrics/analytics, emit the goal-updated event boundary, and return the structured response.
- `ThreadReadCreateGoalToolResponse` keeps `goal`, `remainingTokens`, and omitted `completionBudgetReport` typed.
- `ThreadReadCreateGoalToolOutcome` records argument parsing, validation, insert attempts, preview warning behavior, accounting/metrics/analytics/event boundaries, model-visible errors, response shape, and deterministic summaries.

## Fixture

`fixtures/hxrust/thread-read-create-goal-tool.v1.json` covers:

- invalid JSON rejection before insert;
- empty objective rejection after trim;
- zero-budget rejection;
- successful trimmed objective with token budget;
- successful create without budget while preserving preview warning behavior;
- unfinished-goal rejection;
- insert error conversion to a model-visible tool error.

## Gate

```bash
bash harness/check-thread-read-create-goal-tool.sh
```

The gate runs the Haxe interpreter, haxe.rust portable generation, generated Cargo check/test, and the generated binary.

## Non-Goals

This is selected `create_goal` executor evidence. It does not own production SQLite/log state, real async locks, full analytics/event implementations, credentialed model/provider behavior, update_goal behavior, or Cafex/Cafetera behavior.
