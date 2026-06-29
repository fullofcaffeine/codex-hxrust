# TUI App-Server Event Pump

**Bead:** `TUI-LIVE-6` / `codex-hxrust-6pzd`

## Purpose

This slice connects typed fake app-server events to the minimal live shell redraw path. App-server notifications now update `ChatWidgetShellState`, request redraws through `TerminalRedrawScheduler`, render the updated shell, and apply backend operations through `TerminalSchedulerRunner`.

## Shape

- `TuiAppServerEventPump` drains queued `TuiAppServerEvent` values from `FakeTuiAppServerFacade`, routes shell effects into scheduler draw requests, renders `ChatWidgetShellRenderer`, and applies terminal operations.
- `TuiAppServerPumpPolicy` exposes the current synchronous drain contract plus future async hooks: lossless drain, bounded drain, and cancellation.
- `TuiAppServerPumpOutcome` records structured state/effect evidence: drained events, draw requests, scheduler effects, terminal operations, backpressure, and cancellation.
- `FakeTuiAppServerFacade.shiftQueued()` keeps queue ownership typed while allowing the pump to stop on policy boundaries.

The current pump is synchronous and credential-free. Bounded drains preserve remaining queued events and report backpressure; they do not drop events. Cancellation preserves queued events and skips redraw.

## Gate

Run:

```bash
bash harness/check-tui-app-server-event-pump.sh
```

The gate asserts assistant delta, status update, disconnect handling, queued redraw coalescing, bounded backpressure, cancellation preservation, headless backend draw state, live backend draw/restore behavior, metal haxe.rust generation, and generated Cargo check/test/run.

## Still Not Proven

This is not an async app-server stream, socket transport, prompt submission, model traffic, persistent state, tool execution, or full upstream event loop. `TUI-LIVE-7` should turn composer submit effects into typed app-server request envelopes so the shell can send work into the fake app-server facade.
