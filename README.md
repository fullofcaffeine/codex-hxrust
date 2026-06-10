# codex-hxrust

`codex-hxrust` is an experiment to port the headless/core parts of OpenAI Codex to pure Haxe that emits Rust through [`haxe.rust`](../haxe.rust).

The strategy is upstream-first:

1. Model the mainstream Codex protocol/runtime shape from `../codex`.
2. Prove Haxe-authored, Rust-emitted parity in small gated slices.
3. Add Cafex/Cafetera compatibility later as an adapter/conformance layer.
4. Treat haxe.rust limitations found during the port as upstreamable compiler/runtime work.

This is not a forked copy of Codex or haxe.rust. External repositories stay external and are tracked through pin files under `reference/`.

## Local Haxe Tooling

This repo uses lix-style scoped Haxe libraries for local development:

```bash
npm install
npm run hx:portable
npm run hx:metal
npm run test:generated-cargo
```

`haxe_libraries/reflaxe.rust.hxml` points at the sibling `../haxe.rust` checkout so local builds do not depend on global `haxelib dev` state. haxe.rust itself still owns haxelib package/dev-checkout smoke tests, and pin updates here must keep `experiments/codex-hxrust/scripts/check-generated-cargo.sh` green.

## Repository Status

Current completed gates:

- `HXCX-0`: inventory, topology, fixture map, repo/vendoring policy, parity scorecard
- `HXCX-1`: haxe.rust scaffold, portable/metal build profiles, locked generated Cargo gates, interop policy, doctor binary, haxe.rust audit tooling
- `HXCX-2.1`: protocol ID/newtype slice
- `HXCX-2.2`: typed JSON boundary and serde bridge facade
- `HXCX-2.3`: upstream-first config/profile DTO subset with redacted diagnostics

Next likely work:

- `HXCX-2.4`: protocol event/request/response subset
- `HXCX-7.x`: upstream haxe.rust fixes discovered by the pressure test

Use Beads for the live queue:

```bash
bd ready
bd show <issue-id>
bd update <issue-id> --status in_progress
bd close <issue-id>
bd sync
```

## External Checkouts

Expected sibling directories:

| Path | Role |
| --- | --- |
| `../codex` | Mainstream upstream Codex source of truth |
| `../fullofcaffeine/deps/codex` | Cafex/Cafetera fork used later for adapter parity |
| `../haxe.rust` | External haxe.rust compiler/runtime checkout |

Recorded pins:

| File | Purpose |
| --- | --- |
| `reference/upstream-codex.pin.json` | Upstream Codex baseline |
| `reference/cafex-codex.pin.json` | Cafex fork baseline |
| `reference/haxe-rust.pin.json` | haxe.rust backend pin |
| `reference/haxe-rust-local-patches.v1.json` | Historical local haxe.rust patch ledger; currently records the resolved CallStack workaround |

Do not vendor whole source trees into this repo unless a later Bead explicitly changes the policy.

## haxe.rust Improvement Workflow

The `../haxe.rust` checkout is part of the work surface. When the Codex port exposes a limitation:

1. Reduce it to a small haxe.rust fixture or failing example.
2. Fix it in `../haxe.rust` in an upstreamable way.
3. Run haxe.rust validation plus this repo's gates.
4. Update `reference/haxe-rust.pin.json` only after the gates pass.
5. Record patches, gaps, and follow-up work in Beads and `reference/`.

Current known haxe.rust pressure points are tracked under the `HXCX-7.x` Beads epic.

## Layout

```text
AGENTS.md                         Agent rules and session completion workflow
docs/                             Decisions, policies, topology, scorecards
reference/                        Pins, manifests, audit notes, patch records
vendor/                           Empty by policy during G0/G1
experiments/codex-hxrust/
  hxml/                           Haxe build profiles and harness hxmls
  src/                            Haxe-authored port code
  native/                         Narrow owned Rust wrapper area
  fixtures/                       Local fixture subsets and jq assertions
  harness/                        Credential-free validation scripts
  scripts/                        Build/audit/update tooling
  generated/                      haxe.rust output, ignored except README/.gitignore
```

## Build And Validation

From the repo root:

```bash
experiments/codex-hxrust/harness/check-doctor-json.sh
experiments/codex-hxrust/harness/check-protocol-ids.sh
experiments/codex-hxrust/harness/check-json-boundary.sh
experiments/codex-hxrust/harness/check-config-profile.sh
experiments/codex-hxrust/scripts/check-generated-cargo.sh
jq empty reference/*.json
```

The gates are credential-free. They should not make model calls or mutate real Codex state.

Generated Rust is build output. Clean generated crates after validation unless a Bead explicitly asks for a generated snapshot:

```bash
rm -rf experiments/codex-hxrust/generated/portable \
       experiments/codex-hxrust/generated/metal \
       experiments/codex-hxrust/generated/protocol-ids \
       experiments/codex-hxrust/generated/json-boundary \
       experiments/codex-hxrust/generated/config-profile
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
