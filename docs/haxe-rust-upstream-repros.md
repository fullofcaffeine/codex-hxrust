# haxe.rust Upstream Repros

**Date:** 2026-06-11
**Bead:** `HXCX-7.2` / `codex-hxrust-rat.2`

## Purpose

This record closes the loop from the HXCX-7.1 pressure-gap ledger to generic
haxe.rust fixtures. The remaining compiler gap has a minimal, standalone Haxe
inputs in `../haxe.rust` that can run without Codex, Cafetera, Cafex,
credentials, or local paths.

Machine-readable fixture:

`reference/haxe-rust-upstream-repros.v1.json`

Validation gate:

```bash
cd experiments/codex-hxrust
harness/check-haxe-rust-upstream-repros.sh
```

## Repro Map

| Gap | haxe.rust bead | Fixture | Current result |
| --- | --- | --- | --- |
| `haxe.io.Path.directory` lowering | `haxe.rust-lj8` | `../haxe.rust/test/repro/upstream_open_gaps/path_directory` | expected Cargo failure |

Resolved upstream:

- Nullable interface null values (`haxe.rust-bm6`) moved to the passing
  `../haxe.rust/test/snapshot/nullable_interface_null` snapshot in
  `b3e38c31`.
- `String.lastIndexOf` lowering (`haxe.rust-7s4`) moved to the passing
  `../haxe.rust/test/snapshot/string_last_index_of` snapshot in `916f1534`.

The haxe.rust runner is:

```bash
cd ../haxe.rust
bash scripts/ci/check-upstream-open-gap-repros.sh
```

It currently expects one Rust build failure and checks its signature.
When a compiler fix lands, the corresponding repro should move into a passing
snapshot or semantic-diff case and the linked haxe.rust bead can close.

## Scope Rules

- Keep compiler fixes generic to haxe.rust; no codexhx-specific compiler code.
- Keep Codex/Cafetera/Cafex context in codex-hxrust ledgers, not in haxe.rust fixture source.
- Keep local codexhx workarounds until each haxe.rust bead closes or the gap is explicitly accepted.
- Treat the current expected-failure runner as a backlog contract, not as production readiness proof.
