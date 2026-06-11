# haxe.rust Fixtures

haxe.rust capability and compiler smoke fixtures go here if the port needs local copies.

The haxe.rust source remains an external pinned checkout.

Current fixtures:

- `doctor-shape.v1.jq` asserts the minimal scaffold doctor JSON shape for portable and metal generated binaries.
- `app-protocol-roundtrip.v1.json` covers the selected upstream app-server protocol request, response, notification, transcript, and error payload subset.
- `mock-one-turn-transcript.v1.jsonl` is the deterministic transcript artifact for the mock one-turn runtime run.
- `mock-one-turn-state.v1.json` is the deterministic state summary artifact for the same run.
- `mock-one-turn-cancel-transcript.v1.jsonl` is the deterministic partial transcript artifact for a cancelled mock one-turn runtime run.
- `mock-one-turn-cancel-state.v1.json` is the deterministic state summary artifact for the same cancelled run.
