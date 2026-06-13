# Native State Adapter

**Bead:** `HXCX-4.15` / `codex-hxrust-efo`
**Fixture:** `fixtures/hxrust/native-state-adapter.v1.json`
**Gate:** `harness/check-native-state-adapter.sh`

## Purpose

This slice extends the HXCX-4.14 native SQLite pressure proof from single reconcile/readback into a small typed state adapter: reconcile selected thread rollout metadata, query it back, update it, filter archived state, and fail closed for invalid IDs or disabled mutation intent.

It is still a raw upstream Codex slice. Cafex/Cafetera behavior is out of scope.

## Upstream Anchors

Read-only reference checkout: `../codex`.

- `../codex/codex-rs/rollout/src/state_db.rs:350`
- `../codex/codex-rs/rollout/src/state_db.rs:441`
- `../codex/codex-rs/rollout/src/state_db.rs:474`
- `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:2052`

These anchors cover rollout state DB operations and thread-processing surfaces that need persistent thread/session metadata.

## Boundary Shape

`codexhx.native.state.StateSqliteBridge.runInMemory` accepts typed `StateSqliteCommand` values:

- `Reconcile(StateSqliteReconcileRequest)` validates thread/session/rollout metadata, requires explicit mutation intent, and upserts one metadata row.
- `Query(StateSqliteQueryRequest)` validates the thread id, queries the row, and optionally filters by archived status.

Interpreter mode uses an in-memory Haxe simulation because local Haxe SQLite is not available. haxe.rust metal mode uses `sys.db.Sqlite` against an in-memory SQLite database, then runs generated Cargo `check`, `test`, and `run` gates.

## Non-Goals

This does not open upstream Codex state files, run migrations, own `StateDbHandle`, own `LogDbLayer`, coordinate cross-process locks, or claim full production persistence parity.

Portable DTO/state code remains preferred for pure validation and codecs. Metal is used here because the slice intentionally pressures Rust-native SQLite behavior.

## haxe.rust Pressure

The typed command enum carries class request payloads. This exposed generic haxe.rust issue `haxe.rust-x89k`: generated Rust derived enum equality while `HxRef<T>` class handles lacked `PartialEq`.

The fix landed upstream in haxe.rust `4772d6eaee19a556fc58d5bc9855e00321515b5a`: `HxRef<T>` now implements reference-identity `PartialEq`/`Eq`, covered by the product-neutral `enum_ref_payload` snapshot.
