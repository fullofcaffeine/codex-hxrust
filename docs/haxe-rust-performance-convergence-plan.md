# haxe.rust Portable/Metal Performance Convergence Plan

**Date:** 2026-06-11  
**Bead:** `HXCX-7.5` / `codex-hxrust-yt7`  
**Compiler follow-up:** `haxe.rust-oo3.73`

## Purpose

codexhx should keep using haxe.rust as a general compiler pressure test without turning haxe.rust into a Codex-specific backend. This plan defines how codexhx performance pressure becomes generic portable-vs-metal evidence in haxe.rust.

The architecture rule stays:

> Portable by default, Rust-native by opt-in, metal-like performance whenever haxe.rust can prove Haxe semantics are preserved.

`metal` is a near-term Rust-native authoring contract for host/runtime/tool boundaries. It is not the only performance path. `portable` should keep converging toward metal-level Rust performance wherever the compiler can preserve Haxe semantics.

## Benchmark Criteria

Performance claims need representative non-Codex fixtures in haxe.rust, not codexhx-specific fixtures in the compiler.

| Fixture family | Contract default | What it represents | Parity signal |
| --- | --- | --- | --- |
| DTO/codecs | `portable` | typed records, enums, option/result, field validation | generated Rust shape, clone/temp count, cargo check/test |
| JSON/schema validation | `portable` | parse/stringify/validation boundaries with reflection-safe dynamics | existing haxe.rust JSON benchmark and semantic fixtures |
| Pure state reducers | `portable` | deterministic state transitions without host effects | portable/metal runtime ratio on hot state loops |
| Process/tool boundary facades | `metal` first | host process execution, path/env/stdout/stderr ownership | no raw app injection, typed boundary shape, later portable facade if semantics permit |
| Async/runtime surfaces | `metal` first | futures, cancellation, stream lifecycle, event loops | metal generated Rust behavior and no-runtime lower-bound where applicable |
| Native persistence boundaries | `metal` first | SQLite/filesystem locking/migration/error mapping | typed boundary correctness before performance claims |

Use haxe.rust's existing artifact policy where possible:

- `scripts/ci/perf-hxrt-overhead.sh`
- `comparison.json`
- `current.json`
- `summary.md`
- committed baseline updates with reviewed sampling changes

Initial convergence thresholds should follow haxe.rust defaults unless a fixture justifies a stricter or looser budget:

- hot/pure state portable vs metal: target `<= 1.05x` once the benchmark is stable
- bytes/stdlib-heavy portable vs metal: target `<= 1.08x`
- JSON portable vs metal: target `<= 1.12x`, with JSON-specific semantic coverage required before optimization
- startup-only examples: report size/runtime, but avoid hard runtime claims
- `Int64`-style portability-cost trackers: keep visible, but do not treat as near-native KPIs

## codexhx Profile Use

Keep these codexhx slices portable-first:

- protocol IDs, DTOs, and app-server request/response/notification payloads
- codecs, fixtures, schema fingerprints, and schema/protocol validation
- config/profile parsing and redacted diagnostics
- pure state transitions, transcript/state summaries, goal DTOs, and deterministic test harness state
- JSONL fixture adapters while they remain credential-free and host-effect-free

Use `metal` now where codexhx needs Rust-native behavior or production-shaped host boundaries:

- process/tool execution wrappers
- sandbox and filesystem enforcement wrappers
- live app-server transport, stream/cancellation, and async runtime ownership
- native persistence boundaries such as SQLite/sqlx, locking, migration, backup, and corruption recovery
- reduced/no-HXRT runtime experiments and measured hot paths that cannot yet be represented cleanly in portable

Mixed slices should split the contract at the boundary. The semantic DTO/config/state layer stays portable; the host-effect wrapper can be metal. If a slice uses metal mainly because portable output is currently too slow or awkward, reduce that pressure to a generic haxe.rust fixture and file or link a haxe.rust Bead.

## Follow-Up Links

Existing haxe.rust evidence to reuse:

- `haxe.rust-qo9`: portable performance convergence epic
- `haxe.rust-oo3.24`: JSON boundary convergence milestone
- `haxe.rust-oo3.25.1`: portable near-native guidance
- `haxe.rust-oo3.36`: later JSON boundary convergence and clone-elision deferral

New generic haxe.rust follow-up:

- `haxe.rust-oo3.73`: define a consumer-runtime portable/metal benchmark corpus without downstream project names or assumptions

No Codex-specific compiler behavior is permitted. Any future compiler change must be justified by a generic Haxe fixture, semantic contract, and haxe.rust-owned test or benchmark.

## Decision Rule

When codexhx exposes a performance or code-shape gap:

1. Decide whether the codexhx source contract is portable-first or Rust-native.
2. If it is Rust-native, use `metal` and keep the boundary typed.
3. If it is portable-first, check whether haxe.rust can preserve Haxe semantics while lowering to a cheaper Rust shape.
4. If yes, reduce to a generic haxe.rust fixture/benchmark and link it from codexhx Beads.
5. If no, document the semantic reason and keep the portable fallback honest.

This keeps codexhx productive now while pushing haxe.rust toward the long-term target: portable Haxe source that emits Rust as close to metal as semantics allow.
