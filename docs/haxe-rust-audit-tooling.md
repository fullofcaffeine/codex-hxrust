# haxe.rust Audit Tooling

**Date:** 2026-06-10  
**Bead:** `HXCX-1.6` / `codex-hxrust-wx3.6`  
**Source refs:** `codex-hxrust-port-plan.md`, `../haxe.rust/docs/workflow.md`  
**Decision:** Inspect and coordinate from `../haxe.rust`.
Develop each compiler fix in an isolated worktree and land it through a haxe.rust pull request.
Admit only an exact, clean merged commit as the codex-hxrust pin.

## Commands

Audit upstream drift:

```bash
scripts/audit-haxe-rust.sh
```

Skip network fetch and report from the local remote-tracking branch:

```bash
scripts/audit-haxe-rust.sh --no-fetch
```

Select a compiler checkout explicitly for a generated build:

```bash
HAXE_RUST_ROOT=../haxe-rust-integration-<sha> \
  scripts/run-haxe-rust.sh hxml/portable.checkout.hxml
```

The runner reports the checkout commit, dirty-file count, remote, and pin match.
It supplies all compiler class paths from that selected checkout.

Update the codex-hxrust known-good pin only through the gated updater:

```bash
scripts/update-haxe-rust-pin.sh <candidate-sha>
```

Resync the Haxe doctor mirror from the pin JSON:

```bash
scripts/sync-haxe-rust-pin-hx.sh
```

## Pin Surfaces

`reference/haxe-rust.pin.json` is the codex-hxrust known-good consumer pin.
The haxe.rust repository owns compiler code and compiler Beads.
`src/codexhx/HaxeRustPin.hx` is a scaffold mirror used by doctor output.
The generated doctor also reports the compiler commit that produced the binary.

When the pin changes, update both by running `update-haxe-rust-pin.sh`; do not hand-edit only one side.

## Audit Output

The audit command reports:

1. Pin file, pinned commit, local checkout, expected remote, actual remote.
2. Local branch, local commit, dirty entry count.
3. Remote commits since the pinned SHA.
4. Changed files since the pinned SHA.
5. Classified affected areas.
6. Required gate commands before accepting a new pin.

The affected-area classifier is conservative. Unknown changes should be treated as runtime-affecting until a human reads them.

## Update Gate

`update-haxe-rust-pin.sh` rejects a checkout with the wrong remote, local changes, or a different `HEAD`. It also requires the candidate to exist on fetched `origin/main`. It then runs:

```bash
scripts/check-generated-cargo.sh
```

The gate regenerates both profiles from the selected checkout.
It denies Rust compiler warnings and requires locked Cargo checks, tests, and formatting.
Clippy denies the correctness and suspicious groups.

Only after this gate passes does the updater change the pin and regenerate `HaxeRustPin.hx`.

## Future Fixture Routing

Once later gates exist, haxe.rust updates must also run these fixtures before the pin is accepted:

| Change class | Additional gates |
| --- | --- |
| Portable codegen/runtime | G2 upstream DTO/schema fixtures |
| Metal/async/native interop | G3 headless runtime fixtures and G4 native wrapper fixtures |
| Cargo/dependency/toolchain | G1 generated Cargo gates plus any affected G2/G3 fixtures |
| Runtime-affecting behavior | G3 headless runtime fixtures and G5 Cafex adapter fixtures once G5 exists |
| License/distribution | License review before vendoring, release, or binary distribution |

Until a fixture family exists, record the missing gate in the active bead instead of silently accepting the update.
