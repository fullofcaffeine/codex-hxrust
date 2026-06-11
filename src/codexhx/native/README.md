# Native Haxe Facades

This package is reserved for typed Haxe facades and externs that bind to owned Rust wrapper modules in `../../../native/src/`.

Rules:

1. Prefer pure Haxe outside this package.
2. Bind Rust modules with `extern` plus `@:native("crate::module")`.
3. Declare Rust crate dependencies with structured `@:rustCargo`.
4. Convert host errors into typed Haxe results before they reach app-level modules.
5. Keep raw Rust injection out of app code.

The full policy lives in `../../../docs/interop-boundary-policy.md`.
