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
scripts/update-haxe-rust-pin.sh 5a218a9b585b833f02c792097cd0e5204d1a9d1c
scripts/update-haxe-rust-pin.sh ba76e4861b0b3a30e8f572cc2bd159e0e004973e
```

Each successful updater run executed:

```bash
scripts/check-generated-cargo.sh
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

Classified area from `scripts/audit-haxe-rust.sh`:

- cargo/dependency/toolchain

Gate run:

```bash
scripts/update-haxe-rust-pin.sh 1f91e9e67f5fc04eca1806aa04e2cd50c2b2033d
```

The updater first failed while the local `CallStack.cross.hx` workaround was absent, then passed after restoring the recorded local patch. The successful updater run executed `scripts/check-generated-cargo.sh`, regenerating portable and metal crates and running locked `cargo check`/`cargo test` for each.

## Follow-Up Audit After haxe.rust Direct Fix On 2026-06-10

**Pin before audit:** `1f91e9e67f5fc04eca1806aa04e2cd50c2b2033d`  
**Pin after audit:** `0849fcf1a556cb86615cfcdf635165ba82fec8da`

Additional upstream commits accepted:

- `765b6487` Fix dev haxelib std ownership
- `0849fcf1` Format std ArrayTools

The CallStack workaround recorded in `reference/haxe-rust-local-patches.v1.json` is now resolved upstream. The fix keeps `std/haxe/CallStack.cross.hx` typed as `Exception`, mirrors haxe.rust std top-level entries under `src/` for dev haxelib consumers, and adds haxe.rust package-smoke coverage for both packaged and dev checkout flows.

Gate run:

```bash
scripts/update-haxe-rust-pin.sh 0849fcf1a556cb86615cfcdf635165ba82fec8da
```

The updater executed `scripts/check-generated-cargo.sh`, regenerating portable and metal crates and running locked `cargo check`/`cargo test` for each.

## Follow-Up Audit After Enum Reuse Helper Call Fix On 2026-06-10

**Pin before audit:** `0b2f196e2b3e8742efe79febe002e97f0924802d`

**Pin after audit:** `1a394f41a1ee019350faee6d592d21d2c5dc20bd`

Additional upstream commit accepted:

- `1a394f41` Fix enum value reuse across helper calls

This resolves the codex-hxrust pressure gap where a parsed JSON-like enum value could be moved by the first helper call and become unusable for a second helper call. haxe.rust now treats Haxe enum values as reusable cloneable values and clones reusable enum locals for typed by-value helper calls, with an `enum_reuse_helper_calls` snapshot.

Gate run:

```bash
scripts/update-haxe-rust-pin.sh 1a394f41a1ee019350faee6d592d21d2c5dc20bd
```

The updater executed `scripts/check-generated-cargo.sh`, regenerating portable and metal crates and running locked `cargo check`/`cargo test` for each.

## Follow-Up Audit After Try/Catch Tail Return Fix On 2026-06-10

**Pin before audit:** `1a394f41a1ee019350faee6d592d21d2c5dc20bd`

**Pin after audit:** `551a00bf08cdaecf3b8b3c499b1d80c86506fa81`

Additional upstream commit accepted:

- `551a00bf` Fix try catch tail return lowering

This resolves the codex-hxrust mock model stream parser pressure gap where a non-Void helper with a top-level `try/catch` and return-value branches lowered to a Rust `match` statement with a trailing semicolon. haxe.rust now recognizes a final top-level `try/catch` typed as `Void` by Haxe as a valid tail expression for non-Void function bodies, with a `try_catch_tail_nonvoid` snapshot. codex-hxrust removed the local `parseJson` assignment workaround and now uses direct `try/catch` returns.

Gate runs:

```bash
scripts/update-haxe-rust-pin.sh 551a00bf08cdaecf3b8b3c499b1d80c86506fa81
harness/check-mock-model-stream.sh
```

The updater executed `scripts/check-generated-cargo.sh`, regenerating portable and metal crates and running locked `cargo check`/`cargo test` for each. The mock model stream harness also passed through Haxe interp, haxe.rust generation, and generated Cargo `check`/`test`/`run`.

## Follow-Up Audit After Interface Null Comparison Fix On 2026-06-10

**Pin before audit:** `551a00bf08cdaecf3b8b3c499b1d80c86506fa81`

**Pin after audit:** `e10eae4d197a2ff7d1518536db9aaa4f76d4e9e4`

Additional upstream commit accepted:

- `e10eae4d` Fix interface null comparison lowering

This resolves the codex-hxrust pressure gap where comparing a non-null interface/trait-object value against `null` could lower to generic pointer equality against an untyped `Default::default()`. haxe.rust now lowers interface/polymorphic null-literal comparisons by evaluating the non-null side and returning the correct constant result, with an `interface_null_compare` snapshot and stdout proof.

Related gap resolved later:

- `haxe.rust-bm6` tracked the broader nullable interface value contract after this audit. It was resolved later by haxe.rust `b3e38c31`, which moved the generic nullable interface fixture to a passing snapshot and allowed codex-hxrust to mark nullable interface values as resolved upstream.

