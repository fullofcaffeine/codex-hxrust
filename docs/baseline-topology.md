# Baseline Topology

**Date:** 2026-06-10  
**Bead:** `HXCX-0.1` / `codex-hxrust-r46.1`  
**Purpose:** Record the upstream Codex, Cafex, and haxe.rust topology facts that the port plan depends on.

## Snapshot Roots

| Snapshot | Local path | Git state | Remote |
| --- | --- | --- | --- |
| Upstream Codex | `../codex` | `main` at `2704ecea9a`; dirty only from untracked repomix outputs | `https://github.com/openai/codex.git` |
| Cafex/Cafetera Codex fork | `../fullofcaffeine/deps/codex` | `caf/mounted/rust-v0.124.0-autonomy` at `d7379d6c66`; clean | `git@github.com:fullofcaffeine/codex-caf.git`, with upstream `https://github.com/openai/codex.git` |
| haxe.rust | `../haxe.rust` | `main` at `0b2f196e2b3e8742efe79febe002e97f0924802d`; clean except untracked `repomix-output.haxe-rust.xml.zip` | `git@github.com:fullofcaffeine/reflaxe.rust.git` |

## Toolchain Facts

Observed local toolchain:

- Haxe: `4.3.7`
- Rust: `rustc 1.96.0 (ac68faa20 2026-05-25) (Homebrew)`
- Cargo: `cargo 1.96.0 (30a34c682 2026-05-25) (Homebrew)`
- Node: `v20.19.3`
- npm: `10.8.2`

The haxe.rust package metadata reports:

- package name: `reflaxe.rust`
- package version: `1.0.0`
- license: `GPL-3.0`
- description: Haxe 4.3.7 Rust compilation target built on Reflaxe

## Upstream Codex Workspace

Source: `../codex/codex-rs/Cargo.toml`

- Workspace member count: `118`
- Workspace package version: `0.0.0`
- Rust edition: `2024`
- Workspace license: `Apache-2.0`
- High-centrality crates for this experiment:
  - `protocol`
  - `app-server-protocol`
  - `app-server`
  - `app-server-transport`
  - `core`
  - `config`
  - `login`
  - `state`
  - `tools`
  - `exec`
  - `sandboxing`
  - `linux-sandbox`
  - `tui`
  - `codex-mcp`
  - `rmcp-client`
  - `utils/absolute-path`
  - `utils/path-utils`
  - `utils/output-truncation`

Protocol source areas to treat as first-class parity inputs:

- `../codex/codex-rs/protocol/src/protocol.rs`
- `../codex/codex-rs/protocol/src/session_id.rs`
- `../codex/codex-rs/protocol/src/thread_id.rs`
- `../codex/codex-rs/protocol/src/config_types.rs`
- `../codex/codex-rs/protocol/src/openai_models.rs`
- `../codex/codex-rs/app-server-protocol/src/lib.rs`
- `../codex/codex-rs/app-server-protocol/src/schema_fixtures.rs`
- `../codex/codex-rs/app-server-protocol/tests/schema_fixtures.rs`

## Cafex Workspace

Source: `../fullofcaffeine/deps/codex/codex-rs/Cargo.toml`

- Workspace member count: `113`
- Workspace package version: `0.135.0`
- Rust edition: `2024`
- Workspace license: `Apache-2.0`
- Cafex-only workspace members relative to current local upstream:
  - `debug-client`
  - `cloud-requirements`
- Current local upstream-only members not present in this Cafex snapshot:
  - `cloud-config`
  - `context-fragments`
  - `ext/image-generation`
  - `ext/mcp`
  - `ext/skills`
  - `prompts`
  - `utils/path-uri`

The count/member delta means the first parity work must compare behavior by selected contract surfaces, not by assuming a one-to-one workspace member map.

## Cafex Runtime Seams Found

Receipt and restart continuity:

- `../fullofcaffeine/deps/codex/codex-rs/core/src/caf_runtime.rs`
- Environment variables:
  - `CAF_CODEX_TURN_RECEIPT_PATH`
  - `CAF_CODEX_SESSION_RECEIPT_PATH`
  - `CAF_CODEX_SUCCESSOR_RUN_ID`
  - `CAF_CODEX_PREDECESSOR_SESSION`
- Functions of interest:
  - `maybe_write_session_receipt`
  - `maybe_write_turn_receipt`

Effort/wake bridge:

- `../fullofcaffeine/deps/codex/codex-rs/tui/src/caf_effort_control.rs`
- Request schema: `cafetera.codex.effort-apply-request.v1`
- Receipt schema: `cafetera.codex.effort-apply.v1`
- Environment variables:
  - `CAF_CODEX_EFFORT_REQUESTS_DIR`
  - `CAF_CODEX_WAKE_REQUESTS_DIR`
  - `CAF_CODEX_EFFORT_RECEIPTS_DIR`
  - `CAF_CODEX_WAKE_RECEIPTS_DIR`
- Behavior notes:
  - request scanning is directory based
  - receipts are written as pretty JSON plus trailing newline
  - duplicate receipts are skipped by existing receipt path
  - non-effort wake request files are ignored by the effort bridge
  - accepted effort requests queue an `UpdateReasoningEffort` app event for the next turn

Goal runtime:

