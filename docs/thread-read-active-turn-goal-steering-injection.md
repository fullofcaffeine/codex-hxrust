# Thread/Read Active-Turn Goal Steering Injection

**Bead:** `HXCX-4.29` / `codex-hxrust-bwt`
**Fixture:** `fixtures/hxrust/thread-read-active-turn-goal-steering-injection.v1.json`
**Gate:** `harness/check-thread-read-active-turn-goal-steering-injection.sh`

## Purpose

This slice models selected upstream goal steering injection into an already running turn. The input is an emitted goal steering item, usually from objective-update steering, plus host runtime availability. The output records whether the item was injected into the active turn, skipped because no live runtime/thread/turn was available, or failed because no steering item existed.

## Upstream Anchors

- `../codex/codex-rs/ext/goal/src/runtime.rs:189`
- `../codex/codex-rs/ext/goal/src/runtime.rs:204`
- `../codex/codex-rs/ext/goal/src/runtime.rs:417`
- `../codex/codex-rs/ext/goal/src/runtime.rs:419`
- `../codex/codex-rs/ext/goal/src/runtime.rs:423`
- `../codex/codex-rs/ext/goal/src/runtime.rs:426`
- `../codex/codex-rs/core/src/codex_thread.rs:283`
- `../codex/codex-rs/core/src/session/inject.rs:19`
- `../codex/codex-rs/core/src/session/inject.rs:25`
- `../codex/codex-rs/core/src/session/inject.rs:33`
- `../codex/codex-rs/ext/goal/src/steering.rs:41`

## Boundary Shape

The Haxe facade lives in `codexhx.runtime.app.threadread`:

- `ThreadReadActiveTurnGoalSteeringInjectionRequest` carries a goal steering outcome plus thread-manager, live-thread, and active-turn availability.
- `ThreadReadActiveTurnGoalSteeringInjectionPolicy` mirrors the selected upstream order: steering item required, thread manager lookup, live thread lookup, `inject_if_running`.
- `ThreadReadActiveTurnGoalSteeringInjectionOutcome` records injected/skipped/failure state, lookup attempts, `inject_if_running` attempt, pending-input extension, unchanged returned item summaries, unchanged injected item summaries, and deterministic sequence summaries.

## Selected Behavior

- Objective-updated steering uses the existing HXCX-4.26 steering builder and keeps the injected item summary unchanged.
- Missing thread manager skips before thread lookup.
- Missing live thread skips before `inject_if_running`.
- Missing active turn calls `inject_if_running`, receives the original item back unchanged, and skips injection.
- Running active turn extends pending input for that active turn.
- Missing or skipped steering item fails closed before host lookup.

## Non-Goals

- Owning live `ThreadManager`, `CodexThread`, `Session`, `InputQueue`, or active-turn locks.
- Implementing async scheduling, live task mutation, or production state DB ownership.
- Budget-limit steering; this slice focuses on objective-update active-turn injection.
- Cafex or Cafetera adapter behavior.

## haxe.rust Pressure

No new haxe.rust limitation was exposed. The harness passes through the Haxe interpreter and portable haxe.rust-generated Rust with no raw Rust escapes.
