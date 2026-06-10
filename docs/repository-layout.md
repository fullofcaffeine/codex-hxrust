# Repository Layout Decision

**Date:** 2026-06-10  
**Bead:** `HXCX-0.5` / `codex-hxrust-r46.5`  
**Decision:** Keep `codex-hxrust` as the owner repo for the Haxe port experiment. Do not copy upstream Codex, Cafex, or haxe.rust wholesale into this repo during G0/G1.

## Base Rule

Use mainstream upstream Codex as the source-of-truth baseline, then add Cafex as an adapter/conformance layer after the upstream-shaped Haxe core exists.

Local external checkouts remain the live references:

| Source | Local path | Role |
| --- | --- | --- |
| Upstream Codex | `../codex` | Product/protocol/runtime baseline |
| Cafex/Cafetera Codex fork | `../fullofcaffeine/deps/codex` | Later adapter seams and fixture oracle |
| haxe.rust | `../haxe.rust` | Compiler/runtime backend source |

This repo records pins, manifests, fixture selections, Haxe source, harness code, and generated-output policy. It should not become a mirror of the external repositories.

## Top-Level Layout

Recommended starting layout:

```text
codex-hxrust/
  AGENTS.md
  codex-hxrust-port-prd.md
  codex-hxrust-port-plan.md
  docs/
    baseline-topology.md
    cafex-delta-classification.md
    repository-layout.md
  reference/
    README.md
    upstream-codex.pin.json
    cafex-codex.pin.json
    haxe-rust.pin.json
  vendor/
    README.md
  experiments/
    codex-hxrust/
      README.md
      hxml/
      src/codexhx/
        Main.hx
        protocol/
        config/
        runtime/
        state/
        tools/
        adapters/
          cafex/
      native/
      fixtures/
        upstream/
        cafex/
        hxrust/
      harness/
      generated/
```

Only `docs/`, `reference/`, and `vendor/README.md` are created in G0. The `experiments/codex-hxrust/` scaffold belongs to `HXCX-1.1`.

## Reference Policy

`reference/` is for small, reviewable provenance artifacts:

- pin JSON for external repos
- selected fixture indexes
- schema/source manifests
- patch-stack summaries
- upstream drift reports

It is not for copied source trees. If a later task needs a source snapshot for offline reproducibility, copy only a narrow fixture/schema subset and record the source SHA in the manifest.

## Vendor Policy

`vendor/` is intentionally empty except for `vendor/README.md` during G0/G1.

Do not vendor upstream Codex or Cafex. They are product/reference repositories, not dependencies of the Haxe compiler build.

Do not vendor haxe.rust yet. Use a local path pin to `../haxe.rust` until G1 proves the scaffold and `HXCX-0.6` chooses between:

- external pinned checkout
- git submodule
- git subtree/vendor copy
- package/release artifact

The current preference is external pinned checkout first, then submodule if reproducibility needs become painful. A subtree/vendor copy should be the last choice because it makes upstream compiler merges noisier.

## Generated Output Policy

Generated Rust is build output, not authored source.

Rules:

1. Haxe source under `experiments/codex-hxrust/src/` is authoritative.
2. Generated Rust under `experiments/codex-hxrust/generated/` may be produced locally and in CI.
3. Generated Rust should not be manually edited.
4. Generated Rust should not be committed by default unless a later bead explicitly decides to check in golden generated snapshots for review/debugging.
5. Any checked-in generated snapshot must record the haxe.rust pin, Haxe version, Rust version, hxml profile, and generation command.
6. CI should validate by regenerating and running locked Cargo checks, not by trusting stale generated output.

## Cross-Repo Fixture Paths

Initial fixture references should be path-based and pinned:

| Fixture family | Source path |
| --- | --- |
| Upstream protocol/app-server fixtures | `../codex/codex-rs/app-server-protocol/src/schema_fixtures.rs` and `../codex/codex-rs/app-server-protocol/tests/schema_fixtures.rs` |
| Upstream protocol types | `../codex/codex-rs/protocol/src/` |
| Cafex seam ledger | `../fullofcaffeine/tools/cafetera/modules/codex/tests/fixtures/cafex-fork-seam-ledger.v1.json` |
| Cafex DTO conformance | `../fullofcaffeine/tools/cafetera/modules/codex/tests/fixtures/cafex-runtime-dto-conformance.v1.json` |
| Cafex runtime patch evidence | `../fullofcaffeine/tools/cafetera/modules/codex/runtime/patches/0001-cafex-runtime-0.135.patch` |
| haxe.rust docs/evidence | `../haxe.rust/docs/` |

When a fixture is copied into this repo, place it under `experiments/codex-hxrust/fixtures/{upstream,cafex,hxrust}/` and add a manifest entry with source path, source SHA, copy date, and intended oracle.

## Brew Conversion Metadata

Future conversion tooling should record:

- source repo id, branch, commit, and dirty-state summary
- source path and logical owner
- source license and attribution note
- selected schema ids or Rust/Haxe type names
- target Haxe module path
- target haxe.rust profile (`portable` or `metal`)
- conversion mode (`manual`, `generated`, `fixture-only`, `adapter`)
- parity oracle path and expected gate
- unsupported behavior notes

This metadata should live beside generated manifests or fixture indexes, not inside copied upstream source.

## Why Not Copy Now

Copying `../codex` now would make drift management worse and would blur whether the Haxe code is following upstream Codex or a stale local snapshot.

Copying `../haxe.rust` now would turn compiler development into repo maintenance before we have a scaffold. The safer first move is to pin and audit it, then vendor only if reproducibility or CI requires it.
