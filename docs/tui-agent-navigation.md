# TUI Agent Navigation State

**Bead:** `TUI-LIVE-8` / `codex-hxrust-4dnm`

`codexhx.runtime.tui.agent` is the production home for the TUI state that tracks the main thread plus side-agent threads available for keyboard navigation. The state uses `ThreadId` values internally, preserves first-seen thread ordering, stores immutable metadata entries, cycles next/previous with wraparound, formats the active agent label, and removes closed threads from the picker order.

The legacy smoke fixture package still receives thread IDs as strings. Its `TuiSmokeAgentNavigationState` wrapper converts those strings at the fixture boundary and delegates behavior to `AgentNavigationState`; production modules must not import smoke.

Validation:

```bash
haxe -cp src -cp test -main TuiAgentNavigationHarness --interp
bash harness/check-tui-agent-navigation.sh
```

The gate covers typed ID ordering, metadata updates, record-activity backfill, adjacent navigation, primary/path/fallback labels, picker row formatting, closed-thread tombstones, removal, clear, portable haxe.rust generation, and generated Cargo check/test/run. It does not yet attach the state to the live TUI thread router or app-server events.
