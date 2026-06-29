# codex-hxrust

`codex-hxrust` is a work-in-progress Haxe implementation of OpenAI Codex that targets Rust through the external `haxe.rust` backend.

The goal is whole-Codex parity, not a headless-only subset: app-server protocol, runtime behavior, tool execution, state, persistence, and the interactive TUI are all in scope. This repository is public and has publication safeguards in place, but it is still an active porting project rather than a production Codex replacement.

Public-readiness scaffolding includes repo-managed hooks, Haxe formatting, staged and full-history gitleaks checks, GitHub CI, Dependabot, and generated-Rust smoke gates.

## Port Progress

Current Beads-based completion snapshot:

```text
[#######################################-] 98% (642/651 non-epic Beads closed)
```

This is an unweighted planning and throughput indicator, not a whole-Codex parity claim. The port has many small deterministic gates, including generated-Rust protocol/runtime/TUI slices, but a runnable interactive Codex TUI still needs live terminal ownership, app-server JSON-RPC integration, async task/channel boundaries, state DB persistence, tool execution, and broader upstream widget/runtime parity.

The current queue is intentionally pivoted toward a minimal live TUI shell. `TUI-LIVE-0` / `codex-hxrust-nvs9` now defines the production `TerminalBackend` contract before more deterministic smoke expansion. The next ready milestone is `TUI-LIVE-1` / `codex-hxrust-3ddw`: a generated Rust binary that can own a terminal session, draw a minimal Codex shell frame, process basic input/resize events, and restore terminal state without credentials or model traffic.

The strategy is upstream-first:

1. Model the mainstream Codex protocol/runtime shape from `../codex`.
2. Prove Haxe-authored, Rust-emitted parity in small gated slices.
3. Add Cafex/Cafetera compatibility later as an adapter/conformance layer.
4. Treat haxe.rust limitations found during the port as upstreamable compiler/runtime work.

Headless/core slices are the first proving ground because they are easier to gate without credentials or terminal interactivity. They are not the final scope. TUI work is sequenced after enough protocol, state, tool, and runtime foundations exist to support it cleanly.

The current upstream TUI/live-runtime roadmap is [docs/upstream-tui-live-runtime-sequence.md](docs/upstream-tui-live-runtime-sequence.md). It keeps raw Codex TUI/runtime work ahead of Cafex adapter expansion.

When choosing new work, keep Beads prioritized so mainstream/raw Codex parity is ready first. Cafex tasks should sit later in the queue unless the user explicitly asks for Cafex compatibility or the required upstream-shaped core slice already exists.

This is not a forked copy of Codex or haxe.rust. External repositories stay external and are tracked through pin files under `reference/`.

## Local Haxe Tooling

This repo uses lix-style scoped Haxe libraries for local development:

```bash
npm install
npm run hooks:install
npm run hx:portable
npm run hx:metal
npm run test:generated-cargo
bash harness/check-tui-smoke.sh
```

`haxe_libraries/reflaxe.rust.hxml` points at the sibling `../haxe.rust` checkout so local builds do not depend on global `haxelib dev` state. This is a live path dependency: edits in `../haxe.rust/src`, `../haxe.rust/std`, or its vendored Reflaxe tree are reflected immediately by this repo's `haxe`/haxe.rust builds, even before the haxe.rust change is committed.

`reference/haxe-rust.pin.json` is reproducibility metadata, not what local scoped builds use to choose compiler files. Update the pin only after a haxe.rust change has been committed, pushed, and validated as the known-good compiler revision for codex-hxrust. haxe.rust itself still owns haxelib package/dev-checkout smoke tests, and pin updates here must keep `scripts/check-generated-cargo.sh` green.

`fixtures/hxrust/` is a legacy codexhx fixture namespace for deterministic Haxe interpreter and haxe.rust-generated Rust proof gates. It is not the sibling compiler repository's fixture directory; generic backend fixtures belong in `../haxe.rust`. See [docs/fixture-namespace.md](docs/fixture-namespace.md) for the ownership rules.

## Public Readiness And Hooks

Install repo-managed hooks after cloning:

```bash
npm run hooks:install
```

The pre-commit hook delegates to Beads' official `bd hooks run pre-commit` exporter, stages `.beads/issues.jsonl` and `.beads/interactions.jsonl`, scans staged changes with gitleaks, and formats staged Haxe files with `haxelib formatter`, skipping generated/vendor output. Full public-readiness checks are:

Use `npm run hooks:install` as the project hook installer. `bd hooks install --beads` is useful to inspect Beads' generated shims, but it changes `core.hooksPath` to `.beads/hooks`; this repo keeps the active hook source in committed `scripts/hooks` and delegates to `bd hooks run pre-commit` from there.

