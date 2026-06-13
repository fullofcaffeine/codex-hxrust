# Thread/Read Token Usage Owner

**Bead:** `HXCX-4.21` / `codex-hxrust-ryc`
**Fixture:** `fixtures/hxrust/thread-read-token-usage-owner.v1.json`
**Gate:** `harness/check-thread-read-token-usage-owner.sh`

## Purpose

This slice models the selected raw upstream Codex attribution rules that decide which reconstructed turn owns a replayed `thread/tokenUsage/updated` notification when a client resumes or forks a stored thread.

The Haxe boundary is intentionally narrow: it does not fetch token usage, emit JSON-RPC notifications, or read rollout files. It resolves the owner turn over already reconstructed typed turn summaries.

## Upstream Anchors

- `../codex/codex-rs/app-server/src/request_processors/token_usage_replay.rs:29`
- `../codex/codex-rs/app-server/src/request_processors/token_usage_replay.rs:64`
- `../codex/codex-rs/app-server/src/request_processors/token_usage_replay.rs:69`
- `../codex/codex-rs/app-server/src/request_processors/token_usage_replay.rs:100`
- `../codex/codex-rs/app-server-protocol/src/protocol/thread_history.rs:78`
- `../codex/codex-rs/app-server-protocol/src/protocol/thread_history.rs:112`
- `../codex/codex-rs/app-server/tests/suite/v2/thread_resume.rs:1641`
- `../codex/codex-rs/app-server/tests/suite/v2/thread_resume.rs:1729`

## Boundary Shape

The Haxe facade lives in `codexhx.runtime.app.threadread`:

- `ThreadReadTokenUsageTurnOwnerHint` carries the active-turn snapshot id and optional position captured before a token-count rollout item.
- `ThreadReadTokenUsageOwnerRequest` combines typed reconstructed turns with that optional owner hint.
- `ThreadReadTokenUsageOwnerResolver` chooses the owner turn id with upstream-shaped precedence.
- `ThreadReadTokenUsageOwnerOutcome` and `ThreadReadTokenUsageOwnerReport` expose deterministic fixture summaries.

## Selected Behavior

- Prefer the explicit owner id when it still exists in the rebuilt turn list.
- If the owner id no longer exists, use the owner position to select the corresponding rebuilt turn.
- If rollout owner information is unavailable, select the latest completed or failed turn.
- If no completed or failed turn exists, select the latest reconstructed turn.
- Refuse empty reconstructed turn lists instead of emitting an empty owner id.

## Non-Goals

- Reading raw rollout JSONL.
- Implementing token accounting or usage aggregation.
- Emitting JSON-RPC `thread/tokenUsage/updated` notifications.
- Cafex or Cafetera adapter behavior.

## haxe.rust Pressure

No new haxe.rust compiler/runtime limitation was exposed by this slice. The code uses typed Haxe DTOs, enum abstracts, nullable owner hints, arrays, deterministic reports, and no raw Rust escapes; the harness passes under the Haxe interpreter and portable haxe.rust-generated Rust.
