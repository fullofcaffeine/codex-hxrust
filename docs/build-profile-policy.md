# Build Profile Policy

**Date:** 2026-06-10  
**Bead:** `HXCX-1.2` / `codex-hxrust-wx3.2`  
**Decision:** Keep separate haxe.rust profiles for code generation and build validation.

## Profiles

| Profile | HXML | haxe.rust contract | Cargo behavior | Output |
| --- | --- | --- | --- | --- |
| Portable codegen | `experiments/codex-hxrust/hxml/portable.codegen.hxml` | `portable` | `rust_no_build` | `generated/portable` |
| Portable check | `experiments/codex-hxrust/hxml/portable.hxml` | `portable` | `rust_cargo_subcommand=check` | `generated/portable` |
| Metal codegen | `experiments/codex-hxrust/hxml/metal.codegen.hxml` | `metal` with explicit fallback allowed during scaffold | `rust_no_build` | `generated/metal` |
| Metal check | `experiments/codex-hxrust/hxml/metal.hxml` | `metal` with explicit fallback allowed during scaffold | `rust_cargo_subcommand=check` | `generated/metal` |

## Policy

1. `portable` is the default contract for DTOs, schema fingerprints, config, fixtures, and pure state transitions.
2. `metal` is reserved for runtime shell and native-boundary experiments.
3. Codegen-only profiles are for fast local feedback and deterministic generated-output inspection.
4. Check profiles are the first build gate and must succeed before DTO/runtime work is considered active.
5. Locked Cargo checks/tests are run by `experiments/codex-hxrust/scripts/check-generated-cargo.sh`.
6. Generated output remains build output and is ignored by `experiments/codex-hxrust/generated/.gitignore`.

## Scaffold Caveat

The temporary G1 `Main` is intentionally a no-op. Earlier trace/print smoke output pulled in the generated CallStack helper, which currently references a root `Exception` type when this project builds outside the haxe.rust example tree. `HXCX-1.5` owns clean doctor JSON output and should either use a known-good haxe.rust output path or document/file the upstream compiler fix.

## Commands

From `experiments/codex-hxrust/`:

```bash
haxe hxml/portable.codegen.hxml
haxe hxml/portable.hxml
haxe hxml/metal.codegen.hxml
haxe hxml/metal.hxml
scripts/check-generated-cargo.sh
```

Clean generated output after local validation unless a later bead explicitly asks for generated snapshots.
