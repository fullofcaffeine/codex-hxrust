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
| Commit | Read from `reference/haxe-rust.pin.json` |
| Package | `reflaxe.rust` `1.0.0` |
| License | `GPL-3.0` |

The sibling repository owns the compiler and runtime backend. codex-hxrust records the admitted pin and the pressure-test mapping.

The pin records the admitted compiler commit.
Set `HAXE_RUST_ROOT` to select the checkout for a generated build.
`scripts/run-haxe-rust.sh` supplies all source, standard-library, and Reflaxe paths from that checkout.
It also reports the actual commit and dirty-file count.

The scoped library file remains available for legacy local commands. Reproducibility gates and pin admission do not use its fixed sibling paths.

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
2. The doctor reports the admitted pin and the actual compiler identity that produced it.
3. Generated gates use `HAXE_RUST_ROOT` and `scripts/run-haxe-rust.sh`.
4. Develop generic compiler fixes in isolated haxe.rust worktrees from fetched `origin/main`.
5. Land each compiler fix through a reviewed haxe.rust pull request.
6. Test the exact merged commit through a clean integration worktree.
7. Update this repository's pin in a separate change after the original consumer tracer passes.
8. CI can clone haxe.rust beside this repo by using the exact pin JSON commit.
9. Do not copy or add haxe.rust as a subtree unless an offline release requires it and license review is complete.

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

Do not update `reference/haxe-rust.pin.json` unless the candidate meets these identity checks:

1. The candidate equals the clean integration checkout `HEAD`.
2. The integration checkout uses the expected remote.
3. The candidate is reachable from fetched haxe.rust `origin/main`.
4. The matching haxe.rust pull request is merged.
5. The original consumer tracer passes against that exact checkout.

Then run these product checks:

1. Scaffold doctor reports the old pin, candidate pin, Haxe version, Rust version, and haxe.rust profile.
2. The portable haxe.rust build for codex-hxrust passes.
3. The metal build for affected native-boundary modules passes.
4. Generated Cargo checks and tests use `--locked`.
5. Generated Rust passes rustfmt and haxe.rust's curated Clippy contract.
6. A reviewer inspects the affected generated modules.
7. Affected upstream DTO, runtime, TUI, and adapter fixtures pass.

Before G1 exists, a pin update is allowed only for a blocking compiler bug or agreed bootstrap correction, and the bead must record why normal gates were unavailable.

In G1 and later, update through:

```bash
scripts/update-haxe-rust-pin.sh <candidate-sha>
```

The updater runs `scripts/check-generated-cargo.sh` before editing the pin and resyncs the Haxe doctor mirror at `src/codexhx/HaxeRustPin.hx`.

The updater enforces the identity checks before it starts the generated Cargo gate.

See [the haxe.rust pull-request workflow](haxe-rust-direct-workflow.md) for the complete consumer lifecycle.

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
