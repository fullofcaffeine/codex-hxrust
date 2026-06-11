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
cd experiments/codex-hxrust
harness/check-haxe-rust-pressure-gaps.sh
```

## Summary

| Metric | Count |
| --- | ---: |
| Total pressure gaps | 10 |
| Resolved upstream | 8 |
| Open upstream | 0 |
| Local workaround | 2 |
| High severity | 7 |
| Medium severity | 3 |
| Raw Rust escape matches in current app/test Haxe source | 0 |
| Haxe source/test files scanned | 92 |

Raw Rust pressure is currently low: no `__rust__`, `rust.metal.Code`, `@:rustAllowRaw`, `@:rust...`, or `untyped` escapes are present under `experiments/codex-hxrust/src` or `experiments/codex-hxrust/test`.

## Source Areas

| Area | Gaps | Notes |
| --- | ---: | --- |
| Build/profile/tooling | 2 | Dev haxelib std ownership and Cargo failure propagation blocked trustworthy profile gates. |
| Protocol/JSON/DTO | 3 | Nullable scalar, generic enum payload, and enum reuse issues surfaced in protocol IDs and JSON helpers. |
| Runtime/model/session | 3 | Try/catch tail returns and interface null behavior surfaced in mock stream and one-turn state-machine work. |
| Cafex adapter | 2 | Path/string stdlib lowering workarounds remain local until generic haxe.rust repros are filed. |

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
| `haxe.io.Path.directory` lowering | `local_workaround` | medium | Cafex adapter | Generic haxe.rust repro now exists; keep local string/path helpers until `haxe.rust-lj8` closes. |
| `String.lastIndexOf` lowering | `local_workaround` | medium | Cafex adapter | Generic haxe.rust repro now exists; keep forward-scan/helper logic until `haxe.rust-7s4` closes. |

## Production Readiness Signal

The pressure test is encouraging but not clean enough for broad replacement:

- haxe.rust fixes have been generic and upstreamable so far.
- The current codexhx source avoids raw Rust escape hatches.
- Nullable interface values now have a generic upstream fix and passing snapshot.
- Two adapter stdlib-lowering workarounds still have generic expected-failure repros and can be treated as haxe.rust backlog instead of codexhx-only craft.

Feed `HXCX-7.3` with this stance: haxe.rust is viable for the current helper/headless/selected-adapter pressure slices, but production readiness still depends on resolving or explicitly accepting the remaining stdlib-lowering gaps.
