# Thread/Read Resume Goal Snapshot

**Bead:** `HXCX-4.24` / `codex-hxrust-by5`
**Fixture:** `fixtures/hxrust/thread-read-resume-goal-snapshot.v1.json`
**Gate:** `harness/check-thread-read-resume-goal-snapshot.sh`

## Purpose

This slice models the selected upstream ordering around resume goal snapshots after restored token-usage replay. The Haxe boundary starts after the JSON-RPC response and token-usage delivery policy have settled, then decides whether a `thread/goal/updated` or `thread/goal/cleared` snapshot is emitted and whether idle lifecycle continuation is allowed.

## Upstream Anchors

- `../codex/codex-rs/app-server/src/request_processors/thread_goal_processor.rs:66`
- `../codex/codex-rs/app-server/src/request_processors/thread_goal_processor.rs:80`
- `../codex/codex-rs/app-server/src/request_processors/thread_goal_processor.rs:271`
- `../codex/codex-rs/app-server/src/request_processors/thread_lifecycle.rs:688`
- `../codex/codex-rs/app-server/src/request_processors/thread_lifecycle.rs:706`
- `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:2700`
- `../codex/codex-rs/app-server/src/request_processors/thread_processor.rs:2889`
- `../codex/codex-rs/app-server/tests/suite/v2/thread_resume.rs:920`
- `../codex/codex-rs/app-server/tests/suite/v2/thread_resume.rs:1469`

## Boundary Shape

The Haxe facade lives in `codexhx.runtime.app.threadread`:

- `ThreadReadResumeGoalSnapshotRequest` carries operation, response readiness, goals feature state, state-db availability, pending-request replay point, token-usage delivery outcome, and optional `ThreadGoal`.
- `ThreadReadResumeGoalSnapshotPolicy` preserves response-before-token-usage-before-goal ordering.
- `ThreadReadResumeGoalSnapshotOutcome` records snapshot kind, notification method, sequence, pending request replay point, and continuation intent.
- `ThreadReadResumeGoalContinuationIntent` distinguishes no continuation, snapshot-only, and idle-lifecycle emission.

## Selected Behavior

- Resume and loaded-resume goal snapshots are ordered after the response and after token-usage replay delivery settles.
- If token usage was delivered, goal notifications follow `response->thread/tokenUsage/updated`.
- If token usage was skipped without failure, goal snapshots may still follow `response`.
- A stored goal emits `thread/goal/updated`; an absent stored goal emits `thread/goal/cleared`.
- Active goals allow the upstream idle-lifecycle continuation hook after the snapshot. Paused and terminal goals remain snapshot-only.
- Loaded running-thread resume records that pending request replay happens after the goal snapshot.
- Fork inherits token-usage delivery ordering but does not emit a resume-goal snapshot.
- Disabled goals, unavailable state DB, response-before-ready, and unsettled token usage fail or skip deterministically.

## Non-Goals

- Opening JSON-RPC transports or emitting real notifications.
- Reading `StateDbHandle` or rollout files.
- Implementing goal reconciliation, listener channels, or extension hooks.
- Treating fork as a resume-goal snapshot path.
- Cafex or Cafetera adapter behavior.

## haxe.rust Pressure

No new haxe.rust limitation was exposed. The harness passes through the Haxe interpreter and portable haxe.rust-generated Rust with no raw Rust escapes.
