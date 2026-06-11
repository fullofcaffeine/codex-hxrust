# JSON Boundary Policy

**Date:** 2026-06-10  
**Bead:** `HXCX-2.2` / `codex-hxrust-qml.2`  
**Decision:** Keep JSON parsing at typed boundaries and prevent `Dynamic` from flowing into protocol code.

## Rules

1. Use `haxe.Json.parseValue(text):haxe.json.Value` for parsed JSON.
2. Keep `haxe.Json.parse(text):Dynamic` and `catch (e:Dynamic)` confined to `codexhx.protocol.json`.
3. Convert `haxe.json.Value` to DTO/newtype fields immediately.
4. Return deterministic `JsonError` values with stable `code`, `path`, and `message`.
5. Unknown fields are ignored by DTO decoders by default, but decoders may call `CodexJson.unknownFields(...)` to reject or report them for strict schema gates.
6. JSON object encoding must be deterministic by construction: callers provide field order explicitly.

## Serde Bridge

`codexhx.protocol.json.SerdeBridge` is the Haxe facade for the Rust-side serde/hxrt JSON boundary exposed by haxe.rust. It delegates to `haxe.Json.parseValue` and the deterministic Haxe encoders today. If later DTOs need native serde derives or typed Rust wrappers, they should extend this facade rather than calling raw Rust or `haxe.Json.parse` from app modules.

## Tests

Run:

```bash
harness/check-json-boundary.sh
```

The harness validates:

- typed object field extraction
- deterministic missing/wrong-type errors
- unknown-field reporting
- deterministic object encoding
- haxe.rust generated crate `cargo check --locked`, `cargo test --locked`, and `cargo run --locked`
