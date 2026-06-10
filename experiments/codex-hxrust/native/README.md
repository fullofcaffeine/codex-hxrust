# Native Wrappers

This tree is for narrow Rust wrapper sources used by haxe.rust metal/native boundaries.

The full boundary policy lives in `../../../docs/interop-boundary-policy.md`.

## Layout

```text
native/src/                 Owned Rust wrapper modules
src/codexhx/native/         Typed Haxe facades and externs
generated/                  haxe.rust output; never edit by hand
```

## Rules

1. No native wrapper without a Haxe interface.
2. No raw Rust in app-level Haxe modules.
3. Host effects fail closed by default.
4. Security-sensitive wrappers need fixture-backed diagnostics before mutation is enabled.
5. Cargo dependencies belong in structured `@:rustCargo` metadata on extern/facade types.
6. Wrapper crates must pass `scripts/check-generated-cargo.sh`.
