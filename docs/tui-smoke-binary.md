# TUI Smoke Binary

**Bead:** HXCX-TUI-0 / `codex-hxrust-llji`
**Scope:** raw upstream Codex first; no Cafex behavior, no live model calls, no terminal takeover.

## Purpose

`TuiSmokeMain` is the first haxe.rust-compiled executable shaped like a Codex TUI binary. It is intentionally tiny: it proves that typed Haxe TUI code can generate a Cargo binary, set up a terminal-facing facade, render a deterministic transcript/status/input frame, consume a quit/cancel key, and restore the facade in CI.

This does not claim full upstream TUI parity. Upstream Codex still owns the real interactive surface in `../codex/codex-rs/tui/src/main.rs`, `../codex/codex-rs/tui/src/app.rs`, `../codex/codex-rs/tui/src/app/input.rs`, and the ratatui/crossterm-backed test surfaces under `../codex/codex-rs/tui/tests/`.

## Shape

- `src/codexhx/runtime/tui/smoke/TuiSmokeMain.hx` is the generated binary entrypoint.
- `TuiSmokeTerminalFacade` is a neutral facade. Today it only allows `headless`; a future metal backend can map the same setup/render/poll/restore contract to Rust-native terminal ownership.
- `TuiSmokeRunner` handles `ctrl-c` as cancel and `q`/Esc as quit.
- `fixtures/hxrust/tui-smoke.v1.json` provides credential-free frame/key cases.
- `fixtures/hxrust/tui-smoke.snapshot.txt` is the CI-safe generated-binary stdout snapshot.

## Gate

Run:

```bash
bash harness/check-tui-smoke.sh
```

The gate runs the Haxe interpreter harness, compiles `hxml/tui-smoke.hxml` through haxe.rust metal, checks/tests the generated Cargo crate, runs the generated binary, and diffs stdout against the snapshot.

## Why This Advances TUI Parity

Earlier TUI slices proved story parsing, VT100 row rendering, turn reducers, and many keymap policies as pure Haxe behavior. This slice adds the missing executable boundary: a generated Rust binary can now own a TUI-shaped entrypoint and deterministic terminal facade. The next slices can replace the headless facade piece by piece with Rust-native terminal, event-loop, app-server, and input backends without coupling haxe.rust to Codex-specific code.