```bash
npm run format:haxe:check
npm run format:haxe:changed -- origin/main
npm run security:gitleaks
npm run public:precommit
```

`scripts/security/run-gitleaks.sh` does not silently accept a full-history result that reports zero commits scanned when git history exists. If a local gitleaks version behaves that way, the wrapper falls back to scanning the `git log -p --all` patch stream and then scans the current tree with `gitleaks detect --no-git`.

The package is marked `private` to prevent accidental npm publication. GitHub repository visibility is managed separately from npm publishing.

GitHub CI always runs the public formatter and gitleaks workflows. The generated haxe.rust Cargo smoke job needs access to the sibling `../haxe.rust` repository; on public GitHub Actions it runs when `HAXE_RUST_CHECKOUT_TOKEN` is configured, and otherwise emits a skip notice. Local publishing readiness still requires `npm run test:generated-cargo`.

## Repository Status

Current completed gates:

- `HXCX-0`: inventory, topology, fixture map, repo/vendoring policy, parity scorecard
- `HXCX-1`: haxe.rust scaffold, portable/metal build profiles, locked generated Cargo gates, interop policy, doctor binary, haxe.rust audit tooling
- `HXCX-2.1`: protocol ID/newtype slice
- `HXCX-2.2`: typed JSON boundary and serde bridge facade
- `HXCX-2.3`: upstream-first config/profile DTO subset with redacted diagnostics
- `HXCX-3.6`: headless JSONL adapter emits fixture-backed upstream app-server lifecycle notifications

Next likely work:

- continue the next upstream/raw Codex protocol, runtime, app-server, tool, or state parity slice from `bd ready`
- `HXCX-7.x`: upstream haxe.rust fixes discovered by the pressure test

Use Beads for the live queue:

```bash
bd ready
bd show <issue-id>
bd update <issue-id> --status in_progress
bd close <issue-id>
```

Maintain the ready queue so raw Codex parity tasks outrank Cafex adapter tasks. If a later Cafex item appears ahead of the intended core work, reprioritize or dependency-gate the Beads items before continuing.

## External Checkouts

Expected sibling directories:

| Path | Role |
| --- | --- |
| `../codex` | Mainstream upstream Codex source of truth |
| `../fullofcaffeine/deps/codex` and related `../fullofcaffeine` paths | Cafex/Cafetera references used later for adapter parity |
| `../haxe.rust` | External haxe.rust compiler/runtime checkout |

Recorded pins:

| File | Purpose |
| --- | --- |
| `reference/upstream-codex.pin.json` | Upstream Codex baseline |
| `reference/cafex-codex.pin.json` | Cafex fork baseline |
| `reference/haxe-rust.pin.json` | haxe.rust backend pin |
| `reference/haxe-rust-local-patches.v1.json` | Historical local haxe.rust patch ledger; currently records the resolved CallStack workaround |

Do not vendor whole source trees into this repo unless a later Bead explicitly changes the policy. `../codex` and `../fullofcaffeine` are read-only references for this project; inspect them freely, but make changes only in this repository or, for generic compiler work, in `../haxe.rust`.

## haxe.rust Improvement Workflow

The `../haxe.rust` checkout is part of the work surface. When the Codex port exposes a limitation:

1. Reduce it to a small haxe.rust fixture or failing example.
2. Fix it in `../haxe.rust` in an upstreamable way.
3. Run haxe.rust validation plus this repo's gates against the live sibling checkout.
4. Commit and push the haxe.rust fix in `../haxe.rust`.
5. Update `reference/haxe-rust.pin.json` only after the committed haxe.rust revision is the intended known-good consumer revision and the gates pass.
6. Record patches, gaps, and follow-up work in Beads and `reference/`.

Do not update the pin merely to test local compiler edits. The direct scoped-library path already makes those edits visible to codex-hxrust builds.

Current known haxe.rust pressure points are tracked under the `HXCX-7.x` Beads epic.

Validation gates and deterministic parity reports live under `codexhx.validation.*`; production runtime code stays under `codexhx.runtime.*`. The current resume/TUI validation gates are in `codexhx.validation.tui.resume.live`, while reusable host/runtime abstractions remain in `codexhx.runtime.tui.resume` and `codexhx.runtime.tui.resume.host`.

Generated Rust layout is also a pressure point. codexhx enables haxe.rust nested module output with `-D rust_nested_modules`, so generated validation gates now land under reviewable paths such as `codexhx/validation/tui/resume/live/app_server_boundary_gate.rs` instead of one flat package-derived filename. Keep Haxe production module names short and upstream-domain-shaped; remaining output work should focus on narrower generic haxe.rust refinements such as crate-root package mapping and alias reduction.

