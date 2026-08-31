# TUI App-Server Session Contract

**Bead:** `codex-hxrust-mowj`

## Purpose

The live TUI now owns an app-server session contract. It does not own a fake.

The contract follows upstream `codex-rs/tui/src/app_server_session.rs`. The
review used upstream Codex commit `b8c86376a258e55efc8e5ecfbabc21c16c07d814`.

## Runtime Shape

`TuiAppServerSession` owns these operations:

- Bootstrap and primary-thread attachment.
- Turn start and interruption.
- Typed event enqueue, receive, and delivery.
- Typed server-request resolution and rejection.
- Session and transport shutdown.

The interface does not expose Tokio or Rust task handles. The current tracer is
synchronous. A later driver can schedule the same operations asynchronously.

`TransportTuiAppServerSession` is the runtime implementation. It can use
deterministic, line-connected, or process-backed prompt transports. Its default
transport remains deterministic and credential-free. A live app-server path
must inject the existing line-connected or process-backed transport.

The current bootstrap adopts session and thread identifiers supplied by the
caller. It does not send `initialize`, `thread/start`, or `thread/resume` yet.
The first vertical-tracer task owns that wire-level bootstrap path.

`FakeTuiAppServerFacade` is now a test fixture. It implements the same contract
through the transport-backed session. Production request, runner, pump, and
transport interfaces do not name the fake type.

JSON result and error values exist only at the server-request boundary. Runtime
logic receives a narrow response outcome and does not inspect those values.

## Validation

Run:

```bash
bash harness/check-tui-app-server-session-contract.sh
```

The gate checks the transport-backed session and the test-only compatibility
subclass. It checks bootstrap, thread ownership, turn start, event delivery,
server responses, and shutdown.

The gate checks, tests, formats, and runs the generated metal Rust crate. Rust
warnings fail the build. Clippy correctness and suspicious lints also fail the
build. The gate rejects the fake type anywhere in the production TUI runtime.

## Current Limit

The default constructor does not open a live app-server connection. It uses the
deterministic in-process JSON-RPC transport for the credential-free demo.

Bootstrap does not initialize an app server or start or resume a thread. It
only attaches the caller-supplied identifiers to local TUI state.

The persistent line transport does not send server-request responses yet. It
returns a typed unsupported outcome. These limits preserve the runtime boundary
without pretending that the wire path is complete.

The test-only compatibility subclass also expands inherited method shims in
generated Rust. haxe.rust Bead `haxe_rust-igkk` owns the generic output-size
improvement. The session behavior is correct, but this output is not the final
hand-written-quality target.
