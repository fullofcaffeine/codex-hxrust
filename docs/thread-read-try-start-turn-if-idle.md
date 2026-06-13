# Thread/Read Try Start Turn If Idle

**Bead:** `HXCX-4.27` / `codex-hxrust-uxh`
**Fixture:** `fixtures/hxrust/thread-read-try-start-turn-if-idle.v1.json`
**Gate:** `harness/check-thread-read-try-start-turn-if-idle.sh`

## Purpose

This slice models selected upstream `CodexThread::try_start_turn_if_idle` admission behavior after a goal steering item has been built. The output is a typed host-admission decision: accept automatic idle work as a regular task, reject with the upstream reason while returning the original item unchanged, no-op on empty input, or fail closed when no steering item exists.

## Upstream Anchors

- `../codex/codex-rs/core/src/codex_thread.rs:77`
- `../codex/codex-rs/core/src/codex_thread.rs:98`
- `../codex/codex-rs/core/src/codex_thread.rs:297`
- `../codex/codex-rs/core/src/session/inject.rs:43`
- `../codex/codex-rs/core/src/session/inject.rs:50`
- `../codex/codex-rs/core/src/session/inject.rs:56`
- `../codex/codex-rs/core/src/session/inject.rs:68`
- `../codex/codex-rs/core/src/session/inject.rs:125`
- `../codex/codex-rs/core/src/session/tests.rs:8817`
- `../codex/codex-rs/core/src/session/tests.rs:8851`
- `../codex/codex-rs/core/src/session/tests.rs:8879`
- `../codex/codex-rs/core/src/session/tests.rs:8911`

## Boundary Shape

The Haxe facade lives in `codexhx.runtime.app.threadread`:

- `ThreadReadTryStartTurnIfIdleActiveTaskKind` distinguishes no active task, regular task, and review task.
- `ThreadReadTryStartTurnIfIdleRejectionReason` mirrors the selected upstream reasons: pending trigger turn, Plan mode, and busy.
- `ThreadReadTryStartTurnIfIdleRequest` carries the emitted steering outcome plus typed host state flags.
- `ThreadReadTryStartTurnIfIdlePolicy` preserves upstream ordering: empty input, pending trigger mailbox, Plan mode, active turn, reservation, rechecks, pending input injection, and regular task start.
- `ThreadReadTryStartTurnIfIdleOutcome` records accepted/rejected/no-op/failure state, reservation cleanup, input injection, task start, original-item preservation, and deterministic sequence summaries.

## Selected Behavior

- Accepted automatic idle work reserves an active turn, injects the steering item as pending input, and starts a regular task.
- Busy rejection covers both active regular turns and active review turns.
- Plan mode rejection happens before reservation and again after turn-context construction.
- Pending trigger-turn mailbox rejection happens before reservation, after reservation, and again before task start.
- Reservation loss before task start rejects as busy.
- Rejections preserve the returned steering item summary unchanged, matching upstream `TryStartTurnIfIdleError::into_input`.
- Empty input returns Ok without reserving or starting a task.

## Non-Goals

- Owning live `Session`, `InputQueue`, `ActiveTurn`, or task spawning.
- Implementing async runtime, cancellation, model warning emission, or pending-work scheduling.
- Reading production goal state or JSON-RPC transport.
- Cafex or Cafetera adapter behavior.

## haxe.rust Pressure

No new haxe.rust limitation was exposed. The harness passes through the Haxe interpreter and portable haxe.rust-generated Rust with no raw Rust escapes.
