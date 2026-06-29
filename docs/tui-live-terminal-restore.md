# TUI Live Terminal Restore Gate

**Bead:** `TUI-LIVE-1` / `codex-hxrust-3ddw`

## Purpose

This slice is the first generated Rust gate that crosses from typed Haxe TUI code into real terminal ownership machinery. It adds a `LiveTerminalBackend` implementation of the production `TerminalBackend` contract and a narrow native Rust probe for crossterm raw mode, alternate screen, ratatui frame drawing, nonblocking typed-key polling, and terminal restoration.

## Shape

- `codexhx.runtime.tui.terminal.LiveTerminalBackend` implements setup, draw, poll, exit, and restore through the production terminal contract.
- `codexhx.native.terminal.NativeLiveTerminalProbe` is the only Haxe extern for the native boundary.
- `native/src/live_terminal_probe.rs` owns crossterm/ratatui effects and reports scalar facts back to Haxe.
- `LiveTerminalProbeReport` turns those scalar facts into typed Haxe evidence: status, TTY availability, operation attempts, restore result, counts, and message.

## Gate

Run:

```bash
bash harness/check-tui-live-terminal-restore.sh
```

The gate runs the interpreter harness, compiles through metal haxe.rust, checks/tests the generated Cargo crate, and runs the generated binary. In CI or other non-TTY environments, the native probe returns `SkippedNoTty`; this is an accepted credential-free fallback because no terminal was taken and restoration is therefore vacuously safe. When the generated binary is run from a real TTY, the same backend attempts raw mode plus alternate screen, draws one ratatui frame, polls typed keys without blocking, and restores terminal state on normal and forced-error paths.

## Still Not Proven

This does not attach to the app server, call a model, use SQLite, render upstream widgets, own async streams, or run a full input loop. Panic/abort restoration is still a later hardening target; this slice proves ordinary exit and caught-error restoration.
