# TUI Live Shell Demo

**Beads:** `TUI-LIVE-12` / `codex-hxrust-o797`, `TUI-LIVE-49` / `codex-hxrust-vued`, `TUI-LIVE-50` / `codex-hxrust-62ls`, `TUI-LIVE-57` / `codex-hxrust-54gu`, `TUI-LIVE-60` / `codex-hxrust-riav`, `TUI-LIVE-61` / `codex-hxrust-9oi7`, `TUI-LIVE-62` / `codex-hxrust-dgl3`, `TUI-LIVE-63` / `codex-hxrust-s0fu`

This slice adds a user-runnable generated Rust demo for the minimal live TUI
shell. The demo uses `LiveTerminalBackend` with a 50ms native poll timeout and
the `TuiLiveShellRunner` from TUI-LIVE-11, so it owns the same setup, draw,
typed input, fake app-server dispatch, redraw, exit, and restore path as the
validated runner. By default it still uses the credential-free fake transport.
`TUI-LIVE-49` adds a typed demo config path so the same generated binary can
opt into the dry-run connector-backed JSONL line transport without spawning a
process or opening a socket. `TUI-LIVE-50` adds a scripted prompt mode that
feeds typed headless key events into the same runner, letting CI and CLI users
prove an accepted prompt without interactive terminal input. `TUI-LIVE-57` adds
an explicit `process_stdio` mode that injects the process-backed line attacher,
so the generated demo can run that same scripted prompt path through a real
one-shot child-process JSONL responder. `TUI-LIVE-60` adds `persistent_stdio`,
which uses the persistent connector-backed prompt transport and repeated
scripted prompts to prove two demo-level submissions through one long-lived
shell-backed stdio session. `TUI-LIVE-61` makes the demo print runner-owned
prompt-transport shutdown evidence, including persistent line-close state and
aggregate JSONL counts. `TUI-LIVE-62` adds last/active/completed turn evidence
to the same generated status line. `TUI-LIVE-63` adds interrupted-turn and
interrupt-code evidence to that line, while scripted prompt demos still report
zero interrupts unless a future scripted key path triggers Ctrl-C during an
active long-running turn.

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

Optional process-backed scripted prompt mode:

```bash
cargo run --manifest-path generated/tui-live-shell-demo/Cargo.toml --locked -- \
  --transport=process-stdio \
  --line-command=sh \
  --line-arg=-c \
  --line-arg='<JSONL responder script>' \
  --scripted-prompt=demo
```

Optional persistent scripted prompt mode:

```bash
cargo run --manifest-path generated/tui-live-shell-demo/Cargo.toml --locked -- \
  --transport=persistent-stdio \
  --line-command=sh \
  --line-arg=-c \
  --line-arg='<persistent JSONL responder script>' \
  --scripted-prompt=first \
  --scripted-prompt=second
```

The process-backed script must print a valid prompt response plus the modeled
`turn/started`, assistant delta, and `turn/completed` JSONL records for one
request. The persistent script must keep reading request lines and print that
same response/stream group for each request. The checked examples live in
`harness/check-tui-live-shell-demo.sh`.

The line-transport mode accepts repeated `--line-arg=...` values, repeated
`--line-env=NAME=value` values, `--line-cwd=...`, and
`--line-rejection-code=...` for exercising the deterministic rejection path. If
no line args are provided, the dry-run stdio plan defaults to `codex app-server
--json-rpc`. `process_stdio` uses the same typed launch plan but actually
spawns the configured command for a one-shot JSONL exchange, so current process
mode refuses cwd/env plans until the native process boundary owns those
attributes.

In a real terminal, the generated binary attempts raw mode and alternate-screen
ownership. Type text and press Enter to send a fake prompt; press `q` on an
empty composer, Esc, or Ctrl-C to exit. Alt+Left/Alt+Right switch between the
primary thread and the fake demo agent when the terminal sends those modifiers.

In CI or other no-TTY contexts, the native backend reports a typed no-TTY skip,
draw/restore remain safe, and the demo exits after the bounded idle policy.
When one or more `--scripted-prompt=...` values are provided, the demo
intentionally selects the headless terminal backend, types each prompt, presses
Enter after each one, and exits after a small bounded idle window.
The demo still does not open real app-server JSON-RPC transport, own async
reader/writer tasks, call a model, execute tools, or use SQLite/log persistence.
