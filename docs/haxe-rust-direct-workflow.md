# haxe.rust Direct Work Workflow

**Date:** 2026-06-10  
**Decision:** Keep `../haxe.rust` as the authoritative compiler repository and use `codex-hxrust` as a production pressure-test consumer.

## Repository Rule

`haxe.rust` stays at `../haxe.rust`. Do not move, copy, vendor, or submodule it into this repo unless a later reproducibility decision explicitly changes that.

`reference/haxe-rust.pin.json` records the known-good compiler commit for this experiment. It is not an upstream merge queue. When compiler work is needed, work directly in `../haxe.rust`, commit and push there, then update the pin here after validation.

## Local Dependency Resolution

Use lix scoped libraries for day-to-day local Haxe builds in this repo:

- `.haxerc` pins Haxe `4.3.7` and enables scoped library resolution.
- `haxe_libraries/reflaxe.rust.hxml` points `-lib reflaxe.rust` at `../haxe.rust/src` and `../haxe.rust/std`.
- `haxe_libraries/reflaxe.hxml` points `-lib reflaxe` at `../haxe.rust/vendor/reflaxe/src`.

This avoids global `haxelib dev` drift while keeping `../haxe.rust` as the authoritative compiler checkout. Do not treat lix as a substitute for haxelib release validation: haxe.rust package/dev-haxelib smoke gates still need to pass for compiler changes because published consumers resolve through haxelib.

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

- `codex-hxrust-rat.5` maps to haxe.rust CallStack milestone history (`haxe.rust-oo3.60`, `haxe.rust-oo3.61`, `haxe.rust-oo3.66`) and is resolved by the pinned haxe.rust dev-haxelib std ownership fix.
- `codex-hxrust-rat.6` maps to haxe.rust Cargo handoff regression `haxe.rust-oo3.67` and is resolved by the pinned Cargo failure propagation fix.
- `codex-hxrust-rat.7` maps to haxe.rust nullable scalar regression coverage `haxe.rust-oo3.68` and is resolved by the pinned `nullable_scalar_charcode` snapshot.
- `codex-hxrust-rat.8` maps to haxe.rust generic enum regression `haxe.rust-oo3.69` and is resolved by the pinned `generic_enum_payload` snapshot.
- `codex-hxrust-rat.9` maps to haxe.rust enum reuse regression `haxe.rust-oo3.71` and is resolved by the pinned `enum_reuse_helper_calls` snapshot.

## Validation Expectations

haxe.rust work follows `../haxe.rust/AGENTS.md`: contract-first tests, root-cause compiler/runtime fixes, no temporary workarounds, and `thinking:*` labels on active Beads.

codex-hxrust pin updates must run the affected fixture gates plus `experiments/codex-hxrust/scripts/check-generated-cargo.sh` before commit.
