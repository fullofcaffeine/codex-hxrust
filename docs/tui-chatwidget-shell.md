# TUI ChatWidget Shell

**Bead:** `TUI-LIVE-4` / `codex-hxrust-59op`

## Purpose

This slice adds the first production-shaped ChatWidget shell for the live TUI path. It owns minimal transcript rows, model/status labels, and the typed composer state from `TUI-LIVE-3`, then renders those facts into a `TerminalFrame` that both headless and live backends can draw.

## Shape

- `codexhx.runtime.tui.chatwidget.ChatWidgetShellState` owns transcript rows, status/model labels, revision, and composer state.
- `ChatWidgetShellEffect` reports draw requests, prompt submission, and exit requests as typed effects.
- `ChatWidgetTranscriptRole` and `ChatWidgetTranscriptRow` model visible transcript rows without smoke DTOs.
- `ChatWidgetShellRenderer` produces a header/body/footer/composer frame for `TerminalBackend`.

The shell follows upstream ChatWidget ownership at a very small scale: ChatWidget owns transcript/composer/status state, while terminal backends own drawing and restoration.

## Gate

Run:

```bash
bash harness/check-tui-chatwidget-shell.sh
```

The gate asserts typed reducer effects, transcript state, frame lines/cursor facts, viewport truncation, headless backend draw state, live backend draw/restore behavior, metal haxe.rust generation, and generated Cargo check/test/run. It remains credential-free and does not open an app-server socket, call a model, or touch SQLite/log state.

## Still Not Proven

This is not upstream ChatWidget completeness. It does not open live app-server transport, execute tools, render ratatui history cells, display overlays/popups, or persist conversation state. `TUI-LIVE-5` attaches this shell to a fake app-server session so typed notifications can update the rendered transcript; `TUI-LIVE-6` should pump those events through the live redraw path.
