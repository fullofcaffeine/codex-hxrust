# Interop Boundary Policy

**Date:** 2026-06-10  
**Bead:** `HXCX-1.4` / `codex-hxrust-wx3.4`  
**Source refs:** `../haxe.rust/docs/interop.md`, `../haxe.rust/docs/metal-profile.md`  
**Decision:** Keep Codex app code pure Haxe and restrict Rust interop to typed, owned boundaries.

## Scope

This policy applies to Haxe source under `src/`, native Rust wrapper source under `native/`, and generated Rust under `generated/`.

Generated Rust is build output and is never edited to satisfy this policy. If generated output needs a change, change Haxe source, wrapper source, haxe.rust configuration, or haxe.rust itself.

## Allowed Interop Mechanisms

Allowed mechanisms, in preference order:

1. Pure Haxe compiled through haxe.rust.
2. Haxe `extern` types bound with `@:native("crate::module")`.
3. Extern fields bound with `@:native("rust_fn_name")`.
4. Declarative Cargo dependencies with structured `@:rustCargo({ name: "...", version: "..." })`.
5. Extra owned Rust modules copied with `-D rust_extra_src=native/src` once the first wrapper exists.
6. Narrow trait implementations with `@:rustImpl` for local Haxe-emitted types when Rust trait conformance is the actual boundary.
7. `rust.metal.Code.expr(...)` or `rust.metal.Code.stmt(...)` only inside a tiny framework/native-lane Haxe module that exposes a typed Haxe API.

The default answer for new app behavior is pure Haxe. Use native Rust only when the required host capability, Rust crate, lifetime shape, or system API cannot be represented cleanly in portable Haxe.

Async host capabilities follow the same rule. Codex-facing Haxe APIs should expose runtime-neutral task/stream/cancel/backpressure abstractions, not Tokio handles or Rust `Future`/`Stream` types directly. Tokio bindings belong behind typed facades or haxe.rust runtime support, with a deterministic fixture backend for tests.

## Raw Rust Ban

App-level Haxe modules must not call raw Rust injection:

- No `untyped __rust__(...)` in `src/codexhx/protocol`, `config`, `runtime`, `state`, `tools`, or `adapters`.
- No raw Rust snippets hidden in business logic helpers.
- No manual edits to `generated/` to patch behavior.
- No `@:rustAllowRaw` in app modules.

If raw snippets are unavoidable, they must live behind a typed wrapper module and need an explicit policy exception. In `metal`, `@:rustAllowRaw` is not a bypass for metal-clean rules, so the preferred escape remains `extern` plus owned Rust source.

## Wrapper Ownership

Every native wrapper needs both sides:

| Side | Location | Responsibility |
| --- | --- | --- |
| Haxe extern/facade | `src/codexhx/native/` | Typed API, validation, structured errors, capability names |
| Rust wrapper | `native/src/` | Host call, crate integration, fail-closed behavior |

Wrapper names should match across Haxe and Rust. Example:

| Capability | Haxe facade | Rust module |
| --- | --- | --- |
| Process execution | `codexhx.native.ProcessBridge` | `native/src/process_bridge.rs` |
| Apply-patch dry run | `codexhx.native.ApplyPatchBridge` | `native/src/apply_patch_bridge.rs` |
| Sandbox inspection | `codexhx.native.SandboxBridge` | `native/src/sandbox_bridge.rs` |

Each wrapper must document:

1. Capability name and owner bead.
2. Whether it is portable, metal-only, or mixed.
3. Allowed inputs and rejected inputs.
4. Error shape returned to Haxe.
5. Fixture or Cargo test coverage.
6. Whether the wrapper can mutate filesystem, process, network, or sandbox state.

## Test Requirements

No wrapper is complete until it has an automated gate:

1. Haxe facade compiles in the relevant profile.
2. Generated crate passes `cargo check --locked`.
3. Generated crate passes `cargo test --locked`.
4. Wrapper-specific Rust tests cover the Rust module when behavior is richer than a direct binding.
5. Haxe fixture tests cover Codex-facing behavior and error mapping.
6. Failure cases are tested before mutation is enabled.

The generated Cargo gate lives at `scripts/check-generated-cargo.sh`.

## Security-Sensitive Wrappers

The following wrapper families are security-sensitive and must fail closed:

| Family | Default before explicit enablement | Examples |
| --- | --- | --- |
| Process execution | Deny execution | Shell commands, tool subprocesses |
| Filesystem mutation | Deny mutation | Write, delete, chmod, patch apply |
| Sandbox/approval policy | Deny escalation | Sandbox override, approval bypass |
| Network | Deny network calls | Provider calls, downloads, MCP transports |
| Credential access | Deny secret reads | API keys, auth tokens, credential stores |
| Persistent state | Deny destructive updates | Session store migration, SQLite writes |

Fail-closed means:

1. Missing capability config returns a structured denial.
2. Unknown enum/permission values are rejected, not coerced.
3. Parse failures reject the operation.
4. Wrapper panics are converted into structured errors before crossing into Codex-facing output.
5. Positive mutation paths need fixture-backed diagnostics and an explicit bead acceptance criterion.

## Dynamic Boundaries

`Dynamic` is allowed only where an upstream Haxe or haxe.rust API requires it, such as the compatibility shape of `haxe.Json.parse`. Convert to typed DTOs immediately at the boundary. Protocol, config, runtime, and tool-state modules should not pass untyped `Dynamic` values inward.

## Review Checklist

Before merging a wrapper or extern:

1. Is the app-level API pure Haxe and typed?
2. Is the Rust code confined to `native/src/` or a haxe.rust framework/runtime layer?
3. Are Cargo dependencies declared with `@:rustCargo` rather than hand-editing generated `Cargo.toml`?
4. Does the wrapper pass generated locked check/test?
5. Do denial/error fixtures exist for security-sensitive behavior?
6. Is generated Rust unchanged by hand?
