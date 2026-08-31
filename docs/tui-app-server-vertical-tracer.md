# TUI App-Server Vertical Tracer

The first vertical tracer runs one credential-free Codex-shaped TUI lifecycle through production ownership boundaries.

It proves this sequence:

1. The TUI runner asks `TuiAppServerSession` to open.
2. A replaceable startup transport emits ordered `initialize`, `initialized`, and `thread/start` or `thread/resume` JSON-RPC lines.
3. The session adopts only the identities returned by that transport.
4. The normal composer submits `turn/start` through the prompt transport.
5. App-server events update thread and ChatWidget state.
6. The terminal renderer observes the completed assistant response.
7. The runner shuts down the session and restores the terminal.

The runner and session do not know whether startup is deterministic or process-backed. The current gate uses `DeterministicTuiAppServerStartupTransport` so CI needs no credentials or live service. A later native transport can implement the same `TuiAppServerStartupTransport` contract without changing the runner.

## Upstream anchors

The reviewed upstream Codex checkout is pinned at `b8c86376a258e55efc8e5ecfbabc21c16c07d814`.

- `codex-rs/tui/src/app_server_session.rs`: session-owned startup, `next_event`, turn calls, response routing, and shutdown.
- `codex-rs/app-server/src/request_processors/initialize_processor.rs`: initialize-before-use lifecycle.
- `codex-rs/app-server/src/request_processors/thread_lifecycle.rs`: thread lifecycle and bounded shutdown behavior.
- `codex-rs/tui/src/chatwidget/session_flow.rs`: session-to-ChatWidget handoff.

## Gate

```sh
bash harness/check-tui-app-server-vertical-tracer.sh
```

The gate runs the authored Haxe expectation, generates metal Rust through the exact compiler pin, and runs locked Cargo check/test, rustfmt, warning-denied Clippy, and the generated binary.

## Compiler pressure and admission

The tracer exposed two framework-neutral haxe.rust defects. Both fixes landed through isolated compiler worktrees and reviewed pull requests:

- [reflaxe.rust PR #16](https://github.com/fullofcaffeine/reflaxe.rust/pull/16) wraps a required interface handle when the same optional interface type expects `HxDynRef`. It landed as `6dbb6c32365cc41ac6c529d449ee1f166d5bd4ff`.
- [reflaxe.rust PR #15](https://github.com/fullofcaffeine/reflaxe.rust/pull/15) keeps temporary anonymous-record receivers alive through optional and function-valued field reads. It landed after PR #16 as `02b21f90c0ae8e31ecc07c31887e48c74852256e`.

The known-good compiler pin is the second merge commit. A clean detached checkout of that exact commit passed the tracer with upstream reachability enforced. The broader portable and metal generated Cargo gates also passed before the pin changed.

Generated Rust review confirmed both original failure sites. The startup transport forwarding call now creates `HxDynRef::new(transport.clone())`. The optional startup-request field binds a stable `__hx_recv` before it borrows the anonymous record.

## Limits

The deterministic startup transport emits and records the protocol requests but does not launch a real Codex app-server process. Live process/socket ownership, asynchronous event reading, server-request reply transport, provider/model execution, and production persistence remain separate tasks. The tracer proves the replaceable ownership path; it does not claim complete TUI or app-server parity.
