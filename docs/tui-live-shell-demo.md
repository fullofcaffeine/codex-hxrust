# TUI Live Shell Demo

**Bead:** `TUI-LIVE-12` / `codex-hxrust-o797`

This slice adds a user-runnable generated Rust demo for the minimal live TUI
shell. The demo uses `LiveTerminalBackend` with a 50ms native poll timeout and
the `TuiLiveShellRunner` from TUI-LIVE-11, so it owns the same setup, draw,
typed input, fake app-server dispatch, redraw, exit, and restore path as the
validated runner.

Build and run:

```bash
haxe hxml/tui-live-shell-demo.hxml
cargo run --manifest-path generated/tui-live-shell-demo/Cargo.toml --locked
```

In a real terminal, the generated binary attempts raw mode and alternate-screen
ownership. Type text and press Enter to send a fake prompt; press `q` on an
empty composer, Esc, or Ctrl-C to exit. Alt+Left/Alt+Right switch between the
primary thread and the fake demo agent when the terminal sends those modifiers.

In CI or other no-TTY contexts, the native backend reports a typed no-TTY skip,
draw/restore remain safe, and the demo exits after the bounded idle policy.
The demo still does not open real app-server JSON-RPC transport, call a model,
execute tools, or use SQLite/log persistence.
