# Thread/Read Turns Page

**Bead:** `HXCX-4.18` / `codex-hxrust-blp`
**Fixture:** `fixtures/hxrust/thread-read-turns-page.v1.json`
**Gate:** `harness/check-thread-read-turns-page.sh`

## Purpose

This slice ports the selected raw upstream Codex `thread/turns/list` pagination behavior around reconstructed thread turns. It builds on HXCX-4.17 projected turn summaries and adds typed page requests, opaque cursors, item-view projection, and deterministic page reports.

It is still not live app-server storage ownership. The Haxe boundary consumes already projected turns; real rollout loading, active-turn merge, loaded-thread status normalization, and production DB effects remain later runtime/state slices.

## Upstream Anchors

- `../codex/codex-rs/app-server-protocol/src/protocol/v2/thread.rs:1191`
- `../codex/codex-rs/app-server-protocol/src/protocol/v2/thread.rs:1210`
- `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:2217`
- `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:3600`
- `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:3613`
- `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:3692`
- `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:3703`
- `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:3758`

## Boundary Shape

The Haxe facade lives in `codexhx.runtime.app.threadread`:

- `ThreadReadTurnsPageRequest` uses typed `ThreadId`, cursor text, limit, sort direction, and item view.
- `ThreadReadTurnsCursor` encodes and decodes upstream-shaped opaque cursor JSON with `turnId` and `includeAnchor`.
- `ThreadReadTurnSortDirection` models `asc` and `desc`.
- `ThreadReadTurnItemsView` models `notLoaded`, `summary`, and `full`.
- `ThreadReadTurnsPageOutcome` and `ThreadReadTurnsPageReport` provide deterministic fixture summaries.

Malformed cursor JSON, malformed cursor shape, missing cursor anchors, invalid thread IDs, invalid sort directions, and invalid item views fail closed with typed outcome codes.

## Selected Behavior

- Default/absent limit uses upstream default semantics; explicit limits are clamped to the selected upstream `1..100` range.
- Descending pages walk newest-to-oldest.
- Ascending pages walk oldest-to-newest.
- A cursor with `includeAnchor=false` resumes after the anchor in the selected direction.
- A backwards cursor always includes the first returned turn as an anchor for reverse paging.
- `notLoaded` clears turn items.
- `summary` keeps the first user message and final agent message when present.
- `full` preserves all selected projected items.
- Empty page results are successful and have no cursors.

## Non-Goals

- `thread/turns/items/list` app-server runtime behavior. Upstream protocol DTOs exist, but the current app-server processor returns unsupported for that method.
- Full upstream `Turn`/`ThreadItem` reconstruction.
- Live active-turn merge or status normalization.
- Rollout file reads, SQLite/log DB ownership, or production state replacement.
- Cafex or Cafetera adapter behavior.

## haxe.rust Pressure

No new haxe.rust compiler/runtime limitation was exposed by this slice. Malformed cursor parsing is handled at the Haxe boundary with typed failure outcomes, and the same harness passes under the Haxe interpreter and portable haxe.rust-generated Rust.
