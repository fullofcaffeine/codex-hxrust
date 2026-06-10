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
