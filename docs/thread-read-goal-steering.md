# Thread/Read Goal Steering

**Bead:** `HXCX-4.26` / `codex-hxrust-4lo`
**Fixture:** `fixtures/hxrust/thread-read-goal-steering.v1.json`
**Gate:** `harness/check-thread-read-goal-steering.sh`

## Purpose

This slice models the selected upstream goal steering item payloads submitted by the goal runtime. The output is a typed contextual user fragment with source `goal`; it does not start turns or inject live items itself.

## Upstream Anchors

- `../codex/codex-rs/ext/goal/src/steering.rs:34`
- `../codex/codex-rs/ext/goal/src/steering.rs:38`
- `../codex/codex-rs/ext/goal/src/steering.rs:42`
- `../codex/codex-rs/ext/goal/src/steering.rs:46`
- `../codex/codex-rs/ext/goal/src/steering.rs:54`
- `../codex/codex-rs/ext/goal/src/steering.rs:94`
- `../codex/codex-rs/ext/goal/templates/goals/continuation.md`
- `../codex/codex-rs/ext/goal/templates/goals/objective_updated.md`
- `../codex/codex-rs/ext/goal/src/runtime.rs:205`
- `../codex/codex-rs/ext/goal/src/runtime.rs:392`
- `../codex/codex-rs/core/src/codex_thread.rs:297`

## Boundary Shape

The Haxe facade lives in `codexhx.runtime.app.threadread`:

- `ThreadReadGoalSteeringItemKind` distinguishes continuation and objective-updated steering.
- `ThreadReadGoalSteeringRequest` carries the goal, steering kind, continuation decision, and objective-change flag.
- `ThreadReadGoalSteeringBuilder` creates contextual user fragments and preserves the selected template fields.
- `ThreadReadGoalSteeringOutcome` records emitted, skipped, and failure results with deterministic item summaries.

## Selected Behavior

- Steering items use source `goal` and fragment kind `contextual_user_fragment`.
- Continuation steering requires an active goal and a settled HXCX-4.25 continuation decision that requested goal continuation.
- A host-rejected automatic start still has a continuation steering item because the item is created before `try_start_turn_if_idle` returns.
- Objective-updated steering requires an active goal and an actual objective change.
- Cleared, missing, non-active, unchanged, and unsettled continuation states fail or skip deterministically.
- Objective text escapes `&`, `<`, and `>` before it enters the prompt.
- Continuation prompts render no budget as `none` and remaining tokens as `unbounded`; objective-updated prompts render no budget as `none` and remaining tokens as `unknown`.

## Non-Goals

- Implementing the full Rust template engine.
- Starting turns, injecting active-turn steering, or owning live extension stores.
- Reading production goal state or JSON-RPC transport.
- Cafex or Cafetera adapter behavior.

## haxe.rust Pressure

No new haxe.rust limitation was exposed. The harness passes through the Haxe interpreter and portable haxe.rust-generated Rust with no raw Rust escapes.
