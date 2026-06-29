# Native Haxe Facades

This package is reserved for typed Haxe facades and externs that bind to owned Rust wrapper modules in `../../../native/src/`.

Rules:

1. Prefer pure Haxe outside this package.
2. Bind Rust modules with `extern` plus `@:native("crate::module")`.
3. Declare Rust crate dependencies with structured `@:rustCargo`.
4. Convert host errors into typed Haxe results before they reach app-level modules.
5. Keep raw Rust injection out of app code.

The full policy lives in `../../../docs/interop-boundary-policy.md`.

## Terminal

`codexhx.native.terminal` owns the TUI-LIVE-1 native crossterm/ratatui pressure facade. It binds `native/src/live_terminal_probe.rs` through a tiny extern surface and reports typed setup/draw/poll/restore facts back to `codexhx.runtime.tui.terminal.LiveTerminalBackend`. The generated gate is `harness/check-tui-live-terminal-restore.sh`, and the slice is documented in `docs/tui-live-terminal-restore.md`.

## State

`codexhx.native.state` owns the HXCX-4.14 and HXCX-4.15 native SQLite pressure facades. It uses metal haxe.rust and `sys.db.Sqlite` to prove credential-free thread metadata upsert/readback plus a typed reconcile/query adapter boundary without opening upstream Codex state files or adding Codex-specific compiler behavior.

The fixture `fixtures/hxrust/native-sqlite-persistence.v1.json` and `harness/check-native-sqlite-persistence.sh` prove the slice through Haxe interpreter simulation and haxe.rust-generated Rust. The boundary decision is documented in `docs/native-sqlite-persistence-boundary.md`.

The fixture `fixtures/hxrust/native-state-adapter.v1.json` and `harness/check-native-state-adapter.sh` extend that pressure into typed command/report behavior: reconcile, query, archived filtering, mutation-denied failures, and invalid query failures. The adapter slice is documented in `docs/native-state-adapter.md`.

HXCX-4.16 consumes the adapter report from `codexhx.runtime.app.persistence.PersistedThreadReadViewBuilder` to build a typed persisted thread read view. That higher-level facade is documented in `docs/persisted-thread-read-view.md` and validated by `harness/check-persisted-thread-read-view.sh`.
