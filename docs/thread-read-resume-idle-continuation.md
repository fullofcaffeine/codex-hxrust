# Thread/Read Resume Idle Continuation

**Bead:** `HXCX-4.25` / `codex-hxrust-iqo`
**Fixture:** `fixtures/hxrust/thread-read-resume-idle-continuation.v1.json`
**Gate:** `harness/check-thread-read-resume-idle-continuation.sh`

## Purpose

This slice models the selected upstream idle lifecycle continuation path that follows ordered resume goal snapshots. It distinguishes the app-server/core idle hook from the goal extension's decision to continue an active goal by starting automatic idle work.

## Upstream Anchors

- `../codex/codex-rs/app-server/src/request_processors/thread_goal_processor.rs:66`
- `../codex/codex-rs/app-server/src/request_processors/thread_lifecycle.rs:688`
- `../codex/codex-rs/core/src/tasks/lifecycle.rs:41`
- `../codex/codex-rs/core/src/codex_thread.rs:215`
- `../codex/codex-rs/ext/extension-api/src/contributors.rs:68`
- `../codex/codex-rs/ext/goal/src/extension.rs:154`
- `../codex/codex-rs/ext/goal/src/runtime.rs:348`
- `../codex/codex-rs/ext/goal/src/runtime.rs:388`
- `../codex/codex-rs/core/src/session/tests.rs:8729`
- `../codex/codex-rs/core/src/session/tests.rs:8777`
- `../codex/codex-rs/app-server/tests/suite/v2/thread_resume.rs:920`

## Boundary Shape

The Haxe facade lives in `codexhx.runtime.app.threadread`:

- `ThreadReadResumeIdleContinuationRequest` carries the settled snapshot outcome, thread idle guards, goal status, goal runtime availability, and host automatic-start result.
- `ThreadReadResumeIdleContinuationPolicy` preserves the post-snapshot idle lifecycle ordering.
- `ThreadReadResumeIdleContinuationOutcome` records idle-hook emission, continuation request, automatic turn start, active-goal accounting clear, skip/failure code, and deterministic sequence.
- `ThreadReadResumeIdleContinuationReport` summarizes fixture outcomes.

## Selected Behavior

- Resume idle continuation waits for response, token-usage delivery, and goal snapshot ordering to settle.
- Fork is not routed through the resume idle lifecycle path.
- When goals are disabled, upstream returns before the resume idle hook.
- The core idle hook does not fire while an active turn exists or trigger-turn mailbox work is pending.
- Loaded running-thread resume places pending request replay before the idle hook.
- A cleared goal or non-active goal status is snapshot-only and clears active-goal accounting.
- Active goals may request continuation only when tools are visible and the live thread can be found.
- Host rejection of `try_start_turn_if_idle` is a deterministic skip, not a snapshot failure.

## Non-Goals

- Starting real turns, spawning tasks, or opening transports.
- Implementing extension stores, `ThreadManager`, or `StateDbHandle`.
- Emitting JSON-RPC notifications.
- Modeling Cafex/Cafetera behavior.

## haxe.rust Pressure

No new haxe.rust limitation was exposed. The harness passes through the Haxe interpreter and portable haxe.rust-generated Rust with no raw Rust escapes.
