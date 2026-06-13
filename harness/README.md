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
- `check-diagnostics.sh` validates the HXCX-4.6 diagnostic log redaction and failure-report fixture IDs through Haxe, haxe.rust, and generated Cargo.
- `check-protocol-ids.sh` runs the Haxe ID round-trip harness and compiles the same harness through haxe.rust.
- `check-json-boundary.sh` validates typed JSON boundary helpers and the serde bridge facade.
- `check-config-profile.sh` validates the upstream-first config/profile DTO subset, redacted diagnostics, and unsupported field reporting.
- `check-app-protocol.sh` validates the upstream app-server protocol subset, fixture round trips, deterministic error behavior, and schema fingerprint emission.
- `check-schema-fingerprints.sh` compares the selected upstream app-server schema subset with the accepted golden fingerprint and writes a diff report under `generated/reports/`.
- `check-mock-model-stream.sh` validates the credential-free upstream-shaped mock SSE stream parser, fixture-backed model provider start/cancel boundary, one-turn session terminal state, cancellation checkpoints, structured session errors, deterministic malformed-stream errors, golden internal runtime event output, transcript/state fixture output, secret-free persistence, and corrupt state handling.
- `check-headless-jsonl-adapter.sh` validates the HXCX-3.x command/app-server JSONL adapter for start, submit, status, transcript, canonical JSONL output, lifecycle/item/agent-delta/raw-response/error notifications, failed-turn state, and explicit unsupported-command errors.
- `check-runtime-app-client.sh` validates the HXCX-4.7 typed runtime event bus and in-memory app-server client facade, upstream lossless/best-effort notification classification, bounded queue lag evidence, request/response correlation, typed error categories, and generated Rust gate.
- `check-tui-story-replay.sh` validates the HXCX-4.8 selected upstream TUI story replay fixture, typed startup/app-event/key-event/codex-event/history/op parsing, environment-noise normalization, stable replay fingerprint, and generated Rust gate.
- `check-apply-patch-dry-run.sh` validates the HXCX-4.1 apply-patch dry-run wrapper, deterministic error cases, safe relative-path policy, and mutation-disabled default.
- `check-process-exec.sh` validates the HXCX-4.2 process exec wrapper, exact approval policy, denied-command no-exec proof, deterministic stdout/stderr truncation, and exit-code mapping.
- `check-sandbox-gate.sh` validates the HXCX-4.3 fail-closed sandbox permission gate, unsupported-platform denial, policy decisions, absent bypass path, and security-review fixture.
- `check-state-backend-spike.sh` validates the HXCX-4.4 JSONL versus SQLite state backend decision, JSONL limitations, SQLite/sqlx wrapper cost estimate, replacement-gate rule, and no-production-migration guard.
- `check-tool-registry.sh` validates the HXCX-4.5 tool registry DTOs, fixture lookup, MCP unsupported-feature errors, future real-MCP scope, and generated Rust gate.
- `check-caf-receipts.sh` validates the HXCX-5.1 Caf session/turn receipt writer, absent-env no-ops, pretty JSON fixtures, overwrite behavior, and unsupported source failures.
- `check-caf-bridge.sh` validates the HXCX-5.2/HXCX-8.1/HXCX-8.4 Caf effort/wake/mode/goal/queue directory bridge, request consumption, pretty JSON receipts, idempotent duplicate scans, supported mode next-turn rails, invalid mode refusal, and fail-closed invalid goal requests.
- `check-caf-active-lane.sh` validates the HXCX-8.2 Caf active-lane capability writer, optional native live status, run-id selection, wake directories, generated Cargo output, and fail-closed owner/native PID proof.
- `check-caf-continuity.sh` validates the HXCX-5.4 Caf successor/predecessor metadata parser, continuity receipt fixtures, deterministic invalid metadata, and explicit no-hidden-inference behavior.
- `check-goals.sh` validates the HXCX-5.3 goal DTO, in-memory state transitions, model-facing goal tool subset, and explicit unsupported goal behavior.
- `check-cafetera-contract-subset.sh` runs the HXCX-5.5 selected Cafetera Codex module contract subset against hxrust-backed harnesses and emits a pass/fail/gap report without making a production replacement claim.
- `check-cafex-seam-ledger.sh` validates the HXCX-5.6 Cafex hxrust seam ledger for patch classes, supported evidence, unsupported reasons, source seam coverage, and replacement-review usability.
- `check-friction-comparison.sh` validates the HXCX-6.1 Cafex patch-stack versus hxrust burden comparison against the Cafetera seam ledger, Cafex runtime patch metrics, local hxrust seam ledger, fixture counts, and gate counts.
- `check-migration-modes.sh` validates the HXCX-6.2 migration-mode policy for helper-only, sidecar/headless, selected adapter-slice, and broader replacement rollout criteria.
- `check-operator-runbook.sh` validates the HXCX-6.4 operator runbook for rollback commands, distribution artifact shape, diagnostics, and the no-production-default-change guard.
- `check-haxe-rust-pressure-gaps.sh` validates the HXCX-7.1 haxe.rust pressure-gap ledger, status/severity/source-area counts, and current raw Rust escape pressure in app/test Haxe source.
- `check-haxe-rust-upstream-repros.sh` validates the HXCX-7.2 upstream repro map and confirms there are no remaining generic haxe.rust expected-failure fixtures.
- `check-haxe-rust-production-readiness.sh` validates the HXCX-7.3 haxe.rust production-readiness scorecard and cross-checks measured inputs against pressure-gap, contract, seam, runbook, and pin ledgers.
- `check-haxe-rust-performance-convergence-plan.sh` validates the HXCX-7.5 portable/metal performance convergence plan, benchmark criteria, profile split, and haxe.rust follow-up link.
- `check-replacement-go-no-go.sh` validates the HXCX-6.3 G6 replacement decision record against readiness, friction, seam, contract, and operator runbook evidence.
- `check-post-experiment-archive.sh` validates the HXCX-7.4 post-experiment archive, reusable artifacts, abandoned/deferred paths, and Brew conversion notes against the G6 decision.
