# State

State helpers for the pure-Haxe Codex experiment live here.

Current slices:

- `TranscriptStateStore` writes and loads deterministic one-turn transcript/state artifacts.
- `goals/ThreadGoalStore` owns the HXCX-5.3 in-memory thread-goal lifecycle subset.

Pure state transitions and transcript/store abstractions live here.

Filesystem, SQLite, or host-specific persistence should enter through explicit adapters.

The current backend decision is recorded in `../../../docs/state-backend-spike.md` and checked by `../../../harness/check-state-backend-spike.sh`.

The app-server/TUI persistence boundary is recorded in `../../../docs/persistent-state-boundary.md` and checked by `../../../harness/check-persistence-boundary.sh`.

Summary:

- JSONL/plain-file state is sufficient for current helper, headless, and credential-free fixture evidence.
- SQLite/sqlx or equivalent production persistence parity is required before any slice claims persistent goal, runtime, or app-server state replacement.
- App-server/TUI production persistence effects such as `StateDbHandle`, `LogDbLayer`, rollout reconciliation, and live thread persistence must be implemented through a generic haxe.rust metal/native Rust boundary.
- No production state migration is implied by the current experiment.

## TranscriptStateStore

`TranscriptStateStore` is the HXCX-3.5 minimal persistence slice for a one-turn runtime run.

It writes two deterministic artifacts:

- `transcript.jsonl` contains one canonical runtime event JSON object per line.
- `state.json` contains the stable summary needed to resume/audit the mock run: schema, stream id, terminal state, assistant text, and event count.

The store uses a tmp-file plus rename write path for each artifact. This keeps the boundary close to atomic where the host filesystem supports it while preserving a plain-file format that is easy to diff in fixtures.

The current state surface intentionally does not persist the request prompt or credentials. Corrupt state JSON is normalized into `invalid_state_json` at path `$` so callers can report deterministic state-load failures without leaking parser exceptions.

Cancelled runs write the same artifact shape as completed runs. Their transcript is partial by design: all events observed before the safe checkpoint are written, followed by the terminal `session_cancelled` event.
