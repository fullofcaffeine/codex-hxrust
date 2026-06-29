# TUI Live Agent Navigation Integration

**Beads:** `TUI-LIVE-9` / `codex-hxrust-3v64`, `TUI-LIVE-10` / `codex-hxrust-dglj`

This slice connects the production `AgentNavigationState` to the minimal live
TUI shell. `FakeTuiAppServerFacade` now composes the state beside active session
and active thread ownership, so typed fake app-server events can update agent
metadata, path/running activity, closed state, removal, and active-thread
selection.

`ChatWidgetShellState` stores the currently rendered agent label, and
`ChatWidgetShellRenderer` appends it to the header only when multi-thread agent
state makes the label non-empty. The default single-thread frame stays unchanged.

`TUI-LIVE-10` adds the first semantic input path for this state. The terminal
input mapper distinguishes plain Left/Right from agent navigation, and the live
native probe maps Alt+Left/Alt+Right into `AgentPrevious` / `AgentNext`. The
app-server pump intercepts those events before composer editing, cycles active
threads through `AgentNavigationState`, refreshes the rendered label, and draws
through the existing scheduler.

Validation:

```bash
bash harness/check-tui-live-agent-navigation.sh
```

The gate covers headless and live-backend rendering, prompt submission after
active-thread switching, semantic previous/next input wraparound, singleton
no-op behavior, plain-arrow composer coexistence, active-child removal fallback
to primary, and generated metal haxe.rust Cargo check/test/run. It still does
not implement real app-server JSON-RPC transport, loaded-thread backfill, or the
full upstream agent picker UI.