- `../fullofcaffeine/deps/codex/codex-rs/core/src/goals.rs`
- `../fullofcaffeine/deps/codex/codex-rs/state/src/model/thread_goal.rs`
- `../fullofcaffeine/deps/codex/codex-rs/state/src/runtime/goals.rs`
- `../fullofcaffeine/deps/codex/codex-rs/state/src/migrations.rs`
- `../fullofcaffeine/deps/codex/codex-rs/protocol/src/protocol.rs`
- `../fullofcaffeine/deps/codex/codex-rs/app-server-protocol/src/protocol/v2/thread.rs`
- Persistent state filename: `goals_1.sqlite`
- Protocol/app-server methods and notifications include:
  - `thread/goal/set`
  - `thread/goal/get`
  - `thread/goal/clear`
  - `thread/goal/updated`
  - `thread/goal/cleared`

Other Cafex-specific or fork-seam source areas:

- `../fullofcaffeine/deps/codex/codex-rs/core-plugins/src/startup_remote_sync.rs`
- `../fullofcaffeine/deps/codex/codex-rs/config/src/cloud_requirements.rs`
- `../fullofcaffeine/deps/codex/codex-rs/debug-client`

## haxe.rust Capability Facts

Source docs:

- `../haxe.rust/docs/start-here.md`
- `../haxe.rust/docs/profiles.md`
- `../haxe.rust/docs/workflow.md`
- `../haxe.rust/docs/async-await.md`
- `../haxe.rust/docs/interop.md`
- `../haxe.rust/docs/feature-support-matrix.md`

Profile contracts:

- `portable` is the default Haxe-portable contract and should be used first for DTOs, codecs, fixture transforms, schema fingerprints, config/profile data, and pure state transitions.
- `metal` is the Rust-first contract for strict boundaries, performance-sensitive paths, typed native interop, async, process/tool wrappers, and sandbox interfaces.
- `idiomatic` is not a profile selector; it is the generated-Rust quality goal for both `portable` and `metal`.
- `@:haxeMetal` islands can enforce metal-clean checks inside a portable build.
- Architecture framing: portable by default, Rust-native by opt-in, metal-like performance whenever haxe.rust can prove Haxe semantics are preserved.

Build/workflow facts:

- `-D rust_output=...` selects the generated Cargo crate path.
- Cargo builds by default after codegen.
- `-D rust_no_build` / `-D rust_codegen_only` generates Rust without building.
- `-D rust_cargo_subcommand=build|check|test|clippy|run` selects the Cargo action.
- `-D rust_cargo_locked` adds `--locked`.
- Project scaffolds can use `cargo hx --project ... --profile portable|metal --action ...`.

Async facts:

- `rust_async` requires `-D reflaxe_rust_profile=metal`.
- Supported entry pattern is synchronous `main()` calling `Async.blockOn(...)` on an async helper returning `rust.async.Future<T>`.
- `@:rustAsync` / `@:async` is supported on static methods and generated-class instance methods.
- Constructors cannot be async.
- `Async.blockOn(...)` is forbidden inside async functions.

Interop policy facts:

- Preferred Rust interop pattern is typed `extern` plus `@:native(...)` plus copied Rust modules from `-D rust_extra_src=...`.
- Rust dependencies should be declared with `@:rustCargo(...)`.
- `@:rustExtraSrc(...)` can include small native modules.
- App code should avoid raw `__rust__`; raw authority belongs only in narrow framework/bridge modules and remains subject to metal restrictions.

Evidence posture:

- haxe.rust claims support based on CI evidence, not blanket runtime parity.
- Current evidence snapshot lists Tier1 sweep coverage for `96` modules, Tier2 sweep coverage for `224` modules, and `184` portable importable upstream modules covered in Tier2.
- `rust_async` is a supported Rust-first subset on metal + hxrt, not a blanket async/runtime claim.

## Initial Porting Implications

1. Start with protocol DTOs and fixtures, not runtime replacement.
2. Treat `protocol`, `app-server-protocol`, `state`, and Cafex receipt/goal/effort files as the first parity oracle surfaces.
3. Use haxe.rust `portable` for all pure data surfaces until a concrete native/Rust-first need appears.
4. Use haxe.rust `metal` only at explicit runtime boundaries: async model stream, process execution, sandbox policy, apply-patch wrapper, and state backend integration.
5. Treat idiomatic Rust output as a quality bar across both contracts, not as a new build lane.
6. Keep native Rust wrappers small, typed, fail-closed, and fixture-backed.
7. Do not attempt TUI replacement in the first slice; only the effort/wake bridge behavior is relevant to early Cafex parity.

## Licensing Questions

These must remain open until reviewed:

1. Upstream Codex and Cafex workspace package metadata is `Apache-2.0`; haxe.rust package metadata is `GPL-3.0`. Production distribution needs review before any generated/runtime artifacts are shipped.
2. Confirm whether haxe.rust-generated code carries any GPL obligations, and whether the runtime/hxrt components are linked or copied into produced binaries in a way that affects distribution.
3. Confirm whether vendoring haxe.rust as a submodule, subtree, or copied vendor tree changes obligations for Cafetera/Cafex distribution.
4. Confirm whether generated Rust checked into artifacts or releases needs license headers or attribution separate from Haxe source.

## Follow-Up Beads

This inventory directly unblocks:

- `HXCX-0.2` Cafex runtime delta classification
- `HXCX-0.3` fixture inventory
- `HXCX-0.5` repository/module ownership
- `HXCX-0.6` haxe.rust vendoring and upstream update policy
