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
| Total pressure gaps | 21 |
| Resolved upstream | 14 |
| Open upstream | 7 |
| Local workaround | 0 |
| High severity | 7 |
| Medium severity | 14 |
| Raw Rust escape matches in current app/test Haxe source | 0 |
| Haxe source/test files scanned | 613 |

Raw Rust pressure is currently low: no `__rust__`, `rust.metal.Code`, `@:rustAllowRaw`, `@:rust...`, or `untyped` escapes are present under `src` or `test`.

## Source Areas

| Area | Gaps | Notes |
| --- | ---: | --- |
| Build/profile/tooling | 2 | Dev haxelib std ownership and Cargo failure propagation blocked trustworthy profile gates. |
| Protocol/JSON/DTO | 3 | Nullable scalar, generic enum payload, and enum reuse issues surfaced in protocol IDs and JSON helpers. |
| Runtime/model/session | 10 | Try/catch tail returns, interface null behavior, nullable class-array reads, non-copy field assign-op, non-copy local reuse, static final path lowering, Reflect.compare lowering, optional primitive default lowering, and generic helper bound propagation surfaced in runtime/TUI/model-catalog/planning/request-envelope/stream-route/stream-item-reducer/async-contract work. |
| Native metal/std boundary | 4 | Native SQLite persistence pulled in std List/sys.io surfaces and enum payload equality that needed product-neutral runtime support instead of raw Rust expressions. |
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
| Static final class field access path | `open_upstream` | medium | runtime/model/session | Filed as haxe.rust `haxe.rust-3f0g`; local token-usage delivery harness uses a helper function while static getter path lowering is fixed generically. |
| Reflect.compare lowering | `open_upstream` | medium | runtime/model/session | Filed as haxe.rust `haxe.rust-fz20`; local model catalog sort uses direct typed comparison while Reflect.compare lowers generically. |
| Optional primitive constructor default lowering | `open_upstream` | medium | runtime/model/session | Filed as haxe.rust `haxe.rust-3oju`; local model catalog DTO uses an explicit constructor argument while optional default unwrapping lowers generically. |
| Generic helper bound propagation | `open_upstream` | medium | runtime/model/session | Filed as haxe.rust `haxe.rust-akfm`; local async contract uses a typed enum outcome plus direct constructors and concrete fixture summaries while helper bound propagation is fixed generically. |
| `haxe.ds.List.iterator` raw metal fallback | `resolved_upstream` | medium | native metal/std boundary | Resolved by haxe.rust `f1b122b5` with a typed `ListNative` helper and `list_minimal` snapshot. |
| `sys.io.File` raw metal fallback | `resolved_upstream` | medium | native metal/std boundary | Resolved by haxe.rust `f1b122b5` with a typed `file_native` helper and `sys_io` snapshot. |
| `sys.io.FileInput`/`FileOutput` raw metal fallback | `resolved_upstream` | medium | native metal/std boundary | Resolved by haxe.rust `f1b122b5` with typed handle operations and `sys_io` snapshot. |
| Enum class-payload equality through `HxRef` | `resolved_upstream` | medium | native metal/std boundary | Resolved by haxe.rust `4772d6ea` with reference-identity `HxRef<T>` equality and `enum_ref_payload`. |
| `haxe.io.Path.directory` lowering | `resolved_upstream` | medium | Cafex adapter | Resolved by haxe.rust `39f20b9e` with `path_directory`. |
| `String.lastIndexOf` lowering | `resolved_upstream` | medium | Cafex adapter | Resolved by haxe.rust `916f1534` with `string_last_index_of`. |

## Production Readiness Signal

The pressure test is encouraging but not clean enough for broad replacement:

- haxe.rust fixes have been generic and upstreamable so far; `haxe.rust-362`, `haxe.rust-ojj`, `haxe.rust-fzl`, `haxe.rust-3f0g`, `haxe.rust-fz20`, `haxe.rust-3oju`, and `haxe.rust-akfm` are the current open generic regressions from live-runtime/TUI/model-catalog/planning/request-envelope/stream-route/stream-item-reducer/async-contract work.
- The current codexhx source avoids raw Rust escape hatches.
- The native SQLite persistence, state-adapter, persisted read-view, thread/read turn-projection, turns-page, active-turn merge, turn-items unsupported-runtime, token-usage owner, token-usage replay payload, token-usage replay delivery, resume-goal snapshot ordering, resume idle continuation, goal steering, try_start_turn_if_idle admission, goal runtime restore, active-turn goal steering injection, budget-limit goal steering, active-goal progress accounting, idle-goal progress accounting, turn-start accounting, turn finalization, turn-error active-goal stop, goal token-usage contribution, tool-finish goal-progress admission, goal-tool contributor visibility, get_goal/create_goal/update_goal executor, goal-tool dispatch, provider admission, model catalog, turn model/tool planning, model request envelope, model stream route, model stream item reducer/tool input delta/diff consumer/streamed patch parser including sampling error terminal bypass and turn lifecycle, terminal app-server/TUI turn projection, turn replay reconstruction, and pending interactive replay routing, thread snapshot replay dispatch, replayed server-request surface routing, app-server request resolution routing, app-server response dispatch intent, app-server request enqueue routing, app-server queued request delivery, thread buffered request eviction/filtering, thread session-refresh rebase, thread active-turn cache lifecycle, thread side-parent pending status, status-change, and side-thread UI sync, and async runtime contract boundaries compile through haxe.rust after generic std/raw-boundary fixes and the `HxRef<T>` enum-payload equality fix landed upstream.
- Nullable interface values now have a generic upstream fix and passing snapshot.
- String.lastIndexOf now has a generic upstream fix and passing snapshot.
- haxe.io.Path.directory now has a generic upstream fix and passing snapshot.

Feed `HXCX-7.3` with this stance: haxe.rust is viable for the current helper/headless/selected-adapter/thread-read projection, pagination, active-turn merge, unsupported turn-items runtime, token-usage replay, resume-goal snapshot, resume idle continuation, goal steering, try_start_turn_if_idle admission, goal runtime restore, active-turn goal steering injection, budget-limit goal steering, active-goal progress accounting, idle-goal progress accounting, turn-start accounting, turn finalization, turn-error active-goal stop, goal token-usage contribution, tool-finish goal-progress admission, goal-tool contributor visibility, get_goal/create_goal/update_goal executor, goal-tool dispatch, provider admission, model catalog, turn model/tool planning, model request envelope, model stream route, model stream item reducer/tool input delta/diff consumer/streamed patch parser including sampling error terminal bypass and turn lifecycle, terminal app-server/TUI turn projection, turn replay reconstruction, and pending interactive replay routing, thread snapshot replay dispatch, replayed server-request surface routing, app-server request resolution routing, app-server response dispatch intent, app-server request enqueue routing, app-server queued request delivery, thread buffered request eviction/filtering, thread session-refresh rebase, thread active-turn cache lifecycle, thread side-parent pending status, status-change, and side-thread UI sync, and async runtime contract pressure slices, but production readiness still depends on live runtime, the open nullable `Array.shift()`, non-copy field assign-op, non-copy local reuse, static final path, Reflect.compare, optional primitive default, and generic helper bound-propagation regressions, unsupported Cafex seam, licensing, and broader parity work.
