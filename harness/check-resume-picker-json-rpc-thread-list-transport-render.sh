#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-json-rpc-thread-list-transport-render
haxe -cp src -cp test -main ResumePickerJsonRpcThreadListTransportRenderHarness --interp
haxe hxml/resume-picker-json-rpc-thread-list-transport-render.hxml
cargo check --manifest-path generated/resume-picker-json-rpc-thread-list-transport-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-json-rpc-thread-list-transport-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-json-rpc-thread-list-transport-render/Cargo.toml --locked --quiet

echo "Resume picker JSON-RPC thread/list transport render harness passed."
