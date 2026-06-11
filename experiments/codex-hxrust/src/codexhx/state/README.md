# State

State helpers for the pure-Haxe Codex experiment live here.

Current slices:

- `TranscriptStateStore` writes and loads deterministic one-turn transcript/state artifacts.
- `goals/ThreadGoalStore` owns the HXCX-5.3 in-memory thread-goal lifecycle subset.

Pure state transitions and transcript/store abstractions live here.

Filesystem, SQLite, or host-specific persistence should enter through explicit adapters.

## TranscriptStateStore

`TranscriptStateStore` is the HXCX-3.5 minimal persistence slice for a one-turn runtime run.

It writes two deterministic artifacts:

- `transcript.jsonl` contains one canonical runtime event JSON object per line.
- `state.json` contains the stable summary needed to resume/audit the mock run: schema, stream id, terminal state, assistant text, and event count.

The store uses a tmp-file plus rename write path for each artifact. This keeps the boundary close to atomic where the host filesystem supports it while preserving a plain-file format that is easy to diff in fixtures.

The current state surface intentionally does not persist the request prompt or credentials. Corrupt state JSON is normalized into `invalid_state_json` at path `$` so callers can report deterministic state-load failures without leaking parser exceptions.

Cancelled runs write the same artifact shape as completed runs. Their transcript is partial by design: all events observed before the safe checkpoint are written, followed by the terminal `session_cancelled` event.
