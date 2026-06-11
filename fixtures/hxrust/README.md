# haxe.rust Fixtures

Current fixtures:

- `doctor-shape.v1.jq` validates the minimal doctor command shape.
- `diagnostics-output.v1.jsonl` validates redacted diagnostic logs and fixture-bearing failure reports.
- `headless-jsonl-adapter-input.v1.jsonl` and `headless-jsonl-adapter-output.v1.jsonl` validate the debug JSONL adapter.
- `thread-goal-active.v1.json` validates the HXCX-5.3 `ThreadGoal` DTO shape.
- `thread-goal-transition.v1.jsonl` validates the HXCX-5.3 in-memory goal lifecycle slice.
- `goal-tool-output.v1.jsonl` validates the HXCX-5.3 `get_goal`, `create_goal`, and `update_goal` tool subset.
- `apply-patch-dry-run-input.v1.patch` covers add, update, and delete hunks without mutating the filesystem.
- `apply-patch-dry-run-output.v1.jsonl` covers successful dry-run output plus deterministic mutation-disabled, invalid-header, and unsafe-path failures.
- `process-exec-output.v1.jsonl` validates denied-by-default process execution, exact approval, sandbox marker proof, stdout/stderr truncation, and non-zero exit mapping.
- `sandbox-gate-output.v1.jsonl` validates unsupported-platform fail-closed behavior, sandbox policy decisions, absent bypass path, and security-sensitive denials.

haxe.rust capability and compiler smoke fixtures go here if the port needs local copies.

The haxe.rust source remains an external pinned checkout.

Current fixtures:

- `doctor-shape.v1.jq` asserts the minimal scaffold doctor JSON shape for portable and metal generated binaries.
- `app-protocol-roundtrip.v1.json` covers the selected upstream app-server protocol request, response, notification, transcript, and error payload subset.
- `mock-one-turn-transcript.v1.jsonl` is the deterministic transcript artifact for the mock one-turn runtime run.
- `mock-one-turn-state.v1.json` is the deterministic state summary artifact for the same run.
- `mock-one-turn-cancel-transcript.v1.jsonl` is the deterministic partial transcript artifact for a cancelled mock one-turn runtime run.
- `mock-one-turn-cancel-state.v1.json` is the deterministic state summary artifact for the same cancelled run.
- `headless-jsonl-adapter-input.v1.jsonl` drives the HXCX-3.4 start/submit/status/transcript adapter fixture.
- `headless-jsonl-adapter-output.v1.jsonl` is the canonical JSONL response/event transcript expected from that fixture.
