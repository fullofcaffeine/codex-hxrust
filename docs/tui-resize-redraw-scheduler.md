# TUI Resize Redraw Scheduler

**Bead:** `TUI-LIVE-2` / `codex-hxrust-8072`

## Purpose

This slice adds the first production-shaped frame scheduler for the minimal live TUI shell. It sits above `TerminalBackend` and coalesces resize/redraw inputs into typed backend effects shared by headless and live terminal implementations.

## Shape

- `TerminalSchedulerEvent` models scheduler inputs: `Resize`, `DrawRequested`, `Tick`, and `AppExit`.
- `TerminalRedrawScheduler` owns only resize/draw timing state and counters. Rendering remains caller-owned, so this stays reusable for the later ChatWidget shell.
- `TerminalSchedulerEffect` is a typed effect enum: resize the backend, draw a frame, or request app exit.
- `TerminalSchedulerRunner` applies those effects to any `TerminalBackend`.

The scheduler deliberately does not depend on smoke fixtures, golden trace strings, app-server transport, model credentials, or persistent state.

## Gate

Run:

```bash
bash harness/check-tui-resize-redraw-scheduler.sh
```

The gate runs direct state/effect assertions in the Haxe interpreter, compiles the same harness through metal haxe.rust, checks/tests the generated Cargo crate, and runs the generated binary. It proves that repeated resize inputs coalesce into one backend resize plus one draw at flush time, `Tick` and `DrawRequested` mark typed redraw state, `AppExit` emits a typed exit request, and one resized frame path works through both headless and live backends.

## Still Not Proven

This is not yet a full input loop. It does not map crossterm key events into typed input, attach app-server transport, render upstream widgets, call models, or persist SQLite/log state. `TUI-LIVE-3` should add typed live input on top of this scheduler/backend shape.
