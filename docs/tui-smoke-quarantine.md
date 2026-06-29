# TUI Smoke Quarantine

**Bead:** `ARCH-1` / `codex-hxrust-f512`

## Purpose

The legacy `codexhx.runtime.tui.smoke` package is validation machinery. It remains useful as a deterministic regression scaffold, but it is not production runtime architecture and must not be imported by production `codexhx.runtime.*` modules outside that package.

## Boundary

Production runtime code may depend on production packages such as:

- `codexhx.runtime.tui.terminal`
- `codexhx.runtime.tui.chatwidget`
- `codexhx.runtime.tui.appserver`
- other upstream-domain runtime packages extracted from smoke code

Production runtime code must not depend on:

- `codexhx.runtime.tui.smoke.*`
- `codexhx.validation.*`
- smoke DTOs, trace loops, fixture loaders, nullable fixture records, or expected-trace comparison helpers

If a smoke helper becomes production-worthy, extract a concise upstream-domain runtime abstraction first, add focused typed tests for that abstraction, and leave the smoke wrapper as validation-only evidence.

## Guard

Run:

```bash
npm run lint:import-boundaries
```

The guard scans `src/codexhx/runtime/**/*.hx` outside `src/codexhx/runtime/tui/smoke` and fails if production runtime source imports or fully qualifies validation/smoke packages. It is included in `npm run public:precommit`.

## Staged Migration

This slice intentionally does not move the giant smoke package yet. Existing smoke gates continue to run from the old namespace to avoid high-churn fixture breakage while the live TUI packages mature. The quarantine rule is the immediate architectural fence; later cleanup can move fixture-only smoke code under `codexhx.validation.tui.smoke` once production-worthy pieces such as agent navigation have been promoted.

`TUI-LIVE-8` applies that rule to agent navigation: `codexhx.runtime.tui.agent` now owns the typed state and picker formatting, while `TuiSmokeAgentNavigationState` only adapts legacy fixture string IDs and smoke direction values to the production module.
