# haxe.rust Pressure Gap Ledger

**Date:** 2026-06-11
**Bead:** `HXCX-7.1` / `codex-hxrust-rat.1`
**Decision feed:** `HXCX-7.3`

## Purpose

This ledger captures compiler/runtime/interop gaps discovered while codexhx pressured haxe.rust with Codex-shaped protocol, runtime, tool, and Cafex adapter code.

Machine-readable fixture:

`reference/haxe-rust-pressure-gaps.v1.json`

Follow-up upstream repro map:

`reference/haxe-rust-upstream-repros.v1.json`

Validation gate:

```bash
harness/check-haxe-rust-pressure-gaps.sh
```

## Summary

| Metric | Count |
| --- | ---: |
| Total pressure gaps | 13 |
| Resolved upstream | 10 |
| Open upstream | 3 |
| Local workaround | 0 |
| High severity | 7 |
| Medium severity | 6 |
| Raw Rust escape matches in current app/test Haxe source | 0 |
| Haxe source/test files scanned | 152 |

Raw Rust pressure is currently low: no `__rust__`, `rust.metal.Code`, `@:rustAllowRaw`, `@:rust...`, or `untyped` escapes are present under `src` or `test`.

## Source Areas

| Area | Gaps | Notes |
| --- | ---: | --- |
| Build/profile/tooling | 2 | Dev haxelib std ownership and Cargo failure propagation blocked trustworthy profile gates. |
| Protocol/JSON/DTO | 3 | Nullable scalar, generic enum payload, and enum reuse issues surfaced in protocol IDs and JSON helpers. |
| Runtime/model/session | 6 | Try/catch tail returns, interface null behavior, nullable class-array reads, non-copy field assign-op, and non-copy local reuse surfaced in runtime/TUI work. |
| Cafex adapter | 2 | Path.directory and String.lastIndexOf are now resolved upstream. |

## Gap List

| Gap | Status | Severity | Source area | Workaround / resolution |
| --- | --- | --- | --- | --- |
| CallStack exception dev haxelib std ownership | `resolved_upstream` | high | build/profile/tooling | Resolved by haxe.rust `0849fcf1`; local Dynamic workaround removed. |
| Cargo failure exit status | `resolved_upstream` | high | build/profile/tooling | Resolved by haxe.rust `bc945b32`; Cargo handoff failures now make Haxe fail. |
| Nullable scalar and `charCodeAt` lowering | `resolved_upstream` | medium | protocol/JSON/DTO | Resolved by haxe.rust `72959949` with `nullable_scalar_charcode`. |
| Generic enum payloads | `resolved_upstream` | high | protocol/JSON/DTO | Resolved by haxe.rust `f521fdb2` with `generic_enum_payload`. |
| Enum reuse across helper calls | `resolved_upstream` | high | protocol/JSON/DTO | Resolved by haxe.rust `1a394f41` with `enum_reuse_helper_calls`. |
| Try/catch tail return lowering | `resolved_upstream` | high | runtime/model/session | Resolved by haxe.rust `551a00bf`; local parseJson shape workaround removed. |
| Interface null comparison | `resolved_upstream` | high | runtime/model/session | Resolved by haxe.rust `e10eae4d` with `interface_null_compare`. |
| Nullable interface values | `resolved_upstream` | high | runtime/model/session | Resolved by haxe.rust `b3e38c31` with `nullable_interface_null`. |
| Nullable `Array<Class>.shift()` return | `open_upstream` | medium | runtime/model/session | Filed as haxe.rust `haxe.rust-362`; local runtime queue uses a typed read outcome while the compiler regression is fixed generically. |
| Non-copy class field assign-op | `open_upstream` | medium | runtime/model/session | Filed as haxe.rust `haxe.rust-ojj`; local TUI story summary uses explicit `field = field + value` while compiler support is fixed generically. |
| Reused non-copy local conditional results | `open_upstream` | medium | runtime/model/session | Filed as haxe.rust `haxe.rust-fzl`; local turn reducer uses explicit Haxe string slices while clone insertion is fixed generically. |
| `haxe.io.Path.directory` lowering | `resolved_upstream` | medium | Cafex adapter | Resolved by haxe.rust `39f20b9e` with `path_directory`. |
| `String.lastIndexOf` lowering | `resolved_upstream` | medium | Cafex adapter | Resolved by haxe.rust `916f1534` with `string_last_index_of`. |

## Production Readiness Signal

The pressure test is encouraging but not clean enough for broad replacement:

- haxe.rust fixes have been generic and upstreamable so far; `haxe.rust-362`, `haxe.rust-ojj`, and `haxe.rust-fzl` are the current open generic regressions from live-runtime/TUI work.
- The current codexhx source avoids raw Rust escape hatches.
- Nullable interface values now have a generic upstream fix and passing snapshot.
- String.lastIndexOf now has a generic upstream fix and passing snapshot.
- haxe.io.Path.directory now has a generic upstream fix and passing snapshot.

Feed `HXCX-7.3` with this stance: haxe.rust is viable for the current helper/headless/selected-adapter pressure slices, but production readiness still depends on live runtime, the open nullable `Array.shift()`, non-copy field assign-op, and non-copy local reuse regressions, unsupported Cafex seam, licensing, and broader parity work.
