# haxe.rust Direct Work Workflow

**Date:** 2026-06-10  
**Decision:** Keep `../haxe.rust` as the authoritative compiler repository and use `codex-hxrust` as a production pressure-test consumer.

## Repository Rule

`haxe.rust` stays at `../haxe.rust`. Do not move, copy, vendor, or submodule it into this repo unless a later reproducibility decision explicitly changes that.

`reference/haxe-rust.pin.json` records the known-good compiler commit for this experiment. It is not an upstream merge queue. When compiler work is needed, work directly in `../haxe.rust`, commit and push there, then update the pin here after validation.

## Compiler Generality Rule

haxe.rust must remain a general Haxe-to-Rust compiler/runtime backend. Do not add Codex-specific code, source paths, DTO assumptions, fixture names, or behavior to haxe.rust.

When codex-hxrust exposes a compiler limitation:

1. Create or update a codex-hxrust pressure-test Bead under `HXCX-7`.
2. Create or update the corresponding haxe.rust Bead with a generic title and generic acceptance criteria.
3. Add the smallest generic haxe.rust fixture that reproduces the problem.
4. Fix the compiler/runtime root cause in haxe.rust.
5. Run haxe.rust gates, commit, and push haxe.rust.
6. Update `reference/haxe-rust.pin.json`, run codex-hxrust gates, commit, and push codex-hxrust.

## Imported Beads

`reference/haxe-rust-beads-import.v1.json` is the curated mirror of the haxe.rust Beads ledger. It imports every haxe.rust issue as compact reference metadata, while only Codex-relevant compiler pressure gaps become actionable codex-hxrust Beads.

Current actionable codex-hxrust compiler-gap Beads:

- `codex-hxrust-rat.5` maps to haxe.rust CallStack milestone history (`haxe.rust-oo3.60`, `haxe.rust-oo3.61`).
- `codex-hxrust-rat.6` needs a new generic haxe.rust fixture for Cargo failure exit propagation.
- `codex-hxrust-rat.7` needs a new generic haxe.rust fixture for nullable scalar lowering.
- `codex-hxrust-rat.8` relates to enum codegen history (`haxe.rust-oo3.5.1`) and needs a new generic enum payload fixture.
- `codex-hxrust-rat.9` needs a new generic haxe.rust fixture for enum value borrowing/reuse.

## Validation Expectations

haxe.rust work follows `../haxe.rust/AGENTS.md`: contract-first tests, root-cause compiler/runtime fixes, no temporary workarounds, and `thinking:*` labels on active Beads.

codex-hxrust pin updates must run the affected fixture gates plus `experiments/codex-hxrust/scripts/check-generated-cargo.sh` before commit.
