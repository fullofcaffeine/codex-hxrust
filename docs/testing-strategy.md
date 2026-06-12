# Testing Strategy

**Decision:** Haxe-authored tests compiled to Rust are the primary codexhx gate. Upstream Codex tests, schemas, and fixtures are contract inputs and oracle evidence, not a replacement for tests that exercise the Haxe source through haxe.rust.

## Why

codexhx is not a Rust fork of upstream Codex. Its source of truth is Haxe that emits Rust through haxe.rust, so the main evidence must prove that:

1. the Haxe implementation has the intended Codex-compatible behavior;
2. the same Haxe source works through haxe.rust-generated Rust;
3. generated Rust builds and runs under locked Cargo gates;
4. upstream Codex contract drift is detected intentionally.

Running upstream Rust tests is useful, but many upstream tests bind to Rust crate internals, Tokio/runtime details, filesystem layout, feature flags, or implementation-specific helpers. Passing those tests directly is not the right first proof for a Haxe-authored implementation. Use upstream tests as an oracle source when they express public behavior; adapt or differential-test those behaviors through codexhx-owned fixtures.

## Test Hierarchy

1. **Schema and contract fingerprints**
   - Upstream Codex schemas remain the protocol source of truth.
   - `harness/check-schema-fingerprints.sh` detects selected schema drift and forces reviewed acceptance.

2. **Haxe-authored fixture/unit tests**
   - These are the primary tests for codexhx behavior.
   - They should run in the Haxe interpreter and through haxe.rust-generated Rust whenever the slice is meant to be supported by generated binaries.
   - They live in this repository and should be deterministic, credential-free, and fixture-backed.

3. **Generated Rust gates**
   - Generated crates must pass locked Cargo checks/tests.
   - Generated Rust is build output and must not be manually edited to make tests pass.

4. **Golden parity fixtures**
   - Upstream-shaped JSON-RPC inputs, transcripts, schemas, and state artifacts should produce canonical codexhx outputs.
   - These fixtures are owned here, with provenance recorded when copied or derived from upstream/Cafex sources.

5. **Differential oracle tests**
   - For selected public workflows, run upstream Codex and codexhx against equivalent inputs and compare normalized outputs/events/state.
   - Normalize away implementation-only details such as timings, temporary paths, process IDs, nondeterministic ordering, and internal Rust-only diagnostics.
   - Differential tests become more important as codexhx moves from DTO/protocol validation into runtime/tool/state behavior.

6. **Adapted upstream tests**
   - Import or adapt upstream tests only when they describe public behavior rather than upstream Rust internals.
   - Keep the adapted test in Haxe or in a harness that drives the generated codexhx binary through public inputs.

## Current Practice

Current app-server protocol work follows this pattern:

- inspect upstream Codex schemas and Rust protocol definitions in `../codex`;
- add Haxe validators and fixtures for the selected upstream message shape;
- run the Haxe interpreter harness;
- generate Rust through haxe.rust;
- run generated `cargo check --locked`, `cargo test --locked`, and binary execution;
- update schema fingerprint goldens only after reviewing the upstream schema addition.

This proves selected protocol contract parity and haxe.rust compilation health. It does not yet prove full upstream runtime parity.

## Upstream Test Usage

Use upstream tests in this order:

1. Identify what public behavior the upstream test is asserting.
2. Prefer a Haxe fixture/unit test that asserts the same behavior.
3. If the behavior requires an upstream runtime oracle, build a differential harness around public JSON-RPC, transcript, filesystem, process, or state artifacts.
4. Avoid depending on upstream private Rust modules or test helper internals unless the task is explicitly about a native Rust wrapper or upstream compatibility investigation.

## Completion Claims

Do not claim a codexhx slice is complete merely because upstream tests pass somewhere else. A slice is complete when its codexhx-owned gates pass and the relevant upstream contract/oracle evidence is recorded.

For broad replacement claims, upstream test parity is necessary but not sufficient. The slice also needs Haxe-authored generated-Rust gates, schema/fixture parity, fail-closed host-boundary tests where applicable, and documented residual gaps.
