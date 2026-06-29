# TUI Live Terminal Contract

**Bead:** `TUI-LIVE-0` / `codex-hxrust-nvs9`

## Purpose

`codexhx.runtime.tui.terminal` is the production terminal boundary for the minimal live TUI shell. It is intentionally smaller than upstream Codex's full ratatui/crossterm app loop: this slice defines the typed seam for setup, draw, event polling, resize, exit, and restore semantics before any live terminal takeover is attempted.

The contract is not part of `codexhx.runtime.tui.smoke`. Smoke fixtures may later wrap it, but production terminal/input/render code should depend on this package rather than the smoke facade.

## Shape

- `TerminalBackend` is the backend interface.
- `TerminalMode`, `TerminalSetup`, `TerminalSize`, `TerminalFrame`, `TerminalOperation`, and `TerminalRestoreReport` model setup, drawing, resize, exit, and restore outcomes.
- `TerminalEvent` and `TerminalKey` are typed Haxe enum variants. They avoid the nullable mega-record event shape that exists in the old smoke loop.
- `HeadlessTerminalBackend` is the CI-safe implementation. It records setup/draw/resize/exit/restore state and replays typed queued events without taking over a terminal.

## Gate

Run:

```bash
bash harness/check-tui-terminal-contract.sh
```

The gate runs the Haxe interpreter harness, compiles the harness through portable haxe.rust, checks/tests the generated Cargo crate, and runs the generated binary.

## Next Hook

`TUI-LIVE-1` should add a live backend beside `HeadlessTerminalBackend`. That backend should map the same `TerminalBackend` contract onto Rust-native crossterm/ratatui terminal ownership, prove raw/alternate-screen setup, draw one frame, exit on q/Esc/Ctrl-C, and restore terminal state. It should not add model traffic, production SQLite, or full app-server transport.
