# Persisted Thread Read View

**Bead:** `HXCX-4.16` / `codex-hxrust-cnn`
**Fixture:** `fixtures/hxrust/persisted-thread-read-view.v1.json`
**Gate:** `harness/check-persisted-thread-read-view.sh`

## Purpose

This slice builds the next raw upstream Codex state/runtime layer on top of the native SQLite adapter: a typed Haxe read-view facade for selected persisted thread metadata and history summary data.

The fixture first feeds reconcile/query commands through `StateSqliteBridge.runInMemory`, then projects read requests from the resulting `StateSqliteAdapterReport`. It does not open upstream state files and does not claim full `thread/read` parity.

## Upstream Anchors

Read-only reference checkout: `../codex`.

- `../codex/codex-rs/app-server-protocol/src/protocol/v2/thread.rs:1160`
- `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:2035`
- `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:2052`
- `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:2130`
- `../codex/codex-rs/thread-store/src/local/read_thread.rs:29`
- `../codex/codex-rs/thread-store/src/local/read_thread.rs:1186`

These anchors cover `ThreadReadParams`, `ThreadReadResponse`, the app-server `read_thread_view` builder, persisted-thread loading, and archived SQLite fallback behavior.

## Boundary Shape

`PersistedThreadReadViewBuilder.fromAdapterReport(report, requests)` returns a typed `PersistedThreadReadReport`.

- `PersistedThreadReadRequest` validates `ThreadId` and carries internal `includeTurns` and `includeArchived` read flags.
- `PersistedThreadReadView` keeps typed `ThreadId`, `SessionId`, `PathLikeId`, archived status, and upstream-like `notLoaded` status for persisted metadata-only views.
- `PersistedThreadHistorySummary` reports visible turn count, total history count, persisted count, pending persistence count, and whether the view is metadata-only or history-included.
- Missing threads, active-only archived reads, invalid IDs, and malformed persisted rows fail as typed outcomes.

## Non-Goals

This is not full app-server `thread/read` parity. It does not rebuild API turns from rollout items, merge live `ThreadState`, read real rollout files, run migrations, or own `StateDbHandle`/`LogDbLayer`.

The Haxe layer stays portable and typed. The harness uses metal haxe.rust only because its setup path intentionally exercises the native SQLite adapter before building the read view.

## haxe.rust Pressure

No new haxe.rust compiler/runtime limitation was exposed by this slice. The generated Rust gate passed with typed Haxe DTOs, class payloads, nullable outcomes, and adapter-report scanning without raw Rust escapes.
