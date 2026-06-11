# haxe.rust Vendoring And Upstream Policy

**Date:** 2026-06-10  
**Bead:** `HXCX-0.6` / `codex-hxrust-r46.6`  
**Decision:** Use `../haxe.rust` as a sibling compiler repository and record known-good consumer commits in this repo. Do not vendor or submodule haxe.rust unless a later reproducibility decision explicitly changes this.

## Current Pin

Source: `reference/haxe-rust.pin.json`

| Field | Value |
| --- | --- |
| Local path | `../haxe.rust` |
| Remote | `git@github.com:fullofcaffeine/reflaxe.rust.git` |
| Branch | `main` |
| Commit | `1f91e9e67f5fc04eca1806aa04e2cd50c2b2033d` |
| Package | `reflaxe.rust` `1.0.0` |
| License | `GPL-3.0` |

The current checkout is the compiler/runtime backend for the experiment, not source owned by `codex-hxrust`. Compiler fixes are made directly in `../haxe.rust`; this repo records the pin and pressure-test mapping.

Current local patch record: `reference/haxe-rust-local-patches.v1.json`.

Latest audit note: `reference/haxe-rust-audit-2026-06-10.md`.

## Options Compared

| Option | Pros | Cons | Decision |
| --- | --- | --- | --- |
| External pinned checkout at `../haxe.rust` | Fastest iteration, clean upstream merge path, no nested git complexity, easy to inspect local compiler work | CI must provision the checkout; a missing path breaks local builds until doctor explains it | Use now |
| Git submodule under `vendor/haxe.rust` | Reproducible checkout inside repo, explicit SHA in git, easier CI bootstrap | Adds submodule workflow friction; users must init/update; still depends on remote access | Consider after G1 if CI/local setup pain appears |
| Git subtree or copied vendor tree | Single checkout with no submodule commands; can freeze a release bundle | Very noisy upstream merges; easy to accidentally edit vendored compiler; license/release review becomes more urgent | Defer; last resort |
| Package/release artifact | Cleanest consumer story if haxe.rust publishes stable artifacts | Not enough evidence yet for this experiment; harder to patch compiler during discovery | Revisit after G1/G2 |

## Recommended Flow

1. Keep `reference/haxe-rust.pin.json` as the pin of record.
2. In G1, the scaffold doctor must read the pin and verify that `../haxe.rust` exists at the expected commit.
3. Generated builds should use a path reference to `../haxe.rust` during local development.
4. Work directly in `../haxe.rust` for compiler/runtime fixes; keep those fixes generic and commit/push that repository directly.
5. After haxe.rust gates pass, update this repo's pin and rerun codex-hxrust gates.
6. CI can clone/check out haxe.rust beside this repo using the pin JSON.
7. Do not subtree/copy haxe.rust unless we need an offline/frozen release artifact and have completed license review.

## Upstream Audit Cadence

Run an audit before changing the pin, and at least weekly while active compiler work is happening. During active HXCX milestone work, also run it whenever haxe.rust limitations are discovered or a local haxe.rust patch is restored/changed.

Scripted audit:

```bash
scripts/audit-haxe-rust.sh
```

Suggested manual audit:

```bash
PIN="$(jq -r .commit reference/haxe-rust.pin.json)"
git -C ../haxe.rust fetch origin main
git -C ../haxe.rust log --oneline "${PIN}..origin/main"
git -C ../haxe.rust diff --stat "${PIN}..origin/main"
```

If the log is empty, record a no-op audit note in the active bead. If new commits exist, classify them:

- docs/test-only
- portable codegen/runtime affecting
- metal/async/native interop affecting
- Cargo/dependency/toolchain affecting
- license/distribution affecting

Runtime-affecting or dependency-affecting updates require fixture/build validation before accepting a new pin.

## Pin Update Gate

Do not update `reference/haxe-rust.pin.json` unless these checks pass:

1. Scaffold doctor reports the old pin, candidate pin, Haxe version, Rust version, and haxe.rust profile.
2. Portable haxe.rust build/check for `codex-hxrust` passes.
3. Metal haxe.rust build/check for native-boundary modules passes, once metal exists.
4. Generated Cargo check runs with `--locked`.
5. G2 upstream DTO/schema fixtures pass, once G2 exists.
6. G3 headless runtime fixtures pass, once G3 exists.
7. G5 Cafex adapter fixtures pass for runtime-affecting haxe.rust changes, once G5 exists.

Before G1 exists, a pin update is allowed only for a blocking compiler bug or agreed bootstrap correction, and the bead must record why normal gates were unavailable.

In G1 and later, update through:

```bash
scripts/update-haxe-rust-pin.sh <candidate-sha>
```

The updater runs `scripts/check-generated-cargo.sh` before editing the pin and resyncs the Haxe doctor mirror at `src/codexhx/HaxeRustPin.hx`.

## Future Tooling Shape

`HXCX-1.6` should add a command equivalent to:

```bash
codex-hxrust doctor --json
codex-hxrust hxrust audit --pin reference/haxe-rust.pin.json
codex-hxrust hxrust update-pin --candidate <sha>
```

The audit command should print:

- current pin
- local checkout branch/commit/dirty state
- remote commits since pin
- changed haxe.rust areas
- recommended gate subset
- exact commands to run before accepting the candidate pin

## License Note

haxe.rust package metadata reports `GPL-3.0`; upstream Codex/Cafex are `Apache-2.0`. The experiment can use an external local compiler checkout for development, but distribution of generated artifacts, bundled runtime code, or vendored haxe.rust must be reviewed before release.
