# codex-hxrust

`codex-hxrust` is an experiment to port all of OpenAI Codex to pure Haxe that emits Rust through [`haxe.rust`](../haxe.rust), including the app-server, runtime, tools, state, and TUI surfaces.

The strategy is upstream-first:

1. Model the mainstream Codex protocol/runtime shape from `../codex`.
2. Prove Haxe-authored, Rust-emitted parity in small gated slices.
3. Add Cafex/Cafetera compatibility later as an adapter/conformance layer.
4. Treat haxe.rust limitations found during the port as upstreamable compiler/runtime work.

Headless/core slices are the first proving ground because they are easier to gate without credentials or terminal interactivity. They are not the final scope. The end goal is whole-Codex parity, including the interactive TUI and live runtime behavior, with TUI work sequenced after enough protocol, state, tool, and runtime foundations exist to support it cleanly.

The current upstream TUI/live-runtime roadmap is [docs/upstream-tui-live-runtime-sequence.md](docs/upstream-tui-live-runtime-sequence.md). It keeps raw Codex TUI/runtime work ahead of Cafex adapter expansion.

When choosing new work, keep Beads prioritized so mainstream/raw Codex parity is ready first. Cafex tasks should sit later in the queue unless the user explicitly asks for Cafex compatibility or the required upstream-shaped core slice already exists.

This is not a forked copy of Codex or haxe.rust. External repositories stay external and are tracked through pin files under `reference/`.

## Local Haxe Tooling

This repo uses lix-style scoped Haxe libraries for local development:

```bash
npm install
npm run hx:portable
npm run hx:metal
npm run test:generated-cargo
```

`haxe_libraries/reflaxe.rust.hxml` points at the sibling `../haxe.rust` checkout so local builds do not depend on global `haxelib dev` state. haxe.rust itself still owns haxelib package/dev-checkout smoke tests, and pin updates here must keep `scripts/check-generated-cargo.sh` green.

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
bd sync
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
3. Run haxe.rust validation plus this repo's gates.
4. Update `reference/haxe-rust.pin.json` only after the gates pass.
5. Record patches, gaps, and follow-up work in Beads and `reference/`.

Current known haxe.rust pressure points are tracked under the `HXCX-7.x` Beads epic.

## Profile Approach

Use `metal` now where codexhx needs Rust-native runtime/tool behavior, stricter host-boundary semantics, or production-shaped performance. Keep `portable` for DTOs, codecs, fixtures, schema/protocol validation, config, and pure state. At the compiler level, haxe.rust portable output should converge toward metal-level Rust performance wherever the Rust lowering can preserve Haxe semantics.

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
harness/check-doctor-json.sh
harness/check-protocol-ids.sh
harness/check-json-boundary.sh
harness/check-config-profile.sh
scripts/check-generated-cargo.sh
jq empty reference/*.json
```

The gates are credential-free. They should not make model calls or mutate real Codex state.

Testing policy is documented in `docs/testing-strategy.md`. In short: Haxe-authored tests compiled through haxe.rust are the primary codexhx proof; upstream Codex schemas/tests/fixtures are contract inputs and oracle evidence; differential tests should compare public behavior as runtime parity grows.

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

This repo uses Beads for issue tracking. The authoritative issue JSON lives in `.beads/issues.jsonl`; local database/runtime files are ignored by `.beads/.gitignore`.

Run:

```bash
bd onboard
bd ready
```

Before ending a session, follow `AGENTS.md`: file follow-ups, run gates, update Beads, `bd sync`, commit, push, and verify the branch is up to date with origin.
