# State Backend Spike

**Date:** 2026-06-11
**Bead:** `HXCX-4.4` / `codex-hxrust-hpu.4`
**Gate:** G4 tools/state/security
**Decision:** Keep JSONL/plain-file state for the current experiment. Require SQLite/sqlx or an equivalent production persistence adapter before any slice claims persistent goal/runtime state replacement.

Machine-readable record:

`reference/state-backend-spike.v1.json`

Validation gate:

```bash
harness/check-state-backend-spike.sh
```

## Decision

JSONL plus `state.json` remains the owned backend for credential-free fixture, transcript, and headless sidecar evidence. It is easy to diff, replay, reset, redact, and include in harness output.

SQLite/sqlx is not required for the existing one-turn transcript store, in-memory goal lifecycle subset, or current selected adapter-slice proof. It becomes required when a slice claims parity for persistent goals, app-server state, concurrent multi-session runtime state, schema migrations, backup/recovery, or compatibility with upstream/Cafex SQLite files such as `goals_1.sqlite`.

No production state migration is implied by this decision. Existing upstream or Cafex SQLite state must not be rewritten, upgraded, imported, or deleted by codexhx until a later migration decision record and rollback drill exist.

## JSONL Backend

Owned current surfaces:

| Surface | Artifact | Scope |
| --- | --- | --- |
| One-turn transcript | `transcript.jsonl` | Canonical runtime events, one JSON object per line. |
| One-turn state summary | `state.json` | Schema, stream id, terminal state, assistant text, event count. |
| Cancelled transcript/state | `mock-one-turn-cancel-state.v1.json` | Partial transcript with deterministic terminal cancellation. |
| Headless adapter transcript | headless JSONL harness output | Credential-free command/result evidence. |

Accepted strengths:

- Human-inspectable and fixture-friendly.
- Deterministic enough for git diffs and harness comparison.
- Easy to reset by deleting an experiment output directory.
- Credential-free by construction in current stores.
- No native database dependency or runtime packaging burden.

Documented limitations:

- No multi-writer or cross-process transaction guarantee.
- No indexed relational query support for goals, threads, or app-server views.
- No production schema migration framework.
- No compatibility claim for upstream or Cafex SQLite files.
- No lock, backup, compaction, or corruption-recovery policy beyond structured JSON parse errors.
- No durable atomic batch across transcript, state, goal, and tool records.

## SQLite/sqlx Cost

The minimum production-grade wrapper is medium-high cost, because it crosses the Haxe-to-Rust native boundary and has to carry real operational semantics rather than just storage syntax.

Required work before SQLite-backed replacement claims:

| Tasklet | Notes |
| --- | --- |
| Backend choice | Choose `sqlx`, `rusqlite`, or another native Rust owner with license and async/blocking review. |
| Typed Haxe facade | Keep Haxe portable surfaces typed; isolate native calls behind generic haxe.rust externs. |
| Schema and migrations | Add schema fingerprints, migration IDs, no-op/current-version checks, and downgrade behavior. |
| Fixture import/export | Generate deterministic JSON evidence from SQLite rows for harness comparison. |
| Error mapping | Normalize locked, missing, corrupt, permission, and migration errors into stable diagnostics. |
| Concurrency policy | Define single-writer or pooled access, transaction boundaries, and app-server interaction rules. |
| Backup and rollback | Document copy/restore behavior before mutation and prove no production default change. |
| Upstream compatibility | Compare any `goals_1.sqlite` or runtime database contract against upstream/Cafex pins before use. |

Estimated follow-up size: at least two dedicated beads, one for the generic haxe.rust SQLite/native wrapper pressure test and one for codexhx state adapter semantics. More beads are likely if app-server transport and persistent goal parity are pulled into scope together.

## Replacement Gate

| Mode | State backend requirement |
| --- | --- |
| Helper-only | JSONL/plain files are sufficient. |
| Sidecar/headless | JSONL/plain files are sufficient for fixture-backed, credential-free state. |
| Selected adapter-slice | JSONL is sufficient unless the named slice claims persistent goal/runtime/app-server state parity. |
| Broad replacement | SQLite/sqlx or equivalent production persistence parity is required before review. |

This gate is about semantic ownership, not speed. Portable Haxe should keep generating idiomatic Rust where haxe.rust can prove it, but persistent state replacement must match the source contract before routing changes.

## Follow-Up

- `codex-hxrust-hpu.5`: add MCP/tool registry compatibility skeleton.
- Future bead: create a generic haxe.rust SQLite/native-boundary spike if persistent state replacement becomes a selected slice.
- Future bead: create a codexhx SQLite state adapter only after the generic compiler/native wrapper spike is accepted.
