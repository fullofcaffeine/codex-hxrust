# Thread/Read Turn-Start Goal Accounting

**Bead:** `HXCX-4.33` / `codex-hxrust-ur5`
**Fixture:** `fixtures/hxrust/thread-read-turn-start-goal-accounting.v1.json`
**Gate:** `harness/check-thread-read-turn-start-goal-accounting.sh`

## Purpose

This slice models selected upstream goal accounting setup at turn start. It records the pure decision surface around runtime availability, enabled guards, `start_turn`, Plan-mode clearing, stored goal lookup, and marking active or budget-limited stored goals as active for the current turn.

## Upstream Anchors

- `../codex/codex-rs/ext/goal/src/extension.rs:201`
- `../codex/codex-rs/ext/goal/src/extension.rs:203`
- `../codex/codex-rs/ext/goal/src/extension.rs:206`
- `../codex/codex-rs/ext/goal/src/extension.rs:210`
- `../codex/codex-rs/ext/goal/src/extension.rs:216`
- `../codex/codex-rs/ext/goal/src/extension.rs:220`
- `../codex/codex-rs/ext/goal/src/extension.rs:223`
- `../codex/codex-rs/ext/goal/src/extension.rs:231`
- `../codex/codex-rs/ext/goal/src/extension.rs:238`
- `../codex/codex-rs/ext/goal/src/accounting.rs:67`
- `../codex/codex-rs/ext/goal/src/accounting.rs:134`
- `../codex/codex-rs/ext/goal/src/accounting.rs:174`

## Boundary Shape

The Haxe facade lives in `codexhx.runtime.app.threadread`:

- `ThreadReadTurnStartGoalAccountingRequest` carries runtime availability/enabled state, turn id, collaboration mode, starting token usage, stored-goal lookup result, stored goal, and prior budget-limit reported goal id.
- `ThreadReadTurnStartCollaborationMode` and `ThreadReadStoredGoalLookupOutcomeKind` keep mode and state lookup outcomes typed at the policy boundary.
- `ThreadReadTurnStartGoalAccountingPolicy` mirrors the selected upstream order: runtime missing skip, disabled skip, `start_turn`, Plan clear/return, stored-goal lookup, and active/budget-limited turn marking.
- `ThreadReadTurnStartGoalAccountingOutcome` records start-turn accounting, token-accounting enabled state, Plan-mode clearing, lookup outcome, marked active goal id, wall-clock active goal id, budget-limit report clearing, state lookup errors, and deterministic sequence summaries.

## Selected Behavior

- Missing runtime skips before `start_turn`.
- Disabled runtime skips before `start_turn`.
- `start_turn` stores the current turn and disables token accounting for Plan mode.
- Plan mode calls `clear_current_turn_goal` and returns before stored-goal lookup.
- Stored-goal lookup errors are upstream-style no-op skips, not turn-start failures.
- Missing stored goals and non-active statuses skip current-turn goal marking.
- Stored goals with `active` or `budgetLimited` status call `mark_turn_goal_active`.
- Prior budget-limit report state is cleared when it points to a different goal id and preserved when it already points to the same budget-limited goal.

## Non-Goals

- Owning full turn lifecycle, token usage aggregation, turn stop/abort/error hooks, or production state DB handles.
- Starting live turns, injecting steering, or emitting user-visible notifications.
- Replacing the full upstream goal extension lifecycle.
- Cafex or Cafetera adapter behavior.

## haxe.rust Pressure

No new haxe.rust limitation was exposed. The harness passes through the Haxe interpreter and portable haxe.rust-generated Rust with typed DTOs/enums and no raw Rust escapes.
