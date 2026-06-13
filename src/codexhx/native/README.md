# Native Haxe Facades

This package is reserved for typed Haxe facades and externs that bind to owned Rust wrapper modules in `../../../native/src/`.

Rules:

1. Prefer pure Haxe outside this package.
2. Bind Rust modules with `extern` plus `@:native("crate::module")`.
3. Declare Rust crate dependencies with structured `@:rustCargo`.
4. Convert host errors into typed Haxe results before they reach app-level modules.
5. Keep raw Rust injection out of app code.

The full policy lives in `../../../docs/interop-boundary-policy.md`.

## State

`codexhx.native.state` owns the HXCX-4.14 native SQLite pressure facade. It uses metal haxe.rust and `sys.db.Sqlite` to prove a credential-free thread metadata upsert/readback boundary without opening upstream Codex state files or adding Codex-specific compiler behavior.

The fixture `fixtures/hxrust/native-sqlite-persistence.v1.json` and `harness/check-native-sqlite-persistence.sh` prove the slice through Haxe interpreter simulation and haxe.rust-generated Rust. The boundary decision is documented in `docs/native-sqlite-persistence-boundary.md`.
