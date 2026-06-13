# Native SQLite Persistence Boundary

**Bead:** `HXCX-4.14` / `codex-hxrust-bsy`
**Date:** 2026-06-13
**Scope:** first generic native SQLite pressure slice for raw upstream Codex persistence.

## Purpose

HXCX-4.13 defined that portable Haxe may validate rollout metadata, while production state effects belong behind a generic native Rust boundary. This slice exercises that boundary with one credential-free operation: reconcile selected thread/rollout metadata into a SQLite row.

This is not a Codex-specific database implementation and not a migration of upstream state. It is a small native persistence proof that uses haxe.rust's `sys.db.Sqlite` support, which is backed by `rusqlite` on the Rust target.

## Upstream Anchors

Read-only reference checkout: `../codex`.

Selected anchors:

- `../codex/codex-rs/rollout/src/state_db.rs:474` exposes `reconcile_rollout`.
- `../codex/codex-rs/thread-store/src/local/mod.rs:92` wires local thread stores to an optional state DB handle.
- `../codex/codex-rs/app-server-client/src/lib.rs:326` passes `LogDbLayer` and `StateDbHandle` into in-process startup.
- `../codex/codex-rs/app-server/src/in_process.rs:132` carries the same handles into embedded app-server runtime.

## Boundary Shape

Haxe facade:

- `codexhx.native.state.StateSqliteBridge`
- `StateSqliteReconcileRequest`
- `StateSqliteReconcileOutcome`
- `NativeStateRow`

The facade accepts already-validated `ThreadPersistenceMetadata` and explicit `mutationEnabled` intent. It fails closed when mutation is disabled or metadata is invalid.

Generated Rust path:

- Compiled through `hxml/native-sqlite-persistence.hxml` with `reflaxe_rust_profile=metal`.
- Uses `sys.db.Sqlite.open(":memory:")`.
- Creates a narrow `codex_threads` table.
- Inserts or updates one row by `thread_id`.
- Reads the row back into typed Haxe outcome fields.

Interpreter path:

- Uses a deterministic in-memory simulation because this local Haxe interpreter reports `sys.db.Sqlite` as unsupported.
- Preserves the same request/outcome contract so fixture expectations are shared.

## Harness

Fixture: `../fixtures/hxrust/native-sqlite-persistence.v1.json`

Gate:

```bash
harness/check-native-sqlite-persistence.sh
```

The gate runs:

- Haxe interpreter contract check;
- haxe.rust metal code generation;
- generated Cargo check/test/run.

## Non-Goals

- No upstream Codex SQLite file is opened, migrated, imported, or modified.
- No credentials, network, app-server daemon, or Cafex/Cafetera behavior is involved.
- No broad replacement claim is made for `StateDbHandle`, `LogDbLayer`, `reconcile_rollout`, migrations, locking, repair, backup, or cross-process coordination.

## Next Work

The next state slice should decide whether to build a codexhx-owned native state adapter around this generic SQLite pressure proof or to continue with another upstream operation, such as thread-goal persistence or rollout metadata repair. Any bad generated Rust shape or compiler gap found there belongs in `../haxe.rust` with product-neutral fixtures.
