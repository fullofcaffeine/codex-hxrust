#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-json-rpc-thread-read-transport-render
haxe -cp src -cp test -main ResumePickerJsonRpcThreadReadTransportRenderHarness --interp
haxe hxml/resume-picker-json-rpc-thread-read-transport-render.hxml
cargo check --manifest-path generated/resume-picker-json-rpc-thread-read-transport-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-json-rpc-thread-read-transport-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-json-rpc-thread-read-transport-render/Cargo.toml --locked --quiet

echo "Resume picker JSON-RPC thread/read transport render harness passed."
