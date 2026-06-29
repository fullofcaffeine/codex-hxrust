# TUI Live Prompt Transport

**Bead:** `TUI-LIVE-13` / `codex-hxrust-0gms`

This slice moves prompt-submission response events behind a typed transport
seam. `FakeTuiAppServerFacade` still owns credential-free session/thread
validation and still defaults to fake echo behavior, but it now asks a
`TuiPromptTransport` to turn a `TuiPromptSubmitEnvelope` into queued
`TuiAppServerEvent` values.

The default `EchoTuiPromptTransport` preserves the prior behavior:

- working status
- assistant echo delta
- ready status

Tests can inject another transport to prove refusal behavior. A rejected
transport preserves the prompt envelope and request-registration effects, but
does not enqueue fake assistant/status events.

Validation:

```bash
bash harness/check-tui-prompt-submit-envelope.sh
```

This is still not real app-server JSON-RPC, socket ownership, model traffic,
tool execution, or persistent state. It is the shell-facing seam those later
transports can implement without changing ChatWidget or terminal-loop code.
