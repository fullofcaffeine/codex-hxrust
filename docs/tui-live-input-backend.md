# TUI Live Input Backend

**Bead:** `TUI-LIVE-3` / `codex-hxrust-k92m`

## Purpose

This slice maps terminal key facts into Haxe-owned typed input events for the minimal live shell. It adds enough composer state to prove text editing, submit, cancellation, interrupt, backspace, and arrow behavior without pulling in ChatWidget or app-server complexity.

## Shape

- `TerminalInputEvent` is the semantic input enum consumed by the composer.
- `TerminalInputMapper` maps `TerminalKey` and native poll codes into typed Haxe events.
- `TerminalComposerState` owns a tiny input buffer, cursor, submitted text history, and exit intent.
- `TerminalComposerEffect` reports draw requests, submitted text, and exit requests as typed effects.
- `native/src/live_terminal_probe.rs` still owns crossterm polling, but exports scalar poll codes plus the latest character text. Haxe maps those facts into domain events.

## Gate

Run:

```bash
bash harness/check-tui-live-input-backend.sh
```

`TUI-LIVE-10` extends the typed input vocabulary with semantic
`AgentPrevious`/`AgentNext` events. Plain Left/Right remain composer cursor
movement; Alt+Left/Alt+Right from the native live probe map to agent navigation
so the app-server pump can switch active threads before composer editing sees
the event.

The gate runs typed native-code mapping assertions, headless queued-key composer mutations, live backend nonblocking polling, restoration, metal haxe.rust generation, and generated Cargo check/test/run. It remains credential-free and does not require a TTY; non-TTY runs use the existing typed skipped/no-TTY path.

## Still Not Proven

This is not a full TUI loop or ChatWidget. It does not render upstream widgets, attach app-server transport, submit prompts to a model, or persist state. `TUI-LIVE-4` builds the minimal ChatWidget shell state and render surface on top of this input/composer foundation.
