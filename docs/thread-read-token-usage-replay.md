# Thread/Read Token Usage Replay Payload

**Bead:** `HXCX-4.22` / `codex-hxrust-nc2`
**Fixture:** `fixtures/hxrust/thread-read-token-usage-replay.v1.json`
**Gate:** `harness/check-thread-read-token-usage-replay.sh`

## Purpose

This slice models the selected restored `thread/tokenUsage/updated` payload construction that upstream Codex emits after `thread/resume` or `thread/fork` attaches to persisted token usage.

The Haxe boundary starts after owner attribution: it accepts a validated thread id, a resolved owner turn outcome from HXCX-4.21, and optional token usage info. It returns a typed notification payload or a deterministic refusal.

## Upstream Anchors

- `../codex/codex-rs/app-server/src/request_processors/token_usage_replay.rs:29`
- `../codex/codex-rs/app-server-protocol/src/protocol/v2/thread.rs:1255`
- `../codex/codex-rs/app-server-protocol/src/protocol/v2/thread.rs:1264`
- `../codex/codex-rs/app-server-protocol/src/protocol/v2/thread.rs:1272`
- `../codex/codex-rs/app-server-protocol/src/protocol/v2/thread.rs:1285`
- `../codex/codex-rs/app-server-protocol/src/protocol/v2/thread.rs:1298`
- `../codex/codex-rs/protocol/src/protocol.rs:1938`
- `../codex/codex-rs/protocol/src/protocol.rs:1952`
- `../codex/codex-rs/app-server/tests/suite/v2/thread_resume.rs:1514`
- `../codex/codex-rs/app-server/tests/suite/v2/thread_fork.rs:348`

## Boundary Shape

The Haxe facade lives in `codexhx.runtime.app.threadread`:

- `ThreadReadTokenUsageBreakdown` carries `totalTokens`, `inputTokens`, `cachedInputTokens`, `outputTokens`, and `reasoningOutputTokens`.
- `ThreadReadTokenUsageInfo` carries `total`, `last`, and nullable `modelContextWindow`.
- `ThreadReadTokenUsageReplayNotification` carries the upstream method name, thread id, owner turn id, and token usage payload.
- `ThreadReadTokenUsageReplayBuilder` validates selected inputs and builds deterministic outcomes.

## Selected Behavior

- Build `thread/tokenUsage/updated` for a valid thread id, resolved owner turn, and present token usage.
- Preserve total and last token-usage breakdown fields exactly under upstream camelCase names.
- Preserve nullable model context windows as either a numeric value or JSON `null`.
- Refuse missing token usage, unresolved owner turns, invalid thread ids, and negative counters before notification construction.

## Non-Goals

- Fetching token usage from a live `CodexThread`.
- Emitting over a JSON-RPC connection.
- Aggregating or mutating token accounting state.
- Reading rollout files or reconstructing turns.
- Cafex or Cafetera adapter behavior.

## haxe.rust Pressure

No new haxe.rust compiler/runtime limitation was exposed by this slice. The code uses typed Haxe DTOs, nullable notification payloads, abstract protocol IDs, JSON string construction, deterministic reports, and no raw Rust escapes; the harness passes under the Haxe interpreter and portable haxe.rust-generated Rust.
