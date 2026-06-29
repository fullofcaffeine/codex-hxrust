# TUI Live Agent Navigation Integration

**Bead:** `TUI-LIVE-9` / `codex-hxrust-3v64`

This slice connects the production `AgentNavigationState` to the minimal live
TUI shell. `FakeTuiAppServerFacade` now composes the state beside active session
and active thread ownership, so typed fake app-server events can update agent
metadata, path/running activity, closed state, removal, and active-thread
selection.

`ChatWidgetShellState` stores the currently rendered agent label, and
`ChatWidgetShellRenderer` appends it to the header only when multi-thread agent
state makes the label non-empty. The default single-thread frame stays unchanged.

Validation:

```bash
bash harness/check-tui-live-agent-navigation.sh
```

The gate covers headless and live-backend rendering, prompt submission after
active-thread switching, active-child removal fallback to primary, and generated
metal haxe.rust Cargo check/test/run. It still does not implement real
app-server JSON-RPC transport, loaded-thread backfill, keyboard shortcut
dispatch, or the full upstream agent picker UI.
