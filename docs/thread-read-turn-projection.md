# Thread/Read Turn Projection

**Bead:** `HXCX-4.17` / `codex-hxrust-w4d`
**Fixture:** `fixtures/hxrust/thread-read-turn-projection.v1.json`
**Gate:** `harness/check-thread-read-turn-projection.sh`

## Purpose

This slice ports a selected raw upstream Codex `thread/read` behavior into typed Haxe: projecting rollout/history item summaries into deterministic turn summaries. It is a step toward app-server `ThreadReadResponse` parity, not a full clone of upstream rollout parsing or live app-server state.

The implementation lives in `codexhx.runtime.app.threadread` and stays Cafex-free.

## Upstream Anchors

- `../codex/codex-rs/app-server-protocol/src/protocol/thread_history.rs:74`
- `../codex/codex-rs/app-server-protocol/src/protocol/thread_history.rs:78`
- `../codex/codex-rs/app-server-protocol/src/protocol/thread_history.rs:229`
- `../codex/codex-rs/app-server-protocol/src/protocol/thread_history.rs:942`
- `../codex/codex-rs/app-server/src/request_processors/thread_lifecycle.rs:741`
- `../codex/codex-rs/app-server/tests/suite/v2/thread_read.rs:138`

## Boundary Shape

The Haxe facade uses typed DTOs and enum abstracts instead of raw strings flowing through the runtime:

- `RolloutSummaryItemKind` accepts only the selected upstream-shaped rollout item kinds.
- `ThreadReadTurnStatus` records in-progress, completed, interrupted, and failed terminal states.
- `ThreadReadTurnItemKind` records user, agent, command execution, and compaction summaries.
- `ThreadReadTurnProjectionOutcome` and `ThreadReadTurnProjectionReport` provide deterministic success/failure summaries for fixture gates.

Malformed item kinds, missing boundary IDs, and missing renderable text fail closed with typed outcome codes.

## Selected Behavior

- Explicit `turn_started` and `turn_complete` items create and complete a named turn.
- Legacy histories without explicit turn-start boundaries group each user message plus following items into an implicit `rollout-N` turn.
- Agent messages and command executions are summarized as turn items.
- Compaction entries create a compacted item and use `compacted` as a fallback text when the selected fixture omits text.
- Errors that affect turn status mark the active turn as failed.
- Empty history returns a successful zero-turn projection.

## Non-Goals

- Full upstream `RolloutItem` parsing.
- Full `ThreadItem` or `ResponseItem` reconstruction.
- Pagination, live merge with `ThreadState`, or filesystem rollout reads.
- Production SQLite/log database ownership.
- Cafex or Cafetera adapter behavior.

## haxe.rust Pressure

No new haxe.rust compiler/runtime limitation was exposed by this slice. The code uses typed Haxe classes, enum abstracts, arrays, nullable-free outcomes, and no raw Rust escapes; the harness passes under the Haxe interpreter and portable haxe.rust-generated Rust.
