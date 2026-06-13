# Thread/Read Active-Turn Merge

**Bead:** `HXCX-4.19` / `codex-hxrust-6pz`
**Fixture:** `fixtures/hxrust/thread-read-active-turn-merge.v1.json`
**Gate:** `harness/check-thread-read-active-turn-merge.sh`

## Purpose

This slice ports the selected raw upstream Codex active-turn merge and stale-status normalization behavior used around `thread/read` and `thread/turns/list`. It consumes reconstructed turn summaries and a selected live active-turn snapshot, then returns a normalized turn list plus resolved thread status.

This is pure state behavior. It does not own the app-server thread manager, watch manager, listener loop, rollout storage, or production persistence.

## Upstream Anchors

- `../codex/codex-rs/app-server/src/thread_status.rs:285`
- `../codex/codex-rs/app-server/src/request_processors/thread_lifecycle.rs:778`
- `../codex/codex-rs/app-server/src/request_processors/thread_lifecycle.rs:783`
- `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:3796`
- `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:3814`
- `../codex/codex-rs/app-server/src/thread_state.rs:138`
- `../codex/codex-rs/app-server-protocol/src/protocol/thread_history.rs:120`
- `../codex/codex-rs/app-server/src/request_processors/thread_processor_tests.rs:214`

## Boundary Shape

The Haxe facade lives in `codexhx.runtime.app.threadread`:

- `ThreadReadThreadStatus` models the selected upstream thread statuses: `notLoaded`, `idle`, `systemError`, and `active`.
- `ThreadReadActiveTurnMergeRequest` carries loaded status, live-running observation, and an optional active turn snapshot.
- `ThreadReadActiveTurnMerger` resolves thread status, interrupts stale in-progress turns when the resolved status is not active, and replaces/appends the active snapshot.
- `ThreadReadActiveTurnMergeOutcome` and `ThreadReadActiveTurnMergeReport` provide deterministic fixture summaries.

## Selected Behavior

- If a live in-progress turn exists while loaded status is `idle` or `notLoaded`, the resolved thread status becomes `active`.
- If the resolved thread status is not `active`, any reconstructed `inProgress` turns become `interrupted`.
- If an active turn snapshot is present, any existing history turn with the same ID is removed and the snapshot is appended.
- A missing active snapshot is valid; the reconstructed turns are normalized using the loaded/live-running facts only.
- Invalid loaded status values fail closed.

## Non-Goals

- Live `ThreadState` ownership or event listener integration.
- `ThreadWatchManager` runtime facts and active flags beyond the selected active/not-active decision.
- Full upstream `Turn`/`ThreadItem` reconstruction.
- Rollout file reads, SQLite/log DB ownership, or production state replacement.
- Cafex or Cafetera adapter behavior.

## haxe.rust Pressure

No new haxe.rust compiler/runtime limitation was exposed by this slice. The transform uses typed Haxe DTOs, enum abstracts, nullable active-turn input, array reconstruction, and no raw Rust escapes; the harness passes under the Haxe interpreter and portable haxe.rust-generated Rust.
