# haxe.rust Audit Tooling

**Date:** 2026-06-10  
**Bead:** `HXCX-1.6` / `codex-hxrust-wx3.6`  
**Source refs:** `codex-hxrust-port-plan.md`, `../haxe.rust/docs/workflow.md`  
**Decision:** Work directly in the sibling `../haxe.rust` compiler repo, then use scriptable pin audit/update commands before accepting that compiler commit as the codex-hxrust known-good pin.

## Commands

Audit upstream drift:

```bash
experiments/codex-hxrust/scripts/audit-haxe-rust.sh
```

Skip network fetch and report from the local remote-tracking branch:

```bash
experiments/codex-hxrust/scripts/audit-haxe-rust.sh --no-fetch
```

Update the codex-hxrust known-good pin only through the gated updater:

```bash
experiments/codex-hxrust/scripts/update-haxe-rust-pin.sh <candidate-sha>
```

Resync the Haxe doctor mirror from the pin JSON:

```bash
experiments/codex-hxrust/scripts/sync-haxe-rust-pin-hx.sh
```

## Pin Surfaces

`reference/haxe-rust.pin.json` is the codex-hxrust known-good consumer pin. The source of truth for compiler code and compiler Beads is `../haxe.rust`. `experiments/codex-hxrust/src/codexhx/HaxeRustPin.hx` is a scaffold mirror used by doctor output so generated binaries can report the compiler/runtime pin without parsing local files.

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

`update-haxe-rust-pin.sh` verifies that the candidate SHA exists in `../haxe.rust`, then runs:

```bash
experiments/codex-hxrust/scripts/check-generated-cargo.sh
```

Only after the locked generated Cargo gate passes does it update `reference/haxe-rust.pin.json` and regenerate `HaxeRustPin.hx`.

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