## Profile Approach

Use `metal` now where codexhx needs Rust-native runtime/tool behavior, stricter host-boundary semantics, or production-shaped performance. Keep `portable` for DTOs, codecs, fixtures, schema/protocol validation, config, and pure state. At the compiler level, haxe.rust portable output should converge toward metal-level Rust performance wherever the Rust lowering can preserve Haxe semantics.

Async runtime APIs should stay backend-neutral in Haxe. Tokio is an implementation target for the Rust backend, not the Codex-facing authoring model; live async work should flow through typed task/stream/cancel/backpressure abstractions first. See `docs/async-runtime-contract.md`.

The detailed convergence plan lives in `docs/haxe-rust-performance-convergence-plan.md` and is checked by `harness/check-haxe-rust-performance-convergence-plan.sh`.

## Layout

```text
AGENTS.md                         Agent rules and session completion workflow
docs/                             Decisions, policies, topology, scorecards
reference/                        Pins, manifests, audit notes, patch records
vendor/                           Empty by policy during G0/G1
hxml/                             Haxe build profiles and harness hxmls
src/                              Haxe-authored port code
native/                           Narrow owned Rust wrapper area
fixtures/                         Local fixture subsets and jq assertions
harness/                          Credential-free validation scripts
scripts/                          Build/audit/update tooling
generated/                        haxe.rust output, ignored except README/.gitignore
```

## Build And Validation

From the repo root:

```bash
npm run public:precommit
harness/check-doctor-json.sh
harness/check-protocol-ids.sh
harness/check-json-boundary.sh
harness/check-config-profile.sh
scripts/check-generated-cargo.sh
jq empty reference/*.json
```

The gates are credential-free. They should not make model calls or mutate real Codex state.

Testing policy is documented in `docs/testing-strategy.md`. In short: Haxe-authored tests compiled through haxe.rust are the primary codexhx proof; upstream Codex schemas/tests/fixtures are contract inputs and oracle evidence; relevant upstream public-behavior tests should be ported, covered by differential harnesses, or explicitly marked not-applicable as runtime parity grows.

Generated Rust is build output. Clean generated crates after validation unless a Bead explicitly asks for a generated snapshot:

```bash
rm -rf generated/portable \
       generated/metal \
       generated/protocol-ids \
       generated/json-boundary \
       generated/config-profile
```

## Current Scaffold

The generated doctor binary prints machine-readable JSON with:

- scaffold stage
- upstream/Cafex stance
- active haxe.rust pin
- profile/features
- Haxe/Rust/Cargo toolchain strings
- generated Rust policy

Protocol work currently includes:

- UUID-backed `SessionId` and `ThreadId`
- string-backed `TurnId`, `ToolCallId`, `ModelId`, and `PathLikeId`
- JSON-RPC/MCP-style `RequestId`
- typed JSON parse/field helpers under `codexhx.protocol.json`
- deterministic JSON error code/path/message mapping
- upstream-shaped config/profile DTO parsing under `codexhx.config`
- redacted config diagnostic JSON with unsupported field listing

## Policy Highlights

- Upstream Codex is the core baseline; Cafex comes later as an adapter.
- Beads priorities and dependencies should encode that raw Codex parity comes before Cafex adapter expansion.
- App-level Haxe code stays pure Haxe.
- Native Rust is allowed only behind typed Haxe facades and owned wrapper modules.
- Raw Rust app-code injection is banned by policy.
- Security-sensitive host wrappers must fail closed.
- Broad `Dynamic` is confined to documented JSON/runtime boundaries.
- haxe.rust is external and pinned, not copied into this repo by default.

## Beads

This repo uses Beads for issue tracking. Modern `bd` uses an embedded Dolt backend locally here, but the committed collaboration artifact is JSONL: `.beads/issues.jsonl` plus `.beads/interactions.jsonl`. Local backend/runtime files such as `.beads/embeddeddolt/` and `.beads/*.db` are ignored by `.beads/.gitignore`.

The practical workflow is JSONL-in-git: review, commit, and push tracked Beads JSONL like any other project file. Do not require `bd sync` here. On a fresh clone or after local Beads runtime state is missing, run `bd bootstrap --yes` to hydrate the embedded backend from the tracked JSONL.

Run:

```bash
bd onboard
bd bootstrap --yes
bd ready
```

Before ending a session, follow `AGENTS.md`: file follow-ups, run gates, update Beads JSONL, commit, push, and verify the branch is up to date with origin.
