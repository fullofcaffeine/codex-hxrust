# App Protocol Subset

**Date:** 2026-06-10  
**Bead:** `HXCX-2.4` / `codex-hxrust-qml.4`  
**Baseline:** mainstream Codex app-server protocol v2 from `../codex/codex-rs/app-server-protocol`

## Scope

This slice implements a fixture-backed pure Haxe validator/normalizer for the first headless Codex app-server protocol surface.

Included client requests:

- `thread/start`
- `turn/start`
- `turn/interrupt`
- `thread/read`

Included server notifications:

- `thread/started`
- `thread/status/changed`
- `turn/started`
- `turn/completed`
- `item/started`
- `item/agentMessage/delta`
- `item/completed`
- `rawResponseItem/completed`
- `error`

Included response payloads:

- `ThreadStartResponse`
- `TurnStartResponse`
- `TurnInterruptResponse`
- `ThreadReadResponse`

The fixture also covers transcript-bearing turns with text `userMessage` and `agentMessage` items, selected assistant text delta notifications, and the raw response item completion notification for assistant `message` response items with `output_text` content.

## Error Policy

JSON-RPC errors are normalized with deterministic key ordering.

Codex turn errors follow upstream intent for selected `codexErrorInfo` variants:

- `threadRollbackFailed` does not affect turn status.
- `{ "activeTurnNotSteerable": ... }` does not affect turn status.
- all other selected/unknown error info values affect turn status.

## Fingerprint

`codexhx.protocol.app.AppProtocol.schemaFingerprintJson()` emits a deterministic subset fingerprint. The upstream schema golden is maintained at `reference/app-protocol-schema-fingerprints.v1.json` and checked by `harness/check-schema-fingerprints.sh`.

## Gate

Run from `.`:

```bash
harness/check-app-protocol.sh
```

The gate runs:

- Haxe interpreter harness
- haxe.rust generation through `hxml/app-protocol.hxml`
- generated `cargo check --locked`
- generated `cargo test --locked`
- generated binary execution
