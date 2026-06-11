# codex-hxrust Experiment

This directory is the Haxe-authored, Rust-emitted Codex port experiment.

## Source-Of-Truth Rules

1. Mainstream upstream Codex is the core baseline.
   - Pin: `../../reference/upstream-codex.pin.json`
   - Local source: `../../../codex`
2. Cafex/Cafetera is a later adapter/conformance layer.
   - Pin: `../../reference/cafex-codex.pin.json`
   - Local source: `../../../fullofcaffeine/deps/codex`
   - Cafetera module fixtures: `../../../fullofcaffeine/tools/cafetera/modules/codex/tests`
3. haxe.rust is an external pinned compiler/runtime checkout for G1.
   - Pin: `../../reference/haxe-rust.pin.json`
   - Local source: `../../../haxe.rust`
4. Haxe source under `src/` is authoritative for this experiment.
5. Generated Rust under `generated/` is build output and should not be edited by hand.
6. Native Rust under `native/` is allowed only for narrow typed wrapper boundaries.

## Layout

```text
hxml/                    Haxe build profiles and task files
src/Main.hx              Temporary scaffold entrypoint
src/codexhx/             Haxe source for upstream-shaped Codex core
src/codexhx/native/      Typed Haxe facades for owned Rust wrappers
src/codexhx/adapters/    Later adapter modules; Cafex lives here, not in core
native/src/              Narrow Rust wrapper sources for metal/native boundaries
fixtures/upstream/       Copied upstream fixture subset, once selected
fixtures/cafex/          Copied Cafex adapter fixture subset, once M5 begins
fixtures/hxrust/         haxe.rust capability fixtures, if needed
harness/                 Fixture runner specs and scripts
generated/               Rust output from haxe.rust
```

## Current Scaffold

This G1 scaffold is intentionally tiny. It provides:

- Haxe source tree
- native wrapper tree
- fixtures tree
- harness tree
- portable and metal hxml seeds
- minimal root `Main` doctor entrypoint
- protocol ID and JSON boundary harnesses
- config/profile DTO subset harness
- app-server protocol request/response/notification subset harness
- upstream schema fingerprint drift gate
- headless JSONL adapter harness for start/submit/status/transcript commands

`HXCX-1.2` owns making portable and metal profile checks green. `HXCX-1.3` owns the generated Cargo gate script for locked checks/tests. `HXCX-1.5` owns the minimal doctor JSON binary and shape harness. `HXCX-2.x` owns upstream-shaped protocol, JSON, config, and runtime DTO slices.

Native interop rules are documented in `../../docs/interop-boundary-policy.md`: app code stays pure Haxe; owned Rust wrappers require typed Haxe facades and fail-closed tests.

## Expected First Commands

From this directory, once haxe.rust is available to Haxe:

```bash
npx haxe hxml/portable.codegen.hxml
npx haxe hxml/portable.hxml
npx haxe hxml/metal.codegen.hxml
npx haxe hxml/metal.hxml
scripts/check-generated-cargo.sh
harness/check-doctor-json.sh
harness/check-protocol-ids.sh
harness/check-json-boundary.sh
harness/check-config-profile.sh
harness/check-app-protocol.sh
harness/check-schema-fingerprints.sh
harness/check-headless-jsonl-adapter.sh
```

The `*.codegen.hxml` files use `-D rust_no_build`; the main profile hxmls run haxe.rust's first `cargo check`; the script regenerates both crates and then runs locked Cargo checks/tests.
