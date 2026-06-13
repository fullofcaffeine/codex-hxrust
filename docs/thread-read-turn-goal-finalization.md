# Thread/Read Turn Goal Finalization

**Bead:** `HXCX-4.34` / `codex-hxrust-q24`
**Fixture:** `fixtures/hxrust/thread-read-turn-goal-finalization.v1.json`
**Gate:** `harness/check-thread-read-turn-goal-finalization.sh`

## Purpose

This slice models selected upstream goal finalization at turn stop and turn abort. It records the pure decision surface around runtime guards, active-goal progress accounting with `ActiveOnly` and `ClearActive`, event id suffixes, accounting-error short-circuiting, and `finish_turn`.

## Upstream Anchors

- `../codex/codex-rs/ext/goal/src/extension.rs:243`
- `../codex/codex-rs/ext/goal/src/extension.rs:245`
- `../codex/codex-rs/ext/goal/src/extension.rs:248`
- `../codex/codex-rs/ext/goal/src/extension.rs:253`
- `../codex/codex-rs/ext/goal/src/extension.rs:256`
- `../codex/codex-rs/ext/goal/src/extension.rs:257`
- `../codex/codex-rs/ext/goal/src/extension.rs:258`
- `../codex/codex-rs/ext/goal/src/extension.rs:267`
- `../codex/codex-rs/ext/goal/src/extension.rs:271`
- `../codex/codex-rs/ext/goal/src/extension.rs:281`
- `../codex/codex-rs/ext/goal/src/extension.rs:284`
- `../codex/codex-rs/ext/goal/src/extension.rs:295`
- `../codex/codex-rs/ext/goal/src/accounting.rs:258`

## Boundary Shape

The Haxe facade lives in `codexhx.runtime.app.threadread`:

- `ThreadReadTurnGoalFinalizationRequest` carries stop/abort kind, runtime availability/enabled state, turn id, and a composed `ThreadReadActiveGoalProgressAccountingOutcome`.
- `ThreadReadTurnGoalFinalizationKind` keeps turn-stop versus turn-abort typed at the policy boundary.
- `ThreadReadTurnGoalFinalizationPolicy` mirrors the selected upstream order: runtime missing skip, disabled skip, compute `:turn-stop`/`:turn-abort` event id, account active goal progress with `active_only` and `clear_active`, return on accounting error, otherwise finish the turn.
- `ThreadReadTurnGoalFinalizationOutcome` records accounting mode, disposition, event id, nested accounting code, progress return state, active-goal clearing, `finish_turn`, warning evidence, and deterministic sequence summaries.

## Selected Behavior

- Missing runtime skips before progress accounting.
- Disabled runtime skips before progress accounting.
- Turn stop uses event id suffix `:turn-stop`; turn abort uses `:turn-abort`.
- Both hooks use `GoalAccountingMode::ActiveOnly` and `BudgetLimitedGoalDisposition::ClearActive`.
- Accounting errors log warning evidence and preserve the turn by skipping `finish_turn`.
- `Ok(None)` accounting still finishes the turn.
- Successful accounting with returned progress finishes the turn after preserving the nested accounting outcome.
- Budget-limited clear-active outcomes clear active accounting and still finish the turn.

## Non-Goals

- Owning full active-goal progress accounting internals beyond composing with HXCX-4.31.
- Owning turn error goal stopping, token usage aggregation, production state DB handles, metrics, analytics, or event emitters.
- Starting live turns, injecting steering, or emitting user-visible notifications.
- Cafex or Cafetera adapter behavior.

## haxe.rust Pressure

No new haxe.rust limitation was exposed. The harness passes through the Haxe interpreter and portable haxe.rust-generated Rust with typed DTOs/enums, nested outcome composition, and no raw Rust escapes.