Gate runs:

```bash
scripts/update-haxe-rust-pin.sh e10eae4d197a2ff7d1518536db9aaa4f76d4e9e4
harness/check-mock-model-stream.sh
```

The updater executed `scripts/check-generated-cargo.sh`, regenerating portable and metal crates and running locked `cargo check`/`cargo test` for each. The mock model stream harness passed on the supported non-null model client boundary.

## Follow-Up Audit After Cargo Failure Propagation Fix On 2026-06-10

**Pin before audit:** `0849fcf1a556cb86615cfcdf635165ba82fec8da`  
**Pin after audit:** `bc945b3263e24f95c3b99d86e87dc281e0b713b2`

Additional upstream commit accepted:

- `bc945b32` Propagate Cargo failures from Haxe builds

This resolves the codex-hxrust pressure gap where a generated Cargo failure could be printed while the parent `haxe` process still exited successfully. haxe.rust now reports a compiler error when the configured Cargo command returns non-zero, and haxe.rust carries a generic cargo-failure propagation regression in its CI harness.

Gate run:

```bash
scripts/update-haxe-rust-pin.sh bc945b3263e24f95c3b99d86e87dc281e0b713b2
```

The updater executed `scripts/check-generated-cargo.sh`, regenerating portable and metal crates and running locked `cargo check`/`cargo test` for each.

## Follow-Up Audit After Nullable Scalar Regression Coverage On 2026-06-10

**Pin before audit:** `bc945b3263e24f95c3b99d86e87dc281e0b713b2`

**Pin after audit:** `729599493d350bc8d926b61890eb320acf155b6b`

Additional upstream commit accepted:

- `72959949` Add nullable scalar charCode snapshot

This resolves the codex-hxrust pressure gap for `Null<Int>` stringification/comparisons and `String.charCodeAt` comparisons by pinning generic haxe.rust regression coverage. The compiler already emits `Some(...)` comparisons for nullable scalar values and routes nullable scalar stringification through `Dynamic::to_haxe_string()`.

Gate run:

```bash
scripts/update-haxe-rust-pin.sh 729599493d350bc8d926b61890eb320acf155b6b
```

The updater executed `scripts/check-generated-cargo.sh`, regenerating portable and metal crates and running locked `cargo check`/`cargo test` for each.

## Follow-Up Audit After Profile Language Clarification On 2026-06-10

**Pin before audit:** `729599493d350bc8d926b61890eb320acf155b6b`

**Pin after audit:** `6a673bb43624a0d4327fa6709fb24f7e971dd121`

Additional upstream commit accepted:

- `6a673bb4` Document idiomatic as cross-profile quality goal

This docs-only haxe.rust update clarifies that `portable|metal` are semantic contracts, while "idiomatic" is the generated-Rust quality goal across both contracts. codex-hxrust mirrors that policy in `AGENTS.md`, build-profile policy, and baseline topology docs.

Gate run:

```bash
scripts/update-haxe-rust-pin.sh 6a673bb43624a0d4327fa6709fb24f7e971dd121
```

The updater executed `scripts/check-generated-cargo.sh`, regenerating portable and metal crates and running locked `cargo check`/`cargo test` for each.

## Follow-Up Audit After Generic Enum Payload Fix On 2026-06-10

**Pin before audit:** `6a673bb43624a0d4327fa6709fb24f7e971dd121`

**Pin after audit:** `f521fdb242a7de5f2194633deef6caa3392bafe9`

Additional upstream commit accepted:

- `f521fdb2` Fix generic enum payload codegen

This resolves the codex-hxrust pressure gap where generic Haxe enum payloads such as `IdParseResult<T>` could emit Rust with unbound type parameters. haxe.rust now threads enum type parameters through Rust enum declarations and `TEnum` use-site type rendering, with a generic `generic_enum_payload` snapshot.

Gate run:

```bash
scripts/update-haxe-rust-pin.sh f521fdb242a7de5f2194633deef6caa3392bafe9
```

The updater executed `scripts/check-generated-cargo.sh`, regenerating portable and metal crates and running locked `cargo check`/`cargo test` for each. The protocol ID harness also passed against the new pin.

## Follow-Up Audit After Portable-First Profile Framing On 2026-06-10

**Pin before audit:** `f521fdb242a7de5f2194633deef6caa3392bafe9`

**Pin after audit:** `0b2f196e2b3e8742efe79febe002e97f0924802d`

Additional upstream commit accepted:

- `0b2f196e` Clarify portable-first profile framing

This docs-only haxe.rust update aligns Rust profile wording with the family framing: portable by default, Rust-native by opt-in, and metal-like performance whenever the compiler can prove Haxe semantics are preserved. codex-hxrust mirrors that policy in `AGENTS.md`, build-profile policy, and baseline topology docs.

Gate run:

```bash
scripts/update-haxe-rust-pin.sh 0b2f196e2b3e8742efe79febe002e97f0924802d
```

The updater executed `scripts/check-generated-cargo.sh`, regenerating portable and metal crates and running locked `cargo check`/`cargo test` for each.
