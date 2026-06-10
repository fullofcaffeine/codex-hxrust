# Generated Cargo CI Gates

**Date:** 2026-06-10  
**Bead:** `HXCX-1.3` / `codex-hxrust-wx3.3`  
**Decision:** Validate generated Rust crates with locked Cargo checks and tests.

## Command

From the repository root:

```bash
experiments/codex-hxrust/scripts/check-generated-cargo.sh
```

The script is intentionally local-CI friendly:

1. It changes into `experiments/codex-hxrust/`.
2. It removes each generated crate directory before rebuilding.
3. It runs the profile hxml, which invokes haxe.rust and its first `cargo check`.
4. It verifies that `Cargo.toml` and `Cargo.lock` exist.
5. It runs `cargo check --locked`.
6. It runs `cargo test --locked`.

The current profiles are:

| Profile | HXML | Generated crate |
| --- | --- | --- |
| Portable | `hxml/portable.hxml` | `generated/portable` |
| Metal | `hxml/metal.hxml` | `generated/metal` |

## Credentials

This gate must not require model credentials. The current scaffold entrypoint is a no-op and the script does not read OpenAI, Codex, or Cafex environment variables. Runtime credential handling belongs to later headless runtime beads, not to the compiler gate.

## rustfmt And clippy

`cargo fmt --check` and `cargo clippy --locked` are advisory for G1 rather than required gates. Generated Rust is not authored source, and early haxe.rust output can surface formatter churn or lint noise that is not actionable from this repository.

Developers can opt into advisory runs with:

```bash
HXCX_RUN_FMT=1 HXCX_RUN_CLIPPY=1 experiments/codex-hxrust/scripts/check-generated-cargo.sh
```

Promote either advisory check to required CI only after the generator output is stable enough that failures identify actionable regressions in Haxe source or haxe.rust.

## Generated Output

Generated Rust remains build output. Clean `experiments/codex-hxrust/generated/portable` and `experiments/codex-hxrust/generated/metal` after local validation unless a later bead explicitly asks for generated snapshots.
