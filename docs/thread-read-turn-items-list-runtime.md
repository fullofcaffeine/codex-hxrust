# Thread/Turns Items List Runtime Boundary

**Bead:** `HXCX-4.20` / `codex-hxrust-inh`
**Fixture:** `fixtures/hxrust/thread-read-turn-items-list-runtime.v1.json`
**Gate:** `harness/check-thread-read-turn-items-list.sh`

## Purpose

This slice records the current raw upstream Codex runtime contract for `thread/turns/items/list`: the protocol DTOs exist, but the app-server processor returns an unsupported method error. Codexhx validates selected params first, then returns the same fail-closed unsupported outcome for valid requests.

This intentionally avoids implementing item pagination before upstream has runtime behavior to mirror.

## Upstream Anchors

- `../codex/codex-rs/app-server-protocol/src/protocol/v2/thread.rs:1225`
- `../codex/codex-rs/app-server-protocol/src/protocol/v2/thread.rs:1242`
- `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:627`
- `../codex/codex-rs/app-server-protocol/src/protocol/v2/tests.rs:220`

## Boundary Shape

The Haxe facade lives in `codexhx.runtime.app.threadread`:

- `ThreadReadTurnItemsListRequest` uses typed `ThreadId`, `TurnId`, cursor text, limit, and sort direction.
- `ThreadReadTurnItemsListRuntime` validates the selected request shape.
- `ThreadReadTurnItemsListOutcome` returns typed failures, including upstream-shaped `method_not_found`.
- `ThreadReadTurnItemsListReport` provides deterministic fixture summaries.

## Selected Behavior

- Valid params fail closed with `method_not_found` and message `thread/turns/items/list is not supported yet`.
- Invalid thread IDs fail before the unsupported runtime boundary.
- Empty turn IDs fail before the unsupported runtime boundary.
- Malformed cursor, malformed limit, and invalid sort direction fail before the unsupported runtime boundary.

## Non-Goals

- Implementing item pagination.
- Reconstructing full upstream `ThreadItem` pages.
- Reading rollout files, merging live `ThreadState`, or owning production storage.
- Cafex or Cafetera adapter behavior.

## haxe.rust Pressure

No new haxe.rust compiler/runtime limitation was exposed by this slice. The boundary uses typed DTOs, enum abstracts, nullable ID construction, JSON cursor shape checks, deterministic reports, and no raw Rust escapes; the harness passes under the Haxe interpreter and portable haxe.rust-generated Rust.
