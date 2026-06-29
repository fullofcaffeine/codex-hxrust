# TUI Fake App-Server Session

**Bead:** `TUI-LIVE-5` / `codex-hxrust-ppp3`

## Purpose

This slice attaches the minimal live ChatWidget shell to a deterministic, in-process app-server facade. It proves session lifecycle and active-thread notifications can mutate rendered TUI state without opening sockets, reading credentials, calling models, or touching SQLite/log state.

## Shape

- `codexhx.runtime.tui.appserver.FakeTuiAppServerFacade` owns typed pending attach requests, active session/thread IDs, and a deterministic event queue.
- `TuiAppServerEvent` models session started, thread status, assistant delta, and disconnect notifications as typed variants.
- `TuiAppServerShellEffect` reports request registration, stale response rejection, session attach, event application/ignore, disconnect, and redraw intent.
- Request correlation uses `codexhx.protocol.RequestId`; session/thread ownership uses `SessionId` and `ThreadId`.

No JSON decoding is introduced here. The slice models the JSON-RPC-shaped lifecycle through typed values so later transport work can add a strict decoder at the boundary without changing the shell-facing contract.

## Gate

Run:

```bash
bash harness/check-tui-fake-app-server-session.sh
```

The gate asserts stale attach response rejection, active attach acceptance, active-thread event filtering, status/assistant/disconnect mutation of `ChatWidgetShellState`, rendered frame facts, headless backend draw state, live backend draw/restore behavior, metal haxe.rust generation, and generated Cargo check/test/run.

## Still Not Proven

This is not a live socket transport, real app-server process, prompt submission envelope, model traffic, persistent state, tool execution, or full upstream ChatWidget parity. `TUI-LIVE-6` connects the typed event queue to the live shell scheduler so app-server events request frames through the same redraw path as terminal/input events.
