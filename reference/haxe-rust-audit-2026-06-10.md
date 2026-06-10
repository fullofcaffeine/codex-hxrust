# haxe.rust Audit 2026-06-10

**Pin before audit:** `6ab013d80c38ad821a6645aa0cfada8d3f068020`  
**Pin after audit:** `ba76e4861b0b3a30e8f572cc2bd159e0e004973e`  
**Remote:** `git@github.com:fullofcaffeine/reflaxe.rust.git`  
**Branch:** `main`

## Upstream Commits Accepted

- `a9d28df8` Clarify async constructor contract diagnostic
- `5a218a9b` Refresh Lambda count docs
- `ba76e486` Restore CallStack exception formatting

## Classified Areas

- portable codegen/runtime
- metal/async/native interop
- cargo/dependency/toolchain

## Gates Run

```bash
experiments/codex-hxrust/scripts/update-haxe-rust-pin.sh 5a218a9b585b833f02c792097cd0e5204d1a9d1c
experiments/codex-hxrust/scripts/update-haxe-rust-pin.sh ba76e4861b0b3a30e8f572cc2bd159e0e004973e
```

Each successful updater run executed:

```bash
experiments/codex-hxrust/scripts/check-generated-cargo.sh
```

That regenerated portable and metal crates, then ran `cargo check --locked` and `cargo test --locked` for each generated crate.

## Local Patch Status

`../haxe.rust/std/haxe/CallStack.cross.hx` remains locally modified by the scaffold workaround recorded in `reference/haxe-rust-local-patches.v1.json`.

The first attempted update failed before the workaround was reapplied, proving the pin updater correctly refuses to advance when generated locked Cargo gates fail.

## Deferred Gates

G2 DTO/schema fixtures, G3 headless runtime fixtures, and G5 Cafex adapter fixtures do not exist yet. Future runtime-affecting haxe.rust pin updates must route through those gates once available.

## Follow-Up Audit Later On 2026-06-10

**Pin before audit:** `ba76e4861b0b3a30e8f572cc2bd159e0e004973e`  
**Pin after audit:** `1f91e9e67f5fc04eca1806aa04e2cd50c2b2033d`

Additional upstream commits accepted:

- `d04f63f3` Record CallStack worktree restoration
- `bb0af8d2` Polish first-project onboarding docs
- `e739a13f` Polish generated app README
- `76b63b07` Guard tracked generated artifacts
- `1f91e9e6` Add hello example README

Classified area from `experiments/codex-hxrust/scripts/audit-haxe-rust.sh`:

- cargo/dependency/toolchain

Gate run:

```bash
experiments/codex-hxrust/scripts/update-haxe-rust-pin.sh 1f91e9e67f5fc04eca1806aa04e2cd50c2b2033d
```

The updater first failed while the local `CallStack.cross.hx` workaround was absent, then passed after restoring the recorded local patch. The successful updater run executed `experiments/codex-hxrust/scripts/check-generated-cargo.sh`, regenerating portable and metal crates and running locked `cargo check`/`cargo test` for each.

## Follow-Up Audit After haxe.rust Direct Fix On 2026-06-10

**Pin before audit:** `1f91e9e67f5fc04eca1806aa04e2cd50c2b2033d`  
**Pin after audit:** `0849fcf1a556cb86615cfcdf635165ba82fec8da`

Additional upstream commits accepted:

- `765b6487` Fix dev haxelib std ownership
- `0849fcf1` Format std ArrayTools

The CallStack workaround recorded in `reference/haxe-rust-local-patches.v1.json` is now resolved upstream. The fix keeps `std/haxe/CallStack.cross.hx` typed as `Exception`, mirrors haxe.rust std top-level entries under `src/` for dev haxelib consumers, and adds haxe.rust package-smoke coverage for both packaged and dev checkout flows.

Gate run:

```bash
experiments/codex-hxrust/scripts/update-haxe-rust-pin.sh 0849fcf1a556cb86615cfcdf635165ba82fec8da
```

The updater executed `experiments/codex-hxrust/scripts/check-generated-cargo.sh`, regenerating portable and metal crates and running locked `cargo check`/`cargo test` for each.

## Follow-Up Audit After Cargo Failure Propagation Fix On 2026-06-10

**Pin before audit:** `0849fcf1a556cb86615cfcdf635165ba82fec8da`  
**Pin after audit:** `bc945b3263e24f95c3b99d86e87dc281e0b713b2`

Additional upstream commit accepted:

- `bc945b32` Propagate Cargo failures from Haxe builds

This resolves the codex-hxrust pressure gap where a generated Cargo failure could be printed while the parent `haxe` process still exited successfully. haxe.rust now reports a compiler error when the configured Cargo command returns non-zero, and haxe.rust carries a generic cargo-failure propagation regression in its CI harness.

Gate run:

```bash
experiments/codex-hxrust/scripts/update-haxe-rust-pin.sh bc945b3263e24f95c3b99d86e87dc281e0b713b2
```

The updater executed `experiments/codex-hxrust/scripts/check-generated-cargo.sh`, regenerating portable and metal crates and running locked `cargo check`/`cargo test` for each.

## Follow-Up Audit After Nullable Scalar Regression Coverage On 2026-06-10

**Pin before audit:** `bc945b3263e24f95c3b99d86e87dc281e0b713b2`
**Pin after audit:** `729599493d350bc8d926b61890eb320acf155b6b`

Additional upstream commit accepted:

- `72959949` Add nullable scalar charCode snapshot

This resolves the codex-hxrust pressure gap for `Null<Int>` stringification/comparisons and `String.charCodeAt` comparisons by pinning generic haxe.rust regression coverage. The compiler already emits `Some(...)` comparisons for nullable scalar values and routes nullable scalar stringification through `Dynamic::to_haxe_string()`.

Gate run:

```bash
experiments/codex-hxrust/scripts/update-haxe-rust-pin.sh 729599493d350bc8d926b61890eb320acf155b6b
```

The updater executed `experiments/codex-hxrust/scripts/check-generated-cargo.sh`, regenerating portable and metal crates and running locked `cargo check`/`cargo test` for each.
