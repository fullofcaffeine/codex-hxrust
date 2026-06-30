# TUI Live Shell Demo

**Beads:** `TUI-LIVE-12` / `codex-hxrust-o797`, `TUI-LIVE-49` / `codex-hxrust-vued`, `TUI-LIVE-50` / `codex-hxrust-62ls`

This slice adds a user-runnable generated Rust demo for the minimal live TUI
shell. The demo uses `LiveTerminalBackend` with a 50ms native poll timeout and
the `TuiLiveShellRunner` from TUI-LIVE-11, so it owns the same setup, draw,
typed input, fake app-server dispatch, redraw, exit, and restore path as the
validated runner. By default it still uses the credential-free fake transport.
`TUI-LIVE-49` adds a typed demo config path so the same generated binary can
opt into the dry-run connector-backed JSONL line transport without spawning a
process or opening a socket. `TUI-LIVE-50` adds a scripted prompt mode that
feeds typed headless key events into the same runner, letting CI and CLI users
prove an accepted prompt without interactive terminal input.

Build and run:

```bash
haxe hxml/tui-live-shell-demo.hxml
cargo run --manifest-path generated/tui-live-shell-demo/Cargo.toml --locked
```

Optional dry-run line transport mode:

```bash
cargo run --manifest-path generated/tui-live-shell-demo/Cargo.toml --locked -- \
  --transport=line-stdio \
  --line-command=codex \
  --line-arg=app-server \
  --line-arg=--json-rpc
```

Optional scripted prompt mode:

```bash
cargo run --manifest-path generated/tui-live-shell-demo/Cargo.toml --locked -- \
  --transport=line-stdio \
  --scripted-prompt=demo
```

The line-transport mode accepts repeated `--line-arg=...` values, repeated
`--line-env=NAME=value` values, `--line-cwd=...`, and
`--line-rejection-code=...` for exercising the deterministic rejection path. If
no line args are provided, the dry-run stdio plan defaults to `codex app-server
--json-rpc`.

In a real terminal, the generated binary attempts raw mode and alternate-screen
ownership. Type text and press Enter to send a fake prompt; press `q` on an
empty composer, Esc, or Ctrl-C to exit. Alt+Left/Alt+Right switch between the
primary thread and the fake demo agent when the terminal sends those modifiers.

In CI or other no-TTY contexts, the native backend reports a typed no-TTY skip,
draw/restore remain safe, and the demo exits after the bounded idle policy.
When `--scripted-prompt=...` is provided, the demo intentionally selects the
headless terminal backend, types the prompt, presses Enter, and exits after a
small bounded idle window.
The demo still does not open real app-server JSON-RPC transport, spawn the
app-server process, call a model, execute tools, or use SQLite/log persistence.
