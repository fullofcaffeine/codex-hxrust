# Build Profile Policy

**Date:** 2026-06-10  
**Bead:** `HXCX-1.2` / `codex-hxrust-wx3.2`  
**Decision:** Keep separate haxe.rust profiles for code generation and build validation.

## Profiles

| Profile | HXML | haxe.rust contract | Cargo behavior | Output |
| --- | --- | --- | --- | --- |
| Portable codegen | `hxml/portable.codegen.hxml` | `portable` | `rust_no_build` | `generated/portable` |
| Portable check | `hxml/portable.hxml` | `portable` | `rust_cargo_subcommand=check` | `generated/portable` |
| Metal codegen | `hxml/metal.codegen.hxml` | `metal` with explicit fallback allowed during scaffold | `rust_no_build` | `generated/metal` |
| Metal check | `hxml/metal.hxml` | `metal` with explicit fallback allowed during scaffold | `rust_cargo_subcommand=check` | `generated/metal` |

## Policy

1. `portable` is the default contract for DTOs, schema fingerprints, config, fixtures, and pure state transitions.
2. `metal` is reserved for runtime shell and native-boundary experiments.
3. `idiomatic` is an output-quality goal for both contracts, not a build profile. Prefer phrases like "idiomatic portable output" or "idiomatic metal output" when describing codegen quality.
4. Codegen-only profiles are for fast local feedback and deterministic generated-output inspection.
5. Check profiles are the first build gate and must succeed before DTO/runtime work is considered active.
6. Locked Cargo checks/tests are run by `scripts/check-generated-cargo.sh`.
7. Generated output remains build output and is ignored by `generated/.gitignore`.

Architecture framing: portable by default, Rust-native by opt-in, metal-like performance whenever haxe.rust can prove Haxe semantics are preserved. In codex-hxrust, start with portable for pure Codex data surfaces; choose metal when the source contract itself needs Rust-native authority, stricter boundary enforcement, async/process integration, or reduced-runtime behavior.

## Scaffold Caveat

The temporary G1 `Main` is intentionally a no-op. Earlier trace/print smoke output pulled in the generated CallStack helper, which currently references a root `Exception` type when this project builds outside the haxe.rust example tree. `HXCX-1.5` owns clean doctor JSON output and should either use a known-good haxe.rust output path or document/file the upstream compiler fix.

## Commands

From ``:

```bash
haxe hxml/portable.codegen.hxml
haxe hxml/portable.hxml
haxe hxml/metal.codegen.hxml
haxe hxml/metal.hxml
scripts/check-generated-cargo.sh
```

Clean generated output after local validation unless a later bead explicitly asks for generated snapshots.
