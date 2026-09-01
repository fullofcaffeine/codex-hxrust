# haxe.rust Upstream Repros

**Date:** 2026-06-11
**Reconciled:** 2026-08-31
**Bead:** `HXCX-7.2` / `codex-hxrust-rat.2`

## Purpose

This record links each active pressure gap to one generic haxe.rust fixture.
One output-quality defect remains active. Issue `haxe_rust-4tc8` owns its
framework-neutral snapshot fix. The fixture has no Codex, Cafetera, Cafex,
credential, or local-path dependency.

Machine-readable fixture:

`reference/haxe-rust-upstream-repros.v1.json`

Validation gate:

```bash
harness/check-haxe-rust-upstream-repros.sh
```

## Repro Map

| Gap | haxe.rust bead | Fixture | Current result |
| --- | --- | --- | --- |
| Guarded nullable scalar switch narrowing | `haxe_rust-4tc8` | `test/snapshot/nullable_scalar_switch_narrowing` | [PR #18](https://github.com/fullofcaffeine/reflaxe.rust/pull/18) at `83333c9664d13f4d69a56bb6e44331e69cc74bd8` |

Resolved upstream:

- Nullable interface null values (`haxe.rust-bm6`) moved to the passing
  `../haxe.rust/test/snapshot/nullable_interface_null` snapshot in
  `b3e38c31`.
- `String.lastIndexOf` lowering (`haxe.rust-7s4`) moved to the passing
  `../haxe.rust/test/snapshot/string_last_index_of` snapshot in `916f1534`.
- `haxe.io.Path.directory` lowering (`haxe.rust-lj8`) moved to the passing
  `../haxe.rust/test/snapshot/path_directory` snapshot in `39f20b9e`.

The haxe.rust runner is:

```bash
cd ../haxe.rust
bash scripts/ci/check-upstream-open-gap-repros.sh
```

It currently expects no Cargo build failures. The active defect produces valid
Rust with a dead throw, so its fix uses a snapshot instead. The consumer gate
derives required mappings from active pressure gaps. It rejects an empty repro
list while an active gap exists. When a new compiler gap appears, add one
framework-neutral reproducer before consumer work continues.

## Scope Rules

- Keep compiler fixes generic to haxe.rust; no codexhx-specific compiler code.
- Keep Codex/Cafetera/Cafex context in codex-hxrust ledgers, not in haxe.rust fixture source.
- Keep local codexhx workarounds only until each haxe.rust bead closes or the gap is explicitly accepted.
- Treat the current Cargo runner as one part of the contract. Snapshot fixes in review must include an exact PR and commit.
