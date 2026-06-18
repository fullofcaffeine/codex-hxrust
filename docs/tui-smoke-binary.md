# TUI Smoke Binary

**Bead:** HXCX-TUI-0 / `codex-hxrust-llji`; HXCX-TUI-1 / `codex-hxrust-x2m1`; HXCX-TUI-2 / `codex-hxrust-aw7s`; HXCX-TUI-3 / `codex-hxrust-izhl`; HXCX-TUI-4 / `codex-hxrust-2j6f`; HXCX-TUI-5 / `codex-hxrust-7gal`; HXCX-TUI-6 / `codex-hxrust-jsaw`; HXCX-TUI-7 / `codex-hxrust-twtz`; HXCX-TUI-8 / `codex-hxrust-62hi`; HXCX-TUI-9 / `codex-hxrust-zkqf`; HXCX-TUI-10 / `codex-hxrust-92jl`; HXCX-TUI-11 / `codex-hxrust-jj32`; HXCX-TUI-12 / `codex-hxrust-qrve`; HXCX-TUI-13 / `codex-hxrust-5uvm`; HXCX-TUI-14 / `codex-hxrust-qq9s`; HXCX-TUI-15 / `codex-hxrust-thv4`; HXCX-TUI-16 / `codex-hxrust-33vy`; HXCX-TUI-17 / `codex-hxrust-n1d3`; HXCX-TUI-18 / `codex-hxrust-jtp8`; HXCX-TUI-19 / `codex-hxrust-vhts`; HXCX-TUI-20 / `codex-hxrust-pte1`; HXCX-TUI-21 / `codex-hxrust-7tv4`; HXCX-TUI-22 / `codex-hxrust-n3mn`; HXCX-TUI-23 / `codex-hxrust-17xr`; HXCX-TUI-24 / `codex-hxrust-6ht6`
**Scope:** raw upstream Codex first; no Cafex behavior, no live model calls, no terminal takeover.

## Purpose

`TuiSmokeMain` is the first haxe.rust-compiled executable shaped like a Codex TUI binary. It is intentionally tiny: it proves that typed Haxe TUI code can generate a Cargo binary, set up a terminal-facing facade, render deterministic transcript/status/input frames, process a small headless event loop, preserve queued app-event, app-server notification, app-server request, request-resolution, active-thread request delivery, active-thread notification delivery, pending interactive replay-filter ordering, thread snapshot turn-history replay ordering, thread snapshot session/input replay ordering, replayed server-request surface ordering, replayed notification/history/feedback event ordering, replay-buffer flush/reflow ordering, resize draw scheduling ordering, resize repaint/scrollback intent ordering, inline viewport resize sync ordering, suspend/resume viewport restoration ordering, event-stream pause/resume ordering, terminal mode/keyboard enhancement ordering, alternate-screen lifecycle ordering, draw/update composition ordering, frame scheduler coalescing ordering, draw-event dispatch ordering, and overlay routing ownership, consume quit/cancel paths, and restore the facade in CI.

This does not claim full upstream TUI parity. Upstream Codex still owns the real interactive surface in `../codex/codex-rs/tui/src/main.rs`, `../codex/codex-rs/tui/src/app.rs`, `../codex/codex-rs/tui/src/app/input.rs`, and the ratatui/crossterm-backed test surfaces under `../codex/codex-rs/tui/tests/`.

## Shape

- `src/codexhx/runtime/tui/smoke/TuiSmokeMain.hx` is the generated binary entrypoint.
- `TuiSmokeTerminalFacade` is a neutral facade. Today it only allows `headless`; a future metal backend can map the same setup/render/poll/restore contract to Rust-native terminal ownership.
- `TuiSmokeRunner` handles `ctrl-c` as cancel and `q`/Esc as quit.
- `TuiSmokeEventLoop` models a minimal raw Codex app-loop subset: draw, resize, resize draw scheduling, resize repaint/scrollback intent, inline viewport resize sync, suspend/resume viewport restoration, event-stream pause/resume intent, terminal mode/keyboard enhancement intent, alternate-screen enable/enter/leave/clear intent, legacy and resize-reflow draw/update composition intent, frame scheduler request/coalesce/rate-limit intent, draw-event dispatch/pre-render intent, overlay activation/live-tail/draw/key/cleanup routing intent, status update, input update, key dispatch, and explicit app exit.
- `TuiSmokeAppEventQueue` models the first `AppEventSender`-style queue facade for startup status, commit ticks, and queued app exit.
- `TuiSmokeAppServerFacade` models a narrow app-server event stream subset: thread status, assistant delta, stream close, disconnect, supported request targeting, threadless request ignores, unsupported request rejection, pending request resolution, stale resolution refusal, server-request-resolved dismissal, primary active-thread draining, side-thread buffering, active-thread switch delivery, queued request eviction, active-thread notification delivery, side-thread notification buffering, queued notification eviction, pending interactive replay filtering, replay-kind request delivery, replay notice suppression, typed thread snapshot turn-history replay, typed thread snapshot session/input replay, typed replayed server-request surfaces, typed replayed notification/history/feedback event surfaces, and typed replay-buffer flush/reflow intent.
- `fixtures/hxrust/tui-smoke.v1.json` provides credential-free frame/key cases plus headless app-loop event cases.
- `fixtures/hxrust/tui-smoke.snapshot.txt` is the CI-safe generated-binary stdout snapshot.

`TuiSmokeLoopRequest.frame` is intentionally nullable in Haxe source. This follows the existing local workaround for generic haxe.rust class-field default-constructor lowering pressure: request DTOs with class-typed fields use nullable slots until the compiler can initialize non-null class fields without synthesizing invalid default constructor calls.

## Gate

Run:

```bash
bash harness/check-tui-smoke.sh
```

The gate runs the Haxe interpreter harness, compiles `hxml/tui-smoke.hxml` through haxe.rust metal, checks/tests the generated Cargo crate, runs the generated binary, and diffs stdout against the snapshot.

## Why This Advances TUI Parity

Earlier TUI slices proved story parsing, VT100 row rendering, turn reducers, and many keymap policies as pure Haxe behavior. These smoke slices add the missing executable boundary: a generated Rust binary can now own a TUI-shaped entrypoint, deterministic terminal facade, small raw Codex-shaped event loop, typed app-event queue, typed app-server notification facade, typed app-server request facade, typed request-resolution facade, typed active-thread request-delivery facade, typed active-thread notification-delivery facade, typed pending interactive replay-filter facade, typed thread snapshot turn-history replay facade, typed thread snapshot session/input replay facade, typed replayed server-request surface facade, typed replayed notification/history/feedback event facade, typed replay-buffer flush/reflow facade, typed resize draw scheduling facade, typed resize repaint/scrollback facade, typed inline viewport resize sync facade, typed suspend/resume viewport facade, typed event-stream pause/resume facade, typed terminal mode/keyboard enhancement facade, typed alternate-screen lifecycle facade, typed draw/update composition facade, typed frame scheduler facade, typed draw-event dispatch facade, and typed overlay routing facade. The next slices can replace the headless facade piece by piece with Rust-native terminal, app-server, approval UI, and input backends without coupling haxe.rust to Codex-specific code.
