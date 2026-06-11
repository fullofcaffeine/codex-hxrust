# Harness

Fixture harness work starts here.

Initial fixture-run schema:

```json
{
  "schema": "codex-hxrust.fixture-run.v1",
  "id": "upstream.basic-one-turn",
  "source": "upstream-codex",
  "kind": "sse-sequence",
  "input": {
    "events": []
  },
  "expect": {
    "notifications": [],
    "state": {}
  }
}
```

Keep harness inputs credential-free.

Current harnesses:

- `check-doctor-json.sh` regenerates portable and metal crates, runs each generated binary, and validates the doctor JSON shape with `fixtures/hxrust/doctor-shape.v1.jq`.
- `check-protocol-ids.sh` runs the Haxe ID round-trip harness and compiles the same harness through haxe.rust.
- `check-json-boundary.sh` validates typed JSON boundary helpers and the serde bridge facade.
- `check-config-profile.sh` validates the upstream-first config/profile DTO subset, redacted diagnostics, and unsupported field reporting.
- `check-app-protocol.sh` validates the upstream app-server protocol subset, fixture round trips, deterministic error behavior, and schema fingerprint emission.
- `check-schema-fingerprints.sh` compares the selected upstream app-server schema subset with the accepted golden fingerprint and writes a diff report under `generated/reports/`.
- `check-mock-model-stream.sh` validates the credential-free upstream-shaped mock SSE stream parser, fixture-backed model provider start/cancel boundary, one-turn session terminal state, structured session errors, deterministic malformed-stream errors, golden internal runtime event output, transcript/state fixture output, secret-free persistence, and corrupt state handling.
