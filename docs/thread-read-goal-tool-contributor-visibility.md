# Thread/Read Goal Tool Contributor Visibility

**Bead:** `HXCX-4.38` / `codex-hxrust-ebh`

## Upstream Scope

This slice models the selected raw Codex goal tool contribution path:

- `../codex/codex-rs/ext/goal/src/extension.rs:406` implements `ToolContributor` for `GoalExtension`;
- `../codex/codex-rs/ext/goal/src/extension.rs:415` skips when `goal_runtime_handle` is unavailable;
- `../codex/codex-rs/ext/goal/src/extension.rs:418` skips when `runtime.tools_visible()` is false;
- `../codex/codex-rs/ext/goal/src/extension.rs:422` returns `GoalToolExecutor::get`, `GoalToolExecutor::create`, and `GoalToolExecutor::update` in that order;
- `../codex/codex-rs/ext/goal/src/runtime.rs:114` defines `tools_visible()` as `is_enabled() && tools_available_for_thread`;
- `../codex/codex-rs/ext/goal/src/tool.rs:75` defines the goal tool executor constructors;
- `../codex/codex-rs/ext/goal/src/tool.rs:135` maps executor kinds to plain tool names;
- `../codex/codex-rs/ext/goal/src/spec.rs:9` defines `get_goal`, `create_goal`, and `update_goal`.

## Local Boundary

- `ThreadReadGoalToolContributorVisibilityRequest` carries the runtime handle flags and the thread/runtime boundary inputs needed to decide visibility.
- `ThreadReadGoalToolContributorVisibilityPolicy` mirrors the upstream order: missing runtime returns no tools, invisible runtime returns no tools, visible runtime returns get/create/update descriptors.
- `ThreadReadGoalToolExecutorKind` and `ThreadReadGoalToolExecutorDescriptor` keep tool executor names, ordering, thread id, and attached runtime boundary handles typed rather than stringly inside the policy.
- `ThreadReadGoalToolContributorVisibilityOutcome` records the skip/visible code, `tools_visible` inputs, returned tool count, stable order, and deterministic summary evidence.

## Fixture

`fixtures/hxrust/thread-read-goal-tool-contributor-visibility.v1.json` covers:

- runtime missing;
- runtime disabled;
- tools unavailable for this thread;
- visible tools with stable upstream get/create/update ordering.

## Gate

```bash
bash harness/check-thread-read-goal-tool-contributor-visibility.sh
```

The gate runs the Haxe interpreter, haxe.rust portable generation, generated Cargo check/test, and the generated binary.

## Non-Goals

This is tool contributor visibility and descriptor evidence only. It does not execute `get_goal`, `create_goal`, or `update_goal`, mutate production state, emit analytics/events, create credentials, or model Cafex/Cafetera behavior.
