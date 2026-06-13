# HXCX-4.42 Raw Codex Goal Tool Executor Integration

This slice models the upstream `GoalToolExecutor` tool-selection surface after the individual raw `get_goal`, `create_goal`, and `update_goal` policies were ported.

Selected upstream references:

- `../codex/codex-rs/ext/goal/src/tool.rs:75` defines `GoalToolExecutor::get/create/update` constructors.
- `../codex/codex-rs/ext/goal/src/tool.rs:134` maps `GoalToolKind` to tool names and specs.
- `../codex/codex-rs/ext/goal/src/tool.rs:151` dispatches `handle` to `handle_get`, `handle_create`, or `handle_update`.
- `../codex/codex-rs/ext/goal/src/spec.rs:9` defines the public `get_goal`, `create_goal`, and `update_goal` names and argument schemas.

The Haxe port keeps behavior in the existing tool-specific policies, then adds typed dispatch DTOs:

- `ThreadReadGoalToolKind` models the three public tool names.
- `ThreadReadGoalToolSpec` captures the selected upstream schema facts: non-strict function tools, closed parameters, required fields, and the `complete|blocked` update enum.
- `ThreadReadGoalToolDispatchRequest` carries exactly one typed request payload.
- `ThreadReadGoalToolDispatchOutcome` normalizes shared response shape and event/report visibility across all three tools.
- `ThreadReadGoalToolDispatchReport` summarizes success, errors, emitted events, completion-budget reports, and spec mismatches.

The fixture `fixtures/hxrust/thread-read-goal-tool-dispatch.v1.json` proves:

- `get_goal`, `create_goal`, and `update_goal` names match their selected specs.
- All three tools expose the shared structured response shape: `goal`, `remainingTokens`, and `completionBudgetReport`.
- A realistic raw sequence can read a missing goal, create one, read it back, complete it with a report, and mark another goal blocked without a report.
- Representative error paths remain model-visible and do not emit goal-updated events.
- No Cafex/Cafetera-specific code participates in the executor surface.

Run:

```bash
bash harness/check-thread-read-goal-tool-dispatch.sh
```
