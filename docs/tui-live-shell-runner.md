# TUI Live Shell Runner

**Beads:** `TUI-LIVE-11` / `codex-hxrust-dww3`, `TUI-LIVE-48` / `codex-hxrust-5qfz`

This slice adds the first runnable minimal TUI shell loop. It composes the
production terminal backend, redraw scheduler, ChatWidget shell state, fake
app-server facade, app-server event pump, and typed terminal input mapper into
one bounded runner.

The runner is still credential-free. It does not open a JSON-RPC socket, call a
model, use SQLite/log state, or render the full upstream ratatui widget tree.
It proves the generated Haxe/Rust path can set up a terminal backend, attach a
fake session, draw the first frame, poll typed terminal events, submit prompt
text through the fake app-server path, route semantic agent previous/next input,
handle resize/draw/tick events, request exit for Esc/Ctrl-C/empty-composer `q`,
and restore the terminal.

Validation:

```bash
bash harness/check-tui-live-shell-runner.sh
```

The harness runs through the Haxe interpreter and haxe.rust-generated metal
Cargo check/test/run. Headless events provide deterministic CI coverage while
`LiveTerminalBackend` keeps the same no-TTY-safe generated Rust boundary used by
the earlier live-terminal restore gate.

`TUI-LIVE-48` lets `TuiLiveShellRunRequest` select a concrete JSON-RPC prompt
transport without manually constructing a facade. The default request still uses
the credential-free fake transport, while `withJsonRpcPromptTransport` and
`withLineConnectedPromptTransport` route live-shell prompt submission through
the connector-backed JSONL line pipeline. The runner harness proves both the
direct builder path and a diagnostic path that keeps the
`DryRunTuiAppServerJsonRpcLineConnectedTransport` handle available for typed
attempt/close reports.

For the user-runnable generated binary, see
[tui-live-shell-demo.md](tui-live-shell-demo.md).
