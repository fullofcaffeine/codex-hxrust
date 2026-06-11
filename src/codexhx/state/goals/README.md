# Goal State

`ThreadGoalStore` is the HXCX-5.3 pure-Haxe in-memory goal lifecycle subset.

Implemented:

- create active goal
- reject duplicate create while an unfinished goal exists
- get current goal
- set objective/status for app-server-style external mutations
- positive token budget validation
- simple usage accounting with `budgetLimited` transition
- clear current goal

Explicitly not implemented in this slice:

- SQLite persistence
- rollout/event replay
- runtime idle continuation
- turn-aware accounting locks
- metrics/analytics emission
- thread preview side effects

Those remain upstream/Cafex conformance work for later milestones.

Per `docs/state-backend-spike.md`, SQLite/sqlx is a replacement gate for persistent goal parity. This in-memory subset may support helper/headless and selected fixture-backed adapter work, but it must not be described as production goal persistence.
